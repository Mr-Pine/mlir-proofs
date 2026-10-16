module

public import Firedancer.Leaders.Bits

/-! The stake-weight records, the `fd_sort.c` in-place sort (`util/tmpl/fd_sort.c`) with the
comparators the schedule's input goes through, `fd_stake_weights_by_node`'s sort step
(`flamenco/stakes/fd_stakes.c`) and `compute_id_weights_from_vote_weights`
(`flamenco/leaders/fd_leaders.c`). -/

namespace Firedancer.Leaders

@[expose] public section

/-- `MAX_STAKE_WEIGHTS` (`flamenco/leaders/fd_leaders_base.h:10`). -/
def MAX_STAKE_WEIGHTS : BitVec 64 := 2000#64

/-- `struct fd_stake_weight` (`flamenco/stakes/fd_stake_weight.h:8`). -/
structure fd_stake_weight_t where
  key : fd_pubkey_t
  stake : BitVec 64
deriving Repr, DecidableEq, Inhabited

/-- `struct fd_vote_stake_weight` (`flamenco/stakes/fd_stake_weight.h:14`). -/
structure fd_vote_stake_weight_t where
  vote_key : fd_pubkey_t
  id_key : fd_pubkey_t
  stake : BitVec 64
  bls_key : Vector (BitVec 8) 48
deriving Repr, DecidableEq, Inhabited

/-! ## `fd_sort.c`

Generic in `SORT_BEFORE` (`before`) and `SORT_KEY_T` (`α`); `SORT_IDX_T` is `ulong` and the
thresholds are the defaults (`SORT_QUICK_THRESH = 32`, `SORT_QUICK_ORDER_STYLE = 0`,
`SORT_QUICK_SWAP_MINIMIZE = 0`). `key` is the whole C array; reads past it give `default` and
writes past it are dropped (never reached: every index is in `[l,h) ⊆ [0,cnt)`). -/

/-- `SORT_QUICK_THRESH` (`util/tmpl/fd_sort.c:161`). -/
def SORT_QUICK_THRESH : BitVec 64 := 32#64

/-- The `while( j )` loop of `SORT_(insert)` (`util/tmpl/fd_sort.c:458`) on `key+off`: the
array and the final `j`. -/
def fd_sort_insert.inner {α : Type} [Inhabited α] (before : α → α → Bool) (off : Nat)
    (key_i : α) : Array α → Nat → Array α × Nat
  | key, 0 => (key, 0)
  | key, j + 1 =>
    let k := j
    let key_j := key[off + k]!
    if !(before key_i key_j) then (key, j + 1)
    else fd_sort_insert.inner before off key_i (key.set! (off + (j + 1)) key_j) k

/-- `for( i=1; i<cnt; i++ )` of `SORT_(insert)` (`util/tmpl/fd_sort.c:455`). -/
def fd_sort_insert.outer {α : Type} [Inhabited α] (before : α → α → Bool) (off cnt : Nat)
    (key : Array α) (i : Nat) : Array α :=
  if i < cnt then
    let key_i := key[off + i]!
    let (key, j) := fd_sort_insert.inner before off key_i key i
    fd_sort_insert.outer before off cnt (key.set! (off + j) key_i) (i + 1)
  else key
termination_by cnt - i

/-- `SORT_(insert)( key+off, cnt )` (`util/tmpl/fd_sort.c:453`): insertion sort. -/
def fd_sort_insert.spec {α : Type} [Inhabited α] (before : α → α → Bool) (key : Array α)
    (off cnt : BitVec 64) : Array α :=
  fd_sort_insert.outer before off.toNat cnt.toNat key 1

/-- `ORDER(k0,k1)` (`util/tmpl/fd_sort.c:595`): swap when `SORT_BEFORE(k1,k0)`. -/
def fd_sort_order {α : Type} (before : α → α → Bool) (k0 k1 : α) : α × α :=
  if before k1 k0 then (k1, k0) else (k0, k1)

/-- The three-way partition `do { ... } while( j<=k )` of `SORT_(private_quick)`
(`util/tmpl/fd_sort.c:609-637`): `(key, i, j, k)` after, given `fuel` iterations. -/
def fd_sort_private_quick.partition {α : Type} [Inhabited α] (before : α → α → Bool)
    (p1 p2 : α) : Nat → Array α → BitVec 64 → BitVec 64 → BitVec 64 →
    Fueled (Array α × BitVec 64 × BitVec 64 × BitVec 64)
  | 0, _, _, _, _ => .outOfFuel
  | fuel + 1, key, i, j, k =>
    let kj := key[j.toNat]!
    let to_left := before kj p1
    let to_right := before p2 kj
    let m := if to_right then k else if to_left then i else j
    let key := key.set! j.toNat key[m.toNat]!
    let key := key.set! m.toNat kj
    let i := i + (if to_left then 1#64 else 0#64)
    let j := j + (if to_right then 0#64 else 1#64)
    let k := k - (if to_right then 1#64 else 0#64)
    if j ≤ k then fd_sort_private_quick.partition before p1 p2 fuel key i j k
    else .done (key, i, j, k)

/-- The `retry:` block of `SORT_(private_quick)` (`util/tmpl/fd_sort.c:609-713`) on `[l,h)`;
each `goto retry` takes one `fuel`. -/
def fd_sort_private_quick.retry {α : Type} [Inhabited α] (before : α → α → Bool)
    (l h n : BitVec 64) : Nat → α → α → Array α → Array (BitVec 64) →
    Fueled (Array α × Array (BitVec 64))
  | 0, _, _, _, _ => .outOfFuel
  | fuel + 1, p1, p2, key, stack => do
    let (key, i, j, _k) ←
      fd_sort_private_quick.partition before p1 p2 (n.toNat + 1) key l l (h - 1#64)
    if j - i = n then
      if before p1 p2 then fd_sort_private_quick.retry before l h n fuel p2 p2 key stack
      else .done (key, stack)
    else
      let left_larger := (i - l) > (h - j)
      let l_larger := if left_larger then l else j
      let h_larger := if left_larger then i else h
      let l_smaller := if left_larger then j else l
      let h_smaller := if left_larger then h else i
      let push_smaller := l_smaller < h_smaller
      let push_center := before p1 p2
      let stack := (stack.push l_larger).push h_larger
      let stack := if push_center then (stack.push i).push j else stack
      let stack := if push_smaller then (stack.push l_smaller).push h_smaller else stack
      .done (key, stack)

/-- The `for(;;)` loop of `SORT_(private_quick)` (`util/tmpl/fd_sort.c:554`) with `fuel`
iterations; `stack` is the used part of the C `stack`. -/
def fd_sort_private_quick.loop {α : Type} [Inhabited α] (before : α → α → Bool) :
    Nat → Array α → Array (BitVec 64) → Fueled (Array α)
  | 0, _, _ => .outOfFuel
  | fuel + 1, key, stack =>
    if stack.size = 0 then .done key else
    let h := stack.back!
    let stack := stack.pop
    let l := stack.back!
    let stack := stack.pop
    let n := h - l
    if n ≤ SORT_QUICK_THRESH then
      fd_sort_private_quick.loop before fuel (fd_sort_insert.spec before key l n) stack
    else
      let n3 := n / 3#64
      let h1 := h - 1#64
      let p0 := key[l.toNat]!
      let p1 := key[(l + n3).toNat]!
      let p2 := key[(h1 - n3).toNat]!
      let p3 := key[h1.toNat]!
      let (p0, p2) := fd_sort_order before p0 p2
      let (p1, p3) := fd_sort_order before p1 p3
      let (_p0, p1) := fd_sort_order before p0 p1
      let (p2, _p3) := fd_sort_order before p2 p3
      let (p1, p2) := fd_sort_order before p1 p2
      match fd_sort_private_quick.retry before l h n fuel p1 p2 key stack with
      | .outOfFuel => .outOfFuel
      | .done (key, stack) => fd_sort_private_quick.loop before fuel key stack

/-- `SORT_(inplace)` = `SORT_(private_quick)` (`util/tmpl/fd_sort.c:287`, `:547`) on
`key[0,cnt)`, with fuel `8*cnt+8` (see `TRANSLATION.md`). -/
def fd_sort_inplace.spec {α : Type} [Inhabited α] (before : α → α → Bool) (key : Array α)
    (cnt : BitVec 64) : Fueled (Array α) :=
  fd_sort_private_quick.loop before (8 * cnt.toNat + 8) key #[0#64, cnt]

/-! ## Comparators -/

/-- `SORT_BEFORE` of `sort_vote_weights_by_stake_vote`
(`flamenco/stakes/fd_stake_weight_sort.h:17`): stake descending, then vote key descending. -/
def sort_vote_weights_by_stake_vote.before (a b : fd_vote_stake_weight_t) : Bool :=
  if a.stake > b.stake then true else if a.stake < b.stake then false
  else memcmp a.vote_key b.vote_key > 0

/-- `SORT_BEFORE` of `sort_weights_by_stake_id` (`flamenco/leaders/fd_leaders.c:17`). -/
def sort_weights_by_stake_id.before (a b : fd_stake_weight_t) : Bool :=
  if a.stake > b.stake then true else if a.stake < b.stake then false
  else memcmp a.key b.key > 0

/-- `SORT_BEFORE` of `sort_weights_by_id` (`flamenco/leaders/fd_leaders.c:22`): key
descending. -/
def sort_weights_by_id.before (a b : fd_stake_weight_t) : Bool :=
  memcmp a.key b.key > 0

/-! ## Callers -/

/-- What `fd_stake_weights_by_node` produces: `logErr` for a failed `FD_TEST` (process exit),
`outOfFuel` from the sort, or the weights and their count. -/
inductive fd_stake_weights_by_node.Result where
  | logErr
  | outOfFuel
  | ok (weights : Array fd_vote_stake_weight_t) (weights_cnt : BitVec 64)
deriving Repr, DecidableEq

/-- `fd_stake_weights_by_node` (`flamenco/stakes/fd_stakes.c:459`) on the records the
vote-stakes iterator yields, in order. -/
def fd_stake_weights_by_node.spec (elems : Array fd_vote_stake_weight_t) :
    fd_stake_weights_by_node.Result :=
  if elems.size ≥ MAX_STAKE_WEIGHTS.toNat + 1 then .logErr
  else
    let weights_cnt := BitVec.ofNat 64 elems.size
    match fd_sort_inplace.spec sort_vote_weights_by_stake_vote.before elems weights_cnt with
    | .outOfFuel => .outOfFuel
    | .done weights => .ok weights weights_cnt

/-- The dedup loop of `compute_id_weights_from_vote_weights` (`flamenco/leaders/fd_leaders.c:43`):
the array and the final `j`. -/
def compute_id_weights_from_vote_weights.dedup (idx : Nat) (sw : Array fd_stake_weight_t)
    (i j : Nat) : Array fd_stake_weight_t × Nat :=
  if i < idx then
    if memcmp sw[j]!.key sw[i]!.key = 0 then
      compute_id_weights_from_vote_weights.dedup idx
        (sw.modify j fun e => { e with stake := e.stake + sw[i]!.stake }) (i + 1) j
    else
      let j := j + 1
      let sw := sw.modify j fun e => { e with stake := sw[i]!.stake }
      let sw := sw.modify j fun e => { e with key := sw[i]!.key }
      compute_id_weights_from_vote_weights.dedup idx sw (i + 1) j
  else (sw, j)
termination_by idx - i

/-- `compute_id_weights_from_vote_weights` (`flamenco/leaders/fd_leaders.c:26`):
`stake_weight[0, staked_cnt)` after, and the return. -/
def compute_id_weights_from_vote_weights.spec (vote_stake_weight : Array fd_vote_stake_weight_t)
    (staked_cnt : BitVec 64) : Fueled (Array fd_stake_weight_t × BitVec 64) := do
  let idx := staked_cnt.toNat
  let sw : Array fd_stake_weight_t := (Array.range idx).map fun i =>
    { key := vote_stake_weight[i]!.id_key, stake := vote_stake_weight[i]!.stake }
  let sw ← fd_sort_inplace.spec sort_weights_by_id.before sw staked_cnt
  let (sw, j) := compute_id_weights_from_vote_weights.dedup idx sw 1 0
  let staked_cnt_by_id := fd_ulong_min.spec staked_cnt (BitVec.ofNat 64 j + 1#64)
  let sw ← fd_sort_inplace.spec sort_weights_by_stake_id.before sw staked_cnt_by_id
  return (sw, staked_cnt_by_id)

end

end Firedancer.Leaders

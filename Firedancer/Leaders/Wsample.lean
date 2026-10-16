module

public import Firedancer.Leaders.ChachaRng

/-! `ballet/wsample/fd_wsample.c`: the radix-9 weighted sampler, on the paths the leader
schedule reaches (`new_init/add/fini`, `sample`) plus `footprint` and `seed_rng`. The sampler's
`rng` pointer is not a field: functions that use it take and return the RNG. -/

namespace Firedancer.Leaders

@[expose] public section

/-- `R` (`ballet/wsample/fd_wsample.c:7`). -/
def R : BitVec 64 := 9#64

/-- `INT_MAX`. -/
def INT_MAX : BitVec 64 := 0x7FFFFFFF#64

/-- `FD_WSAMPLE_ALIGN` (`ballet/wsample/fd_wsample.h:26`). -/
def FD_WSAMPLE_ALIGN : BitVec 64 := 64#64

/-- `FD_WSAMPLE_EMPTY` (`ballet/wsample/fd_wsample.h:173`): `UINT_MAX` as a `ulong`. -/
def FD_WSAMPLE_EMPTY : BitVec 64 := 0xFFFFFFFF#64

/-- `FD_WSAMPLE_INDETERMINATE` (`ballet/wsample/fd_wsample.h:174`): `UINT_MAX-1UL`. -/
def FD_WSAMPLE_INDETERMINATE : BitVec 64 := 0xFFFFFFFE#64

/-- `FD_WSAMPLE_HINT_POWERLAW_NOREMOVE` (`ballet/wsample/fd_wsample.h:77`). -/
def FD_WSAMPLE_HINT_POWERLAW_NOREMOVE : BitVec 32 := 2#32

/-- `tree_ele_t` (`ballet/wsample/fd_wsample.c:98`), by its `ulong left_sum[R-1]`. -/
abbrev tree_ele_t := Vector (BitVec 64) 8

/-- `sizeof(tree_ele_t)`. -/
def sizeof_tree_ele_t : BitVec 64 := 64#64

/-- `sizeof(fd_wsample_t)`: 64 bytes of fields and the 64-byte `dummy`. -/
def sizeof_fd_wsample_t : BitVec 64 := 128#64

/-- `struct fd_wsample_private` (`ballet/wsample/fd_wsample.c:105`) without `rng` and `dummy`;
`tree_copy` is the restore copy (empty until written). -/
structure fd_wsample_t where
  total_cnt : BitVec 64
  total_weight : BitVec 64
  unremoved_cnt : BitVec 64
  unremoved_weight : BitVec 64
  internal_node_cnt : BitVec 64
  poisoned_weight : BitVec 64
  height : BitVec 32
  restore_enabled : BitVec 8
  poisoned_mode : BitVec 8
  tree : Array tree_ele_t
  tree_copy : Array tree_ele_t
deriving Repr, DecidableEq, Inhabited

theorem compute_height.mul_R {leaf powRh : BitVec 64} (h1 : leaf < INT_MAX) (h2 : powRh < leaf) :
    (powRh * R).toNat = powRh.toNat * 9 := by
  simp only [R, INT_MAX] at *
  rw [BitVec.lt_def] at h1 h2
  rw [BitVec.toNat_mul, Nat.mod_eq_of_lt] <;> simp at * <;> omega

/-- `while( leaf_cnt>powRh )` of `compute_height` (`ballet/wsample/fd_wsample.c:173`);
`leaf_cnt < INT_MAX` keeps `powRh*R` from wrapping. -/
def compute_height.loop (leaf_cnt : BitVec 64) (hleaf : leaf_cnt < INT_MAX)
    (height internal powRh : BitVec 64) (hpos : 0#64 < powRh) : BitVec 64 × BitVec 64 :=
  if hlt : leaf_cnt > powRh then
    compute_height.loop leaf_cnt hleaf (height + 1#64) (internal + powRh) (powRh * R)
      (by rw [BitVec.lt_def, compute_height.mul_R hleaf hlt]; rw [BitVec.lt_def] at hpos
          simp at *; omega)
  else (height, internal)
termination_by leaf_cnt.toNat - powRh.toNat
decreasing_by
  rw [compute_height.mul_R hleaf hlt]; have := BitVec.lt_def.mp hlt; rw [BitVec.lt_def] at hpos
  simp at *; omega

/-- `compute_height` (`ballet/wsample/fd_wsample.c:162`): `some (height, internal)`, or
`none` for the `-1` return (out-params unwritten). -/
def compute_height.spec (leaf_cnt : BitVec 64) : Option (BitVec 64 × BitVec 64) :=
  if h : leaf_cnt ≥ INT_MAX then none
  else some (compute_height.loop leaf_cnt (by bv_omega) 0#64 0#64 1#64 (by decide))

/-- `fd_wsample_footprint` (`ballet/wsample/fd_wsample.c:184`). -/
def fd_wsample_footprint.spec (ele_cnt : BitVec 64) (restore_enabled : BitVec 32) : BitVec 64 :=
  match compute_height.spec ele_cnt with
  | none => 0#64
  | some (_height, internal_cnt) =>
    sizeof_fd_wsample_t +
      ((if restore_enabled ≠ 0#32 then 2#64 else 1#64) * internal_cnt + 1#64) * sizeof_tree_ele_t

/-- `FD_WSAMPLE_FOOTPRINT` (`ballet/wsample/fd_wsample.h:29`), `restore_enabled` a C truth
value. -/
def FD_WSAMPLE_FOOTPRINT (ele_cnt : BitVec 64) (restore_enabled : Bool) : BitVec 64 :=
  192#64 + 64#64 * (if restore_enabled then 2#64 else 1#64) * (
    if ele_cnt ≤ 1#64 then 0#64 else
    if ele_cnt ≤ 9#64 then 1#64 else
    if ele_cnt ≤ 81#64 then 10#64 else
    if ele_cnt ≤ 729#64 then 91#64 else
    if ele_cnt ≤ 6561#64 then 820#64 else
    if ele_cnt ≤ 59049#64 then 7381#64 else
    if ele_cnt ≤ 531441#64 then 66430#64 else
    if ele_cnt ≤ 4782969#64 then 597871#64 else
    if ele_cnt ≤ 43046721#64 then 5380840#64 else
    if ele_cnt ≤ 387420489#64 then 48427561#64 else 435848050#64)

/-- `fd_wsample_join` (`ballet/wsample/fd_wsample.c:197`) on the pointer `shmem` to `sampler`
(`none` = `NULL`). -/
def fd_wsample_join.spec (shmem : BitVec 64) (sampler : Option fd_wsample_t) :
    Option fd_wsample_t :=
  if shmem = 0#64 then none
  else if fd_ulong_is_aligned.spec shmem 64#64 = 0#32 then none
  else sampler

/-- `fd_wsample_new_init` (`ballet/wsample/fd_wsample.c:272`) at address `shmem`; `none` =
`NULL`. -/
def fd_wsample_new_init.spec (shmem : BitVec 64) (ele_cnt : BitVec 64)
    (restore_enabled : BitVec 32) (_opt_hint : BitVec 32) : Option fd_wsample_t :=
  if shmem = 0#64 then none
  else if fd_ulong_is_aligned.spec shmem 64#64 = 0#32 then none
  else match compute_height.spec ele_cnt with
  | none => none
  | some (height, internal_cnt) =>
    some { total_cnt := 0#64, total_weight := 0#64, unremoved_cnt := 0#64,
           unremoved_weight := 0#64, internal_node_cnt := internal_cnt, poisoned_weight := 0#64,
           height := height.setWidth 32,
           restore_enabled := if restore_enabled ≠ 0#32 then 1#8 else 0#8,
           poisoned_mode := 0#8,
           tree := Array.replicate internal_cnt.toNat (Vector.replicate 8 0#64),
           tree_copy := #[] }

/-- `for( ulong k=child_idx; k<R-1UL; k++ ) tree[ parent ].left_sum[ k ] += weight;`
(`ballet/wsample/fd_wsample.c:335`) on one node. -/
def fd_wsample_new_add.inner (weight : BitVec 64) (e : tree_ele_t) (k : Nat) : tree_ele_t :=
  if h : k < 8 then fd_wsample_new_add.inner weight (e.set k (e[k] + weight)) (k + 1)
  else e
termination_by 8 - k

/-- `for( ulong h=0UL; h<sampler->height; h++ )` of `fd_wsample_new_add`
(`ballet/wsample/fd_wsample.c:332`), `rem = height - h`; a `parent` past `tree` is skipped. -/
def fd_wsample_new_add.loop (weight : BitVec 64) :
    Nat → Array tree_ele_t → BitVec 64 → Array tree_ele_t
  | 0, tree, _ => tree
  | rem + 1, tree, i =>
    let parent := (i - 1#64) / R
    let child_idx := i - 1#64 - R * parent
    let tree := tree.modify parent.toNat fun e => fd_wsample_new_add.inner weight e child_idx.toNat
    fd_wsample_new_add.loop weight rem tree parent

/-- `fd_wsample_new_add` (`ballet/wsample/fd_wsample.c:315`); `none` = `NULL`, in and out. -/
def fd_wsample_new_add.spec (shmem : Option fd_wsample_t) (weight : BitVec 64) :
    Option fd_wsample_t :=
  match shmem with
  | none => none
  | some sampler =>
    if weight = 0#64 then none
    else if sampler.total_weight + weight < weight then none
    else
      let i := sampler.internal_node_cnt + sampler.unremoved_cnt
      let tree := fd_wsample_new_add.loop weight sampler.height.toNat sampler.tree i
      some { sampler with
        tree := tree
        unremoved_cnt := sampler.unremoved_cnt + 1#64
        total_cnt := sampler.total_cnt + 1#64
        unremoved_weight := sampler.unremoved_weight + weight
        total_weight := sampler.total_weight + weight }

/-- `fd_wsample_new_fini` (`ballet/wsample/fd_wsample.c:348`); `none` = `NULL`, in and out. -/
def fd_wsample_new_fini.spec (shmem : Option fd_wsample_t) (poisoned_weight : BitVec 64) :
    Option fd_wsample_t :=
  match shmem with
  | none => none
  | some sampler =>
    if sampler.total_weight + poisoned_weight < sampler.total_weight then none
    else
      let sampler := { sampler with poisoned_weight := poisoned_weight }
      some (if sampler.restore_enabled ≠ 0#8 then { sampler with tree_copy := sampler.tree }
        else sampler)

/-- `fd_wsample_seed_rng` (`ballet/wsample/fd_wsample.c:393`): `*sampler->rng` after. -/
def fd_wsample_seed_rng.spec (rng : fd_chacha_rng_t) (seed : Vector (BitVec 8) 32) :
    fd_chacha_rng_t :=
  fd_chacha_rng_init.spec rng seed FD_CHACHA_RNG_ALGO_CHACHA8

/-- `idxw_pair_t` (`ballet/wsample/fd_wsample.c:422`). -/
structure idxw_pair_t where
  idx : BitVec 64
  weight : BitVec 64
deriving Repr, DecidableEq

/-- `for( ulong i=0UL; i<R-1UL; i++ ) child_idx += (ulong)(e->left_sum[ i ]<=x);`
(`ballet/wsample/fd_wsample.c:442`). -/
def fd_wsample_map_sample_i.child_idx (e : tree_ele_t) (x : BitVec 64) : BitVec 64 :=
  (List.finRange 8).foldl (fun child_idx i => child_idx + (if e[i] ≤ x then 1#64 else 0#64)) 0#64

/-- One iteration of the `h` loop of `fd_wsample_map_sample_i`
(`ballet/wsample/fd_wsample.c:434-467`): `(query, S, cursor)` after; the `temp` writes are
undone, so only their reads remain. -/
def fd_wsample_map_sample_i.step (tree : Array tree_ele_t) (query S cursor : BitVec 64) :
    BitVec 64 × BitVec 64 × BitVec 64 :=
  let e := tree[cursor.toNat]!
  let x := query
  let child_idx := fd_wsample_map_sample_i.child_idx e x
  -- temp[j-1] for j in [0, 10): temp[-1] = 0UL, temp[0..R-2] = left_sum, temp[R-1] = S
  let temp : Vector (BitVec 64) 10 := #v[0#64, e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], S]
  let li := temp[(child_idx + 1#64).toNat]!
  let lm1 := temp[child_idx.toNat]!
  let query := query - lm1
  let S := li - lm1
  let cursor := R * cursor + child_idx + 1#64
  (query, S, cursor)

/-- The `h` loop of `fd_wsample_map_sample_i` (`ballet/wsample/fd_wsample.c:433`), with
`rem = height - h`. -/
def fd_wsample_map_sample_i.loop (tree : Array tree_ele_t) :
    Nat → BitVec 64 → BitVec 64 → BitVec 64 → BitVec 64 × BitVec 64
  | 0, _, S, cursor => (S, cursor)
  | rem + 1, query, S, cursor =>
    let (query, S, cursor) := fd_wsample_map_sample_i.step tree query S cursor
    fd_wsample_map_sample_i.loop tree rem query S cursor

/-- `fd_wsample_map_sample_i` (`ballet/wsample/fd_wsample.c:427`), portable child count (the
`FD_HAS_AVX512` `cmple`+`popcnt` computes the same value). -/
def fd_wsample_map_sample_i.spec (sampler : fd_wsample_t) (query : BitVec 64) : idxw_pair_t :=
  let cursor := 0#64
  let S := sampler.unremoved_weight
  let (S, cursor) :=
    fd_wsample_map_sample_i.loop sampler.tree sampler.height.toNat query S cursor
  { idx := cursor - sampler.internal_node_cnt, weight := S }

/-- `fd_wsample_map_sample` (`ballet/wsample/fd_wsample.c:474`). -/
def fd_wsample_map_sample.spec (sampler : fd_wsample_t) (query : BitVec 64) : BitVec 64 :=
  (fd_wsample_map_sample_i.spec sampler query).idx

/-- `fd_wsample_sample` (`ballet/wsample/fd_wsample.c:764`): the index and `*sampler->rng`
after, with `fuel` for the roll. -/
def fd_wsample_sample.spec (fuel : Nat) (sampler : fd_wsample_t) (rng : fd_chacha_rng_t) :
    Fueled (BitVec 64 × fd_chacha_rng_t) :=
  if sampler.unremoved_weight = 0#64 then .done (FD_WSAMPLE_EMPTY, rng)
  else if sampler.poisoned_mode ≠ 0#8 then .done (FD_WSAMPLE_INDETERMINATE, rng)
  else do
    let (unif, rng) ← fd_chacha_rng_ulong_roll.spec fuel rng
      (sampler.unremoved_weight + sampler.poisoned_weight)
    if unif ≥ sampler.unremoved_weight then return (FD_WSAMPLE_INDETERMINATE, rng)
    return (fd_wsample_map_sample.spec sampler unif, rng)

end

end Firedancer.Leaders

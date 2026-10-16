module

public import Firedancer.Leaders.Bits

/-! Agave's leader schedule, translated from the Rust: `leader-schedule/src/lib.rs`
(`stake_weighted_slot_leaders`, `sort_stakes`), `vote_keyed.rs` (`Index`), `random/src/weighted.rs`
(`WeightedU64Index`), `random/src/range.rs` (`UniformU64Sampler`), `rand_chacha` 0.9.0 (`guts.rs`,
`chacha.rs`, on the portable `ppv-lite86` 0.2.21 machine), `rand_core` 0.9.3 (`BlockRng`) and
`core::slice` (Rust 1.96 `binary_search_by`, `partition_point`, `dedup_by`).

Modelling choices:
- `u64`/`u32`/`u8` are `BitVec 64/32/8`; `usize` values are `Nat` (they stay far below 2^64).
- `sort_unstable_by` is modelled by a stable merge sort under the same comparator. The two agree
  whenever comparator-equal elements are equal, e.g. when vote addresses are pairwise distinct.
- A panic (`unwrap` on a `WeightedU64Index` error, a slice index out of range) is `none`.
- The unbounded `loop` of `UniformU64Sampler::sample` runs under `fuel` (`Fueled`), per sample.
- `debug_assert!` is not modelled (release build).
- The `u32x4x4` lanes of `refill_wide_impl` evolve independently (`soft.rs` maps every operation
  per lane), so the four blocks are computed one lane at a time. -/

namespace Firedancer.Leaders.Agave

@[expose] public section

/-! ## Keys and records -/

/-- `solana_pubkey::Pubkey`, by its `[u8; 32]`. -/
abbrev Pubkey :=
  Vector (BitVec 8) 32

/-- `SlotLeader` (`leader-schedule/src/lib.rs`). -/
structure SlotLeader where
  id : Pubkey
  vote_address : Pubkey
  deriving Repr, DecidableEq, Inhabited

/-- `<u8 as Ord>::cmp`. -/
def u8Cmp (a b : BitVec 8) : Ordering :=
  compare a.toNat b.toNat

/-- `<u64 as Ord>::cmp`. -/
def u64Cmp (a b : BitVec 64) : Ordering :=
  compare a.toNat b.toNat

/-- `<[u8; 32] as Ord>::cmp`: lexicographic from byte `i` on. -/
def pubkeyCmpFrom (a b : Pubkey) (i : Nat) : Ordering :=
  if h : i < 32 then
    match u8Cmp a[i] b[i] with
    | .eq => pubkeyCmpFrom a b (i + 1)
    | o => o
  else .eq
termination_by 32 - i

/-- `<Pubkey as Ord>::cmp` (lexicographic on the bytes). -/
def pubkeyCmp (a b : Pubkey) : Ordering :=
  pubkeyCmpFrom a b 0

/-! ## `sort_stakes` -/

/-- The comparator of `sort_stakes` (`lib.rs`): stake descending, then vote address descending. -/
def stakeCmp (l r : SlotLeader × BitVec 64) : Ordering :=
  if r.2 = l.2 then pubkeyCmp r.1.vote_address l.1.vote_address else u64Cmp r.2 l.2

/-- `slice::sort_unstable_by( cmp )`, as a stable merge sort into `cmp`-ascending order. -/
def sortBy {α : Type} (cmp : α → α → Ordering) (l : List α) : List α :=
  l.mergeSort fun a b => cmp a b != .gt

/-- `Vec::dedup_by( same_bucket )`: drops each element for which `same_bucket( it, prev )` holds,
`prev` the last kept element. -/
def dedupBy {α : Type} (same_bucket : α → α → Bool) : List α → List α
  | [] => []
  | a :: l => a :: go a l
where
  /-- The scan after the kept element `prev`. -/
  go (prev : α) : List α → List α
    | [] => []
    | b :: l => if same_bucket b prev then go prev l else b :: go b l

/-- The `dedup_by` predicate of `sort_stakes`: equal stake and vote address. -/
def stakeSame (l r : SlotLeader × BitVec 64) : Bool :=
  r.2 == l.2 && r.1.vote_address == l.1.vote_address

/-- `sort_stakes` (`leader-schedule/src/lib.rs`). -/
def sort_stakes (stakes : List (SlotLeader × BitVec 64)) : List (SlotLeader × BitVec 64) :=
  dedupBy stakeSame (sortBy stakeCmp stakes)

/-! ## `core::slice` searches -/

/-- The `while size > 1` loop of `binary_search_by` (Rust 1.96), `f` the comparator. -/
def binarySearchLoop {α : Type} [Inhabited α] (a : Array α) (f : α → Ordering) (base size : Nat) :
    Nat :=
  if _h : size > 1 then
    let half := size / 2
    let mid := base + half
    let cmp := f a[mid]!
    let base := if cmp = .gt then base else mid
    binarySearchLoop a f base (size - half)
  else base
termination_by size
decreasing_by omega

/-- `<[T]>::binary_search_by` (Rust 1.96): `.ok i` or `.error i`. -/
def binary_search_by {α : Type} [Inhabited α] (a : Array α) (f : α → Ordering) : Except Nat Nat :=
  if a.size = 0 then .error 0
  else
    let base := binarySearchLoop a f 0 a.size
    let cmp := f a[base]!
    if cmp = .eq then .ok base else .error (base + if cmp = .lt then 1 else 0)

/-- `<[T]>::partition_point( pred )`. -/
def partition_point {α : Type} [Inhabited α] (a : Array α) (pred : α → Bool) : Nat :=
  match binary_search_by a (fun x => if pred x then .lt else .gt) with
  | .ok i => i
  | .error i => i

/-! ## `UniformU64Sampler` (`random/src/range.rs`) -/

/-- `UniformU64Sampler`; `range_end` is a `NonZero<u64>`. -/
structure UniformU64Sampler where
  range_end : BitVec 64
  zone : BitVec 64
  deriving Repr, DecidableEq

/-- `UniformU64Sampler::new_like_instance_sample` (no overflow: `range_end ≥ 1`). -/
def UniformU64Sampler.new_like_instance_sample (range_end : BitVec 64) : UniformU64Sampler :=
  let ints_to_reject := (BitVec.allOnes 64 - range_end + 1#64) % range_end
  let zone := BitVec.allOnes 64 - ints_to_reject
  { range_end, zone }

/-- `UniformU64Sampler::wmul`: `(hi, lo)` of the 128-bit product. -/
def UniformU64Sampler.wmul (x y : BitVec 64) : BitVec 64 × BitVec 64 :=
  let tmp : BitVec 128 := x.zeroExtend 128 * y.zeroExtend 128
  ((tmp >>> 64).truncate 64, tmp.truncate 64)

/-- The `loop` of `UniformU64Sampler::sample` with `fuel` iterations; `next` is
`rng.random::<u64>()` (`StandardUniform` = `next_u64`). -/
def UniformU64Sampler.sampleLoop {σ : Type} (s : UniformU64Sampler) (next : σ → BitVec 64 × σ) :
    Nat → σ → Fueled (BitVec 64 × σ)
  | 0, _ => .outOfFuel
  | fuel + 1, rng =>
    let (x, rng) := next rng
    let (hi, lo) := UniformU64Sampler.wmul x s.range_end
    if lo ≤ s.zone then .done (hi, rng) else s.sampleLoop next fuel rng

/-- `UniformU64Sampler::sample`, with `fuel` loop iterations. -/
def UniformU64Sampler.sample {σ : Type} (s : UniformU64Sampler) (next : σ → BitVec 64 × σ)
    (fuel : Nat) (rng : σ) : Fueled (BitVec 64 × σ) :=
  s.sampleLoop next fuel rng

/-! ## `WeightedU64Index` (`random/src/weighted.rs`) -/

/-- `rand::distr::weighted::Error`, the variants `new` returns. -/
inductive WeightedError where
  | invalidInput
  | insufficientNonZero
  | overflow
  deriving Repr, DecidableEq

/-- `WeightedU64Index`. -/
structure WeightedU64Index where
  weights : Array (BitVec 64)
  total_weight_sampler : UniformU64Sampler
  deriving Repr

/-- `u64::checked_add`. -/
def checkedAdd (a b : BitVec 64) : Option (BitVec 64) :=
  if a.toNat + b.toNat < 2 ^ 64 then some (a + b) else none

/-- The prefix-sum loop of `WeightedU64Index::new`: the running total and the sums so far. -/
def prefixSums (total : BitVec 64) (acc : Array (BitVec 64)) :
    List (BitVec 64) → Except WeightedError (BitVec 64 × Array (BitVec 64))
  | [] => .ok (total, acc)
  | w :: ws =>
    match checkedAdd total w with
    | none => .error .overflow
    | some total => prefixSums total (acc.push total) ws

/-- `WeightedU64Index::new`. -/
def WeightedU64Index.new (weights : List (BitVec 64)) : Except WeightedError WeightedU64Index := do
  let (total_weight, weights) ← prefixSums 0#64 #[] weights
  if weights.size = 0 then
    throw .invalidInput
  let weights := weights.pop
  if total_weight = 0#64 then
    throw .insufficientNonZero
  return { weights,
           total_weight_sampler := UniformU64Sampler.new_like_instance_sample total_weight }

/-- `WeightedU64Index::sample`, with `fuel` for the uniform draw. -/
def WeightedU64Index.sample {σ : Type} (wi : WeightedU64Index) (next : σ → BitVec 64 × σ)
    (fuel : Nat) (rng : σ) : Fueled (Nat × σ) := do
  let (chosen_weight, rng) ← wi.total_weight_sampler.sample next fuel rng
  return (partition_point wi.weights (fun w => w ≤ chosen_weight), rng)

/-! ## ChaCha20 (`rand_chacha` 0.9.0 `guts.rs`, `ppv-lite86` `soft.rs`/`generic.rs`) -/

/-- `u32x4`. -/
abbrev u32x4 :=
  Vector (BitVec 32) 4

/-- Lane-wise `u32x4` addition (wrapping). -/
def u32x4.add (x y : u32x4) : u32x4 :=
  Vector.ofFn fun i => x[i] + y[i]

/-- Lane-wise `u32x4` xor. -/
def u32x4.xor (x y : u32x4) : u32x4 :=
  Vector.ofFn fun i => x[i] ^^^ y[i]

/-- `rotate_each_word_right{16,20,24,25}`: `u32::rotate_right` on each word. -/
def u32x4.rotr (x : u32x4) (k : Nat) : u32x4 :=
  Vector.ofFn fun i => x[i].rotateRight k

/-- `shuffle_lane_words3012` (`generic.rs`): `[x1, x2, x3, x0]`. -/
def u32x4.shuffle3012 (x : u32x4) : u32x4 :=
  #v[x[1], x[2], x[3], x[0]]

/-- `shuffle_lane_words2301` (`swap64`): `[x2, x3, x0, x1]`. -/
def u32x4.shuffle2301 (x : u32x4) : u32x4 :=
  #v[x[2], x[3], x[0], x[1]]

/-- `shuffle_lane_words1230` (`generic.rs`): `[x3, x0, x1, x2]`. -/
def u32x4.shuffle1230 (x : u32x4) : u32x4 :=
  #v[x[3], x[0], x[1], x[2]]

/-- `struct ChaCha` (`guts.rs`): rows `b`, `c` (key) and `d` (counter, stream id). -/
structure ChaCha where
  b : u32x4
  c : u32x4
  d : u32x4
  deriving Repr, DecidableEq, Inhabited

/-- `struct State` (`guts.rs`) on one lane. -/
structure State where
  a : u32x4
  b : u32x4
  c : u32x4
  d : u32x4
  deriving Repr, DecidableEq

/-- `round` (`guts.rs`): four column quarter-rounds. -/
def round (x : State) : State :=
  let a := x.a.add x.b
  let d := (x.d.xor a).rotr 16
  let c := x.c.add d
  let b := (x.b.xor c).rotr 20
  let a := a.add b
  let d := (d.xor a).rotr 24
  let c := c.add d
  let b := (b.xor c).rotr 25
  { a, b, c, d }

/-- `diagonalize` (`guts.rs`). -/
def diagonalize (x : State) : State :=
  { x with
    b := x.b.shuffle3012, c := x.c.shuffle2301, d := x.d.shuffle1230 }

/-- `undiagonalize` (`guts.rs`). -/
def undiagonalize (x : State) : State :=
  { x with
    b := x.b.shuffle1230, c := x.c.shuffle2301, d := x.d.shuffle3012 }

/-- `for _ in 0..drounds { x = round(x); x = undiagonalize(round(diagonalize(x))); }`. -/
def rounds : Nat → State → State
  | 0, x => x
  | n + 1, x => rounds n (undiagonalize (round (diagonalize (round x))))

/-- The ChaCha constant row `k` (`refill_wide_impl`). -/
def kRow : u32x4 :=
  #v[0x61707865#32, 0x3320646e#32, 0x79622d32#32, 0x6b206574#32]

/-- `add_pos` (little-endian branch): adds `i` to the `u64` in words 0–1 (`u64x2` lane 0). -/
def add_pos (d : u32x4) (i : BitVec 64) : u32x4 :=
  let pos := (d[1] ++ d[0] : BitVec 64) + i
  #v[pos.truncate 32, (pos >>> 32).truncate 32, d[2], d[3]]

/-- Lane `i` of `d0123`: `add_pos( d, i )`. -/
def d0123 (d : u32x4) (i : Fin 4) : u32x4 :=
  add_pos d (BitVec.ofNat 64 i.val)

/-- Block `i` of `refill_wide_impl`: `x.{a,b,c,d} + {kk,sb,sc,sd}` on lane `i`, rows in order. -/
def refillLane (state : ChaCha) (drounds : Nat) (i : Fin 4) : Vector (BitVec 32) 16 :=
  let d := d0123 state.d i
  let x := rounds drounds { a := kRow, b := state.b, c := state.c, d := d }
  let a := x.a.add kRow
  let b := x.b.add state.b
  let c := x.c.add state.c
  let d := x.d.add d
  (a ++ b ++ c ++ d).cast (by decide)

/-- `ChaCha::refill4` = `refill_wide_impl`: four blocks into `out[0..64]`, then
`state.d = add_pos( sd.lane 0, 4 )`. -/
def refill4 (state : ChaCha) (drounds : Nat) : ChaCha × Vector (BitVec 32) 64 :=
  let lanes : Vector (Vector (BitVec 32) 16) 4 := Vector.ofFn (refillLane state drounds)
  let out : Vector (BitVec 32) 64 := Vector.ofFn fun j => lanes[j.val / 16][j.val % 16]
  ({ state with d := add_pos state.d 4#64 }, out)

/-- `read_u32le`. -/
def read_u32le (x0 x1 x2 x3 : BitVec 8) : BitVec 32 :=
  x3 ++ x2 ++ x1 ++ x0

/-- `m.read_le( &key[off..off+16] )`: four little-endian `u32`s. -/
def readRowLe (key : Vector (BitVec 8) 32) (off : Nat) (h : off + 16 ≤ 32) : u32x4 :=
  Vector.ofFn fun i =>
    read_u32le key[off + 4 * i.val] key[off + 4 * i.val + 1] key[off + 4 * i.val + 2]
      key[off + 4 * i.val + 3]

/-- `init_chacha( key, nonce )` with an 8-byte nonce: `ctr_nonce = [0, 0, nonce LE words]`. -/
def init_chacha (key : Vector (BitVec 8) 32) (nonce : Vector (BitVec 8) 8) : ChaCha :=
  { b := readRowLe key 0 (by decide), c := readRowLe key 16 (by decide)
    d :=
      #v[0#32, 0#32, read_u32le nonce[0] nonce[1] nonce[2] nonce[3],
        read_u32le nonce[4] nonce[5] nonce[6] nonce[7]] }

/-! ## `ChaCha20Rng` = `BlockRng<ChaCha20Core>` (`rand_core` 0.9.3 `block.rs`) -/

/-- `ChaCha20Rng`: the core state, `results: Array64<u32>` and `index`. -/
structure ChaCha20Rng where
  core : ChaCha
  results : Vector (BitVec 32) 64
  index : Nat
  deriving Repr, DecidableEq

/-- `ChaCha20Rng::from_seed`: `ChaCha::new( &seed, &[0u8; 8] )`, empty buffer (`index = 64`). -/
def ChaCha20Rng.from_seed (seed : Vector (BitVec 8) 32) : ChaCha20Rng :=
  { core := init_chacha seed (Vector.replicate 8 0#8), results := Vector.replicate 64 0#32,
    index := 64 }

/-- `BlockRng::generate_and_set( index )`: `core.generate` = `refill4( 10 )` (ChaCha20). -/
def ChaCha20Rng.generate_and_set (rng : ChaCha20Rng) (index : Nat) : ChaCha20Rng :=
  let (core, results) := refill4 rng.core 10
  { core, results, index }

/-- `BlockRng::next_u64`, including the `u64` split across a refill. -/
def ChaCha20Rng.next_u64 (rng : ChaCha20Rng) : BitVec 64 × ChaCha20Rng :=
  let read_u64 (results : Vector (BitVec 32) 64) (index : Nat) : BitVec 64 :=
    results[index + 1]! ++ results[index]!
  let len := 64
  let index := rng.index
  if index < len - 1 then (read_u64 rng.results index, { rng with index := rng.index + 2 })
  else
    if index ≥ len then
      let rng := rng.generate_and_set 2
      (read_u64 rng.results 0, rng)
    else
      let x := rng.results[len - 1]!
      let rng := rng.generate_and_set 1
      let y := rng.results[0]!
      (y ++ x, rng)

/-! ## `stake_weighted_slot_leaders` (`leader-schedule/src/lib.rs`) -/

/-- `NUM_CONSECUTIVE_LEADER_SLOTS`. -/
def NUM_CONSECUTIVE_LEADER_SLOTS : Nat :=
  4

/-- The seed: `epoch.to_le_bytes()` in bytes 0–7, zeros after. -/
def epochSeed (epoch : BitVec 64) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun i => if i.val < 8 then epoch.extractLsb' (8 * i.val) 8 else 0#8

/-- `iter::repeat_with(|| slot_leaders[weighted_index.sample(rng)]).take(cnt).collect()`, with
`acc` the elements collected so far; `none` = an index out of range (panic). -/
def sampleLeaders (slot_leaders : Array SlotLeader) (wi : WeightedU64Index) (fuel : Nat) :
    Nat → Array SlotLeader → ChaCha20Rng → Fueled (Option (Array SlotLeader))
  | 0, acc, _ => .done (some acc)
  | cnt + 1, acc, rng =>
    match wi.sample ChaCha20Rng.next_u64 fuel rng with
    | .outOfFuel => .outOfFuel
    | .done (i, rng) =>
      match slot_leaders[i]? with
      | none => .done none
      | some l => sampleLeaders slot_leaders wi fuel cnt (acc.push l) rng

/-- `stake_weighted_slot_leaders( slot_leader_stakes, epoch, len, repeat )` (`rep` = `repeat`), `fuel` per sample;
`none` = panic. -/
def stake_weighted_slot_leaders (fuel : Nat) (slot_leader_stakes : List (SlotLeader × BitVec 64))
    (epoch : BitVec 64) (len rep : Nat) : Fueled (Option (Array SlotLeader)) :=
  let sorted := sort_stakes slot_leader_stakes
  let slot_leaders := sorted.map (·.1)
  let stakes := sorted.map (·.2)
  match WeightedU64Index.new stakes with
  | .error _ => .done none
  | .ok wi =>
    let rng := ChaCha20Rng.from_seed (epochSeed epoch)
    sampleLeaders slot_leaders.toArray wi fuel (len / rep) #[] rng

/-- `LeaderSchedule`'s `Index<u64>`: `slot_leaders[index % num_slots / rep]` for the first
`len` slots; `none` = panic (`num_slots = 0`). -/
def slotLeaderAt (slot_leaders : Array SlotLeader) (rep index : Nat) : Option SlotLeader :=
  let num_slots := slot_leaders.size * rep
  if num_slots = 0 then none else slot_leaders[index % num_slots / rep]?

/-- The schedule slot by slot: Agave's leader for each of the `len` slots of the epoch. -/
def slotLeaders (fuel : Nat) (slot_leader_stakes : List (SlotLeader × BitVec 64))
    (epoch : BitVec 64) (len : Nat) : Fueled (Option (List SlotLeader)) :=
  match
    stake_weighted_slot_leaders fuel slot_leader_stakes epoch len NUM_CONSECUTIVE_LEADER_SLOTS with
  | .outOfFuel => .outOfFuel
  | .done none => .done none
  | .done (some sl) => .done ((List.range len).mapM (slotLeaderAt sl NUM_CONSECUTIVE_LEADER_SLOTS))

end

end Firedancer.Leaders.Agave

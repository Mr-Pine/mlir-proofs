module

public import MLIR.Run.Tactic
public import Firedancer.Common.Counter
public import Firedancer.Common.Tactics
public import Firedancer.R52x5.fd_int_min
public import Firedancer.R52x5.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Ref.fd_curve25519_scalar_wnaf
import Std.Data.ExtHashMap.Lemmas

namespace MLIR.Firedancer.R52x5

/-! ## Specification

`_t` as `Int`s: with `bits ≤ 12`, as the C requires, no `short` wraps. Each loop takes a `fuel`
bound it never reaches. -/

@[expose] public section

/-- `_t` after "unpack s bits into _t": bit `i` of the scalar `x` for `i < 255`; `_t[255] = 0`. -/
def fd_curve25519_scalar_wnaf.unpackT (x : BitVec 256) : Vector Int 256 :=
  Vector.ofFn fun i => if i.val < 255 ∧ x.getLsbD i.val then 1 else 0

/-- "Find first non-zero t": the first `i ≥ k` with `_t[i] ≠ 0`, or `256`. -/
def fd_curve25519_scalar_wnaf.firstNonzero (t : Vector Int 256) : (fuel : Nat) → Nat → Nat
  | 0, k => k
  | fuel + 1, k =>
    if h : k < 256 then
      if t[k] ≠ 0 then k else fd_curve25519_scalar_wnaf.firstNonzero t fuel (k + 1)
    else k

/-- The carry from `j`: the ones after `j` become zeros, the first zero a one; that one's index. -/
def fd_curve25519_scalar_wnaf.carryT : (fuel : Nat) → Vector Int 256 → Nat → Vector Int 256 × Nat
  | 0, t, j => (t, j)
  | fuel + 1, t, j =>
    if h : j + 1 < 256 then
      if t[j + 1] = 0 then (t.set (j + 1) 1, j + 1)
      else fd_curve25519_scalar_wnaf.carryT fuel (t.set (j + 1) 0) (j + 1)
    else (t, j + 1)

/-- The `for( j=i+1; … )` loop from `j`: absorb `_t[j …]` into `ti`; the new `_t`, `ti`, and the
`j` it stops at. -/
def fd_curve25519_scalar_wnaf.absorbT (max : Int) (i : Nat) :
    (fuel : Nat) → Vector Int 256 → Int → Nat → Vector Int 256 × Int × Nat
  | 0, t, ti, j => (t, ti, j)
  | fuel + 1, t, ti, j =>
    if h : j < 256 then
      let tj := t[j]
      if tj = 0 then fd_curve25519_scalar_wnaf.absorbT max i fuel t ti (j + 1)
      else
        let delta : Int := 2 ^ min (j - i) 14
        if 2 * max < delta then (t, ti, j)
        else
          let tip := ti + delta
          if tip ≤ max then fd_curve25519_scalar_wnaf.absorbT max i fuel (t.set j 0) tip (j + 1)
          else
            let tim := ti - delta
            if -max ≤ tim then
              let (t', j') := fd_curve25519_scalar_wnaf.carryT 256 (t.set j 0) j
              (t', tim, j')
            else (t, ti, j)
    else (t, ti, j)

/-- The `while( i<256 )` loop from `i`, where `_t[i] = 1`: finalize `ti` at `i`, go on at `j`. -/
def fd_curve25519_scalar_wnaf.outerT (max : Int) :
    (fuel : Nat) → Vector Int 256 → Nat → Vector Int 256
  | 0, t, _ => t
  | fuel + 1, t, i =>
    if h : i < 256 then
      let (t', ti, j) := fd_curve25519_scalar_wnaf.absorbT max i 256 t 1 (i + 1)
      fd_curve25519_scalar_wnaf.outerT max fuel (t'.set i ti) j
    else t

/-- `_t` as `fd_curve25519_scalar_wnaf( _t, s, bits )` leaves it: the width-`bits` NAF of `x`. -/
def fd_curve25519_scalar_wnaf.wnaf (x : BitVec 256) (bits : Nat) : Vector Int 256 :=
  let t := fd_curve25519_scalar_wnaf.unpackT x
  fd_curve25519_scalar_wnaf.outerT (2 ^ bits - 1) 257 t
    (fd_curve25519_scalar_wnaf.firstNonzero t 256 0)

/-- The bytes `fd_curve25519_scalar_wnaf` stores at `_t`: the digits of `wnaf`. -/
def fd_curve25519_scalar_wnaf.spec (x : BitVec 256) (bits : Nat) : BitVec (16 * 256) :=
  Ref.fd_curve25519_scalar_wnaf.shorts (fd_curve25519_scalar_wnaf.wnaf x bits)

end

/-! ## Proof macros -/

set_option hygiene false in
/-- `^bb4` … `^bb10`: `_t[i | k]`, the `k`-th probe of an unrolled iteration at `i`. -/
local macro "probe " k:num : tactic =>
  `(tactic|
    ( have hj : i + $k < 256 := by omega
      block_init
      step_pure [and_ofNat64 (k := $k) hi8 (by decide), or_ofNat64 (k := $k) hi8 (by decide)]
      step_pure [Nat.mod_eq_of_lt (show i + $k < 2 ^ 64 by omega),
        show 2 * (i + $k) < 2 ^ 64 by omega, show (i + $k) * 2 = 2 * (i + $k) by omega]
      step_load
      step_pure
      finish_block))

set_option hygiene false in
/-- After a probe of `_t[j]`: at a non-zero, on to `^bb12`; at a zero, go on. -/
local macro "found_or_next " j:term " with " hK:ident : tactic =>
  `(tactic| (
    pick_goal 2
    · have h : t[$j] ≠ 0 := fun h0 => hbr ((ofInt_eq_zero_iff (ht $j (by omega))).2 h0)
      rw [firstNonzero_of_ne_zero (i := $j) (by omega) h] at hK12
      step_loop using hK12
    have h : t[$j] = 0 := (ofInt_eq_zero_iff (ht $j (by omega))).1 hbr
    rw [firstNonzero_of_eq_zero (i := $j) (by omega) h] at hK12 $hK
    clear hbr h))

set_option hygiene false in
/-- A later bit of the unpack loop, `_t[j] = ((short)_s[j>>3] >> (j&7)) & 1;`. -/
local macro "unpack_bit " j:term : tactic =>
  `(tactic|
    ( have hj : $j < 256 := by omega
      have hb :
        S.mem.readAt (scalar.add (BitVec.ofNat 64 ($j / 8))) 8 = x.extractLsb' ($j / 8 * 8) 8 := by
        rw [hS]
        exact hbyte $j _ _ hj
      have hfb := fits_byte hfs hco hj
      step_pattern using runBodyFrom_unpackBitRun (jn := $j) (x := x)
      clear hb hfb
      rw [storeDef_shorts hso hj (v := if x.getLsbD $j then 1 else 0) rfl] at hS))

set_option hygiene false in
/-- `i + k`, a later bit of the unrolled iteration at `i`. -/
local macro "next_bit " k:num : tactic =>
  `(tactic|
    ( step_pure [saddOverflow_ofNat64 (i := i) (k := $k) (by omega),
        uaddOverflow_ofNat64 (i := i) (k := $k) (by omega), ← BitVec.ofNat_add]
      unpack_bit i + $k))

/-! ## Bit-vector facts -/

section BitVecFacts

/-- Bit `m` of packed lanes: bit `m % we` of lane `m / we`. -/
theorem getLsbD_packLanes {we n : Nat} (v : Vector (BitVec we) n) {m : Nat} (hm : m < we * n) :
    (BitVec.packLanes v).getLsbD m = (v[m / we]'(Nat.div_lt_of_lt_mul hm)).getLsbD (m % we) := by
  have hwe : 0 < we := Nat.pos_of_ne_zero fun h => by simp [h] at hm
  have h :=
    BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (Nat.div_lt_of_lt_mul hm)
      (Nat.mod_lt _ hwe)
  simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- Two small counters are equal as 64-bit values exactly when they are. -/
theorem eq_of_ofNat64_eq {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64)
    (h : BitVec.ofNat 64 a = BitVec.ofNat 64 b) : a = b := by
  have := congrArg BitVec.toNat h
  rwa [BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at this

/-- A small `int` sign-extends to the same `long`. -/
theorem signExtend_ofNat32 {a : Nat} (h : a < 2 ^ 31) :
    (BitVec.ofNat 32 a).signExtend 64 = BitVec.ofNat 64 a := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false (msb_ofNat32 h)]
  exact setWidth_ofNat32 (by omega)

/-- A small `int` read back. -/
theorem toInt_ofInt32 {a : Int} (h : -2 ^ 31 ≤ a ∧ a < 2 ^ 31) : (BitVec.ofInt 32 a).toInt = a :=
  BitVec.toInt_ofInt_eq_self (by decide) h.1 h.2

/-- Signed comparison of small `int`s. -/
theorem slt_ofInt32 {a b : Int} (ha : -2 ^ 31 ≤ a ∧ a < 2 ^ 31) (hb : -2 ^ 31 ≤ b ∧ b < 2 ^ 31) :
    (BitVec.ofInt 32 a).slt (BitVec.ofInt 32 b) = decide (a < b) := by
  rw [BitVec.slt, toInt_ofInt32 ha, toInt_ofInt32 hb]

/-- A small `short` sign-extends to the same `int`. -/
theorem signExtend_ofInt16 {a : Int} (h : -2 ^ 15 ≤ a ∧ a < 2 ^ 15) :
    (BitVec.ofInt 16 a).signExtend 32 = BitVec.ofInt 32 a := by
  apply BitVec.eq_of_toInt_eq
  rw [BitVec.toInt_signExtend_of_le (by decide), BitVec.toInt_ofInt_eq_self (by decide) h.1 h.2,
    toInt_ofInt32 (by omega)]

/-- `(short)` of an `int`. -/
theorem setWidth_ofInt32 (a : Int) : (BitVec.ofInt 32 a).setWidth 16 = BitVec.ofInt 16 a := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofInt]
  omega

/-- `short` subtraction of `Int`s. -/
theorem ofInt_sub16 (a b : Int) :
    BitVec.ofInt 16 a - BitVec.ofInt 16 b = BitVec.ofInt 16 (a - b) := by
  rw [Int.sub_eq_add_neg, BitVec.ofInt_add, BitVec.ofInt_neg, BitVec.sub_eq_add_neg]

/-- Unsigned comparison of small counters. -/
theorem ult_ofNat64 {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 b) = decide (a < b) := by
  simp [BitVec.ult, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb]

/-- `x << 16` has its low 16 bits clear: an `exact` shift right by 15 or 16 drops no set bit. -/
theorem extractLsb'_shiftLeft_16 (x : BitVec 32) :
    (x <<< 16).extractLsb' 0 16 = 0#16 ∧ (x <<< 16).extractLsb' 0 15 = 0#15 := by
  constructor <;> apply BitVec.eq_of_getLsbD_eq <;> intro j hj <;>
    simp [BitVec.getLsbD_extractLsb', BitVec.getLsbD_shiftLeft] <;>
    omega

/-- Signed comparison of small counters. -/
theorem slt_ofNat32 (ha : a < 2 ^ 31) (hb : b < 2 ^ 31) :
    (BitVec.ofNat 32 a).slt (BitVec.ofNat 32 b) = decide (a < b) := by
  have h : ∀ c, c < 2 ^ 31 → (BitVec.ofNat 32 c).toInt = c := fun c hc => by
    have hn : (BitVec.ofNat 32 c).toNat = c := by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    have h2 : 2 * (BitVec.ofNat 32 c).toNat < 2 ^ 32 := by
      rw [hn]
      omega
    rw [BitVec.toInt_eq_toNat_of_lt h2, hn]
  rw [BitVec.slt, h a ha, h b hb]
  simp only [Int.ofNat_lt]

end BitVecFacts

/-! ## Proof -/

section Proof

open fd_curve25519_scalar_wnaf
open Ref.fd_curve25519_scalar_wnaf (shorts)

/-! ### `_t` in memory -/

/-- Splicing lane `j` into 256 packed `short`s sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 16) 256} (hj : j < 256) (y : BitVec 16) :
    Memory.spliceBits (BitVec.packLanes u) (16 * j) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  rw [Memory.getLsbD_spliceBits, getLsbD_packLanes _ hm, getLsbD_packLanes _ hm, Vector.getElem_set]
  by_cases h : m / 16 = j
  · subst h
    have hc : 16 * (m / 16) ≤ m ∧ m < 16 * (m / 16) + 16 ∧ m < 16 * 256 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(16 * j ≤ m ∧ m < 16 * j + 16 ∧ m < 16 * 256) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- The `_t` stored at `slides` over `S`. -/
abbrev withT (slides : Pointer) (t : Vector Int 256) (S : GlobalState) : GlobalState :=
  { S with mem := S.mem.storeAt slides (shorts t) }

/-- `_t` stored at `slides` over `S`, defined where `d` is: partly written by the unpack loop. -/
abbrev withTD (slides : Pointer) (t : Vector Int 256) (d : BitVec (16 * 256)) (S : GlobalState) :
    GlobalState :=
  { S with mem := S.mem.storeDef slides (shorts t) d }

/-- `d` with the `short`s `i … i + n - 1` defined, one at a time as the unpack loop stores them. -/
def defFrom (d : BitVec (16 * 256)) (i : Nat) : Nat → BitVec (16 * 256)
  | 0 => d
  | n + 1 => defFrom (Memory.spliceBits d (16 * i) (BitVec.allOnes 16)) (i + 1) n

/-- Bit `k` of `defFrom`: set inside the new `short`s. -/
theorem getLsbD_defFrom {d : BitVec (16 * 256)} (hk : k < 16 * 256) :
    (defFrom d i n).getLsbD k = (decide (16 * i ≤ k ∧ k < 16 * (i + n)) || d.getLsbD k) := by
  induction n generalizing d i with
  | zero =>
    simp only [defFrom]
    by_cases h : 16 * i ≤ k ∧ k < 16 * (i + 0) <;> simp [h]
  | succ n ih =>
    simp only [defFrom, ih, Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    by_cases h1 : 16 * (i + 1) ≤ k ∧ k < 16 * (i + 1 + n)
    · simp [h1, show 16 * i ≤ k ∧ k < 16 * (i + (n + 1)) by omega]
    · by_cases h2 : 16 * i ≤ k ∧ k < 16 * i + 16
      · simp [h1, h2, show 16 * i ≤ k ∧ k < 16 * (i + (n + 1)) by omega, hk,
          show k - 16 * i < 16 by omega]
      · simp [h1, show ¬(16 * i ≤ k ∧ k < 16 * i + 16 ∧ k < 16 * 256) by omega,
          show ¬(16 * i ≤ k ∧ k < 16 * (i + (n + 1))) by omega]

/-- Five `short`s defined. -/
theorem defFrom_five {d : BitVec (16 * 256)} :
    defFrom d i (m + 5) =
      defFrom
        (Memory.spliceBits
          (Memory.spliceBits
            (Memory.spliceBits
              (Memory.spliceBits (Memory.spliceBits d (16 * i) (BitVec.allOnes 16)) (16 * (i + 1))
                (BitVec.allOnes 16))
              (16 * (i + 2)) (BitVec.allOnes 16))
            (16 * (i + 3)) (BitVec.allOnes 16))
          (16 * (i + 4)) (BitVec.allOnes 16))
        (i + 5) m := by
  simp only [defFrom]

/-- The unpack loop's `short`s `0 … 254` and `_t[255]` defined: all of `_t`. -/
theorem defFrom_255 (d : BitVec (16 * 256)) :
    Memory.spliceBits (defFrom d 0 255) (16 * 255) (BitVec.allOnes 16) =
      BitVec.allOnes (16 * 256) := by
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  rw [Memory.getLsbD_spliceBits]
  split
  · simp only [BitVec.getLsbD_allOnes, decide_eq_decide]
    omega
  · have h : 16 * 0 ≤ k ∧ k < 16 * (0 + 255) := by omega
    rw [getLsbD_defFrom hk, BitVec.getLsbD_allOnes]
    simp [h, hk]

/-- `_t[j]`'s byte offset `2 * j`, which does not wrap. -/
theorem lane_offset {p : Pointer} (hso : ¬p.offset.uaddOverflow 512#64) (hj : j < 256) :
    (BitVec.ofNat 64 (2 * j)).toNat = 2 * j ∧ ¬p.offset.uaddOverflow (BitVec.ofNat 64 (2 * j)) := by
  have h2j : (BitVec.ofNat 64 (2 * j)).toNat = 2 * j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨h2j, BitVec.not_uaddOverflow_of_le hso ?_⟩
  rw [h2j]
  show 2 * j ≤ 512
  omega

/-- `_t[j]`, read from a stored `_t`. -/
@[mlir_read]
public theorem fd_curve25519_scalar_wnaf.readAt_shorts {m : MemoryState} {p : Pointer}
    {t : Vector Int 256} (hfits : InBounds m p (8 * 512)) (hso : ¬p.offset.uaddOverflow 512#64)
    (hj : j < 256) :
    (m.storeAt p (shorts t)).readAt (p.add (BitVec.ofNat 64 (2 * j))) 16 =
      BitVec.ofInt 16 t[j] := by
  obtain ⟨h2j, hov⟩ := lane_offset hso hj
  have hw : (BitVec.ofNat 64 (2 * j)).toNat * 8 + 16 ≤ 16 * 256 := by
    rw [h2j]
    omega
  rw [MemoryState.readAt_storeAt_add hfits hov hw, h2j, show 2 * j * 8 = j * 16 by omega,
    BitVec.extractLsb'_packLanes _ _ hj, Vector.getElem_map]

/-- A store into `_t[j]` of a partly defined `_t`: the whole `_t`, `_t[j]` set and defined. -/
theorem storeDef_storeAt_lane {m : MemoryState} {p : Pointer} {u d : BitVec (16 * 256)}
    (hso : ¬p.offset.uaddOverflow 512#64) (hj : j < 256) (y : BitVec 16) :
    (m.storeDef p u d).storeAt (p.add (BitVec.ofNat 64 (2 * j))) y =
      m.storeDef p (Memory.spliceBits u (16 * j) y)
        (Memory.spliceBits d (16 * j) (BitVec.allOnes 16)) := by
  obtain ⟨h2j, hov⟩ := lane_offset hso hj
  have ho : (p.add (BitVec.ofNat 64 (2 * j))).offsetInBits = p.offsetInBits + 16 * j := by
    rw [Pointer.offsetInBits_add hov, h2j]
    omega
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, ho,
    spliceBits_spliceBits_add _ _ _ _ _ (show 16 * j + 16 ≤ 16 * 256 by omega)]

/-- A store into `_t[j]` of a stored `_t`: the whole `_t`, `_t[j]` set. -/
theorem storeAt_storeAt_lane {m : MemoryState} {p : Pointer} {u : BitVec (16 * 256)}
    (hso : ¬p.offset.uaddOverflow 512#64) (hj : j < 256) (y : BitVec 16) :
    (m.storeAt p u).storeAt (p.add (BitVec.ofNat 64 (2 * j))) y =
      m.storeAt p (Memory.spliceBits u (16 * j) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes (16 * 256)) (16 * j) (BitVec.allOnes 16) =
      BitVec.allOnes (16 * 256) := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  rw [MemoryState.storeAt_eq_storeDef (p := p), storeDef_storeAt_lane hso hj, hones]
  rfl

/-- A store of `_t[j]` into a stored `_t`: `_t[j]` set. -/
theorem storeAt_shorts {m : MemoryState} {p : Pointer} {t : Vector Int 256}
    (hso : ¬p.offset.uaddOverflow 512#64) (hj : j < 256) {y : BitVec 16} {v : Int}
    (hy : y = BitVec.ofInt 16 v) :
    (m.storeAt p (shorts t)).storeAt (p.add (BitVec.ofNat 64 (2 * j))) y =
      m.storeAt p (shorts (t.set j v)) := by
  rw [storeAt_storeAt_lane hso hj, hy, spliceBits_packLanes hj]
  simp only [shorts, Vector.map_set]

/-- A store of `_t[j]` into a partly defined `_t`: `_t[j]` set and defined. -/
theorem storeDef_shorts {m : MemoryState} {p : Pointer} {t : Vector Int 256} {d : BitVec (16 * 256)}
    (hso : ¬p.offset.uaddOverflow 512#64) (hj : j < 256) {y : BitVec 16} {v : Int}
    (hy : y = BitVec.ofInt 16 v) :
    (m.storeDef p (shorts t) d).storeAt (p.add (BitVec.ofNat 64 (2 * j))) y =
      m.storeDef p (shorts (t.set j v)) (Memory.spliceBits d (16 * j) (BitVec.allOnes 16)) := by
  rw [storeDef_storeAt_lane hso hj, hy, spliceBits_packLanes hj]
  simp only [shorts, Vector.map_set]

/-! ### Find first non-zero -/

/-- `firstNonzero` past a zero. -/
theorem firstNonzero_of_eq_zero {t : Vector Int 256} (hi : i < 256) (h : t[i] = 0) :
    firstNonzero t (n + 1) i = firstNonzero t n (i + 1) := by simp [firstNonzero, hi, h]

/-- `firstNonzero` at a non-zero. -/
theorem firstNonzero_of_ne_zero {t : Vector Int 256} (hi : i < 256) (h : t[i] ≠ 0) :
    firstNonzero t (n + 1) i = i := by simp [firstNonzero, hi, h]

/-- A `0`/`1` digit is zero exactly when its `short` is. -/
theorem ofInt_eq_zero_iff {v : Int} (h : v = 0 ∨ v = 1) : BitVec.ofInt 16 v = 0#16 ↔ v = 0 := by
  rcases h with rfl | rfl <;> decide

/-- A counter `a ≤ b` that is not `b` is below it. -/
theorem lt_of_ofNat64_ne {a b : Nat} (hab : a ≤ b) (h : ¬BitVec.ofNat 64 a = BitVec.ofNat 64 b) :
    a < b := by
  rcases Nat.lt_or_ge a b with hlt | hge
  · exact hlt
  · exact absurd (by rw [show a = b by omega]) h

/-- `i + k` on a small `long` counter does not overflow, signed. -/
theorem saddOverflow_ofNat64 {i k : Nat} (h : i + k < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 k) = false := by
  have hi : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 64 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

/-- Nor unsigned. -/
theorem uaddOverflow_ofNat64 {i k : Nat} (h : i + k < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow (BitVec.ofNat 64 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `i | k` for `i` a multiple of `8` and `k < 8`: the bits are disjoint. -/
theorem and_ofNat64 {i k : Nat} (hi : i % 8 = 0) (hk : k < 8) :
    BitVec.ofNat 64 i &&& BitVec.ofNat 64 k = 0#64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_ofNat]
  by_cases h3 : m < 3
  · have := Nat.testBit_mod_two_pow i 3 m
    rw [show i % 2 ^ 3 = 0 by omega, Nat.zero_testBit] at this
    simp [h3] at this
    simp [this]
  · simp [Nat.testBit_lt_two_pow
          (show k < 2 ^ m from
            Nat.lt_of_lt_of_le hk (Nat.pow_le_pow_right (by decide) (by omega) : 2 ^ 3 ≤ 2 ^ m))]

/-- `i | k` is `i + k` then. -/
theorem or_ofNat64 {i k : Nat} (hi : i % 8 = 0) (hk : k < 8) :
    BitVec.ofNat 64 i ||| BitVec.ofNat 64 k = BitVec.ofNat 64 (i + k) := by
  rw [← BitVec.add_eq_or_of_and_eq_zero _ _ (and_ofNat64 hi hk), BitVec.ofNat_add]

/-- The live registers at `^bb3`, "find first non-zero t", at `i`. -/
abbrev hdr3 (mx : BitVec 32) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1303 := .value 3#64, %1306 := .value 1#16, %1307 := .value 1#64, %1308 := .value 2#64, %1309 :=
    .value 4#64, %1310 := .value 5#64, %1311 := .value 255#64, %1313 := .value 0#16, %1314 :=
    .value 6#64, %1315 := .value 7#64, %1316 := .value 256#64, %1317 := .value 16#32, %1318 :=
    .value 15#32, %1319 := .value 0#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 :=
    .value 2#32, %1323 := .value 1#32, %1324 := .value 256#32, %1325 := .value 8#64, %1327 :=
    .value mx, %1386 := .value (BitVec.ofNat 64 i)]

/-- The live registers at `^bb12`, the first non-zero `i` found. -/
abbrev hdr12 (mx : BitVec 32) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1316 := .value 256#64, %1317 := .value 16#32, %1318 := .value 15#32, %1319 := .value 0#32,
    %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32, %1323 := .value 1#32,
    %1324 := .value 256#32, %1327 := .value mx, %1420 := .value (BitVec.ofNat 64 i)]

/-- `^bb3` … `^bb6`, the first half of an unrolled "find first non-zero t" iteration at `i`:
on to `^bb12` at a non-zero `_t[i … i+3]`, else to `^bb7`. -/
theorem fd_curve25519_scalar_wnaf.nonzero_head (slides scalar : Pointer) (w mx : BitVec 32)
    (hso : ¬slides.offset.uaddOverflow 512#64) (t : Vector Int 256)
    (ht : ∀ k (h : k < 256), t[k] = 0 ∨ t[k] = 1) (S : GlobalState)
    (hfits : Room S.mem slides (8 * 512)) (K : PoisonOr (Vals [] × GlobalState)) (f i : Nat)
    (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get)
    (hi8 : i % 8 = 0) (hi : i + 8 ≤ 256)
    (hK12 :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
          firstNonzero t (f + 4) i < 256 →
          fd_curve25519_scalar_wnaf.runFrom (hdr12 mx E' (firstNonzero t (f + 4) i)) ^bb12
              (withT slides t S) =
            K)
    (hK7 :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
          firstNonzero t (f + 4) i = firstNonzero t f (i + 4) →
          fd_curve25519_scalar_wnaf.runFrom (hdr3 mx E' i) ^bb7 (withT slides t S) = K) :
    fd_curve25519_scalar_wnaf.runFrom (hdr3 mx E i) ^bb3 (withT slides t S) = K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  have hj : i < 256 := by omega
  block_init
  seal_env
  -- `if( _t[i] ) break;`, unrolled
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load
  step_pure
  finish_block
  found_or_next i with hK7
  probe 1
  found_or_next (i + 1) with hK7
  probe 2
  found_or_next (i + 2) with hK7
  probe 3
  found_or_next (i + 3) with hK7
  step_loop using hK7

/-- `^bb7` … `^bb10`, the second half: on to `^bb12` at a non-zero `_t[i+4 … i+7]`, else to
`^bb11`. -/
theorem fd_curve25519_scalar_wnaf.nonzero_tail (slides scalar : Pointer) (w mx : BitVec 32)
    (hso : ¬slides.offset.uaddOverflow 512#64) (t : Vector Int 256)
    (ht : ∀ k (h : k < 256), t[k] = 0 ∨ t[k] = 1) (S : GlobalState)
    (hfits : Room S.mem slides (8 * 512)) (K : PoisonOr (Vals [] × GlobalState)) (f i : Nat)
    (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get)
    (hi8 : i % 8 = 0) (hi : i + 8 ≤ 256)
    (hK12 :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
          firstNonzero t (f + 4) (i + 4) < 256 →
          fd_curve25519_scalar_wnaf.runFrom (hdr12 mx E' (firstNonzero t (f + 4) (i + 4))) ^bb12
              (withT slides t S) =
            K)
    (hK11 :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
          firstNonzero t (f + 4) (i + 4) = firstNonzero t f (i + 8) →
          fd_curve25519_scalar_wnaf.runFrom (hdr3 mx E' i) ^bb11 (withT slides t S) = K) :
    fd_curve25519_scalar_wnaf.runFrom (hdr3 mx E i) ^bb7 (withT slides t S) = K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  probe 4
  found_or_next (i + 4) with hK11
  probe 5
  found_or_next (i + 5) with hK11
  probe 6
  found_or_next (i + 6) with hK11
  probe 7
  found_or_next (i + 7) with hK11
  step_loop using hK11

/-- `^bb3`, "find first non-zero t", unrolled by 8, from `i` with `n` iterations left: on to
`^bb12` at the first non-zero, or to `^bb27` if there is none. -/
theorem fd_curve25519_scalar_wnaf.nonzero_loop (slides scalar : Pointer) (w mx : BitVec 32)
    (hso : ¬slides.offset.uaddOverflow 512#64) (t : Vector Int 256)
    (ht : ∀ k (h : k < 256), t[k] = 0 ∨ t[k] = 1) (S : GlobalState)
    (hfits : Room S.mem slides (8 * 512)) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n i (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
        i % 8 = 0 →
        i < 256 →
        i + 8 * n = 256 →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            firstNonzero t (8 * n) i < 256 →
            fd_curve25519_scalar_wnaf.runFrom (hdr12 mx E' (firstNonzero t (8 * n) i)) ^bb12
                (withT slides t S) =
              K) →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            firstNonzero t (8 * n) i = 256 →
            fd_curve25519_scalar_wnaf.runFrom E' ^bb27 (withT slides t S) = K) →
        fd_curve25519_scalar_wnaf.runFrom (hdr3 mx E i) ^bb3 (withT slides t S) = K := by
  have head := fd_curve25519_scalar_wnaf.nonzero_head slides scalar w mx hso t ht S hfits K
  have tail := fd_curve25519_scalar_wnaf.nonzero_tail slides scalar w mx hso t ht S hfits K
  intro n
  induction n with
  | zero =>
    intro i E _ _ hi hn
    omega
  | succ n ih =>
    intro i E hArgs hi8 hi hn hK12 hK27
    replace hK12 := fun E' (h : E'.args = _) => hK12 E' (h.trans hArgs.symm)
    replace hK27 := fun E' (h : E'.args = _) => hK27 E' (h.trans hArgs.symm)
    rw [show 8 * (n + 1) = 8 * n + 4 + 4 by omega] at hK12 hK27
    step_loop using head (8 * n + 4) i
    · intro hlt
      step_loop using hK12
    · intro heq
      rw [heq] at hK12 hK27
      step_loop using tail (8 * n) i
      · intro hlt
        step_loop using hK12
      · intro heq
        rw [heq] at hK12 hK27
        -- `i += 8`, `i<256`
        block_init
        step_pure [saddOverflow_ofNat64 (i := i) (k := 8) (by omega),
          uaddOverflow_ofNat64 (i := i) (k := 8) (by omega), ← BitVec.ofNat_add]
        step_pure
        finish_block
        · obtain rfl : n = 0 := by
            have := eq_of_ofNat64_eq (by omega) (by omega) hbr; omega
          step_loop using hK27
          simp only [firstNonzero]
        · step_loop using ih (i + 8) _ _ (by omega) (lt_of_ofNat64_ne (by omega) hbr) (by omega)
          · intro hlt
            step_loop using hK12
          · intro heq
            step_loop using hK27

/-! ### The carry loop -/

/-- `_t[k …]` are `0` or `1`: digits not yet made sparse. -/
abbrev Bits (t : Vector Int 256) (k : Nat) : Prop :=
  ∀ m (h : m < 256), k ≤ m → t[m] = 0 ∨ t[m] = 1

/-- Setting a digit before `a` keeps `Bits _ a`, and a later start too. -/
theorem Bits.set {t : Vector Int 256} (h : Bits t a) (ha : a ≤ b) (hj : j < b) {hj' : j < 256}
    {v : Int} : Bits (t.set j v hj') b := by
  intro m hm hbm
  rw [Vector.getElem_set_ne _ _ (by omega)]
  exact h m hm (by omega)

/-- `Bits` from a later start. -/
theorem Bits.mono {t : Vector Int 256} (h : Bits t a) (ha : a ≤ b) : Bits t b := fun m hm hbm =>
  h m hm (by omega)

/-- `_t[255] = 0` survives setting an earlier digit. -/
theorem set_255 {t : Vector Int 256} (h255 : t[255] = 0) (hj : j < 255) {hj' : j < 256} {v : Int} :
    (t.set j v hj')[255] = 0 := by
  rw [Vector.getElem_set_ne _ _ (by omega)]
  exact h255

/-- A counter that is not `255` stays below it. -/
theorem lt_of_ne_255 (hk : k + 1 < 256) (h : ¬BitVec.ofNat 64 (k + 1) = 255#64) : k + 1 < 255 := by
  rcases Nat.lt_or_ge (k + 1) 255 with hlt | hge
  · exact hlt
  · exact absurd (by rw [show k + 1 = 255 by omega]) h

/-- With `_t[255] = 0`, a non-zero digit is below `255`. -/
theorem lt_255_of_ne_zero {t : Vector Int 256} (h255 : t[255] = 0) (hj : j < 256) (h : t[j] ≠ 0) :
    j < 255 := by
  rcases Nat.lt_or_ge j 255 with hlt | hge
  · exact hlt
  · obtain rfl : j = 255 := by omega
    exact absurd h255 h

/-- The carry's step onto a zero: it becomes one, and the carry stops there. -/
theorem carryT_of_eq_zero {t : Vector Int 256} (hk : k + 1 < 256) (h : t[k + 1] = 0) :
    carryT (n + 1) t k = (t.set (k + 1) 1, k + 1) := by simp [carryT, hk, h]

/-- The carry's step onto a one: it becomes zero, and the carry goes on. -/
theorem carryT_of_ne_zero {t : Vector Int 256} (hk : k + 1 < 256) (h : t[k + 1] ≠ 0) :
    carryT (n + 1) t k = carryT n (t.set (k + 1) 0) (k + 1) := by simp [carryT, hk, h]

/-- What the carry leaves: it stops after `k` and in `_t`, with `_t` sparse below and bits above. -/
theorem carryT_inv {t : Vector Int 256} (hk : k < 255) (hn : 255 ≤ k + n) (h255 : t[255] = 0)
    (hbits : Bits t (k + 1)) :
    k < (carryT n t k).2 ∧
      (carryT n t k).2 < 256 ∧
      Bits (carryT n t k).1 ((carryT n t k).2 + 1) ∧
      ((carryT n t k).2 < 255 → (carryT n t k).1[255] = 0) := by
  induction n generalizing t k with
  | zero => omega
  | succ n ih =>
    by_cases h : t[k + 1] = 0
    · rw [carryT_of_eq_zero (by omega) h]
      dsimp only
      exact ⟨by omega, by omega, hbits.set (by omega) (by omega), fun h' => set_255 h255 h'⟩
    · have hk1 := lt_255_of_ne_zero h255 (by omega) h
      rw [carryT_of_ne_zero (by omega) h]
      have :=
        ih (t := t.set (k + 1) 0) hk1 (by omega) (set_255 h255 hk1)
          (hbits.set (by omega) (by omega))
      exact ⟨by omega, this.2⟩

/-- The live registers at `^bb23`, the carry loop, at `k`: `%1457` is `&_t[k]`. -/
abbrev hdr23 (max : Int) (slides : Pointer) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i : Nat)
    (tim : Int) (k : Nat) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1317 := .value 16#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32,
    %1323 := .value 1#32, %1324 := .value 256#32, %1424 := .value (BitVec.ofInt 32 max), %1425 :=
    .value (BitVec.ofInt 32 (2 * max)), %1426 := .value (BitVec.ofInt 32 (-max)), %1429 :=
    .value (BitVec.ofNat 64 i), %1446 := .value (BitVec.ofInt 16 tim), %1457 :=
    .value (slides.add (BitVec.ofNat 64 (2 * k))), %1458 := .value (BitVec.ofNat 32 k)]

/-- The live registers at `^bb26`: `_t[i] = ti`, then on at `j`. -/
abbrev hdr26 (max : Int) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i j : Nat) (ti : Int) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1317 := .value 16#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32,
    %1323 := .value 1#32, %1324 := .value 256#32, %1424 := .value (BitVec.ofInt 32 max), %1425 :=
    .value (BitVec.ofInt 32 (2 * max)), %1426 := .value (BitVec.ofInt 32 (-max)), %1429 :=
    .value (BitVec.ofNat 64 i), %1469 := .value (BitVec.ofNat 32 j), %1470 :=
    .value (BitVec.ofInt 16 ti)]

/-- `^bb23`, the carry loop, at `k` with fuel `n`: `_t[k] = 0`, then on to the first zero after
`k`, set to one in `^bb22`, then `^bb26` with `tim`. -/
theorem fd_curve25519_scalar_wnaf.carry_loop (slides scalar : Pointer) (w : BitVec 32) (max : Int)
    (hso : ¬slides.offset.uaddOverflow 512#64) (S : GlobalState)
    (hfits : Room S.mem slides (8 * 512)) (i : Nat) (tim : Int)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (hk : k < 255),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
        255 ≤ k + n →
        t[255] = 0 →
        Bits t (k + 1) →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            fd_curve25519_scalar_wnaf.runFrom (hdr26 max E' i (carryT n (t.set k 0) k).2 tim) ^bb26
                (withT slides (carryT n (t.set k 0) k).1 S) =
              K) →
        fd_curve25519_scalar_wnaf.runFrom (hdr23 max slides E i tim k) ^bb23 (withT slides t S) =
          K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  intro n
  induction n with
  | zero =>
    intro k t E hk _ hn
    omega
  | succ n ih =>
    intro k t E hk hArgs hn h255 hbits hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    have hk1 : k + 1 < 256 := by omega
    block_init
    seal_env
    -- `_t[j] = 0;`
    step_store
    -- `j++; if( !_t[j] )`
    step_pure [← BitVec.ofNat_add]
    step_pure [signExtend_ofNat32 (show k + 1 < 2 ^ 31 by omega)]
    step_pure [Nat.mod_eq_of_lt (show k + 1 < 2 ^ 64 by omega), show 2 * (k + 1) < 2 ^ 64 by omega,
      show (k + 1) * 2 = 2 * (k + 1) by omega]
    step_load
    step_pure
    finish_block
    · -- `_t[j] = 1; break;`
      have h0 : t[k + 1] = 0 := (ofInt_eq_zero_iff (hbits (k + 1) hk1 (by omega))).1 hbr
      rw [storeAt_shorts hso hk' (v := 0) (by decide)] at hS
      block_init
      step_store
      rw [storeAt_shorts hso hk1 (v := 1) (by decide)] at hS
      finish_block
      rw [carryT_of_eq_zero hk1 (by rwa [Vector.getElem_set_ne _ _ (by omega)])] at hK
      step_loop using hK
    · have h1 : t[k + 1] ≠ 0 := fun h0 =>
        hbr ((ofInt_eq_zero_iff (hbits (k + 1) hk1 (by omega))).2 h0)
      rw [storeAt_shorts hso hk' (v := 0) (by decide)] at hS
      rw [carryT_of_ne_zero hk1 (by rwa [Vector.getElem_set_ne _ _ (by omega)])] at hK
      step_loop using
        ih (k + 1) (t.set k 0) _ (lt_255_of_ne_zero h255 hk1 h1) _ (by omega) (set_255 h255 hk)
          (hbits.set (by omega) (by omega))
      step_loop using hK

/-! ### The absorb loop -/

/-- `fd_int_min( j-i, 14 )`, for `i ≤ k < 255` and `j = k + 1`. -/
theorem min_spec (hik : i ≤ k) (hk : k < 255) :
    fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i) =
      BitVec.ofNat 32 (min (k + 1 - i) 14) := by
  have hsub : BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i = BitVec.ofNat 32 (k + 1 - i) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]
    omega
  have hn : (BitVec.ofNat 32 (k + 1 - i)).toNat = k + 1 - i := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have h2 : 2 * (BitVec.ofNat 32 (k + 1 - i)).toNat < 2 ^ 32 := by
    rw [hn]
    omega
  have hd : (BitVec.ofNat 32 (k + 1 - i)).toInt = ((k + 1 - i : Nat) : Int) := by
    rw [BitVec.toInt_eq_toNat_of_lt h2, hn]
  rw [hsub, fd_int_min.spec, BitVec.slt, hd, show (14#32).toInt = 14 from rfl]
  split <;> rename_i h <;> simp only [decide_eq_true_eq] at h
  · rw [Nat.min_eq_left (by omega)]
  · rw [Nat.min_eq_right (by omega)]

/-- The shift `1 << fd_int_min( j-i, 14 )` is in range. -/
theorem shift_lt (hik : i ≤ k) (hk : k < 255) :
    ¬32 ≤ (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat := by
  rw [min_spec hik hk, BitVec.toNat_ofNat]
  omega

/-- `delta`, as the code computes it: `1 << m` as `(65536 << m) >> 16`, both shifts defined. -/
theorem delta_eq (hik : i ≤ k) (hk : k < 255) :
    65536#32 <<< (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat >>>
          (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat =
        65536#32 ∧
      BitVec.sshiftRight
          (65536#32 <<< (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat)
          (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat =
        65536#32 ∧
      BitVec.extractLsb' 0 16
          (65536#32 <<< (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat) =
        0#16 ∧
      65536#32 <<< (fd_int_min.spec (BitVec.ofNat 32 (k + 1) - BitVec.ofNat 32 i)).toNat >>> 16 =
        BitVec.ofInt 32 (2 ^ min (k + 1 - i) 14) := by
  have h :
    ∀ m : Nat,
      m < 15 →
        65536#32 <<< m >>> m = 65536#32 ∧
          (65536#32 <<< m).sshiftRight m = 65536#32 ∧
          (65536#32 <<< m).extractLsb' 0 16 = 0#16 ∧
          65536#32 <<< m >>> 16 = BitVec.ofInt 32 (2 ^ m) := by
    decide
  rw [min_spec hik hk, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  exact h _ (by omega)

/-- A non-negative `short` zero-extends to the same `int`. -/
theorem setWidth_ofInt16 {a : Int} (h : 0 ≤ a ∧ a < 2 ^ 15) :
    (BitVec.ofInt 16 a).setWidth 32 = BitVec.ofInt 32 a := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofInt]
  omega

/-- `delta` is `2 … 2^14` for `j > i`. -/
theorem delta_bounds (hd : 1 ≤ d) : 2 ≤ (2 : Int) ^ min d 14 ∧ (2 : Int) ^ min d 14 ≤ 16384 := by
  have h : ∀ m < 15, 1 ≤ m → 2 ≤ (2 : Int) ^ m ∧ (2 : Int) ^ m ≤ 16384 := by decide
  exact h _ (by omega) (by omega)

/-- `absorbT` past a zero. -/
theorem absorbT_of_eq_zero {max ti : Int} {t : Vector Int 256} (hj : j < 256) (h : t[j] = 0) :
    absorbT max i (n + 1) t ti j = absorbT max i n t ti (j + 1) := by simp [absorbT, hj, h]

/-- `absorbT` at a digit too far to absorb. -/
theorem absorbT_of_far {max ti : Int} {t : Vector Int 256} (hj : j < 256) (h : t[j] ≠ 0)
    (hd : 2 * max < 2 ^ min (j - i) 14) : absorbT max i (n + 1) t ti j = (t, ti, j) := by
  simp [absorbT, hj, h, hd]

/-- `absorbT` adding a digit. -/
theorem absorbT_of_add {max ti : Int} {t : Vector Int 256} (hj : j < 256) (h : t[j] ≠ 0)
    (hd : ¬2 * max < 2 ^ min (j - i) 14) (hp : ti + 2 ^ min (j - i) 14 ≤ max) :
    absorbT max i (n + 1) t ti j =
      absorbT max i n (t.set j 0) (ti + 2 ^ min (j - i) 14) (j + 1) := by
  simp [absorbT, hj, h, hd, hp]

/-- `absorbT` subtracting a digit, with its carry. -/
theorem absorbT_of_sub {max ti : Int} {t : Vector Int 256} (hj : j < 256) (h : t[j] ≠ 0)
    (hd : ¬2 * max < 2 ^ min (j - i) 14) (hp : ¬ti + 2 ^ min (j - i) 14 ≤ max)
    (hm : -max ≤ ti - 2 ^ min (j - i) 14) :
    absorbT max i (n + 1) t ti j =
      ((carryT 256 (t.set j 0) j).1, ti - 2 ^ min (j - i) 14, (carryT 256 (t.set j 0) j).2) := by
  simp [absorbT, hj, h, hd, hp, hm]

/-- `absorbT` at a digit it can neither add nor subtract. -/
theorem absorbT_of_stuck {max ti : Int} {t : Vector Int 256} (hj : j < 256) (h : t[j] ≠ 0)
    (hd : ¬2 * max < 2 ^ min (j - i) 14) (hp : ¬ti + 2 ^ min (j - i) 14 ≤ max)
    (hm : ¬-max ≤ ti - 2 ^ min (j - i) 14) : absorbT max i (n + 1) t ti j = (t, ti, j) := by
  simp [absorbT, hj, h, hd, hp, hm]

/-- `absorbT` at the end of `_t`. -/
theorem absorbT_end {max ti : Int} {t : Vector Int 256} :
    absorbT max i n t ti 256 = (t, ti, 256) := by cases n <;> simp [absorbT]

/-- The live registers at `^bb16`, the absorb loop, after `j = k`: `%1431` is `ti`. -/
abbrev hdr16 (max : Int) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i k : Nat) (ti : Int) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1317 := .value 16#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32,
    %1323 := .value 1#32, %1324 := .value 256#32, %1424 := .value (BitVec.ofInt 32 max), %1425 :=
    .value (BitVec.ofInt 32 (2 * max)), %1426 := .value (BitVec.ofInt 32 (-max)), %1427 :=
    .value (BitVec.ofNat 32 i), %1429 := .value (BitVec.ofNat 64 i), %1430 :=
    .value (BitVec.ofNat 64 k), %1431 := .value (BitVec.ofInt 16 ti)]

/-- The live registers at `^bb25`: `_t[i] = ti`, then return. -/
abbrev hdr25 (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i : Nat) (ti : Int) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1466 := .value (BitVec.ofNat 64 i), %1467 := .value (BitVec.ofInt 16 ti)]

/-- The live registers at `^bb20`, `tip > max`: `%1433` is `&_t[j]`, `%1442` is `delta`. -/
abbrev hdr20 (max : Int) (slides : Pointer) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i k : Nat)
    (ti : Int) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1317 := .value 16#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32,
    %1323 := .value 1#32, %1324 := .value 256#32, %1424 := .value (BitVec.ofInt 32 max), %1425 :=
    .value (BitVec.ofInt 32 (2 * max)), %1426 := .value (BitVec.ofInt 32 (-max)), %1429 :=
    .value (BitVec.ofNat 64 i), %1430 := .value (BitVec.ofNat 64 k), %1431 :=
    .value (BitVec.ofInt 16 ti), %1433 := .value (slides.add (BitVec.ofNat 64 (2 * (k + 1)))),
    %1436 := .value (BitVec.ofNat 32 (k + 1)), %1442 :=
    .value (BitVec.ofInt 16 (2 ^ min (k + 1 - i) 14))]

/-- `^bb20`, `_t[j]` with `j = k + 1` neither too far nor added: `short tim = (short)(ti - delta);
if( tim>=-max )`, subtract it and carry, or stop; then `^bb26`. -/
theorem fd_curve25519_scalar_wnaf.sub_branch (slides scalar : Pointer) (w : BitVec 32) (max : Int)
    (hmax : 1 ≤ max ∧ max ≤ 4095) (hso : ¬slides.offset.uaddOverflow 512#64) (S : GlobalState)
    (hfits : Room S.mem slides (8 * 512)) (i : Nat) (K : PoisonOr (Vals [] × GlobalState))
    (n k : Nat) (ti : Int) (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get)
    (hik : i ≤ k) (hk : k < 255) (hti : -max ≤ ti ∧ ti ≤ max) (h255 : t[255] = 0)
    (hbits : Bits t (k + 1)) (hne : t[k + 1] ≠ 0) (hfar : ¬2 * max < 2 ^ min (k + 1 - i) 14)
    (hsub : ¬ti + 2 ^ min (k + 1 - i) 14 ≤ max)
    (hK26 :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = E.args →
          (absorbT max i (n + 1) t ti (k + 1)).2.2 < 256 →
          fd_curve25519_scalar_wnaf.runFrom
              (hdr26 max E' i (absorbT max i (n + 1) t ti (k + 1)).2.2
                (absorbT max i (n + 1) t ti (k + 1)).2.1)
              ^bb26 (withT slides (absorbT max i (n + 1) t ti (k + 1)).1 S) =
            K) :
    fd_curve25519_scalar_wnaf.runFrom (hdr20 max slides E i k ti) ^bb20 (withT slides t S) = K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  replace hK26 := fun E' (h : E'.args = _) => hK26 E' (h.trans hArgs.symm)
  have hk1 : k + 1 < 256 := by omega
  have hd := delta_bounds (d := k + 1 - i) (by omega)
  block_init
  step_pure [ofInt_sub16]
  step_pure [signExtend_ofInt16 (a := ti - 2 ^ min (k + 1 - i) 14) (by omega)]
  step_pure [slt_ofInt32 (a := ti - 2 ^ min (k + 1 - i) 14) (b := -max) (by omega) (by omega)]
  finish_block
  · -- neither: `break`
    rw [absorbT_of_stuck hk1 hne hfar hsub (Int.not_le.2 (of_decide_eq_true hbr))] at hK26
    dsimp only at hK26
    step_loop using hK26
  · -- `ti = tim; _t[j] = 0;`, then the carry
    have hm : -max ≤ ti - 2 ^ min (k + 1 - i) 14 :=
      Int.not_lt.1 (of_decide_eq_false (Bool.of_not_eq_true hbr))
    clear hbr
    have hk2 : k + 2 < 256 := by
      have := lt_255_of_ne_zero h255 hk1 hne; omega
    rw [absorbT_of_sub hk1 hne hfar hsub hm] at hK26
    dsimp only at hK26
    block_init
    step_pure [signExtend_ofNat32 (show k < 2 ^ 31 by omega)]
    step_store
    rw [storeAt_shorts hso hk1 (v := 0) (by decide)] at hS
    -- `j++; if( !_t[j] )`
    step_pure [← BitVec.ofNat_add]
    step_pure [signExtend_ofNat32 (show k + 2 < 2 ^ 31 by omega)]
    step_pure [Nat.mod_eq_of_lt (show k + 2 < 2 ^ 64 by omega), show 2 * (k + 2) < 2 ^ 64 by omega,
      show (k + 2) * 2 = 2 * (k + 2) by omega]
    step_load
    step_pure
    finish_block
    · -- `_t[j] = 1; break;`
      have h0 : t[k + 2] = 0 := by
        rw [Vector.getElem_set_ne _ _ (by omega)] at hbr
        exact (ofInt_eq_zero_iff (hbits (k + 2) hk2 (by omega))).1 hbr
      rw [carryT_of_eq_zero (n := 255) (by omega)
          (by rwa [Vector.getElem_set_ne _ _ (by omega)])] at hK26
      dsimp only at hK26
      block_init
      step_store
      rw [storeAt_shorts hso hk2 (v := 1) (by decide)] at hS
      finish_block
      step_loop using hK26
    · -- `_t[j] = 0;` and on through the carry loop
      have h1 : t[k + 2] ≠ 0 := by
        intro h0
        apply hbr
        rw [Vector.getElem_set_ne _ _ (by omega)]
        exact (ofInt_eq_zero_iff (hbits (k + 2) hk2 (by omega))).2 h0
      have hk2' : k + 2 < 255 := lt_255_of_ne_zero h255 hk2 h1
      have h255' : (t.set (k + 1) 0)[255] = 0 := set_255 h255 (by omega)
      rw [carryT_of_ne_zero (n := 255) (by omega)
          (by rwa [Vector.getElem_set_ne _ _ (by omega)])] at hK26
      have hc :=
        (carryT_inv (n := 255) (t := (t.set (k + 1) 0).set (k + 2) 0) hk2' (by omega)
            (set_255 h255' hk2')
            ((hbits.set (b := k + 3) (j := k + 1) (by omega) (by omega)).set (by omega)
              (by omega))).2.1
      step_loop using
        fd_curve25519_scalar_wnaf.carry_loop slides scalar w max hso _ hfits i
          (ti - 2 ^ min (k + 1 - i) 14) K 255 (k + 2) (t.set (k + 1) 0) _ hk2' _ (by omega) h255'
          (hbits.set (by omega) (by omega))
      step_loop using hK26

/-- `^bb16`, the absorb loop, after `j = k` with fuel `n`: on to `^bb26` with the `ti` and `j` it
stops at, or to `^bb25` at the end of `_t`. -/
theorem fd_curve25519_scalar_wnaf.absorb_loop (slides scalar : Pointer) (w : BitVec 32) (max : Int)
    (hmax : 1 ≤ max ∧ max ≤ 4095) (hso : ¬slides.offset.uaddOverflow 512#64) (S : GlobalState)
    (hwf : S.WF) (hfits : Room S.mem slides (8 * 512)) (i : Nat)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (ti : Int) (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
        i ≤ k →
        k < 255 →
        256 ≤ k + 1 + n →
        -max ≤ ti ∧ ti ≤ max →
        t[255] = 0 →
        Bits t (k + 1) →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            (absorbT max i n t ti (k + 1)).2.2 < 256 →
            fd_curve25519_scalar_wnaf.runFrom
                (hdr26 max E' i (absorbT max i n t ti (k + 1)).2.2
                  (absorbT max i n t ti (k + 1)).2.1)
                ^bb26 (withT slides (absorbT max i n t ti (k + 1)).1 S) =
              K) →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            (absorbT max i n t ti (k + 1)).2.2 = 256 →
            fd_curve25519_scalar_wnaf.runFrom (hdr25 E' i (absorbT max i n t ti (k + 1)).2.1) ^bb25
                (withT slides (absorbT max i n t ti (k + 1)).1 S) =
              K) →
        fd_curve25519_scalar_wnaf.runFrom (hdr16 max E i k ti) ^bb16 (withT slides t S) = K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  intro n
  induction n with
  | zero =>
    intro k ti t E _ _ hk hn
    omega
  | succ n ih =>
    intro k ti t E hArgs hik hk hn hti h255 hbits hK26 hK25
    replace hK26 := fun E' (h : E'.args = _) => hK26 E' (h.trans hArgs.symm)
    replace hK25 := fun E' (h : E'.args = _) => hK25 E' (h.trans hArgs.symm)
    have hk1 : k + 1 < 256 := by omega
    block_init
    seal_env
    -- `short tj = _t[j]; if( !tj ) continue;`
    step_pure [saddOverflow_one64 (i := k) (by omega), ← BitVec.ofNat_add]
    step_pure [Nat.mod_eq_of_lt (show k + 1 < 2 ^ 64 by omega), show 2 * (k + 1) < 2 ^ 64 by omega,
      show (k + 1) * 2 = 2 * (k + 1) by omega]
    step_load
    step_pure
    finish_block
    · -- `continue`, then `j < 256`
      have h0 : t[k + 1] = 0 := (ofInt_eq_zero_iff (hbits (k + 1) hk1 (by omega))).1 hbr
      rw [absorbT_of_eq_zero hk1 h0] at hK26 hK25
      block_init
      step_pure
      finish_block
      · have h256 : k + 1 + 1 = 256 := by
          have := eq_of_ofNat64_eq (by omega) (by omega) hbr
          omega
        rw [h256, absorbT_end] at hK25
        dsimp only at hK25
        step_loop using hK25
      · step_loop using
          ih (k + 1) ti t _ _ (by omega) (lt_of_ne_255 hk1 hbr) (by omega) hti h255
            (hbits.mono (by omega))
        · intro hlt
          step_loop using hK26
        · intro heq
          step_loop using hK25
    · have hne : t[k + 1] ≠ 0 := fun h0 =>
        hbr ((ofInt_eq_zero_iff (hbits (k + 1) hk1 (by omega))).2 h0)
      have hd := delta_bounds (d := k + 1 - i) (by omega)
      -- `short delta = (short)(1 << fd_int_min( j-i, 14 )); if( delta>(2*max) ) break;`
      block_init
      step_pure [signExtend_ofNat32 (show k + 1 < 2 ^ 31 by omega)]
      step_pure
      step_call using fd_int_min.call_eq
      step_pure [shift_lt hik hk, delta_eq hik hk]
      step_pure [delta_eq hik hk]
      step_pure [slt_ofInt32 (a := 2 * max) (b := 2 ^ min (k + 1 - i) 14) (by omega) (by omega)]
      finish_block
      · rw [absorbT_of_far hk1 hne (of_decide_eq_true hbr)] at hK26
        dsimp only at hK26
        step_loop using hK26
      · -- `short tip = (short)(ti + delta); if( tip<=max )`
        have hfar := of_decide_eq_false (Bool.of_not_eq_true hbr)
        clear hbr
        block_init
        step_pure [setWidth_ofInt32, setWidth_ofInt16 (a := 2 ^ min (k + 1 - i) 14) (by omega),
          signExtend_ofInt16 (a := 2 ^ min (k + 1 - i) 14) (by omega)]
        step_pure [← BitVec.ofInt_add]
        step_pure [signExtend_ofInt16 (a := ti + 2 ^ min (k + 1 - i) 14) (by omega)]
        step_pure [slt_ofInt32 (a := max) (b := ti + 2 ^ min (k + 1 - i) 14) (by omega) (by omega)]
        finish_block
        · -- `short tim = (short)(ti - delta); if( tim>=-max )`
          have hsub : ¬ti + 2 ^ min (k + 1 - i) 14 ≤ max := Int.not_le.2 (of_decide_eq_true hbr)
          clear hbr
          step_loop using
            fd_curve25519_scalar_wnaf.sub_branch slides scalar w max hmax hso _ hfits i K n k ti t
          intro hlt
          step_loop using hK26
        · -- `ti = tip; _t[j] = 0; continue;`
          have hadd : ti + 2 ^ min (k + 1 - i) 14 ≤ max :=
            Int.not_lt.1 (of_decide_eq_false (Bool.of_not_eq_true hbr))
          clear hbr
          block_init
          step_store
          rw [storeAt_shorts hso hk1 (v := 0) (by decide)] at hS
          finish_block
          block_init
          step_pure
          finish_block
          · have := eq_of_ofNat64_eq (by omega) (by omega) hbr
            exact absurd (lt_255_of_ne_zero h255 hk1 hne) (by omega)
          · have hk1' := lt_of_ne_255 hk1 hbr
            rw [absorbT_of_add hk1 hne hfar hadd] at hK26 hK25
            step_loop using
              ih (k + 1) (ti + 2 ^ min (k + 1 - i) 14) (t.set (k + 1) 0) _ _ (by omega) hk1'
                (by omega) ⟨by omega, hadd⟩ (set_255 h255 hk1') (hbits.set (by omega) (by omega))
            · intro hlt
              step_loop using hK26
            · intro heq
              step_loop using hK25

/-! ### The outer loop -/

/-- What the absorb loop leaves: it stops at `j' ≥ j` within `_t`, with bits after `j'` and
`_t[255] = 0` unless it stops at `255` or later. -/
theorem absorbT_inv {max ti : Int} {t : Vector Int 256} (hij : i < j) (hj : j ≤ 256)
    (hn : 256 ≤ j + n) (h255 : t[255] = 0) (hbits : Bits t j) :
    j ≤ (absorbT max i n t ti j).2.2 ∧
      (absorbT max i n t ti j).2.2 ≤ 256 ∧
      Bits (absorbT max i n t ti j).1 ((absorbT max i n t ti j).2.2 + 1) ∧
      ((absorbT max i n t ti j).2.2 < 255 → (absorbT max i n t ti j).1[255] = 0) := by
  induction n generalizing t ti j with
  | zero =>
    obtain rfl : j = 256 := by omega
    rw [absorbT_end]
    dsimp only
    exact
      ⟨Nat.le_refl _, Nat.le_refl _, fun m hm _ => absurd hm (by omega), fun h =>
        absurd h (by omega)⟩
  | succ n ih =>
    rcases Nat.lt_or_ge j 256 with hj' | hj'
    · by_cases h0 : t[j] = 0
      · rw [absorbT_of_eq_zero hj' h0]
        have :=
          ih (t := t) (ti := ti) (j := j + 1) (by omega) (by omega) (by omega) h255
            (hbits.mono (by omega))
        exact ⟨by omega, this.2⟩
      · have hj255 := lt_255_of_ne_zero h255 hj' h0
        have hstop : j ≤ j ∧ j ≤ 256 ∧ Bits t (j + 1) ∧ (j < 255 → t[255] = 0) :=
          ⟨Nat.le_refl _, by omega, hbits.mono (by omega), fun _ => h255⟩
        by_cases hd : 2 * max < 2 ^ min (j - i) 14
        · rw [absorbT_of_far hj' h0 hd]
          exact hstop
        by_cases hp : ti + 2 ^ min (j - i) 14 ≤ max
        · rw [absorbT_of_add hj' h0 hd hp]
          have :=
            ih (t := t.set j 0) (ti := ti + 2 ^ min (j - i) 14) (j := j + 1) (by omega) (by omega)
              (by omega) (set_255 h255 hj255) (hbits.set (by omega) (by omega))
          exact ⟨by omega, this.2⟩
        by_cases hm : -max ≤ ti - 2 ^ min (j - i) 14
        · rw [absorbT_of_sub hj' h0 hd hp hm]
          dsimp only
          have :=
            carryT_inv (n := 256) (t := t.set j 0) hj255 (by omega) (set_255 h255 hj255)
              (hbits.set (by omega) (by omega))
          exact ⟨by omega, by omega, this.2.2⟩
        · rw [absorbT_of_stuck hj' h0 hd hp hm]
          exact hstop
    · obtain rfl : j = 256 := by omega
      rw [absorbT_end]
      dsimp only
      exact
        ⟨Nat.le_refl _, Nat.le_refl _, fun m hm _ => absurd hm (by omega), fun h =>
          absurd h (by omega)⟩

/-- `outerT` at `i < 256`: finalize the absorbed `ti` at `i`, go on where absorbing stopped. -/
theorem outerT_succ {max : Int} {t : Vector Int 256} (hi : i < 256) :
    outerT max (n + 1) t i =
      outerT max n ((absorbT max i 256 t 1 (i + 1)).1.set i (absorbT max i 256 t 1 (i + 1)).2.1)
        (absorbT max i 256 t 1 (i + 1)).2.2 := by
  simp only [outerT, hi, dite_true]

/-- `outerT` at the end of `_t`. -/
theorem outerT_end {max : Int} {t : Vector Int 256} : outerT max n t 256 = t := by
  cases n <;> simp [outerT]

/-- The live registers at `^bb14`, the `while( i<256 )` loop, at `i`. -/
abbrev hdr14 (max : Int) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (i : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1306 := .value 1#16, %1307 := .value 1#64, %1311 := .value 255#64, %1313 := .value 0#16,
    %1317 := .value 16#32, %1320 := .value 255#32, %1321 := .value 65536#32, %1322 := .value 2#32,
    %1323 := .value 1#32, %1324 := .value 256#32, %1424 := .value (BitVec.ofInt 32 max), %1425 :=
    .value (BitVec.ofInt 32 (2 * max)), %1426 := .value (BitVec.ofInt 32 (-max)), %1427 :=
    .value (BitVec.ofNat 32 i)]

/-- `^bb14`, the `while( i<256 )` loop, at `i` with fuel `n`: `_t` made sparse from `i` on, then
`^bb27`. -/
theorem fd_curve25519_scalar_wnaf.outer_loop (slides scalar : Pointer) (w : BitVec 32) (max : Int)
    (hmax : 1 ≤ max ∧ max ≤ 4095) (hso : ¬slides.offset.uaddOverflow 512#64) (S : GlobalState)
    (hwf : S.WF) (hfits : Room S.mem slides (8 * 512)) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n i (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
        i < 256 →
        256 ≤ i + n →
        Bits t (i + 1) →
        (i < 255 → t[255] = 0) →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            fd_curve25519_scalar_wnaf.runFrom E' ^bb27 (withT slides (outerT max n t i) S) = K) →
        fd_curve25519_scalar_wnaf.runFrom (hdr14 max E i) ^bb14 (withT slides t S) = K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  intro n
  induction n with
  | zero =>
    intro i t E _ hi hn
    omega
  | succ n ih =>
    intro i t E hArgs hi hn hbits h255 hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    block_init
    seal_env
    step_pure [slt_ofNat32 (a := i) (b := 255) (by omega) (by omega)]
    finish_block
    · -- `short ti = 1; for( j=i+1; … )`
      have hi' : i < 255 := of_decide_eq_true hbr
      clear hbr
      rw [outerT_succ hi] at hK
      have hinv :=
        absorbT_inv (max := max) (ti := 1) (n := 256) (t := t) (i := i) (j := i + 1) (by omega)
          (by omega) (by omega) (h255 hi') hbits
      block_init
      step_pure [signExtend_ofNat32 (show i < 2 ^ 31 by omega)]
      finish_block
      step_loop using
        fd_curve25519_scalar_wnaf.absorb_loop slides scalar w max hmax hso _ hwf hfits i K 256 i 1 t
          _ _ (Nat.le_refl i) hi' (by omega) ⟨by omega, by omega⟩ (h255 hi') hbits
      · -- `_t[i] = ti; i = j;`
        intro hlt
        clear hread_slides
        obtain ⟨⟨t', ti', j'⟩, hr⟩ : ∃ r, absorbT max i 256 t 1 (i + 1) = r := ⟨_, rfl⟩
        rw [hr] at hK hinv hlt hE hS
        dsimp only at hK hinv hlt hE hS
        block_init
        step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
          show i * 2 = 2 * i by omega]
        step_store
        rw [storeAt_shorts hso hi (v := ti') rfl] at hS
        step_pure [slt_ofNat32 (a := j') (b := 256) (by omega) (by omega)]
        finish_block
        · step_loop using
            ih j' (t'.set i ti') _ _ hlt (by omega) (hinv.2.2.1.set (by omega) (by omega))
              (fun h => set_255 (hinv.2.2.2 h) hi')
          step_loop using hK
        · exact absurd (of_decide_eq_false (Bool.of_not_eq_true hbr)) (by omega)
      · -- `_t[i] = ti;` at the end
        intro heq
        clear hread_slides hinv
        obtain ⟨⟨t', ti', j'⟩, hr⟩ : ∃ r, absorbT max i 256 t 1 (i + 1) = r := ⟨_, rfl⟩
        rw [hr] at hK heq hE hS
        dsimp only at hK heq hE hS
        rw [heq, outerT_end] at hK
        block_init
        step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
          show i * 2 = 2 * i by omega]
        step_store
        rw [storeAt_shorts hso hi (v := ti') rfl] at hS
        finish_block
        step_loop using hK
    · -- `i = 255`: `_t[255] = 1`
      have hi255 : i = 255 := by
        have := of_decide_eq_false (Bool.of_not_eq_true hbr); omega
      clear hbr
      rw [outerT_succ hi, show i + 1 = 256 by omega, absorbT_end] at hK
      dsimp only at hK
      rw [outerT_end] at hK
      simp only [hi255] at hK
      block_init
      step_pure
      step_store
      rw [storeAt_shorts hso (j := 255) (by decide) (y := 1#16) (v := 1) (by decide)] at hS
      finish_block
      step_loop using hK

/-! ### Unpack -/

/-- The unpack loop from `i`, `n` iterations: `_t[i … i + n - 1]` set to `x`'s bits. -/
def unpackFrom (x : BitVec 256) : Nat → Nat → Vector Int 256 → Vector Int 256
  | _, 0, t => t
  | i, n + 1, t =>
    unpackFrom x (i + 1) n (if h : i < 256 then t.set i (if x.getLsbD i then 1 else 0) h else t)

/-- One unpack iteration. -/
theorem unpackFrom_succ {t : Vector Int 256} (hi : i < 256) :
    unpackFrom x i (n + 1) t =
      unpackFrom x (i + 1) n (t.set i (if x.getLsbD i then 1 else 0) hi) := by
  simp [unpackFrom, hi]

/-- `(i >> 3) & 0x1fffffff`, the byte of bit `i`: `i / 8`. -/
theorem byteIdx_eq (h : i < 2 ^ 32) :
    BitVec.ofNat 64 i >>> 3 &&& 536870911#64 = BitVec.ofNat 64 (i / 8) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (536870911#64).toNat = 2 ^ 29 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_ushiftRight, BitVec.toNat_ofNat,
    BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  simp only [Nat.reducePow]
  omega

/-- `i & 7`, the bit of bit `i` in its byte: `i % 8`. -/
theorem bitIdx_eq : BitVec.ofNat 16 i &&& 7#16 = BitVec.ofNat 16 (i % 8) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (7#16).toNat = 2 ^ 3 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  simp only [Nat.reducePow]
  omega

/-- `_s[i>>3]`'s byte offset `i / 8`, which does not wrap. -/
theorem byte_offset {p : Pointer} (hco : ¬p.offset.uaddOverflow 32#64) (hi : i < 256) :
    (BitVec.ofNat 64 (i / 8)).toNat = i / 8 ∧ ¬p.offset.uaddOverflow (BitVec.ofNat 64 (i / 8)) := by
  have hn : (BitVec.ofNat 64 (i / 8)).toNat = i / 8 := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨hn, BitVec.not_uaddOverflow_of_le hco ?_⟩
  rw [hn]
  show i / 8 ≤ 32
  omega

/-- `_s[i>>3]`, read from the scalar `x` at `p`. -/
theorem readAt_byte {m : MemoryState} {p : Pointer} (hfs : Fits m p (8 * 32))
    (hco : ¬p.offset.uaddOverflow 32#64) (hx : m.readAt p 256 = x) (hi : i < 256) :
    m.readAt (p.add (BitVec.ofNat 64 (i / 8))) 8 = x.extractLsb' (i / 8 * 8) 8 := by
  obtain ⟨hn, hov⟩ := byte_offset hco hi
  have hw : (BitVec.ofNat 64 (i / 8)).toNat * 8 + 8 ≤ 8 * 32 := by
    rw [hn]
    omega
  rw [MemoryState.readAt_add_of_readAt hfs.inBounds hov hw hx, hn]

/-- `_s[i>>3]` fits where the scalar does. -/
theorem fits_byte {m : MemoryState} {p : Pointer} (hfs : Fits m p (8 * 32))
    (hco : ¬p.offset.uaddOverflow 32#64) (hi : i < 256) :
    Fits m (p.add (BitVec.ofNat 64 (i / 8))) 8 := by
  obtain ⟨hn, hov⟩ := byte_offset hco hi
  have hw : (BitVec.ofNat 64 (i / 8)).toNat * 8 + 8 ≤ 8 * 32 := by
    rw [hn]
    omega
  exact Fits.add_of_le hov hw hfs

/-- `((short)_s[i>>3] >> (i&7)) & 1`: bit `i` of `x`. -/
theorem bit_eq {x : BitVec 256} :
    (x.extractLsb' (i / 8 * 8) 8).setWidth 16 >>> (i % 8) &&& 1#16 =
      BitVec.ofInt 16 (if x.getLsbD i then 1 else 0) := by
  have hv :
    BitVec.ofInt 16 (if x.getLsbD i then 1 else 0) = (BitVec.ofBool (x.getLsbD i)).setWidth 16 := by
    cases x.getLsbD i <;> decide
  rw [hv]
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_setWidth,
    BitVec.getLsbD_extractLsb', BitVec.getLsbD_one, BitVec.getLsbD_ofBool]
  by_cases hk0 : k = 0
  · subst hk0
    rw [show i / 8 * 8 + (i % 8 + 0) = i by omega]
    simp only [show i % 8 + 0 < 16 by omega, show i % 8 + 0 < 8 by omega, decide_true,
      Bool.true_and, Bool.and_true, show (0 : Nat) < 16 by decide]
  · simp [hk0]

/-- The live registers at `^bb2`, the unpack loop: `bb0`'s constants. -/
abbrev consts (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1302 := .value 0#64, %1303 := .value 3#64, %1304 := .value 536870911#64, %1305 := .value 7#16,
    %1306 := .value 1#16, %1307 := .value 1#64, %1308 := .value 2#64, %1309 := .value 4#64, %1310 :=
    .value 5#64, %1311 := .value 255#64, %1312 := .value 4294967295#32, %1313 := .value 0#16,
    %1314 := .value 6#64, %1315 := .value 7#64, %1316 := .value 256#64, %1317 := .value 16#32,
    %1318 := .value 15#32, %1319 := .value 0#32, %1320 := .value 255#32, %1321 := .value 65536#32,
    %1322 := .value 2#32, %1323 := .value 1#32, %1324 := .value 256#32, %1325 := .value 8#64]

/-- Five unpack iterations. -/
theorem unpackFrom_five {t : Vector Int 256} (hi : i + 5 ≤ 256) :
    unpackFrom x i (m + 5) t =
      unpackFrom x (i + 5) m
        (((((t.set i (if x.getLsbD i then 1 else 0)).set (i + 1)
                      (if x.getLsbD (i + 1) then 1 else 0)).set
                  (i + 2) (if x.getLsbD (i + 2) then 1 else 0)).set
              (i + 3) (if x.getLsbD (i + 3) then 1 else 0)).set
          (i + 4) (if x.getLsbD (i + 4) then 1 else 0)) := by
  simp only [unpackFrom, show i < 256 by omega, show i + 1 < 256 by omega,
    show i + 2 < 256 by omega, show i + 3 < 256 by omega, show i + 4 < 256 by omega, dite_true]

/-- `_s[j>>3]`, read through a store to `_t`. -/
theorem readAt_byte_store {m : MemoryState} {slides scalar : Pointer} {u d : BitVec w}
    (hsep : slides.id ≠ scalar.id) (hfs : Fits m scalar (8 * 32))
    (hco : ¬scalar.offset.uaddOverflow 32#64) (hx : m.readAt scalar 256 = x) (hj : j < 256) :
    (m.storeDef slides u d).readAt (scalar.add (BitVec.ofNat 64 (j / 8))) 8 =
      x.extractLsb' (j / 8 * 8) 8 := by
  rw [MemoryState.readAt_storeDef_disjoint (Range.disjoint_of_id_ne (by simpa using hsep)),
    readAt_byte hfs hco hx hj]

/-- `_t[j] = ((short)_s[j>>3] >> (j&7)) & 1;` as compiled: `(short)j` into `a`, the byte index
`(j >> 3) & 0x1fffffff` into `c` (`c3`, `cm` hold the constants), `_s[c]` into `e`, the bit into
`k` (`c7`, `c1` hold `7`, `1`), stored at `&_t[j]` in `l`. -/
def unpackBitRun (j b c c3 cm : Dst Γ (.bv 64)) (a f g h k c7 c1 : Dst Γ (.bv 16))
    (e : Dst Γ (.bv 8)) (d l : Dst Γ .ptr) (sl sc : Reg Γ .ptr) : List (Instr Γ) :=
  [.unop (.trunc {}) a (.val j.i j.h), .binop (.lshr false) b (.val j.i j.h) (.val c3.i c3.h),
    .binop .and c (.val b.i b.h) (.val cm.i cm.h), .binop (.gepDyn 0 1) d sc (.val c.i c.h),
    .load e (.val d.i d.h), .unop (.zext false) f (.val e.i e.h),
    .binop .and g (.val a.i a.h) (.val c7.i c7.h),
    .binop (.lshr false) h (.val f.i f.h) (.val g.i g.h),
    .binop .and k (.val h.i h.h) (.val c1.i c1.h), .binop (.gepDyn 0 2) l sl (.val j.i j.h),
    .store (.val l.i l.h) (.val k.i k.h)]

/-- Where the body at `pos` is `unpackBitRun` with `j` holding `jn`: running on from `pos` then
`g'` gives `K` if it does from `pos + 11` with bit `jn` of `x` stored at `&_t[jn]`. -/
theorem runBodyFrom_unpackBitRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {j b c c3 cm : Dst Γ (.bv 64)} {a f g h k c7 c1 : Dst Γ (.bv 16)} {e : Dst Γ (.bv 8)}
    {d l : Dst Γ .ptr} {sl sc : Reg Γ .ptr} {rest : List (Instr Γ)} {slides scalar : Pointer}
    {x : BitVec 256} {jn : Nat} {S : GlobalState} {g' : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = unpackBitRun j b c c3 cm a f g h k c7 c1 e d l sl sc ++ rest)
    (hR : E ⊨ [j := BitVec.ofNat 64 jn, c3 := 3#64, cm := 536870911#64, c7 := 7#16, c1 := 1#16])
    (hsl : E.read sl = .value slides) (hsc : E.read sc = .value scalar)
    (hsd : sl ≠ .val d.i d.h)
    (hd : [j.i, b.i, c.i, c3.i, cm.i, a.i, f.i, g.i, h.i, k.i, c7.i, c1.i, e.i, d.i, l.i].Nodup)
    (hj : jn < 256) (hco : ¬scalar.offset.uaddOverflow 32#64)
    (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfb : Fits S.mem (scalar.add (BitVec.ofNat 64 (jn / 8))) 8)
    (hb : S.mem.readAt (scalar.add (BitVec.ofNat 64 (jn / 8))) 8 = x.extractLsb' (jn / 8 * 8) 8)
    (hfl : Room S.mem (slides.add (BitVec.ofNat 64 (2 * jn))) 16)
    (hK :
      ∀ (va vf vg vh vk : ⟦.bv 16⟧) (vb vc : ⟦.bv 64⟧) (ve : ⟦.bv 8⟧) (vd vl : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, e := ve, f := vf, g := vg, h := vh, k := vk,
                l := vl]
              (pos + 11)
              { alloc := S.alloc,
                mem :=
                  S.mem.storeAt (slides.add (BitVec.ofNat 64 (2 * jn)))
                    (BitVec.ofInt 16 (if x.getLsbD jn then 1 else 0)) } >>=
            g') =
          K) :
    (blk.runBodyFrom E pos S >>= g') = K := by
  have hco' : scalar.offset.toNat + 32 < 2 ^ 64 := by
    have := hco
    simp [BitVec.uaddOverflow] at this
    omega
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  step_pure
  step_pure
  step_pure [byteIdx_eq (i := jn) (by omega)]
  step_pure [Nat.mod_lt (jn / 8) (by decide : 0 < 18446744073709551616)]
  step_load consuming hb
  step_pure
  step_pure [bitIdx_eq]
  step_pure [show jn % 8 % 65536 = jn % 8 by omega, show ¬16 ≤ jn % 8 by omega]
  step_pure [bit_eq]
  step_pure [Nat.mod_eq_of_lt (show jn < 2 ^ 64 by omega), show 2 * jn < 2 ^ 64 by omega,
    show jn * 2 = 2 * jn by omega]
  step_store
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _

/-- `^bb2`, "unpack s bits into _t", unrolled by 5, from `i` with `n` iterations left:
`_t[i … 254]` set, then `^bb1`. -/
theorem fd_curve25519_scalar_wnaf.unpack_loop (slides scalar : Pointer) (w : BitVec 32)
    (hso : ¬slides.offset.uaddOverflow 512#64) (hco : ¬scalar.offset.uaddOverflow 32#64)
    (hsep : slides.id ≠ scalar.id) (S : GlobalState) (hfits : Room S.mem slides (8 * 512))
    (hfs : Fits S.mem scalar (8 * 32)) (x : BitVec 256) (hx : S.mem.readAt scalar 256 = x)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n i (t : Vector Int 256) (d : BitVec (16 * 256)) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value w)).get →
        i < 255 →
        i + 5 * n = 255 →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            fd_curve25519_scalar_wnaf.runFrom (consts E') ^bb1
                (withTD slides (unpackFrom x i (5 * n) t) (defFrom d i (5 * n)) S) =
              K) →
        fd_curve25519_scalar_wnaf.runFrom ((consts E)[%1329 := .value (BitVec.ofNat 64 i)]) ^bb2
            (withTD slides t d S) =
          K := by
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  have hco' : scalar.offset.toNat + 32 < 2 ^ 64 := by
    have := hco
    simp [BitVec.uaddOverflow] at this
    omega
  intro n
  induction n with
  | zero =>
    intro i t d E _ hi hn
    omega
  | succ n ih =>
    intro i t d E hArgs hi hn hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    rw [show 5 * (n + 1) = 5 * n + 5 by omega, unpackFrom_five (by omega), defFrom_five] at hK
    have hbyte := fun j (u d : BitVec (16 * 256)) (hj : j < 256) =>
      readAt_byte_store (u := u) (d := d) hsep hfs hco hx hj
    block_init
    seal_env
    have hj : i < 256 := by omega
    have hb :
      (withTD slides t d S).mem.readAt (scalar.add (BitVec.ofNat 64 (i / 8))) 8 =
        x.extractLsb' (i / 8 * 8) 8 :=
      hbyte i _ _ hj
    have hfb := fits_byte hfs hco hj
    step_pattern using runBodyFrom_unpackBitRun (jn := i) (x := x)
    clear hb hfb
    rw [storeDef_shorts hso hj (v := if x.getLsbD i then 1 else 0) rfl] at hS
    next_bit 1
    next_bit 2
    next_bit 3
    next_bit 4
    -- `i += 5`, `i<255`
    step_pure [saddOverflow_ofNat64 (i := i) (k := 5) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 5) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · obtain rfl : n = 0 := by
        have := eq_of_ofNat64_eq (by omega) (by omega) hbr; omega
      step_loop using hK
    · step_loop using ih (i + 5) _ _ _ _ (lt_of_ofNat64_ne (by omega) hbr) (by omega)
      step_loop using hK

/-- The unpack loop's digits, read back. -/
theorem unpackFrom_get {x : BitVec 256} {t : Vector Int 256} (h : i + n ≤ 256) (hk : k < 256) :
    (unpackFrom x i n t)[k] =
      if i ≤ k ∧ k < i + n then (if x.getLsbD k then 1 else 0) else t[k] := by
  induction n generalizing i t with
  | zero =>
    simp only [unpackFrom]
    split <;> omega
  | succ n ih =>
    rw [unpackFrom_succ (by omega), ih (by omega), Vector.getElem_set]
    by_cases hik : i = k
    · subst hik
      simp
    · by_cases h1 : i + 1 ≤ k ∧ k < i + 1 + n
      · simp only [h1, and_self, ite_true, show i ≤ k ∧ k < i + (n + 1) by omega]
      · simp only [h1, ite_false, hik, show ¬(i ≤ k ∧ k < i + (n + 1)) by omega]

/-- "Unpack s bits into _t" and `_t[255] = 0`: `unpackT`. -/
theorem unpackFrom_set_255 {x : BitVec 256} {t : Vector Int 256} :
    (unpackFrom x 0 255 t).set 255 0 = unpackT x := by
  apply Vector.ext
  intro k hk
  rw [Vector.getElem_set, unpackFrom_get (by omega) hk]
  simp only [unpackT, Vector.getElem_ofFn]
  by_cases h : k = 255
  · subst h
    simp
  · simp [show ¬255 = k by omega, show k < 255 by omega, BitVec.getLsbD_eq_getElem hk]

/-- `unpackT`'s digits are bits. -/
theorem unpackT_bit (x : BitVec 256) (k : Nat) (hk : k < 256) :
    (unpackT x)[k] = 0 ∨ (unpackT x)[k] = 1 := by
  simp only [unpackT, Vector.getElem_ofFn]
  split
  · exact .inr rfl
  · exact .inl rfl

/-- `_t[255] = 0` after unpacking. -/
theorem unpackT_255 (x : BitVec 256) : (unpackT x)[255] = 0 := by simp [unpackT]

/-! ### `_t` before the unpack loop -/

/-- The 256 `short`s at `p`, as `Int`s. -/
def tOf (m : MemoryState) (p : Pointer) : Vector Int 256 :=
  Vector.ofFn fun k => ((m.readAt p (16 * 256)).extractLsb' (k.val * 16) 16).toInt

/-- `tOf`'s `short`s are the bytes read. -/
theorem shorts_tOf {m : MemoryState} {p : Pointer} : shorts (tOf m p) = m.readAt p (16 * 256) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [getLsbD_packLanes _ hi]
  simp only [tOf, Vector.getElem_map, Vector.getElem_ofFn, BitVec.ofInt_toInt,
    BitVec.getLsbD_extractLsb']
  simp only [show i % 16 < 16 by omega, decide_true, Bool.true_and]
  congr 1
  omega

/-- `_t`'s old bytes, stored as `tOf` with their defined bits: the same state. -/
theorem withTD_tOf {S : GlobalState} {slides : Pointer} (h : InBounds S.mem slides (8 * 512)) :
    withTD slides (tOf S.mem slides) (S.mem.definedAt slides (16 * 256)) S = S := by
  rw [withTD, shorts_tOf, MemoryState.storeDef_readAt_definedAt h]

/-! ### `max` -/

/-- `-1 << bits`, shifted back arithmetically, is `-1`: the `nsw` shift does not overflow. -/
theorem allOnes_shl_sshiftRight (hb : b ≤ 12) :
    (4294967295#32 <<< b).sshiftRight b = 4294967295#32 := by
  have h : ∀ k < 13, (4294967295#32 <<< k).sshiftRight k = 4294967295#32 := by decide
  exact h _ (by omega)

/-- `max`, as `~(-1 << bits)`. -/
theorem max_eq (hb : b ≤ 12) :
    (4294967295#32 <<< b) ^^^ 4294967295#32 = BitVec.ofInt 32 (2 ^ b - 1) := by
  have h : ∀ k < 13, (4294967295#32 <<< k) ^^^ 4294967295#32 = BitVec.ofInt 32 (2 ^ k - 1) := by
    decide
  exact h _ (by omega)

/-- `(short)max`, as an `int`. -/
theorem max_short (hb : b ≤ 12) :
    (BitVec.ofInt 32 (2 ^ b - 1) <<< 16).sshiftRight 16 = BitVec.ofInt 32 (2 ^ b - 1) := by
  have h :
    ∀ k < 13,
      (BitVec.ofInt 32 (2 ^ k - 1) <<< 16).sshiftRight 16 = BitVec.ofInt 32 (2 ^ k - 1) := by
    decide
  exact h _ (by omega)

/-- `2*max`, from `(short)max`. -/
theorem max_twice (hb : b ≤ 12) :
    (BitVec.ofInt 32 (2 ^ b - 1) <<< 16).sshiftRight 15 = BitVec.ofInt 32 (2 * (2 ^ b - 1)) := by
  have h :
    ∀ k < 13,
      (BitVec.ofInt 32 (2 ^ k - 1) <<< 16).sshiftRight 15 = BitVec.ofInt 32 (2 * (2 ^ k - 1)) := by
    decide
  exact h _ (by omega)

/-- `-max` does not overflow. -/
theorem max_neg_ssubOverflow (hb : b ≤ 12) :
    (0#32).ssubOverflow (BitVec.ofInt 32 (2 ^ b - 1)) = false := by
  have h : ∀ k < 13, (0#32).ssubOverflow (BitVec.ofInt 32 (2 ^ k - 1)) = false := by decide
  exact h _ (by omega)

/-- `-max`. -/
theorem max_neg (m : Int) : 0#32 - BitVec.ofInt 32 m = BitVec.ofInt 32 (-m) := by
  rw [BitVec.ofInt_neg, BitVec.zero_sub]

/-- `max` for `1 ≤ bits ≤ 12`. -/
theorem max_bounds (hb : 1 ≤ b ∧ b ≤ 12) : 1 ≤ (2 : Int) ^ b - 1 ∧ (2 : Int) ^ b - 1 ≤ 4095 := by
  have h : ∀ k < 13, 1 ≤ k → 1 ≤ (2 : Int) ^ k - 1 ∧ (2 : Int) ^ k - 1 ≤ 4095 := by decide
  exact h _ (by omega) hb.1

/-! ### The function -/

/-- `fd_curve25519_scalar_wnaf( slides, s, bits )` stores `spec` of the 256-bit scalar at `scalar`
as the 256 `short`s at `slides`, for `bits` in the documented range `1 … 12`. `slides` and `scalar`
are separate objects. -/
public theorem fd_curve25519_scalar_wnaf.call_eq (slides scalar : Pointer) (bits : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hslides : Room s.mem slides (8 * 512))
    (hso : ¬slides.offset.uaddOverflow 512#64) (hscalar : Fits s.mem scalar (8 * 32))
    (hco : ¬scalar.offset.uaddOverflow 32#64) (hsep : slides.id ≠ scalar.id)
    (hbits : 1 ≤ bits.toNat ∧ bits.toNat ≤ 12) :
    fd_curve25519_scalar_wnaf.call
        (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeAt slides
                (fd_curve25519_scalar_wnaf.spec (s.mem.readAt scalar 256) bits.toNat) }) := by
  func_init
  have hx : S.mem.readAt scalar 256 = S₀.mem.readAt scalar 256 := by rw [hS]
  -- the loops after unpacking, about the entry state
  have nonzero :=
    fd_curve25519_scalar_wnaf.nonzero_loop slides scalar bits (BitVec.ofInt 32 (2 ^ bits.toNat - 1))
      hso (unpackT (S₀.mem.readAt scalar 256)) (unpackT_bit _) S₀ (hS ▸ hslides)
  have outer :=
    fd_curve25519_scalar_wnaf.outer_loop slides scalar bits (2 ^ bits.toNat - 1) (max_bounds hbits)
      hso S₀ (hS ▸ hwf) (hS ▸ hslides)
  block_init
  iterate 24 step_pure
  finish_block
  -- "unpack s bits into _t"
  rw [← withTD_tOf hslides.inBounds]
  step_loop using
    fd_curve25519_scalar_wnaf.unpack_loop slides scalar bits hso hco hsep _ hslides hscalar _ hx _
      51 0 (tOf S.mem slides) (S.mem.definedAt slides (16 * 256))
  -- `short max = (short)((1 << bits) - 1);` as `~(-1 << bits)`
  block_init
  step_pure [show ¬32 ≤ bits.toNat by omega, allOnes_shl_sshiftRight (b := bits.toNat) (by omega)]
  step_pure [max_eq (b := bits.toNat) (by omega)]
  -- `_t[255] = 0;`
  step_pure
  step_store
  rw [storeDef_shorts hso (j := 255) (by decide) (y := 0#16) (v := 0) (by decide),
    unpackFrom_set_255, defFrom_255, ← MemoryState.storeAt_eq_storeDef] at hS
  finish_block
  -- "find first non-zero t"
  step_loop using nonzero _ 32 0
  · -- `while( i<256 )` from the first non-zero `i`
    intro hlt
    clear_reads
    clear nonzero hwf hslides hscalar
    obtain ⟨i, hi⟩ : ∃ i, firstNonzero (unpackT (S₀.mem.readAt scalar 256)) 256 0 = i := ⟨_, rfl⟩
    rw [hi] at hlt hE
    block_init
    step_pure [ult_ofNat64 (a := i) (b := 256) (by omega) (by omega)]
    finish_block
    · block_init
      step_pure [setWidth_ofNat32 (show i < 2 ^ 32 by omega),
        signExtend_ofNat32 (show i < 2 ^ 31 by omega)]
      step_pure
      step_pure [extractLsb'_shiftLeft_16, max_short (b := bits.toNat) (by omega)]
      step_pure [extractLsb'_shiftLeft_16, max_twice (b := bits.toNat) (by omega)]
      step_pure [max_neg_ssubOverflow (b := bits.toNat) (by omega), max_neg]
      finish_block
      step_loop using
        outer _ 257 i (unpackT (S₀.mem.readAt scalar 256)) _ _ hlt (by omega)
          (fun k hk _ => unpackT_bit _ k hk) (fun _ => unpackT_255 _)
      block_init
      finish_block
      rw [hS, ← hi]
      rfl
    · exact absurd (of_decide_eq_false (Bool.of_not_eq_true hbr)) (by omega)
  · -- no non-zero digit: `_t` as unpacked
    intro heq
    clear_reads
    clear nonzero outer hwf hslides hscalar
    block_init
    finish_block
    rw [hS, spec, wnaf]
    simp only [heq, outerT_end]

end Proof

/-! ## Digits -/

section Digits

namespace fd_curve25519_scalar_wnaf

/-- `d` is `0` or odd, in `[-max, max]`. -/
@[expose]
public def Digit (max d : Int) : Prop :=
  (d = 0 ∨ d % 2 = 1) ∧ -max ≤ d ∧ d ≤ max

/-- Every entry of `t` is a `Digit`. -/
@[expose]
public def Digits (max : Int) (t : Vector Int 256) : Prop :=
  ∀ k (hk : k < 256), Digit max t[k]

theorem Digits.set {max : Int} {t : Vector Int 256} (h : Digits max t) (hj : j < 256)
    (hv : Digit max v) : Digits max (t.set j v hj) := fun k hk => by
  rw [Vector.getElem_set]
  split
  · exact hv
  · exact h k hk

/-- The carry sets `0`s and a `1`. -/
theorem carryT_digits {max : Int} {t : Vector Int 256} (hm : 1 ≤ max) (h : Digits max t) :
    Digits max (carryT n t j).1 := by
  induction n generalizing t j with
  | zero => exact h
  | succ n ih =>
    simp only [carryT]
    split
    next hj =>
      split
      · exact h.set hj ⟨.inr rfl, by omega, hm⟩
      · exact ih (h.set hj ⟨.inl rfl, by omega, by omega⟩)
    · exact h

/-- `2^k` is even for `k ≥ 1`. -/
theorem two_pow_emod {k : Nat} (hk : 1 ≤ k) : (2 : Int) ^ k % 2 = 0 := by
  obtain ⟨k, rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  rw [Int.pow_succ]
  omega

/-- Absorbing keeps `ti` odd in `[-max, max]` and sets `0`s and `1`s. -/
theorem absorbT_digits {max : Int} {t : Vector Int 256} {ti : Int} (hm : 1 ≤ max) (hij : i < j)
    (h : Digits max t) (hti : ti % 2 = 1 ∧ -max ≤ ti ∧ ti ≤ max) :
    Digits max (absorbT max i n t ti j).1 ∧
      (absorbT max i n t ti j).2.1 % 2 = 1 ∧
      -max ≤ (absorbT max i n t ti j).2.1 ∧ (absorbT max i n t ti j).2.1 ≤ max := by
  induction n generalizing t ti j with
  | zero => exact ⟨h, hti⟩
  | succ n ih =>
    have hd : (0 : Int) ≤ 2 ^ min (j - i) 14 := Int.pow_nonneg (by decide)
    have he := two_pow_emod (k := min (j - i) 14) (by omega)
    simp only [absorbT]
    split
    next hj =>
      split
      · exact ih (by omega) h hti
      · split
        · exact ⟨h, hti⟩
        · split
          · exact
              ih (by omega) (h.set hj ⟨.inl rfl, by omega, by omega⟩) ⟨by omega, by omega, by omega⟩
          · split
            · refine ⟨carryT_digits hm (h.set hj ⟨.inl rfl, by omega, by omega⟩), ?_, ?_, ?_⟩ <;>
                dsimp only <;>
                omega
            · exact ⟨h, hti⟩
    · exact ⟨h, hti⟩

/-- The outer loop stores only absorbed `ti`s. -/
theorem outerT_digits {max : Int} {t : Vector Int 256} (hm : 1 ≤ max) (h : Digits max t) :
    Digits max (outerT max n t i) := by
  induction n generalizing t i with
  | zero => exact h
  | succ n ih =>
    simp only [outerT]
    split
    next
      hi =>
      have :=
        absorbT_digits (i := i) (n := 256) (j := i + 1) (ti := 1) hm (by omega) h
          ⟨rfl, by omega, hm⟩
      exact ih (this.1.set hi ⟨.inr this.2.1, this.2.2⟩)
    · exact h

/-- Each digit of `wnaf x bits` is `0` or odd, in `[-(2^bits - 1), 2^bits - 1]`. -/
public theorem wnaf_digits (x : BitVec 256) (hb : 1 ≤ bits) :
    Digits (2 ^ bits - 1) (wnaf x bits) := by
  have h2 : 2 ≤ 2 ^ bits := Nat.le_self_pow (by omega) 2
  have hm : (1 : Int) ≤ 2 ^ bits - 1 := by
    have : (2 : Int) ≤ 2 ^ bits := by exact_mod_cast h2
    omega
  refine outerT_digits hm fun k hk => ?_
  simp only [unpackT, Vector.getElem_ofFn]
  split
  · exact ⟨.inr rfl, by omega, hm⟩
  · exact ⟨.inl rfl, by omega, by omega⟩

/-- `n1slide`'s digits: `0` or odd, in `[-15, 15]`. -/
public theorem wnaf4_digits (x : BitVec 256) : Digits 15 (wnaf x 4) :=
  wnaf_digits x (bits := 4) (by decide)

/-- `n2slide`'s digits: `0` or odd, in `[-255, 255]`. -/
public theorem wnaf8_digits (x : BitVec 256) : Digits 255 (wnaf x 8) :=
  wnaf_digits x (bits := 8) (by decide)

end fd_curve25519_scalar_wnaf

end Digits

end MLIR.Firedancer.R52x5

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Counter
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_ulong_find_lsb
public import Firedancer.Ref.fd_ulong_load_8
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_wnaf
import Firedancer.Common.Point
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification

`ulong n[5]` as one 320-bit number `n`, `n[0]` lowest; `_t` as `Int`s. The loop and the scan take a
`fuel` bound they never reach. -/

@[expose] public section

/-- The first set bit of `n` from `k` on, below `256`, or `256`: the scan and `fd_ulong_find_lsb`. -/
def fd_curve25519_scalar_wnaf.nextBit (n : BitVec 320) : (fuel : Nat) → Nat → Nat
  | 0, _ => 256
  | fuel + 1, k =>
    if k < 256 then (if n.getLsbD k then k else fd_curve25519_scalar_wnaf.nextBit n fuel (k + 1))
    else 256

/-- `mask = (1UL<<wid)-1UL`, `wid = bits+1`. -/
def fd_curve25519_scalar_wnaf.mask (bits : Nat) : BitVec 64 :=
  1#64 <<< (bits + 1) - 1#64

/-- The window at the set bit `pos`: `d`, the low `wid` bits of `n>>pos`, cleared from `n`; then
`_t[pos] = d`, or `d - 2^wid` and a carry of `1` into bit `pos+wid`. The new `n` and `_t`. -/
def fd_curve25519_scalar_wnaf.digit (bits : Nat) (n : BitVec 320) (t : Vector Int 256) (pos : Nat)
    (h : pos < 256) : BitVec 320 × Vector Int 256 :=
  let d := (n >>> pos).setWidth 64 &&& fd_curve25519_scalar_wnaf.mask bits
  let n := n &&& ~~~((fd_curve25519_scalar_wnaf.mask bits).setWidth 320 <<< pos)
  if d.toNat < 2 ^ bits then (n, t.set pos d.toNat h)
  else (n + 1#320 <<< (pos + (bits + 1)), t.set pos (d.toNat - 2 ^ (bits + 1)) h)

/-- The `for( pos … )` loop from `pos`: `_t` with the digits from the next set bit on. -/
def fd_curve25519_scalar_wnaf.loop (bits : Nat) :
    (fuel : Nat) → BitVec 320 → Vector Int 256 → Nat → Vector Int 256
  | 0, _, t, _ => t
  | fuel + 1, n, t, pos =>
    if h : fd_curve25519_scalar_wnaf.nextBit n 256 pos < 256 then
      let r := fd_curve25519_scalar_wnaf.digit bits n t _ h
      fd_curve25519_scalar_wnaf.loop bits fuel r.1 r.2
        (fd_curve25519_scalar_wnaf.nextBit n 256 pos + (bits + 1))
    else t

/-- `n` as loaded: the scalar `x` without bit 255. -/
def fd_curve25519_scalar_wnaf.n0 (x : BitVec 256) : BitVec 320 :=
  (x.setWidth 255).setWidth 320

/-- `_t` as `fd_curve25519_scalar_wnaf( _t, s, bits )` leaves it: the width-`bits` NAF of `x`. -/
def fd_curve25519_scalar_wnaf.wnaf (x : BitVec 256) (bits : Nat) : Vector Int 256 :=
  fd_curve25519_scalar_wnaf.loop bits 256 (fd_curve25519_scalar_wnaf.n0 x) (Vector.replicate 256 0)
    0

/-- 256 `short`s' bytes, `_t[0]` lowest. -/
abbrev fd_curve25519_scalar_wnaf.shorts (t : Vector Int 256) : BitVec (16 * 256) :=
  BitVec.packLanes (t.map (BitVec.ofInt 16))

/-- The bytes `fd_curve25519_scalar_wnaf` stores at `_t`: the digits of `wnaf`. -/
def fd_curve25519_scalar_wnaf.spec (x : BitVec 256) (bits : Nat) : BitVec (16 * 256) :=
  fd_curve25519_scalar_wnaf.shorts (fd_curve25519_scalar_wnaf.wnaf x bits)

end

/-! ## Proof -/

section Proof

open fd_curve25519_scalar_wnaf

/-! ### `n` and `_t` in memory -/

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self,
    implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- `n[w]`'s byte offset `8 * w`, which does not wrap. -/
theorem limb_offset {v : Pointer} (hv : v.offset = 0) (hw : w < 5) :
    (BitVec.ofNat 64 (8 * w)).toNat = 8 * w ∧ ¬v.offset.uaddOverflow (BitVec.ofNat 64 (8 * w)) := by
  have h8 : (BitVec.ofNat 64 (8 * w)).toNat = 8 * w := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨h8, ?_⟩
  simp only [BitVec.uaddOverflow, hv, h8]
  simp
  omega

/-- `n[w]`, read from a stored `n`. -/
@[mlir_read]
public theorem fd_curve25519_scalar_wnaf.readAt_limb {m : MemoryState} {v : Pointer}
    {n : BitVec 320} (hf : Room m v 320) (hv : v.offset = 0) (hw : w < 5) :
    (m.storeAt v n).readAt (v.add (BitVec.ofNat 64 (8 * w))) 64 = n.extractLsb' (64 * w) 64 := by
  obtain ⟨h8, hov⟩ := limb_offset hv hw
  rw [MemoryState.readAt_storeAt_add hf hov (by omega), h8, show 8 * w * 8 = 64 * w by omega]

/-- A store of `n[w]` into a stored `n`: `n` with limb `w` spliced. -/
theorem storeAt_limb {m : MemoryState} {v : Pointer} {n : BitVec 320} (hv : v.offset = 0)
    (hw : w < 5) (y : BitVec 64) :
    (m.storeAt v n).storeAt (v.add (BitVec.ofNat 64 (8 * w))) y =
      m.storeAt v (Memory.spliceBits n (64 * w) y) := by
  obtain ⟨h8, hov⟩ := limb_offset hv hw
  rw [storeAt_storeAt_add hov (by omega), h8, show 8 * w * 8 = 64 * w by omega]

/-- Splicing lane `j` into 256 packed `short`s sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 16) 256} (hj : j < 256) (y : BitVec 16) :
    Memory.spliceBits (BitVec.packLanes u) (16 * j) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hl :
    ∀ (v : Vector (BitVec 16) 256),
      (BitVec.packLanes v).getLsbD m = (v[m / 16]'(by omega)).getLsbD (m % 16) :=
    fun v => by
    have h := BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (by omega) (by omega)
    simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h
  rw [Memory.getLsbD_spliceBits, hl, hl, Vector.getElem_set]
  by_cases h : m / 16 = j
  · subst h
    have hc : 16 * (m / 16) ≤ m ∧ m < 16 * (m / 16) + 16 ∧ m < 16 * 256 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(16 * j ≤ m ∧ m < 16 * j + 16 ∧ m < 16 * 256) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- A store of `_t[j]` into a stored `_t` under a stored `n`: `_t[j]` set. -/
theorem storeAt_shorts {m : MemoryState} {slides v : Pointer} {t : Vector Int 256} {n : BitVec 320}
    (hne : slides.id ≠ v.id) (hso : ¬slides.offset.uaddOverflow 512#64) (hj : j < 256)
    {y : BitVec 16} {val : Int} (hy : y = BitVec.ofInt 16 val) :
    ((m.storeAt slides (shorts t)).storeAt v n).storeAt (slides.add (BitVec.ofNat 64 (2 * j))) y =
      (m.storeAt slides (shorts (t.set j val))).storeAt v n := by
  have h2j : (BitVec.ofNat 64 (2 * j)).toNat = 2 * j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬slides.offset.uaddOverflow (BitVec.ofNat 64 (2 * j)) := by
    refine BitVec.not_uaddOverflow_of_le hso ?_
    rw [h2j]
    show 2 * j ≤ 512
    omega
  rw [MemoryState.storeAt_comm (.inl (by simpa [Range.of] using Ne.symm hne)),
    storeAt_storeAt_add hov (by omega), h2j, show 2 * j * 8 = 16 * j by omega, hy,
    spliceBits_packLanes hj]
  simp only [shorts, Vector.map_set]

/-- `_t` and `n` stored over `S`. -/
abbrev st (slides v : Pointer) (t : Vector Int 256) (n : BitVec 320) (S : GlobalState) :
    GlobalState :=
  { S with mem := (S.mem.storeAt slides (shorts t)).storeAt v n }

/-- The registers live in the loop: `bb0`'s constants, `n`, and the ones `bits` gives. -/
abbrev consts (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1680 := .value 0#64, %1683 := .value 1#64, %1684 := .value 18446744073709551615#64, %1685 :=
    .value 63#64, %1686 := .value 6#64, %1687 := .value 3#64, %1688 := .value 64#64, %1689 :=
    .value 320#64, %1690 := .value 4#64, %1691 := .value 0#1, %1692 := .value 256#64, %1693 :=
    .value v, %1706 := .value (BitVec.ofNat 64 B), %1707 := .value (BitVec.ofNat 64 (B + 1)),
    %1708 := .value (1#64 <<< (B + 1)), %1709 := .value (mask B), %1710 :=
    .value (BitVec.ofNat 64 (63 - B))]

/-! ### Shifts and counters -/

/-- A small `int` sign-extends to the same `long`. -/
theorem signExtend_toNat32 {b : BitVec 32} (h : b.toNat < 2 ^ 31) :
    b.signExtend 64 = BitVec.ofNat 64 b.toNat := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false
      (by
        rw [BitVec.msb_eq_false_iff_two_mul_lt]; omega)]
  apply BitVec.eq_of_toNat_eq
  simp

/-- `1UL<<k` for `k < 64`: the `nuw` shift loses no bit. -/
theorem shl_one_ushiftRight (h : k < 64) : 1#64 <<< k >>> k = 1#64 := by
  have : ∀ k < 64, 1#64 <<< k >>> k = 1#64 := by decide
  exact this k h

/-- `mask`, as `(1UL<<wid) + -1`. -/
theorem add_allOnes_eq_mask : 1#64 <<< (B + 1) + 18446744073709551615#64 = mask B := by
  rw [mask, BitVec.sub_eq_add_neg]
  rfl

/-- `63 - bits`, `nsw`. -/
theorem ssubOverflow_63 (h : B ≤ 12) :
    (63#64).ssubOverflow (BitVec.ofNat 64 B) = false ∧
      63#64 - BitVec.ofNat 64 B = BitVec.ofNat 64 (63 - B) := by
  have :
    ∀ k < 13,
      (63#64).ssubOverflow (BitVec.ofNat 64 k) = false ∧
        63#64 - BitVec.ofNat 64 k = BitVec.ofNat 64 (63 - k) := by
    decide
  exact this B (by omega)

/-! ### The window -/

/-- `spliceBits` as masks and shifts, for `bv_decide`. -/
theorem spliceBits_eq {n w : Nat} (b : BitVec n) (off : Nat) (x : BitVec w) :
    Memory.spliceBits b off x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-- A shift by a small `Nat`, as by a `BitVec`, for `bv_decide`. -/
theorem shiftLeft_ofNat {w : Nat} (x : BitVec w) (h : k < 2 ^ 64) :
    x <<< k = x <<< BitVec.ofNat 64 k := by
  rw [BitVec.shiftLeft_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

/-- The same for a right shift. -/
theorem ushiftRight_ofNat {w : Nat} (x : BitVec w) (h : k < 2 ^ 64) :
    x >>> k = x >>> BitVec.ofNat 64 k := by
  rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

/-- `n[w] &= ~(mask<<b)`, the window within `n[w]`: `n` with bits `pos … pos+wid-1` cleared. -/
theorem clear_one (n : BitVec 320) (hw : w < 4) (hb : b ≤ 63 - B) (hB : B ≤ 12) :
    Memory.spliceBits n (64 * w)
        (n.extractLsb' (64 * w) 64 &&& (mask B <<< b ^^^ 18446744073709551615#64)) =
      n &&& ~~~((mask B).setWidth 320 <<< (64 * w + b)) := by
  rw [mask, shiftLeft_ofNat _ (show B + 1 < 2 ^ 64 by omega),
    shiftLeft_ofNat _ (show b < 2 ^ 64 by omega),
    shiftLeft_ofNat (w := 320) _ (show 64 * w + b < 2 ^ 64 by omega), BitVec.ofNat_add,
    BitVec.ofNat_add]
  have hc : BitVec.ofNat 64 b ≤ 63#64 - BitVec.ofNat 64 B := by
    rw [BitVec.le_def, BitVec.toNat_sub]; simp; omega
  have hB' : BitVec.ofNat 64 B ≤ 12#64 := by
    rw [BitVec.le_def]; simp; omega
  generalize BitVec.ofNat 64 b = c at hc ⊢
  generalize BitVec.ofNat 64 B = β at hc hB' ⊢
  rcases (show w = 0 ∨ w = 1 ∨ w = 2 ∨ w = 3 by omega) with rfl | rfl | rfl | rfl <;>
    simp only [spliceBits_eq] <;>
    bv_decide

/-- With the window spilling into `n[w+1]`, `n[w+1] &= ~(mask>>(64-b))` clears the rest. -/
theorem clear_spill (n : BitVec 320) (hw : w < 4) (hb : 63 - B < b) (hb64 : b < 64) (hB : B ≤ 12) :
    Memory.spliceBits
        (Memory.spliceBits n (64 * w)
          (n.extractLsb' (64 * w) 64 &&& (mask B <<< b ^^^ 18446744073709551615#64)))
        (64 * (w + 1))
        ((Memory.spliceBits n (64 * w)
                (n.extractLsb' (64 * w) 64 &&&
                  (mask B <<< b ^^^ 18446744073709551615#64))).extractLsb'
            (64 * (w + 1)) 64 &&&
          (mask B >>> (64 - b) ^^^ 18446744073709551615#64)) =
      n &&& ~~~((mask B).setWidth 320 <<< (64 * w + b)) := by
  rw [mask, shiftLeft_ofNat _ (show B + 1 < 2 ^ 64 by omega),
    shiftLeft_ofNat _ (show b < 2 ^ 64 by omega),
    ushiftRight_ofNat _ (show 64 - b < 2 ^ 64 by omega),
    shiftLeft_ofNat (w := 320) _ (show 64 * w + b < 2 ^ 64 by omega), BitVec.ofNat_add,
    BitVec.ofNat_add,
    show BitVec.ofNat 64 (64 - b) = 64#64 - BitVec.ofNat 64 b by
      apply BitVec.eq_of_toNat_eq; simp; omega]
  have hc : 63#64 - BitVec.ofNat 64 B < BitVec.ofNat 64 b := by
    rw [BitVec.lt_def, BitVec.toNat_sub]; simp; omega
  have hc64 : BitVec.ofNat 64 b < 64#64 := by
    rw [BitVec.lt_def]; simp; omega
  have hB' : BitVec.ofNat 64 B ≤ 12#64 := by
    rw [BitVec.le_def]; simp; omega
  generalize BitVec.ofNat 64 b = c at hc hc64 ⊢
  generalize BitVec.ofNat 64 B = β at hc hB' ⊢
  rcases (show w = 0 ∨ w = 1 ∨ w = 2 ∨ w = 3 by omega) with rfl | rfl | rfl | rfl <;>
    simp only [spliceBits_eq] <;>
    bv_decide

/-- `lo = n[w]>>b | n[w+1]<<(64-b)` for `b ≠ 0`: the 64 bits of `n` from `pos`; the halves are
disjoint. -/
theorem window_spec (n : BitVec 320) (hw : w < 4) (hb0 : 0 < b) (hb : b < 64) :
    n.extractLsb' (64 * (w + 1)) 64 <<< (64 - b) &&& n.extractLsb' (64 * w) 64 >>> b = 0#64 ∧
      n.extractLsb' (64 * (w + 1)) 64 <<< (64 - b) ||| n.extractLsb' (64 * w) 64 >>> b =
        (n >>> (64 * w + b)).setWidth 64 := by
  rw [shiftLeft_ofNat _ (show 64 - b < 2 ^ 64 by omega),
    ushiftRight_ofNat _ (show b < 2 ^ 64 by omega),
    ushiftRight_ofNat (w := 320) _ (show 64 * w + b < 2 ^ 64 by omega), BitVec.ofNat_add,
    show BitVec.ofNat 64 (64 - b) = 64#64 - BitVec.ofNat 64 b by
      apply BitVec.eq_of_toNat_eq; simp; omega]
  have hc0 : 0#64 < BitVec.ofNat 64 b := by
    rw [BitVec.lt_def]; simp; omega
  have hc64 : BitVec.ofNat 64 b < 64#64 := by
    rw [BitVec.lt_def]; simp; omega
  generalize BitVec.ofNat 64 b = c at hc0 hc64 ⊢
  rcases (show w = 0 ∨ w = 1 ∨ w = 2 ∨ w = 3 by omega) with rfl | rfl | rfl | rfl <;>
    constructor <;>
    bv_decide

/-! ### The carry -/

/-- One carry step at word `cw`, bit `cb`: `n[cw] += 1<<cb`. Without a wrap, or at the top word, it
adds `1` at bit `64 cw + cb`; with one, the rest is a carry into word `cw+1`. -/
theorem carry_spec (n : BitVec 320) (hw : cw < 5) (hcb : cb < 64) :
    ((¬(n.extractLsb' (64 * cw) 64 + 1#64 <<< cb).ult (n.extractLsb' (64 * cw) 64) ∨ cw = 4) →
        Memory.spliceBits n (64 * cw) (n.extractLsb' (64 * cw) 64 + 1#64 <<< cb) =
          n + 1#320 <<< (64 * cw + cb)) ∧
      ((n.extractLsb' (64 * cw) 64 + 1#64 <<< cb).ult (n.extractLsb' (64 * cw) 64) →
        cw < 4 →
        Memory.spliceBits n (64 * cw) (n.extractLsb' (64 * cw) 64 + 1#64 <<< cb) +
            1#320 <<< (64 * (cw + 1) + 0) =
          n + 1#320 <<< (64 * cw + cb)) := by
  have h1 : 1#64 <<< cb = 1#64 <<< BitVec.ofNat 64 cb := by
    rw [BitVec.shiftLeft_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have h2 :
    ∀ k,
      k < 5 →
        1#320 <<< (64 * k + cb) =
          1#320 <<< (BitVec.ofNat 320 (64 * k) + (BitVec.ofNat 64 cb).setWidth 320) :=
    fun k hk => by
    rw [BitVec.shiftLeft_eq', BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_ofNat,
      BitVec.toNat_ofNat]
    congr 1
    omega
  have hc : BitVec.ofNat 64 cb < 64#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat]; simp; omega
  rw [h1, h2 cw hw, show 64 * (cw + 1) + 0 = 64 * (cw + 1) by omega]
  generalize BitVec.ofNat 64 cb = c at hc ⊢
  rcases (show cw = 0 ∨ cw = 1 ∨ cw = 2 ∨ cw = 3 ∨ cw = 4 by omega) with rfl | rfl | rfl | rfl |
      rfl <;>
    simp only [spliceBits_eq] <;>
    constructor <;>
    bv_decide

/-- The carry loop's condition: a wrap, and a word left. -/
theorem carry_cond {a b : Bool} : (if a = true then BitVec.ofBool b else 0#1) = 1#1 ↔ a ∧ b := by
  cases a <;> cases b <;> decide

/-- Unsigned comparison of small counters. -/
theorem ult_ofNat64 {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 b) = decide (a < b) := by
  simp [BitVec.ult, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb]

/-- The registers at `^bb14`, the carry loop, at word `cw`, bit `cb`; `q` for `^bb15`. -/
abbrev hdr14 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (q cb cw : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1762 := .value (BitVec.ofNat 64 q), %1766 := .value (BitVec.ofNat 64 cb), %1767 :=
    .value (BitVec.ofNat 64 cw)]

/-- The registers at `^bb15`, `pos += wid`, at `q`. -/
abbrev hdr15 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (q : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1776 := .value (BitVec.ofNat 64 q)]

/-- `^bb14`, the carry loop, at word `cw`, bit `cb`, `4 - cw` words left: on to `^bb15` with `1`
added at bit `64 cw + cb`. -/
theorem fd_curve25519_scalar_wnaf.carry_loop (slides scalar v : Pointer) (bits : BitVec 32)
    (B q : Nat) (Sb : GlobalState) (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v)
    (hv : v.offset = 0) (t : Vector Int 256) {β : Type} (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ m cw cb (n : BitVec 320) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
        cw + m = 4 →
        cb < 64 →
        (∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args = E.args →
            (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' q) ^bb15
                  (st slides v t (n + 1#320 <<< (64 * cw + cb)) Sb) >>=
                g) =
              K) →
        (fd_curve25519_scalar_wnaf.runFrom (hdr14 v B E q cb cw) ^bb14 (st slides v t n Sb) >>= g) =
          K := by
  intro m
  induction m with
  | zero =>
    intro cw cb n E hArgs hm hcb hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hw : cw < 5 := by omega
    block_init
    seal_env
    -- `ulong o = n[cw]; n[cw] = o + (1UL<<cb);`
    step_pure [Nat.mod_eq_of_lt (show cw < 2 ^ 64 by omega), show cw * 8 = 8 * cw by omega,
      show 8 * cw < 2 ^ 64 by omega]
    step_load
    step_pure [Nat.mod_eq_of_lt (show cb < 2 ^ 64 by omega), show ¬64 ≤ cb by omega,
      shl_one_ushiftRight hcb]
    step_pure
    step_store
    rw [storeAt_limb hv hw] at hS
    -- `if( n[cw]>=o ) break;`, `cw<5`
    step_pure
    step_pure [saddOverflow_one64 (i := cw) (by omega), uaddOverflow_one64 (i := cw) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    step_pure
    finish_block
    · simp only [carry_cond, ult_ofNat64 (show cw < 2 ^ 64 by omega) (show 4 < 2 ^ 64 by omega),
        decide_eq_true_eq] at hbr
      omega
    · rw [((carry_spec n hw hcb).1 (.inr (by omega)))] at hS
      step_loop using hK
  | succ m ih =>
    intro cw cb n E hArgs hm hcb hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hw : cw < 5 := by omega
    block_init
    seal_env
    step_pure [Nat.mod_eq_of_lt (show cw < 2 ^ 64 by omega), show cw * 8 = 8 * cw by omega,
      show 8 * cw < 2 ^ 64 by omega]
    step_load
    step_pure [Nat.mod_eq_of_lt (show cb < 2 ^ 64 by omega), show ¬64 ≤ cb by omega,
      shl_one_ushiftRight hcb]
    step_pure
    step_store
    rw [storeAt_limb hv hw] at hS
    step_pure
    step_pure [saddOverflow_one64 (i := cw) (by omega), uaddOverflow_one64 (i := cw) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    step_pure
    finish_block
    · -- a wrap: on to `n[cw+1]` at bit `0`
      simp only [carry_cond, ult_ofNat64 (show cw < 2 ^ 64 by omega) (show 4 < 2 ^ 64 by omega),
        decide_eq_true_eq] at hbr
      have hn := (carry_spec n hw hcb).2 hbr.1 hbr.2
      step_loop using ih (cw + 1) 0 _ _ _ (by omega) (by omega)
      rw [hn] at hS
      step_loop using hK
    · simp only [carry_cond, ult_ofNat64 (show cw < 2 ^ 64 by omega) (show 4 < 2 ^ 64 by omega),
        decide_eq_true_eq, not_and] at hbr
      rw [((carry_spec n hw hcb).1
          (by
            by_cases h : (n.extractLsb' (64 * cw) 64 + 1#64 <<< cb).ult (n.extractLsb' (64 * cw) 64)
            · exact
                .inr
                  (by
                    have := hbr h; omega)
            · exact .inl h))] at hS
      step_loop using hK

/-! ### The digit -/

/-- `x & 63` on a counter: `x % 64`. -/
theorem ofNat_and_63 : BitVec.ofNat 64 k &&& 63#64 = BitVec.ofNat 64 (k % 64) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (63#64).toNat = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `x >> 6` on a counter: `x / 64`. -/
theorem ofNat_ushiftRight_6 (h : k < 2 ^ 64) :
    BitVec.ofNat 64 k >>> 6 = BitVec.ofNat 64 (k / 64) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow,
    Nat.mod_eq_of_lt h, Nat.mod_eq_of_lt (by omega)]

/-- `d < half`, as `d>>bits == 0`. -/
theorem ushiftRight_eq_zero_iff (d : BitVec 64) : d >>> B = 0#64 ↔ d.toNat < 2 ^ B := by
  rw [← BitVec.toNat_inj, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_zero,
    Nat.div_eq_zero_iff_lt (Nat.two_pow_pos B)]

/-- `(short)d`. -/
theorem setWidth_eq_ofInt (d : BitVec 64) : d.setWidth 16 = BitVec.ofInt 16 (d.toNat : Int) := by
  rw [BitVec.ofInt_natCast]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]

/-- `(short)((long)d - (long)(mask+1UL))`. -/
theorem setWidth_sub_eq_ofInt (d : BitVec 64) (h : B ≤ 12) :
    (d - 1#64 <<< (B + 1)).setWidth 16 = BitVec.ofInt 16 ((d.toNat : Int) - 2 ^ (B + 1)) := by
  have hsub : ∀ y : BitVec 64, (d - y).setWidth 16 = d.setWidth 16 - y.setWidth 16 := by
    intro y
    bv_decide
  have hpow : ∀ k < 14, (1#64 <<< k).setWidth 16 = BitVec.ofInt 16 (2 ^ k) := by decide
  rw [hsub, hpow _ (by omega), setWidth_eq_ofInt, Int.sub_eq_add_neg, BitVec.ofInt_add,
    BitVec.ofInt_neg, BitVec.sub_eq_add_neg]

/-- The registers at `^bb10`: `d` and `pos`. -/
abbrev hdr10 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (p : Nat) (d : BitVec 64) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1732 := .value (BitVec.ofNat 64 p), %1743 := .value d]

/-- `^bb10`, the window cleared from `n`: `_t[pos]` set, the carry, then `^bb15` at `pos+wid`. -/
theorem fd_curve25519_scalar_wnaf.store_digit (slides scalar v : Pointer) (bits : BitVec 32)
    (B : Nat) (hB : B ≤ 12) (Sb : GlobalState) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (p : Nat) (hp : p < 256)
    (n : BitVec 320) (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get)
    (hK :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = E.args →
          (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (p + (B + 1))) ^bb15
                (st slides v (digit B n t p hp).2 (digit B n t p hp).1 Sb) >>=
              g) =
            K) :
    (fd_curve25519_scalar_wnaf.runFrom (hdr10 v B E p ((n >>> p).setWidth 64 &&& mask B)) ^bb10
          (st slides v t (n &&& ~~~((mask B).setWidth 320 <<< p)) Sb) >>=
        g) =
      K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hso' : slides.offset.toNat + 512 < 2 ^ 64 := by
    have := hso
    simp [BitVec.uaddOverflow] at this
    omega
  block_init
  seal_env
  -- `if( d<half )`
  step_pure [Nat.mod_eq_of_lt (show B < 2 ^ 64 by omega), show ¬64 ≤ B by omega]
  step_pure
  finish_block
  · -- `_t[pos] = (short)d;`
    rw [ushiftRight_eq_zero_iff] at hbr
    block_init
    step_pure
    step_pure [Nat.mod_eq_of_lt (show p < 2 ^ 64 by omega), show p * 2 = 2 * p by omega,
      show 2 * p < 2 ^ 64 by omega]
    step_store
    rw [storeAt_shorts hne hso hp (val := ((n >>> p).setWidth 64 &&& mask B).toNat)
        (by
          rw [← setWidth_eq_ofInt]; simp)] at hS
    step_pure [← BitVec.ofNat_add]
    finish_block
    simp only [digit, hbr, ↓reduceIte] at hK
    step_loop using hK
  · -- `_t[pos] = (short)((long)d - (long)(mask+1UL));`, the carry from `pos+wid`
    rw [ushiftRight_eq_zero_iff] at hbr
    block_init
    step_pure
    step_pure
    step_pure [Nat.mod_eq_of_lt (show p < 2 ^ 64 by omega), show p * 2 = 2 * p by omega,
      show 2 * p < 2 ^ 64 by omega]
    step_store
    rw [storeAt_shorts hne hso hp (val := ((n >>> p).setWidth 64 &&& mask B).toNat - 2 ^ (B + 1))
        (by rw [← setWidth_sub_eq_ofInt _ hB])] at hS
    step_pure [← BitVec.ofNat_add]
    step_pure [ult_ofNat64 (show p + (B + 1) < 2 ^ 64 by omega) (show 320 < 2 ^ 64 by omega),
      show p + (B + 1) < 320 by omega]
    finish_block
    block_init
    step_pure [ofNat_and_63]
    step_pure [ofNat_ushiftRight_6 (show p + (B + 1) < 2 ^ 64 by omega)]
    finish_block
    simp only [digit, hbr, ↓reduceIte] at hK
    step_loop using
      fd_curve25519_scalar_wnaf.carry_loop slides scalar v bits B (p + (B + 1)) Sb hfv hwv hv _ g K
        (4 - (p + (B + 1)) / 64) ((p + (B + 1)) / 64) ((p + (B + 1)) % 64) _ _ _ (by omega)
        (by omega)
    rw [show 64 * ((p + (B + 1)) / 64) + (p + (B + 1)) % 64 = p + (B + 1) by omega] at hS
    step_loop using hK

/-- `64 - b`, `nsw nuw`. -/
theorem sub_64 (h : b ≤ 64) :
    (64#64).ssubOverflow (BitVec.ofNat 64 b) = false ∧
      (64#64).usubOverflow (BitVec.ofNat 64 b) = false ∧
      64#64 - BitVec.ofNat 64 b = BitVec.ofNat 64 (64 - b) := by
  have :
    ∀ k < 65,
      (64#64).ssubOverflow (BitVec.ofNat 64 k) = false ∧
        (64#64).usubOverflow (BitVec.ofNat 64 k) = false ∧
        64#64 - BitVec.ofNat 64 k = BitVec.ofNat 64 (64 - k) := by
    decide
  exact this b (by omega)

/-- The registers at `^bb8`: `n[w]`, `pos`, `b`, `&n[w]`, and `lo`. -/
abbrev hdr8 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (n : BitVec 320)
    (w b : Nat) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1726 := .value (n.extractLsb' (64 * w) 64), %1732 :=
    .value (BitVec.ofNat 64 (64 * w + b)), %1733 := .value (BitVec.ofNat 64 b), %1734 :=
    .value (v.add (BitVec.ofNat 64 (8 * w))), %1742 := .value ((n >>> (64 * w + b)).setWidth 64)]

/-- `^bb8`, `lo` read at `pos = 64 w + b`: `d`, the window cleared from `n[w]` (and `n[w+1]`), then
`^bb10`. -/
theorem fd_curve25519_scalar_wnaf.clear_window (slides scalar v : Pointer) (bits : BitVec 32)
    (B : Nat) (hB : B ≤ 12) (Sb : GlobalState) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (w b : Nat) (hw : w < 4)
    (hb : b < 64) (n : BitVec 320) (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get)
    (hK :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = E.args →
          (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (64 * w + b + (B + 1))) ^bb15
                (st slides v (digit B n t (64 * w + b) (by omega)).2
                  (digit B n t (64 * w + b) (by omega)).1 Sb) >>=
              g) =
            K) :
    (fd_curve25519_scalar_wnaf.runFrom (hdr8 v B E n w b) ^bb8 (st slides v t n Sb) >>= g) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  block_init
  seal_env
  -- `d = lo & mask; n[w] &= ~(mask<<b);`
  step_pure
  step_pure [Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega), show ¬64 ≤ b by omega]
  step_pure
  step_pure
  step_store
  rw [storeAt_limb hv (show w < 5 by omega)] at hS
  -- `if( b>64UL-wid ) n[w+1] &= ~(mask>>(64UL-b));`
  step_pure [ult_ofNat64 (show 63 - B < 2 ^ 64 by omega) (show b < 2 ^ 64 by omega)]
  finish_block
  · simp only [decide_eq_true_eq] at hbr
    obtain ⟨h1, h2, h3⟩ := sub_64 (b := b) (by omega)
    block_init
    step_pure [h1, h2, h3]
    step_pure [Nat.mod_eq_of_lt (show 64 - b < 2 ^ 64 by omega), show ¬64 ≤ 64 - b by omega]
    step_pure
    step_pure [Pointer.add_add, ← BitVec.ofNat_add, show 8 * w + 8 = 8 * (w + 1) by omega]
    have hw1 : w + 1 < 5 := by omega
    step_load
    step_pure
    step_store
    rw [storeAt_limb hv hw1, clear_spill n hw (by omega) hb hB] at hS
    finish_block
    step_loop using
      fd_curve25519_scalar_wnaf.store_digit slides scalar v bits B hB Sb hfs hws hso hfv hwv hv hne
        g K (64 * w + b) (by omega) n t
    step_loop using hK
  · simp only [decide_eq_true_eq] at hbr
    rw [clear_one n hw (by omega) hB] at hS
    step_loop using
      fd_curve25519_scalar_wnaf.store_digit slides scalar v bits B hB Sb hfs hws hso hfv hwv hv hne
        g K (64 * w + b) (by omega) n t
    step_loop using hK

/-- `ctz` of a non-zero `y >> b0` stays within `y`'s 64 bits. -/
theorem ctz_ushiftRight_lt {y : BitVec 64} (h : y >>> b0 ≠ 0#64) :
    b0 + (y >>> b0).ctz.toNat < 64 := by
  have h1 := BitVec.getLsbD_true_ctz_of_ne_zero h
  rw [BitVec.getLsbD_ushiftRight] at h1
  by_contra hc
  rw [BitVec.getLsbD_of_ge _ _ (by omega)] at h1
  exact absurd h1 (by decide)

/-- `pos += find_lsb(x)`: `nsw`, and the sum. -/
theorem add_ctz (x : BitVec 64) (h : base < 256) :
    (BitVec.ofNat 64 base).saddOverflow x.ctz = false ∧
      BitVec.ofNat 64 base + x.ctz = BitVec.ofNat 64 (base + x.ctz.toNat) := by
  have hc : x.ctz ≤ 64#64 := BitVec.ctz_eq_reverse_clz ▸ BitVec.clz_le
  have hb : BitVec.ofNat 64 base < 256#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; simp; omega
  constructor
  · generalize BitVec.ofNat 64 base = a at hb
    generalize x.ctz = c at hc
    bv_decide
  · rw [BitVec.ofNat_add, BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- The registers at `^bb6`: `n[w]`, `x = n[w]>>b0`, `w`, and `pos - (pos&63) + b0`. -/
abbrev hdr6 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (n : BitVec 320)
    (w base : Nat) (x : BitVec 64) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1726 := .value (n.extractLsb' (64 * w) 64), %1727 := .value x, %1728 :=
    .value (BitVec.ofNat 64 w), %1729 := .value (BitVec.ofNat 64 base)]

/-- `^bb6`, `x = n[w]>>b0` non-zero: `pos = 64 w + b0 + find_lsb(x)`, `lo`, then `^bb8`. -/
theorem fd_curve25519_scalar_wnaf.read_window (slides scalar v : Pointer) (bits : BitVec 32)
    (B : Nat) (hB : B ≤ 12) (Sb : GlobalState) (hwf : Sb.WF) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (w b0 b base : Nat)
    (hbase : base = 64 * w + b0) (hw : w < 4) (n : BitVec 320) (t : Vector Int 256) (x : BitVec 64)
    (hx : x = n.extractLsb' (64 * w) 64 >>> b0) (hx0 : x ≠ 0#64) (hb : b0 + x.ctz.toNat = b)
    (hb64 : b < 64) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get)
    (hK :
      ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
        E'.args = E.args →
          (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (64 * w + b + (B + 1))) ^bb15
                (st slides v (digit B n t (64 * w + b) (by omega)).2
                  (digit B n t (64 * w + b) (by omega)).1 Sb) >>=
              g) =
            K) :
    (fd_curve25519_scalar_wnaf.runFrom (hdr6 v B E n w base x) ^bb6 (st slides v t n Sb) >>= g) =
      K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  subst hx hbase
  have hw1 : w + 1 < 5 := by omega
  block_init
  seal_env
  -- `pos += find_lsb( x );`
  step_call using fd_ulong_find_lsb.call_eq
  step_pure [fd_ulong_find_lsb.spec, hx0, (fd_ulong_find_lsb.ctz_trunc _).2]
  step_pure [(add_ctz _ (show 64 * w + b0 < 256 by omega)).1,
    (add_ctz _ (show 64 * w + b0 < 256 by omega)).2, Nat.add_assoc, hb]
  -- `b = pos&63; lo = n[w]>>b;`
  step_pure [ofNat_and_63, show (64 * w + b) % 64 = b by omega]
  step_pure [Nat.mod_eq_of_lt (show w < 2 ^ 64 by omega), show w * 8 = 8 * w by omega,
    show 8 * w < 2 ^ 64 by omega]
  step_pure [Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega), show ¬64 ≤ b by omega]
  step_pure
  finish_block
  · -- `b == 0`: `lo = n[w]`
    obtain rfl : b = 0 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega)] at this
      exact this
    step_loop using
      fd_curve25519_scalar_wnaf.clear_window slides scalar v bits B hB Sb hfs hws hso hfv hwv hv hne
        g K w 0 hw (by omega) n t
    step_loop using hK
  · -- `lo |= n[w+1]<<(64UL-b);`
    have hb0 : 0 < b := by
      rcases Nat.eq_zero_or_pos b with h | h
      · exact absurd (by rw [h]) hbr
      · exact h
    obtain ⟨h1, h2, h3⟩ := sub_64 (b := b) (by omega)
    obtain ⟨hd, hlo⟩ := window_spec n hw hb0 hb64
    block_init
    step_pure [Pointer.add_add, ← BitVec.ofNat_add, show 8 * w + 8 = 8 * (w + 1) by omega]
    step_load
    step_pure [h1, h2, h3]
    step_pure [Nat.mod_eq_of_lt (show 64 - b < 2 ^ 64 by omega), show ¬64 ≤ 64 - b by omega]
    step_pure [hd, hlo]
    finish_block
    step_loop using
      fd_curve25519_scalar_wnaf.clear_window slides scalar v bits B hB Sb hfs hws hso hfv hwv hv hne
        g K w b hw hb64 n t
    step_loop using hK

/-! ### The scan -/

/-- `nextBit` finds the set bit `j` when none lies between `k` and `j`. -/
theorem nextBit_eq_of_set {n : BitVec 320} (hkj : k ≤ j) (hj : j < 256) (h : n.getLsbD j = true)
    (hz : ∀ i, k ≤ i → i < j → n.getLsbD i = false) (hf : 256 ≤ k + fuel) :
    nextBit n fuel k = j := by
  induction fuel generalizing k with
  | zero => omega
  | succ fuel ih =>
    simp only [nextBit, show k < 256 by omega, ite_true]
    split
    next hk =>
      by_contra hne
      exact absurd (hz k le_rfl (by omega)) (by simp [hk])
    next hk =>
      exact
        ih
          (by
            rcases Nat.lt_or_ge k j with h' | h'
            · omega
            · obtain rfl : k = j := by omega
              simp [h] at hk)
          (fun i h1 h2 => hz i (by omega) h2) (by omega)

/-- `nextBit` is `256` when no bit is set from `k` on. -/
theorem nextBit_eq_none {n : BitVec 320} (hz : ∀ i, k ≤ i → i < 256 → n.getLsbD i = false) :
    nextBit n fuel k = 256 := by
  induction fuel generalizing k with
  | zero => rfl
  | succ fuel ih =>
    simp only [nextBit]
    split
    next hk =>
      rw [hz k le_rfl hk]; exact ih fun i h1 h2 => hz i (by omega) h2
    · rfl

/-- Bit `i` of `n[w]>>b0`. -/
theorem getLsbD_limb_shift (n : BitVec 320) :
    (n.extractLsb' (64 * w) 64 >>> b0).getLsbD i =
      (decide (b0 + i < 64) && n.getLsbD (64 * w + (b0 + i))) := by
  simp only [BitVec.getLsbD_ushiftRight, BitVec.getLsbD_extractLsb']

/-- `n[w]>>b0 == 0`: no set bit of `n` from `64 w + b0` to the end of `n[w]`. -/
theorem limb_shift_eq_zero {n : BitVec 320} (h : n.extractLsb' (64 * w) 64 >>> b0 = 0#64) :
    ∀ i, 64 * w + b0 ≤ i → i < 64 * w + 64 → n.getLsbD i = false := by
  intro i h1 h2
  have := getLsbD_limb_shift (w := w) (b0 := b0) (i := i - (64 * w + b0)) n
  rw [h, BitVec.getLsbD_zero, show 64 * w + (b0 + (i - (64 * w + b0))) = i by omega] at this
  simpa [show b0 + (i - (64 * w + b0)) < 64 by omega] using this.symm

/-- `pos += find_lsb(x)` for `x = n[w]>>b0 ≠ 0`, nothing set from `pos` to `64 w + b0`: the next set
bit. -/
theorem nextBit_limb_shift {n : BitVec 320} (hw : w < 4) (hpos : pos ≤ 64 * w + b0)
    (hz : ∀ i, pos ≤ i → i < 64 * w + b0 → n.getLsbD i = false)
    (hx0 : n.extractLsb' (64 * w) 64 >>> b0 ≠ 0#64) :
    nextBit n 256 pos = 64 * w + (b0 + (n.extractLsb' (64 * w) 64 >>> b0).ctz.toNat) := by
  have hlt := ctz_ushiftRight_lt hx0
  have h1 := BitVec.getLsbD_true_ctz_of_ne_zero hx0
  rw [getLsbD_limb_shift] at h1
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h1
  refine nextBit_eq_of_set (by omega) (by omega) h1.2 (fun i h2 h3 => ?_) (by omega)
  by_cases hi : i < 64 * w + b0
  · exact hz i h2 hi
  · have h4 :=
      BitVec.getLsbD_false_of_lt_ctz (x := n.extractLsb' (64 * w) 64 >>> b0) (i :=
        i - (64 * w + b0)) (by omega)
    rw [getLsbD_limb_shift, show 64 * w + (b0 + (i - (64 * w + b0))) = i by omega] at h4
    simpa [show b0 + (i - (64 * w + b0)) < 64 by omega] using h4

/-! ### The loop -/

/-- An iteration of `loop` at the next set bit `p`. -/
theorem loop_succ_some {n : BitVec 320} {t : Vector Int 256} (h : nextBit n 256 pos = p)
    (hp : p < 256) :
    loop B (f + 1) n t pos = loop B f (digit B n t p hp).1 (digit B n t p hp).2 (p + (B + 1)) := by
  subst h
  simp only [loop, hp, dite_true]

/-- `loop` with no set bit left. -/
theorem loop_succ_none {n : BitVec 320} {t : Vector Int 256} (h : nextBit n 256 pos = 256) :
    loop B (f + 1) n t pos = t := by simp only [loop, h, lt_irrefl, dite_false]

/-- `loop` past `_t`. -/
theorem loop_ge {n : BitVec 320} {t : Vector Int 256} (h : 256 ≤ pos) : loop B f n t pos = t := by
  cases f with
  | zero => rfl
  | succ f => exact loop_succ_none (nextBit_eq_none fun i h1 h2 => by omega)

/-- `x << 6` on a counter: `64 x`, `nsw nuw`. -/
theorem shl_6 (h : w < 4) :
    BitVec.ofNat 64 (64 * w) >>> 6 = BitVec.ofNat 64 w ∧
      (BitVec.ofNat 64 (64 * w)).sshiftRight 6 = BitVec.ofNat 64 w ∧
      BitVec.ofNat 64 w <<< 6 = BitVec.ofNat 64 (64 * w) := by
  have :
    ∀ k < 4,
      BitVec.ofNat 64 (64 * k) >>> 6 = BitVec.ofNat 64 k ∧
        (BitVec.ofNat 64 (64 * k)).sshiftRight 6 = BitVec.ofNat 64 k ∧
        BitVec.ofNat 64 k <<< 6 = BitVec.ofNat 64 (64 * k) := by
    decide
  exact this w h

/-- The registers at `^bb16`, the return. -/
abbrev hdr16 (v : Pointer) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) : ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  E[%1693 := .value v]

/-- The registers at `^bb4`, the scan, past word `w`. -/
abbrev hdr4 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (w : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1720 := .value (BitVec.ofNat 64 w)]

/-- One step of `^bb4`, `do { if( ++w>=4UL ) return; x = n[w]; } while( !x );`, past word `w < 3`,
nothing set from `pos` on: to `^bb16` if no set bit is left, through `^bb6` to `^bb15` at a set bit
in `n[w+1]`, or on past `w+1`. -/
theorem fd_curve25519_scalar_wnaf.scan_iter (slides scalar v : Pointer) (bits : BitVec 32) (B : Nat)
    (hB : B ≤ 12) (Sb : GlobalState) (hwf : Sb.WF) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (pos : Nat)
    (n : BitVec 320) (t : Vector Int 256)
    (hK16 :
      nextBit n 256 pos = 256 →
        ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args =
              (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
            (fd_curve25519_scalar_wnaf.runFrom (hdr16 v E') ^bb16 (st slides v t n Sb) >>= g) = K)
    (hK15 :
      ∀ p (hp : p < 256),
        nextBit n 256 pos = p →
          ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
            E'.args =
                (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
              (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (p + (B + 1))) ^bb15
                    (st slides v (digit B n t p hp).2 (digit B n t p hp).1 Sb) >>=
                  g) =
                K)
    (w : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫)
    (hArgs :
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get)
    (hw : w < 3) (hpos : pos ≤ 64 * (w + 1))
    (hz : ∀ i, pos ≤ i → i < 64 * (w + 1) → n.getLsbD i = false)
    (hnext :
      w + 1 < 3 →
        (∀ i, pos ≤ i → i < 64 * (w + 1 + 1) → n.getLsbD i = false) →
        ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args =
              (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
            (fd_curve25519_scalar_wnaf.runFrom (hdr4 v B E' (w + 1)) ^bb4 (st slides v t n Sb) >>=
                g) =
              K) :
    (fd_curve25519_scalar_wnaf.runFrom (hdr4 v B E w) ^bb4 (st slides v t n Sb) >>= g) = K := by
  have hw1 : w + 1 < 5 := by omega
  block_init
  seal_env
  -- `++w; x = n[w];`
  step_pure [saddOverflow_one64 (i := w) (by omega), uaddOverflow_one64 (i := w) (by omega),
    ← BitVec.ofNat_add]
  step_pure [Nat.mod_eq_of_lt (show w + 1 < 2 ^ 64 by omega),
    show (w + 1) * 8 = 8 * (w + 1) by omega, show 8 * (w + 1) < 2 ^ 64 by omega]
  step_load
  step_pure
  finish_block
  · -- `!x`: `w>=4UL`, or on
    have hz' : ∀ i, pos ≤ i → i < 64 * (w + 1 + 1) → n.getLsbD i = false := fun i h1 h2 => by
      by_cases hi : i < 64 * (w + 1)
      · exact hz i h1 hi
      · exact
          limb_shift_eq_zero (w := w + 1) (b0 := 0) (n := n)
            (by
              rw [BitVec.ushiftRight_zero]; exact hbr)
            i (by omega) (by omega)
    block_init
    step_pure
    finish_block
    · have h3 : w + 1 = 3 := by
        have := congrArg BitVec.toNat hbr
        simp only [BitVec.toNat_ofNat] at this
        omega
      step_loop using hK16 (nextBit_eq_none fun i h1 h2 => hz' i h1 (by omega))
    · have h3 : w + 1 < 3 := by
        rcases Nat.lt_or_ge (w + 1) 3 with h | h
        · exact h
        · exact absurd (by rw [show w + 1 = 3 by omega]) hbr
      step_loop using hnext h3 hz'
  · -- `pos = w<<6`
    have hx0 : n.extractLsb' (64 * (w + 1)) 64 >>> 0 ≠ 0#64 := by
      rw [BitVec.ushiftRight_zero]; exact hbr
    obtain ⟨h1, h2, h3⟩ := shl_6 (w := w + 1) (by omega)
    block_init
    step_pure [h1, h2, h3]
    finish_block
    step_loop using
      fd_curve25519_scalar_wnaf.read_window slides scalar v bits B hB Sb hwf hfs hws hso hfv hwv hv
        hne g K (w + 1) 0 _ (64 * (w + 1)) (by omega) (by omega) n t _
        (BitVec.ushiftRight_zero _).symm hbr rfl
        (by
          have := ctz_ushiftRight_lt hx0; rwa [BitVec.ushiftRight_zero] at this)
    have hn :=
      nextBit_limb_shift (pos := pos) (by omega) (by omega) (fun i h1 h2 => hz i h1 (by omega)) hx0
    rw [BitVec.ushiftRight_zero] at hn
    step_loop using hK15 _ _ hn

/-- `^bb4`, the scan, past word `w = 2 - m`, nothing set from `pos` on: to `^bb16` or `^bb15`. -/
theorem fd_curve25519_scalar_wnaf.scan_loop (slides scalar v : Pointer) (bits : BitVec 32) (B : Nat)
    (hB : B ≤ 12) (Sb : GlobalState) (hwf : Sb.WF) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (pos : Nat)
    (n : BitVec 320) (t : Vector Int 256)
    (hK16 :
      nextBit n 256 pos = 256 →
        ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args =
              (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
            (fd_curve25519_scalar_wnaf.runFrom (hdr16 v E') ^bb16 (st slides v t n Sb) >>= g) = K)
    (hK15 :
      ∀ p (hp : p < 256),
        nextBit n 256 pos = p →
          ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
            E'.args =
                (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
              (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (p + (B + 1))) ^bb15
                    (st slides v (digit B n t p hp).2 (digit B n t p hp).1 Sb) >>=
                  g) =
                K) :
    ∀ m w (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
        w + m = 2 →
        pos ≤ 64 * (w + 1) →
        (∀ i, pos ≤ i → i < 64 * (w + 1) → n.getLsbD i = false) →
        (fd_curve25519_scalar_wnaf.runFrom (hdr4 v B E w) ^bb4 (st slides v t n Sb) >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro w E hArgs hm hpos hz
    exact
      fd_curve25519_scalar_wnaf.scan_iter slides scalar v bits B hB Sb hwf hfs hws hso hfv hwv hv
        hne g K pos n t hK16 hK15 w E hArgs (by omega) hpos hz fun h => absurd h (by omega)
  | succ m ih =>
    intro w E hArgs hm hpos hz
    exact
      fd_curve25519_scalar_wnaf.scan_iter slides scalar v bits B hB Sb hwf hfs hws hso hfv hwv hv
        hne g K pos n t hK16 hK15 w E hArgs (by omega) hpos hz fun _ hz' E' h =>
        ih (w + 1) E' h (by omega) (by omega) hz'

/-- `nextBit` from `k ≤ 256` is at least `k`. -/
public theorem fd_curve25519_scalar_wnaf.le_nextBit {n : BitVec 320} (hk : k ≤ 256) :
    k ≤ nextBit n fuel k := by
  induction fuel generalizing k with
  | zero => exact hk
  | succ fuel ih =>
    simp only [nextBit]
    split
    · split
      · exact le_rfl
      · exact Nat.le_of_succ_le (ih (by omega))
    · exact hk

/-- The registers at `^bb1`, the `for( pos … )` loop, at `pos`. -/
abbrev hdr1 (v : Pointer) (B : Nat) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (pos : Nat) :
    ⟪fd_curve25519_scalar_wnaf.Γ⟫ :=
  (consts v B E)[%1711 := .value (BitVec.ofNat 64 pos)]

/-- `^bb1`, the `for( pos … )` loop, at `pos < 256` with fuel `f`: `_t` and `n` as `loop` leaves
them, then `^bb16`. -/
theorem fd_curve25519_scalar_wnaf.main_loop (slides scalar v : Pointer) (bits : BitVec 32) (B : Nat)
    (hB : B ≤ 12) (Sb : GlobalState) (hwf : Sb.WF) (hfs : Fits Sb.mem slides (8 * 512))
    (hws : Writable Sb.mem slides) (hso : ¬slides.offset.uaddOverflow 512#64)
    (hfv : Fits Sb.mem v 320) (hwv : Writable Sb.mem v) (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ f pos (n : BitVec 320) (t : Vector Int 256) (E : ⟪fd_curve25519_scalar_wnaf.Γ⟫),
      E.args = (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
        pos < 256 →
        256 ≤ pos + f →
        (∀ (E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫) (n' : BitVec 320),
          E'.args =
              (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
            (fd_curve25519_scalar_wnaf.runFrom (hdr16 v E') ^bb16
                  (st slides v (loop B f n t pos) n' Sb) >>=
                g) =
              K) →
        (fd_curve25519_scalar_wnaf.runFrom (hdr1 v B E pos) ^bb1 (st slides v t n Sb) >>= g) =
          K := by
  intro f
  induction f with
  | zero =>
    intro pos n t E _ hpos hf
    omega
  | succ f ih =>
    intro pos n t E hArgs hpos hf hK
    -- `pos += wid`, at the next set bit
    have hK15 :
      ∀ p (hp : p < 256),
        nextBit n 256 pos = p →
          ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
            E'.args =
                (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
              (fd_curve25519_scalar_wnaf.runFrom (hdr15 v B E' (p + (B + 1))) ^bb15
                    (st slides v (digit B n t p hp).2 (digit B n t p hp).1 Sb) >>=
                  g) =
                K := by
      intro p hp hnp E' hArgs
      have hpp : pos ≤ p := hnp ▸ le_nextBit (by omega)
      rw [loop_succ_some hnp hp] at hK
      block_init
      step_pure [ult_ofNat64 (show p + (B + 1) < 2 ^ 64 by omega) (show 256 < 2 ^ 64 by omega)]
      finish_block
      · step_loop using ih (p + (B + 1)) _ _ _ _ (by simpa using hbr) (by omega)
        step_loop using hK
      · rw [loop_ge (by simpa using hbr)] at hK
        step_loop using hK
    have hK16 :
      nextBit n 256 pos = 256 →
        ∀ E' : ⟪fd_curve25519_scalar_wnaf.Γ⟫,
          E'.args =
              (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)).get →
            (fd_curve25519_scalar_wnaf.runFrom (hdr16 v E') ^bb16 (st slides v t n Sb) >>= g) = K :=
      fun h E' h' => by
      rw [loop_succ_none h] at hK
      exact hK E' n h'
    clear hK
    obtain ⟨w, b0, rfl, hb0⟩ : ∃ w b0, pos = 64 * w + b0 ∧ b0 < 64 :=
      ⟨pos / 64, pos % 64, by omega, by omega⟩
    have hw : w < 4 := by omega
    block_init
    seal_env
    -- `ulong w = pos>>6; ulong x = n[w]>>(pos&63UL);`
    step_pure [ofNat_ushiftRight_6 (show 64 * w + b0 < 2 ^ 64 by omega),
      show (64 * w + b0) / 64 = w by omega]
    step_pure [Nat.mod_eq_of_lt (show w < 2 ^ 64 by omega), show w * 8 = 8 * w by omega,
      show 8 * w < 2 ^ 64 by omega]
    step_load
    step_pure [ofNat_and_63, show (64 * w + b0) % 64 = b0 by omega]
    step_pure [Nat.mod_eq_of_lt (show b0 < 2 ^ 64 by omega), show ¬64 ≤ b0 by omega]
    step_pure
    finish_block
    · -- `!x`: the scan
      have hz := limb_shift_eq_zero hbr
      block_init
      step_pure
      finish_block
      · have h3 : w = 3 := by
          have := congrArg BitVec.toNat hbr
          simp only [BitVec.toNat_ofNat] at this
          omega
        step_loop using hK16 (nextBit_eq_none fun i h1 h2 => hz i h1 (by omega))
      · have h3 : w < 3 := by
          rcases Nat.lt_or_ge w 3 with h | h
          · exact h
          · exact absurd (by rw [show w = 3 by omega]) hbr
        step_loop using
          fd_curve25519_scalar_wnaf.scan_loop slides scalar v bits B hB Sb hwf hfs hws hso hfv hwv
            hv hne g K (64 * w + b0) n t hK16 hK15 (2 - w) w _ _ (by omega) (by omega)
            (fun i h1 h2 => hz i h1 (by omega))
    · -- `pos += find_lsb( x );`
      have hlt := ctz_ushiftRight_lt hbr
      step_loop using
        fd_curve25519_scalar_wnaf.read_window slides scalar v bits B hB Sb hwf hfs hws hso hfv hwv
          hv hne g K w b0 _ (64 * w + b0) rfl hw n t _ rfl hbr rfl (by omega)
      step_loop using hK15 _ _ (nextBit_limb_shift hw le_rfl (fun i h1 h2 => by omega) hbr)

/-! ### The function -/

/-- `n` as `bb0` stores it, limb by limb, and `memset( _t, 0, 512 )`: `n0 x` and zero digits,
stored over a zeroed `_t` and `n`. -/
theorem init_eq {m : MemoryState} {slides v : Pointer} (hv : v.offset = 0) (hne : slides.id ≠ v.id)
    (x : BitVec 256) :
    ((((((m.storeAt v (x.setWidth 64)).storeAt (v.add 8#64) (x.extractLsb' 64 64)).storeAt
                    (v.add 16#64) (x.extractLsb' 128 64)).storeAt
                (v.add 24#64) (x.extractLsb' 192 64 &&& 9223372036854775807#64)).storeAt
            (v.add 32#64) 0#64).storeAt
        slides 0#4096) =
      ((((m.storeAt slides 0#4096).storeAt v 0#320).storeAt slides
            (shorts (Vector.replicate 256 0))).storeAt
        v (n0 x)) := by
  have hov : ∀ k : Nat, k ≤ 32 → ¬v.offset.uaddOverflow (BitVec.ofNat 64 k) := fun k hk => by
    simp only [BitVec.uaddOverflow, hv, BitVec.toNat_ofNat]
    simp
    omega
  have hz : (0#4096 : BitVec (16 * 256)) = shorts (Vector.replicate 256 0) := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    have h :=
      BitVec.extractLsb'_packLanes_of_lt ((Vector.replicate 256 (0 : Int)).map (BitVec.ofInt 16))
        (s := i) (w := 1) (by omega) (by omega)
    have h' := congrArg (·.getLsbD 0) h
    simp only [BitVec.getLsbD_extractLsb', Vector.getElem_map, Vector.getElem_replicate] at h'
    simp only [shorts, BitVec.getLsbD_zero]
    simpa using h'.symm
  have hd : (Range.of v 320).Disjoint (Range.of slides (16 * 256)) := .inl (Ne.symm hne)
  have hR :
    (((m.storeAt slides 0#4096).storeAt v 0#320).storeAt slides
            (shorts (Vector.replicate 256 0))).storeAt
        v (n0 x) =
      (m.storeAt slides (shorts (Vector.replicate 256 0))).storeAt v (n0 x) := by
    rw [MemoryState.storeAt_comm hd, MemoryState.storeAt_storeAt_self,
      MemoryState.storeAt_storeAt_self]
  rw [hR, show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl,
    MemoryState.storeAt_storeAt_append (hov 8 (by omega)) rfl (by decide),
    show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    MemoryState.storeAt_storeAt_append (hov 16 (by omega)) rfl (by decide),
    show (24#64 : BitVec 64) = BitVec.ofNat 64 24 from rfl,
    MemoryState.storeAt_storeAt_append (hov 24 (by omega)) rfl (by decide),
    show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    MemoryState.storeAt_storeAt_append (hov 32 (by omega)) rfl (by decide),
    MemoryState.storeAt_comm (.inl (by simpa [Range.of] using Ne.symm hne)), hz]
  congr 1
  simp only [n0]
  bv_decide

/-- `fd_curve25519_scalar_wnaf( slides, s, bits )` stores `spec` of the 256-bit scalar at `scalar`
as the 256 `short`s at `slides`, for `bits` in the documented range `1 … 12`; its `ulong n[5]` is
a frame slot. -/
public theorem fd_curve25519_scalar_wnaf.call_eq (slides scalar : Pointer) (bits : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hslides : Room s.mem slides (8 * 512))
    (hso : ¬slides.offset.uaddOverflow 512#64) (hscalar : Fits s.mem scalar (8 * 32))
    (hco : ¬scalar.offset.uaddOverflow 32#64) (hbits : 1 ≤ bits.toNat ∧ bits.toNat ≤ 12) :
    fd_curve25519_scalar_wnaf.call
        (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem :=
              s.mem.storeAt slides
                (fd_curve25519_scalar_wnaf.spec (s.mem.readAt scalar 256) bits.toNat) }) := by
  func_init
  obtain ⟨x, hx⟩ : ∃ x, S₀.mem.readAt scalar 256 = x := ⟨_, rfl⟩
  have hxS : S.mem.readAt scalar 256 = x := hS ▸ hx
  rw [hx]
  obtain ⟨B, hB⟩ : ∃ B, bits.toNat = B := ⟨_, rfl⟩
  rw [hB] at hbits ⊢
  block_init
  iterate 15 step_pure
  step_alloca with v
  -- its lifetime starts
  step_pure
  clear hv_bounds
  -- `ulong n[5] = { … };`
  step_call using fd_ulong_load_8.call_eq
  step_store
  iterate 2 step_pure
  step_call using fd_ulong_load_8.call_eq
  step_store
  iterate 2 step_pure
  step_call using fd_ulong_load_8.call_eq
  step_store
  iterate 2 step_pure
  step_call using fd_ulong_load_8.call_eq
  step_pure
  step_store
  step_pure
  step_store
  -- `memset( _t, 0, 256UL*sizeof(short) );`
  step_memset
  rw [init_eq hv_off hslides_ne_v x] at hS
  -- `wid`, `mask`, `half`
  step_pure [signExtend_toNat32 (b := bits) (by omega), hB]
  step_pure [saddOverflow_one64 (i := B) (by omega), ← BitVec.ofNat_add]
  step_pure [Nat.mod_eq_of_lt (show B + 1 < 2 ^ 64 by omega), show ¬64 ≤ B + 1 by omega,
    shl_one_ushiftRight (k := B + 1) (by omega)]
  step_pure [add_allOnes_eq_mask]
  step_pure [(ssubOverflow_63 (B := B) (by omega)).1, (ssubOverflow_63 (B := B) (by omega)).2]
  finish_block
  clear_reads
  step_loop using
    fd_curve25519_scalar_wnaf.main_loop slides scalar v bits B (by omega)
      { alloc := (S₀.alloca 40 true).alloc,
        mem := (((S₀.alloca 40 true).mem.lifetimeStart v).storeAt slides 0#4096).storeAt v 0#320 }
      _ _ _ hso _ _ hv_off hslides_ne_v _ _ 256 0 (n0 x) (Vector.replicate 256 0) _ _ (by omega)
      (by omega)
  -- `return`
  block_init
  step_pure
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeAt_storeAt_self]
  rfl

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

/-- `nextBit` below `256` is a set bit. -/
public theorem getLsbD_nextBit {n : BitVec 320} (h : nextBit n fuel k < 256) :
    n.getLsbD (nextBit n fuel k) = true := by
  induction fuel generalizing k with
  | zero => exact absurd h (by simp [nextBit])
  | succ fuel ih =>
    by_cases hk : k < 256
    · by_cases hb : n.getLsbD k = true
      · simp only [nextBit, hk, hb, ite_true]
      · simp only [nextBit, hk, hb, ite_true, Bool.false_eq_true, ite_false] at h ⊢
        exact ih h
    · simp [nextBit, hk] at h

/-- `mask` is `2^wid - 1`, all ones from `wid = 64` on. -/
public theorem toNat_mask : (mask B).toNat = 2 ^ min (B + 1) 64 - 1 := by
  have h1 : (1#64).toNat = 1 := rfl
  have hs : (1#64 <<< (B + 1)).toNat = 2 ^ (B + 1) % 2 ^ 64 := by
    rw [BitVec.toNat_shiftLeft, h1, Nat.shiftLeft_eq, Nat.one_mul]
  rw [mask, BitVec.toNat_sub, hs, h1]
  rcases Nat.lt_or_ge (B + 1) 64 with h | h
  · have h1 : 2 ^ (B + 1) < 2 ^ 64 := Nat.pow_lt_pow_right (by decide) h
    have h2 : 1 ≤ 2 ^ (B + 1) := Nat.one_le_two_pow
    rw [Nat.mod_eq_of_lt h1, Nat.min_eq_left h.le]
    omega
  · obtain ⟨k, hk⟩ : ∃ k, B + 1 = 64 + k := ⟨B + 1 - 64, by omega⟩
    rw [hk, Nat.pow_add, Nat.mul_mod_right, Nat.min_eq_right (by omega)]

/-- The digit at a set bit `pos` is `0` or odd, in `[-(2^bits - 1), 2^bits - 1]`. -/
theorem digit_digits {t : Vector Int 256} {n : BitVec 320} (hB : 1 ≤ B) (h : Digits (2 ^ B - 1) t)
    (hp : p < 256) (hbit : n.getLsbD p = true) : Digits (2 ^ B - 1) (digit B n t p hp).2 := by
  have hd :
    ((n >>> p).setWidth 64 &&& mask B).toNat =
      ((n >>> p).setWidth 64).toNat % 2 ^ min (B + 1) 64 := by
    rw [BitVec.toNat_and, toNat_mask, Nat.and_two_pow_sub_one_eq_mod]
  have hodd : ((n >>> p).setWidth 64).toNat % 2 = 1 := by
    rw [BitVec.getLsbD, Nat.testBit_eq_decide_div_mod_eq, decide_eq_true_eq] at hbit
    rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
      Nat.mod_mod_of_dvd _ (by decide : 2 ∣ 2 ^ 64)]
    exact hbit
  have hdm : ((n >>> p).setWidth 64).toNat % 2 ^ min (B + 1) 64 % 2 = 1 := by
    rw [Nat.mod_mod_of_dvd _ (by simpa using Nat.pow_dvd_pow 2 (show 1 ≤ min (B + 1) 64 by omega))]
    exact hodd
  have hlt := Nat.mod_lt ((n >>> p).setWidth 64).toNat (Nat.two_pow_pos (min (B + 1) 64))
  have hmin : 2 ^ min (B + 1) 64 ≤ 2 * 2 ^ B := by
    rw [← Nat.pow_succ']
    exact Nat.pow_le_pow_right (by decide) (by omega)
  have heven : 2 ^ B % 2 = 0 := by
    obtain ⟨k, rfl⟩ : ∃ k, B = k + 1 := ⟨B - 1, by omega⟩
    rw [Nat.pow_succ, Nat.mul_mod_left]
  have hP : (2 : Int) ^ B = ((2 ^ B : Nat) : Int) := by
    push_cast; rfl
  have hP1 : (2 : Int) ^ (B + 1) = 2 * ((2 ^ B : Nat) : Int) := by
    rw [Int.pow_succ, hP, Int.mul_comm]
  simp only [digit, hd]
  generalize ((n >>> p).setWidth 64).toNat % 2 ^ min (B + 1) 64 = D at hdm hlt ⊢
  generalize 2 ^ min (B + 1) 64 = M at hlt hmin
  rw [hP] at h ⊢
  split
  · refine h.set hp ⟨.inr ?_, ?_, ?_⟩ <;> omega
  · rw [hP1]
    refine h.set hp ⟨.inr ?_, ?_, ?_⟩ <;> omega

/-- `n` splits at the window into `n` cleared and `d 2^pos`, without a carry. -/
theorem split_bv (n : BitVec 320) (c β : BitVec 64) (hc : c < 256#64) (hβ : β ≤ 13#64) :
    n =
        (n &&& ~~~((1#64 <<< (β + 1#64) - 1#64).setWidth 320 <<< c)) +
          ((n >>> c).setWidth 64 &&& (1#64 <<< (β + 1#64) - 1#64)).setWidth 320 <<< c ∧
      ¬(n &&& ~~~((1#64 <<< (β + 1#64) - 1#64).setWidth 320 <<< c)).uaddOverflow
          (((n >>> c).setWidth 64 &&& (1#64 <<< (β + 1#64) - 1#64)).setWidth 320 <<< c) := by
  constructor <;> bv_decide

/-- `d`, the window at `pos`, as a number: the `bits+1` bits of `n` from `pos`. -/
public theorem toNat_window (n : BitVec 320) (hB : B ≤ 13) :
    ((n >>> p).setWidth 64 &&& mask B).toNat = n.toNat / 2 ^ p % 2 ^ (B + 1) := by
  rw [BitVec.toNat_and, toNat_mask, Nat.min_eq_left (by omega), Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
    Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega))]

/-- The window cleared from `n` leaves `n - d 2^pos`. -/
public theorem toNat_clear (n : BitVec 320) (hp : p < 256) (hB : B ≤ 13) :
    (n &&& ~~~((mask B).setWidth 320 <<< p)).toNat + n.toNat / 2 ^ p % 2 ^ (B + 1) * 2 ^ p =
      n.toNat := by
  have hc : BitVec.ofNat 64 p < 256#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; simp; omega
  have hβ : BitVec.ofNat 64 B ≤ 13#64 := by
    rw [BitVec.le_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; simp; omega
  obtain ⟨h1, h2⟩ := split_bv n _ _ hc hβ
  have hm : 1#64 <<< (BitVec.ofNat 64 B + 1#64) - 1#64 = mask B := by
    rw [mask, BitVec.shiftLeft_eq', ← BitVec.ofNat_add, BitVec.toNat_ofNat,
      Nat.mod_eq_of_lt (show B + 1 < 2 ^ 64 by omega)]
  have hsh : ∀ {w} (y : BitVec w), y <<< BitVec.ofNat 64 p = y <<< p := fun y => by
    rw [BitVec.shiftLeft_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hshr : n >>> BitVec.ofNat 64 p = n >>> p := by
    rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [hm, hsh, hsh, hshr] at h1 h2
  have h3 : n.toNat / 2 ^ p % 2 ^ (B + 1) < 2 ^ 14 :=
    lt_of_lt_of_le (Nat.mod_lt _ (Nat.two_pow_pos _)) (Nat.pow_le_pow_right (by decide) (by omega))
  have h5 : n.toNat / 2 ^ p % 2 ^ (B + 1) * 2 ^ p < 2 ^ 320 :=
    calc
      _ < 2 ^ 14 * 2 ^ p := Nat.mul_lt_mul_of_pos_right h3 (Nat.two_pow_pos p)
      _ = 2 ^ (14 + p) := (Nat.pow_add 2 14 p).symm
      _ ≤ 2 ^ 320 := Nat.pow_le_pow_right (by decide) (show 14 + p ≤ 320 by omega)
  have hy :
    (((n >>> p).setWidth 64 &&& mask B).setWidth 320 <<< p).toNat =
      n.toNat / 2 ^ p % 2 ^ (B + 1) * 2 ^ p := by
    rw [BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, toNat_window n hB, Nat.shiftLeft_eq,
      Nat.mod_eq_of_lt
        (lt_trans h3 (Nat.pow_lt_pow_right (a := 2) (by decide) (show 14 < 320 by decide))),
      Nat.mod_eq_of_lt h5]
  have := congrArg BitVec.toNat h1
  rw [BitVec.toNat_add_of_not_uaddOverflow h2, hy] at this
  exact this.symm

/-- `n + 1<<k` below `2^255`: no wrap. -/
public theorem toNat_add_shiftLeft {a : BitVec 320} (hk : k < 320) (h : a.toNat + 2 ^ k ≤ 2 ^ 255) :
    (a + 1#320 <<< k).toNat = a.toNat + 2 ^ k := by
  have hR : (1#320 <<< k).toNat = 2 ^ k := by
    rw [BitVec.toNat_shiftLeft, BitVec.toNat_one (by decide), Nat.shiftLeft_eq, Nat.one_mul,
      Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (a := 2) (by decide) (show k < 320 by omega))]
  rw [BitVec.toNat_add, hR,
    Nat.mod_eq_of_lt
      (lt_of_le_of_lt h (Nat.pow_lt_pow_right (a := 2) (by decide) (show 255 < 320 by decide)))]

/-- `loop` sets only digits. -/
theorem loop_digits {t : Vector Int 256} {n : BitVec 320} (hB : 1 ≤ B) (h : Digits (2 ^ B - 1) t) :
    Digits (2 ^ B - 1) (loop B f n t pos) := by
  induction f generalizing n t pos with
  | zero => exact h
  | succ f ih =>
    simp only [loop]
    split
    next hp => exact ih (digit_digits hB h hp (getLsbD_nextBit hp))
    · exact h

/-- Each digit of `wnaf x bits` is `0` or odd, in `[-(2^bits - 1), 2^bits - 1]`. -/
public theorem wnaf_digits (x : BitVec 256) (hb : 1 ≤ bits) :
    Digits (2 ^ bits - 1) (wnaf x bits) := by
  refine loop_digits hb fun k hk => ?_
  have : (1 : Int) ≤ 2 ^ bits := by exact_mod_cast Nat.one_le_two_pow
  simp only [Vector.getElem_replicate]
  exact ⟨.inl rfl, by omega, by omega⟩

/-- `n1slide`'s digits: `0` or odd, in `[-15, 15]`. -/
public theorem wnaf4_digits (x : BitVec 256) : Digits 15 (wnaf x 4) :=
  wnaf_digits x (bits := 4) (by decide)

/-- `n2slide`'s digits: `0` or odd, in `[-255, 255]`. -/
public theorem wnaf8_digits (x : BitVec 256) : Digits 255 (wnaf x 8) :=
  wnaf_digits x (bits := 8) (by decide)

end fd_curve25519_scalar_wnaf

end Digits

end MLIR.Firedancer.Ref

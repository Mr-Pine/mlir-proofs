module

public import Zig.Fe
public import Ed25519.Scalar
import Std.Tactic.BVDecide

/-! Scalars mod `ℓ` as Zig's `Scalar` holds them: five 64-bit limbs of 56 bits' weight, at the
layout `readLimbs` reads. -/

namespace LeanMLIR.RIR.Zig

@[expose] public section

/-- `0xffffffffffffff`, a limb's 56 bits. -/
abbrev Scalar.mask : BitVec 64 :=
  0xffffffffffffff#64

/-- `ℓ`'s limbs. -/
abbrev Scalar.ell : Fin 5 → BitVec 64 :=
  Fe.mk5 5175514460705773#64 70332060721272408#64 5342#64 0#64 268435456#64

/-- `ℓ` in 320 bits. -/
abbrev Scalar.ell320 : BitVec 320 :=
  7237005577332262213973186563042994240857116359379907606001950938285454250989#320

/-- The limbs' value, limb `i` weighing `2^(56 i)`. -/
def Scalar.val (l : Fin 5 → BitVec 64) : Nat :=
  (l 0).toNat + 2 ^ 56 * (l 1).toNat + 2 ^ 112 * (l 2).toNat + 2 ^ 168 * (l 3).toNat +
    2 ^ 224 * (l 4).toNat

/-- Canonical limbs: each below `2^56`, the value below `ℓ`. -/
def Scalar.Canonical (l : Fin 5 → BitVec 64) : Prop :=
  Fe.Lt l (2 ^ 56) ∧ Scalar.val l < Ed25519.ell

/-- The limbs' value in 320 bits. -/
def Scalar.wide (l : Fin 5 → BitVec 64) : BitVec 320 :=
  (l 0).setWidth 320 + (l 1).setWidth 320 <<< 56 + (l 2).setWidth 320 <<< 112 +
    (l 3).setWidth 320 <<< 168 + (l 4).setWidth 320 <<< 224

/-- A 320-bit value's limbs: four of 56 bits, the rest in the top one. -/
def Scalar.limbs (z : BitVec 320) : Fin 5 → BitVec 64 :=
  Fe.mk5 (z.setWidth 64 &&& Scalar.mask) ((z >>> 56).setWidth 64 &&& Scalar.mask)
    ((z >>> 112).setWidth 64 &&& Scalar.mask) ((z >>> 168).setWidth 64 &&& Scalar.mask)
    ((z >>> 224).setWidth 64)

end

set_option exponentiation.threshold 320 in
/-- `ℓ` in 320 bits is `ℓ`. -/
public theorem Scalar.toNat_ell320 : Scalar.ell320.toNat = Ed25519.ell := by
  have e : (7237005577332262213973186563042994240857116359379907606001950938285454250989 : Nat) =
      Ed25519.ell := by
    unfold Ed25519.ell; rfl
  rw [BitVec.toNat_ofNat, e]
  exact Nat.mod_eq_of_lt (Ed25519.ell_lt.trans (Nat.pow_lt_pow_right (by decide) (by decide)))

/-- A limb below `2^56`, as `bv_decide` takes it. -/
public theorem Scalar.lt56 {x : BitVec 64} (h : x.toNat < 2 ^ 56) : x < 72057594037927936#64 := by
  simp only [BitVec.lt_def]; exact h

/-- The wide value of limbs below `2^56` is theirs. -/
public theorem Scalar.toNat_wide {l : Fin 5 → BitVec 64} (h : Fe.Lt l (2 ^ 56)) :
    (Scalar.wide l).toNat = Scalar.val l := by
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3; have h4 := h 4
  simp only [Scalar.wide, Scalar.val, BitVec.toNat_add, BitVec.toNat_shiftLeft,
    BitVec.toNat_setWidth, Nat.shiftLeft_eq]
  omega

/-- Canonical limbs' wide value is below `ℓ`. -/
public theorem Scalar.wide_lt_ell {l : Fin 5 → BitVec 64} (h : Scalar.Canonical l) :
    Scalar.wide l < Scalar.ell320 := by
  rw [BitVec.lt_def, Scalar.toNat_wide h.1, Scalar.toNat_ell320]
  exact h.2

/-- The limbs of a value below `2^280`: below `2^56`, of its value. -/
public theorem Scalar.limbs_lt_val {z : BitVec 320} (h : z.toNat < 2 ^ 280) :
    Fe.Lt (Scalar.limbs z) (2 ^ 56) ∧ Scalar.val (Scalar.limbs z) = z.toNat := by
  have hm (y : BitVec 64) : (y &&& Scalar.mask).toNat = y.toNat % 2 ^ 56 := by
    rw [BitVec.toNat_and, show Scalar.mask.toNat = 2 ^ 56 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have hs (k : Nat) : ((z >>> k).setWidth 64).toNat = z.toNat / 2 ^ k % 2 ^ 64 := by
    rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have h0 : (z.setWidth 64).toNat = z.toNat % 2 ^ 64 := BitVec.toNat_setWidth ..
  constructor
  · intro i
    fin_cases i <;> simp only [Scalar.limbs, Fe.mk5, hm, hs, h0] <;> omega
  · simp only [Scalar.val, Scalar.limbs, Fe.mk5, hm, hs, h0]
    omega

end LeanMLIR.RIR.Zig

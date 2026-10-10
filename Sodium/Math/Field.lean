module

public import Ed25519.Limbs
public import Agave.Math.FieldElement51
public import Sodium.fe25519_mul
public import Sodium.fe25519_sq
public import Sodium.fe25519_sq2
public import Sodium.fe25519_add
public import Sodium.fe25519_sub
public import Sodium.fe25519_neg
public import Sodium.fe25519_pow22523
public import Sodium.fe25519_invert
public import Boringssl.Math.Field
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! libsodium's `fe25519` arithmetic (`fe_51`) in `ZMod p`: each spec computes its field operation
on `Limbs.val`, under limb bounds `Limbs.Lt`: below `2^54` into a product (`2^53` into `sq2`),
below `2^52` out of one. -/

namespace MLIR.Sodium

open _root_.Ed25519 Agave

/-! ## Products -/

/-- The carries after a product's 128-bit column sums `c0 … c4`: each column plus the whole carry
of the one below, the top carry times 19 into limb 0, then carries out of limbs 0 and 1. -/
def carryChain (c0 c1 c2 c3 c4 : BitVec 128) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#64
  let r00 := c0.setWidth 64 &&& mask
  let r1 := c1 + c0 >>> 51
  let r01 := r1.setWidth 64 &&& mask
  let r2 := c2 + r1 >>> 51
  let r02 := r2.setWidth 64 &&& mask
  let r3 := c3 + r2 >>> 51
  let r03 := r3.setWidth 64 &&& mask
  let r4 := c4 + r3 >>> 51
  let r04 := r4.setWidth 64 &&& mask
  let r00 := (r4 >>> 51).setWidth 64 * 19#64 + r00
  let r01 := r00 >>> 51 + r01
  let r02 := r01 >>> 51 + r02
  fun
  | 0 => r00 &&& mask
  | 1 => r01 &&& mask
  | 2 => r02
  | 3 => r03
  | 4 => r04

theorem toNat_shift128 (x : BitVec 128) : (x >>> 51).toNat = x.toNat / 2 ^ 51 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `carryChain` computes the columns' value into limbs below `2^52`, for columns below `2^120`
and the top one at most `5 · 2^108` (so its carry times 19 does not wrap). -/
theorem carryChain_spec {c0 c1 c2 c3 c4 : BitVec 128} (h0 : c0.toNat < 2 ^ 120)
    (h1 : c1.toNat < 2 ^ 120) (h2 : c2.toNat < 2 ^ 120) (h3 : c3.toNat < 2 ^ 120)
    (h4 : c4.toNat ≤ 5 * 2 ^ 108) :
    Limbs.val (carryChain c0 c1 c2 c3 c4) =
        c0.toNat + c1.toNat * 2 ^ 51 + c2.toNat * 2 ^ 102 + c3.toNat * 2 ^ 153 +
          c4.toNat * 2 ^ 204 ∧
      Limbs.Lt (carryChain c0 c1 c2 c3 c4) (2 ^ 52) := by
  rw [Limbs.val_eq, Limbs.lt_iff]
  dsimp only [carryChain]
  generalize hr1 : c1 + c0 >>> 51 = r1
  generalize hr2 : c2 + r1 >>> 51 = r2
  generalize hr3 : c3 + r2 >>> 51 = r3
  generalize hr4 : c4 + r3 >>> 51 = r4
  generalize hu0 : (r4 >>> 51).setWidth 64 * 19#64 + (c0.setWidth 64 &&& 0x7ffffffffffff#64) = u0
  generalize hu1 : u0 >>> 51 + (r1.setWidth 64 &&& 0x7ffffffffffff#64) = u1
  have k1 : r1.toNat = c1.toNat + c0.toNat / 2 ^ 51 := by
    rw [← hr1, BitVec.toNat_add, toNat_shift128]; omega
  have k2 : r2.toNat = c2.toNat + r1.toNat / 2 ^ 51 := by
    rw [← hr2, BitVec.toNat_add, toNat_shift128]; omega
  have k3 : r3.toNat = c3.toNat + r2.toNat / 2 ^ 51 := by
    rw [← hr3, BitVec.toNat_add, toNat_shift128]; omega
  have k4 : r4.toNat = c4.toNat + r3.toNat / 2 ^ 51 := by
    rw [← hr4, BitVec.toNat_add, toNat_shift128]; omega
  have ku0 : u0.toNat = r4.toNat / 2 ^ 51 * 19 + c0.toNat % 2 ^ 51 := by
    rw [← hu0, BitVec.toNat_add, BitVec.toNat_mul, BitVec.toNat_setWidth, toNat_shift128,
      toNat_setWidth_mask, show (19#64).toNat = 19 from rfl]
    omega
  have ku1 : u1.toNat = u0.toNat / 2 ^ 51 + r1.toNat % 2 ^ 51 := by
    rw [← hu1, BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  have ko2 :
    (u1 >>> 51 + (r2.setWidth 64 &&& 0x7ffffffffffff#64)).toNat =
      u1.toNat / 2 ^ 51 + r2.toNat % 2 ^ 51 := by
    rw [BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  simp only [toNat_setWidth_mask]
  simp only [toNat_and_mask, ko2]
  refine ⟨carry_val k1 k2 k3 k4 ku0 ku1, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- `carryChain_spec` over column sums known through `ValLe`. -/
theorem carryChain_valLe {c0 c1 c2 c3 c4 : BitVec 128} {v : ZMod p} (h0 : ValLe c0 n0 M0)
    (h1 : ValLe c1 n1 M1) (h2 : ValLe c2 n2 M2) (h3 : ValLe c3 n3 M3) (h4 : ValLe c4 n4 M4)
    (hM : M0 < 2 ^ 120 ∧ M1 < 2 ^ 120 ∧ M2 < 2 ^ 120 ∧ M3 < 2 ^ 120 ∧ M4 ≤ 5 * 2 ^ 108)
    (hv : (n0 : ZMod p) + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204 = v) :
    Limbs.val (carryChain c0 c1 c2 c3 c4) = v ∧ Limbs.Lt (carryChain c0 c1 c2 c3 c4) (2 ^ 52) := by
  obtain ⟨rfl, h0⟩ := h0
  obtain ⟨rfl, h1⟩ := h1
  obtain ⟨rfl, h2⟩ := h2
  obtain ⟨rfl, h3⟩ := h3
  obtain ⟨rfl, h4⟩ := h4
  obtain ⟨hv', ht⟩ :=
    carryChain_spec (c0 := c0) (c1 := c1) (c2 := c2) (c3 := c3) (c4 := c4) (by omega) (by omega)
      (by omega) (by omega) (by omega)
  exact ⟨hv'.trans hv, ht⟩

open Agave.Serial (mulWide)

/-- `fe25519_mul.spec` is `carryChain` of the product's column sums. -/
theorem fe25519_mul.spec_eq (f g : Fin 5 → BitVec 64) :
    fe25519_mul.spec f g =
      carryChain
        (mulWide (g 1) (f 4 * 19#64) + mulWide (g 0) (f 0) + mulWide (g 2) (f 3 * 19#64) +
          mulWide (g 3) (f 2 * 19#64) +
          mulWide (g 4) (f 1 * 19#64))
        (mulWide (g 1) (f 0) + mulWide (g 0) (f 1) + mulWide (g 2) (f 4 * 19#64) +
          mulWide (g 3) (f 3 * 19#64) +
          mulWide (g 4) (f 2 * 19#64))
        (mulWide (g 1) (f 1) + mulWide (g 0) (f 2) + mulWide (g 2) (f 0) +
          mulWide (g 3) (f 4 * 19#64) +
          mulWide (g 4) (f 3 * 19#64))
        (mulWide (g 1) (f 2) + mulWide (g 0) (f 3) + mulWide (g 2) (f 1) + mulWide (g 3) (f 0) +
          mulWide (g 4) (f 4 * 19#64))
        (mulWide (g 1) (f 3) + mulWide (g 0) (f 4) + mulWide (g 2) (f 2) + mulWide (g 3) (f 1) +
          mulWide (g 4) (f 0)) := by
  funext i
  fin_cases i <;> rfl

/-- `fe25519_mul` multiplies limbs below `2^54` into limbs below `2^52`. -/
public theorem fe25519_mul.spec_val {f g : Fin 5 → BitVec 64} (hf : Limbs.Lt f (2 ^ 54))
    (hg : Limbs.Lt g (2 ^ 54)) :
    Limbs.val (fe25519_mul.spec f g) = Limbs.val f * Limbs.val g ∧
      Limbs.Lt (fe25519_mul.spec f g) (2 ^ 52) := by
  have hF i : ValLe (f i) (f i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := hf i; omega⟩
  have hG i : ValLe (g i) (g i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := hg i; omega⟩
  rw [fe25519_mul.spec_eq]
  apply carryChain_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq, Limbs.val_eq]
    simp only [show (19#64).toNat = 19 from rfl]
    push_cast
    generalize ((f 0).toNat : ZMod p) = f0
    generalize ((f 1).toNat : ZMod p) = f1
    generalize ((f 2).toNat : ZMod p) = f2
    generalize ((f 3).toNat : ZMod p) = f3
    generalize ((f 4).toNat : ZMod p) = f4
    generalize ((g 0).toNat : ZMod p) = g0
    generalize ((g 1).toNat : ZMod p) = g1
    generalize ((g 2).toNat : ZMod p) = g2
    generalize ((g 3).toNat : ZMod p) = g3
    generalize ((g 4).toNat : ZMod p) = g4
    linear_combination
      -(f1 * g4 + f2 * g3 + f3 * g2 + f4 * g1 + (f2 * g4 + f3 * g3 + f4 * g2) * 2 ^ 51 +
            (f3 * g4 + f4 * g3) * 2 ^ 102 +
            f4 * g4 * 2 ^ 153) *
        two_pow_255

/-- `fe25519_sq.spec` is `carryChain` of the square's column sums. -/
theorem fe25519_sq.spec_eq (f : Fin 5 → BitVec 64) :
    fe25519_sq.spec f =
      carryChain (mulWide (f 2 * 38#64) (f 3) + mulWide (f 0) (f 0) + mulWide (f 4) (f 1 * 38#64))
        (mulWide (f 4) (f 2 * 38#64) + mulWide (f 0 <<< 1) (f 1) + mulWide (f 3 * 19#64) (f 3))
        (mulWide (f 2) (f 0 <<< 1) + mulWide (f 1) (f 1) + mulWide (f 3 * 38#64) (f 4))
        (mulWide (f 3) (f 0 <<< 1) + mulWide (f 1 <<< 1) (f 2) + mulWide (f 4 * 19#64) (f 4))
        (mulWide (f 3) (f 1 <<< 1) + mulWide (f 2) (f 2) + mulWide (f 4) (f 0 <<< 1)) := by
  funext i
  fin_cases i <;> rfl

/-- `fe25519_sq` squares limbs below `2^54` into limbs below `2^52`. -/
public theorem fe25519_sq.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Lt f (2 ^ 54)) :
    Limbs.val (fe25519_sq.spec f) = Limbs.val f ^ 2 ∧ Limbs.Lt (fe25519_sq.spec f) (2 ^ 52) := by
  have hF i : ValLe (f i) (f i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := hf i; omega⟩
  rw [fe25519_sq.spec_eq]
  apply carryChain_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.shl, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19#64).toNat = 19 from rfl, show (38#64).toNat = 38 from rfl]
    push_cast
    generalize ((f 0).toNat : ZMod p) = f0
    generalize ((f 1).toNat : ZMod p) = f1
    generalize ((f 2).toNat : ZMod p) = f2
    generalize ((f 3).toNat : ZMod p) = f3
    generalize ((f 4).toNat : ZMod p) = f4
    linear_combination
      -(2 * f1 * f4 + 2 * f2 * f3 + (2 * f2 * f4 + f3 * f3) * 2 ^ 51 + 2 * f3 * f4 * 2 ^ 102 +
            f4 * f4 * 2 ^ 153) *
        two_pow_255

/-- `fe25519_sq2.spec` is `carryChain` of the doubled square's column sums. -/
theorem fe25519_sq2.spec_eq (f : Fin 5 → BitVec 64) :
    fe25519_sq2.spec f =
      carryChain
        ((mulWide (f 2 * 38#64) (f 3) + mulWide (f 0) (f 0) + mulWide (f 4) (f 1 * 38#64)) <<< 1)
        ((mulWide (f 4) (f 2 * 38#64) + mulWide (f 0 <<< 1) (f 1) + mulWide (f 3 * 19#64) (f 3)) <<<
          1)
        ((mulWide (f 2) (f 0 <<< 1) + mulWide (f 1) (f 1) + mulWide (f 3 * 38#64) (f 4)) <<< 1)
        ((mulWide (f 3) (f 0 <<< 1) + mulWide (f 1 <<< 1) (f 2) + mulWide (f 4 * 19#64) (f 4)) <<<
          1)
        ((mulWide (f 3) (f 1 <<< 1) + mulWide (f 2) (f 2) + mulWide (f 4) (f 0 <<< 1)) <<< 1) := by
  funext i
  fin_cases i <;> simp only [fe25519_sq2.spec, carryChain] <;> ac_rfl

/-- `fe25519_sq2` doubles the square of limbs below `2^53` into limbs below `2^52`. -/
public theorem fe25519_sq2.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Lt f (2 ^ 53)) :
    Limbs.val (fe25519_sq2.spec f) = 2 * Limbs.val f ^ 2 ∧
      Limbs.Lt (fe25519_sq2.spec f) (2 ^ 52) := by
  have hF i : ValLe (f i) (f i).toNat (2 ^ 53 - 1) :=
    ⟨rfl, by
      have := hf i; omega⟩
  rw [fe25519_sq2.spec_eq]
  apply carryChain_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.shl, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19#64).toNat = 19 from rfl, show (38#64).toNat = 38 from rfl]
    push_cast
    generalize ((f 0).toNat : ZMod p) = f0
    generalize ((f 1).toNat : ZMod p) = f1
    generalize ((f 2).toNat : ZMod p) = f2
    generalize ((f 3).toNat : ZMod p) = f3
    generalize ((f 4).toNat : ZMod p) = f4
    linear_combination
      -2 *
        (2 * f1 * f4 + 2 * f2 * f3 + (2 * f2 * f4 + f3 * f3) * 2 ^ 51 + 2 * f3 * f4 * 2 ^ 102 +
          f4 * f4 * 2 ^ 153) *
        two_pow_255

/-! ## Sums -/

/-- `x`'s low 51 bits and its carry, in `ZMod p`. -/
theorem mod_add_div51 (x : ℕ) : ((x % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (x / 2 ^ 51 : ℕ) = x := by
  exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ 51))

/-- `fe25519_add` (Firedancer's `fiat_25519_add.spec`) adds limbs below `A` and `B`,
`A + B ≤ 2^64`, into limbs below `A + B`. -/
public theorem fe25519_add.spec_val {f g : Fin 5 → BitVec 64} {A B : ℕ} (hf : Limbs.Lt f A)
    (hg : Limbs.Lt g B) (h : A + B ≤ 2 ^ 64) :
    Limbs.val (Firedancer.Ref.fiat_25519_add.spec f g) = Limbs.val f + Limbs.val g ∧
      Limbs.Lt (Firedancer.Ref.fiat_25519_add.spec f g) (A + B) := by
  have e (i : Fin 5) :
    (Firedancer.Ref.fiat_25519_add.spec f g i).toNat = (f i).toNat + (g i).toNat := by
    have := hf i
    have := hg i
    simp only [Firedancer.Ref.fiat_25519_add.spec, BitVec.toNat_add]
    omega
  refine
    ⟨?_, fun i => by
      have := hf i; have := hg i; rw [e]; omega⟩
  simp only [Limbs.val, e]
  push_cast
  rw [← Finset.sum_add_distrib]
  simp only [add_mul]

/-- `2p`'s limbs, `fe25519_sub`'s offset: their value is `0`. -/
theorem val_two_p :
    ((4503599627370458 + 4503599627370494 * 2 ^ 51 + 4503599627370494 * 2 ^ 102 +
            4503599627370494 * 2 ^ 153 +
            4503599627370494 * 2 ^ 204 :
          ℕ) :
        ZMod p) =
      0 := by
  rw [show
      4503599627370458 + 4503599627370494 * 2 ^ 51 + 4503599627370494 * 2 ^ 102 +
          4503599627370494 * 2 ^ 153 +
          4503599627370494 * 2 ^ 204 =
        2 * p
      by norm_num]
  simp

/-- `fe25519_sub` subtracts limbs below `2^63` from limbs below `A`, `A + 2^52 ≤ 2^64`, into
limbs below `A + 2^52 - 1`. -/
public theorem fe25519_sub.spec_val {f g : Fin 5 → BitVec 64} {A : ℕ} (hf : Limbs.Lt f A)
    (hA : A + 2 ^ 52 ≤ 2 ^ 64) (hg : Limbs.Lt g (2 ^ 63)) :
    Limbs.val (fe25519_sub.spec f g) = Limbs.val f - Limbs.val g ∧
      Limbs.Lt (fe25519_sub.spec f g) (A + 2 ^ 52 - 1) := by
  obtain ⟨f0, f1, f2, f3, f4⟩ := (Limbs.lt_iff _ _).1 hf
  obtain ⟨g0, g1, g2, g3, g4⟩ := (Limbs.lt_iff _ _).1 hg
  rw [Limbs.val_eq, Limbs.val_eq, Limbs.val_eq, Limbs.lt_iff]
  dsimp only [fe25519_sub.spec]
  generalize hh1 : g 1 + g 0 >>> 51 = h1 at *
  generalize hh2 : g 2 + h1 >>> 51 = h2 at *
  generalize hh3 : g 3 + h2 >>> 51 = h3 at *
  generalize hh4 : g 4 + h3 >>> 51 = h4 at *
  generalize hh0 : (g 0 &&& 0x7ffffffffffff#64) + 19#64 * (h4 >>> 51) = h0 at *
  have k1 : h1.toNat = (g 1).toNat + (g 0).toNat / 2 ^ 51 := by
    rw [← hh1, BitVec.toNat_add, toNat_shift]; omega
  have k2 : h2.toNat = (g 2).toNat + h1.toNat / 2 ^ 51 := by
    rw [← hh2, BitVec.toNat_add, toNat_shift]; omega
  have k3 : h3.toNat = (g 3).toNat + h2.toNat / 2 ^ 51 := by
    rw [← hh3, BitVec.toNat_add, toNat_shift]; omega
  have k4 : h4.toNat = (g 4).toNat + h3.toNat / 2 ^ 51 := by
    rw [← hh4, BitVec.toNat_add, toNat_shift]; omega
  have k0 : h0.toNat = (g 0).toNat % 2 ^ 51 + 19 * (h4.toNat / 2 ^ 51) := by
    rw [← hh0, BitVec.toNat_add, BitVec.toNat_mul, toNat_and_mask, toNat_shift,
      show (19#64).toNat = 19 from rfl]
    omega
  have e0 : (f 0 + 0xfffffffffffda#64 - h0).toNat + h0.toNat = (f 0).toNat + 4503599627370458 := by
    rw [BitVec.toNat_sub, BitVec.toNat_add,
      show (0xfffffffffffda#64).toNat = 4503599627370458 from rfl]
    omega
  have e (x c : BitVec 64) (hx : x.toNat < A) (hc : c.toNat = 4503599627370494) (y : BitVec 64) :
    (x + c - (y &&& 0x7ffffffffffff#64)).toNat + y.toNat % 2 ^ 51 = x.toNat + 4503599627370494 := by
    rw [BitVec.toNat_sub, BitVec.toNat_add, toNat_and_mask, hc]
    omega
  have hc : (0xffffffffffffe#64).toNat = 4503599627370494 := rfl
  have e1 := e (f 1) _ f1 hc h1
  have e2 := e (f 2) _ f2 hc h2
  have e3 := e (f 3) _ f3 hc h3
  have e4 := e (f 4) _ f4 hc h4
  refine ⟨?_, by omega, by omega, by omega, by omega, by omega⟩
  have E0 := congrArg (Nat.cast (R := ZMod p)) e0
  have E1 := congrArg (Nat.cast (R := ZMod p)) e1
  have E2 := congrArg (Nat.cast (R := ZMod p)) e2
  have E3 := congrArg (Nat.cast (R := ZMod p)) e3
  have E4 := congrArg (Nat.cast (R := ZMod p)) e4
  have K0 := congrArg (Nat.cast (R := ZMod p)) k0
  have K1 := congrArg (Nat.cast (R := ZMod p)) k1
  have K2 := congrArg (Nat.cast (R := ZMod p)) k2
  have K3 := congrArg (Nat.cast (R := ZMod p)) k3
  have K4 := congrArg (Nat.cast (R := ZMod p)) k4
  have hP := val_two_p
  push_cast at E0 E1 E2 E3 E4 K0 K1 K2 K3 K4 hP
  linear_combination
    E0 + 2 ^ 51 * E1 + 2 ^ 102 * E2 + 2 ^ 153 * E3 + 2 ^ 204 * E4 + hP - K0 -
        mod_add_div51 (g 0).toNat -
        2 ^ 51 * K1 -
        2 ^ 51 * mod_add_div51 h1.toNat -
        2 ^ 102 * K2 -
        2 ^ 102 * mod_add_div51 h2.toNat -
        2 ^ 153 * K3 -
        2 ^ 153 * mod_add_div51 h3.toNat -
        2 ^ 204 * K4 -
        2 ^ 204 * mod_add_div51 h4.toNat +
      ((h4.toNat / 2 ^ 51 : ℕ) : ZMod p) * two_pow_255

/-- `fe25519_neg` negates limbs below `2^63` into limbs below `2^52`. -/
public theorem fe25519_neg.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Lt f (2 ^ 63)) :
    Limbs.val (fe25519_neg.spec f) = -Limbs.val f ∧ Limbs.Lt (fe25519_neg.spec f) (2 ^ 52) := by
  have h0 : Limbs.Lt Boringssl.fe_0.spec 1 := fun _ => by simp [Boringssl.fe_0.spec]
  obtain ⟨hv, hl⟩ := fe25519_sub.spec_val h0 (by decide) hf
  refine ⟨?_, hl⟩
  rw [fe25519_neg.spec, hv, Boringssl.fe_0.spec_val.1, zero_sub]

/-! ## Constants -/

/-- `fe25519_0` stores `0` (BoringSSL's `fe_0.spec`), limbs below `1`. -/
public theorem fe25519_0.spec_val :
    Limbs.val Boringssl.fe_0.spec = 0 ∧ Limbs.Lt Boringssl.fe_0.spec 1 :=
  ⟨Boringssl.fe_0.spec_val.1, fun _ => by simp [Boringssl.fe_0.spec]⟩

/-- `fe25519_1` stores `1` (BoringSSL's `fe_1.spec`), limbs below `2`. -/
public theorem fe25519_1.spec_val :
    Limbs.val Boringssl.fe_1.spec = 1 ∧ Limbs.Lt Boringssl.fe_1.spec 2 := by
  refine ⟨Boringssl.fe_1.spec_val.1, fun i => ?_⟩
  fin_cases i <;> decide

/-! ## Powers -/

/-- `l` holds `z ^ e` in limbs below `2^54`. -/
def IsPow (l z : Fin 5 → BitVec 64) (e : ℕ) : Prop :=
  Limbs.val l = Limbs.val z ^ e ∧ Limbs.Lt l (2 ^ 54)

theorem IsPow.self {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) : IsPow z z 1 :=
  ⟨(pow_one _).symm, hz⟩

theorem IsPow.sq (h : IsPow l z e) : IsPow (fe25519_sq.spec l) z (e * 2) := by
  obtain ⟨hv, hl⟩ := fe25519_sq.spec_val h.2
  exact ⟨by rw [hv, h.1, pow_mul], hl.mono (by decide)⟩

theorem IsPow.mul (h : IsPow l z e) (h' : IsPow m z f) :
    IsPow (fe25519_mul.spec l m) z (e + f) := by
  obtain ⟨hv, hl⟩ := fe25519_mul.spec_val h.2 h'.2
  exact ⟨by rw [hv, h.1, h'.1, pow_add], hl.mono (by decide)⟩

theorem IsPow.sqrN (h : IsPow l z e) : IsPow (Sodium.sqrN n l) z (e * 2 ^ n) := by
  induction n generalizing l e with
  | zero => simpa [Sodium.sqrN] using h
  | succ n ih =>
    rw [Sodium.sqrN, pow_succ', ← mul_assoc]
    exact ih h.sq

/-- The last product of a chain: `z ^ g`, `g = e + f`, in limbs below `2^52`. -/
theorem IsPow.mul_last (h : IsPow l z e) (h' : IsPow m z f) (hg : e + f = g) :
    Limbs.val (fe25519_mul.spec l m) = Limbs.val z ^ g ∧
      Limbs.Lt (fe25519_mul.spec l m) (2 ^ 52) := by
  obtain ⟨hv, hl⟩ := fe25519_mul.spec_val h.2 h'.2
  exact ⟨by rw [hv, h.1, h'.1, ← pow_add, hg], hl⟩

/-- `fe25519_pow22523` raises limbs below `2^54` to `(p - 5) / 8`, into limbs below `2^52`. -/
public theorem fe25519_pow22523.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) :
    Limbs.val (fe25519_pow22523.spec z) = Limbs.val z ^ ((p - 5) / 8) ∧
      Limbs.Lt (fe25519_pow22523.spec z) (2 ^ 52) := by
  have h0 := IsPow.self hz
  have h1 := h0.sq
  have h2 := h1.sq
  have h3 := h2.sq
  have h4 := h0.mul h3
  have h5 := h1.mul h4
  have h6 := h5.sq
  have h7 := h4.mul h6
  have h8 := h7.sq
  have h9 := h8.sqrN (n := 4)
  have h10 := h9.mul h7
  have h11 := h10.sq
  have h12 := h11.sqrN (n := 9)
  have h13 := h12.mul h10
  have h14 := h13.sq
  have h15 := h14.sqrN (n := 19)
  have h16 := h15.mul h13
  have h17 := h16.sqrN (n := 10)
  have h18 := h17.mul h10
  have h19 := h18.sq
  have h20 := h19.sqrN (n := 49)
  have h21 := h20.mul h18
  have h22 := h21.sq
  have h23 := h22.sqrN (n := 99)
  have h24 := h23.mul h21
  have h25 := h24.sqrN (n := 50)
  have h26 := h25.mul h18
  have h27 := h26.sq
  have h28 := h27.sq
  exact h28.mul_last h0 (by norm_num [p])

/-- `fe25519_invert` raises limbs below `2^54` to `p - 2` (the inverse, `0` at `0`), into limbs
below `2^52`. -/
public theorem fe25519_invert.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) :
    Limbs.val (fe25519_invert.spec z) = Limbs.val z ^ (p - 2) ∧
      Limbs.Lt (fe25519_invert.spec z) (2 ^ 52) := by
  have h0 := IsPow.self hz
  have h1 := h0.sq
  have h2 := h1.sq
  have h3 := h2.sq
  have h4 := h0.mul h3
  have h5 := h1.mul h4
  have h6 := h5.sq
  have h7 := h4.mul h6
  have h8 := h7.sq
  have h9 := h8.sqrN (n := 4)
  have h10 := h9.mul h7
  have h11 := h10.sq
  have h12 := h11.sqrN (n := 9)
  have h13 := h12.mul h10
  have h14 := h13.sq
  have h15 := h14.sqrN (n := 19)
  have h16 := h15.mul h13
  have h17 := h16.sqrN (n := 10)
  have h18 := h17.mul h10
  have h19 := h18.sq
  have h20 := h19.sqrN (n := 49)
  have h21 := h20.mul h18
  have h22 := h21.sq
  have h23 := h22.sqrN (n := 99)
  have h24 := h23.mul h21
  have h25 := h24.sqrN (n := 50)
  have h26 := h25.mul h18
  have h27 := h26.sqrN (n := 5)
  exact h27.mul_last h5 (by norm_num [p])

end MLIR.Sodium

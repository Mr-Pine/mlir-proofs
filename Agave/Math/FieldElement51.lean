module

public import Ed25519.Limbs
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_Neg_neg
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.FieldElement51_pow22501
public import Agave.Serial.FieldElement51_to_bytes
public import Agave.Serial.FieldElement51_is_negative
public import Agave.Serial.FieldElement51_ConstantTimeEq_ct_eq
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The serial `FieldElement51` arithmetic in `ZMod p`: each spec computes its field operation on
`Limbs.val`, under dalek's limb bounds (`Limbs.Lt`: below `2^54` into a product, below `2^52` out
of a carry). -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- Every limb below `c`. -/
abbrev Limbs.Lt (l : Fin 5 → BitVec 64) (c : ℕ) : Prop :=
  ∀ i, (l i).toNat < c

end

public theorem Limbs.Lt.mono {l : Fin 5 → BitVec 64} {c d : ℕ} (h : Limbs.Lt l c) (hcd : c ≤ d) :
    Limbs.Lt l d := fun i => (h i).trans_le hcd

public theorem Limbs.lt_iff (l : Fin 5 → BitVec 64) (c : ℕ) :
    Limbs.Lt l c ↔
      (l 0).toNat < c ∧ (l 1).toNat < c ∧ (l 2).toNat < c ∧ (l 3).toNat < c ∧ (l 4).toNat < c := by
  refine ⟨fun h => ⟨h 0, h 1, h 2, h 3, h 4⟩, fun h i => ?_⟩
  fin_cases i <;> simp [h]

namespace Serial

/-! ## Carries -/

/-- `x`'s low 51 bits and its carry, in `ZMod p`. -/
theorem mod_add_div51 (x : ℕ) : ((x % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (x / 2 ^ 51 : ℕ) = x := by
  exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ 51))

/-- `reduce`'s limbs: each limb's low 51 bits plus the carry of the one below, `19` times the top
carry into limb 0. -/
theorem FieldElement51.reduce_toNat (l : Fin 5 → BitVec 64) :
    (FieldElement51.reduce l 0).toNat = (l 4).toNat / 2 ^ 51 * 19 + (l 0).toNat % 2 ^ 51 ∧
      (FieldElement51.reduce l 1).toNat = (l 1).toNat % 2 ^ 51 + (l 0).toNat / 2 ^ 51 ∧
      (FieldElement51.reduce l 2).toNat = (l 2).toNat % 2 ^ 51 + (l 1).toNat / 2 ^ 51 ∧
      (FieldElement51.reduce l 3).toNat = (l 3).toNat % 2 ^ 51 + (l 2).toNat / 2 ^ 51 ∧
      (FieldElement51.reduce l 4).toNat = (l 4).toNat % 2 ^ 51 + (l 3).toNat / 2 ^ 51 := by
  have := (l 0).isLt
  have := (l 1).isLt
  have := (l 2).isLt
  have := (l 3).isLt
  have := (l 4).isLt
  simp only [FieldElement51.reduce, BitVec.toNat_add, BitVec.toNat_mul, toNat_shift, toNat_and_mask,
    show (19#64).toNat = 19 from rfl]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- `reduce` keeps the value and leaves limbs below `2^52`. -/
public theorem FieldElement51.reduce_val (l : Fin 5 → BitVec 64) :
    Limbs.val (FieldElement51.reduce l) = Limbs.val l ∧
      Limbs.Lt (FieldElement51.reduce l) (2 ^ 52) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := FieldElement51.reduce_toNat l
  refine ⟨?_, (Limbs.lt_iff _ _).2 ⟨by omega, by omega, by omega, by omega, by omega⟩⟩
  rw [Limbs.val_eq, Limbs.val_eq, h0, h1, h2, h3, h4]
  push_cast
  linear_combination
    mod_add_div51 (l 0).toNat + 2 ^ 51 * mod_add_div51 (l 1).toNat +
        2 ^ 102 * mod_add_div51 (l 2).toNat +
        2 ^ 153 * mod_add_div51 (l 3).toNat +
        2 ^ 204 * mod_add_div51 (l 4).toNat -
      (((l 4).toNat / 2 ^ 51 : ℕ) : ZMod p) * two_pow_255

/-! ## `add`, `sub`, `neg` -/

/-- `&a + &b` adds limbs below `A` and `B`, `A + B ≤ 2^64`, into limbs below `A + B`. -/
public theorem FieldElement51_Add_add.spec_val {a b : Fin 5 → BitVec 64} {A B : ℕ}
    (ha : Limbs.Lt a A) (hb : Limbs.Lt b B) (h : A + B ≤ 2 ^ 64) :
    Limbs.val (FieldElement51_Add_add.spec a b) = Limbs.val a + Limbs.val b ∧
      Limbs.Lt (FieldElement51_Add_add.spec a b) (A + B) := by
  have e (i : Fin 5) : (FieldElement51_Add_add.spec a b i).toNat = (a i).toNat + (b i).toNat := by
    have := ha i
    have := hb i
    simp only [FieldElement51_Add_add.spec, BitVec.toNat_add]
    omega
  refine
    ⟨?_, fun i => by
      have := ha i; have := hb i; rw [e]; omega⟩
  simp only [Limbs.val, e]
  push_cast
  rw [← Finset.sum_add_distrib]
  simp only [add_mul]

/-- `16 p`'s limbs: their value is `0`. -/
theorem val_p16 :
    ((36028797018963664 + 36028797018963952 * 2 ^ 51 + 36028797018963952 * 2 ^ 102 +
            36028797018963952 * 2 ^ 153 +
            36028797018963952 * 2 ^ 204 :
          ℕ) :
        ZMod p) =
      0 := by
  rw [show
      36028797018963664 + 36028797018963952 * 2 ^ 51 + 36028797018963952 * 2 ^ 102 +
          36028797018963952 * 2 ^ 153 +
          36028797018963952 * 2 ^ 204 =
        16 * p
      by norm_num]
  simp

/-- A limb of `x + c - y`, no wrap for `x + c < 2^64` and `y ≤ c`. -/
theorem sub_limb_toNat {x c y : BitVec 64} (h : x.toNat + c.toNat < 2 ^ 64)
    (hy : y.toNat ≤ c.toNat) : (x + c - y).toNat + y.toNat = x.toNat + c.toNat := by
  rw [BitVec.toNat_sub, BitVec.toNat_add]
  omega

/-- A limb of `c - y`, no wrap for `y ≤ c`. -/
theorem neg_limb_toNat {c y : BitVec 64} (hy : y.toNat ≤ c.toNat) :
    (c - y).toNat + y.toNat = c.toNat := by
  rw [BitVec.toNat_sub]
  omega

/-- `&a - &b` subtracts limbs below `2^54` into limbs below `2^52`. -/
public theorem FieldElement51_Sub_sub.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54))
    (hb : Limbs.Lt b (2 ^ 54)) :
    Limbs.val (FieldElement51_Sub_sub.spec a b) = Limbs.val a - Limbs.val b ∧
      Limbs.Lt (FieldElement51_Sub_sub.spec a b) (2 ^ 52) := by
  obtain ⟨hv, hl⟩ := FieldElement51.reduce_val fun i => a i + p16 i - b i
  refine ⟨?_, hl⟩
  rw [FieldElement51_Sub_sub.spec, hv]
  obtain ⟨a0, a1, a2, a3, a4⟩ := (Limbs.lt_iff _ _).1 ha
  obtain ⟨b0, b1, b2, b3, b4⟩ := (Limbs.lt_iff _ _).1 hb
  have k0 : (p16 0).toNat = 36028797018963664 := rfl
  have k (i : Fin 5) (hi : i ≠ 0) : (p16 i).toNat = 36028797018963952 := by
    fin_cases i
    · exact absurd rfl hi
    all_goals rfl
  have e0 :=
    congrArg (Nat.cast (R := ZMod p))
      (sub_limb_toNat (x := a 0) (c := p16 0) (y := b 0) (by omega) (by omega))
  have e1 :=
    congrArg (Nat.cast (R := ZMod p))
      (sub_limb_toNat (x := a 1) (c := p16 1) (y := b 1)
        (by
          rw [k 1 (by decide)]; omega)
        (by
          rw [k 1 (by decide)]; omega))
  have e2 :=
    congrArg (Nat.cast (R := ZMod p))
      (sub_limb_toNat (x := a 2) (c := p16 2) (y := b 2)
        (by
          rw [k 2 (by decide)]; omega)
        (by
          rw [k 2 (by decide)]; omega))
  have e3 :=
    congrArg (Nat.cast (R := ZMod p))
      (sub_limb_toNat (x := a 3) (c := p16 3) (y := b 3)
        (by
          rw [k 3 (by decide)]; omega)
        (by
          rw [k 3 (by decide)]; omega))
  have e4 :=
    congrArg (Nat.cast (R := ZMod p))
      (sub_limb_toNat (x := a 4) (c := p16 4) (y := b 4)
        (by
          rw [k 4 (by decide)]; omega)
        (by
          rw [k 4 (by decide)]; omega))
  rw [k0] at e0
  rw [k 1 (by decide)] at e1
  rw [k 2 (by decide)] at e2
  rw [k 3 (by decide)] at e3
  rw [k 4 (by decide)] at e4
  have hP := val_p16
  push_cast at e0 e1 e2 e3 e4 hP
  rw [Limbs.val_eq, Limbs.val_eq, Limbs.val_eq]
  linear_combination e0 + 2 ^ 51 * e1 + 2 ^ 102 * e2 + 2 ^ 153 * e3 + 2 ^ 204 * e4 + hP

/-- `-&a` negates limbs below `2^54` into limbs below `2^52`. -/
public theorem FieldElement51_Neg_neg.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54)) :
    Limbs.val (FieldElement51_Neg_neg.spec a) = -Limbs.val a ∧
      Limbs.Lt (FieldElement51_Neg_neg.spec a) (2 ^ 52) := by
  obtain ⟨hv, hl⟩ := FieldElement51.reduce_val fun i => p16 i - a i
  refine ⟨?_, hl⟩
  rw [FieldElement51_Neg_neg.spec, hv]
  obtain ⟨a0, a1, a2, a3, a4⟩ := (Limbs.lt_iff _ _).1 ha
  have k0 : (p16 0).toNat = 36028797018963664 := rfl
  have k (i : Fin 5) (hi : i ≠ 0) : (p16 i).toNat = 36028797018963952 := by
    fin_cases i
    · exact absurd rfl hi
    all_goals rfl
  have e0 := congrArg (Nat.cast (R := ZMod p)) (neg_limb_toNat (c := p16 0) (y := a 0) (by omega))
  have e1 :=
    congrArg (Nat.cast (R := ZMod p))
      (neg_limb_toNat (c := p16 1) (y := a 1)
        (by
          rw [k 1 (by decide)]; omega))
  have e2 :=
    congrArg (Nat.cast (R := ZMod p))
      (neg_limb_toNat (c := p16 2) (y := a 2)
        (by
          rw [k 2 (by decide)]; omega))
  have e3 :=
    congrArg (Nat.cast (R := ZMod p))
      (neg_limb_toNat (c := p16 3) (y := a 3)
        (by
          rw [k 3 (by decide)]; omega))
  have e4 :=
    congrArg (Nat.cast (R := ZMod p))
      (neg_limb_toNat (c := p16 4) (y := a 4)
        (by
          rw [k 4 (by decide)]; omega))
  rw [k0] at e0
  rw [k 1 (by decide)] at e1
  rw [k 2 (by decide)] at e2
  rw [k 3 (by decide)] at e3
  rw [k 4 (by decide)] at e4
  have hP := val_p16
  push_cast at e0 e1 e2 e3 e4 hP
  rw [Limbs.val_eq, Limbs.val_eq]
  linear_combination e0 + 2 ^ 51 * e1 + 2 ^ 102 * e2 + 2 ^ 153 * e3 + 2 ^ 204 * e4 + hP

/-! ## Products -/

theorem toNat_carry128 (x : BitVec 128) : (carry128 x).toNat = x.toNat / 2 ^ 51 % 2 ^ 64 := by
  rw [BitVec.toNat_and, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, ←
    Nat.and_two_pow_sub_one_eq_mod]
  rfl

theorem toNat_shift_setWidth (x : BitVec 128) :
    ((x >>> 51).setWidth 64).toNat = x.toNat / 2 ^ 51 % 2 ^ 64 := by
  rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- dalek's carries after a product's 128-bit column sums `c0 … c4` (`mul`, `pow2k`): each into
the next at bit 51, `carry * 19` into limb 0, then one carry out of limb 0. -/
def carry5 (c0 c1 c2 c3 c4 : BitVec 128) : Fin 5 → BitVec 64 :=
  let c1 := c1 + carry128 c0
  let out0 := c0.setWidth 64 &&& mask51
  let c2 := c2 + carry128 c1
  let out1 := c1.setWidth 64 &&& mask51
  let c3 := c3 + carry128 c2
  let out2 := c2.setWidth 64 &&& mask51
  let c4 := c4 + carry128 c3
  let out3 := c3.setWidth 64 &&& mask51
  let carry := (c4 >>> 51).setWidth 64
  let out4 := c4.setWidth 64 &&& mask51
  let out0 := carry * 19#64 + out0
  let out1 := out0 >>> 51 + out1
  fun
  | 0 => out0 &&& mask51
  | 1 => out1
  | 2 => out2
  | 3 => out3
  | 4 => out4

/-- `carry5`'s value identity in `ℕ`, cast to `ZMod p`. -/
theorem carry5_val {C0 C1 C2 C3 C4 r1 r2 r3 r4 u0 u1 : ℕ} (ht1 : r1 = C1 + C0 / 2 ^ 51)
    (ht2 : r2 = C2 + r1 / 2 ^ 51) (ht3 : r3 = C3 + r2 / 2 ^ 51) (ht4 : r4 = C4 + r3 / 2 ^ 51)
    (hu0 : u0 = r4 / 2 ^ 51 * 19 + C0 % 2 ^ 51) (hu1 : u1 = u0 / 2 ^ 51 + r1 % 2 ^ 51) :
    ((u0 % 2 ^ 51 : ℕ) : ZMod p) + (u1 : ℕ) * 2 ^ 51 + (r2 % 2 ^ 51 : ℕ) * 2 ^ 102 +
        (r3 % 2 ^ 51 : ℕ) * 2 ^ 153 +
        (r4 % 2 ^ 51 : ℕ) * 2 ^ 204 =
      C0 + C1 * 2 ^ 51 + C2 * 2 ^ 102 + C3 * 2 ^ 153 + C4 * 2 ^ 204 := by
  have T1 := congrArg (Nat.cast (R := ZMod p)) ht1
  have T2 := congrArg (Nat.cast (R := ZMod p)) ht2
  have T3 := congrArg (Nat.cast (R := ZMod p)) ht3
  have T4 := congrArg (Nat.cast (R := ZMod p)) ht4
  have U0 := congrArg (Nat.cast (R := ZMod p)) hu0
  have U1 := congrArg (Nat.cast (R := ZMod p)) hu1
  have e0 := mod_add_div51 C0
  have e1 := mod_add_div51 r1
  have e2 := mod_add_div51 r2
  have e3 := mod_add_div51 r3
  have e4 := mod_add_div51 r4
  have eu := mod_add_div51 u0
  push_cast at T1 T2 T3 T4 U0 U1 ⊢
  linear_combination
    2 ^ 51 * U1 + eu + U0 + e0 + 2 ^ 51 * T1 + 2 ^ 51 * e1 + 2 ^ 102 * T2 + 2 ^ 102 * e2 +
        2 ^ 153 * T3 +
        2 ^ 153 * e3 +
        2 ^ 204 * T4 +
        2 ^ 204 * e4 -
      (r4 / 2 ^ 51 : ℕ) * two_pow_255

/-- `carry5` computes the columns' value into limbs below `2^52`, the columns below `2^115 - 2^64`
and the top one at most `5 · 2^108` (so `carry * 19` does not wrap). -/
theorem carry5_spec {c0 c1 c2 c3 c4 : BitVec 128} (h0 : c0.toNat < 2 ^ 115 - 2 ^ 64)
    (h1 : c1.toNat < 2 ^ 115 - 2 ^ 64) (h2 : c2.toNat < 2 ^ 115 - 2 ^ 64)
    (h3 : c3.toNat < 2 ^ 115 - 2 ^ 64) (h4 : c4.toNat ≤ 5 * 2 ^ 108) :
    Limbs.val (carry5 c0 c1 c2 c3 c4) =
        c0.toNat + c1.toNat * 2 ^ 51 + c2.toNat * 2 ^ 102 + c3.toNat * 2 ^ 153 +
          c4.toNat * 2 ^ 204 ∧
      Limbs.Lt (carry5 c0 c1 c2 c3 c4) (2 ^ 52) := by
  rw [Limbs.val_eq, Limbs.lt_iff]
  dsimp only [carry5]
  generalize hr1 : c1 + carry128 c0 = r1
  generalize hr2 : c2 + carry128 r1 = r2
  generalize hr3 : c3 + carry128 r2 = r3
  generalize hr4 : c4 + carry128 r3 = r4
  generalize hu0 : (r4 >>> 51).setWidth 64 * 19#64 + (c0.setWidth 64 &&& mask51) = u0
  generalize hu1 : u0 >>> 51 + (r1.setWidth 64 &&& mask51) = u1
  have k1 : r1.toNat = c1.toNat + c0.toNat / 2 ^ 51 := by
    rw [← hr1, BitVec.toNat_add, toNat_carry128]; omega
  have k2 : r2.toNat = c2.toNat + r1.toNat / 2 ^ 51 := by
    rw [← hr2, BitVec.toNat_add, toNat_carry128]; omega
  have k3 : r3.toNat = c3.toNat + r2.toNat / 2 ^ 51 := by
    rw [← hr3, BitVec.toNat_add, toNat_carry128]; omega
  have k4 : r4.toNat = c4.toNat + r3.toNat / 2 ^ 51 := by
    rw [← hr4, BitVec.toNat_add, toNat_carry128]; omega
  have ku0 : u0.toNat = r4.toNat / 2 ^ 51 * 19 + c0.toNat % 2 ^ 51 := by
    rw [← hu0, BitVec.toNat_add, BitVec.toNat_mul, toNat_shift_setWidth, toNat_setWidth_mask,
      show (19#64).toNat = 19 from rfl]
    omega
  have ku1 : u1.toNat = u0.toNat / 2 ^ 51 + r1.toNat % 2 ^ 51 := by
    rw [← hu1, BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  simp only [toNat_setWidth_mask]
  simp only [toNat_and_mask]
  refine ⟨carry5_val k1 k2 k3 k4 ku0 ku1, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- `carry5_spec` over column sums known through `ValLe`. -/
theorem carry5_valLe {c0 c1 c2 c3 c4 : BitVec 128} {v : ZMod p} (h0 : ValLe c0 n0 M0)
    (h1 : ValLe c1 n1 M1) (h2 : ValLe c2 n2 M2) (h3 : ValLe c3 n3 M3) (h4 : ValLe c4 n4 M4)
    (hM :
      M0 < 2 ^ 115 - 2 ^ 64 ∧
        M1 < 2 ^ 115 - 2 ^ 64 ∧ M2 < 2 ^ 115 - 2 ^ 64 ∧ M3 < 2 ^ 115 - 2 ^ 64 ∧ M4 ≤ 5 * 2 ^ 108)
    (hv : (n0 : ZMod p) + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204 = v) :
    Limbs.val (carry5 c0 c1 c2 c3 c4) = v ∧ Limbs.Lt (carry5 c0 c1 c2 c3 c4) (2 ^ 52) := by
  obtain ⟨rfl, h0⟩ := h0
  obtain ⟨rfl, h1⟩ := h1
  obtain ⟨rfl, h2⟩ := h2
  obtain ⟨rfl, h3⟩ := h3
  obtain ⟨rfl, h4⟩ := h4
  obtain ⟨hv', ht⟩ :=
    carry5_spec (c0 := c0) (c1 := c1) (c2 := c2) (c3 := c3) (c4 := c4) (by omega) (by omega)
      (by omega) (by omega) (by omega)
  exact ⟨hv'.trans hv, ht⟩

/-- `mul.spec` is `carry5` of the product's column sums. -/
theorem FieldElement51_Mul_mul.spec_eq (a b : Fin 5 → BitVec 64) :
    FieldElement51_Mul_mul.spec a b =
      carry5
        (mulWide (a 4) (b 1 * 19#64) + mulWide (b 0) (a 0) + mulWide (a 3) (b 2 * 19#64) +
          mulWide (a 2) (b 3 * 19#64) +
          mulWide (a 1) (b 4 * 19#64))
        (mulWide (a 4) (b 2 * 19#64) + mulWide (a 0) (b 1) + mulWide (a 3) (b 3 * 19#64) +
          mulWide (a 2) (b 4 * 19#64) +
          mulWide (a 1) (b 0))
        (mulWide (a 4) (b 3 * 19#64) + mulWide (a 0) (b 2) + mulWide (a 3) (b 4 * 19#64) +
          mulWide (a 2) (b 0) +
          mulWide (a 1) (b 1))
        (mulWide (a 4) (b 4 * 19#64) + mulWide (a 0) (b 3) + mulWide (a 3) (b 0) +
          mulWide (a 2) (b 1) +
          mulWide (a 1) (b 2))
        (mulWide (a 4) (b 0) + mulWide (a 0) (b 4) + mulWide (a 3) (b 1) + mulWide (a 2) (b 2) +
          mulWide (a 1) (b 3)) := by
  funext i
  fin_cases i <;> rfl

/-- `&a * &b` multiplies limbs below `2^54` into limbs below `2^52`. -/
public theorem FieldElement51_Mul_mul.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54))
    (hb : Limbs.Lt b (2 ^ 54)) :
    Limbs.val (FieldElement51_Mul_mul.spec a b) = Limbs.val a * Limbs.val b ∧
      Limbs.Lt (FieldElement51_Mul_mul.spec a b) (2 ^ 52) := by
  have hA i : ValLe (a i) (a i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := ha i; omega⟩
  have hB i : ValLe (b i) (b i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := hb i; omega⟩
  rw [FieldElement51_Mul_mul.spec_eq]
  apply carry5_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq, Limbs.val_eq]
    simp only [show (19#64).toNat = 19 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    generalize ((b 0).toNat : ZMod p) = b0
    generalize ((b 1).toNat : ZMod p) = b1
    generalize ((b 2).toNat : ZMod p) = b2
    generalize ((b 3).toNat : ZMod p) = b3
    generalize ((b 4).toNat : ZMod p) = b4
    linear_combination
      -(a1 * b4 + a2 * b3 + a3 * b2 + a4 * b1 + (a2 * b4 + a3 * b3 + a4 * b2) * 2 ^ 51 +
            (a3 * b4 + a4 * b3) * 2 ^ 102 +
            a4 * b4 * 2 ^ 153) *
        two_pow_255

/-- `pow2k`'s squaring is `carry5` of the square's column sums. -/
theorem FieldElement51_pow2k.square_eq (a : Fin 5 → BitVec 64) :
    FieldElement51_pow2k.square a =
      carry5
        (mulWide (a 1) (a 4 * 19#64) <<< 1 + mulWide (a 2) (a 3 * 19#64) <<< 1 +
          mulWide (a 0) (a 0))
        (mulWide (a 0) (a 1) <<< 1 + mulWide (a 2) (a 4 * 19#64) <<< 1 +
          mulWide (a 3 * 19#64) (a 3))
        (mulWide (a 0) (a 2) <<< 1 + mulWide (a 3 * 19#64) (a 4) <<< 1 + mulWide (a 1) (a 1))
        (mulWide (a 0) (a 3) <<< 1 + mulWide (a 1) (a 2) <<< 1 + mulWide (a 4 * 19#64) (a 4))
        (mulWide (a 0) (a 4) <<< 1 + mulWide (a 1) (a 3) <<< 1 + mulWide (a 2) (a 2)) := by
  funext i
  fin_cases i <;> rfl

/-- One pass of `pow2k` squares limbs below `2^54` into limbs below `2^52`. -/
public theorem FieldElement51_pow2k.square_val {a : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54)) :
    Limbs.val (FieldElement51_pow2k.square a) = Limbs.val a ^ 2 ∧
      Limbs.Lt (FieldElement51_pow2k.square a) (2 ^ 52) := by
  have hA i : ValLe (a i) (a i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := ha i; omega⟩
  rw [FieldElement51_pow2k.square_eq]
  apply carry5_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.shl, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19#64).toNat = 19 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    linear_combination
      -(2 * a1 * a4 + 2 * a2 * a3 + (2 * a2 * a4 + a3 * a3) * 2 ^ 51 + 2 * a3 * a4 * 2 ^ 102 +
            a4 * a4 * 2 ^ 153) *
        two_pow_255

/-- `sqrN k` raises limbs below `2^54` to the `2^k`-th power; for `k > 0` into limbs below
`2^52`. -/
public theorem FieldElement51_pow2k.sqrN_val :
    ∀ (k : ℕ) {a : Fin 5 → BitVec 64},
      Limbs.Lt a (2 ^ 54) →
        Limbs.val (FieldElement51_pow2k.sqrN k a) = Limbs.val a ^ 2 ^ k ∧
          (0 < k → Limbs.Lt (FieldElement51_pow2k.sqrN k a) (2 ^ 52))
  | 0, a, _ => ⟨by simp [FieldElement51_pow2k.sqrN], by omega⟩
  | k + 1, a, ha => by
    obtain ⟨hv, hl⟩ := FieldElement51_pow2k.square_val ha
    obtain ⟨hv', hl'⟩ := FieldElement51_pow2k.sqrN_val k (hl.mono (by decide))
    refine ⟨?_, fun _ => ?_⟩
    · rw [FieldElement51_pow2k.sqrN, hv', hv, ← pow_mul, pow_succ']
    · rcases Nat.eq_zero_or_pos k with rfl | hk
      · exact hl
      · exact hl' hk

/-- `a.pow2k(k)`, `k > 0`, raises limbs below `2^54` to the `2^k`-th power, into limbs below
`2^52`. -/
public theorem FieldElement51_pow2k.spec_val {a : Fin 5 → BitVec 64} {k : ℕ} (hk : 0 < k)
    (ha : Limbs.Lt a (2 ^ 54)) :
    Limbs.val (FieldElement51_pow2k.spec a k) = Limbs.val a ^ 2 ^ k ∧
      Limbs.Lt (FieldElement51_pow2k.spec a k) (2 ^ 52) :=
  ⟨(FieldElement51_pow2k.sqrN_val k ha).1, (FieldElement51_pow2k.sqrN_val k ha).2 hk⟩

/-- `a.square()` squares limbs below `2^54` into limbs below `2^52`. -/
public theorem FieldElement51_square.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54)) :
    Limbs.val (FieldElement51_square.spec a) = Limbs.val a ^ 2 ∧
      Limbs.Lt (FieldElement51_square.spec a) (2 ^ 52) :=
  FieldElement51_pow2k.spec_val (k := 1) (by decide) ha

/-! ## `pow22501` -/

/-- `l` holds `z^e` in limbs below `2^52`. -/
def IsPow (l z : Fin 5 → BitVec 64) (e : ℕ) : Prop :=
  Limbs.val l = Limbs.val z ^ e ∧ Limbs.Lt l (2 ^ 52)

theorem IsPow.congr (h : IsPow l z e) (he : e = e') : IsPow l z e' :=
  he ▸ h

theorem IsPow.sq (h : IsPow l z e) : IsPow (FieldElement51_square.spec l) z (e * 2) := by
  obtain ⟨hv, hl⟩ := FieldElement51_square.spec_val (h.2.mono (by decide))
  exact ⟨by rw [hv, h.1, pow_mul], hl⟩

theorem IsPow.pow2k (h : IsPow l z e) (hk : 0 < k) :
    IsPow (FieldElement51_pow2k.spec l k) z (e * 2 ^ k) := by
  obtain ⟨hv, hl⟩ := FieldElement51_pow2k.spec_val hk (h.2.mono (by decide))
  exact ⟨by rw [hv, h.1, pow_mul], hl⟩

theorem IsPow.mul (h : IsPow l z e) (h' : IsPow m z f) :
    IsPow (FieldElement51_Mul_mul.spec l m) z (e + f) := by
  obtain ⟨hv, hl⟩ := FieldElement51_Mul_mul.spec_val (h.2.mono (by decide)) (h'.2.mono (by decide))
  exact ⟨by rw [hv, h.1, h'.1, pow_add], hl⟩

/-- `z.pow22501()` takes limbs below `2^54` to `(z^(2^250 - 1), z^11)`, both in limbs below
`2^52`. -/
public theorem FieldElement51_pow22501.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) :
    (Limbs.val (FieldElement51_pow22501.spec z).1 = Limbs.val z ^ (2 ^ 250 - 1) ∧
        Limbs.Lt (FieldElement51_pow22501.spec z).1 (2 ^ 52)) ∧
      Limbs.val (FieldElement51_pow22501.spec z).2 = Limbs.val z ^ 11 ∧
      Limbs.Lt (FieldElement51_pow22501.spec z).2 (2 ^ 52) := by
  dsimp only [FieldElement51_pow22501.spec]
  have t0 : IsPow (FieldElement51_square.spec z) z 2 := by
    obtain ⟨hv, hl⟩ := FieldElement51_square.spec_val hz
    exact ⟨hv, hl⟩
  have t1 := t0.sq.sq
  have t2 :
    IsPow
      (FieldElement51_Mul_mul.spec z
        (FieldElement51_square.spec (FieldElement51_square.spec (FieldElement51_square.spec z))))
      z (1 + 2 * 2 * 2) := by
    obtain ⟨hv, hl⟩ := FieldElement51_Mul_mul.spec_val hz (t1.2.mono (by decide))
    exact ⟨by rw [hv, t1.1, pow_add, pow_one], hl⟩
  have t3 := t0.mul t2
  have t5 := t2.mul t3.sq
  have t7 := (t5.pow2k (k := 5) (by decide)).mul t5
  have t9 := (t7.pow2k (k := 10) (by decide)).mul t7
  have t11 := (t9.pow2k (k := 20) (by decide)).mul t9
  have t13 := (t11.pow2k (k := 10) (by decide)).mul t7
  have t15 := (t13.pow2k (k := 50) (by decide)).mul t13
  have t17 := (t15.pow2k (k := 100) (by decide)).mul t15
  have t19 := (t17.pow2k (k := 50) (by decide)).mul t13
  exact ⟨t19.congr (by norm_num), t3.congr (by norm_num)⟩

/-! ## `to_bytes` -/

/-- `bytes` of 51-bit limbs is their 255-bit sum. -/
theorem FieldElement51_to_bytes.bytes_eq_sum {l0 l1 l2 l3 l4 : BitVec 64}
    (h0 : l0 < 0x8000000000000#64) (h1 : l1 < 0x8000000000000#64) (h2 : l2 < 0x8000000000000#64)
    (h3 : l3 < 0x8000000000000#64) (h4 : l4 < 0x8000000000000#64) :
    FieldElement51_to_bytes.bytes l0 l1 l2 l3 l4 =
      l0.setWidth 256 + l1.setWidth 256 <<< 51 + l2.setWidth 256 <<< 102 + l3.setWidth 256 <<< 153 +
        l4.setWidth 256 <<< 204 := by
  simp only [FieldElement51_to_bytes.bytes]
  bv_decide

theorem FieldElement51_to_bytes.bytes_toNat {l0 l1 l2 l3 l4 : BitVec 64} (h0 : l0.toNat < 2 ^ 51)
    (h1 : l1.toNat < 2 ^ 51) (h2 : l2.toNat < 2 ^ 51) (h3 : l3.toNat < 2 ^ 51)
    (h4 : l4.toNat < 2 ^ 51) :
    (FieldElement51_to_bytes.bytes l0 l1 l2 l3 l4).toNat =
      l0.toNat + l1.toNat * 2 ^ 51 + l2.toNat * 2 ^ 102 + l3.toNat * 2 ^ 153 +
        l4.toNat * 2 ^ 204 := by
  rw [FieldElement51_to_bytes.bytes_eq_sum (BitVec.lt_def.2 h0) (BitVec.lt_def.2 h1)
      (BitVec.lt_def.2 h2) (BitVec.lt_def.2 h3) (BitVec.lt_def.2 h4)]
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq]
  omega

/-- A carry into the next limb, as a division: `(x / B^k + r) / B = (x + r B^k) / B^(k+1)`. -/
theorem div_carry (x r k : ℕ) :
    (x / 2 ^ (51 * k) + r) / 2 ^ 51 = (x + r * 2 ^ (51 * k)) / 2 ^ (51 * (k + 1)) := by
  rw [show 51 * (k + 1) = 51 * k + 51 by ring, pow_add, ← Nat.div_div_eq_div_mul,
    Nat.add_mul_div_right _ _ (Nat.two_pow_pos _)]

/-- `to_bytes`'s limbs are 51 bits, and their number is the value's representative in `[0, p)`. -/
public theorem FieldElement51_to_bytes.limbs_spec (a : Fin 5 → BitVec 64) :
    Limbs.Lt (FieldElement51_to_bytes.limbs a) (2 ^ 51) ∧
      Limbs.nat (FieldElement51_to_bytes.limbs a) = (Limbs.val a).val := by
  obtain ⟨hv, -⟩ := FieldElement51.reduce_val a
  obtain ⟨e0, e1, e2, e3, e4⟩ := FieldElement51.reduce_toNat a
  have := (a 0).isLt
  have := (a 1).isLt
  have := (a 2).isLt
  have := (a 3).isLt
  have := (a 4).isLt
  rw [Limbs.lt_iff, Limbs.nat, ← hv, Limbs.val_nat, Limbs.nat, ZMod.val_natCast]
  dsimp only [FieldElement51_to_bytes.limbs]
  generalize FieldElement51.reduce a = r at e0 e1 e2 e3 e4
  generalize hR0 : (r 0).toNat = R0 at e0
  generalize hR1 : (r 1).toNat = R1 at e1
  generalize hR2 : (r 2).toNat = R2 at e2
  generalize hR3 : (r 3).toNat = R3 at e3
  generalize hR4 : (r 4).toNat = R4 at e4
  have b0 : R0 < 2 ^ 51 + 19 * 2 ^ 13 := by omega
  have b1 : R1 < 2 ^ 51 + 2 ^ 13 := by omega
  have b2 : R2 < 2 ^ 51 + 2 ^ 13 := by omega
  have b3 : R3 < 2 ^ 51 + 2 ^ 13 := by omega
  have b4 : R4 < 2 ^ 51 + 2 ^ 13 := by omega
  clear e0 e1 e2 e3 e4
  -- q = (h + 19) / 2^255, limb by limb
  generalize hq0 : (r 0 + 19#64) >>> 51 = q0
  generalize hq1 : (q0 + r 1) >>> 51 = q1
  generalize hq2 : (q1 + r 2) >>> 51 = q2
  generalize hq3 : (q2 + r 3) >>> 51 = q3
  generalize hq4 : (q3 + r 4) >>> 51 = q4
  have k0 : q0.toNat = (R0 + 19) / 2 ^ 51 := by
    rw [← hq0, toNat_shift, BitVec.toNat_add, hR0, show (19#64).toNat = 19 from rfl]; omega
  have k1 : q1.toNat = (R0 + 19 + R1 * 2 ^ 51) / 2 ^ 102 := by
    rw [← hq1, toNat_shift, BitVec.toNat_add, hR1, k0, Nat.mod_eq_of_lt (by omega)]
    exact div_carry _ _ 1
  have k2 : q2.toNat = (R0 + 19 + R1 * 2 ^ 51 + R2 * 2 ^ 102) / 2 ^ 153 := by
    rw [← hq2, toNat_shift, BitVec.toNat_add, hR2, k1, Nat.mod_eq_of_lt (by omega)]
    exact div_carry _ _ 2
  have k3 : q3.toNat = (R0 + 19 + R1 * 2 ^ 51 + R2 * 2 ^ 102 + R3 * 2 ^ 153) / 2 ^ 204 := by
    rw [← hq3, toNat_shift, BitVec.toNat_add, hR3, k2, Nat.mod_eq_of_lt (by omega)]
    exact div_carry _ _ 3
  have k4 :
    q4.toNat = (R0 + 19 + R1 * 2 ^ 51 + R2 * 2 ^ 102 + R3 * 2 ^ 153 + R4 * 2 ^ 204) / 2 ^ 255 := by
    rw [← hq4, toNat_shift, BitVec.toNat_add, hR4, k3, Nat.mod_eq_of_lt (by omega)]
    exact div_carry _ _ 4
  -- `19 q` added and carried
  generalize hl0 : q4 * 19#64 + r 0 = l0
  generalize hl1 : l0 >>> 51 + r 1 = l1
  generalize hl2 : l1 >>> 51 + r 2 = l2
  generalize hl3 : l2 >>> 51 + r 3 = l3
  generalize hl4 : l3 >>> 51 + r 4 = l4
  have hq : q4.toNat ≤ 1 := by
    rw [k4]; omega
  have j0 : l0.toNat = q4.toNat * 19 + R0 := by
    rw [← hl0, BitVec.toNat_add, BitVec.toNat_mul, hR0, show (19#64).toNat = 19 from rfl]
    omega
  have j1 : l1.toNat = l0.toNat / 2 ^ 51 + R1 := by
    rw [← hl1, BitVec.toNat_add, toNat_shift, hR1]; omega
  have j2 : l2.toNat = l1.toNat / 2 ^ 51 + R2 := by
    rw [← hl2, BitVec.toNat_add, toNat_shift, hR2]; omega
  have j3 : l3.toNat = l2.toNat / 2 ^ 51 + R3 := by
    rw [← hl3, BitVec.toNat_add, toNat_shift, hR3]; omega
  have j4 : l4.toNat = l3.toNat / 2 ^ 51 + R4 := by
    rw [← hl4, BitVec.toNat_add, toNat_shift, hR4]; omega
  simp only [toNat_and_mask]
  refine ⟨⟨by omega, by omega, by omega, by omega, by omega⟩, ?_⟩
  change _ = _ % (2 ^ 255 - 19)
  clear k0 k1 k2 k3 hq0 hq1 hq2 hq3 hq4 hl0 hl1 hl2 hl3 hl4
  generalize hh : R0 + R1 * 2 ^ 51 + R2 * 2 ^ 102 + R3 * 2 ^ 153 + R4 * 2 ^ 204 = h
  have hk4 : q4.toNat = (h + 19) / 2 ^ 255 := by
    rw [k4, ← hh]; congr 1; omega
  have hP :
    2 ^ 255 - 19 =
      57896044618658097711785492504343953926634992332820282019728792003956564819949 := by
    norm_num
  rw [hP]
  have hlt :
    h < 2 * 57896044618658097711785492504343953926634992332820282019728792003956564819949 := by
    omega
  have hc :
    (q4.toNat = 1 ∧
        57896044618658097711785492504343953926634992332820282019728792003956564819949 ≤ h) ∨
      (q4.toNat = 0 ∧
        h < 57896044618658097711785492504343953926634992332820282019728792003956564819949) := by
    rw [hk4]; omega
  clear k4 hk4
  rcases hc with ⟨hq1, hp⟩ | ⟨hq0, hp⟩
  · rw [Nat.mod_eq_sub_mod hp,
      Nat.mod_eq_of_lt (a :=
        h - 57896044618658097711785492504343953926634992332820282019728792003956564819949)
        (by omega)]
    omega
  · rw [Nat.mod_eq_of_lt hp]
    omega

/-- `a.to_bytes()` is the canonical encoding: its number is `a`'s value's representative in
`[0, p)`, for any limbs. -/
public theorem FieldElement51_to_bytes.spec_val (a : Fin 5 → BitVec 64) :
    (FieldElement51_to_bytes.spec a).toNat = (Limbs.val a).val := by
  obtain ⟨hl, hn⟩ := FieldElement51_to_bytes.limbs_spec a
  rw [FieldElement51_to_bytes.spec,
    FieldElement51_to_bytes.bytes_toNat (hl 0) (hl 1) (hl 2) (hl 3) (hl 4), ← hn, Limbs.nat]

/-- Equal encodings, equal values. -/
public theorem FieldElement51_to_bytes.spec_eq_iff (a b : Fin 5 → BitVec 64) :
    FieldElement51_to_bytes.spec a = FieldElement51_to_bytes.spec b ↔
      Limbs.val a = Limbs.val b := by
  rw [← BitVec.toNat_inj, FieldElement51_to_bytes.spec_val, FieldElement51_to_bytes.spec_val]
  exact ZMod.val_injective _ |>.eq_iff

/-! ## `is_negative`, `ct_eq` -/

/-- `a.is_negative()` is the canonical representative's parity. -/
public theorem FieldElement51_is_negative.spec_val (a : Fin 5 → BitVec 64) :
    (FieldElement51_is_negative.spec a).toNat = (Limbs.val a).val % 2 := by
  rw [FieldElement51_is_negative.spec, BitVec.toNat_and, BitVec.toNat_setWidth,
    FieldElement51_to_bytes.spec_val, show (1#8).toNat = 1 from rfl, Nat.and_one_is_mod,
    Nat.mod_mod_of_dvd _ (by decide)]

/-- `a.ct_eq(&b)` is `1` iff the values are equal, else `0`. -/
public theorem FieldElement51_ConstantTimeEq_ct_eq.spec_val (a b : Fin 5 → BitVec 64) :
    FieldElement51_ConstantTimeEq_ct_eq.spec a b =
      if Limbs.val a = Limbs.val b then 1#8 else 0#8 := by
  rw [FieldElement51_ConstantTimeEq_ct_eq.spec, slice_u8_ConstantTimeEq_ct_eq.spec_eq]
  simp only [FieldElement51_to_bytes.spec_eq_iff]

end Serial

end MLIR.Agave

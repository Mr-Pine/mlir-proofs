module

public import Firedancer.Bn254.Math.Glv
public import Firedancer.Bn254.Math.Point
import Mathlib.FieldTheory.Finiteness
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.Algebra.Module.ZMod
import Mathlib.Data.Fintype.Option
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The endomorphism `φ(x, y) = (βx, y)` of `y² = x³ + 3` over `ZMod p`: a group endomorphism
with `φ² + φ + 1 = 0`, and `φ = [λ]` on every point when every point is killed by `r`. -/

namespace Firedancer.Bn254

open Jac WeierstrassCurve WeierstrassCurve.Affine

public theorem beta_nonsingular {x y : ZMod p_bn254}
    (h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y) :
    (curve (ZMod p_bn254)).toAffine.Nonsingular (beta * x) y := by
  apply nonsingular_of_eqn h3
  rw [mul_pow, beta_cube, one_mul]; exact eqn h

@[expose] public section

/-- `φ(x, y) = (βx, y)`. -/
def phi : ECPoint → ECPoint
  | .zero => .zero
  | .some x y h => .some (beta * x) y (beta_nonsingular h)

end

public theorem phi_zero : phi 0 = 0 :=
  rfl

public theorem phi_some {x y : ZMod p_bn254} (h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y) :
    phi (.some x y h) = .some (beta * x) y (beta_nonsingular h) :=
  rfl

theorem slope_beta (x₁ x₂ y₁ y₂ : ZMod p_bn254) :
    (curve (ZMod p_bn254)).toAffine.slope (beta * x₁) (beta * x₂) y₁ y₂ =
      beta ^ 2 * (curve (ZMod p_bn254)).toAffine.slope x₁ x₂ y₁ y₂ := by
  have hb := beta_ne_zero
  have hc := beta_cube
  unfold WeierstrassCurve.Affine.slope
  simp only [negY_eq, mul_right_inj' hb]
  by_cases h1 : x₁ = x₂
  · simp only [h1, ↓reduceIte]
    split_ifs
    · ring
    · simp only [curve]; ring
  · simp only [h1, ↓reduceIte]
    rw [← mul_sub, show beta ^ 2 = beta⁻¹ from eq_inv_of_mul_eq_one_left (by rw [← pow_succ, hc])]
    field_simp

/-- `φ` is additive. -/
public theorem phi_add (P Q : ECPoint) : phi (P + Q) = phi P + phi Q := by
  have hb := beta_ne_zero
  have hc := beta_cube
  cases P with
  | zero => rw [← Point.zero_def, zero_add, phi_zero, zero_add]
  | some x₁ y₁ h₁ =>
    cases Q with
    | zero => rw [← Point.zero_def, add_zero, phi_zero, add_zero]
    | some x₂ y₂
      h₂ =>
      by_cases hxy : x₁ = x₂ ∧ y₁ = (curve (ZMod p_bn254)).toAffine.negY x₂ y₂
      · rw [Point.add_of_Y_eq hxy.1 hxy.2, phi_zero, phi_some, phi_some,
          Point.add_of_Y_eq (by rw [hxy.1])
            (by
              rw [negY_eq] at hxy ⊢; exact hxy.2)]
      · have hxy' :
          ¬(beta * x₁ = beta * x₂ ∧ y₁ = (curve (ZMod p_bn254)).toAffine.negY (beta * x₂) y₂) := by
          rw [mul_right_inj' hb, negY_eq]; rw [negY_eq] at hxy; exact hxy
        rw [Point.add_some hxy, phi_some, phi_some, phi_some, Point.add_some hxy', Point.some.injEq,
          slope_beta]
        generalize (curve (ZMod p_bn254)).toAffine.slope x₁ x₂ y₁ y₂ = L
        simp only [addY, negAddY, addX, negY_eq]
        simp only [curve]
        constructor
        · linear_combination (-(L ^ 2 * beta)) * hc
        · linear_combination (L * ((beta ^ 3 + 1) * L ^ 2 - 2 * x₁ - x₂)) * hc

/-- `φ` as an additive endomorphism. -/
@[expose]
public def phiHom : ECPoint →+ ECPoint where
  toFun := phi
  map_zero' := phi_zero
  map_add' := phi_add

/-- `φ² + φ + 1 = 0`. -/
public theorem phi_phi_add_phi_add (P : ECPoint) : phi (phi P) + phi P + P = 0 := by
  cases P with
  | zero => rfl
  | some x y
    h =>
    have hx : x ≠ 0 := by
      rintro rfl
      exact
        sq_ne_three y
          (by
            have := eqn h; rw [this]; ring)
    have hb := beta_ne_zero
    have hne : beta * (beta * x) ≠ beta * x := by
      intro hc
      have :=
        mul_right_cancel₀ hx
          (mul_left_cancel₀ hb (by linear_combination hc : beta * (beta * x) = beta * (1 * x)))
      exact beta_ne_one (by simpa using this)
    rw [phi_some, phi_some]
    have hs : (curve (ZMod p_bn254)).toAffine.slope (beta * (beta * x)) (beta * x) y y = 0 := by
      rw [slope_of_X_ne hne, sub_self, zero_div]
    have hsum :
      Point.some (beta * (beta * x)) y (beta_nonsingular (beta_nonsingular h)) +
          Point.some (beta * x) y (beta_nonsingular h) =
        -Point.some x y h := by
      rw [Point.add_of_X_ne hne, Point.neg_some, Point.some.injEq, hs]
      simp only [addY, negAddY, addX, negY_eq]
      simp only [curve]
      constructor
      · linear_combination (-x) * beta_sq_add
      · ring
    rw [hsum, neg_add_cancel]

/-! ## `φ = [λ]` -/

public theorem G_nonsingular : (curve (ZMod p_bn254)).toAffine.Nonsingular 1 2 :=
  nonsingular_of_eqn h3 (by norm_num)

@[expose] public section

/-- The generator `G = (1, 2)`. -/
def G : ECPoint :=
  .some 1 2 G_nonsingular

end

theorem mulAff_lam :
    mulAff (1 : ZMod p_bn254) 2 lam 254 =
      ⟨4005157576274923028979186788246761176148397185556984932485459631346228276528,
        16345617106706985702582500198396161467622388238978719623835895909043452417074,
        18649762464072120706574907088298002600256299377972120385240921761395683880402⟩ := by
  apply Pt.ext <;> decide +kernel

/-- `λ • G = φ(G)`, by evaluating a Jacobian double-and-add ladder (this pins `λ` against the other
cube root of unity). -/
public theorem lam_smul_G : lam • G = phi G := by
  obtain ⟨k, hk⟩ : ∃ k, k = lam := ⟨_, rfl⟩
  have h := rep_mulAff h3 G_nonsingular 254 k
  have hk' : k % 2 ^ 254 = k :=
    Nat.mod_eq_of_lt
      (by
        rw [hk]; norm_num [lam])
  rw [hk'] at h
  have hc : Rep (mulAff (1 : ZMod p_bn254) 2 k 254) (phi G) := by
    rw [hk, mulAff_lam, G, phi_some]
    refine
      ⟨by
        unfold p_bn254; decide, by
        unfold beta p_bn254; decide, by
        unfold p_bn254; decide⟩
  have := Rep.unique h hc
  rw [hk] at this
  exact this

/-- Points as `x` with a sign bit for `y` (injective since `y ≠ 0`, `p` odd). -/
def enc : ECPoint → Option (ZMod p_bn254 × Bool)
  | .zero => none
  | .some x y _ => some (x, decide (y.val ≤ p_bn254 / 2))

theorem enc_injective : Function.Injective enc := by
  intro P Q hPQ
  cases P with
  | zero =>
    cases Q with
    | zero => rfl
    | some => cases hPQ
  | some x y h =>
    cases Q with
    | zero => cases hPQ
    | some x' y'
      h' =>
      simp only [enc, Option.some.injEq, Prod.mk.injEq, decide_eq_decide] at hPQ
      obtain ⟨rfl, hs⟩ := hPQ
      rcases y_eq_or_neg (eqn h) (eqn h') with rfl | hy
      · rfl
      · exfalso
        have hy0 : y' ≠ 0 := by
          rintro rfl; simp at hy; exact y_ne_zero h3 (eqn h) hy
        have hv := ZMod.neg_val y'
        rw [ite_eq_right hy0, ← hy] at hv
        have hlt := ZMod.val_lt y'
        have hpo : p_bn254 % 2 = 1 := by norm_num [p_bn254]
        rw [hv] at hs
        omega

instance : Finite ECPoint :=
  Finite.of_injective enc enc_injective

theorem card_le : Nat.card ECPoint ≤ 2 * p_bn254 + 1 := by
  calc
    Nat.card ECPoint ≤ Nat.card (Option (ZMod p_bn254 × Bool)) :=
      Nat.card_le_card_of_injective enc enc_injective
    _ = 2 * p_bn254 + 1 := by
      rw [Nat.card_eq_fintype_card, Fintype.card_option, Fintype.card_prod, ZMod.card,
        Fintype.card_bool];
      ring

/-- If every point is killed by `r`, `φ` acts as `[λ]` on every point. -/
public theorem phi_eq_lam_smul (hr : ∀ P : ECPoint, r_bn254 • P = 0) (P : ECPoint) :
    phi P = lam • P := by
  let _ : Module (ZMod r_bn254) ECPoint := AddCommGroup.zmodModule hr
  let _ : Fintype ECPoint := Fintype.ofFinite ECPoint
  have hG : G ≠ 0 := Point.some_ne_zero _
  have hcard := Module.card_eq_pow_finrank (K := ZMod r_bn254) (V := ECPoint)
  rw [ZMod.card] at hcard
  have hle : Fintype.card ECPoint ≤ 2 * p_bn254 + 1 := by
    rw [← Nat.card_eq_fintype_card]; exact card_le
  have h1 : Module.finrank (ZMod r_bn254) ECPoint = 1 := by
    have hlt : Module.finrank (ZMod r_bn254) ECPoint < 2 := by
      by_contra hc
      have : r_bn254 ^ 2 ≤ r_bn254 ^ Module.finrank (ZMod r_bn254) ECPoint :=
        Nat.pow_le_pow_right (Fact.out : r_bn254.Prime).pos (by omega)
      have hr2 : 2 * p_bn254 + 1 < r_bn254 ^ 2 := by norm_num [p_bn254, r_bn254]
      omega
    have hne : Module.finrank (ZMod r_bn254) ECPoint ≠ 0 := by
      intro h0
      rw [h0, pow_zero] at hcard
      have : (0 : ECPoint) = G := Fintype.card_le_one_iff.mp hcard.le 0 G
      exact hG this.symm
    omega
  obtain ⟨c, rfl⟩ := (finrank_eq_one_iff_of_nonzero' G hG).mp h1 P
  have := ZMod.map_smul phiHom c G
  simp only [phiHom, AddMonoidHom.coe_mk, ZeroHom.coe_mk] at this
  rw [this, ← lam_smul_G, smul_comm]

end Firedancer.Bn254

module

public import Firedancer.Math.Verify
public import Firedancer.Math.R52x5.Canon
public import Firedancer.Math.R52x5.QuadMul
public import Firedancer.R52x5.fd_f25519_is_nonzero
public import Firedancer.R52x5.fd_f25519_eq
public import Firedancer.R52x5.fd_f25519_sgn
public import Firedancer.R52x5.fd_ed25519_point_affine_eq
public import Firedancer.R52x5.fd_ed25519_affine_is_small_order
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! The r52x5 comparisons in `ZMod p`: `is_zero`, `is_nonzero`, `eq` and `sgn` of a field
element's value, equality of projective points, and the small order test of an affine point. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open MLIR.Firedancer.Ref.Ed25519 (OnCurve SmallOrder)
open Firedancer.Avx512 (Wwl)

/-! ## Field elements -/

section Field

/-- Two `0`/`1` flags' `|`. -/
theorem ite_or_ite' {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then (1 : BitVec 32) else 0) ||| if b then 1 else 0) = if a ∨ b then 1 else 0 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- Two `0`/`1` flags' `&`. -/
theorem ite_and_ite' {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then (1 : BitVec 32) else 0) &&& if b then 1 else 0) = if a ∧ b then 1 else 0 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- An `|` is zero when both sides are. -/
theorem or_eq_zero (a b : BitVec 64) : a ||| b = 0 ↔ a = 0 ∧ b = 0 := by
  bv_decide

/-- The C's `(h[0]|h[1]|h[2]|h[3]|h[4]) == 0` on canonical limbs: `1` exactly at zero. -/
public theorem Canon.isZero {l : Fin 5 → BitVec 64} (h : Canon l) :
    (if (l 0 ||| l 1 ||| l 2 ||| l 3 ||| l 4) = 0 then (1 : BitVec 32) else 0) =
      if Ref.Limbs.val l = 0 then 1 else 0 := by
  refine if_congr ?_ rfl rfl
  have hn := h.2
  rw [Ref.Limbs.val_nat, ZMod.natCast_eq_zero_iff]
  simp only [or_eq_zero, and_assoc]
  constructor
  · rintro ⟨h0, h1, h2, h3, h4⟩
    simp [Ref.Limbs.nat, h0, h1, h2, h3, h4]
  · intro hd
    have h0 := Nat.eq_zero_of_dvd_of_lt hd hn
    unfold Ref.Limbs.nat at h0
    refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> apply BitVec.eq_of_toNat_eq <;> change _ = 0 <;> omega

/-- `is_zero`: `1` exactly at zero. -/
public theorem fd_f25519_is_zero.spec_val (a : Wwl) :
    fd_f25519_is_zero.spec a = if val a = 0 then 1 else 0 := by
  obtain ⟨hc, hv⟩ := fd_f25519_canonical_limbs.spec_val a
  simp only [fd_f25519_is_zero.spec]
  rw [hc.isZero, hv]

/-- `is_nonzero`: `0` exactly at zero. -/
public theorem fd_f25519_is_nonzero.spec_val (a : Wwl) :
    fd_f25519_is_nonzero.spec a = if val a = 0 then 0 else 1 := by
  rw [fd_f25519_is_nonzero.spec, fd_f25519_is_zero.spec_val]
  split <;> rfl

/-- `eq`, `b` under `sub`'s `16 p` bias: `1` exactly when the values are equal. -/
public theorem fd_f25519_eq.spec_val {a b : Wwl} (ha : ∀ i, (limbs a i).toNat < 2 ^ 63)
    (hb : ∀ i, (limbs b i).toNat < 2 ^ 54) :
    fd_f25519_eq.spec a b = if val a = val b then 1 else 0 := by
  rw [fd_f25519_eq.spec, fd_f25519_is_zero.spec_val, (fd_f25519_sub.spec_val ha hb).1]
  simp only [sub_eq_zero]

/-- `sgn`: the parity of the canonical value. -/
public theorem fd_f25519_sgn.spec_val (a : Wwl) :
    fd_f25519_sgn.spec a = BitVec.ofNat 32 ((val a).val % 2) := by
  obtain ⟨hc, hv⟩ := fd_f25519_canonical_limbs.spec_val a
  rw [fd_f25519_sgn.spec]
  generalize fd_f25519_canonical_limbs.spec a = h at hc hv ⊢
  have hn : (val a).val = Ref.Limbs.nat h := by
    rw [← hv, Ref.Limbs.val_nat, ZMod.val_natCast, Nat.mod_eq_of_lt hc.2]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ofNat, hn,
    Ref.Limbs.nat]
  rw [Nat.and_one_is_mod]
  omega

end Field

/-! ## Points -/

section Points

variable {x y x₁ y₁ x₂ y₂ : ZMod p}

/-- Affine coordinates are extended ones, `Z = 1`. -/
public theorem Quad5.Affine.ext {Q : Quad5} (h : Q.Affine x y) : Q.Ext x y := by
  obtain ⟨h0, h1, h2, h3⟩ := h
  rw [Quad5.ext_iff_isExt, h0, h1, h2, h3]
  exact ⟨one_ne_zero, (mul_one x).symm, (mul_one y).symm, by ring⟩

/-- Limbs at most `FD_R52X5_QUAD_REDUCE`'s `2^51 + 2^18`: a number below `2p`. -/
theorem nat_lt_of_reduced {l : Fin 5 → BitVec 64} (h : ∀ i, (l i).toNat ≤ 2 ^ 51 + 2 ^ 18) :
    Ref.Limbs.nat l < 2 * p := by
  have := h 0; have := h 1; have := h 2; have := h 3; have := h 4
  unfold Ref.Limbs.nat
  change _ < 2 * (2 ^ 255 - 19)
  omega

/-- `ge_is_eq`'s zero test on reduced limbs, canonicalized: `1` exactly at zero. -/
theorem isZero_reduce {l : Fin 5 → BitVec 64} (h : ∀ i, (l i).toNat ≤ 2 ^ 51 + 2 ^ 18) :
    fd_r52x5_ge_is_eq.isZero (fd_r52x5_reduce.spec l) = if Ref.Limbs.val l = 0 then 1 else 0 := by
  obtain ⟨hc, hv⟩ :=
    fd_r52x5_reduce.spec_canon (fun i => (h i).trans_lt (by norm_num)) (nat_lt_of_reduced h)
  rw [fd_r52x5_ge_is_eq.isZero, hc.isZero, hv]

/-- `ge_is_eq`'s test of coordinate `j` of a reduced difference: `1` exactly at zero. -/
theorem isZero_of_is {D : Quad5} (h : D.Is v fun _ => 2 ^ 51 + 2 ^ 18) (j : Fin 4) :
    fd_r52x5_ge_is_eq.isZero (fd_r52x5_reduce.spec (D.elem j)) = if v j = 0 then 1 else 0 := by
  rw [isZero_reduce (h.le j)]
  exact if_congr (by rw [show Ref.Limbs.val (D.elem j) = v j from h.val j]) rfl rfl

/-- `ge_is_eq` compares projective `(x₁, y₁)` and `(x₂, y₂)` by `X₁ Z₂ = Z₁ X₂` and
`Y₁ Z₂ = Z₁ Y₂`: `1` exactly when they are equal. -/
public theorem fd_r52x5_ge_is_eq.spec_val {A B : Quad5} (hA : A.Proj x₁ y₁) (hB : B.Proj x₂ y₂)
    (rA : A.Below 52) (rB : B.Below 52) :
    fd_r52x5_ge_is_eq.spec A B = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 := by
  obtain ⟨hz₁, hx₁, hy₁⟩ := Quad5.proj_iff.1 hA
  obtain ⟨hz₂, hx₂, hy₂⟩ := Quad5.proj_iff.1 hB
  have m := (fd_r52x5_quad_mul_fast.spec_is (Quad5.permute_is 2 0 2 1 rA.is)
    (Quad5.permute_is 0 2 1 2 rB.is) (fun _ => by norm_num) (fun _ => by norm_num)).reduce
  have d := (Quad5.addFast_is (Quad5.permute_is 1 0 3 2 m)
    (Quad5.negateLazy_is m fun _ => by norm_num) fun _ => by norm_num).reduce
  simp only [fd_r52x5_ge_is_eq.spec]
  rw [isZero_of_is d 0, isZero_of_is d 2, ite_and_ite']
  refine if_congr ?_ rfl rfl
  simp only [Quad5.sel, Nat.succ_eq_add_one, Nat.reduceAdd, Fin.isValue, Matrix.cons_val_zero,
    Nat.one_mod, Fin.mk_one, Matrix.cons_val_one, Nat.zero_mod, Fin.zero_eta, Nat.reduceMod,
    Fin.reduceFinMk, Matrix.cons_val, Nat.mod_succ]
  rw [hx₁, hx₂, hy₁, hy₂]
  have hz : A.val 2 * B.val 2 ≠ 0 := mul_ne_zero hz₁ hz₂
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨mul_right_cancel₀ hz (by linear_combination h1),
      mul_right_cancel₀ hz (by linear_combination h2)⟩
  · rintro ⟨rfl, rfl⟩
    exact ⟨by ring, by ring⟩

/-- `point_eq` compares projective `(x₁, y₁)` and `(x₂, y₂)`: `1` exactly when they are equal. -/
public theorem fd_ed25519_point_eq.spec_val {A B : Quad5} (hA : A.Proj x₁ y₁) (hB : B.Proj x₂ y₂)
    (rA : A.Below 52) (rB : B.Below 52) :
    fd_ed25519_point_eq.spec A B = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 :=
  fd_r52x5_ge_is_eq.spec_val hA hB rA rB

/-- `point_affine_eq` is `point_eq`; `B`'s `Z = 1` is not used. -/
public theorem fd_ed25519_point_affine_eq.spec_val {A B : Quad5} (hA : A.Proj x₁ y₁)
    (hB : B.Proj x₂ y₂) (rA : A.Below 52) (rB : B.Below 52) :
    fd_ed25519_point_affine_eq.spec A B = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 :=
  fd_r52x5_ge_is_eq.spec_val hA hB rA rB

/-- `point_eq` on points of the group: `1` exactly when they are equal. -/
public theorem fd_ed25519_point_eq.spec_point {A B : Quad5} {P Q : Ref.Ed25519.Point}
    (hA : A.Proj P.x P.y) (hB : B.Proj Q.x Q.y) (rA : A.Below 52) (rB : B.Below 52) :
    fd_ed25519_point_eq.spec A B = if P = Q then 1 else 0 :=
  (fd_ed25519_point_eq.spec_val hA hB rA rB).trans
    (if_congr (Ref.Ed25519.Point.ext_iff (x := P) (y := Q)).symm rfl rfl)

/-- `point_affine_eq` on points of the group: `1` exactly when they are equal. -/
public theorem fd_ed25519_point_affine_eq.spec_point {A B : Quad5} {P Q : Ref.Ed25519.Point}
    (hA : A.Proj P.x P.y) (hB : B.Proj Q.x Q.y) (rA : A.Below 52) (rB : B.Below 52) :
    fd_ed25519_point_affine_eq.spec A B = if P = Q then 1 else 0 :=
  fd_ed25519_point_eq.spec_point hA hB rA rB

/-- `UNPACK`'s `x` holds coordinate 0's limbs. -/
theorem val_unpack_x (A : Quad5) : val A.unpack.1 = A.val 0 :=
  congrArg Ref.Limbs.val (funext fun i => by fin_cases i <;> rfl)

/-- `UNPACK`'s `y` holds coordinate 1's limbs. -/
theorem limbs_unpack_y (A : Quad5) : limbs A.unpack.2.1 = A.elem 1 :=
  funext fun i => by fin_cases i <;> rfl

/-- `is_small_order` on an affine point `(x, y)` on the curve (`X = x`, `Y = y`), reduced: `1`
exactly when `8 (x, y)` is the neutral point. -/
public theorem fd_ed25519_affine_is_small_order.spec_val {A : Quad5} (hx : A.val 0 = x)
    (hy : A.val 1 = y) (hc : OnCurve x y) (hr : A.Below 52) :
    fd_ed25519_affine_is_small_order.spec A = if SmallOrder x y then 1 else 0 := by
  obtain ⟨⟨v0, b0⟩, ⟨v1, b1⟩⟩ := Ref.fd_ed25519_order8_point_y.val
  have hY (i : Fin 5) : (limbs A.unpack.2.1 i).toNat < 2 ^ 63 := by
    rw [limbs_unpack_y]; exact (hr 1 i).trans (by norm_num)
  have h0 (i : Fin 5) : (limbs fd_ed25519_order8_point_y0.vec i).toNat < 2 ^ 54 := by
    rw [fd_ed25519_order8_point_y0.limbs_eq]; exact (b0 i).trans_lt (by norm_num)
  have h1 (i : Fin 5) : (limbs fd_ed25519_order8_point_y1.vec i).toNat < 2 ^ 54 := by
    rw [fd_ed25519_order8_point_y1.limbs_eq]; exact (b1 i).trans_lt (by norm_num)
  have vy : val A.unpack.2.1 = y := (congrArg Ref.Limbs.val (limbs_unpack_y A)).trans hy
  have vx : val A.unpack.1 = x := (val_unpack_x A).trans hx
  have w0 : val fd_ed25519_order8_point_y0.vec = Ref.Ed25519.y8 :=
    (congrArg Ref.Limbs.val fd_ed25519_order8_point_y0.limbs_eq).trans v0
  have w1 : val fd_ed25519_order8_point_y1.vec = -Ref.Ed25519.y8 :=
    (congrArg Ref.Limbs.val fd_ed25519_order8_point_y1.limbs_eq).trans v1
  rw [fd_ed25519_affine_is_small_order.spec, fd_f25519_is_zero.spec_val,
    fd_f25519_is_zero.spec_val, fd_f25519_eq.spec_val hY h0, fd_f25519_eq.spec_val hY h1, vx, vy,
    w0, w1]
  simp only [ite_or_ite']
  exact if_congr (by rw [Ref.Ed25519.smallOrder_iff hc]; tauto) rfl rfl

/-- `is_small_order` on an affine point of the group, reduced: `1` exactly when `8 P = 0`. -/
public theorem fd_ed25519_affine_is_small_order.spec_point {A : Quad5} {P : Ref.Ed25519.Point}
    (hA : A.Affine P.x P.y) (hr : A.Below 52) :
    fd_ed25519_affine_is_small_order.spec A = if 8 • P = 0 then 1 else 0 :=
  (fd_ed25519_affine_is_small_order.spec_val hA.1 hA.2.1 P.on hr).trans
    (if_congr (Ref.Ed25519.Point.smallOrder_iff_nsmul P) rfl rfl)

end Points

end MLIR.Firedancer.R52x5

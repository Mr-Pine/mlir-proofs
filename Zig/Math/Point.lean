module

public import Ed25519.Curve
public import Ed25519.Group
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar
public import Zig.Edwards25519_add
public import Zig.Edwards25519_neg
public import Zig.Edwards25519_sub
public import Zig.Math.Field

/-! Zig's point operations on the curve: `add`, `neg` and `sub` compute the curve's sum, negation
and difference in extended coordinates, under the limb bounds the program proofs assume. -/

namespace MLIR.Zig

open _root_.Ed25519

/-! ## Definitions -/

/-- `P` is `(x, y)` in extended coordinates. -/
@[expose]
public def ZPt.Ext (P : ZPt) (x y : ZMod p) : Prop :=
  IsExt x y (Limbs.val P.x) (Limbs.val P.y) (Limbs.val P.t) (Limbs.val P.z)

/-! ## Constants and doubling -/

/-- `d2` is `2d`. -/
public theorem Fe.d2_val : Limbs.val Fe.d2 = 2 * d := by
  rw [Limbs.val_eq]
  unfold Ed25519.d
  simp [Fe.d2]
  reduce_mod_char

/-- `d2`'s limbs are below `2^51`. -/
public theorem Fe.d2_lt : Fe.Lt Fe.d2 (2 ^ 51) := by
  intro i
  fin_cases i <;> decide

/-- Limbs below `2^52`, each shifted left by one: the value doubled, below `2^53`. -/
theorem Fe.shl1_val {l : Fin 5 → BitVec 64} (h : Fe.Lt l (2 ^ 52)) :
    Limbs.val (fun i => l i <<< 1) = 2 * Limbs.val l ∧ Fe.Lt (fun i => l i <<< 1) (2 ^ 53) := by
  have e (i : Fin 5) : (l i <<< 1).toNat = 2 * (l i).toNat := shl1_toNat ((h i).trans (by norm_num))
  refine ⟨?_, fun i => ?_⟩
  · simp only [Limbs.val_eq, e]
    push_cast
    ring
  · have := h i
    simp only [e]
    omega

/-! ## Addition -/

section Add

variable {P Q : ZPt} {x₁ y₁ x₂ y₂ : ZMod p}

/-- `add` computes the curve's sum, for limbs below `2^53`; the sum's limbs are below `2^52`. -/
public theorem Edwards25519.add.spec_ext (hP : P.Ext x₁ y₁) (hQ : Q.Ext x₂ y₂) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) (hPb : P.Lt (2 ^ 53)) (hQb : Q.Lt (2 ^ 53)) :
    (Edwards25519.add.spec P Q).Ext (add x₁ y₁ x₂ y₂).1 (add x₁ y₁ x₂ y₂).2 ∧
      (Edwards25519.add.spec P Q).Lt (2 ^ 52) := by
  obtain ⟨px, py, pz, pt⟩ := hPb
  obtain ⟨qx, qy, qz, qt⟩ := hQb
  obtain ⟨d₁, d₂, eX, eT⟩ := add_compl hP hQ h1 h2
  have l63 {l : Fin 5 → BitVec 64} {B : ℕ} (h : Fe.Lt l B) (hB : B ≤ 2 ^ 63) : Fe.Lt l (2 ^ 63) :=
    h.mono hB
  have l54 {l : Fin 5 → BitVec 64} {B : ℕ} (h : Fe.Lt l B) (hB : B ≤ 2 ^ 54) : Fe.Lt l (2 ^ 54) :=
    h.mono hB
  -- `a = (Y₁ - X₁)(Y₂ - X₂)`, `b = (X₁ + Y₁)(X₂ + Y₂)`, `c = 2d T₁ T₂`, `d = 2 Z₁ Z₂`
  have sP := Fe.sub.spec_lt (b := P.x) py (by norm_num)
  have sQ := Fe.sub.spec_lt (b := Q.x) qy (by norm_num)
  have aP := Fe.add.spec_lt px py (by norm_num)
  have aQ := Fe.add.spec_lt qx qy (by norm_num)
  have va := Fe.mul.spec_val (l54 sP (by norm_num)) (l54 sQ (by norm_num))
  rw [Fe.sub.spec_val (l63 py (by norm_num)) (l63 px (by norm_num)),
    Fe.sub.spec_val (l63 qy (by norm_num)) (l63 qx (by norm_num))] at va
  have vb := Fe.mul.spec_val (l54 aP (by norm_num)) (l54 aQ (by norm_num))
  rw [Fe.add.spec_val px py (by norm_num), Fe.add.spec_val qx qy (by norm_num)] at vb
  have vtt := Fe.mul.spec_val (l54 pt (by norm_num)) (l54 qt (by norm_num))
  have vc :=
    Fe.mul.spec_val (l54 (Fe.mul.spec_lt P.t Q.t) (by norm_num)) (l54 Fe.d2_lt (by norm_num))
  rw [vtt, Fe.d2_val] at vc
  have vzz := Fe.mul.spec_val (l54 pz (by norm_num)) (l54 qz (by norm_num))
  obtain ⟨vd, bd⟩ := Fe.shl1_val (Fe.mul.spec_lt P.z Q.z)
  rw [vzz] at vd
  have bA := Fe.mul.spec_lt (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x)
  have bB := Fe.mul.spec_lt (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y)
  have bC := Fe.mul.spec_lt (Fe.mul.spec P.t Q.t) Fe.d2
  simp only [Edwards25519.add.spec]
  generalize Fe.mul.spec (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x) = A at *
  generalize Fe.mul.spec (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y) = B at *
  generalize Fe.mul.spec (Fe.mul.spec P.t Q.t) Fe.d2 = C at *
  generalize (fun i => Fe.mul.spec P.z Q.z i <<< 1) = D at *
  -- `E = b - a`, `H = b + a`, `G = d + c`, `F = d - c`
  have vE := Fe.sub.spec_val (l63 bB (by norm_num)) (l63 bA (by norm_num))
  have vH := Fe.add.spec_val bB bA (by norm_num)
  have vG := Fe.add.spec_val bd bC (by norm_num)
  have vF := Fe.sub.spec_val (l63 bd (by norm_num)) (l63 bC (by norm_num))
  have bE := Fe.sub.spec_lt (b := A) bB (by norm_num)
  have bH := Fe.add.spec_lt bB bA (by norm_num)
  have bG := Fe.add.spec_lt bd bC (by norm_num)
  have bF := Fe.sub.spec_lt (b := C) bd (by norm_num)
  refine ⟨?_, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _⟩
  unfold ZPt.Ext IsExt
  dsimp only
  rw [Fe.mul.spec_val (l54 bE (by norm_num)) (l54 bF (by norm_num)),
    Fe.mul.spec_val (l54 bH (by norm_num)) (l54 bG (by norm_num)),
    Fe.mul.spec_val (l54 bG (by norm_num)) (l54 bF (by norm_num)),
    Fe.mul.spec_val (l54 bE (by norm_num)) (l54 bH (by norm_num)), vE, vH, vG, vF, va, vb, vc, vd]
  refine ⟨mul_ne_zero ?_ ?_, ?_, ?_, by ring⟩
  · convert d₁ using 1; ring
  · convert d₂ using 1; ring
  · linear_combination
      (2 * (Limbs.val P.z * Limbs.val Q.z) - Limbs.val P.t * Limbs.val Q.t * (2 * d)) * eX
  · linear_combination
      (2 * (Limbs.val P.z * Limbs.val Q.z) + Limbs.val P.t * Limbs.val Q.t * (2 * d)) * eT

/-- `add` on points of the curve's group. -/
public theorem Edwards25519.add.spec_point {A B : Point} (hP : P.Ext A.x A.y) (hQ : Q.Ext B.x B.y)
    (hPb : P.Lt (2 ^ 53)) (hQb : Q.Lt (2 ^ 53)) :
    (Edwards25519.add.spec P Q).Ext (A + B).x (A + B).y ∧ (Edwards25519.add.spec P Q).Lt (2 ^ 52) :=
  Edwards25519.add.spec_ext hP hQ A.on B.on hPb hQb

end Add

/-! ## Negation and subtraction -/

section Neg

variable {P Q : ZPt} {x y x₁ y₁ x₂ y₂ : ZMod p}

/-- `neg` negates, for `x`, `t` below `2^63`. -/
public theorem Edwards25519.neg.spec_ext (hP : P.Ext x y) (hx : Fe.Lt P.x (2 ^ 63))
    (ht : Fe.Lt P.t (2 ^ 63)) : (Edwards25519.neg.spec P).Ext (-x) y := by
  unfold ZPt.Ext at hP ⊢
  simp only [Edwards25519.neg.spec]
  rw [Fe.neg.spec_val hx, Fe.neg.spec_val ht]
  exact hP.neg

/-- `neg` keeps limbs below `B`, for `2^52 ≤ B ≤ 2^63`. -/
public theorem Edwards25519.neg.spec_lt_of_le {B : ℕ} (hP : P.Lt B) (h1 : 2 ^ 52 ≤ B)
    (h2 : B ≤ 2 ^ 63) : (Edwards25519.neg.spec P).Lt B := by
  obtain ⟨hx, hy, hz, ht⟩ := hP
  exact ⟨(Fe.neg.spec_lt (hx.mono h2)).mono h1, hy, hz, (Fe.neg.spec_lt (ht.mono h2)).mono h1⟩

/-- `neg` on points of the curve's group. -/
public theorem Edwards25519.neg.spec_point {A : Point} (hP : P.Ext A.x A.y)
    (hx : Fe.Lt P.x (2 ^ 63)) (ht : Fe.Lt P.t (2 ^ 63)) :
    (Edwards25519.neg.spec P).Ext (-A).x (-A).y :=
  Edwards25519.neg.spec_ext hP hx ht

/-- `sub` computes the curve's difference, for limbs below `2^53`; its limbs are below `2^52`. -/
public theorem Edwards25519.sub.spec_ext (hP : P.Ext x₁ y₁) (hQ : Q.Ext x₂ y₂) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) (hPb : P.Lt (2 ^ 53)) (hQb : Q.Lt (2 ^ 53)) :
    (Edwards25519.sub.spec P Q).Ext (add x₁ y₁ (-x₂) y₂).1 (add x₁ y₁ (-x₂) y₂).2 ∧
      (Edwards25519.sub.spec P Q).Lt (2 ^ 52) := by
  have hN := Edwards25519.neg.spec_lt hQb
  obtain ⟨qx, -, -, qt⟩ := hQb
  exact
    Edwards25519.add.spec_ext hP
      (Edwards25519.neg.spec_ext hQ (qx.mono (by norm_num)) (qt.mono (by norm_num))) h1 h2.neg hPb
      hN

/-- `sub` on points of the curve's group. -/
public theorem Edwards25519.sub.spec_point {A B : Point} (hP : P.Ext A.x A.y) (hQ : Q.Ext B.x B.y)
    (hPb : P.Lt (2 ^ 53)) (hQb : Q.Lt (2 ^ 53)) :
    (Edwards25519.sub.spec P Q).Ext (A - B).x (A - B).y ∧ (Edwards25519.sub.spec P Q).Lt (2 ^ 52) :=
  Edwards25519.sub.spec_ext hP hQ A.on B.on hPb hQb

end Neg

end MLIR.Zig

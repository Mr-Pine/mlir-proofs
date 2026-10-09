module

public import Firedancer.Math.Avx512.Point
public import Firedancer.Math.Avx512.F25519
public import Firedancer.Math.Group
public import Firedancer.Math.Ext
public import Firedancer.Avx512.fd_ed25519_partial_dbl
public import Firedancer.Avx512.fd_ed25519_point_sub_with_opts
public import Firedancer.Avx512.fd_ed25519_point_dbln
public import Firedancer.Avx512.fd_ed25519_point_set_zero
public import Firedancer.Avx512.fd_ed25519_point_from
public import Firedancer.Avx512.fd_curve25519_into_precomputed
public import Firedancer.Avx512.fd_ed25519_point_eq_z1
public import Firedancer.Avx512.fd_ed25519_affine_is_small_order
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! The AVX-512 point operations on the twisted Edwards curve over `ZMod p`: each spec computes
its curve operation on the points its QUADs represent, folded. -/

namespace MLIR.Firedancer.Avx512

open MLIR.Firedancer.Ref (p)
open MLIR.Firedancer.Ref.Ed25519 (d OnCurve IsExt)
open MLIR.Firedancer.Ref.Ed25519 (isExt_add isExt_dbl isExt_neg dblN_succ' dblN_onCurve)

/-! ## The QUAD formulas -/

section Formulas

/-- `(1, 1, 1, 2d)`, reduced. -/
public theorem quad1112d_is :
    quad1112d.Is ![1, 1, 1, 2 * d] (fun _ => 0) (fun _ => 2 ^ 44 - 1) := by
  intro j
  fin_cases j <;> refine ⟨?_, ?_⟩ <;> (try unfold d) <;> decide

/-- `FD_R43X6_GE_ADD`'s and `GE_ADD_TABLE_ALT`'s common end, from `(A, B, D, C)`: `E = B - A`,
`F = D - C`, `G = D + C`, `H = B + A`, then `(E F, G H, F G, E H)`. -/
def addTail (ta : Quad) : Quad :=
  let _tb := ta.permute 1 0 3 2
  let _tb := _tb.laneSubFast 1 0 0 1 _tb ta
  let _tb := _tb.laneAddFast 0 1 1 0 _tb ta
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 2 2 0
  let _tb := _tb.permute 3 1 3 1
  (quadMul _ta _tb).foldUnsigned

/-- `addTail` of `(A, B, D, C)` below `7 · 2^59`: `(E F, G H, F G, E H)`, folded. -/
theorem addTail_is {ta : Quad} {A B D C : ZMod p}
    (h : ta.Is ![A, B, D, C] (fun _ => 0) (fun _ => 7 * 2 ^ 59 - 1)) :
    (addTail ta).Is ![(B - A) * (D - C), (C + D) * (A + B), (C + D) * (D - C), (B - A) * (A + B)]
        (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ (addTail ta).Folded := by
  have t1 := Quad.Is.permute h 1 0 3 2 ![B, A, C, D]
  have t2 := Quad.Is.laneSubFast t1 t1 h 1 0 0 1 ![B - A, A, C, D - C]
    ![-(7 * 2 ^ 59 - 1), 0, 0, -(7 * 2 ^ 59 - 1)] ![7 * 2 ^ 59 - 1 + 2 ^ 43, 7 * 2 ^ 59 - 1,
      7 * 2 ^ 59 - 1, 7 * 2 ^ 59 - 1 + 2 ^ 43]
  have t3 := Quad.Is.laneAddFast t2 t2 h 0 1 1 0 ![B - A, A + B, C + D, D - C]
    ![-(7 * 2 ^ 59 - 1), 0, 0, -(7 * 2 ^ 59 - 1)] ![7 * 2 ^ 59 - 1 + 2 ^ 43, 2 * (7 * 2 ^ 59 - 1),
      2 * (7 * 2 ^ 59 - 1), 7 * 2 ^ 59 - 1 + 2 ^ 43]
  obtain ⟨t4, -⟩ := Quad.Is.foldSigned t3
  have t5 := Quad.Is.permute t4 0 2 2 0 ![B - A, C + D, C + D, B - A]
  have t6 := Quad.Is.permute t4 3 1 3 1 ![D - C, A + B, D - C, A + B]
  exact Quad.Is.foldUnsigned (Quad.Is.quadMul t5 t6 _)

/-- `FD_R43X6_GE_ADD` on elements below `2^61`: `(A, B, D, C)` as `GE_ADD`'s comments name them,
then `addTail`. -/
public theorem geAdd_is {P1 P2 : Quad} {X1 Y1 Z1 T1 X2 Y2 Z2 T2 : ZMod p}
    (h1 : P1.Is ![X1, Y1, Z1, T1] (fun _ => 0) (fun _ => 2 ^ 61 - 1))
    (h2 : P2.Is ![X2, Y2, Z2, T2] (fun _ => 0) (fun _ => 2 ^ 61 - 1)) :
    let A := (Y1 - X1) * 1 * (Y2 - X2)
    let B := (X1 + Y1) * 1 * (X2 + Y2)
    let D := (Z1 + Z1) * 1 * Z2
    let C := T1 * (2 * d) * T2
    (geAdd quadMul P1 P2).Is
        ![(B - A) * (D - C), (C + D) * (A + B), (C + D) * (D - C), (B - A) * (A + B)]
        (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ (geAdd quadMul P1 P2).Folded := by
  intro A B D C
  have a1 := Quad.Is.permute h1 1 0 2 3 ![Y1, X1, Z1, T1]
  have b1 := Quad.Is.permute h2 1 0 2 3 ![Y2, X2, Z2, T2]
  have a2 := Quad.Is.laneSubFast a1 a1 h1 1 0 0 0 ![Y1 - X1, X1, Z1, T1]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 61 - 1]
  have b2 := Quad.Is.laneSubFast b1 b1 h2 1 0 0 0 ![Y2 - X2, X2, Z2, T2]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 61 - 1]
  have a3 := Quad.Is.laneAddFast a2 a2 h1 0 1 1 0 ![Y1 - X1, X1 + Y1, Z1 + Z1, T1]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 62 - 2, 2 ^ 62 - 2, 2 ^ 61 - 1]
  have b3 := Quad.Is.laneAddFast b2 b2 h2 0 1 0 0 ![Y2 - X2, X2 + Y2, Z2, T2]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 62 - 2, 2 ^ 61 - 1, 2 ^ 61 - 1]
  obtain ⟨a4, -⟩ := Quad.Is.foldSigned a3
  obtain ⟨b4, -⟩ := Quad.Is.foldSigned b3
  have a5 := Quad.Is.quadMul a4 quad1112d_is
    ![(Y1 - X1) * 1, (X1 + Y1) * 1, (Z1 + Z1) * 1, T1 * (2 * d)]
  obtain ⟨a6, -⟩ := Quad.Is.foldUnsigned a5
  exact addTail_is (Quad.Is.quadMul a6 b4 ![A, B, D, C])

/-- `FD_R43X6_GE_ADD_TABLE_ALT` of `P1` below `2^61` and `T2` below `2^47`: `(A, B, D, C)`, then
`addTail`. -/
public theorem geAddTable_is {P1 T2 : Quad} {X1 Y1 Z1 T1 U V W K : ZMod p}
    (h1 : P1.Is ![X1, Y1, Z1, T1] (fun _ => 0) (fun _ => 2 ^ 61 - 1))
    (h2 : T2.Is ![U, V, W, K] (fun _ => 0) (fun _ => 2 ^ 47 - 1)) :
    let A := U * (Y1 - X1)
    let B := V * (X1 + Y1)
    let D := W * (Z1 + Z1)
    let C := K * T1
    (geAddTable quadMul P1 T2).Is
        ![(B - A) * (D - C), (C + D) * (A + B), (C + D) * (D - C), (B - A) * (A + B)]
        (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ (geAddTable quadMul P1 T2).Folded := by
  intro A B D C
  have a1 := Quad.Is.permute h1 1 0 2 3 ![Y1, X1, Z1, T1]
  have a2 := Quad.Is.laneSubFast a1 a1 h1 1 0 0 0 ![Y1 - X1, X1, Z1, T1]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 61 - 1]
  have a3 := Quad.Is.laneAddFast a2 a2 h1 0 1 1 0 ![Y1 - X1, X1 + Y1, Z1 + Z1, T1]
    ![-(2 ^ 61 - 1), 0, 0, 0] ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 62 - 2, 2 ^ 62 - 2, 2 ^ 61 - 1]
  obtain ⟨a4, -⟩ := Quad.Is.foldSigned a3
  obtain ⟨a5, -⟩ := Quad.Is.foldUnsigned (Quad.Is.quadMul' h2 a4 ![A, B, D, C])
  exact addTail_is (Quad.Is.mono a5 (fun _ => 0) (fun _ => 7 * 2 ^ 59 - 1))

/-- `FD_R43X6_GE_DBL` on elements below `2^44`: `A = X^2`, `B = Y^2`, `C = 2 Z^2`, `H = A + B`,
`E = H - (X + Y)^2`, `G = A - B`, `F = G + C`, then `(E F, G H, F G, E H)`. -/
public theorem geDbl_is {P1 : Quad} {X1 Y1 Z1 T1 : ZMod p}
    (h : P1.Is ![X1, Y1, Z1, T1] (fun _ => 0) (fun _ => 2 ^ 44 - 1)) :
    let A := X1 ^ 2
    let B := Y1 ^ 2
    let E := A + B - (Y1 + X1) ^ 2
    let G := A - B
    let F := G + (Z1 ^ 2 + Z1 ^ 2)
    let H := A + B
    (geDbl quadMul quadSqr P1).Is ![E * F, G * H, G * F, E * H]
        (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ (geDbl quadMul quadSqr P1).Folded := by
  intro A B E G F H
  have t1 := Quad.Is.permute h 1 1 2 0 ![Y1, Y1, Z1, X1]
  have t2 := Quad.Is.laneAddFast t1 t1 h 1 0 0 0 ![Y1 + X1, Y1, Z1, X1] (fun _ => 0)
    ![2 ^ 45 - 2, 2 ^ 44 - 1, 2 ^ 44 - 1, 2 ^ 44 - 1]
  have t3 := Quad.Is.quadSqr t2 ![(Y1 + X1) ^ 2, B, Z1 ^ 2, A]
  have t4 := Quad.Is.laneAddFast t3 t3 t3 0 0 1 0 ![(Y1 + X1) ^ 2, B, Z1 ^ 2 + Z1 ^ 2, A]
    (fun _ => 0) ![2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 62 - 2, 2 ^ 61 - 1]
  have t5 := Quad.Is.permute t4 3 3 3 3 ![A, A, A, A]
  have t6 := Quad.Is.permute t4 1 1 1 1 ![B, B, B, B]
  have t7 := Quad.Is.laneAddFast t5 t5 t6 1 0 0 1 ![H, A, A, H] (fun _ => 0)
    ![2 ^ 62 - 2, 2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 62 - 2]
  have t8 := Quad.Is.laneSubFast t7 t7 t6 0 1 1 0 ![H, G, G, H]
    ![0, -(2 ^ 61 - 1), -(2 ^ 61 - 1), 0]
    ![2 ^ 62 - 2, 2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1 + 2 ^ 43, 2 ^ 62 - 2]
  have t9 := Quad.Is.laneAddFast t8 t8 t4 0 0 1 0 ![H, G, F, H]
    ![0, -(2 ^ 61 - 1), -(2 ^ 61 - 1), 0]
    ![2 ^ 62 - 2, 2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1 + 2 ^ 43 + (2 ^ 62 - 2), 2 ^ 62 - 2]
  have t10 := Quad.Is.laneSubFast t9 t9 t4 1 0 0 0 ![E, G, F, H]
    ![-(2 ^ 61 - 1), -(2 ^ 61 - 1), -(2 ^ 61 - 1), 0]
    ![2 ^ 62 - 2 + 2 ^ 43, 2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1 + 2 ^ 43 + (2 ^ 62 - 2), 2 ^ 62 - 2]
  obtain ⟨t11, -⟩ := Quad.Is.foldSigned t10
  have t12 := Quad.Is.permute t11 0 1 1 0 ![E, G, G, E]
  have t13 := Quad.Is.permute t11 2 3 2 3 ![F, H, F, H]
  exact Quad.Is.foldUnsigned (Quad.Is.quadMul t12 t13 _)

end Formulas

/-! ## The point operations -/

section Ops

variable {A B : Quad} {x y x₁ y₁ x₂ y₂ : ZMod p}

/-- `partial_dbl` (`FD_R43X6_GE_DBL`) takes a projective `(x, y)` on the curve, its elements below
`2^44`, to `2 (x, y)` in extended coordinates, folded. -/
public theorem fd_ed25519_partial_dbl.spec_ext (hA : A.Proj x y) (hc : OnCurve x y)
    (hr : A.Unsigned 44) :
    let D := fd_ed25519_partial_dbl.spec A
    D.Ext (Ref.Ed25519.dbl x y).1 (Ref.Ed25519.dbl x y).2 ∧ D.Folded := by
  obtain ⟨hv, hf⟩ := geDbl_is (Quad.Is.of_unsigned hr (by decide))
  exact ⟨Quad.Is.ext hv (isExt_dbl hA.1 hA.2.1 hA.2.2 hc), hf⟩

/-- `add_with_opts` (`FD_R43X6_GE_ADD`, or `GE_ADD_TABLE_ALT` for a nonzero `pre`) takes `A`
extended and `B` as its operand, on the curve, to `A + B` in extended coordinates, folded. `A`'s
elements below `2^61`, `B`'s below `2^61`, or `2^47` precomputed. -/
public theorem fd_ed25519_point_add_with_opts.spec_ext {pre : BitVec 32} (hA : A.Ext x₁ y₁)
    (hB : B.Operand pre x₂ y₂) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) (hAr : A.Unsigned 61)
    (hBr : B.Unsigned (if pre = 0 then 61 else 47)) :
    let Q := Ref.Ed25519.add x₁ y₁ x₂ y₂
    let R := fd_ed25519_point_add_with_opts.spec A B pre
    R.Ext Q.1 Q.2 ∧ R.Folded := by
  have ha := Quad.Is.of_unsigned hAr (by decide)
  simp only [fd_ed25519_point_add_with_opts.spec, ne_eq, ite_not]
  rw [Quad.Operand] at hB
  by_cases hp : pre = 0 <;> simp only [hp, ite_true, ite_false] at hB hBr ⊢
  · obtain ⟨hv, hf⟩ := geAdd_is ha (Quad.Is.of_unsigned hBr (by decide))
    exact ⟨Quad.Is.ext hv (isExt_add hA hB h1 h2 (by ring) (by ring) (by ring) (by ring)), hf⟩
  · obtain ⟨X, Y, T, Z, hE, e0, e1, e2, e3⟩ := hB
    obtain ⟨hv, hf⟩ := geAddTable_is ha (Quad.Is.of_unsigned hBr (by decide))
    refine ⟨Quad.Is.ext hv (isExt_add hA hE h1 h2 ?_ ?_ ?_ ?_), hf⟩
    · rw [e0]; ring
    · rw [e1]; ring
    · rw [e3]; ring
    · rw [e2]; ring

/-- `neg` takes a folded `(x, y)` to `-(x, y) = (-x, y)`, folded. -/
public theorem fd_ed25519_point_neg.spec_ext (hA : A.Ext x y) (hr : A.Folded) :
    let N := fd_ed25519_point_neg.spec A
    N.Ext (-x) y ∧ N.Folded := by
  have ha := Quad.Is.of_unsigned hr.unsigned (by decide)
  obtain ⟨hv, hf⟩ := Quad.Is.foldUnsigned (Quad.Is.laneSubFast_p ha hr 1 0 0 1
    ![-A.val 0, A.val 1, A.val 2, -A.val 3])
  exact ⟨Quad.Is.ext hv (isExt_neg hA), hf⟩

/-- `neg_precomputed` takes a folded precomputed `(x, y)` to `(-x, y)` precomputed, its elements
below `2^44`. -/
public theorem fd_ed25519_point_neg_precomputed.spec_pre (hA : A.Pre x y) (hr : A.Folded) :
    let N := fd_ed25519_point_neg_precomputed.spec A
    N.Pre (-x) y ∧ N.Unsigned 44 := by
  obtain ⟨X, Y, T, Z, hE, e0, e1, e2, e3⟩ := hA
  have ha := Quad.Is.of_unsigned hr.unsigned (by decide)
  -- the values opaque: the kernel would unfold `A.val` comparing them
  generalize A.val 0 = a0, A.val 1 = a1, A.val 2 = a2, A.val 3 = a3 at ha e0 e1 e2 e3
  have h1 := Quad.Is.laneSubFast_p ha hr 0 0 0 1 ![a0, a1, a2, -a3]
  generalize hb : -a3 = b3 at h1
  have h2 := Quad.Is.permute h1 1 0 2 3 ![a1, a0, a2, b3]
  refine ⟨⟨-X, Y, -T, Z, isExt_neg hE, ?_, ?_, ?_, ?_⟩, h2.unsigned fun _ => by norm_num⟩
  · exact (h2.val 0).trans (by simp [e1])
  · exact (h2.val 1).trans (by simp [e0]; ring)
  · exact (h2.val 2).trans (by simp [e2])
  · exact (h2.val 3).trans (by simp [← hb, e3])

/-- `into_precomputed` takes `(x, y)` extended, its elements below `2^61`, to its precomputed form,
folded. -/
public theorem fd_curve25519_into_precomputed.spec_pre (hA : A.Ext x y) (hr : A.Unsigned 61) :
    let Q := fd_curve25519_into_precomputed.spec A
    Q.Pre x y ∧ Q.Folded := by
  have ha := Quad.Is.of_unsigned hr (by decide)
  obtain ⟨X, Y, T, Z, hE⟩ : ∃ X Y T Z, A.val 0 = X ∧ A.val 1 = Y ∧ A.val 2 = Z ∧ A.val 3 = T :=
    ⟨_, _, _, _, rfl, rfl, rfl, rfl⟩
  obtain ⟨e0, e1, e2, e3⟩ := hE
  rw [Quad.Ext, e0, e1, e2, e3] at hA
  rw [e0, e1, e2, e3] at ha
  have a1 := Quad.Is.permute ha 1 0 2 3 ![Y, X, Z, T]
  have a2 := Quad.Is.laneSubFast a1 a1 ha 1 0 0 0 ![Y - X, X, Z, T] ![-(2 ^ 61 - 1), 0, 0, 0]
    ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 61 - 1, 2 ^ 61 - 1, 2 ^ 61 - 1]
  have a3 := Quad.Is.laneAddFast a2 a2 ha 0 1 0 0 ![Y - X, X + Y, Z, T] ![-(2 ^ 61 - 1), 0, 0, 0]
    ![2 ^ 61 - 1 + 2 ^ 43, 2 ^ 62 - 2, 2 ^ 61 - 1, 2 ^ 61 - 1]
  obtain ⟨a4, -⟩ := Quad.Is.foldSigned a3
  obtain ⟨hv, hf⟩ := Quad.Is.foldUnsigned (Quad.Is.quadMul a4 quad1112d_is
    ![(Y - X) * 1, (X + Y) * 1, Z * 1, T * (2 * d)])
  refine ⟨⟨_, _, _, _, hA, ?_, ?_, ?_, ?_⟩, hf⟩
  · exact (hv.val 0).trans (by simp)
  · exact (hv.val 1).trans (by simp [add_comm])
  · exact (hv.val 2).trans (by simp)
  · exact (hv.val 3).trans (by simp; ring)

/-- `sub_with_opts` takes `A` extended and folded `B` as its operand, on the curve, to `A - B`
in extended coordinates, folded; `A`'s elements below `2^61`. -/
public theorem fd_ed25519_point_sub_with_opts.spec_ext {pre : BitVec 32} (hA : A.Ext x₁ y₁)
    (hB : B.Operand pre x₂ y₂) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) (hAr : A.Unsigned 61)
    (hBr : B.Folded) :
    let Q := Ref.Ed25519.add x₁ y₁ (-x₂) y₂
    let R := fd_ed25519_point_sub_with_opts.spec A B pre
    R.Ext Q.1 Q.2 ∧ R.Folded := by
  simp only [fd_ed25519_point_sub_with_opts.spec, ne_eq, ite_not]
  rw [Quad.Operand] at hB
  by_cases hp : pre = 0 <;> simp only [hp, ite_true, ite_false] at hB ⊢
  · obtain ⟨hn, hnr⟩ := fd_ed25519_point_neg.spec_ext hB hBr
    exact fd_ed25519_point_add_with_opts.spec_ext hA (by simpa [Quad.Operand] using hn) h1
      h2.neg hAr (by simpa using hnr.unsigned.mono (by decide))
  · obtain ⟨hn, hnr⟩ := fd_ed25519_point_neg_precomputed.spec_pre hB hBr
    refine fd_ed25519_point_add_with_opts.spec_ext hA ?_ h1 h2.neg hAr ?_
    · rw [Quad.Operand]
      split_ifs
      exact hn
    · split_ifs
      exact hnr.mono (by decide)

/-- `set_zero` is the neutral point `(0, 1)`, folded. -/
public theorem fd_ed25519_point_set_zero.spec_ext :
    fd_ed25519_point_set_zero.spec.Ext 0 1 ∧ fd_ed25519_point_set_zero.spec.Folded := by
  have h : fd_ed25519_point_set_zero.spec.Is ![0, 1, 1, 0] (fun _ => 0) (fun _ => 1) := by
    intro j
    fin_cases j <;> refine ⟨?_, ?_⟩ <;> decide
  refine ⟨Quad.Is.ext h ⟨one_ne_zero, by ring, by ring, by ring⟩, ?_⟩
  decide

/-- `from` packs `x, y, z, t` into a point: its elements' values are theirs. -/
public theorem fd_ed25519_point_from.spec_val (x y z t : Wwl) :
    let Q := fd_ed25519_point_from.spec x y z t
    Q.val 0 = R43x6.val x ∧ Q.val 1 = R43x6.val y ∧ Q.val 2 = R43x6.val z ∧
      Q.val 3 = R43x6.val t := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    simp [Quad.val, Quad.elem_eq_nat, fd_ed25519_point_from.spec, Quad.pack, R43x6.val,
      R43x6.int]

/-- `from` of folded `x, y, z, t` is folded. -/
public theorem fd_ed25519_point_from.spec_folded {x y z t : Wwl} (hx : R43x6.Folded x)
    (hy : R43x6.Folded y) (hz : R43x6.Folded z) (ht : R43x6.Folded t) :
    (fd_ed25519_point_from.spec x y z t).Folded := by
  intro j hj
  match j, hj with
  | 0, h | 1, h | 2, h | 3, h =>
    rw [Quad.elem_eq_nat _ _ h]
    simp only [fd_ed25519_point_from.spec, Quad.pack]
    first
    | exact ⟨hx.1, hx.2.1, hx.2.2.1, hx.2.2.2.1, hx.2.2.2.2.1, hx.2.2.2.2.2.1, rfl, rfl⟩
    | exact ⟨hy.1, hy.2.1, hy.2.2.1, hy.2.2.2.1, hy.2.2.2.2.1, hy.2.2.2.2.2.1, rfl, rfl⟩
    | exact ⟨hz.1, hz.2.1, hz.2.2.1, hz.2.2.2.1, hz.2.2.2.2.1, hz.2.2.2.2.2.1, rfl, rfl⟩
    | exact ⟨ht.1, ht.2.1, ht.2.2.1, ht.2.2.2.1, ht.2.2.2.2.1, ht.2.2.2.2.2.1, rfl, rfl⟩

/-- `dbln` takes a projective `(x, y)` on the curve, its elements below `2^44`, to `2ⁿ (x, y)` in
extended coordinates, folded, for `n ≥ 1`. -/
public theorem fd_ed25519_point_dbln.spec_ext {n : ℕ} (hA : A.Proj x y) (hc : OnCurve x y)
    (hr : A.Unsigned 44) (hn : 1 ≤ n) :
    let Q := Ref.Ed25519.dblN n (x, y)
    (fd_ed25519_point_dbln.spec A n).Ext Q.1 Q.2 ∧ (fd_ed25519_point_dbln.spec A n).Folded := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  simp only [fd_ed25519_point_dbln.spec, Nat.add_sub_cancel]
  induction m with
  | zero => exact fd_ed25519_partial_dbl.spec_ext hA hc hr
  | succ m ih =>
    obtain ⟨he, hf⟩ := ih (by omega)
    rw [Nat.repeat, dblN_succ']
    exact fd_ed25519_partial_dbl.spec_ext he.proj (dblN_onCurve _ hc) hf.unsigned

end Ops

/-! ## Comparisons -/

section Compare

variable {x y x₁ y₁ x₂ y₂ : ZMod p}

/-- Limbs in `[lo, hi] ⊆ [-2^62, 2^62)` are signed. -/
public theorem in_signed {v : Wwl} (h : R43x6.In lo hi v) (h1 : -2 ^ 62 ≤ lo) (h2 : hi < 2 ^ 62) :
    R43x6.Signed 62 v :=
  fun i => ⟨h1.trans (h i).1, lt_of_le_of_lt (h i).2 h2⟩

/-- Two `0`/`1` flags' `|`. -/
theorem ite_or_ite' {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then (1 : BitVec 32) else 0) ||| if b then 1 else 0) = if a ∨ b then 1 else 0 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- Two `0`/`1` flags' `&`. -/
theorem ite_and_ite' {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then (1 : BitVec 32) else 0) &&& if b then 1 else 0) = if a ∧ b then 1 else 0 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- The C's `!fd_r43x6_is_nonzero( x )`: `1` exactly when `x` is zero. -/
theorem not_nonzero {v : Wwl} (hv : R43x6.Signed 62 v) :
    (if fd_r43x6_is_nonzero.spec v = 0 then (1 : BitVec 32) else 0) =
      if R43x6.val v = 0 then 1 else 0 := by
  rw [R43x6.fd_r43x6_is_nonzero_spec hv]
  split_ifs <;> simp_all

/-- `fd_r43x6_ge_is_eq` compares projective `(x₁, y₁)` and `(x₂, y₂)`, their elements below
`2^44`: `1` exactly when they are equal. -/
public theorem fd_r43x6_ge_is_eq.spec_val {X Y : Quad} (hX : X.Proj x₁ y₁) (hY : Y.Proj x₂ y₂)
    (rX : X.Unsigned 44) (rY : Y.Unsigned 44) :
    fd_r43x6_ge_is_eq.spec X Y = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 := by
  have a := Quad.Is.of_unsigned rX (by decide)
  have b := Quad.Is.of_unsigned rY (by decide)
  obtain ⟨hz₁, hx₁, hy₁⟩ := hX
  obtain ⟨hz₂, hx₂, hy₂⟩ := hY
  generalize X.val 0 = X₁, X.val 1 = Y₁, X.val 2 = Z₁, X.val 3 = T₁ at a hz₁ hx₁ hy₁
  generalize Y.val 0 = X₂, Y.val 1 = Y₂, Y.val 2 = Z₂, Y.val 3 = T₂ at b hz₂ hx₂ hy₂
  have m : (Avx512.quadMul (X.permute 2 0 2 1) (Y.permute 0 2 1 2)).Is
      ![Z₁ * X₂, X₁ * Z₂, Z₁ * Y₂, Y₁ * Z₂] (fun _ => 0) (fun _ => 7 * 2 ^ 59 - 1) :=
    Quad.Is.quadMul (Quad.Is.permute a 2 0 2 1 ![Z₁, X₁, Z₁, Y₁])
      (Quad.Is.permute b 0 2 1 2 ![X₂, Z₂, Y₂, Z₂]) _
  simp only [fd_r43x6_ge_is_eq.spec]
  generalize Avx512.quadMul (X.permute 2 0 2 1) (Y.permute 0 2 1 2) = M at m ⊢
  have m0 : R43x6.val M.X = Z₁ * X₂ ∧ R43x6.In 0 (7 * 2 ^ 59 - 1) M.X := by
    rw [Quad.X_eq]; exact m 0
  have m1 : R43x6.val M.Y = X₁ * Z₂ ∧ R43x6.In 0 (7 * 2 ^ 59 - 1) M.Y := by
    rw [Quad.Y_eq]; exact m 1
  have m2 : R43x6.val M.Z = Z₁ * Y₂ ∧ R43x6.In 0 (7 * 2 ^ 59 - 1) M.Z := by
    rw [Quad.Z_eq]; exact m 2
  have m3 : R43x6.val M.T = Y₁ * Z₂ ∧ R43x6.In 0 (7 * 2 ^ 59 - 1) M.T := by
    rw [Quad.T_eq]; exact m 3
  obtain ⟨v1, i1⟩ := m1.2.sub_fast m0.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  obtain ⟨v2, i2⟩ := m3.2.sub_fast m2.2 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  rw [not_nonzero (in_signed i1 (by norm_num) (by norm_num)),
    not_nonzero (in_signed i2 (by norm_num) (by norm_num)), v1, v2, m0.1, m1.1, m2.1, m3.1,
    ite_and_ite']
  refine if_congr ?_ rfl rfl
  rw [hx₁, hx₂, hy₁, hy₂]
  have hz : Z₁ * Z₂ ≠ 0 := mul_ne_zero hz₁ hz₂
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨mul_right_cancel₀ hz (by linear_combination h1),
      mul_right_cancel₀ hz (by linear_combination h2)⟩
  · rintro ⟨rfl, rfl⟩
    exact ⟨by ring, by ring⟩

/-- `point_eq` compares projective `(x₁, y₁)` and `(x₂, y₂)`, their elements below `2^44`: `1`
exactly when they are equal. -/
public theorem fd_ed25519_point_eq.spec_val {X Y : Quad} (hX : X.Proj x₁ y₁) (hY : Y.Proj x₂ y₂)
    (rX : X.Unsigned 44) (rY : Y.Unsigned 44) :
    fd_ed25519_point_eq.spec X Y = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 :=
  fd_r43x6_ge_is_eq.spec_val hX hY rX rY

/-- `point_eq_z1` is `point_eq`; its `Z = 1` is not used. -/
public theorem fd_ed25519_point_eq_z1.spec_val {X Y : Quad} (hX : X.Proj x₁ y₁)
    (hY : Y.Proj x₂ y₂) (rX : X.Unsigned 44) (rY : Y.Unsigned 44) :
    fd_ed25519_point_eq_z1.spec X Y = if x₁ = x₂ ∧ y₁ = y₂ then 1 else 0 :=
  fd_r43x6_ge_is_eq.spec_val hX hY rX rY

/-- The order-8 `y`s' lanes: `y8` and `-y8`. -/
theorem order8_y :
    (R43x6.val fd_ed25519_order8_point_y0.vec = Ref.Ed25519.y8 ∧
        R43x6.Signed 61 fd_ed25519_order8_point_y0.vec) ∧
      (R43x6.val fd_ed25519_order8_point_y1.vec = -Ref.Ed25519.y8 ∧
        R43x6.Signed 61 fd_ed25519_order8_point_y1.vec) := by
  refine ⟨⟨?_, by decide⟩, ⟨?_, by decide⟩⟩ <;> unfold Ref.Ed25519.y8 <;> decide

/-- `is_small_order` on an affine point `(x, y)` on the curve (`X = x`, `Y = y`), folded: `1`
exactly when `8 (x, y)` is the neutral point. -/
public theorem fd_ed25519_affine_is_small_order.spec_val {A : Quad} (hx : A.val 0 = x)
    (hy : A.val 1 = y) (hc : OnCurve x y) (hr : A.Folded) :
    fd_ed25519_affine_is_small_order.spec A =
      if Ref.Ed25519.SmallOrder x y then 1 else 0 := by
  obtain ⟨⟨v0, s0⟩, ⟨v1, s1⟩⟩ := order8_y
  have sy : R43x6.Signed 61 A.Y := by
    rw [Quad.Y_eq]
    exact ((hr 1 (by decide)).unsigned.signed (by decide)).mono (by decide)
  have hx' : R43x6.val A.X = x := by rw [Quad.X_eq]; exact hx
  have hy' : R43x6.val A.Y = y := by rw [Quad.Y_eq]; exact hy
  rw [fd_ed25519_affine_is_small_order.spec,
    R43x6.fd_f25519_is_zero_spec (by rw [Quad.Y_eq]; exact .inl (hr 1 (by decide))),
    R43x6.fd_f25519_is_zero_spec (by rw [Quad.X_eq]; exact .inl (hr 0 (by decide))),
    R43x6.fd_f25519_eq_spec sy s0, R43x6.fd_f25519_eq_spec sy s1, v0, v1, hx', hy']
  simp only [ite_or_ite']
  exact if_congr (by rw [Ref.Ed25519.smallOrder_iff hc]; tauto) rfl rfl

end Compare

end MLIR.Firedancer.Avx512

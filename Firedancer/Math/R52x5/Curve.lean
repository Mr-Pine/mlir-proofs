module

public import Firedancer.Math.R52x5.Point
public import Firedancer.Math.R52x5.QuadMul
public import Firedancer.Math.R52x5.QuadSqr
public import Firedancer.R52x5.fd_ed25519_partial_dbl
public import Firedancer.R52x5.fd_ed25519_point_dbln
public import Firedancer.R52x5.fd_ed25519_point_sub_with_opts
import Ed25519.Ext
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! The R52x5 point operations on the twisted Edwards curve over `ZMod p`: each spec computes its
curve operation on the points its QUADs represent, reduced (`Below 52`). -/

namespace MLIR.Firedancer.R52x5

open _root_.Ed25519 (p d OnCurve IsExt isExt_add isExt_dbl dblN_succ' dblN_onCurve)

/-! ## The QUAD formulas -/

/-- `FD_R52X5_GE_ADD_TABLE` of `P1` and `T2`, limbs below `2^52`: `(A, B, D, C)` the lanewise
products of `(Y1 - X1, X1 + Y1, Z1, T1)` and `T2`, then `(E F, G H, G F, E H)` for `E = B - A`,
`F = D - C`, `G = C + D`, `H = A + B`. -/
public theorem geAddTable_is {P1 T2 : Quad5} {X1 Y1 Z1 T1 U V W K : ZMod p} {b c : Fin 4 → ℕ}
    (h1 : P1.Is ![X1, Y1, Z1, T1] b) (hb : ∀ j, b j < 2 ^ 52) (h2 : T2.Is ![U, V, W, K] c)
    (hc : ∀ j, c j < 2 ^ 52) :
    let A := (Y1 - X1) * U
    let B := (X1 + Y1) * V
    let D := Z1 * W
    let C := T1 * K
    (geAddTable P1 T2).Is
      ![(B - A) * (D - C), (C + D) * (A + B), (C + D) * (D - C), (B - A) * (A + B)]
      (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro A B D C
  have t1 := (Quad5.laneIf_is 1 1 0 0
    (Quad5.diffSum_is h1 fun j => by have := hb j; omega) h1).reduce
  have t1' := t1.congr (v' := ![Y1 - X1, X1 + Y1, Z1, T1]) (fun j => by fin_cases j <;> simp)
    (fun _ => le_rfl)
  have t2 := fd_r52x5_quad_mul_fast.spec_is t1' h2 (fun _ => by norm_num) hc
  have t3 := (Quad5.diffSum_is (Quad5.permute_is 0 1 3 2 t2) fun _ => by norm_num).reduce
  have t3' := t3.congr (v' := ![B - A, A + B, D - C, C + D])
    (fun j => by fin_cases j <;> simp [Quad5.sel, A, B, C, D]) (fun _ => le_rfl)
  have t4 := (fd_r52x5_quad_mul_fast.spec_is (Quad5.permute_is 0 3 3 0 t3')
    (Quad5.permute_is 2 1 2 1 t3') (fun _ => by norm_num) (fun _ => by norm_num)).reduce
  exact t4.congr (fun j => by fin_cases j <;> simp [Quad5.sel]) (fun _ => le_rfl)

/-- `FD_R52X5_GE_ADD_TABLE` takes `P1` extended and `T2` precomputed, on the curve and reduced, to
their sum in extended coordinates, reduced. -/
public theorem geAddTable_ext {P1 T2 : Quad5} {x₁ y₁ x₂ y₂ : ZMod p} (hP : P1.Ext x₁ y₁)
    (hPb : P1.Below 52) (hT : T2.Pre x₂ y₂) (hTb : T2.Below 52) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    (geAddTable P1 T2).Ext Q.1 Q.2 ∧ (geAddTable P1 T2).Below 52 := by
  obtain ⟨X, Y, T, Z, hE, e0, e1, e2, e3⟩ := hT
  have hp := hPb.is.congr (v' := ![P1.val 0, P1.val 1, P1.val 2, P1.val 3])
    (fun j => by fin_cases j <;> rfl) (fun _ => le_rfl)
  have ht := hTb.is.congr (v' := ![Y - X, Y + X, 2 * Z, 2 * d * T])
    (fun j => by fin_cases j <;> simp [e0, e1, e2, e3]) (fun _ => le_rfl)
  have h := geAddTable_is hp (fun _ => by norm_num) ht (fun _ => by norm_num)
  refine ⟨?_, h.below fun _ => by norm_num⟩
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  exact isExt_add (Quad5.ext_iff_isExt.1 hP) hE h1 h2 rfl (by ring) (by ring) (by ring)

theorem quad5Zero_is : quad5Zero.Is ![0, 0, 0, 0] (fun _ => 0) := by
  intro j
  refine ⟨?_, fun i => ?_⟩ <;> fin_cases j <;> (try fin_cases i) <;>
    simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, quad5Zero]

/-- `FD_R52X5_GE_DBL` of `P1`, limbs below `2^63`: `A = X^2`, `B = Y^2`, `H = A + B`,
`E = H - (Y + X)^2`, `G = A - B`, `F = G + 2 Z^2`, then `(E F, G H, G F, E H)`. -/
public theorem geDbl_is {P1 : Quad5} {X1 Y1 Z1 T1 : ZMod p} {b : Fin 4 → ℕ}
    (h : P1.Is ![X1, Y1, Z1, T1] b) (hb : ∀ j, b j < 2 ^ 63) :
    let A := X1 ^ 2
    let B := Y1 ^ 2
    let E := A + B - (Y1 + X1) ^ 2
    let G := A - B
    let F := G + (Z1 ^ 2 + Z1 ^ 2)
    let H := A + B
    (geDbl P1).Is ![E * F, G * H, G * F, E * H] (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro A B E G F H
  have hb' j := hb (Quad5.sel 1 0 3 2 j)
  have t1 := (Quad5.laneIf_is 0 0 0 1
    (Quad5.permute_is 0 1 0 1 (Quad5.addFast_is (Quad5.permute_is 1 0 3 2 h) h
      fun j => by have := hb j; have := hb' j; omega)) h).reduce
  have t1' := t1.congr (v' := ![X1, Y1, Z1, Y1 + X1])
    (fun j => by fin_cases j <;> simp [Quad5.sel, add_comm]) (fun _ => le_rfl)
  have t2 := fd_r52x5_quad_sqr_fast.spec_is t1' fun _ => by norm_num
  have t2' := t2.congr (v' := ![A, B, Z1 ^ 2, (Y1 + X1) ^ 2])
    (fun j => by fin_cases j <;> simp [A, B]) (fun _ => le_rfl)
  have p1 := Quad5.permute_is 0 0 0 0 t2'
  have p2 := Quad5.permute_is 1 1 1 1 t2'
  have n := Quad5.negateLazy_is (Quad5.laneIf_is 0 0 0 1 t2' p2) fun j => by
    fin_cases j <;> simp
  have a1 := Quad5.addFast_is p1 (Quad5.laneIf_is 0 0 1 0 (Quad5.addFast_is t2' t2' fun _ => by
    norm_num) quad5Zero_is) fun j => by fin_cases j <;> simp
  have a2 := Quad5.addFast_is a1 (Quad5.laneIf_is 1 0 0 1 p2 quad5Zero_is) fun j => by
    fin_cases j <;> simp
  have a3 := (Quad5.addFast_is a2 (Quad5.laneIf_is 0 1 1 1 n quad5Zero_is) fun j => by
    fin_cases j <;> simp).reduce
  have a3' := a3.congr (v' := ![H, G, F, E])
    (fun j => by fin_cases j <;> simp [Quad5.sel, H, G, F, E] <;> ring) (fun _ => le_rfl)
  have t4 := (fd_r52x5_quad_mul_fast.spec_is (Quad5.permute_is 2 0 2 0 a3')
    (Quad5.permute_is 3 1 1 3 a3') (fun _ => by norm_num) (fun _ => by norm_num)).reduce
  exact t4.congr (fun j => by fin_cases j <;> simp [Quad5.sel] <;> ring) (fun _ => le_rfl)

/-! ## The point operations -/

variable {A B : Quad5} {x y x₁ y₁ x₂ y₂ : ZMod p}

/-- `partial_dbl` (`FD_R52X5_GE_DBL`) takes a projective `(x, y)` on the curve, reduced, to
`2 (x, y)` in extended coordinates, reduced. -/
public theorem fd_ed25519_partial_dbl.spec_ext (hA : A.Proj x y) (hc : OnCurve x y)
    (hb : A.Below 52) :
    let D := fd_ed25519_partial_dbl.spec A
    D.Ext (Ed25519.dbl x y).1 (Ed25519.dbl x y).2 ∧ D.Below 52 := by
  have ha :=
    hb.is.congr (v' := ![A.val 0, A.val 1, A.val 2, A.val 3]) (fun j => by fin_cases j <;> rfl)
      (fun _ => le_rfl)
  have h : (fd_ed25519_partial_dbl.spec A).Is _ _ := geDbl_is ha fun _ => by norm_num
  refine ⟨?_, h.below fun _ => by norm_num⟩
  obtain ⟨hz, hx, hy⟩ := Quad5.proj_iff.1 hA
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  exact isExt_dbl hz hx hy hc


/-- `add_with_opts` takes `A` extended and `B` as its operand, on the curve and reduced, to
`A + B` in extended coordinates, reduced. -/
public theorem fd_ed25519_point_add_with_opts.spec_ext {pre : BitVec 32} (hA : A.Ext x₁ y₁)
    (hAb : A.Below 52) (hB : B.Operand pre x₂ y₂) (hBb : B.Below 52) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let R := fd_ed25519_point_add_with_opts.spec A B pre
    R.Ext Q.1 Q.2 ∧ R.Below 52 := by
  rw [Quad5.Operand] at hB
  simp only [fd_ed25519_point_add_with_opts.spec]
  split_ifs at hB ⊢
  · obtain ⟨hp, hpb⟩ := fd_curve25519_into_precomputed.spec_pre hB hBb
    exact geAddTable_ext hA hAb hp hpb h1 h2
  · exact geAddTable_ext hA hAb hB hBb h1 h2

/-- `neg_precomputed` negates a precomputed point, reduced. -/
public theorem fd_ed25519_point_neg_precomputed.spec_pre (hA : A.Pre x y) (hb : A.Below 52) :
    let N := fd_ed25519_point_neg_precomputed.spec A
    N.Pre (-x) y ∧ N.Below 52 := by
  obtain ⟨X, Y, T, Z, hE, e0, e1, e2, e3⟩ := hA
  have ha := hb.is
  -- the values opaque: the kernel would unfold `A.val` comparing them
  generalize A.val = v at ha e0 e1 e2 e3
  have h : (fd_ed25519_point_neg_precomputed.spec A).Is _ _ :=
    Quad5.laneIf_is 0 0 0 1 (Quad5.negateLazy_is ha fun _ => by norm_num).reduce
      (Quad5.permute_is 1 0 2 3 ha)
  refine ⟨⟨-X, Y, -T, Z, hE.neg, ?_, ?_, ?_, ?_⟩, h.below fun j => by fin_cases j <;> simp⟩
  · rw [h.val 0]; simp [Quad5.sel, e1]
  · rw [h.val 1]; simp [Quad5.sel, e0]; ring
  · rw [h.val 2]; simp [Quad5.sel, e2]
  · rw [h.val 3]; simp [e3]

/-- `sub_with_opts` takes `A` extended and `B` as its operand, on the curve and reduced, to
`A - B` in extended coordinates, reduced. -/
public theorem fd_ed25519_point_sub_with_opts.spec_ext {pre : BitVec 32} (hA : A.Ext x₁ y₁)
    (hAb : A.Below 52) (hB : B.Operand pre x₂ y₂) (hBb : B.Below 52) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) :
    let Q := Ed25519.add x₁ y₁ (-x₂) y₂
    let R := fd_ed25519_point_sub_with_opts.spec A B pre
    R.Ext Q.1 Q.2 ∧ R.Below 52 := by
  have hn : (if pre = 0 then fd_ed25519_point_neg.spec B
      else fd_ed25519_point_neg_precomputed.spec B).Operand pre (-x₂) y₂ ∧
      (if pre = 0 then fd_ed25519_point_neg.spec B
        else fd_ed25519_point_neg_precomputed.spec B).Below 52 := by
    rw [Quad5.Operand] at hB ⊢
    split_ifs at hB ⊢
    · exact fd_ed25519_point_neg.spec_ext hB hBb
    · exact fd_ed25519_point_neg_precomputed.spec_pre hB hBb
  exact fd_ed25519_point_add_with_opts.spec_ext hA hAb hn.1 hn.2 h1 h2.neg

/-- `dbln` takes a projective `(x, y)` on the curve, reduced, to `2ⁿ (x, y)` in extended
coordinates, reduced, for `n ≥ 1`. -/
public theorem fd_ed25519_point_dbln.spec_ext {n : ℕ} (hA : A.Proj x y) (hc : OnCurve x y)
    (hb : A.Below 52) (hn : 1 ≤ n) :
    let Q := Ed25519.dblN n (x, y)
    (fd_ed25519_point_dbln.spec A n).Ext Q.1 Q.2 ∧ (fd_ed25519_point_dbln.spec A n).Below 52 := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  simp only [fd_ed25519_point_dbln.spec, Nat.add_sub_cancel]
  induction m with
  | zero => exact fd_ed25519_partial_dbl.spec_ext hA hc hb
  | succ m ih =>
    obtain ⟨he, hf⟩ := ih (by omega)
    rw [Nat.repeat, dblN_succ']
    exact fd_ed25519_partial_dbl.spec_ext he.proj (dblN_onCurve _ hc) hf

end MLIR.Firedancer.R52x5

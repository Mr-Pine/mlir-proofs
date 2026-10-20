module

public import Firedancer.Crc.Verify.Math.Quad
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_add
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.fd_r52x5_quad_to_table
public import Firedancer.Crc.Verify.fd_r52x5_odd_table
public import Firedancer.Math.R52x5.Curve
public import Firedancer.Math.R52x5.Equal
import Ed25519.Ext
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! crc's QUAD point kernels in `ZMod p`: `ge_add_table`, `to_table`, `ge_add`, `ge_dbl` and the
odd table, lane by lane and on the group. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p d OnCurve IsExt isExt_add isExt_dbl Point)

variable {v w : Fin 4 → ZMod p} {b c : Fin 4 → ℕ}

/-! ## The shared kernels -/

public theorem negate_lazy_eq (X : Quad5) : fd_r52x5_quad_negate_lazy.spec X = Quad5.negateLazy X := rfl

public theorem add_nc_eq (X Y : Quad5) : fd_r52x5_quad_add_nc.spec X Y = Quad5.addFast Y X := rfl

public theorem quad5_zero_eq : quad5_zero = quad5Zero := rfl

public theorem quad5_zero_is : quad5_zero.Is ![0, 0, 0, 0] (fun _ => 0) := by
  intro j
  refine ⟨?_, fun i => ?_⟩ <;> fin_cases j <;> (try fin_cases i) <;>
    simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, quad5_zero, wl_zero]

/-- `fd_r52x5_quad_add_nc` of `(permute 1 0 3 2 X)` and `laneIf 1 0 1 0 (negate_lazy X) X`:
`FD_R52X5_QUAD_DIFF_SUM`, `[Y - X, X + Y, T - Z, Z + T]`. -/
public theorem diffSum_is {X : Quad5} (h : X.Is v b) (hb : ∀ j, b j ≤ 2 ^ 56 - 608) :
    (fd_r52x5_quad_add_nc.spec (Quad5.permute 1 0 3 2 X)
        (Quad5.laneIf 1 0 1 0 (fd_r52x5_quad_negate_lazy.spec X) X)).Is
      ![v 1 - v 0, v 0 + v 1, v 3 - v 2, v 2 + v 3] (fun _ => 2 ^ 57) := by
  rw [add_nc_eq, negate_lazy_eq]
  have h2 := Quad5.laneIf_is 1 0 1 0 (Quad5.negateLazy_is h hb) h
  have h3 := Quad5.addFast_is h2 (Quad5.permute_is 1 0 3 2 h) fun j => by
    have := hb 0; have := hb 1; have := hb 2; have := hb 3
    fin_cases j <;> simp [Quad5.sel] <;> omega
  refine h3.congr (fun j => ?_) (fun j => ?_)
  · fin_cases j <;> simp [Quad5.sel] <;> ring
  · have := hb 0; have := hb 1; have := hb 2; have := hb 3
    fin_cases j <;> simp [Quad5.sel] <;> omega

/-! ## `fd_r52x5_quad_ge_add_table` -/

/-- `fd_r52x5_quad_ge_add_table` of `P1` and `T2`, limbs below `2^52`: `(A, B, D, C)` the
lanewise products of `(Y1 - X1, X1 + Y1, Z1, T1)` and `T2`, then `(E F, G H, G F, E H)` for
`E = B - A`, `F = D - C`, `G = C + D`, `H = A + B`. -/
public theorem ge_add_table_is {P1 T2 : Quad5} {X1 Y1 Z1 T1 U V W K : ZMod p}
    (h1 : P1.Is ![X1, Y1, Z1, T1] b) (hb : ∀ j, b j < 2 ^ 52) (h2 : T2.Is ![U, V, W, K] c)
    (hc : ∀ j, c j < 2 ^ 52) :
    let A := (Y1 - X1) * U
    let B := (X1 + Y1) * V
    let D := Z1 * W
    let C := T1 * K
    (fd_r52x5_quad_ge_add_table.spec P1 T2).Is
      ![(B - A) * (D - C), (C + D) * (A + B), (C + D) * (D - C), (B - A) * (A + B)]
      (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro A B D C
  have t1 := Quad5.laneIf_is 1 1 0 0
    (fd_r52x5_quad_reduce.spec_is (diffSum_is h1 fun j => by have := hb j; omega)) h1
  have t1' := t1.congr (v' := ![Y1 - X1, X1 + Y1, Z1, T1]) (b' := fun j => 2 ^ 52 - 1)
    (fun j => by fin_cases j <;> simp)
    (fun j => by have := hb j; split <;> omega)
  have t2 := fd_r52x5_quad_mul.spec_is t1' h2 (fun _ => by norm_num) hc
  have t3 := fd_r52x5_quad_reduce.spec_is
    (diffSum_is (Quad5.permute_is 0 1 3 2 t2) fun _ => by norm_num)
  have t3' := t3.congr (v' := ![B - A, A + B, D - C, C + D])
    (fun j => by fin_cases j <;> simp [Quad5.sel, A, B, C, D]) (fun _ => le_rfl)
  have t4 := fd_r52x5_quad_mul.spec_is (Quad5.permute_is 0 3 3 0 t3')
    (Quad5.permute_is 2 1 2 1 t3') (fun _ => by norm_num) (fun _ => by norm_num)
  exact t4.congr (fun j => by fin_cases j <;> simp [Quad5.sel]) (fun _ => le_rfl)

/-! ## `fd_r52x5_quad_to_table` -/

/-- The constant QUAD `(1, 1, 2, 2d)` of `to_table` and `ge_add`. -/
@[expose] public def c0 : Quad5 :=
  ⟨#v[1, 1, 2, 1859910466990425], #v[0, 0, 0, 932731440258426],
    #v[0, 0, 0, 1072319116312658], #v[0, 0, 0, 1815898335770999], #v[0, 0, 0, 633789495995903]⟩

public theorem c0_elem3 : c0.elem 3 = Ref.fd_f25519_k.limbs := by
  funext i; fin_cases i <;> rfl

public theorem c0_is : c0.Is ![1, 1, 2, 2 * d] (fun _ => 2 ^ 51) := by
  intro j
  fin_cases j
  · refine ⟨?_, fun i => ?_⟩ <;> (try fin_cases i) <;>
      simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, c0]
  · refine ⟨?_, fun i => ?_⟩ <;> (try fin_cases i) <;>
      simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, c0]
  · refine ⟨?_, fun i => ?_⟩ <;> (try fin_cases i) <;>
      simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, c0]
  · obtain ⟨hv, -⟩ := Ref.fd_f25519_k.val
    refine ⟨?_, fun i => ?_⟩
    · show Ed25519.Limbs.val (c0.elem 3) = _
      rw [c0_elem3, hv]; rfl
    · show (c0.elem 3 i).toNat ≤ _
      fin_cases i <;> decide

public theorem to_table_eq (X : Quad5) :
    fd_r52x5_quad_to_table.spec X =
      fd_r52x5_quad_mul.spec
        (Quad5.laneIf 1 1 0 0
          (fd_r52x5_quad_reduce.spec (fd_r52x5_quad_add_nc.spec (Quad5.permute 1 0 3 2 X)
            (Quad5.laneIf 1 0 1 0 (fd_r52x5_quad_negate_lazy.spec X) X))) X) c0 := rfl

/-- `to_table` of `(X, Y, Z, T)` with limbs below `2^52`: `(Y - X, Y + X, 2 Z, 2 d T)`. -/
public theorem to_table_is {P : Quad5} {X Y Z T : ZMod p} (h : P.Is ![X, Y, Z, T] b)
    (hb : ∀ j, b j < 2 ^ 52) :
    (fd_r52x5_quad_to_table.spec P).Is ![Y - X, Y + X, 2 * Z, 2 * d * T]
      (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [to_table_eq]
  have t1 := Quad5.laneIf_is 1 1 0 0
    (fd_r52x5_quad_reduce.spec_is (diffSum_is h fun j => by have := hb j; omega)) h
  have t1' := t1.congr (v' := ![Y - X, X + Y, Z, T]) (b' := fun j => 2 ^ 52 - 1)
    (fun j => by fin_cases j <;> simp)
    (fun j => by have := hb j; split <;> omega)
  have t2 := fd_r52x5_quad_mul.spec_is t1' c0_is (fun _ => by norm_num) (fun _ => by norm_num)
  exact t2.congr (fun j => by fin_cases j <;> simp <;> ring) (fun _ => le_rfl)

/-! ## `fd_r52x5_quad_ge_add` -/

public theorem ge_add_eq (X Y : Quad5) :
    fd_r52x5_quad_ge_add.spec X Y =
      fd_r52x5_quad_ge_add_table.spec X (fd_r52x5_quad_to_table.spec Y) := rfl

/-! ## `fd_r52x5_quad_ge_dbl` -/

/-- `fd_r52x5_quad_ge_dbl` of `P1`, limbs below `2^52`: `A = X^2`, `B = Y^2`, `H = A + B`,
`E = H - (Y + X)^2`, `G = A - B`, `F = G + 2 Z^2`, then `(E F, G H, G F, E H)`. -/
public theorem ge_dbl_is {P1 : Quad5} {X1 Y1 Z1 T1 : ZMod p}
    (h : P1.Is ![X1, Y1, Z1, T1] b) (hb : ∀ j, b j < 2 ^ 52) :
    let A := X1 ^ 2
    let B := Y1 ^ 2
    let E := A + B - (Y1 + X1) ^ 2
    let G := A - B
    let F := G + (Z1 ^ 2 + Z1 ^ 2)
    let H := A + B
    (fd_r52x5_quad_ge_dbl.spec P1).Is ![E * F, G * H, G * F, E * H] (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro A B E G F H
  simp only [fd_r52x5_quad_ge_dbl.spec, add_nc_eq, negate_lazy_eq]
  have hb' j := hb (Quad5.sel 1 0 3 2 j)
  have t1 := Quad5.laneIf_is 1 1 1 0 h
    (Quad5.permute_is 0 1 0 1 (fd_r52x5_quad_reduce.spec_is
      (Quad5.addFast_is h (Quad5.permute_is 1 0 3 2 h) fun j => by have := hb j; have := hb' j; omega)))
  have t1' := t1.congr (v' := ![X1, Y1, Z1, Y1 + X1]) (b' := fun _ => 2 ^ 52 - 1)
    (fun j => by fin_cases j <;> simp [Quad5.sel, add_comm])
    (fun j => by have := hb j; split <;> omega)
  have t2 := fd_r52x5_quad_sqr.spec_is t1' fun _ => by norm_num
  have t2' := t2.congr (v' := ![A, B, Z1 ^ 2, (Y1 + X1) ^ 2])
    (fun j => by fin_cases j <;> simp [A, B]) (fun _ => le_rfl)
  have p1 := Quad5.permute_is 0 0 0 0 t2'
  have p2 := Quad5.permute_is 1 1 1 1 t2'
  have n := Quad5.negateLazy_is (Quad5.laneIf_is 1 1 1 0 p2 t2') fun j => by
    fin_cases j <;> simp
  have a1 := Quad5.addFast_is (Quad5.laneIf_is 0 0 1 0 (Quad5.addFast_is t2' t2' fun _ => by
    norm_num) quad5_zero_is) p1 fun j => by fin_cases j <;> simp
  have a2 := Quad5.addFast_is (Quad5.laneIf_is 1 0 0 1 p2 quad5_zero_is) a1 fun j => by
    fin_cases j <;> simp
  have a3 := fd_r52x5_quad_reduce.spec_is
    (Quad5.addFast_is (Quad5.laneIf_is 0 1 1 1 n quad5_zero_is) a2 fun j => by fin_cases j <;> simp)
  have a3' := a3.congr (v' := ![H, G, F, E])
    (fun j => by fin_cases j <;> simp [Quad5.sel, H, G, F, E] <;> ring) (fun _ => le_rfl)
  have t4 := fd_r52x5_quad_mul.spec_is (Quad5.permute_is 3 1 1 3 a3')
    (Quad5.permute_is 2 0 2 0 a3') (fun _ => by norm_num) (fun _ => by norm_num)
  exact t4.congr (fun j => by fin_cases j <;> (simp [Quad5.sel]; try ring)) (fun _ => le_rfl)

/-! ## On the group -/

/-- `R` is `P` in extended coordinates, reduced, as the point kernels give it. -/
@[expose] public def ExtF (R : Quad5) (P : Point) : Prop :=
  R.Ext P.x P.y ∧ R.Below 52

/-- `T` is `P` precomputed, reduced, as `to_table` gives it. -/
@[expose] public def PreF (T : Quad5) (P : Point) : Prop :=
  T.Pre P.x P.y ∧ T.Below 52

public theorem ExtF.congr {R : Quad5} {P Q : Point} (h : ExtF R P) (e : P = Q) : ExtF R Q :=
  e ▸ h

public theorem ExtF.is {R : Quad5} {P : Point} (h : ExtF R P) :
    R.Is ![R.val 0, R.val 1, R.val 2, R.val 3] (fun _ => 2 ^ 52 - 1) :=
  h.2.is.congr (fun j => by fin_cases j <;> rfl) (fun _ => le_rfl)

/-- `ge_add_table` of `Q` extended and `P` precomputed: `Q + P`. -/
public theorem ge_add_table_extF {R T : Quad5} {Q P : Point} (hR : ExtF R Q) (hT : PreF T P) :
    ExtF (fd_r52x5_quad_ge_add_table.spec R T) (Q + P) := by
  obtain ⟨X, Y, T', Z, hE, e0, e1, e2, e3⟩ := hT.1
  have ht := hT.2.is.congr (v' := ![Y - X, Y + X, 2 * Z, 2 * d * T'])
    (fun j => by fin_cases j <;> simp [e0, e1, e2, e3]) (fun _ => le_rfl)
  have h := ge_add_table_is hR.is (fun _ => by norm_num) ht (fun _ => by norm_num)
  refine ⟨?_, h.below fun _ => by norm_num⟩
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3, Ed25519.Point.add_x, Ed25519.Point.add_y]
  exact isExt_add (Quad5.ext_iff_isExt.1 hR.1) hE Q.on P.on rfl (by ring) (by ring) (by ring)

/-- `to_table` of `Q` extended: `Q` precomputed. -/
public theorem to_table_preF {R : Quad5} {Q : Point} (hR : ExtF R Q) :
    PreF (fd_r52x5_quad_to_table.spec R) Q := by
  have h := to_table_is hR.is fun _ => by norm_num
  refine ⟨⟨R.val 0, R.val 1, R.val 3, R.val 2, Quad5.ext_iff_isExt.1 hR.1, ?_, ?_, ?_, ?_⟩,
    h.below fun _ => by norm_num⟩
  · rw [h.val 0]; simp
  · rw [h.val 1]; simp
  · rw [h.val 2]; simp
  · rw [h.val 3]; simp

/-- `ge_add` of `Q` and `P` extended: `Q + P`. -/
public theorem ge_add_extF {R S : Quad5} {Q P : Point} (hR : ExtF R Q) (hS : ExtF S P) :
    ExtF (fd_r52x5_quad_ge_add.spec R S) (Q + P) := by
  rw [ge_add_eq]
  exact ge_add_table_extF hR (to_table_preF hS)

/-- `ge_dbl` of `Q` extended: `Q + Q`. -/
public theorem ge_dbl_extF {R : Quad5} {Q : Point} (hR : ExtF R Q) :
    ExtF (fd_r52x5_quad_ge_dbl.spec R) (Q + Q) := by
  have h := ge_dbl_is hR.is fun _ => by norm_num
  refine ⟨?_, h.below fun _ => by norm_num⟩
  obtain ⟨hz, hx, hy⟩ := Quad5.proj_iff.1 hR.1.proj
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  have := isExt_dbl hz hx hy Q.on
  rw [Ed25519.Point.dbl_eq] at this
  exact this

/-- Entry `j` of the odd table of `A`, `A` extended `P`: `(2 j + 1) P` precomputed. -/
public theorem odd_table_preF {A : Quad5} {P : Point} (hA : ExtF A P) (j : ℕ) :
    PreF (fd_r52x5_odd_table.spec A j) ((2 * j + 1) • P) := by
  refine to_table_preF ?_
  induction j with
  | zero => exact hA.congr (by simp)
  | succ j ih =>
    rw [fd_r52x5_odd_table.pt]
    refine (ge_add_extF ih (ge_dbl_extF hA)).congr ?_
    rw [show 2 * (j + 1) + 1 = (2 * j + 1) + 2 by ring, add_nsmul _ (2 * j + 1) 2, two_nsmul]

/-- `GE_ZERO` is the neutral point, reduced. -/
public theorem quadZero_extF : ExtF quadZero 0 := by
  have h : quadZero.Is ![0, 1, 1, 0] (fun _ => 1) := by
    intro j
    refine ⟨?_, fun i => ?_⟩ <;> fin_cases j <;> (try fin_cases i) <;>
      simp [Quad5.val, Ed25519.Limbs.val_eq, Quad5.elem, Quad5.limb, quadZero, wl, wl_zero]
  refine ⟨?_, h.below fun _ => by norm_num⟩
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  exact ⟨one_ne_zero, by simp, by simp, by simp⟩

/-- The lane blend of `quad_neg A` into `A`, `A` affine reduced: `-P` extended. -/
public theorem neg_lane_extF {A : Quad5} {P : Point} (hA : A.Affine P.x P.y) (hb : A.Below 52) :
    ExtF (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec A) A) (-P) := by
  have h := Quad5.laneIf_is 1 0 0 1 (fd_r52x5_quad_neg.spec_is hb.is fun _ => by norm_num) hb.is
  refine ⟨?_, h.below fun j => by fin_cases j <;> simp⟩
  have := Ed25519.IsExt.neg (Quad5.ext_iff_isExt.1 hA.ext)
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  simpa using this

/-- An affine reduced point is extended. -/
public theorem Affine.extF {A : Quad5} {P : Point} (hA : A.Affine P.x P.y) (hb : A.Below 52) :
    ExtF A P :=
  ⟨hA.ext, hb⟩

end MLIR.Firedancer.Crc.Verify

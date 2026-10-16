module

public import Ed25519.Group
public import Mathlib.Algebra.Group.Subgroup.Basic
public import Mathlib.GroupTheory.QuotientGroup.Defs
public import Mathlib.Algebra.BigOperators.Group.Finset.Defs
import Mathlib.Algebra.Group.Submonoid.BigOperators
import Mathlib.Tactic.Abel
import Ed25519.Decode
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! ristretto255 (RFC 9496) over the Edwards group: decoding, encoding, and the 4-torsion `E4` they
identify. Encoding is constant on `E4`-cosets of `Even` (the points with `1 - y²` a square, a
subgroup containing `2E` and every decoded point), and induces a bijection `Even / E4 ≃` the
accepted encodings. -/

namespace Ed25519.Ristretto

/-! ## Definitions -/

@[expose] public section

/-- RFC 9496's `IS_NEGATIVE`: the canonical value is odd. -/
def IsNeg (a : ZMod p) : Prop :=
  a.val % 2 = 1

instance (a : ZMod p) : Decidable (IsNeg a) :=
  inferInstanceAs (Decidable (_ = _))

/-- `CT_ABS`: `-a` for negative `a`, else `a`. -/
def ctAbs (a : ZMod p) : ZMod p :=
  if IsNeg a then -a else a

/-- The nonnegative square root of `a`, `0` if `a` is no square. -/
noncomputable def nnSqrt (a : ZMod p) : ZMod p :=
  open Classical in if h : IsSquare a then ctAbs h.choose else 0

/-- RFC 9496 §4.2 `SQRT_RATIO_M1(u, v)`: `(true, √(u/v))` for `u = 0` or `u/v` a nonzero square,
`(false, 0)` for `v = 0 ≠ u`, else `(false, √(√-1 · u/v))`; roots nonnegative. -/
noncomputable def sqrtRatioM1 (u v : ZMod p) : Bool × ZMod p :=
  open Classical in
    if u = 0 ∨ (v ≠ 0 ∧ IsSquare (u / v)) then (true, nnSqrt (u / v))
    else (false, nnSqrt (sqrtM1 * u / v))

/-- `INVSQRT_A_MINUS_D`, `1/√(a - d)` for `a = -1`. -/
def invsqrtAMinusD : ZMod p :=
  54469307008909316920995813868745141605393597292927456921205312896311721017578

/-- RFC 9496 §4.3.1 decoding, steps 2–3, from the field element `s`. -/
noncomputable def decodeS (s : ZMod p) : Option (ZMod p × ZMod p) :=
  let ss := s ^ 2
  let u1 := 1 - ss
  let u2 := 1 + ss
  let u2_sqr := u2 ^ 2
  let v := -(d * u1 ^ 2) - u2_sqr
  let r := sqrtRatioM1 1 (v * u2_sqr)
  let den_x := r.2 * u2
  let den_y := r.2 * den_x * v
  let x := ctAbs (2 * s * den_x)
  let y := u1 * den_y
  let t := x * y
  if r.1 = false ∨ IsNeg t ∨ y = 0 then none else some (x, y)

/-- RFC 9496 §4.3.1 decoding, as coordinates: `none` for `s ≥ p`, odd `s`, or where steps 2–3
reject. -/
noncomputable def decodeXY (b : BitVec 256) : Option (ZMod p × ZMod p) :=
  if p ≤ b.toNat ∨ b.toNat % 2 = 1 then none else decodeS b.toNat

/-- RFC 9496 §4.3.2 encoding of extended coordinates `(x0 : y0 : z0 : t0)`, the field element `s`. -/
noncomputable def encodeExtS (x0 y0 z0 t0 : ZMod p) : ZMod p :=
  let u1 := (z0 + y0) * (z0 - y0)
  let u2 := x0 * y0
  let invsqrt := (sqrtRatioM1 1 (u1 * u2 ^ 2)).2
  let den1 := invsqrt * u1
  let den2 := invsqrt * u2
  let z_inv := den1 * den2 * t0
  let ix0 := x0 * sqrtM1
  let iy0 := y0 * sqrtM1
  let enchanted_denominator := den1 * invsqrtAMinusD
  let rotate := IsNeg (t0 * z_inv)
  let x := if rotate then iy0 else x0
  let y := if rotate then ix0 else y0
  let den_inv := if rotate then enchanted_denominator else den2
  let y := if IsNeg (x * z_inv) then -y else y
  ctAbs (den_inv * (z0 - y))

/-- RFC 9496 §4.3.2 encoding of extended coordinates, as 32 little-endian bytes. -/
noncomputable def encodeExt (x0 y0 z0 t0 : ZMod p) : BitVec 256 :=
  BitVec.ofNat 256 (encodeExtS x0 y0 z0 t0).val

/-- `P`'s ristretto255 encoding, from its affine extended coordinates `(x : y : 1 : x y)`. -/
noncomputable def encode (P : Point) : BitVec 256 :=
  encodeExt P.x P.y 1 (P.x * P.y)

/-- The 2-torsion point `(0, -1)`. -/
def T2 : Point :=
  ⟨0, -1, by
    unfold OnCurve; ring⟩

/-- The 4-torsion point `(√-1, 0)`. -/
def T4 : Point :=
  ⟨sqrtM1, 0, by
    unfold OnCurve; linear_combination -sqrtM1_sq⟩

end

/-! ## Field facts -/

section Field

/-- `INVSQRT_A_MINUS_D² (a - d) = 1`. -/
public theorem invsqrtAMinusD_sq : invsqrtAMinusD ^ 2 * (-1 - d) = 1 := by
  unfold invsqrtAMinusD d
  reduce_mod_char

/-- `1 + d ≠ 0`. -/
theorem one_add_d_ne : (1 : ZMod p) + d ≠ 0 := fun h => by
  have := invsqrtAMinusD_sq
  rw [show (-1 : ZMod p) - d = -(1 + d) by ring, h] at this
  simp at this

theorem two_ne : (2 : ZMod p) ≠ 0 := by decide

theorem p_odd : p % 2 = 1 := by norm_num

/-- `-a` has the other parity, for `a ≠ 0`. -/
public theorem val_neg_mod_two {a : ZMod p} (h : a ≠ 0) : (-a).val % 2 = 1 - a.val % 2 := by
  rw [ZMod.neg_val, ite_eq_right_of_eq_false _ _ (eq_false h)]
  have := ZMod.val_lt a
  have : 0 < a.val := (ZMod.val_pos).2 h
  have := p_odd
  omega

/-- `CT_ABS` is nonnegative. -/
public theorem ctAbs_even (a : ZMod p) : (ctAbs a).val % 2 = 0 := by
  unfold ctAbs
  split_ifs with h <;> unfold IsNeg at h
  · have h0 : a ≠ 0 := by
      rintro rfl; simp at h
    rw [val_neg_mod_two h0]; omega
  · omega

/-- `CT_ABS a` is `±a`. -/
public theorem ctAbs_eq_or (a : ZMod p) : ctAbs a = a ∨ ctAbs a = -a := by
  unfold ctAbs; split <;> simp

/-- `CT_ABS a` squares to `a²`. -/
public theorem ctAbs_sq (a : ZMod p) : ctAbs a ^ 2 = a ^ 2 := by
  rcases ctAbs_eq_or a with h | h <;> rw [h]; ring

/-- `CT_ABS` fixes nonnegative values. -/
public theorem ctAbs_of_even {a : ZMod p} (h : a.val % 2 = 0) : ctAbs a = a := by
  unfold ctAbs IsNeg; simp [h]

/-- Two even roots of one square are equal. -/
public theorem eq_of_sq_eq {r s : ZMod p} (h : r ^ 2 = s ^ 2) (hr : r.val % 2 = 0)
    (hs : s.val % 2 = 0) : r = s := by
  have : (r - s) * (r + s) = 0 := by linear_combination h
  rcases mul_eq_zero.1 this with h | h
  · linear_combination h
  · have hr' : r = -s := by linear_combination h
    by_cases s0 : s = 0
    · rw [hr', s0, neg_zero]
    · rw [hr', val_neg_mod_two s0] at hr; omega

/-- `CT_ABS (-a) = CT_ABS a`. -/
public theorem ctAbs_neg (a : ZMod p) : ctAbs (-a) = ctAbs a :=
  eq_of_sq_eq (by rw [ctAbs_sq, ctAbs_sq, neg_sq]) (ctAbs_even _) (ctAbs_even _)

/-- `CT_ABS` of either root of `a²` is `CT_ABS a`. -/
public theorem ctAbs_eq_of_sq_eq {a b : ZMod p} (h : a ^ 2 = b ^ 2) : ctAbs a = ctAbs b :=
  eq_of_sq_eq (by rw [ctAbs_sq, ctAbs_sq, h]) (ctAbs_even _) (ctAbs_even _)

/-- `nnSqrt` is nonnegative. -/
public theorem nnSqrt_even (a : ZMod p) : (nnSqrt a).val % 2 = 0 := by
  unfold nnSqrt; split
  · exact ctAbs_even _
  · simp

/-- `nnSqrt a` is a root of a square `a`. -/
public theorem nnSqrt_sq {a : ZMod p} (h : IsSquare a) : nnSqrt a ^ 2 = a := by
  unfold nnSqrt
  rw [dite_eq_left_of_eq_true (eq_true h), ctAbs_sq, sq]
  exact h.choose_spec.symm

/-- `nnSqrt` of a non-square is `0`. -/
public theorem nnSqrt_of_not {a : ZMod p} (h : ¬IsSquare a) : nnSqrt a = 0 := by
  unfold nnSqrt; rw [dite_eq_right_of_eq_false (eq_false h)]

/-- A nonnegative root of `a` is `nnSqrt a`. -/
public theorem nnSqrt_eq {a r : ZMod p} (h : r ^ 2 = a) (hr : r.val % 2 = 0) : nnSqrt a = r :=
  eq_of_sq_eq (by rw [nnSqrt_sq ⟨r, by rw [← h, sq]⟩, h]) (nnSqrt_even _) hr

/-- `nnSqrt 0 = 0`. -/
public theorem nnSqrt_zero : nnSqrt 0 = 0 :=
  nnSqrt_eq (by ring) (by simp)

/-- `SQRT_RATIO_M1`'s root is nonnegative. -/
public theorem sqrtRatioM1_even (u v : ZMod p) : (sqrtRatioM1 u v).2.val % 2 = 0 := by
  unfold sqrtRatioM1; split <;> exact nnSqrt_even _

/-- `SQRT_RATIO_M1(1, w)` succeeds exactly for `w` a nonzero square, its root then `1/√w`. -/
public theorem sqrtRatioM1_one {w : ZMod p} :
    ((sqrtRatioM1 1 w).1 = true ↔ w ≠ 0 ∧ IsSquare w) ∧
      ((sqrtRatioM1 1 w).1 = true → (sqrtRatioM1 1 w).2 ^ 2 * w = 1) := by
  have hiff : w ≠ 0 → (IsSquare (1 / w) ↔ IsSquare w) := fun hw => by
    constructor <;> rintro ⟨r, hr⟩
    · refine ⟨1 / r, ?_⟩
      have hr0 : r ≠ 0 := by
        rintro rfl; simp [hw] at hr
      field_simp at hr ⊢; linear_combination -hr
    · refine ⟨1 / r, ?_⟩
      have hr0 : r ≠ 0 := by
        rintro rfl; simp [hw] at hr
      rw [hr]; field_simp
  unfold sqrtRatioM1
  by_cases h : (1 : ZMod p) = 0 ∨ (w ≠ 0 ∧ IsSquare (1 / w))
  · rw [ite_eq_left_of_eq_true _ _ (eq_true h)]
    have h' : w ≠ 0 ∧ IsSquare (1 / w) := h.resolve_left one_ne_zero
    refine ⟨by simpa using ⟨h'.1, (hiff h'.1).1 h'.2⟩, fun _ => ?_⟩
    rw [nnSqrt_sq h'.2]; field_simp [h'.1]
  · rw [ite_eq_right_of_eq_false _ _ (eq_false h)]
    simp only [Bool.false_eq_true, false_iff, false_implies, and_true]
    rintro ⟨hw, hs⟩
    exact h (.inr ⟨hw, (hiff hw).2 hs⟩)

/-- `SQRT_RATIO_M1(1, 0)` is `(false, 0)`. -/
public theorem sqrtRatioM1_one_zero : sqrtRatioM1 1 0 = (false, 0) := by
  unfold sqrtRatioM1
  simp [nnSqrt_zero]

end Field

/-! ## The 4-torsion `E4` and the domain `Dom` -/

section Torsion

/-- On the curve `x = 0` exactly when `y² = 1`. -/
public theorem x_eq_zero_iff {x y : ZMod p} (h : OnCurve x y) : x = 0 ↔ y ^ 2 = 1 := by
  rw [onCurve_iff] at h
  constructor
  · rintro rfl; linear_combination -h
  · intro hy
    have : (y ^ 2 * d + 1) * x ^ 2 = 0 := by
      rw [h, hy]; ring
    have hv : y ^ 2 * d + 1 ≠ 0 := by
      have := v_ne y; intro h0; exact this (by linear_combination h0)
    exact pow_eq_zero_iff (n := 2) (by norm_num) |>.1 ((mul_eq_zero.1 this).resolve_left hv)

/-- The curve identity behind the rotation: `(1 - y²)(1 + x²) = -(1 + d) x² y²`. -/
public theorem one_sub_mul_one_add {x y : ZMod p} (h : OnCurve x y) :
    (1 - y ^ 2) * (1 + x ^ 2) = -(1 + d) * x ^ 2 * y ^ 2 := by
  unfold OnCurve at h; linear_combination -h

/-- A double's `x` is zero exactly when `x y = 0`. -/
theorem double_x_eq_zero (P : Point) : (P + P).x = 0 ↔ P.x * P.y = 0 := by
  rw [Point.add_x]; simp only [add]; rw [div_eq_zero_iff, or_iff_left (add_den₁ P.on P.on)]
  constructor <;> intro h
  · have := mul_eq_zero.1 (show 2 * (P.x * P.y) = 0 by linear_combination h)
    exact this.resolve_left two_ne
  · linear_combination 2 * h

/-- A point with `x = 0` doubles to `0`. -/
theorem double_of_x (P : Point) (h : P.x = 0) : P + P = 0 := by
  have hy := (x_eq_zero_iff P.on).1 h
  ext
  · simp [Point.add_x, add, h]
  · simp [Point.add_y, add, h, ← sq, hy]

/-- A point with `y = 0` doubles to `(0, -1)`. -/
theorem double_y_of_y (P : Point) (h : P.y = 0) : (P + P).y = -1 := by
  have hc := P.on
  unfold OnCurve at hc
  simp only [Point.add_y, add, h, mul_zero, sub_zero, zero_add, div_one]
  rw [h] at hc; linear_combination -hc

public section

/-- The 4-torsion subgroup `E[4]`. -/
@[expose]
def E4 : AddSubgroup Point where
  carrier := {P | 4 • P = 0}
  zero_mem' := nsmul_zero 4
  add_mem' {a b} ha hb := by
    simp only [Set.mem_ofPred_eq] at ha hb ⊢; rw [nsmul_add, ha, hb, add_zero]
  neg_mem' {a} ha := by
    simp only [Set.mem_ofPred_eq] at ha ⊢; rw [smul_neg, ha, neg_zero]

end

/-- `E[4]` is the points with `x = 0` or `y = 0`. -/
public theorem mem_E4 {P : Point} : P ∈ E4 ↔ P.x = 0 ∨ P.y = 0 := by
  change 4 • P = 0 ↔ _
  rw [show 4 • P = 2 • P + 2 • P by rw [← add_nsmul], two_nsmul]
  rw [← mul_eq_zero, ← double_x_eq_zero]
  constructor
  · intro h
    have hx := congrArg Point.x h
    rw [Point.zero_x] at hx
    rcases mul_eq_zero.1 ((double_x_eq_zero _).1 hx) with h0 | h0
    · exact h0
    · have := double_y_of_y _ h0
      rw [h, Point.zero_y] at this
      exact absurd this (by decide)
  · exact double_of_x _

/-- `E[4] = {0, (0, -1), (±√-1, 0)}`. -/
public theorem mem_E4_iff_eq {P : Point} : P ∈ E4 ↔ P = 0 ∨ P = T2 ∨ P = T4 ∨ P = -T4 := by
  rw [mem_E4]
  have hc := P.on
  constructor
  · rintro (h | h)
    · have hy := (x_eq_zero_iff hc).1 h
      rcases sq_eq_one_iff'.1 hy with hy | hy
      · exact .inl (Point.ext h hy)
      · exact .inr (.inl (Point.ext h hy))
    · unfold OnCurve at hc
      rw [h] at hc
      have : (P.x - sqrtM1) * (P.x + sqrtM1) = 0 := by linear_combination -hc - sqrtM1_sq
      rcases mul_eq_zero.1 this with h' | h'
      · exact
          .inr
            (.inr
              (.inl
                (Point.ext
                  (by
                    show P.x = sqrtM1; linear_combination h')
                  h)))
      · exact
          .inr
            (.inr
              (.inr
                (Point.ext
                  (by
                    show P.x = -sqrtM1; linear_combination h')
                  h)))
  · rintro (rfl | rfl | rfl | rfl)
    · exact .inl rfl
    · exact .inl rfl
    · exact .inr rfl
    · exact .inr rfl

/-- Adding `(0, -1)` negates both coordinates. -/
public theorem add_T2 (P : Point) : (P + T2).x = -P.x ∧ (P + T2).y = -P.y := by
  simp [Point.add_x, Point.add_y, add, T2]

/-- Adding `(√-1, 0)` gives `(√-1 y, √-1 x)`. -/
public theorem add_T4 (P : Point) : (P + T4).x = P.y * sqrtM1 ∧ (P + T4).y = P.x * sqrtM1 := by
  simp [Point.add_x, Point.add_y, add, T4]

/-- Subtracting `(√-1, 0)` gives `(-√-1 y, -√-1 x)`. -/
public theorem sub_T4 (P : Point) :
    (P - T4).x = -(P.y * sqrtM1) ∧ (P - T4).y = -(P.x * sqrtM1) := by
  simp [Point.sub_x, Point.sub_y, add, T4]

/-- RFC 9496 §4.3.3 equality, `x₁ y₂ = y₁ x₂ ∨ y₁ y₂ = x₁ x₂`, is `P - Q ∈ E[4]`, for all points. -/
public theorem rfcEq_iff (P Q : Point) :
    (P.x * Q.y = P.y * Q.x ∨ P.y * Q.y = P.x * Q.x) ↔ P - Q ∈ E4 := by
  rw [mem_E4, Point.sub_x, Point.sub_y]; simp only [add];
  rw [div_eq_zero_iff, div_eq_zero_iff, or_iff_left (add_den₁ P.on Q.on.neg),
    or_iff_left (add_den₂ P.on Q.on.neg)]
  constructor <;> rintro (h | h)
  · exact .inl (by linear_combination h)
  · exact .inr (by linear_combination h)
  · exact .inl (by linear_combination h)
  · exact .inr (by linear_combination h)

end Torsion

section Dom

/-- `1 - (N/M)²` is `(K/L)²` once `(M² - N²) L² = K² M²`. -/
theorem one_sub_div_sq {N M K L : ZMod p} (hM : M ≠ 0) (hL : L ≠ 0)
    (h : (M ^ 2 - N ^ 2) * L ^ 2 = K ^ 2 * M ^ 2) : 1 - (N / M) ^ 2 = K / L * (K / L) := by
  rw [show K / L * (K / L) = K ^ 2 / L ^ 2 by ring, div_pow,
    show 1 - N ^ 2 / M ^ 2 = (M ^ 2 - N ^ 2) / M ^ 2 by field_simp,
    div_eq_div_iff (pow_ne_zero 2 hM) (pow_ne_zero 2 hL)]
  exact h

/-- A double has `1 - y²` a square. -/
public theorem isSquare_double (P : Point) : IsSquare (1 - (P + P).y ^ 2) := by
  rcases P with ⟨x, y, hc⟩
  have hD := add_den₂ hc hc
  have hc2 := invsqrtAMinusD_sq
  have hcd : invsqrtAMinusD ≠ 0 := by
    rintro h; rw [h] at hc2; simp at hc2
  rw [Point.add_y]
  simp only [add]
  refine ⟨_, one_sub_div_sq hD (mul_ne_zero hcd hD) (K := 2 * x * y) ?_⟩
  unfold OnCurve at hc
  linear_combination
    invsqrtAMinusD ^ 2 * (1 - d * x * x * y * y) ^ 2 * (-(d * x ^ 2 * y ^ 2) + x ^ 2 - y ^ 2 - 1) *
        hc +
      4 * x ^ 2 * y ^ 2 * (1 - d * x * x * y * y) ^ 2 * hc2

/-- `Dom` is closed under addition: `1 - y²` is multiplicative modulo squares. -/
public theorem isSquare_add {P Q : Point} (hP : IsSquare (1 - P.y ^ 2))
    (hQ : IsSquare (1 - Q.y ^ 2)) : IsSquare (1 - (P + Q).y ^ 2) := by
  have h1 := P.on
  have h2 := Q.on
  by_cases hx₁ : P.x = 0
  · have hy := (x_eq_zero_iff h1).1 hx₁
    rw [Point.add_y]; simp only [add, hx₁]
    simp only [mul_zero, zero_mul, add_zero, sub_zero, div_one]
    rwa [mul_pow, hy, one_mul]
  by_cases hx₂ : Q.x = 0
  · have hy := (x_eq_zero_iff h2).1 hx₂
    rw [Point.add_y]; simp only [add, hx₂]
    simp only [mul_zero, zero_mul, add_zero, sub_zero, div_one]
    rwa [mul_pow, hy, mul_one]
  by_cases hy : P.y = Q.y
  · rw [← hy] at h2
    rcases
      sq_eq_one_iff'.1
        (show (Q.x / P.x) ^ 2 = 1 by
          rw [div_pow, ← sq_eq_of_onCurve h1 h2, div_self (pow_ne_zero 2 hx₁)]) with
      h | h
    · rw [show Q = P from
          Point.ext
            (by
              field_simp at h; exact h)
            hy.symm]
      exact isSquare_double P
    · rw [show Q = -P from
          Point.ext
            (by
              field_simp at h; rw [Point.neg_x]; linear_combination h)
            hy.symm,
        add_neg_cancel, Point.zero_y]
      exact ⟨0, by ring⟩
  · obtain ⟨a, ha⟩ := hP
    obtain ⟨b, hb⟩ := hQ
    have hM := add_den₂ h1 h2
    have hc2 := invsqrtAMinusD_sq
    rw [Point.add_y]
    simp only [add]
    set x₁ := P.x
    set y₁ := P.y
    set x₂ := Q.x
    set y₂ := Q.y
    set c := invsqrtAMinusD
    have hyy : y₂ - y₁ ≠ 0 := sub_ne_zero.2 (Ne.symm hy)
    unfold OnCurve at h1 h2
    have hid :
      ((1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 - (y₁ * y₂ + x₁ * x₂) ^ 2) * (1 + d) * x₁ ^ 2 * x₂ ^ 2 *
          (y₂ - y₁) ^ 2 =
        -((1 - d * x₁ * x₂ * y₁ * y₂) - (y₁ * y₂ + x₁ * x₂)) ^ 2 * (1 - y₁ ^ 2) * (1 - y₂ ^ 2) *
          (x₂ - x₁) ^ 2 := by
      linear_combination
        (x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 4 * d - 2 * x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ * d +
                                                        x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 4 -
                                                      2 * x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ -
                                                      2 * x₁ * y₁ ^ 2 * x₂ ^ 3 * y₂ ^ 2 +
                                                    x₁ ^ 2 * x₂ ^ 4 * y₂ ^ 2 +
                                                    2 * x₁ * y₁ * x₂ ^ 3 * y₂ ^ 3 -
                                                  x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 4 +
                                                y₁ ^ 2 * x₂ ^ 2 * y₂ ^ 4 +
                                                x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 * d -
                                              2 * x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * d +
                                            2 * x₁ * y₁ * x₂ ^ 3 * y₂ * d +
                                            x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 +
                                            2 * x₁ * y₁ ^ 2 * x₂ ^ 3 -
                                          x₁ ^ 2 * x₂ ^ 4 -
                                          2 * x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ +
                                        x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 2 -
                                      2 * x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 +
                                    2 * x₁ ^ 2 * x₂ ^ 2 * y₂ ^ 2 -
                                  y₁ ^ 2 * x₂ ^ 2 * y₂ ^ 2 -
                                  2 * x₁ * x₂ ^ 3 * y₂ ^ 2 +
                                2 * x₁ ^ 2 * y₁ * y₂ ^ 3 +
                                2 * x₁ * y₁ * x₂ * y₂ ^ 3 -
                              2 * y₁ * x₂ ^ 2 * y₂ ^ 3 +
                            2 * x₁ * y₁ ^ 2 * x₂ -
                          2 * x₁ ^ 2 * x₂ ^ 2 +
                        2 * x₁ * x₂ ^ 3 -
                      2 * x₁ ^ 2 * y₁ * y₂ -
                      2 * x₁ * y₁ * x₂ * y₂ +
                    2 * y₁ * x₂ ^ 2 * y₂ -
                  2 * x₁ * x₂ * y₂ ^ 2 +
                x₂ ^ 2 * y₂ ^ 2 +
                2 * x₁ * x₂ -
              x₂ ^ 2) *
            h1 +
          (-x₁ ^ 4 * y₁ ^ 4 * x₂ ^ 2 * d ^ 2 + 2 * x₁ ^ 4 * y₁ ^ 3 * x₂ ^ 2 * y₂ * d ^ 2 -
                                                          x₁ ^ 4 * y₁ ^ 2 * x₂ ^ 2 * y₂ ^ 2 *
                                                            d ^ 2 -
                                                          x₁ ^ 4 * y₁ ^ 4 * x₂ ^ 2 * d +
                                                        2 * x₁ ^ 4 * y₁ ^ 3 * x₂ ^ 2 * y₂ * d -
                                                      x₁ ^ 4 * y₁ ^ 4 * y₂ ^ 2 * d +
                                                    2 * x₁ ^ 3 * y₁ ^ 4 * x₂ * y₂ ^ 2 * d -
                                                  x₁ ^ 4 * y₁ ^ 2 * x₂ ^ 2 * y₂ ^ 2 * d -
                                                  x₁ ^ 2 * y₁ ^ 4 * x₂ ^ 2 * y₂ ^ 2 * d -
                                                  2 * x₁ ^ 3 * y₁ ^ 4 * x₂ * d +
                                                x₁ ^ 4 * y₁ ^ 2 * x₂ ^ 2 * d +
                                                x₁ ^ 2 * y₁ ^ 4 * x₂ ^ 2 * d +
                                                2 * x₁ ^ 4 * y₁ ^ 3 * y₂ * d -
                                              2 * x₁ ^ 3 * y₁ ^ 2 * x₂ * y₂ ^ 2 * d +
                                            x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 * y₂ ^ 2 * d +
                                            x₁ ^ 2 * y₁ ^ 4 * x₂ ^ 2 +
                                            2 * x₁ ^ 3 * y₁ ^ 3 * x₂ * y₂ -
                                          2 * x₁ ^ 2 * y₁ ^ 3 * x₂ ^ 2 * y₂ -
                                          x₁ ^ 4 * y₁ ^ 2 * y₂ ^ 2 +
                                        2 * x₁ ^ 2 * y₁ ^ 4 * y₂ ^ 2 -
                                      2 * x₁ * y₁ ^ 4 * x₂ * y₂ ^ 2 -
                                      2 * x₁ ^ 3 * y₁ ^ 2 * x₂ * d -
                                      x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 * d +
                                    2 * x₁ ^ 3 * y₁ * x₂ * y₂ * d -
                                  4 * x₁ ^ 3 * y₁ ^ 2 * x₂ +
                                2 * x₁ * y₁ ^ 4 * x₂ +
                                x₁ ^ 4 * x₂ ^ 2 -
                              x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 +
                            2 * x₁ ^ 4 * y₁ * y₂ -
                          4 * x₁ ^ 2 * y₁ ^ 3 * y₂ +
                        2 * x₁ * y₁ ^ 3 * x₂ * y₂ +
                        2 * x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ -
                      2 * x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 2 +
                    2 * x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 +
                    x₁ ^ 2 * y₁ ^ 2 -
                  2 * x₁ * y₁ ^ 2 * x₂ +
                4 * x₁ ^ 2 * y₁ * y₂ -
              2 * x₁ * y₁ * x₂ * y₂ -
              x₁ ^ 2) *
            h2
    refine
      ⟨_,
        one_sub_div_sq hM (mul_ne_zero (mul_ne_zero (mul_ne_zero hx₁ hx₂) hyy) hM) (K :=
          a * b * c * ((1 - d * x₁ * x₂ * y₁ * y₂) - (y₁ * y₂ + x₁ * x₂)) * (x₂ - x₁)) ?_⟩
    linear_combination
      (-((1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 - (y₁ * y₂ + x₁ * x₂) ^ 2) * x₁ ^ 2 * x₂ ^ 2 *
              (y₂ - y₁) ^ 2 *
              (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2) *
            hc2 -
          c ^ 2 * (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 * hid +
        c ^ 2 * (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 *
          ((1 - d * x₁ * x₂ * y₁ * y₂) - (y₁ * y₂ + x₁ * x₂)) ^ 2 *
          (x₂ - x₁) ^ 2 *
          (1 - y₂ ^ 2) *
          ha +
        c ^ 2 * (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 *
          ((1 - d * x₁ * x₂ * y₁ * y₂) - (y₁ * y₂ + x₁ * x₂)) ^ 2 *
          (x₂ - x₁) ^ 2 *
          a ^ 2 *
          hb

end Dom

section Dom

/-- The points with `1 - y²` a square: a subgroup containing `2E`, `E[4]` and every decoded point,
on whose `E[4]`-cosets the encoding is constant. -/
@[expose]
public def Dom : AddSubgroup Point where
  carrier := {P | IsSquare (1 - P.y ^ 2)}
  zero_mem' := ⟨0, by simp⟩
  add_mem' := isSquare_add
  neg_mem' {a} h := by simpa using h

/-- Membership in `Dom`. -/
public theorem mem_Dom {P : Point} : P ∈ Dom ↔ IsSquare (1 - P.y ^ 2) :=
  Iff.rfl

/-- `2E ⊆ Dom`. -/
public theorem two_nsmul_mem_Dom (P : Point) : 2 • P ∈ Dom := by
  rw [two_nsmul]; exact isSquare_double P

/-- `E[4] ⊆ Dom`. -/
public theorem E4_le_Dom : E4 ≤ Dom := fun P h => by
  rcases mem_E4.1 h with h | h
  · rw [mem_Dom, (x_eq_zero_iff P.on).1 h]; exact ⟨0, by ring⟩
  · rw [mem_Dom, h]; exact ⟨1, by ring⟩

end Dom

/-! ## Decoding -/

section Decode

/-- `(x, y)` is what decoding produces from `s`: `y = (1 - s²)/(1 + s²)`, `x` and `x y` even,
`y ≠ 0`. -/
@[expose]
public def Canon (s x y : ZMod p) : Prop :=
  y * (1 + s ^ 2) = 1 - s ^ 2 ∧ x.val % 2 = 0 ∧ (x * y).val % 2 = 0 ∧ y ≠ 0

/-- On the curve with `y (1 + s²) = 1 - s²`: `v x² = 4 s²` for RFC 9496's `v`. -/
theorem v_mul_sq {s x y : ZMod p} (hc : OnCurve x y) (hy : y * (1 + s ^ 2) = 1 - s ^ 2) :
    (-(d * (1 - s ^ 2) ^ 2) - (1 + s ^ 2) ^ 2) * x ^ 2 = 4 * s ^ 2 := by
  rw [onCurve_iff] at hc
  linear_combination
    (x ^ 2 * y * d * s ^ 2 - x ^ 2 * s ^ 2 * d + x ^ 2 * y * d - y * s ^ 2 + x ^ 2 * d + s ^ 2 - y -
          1) *
        hy +
      (-s ^ 4 - 2 * s ^ 2 - 1) * hc

/-- Steps 2–3 accept exactly the points `Canon s` describes, returning them. -/
public theorem decodeS_eq_some {s x y : ZMod p} :
    decodeS s = some (x, y) ↔ OnCurve x y ∧ Canon s x y := by
  unfold decodeS
  dsimp only
  generalize hw : (-(d * (1 - s ^ 2) ^ 2) - (1 + s ^ 2) ^ 2) * (1 + s ^ 2) ^ 2 = w
  generalize hv : -(d * (1 - s ^ 2) ^ 2) - (1 + s ^ 2) ^ 2 = v at hw
  obtain ⟨hok, hI⟩ := sqrtRatioM1_one (w := w)
  generalize sqrtRatioM1 1 w = r at hok hI
  rcases r with ⟨ok, I⟩
  dsimp only at hok hI ⊢
  constructor
  · intro h
    split_ifs at h with hc
    simp only [not_or, Bool.not_eq_false] at hc
    obtain ⟨hok', hneg, hy0⟩ := hc
    cases h
    have hI' := hI hok'
    have hu2 : 1 + s ^ 2 ≠ 0 := fun h0 =>
      (hok.1 hok').1
        (by
          rw [← hw, h0]; ring)
    have hIv : I ^ 2 * (v * (1 + s ^ 2) ^ 2) = 1 := by
      rw [hw]; exact hI'
    have hy : (1 - s ^ 2) * (I * (I * (1 + s ^ 2)) * v) * (1 + s ^ 2) = 1 - s ^ 2 := by
      linear_combination (1 - s ^ 2) * hIv
    have hx : (ctAbs (2 * s * (I * (1 + s ^ 2)))) ^ 2 * v = 4 * s ^ 2 := by
      rw [ctAbs_sq]; linear_combination 4 * s ^ 2 * hIv
    refine ⟨?_, hy, ctAbs_even _, ?_, hy0⟩
    · rw [onCurve_iff]
      apply mul_right_cancel₀ (pow_ne_zero 2 hu2)
      generalize ctAbs (2 * s * (I * (1 + s ^ 2))) = x at hx
      generalize (1 - s ^ 2) * (I * (I * (1 + s ^ 2)) * v) = y at hy
      rw [← hv] at hx
      linear_combination (y * (1 + s ^ 2) + (1 - s ^ 2)) * (d * x ^ 2 - 1) * hy - hx
    · unfold IsNeg at hneg; omega
  · rintro ⟨hc, hy, hx, hxy, hy0⟩
    have hu2 : 1 + s ^ 2 ≠ 0 := fun h0 => by
      rw [h0, mul_zero] at hy
      have : (2 : ZMod p) = 0 := by linear_combination h0 - hy
      exact two_ne this
    have hvx := v_mul_sq hc hy
    rw [hv] at hvx
    have hv0 : v ≠ 0 := fun h0 => by
      rw [h0, zero_mul] at hvx
      have hs : s = 0 :=
        pow_eq_zero_iff (n := 2) (by norm_num) |>.1
          ((mul_eq_zero.1 hvx.symm).resolve_left (by decide))
      rw [hs] at hv
      exact one_add_d_ne (by linear_combination -hv - h0)
    have hsq : IsSquare w := by
      rw [← hw]
      by_cases hx0 : x = 0
      · have hs : s = 0 :=
          pow_eq_zero_iff (n := 2) (by norm_num) |>.1
            ((mul_eq_zero.1
                  (by
                    rw [← hvx, hx0]; ring : (4 : ZMod p) * s ^ 2 = 0)).resolve_left
              (by decide))
        rw [hs] at hv ⊢
        have hc2 := invsqrtAMinusD_sq
        have hcd : invsqrtAMinusD ≠ 0 := by
          rintro h; rw [h] at hc2; simp at hc2
        refine ⟨1 / invsqrtAMinusD, ?_⟩
        field_simp
        linear_combination hc2 - invsqrtAMinusD ^ 2 * hv
      · refine ⟨2 * s * (1 + s ^ 2) / x, ?_⟩
        field_simp
        linear_combination hvx
    have hok' : ok = true :=
      hok.2
        ⟨by
          rw [← hw]; exact mul_ne_zero hv0 (pow_ne_zero 2 hu2), hsq⟩
    have hI' := hI hok'
    rw [← hw] at hI'
    have hx' : ctAbs (2 * s * (I * (1 + s ^ 2))) = x := by
      rw [ctAbs_eq_of_sq_eq (b := x)
          (by linear_combination x ^ 2 * hI' - I ^ 2 * (1 + s ^ 2) ^ 2 * hvx),
        ctAbs_of_even hx]
    have hy' : (1 - s ^ 2) * (I * (I * (1 + s ^ 2)) * v) = y := by
      apply mul_right_cancel₀ hu2
      linear_combination (1 - s ^ 2) * hI' - hy
    rw [hx', hy', ite_eq_right_of_eq_false _ _ (eq_false ?_)]
    simp only [hok', Bool.true_eq_false, false_or, not_or]
    exact
      ⟨by
        unfold IsNeg; omega, hy0⟩

end Decode

section Decode2

/-- `decodeXY b` is `(x, y)` exactly for canonical even `b` and a curve point `Canon` for `s = b`. -/
public theorem decodeXY_eq_some {b : BitVec 256} {x y : ZMod p} :
    decodeXY b = some (x, y) ↔
      b.toNat < p ∧ b.toNat % 2 = 0 ∧ OnCurve x y ∧ Canon (b.toNat : ZMod p) x y := by
  unfold decodeXY
  split_ifs with h
  · simp only [false_iff]; omega
  · rw [decodeS_eq_some]; constructor
    · exact fun h' => ⟨by omega, by omega, h'⟩
    · exact fun h' => h'.2.2

/-- `decodeXY` accepts only curve points. -/
public theorem decodeXY_onCurve {b : BitVec 256} {xy : ZMod p × ZMod p} (h : decodeXY b = some xy) :
    OnCurve xy.1 xy.2 :=
  (decodeXY_eq_some.1 h).2.2.1

end Decode2

/-- RFC 9496 §4.3.1 decoding: the point `b` encodes, `none` where the RFC rejects. -/
@[expose]
public noncomputable def decode (b : BitVec 256) : Option Point :=
  match h : decodeXY b with
  | none => none
  | some xy => some ⟨xy.1, xy.2, decodeXY_onCurve h⟩

section Decode3

/-- Decoding gives `P` exactly when `b` is canonical and even and `Canon s P` holds. -/
public theorem decode_eq_some {b : BitVec 256} {P : Point} :
    decode b = some P ↔ b.toNat < p ∧ b.toNat % 2 = 0 ∧ Canon (b.toNat : ZMod p) P.x P.y := by
  have : decode b = some P ↔ decodeXY b = some (P.x, P.y) := by
    unfold decode
    split
    · next h => simp [h]
    · next xy h =>
        constructor
        · intro e
          cases e
          exact h
        · intro e
          rw [h, Option.some.injEq] at e
          subst e
          rfl
  rw [this, decodeXY_eq_some]
  exact ⟨fun h => ⟨h.1, h.2.1, h.2.2.2⟩, fun h => ⟨h.1, h.2.1, P.on, h.2.2⟩⟩

/-- `decode` fails exactly when `decodeXY` does. -/
public theorem decode_eq_none {b : BitVec 256} : decode b = none ↔ decodeXY b = none := by
  unfold decode
  split
  · next h => simp [h]
  · next h => simp [h]

/-- `Canon`'s `y` is never `-1`. -/
theorem Canon.one_add_ne {s x y : ZMod p} (h : Canon s x y) : 1 + y ≠ 0 := fun h0 => by
  have : (2 : ZMod p) = 0 := by linear_combination (1 + s ^ 2) * h0 - h.1
  exact two_ne this

/-- `Canon`'s `1 + s²` is nonzero. -/
theorem Canon.u2_ne {s x y : ZMod p} (h : Canon s x y) : 1 + s ^ 2 ≠ 0 := fun h0 => by
  have h1 := h.1
  rw [h0, mul_zero] at h1
  exact two_ne (by linear_combination h0 - h1)

/-- `Canon` points lie in `Dom`: `1 - y² = (2s/(1 + s²))²`. -/
theorem Canon.isSquare {s x y : ZMod p} (h : Canon s x y) : IsSquare (1 - y ^ 2) := by
  have hu := h.u2_ne
  refine ⟨2 * s / (1 + s ^ 2), ?_⟩
  have hy : y = (1 - s ^ 2) / (1 + s ^ 2) := by
    rw [eq_div_iff hu]; exact h.1
  rw [hy]; field_simp; ring

/-- `Canon s` fixes `s` up to sign, so an even `s`. -/
theorem Canon.s_unique {s s' x y : ZMod p} (h : Canon s x y) (h' : Canon s' x y)
    (hs : s.val % 2 = 0) (hs' : s'.val % 2 = 0) : s = s' := by
  have hy := h.one_add_ne
  refine eq_of_sq_eq (mul_left_cancel₀ hy ?_) hs hs'
  linear_combination h.1 - h'.1

/-- `Canon` points in one `E[4]`-coset are equal. -/
theorem Canon.unique {s s' : ZMod p} {Q Q' : Point} (h : Canon s Q.x Q.y) (h' : Canon s' Q'.x Q'.y)
    (hQ : Q - Q' ∈ E4) : Q = Q' := by
  -- the even `x y` (or `x`) of both rules out the other three coset members
  have hpar (e : Q.x * Q.y = -(Q'.x * Q'.y)) (h0 : Q'.x * Q'.y ≠ 0) : False := by
    have := h.2.2.1
    rw [e, val_neg_mod_two h0, h'.2.2.1] at this
    omega
  rcases mem_E4_iff_eq.1 hQ with e | e | e | e
  · exact sub_eq_zero.1 e
  · exfalso
    have hq : Q = Q' + T2 := by
      rw [← e]; abel
    obtain ⟨ex, ey⟩ := add_T2 Q'
    rw [← hq] at ex ey
    by_cases hx : Q'.x = 0
    · have hy : Q'.y = 1 := by
        rcases sq_eq_one_iff'.1 ((x_eq_zero_iff Q'.on).1 hx) with e | e
        · exact e
        · exact
            absurd
              (by
                rw [e]; ring)
              h'.one_add_ne
      exact
        h.one_add_ne
          (by
            rw [ey, hy]; ring)
    · have := h.2.1
      rw [ex, val_neg_mod_two hx, h'.2.1] at this
      omega
  · exfalso
    have hq : Q = Q' + T4 := by
      rw [← e]; abel
    obtain ⟨ex, ey⟩ := add_T4 Q'
    rw [← hq] at ex ey
    by_cases hx : Q'.x = 0
    · exact h.2.2.2 (by rw [ey, hx, zero_mul])
    · exact
        hpar
          (by
            rw [ex, ey]; linear_combination Q'.x * Q'.y * sqrtM1_sq)
          (mul_ne_zero hx h'.2.2.2)
  · exfalso
    have hq : Q = Q' - T4 := by
      rw [sub_eq_add_neg, ← e]; abel
    obtain ⟨ex, ey⟩ := sub_T4 Q'
    rw [← hq] at ex ey
    by_cases hx : Q'.x = 0
    · exact h.2.2.2 (by rw [ey, hx, zero_mul, neg_zero])
    · exact
        hpar
          (by
            rw [ex, ey]; linear_combination Q'.x * Q'.y * sqrtM1_sq)
          (mul_ne_zero hx h'.2.2.2)

/-- Decoded points lie in `Dom`. -/
public theorem decode_mem_Dom {b : BitVec 256} {P : Point} (h : decode b = some P) : P ∈ Dom :=
  (decode_eq_some.1 h).2.2.isSquare

end Decode3

/-! ## Encoding -/

section Encode

/-- The encoded `s` is nonnegative. -/
public theorem encodeExtS_even (x0 y0 z0 t0 : ZMod p) : (encodeExtS x0 y0 z0 t0).val % 2 = 0 :=
  ctAbs_even _

/-- On `Dom`, the encoded `s` is `Canon` for a point of `P`'s `E[4]`-coset. -/
public theorem encodeS_canon {P : Point} (hP : P ∈ Dom) :
    ∃ Q, Q - P ∈ E4 ∧ Canon (encodeExtS P.x P.y 1 (P.x * P.y)) Q.x Q.y := by
  rcases P with ⟨x, y, hc⟩
  obtain ⟨a, ha⟩ := mem_Dom.1 hP
  change 1 - y ^ 2 = a * a at ha
  dsimp only
  obtain ⟨hok, hI⟩ := sqrtRatioM1_one (w := (1 + y) * (1 - y) * (x * y) ^ 2)
  by_cases hxy : x * y = 0
  · have hP4 : (⟨x, y, hc⟩ : Point) ∈ E4 := mem_E4.2 (mul_eq_zero.1 hxy)
    have h0 : (sqrtRatioM1 1 ((1 + y) * (1 - y) * (x * y) ^ 2)).2 = 0 := by
      rw [hxy, show (1 + y) * (1 - y) * (0 : ZMod p) ^ 2 = 0 by ring, sqrtRatioM1_one_zero]
    unfold encodeExtS
    dsimp only
    rw [h0]
    simp only [zero_mul, ite_self]
    refine
      ⟨0, by
        rw [zero_sub]; exact E4.neg_mem hP4, ?_⟩
    rw [ctAbs_of_even (by simp)]
    refine ⟨by simp, by simp, by simp, by simp⟩
  have hx : x ≠ 0 := left_ne_zero_of_mul hxy
  have hy : y ≠ 0 := right_ne_zero_of_mul hxy
  have hy2 : (1 + y) * (1 - y) ≠ 0 := fun h0 =>
    hx ((x_eq_zero_iff hc).2 (by linear_combination -h0))
  have hI' :=
    hI
      (hok.2
        ⟨mul_ne_zero hy2 (pow_ne_zero 2 hxy),
          ⟨a * (x * y), by
            rw [show (1 + y) * (1 - y) = 1 - y ^ 2 by ring, ha]; ring⟩⟩)
  have hcur := hc
  unfold OnCurve at hcur
  have hc2 := invsqrtAMinusD_sq
  have hi := sqrtM1_sq
  unfold encodeExtS
  dsimp only
  generalize (sqrtRatioM1 1 ((1 + y) * (1 - y) * (x * y) ^ 2)).2 = I at hI' ⊢
  have hz : I * ((1 + y) * (1 - y)) * (I * (x * y)) * (x * y) = 1 := by linear_combination hI'
  rw [hz]
  simp only [mul_one]
  set P : Point := ⟨x, y, hc⟩ with hPdef
  have hPx : P.x = x := rfl
  have hPy : P.y = y := rfl
  have hi0 : sqrtM1 ≠ 0 := fun h0 => by
    rw [h0] at hi; exact absurd hi (by decide)
  split_ifs with hr hn hn
  · -- rotated, `-√-1 y`: the point `P - T4`
    obtain ⟨ex, ey⟩ := sub_T4 P
    refine
      ⟨P - T4, by
        rw [sub_sub_cancel_left]; exact E4.neg_mem (mem_E4.2 (.inr rfl)), ?_, ?_, ?_, ?_⟩
    · rw [ey, hPx, ctAbs_sq]
      linear_combination
        (x * sqrtM1 + 1) * hI' +
          (-x ^ 3 * y ^ 4 * I ^ 2 * sqrtM1 - x ^ 2 * y ^ 4 * I ^ 2 +
              x ^ 3 * y ^ 2 * I ^ 2 * sqrtM1 +
              x ^ 2 * y ^ 2 * I ^ 2) *
            hc2 +
          (x * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 + y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 -
              x * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
              I ^ 2 * invsqrtAMinusD ^ 2) *
            hcur +
          (-x ^ 3 * y ^ 4 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
                  x ^ 2 * y ^ 4 * I ^ 2 * invsqrtAMinusD ^ 2 +
                2 * x ^ 3 * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 +
                2 * x ^ 2 * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 -
              x ^ 3 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
              x ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2) *
            hi
    · rw [ex, hPy, val_neg_mod_two (mul_ne_zero hy hi0)]; unfold IsNeg at hn; omega
    · rw [ex, ey, hPx, hPy,
        show -(y * sqrtM1) * -(x * sqrtM1) = -(x * y) by linear_combination x * y * hi,
        val_neg_mod_two hxy]
      unfold IsNeg at hr; omega
    · rw [ey, hPx]; exact neg_ne_zero.2 (mul_ne_zero hx hi0)
  · -- rotated: the point `P + T4`
    obtain ⟨ex, ey⟩ := add_T4 P
    refine
      ⟨P + T4, by
        rw [add_sub_cancel_left]; exact mem_E4.2 (.inr rfl), ?_, ?_, ?_, ?_⟩
    · rw [ey, hPx, ctAbs_sq]
      linear_combination
        (-x * sqrtM1 + 1) * hI' +
          (x ^ 3 * y ^ 4 * I ^ 2 * sqrtM1 - x ^ 2 * y ^ 4 * I ^ 2 - x ^ 3 * y ^ 2 * I ^ 2 * sqrtM1 +
              x ^ 2 * y ^ 2 * I ^ 2) *
            hc2 +
          (-x * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 + y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 +
                x * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
              I ^ 2 * invsqrtAMinusD ^ 2) *
            hcur +
          (x ^ 3 * y ^ 4 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
                  x ^ 2 * y ^ 4 * I ^ 2 * invsqrtAMinusD ^ 2 -
                  2 * x ^ 3 * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 +
                2 * x ^ 2 * y ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2 +
                x ^ 3 * I ^ 2 * invsqrtAMinusD ^ 2 * sqrtM1 -
              x ^ 2 * I ^ 2 * invsqrtAMinusD ^ 2) *
            hi
    · rw [ex, hPy]; unfold IsNeg at hn; omega
    · rw [ex, ey, hPx, hPy,
        show y * sqrtM1 * (x * sqrtM1) = -(x * y) by linear_combination x * y * hi,
        val_neg_mod_two hxy]
      unfold IsNeg at hr; omega
    · rw [ey, hPx]; exact mul_ne_zero hx hi0
  · -- `x` negative: the point `P + T2`
    obtain ⟨ex, ey⟩ := add_T2 P
    refine
      ⟨P + T2, by
        rw [add_sub_cancel_left]; exact mem_E4.2 (.inl rfl), ?_, ?_, ?_, ?_⟩
    · rw [ey, hPy, ctAbs_sq]
      linear_combination (1 + y) * hI'
    · rw [ex, hPx, val_neg_mod_two hx]; unfold IsNeg at hn; omega
    · rw [ex, ey, hPx, hPy, neg_mul_neg]; unfold IsNeg at hr; omega
    · rw [ey, hPy]; exact neg_ne_zero.2 hy
  · refine
      ⟨P, by
        rw [sub_self]; exact E4.zero_mem, ?_, ?_, ?_, hy⟩
    · rw [hPy, ctAbs_sq]
      linear_combination (1 - y) * hI'
    · rw [hPx]; unfold IsNeg at hn; omega
    · rw [hPx, hPy]; unfold IsNeg at hr; omega

end Encode

/-! ## Decoding and encoding are inverse modulo `E4` -/

section Main

/-- `encode P` holds the canonical value of `P`'s encoded `s`. -/
public theorem toNat_encode (P : Point) :
    (encode P).toNat = (encodeExtS P.x P.y 1 (P.x * P.y)).val := by
  unfold encode encodeExt
  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ((ZMod.val_lt _).trans (by decide))]

/-- On `Dom`, encoding is constant on `E[4]`-cosets. -/
public theorem encode_add_E4 {P T : Point} (hP : P ∈ Dom) (hT : T ∈ E4) :
    encode (P + T) = encode P := by
  obtain ⟨Q₁, h₁, c₁⟩ := encodeS_canon hP
  obtain ⟨Q₂, h₂, c₂⟩ := encodeS_canon (Dom.add_mem hP (E4_le_Dom hT))
  have hQ : Q₂ = Q₁ :=
    c₂.unique c₁
      (by
        have := E4.sub_mem (E4.add_mem h₂ hT) h₁
        convert this using 1; abel)
  rw [hQ] at c₂
  unfold encode encodeExt
  rw [c₂.s_unique c₁ (encodeExtS_even ..) (encodeExtS_even ..)]

/-- On `Dom`, decoding the encoding succeeds, with a point of the same `E[4]`-coset. -/
public theorem decode_encode {P : Point} (hP : P ∈ Dom) :
    ∃ Q, decode (encode P) = some Q ∧ Q - P ∈ E4 := by
  obtain ⟨Q, hQ, c⟩ := encodeS_canon hP
  refine ⟨Q, decode_eq_some.2 ⟨?_, ?_, ?_⟩, hQ⟩ <;> rw [toNat_encode]
  · exact ZMod.val_lt _
  · exact encodeExtS_even ..
  · rw [ZMod.natCast_zmod_val]; exact c

/-- Encoding a decoded point gives back the bytes. -/
public theorem encode_decode {b : BitVec 256} {P : Point} (h : decode b = some P) :
    encode P = b := by
  obtain ⟨hb, he, c⟩ := decode_eq_some.1 h
  obtain ⟨Q, hQ, c'⟩ := encodeS_canon (decode_mem_Dom h)
  have hQP := c'.unique c hQ
  subst hQP
  have hs :=
    c'.s_unique c (encodeExtS_even ..)
      (by
        rw [ZMod.val_natCast, Nat.mod_eq_of_lt hb]; exact he)
  apply BitVec.eq_of_toNat_eq
  rw [toNat_encode, hs, ZMod.val_natCast, Nat.mod_eq_of_lt hb]

/-- Decoding succeeds exactly on the encodings of points of `Dom`. -/
public theorem decode_isSome_iff {b : BitVec 256} :
    (decode b).isSome ↔ ∃ P ∈ Dom, encode P = b := by
  constructor
  · intro h
    obtain ⟨P, hP⟩ := Option.isSome_iff_exists.1 h
    exact ⟨P, decode_mem_Dom hP, encode_decode hP⟩
  · rintro ⟨P, hP, rfl⟩
    obtain ⟨Q, hQ, -⟩ := decode_encode hP
    rw [hQ]; rfl

/-- On `Dom`, two points encode alike exactly when they differ by `E[4]`. -/
public theorem encode_eq_encode_iff {P Q : Point} (hP : P ∈ Dom) (hQ : Q ∈ Dom) :
    encode P = encode Q ↔ P - Q ∈ E4 := by
  constructor
  · intro h
    obtain ⟨P', hP', eP⟩ := decode_encode hP
    obtain ⟨Q', hQ', eQ⟩ := decode_encode hQ
    rw [h, hQ', Option.some.injEq] at hP'
    subst hP'
    have := E4.sub_mem eQ eP
    convert this using 1; abel
  · intro h
    have := encode_add_E4 hQ h
    rwa [show Q + (P - Q) = P by abel] at this

/-- The identity encodes to zero bytes. -/
public theorem encode_zero : encode 0 = 0 :=
  encode_decode (decode_eq_some.2 ⟨by decide, by decide, by simp [Canon]⟩)

/-- Encoding on `Dom / E[4]`. -/
@[expose]
public noncomputable def encodeQ :
    Dom ⧸ E4.addSubgroupOf Dom → { b : BitVec 256 // (decode b).isSome } :=
  Quotient.lift (fun P => ⟨encode P, decode_isSome_iff.2 ⟨P, P.2, rfl⟩⟩)
    (by
      intro P Q h
      have h' : -P + Q ∈ E4.addSubgroupOf Dom := QuotientAddGroup.leftRel_apply.1 h
      rw [AddSubgroup.mem_addSubgroupOf] at h'
      refine Subtype.ext ((encode_eq_encode_iff Q.2 P.2).2 ?_).symm
      convert h' using 1; push_cast; abel)

/-- The point accepted bytes decode to. -/
@[expose]
public noncomputable def decodeDom (b : { b : BitVec 256 // (decode b).isSome }) : Dom :=
  ⟨(decode b.1).get b.2, decode_mem_Dom (Option.some_get _).symm⟩

/-- `decodeDom b` is `b`'s decoding. -/
public theorem decode_decodeDom (b : { b : BitVec 256 // (decode b).isSome }) :
    decode b.1 = some (decodeDom b : Point) :=
  (Option.some_get _).symm

/-- Encoding is a bijection from `Dom / E[4]` onto the bytes decoding accepts; decoding is its
inverse. -/
@[expose]
public noncomputable def quotientEquiv :
    Dom ⧸ E4.addSubgroupOf Dom ≃ { b : BitVec 256 // (decode b).isSome } where
  toFun := encodeQ
  invFun b := QuotientAddGroup.mk (decodeDom b)
  left_inv q := by
    induction q using QuotientAddGroup.induction_on with
    | H P =>
      obtain ⟨Q, hQ, hQP⟩ := decode_encode P.2
      have h1 : (encodeQ (P : Dom ⧸ E4.addSubgroupOf Dom)).1 = encode P := rfl
      change QuotientAddGroup.mk (decodeDom (encodeQ (P : Dom ⧸ E4.addSubgroupOf Dom))) = _
      generalize encodeQ (P : Dom ⧸ E4.addSubgroupOf Dom) = b at h1 ⊢
      have h2 := decode_decodeDom b
      rw [h1, hQ, Option.some.injEq] at h2
      rw [QuotientAddGroup.eq, AddSubgroup.mem_addSubgroupOf]
      convert E4.neg_mem hQP using 1
      push_cast
      rw [← h2]
      abel
  right_inv b := Subtype.ext (encode_decode (decode_decodeDom b))

/-- `quotientEquiv` sends a coset to the encoding of any representative. -/
public theorem quotientEquiv_mk (P : Dom) :
    (quotientEquiv (P : Dom ⧸ E4.addSubgroupOf Dom)).1 = encode P :=
  rfl

/-- `quotientEquiv`'s inverse decodes. -/
public theorem quotientEquiv_symm (b : { b : BitVec 256 // (decode b).isSome }) :
    ∃ P : Dom, decode b.1 = some P ∧ quotientEquiv.symm b = P :=
  ⟨decodeDom b, decode_decodeDom b, rfl⟩

end Main

/-! ## Projective invariance of the encoding -/

section Scale

/-- Equal squares differ by a sign. -/
theorem exists_sign {X Y : ZMod p} (h : X ^ 2 = Y ^ 2) : ∃ ε : ZMod p, ε ^ 2 = 1 ∧ X = ε * Y := by
  by_cases hY : Y = 0
  · subst hY
    exact
      ⟨1, by ring,
        pow_eq_zero_iff (n := 2) (by norm_num) |>.1
          (by
            rw [h]; ring)⟩
  · refine ⟨X / Y, ?_, by field_simp⟩
    rw [div_pow, h, div_self (pow_ne_zero 2 hY)]

/-- `√(a/l²) = ±√a / l`. -/
theorem nnSqrt_div_sq {a l : ZMod p} (hl : l ≠ 0) :
    ∃ ε : ZMod p, ε ^ 2 = 1 ∧ nnSqrt (a / l ^ 2) * l = ε * nnSqrt a := by
  by_cases h : IsSquare a
  · have h' : IsSquare (a / l ^ 2) := by
      obtain ⟨r, hr⟩ := h
      exact
        ⟨r / l, by
          rw [hr]; ring⟩
    refine exists_sign ?_
    rw [mul_pow, nnSqrt_sq h', nnSqrt_sq h, div_mul_cancel₀ _ (pow_ne_zero 2 hl)]
  · have h' : ¬IsSquare (a / l ^ 2) := fun ⟨r, hr⟩ =>
      h
        ⟨r * l, by
          rw [show a = a / l ^ 2 * l ^ 2 by field_simp, hr]; ring⟩
    exact
      ⟨1, by ring, by
        rw [nnSqrt_of_not h, nnSqrt_of_not h']; ring⟩

/-- `SQRT_RATIO_M1(1, l² w)`'s root is `±` that of `(1, w)` over `l`. -/
theorem sqrtRatioM1_one_scale {w l : ZMod p} (hl : l ≠ 0) :
    ∃ ε : ZMod p, ε ^ 2 = 1 ∧ (sqrtRatioM1 1 (l ^ 2 * w)).2 * l = ε * (sqrtRatioM1 1 w).2 := by
  have hC :
    (1 : ZMod p) = 0 ∨ (l ^ 2 * w ≠ 0 ∧ IsSquare (1 / (l ^ 2 * w))) ↔
      (1 : ZMod p) = 0 ∨ (w ≠ 0 ∧ IsSquare (1 / w)) := by
    have e : 1 / (l ^ 2 * w) = 1 / w / l ^ 2 := by rw [div_div, mul_comm]
    rw [e]
    constructor
    · rintro (h | ⟨h1, ⟨r, hr⟩⟩)
      · exact .inl h
      · refine .inr ⟨right_ne_zero_of_mul h1, r * l, ?_⟩
        rw [show 1 / w = 1 / w / l ^ 2 * l ^ 2 by field_simp, hr]; ring
    · rintro (h | ⟨h1, ⟨r, hr⟩⟩)
      · exact .inl h
      · exact
          .inr
            ⟨mul_ne_zero (pow_ne_zero 2 hl) h1, r / l, by
              rw [hr]; ring⟩
  unfold sqrtRatioM1
  by_cases h : (1 : ZMod p) = 0 ∨ (w ≠ 0 ∧ IsSquare (1 / w))
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (hC.2 h)), ite_eq_left_of_eq_true _ _ (eq_true h),
      show 1 / (l ^ 2 * w) = 1 / w / l ^ 2 by rw [div_div, mul_comm]]
    exact nnSqrt_div_sq hl
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (mt hC.1 h)),
      ite_eq_right_of_eq_false _ _ (eq_false h),
      show sqrtM1 * 1 / (l ^ 2 * w) = sqrtM1 * 1 / w / l ^ 2 by rw [div_div, mul_comm (l ^ 2)]]
    exact nnSqrt_div_sq hl

/-- `encodeExtS` after its inverse square root. -/
def encodeTail (x0 y0 z0 t0 den1 den2 z_inv : ZMod p) : ZMod p :=
  let ix0 := x0 * sqrtM1
  let iy0 := y0 * sqrtM1
  let enchanted_denominator := den1 * invsqrtAMinusD
  let rotate := IsNeg (t0 * z_inv)
  let x := if rotate then iy0 else x0
  let y := if rotate then ix0 else y0
  let den_inv := if rotate then enchanted_denominator else den2
  let y := if IsNeg (x * z_inv) then -y else y
  ctAbs (den_inv * (z0 - y))

theorem encodeExtS_eq_tail (x0 y0 z0 t0 : ZMod p) :
    encodeExtS x0 y0 z0 t0 =
      encodeTail x0 y0 z0 t0
        ((sqrtRatioM1 1 ((z0 + y0) * (z0 - y0) * (x0 * y0) ^ 2)).2 * ((z0 + y0) * (z0 - y0)))
        ((sqrtRatioM1 1 ((z0 + y0) * (z0 - y0) * (x0 * y0) ^ 2)).2 * (x0 * y0))
        ((sqrtRatioM1 1 ((z0 + y0) * (z0 - y0) * (x0 * y0) ^ 2)).2 * ((z0 + y0) * (z0 - y0)) *
          ((sqrtRatioM1 1 ((z0 + y0) * (z0 - y0) * (x0 * y0) ^ 2)).2 * (x0 * y0)) *
          t0) :=
  rfl

/-- `CT_ABS` ignores a sign. -/
theorem ctAbs_sign {ε u v : ZMod p} (hε : ε ^ 2 = 1) (h : u = ε * v) : ctAbs u = ctAbs v :=
  ctAbs_eq_of_sq_eq (by rw [h, mul_pow, hε, one_mul])

/-- The tail is invariant under scaling by `Z` with the denominators scaled by `±1/Z`. -/
theorem encodeTail_scale {x y t Z ε den1 den2 zi : ZMod p} (hZ : Z ≠ 0) (hε : ε ^ 2 = 1) :
    encodeTail (x * Z) (y * Z) Z (t * Z) (ε * den1 / Z) (ε * den2 / Z) (zi / Z) =
      encodeTail x y 1 t den1 den2 zi := by
  unfold encodeTail
  dsimp only
  have e1 : t * Z * (zi / Z) = t * zi := by field_simp
  have e2 : y * Z * sqrtM1 * (zi / Z) = y * sqrtM1 * zi := by field_simp
  have e3 : x * Z * (zi / Z) = x * zi := by field_simp
  rw [e1]
  by_cases hr : IsNeg (t * zi)
  · simp only [hr, ↓reduceIte, e2]
    by_cases hn : IsNeg (y * sqrtM1 * zi)
    · simp only [hn, ↓reduceIte]
      exact ctAbs_sign hε (by field_simp)
    · simp only [hn, ↓reduceIte]
      exact ctAbs_sign hε (by field_simp)
  · simp only [hr, ↓reduceIte, e3]
    by_cases hn : IsNeg (x * zi)
    · simp only [hn, ↓reduceIte]
      exact ctAbs_sign hε (by field_simp)
    · simp only [hn, ↓reduceIte]
      exact ctAbs_sign hε (by field_simp)

/-- The encoding of `(x Z : y Z : Z : x y Z)` is that of `(x : y : 1 : x y)`. -/
public theorem encodeExtS_scale {x y Z : ZMod p} (hZ : Z ≠ 0) :
    encodeExtS (x * Z) (y * Z) Z (x * y * Z) = encodeExtS x y 1 (x * y) := by
  rw [encodeExtS_eq_tail, encodeExtS_eq_tail,
    show
      (Z + y * Z) * (Z - y * Z) * (x * Z * (y * Z)) ^ 2 =
        (Z ^ 3) ^ 2 * ((1 + y) * (1 - y) * (x * y) ^ 2)
      by ring]
  obtain ⟨ε, hε, hI⟩ :=
    sqrtRatioM1_one_scale (w := (1 + y) * (1 - y) * (x * y) ^ 2) (pow_ne_zero 3 hZ)
  generalize (sqrtRatioM1 1 ((Z ^ 3) ^ 2 * ((1 + y) * (1 - y) * (x * y) ^ 2))).2 = I' at hI ⊢
  generalize (sqrtRatioM1 1 ((1 + y) * (1 - y) * (x * y) ^ 2)).2 = I at hI ⊢
  have hI' : I' = ε * I / Z ^ 3 := eq_div_of_mul_eq (pow_ne_zero 3 hZ) hI
  subst hI'
  rw [← encodeTail_scale hZ hε (x := x) (y := y) (t := x * y) (ε := ε)]
  congr 1
  · field_simp
  · field_simp
  · field_simp; linear_combination (I ^ 2 * (1 + y) * (1 - y) * (x * y) ^ 2) * hε

end Scale

/-! ## Well-definedness on cosets -/

section Congr

/-- On `Dom`, a point of `P`'s `E[4]`-coset encodes as `P`. -/
public theorem encode_congr {P P' : Point} (hP : P ∈ Dom) (h : P' - P ∈ E4) :
    Ristretto.encode P' = Ristretto.encode P := by
  have := encode_add_E4 hP h
  rwa [show P + (P' - P) = P' by abel] at this

/-- A point of `Dom` encoding to accepted bytes differs from their decoding by `E[4]`. -/
public theorem sub_decode_mem {P Q : Point} {b : BitVec 256} (hP : P ∈ Dom)
    (hb : Ristretto.decode b = some Q) (e : Ristretto.encode P = b) : P - Q ∈ E4 :=
  (encode_eq_encode_iff hP (decode_mem_Dom hb)).1 (e.trans (encode_decode hb).symm)

/-- Termwise `E[4]` differences give an `E[4]` difference of the linear combinations. -/
public theorem sum_sub_mem_E4 {n : ℕ} (s : ℕ → ℕ) {P P' : ℕ → Point}
    (h : ∀ j < n, P' j - P j ∈ E4) :
    (∑ j ∈ Finset.range n, s j • P' j) - ∑ j ∈ Finset.range n, s j • P j ∈ E4 := by
  rw [← Finset.sum_sub_distrib]
  refine AddSubgroup.sum_mem _ fun j hj => ?_
  rw [← nsmul_sub]
  exact AddSubgroup.nsmul_mem _ (h j (Finset.mem_range.1 hj)) _

/-- Linear combinations of points of `Dom` lie in `Dom`. -/
public theorem sum_mem_Dom {n : ℕ} (s : ℕ → ℕ) {P : ℕ → Point} (h : ∀ j < n, P j ∈ Dom) :
    ∑ j ∈ Finset.range n, s j • P j ∈ Dom :=
  AddSubgroup.sum_mem _ fun j hj => AddSubgroup.nsmul_mem _ (h j (Finset.mem_range.1 hj)) _

end Congr

end Ed25519.Ristretto

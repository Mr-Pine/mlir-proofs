module

public import Ed25519.Ext
public import Ed25519.Group
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.Ring

/-! Dalek's point forms over `ZMod p`, besides `Ed25519.IsExt`'s extended one: projective,
completed, (affine) Niels and the AVX2 cached form; their conversions, and the doubling,
addition and subtraction formulas of the serial and AVX2 backends. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `(X : Y : Z)` are projective coordinates of `(x, y)` (`ProjectivePoint`). -/
def IsProj (x y X Y Z : ZMod p) : Prop :=
  Z ≠ 0 ∧ X = x * Z ∧ Y = y * Z

/-- `((X : Z), (Y : T))` are completed coordinates of `(x, y)` (`CompletedPoint`): `x = X / Z`,
`y = Y / T`. -/
def IsCompleted (x y X Y Z T : ZMod p) : Prop :=
  Z ≠ 0 ∧ T ≠ 0 ∧ X = x * Z ∧ Y = y * T

/-- `(Y + X, Y - X, Z, 2d T)` for extended coordinates of `(x, y)` (`ProjectiveNielsPoint`). -/
def IsNiels (x y YpX YmX Z T2d : ZMod p) : Prop :=
  Z ≠ 0 ∧ YpX = (y + x) * Z ∧ YmX = (y - x) * Z ∧ T2d = 2 * d * x * y * Z

/-- `(y + x, y - x, 2d x y)` (`AffineNielsPoint`): Niels with `Z = 1`. -/
abbrev IsAffineNiels (x y ypx ymx xy2d : ZMod p) : Prop :=
  IsNiels x y ypx ymx 1 xy2d

/-- The AVX2 `CachedPoint` lanes `(Y - X, Y + X, 2 Z, 2d T)` for extended coordinates of `(x, y)`;
`CachedPoint::from` scales them by `121666`, absorbed in `Z`. -/
def IsCached (x y a b c e : ZMod p) : Prop :=
  ∃ Z, Z ≠ 0 ∧ a = (y - x) * Z ∧ b = (y + x) * Z ∧ c = 2 * Z ∧ e = 2 * d * x * y * Z

end

/-! ## Conversions -/

section Conversions

variable {x y X Y Z T : ZMod p}

public theorem d_mul_121666 : d * 121666 = -121665 := by
  unfold d
  reduce_mod_char

/-- Extended coordinates with their components rewritten. -/
public theorem IsExt.congr {X' Y' T' Z' : ZMod p} (h : IsExt x y X Y T Z) (hX : X = X')
    (hY : Y = Y') (hT : T = T') (hZ : Z = Z') : IsExt x y X' Y' T' Z' := by
  subst hX hY hT hZ; exact h

/-- `T = x y Z`. -/
public theorem IsExt.t_eq (h : IsExt x y X Y T Z) : T = x * y * Z := by
  obtain ⟨hZ, rfl, rfl, hT⟩ := h
  exact
    mul_right_cancel₀ hZ
      (by
        rw [hT]; ring)

/-- `EdwardsPoint::as_projective`. -/
public theorem IsExt.isProj (h : IsExt x y X Y T Z) : IsProj x y X Y Z :=
  ⟨h.1, h.2.1, h.2.2.1⟩

/-- `ProjectivePoint::as_extended`. -/
public theorem IsProj.isExt (h : IsProj x y X Y Z) : IsExt x y (X * Z) (Y * Z) (X * Y) (Z ^ 2) := by
  obtain ⟨hZ, rfl, rfl⟩ := h
  exact ⟨pow_ne_zero 2 hZ, by ring, by ring, by ring⟩

/-- `CompletedPoint::as_projective`. -/
public theorem IsCompleted.isProj (h : IsCompleted x y X Y Z T) :
    IsProj x y (X * T) (Y * Z) (Z * T) := by
  obtain ⟨hZ, hT, rfl, rfl⟩ := h
  exact ⟨mul_ne_zero hZ hT, by ring, by ring⟩

/-- `CompletedPoint::as_extended`. -/
public theorem IsCompleted.isExt (h : IsCompleted x y X Y Z T) :
    IsExt x y (X * T) (Y * Z) (X * Y) (Z * T) := by
  obtain ⟨hZ, hT, rfl, rfl⟩ := h
  exact ⟨mul_ne_zero hZ hT, by ring, by ring, by ring⟩

/-- `EdwardsPoint::as_projective_niels`. -/
public theorem IsExt.isNiels (h : IsExt x y X Y T Z) :
    IsNiels x y (Y + X) (Y - X) Z (T * (2 * d)) := by
  rw [IsExt.t_eq h]
  obtain ⟨hZ, rfl, rfl, -⟩ := h
  exact ⟨hZ, by ring, by ring, by ring⟩

/-- `EdwardsPoint::as_affine_niels`, for `Z⁻¹` the inverse of `Z`. -/
public theorem IsExt.isAffineNiels (h : IsExt x y X Y T Z) {R : ZMod p} (hR : Z * R = 1) :
    IsAffineNiels x y (Y * R + X * R) (Y * R - X * R) (X * R * (Y * R) * (2 * d)) := by
  obtain ⟨hZ, rfl, rfl, -⟩ := h
  have hx : x * Z * R = x := by rw [mul_assoc, hR, mul_one]
  have hy : y * Z * R = y := by rw [mul_assoc, hR, mul_one]
  rw [hx, hy]
  exact ⟨one_ne_zero, by ring, by ring, by ring⟩

/-- Niels coordinates as extended ones. -/
public theorem IsNiels.isExt {YpX YmX T2d : ZMod p} (h : IsNiels x y YpX YmX Z T2d) :
    IsExt x y (x * Z) (y * Z) (x * y * Z) Z :=
  ⟨h.1, rfl, rfl, by ring⟩

/-- `ProjectiveNielsPoint`'s and `AffineNielsPoint`'s negation. -/
public theorem IsNiels.neg {YpX YmX T2d : ZMod p} (h : IsNiels x y YpX YmX Z T2d) :
    IsNiels (-x) y YmX YpX Z (-T2d) := by
  obtain ⟨hZ, rfl, rfl, rfl⟩ := h
  exact ⟨hZ, by ring, by ring, by ring⟩

/-- `CachedPoint::from`: `(121666 (Y - X), 121666 (Y + X), 2 · 121666 Z, -2 · 121665 T)`. -/
public theorem IsExt.isCached (h : IsExt x y X Y T Z) :
    IsCached x y ((Y - X) * 121666) ((Y + X) * 121666) (Z * (2 * 121666))
      (-(T * (2 * 121665))) := by
  rw [IsExt.t_eq h]
  obtain ⟨hZ, rfl, rfl, -⟩ := h
  refine ⟨Z * 121666, mul_ne_zero hZ (by decide), by ring, by ring, by ring, ?_⟩
  linear_combination (-2 * x * y * Z) * d_mul_121666

/-- `CachedPoint`'s negation: `A` and `B` swapped, `D` negated. -/
public theorem IsCached.neg {a b c e : ZMod p} (h : IsCached x y a b c e) :
    IsCached (-x) y b a c (-e) := by
  obtain ⟨Z, hZ, rfl, rfl, rfl, rfl⟩ := h
  exact ⟨Z, hZ, by ring, by ring, rfl, by ring⟩

/-- Cached coordinates as extended ones. -/
public theorem IsCached.isExt {a b c e : ZMod p} (h : IsCached x y a b c e) :
    ∃ Z',
      IsExt x y (x * Z') (y * Z') (x * y * Z') Z' ∧
        a = y * Z' - x * Z' ∧ b = y * Z' + x * Z' ∧ c = Z' + Z' ∧ e = x * y * Z' * (2 * d) := by
  obtain ⟨Z, hZ, rfl, rfl, rfl, rfl⟩ := h
  exact ⟨Z, ⟨hZ, rfl, rfl, by ring⟩, by ring, by ring, by ring, by ring⟩

end Conversions

/-! ## Doubling -/

section Doubling

variable {x y X Y Z : ZMod p}

/-- `ProjectivePoint::double`: `((X + Y)² - (Y² + X²) : Y² - X², Y² + X² : 2 Z² - (Y² - X²))`. -/
public theorem isCompleted_dbl (h : IsProj x y X Y Z) (hc : OnCurve x y) :
    IsCompleted (dbl x y).1 (dbl x y).2 ((X + Y) ^ 2 - (Y ^ 2 + X ^ 2)) (Y ^ 2 + X ^ 2)
      (Y ^ 2 - X ^ 2) (2 * Z ^ 2 - (Y ^ 2 - X ^ 2)) := by
  obtain ⟨hZ, rfl, rfl⟩ := h
  have d₁ := dbl_den₁ hc
  have d₂ := dbl_den₂ hc
  have hz2 : Z ^ 2 ≠ 0 := pow_ne_zero 2 hZ
  refine ⟨?_, ?_, ?_, ?_⟩
  · have : (y * Z) ^ 2 - (x * Z) ^ 2 = Z ^ 2 * (y ^ 2 - x ^ 2) := by ring
    rw [this]; exact mul_ne_zero hz2 d₁
  · have : 2 * Z ^ 2 - ((y * Z) ^ 2 - (x * Z) ^ 2) = Z ^ 2 * (2 - y ^ 2 + x ^ 2) := by ring
    rw [this]; exact mul_ne_zero hz2 d₂
  · simp only [dbl]
    rw [div_mul_eq_mul_div, eq_div_iff d₁]
    ring
  · simp only [dbl]
    rw [div_mul_eq_mul_div, eq_div_iff d₂]
    ring

/-- `ExtendedPoint::double` (AVX2): for `S₁ … S₄ = X², Y², Z², (X + Y)²`, `S₅ = S₁ + S₂`,
`S₆ = S₁ - S₂`, `S₈ = S₆ + 2 S₃`, `S₉ = S₅ - S₄`, the double is
`(S₈ S₉ : S₅ S₆ : S₅ S₉ : S₈ S₆)`. -/
public theorem isExt_dbl_avx2 (h : IsProj x y X Y Z) (hc : OnCurve x y) :
    let S₅ := X ^ 2 + Y ^ 2
    let S₆ := X ^ 2 - Y ^ 2
    let S₈ := X ^ 2 - Y ^ 2 + 2 * Z ^ 2
    let S₉ := X ^ 2 + Y ^ 2 - (X + Y) ^ 2
    IsExt (dbl x y).1 (dbl x y).2 (S₈ * S₉) (S₅ * S₆) (S₅ * S₉) (S₈ * S₆) := by
  intro S₅ S₆ S₈ S₉
  exact IsExt.congr (isExt_dbl h.1 h.2.1 h.2.2 hc) (by ring) (by ring) (by ring) (by ring)

end Doubling

/-! ## Addition -/

section Addition

variable {x₁ y₁ x₂ y₂ X Y T Z : ZMod p}

/-- `EdwardsPoint + ProjectiveNielsPoint`: for `PP = (Y + X) YpX`, `MM = (Y - X) YmX`,
`TT2d = T T2d`, `ZZ2 = Z Z₂ + Z Z₂`, the sum is `(PP - MM : ZZ2 + TT2d, PP + MM : ZZ2 - TT2d)`. -/
public theorem isCompleted_add_niels {YpX YmX Z₂ T2d : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsNiels x₂ y₂ YpX YmX Z₂ T2d) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ x₂ y₂
    IsCompleted Q.1 Q.2 ((Y + X) * YpX - (Y - X) * YmX) ((Y + X) * YpX + (Y - X) * YmX)
      (Z * Z₂ + Z * Z₂ + T * T2d) (Z * Z₂ + Z * Z₂ - T * T2d) := by
  obtain ⟨h₁, h₂, h₃, h₄⟩ := add_compl hP hQ.isExt h1 h2
  obtain ⟨-, rfl, rfl, rfl⟩ := hQ
  have e₅ : (Y - X) * ((y₂ - x₂) * Z₂) = (Y - X) * (y₂ * Z₂ - x₂ * Z₂) := by ring
  have e₆ : (Y + X) * ((y₂ + x₂) * Z₂) = (Y + X) * (y₂ * Z₂ + x₂ * Z₂) := by ring
  have e₇ : T * (2 * d * x₂ * y₂ * Z₂) = T * (x₂ * y₂ * Z₂) * (2 * d) := by ring
  have e₈ : Z * Z₂ + Z * Z₂ = (Z + Z) * Z₂ := by ring
  rw [e₅, e₆, e₇, e₈]
  exact ⟨h₁, h₂, h₃, h₄⟩

/-- `EdwardsPoint - ProjectiveNielsPoint`: for `PM = (Y + X) YmX`, `MP = (Y - X) YpX`, the
difference is `(PM - MP : ZZ2 - TT2d, PM + MP : ZZ2 + TT2d)`. -/
public theorem isCompleted_sub_niels {YpX YmX Z₂ T2d : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsNiels x₂ y₂ YpX YmX Z₂ T2d) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ (-x₂) y₂
    IsCompleted Q.1 Q.2 ((Y + X) * YmX - (Y - X) * YpX) ((Y + X) * YmX + (Y - X) * YpX)
      (Z * Z₂ + Z * Z₂ - T * T2d) (Z * Z₂ + Z * Z₂ + T * T2d) := by
  have h := isCompleted_add_niels hP hQ.neg h1 h2.neg
  rwa [mul_neg, ← sub_eq_add_neg, sub_neg_eq_add] at h

/-- `EdwardsPoint + AffineNielsPoint`: `ProjectiveNielsPoint`'s with `Z₂ = 1`, `Z2 = Z + Z`. -/
public theorem isCompleted_add_affineNiels {ypx ymx xy2d : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsAffineNiels x₂ y₂ ypx ymx xy2d) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ x₂ y₂
    IsCompleted Q.1 Q.2 ((Y + X) * ypx - (Y - X) * ymx) ((Y + X) * ypx + (Y - X) * ymx)
      (Z + Z + T * xy2d) (Z + Z - T * xy2d) := by
  have h := isCompleted_add_niels hP hQ h1 h2
  rwa [mul_one] at h

/-- `EdwardsPoint - AffineNielsPoint`. -/
public theorem isCompleted_sub_affineNiels {ypx ymx xy2d : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsAffineNiels x₂ y₂ ypx ymx xy2d) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ (-x₂) y₂
    IsCompleted Q.1 Q.2 ((Y + X) * ymx - (Y - X) * ypx) ((Y + X) * ymx + (Y - X) * ypx)
      (Z + Z - T * xy2d) (Z + Z + T * xy2d) := by
  have h := isCompleted_sub_niels hP hQ h1 h2
  rwa [mul_one] at h

/-- `ExtendedPoint + CachedPoint` (AVX2): for `S₈ = (Y - X) a`, `S₉ = (Y + X) b`, `S₁₀ = Z c`,
`S₁₁ = T e` and `S₁₂ … S₁₅ = S₉ - S₈, S₉ + S₈, S₁₀ - S₁₁, S₁₀ + S₁₁`, the sum is
`(S₁₂ S₁₄ : S₁₅ S₁₃ : S₁₂ S₁₃ : S₁₅ S₁₄)`. -/
public theorem isExt_add_cached {a b c e : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsCached x₂ y₂ a b c e) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ x₂ y₂
    let S₁₂ := (Y + X) * b - (Y - X) * a
    let S₁₃ := (Y + X) * b + (Y - X) * a
    let S₁₄ := Z * c - T * e
    let S₁₅ := Z * c + T * e
    IsExt Q.1 Q.2 (S₁₂ * S₁₄) (S₁₅ * S₁₃) (S₁₂ * S₁₃) (S₁₅ * S₁₄) := by
  intro Q S₁₂ S₁₃ S₁₄ S₁₅
  obtain ⟨Z', hQ', rfl, rfl, rfl, rfl⟩ := hQ.isExt
  exact IsExt.congr (isExt_add hP hQ' h1 h2 rfl rfl rfl rfl) (by ring) (by ring) (by ring) (by ring)

/-- `ExtendedPoint - CachedPoint` (AVX2): the sum with the negated cached point. -/
public theorem isExt_sub_cached {a b c e : ZMod p} (hP : IsExt x₁ y₁ X Y T Z)
    (hQ : IsCached x₂ y₂ a b c e) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    let Q := add x₁ y₁ (-x₂) y₂
    let S₁₂ := (Y + X) * a - (Y - X) * b
    let S₁₃ := (Y + X) * a + (Y - X) * b
    let S₁₄ := Z * c + T * e
    let S₁₅ := Z * c - T * e
    IsExt Q.1 Q.2 (S₁₂ * S₁₄) (S₁₅ * S₁₃) (S₁₂ * S₁₃) (S₁₅ * S₁₄) := by
  have h := isExt_add_cached hP hQ.neg h1 h2.neg
  simp only [mul_neg, sub_neg_eq_add, ← sub_eq_add_neg] at h
  exact h

end Addition

end MLIR.Agave

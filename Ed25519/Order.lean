module

public import Ed25519.BasePoint
public import Ed25519.Scalar
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The base point has order `ℓ`, and no point has order 16: `64 P = 0` forces `8 P = 0`. -/

namespace Ed25519

/-! ## `ℓ B = 0`, computed in extended coordinates over `ℕ` -/

namespace ExtN

@[expose] public section

/-- `a b mod p`. -/
def mulN (a b : ℕ) : ℕ :=
  a * b % p

/-- `a + b mod p`. -/
def addN (a b : ℕ) : ℕ :=
  (a + b) % p

/-- `a - b mod p`. -/
def subN (a b : ℕ) : ℕ :=
  (a + (p - b % p)) % p

theorem cast_mulN (a b : ℕ) : ((mulN a b : ℕ) : ZMod p) = a * b := by
  rw [mulN, ZMod.natCast_mod, Nat.cast_mul]

theorem cast_addN (a b : ℕ) : ((addN a b : ℕ) : ZMod p) = a + b := by
  rw [addN, ZMod.natCast_mod, Nat.cast_add]

theorem cast_subN (a b : ℕ) : ((subN a b : ℕ) : ZMod p) = a - b := by
  rw [subN, ZMod.natCast_mod, Nat.cast_add, Nat.cast_sub (Nat.mod_lt _ (by decide)).le,
    ZMod.natCast_self, ZMod.natCast_mod]
  ring

/-- `2 d`. -/
def d2N : ℕ :=
  2 * 37095705934669439343138083508754565189542113879843219016388785533085940283555

theorem cast_d2N : ((d2N : ℕ) : ZMod p) = 2 * d := by
  rw [d2N, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_ofNat, d]

/-- Extended coordinates `(X : Y : T : Z)` over `ℕ`. -/
structure E where
  X : ℕ
  Y : ℕ
  T : ℕ
  Z : ℕ
  deriving DecidableEq

/-- `A` are extended coordinates of `P`, mod `p`. -/
def Rep (P : Point) (A : E) : Prop :=
  IsExt P.x P.y A.X A.Y A.T A.Z

/-- The sum, by `add_compl`'s completed point. -/
def eadd (A B : E) : E :=
  let r₅ := mulN (subN A.Y A.X) (subN B.Y B.X)
  let r₆ := mulN (addN A.Y A.X) (addN B.Y B.X)
  let r₇ := mulN (mulN A.T B.T) d2N
  let r₈ := mulN (addN A.Z A.Z) B.Z
  ⟨mulN (subN r₆ r₅) (subN r₈ r₇), mulN (addN r₆ r₅) (addN r₈ r₇), mulN (subN r₆ r₅) (addN r₆ r₅),
    mulN (addN r₈ r₇) (subN r₈ r₇)⟩

/-- The completed point `(r₆ - r₅, r₈ - r₇, r₈ + r₇, r₆ + r₅)` as extended coordinates. -/
theorem isExt_add {x₁ y₁ X₁ Y₁ T₁ Z₁ x₂ y₂ X₂ Y₂ T₂ Z₂ : ZMod p} (hA : IsExt x₁ y₁ X₁ Y₁ T₁ Z₁)
    (hB : IsExt x₂ y₂ X₂ Y₂ T₂ Z₂) (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) {r₅ r₆ r₇ r₈ : ZMod p}
    (e₅ : r₅ = (Y₁ - X₁) * (Y₂ - X₂)) (e₆ : r₆ = (Y₁ + X₁) * (Y₂ + X₂))
    (e₇ : r₇ = T₁ * T₂ * (2 * d)) (e₈ : r₈ = (Z₁ + Z₁) * Z₂) :
    IsExt (add x₁ y₁ x₂ y₂).1 (add x₁ y₁ x₂ y₂).2 ((r₆ - r₅) * (r₈ - r₇)) ((r₆ + r₅) * (r₈ + r₇))
      ((r₆ - r₅) * (r₆ + r₅)) ((r₈ + r₇) * (r₈ - r₇)) := by
  subst e₅ e₆ e₇ e₈
  obtain ⟨n₁, n₂, c₁, c₂⟩ := add_compl hA hB h1 h2
  exact
    ⟨mul_ne_zero n₁ n₂, by
      rw [c₁]; ring, by
      rw [c₂]; ring, by ring⟩

theorem rep_add {P Q : Point} {A B : E} (hA : Rep P A) (hB : Rep Q B) : Rep (P + Q) (eadd A B) := by
  simp only [Rep, eadd, cast_mulN, cast_addN, cast_subN, cast_d2N, Point.add_x, Point.add_y]
  exact isExt_add hA hB P.on Q.on rfl rfl rfl rfl

/-- `acc + n A` by double-and-add over `k` bits. -/
def ladder : ℕ → ℕ → E → E → E
  | 0, _, _, acc => acc
  | k + 1, n, A, acc => ladder k (n / 2) (eadd A A) (if n % 2 = 1 then eadd acc A else acc)

theorem rep_ladder (k : ℕ) :
    ∀ (n : ℕ) (Q R : Point) (A acc : E),
      Rep Q A → Rep R acc → n < 2 ^ k → Rep (R + n • Q) (ladder k n A acc) := by
  induction k with
  | zero =>
    intro n Q R A acc _ hR hn
    obtain rfl : n = 0 := by omega
    simpa [ladder] using hR
  | succ k ih =>
    intro n Q R A acc hQ hR hn
    have hn' : n / 2 < 2 ^ k := by
      rw [pow_succ] at hn; omega
    have key : R + n • Q = (R + (n % 2) • Q) + (n / 2) • (Q + Q) := by
      rw [← two_smul ℕ Q, smul_smul, add_assoc, ← add_smul, mul_comm, Nat.mod_add_div]
    rw [key, ladder]
    refine ih _ _ _ _ _ (rep_add hQ hQ) ?_ hn'
    rcases Nat.mod_two_eq_zero_or_one n with h | h
    · simpa [h] using hR
    · simpa [h] using rep_add hR hQ

/-- `B`'s `x` over `ℕ`. -/
def BxN : ℕ :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

/-- `B`'s `y` over `ℕ`. -/
def ByN : ℕ :=
  46316835694926478169428394003475163141307993866256225615783033603165251855960

theorem rep_B : Rep basePoint ⟨BxN, ByN, BxN * ByN % p, 1⟩ := by
  refine ⟨by simp, ?_, ?_, ?_⟩
  · rw [Nat.cast_one, mul_one, BxN, Nat.cast_ofNat]; rfl
  · rw [Nat.cast_one, mul_one, ByN, Nat.cast_ofNat]; rfl
  · rw [Nat.cast_one, mul_one, ZMod.natCast_mod, Nat.cast_mul]

theorem rep_zero : Rep 0 ⟨0, 1, 0, 1⟩ :=
  ⟨by simp, by simp, by simp, by simp⟩

/-- `(X : Y : T : Z)` is the neutral point: `X = 0` and `Y = Z`. -/
def IsZero (A : E) : Bool :=
  A.X % p == 0 && A.Y % p == A.Z % p

theorem eq_zero_of_isZero {P : Point} {A : E} (h : Rep P A) (hz : IsZero A = true) : P = 0 := by
  simp only [IsZero, Bool.and_eq_true, beq_iff_eq] at hz
  obtain ⟨hZ, hX, hY, -⟩ := h
  have hX0 : ((A.X : ℕ) : ZMod p) = 0 := by rw [← ZMod.natCast_mod, hz.1, Nat.cast_zero]
  have hYZ : ((A.Y : ℕ) : ZMod p) = A.Z := by rw [← ZMod.natCast_mod, hz.2, ZMod.natCast_mod]
  ext
  · rw [hX0, eq_comm, mul_eq_zero] at hX
    exact hX.resolve_right hZ
  · rw [hYZ] at hY
    exact mul_right_cancel₀ hZ (hY.symm.trans (one_mul _).symm)

theorem isZero_ladder :
    IsZero (ladder 253 ell ⟨BxN, ByN, BxN * ByN % p, 1⟩ ⟨0, 1, 0, 1⟩) = true := by decide +kernel

end

end ExtN

/-- `ℓ B = 0`. -/
public theorem ell_smul_basePoint : ell • basePoint = 0 := by
  have h :=
    ExtN.rep_ladder 253 ell basePoint 0 _ _ ExtN.rep_B ExtN.rep_zero
      (by
        unfold ell; norm_num)
  rw [zero_add] at h
  exact ExtN.eq_zero_of_isZero h ExtN.isZero_ladder

/-! ## No point of order 16 -/

/-- `(1 + d) (1 + d y8²)`, a quarter of the discriminant for halving an order-8 point. -/
public theorem disc_not_square : ¬IsSquare ((1 + d) * (1 + d * y8 ^ 2)) := by
  have e :
    (1 + d) * (1 + d * y8 ^ 2) =
      18649689278727228840354232979487548124034359932680984740981561174796302117467 := by
    unfold d y8
    reduce_mod_char
  have h0 :
    (18649689278727228840354232979487548124034359932680984740981561174796302117467 : ZMod p) ≠
      0 := by
    decide
  rw [e, ZMod.euler_criterion p h0]
  reduce_mod_char
  decide

/-- Doubling's `y` is never `± y8`: else `(1 + d) (1 + d y8²)` is a square. -/
public theorem dbl_snd_ne {x y c : ZMod p} (hc : OnCurve x y) (hc8 : c ^ 2 = y8 ^ 2) :
    (dbl x y).2 ≠ c := by
  intro h
  have hy : y ^ 2 + x ^ 2 = c * (2 - y ^ 2 + x ^ 2) := (div_eq_iff (dbl_den₂ hc)).1 h
  unfold OnCurve at hc
  refine disc_not_square ⟨d * (1 + c) * y ^ 2 + (1 - c * d), ?_⟩
  linear_combination -(d * (1 + c)) * ((1 - c) * hc + (1 + d * y ^ 2) * hy) - (1 + d) * d * hc8

/-- A point whose double has small order has small order. -/
public theorem smallOrder_of_dbl {x y : ZMod p} (hc : OnCurve x y)
    (h : SmallOrder (dbl x y).1 (dbl x y).2) : SmallOrder x y := by
  rw [smallOrder_iff (dbl_onCurve hc)] at h
  rw [smallOrder_iff hc]
  rcases h with h | h | h | h
  · rcases mul_eq_zero.1 ((dbl_fst_eq_zero hc).1 h) with h | h
    · exact .inl h
    · exact .inr (.inl h)
  · exact .inr (.inr ((sq_add_sq_eq_zero hc).1 ((dbl_snd_eq_zero hc).1 h)))
  · exact absurd h (dbl_snd_ne hc rfl)
  · exact absurd h (dbl_snd_ne hc (neg_sq _))

namespace Point

/-- `8 (2 Q) = 0` forces `8 Q = 0`. -/
public theorem eight_smul_of_two_smul {Q : Point} (h : 8 • (2 • Q) = 0) : 8 • Q = 0 := by
  have e : dbl Q.x Q.y = ((2 • Q).x, (2 • Q).y) := by rw [two_smul, dbl_eq]
  rw [← smallOrder_iff_nsmul] at h ⊢
  exact smallOrder_of_dbl Q.on (by rwa [e])

/-- `2ᵏ 8 P = 0` forces `8 P = 0`. -/
public theorem eight_smul_of_pow_smul (k : ℕ) {P : Point} (h : 2 ^ k • 8 • P = 0) : 8 • P = 0 := by
  induction k generalizing P with
  | zero => simpa using h
  | succ k ih =>
    refine eight_smul_of_two_smul (ih ?_)
    rw [smul_smul, smul_smul] at *
    rw [← h, pow_succ]
    ring_nf

/-- No point of order 16: `64 P = 0` forces `8 P = 0`. -/
public theorem eight_smul_of_sixtyFour_smul {P : Point} (h : 64 • P = 0) : 8 • P = 0 :=
  eight_smul_of_pow_smul 3
    (by
      rw [smul_smul]; exact h)

/-- `x (32 P) = 0` forces `8 P = 0`. -/
public theorem eight_smul_of_x_eq_zero {P : Point} (h : (32 • P).x = 0) : 8 • P = 0 := by
  refine eight_smul_of_sixtyFour_smul ?_
  have e := dbl_of_fst (32 • P).on h
  rw [dbl_eq, ← two_smul ℕ, smul_smul] at e
  exact Point.ext (congrArg Prod.fst e) (congrArg Prod.snd e)

end Point

end Ed25519

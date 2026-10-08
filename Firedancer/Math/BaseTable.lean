module

public import Firedancer.Math.Curve
public import Firedancer.Math.Group
public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The Ref base point table `fd_ed25519_base_point_wnaf_table`: entry `j` is `(2 j + 1) B`,
affine (`Z = 1`) and precomputed as `(Y - X, Y + X, 2d T)`. The limbs are read off the global's
bits; the points are checked by the kernel, mod `p`, against the curve formulas. -/

namespace LeanMLIR.RIR.Firedancer.Ref

open fd_ed25519_double_scalar_mul_base

/-! ## Definitions -/

@[expose] public section

namespace Ed25519

/-- The base point's `x`, the even root. -/
def Bx : ZMod p :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

/-- The base point's `y`, `4 / 5`. -/
def By : ZMod p :=
  46316835694926478169428394003475163141307993866256225615783033603165251855960

/-- `(2 j + 1) B`: `B` plus `j` times `2 B`. -/
def oddMul : ℕ → ZMod p × ZMod p
  | 0 => (Bx, By)
  | j + 1 => add (oddMul j).1 (oddMul j).2 (dbl Bx By).1 (dbl Bx By).2

end Ed25519

end

/-! ## Reading the table -/

/-- A field element global's type. -/
abbrev tFe : Ty :=
  .array 1 (.struct [.array 5 (.bv 64)])

/-- A point global's type: `X, Y, T, Z`. -/
abbrev tPt : Ty :=
  .struct [tFe, tFe, tFe, tFe]

/-- A point global's limbs; noncomputable: the compiler cannot type a `⟦t⟧ᵣ` argument across
modules. -/
noncomputable def entry (e : ⟦tPt⟧ᵣ) : PointLimbs :=
  ⟨fun i => e.1[0][i], fun i => e.2.1[0][i], fun i => e.2.2.1[0][i], fun i => e.2.2.2[0][i]⟩

/-- Limb `i` of a field element global's bits. -/
theorem fe_limb (a : ⟦tFe⟧ᵣ) (i : Fin 5) :
    (Ty.flattenRaw tFe a).extractLsb' (64 * i) 64 = a[0][i] := by
  fin_cases i <;>
    simp (disch := decide) only [Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_struct_singleton, Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.fieldsWidth, Ty.padding, Ty.align, Ty.fieldsAlign]

/-- Four 320-bit fields, packed as a struct: `a` lowest. -/
abbrev pack4 (a b c d : BitVec 320) : BitVec 1280 :=
  (((0#0 ++ d) ++ (0#0 ++ c)) ++ (0#0 ++ b)) ++ (0#0 ++ a)

/-- Limb `i` of each field. -/
theorem pack4_extract (a b c d : BitVec 320) {i : Nat} (hi : i < 5) :
    (pack4 a b c d).extractLsb' (64 * i) 64 = a.extractLsb' (64 * i) 64 ∧
      (pack4 a b c d).extractLsb' (320 + 64 * i) 64 = b.extractLsb' (64 * i) 64 ∧
      (pack4 a b c d).extractLsb' (640 + 64 * i) 64 = c.extractLsb' (64 * i) 64 ∧
      (pack4 a b c d).extractLsb' (960 + 64 * i) 64 = d.extractLsb' (64 * i) 64 := by
  simp (disch := omega) only [pack4, BitVec.extractLsb'_append_eq_of_add_le,
    BitVec.extractLsb'_append_eq_of_le, Nat.zero_add, Nat.add_sub_cancel_left, true_and]
  rw [show 640 + 64 * i - 320 - 320 = 64 * i by omega,
    show 960 + 64 * i - 320 - 320 - 320 = 64 * i by omega]
  exact ⟨rfl, rfl⟩

/-- A point global's bits: its fields', packed. -/
theorem flattenRaw_tPt (a b c d : ⟦tFe⟧ᵣ) :
    Ty.flattenRaw tPt (a, b, c, d) =
      pack4 (Ty.flattenRaw tFe a) (Ty.flattenRaw tFe b) (Ty.flattenRaw tFe c)
        (Ty.flattenRaw tFe d) :=
  (Ty.flattenRaw_struct _).trans <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <| congrArg (· ++ _) <| Ty.flattenRawFields_singleton _

/-- Entry `j` is the literal's. -/
theorem baseTbl_eq {j : ℕ} (hj : j < 128) :
    baseTbl j = entry fd_ed25519_base_point_wnaf_table.lit[j] := by
  set e := fd_ed25519_base_point_wnaf_table.lit[j]
  set F :=
    pack4 (Ty.flattenRaw tFe e.1) (Ty.flattenRaw tFe e.2.1) (Ty.flattenRaw tFe e.2.2.1)
      (Ty.flattenRaw tFe e.2.2.2)
  have hs : tPt.stride = 1280 := rfl
  have key (o : ℕ) (ho : o + 64 ≤ 1280) :
    (Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 163840) (hw := rfl)).extractLsb'
        (1280 * j + o) 64 =
      F.extractLsb' o 64 := by
    have hi : (1280 * j + o) / tPt.stride < 128 := by
      rw [hs]; omega
    have hw : (1280 * j + o) % tPt.stride + 64 ≤ tPt.width := by
      rw [hs, show tPt.width = 1280 from rfl]; omega
    have h := Ty.extractLsb'_flattenRaw_array fd_ed25519_base_point_wnaf_table.lit hi hw
    have e1 : (1280 * j + o) / tPt.stride = j := by
      rw [hs]; omega
    have e2 : (1280 * j + o) % tPt.stride = o := by
      rw [hs]; omega
    simp only [e1, e2] at h
    exact
      (congrArg (BitVec.extractLsb' _ 64) Ty.flatBits_eq).trans <|
        BitVec.extractLsb'_cast.trans <|
        h.trans <| congrArg (BitVec.extractLsb' o 64) <| flattenRaw_tPt e.1 e.2.1 e.2.2.1 e.2.2.2
  have hx (i : Fin 5) :=
    pack4_extract (Ty.flattenRaw tFe e.1) (Ty.flattenRaw tFe e.2.1) (Ty.flattenRaw tFe e.2.2.1)
      (Ty.flattenRaw tFe e.2.2.2) i.isLt
  simp only [baseTbl, pointAt, entry, Nat.add_assoc]
  congr 1 <;> funext i
  · exact (key _ (by omega)).trans <| (hx i).1.trans (fe_limb _ i)
  · exact (key _ (by omega)).trans <| (hx i).2.1.trans (fe_limb _ i)
  · exact (key _ (by omega)).trans <| (hx i).2.2.1.trans (fe_limb _ i)
  · exact (key _ (by omega)).trans <| (hx i).2.2.2.trans (fe_limb _ i)

/-! ## Checks

Natural number checks, mod `p`, that the kernel decides. -/

/-- `d`. -/
@[expose] public def dN : ℕ :=
  37095705934669439343138083508754565189542113879843219016388785533085940283555

/-- `2 B`'s `x`. -/
@[expose] public def x2N : ℕ :=
  24727413235106541002554574571675588834622768167397638456726423682521233608206

/-- `2 B`'s `y`. -/
@[expose] public def y2N : ℕ :=
  15549675580280190176352668710449542251549572066445060580507079593062643049417

/-- The affine point a precomputed entry stores, `((Y + X) - (Y - X), (Y + X) + (Y - X)) / 2`:
the witness the checks test. -/
def affine (P : PointLimbs) : ℕ × ℕ :=
  ((Limbs.nat P.Y + p - Limbs.nat P.X % p) * ((p + 1) / 2) % p,
    (Limbs.nat P.X + Limbs.nat P.Y) * ((p + 1) / 2) % p)

/-- Every limb at most `c`. -/
def bounded (c : ℕ) (l : Fin 5 → BitVec 64) : Bool :=
  (l 0).toNat ≤ c && (l 1).toNat ≤ c && (l 2).toNat ≤ c && (l 3).toNat ≤ c && (l 4).toNat ≤ c

/-- `(x, y)` is on the curve: `y² = 1 + d x² y² + x²`. -/
@[expose] public def curveOk (x y : ℕ) : Bool :=
  y * y % p == (1 + dN * (x * x) * (y * y) + x * x) % p

/-- `P` is the curve point `(x, y)`, precomputed with `Z = 1`: `X, Y` loose, `T, Z` tight. -/
def entryOk (P : PointLimbs) (x y : ℕ) : Bool :=
  (Limbs.nat P.X + x) % p == y % p && Limbs.nat P.Y % p == (y + x) % p &&
    Limbs.nat P.T % p == 2 * dN * x * y % p &&
    bounded 0x18000000000000 P.X &&
    bounded 0x18000000000000 P.Y &&
    bounded 0x8000000000000 P.T &&
    bounded 0x8000000000000 P.Z &&
    curveOk x y

/-- `add` of `(x₁, y₁)` and `(x₂, y₂)` is `(x₃, y₃)`, denominators multiplied out. -/
@[expose] public def addOk (x₁ y₁ x₂ y₂ x₃ y₃ : ℕ) : Bool :=
  (1 + dN * x₁ * x₂ * y₁ * y₂) % p != 0 && dN * x₁ * x₂ * y₁ * y₂ % p != 1 &&
    (x₁ * y₂ + y₁ * x₂) % p == x₃ * (1 + dN * x₁ * x₂ * y₁ * y₂) % p &&
    (y₁ * y₂ + x₁ * x₂ + y₃ * (dN * x₁ * x₂ * y₁ * y₂)) % p == y₃ % p

/-- `dbl` of `(x, y)` is `(x', y')`, denominators multiplied out. -/
@[expose] public def dblOk (x y x' y' : ℕ) : Bool :=
  y * y % p != x * x % p && (2 * x * y + x' * (x * x)) % p == x' * (y * y) % p &&
    (2 + x * x) % p != y * y % p &&
    (y * y + x * x + y' * (y * y)) % p == y' * (2 + x * x) % p

/-- Entry `0` stores `B`, and `2 B` is `(x2N, y2N)`. -/
theorem base_ok :
    affine (entry fd_ed25519_base_point_wnaf_table.lit[0]) = (Ed25519.Bx.val, Ed25519.By.val) ∧
      dblOk Ed25519.Bx.val Ed25519.By.val x2N y2N = true := by
  decide +kernel

/-- Every entry stores its point, on the curve. -/
theorem entries_ok :
    ∀ j (h : j < 128),
      entryOk (entry fd_ed25519_base_point_wnaf_table.lit[j])
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).1
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).2 =
        true := by
  decide +kernel

/-- Each entry's point plus `2 B` is the next's. -/
theorem adds_ok :
    ∀ j (h : j < 127),
      addOk (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).1
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).2 x2N y2N
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j + 1])).1
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j + 1])).2 =
        true := by
  decide +kernel

/-! ## Soundness -/

/-- Naturals equal mod `p` are equal in `ZMod p`. -/
public theorem natCast_eq {a b : ℕ} (h : a % p = b % p) : (a : ZMod p) = b :=
  (ZMod.natCast_eq_natCast_iff' a b p).2 h

/-- Naturals distinct mod `p` are distinct in `ZMod p`. -/
public theorem natCast_ne {a b : ℕ} (h : a % p ≠ b % p) : (a : ZMod p) ≠ b := fun e =>
  h ((ZMod.natCast_eq_natCast_iff' a b p).1 e)

/-- `dN` is `d`. -/
public theorem dN_eq : (dN : ZMod p) = Ed25519.d := by
  unfold dN Ed25519.d
  exact Nat.cast_ofNat

/-- `addOk` computes `add`. -/
public theorem add_of_ok {x₁ y₁ x₂ y₂ x₃ y₃ : ℕ} (h : addOk x₁ y₁ x₂ y₂ x₃ y₃ = true) :
    Ed25519.add x₁ y₁ x₂ y₂ = ((x₃ : ZMod p), (y₃ : ZMod p)) := by
  simp only [addOk, Bool.and_eq_true, bne_iff_ne, beq_iff_eq, ne_eq] at h
  obtain ⟨⟨⟨h₁, h₂⟩, h₃⟩, h₄⟩ := h
  have d₁ := natCast_ne (b := 0) h₁
  have d₂ := natCast_ne (b := 1) h₂
  have e₃ := natCast_eq h₃
  have e₄ := natCast_eq h₄
  push_cast [dN_eq] at d₁ d₂ e₃ e₄
  have d₂' : 1 - Ed25519.d * x₁ * x₂ * y₁ * y₂ ≠ 0 := fun h => d₂ (by linear_combination -h)
  simp only [Ed25519.add, Prod.mk.injEq]
  rw [div_eq_iff d₁, div_eq_iff d₂']
  exact ⟨by linear_combination e₃, by linear_combination e₄⟩

/-- `dblOk` computes `dbl`. -/
public theorem dbl_of_ok {x y x' y' : ℕ} (h : dblOk x y x' y' = true) :
    Ed25519.dbl x y = ((x' : ZMod p), (y' : ZMod p)) := by
  simp only [dblOk, Bool.and_eq_true, bne_iff_ne, beq_iff_eq, ne_eq] at h
  obtain ⟨⟨⟨h₁, h₂⟩, h₃⟩, h₄⟩ := h
  have d₁ := natCast_ne h₁
  have d₂ := natCast_ne h₃
  have e₂ := natCast_eq h₂
  have e₄ := natCast_eq h₄
  push_cast at d₁ d₂ e₂ e₄
  have d₁' : (y : ZMod p) ^ 2 - x ^ 2 ≠ 0 := fun h => d₁ (by linear_combination h)
  have d₂' : 2 - (y : ZMod p) ^ 2 + x ^ 2 ≠ 0 := fun h => d₂ (by linear_combination h)
  simp only [Ed25519.dbl, Prod.mk.injEq]
  rw [div_eq_iff d₁', div_eq_iff d₂']
  exact ⟨by linear_combination e₂, by linear_combination e₄⟩

/-- `curveOk` is `OnCurve`. -/
public theorem onCurve_of_ok {x y : ℕ} (h : curveOk x y = true) : Ed25519.OnCurve x y := by
  simp only [curveOk, beq_iff_eq] at h
  have e := natCast_eq h
  push_cast [dN_eq] at e
  unfold Ed25519.OnCurve
  linear_combination e

/-- `bounded c` bounds every limb by `c`. -/
theorem limbs_of_bounded {c : ℕ} {l : Fin 5 → BitVec 64} (h : bounded c l = true) :
    ∀ i, (l i).toNat ≤ c := by
  simp only [bounded, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨h0, h1⟩, h2⟩, h3⟩, h4⟩ := h
  intro i
  fin_cases i <;> assumption

/-- `entryOk` gives the operand, its bounds, and the point on the curve. -/
theorem entry_of_ok {P : PointLimbs} {x y : ℕ} (h : entryOk P x y = true) :
    P.Operand 1#32 1#32 x y ∧
      Limbs.Loose P.X ∧
      Limbs.Loose P.Y ∧ Limbs.Tight P.T ∧ Limbs.Tight P.Z ∧ Ed25519.OnCurve x y := by
  simp only [entryOk, Bool.and_eq_true, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨hX, hY⟩, hT⟩, bX⟩, bY⟩, bT⟩, bZ⟩, hc⟩ := h
  refine
    ⟨⟨x, y, x * y, 1, ⟨one_ne_zero, (mul_one _).symm, (mul_one _).symm, by ring⟩, by simp, ?_⟩,
      limbs_of_bounded bX, limbs_of_bounded bY, limbs_of_bounded bT, limbs_of_bounded bZ,
      onCurve_of_ok hc⟩
  have eX := natCast_eq hX
  have eY := natCast_eq hY
  have eT := natCast_eq hT
  push_cast [dN_eq] at eX eY eT
  simp only [show (1#32 = 0#32) = False by decide, ite_false, Limbs.val_nat]
  exact ⟨by linear_combination eX, by linear_combination eY, by linear_combination eT⟩

/-! ## The table -/

/-- `B`'s `y` is `4 / 5`. -/
public theorem Ed25519.By_eq : Ed25519.By = 4 / 5 := by
  rw [eq_div_iff (by decide)]
  decide

/-- `B` is on the curve. -/
public theorem Ed25519.onCurve_B : Ed25519.OnCurve Ed25519.Bx Ed25519.By := by
  have h := (entry_of_ok (entries_ok 0 (by decide))).2.2.2.2.2
  rwa [base_ok.1, ZMod.natCast_zmod_val, ZMod.natCast_zmod_val] at h

/-- `(2 j + 1) B` is the point entry `j` stores. -/
theorem Ed25519.oddMul_eq {j : ℕ} (hj : j < 128) :
    Ed25519.oddMul j = (((affine (baseTbl j)).1 : ZMod p), ((affine (baseTbl j)).2 : ZMod p)) := by
  induction j with
  | zero =>
    rw [baseTbl_eq hj, base_ok.1, ZMod.natCast_zmod_val, ZMod.natCast_zmod_val]
    rfl
  | succ j ih =>
    have h2 := dbl_of_ok base_ok.2
    rw [ZMod.natCast_zmod_val, ZMod.natCast_zmod_val] at h2
    rw [Ed25519.oddMul, ih (by omega), h2, baseTbl_eq hj, baseTbl_eq (by omega)]
    exact add_of_ok (adds_ok j (by omega))

/-- Entry `j` of the base point's table is `(2 j + 1) B` as `add_with_opts`'s precomputed `Z = 1`
operand: `X, Y` loose, `T, Z` tight, the point on the curve. -/
public theorem fd_ed25519_double_scalar_mul_base.baseTbl_operand {j : ℕ} (hj : j < 128) :
    let Q := Ed25519.oddMul j
    (baseTbl j).Operand 1#32 1#32 Q.1 Q.2 ∧
      Limbs.Loose (baseTbl j).X ∧
      Limbs.Loose (baseTbl j).Y ∧
      Limbs.Tight (baseTbl j).T ∧ Limbs.Tight (baseTbl j).Z ∧ Ed25519.OnCurve Q.1 Q.2 := by
  rw [Ed25519.oddMul_eq hj, baseTbl_eq hj]
  exact entry_of_ok (entries_ok j hj)

/-- The base point `B`. -/
@[expose] public def Ed25519.basePoint : Ed25519.Point :=
  ⟨Ed25519.Bx, Ed25519.By, Ed25519.onCurve_B⟩

/-- `oddMul j` is `(2 j + 1) B`. -/
public theorem Ed25519.oddMul_eq_nsmul (j : ℕ) :
    Ed25519.oddMul j =
      (((2 * j + 1) • Ed25519.basePoint).x, ((2 * j + 1) • Ed25519.basePoint).y) := by
  induction j with
  | zero => simp [Ed25519.oddMul, Ed25519.basePoint]
  | succ j ih =>
    have e : (2 * (j + 1) + 1) • Ed25519.basePoint =
        (2 * j + 1) • Ed25519.basePoint + (Ed25519.basePoint + Ed25519.basePoint) := by
      rw [show 2 * (j + 1) + 1 = (2 * j + 1) + 2 by ring, add_smul, two_smul]
    rw [Ed25519.oddMul, ih, show Ed25519.Bx = Ed25519.basePoint.x from rfl,
      show Ed25519.By = Ed25519.basePoint.y from rfl, Ed25519.Point.dbl_eq, e]
    rfl

end LeanMLIR.RIR.Firedancer.Ref

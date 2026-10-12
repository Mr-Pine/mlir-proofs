module

public import Sodium.Math.Point
public import Boringssl.Math.Slide
public import Sodium.ge25519_double_scalarmult_vartime
public import Firedancer.Math.BaseTable
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module
import Mathlib.Tactic.Ring

/-! `ge25519_double_scalarmult_vartime` computes `[a] A + [b] B`: `Bi[j]` is `(2 j + 1) B`, checked
by the kernel against the curve formulas; `Ai[j]` is `(2 j + 1) A`; each slide digit adds its odd
multiple, and the ladder doubles between digits. -/

namespace MLIR.Sodium

open _root_.Ed25519 Agave
open Firedancer.Ref (dN x2N y2N addOk dblOk curveOk natCast_eq dN_eq add_of_ok dbl_of_ok
  onCurve_of_ok)
open Boringssl.ge_double_scalarmult_vartime (start precompAt Digits)

namespace ge25519_double_scalarmult_vartime

/-! ## The table `Bi` -/

/-- An `fe25519` global's type. -/
abbrev tFe : Ty :=
  .array 5 (.bv 64)

/-- A `ge25519_precomp` global's type: `yplusx, yminusx, xy2d`. -/
abbrev tPre : Ty :=
  .struct [tFe, tFe, tFe]

/-- A `ge25519_precomp` global's limbs. -/
noncomputable def entry (e : ⟦tPre⟧ᵣ) : GePrecomp :=
  ⟨fun i => e.1[i], fun i => e.2.1[i], fun i => e.2.2[i]⟩

/-- Limb `i` of a field element global's bits. -/
theorem fe_limb (a : ⟦tFe⟧ᵣ) (i : Fin 5) :
    (Ty.flattenRaw tFe a).extractLsb' (64 * i) 64 = a[i] := by
  fin_cases i <;>
    simp (disch := decide) only [Ty.extractLsb'_flattenRaw_array, Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.padding, Ty.align]

/-- Three 320-bit fields, packed as a struct: `a` lowest. -/
abbrev pack3 (a b c : BitVec 320) : BitVec 960 :=
  ((0#0 ++ c) ++ (0#0 ++ b)) ++ (0#0 ++ a)

/-- Limb `i` of each field. -/
theorem pack3_extract (a b c : BitVec 320) {i : Nat} (hi : i < 5) :
    (pack3 a b c).extractLsb' (64 * i) 64 = a.extractLsb' (64 * i) 64 ∧
      (pack3 a b c).extractLsb' (320 + 64 * i) 64 = b.extractLsb' (64 * i) 64 ∧
      (pack3 a b c).extractLsb' (640 + 64 * i) 64 = c.extractLsb' (64 * i) 64 := by
  simp (disch := omega) only [pack3, BitVec.extractLsb'_append_eq_of_add_le,
    BitVec.extractLsb'_append_eq_of_le, Nat.zero_add, Nat.add_sub_cancel_left, true_and]
  rw [show 640 + 64 * i - 320 - 320 = 64 * i by omega]

/-- A `ge25519_precomp` global's bits: its fields', packed. -/
theorem flattenRaw_tPre (a b c : ⟦tFe⟧ᵣ) :
    Ty.flattenRaw tPre (a, b, c) =
      pack3 (Ty.flattenRaw tFe a) (Ty.flattenRaw tFe b) (Ty.flattenRaw tFe c) := by
  rw [Ty.flattenRaw_struct, Ty.flattenRawFields_cons, Ty.flattenRawFields_cons,
    Ty.flattenRawFields_singleton]
  rfl

/-- Entry `j` is the literal's. -/
theorem biTbl_eq {j : ℕ} (hj : j < 8) :
    biTbl j = entry ge25519_double_scalarmult_vartime_Bi.lit[j] := by
  set e := ge25519_double_scalarmult_vartime_Bi.lit[j]
  set F := pack3 (Ty.flattenRaw tFe e.1) (Ty.flattenRaw tFe e.2.1) (Ty.flattenRaw tFe e.2.2)
  have hs : tPre.stride = 960 := rfl
  have key (o : ℕ) (ho : o + 64 ≤ 960) :
    (Ty.flatBits ge25519_double_scalarmult_vartime_Bi.lit (w := 7680) (hw := rfl)).extractLsb'
        (960 * j + o) 64 =
      F.extractLsb' o 64 := by
    have hi : (960 * j + o) / tPre.stride < 8 := by
      rw [hs]; omega
    have hw : (960 * j + o) % tPre.stride + 64 ≤ tPre.width := by
      rw [hs, show tPre.width = 960 from rfl]; omega
    have h := Ty.extractLsb'_flattenRaw_array ge25519_double_scalarmult_vartime_Bi.lit hi hw
    have e1 : (960 * j + o) / tPre.stride = j := by
      rw [hs]; omega
    have e2 : (960 * j + o) % tPre.stride = o := by
      rw [hs]; omega
    simp only [e1, e2] at h
    exact
      (congrArg (BitVec.extractLsb' _ 64) Ty.flatBits_eq).trans <|
        BitVec.extractLsb'_cast.trans <|
        h.trans <| congrArg (BitVec.extractLsb' o 64) <| flattenRaw_tPre e.1 e.2.1 e.2.2
  have hx (i : Fin 5) :=
    pack3_extract (Ty.flattenRaw tFe e.1) (Ty.flattenRaw tFe e.2.1) (Ty.flattenRaw tFe e.2.2) i.isLt
  simp only [biTbl, precompAt, entry, Nat.add_assoc]
  congr 1 <;> funext i
  · exact (key _ (by omega)).trans <| (hx i).1.trans (fe_limb _ i)
  · exact (key _ (by omega)).trans <| (hx i).2.1.trans (fe_limb _ i)
  · exact (key _ (by omega)).trans <| (hx i).2.2.trans (fe_limb _ i)

/-! ### Checks

Natural number checks, mod `p`, that the kernel decides. -/

/-- The affine point a precomputed entry stores, `((y + x) - (y - x), (y + x) + (y - x)) / 2`: the
witness the checks test. -/
def affine (P : GePrecomp) : ℕ × ℕ :=
  ((Limbs.nat P.yplusx + p - Limbs.nat P.yminusx % p) * ((p + 1) / 2) % p,
    (Limbs.nat P.yplusx + Limbs.nat P.yminusx) * ((p + 1) / 2) % p)

/-- Every limb below `c`. -/
def bounded (c : ℕ) (l : Fin 5 → BitVec 64) : Bool :=
  (l 0).toNat < c && (l 1).toNat < c && (l 2).toNat < c && (l 3).toNat < c && (l 4).toNat < c

/-- `P` is the curve point `(x, y)` as `(y + x, y - x, 2d x y)`, limbs below `2^54`. -/
def entryOk (P : GePrecomp) (x y : ℕ) : Bool :=
  Limbs.nat P.yplusx % p == (y + x) % p && (Limbs.nat P.yminusx + x) % p == y % p &&
    Limbs.nat P.xy2d % p == 2 * dN * x * y % p &&
    bounded (2 ^ 54) P.yplusx &&
    bounded (2 ^ 54) P.yminusx &&
    bounded (2 ^ 54) P.xy2d &&
    curveOk x y

/-- Entry `0` stores `B`, and `2 B` is `(x2N, y2N)`. -/
theorem base_ok :
    affine (entry ge25519_double_scalarmult_vartime_Bi.lit[0]) = (Ed25519.Bx.val, Ed25519.By.val) ∧
      dblOk Ed25519.Bx.val Ed25519.By.val x2N y2N = true := by
  decide +kernel

/-- Every entry stores its point, on the curve. -/
theorem entries_ok :
    ∀ j (h : j < 8),
      entryOk (entry ge25519_double_scalarmult_vartime_Bi.lit[j])
          (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j])).1
          (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j])).2 =
        true := by
  decide +kernel

/-- Each entry's point plus `2 B` is the next's. -/
theorem adds_ok :
    ∀ j (h : j < 7),
      addOk (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j])).1
          (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j])).2 x2N y2N
          (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j + 1])).1
          (affine (entry ge25519_double_scalarmult_vartime_Bi.lit[j + 1])).2 =
        true := by
  decide +kernel

/-! ### Soundness -/

/-- `bounded c` bounds every limb by `c`. -/
theorem lt_of_bounded {c : ℕ} {l : Fin 5 → BitVec 64} (h : bounded c l = true) : Limbs.Lt l c := by
  simp only [bounded, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨h0, h1⟩, h2⟩, h3⟩, h4⟩ := h
  intro i
  fin_cases i <;> assumption

/-- `entryOk` gives the `ge25519_precomp` of `(x, y)`, limbs below `2^54`, the point on the
curve. -/
theorem entry_of_ok {P : GePrecomp} {x y : ℕ} (h : entryOk P x y = true) :
    IsAffineNiels x y (Limbs.val P.yplusx) (Limbs.val P.yminusx) (Limbs.val P.xy2d) ∧
      Limbs.Lt P.yplusx (2 ^ 54) ∧
      Limbs.Lt P.yminusx (2 ^ 54) ∧ Limbs.Lt P.xy2d (2 ^ 54) ∧ OnCurve x y := by
  simp only [entryOk, Bool.and_eq_true, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨hp, hm⟩, ht⟩, bp⟩, bm⟩, bt⟩, hc⟩ := h
  refine ⟨?_, lt_of_bounded bp, lt_of_bounded bm, lt_of_bounded bt, onCurve_of_ok hc⟩
  have ep := natCast_eq hp
  have em := natCast_eq hm
  have et := natCast_eq ht
  push_cast [dN_eq] at ep em et
  simp only [Limbs.val_nat]
  exact ⟨one_ne_zero, by linear_combination ep, by linear_combination em, by linear_combination et⟩

/-- `(2 j + 1) B` is the point entry `j` stores. -/
theorem oddMul_eq {j : ℕ} (hj : j < 8) :
    Firedancer.Ref.Ed25519.oddMul j =
      (((affine (biTbl j)).1 : ZMod p), ((affine (biTbl j)).2 : ZMod p)) := by
  induction j with
  | zero =>
    rw [biTbl_eq hj, base_ok.1, ZMod.natCast_zmod_val, ZMod.natCast_zmod_val]
    rfl
  | succ j ih =>
    have h2 := dbl_of_ok base_ok.2
    rw [ZMod.natCast_zmod_val, ZMod.natCast_zmod_val] at h2
    rw [Firedancer.Ref.Ed25519.oddMul, ih (by omega), h2, biTbl_eq hj, biTbl_eq (by omega)]
    exact add_of_ok (adds_ok j (by omega))

/-- `Bi[j]` is `(2 j + 1) B` as a `ge25519_precomp`, limbs below `2^54`. -/
public theorem biTbl_nielsLt {j : ℕ} (hj : j < 8) :
    (biTbl j).NielsLt ((2 * j + 1) • Ed25519.basePoint) (2 ^ 54) := by
  have e := (oddMul_eq hj).symm.trans (Firedancer.Ref.Ed25519.oddMul_eq_nsmul j)
  obtain ⟨hx, hy⟩ := Prod.mk.inj e
  obtain ⟨hn, bp, bm, bt, -⟩ := entry_of_ok (biTbl_eq hj ▸ entries_ok j hj)
  rw [hx, hy] at hn
  exact ⟨hn, bp, bm, bt⟩

/-! ## Digits -/

/-- A slide digit: `0`, or odd in `[-15, 15]`. -/
def DigitOk (d : BitVec 8) : Prop :=
  d = 0#8 ∨ (Odd d.toInt ∧ -15 ≤ d.toInt ∧ d.toInt ≤ 15)

/-- A positive odd digit halves to the index of its multiple. -/
theorem idx_val_pos {d : BitVec 8} (hpos : (0#8).slt d = true) (ho : Odd d.toInt) :
    ((2 * (d >>> 1).toNat + 1 : ℕ) : ℤ) = d.toInt := by
  have h1 : 0 < d.toInt := by
    simp only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] at hpos
    exact hpos
  have h2 : d.toInt = d.toNat := by
    have := BitVec.toInt_eq_toNat_cond d
    split at this <;> omega
  rw [BitVec.toNat_ushiftRight, h2]
  rw [h2] at ho
  obtain ⟨m, hm⟩ := ho
  rw [Nat.shiftRight_one]
  omega

/-- A negative odd digit at least `-15`, negated, halves to the index of its multiple. -/
theorem idx_val_neg {d : BitVec 8} (hneg : d.slt 0#8 = true) (ho : Odd d.toInt)
    (h15 : -15 ≤ d.toInt) : ((2 * ((-d) >>> 1).toNat + 1 : ℕ) : ℤ) = -d.toInt := by
  have h1 : d.toInt < 0 := by
    simp only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] at hneg
    exact hneg
  have h2 : d.toInt = d.toNat - 256 := by
    have := BitVec.toInt_eq_toNat_cond d
    split at this <;> omega
  have h3 : (-d).toNat = 256 - d.toNat := by
    rw [BitVec.toNat_neg]
    omega
  rw [BitVec.toNat_ushiftRight, h3]
  rw [h2] at ho h15 ⊢
  obtain ⟨m, hm⟩ := ho
  rw [Nat.shiftRight_one]
  omega

/-- A digit neither positive nor negative is `0`. -/
theorem eq_zero_of_not {d : BitVec 8} (hp : ¬(0#8).slt d = true) (hn : ¬d.slt 0#8 = true) :
    d = 0#8 := by
  simp only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero, not_lt] at hp hn
  have : d.toInt = 0 := by omega
  exact BitVec.eq_of_toInt_eq (by simpa using this)

/-- A table of `P`'s odd multiples looked up at a digit `d ≠ 0`: `d P`, by sign. -/
theorem addDigit {β : Type} {Niels : β → Point → Prop} {tbl : ℕ → β} {P : Point}
    (htbl : ∀ k < 8, Niels (tbl k) ((2 * k + 1) • P)) {d : BitVec 8}
    (hd : Odd d.toInt ∧ -15 ≤ d.toInt ∧ d.toInt ≤ 15) :
    ((0#8).slt d = true → Niels (tbl (d >>> 1).toNat) (d.toInt • P)) ∧
      (d.slt 0#8 = true → Niels (tbl ((-d) >>> 1).toNat) ((-d.toInt) • P)) := by
  refine ⟨fun hp => ?_, fun hn => ?_⟩
  · have e := idx_val_pos hp hd.1
    have := htbl (d >>> 1).toNat (by omega)
    rwa [← natCast_zsmul, e] at this
  · have e := idx_val_neg hn hd.1 hd.2.1
    have := htbl ((-d) >>> 1).toNat (by omega)
    rwa [← natCast_zsmul, e] at this

/-- `aslide[i]`'s add takes `t`, `Q`, to `Q + d A`, `Ai` holding `A`'s odd multiples. -/
theorem addA_complLt {AI : ℕ → GeCached} {PA Q : Point} {t : GeP1p1} {d : BitVec 8}
    (hai : ∀ k < 8, (AI k).NielsLt ((2 * k + 1) • PA) (2 ^ 54)) (ht : t.ComplLt Q (2 ^ 54))
    (hd : DigitOk d) : (addA AI d t).ComplLt (Q + d.toInt • PA) (2 ^ 54) := by
  unfold addA
  split_ifs with hp hn
  · rcases hd with rfl | hd
    · exact absurd hp (by decide)
    exact
      ge25519_add.spec_complLt (ge25519_p1p1_to_p3.spec_extLt ht)
        ((addDigit (Niels := fun C Q => GeCached.NielsLt C Q (2 ^ 54)) hai hd).1 hp)
  · rcases hd with rfl | hd
    · exact absurd hn (by decide)
    have h :=
      ge25519_sub.spec_complLt (ge25519_p1p1_to_p3.spec_extLt ht)
        ((addDigit (Niels := fun C Q => GeCached.NielsLt C Q (2 ^ 54)) hai hd).2 hn)
    rwa [neg_smul, sub_neg_eq_add] at h
  · rw [eq_zero_of_not hp hn, BitVec.toInt_zero, zero_smul, add_zero]
    exact ht

/-- `bslide[i]`'s add takes `t`, `Q`, to `Q + d B`, `Bi` holding `B`'s odd multiples. -/
theorem addB_complLt {BI : ℕ → GePrecomp} {PB Q : Point} {t : GeP1p1} {d : BitVec 8}
    (hbi : ∀ k < 8, (BI k).NielsLt ((2 * k + 1) • PB) (2 ^ 54)) (ht : t.ComplLt Q (2 ^ 54))
    (hd : DigitOk d) : (addB BI d t).ComplLt (Q + d.toInt • PB) (2 ^ 54) := by
  unfold addB
  split_ifs with hp hn
  · rcases hd with rfl | hd
    · exact absurd hp (by decide)
    exact
      ge25519_madd.spec_complLt (ge25519_p1p1_to_p3.spec_extLt ht)
        ((addDigit (Niels := fun C Q => GePrecomp.NielsLt C Q (2 ^ 54)) hbi hd).1 hp)
  · rcases hd with rfl | hd
    · exact absurd hn (by decide)
    have h :=
      ge25519_msub.spec_complLt (ge25519_p1p1_to_p3.spec_extLt ht)
        ((addDigit (Niels := fun C Q => GePrecomp.NielsLt C Q (2 ^ 54)) hbi hd).2 hn)
    rwa [neg_smul, sub_neg_eq_add] at h
  · rw [eq_zero_of_not hp hn, BitVec.toInt_zero, zero_smul, add_zero]
    exact ht

/-- An iteration takes `r`, `R`, to `2 R + d₁ A + d₂ B`. -/
theorem step_projLt {AI : ℕ → GeCached} {BI : ℕ → GePrecomp} {PA PB R : Point} {r : GeP2}
    {d₁ d₂ : BitVec 8} (hai : ∀ k < 8, (AI k).NielsLt ((2 * k + 1) • PA) (2 ^ 54))
    (hbi : ∀ k < 8, (BI k).NielsLt ((2 * k + 1) • PB) (2 ^ 54)) (hr : r.ProjLt R (2 ^ 52))
    (hd₁ : DigitOk d₁) (hd₂ : DigitOk d₂) :
    (step AI BI d₁ d₂ r).ProjLt (2 • R + d₁.toInt • PA + d₂.toInt • PB) (2 ^ 52) := by
  rw [two_nsmul]
  exact
    ge25519_p1p1_to_p2.spec_projLt
      (addB_complLt hbi (addA_complLt hai (ge25519_p2_dbl.spec_complLt hr) hd₁) hd₂)

/-! ## The ladder -/

/-- The value of `w`'s low `i` digits, `Σ_{k < i} w[k] 2^k`, signed. -/
def low (w : Vector (BitVec 8) 256) (i : ℕ) : ℤ :=
  ∑ k ∈ Finset.range i, if h : k < 256 then w[k].toInt * 2 ^ k else 0

/-- One more digit. -/
theorem low_succ (w : Vector (BitVec 8) 256) {i : ℕ} (h : i < 256) :
    low w (i + 1) = low w i + w[i].toInt * 2 ^ i := by
  rw [low, Finset.sum_range_succ, dite_eq_left_of_eq_true (eq_true h)]
  rfl

/-- All digits: `w`'s value. -/
theorem low_256 (w : Vector (BitVec 8) 256) :
    low w 256 = ∑ i : Fin 256, w[i].toInt * 2 ^ (i : ℕ) := by
  rw [low, ← Fin.sum_univ_eq_sum_range]
  simp

/-- Zero digits from `j` on add nothing. -/
theorem low_add {w : Vector (BitVec 8) 256} {j : ℕ} (hz : ∀ k (hk : k < 256), j ≤ k → w[k] = 0#8) :
    ∀ m, j + m ≤ 256 → low w (j + m) = low w j
  | 0, _ => rfl
  | m + 1, h => by
    rw [← Nat.add_assoc, low_succ w (by omega), hz _ _ (by omega), BitVec.toInt_zero, zero_mul,
      add_zero, low_add hz m (by omega)]

/-- `ProjLt` of equal points. -/
theorem projLt_congr {r : GeP2} {P Q : Point} {b : ℕ} (h : r.ProjLt P b) (e : P = Q) :
    r.ProjLt Q b :=
  e ▸ h

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_projLt {AI : ℕ → GeCached} {BI : ℕ → GePrecomp} {PA PB : Point}
    {as bs : Vector (BitVec 8) 256} (hai : ∀ k < 8, (AI k).NielsLt ((2 * k + 1) • PA) (2 ^ 54))
    (hbi : ∀ k < 8, (BI k).NielsLt ((2 * k + 1) • PB) (2 ^ 54))
    (hwa : ∀ k (hk : k < 256), DigitOk as[k]) (hwb : ∀ k (hk : k < 256), DigitOk bs[k]) :
    ∀ i (h : i < 256) {r : GeP2} {R : Point},
      r.ProjLt R (2 ^ 52) →
        (ladder AI BI as bs i h r).ProjLt
          ((2 ^ (i + 1) : ℤ) • R + low as (i + 1) • PA + low bs (i + 1) • PB) (2 ^ 52)
  | 0, h, r, R, hr => by
    rw [ladder]
    refine projLt_congr (step_projLt hai hbi hr (hwa 0 h) (hwb 0 h)) ?_
    rw [low_succ as h, low_succ bs h]
    simp only [low, Finset.range_zero, Finset.sum_empty]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    refine
      projLt_congr
        (ladder_projLt hai hbi hwa hwb i (by omega) (step_projLt hai hbi hr (hwa _ h) (hwb _ h))) ?_
    rw [low_succ as h, low_succ bs h]
    module

/-! ## The table `Ai` -/

/-- `Ai[k]` is `(2 k + 1) A`. -/
theorem aiTbl_nielsLt {P : GeP3} {PA : Point} (hP : P.ExtLt PA (2 ^ 52)) :
    ∀ k, (aiTbl P k).NielsLt ((2 * k + 1) • PA) (2 ^ 54)
  | 0 => by
    rw [Nat.mul_zero, Nat.zero_add, one_smul]
    exact ge25519_p3_to_cached.spec_nielsLt hP
  | k + 1 => by
    have h2 := ge25519_p1p1_to_p3.spec_extLt (ge25519_p3_dbl.spec_complLt hP)
    have h :=
      ge25519_p3_to_cached.spec_nielsLt
        (ge25519_p1p1_to_p3.spec_extLt (ge25519_add.spec_complLt h2 (aiTbl_nielsLt hP k)))
    have e : PA + PA + (2 * k + 1) • PA = (2 * (k + 1) + 1) • PA := by
      rw [← two_nsmul, ← add_smul]
      congr 1
      ring
    rw [← e]
    exact h

/-! ## The first non-zero digit -/

/-- `start` stops at `j`: the digits above it, up to `i`, are zero. -/
theorem start_some {as bs : Vector (BitVec 8) 256} :
    ∀ i (h : i < 256) {j : Fin 256},
      start as bs i h = some j → ∀ k (hk : k < 256), j.val < k → k ≤ i → as[k] = 0#8 ∧ bs[k] = 0#8
  | 0, _, _, _, _, _, hjk, hki => absurd hjk (by omega)
  | i + 1, h, j, hs, k, hk, hjk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · by_cases hki' : k = i + 1
      · subst hki'
        exact hz
      · exact start_some i (by omega) hs k hk hjk (by omega)
    · have := congrArg Fin.val (Option.some.inj hs)
      simp only at this
      omega

/-- `start` finds nothing: the digits up to `i` are zero. -/
theorem start_none {as bs : Vector (BitVec 8) 256} :
    ∀ i (h : i < 256),
      start as bs i h = none → ∀ k (hk : k < 256), k ≤ i → as[k] = 0#8 ∧ bs[k] = 0#8
  | 0, _, hs, k, hk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · obtain rfl : k = 0 := by omega
      exact hz
  | i + 1, h, hs, k, hk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · by_cases hki' : k = i + 1
      · subst hki'
        exact hz
      · exact start_none i (by omega) hs k hk (by omega)

/-! ## `[a] A + [b] B` -/

/-- For `x < 2^255`, `slide`'s digits are in `[-15, 15]`, as `ge25519_double_scalarmult_vartime`
needs. -/
public theorem digits_of_lt {x : BitVec 256} (hx : x.toNat < 2 ^ 255) : Digits x := fun k hk => by
  rcases Boringssl.slide.spec_digit x hx hk with h | ⟨-, h⟩
  · rw [h, BitVec.toInt_zero]
    omega
  · exact h

/-- `ge25519_double_scalarmult_vartime` computes `[a] A + [b] B` in projective coordinates, limbs
below `2^52`, for `a, b < 2^255`. -/
public theorem spec_projLt {a b : BitVec 256} {A : GeP3} {PA : Point} (hA : A.ExtLt PA (2 ^ 52))
    (ha : a.toNat < 2 ^ 255) (hb : b.toNat < 2 ^ 255) :
    (ge25519_double_scalarmult_vartime.spec a A b).ProjLt (a.toNat • PA + b.toNat • basePoint)
      (2 ^ 52) := by
  have hai := fun k (_ : k < 8) => aiTbl_nielsLt hA k
  have hwa := fun k (hk : k < 256) => Boringssl.slide.spec_digit a ha hk
  have hwb := fun k (hk : k < 256) => Boringssl.slide.spec_digit b hb hk
  have s1 := Boringssl.slide.spec_sum a ha
  have s2 := Boringssl.slide.spec_sum b hb
  rw [← low_256] at s1 s2
  rw [← natCast_zsmul, ← natCast_zsmul, ← s1, ← s2]
  unfold ge25519_double_scalarmult_vartime.spec
  dsimp only
  generalize Boringssl.slide.spec a = w1 at *
  generalize Boringssl.slide.spec b = w2 at *
  split
  · rename_i i hs
    have hz1 : ∀ k (hk : k < 256), i.val + 1 ≤ k → w1[k] = 0#8 := fun k hk hik =>
      (start_some 255 (by decide) hs k hk (by omega) (by omega)).1
    have hz2 : ∀ k (hk : k < 256), i.val + 1 ≤ k → w2[k] = 0#8 := fun k hk hik =>
      (start_some 255 (by decide) hs k hk (by omega) (by omega)).2
    have e1 := low_add hz1 (255 - i.val) (by omega)
    have e2 := low_add hz2 (255 - i.val) (by omega)
    rw [show i.val + 1 + (255 - i.val) = 256 by omega] at e1 e2
    refine
      projLt_congr
        (ladder_projLt hai (fun k hk => biTbl_nielsLt hk) hwa hwb i i.isLt ge25519_p2_0.spec_projLt)
        ?_
    rw [e1, e2, smul_zero, zero_add]
  · rename_i hs
    have hz1 : ∀ k (hk : k < 256), 0 ≤ k → w1[k] = 0#8 := fun k hk _ =>
      (start_none 255 (by decide) hs k hk (by omega)).1
    have hz2 : ∀ k (hk : k < 256), 0 ≤ k → w2[k] = 0#8 := fun k hk _ =>
      (start_none 255 (by decide) hs k hk (by omega)).2
    have e1 := low_add hz1 256 (by omega)
    have e2 := low_add hz2 256 (by omega)
    simp only [Nat.zero_add] at e1 e2
    rw [e1, e2]
    simp only [low, Finset.range_zero, Finset.sum_empty, zero_smul, add_zero]
    exact ge25519_p2_0.spec_projLt

end ge25519_double_scalarmult_vartime

end MLIR.Sodium

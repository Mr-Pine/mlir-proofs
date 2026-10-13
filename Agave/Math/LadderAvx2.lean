module

public import Agave.Avx2.impl_mul.Spec
public import Agave.Math.CachedTable
public import Agave.Math.Ladder
import all Agave.Math.Ladder
import Mathlib.Tactic.Module

/-! `vartime_double_base::spec_avx2::mul` in `ZMod p`: `impl_mul.spec a A b` is `a A + b B` for
`a, b < 2^255`. `Serial.mul`'s ladder over the AVX2 forms: extended coordinates in a reduced
`FieldElement2625x4`, cached table entries, and `split` back to an `EdwardsPoint`. -/

namespace MLIR.Agave.Avx2

open _root_.Ed25519 _root_.MLIR.Agave.Fe2625x4 Serial.mul

namespace impl_mul

/-- Extended coordinates of `R`, reduced. -/
abbrev ER (v : Fe2625x4) (R : Point) : Prop :=
  IsExtOf v R ∧ Reduced v

theorem ER.congr {v : Fe2625x4} {R S : Point} (h : ER v R) (e : R = S) : ER v S :=
  e ▸ h

/-- A digit's add takes `v`, `R`, to `R + d P`, `T` holding `P`'s odd multiples. -/
theorem addDigit_ext {w : ℕ} {T : ℕ → Fe2625x4} {PT R : Point} {v : Fe2625x4} {d : BitVec 8}
    (hT : ∀ k, 2 * k + 1 < 2 ^ (w - 1) → IsCachedOf (T k) ((2 * k + 1) • PT) ∧ Reduced (T k))
    (hw : w ≤ 8) (hd : Naf.Digit w d.toInt) (hv : ER v R) :
    ER (addDigit T d v) (R + d.toInt • PT) := by
  unfold addDigit
  split_ifs with hp hn
  · obtain ⟨e, hk⟩ := idx_pos hd hp
    obtain ⟨hc, hl⟩ := hT _ hk
    have hs : (2 * (d >>> 1).toNat + 1) • PT = d.toInt • PT := by rw [← natCast_zsmul, e]
    rw [hs] at hc
    exact
      ExtendedPoint_Add_CachedPoint_add_impl_add.spec_val hv.1 hv.2 hc
        (hl.mono (by norm_num) (by norm_num))
  · obtain ⟨e, hk⟩ := idx_neg hw hd hn
    obtain ⟨hc, hl⟩ := hT _ hk
    obtain ⟨c, l⟩ := ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec_val hv.1 hv.2 hc hl
    have hs : R - (2 * ((-d) >>> 1).toNat + 1) • PT = R + d.toInt • PT := by
      rw [← natCast_zsmul, e, neg_smul, sub_neg_eq_add]
    rw [hs] at c
    exact ⟨c, l⟩
  · rw [eq_zero_of_not hp hn, BitVec.toInt_zero, zero_smul, add_zero]
    exact hv

/-- An iteration takes `v`, `R`, to `2 R + da A + db B`. -/
theorem step_ext {wa wb : ℕ} {tA tB : ℕ → Fe2625x4} {PA PB R : Point} {v : Fe2625x4}
    {da db : BitVec 8}
    (htA : ∀ k, 2 * k + 1 < 2 ^ (wa - 1) → IsCachedOf (tA k) ((2 * k + 1) • PA) ∧ Reduced (tA k))
    (htB : ∀ k, 2 * k + 1 < 2 ^ (wb - 1) → IsCachedOf (tB k) ((2 * k + 1) • PB) ∧ Reduced (tB k))
    (hwa : wa ≤ 8) (hwb : wb ≤ 8) (hda : Naf.Digit wa da.toInt) (hdb : Naf.Digit wb db.toInt)
    (hv : ER v R) : ER (step tA tB da db v) (2 • R + da.toInt • PA + db.toInt • PB) :=
  addDigit_ext htB hwb hdb
    (addDigit_ext htA hwa hda (ExtendedPoint_double_impl_double.spec_val hv.1 hv.2))

/-- The loop from `i` on `v`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_ext {wa wb : ℕ} {tA tB : ℕ → Fe2625x4} {PA PB : Point}
    {a_naf b_naf : BitVec (8 * 256)}
    (htA : ∀ k, 2 * k + 1 < 2 ^ (wa - 1) → IsCachedOf (tA k) ((2 * k + 1) • PA) ∧ Reduced (tA k))
    (htB : ∀ k, 2 * k + 1 < 2 ^ (wb - 1) → IsCachedOf (tB k) ((2 * k + 1) • PB) ∧ Reduced (tB k))
    (hwa : wa ≤ 8) (hwb : wb ≤ 8) (hda : ∀ k < 256, Naf.Digit wa (digit a_naf k).toInt)
    (hdb : ∀ k < 256, Naf.Digit wb (digit b_naf k).toInt) :
    ∀ i,
      i < 256 →
        ∀ {v : Fe2625x4} {R : Point},
          ER v R →
            ER (ladder tA tB a_naf b_naf i v)
              ((2 ^ (i + 1) : ℤ) • R + low a_naf (i + 1) • PA + low b_naf (i + 1) • PB)
  | 0, h, v, R, hv => by
    rw [ladder]
    refine (step_ext htA htB hwa hwb (hda 0 h) (hdb 0 h) hv).congr ?_
    simp only [low, Finset.sum_range_one, pow_zero, mul_one, zero_add, pow_one]
    module
  | i + 1, h, v, R, hv => by
    rw [ladder]
    have hl :=
      ladder_ext htA htB hwa hwb hda hdb i (by omega)
        (step_ext htA htB hwa hwb (hda _ h) (hdb _ h) hv)
    refine hl.congr ?_
    rw [low_succ a_naf (i + 1), low_succ b_naf (i + 1)]
    module

/-- A `split` limb of a reduced element: below `2^52`. -/
theorem split_lt {v : Fe2625x4} (hb : Reduced v) (e : Fin 4) : Limbs.Lt (split v e) (2 ^ 52) := by
  intro i
  obtain ⟨h0, h1⟩ := hb i e
  have := ((v i)[evenLane e]).isLt
  have := ((v i)[oddLane e]).isLt
  simp only [split, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega),
    Nat.mod_eq_of_lt (by omega)]
  omega

/-- `Q.into()` of extended coordinates of `R`, reduced: extended coordinates of `R` below
`2^52`. -/
theorem toEdwards_val {v : Fe2625x4} {R : Point} (h : ER v R) :
    (toEdwards v).Ext R.x R.y ∧ (toEdwards v).Lt (2 ^ 52) := by
  refine ⟨?_, split_lt h.2 0, split_lt h.2 1, split_lt h.2 2, split_lt h.2 3⟩
  have h1 := h.1
  unfold IsExtOf at h1
  simp only [EdwardsPoint.Ext, toEdwards, val_split]
  exact h1

end impl_mul

open
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from renaming
  spec_val → tableSpec_val

open impl_mul in
/-- `vartime_double_base::spec_avx2::mul(a, A, b)`, `A` extended below `2^53` of `Q`,
`a, b < 2^255`: extended coordinates of `a Q + b B`, below `2^52`. -/
public theorem impl_mul.spec_val {A : EdwardsPoint} {Q : Point} (hb : A.Lt (2 ^ 53))
    (h : A.Ext Q.x Q.y) {a b : BitVec 256} (ha : a.toNat < 2 ^ 255) (hb' : b.toNat < 2 ^ 255) :
    (impl_mul.spec a A b).Ext (a.toNat • Q + b.toNat • basePoint).x
        (a.toNat • Q + b.toNat • basePoint).y ∧
      (impl_mul.spec a A b).Lt (2 ^ 52) := by
  have hb58 : A.Lt (2 ^ 58) :=
    ⟨hb.1.mono (by norm_num), hb.2.1.mono (by norm_num), hb.2.2.1.mono (by norm_num),
      hb.2.2.2.mono (by norm_num)⟩
  have htA :
    ∀ k,
      2 * k + 1 < 2 ^ (5 - 1) →
        IsCachedOf (tableA A k) ((2 * k + 1) • Q) ∧ Reduced (tableA A k) := by
    intro k hk
    rw [show (2 : ℕ) ^ (5 - 1) = 16 from rfl] at hk
    exact tableSpec_val hb58 h ⟨k, by omega⟩
  have htB :
    ∀ k,
      2 * k + 1 < 2 ^ (8 - 1) →
        IsCachedOf (BASEPOINT_ODD_LOOKUP_TABLE.point k) ((2 * k + 1) • basePoint) ∧
          Reduced (BASEPOINT_ODD_LOOKUP_TABLE.point k) := by
    intro k hk
    rw [show (2 : ℕ) ^ (8 - 1) = 128 from rfl] at hk
    exact BASEPOINT_ODD_LOOKUP_TABLE.point_val (by omega)
  have hda := fun k (hk : k < 256) => digit_spec (w := 5) (by decide) (by decide) ha hk
  have hdb := fun k (hk : k < 256) => digit_spec (w := 8) (by decide) (by decide) hb' hk
  unfold impl_mul.spec
  dsimp only
  generalize hs :
    start (Scalar_non_adjacent_form.spec a 5) (Scalar_non_adjacent_form.spec b 8) 255 = s
  have hs255 : s ≤ 255 := hs ▸ start_le _ _ 255
  have hz :=
    hs ▸ start_zero (Scalar_non_adjacent_form.spec a 5) (Scalar_non_adjacent_form.spec b 8) 255
  have e1 :=
    low_add (j := s + 1) (fun k hk hk' => (hz k (by omega) (by omega)).1) (255 - s) (by omega)
  have e2 :=
    low_add (j := s + 1) (fun k hk hk' => (hz k (by omega) (by omega)).2) (255 - s) (by omega)
  rw [show s + 1 + (255 - s) = 256 by omega, low_256 (by decide) (by decide) ha] at e1
  rw [show s + 1 + (255 - s) = 256 by omega, low_256 (by decide) (by decide) hb'] at e2
  have hl :=
    ladder_ext htA htB (by decide) (by decide) hda hdb s (by omega) (v :=
      EXTENDEDPOINT_IDENTITY.point) (R := 0) EXTENDEDPOINT_IDENTITY.point_val
  exact
    toEdwards_val (hl.congr (by rw [← e1, ← e2, smul_zero, zero_add, natCast_zsmul, natCast_zsmul]))

end MLIR.Agave.Avx2

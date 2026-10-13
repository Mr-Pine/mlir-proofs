module

public import Agave.Math.ExtendedPoint
public import Agave.Math.CurveModels
public import Agave.Avx2.NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-! The AVX2 `NafLookupTable5<CachedPoint>::from(&P)` in `ZMod p`: `ExtendedPoint::from(P)`
(`Fe2625x4.new`) keeps `P`'s coordinates, and entry `i` holds cached coordinates of
`(2 i + 1) P`. -/

namespace MLIR.Agave

open _root_.Ed25519 _root_.MLIR.Agave.Fe2625x4

/-- `FieldElement2625x4::new(X, Y, Z, T)` of a point's limbs below `2^58`: extended coordinates of
the same point, reduced. -/
public theorem Fe2625x4.new_val {P : EdwardsPoint} {Q : Point} (hb : P.Lt (2 ^ 58))
    (h : P.Ext Q.x Q.y) :
    IsExtOf (Fe2625x4.new P.X P.Y P.Z P.T) Q ∧ Reduced (Fe2625x4.new P.X P.Y P.Z P.T) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hb
  have hv (e : Fin 4) :
    val (Fe2625x4.new P.X P.Y P.Z P.T) e = Limbs.val (![P.X, P.Y, P.Z, P.T] e) := by
    rw [Fe2625x4.new, val_reduce, val, nat_pack, Limbs.val_nat]
    intro i
    fin_cases e
    exacts [hX i, hY i, hZ i, hT i]
  refine ⟨?_, (reduce_bounded _).mono (by norm_num) (by norm_num)⟩
  unfold IsExtOf
  rw [hv, hv, hv, hv]
  exact h

namespace Avx2

open NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

/-- `Ai A A2 n`, for `A` extended coordinates of `Q` and `A2` of `2 Q`, both reduced: cached
coordinates of `(2 n + 1) Q`, reduced. -/
theorem
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.Ai_val
    {A A2 : Fe2625x4} {Q : Point} (hA : IsExtOf A Q) (hAb : Reduced A) (hA2 : IsExtOf A2 (2 • Q))
    (hA2b : Reduced A2) (n : ℕ) :
    IsCachedOf (Ai A A2 n) ((2 * n + 1) • Q) ∧ Reduced (Ai A A2 n) := by
  induction n with
  | zero =>
    simpa only [Ai, Nat.mul_zero, Nat.zero_add, one_nsmul] using
      CachedPoint_From_ExtendedPoint_from_impl_from.spec_val hA hAb
  | succ n
    ih =>
    obtain ⟨hs, hsb⟩ :=
      ExtendedPoint_Add_CachedPoint_add_impl_add.spec_val hA2 hA2b ih.1
        (ih.2.mono (by norm_num) (by norm_num))
    have he : 2 • Q + (2 * n + 1) • Q = (2 * (n + 1) + 1) • Q := by
      rw [← add_nsmul]; congr 1; ring
    rw [he] at hs
    exact CachedPoint_From_ExtendedPoint_from_impl_from.spec_val hs hsb

/-- `NafLookupTable5::<CachedPoint>::from(&P)` of a point's limbs below `2^58`, extended
coordinates of `Q`: entry `i` holds cached coordinates of `(2 i + 1) Q`, reduced. -/
public theorem
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.spec_val
    {P : EdwardsPoint} {Q : Point} (hb : P.Lt (2 ^ 58)) (h : P.Ext Q.x Q.y) (i : Fin 8) :
    IsCachedOf (spec P i) ((2 * i.val + 1) • Q) ∧ Reduced (spec P i) := by
  obtain ⟨hA, hAb⟩ := Fe2625x4.new_val hb h
  obtain ⟨hA2, hA2b⟩ := ExtendedPoint_double_impl_double.spec_val hA hAb
  exact Ai_val hA hAb hA2 hA2b i

end Avx2

end MLIR.Agave

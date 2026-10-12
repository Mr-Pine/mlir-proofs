module

public import Agave.Math.CurveModels
public import Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from
import Mathlib.Tactic.Ring

/-! `NafLookupTable5::<ProjectiveNielsPoint>::from(A)` in `ZMod p`: entry `i` holds Niels
coordinates of `(2 i + 1) A`. -/

namespace MLIR.Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

open _root_.Ed25519

/-- `A.double()` of extended coordinates below `2^53` of `Q`: extended ones of `2 Q`, below
`2^52`. -/
public theorem double_val {A : EdwardsPoint} {Q : Point} (hb : A.Lt (2 ^ 53)) (h : A.Ext Q.x Q.y) :
    (double A).Ext (2 • Q).x (2 • Q).y ∧ (double A).Lt (2 ^ 52) := by
  obtain ⟨hX, hY, hZ, -⟩ := hb
  obtain ⟨c, l⟩ :=
    ProjectivePoint_double.spec_val (P := ⟨A.X, A.Y, A.Z⟩) ⟨hX, hY, hZ⟩ (IsExt.isProj h) Q.on
  rw [Point.dbl_eq, ← two_nsmul] at c
  exact CompletedPoint_as_extended.spec_val l c

/-- `Ai[n]` of extended coordinates below `2^53` of `Q`: Niels coordinates of `(2 n + 1) Q`, below
`2^54`. -/
public theorem Ai_val {A : EdwardsPoint} {Q : Point} (hb : A.Lt (2 ^ 53)) (h : A.Ext Q.x Q.y)
    (n : ℕ) : (Ai A n).Niels ((2 * n + 1) • Q).x ((2 * n + 1) • Q).y ∧ (Ai A n).Lt (2 ^ 54) := by
  induction n with
  | zero =>
    simpa only [Ai, Nat.mul_zero, Nat.zero_add, one_nsmul] using
      EdwardsPoint_as_projective_niels.spec_val hb h
  | succ n ih =>
    obtain ⟨hd, ⟨dX, dY, dZ, dT⟩⟩ := double_val hb h
    obtain ⟨c, l⟩ :=
      EdwardsPoint_Add_ProjectiveNielsPoint_add.spec_val
        ⟨dX.mono (by norm_num), dY.mono (by norm_num), dZ.mono (by norm_num), dT.mono (by norm_num)⟩
        ih.2 hd ih.1 (2 • Q).on ((2 * n + 1) • Q).on
    obtain ⟨e, ⟨eX, eY, eZ, eT⟩⟩ := CompletedPoint_as_extended.spec_val l c
    have hs : 2 • Q + (2 * n + 1) • Q = (2 * (n + 1) + 1) • Q := by
      rw [← add_nsmul]; congr 1; ring
    rw [← Point.add_x, ← Point.add_y, hs] at e
    exact
      EdwardsPoint_as_projective_niels.spec_val
        ⟨eX.mono (by norm_num), eY.mono (by norm_num), eZ.mono (by norm_num), eT.mono (by norm_num)⟩
        e

/-- `NafLookupTable5::<ProjectiveNielsPoint>::from(A)` of extended coordinates below `2^53` of `Q`:
entry `i` holds Niels coordinates of `(2 i + 1) Q`, below `2^54`. -/
public theorem spec_val {A : EdwardsPoint} {Q : Point} (hb : A.Lt (2 ^ 53)) (h : A.Ext Q.x Q.y)
    (i : Fin 8) :
    (spec A i).Niels ((2 * i.val + 1) • Q).x ((2 * i.val + 1) • Q).y ∧ (spec A i).Lt (2 ^ 54) :=
  Ai_val hb h i

end MLIR.Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

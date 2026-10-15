module

public import Firedancer.Secp256k1.Math.Point
public import Firedancer.Secp256k1.Math.Slide
import Mathlib.Tactic.Module

/-! `fd_secp256k1_precompute` and `fd_secp256k1_double_base_mul` on any backend meeting
`Backend.Spec`: the tables hold `i • P`, every table read is in bounds, and the result represents
`s1 • G + s2 • P2`. -/

namespace Firedancer.Secp256k1

open Finset Formulas
variable {B : Backend}

/-- `fd_secp256k1_precompute` stores a representative of `i • P` at index `i`. -/
public theorem fd_secp256k1_precompute.spec_rep (hB : B.Spec) {a : fd_secp256k1_point_t}
    {P : ECPoint} (ha : PRep a P) :
    ∀ (i : ℕ) (hi : i < 9), PRep (fd_secp256k1_precompute.spec B a)[i] (i • P) := by
  suffices h :
    ∀ (i : ℕ) (hi : i < 9), i < 7 + 2 → PRep (fd_secp256k1_precompute.spec B a)[i] (i • P) from
    fun i hi => h i hi (by omega)
  unfold fd_secp256k1_precompute.spec
  extract_lets  r0 r1 r2
  exact
    fold_induct (P := fun k (r : Vector fd_secp256k1_point_t 9) =>
      ∀ (i : ℕ) (hi : i < 9), i < k + 2 → PRep r[i] (i • P)) 7 _ r2
      (by
        intro i hi hk
        simp only [r2, r1, Vector.getElem_set]
        split_ifs with e1 e0
        · subst e1; rw [one_nsmul, fd_secp256k1_point_set.spec_eq hB]; exact ha
        · subst e0; rw [zero_nsmul]; exact fd_secp256k1_point_set_identity.spec_rep hB
        · omega)
      (by
        intro k hk r hr i hi hi'
        dsimp only
        split_ifs with hodd
        · rw [Vector.getElem_set]
          split_ifs with e
          · subst e
            have := PRep.add hB (hr (k + 2 - 1) (by omega) (by omega)) ha
            rwa [← succ_nsmul, show k + 2 - 1 + 1 = k + 2 by omega] at this
          · exact hr i hi (by omega)
        · rw [Vector.getElem_set]
          split_ifs with e
          · subst e
            have := PRep.dbl hB (hr ((k + 2) / 2) (by omega) (by omega))
            rwa [smul_smul, show 2 * ((k + 2) / 2) = k + 2 by omega] at this
          · exact hr i hi (by omega))

/-- A table read at a digit in `[-8, 8]` adds `d • P`, and stays in bounds. -/
theorem table_step (hB : B.Spec) {pc : Vector fd_secp256k1_point_t 9} {P : ECPoint}
    (hpc : ∀ (i : ℕ) (hi : i < 9), PRep pc[i] (i • P)) {d : BitVec 8} (hl : -8 ≤ d.toInt)
    (hu : d.toInt ≤ 8) {r : fd_secp256k1_point_t} {A : ECPoint} (hr : PRep r A) :
    PRep
      (if (0#32).slt (d.signExtend 32) then
        fd_secp256k1_point_add.spec B r (fd_secp256k1_point_table_read pc (d.signExtend 64))
      else
        if (d.signExtend 32).slt 0#32 then
          fd_secp256k1_point_sub.spec B r
            (fd_secp256k1_point_table_read pc ((-(d.signExtend 32)).signExtend 64))
        else r)
      (A + d.toInt • P) := by
  obtain ⟨hpos, hneg, ipos, ineg⟩ := digit_index hl hu
  by_cases h1 : 0 < d.toInt
  · have hi := ipos h1
    have hlt : (d.signExtend 64).toNat < 9 := by omega
    rw [ite_eq_left (hpos.2 h1), fd_secp256k1_point_table_read, dite_eq_left hlt]
    have := PRep.add hB hr (hpc _ hlt)
    rwa [← natCast_zsmul, hi] at this
  · rw [ite_eq_right (fun h => h1 (hpos.1 h))]
    by_cases h2 : d.toInt < 0
    · have hi := ineg h2
      have hlt : ((-(d.signExtend 32)).signExtend 64).toNat < 9 := by omega
      rw [ite_eq_left (hneg.2 h2), fd_secp256k1_point_table_read, dite_eq_left hlt]
      have := PRep.sub hB hr (hpc _ hlt)
      rwa [← natCast_zsmul, hi, neg_zsmul, sub_neg_eq_add] at this
    · rw [ite_eq_right (fun h => h2 (hneg.1 h)), show d.toInt = 0 by omega, zero_zsmul, add_zero]
      exact hr

/-- Every table index the loop reads at a `slide` digit is below `9`: the out-of-bounds read is
never taken. -/
public theorem fd_secp256k1_slide.reads_in_bounds (s : Vector (BitVec 8) 32) {k : ℕ} (hk : k < 65) :
    ((0#32).slt ((fd_secp256k1_slide.spec s)[k].signExtend 32) = true →
        ((fd_secp256k1_slide.spec s)[k].signExtend 64).toNat < 9) ∧
      (((fd_secp256k1_slide.spec s)[k].signExtend 32).slt 0#32 = true →
        ((-((fd_secp256k1_slide.spec s)[k].signExtend 32)).signExtend 64).toNat < 9) := by
  obtain ⟨hl, hu⟩ := fd_secp256k1_slide.digit_bounds s hk
  obtain ⟨hpos, hneg, ipos, ineg⟩ := digit_index hl hu
  exact
    ⟨fun h => by
      have := ipos (hpos.1 h); omega, fun h => by
      have := ineg (hneg.1 h); omega⟩

/-- The loop from `pos` down, started at a representative of `A`, represents
`16^pos • A + (Σ_{k ≤ pos} e1ₖ 16ᵏ) • P1 + (Σ_{k ≤ pos} e2ₖ 16ᵏ) • P2`. -/
theorem fd_secp256k1_double_base_mul.loop_rep (hB : B.Spec)
    {pc1 pc2 : Vector fd_secp256k1_point_t 9} {P1 P2 : ECPoint}
    (hpc1 : ∀ (i : ℕ) (hi : i < 9), PRep pc1[i] (i • P1))
    (hpc2 : ∀ (i : ℕ) (hi : i < 9), PRep pc2[i] (i • P2)) {e1 e2 : Vector (BitVec 8) 65}
    (he1 : ∀ (k : ℕ) (hk : k < 65), -8 ≤ e1[k].toInt ∧ e1[k].toInt ≤ 8)
    (he2 : ∀ (k : ℕ) (hk : k < 65), -8 ≤ e2[k].toInt ∧ e2[k].toInt ≤ 8) :
    ∀ (pos : ℕ) (h : pos ≤ 64) (r : fd_secp256k1_point_t) (A : ECPoint),
      PRep r A →
        PRep (fd_secp256k1_double_base_mul.loop B pc1 pc2 e1 e2 pos h r)
          (16 ^ pos • A + (∑ k ∈ range (pos + 1), digitTerm e1 k) • P1 +
            (∑ k ∈ range (pos + 1), digitTerm e2 k) • P2) := by
  intro pos
  induction pos with
  | zero =>
    intro h r A hr
    rw [fd_secp256k1_double_base_mul.loop]
    have h1 := table_step hB hpc1 (he1 0 (by omega)).1 (he1 0 (by omega)).2 hr
    have h2 := table_step hB hpc2 (he2 0 (by omega)).1 (he2 0 (by omega)).2 h1
    convert h2 using 1
    simp [digitTerm]
  | succ pos ih =>
    intro h r A hr
    rw [fd_secp256k1_double_base_mul.loop]
    have h1 := table_step hB hpc1 (he1 (pos + 1) (by omega)).1 (he1 (pos + 1) (by omega)).2 hr
    have h2 := table_step hB hpc2 (he2 (pos + 1) (by omega)).1 (he2 (pos + 1) (by omega)).2 h1
    have h3 := PRep.dbl hB (PRep.dbl hB (PRep.dbl hB (PRep.dbl hB h2)))
    have := ih (by omega) _ _ h3
    convert this using 1
    rw [sum_range_succ _ (pos + 1), sum_range_succ _ (pos + 1)]
    simp only [digitTerm, dite_eq_left (show pos + 1 < 65 by omega)]
    rw [← natCast_zsmul, ← natCast_zsmul, ← natCast_zsmul, ← natCast_zsmul, ← natCast_zsmul, ←
      natCast_zsmul]
    push_cast
    module

/-- `fd_secp256k1_double_base_mul` represents `s1 • G + s2 • P2`, for the scalars' values. -/
public theorem fd_secp256k1_double_base_mul.spec_rep (hB : B.Spec) (s1 s2 : fd_secp256k1_scalar_t)
    {p2 : fd_secp256k1_point_t} {P2 : ECPoint} (hp2 : PRep p2 P2) :
    PRep (fd_secp256k1_double_base_mul.spec B s1 p2 s2)
      (limbsEval s1 • basePoint + limbsEval s2 • P2) := by
  unfold fd_secp256k1_double_base_mul.spec
  have :=
    fd_secp256k1_double_base_mul.loop_rep hB
      (fd_secp256k1_precompute.spec_rep hB (fd_secp256k1_point_set_base.spec_rep hB))
      (fd_secp256k1_precompute.spec_rep hB hp2)
      (fun k hk => fd_secp256k1_slide.digit_bounds s1.buf hk)
      (fun k hk => fd_secp256k1_slide.digit_bounds s2.buf hk) 64 (by omega) _ _
      (fd_secp256k1_point_set_identity.spec_rep hB)
  rw [fd_secp256k1_slide.sum_digitTerm, fd_secp256k1_slide.sum_digitTerm, leNat_buf, leNat_buf,
    nsmul_zero, zero_add, natCast_zsmul, natCast_zsmul] at this
  exact this

end Firedancer.Secp256k1

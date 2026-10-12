module

public import MLIR.Run.Tactic
public import Agave.Common.LimbQuads
public import Agave.Serial.ProjectivePoint_double
public import Agave.Avx2.FieldElement51_Add_add
public import Agave.Avx2.FieldElement51_Sub_sub
public import Agave.Avx2.Mlir.ProjectivePoint_double
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- The first limb quad of limbs that fit: the four limbs. -/
theorem readAt_quad0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    m.readAt p 256 =
      m.readAt (p.add 24#64) 64 ++
        (m.readAt (p.add 16#64) 64 ++ (m.readAt (p.add 8#64) 64 ++ m.readAt p 64)) := by
  rw [MemoryState.readAt_of_readAt_le (w := 256) (v := 320) (by decide) (readAt_eq_limbsBits h)]
  simp only [limbsBits, MemoryState.readLimbs]
  bv_decide

/-- The four 64-bit lanes of `x3 ++ x2 ++ x1 ++ x0`. -/
theorem lanes_append (x3 x2 x1 x0 : BitVec 64) :
    (x3 ++ (x2 ++ (x1 ++ x0))).extractLsb' 0 64 = x0 ∧
      (x3 ++ (x2 ++ (x1 ++ x0))).extractLsb' 64 64 = x1 ∧
      (x3 ++ (x2 ++ (x1 ++ x0))).extractLsb' 128 64 = x2 ∧
      (x3 ++ (x2 ++ (x1 ++ x0))).extractLsb' 192 64 = x3 := by
  bv_decide

/-- The limbs `square2` leaves: `pow2k(1)`'s, each shifted by one, stored as the quad at byte 0
and the last limb. -/
theorem square2_readLimbs {m : MemoryState} {p : Pointer} (a : Fin 5 → BitVec 64) (h : m.LimbsFit p)
    (h0 :
      m.readAt p 256 =
        BitVec.packLanes
          (Vector.ofFn fun i =>
            Ty.extractVecElem 4 64 i
                (Serial.FieldElement51_pow2k.spec a 1 3 ++
                  (Serial.FieldElement51_pow2k.spec a 1 2 ++
                    (Serial.FieldElement51_pow2k.spec a 1 1 ++
                      Serial.FieldElement51_pow2k.spec a 1 0))) <<<
              1))
    (h4 : m.readAt (p.add 32#64) 64 = Serial.FieldElement51_pow2k.spec a 1 4 <<< 1) :
    m.readLimbs p = Serial.FieldElement51_square2.spec a := by
  funext i
  have hl (j : Fin 4) := lane_readAt0 h j
  simp only [h0, Ty.extractVecElem_packLanes] at hl
  fin_cases i
  · refine (hl 0).symm.trans ?_
    simp only [Fin.getElem_fin, Vector.getElem_ofFn, Ty.extractVecElem_eq,
      Serial.FieldElement51_square2.spec]
    congr 1
    exact (lanes_append _ _ _ _).1
  · refine (hl 1).symm.trans ?_
    simp only [Fin.getElem_fin, Vector.getElem_ofFn, Ty.extractVecElem_eq,
      Serial.FieldElement51_square2.spec]
    congr 1
    exact (lanes_append _ _ _ _).2.1
  · refine (hl 2).symm.trans ?_
    simp only [Fin.getElem_fin, Vector.getElem_ofFn, Ty.extractVecElem_eq,
      Serial.FieldElement51_square2.spec]
    congr 1
    exact (lanes_append _ _ _ _).2.2.1
  · refine (hl 3).symm.trans ?_
    simp only [Fin.getElem_fin, Vector.getElem_ofFn, Ty.extractVecElem_eq,
      Serial.FieldElement51_square2.spec]
    congr 1
    exact (lanes_append _ _ _ _).2.2.2
  · exact h4

/-- Field elements stored at bytes 0, 120, 40, 80: `storeFe4`'s. -/
theorem storeFe4_of_XTYZ {m : MemoryState} {p : Pointer} (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (((m.storeLimbs p a).storeLimbs (p.add 120#64) d).storeLimbs (p.add 40#64) b).storeLimbs
        (p.add 80#64) c =
      m.storeFe4 p a b c d := by
  rw [MemoryState.storeLimbs_comm_coord (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    MemoryState.storeLimbs_comm_coord (a := 120) (b := 80) hp (by omega) (by omega) (by omega)]
  rfl

/-- `P.double()` stores `Serial.ProjectivePoint_double.spec P` at `out`. Every read of `P` comes
before the first store to `out`, so `out` may alias it. Its seven temporaries count seven blocks. -/
public theorem ProjectivePoint_double.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PointRoom out) (hp : s.mem.ProjectiveFit p) :
    ProjectivePoint_double.call (ProjectivePoint_double.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storeCompleted out
                (Serial.ProjectivePoint_double.spec (s.mem.readProjective p)) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_alloca with yy_minus_xx
  step_alloca with yy_plus_xx
  step_alloca with x_plus_y_sq
  step_alloca with x_plus_y
  step_alloca with zz2
  step_alloca with yy
  step_alloca with xx
  -- let XX = self.X.square();
  step_pure
  limbs_room xx
  step_call using Serial.FieldElement51_square.call_eq
  name_limbs XX
  -- let YY = self.Y.square();
  step_pure
  limbs_room yy
  step_pure
  step_call using Serial.FieldElement51_square.call_eq
  name_limbs YY
  -- let ZZ2 = self.Z.square2();
  step_pure
  limbs_room zz2
  step_pure
  step_call using
    (Serial.FieldElement51_pow2k.call_eq (k := 1#32) (hk0 := by decide) (hk := by decide))
  name_limbs ZZ
  have hq : S.mem.readAt zz2 256 = ZZ 3 ++ (ZZ 2 ++ (ZZ 1 ++ ZZ 0)) := by
    rw [readAt_quad0 hzz2_limbs, ← hread_zz2_readLimbs]
    rfl
  have h4 : S.mem.readAt (zz2.add 32#64) 64 = ZZ 4 := by
    rw [← hread_zz2_readLimbs]
    rfl
  have hzz2_q := fits_quad0 hzz2_limbs
  clear hread_zz2 hread_zz2_readLimbs
  step_load
  step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  have hread_zz2_limbs := square2_readLimbs _ hzz2_limbs hread_zz2 hread_zz2_32
  clear hread_zz2 hread_zz2_32 hzz2_q
  -- let X_plus_Y = &self.X + &self.Y;
  step_pure
  limbs_room x_plus_y
  step_call using FieldElement51_Add_add.call_eq
  name_limbs X_plus_Y
  -- let X_plus_Y_sq = X_plus_Y.square();
  step_pure
  limbs_room x_plus_y_sq
  step_call using Serial.FieldElement51_square.call_eq consuming hread_x_plus_y
    hread_x_plus_y_readLimbs hx_plus_y_limbs
  name_limbs X_plus_Y_sq
  -- let YY_plus_XX = &YY + &XX;
  step_pure
  limbs_room yy_plus_xx
  step_call using FieldElement51_Add_add.call_eq
  name_limbs YY_plus_XX
  -- let YY_minus_XX = &YY - &XX;
  step_pure
  limbs_room yy_minus_xx
  step_call using FieldElement51_Sub_sub.call_eq consuming hread_xx hread_xx_readLimbs hxx_limbs
    hread_yy hread_yy_readLimbs hyy_limbs
  name_limbs YY_minus_XX
  -- CompletedPoint { X: &X_plus_Y_sq - &YY_plus_XX, Y: YY_plus_XX, Z: YY_minus_XX,
  --   T: &ZZ2 - &YY_minus_XX }
  step_call using FieldElement51_Sub_sub.call_eq consuming hread_x_plus_y_sq
    hread_x_plus_y_sq_readLimbs hx_plus_y_sq_limbs
  step_pure
  step_call using FieldElement51_Sub_sub.call_eq consuming hread_zz2_limbs hzz2_limbs
  step_pure
  have hroom_Y := room_of_limbsRoom hout.limbsRoom_Y
  have hfits_Y := fits_of_limbsFit hyy_plus_xx_limbs
  step_memcpy
  step_pure
  have hroom_Z := room_of_limbsRoom hout.limbsRoom_T
  have hfits_Z := fits_of_limbsFit hyy_minus_xx_limbs
  step_memcpy
  iterate 7 step_pure
  finish_block
  have ho := hout.1
  clear_reads
  subst hS
  erase_frame
  rw [← storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 40) ho (by omega)), ←
    storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 80) ho (by omega)), storeFe4_of_XTYZ ho]
  subst_vars
  rfl

end Proof

end MLIR.Agave.Avx2

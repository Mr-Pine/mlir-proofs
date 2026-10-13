module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Firedancer.Common.Tactics
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.Mlir.ProjectivePoint_double
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `self.square2()`: `self.pow2k(1)`, each limb doubled (`*= 2`, a shift). -/
def FieldElement51_square2.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 := fun i =>
  FieldElement51_pow2k.spec a 1 i <<< 1

/-- `ProjectivePoint::double`, named as in the Rust: the double is
`((X + Y)² - (Y² + X²), Y² + X², Y² - X², 2 Z² - (Y² - X²))`. -/
def ProjectivePoint_double.spec (P : ProjectivePoint) : CompletedPoint :=
  let XX := FieldElement51_square.spec P.X
  let YY := FieldElement51_square.spec P.Y
  let ZZ2 := FieldElement51_square2.spec P.Z
  let X_plus_Y := FieldElement51_Add_add.spec P.X P.Y
  let X_plus_Y_sq := FieldElement51_square.spec X_plus_Y
  let YY_plus_XX := FieldElement51_Add_add.spec YY XX
  let YY_minus_XX := FieldElement51_Sub_sub.spec YY XX
  ⟨FieldElement51_Sub_sub.spec X_plus_Y_sq YY_plus_XX, YY_plus_XX, YY_minus_XX,
    FieldElement51_Sub_sub.spec ZZ2 YY_minus_XX⟩

end

/-! ## Proof -/

section Proof

theorem extractLsb'_append_lo (x y : BitVec 64) : (x ++ y).extractLsb' 0 64 = y := by bv_decide

theorem extractLsb'_append_hi (x y : BitVec 64) : (x ++ y).extractLsb' 64 64 = x := by bv_decide

theorem split_lanes (x : BitVec 128) :
    x = Ty.extractVecElem 2 64 1 x ++ Ty.extractVecElem 2 64 0 x := by
  simp only [Ty.extractVecElem_eq, Fin.val_one, Fin.val_zero]
  bv_decide

/-- The first limb pair of limbs that fit: the two limbs. -/
theorem readAt_pair0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    m.readAt p 128 = m.readAt (p.add 8#64) 64 ++ m.readAt p 64 := by
  rw [← lane1_readAt0 h, ← lane0_readAt]
  exact split_lanes _

/-- The limb pair at byte `k ≤ 24` of limbs that fit: the two limbs. -/
theorem readAt_pair {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) {k : BitVec 64}
    (hk : k.toNat ≤ 24) :
    m.readAt (p.add k) 128 = m.readAt (p.add (k + 8#64)) 64 ++ m.readAt (p.add k) 64 := by
  rw [← lane1_readAt h hk, ← lane0_readAt]
  exact split_lanes _

/-- The limbs `square2` leaves: `pow2k(1)`'s, each shifted by one, stored as the pairs at bytes 0
and 16 and the last limb. -/
theorem square2_readLimbs {m : MemoryState} {p : Pointer} (a : Fin 5 → BitVec 64) (h : m.LimbsFit p)
    (h0 :
      m.readAt p 128 =
        BitVec.packLanes
          (Vector.ofFn fun i =>
            Ty.extractVecElem 2 64 i
                (FieldElement51_pow2k.spec a 1 1 ++ FieldElement51_pow2k.spec a 1 0) <<<
              1))
    (h1 :
      m.readAt (p.add 16#64) 128 =
        BitVec.packLanes
          (Vector.ofFn fun i =>
            Ty.extractVecElem 2 64 i
                (FieldElement51_pow2k.spec a 1 3 ++ FieldElement51_pow2k.spec a 1 2) <<<
              1))
    (h2 : m.readAt (p.add 32#64) 64 = FieldElement51_pow2k.spec a 1 4 <<< 1) :
    m.readLimbs p = FieldElement51_square2.spec a := by
  funext i
  fin_cases i
  · show m.readAt p 64 = _
    rw [← lane0_readAt, h0, Ty.extractVecElem_packLanes]
    simp [Ty.extractVecElem_eq, FieldElement51_square2.spec, extractLsb'_append_lo]
  · show m.readAt (p.add 8#64) 64 = _
    rw [← lane1_readAt0 h, h0, Ty.extractVecElem_packLanes]
    simp [Ty.extractVecElem_eq, FieldElement51_square2.spec, extractLsb'_append_hi]
  · show m.readAt (p.add 16#64) 64 = _
    rw [← lane0_readAt, h1, Ty.extractVecElem_packLanes]
    simp [Ty.extractVecElem_eq, FieldElement51_square2.spec, extractLsb'_append_lo]
  · show m.readAt (p.add 24#64) 64 = _
    rw [show (24#64 : BitVec 64) = 16#64 + 8#64 from rfl, ← lane1_readAt h (by decide), h1,
      Ty.extractVecElem_packLanes]
    simp [Ty.extractVecElem_eq, FieldElement51_square2.spec, extractLsb'_append_hi]
  · exact h2

/-- Field elements stored at bytes 0, 120, 40, 80: `storeFe4`'s. -/
theorem storeFe4_of_XTYZ {m : MemoryState} {p : Pointer} (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (((m.storeLimbs p a).storeLimbs (p.add 120#64) d).storeLimbs (p.add 40#64) b).storeLimbs
        (p.add 80#64) c =
      m.storeFe4 p a b c d := by
  rw [MemoryState.storeLimbs_comm_coord (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    MemoryState.storeLimbs_comm_coord (a := 120) (b := 80) hp (by omega) (by omega) (by omega)]
  rfl

/-- `P.double()` stores `spec P` at `out`. Every read of `P` comes before the first store to `out`,
so `out` may alias it. Its seven temporaries count seven blocks. -/
public theorem ProjectivePoint_double.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PointRoom out) (hp : s.mem.ProjectiveFit p) :
    ProjectivePoint_double.call (ProjectivePoint_double.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storeCompleted out
                (ProjectivePoint_double.spec (s.mem.readProjective p)) }) := by
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
  step_call using FieldElement51_square.call_eq
  name_limbs XX
  -- let YY = self.Y.square();
  step_pure
  limbs_room yy
  step_pure
  step_call using FieldElement51_square.call_eq
  name_limbs YY
  -- let ZZ2 = self.Z.square2();
  step_pure
  limbs_room zz2
  step_pure
  step_call using (FieldElement51_pow2k.call_eq (k := 1#32) (hk0 := by decide) (hk := by decide))
  name_limbs ZZ
  have hlo : S.mem.readAt zz2 128 = ZZ 1 ++ ZZ 0 := by
    rw [readAt_pair0 hzz2_limbs, ← hread_zz2_readLimbs]
    rfl
  have hhi : S.mem.readAt (zz2.add 16#64) 128 = ZZ 3 ++ ZZ 2 := by
    rw [readAt_pair hzz2_limbs (k := 16#64) (by decide), ← hread_zz2_readLimbs]
    rfl
  have h4 : S.mem.readAt (zz2.add 32#64) 64 = ZZ 4 := by
    rw [← hread_zz2_readLimbs]
    rfl
  have hzz2_lo := fits_pair0 hzz2_limbs
  have hzz2_hi := fits_pair hzz2_limbs (k := 16#64) (by decide)
  clear hread_zz2 hread_zz2_readLimbs
  step_load
  step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  rw [hZZ] at hread_zz2 hread_zz2_16 hread_zz2_32
  have hread_zz2_limbs := square2_readLimbs _ hzz2_limbs hread_zz2 hread_zz2_16 hread_zz2_32
  clear hread_zz2 hread_zz2_16 hread_zz2_32 hzz2_lo hzz2_hi
  -- let X_plus_Y = &self.X + &self.Y;
  step_pure
  limbs_room x_plus_y
  step_call using FieldElement51_Add_add.call_eq
  name_limbs X_plus_Y
  -- let X_plus_Y_sq = X_plus_Y.square();
  step_pure
  limbs_room x_plus_y_sq
  step_call using FieldElement51_square.call_eq consuming hread_x_plus_y hread_x_plus_y_readLimbs
    hx_plus_y_limbs
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

end MLIR.Agave.Serial

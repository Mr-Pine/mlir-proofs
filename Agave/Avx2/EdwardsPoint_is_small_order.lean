module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Agave.Common.Tactics
public import Firedancer.Common.Tactics
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Avx2.ProjectivePoint_double
public import Agave.Avx2.Mlir.EdwardsPoint_is_small_order
import all MLIR.Ty

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `CompletedPoint::as_projective`, inlined: the three products of the completed point at `q`
(`q40 q80 q120` its coordinates) into `o` (`o40 o80`). -/
def asProjRun (o o40 o80 q q40 q80 q120 : Reg Γ .ptr) : List (Instr Γ) :=
  [.call Serial.FieldElement51_Mul_mul.call (.cons o (.cons q (.cons q120 .nil))) .nil,
    .call Serial.FieldElement51_Mul_mul.call (.cons o40 (.cons q40 (.cons q80 .nil))) .nil,
    .call Serial.FieldElement51_Mul_mul.call (.cons o80 (.cons q80 (.cons q120 .nil))) .nil]

/-- Where the body at `pos` is `asProjRun` of `O` and `Q`: running on from `pos` then `g` gives
`K` if it does from `pos + 3` with `as_projective.spec` of `Q` stored at `O`. -/
theorem runBodyFrom_asProjRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {o o40 o80 q q40 q80 q120 : Reg Γ .ptr} {rest : List (Instr Γ)} {O Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = asProjRun o o40 o80 q q40 q80 q120 ++ rest)
    (ho : E.read o = .value O) (ho40 : E.read o40 = .value (O.add 40#64))
    (ho80 : E.read o80 = .value (O.add 80#64)) (hq : E.read q = .value Q)
    (hq40 : E.read q40 = .value (Q.add 40#64)) (hq80 : E.read q80 = .value (Q.add 80#64))
    (hq120 : E.read q120 = .value (Q.add 120#64)) (hwf : S.WF) (hO : S.mem.ProjectiveRoom O)
    (hQ : S.mem.PointFit Q) (hsep : O.id ≠ Q.id)
    (hK :
      (blk.runBodyFrom E (pos + 3)
            { S with
              mem :=
                S.mem.storeProjective O
                  (Serial.CompletedPoint_as_projective.spec (S.mem.readCompleted Q)) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  rw [← hK, hS]
  rfl

/-- `CompletedPoint::as_extended`, inlined: the four products of the completed point at `q`
(`q120` its `T`) into `o`, with the coordinates' `getelementptr`s between them. -/
def asExtRun (o q q120 q40 q80 o40 o80 o120 : Dst Γ .ptr) : List (Instr Γ) :=
  [.call Serial.FieldElement51_Mul_mul.call
      (.cons (.val o.i o.h) (.cons (.val q.i q.h) (.cons (.val q120.i q120.h) .nil))) .nil,
    .unop (.gepConst { nusw := true, nuw := true } 40) q40 (.val q.i q.h),
    .unop (.gepConst { nusw := true, nuw := true } 80) q80 (.val q.i q.h),
    .unop (.gepConst { nusw := true, nuw := true } 40) o40 (.val o.i o.h),
    .call Serial.FieldElement51_Mul_mul.call
      (.cons (.val o40.i o40.h) (.cons (.val q40.i q40.h) (.cons (.val q80.i q80.h) .nil))) .nil,
    .unop (.gepConst { nusw := true, nuw := true } 80) o80 (.val o.i o.h),
    .call Serial.FieldElement51_Mul_mul.call
      (.cons (.val o80.i o80.h) (.cons (.val q80.i q80.h) (.cons (.val q120.i q120.h) .nil))) .nil,
    .unop (.gepConst { nusw := true, nuw := true } 120) o120 (.val o.i o.h),
    .call Serial.FieldElement51_Mul_mul.call
      (.cons (.val o120.i o120.h) (.cons (.val q.i q.h) (.cons (.val q40.i q40.h) .nil))) .nil]

/-- Where the body at `pos` is `asExtRun` of `O` and `Q`: running on from `pos` then `g` gives `K`
if it does from `pos + 9` with `as_extended.spec` of `Q` stored at `O` and the coordinates'
pointers in their registers. -/
theorem runBodyFrom_asExtRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {o q q120 q40 q80 o40 o80 o120 : Dst Γ .ptr} {rest : List (Instr Γ)} {O Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = asExtRun o q q120 q40 q80 o40 o80 o120 ++ rest)
    (ho : E.read (.val o.i o.h) = .value O) (hq : E.read (.val q.i q.h) = .value Q)
    (hq120 : E.read (.val q120.i q120.h) = .value (Q.add 120#64))
    (hd : [o.i, q.i, q120.i, q40.i, q80.i, o40.i, o80.i, o120.i].Nodup) (hwf : S.WF)
    (hO : S.mem.PointRoom O) (hQ : S.mem.PointFit Q) (hsep : O.id ≠ Q.id)
    (hK :
      (blk.runBodyFrom
            E[q40 := .value (Q.add 40#64), q80 := .value (Q.add 80#64), o40 := .value (O.add 40#64),
              o80 := .value (O.add 80#64), o120 := .value (O.add 120#64)]
            (pos + 9)
            { S with
              mem :=
                S.mem.storeEdwards O
                  (Serial.CompletedPoint_as_extended.spec (S.mem.readCompleted Q)) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  step_pure
  step_pure
  step_pure
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  step_pure
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  step_pure
  step_call using Serial.FieldElement51_Mul_mul.call_eq
  rw [hE, ← hK, hS]
  rfl

/-- `identity()`'s stores: `X` and `T` zeroed, `ONE` copied into `Y` and `Z`. -/
theorem storeAt_eq_storeEdwards_identity {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (((m.storeAt p 0#320).storeAt (p.add 40#64) (limbsBits Serial.FieldElement51.ONE)).storeAt
            (p.add 80#64) (limbsBits Serial.FieldElement51.ONE)).storeAt
        (p.add 120#64) 0#320 =
      m.storeEdwards p Serial.EdwardsPoint_identity.spec := by
  have h0 : (0#320 : BitVec 320) = limbsBits Serial.FieldElement51.ZERO := by
    simp [limbsBits, Serial.FieldElement51.ZERO]
  rw [h0, ← storeLimbs_eq_storeAt (by omega : p.offset.toNat + 32 < 2 ^ 64), ←
    storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 40) hp (by omega)), ←
    storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 80) hp (by omega)), ←
    storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 120) hp (by omega))]
  rfl

/-- `EdwardsPoint::as_projective`'s copies, `Y`, `Z`, then `X`: a `ProjectivePoint` store. -/
theorem storeAt_limbsBits_eq_storeProjective {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 120 ≤ 2 ^ 64) (a b c : Fin 5 → BitVec 64) :
    ((m.storeAt (p.add 40#64) (limbsBits b)).storeAt (p.add 80#64) (limbsBits c)).storeAt p
        (limbsBits a) =
      m.storeProjective p ⟨a, b, c⟩ := by
  have h0 : p.offset.toNat + 32 < 2 ^ 64 := by omega
  have h40 := Pointer.coord_offset_le (a := 40) hp (by omega)
  have h80 := Pointer.coord_offset_le (a := 80) hp (by omega)
  rw [← storeLimbs_eq_storeAt h40, ← storeLimbs_eq_storeAt h80, ← storeLimbs_eq_storeAt h0,
    MemoryState.storeLimbs_comm h80 h0
      (by
        simpa [Pointer.add_zero'] using
          Range.disjoint_coords_le (a := 80) (b := 0) hp (by omega) (by omega) (by omega)),
    MemoryState.storeLimbs_comm h40 h0
      (by
        simpa [Pointer.add_zero'] using
          Range.disjoint_coords_le (a := 40) (b := 0) hp (by omega) (by omega) (by omega))]
  rfl

-- about 90 steps over a frame of 9 slots and 13 calls: past the default heartbeats
set_option maxHeartbeats 400000 in
/-- `P.is_small_order()` returns `Serial.EdwardsPoint_is_small_order.spec P`, with
`as_projective`/`as_extended` inlined. Its slots and its callees' temporaries are freed again: only
the counter moves on, by 101 blocks. -/
public theorem EdwardsPoint_is_small_order.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals EdwardsPoint_is_small_order.globals) (hp : s.mem.PointFit p) :
    EdwardsPoint_is_small_order.call (EdwardsPoint_is_small_order.args (.value p)) s =
      .value
        (.cons (.value (Serial.EdwardsPoint_is_small_order.spec (s.mem.readEdwards p))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 101⟩, mem := s.mem }) := by
  func_init
  block_init
  -- `P`'s coordinates, read before the frame's blocks
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  have hX : S.mem.readAt p 320 = limbsBits (S₀.mem.readLimbs p) := by
    rw [hS]; exact readAt_eq_limbsBits hp₀.limbsFit_X
  have hY : S.mem.readAt (p.add 40#64) 320 = limbsBits (S₀.mem.readLimbs (p.add 40#64)) := by
    rw [hS]; exact readAt_eq_limbsBits hp₀.limbsFit_Y
  have hZ : S.mem.readAt (p.add 80#64) 320 = limbsBits (S₀.mem.readLimbs (p.add 80#64)) := by
    rw [hS]; exact readAt_eq_limbsBits hp₀.limbsFit_T
  clear hp₀
  iterate 3 step_pure
  step_addressof Serial.anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq with one
  have hread_one_limbs : S.mem.readAt one 320 = limbsBits Serial.FieldElement51.ONE :=
    hread_one.trans (by decide +kernel)
  clear hread_one
  -- slots: `v4 … v7` the products `ct_eq` compares, `v8` `identity()`, `v9` the last double,
  -- `v10` `s`, `v11` `r`, `v12` `mul_by_cofactor()`
  step_alloca with v4
  step_alloca with v5
  step_alloca with v6
  step_alloca with v7
  step_alloca with v8
  step_alloca with v9
  step_alloca with v10
  step_alloca with v11
  step_alloca with v12
  iterate 3 step_pure
  have hv10_proj := MemoryState.ProjectiveRoom.of_room hroom_v10 hv10_off
  have hv11_point := MemoryState.PointRoom.of_room hroom_v11 hv11_off
  have hv12_point := MemoryState.PointRoom.of_room hroom_v12 hv12_off
  clear hroom_v10 hroom_v11 hroom_v12 hv10_bounds hv11_bounds hv12_bounds
  -- let mut s = self.as_projective();
  step_pure
  step_pure
  have := room_of_limbsRoom hv10_proj.limbsRoom_Y
  have := fits_of_limbsFit hp.limbsFit_Y
  step_memcpy
  step_pure
  step_pure
  have := room_of_limbsRoom hv10_proj.limbsRoom_Z
  have := fits_of_limbsFit hp.limbsFit_T
  step_memcpy
  have := room_of_limbsRoom hv10_proj.limbsRoom_X
  have := fits_of_limbsFit hp.limbsFit_X
  step_memcpy
  rw [storeAt_limbsBits_eq_storeProjective (by simp [hv10_off])] at hS
  obtain ⟨hv10_fit, hread_v10⟩ :
    S.mem.ProjectiveFit v10 ∧
      S.mem.readProjective v10 =
        ⟨S₀.mem.readLimbs p, S₀.mem.readLimbs (p.add 40#64), S₀.mem.readLimbs (p.add 80#64)⟩ :=
    by
    have h := MemoryState.ProjectiveRoom.of_storeProjective (hS ▸ hv10_proj)
    rw [hS]
    exact ⟨.storeProjective_self h, MemoryState.readProjective_storeProjective_self h⟩
  clear hread_v10_40 hread_v10_80 hfits_v10 hfits_v10_40 hfits_v10_80 hX hY hZ hv10_proj hp
  name_point s0
  -- for _ in 0..(k-1) { r = s.double(); s = r.as_projective(); }
  iterate 3 step_pure
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v11_readLimbs
    hread_v11_40 hread_v11_80 hread_v11_120
  name_point r1
  step_pattern using runBodyFrom_asProjRun
  clear hread_v11
  name_point s1
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v11_readLimbs
    hread_v11_40 hread_v11_80 hread_v11_120
  name_point r2
  step_pattern using runBodyFrom_asProjRun
  clear hread_v11
  name_point s2
  -- s.double().as_extended()
  step_pure
  have hv9_point := MemoryState.PointRoom.of_room hroom_v9 hv9_off
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v9_readLimbs hread_v9_40
    hread_v9_80 hread_v9_120
  name_point r3
  step_pure
  step_pattern using runBodyFrom_asExtRun
  clear hread_v9
  name_point P8
  iterate 3 step_pure
  -- EdwardsPoint::identity()
  step_pure
  have hv8_point := MemoryState.PointRoom.of_room hroom_v8 hv8_off
  have := room_of_limbsRoom hv8_point.limbsRoom_X
  step_memset
  step_pure
  have := room_of_limbsRoom hv8_point.limbsRoom_Y
  step_memcpy
  step_pure
  have := room_of_limbsRoom hv8_point.limbsRoom_T
  step_memcpy
  step_pure
  have := room_of_limbsRoom hv8_point.limbsRoom_Z
  step_memset
  rw [storeAt_eq_storeEdwards_identity (by simp [hv8_off])] at hS
  obtain ⟨hv8_fit, hid_X, hid_Y, hid_Z⟩ :
    S.mem.PointFit v8 ∧
      S.mem.readLimbs v8 = Serial.FieldElement51.ZERO ∧
      S.mem.readLimbs (v8.add 40#64) = Serial.FieldElement51.ONE ∧
      S.mem.readLimbs (v8.add 80#64) = Serial.FieldElement51.ONE :=
    by
    have h := MemoryState.PointRoom.of_storeEdwards (hS ▸ hv8_point)
    rw [hS]
    exact
      ⟨.storeEdwards_self h, MemoryState.readLimbs_storeEdwards_X h,
        MemoryState.readLimbs_storeEdwards_Y h, MemoryState.readLimbs_storeEdwards_Z h⟩
  clear hread_v8 hread_v8_40 hread_v8_80 hread_v8_120 hfits_v8 hfits_v8_40 hfits_v8_80 hfits_v8_120
    hroom_v8 hv8_point hv8_bounds hread_one_limbs hone_fits hone_live
  -- (&self.X * &other.Z).ct_eq(&(&other.X * &self.Z))
  step_pure
  limbs_room v7
  step_call using Serial.FieldElement51_Mul_mul.call_eq consuming hread_v7 hread_v12_readLimbs
  step_pure
  limbs_room v6
  step_call using Serial.FieldElement51_Mul_mul.call_eq consuming hread_v6 hid_X
  step_call using Serial.FieldElement51_ConstantTimeEq_ct_eq.call_eq with x_eq consuming
    hread_v7_readLimbs hread_v6_readLimbs hv7_limbs hv6_limbs
  -- (&self.Y * &other.Z).ct_eq(&(&other.Y * &self.Z))
  step_pure
  limbs_room v5
  step_call using Serial.FieldElement51_Mul_mul.call_eq consuming hread_v5 hread_v12_40 hid_Z
  step_pure
  limbs_room v4
  step_call using Serial.FieldElement51_Mul_mul.call_eq consuming hread_v4 hid_Y hread_v12_80
  step_call using Serial.FieldElement51_ConstantTimeEq_ct_eq.call_eq with y_eq consuming
    hread_v5_readLimbs hread_v4_readLimbs hv5_limbs hv4_limbs
  -- `bool::from(y_eq & x_eq)`, through `black_box`
  step_pure
  step_call using Serial.black_box_u8.call_eq
  iterate 4 step_pure
  step_pure
  iterate 2 step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  rfl

end Proof

end MLIR.Agave.Avx2

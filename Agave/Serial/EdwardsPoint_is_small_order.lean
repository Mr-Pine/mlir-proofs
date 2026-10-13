module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Agave.Common.Tactics
public import Firedancer.Common.Tactics
public import Agave.Serial.ProjectivePoint_double
public import Agave.Serial.CompletedPoint_as_projective
public import Agave.Serial.CompletedPoint_as_extended
public import Agave.Serial.FieldElement51_ConstantTimeEq_ct_eq
public import Agave.Serial.black_box_u8
public import Agave.Serial.Mlir.EdwardsPoint_is_small_order
import all MLIR.Ty

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `FieldElement51::ZERO`'s limbs. -/
def FieldElement51.ZERO : Fin 5 → BitVec 64 := fun _ => 0#64

/-- `FieldElement51::ONE`'s limbs. -/
def FieldElement51.ONE : Fin 5 → BitVec 64 := fun i => #v[1#64, 0#64, 0#64, 0#64, 0#64][i]

/-- `EdwardsPoint::identity()`: `(0, 1, 1, 0)`. -/
def EdwardsPoint_identity.spec : EdwardsPoint :=
  ⟨FieldElement51.ZERO, FieldElement51.ONE, FieldElement51.ONE, FieldElement51.ZERO⟩

/-- `EdwardsPoint::mul_by_cofactor`, `mul_by_pow_2(3)`, named as in the Rust: `P` as projective,
doubled three times, the last double as extended. -/
def EdwardsPoint_mul_by_cofactor.spec (P : EdwardsPoint) : EdwardsPoint :=
  let s0 : ProjectivePoint := ⟨P.X, P.Y, P.Z⟩
  let r1 := ProjectivePoint_double.spec s0
  let s1 := CompletedPoint_as_projective.spec r1
  let r2 := ProjectivePoint_double.spec s1
  let s2 := CompletedPoint_as_projective.spec r2
  let r3 := ProjectivePoint_double.spec s2
  CompletedPoint_as_extended.spec r3

/-- `EdwardsPoint::ct_eq`: `X Q.Z = Q.X Z` and `Y Q.Z = Q.Y Z`, as `Choice`s, in the code's operand
order. -/
def EdwardsPoint_ConstantTimeEq_ct_eq.spec (P Q : EdwardsPoint) : BitVec 8 :=
  let x_eq :=
    FieldElement51_ConstantTimeEq_ct_eq.spec (FieldElement51_Mul_mul.spec P.X Q.Z)
      (FieldElement51_Mul_mul.spec Q.X P.Z)
  let y_eq :=
    FieldElement51_ConstantTimeEq_ct_eq.spec (FieldElement51_Mul_mul.spec P.Y Q.Z)
      (FieldElement51_Mul_mul.spec Q.Y P.Z)
  y_eq &&& x_eq

/-- `P.is_small_order()`: `P.mul_by_cofactor().is_identity()`, its `ct_eq` with `identity()` as a
`bool`. -/
def EdwardsPoint_is_small_order.spec (P : EdwardsPoint) : BitVec 1 :=
  BitVec.ofBool
    (EdwardsPoint_ConstantTimeEq_ct_eq.spec (EdwardsPoint_mul_by_cofactor.spec P)
        EdwardsPoint_identity.spec !=
      0#8)

end

/-! ## Proof -/

section Proof

public theorem anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_1.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `ONE`'s global: `ONE`'s limbs' bits. -/
public theorem one_bits {hw : (Ty.array 40 (.bv 8)).width = 320} :
    Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw := hw) =
      limbsBits FieldElement51.ONE := by
  decide +kernel +revert

/-- `identity()`'s stores: `X` and `T` zeroed, `ONE` copied into `Y` and `Z`. -/
theorem storeAt_eq_storeEdwards_identity {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (((m.storeAt p 0#320).storeAt (p.add 40#64) (limbsBits FieldElement51.ONE)).storeAt
            (p.add 80#64) (limbsBits FieldElement51.ONE)).storeAt
        (p.add 120#64) 0#320 =
      m.storeEdwards p EdwardsPoint_identity.spec := by
  have h0 : (0#320 : BitVec 320) = limbsBits FieldElement51.ZERO := by
    simp [limbsBits, FieldElement51.ZERO]
  rw [h0, ← MemoryState.storeLimbs_eq_storeAt (by omega : p.offset.toNat + 32 < 2 ^ 64), ←
    MemoryState.storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 40) hp (by omega)), ←
    MemoryState.storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 80) hp (by omega)), ←
    MemoryState.storeLimbs_eq_storeAt (Pointer.coord_offset_le (a := 120) hp (by omega))]
  rfl

/-- `EdwardsPoint::as_projective`'s copies, `Y`, `Z`, then `X`: a `ProjectivePoint` store. -/
public theorem storeAt_limbsBits_eq_storeProjective {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 120 ≤ 2 ^ 64) (a b c : Fin 5 → BitVec 64) :
    ((m.storeAt (p.add 40#64) (limbsBits b)).storeAt (p.add 80#64) (limbsBits c)).storeAt p
        (limbsBits a) =
      m.storeProjective p ⟨a, b, c⟩ := by
  have h0 : p.offset.toNat + 32 < 2 ^ 64 := by omega
  have h40 := Pointer.coord_offset_le (a := 40) hp (by omega)
  have h80 := Pointer.coord_offset_le (a := 80) hp (by omega)
  rw [← MemoryState.storeLimbs_eq_storeAt h40, ← MemoryState.storeLimbs_eq_storeAt h80, ←
    MemoryState.storeLimbs_eq_storeAt h0,
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
/-- `P.is_small_order()` returns `spec P`. Its slots and its callees' temporaries are freed again:
only the counter moves on, by 101 blocks. -/
public theorem EdwardsPoint_is_small_order.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals EdwardsPoint_is_small_order.globals) (hp : s.mem.PointFit p) :
    EdwardsPoint_is_small_order.call (EdwardsPoint_is_small_order.args (.value p)) s =
      .value
        (.cons (.value (EdwardsPoint_is_small_order.spec (s.mem.readEdwards p))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 101⟩, mem := s.mem }) := by
  func_init
  block_init
  -- `P`'s coordinates, read before the frame's blocks
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  have hX : S.mem.readAt p 320 = limbsBits (S₀.mem.readLimbs p) := by
    rw [hS]; exact MemoryState.readAt_eq_limbsBits hp₀.limbsFit_X
  have hY : S.mem.readAt (p.add 40#64) 320 = limbsBits (S₀.mem.readLimbs (p.add 40#64)) := by
    rw [hS]; exact MemoryState.readAt_eq_limbsBits hp₀.limbsFit_Y
  have hZ : S.mem.readAt (p.add 80#64) 320 = limbsBits (S₀.mem.readLimbs (p.add 80#64)) := by
    rw [hS]; exact MemoryState.readAt_eq_limbsBits hp₀.limbsFit_T
  clear hp₀
  iterate 3 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq with one
  have hread_one_limbs : S.mem.readAt one 320 = limbsBits FieldElement51.ONE :=
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
  have := MemoryState.LimbsRoom.room320 hv10_proj.limbsRoom_Y
  have := MemoryState.LimbsFit.fits hp.limbsFit_Y
  step_memcpy
  step_pure
  step_pure
  have := MemoryState.LimbsRoom.room320 hv10_proj.limbsRoom_Z
  have := MemoryState.LimbsFit.fits hp.limbsFit_T
  step_memcpy
  have := MemoryState.LimbsRoom.room320 hv10_proj.limbsRoom_X
  have := MemoryState.LimbsFit.fits hp.limbsFit_X
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
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v11_readLimbs
    hread_v11_40 hread_v11_80 hread_v11_120
  name_point r1
  step_call using CompletedPoint_as_projective.call_eq consuming hread_v11 hread_v10_readLimbs
    hread_v10_40 hread_v10_80
  name_point s1
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v11_readLimbs
    hread_v11_40 hread_v11_80 hread_v11_120
  name_point r2
  step_call using CompletedPoint_as_projective.call_eq consuming hread_v11 hread_v10_readLimbs
    hread_v10_40 hread_v10_80
  name_point s2
  -- s.double().as_extended()
  step_pure
  have hv9_point := MemoryState.PointRoom.of_room hroom_v9 hv9_off
  step_call using ProjectivePoint_double.call_eq consuming hread_v10 hread_v9_readLimbs hread_v9_40
    hread_v9_80 hread_v9_120
  name_point r3
  step_call using CompletedPoint_as_extended.call_eq consuming hread_v9 hread_v12 hread_v12_120
  name_point P8
  iterate 3 step_pure
  -- EdwardsPoint::identity()
  step_pure
  have hv8_point := MemoryState.PointRoom.of_room hroom_v8 hv8_off
  have := MemoryState.LimbsRoom.room320 hv8_point.limbsRoom_X
  step_memset
  step_pure
  have := MemoryState.LimbsRoom.room320 hv8_point.limbsRoom_Y
  step_memcpy
  step_pure
  have := MemoryState.LimbsRoom.room320 hv8_point.limbsRoom_T
  step_memcpy
  step_pure
  have := MemoryState.LimbsRoom.room320 hv8_point.limbsRoom_Z
  step_memset
  rw [storeAt_eq_storeEdwards_identity (by simp [hv8_off])] at hS
  obtain ⟨hv8_fit, hid_X, hid_Y, hid_Z⟩ :
    S.mem.PointFit v8 ∧
      S.mem.readLimbs v8 = FieldElement51.ZERO ∧
      S.mem.readLimbs (v8.add 40#64) = FieldElement51.ONE ∧
      S.mem.readLimbs (v8.add 80#64) = FieldElement51.ONE :=
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
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_v7 hread_v12_readLimbs
  step_pure
  limbs_room v6
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_v6 hid_X
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with x_eq consuming hread_v7_readLimbs
    hread_v6_readLimbs hv7_limbs hv6_limbs
  -- (&self.Y * &other.Z).ct_eq(&(&other.Y * &self.Z))
  step_pure
  limbs_room v5
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_v5 hread_v12_40 hid_Z
  step_pure
  limbs_room v4
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_v4 hid_Y hread_v12_80
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with y_eq consuming hread_v5_readLimbs
    hread_v4_readLimbs hv5_limbs hv4_limbs
  -- `bool::from(y_eq & x_eq)`, through `black_box`
  step_pure
  step_call using black_box_u8.call_eq
  iterate 4 step_pure
  step_pure
  iterate 2 step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial

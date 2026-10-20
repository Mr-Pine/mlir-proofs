module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.wl_permute
public import Firedancer.Crc.Verify.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Verify.fd_r52x5_limbs_eq
public import Firedancer.Crc.Verify.QuadRuns
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_eq_z1

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_eq_z1( a, b )`: with `M = B · [Za, Za, Za, Za]`, `1` when the canonical lanes 0
and 1 of `M` equal those of `A`, tested in that order, else `0`. -/
def fd_r52x5_ge_eq_z1.spec (A B : Quad5) : BitVec 32 :=
  let M := fd_r52x5_quad_mul.spec B (Quad5.permute 2 2 2 2 A)
  if fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec M 0) (fd_r52x5_quad_lane_canon.spec A 0)
      = 0 then 0
  else fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec M 1) (fd_r52x5_quad_lane_canon.spec A 1)

end

/-! ## Proof -/

section Proof

set_option maxHeartbeats 1000000 in
/-- `^bb0` from site `55` (the four lane canonicalizations, the first `limbs_eq`) and both
branches to the return, over a bare state whose slots `5 … 8` of `S₀` are the limb arrays. -/
private theorem fd_r52x5_ge_eq_z1.tail_run (S₀ S : GlobalState) (E : ⟪fd_r52x5_ge_eq_z1.Γ⟫)
    (A Bq : Quad5)
    (hR : E ⊨ [rir_reg% fd_r52x5_ge_eq_z1.hty 8 := PoisonOr.value (S₀.slot 5),
      rir_reg% fd_r52x5_ge_eq_z1.hty 9 := PoisonOr.value (S₀.slot 6),
      rir_reg% fd_r52x5_ge_eq_z1.hty 10 := PoisonOr.value (S₀.slot 7),
      rir_reg% fd_r52x5_ge_eq_z1.hty 11 := PoisonOr.value (S₀.slot 8),
      rir_reg% fd_r52x5_ge_eq_z1.hty 2 := PoisonOr.value 0#32,
      rir_reg% fd_r52x5_ge_eq_z1.hty 0 := PoisonOr.value 1#32,
      rir_reg% fd_r52x5_ge_eq_z1.hty 12 := Ty.wrap A.P0,
      rir_reg% fd_r52x5_ge_eq_z1.hty 14 := Ty.wrap A.P1,
      rir_reg% fd_r52x5_ge_eq_z1.hty 16 := Ty.wrap A.P2,
      rir_reg% fd_r52x5_ge_eq_z1.hty 18 := Ty.wrap A.P3,
      rir_reg% fd_r52x5_ge_eq_z1.hty 20 := Ty.wrap A.P4,
      rir_reg% fd_r52x5_ge_eq_z1.hty 35 := Ty.wrap (fd_r52x5_quad_mul.spec Bq (Quad5.permute 2 2 2 2 A)).P0,
      rir_reg% fd_r52x5_ge_eq_z1.hty 36 := Ty.wrap (fd_r52x5_quad_mul.spec Bq (Quad5.permute 2 2 2 2 A)).P1,
      rir_reg% fd_r52x5_ge_eq_z1.hty 37 := Ty.wrap (fd_r52x5_quad_mul.spec Bq (Quad5.permute 2 2 2 2 A)).P2,
      rir_reg% fd_r52x5_ge_eq_z1.hty 38 := Ty.wrap (fd_r52x5_quad_mul.spec Bq (Quad5.permute 2 2 2 2 A)).P3,
      rir_reg% fd_r52x5_ge_eq_z1.hty 39 := Ty.wrap (fd_r52x5_quad_mul.spec Bq (Quad5.permute 2 2 2 2 A)).P4])
    (hwf : S.WF)
    (hroom_m0 : Room S.mem (S₀.slot 5) 320) (hroom_m1 : Room S.mem (S₀.slot 6) 320)
    (hroom_a0 : Room S.mem (S₀.slot 7) 320) (hroom_a1 : Room S.mem (S₀.slot 8) 320)
    (hwritable_m0 : Writable S.mem (S₀.slot 5)) (hm0_bounds : InBounds S.mem (S₀.slot 5) 320)
    (hwritable_m1 : Writable S.mem (S₀.slot 6)) (hm1_bounds : InBounds S.mem (S₀.slot 6) 320)
    (hwritable_a0 : Writable S.mem (S₀.slot 7)) (ha0_bounds : InBounds S.mem (S₀.slot 7) 320)
    (hwritable_a1 : Writable S.mem (S₀.slot 8)) (ha1_bounds : InBounds S.mem (S₀.slot 8) 320)
    (herase : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem)
    (halloc : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 9 + 5) :
    (do
      let x ← fd_r52x5_ge_eq_z1.bb0.runBodyFrom E 55 S
      let x ← Exit.run fd_r52x5_ge_eq_z1.blockParams x.1 fd_r52x5_ge_eq_z1.bb0.exit x.2
      let p ← Func.continue (func := fd_r52x5_ge_eq_z1) x.1.1 x.1.2 x.2
      PoisonOr.value (p.1, GlobalState.mk p.2.alloc (p.2.mem.eraseFrom S₀.alloc.nextFreeBlock))) =
    PoisonOr.value
      (Vals.cons (PoisonOr.value (fd_r52x5_ge_eq_z1.spec A Bq)) Vals.nil,
        GlobalState.mk ⟨S₀.alloc.nextFreeBlock + 9 + 5 + 24⟩ S₀.mem) := by
  have hm0_off : (S₀.slot 5).offset = 0 := rfl
  have hm1_off : (S₀.slot 6).offset = 0 := rfl
  have ha0_off : (S₀.slot 7).offset = 0 := rfl
  have ha1_off : (S₀.slot 8).offset = 0 := rfl
  have r0 := MemoryState.LimbsRoom.of_room hroom_m0 hm0_off
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := fd_r52x5_quad_mul.spec Bq
    (Quad5.permute 2 2 2 2 A)) (hl := by decide)) consuming r0
  have r1 := MemoryState.LimbsRoom.of_room hroom_m1 hm1_off
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := fd_r52x5_quad_mul.spec Bq
    (Quad5.permute 2 2 2 2 A)) (hl := by decide)) consuming r1
  have r2 := MemoryState.LimbsRoom.of_room hroom_a0 ha0_off
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := A) (hl := by decide)) consuming r2
  have r3 := MemoryState.LimbsRoom.of_room hroom_a1 ha1_off
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := A) (hl := by decide)) consuming r3
  step_call using (fd_r52x5_limbs_eq.call_eq (S₀.slot 5) (S₀.slot 7))
  step_pure
  finish_block
  case isTrue =>
    block_init
    clear * - hS hE hbr herase halloc hR
    iterate 4 step_pure
    finish_block
    subst hS
    erase_frame
    simp_all [fd_r52x5_ge_eq_z1.spec]
  case isFalse =>
    block_init
    step_call using (fd_r52x5_limbs_eq.call_eq (S₀.slot 6) (S₀.slot 8))
    finish_block
    block_init
    clear * - hS hE hbr herase halloc hR
    iterate 4 step_pure
    finish_block
    subst hS
    erase_frame
    simp_all [fd_r52x5_ge_eq_z1.spec]

set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_ge_eq_z1( a, b )` returns `spec` of the points at `a` and `b`; its temporaries, the
permutes' and the canonicalizations' blocks are freed. -/
public theorem fd_r52x5_ge_eq_z1.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.Quad5Fit a) (hb : s.mem.Quad5Fit b) :
    fd_r52x5_ge_eq_z1.call (fd_r52x5_ge_eq_z1.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_r52x5_ge_eq_z1.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b))) .nil,
          { s with alloc := ⟨s.alloc.nextFreeBlock + 9 + 5 + 24⟩ }) := by
  func_init
  block_init
  iterate 3 step_pure
  iterate 5 step_alloca
  step_alloca with m0
  step_alloca with m1
  step_alloca with a0
  step_alloca with a1
  have hlta := hwf₀.lt ha₀.inBounds.mem
  have hltb := hwf₀.lt hb₀.inBounds.mem
  step_pattern' using runBodyFrom_quad5LoadRun inline
  step_pattern' using runBodyFrom_quad5LoadRun inline
  rename_i qa hqa
  have eqa : qa = S₀.mem.readQuad5 a := by
    rw [hqa, hS]
    simp (disch := (try simp only [GlobalState.alloca_alloc]); omega) only
      [MemoryState.readQuad5_alloca_lt]
  have eqb : Q = S₀.mem.readQuad5 b := by
    rw [hQ, hS]
    simp (disch := (try simp only [GlobalState.alloca_alloc]); omega) only
      [MemoryState.readQuad5_alloca_lt]
  subst eqa eqb
  clear hlta hltb hqa hQ ha hb
  step_pattern' using runBodyFrom_permuteRun 2 2 2 2 (X := S₀.mem.readQuad5 a) inline
  subst hv3 hv4 hv5 hv6 hv7
  have hF : SlotFrame S₀ 5 S.mem := fun j hj =>
    match j, hj with
    | 0, _ => ⟨hv3_bounds, hwritable_v3⟩
    | 1, _ => ⟨hv4_bounds, hwritable_v4⟩
    | 2, _ => ⟨hv5_bounds, hwritable_v5⟩
    | 3, _ => ⟨hv6_bounds, hwritable_v6⟩
    | 4, _ => ⟨hv7_bounds, hwritable_v7⟩
  clear hwritable_v3 hwritable_v4 hwritable_v5 hwritable_v6 hwritable_v7 hv3_bounds hv4_bounds
    hv5_bounds hv6_bounds hv7_bounds
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq)
    (X := S₀.mem.readQuad5 b) (Y := Quad5.permute 2 2 2 2 (S₀.mem.readQuad5 a)) inline
  clear hF
  iterate 4 step_pure
  subst hm0 hm1 ha0 ha1
  have herase : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [hS]
    erase_frame
  have halloc : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 9 + 5 := by
    rw [hS]
    simp only [GlobalState.alloca]
  subst hE hQ
  exact fd_r52x5_ge_eq_z1.tail_run S₀ S _ (S₀.mem.readQuad5 a) (S₀.mem.readQuad5 b) (by lemma_reads)
    hwf hroom_m0 hroom_m1 hroom_a0 hroom_a1 hwritable_m0 hm0_bounds hwritable_m1 hm1_bounds
    hwritable_a0 ha0_bounds hwritable_a1 ha1_bounds herase halloc

end Proof

end MLIR.Firedancer.Crc.Verify

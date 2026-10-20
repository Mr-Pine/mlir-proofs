module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Quad
public import Firedancer.Crc.Verify.wl_extract_variable
public import Firedancer.Crc.Verify.fd_r52x5_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5 (Quad5)

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_lane_canon( r, X0 … X4, lane )`: `fd_r52x5_canon` of lane `lane` of `X`. -/
def fd_r52x5_quad_lane_canon.spec (X : Quad5) (j : Fin 4) : Fin 5 → BitVec 64 :=
  fd_r52x5_canon.spec (X.elem j)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_quad_lane_canon( r, X0 … X4, lane )` stores `spec` at `r`, `lane` below 4; its limbs
and the extracts' unions are freed. -/
public theorem fd_r52x5_quad_lane_canon.call_eq (r : Pointer) (X : Quad5) (lane : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.LimbsRoom r) (hl : lane.toNat < 4) :
    fd_r52x5_quad_lane_canon.call
        (fd_r52x5_quad_lane_canon.args (.value r) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2)
          (Ty.wrap X.P3) (Ty.wrap X.P4) (.value lane))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem := s.mem.storeLimbs r (fd_r52x5_quad_lane_canon.spec X ⟨lane.toNat, hl⟩) }) := by
  func_init
  block_init
  step_pure
  step_alloca with t
  step_pure
  step_call using wl_extract_variable.call_eq
  step_store
  iterate 4 (step_pure; step_call using wl_extract_variable.call_eq; step_store)
  have hrd : S.mem.readLimbs t = X.elem ⟨lane.toNat, hl⟩ := by
    funext i
    fin_cases i <;>
      simp only [MemoryState.readLimbs, Quad5.elem, Quad5.limb, hread_t, hread_t_8, hread_t_16,
        hread_t_24, hread_t_32] <;> rfl
  have hft : S.mem.LimbsFit t := ⟨by rw [ht_off]; decide, hfits_t, hfits_t_8, hfits_t_16,
    hfits_t_24, hfits_t_32⟩
  step_call using fd_r52x5_canon.call_eq consuming hft
  clear hread_t hread_t_8 hread_t_16 hread_t_24 hread_t_32 hrd hfits_t hfits_t_8 hfits_t_16
    hfits_t_24 hfits_t_32 hroom_t hwritable_t ht_bounds hr hread_r hwf
  rename_i hr0
  clear hr0
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify

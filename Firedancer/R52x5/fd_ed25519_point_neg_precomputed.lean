module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
import Firedancer.Common.Tactics
public import Firedancer.R52x5.Mlir.fd_ed25519_point_neg_precomputed

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `-A` in the table form: `Y-X` and `Y+X` swapped, `2dT` replaced by `32 p - 2dT`, reduced. -/
def fd_ed25519_point_neg_precomputed.spec (A : Quad5) : Quad5 :=
  let _r := A.permute 1 0 2 3
  let _p := A.negateLazy
  let _p := _p.reduce
  Quad5.laneIf 0 0 0 1 _p _r

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_sub_wl

/-- Lane `T` of the negation reads only lane `T`, which `PERMUTE( 1,0,2,3 )` keeps. -/
theorem laneIf_0001_permute (A X : Quad5) :
    Quad5.laneIf 0 0 0 1 (A.permute 1 0 2 3).negateLazy.reduce X =
      Quad5.laneIf 0 0 0 1 A.negateLazy.reduce X := by
  simp [Quad5.laneIf, wlBlend, Quad5.reduce, Quad5.negateLazy, Quad5.permute, wlPermute,
    wl_madd52lo, wl_add, wl_and, wl_shru, wl_sub]

/-- `fd_ed25519_point_neg_precomputed` stores `spec` of the point at `a` at `r`, which is `a`
itself or in another block, and returns `r`; its five `wl_permute` calls' unions are freed. -/
public theorem fd_ed25519_point_neg_precomputed.call_eq (r a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.Quad5Fit r) (ha : s.mem.Quad5Fit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_neg_precomputed.call
        (fd_ed25519_point_neg_precomputed.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem :=
              s.mem.storeQuad5 r
                (fd_ed25519_point_neg_precomputed.spec (s.mem.readQuad5 a)) }) := by
  rcases hsep with rfl | hsep
  all_goals
    func_init
    block_init
    iterate 9 step_pure
    -- FD_R52X5_QUAD_PERMUTE( r->P, 1,0,2,3, a->P )
    step_load [ofFn_extractVecElem_readAt] with a0
    step_call using wl_permute.call_eq
    step_store
    iterate 4 
      step_pure
      step_load [ofFn_extractVecElem_readAt]
      step_call using wl_permute.call_eq
      step_pure
      step_store
    -- FD_R52X5_QUAD_NEGATE_LAZY( _p, a->P ), a->P reloaded
    step_load [ofFn_extractVecElem_readAt] with b0
    step_pure with n0
    step_load [ofFn_extractVecElem_readAt] with b1
    step_pure with n1
    step_load [ofFn_extractVecElem_readAt] with b2
    step_pure with n2
    step_load [ofFn_extractVecElem_readAt] with b3
    step_pure with n3
    step_load [ofFn_extractVecElem_readAt] with b4
    step_pure with n4
    -- FD_R52X5_QUAD_REDUCE( _p, _p )
    step_pattern using runBodyFrom_reduceRun (Q := ⟨n0, n1, n2, n3, n4⟩) inline
    -- FD_R52X5_QUAD_LANE_IF( r->P, 0,0,0,1, _p, r->P )
    step_call using wc_bcast_wide.call_eq
    iterate 3 step_pattern using runBodyFrom_bytesRun inline
    step_pattern using runBodyFrom_blendRun 0 0 0 1 inline
    step_store
    iterate 4 
      iterate 2 step_pattern using runBodyFrom_bytesRun inline
      step_pattern using runBodyFrom_blendRun 0 0 0 1 inline
      step_store
    finish_block
    have hp : r.offset.toNat + 160 ≤ 2 ^ 64 := hr.1
    rw [hS]
    simp only [MemoryState.storeAt_packLanes_wlBytes]
    clear_reads
    subst_vars
    erase_frame
  -- the permuted point's stores, overwritten; aliased, `a->P` reloaded permuted
  · rw [← MemoryState.storeQuad5_storeQuad5_self (P := (S₀.mem.readQuad5 r).permute 1 0 2 3) hp,
      fd_ed25519_point_neg_precomputed.spec, ← laneIf_0001_permute]
    rfl
  · rw [← MemoryState.storeQuad5_storeQuad5_self (P := (S₀.mem.readQuad5 a).permute 1 0 2 3) hp]
    rfl

end Proof

end MLIR.Firedancer.R52x5

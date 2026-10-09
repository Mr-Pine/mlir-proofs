module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
import Firedancer.Common.Tactics
public import Firedancer.R52x5.wwl_st
public import Firedancer.R52x5.Mlir.fd_ed25519_point_from

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_from` stores `Quad5.pack` of the field elements at `x, y, z, t` at `r` and
returns `r`; its four `long[8]` arrays are freed. -/
public theorem fd_ed25519_point_from.call_eq (r x y z t : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) (hx : Fits s.mem x 512) (hy : Fits s.mem y 512) (hz : Fits s.mem z 512)
    (ht : Fits s.mem t 512) :
    fd_ed25519_point_from.call
        (fd_ed25519_point_from.args (.value r) (.value x) (.value y) (.value z) (.value t)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              s.mem.storeQuad5 r
                (Quad5.pack (s.mem.readVec x) (s.mem.readVec y) (s.mem.readVec z)
                  (s.mem.readVec t)) }) := by
  func_init
  block_init
  iterate 4 step_pure
  -- long _x[8], _y[8], _z[8], _t[8];
  step_alloca with _x
  step_alloca with _y
  step_alloca with _z
  step_alloca with _t
  -- wwl_st( _x, x ); … wwl_st( _t, t );
  iterate 4 
    step_pure
    step_load
    step_call using wwl_st.call_eq
  -- r->P0 = wl( _x[0], _y[0], _z[0], _t[0] ); … r->P4
  step_pattern using runBodyFrom_packLimbRun0 inline
  step_store
  step_pattern using runBodyFrom_packLimbRun 1 inline
  step_pure
  step_store
  step_pattern using runBodyFrom_packLimbRun 2 inline
  step_pure
  step_store
  step_pattern using runBodyFrom_packLimbRun 3 inline
  step_pure
  step_store
  step_pattern using runBodyFrom_packLimbRun 4 inline
  step_pure
  step_store
  iterate 4 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5

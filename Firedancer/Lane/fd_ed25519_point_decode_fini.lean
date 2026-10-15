module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Lane.fd_r43x6_ge_decode_fini
public import Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini

namespace MLIR.Firedancer.Lane

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_decode_fini` finishes the decode at `st`, stores `DecSt.fini`'s point at `r`
and returns its code; three temporaries count `3` blocks. -/
public theorem fd_ed25519_point_decode_fini.call_eq (r st : Pointer) (D : DecSt) (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini.globals)
    (hst : s.mem.DecRoom st) (hD : s.mem.DecHolds st D) (hOk : D.Ok) (hr : s.mem.QuadRoom r) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini.args (.value r) (.value st)) s =
      .value
        (.cons (.value D.fini.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem := (s.mem.storeDec st (D.stepSlow 18446744073709551615#64)).storeQuad r
              D.fini.2 }) := by
  func_init
  block_init
  step_pure
  iterate 3 step_alloca
  iterate 3 step_pure
  have hids : [v1.id, v2.id, v3.id].Nodup := by
    simp [hv1, hv2, hv3, GlobalState.slot]
  step_call using fd_r43x6_ge_decode_fini.call_eq consuming hD hg hst hwritable_v1 hwritable_v2
    hwritable_v3
  -- FD_R43X6_QUAD_MOV( r->P, _P )
  step_load
  step_store
  iterate 2
    step_load
    step_pure
    step_store
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  subst hv1 hv2 hv3
  rfl

end Proof

end MLIR.Firedancer.Lane

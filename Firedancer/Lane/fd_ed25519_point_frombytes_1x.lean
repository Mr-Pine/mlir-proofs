module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Lane.fd_r43x6_ge_decode
public import Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_1x

namespace MLIR.Firedancer.Lane

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_frombytes_1x` stores `fd_r43x6_ge_decode.spec`'s point of the encoding at
`buf` at `r` and returns its code; three temporaries count `3` blocks. -/
public theorem fd_ed25519_point_frombytes_1x.call_eq (r buf : Pointer) (s : GlobalState)
    (hwf : s.WF) (hbuf : Fits s.mem buf 256) (hbo : ¬buf.offset.uaddOverflow 32#64)
    (hr : s.mem.QuadRoom r) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_1x.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_1x.args (.value r) (.value buf)) s =
      let R := fd_r43x6_ge_decode.spec (s.mem.readAt buf 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem.storeQuad r R.2 }) := by
  func_init
  block_init
  step_pure
  iterate 3 step_alloca
  iterate 3 step_pure
  have hids : [v1.id, v2.id, v3.id].Nodup := by
    simp [hv1, hv2, hv3, GlobalState.slot]
  step_call using fd_r43x6_ge_decode.call_eq consuming hwritable_v1 hwritable_v2 hwritable_v3
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

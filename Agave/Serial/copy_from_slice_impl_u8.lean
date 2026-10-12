module

public import MLIR.Run.Tactic
public import Agave.Serial.Mlir.copy_from_slice_impl_u8

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

/-- `dst.copy_from_slice(src)` on `n` bytes each: the bytes at `src` stored at `dst`. Unequal
lengths panic, so both are `n`; `dst` and `src` are in different blocks. -/
public theorem copy_from_slice_impl_u8.call_eq (dst src loc : Pointer) (n : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hdst : Room s.mem dst (8 * n.toNat))
    (hsrc : Fits s.mem src (8 * n.toNat)) (hsep : dst.id ≠ src.id) :
    copy_from_slice_impl_u8.call
        (copy_from_slice_impl_u8.args (.value dst) (.value n) (.value src) (.value n) (.value loc))
        s =
      .value (.nil, { s with mem := s.mem.storeAt dst (s.mem.readAt src (8 * n.toNat)) }) := by
  func_init
  block_init
  step_pure
  finish_block
  block_init
  step_memcpy
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Agave.Serial

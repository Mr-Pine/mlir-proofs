module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.Mlir.fd_f25519_set

namespace MLIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `set` copies `src`'s limbs to `dst`, which is `src` itself or in another block, and returns
`dst`. -/
public theorem fd_f25519_set.call_eq (dst src : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdst : s.mem.LimbsFit dst) (hsrc : s.mem.LimbsFit src) (hsep : dst = src ∨ dst.id ≠ src.id) :
    fd_f25519_set.call (fd_f25519_set.args (.value dst) (.value src)) s =
      .value
        (.cons (.value dst) .nil,
          { s with mem := s.mem.storeLimbs dst (s.mem.readLimbs src) }) := by
  rcases hsep with rfl | hsep <;>
    · func_init
      block_init
      step_load
      step_store
      iterate 4 
        step_pure
        step_load
        step_pure
        step_store
      finish_block
      simp [hS, MemoryState.storeLimbs]
      rfl

end Proof

end MLIR.Firedancer.Ref

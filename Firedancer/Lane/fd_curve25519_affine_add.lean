module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadMem
public import Firedancer.Lane.fd_curve25519_into_affine
public import Firedancer.Lane.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_curve25519_affine_add

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `A + B` in affine form. -/
def fd_curve25519_affine_add.spec (A B : Quad) : Quad :=
  fd_curve25519_into_affine.spec (fd_ed25519_point_add_with_opts.spec A B 0)

end

/-! ## Proof -/

section Proof

/-- `fd_curve25519_affine_add` stores `spec` of the points at `a` and `b` at `r` and returns `r`;
`r` may be `a` or `b`. -/
public theorem fd_curve25519_affine_add.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    _root_.Firedancer.Lane.Mlir.fd_curve25519_affine_add.call
        (_root_.Firedancer.Lane.Mlir.fd_curve25519_affine_add.args (.value r) (.value a)
          (.value b))
        s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeQuad r
                (fd_curve25519_affine_add.spec (s.mem.readQuad a) (s.mem.readQuad b)) }) := by
  have hro := hr.1
  func_init
  block_init
  step_pure
  -- fd_ed25519_point_add_with_opts( r, a, b, 1, 0, 0 ), then fd_curve25519_into_affine( r )
  step_call using fd_ed25519_point_add_with_opts.call_eq
  step_call using fd_curve25519_into_affine.call_eq
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeQuad_storeQuad_self hro]
  rfl

end Proof

end MLIR.Firedancer.Lane

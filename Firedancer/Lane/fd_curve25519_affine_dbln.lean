module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadMem
public import Firedancer.Lane.fd_curve25519_into_affine
public import Firedancer.Lane.fd_ed25519_point_dbln
public import Firedancer.Lane.Mlir.fd_curve25519_affine_dbln

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `2ⁿ A` in affine form. -/
def fd_curve25519_affine_dbln.spec (A : Quad) (n : Nat) : Quad :=
  fd_curve25519_into_affine.spec (fd_ed25519_point_dbln.spec A n)

end

/-! ## Proof -/

section Proof

/-- `fd_curve25519_affine_dbln` stores `spec` of the point at `a` at `r` and returns `r`. -/
public theorem fd_curve25519_affine_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hn : n.toNat ≤ 255) :
    _root_.Firedancer.Lane.Mlir.fd_curve25519_affine_dbln.call
        (_root_.Firedancer.Lane.Mlir.fd_curve25519_affine_dbln.args (.value r) (.value a)
          (.value n))
        s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeQuad r (fd_curve25519_affine_dbln.spec (s.mem.readQuad a) n.toNat) }) := by
  have hro := hr.1
  func_init
  block_init
  -- fd_ed25519_point_dbln( r, a, n ), then fd_curve25519_into_affine( r )
  step_call using fd_ed25519_point_dbln.call_eq
  step_call using fd_curve25519_into_affine.call_eq
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeQuad_storeQuad_self hro]
  rfl

end Proof

end MLIR.Firedancer.Lane

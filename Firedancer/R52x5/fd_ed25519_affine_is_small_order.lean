module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Globals
public import Firedancer.R52x5.fd_ed25519_point_to
public import Firedancer.R52x5.fd_f25519_is_zero
public import Firedancer.R52x5.fd_f25519_eq
public import Firedancer.R52x5.Mlir.fd_ed25519_affine_is_small_order

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `1` when `X = 0`, `Y = 0`, or `Y` is one of the order-8 points' `y` (by `is_zero`/`eq`), else
`0`; in the program's operand order. -/
def fd_ed25519_affine_is_small_order.spec (A : Quad5) : BitVec 32 :=
  fd_f25519_is_zero.spec A.unpack.2.1 ||| fd_f25519_is_zero.spec A.unpack.1 |||
    fd_f25519_eq.spec A.unpack.2.1 fd_ed25519_order8_point_y0.vec |||
    fd_f25519_eq.spec A.unpack.2.1 fd_ed25519_order8_point_y1.vec

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_affine_is_small_order` returns `spec` of the point at `a`; the four temporaries
and the frames of two `is_zero` (2 each) and two `eq` (3 each) count 14 blocks. -/
public theorem fd_ed25519_affine_is_small_order.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_ed25519_affine_is_small_order.globals) (ha : s.mem.Quad5Fit a) :
    fd_ed25519_affine_is_small_order.call (fd_ed25519_affine_is_small_order.args (.value a)) s =
      .value
        (.cons (.value (fd_ed25519_affine_is_small_order.spec (s.mem.readQuad5 a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 14⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_addressof fd_ed25519_order8_point_y0.value_eq with y0
  step_addressof fd_ed25519_order8_point_y1.value_eq with y1
  -- fd_f25519_t x[1], y[1], z[1], t[1];
  step_alloca with x
  step_alloca with y
  step_alloca with z
  step_alloca with t
  iterate 4 step_pure
  have hy0_read := fd_ed25519_order8_point_y0.readVec hread_y0
  have hy1_read := fd_ed25519_order8_point_y1.readVec hread_y1
  clear hread_y0 hread_y1
  -- fd_ed25519_point_to( x, y, z, t, a );
  step_call using fd_ed25519_point_to.call_eq consuming ha
  -- return fd_f25519_is_zero( x ) | fd_f25519_is_zero( y )
  step_call using fd_f25519_is_zero.call_eq
  step_call using fd_f25519_is_zero.call_eq
  step_pure
  --   | fd_f25519_eq( y, fd_ed25519_order8_point_y0 )
  step_call using fd_f25519_eq.call_eq consuming hy0_read
  step_pure
  --   | fd_f25519_eq( y, fd_ed25519_order8_point_y1 );
  step_call using fd_f25519_eq.call_eq consuming hy1_read
  step_pure
  iterate 4 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5

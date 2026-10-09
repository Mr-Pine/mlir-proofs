module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Common.Tactics
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_ed25519_point_to
public import Firedancer.Ref.fd_f25519_is_zero
public import Firedancer.Ref.fd_f25519_eq
public import Firedancer.Ref.Mlir.fd_ed25519_affine_is_small_order

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `1` when `X = 0`, `Y = 0`, or `Y` is one of the order-8 points' `y` (by `is_zero`/`eq`), else
`0`; in the program's operand order. -/
def fd_ed25519_affine_is_small_order.spec (A : PointLimbs) : BitVec 32 :=
  fd_f25519_is_zero.spec A.Y ||| fd_f25519_is_zero.spec A.X |||
    fd_f25519_eq.spec A.Y fd_ed25519_order8_point_y0.limbs |||
    fd_f25519_eq.spec A.Y fd_ed25519_order8_point_y1.limbs

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_affine_is_small_order` returns `spec` of the point at `a`; the two globals, four
temporaries and two `fd_f25519_eq` frames count eight blocks. -/
public theorem fd_ed25519_affine_is_small_order.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.PointFit a) :
    fd_ed25519_affine_is_small_order.call (fd_ed25519_affine_is_small_order.args (.value a)) s =
      .value
        (.cons (.value (fd_ed25519_affine_is_small_order.spec (s.mem.readPoint a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 8⟩, mem := s.mem }) := by
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
  have hy0_read := fd_ed25519_order8_point_y0.readLimbs hy0_fits hy0_off hread_y0
  have hy1_read := fd_ed25519_order8_point_y1.readLimbs hy1_fits hy1_off hread_y1
  have hy0_limbs := MemoryState.LimbsFit.of_fits hy0_fits hy0_off
  have hy1_limbs := MemoryState.LimbsFit.of_fits hy1_fits hy1_off
  have hx_limbs := MemoryState.LimbsFit.of_fits hx_fits hx_off
  have hy_limbs := MemoryState.LimbsFit.of_fits hy_fits hy_off
  have hz_limbs := MemoryState.LimbsFit.of_fits hz_fits hz_off
  have ht_limbs := MemoryState.LimbsFit.of_fits ht_fits ht_off
  clear hread_y0 hread_y1 hy0_fits hy1_fits hx_fits hy_fits hz_fits ht_fits
  -- `a` lies below the globals' blocks
  have ha_b0 : a.id ≠ ⟨S₀.alloc.nextFreeBlock⟩ := by
    rw [hy0] at ha_ne_y0; exact ha_ne_y0
  have ha_b1 : a.id ≠ ⟨S₀.alloc.nextFreeBlock + 1⟩ := by
    rw [hy1] at ha_ne_y1; exact ha_ne_y1
  -- fd_ed25519_point_to( x, y, z, t, a );
  step_call using fd_ed25519_point_to.call_eq consuming ha
  clear hread_z hread_t hz_limbs ht_limbs ha_b0 ha_b1
  -- return fd_f25519_is_zero( x ) | fd_f25519_is_zero( y )
  step_call using fd_f25519_is_zero.call_eq consuming hread_x
  clear hx_limbs
  step_call using fd_f25519_is_zero.call_eq
  step_pure
  --   | fd_f25519_eq( y, fd_ed25519_order8_point_y0 )
  step_call using fd_f25519_eq.call_eq consuming hy0_read
  clear hy0_limbs
  step_pure
  --   | fd_f25519_eq( y, fd_ed25519_order8_point_y1 );
  step_call using fd_f25519_eq.call_eq consuming hy1_read
  clear hy1_limbs
  step_pure
  iterate 4 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref

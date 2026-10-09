module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_eq
public import Firedancer.Ref.Mlir.fd_ed25519_point_eq_z1

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `1` when `B.X * A.Z = A.X` and `B.Y * A.Z = A.Y` by `fd_f25519_eq` (`B.Z` taken as `1`), else
`0`; the two tests in the program's operand order. -/
def fd_ed25519_point_eq_z1.spec (A B : PointLimbs) : BitVec 32 :=
  let x1 := fd_f25519_mul.spec B.X A.Z
  let y1 := fd_f25519_mul.spec B.Y A.Z
  fd_f25519_eq.spec y1 A.Y &&& fd_f25519_eq.spec x1 A.X

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_eq_z1` returns `spec` of the points at `a` and `b`, which may be one point;
its two temporaries and the two of its `fd_f25519_eq` calls are freed, the counter moves on by four
blocks. -/
public theorem fd_ed25519_point_eq_z1.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.PointFit a) (hb : s.mem.PointFit b) :
    fd_ed25519_point_eq_z1.call (fd_ed25519_point_eq_z1.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_ed25519_point_eq_z1.spec (s.mem.readPoint a) (s.mem.readPoint b))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem }) := by
  func_init
  block_init
  -- fd_f25519_t x1[1], y1[1];
  step_pure
  step_alloca with x1
  step_alloca with y1
  iterate 2 step_pure
  have hx1_limbs := MemoryState.LimbsFit.of_fits hx1_fits hx1_off
  have hy1_limbs := MemoryState.LimbsFit.of_fits hy1_fits hy1_off
  -- reads of the temporaries go through the stores over the state after the `alloca`s
  have hx1₀ := hS ▸ hx1_limbs
  have hy1₀ := hS ▸ hy1_limbs
  clear hx1_fits hy1_fits
  -- fd_f25519_mul( x1, b->X, a->Z );
  step_pure
  step_call using fd_f25519_mul.call_eq
  -- fd_f25519_mul( y1, b->Y, a->Z );
  step_pure
  step_call using fd_f25519_mul.call_eq consuming hb
  -- return fd_f25519_eq( x1, a->X ) & fd_f25519_eq( y1, a->Y );
  step_call using fd_f25519_eq.call_eq consuming hread_x1
  clear hx1_limbs hx1₀
  step_pure
  step_call using fd_f25519_eq.call_eq consuming hread_y1
  clear ha hy1_limbs hy1₀
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref

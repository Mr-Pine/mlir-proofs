module

public import MLIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.Mlir.fd_f25519_sgn

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a`'s sign: the low bit of its canonical encoding, `buf[0] & 1` with `buf[0]` promoted to
`int`. -/
def fd_f25519_sgn.spec (a : Fin 5 → BitVec 64) : BitVec 32 :=
  let buf := fd_f25519_tobytes.spec a
  (buf.setWidth 8).setWidth 32 &&& 1#32

end

/-! ## Proof -/

section Proof

/-! ### The function -/

/-- `fd_f25519_sgn` returns `spec` of `a`'s limbs; the buffer and `tobytes`'s 21 blocks are freed
again: only the counter moves on. -/
public theorem fd_f25519_sgn.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) :
    fd_f25519_sgn.call (fd_f25519_sgn.args (.value a)) s =
      .value
        (.cons (.value (fd_f25519_sgn.spec (s.mem.readLimbs a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 22⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- uchar buf[32];
  step_alloca with buf
  step_pure
  -- fd_f25519_tobytes( buf, a );
  step_call using fd_f25519_tobytes.call_eq consuming ha
  -- return buf[0] & 1;
  step_load consuming hread_buf
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref

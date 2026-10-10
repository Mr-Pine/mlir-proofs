module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_f25519_sgn
public import Boringssl.fe_tobytes
public import Boringssl.Mlir.fe_isnegative

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_isnegative` returns `f`'s sign, the low bit of its canonical encoding: Firedancer's
`fd_f25519_sgn.spec` (the same `s[0] & 1`). The buffer and `fe_tobytes`'s 21 blocks are freed
again: only the counter moves on. -/
public theorem fe_isnegative.call_eq (f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : s.mem.LimbsFit f) :
    fe_isnegative.call (fe_isnegative.args (.value f)) s =
      .value
        (.cons (.value (Firedancer.Ref.fd_f25519_sgn.spec (s.mem.readLimbs f))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 22⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- uint8_t s[32];
  step_alloca with buf
  step_pure
  -- fe_tobytes(s, f);
  step_call using fe_tobytes.call_eq consuming hf
  -- return s[0] & 1;
  step_load consuming hread_buf
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl

module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.fd_f25519_fold_unsigned
public import Firedancer.R52x5.fd_r52x5_reduce
public import Firedancer.R52x5.wwl_st
public import Firedancer.R52x5.Mlir.fd_f25519_reduce

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_reduce( out, in )` stores the limbs of `fold in` at `out`; its temporary `h` is
freed, the counter moves on by one block. -/
public theorem fd_f25519_reduce.call_eq (out : Pointer) (x : Wwl) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) :
    fd_f25519_reduce.call (fd_f25519_reduce.args (.value out) (Ty.wrap x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs out (limbs (fold x)) }) := by
  have hout256 : Fits s.mem out 256 := (MemoryState.LimbsFit.fits hout).mono (by omega)
  rw [← MemoryState.storeLimbsV_eq hout]
  obtain ⟨hout_off, -, -, -, -, hout32⟩ := hout
  func_init
  block_init
  step_pure
  -- long h[8];
  step_alloca with h
  step_pure
  -- wwl_st( h, fd_f25519_fold_unsigned( in ) );
  step_call using fd_f25519_fold_unsigned.call_eq
  step_call using wwl_st.call_eq
  -- out[0] = (ulong)h[0]; … out[4] = (ulong)h[4];
  step_load [expandOfFn, Ty.extractVecElem_eq, BitVec.extractLsb'_setWidth_of_le]
  step_store
  step_pure
  step_load
  step_pure
  step_store
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5

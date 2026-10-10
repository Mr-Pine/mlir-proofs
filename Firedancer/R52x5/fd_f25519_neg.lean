module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_fold_unsigned
public import Firedancer.R52x5.Mlir.fd_f25519_neg

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_neg`: `fold (16 p - a)`. -/
def fd_f25519_neg.spec (a : Wwl) : Wwl :=
  fold (wwl_sub bias16p a)

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_neg( r, a )` stores `spec` of the element at `a` at `r` and returns `r`; `r` may
alias `a`. -/
public theorem fd_f25519_neg.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 512) (ha : Fits s.mem a 512) :
    fd_f25519_neg.call (fd_f25519_neg.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_neg.spec (s.mem.readVec a)) }) := by
  func_init
  block_init
  step_pure
  step_load
  step_pure
  step_call using fd_f25519_fold_unsigned.call_eq
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.R52x5

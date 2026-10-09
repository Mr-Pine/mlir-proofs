module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_fold_unsigned
public import Firedancer.R52x5.Mlir.fd_f25519_sub

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_sub`: `fold (a + 16 p - b)`, the compiled order. -/
def fd_f25519_sub.spec (a b : Wwl) : Wwl :=
  fold (wwl_sub (wwl_add a bias16p) b)

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_sub( r, a, b )` stores `spec` of the elements at `a` and `b` at `r` and returns
`r`; `r` may alias `a` or `b`. -/
public theorem fd_f25519_sub.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Fits s.mem r 512) (ha : Fits s.mem a 512) (hb : Fits s.mem b 512) :
    fd_f25519_sub.call (fd_f25519_sub.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r (fd_f25519_sub.spec (s.mem.readVec a) (s.mem.readVec b)) }) := by
  func_init
  block_init
  step_pure
  step_load
  step_load
  step_pure
  step_pure
  step_call using fd_f25519_fold_unsigned.call_eq
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.R52x5

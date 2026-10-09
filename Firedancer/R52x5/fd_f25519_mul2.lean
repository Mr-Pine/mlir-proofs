module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_f25519_mul
public import Firedancer.R52x5.Mlir.fd_f25519_mul2

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_f25519_mul2( r1, a1, b1, r2, a2, b2 )` stores `fd_f25519_mul.spec` of the elements at `a1`
and `b1` at `r1`, then that of `a2` and `b2` at `r2`; `r1` is apart from `a2` and `b2`. -/
public theorem fd_f25519_mul2.call_eq (r1 a1 b1 r2 a2 b2 : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr1 : Fits s.mem r1 512) (ha1 : Fits s.mem a1 512) (hb1 : Fits s.mem b1 512)
    (hr2 : Fits s.mem r2 512) (ha2 : Fits s.mem a2 512) (hb2 : Fits s.mem b2 512)
    (ha2r1 : r1.id ≠ a2.id) (hb2r1 : r1.id ≠ b2.id) :
    fd_f25519_mul2.call
        (fd_f25519_mul2.args (.value r1) (.value a1) (.value b1) (.value r2) (.value a2)
          (.value b2))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeVec r1
                    (fd_f25519_mul.spec (s.mem.readVec a1) (s.mem.readVec b1))).storeVec
                r2 (fd_f25519_mul.spec (s.mem.readVec a2) (s.mem.readVec b2)) }) := by
  func_init
  block_init
  step_call using fd_f25519_mul.call_eq
  step_call using fd_f25519_mul.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.R52x5

module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.Mlir.fd_f25519_mul3

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_f25519_mul3` stores its 3 products in order. No output is in the block of a later input, so each
product is of the inputs as they were. -/
public theorem fd_f25519_mul3.call_eq (r1 a1 b1 r2 a2 b2 r3 a3 b3 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.LimbsFit r1) (ha1 : s.mem.LimbsFit a1) (hb1 : s.mem.LimbsFit b1)
    (hr2 : s.mem.LimbsFit r2) (ha2 : s.mem.LimbsFit a2) (hb2 : s.mem.LimbsFit b2)
    (hr3 : s.mem.LimbsFit r3) (ha3 : s.mem.LimbsFit a3) (hb3 : s.mem.LimbsFit b3)
    (h1a2 : r1.id ≠ a2.id) (h1b2 : r1.id ≠ b2.id) (h1a3 : r1.id ≠ a3.id) (h1b3 : r1.id ≠ b3.id)
    (h2a3 : r2.id ≠ a3.id) (h2b3 : r2.id ≠ b3.id) :
    fd_f25519_mul3.call
        (fd_f25519_mul3.args (.value r1) (.value a1) (.value b1) (.value r2) (.value a2) (.value b2)
          (.value r3) (.value a3) (.value b3))
        s =
      .value
        (.nil,
          { s with
            mem :=
              ((s.mem.storeLimbs r1
                        (fd_f25519_mul.spec (s.mem.readLimbs a1) (s.mem.readLimbs b1))).storeLimbs
                    r2 (fd_f25519_mul.spec (s.mem.readLimbs a2) (s.mem.readLimbs b2))).storeLimbs
                r3 (fd_f25519_mul.spec (s.mem.readLimbs a3) (s.mem.readLimbs b3)) }) := by
  func_init
  block_init
  iterate 3 step_call using fd_f25519_mul.call_eq
  finish_block
  simp [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref

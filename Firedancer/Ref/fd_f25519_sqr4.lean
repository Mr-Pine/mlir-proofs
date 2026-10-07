module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.Mlir.fd_f25519_sqr4

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_f25519_sqr4` stores its 4 squares in order. No output is in the block of a later input, so each
square is of the inputs as they were. -/
public theorem fd_f25519_sqr4.call_eq (r1 a1 r2 a2 r3 a3 r4 a4 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.LimbsFit r1) (ha1 : s.mem.LimbsFit a1) (hr2 : s.mem.LimbsFit r2)
    (ha2 : s.mem.LimbsFit a2) (hr3 : s.mem.LimbsFit r3) (ha3 : s.mem.LimbsFit a3)
    (hr4 : s.mem.LimbsFit r4) (ha4 : s.mem.LimbsFit a4) (h1a2 : r1.id ≠ a2.id)
    (h1a3 : r1.id ≠ a3.id) (h1a4 : r1.id ≠ a4.id) (h2a3 : r2.id ≠ a3.id) (h2a4 : r2.id ≠ a4.id)
    (h3a4 : r3.id ≠ a4.id) :
    fd_f25519_sqr4.call
        (fd_f25519_sqr4.args (.value r1) (.value a1) (.value r2) (.value a2) (.value r3) (.value a3)
          (.value r4) (.value a4))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (((s.mem.storeLimbs r1 (fd_f25519_sqr.spec (s.mem.readLimbs a1))).storeLimbs r2
                        (fd_f25519_sqr.spec (s.mem.readLimbs a2))).storeLimbs
                    r3 (fd_f25519_sqr.spec (s.mem.readLimbs a3))).storeLimbs
                r4 (fd_f25519_sqr.spec (s.mem.readLimbs a4)) }) := by
  func_init
  block_init
  iterate 4 step_call using fd_f25519_sqr.call_eq
  finish_block
  simp [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref

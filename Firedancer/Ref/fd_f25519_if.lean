module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Common.Tactics
public import Firedancer.Ref.fiat_25519_selectznz
public import Firedancer.Ref.Mlir.fd_f25519_if

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a0` when `cond`'s low byte is nonzero, else `a1`: `cond ? a0 : a1` for `cond ∈ {0, 1}`. -/
def fd_f25519_if.spec (cond : BitVec 32) (a0 a1 : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_selectznz.spec (cond.setWidth 8) a1 a0

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_if` stores `spec cond a0 a1` at `r` and returns `r`; `r` may alias `a0` or `a1`.
`selectznz`'s five temporaries are freed again: only the counter moves on. -/
public theorem fd_f25519_if.call_eq (r : Pointer) (cond : BitVec 32) (a0 a1 : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.LimbsFit r) (ha0 : s.mem.LimbsFit a0)
    (ha1 : s.mem.LimbsFit a1) :
    fd_f25519_if.call (fd_f25519_if.args (.value r) (.value cond) (.value a0) (.value a1)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem :=
              s.mem.storeLimbs r
                (fd_f25519_if.spec cond (s.mem.readLimbs a0) (s.mem.readLimbs a1)) }) := by
  func_init
  block_init
  -- fiat_25519_selectznz( r->el, (uchar)cond, a1->el, a0->el );
  step_pure
  step_call using fiat_25519_selectznz.call_eq
  finish_block
  clear_reads
  subst hS
  erase_frame
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref

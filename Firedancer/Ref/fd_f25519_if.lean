module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fiat_25519_selectznz
public import Firedancer.Ref.Mlir.fd_f25519_if

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `a0` when `cond`'s low byte is nonzero, else `a1`: `cond ? a0 : a1` for `cond ∈ {0, 1}`. -/
def fd_f25519_if.spec (cond : BitVec 32) (a0 a1 : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fiat_25519_selectznz.spec (cond.setWidth 8) a1 a0

end

/-! ## Proof -/

section Proof

/-- `trunc nuw` of a byte-sized `cond` is defined. -/
theorem setWidth_setWidth_of_lt {cond : BitVec 32} (hcond : cond.toNat < 256) :
    (cond.setWidth 8).setWidth 32 = cond := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth]
  omega

/-- `fd_f25519_if` stores `spec cond a0 a1` at `r` and returns `r`; `r` may alias `a0` or `a1`.
`selectznz`'s five temporaries are freed again: only the counter moves on.
`hcond` is the `range(0, 256)` that makes `(uchar)cond` a `trunc nuw`. -/
public theorem fd_f25519_if.call_eq (r : Pointer) (cond : BitVec 32) (a0 a1 : Pointer)
    (hcond : cond.toNat < 256) (s : GlobalState) (hwf : s.WF) (hr : s.mem.LimbsRoom r)
    (ha0 : s.mem.LimbsFit a0) (ha1 : s.mem.LimbsFit a1) :
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
  step_pure [setWidth_setWidth_of_lt hcond]
  step_call using fiat_25519_selectznz.call_eq
  finish_block
  clear_reads
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref

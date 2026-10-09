module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.Mlir.fd_f25519_if

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_if`: `a0` if `cond` is nonzero, else `a1`. -/
def fd_f25519_if.spec (cond : BitVec 32) (a0 a1 : Wwl) : Wwl :=
  if cond = 0 then a1 else a0

end

/-! ## Proof -/

section Proof

/-- The lane mask of `cond = 0`: every lane clear. -/
theorem fd_f25519_if.mask_zero (h : (Ty.bv 8).width = (Ty.bv 8).width) (k : Fin 8) :
    Ty.extractVecElem 8 1 k (@BitVec.cast 8 8 h 0#8) = 0#1 := by
  rw [Ty.extractVecElem_eq]; revert h k; decide

/-- The lane mask of `cond = 1`: every lane set. -/
theorem fd_f25519_if.mask_one (h : (Ty.bv 8).width = (Ty.bv 8).width) (k : Fin 8) :
    Ty.extractVecElem 8 1 k (@BitVec.cast 8 8 h 255#8) = 1#1 := by
  rw [Ty.extractVecElem_eq]; revert h k; decide

/-- `fd_f25519_if( r, cond, a0, a1 )` stores `spec` at `r` and returns `r`, for `cond` `0` or `1`
(the compiled `trunc nuw nsw` to a byte); `r` may alias `a0` or `a1`. -/
public theorem fd_f25519_if.call_eq (r : Pointer) (cond : BitVec 32) (a0 a1 : Pointer)
    (s : GlobalState) (hwf : s.WF) (hc : cond = 0 ∨ cond = 1) (hr : Fits s.mem r 512)
    (ha0 : Fits s.mem a0 512) (ha1 : Fits s.mem a1 512) :
    fd_f25519_if.call (fd_f25519_if.args (.value r) (.value cond) (.value a0) (.value a1)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r
                (fd_f25519_if.spec cond (s.mem.readVec a0) (s.mem.readVec a1)) }) := by
  have h0 : (0#8).ssubOverflow 0#8 = false := by decide
  have h1 : (0#8).ssubOverflow 1#8 = false := by decide
  rcases hc with rfl | rfl
  all_goals
    func_init
    block_init
    step_pure
    step_pure
    step_pure [h0, h1]
    step_load
    step_load
    step_pure
    step_pure [expandOfFn, fd_f25519_if.mask_zero, fd_f25519_if.mask_one]
    step_store
    finish_block
    rw [hS]
    rfl

end Proof

end MLIR.Firedancer.R52x5

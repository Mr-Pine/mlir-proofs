module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.LaneNI.Mlir.fd_f25519_if
public import Firedancer.LaneNI.Mlir.fd_f25519_if_85

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- A select by the lane mask of all-ones bits: its first operand. -/
private theorem select_ones (h : 8 = 1 * 8) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (BitVec.cast h 255#8) = 1#1 then x[(i : Nat)]
        else y[(i : Nat)]) = x := by
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;> first | omega | simp [Ty.extractVecElem_eq]

/-- A select by the lane mask of zero bits: its second operand. -/
private theorem select_zeros (h : 8 = 1 * 8) (m : BitVec 8) (hm : m = 0#8) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (BitVec.cast h m) = 1#1 then x[(i : Nat)]
        else y[(i : Nat)]) = y := by
  subst hm
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;> first | omega | simp [Ty.extractVecElem_eq]

/-- `fd_f25519_if` stores `cond ? a0 : a1` at `r` and returns `r`; `cond` is `0` or `1`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_if.call_eq (r : Pointer) (cond : BitVec 32)
    (a0 a1 : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512)
    (hc : cond = 0 ∨ cond = 1) :
    Firedancer.LaneNI.Mlir.fd_f25519_if.call
        (Firedancer.LaneNI.Mlir.fd_f25519_if.args (.value r) (.value cond) (Ty.wrap a0)
          (Ty.wrap a1)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.ifc cond a0 a1) }) := by
  rcases hc with rfl | rfl
  all_goals
    func_init
    block_init
    iterate 4 step_pure
    step_pure with v
  · have e : v = a1 := by rw [hv]; exact select_ones _ _ _
    step_store
    finish_block
    subst_vars
    rfl
  · have e : v = a0 := by rw [hv]; exact select_zeros _ _ rfl _ _
    step_store
    finish_block
    subst_vars
    rfl

/-- `fd_f25519_if_85` stores `cond ? a0 : a1` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_if_85.call_eq (r : Pointer)
    (cond : BitVec 32) (a0 a1 : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_if_85.call
        (Firedancer.LaneNI.Mlir.fd_f25519_if_85.args (.value r) (.value cond) (Ty.wrap a0)
          (Ty.wrap a1)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.ifc cond a0 a1) }) := by
  by_cases hc : cond = 0
  · subst hc
    func_init
    block_init
    iterate 4 step_pure
    step_pure with v
    have e : v = a1 := by rw [hv]; exact select_ones _ _ _
    step_store
    finish_block
    subst_vars
    rfl
  · func_init
    block_init
    iterate 4 step_pure
    step_pure with v
    have e : v = a0 := by
      rw [hv]; refine select_zeros _ _ ?_ _ _
      simp [show (cond == 0#32) = false from by simpa using hc]
    step_store
    finish_block
    subst_vars
    rw [MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.ifc, ite_eq_right hc]
    rfl

end Proof

end MLIR.Firedancer.LaneNI

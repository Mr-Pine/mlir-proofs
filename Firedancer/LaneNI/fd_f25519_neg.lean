module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.Neg
public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.LaneNI.Mlir.fd_f25519_neg
public import Firedancer.LaneNI.Mlir.fd_f25519_neg_79
public import Firedancer.LaneNI.Mlir.fd_f25519_neg_70
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_neg` stores `-a` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_neg.call_eq (r : Pointer)
    (a : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_neg.call
        (Firedancer.LaneNI.Mlir.fd_f25519_neg.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.neg a) }) := by
  func_init
  block_init
  iterate 25 step_pure
  -- `fd_r43x6_neg_fast( a )`, `fd_r43x6_fold_signed`
  step_pure with transparent d
  step_pure with transparent lo
  step_pure [foldShifts_lt] with transparent hi
  step_pure with transparent c
  step_pure with transparent t
  step_pure with transparent u
  step_pure [MLIR.Firedancer.Lane.SqrtRatio.negBias_no_overflow'] with transparent s1
  step_pure with transparent s2
  step_pure with n
  have e : n = negFold a := by
    subst hn
    apply vec_ext_fin
    intro i
    fin_cases i
    all_goals simp [negFold, negP, foldMask, foldShifts, negBias, neg18, negSel]
    simp only [allOnes_64, BitVec.and_allOnes]
  step_store
  finish_block
  subst_vars
  rw [← MLIR.Firedancer.Lane.SqrtRatio.negFold_eq_neg]
  rfl

/-- `fd_f25519_neg_70` is `fd_f25519_neg` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_neg_70.call_eq (r : Pointer)
    (a : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_neg_70.call
        (Firedancer.LaneNI.Mlir.fd_f25519_neg_70.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.neg a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_neg.call_eq r a s hwf hr

/-- `fd_f25519_neg_79` is `fd_f25519_neg` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_neg_79.call_eq (r : Pointer)
    (a : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_neg_79.call
        (Firedancer.LaneNI.Mlir.fd_f25519_neg_79.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.neg a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_neg.call_eq r a s hwf hr

end Proof

end MLIR.Firedancer.LaneNI

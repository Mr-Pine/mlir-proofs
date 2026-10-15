module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.fd_f25519_sub
public import Firedancer.LaneNI.fd_f25519_one
public import Firedancer.LaneNI.Mlir.fd_f25519_sub
public import Firedancer.LaneNI.Mlir.fd_f25519_sub_72
public import Firedancer.LaneNI.Mlir.fd_f25519_sub_155
public import Firedancer.LaneNI.Mlir.fd_f25519_sub_130
public import Firedancer.LaneNI.Mlir.fd_f25519_sub_76
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- Lane 0 of `a - 1 + (p - _b)`, as the constant folds it. -/
private theorem sub_one_add (x : BitVec 64) :
    x - 1#64 + 8795933638637#64 = x + 8795933638636#64 := by
  bv_omega

/-- Lane 0's carry product, masked by `-1`. -/
private theorem mul18_and (x : BitVec 64) :
    (x * 18#64 &&& 18446744073709551615#64) = 18#64 * x := by
  rw [show (18446744073709551615#64) = BitVec.allOnes 64 by decide, BitVec.and_allOnes,
    BitVec.mul_comm]

/-- `fd_f25519_sub_72` stores `fd_f25519_sub.spec a b` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call_eq (r : Pointer)
    (a b : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sub_72.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_f25519_sub.spec a b) }) := by
  rw [MemoryState.storeVec]
  func_init
  block_init
  step_pure with _b
  step_pure with d_mask
  step_pure with eighteen
  -- lane indices `7 … 1`
  iterate 7 step_pure
  step_pure with pb
  step_pure with m
  step_pure with sh
  -- `wwl_zero()` as `#v[0, poison, …]`: the rotation reads only its lane 0
  iterate 12 step_pure
  -- `fd_r43x6_sub_fast`
  step_pure
  step_pure with _x
  -- `fd_r43x6_fold_signed`
  step_pure with _xl
  step_pure opaque [hsh, expandOfFn] with _xh
  step_pure with _c
  step_pure [heighteen]
  step_pure [hd_mask] with _d
  step_pure opaque [h_xl, hm, h_b, expandOfFn, and_add_no_overflow] with _xl_b
  step_pure
  step_pure
  step_store
  finish_block
  rw [hS]
  subst_vars
  clear hfits_r hArgs hwf
  congr 1; congr 1; congr 1; congr 1; congr 1
  apply vec_ext_fin
  intro i
  fin_cases i
  all_goals try simp [fd_f25519_sub.spec]
  -- the compiled sum is `_xl + _b + _c + _d`; lane 0: `(c * 18) &&& -1 = 18 * c`
  · simp only [mul18_and]
    ac_rfl
  all_goals ac_rfl

/-- `fd_f25519_sub` with `b` fixed to `fd_f25519_one`: stores `fd_f25519_sub.spec a 1` at `r`,
returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sub.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sub.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sub.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_sub.spec a fd_f25519_one.vec) }) := by
  rw [MemoryState.storeVec]
  func_init
  block_init
  step_pure with _b
  step_pure with d_mask
  step_pure with eighteen
  -- lane indices `7 … 1`
  iterate 7 step_pure
  step_pure with pb
  step_pure with m
  step_pure with sh
  -- `wwl_zero()` as `#v[0, poison, …]`: the rotation reads only its lane 0
  iterate 12 step_pure
  -- `fd_r43x6_sub_fast`
  step_pure with _x
  -- `fd_r43x6_fold_signed`
  step_pure with _xl
  step_pure opaque [hsh, expandOfFn] with _xh
  step_pure with _c
  step_pure [heighteen]
  step_pure [hd_mask] with _d
  step_pure opaque [h_xl, hm, h_b, expandOfFn, and_add_no_overflow] with _xl_b
  step_pure
  step_pure
  step_store
  finish_block
  rw [hS]
  subst_vars
  clear hfits_r hArgs hwf
  congr 1; congr 1; congr 1; congr 1; congr 1
  apply vec_ext_fin
  intro i
  fin_cases i
  all_goals try simp [fd_f25519_sub.spec, fd_f25519_one.vec, wwl, sub_one_add]
  -- the compiled sum is `_xl + _b + _c + _d`; lane 0: `(c * 18) &&& -1 = 18 * c`
  · simp only [mul18_and]
    ac_rfl
  all_goals ac_rfl

/-- `fd_f25519_sub_76` is `fd_f25519_sub_72` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sub_76.call_eq (r : Pointer)
    (a b : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sub_76.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sub_76.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_f25519_sub.spec a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call_eq r a b s hwf hr

/-- `fd_f25519_sub_130` is `fd_f25519_sub_72` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sub_130.call_eq (r : Pointer)
    (a b : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sub_130.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sub_130.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_f25519_sub.spec a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call_eq r a b s hwf hr

/-- `fd_f25519_sub_155` is `fd_f25519_sub_72` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sub_155.call_eq (r : Pointer)
    (a b : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sub_155.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sub_155.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_f25519_sub.spec a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call_eq r a b s hwf hr

end Proof

end MLIR.Firedancer.LaneNI

module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.Avx512.Common.R43x6
public import Firedancer.LaneNI.fd_f25519_one
public import Firedancer.LaneNI.Mlir.fd_f25519_add
public import Firedancer.LaneNI.Mlir.fd_f25519_add_45
public import Firedancer.LaneNI.Mlir.fd_f25519_add_77

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_add(a, b)`: `fd_r43x6_fold_unsigned(fd_r43x6_add_fast(a, b))`. -/
def fd_f25519_add.spec (a b : Wwl) : Wwl :=
  fold (fd_r43x6_add_fast a b)

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_add_77` stores `fd_f25519_add.spec a b` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_add_77.call_eq (r : Pointer)
    (a b : Wwl) (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_add_77.call
        (Firedancer.LaneNI.Mlir.fd_f25519_add_77.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_f25519_add.spec a b) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_pure with x
  have e : x = fd_r43x6_add_fast a b := by
    rw [hx]; ext i hi : 1; simp [fd_r43x6_add_fast, wwl_add, BitVec.add_comm]
  step_pattern using runBodyFrom_foldRun with f
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_add` with `b` fixed to `fd_f25519_one`: stores `fd_f25519_add.spec a 1` at `r`,
returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_add.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_add.call
        (Firedancer.LaneNI.Mlir.fd_f25519_add.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_add.spec a fd_f25519_one.vec) }) := by
  func_init
  block_init
  iterate 5 step_pure
  step_pure with x
  have e : x = fd_r43x6_add_fast a fd_f25519_one.vec := by
    rw [hx]; ext i hi : 1
    simp [fd_r43x6_add_fast, wwl_add, fd_f25519_one.vec, wwl]
  step_pattern using runBodyFrom_foldRun with f
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_add_45` folds `a`: stores `fold a` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_add_45.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_add_45.call
        (Firedancer.LaneNI.Mlir.fd_f25519_add_45.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fold a) }) := by
  func_init
  block_init
  iterate 4 step_pure
  -- `fd_r43x6_fold_unsigned( a )`, its operand an argument
  step_pure with transparent xl
  step_pure [foldShifts_lt] with transparent xh
  step_pure with transparent c
  step_pure with f
  have e : f = fold a := by
    rw [hf, fold]
    ext i hi : 1
    simp [Vector.getElem_ofFn hi]
  step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.LaneNI

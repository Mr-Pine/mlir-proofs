module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_ulong_find_lsb
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `__builtin_ffsl( (long)x )-1`: the index of `x`'s least significant set bit, `-1` for `0`. -/
def fd_ulong_find_lsb.spec (x : BitVec 64) : BitVec 32 :=
  if x = 0#64 then -1#32 else x.ctz.setWidth 32

end

/-! ## Proof -/

section Proof

/-- `ctz` fits an `int`: the `trunc nuw nsw` to 32 bits is exact. -/
public theorem fd_ulong_find_lsb.ctz_trunc (x : BitVec 64) :
    (x.ctz.setWidth 32).setWidth 64 = x.ctz ∧ (x.ctz.setWidth 32).signExtend 64 = x.ctz := by
  have h : x.ctz ≤ 64#64 := BitVec.ctz_eq_reverse_clz ▸ BitVec.clz_le
  generalize x.ctz = c at h ⊢
  constructor <;> bv_decide

/-- `fd_ulong_find_lsb` returns `spec x`. -/
public theorem fd_ulong_find_lsb.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_find_lsb.call (fd_ulong_find_lsb.args (.value x)) s =
      .value (.cons (.value (fd_ulong_find_lsb.spec x)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [fd_ulong_find_lsb.ctz_trunc]
  step_pure
  finish_block
  rw [hS, fd_ulong_find_lsb.spec]
  by_cases hx : x = 0#64 <;> simp [hx, beq_eq_false_iff_ne.2]

end Proof

end MLIR.Firedancer.Ref

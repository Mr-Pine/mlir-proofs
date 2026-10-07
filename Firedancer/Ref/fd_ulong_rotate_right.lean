module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_ulong_rotate_right
import Std.Tactic.BVDecide

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `x` rotated right by `n` bits: `(x >> (n&63)) | (x << ((-n)&63))`. -/
def fd_ulong_rotate_right.spec (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  (x >>> (n &&& 63#32).toNat) ||| (x <<< (-n &&& 63#32).toNat)

end

/-! ## Proof -/

section Proof

/-- `llvm.intr.fshr( x, x, n )` computes `spec`. -/
theorem fd_ulong_rotate_right.fshr_eq (x : BitVec 64) (n : BitVec 32) :
    ((x ++ x) >>> (n.toNat % 64)).setWidth 64 = fd_ulong_rotate_right.spec x n := by
  have h1 : n.toNat % 64 = ((n &&& 63#32).setWidth 128).toNat := by
    rw [BitVec.toNat_setWidth_of_le (by decide), BitVec.toNat_and,
      show (63#32).toNat = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have h2 : (n &&& 63#32).toNat = ((n &&& 63#32).setWidth 64).toNat :=
    (BitVec.toNat_setWidth_of_le (by decide)).symm
  have h3 : (-n &&& 63#32).toNat = ((-n &&& 63#32).setWidth 64).toNat :=
    (BitVec.toNat_setWidth_of_le (by decide)).symm
  rw [fd_ulong_rotate_right.spec, h1, h2, h3, ← BitVec.ushiftRight_eq', ← BitVec.ushiftRight_eq', ←
    BitVec.shiftLeft_eq']
  bv_decide

/-- `fd_ulong_rotate_right` returns `spec x n`. -/
public theorem fd_ulong_rotate_right.call_eq (x : BitVec 64) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) :
    fd_ulong_rotate_right.call (fd_ulong_rotate_right.args (.value x) (.value n)) s =
      .value (.cons (.value (fd_ulong_rotate_right.spec x n)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_pure [fd_ulong_rotate_right.fshr_eq]
  finish_block
  rw [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref

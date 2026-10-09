module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_ulong_rotate_right
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `x` rotated right by `n` bits: `(x >> (n&63)) | (x << ((-n)&63))`. -/
def fd_ulong_rotate_right.spec (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  (x >>> (n &&& 63#32).toNat) ||| (x <<< (-n &&& 63#32).toNat)

end

/-! ## Proof -/

section Proof

/-- `sub nsw 0, n` does not overflow. -/
theorem fd_ulong_rotate_right.ssubOverflow_eq (n : BitVec 32) (hn : n.toNat < 64) :
    (0#32).ssubOverflow n = false := by
  have : n < 64#32 := by rw [BitVec.lt_def]; exact hn
  bv_decide

/-- The lifted shift count `(-n)&63`, as the step leaves it. -/
theorem fd_ulong_rotate_right.neg_and_eq (n : BitVec 32) :
    (4294967296 - n.toNat) % 4294967296 % 18446744073709551616 &&& 63 = (-n &&& 63#32).toNat := by
  rw [BitVec.toNat_and, BitVec.toNat_neg, Nat.mod_eq_of_lt (a := _ % 4294967296) (by omega)]
  rfl

/-- The `shl` count `(-n)&63` is below 64. -/
theorem fd_ulong_rotate_right.neg_and_lt (n : BitVec 32) :
    ¬64 ≤ (4294967296 - n.toNat) % 4294967296 % 18446744073709551616 &&& 63 :=
  Nat.not_le.2 (Nat.lt_of_le_of_lt Nat.and_le_right (by decide))

/-- `(x << ((-n)&63)) | (x >> n)`, as the step leaves it, computes `spec` for `n < 64`. -/
theorem fd_ulong_rotate_right.value_eq (x : BitVec 64) (n : BitVec 32) (hn : n.toNat < 64) :
    x <<< ((4294967296 - n.toNat) % 4294967296 % 18446744073709551616 &&& 63) ||| x >>> n.toNat =
      fd_ulong_rotate_right.spec x n := by
  have h : (n &&& 63#32).toNat = n.toNat := by
    rw [BitVec.toNat_and, show (63#32).toNat = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
      Nat.mod_eq_of_lt hn]
  rw [fd_ulong_rotate_right.neg_and_eq, fd_ulong_rotate_right.spec, BitVec.or_comm, h]

/-- `fd_ulong_rotate_right` returns `spec x n` for `n < 64`. -/
public theorem fd_ulong_rotate_right.call_eq (x : BitVec 64) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hn : n.toNat < 64) :
    fd_ulong_rotate_right.call (fd_ulong_rotate_right.args (.value x) (.value n)) s =
      .value (.cons (.value (fd_ulong_rotate_right.spec x n)) .nil, s) := by
  have hmsb : n.msb = false := by
    rw [BitVec.msb_eq_false_iff_two_mul_lt]; omega
  have hmod : n.toNat % 18446744073709551616 = n.toNat := Nat.mod_eq_of_lt (by omega)
  have hsh : ¬64 ≤ n.toNat := by omega
  have h63 : (63#32).msb = false := by decide
  func_init
  block_init
  step_pure
  step_pure
  step_pure [hmsb]
  step_pure [hmod, hsh]
  step_pure [fd_ulong_rotate_right.ssubOverflow_eq n hn]
  step_pure
  step_pure
  step_pure [fd_ulong_rotate_right.neg_and_lt, h63]
  step_pure [fd_ulong_rotate_right.value_eq x n hn]
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.Ref

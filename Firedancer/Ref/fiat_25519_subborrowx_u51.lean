module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Mlir.fiat_25519_subborrowx_u51
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The 51-bit difference and its borrow: `(x3, 0 - x2)`, stored at `out1` and `out2`. `x1`
subtracts the sum `arg1 + arg3`, as the compiled code does. -/
def fiat_25519_subborrowx_u51.spec (arg1 : BitVec 8) (arg2 arg3 : BitVec 64) :
    BitVec 64 × BitVec 8 :=
  let x1 := arg2 - (arg1.setWidth 64 + arg3)
  let x2 := (x1 >>> 51).setWidth 8
  let x3 := x1 &&& 2251799813685247#64
  (x3, 0 - x2)

end

/-! ## Proof -/

section Proof

/-- `arg3 + arg1` (the `add nuw nsw`) does not wrap signed for `arg3 < 2 ^ 51`. -/
theorem subborrowx_saddOverflow (a : BitVec 64) (c : BitVec 8) (h : a.toNat < 2 ^ 51) :
    ¬a.saddOverflow (c.setWidth 64) := by
  have : a < 2251799813685248#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `arg3 + arg1` (the `add nuw nsw`) does not wrap unsigned for `arg3 < 2 ^ 51`. -/
theorem subborrowx_uaddOverflow (a : BitVec 64) (c : BitVec 8) (h : a.toNat < 2 ^ 51) :
    ¬a.uaddOverflow (c.setWidth 64) := by
  have : a < 2251799813685248#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `subborrowx` stores the difference's low 51 bits at `out1`, then its borrow at `out2`. -/
public theorem fiat_25519_subborrowx_u51.call_eq (out1 out2 : Pointer) (arg1 : BitVec 8)
    (arg2 arg3 : BitVec 64) (s : GlobalState) (hwf : s.WF) (hout1 : Room s.mem out1 64)
    (hout2 : Room s.mem out2 8) (harg3 : arg3.toNat < 2 ^ 51) :
    fiat_25519_subborrowx_u51.call
        (fiat_25519_subborrowx_u51.args (.value out1) (.value out2) (.value arg1) (.value arg2)
          (.value arg3))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeAt out1 (fiat_25519_subborrowx_u51.spec arg1 arg2 arg3).1).storeAt out2
                (fiat_25519_subborrowx_u51.spec arg1 arg2 arg3).2 }) := by
  func_init
  block_init
  iterate 3 step_pure
  -- x1 = ((int64_t)((int64_t)arg2 - (int64_t)arg1) - (int64_t)arg3);
  step_pure
  step_pure [subborrowx_saddOverflow _ _ harg3, subborrowx_uaddOverflow _ _ harg3]
  step_pure with x1
  -- x2 = (fiat_25519_int1)(x1 >> 51);
  step_pure
  step_pure
  -- x3 = ((uint64_t)x1 & UINT64_C(0x7ffffffffffff)); *out1 = x3;
  step_pure
  step_store
  -- *out2 = (fiat_25519_uint1)(0x0 - x2);
  step_pure
  step_store
  finish_block
  rw [hS]
  subst_vars
  rw [BitVec.add_comm arg3]
  rfl

end Proof

end MLIR.Firedancer.Ref

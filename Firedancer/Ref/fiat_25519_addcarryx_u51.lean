module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Mlir.fiat_25519_addcarryx_u51

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The 51-bit sum and its carry: `(x2, x3)`, stored at `out1` and `out2`. -/
def fiat_25519_addcarryx_u51.spec (arg1 : BitVec 8) (arg2 arg3 : BitVec 64) :
    BitVec 64 × BitVec 8 :=
  let x1 := arg1.setWidth 64 + arg2 + arg3
  let x2 := x1 &&& 2251799813685247#64
  let x3 := (x1 >>> 51).setWidth 8
  (x2, x3)

end

/-! ## Proof -/

section Proof

/-- `addcarryx` stores the sum's low 51 bits at `out1`, then its carry at `out2`. -/
public theorem fiat_25519_addcarryx_u51.call_eq (out1 out2 : Pointer) (arg1 : BitVec 8)
    (arg2 arg3 : BitVec 64) (s : GlobalState) (hwf : s.WF) (hout1 : Room s.mem out1 64)
    (hout2 : Room s.mem out2 8) :
    fiat_25519_addcarryx_u51.call
        (fiat_25519_addcarryx_u51.args (.value out1) (.value out2) (.value arg1) (.value arg2)
          (.value arg3))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeAt out1 (fiat_25519_addcarryx_u51.spec arg1 arg2 arg3).1).storeAt out2
                (fiat_25519_addcarryx_u51.spec arg1 arg2 arg3).2 }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- x1 = ((arg1 + arg2) + arg3);
  step_pure
  step_pure
  step_pure with x1
  -- x2 = (x1 & UINT64_C(0x7ffffffffffff));
  step_pure
  -- x3 = (fiat_25519_uint1)(x1 >> 51);
  step_pure
  step_pure
  step_store
  step_store
  finish_block
  rw [hS]
  subst_vars
  rw [BitVec.add_comm arg2]
  rfl

end Proof

end MLIR.Firedancer.Ref

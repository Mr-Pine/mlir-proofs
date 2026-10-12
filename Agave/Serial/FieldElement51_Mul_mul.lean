module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.FieldElement51
public import Agave.Serial.Mlir.FieldElement51_Mul_mul

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `&a * &b`, named as in the Rust: the column sums `c0 … c4` (limbs past the top wrap round
times 19, `b1_19 … b4_19`), carried at bit 51 into `out`, then `carry * 19` into `out[0]` and one
more carry; sums in the code's operand order. -/
def FieldElement51_Mul_mul.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let b1_19 := b 1 * 19#64
  let b2_19 := b 2 * 19#64
  let b3_19 := b 3 * 19#64
  let b4_19 := b 4 * 19#64
  let c0 :=
    mulWide (a 4) b1_19 + mulWide (b 0) (a 0) + mulWide (a 3) b2_19 + mulWide (a 2) b3_19 +
      mulWide (a 1) b4_19
  let c1 :=
    mulWide (a 4) b2_19 + mulWide (a 0) (b 1) + mulWide (a 3) b3_19 + mulWide (a 2) b4_19 +
      mulWide (a 1) (b 0) +
      carry128 c0
  let out0 := c0.setWidth 64 &&& mask51
  let c2 :=
    mulWide (a 4) b3_19 + mulWide (a 0) (b 2) + mulWide (a 3) b4_19 + mulWide (a 2) (b 0) +
      mulWide (a 1) (b 1) +
      carry128 c1
  let out1 := c1.setWidth 64 &&& mask51
  let c3 :=
    mulWide (a 4) b4_19 + mulWide (a 0) (b 3) + mulWide (a 3) (b 0) + mulWide (a 2) (b 1) +
      mulWide (a 1) (b 2) +
      carry128 c2
  let out2 := c2.setWidth 64 &&& mask51
  let c4 :=
    mulWide (a 4) (b 0) + mulWide (a 0) (b 4) + mulWide (a 3) (b 1) + mulWide (a 2) (b 2) +
      mulWide (a 1) (b 3) +
      carry128 c3
  let out3 := c3.setWidth 64 &&& mask51
  let carry := (c4 >>> 51).setWidth 64
  let out4 := c4.setWidth 64 &&& mask51
  let out0' := carry * 19#64 + out0
  let out1' := out0' >>> 51 + out1
  fun
  | 0 => out0' &&& mask51
  | 1 => out1'
  | 2 => out2
  | 3 => out3
  | 4 => out4

end

/-! ## Proof -/

section Proof

/-- `&a * &b` stores `spec a b` at `out`. The loads all come before the stores, so `out` may alias
`a` or `b`; the `nuw`/`nsw` flags never fire. -/
public theorem FieldElement51_Mul_mul.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    FieldElement51_Mul_mul.call (FieldElement51_Mul_mul.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (FieldElement51_Mul_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  block_init
  iterate 5 step_pure
  -- let b1_19 = b[1] * 19; … let b4_19 = b[4] * 19;
  step_pure
  step_load with b1
  step_pure with b1_19
  step_pure
  step_load with b2
  step_pure with b2_19
  step_pure
  step_load with b3
  step_pure with b3_19
  step_pure
  step_load with b4
  step_pure with b4_19
  -- c0 = m(a[0], b[0]) + m(a[4], b1_19) + m(a[3], b2_19) + m(a[2], b3_19) + m(a[1], b4_19);
  step_load with a0
  step_load with b0
  iterate 3 step_pure
  step_pure
  step_load with a4
  iterate 4 step_pure
  step_pure
  step_load with a3
  iterate 4 step_pure
  step_pure
  step_load with a2
  iterate 4 step_pure
  step_pure
  step_load with a1
  iterate 3 step_pure
  step_pure with c0
  -- the other columns' products
  iterate 24 step_pure
  -- c1 … c4, each plus the previous carry, and out[0] … out[4]
  iterate 7 step_pure
  step_pure with c1
  step_pure with out0
  iterate 7 step_pure
  step_pure with c2
  step_pure with out1
  iterate 7 step_pure
  step_pure with c3
  step_pure with out2
  iterate 7 step_pure
  step_pure with c4
  step_pure with out3
  -- let carry = (c4 >> 51) as u64; out[4] = (c4 as u64) & LOW_51_BIT_MASK;
  step_pure
  step_pure with carry
  step_pure
  step_pure with out4
  -- out[0] += carry * 19; out[1] += out[0] >> 51; out[0] &= LOW_51_BIT_MASK;
  step_pure
  step_pure with out0'
  step_pure
  step_pure [hout1] with out1'
  step_pure
  -- the stores
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  subst hS
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial

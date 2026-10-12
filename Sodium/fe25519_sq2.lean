module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Agave.Serial.FieldElement51
public import Sodium.Mlir.fe25519_sq2
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

open Agave.Serial (mulWide)

/-! ## Specification -/

@[expose] public section

/-- `2 f * f`, named as in the C: `fe25519_sq.spec`'s column sums `r0 … r4`, doubled
(`r0 <<= 1; …`), then carried; sums in the code's operand order. -/
def fe25519_sq2.spec (f : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#64
  let f0_2 := f 0 <<< 1
  let f1_2 := f 1 <<< 1
  let f1_38 := f 1 * 38#64
  let f2_38 := f 2 * 38#64
  let f3_38 := f 3 * 38#64
  let f3_19 := f 3 * 19#64
  let f4_19 := f 4 * 19#64
  let r0 := mulWide f2_38 (f 3) + mulWide (f 0) (f 0) + mulWide (f 4) f1_38
  let r1 := mulWide (f 4) f2_38 + mulWide f0_2 (f 1) + mulWide f3_19 (f 3)
  let r2 := mulWide (f 2) f0_2 + mulWide (f 1) (f 1) + mulWide f3_38 (f 4)
  let r3 := mulWide (f 3) f0_2 + mulWide f1_2 (f 2) + mulWide f4_19 (f 4)
  let r4 := mulWide (f 3) f1_2 + mulWide (f 2) (f 2) + mulWide (f 4) f0_2
  let r0 := r0 <<< 1
  let r1 := r1 <<< 1
  let r2 := r2 <<< 1
  let r3 := r3 <<< 1
  let r4 := r4 <<< 1
  let r00 := r0.setWidth 64 &&& mask
  let r1 := r0 >>> 51 + r1
  let r01 := r1.setWidth 64 &&& mask
  let r2 := r1 >>> 51 + r2
  let r02 := r2.setWidth 64 &&& mask
  let r3 := r2 >>> 51 + r3
  let r03 := r3.setWidth 64 &&& mask
  let r4 := r3 >>> 51 + r4
  let r04 := r4.setWidth 64 &&& mask
  let r00 := (r4 >>> 51).setWidth 64 * 19#64 + r00
  let r01 := r00 >>> 51 + r01
  let r02 := r01 >>> 51 + r02
  fun
  | 0 => r00 &&& mask
  | 1 => r01 &&& mask
  | 2 => r02
  | 3 => r03
  | 4 => r04

end

/-! ## Proof -/

section Proof

/-- A doubled column's low bit is clear: the code masks it with `mask - 1`. -/
theorem shl_and_mask (x : BitVec 64) :
    x <<< 1 &&& 2251799813685246#64 = x <<< 1 &&& 2251799813685247#64 := by bv_decide

/-- `fe25519_sq2` stores `spec f` at `h`. The loads all come before the stores, so `h` may alias
`f`; the `nuw`/`nsw` flags never fire. -/
public theorem fe25519_sq2.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe25519_sq2.call (fe25519_sq2.args (.value h) (.value f)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs h (fe25519_sq2.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  iterate 8 step_pure
  -- f0 = f[0]; … f4 = f[4];
  step_load with f0
  step_pure
  step_load with f1
  step_pure
  step_load with f2
  step_pure
  step_load with f3
  step_pure
  step_load with f4
  -- f0_2 = f0 << 1; … f4_19 = 19ULL * f4;
  step_pure with f0_2
  step_pure with f1_2
  step_pure with f1_38
  step_pure with f2_38
  step_pure with f3_38
  step_pure with f3_19
  step_pure with f4_19
  -- r0 = … ; … r4 = …;
  iterate 9 step_pure
  step_pure with r0
  iterate 7 step_pure
  step_pure with r1
  iterate 6 step_pure
  step_pure with r2
  iterate 6 step_pure
  step_pure with r3
  iterate 4 step_pure
  step_pure with r4
  -- r0 <<= 1; … r4 <<= 1;
  iterate 5 step_pure
  -- r00 = ((uint64_t) r0) & mask; carry = r0 >> 51; r1 += carry; …
  step_pure
  step_pure [shl_and_mask] with r00
  step_pure
  step_pure with r1'
  step_pure
  step_pure with r01
  step_pure
  step_pure with r2'
  step_pure
  step_pure with r02
  step_pure
  step_pure with r3'
  step_pure
  step_pure with r03
  step_pure
  step_pure with r4'
  step_pure
  step_pure with r04
  -- r00 += 19ULL * (uint64_t) carry; carry = r00 >> 51; r00 &= mask; r01 += (uint64_t) carry; …
  iterate 3 step_pure
  step_pure with r00'
  iterate 2 step_pure
  step_pure [hr01] with r01'
  iterate 2 step_pure
  step_pure [hr02] with r02'
  -- h[0] = r00; … h[4] = r04;
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  subst hS
  subst_vars
  simp only [fe25519_sq2.spec, BitVec.setWidth_shiftLeft_of_le (show 64 ≤ 128 by decide)]
  rfl

end Proof

end MLIR.Sodium

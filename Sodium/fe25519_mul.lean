module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Agave.Serial.FieldElement51
public import Sodium.Mlir.fe25519_mul

namespace MLIR.Sodium

open Agave.Serial (mulWide)

/-! ## Specification -/

@[expose] public section

/-- `f * g`, named as in the C: the 128-bit column sums `r0 … r4` (limbs past the top wrap round
times 19, `f1_19 … f4_19`), each carried at bit 51 into the next, the top carry times 19 into
`r00`, then two more carries; sums in the code's operand order. -/
def fe25519_mul.spec (f g : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#64
  let f1_19 := f 1 * 19#64
  let f2_19 := f 2 * 19#64
  let f3_19 := f 3 * 19#64
  let f4_19 := f 4 * 19#64
  let r0 :=
    mulWide (g 1) f4_19 + mulWide (g 0) (f 0) + mulWide (g 2) f3_19 + mulWide (g 3) f2_19 +
      mulWide (g 4) f1_19
  let r1 :=
    mulWide (g 1) (f 0) + mulWide (g 0) (f 1) + mulWide (g 2) f4_19 + mulWide (g 3) f3_19 +
      mulWide (g 4) f2_19
  let r2 :=
    mulWide (g 1) (f 1) + mulWide (g 0) (f 2) + mulWide (g 2) (f 0) + mulWide (g 3) f4_19 +
      mulWide (g 4) f3_19
  let r3 :=
    mulWide (g 1) (f 2) + mulWide (g 0) (f 3) + mulWide (g 2) (f 1) + mulWide (g 3) (f 0) +
      mulWide (g 4) f4_19
  let r4 :=
    mulWide (g 1) (f 3) + mulWide (g 0) (f 4) + mulWide (g 2) (f 2) + mulWide (g 3) (f 1) +
      mulWide (g 4) (f 0)
  let r00 := r0.setWidth 64 &&& mask
  let r1 := r1 + r0 >>> 51
  let r01 := r1.setWidth 64 &&& mask
  let r2 := r2 + r1 >>> 51
  let r02 := r2.setWidth 64 &&& mask
  let r3 := r3 + r2 >>> 51
  let r03 := r3.setWidth 64 &&& mask
  let r4 := r4 + r3 >>> 51
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

/-- `fe25519_mul` stores `spec f g` at `h`. The loads all come before the stores, so `h` may
alias `f` or `g`; the `nuw`/`nsw` flags never fire. -/
public theorem fe25519_mul.call_eq (h f g : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hg : s.mem.LimbsFit g) :
    fe25519_mul.call (fe25519_mul.args (.value h) (.value f) (.value g)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h (fe25519_mul.spec (s.mem.readLimbs f) (s.mem.readLimbs g)) }) := by
  func_init
  block_init
  iterate 4 step_pure
  -- f0 = f[0]; … g4 = g[4];
  step_load with f0
  step_pure
  step_load with f1
  step_pure
  step_load with f2
  step_pure
  step_load with f3
  step_pure
  step_load with f4
  step_load with g0
  step_pure
  step_load with g1
  step_pure
  step_load with g2
  step_pure
  step_load with g3
  step_pure
  step_load with g4
  -- f1_19 = 19ULL * f1; … f4_19 = 19ULL * f4;
  step_pure with f1_19
  step_pure with f2_19
  step_pure with f3_19
  step_pure with f4_19
  -- the products, then r0 = …
  iterate 15 step_pure
  iterate 3 step_pure
  step_pure with r0
  -- the other columns' products
  iterate 25 step_pure
  -- r00 = ((uint64_t) r0) & mask; carry = r0 >> 51; r1 += carry; …
  step_pure
  step_pure with r00
  iterate 4 step_pure
  step_pure with r1
  step_pure
  step_pure with r01
  iterate 5 step_pure
  step_pure with r2
  step_pure
  step_pure with r02
  iterate 5 step_pure
  step_pure with r3
  step_pure
  step_pure with r03
  iterate 5 step_pure
  step_pure with r4
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
  rfl

end Proof

end MLIR.Sodium

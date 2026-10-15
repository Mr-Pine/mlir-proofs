module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Fe64
public import Firedancer.Crc.Ref.Fe64Carry
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c_2
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c_40
import Firedancer.Common.Tactics

/-!
# `crc_fe64_mul_c` refinement (MLIR lift ↔ spec)

Each copy of `crc_fe64_mul_c( r, x, y )` stores `Fe64.mul` of the 256-bit values at `x`
and `y` at `r` (`x·y` mod `p`, below `2^255 + 2^11`: `Fe64.mul_val`, `Fe64.mul_lt`).
-/

namespace MLIR.Firedancer.Crc.Ref

open Fe64

set_option hygiene false in
/-- Part 1 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_1" c:term : tactic => `(tactic| (
  func_init
  have x0_rd : S.mem.readAt x 64 = (S₀.mem.readAt x 256).extractLsb' 0 64 := by
    subst hS; exact Fe64.readAt_limb0
  have x1_rd : S.mem.readAt (x.add 8#64) 64 = (S₀.mem.readAt x 256).extractLsb' 64 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  have x2_rd : S.mem.readAt (x.add 16#64) 64 = (S₀.mem.readAt x 256).extractLsb' 128 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  have x3_rd : S.mem.readAt (x.add 24#64) 64 = (S₀.mem.readAt x 256).extractLsb' 192 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  have y0_rd : S.mem.readAt y 64 = (S₀.mem.readAt y 256).extractLsb' 0 64 := by
    subst hS; exact Fe64.readAt_limb0
  have y1_rd : S.mem.readAt (y.add 8#64) 64 = (S₀.mem.readAt y 256).extractLsb' 64 64 := by
    subst hS; exact Fe64.readAt_limb hy hyo (by decide)
  have y2_rd : S.mem.readAt (y.add 16#64) 64 = (S₀.mem.readAt y 256).extractLsb' 128 64 := by
    subst hS; exact Fe64.readAt_limb hy hyo (by decide)
  have y3_rd : S.mem.readAt (y.add 24#64) 64 = (S₀.mem.readAt y 256).extractLsb' 192 64 := by
    subst hS; exact Fe64.readAt_limb hy hyo (by decide)
  block_init
  iterate 6 step_pure
  iterate 56 step_alloca
  have hB0 := hS.symm
  clear hS
  step_load with x0 consuming x0_rd
  step_pure
  step_load with y0 consuming y0_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t1_lo
  rw [BitVec.mul_comm] at ht1_lo
  step_pure
  step_pure [trunc_hi] with t1_hi
  rw [BitVec.mul_comm] at ht1_hi
  step_pure
  step_load with x1 consuming x1_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t6_lo
  step_pure
  step_pure [trunc_hi] with t6_hi
  step_pure
  step_load with x2 consuming x2_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t26_lo
  step_pure
  step_pure [trunc_hi] with t26_hi
  step_pure
  step_load with x3 consuming x3_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t69_lo
  step_pure
  step_pure [trunc_hi] with t69_hi
  have b_t69_hi : t69_hi.toNat ≤ 18446744073709551614 := hi_le ht69_hi
  step_pure
  step_call using $c with t29_hi
  step_pure
  step_call using $c with t72_hi
  have b_t72_hi : t72_hi.toNat ≤ 1 := carry_le ht72_hi
  step_pure
  step_call using $c with t9_hi
  step_pure
  step_load with t29_lo consuming hread_v6
  clear hfits_v6 hroom_v6 hv6_bounds hwritable_v6 hv6_off hr_ne_v6 hx_ne_v6 hy_ne_v6
  step_call using $c
  step_pure with t32_hi
  rw [BitVec.or_comm] at ht32_hi
  step_pure
  step_load with t72_lo consuming hread_v7
  clear hfits_v7 hroom_v7 hv7_bounds hwritable_v7 hv7_off hr_ne_v7 hx_ne_v7 hy_ne_v7
  step_call using $c
  step_pure with t75_hi
  rw [BitVec.or_comm] at ht75_hi
  have b_t75_hi : t75_hi.toNat ≤ 1 := or_carry_le ht75_hi b_t72_hi
  step_pure [uaddOverflow_false b_t75_hi b_t69_hi] with t135
  rw [BitVec.add_comm] at ht135
  step_pure
  step_load with y1 consuming y1_rd
  step_pure
  step_pure [umulOverflow_setWidth]))

set_option hygiene false in
/-- Part 2 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_2" c:term : tactic => `(tactic| (
  step_pure with t14_lo
  rw [BitVec.mul_comm] at ht14_lo
  step_pure
  step_pure [trunc_hi] with t14_hi
  rw [BitVec.mul_comm] at ht14_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t43_lo
  rw [BitVec.mul_comm] at ht43_lo
  step_pure
  step_pure [trunc_hi] with t43_hi
  rw [BitVec.mul_comm] at ht43_hi
  step_pure
  step_load with t75_lo consuming hread_v10
  clear hfits_v10 hroom_v10 hv10_bounds hwritable_v10 hv10_off hr_ne_v10 hx_ne_v10 hy_ne_v10
  step_call using $c with t81_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t88_lo
  rw [BitVec.mul_comm] at ht88_lo
  step_pure
  step_pure [trunc_hi] with t88_hi
  rw [BitVec.mul_comm] at ht88_hi
  step_pure
  step_call using $c with t138_hi
  have b_t138_hi : t138_hi.toNat ≤ 1 := carry_le ht138_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t145_lo
  rw [BitVec.mul_comm] at ht145_lo
  step_pure
  step_pure [trunc_hi] with t145_hi
  rw [BitVec.mul_comm] at ht145_hi
  have b_t145_hi : t145_hi.toNat ≤ 18446744073709551614 := hi_le ht145_hi
  step_pure
  step_load with t32_lo consuming hread_v9
  clear hfits_v9 hroom_v9 hv9_bounds hwritable_v9 hv9_off hr_ne_v9 hx_ne_v9 hy_ne_v9
  step_call using $c with t38_hi
  step_pure
  step_load with t81_lo consuming hread_v11
  clear hfits_v11 hroom_v11 hv11_bounds hwritable_v11 hv11_off hr_ne_v11 hx_ne_v11 hy_ne_v11
  step_call using $c
  step_pure with t84_hi
  rw [BitVec.or_comm] at ht84_hi
  step_pure
  step_load with t138_lo consuming hread_v12
  clear hfits_v12 hroom_v12 hv12_bounds hwritable_v12 hv12_off hr_ne_v12 hx_ne_v12 hy_ne_v12
  step_call using $c
  step_pure with t141_hi
  rw [BitVec.or_comm] at ht141_hi
  have b_t141_hi : t141_hi.toNat ≤ 1 := or_carry_le ht141_hi b_t138_hi
  step_pure [uaddOverflow_false b_t141_hi b_t145_hi] with t225
  step_pure
  step_load with t38_lo consuming hread_v13
  clear hfits_v13 hroom_v13 hv13_bounds hwritable_v13 hv13_off hr_ne_v13 hx_ne_v13 hy_ne_v13
  step_call using $c with t46_hi
  step_pure
  step_load with t84_lo consuming hread_v14
  clear hfits_v14 hroom_v14 hv14_bounds hwritable_v14 hv14_off hr_ne_v14 hx_ne_v14 hy_ne_v14
  have hB1 := hS.symm
  clear hS
  step_call using $c with t91_hi
  step_pure
  step_load with t141_lo consuming hread_v15
  clear hfits_v15 hroom_v15 hv15_bounds hwritable_v15 hv15_off hr_ne_v15 hx_ne_v15 hy_ne_v15
  step_call using $c with t148_hi
  step_pure
  step_load with t9_lo consuming hread_v8
  clear hfits_v8 hroom_v8 hv8_bounds hwritable_v8 hv8_off hr_ne_v8 hx_ne_v8 hy_ne_v8
  step_call using $c with t17_hi
  step_pure
  step_load with t46_lo consuming hread_v16
  clear hfits_v16 hroom_v16 hv16_bounds hwritable_v16 hv16_off hr_ne_v16 hx_ne_v16 hy_ne_v16
  step_call using $c
  step_pure with t49_hi
  rw [BitVec.or_comm] at ht49_hi
  step_pure
  step_load with t91_lo consuming hread_v17
  clear hfits_v17 hroom_v17 hv17_bounds hwritable_v17 hv17_off hr_ne_v17 hx_ne_v17 hy_ne_v17
  step_call using $c
  step_pure with t94_hi
  rw [BitVec.or_comm] at ht94_hi
  step_pure))

set_option hygiene false in
/-- Part 3 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_3" c:term : tactic => `(tactic| (
  step_load with t148_lo consuming hread_v18
  clear hfits_v18 hroom_v18 hv18_bounds hwritable_v18 hv18_off hr_ne_v18 hx_ne_v18 hy_ne_v18
  step_call using $c
  step_pure with t151_hi
  rw [BitVec.or_comm] at ht151_hi
  step_pure with t226
  rw [BitVec.add_comm] at ht226
  step_pure
  step_load with y2 consuming y2_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t53_lo
  rw [BitVec.mul_comm] at ht53_lo
  step_pure
  step_pure [trunc_hi] with t53_hi
  rw [BitVec.mul_comm] at ht53_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t105_lo
  rw [BitVec.mul_comm] at ht105_lo
  step_pure
  step_pure [trunc_hi] with t105_hi
  rw [BitVec.mul_comm] at ht105_hi
  step_pure
  step_load with t151_lo consuming hread_v22
  clear hfits_v22 hroom_v22 hv22_bounds hwritable_v22 hv22_off hr_ne_v22 hx_ne_v22 hy_ne_v22
  step_call using $c with t157_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t164_lo
  rw [BitVec.mul_comm] at ht164_lo
  step_pure
  step_pure [trunc_hi] with t164_hi
  rw [BitVec.mul_comm] at ht164_hi
  step_pure
  step_call using $c with t229_hi
  have b_t229_hi : t229_hi.toNat ≤ 1 := carry_le ht229_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t236_lo
  rw [BitVec.mul_comm] at ht236_lo
  step_pure
  step_pure [trunc_hi] with t236_hi
  rw [BitVec.mul_comm] at ht236_hi
  have b_t236_hi : t236_hi.toNat ≤ 18446744073709551614 := hi_le ht236_hi
  step_pure
  step_load with t94_lo consuming hread_v21
  clear hfits_v21 hroom_v21 hv21_bounds hwritable_v21 hv21_off hr_ne_v21 hx_ne_v21 hy_ne_v21
  step_call using $c with t100_hi
  step_pure
  step_load with t157_lo consuming hread_v23
  clear hfits_v23 hroom_v23 hv23_bounds hwritable_v23 hv23_off hr_ne_v23 hx_ne_v23 hy_ne_v23
  step_call using $c
  step_pure with t160_hi
  rw [BitVec.or_comm] at ht160_hi
  step_pure
  step_load with t229_lo consuming hread_v24
  clear hfits_v24 hroom_v24 hv24_bounds hwritable_v24 hv24_off hr_ne_v24 hx_ne_v24 hy_ne_v24
  step_call using $c
  step_pure with t232_hi
  rw [BitVec.or_comm] at ht232_hi
  have b_t232_hi : t232_hi.toNat ≤ 1 := or_carry_le ht232_hi b_t229_hi
  step_pure [uaddOverflow_false b_t232_hi b_t236_hi] with t299
  step_pure
  step_load with t100_lo consuming hread_v25
  clear hfits_v25 hroom_v25 hv25_bounds hwritable_v25 hv25_off hr_ne_v25 hx_ne_v25 hy_ne_v25
  step_call using $c with t108_hi
  step_pure
  step_load with t160_lo consuming hread_v26
  clear hfits_v26 hroom_v26 hv26_bounds hwritable_v26 hv26_off hr_ne_v26 hx_ne_v26 hy_ne_v26
  have hB2 := hS.symm
  clear hS
  step_call using $c with t167_hi
  step_pure
  step_load with t232_lo consuming hread_v27
  clear hfits_v27 hroom_v27 hv27_bounds hwritable_v27 hv27_off hr_ne_v27 hx_ne_v27 hy_ne_v27
  step_call using $c with t239_hi
  step_pure
  step_load with t49_lo consuming hread_v20
  clear hfits_v20 hroom_v20 hv20_bounds hwritable_v20 hv20_off hr_ne_v20 hx_ne_v20 hy_ne_v20
  step_call using $c with t56_hi
  step_pure
  step_load with t108_lo consuming hread_v28))

set_option hygiene false in
/-- Part 4 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_4" c:term : tactic => `(tactic| (
  clear hfits_v28 hroom_v28 hv28_bounds hwritable_v28 hv28_off hr_ne_v28 hx_ne_v28 hy_ne_v28
  step_call using $c
  step_pure with t111_hi
  rw [BitVec.or_comm] at ht111_hi
  step_pure
  step_load with t167_lo consuming hread_v29
  clear hfits_v29 hroom_v29 hv29_bounds hwritable_v29 hv29_off hr_ne_v29 hx_ne_v29 hy_ne_v29
  step_call using $c
  step_pure with t170_hi
  rw [BitVec.or_comm] at ht170_hi
  step_pure
  step_load with t239_lo consuming hread_v30
  clear hfits_v30 hroom_v30 hv30_bounds hwritable_v30 hv30_off hr_ne_v30 hx_ne_v30 hy_ne_v30
  step_call using $c
  step_pure with t242_hi
  rw [BitVec.or_comm] at ht242_hi
  step_pure with t300
  rw [BitVec.add_comm] at ht300
  step_pure
  step_load with y3 consuming y3_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t115_lo
  rw [BitVec.mul_comm] at ht115_lo
  step_pure
  step_pure [trunc_hi] with t115_hi
  rw [BitVec.mul_comm] at ht115_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t181_lo
  rw [BitVec.mul_comm] at ht181_lo
  step_pure
  step_pure [trunc_hi] with t181_hi
  rw [BitVec.mul_comm] at ht181_hi
  step_pure
  step_load with t242_lo consuming hread_v34
  clear hfits_v34 hroom_v34 hv34_bounds hwritable_v34 hv34_off hr_ne_v34 hx_ne_v34 hy_ne_v34
  step_call using $c with t248_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t255_lo
  rw [BitVec.mul_comm] at ht255_lo
  step_pure
  step_pure [trunc_hi] with t255_hi
  rw [BitVec.mul_comm] at ht255_hi
  step_pure
  step_call using $c with t303_hi
  have b_t303_hi : t303_hi.toNat ≤ 1 := carry_le ht303_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t310_lo
  rw [BitVec.mul_comm] at ht310_lo
  step_pure
  step_pure [trunc_hi] with t310_hi
  rw [BitVec.mul_comm] at ht310_hi
  have b_t310_hi : t310_hi.toNat ≤ 18446744073709551614 := hi_le ht310_hi
  step_pure
  step_load with t170_lo consuming hread_v33
  clear hfits_v33 hroom_v33 hv33_bounds hwritable_v33 hv33_off hr_ne_v33 hx_ne_v33 hy_ne_v33
  step_call using $c with t176_hi
  step_pure
  step_load with t248_lo consuming hread_v35
  clear hfits_v35 hroom_v35 hv35_bounds hwritable_v35 hv35_off hr_ne_v35 hx_ne_v35 hy_ne_v35
  step_call using $c
  step_pure with t251_hi
  rw [BitVec.or_comm] at ht251_hi
  step_pure
  step_load with t303_lo consuming hread_v36
  clear hfits_v36 hroom_v36 hv36_bounds hwritable_v36 hv36_off hr_ne_v36 hx_ne_v36 hy_ne_v36
  step_call using $c
  step_pure with t306_hi
  rw [BitVec.or_comm] at ht306_hi
  have b_t306_hi : t306_hi.toNat ≤ 1 := or_carry_le ht306_hi b_t303_hi
  step_pure [uaddOverflow_false b_t306_hi b_t310_hi] with t350
  step_pure
  step_load with t176_lo consuming hread_v37
  clear hfits_v37 hroom_v37 hv37_bounds hwritable_v37 hv37_off hr_ne_v37 hx_ne_v37 hy_ne_v37
  step_call using $c with t184_hi
  step_pure
  step_load with t251_lo consuming hread_v38
  clear hfits_v38 hroom_v38 hv38_bounds hwritable_v38 hv38_off hr_ne_v38 hx_ne_v38 hy_ne_v38
  have hB3 := hS.symm
  clear hS))

set_option hygiene false in
/-- Part 5 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_5" c:term : tactic => `(tactic| (
  step_call using $c with t258_hi
  step_pure
  step_load with t306_lo consuming hread_v39
  clear hfits_v39 hroom_v39 hv39_bounds hwritable_v39 hv39_off hr_ne_v39 hx_ne_v39 hy_ne_v39
  step_call using $c with t313_hi
  step_pure
  step_load with t111_lo consuming hread_v32
  clear hfits_v32 hroom_v32 hv32_bounds hwritable_v32 hv32_off hr_ne_v32 hx_ne_v32 hy_ne_v32
  step_call using $c with t118_hi
  step_pure
  step_load with t184_lo consuming hread_v40
  clear hfits_v40 hroom_v40 hv40_bounds hwritable_v40 hv40_off hr_ne_v40 hx_ne_v40 hy_ne_v40
  step_call using $c
  step_pure with t187_hi
  rw [BitVec.or_comm] at ht187_hi
  step_pure
  step_load with t258_lo consuming hread_v41
  clear hfits_v41 hroom_v41 hv41_bounds hwritable_v41 hv41_off hr_ne_v41 hx_ne_v41 hy_ne_v41
  step_call using $c
  step_pure with t261_hi
  rw [BitVec.or_comm] at ht261_hi
  step_pure
  step_load with t313_lo consuming hread_v42
  clear hfits_v42 hroom_v42 hv42_bounds hwritable_v42 hv42_off hr_ne_v42 hx_ne_v42 hy_ne_v42
  step_call using $c
  step_pure with t316_hi
  rw [BitVec.or_comm] at ht316_hi
  step_pure with t351
  rw [BitVec.add_comm] at ht351
  step_load with t187_lo consuming hread_v44
  clear hfits_v44 hroom_v44 hv44_bounds hwritable_v44 hv44_off hr_ne_v44 hx_ne_v44 hy_ne_v44
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t191_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t191_hi
  step_load with t261_lo consuming hread_v45
  clear hfits_v45 hroom_v45 hv45_bounds hwritable_v45 hv45_off hr_ne_v45 hx_ne_v45 hy_ne_v45
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t265_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t265_hi
  step_pure
  step_load with t56_lo consuming hread_v31
  clear hfits_v31 hroom_v31 hv31_bounds hwritable_v31 hv31_off hr_ne_v31 hx_ne_v31 hy_ne_v31
  step_call using $c with t282_hi
  step_load with t316_lo consuming hread_v46
  clear hfits_v46 hroom_v46 hv46_bounds hwritable_v46 hv46_off hr_ne_v46 hx_ne_v46 hy_ne_v46
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t320_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t320_hi
  step_pure
  step_load with t118_lo consuming hread_v43
  clear hfits_v43 hroom_v43 hv43_bounds hwritable_v43 hv43_off hr_ne_v43 hx_ne_v43 hy_ne_v43
  step_call using $c with t337_hi
  have b_t337_hi : t337_hi.toNat ≤ 1 := carry_le ht337_hi
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t352_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t352_hi
  have b_t352_hi : t352_hi.toNat ≤ 37 := hi38_le ht352_hi
  step_pure
  step_load with t17_lo consuming hread_v19
  clear hfits_v19 hroom_v19 hv19_bounds hwritable_v19 hv19_off hr_ne_v19 hx_ne_v19 hy_ne_v19
  step_call using $c with t206_hi
  step_pure
  step_load with t282_lo consuming hread_v47
  clear hfits_v47 hroom_v47 hv47_bounds hwritable_v47 hv47_off hr_ne_v47 hx_ne_v47 hy_ne_v47
  step_call using $c
  step_pure with t285_hi
  rw [BitVec.or_comm] at ht285_hi
  step_pure
  step_load with t337_lo consuming hread_v48
  clear hfits_v48 hroom_v48 hv48_bounds hwritable_v48 hv48_off hr_ne_v48 hx_ne_v48 hy_ne_v48
  step_call using $c
  step_pure with t340_hi))

set_option hygiene false in
/-- Part 6 of 9 of `crc_fe64_mul_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "mul_walk_6" c:term : tactic => `(tactic| (
  rw [BitVec.or_comm] at ht340_hi
  have b_t340_hi : t340_hi.toNat ≤ 1 := or_carry_le ht340_hi b_t337_hi
  step_pure [uaddOverflow_false b_t340_hi b_t352_hi,
      saddOverflow_false b_t340_hi b_t352_hi] with t367
  have b_t367 : t367.toNat ≤ 38 := add_le ht367 b_t340_hi b_t352_hi
  step_pure
  step_load with t206_lo consuming hread_v49
  clear hfits_v49 hroom_v49 hv49_bounds hwritable_v49 hv49_off hr_ne_v49 hx_ne_v49 hy_ne_v49
  step_call using $c with t269_hi
  step_pure
  step_load with t285_lo consuming hread_v50
  clear hfits_v50 hroom_v50 hv50_bounds hwritable_v50 hv50_off hr_ne_v50 hx_ne_v50 hy_ne_v50
  have hB4 := hS.symm
  clear hS
  step_call using $c with t324_hi
  step_pure
  step_load with t340_lo consuming hread_v51
  clear hfits_v51 hroom_v51 hv51_bounds hwritable_v51 hv51_off hr_ne_v51 hx_ne_v51 hy_ne_v51
  step_call using $c with t356_hi
  have b_t356_hi : t356_hi.toNat ≤ 1 := carry_le ht356_hi
  step_pure
  step_call using $c with t195_hi
  step_pure
  step_load with t269_lo consuming hread_v52
  clear hfits_v52 hroom_v52 hv52_bounds hwritable_v52 hv52_off hr_ne_v52 hx_ne_v52 hy_ne_v52
  step_call using $c
  step_pure with t272_hi
  rw [BitVec.or_comm] at ht272_hi
  step_pure
  step_load with t324_lo consuming hread_v53
  clear hfits_v53 hroom_v53 hv53_bounds hwritable_v53 hv53_off hr_ne_v53 hx_ne_v53 hy_ne_v53
  step_call using $c
  step_pure with t327_hi
  rw [BitVec.or_comm] at ht327_hi
  step_pure
  step_load with t356_lo consuming hread_v54
  clear hfits_v54 hroom_v54 hv54_bounds hwritable_v54 hv54_off hr_ne_v54 hx_ne_v54 hy_ne_v54
  step_call using $c
  step_pure with t359_hi
  rw [BitVec.or_comm] at ht359_hi
  have b_t359_hi : t359_hi.toNat ≤ 1 := or_carry_le ht359_hi b_t356_hi
  step_pure [uaddOverflow_false b_t367 b_t359_hi, saddOverflow_false b_t367 b_t359_hi] with t368
  rw [BitVec.add_comm] at ht368
  have b_t368 : t368.toNat ≤ 39 := add_le ht368 b_t359_hi b_t367
  step_load with t359_lo consuming hread_v58
  clear hfits_v58 hroom_v58 hv58_bounds hwritable_v58 hv58_off hr_ne_v58 hx_ne_v58 hy_ne_v58
  step_pure with t373
  rw [fshl_one] at ht373
  have b_t373 : t373.toNat ≤ 79 := dbl_top_le ht373 b_t368
  step_pure with t398
  have b_t398 : t398.toNat ≤ 9223372036854775807 := mask_le ht398
  step_pure [umulOverflow_mul19 b_t373, smulOverflow_mul19 b_t373] with t374
  step_pure
  step_load with t195_lo consuming hread_v55
  clear hfits_v55 hroom_v55 hv55_bounds hwritable_v55 hv55_off hr_ne_v55 hx_ne_v55 hy_ne_v55
  step_call using $c with t375_hi
  step_pure
  step_load with t272_lo consuming hread_v56
  clear hfits_v56 hroom_v56 hv56_bounds hwritable_v56 hv56_off hr_ne_v56 hx_ne_v56 hy_ne_v56
  step_call using $c with t384_hi
  step_pure
  step_load with t327_lo consuming hread_v57
  clear hfits_v57 hroom_v57 hv57_bounds hwritable_v57 hv57_off hr_ne_v57 hx_ne_v57 hy_ne_v57
  step_call using $c with t393_hi
  have b_t393_hi : t393_hi.toNat ≤ 1 := carry_le ht393_hi
  step_pure [uaddOverflow_false b_t393_hi b_t398] with t401
  rw [BitVec.add_comm] at ht401
  step_load with t375_lo consuming hread_v59
  clear hfits_v59 hroom_v59 hv59_bounds hwritable_v59 hv59_off hr_ne_v59 hx_ne_v59 hy_ne_v59
  step_store
  step_load with t384_lo consuming hread_v60
  clear hfits_v60 hroom_v60 hv60_bounds hwritable_v60 hv60_off hr_ne_v60 hx_ne_v60 hy_ne_v60
  step_pure
  step_store
  step_load with t393_lo consuming hread_v61
  clear hfits_v61 hroom_v61 hv61_bounds hwritable_v61 hv61_off hr_ne_v61 hx_ne_v61 hy_ne_v61
  step_pure
  step_store
  step_pure
  step_store
  iterate 56 step_pure))

set_option hygiene false in
/-- Part 7 of 9 of `crc_fe64_mul_c`'s walk. -/
local macro "mul_walk_7" : tactic => `(tactic| (
  finish_block
  -- the frame, base by base
  subst hS
  erase_frame
  rw [← hB4]
  erase_frame
  rw [← hB3]
  erase_frame
  rw [← hB2]
  erase_frame
  rw [← hB1]
  erase_frame
  rw [← hB0]
  erase_frame
  simp only [GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
  -- the four limb stores, one 256-bit store
  rw [Fe64.storeAt_limbs hro]
  suffices e : t401 ++ (t393_lo ++ (t384_lo ++ t375_lo)) =
      Fe64.mul (S₀.mem.readAt x 256) (S₀.mem.readAt y 256) by rw [e]
  -- the named values, one by one, as the spec's
  clear_reads
  unfold Fe64.mul
  extract_lets x0' x1' x2' x3' y0' y1' y2' y3' p1' t1_lo' t1_hi' p2' t6_lo' t6_hi' p4' t26_lo'
      t26_hi' p7' t69_lo' t69_hi' t29_lo' t29_hi' t72_lo' t72_hi' t9_lo' t9_hi' t32_lo' c32'
      t32_hi' t75_lo' c75' t75_hi' t135' p3' t14_lo' t14_hi' p5' t43_lo' t43_hi' t81_lo' t81_hi'
      p8' t88_lo' t88_hi' t138_lo' t138_hi' p11' t145_lo' t145_hi' t38_lo' t38_hi' t84_lo' c84'
      t84_hi' t141_lo' c141' t141_hi' t225' t46_lo' t46_hi' t91_lo' t91_hi' t148_lo' t148_hi'
      t17_lo' t17_hi' t49_lo' c49' t49_hi' t94_lo' c94' t94_hi' t151_lo' c151' t151_hi' t226' p6'
      t53_lo' t53_hi' p9' t105_lo' t105_hi' t157_lo' t157_hi' p12' t164_lo' t164_hi' t229_lo'
      t229_hi' p15' t236_lo' t236_hi' t100_lo' t100_hi' t160_lo' c160' t160_hi' t232_lo' c232'
      t232_hi' t299' t108_lo' t108_hi' t167_lo' t167_hi' t239_lo' t239_hi' t56_lo' t56_hi' t111_lo'
      c111' t111_hi' t170_lo' c170' t170_hi' t242_lo' c242' t242_hi' t300' p10' t115_lo' t115_hi'
      p13' t181_lo' t181_hi' t248_lo' t248_hi' p16' t255_lo' t255_hi' t303_lo' t303_hi' p18'
      t310_lo' t310_hi' t176_lo' t176_hi' t251_lo' c251' t251_hi' t306_lo' c306' t306_hi' t350'
      t184_lo' t184_hi' t258_lo' t258_hi' t313_lo' t313_hi' t118_lo' t118_hi' t187_lo' c187'
      t187_hi' t261_lo' c261' t261_hi' t316_lo' c316' t316_hi' t351' p14' t191_lo' t191_hi' p17'
      t265_lo' t265_hi' t282_lo' t282_hi' p19' t320_lo' t320_hi' t337_lo' t337_hi' p20' t352_lo'
      t352_hi' t206_lo' t206_hi' t285_lo' c285' t285_hi' t340_lo' c340' t340_hi' t367' t269_lo'
      t269_hi' t324_lo' t324_hi' t356_lo' t356_hi' t195_lo' t195_hi' t272_lo' c272' t272_hi'
      t327_lo' c327' t327_hi' t359_lo' c359' t359_hi' t368' t369' t372' t373' t398' t374' t375_lo'
      t375_hi' t384_lo' t384_hi' t393_lo' t393_hi' t401'
  have e_x0 : x0 = x0' := hx0
  have e_x1 : x1 = x1' := hx1
  have e_x2 : x2 = x2' := hx2
  have e_x3 : x3 = x3' := hx3
  have e_y0 : y0 = y0' := hy0
  have e_y1 : y1 = y1' := hy1
  have e_y2 : y2 = y2' := hy2
  have e_y3 : y3 = y3' := hy3
  have e_t1_lo : t1_lo = t1_lo' := by rw [ht1_lo, e_x0, e_y0]
  have e_t1_hi : t1_hi = t1_hi' := by rw [ht1_hi, e_x0, e_y0]
  have e_t6_lo : t6_lo = t6_lo' := by rw [ht6_lo, e_x1, e_y0]
  have e_t6_hi : t6_hi = t6_hi' := by rw [ht6_hi, e_x1, e_y0]
  have e_t26_lo : t26_lo = t26_lo' := by rw [ht26_lo, e_x2, e_y0]
  have e_t26_hi : t26_hi = t26_hi' := by rw [ht26_hi, e_x2, e_y0]
  have e_t69_lo : t69_lo = t69_lo' := by rw [ht69_lo, e_x3, e_y0]
  have e_t69_hi : t69_hi = t69_hi' := by rw [ht69_hi, e_x3, e_y0]
  have e_t29_lo : t29_lo = t29_lo' := by rw [ht29_lo, e_t6_hi, e_t26_lo]
  have e_t29_hi : t29_hi = t29_hi' := by rw [ht29_hi, e_t6_hi, e_t26_lo]
  have e_t72_lo : t72_lo = t72_lo' := by rw [ht72_lo, e_t26_hi, e_t69_lo]
  have e_t72_hi : t72_hi = t72_hi' := by rw [ht72_hi, e_t26_hi, e_t69_lo]
  have e_t9_lo : t9_lo = t9_lo' := by rw [ht9_lo, e_t1_hi, e_t6_lo]
  have e_t9_hi : t9_hi = t9_hi' := by rw [ht9_hi, e_t1_hi, e_t6_lo]
  have e_t32_lo : t32_lo = t32_lo' := by rw [ht32_lo, e_t9_hi, e_t29_lo]
  have e_t32_hi : t32_hi = t32_hi' := by rw [ht32_hi, e_t29_hi, e_t9_hi, e_t29_lo]
  have e_t75_lo : t75_lo = t75_lo' := by rw [ht75_lo, e_t32_hi, e_t72_lo]
  have e_t75_hi : t75_hi = t75_hi' := by rw [ht75_hi, e_t72_hi, e_t32_hi, e_t72_lo]
  have e_t135 : t135 = t135' := by rw [ht135, e_t69_hi, e_t75_hi]
  have e_t14_lo : t14_lo = t14_lo' := by rw [ht14_lo, e_x0, e_y1]
  have e_t14_hi : t14_hi = t14_hi' := by rw [ht14_hi, e_x0, e_y1]
  have e_t43_lo : t43_lo = t43_lo' := by rw [ht43_lo, e_x1, e_y1]
  have e_t43_hi : t43_hi = t43_hi' := by rw [ht43_hi, e_x1, e_y1]
  have e_t81_lo : t81_lo = t81_lo' := by rw [ht81_lo, e_t75_lo, e_t43_hi]
  have e_t81_hi : t81_hi = t81_hi' := by rw [ht81_hi, e_t75_lo, e_t43_hi]
  have e_t88_lo : t88_lo = t88_lo' := by rw [ht88_lo, e_x2, e_y1]
  have e_t88_hi : t88_hi = t88_hi' := by rw [ht88_hi, e_x2, e_y1]
  have e_t138_lo : t138_lo = t138_lo' := by rw [ht138_lo, e_t135, e_t88_hi]
  have e_t138_hi : t138_hi = t138_hi' := by rw [ht138_hi, e_t135, e_t88_hi]
  have e_t145_lo : t145_lo = t145_lo' := by rw [ht145_lo, e_x3, e_y1]
  have e_t145_hi : t145_hi = t145_hi' := by rw [ht145_hi, e_x3, e_y1]
  have e_t38_lo : t38_lo = t38_lo' := by rw [ht38_lo, e_t32_lo, e_t14_hi]
  have e_t38_hi : t38_hi = t38_hi' := by rw [ht38_hi, e_t32_lo, e_t14_hi]
  have e_t84_lo : t84_lo = t84_lo' := by rw [ht84_lo, e_t38_hi, e_t81_lo]
  have e_t84_hi : t84_hi = t84_hi' := by rw [ht84_hi, e_t81_hi, e_t38_hi, e_t81_lo]
  have e_t141_lo : t141_lo = t141_lo' := by rw [ht141_lo, e_t84_hi, e_t138_lo]
  have e_t141_hi : t141_hi = t141_hi' := by rw [ht141_hi, e_t138_hi, e_t84_hi, e_t138_lo]
  have e_t225 : t225 = t225' := by rw [ht225, e_t141_hi, e_t145_hi]
  have e_t46_lo : t46_lo = t46_lo' := by rw [ht46_lo, e_t38_lo, e_t43_lo]
  have e_t46_hi : t46_hi = t46_hi' := by rw [ht46_hi, e_t38_lo, e_t43_lo]
  have e_t91_lo : t91_lo = t91_lo' := by rw [ht91_lo, e_t84_lo, e_t88_lo]
  have e_t91_hi : t91_hi = t91_hi' := by rw [ht91_hi, e_t84_lo, e_t88_lo]
  have e_t148_lo : t148_lo = t148_lo' := by rw [ht148_lo, e_t141_lo, e_t145_lo]
  have e_t148_hi : t148_hi = t148_hi' := by rw [ht148_hi, e_t141_lo, e_t145_lo]
  have e_t17_lo : t17_lo = t17_lo' := by rw [ht17_lo, e_t9_lo, e_t14_lo]
  have e_t17_hi : t17_hi = t17_hi' := by rw [ht17_hi, e_t9_lo, e_t14_lo]
  have e_t49_lo : t49_lo = t49_lo' := by rw [ht49_lo, e_t17_hi, e_t46_lo]
  have e_t49_hi : t49_hi = t49_hi' := by rw [ht49_hi, e_t46_hi, e_t17_hi, e_t46_lo]
  have e_t94_lo : t94_lo = t94_lo' := by rw [ht94_lo, e_t49_hi, e_t91_lo]))

set_option hygiene false in
/-- Part 8 of 9 of `crc_fe64_mul_c`'s walk. -/
local macro "mul_walk_8" : tactic => `(tactic| (
  have e_t94_hi : t94_hi = t94_hi' := by rw [ht94_hi, e_t91_hi, e_t49_hi, e_t91_lo]
  have e_t151_lo : t151_lo = t151_lo' := by rw [ht151_lo, e_t94_hi, e_t148_lo]
  have e_t151_hi : t151_hi = t151_hi' := by rw [ht151_hi, e_t148_hi, e_t94_hi, e_t148_lo]
  have e_t226 : t226 = t226' := by rw [ht226, e_t151_hi, e_t225]
  have e_t53_lo : t53_lo = t53_lo' := by rw [ht53_lo, e_x0, e_y2]
  have e_t53_hi : t53_hi = t53_hi' := by rw [ht53_hi, e_x0, e_y2]
  have e_t105_lo : t105_lo = t105_lo' := by rw [ht105_lo, e_x1, e_y2]
  have e_t105_hi : t105_hi = t105_hi' := by rw [ht105_hi, e_x1, e_y2]
  have e_t157_lo : t157_lo = t157_lo' := by rw [ht157_lo, e_t151_lo, e_t105_hi]
  have e_t157_hi : t157_hi = t157_hi' := by rw [ht157_hi, e_t151_lo, e_t105_hi]
  have e_t164_lo : t164_lo = t164_lo' := by rw [ht164_lo, e_x2, e_y2]
  have e_t164_hi : t164_hi = t164_hi' := by rw [ht164_hi, e_x2, e_y2]
  have e_t229_lo : t229_lo = t229_lo' := by rw [ht229_lo, e_t226, e_t164_hi]
  have e_t229_hi : t229_hi = t229_hi' := by rw [ht229_hi, e_t226, e_t164_hi]
  have e_t236_lo : t236_lo = t236_lo' := by rw [ht236_lo, e_x3, e_y2]
  have e_t236_hi : t236_hi = t236_hi' := by rw [ht236_hi, e_x3, e_y2]
  have e_t100_lo : t100_lo = t100_lo' := by rw [ht100_lo, e_t94_lo, e_t53_hi]
  have e_t100_hi : t100_hi = t100_hi' := by rw [ht100_hi, e_t94_lo, e_t53_hi]
  have e_t160_lo : t160_lo = t160_lo' := by rw [ht160_lo, e_t100_hi, e_t157_lo]
  have e_t160_hi : t160_hi = t160_hi' := by rw [ht160_hi, e_t157_hi, e_t100_hi, e_t157_lo]
  have e_t232_lo : t232_lo = t232_lo' := by rw [ht232_lo, e_t160_hi, e_t229_lo]
  have e_t232_hi : t232_hi = t232_hi' := by rw [ht232_hi, e_t229_hi, e_t160_hi, e_t229_lo]
  have e_t299 : t299 = t299' := by rw [ht299, e_t232_hi, e_t236_hi]
  have e_t108_lo : t108_lo = t108_lo' := by rw [ht108_lo, e_t100_lo, e_t105_lo]
  have e_t108_hi : t108_hi = t108_hi' := by rw [ht108_hi, e_t100_lo, e_t105_lo]
  have e_t167_lo : t167_lo = t167_lo' := by rw [ht167_lo, e_t160_lo, e_t164_lo]
  have e_t167_hi : t167_hi = t167_hi' := by rw [ht167_hi, e_t160_lo, e_t164_lo]
  have e_t239_lo : t239_lo = t239_lo' := by rw [ht239_lo, e_t232_lo, e_t236_lo]
  have e_t239_hi : t239_hi = t239_hi' := by rw [ht239_hi, e_t232_lo, e_t236_lo]
  have e_t56_lo : t56_lo = t56_lo' := by rw [ht56_lo, e_t49_lo, e_t53_lo]
  have e_t56_hi : t56_hi = t56_hi' := by rw [ht56_hi, e_t49_lo, e_t53_lo]
  have e_t111_lo : t111_lo = t111_lo' := by rw [ht111_lo, e_t56_hi, e_t108_lo]
  have e_t111_hi : t111_hi = t111_hi' := by rw [ht111_hi, e_t108_hi, e_t56_hi, e_t108_lo]
  have e_t170_lo : t170_lo = t170_lo' := by rw [ht170_lo, e_t111_hi, e_t167_lo]
  have e_t170_hi : t170_hi = t170_hi' := by rw [ht170_hi, e_t167_hi, e_t111_hi, e_t167_lo]
  have e_t242_lo : t242_lo = t242_lo' := by rw [ht242_lo, e_t170_hi, e_t239_lo]
  have e_t242_hi : t242_hi = t242_hi' := by rw [ht242_hi, e_t239_hi, e_t170_hi, e_t239_lo]
  have e_t300 : t300 = t300' := by rw [ht300, e_t242_hi, e_t299]
  have e_t115_lo : t115_lo = t115_lo' := by rw [ht115_lo, e_x0, e_y3]
  have e_t115_hi : t115_hi = t115_hi' := by rw [ht115_hi, e_x0, e_y3]
  have e_t181_lo : t181_lo = t181_lo' := by rw [ht181_lo, e_x1, e_y3]
  have e_t181_hi : t181_hi = t181_hi' := by rw [ht181_hi, e_x1, e_y3]
  have e_t248_lo : t248_lo = t248_lo' := by rw [ht248_lo, e_t242_lo, e_t181_hi]
  have e_t248_hi : t248_hi = t248_hi' := by rw [ht248_hi, e_t242_lo, e_t181_hi]
  have e_t255_lo : t255_lo = t255_lo' := by rw [ht255_lo, e_x2, e_y3]
  have e_t255_hi : t255_hi = t255_hi' := by rw [ht255_hi, e_x2, e_y3]
  have e_t303_lo : t303_lo = t303_lo' := by rw [ht303_lo, e_t300, e_t255_hi]
  have e_t303_hi : t303_hi = t303_hi' := by rw [ht303_hi, e_t300, e_t255_hi]
  have e_t310_lo : t310_lo = t310_lo' := by rw [ht310_lo, e_x3, e_y3]
  have e_t310_hi : t310_hi = t310_hi' := by rw [ht310_hi, e_x3, e_y3]
  have e_t176_lo : t176_lo = t176_lo' := by rw [ht176_lo, e_t170_lo, e_t115_hi]
  have e_t176_hi : t176_hi = t176_hi' := by rw [ht176_hi, e_t170_lo, e_t115_hi]
  have e_t251_lo : t251_lo = t251_lo' := by rw [ht251_lo, e_t176_hi, e_t248_lo]
  have e_t251_hi : t251_hi = t251_hi' := by rw [ht251_hi, e_t248_hi, e_t176_hi, e_t248_lo]
  have e_t306_lo : t306_lo = t306_lo' := by rw [ht306_lo, e_t251_hi, e_t303_lo]
  have e_t306_hi : t306_hi = t306_hi' := by rw [ht306_hi, e_t303_hi, e_t251_hi, e_t303_lo]
  have e_t350 : t350 = t350' := by rw [ht350, e_t306_hi, e_t310_hi]
  have e_t184_lo : t184_lo = t184_lo' := by rw [ht184_lo, e_t176_lo, e_t181_lo]
  have e_t184_hi : t184_hi = t184_hi' := by rw [ht184_hi, e_t176_lo, e_t181_lo]
  have e_t258_lo : t258_lo = t258_lo' := by rw [ht258_lo, e_t251_lo, e_t255_lo]
  have e_t258_hi : t258_hi = t258_hi' := by rw [ht258_hi, e_t251_lo, e_t255_lo]
  have e_t313_lo : t313_lo = t313_lo' := by rw [ht313_lo, e_t306_lo, e_t310_lo]
  have e_t313_hi : t313_hi = t313_hi' := by rw [ht313_hi, e_t306_lo, e_t310_lo]
  have e_t118_lo : t118_lo = t118_lo' := by rw [ht118_lo, e_t111_lo, e_t115_lo]
  have e_t118_hi : t118_hi = t118_hi' := by rw [ht118_hi, e_t111_lo, e_t115_lo]
  have e_t187_lo : t187_lo = t187_lo' := by rw [ht187_lo, e_t118_hi, e_t184_lo]
  have e_t187_hi : t187_hi = t187_hi' := by rw [ht187_hi, e_t184_hi, e_t118_hi, e_t184_lo]
  have e_t261_lo : t261_lo = t261_lo' := by rw [ht261_lo, e_t187_hi, e_t258_lo]
  have e_t261_hi : t261_hi = t261_hi' := by rw [ht261_hi, e_t258_hi, e_t187_hi, e_t258_lo]
  have e_t316_lo : t316_lo = t316_lo' := by rw [ht316_lo, e_t261_hi, e_t313_lo]
  have e_t316_hi : t316_hi = t316_hi' := by rw [ht316_hi, e_t313_hi, e_t261_hi, e_t313_lo]
  have e_t351 : t351 = t351' := by rw [ht351, e_t316_hi, e_t350]
  have e_t191_lo : t191_lo = t191_lo' := by rw [ht191_lo, e_t187_lo]
  have e_t191_hi : t191_hi = t191_hi' := by rw [ht191_hi, e_t187_lo]
  have e_t265_lo : t265_lo = t265_lo' := by rw [ht265_lo, e_t261_lo]
  have e_t265_hi : t265_hi = t265_hi' := by rw [ht265_hi, e_t261_lo]
  have e_t282_lo : t282_lo = t282_lo' := by rw [ht282_lo, e_t56_lo, e_t265_hi]
  have e_t282_hi : t282_hi = t282_hi' := by rw [ht282_hi, e_t56_lo, e_t265_hi]
  have e_t320_lo : t320_lo = t320_lo' := by rw [ht320_lo, e_t316_lo]
  have e_t320_hi : t320_hi = t320_hi' := by rw [ht320_hi, e_t316_lo]))

set_option hygiene false in
/-- Part 9 of 9 of `crc_fe64_mul_c`'s walk. -/
local macro "mul_walk_9" : tactic => `(tactic| (
  have e_t337_lo : t337_lo = t337_lo' := by rw [ht337_lo, e_t118_lo, e_t320_hi]
  have e_t337_hi : t337_hi = t337_hi' := by rw [ht337_hi, e_t118_lo, e_t320_hi]
  have e_t352_lo : t352_lo = t352_lo' := by rw [ht352_lo, e_t351]
  have e_t352_hi : t352_hi = t352_hi' := by rw [ht352_hi, e_t351]
  have e_t206_lo : t206_lo = t206_lo' := by rw [ht206_lo, e_t17_lo, e_t191_hi]
  have e_t206_hi : t206_hi = t206_hi' := by rw [ht206_hi, e_t17_lo, e_t191_hi]
  have e_t285_lo : t285_lo = t285_lo' := by rw [ht285_lo, e_t206_hi, e_t282_lo]
  have e_t285_hi : t285_hi = t285_hi' := by rw [ht285_hi, e_t282_hi, e_t206_hi, e_t282_lo]
  have e_t340_lo : t340_lo = t340_lo' := by rw [ht340_lo, e_t285_hi, e_t337_lo]
  have e_t340_hi : t340_hi = t340_hi' := by rw [ht340_hi, e_t337_hi, e_t285_hi, e_t337_lo]
  have e_t367 : t367 = t367' := by rw [ht367, e_t340_hi, e_t352_hi]
  have e_t269_lo : t269_lo = t269_lo' := by rw [ht269_lo, e_t206_lo, e_t265_lo]
  have e_t269_hi : t269_hi = t269_hi' := by rw [ht269_hi, e_t206_lo, e_t265_lo]
  have e_t324_lo : t324_lo = t324_lo' := by rw [ht324_lo, e_t285_lo, e_t320_lo]
  have e_t324_hi : t324_hi = t324_hi' := by rw [ht324_hi, e_t285_lo, e_t320_lo]
  have e_t356_lo : t356_lo = t356_lo' := by rw [ht356_lo, e_t340_lo, e_t352_lo]
  have e_t356_hi : t356_hi = t356_hi' := by rw [ht356_hi, e_t340_lo, e_t352_lo]
  have e_t195_lo : t195_lo = t195_lo' := by rw [ht195_lo, e_t1_lo, e_t191_lo]
  have e_t195_hi : t195_hi = t195_hi' := by rw [ht195_hi, e_t1_lo, e_t191_lo]
  have e_t272_lo : t272_lo = t272_lo' := by rw [ht272_lo, e_t195_hi, e_t269_lo]
  have e_t272_hi : t272_hi = t272_hi' := by rw [ht272_hi, e_t269_hi, e_t195_hi, e_t269_lo]
  have e_t327_lo : t327_lo = t327_lo' := by rw [ht327_lo, e_t272_hi, e_t324_lo]
  have e_t327_hi : t327_hi = t327_hi' := by rw [ht327_hi, e_t324_hi, e_t272_hi, e_t324_lo]
  have e_t359_lo : t359_lo = t359_lo' := by rw [ht359_lo, e_t327_hi, e_t356_lo]
  have e_t359_hi : t359_hi = t359_hi' := by rw [ht359_hi, e_t356_hi, e_t327_hi, e_t356_lo]
  have e_t368 : t368 = t368' := by rw [ht368, e_t359_hi, e_t367]
  have e_t373 : t373 = t373' := by rw [ht373, e_t368, e_t359_lo]
  have e_t398 : t398 = t398' := by rw [ht398, e_t359_lo]
  have e_t374 : t374 = t374' := by rw [ht374, e_t373]
  have e_t375_lo : t375_lo = t375_lo' := by rw [ht375_lo, e_t195_lo, e_t374]
  have e_t375_hi : t375_hi = t375_hi' := by rw [ht375_hi, e_t195_lo, e_t374]
  have e_t384_lo : t384_lo = t384_lo' := by rw [ht384_lo, e_t272_lo, e_t375_hi]
  have e_t384_hi : t384_hi = t384_hi' := by rw [ht384_hi, e_t272_lo, e_t375_hi]
  have e_t393_lo : t393_lo = t393_lo' := by rw [ht393_lo, e_t327_lo, e_t384_hi]
  have e_t393_hi : t393_hi = t393_hi' := by rw [ht393_hi, e_t327_lo, e_t384_hi]
  have e_t401 : t401 = t401' := by rw [ht401, e_t398, e_t393_hi]
  rw [e_t401, e_t393_lo, e_t384_lo, e_t375_lo]))

section Proof

-- 435 instructions with 56 calls, every step interpreted: about 3.8M heartbeats
set_option maxHeartbeats 5000000 in
/-- `crc_fe64_mul_c( r, x, y )` stores `Fe64.mul` of the elements at `x` and `y` at `r`. Its
56 carry slots are freed again (the counter moves on by 56). The loads precede the stores,
so `r` may alias `x` or `y`. -/
public theorem crc_fe64_mul_c.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_mul_c.call (crc_fe64_mul_c.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 56⟩,
            mem := s.mem.storeAt r (Fe64.mul (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  mul_walk_1 crc_fe64_addc.call_eq
  mul_walk_2 crc_fe64_addc.call_eq
  mul_walk_3 crc_fe64_addc.call_eq
  mul_walk_4 crc_fe64_addc.call_eq
  mul_walk_5 crc_fe64_addc.call_eq
  mul_walk_6 crc_fe64_addc.call_eq
  mul_walk_7
  mul_walk_8
  mul_walk_9

-- 435 instructions with 56 calls, every step interpreted: about 3.8M heartbeats
set_option maxHeartbeats 5000000 in
@[inherit_doc crc_fe64_mul_c.call_eq]
public theorem crc_fe64_mul_c_2.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_mul_c_2.call (crc_fe64_mul_c_2.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 56⟩,
            mem := s.mem.storeAt r (Fe64.mul (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  mul_walk_1 crc_fe64_addc_7.call_eq
  mul_walk_2 crc_fe64_addc_7.call_eq
  mul_walk_3 crc_fe64_addc_7.call_eq
  mul_walk_4 crc_fe64_addc_7.call_eq
  mul_walk_5 crc_fe64_addc_7.call_eq
  mul_walk_6 crc_fe64_addc_7.call_eq
  mul_walk_7
  mul_walk_8
  mul_walk_9

-- 435 instructions with 56 calls, every step interpreted: about 3.8M heartbeats
set_option maxHeartbeats 5000000 in
@[inherit_doc crc_fe64_mul_c.call_eq]
public theorem crc_fe64_mul_c_40.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_mul_c_40.call (crc_fe64_mul_c_40.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 56⟩,
            mem := s.mem.storeAt r (Fe64.mul (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  mul_walk_1 crc_fe64_addc_34.call_eq
  mul_walk_2 crc_fe64_addc_34.call_eq
  mul_walk_3 crc_fe64_addc_34.call_eq
  mul_walk_4 crc_fe64_addc_34.call_eq
  mul_walk_5 crc_fe64_addc_34.call_eq
  mul_walk_6 crc_fe64_addc_34.call_eq
  mul_walk_7
  mul_walk_8
  mul_walk_9

end Proof

end MLIR.Firedancer.Crc.Ref


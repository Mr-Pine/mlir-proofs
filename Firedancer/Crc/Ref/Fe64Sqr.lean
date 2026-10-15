module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Fe64
public import Firedancer.Crc.Ref.Fe64Carry
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sqr_c
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sqr_c_10
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sqr_c_37
import Firedancer.Common.Tactics

/-!
# `crc_fe64_sqr_c` refinement (MLIR lift ↔ spec)

Each copy of `crc_fe64_sqr_c( r, x )` stores `Fe64.sqr` of the 256-bit value at `x`
at `r` (`x²` mod `p`, below `2^255 + 2^11`: `Fe64.sqr_val`, `Fe64.sqr_lt`).
-/

namespace MLIR.Firedancer.Crc.Ref

open Fe64

set_option hygiene false in
/-- Part 1 of 7 of `crc_fe64_sqr_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "sqr_walk_1" c:term : tactic => `(tactic| (
  func_init
  have x0_rd : S.mem.readAt x 64 = (S₀.mem.readAt x 256).extractLsb' 0 64 := by
    subst hS; exact Fe64.readAt_limb0
  have x1_rd : S.mem.readAt (x.add 8#64) 64 = (S₀.mem.readAt x 256).extractLsb' 64 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  have x2_rd : S.mem.readAt (x.add 16#64) 64 = (S₀.mem.readAt x 256).extractLsb' 128 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  have x3_rd : S.mem.readAt (x.add 24#64) 64 = (S₀.mem.readAt x 256).extractLsb' 192 64 := by
    subst hS; exact Fe64.readAt_limb hx hxo (by decide)
  block_init
  iterate 6 step_pure
  iterate 48 step_alloca
  have hB0 := hS.symm
  clear hS
  step_load with x0 consuming x0_rd
  iterate 2 step_pure
  step_load with x1 consuming x1_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t6_lo
  rw [BitVec.mul_comm] at ht6_lo
  step_pure
  step_pure [trunc_hi] with t6_hi
  rw [BitVec.mul_comm] at ht6_hi
  step_pure
  step_load with x3 consuming x3_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t54_lo
  rw [BitVec.mul_comm] at ht54_lo
  step_pure
  step_pure [trunc_hi] with t54_hi
  rw [BitVec.mul_comm] at ht54_hi
  step_pure
  step_load with x2 consuming x2_rd
  step_pure
  step_pure [umulOverflow_setWidth]
  step_pure with t162_lo
  step_pure
  step_pure [trunc_hi] with t162_hi
  have b_t162_hi : t162_hi.toNat ≤ 18446744073709551614 := hi_le ht162_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t26_lo
  rw [BitVec.mul_comm] at ht26_lo
  step_pure
  step_pure [trunc_hi] with t26_hi
  rw [BitVec.mul_comm] at ht26_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t64_lo
  rw [BitVec.mul_comm] at ht64_lo
  step_pure
  step_pure [trunc_hi] with t64_hi
  rw [BitVec.mul_comm] at ht64_hi
  step_pure
  step_call using $c with t101_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t108_lo
  rw [BitVec.mul_comm] at ht108_lo
  step_pure
  step_pure [trunc_hi] with t108_hi
  rw [BitVec.mul_comm] at ht108_hi
  step_pure
  step_call using $c with t167_hi
  have b_t167_hi : t167_hi.toNat ≤ 1 := carry_le ht167_hi
  step_pure
  step_call using $c with t59_hi
  step_pure
  step_load with t101_lo consuming hread_v6
  clear hfits_v6 hroom_v6 hv6_bounds hwritable_v6 hv6_off hr_ne_v6 hx_ne_v6
  step_call using $c
  step_pure with t104_hi
  rw [BitVec.or_comm] at ht104_hi
  step_pure
  step_load with t167_lo consuming hread_v7
  clear hfits_v7 hroom_v7 hv7_bounds hwritable_v7 hv7_off hr_ne_v7 hx_ne_v7
  step_call using $c
  step_pure with t170_hi
  rw [BitVec.or_comm] at ht170_hi
  have b_t170_hi : t170_hi.toNat ≤ 1 := or_carry_le ht170_hi b_t167_hi
  step_pure [uaddOverflow_false b_t170_hi b_t162_hi] with t230))

set_option hygiene false in
/-- Part 2 of 7 of `crc_fe64_sqr_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "sqr_walk_2" c:term : tactic => `(tactic| (
  rw [BitVec.add_comm] at ht230
  step_pure
  step_load with t59_lo consuming hread_v8
  clear hfits_v8 hroom_v8 hv8_bounds hwritable_v8 hv8_off hr_ne_v8 hx_ne_v8
  step_call using $c with t67_hi
  step_pure
  step_load with t104_lo consuming hread_v9
  clear hfits_v9 hroom_v9 hv9_bounds hwritable_v9 hv9_off hr_ne_v9 hx_ne_v9
  step_call using $c with t111_hi
  step_pure
  step_call using $c with t29_hi
  step_pure
  step_load with t67_lo consuming hread_v11
  clear hfits_v11 hroom_v11 hv11_bounds hwritable_v11 hv11_off hr_ne_v11 hx_ne_v11
  step_call using $c
  step_pure with t70_hi
  rw [BitVec.or_comm] at ht70_hi
  step_pure
  step_load with t111_lo consuming hread_v12
  clear hfits_v12 hroom_v12 hv12_bounds hwritable_v12 hv12_off hr_ne_v12 hx_ne_v12
  step_call using $c
  step_pure with t114_hi
  rw [BitVec.or_comm] at ht114_hi
  step_pure
  step_load with t170_lo consuming hread_v10
  clear hfits_v10 hroom_v10 hv10_bounds hwritable_v10 hv10_off hr_ne_v10 hx_ne_v10
  step_call using $c with t174_hi
  step_pure with t231
  rw [BitVec.add_comm] at ht231
  step_pure [umulOverflow_setWidth]
  step_pure with t1_lo
  step_pure
  step_pure [trunc_hi] with t1_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t19_lo
  step_pure
  step_pure [trunc_hi] with t19_hi
  step_pure
  step_load with t29_lo consuming hread_v13
  clear hfits_v13 hroom_v13 hv13_bounds hwritable_v13 hv13_off hr_ne_v13 hx_ne_v13
  have hB1 := hS.symm
  clear hS
  step_call using $c with t34_hi
  step_pure
  step_load with t70_lo consuming hread_v14
  clear hfits_v14 hroom_v14 hv14_bounds hwritable_v14 hv14_off hr_ne_v14 hx_ne_v14
  step_call using $c with t74_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t88_lo
  step_pure
  step_pure [trunc_hi] with t88_hi
  step_pure
  step_load with t114_lo consuming hread_v15
  clear hfits_v15 hroom_v15 hv15_bounds hwritable_v15 hv15_off hr_ne_v15 hx_ne_v15
  step_call using $c with t118_hi
  step_pure
  step_load with t174_lo consuming hread_v16
  clear hfits_v16 hroom_v16 hv16_bounds hwritable_v16 hv16_off hr_ne_v16 hx_ne_v16
  step_call using $c with t179_hi
  step_pure [umulOverflow_setWidth]
  step_pure with t219_lo
  step_pure
  step_pure [trunc_hi] with t219_hi
  have b_t219_hi : t219_hi.toNat ≤ 18446744073709551614 := hi_le ht219_hi
  step_pure
  step_call using $c with t232_hi
  have b_t232_hi : t232_hi.toNat ≤ 1 := carry_le ht232_hi
  step_pure
  step_call using $c with t9_hi
  step_pure
  step_load with t34_lo consuming hread_v17
  clear hfits_v17 hroom_v17 hv17_bounds hwritable_v17 hv17_off hr_ne_v17 hx_ne_v17
  step_call using $c
  step_pure with t37_hi
  rw [BitVec.or_comm] at ht37_hi
  step_pure
  step_load with t74_lo consuming hread_v18
  clear hfits_v18 hroom_v18 hv18_bounds hwritable_v18 hv18_off hr_ne_v18 hx_ne_v18
  step_call using $c
  step_pure with t77_hi))

set_option hygiene false in
/-- Part 3 of 7 of `crc_fe64_sqr_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "sqr_walk_3" c:term : tactic => `(tactic| (
  rw [BitVec.or_comm] at ht77_hi
  step_pure
  step_load with t118_lo consuming hread_v19
  clear hfits_v19 hroom_v19 hv19_bounds hwritable_v19 hv19_off hr_ne_v19 hx_ne_v19
  step_call using $c
  step_pure with t121_hi
  rw [BitVec.or_comm] at ht121_hi
  step_pure
  step_load with t179_lo consuming hread_v20
  clear hfits_v20 hroom_v20 hv20_bounds hwritable_v20 hv20_off hr_ne_v20 hx_ne_v20
  step_call using $c
  step_pure with t182_hi
  rw [BitVec.or_comm] at ht182_hi
  step_pure
  step_load with t232_lo consuming hread_v21
  clear hfits_v21 hroom_v21 hv21_bounds hwritable_v21 hv21_off hr_ne_v21 hx_ne_v21
  step_call using $c
  step_pure with t235_hi
  rw [BitVec.or_comm] at ht235_hi
  have b_t235_hi : t235_hi.toNat ≤ 1 := or_carry_le ht235_hi b_t232_hi
  step_pure [uaddOverflow_false b_t235_hi b_t219_hi] with t276
  rw [BitVec.add_comm] at ht276
  step_pure
  step_load with t37_lo consuming hread_v23
  clear hfits_v23 hroom_v23 hv23_bounds hwritable_v23 hv23_off hr_ne_v23 hx_ne_v23
  step_call using $c with t41_hi
  step_pure
  step_load with t77_lo consuming hread_v24
  clear hfits_v24 hroom_v24 hv24_bounds hwritable_v24 hv24_off hr_ne_v24 hx_ne_v24
  have hB2 := hS.symm
  clear hS
  step_call using $c with t81_hi
  step_pure
  step_load with t121_lo consuming hread_v25
  clear hfits_v25 hroom_v25 hv25_bounds hwritable_v25 hv25_off hr_ne_v25 hx_ne_v25
  step_call using $c with t125_hi
  step_pure
  step_load with t182_lo consuming hread_v26
  clear hfits_v26 hroom_v26 hv26_bounds hwritable_v26 hv26_off hr_ne_v26 hx_ne_v26
  step_call using $c with t186_hi
  step_pure
  step_load with t235_lo consuming hread_v27
  clear hfits_v27 hroom_v27 hv27_bounds hwritable_v27 hv27_off hr_ne_v27 hx_ne_v27
  step_call using $c with t239_hi
  step_pure
  step_load with t9_lo consuming hread_v22
  clear hfits_v22 hroom_v22 hv22_bounds hwritable_v22 hv22_off hr_ne_v22 hx_ne_v22
  step_call using $c with t14_hi
  step_pure
  step_load with t41_lo consuming hread_v28
  clear hfits_v28 hroom_v28 hv28_bounds hwritable_v28 hv28_off hr_ne_v28 hx_ne_v28
  step_call using $c
  step_pure with t44_hi
  rw [BitVec.or_comm] at ht44_hi
  step_pure
  step_load with t81_lo consuming hread_v29
  clear hfits_v29 hroom_v29 hv29_bounds hwritable_v29 hv29_off hr_ne_v29 hx_ne_v29
  step_call using $c
  step_pure with t84_hi
  rw [BitVec.or_comm] at ht84_hi
  step_pure
  step_load with t125_lo consuming hread_v30
  clear hfits_v30 hroom_v30 hv30_bounds hwritable_v30 hv30_off hr_ne_v30 hx_ne_v30
  step_call using $c
  step_pure with t128_hi
  rw [BitVec.or_comm] at ht128_hi
  step_pure
  step_load with t186_lo consuming hread_v31
  clear hfits_v31 hroom_v31 hv31_bounds hwritable_v31 hv31_off hr_ne_v31 hx_ne_v31
  step_call using $c
  step_pure with t189_hi
  rw [BitVec.or_comm] at ht189_hi
  step_pure
  step_load with t239_lo consuming hread_v32
  clear hfits_v32 hroom_v32 hv32_bounds hwritable_v32 hv32_off hr_ne_v32 hx_ne_v32
  step_call using $c
  step_pure with t242_hi
  rw [BitVec.or_comm] at ht242_hi
  step_pure with t277
  rw [BitVec.add_comm] at ht277))

set_option hygiene false in
/-- Part 4 of 7 of `crc_fe64_sqr_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "sqr_walk_4" c:term : tactic => `(tactic| (
  step_load with t128_lo consuming hread_v36
  clear hfits_v36 hroom_v36 hv36_bounds hwritable_v36 hv36_off hr_ne_v36 hx_ne_v36
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t132_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t132_hi
  step_load with t189_lo consuming hread_v37
  clear hfits_v37 hroom_v37 hv37_bounds hwritable_v37 hv37_off hr_ne_v37 hx_ne_v37
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t193_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t193_hi
  step_pure
  step_load with t44_lo consuming hread_v34
  clear hfits_v34 hroom_v34 hv34_bounds hwritable_v34 hv34_off hr_ne_v34 hx_ne_v34
  step_call using $c with t210_hi
  step_load with t242_lo consuming hread_v38
  clear hfits_v38 hroom_v38 hv38_bounds hwritable_v38 hv38_off hr_ne_v38 hx_ne_v38
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t246_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t246_hi
  step_pure
  step_load with t84_lo consuming hread_v35
  clear hfits_v35 hroom_v35 hv35_bounds hwritable_v35 hv35_off hr_ne_v35 hx_ne_v35
  step_call using $c with t263_hi
  have b_t263_hi : t263_hi.toNat ≤ 1 := carry_le ht263_hi
  step_pure
  step_pure [umulOverflow_mul38, smulOverflow_mul38]
  step_pure with t278_lo
  step_pure
  step_pure [trunc_hi, sext_hi38] with t278_hi
  have b_t278_hi : t278_hi.toNat ≤ 37 := hi38_le ht278_hi
  step_pure
  step_load with t14_lo consuming hread_v33
  clear hfits_v33 hroom_v33 hv33_bounds hwritable_v33 hv33_off hr_ne_v33 hx_ne_v33
  have hB3 := hS.symm
  clear hS
  step_call using $c with t147_hi
  step_pure
  step_load with t210_lo consuming hread_v39
  clear hfits_v39 hroom_v39 hv39_bounds hwritable_v39 hv39_off hr_ne_v39 hx_ne_v39
  step_call using $c
  step_pure with t213_hi
  rw [BitVec.or_comm] at ht213_hi
  step_pure
  step_load with t263_lo consuming hread_v40
  clear hfits_v40 hroom_v40 hv40_bounds hwritable_v40 hv40_off hr_ne_v40 hx_ne_v40
  step_call using $c
  step_pure with t266_hi
  rw [BitVec.or_comm] at ht266_hi
  have b_t266_hi : t266_hi.toNat ≤ 1 := or_carry_le ht266_hi b_t263_hi
  step_pure [uaddOverflow_false b_t266_hi b_t278_hi,
      saddOverflow_false b_t266_hi b_t278_hi] with t293
  have b_t293 : t293.toNat ≤ 38 := add_le ht293 b_t266_hi b_t278_hi
  step_pure
  step_load with t147_lo consuming hread_v41
  clear hfits_v41 hroom_v41 hv41_bounds hwritable_v41 hv41_off hr_ne_v41 hx_ne_v41
  step_call using $c with t197_hi
  step_pure
  step_load with t213_lo consuming hread_v42
  clear hfits_v42 hroom_v42 hv42_bounds hwritable_v42 hv42_off hr_ne_v42 hx_ne_v42
  step_call using $c with t250_hi
  step_pure
  step_load with t266_lo consuming hread_v43
  clear hfits_v43 hroom_v43 hv43_bounds hwritable_v43 hv43_off hr_ne_v43 hx_ne_v43
  step_call using $c with t282_hi
  have b_t282_hi : t282_hi.toNat ≤ 1 := carry_le ht282_hi
  step_pure
  step_call using $c with t136_hi
  step_pure
  step_load with t197_lo consuming hread_v44
  clear hfits_v44 hroom_v44 hv44_bounds hwritable_v44 hv44_off hr_ne_v44 hx_ne_v44
  step_call using $c
  step_pure with t200_hi
  rw [BitVec.or_comm] at ht200_hi
  step_pure
  step_load with t250_lo consuming hread_v45))

set_option hygiene false in
/-- Part 5 of 7 of `crc_fe64_sqr_c`'s walk, `c` the carry helper's `call_eq`. -/
local macro "sqr_walk_5" c:term : tactic => `(tactic| (
  clear hfits_v45 hroom_v45 hv45_bounds hwritable_v45 hv45_off hr_ne_v45 hx_ne_v45
  step_call using $c
  step_pure with t253_hi
  rw [BitVec.or_comm] at ht253_hi
  step_pure
  step_load with t282_lo consuming hread_v46
  clear hfits_v46 hroom_v46 hv46_bounds hwritable_v46 hv46_off hr_ne_v46 hx_ne_v46
  step_call using $c
  step_pure with t285_hi
  rw [BitVec.or_comm] at ht285_hi
  have b_t285_hi : t285_hi.toNat ≤ 1 := or_carry_le ht285_hi b_t282_hi
  step_pure [uaddOverflow_false b_t293 b_t285_hi, saddOverflow_false b_t293 b_t285_hi] with t294
  rw [BitVec.add_comm] at ht294
  have b_t294 : t294.toNat ≤ 39 := add_le ht294 b_t285_hi b_t293
  step_load with t285_lo consuming hread_v50
  clear hfits_v50 hroom_v50 hv50_bounds hwritable_v50 hv50_off hr_ne_v50 hx_ne_v50
  step_pure with t299
  rw [fshl_one] at ht299
  have b_t299 : t299.toNat ≤ 79 := dbl_top_le ht299 b_t294
  step_pure with t324
  have b_t324 : t324.toNat ≤ 9223372036854775807 := mask_le ht324
  step_pure [umulOverflow_mul19 b_t299, smulOverflow_mul19 b_t299] with t300
  step_pure
  step_load with t136_lo consuming hread_v47
  clear hfits_v47 hroom_v47 hv47_bounds hwritable_v47 hv47_off hr_ne_v47 hx_ne_v47
  step_call using $c with t301_hi
  step_pure
  step_load with t200_lo consuming hread_v48
  clear hfits_v48 hroom_v48 hv48_bounds hwritable_v48 hv48_off hr_ne_v48 hx_ne_v48
  step_call using $c with t310_hi
  step_pure
  step_load with t253_lo consuming hread_v49
  clear hfits_v49 hroom_v49 hv49_bounds hwritable_v49 hv49_off hr_ne_v49 hx_ne_v49
  have hB4 := hS.symm
  clear hS
  step_call using $c with t319_hi
  have b_t319_hi : t319_hi.toNat ≤ 1 := carry_le ht319_hi
  step_pure [uaddOverflow_false b_t319_hi b_t324] with t327
  rw [BitVec.add_comm] at ht327
  step_load with t301_lo consuming hread_v51
  clear hfits_v51 hroom_v51 hv51_bounds hwritable_v51 hv51_off hr_ne_v51 hx_ne_v51
  step_store
  step_load with t310_lo consuming hread_v52
  clear hfits_v52 hroom_v52 hv52_bounds hwritable_v52 hv52_off hr_ne_v52 hx_ne_v52
  step_pure
  step_store
  step_load with t319_lo consuming hread_v53
  clear hfits_v53 hroom_v53 hv53_bounds hwritable_v53 hv53_off hr_ne_v53 hx_ne_v53
  step_pure
  step_store
  step_pure
  step_store
  iterate 48 step_pure
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
  suffices e : t327 ++ (t319_lo ++ (t310_lo ++ t301_lo)) =
      Fe64.sqr (S₀.mem.readAt x 256) by rw [e]
  -- the named values, one by one, as the spec's
  clear_reads
  unfold Fe64.sqr
  extract_lets x0' x1' x2' x3' p2' t6_lo' t6_hi' p5' t54_lo' t54_hi' p10' t162_lo' t162_hi' p4'
      t26_lo' t26_hi' p6' t64_lo' t64_hi' t101_lo' t101_hi' p8' t108_lo' t108_hi' t167_lo' t167_hi'
      t59_lo' t59_hi' t104_lo' c104' t104_hi' t170_lo' c170' t170_hi' t230' t67_lo' t67_hi'
      t111_lo' t111_hi' t29_lo' t29_hi' t70_lo' c70' t70_hi' t114_lo' c114' t114_hi' t174_lo'
      t174_hi' t231' p1' t1_lo' t1_hi' p3' t19_lo' t19_hi' t34_lo' t34_hi' t74_lo' t74_hi' p7'
      t88_lo' t88_hi' t118_lo' t118_hi' t179_lo' t179_hi' p12' t219_lo' t219_hi' t232_lo' t232_hi'
      t9_lo' t9_hi' t37_lo' c37' t37_hi' t77_lo' c77' t77_hi' t121_lo' c121' t121_hi' t182_lo'
      c182' t182_hi' t235_lo' c235' t235_hi' t276' t41_lo' t41_hi' t81_lo' t81_hi' t125_lo'
      t125_hi' t186_lo' t186_hi' t239_lo' t239_hi' t14_lo' t14_hi' t44_lo' c44' t44_hi' t84_lo'
      c84' t84_hi' t128_lo' c128' t128_hi' t189_lo' c189' t189_hi' t242_lo' c242' t242_hi' t277'
      p9' t132_lo' t132_hi' p11' t193_lo' t193_hi' t210_lo' t210_hi' p13' t246_lo' t246_hi'
      t263_lo' t263_hi' p14' t278_lo' t278_hi' t147_lo' t147_hi' t213_lo' c213' t213_hi' t266_lo'
      c266' t266_hi' t293' t197_lo' t197_hi' t250_lo' t250_hi' t282_lo' t282_hi' t136_lo' t136_hi'
      t200_lo' c200' t200_hi' t253_lo' c253' t253_hi' t285_lo' c285' t285_hi' t294' t295' t298'
      t299' t324' t300' t301_lo' t301_hi' t310_lo' t310_hi' t319_lo' t319_hi' t327'
  have e_x0 : x0 = x0' := hx0
  have e_x1 : x1 = x1' := hx1
  have e_x2 : x2 = x2' := hx2
  have e_x3 : x3 = x3' := hx3))

set_option hygiene false in
/-- Part 6 of 7 of `crc_fe64_sqr_c`'s walk. -/
local macro "sqr_walk_6" : tactic => `(tactic| (
  have e_t6_lo : t6_lo = t6_lo' := by rw [ht6_lo, e_x0, e_x1]
  have e_t6_hi : t6_hi = t6_hi' := by rw [ht6_hi, e_x0, e_x1]
  have e_t54_lo : t54_lo = t54_lo' := by rw [ht54_lo, e_x0, e_x3]
  have e_t54_hi : t54_hi = t54_hi' := by rw [ht54_hi, e_x0, e_x3]
  have e_t162_lo : t162_lo = t162_lo' := by rw [ht162_lo, e_x2, e_x3]
  have e_t162_hi : t162_hi = t162_hi' := by rw [ht162_hi, e_x2, e_x3]
  have e_t26_lo : t26_lo = t26_lo' := by rw [ht26_lo, e_x0, e_x2]
  have e_t26_hi : t26_hi = t26_hi' := by rw [ht26_hi, e_x0, e_x2]
  have e_t64_lo : t64_lo = t64_lo' := by rw [ht64_lo, e_x1, e_x2]
  have e_t64_hi : t64_hi = t64_hi' := by rw [ht64_hi, e_x1, e_x2]
  have e_t101_lo : t101_lo = t101_lo' := by rw [ht101_lo, e_t54_hi, e_t64_hi]
  have e_t101_hi : t101_hi = t101_hi' := by rw [ht101_hi, e_t54_hi, e_t64_hi]
  have e_t108_lo : t108_lo = t108_lo' := by rw [ht108_lo, e_x1, e_x3]
  have e_t108_hi : t108_hi = t108_hi' := by rw [ht108_hi, e_x1, e_x3]
  have e_t167_lo : t167_lo = t167_lo' := by rw [ht167_lo, e_t162_lo, e_t108_hi]
  have e_t167_hi : t167_hi = t167_hi' := by rw [ht167_hi, e_t162_lo, e_t108_hi]
  have e_t59_lo : t59_lo = t59_lo' := by rw [ht59_lo, e_t54_lo, e_t26_hi]
  have e_t59_hi : t59_hi = t59_hi' := by rw [ht59_hi, e_t54_lo, e_t26_hi]
  have e_t104_lo : t104_lo = t104_lo' := by rw [ht104_lo, e_t59_hi, e_t101_lo]
  have e_t104_hi : t104_hi = t104_hi' := by rw [ht104_hi, e_t101_hi, e_t59_hi, e_t101_lo]
  have e_t170_lo : t170_lo = t170_lo' := by rw [ht170_lo, e_t104_hi, e_t167_lo]
  have e_t170_hi : t170_hi = t170_hi' := by rw [ht170_hi, e_t167_hi, e_t104_hi, e_t167_lo]
  have e_t230 : t230 = t230' := by rw [ht230, e_t162_hi, e_t170_hi]
  have e_t67_lo : t67_lo = t67_lo' := by rw [ht67_lo, e_t59_lo, e_t64_lo]
  have e_t67_hi : t67_hi = t67_hi' := by rw [ht67_hi, e_t59_lo, e_t64_lo]
  have e_t111_lo : t111_lo = t111_lo' := by rw [ht111_lo, e_t104_lo, e_t108_lo]
  have e_t111_hi : t111_hi = t111_hi' := by rw [ht111_hi, e_t104_lo, e_t108_lo]
  have e_t29_lo : t29_lo = t29_lo' := by rw [ht29_lo, e_t6_hi, e_t26_lo]
  have e_t29_hi : t29_hi = t29_hi' := by rw [ht29_hi, e_t6_hi, e_t26_lo]
  have e_t70_lo : t70_lo = t70_lo' := by rw [ht70_lo, e_t29_hi, e_t67_lo]
  have e_t70_hi : t70_hi = t70_hi' := by rw [ht70_hi, e_t67_hi, e_t29_hi, e_t67_lo]
  have e_t114_lo : t114_lo = t114_lo' := by rw [ht114_lo, e_t70_hi, e_t111_lo]
  have e_t114_hi : t114_hi = t114_hi' := by rw [ht114_hi, e_t111_hi, e_t70_hi, e_t111_lo]
  have e_t174_lo : t174_lo = t174_lo' := by rw [ht174_lo, e_t114_hi, e_t170_lo]
  have e_t174_hi : t174_hi = t174_hi' := by rw [ht174_hi, e_t114_hi, e_t170_lo]
  have e_t231 : t231 = t231' := by rw [ht231, e_t174_hi, e_t230]
  have e_t1_lo : t1_lo = t1_lo' := by rw [ht1_lo, e_x0]
  have e_t1_hi : t1_hi = t1_hi' := by rw [ht1_hi, e_x0]
  have e_t19_lo : t19_lo = t19_lo' := by rw [ht19_lo, e_x1]
  have e_t19_hi : t19_hi = t19_hi' := by rw [ht19_hi, e_x1]
  have e_t34_lo : t34_lo = t34_lo' := by rw [ht34_lo, e_t29_lo]
  have e_t34_hi : t34_hi = t34_hi' := by rw [ht34_hi, e_t29_lo]
  have e_t74_lo : t74_lo = t74_lo' := by rw [ht74_lo, e_t70_lo]
  have e_t74_hi : t74_hi = t74_hi' := by rw [ht74_hi, e_t70_lo]
  have e_t88_lo : t88_lo = t88_lo' := by rw [ht88_lo, e_x2]
  have e_t88_hi : t88_hi = t88_hi' := by rw [ht88_hi, e_x2]
  have e_t118_lo : t118_lo = t118_lo' := by rw [ht118_lo, e_t114_lo]
  have e_t118_hi : t118_hi = t118_hi' := by rw [ht118_hi, e_t114_lo]
  have e_t179_lo : t179_lo = t179_lo' := by rw [ht179_lo, e_t174_lo]
  have e_t179_hi : t179_hi = t179_hi' := by rw [ht179_hi, e_t174_lo]
  have e_t219_lo : t219_lo = t219_lo' := by rw [ht219_lo, e_x3]
  have e_t219_hi : t219_hi = t219_hi' := by rw [ht219_hi, e_x3]
  have e_t232_lo : t232_lo = t232_lo' := by rw [ht232_lo, e_t231]
  have e_t232_hi : t232_hi = t232_hi' := by rw [ht232_hi, e_t231]
  have e_t9_lo : t9_lo = t9_lo' := by rw [ht9_lo, e_t6_lo]
  have e_t9_hi : t9_hi = t9_hi' := by rw [ht9_hi, e_t6_lo]
  have e_t37_lo : t37_lo = t37_lo' := by rw [ht37_lo, e_t9_hi, e_t34_lo]
  have e_t37_hi : t37_hi = t37_hi' := by rw [ht37_hi, e_t34_hi, e_t9_hi, e_t34_lo]
  have e_t77_lo : t77_lo = t77_lo' := by rw [ht77_lo, e_t37_hi, e_t74_lo]
  have e_t77_hi : t77_hi = t77_hi' := by rw [ht77_hi, e_t74_hi, e_t37_hi, e_t74_lo]
  have e_t121_lo : t121_lo = t121_lo' := by rw [ht121_lo, e_t77_hi, e_t118_lo]
  have e_t121_hi : t121_hi = t121_hi' := by rw [ht121_hi, e_t118_hi, e_t77_hi, e_t118_lo]
  have e_t182_lo : t182_lo = t182_lo' := by rw [ht182_lo, e_t121_hi, e_t179_lo]
  have e_t182_hi : t182_hi = t182_hi' := by rw [ht182_hi, e_t179_hi, e_t121_hi, e_t179_lo]
  have e_t235_lo : t235_lo = t235_lo' := by rw [ht235_lo, e_t182_hi, e_t232_lo]
  have e_t235_hi : t235_hi = t235_hi' := by rw [ht235_hi, e_t232_hi, e_t182_hi, e_t232_lo]
  have e_t276 : t276 = t276' := by rw [ht276, e_t219_hi, e_t235_hi]
  have e_t41_lo : t41_lo = t41_lo' := by rw [ht41_lo, e_t19_lo, e_t37_lo]
  have e_t41_hi : t41_hi = t41_hi' := by rw [ht41_hi, e_t19_lo, e_t37_lo]
  have e_t81_lo : t81_lo = t81_lo' := by rw [ht81_lo, e_t19_hi, e_t77_lo]
  have e_t81_hi : t81_hi = t81_hi' := by rw [ht81_hi, e_t19_hi, e_t77_lo]
  have e_t125_lo : t125_lo = t125_lo' := by rw [ht125_lo, e_t88_lo, e_t121_lo]
  have e_t125_hi : t125_hi = t125_hi' := by rw [ht125_hi, e_t88_lo, e_t121_lo]
  have e_t186_lo : t186_lo = t186_lo' := by rw [ht186_lo, e_t88_hi, e_t182_lo]
  have e_t186_hi : t186_hi = t186_hi' := by rw [ht186_hi, e_t88_hi, e_t182_lo]
  have e_t239_lo : t239_lo = t239_lo' := by rw [ht239_lo, e_t219_lo, e_t235_lo]
  have e_t239_hi : t239_hi = t239_hi' := by rw [ht239_hi, e_t219_lo, e_t235_lo]
  have e_t14_lo : t14_lo = t14_lo' := by rw [ht14_lo, e_t1_hi, e_t9_lo]
  have e_t14_hi : t14_hi = t14_hi' := by rw [ht14_hi, e_t1_hi, e_t9_lo]
  have e_t44_lo : t44_lo = t44_lo' := by rw [ht44_lo, e_t14_hi, e_t41_lo]))

set_option hygiene false in
/-- Part 7 of 7 of `crc_fe64_sqr_c`'s walk. -/
local macro "sqr_walk_7" : tactic => `(tactic| (
  have e_t44_hi : t44_hi = t44_hi' := by rw [ht44_hi, e_t41_hi, e_t14_hi, e_t41_lo]
  have e_t84_lo : t84_lo = t84_lo' := by rw [ht84_lo, e_t44_hi, e_t81_lo]
  have e_t84_hi : t84_hi = t84_hi' := by rw [ht84_hi, e_t81_hi, e_t44_hi, e_t81_lo]
  have e_t128_lo : t128_lo = t128_lo' := by rw [ht128_lo, e_t84_hi, e_t125_lo]
  have e_t128_hi : t128_hi = t128_hi' := by rw [ht128_hi, e_t125_hi, e_t84_hi, e_t125_lo]
  have e_t189_lo : t189_lo = t189_lo' := by rw [ht189_lo, e_t128_hi, e_t186_lo]
  have e_t189_hi : t189_hi = t189_hi' := by rw [ht189_hi, e_t186_hi, e_t128_hi, e_t186_lo]
  have e_t242_lo : t242_lo = t242_lo' := by rw [ht242_lo, e_t189_hi, e_t239_lo]
  have e_t242_hi : t242_hi = t242_hi' := by rw [ht242_hi, e_t239_hi, e_t189_hi, e_t239_lo]
  have e_t277 : t277 = t277' := by rw [ht277, e_t242_hi, e_t276]
  have e_t132_lo : t132_lo = t132_lo' := by rw [ht132_lo, e_t128_lo]
  have e_t132_hi : t132_hi = t132_hi' := by rw [ht132_hi, e_t128_lo]
  have e_t193_lo : t193_lo = t193_lo' := by rw [ht193_lo, e_t189_lo]
  have e_t193_hi : t193_hi = t193_hi' := by rw [ht193_hi, e_t189_lo]
  have e_t210_lo : t210_lo = t210_lo' := by rw [ht210_lo, e_t44_lo, e_t193_hi]
  have e_t210_hi : t210_hi = t210_hi' := by rw [ht210_hi, e_t44_lo, e_t193_hi]
  have e_t246_lo : t246_lo = t246_lo' := by rw [ht246_lo, e_t242_lo]
  have e_t246_hi : t246_hi = t246_hi' := by rw [ht246_hi, e_t242_lo]
  have e_t263_lo : t263_lo = t263_lo' := by rw [ht263_lo, e_t84_lo, e_t246_hi]
  have e_t263_hi : t263_hi = t263_hi' := by rw [ht263_hi, e_t84_lo, e_t246_hi]
  have e_t278_lo : t278_lo = t278_lo' := by rw [ht278_lo, e_t277]
  have e_t278_hi : t278_hi = t278_hi' := by rw [ht278_hi, e_t277]
  have e_t147_lo : t147_lo = t147_lo' := by rw [ht147_lo, e_t14_lo, e_t132_hi]
  have e_t147_hi : t147_hi = t147_hi' := by rw [ht147_hi, e_t14_lo, e_t132_hi]
  have e_t213_lo : t213_lo = t213_lo' := by rw [ht213_lo, e_t147_hi, e_t210_lo]
  have e_t213_hi : t213_hi = t213_hi' := by rw [ht213_hi, e_t210_hi, e_t147_hi, e_t210_lo]
  have e_t266_lo : t266_lo = t266_lo' := by rw [ht266_lo, e_t213_hi, e_t263_lo]
  have e_t266_hi : t266_hi = t266_hi' := by rw [ht266_hi, e_t263_hi, e_t213_hi, e_t263_lo]
  have e_t293 : t293 = t293' := by rw [ht293, e_t266_hi, e_t278_hi]
  have e_t197_lo : t197_lo = t197_lo' := by rw [ht197_lo, e_t147_lo, e_t193_lo]
  have e_t197_hi : t197_hi = t197_hi' := by rw [ht197_hi, e_t147_lo, e_t193_lo]
  have e_t250_lo : t250_lo = t250_lo' := by rw [ht250_lo, e_t213_lo, e_t246_lo]
  have e_t250_hi : t250_hi = t250_hi' := by rw [ht250_hi, e_t213_lo, e_t246_lo]
  have e_t282_lo : t282_lo = t282_lo' := by rw [ht282_lo, e_t266_lo, e_t278_lo]
  have e_t282_hi : t282_hi = t282_hi' := by rw [ht282_hi, e_t266_lo, e_t278_lo]
  have e_t136_lo : t136_lo = t136_lo' := by rw [ht136_lo, e_t1_lo, e_t132_lo]
  have e_t136_hi : t136_hi = t136_hi' := by rw [ht136_hi, e_t1_lo, e_t132_lo]
  have e_t200_lo : t200_lo = t200_lo' := by rw [ht200_lo, e_t136_hi, e_t197_lo]
  have e_t200_hi : t200_hi = t200_hi' := by rw [ht200_hi, e_t197_hi, e_t136_hi, e_t197_lo]
  have e_t253_lo : t253_lo = t253_lo' := by rw [ht253_lo, e_t200_hi, e_t250_lo]
  have e_t253_hi : t253_hi = t253_hi' := by rw [ht253_hi, e_t250_hi, e_t200_hi, e_t250_lo]
  have e_t285_lo : t285_lo = t285_lo' := by rw [ht285_lo, e_t253_hi, e_t282_lo]
  have e_t285_hi : t285_hi = t285_hi' := by rw [ht285_hi, e_t282_hi, e_t253_hi, e_t282_lo]
  have e_t294 : t294 = t294' := by rw [ht294, e_t285_hi, e_t293]
  have e_t299 : t299 = t299' := by rw [ht299, e_t294, e_t285_lo]
  have e_t324 : t324 = t324' := by rw [ht324, e_t285_lo]
  have e_t300 : t300 = t300' := by rw [ht300, e_t299]
  have e_t301_lo : t301_lo = t301_lo' := by rw [ht301_lo, e_t136_lo, e_t300]
  have e_t301_hi : t301_hi = t301_hi' := by rw [ht301_hi, e_t136_lo, e_t300]
  have e_t310_lo : t310_lo = t310_lo' := by rw [ht310_lo, e_t200_lo, e_t301_hi]
  have e_t310_hi : t310_hi = t310_hi' := by rw [ht310_hi, e_t200_lo, e_t301_hi]
  have e_t319_lo : t319_lo = t319_lo' := by rw [ht319_lo, e_t253_lo, e_t310_hi]
  have e_t319_hi : t319_hi = t319_hi' := by rw [ht319_hi, e_t253_lo, e_t310_hi]
  have e_t327 : t327 = t327' := by rw [ht327, e_t324, e_t319_hi]
  rw [e_t327, e_t319_lo, e_t310_lo, e_t301_lo]))

section Proof

-- 354 instructions with 48 calls, every step interpreted: about 2.3M heartbeats
set_option maxHeartbeats 3200000 in
/-- `crc_fe64_sqr_c( r, x )` stores `Fe64.sqr` of the element at `x` at `r`. Its 48 carry
slots are freed again (the counter moves on by 48). The loads precede the stores, so `r`
may alias `x`. -/
public theorem crc_fe64_sqr_c.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_sqr_c.call (crc_fe64_sqr_c.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 48⟩,
            mem := s.mem.storeAt r (Fe64.sqr (s.mem.readAt x 256)) }) := by
  sqr_walk_1 crc_fe64_addc.call_eq
  sqr_walk_2 crc_fe64_addc.call_eq
  sqr_walk_3 crc_fe64_addc.call_eq
  sqr_walk_4 crc_fe64_addc.call_eq
  sqr_walk_5 crc_fe64_addc.call_eq
  sqr_walk_6
  sqr_walk_7

-- 354 instructions with 48 calls, every step interpreted: about 2.3M heartbeats
set_option maxHeartbeats 3200000 in
@[inherit_doc crc_fe64_sqr_c.call_eq]
public theorem crc_fe64_sqr_c_10.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_sqr_c_10.call (crc_fe64_sqr_c_10.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 48⟩,
            mem := s.mem.storeAt r (Fe64.sqr (s.mem.readAt x 256)) }) := by
  sqr_walk_1 crc_fe64_addc_7.call_eq
  sqr_walk_2 crc_fe64_addc_7.call_eq
  sqr_walk_3 crc_fe64_addc_7.call_eq
  sqr_walk_4 crc_fe64_addc_7.call_eq
  sqr_walk_5 crc_fe64_addc_7.call_eq
  sqr_walk_6
  sqr_walk_7

-- 354 instructions with 48 calls, every step interpreted: about 2.3M heartbeats
set_option maxHeartbeats 3200000 in
@[inherit_doc crc_fe64_sqr_c.call_eq]
public theorem crc_fe64_sqr_c_37.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_sqr_c_37.call (crc_fe64_sqr_c_37.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 48⟩,
            mem := s.mem.storeAt r (Fe64.sqr (s.mem.readAt x 256)) }) := by
  sqr_walk_1 crc_fe64_addc_34.call_eq
  sqr_walk_2 crc_fe64_addc_34.call_eq
  sqr_walk_3 crc_fe64_addc_34.call_eq
  sqr_walk_4 crc_fe64_addc_34.call_eq
  sqr_walk_5 crc_fe64_addc_34.call_eq
  sqr_walk_6
  sqr_walk_7

end Proof

end MLIR.Firedancer.Crc.Ref


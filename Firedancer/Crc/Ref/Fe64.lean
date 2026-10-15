module

public import MLIR.Run.Tactic
import Firedancer.Common.Memory
import Std.Tactic.BVDecide

/-!
# 4×64 field elements

A field element is four little-endian 64-bit limbs, read as one 256-bit value at its pointer.
`mul` and `sqr` are the kernels' results; their arithmetic is in `Fe64Math`. Below them, what the
kernels' walks use: limb reads, the flagged operations' no-overflow facts and the bounds behind
them.
-/

namespace MLIR.Firedancer.Crc.Ref.Fe64

@[expose] public section

/-- `crc_fe64_addc`'s carry out. -/
abbrev carry (a b : BitVec 64) : BitVec 64 :=
  (BitVec.ofBool (a.uaddOverflow b)).setWidth 64

/-- `crc_fe64_mul_c( r, x, y )`'s `r`, statement by statement (C's names; `cN` is the carry
an `|` merges in). -/
def mul (X Y : BitVec 256) : BitVec 256 :=
  let x0 := X.extractLsb' 0 64
  let x1 := X.extractLsb' 64 64
  let x2 := X.extractLsb' 128 64
  let x3 := X.extractLsb' 192 64
  let y0 := Y.extractLsb' 0 64
  let y1 := Y.extractLsb' 64 64
  let y2 := Y.extractLsb' 128 64
  let y3 := Y.extractLsb' 192 64
  let p1 := x0.setWidth 128 * y0.setWidth 128
  let t1_lo := p1.setWidth 64
  let t1_hi := (p1 >>> 64).setWidth 64
  let p2 := x1.setWidth 128 * y0.setWidth 128
  let t6_lo := p2.setWidth 64
  let t6_hi := (p2 >>> 64).setWidth 64
  let p4 := x2.setWidth 128 * y0.setWidth 128
  let t26_lo := p4.setWidth 64
  let t26_hi := (p4 >>> 64).setWidth 64
  let p7 := x3.setWidth 128 * y0.setWidth 128
  let t69_lo := p7.setWidth 64
  let t69_hi := (p7 >>> 64).setWidth 64
  let t29_lo := t6_hi + t26_lo
  let t29_hi := carry t6_hi t26_lo
  let t72_lo := t26_hi + t69_lo
  let t72_hi := carry t26_hi t69_lo
  let t9_lo := t1_hi + t6_lo
  let t9_hi := carry t1_hi t6_lo
  let t32_lo := t9_hi + t29_lo
  let c32 := carry t9_hi t29_lo
  let t32_hi := t29_hi ||| c32
  let t75_lo := t32_hi + t72_lo
  let c75 := carry t32_hi t72_lo
  let t75_hi := t72_hi ||| c75
  let t135 := t69_hi + t75_hi
  let p3 := x0.setWidth 128 * y1.setWidth 128
  let t14_lo := p3.setWidth 64
  let t14_hi := (p3 >>> 64).setWidth 64
  let p5 := x1.setWidth 128 * y1.setWidth 128
  let t43_lo := p5.setWidth 64
  let t43_hi := (p5 >>> 64).setWidth 64
  let t81_lo := t75_lo + t43_hi
  let t81_hi := carry t75_lo t43_hi
  let p8 := x2.setWidth 128 * y1.setWidth 128
  let t88_lo := p8.setWidth 64
  let t88_hi := (p8 >>> 64).setWidth 64
  let t138_lo := t135 + t88_hi
  let t138_hi := carry t135 t88_hi
  let p11 := x3.setWidth 128 * y1.setWidth 128
  let t145_lo := p11.setWidth 64
  let t145_hi := (p11 >>> 64).setWidth 64
  let t38_lo := t32_lo + t14_hi
  let t38_hi := carry t32_lo t14_hi
  let t84_lo := t38_hi + t81_lo
  let c84 := carry t38_hi t81_lo
  let t84_hi := t81_hi ||| c84
  let t141_lo := t84_hi + t138_lo
  let c141 := carry t84_hi t138_lo
  let t141_hi := t138_hi ||| c141
  let t225 := t141_hi + t145_hi
  let t46_lo := t38_lo + t43_lo
  let t46_hi := carry t38_lo t43_lo
  let t91_lo := t84_lo + t88_lo
  let t91_hi := carry t84_lo t88_lo
  let t148_lo := t141_lo + t145_lo
  let t148_hi := carry t141_lo t145_lo
  let t17_lo := t9_lo + t14_lo
  let t17_hi := carry t9_lo t14_lo
  let t49_lo := t17_hi + t46_lo
  let c49 := carry t17_hi t46_lo
  let t49_hi := t46_hi ||| c49
  let t94_lo := t49_hi + t91_lo
  let c94 := carry t49_hi t91_lo
  let t94_hi := t91_hi ||| c94
  let t151_lo := t94_hi + t148_lo
  let c151 := carry t94_hi t148_lo
  let t151_hi := t148_hi ||| c151
  let t226 := t151_hi + t225
  let p6 := x0.setWidth 128 * y2.setWidth 128
  let t53_lo := p6.setWidth 64
  let t53_hi := (p6 >>> 64).setWidth 64
  let p9 := x1.setWidth 128 * y2.setWidth 128
  let t105_lo := p9.setWidth 64
  let t105_hi := (p9 >>> 64).setWidth 64
  let t157_lo := t151_lo + t105_hi
  let t157_hi := carry t151_lo t105_hi
  let p12 := x2.setWidth 128 * y2.setWidth 128
  let t164_lo := p12.setWidth 64
  let t164_hi := (p12 >>> 64).setWidth 64
  let t229_lo := t226 + t164_hi
  let t229_hi := carry t226 t164_hi
  let p15 := x3.setWidth 128 * y2.setWidth 128
  let t236_lo := p15.setWidth 64
  let t236_hi := (p15 >>> 64).setWidth 64
  let t100_lo := t94_lo + t53_hi
  let t100_hi := carry t94_lo t53_hi
  let t160_lo := t100_hi + t157_lo
  let c160 := carry t100_hi t157_lo
  let t160_hi := t157_hi ||| c160
  let t232_lo := t160_hi + t229_lo
  let c232 := carry t160_hi t229_lo
  let t232_hi := t229_hi ||| c232
  let t299 := t232_hi + t236_hi
  let t108_lo := t100_lo + t105_lo
  let t108_hi := carry t100_lo t105_lo
  let t167_lo := t160_lo + t164_lo
  let t167_hi := carry t160_lo t164_lo
  let t239_lo := t232_lo + t236_lo
  let t239_hi := carry t232_lo t236_lo
  let t56_lo := t49_lo + t53_lo
  let t56_hi := carry t49_lo t53_lo
  let t111_lo := t56_hi + t108_lo
  let c111 := carry t56_hi t108_lo
  let t111_hi := t108_hi ||| c111
  let t170_lo := t111_hi + t167_lo
  let c170 := carry t111_hi t167_lo
  let t170_hi := t167_hi ||| c170
  let t242_lo := t170_hi + t239_lo
  let c242 := carry t170_hi t239_lo
  let t242_hi := t239_hi ||| c242
  let t300 := t242_hi + t299
  let p10 := x0.setWidth 128 * y3.setWidth 128
  let t115_lo := p10.setWidth 64
  let t115_hi := (p10 >>> 64).setWidth 64
  let p13 := x1.setWidth 128 * y3.setWidth 128
  let t181_lo := p13.setWidth 64
  let t181_hi := (p13 >>> 64).setWidth 64
  let t248_lo := t242_lo + t181_hi
  let t248_hi := carry t242_lo t181_hi
  let p16 := x2.setWidth 128 * y3.setWidth 128
  let t255_lo := p16.setWidth 64
  let t255_hi := (p16 >>> 64).setWidth 64
  let t303_lo := t300 + t255_hi
  let t303_hi := carry t300 t255_hi
  let p18 := x3.setWidth 128 * y3.setWidth 128
  let t310_lo := p18.setWidth 64
  let t310_hi := (p18 >>> 64).setWidth 64
  let t176_lo := t170_lo + t115_hi
  let t176_hi := carry t170_lo t115_hi
  let t251_lo := t176_hi + t248_lo
  let c251 := carry t176_hi t248_lo
  let t251_hi := t248_hi ||| c251
  let t306_lo := t251_hi + t303_lo
  let c306 := carry t251_hi t303_lo
  let t306_hi := t303_hi ||| c306
  let t350 := t306_hi + t310_hi
  let t184_lo := t176_lo + t181_lo
  let t184_hi := carry t176_lo t181_lo
  let t258_lo := t251_lo + t255_lo
  let t258_hi := carry t251_lo t255_lo
  let t313_lo := t306_lo + t310_lo
  let t313_hi := carry t306_lo t310_lo
  let t118_lo := t111_lo + t115_lo
  let t118_hi := carry t111_lo t115_lo
  let t187_lo := t118_hi + t184_lo
  let c187 := carry t118_hi t184_lo
  let t187_hi := t184_hi ||| c187
  let t261_lo := t187_hi + t258_lo
  let c261 := carry t187_hi t258_lo
  let t261_hi := t258_hi ||| c261
  let t316_lo := t261_hi + t313_lo
  let c316 := carry t261_hi t313_lo
  let t316_hi := t313_hi ||| c316
  let t351 := t316_hi + t350
  let p14 := t187_lo.setWidth 128 * 38#128
  let t191_lo := p14.setWidth 64
  let t191_hi := (p14 >>> 64).setWidth 64
  let p17 := t261_lo.setWidth 128 * 38#128
  let t265_lo := p17.setWidth 64
  let t265_hi := (p17 >>> 64).setWidth 64
  let t282_lo := t56_lo + t265_hi
  let t282_hi := carry t56_lo t265_hi
  let p19 := t316_lo.setWidth 128 * 38#128
  let t320_lo := p19.setWidth 64
  let t320_hi := (p19 >>> 64).setWidth 64
  let t337_lo := t118_lo + t320_hi
  let t337_hi := carry t118_lo t320_hi
  let p20 := t351.setWidth 128 * 38#128
  let t352_lo := p20.setWidth 64
  let t352_hi := (p20 >>> 64).setWidth 64
  let t206_lo := t17_lo + t191_hi
  let t206_hi := carry t17_lo t191_hi
  let t285_lo := t206_hi + t282_lo
  let c285 := carry t206_hi t282_lo
  let t285_hi := t282_hi ||| c285
  let t340_lo := t285_hi + t337_lo
  let c340 := carry t285_hi t337_lo
  let t340_hi := t337_hi ||| c340
  let t367 := t340_hi + t352_hi
  let t269_lo := t206_lo + t265_lo
  let t269_hi := carry t206_lo t265_lo
  let t324_lo := t285_lo + t320_lo
  let t324_hi := carry t285_lo t320_lo
  let t356_lo := t340_lo + t352_lo
  let t356_hi := carry t340_lo t352_lo
  let t195_lo := t1_lo + t191_lo
  let t195_hi := carry t1_lo t191_lo
  let t272_lo := t195_hi + t269_lo
  let c272 := carry t195_hi t269_lo
  let t272_hi := t269_hi ||| c272
  let t327_lo := t272_hi + t324_lo
  let c327 := carry t272_hi t324_lo
  let t327_hi := t324_hi ||| c327
  let t359_lo := t327_hi + t356_lo
  let c359 := carry t327_hi t356_lo
  let t359_hi := t356_hi ||| c359
  let t368 := t359_hi + t367
  let t369 := t368 * 2#64
  let t372 := t359_lo >>> 63
  let t373 := t369 + t372
  let t398 := t359_lo &&& 9223372036854775807#64
  let t374 := t373 * 19#64
  let t375_lo := t195_lo + t374
  let t375_hi := carry t195_lo t374
  let t384_lo := t272_lo + t375_hi
  let t384_hi := carry t272_lo t375_hi
  let t393_lo := t327_lo + t384_hi
  let t393_hi := carry t327_lo t384_hi
  let t401 := t398 + t393_hi
  t401 ++ (t393_lo ++ (t384_lo ++ t375_lo))

/-- `crc_fe64_sqr_c( r, x )`'s `r`, statement by statement (C's names; `cN` is the carry an
`|` merges in). -/
def sqr (X : BitVec 256) : BitVec 256 :=
  let x0 := X.extractLsb' 0 64
  let x1 := X.extractLsb' 64 64
  let x2 := X.extractLsb' 128 64
  let x3 := X.extractLsb' 192 64
  let p2 := x0.setWidth 128 * x1.setWidth 128
  let t6_lo := p2.setWidth 64
  let t6_hi := (p2 >>> 64).setWidth 64
  let p5 := x0.setWidth 128 * x3.setWidth 128
  let t54_lo := p5.setWidth 64
  let t54_hi := (p5 >>> 64).setWidth 64
  let p10 := x2.setWidth 128 * x3.setWidth 128
  let t162_lo := p10.setWidth 64
  let t162_hi := (p10 >>> 64).setWidth 64
  let p4 := x0.setWidth 128 * x2.setWidth 128
  let t26_lo := p4.setWidth 64
  let t26_hi := (p4 >>> 64).setWidth 64
  let p6 := x1.setWidth 128 * x2.setWidth 128
  let t64_lo := p6.setWidth 64
  let t64_hi := (p6 >>> 64).setWidth 64
  let t101_lo := t54_hi + t64_hi
  let t101_hi := carry t54_hi t64_hi
  let p8 := x1.setWidth 128 * x3.setWidth 128
  let t108_lo := p8.setWidth 64
  let t108_hi := (p8 >>> 64).setWidth 64
  let t167_lo := t162_lo + t108_hi
  let t167_hi := carry t162_lo t108_hi
  let t59_lo := t54_lo + t26_hi
  let t59_hi := carry t54_lo t26_hi
  let t104_lo := t59_hi + t101_lo
  let c104 := carry t59_hi t101_lo
  let t104_hi := t101_hi ||| c104
  let t170_lo := t104_hi + t167_lo
  let c170 := carry t104_hi t167_lo
  let t170_hi := t167_hi ||| c170
  let t230 := t162_hi + t170_hi
  let t67_lo := t59_lo + t64_lo
  let t67_hi := carry t59_lo t64_lo
  let t111_lo := t104_lo + t108_lo
  let t111_hi := carry t104_lo t108_lo
  let t29_lo := t6_hi + t26_lo
  let t29_hi := carry t6_hi t26_lo
  let t70_lo := t29_hi + t67_lo
  let c70 := carry t29_hi t67_lo
  let t70_hi := t67_hi ||| c70
  let t114_lo := t70_hi + t111_lo
  let c114 := carry t70_hi t111_lo
  let t114_hi := t111_hi ||| c114
  let t174_lo := t114_hi + t170_lo
  let t174_hi := carry t114_hi t170_lo
  let t231 := t174_hi + t230
  let p1 := x0.setWidth 128 * x0.setWidth 128
  let t1_lo := p1.setWidth 64
  let t1_hi := (p1 >>> 64).setWidth 64
  let p3 := x1.setWidth 128 * x1.setWidth 128
  let t19_lo := p3.setWidth 64
  let t19_hi := (p3 >>> 64).setWidth 64
  let t34_lo := t29_lo + t29_lo
  let t34_hi := carry t29_lo t29_lo
  let t74_lo := t70_lo + t70_lo
  let t74_hi := carry t70_lo t70_lo
  let p7 := x2.setWidth 128 * x2.setWidth 128
  let t88_lo := p7.setWidth 64
  let t88_hi := (p7 >>> 64).setWidth 64
  let t118_lo := t114_lo + t114_lo
  let t118_hi := carry t114_lo t114_lo
  let t179_lo := t174_lo + t174_lo
  let t179_hi := carry t174_lo t174_lo
  let p12 := x3.setWidth 128 * x3.setWidth 128
  let t219_lo := p12.setWidth 64
  let t219_hi := (p12 >>> 64).setWidth 64
  let t232_lo := t231 + t231
  let t232_hi := carry t231 t231
  let t9_lo := t6_lo + t6_lo
  let t9_hi := carry t6_lo t6_lo
  let t37_lo := t9_hi + t34_lo
  let c37 := carry t9_hi t34_lo
  let t37_hi := t34_hi ||| c37
  let t77_lo := t37_hi + t74_lo
  let c77 := carry t37_hi t74_lo
  let t77_hi := t74_hi ||| c77
  let t121_lo := t77_hi + t118_lo
  let c121 := carry t77_hi t118_lo
  let t121_hi := t118_hi ||| c121
  let t182_lo := t121_hi + t179_lo
  let c182 := carry t121_hi t179_lo
  let t182_hi := t179_hi ||| c182
  let t235_lo := t182_hi + t232_lo
  let c235 := carry t182_hi t232_lo
  let t235_hi := t232_hi ||| c235
  let t276 := t219_hi + t235_hi
  let t41_lo := t19_lo + t37_lo
  let t41_hi := carry t19_lo t37_lo
  let t81_lo := t19_hi + t77_lo
  let t81_hi := carry t19_hi t77_lo
  let t125_lo := t88_lo + t121_lo
  let t125_hi := carry t88_lo t121_lo
  let t186_lo := t88_hi + t182_lo
  let t186_hi := carry t88_hi t182_lo
  let t239_lo := t219_lo + t235_lo
  let t239_hi := carry t219_lo t235_lo
  let t14_lo := t1_hi + t9_lo
  let t14_hi := carry t1_hi t9_lo
  let t44_lo := t14_hi + t41_lo
  let c44 := carry t14_hi t41_lo
  let t44_hi := t41_hi ||| c44
  let t84_lo := t44_hi + t81_lo
  let c84 := carry t44_hi t81_lo
  let t84_hi := t81_hi ||| c84
  let t128_lo := t84_hi + t125_lo
  let c128 := carry t84_hi t125_lo
  let t128_hi := t125_hi ||| c128
  let t189_lo := t128_hi + t186_lo
  let c189 := carry t128_hi t186_lo
  let t189_hi := t186_hi ||| c189
  let t242_lo := t189_hi + t239_lo
  let c242 := carry t189_hi t239_lo
  let t242_hi := t239_hi ||| c242
  let t277 := t242_hi + t276
  let p9 := t128_lo.setWidth 128 * 38#128
  let t132_lo := p9.setWidth 64
  let t132_hi := (p9 >>> 64).setWidth 64
  let p11 := t189_lo.setWidth 128 * 38#128
  let t193_lo := p11.setWidth 64
  let t193_hi := (p11 >>> 64).setWidth 64
  let t210_lo := t44_lo + t193_hi
  let t210_hi := carry t44_lo t193_hi
  let p13 := t242_lo.setWidth 128 * 38#128
  let t246_lo := p13.setWidth 64
  let t246_hi := (p13 >>> 64).setWidth 64
  let t263_lo := t84_lo + t246_hi
  let t263_hi := carry t84_lo t246_hi
  let p14 := t277.setWidth 128 * 38#128
  let t278_lo := p14.setWidth 64
  let t278_hi := (p14 >>> 64).setWidth 64
  let t147_lo := t14_lo + t132_hi
  let t147_hi := carry t14_lo t132_hi
  let t213_lo := t147_hi + t210_lo
  let c213 := carry t147_hi t210_lo
  let t213_hi := t210_hi ||| c213
  let t266_lo := t213_hi + t263_lo
  let c266 := carry t213_hi t263_lo
  let t266_hi := t263_hi ||| c266
  let t293 := t266_hi + t278_hi
  let t197_lo := t147_lo + t193_lo
  let t197_hi := carry t147_lo t193_lo
  let t250_lo := t213_lo + t246_lo
  let t250_hi := carry t213_lo t246_lo
  let t282_lo := t266_lo + t278_lo
  let t282_hi := carry t266_lo t278_lo
  let t136_lo := t1_lo + t132_lo
  let t136_hi := carry t1_lo t132_lo
  let t200_lo := t136_hi + t197_lo
  let c200 := carry t136_hi t197_lo
  let t200_hi := t197_hi ||| c200
  let t253_lo := t200_hi + t250_lo
  let c253 := carry t200_hi t250_lo
  let t253_hi := t250_hi ||| c253
  let t285_lo := t253_hi + t282_lo
  let c285 := carry t253_hi t282_lo
  let t285_hi := t282_hi ||| c285
  let t294 := t285_hi + t293
  let t295 := t294 * 2#64
  let t298 := t285_lo >>> 63
  let t299 := t295 + t298
  let t324 := t285_lo &&& 9223372036854775807#64
  let t300 := t299 * 19#64
  let t301_lo := t136_lo + t300
  let t301_hi := carry t136_lo t300
  let t310_lo := t200_lo + t301_hi
  let t310_hi := carry t200_lo t301_hi
  let t319_lo := t253_lo + t310_hi
  let t319_hi := carry t253_lo t310_hi
  let t327 := t324 + t319_hi
  t327 ++ (t319_lo ++ (t310_lo ++ t301_lo))

end

/-! ## Limb reads -/

/-- Limb `k` of the element at `p`, at the pointer `getelementptr` gives it. -/
public theorem readAt_limb {m : MemoryState} {p : Pointer} (hf : Fits m p 256)
    (ho : ¬p.offset.uaddOverflow 32#64) {off : BitVec 64} (hk : off.toNat ≤ 24) :
    m.readAt (p.add off) 64 = (m.readAt p 256).extractLsb' (off.toNat * 8) 64 :=
  MemoryState.readAt_add_of_readAt hf.inBounds
    (BitVec.not_uaddOverflow_of_le ho (by simp; omega)) (by omega) rfl

/-- Limb `0` of the element at `p`. -/
public theorem readAt_limb0 {m : MemoryState} {p : Pointer} :
    m.readAt p 64 = (m.readAt p 256).extractLsb' 0 64 := by
  rw [MemoryState.readAt_of_readAt_le (v := 256) (by decide) rfl]
  simp [BitVec.extractLsb']

/-- The four limb stores at `r`, lowest first, as one 256-bit store. -/
public theorem storeAt_limbs {m : MemoryState} {r : Pointer} (ho : ¬r.offset.uaddOverflow 32#64)
    (a b c d : BitVec 64) :
    (((m.storeAt r a).storeAt (r.add 8#64) b).storeAt (r.add 16#64) c).storeAt (r.add 24#64) d =
      m.storeAt r (d ++ (c ++ (b ++ a))) := by
  rw [MemoryState.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le ho (by decide)) (by decide),
    MemoryState.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le ho (by decide)) (by decide),
    MemoryState.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le ho (by decide)) (by decide)]

/-! ## Flagged operations -/

public theorem umulOverflow_setWidth (a b : BitVec 64) :
    (a.setWidth 128).umulOverflow (b.setWidth 128) = false := by
  bv_decide

public theorem trunc_hi (x : BitVec 128) : ((x >>> 64).setWidth 64).setWidth 128 = x >>> 64 := by
  bv_decide

public theorem umulOverflow_mul38 (a : BitVec 64) :
    (a.setWidth 128).umulOverflow 38#128 = false := by
  bv_decide

public theorem smulOverflow_mul38 (a : BitVec 64) :
    (a.setWidth 128).smulOverflow 38#128 = false := by
  bv_decide

public theorem sext_hi38 (a : BitVec 64) :
    (((a.setWidth 128 * 38#128) >>> 64).setWidth 64).signExtend 128 =
      (a.setWidth 128 * 38#128) >>> 64 := by
  bv_decide

public theorem fshl_one (a b : BitVec 64) :
    ((a ++ b) <<< 1).extractLsb' 64 64 = a * 2#64 + b >>> 63 := by
  bv_decide

public theorem uaddOverflow_false {a b : BitVec 64} (ha : a.toNat ≤ A) (hb : b.toNat ≤ B)
    (h : A + B < 2 ^ 64 := by decide) : a.uaddOverflow b = false := by
  simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le]
  omega

public theorem saddOverflow_false {a b : BitVec 64} (ha : a.toNat ≤ A) (hb : b.toNat ≤ B)
    (h : A + B < 2 ^ 63 := by decide) : a.saddOverflow b = false := by
  have ha' : a.toInt = a.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  have hb' : b.toInt = b.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  simp only [BitVec.saddOverflow, ha', hb', Bool.or_eq_false_iff, decide_eq_false_iff_not]
  omega

public theorem umulOverflow_mul19 {a : BitVec 64} (ha : a.toNat ≤ A)
    (h : A * 19 < 2 ^ 64 := by decide) : a.umulOverflow 19#64 = false := by
  simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, BitVec.toNat_ofNat]
  omega

public theorem smulOverflow_mul19 {a : BitVec 64} (ha : a.toNat ≤ A)
    (h : A * 19 < 2 ^ 63 := by decide) : a.smulOverflow 19#64 = false := by
  have ha' : a.toInt = a.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  simp only [BitVec.smulOverflow, ha', Bool.or_eq_false_iff, decide_eq_false_iff_not]
  simp
  omega

/-! ## Bounds -/

public theorem carry_le {t : BitVec 64} (h : t = (BitVec.ofBool c).setWidth 64) : t.toNat ≤ 1 := by
  subst h; cases c <;> decide

public theorem or_carry_le {t u : BitVec 64} (h : t = u ||| (BitVec.ofBool c).setWidth 64)
    (hu : u.toNat ≤ 1) : t.toNat ≤ 1 := by
  subst h
  have : u = 0#64 ∨ u = 1#64 := by
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp hu with h | h
    · exact .inl (BitVec.eq_of_toNat_eq h)
    · exact .inr (BitVec.eq_of_toNat_eq h)
  rcases this with rfl | rfl <;> cases c <;> decide

public theorem hi_le {t a b : BitVec 64}
    (h : t = ((a.setWidth 128 * b.setWidth 128) >>> 64).setWidth 64) :
    t.toNat ≤ 18446744073709551614 := by
  subst h
  have ha : a.toNat ≤ 2 ^ 64 - 1 := by have := a.isLt; omega
  have hb : b.toNat ≤ 2 ^ 64 - 1 := by have := b.isLt; omega
  have hab : a.toNat * b.toNat ≤ (2 ^ 64 - 1) * (2 ^ 64 - 1) := Nat.mul_le_mul ha hb
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_mul,
    Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (a := a.toNat) (by omega), Nat.mod_eq_of_lt (a := b.toNat) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  have : a.toNat * b.toNat / 2 ^ 64 < 2 ^ 64 - 1 :=
    (Nat.div_lt_iff_lt_mul (by decide)).mpr (by omega)
  omega

public theorem hi38_le {t a : BitVec 64} (h : t = ((a.setWidth 128 * 38#128) >>> 64).setWidth 64) :
    t.toNat ≤ 37 := by
  subst h
  have : ((a.setWidth 128 * 38#128) >>> 64).setWidth 64 ≤ 37#64 := by bv_decide
  exact this

public theorem mask_le {t u : BitVec 64} (h : t = u &&& 9223372036854775807#64) :
    t.toNat ≤ 9223372036854775807 := by
  subst h
  have : u &&& 9223372036854775807#64 ≤ 9223372036854775807#64 := by bv_decide
  exact this

public theorem add_le {t a b : BitVec 64} (h : t = a + b) (ha : a.toNat ≤ A) (hb : b.toNat ≤ B)
    (hAB : A + B < 2 ^ 64 := by decide) : t.toNat ≤ A + B := by
  subst h
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  omega

public theorem dbl_top_le {t a b : BitVec 64} (h : t = a * 2#64 + b >>> 63) (ha : a.toNat ≤ A)
    (hA : 2 * A + 1 < 2 ^ 64 := by decide) : t.toNat ≤ 2 * A + 1 := by
  subst h
  have hb : (b >>> 63).toNat ≤ 1 := by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
    have := b.isLt
    omega
  have h2 : (2#64).toNat = 2 := rfl
  rw [BitVec.toNat_add, BitVec.toNat_mul, h2, Nat.mod_eq_of_lt (a := a.toNat * 2) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  omega

end MLIR.Firedancer.Crc.Ref.Fe64

module

public import MLIR.Run.Tactic
public import Zig.Scalar_toBytes
public import Zig.Mlir.scalar_reduce64
public import Common.Tactics
public import Zig.Steps
import Std.Tactic.BVDecide
import Mathlib.Tactic.ClearExcept
import Mathlib.Tactic.Ring

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- Barrett reduction of 64 bytes: as `Scalar.fromBytes.spec`, the estimate from the top 264 bits. -/
def scalar.reduce64.limbs (b : BitVec 512) : Fin 5 → BitVec 64 :=
  let x := b.setWidth 640
  let k := ((x >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264
  let r := x - k * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640
  Scalar.limbs ((if r < 7237005577332262213973186563042994240857116359379907606001950938285454250989#640 then r else r - 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).setWidth 320)

/-- The 64 bytes `b` reduced mod `ℓ`, as 32 bytes. -/
def scalar.reduce64.spec (b : BitVec 512) : BitVec 256 :=
  Scalar.toBytes.spec (scalar.reduce64.limbs b)

end

/-! ## Proof -/

section Proof

namespace scalar_reduce64

theorem toNat_lit {w C : Nat} (h : C < 2 ^ w) : (BitVec.ofNat w C).toNat = C := by
  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

theorem tel (T0 T1 T2 T3 T4 T5 T6 T7 T8 c1 c2 c3 c4 c5 c6 c7 c8 : Nat)
    (h1 : T1 = c1 + T0 / 2 ^ 56) (h2 : T2 = c2 + T1 / 2 ^ 56) (h3 : T3 = c3 + T2 / 2 ^ 56)
    (h4 : T4 = c4 + T3 / 2 ^ 56) (h5 : T5 = c5 + T4 / 2 ^ 56) (h6 : T6 = c6 + T5 / 2 ^ 56)
    (h7 : T7 = c7 + T6 / 2 ^ 56) (h8 : T8 = c8 + T7 / 2 ^ 56) :
    T0 + c1 * 2 ^ 56 + c2 * 2 ^ 112 + c3 * 2 ^ 168 + c4 * 2 ^ 224 + c5 * 2 ^ 280 + c6 * 2 ^ 336 +
      c7 * 2 ^ 392 + c8 * 2 ^ 448 =
      T0 % 2 ^ 56 + T1 % 2 ^ 56 * 2 ^ 56 + T2 % 2 ^ 56 * 2 ^ 112 + T3 % 2 ^ 56 * 2 ^ 168 +
        2 ^ 224 * (T4 % 2 ^ 56 + T5 % 2 ^ 56 * 2 ^ 56 + T6 % 2 ^ 56 * 2 ^ 112 + T7 % 2 ^ 56 * 2 ^ 168 +
          T8 * 2 ^ 224) := by
  omega

theorem kv (T4 T5 T6 T7 T8 : Nat) (hb : T8 < 2 ^ 96) :
    (T5 % 2 ^ 64 % 2 ^ 40 * 2 ^ 16 + T4 % 2 ^ 64 / 2 ^ 40 % 2 ^ 16) +
      (T6 % 2 ^ 64 % 2 ^ 40 * 2 ^ 16 + T5 % 2 ^ 64 / 2 ^ 40 % 2 ^ 16) * 2 ^ 56 +
      (T7 % 2 ^ 64 % 2 ^ 40 * 2 ^ 16 + T6 % 2 ^ 64 / 2 ^ 40 % 2 ^ 16) * 2 ^ 112 +
      (T8 % 2 ^ 64 % 2 ^ 40 * 2 ^ 16 + T7 % 2 ^ 64 / 2 ^ 40 % 2 ^ 16) * 2 ^ 168 +
      T8 / 2 ^ 40 % 2 ^ 56 * 2 ^ 224 =
      (T4 % 2 ^ 56 + T5 % 2 ^ 56 * 2 ^ 56 + T6 % 2 ^ 56 * 2 ^ 112 + T7 % 2 ^ 56 * 2 ^ 168 +
        T8 * 2 ^ 224) / 2 ^ 40 := by
  omega

theorem mod64_56 (T : Nat) : T % 2 ^ 64 % 2 ^ 56 = T % 2 ^ 56 := by omega

theorem mod64_40 (T : Nat) : T % 2 ^ 64 % 2 ^ 40 = T % 2 ^ 40 := by omega

set_option maxHeartbeats 0 in
theorem tail (t0 t1 t2 t3 r4 m0 m1 m2 m3 m4 : BitVec 64)
    (h0 : t0 < 72057594037927936#64) (h1 : t1 < 72057594037927936#64) (h2 : t2 < 72057594037927936#64)
    (h3 : t3 < 72057594037927936#64) (h4 : r4 < 1099511627776#64)
    (g0 : m0 < 72057594037927936#64) (g1 : m1 < 72057594037927936#64) (g2 : m2 < 72057594037927936#64)
    (g3 : m3 < 72057594037927936#64) (g4 : m4 < 1099511627776#64)
    (x225 : BitVec 64) (h225 : x225 = t0 - m0)
    (x226 : BitVec 64) (h226 : x226 = x225.sshiftRight 63)
    (x227 : BitVec 64) (h227 : x227 = x225 >>> 7)
    (x228 : BitVec 64) (h228 : x228 = x227 &&& 72057594037927936#64)
    (x229 : BitVec 64) (h229 : x229 = x228 + x225)
    (x230 : BitVec 64) (h230 : x230 = x226 + t1)
    (x231 : BitVec 64) (h231 : x231 = x230 - m1)
    (x232 : BitVec 64) (h232 : x232 = x231.sshiftRight 63)
    (x233 : BitVec 64) (h233 : x233 = x231 >>> 7)
    (x234 : BitVec 64) (h234 : x234 = x233 &&& 72057594037927936#64)
    (x235 : BitVec 64) (h235 : x235 = x234 + x231)
    (x236 : BitVec 64) (h236 : x236 = x232 + t2)
    (x237 : BitVec 64) (h237 : x237 = x236 - m2)
    (x238 : BitVec 64) (h238 : x238 = x237.sshiftRight 63)
    (x239 : BitVec 64) (h239 : x239 = x237 >>> 7)
    (x240 : BitVec 64) (h240 : x240 = x239 &&& 72057594037927936#64)
    (x241 : BitVec 64) (h241 : x241 = x240 + x237)
    (x242 : BitVec 64) (h242 : x242 = t3 - m3)
    (x243 : BitVec 64) (h243 : x243 = x242 + x238)
    (x244 : BitVec 64) (h244 : x244 = x243 >>> 63)
    (x245 : BitVec 64) (h245 : x245 = x244 <<< 56)
    (x246 : BitVec 64) (h246 : x246 = x245 + x243)
    (x247 : BitVec 64) (h247 : x247 = x244 + m4)
    (x248 : BitVec 1) (h248 : x248 = BitVec.ofBool (r4.ult x247))
    (x249 : BitVec 64) (h249 : x249 = if x248 = 1#1 then 1099511627776#64 else 0#64)
    (x250 : BitVec 64) (h250 : x250 = x249 ||| r4)
    (x251 : BitVec 64) (h251 : x251 = x250 - x247)
    (x252 : BitVec 64) (h252 : x252 = x229 + 18441568559248845843#64)
    (x253 : BitVec 64) (h253 : x253 = x252 >>> 63)
    (x254 : BitVec 64) (h254 : x254 = x253 <<< 56)
    (x255 : BitVec 64) (h255 : x255 = x254 + x252)
    (x256 : BitVec 64) (h256 : x256 = x253 ||| 70332060721272408#64)
    (x257 : BitVec 64) (h257 : x257 = x235 - x256)
    (x258 : BitVec 64) (h258 : x258 = x257 >>> 63)
    (x259 : BitVec 64) (h259 : x259 = x258 <<< 56)
    (x260 : BitVec 64) (h260 : x260 = x259 + x257)
    (x261 : BitVec 64) (h261 : x261 = x258 ||| 5342#64)
    (x262 : BitVec 64) (h262 : x262 = x241 - x261)
    (x263 : BitVec 64) (h263 : x263 = x262.sshiftRight 63)
    (x264 : BitVec 64) (h264 : x264 = x262 >>> 63)
    (x265 : BitVec 64) (h265 : x265 = x264 <<< 56)
    (x266 : BitVec 64) (h266 : x266 = x265 + x262)
    (x267 : BitVec 64) (h267 : x267 = x246 - x264)
    (x268 : BitVec 64) (h268 : x268 = x267 >>> 63)
    (x269 : BitVec 64) (h269 : x269 = x268 <<< 56)
    (x270 : BitVec 64) (h270 : x270 = x246 + x263)
    (x271 : BitVec 64) (h271 : x271 = x270 + x269)
    (x272 : BitVec 64) (h272 : x272 = x268 ||| 268435456#64)
    (x273 : BitVec 1) (h273 : x273 = BitVec.ofBool (x251.slt x272))
    (x274 : BitVec 64) (h274 : x274 = if x273 = 1#1 then x229 else x255)
    (x275 : BitVec 64) (h275 : x275 = if x273 = 1#1 then x235 else x260)
    (x276 : BitVec 64) (h276 : x276 = if x273 = 1#1 then x241 else x266)
    (x277 : BitVec 64) (h277 : x277 = if x273 = 1#1 then x246 else x271)
    (x278 : BitVec 64) (h278 : x278 = if x273 = 1#1 then 0#64 else x272)
    (x279 : BitVec 64) (h279 : x279 = x251 - x278)
 :
    let s := (Scalar.wide (Fe.mk5 t0 t1 t2 t3 r4) - Scalar.wide (Fe.mk5 m0 m1 m2 m3 m4)) &&&
      (BitVec.allOnes 320 >>> 56)
    Fe.mk5 x274 x275 x276 x277 x279 =
      Scalar.limbs (if s < Scalar.ell320 then s else s - Scalar.ell320) := by
  intro s
  funext i
  fin_cases i <;> simp only [s, Scalar.wide, Scalar.limbs, Scalar.ell320, Fe.mk5] <;> subst_vars <;> bv_decide

theorem qval (X : Nat) (h : X < 2 ^ 512) :
    X / 2 ^ 248 % 2 ^ 56 + X / 2 ^ 304 % 2 ^ 56 * 2 ^ 56 + X / 2 ^ 360 % 2 ^ 56 * 2 ^ 112 +
      X / 2 ^ 416 % 2 ^ 56 * 2 ^ 168 + X / 2 ^ 472 % 2 ^ 40 * 2 ^ 224 = X / 2 ^ 248 := by
  omega

theorem rval (X : Nat) :
    X % 2 ^ 56 + X / 2 ^ 56 % 2 ^ 56 * 2 ^ 56 + X / 2 ^ 112 % 2 ^ 56 * 2 ^ 112 +
      X / 2 ^ 168 % 2 ^ 56 * 2 ^ 168 + X / 2 ^ 224 % 2 ^ 40 * 2 ^ 224 = X % 2 ^ 264 := by
  omega

theorem toNat_extract (B : BitVec 512) (s w : Nat) (hw : w ≤ 64) :
    ((B.extractLsb' s w).setWidth 64).toNat = B.toNat / 2 ^ s % 2 ^ w := by
  rw [BitVec.toNat_setWidth, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  exact Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le (Nat.mod_lt _ (Nat.two_pow_pos w))
    (Nat.pow_le_pow_right (by decide) hw))

theorem barrett64 (X : Nat) (hX : X < 2 ^ 512) :
    X / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 * 7237005577332262213973186563042994240857116359379907606001950938285454250989 ≤ X ∧
      X < (X / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 + 2) * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
  omega

theorem modsub (B P W1 W2 : Nat) (hW1 : W1 = B % 2 ^ 264) (hW2 : W2 = P % 2 ^ 264)
    (h1 : P ≤ B) (h2 : B < P + 2 ^ 264) : (2 ^ 320 - W2 + W1) % 2 ^ 320 % 2 ^ 264 = B - P := by
  omega

theorem tel5 (T0 T1 T2 T3 T4 c1 c2 c3 c4 : Nat) (h1 : T1 = c1 + T0 / 2 ^ 56)
    (h2 : T2 = c2 + T1 / 2 ^ 56) (h3 : T3 = c3 + T2 / 2 ^ 56) (h4 : T4 = c4 + T3 / 2 ^ 56) :
    (T0 + c1 * 2 ^ 56 + c2 * 2 ^ 112 + c3 * 2 ^ 168 + c4 * 2 ^ 224) % 2 ^ 264 =
      T0 % 2 ^ 56 + T1 % 2 ^ 56 * 2 ^ 56 + T2 % 2 ^ 56 * 2 ^ 112 + T3 % 2 ^ 56 * 2 ^ 168 +
        T4 % 2 ^ 40 * 2 ^ 224 := by
  omega

theorem divsplit (a V : Nat) (ha : a < 2 ^ 224) : (a + 2 ^ 224 * V) / 2 ^ 264 = V / 2 ^ 40 := by
  omega

theorem qdivLimb (a b : BitVec 64) :
    (((a <<< 16) &&& 72057594037862400#64) ||| ((b >>> 40) &&& 65535#64)).toNat =
      a.toNat % 2 ^ 40 * 2 ^ 16 + b.toNat / 2 ^ 40 % 2 ^ 16 := by
  have e : ((a <<< 16) &&& 72057594037862400#64) ||| ((b >>> 40) &&& 65535#64) =
      ((a &&& 1099511627775#64) <<< 16) + ((b >>> 40) &&& 65535#64) := by bv_decide
  have h1 : ((a &&& 1099511627775#64) <<< 16).toNat = a.toNat % 2 ^ 40 * 2 ^ 16 := by
    rw [BitVec.toNat_shiftLeft, BitVec.toNat_and, toNat_lit (by decide),
      show 1099511627775 = 2 ^ 40 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod, Nat.shiftLeft_eq]
    have := Nat.mod_lt a.toNat (show 0 < 2 ^ 40 by decide)
    omega
  have h2 : ((b >>> 40) &&& 65535#64).toNat = b.toNat / 2 ^ 40 % 2 ^ 16 := by
    rw [BitVec.toNat_and, toNat_lit (by decide), show 65535 = 2 ^ 16 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  rw [e, BitVec.toNat_add_of_lt (by rw [h1, h2]; omega), h1, h2]

theorem qdivTop (c : BitVec 128) :
    (((c.setWidth 64 >>> 40) &&& 65535#64) ||| ((c >>> 40).setWidth 64 &&& 72057594037862400#64)).toNat =
      c.toNat / 2 ^ 40 % 2 ^ 56 := by
  have e : ((c.setWidth 64 >>> 40) &&& 65535#64) ||| ((c >>> 40).setWidth 64 &&& 72057594037862400#64) =
      (c >>> 40).setWidth 64 &&& 72057594037927935#64 := by bv_decide
  rw [e, BitVec.toNat_and, toNat_lit (by decide), show 72057594037927935 = 2 ^ 56 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow]
  omega

set_option maxHeartbeats 0 in
set_option exponentiation.threshold 700 in
theorem code_eq (B : BitVec 512) (t0 t1 t2 t3 t4 t5 t6 t7 t8 : BitVec 64) (b : BitVec 8)
    (ht0 : t0 = B.extractLsb' 0 64 &&& 72057594037927935#64)
    (ht1 : t1 = B.extractLsb' 56 64 &&& 72057594037927935#64)
    (ht2 : t2 = B.extractLsb' 112 64 &&& 72057594037927935#64)
    (ht3 : t3 = B.extractLsb' 168 64 &&& 72057594037927935#64)
    (ht4 : t4 = B.extractLsb' 224 64 &&& 72057594037927935#64)
    (ht5 : t5 = B.extractLsb' 280 64 &&& 72057594037927935#64)
    (ht6 : t6 = B.extractLsb' 336 64 &&& 72057594037927935#64)
    (ht7 : t7 = B.extractLsb' 392 64 &&& 72057594037927935#64)
    (ht8 : t8 = B.extractLsb' 448 64 &&& 72057594037927935#64)
    (hb : b = B.extractLsb' 504 8)
    (x50 : BitVec 64) (h50 : x50 = b.setWidth 64)
    (x68 : BitVec 64) (h68 : x68 = t5 <<< 32)
    (x69 : BitVec 64) (h69 : x69 = x68 &&& 72057589742960640#64)
    (x70 : BitVec 64) (h70 : x70 = t4 >>> 24)
    (x71 : BitVec 64) (h71 : x71 = x69 ||| x70)
    (x72 : BitVec 64) (h72 : x72 = t6 <<< 32)
    (x73 : BitVec 64) (h73 : x73 = x72 &&& 72057589742960640#64)
    (x74 : BitVec 64) (h74 : x74 = t5 >>> 24)
    (x75 : BitVec 64) (h75 : x75 = x73 ||| x74)
    (x76 : BitVec 64) (h76 : x76 = t7 <<< 32)
    (x77 : BitVec 64) (h77 : x77 = x76 &&& 72057589742960640#64)
    (x78 : BitVec 64) (h78 : x78 = t6 >>> 24)
    (x79 : BitVec 64) (h79 : x79 = x77 ||| x78)
    (x80 : BitVec 64) (h80 : x80 = t8 <<< 32)
    (x81 : BitVec 64) (h81 : x81 = x80 &&& 72057589742960640#64)
    (x82 : BitVec 64) (h82 : x82 = t7 >>> 24)
    (x83 : BitVec 64) (h83 : x83 = x81 ||| x82)
    (x84 : BitVec 64) (h84 : x84 = x50 <<< 32)
    (x85 : BitVec 64) (h85 : x85 = t8 >>> 24)
    (x86 : BitVec 64) (h86 : x86 = x85 ||| x84)
    (x87 : BitVec 128) (h87 : x87 = x71.setWidth 128)
    (x88 : BitVec 128) (h88 : x88 = x87 * 44162584779952923#128)
    (x89 : BitVec 128) (h89 : x89 = x87 * 9390964836247533#128)
    (x90 : BitVec 128) (h90 : x90 = x87 * 72057594036560134#128)
    (x91 : BitVec 128) (h91 : x91 = x87 * 72057594037927935#128)
    (x92 : BitVec 128) (h92 : x92 = x87 * 68719476735#128)
    (x93 : BitVec 128) (h93 : x93 = x75.setWidth 128)
    (x94 : BitVec 128) (h94 : x94 = x93 * 44162584779952923#128)
    (x95 : BitVec 128) (h95 : x95 = x93 * 9390964836247533#128)
    (x96 : BitVec 128) (h96 : x96 = x93 * 72057594036560134#128)
    (x97 : BitVec 128) (h97 : x97 = x93 * 72057594037927935#128)
    (x98 : BitVec 128) (h98 : x98 = x93 * 68719476735#128)
    (x99 : BitVec 128) (h99 : x99 = x79.setWidth 128)
    (x100 : BitVec 128) (h100 : x100 = x99 * 44162584779952923#128)
    (x101 : BitVec 128) (h101 : x101 = x99 * 9390964836247533#128)
    (x102 : BitVec 128) (h102 : x102 = x99 * 72057594036560134#128)
    (x103 : BitVec 128) (h103 : x103 = x99 * 72057594037927935#128)
    (x104 : BitVec 128) (h104 : x104 = x99 * 68719476735#128)
    (x105 : BitVec 128) (h105 : x105 = x83.setWidth 128)
    (x106 : BitVec 128) (h106 : x106 = x105 * 44162584779952923#128)
    (x107 : BitVec 128) (h107 : x107 = x105 * 9390964836247533#128)
    (x108 : BitVec 128) (h108 : x108 = x105 * 72057594036560134#128)
    (x109 : BitVec 128) (h109 : x109 = x105 * 72057594037927935#128)
    (x110 : BitVec 128) (h110 : x110 = x105 * 68719476735#128)
    (x111 : BitVec 128) (h111 : x111 = x86.setWidth 128)
    (x112 : BitVec 128) (h112 : x112 = x111 * 44162584779952923#128)
    (x113 : BitVec 128) (h113 : x113 = x111 * 9390964836247533#128)
    (x114 : BitVec 128) (h114 : x114 = x111 * 72057594036560134#128)
    (x115 : BitVec 128) (h115 : x115 = x111 * 72057594037927935#128)
    (x116 : BitVec 128) (h116 : x116 = x111 * 68719476735#128)
    (x117 : BitVec 128) (h117 : x117 = x94 + x89)
    (x118 : BitVec 128) (h118 : x118 = x95 + x90)
    (x119 : BitVec 128) (h119 : x119 = x118 + x100)
    (x120 : BitVec 128) (h120 : x120 = x96 + x91)
    (x121 : BitVec 128) (h121 : x121 = x120 + x101)
    (x122 : BitVec 128) (h122 : x122 = x121 + x106)
    (x123 : BitVec 128) (h123 : x123 = x97 + x92)
    (x124 : BitVec 128) (h124 : x124 = x123 + x102)
    (x125 : BitVec 128) (h125 : x125 = x103 + x98)
    (x126 : BitVec 128) (h126 : x126 = x110 + x115)
    (x127 : BitVec 128) (h127 : x127 = x88 >>> 56)
    (x128 : BitVec 128) (h128 : x128 = x117 + x127)
    (x129 : BitVec 128) (h129 : x129 = x128 >>> 56)
    (x130 : BitVec 128) (h130 : x130 = x119 + x129)
    (x131 : BitVec 128) (h131 : x131 = x130 >>> 56)
    (x132 : BitVec 128) (h132 : x132 = x122 + x131)
    (x133 : BitVec 128) (h133 : x133 = x132 >>> 56)
    (x134 : BitVec 128) (h134 : x134 = x124 + x112)
    (x135 : BitVec 128) (h135 : x135 = x134 + x107)
    (x136 : BitVec 128) (h136 : x136 = x135 + x133)
    (x137 : BitVec 128) (h137 : x137 = x136 >>> 56)
    (x138 : BitVec 64) (h138 : x138 = x136.setWidth 64)
    (x139 : BitVec 128) (h139 : x139 = x125 + x113)
    (x140 : BitVec 128) (h140 : x140 = x139 + x108)
    (x141 : BitVec 128) (h141 : x141 = x140 + x137)
    (x142 : BitVec 128) (h142 : x142 = x141 >>> 56)
    (x143 : BitVec 64) (h143 : x143 = x141.setWidth 64)
    (x144 : BitVec 128) (h144 : x144 = x114 + x104)
    (x145 : BitVec 128) (h145 : x145 = x144 + x109)
    (x146 : BitVec 128) (h146 : x146 = x145 + x142)
    (x147 : BitVec 128) (h147 : x147 = x146 >>> 56)
    (x148 : BitVec 64) (h148 : x148 = x146.setWidth 64)
    (x149 : BitVec 128) (h149 : x149 = x126 + x147)
    (x150 : BitVec 128) (h150 : x150 = x149 >>> 56)
    (x151 : BitVec 64) (h151 : x151 = x149.setWidth 64)
    (x152 : BitVec 128) (h152 : x152 = x150 + x116)
    (x153 : BitVec 64) (h153 : x153 = x152.setWidth 64)
    (x154 : BitVec 64) (h154 : x154 = x143 <<< 16)
    (x155 : BitVec 64) (h155 : x155 = x154 &&& 72057594037862400#64)
    (x156 : BitVec 64) (h156 : x156 = x138 >>> 40)
    (x157 : BitVec 64) (h157 : x157 = x156 &&& 65535#64)
    (x158 : BitVec 64) (h158 : x158 = x155 ||| x157)
    (x159 : BitVec 64) (h159 : x159 = x148 <<< 16)
    (x160 : BitVec 64) (h160 : x160 = x159 &&& 72057594037862400#64)
    (x161 : BitVec 64) (h161 : x161 = x143 >>> 40)
    (x162 : BitVec 64) (h162 : x162 = x161 &&& 65535#64)
    (x163 : BitVec 64) (h163 : x163 = x160 ||| x162)
    (x164 : BitVec 64) (h164 : x164 = x151 <<< 16)
    (x165 : BitVec 64) (h165 : x165 = x164 &&& 72057594037862400#64)
    (x166 : BitVec 64) (h166 : x166 = x148 >>> 40)
    (x167 : BitVec 64) (h167 : x167 = x166 &&& 65535#64)
    (x168 : BitVec 64) (h168 : x168 = x165 ||| x167)
    (x169 : BitVec 64) (h169 : x169 = x153 <<< 16)
    (x170 : BitVec 64) (h170 : x170 = x169 &&& 72057594037862400#64)
    (x171 : BitVec 64) (h171 : x171 = x151 >>> 40)
    (x172 : BitVec 64) (h172 : x172 = x171 &&& 65535#64)
    (x173 : BitVec 64) (h173 : x173 = x170 ||| x172)
    (x174 : BitVec 128) (h174 : x174 = x152 >>> 40)
    (x175 : BitVec 64) (h175 : x175 = x174.setWidth 64)
    (x176 : BitVec 64) (h176 : x176 = x175 &&& 72057594037862400#64)
    (x177 : BitVec 64) (h177 : x177 = x153 >>> 40)
    (x178 : BitVec 64) (h178 : x178 = x177 &&& 65535#64)
    (x179 : BitVec 64) (h179 : x179 = x178 ||| x176)
    (x180 : BitVec 64) (h180 : x180 = t4 &&& 1099511627775#64)
    (x181 : BitVec 128) (h181 : x181 = x158.setWidth 128)
    (x182 : BitVec 128) (h182 : x182 = x181 * 5175514460705773#128)
    (x183 : BitVec 128) (h183 : x183 = x181 * 70332060721272408#128)
    (x184 : BitVec 128) (h184 : x184 = x181 * 5342#128)
    (x185 : BitVec 128) (h185 : x185 = x181 <<< 28)
    (x186 : BitVec 128) (h186 : x186 = x163.setWidth 128)
    (x187 : BitVec 128) (h187 : x187 = x186 * 5175514460705773#128)
    (x188 : BitVec 128) (h188 : x188 = x186 * 70332060721272408#128)
    (x189 : BitVec 128) (h189 : x189 = x186 * 5342#128)
    (x190 : BitVec 128) (h190 : x190 = x168.setWidth 128)
    (x191 : BitVec 128) (h191 : x191 = x190 * 5175514460705773#128)
    (x192 : BitVec 128) (h192 : x192 = x190 * 70332060721272408#128)
    (x193 : BitVec 128) (h193 : x193 = x190 * 5342#128)
    (x194 : BitVec 128) (h194 : x194 = x173.setWidth 128)
    (x195 : BitVec 128) (h195 : x195 = x194 * 5175514460705773#128)
    (x196 : BitVec 128) (h196 : x196 = x194 * 699938952792#128)
    (x197 : BitVec 128) (h197 : x197 = x179.setWidth 128)
    (x198 : BitVec 128) (h198 : x198 = x197 * 113228764141#128)
    (x199 : BitVec 128) (h199 : x199 = x182 >>> 56)
    (x200 : BitVec 64) (h200 : x200 = x182.setWidth 64)
    (x201 : BitVec 64) (h201 : x201 = x200 &&& 72057594037927935#64)
    (x202 : BitVec 128) (h202 : x202 = x199 + x183)
    (x203 : BitVec 128) (h203 : x203 = x202 + x187)
    (x204 : BitVec 128) (h204 : x204 = x203 >>> 56)
    (x205 : BitVec 64) (h205 : x205 = x203.setWidth 64)
    (x206 : BitVec 64) (h206 : x206 = x205 &&& 72057594037927935#64)
    (x207 : BitVec 128) (h207 : x207 = x188 + x184)
    (x208 : BitVec 128) (h208 : x208 = x207 + x191)
    (x209 : BitVec 128) (h209 : x209 = x208 + x204)
    (x210 : BitVec 128) (h210 : x210 = x209 >>> 56)
    (x211 : BitVec 64) (h211 : x211 = x209.setWidth 64)
    (x212 : BitVec 64) (h212 : x212 = x211 &&& 72057594037927935#64)
    (x213 : BitVec 128) (h213 : x213 = x192 + x189)
    (x214 : BitVec 128) (h214 : x214 = x213 + x195)
    (x215 : BitVec 128) (h215 : x215 = x214 + x210)
    (x216 : BitVec 128) (h216 : x216 = x215 >>> 56)
    (x217 : BitVec 64) (h217 : x217 = x215.setWidth 64)
    (x218 : BitVec 64) (h218 : x218 = x217 &&& 72057594037927935#64)
    (x219 : BitVec 128) (h219 : x219 = x193 + x185)
    (x220 : BitVec 128) (h220 : x220 = x219 + x196)
    (x221 : BitVec 128) (h221 : x221 = x220 + x198)
    (x222 : BitVec 128) (h222 : x222 = x221 + x216)
    (x223 : BitVec 64) (h223 : x223 = x222.setWidth 64)
    (x224 : BitVec 64) (h224 : x224 = x223 &&& 1099511627775#64)
    (x225 : BitVec 64) (h225 : x225 = t0 - x201)
    (x226 : BitVec 64) (h226 : x226 = x225.sshiftRight 63)
    (x227 : BitVec 64) (h227 : x227 = x225 >>> 7)
    (x228 : BitVec 64) (h228 : x228 = x227 &&& 72057594037927936#64)
    (x229 : BitVec 64) (h229 : x229 = x228 + x225)
    (x230 : BitVec 64) (h230 : x230 = x226 + t1)
    (x231 : BitVec 64) (h231 : x231 = x230 - x206)
    (x232 : BitVec 64) (h232 : x232 = x231.sshiftRight 63)
    (x233 : BitVec 64) (h233 : x233 = x231 >>> 7)
    (x234 : BitVec 64) (h234 : x234 = x233 &&& 72057594037927936#64)
    (x235 : BitVec 64) (h235 : x235 = x234 + x231)
    (x236 : BitVec 64) (h236 : x236 = x232 + t2)
    (x237 : BitVec 64) (h237 : x237 = x236 - x212)
    (x238 : BitVec 64) (h238 : x238 = x237.sshiftRight 63)
    (x239 : BitVec 64) (h239 : x239 = x237 >>> 7)
    (x240 : BitVec 64) (h240 : x240 = x239 &&& 72057594037927936#64)
    (x241 : BitVec 64) (h241 : x241 = x240 + x237)
    (x242 : BitVec 64) (h242 : x242 = t3 - x218)
    (x243 : BitVec 64) (h243 : x243 = x242 + x238)
    (x244 : BitVec 64) (h244 : x244 = x243 >>> 63)
    (x245 : BitVec 64) (h245 : x245 = x244 <<< 56)
    (x246 : BitVec 64) (h246 : x246 = x245 + x243)
    (x247 : BitVec 64) (h247 : x247 = x244 + x224)
    (x248 : BitVec 1) (h248 : x248 = BitVec.ofBool (x180.ult x247))
    (x249 : BitVec 64) (h249 : x249 = if x248 = 1#1 then 1099511627776#64 else 0#64)
    (x250 : BitVec 64) (h250 : x250 = x249 ||| x180)
    (x251 : BitVec 64) (h251 : x251 = x250 - x247)
    (x252 : BitVec 64) (h252 : x252 = x229 + 18441568559248845843#64)
    (x253 : BitVec 64) (h253 : x253 = x252 >>> 63)
    (x254 : BitVec 64) (h254 : x254 = x253 <<< 56)
    (x255 : BitVec 64) (h255 : x255 = x254 + x252)
    (x256 : BitVec 64) (h256 : x256 = x253 ||| 70332060721272408#64)
    (x257 : BitVec 64) (h257 : x257 = x235 - x256)
    (x258 : BitVec 64) (h258 : x258 = x257 >>> 63)
    (x259 : BitVec 64) (h259 : x259 = x258 <<< 56)
    (x260 : BitVec 64) (h260 : x260 = x259 + x257)
    (x261 : BitVec 64) (h261 : x261 = x258 ||| 5342#64)
    (x262 : BitVec 64) (h262 : x262 = x241 - x261)
    (x263 : BitVec 64) (h263 : x263 = x262.sshiftRight 63)
    (x264 : BitVec 64) (h264 : x264 = x262 >>> 63)
    (x265 : BitVec 64) (h265 : x265 = x264 <<< 56)
    (x266 : BitVec 64) (h266 : x266 = x265 + x262)
    (x267 : BitVec 64) (h267 : x267 = x246 - x264)
    (x268 : BitVec 64) (h268 : x268 = x267 >>> 63)
    (x269 : BitVec 64) (h269 : x269 = x268 <<< 56)
    (x270 : BitVec 64) (h270 : x270 = x246 + x263)
    (x271 : BitVec 64) (h271 : x271 = x270 + x269)
    (x272 : BitVec 64) (h272 : x272 = x268 ||| 268435456#64)
    (x273 : BitVec 1) (h273 : x273 = BitVec.ofBool (x251.slt x272))
    (x274 : BitVec 64) (h274 : x274 = if x273 = 1#1 then x229 else x255)
    (x275 : BitVec 64) (h275 : x275 = if x273 = 1#1 then x235 else x260)
    (x276 : BitVec 64) (h276 : x276 = if x273 = 1#1 then x241 else x266)
    (x277 : BitVec 64) (h277 : x277 = if x273 = 1#1 then x246 else x271)
    (x278 : BitVec 64) (h278 : x278 = if x273 = 1#1 then 0#64 else x272)
    (x279 : BitVec 64) (h279 : x279 = x251 - x278)
 :
    Fe.mk5 x274 x275 x276 x277 x279 = scalar.reduce64.limbs B := by
  have q0 : x71 < 72057594037927936#64 := by clear * - h68 h69 h70 h71; bv_decide
  have q1 : x75 < 72057594037927936#64 := by clear * - h72 h73 h74 h75; bv_decide
  have q2 : x79 < 72057594037927936#64 := by clear * - h76 h77 h78 h79; bv_decide
  have q3 : x83 < 72057594037927936#64 := by clear * - h80 h81 h82 h83; bv_decide
  have q4 : x86 < 1099511627776#64 := by clear * - ht8 hb h50 h84 h85 h86; bv_decide
  have b71 : x71.toNat < 2 ^ 56 := q0
  have b75 : x75.toNat < 2 ^ 56 := q1
  have b79 : x79.toNat < 2 ^ 56 := q2
  have b83 : x83.toNat < 2 ^ 56 := q3
  have b86 : x86.toNat < 2 ^ 40 := q4
  clear q0 q1 q2 q3 q4
  have n87 : x87.toNat = x71.toNat := by rw [h87, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b71; omega)
  have b87 : x87.toNat < 72057594037927936 := by clear * - n87 b71; omega
  have n88 : x88.toNat = x87.toNat * 44162584779952923 := by rw [h88, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b87; omega), toNat_lit (by decide)]
  have b88 : x88.toNat < 3182249605739422709613305766604006 := by clear * - n88 b87; omega
  have n89 : x89.toNat = x87.toNat * 9390964836247533 := by rw [h89, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b87; omega), toNat_lit (by decide)]
  have b89 : x89.toNat < 676690331794781120312084075534356 := by clear * - n89 b87; omega
  have n90 : x90.toNat = x87.toNat * 72057594036560134 := by rw [h90, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b87; omega), toNat_lit (by decide)]
  have b90 : x90.toNat < 5192296858436267035232636385943291 := by clear * - n90 b87; omega
  have n91 : x91.toNat = x87.toNat * 72057594037927935 := by rw [h91, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b87; omega), toNat_lit (by decide)]
  have b91 : x91.toNat < 5192296858534827484415308253364226 := by clear * - n91 b87; omega
  have n92 : x92.toNat = x87.toNat * 68719476735 := by rw [h92, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b87; omega), toNat_lit (by decide)]
  have b92 : x92.toNat < 4951760157069463436839092226 := by clear * - n92 b87; omega
  have n93 : x93.toNat = x75.toNat := by rw [h93, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b75; omega)
  have b93 : x93.toNat < 72057594037927936 := by clear * - n93 b75; omega
  have n94 : x94.toNat = x93.toNat * 44162584779952923 := by rw [h94, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b93; omega), toNat_lit (by decide)]
  have b94 : x94.toNat < 3182249605739422709613305766604006 := by clear * - n94 b93; omega
  have n95 : x95.toNat = x93.toNat * 9390964836247533 := by rw [h95, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b93; omega), toNat_lit (by decide)]
  have b95 : x95.toNat < 676690331794781120312084075534356 := by clear * - n95 b93; omega
  have n96 : x96.toNat = x93.toNat * 72057594036560134 := by rw [h96, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b93; omega), toNat_lit (by decide)]
  have b96 : x96.toNat < 5192296858436267035232636385943291 := by clear * - n96 b93; omega
  have n97 : x97.toNat = x93.toNat * 72057594037927935 := by rw [h97, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b93; omega), toNat_lit (by decide)]
  have b97 : x97.toNat < 5192296858534827484415308253364226 := by clear * - n97 b93; omega
  have n98 : x98.toNat = x93.toNat * 68719476735 := by rw [h98, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b93; omega), toNat_lit (by decide)]
  have b98 : x98.toNat < 4951760157069463436839092226 := by clear * - n98 b93; omega
  have n99 : x99.toNat = x79.toNat := by rw [h99, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b79; omega)
  have b99 : x99.toNat < 72057594037927936 := by clear * - n99 b79; omega
  have n100 : x100.toNat = x99.toNat * 44162584779952923 := by rw [h100, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b99; omega), toNat_lit (by decide)]
  have b100 : x100.toNat < 3182249605739422709613305766604006 := by clear * - n100 b99; omega
  have n101 : x101.toNat = x99.toNat * 9390964836247533 := by rw [h101, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b99; omega), toNat_lit (by decide)]
  have b101 : x101.toNat < 676690331794781120312084075534356 := by clear * - n101 b99; omega
  have n102 : x102.toNat = x99.toNat * 72057594036560134 := by rw [h102, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b99; omega), toNat_lit (by decide)]
  have b102 : x102.toNat < 5192296858436267035232636385943291 := by clear * - n102 b99; omega
  have n103 : x103.toNat = x99.toNat * 72057594037927935 := by rw [h103, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b99; omega), toNat_lit (by decide)]
  have b103 : x103.toNat < 5192296858534827484415308253364226 := by clear * - n103 b99; omega
  have n104 : x104.toNat = x99.toNat * 68719476735 := by rw [h104, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b99; omega), toNat_lit (by decide)]
  have b104 : x104.toNat < 4951760157069463436839092226 := by clear * - n104 b99; omega
  have n105 : x105.toNat = x83.toNat := by rw [h105, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b83; omega)
  have b105 : x105.toNat < 72057594037927936 := by clear * - n105 b83; omega
  have n106 : x106.toNat = x105.toNat * 44162584779952923 := by rw [h106, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b105; omega), toNat_lit (by decide)]
  have b106 : x106.toNat < 3182249605739422709613305766604006 := by clear * - n106 b105; omega
  have n107 : x107.toNat = x105.toNat * 9390964836247533 := by rw [h107, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b105; omega), toNat_lit (by decide)]
  have b107 : x107.toNat < 676690331794781120312084075534356 := by clear * - n107 b105; omega
  have n108 : x108.toNat = x105.toNat * 72057594036560134 := by rw [h108, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b105; omega), toNat_lit (by decide)]
  have b108 : x108.toNat < 5192296858436267035232636385943291 := by clear * - n108 b105; omega
  have n109 : x109.toNat = x105.toNat * 72057594037927935 := by rw [h109, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b105; omega), toNat_lit (by decide)]
  have b109 : x109.toNat < 5192296858534827484415308253364226 := by clear * - n109 b105; omega
  have n110 : x110.toNat = x105.toNat * 68719476735 := by rw [h110, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b105; omega), toNat_lit (by decide)]
  have b110 : x110.toNat < 4951760157069463436839092226 := by clear * - n110 b105; omega
  have n111 : x111.toNat = x86.toNat := by rw [h111, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b86; omega)
  have b111 : x111.toNat < 1099511627776 := by clear * - n111 b86; omega
  have n112 : x112.toNat = x111.toNat * 44162584779952923 := by rw [h112, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b111; omega), toNat_lit (by decide)]
  have b112 : x112.toNat < 48557275478157478555599236326 := by clear * - n112 b111; omega
  have n113 : x113.toNat = x111.toNat * 9390964836247533 := by rw [h113, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b111; omega), toNat_lit (by decide)]
  have b113 : x113.toNat < 10325475033480311331658029076 := by clear * - n113 b111; omega
  have n114 : x114.toNat = x111.toNat * 72057594036560134 := by rw [h114, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b111; omega), toNat_lit (by decide)]
  have b114 : x114.toNat < 79228162512688365796012121851 := by clear * - n114 b111; omega
  have n115 : x115.toNat = x111.toNat * 72057594037927935 := by rw [h115, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b111; omega), toNat_lit (by decide)]
  have b115 : x115.toNat < 79228162514192278899994394626 := by clear * - n115 b111; omega
  have n116 : x116.toNat = x111.toNat * 68719476735 := by rw [h116, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b111; omega), toNat_lit (by decide)]
  have b116 : x116.toNat < 75557863724746092314626 := by clear * - n116 b111; omega
  have n117 : x117.toNat = x94.toNat + x89.toNat := by rw [h117, BitVec.toNat_add_of_lt (by clear * - b94 b89; omega)]
  have b117 : x117.toNat < 3858939937534203829925389842138361 := by clear * - n117 b94 b89; omega
  have n118 : x118.toNat = x95.toNat + x90.toNat := by rw [h118, BitVec.toNat_add_of_lt (by clear * - b95 b90; omega)]
  have b118 : x118.toNat < 5868987190231048155544720461477646 := by clear * - n118 b95 b90; omega
  have n119 : x119.toNat = x118.toNat + x100.toNat := by rw [h119, BitVec.toNat_add_of_lt (by clear * - b118 b100; omega)]
  have b119 : x119.toNat < 9051236795970470865158026228081651 := by clear * - n119 b118 b100; omega
  have n120 : x120.toNat = x96.toNat + x91.toNat := by rw [h120, BitVec.toNat_add_of_lt (by clear * - b96 b91; omega)]
  have b120 : x120.toNat < 10384593716971094519647944639307516 := by clear * - n120 b96 b91; omega
  have n121 : x121.toNat = x120.toNat + x101.toNat := by rw [h121, BitVec.toNat_add_of_lt (by clear * - b120 b101; omega)]
  have b121 : x121.toNat < 11061284048765875639960028714841871 := by clear * - n121 b120 b101; omega
  have n122 : x122.toNat = x121.toNat + x106.toNat := by rw [h122, BitVec.toNat_add_of_lt (by clear * - b121 b106; omega)]
  have b122 : x122.toNat < 14243533654505298349573334481445876 := by clear * - n122 b121 b106; omega
  have n123 : x123.toNat = x97.toNat + x92.toNat := by rw [h123, BitVec.toNat_add_of_lt (by clear * - b97 b92; omega)]
  have b123 : x123.toNat < 5192301810294984553878745092456451 := by clear * - n123 b97 b92; omega
  have n124 : x124.toNat = x123.toNat + x102.toNat := by rw [h124, BitVec.toNat_add_of_lt (by clear * - b123 b102; omega)]
  have b124 : x124.toNat < 10384598668731251589111381478399741 := by clear * - n124 b123 b102; omega
  have n125 : x125.toNat = x103.toNat + x98.toNat := by rw [h125, BitVec.toNat_add_of_lt (by clear * - b103 b98; omega)]
  have b125 : x125.toNat < 5192301810294984553878745092456451 := by clear * - n125 b103 b98; omega
  have n126 : x126.toNat = x110.toNat + x115.toNat := by rw [h126, BitVec.toNat_add_of_lt (by clear * - b110 b115; omega)]
  have b126 : x126.toNat < 84179922671261742336833486851 := by clear * - n126 b110 b115; omega
  have n127 : x127.toNat = x88.toNat / 2 ^ 56 := by rw [h127, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b127 : x127.toNat < 44162584779952923 := by clear * - n127 b88; omega
  have n128 : x128.toNat = x117.toNat + x127.toNat := by rw [h128, BitVec.toNat_add_of_lt (by clear * - b117 b127; omega)]
  have b128 : x128.toNat < 3858939937534203874087974622091283 := by clear * - n128 b117 b127; omega
  have n129 : x129.toNat = x128.toNat / 2 ^ 56 := by rw [h129, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b129 : x129.toNat < 53553549616200456 := by clear * - n129 b128; omega
  have n130 : x130.toNat = x119.toNat + x129.toNat := by rw [h130, BitVec.toNat_add_of_lt (by clear * - b119 b129; omega)]
  have b130 : x130.toNat < 9051236795970470918711575844282106 := by clear * - n130 b119 b129; omega
  have n131 : x131.toNat = x130.toNat / 2 ^ 56 := by rw [h131, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b131 : x131.toNat < 125611143652760590 := by clear * - n131 b130; omega
  have n132 : x132.toNat = x122.toNat + x131.toNat := by rw [h132, BitVec.toNat_add_of_lt (by clear * - b122 b131; omega)]
  have b132 : x132.toNat < 14243533654505298475184478134206465 := by clear * - n132 b122 b131; omega
  have n133 : x133.toNat = x132.toNat / 2 ^ 56 := by rw [h133, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b133 : x133.toNat < 197668737690688525 := by clear * - n133 b132; omega
  have n134 : x134.toNat = x124.toNat + x112.toNat := by rw [h134, BitVec.toNat_add_of_lt (by clear * - b124 b112; omega)]
  have b134 : x134.toNat < 10384647226006729746589937077636066 := by clear * - n134 b124 b112; omega
  have n135 : x135.toNat = x134.toNat + x107.toNat := by rw [h135, BitVec.toNat_add_of_lt (by clear * - b134 b107; omega)]
  have b135 : x135.toNat < 11061337557801510866902021153170421 := by clear * - n135 b134 b107; omega
  have n136 : x136.toNat = x135.toNat + x133.toNat := by rw [h136, BitVec.toNat_add_of_lt (by clear * - b135 b133; omega)]
  have b136 : x136.toNat < 11061337557801511064570758843858945 := by clear * - n136 b135 b133; omega
  have n137 : x137.toNat = x136.toNat / 2 ^ 56 := by rw [h137, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b137 : x137.toNat < 153506895497777950 := by clear * - n137 b136; omega
  have n138 : x138.toNat = x136.toNat % 2 ^ 64 := by rw [h138, BitVec.toNat_setWidth]
  have b138 : x138.toNat < 18446744073709551616 := by clear * - n138 b136; omega
  have n139 : x139.toNat = x125.toNat + x113.toNat := by rw [h139, BitVec.toNat_add_of_lt (by clear * - b125 b113; omega)]
  have b139 : x139.toNat < 5192312135770018034190076750485526 := by clear * - n139 b125 b113; omega
  have n140 : x140.toNat = x139.toNat + x108.toNat := by rw [h140, BitVec.toNat_add_of_lt (by clear * - b139 b108; omega)]
  have b140 : x140.toNat < 10384608994206285069422713136428816 := by clear * - n140 b139 b108; omega
  have n141 : x141.toNat = x140.toNat + x137.toNat := by rw [h141, BitVec.toNat_add_of_lt (by clear * - b140 b137; omega)]
  have b141 : x141.toNat < 10384608994206285222929608634206765 := by clear * - n141 b140 b137; omega
  have n142 : x142.toNat = x141.toNat / 2 ^ 56 := by rw [h142, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b142 : x142.toNat < 144115400088716334 := by clear * - n142 b141; omega
  have n143 : x143.toNat = x141.toNat % 2 ^ 64 := by rw [h143, BitVec.toNat_setWidth]
  have b143 : x143.toNat < 18446744073709551616 := by clear * - n143 b141; omega
  have n144 : x144.toNat = x114.toNat + x104.toNat := by rw [h144, BitVec.toNat_add_of_lt (by clear * - b114 b104; omega)]
  have b144 : x144.toNat < 84179922669757829232851214076 := by clear * - n144 b114 b104; omega
  have n145 : x145.toNat = x144.toNat + x109.toNat := by rw [h145, BitVec.toNat_add_of_lt (by clear * - b144 b109; omega)]
  have b145 : x145.toNat < 5192381038457497242244541104578301 := by clear * - n145 b144 b109; omega
  have n146 : x146.toNat = x145.toNat + x142.toNat := by rw [h146, BitVec.toNat_add_of_lt (by clear * - b145 b142; omega)]
  have b146 : x146.toNat < 5192381038457497386359941193294634 := by clear * - n146 b145 b142; omega
  have n147 : x147.toNat = x146.toNat / 2 ^ 56 := by rw [h147, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b147 : x147.toNat < 72058762269032426 := by clear * - n147 b146; omega
  have n148 : x148.toNat = x146.toNat % 2 ^ 64 := by rw [h148, BitVec.toNat_setWidth]
  have b148 : x148.toNat < 18446744073709551616 := by clear * - n148 b146; omega
  have n149 : x149.toNat = x126.toNat + x147.toNat := by rw [h149, BitVec.toNat_add_of_lt (by clear * - b126 b147; omega)]
  have b149 : x149.toNat < 84179922671333801099102519276 := by clear * - n149 b126 b147; omega
  have n150 : x150.toNat = x149.toNat / 2 ^ 56 := by rw [h150, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b150 : x150.toNat < 1168231104511 := by clear * - n150 b149; omega
  have n151 : x151.toNat = x149.toNat % 2 ^ 64 := by rw [h151, BitVec.toNat_setWidth]
  have b151 : x151.toNat < 18446744073709551616 := by clear * - n151 b149; omega
  have n152 : x152.toNat = x150.toNat + x116.toNat := by rw [h152, BitVec.toNat_add_of_lt (by clear * - b150 b116; omega)]
  have b152 : x152.toNat < 75557863725914323419136 := by clear * - n152 b150 b116; omega
  have n153 : x153.toNat = x152.toNat % 2 ^ 64 := by rw [h153, BitVec.toNat_setWidth]
  have b153 : x153.toNat < 18446744073709551616 := by clear * - n153 b152; omega
  have n158 : x158.toNat = x143.toNat % 2 ^ 40 * 2 ^ 16 + x138.toNat / 2 ^ 40 % 2 ^ 16 := by
    rw [h158, h155, h154, h157, h156]; exact qdivLimb _ _
  have n163 : x163.toNat = x148.toNat % 2 ^ 40 * 2 ^ 16 + x143.toNat / 2 ^ 40 % 2 ^ 16 := by
    rw [h163, h160, h159, h162, h161]; exact qdivLimb _ _
  have n168 : x168.toNat = x151.toNat % 2 ^ 40 * 2 ^ 16 + x148.toNat / 2 ^ 40 % 2 ^ 16 := by
    rw [h168, h165, h164, h167, h166]; exact qdivLimb _ _
  have n173 : x173.toNat = x153.toNat % 2 ^ 40 * 2 ^ 16 + x151.toNat / 2 ^ 40 % 2 ^ 16 := by
    rw [h173, h170, h169, h172, h171]; exact qdivLimb _ _
  have n179 : x179.toNat = x152.toNat / 2 ^ 40 % 2 ^ 56 := by
    rw [h179, h178, h177, h176, h175, h174, h153]; exact qdivTop _
  have hTel := tel x88.toNat x128.toNat x130.toNat x132.toNat x136.toNat x141.toNat x146.toNat
    x149.toNat x152.toNat x117.toNat x119.toNat x122.toNat x135.toNat x140.toNat x145.toNat
    x126.toNat x116.toNat (by rw [n128, n127]) (by rw [n130, n129]) (by rw [n132, n131])
    (by rw [n136, n133]) (by rw [n141, n137]) (by rw [n146, n142]) (by rw [n149, n147])
    (by rw [n152, n150, Nat.add_comm])
  have hKV := kv x136.toNat x141.toNat x146.toNat x149.toNat x152.toNat (by clear * - b152; omega)
  rw [← n138, ← n143, ← n148, ← n151, ← n153, ← n158, ← n163, ← n168, ← n173, ← n179] at hKV
  have hQ : (x71.toNat + x75.toNat * 2 ^ 56 + x79.toNat * 2 ^ 112 + x83.toNat * 2 ^ 168 +
      x86.toNat * 2 ^ 224) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 = x88.toNat + x117.toNat * 2 ^ 56 + x119.toNat * 2 ^ 112 +
      x122.toNat * 2 ^ 168 + x135.toNat * 2 ^ 224 + x140.toNat * 2 ^ 280 + x145.toNat * 2 ^ 336 +
      x126.toNat * 2 ^ 392 + x116.toNat * 2 ^ 448 := by
    simp only [n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n134, n135, n139, n140,
      n144, n145, n88, n89, n90, n91, n92, n94, n95, n96, n97, n98, n100, n101, n102, n103, n104,
      n106, n107, n108, n109, n110, n112, n113, n114, n115, n116, n87, n93, n99, n105, n111]
    ring
  have hK : x158.toNat + x163.toNat * 2 ^ 56 + x168.toNat * 2 ^ 112 + x173.toNat * 2 ^ 168 +
      x179.toNat * 2 ^ 224 = (x71.toNat + x75.toNat * 2 ^ 56 + x79.toNat * 2 ^ 112 +
        x83.toNat * 2 ^ 168 + x86.toNat * 2 ^ 224) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 := by
    rw [hQ, hTel, divsplit _ _ (by clear * -; omega), hKV]
  clear hTel hKV hQ
  have b158 : x158.toNat < 2 ^ 56 := by rw [n158]; clear * -; omega
  have b163 : x163.toNat < 2 ^ 56 := by rw [n163]; clear * -; omega
  have b168 : x168.toNat < 2 ^ 56 := by rw [n168]; clear * -; omega
  have b173 : x173.toNat < 2 ^ 56 := by rw [n173]; clear * -; omega
  have b179 : x179.toNat < 2 ^ 56 := by rw [n179]; clear * -; omega
  have n181 : x181.toNat = x158.toNat := by rw [h181, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b158; omega)
  have b181 : x181.toNat < 72057594037927936 := by clear * - n181 b158; omega
  have n182 : x182.toNat = x181.toNat * 5175514460705773 := by rw [h182, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b181; omega), toNat_lit (by decide)]
  have b182 : x182.toNat < 372935119946962120347370612468756 := by clear * - n182 b181; omega
  have n183 : x183.toNat = x181.toNat * 70332060721272408 := by rw [h183, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b181; omega), toNat_lit (by decide)]
  have b183 : x183.toNat < 5067959079304344166518825007917481 := by clear * - n183 b181; omega
  have n184 : x184.toNat = x181.toNat * 5342 := by rw [h184, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b181; omega), toNat_lit (by decide)]
  have b184 : x184.toNat < 384931667350611028771 := by clear * - n184 b181; omega
  have n185 : x185.toNat = x181.toNat * 268435456 := by rw [h185, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]; clear * - b181; omega
  have b185 : x185.toNat < 19342813113834066526863361 := by clear * - n185 b181; omega
  have n186 : x186.toNat = x163.toNat := by rw [h186, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b163; omega)
  have b186 : x186.toNat < 72057594037927936 := by clear * - n186 b163; omega
  have n187 : x187.toNat = x186.toNat * 5175514460705773 := by rw [h187, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b186; omega), toNat_lit (by decide)]
  have b187 : x187.toNat < 372935119946962120347370612468756 := by clear * - n187 b186; omega
  have n188 : x188.toNat = x186.toNat * 70332060721272408 := by rw [h188, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b186; omega), toNat_lit (by decide)]
  have b188 : x188.toNat < 5067959079304344166518825007917481 := by clear * - n188 b186; omega
  have n189 : x189.toNat = x186.toNat * 5342 := by rw [h189, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b186; omega), toNat_lit (by decide)]
  have b189 : x189.toNat < 384931667350611028771 := by clear * - n189 b186; omega
  have n190 : x190.toNat = x168.toNat := by rw [h190, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b168; omega)
  have b190 : x190.toNat < 72057594037927936 := by clear * - n190 b168; omega
  have n191 : x191.toNat = x190.toNat * 5175514460705773 := by rw [h191, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b190; omega), toNat_lit (by decide)]
  have b191 : x191.toNat < 372935119946962120347370612468756 := by clear * - n191 b190; omega
  have n192 : x192.toNat = x190.toNat * 70332060721272408 := by rw [h192, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b190; omega), toNat_lit (by decide)]
  have b192 : x192.toNat < 5067959079304344166518825007917481 := by clear * - n192 b190; omega
  have n193 : x193.toNat = x190.toNat * 5342 := by rw [h193, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b190; omega), toNat_lit (by decide)]
  have b193 : x193.toNat < 384931667350611028771 := by clear * - n193 b190; omega
  have n194 : x194.toNat = x173.toNat := by rw [h194, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b173; omega)
  have b194 : x194.toNat < 72057594037927936 := by clear * - n194 b173; omega
  have n195 : x195.toNat = x194.toNat * 5175514460705773 := by rw [h195, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b194; omega), toNat_lit (by decide)]
  have b195 : x195.toNat < 372935119946962120347370612468756 := by clear * - n195 b194; omega
  have n196 : x196.toNat = x194.toNat * 699938952792 := by rw [h196, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b194; omega), toNat_lit (by decide)]
  have b196 : x196.toNat < 50435916911618341553463044521 := by clear * - n196 b194; omega
  have n197 : x197.toNat = x179.toNat := by rw [h197, BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by clear * - b179; omega)
  have b197 : x197.toNat < 72057594037927936 := by clear * - n197 b179; omega
  have n198 : x198.toNat = x197.toNat * 113228764141 := by rw [h198, BitVec.toNat_mul_of_lt (by rw [toNat_lit (by decide)]; clear * - b197; omega), toNat_lit (by decide)]
  have b198 : x198.toNat < 8158992319888469960470178836 := by clear * - n198 b197; omega
  have n199 : x199.toNat = x182.toNat / 2 ^ 56 := by rw [h199, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b199 : x199.toNat < 5175514460705773 := by clear * - n199 b182; omega
  have n200 : x200.toNat = x182.toNat % 2 ^ 64 := by rw [h200, BitVec.toNat_setWidth]
  have b200 : x200.toNat < 18446744073709551616 := by clear * - n200 b182; omega
  have n201 : x201.toNat = x200.toNat % 2 ^ 56 := by rw [h201, BitVec.toNat_and, show (72057594037927935#64 : BitVec 64).toNat = 2 ^ 56 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have b201 : x201.toNat < 72057594037927936 := by clear * - n201 b200; omega
  have n202 : x202.toNat = x199.toNat + x183.toNat := by rw [h202, BitVec.toNat_add_of_lt (by clear * - b199 b183; omega)]
  have b202 : x202.toNat < 5067959079304344171694339468623253 := by clear * - n202 b199 b183; omega
  have n203 : x203.toNat = x202.toNat + x187.toNat := by rw [h203, BitVec.toNat_add_of_lt (by clear * - b202 b187; omega)]
  have b203 : x203.toNat < 5440894199251306292041710081092008 := by clear * - n203 b202 b187; omega
  have n204 : x204.toNat = x203.toNat / 2 ^ 56 := by rw [h204, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b204 : x204.toNat < 75507575181978181 := by clear * - n204 b203; omega
  have n205 : x205.toNat = x203.toNat % 2 ^ 64 := by rw [h205, BitVec.toNat_setWidth]
  have b205 : x205.toNat < 18446744073709551616 := by clear * - n205 b203; omega
  have n206 : x206.toNat = x205.toNat % 2 ^ 56 := by rw [h206, BitVec.toNat_and, show (72057594037927935#64 : BitVec 64).toNat = 2 ^ 56 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have b206 : x206.toNat < 72057594037927936 := by clear * - n206 b205; omega
  have n207 : x207.toNat = x188.toNat + x184.toNat := by rw [h207, BitVec.toNat_add_of_lt (by clear * - b188 b184; omega)]
  have b207 : x207.toNat < 5067959079304729098186175618946251 := by clear * - n207 b188 b184; omega
  have n208 : x208.toNat = x207.toNat + x191.toNat := by rw [h208, BitVec.toNat_add_of_lt (by clear * - b207 b191; omega)]
  have b208 : x208.toNat < 5440894199251691218533546231415006 := by clear * - n208 b207 b191; omega
  have n209 : x209.toNat = x208.toNat + x204.toNat := by rw [h209, BitVec.toNat_add_of_lt (by clear * - b208 b204; omega)]
  have b209 : x209.toNat < 5440894199251691294041121413393186 := by clear * - n209 b208 b204; omega
  have n210 : x210.toNat = x209.toNat / 2 ^ 56 := by rw [h210, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b210 : x210.toNat < 75507575181983523 := by clear * - n210 b209; omega
  have n211 : x211.toNat = x209.toNat % 2 ^ 64 := by rw [h211, BitVec.toNat_setWidth]
  have b211 : x211.toNat < 18446744073709551616 := by clear * - n211 b209; omega
  have n212 : x212.toNat = x211.toNat % 2 ^ 56 := by rw [h212, BitVec.toNat_and, show (72057594037927935#64 : BitVec 64).toNat = 2 ^ 56 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have b212 : x212.toNat < 72057594037927936 := by clear * - n212 b211; omega
  have n213 : x213.toNat = x192.toNat + x189.toNat := by rw [h213, BitVec.toNat_add_of_lt (by clear * - b192 b189; omega)]
  have b213 : x213.toNat < 5067959079304729098186175618946251 := by clear * - n213 b192 b189; omega
  have n214 : x214.toNat = x213.toNat + x195.toNat := by rw [h214, BitVec.toNat_add_of_lt (by clear * - b213 b195; omega)]
  have b214 : x214.toNat < 5440894199251691218533546231415006 := by clear * - n214 b213 b195; omega
  have n215 : x215.toNat = x214.toNat + x210.toNat := by rw [h215, BitVec.toNat_add_of_lt (by clear * - b214 b210; omega)]
  have b215 : x215.toNat < 5440894199251691294041121413398528 := by clear * - n215 b214 b210; omega
  have n216 : x216.toNat = x215.toNat / 2 ^ 56 := by rw [h216, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have b216 : x216.toNat < 75507575181983523 := by clear * - n216 b215; omega
  have n217 : x217.toNat = x215.toNat % 2 ^ 64 := by rw [h217, BitVec.toNat_setWidth]
  have b217 : x217.toNat < 18446744073709551616 := by clear * - n217 b215; omega
  have n218 : x218.toNat = x217.toNat % 2 ^ 56 := by rw [h218, BitVec.toNat_and, show (72057594037927935#64 : BitVec 64).toNat = 2 ^ 56 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have b218 : x218.toNat < 72057594037927936 := by clear * - n218 b217; omega
  have n219 : x219.toNat = x193.toNat + x185.toNat := by rw [h219, BitVec.toNat_add_of_lt (by clear * - b193 b185; omega)]
  have b219 : x219.toNat < 19343198045501417137892131 := by clear * - n219 b193 b185; omega
  have n220 : x220.toNat = x219.toNat + x196.toNat := by rw [h220, BitVec.toNat_add_of_lt (by clear * - b219 b196; omega)]
  have b220 : x220.toNat < 50455260109663842970600936651 := by clear * - n220 b219 b196; omega
  have n221 : x221.toNat = x220.toNat + x198.toNat := by rw [h221, BitVec.toNat_add_of_lt (by clear * - b220 b198; omega)]
  have b221 : x221.toNat < 58614252429552312931071115486 := by clear * - n221 b220 b198; omega
  have n222 : x222.toNat = x221.toNat + x216.toNat := by rw [h222, BitVec.toNat_add_of_lt (by clear * - b221 b216; omega)]
  have b222 : x222.toNat < 58614252429627820506253099008 := by clear * - n222 b221 b216; omega
  have n223 : x223.toNat = x222.toNat % 2 ^ 64 := by rw [h223, BitVec.toNat_setWidth]
  have b223 : x223.toNat < 18446744073709551616 := by clear * - n223 b222; omega
  have n224 : x224.toNat = x223.toNat % 2 ^ 40 := by rw [h224, BitVec.toNat_and, show (1099511627775#64 : BitVec 64).toNat = 2 ^ 40 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have b224 : x224.toNat < 1099511627776 := by clear * - n224 b223; omega
  have hM := tel5 x182.toNat x203.toNat x209.toNat x215.toNat x222.toNat
    (x183.toNat + x187.toNat) (x188.toNat + x184.toNat + x191.toNat)
    (x192.toNat + x189.toNat + x195.toNat) (x193.toNat + x185.toNat + x196.toNat + x198.toNat)
    (by rw [n203, n202, n199]; clear * -; omega) (by rw [n209, n208, n207, n204])
    (by rw [n215, n214, n213, n210]) (by rw [n222, n221, n220, n219, n216])
  have hKL : (x158.toNat + x163.toNat * 2 ^ 56 + x168.toNat * 2 ^ 112 + x173.toNat * 2 ^ 168 +
      x179.toNat * 2 ^ 224) * 7237005577332262213973186563042994240857116359379907606001950938285454250989 =
      x182.toNat + (x183.toNat + x187.toNat) * 2 ^ 56 +
        (x188.toNat + x184.toNat + x191.toNat) * 2 ^ 112 +
        (x192.toNat + x189.toNat + x195.toNat) * 2 ^ 168 +
        (x193.toNat + x185.toNat + x196.toNat + x198.toNat) * 2 ^ 224 +
        2 ^ 264 * (x163.toNat * 17592186044416 + x168.toNat * 1267650600228229401496703205376 +
          x173.toNat * 91343852333181432387730302044767688728845941214 +
          x179.toNat * 6582018229284824168619876730229402019956174953567740527434535523) := by
    simp only [n182, n183, n184, n185, n187, n188, n189, n191, n192, n193, n195, n196, n198, n181,
      n186, n190, n194, n197]
    ring
  have hM' : x201.toNat + x206.toNat * 2 ^ 56 + x212.toNat * 2 ^ 112 + x218.toNat * 2 ^ 168 +
      x224.toNat * 2 ^ 224 = ((x158.toNat + x163.toNat * 2 ^ 56 + x168.toNat * 2 ^ 112 +
        x173.toNat * 2 ^ 168 + x179.toNat * 2 ^ 224) * 7237005577332262213973186563042994240857116359379907606001950938285454250989) % 2 ^ 264 := by
    rw [n201, n200, n206, n205, n212, n211, n218, n217, n224, n223, mod64_56, mod64_56, mod64_56, mod64_56, mod64_40, ← hM,
      hKL, Nat.add_mul_mod_self_left]
  -- the inputs as `B`'s bits
  have g71 : x71 = (B.extractLsb' 248 56).setWidth 64 := by clear * - ht4 ht5 h68 h69 h70 h71; bv_decide
  have g75 : x75 = (B.extractLsb' 304 56).setWidth 64 := by clear * - ht5 ht6 h72 h73 h74 h75; bv_decide
  have g79 : x79 = (B.extractLsb' 360 56).setWidth 64 := by clear * - ht6 ht7 h76 h77 h78 h79; bv_decide
  have g83 : x83 = (B.extractLsb' 416 56).setWidth 64 := by clear * - ht7 ht8 h80 h81 h82 h83; bv_decide
  have g86 : x86 = (B.extractLsb' 472 40).setWidth 64 := by
    clear * - ht8 hb h50 h84 h85 h86; bv_decide
  have r0 : t0 = (B.extractLsb' 0 56).setWidth 64 := by clear * - ht0; bv_decide
  have r1 : t1 = (B.extractLsb' 56 56).setWidth 64 := by clear * - ht1; bv_decide
  have r2 : t2 = (B.extractLsb' 112 56).setWidth 64 := by clear * - ht2; bv_decide
  have r3 : t3 = (B.extractLsb' 168 56).setWidth 64 := by clear * - ht3; bv_decide
  have r4 : x180 = (B.extractLsb' 224 40).setWidth 64 := by clear * - ht4 h180; bv_decide
  have hBl := B.isLt
  have hQn : x71.toNat + x75.toNat * 2 ^ 56 + x79.toNat * 2 ^ 112 + x83.toNat * 2 ^ 168 +
      x86.toNat * 2 ^ 224 = B.toNat / 2 ^ 248 := by
    rw [g71, g75, g79, g83, g86, toNat_extract _ _ _ (by decide), toNat_extract _ _ _ (by decide),
      toNat_extract _ _ _ (by decide), toNat_extract _ _ _ (by decide),
      toNat_extract _ _ _ (by decide)]
    exact qval _ hBl
  have hRn : t0.toNat + t1.toNat * 2 ^ 56 + t2.toNat * 2 ^ 112 + t3.toNat * 2 ^ 168 +
      x180.toNat * 2 ^ 224 = B.toNat % 2 ^ 264 := by
    rw [r0, r1, r2, r3, r4, toNat_extract _ _ _ (by decide), toNat_extract _ _ _ (by decide),
      toNat_extract _ _ _ (by decide), toNat_extract _ _ _ (by decide),
      toNat_extract _ _ _ (by decide), Nat.pow_zero, Nat.div_one]
    exact rval _
  rw [hQn] at hK
  rw [hK] at hM'
  -- the tail
  have lt56 (x : BitVec 64) (h : x.toNat < 2 ^ 56) : x < 72057594037927936#64 := BitVec.lt_def.mpr h
  have lt40 (x : BitVec 64) (h : x.toNat < 2 ^ 40) : x < 1099511627776#64 := BitVec.lt_def.mpr h
  have hT := tail t0 t1 t2 t3 x180 x201 x206 x212 x218 x224
    (by rw [r0]; clear * -; bv_decide) (by rw [r1]; clear * -; bv_decide) (by rw [r2]; clear * -; bv_decide) (by rw [r3]; clear * -; bv_decide)
    (by rw [r4]; clear * -; bv_decide) (lt56 _ b201) (lt56 _ b206) (lt56 _ b212) (lt56 _ b218) (lt40 _ b224)
    x225 h225 x226 h226 x227 h227 x228 h228 x229 h229 x230 h230 x231 h231 x232 h232 x233 h233 x234 h234 x235 h235 x236 h236 x237 h237 x238 h238 x239 h239 x240 h240 x241 h241 x242 h242 x243 h243 x244 h244 x245 h245 x246 h246 x247 h247 x248 h248 x249 h249 x250 h250 x251 h251 x252 h252 x253 h253 x254 h254 x255 h255 x256 h256 x257 h257 x258 h258 x259 h259 x260 h260 x261 h261 x262 h262 x263 h263 x264 h264 x265 h265 x266 h266 x267 h267 x268 h268 x269 h269 x270 h270 x271 h271 x272 h272 x273 h273 x274 h274 x275 h275 x276 h276 x277 h277 x278 h278 x279 h279
  rw [hT]
  have bt0 : t0.toNat < 2 ^ 56 := by rw [r0, toNat_extract _ _ _ (by decide)]; exact Nat.mod_lt _ (by decide)
  have bt1 : t1.toNat < 2 ^ 56 := by rw [r1, toNat_extract _ _ _ (by decide)]; exact Nat.mod_lt _ (by decide)
  have bt2 : t2.toNat < 2 ^ 56 := by rw [r2, toNat_extract _ _ _ (by decide)]; exact Nat.mod_lt _ (by decide)
  have bt3 : t3.toNat < 2 ^ 56 := by rw [r3, toNat_extract _ _ _ (by decide)]; exact Nat.mod_lt _ (by decide)
  have bt4 : x180.toNat < 2 ^ 40 := by rw [r4, toNat_extract _ _ _ (by decide)]; exact Nat.mod_lt _ (by decide)
  clear * - hRn hM' hK hBl b201 b206 b212 b218 b224 bt0 bt1 bt2 bt3 bt4
  -- both reductions reach `B - k ℓ`, less `ℓ` unless below it
  have hell : Ed25519.ell = 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by unfold Ed25519.ell; rfl
  have hL320 : Scalar.ell320.toNat = 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by rw [Scalar.toNat_ell320, hell]
  have hBar := barrett64 B.toNat hBl
  generalize hKn : x158.toNat + x163.toNat * 2 ^ 56 + x168.toNat * 2 ^ 112 + x173.toNat * 2 ^ 168 +
    x179.toNat * 2 ^ 224 = Kn at hK hM'
  rw [← hK] at hBar
  have hW1 := Scalar.toNat_wide (l := Fe.mk5 t0 t1 t2 t3 x180) (by
    intro i; fin_cases i <;> simp only [Fe.mk5] <;> omega)
  have hW2 := Scalar.toNat_wide (l := Fe.mk5 x201 x206 x212 x218 x224) (by
    intro i; fin_cases i <;> simp only [Fe.mk5] <;> omega)
  simp only [Scalar.val, Fe.mk5] at hW1 hW2
  generalize Scalar.wide (Fe.mk5 t0 t1 t2 t3 x180) = W1 at hW1 ⊢
  generalize Scalar.wide (Fe.mk5 x201 x206 x212 x218 x224) = W2 at hW2 ⊢
  have hs : ((W1 - W2) &&& (BitVec.allOnes 320 >>> 56)).toNat = B.toNat - Kn * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
    have hm : (BitVec.allOnes 320 >>> 56).toNat = 2 ^ 264 - 1 := by
      rw [BitVec.toNat_ushiftRight, BitVec.toNat_allOnes, Nat.shiftRight_eq_div_pow]; decide
    rw [BitVec.toNat_and, hm, Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_sub]
    rw [← hK] at hM'
    exact modsub _ _ _ _ (by rw [hW1, ← hRn]; ring) (by rw [hW2, ← hM']; ring) hBar.1
      (by have := hBar.2; omega)
  have hk : ((((B.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264)).toNat = Kn := by
    rw [BitVec.toNat_ushiftRight, BitVec.toNat_mul, BitVec.toNat_ushiftRight, BitVec.toNat_setWidth,
      toNat_lit (by decide), Nat.shiftRight_eq_div_pow, Nat.shiftRight_eq_div_pow, hK]
    congr 1
    clear * - hBl
    omega
  have hr : (B.setWidth 640 - (((B.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).toNat =
      B.toNat - Kn * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
    have hkL : ((((B.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).toNat = Kn * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
      rw [BitVec.toNat_mul, hk, toNat_lit (by decide)]
      clear * - hBar hBl
      omega
    have hx : (B.setWidth 640).toNat = B.toNat := by
      rw [BitVec.toNat_setWidth]; clear * - hBl; omega
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hkL, hx]; omega), hkL, hx]
  unfold scalar.reduce64.limbs
  dsimp only
  congr 1
  generalize (W1 - W2) &&& (BitVec.allOnes 320 >>> 56) = S at hs ⊢
  generalize B.setWidth 640 - (((B.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640 = R at hr ⊢
  apply BitVec.eq_of_toNat_eq
  have hL640 : (7237005577332262213973186563042994240857116359379907606001950938285454250989#640 : BitVec 640).toNat = 7237005577332262213973186563042994240857116359379907606001950938285454250989 := toNat_lit (by decide)
  have hRS : R.toNat = S.toNat := by rw [hr, hs]
  have hS2 : S.toNat < 2 * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by rw [hs]; omega
  by_cases hc : S.toNat < 7237005577332262213973186563042994240857116359379907606001950938285454250989
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (by rw [BitVec.lt_def, hL320]; exact hc)),
      ite_eq_left_of_eq_true _ _ (eq_true (by rw [BitVec.lt_def, hL640, hRS]; exact hc)),
      BitVec.toNat_setWidth, hRS]
    omega
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (by rw [BitVec.lt_def, hL320]; exact hc)),
      ite_eq_right_of_eq_false _ _ (eq_false (by rw [BitVec.lt_def, hL640, hRS]; exact hc)),
      BitVec.toNat_setWidth,
      BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hL320]; omega),
      BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hL640]; omega), hL320, hL640, hRS]
    omega

end scalar_reduce64

/-! ## Meaning -/

set_option exponentiation.threshold 700 in
/-- The limbs are canonical, of the 64 bytes' value mod `ℓ`. -/
public theorem scalar.reduce64.limbs_canonical (b : BitVec 512) :
    Scalar.Canonical (scalar.reduce64.limbs b) ∧
      Scalar.val (scalar.reduce64.limbs b) = b.toNat % Ed25519.ell := by
  have hN := b.isLt
  have hell : Ed25519.ell = 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by unfold Ed25519.ell; rfl
  have hx : (b.setWidth 640).toNat = b.toNat := by
    rw [BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by omega)
  have hk : (((b.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264).toNat =
      b.toNat / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 := by
    rw [BitVec.toNat_ushiftRight, BitVec.toNat_mul, BitVec.toNat_ushiftRight, hx,
      Nat.shiftRight_eq_div_pow, Nat.shiftRight_eq_div_pow, scalar_reduce64.toNat_lit (by decide)]
    congr 1
    omega
  obtain ⟨hb1, hb2⟩ := scalar_reduce64.barrett64 _ hN
  generalize b.toNat / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 = K at hk hb1 hb2
  have hkL : ((((b.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).toNat = K * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
    rw [BitVec.toNat_mul, hk, scalar_reduce64.toNat_lit (by decide)]
    omega
  have hr : (b.setWidth 640 - (((b.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).toNat =
      b.toNat - K * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hkL, hx]; exact hb1), hkL, hx]
  have hmod : (b.toNat - K * 7237005577332262213973186563042994240857116359379907606001950938285454250989) % 7237005577332262213973186563042994240857116359379907606001950938285454250989 = b.toNat % 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
    have := Nat.sub_mul_mod (show 7237005577332262213973186563042994240857116359379907606001950938285454250989 * K ≤ b.toNat by rw [Nat.mul_comm]; exact hb1)
    rwa [Nat.mul_comm] at this
  have hL640 : (7237005577332262213973186563042994240857116359379907606001950938285454250989#640 : BitVec 640).toNat = 7237005577332262213973186563042994240857116359379907606001950938285454250989 := scalar_reduce64.toNat_lit (by decide)
  unfold scalar.reduce64.limbs
  dsimp only
  rw [hell]
  generalize b.setWidth 640 - (((b.setWidth 640 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#640) >>> 264) * 7237005577332262213973186563042994240857116359379907606001950938285454250989#640 = r at hr
  rw [Nat.add_mul] at hb2
  obtain ⟨P, hP⟩ : ∃ P, P = K * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := ⟨_, rfl⟩
  rw [← hP] at hb1 hb2 hr hmod
  have hlt : b.toNat - P < 2 * 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by omega
  split
  · rename_i h
    rw [BitVec.lt_def, hr, hL640] at h
    have hz : (r.setWidth 320).toNat = b.toNat - P := by
      rw [BitVec.toNat_setWidth, hr]; omega
    obtain ⟨h1, h2⟩ := Scalar.limbs_lt_val (z := r.setWidth 320) (by omega)
    rw [Nat.mod_eq_of_lt h] at hmod
    exact ⟨⟨h1, by rw [hell]; omega⟩, by omega⟩
  · rename_i h
    rw [BitVec.lt_def, hr, hL640] at h
    have hz : ((r - 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).setWidth 320).toNat = b.toNat - P - 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
      rw [BitVec.toNat_setWidth, BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hr, hL640]; omega),
        hr, hL640]
      omega
    obtain ⟨h1, h2⟩ := Scalar.limbs_lt_val (z := (r - 7237005577332262213973186563042994240857116359379907606001950938285454250989#640).setWidth 320) (by omega)
    rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)] at hmod
    exact ⟨⟨h1, by rw [hell]; omega⟩, by omega⟩

/-- `spec b`, little-endian, is `b mod ℓ`. -/
public theorem scalar.reduce64.toNat_spec (b : BitVec 512) :
    (scalar.reduce64.spec b).toNat = b.toNat % Ed25519.ell := by
  obtain ⟨hc, hv⟩ := scalar.reduce64.limbs_canonical b
  rw [scalar.reduce64.spec, Scalar.toBytes.toNat_spec_canonical hc, hv]

/-- `spec b` is `b mod ℓ` in 32 bytes. -/
public theorem scalar.reduce64.spec_eq (b : BitVec 512) :
    scalar.reduce64.spec b = BitVec.ofNat 256 (b.toNat % Ed25519.ell) := by
  apply BitVec.eq_of_toNat_eq
  have := Nat.mod_lt b.toNat (show 0 < Ed25519.ell by unfold Ed25519.ell; omega)
  have := Ed25519.ell_lt
  rw [scalar.reduce64.toNat_spec, BitVec.toNat_ofNat]
  exact (Nat.mod_eq_of_lt (by omega)).symm

set_option maxHeartbeats 8000000 in
/-- `scalar.reduce64` stores `spec b` at `out`, for the 64 bytes `b` at `p`. -/
public theorem scalar_reduce64.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 256) (hp : Fits s.mem p 512) (hpo : p.offset.toNat + 64 < 2 ^ 64) :
    scalar_reduce64.call (scalar_reduce64.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storeAt out (scalar.reduce64.spec (s.mem.readAt p 512)) }) := by
  func_init
  have hwf₀ : S₀.WF := hS ▸ hwf
  have hp₀ : Fits S₀.mem p 512 := hS ▸ hp
  have hp63 : Fits S.mem (p.add 63#64) 8 :=
    Fits.add_of_le (by simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_ofNat]; omega) (by decide) hp
  have hp63₀ : Fits S₀.mem (p.add 63#64) 8 := hS ▸ hp63
  have hb63 : S₀.mem.readAt (p.add 63#64) 8 = (S₀.mem.readAt p 512).extractLsb' 504 8 := by
    rw [MemoryState.readAt_add_of_readAt (w := 8) hp₀ (by
      simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]; omega)
      (by decide) rfl]
    rfl
  block_init
  iterate 36 step_pure
  step_alloca with sc
  step_alloca with lw
  step_alloca with buf
  step_alloca with bo
  iterate 2 step_pure
  step_memcpy
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (0#64).smulOverflow 7#64 = false), (by decide : (0#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld0 hld0
  step_pure with m0 hm0
  step_store
  step_pure [(by decide : (0#64).saddOverflow 1#64 = false), (by decide : (0#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (1#64).smulOverflow 7#64 = false), (by decide : (1#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld1 hld1
  step_pure with m1 hm1
  step_store
  step_pure [(by decide : (1#64).saddOverflow 1#64 = false), (by decide : (1#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (2#64).smulOverflow 7#64 = false), (by decide : (2#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld2 hld2
  step_pure with m2 hm2
  step_store
  step_pure [(by decide : (2#64).saddOverflow 1#64 = false), (by decide : (2#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (3#64).smulOverflow 7#64 = false), (by decide : (3#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld3 hld3
  step_pure with m3 hm3
  step_store
  step_pure [(by decide : (3#64).saddOverflow 1#64 = false), (by decide : (3#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (4#64).smulOverflow 7#64 = false), (by decide : (4#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld4 hld4
  step_pure with m4 hm4
  step_store
  step_pure [(by decide : (4#64).saddOverflow 1#64 = false), (by decide : (4#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (5#64).smulOverflow 7#64 = false), (by decide : (5#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld5 hld5
  step_pure with m5 hm5
  step_store
  step_pure [(by decide : (5#64).saddOverflow 1#64 = false), (by decide : (5#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (6#64).smulOverflow 7#64 = false), (by decide : (6#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld6 hld6
  step_pure with m6 hm6
  step_store
  step_pure [(by decide : (6#64).saddOverflow 1#64 = false), (by decide : (6#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (7#64).smulOverflow 7#64 = false), (by decide : (7#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld7 hld7
  step_pure with m7 hm7
  step_store
  step_pure [(by decide : (7#64).saddOverflow 1#64 = false), (by decide : (7#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (8#64).smulOverflow 7#64 = false), (by decide : (8#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld8 hld8
  step_pure with m8 hm8
  step_store
  step_pure [(by decide : (8#64).saddOverflow 1#64 = false), (by decide : (8#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  have hg63 : p.offset.uaddOverflow 63#64 = false := by
    simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le, BitVec.toNat_ofNat]; omega
  step_pure [hg63]
  step_load with x49 hx49
  step_pure with x50 hx50
  step_load with x51 hx51
  step_pure
  step_load with x53 hx53
  step_pure
  step_load with x55 hx55
  step_pure
  step_load with x57 hx57
  step_pure
  step_load with x59 hx59
  step_pure
  step_load with x61 hx61
  step_pure
  step_load with x63 hx63
  step_pure
  step_load with x65 hx65
  step_pure
  step_load with x67 hx67
  step_pure
  step_pure
  step_pure
  step_pure with x68 hx68
  step_pure with x69 hx69
  step_pure with x70 hx70
  step_pure with x71 hx71
  step_pure with x72 hx72
  step_pure with x73 hx73
  step_pure with x74 hx74
  step_pure with x75 hx75
  step_pure with x76 hx76
  step_pure with x77 hx77
  step_pure with x78 hx78
  step_pure with x79 hx79
  step_pure with x80 hx80
  step_pure with x81 hx81
  step_pure with x82 hx82
  step_pure with x83 hx83
  have c84_0 : (x50) <<< 32 >>> 32 = x50 := by clear * - hx50; bv_decide
  have c84_1 : ((x50) <<< 32).sshiftRight 32 = x50 := by clear * - hx50; bv_decide
  step_pure [c84_0, c84_1] with x84 hx84
  clear c84_0 c84_1
  step_pure with x85 hx85
  step_pure with x86 hx86
  have c87_0 : (x71).msb = false := by clear * - hx69 hx70 hx71; bv_decide
  step_pure [c87_0] with x87 hx87
  clear c87_0
  have c88_0 : (x87).smulOverflow (44162584779952923#128) = false := by clear * - hx87; bv_decide
  have c88_1 : (x87).umulOverflow (44162584779952923#128) = false := by clear * - hx87; bv_decide
  step_pure [c88_0, c88_1] with x88 hx88
  clear c88_0 c88_1
  have c89_0 : (x87).smulOverflow (9390964836247533#128) = false := by clear * - hx87; bv_decide
  have c89_1 : (x87).umulOverflow (9390964836247533#128) = false := by clear * - hx87; bv_decide
  step_pure [c89_0, c89_1] with x89 hx89
  clear c89_0 c89_1
  have c90_0 : (x87).smulOverflow (72057594036560134#128) = false := by clear * - hx87; bv_decide
  have c90_1 : (x87).umulOverflow (72057594036560134#128) = false := by clear * - hx87; bv_decide
  step_pure [c90_0, c90_1] with x90 hx90
  clear c90_0 c90_1
  have c91_0 : (x87).smulOverflow (72057594037927935#128) = false := by clear * - hx87; bv_decide
  have c91_1 : (x87).umulOverflow (72057594037927935#128) = false := by clear * - hx87; bv_decide
  step_pure [c91_0, c91_1] with x91 hx91
  clear c91_0 c91_1
  have c92_0 : (x87).smulOverflow (68719476735#128) = false := by clear * - hx87; bv_decide
  have c92_1 : (x87).umulOverflow (68719476735#128) = false := by clear * - hx87; bv_decide
  step_pure [c92_0, c92_1] with x92 hx92
  clear c92_0 c92_1
  have c93_0 : (x75).msb = false := by clear * - hx73 hx74 hx75; bv_decide
  step_pure [c93_0] with x93 hx93
  clear c93_0
  have c94_0 : (x93).smulOverflow (44162584779952923#128) = false := by clear * - hx93; bv_decide
  have c94_1 : (x93).umulOverflow (44162584779952923#128) = false := by clear * - hx93; bv_decide
  step_pure [c94_0, c94_1] with x94 hx94
  clear c94_0 c94_1
  have c95_0 : (x93).smulOverflow (9390964836247533#128) = false := by clear * - hx93; bv_decide
  have c95_1 : (x93).umulOverflow (9390964836247533#128) = false := by clear * - hx93; bv_decide
  step_pure [c95_0, c95_1] with x95 hx95
  clear c95_0 c95_1
  have c96_0 : (x93).smulOverflow (72057594036560134#128) = false := by clear * - hx93; bv_decide
  have c96_1 : (x93).umulOverflow (72057594036560134#128) = false := by clear * - hx93; bv_decide
  step_pure [c96_0, c96_1] with x96 hx96
  clear c96_0 c96_1
  have c97_0 : (x93).smulOverflow (72057594037927935#128) = false := by clear * - hx93; bv_decide
  have c97_1 : (x93).umulOverflow (72057594037927935#128) = false := by clear * - hx93; bv_decide
  step_pure [c97_0, c97_1] with x97 hx97
  clear c97_0 c97_1
  have c98_0 : (x93).smulOverflow (68719476735#128) = false := by clear * - hx93; bv_decide
  have c98_1 : (x93).umulOverflow (68719476735#128) = false := by clear * - hx93; bv_decide
  step_pure [c98_0, c98_1] with x98 hx98
  clear c98_0 c98_1
  have c99_0 : (x79).msb = false := by clear * - hx77 hx78 hx79; bv_decide
  step_pure [c99_0] with x99 hx99
  clear c99_0
  have c100_0 : (x99).smulOverflow (44162584779952923#128) = false := by clear * - hx99; bv_decide
  have c100_1 : (x99).umulOverflow (44162584779952923#128) = false := by clear * - hx99; bv_decide
  step_pure [c100_0, c100_1] with x100 hx100
  clear c100_0 c100_1
  have c101_0 : (x99).smulOverflow (9390964836247533#128) = false := by clear * - hx99; bv_decide
  have c101_1 : (x99).umulOverflow (9390964836247533#128) = false := by clear * - hx99; bv_decide
  step_pure [c101_0, c101_1] with x101 hx101
  clear c101_0 c101_1
  have c102_0 : (x99).smulOverflow (72057594036560134#128) = false := by clear * - hx99; bv_decide
  have c102_1 : (x99).umulOverflow (72057594036560134#128) = false := by clear * - hx99; bv_decide
  step_pure [c102_0, c102_1] with x102 hx102
  clear c102_0 c102_1
  have c103_0 : (x99).smulOverflow (72057594037927935#128) = false := by clear * - hx99; bv_decide
  have c103_1 : (x99).umulOverflow (72057594037927935#128) = false := by clear * - hx99; bv_decide
  step_pure [c103_0, c103_1] with x103 hx103
  clear c103_0 c103_1
  have c104_0 : (x99).smulOverflow (68719476735#128) = false := by clear * - hx99; bv_decide
  have c104_1 : (x99).umulOverflow (68719476735#128) = false := by clear * - hx99; bv_decide
  step_pure [c104_0, c104_1] with x104 hx104
  clear c104_0 c104_1
  have c105_0 : (x83).msb = false := by clear * - hx81 hx82 hx83; bv_decide
  step_pure [c105_0] with x105 hx105
  clear c105_0
  have c106_0 : (x105).smulOverflow (44162584779952923#128) = false := by clear * - hx105; bv_decide
  have c106_1 : (x105).umulOverflow (44162584779952923#128) = false := by clear * - hx105; bv_decide
  step_pure [c106_0, c106_1] with x106 hx106
  clear c106_0 c106_1
  have c107_0 : (x105).smulOverflow (9390964836247533#128) = false := by clear * - hx105; bv_decide
  have c107_1 : (x105).umulOverflow (9390964836247533#128) = false := by clear * - hx105; bv_decide
  step_pure [c107_0, c107_1] with x107 hx107
  clear c107_0 c107_1
  have c108_0 : (x105).smulOverflow (72057594036560134#128) = false := by clear * - hx105; bv_decide
  have c108_1 : (x105).umulOverflow (72057594036560134#128) = false := by clear * - hx105; bv_decide
  step_pure [c108_0, c108_1] with x108 hx108
  clear c108_0 c108_1
  have c109_0 : (x105).smulOverflow (72057594037927935#128) = false := by clear * - hx105; bv_decide
  have c109_1 : (x105).umulOverflow (72057594037927935#128) = false := by clear * - hx105; bv_decide
  step_pure [c109_0, c109_1] with x109 hx109
  clear c109_0 c109_1
  have c110_0 : (x105).smulOverflow (68719476735#128) = false := by clear * - hx105; bv_decide
  have c110_1 : (x105).umulOverflow (68719476735#128) = false := by clear * - hx105; bv_decide
  step_pure [c110_0, c110_1] with x110 hx110
  clear c110_0 c110_1
  have c111_0 : (x86).msb = false := by clear * - hx50 hx67 hx84 hx85 hx86; bv_decide
  step_pure [c111_0] with x111 hx111
  clear c111_0
  have c112_0 : (x111).smulOverflow (44162584779952923#128) = false := by clear * - hx111; bv_decide
  have c112_1 : (x111).umulOverflow (44162584779952923#128) = false := by clear * - hx111; bv_decide
  step_pure [c112_0, c112_1] with x112 hx112
  clear c112_0 c112_1
  have c113_0 : (x111).smulOverflow (9390964836247533#128) = false := by clear * - hx111; bv_decide
  have c113_1 : (x111).umulOverflow (9390964836247533#128) = false := by clear * - hx111; bv_decide
  step_pure [c113_0, c113_1] with x113 hx113
  clear c113_0 c113_1
  have c114_0 : (x111).smulOverflow (72057594036560134#128) = false := by clear * - hx111; bv_decide
  have c114_1 : (x111).umulOverflow (72057594036560134#128) = false := by clear * - hx111; bv_decide
  step_pure [c114_0, c114_1] with x114 hx114
  clear c114_0 c114_1
  have c115_0 : (x111).smulOverflow (72057594037927935#128) = false := by clear * - hx111; bv_decide
  have c115_1 : (x111).umulOverflow (72057594037927935#128) = false := by clear * - hx111; bv_decide
  step_pure [c115_0, c115_1] with x115 hx115
  clear c115_0 c115_1
  have c116_0 : (x111).smulOverflow (68719476735#128) = false := by clear * - hx111; bv_decide
  have c116_1 : (x111).umulOverflow (68719476735#128) = false := by clear * - hx111; bv_decide
  step_pure [c116_0, c116_1] with x116 hx116
  clear c116_0 c116_1
  have c117_0 : (x94).saddOverflow (x89) = false := by clear * - hx87 hx89 hx93 hx94; bv_decide
  have c117_1 : (x94).uaddOverflow (x89) = false := by clear * - hx87 hx89 hx93 hx94; bv_decide
  step_pure [c117_0, c117_1] with x117 hx117
  clear c117_0 c117_1
  have c118_0 : (x95).saddOverflow (x90) = false := by clear * - hx87 hx90 hx93 hx95; bv_decide
  have c118_1 : (x95).uaddOverflow (x90) = false := by clear * - hx87 hx90 hx93 hx95; bv_decide
  step_pure [c118_0, c118_1] with x118 hx118
  clear c118_0 c118_1
  have c119_0 : (x118).saddOverflow (x100) = false := by clear * - hx100 hx118 hx79 hx87 hx90 hx93 hx95 hx99; bv_decide
  have c119_1 : (x118).uaddOverflow (x100) = false := by clear * - hx100 hx118 hx79 hx87 hx90 hx93 hx95 hx99; bv_decide
  step_pure [c119_0, c119_1] with x119 hx119
  clear c119_0 c119_1
  have c120_0 : (x96).saddOverflow (x91) = false := by clear * - hx87 hx91 hx93 hx96; bv_decide
  have c120_1 : (x96).uaddOverflow (x91) = false := by clear * - hx87 hx91 hx93 hx96; bv_decide
  step_pure [c120_0, c120_1] with x120 hx120
  clear c120_0 c120_1
  have c121_0 : (x120).saddOverflow (x101) = false := by clear * - hx101 hx120 hx79 hx87 hx91 hx93 hx96 hx99; bv_decide
  have c121_1 : (x120).uaddOverflow (x101) = false := by clear * - hx101 hx120 hx79 hx87 hx91 hx93 hx96 hx99; bv_decide
  step_pure [c121_0, c121_1] with x121 hx121
  clear c121_0 c121_1
  have c122_0 : (x121).saddOverflow (x106) = false := by clear * - hx101 hx105 hx106 hx120 hx121 hx79 hx81 hx82 hx83 hx87 hx91 hx93 hx96 hx99; bv_decide
  have c122_1 : (x121).uaddOverflow (x106) = false := by clear * - hx101 hx105 hx106 hx120 hx121 hx79 hx81 hx82 hx83 hx87 hx91 hx93 hx96 hx99; bv_decide
  step_pure [c122_0, c122_1] with x122 hx122
  clear c122_0 c122_1
  have c123_0 : (x97).saddOverflow (x92) = false := by clear * - hx87 hx92 hx93 hx97; bv_decide
  have c123_1 : (x97).uaddOverflow (x92) = false := by clear * - hx87 hx92 hx93 hx97; bv_decide
  step_pure [c123_0, c123_1] with x123 hx123
  clear c123_0 c123_1
  have c124_0 : (x123).saddOverflow (x102) = false := by clear * - hx102 hx123 hx79 hx87 hx92 hx93 hx97 hx99; bv_decide
  have c124_1 : (x123).uaddOverflow (x102) = false := by clear * - hx102 hx123 hx79 hx87 hx92 hx93 hx97 hx99; bv_decide
  step_pure [c124_0, c124_1] with x124 hx124
  clear c124_0 c124_1
  have c125_0 : (x103).saddOverflow (x98) = false := by clear * - hx103 hx93 hx98 hx99; bv_decide
  have c125_1 : (x103).uaddOverflow (x98) = false := by clear * - hx103 hx93 hx98 hx99; bv_decide
  step_pure [c125_0, c125_1] with x125 hx125
  clear c125_0 c125_1
  have c126_0 : (x110).saddOverflow (x115) = false := by clear * - hx105 hx110 hx111 hx115; bv_decide
  have c126_1 : (x110).uaddOverflow (x115) = false := by clear * - hx105 hx110 hx111 hx115; bv_decide
  step_pure [c126_0, c126_1] with x126 hx126
  clear c126_0 c126_1
  step_pure with x127 hx127
  have c128_0 : (x117).saddOverflow (x127) = false := by clear * - hx117 hx127 hx87 hx88 hx89 hx93 hx94; bv_decide
  have c128_1 : (x117).uaddOverflow (x127) = false := by clear * - hx117 hx127 hx87 hx88 hx89 hx93 hx94; bv_decide
  step_pure [c128_0, c128_1] with x128 hx128
  clear c128_0 c128_1
  step_pure with x129 hx129
  have c130_0 : (x119).saddOverflow (x129) = false := by clear * - hx100 hx117 hx118 hx119 hx127 hx128 hx129 hx79 hx87 hx88 hx89 hx90 hx93 hx94 hx95 hx99; bv_decide
  have c130_1 : (x119).uaddOverflow (x129) = false := by clear * - hx100 hx117 hx118 hx119 hx127 hx128 hx129 hx79 hx87 hx88 hx89 hx90 hx93 hx94 hx95 hx99; bv_decide
  step_pure [c130_0, c130_1] with x130 hx130
  clear c130_0 c130_1
  step_pure with x131 hx131
  have c132_0 : (x122).saddOverflow (x131) = false := by clear * - hx100 hx101 hx105 hx106 hx117 hx118 hx119 hx120 hx121 hx122 hx127 hx128 hx129 hx130 hx131 hx65 hx71 hx75 hx77 hx78 hx79 hx80 hx81 hx82 hx83 hx87 hx88 hx89 hx90 hx91 hx93 hx94 hx95 hx96 hx99; bv_decide
  have c132_1 : (x122).uaddOverflow (x131) = false := by clear * - hx100 hx101 hx105 hx106 hx117 hx118 hx119 hx120 hx121 hx122 hx127 hx128 hx129 hx130 hx131 hx65 hx71 hx75 hx77 hx78 hx79 hx80 hx81 hx82 hx83 hx87 hx88 hx89 hx90 hx91 hx93 hx94 hx95 hx96 hx99; bv_decide
  step_pure [c132_0, c132_1] with x132 hx132
  clear c132_0 c132_1
  step_pure with x133 hx133
  have c134_0 : (x124).saddOverflow (x112) = false := by clear * - hx102 hx111 hx112 hx123 hx124 hx79 hx84 hx85 hx86 hx87 hx92 hx93 hx97 hx99; bv_decide
  have c134_1 : (x124).uaddOverflow (x112) = false := by clear * - hx102 hx111 hx112 hx123 hx124 hx79 hx84 hx85 hx86 hx87 hx92 hx93 hx97 hx99; bv_decide
  step_pure [c134_0, c134_1] with x134 hx134
  clear c134_0 c134_1
  have c135_0 : (x134).saddOverflow (x107) = false := by clear * - hx102 hx105 hx107 hx111 hx112 hx123 hx124 hx134 hx50 hx65 hx67 hx71 hx75 hx77 hx78 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx87 hx92 hx93 hx97 hx99; bv_decide
  have c135_1 : (x134).uaddOverflow (x107) = false := by clear * - hx102 hx105 hx107 hx111 hx112 hx123 hx124 hx134 hx50 hx65 hx67 hx71 hx75 hx77 hx78 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx87 hx92 hx93 hx97 hx99; bv_decide
  step_pure [c135_0, c135_1] with x135 hx135
  clear c135_0 c135_1
  have c136_0 : (x135).saddOverflow (x133) = false := by clear * - hx100 hx101 hx102 hx105 hx106 hx107 hx111 hx112 hx118 hx119 hx120 hx121 hx122 hx123 hx124 hx128 hx129 hx130 hx131 hx132 hx133 hx134 hx135 hx65 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx87 hx91 hx92 hx93 hx96 hx97 hx99; bv_decide
  have c136_1 : (x135).uaddOverflow (x133) = false := by clear * - hx100 hx101 hx102 hx105 hx106 hx107 hx111 hx112 hx118 hx119 hx120 hx121 hx122 hx123 hx124 hx128 hx129 hx130 hx131 hx132 hx133 hx134 hx135 hx65 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx87 hx91 hx92 hx93 hx96 hx97 hx99; bv_decide
  step_pure [c136_0, c136_1] with x136 hx136
  clear c136_0 c136_1
  step_pure with x137 hx137
  step_pure with x138 hx138
  have c139_0 : (x125).saddOverflow (x113) = false := by clear * - hx103 hx111 hx113 hx125 hx86 hx93 hx98 hx99; bv_decide
  have c139_1 : (x125).uaddOverflow (x113) = false := by clear * - hx103 hx111 hx113 hx125 hx86 hx93 hx98 hx99; bv_decide
  step_pure [c139_0, c139_1] with x139 hx139
  clear c139_0 c139_1
  have c140_0 : (x139).saddOverflow (x108) = false := by clear * - hx103 hx105 hx108 hx111 hx113 hx125 hx139 hx81 hx82 hx83 hx86 hx93 hx98 hx99; bv_decide
  have c140_1 : (x139).uaddOverflow (x108) = false := by clear * - hx103 hx105 hx108 hx111 hx113 hx125 hx139 hx81 hx82 hx83 hx86 hx93 hx98 hx99; bv_decide
  step_pure [c140_0, c140_1] with x140 hx140
  clear c140_0 c140_1
  have c141_0 : (x140).saddOverflow (x137) = false := by clear * - hx102 hx103 hx105 hx106 hx107 hx108 hx111 hx112 hx113 hx121 hx122 hx123 hx124 hx125 hx130 hx131 hx132 hx133 hx134 hx135 hx136 hx137 hx139 hx140 hx65 hx75 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx93 hx98 hx99; bv_decide
  have c141_1 : (x140).uaddOverflow (x137) = false := by clear * - hx102 hx103 hx105 hx106 hx107 hx108 hx111 hx112 hx113 hx121 hx122 hx123 hx124 hx125 hx130 hx131 hx132 hx133 hx134 hx135 hx136 hx137 hx139 hx140 hx65 hx75 hx79 hx80 hx81 hx82 hx83 hx84 hx85 hx86 hx93 hx98 hx99; bv_decide
  step_pure [c141_0, c141_1] with x141 hx141
  clear c141_0 c141_1
  step_pure with x142 hx142
  step_pure with x143 hx143
  have c144_0 : (x114).saddOverflow (x104) = false := by clear * - hx104 hx111 hx114 hx99; bv_decide
  have c144_1 : (x114).uaddOverflow (x104) = false := by clear * - hx104 hx111 hx114 hx99; bv_decide
  step_pure [c144_0, c144_1] with x144 hx144
  clear c144_0 c144_1
  have c145_0 : (x144).saddOverflow (x109) = false := by clear * - hx104 hx105 hx109 hx111 hx114 hx144 hx83 hx99; bv_decide
  have c145_1 : (x144).uaddOverflow (x109) = false := by clear * - hx104 hx105 hx109 hx111 hx114 hx144 hx83 hx99; bv_decide
  step_pure [c145_0, c145_1] with x145 hx145
  clear c145_0 c145_1
  have c146_0 : (x145).saddOverflow (x142) = false := by clear * - hx104 hx105 hx108 hx109 hx111 hx114 hx136 hx137 hx139 hx140 hx141 hx142 hx144 hx145 hx83 hx99; bv_decide
  have c146_1 : (x145).uaddOverflow (x142) = false := by clear * - hx104 hx105 hx108 hx109 hx111 hx114 hx136 hx137 hx139 hx140 hx141 hx142 hx144 hx145 hx83 hx99; bv_decide
  step_pure [c146_0, c146_1] with x146 hx146
  clear c146_0 c146_1
  step_pure with x147 hx147
  step_pure with x148 hx148
  have c149_0 : (x126).saddOverflow (x147) = false := by clear * - hx105 hx110 hx111 hx115 hx126 hx142 hx145 hx146 hx147; bv_decide
  have c149_1 : (x126).uaddOverflow (x147) = false := by clear * - hx105 hx110 hx111 hx115 hx126 hx142 hx145 hx146 hx147; bv_decide
  step_pure [c149_0, c149_1] with x149 hx149
  clear c149_0 c149_1
  step_pure with x150 hx150
  step_pure with x151 hx151
  have c152_0 : (x150).saddOverflow (x116) = false := by clear * - hx111 hx116 hx149 hx150; bv_decide
  have c152_1 : (x150).uaddOverflow (x116) = false := by clear * - hx111 hx116 hx149 hx150; bv_decide
  step_pure [c152_0, c152_1] with x152 hx152
  clear c152_0 c152_1
  step_pure with x153 hx153
  step_pure with x154 hx154
  step_pure with x155 hx155
  step_pure with x156 hx156
  step_pure with x157 hx157
  have c158_0 : (x155) &&& (x157) = 0#64 := by clear * - hx155 hx157; bv_decide
  step_pure [c158_0] with x158 hx158
  clear c158_0
  step_pure with x159 hx159
  step_pure with x160 hx160
  step_pure with x161 hx161
  step_pure with x162 hx162
  have c163_0 : (x160) &&& (x162) = 0#64 := by clear * - hx160 hx162; bv_decide
  step_pure [c163_0] with x163 hx163
  clear c163_0
  step_pure with x164 hx164
  step_pure with x165 hx165
  step_pure with x166 hx166
  step_pure with x167 hx167
  have c168_0 : (x165) &&& (x167) = 0#64 := by clear * - hx165 hx167; bv_decide
  step_pure [c168_0] with x168 hx168
  clear c168_0
  step_pure with x169 hx169
  step_pure with x170 hx170
  step_pure with x171 hx171
  step_pure with x172 hx172
  have c173_0 : (x170) &&& (x172) = 0#64 := by clear * - hx170 hx172; bv_decide
  step_pure [c173_0] with x173 hx173
  clear c173_0
  step_pure with x174 hx174
  have c175_0 : ((x174).setWidth 64).setWidth 128 = x174 := by clear * - hx111 hx116 hx149 hx150 hx152 hx174; bv_decide
  have c175_1 : ((x174).setWidth 64).signExtend 128 = x174 := by clear * - hx111 hx116 hx149 hx150 hx152 hx174; bv_decide
  step_pure [c175_0, c175_1] with x175 hx175
  clear c175_0 c175_1
  step_pure with x176 hx176
  step_pure with x177 hx177
  step_pure with x178 hx178
  have c179_0 : (x178) &&& (x176) = 0#64 := by clear * - hx176 hx178; bv_decide
  step_pure [c179_0] with x179 hx179
  clear c179_0
  step_pure with x180 hx180
  have c181_0 : (x158).msb = false := by clear * - hx155 hx157 hx158; bv_decide
  step_pure [c181_0] with x181 hx181
  clear c181_0
  have c182_0 : (x181).smulOverflow (5175514460705773#128) = false := by clear * - hx181; bv_decide
  have c182_1 : (x181).umulOverflow (5175514460705773#128) = false := by clear * - hx181; bv_decide
  step_pure [c182_0, c182_1] with x182 hx182
  clear c182_0 c182_1
  have c183_0 : (x181).smulOverflow (70332060721272408#128) = false := by clear * - hx181; bv_decide
  have c183_1 : (x181).umulOverflow (70332060721272408#128) = false := by clear * - hx181; bv_decide
  step_pure [c183_0, c183_1] with x183 hx183
  clear c183_0 c183_1
  have c184_0 : (x181).smulOverflow (5342#128) = false := by clear * - hx181; bv_decide
  have c184_1 : (x181).umulOverflow (5342#128) = false := by clear * - hx181; bv_decide
  step_pure [c184_0, c184_1] with x184 hx184
  clear c184_0 c184_1
  have c185_0 : (x181) <<< 28 >>> 28 = x181 := by clear * - hx181; bv_decide
  have c185_1 : ((x181) <<< 28).sshiftRight 28 = x181 := by clear * - hx181; bv_decide
  step_pure [c185_0, c185_1] with x185 hx185
  clear c185_0 c185_1
  have c186_0 : (x163).msb = false := by clear * - hx160 hx162 hx163; bv_decide
  step_pure [c186_0] with x186 hx186
  clear c186_0
  have c187_0 : (x186).smulOverflow (5175514460705773#128) = false := by clear * - hx186; bv_decide
  have c187_1 : (x186).umulOverflow (5175514460705773#128) = false := by clear * - hx186; bv_decide
  step_pure [c187_0, c187_1] with x187 hx187
  clear c187_0 c187_1
  have c188_0 : (x186).smulOverflow (70332060721272408#128) = false := by clear * - hx186; bv_decide
  have c188_1 : (x186).umulOverflow (70332060721272408#128) = false := by clear * - hx186; bv_decide
  step_pure [c188_0, c188_1] with x188 hx188
  clear c188_0 c188_1
  have c189_0 : (x186).smulOverflow (5342#128) = false := by clear * - hx186; bv_decide
  have c189_1 : (x186).umulOverflow (5342#128) = false := by clear * - hx186; bv_decide
  step_pure [c189_0, c189_1] with x189 hx189
  clear c189_0 c189_1
  have c190_0 : (x168).msb = false := by clear * - hx165 hx167 hx168; bv_decide
  step_pure [c190_0] with x190 hx190
  clear c190_0
  have c191_0 : (x190).smulOverflow (5175514460705773#128) = false := by clear * - hx190; bv_decide
  have c191_1 : (x190).umulOverflow (5175514460705773#128) = false := by clear * - hx190; bv_decide
  step_pure [c191_0, c191_1] with x191 hx191
  clear c191_0 c191_1
  have c192_0 : (x190).smulOverflow (70332060721272408#128) = false := by clear * - hx190; bv_decide
  have c192_1 : (x190).umulOverflow (70332060721272408#128) = false := by clear * - hx190; bv_decide
  step_pure [c192_0, c192_1] with x192 hx192
  clear c192_0 c192_1
  have c193_0 : (x190).smulOverflow (5342#128) = false := by clear * - hx190; bv_decide
  have c193_1 : (x190).umulOverflow (5342#128) = false := by clear * - hx190; bv_decide
  step_pure [c193_0, c193_1] with x193 hx193
  clear c193_0 c193_1
  have c194_0 : (x173).msb = false := by clear * - hx170 hx172 hx173; bv_decide
  step_pure [c194_0] with x194 hx194
  clear c194_0
  have c195_0 : (x194).smulOverflow (5175514460705773#128) = false := by clear * - hx194; bv_decide
  have c195_1 : (x194).umulOverflow (5175514460705773#128) = false := by clear * - hx194; bv_decide
  step_pure [c195_0, c195_1] with x195 hx195
  clear c195_0 c195_1
  have c196_0 : (x194).smulOverflow (699938952792#128) = false := by clear * - hx194; bv_decide
  have c196_1 : (x194).umulOverflow (699938952792#128) = false := by clear * - hx194; bv_decide
  step_pure [c196_0, c196_1] with x196 hx196
  clear c196_0 c196_1
  have c197_0 : (x179).msb = false := by clear * - hx176 hx178 hx179; bv_decide
  step_pure [c197_0] with x197 hx197
  clear c197_0
  have c198_0 : (x197).smulOverflow (113228764141#128) = false := by clear * - hx197; bv_decide
  have c198_1 : (x197).umulOverflow (113228764141#128) = false := by clear * - hx197; bv_decide
  step_pure [c198_0, c198_1] with x198 hx198
  clear c198_0 c198_1
  step_pure with x199 hx199
  step_pure with x200 hx200
  step_pure with x201 hx201
  have c202_0 : (x199).saddOverflow (x183) = false := by clear * - hx181 hx182 hx183 hx199; bv_decide
  have c202_1 : (x199).uaddOverflow (x183) = false := by clear * - hx181 hx182 hx183 hx199; bv_decide
  step_pure [c202_0, c202_1] with x202 hx202
  clear c202_0 c202_1
  have c203_0 : (x202).saddOverflow (x187) = false := by clear * - hx163 hx181 hx182 hx183 hx186 hx187 hx199 hx202; bv_decide
  have c203_1 : (x202).uaddOverflow (x187) = false := by clear * - hx163 hx181 hx182 hx183 hx186 hx187 hx199 hx202; bv_decide
  step_pure [c203_0, c203_1] with x203 hx203
  clear c203_0 c203_1
  step_pure with x204 hx204
  step_pure with x205 hx205
  step_pure with x206 hx206
  have c207_0 : (x188).saddOverflow (x184) = false := by clear * - hx181 hx184 hx186 hx188; bv_decide
  have c207_1 : (x188).uaddOverflow (x184) = false := by clear * - hx181 hx184 hx186 hx188; bv_decide
  step_pure [c207_0, c207_1] with x207 hx207
  clear c207_0 c207_1
  have c208_0 : (x207).saddOverflow (x191) = false := by clear * - hx168 hx181 hx184 hx186 hx188 hx190 hx191 hx207; bv_decide
  have c208_1 : (x207).uaddOverflow (x191) = false := by clear * - hx168 hx181 hx184 hx186 hx188 hx190 hx191 hx207; bv_decide
  step_pure [c208_0, c208_1] with x208 hx208
  clear c208_0 c208_1
  have c209_0 : (x208).saddOverflow (x204) = false := by clear * - hx168 hx181 hx183 hx184 hx186 hx187 hx188 hx190 hx191 hx199 hx202 hx203 hx204 hx207 hx208; bv_decide
  have c209_1 : (x208).uaddOverflow (x204) = false := by clear * - hx168 hx181 hx183 hx184 hx186 hx187 hx188 hx190 hx191 hx199 hx202 hx203 hx204 hx207 hx208; bv_decide
  step_pure [c209_0, c209_1] with x209 hx209
  clear c209_0 c209_1
  step_pure with x210 hx210
  step_pure with x211 hx211
  step_pure with x212 hx212
  have c213_0 : (x192).saddOverflow (x189) = false := by clear * - hx186 hx189 hx190 hx192; bv_decide
  have c213_1 : (x192).uaddOverflow (x189) = false := by clear * - hx186 hx189 hx190 hx192; bv_decide
  step_pure [c213_0, c213_1] with x213 hx213
  clear c213_0 c213_1
  have c214_0 : (x213).saddOverflow (x195) = false := by clear * - hx173 hx186 hx189 hx190 hx192 hx194 hx195 hx213; bv_decide
  have c214_1 : (x213).uaddOverflow (x195) = false := by clear * - hx173 hx186 hx189 hx190 hx192 hx194 hx195 hx213; bv_decide
  step_pure [c214_0, c214_1] with x214 hx214
  clear c214_0 c214_1
  have c215_0 : (x214).saddOverflow (x210) = false := by clear * - hx173 hx186 hx189 hx190 hx191 hx192 hx194 hx195 hx203 hx204 hx207 hx208 hx209 hx210 hx213 hx214; bv_decide
  have c215_1 : (x214).uaddOverflow (x210) = false := by clear * - hx173 hx186 hx189 hx190 hx191 hx192 hx194 hx195 hx203 hx204 hx207 hx208 hx209 hx210 hx213 hx214; bv_decide
  step_pure [c215_0, c215_1] with x215 hx215
  clear c215_0 c215_1
  step_pure with x216 hx216
  step_pure with x217 hx217
  step_pure with x218 hx218
  have c219_0 : (x193).saddOverflow (x185) = false := by clear * - hx181 hx185 hx190 hx193; bv_decide
  have c219_1 : (x193).uaddOverflow (x185) = false := by clear * - hx181 hx185 hx190 hx193; bv_decide
  step_pure [c219_0, c219_1] with x219 hx219
  clear c219_0 c219_1
  have c220_0 : (x219).saddOverflow (x196) = false := by clear * - hx173 hx181 hx185 hx190 hx193 hx194 hx196 hx219; bv_decide
  have c220_1 : (x219).uaddOverflow (x196) = false := by clear * - hx173 hx181 hx185 hx190 hx193 hx194 hx196 hx219; bv_decide
  step_pure [c220_0, c220_1] with x220 hx220
  clear c220_0 c220_1
  have c221_0 : (x220).saddOverflow (x198) = false := by clear * - hx173 hx176 hx178 hx179 hx181 hx185 hx190 hx193 hx194 hx196 hx197 hx198 hx219 hx220; bv_decide
  have c221_1 : (x220).uaddOverflow (x198) = false := by clear * - hx173 hx176 hx178 hx179 hx181 hx185 hx190 hx193 hx194 hx196 hx197 hx198 hx219 hx220; bv_decide
  step_pure [c221_0, c221_1] with x221 hx221
  clear c221_0 c221_1
  have c222_0 : (x221).saddOverflow (x216) = false := by clear * - hx158 hx168 hx170 hx172 hx173 hx175 hx176 hx177 hx178 hx179 hx181 hx185 hx186 hx189 hx190 hx191 hx192 hx193 hx194 hx195 hx196 hx197 hx198 hx203 hx204 hx207 hx208 hx209 hx210 hx213 hx214 hx215 hx216 hx219 hx220 hx221; bv_decide
  have c222_1 : (x221).uaddOverflow (x216) = false := by clear * - hx158 hx168 hx170 hx172 hx173 hx175 hx176 hx177 hx178 hx179 hx181 hx185 hx186 hx189 hx190 hx191 hx192 hx193 hx194 hx195 hx196 hx197 hx198 hx203 hx204 hx207 hx208 hx209 hx210 hx213 hx214 hx215 hx216 hx219 hx220 hx221; bv_decide
  step_pure [c222_0, c222_1] with x222 hx222
  clear c222_0 c222_1
  step_pure with x223 hx223
  step_pure with x224 hx224
  step_pure with x225 hx225
  step_pure with x226 hx226
  step_pure with x227 hx227
  step_pure with x228 hx228
  step_pure with x229 hx229
  step_pure with x230 hx230
  step_pure with x231 hx231
  step_pure with x232 hx232
  step_pure with x233 hx233
  step_pure with x234 hx234
  step_pure with x235 hx235
  step_pure with x236 hx236
  step_pure with x237 hx237
  step_pure with x238 hx238
  step_pure with x239 hx239
  step_pure with x240 hx240
  step_pure with x241 hx241
  step_pure with x242 hx242
  step_pure with x243 hx243
  step_pure with x244 hx244
  have c245_0 : (x244) <<< 56 >>> 56 = x244 := by clear * - hx244; bv_decide
  have c245_1 : ((x244) <<< 56).sshiftRight 56 = x244 := by clear * - hx244; bv_decide
  step_pure [c245_0, c245_1] with x245 hx245
  clear c245_0 c245_1
  step_pure with x246 hx246
  have c247_0 : (x244).saddOverflow (x224) = false := by clear * - hx224 hx244; bv_decide
  have c247_1 : (x244).uaddOverflow (x224) = false := by clear * - hx224 hx244; bv_decide
  step_pure [c247_0, c247_1] with x247 hx247
  clear c247_0 c247_1
  step_pure with x248 hx248
  step_pure with x249 hx249
  have c250_0 : (x249) &&& (x180) = 0#64 := by clear * - hx180 hx249; bv_decide
  step_pure [c250_0] with x250 hx250
  clear c250_0
  have c251_0 : (x250).ssubOverflow (x247) = false := by clear * - hx180 hx224 hx244 hx247 hx249 hx250; bv_decide
  step_pure [c251_0] with x251 hx251
  clear c251_0
  step_pure with x252 hx252
  step_pure with x253 hx253
  have c254_0 : (x253) <<< 56 >>> 56 = x253 := by clear * - hx253; bv_decide
  have c254_1 : ((x253) <<< 56).sshiftRight 56 = x253 := by clear * - hx253; bv_decide
  step_pure [c254_0, c254_1] with x254 hx254
  clear c254_0 c254_1
  step_pure with x255 hx255
  have c256_0 : (x253) &&& (70332060721272408#64) = 0#64 := by clear * - hx253; bv_decide
  step_pure [c256_0] with x256 hx256
  clear c256_0
  step_pure with x257 hx257
  step_pure with x258 hx258
  have c259_0 : (x258) <<< 56 >>> 56 = x258 := by clear * - hx258; bv_decide
  have c259_1 : ((x258) <<< 56).sshiftRight 56 = x258 := by clear * - hx258; bv_decide
  step_pure [c259_0, c259_1] with x259 hx259
  clear c259_0 c259_1
  step_pure with x260 hx260
  have c261_0 : (x258) &&& (5342#64) = 0#64 := by clear * - hx258; bv_decide
  step_pure [c261_0] with x261 hx261
  clear c261_0
  step_pure with x262 hx262
  step_pure with x263 hx263
  step_pure with x264 hx264
  have c265_0 : (x264) <<< 56 >>> 56 = x264 := by clear * - hx264; bv_decide
  have c265_1 : ((x264) <<< 56).sshiftRight 56 = x264 := by clear * - hx264; bv_decide
  step_pure [c265_0, c265_1] with x265 hx265
  clear c265_0 c265_1
  step_pure with x266 hx266
  step_pure with x267 hx267
  step_pure with x268 hx268
  have c269_0 : (x268) <<< 56 >>> 56 = x268 := by clear * - hx268; bv_decide
  have c269_1 : ((x268) <<< 56).sshiftRight 56 = x268 := by clear * - hx268; bv_decide
  step_pure [c269_0, c269_1] with x269 hx269
  clear c269_0 c269_1
  step_pure with x270 hx270
  step_pure with x271 hx271
  have c272_0 : (x268) &&& (268435456#64) = 0#64 := by clear * - hx268; bv_decide
  step_pure [c272_0] with x272 hx272
  clear c272_0
  step_pure with x273 hx273
  step_pure with x274 hx274
  step_pure with x275 hx275
  step_pure with x276 hx276
  step_pure with x277 hx277
  step_pure with x278 hx278
  have c279_0 : (x251).ssubOverflow (x278) = false := by clear * - hx180 hx224 hx244 hx247 hx249 hx250 hx251 hx268 hx272 hx273 hx278; bv_decide
  step_pure [c279_0] with x279 hx279
  clear c279_0
  -- the limbs read back from `lw`, and the code's limbs as `spec`'s
  have hF : Fits ((((S₀.alloca 40).alloca 80).alloca 64).alloca 32).mem lw 640 := by
    have := hlw_fits; rw [hS] at this; simpa [Fits.storeAt_iff] using this
  have hov (k : Nat) (hk : k ≤ 72) : ¬lw.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [hlw_off, BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    simp; omega
  have f8 := Fits.add_of_le (w := 64) (hov 8 (by decide)) (by decide) hF
  have f16 := Fits.add_of_le (w := 64) (hov 16 (by decide)) (by decide) hF
  have f24 := Fits.add_of_le (w := 64) (hov 24 (by decide)) (by decide) hF
  have f32 := Fits.add_of_le (w := 64) (hov 32 (by decide)) (by decide) hF
  have f40 := Fits.add_of_le (w := 64) (hov 40 (by decide)) (by decide) hF
  have f48 := Fits.add_of_le (w := 64) (hov 48 (by decide)) (by decide) hF
  have f56 := Fits.add_of_le (w := 64) (hov 56 (by decide)) (by decide) hF
  have f64 := Fits.add_of_le (w := 64) (hov 64 (by decide)) (by decide) hF
  simp only [Tactic.readThroughStore] at hx53 hx55 hx57 hx59 hx61 hx63 hx65 hx67
  clear hov f8 f16 f24 f32 f40 f48 f56 f64 hF
  have hc := scalar_reduce64.code_eq (S₀.mem.readAt p 512) m0 x53 x55 x57 x59 x61 x63 x65 x67 x49
    (by rw [hm0, hld0]; clear * -; bv_decide) (by rw [hx53, hm1, hld1])
    (by rw [hx55, hm2, hld2]) (by rw [hx57, hm3, hld3]) (by rw [hx59, hm4, hld4])
    (by rw [hx61, hm5, hld5]) (by rw [hx63, hm6, hld6]) (by rw [hx65, hm7, hld7])
    (by rw [hx67, hm8, hld8])
    (by rw [hx49, hb63])
    x50 hx50
    x68 hx68 x69 hx69 x70 hx70 x71 hx71 x72 hx72 x73 hx73 x74 hx74 x75 hx75 x76 hx76 x77 hx77 x78
    hx78 x79 hx79 x80 hx80 x81 hx81 x82 hx82 x83 hx83 x84 hx84 x85 hx85 x86 hx86 x87 hx87 x88
    hx88 x89 hx89 x90 hx90 x91 hx91 x92 hx92 x93 hx93 x94 hx94 x95 hx95 x96 hx96 x97 hx97 x98
    hx98 x99 hx99 x100 hx100 x101 hx101 x102 hx102 x103 hx103 x104 hx104 x105 hx105 x106 hx106
    x107 hx107 x108 hx108 x109 hx109 x110 hx110 x111 hx111 x112 hx112 x113 hx113 x114 hx114 x115
    hx115 x116 hx116 x117 hx117 x118 hx118 x119 hx119 x120 hx120 x121 hx121 x122 hx122 x123 hx123
    x124 hx124 x125 hx125 x126 hx126 x127 hx127 x128 hx128 x129 hx129 x130 hx130 x131 hx131 x132
    hx132 x133 hx133 x134 hx134 x135 hx135 x136 hx136 x137 hx137 x138 hx138 x139 hx139 x140 hx140
    x141 hx141 x142 hx142 x143 hx143 x144 hx144 x145 hx145 x146 hx146 x147 hx147 x148 hx148 x149
    hx149 x150 hx150 x151 hx151 x152 hx152 x153 hx153 x154 hx154 x155 hx155 x156 hx156 x157 hx157
    x158 hx158 x159 hx159 x160 hx160 x161 hx161 x162 hx162 x163 hx163 x164 hx164 x165 hx165 x166
    hx166 x167 hx167 x168 hx168 x169 hx169 x170 hx170 x171 hx171 x172 hx172 x173 hx173 x174 hx174
    x175 hx175 x176 hx176 x177 hx177 x178 hx178 x179 hx179 x180 hx180 x181 hx181 x182 hx182 x183
    hx183 x184 hx184 x185 hx185 x186 hx186 x187 hx187 x188 hx188 x189 hx189 x190 hx190 x191 hx191
    x192 hx192 x193 hx193 x194 hx194 x195 hx195 x196 hx196 x197 hx197 x198 hx198 x199 hx199 x200
    hx200 x201 hx201 x202 hx202 x203 hx203 x204 hx204 x205 hx205 x206 hx206 x207 hx207 x208 hx208
    x209 hx209 x210 hx210 x211 hx211 x212 hx212 x213 hx213 x214 hx214 x215 hx215 x216 hx216 x217
    hx217 x218 hx218 x219 hx219 x220 hx220 x221 hx221 x222 hx222 x223 hx223 x224 hx224 x225 hx225
    x226 hx226 x227 hx227 x228 hx228 x229 hx229 x230 hx230 x231 hx231 x232 hx232 x233 hx233 x234
    hx234 x235 hx235 x236 hx236 x237 hx237 x238 hx238 x239 hx239 x240 hx240 x241 hx241 x242 hx242
    x243 hx243 x244 hx244 x245 hx245 x246 hx246 x247 hx247 x248 hx248 x249 hx249 x250 hx250 x251
    hx251 x252 hx252 x253 hx253 x254 hx254 x255 hx255 x256 hx256 x257 hx257 x258 hx258 x259 hx259
    x260 hx260 x261 hx261 x262 hx262 x263 hx263 x264 hx264 x265 hx265 x266 hx266 x267 hx267 x268
    hx268 x269 hx269 x270 hx270 x271 hx271 x272 hx272 x273 hx273 x274 hx274 x275 hx275 x276 hx276
    x277 hx277 x278 hx278 x279 hx279
  have h4 : (Fe.mk5 x274 x275 x276 x277 x279 4).toNat < 2 ^ 32 := by
    rw [hc]; exact (scalar.reduce64.limbs_canonical _).1.top_lt
  limbs_fit sc
  clear hp hlw_fits hbuf_fits hp63 hread_lw_8 hread_lw_16 hread_lw_24 hread_lw_32 hread_lw_40
    hread_lw_48 hread_lw_56 hread_lw_64 hread_lw hread_buf
  have f0 : Fits S.mem sc (Ty.bv 64).width := hsc_limbs.2.1
  step_store consuming f0
  step_pure
  have f1 : Fits S.mem (sc.add 8#64) (Ty.bv 64).width := hsc_limbs.2.2.1
  step_store consuming f1
  step_pure
  have f2 : Fits S.mem (sc.add 16#64) (Ty.bv 64).width := hsc_limbs.2.2.2.1
  step_store consuming f2
  step_pure
  have f3 : Fits S.mem (sc.add 24#64) (Ty.bv 64).width := hsc_limbs.2.2.2.2.1
  step_store consuming f3
  step_pure
  have f4 : Fits S.mem (sc.add 32#64) (Ty.bv 64).width := hsc_limbs.2.2.2.2.2
  step_store consuming f4
  read_stores sc, (Fe.mk5 x274 x275 x276 x277 x279) with hL
  step_call using Scalar_toBytes.call_eq_of consuming h4 hL
  step_pure
  step_memcpy
  finish_block
  rw [hS]
  erase_frame
  rw [hc]
  rfl

end Proof

end MLIR.Zig

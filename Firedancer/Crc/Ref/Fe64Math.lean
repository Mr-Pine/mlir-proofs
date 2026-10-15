module

public import Firedancer.Crc.Ref.Fe64
public import Ed25519.Field
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-!
# 4×64 field kernels: the arithmetic

`Fe64.mul X Y` is `X·Y` and `Fe64.sqr X` is `X²` mod `p = 2^255 - 19`, both below `2^255 + 2^11`,
for any 256-bit inputs. Each C statement gives an exact integer equation (a carry chain step, a
128-bit product's halves, a sum that does not wrap); weighted sums of them give the results.
-/

namespace MLIR.Firedancer.Crc.Ref.Fe64

/-! ## Word facts -/

theorem toNat_limbs (X : BitVec 256) :
    (X.toNat : ℤ) = (X.extractLsb' 0 64).toNat + 2 ^ 64 * (X.extractLsb' 64 64).toNat +
      2 ^ 128 * (X.extractLsb' 128 64).toNat + 2 ^ 192 * (X.extractLsb' 192 64).toNat := by
  have h := X.isLt
  simp only [BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  omega

theorem toNat_append' (x : BitVec m) (y : BitVec n) : (x ++ y).toNat = x.toNat * 2 ^ n
    + y.toNat := by
  rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt y.isLt, Nat.shiftLeft_eq]

theorem toNat_concat4 (a b c d : BitVec 64) :
    ((a ++ (b ++ (c ++ d))).toNat : ℤ) =
      d.toNat + 2 ^ 64 * c.toNat + 2 ^ 128 * b.toNat + 2 ^ 192 * a.toNat := by
  simp only [toNat_append']
  push_cast
  ring

theorem le_max (a : BitVec 64) : a.toNat ≤ 18446744073709551615 := by
  have := a.isLt; omega

theorem prod_le (a b : BitVec 64) :
    (a.toNat : ℤ) * b.toNat ≤ 340282366920938463426481119284349108225 := by
  have h := Nat.mul_le_mul (le_max a) (le_max b)
  exact_mod_cast h

theorem split_mul (a b : BitVec 64) :
    (((a.setWidth 128 * b.setWidth 128).setWidth 64).toNat : ℤ) +
        2 ^ 64 * (((a.setWidth 128 * b.setWidth 128) >>> 64).setWidth 64).toNat =
      a.toNat * b.toNat := by
  have h := Nat.mul_le_mul (le_max a) (le_max b)
  have ha := a.isLt; have hb := b.isLt
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_mul,
    Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (a := a.toNat) (by omega), Nat.mod_eq_of_lt (a := b.toNat) (by omega),
    Nat.mod_eq_of_lt (a := a.toNat * b.toNat) (by omega)]
  have : a.toNat * b.toNat / 2 ^ 64 < 2 ^ 64 := by omega
  rw [Nat.mod_eq_of_lt this]
  have := Nat.mod_add_div (a.toNat * b.toNat) (2 ^ 64)
  omega

theorem split_mul38 (a : BitVec 64) :
    (((a.setWidth 128 * 38#128).setWidth 64).toNat : ℤ) +
        2 ^ 64 * (((a.setWidth 128 * 38#128) >>> 64).setWidth 64).toNat = a.toNat * 38 := by
  have ha := a.isLt
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_mul,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (a := a.toNat) (by omega)]
  omega

theorem addc_int (a b : BitVec 64) :
    ((a + b).toNat : ℤ) + 2 ^ 64 * (carry a b).toNat = a.toNat + b.toNat := by
  have ha := a.isLt; have hb := b.isLt
  simp only [carry, BitVec.toNat_add, BitVec.uaddOverflow]
  by_cases h : 2 ^ 64 ≤ a.toNat + b.toNat
  · simp only [h, decide_true, BitVec.ofBool_true]
    have : (BitVec.setWidth 64 (1 : BitVec 1)).toNat = 1 := rfl
    omega
  · simp only [h, decide_false, BitVec.ofBool_false]
    have : (BitVec.setWidth 64 (0 : BitVec 1)).toNat = 0 := rfl
    omega

theorem or_carry (u v w : BitVec 64) (hw : w.toNat ≤ 1) :
    ((carry u v ||| carry w (u + v)).toNat : ℤ) =
      (carry u v).toNat + (carry w (u + v)).toNat := by
  have hw' : w ≤ 1#64 := hw
  have h : carry u v ||| carry w (u + v) = carry u v + carry w (u + v) := by
    simp only [carry]; bv_decide
  rw [h, BitVec.toNat_add, Nat.mod_eq_of_lt]
  · push_cast; rfl
  · have := carry_le (t := carry u v) rfl; have := carry_le (t := carry w (u + v)) rfl; omega

theorem add_exact {a b : BitVec 64} (ha : a.toNat ≤ A) (hb : b.toNat ≤ B)
    (h : A + B < 2 ^ 64 := by decide) : ((a + b).toNat : ℤ) = a.toNat + b.toNat := by
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]; push_cast; rfl

theorem add_exact_of_lt {a b : BitVec 64} (h : (a.toNat : ℤ) + b.toNat < 2 ^ 64) :
    ((a + b).toNat : ℤ) = a.toNat + b.toNat := by
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]; push_cast; rfl

theorem mul2_exact {a : BitVec 64} (ha : a.toNat ≤ A) (h : 2 * A < 2 ^ 64 := by decide) :
    ((a * 2#64).toNat : ℤ) = 2 * a.toNat := by
  have h2 : (2#64).toNat = 2 := rfl
  rw [BitVec.toNat_mul, h2, Nat.mod_eq_of_lt (by omega)]; push_cast; omega

theorem mul19_exact {a : BitVec 64} (ha : a.toNat ≤ A) (h : 19 * A < 2 ^ 64 := by decide) :
    ((a * 19#64).toNat : ℤ) = 19 * a.toNat := by
  have h2 : (19#64).toNat = 19 := rfl
  rw [BitVec.toNat_mul, h2, Nat.mod_eq_of_lt (by omega)]; push_cast; omega

theorem split63 (a : BitVec 64) :
    2 ^ 63 * ((a >>> 63).toNat : ℤ) + (a &&& 9223372036854775807#64).toNat = a.toNat := by
  have h : (a &&& 9223372036854775807#64).toNat = a.toNat % 2 ^ 63 := by
    rw [BitVec.toNat_and, show (9223372036854775807#64).toNat = 2 ^ 63 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod]
  rw [h, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have := Nat.mod_add_div a.toNat (2 ^ 63)
  omega

/-! ## Bounds, closed forms -/

theorem carry_le' (a b : BitVec 64) : (carry a b).toNat ≤ 1 := carry_le rfl

theorem or_le' {u v : BitVec 64} (hu : u.toNat ≤ 1) (hv : v.toNat ≤ 1) : (u ||| v).toNat ≤ 1 := by
  have hu' : u ≤ 1#64 := hu
  have hv' : v ≤ 1#64 := hv
  have : u ||| v ≤ 1#64 := by bv_decide
  exact this

theorem hi_le' (a b : BitVec 64) :
    (((a.setWidth 128 * b.setWidth 128) >>> 64).setWidth 64).toNat ≤ 18446744073709551614 :=
  hi_le rfl

theorem hi38_le' (a : BitVec 64) : (((a.setWidth 128 * 38#128) >>> 64).setWidth 64).toNat ≤ 37 :=
  hi38_le rfl

theorem add_le' {a b : BitVec 64} (ha : a.toNat ≤ A) (hb : b.toNat ≤ B)
    (h : A + B < 2 ^ 64 := by decide) : (a + b).toNat ≤ A + B :=
  add_le rfl ha hb h

theorem mul2_le' {a : BitVec 64} (ha : a.toNat ≤ A) (h : 2 * A < 2 ^ 64 := by decide) :
    (a * 2#64).toNat ≤ 2 * A := by
  have h2 : (2#64).toNat = 2 := rfl
  rw [BitVec.toNat_mul, h2, Nat.mod_eq_of_lt (by omega)]; omega

theorem mul19_le' {a : BitVec 64} (ha : a.toNat ≤ A) (h : 19 * A < 2 ^ 64 := by decide) :
    (a * 19#64).toNat ≤ 19 * A := by
  have h2 : (19#64).toNat = 19 := rfl
  rw [BitVec.toNat_mul, h2, Nat.mod_eq_of_lt (by omega)]; omega

theorem top_le' (a : BitVec 64) : (a >>> 63).toNat ≤ 1 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; have := a.isLt; omega

theorem mask_le' (a : BitVec 64) : (a &&& 9223372036854775807#64).toNat ≤ 9223372036854775807 :=
  mask_le rfl

/-! ## The kernels -/

set_option exponentiation.threshold 600 in
theorem mul_row_t226 {t1_lo t225 t17_lo t49_lo t94_lo t151_lo t151_hi x0 y0 y1 x1 x2 x3 t1_hi t6_lo
    t6_hi t26_lo t26_hi t69_lo t69_hi t29_lo t29_hi t72_lo t72_hi t9_lo t9_hi t32_lo c32 t32_hi
    t75_lo c75 t75_hi t135 t14_lo t14_hi t43_lo t43_hi t81_lo t81_hi t88_lo t88_hi t138_lo t138_hi
    t145_lo t145_hi t38_lo t38_hi t84_lo c84 t84_hi t141_lo c141 t141_hi t46_lo t46_hi t91_lo
    t91_hi t148_lo t148_hi t17_hi c49 t49_hi c94 t94_hi c151 : ℤ}
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * y0)
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x1 * y0)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x2 * y0)
    (f_t69_lo : t69_lo + 2 ^ 64 * t69_hi = x3 * y0)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t72_lo : t72_lo + 2 ^ 64 * t72_hi = t26_hi + t69_lo)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t1_hi + t6_lo)
    (f_t32_lo : t32_lo + 2 ^ 64 * c32 = t9_hi + t29_lo)
    (g_t32_hi : t32_hi = t29_hi + c32)
    (f_t75_lo : t75_lo + 2 ^ 64 * c75 = t32_hi + t72_lo)
    (g_t75_hi : t75_hi = t72_hi + c75)
    (f_t135 : t135 = t69_hi + t75_hi)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = x0 * y1)
    (f_t43_lo : t43_lo + 2 ^ 64 * t43_hi = x1 * y1)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t75_lo + t43_hi)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * y1)
    (f_t138_lo : t138_lo + 2 ^ 64 * t138_hi = t135 + t88_hi)
    (f_t145_lo : t145_lo + 2 ^ 64 * t145_hi = x3 * y1)
    (f_t38_lo : t38_lo + 2 ^ 64 * t38_hi = t32_lo + t14_hi)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t38_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t141_lo : t141_lo + 2 ^ 64 * c141 = t84_hi + t138_lo)
    (g_t141_hi : t141_hi = t138_hi + c141)
    (f_t225 : t225 = t141_hi + t145_hi)
    (f_t46_lo : t46_lo + 2 ^ 64 * t46_hi = t38_lo + t43_lo)
    (f_t91_lo : t91_lo + 2 ^ 64 * t91_hi = t84_lo + t88_lo)
    (f_t148_lo : t148_lo + 2 ^ 64 * t148_hi = t141_lo + t145_lo)
    (f_t17_lo : t17_lo + 2 ^ 64 * t17_hi = t9_lo + t14_lo)
    (f_t49_lo : t49_lo + 2 ^ 64 * c49 = t17_hi + t46_lo)
    (g_t49_hi : t49_hi = t46_hi + c49)
    (f_t94_lo : t94_lo + 2 ^ 64 * c94 = t49_hi + t91_lo)
    (g_t94_hi : t94_hi = t91_hi + c94)
    (f_t151_lo : t151_lo + 2 ^ 64 * c151 = t94_hi + t148_lo)
    (g_t151_hi : t151_hi = t148_hi + c151) :
    t1_lo + 2 ^ 320 * t225 + 2 ^ 64 * t17_lo + 2 ^ 128 * t49_lo + 2 ^ 192 * t94_lo
        + 2 ^ 256 * t151_lo + 2 ^ 320 * t151_hi = x0 * y0 + 2 ^ 64 * x0 * y1 + 2 ^ 64 * x1 * y0
        + 2 ^ 128 * x1 * y1 + 2 ^ 128 * x2 * y0 + 2 ^ 192 * x2 * y1 + 2 ^ 192 * x3 * y0
        + 2 ^ 256 * x3 * y1 := by
  linear_combination f_t1_lo + 2 ^ 64 * f_t6_lo + 2 ^ 128 * f_t26_lo + 2 ^ 192 * f_t69_lo
      + 2 ^ 128 * f_t29_lo + 2 ^ 192 * f_t72_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t32_lo
      + 2 ^ 192 * g_t32_hi + 2 ^ 192 * f_t75_lo + 2 ^ 256 * g_t75_hi + 2 ^ 256 * f_t135
      + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t43_lo + 2 ^ 192 * f_t81_lo + 2 ^ 192 * f_t88_lo
      + 2 ^ 256 * f_t138_lo + 2 ^ 256 * f_t145_lo + 2 ^ 128 * f_t38_lo + 2 ^ 192 * f_t84_lo
      + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t141_lo + 2 ^ 320 * g_t141_hi + 2 ^ 320 * f_t225
      + 2 ^ 128 * f_t46_lo + 2 ^ 192 * f_t91_lo + 2 ^ 256 * f_t148_lo + 2 ^ 64 * f_t17_lo
      + 2 ^ 128 * f_t49_lo + 2 ^ 192 * g_t49_hi + 2 ^ 192 * f_t94_lo + 2 ^ 256 * g_t94_hi
      + 2 ^ 256 * f_t151_lo + 2 ^ 320 * g_t151_hi

set_option exponentiation.threshold 600 in
theorem mul_row_t300 {t1_lo t17_lo t299 t56_lo t111_lo t170_lo t242_lo t242_hi x0 y0 y1 y2 x1 x2 x3
    t1_hi t6_lo t6_hi t26_lo t26_hi t69_lo t69_hi t29_lo t29_hi t72_lo t72_hi t9_lo t9_hi t32_lo
    c32 t32_hi t75_lo c75 t75_hi t135 t14_lo t14_hi t43_lo t43_hi t81_lo t81_hi t88_lo t88_hi
    t138_lo t138_hi t145_lo t145_hi t38_lo t38_hi t84_lo c84 t84_hi t141_lo c141 t141_hi t225
    t46_lo t46_hi t91_lo t91_hi t148_lo t148_hi t17_hi t49_lo c49 t49_hi t94_lo c94 t94_hi t151_lo
    c151 t151_hi t226 t53_lo t53_hi t105_lo t105_hi t157_lo t157_hi t164_lo t164_hi t229_lo t229_hi
    t236_lo t236_hi t100_lo t100_hi t160_lo c160 t160_hi t232_lo c232 t232_hi t108_lo t108_hi
    t167_lo t167_hi t239_lo t239_hi t56_hi c111 t111_hi c170 t170_hi c242 : ℤ}
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * y0)
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x1 * y0)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x2 * y0)
    (f_t69_lo : t69_lo + 2 ^ 64 * t69_hi = x3 * y0)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t72_lo : t72_lo + 2 ^ 64 * t72_hi = t26_hi + t69_lo)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t1_hi + t6_lo)
    (f_t32_lo : t32_lo + 2 ^ 64 * c32 = t9_hi + t29_lo)
    (g_t32_hi : t32_hi = t29_hi + c32)
    (f_t75_lo : t75_lo + 2 ^ 64 * c75 = t32_hi + t72_lo)
    (g_t75_hi : t75_hi = t72_hi + c75)
    (f_t135 : t135 = t69_hi + t75_hi)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = x0 * y1)
    (f_t43_lo : t43_lo + 2 ^ 64 * t43_hi = x1 * y1)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t75_lo + t43_hi)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * y1)
    (f_t138_lo : t138_lo + 2 ^ 64 * t138_hi = t135 + t88_hi)
    (f_t145_lo : t145_lo + 2 ^ 64 * t145_hi = x3 * y1)
    (f_t38_lo : t38_lo + 2 ^ 64 * t38_hi = t32_lo + t14_hi)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t38_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t141_lo : t141_lo + 2 ^ 64 * c141 = t84_hi + t138_lo)
    (g_t141_hi : t141_hi = t138_hi + c141)
    (f_t225 : t225 = t141_hi + t145_hi)
    (f_t46_lo : t46_lo + 2 ^ 64 * t46_hi = t38_lo + t43_lo)
    (f_t91_lo : t91_lo + 2 ^ 64 * t91_hi = t84_lo + t88_lo)
    (f_t148_lo : t148_lo + 2 ^ 64 * t148_hi = t141_lo + t145_lo)
    (f_t17_lo : t17_lo + 2 ^ 64 * t17_hi = t9_lo + t14_lo)
    (f_t49_lo : t49_lo + 2 ^ 64 * c49 = t17_hi + t46_lo)
    (g_t49_hi : t49_hi = t46_hi + c49)
    (f_t94_lo : t94_lo + 2 ^ 64 * c94 = t49_hi + t91_lo)
    (g_t94_hi : t94_hi = t91_hi + c94)
    (f_t151_lo : t151_lo + 2 ^ 64 * c151 = t94_hi + t148_lo)
    (g_t151_hi : t151_hi = t148_hi + c151)
    (f_t226 : t226 = t151_hi + t225)
    (f_t53_lo : t53_lo + 2 ^ 64 * t53_hi = x0 * y2)
    (f_t105_lo : t105_lo + 2 ^ 64 * t105_hi = x1 * y2)
    (f_t157_lo : t157_lo + 2 ^ 64 * t157_hi = t151_lo + t105_hi)
    (f_t164_lo : t164_lo + 2 ^ 64 * t164_hi = x2 * y2)
    (f_t229_lo : t229_lo + 2 ^ 64 * t229_hi = t226 + t164_hi)
    (f_t236_lo : t236_lo + 2 ^ 64 * t236_hi = x3 * y2)
    (f_t100_lo : t100_lo + 2 ^ 64 * t100_hi = t94_lo + t53_hi)
    (f_t160_lo : t160_lo + 2 ^ 64 * c160 = t100_hi + t157_lo)
    (g_t160_hi : t160_hi = t157_hi + c160)
    (f_t232_lo : t232_lo + 2 ^ 64 * c232 = t160_hi + t229_lo)
    (g_t232_hi : t232_hi = t229_hi + c232)
    (f_t299 : t299 = t232_hi + t236_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = t100_lo + t105_lo)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t160_lo + t164_lo)
    (f_t239_lo : t239_lo + 2 ^ 64 * t239_hi = t232_lo + t236_lo)
    (f_t56_lo : t56_lo + 2 ^ 64 * t56_hi = t49_lo + t53_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * c111 = t56_hi + t108_lo)
    (g_t111_hi : t111_hi = t108_hi + c111)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t111_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t242_lo : t242_lo + 2 ^ 64 * c242 = t170_hi + t239_lo)
    (g_t242_hi : t242_hi = t239_hi + c242) :
    t1_lo + 2 ^ 64 * t17_lo + 2 ^ 384 * t299 + 2 ^ 128 * t56_lo + 2 ^ 192 * t111_lo
        + 2 ^ 256 * t170_lo + 2 ^ 320 * t242_lo + 2 ^ 384 * t242_hi = x0 * y0 + 2 ^ 64 * x0 * y1
        + 2 ^ 128 * x0 * y2 + 2 ^ 64 * x1 * y0 + 2 ^ 128 * x1 * y1 + 2 ^ 192 * x1 * y2
        + 2 ^ 128 * x2 * y0 + 2 ^ 192 * x2 * y1 + 2 ^ 256 * x2 * y2 + 2 ^ 192 * x3 * y0
        + 2 ^ 256 * x3 * y1 + 2 ^ 320 * x3 * y2 := by
  linear_combination f_t1_lo + 2 ^ 64 * f_t6_lo + 2 ^ 128 * f_t26_lo + 2 ^ 192 * f_t69_lo
      + 2 ^ 128 * f_t29_lo + 2 ^ 192 * f_t72_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t32_lo
      + 2 ^ 192 * g_t32_hi + 2 ^ 192 * f_t75_lo + 2 ^ 256 * g_t75_hi + 2 ^ 256 * f_t135
      + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t43_lo + 2 ^ 192 * f_t81_lo + 2 ^ 192 * f_t88_lo
      + 2 ^ 256 * f_t138_lo + 2 ^ 256 * f_t145_lo + 2 ^ 128 * f_t38_lo + 2 ^ 192 * f_t84_lo
      + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t141_lo + 2 ^ 320 * g_t141_hi + 2 ^ 320 * f_t225
      + 2 ^ 128 * f_t46_lo + 2 ^ 192 * f_t91_lo + 2 ^ 256 * f_t148_lo + 2 ^ 64 * f_t17_lo
      + 2 ^ 128 * f_t49_lo + 2 ^ 192 * g_t49_hi + 2 ^ 192 * f_t94_lo + 2 ^ 256 * g_t94_hi
      + 2 ^ 256 * f_t151_lo + 2 ^ 320 * g_t151_hi + 2 ^ 320 * f_t226 + 2 ^ 128 * f_t53_lo
      + 2 ^ 192 * f_t105_lo + 2 ^ 256 * f_t157_lo + 2 ^ 256 * f_t164_lo + 2 ^ 320 * f_t229_lo
      + 2 ^ 320 * f_t236_lo + 2 ^ 192 * f_t100_lo + 2 ^ 256 * f_t160_lo + 2 ^ 320 * g_t160_hi
      + 2 ^ 320 * f_t232_lo + 2 ^ 384 * g_t232_hi + 2 ^ 384 * f_t299 + 2 ^ 192 * f_t108_lo
      + 2 ^ 256 * f_t167_lo + 2 ^ 320 * f_t239_lo + 2 ^ 128 * f_t56_lo + 2 ^ 192 * f_t111_lo
      + 2 ^ 256 * g_t111_hi + 2 ^ 256 * f_t170_lo + 2 ^ 320 * g_t170_hi + 2 ^ 320 * f_t242_lo
      + 2 ^ 384 * g_t242_hi

set_option exponentiation.threshold 600 in
theorem mul_row_t351 {t1_lo t17_lo t56_lo t350 t118_lo t187_lo t261_lo t316_lo t316_hi x0 y0 y1 y2
    y3 x1 x2 x3 t1_hi t6_lo t6_hi t26_lo t26_hi t69_lo t69_hi t29_lo t29_hi t72_lo t72_hi t9_lo
    t9_hi t32_lo c32 t32_hi t75_lo c75 t75_hi t135 t14_lo t14_hi t43_lo t43_hi t81_lo t81_hi t88_lo
    t88_hi t138_lo t138_hi t145_lo t145_hi t38_lo t38_hi t84_lo c84 t84_hi t141_lo c141 t141_hi
    t225 t46_lo t46_hi t91_lo t91_hi t148_lo t148_hi t17_hi t49_lo c49 t49_hi t94_lo c94 t94_hi
    t151_lo c151 t151_hi t226 t53_lo t53_hi t105_lo t105_hi t157_lo t157_hi t164_lo t164_hi t229_lo
    t229_hi t236_lo t236_hi t100_lo t100_hi t160_lo c160 t160_hi t232_lo c232 t232_hi t299 t108_lo
    t108_hi t167_lo t167_hi t239_lo t239_hi t56_hi t111_lo c111 t111_hi t170_lo c170 t170_hi
    t242_lo c242 t242_hi t300 t115_lo t115_hi t181_lo t181_hi t248_lo t248_hi t255_lo t255_hi
    t303_lo t303_hi t310_lo t310_hi t176_lo t176_hi t251_lo c251 t251_hi t306_lo c306 t306_hi
    t184_lo t184_hi t258_lo t258_hi t313_lo t313_hi t118_hi c187 t187_hi c261 t261_hi c316 : ℤ}
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * y0)
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x1 * y0)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x2 * y0)
    (f_t69_lo : t69_lo + 2 ^ 64 * t69_hi = x3 * y0)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t72_lo : t72_lo + 2 ^ 64 * t72_hi = t26_hi + t69_lo)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t1_hi + t6_lo)
    (f_t32_lo : t32_lo + 2 ^ 64 * c32 = t9_hi + t29_lo)
    (g_t32_hi : t32_hi = t29_hi + c32)
    (f_t75_lo : t75_lo + 2 ^ 64 * c75 = t32_hi + t72_lo)
    (g_t75_hi : t75_hi = t72_hi + c75)
    (f_t135 : t135 = t69_hi + t75_hi)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = x0 * y1)
    (f_t43_lo : t43_lo + 2 ^ 64 * t43_hi = x1 * y1)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t75_lo + t43_hi)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * y1)
    (f_t138_lo : t138_lo + 2 ^ 64 * t138_hi = t135 + t88_hi)
    (f_t145_lo : t145_lo + 2 ^ 64 * t145_hi = x3 * y1)
    (f_t38_lo : t38_lo + 2 ^ 64 * t38_hi = t32_lo + t14_hi)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t38_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t141_lo : t141_lo + 2 ^ 64 * c141 = t84_hi + t138_lo)
    (g_t141_hi : t141_hi = t138_hi + c141)
    (f_t225 : t225 = t141_hi + t145_hi)
    (f_t46_lo : t46_lo + 2 ^ 64 * t46_hi = t38_lo + t43_lo)
    (f_t91_lo : t91_lo + 2 ^ 64 * t91_hi = t84_lo + t88_lo)
    (f_t148_lo : t148_lo + 2 ^ 64 * t148_hi = t141_lo + t145_lo)
    (f_t17_lo : t17_lo + 2 ^ 64 * t17_hi = t9_lo + t14_lo)
    (f_t49_lo : t49_lo + 2 ^ 64 * c49 = t17_hi + t46_lo)
    (g_t49_hi : t49_hi = t46_hi + c49)
    (f_t94_lo : t94_lo + 2 ^ 64 * c94 = t49_hi + t91_lo)
    (g_t94_hi : t94_hi = t91_hi + c94)
    (f_t151_lo : t151_lo + 2 ^ 64 * c151 = t94_hi + t148_lo)
    (g_t151_hi : t151_hi = t148_hi + c151)
    (f_t226 : t226 = t151_hi + t225)
    (f_t53_lo : t53_lo + 2 ^ 64 * t53_hi = x0 * y2)
    (f_t105_lo : t105_lo + 2 ^ 64 * t105_hi = x1 * y2)
    (f_t157_lo : t157_lo + 2 ^ 64 * t157_hi = t151_lo + t105_hi)
    (f_t164_lo : t164_lo + 2 ^ 64 * t164_hi = x2 * y2)
    (f_t229_lo : t229_lo + 2 ^ 64 * t229_hi = t226 + t164_hi)
    (f_t236_lo : t236_lo + 2 ^ 64 * t236_hi = x3 * y2)
    (f_t100_lo : t100_lo + 2 ^ 64 * t100_hi = t94_lo + t53_hi)
    (f_t160_lo : t160_lo + 2 ^ 64 * c160 = t100_hi + t157_lo)
    (g_t160_hi : t160_hi = t157_hi + c160)
    (f_t232_lo : t232_lo + 2 ^ 64 * c232 = t160_hi + t229_lo)
    (g_t232_hi : t232_hi = t229_hi + c232)
    (f_t299 : t299 = t232_hi + t236_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = t100_lo + t105_lo)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t160_lo + t164_lo)
    (f_t239_lo : t239_lo + 2 ^ 64 * t239_hi = t232_lo + t236_lo)
    (f_t56_lo : t56_lo + 2 ^ 64 * t56_hi = t49_lo + t53_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * c111 = t56_hi + t108_lo)
    (g_t111_hi : t111_hi = t108_hi + c111)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t111_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t242_lo : t242_lo + 2 ^ 64 * c242 = t170_hi + t239_lo)
    (g_t242_hi : t242_hi = t239_hi + c242)
    (f_t300 : t300 = t242_hi + t299)
    (f_t115_lo : t115_lo + 2 ^ 64 * t115_hi = x0 * y3)
    (f_t181_lo : t181_lo + 2 ^ 64 * t181_hi = x1 * y3)
    (f_t248_lo : t248_lo + 2 ^ 64 * t248_hi = t242_lo + t181_hi)
    (f_t255_lo : t255_lo + 2 ^ 64 * t255_hi = x2 * y3)
    (f_t303_lo : t303_lo + 2 ^ 64 * t303_hi = t300 + t255_hi)
    (f_t310_lo : t310_lo + 2 ^ 64 * t310_hi = x3 * y3)
    (f_t176_lo : t176_lo + 2 ^ 64 * t176_hi = t170_lo + t115_hi)
    (f_t251_lo : t251_lo + 2 ^ 64 * c251 = t176_hi + t248_lo)
    (g_t251_hi : t251_hi = t248_hi + c251)
    (f_t306_lo : t306_lo + 2 ^ 64 * c306 = t251_hi + t303_lo)
    (g_t306_hi : t306_hi = t303_hi + c306)
    (f_t350 : t350 = t306_hi + t310_hi)
    (f_t184_lo : t184_lo + 2 ^ 64 * t184_hi = t176_lo + t181_lo)
    (f_t258_lo : t258_lo + 2 ^ 64 * t258_hi = t251_lo + t255_lo)
    (f_t313_lo : t313_lo + 2 ^ 64 * t313_hi = t306_lo + t310_lo)
    (f_t118_lo : t118_lo + 2 ^ 64 * t118_hi = t111_lo + t115_lo)
    (f_t187_lo : t187_lo + 2 ^ 64 * c187 = t118_hi + t184_lo)
    (g_t187_hi : t187_hi = t184_hi + c187)
    (f_t261_lo : t261_lo + 2 ^ 64 * c261 = t187_hi + t258_lo)
    (g_t261_hi : t261_hi = t258_hi + c261)
    (f_t316_lo : t316_lo + 2 ^ 64 * c316 = t261_hi + t313_lo)
    (g_t316_hi : t316_hi = t313_hi + c316) :
    t1_lo + 2 ^ 64 * t17_lo + 2 ^ 128 * t56_lo + 2 ^ 448 * t350 + 2 ^ 192 * t118_lo
        + 2 ^ 256 * t187_lo + 2 ^ 320 * t261_lo + 2 ^ 384 * t316_lo + 2 ^ 448 * t316_hi = x0 * y0
        + 2 ^ 64 * x0 * y1 + 2 ^ 128 * x0 * y2 + 2 ^ 192 * x0 * y3 + 2 ^ 64 * x1 * y0
        + 2 ^ 128 * x1 * y1 + 2 ^ 192 * x1 * y2 + 2 ^ 256 * x1 * y3 + 2 ^ 128 * x2 * y0
        + 2 ^ 192 * x2 * y1 + 2 ^ 256 * x2 * y2 + 2 ^ 320 * x2 * y3 + 2 ^ 192 * x3 * y0
        + 2 ^ 256 * x3 * y1 + 2 ^ 320 * x3 * y2 + 2 ^ 384 * x3 * y3 := by
  linear_combination f_t1_lo + 2 ^ 64 * f_t6_lo + 2 ^ 128 * f_t26_lo + 2 ^ 192 * f_t69_lo
      + 2 ^ 128 * f_t29_lo + 2 ^ 192 * f_t72_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t32_lo
      + 2 ^ 192 * g_t32_hi + 2 ^ 192 * f_t75_lo + 2 ^ 256 * g_t75_hi + 2 ^ 256 * f_t135
      + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t43_lo + 2 ^ 192 * f_t81_lo + 2 ^ 192 * f_t88_lo
      + 2 ^ 256 * f_t138_lo + 2 ^ 256 * f_t145_lo + 2 ^ 128 * f_t38_lo + 2 ^ 192 * f_t84_lo
      + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t141_lo + 2 ^ 320 * g_t141_hi + 2 ^ 320 * f_t225
      + 2 ^ 128 * f_t46_lo + 2 ^ 192 * f_t91_lo + 2 ^ 256 * f_t148_lo + 2 ^ 64 * f_t17_lo
      + 2 ^ 128 * f_t49_lo + 2 ^ 192 * g_t49_hi + 2 ^ 192 * f_t94_lo + 2 ^ 256 * g_t94_hi
      + 2 ^ 256 * f_t151_lo + 2 ^ 320 * g_t151_hi + 2 ^ 320 * f_t226 + 2 ^ 128 * f_t53_lo
      + 2 ^ 192 * f_t105_lo + 2 ^ 256 * f_t157_lo + 2 ^ 256 * f_t164_lo + 2 ^ 320 * f_t229_lo
      + 2 ^ 320 * f_t236_lo + 2 ^ 192 * f_t100_lo + 2 ^ 256 * f_t160_lo + 2 ^ 320 * g_t160_hi
      + 2 ^ 320 * f_t232_lo + 2 ^ 384 * g_t232_hi + 2 ^ 384 * f_t299 + 2 ^ 192 * f_t108_lo
      + 2 ^ 256 * f_t167_lo + 2 ^ 320 * f_t239_lo + 2 ^ 128 * f_t56_lo + 2 ^ 192 * f_t111_lo
      + 2 ^ 256 * g_t111_hi + 2 ^ 256 * f_t170_lo + 2 ^ 320 * g_t170_hi + 2 ^ 320 * f_t242_lo
      + 2 ^ 384 * g_t242_hi + 2 ^ 384 * f_t300 + 2 ^ 192 * f_t115_lo + 2 ^ 256 * f_t181_lo
      + 2 ^ 320 * f_t248_lo + 2 ^ 320 * f_t255_lo + 2 ^ 384 * f_t303_lo + 2 ^ 384 * f_t310_lo
      + 2 ^ 256 * f_t176_lo + 2 ^ 320 * f_t251_lo + 2 ^ 384 * g_t251_hi + 2 ^ 384 * f_t306_lo
      + 2 ^ 448 * g_t306_hi + 2 ^ 448 * f_t350 + 2 ^ 256 * f_t184_lo + 2 ^ 320 * f_t258_lo
      + 2 ^ 384 * f_t313_lo + 2 ^ 192 * f_t118_lo + 2 ^ 256 * f_t187_lo + 2 ^ 320 * g_t187_hi
      + 2 ^ 320 * f_t261_lo + 2 ^ 384 * g_t261_hi + 2 ^ 384 * f_t316_lo + 2 ^ 448 * g_t316_hi

set_option exponentiation.threshold 600 in
theorem mul_final {t375_lo t384_lo t393_lo t401 t187_lo t261_lo t316_lo t351 t373 x0 x1 x2 x3 y0 y1
    y2 y3 t1_lo t1_hi t6_lo t6_hi t26_lo t26_hi t69_lo t69_hi t29_lo t29_hi t72_lo t72_hi t9_lo
    t9_hi t32_lo c32 t32_hi t75_lo c75 t75_hi t135 t14_lo t14_hi t43_lo t43_hi t81_lo t81_hi t88_lo
    t88_hi t138_lo t138_hi t145_lo t145_hi t38_lo t38_hi t84_lo c84 t84_hi t141_lo c141 t141_hi
    t225 t46_lo t46_hi t91_lo t91_hi t148_lo t148_hi t17_lo t17_hi t49_lo c49 t49_hi t94_lo c94
    t94_hi t151_lo c151 t151_hi t226 t53_lo t53_hi t105_lo t105_hi t157_lo t157_hi t164_lo t164_hi
    t229_lo t229_hi t236_lo t236_hi t100_lo t100_hi t160_lo c160 t160_hi t232_lo c232 t232_hi t299
    t108_lo t108_hi t167_lo t167_hi t239_lo t239_hi t56_lo t56_hi t111_lo c111 t111_hi t170_lo c170
    t170_hi t242_lo c242 t242_hi t300 t115_lo t115_hi t181_lo t181_hi t248_lo t248_hi t255_lo
    t255_hi t303_lo t303_hi t310_lo t310_hi t176_lo t176_hi t251_lo c251 t251_hi t306_lo c306
    t306_hi t350 t184_lo t184_hi t258_lo t258_hi t313_lo t313_hi t118_lo t118_hi c187 t187_hi c261
    t261_hi c316 t316_hi t191_lo t191_hi t265_lo t265_hi t282_lo t282_hi t320_lo t320_hi t337_lo
    t337_hi t352_lo t352_hi t206_lo t206_hi t285_lo c285 t285_hi t340_lo c340 t340_hi t367 t269_lo
    t269_hi t324_lo t324_hi t356_lo t356_hi t195_lo t195_hi t272_lo c272 t272_hi t327_lo c327
    t327_hi t359_lo c359 t359_hi t368 t369 t372 t398 t374 t375_hi t384_hi t393_hi : ℤ}
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * y0)
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x1 * y0)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x2 * y0)
    (f_t69_lo : t69_lo + 2 ^ 64 * t69_hi = x3 * y0)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t72_lo : t72_lo + 2 ^ 64 * t72_hi = t26_hi + t69_lo)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t1_hi + t6_lo)
    (f_t32_lo : t32_lo + 2 ^ 64 * c32 = t9_hi + t29_lo)
    (g_t32_hi : t32_hi = t29_hi + c32)
    (f_t75_lo : t75_lo + 2 ^ 64 * c75 = t32_hi + t72_lo)
    (g_t75_hi : t75_hi = t72_hi + c75)
    (f_t135 : t135 = t69_hi + t75_hi)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = x0 * y1)
    (f_t43_lo : t43_lo + 2 ^ 64 * t43_hi = x1 * y1)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t75_lo + t43_hi)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * y1)
    (f_t138_lo : t138_lo + 2 ^ 64 * t138_hi = t135 + t88_hi)
    (f_t145_lo : t145_lo + 2 ^ 64 * t145_hi = x3 * y1)
    (f_t38_lo : t38_lo + 2 ^ 64 * t38_hi = t32_lo + t14_hi)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t38_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t141_lo : t141_lo + 2 ^ 64 * c141 = t84_hi + t138_lo)
    (g_t141_hi : t141_hi = t138_hi + c141)
    (f_t225 : t225 = t141_hi + t145_hi)
    (f_t46_lo : t46_lo + 2 ^ 64 * t46_hi = t38_lo + t43_lo)
    (f_t91_lo : t91_lo + 2 ^ 64 * t91_hi = t84_lo + t88_lo)
    (f_t148_lo : t148_lo + 2 ^ 64 * t148_hi = t141_lo + t145_lo)
    (f_t17_lo : t17_lo + 2 ^ 64 * t17_hi = t9_lo + t14_lo)
    (f_t49_lo : t49_lo + 2 ^ 64 * c49 = t17_hi + t46_lo)
    (g_t49_hi : t49_hi = t46_hi + c49)
    (f_t94_lo : t94_lo + 2 ^ 64 * c94 = t49_hi + t91_lo)
    (g_t94_hi : t94_hi = t91_hi + c94)
    (f_t151_lo : t151_lo + 2 ^ 64 * c151 = t94_hi + t148_lo)
    (g_t151_hi : t151_hi = t148_hi + c151)
    (f_t226 : t226 = t151_hi + t225)
    (f_t53_lo : t53_lo + 2 ^ 64 * t53_hi = x0 * y2)
    (f_t105_lo : t105_lo + 2 ^ 64 * t105_hi = x1 * y2)
    (f_t157_lo : t157_lo + 2 ^ 64 * t157_hi = t151_lo + t105_hi)
    (f_t164_lo : t164_lo + 2 ^ 64 * t164_hi = x2 * y2)
    (f_t229_lo : t229_lo + 2 ^ 64 * t229_hi = t226 + t164_hi)
    (f_t236_lo : t236_lo + 2 ^ 64 * t236_hi = x3 * y2)
    (f_t100_lo : t100_lo + 2 ^ 64 * t100_hi = t94_lo + t53_hi)
    (f_t160_lo : t160_lo + 2 ^ 64 * c160 = t100_hi + t157_lo)
    (g_t160_hi : t160_hi = t157_hi + c160)
    (f_t232_lo : t232_lo + 2 ^ 64 * c232 = t160_hi + t229_lo)
    (g_t232_hi : t232_hi = t229_hi + c232)
    (f_t299 : t299 = t232_hi + t236_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = t100_lo + t105_lo)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t160_lo + t164_lo)
    (f_t239_lo : t239_lo + 2 ^ 64 * t239_hi = t232_lo + t236_lo)
    (f_t56_lo : t56_lo + 2 ^ 64 * t56_hi = t49_lo + t53_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * c111 = t56_hi + t108_lo)
    (g_t111_hi : t111_hi = t108_hi + c111)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t111_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t242_lo : t242_lo + 2 ^ 64 * c242 = t170_hi + t239_lo)
    (g_t242_hi : t242_hi = t239_hi + c242)
    (f_t300 : t300 = t242_hi + t299)
    (f_t115_lo : t115_lo + 2 ^ 64 * t115_hi = x0 * y3)
    (f_t181_lo : t181_lo + 2 ^ 64 * t181_hi = x1 * y3)
    (f_t248_lo : t248_lo + 2 ^ 64 * t248_hi = t242_lo + t181_hi)
    (f_t255_lo : t255_lo + 2 ^ 64 * t255_hi = x2 * y3)
    (f_t303_lo : t303_lo + 2 ^ 64 * t303_hi = t300 + t255_hi)
    (f_t310_lo : t310_lo + 2 ^ 64 * t310_hi = x3 * y3)
    (f_t176_lo : t176_lo + 2 ^ 64 * t176_hi = t170_lo + t115_hi)
    (f_t251_lo : t251_lo + 2 ^ 64 * c251 = t176_hi + t248_lo)
    (g_t251_hi : t251_hi = t248_hi + c251)
    (f_t306_lo : t306_lo + 2 ^ 64 * c306 = t251_hi + t303_lo)
    (g_t306_hi : t306_hi = t303_hi + c306)
    (f_t350 : t350 = t306_hi + t310_hi)
    (f_t184_lo : t184_lo + 2 ^ 64 * t184_hi = t176_lo + t181_lo)
    (f_t258_lo : t258_lo + 2 ^ 64 * t258_hi = t251_lo + t255_lo)
    (f_t313_lo : t313_lo + 2 ^ 64 * t313_hi = t306_lo + t310_lo)
    (f_t118_lo : t118_lo + 2 ^ 64 * t118_hi = t111_lo + t115_lo)
    (f_t187_lo : t187_lo + 2 ^ 64 * c187 = t118_hi + t184_lo)
    (g_t187_hi : t187_hi = t184_hi + c187)
    (f_t261_lo : t261_lo + 2 ^ 64 * c261 = t187_hi + t258_lo)
    (g_t261_hi : t261_hi = t258_hi + c261)
    (f_t316_lo : t316_lo + 2 ^ 64 * c316 = t261_hi + t313_lo)
    (g_t316_hi : t316_hi = t313_hi + c316)
    (f_t351 : t351 = t316_hi + t350)
    (f_t191_lo : t191_lo + 2 ^ 64 * t191_hi = t187_lo * 38)
    (f_t265_lo : t265_lo + 2 ^ 64 * t265_hi = t261_lo * 38)
    (f_t282_lo : t282_lo + 2 ^ 64 * t282_hi = t56_lo + t265_hi)
    (f_t320_lo : t320_lo + 2 ^ 64 * t320_hi = t316_lo * 38)
    (f_t337_lo : t337_lo + 2 ^ 64 * t337_hi = t118_lo + t320_hi)
    (f_t352_lo : t352_lo + 2 ^ 64 * t352_hi = t351 * 38)
    (f_t206_lo : t206_lo + 2 ^ 64 * t206_hi = t17_lo + t191_hi)
    (f_t285_lo : t285_lo + 2 ^ 64 * c285 = t206_hi + t282_lo)
    (g_t285_hi : t285_hi = t282_hi + c285)
    (f_t340_lo : t340_lo + 2 ^ 64 * c340 = t285_hi + t337_lo)
    (g_t340_hi : t340_hi = t337_hi + c340)
    (f_t367 : t367 = t340_hi + t352_hi)
    (f_t269_lo : t269_lo + 2 ^ 64 * t269_hi = t206_lo + t265_lo)
    (f_t324_lo : t324_lo + 2 ^ 64 * t324_hi = t285_lo + t320_lo)
    (f_t356_lo : t356_lo + 2 ^ 64 * t356_hi = t340_lo + t352_lo)
    (f_t195_lo : t195_lo + 2 ^ 64 * t195_hi = t1_lo + t191_lo)
    (f_t272_lo : t272_lo + 2 ^ 64 * c272 = t195_hi + t269_lo)
    (g_t272_hi : t272_hi = t269_hi + c272)
    (f_t327_lo : t327_lo + 2 ^ 64 * c327 = t272_hi + t324_lo)
    (g_t327_hi : t327_hi = t324_hi + c327)
    (f_t359_lo : t359_lo + 2 ^ 64 * c359 = t327_hi + t356_lo)
    (g_t359_hi : t359_hi = t356_hi + c359)
    (f_t368 : t368 = t359_hi + t367)
    (f_t369 : t369 = 2 * t368)
    (f_t398 : 2 ^ 63 * t372 + t398 = t359_lo)
    (f_t373 : t373 = t369 + t372)
    (f_t374 : t374 = 19 * t373)
    (f_t375_lo : t375_lo + 2 ^ 64 * t375_hi = t195_lo + t374)
    (f_t384_lo : t384_lo + 2 ^ 64 * t384_hi = t272_lo + t375_hi)
    (f_t393_lo : t393_lo + 2 ^ 64 * t393_hi = t327_lo + t384_hi)
    (f_t401 : t401 = t398 + t393_hi) :
    t375_lo + 2 ^ 64 * t384_lo + 2 ^ 128 * t393_lo + 2 ^ 192 * t401
        + (2 ^ 255 - 19) * (2 * (t187_lo + 2 ^ 64 * t261_lo + 2 ^ 128 * t316_lo + 2 ^ 192 * t351)
        + t373) = (x0 + 2 ^ 64 * x1 + 2 ^ 128 * x2 + 2 ^ 192 * x3) * (y0 + 2 ^ 64 * y1
        + 2 ^ 128 * y2 + 2 ^ 192 * y3) := by
  linear_combination f_t1_lo + 2 ^ 64 * f_t6_lo + 2 ^ 128 * f_t26_lo + 2 ^ 192 * f_t69_lo
      + 2 ^ 128 * f_t29_lo + 2 ^ 192 * f_t72_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t32_lo
      + 2 ^ 192 * g_t32_hi + 2 ^ 192 * f_t75_lo + 2 ^ 256 * g_t75_hi + 2 ^ 256 * f_t135
      + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t43_lo + 2 ^ 192 * f_t81_lo + 2 ^ 192 * f_t88_lo
      + 2 ^ 256 * f_t138_lo + 2 ^ 256 * f_t145_lo + 2 ^ 128 * f_t38_lo + 2 ^ 192 * f_t84_lo
      + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t141_lo + 2 ^ 320 * g_t141_hi + 2 ^ 320 * f_t225
      + 2 ^ 128 * f_t46_lo + 2 ^ 192 * f_t91_lo + 2 ^ 256 * f_t148_lo + 2 ^ 64 * f_t17_lo
      + 2 ^ 128 * f_t49_lo + 2 ^ 192 * g_t49_hi + 2 ^ 192 * f_t94_lo + 2 ^ 256 * g_t94_hi
      + 2 ^ 256 * f_t151_lo + 2 ^ 320 * g_t151_hi + 2 ^ 320 * f_t226 + 2 ^ 128 * f_t53_lo
      + 2 ^ 192 * f_t105_lo + 2 ^ 256 * f_t157_lo + 2 ^ 256 * f_t164_lo + 2 ^ 320 * f_t229_lo
      + 2 ^ 320 * f_t236_lo + 2 ^ 192 * f_t100_lo + 2 ^ 256 * f_t160_lo + 2 ^ 320 * g_t160_hi
      + 2 ^ 320 * f_t232_lo + 2 ^ 384 * g_t232_hi + 2 ^ 384 * f_t299 + 2 ^ 192 * f_t108_lo
      + 2 ^ 256 * f_t167_lo + 2 ^ 320 * f_t239_lo + 2 ^ 128 * f_t56_lo + 2 ^ 192 * f_t111_lo
      + 2 ^ 256 * g_t111_hi + 2 ^ 256 * f_t170_lo + 2 ^ 320 * g_t170_hi + 2 ^ 320 * f_t242_lo
      + 2 ^ 384 * g_t242_hi + 2 ^ 384 * f_t300 + 2 ^ 192 * f_t115_lo + 2 ^ 256 * f_t181_lo
      + 2 ^ 320 * f_t248_lo + 2 ^ 320 * f_t255_lo + 2 ^ 384 * f_t303_lo + 2 ^ 384 * f_t310_lo
      + 2 ^ 256 * f_t176_lo + 2 ^ 320 * f_t251_lo + 2 ^ 384 * g_t251_hi + 2 ^ 384 * f_t306_lo
      + 2 ^ 448 * g_t306_hi + 2 ^ 448 * f_t350 + 2 ^ 256 * f_t184_lo + 2 ^ 320 * f_t258_lo
      + 2 ^ 384 * f_t313_lo + 2 ^ 192 * f_t118_lo + 2 ^ 256 * f_t187_lo + 2 ^ 320 * g_t187_hi
      + 2 ^ 320 * f_t261_lo + 2 ^ 384 * g_t261_hi + 2 ^ 384 * f_t316_lo + 2 ^ 448 * g_t316_hi
      + 2 ^ 448 * f_t351 + f_t191_lo + 2 ^ 64 * f_t265_lo + 2 ^ 128 * f_t282_lo
      + 2 ^ 128 * f_t320_lo + 2 ^ 192 * f_t337_lo + 2 ^ 192 * f_t352_lo + 2 ^ 64 * f_t206_lo
      + 2 ^ 128 * f_t285_lo + 2 ^ 192 * g_t285_hi + 2 ^ 192 * f_t340_lo + 2 ^ 256 * g_t340_hi
      + 2 ^ 256 * f_t367 + 2 ^ 64 * f_t269_lo + 2 ^ 128 * f_t324_lo + 2 ^ 192 * f_t356_lo
      + f_t195_lo + 2 ^ 64 * f_t272_lo + 2 ^ 128 * g_t272_hi + 2 ^ 128 * f_t327_lo
      + 2 ^ 192 * g_t327_hi + 2 ^ 192 * f_t359_lo + 2 ^ 256 * g_t359_hi + 2 ^ 256 * f_t368
      + 2 ^ 255 * f_t369 + 2 ^ 192 * f_t398 + 2 ^ 255 * f_t373 + f_t374 + f_t375_lo
      + 2 ^ 64 * f_t384_lo + 2 ^ 128 * f_t393_lo + 2 ^ 192 * f_t401

set_option exponentiation.threshold 600 in
theorem mul_aux (X Y : BitVec 256) :
    ∃ q : ℤ, ((mul X Y).toNat : ℤ) + (2 ^ 255 - 19) * q = (X.toNat : ℤ) * Y.toNat ∧
      (mul X Y).toNat < 2 ^ 255 + 2 ^ 11 := by
  unfold mul
  extract_lets x0 x1 x2 x3 y0 y1 y2 y3 p1 t1_lo t1_hi p2 t6_lo t6_hi p4 t26_lo t26_hi p7 t69_lo
      t69_hi t29_lo t29_hi t72_lo t72_hi t9_lo t9_hi t32_lo c32 t32_hi t75_lo c75 t75_hi t135 p3
      t14_lo t14_hi p5 t43_lo t43_hi t81_lo t81_hi p8 t88_lo t88_hi t138_lo t138_hi p11 t145_lo
      t145_hi t38_lo t38_hi t84_lo c84 t84_hi t141_lo c141 t141_hi t225 t46_lo t46_hi t91_lo t91_hi
      t148_lo t148_hi t17_lo t17_hi t49_lo c49 t49_hi t94_lo c94 t94_hi t151_lo c151 t151_hi t226
      p6 t53_lo t53_hi p9 t105_lo t105_hi t157_lo t157_hi p12 t164_lo t164_hi t229_lo t229_hi p15
      t236_lo t236_hi t100_lo t100_hi t160_lo c160 t160_hi t232_lo c232 t232_hi t299 t108_lo
      t108_hi t167_lo t167_hi t239_lo t239_hi t56_lo t56_hi t111_lo c111 t111_hi t170_lo c170
      t170_hi t242_lo c242 t242_hi t300 p10 t115_lo t115_hi p13 t181_lo t181_hi t248_lo t248_hi p16
      t255_lo t255_hi t303_lo t303_hi p18 t310_lo t310_hi t176_lo t176_hi t251_lo c251 t251_hi
      t306_lo c306 t306_hi t350 t184_lo t184_hi t258_lo t258_hi t313_lo t313_hi t118_lo t118_hi
      t187_lo c187 t187_hi t261_lo c261 t261_hi t316_lo c316 t316_hi t351 p14 t191_lo t191_hi p17
      t265_lo t265_hi t282_lo t282_hi p19 t320_lo t320_hi t337_lo t337_hi p20 t352_lo t352_hi
      t206_lo t206_hi t285_lo c285 t285_hi t340_lo c340 t340_hi t367 t269_lo t269_hi t324_lo
      t324_hi t356_lo t356_hi t195_lo t195_hi t272_lo c272 t272_hi t327_lo c327 t327_hi t359_lo
      c359 t359_hi t368 t369 t372 t373 t398 t374 t375_lo t375_hi t384_lo t384_hi t393_lo t393_hi
      t401
  have hX : (X.toNat : ℤ) = x0.toNat + 2 ^ 64 * x1.toNat + 2 ^ 128 * x2.toNat
      + 2 ^ 192 * x3.toNat :=
    toNat_limbs X
  have hY : (Y.toNat : ℤ) = y0.toNat + 2 ^ 64 * y1.toNat + 2 ^ 128 * y2.toNat
      + 2 ^ 192 * y3.toNat :=
    toNat_limbs Y
  have m_x0_y0 := prod_le x0 y0
  have m_x0_y1 := prod_le x0 y1
  have m_x0_y2 := prod_le x0 y2
  have m_x0_y3 := prod_le x0 y3
  have m_x1_y0 := prod_le x1 y0
  have m_x1_y1 := prod_le x1 y1
  have m_x1_y2 := prod_le x1 y2
  have m_x1_y3 := prod_le x1 y3
  have m_x2_y0 := prod_le x2 y0
  have m_x2_y1 := prod_le x2 y1
  have m_x2_y2 := prod_le x2 y2
  have m_x2_y3 := prod_le x2 y3
  have m_x3_y0 := prod_le x3 y0
  have m_x3_y1 := prod_le x3 y1
  have m_x3_y2 := prod_le x3 y2
  have m_x3_y3 := prod_le x3 y3
  have f_t1_lo : (t1_lo.toNat : ℤ)
      + 2 ^ 64 * (t1_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y0.toNat : ℤ) := split_mul x0 y0
  have f_t6_lo : (t6_lo.toNat : ℤ)
      + 2 ^ 64 * (t6_hi.toNat : ℤ) = (x1.toNat : ℤ) * (y0.toNat : ℤ) := split_mul x1 y0
  have f_t26_lo : (t26_lo.toNat : ℤ)
      + 2 ^ 64 * (t26_hi.toNat : ℤ) = (x2.toNat : ℤ) * (y0.toNat : ℤ) := split_mul x2 y0
  have f_t69_lo : (t69_lo.toNat : ℤ)
      + 2 ^ 64 * (t69_hi.toNat : ℤ) = (x3.toNat : ℤ) * (y0.toNat : ℤ) := split_mul x3 y0
  have f_t29_lo : (t29_lo.toNat : ℤ) + 2 ^ 64 * (t29_hi.toNat : ℤ) = (t6_hi.toNat : ℤ)
      + (t26_lo.toNat : ℤ) := addc_int t6_hi t26_lo
  have f_t72_lo : (t72_lo.toNat : ℤ) + 2 ^ 64 * (t72_hi.toNat : ℤ) = (t26_hi.toNat : ℤ)
      + (t69_lo.toNat : ℤ) := addc_int t26_hi t69_lo
  have f_t9_lo : (t9_lo.toNat : ℤ) + 2 ^ 64 * (t9_hi.toNat : ℤ) = (t1_hi.toNat : ℤ)
      + (t6_lo.toNat : ℤ) := addc_int t1_hi t6_lo
  have f_t32_lo : (t32_lo.toNat : ℤ) + 2 ^ 64 * (c32.toNat : ℤ) = (t9_hi.toNat : ℤ)
      + (t29_lo.toNat : ℤ) := addc_int t9_hi t29_lo
  have b_t9_hi : t9_hi.toNat ≤ 1 := carry_le' t1_hi t6_lo
  have g_t32_hi : (t32_hi.toNat : ℤ) = (t29_hi.toNat : ℤ)
      + (c32.toNat : ℤ) := or_carry t6_hi t26_lo t9_hi (b_t9_hi)
  have f_t75_lo : (t75_lo.toNat : ℤ) + 2 ^ 64 * (c75.toNat : ℤ) = (t32_hi.toNat : ℤ)
      + (t72_lo.toNat : ℤ) := addc_int t32_hi t72_lo
  have b_t29_hi : t29_hi.toNat ≤ 1 := carry_le' t6_hi t26_lo
  have b_c32 : c32.toNat ≤ 1 := carry_le' t9_hi t29_lo
  have b_t32_hi : t32_hi.toNat ≤ 1 := or_le' b_t29_hi b_c32
  have g_t75_hi : (t75_hi.toNat : ℤ) = (t72_hi.toNat : ℤ)
      + (c75.toNat : ℤ) := or_carry t26_hi t69_lo t32_hi (b_t32_hi)
  have b_t69_hi : t69_hi.toNat ≤ 18446744073709551614 := hi_le' x3 y0
  have b_t72_hi : t72_hi.toNat ≤ 1 := carry_le' t26_hi t69_lo
  have b_c75 : c75.toNat ≤ 1 := carry_le' t32_hi t72_lo
  have b_t75_hi : t75_hi.toNat ≤ 1 := or_le' b_t72_hi b_c75
  have f_t135 : (t135.toNat : ℤ) = (t69_hi.toNat : ℤ)
      + (t75_hi.toNat : ℤ) := add_exact b_t69_hi b_t75_hi
  have f_t14_lo : (t14_lo.toNat : ℤ)
      + 2 ^ 64 * (t14_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y1.toNat : ℤ) := split_mul x0 y1
  have f_t43_lo : (t43_lo.toNat : ℤ)
      + 2 ^ 64 * (t43_hi.toNat : ℤ) = (x1.toNat : ℤ) * (y1.toNat : ℤ) := split_mul x1 y1
  have f_t81_lo : (t81_lo.toNat : ℤ) + 2 ^ 64 * (t81_hi.toNat : ℤ) = (t75_lo.toNat : ℤ)
      + (t43_hi.toNat : ℤ) := addc_int t75_lo t43_hi
  have f_t88_lo : (t88_lo.toNat : ℤ)
      + 2 ^ 64 * (t88_hi.toNat : ℤ) = (x2.toNat : ℤ) * (y1.toNat : ℤ) := split_mul x2 y1
  have f_t138_lo : (t138_lo.toNat : ℤ) + 2 ^ 64 * (t138_hi.toNat : ℤ) = (t135.toNat : ℤ)
      + (t88_hi.toNat : ℤ) := addc_int t135 t88_hi
  have f_t145_lo : (t145_lo.toNat : ℤ)
      + 2 ^ 64 * (t145_hi.toNat : ℤ) = (x3.toNat : ℤ) * (y1.toNat : ℤ) := split_mul x3 y1
  have f_t38_lo : (t38_lo.toNat : ℤ) + 2 ^ 64 * (t38_hi.toNat : ℤ) = (t32_lo.toNat : ℤ)
      + (t14_hi.toNat : ℤ) := addc_int t32_lo t14_hi
  have f_t84_lo : (t84_lo.toNat : ℤ) + 2 ^ 64 * (c84.toNat : ℤ) = (t38_hi.toNat : ℤ)
      + (t81_lo.toNat : ℤ) := addc_int t38_hi t81_lo
  have b_t38_hi : t38_hi.toNat ≤ 1 := carry_le' t32_lo t14_hi
  have g_t84_hi : (t84_hi.toNat : ℤ) = (t81_hi.toNat : ℤ)
      + (c84.toNat : ℤ) := or_carry t75_lo t43_hi t38_hi (b_t38_hi)
  have f_t141_lo : (t141_lo.toNat : ℤ) + 2 ^ 64 * (c141.toNat : ℤ) = (t84_hi.toNat : ℤ)
      + (t138_lo.toNat : ℤ) := addc_int t84_hi t138_lo
  have b_t81_hi : t81_hi.toNat ≤ 1 := carry_le' t75_lo t43_hi
  have b_c84 : c84.toNat ≤ 1 := carry_le' t38_hi t81_lo
  have b_t84_hi : t84_hi.toNat ≤ 1 := or_le' b_t81_hi b_c84
  have g_t141_hi : (t141_hi.toNat : ℤ) = (t138_hi.toNat : ℤ)
      + (c141.toNat : ℤ) := or_carry t135 t88_hi t84_hi (b_t84_hi)
  have b_t138_hi : t138_hi.toNat ≤ 1 := carry_le' t135 t88_hi
  have b_c141 : c141.toNat ≤ 1 := carry_le' t84_hi t138_lo
  have b_t141_hi : t141_hi.toNat ≤ 1 := or_le' b_t138_hi b_c141
  have b_t145_hi : t145_hi.toNat ≤ 18446744073709551614 := hi_le' x3 y1
  have f_t225 : (t225.toNat : ℤ) = (t141_hi.toNat : ℤ)
      + (t145_hi.toNat : ℤ) := add_exact b_t141_hi b_t145_hi
  have f_t46_lo : (t46_lo.toNat : ℤ) + 2 ^ 64 * (t46_hi.toNat : ℤ) = (t38_lo.toNat : ℤ)
      + (t43_lo.toNat : ℤ) := addc_int t38_lo t43_lo
  have f_t91_lo : (t91_lo.toNat : ℤ) + 2 ^ 64 * (t91_hi.toNat : ℤ) = (t84_lo.toNat : ℤ)
      + (t88_lo.toNat : ℤ) := addc_int t84_lo t88_lo
  have f_t148_lo : (t148_lo.toNat : ℤ) + 2 ^ 64 * (t148_hi.toNat : ℤ) = (t141_lo.toNat : ℤ)
      + (t145_lo.toNat : ℤ) := addc_int t141_lo t145_lo
  have f_t17_lo : (t17_lo.toNat : ℤ) + 2 ^ 64 * (t17_hi.toNat : ℤ) = (t9_lo.toNat : ℤ)
      + (t14_lo.toNat : ℤ) := addc_int t9_lo t14_lo
  have f_t49_lo : (t49_lo.toNat : ℤ) + 2 ^ 64 * (c49.toNat : ℤ) = (t17_hi.toNat : ℤ)
      + (t46_lo.toNat : ℤ) := addc_int t17_hi t46_lo
  have b_t17_hi : t17_hi.toNat ≤ 1 := carry_le' t9_lo t14_lo
  have g_t49_hi : (t49_hi.toNat : ℤ) = (t46_hi.toNat : ℤ)
      + (c49.toNat : ℤ) := or_carry t38_lo t43_lo t17_hi (b_t17_hi)
  have f_t94_lo : (t94_lo.toNat : ℤ) + 2 ^ 64 * (c94.toNat : ℤ) = (t49_hi.toNat : ℤ)
      + (t91_lo.toNat : ℤ) := addc_int t49_hi t91_lo
  have b_t46_hi : t46_hi.toNat ≤ 1 := carry_le' t38_lo t43_lo
  have b_c49 : c49.toNat ≤ 1 := carry_le' t17_hi t46_lo
  have b_t49_hi : t49_hi.toNat ≤ 1 := or_le' b_t46_hi b_c49
  have g_t94_hi : (t94_hi.toNat : ℤ) = (t91_hi.toNat : ℤ)
      + (c94.toNat : ℤ) := or_carry t84_lo t88_lo t49_hi (b_t49_hi)
  have f_t151_lo : (t151_lo.toNat : ℤ) + 2 ^ 64 * (c151.toNat : ℤ) = (t94_hi.toNat : ℤ)
      + (t148_lo.toNat : ℤ) := addc_int t94_hi t148_lo
  have b_t91_hi : t91_hi.toNat ≤ 1 := carry_le' t84_lo t88_lo
  have b_c94 : c94.toNat ≤ 1 := carry_le' t49_hi t91_lo
  have b_t94_hi : t94_hi.toNat ≤ 1 := or_le' b_t91_hi b_c94
  have g_t151_hi : (t151_hi.toNat : ℤ) = (t148_hi.toNat : ℤ)
      + (c151.toNat : ℤ) := or_carry t141_lo t145_lo t94_hi (b_t94_hi)
  have r_t226 : (t1_lo.toNat : ℤ) + 2 ^ 320 * (t225.toNat : ℤ) + 2 ^ 64 * (t17_lo.toNat : ℤ)
      + 2 ^ 128 * (t49_lo.toNat : ℤ) + 2 ^ 192 * (t94_lo.toNat : ℤ)
      + 2 ^ 256 * (t151_lo.toNat : ℤ)
      + 2 ^ 320 * (t151_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 64 * (x0.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 64 * (x1.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 128 * (x1.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 128 * (x2.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 192 * (x2.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 192 * (x3.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 256 * (x3.toNat : ℤ) * (y1.toNat : ℤ)
      := mul_row_t226 f_t1_lo f_t6_lo f_t26_lo f_t69_lo f_t29_lo f_t72_lo f_t9_lo f_t32_lo g_t32_hi
      f_t75_lo g_t75_hi f_t135 f_t14_lo f_t43_lo f_t81_lo f_t88_lo f_t138_lo f_t145_lo f_t38_lo
      f_t84_lo g_t84_hi f_t141_lo g_t141_hi f_t225 f_t46_lo f_t91_lo f_t148_lo f_t17_lo f_t49_lo
      g_t49_hi f_t94_lo g_t94_hi f_t151_lo g_t151_hi
  have l_t226 : (t151_hi.toNat : ℤ) + (t225.toNat : ℤ) < 2 ^ 64 := by
    linarith only [r_t226, m_x0_y0, m_x0_y1, m_x0_y2, m_x0_y3, m_x1_y0, m_x1_y1, m_x1_y2, m_x1_y3,
        m_x2_y0, m_x2_y1, m_x2_y2, m_x2_y3, m_x3_y0, m_x3_y1, m_x3_y2, m_x3_y3,
        Int.natCast_nonneg t1_lo.toNat, Int.natCast_nonneg t17_lo.toNat,
        Int.natCast_nonneg t49_lo.toNat, Int.natCast_nonneg t94_lo.toNat,
        Int.natCast_nonneg t151_lo.toNat]
  have f_t226 : (t226.toNat : ℤ) = (t151_hi.toNat : ℤ) + (t225.toNat : ℤ) := add_exact_of_lt l_t226
  have f_t53_lo : (t53_lo.toNat : ℤ)
      + 2 ^ 64 * (t53_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y2.toNat : ℤ) := split_mul x0 y2
  have f_t105_lo : (t105_lo.toNat : ℤ)
      + 2 ^ 64 * (t105_hi.toNat : ℤ) = (x1.toNat : ℤ) * (y2.toNat : ℤ) := split_mul x1 y2
  have f_t157_lo : (t157_lo.toNat : ℤ) + 2 ^ 64 * (t157_hi.toNat : ℤ) = (t151_lo.toNat : ℤ)
      + (t105_hi.toNat : ℤ) := addc_int t151_lo t105_hi
  have f_t164_lo : (t164_lo.toNat : ℤ)
      + 2 ^ 64 * (t164_hi.toNat : ℤ) = (x2.toNat : ℤ) * (y2.toNat : ℤ) := split_mul x2 y2
  have f_t229_lo : (t229_lo.toNat : ℤ) + 2 ^ 64 * (t229_hi.toNat : ℤ) = (t226.toNat : ℤ)
      + (t164_hi.toNat : ℤ) := addc_int t226 t164_hi
  have f_t236_lo : (t236_lo.toNat : ℤ)
      + 2 ^ 64 * (t236_hi.toNat : ℤ) = (x3.toNat : ℤ) * (y2.toNat : ℤ) := split_mul x3 y2
  have f_t100_lo : (t100_lo.toNat : ℤ) + 2 ^ 64 * (t100_hi.toNat : ℤ) = (t94_lo.toNat : ℤ)
      + (t53_hi.toNat : ℤ) := addc_int t94_lo t53_hi
  have f_t160_lo : (t160_lo.toNat : ℤ) + 2 ^ 64 * (c160.toNat : ℤ) = (t100_hi.toNat : ℤ)
      + (t157_lo.toNat : ℤ) := addc_int t100_hi t157_lo
  have b_t100_hi : t100_hi.toNat ≤ 1 := carry_le' t94_lo t53_hi
  have g_t160_hi : (t160_hi.toNat : ℤ) = (t157_hi.toNat : ℤ)
      + (c160.toNat : ℤ) := or_carry t151_lo t105_hi t100_hi (b_t100_hi)
  have f_t232_lo : (t232_lo.toNat : ℤ) + 2 ^ 64 * (c232.toNat : ℤ) = (t160_hi.toNat : ℤ)
      + (t229_lo.toNat : ℤ) := addc_int t160_hi t229_lo
  have b_t157_hi : t157_hi.toNat ≤ 1 := carry_le' t151_lo t105_hi
  have b_c160 : c160.toNat ≤ 1 := carry_le' t100_hi t157_lo
  have b_t160_hi : t160_hi.toNat ≤ 1 := or_le' b_t157_hi b_c160
  have g_t232_hi : (t232_hi.toNat : ℤ) = (t229_hi.toNat : ℤ)
      + (c232.toNat : ℤ) := or_carry t226 t164_hi t160_hi (b_t160_hi)
  have b_t229_hi : t229_hi.toNat ≤ 1 := carry_le' t226 t164_hi
  have b_c232 : c232.toNat ≤ 1 := carry_le' t160_hi t229_lo
  have b_t232_hi : t232_hi.toNat ≤ 1 := or_le' b_t229_hi b_c232
  have b_t236_hi : t236_hi.toNat ≤ 18446744073709551614 := hi_le' x3 y2
  have f_t299 : (t299.toNat : ℤ) = (t232_hi.toNat : ℤ)
      + (t236_hi.toNat : ℤ) := add_exact b_t232_hi b_t236_hi
  have f_t108_lo : (t108_lo.toNat : ℤ) + 2 ^ 64 * (t108_hi.toNat : ℤ) = (t100_lo.toNat : ℤ)
      + (t105_lo.toNat : ℤ) := addc_int t100_lo t105_lo
  have f_t167_lo : (t167_lo.toNat : ℤ) + 2 ^ 64 * (t167_hi.toNat : ℤ) = (t160_lo.toNat : ℤ)
      + (t164_lo.toNat : ℤ) := addc_int t160_lo t164_lo
  have f_t239_lo : (t239_lo.toNat : ℤ) + 2 ^ 64 * (t239_hi.toNat : ℤ) = (t232_lo.toNat : ℤ)
      + (t236_lo.toNat : ℤ) := addc_int t232_lo t236_lo
  have f_t56_lo : (t56_lo.toNat : ℤ) + 2 ^ 64 * (t56_hi.toNat : ℤ) = (t49_lo.toNat : ℤ)
      + (t53_lo.toNat : ℤ) := addc_int t49_lo t53_lo
  have f_t111_lo : (t111_lo.toNat : ℤ) + 2 ^ 64 * (c111.toNat : ℤ) = (t56_hi.toNat : ℤ)
      + (t108_lo.toNat : ℤ) := addc_int t56_hi t108_lo
  have b_t56_hi : t56_hi.toNat ≤ 1 := carry_le' t49_lo t53_lo
  have g_t111_hi : (t111_hi.toNat : ℤ) = (t108_hi.toNat : ℤ)
      + (c111.toNat : ℤ) := or_carry t100_lo t105_lo t56_hi (b_t56_hi)
  have f_t170_lo : (t170_lo.toNat : ℤ) + 2 ^ 64 * (c170.toNat : ℤ) = (t111_hi.toNat : ℤ)
      + (t167_lo.toNat : ℤ) := addc_int t111_hi t167_lo
  have b_t108_hi : t108_hi.toNat ≤ 1 := carry_le' t100_lo t105_lo
  have b_c111 : c111.toNat ≤ 1 := carry_le' t56_hi t108_lo
  have b_t111_hi : t111_hi.toNat ≤ 1 := or_le' b_t108_hi b_c111
  have g_t170_hi : (t170_hi.toNat : ℤ) = (t167_hi.toNat : ℤ)
      + (c170.toNat : ℤ) := or_carry t160_lo t164_lo t111_hi (b_t111_hi)
  have f_t242_lo : (t242_lo.toNat : ℤ) + 2 ^ 64 * (c242.toNat : ℤ) = (t170_hi.toNat : ℤ)
      + (t239_lo.toNat : ℤ) := addc_int t170_hi t239_lo
  have b_t167_hi : t167_hi.toNat ≤ 1 := carry_le' t160_lo t164_lo
  have b_c170 : c170.toNat ≤ 1 := carry_le' t111_hi t167_lo
  have b_t170_hi : t170_hi.toNat ≤ 1 := or_le' b_t167_hi b_c170
  have g_t242_hi : (t242_hi.toNat : ℤ) = (t239_hi.toNat : ℤ)
      + (c242.toNat : ℤ) := or_carry t232_lo t236_lo t170_hi (b_t170_hi)
  have r_t300 : (t1_lo.toNat : ℤ) + 2 ^ 64 * (t17_lo.toNat : ℤ) + 2 ^ 384 * (t299.toNat : ℤ)
      + 2 ^ 128 * (t56_lo.toNat : ℤ) + 2 ^ 192 * (t111_lo.toNat : ℤ)
      + 2 ^ 256 * (t170_lo.toNat : ℤ) + 2 ^ 320 * (t242_lo.toNat : ℤ)
      + 2 ^ 384 * (t242_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 64 * (x0.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 128 * (x0.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 64 * (x1.toNat : ℤ) * (y0.toNat : ℤ) + 2 ^ 128 * (x1.toNat : ℤ) * (y1.toNat : ℤ)
      + 2 ^ 192 * (x1.toNat : ℤ) * (y2.toNat : ℤ) + 2 ^ 128 * (x2.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 192 * (x2.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 256 * (x2.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 192 * (x3.toNat : ℤ) * (y0.toNat : ℤ) + 2 ^ 256 * (x3.toNat : ℤ) * (y1.toNat : ℤ)
      + 2 ^ 320 * (x3.toNat : ℤ) * (y2.toNat : ℤ)
      := mul_row_t300 f_t1_lo f_t6_lo f_t26_lo f_t69_lo f_t29_lo f_t72_lo f_t9_lo f_t32_lo g_t32_hi
      f_t75_lo g_t75_hi f_t135 f_t14_lo f_t43_lo f_t81_lo f_t88_lo f_t138_lo f_t145_lo f_t38_lo
      f_t84_lo g_t84_hi f_t141_lo g_t141_hi f_t225 f_t46_lo f_t91_lo f_t148_lo f_t17_lo f_t49_lo
      g_t49_hi f_t94_lo g_t94_hi f_t151_lo g_t151_hi f_t226 f_t53_lo f_t105_lo f_t157_lo f_t164_lo
      f_t229_lo f_t236_lo f_t100_lo f_t160_lo g_t160_hi f_t232_lo g_t232_hi f_t299 f_t108_lo
      f_t167_lo f_t239_lo f_t56_lo f_t111_lo g_t111_hi f_t170_lo g_t170_hi f_t242_lo g_t242_hi
  have l_t300 : (t242_hi.toNat : ℤ) + (t299.toNat : ℤ) < 2 ^ 64 := by
    linarith only [r_t300, m_x0_y0, m_x0_y1, m_x0_y2, m_x0_y3, m_x1_y0, m_x1_y1, m_x1_y2, m_x1_y3,
        m_x2_y0, m_x2_y1, m_x2_y2, m_x2_y3, m_x3_y0, m_x3_y1, m_x3_y2, m_x3_y3,
        Int.natCast_nonneg t1_lo.toNat, Int.natCast_nonneg t17_lo.toNat,
        Int.natCast_nonneg t56_lo.toNat, Int.natCast_nonneg t111_lo.toNat,
        Int.natCast_nonneg t170_lo.toNat, Int.natCast_nonneg t242_lo.toNat]
  have f_t300 : (t300.toNat : ℤ) = (t242_hi.toNat : ℤ) + (t299.toNat : ℤ) := add_exact_of_lt l_t300
  have f_t115_lo : (t115_lo.toNat : ℤ)
      + 2 ^ 64 * (t115_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y3.toNat : ℤ) := split_mul x0 y3
  have f_t181_lo : (t181_lo.toNat : ℤ)
      + 2 ^ 64 * (t181_hi.toNat : ℤ) = (x1.toNat : ℤ) * (y3.toNat : ℤ) := split_mul x1 y3
  have f_t248_lo : (t248_lo.toNat : ℤ) + 2 ^ 64 * (t248_hi.toNat : ℤ) = (t242_lo.toNat : ℤ)
      + (t181_hi.toNat : ℤ) := addc_int t242_lo t181_hi
  have f_t255_lo : (t255_lo.toNat : ℤ)
      + 2 ^ 64 * (t255_hi.toNat : ℤ) = (x2.toNat : ℤ) * (y3.toNat : ℤ) := split_mul x2 y3
  have f_t303_lo : (t303_lo.toNat : ℤ) + 2 ^ 64 * (t303_hi.toNat : ℤ) = (t300.toNat : ℤ)
      + (t255_hi.toNat : ℤ) := addc_int t300 t255_hi
  have f_t310_lo : (t310_lo.toNat : ℤ)
      + 2 ^ 64 * (t310_hi.toNat : ℤ) = (x3.toNat : ℤ) * (y3.toNat : ℤ) := split_mul x3 y3
  have f_t176_lo : (t176_lo.toNat : ℤ) + 2 ^ 64 * (t176_hi.toNat : ℤ) = (t170_lo.toNat : ℤ)
      + (t115_hi.toNat : ℤ) := addc_int t170_lo t115_hi
  have f_t251_lo : (t251_lo.toNat : ℤ) + 2 ^ 64 * (c251.toNat : ℤ) = (t176_hi.toNat : ℤ)
      + (t248_lo.toNat : ℤ) := addc_int t176_hi t248_lo
  have b_t176_hi : t176_hi.toNat ≤ 1 := carry_le' t170_lo t115_hi
  have g_t251_hi : (t251_hi.toNat : ℤ) = (t248_hi.toNat : ℤ)
      + (c251.toNat : ℤ) := or_carry t242_lo t181_hi t176_hi (b_t176_hi)
  have f_t306_lo : (t306_lo.toNat : ℤ) + 2 ^ 64 * (c306.toNat : ℤ) = (t251_hi.toNat : ℤ)
      + (t303_lo.toNat : ℤ) := addc_int t251_hi t303_lo
  have b_t248_hi : t248_hi.toNat ≤ 1 := carry_le' t242_lo t181_hi
  have b_c251 : c251.toNat ≤ 1 := carry_le' t176_hi t248_lo
  have b_t251_hi : t251_hi.toNat ≤ 1 := or_le' b_t248_hi b_c251
  have g_t306_hi : (t306_hi.toNat : ℤ) = (t303_hi.toNat : ℤ)
      + (c306.toNat : ℤ) := or_carry t300 t255_hi t251_hi (b_t251_hi)
  have b_t303_hi : t303_hi.toNat ≤ 1 := carry_le' t300 t255_hi
  have b_c306 : c306.toNat ≤ 1 := carry_le' t251_hi t303_lo
  have b_t306_hi : t306_hi.toNat ≤ 1 := or_le' b_t303_hi b_c306
  have b_t310_hi : t310_hi.toNat ≤ 18446744073709551614 := hi_le' x3 y3
  have f_t350 : (t350.toNat : ℤ) = (t306_hi.toNat : ℤ)
      + (t310_hi.toNat : ℤ) := add_exact b_t306_hi b_t310_hi
  have f_t184_lo : (t184_lo.toNat : ℤ) + 2 ^ 64 * (t184_hi.toNat : ℤ) = (t176_lo.toNat : ℤ)
      + (t181_lo.toNat : ℤ) := addc_int t176_lo t181_lo
  have f_t258_lo : (t258_lo.toNat : ℤ) + 2 ^ 64 * (t258_hi.toNat : ℤ) = (t251_lo.toNat : ℤ)
      + (t255_lo.toNat : ℤ) := addc_int t251_lo t255_lo
  have f_t313_lo : (t313_lo.toNat : ℤ) + 2 ^ 64 * (t313_hi.toNat : ℤ) = (t306_lo.toNat : ℤ)
      + (t310_lo.toNat : ℤ) := addc_int t306_lo t310_lo
  have f_t118_lo : (t118_lo.toNat : ℤ) + 2 ^ 64 * (t118_hi.toNat : ℤ) = (t111_lo.toNat : ℤ)
      + (t115_lo.toNat : ℤ) := addc_int t111_lo t115_lo
  have f_t187_lo : (t187_lo.toNat : ℤ) + 2 ^ 64 * (c187.toNat : ℤ) = (t118_hi.toNat : ℤ)
      + (t184_lo.toNat : ℤ) := addc_int t118_hi t184_lo
  have b_t118_hi : t118_hi.toNat ≤ 1 := carry_le' t111_lo t115_lo
  have g_t187_hi : (t187_hi.toNat : ℤ) = (t184_hi.toNat : ℤ)
      + (c187.toNat : ℤ) := or_carry t176_lo t181_lo t118_hi (b_t118_hi)
  have f_t261_lo : (t261_lo.toNat : ℤ) + 2 ^ 64 * (c261.toNat : ℤ) = (t187_hi.toNat : ℤ)
      + (t258_lo.toNat : ℤ) := addc_int t187_hi t258_lo
  have b_t184_hi : t184_hi.toNat ≤ 1 := carry_le' t176_lo t181_lo
  have b_c187 : c187.toNat ≤ 1 := carry_le' t118_hi t184_lo
  have b_t187_hi : t187_hi.toNat ≤ 1 := or_le' b_t184_hi b_c187
  have g_t261_hi : (t261_hi.toNat : ℤ) = (t258_hi.toNat : ℤ)
      + (c261.toNat : ℤ) := or_carry t251_lo t255_lo t187_hi (b_t187_hi)
  have f_t316_lo : (t316_lo.toNat : ℤ) + 2 ^ 64 * (c316.toNat : ℤ) = (t261_hi.toNat : ℤ)
      + (t313_lo.toNat : ℤ) := addc_int t261_hi t313_lo
  have b_t258_hi : t258_hi.toNat ≤ 1 := carry_le' t251_lo t255_lo
  have b_c261 : c261.toNat ≤ 1 := carry_le' t187_hi t258_lo
  have b_t261_hi : t261_hi.toNat ≤ 1 := or_le' b_t258_hi b_c261
  have g_t316_hi : (t316_hi.toNat : ℤ) = (t313_hi.toNat : ℤ)
      + (c316.toNat : ℤ) := or_carry t306_lo t310_lo t261_hi (b_t261_hi)
  have r_t351 : (t1_lo.toNat : ℤ) + 2 ^ 64 * (t17_lo.toNat : ℤ) + 2 ^ 128 * (t56_lo.toNat : ℤ)
      + 2 ^ 448 * (t350.toNat : ℤ) + 2 ^ 192 * (t118_lo.toNat : ℤ)
      + 2 ^ 256 * (t187_lo.toNat : ℤ) + 2 ^ 320 * (t261_lo.toNat : ℤ)
      + 2 ^ 384 * (t316_lo.toNat : ℤ)
      + 2 ^ 448 * (t316_hi.toNat : ℤ) = (x0.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 64 * (x0.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 128 * (x0.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 192 * (x0.toNat : ℤ) * (y3.toNat : ℤ) + 2 ^ 64 * (x1.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 128 * (x1.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 192 * (x1.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 256 * (x1.toNat : ℤ) * (y3.toNat : ℤ) + 2 ^ 128 * (x2.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 192 * (x2.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 256 * (x2.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 320 * (x2.toNat : ℤ) * (y3.toNat : ℤ) + 2 ^ 192 * (x3.toNat : ℤ) * (y0.toNat : ℤ)
      + 2 ^ 256 * (x3.toNat : ℤ) * (y1.toNat : ℤ) + 2 ^ 320 * (x3.toNat : ℤ) * (y2.toNat : ℤ)
      + 2 ^ 384 * (x3.toNat : ℤ) * (y3.toNat : ℤ)
      := mul_row_t351 f_t1_lo f_t6_lo f_t26_lo f_t69_lo f_t29_lo f_t72_lo f_t9_lo f_t32_lo g_t32_hi
      f_t75_lo g_t75_hi f_t135 f_t14_lo f_t43_lo f_t81_lo f_t88_lo f_t138_lo f_t145_lo f_t38_lo
      f_t84_lo g_t84_hi f_t141_lo g_t141_hi f_t225 f_t46_lo f_t91_lo f_t148_lo f_t17_lo f_t49_lo
      g_t49_hi f_t94_lo g_t94_hi f_t151_lo g_t151_hi f_t226 f_t53_lo f_t105_lo f_t157_lo f_t164_lo
      f_t229_lo f_t236_lo f_t100_lo f_t160_lo g_t160_hi f_t232_lo g_t232_hi f_t299 f_t108_lo
      f_t167_lo f_t239_lo f_t56_lo f_t111_lo g_t111_hi f_t170_lo g_t170_hi f_t242_lo g_t242_hi
      f_t300 f_t115_lo f_t181_lo f_t248_lo f_t255_lo f_t303_lo f_t310_lo f_t176_lo f_t251_lo
      g_t251_hi f_t306_lo g_t306_hi f_t350 f_t184_lo f_t258_lo f_t313_lo f_t118_lo f_t187_lo
      g_t187_hi f_t261_lo g_t261_hi f_t316_lo g_t316_hi
  have l_t351 : (t316_hi.toNat : ℤ) + (t350.toNat : ℤ) < 2 ^ 64 := by
    linarith only [r_t351, m_x0_y0, m_x0_y1, m_x0_y2, m_x0_y3, m_x1_y0, m_x1_y1, m_x1_y2, m_x1_y3,
        m_x2_y0, m_x2_y1, m_x2_y2, m_x2_y3, m_x3_y0, m_x3_y1, m_x3_y2, m_x3_y3,
        Int.natCast_nonneg t1_lo.toNat, Int.natCast_nonneg t17_lo.toNat,
        Int.natCast_nonneg t56_lo.toNat, Int.natCast_nonneg t118_lo.toNat,
        Int.natCast_nonneg t187_lo.toNat, Int.natCast_nonneg t261_lo.toNat,
        Int.natCast_nonneg t316_lo.toNat]
  have f_t351 : (t351.toNat : ℤ) = (t316_hi.toNat : ℤ) + (t350.toNat : ℤ) := add_exact_of_lt l_t351
  have f_t191_lo : (t191_lo.toNat : ℤ)
      + 2 ^ 64 * (t191_hi.toNat : ℤ) = (t187_lo.toNat : ℤ) * 38 := split_mul38 t187_lo
  have f_t265_lo : (t265_lo.toNat : ℤ)
      + 2 ^ 64 * (t265_hi.toNat : ℤ) = (t261_lo.toNat : ℤ) * 38 := split_mul38 t261_lo
  have f_t282_lo : (t282_lo.toNat : ℤ) + 2 ^ 64 * (t282_hi.toNat : ℤ) = (t56_lo.toNat : ℤ)
      + (t265_hi.toNat : ℤ) := addc_int t56_lo t265_hi
  have f_t320_lo : (t320_lo.toNat : ℤ)
      + 2 ^ 64 * (t320_hi.toNat : ℤ) = (t316_lo.toNat : ℤ) * 38 := split_mul38 t316_lo
  have f_t337_lo : (t337_lo.toNat : ℤ) + 2 ^ 64 * (t337_hi.toNat : ℤ) = (t118_lo.toNat : ℤ)
      + (t320_hi.toNat : ℤ) := addc_int t118_lo t320_hi
  have f_t352_lo : (t352_lo.toNat : ℤ)
      + 2 ^ 64 * (t352_hi.toNat : ℤ) = (t351.toNat : ℤ) * 38 := split_mul38 t351
  have f_t206_lo : (t206_lo.toNat : ℤ) + 2 ^ 64 * (t206_hi.toNat : ℤ) = (t17_lo.toNat : ℤ)
      + (t191_hi.toNat : ℤ) := addc_int t17_lo t191_hi
  have f_t285_lo : (t285_lo.toNat : ℤ) + 2 ^ 64 * (c285.toNat : ℤ) = (t206_hi.toNat : ℤ)
      + (t282_lo.toNat : ℤ) := addc_int t206_hi t282_lo
  have b_t206_hi : t206_hi.toNat ≤ 1 := carry_le' t17_lo t191_hi
  have g_t285_hi : (t285_hi.toNat : ℤ) = (t282_hi.toNat : ℤ)
      + (c285.toNat : ℤ) := or_carry t56_lo t265_hi t206_hi (b_t206_hi)
  have f_t340_lo : (t340_lo.toNat : ℤ) + 2 ^ 64 * (c340.toNat : ℤ) = (t285_hi.toNat : ℤ)
      + (t337_lo.toNat : ℤ) := addc_int t285_hi t337_lo
  have b_t282_hi : t282_hi.toNat ≤ 1 := carry_le' t56_lo t265_hi
  have b_c285 : c285.toNat ≤ 1 := carry_le' t206_hi t282_lo
  have b_t285_hi : t285_hi.toNat ≤ 1 := or_le' b_t282_hi b_c285
  have g_t340_hi : (t340_hi.toNat : ℤ) = (t337_hi.toNat : ℤ)
      + (c340.toNat : ℤ) := or_carry t118_lo t320_hi t285_hi (b_t285_hi)
  have b_t337_hi : t337_hi.toNat ≤ 1 := carry_le' t118_lo t320_hi
  have b_c340 : c340.toNat ≤ 1 := carry_le' t285_hi t337_lo
  have b_t340_hi : t340_hi.toNat ≤ 1 := or_le' b_t337_hi b_c340
  have b_t352_hi : t352_hi.toNat ≤ 37 := hi38_le' t351
  have f_t367 : (t367.toNat : ℤ) = (t340_hi.toNat : ℤ)
      + (t352_hi.toNat : ℤ) := add_exact b_t340_hi b_t352_hi
  have f_t269_lo : (t269_lo.toNat : ℤ) + 2 ^ 64 * (t269_hi.toNat : ℤ) = (t206_lo.toNat : ℤ)
      + (t265_lo.toNat : ℤ) := addc_int t206_lo t265_lo
  have f_t324_lo : (t324_lo.toNat : ℤ) + 2 ^ 64 * (t324_hi.toNat : ℤ) = (t285_lo.toNat : ℤ)
      + (t320_lo.toNat : ℤ) := addc_int t285_lo t320_lo
  have f_t356_lo : (t356_lo.toNat : ℤ) + 2 ^ 64 * (t356_hi.toNat : ℤ) = (t340_lo.toNat : ℤ)
      + (t352_lo.toNat : ℤ) := addc_int t340_lo t352_lo
  have f_t195_lo : (t195_lo.toNat : ℤ) + 2 ^ 64 * (t195_hi.toNat : ℤ) = (t1_lo.toNat : ℤ)
      + (t191_lo.toNat : ℤ) := addc_int t1_lo t191_lo
  have f_t272_lo : (t272_lo.toNat : ℤ) + 2 ^ 64 * (c272.toNat : ℤ) = (t195_hi.toNat : ℤ)
      + (t269_lo.toNat : ℤ) := addc_int t195_hi t269_lo
  have b_t195_hi : t195_hi.toNat ≤ 1 := carry_le' t1_lo t191_lo
  have g_t272_hi : (t272_hi.toNat : ℤ) = (t269_hi.toNat : ℤ)
      + (c272.toNat : ℤ) := or_carry t206_lo t265_lo t195_hi (b_t195_hi)
  have f_t327_lo : (t327_lo.toNat : ℤ) + 2 ^ 64 * (c327.toNat : ℤ) = (t272_hi.toNat : ℤ)
      + (t324_lo.toNat : ℤ) := addc_int t272_hi t324_lo
  have b_t269_hi : t269_hi.toNat ≤ 1 := carry_le' t206_lo t265_lo
  have b_c272 : c272.toNat ≤ 1 := carry_le' t195_hi t269_lo
  have b_t272_hi : t272_hi.toNat ≤ 1 := or_le' b_t269_hi b_c272
  have g_t327_hi : (t327_hi.toNat : ℤ) = (t324_hi.toNat : ℤ)
      + (c327.toNat : ℤ) := or_carry t285_lo t320_lo t272_hi (b_t272_hi)
  have f_t359_lo : (t359_lo.toNat : ℤ) + 2 ^ 64 * (c359.toNat : ℤ) = (t327_hi.toNat : ℤ)
      + (t356_lo.toNat : ℤ) := addc_int t327_hi t356_lo
  have b_t324_hi : t324_hi.toNat ≤ 1 := carry_le' t285_lo t320_lo
  have b_c327 : c327.toNat ≤ 1 := carry_le' t272_hi t324_lo
  have b_t327_hi : t327_hi.toNat ≤ 1 := or_le' b_t324_hi b_c327
  have g_t359_hi : (t359_hi.toNat : ℤ) = (t356_hi.toNat : ℤ)
      + (c359.toNat : ℤ) := or_carry t340_lo t352_lo t327_hi (b_t327_hi)
  have b_t356_hi : t356_hi.toNat ≤ 1 := carry_le' t340_lo t352_lo
  have b_c359 : c359.toNat ≤ 1 := carry_le' t327_hi t356_lo
  have b_t359_hi : t359_hi.toNat ≤ 1 := or_le' b_t356_hi b_c359
  have b_t367 : t367.toNat ≤ 38 := add_le' b_t340_hi b_t352_hi
  have f_t368 : (t368.toNat : ℤ) = (t359_hi.toNat : ℤ)
      + (t367.toNat : ℤ) := add_exact b_t359_hi b_t367
  have b_t368 : t368.toNat ≤ 39 := add_le' b_t359_hi b_t367
  have f_t369 : (t369.toNat : ℤ) = 2 * (t368.toNat : ℤ) := mul2_exact (b_t368)
  have f_t398 : 2 ^ 63 * (t372.toNat : ℤ)
      + (t398.toNat : ℤ) = (t359_lo.toNat : ℤ) := split63 t359_lo
  have b_t369 : t369.toNat ≤ 78 := mul2_le' b_t368
  have b_t372 : t372.toNat ≤ 1 := top_le' t359_lo
  have f_t373 : (t373.toNat : ℤ) = (t369.toNat : ℤ) + (t372.toNat : ℤ) := add_exact b_t369 b_t372
  have b_t373 : t373.toNat ≤ 79 := add_le' b_t369 b_t372
  have f_t374 : (t374.toNat : ℤ) = 19 * (t373.toNat : ℤ) := mul19_exact (b_t373)
  have f_t375_lo : (t375_lo.toNat : ℤ) + 2 ^ 64 * (t375_hi.toNat : ℤ) = (t195_lo.toNat : ℤ)
      + (t374.toNat : ℤ) := addc_int t195_lo t374
  have f_t384_lo : (t384_lo.toNat : ℤ) + 2 ^ 64 * (t384_hi.toNat : ℤ) = (t272_lo.toNat : ℤ)
      + (t375_hi.toNat : ℤ) := addc_int t272_lo t375_hi
  have f_t393_lo : (t393_lo.toNat : ℤ) + 2 ^ 64 * (t393_hi.toNat : ℤ) = (t327_lo.toNat : ℤ)
      + (t384_hi.toNat : ℤ) := addc_int t327_lo t384_hi
  have b_t398 : t398.toNat ≤ 9223372036854775807 := mask_le' t359_lo
  have b_t393_hi : t393_hi.toNat ≤ 1 := carry_le' t327_lo t384_hi
  have f_t401 : (t401.toNat : ℤ) = (t398.toNat : ℤ)
      + (t393_hi.toNat : ℤ) := add_exact b_t398 b_t393_hi
  have hout : ((t401 ++ (t393_lo ++ (t384_lo ++ t375_lo))).toNat : ℤ) = (t375_lo.toNat : ℤ)
      + 2 ^ 64 * (t384_lo.toNat : ℤ) + 2 ^ 128 * (t393_lo.toNat : ℤ) + 2 ^ 192 * (t401.toNat : ℤ) :=
    toNat_concat4 t401 t393_lo t384_lo t375_lo
  refine ⟨2 * ((t187_lo.toNat : ℤ) + 2 ^ 64 * (t261_lo.toNat : ℤ) + 2 ^ 128 * (t316_lo.toNat : ℤ)
      + 2 ^ 192 * (t351.toNat : ℤ)) + (t373.toNat : ℤ), ?_, ?_⟩
  · rw [hout, hX, hY]
    exact mul_final f_t1_lo f_t6_lo f_t26_lo f_t69_lo f_t29_lo f_t72_lo f_t9_lo f_t32_lo g_t32_hi
        f_t75_lo g_t75_hi f_t135 f_t14_lo f_t43_lo f_t81_lo f_t88_lo f_t138_lo f_t145_lo f_t38_lo
        f_t84_lo g_t84_hi f_t141_lo g_t141_hi f_t225 f_t46_lo f_t91_lo f_t148_lo f_t17_lo f_t49_lo
        g_t49_hi f_t94_lo g_t94_hi f_t151_lo g_t151_hi f_t226 f_t53_lo f_t105_lo f_t157_lo
        f_t164_lo f_t229_lo f_t236_lo f_t100_lo f_t160_lo g_t160_hi f_t232_lo g_t232_hi f_t299
        f_t108_lo f_t167_lo f_t239_lo f_t56_lo f_t111_lo g_t111_hi f_t170_lo g_t170_hi f_t242_lo
        g_t242_hi f_t300 f_t115_lo f_t181_lo f_t248_lo f_t255_lo f_t303_lo f_t310_lo f_t176_lo
        f_t251_lo g_t251_hi f_t306_lo g_t306_hi f_t350 f_t184_lo f_t258_lo f_t313_lo f_t118_lo
        f_t187_lo g_t187_hi f_t261_lo g_t261_hi f_t316_lo g_t316_hi f_t351 f_t191_lo f_t265_lo
        f_t282_lo f_t320_lo f_t337_lo f_t352_lo f_t206_lo f_t285_lo g_t285_hi f_t340_lo g_t340_hi
        f_t367 f_t269_lo f_t324_lo f_t356_lo f_t195_lo f_t272_lo g_t272_hi f_t327_lo g_t327_hi
        f_t359_lo g_t359_hi f_t368 f_t369 f_t398 f_t373 f_t374 f_t375_lo f_t384_lo f_t393_lo f_t401
  · have hlt : ((t401 ++ (t393_lo ++ (t384_lo ++ t375_lo))).toNat : ℤ) < 2 ^ 255 + 2 ^ 11 := by
      rw [hout]
      linarith only [f_t375_lo, f_t384_lo, f_t393_lo, f_t401, f_t374, b_t373, b_t398,
          le_max t195_lo, le_max t272_lo, le_max t327_lo]
    exact_mod_cast hlt

set_option exponentiation.threshold 600 in
theorem sqr_row_t231 {t6_lo t230 t29_lo t70_lo t114_lo t174_lo t174_hi x0 x1 x2 x3 t6_hi t54_lo
    t54_hi t162_lo t162_hi t26_lo t26_hi t64_lo t64_hi t101_lo t101_hi t108_lo t108_hi t167_lo
    t167_hi t59_lo t59_hi t104_lo c104 t104_hi t170_lo c170 t170_hi t67_lo t67_hi t111_lo t111_hi
    t29_hi c70 t70_hi c114 t114_hi : ℤ}
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x0 * x1)
    (f_t54_lo : t54_lo + 2 ^ 64 * t54_hi = x0 * x3)
    (f_t162_lo : t162_lo + 2 ^ 64 * t162_hi = x2 * x3)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x0 * x2)
    (f_t64_lo : t64_lo + 2 ^ 64 * t64_hi = x1 * x2)
    (f_t101_lo : t101_lo + 2 ^ 64 * t101_hi = t54_hi + t64_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = x1 * x3)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t162_lo + t108_hi)
    (f_t59_lo : t59_lo + 2 ^ 64 * t59_hi = t54_lo + t26_hi)
    (f_t104_lo : t104_lo + 2 ^ 64 * c104 = t59_hi + t101_lo)
    (g_t104_hi : t104_hi = t101_hi + c104)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t104_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t230 : t230 = t162_hi + t170_hi)
    (f_t67_lo : t67_lo + 2 ^ 64 * t67_hi = t59_lo + t64_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * t111_hi = t104_lo + t108_lo)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t70_lo : t70_lo + 2 ^ 64 * c70 = t29_hi + t67_lo)
    (g_t70_hi : t70_hi = t67_hi + c70)
    (f_t114_lo : t114_lo + 2 ^ 64 * c114 = t70_hi + t111_lo)
    (g_t114_hi : t114_hi = t111_hi + c114)
    (f_t174_lo : t174_lo + 2 ^ 64 * t174_hi = t114_hi + t170_lo) :
    2 ^ 64 * t6_lo + 2 ^ 384 * t230 + 2 ^ 128 * t29_lo + 2 ^ 192 * t70_lo + 2 ^ 256 * t114_lo
        + 2 ^ 320 * t174_lo + 2 ^ 384 * t174_hi = 2 ^ 64 * x0 * x1 + 2 ^ 128 * x0 * x2
        + 2 ^ 192 * x0 * x3 + 2 ^ 192 * x1 * x2 + 2 ^ 256 * x1 * x3 + 2 ^ 320 * x2 * x3 := by
  linear_combination 2 ^ 64 * f_t6_lo + 2 ^ 192 * f_t54_lo + 2 ^ 320 * f_t162_lo
      + 2 ^ 128 * f_t26_lo + 2 ^ 192 * f_t64_lo + 2 ^ 256 * f_t101_lo + 2 ^ 256 * f_t108_lo
      + 2 ^ 320 * f_t167_lo + 2 ^ 192 * f_t59_lo + 2 ^ 256 * f_t104_lo + 2 ^ 320 * g_t104_hi
      + 2 ^ 320 * f_t170_lo + 2 ^ 384 * g_t170_hi + 2 ^ 384 * f_t230 + 2 ^ 192 * f_t67_lo
      + 2 ^ 256 * f_t111_lo + 2 ^ 128 * f_t29_lo + 2 ^ 192 * f_t70_lo + 2 ^ 256 * g_t70_hi
      + 2 ^ 256 * f_t114_lo + 2 ^ 320 * g_t114_hi + 2 ^ 320 * f_t174_lo

set_option exponentiation.threshold 600 in
theorem sqr_row_t277 {t1_lo t276 t14_lo t44_lo t84_lo t128_lo t189_lo t242_lo t242_hi x0 x1 x2 x3
    t6_lo t6_hi t54_lo t54_hi t162_lo t162_hi t26_lo t26_hi t64_lo t64_hi t101_lo t101_hi t108_lo
    t108_hi t167_lo t167_hi t59_lo t59_hi t104_lo c104 t104_hi t170_lo c170 t170_hi t230 t67_lo
    t67_hi t111_lo t111_hi t29_lo t29_hi t70_lo c70 t70_hi t114_lo c114 t114_hi t174_lo t174_hi
    t231 t1_hi t19_lo t19_hi t34_lo t34_hi t74_lo t74_hi t88_lo t88_hi t118_lo t118_hi t179_lo
    t179_hi t219_lo t219_hi t232_lo t232_hi t9_lo t9_hi t37_lo c37 t37_hi t77_lo c77 t77_hi t121_lo
    c121 t121_hi t182_lo c182 t182_hi t235_lo c235 t235_hi t41_lo t41_hi t81_lo t81_hi t125_lo
    t125_hi t186_lo t186_hi t239_lo t239_hi t14_hi c44 t44_hi c84 t84_hi c128 t128_hi c189 t189_hi
    c242 : ℤ}
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x0 * x1)
    (f_t54_lo : t54_lo + 2 ^ 64 * t54_hi = x0 * x3)
    (f_t162_lo : t162_lo + 2 ^ 64 * t162_hi = x2 * x3)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x0 * x2)
    (f_t64_lo : t64_lo + 2 ^ 64 * t64_hi = x1 * x2)
    (f_t101_lo : t101_lo + 2 ^ 64 * t101_hi = t54_hi + t64_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = x1 * x3)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t162_lo + t108_hi)
    (f_t59_lo : t59_lo + 2 ^ 64 * t59_hi = t54_lo + t26_hi)
    (f_t104_lo : t104_lo + 2 ^ 64 * c104 = t59_hi + t101_lo)
    (g_t104_hi : t104_hi = t101_hi + c104)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t104_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t230 : t230 = t162_hi + t170_hi)
    (f_t67_lo : t67_lo + 2 ^ 64 * t67_hi = t59_lo + t64_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * t111_hi = t104_lo + t108_lo)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t70_lo : t70_lo + 2 ^ 64 * c70 = t29_hi + t67_lo)
    (g_t70_hi : t70_hi = t67_hi + c70)
    (f_t114_lo : t114_lo + 2 ^ 64 * c114 = t70_hi + t111_lo)
    (g_t114_hi : t114_hi = t111_hi + c114)
    (f_t174_lo : t174_lo + 2 ^ 64 * t174_hi = t114_hi + t170_lo)
    (f_t231 : t231 = t174_hi + t230)
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * x0)
    (f_t19_lo : t19_lo + 2 ^ 64 * t19_hi = x1 * x1)
    (f_t34_lo : t34_lo + 2 ^ 64 * t34_hi = t29_lo + t29_lo)
    (f_t74_lo : t74_lo + 2 ^ 64 * t74_hi = t70_lo + t70_lo)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * x2)
    (f_t118_lo : t118_lo + 2 ^ 64 * t118_hi = t114_lo + t114_lo)
    (f_t179_lo : t179_lo + 2 ^ 64 * t179_hi = t174_lo + t174_lo)
    (f_t219_lo : t219_lo + 2 ^ 64 * t219_hi = x3 * x3)
    (f_t232_lo : t232_lo + 2 ^ 64 * t232_hi = t231 + t231)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t6_lo + t6_lo)
    (f_t37_lo : t37_lo + 2 ^ 64 * c37 = t9_hi + t34_lo)
    (g_t37_hi : t37_hi = t34_hi + c37)
    (f_t77_lo : t77_lo + 2 ^ 64 * c77 = t37_hi + t74_lo)
    (g_t77_hi : t77_hi = t74_hi + c77)
    (f_t121_lo : t121_lo + 2 ^ 64 * c121 = t77_hi + t118_lo)
    (g_t121_hi : t121_hi = t118_hi + c121)
    (f_t182_lo : t182_lo + 2 ^ 64 * c182 = t121_hi + t179_lo)
    (g_t182_hi : t182_hi = t179_hi + c182)
    (f_t235_lo : t235_lo + 2 ^ 64 * c235 = t182_hi + t232_lo)
    (g_t235_hi : t235_hi = t232_hi + c235)
    (f_t276 : t276 = t219_hi + t235_hi)
    (f_t41_lo : t41_lo + 2 ^ 64 * t41_hi = t19_lo + t37_lo)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t19_hi + t77_lo)
    (f_t125_lo : t125_lo + 2 ^ 64 * t125_hi = t88_lo + t121_lo)
    (f_t186_lo : t186_lo + 2 ^ 64 * t186_hi = t88_hi + t182_lo)
    (f_t239_lo : t239_lo + 2 ^ 64 * t239_hi = t219_lo + t235_lo)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = t1_hi + t9_lo)
    (f_t44_lo : t44_lo + 2 ^ 64 * c44 = t14_hi + t41_lo)
    (g_t44_hi : t44_hi = t41_hi + c44)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t44_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t128_lo : t128_lo + 2 ^ 64 * c128 = t84_hi + t125_lo)
    (g_t128_hi : t128_hi = t125_hi + c128)
    (f_t189_lo : t189_lo + 2 ^ 64 * c189 = t128_hi + t186_lo)
    (g_t189_hi : t189_hi = t186_hi + c189)
    (f_t242_lo : t242_lo + 2 ^ 64 * c242 = t189_hi + t239_lo)
    (g_t242_hi : t242_hi = t239_hi + c242) :
    t1_lo + 2 ^ 448 * t276 + 2 ^ 64 * t14_lo + 2 ^ 128 * t44_lo + 2 ^ 192 * t84_lo
        + 2 ^ 256 * t128_lo + 2 ^ 320 * t189_lo + 2 ^ 384 * t242_lo + 2 ^ 448 * t242_hi = x0 * x0
        + 2 ^ 65 * x0 * x1 + 2 ^ 129 * x0 * x2 + 2 ^ 193 * x0 * x3 + 2 ^ 128 * x1 * x1
        + 2 ^ 193 * x1 * x2 + 2 ^ 257 * x1 * x3 + 2 ^ 256 * x2 * x2 + 2 ^ 321 * x2 * x3
        + 2 ^ 384 * x3 * x3 := by
  linear_combination 2 ^ 65 * f_t6_lo + 2 ^ 193 * f_t54_lo + 2 ^ 321 * f_t162_lo
      + 2 ^ 129 * f_t26_lo + 2 ^ 193 * f_t64_lo + 2 ^ 257 * f_t101_lo + 2 ^ 257 * f_t108_lo
      + 2 ^ 321 * f_t167_lo + 2 ^ 193 * f_t59_lo + 2 ^ 257 * f_t104_lo + 2 ^ 321 * g_t104_hi
      + 2 ^ 321 * f_t170_lo + 2 ^ 385 * g_t170_hi + 2 ^ 385 * f_t230 + 2 ^ 193 * f_t67_lo
      + 2 ^ 257 * f_t111_lo + 2 ^ 129 * f_t29_lo + 2 ^ 193 * f_t70_lo + 2 ^ 257 * g_t70_hi
      + 2 ^ 257 * f_t114_lo + 2 ^ 321 * g_t114_hi + 2 ^ 321 * f_t174_lo + 2 ^ 385 * f_t231
      + f_t1_lo + 2 ^ 128 * f_t19_lo + 2 ^ 128 * f_t34_lo + 2 ^ 192 * f_t74_lo
      + 2 ^ 256 * f_t88_lo + 2 ^ 256 * f_t118_lo + 2 ^ 320 * f_t179_lo + 2 ^ 384 * f_t219_lo
      + 2 ^ 384 * f_t232_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t37_lo + 2 ^ 192 * g_t37_hi
      + 2 ^ 192 * f_t77_lo + 2 ^ 256 * g_t77_hi + 2 ^ 256 * f_t121_lo + 2 ^ 320 * g_t121_hi
      + 2 ^ 320 * f_t182_lo + 2 ^ 384 * g_t182_hi + 2 ^ 384 * f_t235_lo + 2 ^ 448 * g_t235_hi
      + 2 ^ 448 * f_t276 + 2 ^ 128 * f_t41_lo + 2 ^ 192 * f_t81_lo + 2 ^ 256 * f_t125_lo
      + 2 ^ 320 * f_t186_lo + 2 ^ 384 * f_t239_lo + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t44_lo
      + 2 ^ 192 * g_t44_hi + 2 ^ 192 * f_t84_lo + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t128_lo
      + 2 ^ 320 * g_t128_hi + 2 ^ 320 * f_t189_lo + 2 ^ 384 * g_t189_hi + 2 ^ 384 * f_t242_lo
      + 2 ^ 448 * g_t242_hi

set_option exponentiation.threshold 600 in
theorem sqr_final {t301_lo t310_lo t319_lo t327 t128_lo t189_lo t242_lo t277 t299 x0 x1 x2 x3 t6_lo
    t6_hi t54_lo t54_hi t162_lo t162_hi t26_lo t26_hi t64_lo t64_hi t101_lo t101_hi t108_lo t108_hi
    t167_lo t167_hi t59_lo t59_hi t104_lo c104 t104_hi t170_lo c170 t170_hi t230 t67_lo t67_hi
    t111_lo t111_hi t29_lo t29_hi t70_lo c70 t70_hi t114_lo c114 t114_hi t174_lo t174_hi t231 t1_lo
    t1_hi t19_lo t19_hi t34_lo t34_hi t74_lo t74_hi t88_lo t88_hi t118_lo t118_hi t179_lo t179_hi
    t219_lo t219_hi t232_lo t232_hi t9_lo t9_hi t37_lo c37 t37_hi t77_lo c77 t77_hi t121_lo c121
    t121_hi t182_lo c182 t182_hi t235_lo c235 t235_hi t276 t41_lo t41_hi t81_lo t81_hi t125_lo
    t125_hi t186_lo t186_hi t239_lo t239_hi t14_lo t14_hi t44_lo c44 t44_hi t84_lo c84 t84_hi c128
    t128_hi c189 t189_hi c242 t242_hi t132_lo t132_hi t193_lo t193_hi t210_lo t210_hi t246_lo
    t246_hi t263_lo t263_hi t278_lo t278_hi t147_lo t147_hi t213_lo c213 t213_hi t266_lo c266
    t266_hi t293 t197_lo t197_hi t250_lo t250_hi t282_lo t282_hi t136_lo t136_hi t200_lo c200
    t200_hi t253_lo c253 t253_hi t285_lo c285 t285_hi t294 t295 t298 t324 t300 t301_hi t310_hi
    t319_hi : ℤ}
    (f_t6_lo : t6_lo + 2 ^ 64 * t6_hi = x0 * x1)
    (f_t54_lo : t54_lo + 2 ^ 64 * t54_hi = x0 * x3)
    (f_t162_lo : t162_lo + 2 ^ 64 * t162_hi = x2 * x3)
    (f_t26_lo : t26_lo + 2 ^ 64 * t26_hi = x0 * x2)
    (f_t64_lo : t64_lo + 2 ^ 64 * t64_hi = x1 * x2)
    (f_t101_lo : t101_lo + 2 ^ 64 * t101_hi = t54_hi + t64_hi)
    (f_t108_lo : t108_lo + 2 ^ 64 * t108_hi = x1 * x3)
    (f_t167_lo : t167_lo + 2 ^ 64 * t167_hi = t162_lo + t108_hi)
    (f_t59_lo : t59_lo + 2 ^ 64 * t59_hi = t54_lo + t26_hi)
    (f_t104_lo : t104_lo + 2 ^ 64 * c104 = t59_hi + t101_lo)
    (g_t104_hi : t104_hi = t101_hi + c104)
    (f_t170_lo : t170_lo + 2 ^ 64 * c170 = t104_hi + t167_lo)
    (g_t170_hi : t170_hi = t167_hi + c170)
    (f_t230 : t230 = t162_hi + t170_hi)
    (f_t67_lo : t67_lo + 2 ^ 64 * t67_hi = t59_lo + t64_lo)
    (f_t111_lo : t111_lo + 2 ^ 64 * t111_hi = t104_lo + t108_lo)
    (f_t29_lo : t29_lo + 2 ^ 64 * t29_hi = t6_hi + t26_lo)
    (f_t70_lo : t70_lo + 2 ^ 64 * c70 = t29_hi + t67_lo)
    (g_t70_hi : t70_hi = t67_hi + c70)
    (f_t114_lo : t114_lo + 2 ^ 64 * c114 = t70_hi + t111_lo)
    (g_t114_hi : t114_hi = t111_hi + c114)
    (f_t174_lo : t174_lo + 2 ^ 64 * t174_hi = t114_hi + t170_lo)
    (f_t231 : t231 = t174_hi + t230)
    (f_t1_lo : t1_lo + 2 ^ 64 * t1_hi = x0 * x0)
    (f_t19_lo : t19_lo + 2 ^ 64 * t19_hi = x1 * x1)
    (f_t34_lo : t34_lo + 2 ^ 64 * t34_hi = t29_lo + t29_lo)
    (f_t74_lo : t74_lo + 2 ^ 64 * t74_hi = t70_lo + t70_lo)
    (f_t88_lo : t88_lo + 2 ^ 64 * t88_hi = x2 * x2)
    (f_t118_lo : t118_lo + 2 ^ 64 * t118_hi = t114_lo + t114_lo)
    (f_t179_lo : t179_lo + 2 ^ 64 * t179_hi = t174_lo + t174_lo)
    (f_t219_lo : t219_lo + 2 ^ 64 * t219_hi = x3 * x3)
    (f_t232_lo : t232_lo + 2 ^ 64 * t232_hi = t231 + t231)
    (f_t9_lo : t9_lo + 2 ^ 64 * t9_hi = t6_lo + t6_lo)
    (f_t37_lo : t37_lo + 2 ^ 64 * c37 = t9_hi + t34_lo)
    (g_t37_hi : t37_hi = t34_hi + c37)
    (f_t77_lo : t77_lo + 2 ^ 64 * c77 = t37_hi + t74_lo)
    (g_t77_hi : t77_hi = t74_hi + c77)
    (f_t121_lo : t121_lo + 2 ^ 64 * c121 = t77_hi + t118_lo)
    (g_t121_hi : t121_hi = t118_hi + c121)
    (f_t182_lo : t182_lo + 2 ^ 64 * c182 = t121_hi + t179_lo)
    (g_t182_hi : t182_hi = t179_hi + c182)
    (f_t235_lo : t235_lo + 2 ^ 64 * c235 = t182_hi + t232_lo)
    (g_t235_hi : t235_hi = t232_hi + c235)
    (f_t276 : t276 = t219_hi + t235_hi)
    (f_t41_lo : t41_lo + 2 ^ 64 * t41_hi = t19_lo + t37_lo)
    (f_t81_lo : t81_lo + 2 ^ 64 * t81_hi = t19_hi + t77_lo)
    (f_t125_lo : t125_lo + 2 ^ 64 * t125_hi = t88_lo + t121_lo)
    (f_t186_lo : t186_lo + 2 ^ 64 * t186_hi = t88_hi + t182_lo)
    (f_t239_lo : t239_lo + 2 ^ 64 * t239_hi = t219_lo + t235_lo)
    (f_t14_lo : t14_lo + 2 ^ 64 * t14_hi = t1_hi + t9_lo)
    (f_t44_lo : t44_lo + 2 ^ 64 * c44 = t14_hi + t41_lo)
    (g_t44_hi : t44_hi = t41_hi + c44)
    (f_t84_lo : t84_lo + 2 ^ 64 * c84 = t44_hi + t81_lo)
    (g_t84_hi : t84_hi = t81_hi + c84)
    (f_t128_lo : t128_lo + 2 ^ 64 * c128 = t84_hi + t125_lo)
    (g_t128_hi : t128_hi = t125_hi + c128)
    (f_t189_lo : t189_lo + 2 ^ 64 * c189 = t128_hi + t186_lo)
    (g_t189_hi : t189_hi = t186_hi + c189)
    (f_t242_lo : t242_lo + 2 ^ 64 * c242 = t189_hi + t239_lo)
    (g_t242_hi : t242_hi = t239_hi + c242)
    (f_t277 : t277 = t242_hi + t276)
    (f_t132_lo : t132_lo + 2 ^ 64 * t132_hi = t128_lo * 38)
    (f_t193_lo : t193_lo + 2 ^ 64 * t193_hi = t189_lo * 38)
    (f_t210_lo : t210_lo + 2 ^ 64 * t210_hi = t44_lo + t193_hi)
    (f_t246_lo : t246_lo + 2 ^ 64 * t246_hi = t242_lo * 38)
    (f_t263_lo : t263_lo + 2 ^ 64 * t263_hi = t84_lo + t246_hi)
    (f_t278_lo : t278_lo + 2 ^ 64 * t278_hi = t277 * 38)
    (f_t147_lo : t147_lo + 2 ^ 64 * t147_hi = t14_lo + t132_hi)
    (f_t213_lo : t213_lo + 2 ^ 64 * c213 = t147_hi + t210_lo)
    (g_t213_hi : t213_hi = t210_hi + c213)
    (f_t266_lo : t266_lo + 2 ^ 64 * c266 = t213_hi + t263_lo)
    (g_t266_hi : t266_hi = t263_hi + c266)
    (f_t293 : t293 = t266_hi + t278_hi)
    (f_t197_lo : t197_lo + 2 ^ 64 * t197_hi = t147_lo + t193_lo)
    (f_t250_lo : t250_lo + 2 ^ 64 * t250_hi = t213_lo + t246_lo)
    (f_t282_lo : t282_lo + 2 ^ 64 * t282_hi = t266_lo + t278_lo)
    (f_t136_lo : t136_lo + 2 ^ 64 * t136_hi = t1_lo + t132_lo)
    (f_t200_lo : t200_lo + 2 ^ 64 * c200 = t136_hi + t197_lo)
    (g_t200_hi : t200_hi = t197_hi + c200)
    (f_t253_lo : t253_lo + 2 ^ 64 * c253 = t200_hi + t250_lo)
    (g_t253_hi : t253_hi = t250_hi + c253)
    (f_t285_lo : t285_lo + 2 ^ 64 * c285 = t253_hi + t282_lo)
    (g_t285_hi : t285_hi = t282_hi + c285)
    (f_t294 : t294 = t285_hi + t293)
    (f_t295 : t295 = 2 * t294)
    (f_t324 : 2 ^ 63 * t298 + t324 = t285_lo)
    (f_t299 : t299 = t295 + t298)
    (f_t300 : t300 = 19 * t299)
    (f_t301_lo : t301_lo + 2 ^ 64 * t301_hi = t136_lo + t300)
    (f_t310_lo : t310_lo + 2 ^ 64 * t310_hi = t200_lo + t301_hi)
    (f_t319_lo : t319_lo + 2 ^ 64 * t319_hi = t253_lo + t310_hi)
    (f_t327 : t327 = t324 + t319_hi) :
    t301_lo + 2 ^ 64 * t310_lo + 2 ^ 128 * t319_lo + 2 ^ 192 * t327
        + (2 ^ 255 - 19) * (2 * (t128_lo + 2 ^ 64 * t189_lo + 2 ^ 128 * t242_lo + 2 ^ 192 * t277)
        + t299) = (x0 + 2 ^ 64 * x1 + 2 ^ 128 * x2 + 2 ^ 192 * x3) * (x0 + 2 ^ 64 * x1
        + 2 ^ 128 * x2 + 2 ^ 192 * x3) := by
  linear_combination 2 ^ 65 * f_t6_lo + 2 ^ 193 * f_t54_lo + 2 ^ 321 * f_t162_lo
      + 2 ^ 129 * f_t26_lo + 2 ^ 193 * f_t64_lo + 2 ^ 257 * f_t101_lo + 2 ^ 257 * f_t108_lo
      + 2 ^ 321 * f_t167_lo + 2 ^ 193 * f_t59_lo + 2 ^ 257 * f_t104_lo + 2 ^ 321 * g_t104_hi
      + 2 ^ 321 * f_t170_lo + 2 ^ 385 * g_t170_hi + 2 ^ 385 * f_t230 + 2 ^ 193 * f_t67_lo
      + 2 ^ 257 * f_t111_lo + 2 ^ 129 * f_t29_lo + 2 ^ 193 * f_t70_lo + 2 ^ 257 * g_t70_hi
      + 2 ^ 257 * f_t114_lo + 2 ^ 321 * g_t114_hi + 2 ^ 321 * f_t174_lo + 2 ^ 385 * f_t231
      + f_t1_lo + 2 ^ 128 * f_t19_lo + 2 ^ 128 * f_t34_lo + 2 ^ 192 * f_t74_lo
      + 2 ^ 256 * f_t88_lo + 2 ^ 256 * f_t118_lo + 2 ^ 320 * f_t179_lo + 2 ^ 384 * f_t219_lo
      + 2 ^ 384 * f_t232_lo + 2 ^ 64 * f_t9_lo + 2 ^ 128 * f_t37_lo + 2 ^ 192 * g_t37_hi
      + 2 ^ 192 * f_t77_lo + 2 ^ 256 * g_t77_hi + 2 ^ 256 * f_t121_lo + 2 ^ 320 * g_t121_hi
      + 2 ^ 320 * f_t182_lo + 2 ^ 384 * g_t182_hi + 2 ^ 384 * f_t235_lo + 2 ^ 448 * g_t235_hi
      + 2 ^ 448 * f_t276 + 2 ^ 128 * f_t41_lo + 2 ^ 192 * f_t81_lo + 2 ^ 256 * f_t125_lo
      + 2 ^ 320 * f_t186_lo + 2 ^ 384 * f_t239_lo + 2 ^ 64 * f_t14_lo + 2 ^ 128 * f_t44_lo
      + 2 ^ 192 * g_t44_hi + 2 ^ 192 * f_t84_lo + 2 ^ 256 * g_t84_hi + 2 ^ 256 * f_t128_lo
      + 2 ^ 320 * g_t128_hi + 2 ^ 320 * f_t189_lo + 2 ^ 384 * g_t189_hi + 2 ^ 384 * f_t242_lo
      + 2 ^ 448 * g_t242_hi + 2 ^ 448 * f_t277 + f_t132_lo + 2 ^ 64 * f_t193_lo
      + 2 ^ 128 * f_t210_lo + 2 ^ 128 * f_t246_lo + 2 ^ 192 * f_t263_lo + 2 ^ 192 * f_t278_lo
      + 2 ^ 64 * f_t147_lo + 2 ^ 128 * f_t213_lo + 2 ^ 192 * g_t213_hi + 2 ^ 192 * f_t266_lo
      + 2 ^ 256 * g_t266_hi + 2 ^ 256 * f_t293 + 2 ^ 64 * f_t197_lo + 2 ^ 128 * f_t250_lo
      + 2 ^ 192 * f_t282_lo + f_t136_lo + 2 ^ 64 * f_t200_lo + 2 ^ 128 * g_t200_hi
      + 2 ^ 128 * f_t253_lo + 2 ^ 192 * g_t253_hi + 2 ^ 192 * f_t285_lo + 2 ^ 256 * g_t285_hi
      + 2 ^ 256 * f_t294 + 2 ^ 255 * f_t295 + 2 ^ 192 * f_t324 + 2 ^ 255 * f_t299 + f_t300
      + f_t301_lo + 2 ^ 64 * f_t310_lo + 2 ^ 128 * f_t319_lo + 2 ^ 192 * f_t327

set_option exponentiation.threshold 600 in
theorem sqr_aux (X : BitVec 256) :
    ∃ q : ℤ, ((sqr X).toNat : ℤ) + (2 ^ 255 - 19) * q = (X.toNat : ℤ) * X.toNat ∧
      (sqr X).toNat < 2 ^ 255 + 2 ^ 11 := by
  unfold sqr
  extract_lets x0 x1 x2 x3 p2 t6_lo t6_hi p5 t54_lo t54_hi p10 t162_lo t162_hi p4 t26_lo t26_hi p6
      t64_lo t64_hi t101_lo t101_hi p8 t108_lo t108_hi t167_lo t167_hi t59_lo t59_hi t104_lo c104
      t104_hi t170_lo c170 t170_hi t230 t67_lo t67_hi t111_lo t111_hi t29_lo t29_hi t70_lo c70
      t70_hi t114_lo c114 t114_hi t174_lo t174_hi t231 p1 t1_lo t1_hi p3 t19_lo t19_hi t34_lo
      t34_hi t74_lo t74_hi p7 t88_lo t88_hi t118_lo t118_hi t179_lo t179_hi p12 t219_lo t219_hi
      t232_lo t232_hi t9_lo t9_hi t37_lo c37 t37_hi t77_lo c77 t77_hi t121_lo c121 t121_hi t182_lo
      c182 t182_hi t235_lo c235 t235_hi t276 t41_lo t41_hi t81_lo t81_hi t125_lo t125_hi t186_lo
      t186_hi t239_lo t239_hi t14_lo t14_hi t44_lo c44 t44_hi t84_lo c84 t84_hi t128_lo c128
      t128_hi t189_lo c189 t189_hi t242_lo c242 t242_hi t277 p9 t132_lo t132_hi p11 t193_lo t193_hi
      t210_lo t210_hi p13 t246_lo t246_hi t263_lo t263_hi p14 t278_lo t278_hi t147_lo t147_hi
      t213_lo c213 t213_hi t266_lo c266 t266_hi t293 t197_lo t197_hi t250_lo t250_hi t282_lo
      t282_hi t136_lo t136_hi t200_lo c200 t200_hi t253_lo c253 t253_hi t285_lo c285 t285_hi t294
      t295 t298 t299 t324 t300 t301_lo t301_hi t310_lo t310_hi t319_lo t319_hi t327
  have hX : (X.toNat : ℤ) = x0.toNat + 2 ^ 64 * x1.toNat + 2 ^ 128 * x2.toNat
      + 2 ^ 192 * x3.toNat :=
    toNat_limbs X
  have m_x0_x0 := prod_le x0 x0
  have m_x0_x1 := prod_le x0 x1
  have m_x0_x2 := prod_le x0 x2
  have m_x0_x3 := prod_le x0 x3
  have m_x1_x1 := prod_le x1 x1
  have m_x1_x2 := prod_le x1 x2
  have m_x1_x3 := prod_le x1 x3
  have m_x2_x2 := prod_le x2 x2
  have m_x2_x3 := prod_le x2 x3
  have m_x3_x3 := prod_le x3 x3
  have f_t6_lo : (t6_lo.toNat : ℤ)
      + 2 ^ 64 * (t6_hi.toNat : ℤ) = (x0.toNat : ℤ) * (x1.toNat : ℤ) := split_mul x0 x1
  have f_t54_lo : (t54_lo.toNat : ℤ)
      + 2 ^ 64 * (t54_hi.toNat : ℤ) = (x0.toNat : ℤ) * (x3.toNat : ℤ) := split_mul x0 x3
  have f_t162_lo : (t162_lo.toNat : ℤ)
      + 2 ^ 64 * (t162_hi.toNat : ℤ) = (x2.toNat : ℤ) * (x3.toNat : ℤ) := split_mul x2 x3
  have f_t26_lo : (t26_lo.toNat : ℤ)
      + 2 ^ 64 * (t26_hi.toNat : ℤ) = (x0.toNat : ℤ) * (x2.toNat : ℤ) := split_mul x0 x2
  have f_t64_lo : (t64_lo.toNat : ℤ)
      + 2 ^ 64 * (t64_hi.toNat : ℤ) = (x1.toNat : ℤ) * (x2.toNat : ℤ) := split_mul x1 x2
  have f_t101_lo : (t101_lo.toNat : ℤ) + 2 ^ 64 * (t101_hi.toNat : ℤ) = (t54_hi.toNat : ℤ)
      + (t64_hi.toNat : ℤ) := addc_int t54_hi t64_hi
  have f_t108_lo : (t108_lo.toNat : ℤ)
      + 2 ^ 64 * (t108_hi.toNat : ℤ) = (x1.toNat : ℤ) * (x3.toNat : ℤ) := split_mul x1 x3
  have f_t167_lo : (t167_lo.toNat : ℤ) + 2 ^ 64 * (t167_hi.toNat : ℤ) = (t162_lo.toNat : ℤ)
      + (t108_hi.toNat : ℤ) := addc_int t162_lo t108_hi
  have f_t59_lo : (t59_lo.toNat : ℤ) + 2 ^ 64 * (t59_hi.toNat : ℤ) = (t54_lo.toNat : ℤ)
      + (t26_hi.toNat : ℤ) := addc_int t54_lo t26_hi
  have f_t104_lo : (t104_lo.toNat : ℤ) + 2 ^ 64 * (c104.toNat : ℤ) = (t59_hi.toNat : ℤ)
      + (t101_lo.toNat : ℤ) := addc_int t59_hi t101_lo
  have b_t59_hi : t59_hi.toNat ≤ 1 := carry_le' t54_lo t26_hi
  have g_t104_hi : (t104_hi.toNat : ℤ) = (t101_hi.toNat : ℤ)
      + (c104.toNat : ℤ) := or_carry t54_hi t64_hi t59_hi (b_t59_hi)
  have f_t170_lo : (t170_lo.toNat : ℤ) + 2 ^ 64 * (c170.toNat : ℤ) = (t104_hi.toNat : ℤ)
      + (t167_lo.toNat : ℤ) := addc_int t104_hi t167_lo
  have b_t101_hi : t101_hi.toNat ≤ 1 := carry_le' t54_hi t64_hi
  have b_c104 : c104.toNat ≤ 1 := carry_le' t59_hi t101_lo
  have b_t104_hi : t104_hi.toNat ≤ 1 := or_le' b_t101_hi b_c104
  have g_t170_hi : (t170_hi.toNat : ℤ) = (t167_hi.toNat : ℤ)
      + (c170.toNat : ℤ) := or_carry t162_lo t108_hi t104_hi (b_t104_hi)
  have b_t162_hi : t162_hi.toNat ≤ 18446744073709551614 := hi_le' x2 x3
  have b_t167_hi : t167_hi.toNat ≤ 1 := carry_le' t162_lo t108_hi
  have b_c170 : c170.toNat ≤ 1 := carry_le' t104_hi t167_lo
  have b_t170_hi : t170_hi.toNat ≤ 1 := or_le' b_t167_hi b_c170
  have f_t230 : (t230.toNat : ℤ) = (t162_hi.toNat : ℤ)
      + (t170_hi.toNat : ℤ) := add_exact b_t162_hi b_t170_hi
  have f_t67_lo : (t67_lo.toNat : ℤ) + 2 ^ 64 * (t67_hi.toNat : ℤ) = (t59_lo.toNat : ℤ)
      + (t64_lo.toNat : ℤ) := addc_int t59_lo t64_lo
  have f_t111_lo : (t111_lo.toNat : ℤ) + 2 ^ 64 * (t111_hi.toNat : ℤ) = (t104_lo.toNat : ℤ)
      + (t108_lo.toNat : ℤ) := addc_int t104_lo t108_lo
  have f_t29_lo : (t29_lo.toNat : ℤ) + 2 ^ 64 * (t29_hi.toNat : ℤ) = (t6_hi.toNat : ℤ)
      + (t26_lo.toNat : ℤ) := addc_int t6_hi t26_lo
  have f_t70_lo : (t70_lo.toNat : ℤ) + 2 ^ 64 * (c70.toNat : ℤ) = (t29_hi.toNat : ℤ)
      + (t67_lo.toNat : ℤ) := addc_int t29_hi t67_lo
  have b_t29_hi : t29_hi.toNat ≤ 1 := carry_le' t6_hi t26_lo
  have g_t70_hi : (t70_hi.toNat : ℤ) = (t67_hi.toNat : ℤ)
      + (c70.toNat : ℤ) := or_carry t59_lo t64_lo t29_hi (b_t29_hi)
  have f_t114_lo : (t114_lo.toNat : ℤ) + 2 ^ 64 * (c114.toNat : ℤ) = (t70_hi.toNat : ℤ)
      + (t111_lo.toNat : ℤ) := addc_int t70_hi t111_lo
  have b_t67_hi : t67_hi.toNat ≤ 1 := carry_le' t59_lo t64_lo
  have b_c70 : c70.toNat ≤ 1 := carry_le' t29_hi t67_lo
  have b_t70_hi : t70_hi.toNat ≤ 1 := or_le' b_t67_hi b_c70
  have g_t114_hi : (t114_hi.toNat : ℤ) = (t111_hi.toNat : ℤ)
      + (c114.toNat : ℤ) := or_carry t104_lo t108_lo t70_hi (b_t70_hi)
  have f_t174_lo : (t174_lo.toNat : ℤ) + 2 ^ 64 * (t174_hi.toNat : ℤ) = (t114_hi.toNat : ℤ)
      + (t170_lo.toNat : ℤ) := addc_int t114_hi t170_lo
  have r_t231 : 2 ^ 64 * (t6_lo.toNat : ℤ) + 2 ^ 384 * (t230.toNat : ℤ)
      + 2 ^ 128 * (t29_lo.toNat : ℤ) + 2 ^ 192 * (t70_lo.toNat : ℤ)
      + 2 ^ 256 * (t114_lo.toNat : ℤ) + 2 ^ 320 * (t174_lo.toNat : ℤ)
      + 2 ^ 384 * (t174_hi.toNat : ℤ) = 2 ^ 64 * (x0.toNat : ℤ) * (x1.toNat : ℤ)
      + 2 ^ 128 * (x0.toNat : ℤ) * (x2.toNat : ℤ) + 2 ^ 192 * (x0.toNat : ℤ) * (x3.toNat : ℤ)
      + 2 ^ 192 * (x1.toNat : ℤ) * (x2.toNat : ℤ) + 2 ^ 256 * (x1.toNat : ℤ) * (x3.toNat : ℤ)
      + 2 ^ 320 * (x2.toNat : ℤ) * (x3.toNat : ℤ)
      := sqr_row_t231 f_t6_lo f_t54_lo f_t162_lo f_t26_lo f_t64_lo f_t101_lo f_t108_lo f_t167_lo
      f_t59_lo f_t104_lo g_t104_hi f_t170_lo g_t170_hi f_t230 f_t67_lo f_t111_lo f_t29_lo f_t70_lo
      g_t70_hi f_t114_lo g_t114_hi f_t174_lo
  have l_t231 : (t174_hi.toNat : ℤ) + (t230.toNat : ℤ) < 2 ^ 64 := by
    linarith only [r_t231, m_x0_x0, m_x0_x1, m_x0_x2, m_x0_x3, m_x1_x1, m_x1_x2, m_x1_x3, m_x2_x2,
        m_x2_x3, m_x3_x3, Int.natCast_nonneg t6_lo.toNat, Int.natCast_nonneg t29_lo.toNat,
        Int.natCast_nonneg t70_lo.toNat, Int.natCast_nonneg t114_lo.toNat,
        Int.natCast_nonneg t174_lo.toNat]
  have f_t231 : (t231.toNat : ℤ) = (t174_hi.toNat : ℤ) + (t230.toNat : ℤ) := add_exact_of_lt l_t231
  have f_t1_lo : (t1_lo.toNat : ℤ)
      + 2 ^ 64 * (t1_hi.toNat : ℤ) = (x0.toNat : ℤ) * (x0.toNat : ℤ) := split_mul x0 x0
  have f_t19_lo : (t19_lo.toNat : ℤ)
      + 2 ^ 64 * (t19_hi.toNat : ℤ) = (x1.toNat : ℤ) * (x1.toNat : ℤ) := split_mul x1 x1
  have f_t34_lo : (t34_lo.toNat : ℤ) + 2 ^ 64 * (t34_hi.toNat : ℤ) = (t29_lo.toNat : ℤ)
      + (t29_lo.toNat : ℤ) := addc_int t29_lo t29_lo
  have f_t74_lo : (t74_lo.toNat : ℤ) + 2 ^ 64 * (t74_hi.toNat : ℤ) = (t70_lo.toNat : ℤ)
      + (t70_lo.toNat : ℤ) := addc_int t70_lo t70_lo
  have f_t88_lo : (t88_lo.toNat : ℤ)
      + 2 ^ 64 * (t88_hi.toNat : ℤ) = (x2.toNat : ℤ) * (x2.toNat : ℤ) := split_mul x2 x2
  have f_t118_lo : (t118_lo.toNat : ℤ) + 2 ^ 64 * (t118_hi.toNat : ℤ) = (t114_lo.toNat : ℤ)
      + (t114_lo.toNat : ℤ) := addc_int t114_lo t114_lo
  have f_t179_lo : (t179_lo.toNat : ℤ) + 2 ^ 64 * (t179_hi.toNat : ℤ) = (t174_lo.toNat : ℤ)
      + (t174_lo.toNat : ℤ) := addc_int t174_lo t174_lo
  have f_t219_lo : (t219_lo.toNat : ℤ)
      + 2 ^ 64 * (t219_hi.toNat : ℤ) = (x3.toNat : ℤ) * (x3.toNat : ℤ) := split_mul x3 x3
  have f_t232_lo : (t232_lo.toNat : ℤ) + 2 ^ 64 * (t232_hi.toNat : ℤ) = (t231.toNat : ℤ)
      + (t231.toNat : ℤ) := addc_int t231 t231
  have f_t9_lo : (t9_lo.toNat : ℤ) + 2 ^ 64 * (t9_hi.toNat : ℤ) = (t6_lo.toNat : ℤ)
      + (t6_lo.toNat : ℤ) := addc_int t6_lo t6_lo
  have f_t37_lo : (t37_lo.toNat : ℤ) + 2 ^ 64 * (c37.toNat : ℤ) = (t9_hi.toNat : ℤ)
      + (t34_lo.toNat : ℤ) := addc_int t9_hi t34_lo
  have b_t9_hi : t9_hi.toNat ≤ 1 := carry_le' t6_lo t6_lo
  have g_t37_hi : (t37_hi.toNat : ℤ) = (t34_hi.toNat : ℤ)
      + (c37.toNat : ℤ) := or_carry t29_lo t29_lo t9_hi (b_t9_hi)
  have f_t77_lo : (t77_lo.toNat : ℤ) + 2 ^ 64 * (c77.toNat : ℤ) = (t37_hi.toNat : ℤ)
      + (t74_lo.toNat : ℤ) := addc_int t37_hi t74_lo
  have b_t34_hi : t34_hi.toNat ≤ 1 := carry_le' t29_lo t29_lo
  have b_c37 : c37.toNat ≤ 1 := carry_le' t9_hi t34_lo
  have b_t37_hi : t37_hi.toNat ≤ 1 := or_le' b_t34_hi b_c37
  have g_t77_hi : (t77_hi.toNat : ℤ) = (t74_hi.toNat : ℤ)
      + (c77.toNat : ℤ) := or_carry t70_lo t70_lo t37_hi (b_t37_hi)
  have f_t121_lo : (t121_lo.toNat : ℤ) + 2 ^ 64 * (c121.toNat : ℤ) = (t77_hi.toNat : ℤ)
      + (t118_lo.toNat : ℤ) := addc_int t77_hi t118_lo
  have b_t74_hi : t74_hi.toNat ≤ 1 := carry_le' t70_lo t70_lo
  have b_c77 : c77.toNat ≤ 1 := carry_le' t37_hi t74_lo
  have b_t77_hi : t77_hi.toNat ≤ 1 := or_le' b_t74_hi b_c77
  have g_t121_hi : (t121_hi.toNat : ℤ) = (t118_hi.toNat : ℤ)
      + (c121.toNat : ℤ) := or_carry t114_lo t114_lo t77_hi (b_t77_hi)
  have f_t182_lo : (t182_lo.toNat : ℤ) + 2 ^ 64 * (c182.toNat : ℤ) = (t121_hi.toNat : ℤ)
      + (t179_lo.toNat : ℤ) := addc_int t121_hi t179_lo
  have b_t118_hi : t118_hi.toNat ≤ 1 := carry_le' t114_lo t114_lo
  have b_c121 : c121.toNat ≤ 1 := carry_le' t77_hi t118_lo
  have b_t121_hi : t121_hi.toNat ≤ 1 := or_le' b_t118_hi b_c121
  have g_t182_hi : (t182_hi.toNat : ℤ) = (t179_hi.toNat : ℤ)
      + (c182.toNat : ℤ) := or_carry t174_lo t174_lo t121_hi (b_t121_hi)
  have f_t235_lo : (t235_lo.toNat : ℤ) + 2 ^ 64 * (c235.toNat : ℤ) = (t182_hi.toNat : ℤ)
      + (t232_lo.toNat : ℤ) := addc_int t182_hi t232_lo
  have b_t179_hi : t179_hi.toNat ≤ 1 := carry_le' t174_lo t174_lo
  have b_c182 : c182.toNat ≤ 1 := carry_le' t121_hi t179_lo
  have b_t182_hi : t182_hi.toNat ≤ 1 := or_le' b_t179_hi b_c182
  have g_t235_hi : (t235_hi.toNat : ℤ) = (t232_hi.toNat : ℤ)
      + (c235.toNat : ℤ) := or_carry t231 t231 t182_hi (b_t182_hi)
  have b_t219_hi : t219_hi.toNat ≤ 18446744073709551614 := hi_le' x3 x3
  have b_t232_hi : t232_hi.toNat ≤ 1 := carry_le' t231 t231
  have b_c235 : c235.toNat ≤ 1 := carry_le' t182_hi t232_lo
  have b_t235_hi : t235_hi.toNat ≤ 1 := or_le' b_t232_hi b_c235
  have f_t276 : (t276.toNat : ℤ) = (t219_hi.toNat : ℤ)
      + (t235_hi.toNat : ℤ) := add_exact b_t219_hi b_t235_hi
  have f_t41_lo : (t41_lo.toNat : ℤ) + 2 ^ 64 * (t41_hi.toNat : ℤ) = (t19_lo.toNat : ℤ)
      + (t37_lo.toNat : ℤ) := addc_int t19_lo t37_lo
  have f_t81_lo : (t81_lo.toNat : ℤ) + 2 ^ 64 * (t81_hi.toNat : ℤ) = (t19_hi.toNat : ℤ)
      + (t77_lo.toNat : ℤ) := addc_int t19_hi t77_lo
  have f_t125_lo : (t125_lo.toNat : ℤ) + 2 ^ 64 * (t125_hi.toNat : ℤ) = (t88_lo.toNat : ℤ)
      + (t121_lo.toNat : ℤ) := addc_int t88_lo t121_lo
  have f_t186_lo : (t186_lo.toNat : ℤ) + 2 ^ 64 * (t186_hi.toNat : ℤ) = (t88_hi.toNat : ℤ)
      + (t182_lo.toNat : ℤ) := addc_int t88_hi t182_lo
  have f_t239_lo : (t239_lo.toNat : ℤ) + 2 ^ 64 * (t239_hi.toNat : ℤ) = (t219_lo.toNat : ℤ)
      + (t235_lo.toNat : ℤ) := addc_int t219_lo t235_lo
  have f_t14_lo : (t14_lo.toNat : ℤ) + 2 ^ 64 * (t14_hi.toNat : ℤ) = (t1_hi.toNat : ℤ)
      + (t9_lo.toNat : ℤ) := addc_int t1_hi t9_lo
  have f_t44_lo : (t44_lo.toNat : ℤ) + 2 ^ 64 * (c44.toNat : ℤ) = (t14_hi.toNat : ℤ)
      + (t41_lo.toNat : ℤ) := addc_int t14_hi t41_lo
  have b_t14_hi : t14_hi.toNat ≤ 1 := carry_le' t1_hi t9_lo
  have g_t44_hi : (t44_hi.toNat : ℤ) = (t41_hi.toNat : ℤ)
      + (c44.toNat : ℤ) := or_carry t19_lo t37_lo t14_hi (b_t14_hi)
  have f_t84_lo : (t84_lo.toNat : ℤ) + 2 ^ 64 * (c84.toNat : ℤ) = (t44_hi.toNat : ℤ)
      + (t81_lo.toNat : ℤ) := addc_int t44_hi t81_lo
  have b_t41_hi : t41_hi.toNat ≤ 1 := carry_le' t19_lo t37_lo
  have b_c44 : c44.toNat ≤ 1 := carry_le' t14_hi t41_lo
  have b_t44_hi : t44_hi.toNat ≤ 1 := or_le' b_t41_hi b_c44
  have g_t84_hi : (t84_hi.toNat : ℤ) = (t81_hi.toNat : ℤ)
      + (c84.toNat : ℤ) := or_carry t19_hi t77_lo t44_hi (b_t44_hi)
  have f_t128_lo : (t128_lo.toNat : ℤ) + 2 ^ 64 * (c128.toNat : ℤ) = (t84_hi.toNat : ℤ)
      + (t125_lo.toNat : ℤ) := addc_int t84_hi t125_lo
  have b_t81_hi : t81_hi.toNat ≤ 1 := carry_le' t19_hi t77_lo
  have b_c84 : c84.toNat ≤ 1 := carry_le' t44_hi t81_lo
  have b_t84_hi : t84_hi.toNat ≤ 1 := or_le' b_t81_hi b_c84
  have g_t128_hi : (t128_hi.toNat : ℤ) = (t125_hi.toNat : ℤ)
      + (c128.toNat : ℤ) := or_carry t88_lo t121_lo t84_hi (b_t84_hi)
  have f_t189_lo : (t189_lo.toNat : ℤ) + 2 ^ 64 * (c189.toNat : ℤ) = (t128_hi.toNat : ℤ)
      + (t186_lo.toNat : ℤ) := addc_int t128_hi t186_lo
  have b_t125_hi : t125_hi.toNat ≤ 1 := carry_le' t88_lo t121_lo
  have b_c128 : c128.toNat ≤ 1 := carry_le' t84_hi t125_lo
  have b_t128_hi : t128_hi.toNat ≤ 1 := or_le' b_t125_hi b_c128
  have g_t189_hi : (t189_hi.toNat : ℤ) = (t186_hi.toNat : ℤ)
      + (c189.toNat : ℤ) := or_carry t88_hi t182_lo t128_hi (b_t128_hi)
  have f_t242_lo : (t242_lo.toNat : ℤ) + 2 ^ 64 * (c242.toNat : ℤ) = (t189_hi.toNat : ℤ)
      + (t239_lo.toNat : ℤ) := addc_int t189_hi t239_lo
  have b_t186_hi : t186_hi.toNat ≤ 1 := carry_le' t88_hi t182_lo
  have b_c189 : c189.toNat ≤ 1 := carry_le' t128_hi t186_lo
  have b_t189_hi : t189_hi.toNat ≤ 1 := or_le' b_t186_hi b_c189
  have g_t242_hi : (t242_hi.toNat : ℤ) = (t239_hi.toNat : ℤ)
      + (c242.toNat : ℤ) := or_carry t219_lo t235_lo t189_hi (b_t189_hi)
  have r_t277 : (t1_lo.toNat : ℤ) + 2 ^ 448 * (t276.toNat : ℤ) + 2 ^ 64 * (t14_lo.toNat : ℤ)
      + 2 ^ 128 * (t44_lo.toNat : ℤ) + 2 ^ 192 * (t84_lo.toNat : ℤ)
      + 2 ^ 256 * (t128_lo.toNat : ℤ) + 2 ^ 320 * (t189_lo.toNat : ℤ)
      + 2 ^ 384 * (t242_lo.toNat : ℤ)
      + 2 ^ 448 * (t242_hi.toNat : ℤ) = (x0.toNat : ℤ) * (x0.toNat : ℤ)
      + 2 ^ 65 * (x0.toNat : ℤ) * (x1.toNat : ℤ) + 2 ^ 129 * (x0.toNat : ℤ) * (x2.toNat : ℤ)
      + 2 ^ 193 * (x0.toNat : ℤ) * (x3.toNat : ℤ) + 2 ^ 128 * (x1.toNat : ℤ) * (x1.toNat : ℤ)
      + 2 ^ 193 * (x1.toNat : ℤ) * (x2.toNat : ℤ) + 2 ^ 257 * (x1.toNat : ℤ) * (x3.toNat : ℤ)
      + 2 ^ 256 * (x2.toNat : ℤ) * (x2.toNat : ℤ) + 2 ^ 321 * (x2.toNat : ℤ) * (x3.toNat : ℤ)
      + 2 ^ 384 * (x3.toNat : ℤ) * (x3.toNat : ℤ)
      := sqr_row_t277 f_t6_lo f_t54_lo f_t162_lo f_t26_lo f_t64_lo f_t101_lo f_t108_lo f_t167_lo
      f_t59_lo f_t104_lo g_t104_hi f_t170_lo g_t170_hi f_t230 f_t67_lo f_t111_lo f_t29_lo f_t70_lo
      g_t70_hi f_t114_lo g_t114_hi f_t174_lo f_t231 f_t1_lo f_t19_lo f_t34_lo f_t74_lo f_t88_lo
      f_t118_lo f_t179_lo f_t219_lo f_t232_lo f_t9_lo f_t37_lo g_t37_hi f_t77_lo g_t77_hi f_t121_lo
      g_t121_hi f_t182_lo g_t182_hi f_t235_lo g_t235_hi f_t276 f_t41_lo f_t81_lo f_t125_lo
      f_t186_lo f_t239_lo f_t14_lo f_t44_lo g_t44_hi f_t84_lo g_t84_hi f_t128_lo g_t128_hi
      f_t189_lo g_t189_hi f_t242_lo g_t242_hi
  have l_t277 : (t242_hi.toNat : ℤ) + (t276.toNat : ℤ) < 2 ^ 64 := by
    linarith only [r_t277, m_x0_x0, m_x0_x1, m_x0_x2, m_x0_x3, m_x1_x1, m_x1_x2, m_x1_x3, m_x2_x2,
        m_x2_x3, m_x3_x3, Int.natCast_nonneg t1_lo.toNat, Int.natCast_nonneg t14_lo.toNat,
        Int.natCast_nonneg t44_lo.toNat, Int.natCast_nonneg t84_lo.toNat,
        Int.natCast_nonneg t128_lo.toNat, Int.natCast_nonneg t189_lo.toNat,
        Int.natCast_nonneg t242_lo.toNat]
  have f_t277 : (t277.toNat : ℤ) = (t242_hi.toNat : ℤ) + (t276.toNat : ℤ) := add_exact_of_lt l_t277
  have f_t132_lo : (t132_lo.toNat : ℤ)
      + 2 ^ 64 * (t132_hi.toNat : ℤ) = (t128_lo.toNat : ℤ) * 38 := split_mul38 t128_lo
  have f_t193_lo : (t193_lo.toNat : ℤ)
      + 2 ^ 64 * (t193_hi.toNat : ℤ) = (t189_lo.toNat : ℤ) * 38 := split_mul38 t189_lo
  have f_t210_lo : (t210_lo.toNat : ℤ) + 2 ^ 64 * (t210_hi.toNat : ℤ) = (t44_lo.toNat : ℤ)
      + (t193_hi.toNat : ℤ) := addc_int t44_lo t193_hi
  have f_t246_lo : (t246_lo.toNat : ℤ)
      + 2 ^ 64 * (t246_hi.toNat : ℤ) = (t242_lo.toNat : ℤ) * 38 := split_mul38 t242_lo
  have f_t263_lo : (t263_lo.toNat : ℤ) + 2 ^ 64 * (t263_hi.toNat : ℤ) = (t84_lo.toNat : ℤ)
      + (t246_hi.toNat : ℤ) := addc_int t84_lo t246_hi
  have f_t278_lo : (t278_lo.toNat : ℤ)
      + 2 ^ 64 * (t278_hi.toNat : ℤ) = (t277.toNat : ℤ) * 38 := split_mul38 t277
  have f_t147_lo : (t147_lo.toNat : ℤ) + 2 ^ 64 * (t147_hi.toNat : ℤ) = (t14_lo.toNat : ℤ)
      + (t132_hi.toNat : ℤ) := addc_int t14_lo t132_hi
  have f_t213_lo : (t213_lo.toNat : ℤ) + 2 ^ 64 * (c213.toNat : ℤ) = (t147_hi.toNat : ℤ)
      + (t210_lo.toNat : ℤ) := addc_int t147_hi t210_lo
  have b_t147_hi : t147_hi.toNat ≤ 1 := carry_le' t14_lo t132_hi
  have g_t213_hi : (t213_hi.toNat : ℤ) = (t210_hi.toNat : ℤ)
      + (c213.toNat : ℤ) := or_carry t44_lo t193_hi t147_hi (b_t147_hi)
  have f_t266_lo : (t266_lo.toNat : ℤ) + 2 ^ 64 * (c266.toNat : ℤ) = (t213_hi.toNat : ℤ)
      + (t263_lo.toNat : ℤ) := addc_int t213_hi t263_lo
  have b_t210_hi : t210_hi.toNat ≤ 1 := carry_le' t44_lo t193_hi
  have b_c213 : c213.toNat ≤ 1 := carry_le' t147_hi t210_lo
  have b_t213_hi : t213_hi.toNat ≤ 1 := or_le' b_t210_hi b_c213
  have g_t266_hi : (t266_hi.toNat : ℤ) = (t263_hi.toNat : ℤ)
      + (c266.toNat : ℤ) := or_carry t84_lo t246_hi t213_hi (b_t213_hi)
  have b_t263_hi : t263_hi.toNat ≤ 1 := carry_le' t84_lo t246_hi
  have b_c266 : c266.toNat ≤ 1 := carry_le' t213_hi t263_lo
  have b_t266_hi : t266_hi.toNat ≤ 1 := or_le' b_t263_hi b_c266
  have b_t278_hi : t278_hi.toNat ≤ 37 := hi38_le' t277
  have f_t293 : (t293.toNat : ℤ) = (t266_hi.toNat : ℤ)
      + (t278_hi.toNat : ℤ) := add_exact b_t266_hi b_t278_hi
  have f_t197_lo : (t197_lo.toNat : ℤ) + 2 ^ 64 * (t197_hi.toNat : ℤ) = (t147_lo.toNat : ℤ)
      + (t193_lo.toNat : ℤ) := addc_int t147_lo t193_lo
  have f_t250_lo : (t250_lo.toNat : ℤ) + 2 ^ 64 * (t250_hi.toNat : ℤ) = (t213_lo.toNat : ℤ)
      + (t246_lo.toNat : ℤ) := addc_int t213_lo t246_lo
  have f_t282_lo : (t282_lo.toNat : ℤ) + 2 ^ 64 * (t282_hi.toNat : ℤ) = (t266_lo.toNat : ℤ)
      + (t278_lo.toNat : ℤ) := addc_int t266_lo t278_lo
  have f_t136_lo : (t136_lo.toNat : ℤ) + 2 ^ 64 * (t136_hi.toNat : ℤ) = (t1_lo.toNat : ℤ)
      + (t132_lo.toNat : ℤ) := addc_int t1_lo t132_lo
  have f_t200_lo : (t200_lo.toNat : ℤ) + 2 ^ 64 * (c200.toNat : ℤ) = (t136_hi.toNat : ℤ)
      + (t197_lo.toNat : ℤ) := addc_int t136_hi t197_lo
  have b_t136_hi : t136_hi.toNat ≤ 1 := carry_le' t1_lo t132_lo
  have g_t200_hi : (t200_hi.toNat : ℤ) = (t197_hi.toNat : ℤ)
      + (c200.toNat : ℤ) := or_carry t147_lo t193_lo t136_hi (b_t136_hi)
  have f_t253_lo : (t253_lo.toNat : ℤ) + 2 ^ 64 * (c253.toNat : ℤ) = (t200_hi.toNat : ℤ)
      + (t250_lo.toNat : ℤ) := addc_int t200_hi t250_lo
  have b_t197_hi : t197_hi.toNat ≤ 1 := carry_le' t147_lo t193_lo
  have b_c200 : c200.toNat ≤ 1 := carry_le' t136_hi t197_lo
  have b_t200_hi : t200_hi.toNat ≤ 1 := or_le' b_t197_hi b_c200
  have g_t253_hi : (t253_hi.toNat : ℤ) = (t250_hi.toNat : ℤ)
      + (c253.toNat : ℤ) := or_carry t213_lo t246_lo t200_hi (b_t200_hi)
  have f_t285_lo : (t285_lo.toNat : ℤ) + 2 ^ 64 * (c285.toNat : ℤ) = (t253_hi.toNat : ℤ)
      + (t282_lo.toNat : ℤ) := addc_int t253_hi t282_lo
  have b_t250_hi : t250_hi.toNat ≤ 1 := carry_le' t213_lo t246_lo
  have b_c253 : c253.toNat ≤ 1 := carry_le' t200_hi t250_lo
  have b_t253_hi : t253_hi.toNat ≤ 1 := or_le' b_t250_hi b_c253
  have g_t285_hi : (t285_hi.toNat : ℤ) = (t282_hi.toNat : ℤ)
      + (c285.toNat : ℤ) := or_carry t266_lo t278_lo t253_hi (b_t253_hi)
  have b_t282_hi : t282_hi.toNat ≤ 1 := carry_le' t266_lo t278_lo
  have b_c285 : c285.toNat ≤ 1 := carry_le' t253_hi t282_lo
  have b_t285_hi : t285_hi.toNat ≤ 1 := or_le' b_t282_hi b_c285
  have b_t293 : t293.toNat ≤ 38 := add_le' b_t266_hi b_t278_hi
  have f_t294 : (t294.toNat : ℤ) = (t285_hi.toNat : ℤ)
      + (t293.toNat : ℤ) := add_exact b_t285_hi b_t293
  have b_t294 : t294.toNat ≤ 39 := add_le' b_t285_hi b_t293
  have f_t295 : (t295.toNat : ℤ) = 2 * (t294.toNat : ℤ) := mul2_exact (b_t294)
  have f_t324 : 2 ^ 63 * (t298.toNat : ℤ)
      + (t324.toNat : ℤ) = (t285_lo.toNat : ℤ) := split63 t285_lo
  have b_t295 : t295.toNat ≤ 78 := mul2_le' b_t294
  have b_t298 : t298.toNat ≤ 1 := top_le' t285_lo
  have f_t299 : (t299.toNat : ℤ) = (t295.toNat : ℤ) + (t298.toNat : ℤ) := add_exact b_t295 b_t298
  have b_t299 : t299.toNat ≤ 79 := add_le' b_t295 b_t298
  have f_t300 : (t300.toNat : ℤ) = 19 * (t299.toNat : ℤ) := mul19_exact (b_t299)
  have f_t301_lo : (t301_lo.toNat : ℤ) + 2 ^ 64 * (t301_hi.toNat : ℤ) = (t136_lo.toNat : ℤ)
      + (t300.toNat : ℤ) := addc_int t136_lo t300
  have f_t310_lo : (t310_lo.toNat : ℤ) + 2 ^ 64 * (t310_hi.toNat : ℤ) = (t200_lo.toNat : ℤ)
      + (t301_hi.toNat : ℤ) := addc_int t200_lo t301_hi
  have f_t319_lo : (t319_lo.toNat : ℤ) + 2 ^ 64 * (t319_hi.toNat : ℤ) = (t253_lo.toNat : ℤ)
      + (t310_hi.toNat : ℤ) := addc_int t253_lo t310_hi
  have b_t324 : t324.toNat ≤ 9223372036854775807 := mask_le' t285_lo
  have b_t319_hi : t319_hi.toNat ≤ 1 := carry_le' t253_lo t310_hi
  have f_t327 : (t327.toNat : ℤ) = (t324.toNat : ℤ)
      + (t319_hi.toNat : ℤ) := add_exact b_t324 b_t319_hi
  have hout : ((t327 ++ (t319_lo ++ (t310_lo ++ t301_lo))).toNat : ℤ) = (t301_lo.toNat : ℤ)
      + 2 ^ 64 * (t310_lo.toNat : ℤ) + 2 ^ 128 * (t319_lo.toNat : ℤ) + 2 ^ 192 * (t327.toNat : ℤ) :=
    toNat_concat4 t327 t319_lo t310_lo t301_lo
  refine ⟨2 * ((t128_lo.toNat : ℤ) + 2 ^ 64 * (t189_lo.toNat : ℤ) + 2 ^ 128 * (t242_lo.toNat : ℤ)
      + 2 ^ 192 * (t277.toNat : ℤ)) + (t299.toNat : ℤ), ?_, ?_⟩
  · rw [hout, hX]
    exact sqr_final f_t6_lo f_t54_lo f_t162_lo f_t26_lo f_t64_lo f_t101_lo f_t108_lo f_t167_lo
        f_t59_lo f_t104_lo g_t104_hi f_t170_lo g_t170_hi f_t230 f_t67_lo f_t111_lo f_t29_lo
        f_t70_lo g_t70_hi f_t114_lo g_t114_hi f_t174_lo f_t231 f_t1_lo f_t19_lo f_t34_lo f_t74_lo
        f_t88_lo f_t118_lo f_t179_lo f_t219_lo f_t232_lo f_t9_lo f_t37_lo g_t37_hi f_t77_lo
        g_t77_hi f_t121_lo g_t121_hi f_t182_lo g_t182_hi f_t235_lo g_t235_hi f_t276 f_t41_lo
        f_t81_lo f_t125_lo f_t186_lo f_t239_lo f_t14_lo f_t44_lo g_t44_hi f_t84_lo g_t84_hi
        f_t128_lo g_t128_hi f_t189_lo g_t189_hi f_t242_lo g_t242_hi f_t277 f_t132_lo f_t193_lo
        f_t210_lo f_t246_lo f_t263_lo f_t278_lo f_t147_lo f_t213_lo g_t213_hi f_t266_lo g_t266_hi
        f_t293 f_t197_lo f_t250_lo f_t282_lo f_t136_lo f_t200_lo g_t200_hi f_t253_lo g_t253_hi
        f_t285_lo g_t285_hi f_t294 f_t295 f_t324 f_t299 f_t300 f_t301_lo f_t310_lo f_t319_lo f_t327
  · have hlt : ((t327 ++ (t319_lo ++ (t310_lo ++ t301_lo))).toNat : ℤ) < 2 ^ 255 + 2 ^ 11 := by
      rw [hout]
      linarith only [f_t301_lo, f_t310_lo, f_t319_lo, f_t327, f_t300, b_t299, b_t324,
          le_max t136_lo, le_max t200_lo, le_max t253_lo]
    exact_mod_cast hlt

/-! ## Results -/

open _root_.Ed25519 in
/-- `mul X Y` is `X·Y` in the field. -/
public theorem mul_val (X Y : BitVec 256) : ((mul X Y).toNat : ZMod p) = X.toNat * Y.toNat := by
  obtain ⟨q, h, -⟩ := mul_aux X Y
  have h' := congrArg (Int.cast : ℤ → ZMod p) h
  simp only [Int.cast_add, Int.cast_mul, Int.cast_sub, Int.cast_pow, Int.cast_ofNat, two_pow_255,
    sub_self, zero_mul, add_zero] at h'
  exact_mod_cast h'

open _root_.Ed25519 in
public theorem mul_mod (X Y : BitVec 256) : (mul X Y).toNat % p = X.toNat * Y.toNat % p :=
  (ZMod.natCast_eq_natCast_iff' _ _ _).mp (by push_cast; exact mul_val X Y)

/-- `mul`'s result is weakly reduced. -/
public theorem mul_lt (X Y : BitVec 256) : (mul X Y).toNat < 2 ^ 255 + 2 ^ 11 :=
  (mul_aux X Y).choose_spec.2

open _root_.Ed25519 in
/-- `sqr X` is `X²` in the field. -/
public theorem sqr_val (X : BitVec 256) : ((sqr X).toNat : ZMod p) = X.toNat ^ 2 := by
  obtain ⟨q, h, -⟩ := sqr_aux X
  have h' := congrArg (Int.cast : ℤ → ZMod p) h
  simp only [Int.cast_add, Int.cast_mul, Int.cast_sub, Int.cast_pow, Int.cast_ofNat, two_pow_255,
    sub_self, zero_mul, add_zero] at h'
  rw [sq]
  exact_mod_cast h'

open _root_.Ed25519 in
public theorem sqr_mod (X : BitVec 256) : (sqr X).toNat % p = X.toNat ^ 2 % p :=
  (ZMod.natCast_eq_natCast_iff' _ _ _).mp (by push_cast; exact sqr_val X)

/-- `sqr`'s result is weakly reduced. -/
public theorem sqr_lt (X : BitVec 256) : (sqr X).toNat < 2 ^ 255 + 2 ^ 11 :=
  (sqr_aux X).choose_spec.2

end MLIR.Firedancer.Crc.Ref.Fe64

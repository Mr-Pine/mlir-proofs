module

public import Firedancer.Bn254.G1
public import Firedancer.Bn254.Math.Mont
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The `uint128` GLV helpers of `fd_bn254_glv.h` compute exact products, sums and differences on
the operands `fd_bn254_g1_scalar_mul` gives them: no accumulator wraps, for every 256-bit
scalar. -/

namespace Firedancer.Bn254

/-! ## Limbs and `uint128` -/

public theorem limbsEval_one (a : Vector (BitVec 64) 1) : limbsEval a = a[0].toNat := by
  simp [limbsEval, Nat.fold_succ]

public theorem limbsEval_two (a : Vector (BitVec 64) 2) :
    limbsEval a = a[0].toNat + a[1].toNat * 2 ^ 64 := by simp [limbsEval, Nat.fold_succ]

public theorem limbsEval_three (a : Vector (BitVec 64) 3) :
    limbsEval a = a[0].toNat + a[1].toNat * 2 ^ 64 + a[2].toNat * 2 ^ 128 := by
  simp [limbsEval, Nat.fold_succ]

theorem toNat_u128 (x : BitVec 64) : (u128 x).toNat = x.toNat := by
  have := x.isLt
  simp only [u128, BitVec.toNat_setWidth]
  omega

theorem toNat_u128_mul (x y : BitVec 64) : (u128 x * u128 y).toNat = x.toNat * y.toNat := by
  rw [BitVec.toNat_mul, toNat_u128, toNat_u128]
  have := Nat.mul_lt_mul'' x.isLt y.isLt
  exact Nat.mod_eq_of_lt (by omega)

theorem toNat_hi (a : BitVec 128) : (hi a).toNat = a.toNat / 2 ^ 64 := by
  have := a.isLt
  simp only [hi, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

theorem toNat_add_of_lt {x y : BitVec 128} (h : x.toNat + y.toNat < 2 ^ 128) :
    (x + y).toNat = x.toNat + y.toNat := by
  rw [BitVec.toNat_add]; exact Nat.mod_eq_of_lt h

theorem toNat_lo (a : BitVec 128) : (a.setWidth 64).toNat = a.toNat % 2 ^ 64 := by
  simp [BitVec.toNat_setWidth]

theorem toNat_shr (a : BitVec 128) : ((a >>> 64).setWidth 64).toNat = a.toNat / 2 ^ 64 := by
  have := a.isLt
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

theorem psum {P Q : BitVec 128} {X Y : ℕ} (hP : P.toNat = X) (hQ : Q.toNat = Y)
    (h : X + Y < 2 ^ 128) : (P + Q).toNat = X + Y := by
  rw [toNat_add_of_lt
      (by
        rw [hP, hQ]; exact h),
    hP, hQ]

theorem col {P a : BitVec 128} {X : ℕ} (hP : P.toNat = X) (h : X + a.toNat / 2 ^ 64 < 2 ^ 128) :
    (P + hi a).toNat = X + a.toNat / 2 ^ 64 :=
  psum hP (toNat_hi a) h

/-! ## Products -/

theorem sxg3_tele {p00 p10 p01 p20 p11 p02 p30 p21 p12 p31 p22 p32 A0 A1 A2 A3 A4 A5 A6 : ℕ}
    (e0 : A0 = p00) (e1 : A1 = p10 + p01 + A0 / 2 ^ 64) (e2 : A2 = p20 + p11 + p02 + A1 / 2 ^ 64)
    (e3 : A3 = p30 + p21 + p12 + A2 / 2 ^ 64) (e4 : A4 = p31 + p22 + A3 / 2 ^ 64)
    (e5 : A5 = p32 + A4 / 2 ^ 64) (e6 : A6 = A5 / 2 ^ 64) (h5 : A5 < 2 ^ 128) :
    A4 % 2 ^ 64 + A5 % 2 ^ 64 * 2 ^ 64 + A6 % 2 ^ 64 * 2 ^ 128 =
      (p00 +
          2 ^ 64 *
            (p10 + p01 +
              2 ^ 64 *
                (p20 + p11 + p02 +
                  2 ^ 64 * (p30 + p21 + p12 + 2 ^ 64 * (p31 + p22 + 2 ^ 64 * (p32)))))) /
        2 ^ 256 := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  have d2 := Nat.div_add_mod A2 (2 ^ 64)
  have m2 := Nat.mod_lt A2 (by norm_num : 0 < 2 ^ 64)
  have d3 := Nat.div_add_mod A3 (2 ^ 64)
  have m3 := Nat.mod_lt A3 (by norm_num : 0 < 2 ^ 64)
  have d4 := Nat.div_add_mod A4 (2 ^ 64)
  have m4 := Nat.mod_lt A4 (by norm_num : 0 < 2 ^ 64)
  have d5 := Nat.div_add_mod A5 (2 ^ 64)
  have m5 := Nat.mod_lt A5 (by norm_num : 0 < 2 ^ 64)
  have hL :
    p00 +
        2 ^ 64 *
          (p10 + p01 +
            2 ^ 64 *
              (p20 + p11 + p02 +
                2 ^ 64 * (p30 + p21 + p12 + 2 ^ 64 * (p31 + p22 + 2 ^ 64 * (p32))))) =
      (A0 % 2 ^ 64 + 2 ^ 64 * (A1 % 2 ^ 64 + 2 ^ 64 * (A2 % 2 ^ 64 + 2 ^ 64 * (A3 % 2 ^ 64)))) +
        2 ^ 256 * (A4 % 2 ^ 64 + 2 ^ 64 * A5) := by
    subst e0 e1 e2 e3 e4 e5; omega
  rw [hL, Nat.add_mul_div_left _ _ (by norm_num), Nat.div_eq_of_lt (by omega), e6]
  omega

theorem sxg2_tele {p00 p10 p01 p20 p11 p30 p21 p31 A0 A1 A2 A3 A4 A5 : ℕ} (e0 : A0 = p00)
    (e1 : A1 = p10 + p01 + A0 / 2 ^ 64) (e2 : A2 = p20 + p11 + A1 / 2 ^ 64)
    (e3 : A3 = p30 + p21 + A2 / 2 ^ 64) (e4 : A4 = p31 + A3 / 2 ^ 64) (e5 : A5 = A4 / 2 ^ 64)
    (h4 : A4 < 2 ^ 128) :
    A4 % 2 ^ 64 + A5 % 2 ^ 64 * 2 ^ 64 =
      (p00 + 2 ^ 64 * (p10 + p01 + 2 ^ 64 * (p20 + p11 + 2 ^ 64 * (p30 + p21 + 2 ^ 64 * (p31))))) /
        2 ^ 256 := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  have d2 := Nat.div_add_mod A2 (2 ^ 64)
  have m2 := Nat.mod_lt A2 (by norm_num : 0 < 2 ^ 64)
  have d3 := Nat.div_add_mod A3 (2 ^ 64)
  have m3 := Nat.mod_lt A3 (by norm_num : 0 < 2 ^ 64)
  have d4 := Nat.div_add_mod A4 (2 ^ 64)
  have m4 := Nat.mod_lt A4 (by norm_num : 0 < 2 ^ 64)
  have hL :
    p00 + 2 ^ 64 * (p10 + p01 + 2 ^ 64 * (p20 + p11 + 2 ^ 64 * (p30 + p21 + 2 ^ 64 * (p31)))) =
      (A0 % 2 ^ 64 + 2 ^ 64 * (A1 % 2 ^ 64 + 2 ^ 64 * (A2 % 2 ^ 64 + 2 ^ 64 * (A3 % 2 ^ 64)))) +
        2 ^ 256 * A4 := by
    subst e0 e1 e2 e3 e4; omega
  rw [hL, Nat.add_mul_div_left _ _ (by norm_num), Nat.div_eq_of_lt (by omega), e5]
  omega

theorem mul3x2_tele {p00 p10 p01 p20 p11 p21 A0 A1 A2 A3 : ℕ} (e0 : A0 = p00)
    (e1 : A1 = p10 + p01 + A0 / 2 ^ 64) (e2 : A2 = p20 + p11 + A1 / 2 ^ 64)
    (e3 : A3 = p21 + A2 / 2 ^ 64) :
    A0 % 2 ^ 64 + A1 % 2 ^ 64 * 2 ^ 64 + A2 % 2 ^ 64 * 2 ^ 128 + A3 % 2 ^ 64 * 2 ^ 192 =
      (p00 + 2 ^ 64 * (p10 + p01 + 2 ^ 64 * (p20 + p11 + 2 ^ 64 * (p21)))) % 2 ^ 256 := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  have d2 := Nat.div_add_mod A2 (2 ^ 64)
  have m2 := Nat.mod_lt A2 (by norm_num : 0 < 2 ^ 64)
  have d3 := Nat.div_add_mod A3 (2 ^ 64)
  have m3 := Nat.mod_lt A3 (by norm_num : 0 < 2 ^ 64)
  have hL :
    p00 + 2 ^ 64 * (p10 + p01 + 2 ^ 64 * (p20 + p11 + 2 ^ 64 * (p21))) =
      (A0 % 2 ^ 64 + 2 ^ 64 * (A1 % 2 ^ 64 + 2 ^ 64 * (A2 % 2 ^ 64 + 2 ^ 64 * (A3 % 2 ^ 64)))) +
        2 ^ 256 * (A3 / 2 ^ 64) := by
    subst e0 e1 e2 e3; omega
  have hX :
    A0 % 2 ^ 64 + 2 ^ 64 * (A1 % 2 ^ 64 + 2 ^ 64 * (A2 % 2 ^ 64 + 2 ^ 64 * (A3 % 2 ^ 64))) <
      2 ^ 256 := by
    omega
  rw [hL, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt hX]
  omega

theorem mul3x1_tele {p00 p10 p20 A0 A1 A2 A3 : ℕ} (e0 : A0 = p00) (e1 : A1 = p10 + A0 / 2 ^ 64)
    (e2 : A2 = p20 + A1 / 2 ^ 64) (e3 : A3 = A2 / 2 ^ 64) (h2 : A2 < 2 ^ 128) :
    A0 % 2 ^ 64 + A1 % 2 ^ 64 * 2 ^ 64 + A2 % 2 ^ 64 * 2 ^ 128 + A3 % 2 ^ 64 * 2 ^ 192 =
      p00 + 2 ^ 64 * (p10 + 2 ^ 64 * (p20)) := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  have d2 := Nat.div_add_mod A2 (2 ^ 64)
  have m2 := Nat.mod_lt A2 (by norm_num : 0 < 2 ^ 64)
  subst e0 e1 e2 e3; omega

theorem mul2x2_tele {p00 p10 p01 p11 A0 A1 A2 A3 : ℕ} (e0 : A0 = p00)
    (e1 : A1 = p10 + p01 + A0 / 2 ^ 64) (e2 : A2 = p11 + A1 / 2 ^ 64) (e3 : A3 = A2 / 2 ^ 64)
    (h2 : A2 < 2 ^ 128) :
    A0 % 2 ^ 64 + A1 % 2 ^ 64 * 2 ^ 64 + A2 % 2 ^ 64 * 2 ^ 128 + A3 % 2 ^ 64 * 2 ^ 192 =
      p00 + 2 ^ 64 * (p10 + p01 + 2 ^ 64 * (p11)) := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  have d2 := Nat.div_add_mod A2 (2 ^ 64)
  have m2 := Nat.mod_lt A2 (by norm_num : 0 < 2 ^ 64)
  subst e0 e1 e2 e3; omega

theorem mul2x1_tele {p00 p10 A0 A1 A2 : ℕ} (e0 : A0 = p00) (e1 : A1 = p10 + A0 / 2 ^ 64)
    (e2 : A2 = A1 / 2 ^ 64) (h1 : A1 < 2 ^ 128) :
    A0 % 2 ^ 64 + A1 % 2 ^ 64 * 2 ^ 64 + A2 % 2 ^ 64 * 2 ^ 128 = p00 + 2 ^ 64 * (p10) := by
  have d0 := Nat.div_add_mod A0 (2 ^ 64)
  have m0 := Nat.mod_lt A0 (by norm_num : 0 < 2 ^ 64)
  have d1 := Nat.div_add_mod A1 (2 ^ 64)
  have m1 := Nat.mod_lt A1 (by norm_num : 0 < 2 ^ 64)
  subst e0 e1 e2; omega

/-- `glv_sxg3( s, g )` is `⌊s · g / 2^256⌋` when `g`'s limbs sum below `2^64`. -/
public theorem fd_bn254_glv_sxg3.val (s : fd_bn254_scalar_t) (g : Vector (BitVec 64) 3)
    (hg : g[0].toNat + g[1].toNat + g[2].toNat < 2 ^ 64) :
    limbsEval (fd_bn254_glv_sxg3.spec s g) = limbsEval s * limbsEval g / 2 ^ 256 := by
  have hm :
    limbsEval s * limbsEval g =
      s[0].toNat * g[0].toNat +
        2 ^ 64 *
          (s[1].toNat * g[0].toNat + s[0].toNat * g[1].toNat +
            2 ^ 64 *
              (s[2].toNat * g[0].toNat + s[1].toNat * g[1].toNat + s[0].toNat * g[2].toNat +
                2 ^ 64 *
                  (s[3].toNat * g[0].toNat + s[2].toNat * g[1].toNat + s[1].toNat * g[2].toNat +
                    2 ^ 64 *
                      (s[3].toNat * g[1].toNat + s[2].toNat * g[2].toNat +
                        2 ^ 64 * (s[3].toNat * g[2].toNat))))) := by
    simp only [limbsEval_three, limbsEval_four]; ring
  have hx0 := s[0].isLt
  have hx1 := s[1].isLt
  have hx2 := s[2].isLt
  have hx3 := s[3].isLt
  have hy0 := g[0].isLt
  have hy1 := g[1].isLt
  have hy2 := g[2].isLt
  have hp00 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp01 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx0)
  have hp02 := Nat.mul_le_mul_right g[2].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx1)
  have hp11 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx1)
  have hp12 := Nat.mul_le_mul_right g[2].toNat (Nat.le_sub_one_of_lt hx1)
  have hp20 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx2)
  have hp21 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx2)
  have hp22 := Nat.mul_le_mul_right g[2].toNat (Nat.le_sub_one_of_lt hx2)
  have hp30 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx3)
  have hp31 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx3)
  have hp32 := Nat.mul_le_mul_right g[2].toNat (Nat.le_sub_one_of_lt hx3)
  rw [fd_bn254_glv_sxg3.spec]
  have e0 := (toNat_u128_mul s[0] g[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 s[0] * u128 g[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0)
      (psum (toNat_u128_mul s[1] g[0]) (toNat_u128_mul s[0] g[1])
        (by
          clear * - hp10 hp01 hy0 hy1 hy2 hg; omega))
      (by
        have := a0.isLt; clear * - this hp10 hp01 hy0 hy1 hy2 hg; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 s[1] * u128 g[0] + u128 s[0] * u128 g[1] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 :=
    (col (a := a1)
      (psum
        (psum (toNat_u128_mul s[2] g[0]) (toNat_u128_mul s[1] g[1])
          (by
            clear * - hp20 hp11 hp02 hy0 hy1 hy2 hg; omega))
        (toNat_u128_mul s[0] g[2])
        (by
          clear * - hp20 hp11 hp02 hy0 hy1 hy2 hg; omega))
      (by
        have := a1.isLt; clear * - this hp20 hp11 hp02 hy0 hy1 hy2 hg; omega))
  obtain ⟨a2, ha2⟩ :
    ∃ x, u128 s[2] * u128 g[0] + u128 s[1] * u128 g[1] + u128 s[0] * u128 g[2] + hi a1 = x :=
    ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  have e3 :=
    (col (a := a2)
      (psum
        (psum (toNat_u128_mul s[3] g[0]) (toNat_u128_mul s[2] g[1])
          (by
            clear * - hp30 hp21 hp12 hy0 hy1 hy2 hg; omega))
        (toNat_u128_mul s[1] g[2])
        (by
          clear * - hp30 hp21 hp12 hy0 hy1 hy2 hg; omega))
      (by
        have := a2.isLt; clear * - this hp30 hp21 hp12 hy0 hy1 hy2 hg; omega))
  obtain ⟨a3, ha3⟩ :
    ∃ x, u128 s[3] * u128 g[0] + u128 s[2] * u128 g[1] + u128 s[1] * u128 g[2] + hi a2 = x :=
    ⟨_, rfl⟩
  simp only [ha3] at e3 ⊢
  have e4 :=
    (col (a := a3)
      (psum (toNat_u128_mul s[3] g[1]) (toNat_u128_mul s[2] g[2])
        (by
          clear * - hp31 hp22 hy0 hy1 hy2 hg; omega))
      (by
        have := a3.isLt; clear * - this hp31 hp22 hy0 hy1 hy2 hg; omega))
  obtain ⟨a4, ha4⟩ : ∃ x, u128 s[3] * u128 g[1] + u128 s[2] * u128 g[2] + hi a3 = x := ⟨_, rfl⟩
  simp only [ha4] at e4 ⊢
  have e5 :=
    (col (a := a4) (toNat_u128_mul s[3] g[2])
      (by
        have := a4.isLt; clear * - this hp32 hy0 hy1 hy2 hg; omega))
  obtain ⟨a5, ha5⟩ : ∃ x, u128 s[3] * u128 g[2] + hi a4 = x := ⟨_, rfl⟩
  simp only [ha5] at e5 ⊢
  have e6 := (toNat_hi a5)
  obtain ⟨a6, ha6⟩ : ∃ x, hi a5 = x := ⟨_, rfl⟩
  simp only [ha6] at e6 ⊢
  rw [hm]
  simp only [limbsEval_three, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact sxg3_tele e0 e1 e2 e3 e4 e5 e6 a5.isLt

/-- `glv_sxg2( s, g )` is `⌊s · g / 2^256⌋` when `g`'s limbs sum below `2^64`. -/
public theorem fd_bn254_glv_sxg2.val (s : fd_bn254_scalar_t) (g : Vector (BitVec 64) 2)
    (hg : g[0].toNat + g[1].toNat < 2 ^ 64) :
    limbsEval (fd_bn254_glv_sxg2.spec s g) = limbsEval s * limbsEval g / 2 ^ 256 := by
  have hm :
    limbsEval s * limbsEval g =
      s[0].toNat * g[0].toNat +
        2 ^ 64 *
          (s[1].toNat * g[0].toNat + s[0].toNat * g[1].toNat +
            2 ^ 64 *
              (s[2].toNat * g[0].toNat + s[1].toNat * g[1].toNat +
                2 ^ 64 *
                  (s[3].toNat * g[0].toNat + s[2].toNat * g[1].toNat +
                    2 ^ 64 * (s[3].toNat * g[1].toNat)))) := by
    simp only [limbsEval_two, limbsEval_four]; ring
  have hx0 := s[0].isLt
  have hx1 := s[1].isLt
  have hx2 := s[2].isLt
  have hx3 := s[3].isLt
  have hy0 := g[0].isLt
  have hy1 := g[1].isLt
  have hp00 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp01 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx1)
  have hp11 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx1)
  have hp20 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx2)
  have hp21 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx2)
  have hp30 := Nat.mul_le_mul_right g[0].toNat (Nat.le_sub_one_of_lt hx3)
  have hp31 := Nat.mul_le_mul_right g[1].toNat (Nat.le_sub_one_of_lt hx3)
  rw [fd_bn254_glv_sxg2.spec]
  have e0 := (toNat_u128_mul s[0] g[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 s[0] * u128 g[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0)
      (psum (toNat_u128_mul s[1] g[0]) (toNat_u128_mul s[0] g[1])
        (by
          clear * - hp10 hp01 hy0 hy1 hg; omega))
      (by
        have := a0.isLt; clear * - this hp10 hp01 hy0 hy1 hg; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 s[1] * u128 g[0] + u128 s[0] * u128 g[1] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 :=
    (col (a := a1)
      (psum (toNat_u128_mul s[2] g[0]) (toNat_u128_mul s[1] g[1])
        (by
          clear * - hp20 hp11 hy0 hy1 hg; omega))
      (by
        have := a1.isLt; clear * - this hp20 hp11 hy0 hy1 hg; omega))
  obtain ⟨a2, ha2⟩ : ∃ x, u128 s[2] * u128 g[0] + u128 s[1] * u128 g[1] + hi a1 = x := ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  have e3 :=
    (col (a := a2)
      (psum (toNat_u128_mul s[3] g[0]) (toNat_u128_mul s[2] g[1])
        (by
          clear * - hp30 hp21 hy0 hy1 hg; omega))
      (by
        have := a2.isLt; clear * - this hp30 hp21 hy0 hy1 hg; omega))
  obtain ⟨a3, ha3⟩ : ∃ x, u128 s[3] * u128 g[0] + u128 s[2] * u128 g[1] + hi a2 = x := ⟨_, rfl⟩
  simp only [ha3] at e3 ⊢
  have e4 :=
    (col (a := a3) (toNat_u128_mul s[3] g[1])
      (by
        have := a3.isLt; clear * - this hp31 hy0 hy1 hg; omega))
  obtain ⟨a4, ha4⟩ : ∃ x, u128 s[3] * u128 g[1] + hi a3 = x := ⟨_, rfl⟩
  simp only [ha4] at e4 ⊢
  have e5 := (toNat_hi a4)
  obtain ⟨a5, ha5⟩ : ∃ x, hi a4 = x := ⟨_, rfl⟩
  simp only [ha5] at e5 ⊢
  rw [hm]
  simp only [limbsEval_two, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact sxg2_tele e0 e1 e2 e3 e4 e5 a4.isLt

/-- `glv_mul3x2( a, n )` is `a · n mod 2^256` when `n`'s limbs sum below `2^64`. -/
public theorem fd_bn254_glv_mul3x2.val (a : Vector (BitVec 64) 3) (n : Vector (BitVec 64) 2)
    (hg : n[0].toNat + n[1].toNat < 2 ^ 64) :
    limbsEval (fd_bn254_glv_mul3x2.spec a n) = limbsEval a * limbsEval n % 2 ^ 256 := by
  have hm :
    limbsEval a * limbsEval n =
      a[0].toNat * n[0].toNat +
        2 ^ 64 *
          (a[1].toNat * n[0].toNat + a[0].toNat * n[1].toNat +
            2 ^ 64 *
              (a[2].toNat * n[0].toNat + a[1].toNat * n[1].toNat +
                2 ^ 64 * (a[2].toNat * n[1].toNat))) := by
    simp only [limbsEval_two, limbsEval_three]; ring
  have hx0 := a[0].isLt
  have hx1 := a[1].isLt
  have hx2 := a[2].isLt
  have hy0 := n[0].isLt
  have hy1 := n[1].isLt
  have hp00 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp01 := Nat.mul_le_mul_right n[1].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx1)
  have hp11 := Nat.mul_le_mul_right n[1].toNat (Nat.le_sub_one_of_lt hx1)
  have hp20 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx2)
  have hp21 := Nat.mul_le_mul_right n[1].toNat (Nat.le_sub_one_of_lt hx2)
  rw [fd_bn254_glv_mul3x2.spec]
  have e0 := (toNat_u128_mul a[0] n[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 a[0] * u128 n[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0)
      (psum (toNat_u128_mul a[1] n[0]) (toNat_u128_mul a[0] n[1])
        (by
          clear * - hp10 hp01 hy0 hy1 hg; omega))
      (by
        have := a0.isLt; clear * - this hp10 hp01 hy0 hy1 hg; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 a[1] * u128 n[0] + u128 a[0] * u128 n[1] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 :=
    (col (a := a1)
      (psum (toNat_u128_mul a[2] n[0]) (toNat_u128_mul a[1] n[1])
        (by
          clear * - hp20 hp11 hy0 hy1 hg; omega))
      (by
        have := a1.isLt; clear * - this hp20 hp11 hy0 hy1 hg; omega))
  obtain ⟨a2, ha2⟩ : ∃ x, u128 a[2] * u128 n[0] + u128 a[1] * u128 n[1] + hi a1 = x := ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  have e3 :=
    (col (a := a2) (toNat_u128_mul a[2] n[1])
      (by
        have := a2.isLt; clear * - this hp21 hy0 hy1 hg; omega))
  obtain ⟨a3, ha3⟩ : ∃ x, u128 a[2] * u128 n[1] + hi a2 = x := ⟨_, rfl⟩
  simp only [ha3] at e3 ⊢
  rw [hm]
  simp only [limbsEval_four, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact mul3x2_tele e0 e1 e2 e3

/-- `glv_mul3x1( a, n )` is `a · n`. -/
public theorem fd_bn254_glv_mul3x1.val (a : Vector (BitVec 64) 3) (n : Vector (BitVec 64) 1) :
    limbsEval (fd_bn254_glv_mul3x1.spec a n) = limbsEval a * limbsEval n := by
  have hm :
    limbsEval a * limbsEval n =
      a[0].toNat * n[0].toNat +
        2 ^ 64 * (a[1].toNat * n[0].toNat + 2 ^ 64 * (a[2].toNat * n[0].toNat)) := by
    simp only [limbsEval_one, limbsEval_three]; ring
  have hx0 := a[0].isLt
  have hx1 := a[1].isLt
  have hx2 := a[2].isLt
  have hy0 := n[0].isLt
  have hp00 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx1)
  have hp20 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx2)
  rw [fd_bn254_glv_mul3x1.spec]
  have e0 := (toNat_u128_mul a[0] n[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 a[0] * u128 n[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0) (toNat_u128_mul a[1] n[0])
      (by
        have := a0.isLt; clear * - this hp10 hy0; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 a[1] * u128 n[0] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 :=
    (col (a := a1) (toNat_u128_mul a[2] n[0])
      (by
        have := a1.isLt; clear * - this hp20 hy0; omega))
  obtain ⟨a2, ha2⟩ : ∃ x, u128 a[2] * u128 n[0] + hi a1 = x := ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  have e3 := (toNat_hi a2)
  obtain ⟨a3, ha3⟩ : ∃ x, hi a2 = x := ⟨_, rfl⟩
  simp only [ha3] at e3 ⊢
  rw [hm]
  simp only [limbsEval_four, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact mul3x1_tele e0 e1 e2 e3 a2.isLt

/-- `glv_mul2x2( a, n )` is `a · n` when `n`'s limbs sum below `2^64`. -/
public theorem fd_bn254_glv_mul2x2.val (a : Vector (BitVec 64) 2) (n : Vector (BitVec 64) 2)
    (hg : n[0].toNat + n[1].toNat < 2 ^ 64) :
    limbsEval (fd_bn254_glv_mul2x2.spec a n) = limbsEval a * limbsEval n := by
  have hm :
    limbsEval a * limbsEval n =
      a[0].toNat * n[0].toNat +
        2 ^ 64 *
          (a[1].toNat * n[0].toNat + a[0].toNat * n[1].toNat +
            2 ^ 64 * (a[1].toNat * n[1].toNat)) := by
    simp only [limbsEval_two]; ring
  have hx0 := a[0].isLt
  have hx1 := a[1].isLt
  have hy0 := n[0].isLt
  have hy1 := n[1].isLt
  have hp00 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp01 := Nat.mul_le_mul_right n[1].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx1)
  have hp11 := Nat.mul_le_mul_right n[1].toNat (Nat.le_sub_one_of_lt hx1)
  rw [fd_bn254_glv_mul2x2.spec]
  have e0 := (toNat_u128_mul a[0] n[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 a[0] * u128 n[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0)
      (psum (toNat_u128_mul a[1] n[0]) (toNat_u128_mul a[0] n[1])
        (by
          clear * - hp10 hp01 hy0 hy1 hg; omega))
      (by
        have := a0.isLt; clear * - this hp10 hp01 hy0 hy1 hg; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 a[1] * u128 n[0] + u128 a[0] * u128 n[1] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 :=
    (col (a := a1) (toNat_u128_mul a[1] n[1])
      (by
        have := a1.isLt; clear * - this hp11 hy0 hy1 hg; omega))
  obtain ⟨a2, ha2⟩ : ∃ x, u128 a[1] * u128 n[1] + hi a1 = x := ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  have e3 := (toNat_hi a2)
  obtain ⟨a3, ha3⟩ : ∃ x, hi a2 = x := ⟨_, rfl⟩
  simp only [ha3] at e3 ⊢
  rw [hm]
  simp only [limbsEval_four, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact mul2x2_tele e0 e1 e2 e3 a2.isLt

/-- `glv_mul2x1( a, n )` is `a · n`. -/
public theorem fd_bn254_glv_mul2x1.val (a : Vector (BitVec 64) 2) (n : Vector (BitVec 64) 1) :
    limbsEval (fd_bn254_glv_mul2x1.spec a n) = limbsEval a * limbsEval n := by
  have hm :
    limbsEval a * limbsEval n = a[0].toNat * n[0].toNat + 2 ^ 64 * (a[1].toNat * n[0].toNat) := by
    simp only [limbsEval_one, limbsEval_two]; ring
  have hx0 := a[0].isLt
  have hx1 := a[1].isLt
  have hy0 := n[0].isLt
  have hp00 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx0)
  have hp10 := Nat.mul_le_mul_right n[0].toNat (Nat.le_sub_one_of_lt hx1)
  rw [fd_bn254_glv_mul2x1.spec]
  have e0 := (toNat_u128_mul a[0] n[0])
  obtain ⟨a0, ha0⟩ : ∃ x, u128 a[0] * u128 n[0] = x := ⟨_, rfl⟩
  simp only [ha0] at e0 ⊢
  have e1 :=
    (col (a := a0) (toNat_u128_mul a[1] n[0])
      (by
        have := a0.isLt; clear * - this hp10 hy0; omega))
  obtain ⟨a1, ha1⟩ : ∃ x, u128 a[1] * u128 n[0] + hi a0 = x := ⟨_, rfl⟩
  simp only [ha1] at e1 ⊢
  have e2 := (toNat_hi a1)
  obtain ⟨a2, ha2⟩ : ∃ x, hi a1 = x := ⟨_, rfl⟩
  simp only [ha2] at e2 ⊢
  rw [hm]
  simp only [limbsEval_three, toNat_lo, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ]
  exact mul2x1_tele e0 e1 e2 a1.isLt

/-! ## `add4`, `sub4`, `negate4` -/

theorem add_limb (a b c : BitVec 64) :
    ((u128 a + u128 b + u128 c).setWidth 64).toNat +
        (((u128 a + u128 b + u128 c) >>> 64).setWidth 64).toNat * 2 ^ 64 =
      a.toNat + b.toNat + c.toNat := by
  have ha := a.isLt; have hb := b.isLt; have hc := c.isLt
  rw [toNat_lo, toNat_shr,
    psum (psum (toNat_u128 a) (toNat_u128 b) (by omega)) (toNat_u128 c) (by omega)]
  omega

/-- `glv_add4( a, b )`: the sum with its carry. -/
public theorem fd_bn254_glv_add4.val (a b : Vector (BitVec 64) 4) :
    limbsEval (fd_bn254_glv_add4.spec a b).1 + (fd_bn254_glv_add4.spec a b).2.toNat * 2 ^ 256 =
      limbsEval a + limbsEval b := by
  rw [limbsEval_four a, limbsEval_four b, fd_bn254_glv_add4.spec]
  have e0 := add_limb a[0] b[0] 0
  obtain ⟨s0, h0⟩ : ∃ x, u128 a[0] + u128 b[0] + u128 0 = x := ⟨_, rfl⟩
  simp only [h0] at e0 ⊢
  have e1 := add_limb a[1] b[1] ((s0 >>> 64).setWidth 64)
  obtain ⟨s1, h1⟩ : ∃ x, u128 a[1] + u128 b[1] + u128 ((s0 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h1] at e1 ⊢
  have e2 := add_limb a[2] b[2] ((s1 >>> 64).setWidth 64)
  obtain ⟨s2, h2⟩ : ∃ x, u128 a[2] + u128 b[2] + u128 ((s1 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h2] at e2 ⊢
  have e3 := add_limb a[3] b[3] ((s2 >>> 64).setWidth 64)
  obtain ⟨s3, h3⟩ : ∃ x, u128 a[3] + u128 b[3] + u128 ((s2 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h3] at e3 ⊢
  simp only [limbsEval_four, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  simp only [bv_toNat_zero, add_zero] at e0
  omega

theorem sub_limb (av bv borrow : BitVec 64) (hb : borrow = 0 ∨ borrow = 1) :
    (fd_bn254_glv_sub4.limb av bv borrow).1.toNat + bv.toNat + borrow.toNat =
        av.toNat + (fd_bn254_glv_sub4.limb av bv borrow).2.toNat * 2 ^ 64 ∧
      ((fd_bn254_glv_sub4.limb av bv borrow).2 = 0 ∨
        (fd_bn254_glv_sub4.limb av bv borrow).2 = 1) := by
  have hbv :
    ((fd_bn254_glv_sub4.limb av bv borrow).1.setWidth 66 + bv.setWidth 66 + borrow.setWidth 66 =
        av.setWidth 66 + (fd_bn254_glv_sub4.limb av bv borrow).2.setWidth 66 <<< 64) ∧
      ((fd_bn254_glv_sub4.limb av bv borrow).2 = 0 ∨
        (fd_bn254_glv_sub4.limb av bv borrow).2 = 1) := by
    unfold fd_bn254_glv_sub4.limb; dsimp only; rcases hb with rfl | rfl <;> bv_decide
  refine ⟨?_, hbv.2⟩
  have h := congrArg BitVec.toNat hbv.1
  have := av.isLt; have := bv.isLt; have := (fd_bn254_glv_sub4.limb av bv borrow).1.isLt
  have hb2 : (fd_bn254_glv_sub4.limb av bv borrow).2.toNat ≤ 1 := by
    rcases hbv.2 with h | h <;> rw [h] <;> decide
  have hbi : borrow.toNat ≤ 1 := by rcases hb with rfl | rfl <;> decide
  simp only [BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_shiftLeft] at h
  rw [Nat.shiftLeft_eq] at h
  omega

/-- `glv_sub4( a, b )`: the difference modulo `2^256` with its borrow. -/
public theorem fd_bn254_glv_sub4.val (a b : Vector (BitVec 64) 4) :
    limbsEval (fd_bn254_glv_sub4.spec a b).1 + limbsEval b =
        limbsEval a + (fd_bn254_glv_sub4.spec a b).2.toNat * 2 ^ 256 ∧
      ((fd_bn254_glv_sub4.spec a b).2 = 0 ∨ (fd_bn254_glv_sub4.spec a b).2 = 1) := by
  rw [limbsEval_four a, limbsEval_four b, fd_bn254_glv_sub4.spec]
  obtain ⟨e0, b0⟩ := sub_limb a[0] b[0] 0 (.inl rfl)
  obtain ⟨d0, h0⟩ : ∃ x, fd_bn254_glv_sub4.limb a[0] b[0] 0 = x := ⟨_, rfl⟩
  simp only [h0] at e0 b0 ⊢
  obtain ⟨e1, b1⟩ := sub_limb a[1] b[1] d0.2 b0
  obtain ⟨d1, h1⟩ : ∃ x, fd_bn254_glv_sub4.limb a[1] b[1] d0.2 = x := ⟨_, rfl⟩
  simp only [h1] at e1 b1 ⊢
  obtain ⟨e2, b2⟩ := sub_limb a[2] b[2] d1.2 b1
  obtain ⟨d2, h2⟩ : ∃ x, fd_bn254_glv_sub4.limb a[2] b[2] d1.2 = x := ⟨_, rfl⟩
  simp only [h2] at e2 b2 ⊢
  obtain ⟨e3, b3⟩ := sub_limb a[3] b[3] d2.2 b2
  obtain ⟨d3, h3⟩ : ∃ x, fd_bn254_glv_sub4.limb a[3] b[3] d2.2 = x := ⟨_, rfl⟩
  simp only [h3] at e3 b3 ⊢
  simp only [limbsEval_four, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  simp only [bv_toNat_zero, add_zero] at e0
  have := d0.1.isLt; have := d1.1.isLt; have := d2.1.isLt; have := d3.1.isLt
  have t0 : d0.2.toNat ≤ 1 := by rcases b0 with h | h <;> rw [h] <;> decide
  have t1 : d1.2.toNat ≤ 1 := by rcases b1 with h | h <;> rw [h] <;> decide
  have t2 : d2.2.toNat ≤ 1 := by rcases b2 with h | h <;> rw [h] <;> decide
  exact ⟨by omega, b3⟩

theorem neg_limb (v c : BitVec 64) (hc : c.toNat ≤ 1) :
    ((u128 (~~~v) + u128 c).setWidth 64).toNat +
        (((u128 (~~~v) + u128 c) >>> 64).setWidth 64).toNat * 2 ^ 64 =
      2 ^ 64 - 1 - v.toNat + c.toNat := by
  have := v.isLt
  rw [toNat_lo, toNat_shr,
    psum (toNat_u128 _) (toNat_u128 c)
      (by
        have := (~~~v).isLt; omega),
    BitVec.toNat_not]
  omega

theorem negate4_eq (v0 v1 v2 v3 : BitVec 64) :
    fd_bn254_glv_negate4.spec #v[v0, v1, v2, v3] =
      let s0 := u128 (~~~v0) + u128 1
      let s1 := u128 (~~~v1) + u128 ((s0 >>> 64).setWidth 64)
      let s2 := u128 (~~~v2) + u128 ((s1 >>> 64).setWidth 64)
      let s3 := u128 (~~~v3) + u128 ((s2 >>> 64).setWidth 64)
      #v[s0.setWidth 64, s1.setWidth 64, s2.setWidth 64, s3.setWidth 64] :=
  rfl

/-- `glv_negate4( v )` is `2^256 - v` modulo `2^256`. -/
public theorem fd_bn254_glv_negate4.val (v : Vector (BitVec 64) 4) :
    limbsEval (fd_bn254_glv_negate4.spec v) = (2 ^ 256 - limbsEval v) % 2 ^ 256 := by
  rw [vec4_eta v, negate4_eq]
  dsimp only
  have one : (1 : BitVec 64).toNat = 1 := rfl
  have e0 := neg_limb v[0] 1 (by decide)
  rw [one] at e0
  obtain ⟨s0, h0⟩ : ∃ x, u128 (~~~v[0]) + u128 1 = x := ⟨_, rfl⟩
  simp only [h0] at e0 ⊢
  have e1 := neg_limb v[1] ((s0 >>> 64).setWidth 64) (by omega)
  obtain ⟨s1, h1⟩ : ∃ x, u128 (~~~v[1]) + u128 ((s0 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h1] at e1 ⊢
  have e2 := neg_limb v[2] ((s1 >>> 64).setWidth 64) (by omega)
  obtain ⟨s2, h2⟩ : ∃ x, u128 (~~~v[2]) + u128 ((s1 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h2] at e2 ⊢
  have e3 := neg_limb v[3] ((s2 >>> 64).setWidth 64) (by omega)
  obtain ⟨s3, h3⟩ : ∃ x, u128 (~~~v[3]) + u128 ((s2 >>> 64).setWidth 64) = x := ⟨_, rfl⟩
  simp only [h3] at e3 ⊢
  simp only [limbsEval_four, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  have := v[0].isLt; have := v[1].isLt; have := v[2].isLt; have := v[3].isLt
  have := (s0.setWidth 64).isLt; have := (s1.setWidth 64).isLt
  have := (s2.setWidth 64).isLt; have := (s3.setWidth 64).isLt
  omega

/-! ## The decomposition -/

/-- The lattice bounds: `b₁ N_A + b₂ N_B ≤ s` with slack below `2^128`, and
`|b₁ N_B - b₂ N_C| < 2^128`. -/
theorem glv_bounds {S B1 B2 : ℕ} (hS : S < 2 ^ 256)
    (hB1 : B1 = S * 782660544089080853131326142527431468389 / 2 ^ 256)
    (hB2 : B2 = S * 52538187511802934231 / 2 ^ 256) :
    B1 * 147946756881789319000765030803803410728 + B2 * 9931322734385697763 ≤ S ∧
      S < B1 * 147946756881789319000765030803803410728 + B2 * 9931322734385697763 + 2 ^ 128 ∧
      B1 * 9931322734385697763 < B2 * 147946756881789319010696353538189108491 + 2 ^ 128 ∧
      B2 * 147946756881789319010696353538189108491 < B1 * 9931322734385697763 + 2 ^ 128 := by
  have h1 := Nat.div_add_mod (S * 782660544089080853131326142527431468389) (2 ^ 256)
  have h2 := Nat.div_add_mod (S * 52538187511802934231) (2 ^ 256)
  have h1' := Nat.mod_lt (S * 782660544089080853131326142527431468389) (by norm_num : 0 < 2 ^ 256)
  have h2' := Nat.mod_lt (S * 52538187511802934231) (by norm_num : 0 < 2 ^ 256)
  rw [← hB1] at h1
  rw [← hB2] at h2
  refine ⟨?_, ?_, ?_, ?_⟩ <;> omega

@[expose] public section

/-- `b1 * N_A` (`p11`). -/
def glvP11 (s : fd_bn254_scalar_t) : Vector (BitVec 64) 4 :=
  fd_bn254_glv_mul3x2.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) na

set_option linter.auxLemma false in
/-- `b2 * N_B` padded to 4 limbs (`p21`), as the spec writes it. -/
def glvP21 (s : fd_bn254_scalar_t) : Vector (BitVec 64) 4 :=
  Vector.mk
    (List.toArray
      (List.cons
        (getElem (fd_bn254_glv_mul2x1.spec (fd_bn254_glv_sxg2.spec s g2_const) nb) 0
          fd_bn254_g1_scalar_mul.spec._proof_8)
        (List.cons
          (getElem (fd_bn254_glv_mul2x1.spec (fd_bn254_glv_sxg2.spec s g2_const) nb) 1
            fd_bn254_g1_scalar_mul.spec._proof_10)
          (List.cons
            (getElem (fd_bn254_glv_mul2x1.spec (fd_bn254_glv_sxg2.spec s g2_const) nb) 2
              fd_bn254_g1_scalar_mul.spec._proof_12)
            (List.cons
              (getElem
                (Vector.mk
                  (List.toArray (List.cons 0 (List.cons 0 (List.cons 0 (List.cons 0 List.nil)))))
                  fd_bn254_g1_scalar_mul.spec._proof_1)
                3 fd_bn254_g1_scalar_mul.spec._proof_14)
              List.nil)))))
    (fd_bn254_g1_scalar_mul.spec._proof_2 s)

/-- `b1 * N_B - b2 * N_C` with its borrow. -/
def glvD (s : fd_bn254_scalar_t) : Vector (BitVec 64) 4 × BitVec 64 :=
  fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
    (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)

/-- `k1` of `fd_bn254_g1_scalar_mul.spec`. -/
def glvK1 (s : fd_bn254_scalar_t) : fd_uint256_t :=
  (fd_bn254_glv_sub4.spec s
      (fd_bn254_glv_add4.spec (fd_bn254_glv_mul3x2.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) na)
          (glvP21 s)).1).1

/-- `(k2 < 0, |k2|)` of `fd_bn254_g1_scalar_mul.spec`. -/
def glvK2 (s : fd_bn254_scalar_t) : BitVec 32 × fd_uint256_t :=
  if
      (fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
            (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)).2 ≠
        0 then
    (1,
      fd_bn254_glv_negate4.spec
        (fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
            (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)).1)
  else
    (0,
      (fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
          (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)).1)

/-- The eigenvalue `λ` of `φ(x, y) = (βx, y)` on `E(F_p)` (the cube root of unity mod `r` that
`fd_bn254_glv.h:31`'s comment does not name). -/
def lam : ℕ :=
  21888242871839275217838484774961031246154997185409878258781734729429964517155

end

theorem limbsEval_p21 (o : Vector (BitVec 64) 3) :
    limbsEval
        (#v[o[0], o[1], o[2], (#v[0, 0, 0, 0] : Vector (BitVec 64) 4)[3]] : Vector (BitVec 64) 4) =
      limbsEval o := by
  simp [limbsEval_four, limbsEval_three]

/-- The GLV decomposition of every 256-bit `s`: `s = k1 + b₁ N_A + b₂ N_B` exactly (`k1 ≥ 0`, no
wrap), `±|k2| = b₁ N_B - b₂ N_C`, and `k1, |k2| < 2^128`. -/
public theorem glv_spec (s : fd_bn254_scalar_t) :
    limbsEval (glvK1 s) < 2 ^ 128 ∧
      limbsEval (glvK2 s).2 < 2 ^ 128 ∧
      ((glvK2 s).1 = 0 ∨ (glvK2 s).1 = 1) ∧
      ∃ b₁ b₂ : ℕ,
        limbsEval s =
            limbsEval (glvK1 s) + b₁ * 147946756881789319000765030803803410728 +
              b₂ * 9931322734385697763 ∧
          ((glvK2 s).1 = 0 →
            limbsEval (glvK2 s).2 + b₂ * 147946756881789319010696353538189108491 =
              b₁ * 9931322734385697763) ∧
          ((glvK2 s).1 = 1 →
            limbsEval (glvK2 s).2 + b₁ * 9931322734385697763 =
              b₂ * 147946756881789319010696353538189108491) := by
  have hS := limbsEval_lt s
  have hB1 := fd_bn254_glv_sxg3.val s g1_const_g1 (by decide)
  have hB2 := fd_bn254_glv_sxg2.val s g2_const (by decide)
  have eG1 : limbsEval g1_const_g1 = 782660544089080853131326142527431468389 := by
    simp [limbsEval_three, g1_const_g1]
  have eG2 : limbsEval g2_const = 52538187511802934231 := by simp [limbsEval_two, g2_const]
  have eNA : limbsEval na = 147946756881789319000765030803803410728 := by simp [limbsEval_two, na]
  have eNB : limbsEval nb = 9931322734385697763 := by simp [limbsEval_one, nb]
  have eNC : limbsEval nc = 147946756881789319010696353538189108491 := by simp [limbsEval_two, nc]
  rw [eG1] at hB1
  rw [eG2] at hB2
  obtain ⟨g1, g2, g3, g4⟩ := glv_bounds hS hB1 hB2
  have hP11 := fd_bn254_glv_mul3x2.val (fd_bn254_glv_sxg3.spec s g1_const_g1) na (by decide)
  have hO := fd_bn254_glv_mul2x1.val (fd_bn254_glv_sxg2.spec s g2_const) nb
  have hPos := fd_bn254_glv_mul3x1.val (fd_bn254_glv_sxg3.spec s g1_const_g1) nb
  have hNeg := fd_bn254_glv_mul2x2.val (fd_bn254_glv_sxg2.spec s g2_const) nc (by decide)
  rw [eNA] at hP11
  rw [eNB] at hO
  rw [eNB] at hPos
  rw [eNC] at hNeg
  generalize limbsEval (fd_bn254_glv_sxg3.spec s g1_const_g1) = B1 at hP11 hPos g1 g2 g3 g4
  generalize limbsEval (fd_bn254_glv_sxg2.spec s g2_const) = B2 at hO hNeg g1 g2 g3 g4
  have hp21 : limbsEval (glvP21 s) = B2 * 9931322734385697763 := by rw [glvP21, limbsEval_p21, hO]
  have hp11 : limbsEval (glvP11 s) = B1 * 147946756881789319000765030803803410728 % 2 ^ 256 := by
    rw [glvP11, hP11]
  have hadd := fd_bn254_glv_add4.val (glvP11 s) (glvP21 s)
  rw [hp21, hp11] at hadd
  have hsub := fd_bn254_glv_sub4.val s (fd_bn254_glv_add4.spec (glvP11 s) (glvP21 s)).1
  have hsub2 :=
    fd_bn254_glv_sub4.val (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
      (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)
  rw [hPos, hNeg] at hsub2
  have e1 :
    glvK1 s = (fd_bn254_glv_sub4.spec s (fd_bn254_glv_add4.spec (glvP11 s) (glvP21 s)).1).1 := by
    simp only [glvK1, glvP11]
  have e2 :
    glvK2 s =
      if (glvD s).2 ≠ 0 then ((1 : BitVec 32), fd_bn254_glv_negate4.spec (glvD s).1)
      else (0, (glvD s).1) := by
    unfold glvK2 glvD
    by_cases hc :
      (fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
            (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)).2 ≠
        0
    · simp only [ne_eq, hc, not_false_eq_true, ↓reduceIte]
    · simp only [ne_eq, not_not] at hc
      simp only [hc, ne_eq, not_true_eq_false, ↓reduceIte]
  rw [e1, e2]
  generalize fd_bn254_glv_add4.spec (glvP11 s) (glvP21 s) = A at hadd hsub ⊢
  obtain ⟨t, c⟩ := A
  generalize fd_bn254_glv_sub4.spec s t = K at hsub ⊢
  obtain ⟨k1, bo⟩ := K
  rw [show
      glvD s =
        fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
          (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc)
      from rfl]
  generalize
    fd_bn254_glv_sub4.spec (fd_bn254_glv_mul3x1.spec (fd_bn254_glv_sxg3.spec s g1_const_g1) nb)
      (fd_bn254_glv_mul2x2.spec (fd_bn254_glv_sxg2.spec s g2_const) nc) =
    D at hsub2 ⊢
  obtain ⟨k2, bo2⟩ := D
  dsimp only at hadd hsub hsub2 ⊢
  have ht := limbsEval_lt t; have hk1 := limbsEval_lt k1; have hk2' := limbsEval_lt k2
  have hc := c.isLt
  obtain ⟨hs1, hs1b⟩ := hsub
  obtain ⟨hs2, hs2b⟩ := hsub2
  have hbo : bo.toNat ≤ 1 := by rcases hs1b with h | h <;> rw [h] <;> decide
  have hbo2 : bo2.toNat ≤ 1 := by rcases hs2b with h | h <;> rw [h] <;> decide
  by_cases hb : bo2 ≠ 0
  · rw [ite_eq_left hb]
    dsimp only
    have hb1 : bo2.toNat = 1 := by
      rcases hs2b with h | h
      · exact absurd h hb
      · rw [h]; rfl
    have hn := fd_bn254_glv_negate4.val k2
    rw [hb1] at hs2
    have hlt : B1 * 9931322734385697763 < B2 * 147946756881789319010696353538189108491 := by
      clear * - hs2 hk2'; omega
    have hk :
      2 ^ 256 - limbsEval k2 =
        B2 * 147946756881789319010696353538189108491 - B1 * 9931322734385697763 := by
      clear * - hs2 hk2'; omega
    have hk' :
      (2 ^ 256 - limbsEval k2) % 2 ^ 256 =
        B2 * 147946756881789319010696353538189108491 - B1 * 9931322734385697763 := by
      rw [hk];
      exact
        Nat.mod_eq_of_lt
          (by
            clear * - g4; omega)
    rw [hn, hk']
    refine
      ⟨by omega, by omega, .inr rfl, B1, B2, by omega, fun h => absurd h (by decide), fun _ => by
        omega⟩
  · rw [ite_eq_right hb]
    dsimp only
    have hb0 : bo2 = 0 := by simpa using hb
    rw [hb0] at hs2
    simp only [bv_toNat_zero, zero_mul, add_zero] at hs2
    refine
      ⟨by omega, by omega, .inl rfl, B1, B2, by omega, fun _ => by omega, fun h =>
        absurd h (by decide)⟩

end Firedancer.Bn254

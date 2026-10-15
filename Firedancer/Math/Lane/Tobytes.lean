module

public import Firedancer.Math.Avx512.Reduce
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! `fd_f25519_tobytes` in `ZMod p`: `tobytes a` is the canonical little-endian encoding of `a`'s
value, for any limbs. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 Firedancer.Avx512.R43x6
open _root_.Ed25519 (p)

/-- Six limbs' integer, read as longs. -/
def limbsInt (l : Limbs) : ℤ :=
  l.y0.toInt + l.y1.toInt * 2 ^ 43 + l.y2.toInt * 2 ^ 86 + l.y3.toInt * 2 ^ 129 +
    l.y4.toInt * 2 ^ 172 + l.y5.toInt * 2 ^ 215

/-- A long's low 43 bits, as a long. -/
theorem toInt_and43 (a : BitVec 64) : (a &&& m43).toInt = a.toInt % 2 ^ 43 := by
  rw [toInt_of_lt (by have := and_m43_lt a; omega), toInt_and_m43]

/-- A long's low 40 bits, as a long. -/
theorem toInt_and40 (a : BitVec 64) : (a &&& m40).toInt = a.toInt % 2 ^ 40 := by
  rw [toInt_of_lt (by have := and_m40_lt a; omega), toInt_and_m40]

/-- `m + b >>ₛ 43` for `m` in `[0, 2^43)`: no overflow. -/
theorem add_sshr43 {m : BitVec 64} (hm : 0 ≤ m.toInt ∧ m.toInt < 2 ^ 43) (b : BitVec 64) :
    (m + b.sshiftRight 43).toInt = m.toInt + b.toInt / 2 ^ 43 := by
  have := toInt_bounds b
  rw [toInt_add' (by rw [toInt_sshiftRight']; omega) (by rw [toInt_sshiftRight']; omega),
    toInt_sshiftRight']

/-- `m + 19 (b >>ₛ 40)` for `m` in `[0, 2^43)`: no overflow. -/
theorem add_mul19_sshr40 {m : BitVec 64} (hm : 0 ≤ m.toInt ∧ m.toInt < 2 ^ 43) (b : BitVec 64) :
    (m + 19 * b.sshiftRight 40).toInt = m.toInt + 19 * (b.toInt / 2 ^ 40) := by
  have := toInt_bounds b
  have hc := toInt_sshiftRight' b 40
  have h19 : (19 * b.sshiftRight 40).toInt = 19 * (b.toInt / 2 ^ 40) := by
    rw [toInt_mul19 (by rw [hc]; omega) (by rw [hc]; omega), hc]
  rw [toInt_add' (by rw [h19]; omega) (by rw [h19]; omega), h19]

/-- `fd_r43x6_approx_carry_propagate_limbs` of any limbs: signed limbs, the integer less `p` times
limb 5's carry. -/
theorem approx_spec (x : Limbs) :
    let l := approxCarryPropagateLimbs x
    0 ≤ l.y0.toInt + 19 * 2 ^ 23 ∧ l.y0.toInt < 2 ^ 43 + 19 * 2 ^ 23 ∧
      -2 ^ 20 ≤ l.y1.toInt ∧ l.y1.toInt < 2 ^ 43 + 2 ^ 20 ∧
      -2 ^ 20 ≤ l.y2.toInt ∧ l.y2.toInt < 2 ^ 43 + 2 ^ 20 ∧
      -2 ^ 20 ≤ l.y3.toInt ∧ l.y3.toInt < 2 ^ 43 + 2 ^ 20 ∧
      -2 ^ 20 ≤ l.y4.toInt ∧ l.y4.toInt < 2 ^ 43 + 2 ^ 20 ∧
      -2 ^ 20 ≤ l.y5.toInt ∧ l.y5.toInt < 2 ^ 40 + 2 ^ 20 ∧
      limbsInt l = limbsInt x - (p : ℤ) * (x.y5.toInt / 2 ^ 40) := by
  intro l
  have b0 := toInt_bounds x.y0
  have b1 := toInt_bounds x.y1
  have b2 := toInt_bounds x.y2
  have b3 := toInt_bounds x.y3
  have b4 := toInt_bounds x.y4
  have b5 := toInt_bounds x.y5
  have a0 := toInt_and43 x.y0
  have a1 := toInt_and43 x.y1
  have a2 := toInt_and43 x.y2
  have a3 := toInt_and43 x.y3
  have a4 := toInt_and43 x.y4
  have a5 := toInt_and40 x.y5
  have e0 : l.y0.toInt = x.y0.toInt % 2 ^ 43 + 19 * (x.y5.toInt / 2 ^ 40) := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_mul19_sshr40 (by rw [a0]; omega), a0]
  have e1 : l.y1.toInt = x.y1.toInt % 2 ^ 43 + x.y0.toInt / 2 ^ 43 := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_sshr43 (by rw [a1]; omega), a1]
  have e2 : l.y2.toInt = x.y2.toInt % 2 ^ 43 + x.y1.toInt / 2 ^ 43 := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_sshr43 (by rw [a2]; omega), a2]
  have e3 : l.y3.toInt = x.y3.toInt % 2 ^ 43 + x.y2.toInt / 2 ^ 43 := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_sshr43 (by rw [a3]; omega), a3]
  have e4 : l.y4.toInt = x.y4.toInt % 2 ^ 43 + x.y3.toInt / 2 ^ 43 := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_sshr43 (by rw [a4]; omega), a4]
  have e5 : l.y5.toInt = x.y5.toInt % 2 ^ 40 + x.y4.toInt / 2 ^ 43 := by
    simp only [l, approxCarryPropagateLimbs]
    rw [add_sshr43 (by rw [a5]; omega), a5]
  refine ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega,
    by omega, by omega, by omega, ?_⟩
  have m0 := Int.emod_def x.y0.toInt (2 ^ 43)
  have m1 := Int.emod_def x.y1.toInt (2 ^ 43)
  have m2 := Int.emod_def x.y2.toInt (2 ^ 43)
  have m3 := Int.emod_def x.y3.toInt (2 ^ 43)
  have m4 := Int.emod_def x.y4.toInt (2 ^ 43)
  have m5 := Int.emod_def x.y5.toInt (2 ^ 40)
  simp only [limbsInt]
  rw [e0, e1, e2, e3, e4, e5, p_int]
  linear_combination m0 + 2 ^ 43 * m1 + 2 ^ 86 * m2 + 2 ^ 129 * m3 + 2 ^ 172 * m4 + 2 ^ 215 * m5

/-- A signed limb plus any long's carry: no overflow. -/
theorem add_sshr43' {a : BitVec 64} (ha : -2 ^ 62 ≤ a.toInt ∧ a.toInt < 2 ^ 62) (b : BitVec 64) :
    (a + b.sshiftRight 43).toInt = a.toInt + b.toInt / 2 ^ 43 := by
  have := toInt_bounds b
  rw [toInt_add' (by rw [toInt_sshiftRight']; omega) (by rw [toInt_sshiftRight']; omega),
    toInt_sshiftRight']

/-- `fd_r43x6_biased_carry_propagate_limbs(x, y, 1)` of `approx_spec`'s limbs: nearly reduced
limbs whose integer is `x`'s less a multiple of `p`. -/
theorem biased1_spec {l : Limbs}
    (h0 : 0 ≤ l.y0.toInt + 19 * 2 ^ 23 ∧ l.y0.toInt < 2 ^ 43 + 19 * 2 ^ 23)
    (h1 : -2 ^ 20 ≤ l.y1.toInt ∧ l.y1.toInt < 2 ^ 43 + 2 ^ 20)
    (h2 : -2 ^ 20 ≤ l.y2.toInt ∧ l.y2.toInt < 2 ^ 43 + 2 ^ 20)
    (h3 : -2 ^ 20 ≤ l.y3.toInt ∧ l.y3.toInt < 2 ^ 43 + 2 ^ 20)
    (h4 : -2 ^ 20 ≤ l.y4.toInt ∧ l.y4.toInt < 2 ^ 43 + 2 ^ 20)
    (h5 : -2 ^ 20 ≤ l.y5.toInt ∧ l.y5.toInt < 2 ^ 40 + 2 ^ 20) :
    LimbsBounded 41 (biasedCarryPropagateLimbs l 1) ∧
      limbsNat (biasedCarryPropagateLimbs l 1) < 2 * p ∧
      ∃ c : ℤ, (limbsNat (biasedCarryPropagateLimbs l 1) : ℤ) = limbsInt l - p * c := by
  simp only [biasedCarryPropagateLimbs, carryLimbs, carrySums, limbsNat]
  have h1' : (1 : BitVec 64).toInt = 1 := by decide
  have Ht : (l.y5 - 1).toInt = l.y5.toInt - 1 := by
    rw [toInt_sub' (by rw [h1']; omega) (by rw [h1']; omega), h1']
  generalize l.y5 - 1 = t at Ht ⊢
  have Hc := toInt_sshiftRight' t 40
  generalize t.sshiftRight 40 = c at Hc ⊢
  have Hz : (l.y0 + 19 * c).toInt = l.y0.toInt + 19 * c.toInt := by
    have h19 : (19 * c).toInt = 19 * c.toInt := toInt_mul19 (by omega) (by omega)
    rw [toInt_add' (by rw [h19]; omega) (by rw [h19]; omega), h19]
  generalize l.y0 + 19 * c = z0 at Hz ⊢
  have Hs1 := add_sshr43' (a := l.y1) (by omega) z0
  generalize l.y1 + z0.sshiftRight 43 = s1 at Hs1 ⊢
  have Hs2 := add_sshr43' (a := l.y2) (by omega) s1
  generalize l.y2 + s1.sshiftRight 43 = s2 at Hs2 ⊢
  have Hs3 := add_sshr43' (a := l.y3) (by omega) s2
  generalize l.y3 + s2.sshiftRight 43 = s3 at Hs3 ⊢
  have Hs4 := add_sshr43' (a := l.y4) (by omega) s3
  generalize l.y4 + s3.sshiftRight 43 = s4 at Hs4 ⊢
  have Hc4 := toInt_sshiftRight' s4 43
  generalize s4.sshiftRight 43 = c4 at Hc4 ⊢
  have Hm := toInt_and40 t
  have Hy5i : ((t &&& m40) + c4 + 1#64).toInt = t.toInt % 2 ^ 40 + c4.toInt + 1 := by
    have e : ((t &&& m40) + c4).toInt = t.toInt % 2 ^ 40 + c4.toInt := by
      rw [toInt_add' (by rw [Hm]; omega) (by rw [Hm]; omega), Hm]
    have h1'' : (1#64).toInt = 1 := by decide
    rw [toInt_add' (by rw [e, h1'']; omega) (by rw [e, h1'']; omega), e, h1'']
  have Hy5n : (((t &&& m40) + c4 + 1#64).toNat : ℤ) = t.toInt % 2 ^ 40 + c4.toInt + 1 := by
    rw [toNat_of_toInt_nonneg (by rw [Hy5i]; omega), Hy5i]
  have Hy5n1 : (((t &&& m40) + c4 + 1).toNat : ℤ) = t.toInt % 2 ^ 40 + c4.toInt + 1 := Hy5n
  have q0 := and_m43_lt z0
  have q1 := and_m43_lt s1
  have q2 := and_m43_lt s2
  have q3 := and_m43_lt s3
  have q4 := and_m43_lt s4
  have n0 := toInt_and_m43 z0
  have n1 := toInt_and_m43 s1
  have n2 := toInt_and_m43 s2
  have n3 := toInt_and_m43 s3
  have n4 := toInt_and_m43 s4
  have pa := p_add
  refine ⟨⟨q0, q1, q2, q3, q4, by dsimp only; omega⟩, by omega, c.toInt, ?_⟩
  push_cast
  simp only [n0, n1, n2, n3, n4, Hy5n, limbsInt]
  have m0 := Int.emod_def z0.toInt (2 ^ 43)
  have m1 := Int.emod_def s1.toInt (2 ^ 43)
  have m2 := Int.emod_def s2.toInt (2 ^ 43)
  have m3 := Int.emod_def s3.toInt (2 ^ 43)
  have m4 := Int.emod_def s4.toInt (2 ^ 43)
  have mt := Int.emod_def t.toInt (2 ^ 40)
  linear_combination m0 + 2 ^ 43 * m1 + 2 ^ 86 * m2 + 2 ^ 129 * m3 + 2 ^ 172 * m4 +
    2 ^ 215 * mt + Hz + 2 ^ 43 * Hs1 + 2 ^ 86 * Hs2 + 2 ^ 129 * Hs3 + 2 ^ 172 * Hs4 +
    2 ^ 215 * Ht + 2 ^ 255 * Hc + 2 ^ 215 * Hc4

/-- Six limbs packed into 320 bits, limb `i` at bit `43 i`. -/
def pack320 (l : Limbs) : BitVec 320 :=
  l.y0.zeroExtend 320 + (l.y1.zeroExtend 320 <<< 43) + (l.y2.zeroExtend 320 <<< 86) +
    (l.y3.zeroExtend 320 <<< 129) + (l.y4.zeroExtend 320 <<< 172) + (l.y5.zeroExtend 320 <<< 215)

theorem pack320_toNat (l : Limbs) : (pack320 l).toNat = limbsNat l := by
  have := l.y0.isLt
  have := l.y1.isLt
  have := l.y2.isLt
  have := l.y3.isLt
  have := l.y4.isLt
  have := l.y5.isLt
  simp only [pack320, limbsNat, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  simp (disch := omega) only [Nat.mod_eq_of_lt]

/-- `fd_r43x6_pack` of reduced limbs, bit by bit: their packed 320 bits' low 256. -/
theorem r43x6Pack_bv {y0 y1 y2 y3 y4 y5 : BitVec 64} (h0 : y0 < 0x80000000000#64)
    (h1 : y1 < 0x80000000000#64) (h2 : y2 < 0x80000000000#64) (h3 : y3 < 0x80000000000#64)
    (h4 : y4 < 0x80000000000#64) (h5 : y5 < 0x10000000000#64) :
    r43x6Pack ⟨y0, y1, y2, y3, y4, y5⟩ = (pack320 ⟨y0, y1, y2, y3, y4, y5⟩).setWidth 256 := by
  simp only [r43x6Pack, pack320]
  bv_decide

/-- `fd_r43x6_pack` of reduced limbs: their integer's 256 bits. -/
theorem r43x6Pack_eq {r : Limbs} (hr : LimbsBounded 40 r) :
    r43x6Pack r = BitVec.ofNat 256 (limbsNat r) := by
  obtain ⟨b0, b1, b2, b3, b4, b5⟩ := hr
  obtain ⟨y0, y1, y2, y3, y4, y5⟩ := r
  rw [r43x6Pack_bv (by rw [BitVec.lt_def]; simpa using b0) (by rw [BitVec.lt_def]; simpa using b1)
    (by rw [BitVec.lt_def]; simpa using b2) (by rw [BitVec.lt_def]; simpa using b3)
    (by rw [BitVec.lt_def]; simpa using b4) (by rw [BitVec.lt_def]; simpa using b5)]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_setWidth, pack320_toNat, BitVec.toNat_ofNat]

/-- `fd_f25519_tobytes`' bytes `tobytes a` are the canonical little-endian encoding of `a`'s value,
for any limbs `a`. -/
public theorem tobytes_eq_ofNat_val (a : Wwl) : tobytes a = BitVec.ofNat 256 (val a).val := by
  obtain ⟨a0, a0', a1, a1', a2, a2', a3, a3', a4, a4', a5, a5', ha⟩ :=
    approx_spec (extractLimbs a)
  obtain ⟨hb, hlt, c, hc⟩ :=
    biased1_spec ⟨a0, a0'⟩ ⟨a1, a1'⟩ ⟨a2, a2'⟩ ⟨a3, a3'⟩ ⟨a4, a4'⟩ ⟨a5, a5'⟩
  obtain ⟨rb, rv⟩ := modNearly_spec hb hlt
  rw [tobytes, r43x6Mod, r43x6Pack_eq rb, rv]
  refine congrArg (BitVec.ofNat 256) ?_
  have e : ((val a).val : ℤ) = int a % p := by rw [val, ZMod.val_intCast]
  have e' : limbsInt (extractLimbs a) = int a := rfl
  apply Nat.cast_injective (R := ℤ)
  rw [e, Int.natCast_mod, hc, ha, e',
    show int a - (p : ℤ) * ((extractLimbs a).y5.toInt / 2 ^ 40) - p * c =
      int a + (-((extractLimbs a).y5.toInt / 2 ^ 40) - c) * p by ring,
    Int.add_mul_emod_self_right]

end MLIR.Firedancer.Lane

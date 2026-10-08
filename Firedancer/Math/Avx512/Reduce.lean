module

public import Firedancer.Math.Avx512.R43x6
public import Firedancer.Avx512.fd_r43x6_is_nonzero
public import Firedancer.Avx512.fd_r43x6_diagnose
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring

/-! `fd_r43x6_is_nonzero` and `fd_r43x6_diagnose` in `ZMod p`: the scalar carries
`fd_r43x6_biased_carry_propagate_limbs` and `fd_r43x6_mod_nearly_reduced_limbs` take a signed
`fd_r43x6_t` to the reduced limbs of its value. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

open LeanMLIR.RIR.Firedancer.Ref (p)

namespace R43x6

@[expose] public section

/-- Six limbs' integer, read unsigned: limb `i` weighs `2^(43 i)`. -/
def limbsNat (l : Limbs) : ℕ :=
  l.y0.toNat + l.y1.toNat * 2 ^ 43 + l.y2.toNat * 2 ^ 86 + l.y3.toNat * 2 ^ 129 +
    l.y4.toNat * 2 ^ 172 + l.y5.toNat * 2 ^ 215

/-- Limbs 0-4 in `[0, 2^43)`, limb 5 in `[0, 2^b)`. -/
abbrev LimbsBounded (b : ℕ) (l : Limbs) : Prop :=
  l.y0.toNat < 2 ^ 43 ∧ l.y1.toNat < 2 ^ 43 ∧ l.y2.toNat < 2 ^ 43 ∧ l.y3.toNat < 2 ^ 43 ∧
    l.y4.toNat < 2 ^ 43 ∧ l.y5.toNat < 2 ^ b

/-- `fd_r43x6_reduce`'s limbs: extracted, biased carry propagated, reduced. -/
def reduceLimbs (x : Wwl) : Limbs :=
  modNearlyReducedLimbs (biasedCarryPropagateLimbs (extractLimbs x) (1 <<< 20))

end

/-! ## Signed carries -/

/-- The low 43 bits of a long: its value mod `2^43`. -/
public theorem toInt_and_m43 (a : BitVec 64) : ((a &&& m43).toNat : ℤ) = a.toInt % 2 ^ 43 := by
  rw [BitVec.toNat_and, show m43.toNat = 8796093022207 from rfl, and_m43,
    BitVec.toInt_eq_toNat_cond]
  have := a.isLt
  split <;> omega

/-- The low 40 bits of a long: its value mod `2^40`. -/
public theorem toInt_and_m40 (a : BitVec 64) : ((a &&& m40).toNat : ℤ) = a.toInt % 2 ^ 40 := by
  rw [BitVec.toNat_and, show m40.toNat = 1099511627775 from rfl, and_m40,
    BitVec.toInt_eq_toNat_cond]
  have := a.isLt
  split <;> omega

/-- An arithmetic shift right: floor division. -/
public theorem toInt_sshiftRight' (a : BitVec 64) (k : ℕ) :
    (a.sshiftRight k).toInt = a.toInt / 2 ^ k := by
  rw [BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  push_cast
  rfl

/-- A nonnegative long is its unsigned value. -/
public theorem toNat_of_toInt_nonneg {a : BitVec 64} (h : 0 ≤ a.toInt) :
    (a.toNat : ℤ) = a.toInt := by
  rw [BitVec.toInt_eq_toNat_cond] at h ⊢
  have := a.isLt
  split_ifs at h ⊢ <;> omega

public theorem and_m43_lt (a : BitVec 64) : (a &&& m43).toNat < 2 ^ 43 := by
  rw [BitVec.toNat_and, show m43.toNat = 8796093022207 from rfl, and_m43]
  exact Nat.mod_lt _ (by norm_num)

public theorem and_m40_lt (a : BitVec 64) : (a &&& m40).toNat < 2 ^ 40 := by
  rw [BitVec.toNat_and, show m40.toNat = 1099511627775 from rfl, and_m40]
  exact Nat.mod_lt _ (by norm_num)

/-- `19 c` of a small long. -/
public theorem toInt_mul19 {c : BitVec 64} (h1 : -2 ^ 58 ≤ c.toInt) (h2 : c.toInt < 2 ^ 58) :
    (19 * c).toInt = 19 * c.toInt := by
  rw [BitVec.toInt_mul_of_not_smulOverflow (by simp [BitVec.smulOverflow]; omega)]
  rfl

/-- `x5 - b`, `b = 2^20`, of a signed limb. -/
theorem sub_bias {a : BitVec 64} (h : -2 ^ 62 ≤ a.toInt) :
    (a - ↑(1 <<< 20 : ℕ)).toInt = a.toInt - 2 ^ 20 := by
  have hb : (↑(1 <<< 20 : ℕ) : BitVec 64).toInt = 2 ^ 20 := by decide
  have := toInt_bounds a
  rw [toInt_sub' (by omega) (by omega), hb]

/-- The carry out of limb 5. -/
theorem shr40_bounds (t : BitVec 64) :
    (t.sshiftRight 40).toInt = t.toInt / 2 ^ 40 ∧ -2 ^ 23 ≤ (t.sshiftRight 40).toInt ∧
      (t.sshiftRight 40).toInt < 2 ^ 23 := by
  have := toInt_bounds t
  rw [toInt_sshiftRight']
  omega

/-- Limb 0 plus `19` times limb 5's carry. -/
theorem add_mul19 {a c : BitVec 64} (ha : -2 ^ 62 ≤ a.toInt ∧ a.toInt < 2 ^ 62)
    (hc : -2 ^ 23 ≤ c.toInt ∧ c.toInt < 2 ^ 23) :
    (a + 19 * c).toInt = a.toInt + 19 * c.toInt ∧ -2 ^ 63 ≤ a.toInt + 19 * c.toInt ∧
      a.toInt + 19 * c.toInt < 2 ^ 63 := by
  rw [toInt_add' (by rw [toInt_mul19 (by omega) (by omega)]; omega)
    (by rw [toInt_mul19 (by omega) (by omega)]; omega), toInt_mul19 (by omega) (by omega)]
  omega

/-- A signed limb plus the carry of any long. -/
theorem add_shr43 {a s : BitVec 64} (ha : -2 ^ 62 ≤ a.toInt ∧ a.toInt < 2 ^ 62) :
    (a + s.sshiftRight 43).toInt = a.toInt + s.toInt / 2 ^ 43 ∧
      -2 ^ 63 ≤ a.toInt + s.toInt / 2 ^ 43 ∧ a.toInt + s.toInt / 2 ^ 43 < 2 ^ 63 := by
  have := toInt_bounds s
  rw [toInt_add' (by rw [toInt_sshiftRight']; omega) (by rw [toInt_sshiftRight']; omega),
    toInt_sshiftRight']
  omega

/-- Limb 5: its low 40 bits, the carry out of limb 4 and the bias `2^20`. -/
theorem limb5_bias (m s : BitVec 64) :
    ((m &&& m40) + s.sshiftRight 43 + ↑(1 <<< 20 : ℕ)).toNat =
        (m &&& m40).toNat + s.toInt / 2 ^ 43 + 2 ^ 20 ∧
      (m &&& m40).toNat + s.toInt / 2 ^ 43 + 2 ^ 20 < 2 ^ 40 + 2 ^ 21 := by
  have hb : (↑(1 <<< 20 : ℕ) : BitVec 64).toInt = 2 ^ 20 := by decide
  have hm := and_m40_lt m
  have hmi : (m &&& m40).toInt = (m &&& m40).toNat := toInt_of_lt (by omega)
  have := toInt_bounds s
  have e1 : ((m &&& m40) + s.sshiftRight 43).toInt = (m &&& m40).toNat + s.toInt / 2 ^ 43 := by
    rw [toInt_add' (by rw [hmi, toInt_sshiftRight']; omega)
      (by rw [hmi, toInt_sshiftRight']; omega), hmi, toInt_sshiftRight']
  have e2 : ((m &&& m40) + s.sshiftRight 43 + ↑(1 <<< 20 : ℕ)).toInt =
      (m &&& m40).toNat + s.toInt / 2 ^ 43 + 2 ^ 20 := by
    rw [toInt_add' (by rw [e1, hb]; omega) (by rw [e1, hb]; omega), e1, hb]
  rw [toNat_of_toInt_nonneg (by rw [e2]; omega), e2]
  omega

/-- `fd_r43x6_biased_carry_propagate_limbs(x, y, 1<<20)` of a signed `fd_r43x6_t`: nearly reduced
limbs (limb 5 below `2^40 + 2^21`) whose integer is `x`'s less a multiple of `p`. -/
public theorem biasedCarry_spec {x : Wwl} (hx : Signed 62 x) :
    LimbsBounded 41 (biasedCarryPropagateLimbs (extractLimbs x) (1 <<< 20)) ∧
      (biasedCarryPropagateLimbs (extractLimbs x) (1 <<< 20)).y5.toNat < 2 ^ 40 + 2 ^ 21 ∧
      ∃ c : ℤ, (limbsNat (biasedCarryPropagateLimbs (extractLimbs x) (1 <<< 20)) : ℤ) =
        int x - p * c := by
  have hx0 : -2 ^ 62 ≤ x[0].toInt ∧ x[0].toInt < 2 ^ 62 := hx 0
  have hx1 : -2 ^ 62 ≤ x[1].toInt ∧ x[1].toInt < 2 ^ 62 := hx 1
  have hx2 : -2 ^ 62 ≤ x[2].toInt ∧ x[2].toInt < 2 ^ 62 := hx 2
  have hx3 : -2 ^ 62 ≤ x[3].toInt ∧ x[3].toInt < 2 ^ 62 := hx 3
  have hx4 : -2 ^ 62 ≤ x[4].toInt ∧ x[4].toInt < 2 ^ 62 := hx 4
  have hx5 : -2 ^ 62 ≤ x[5].toInt ∧ x[5].toInt < 2 ^ 62 := hx 5
  clear hx
  simp only [biasedCarryPropagateLimbs, carryLimbs, carrySums, extractLimbs, limbsNat]
  have Ht := sub_bias hx5.1
  generalize x[5] - ↑(1 <<< 20 : ℕ) = t at Ht ⊢
  obtain ⟨Hc, Hc1, Hc2⟩ := shr40_bounds t
  generalize t.sshiftRight 40 = c at Hc Hc1 Hc2 ⊢
  obtain ⟨Hs0, -⟩ := add_mul19 hx0 ⟨Hc1, Hc2⟩
  generalize x[0] + 19 * c = s0 at Hs0 ⊢
  obtain ⟨Hs1, -⟩ := add_shr43 (s := s0) hx1
  generalize x[1] + s0.sshiftRight 43 = s1 at Hs1 ⊢
  obtain ⟨Hs2, -⟩ := add_shr43 (s := s1) hx2
  generalize x[2] + s1.sshiftRight 43 = s2 at Hs2 ⊢
  obtain ⟨Hs3, -⟩ := add_shr43 (s := s2) hx3
  generalize x[3] + s2.sshiftRight 43 = s3 at Hs3 ⊢
  obtain ⟨Hs4, -⟩ := add_shr43 (s := s3) hx4
  generalize x[4] + s3.sshiftRight 43 = s4 at Hs4 ⊢
  obtain ⟨Y5, Y5b⟩ := limb5_bias t s4
  refine ⟨⟨and_m43_lt _, and_m43_lt _, and_m43_lt _, and_m43_lt _, and_m43_lt _, ?_⟩, ?_, c.toInt,
    ?_⟩
  · dsimp only
    omega
  · omega
  simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat]
  rw [toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, Y5,
    toInt_and_m40, int, p_int]
  have m0 := Int.emod_def s0.toInt (2 ^ 43)
  have m1 := Int.emod_def s1.toInt (2 ^ 43)
  have m2 := Int.emod_def s2.toInt (2 ^ 43)
  have m3 := Int.emod_def s3.toInt (2 ^ 43)
  have m4 := Int.emod_def s4.toInt (2 ^ 43)
  have mt := Int.emod_def t.toInt (2 ^ 40)
  linear_combination m0 + 2 ^ 43 * m1 + 2 ^ 86 * m2 + 2 ^ 129 * m3 + 2 ^ 172 * m4 +
    2 ^ 215 * mt + Hs0 + 2 ^ 43 * Hs1 + 2 ^ 86 * Hs2 + 2 ^ 129 * Hs3 + 2 ^ 172 * Hs4 +
    2 ^ 215 * Ht + 2 ^ 255 * Hc

/-- A limb in `[0, 2^43)` as a long. -/
theorem toInt_small {a : BitVec 64} (h : a.toNat < 2 ^ 43) :
    a.toInt = a.toNat ∧ (0 : ℤ) ≤ a.toInt ∧ a.toInt < 2 ^ 43 := by
  rw [toInt_of_lt (by omega)]
  omega

theorem add19 {a : BitVec 64} (h : a.toNat < 2 ^ 43) : (a + 19).toInt = a.toNat + 19 := by
  obtain ⟨e, -, -⟩ := toInt_small h
  have h19 : (19 : BitVec 64).toInt = 19 := by decide
  rw [toInt_add' (by rw [e, h19]; omega) (by rw [e, h19]; omega), e, h19]

theorem sub_ite19 {a c : BitVec 64} (h : a.toNat < 2 ^ 43) :
    (a - if c = 0 then 19 else 0).toInt = a.toNat - if c.toInt = 0 then 19 else 0 := by
  obtain ⟨e, -, -⟩ := toInt_small h
  have hc : c = 0 ↔ c.toInt = 0 := by
    constructor
    · rintro rfl; rfl
    · intro h0; exact BitVec.toInt_inj.mp (by rw [h0]; rfl)
  have h19 : (19 : BitVec 64).toInt = 19 := by decide
  by_cases h0 : c = 0
  · have h0' := hc.mp h0
    have hz : (0 : BitVec 64).toInt = 0 := by decide
    simp only [h0, hz, ↓reduceIte]
    rw [toInt_sub' (by rw [e, h19]; omega) (by rw [e, h19]; omega), e, h19]
  · have h0' := mt hc.mpr h0
    simp only [h0, h0', ↓reduceIte, Int.sub_zero]
    rw [show a - 0 = a from BitVec.sub_zero a, e]

/-- `carryLimbs` of signed limbs: limbs in `[0, 2^43)` and a carry out of limb 4 that together
keep the integer. -/
theorem carryLimbs_spec {z0 z1 z2 z3 z4 : BitVec 64} (h1 : -2 ^ 62 ≤ z1.toInt ∧ z1.toInt < 2 ^ 62)
    (h2 : -2 ^ 62 ≤ z2.toInt ∧ z2.toInt < 2 ^ 62) (h3 : -2 ^ 62 ≤ z3.toInt ∧ z3.toInt < 2 ^ 62)
    (h4 : -2 ^ 62 ≤ z4.toInt ∧ z4.toInt < 2 ^ 62) :
    let y := carryLimbs z0 z1 z2 z3 z4
    y.y0.toNat < 2 ^ 43 ∧ y.y1.toNat < 2 ^ 43 ∧ y.y2.toNat < 2 ^ 43 ∧ y.y3.toNat < 2 ^ 43 ∧
      y.y4.toNat < 2 ^ 43 ∧ -2 ^ 20 ≤ y.c.toInt ∧ y.c.toInt ≤ 2 ^ 20 ∧
      (y.y0.toNat + y.y1.toNat * 2 ^ 43 + y.y2.toNat * 2 ^ 86 + y.y3.toNat * 2 ^ 129 +
          y.y4.toNat * 2 ^ 172 : ℤ) + y.c.toInt * 2 ^ 215 =
        z0.toInt + z1.toInt * 2 ^ 43 + z2.toInt * 2 ^ 86 + z3.toInt * 2 ^ 129 +
          z4.toInt * 2 ^ 172 := by
  intro y
  simp only [y, carryLimbs, carrySums]
  obtain ⟨Hs1, -⟩ := add_shr43 (s := z0) h1
  generalize z1 + z0.sshiftRight 43 = s1 at Hs1 ⊢
  obtain ⟨Hs2, -⟩ := add_shr43 (s := s1) h2
  generalize z2 + s1.sshiftRight 43 = s2 at Hs2 ⊢
  obtain ⟨Hs3, -⟩ := add_shr43 (s := s2) h3
  generalize z3 + s2.sshiftRight 43 = s3 at Hs3 ⊢
  obtain ⟨Hs4, -⟩ := add_shr43 (s := s3) h4
  generalize z4 + s3.sshiftRight 43 = s4 at Hs4 ⊢
  have Hc := toInt_sshiftRight' s4 43
  have := toInt_bounds s4
  refine ⟨and_m43_lt _, and_m43_lt _, and_m43_lt _, and_m43_lt _, and_m43_lt _, by omega,
    by omega, ?_⟩
  rw [toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, Hc]
  have m0 := Int.emod_def z0.toInt (2 ^ 43)
  have m1 := Int.emod_def s1.toInt (2 ^ 43)
  have m2 := Int.emod_def s2.toInt (2 ^ 43)
  have m3 := Int.emod_def s3.toInt (2 ^ 43)
  have m4 := Int.emod_def s4.toInt (2 ^ 43)
  linear_combination m0 + 2 ^ 43 * m1 + 2 ^ 86 * m2 + 2 ^ 129 * m3 + 2 ^ 172 * m4 +
    2 ^ 43 * Hs1 + 2 ^ 86 * Hs2 + 2 ^ 129 * Hs3 + 2 ^ 172 * Hs4

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

/-- `fd_r43x6_mod_nearly_reduced_limbs` as 320-bit arithmetic: `p` taken off at most once. -/
theorem modNearly_bv (l0 l1 l2 l3 l4 l5 : BitVec 64) (h0 : l0 < 0x80000000000#64)
    (h1 : l1 < 0x80000000000#64) (h2 : l2 < 0x80000000000#64) (h3 : l3 < 0x80000000000#64)
    (h4 : l4 < 0x80000000000#64) (h5 : l5 < 0x20000000000#64)
    (hL : pack320 ⟨l0, l1, l2, l3, l4, l5⟩ < BitVec.ofNat 320 (2 * (2 ^ 255 - 19))) :
    pack320 (modNearlyReducedLimbs ⟨l0, l1, l2, l3, l4, l5⟩) =
        (if BitVec.ofNat 320 (2 ^ 255 - 19) ≤ pack320 ⟨l0, l1, l2, l3, l4, l5⟩ then
          pack320 ⟨l0, l1, l2, l3, l4, l5⟩ - BitVec.ofNat 320 (2 ^ 255 - 19)
        else pack320 ⟨l0, l1, l2, l3, l4, l5⟩) ∧
      (modNearlyReducedLimbs ⟨l0, l1, l2, l3, l4, l5⟩).y5 < 0x10000000000#64 := by
  simp only [modNearlyReducedLimbs, carryLimbs, carrySums, pack320] at hL ⊢
  bv_decide

-- `norm_num` compares `2p` with `2^320`
set_option exponentiation.threshold 512 in
/-- `fd_r43x6_mod_nearly_reduced_limbs` of nearly reduced limbs: the reduced limbs of their
integer. -/
public theorem modNearly_spec {l : Limbs} (hb : LimbsBounded 41 l) (hL : limbsNat l < 2 * p) :
    LimbsBounded 40 (modNearlyReducedLimbs l) ∧
      limbsNat (modNearlyReducedLimbs l) = limbsNat l % p := by
  obtain ⟨b0, b1, b2, b3, b4, b5⟩ := hb
  have pa := p_add
  obtain ⟨y0, y1, y2, y3, y4, y5⟩ := l
  have hp : (BitVec.ofNat 320 (2 ^ 255 - 19)).toNat = p := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by norm_num)]
  have hL' : pack320 ⟨y0, y1, y2, y3, y4, y5⟩ < BitVec.ofNat 320 (2 * (2 ^ 255 - 19)) := by
    rw [BitVec.lt_def, pack320_toNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by norm_num)]
    exact hL
  obtain ⟨e, h5⟩ := modNearly_bv y0 y1 y2 y3 y4 y5 (by rw [BitVec.lt_def]; simpa using b0)
    (by rw [BitVec.lt_def]; simpa using b1) (by rw [BitVec.lt_def]; simpa using b2)
    (by rw [BitVec.lt_def]; simpa using b3) (by rw [BitVec.lt_def]; simpa using b4)
    (by rw [BitVec.lt_def]; simpa using b5) hL'
  refine ⟨⟨?_, ?_, ?_, ?_, ?_, by rw [BitVec.lt_def] at h5; simpa using h5⟩, ?_⟩
  · simp only [modNearlyReducedLimbs, carryLimbs]; exact and_m43_lt _
  · simp only [modNearlyReducedLimbs, carryLimbs]; exact and_m43_lt _
  · simp only [modNearlyReducedLimbs, carryLimbs]; exact and_m43_lt _
  · simp only [modNearlyReducedLimbs, carryLimbs]; exact and_m43_lt _
  · simp only [modNearlyReducedLimbs, carryLimbs]; exact and_m43_lt _
  rw [← pack320_toNat, e]
  rw [← pack320_toNat] at hL ⊢
  split
  · rename_i hge
    rw [BitVec.le_def, hp] at hge
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hp]; exact hge), hp,
      Nat.mod_eq_sub_mod hge, Nat.mod_eq_of_lt (by omega)]
  · rename_i hlt
    rw [BitVec.le_def, hp] at hlt
    rw [Nat.mod_eq_of_lt (by omega)]

/-- A signed `fd_r43x6_t`'s reduced limbs: below `2^43` (limb 5 below `2^40`), packing to its
value. -/
public theorem reduceLimbs_spec {x : Wwl} (hx : Signed 62 x) :
    LimbsBounded 40 (reduceLimbs x) ∧ limbsNat (reduceLimbs x) = (val x).val := by
  obtain ⟨hb, h5, c, hc⟩ := biasedCarry_spec hx
  have hL : limbsNat (biasedCarryPropagateLimbs (extractLimbs x) (1 <<< 20)) < 2 * p := by
    obtain ⟨b0, b1, b2, b3, b4, -⟩ := hb
    have := p_add
    unfold limbsNat
    omega
  obtain ⟨rb, rv⟩ := modNearly_spec hb hL
  refine ⟨rb, ?_⟩
  rw [reduceLimbs, rv]
  have e : ((val x).val : ℤ) = int x % p := by
    rw [val, ZMod.val_intCast]
  apply Nat.cast_injective (R := ℤ)
  rw [e, Int.natCast_mod, hc, show int x - p * c = int x + (-c) * p by ring,
    Int.add_mul_emod_self_right]

/-- Limbs are all zero exactly when their integer is. -/
theorem limbs_or_eq_zero (l : Limbs) :
    (l.y0 ||| l.y1 ||| l.y2 ||| l.y3 ||| l.y4 ||| l.y5) = 0#64 ↔ limbsNat l = 0 := by
  simp only [BitVec.or_eq_zero_iff, limbsNat]
  constructor
  · rintro ⟨⟨⟨⟨⟨h0, h1⟩, h2⟩, h3⟩, h4⟩, h5⟩
    simp [h0, h1, h2, h3, h4, h5]
  · intro h
    refine ⟨⟨⟨⟨⟨?_, ?_⟩, ?_⟩, ?_⟩, ?_⟩, ?_⟩ <;> apply BitVec.eq_of_toNat_eq <;> simp <;> omega

/-- A signed `fd_r43x6_t`'s reduced limbs are all zero exactly when its value is. -/
theorem reduceLimbs_zero {x : Wwl} (hx : Signed 62 x) :
    ((reduceLimbs x).y0 ||| (reduceLimbs x).y1 ||| (reduceLimbs x).y2 ||| (reduceLimbs x).y3 |||
        (reduceLimbs x).y4 ||| (reduceLimbs x).y5) = 0 ↔ val x = 0 := by
  rw [← ZMod.val_eq_zero, ← (reduceLimbs_spec hx).2]
  exact limbs_or_eq_zero _

/-- `fd_r43x6_is_nonzero` of a signed `fd_r43x6_t`: `0` if its value is zero, else `1`. -/
public theorem fd_r43x6_is_nonzero_spec {x : Wwl} (hx : Signed 62 x) :
    fd_r43x6_is_nonzero.spec x = if val x = 0 then 0 else 1 := by
  rw [fd_r43x6_is_nonzero.spec]
  change (if (reduceLimbs x).y0 ||| (reduceLimbs x).y1 ||| (reduceLimbs x).y2 |||
      (reduceLimbs x).y3 ||| (reduceLimbs x).y4 ||| (reduceLimbs x).y5 = 0 then 0 else 1) = _
  by_cases hv : val x = 0
  · simp only [hv, (reduceLimbs_zero hx).2 hv, ↓reduceIte]
  · simp only [hv, mt (reduceLimbs_zero hx).1 hv, ↓reduceIte]

/-- `fd_r43x6_diagnose` of a signed `fd_r43x6_t`: `-1` if its value is zero, else the low bit of
the reduced value. -/
public theorem fd_r43x6_diagnose_spec {x : Wwl} (hx : Signed 62 x) :
    fd_r43x6_diagnose.spec x = if val x = 0 then -1 else BitVec.ofNat 32 ((val x).val % 2) := by
  obtain ⟨-, rv⟩ := reduceLimbs_spec hx
  rw [fd_r43x6_diagnose.spec]
  change (if (reduceLimbs x).y0 ||| (reduceLimbs x).y1 ||| (reduceLimbs x).y2 |||
      (reduceLimbs x).y3 ||| (reduceLimbs x).y4 ||| (reduceLimbs x).y5 = 0 then -1
      else ((reduceLimbs x).y0 &&& 1).truncate 32) = _
  by_cases hv : val x = 0
  · simp only [hv, (reduceLimbs_zero hx).2 hv, ↓reduceIte]
  · simp only [hv, mt (reduceLimbs_zero hx).1 hv, ↓reduceIte]
    rw [← rv]
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth, BitVec.toNat_and,
      BitVec.toNat_ofNat, limbsNat]
    rw [show (1 : BitVec 64).toNat = 2 ^ 1 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
    omega

end R43x6



end LeanMLIR.RIR.Firedancer.Avx512

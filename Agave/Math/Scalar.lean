module

public import Ed25519.Scalar
public import Mathlib.Data.Fin.VecNotation
public import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Zify

/-! Scalars as `Scalar52`: five 64-bit limbs of radix `2^52`, and the Montgomery arithmetic mod `ℓ`
with `R = 2^260`: the constants `L`, `LFACTOR`, `R`, `RR`; `montgomery_reduce`'s carry chain
(`r · 2^260 = z + n ℓ`), so its result is `z / R mod ℓ` and below `2 ℓ`; and
`from_bytes_mod_order_wide`'s two Montgomery products summing to the input mod `ℓ`. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Scalar52

/-- A `Scalar52`'s number: limb `i` weighs `2^(52 i)`. -/
def nat (l : Fin 5 → BitVec 64) : ℕ :=
  (l 0).toNat + (l 1).toNat * 2 ^ 52 + (l 2).toNat * 2 ^ 104 + (l 3).toNat * 2 ^ 156 +
    (l 4).toNat * 2 ^ 208

/-- `L = ℓ`. -/
def L : Fin 5 → BitVec 64 :=
  ![0x0002631a5cf5d3ed#64, 0x000dea2f79cd6581#64, 0x000000000014def9#64, 0#64,
    0x0000100000000000#64]

/-- `LFACTOR = -ℓ⁻¹ mod 2^52`. -/
def LFACTOR : BitVec 64 :=
  0x51da312547e1b#64

/-- `R = 2^260 mod ℓ`. -/
def R : Fin 5 → BitVec 64 :=
  ![0x000f48bd6721e6ed#64, 0x0003bab5ac67e45a#64, 0x000fffffeb35e51b#64, 0x000fffffffffffff#64,
    0x00000fffffffffff#64]

/-- `RR = 2^520 mod ℓ`. -/
def RR : Fin 5 → BitVec 64 :=
  ![0x0009d265e952d13b#64, 0x000d63c715bea69f#64, 0x0005be65cb687604#64, 0x0003dceec73d217f#64,
    0x000009411b7c309a#64]

/-- `2^260`'s inverse mod `ℓ`. -/
def Rinv : ℕ :=
  5706410653605570882457795059301885719620630590890452783038400561109479083972

end Scalar52

end

namespace Scalar52

/-! ## The constants -/

public theorem nat_L : nat L = ell := by decide +kernel

public theorem nat_R : nat R = 2 ^ 260 % ell := by decide +kernel

public theorem nat_RR : nat RR = 2 ^ 520 % ell := by decide +kernel

/-- `LFACTOR ℓ₀ = -1 mod 2^52`. -/
public theorem lfactor_mul : (LFACTOR.toNat * (L 0).toNat + 1) % 2 ^ 52 = 0 := by decide +kernel

public theorem rinv_mul : 2 ^ 260 * Rinv ≡ 1 [MOD ell] := by
  unfold Nat.ModEq; decide +kernel

/-- Limbs below `2^52` make a number below `2^260`. -/
public theorem nat_lt {l : Fin 5 → BitVec 64} (h : ∀ i, (l i).toNat < 2 ^ 52) :
    nat l < 2 ^ 260 := by
  have := h 0; have := h 1; have := h 2; have := h 3; have := h 4
  unfold nat; omega

/-! ## `montgomery_reduce` -/

/-- `part1`'s multiplier `p = (sum · LFACTOR) mod 2^52`, as the code computes it from the low 64
bits. -/
public theorem part1_p (s : BitVec 128) :
    ((s.setWidth 64 * LFACTOR) &&& 0xfffffffffffff#64).toNat =
      s.toNat * LFACTOR.toNat % 2 ^ 52 := by
  rw [BitVec.toNat_and, show (0xfffffffffffff#64).toNat = 2 ^ 52 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_mul, BitVec.toNat_setWidth,
    Nat.mod_mod_of_dvd _ (by decide : 2 ^ 52 ∣ 2 ^ 64), ← Nat.mod_mul_mod,
    Nat.mod_mod_of_dvd _ (by decide : 2 ^ 52 ∣ 2 ^ 64), Nat.mod_mul_mod]

/-- `part1` makes its column divisible by `2^52`. -/
public theorem part1_dvd (s : ℕ) : (s + s * LFACTOR.toNat % 2 ^ 52 * (L 0).toNat) % 2 ^ 52 = 0 := by
  have h1 :
    s * LFACTOR.toNat % 2 ^ 52 * (L 0).toNat ≡ s * LFACTOR.toNat * (L 0).toNat [MOD 2 ^ 52] :=
    (Nat.mod_modEq _ _).mul_right _
  have h2 : s + s * LFACTOR.toNat * (L 0).toNat = s * (LFACTOR.toNat * (L 0).toNat + 1) := by ring
  rw [(h1.add_left s), h2, Nat.mul_mod, lfactor_mul, mul_zero, Nat.zero_mod]

-- `ring` must evaluate the chain's weights, up to `2^468`
set_option exponentiation.threshold 500 in
/-- `montgomery_reduce`'s carry chain: `part1` columns `c₀ … c₄` exactly divided by `2^52`,
`part2` columns split into a limb `rᵢ` and a carry, and `r₄` the last carry. Then
`r 2^260 = z + n ℓ`, for `z` the 9-limb input and `n` the multipliers. -/
public theorem montgomery_chain
    {z₀ z₁ z₂ z₃ z₄ z₅ z₆ z₇ z₈ n₀ n₁ n₂ n₃ n₄ c₀ c₁ c₂ c₃ c₄ c₅ c₆ c₇ r₀ r₁ r₂ r₃ r₄ : ℕ}
    (h₀ : c₀ * 2 ^ 52 = z₀ + n₀ * (L 0).toNat)
    (h₁ : c₁ * 2 ^ 52 = c₀ + z₁ + n₀ * (L 1).toNat + n₁ * (L 0).toNat)
    (h₂ : c₂ * 2 ^ 52 = c₁ + z₂ + n₀ * (L 2).toNat + n₁ * (L 1).toNat + n₂ * (L 0).toNat)
    (h₃ : c₃ * 2 ^ 52 = c₂ + z₃ + n₁ * (L 2).toNat + n₂ * (L 1).toNat + n₃ * (L 0).toNat)
    (h₄ :
      c₄ * 2 ^ 52 =
        c₃ + z₄ + n₀ * (L 4).toNat + n₂ * (L 2).toNat + n₃ * (L 1).toNat + n₄ * (L 0).toNat)
    (h₅ : r₀ + c₅ * 2 ^ 52 = c₄ + z₅ + n₁ * (L 4).toNat + n₃ * (L 2).toNat + n₄ * (L 1).toNat)
    (h₆ : r₁ + c₆ * 2 ^ 52 = c₅ + z₆ + n₂ * (L 4).toNat + n₄ * (L 2).toNat)
    (h₇ : r₂ + c₇ * 2 ^ 52 = c₆ + z₇ + n₃ * (L 4).toNat)
    (h₈ : r₃ + r₄ * 2 ^ 52 = c₇ + z₈ + n₄ * (L 4).toNat) :
    (r₀ + r₁ * 2 ^ 52 + r₂ * 2 ^ 104 + r₃ * 2 ^ 156 + r₄ * 2 ^ 208) * 2 ^ 260 =
      z₀ + z₁ * 2 ^ 52 + z₂ * 2 ^ 104 + z₃ * 2 ^ 156 + z₄ * 2 ^ 208 + z₅ * 2 ^ 260 + z₆ * 2 ^ 312 +
        z₇ * 2 ^ 364 +
        z₈ * 2 ^ 416 +
        (n₀ + n₁ * 2 ^ 52 + n₂ * 2 ^ 104 + n₃ * 2 ^ 156 + n₄ * 2 ^ 208) * ell := by
  have hL :
    ell = (L 0).toNat + (L 1).toNat * 2 ^ 52 + (L 2).toNat * 2 ^ 104 + (L 4).toNat * 2 ^ 208 := by
    decide +kernel
  rw [hL]
  zify at h₀ h₁ h₂ h₃ h₄ h₅ h₆ h₇ h₈ ⊢
  linear_combination
    h₀ + 2 ^ 52 * h₁ + 2 ^ 104 * h₂ + 2 ^ 156 * h₃ + 2 ^ 208 * h₄ + 2 ^ 260 * h₅ + 2 ^ 312 * h₆ +
      2 ^ 364 * h₇ +
      2 ^ 416 * h₈

/-- A Montgomery result is the input divided by `2^260`, mod `ℓ`. -/
public theorem montgomery_mod {r z n : ℕ} (h : r * 2 ^ 260 = z + n * ell) :
    r % ell = z * Rinv % ell := by
  have e : r * 2 ^ 260 * Rinv ≡ z * Rinv [MOD ell] := by
    rw [h, add_mul, mul_right_comm]
    have : n * Rinv * ell ≡ 0 [MOD ell] := Nat.modEq_zero_iff_dvd.2 (dvd_mul_left _ _)
    simp
  have e' : r * 2 ^ 260 * Rinv ≡ r [MOD ell] := by
    rw [mul_assoc]
    calc
      r * (2 ^ 260 * Rinv) ≡ r * 1 [MOD ell] := (Nat.ModEq.mul_left _ rinv_mul)
      _ = r := mul_one r
  exact e'.symm.trans e

/-- A Montgomery result of an input below `2^260 ℓ`, with multiplier below `2^260`, is below `2 ℓ`.
-/
public theorem montgomery_lt {r z n : ℕ} (h : r * 2 ^ 260 = z + n * ell) (hz : z < 2 ^ 260 * ell)
    (hn : n < 2 ^ 260) : r < 2 * ell := by
  have hn' : n * ell < 2 ^ 260 * ell :=
    Nat.mul_lt_mul_of_pos_right hn
      (by
        unfold ell; omega)
  have : r * 2 ^ 260 < 2 * ell * 2 ^ 260 :=
    calc
      r * 2 ^ 260 = z + n * ell := h
      _ < 2 ^ 260 * ell + 2 ^ 260 * ell := Nat.add_lt_add hz hn'
      _ = 2 * ell * 2 ^ 260 := by rw [← two_mul, ← mul_assoc, mul_right_comm]
  exact Nat.lt_of_mul_lt_mul_right this

/-- Below `2 ℓ`, subtracting `ℓ` when possible reduces mod `ℓ`. -/
public theorem sub_ell_eq_mod {r : ℕ} (h : r < 2 * ell) :
    (if r < ell then r else r - ell) = r % ell := by
  split_ifs with h'
  · exact (Nat.mod_eq_of_lt h').symm
  · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]

/-! ## `from_bytes_mod_order_wide` -/

-- unification compares `2^260 * 2^260` with its power
set_option exponentiation.threshold 520 in
/-- `montgomery_mul(lo, R) + montgomery_mul(hi, RR)` is `lo + 2^260 hi` mod `ℓ`. -/
public theorem wide_mod {a b lo hi : ℕ} (ha : a % ell = lo * nat R * Rinv % ell)
    (hb : b % ell = hi * nat RR * Rinv % ell) : (a + b) % ell = (lo + 2 ^ 260 * hi) % ell := by
  have hR : nat R * Rinv ≡ 1 [MOD ell] := by
    rw [nat_R]
    exact ((Nat.mod_modEq _ _).mul_right _).trans rinv_mul
  have e : (2 : ℕ) ^ 520 = 2 ^ 260 * 2 ^ 260 := by rw [← pow_add]
  have hRR : nat RR * Rinv ≡ 2 ^ 260 [MOD ell] := by
    rw [nat_RR, e]
    calc
      2 ^ 260 * 2 ^ 260 % ell * Rinv ≡ 2 ^ 260 * 2 ^ 260 * Rinv [MOD ell] :=
        (Nat.mod_modEq _ _).mul_right _
      _ = 2 ^ 260 * (2 ^ 260 * Rinv) := mul_assoc _ _ _
      _ ≡ 2 ^ 260 * 1 [MOD ell] := Nat.ModEq.mul_left _ rinv_mul
      _ = 2 ^ 260 := mul_one _
  have ea : a ≡ lo [MOD ell] := by
    calc
      a ≡ lo * (nat R * Rinv) [MOD ell] := by
        rw [← mul_assoc]; exact ha
      _ ≡ lo * 1 [MOD ell] := Nat.ModEq.mul_left _ hR
      _ = lo := mul_one _
  have eb : b ≡ 2 ^ 260 * hi [MOD ell] := by
    calc
      b ≡ hi * (nat RR * Rinv) [MOD ell] := by
        rw [← mul_assoc]; exact hb
      _ ≡ hi * 2 ^ 260 [MOD ell] := Nat.ModEq.mul_left _ hRR
      _ = 2 ^ 260 * hi := mul_comm _ _
  exact ea.add eb

end Scalar52

end MLIR.Agave

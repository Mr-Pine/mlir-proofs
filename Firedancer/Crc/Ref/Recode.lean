module

public import Mathlib.Tactic

/-!
# Signed nibble recoding with bias (spec and mathematical correctness)

`crc_adx_recode16_bias` (PR firedancer #12267, `crc/ref/fd_ed25519_ref_sign.c`) recodes the 256-bit
little-endian scalar `s` into 64 signed nibble digits `d₀, …, d₆₃ ∈ [-7, 8]` with
`∑ᵢ dᵢ · 16^i = s`, the digit stream the constant-time comb multiplication
`crc_ge_adx_scalar_mul_base_ct` consumes.

The C adds the all-sevens constant `0x77…77` (64 nibbles of `7`) to `s` with carry across the four
limbs, drops the carry out of bit 256, then takes each nibble of the result minus `7`:

```c
for i: w += 0x7777777777777777 (with inter-limb carry)     // w ← (s + bias) mod 2^256
for i in 0..64: d[i] = nibble_i(w) − 7
```

Adding `bias = ∑_{k<64} 7·16^k` shifts every nibble up by 7 so the subtraction recovers a signed
digit; the bias cancels in the sum. We model `s` and the result as naturals and prove the two
properties, for scalars small enough that `s + bias` does not overflow 256 bits — the reduced
Ed25519 scalars (`s < ℓ < 2^253`) are far below the bound.
-/

namespace MLIR.Firedancer.Crc.Ref.Recode

@[expose] public section

/-- `bias = 0x77…77`: 64 nibbles of `7`, `∑_{k<64} 7·16^k`. -/
def bias : Nat := ∑ k ∈ Finset.range 64, 7 * 16 ^ k

/-- Digit `i` of the recoding of `s`: nibble `i` of `(s + bias) mod 2^256`, minus `7`. -/
def digit (s : Nat) (i : Nat) : Int :=
  (((s + bias) % 2 ^ 256 / 16 ^ i % 16 : Nat) : Int) - 7

/-! ## Mathematical correctness -/

/-- Base-`B` expansion: the low `n` digits of `x` reconstruct `x mod B^n`. -/
theorem base_expand (B : Nat) :
    ∀ x n, ∑ i ∈ Finset.range n, (x / B ^ i % B) * B ^ i = x % B ^ n := by
  intro x n
  induction n with
  | zero => simp [Nat.mod_one]
  | succ n ih =>
    rw [Finset.sum_range_succ, ih, pow_succ, Nat.mod_mul]
    ring

/-- **Reconstruction.** The 64 signed nibbles sum back to `s` (when `s + bias < 2^256`). -/
theorem recode_sum (s : Nat) (hs : s + bias < 2 ^ 256) :
    ∑ i ∈ Finset.range 64, digit s i * 16 ^ i = (s : Int) := by
  have hw : (s + bias) % 2 ^ 256 = s + bias := Nat.mod_eq_of_lt hs
  have hpow : (2 : Nat) ^ 256 = 16 ^ 64 := by norm_num
  have hnat : ∑ i ∈ Finset.range 64, ((s + bias) / 16 ^ i % 16) * 16 ^ i = s + bias := by
    rw [base_expand 16, ← hpow, hw]
  have e1 : ∑ i ∈ Finset.range 64, digit s i * 16 ^ i
      = ∑ i ∈ Finset.range 64, ((((s + bias) / 16 ^ i % 16 : ℕ) : Int) - 7) * 16 ^ i := by
    apply Finset.sum_congr rfl; intro i _; rw [digit, hw]
  have e2 : ∑ i ∈ Finset.range 64, ((((s + bias) / 16 ^ i % 16 : ℕ) : Int) - 7) * 16 ^ i
      = (↑(∑ i ∈ Finset.range 64, ((s + bias) / 16 ^ i % 16) * 16 ^ i) : Int)
        - ↑(∑ i ∈ Finset.range 64, 7 * 16 ^ i) := by
    push_cast [Nat.cast_sum]
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro i _; ring
  rw [e1, e2, hnat]
  simp only [bias]
  push_cast
  ring

/-- **Digit range.** Each digit lies in `[-7, 8]`. -/
theorem digit_range (s i : Nat) : -7 ≤ digit s i ∧ digit s i ≤ 8 := by
  rw [digit]
  have h : (s + bias) % 2 ^ 256 / 16 ^ i % 16 < 16 := Nat.mod_lt _ (by norm_num)
  set n := (s + bias) % 2 ^ 256 / 16 ^ i % 16 with hn
  have hc : (n : Int) < 16 := by exact_mod_cast h
  have hc0 : (0 : Int) ≤ (n : Int) := Int.natCast_nonneg n
  omega

end

end MLIR.Firedancer.Crc.Ref.Recode

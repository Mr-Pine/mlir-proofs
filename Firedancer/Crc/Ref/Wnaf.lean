module

public import Mathlib.Tactic
public import Firedancer.Math.Wnaf

/-!
# wNAF signed-digit decomposition (spec and mathematical correctness)

`crc_adx_wnaf` (PR firedancer #12267, `crc/ref/fd_ed25519_ref_verify.c`) rewrites a 256-bit
little-endian scalar `s` as signed digits `d₀, d₁, …` with `∑ᵢ dᵢ · 2^i = s`, each `dᵢ` zero or
odd and `−2^bits < dᵢ < 2^bits`. It peels one digit per right shift:

```c
while( w ) {                              // w = the running scalar
  long di = 0;
  if( w & 1 ) { ulong lo = w & ((1<<(bits+1))-1);          // lo = w mod 2^(bits+1)
                di = (lo >= 1<<bits) ? lo - (1<<(bits+1)) : lo; w -= di; }
  d[n++] = di;  w >>= 1;                  // w ← (w − di) / 2
}
```

We model `w` as a natural (`= s.toNat`), state the digit rule and the loop as pure functions, and
prove the three properties **directly** for this algorithm — not by appeal to the tree's variant.
The last section additionally records that the proved reconstruction of the tree's
`fd_curve25519_scalar_wnaf` (`Firedancer.Math.Wnaf`) is available for reuse.
-/

namespace MLIR.Firedancer.Crc.Ref.Wnaf

@[expose] public section

/-! ## The dense-peel model -/

/-- The signed window digit of `w` for `bits`-wide windows: `0` when `w` is even, else the
representative of `w mod 2^(bits+1)` shifted into `(-2^bits, 2^bits)`. -/
def digit (bits w : Nat) : Int :=
  if w % 2 = 0 then 0
  else if 2 ^ bits ≤ (w : Int) % 2 ^ (bits + 1) then
    (w : Int) % 2 ^ (bits + 1) - 2 ^ (bits + 1)
  else (w : Int) % 2 ^ (bits + 1)

/-- Evaluate a little-endian signed-digit list: `∑ᵢ dᵢ · 2^i`. -/
def eval : List Int → Int
  | [] => 0
  | d :: ds => d + 2 * eval ds

/-- The wNAF digits of `w` (low to high), with `fuel` bounding the number of iterations. -/
def digits (bits : Nat) : Nat → Nat → List Int
  | 0, _ => []
  | _ + 1, 0 => []
  | fuel + 1, w + 1 =>
    digit bits (w + 1) :: digits bits fuel ((((w + 1 : Nat) : Int) - digit bits (w + 1)).toNat / 2)

/-! ## Digit properties -/

/-- The facts about `lo = w mod 2^(bits+1)` the digit reasoning needs: its parity equals `w`'s, it
is below `2^(bits+1) = 2·2^bits`, nonnegative. -/
private theorem lo_facts (bits w : Nat) :
    ((w : Int) % 2 ^ (bits + 1)) % 2 = (w : Int) % 2 ∧
      (w : Int) % 2 ^ (bits + 1) < 2 ^ (bits + 1) ∧
      0 ≤ (w : Int) % 2 ^ (bits + 1) ∧
      (2 : Int) ^ (bits + 1) = 2 * 2 ^ bits := by
  have hp : (0 : Int) < 2 ^ (bits + 1) := by positivity
  refine ⟨?_, Int.emod_lt_of_pos _ hp, Int.emod_nonneg _ (by positivity), by ring⟩
  rw [Int.emod_emod_of_dvd _ (dvd_pow_self 2 (Nat.succ_ne_zero bits))]

/-- `w − digit` is a nonnegative even integer: the next `w` is a well-defined natural. -/
theorem sub_digit_even (bits w : Nat) : ((w : Int) - digit bits w) % 2 = 0 := by
  obtain ⟨hpar, _, _, htwo⟩ := lo_facts bits w
  unfold digit
  split_ifs <;> omega

/-- `w mod 2^(bits+1) ≤ w`. -/
theorem emod_le (bits w : Nat) : (w : Int) % 2 ^ (bits + 1) ≤ (w : Int) := by
  rw [show (2 : Int) ^ (bits + 1) = ((2 ^ (bits + 1) : Nat) : Int) by push_cast; ring,
    ← Int.natCast_emod]
  exact_mod_cast Nat.mod_le w _

/-- The low digit never exceeds `w`, so `w − digit ≥ 0`. -/
theorem digit_le (bits w : Nat) : digit bits w ≤ (w : Int) := by
  have hmod := emod_le bits w
  have hpos : (0 : Int) ≤ 2 ^ (bits + 1) := by positivity
  unfold digit
  split_ifs <;> omega

theorem sub_digit_nonneg (bits w : Nat) : 0 ≤ (w : Int) - digit bits w := by
  have := digit_le bits w; omega

/-- A digit is `0` (when `w` is even) or odd (when `w` is odd). -/
theorem digit_zero_or_odd (bits w : Nat) : digit bits w = 0 ∨ digit bits w % 2 = 1 := by
  obtain ⟨hpar, _, _, htwo⟩ := lo_facts bits w
  unfold digit
  split_ifs <;> omega

/-- A digit lies strictly inside `(-2^bits, 2^bits)` (for `bits ≥ 1`). -/
theorem digit_bound (bits w : Nat) (hbits : 1 ≤ bits) :
    -(2 ^ bits) < digit bits w ∧ digit bits w < 2 ^ bits := by
  obtain ⟨hpar, hlt, hnn, htwo⟩ := lo_facts bits w
  have hpow : (0 : Int) < 2 ^ bits := by positivity
  have hpoweven : (2 : Int) ^ bits % 2 = 0 := by
    have : (2 : Int) ^ bits = 2 * 2 ^ (bits - 1) := by rw [← pow_succ']; congr 1; omega
    omega
  unfold digit
  split_ifs <;> omega

/-! ## Termination and reconstruction -/

/-- A digit never drops below `-w` (for `w ≥ 1`, `bits ≥ 1`). -/
theorem neg_lt_digit (bits w : Nat) (hbits : 1 ≤ bits) (hw : 1 ≤ w) :
    -(w : Int) < digit bits w := by
  obtain ⟨hpar, hlt, hnn, htwo⟩ := lo_facts bits w
  have hmod := emod_le bits w
  have hpoweven : (2 : Int) ^ bits % 2 = 0 := by
    have : (2 : Int) ^ bits = 2 * 2 ^ (bits - 1) := by rw [← pow_succ']; congr 1; omega
    omega
  unfold digit
  split_ifs <;> omega

/-- Each iteration strictly shrinks `w` (for `w ≥ 1`, `bits ≥ 1`): the loop terminates. -/
theorem next_lt (bits w : Nat) (hbits : 1 ≤ bits) (hw : 1 ≤ w) :
    ((w : Int) - digit bits w).toNat / 2 < w := by
  have hgt := neg_lt_digit bits w hbits hw
  have hnn := sub_digit_nonneg bits w
  omega

/-- **Reconstruction.** For enough `fuel` (`w ≤ fuel`, `bits ≥ 1`), the dense-peel digits of `w`
sum back to `w`: `∑ᵢ dᵢ · 2^i = w`. -/
theorem eval_digits (bits : Nat) (hbits : 1 ≤ bits) :
    ∀ fuel w, w ≤ fuel → eval (digits bits fuel w) = (w : Int) := by
  intro fuel
  induction fuel with
  | zero => intro w hw; interval_cases w; rfl
  | succ fuel ih =>
    intro w hw
    cases w with
    | zero => rfl
    | succ w =>
      have hw1 : 1 ≤ w + 1 := by omega
      have hnn := sub_digit_nonneg bits (w + 1)
      have he := sub_digit_even bits (w + 1)
      have hlt := next_lt bits (w + 1) hbits hw1
      rw [digits, eval, ih _ (by omega)]
      omega

/-- **Digit shape of the sequence.** Every digit `crc_adx_wnaf` writes is `0` or odd and lies in
`(-2^bits, 2^bits)` (`bits ≥ 1`). -/
theorem digits_mem_shape (bits : Nat) (hbits : 1 ≤ bits) :
    ∀ fuel w d, d ∈ digits bits fuel w →
      (d = 0 ∨ d % 2 = 1) ∧ -(2 ^ bits) < d ∧ d < 2 ^ bits := by
  intro fuel
  induction fuel with
  | zero => intro w d hd; simp [digits] at hd
  | succ fuel ih =>
    intro w d hd
    cases w with
    | zero => simp only [digits, List.not_mem_nil] at hd
    | succ w =>
      simp only [digits, List.mem_cons] at hd
      rcases hd with rfl | hd
      · exact ⟨digit_zero_or_odd bits (w + 1), digit_bound bits (w + 1) hbits⟩
      · exact ih _ d hd

/-! ## Reuse of the tree's reconstruction

The tree's `fd_curve25519_scalar_wnaf` produces the same signed-digit sequence by a set-bit scan;
its reconstruction and digit bounds are proved in `Firedancer.Math.Wnaf` and are available here. -/

/-- The tree's wNAF of `s` with window `bits`, proved to reconstruct `s` and have in-range digits
(`Firedancer.Math.Wnaf.wnaf_sum`, `wnaf_digit`). -/
abbrev treeSpec (s : BitVec 256) (bits : Nat) : Vector Int 256 :=
  MLIR.Firedancer.Ref.fd_curve25519_scalar_wnaf.wnaf s bits

theorem treeSpec_sum (s : BitVec 256) (hb : 1 ≤ bits ∧ bits ≤ 13) (hs : s.toNat < 2 ^ 255) :
    ∑ i : Fin 256, (treeSpec s bits)[i] * 2 ^ (i : Nat) = s.toNat :=
  MLIR.Firedancer.Ref.fd_curve25519_scalar_wnaf.wnaf_sum s hb hs

end

end MLIR.Firedancer.Crc.Ref.Wnaf

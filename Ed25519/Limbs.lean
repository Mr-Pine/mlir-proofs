module

public import Ed25519.Field
public import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.FinCases

/-! Field elements as five 64-bit limbs of radix `2^51`: their value in `ZMod p`, their number in
`ℕ`, and the carry and bound arithmetic shared by the limb implementations. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- A field element's value: limb `i` weighs `2^(51 i)`. -/
def Limbs.val (l : Fin 5 → BitVec 64) : ZMod p :=
  ∑ i : Fin 5, ((l i).toNat : ZMod p) * 2 ^ (51 * (i : ℕ))

/-- The limbs' natural number, before reduction mod `p`. -/
def Limbs.nat (l : Fin 5 → BitVec 64) : ℕ :=
  (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
    (l 4).toNat * 2 ^ 204

/-- Every limb below `c`. -/
abbrev Limbs.Lt (l : Fin 5 → BitVec 64) (c : ℕ) : Prop :=
  ∀ i, (l i).toNat < c

/-- `x` holds `n`, at most `M`. -/
def ValLe (x : BitVec w) (n M : ℕ) : Prop :=
  x.toNat = n ∧ n ≤ M

end

/-! ## Bounds -/

public theorem Limbs.Lt.mono {l : Fin 5 → BitVec 64} {c d : ℕ} (h : Limbs.Lt l c) (hcd : c ≤ d) :
    Limbs.Lt l d := fun i => (h i).trans_le hcd

public theorem Limbs.lt_iff (l : Fin 5 → BitVec 64) (c : ℕ) :
    Limbs.Lt l c ↔
      (l 0).toNat < c ∧ (l 1).toNat < c ∧ (l 2).toNat < c ∧ (l 3).toNat < c ∧ (l 4).toNat < c := by
  refine ⟨fun h => ⟨h 0, h 1, h 2, h 3, h 4⟩, fun h i => ?_⟩
  fin_cases i <;> simp [h]

/-! ## Carries -/

/-- `x`'s low 51 bits and its carry, in `ZMod p`. -/
public theorem mod_add_div51 (x : ℕ) :
    ((x % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (x / 2 ^ 51 : ℕ) = x := by
  exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ 51))

/-- A 128-bit column's carry out of bit 51, truncated to a limb. -/
public theorem toNat_shift_setWidth (x : BitVec 128) :
    ((x >>> 51).setWidth 64).toNat = x.toNat / 2 ^ 51 % 2 ^ 64 := by
  rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-! ## Values -/

public theorem Limbs.val_eq (l : Fin 5 → BitVec 64) :
    Limbs.val l =
      (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
        (l 4).toNat * 2 ^ 204 := by
  simp [Limbs.val, Fin.sum_univ_five]

public theorem Limbs.val_nat (l : Fin 5 → BitVec 64) : Limbs.val l = (Limbs.nat l : ZMod p) := by
  rw [Limbs.val_eq, Limbs.nat]
  push_cast
  rfl

/-- Limbs with the same number have the same value. -/
public theorem Limbs.val_congr {l l' : Fin 5 → BitVec 64} (h : Limbs.nat l = Limbs.nat l') :
    Limbs.val l = Limbs.val l' := by rw [Limbs.val_nat, Limbs.val_nat, h]

/-! ## Limb bits -/

public theorem toNat_and_mask (x : BitVec 64) :
    (x &&& 2251799813685247#64).toNat = x.toNat % 2 ^ 51 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]
  rfl

public theorem toNat_shift (x : BitVec 64) : (x >>> 51).toNat = x.toNat / 2 ^ 51 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

public theorem toNat_setWidth_mask (x : BitVec 128) :
    (x.setWidth 64 &&& 2251799813685247#64).toNat = x.toNat % 2 ^ 51 := by
  rw [toNat_and_mask, BitVec.toNat_setWidth, Nat.mod_mod_of_dvd _ (by decide)]

/-! ## Carries -/

/-- A carry chain's value identity in `ℕ`, cast to `ZMod p`: columns `C` carried at bit 51, the top
carry times 19 into limb 0, then carries out of limbs 0 and 1. -/
public theorem carry_val {C0 C1 C2 C3 C4 t1 t2 t3 t4 u0 u1 : ℕ} (ht1 : t1 = C1 + C0 / 2 ^ 51)
    (ht2 : t2 = C2 + t1 / 2 ^ 51) (ht3 : t3 = C3 + t2 / 2 ^ 51) (ht4 : t4 = C4 + t3 / 2 ^ 51)
    (hu0 : u0 = t4 / 2 ^ 51 * 19 + C0 % 2 ^ 51) (hu1 : u1 = u0 / 2 ^ 51 + t1 % 2 ^ 51) :
    ((u0 % 2 ^ 51 : ℕ) : ZMod p) + (u1 % 2 ^ 51 : ℕ) * 2 ^ 51 +
        (u1 / 2 ^ 51 + t2 % 2 ^ 51 : ℕ) * 2 ^ 102 +
        (t3 % 2 ^ 51 : ℕ) * 2 ^ 153 +
        (t4 % 2 ^ 51 : ℕ) * 2 ^ 204 =
      C0 + C1 * 2 ^ 51 + C2 * 2 ^ 102 + C3 * 2 ^ 153 + C4 * 2 ^ 204 := by
  have e (x : ℕ) : ((x % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (x / 2 ^ 51 : ℕ) = x := by
    exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ 51))
  have T1 := congrArg (Nat.cast (R := ZMod p)) ht1
  have T2 := congrArg (Nat.cast (R := ZMod p)) ht2
  have T3 := congrArg (Nat.cast (R := ZMod p)) ht3
  have T4 := congrArg (Nat.cast (R := ZMod p)) ht4
  have U0 := congrArg (Nat.cast (R := ZMod p)) hu0
  have U1 := congrArg (Nat.cast (R := ZMod p)) hu1
  push_cast at T1 T2 T3 T4 U0 U1 ⊢
  linear_combination
    2 ^ 51 * e u1 + 2 ^ 51 * U1 + e u0 + U0 + e C0 + 2 ^ 51 * T1 + 2 ^ 51 * e t1 + 2 ^ 102 * T2 +
        2 ^ 102 * e t2 +
        2 ^ 153 * T3 +
        2 ^ 153 * e t3 +
        2 ^ 204 * T4 +
        2 ^ 204 * e t4 -
      (t4 / 2 ^ 51 : ℕ) * two_pow_255

/-! ## Bounded values -/

public theorem ValLe.const (c : BitVec w) : ValLe c c.toNat c.toNat :=
  ⟨rfl, le_rfl⟩

public theorem ValLe.add {x y : BitVec w} (hx : ValLe x m M) (hy : ValLe y n N)
    (h : M + N < 2 ^ w) : ValLe (x + y) (m + n) (M + N) := by
  obtain ⟨rfl, hm⟩ := hx
  obtain ⟨rfl, hn⟩ := hy
  exact ⟨by rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)], by omega⟩

public theorem ValLe.mul {x y : BitVec w} (hx : ValLe x m M) (hy : ValLe y n N)
    (h : M * N < 2 ^ w) : ValLe (x * y) (m * n) (M * N) := by
  obtain ⟨rfl, hm⟩ := hx
  obtain ⟨rfl, hn⟩ := hy
  have := Nat.mul_le_mul hm hn
  exact ⟨by rw [BitVec.toNat_mul, Nat.mod_eq_of_lt (by omega)], this⟩

public theorem ValLe.setWidth {x : BitVec w} (hx : ValLe x n M) (h : M < 2 ^ v) :
    ValLe (x.setWidth v) n M := by
  obtain ⟨rfl, hn⟩ := hx
  exact ⟨by rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)], hn⟩

public theorem ValLe.shl {x : BitVec w} (hx : ValLe x n M) (h : M * 2 ^ k < 2 ^ w) :
    ValLe (x <<< k) (n * 2 ^ k) (M * 2 ^ k) := by
  obtain ⟨rfl, hn⟩ := hx
  have := Nat.mul_le_mul_right (2 ^ k) hn
  exact ⟨by rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)], this⟩

end Ed25519

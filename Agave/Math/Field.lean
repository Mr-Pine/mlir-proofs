module

public import Ed25519.Limbs
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! Field elements. The serial `FieldElement51` is `Ed25519.Limbs`: five 64-bit limbs of radix
`2^51`, `Limbs.val`. The AVX2 `FieldElement2625x4` packs four field elements `A, B, C, D` of ten
limbs each, alternately of 26 and 25 bits, into five `u32x8` registers: register `i` holds limbs
`2 i` and `2 i + 1` as `(a₂ᵢ, b₂ᵢ, a₂ᵢ₊₁, b₂ᵢ₊₁, c₂ᵢ, d₂ᵢ, c₂ᵢ₊₁, d₂ᵢ₊₁)`. Here: its value, `split`
and `new`'s packing, `2 p`'s limbs, and `reduce`'s carry chain. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- An AVX2 `FieldElement2625x4`: five `u32x8` registers. -/
abbrev Fe2625x4 :=
  Fin 5 → Vector (BitVec 32) 8

namespace Fe2625x4

/-- The lane of element `e`'s even limbs. -/
def evenLane (e : Fin 4) : Fin 8 :=
  ![0, 1, 4, 5] e

/-- The lane of element `e`'s odd limbs. -/
def oddLane (e : Fin 4) : Fin 8 :=
  ![2, 3, 6, 7] e

/-- Element `e`'s number: limb `2 i` weighs `2^(51 i)`, limb `2 i + 1` weighs `2^(51 i + 26)`. -/
def nat (v : Fe2625x4) (e : Fin 4) : ℕ :=
  ∑ i : Fin 5,
    ((v i)[evenLane e].toNat * 2 ^ (51 * (i : ℕ)) +
      (v i)[oddLane e].toNat * 2 ^ (51 * (i : ℕ) + 26))

/-- Element `e`'s value. -/
def val (v : Fe2625x4) (e : Fin 4) : ZMod p :=
  (nat v e : ZMod p)

/-- `split`: element `e` as radix-`2^51` limbs, `lo + hi · 2^26` per register. -/
def split (v : Fe2625x4) (e : Fin 4) : Fin 5 → BitVec 64 := fun i =>
  (v i)[evenLane e].setWidth 64 + (v i)[oddLane e].setWidth 64 <<< 26

/-- `new`'s packing, before its `reduce`: each radix-`2^51` limb's low 26 bits and the rest. -/
def pack (x₀ x₁ x₂ x₃ : Fin 5 → BitVec 64) : Fe2625x4 := fun i =>
  let lo (x : Fin 5 → BitVec 64) := (x i &&& 67108863#64).setWidth 32
  let hi (x : Fin 5 → BitVec 64) := (x i >>> 26).setWidth 32
  Vector.ofFn ![lo x₀, lo x₁, hi x₀, hi x₁, lo x₂, lo x₃, hi x₂, hi x₃]

/-- `P_TIMES_2_LO`, register 0 of `(2p, 2p, 2p, 2p)`. -/
def p2Lo : Vector (BitVec 32) 8 :=
  #v[134217690, 134217690, 67108862, 67108862, 134217690, 134217690, 67108862, 67108862]

/-- `P_TIMES_2_HI`, registers 1 to 4 of `(2p, 2p, 2p, 2p)`. -/
def p2Hi : Vector (BitVec 32) 8 :=
  #v[134217726, 134217726, 67108862, 67108862, 134217726, 134217726, 67108862, 67108862]

/-- `(2p, 2p, 2p, 2p)`. -/
def p2 : Fe2625x4 := fun i => if i = 0 then p2Lo else p2Hi

end Fe2625x4

end

namespace Fe2625x4

/-! ## Values -/

public theorem nat_eq (v : Fe2625x4) (e : Fin 4) :
    nat v e =
      (v 0)[evenLane e].toNat + (v 0)[oddLane e].toNat * 2 ^ 26 + (v 1)[evenLane e].toNat * 2 ^ 51 +
        (v 1)[oddLane e].toNat * 2 ^ 77 +
        (v 2)[evenLane e].toNat * 2 ^ 102 +
        (v 2)[oddLane e].toNat * 2 ^ 128 +
        (v 3)[evenLane e].toNat * 2 ^ 153 +
        (v 3)[oddLane e].toNat * 2 ^ 179 +
        (v 4)[evenLane e].toNat * 2 ^ 204 +
        (v 4)[oddLane e].toNat * 2 ^ 230 := by
  simp only [nat, Fin.sum_univ_five]
  norm_num
  ring

/-- `split` keeps each element's number: a limb pair fits 64 bits. -/
public theorem nat_split (v : Fe2625x4) (e : Fin 4) : Limbs.nat (split v e) = nat v e := by
  have h (i : Fin 5) :
    (split v e i).toNat = (v i)[evenLane e].toNat + (v i)[oddLane e].toNat * 2 ^ 26 := by
    have := ((v i)[evenLane e]).isLt
    have := ((v i)[oddLane e]).isLt
    simp only [split, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
      Nat.shiftLeft_eq]
    rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
  rw [Limbs.nat, h, h, h, h, h, nat_eq]
  ring

public theorem val_split (v : Fe2625x4) (e : Fin 4) : Limbs.val (split v e) = val v e := by
  rw [Limbs.val_nat, nat_split, val]

public theorem pack_even (x₀ x₁ x₂ x₃ : Fin 5 → BitVec 64) (e : Fin 4) (i : Fin 5) :
    (pack x₀ x₁ x₂ x₃ i)[evenLane e] = (![x₀, x₁, x₂, x₃] e i &&& 67108863#64).setWidth 32 := by
  fin_cases e <;> rfl

public theorem pack_odd (x₀ x₁ x₂ x₃ : Fin 5 → BitVec 64) (e : Fin 4) (i : Fin 5) :
    (pack x₀ x₁ x₂ x₃ i)[oddLane e] = (![x₀, x₁, x₂, x₃] e i >>> 26).setWidth 32 := by
  fin_cases e <;> rfl

/-- `new`'s packing keeps limbs below `2^58`. -/
public theorem nat_pack (x₀ x₁ x₂ x₃ : Fin 5 → BitVec 64) (e : Fin 4)
    (h : ∀ i, (![x₀, x₁, x₂, x₃] e i).toNat < 2 ^ 58) :
    nat (pack x₀ x₁ x₂ x₃) e = Limbs.nat (![x₀, x₁, x₂, x₃] e) := by
  have key (x : BitVec 64) (hx : x.toNat < 2 ^ 58) :
    ((x &&& 67108863#64).setWidth 32).toNat + ((x >>> 26).setWidth 32).toNat * 2 ^ 26 =
      x.toNat := by
    have e1 : (x &&& 67108863#64).toNat = x.toNat % 2 ^ 26 := by
      rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]; rfl
    have h1 : ((x &&& 67108863#64).setWidth 32).toNat = x.toNat % 2 ^ 26 := by
      rw [BitVec.toNat_setWidth, e1]; exact Nat.mod_eq_of_lt (by omega)
    have h2 : ((x >>> 26).setWidth 32).toNat = x.toNat / 2 ^ 26 := by
      rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
      exact Nat.mod_eq_of_lt (by omega)
    rw [h1, h2]
    omega
  rw [nat_eq, Limbs.nat]
  simp only [pack_even, pack_odd]
  rw [← key _ (h 0), ← key _ (h 1), ← key _ (h 2), ← key _ (h 3), ← key _ (h 4)]
  ring

/-! ## `2 p` -/

/-- `(2p, 2p, 2p, 2p)` is `2 p` in each element. -/
public theorem nat_p2 (e : Fin 4) : nat p2 e = 2 * p := by
  rw [nat_eq]
  fin_cases e <;> decide

/-! ## `reduce` -/

/-- `reduce`'s carry chain keeps the value: each limb keeps its low 26 (even) or 25 (odd) bits
and takes the previous limb's carry; limb 0 takes 19 times limb 9's. -/
public theorem reduce_val (x₀ x₁ x₂ x₃ x₄ x₅ x₆ x₇ x₈ x₉ : ℕ) :
    (((x₀ % 2 ^ 26 + 19 * (x₉ / 2 ^ 25) : ℕ) : ZMod p) + (x₁ % 2 ^ 25 + x₀ / 2 ^ 26 : ℕ) * 2 ^ 26 +
        (x₂ % 2 ^ 26 + x₁ / 2 ^ 25 : ℕ) * 2 ^ 51 +
        (x₃ % 2 ^ 25 + x₂ / 2 ^ 26 : ℕ) * 2 ^ 77 +
        (x₄ % 2 ^ 26 + x₃ / 2 ^ 25 : ℕ) * 2 ^ 102 +
        (x₅ % 2 ^ 25 + x₄ / 2 ^ 26 : ℕ) * 2 ^ 128 +
        (x₆ % 2 ^ 26 + x₅ / 2 ^ 25 : ℕ) * 2 ^ 153 +
        (x₇ % 2 ^ 25 + x₆ / 2 ^ 26 : ℕ) * 2 ^ 179 +
        (x₈ % 2 ^ 26 + x₇ / 2 ^ 25 : ℕ) * 2 ^ 204 +
        (x₉ % 2 ^ 25 + x₈ / 2 ^ 26 : ℕ) * 2 ^ 230) =
      x₀ + x₁ * 2 ^ 26 + x₂ * 2 ^ 51 + x₃ * 2 ^ 77 + x₄ * 2 ^ 102 + x₅ * 2 ^ 128 + x₆ * 2 ^ 153 +
        x₇ * 2 ^ 179 +
        x₈ * 2 ^ 204 +
        x₉ * 2 ^ 230 := by
  have e (x w : ℕ) : ((x % 2 ^ w : ℕ) : ZMod p) + 2 ^ w * (x / 2 ^ w : ℕ) = x := by
    exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ w))
  push_cast
  linear_combination
    e x₀ 26 + 2 ^ 26 * e x₁ 25 + 2 ^ 51 * e x₂ 26 + 2 ^ 77 * e x₃ 25 + 2 ^ 102 * e x₄ 26 +
        2 ^ 128 * e x₅ 25 +
        2 ^ 153 * e x₆ 26 +
        2 ^ 179 * e x₇ 25 +
        2 ^ 204 * e x₈ 26 +
        2 ^ 230 * e x₉ 25 -
      ((x₉ / 2 ^ 25 : ℕ) : ZMod p) * two_pow_255

end Fe2625x4

end MLIR.Agave

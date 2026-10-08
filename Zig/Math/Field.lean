module

public import Ed25519.Limbs
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_neg
public import Zig.Fe_mul
public import Zig.Fe_sq
public import Zig.Fe_sqn
public import Zig.Fe_reduce
public import Zig.Fe_isZero
public import Zig.Fe_cMov
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! Zig's field arithmetic in `ZMod p`: each spec computes its field operation on the limbs'
values, under the limb bounds the program proofs assume. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

/-! ## Carrying columns -/

/-- `_carry128` keeps its columns' value. -/
public theorem Fe.carry128.spec_val {r : Fin 5 → BitVec 128} (h : Fe.carry128.Pre r) :
    Limbs.val (Fe.carry128.spec r) =
      ((r 0).toNat : ZMod p) + (r 1).toNat * 2 ^ 51 + (r 2).toNat * 2 ^ 102 +
        (r 3).toNat * 2 ^ 153 +
        (r 4).toNat * 2 ^ 204 := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := h
  rw [Limbs.val_eq]
  dsimp only [Fe.carry128.spec, Fe.carry128.wide, Fe.mask]
  generalize hw1 : r 1 + r 0 >>> 51 = w1
  generalize hw2 : r 2 + w1 >>> 51 = w2
  generalize hw3 : r 3 + w2 >>> 51 = w3
  generalize hw4 : r 4 + w3 >>> 51 = w4
  have b0 : (r 0).toNat < 2 ^ 115 := by omega
  have k1 : w1.toNat = (r 1).toNat + (r 0).toNat / 2 ^ 51 := hw1 ▸ toNat_add_shr51 h1 b0
  have b1 : w1.toNat < 2 ^ 115 := hw1 ▸ add_shr51_lt h1 b0
  have k2 : w2.toNat = (r 2).toNat + w1.toNat / 2 ^ 51 := hw2 ▸ toNat_add_shr51 h2 b1
  have b2 : w2.toNat < 2 ^ 115 := hw2 ▸ add_shr51_lt h2 b1
  have k3 : w3.toNat = (r 3).toNat + w2.toNat / 2 ^ 51 := hw3 ▸ toNat_add_shr51 h3 b2
  have b3 : w3.toNat < 2 ^ 115 := hw3 ▸ add_shr51_lt h3 b2
  have h4' : (r 4).toNat < 2 ^ 115 - 2 ^ 64 := by omega
  have k4 : w4.toNat = (r 4).toNat + w3.toNat / 2 ^ 51 := hw4 ▸ toNat_add_shr51 h4' b3
  have b4 : w4.toNat < 3 * 2 ^ 109 + 2 ^ 64 := by omega
  generalize hu0 :
    BitVec.setWidth 64 (w4 >>> 51) * 19#64 + (BitVec.setWidth 64 (r 0) &&& 2251799813685247#64) = u0
  generalize hu1 : u0 >>> 51 + (BitVec.setWidth 64 w1 &&& 2251799813685247#64) = u1
  have ku0 : u0.toNat = w4.toNat / 2 ^ 51 * 19 + (r 0).toNat % 2 ^ 51 := by
    rw [← hu0, BitVec.toNat_add, BitVec.toNat_mul, toNat_top b4, toNat_setWidth_mask,
      show (19#64).toNat = 19 from rfl]
    omega
  have ku1 : u1.toNat = u0.toNat / 2 ^ 51 + w1.toNat % 2 ^ 51 := by
    rw [← hu1, BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  have ko2 :
    (u1 >>> 51 + (BitVec.setWidth 64 w2 &&& 2251799813685247#64)).toNat =
      u1.toNat / 2 ^ 51 + w2.toNat % 2 ^ 51 := by
    rw [BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  simp only [toNat_setWidth_mask]
  simp only [toNat_and_mask, ko2]
  exact carry_val k1 k2 k3 k4 ku0 ku1

/-- `carry128.spec_val` over columns known through `ValLe`. -/
theorem Fe.carry128.spec_valLe {r : Fin 5 → BitVec 128} (h0 : ValLe (r 0) n0 M0)
    (h1 : ValLe (r 1) n1 M1) (h2 : ValLe (r 2) n2 M2) (h3 : ValLe (r 3) n3 M3)
    (h4 : ValLe (r 4) n4 M4)
    (hM :
      M0 < 2 ^ 115 - 2 ^ 64 ∧
        M1 < 2 ^ 115 - 2 ^ 64 ∧ M2 < 2 ^ 115 - 2 ^ 64 ∧ M3 < 2 ^ 115 - 2 ^ 64 ∧ M4 < 3 * 2 ^ 109)
    (hv : (n0 : ZMod p) + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204 = v) :
    Limbs.val (Fe.carry128.spec r) = v := by
  obtain ⟨e0, h0⟩ := h0
  obtain ⟨e1, h1⟩ := h1
  obtain ⟨e2, h2⟩ := h2
  obtain ⟨e3, h3⟩ := h3
  obtain ⟨e4, h4⟩ := h4
  rw [Fe.carry128.spec_val ⟨by omega, by omega, by omega, by omega, by omega⟩, e0, e1, e2, e3, e4,
    hv]

/-! ## Products -/

/-- `mul` multiplies, for limbs below `2^54`. -/
public theorem Fe.mul.spec_val {a b : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54))
    (hb : Fe.Lt b (2 ^ 54)) : Limbs.val (Fe.mul.spec a b) = Limbs.val a * Limbs.val b := by
  have hA i : ValLe (a i) (a i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := ha i; omega⟩
  have hB i : ValLe (b i) (b i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := hb i; omega⟩
  rw [Fe.mul.spec]
  apply Fe.carry128.spec_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq, Limbs.val_eq]
    simp only [show (19#128).toNat = 19 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    generalize ((b 0).toNat : ZMod p) = b0
    generalize ((b 1).toNat : ZMod p) = b1
    generalize ((b 2).toNat : ZMod p) = b2
    generalize ((b 3).toNat : ZMod p) = b3
    generalize ((b 4).toNat : ZMod p) = b4
    linear_combination
      -(a1 * b4 + a2 * b3 + a3 * b2 + a4 * b1 + (a2 * b4 + a3 * b3 + a4 * b2) * 2 ^ 51 +
            (a3 * b4 + a4 * b3) * 2 ^ 102 +
            a4 * b4 * 2 ^ 153) *
        two_pow_255

/-- `sq` squares, for limbs below `2^54`. -/
public theorem Fe.sq.spec_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
    Limbs.val (Fe.sq.spec a) = Limbs.val a ^ 2 := by
  have hA i : ValLe (a i) (a i).toNat (2 ^ 54 - 1) :=
    ⟨rfl, by
      have := ha i; omega⟩
  rw [Fe.sq.spec]
  apply Fe.carry128.spec_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19#128).toNat = 19 from rfl, show (38#128).toNat = 38 from rfl,
      show (2#128).toNat = 2 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    linear_combination
      -(2 * a1 * a4 + 2 * a2 * a3 + (2 * a2 * a4 + a3 ^ 2) * 2 ^ 51 + 2 * a3 * a4 * 2 ^ 102 +
            a4 ^ 2 * 2 ^ 153) *
        two_pow_255

/-- `sqn n` raises to `2^n`, for limbs below `2^54`. -/
public theorem Fe.sqn.spec_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) (n : ℕ) :
    Limbs.val (Fe.sqn.spec n a) = Limbs.val a ^ 2 ^ n := by
  induction n generalizing a with
  | zero => simp [Fe.sqn.spec]
  | succ n ih =>
    rw [Fe.sqn.spec, ih ((Fe.sq.spec_lt a).mono (by norm_num)), Fe.sq.spec_val ha, ← pow_mul,
      pow_succ']

/-- `sqn`'s limbs stay below `2^54`. -/
public theorem Fe.sqn.spec_lt {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) (n : ℕ) :
    Fe.Lt (Fe.sqn.spec n a) (2 ^ 54) := by
  induction n generalizing a with
  | zero => exact ha
  | succ n ih => exact ih ((Fe.sq.spec_lt a).mono (by norm_num))

/-! ## Sums and differences -/

/-- A limb of `a + b` without wrap. -/
theorem Fe.add.spec_toNat {a b : Fin 5 → BitVec 64} {A B : ℕ} (ha : Fe.Lt a A) (hb : Fe.Lt b B)
    (h : A + B ≤ 2 ^ 64) (k : Fin 5) : (Fe.add.spec a b k).toNat = (a k).toNat + (b k).toNat := by
  have := ha k
  have := hb k
  rw [Fe.add.spec, BitVec.toNat_add]
  omega

/-- `add` adds the limbs' numbers, for limb bounds summing to at most `2^64`. -/
public theorem Fe.add.spec_nat {a b : Fin 5 → BitVec 64} {A B : ℕ} (ha : Fe.Lt a A) (hb : Fe.Lt b B)
    (h : A + B ≤ 2 ^ 64) : Limbs.nat (Fe.add.spec a b) = Limbs.nat a + Limbs.nat b := by
  simp only [Limbs.nat, Fe.add.spec_toNat ha hb h]
  ring

/-- `add` adds, for limb bounds summing to at most `2^64`. -/
public theorem Fe.add.spec_val {a b : Fin 5 → BitVec 64} {A B : ℕ} (ha : Fe.Lt a A) (hb : Fe.Lt b B)
    (h : A + B ≤ 2 ^ 64) : Limbs.val (Fe.add.spec a b) = Limbs.val a + Limbs.val b := by
  rw [Limbs.val_nat, Limbs.val_nat, Limbs.val_nat, Fe.add.spec_nat ha hb h, Nat.cast_add]

/-- `x + K - y` without wrap. -/
theorem sub_limb_toNat {x y K : BitVec 64} (hx : x.toNat < 2 ^ 63) (hy : y.toNat ≤ K.toNat)
    (hK : K.toNat < 2 ^ 63) : (x + K - y).toNat + y.toNat = x.toNat + K.toNat := by
  rw [BitVec.toNat_sub, BitVec.toNat_add]
  omega

/-- `sub`'s limbs and numbers: `a + 2p` minus `b` carried once, whose top carry `q` folds back as
`19`. -/
theorem Fe.sub.spec_nat {a b : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) (hb : Fe.Lt b (2 ^ 63)) :
    ∃ q,
      Limbs.nat (Fe.sub.spec a b) + Limbs.nat b + 19 * q = Limbs.nat a + 2 * p + 2 ^ 255 * q ∧
        ∀ i, (Fe.sub.spec a b i).toNat ≤ (a i).toNat + 4503599627370494 := by
  have a0 := ha 0
  have a1 := ha 1
  have a2 := ha 2
  have a3 := ha 3
  have a4 := ha 4
  have b0 := hb 0
  have b1 := hb 1
  have b2 := hb 2
  have b3 := hb 3
  have b4 := hb 4
  have hs (i : Fin 5) : Fe.sub.spec a b i = Fe.sub.spec a b i := rfl
  have s0 := hs 0
  have s1 := hs 1
  have s2 := hs 2
  have s3 := hs 3
  have s4 := hs 4
  conv at s0 =>
    rhs; dsimp only [Fe.sub.spec, Fe.mask]
  conv at s1 =>
    rhs; dsimp only [Fe.sub.spec, Fe.mask]
  conv at s2 =>
    rhs; dsimp only [Fe.sub.spec, Fe.mask]
  conv at s3 =>
    rhs; dsimp only [Fe.sub.spec, Fe.mask]
  conv at s4 =>
    rhs; dsimp only [Fe.sub.spec, Fe.mask]
  generalize hB1 : b 1 + b 0 >>> 51 = B1 at s0 s1 s2 s3 s4
  generalize hB2 : B1 >>> 51 + b 2 = B2 at s0 s1 s2 s3 s4
  generalize hB3 : B2 >>> 51 + b 3 = B3 at s0 s1 s2 s3 s4
  generalize hB4 : B3 >>> 51 + b 4 = B4 at s0 s1 s2 s3 s4
  generalize hC0 : (b 0 &&& 2251799813685247#64) + 19#64 * (B4 >>> 51) = C0 at s0
  have k1 : B1.toNat = (b 1).toNat + (b 0).toNat / 2 ^ 51 := by
    rw [← hB1, BitVec.toNat_add, toNat_shift]; omega
  have k2 : B2.toNat = B1.toNat / 2 ^ 51 + (b 2).toNat := by
    rw [← hB2, BitVec.toNat_add, toNat_shift]; omega
  have k3 : B3.toNat = B2.toNat / 2 ^ 51 + (b 3).toNat := by
    rw [← hB3, BitVec.toNat_add, toNat_shift]; omega
  have k4 : B4.toNat = B3.toNat / 2 ^ 51 + (b 4).toNat := by
    rw [← hB4, BitVec.toNat_add, toNat_shift]; omega
  have kc : C0.toNat = (b 0).toNat % 2 ^ 51 + 19 * (B4.toNat / 2 ^ 51) := by
    rw [← hC0, BitVec.toNat_add, BitVec.toNat_mul, toNat_and_mask, toNat_shift,
      show (19#64).toNat = 19 from rfl]
    omega
  have K0 : (4503599627370458#64).toNat = 4503599627370458 := rfl
  have K1 : (4503599627370494#64).toNat = 4503599627370494 := rfl
  have e0 :=
    sub_limb_toNat (x := a 0) (y := C0) (K := 4503599627370458#64) a0
      (by
        rw [K0, kc]; omega)
      (by
        rw [K0]; omega)
  have e1 :=
    sub_limb_toNat (x := a 1) (y := B1 &&& 2251799813685247#64) (K := 4503599627370494#64) a1
      (by
        rw [K1, toNat_and_mask]; omega)
      (by
        rw [K1]; omega)
  have e2 :=
    sub_limb_toNat (x := a 2) (y := B2 &&& 2251799813685247#64) (K := 4503599627370494#64) a2
      (by
        rw [K1, toNat_and_mask]; omega)
      (by
        rw [K1]; omega)
  have e3 :=
    sub_limb_toNat (x := a 3) (y := B3 &&& 2251799813685247#64) (K := 4503599627370494#64) a3
      (by
        rw [K1, toNat_and_mask]; omega)
      (by
        rw [K1]; omega)
  have e4 :=
    sub_limb_toNat (x := a 4) (y := B4 &&& 2251799813685247#64) (K := 4503599627370494#64) a4
      (by
        rw [K1, toNat_and_mask]; omega)
      (by
        rw [K1]; omega)
  rw [← s0] at e0
  rw [← s1] at e1
  rw [← s2] at e2
  rw [← s3] at e3
  rw [← s4] at e4
  rw [K0, kc] at e0
  rw [K1, toNat_and_mask] at e1 e2 e3 e4
  refine ⟨B4.toNat / 2 ^ 51, ?_, fun i => ?_⟩
  · unfold Limbs.nat
    change _ = _ + 2 * (2 ^ 255 - 19) + _
    omega
  · fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega

/-- `sub` subtracts, for limbs below `2^63`. -/
public theorem Fe.sub.spec_val {a b : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63))
    (hb : Fe.Lt b (2 ^ 63)) : Limbs.val (Fe.sub.spec a b) = Limbs.val a - Limbs.val b := by
  obtain ⟨q, h, -⟩ := Fe.sub.spec_nat ha hb
  have h' := congrArg (Nat.cast (R := ZMod p)) h
  simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat, ZMod.natCast_self, mul_zero,
    add_zero, two_pow_255] at h'
  rw [Limbs.val_nat, Limbs.val_nat, Limbs.val_nat]
  linear_combination h'

/-- `neg` negates, for limbs below `2^63`. -/
public theorem Fe.neg.spec_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Limbs.val (Fe.neg.spec a) = -Limbs.val a := by
  have h0 : Limbs.val (fun _ => 0#64) = 0 := by simp [Limbs.val_eq]
  rw [Fe.neg.spec, Fe.sub.spec_val (fun _ => by simp) ha, h0, zero_sub]

/-- `neg`'s limbs are below `2^52`. -/
public theorem Fe.neg.spec_lt {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Fe.Lt (Fe.neg.spec a) (2 ^ 52) := by
  obtain ⟨-, -, h⟩ := Fe.sub.spec_nat (a := fun _ => 0#64) (fun _ => by simp) ha
  intro i
  have := h i
  simp only [BitVec.toNat_ofNat, Nat.zero_mod, zero_add] at this
  rw [Fe.neg.spec]
  omega

/-! ## Reduction -/

/-- `reduce`'s carry pass keeps the number, limbs `0 … 3` below `2^51`. -/
theorem Fe.reduce.carry_nat {l : Fin 5 → BitVec 64} (hl : Fe.Lt l (2 ^ 63)) :
    Limbs.nat (Fe.reduce.carry l) = Limbs.nat l ∧
      (Fe.reduce.carry l 0).toNat < 2 ^ 51 ∧
      (Fe.reduce.carry l 1).toNat < 2 ^ 51 ∧
      (Fe.reduce.carry l 2).toNat < 2 ^ 51 ∧ (Fe.reduce.carry l 3).toNat < 2 ^ 51 := by
  have l0 := hl 0
  have l1 := hl 1
  have l2 := hl 2
  have l3 := hl 3
  have l4 := hl 4
  unfold Limbs.nat
  dsimp only [Fe.reduce.carry, Fe.mask]
  generalize hL1 : l 1 + l 0 >>> 51 = L1
  generalize hL2 : l 2 + L1 >>> 51 = L2
  generalize hL3 : l 3 + L2 >>> 51 = L3
  generalize hL4 : l 4 + L3 >>> 51 = L4
  have k1 : L1.toNat = (l 1).toNat + (l 0).toNat / 2 ^ 51 := by
    rw [← hL1, BitVec.toNat_add, toNat_shift]; omega
  have k2 : L2.toNat = (l 2).toNat + L1.toNat / 2 ^ 51 := by
    rw [← hL2, BitVec.toNat_add, toNat_shift]; omega
  have k3 : L3.toNat = (l 3).toNat + L2.toNat / 2 ^ 51 := by
    rw [← hL3, BitVec.toNat_add, toNat_shift]; omega
  have k4 : L4.toNat = (l 4).toNat + L3.toNat / 2 ^ 51 := by
    rw [← hL4, BitVec.toNat_add, toNat_shift]; omega
  simp only [toNat_and_mask]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- `reduce`'s wrap: the top carry times 19 into limb 0. -/
theorem Fe.reduce.wrap_toNat {l : Fin 5 → BitVec 64} (h0 : (l 0).toNat < 2 ^ 63) :
    (Fe.reduce.wrap l 0).toNat = (l 0).toNat + 19 * ((l 4).toNat / 2 ^ 51) ∧
      (Fe.reduce.wrap l 1).toNat = (l 1).toNat ∧
      (Fe.reduce.wrap l 2).toNat = (l 2).toNat ∧
      (Fe.reduce.wrap l 3).toNat = (l 3).toNat ∧
      (Fe.reduce.wrap l 4).toNat = (l 4).toNat % 2 ^ 51 := by
  refine ⟨?_, rfl, rfl, rfl, toNat_and_mask _⟩
  change (l 0 + 19#64 * (l 4 >>> 51)).toNat = _
  have := (l 4).isLt
  rw [BitVec.toNat_add, BitVec.toNat_mul, toNat_shift, show (19#64).toNat = 19 from rfl]
  omega

/-- A carry and a wrap: limbs `1 … 4` below `2^51`, the number less `p` times the top carry. -/
theorem Fe.reduce.carry_wrap {l : Fin 5 → BitVec 64} (hl : Fe.Lt l (2 ^ 63)) :
    let w := Fe.reduce.wrap (Fe.reduce.carry l)
    Limbs.nat w + p * (Limbs.nat l / 2 ^ 255) = Limbs.nat l ∧
      (w 0).toNat < 2 ^ 51 + 19 * (Limbs.nat l / 2 ^ 255) ∧
      (w 1).toNat < 2 ^ 51 ∧
      (w 2).toNat < 2 ^ 51 ∧ (w 3).toNat < 2 ^ 51 ∧ (w 4).toNat < 2 ^ 51 := by
  obtain ⟨n, c0, c1, c2, c3⟩ := Fe.reduce.carry_nat hl
  obtain ⟨w0, w1, w2, w3, w4⟩ := Fe.reduce.wrap_toNat (l := Fe.reduce.carry l) (by omega)
  intro w
  rw [← n]
  unfold Limbs.nat
  change _ + (2 ^ 255 - 19) * _ = _ ∧ _
  rw [w0, w1, w2, w3, w4]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- The last pass's arithmetic: `+ 19`, a wrap, `+ p`, and `2^255` dropped leave `N` mod `p`. -/
theorem Fe.reduce.final {NB NC N : ℕ} (hC : NC + (2 ^ 255 - 19) * (NB / 2 ^ 255) = N + 2 ^ 255)
    (hNB : NB = N + 19) (hNB2 : NB / 2 ^ 255 ≤ 1) (hN : N < 2 ^ 255 + 19) :
    NC % 2 ^ 255 + (2 ^ 255 - 19) * (NB / 2 ^ 255) = N ∧ NC % 2 ^ 255 < 2 ^ 255 - 19 := by
  obtain h | h : NB / 2 ^ 255 = 0 ∨ NB / 2 ^ 255 = 1 := by omega
  · rw [h] at hC
    have : NC = N + 2 ^ 255 := by omega
    rw [this, h, Nat.add_mod_right, Nat.mod_eq_of_lt (by omega)]
    omega
  · rw [h] at hC
    have : NC = N + 19 := by omega
    rw [this, h, Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]
    omega

/-- `reduce` gives the canonical limbs, for limbs below `2^63`. -/
public theorem Fe.reduce.spec_nat {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Limbs.nat (Fe.reduce.spec a) = Limbs.nat a % p ∧ Fe.Lt (Fe.reduce.spec a) (2 ^ 51) := by
  dsimp only [Fe.reduce.spec]
  -- two passes
  obtain ⟨n1, x0, x1, x2, x3, x4⟩ := Fe.reduce.carry_wrap ha
  generalize Fe.reduce.wrap (Fe.reduce.carry a) = W1 at *
  have hp : p = 2 ^ 255 - 19 := rfl
  have hNa : Limbs.nat a / 2 ^ 255 < 2 ^ 14 := by
    have := ha 0; have := ha 1; have := ha 2; have := ha 3; have := ha 4
    unfold Limbs.nat; omega
  have hW1 : Fe.Lt W1 (2 ^ 63) := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega
  obtain ⟨n2, y0, y1, y2, y3, y4⟩ := Fe.reduce.carry_wrap hW1
  generalize Fe.reduce.wrap (Fe.reduce.carry W1) = W2 at *
  have hN1 : Limbs.nat W1 / 2 ^ 255 ≤ 1 := by
    unfold Limbs.nat; omega
  -- `+ 19` and a third pass: the top carry is `1` exactly when the number is at least `p`
  generalize hB : (fun i : Fin 5 => if i = 0 then W2 0 + 19#64 else W2 i) = B
  have hB0 : (B 0).toNat = (W2 0).toNat + 19 := by
    rw [← hB]; dsimp only
    simp only [↓reduceIte]
    rw [BitVec.toNat_add, show (19#64).toNat = 19 from rfl]
    omega
  have hBi (i : Fin 5) (hi : i ≠ 0) : B i = W2 i := by
    rw [← hB]; simp only [hi, ↓reduceIte]
  have hNB : Limbs.nat B = Limbs.nat W2 + 19 := by
    unfold Limbs.nat
    rw [hB0, hBi 1 (by decide), hBi 2 (by decide), hBi 3 (by decide), hBi 4 (by decide)]
    omega
  have hBl : Fe.Lt B (2 ^ 63) := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk]
    · omega
    all_goals rw [hBi _ (by decide)]; omega
  obtain ⟨n3, z0, z1, z2, z3, z4⟩ := Fe.reduce.carry_wrap hBl
  generalize Fe.reduce.wrap (Fe.reduce.carry B) = W3 at *
  have hNW2 : Limbs.nat W2 < 2 ^ 255 + 19 := by
    unfold Limbs.nat; omega
  -- `+ p`, a last carry, and `2^255` dropped
  generalize hD :
    (fun i : Fin 5 => if i = 0 then W3 0 + 0x7ffffffffffed#64 else W3 i + 0x7ffffffffffff#64) = D
  have hD0 : (D 0).toNat = (W3 0).toNat + 0x7ffffffffffed := by
    rw [← hD]; dsimp only
    simp only [↓reduceIte]
    rw [BitVec.toNat_add, show (0x7ffffffffffed#64).toNat = 0x7ffffffffffed from rfl]
    omega
  have hDi (i : Fin 5) (hi : i ≠ 0) (h : (W3 i).toNat < 2 ^ 51) :
    (D i).toNat = (W3 i).toNat + 0x7ffffffffffff := by
    rw [← hD]; dsimp only
    simp only [hi, ↓reduceIte]
    rw [BitVec.toNat_add, show (0x7ffffffffffff#64).toNat = 0x7ffffffffffff from rfl]
    omega
  have hNB2 : Limbs.nat B / 2 ^ 255 ≤ 1 := by omega
  have d1 := hDi 1 (by decide) z1
  have d2 := hDi 2 (by decide) z2
  have d3 := hDi 3 (by decide) z3
  have d4 := hDi 4 (by decide) z4
  have hND : Limbs.nat D = Limbs.nat W3 + p := by
    unfold Limbs.nat
    rw [hD0, d1, d2, d3, d4]
    omega
  have hDl : Fe.Lt D (2 ^ 63) := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega
  obtain ⟨n4, e0, e1, e2, e3⟩ := Fe.reduce.carry_nat hDl
  generalize Fe.reduce.carry D = C at *
  generalize hR : (fun i : Fin 5 => if i = 4 then C 4 &&& Fe.mask else C i) = R
  have r4 : (R 4).toNat = (C 4).toNat % 2 ^ 51 := by
    rw [← hR]; dsimp only
    simp only [↓reduceIte]
    rw [toNat_and_mask]
  have ri (i : Fin 5) (hi : i ≠ 4) : R i = C i := by
    rw [← hR]; simp only [hi, ↓reduceIte]
  have hNR : Limbs.nat R = Limbs.nat C % 2 ^ 255 := by
    unfold Limbs.nat
    rw [r4, ri 0 (by decide), ri 1 (by decide), ri 2 (by decide), ri 3 (by decide)]
    omega
  refine ⟨?_, fun i => ?_⟩
  · rw [hp] at n1 n2 n3 hND ⊢
    have h3 :
      Limbs.nat R + (2 ^ 255 - 19) * (Limbs.nat B / 2 ^ 255) = Limbs.nat W2 ∧
        Limbs.nat R < 2 ^ 255 - 19 := by
      rw [hNR]
      refine Fe.reduce.final ?_ hNB hNB2 hNW2
      clear * - n4 hND n3 hNB
      omega
    have :
      Limbs.nat a =
        Limbs.nat R +
          (2 ^ 255 - 19) *
            (Limbs.nat B / 2 ^ 255 + Limbs.nat W1 / 2 ^ 255 + Limbs.nat a / 2 ^ 255) := by
      have h3' := h3.1
      clear * - n1 n2 h3'
      generalize Limbs.nat B / 2 ^ 255 = q3 at *
      generalize Limbs.nat W1 / 2 ^ 255 = q2 at *
      generalize Limbs.nat a / 2 ^ 255 = q1 at *
      rw [← n1, ← n2, ← h3']
      ring
    rw [this, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt h3.2]
  · fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk]
    · rw [ri 0 (by decide)]; exact e0
    · rw [ri 1 (by decide)]; exact e1
    · rw [ri 2 (by decide)]; exact e2
    · rw [ri 3 (by decide)]; exact e3
    · rw [r4]; omega

/-- `reduce` keeps the value. -/
public theorem Fe.reduce.spec_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Limbs.val (Fe.reduce.spec a) = Limbs.val a := by
  rw [Limbs.val_nat, Limbs.val_nat, (Fe.reduce.spec_nat ha).1, ZMod.natCast_mod]

/-- `reduce`'s number is the value's representative in `[0, p)`. -/
public theorem Fe.reduce.spec_nat_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Limbs.nat (Fe.reduce.spec a) = (Limbs.val a).val := by
  rw [Limbs.val_nat, ZMod.val_natCast, (Fe.reduce.spec_nat ha).1]

/-! ## Tests and selection -/

/-- `isZero` tests the value against zero, for limbs below `2^63`. -/
public theorem Fe.isZero.spec_eq {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 63)) :
    Fe.isZero.spec a = BitVec.ofBool (decide (Limbs.val a = 0)) := by
  have hor (x0 x1 x2 x3 x4 : BitVec 64) :
    x1 ||| x0 ||| x2 ||| x3 ||| x4 = 0#64 ↔
      x0 = 0#64 ∧ x1 = 0#64 ∧ x2 = 0#64 ∧ x3 = 0#64 ∧ x4 = 0#64 := by
    simp only [BitVec.or_eq_zero_iff, and_assoc]
    exact ⟨fun ⟨a, b, c⟩ => ⟨b, a, c⟩, fun ⟨a, b, c⟩ => ⟨b, a, c⟩⟩
  have hn := Fe.reduce.spec_nat_val ha
  simp only [Fe.isZero.spec]
  congr 1
  rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, hor, ← ZMod.val_eq_zero, ← hn]
  generalize Fe.reduce.spec a = r
  simp only [Limbs.nat, BitVec.toNat_eq, BitVec.toNat_ofNat, Nat.zero_mod]
  omega

/-- `cMov` selects the value, for a `0`/`1` condition. -/
public theorem Fe.cMov.spec_val {fe a : Fin 5 → BitVec 64} {c : BitVec 64} (hc : c.toNat < 2) :
    Limbs.val (Fe.cMov.spec fe a c) = if c = 1#64 then Limbs.val a else Limbs.val fe := by
  rw [Fe.cMov.spec_eq fe a c hc]
  split <;> rfl

end LeanMLIR.RIR.Zig

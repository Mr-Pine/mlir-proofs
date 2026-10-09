module

public import Firedancer.Math.Field
public import Firedancer.Avx512.Common.R43x6
public import Firedancer.Avx512.Common.FoldUnsigned
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! The value in `ZMod p` of an `fd_r43x6_t` (six radix-`2^43` limbs in lanes `0 … 5` of a `wwl_t`),
the C's limb range classes, and the value and ranges of the fast add, sub and neg and of the
folds. -/

namespace MLIR.Firedancer.Avx512

open MLIR.Firedancer.Ref (p)

/-! ## Definitions -/

@[expose] public section

namespace R43x6

/-- The integer of an `fd_r43x6_t`: lane `i < 6`, as a long, weighs `2^(43 i)`. -/
def int (x : Wwl) : ℤ :=
  x[0].toInt + x[1].toInt * (2 : ℤ) ^ 43 + x[2].toInt * (2 : ℤ) ^ 86 +
    x[3].toInt * (2 : ℤ) ^ 129 + x[4].toInt * (2 : ℤ) ^ 172 + x[5].toInt * (2 : ℤ) ^ 215

/-- The integer of an `fd_r43x6_t` read with unsigned lanes. -/
def nat (x : Wwl) : ℕ :=
  x[0].toNat + x[1].toNat * 2 ^ 43 + x[2].toNat * 2 ^ 86 + x[3].toNat * 2 ^ 129 +
    x[4].toNat * 2 ^ 172 + x[5].toNat * 2 ^ 215

/-- The field element an `fd_r43x6_t` represents. -/
def val (x : Wwl) : ZMod p :=
  (int x : ZMod p)

/-- Limbs in `[0, 2^n)`: the C's `un`; `unsigned` is `u62`, `unreduced` `u47`. -/
abbrev Unsigned (n : ℕ) (x : Wwl) : Prop :=
  ∀ i : Fin 6, x[(i : ℕ)].toNat < 2 ^ n

/-- Limbs in `[-2^n, 2^n)` as longs: the C's `signed` for `n = 62`. -/
abbrev Signed (n : ℕ) (x : Wwl) : Prop :=
  ∀ i : Fin 6, -(2 : ℤ) ^ n ≤ x[(i : ℕ)].toInt ∧ x[(i : ℕ)].toInt < 2 ^ n

/-- Lanes 6 and 7 zero. -/
abbrev HighZero (x : Wwl) : Prop :=
  x[6] = 0 ∧ x[7] = 0

/-- The C's `unreduced`, with lanes 6 and 7 zero: the inputs of `mul`, `sqr`, `pow22523`. -/
abbrev Unreduced (x : Wwl) : Prop :=
  Unsigned 47 x ∧ HighZero x

/-- The ranges `fd_r43x6_fold_signed` (and `fold_unsigned`) produce: limb 0 in
`[0, 2^43 + 19 (2^24 - 1))`, limbs 1-4 in `[0, 2^43 + 2^21 - 1)`, limb 5 in
`[0, 2^40 + 2^21 - 1)`, lanes 6 and 7 zero. -/
abbrev Folded (x : Wwl) : Prop :=
  x[0].toNat < 2 ^ 43 + 19 * (2 ^ 24 - 1) ∧ x[1].toNat < 2 ^ 43 + 2 ^ 21 - 1 ∧
    x[2].toNat < 2 ^ 43 + 2 ^ 21 - 1 ∧ x[3].toNat < 2 ^ 43 + 2 ^ 21 - 1 ∧
    x[4].toNat < 2 ^ 43 + 2 ^ 21 - 1 ∧ x[5].toNat < 2 ^ 40 + 2 ^ 21 - 1 ∧ HighZero x

/-- The C's `unpacked`: limbs 0-4 in `[0, 2^43)`, limb 5 in `[0, 2^41)`, lanes 6 and 7 zero. -/
abbrev Unpacked (x : Wwl) : Prop :=
  x[0].toNat < 2 ^ 43 ∧ x[1].toNat < 2 ^ 43 ∧ x[2].toNat < 2 ^ 43 ∧ x[3].toNat < 2 ^ 43 ∧
    x[4].toNat < 2 ^ 43 ∧ x[5].toNat < 2 ^ 41 ∧ HighZero x

/-- The C's `nearly reduced`: unpacked, the packed value in `[0, 2p)`. -/
abbrev NearlyReduced (x : Wwl) : Prop :=
  Unpacked x ∧ nat x < 2 * p

/-- The C's `reduced`: unpacked with limb 5 in `[0, 2^40)`, the packed value in `[0, p)`. -/
abbrev Reduced (x : Wwl) : Prop :=
  Unpacked x ∧ x[5].toNat < 2 ^ 40 ∧ nat x < p

end R43x6

/-- `fd_r43x6_fold_signed`'s operand as `fold`'s: lane `i` plus `2^63 - _b_i`. -/
def foldSignedBias (x : Wwl) : Wwl :=
  wwl_add x (wwl 0x7FFFFFFFF6800000 0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000
    0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000 0 0)

end

/-! ## Lanes -/

namespace R43x6

/-- `p + 19 = 2^255`. -/
public theorem p_add : p + 19 = 2 ^ 255 := by
  decide

/-- `p` as an integer. -/
public theorem p_int : (p : ℤ) = 2 ^ 255 - 19 := by
  have := p_add
  omega

/-- A long sum that does not overflow. -/
public theorem toInt_add' {a b : BitVec 64} (h1 : -(2 : ℤ) ^ 63 ≤ a.toInt + b.toInt)
    (h2 : a.toInt + b.toInt < 2 ^ 63) : (a + b).toInt = a.toInt + b.toInt :=
  BitVec.toInt_add_of_not_saddOverflow (by simp [BitVec.saddOverflow]; omega)

/-- A long difference that does not overflow. -/
public theorem toInt_sub' {a b : BitVec 64} (h1 : -(2 : ℤ) ^ 63 ≤ a.toInt - b.toInt)
    (h2 : a.toInt - b.toInt < 2 ^ 63) : (a - b).toInt = a.toInt - b.toInt :=
  BitVec.toInt_sub_of_not_ssubOverflow (by simp [BitVec.ssubOverflow]; omega)

/-- A long below `2^63` is its unsigned value. -/
public theorem toInt_of_lt {a : BitVec 64} (h : a.toNat < 2 ^ 63) : a.toInt = a.toNat :=
  BitVec.toInt_eq_toNat_of_lt (by omega)

/-- A long is in `[-2^63, 2^63)`. -/
public theorem toInt_bounds (a : BitVec 64) : -(2 : ℤ) ^ 63 ≤ a.toInt ∧ a.toInt < 2 ^ 63 :=
  ⟨BitVec.le_toInt a, BitVec.toInt_lt⟩

/-- `int` from each lane's long. -/
public theorem int_of_lanes {x : Wwl} {f : Fin 6 → ℤ} (h : ∀ i : Fin 6, x[(i : ℕ)].toInt = f i) :
    int x = f 0 + f 1 * 2 ^ 43 + f 2 * 2 ^ 86 + f 3 * 2 ^ 129 + f 4 * 2 ^ 172 + f 5 * 2 ^ 215 := by
  have h0 : x[0].toInt = f 0 := h 0
  have h1 : x[1].toInt = f 1 := h 1
  have h2 : x[2].toInt = f 2 := h 2
  have h3 : x[3].toInt = f 3 := h 3
  have h4 : x[4].toInt = f 4 := h 4
  have h5 : x[5].toInt = f 5 := h 5
  rw [int, h0, h1, h2, h3, h4, h5]

/-- Unsigned limbs' integer is their unsigned one. -/
public theorem int_eq_nat {x : Wwl} (h : Unsigned 63 x) : int x = nat x := by
  rw [int_of_lanes (f := fun i => (x[(i : ℕ)].toNat : ℤ)) fun i => toInt_of_lt (h i), nat]
  push_cast
  rfl

/-- Unsigned limbs' value is their unsigned integer's. -/
public theorem val_eq_nat {x : Wwl} (h : Unsigned 63 x) : val x = (nat x : ZMod p) := by
  rw [val, int_eq_nat h, Int.cast_natCast]

public theorem Unsigned.mono {x : Wwl} (h : Unsigned m x) (hmn : m ≤ n) : Unsigned n x :=
  fun i => lt_of_lt_of_le (h i) (Nat.pow_le_pow_right (by decide) hmn)

public theorem Signed.mono {x : Wwl} (h : Signed m x) (hmn : m ≤ n) : Signed n x := by
  intro i
  have := (h i)
  have e : (2 : ℤ) ^ m ≤ 2 ^ n := pow_le_pow_right₀ (by decide) hmn
  omega

/-- Unsigned limbs below `2^63` are signed ones. -/
public theorem Unsigned.signed {x : Wwl} (h : Unsigned n x) (hn : n ≤ 63) : Signed n x := by
  intro i
  have := h i
  have e : 2 ^ n ≤ 2 ^ 63 := Nat.pow_le_pow_right (by decide) hn
  rw [toInt_of_lt (by omega)]
  have : ((2 ^ n : ℕ) : ℤ) = 2 ^ n := by push_cast; rfl
  omega

/-- Unsigned limbs below `2^63` are nonnegative longs. -/
public theorem Unsigned.toInt_nonneg {x : Wwl} (h : Unsigned m x) (hm : m ≤ 63) (i : Fin 6) :
    0 ≤ x[(i : ℕ)].toInt := by
  have := h i
  have := Nat.pow_le_pow_right (n := 2) (by decide) hm
  rw [toInt_of_lt (by omega)]
  omega

/-- Folded limbs are `u44`. -/
public theorem Folded.unsigned {x : Wwl} (h : Folded x) : Unsigned 44 x := by
  obtain ⟨h0, h1, h2, h3, h4, h5, -⟩ := h
  intro i; fin_cases i <;> simp <;> omega

/-- Folded limbs are unreduced. -/
public theorem Folded.unreduced {x : Wwl} (h : Folded x) : Unreduced x :=
  ⟨h.unsigned.mono (by decide), h.2.2.2.2.2.2⟩

/-- Unpacked limbs are `u43`. -/
public theorem Unpacked.unsigned {x : Wwl} (h : Unpacked x) : Unsigned 43 x := by
  obtain ⟨h0, h1, h2, h3, h4, h5, -⟩ := h
  intro i; fin_cases i <;> simp <;> omega

end R43x6


-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

/-! ## Lane lemmas

Each `wwl_*` operation's lane `i`, indices read with `?.getD 0` so `simp` can evaluate them. -/

namespace R43x6

public theorem wwl_add_get (x y : Wwl) (i : ℕ) (h : i < 8) : (wwl_add x y)[i] = x[i] + y[i] := by
  simp [wwl_add]

public theorem wwl_sub_get (x y : Wwl) (i : ℕ) (h : i < 8) : (wwl_sub x y)[i] = x[i] - y[i] := by
  simp [wwl_sub]

public theorem wwl_and_get (x y : Wwl) (i : ℕ) (h : i < 8) : (wwl_and x y)[i] = x[i] &&& y[i] := by
  simp [wwl_and]

public theorem wwl_andnot_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_andnot x y)[i] = ~~~x[i] &&& y[i] := by
  simp [wwl_andnot]

public theorem wwl_shl_get (x : Wwl) (n i : ℕ) (h : i < 8) : (wwl_shl x n)[i] = x[i] <<< n := by
  simp [wwl_shl]

public theorem wwl_shl_vector_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_shl_vector x y)[i] = x[i] <<< y[i].toNat := by
  simp [wwl_shl_vector]

public theorem wwl_shr_vector_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_shr_vector x y)[i] = x[i].sshiftRight y[i].toNat := by
  simp [wwl_shr_vector]

public theorem wwl_shru_vector_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_shru_vector x y)[i] = x[i] >>> y[i].toNat := by
  simp [wwl_shru_vector]

public theorem wwl_madd52lo_get (a x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_madd52lo a x y)[i] = a[i] + madd52lo x[i] y[i] := by
  simp [wwl_madd52lo]

public theorem wwl_madd52hi_get (a x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_madd52hi a x y)[i] = a[i] + madd52hi x[i] y[i] := by
  simp [wwl_madd52hi]

public theorem wwl_permute_get (q x : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_permute q x)[i] = x[q[i].toNat % 8]?.getD 0#64 := by
  simp [wwl_permute, Nat.mod_lt _ (show 0 < 8 by decide)]

public theorem wwl_select_get (q x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_select q x y)[i] =
      if q[i].toNat % 16 < 8 then x[q[i].toNat % 16]?.getD 0#64
      else y[q[i].toNat % 16 - 8]?.getD 0#64 := by
  unfold wwl_select
  simp only [Vector.getElem_ofFn]
  split <;> rename_i hj <;> simp only [Fin.getElem_fin] at hj
  · simp [hj]
  · have : q[i].toNat % 16 - 8 < 8 := by omega
    simp [hj, this]

public theorem wwl_slide_get (x y : Wwl) (n i : ℕ) (h : i < 8) :
    (wwl_slide x y n)[i] = if i + n < 8 then x[i + n]?.getD 0#64 else y[i + n - 8]?.getD 0#64 := by
  simp only [wwl_slide, Vector.getElem_ofFn]
  split <;> simp_all

public theorem wwl_pack_halves_get (x : Wwl) (a : ℕ) (y : Wwl) (b i : ℕ) (h : i < 8) :
    (wwl_pack_halves x a y b)[i] =
      if i < 4 then x[(4 * a + i) % 8]?.getD 0#64 else y[(4 * b + i - 4) % 8]?.getD 0#64 := by
  simp only [wwl_pack_halves, Vector.getElem_ofFn]
  split <;> simp [Nat.mod_lt _ (show 0 < 8 by decide)]

public theorem wwl_pack_h0_h1_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_pack_h0_h1 x y)[i] = if i < 4 then x[i] else y[i] := by
  simp [wwl_pack_h0_h1]

public theorem wwv_add_if_get (c : BitVec 8) (x y z : Wwl) (i : ℕ) (h : i < 8) :
    (wwv_add_if c x y z)[i] = if c.getLsbD i then x[i] + y[i] else z[i] := by
  simp [wwv_add_if, BitVec.getElem_eq_testBit_toNat, BitVec.getLsbD_eq_getElem h]

public theorem wwl_get0 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[0] = a0 := by
  simp [wwl]
public theorem wwl_get1 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[1] = a1 := by
  simp [wwl]
public theorem wwl_get2 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[2] = a2 := by
  simp [wwl]
public theorem wwl_get3 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[3] = a3 := by
  simp [wwl]
public theorem wwl_get4 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[4] = a4 := by
  simp [wwl]
public theorem wwl_get5 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[5] = a5 := by
  simp [wwl]
public theorem wwl_get6 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[6] = a6 := by
  simp [wwl]
public theorem wwl_get7 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (wwl a0 a1 a2 a3 a4 a5 a6 a7)[7] = a7 := by
  simp [wwl]

/-- An in-range `?.getD` read. -/
public theorem getD_get (x : Wwl) (i : ℕ) (h : i < 8) : x[i]?.getD 0#64 = x[i] := by
  simp [h]

public theorem wwl_zero_get (i : ℕ) (h : i < 8) : (wwl_zero)[i] = 0 := by
  simp [wwl_zero]

public theorem wwl_bcast_get (a : BitVec 64) (i : ℕ) (h : i < 8) : (wwl_bcast a)[i] = a := by
  simp [wwl_bcast]

end R43x6

/-! ## Folds -/

namespace R43x6

/-- `&&& (2^43 - 1)` on naturals. -/
public theorem and_m43 (n : ℕ) : n &&& 8796093022207 = n % 2 ^ 43 :=
  Nat.and_two_pow_sub_one_eq_mod n 43

/-- `&&& (2^40 - 1)` on naturals. -/
public theorem and_m40 (n : ℕ) : n &&& 1099511627775 = n % 2 ^ 40 :=
  Nat.and_two_pow_sub_one_eq_mod n 40

/-- `&&& (2^52 - 1)` on naturals. -/
public theorem and_m52 (n : ℕ) : n &&& 4503599627370495 = n % 2 ^ 52 :=
  Nat.and_two_pow_sub_one_eq_mod n 52

/-- `fold`'s lanes as `BitVec` terms. -/
public theorem fold_get (u : Vector (BitVec 64) 8) :
    (fold u)[0] = (u[0] &&& 8796093022207#64) + (19#64 * (u[5] >>> 40) &&& 4503599627370495#64) ∧
      (fold u)[1] = (u[1] &&& 8796093022207#64) + (u[0] >>> 43 &&& 4503599627370495#64) ∧
      (fold u)[2] = (u[2] &&& 8796093022207#64) + (u[1] >>> 43 &&& 4503599627370495#64) ∧
      (fold u)[3] = (u[3] &&& 8796093022207#64) + (u[2] >>> 43 &&& 4503599627370495#64) ∧
      (fold u)[4] = (u[4] &&& 8796093022207#64) + (u[3] >>> 43 &&& 4503599627370495#64) ∧
      (fold u)[5] = (u[5] &&& 1099511627775#64) + (u[4] >>> 43 &&& 4503599627370495#64) ∧
      (fold u)[6] = 0 ∧ (fold u)[7] = 0 := by
  rw [fold]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [foldMask, foldK, foldShifts] <;>
    generalize u[0] = a0 <;> generalize u[1] = a1 <;> generalize u[2] = a2 <;>
    generalize u[3] = a3 <;> generalize u[4] = a4 <;> generalize u[5] = a5 <;> bv_decide

/-- `fold`'s lanes: each limb's low bits plus the carry of the limb below, limb 5's times `19`. -/
public theorem fold_lanes (u : Wwl) :
    (fold u)[0].toNat = u[0].toNat % 2 ^ 43 + 19 * (u[5].toNat / 2 ^ 40) ∧
      (fold u)[1].toNat = u[1].toNat % 2 ^ 43 + u[0].toNat / 2 ^ 43 ∧
      (fold u)[2].toNat = u[2].toNat % 2 ^ 43 + u[1].toNat / 2 ^ 43 ∧
      (fold u)[3].toNat = u[3].toNat % 2 ^ 43 + u[2].toNat / 2 ^ 43 ∧
      (fold u)[4].toNat = u[4].toNat % 2 ^ 43 + u[3].toNat / 2 ^ 43 ∧
      (fold u)[5].toNat = u[5].toNat % 2 ^ 40 + u[4].toNat / 2 ^ 43 ∧
      (fold u)[6] = 0 ∧ (fold u)[7] = 0 := by
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ := fold_get u
  have b0 := u[0].isLt
  have b1 := u[1].isLt
  have b2 := u[2].isLt
  have b3 := u[3].isLt
  have b4 := u[4].isLt
  have b5 := u[5].isLt
  have c0 : u[0].toNat / 2 ^ 43 < 2 ^ 21 := by omega
  have c1 : u[1].toNat / 2 ^ 43 < 2 ^ 21 := by omega
  have c2 : u[2].toNat / 2 ^ 43 < 2 ^ 21 := by omega
  have c3 : u[3].toNat / 2 ^ 43 < 2 ^ 21 := by omega
  have c4 : u[4].toNat / 2 ^ 43 < 2 ^ 21 := by omega
  have c5 : u[5].toNat / 2 ^ 40 < 2 ^ 24 := by omega
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, e6, e7⟩ <;>
    simp only [e0, e1, e2, e3, e4, e5, BitVec.toNat_add, BitVec.toNat_and, BitVec.toNat_mul,
      BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat, Nat.reducePow,
      Nat.reduceMod, and_m43, and_m40, and_m52] <;>
    simp (disch := omega) only [Nat.mod_eq_of_lt]

/-- `fold` takes `p` times limb 5's carry off the integer. -/
public theorem fold_nat (u : Wwl) : nat (fold u) + p * (u[5].toNat / 2 ^ 40) = nat u := by
  obtain ⟨e0, e1, e2, e3, e4, e5, -, -⟩ := fold_lanes u
  simp only [nat, e0, e1, e2, e3, e4, e5]
  have := Nat.mod_add_div u[0].toNat (2 ^ 43)
  have := Nat.mod_add_div u[1].toNat (2 ^ 43)
  have := Nat.mod_add_div u[2].toNat (2 ^ 43)
  have := Nat.mod_add_div u[3].toNat (2 ^ 43)
  have := Nat.mod_add_div u[4].toNat (2 ^ 43)
  have := Nat.mod_add_div u[5].toNat (2 ^ 40)
  generalize u[0].toNat % 2 ^ 43 = r0, u[0].toNat / 2 ^ 43 = q0 at *
  generalize u[1].toNat % 2 ^ 43 = r1, u[1].toNat / 2 ^ 43 = q1 at *
  generalize u[2].toNat % 2 ^ 43 = r2, u[2].toNat / 2 ^ 43 = q2 at *
  generalize u[3].toNat % 2 ^ 43 = r3, u[3].toNat / 2 ^ 43 = q3 at *
  generalize u[4].toNat % 2 ^ 43 = r4, u[4].toNat / 2 ^ 43 = q4 at *
  generalize u[5].toNat % 2 ^ 40 = r5, u[5].toNat / 2 ^ 40 = q5 at *
  simp only [p]
  omega

/-- `fold`'s output is `Folded`, whatever its input. -/
public theorem fold_folded (u : Wwl) : Folded (fold u) := by
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ := fold_lanes u
  have := u[0].isLt
  have := u[1].isLt
  have := u[2].isLt
  have := u[3].isLt
  have := u[4].isLt
  have := u[5].isLt
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, e6, e7⟩ <;> omega

/-- `(2 : ℤ) ^ m` between `2 ^ a` and `2 ^ b`, for `omega`. -/
public theorem pow_between {a b m : ℕ} (ha : a ≤ m) (hb : m ≤ b) :
    (2 : ℤ) ^ a ≤ 2 ^ m ∧ (2 : ℤ) ^ m ≤ 2 ^ b ∧ (2 : ℤ) ^ (m + 1) = 2 * 2 ^ m ∧
      (2 : ℤ) ^ (m + 2) = 4 * 2 ^ m :=
  ⟨pow_le_pow_right₀ (by decide) ha, pow_le_pow_right₀ (by decide) hb, by ring, by ring⟩

/-- Unsigned limbs whose integer differs from `u`'s by a multiple of `p` have `u`'s value. -/
public theorem val_of_nat {x u : Wwl} (hx : Unsigned 63 x) (k : ℕ) (h : nat x + p * k = int u) :
    val x = val u := by
  rw [val_eq_nat hx, val, ← h, Int.cast_add, Int.cast_mul, Int.cast_natCast, Int.cast_natCast,
    Int.cast_natCast, ZMod.natCast_self, zero_mul, add_zero]

/-- `fold` keeps an unsigned `fd_r43x6_t`'s value and folds it. -/
public theorem fold_spec {x : Wwl} (hx : Unsigned 63 x) : val (fold x) = val x ∧ Folded (fold x) :=
  ⟨val_of_nat ((fold_folded x).unsigned.mono (by decide)) _
      (by rw [int_eq_nat hx]; exact_mod_cast fold_nat x), fold_folded x⟩

/-- The lane lemmas, as a `simp` set. -/
local macro "simp_lanes" : tactic =>
  `(tactic| simp only [wwl_add_get, wwl_sub_get, wwl_and_get, wwl_andnot_get, wwl_shl_get,
    wwl_shl_vector_get, wwl_shr_vector_get, wwl_shru_vector_get, wwl_madd52lo_get,
    wwl_madd52hi_get, wwl_permute_get, wwl_select_get, wwl_slide_get, wwl_pack_halves_get,
    wwl_pack_h0_h1_get, wwv_add_if_get, wwl_bcast_get])

/-- `fd_r43x6_fold_unsigned` is `fold`. -/
public theorem fd_r43x6_fold_unsigned_eq (x : Wwl) : fd_r43x6_fold_unsigned x = fold x := by
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ := fold_get x
  unfold fd_r43x6_fold_unsigned
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    simp only [Nat.zero_add, Nat.reduceAdd, e0, e1, e2, e3, e4, e5, e6, e7]
    clear e0 e1 e2 e3 e4 e5 e6 e7
    iterate 2
      try simp_lanes
      try simp only [wwl_get0, wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6,
        wwl_get7, wwl_zero_get, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
        Nat.reduceSub, ite_true, ite_false, getD_get]
    simp only [madd52lo]
    generalize x[0] = a0, x[1] = a1, x[2] = a2, x[3] = a3, x[4] = a4, x[5] = a5, x[6] = a6,
      x[7] = a7
    bv_decide

/-- `fd_r43x6_fold_unsigned` keeps an unsigned `fd_r43x6_t`'s value and folds it. -/
public theorem fd_r43x6_fold_unsigned_spec {x : Wwl} (hx : Unsigned 63 x) :
    val (fd_r43x6_fold_unsigned x) = val x ∧ Folded (fd_r43x6_fold_unsigned x) := by
  rw [fd_r43x6_fold_unsigned_eq]
  exact fold_spec hx

/-- `fd_r43x6_fold_signed` is `fold` of the biased lanes. -/
public theorem fd_r43x6_fold_signed_eq (x : Wwl) :
    fd_r43x6_fold_signed x = fold (foldSignedBias x) := by
  unfold fd_r43x6_fold_signed fd_r43x6_approx_carry_propagate foldSignedBias
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ := fold_get (wwl_add x (wwl 0x7FFFFFFFF6800000
    0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000 0x7FFFFFFFFFF00000
    0 0))
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    simp only [Nat.zero_add, Nat.reduceAdd, e0, e1, e2, e3, e4, e5, e6, e7]
    clear e0 e1 e2 e3 e4 e5 e6 e7
    iterate 2
      try simp_lanes
      try simp only [wwl_get0, wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6,
        wwl_get7, wwl_zero_get, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
        Nat.reduceSub, ite_true, ite_false, getD_get]
  all_goals
    generalize x[0] = a0, x[1] = a1, x[2] = a2, x[3] = a3, x[4] = a4, x[5] = a5
    bv_decide

/-- A long biased by `c < 2^63`, no lower than `-c`, as an unsigned long. -/
public theorem toNat_bias {a : BitVec 64} {c : ℕ} (hc : c < 2 ^ 63) (h : -(c : ℤ) ≤ a.toInt) :
    ((a + BitVec.ofNat 64 c).toNat : ℤ) = a.toInt + c := by
  have ha := a.isLt
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (a := c) (by omega)]
  rw [BitVec.toInt_eq_toNat_cond] at h ⊢
  split_ifs at h ⊢ with hlt
  · rw [Nat.mod_eq_of_lt (by omega)]
    push_cast; ring
  · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega), Nat.cast_sub (by omega)]
    push_cast
    ring

/-- `foldSignedBias`'s integer: `int x` plus `2^23 p`, under `fd_r43x6_fold_signed`'s input
ranges. -/
public theorem foldSignedBias_nat {x : Wwl} (h0 : (-2 ^ 63 + 19 * 2 ^ 23 : ℤ) ≤ x[0].toInt)
    (h : ∀ i : Fin 6, (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[(i : ℕ)].toInt) :
    (nat (foldSignedBias x) : ℤ) = int x + 2 ^ 23 * p := by
  have h1 : (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[1].toInt := h 1
  have h2 : (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[2].toInt := h 2
  have h3 : (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[3].toInt := h 3
  have h4 : (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[4].toInt := h 4
  have h5 : (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[5].toInt := h 5
  unfold nat foldSignedBias
  simp only [wwl_add_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5]
  push_cast
  rw [toNat_bias (by norm_num) (by omega), toNat_bias (by norm_num) (by omega),
    toNat_bias (by norm_num) (by omega), toNat_bias (by norm_num) (by omega),
    toNat_bias (by norm_num) (by omega), toNat_bias (by norm_num) (by omega), int]
  push_cast
  ring

/-- `fd_r43x6_fold_signed` keeps the value and folds, for the C's input ranges: limb 0 from
`-2^63 + 19 · 2^23`, limbs 1-5 from `-2^63 + 2^20`. -/
public theorem fd_r43x6_fold_signed_spec_of_ge {x : Wwl}
    (h0 : (-2 ^ 63 + 19 * 2 ^ 23 : ℤ) ≤ x[0].toInt)
    (h : ∀ i : Fin 6, (-2 ^ 63 + 2 ^ 20 : ℤ) ≤ x[(i : ℕ)].toInt) :
    val (fd_r43x6_fold_signed x) = val x ∧ Folded (fd_r43x6_fold_signed x) := by
  rw [fd_r43x6_fold_signed_eq]
  refine ⟨?_, fold_folded _⟩
  have e := fold_nat (foldSignedBias x)
  have b := foldSignedBias_nat h0 h
  rw [val_eq_nat ((fold_folded _).unsigned.mono (by decide)), val]
  have e' : (nat (fold (foldSignedBias x)) : ℤ) + p * ((foldSignedBias x)[5].toNat / 2 ^ 40 : ℕ) =
      nat (foldSignedBias x) := by exact_mod_cast e
  have : ((nat (fold (foldSignedBias x)) : ℤ) : ZMod p) = (int x : ZMod p) := by
    rw [show (nat (fold (foldSignedBias x)) : ℤ) =
        int x + p * (2 ^ 23 - ((foldSignedBias x)[5].toNat / 2 ^ 40 : ℕ)) by
      linear_combination e' + b]
    rw [Int.cast_add, Int.cast_mul, Int.cast_natCast, ZMod.natCast_self, zero_mul, add_zero]
  exact_mod_cast this

/-- `fd_r43x6_fold_signed` keeps a signed `fd_r43x6_t`'s value and folds it. -/
public theorem fd_r43x6_fold_signed_spec {x : Wwl} (hx : Signed 62 x) :
    val (fd_r43x6_fold_signed x) = val x ∧ Folded (fd_r43x6_fold_signed x) := by
  have := (hx 0).1
  exact fd_r43x6_fold_signed_spec_of_ge (by simp at this ⊢; omega)
    fun i => by have := (hx i).1; omega

/-! ## Fast add, sub and neg -/

public theorem add_fast_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (fd_r43x6_add_fast x y)[i] = x[i] + y[i] :=
  wwl_add_get x y i h

public theorem sub_fast_get (x y : Wwl) (i : ℕ) (h : i < 8) :
    (fd_r43x6_sub_fast x y)[i] = x[i] + (fd_r43x6_p[i] - y[i]) := by
  unfold fd_r43x6_sub_fast
  rw [wwl_add_get, wwl_sub_get]

public theorem neg_fast_get (x : Wwl) (i : ℕ) (h : i < 8) :
    (fd_r43x6_neg_fast x)[i] = fd_r43x6_p[i] - x[i] :=
  wwl_sub_get _ x i h

/-- `fd_r43x6_p()`'s limbs, as longs. -/
public theorem p_lane (i : Fin 6) :
    0 ≤ fd_r43x6_p[(i : ℕ)].toInt ∧ fd_r43x6_p[(i : ℕ)].toInt < 2 ^ 43 ∧
      fd_r43x6_p[(i : ℕ)].toNat < 2 ^ 43 := by
  fin_cases i <;> decide

/-- `fd_r43x6_p()` holds `p`. -/
public theorem int_p : int fd_r43x6_p = p := by
  rw [p_int]
  decide

/-- `fd_r43x6_p()` is zero. -/
public theorem val_p : val fd_r43x6_p = 0 := by
  rw [val, int_p, Int.cast_natCast, ZMod.natCast_self]

public theorem HighZero.p : HighZero fd_r43x6_p :=
  ⟨rfl, rfl⟩

public theorem HighZero.add_fast {x y : Wwl} (hx : HighZero x) (hy : HighZero y) :
    HighZero (fd_r43x6_add_fast x y) := by
  rw [HighZero, add_fast_get, add_fast_get, hx.1, hx.2, hy.1, hy.2]
  decide

public theorem HighZero.sub_fast {x y : Wwl} (hx : HighZero x) (hy : HighZero y) :
    HighZero (fd_r43x6_sub_fast x y) := by
  rw [HighZero, sub_fast_get, sub_fast_get, hx.1, hx.2, hy.1, hy.2, HighZero.p.1, HighZero.p.2]
  decide

public theorem HighZero.neg_fast {x : Wwl} (hx : HighZero x) : HighZero (fd_r43x6_neg_fast x) := by
  rw [HighZero, neg_fast_get, neg_fast_get, hx.1, hx.2, HighZero.p.1, HighZero.p.2]
  decide

/-- `fd_r43x6_add_fast` adds signed limbs, one more bit. -/
public theorem fd_r43x6_add_fast_spec {x y : Wwl} (hx : Signed m x) (hy : Signed m y)
    (hm : m ≤ 62) :
    val (fd_r43x6_add_fast x y) = val x + val y ∧ Signed (m + 1) (fd_r43x6_add_fast x y) := by
  obtain ⟨-, p2, p3, -⟩ := pow_between (Nat.zero_le m) hm
  have lane : ∀ i : Fin 6, (fd_r43x6_add_fast x y)[(i : ℕ)].toInt =
      x[(i : ℕ)].toInt + y[(i : ℕ)].toInt := fun i => by
    have := hx i
    have := hy i
    rw [add_fast_get]
    exact toInt_add' (by omega) (by omega)
  refine ⟨?_, fun i => ?_⟩
  · rw [val, val, val, int_of_lanes lane, int, int]
    simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod]
    push_cast
    ring
  · have := hx i
    have := hy i
    rw [lane i]
    omega

/-- `fd_r43x6_add_fast` adds unsigned limbs, one more bit. -/
public theorem fd_r43x6_add_fast_spec_unsigned {x y : Wwl} (hx : Unsigned m x)
    (hy : Unsigned m y) (hm : m ≤ 62) :
    val (fd_r43x6_add_fast x y) = val x + val y ∧ Unsigned (m + 1) (fd_r43x6_add_fast x y) := by
  refine ⟨(fd_r43x6_add_fast_spec (hx.signed (by omega)) (hy.signed (by omega)) hm).1,
    fun i => ?_⟩
  have := hx i
  have := hy i
  have e : 2 ^ (m + 1) = 2 * 2 ^ m := by ring
  have : 2 ^ m ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) hm
  rw [add_fast_get, BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  omega

/-- `fd_r43x6_sub_fast`'s lanes and value, for limbs of `y` and of `x - y` in `[-2^62, 2^62)`. -/
public theorem sub_fast_lanes {x y : Wwl}
    (h : ∀ i : Fin 6, -(2 : ℤ) ^ 62 ≤ y[(i : ℕ)].toInt ∧ y[(i : ℕ)].toInt < 2 ^ 62 ∧
      -(2 : ℤ) ^ 62 ≤ x[(i : ℕ)].toInt - y[(i : ℕ)].toInt ∧
      x[(i : ℕ)].toInt - y[(i : ℕ)].toInt < 2 ^ 62) :
    (∀ i : Fin 6, (fd_r43x6_sub_fast x y)[(i : ℕ)].toInt =
      x[(i : ℕ)].toInt + (fd_r43x6_p[(i : ℕ)].toInt - y[(i : ℕ)].toInt)) ∧
      val (fd_r43x6_sub_fast x y) = val x - val y := by
  have lane : ∀ i : Fin 6, (fd_r43x6_sub_fast x y)[(i : ℕ)].toInt =
      x[(i : ℕ)].toInt + (fd_r43x6_p[(i : ℕ)].toInt - y[(i : ℕ)].toInt) := fun i => by
    have := h i
    have := p_lane i
    rw [sub_fast_get, toInt_add' (by rw [toInt_sub' (by omega) (by omega)]; omega)
      (by rw [toInt_sub' (by omega) (by omega)]; omega), toInt_sub' (by omega) (by omega)]
  refine ⟨lane, ?_⟩
  have e := int_p
  rw [val, val, val, int_of_lanes lane, int, int]
  rw [int] at e
  simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod]
  have e' := congrArg (Int.cast : ℤ → ZMod p) e
  rw [Int.cast_natCast, ZMod.natCast_self] at e'
  push_cast at e' ⊢
  linear_combination e'

/-- `fd_r43x6_sub_fast` subtracts signed limbs, as `x + (p - y)`, two more bits. -/
public theorem fd_r43x6_sub_fast_spec {x y : Wwl} (hx : Signed m x) (hy : Signed m y)
    (h43 : 43 ≤ m) (hm : m ≤ 61) :
    val (fd_r43x6_sub_fast x y) = val x - val y ∧ Signed (m + 2) (fd_r43x6_sub_fast x y) := by
  obtain ⟨p1, p2, -, p4⟩ := pow_between h43 hm
  obtain ⟨lane, v⟩ := sub_fast_lanes (x := x) (y := y) fun i => by
    have := hx i
    have := hy i
    omega
  refine ⟨v, fun i => ?_⟩
  have := hx i
  have := hy i
  have := p_lane i
  rw [lane i]
  omega

/-- `fd_r43x6_sub_fast` subtracts unsigned limbs into signed ones, one more bit. -/
public theorem fd_r43x6_sub_fast_spec_unsigned {x y : Wwl} (hx : Unsigned m x)
    (hy : Unsigned m y) (h43 : 43 ≤ m) (hm : m ≤ 62) :
    val (fd_r43x6_sub_fast x y) = val x - val y ∧ Signed (m + 1) (fd_r43x6_sub_fast x y) := by
  obtain ⟨p1, p2, p3, -⟩ := pow_between h43 hm
  have sx := hx.signed (by omega)
  have sy := hy.signed (by omega)
  have ux := hx.toInt_nonneg (by omega)
  have uy := hy.toInt_nonneg (by omega)
  obtain ⟨lane, v⟩ := sub_fast_lanes (x := x) (y := y) fun i => by
    have := sx i
    have := sy i
    have := ux i
    have := uy i
    omega
  refine ⟨v, fun i => ?_⟩
  have := sx i
  have := sy i
  have := ux i
  have := uy i
  have := p_lane i
  rw [lane i]
  omega

/-- `fd_r43x6_neg_fast` negates unsigned limbs into signed ones, as `p - x`. -/
public theorem fd_r43x6_neg_fast_spec_unsigned {x : Wwl} (hx : Unsigned m x) (h43 : 43 ≤ m)
    (hm : m ≤ 63) :
    val (fd_r43x6_neg_fast x) = -val x ∧ Signed m (fd_r43x6_neg_fast x) := by
  obtain ⟨p1, p2, -, -⟩ := pow_between h43 hm
  have sx := hx.signed hm
  have ux := hx.toInt_nonneg (by omega)
  have lane : ∀ i : Fin 6, (fd_r43x6_neg_fast x)[(i : ℕ)].toInt =
      fd_r43x6_p[(i : ℕ)].toInt - x[(i : ℕ)].toInt := fun i => by
    have := sx i
    have := ux i
    have := p_lane i
    rw [neg_fast_get, toInt_sub' (by omega) (by omega)]
  refine ⟨?_, fun i => ?_⟩
  · have e := int_p
    rw [val, val, int_of_lanes lane, int]
    rw [int] at e
    simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod]
    have e' := congrArg (Int.cast : ℤ → ZMod p) e
    rw [Int.cast_natCast, ZMod.natCast_self] at e'
    push_cast at e' ⊢
    linear_combination e'
  · have := sx i
    have := ux i
    have := p_lane i
    rw [lane i]
    omega

/-- `fd_r43x6_neg_fast` negates signed limbs, as `p - x`, one more bit. -/
public theorem fd_r43x6_neg_fast_spec {x : Wwl} (hx : Signed m x) (h43 : 43 ≤ m) (hm : m ≤ 62) :
    val (fd_r43x6_neg_fast x) = -val x ∧ Signed (m + 1) (fd_r43x6_neg_fast x) := by
  obtain ⟨p1, p2, p3, -⟩ := pow_between h43 hm
  have lane : ∀ i : Fin 6, (fd_r43x6_neg_fast x)[(i : ℕ)].toInt =
      fd_r43x6_p[(i : ℕ)].toInt - x[(i : ℕ)].toInt := fun i => by
    have := hx i
    have := p_lane i
    rw [neg_fast_get, toInt_sub' (by omega) (by omega)]
  refine ⟨?_, fun i => ?_⟩
  · have e := int_p
    rw [val, val, int_of_lanes lane, int]
    rw [int] at e
    simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod]
    have e' := congrArg (Int.cast : ℤ → ZMod p) e
    rw [Int.cast_natCast, ZMod.natCast_self] at e'
    push_cast at e' ⊢
    linear_combination e'
  · have := hx i
    have := p_lane i
    rw [lane i]
    omega

end R43x6





end MLIR.Firedancer.Avx512

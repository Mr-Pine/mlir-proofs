module

public import Agave.Serial.Scalar52_from_bytes
public import Agave.Serial.Scalar52_add
public import Agave.Serial.Scalar52_from_bytes_wide
public import Agave.Serial.Scalar_reduce
import Mathlib.Data.BitVec
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `Scalar52::from_bytes`, `Scalar52::add`, `Scalar52::from_bytes_wide` and `Scalar::reduce` as
numbers mod `ℓ`: the bytes' number, the sum of reduced scalars mod `ℓ`, and the 64 or 32 bytes'
number mod `ℓ`. -/

namespace MLIR.Agave.Serial

open _root_.Ed25519 Agave.Scalar52

/-- A masked 64-bit value is below `2^52`. -/
theorem toNat_and_mask_lt (x : BitVec 64) : (x &&& 0xfffffffffffff#64).toNat < 2 ^ 52 := by
  rw [BitVec.toNat_and]
  exact lt_of_le_of_lt Nat.and_le_right (by decide)

/-! ## `from_bytes` -/

namespace Scalar52_from_bytes

public theorem spec_bounded (b : BitVec 256) : Bounded (spec b) := by
  intro i
  fin_cases i
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · simp only [spec, BitVec.toNat_and]
    exact lt_of_le_of_lt Nat.and_le_right (by decide)

theorem bits_spec (b : BitVec 256) : bits (spec b) = b.setWidth 260 := by
  simp only [bits, spec]
  bv_decide

/-- The limbs are the bytes' number. -/
public theorem nat_spec (b : BitVec 256) : nat (spec b) = b.toNat := by
  rw [← toNat_bits (spec_bounded b), bits_spec, BitVec.toNat_setWidth_of_le (by decide)]

end Scalar52_from_bytes

/-! ## `add` -/

namespace Scalar52_add

theorem sum_bounded (a b : Fin 5 → BitVec 64) : Bounded (sum a b) := by
  intro i
  fin_cases i <;> exact toNat_and_mask_lt _

theorem bits_sum {a b : Fin 5 → BitVec 64} (ha : Bounded a) (hb : Bounded b) :
    bits (sum a b) = bits a + bits b := by
  have a0 := ha 0; have a1 := ha 1; have a2 := ha 2; have a3 := ha 3; have a4 := ha 4
  have b0 := hb 0; have b1 := hb 1; have b2 := hb 2; have b3 := hb 3; have b4 := hb 4
  simp only [bits, sum]
  generalize a 0 = x0 at *
  generalize a 1 = x1 at *
  generalize a 2 = x2 at *
  generalize a 3 = x3 at *
  generalize a 4 = x4 at *
  generalize b 0 = y0 at *
  generalize b 1 = y1 at *
  generalize b 2 = y2 at *
  generalize b 3 = y3 at *
  generalize b 4 = y4 at *
  replace a0 : x0 < 0x10000000000000#64 := a0
  replace a1 : x1 < 0x10000000000000#64 := a1
  replace a2 : x2 < 0x10000000000000#64 := a2
  replace a3 : x3 < 0x10000000000000#64 := a3
  replace a4 : x4 < 0x10000000000000#64 := a4
  replace b0 : y0 < 0x10000000000000#64 := b0
  replace b1 : y1 < 0x10000000000000#64 := b1
  replace b2 : y2 < 0x10000000000000#64 := b2
  replace b3 : y3 < 0x10000000000000#64 := b3
  replace b4 : y4 < 0x10000000000000#64 := b4
  bv_decide

/-- For reduced scalars, the spec is their sum mod `ℓ`, in bounded limbs. -/
public theorem nat_spec {a b : Fin 5 → BitVec 64} (ha : Bounded a) (hb : Bounded b)
    (ha' : nat a < ell) (hb' : nat b < ell) : nat (spec a b) = (nat a + nat b) % ell := by
  have hell : ell < 2 ^ 253 := by decide +kernel
  have hs : nat (sum a b) = nat a + nat b := by
    have e := congrArg BitVec.toNat (bits_sum ha hb)
    rw [toNat_bits (sum_bounded a b), BitVec.toNat_add, toNat_bits ha, toNat_bits hb] at e
    rw [e, Nat.mod_eq_of_lt (by omega)]
  rw [spec, Scalar52_sub.nat_spec_mod (sum_bounded a b) (by omega), hs]

public theorem spec_bounded (a b : Fin 5 → BitVec 64) : Bounded (spec a b) :=
  Scalar52_sub.spec_bounded _

end Scalar52_add

/-! ## `from_bytes_wide` -/

namespace Scalar52_from_bytes_wide

theorem lo_bounded (b : BitVec 512) : Bounded (lo b) := by
  intro i
  fin_cases i <;> exact toNat_and_mask_lt _

theorem hi_bounded (b : BitVec 512) : Bounded (hi b) := by
  intro i
  fin_cases i
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · exact toNat_and_mask_lt _
  · simp only [hi, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
    have := (b.extractLsb' (64 * 7) 64).isLt
    omega

theorem bits_lo (b : BitVec 512) : bits (lo b) = b.setWidth 260 := by
  simp only [bits, lo]
  bv_decide

theorem bits_hi (b : BitVec 512) : bits (hi b) = (b >>> 260).setWidth 260 := by
  simp only [bits, hi]
  bv_decide

-- `omega` must see `2^260`
set_option exponentiation.threshold 260 in
theorem nat_lo_hi (b : BitVec 512) : nat (lo b) + 2 ^ 260 * nat (hi b) = b.toNat := by
  rw [← toNat_bits (lo_bounded b), ← toNat_bits (hi_bounded b), bits_lo, bits_hi]
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have := b.isLt
  rw [Nat.mod_eq_of_lt (a := b.toNat / 2 ^ 260) (by omega)]
  omega

theorem R_bounded : Bounded R := by
  intro i; fin_cases i <;> decide

theorem RR_bounded : Bounded RR := by
  intro i; fin_cases i <;> decide

-- `omega` must see `2^260`
set_option exponentiation.threshold 260 in
/-- The spec is the 64 bytes' number mod `ℓ`. -/
public theorem nat_spec (b : BitVec 512) : nat (spec b) = b.toNat % ell := by
  have hell : ell < 2 ^ 253 := by decide +kernel
  have hR : nat R < ell := by
    rw [nat_R]; exact Nat.mod_lt _ (by decide)
  have hRR : nat RR < ell := by
    rw [nat_RR]; exact Nat.mod_lt _ (by decide)
  have hlo := nat_lt (lo_bounded b)
  have hhi : nat (hi b) < 2 ^ 252 := by
    have := nat_lo_hi b
    have := b.isLt
    omega
  have elo :=
    Scalar52_montgomery_mul.nat_spec (lo_bounded b) R_bounded
      (Nat.mul_lt_mul_of_lt_of_le hlo hR.le (by decide +kernel))
  have ehi :=
    Scalar52_montgomery_mul.nat_spec (hi_bounded b) RR_bounded
      (lt_of_lt_of_le (Nat.mul_lt_mul_of_lt_of_le hhi hRR.le (by decide +kernel))
        (Nat.mul_le_mul_right _ (by decide)))
  rw [spec,
    Scalar52_add.nat_spec (Scalar52_montgomery_mul.spec_bounded _ _)
      (Scalar52_montgomery_mul.spec_bounded _ _)
      (by
        rw [ehi]; exact Nat.mod_lt _ (by decide))
      (by
        rw [elo]; exact Nat.mod_lt _ (by decide)),
    Nat.add_comm, wide_mod (by rw [elo, Nat.mod_mod]) (by rw [ehi, Nat.mod_mod]), nat_lo_hi]

end Scalar52_from_bytes_wide

/-! ## `reduce` -/

namespace Scalar_reduce

theorem columns_eq (x : Fin 5 → BitVec 64) : columns x = Scalar52_mul_internal.spec x R := by
  have e0 : (0x000f48bd6721e6ed#64).setWidth 128 = 0x000f48bd6721e6ed#128 := by decide
  have e1 : (0x0003bab5ac67e45a#64).setWidth 128 = 0x0003bab5ac67e45a#128 := by decide
  have e2 : (0x000fffffeb35e51b#64).setWidth 128 = 0x000fffffeb35e51b#128 := by decide
  have e3 : (0x000fffffffffffff#64).setWidth 128 = 0x000fffffffffffff#128 := by decide
  have e4 : (0x00000fffffffffff#64).setWidth 128 = 0x00000fffffffffff#128 := by decide
  funext k
  fin_cases k <;>
    simp only [columns, Scalar52_mul_internal.spec, m, R, Matrix.cons_val, Fin.isValue, e0, e1, e2,
      e3, e4] <;>
    ring

/-- The spec is the 32 bytes' number mod `ℓ`, little-endian. -/
public theorem toNat_spec (b : BitVec 256) : (spec b).toNat = b.toNat % ell := by
  have hell : ell < 2 ^ 253 := by decide +kernel
  have hR : nat R < ell := by
    rw [nat_R]; exact Nat.mod_lt _ (by decide)
  have hx := Scalar52_from_bytes.nat_spec b
  have hxb := Scalar52_from_bytes.spec_bounded b
  have e :=
    Scalar52_montgomery_mul.nat_spec hxb Scalar52_from_bytes_wide.R_bounded
      (Nat.mul_lt_mul_of_lt_of_le (nat_lt hxb) hR.le (by decide +kernel))
  have hm : nat (Scalar52_montgomery_mul.spec (Scalar52_from_bytes.spec b) R) = b.toNat % ell := by
    have h1 : 2 ^ 260 % ell * Rinv ≡ 1 [MOD ell] := ((Nat.mod_modEq _ _).mul_right _).trans rinv_mul
    rw [e, hx, nat_R, Nat.mul_assoc]
    exact (h1.mul_left b.toNat).trans (by rw [Nat.mul_one])
  have hlt : nat (Scalar52_montgomery_mul.spec (Scalar52_from_bytes.spec b) R) < ell := by
    rw [hm]; exact Nat.mod_lt _ (by decide)
  rw [spec, columns_eq, ← Scalar52_montgomery_mul.spec,
    Scalar52_pack.toNat_spec (Scalar52_montgomery_mul.spec_bounded _ _) (Scalar52_pack.top_lt hlt),
    hm]

end Scalar_reduce

end MLIR.Agave.Serial

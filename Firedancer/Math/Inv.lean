module

public import Firedancer.Math.Field
public import Firedancer.Ref.fd_f25519_inv
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.NormNum.Prime

/-! The Ref inverse `fd_f25519_inv` and the s2n one: both compute `a⁻¹` in `ZMod p`, `0` at `0`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-- `a ^ (p - 2)` is `a⁻¹`, `0` at `0`. -/
public theorem pow_p_sub_two (a : ZMod p) : a ^ (p - 2) = a⁻¹ := by
  by_cases ha : a = 0
  · subst ha
    rw [zero_pow (by norm_num), inv_zero]
  · refine (inv_eq_of_mul_eq_one_right ?_).symm
    rw [← pow_succ', show p - 2 + 1 = p - 1 by norm_num]
    exact ZMod.pow_card_sub_one_eq_one ha

/-- The ref `fd_f25519_inv` takes a loose field element to its inverse (`0` at `0`), tight. -/
public theorem fd_f25519_inv.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Loose a) :
    Limbs.val (fd_f25519_inv.spec a) = (Limbs.val a)⁻¹ ∧ Limbs.Tight (fd_f25519_inv.spec a) := by
  have h0 := IsPow.self ha
  have h1 := h0.sqr
  have h2 := h1.sqr
  have h3 := h2.sqr
  have h4 := h0.mul h3
  have h5 := h1.mul h4
  have h6 := h5.sqr
  have h7 := h4.mul h6
  have h8 := h7.sqr
  have h9 := h8.sqrN (n := 4)
  have h10 := h9.mul h7
  have h11 := h10.sqr
  have h12 := h11.sqrN (n := 9)
  have h13 := h12.mul h10
  have h14 := h13.sqr
  have h15 := h14.sqrN (n := 19)
  have h16 := h15.mul h13
  have h17 := h16.sqrN (n := 10)
  have h18 := h17.mul h10
  have h19 := h18.sqr
  have h20 := h19.sqrN (n := 49)
  have h21 := h20.mul h18
  have h22 := h21.sqr
  have h23 := h22.sqrN (n := 99)
  have h24 := h23.mul h21
  have h25 := h24.sqr
  have h26 := h25.sqrN (n := 49)
  have h27 := h26.mul h18
  have h28 := h27.sqr
  have h29 := h28.sqrN (n := 4)
  obtain ⟨⟨v, t⟩, -⟩ := h29.mul_tight h5 (g := p - 2) (by norm_num)
  exact ⟨v.trans (pow_p_sub_two _), t⟩

/-- `bignum_inv_p25519` by its contract: the inverse's representative below `p`, `0` at `0`. -/
theorem bignum_inv_p25519.spec_val {x : BitVec 256} (hx : x.toNat < p) :
    (bignum_inv_p25519.spec x).toNat < p ∧
      ((bignum_inv_p25519.spec x).toNat : ZMod p) = ((x.toNat : ℕ) : ZMod p)⁻¹ := by
  unfold bignum_inv_p25519.spec
  have hp : p_25519 = p := rfl
  rw [hp]
  split_ifs with h
  · obtain ⟨c, hc⟩ := h
    have : x.toNat = 0 := by
      rcases c with _ | c
      · simpa using hc
      · rw [hc] at hx; nlinarith
    simp only [BitVec.toNat_ofNat, Nat.zero_mod, this, Nat.cast_zero, inv_zero]
    exact ⟨by norm_num, trivial⟩
  · have hp0 : (0 : ℤ) < (p : ℤ) := by norm_num
    have hm0 := Int.emod_nonneg (Nat.gcdA x.toNat p) hp0.ne'
    have hm1 := Int.emod_lt_of_pos (Nat.gcdA x.toNat p) hp0
    have hlt : (Nat.gcdA x.toNat p % (p : ℤ)).toNat < p := by omega
    have hlt' : (Nat.gcdA x.toNat p % (p : ℤ)).toNat < 2 ^ 256 := hlt.trans (by norm_num)
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hlt']
    refine ⟨hlt, ?_⟩
    have hcop : Nat.Coprime x.toNat p := ((Nat.Prime.coprime_iff_not_dvd prime_p).2 h).symm
    have hg := Nat.gcd_eq_gcd_ab x.toNat p
    rw [hcop.gcd_eq_one] at hg
    have hg' := congrArg (fun z : ℤ => (z : ZMod p)) hg
    simp only [Nat.cast_one, Int.cast_one, Int.cast_add, Int.cast_mul, Int.cast_natCast,
      ZMod.natCast_self, zero_mul, add_zero] at hg'
    rw [inv_eq_of_mul_eq_one_right hg'.symm, ← Int.cast_natCast, Int.toNat_of_nonneg hm0,
      ZMod.intCast_mod]

/-- The s2n `fd_f25519_inv` (`bignum_inv_p25519`) takes a tight field element to its inverse (`0`
at `0`), tight. -/
public theorem fd_f25519_inv.s2n_val {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    Limbs.val (fd_f25519_inv.s2n a) = (Limbs.val a)⁻¹ ∧ Limbs.Tight (fd_f25519_inv.s2n a) := by
  have hb := fd_f25519_tobytes.spec_val ha.under2p ha.nat_lt
  obtain ⟨hz, hzv⟩ := bignum_inv_p25519.spec_val (hb ▸ ZMod.val_lt (Limbs.val a))
  obtain ⟨v, t⟩ := fd_f25519_frombytes.spec_val (bignum_inv_p25519.spec (fd_f25519_tobytes.spec a))
  refine ⟨?_, t⟩
  rw [fd_f25519_inv.s2n, v, Nat.mod_eq_of_lt (hz.trans (by norm_num)), hzv, hb,
    ZMod.natCast_zmod_val]

end MLIR.Firedancer.Ref

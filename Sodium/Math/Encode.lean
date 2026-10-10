module

public import Ed25519.Limbs
public import Agave.Math.FieldElement51
public import Sodium.fe25519_reduce
public import Sodium.fe25519_tobytes
public import Sodium.fe25519_frombytes
public import Sodium.fe25519_isnegative
public import Sodium.fe25519_iszero
import Mathlib.Tactic.ClearExcept
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! libsodium's `fe25519` encodings in `ZMod p`: `fe25519_reduce` and `fe25519_tobytes` are
canonical for any limbs, `fe25519_frombytes` reads the low 255 bits, and `fe25519_isnegative`,
`fe25519_iszero` (by `sodium_is_zero`) test the canonical encoding. -/

namespace MLIR.Sodium

open _root_.Ed25519 Agave

/-! ## `fe25519_reduce` -/

/-- A carry chain without the top carry folded: the number is its 51-bit limbs' plus the top
carry at `2^255`. -/
theorem chain_nat {t0 t1 t2 t3 t4 s1 s2 s3 s4 : ℕ} (h1 : s1 = t0 / 2 ^ 51 + t1)
    (h2 : s2 = s1 / 2 ^ 51 + t2) (h3 : s3 = s2 / 2 ^ 51 + t3) (h4 : s4 = s3 / 2 ^ 51 + t4) :
    t0 + t1 * 2 ^ 51 + t2 * 2 ^ 102 + t3 * 2 ^ 153 + t4 * 2 ^ 204 =
      t0 % 2 ^ 51 + s1 % 2 ^ 51 * 2 ^ 51 + s2 % 2 ^ 51 * 2 ^ 102 + s3 % 2 ^ 51 * 2 ^ 153 +
        s4 % 2 ^ 51 * 2 ^ 204 +
        s4 / 2 ^ 51 * 2 ^ 255 := by
  omega

/-- A carry plus a value below `2^100` does not wrap. -/
theorem t_shift_add {x y : BitVec 128} (hy : y.toNat < 2 ^ 100) :
    (x >>> 51 + y).toNat = x.toNat / 2 ^ 51 + y.toNat := by
  have := x.isLt
  rw [BitVec.toNat_add, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
    Nat.mod_eq_of_lt (by omega)]

/-- A value below `2^100` plus a carry does not wrap. -/
theorem t_add_shift {x y : BitVec 128} (hx : x.toNat < 2 ^ 100) :
    (x + y >>> 51).toNat = x.toNat + y.toNat / 2 ^ 51 := by
  have := y.isLt
  rw [BitVec.toNat_add, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
    Nat.mod_eq_of_lt (by omega)]

/-- A 51-bit mask. -/
theorem t_mask (x : BitVec 128) : (x &&& 2251799813685247#128).toNat = x.toNat % 2 ^ 51 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]
  rfl

/-- A sum of values below `2^100` does not wrap. -/
theorem t_add {x y : BitVec 128} (hx : x.toNat < 2 ^ 100) (hy : y.toNat < 2 ^ 100) :
    (x + y).toNat = x.toNat + y.toNat := by rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]

/-- A constant added to a value below `2^100` does not wrap. -/
theorem t_add_const {x : BitVec 128} {c : ℕ} (hx : x.toNat < 2 ^ 100) (hc : c < 2 ^ 100) :
    (x + BitVec.ofNat 128 c).toNat = x.toNat + c := by
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega : c < 2 ^ 128),
    Nat.mod_eq_of_lt (by omega)]

/-- A carry times 19, of a value below `2^100`, does not wrap. -/
theorem t_carry19 {x : BitVec 128} (h : x.toNat < 2 ^ 100) :
    (x >>> 51 * 19#128).toNat = x.toNat / 2 ^ 51 * 19 := by
  rw [BitVec.toNat_mul, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
    show (19#128).toNat = 19 from rfl, Nat.mod_eq_of_lt (by omega)]

/-- A limb's low 51 bits. -/
theorem t_low (x : BitVec 128) : (x.setWidth 64 &&& 2251799813685247#64).toNat = x.toNat % 2 ^ 51 :=
  toNat_setWidth_mask x

/-- The last two passes, for limbs after the second (the first below `2^51 + 19`): `+ 19`, a
pass, `+ 2^255 - 19` and a pass without the top carry leave the number modulo `p`. -/
theorem final_nat {n0 n1 n2 n3 n4 c1 c2 c3 c4 d0 e1 e2 e3 e4 : ℕ} (b0 : n0 ≤ 2 ^ 51 + 18)
    (b1 : n1 < 2 ^ 51) (b2 : n2 < 2 ^ 51) (b3 : n3 < 2 ^ 51) (b4 : n4 < 2 ^ 51)
    (h1 : c1 = (n0 + 19) / 2 ^ 51 + n1) (h2 : c2 = c1 / 2 ^ 51 + n2) (h3 : c3 = c2 / 2 ^ 51 + n3)
    (h4 : c4 = c3 / 2 ^ 51 + n4) (hd0 : d0 = (n0 + 19) % 2 ^ 51 + (2 ^ 51 - 19) + c4 / 2 ^ 51 * 19)
    (he1 : e1 = c1 % 2 ^ 51 + (2 ^ 51 - 1) + d0 / 2 ^ 51)
    (he2 : e2 = c2 % 2 ^ 51 + (2 ^ 51 - 1) + e1 / 2 ^ 51)
    (he3 : e3 = c3 % 2 ^ 51 + (2 ^ 51 - 1) + e2 / 2 ^ 51)
    (he4 : e4 = c4 + (2 ^ 51 - 1) + e3 / 2 ^ 51) :
    d0 % 2 ^ 51 + e1 % 2 ^ 51 * 2 ^ 51 + e2 % 2 ^ 51 * 2 ^ 102 + e3 % 2 ^ 51 * 2 ^ 153 +
        e4 % 2 ^ 51 * 2 ^ 204 =
      (n0 + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204) % (2 ^ 255 - 19) := by
  have hC := chain_nat h1 h2 h3 h4
  have hU :=
    chain_nat (t0 := d0) (t1 := c1 % 2 ^ 51 + (2 ^ 51 - 1)) (t2 := c2 % 2 ^ 51 + (2 ^ 51 - 1))
      (t3 := c3 % 2 ^ 51 + (2 ^ 51 - 1)) (t4 := c4 + (2 ^ 51 - 1)) (s1 := e1) (s2 := e2) (s3 := e3)
      (s4 := e4) (by omega) (by omega) (by omega) (by omega)
  have hq : c4 / 2 ^ 51 ≤ 1 := by omega
  have hc4 : c4 = c4 % 2 ^ 51 + c4 / 2 ^ 51 * 2 ^ 51 := by omega
  have hd0' : d0 % 2 ^ 51 = d0 - d0 / 2 ^ 51 * 2 ^ 51 := by omega
  have hm1 : c1 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have hm2 : c2 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have hm3 : c3 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have hm4 : c4 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have hm0 : (n0 + 19) % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have ho0 : d0 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have ho1 : e1 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have ho2 : e2 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have ho3 : e3 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  have ho4 : e4 % 2 ^ 51 < 2 ^ 51 := Nat.mod_lt _ (by decide)
  clear h1 h2 h3 h4 he1 he2 he3 he4
  subst hd0
  generalize c4 / 2 ^ 51 = q at *
  generalize (n0 + 19) % 2 ^ 51 = m0 at *
  generalize c1 % 2 ^ 51 = m1 at *
  generalize c2 % 2 ^ 51 = m2 at *
  generalize c3 % 2 ^ 51 = m3 at *
  generalize c4 % 2 ^ 51 = m4 at *
  generalize e1 % 2 ^ 51 = o1 at *
  generalize e2 % 2 ^ 51 = o2 at *
  generalize e3 % 2 ^ 51 = o3 at *
  generalize e4 % 2 ^ 51 = o4 at *
  generalize e4 / 2 ^ 51 = qe at *
  generalize (m0 + (2 ^ 51 - 19) + q * 19) % 2 ^ 51 = o0 at *
  generalize hN : n0 + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204 = N
  have hNle : N ≤ 2 ^ 255 + 18 := by omega
  rcases (by omega : q = 0 ∨ q = 1) with rfl | rfl
  · have hNp : N < 2 ^ 255 - 19 := by omega
    rw [Nat.mod_eq_of_lt hNp]
    omega
  · have hNp : 2 ^ 255 - 19 ≤ N := by omega
    rw [Nat.mod_eq_sub_mod hNp, Nat.mod_eq_of_lt (by omega)]
    omega

/-- `fe25519_reduce` leaves 51-bit limbs whose number is `f`'s modulo `p`, for any limbs. -/
theorem fe25519_reduce.spec_nat (f : Fin 5 → BitVec 64) :
    Limbs.Lt (fe25519_reduce.spec f) (2 ^ 51) ∧
      Limbs.nat (fe25519_reduce.spec f) = Limbs.nat f % (2 ^ 255 - 19) := by
  rw [Limbs.lt_iff, Limbs.nat, Limbs.nat]
  dsimp only [fe25519_reduce.spec]
  generalize hz0 : (f 0).setWidth 128 = z0
  generalize hz1 : (f 1).setWidth 128 = z1
  generalize hz2 : (f 2).setWidth 128 = z2
  generalize hz3 : (f 3).setWidth 128 = z3
  generalize hz4 : (f 4).setWidth 128 = z4
  have kz0 : z0.toNat = (f 0).toNat := by
    rw [← hz0, BitVec.toNat_setWidth]; have := (f 0).isLt; omega
  have kz1 : z1.toNat = (f 1).toNat := by
    rw [← hz1, BitVec.toNat_setWidth]; have := (f 1).isLt; omega
  have kz2 : z2.toNat = (f 2).toNat := by
    rw [← hz2, BitVec.toNat_setWidth]; have := (f 2).isLt; omega
  have kz3 : z3.toNat = (f 3).toNat := by
    rw [← hz3, BitVec.toNat_setWidth]; have := (f 3).isLt; omega
  have kz4 : z4.toNat = (f 4).toNat := by
    rw [← hz4, BitVec.toNat_setWidth]; have := (f 4).isLt; omega
  have bz0 : z0.toNat < 2 ^ 64 := kz0 ▸ (f 0).isLt
  have bz1 : z1.toNat < 2 ^ 64 := kz1 ▸ (f 1).isLt
  have bz2 : z2.toNat < 2 ^ 64 := kz2 ▸ (f 2).isLt
  have bz3 : z3.toNat < 2 ^ 64 := kz3 ▸ (f 3).isLt
  have bz4 : z4.toNat < 2 ^ 64 := kz4 ▸ (f 4).isLt
  clear hz0 hz1 hz2 hz3 hz4
  generalize ha1 : z0 >>> 51 + z1 = a1
  have ka1 := ha1 ▸ t_shift_add (x := z0) (y := z1) (bz1.trans (by decide))
  have ba1 : a1.toNat < 2 ^ 65 := by
    clear * - ka1 bz0 bz1; omega
  clear ha1
  generalize ha2 : a1 >>> 51 + z2 = a2
  have ka2 := ha2 ▸ t_shift_add (x := a1) (y := z2) (bz2.trans (by decide))
  have ba2 : a2.toNat < 2 ^ 65 := by
    clear * - ka2 ba1 bz2; omega
  clear ha2
  generalize ha3 : a2 >>> 51 + z3 = a3
  have ka3 := ha3 ▸ t_shift_add (x := a2) (y := z3) (bz3.trans (by decide))
  have ba3 : a3.toNat < 2 ^ 65 := by
    clear * - ka3 ba2 bz3; omega
  clear ha3
  generalize ha4 : a3 >>> 51 + z4 = a4
  have ka4 := ha4 ▸ t_shift_add (x := a3) (y := z4) (bz4.trans (by decide))
  have ba4 : a4.toNat < 2 ^ 65 := by
    clear * - ka4 ba3 bz4; omega
  clear ha4
  generalize hqa : a4 >>> 51 * 19#128 = qa
  have kqa := hqa ▸ t_carry19 (x := a4) (ba4.trans (by decide))
  have bqa : qa.toNat < 2 ^ 19 := by
    clear * - kqa ba4; omega
  clear hqa
  generalize ha0m : z0 &&& 2251799813685247#128 = a0m
  have ka0m := ha0m ▸ t_mask z0
  have ba0m : a0m.toNat < 2 ^ 51 := by
    clear * - ka0m; omega
  clear ha0m
  generalize ha1m : a1 &&& 2251799813685247#128 = a1m
  have ka1m := ha1m ▸ t_mask a1
  have ba1m : a1m.toNat < 2 ^ 51 := by
    clear * - ka1m; omega
  clear ha1m
  generalize ha2m : a2 &&& 2251799813685247#128 = a2m
  have ka2m := ha2m ▸ t_mask a2
  have ba2m : a2m.toNat < 2 ^ 51 := by
    clear * - ka2m; omega
  clear ha2m
  generalize ha3m : a3 &&& 2251799813685247#128 = a3m
  have ka3m := ha3m ▸ t_mask a3
  have ba3m : a3m.toNat < 2 ^ 51 := by
    clear * - ka3m; omega
  clear ha3m
  generalize ha4m : a4 &&& 2251799813685247#128 = a4m
  have ka4m := ha4m ▸ t_mask a4
  have ba4m : a4m.toNat < 2 ^ 51 := by
    clear * - ka4m; omega
  clear ha4m
  generalize hb0 : qa + a0m = b0
  have kb0 := hb0 ▸ t_add (x := qa) (y := a0m) (bqa.trans (by decide)) (ba0m.trans (by decide))
  have bb0 : b0.toNat < 2 ^ 52 := by
    clear * - kb0 bqa ba0m; omega
  clear hb0
  generalize hb1 : b0 >>> 51 + a1m = b1
  have kb1 := hb1 ▸ t_shift_add (x := b0) (y := a1m) (ba1m.trans (by decide))
  have bb1 : b1.toNat < 2 ^ 52 := by
    clear * - kb1 bb0 ba1m; omega
  clear hb1
  generalize hb2 : b1 >>> 51 + a2m = b2
  have kb2 := hb2 ▸ t_shift_add (x := b1) (y := a2m) (ba2m.trans (by decide))
  have bb2 : b2.toNat < 2 ^ 52 := by
    clear * - kb2 bb1 ba2m; omega
  clear hb2
  generalize hb3 : b2 >>> 51 + a3m = b3
  have kb3 := hb3 ▸ t_shift_add (x := b2) (y := a3m) (ba3m.trans (by decide))
  have bb3 : b3.toNat < 2 ^ 52 := by
    clear * - kb3 bb2 ba3m; omega
  clear hb3
  generalize hb4 : b3 >>> 51 + a4m = b4
  have kb4 := hb4 ▸ t_shift_add (x := b3) (y := a4m) (ba4m.trans (by decide))
  have bb4 : b4.toNat < 2 ^ 52 := by
    clear * - kb4 bb3 ba4m; omega
  clear hb4
  generalize hqb : b4 >>> 51 * 19#128 = qb
  have kqb := hqb ▸ t_carry19 (x := b4) (bb4.trans (by decide))
  have bqb : qb.toNat < 2 ^ 6 := by
    clear * - kqb bb4; omega
  clear hqb
  generalize hb0m : b0 &&& 2251799813685247#128 = b0m
  have kb0m := hb0m ▸ t_mask b0
  have bb0m : b0m.toNat < 2 ^ 51 := by
    clear * - kb0m; omega
  clear hb0m
  generalize hb1m : b1 &&& 2251799813685247#128 = b1m
  have kb1m := hb1m ▸ t_mask b1
  have bb1m : b1m.toNat < 2 ^ 51 := by
    clear * - kb1m; omega
  clear hb1m
  generalize hb2m : b2 &&& 2251799813685247#128 = b2m
  have kb2m := hb2m ▸ t_mask b2
  have bb2m : b2m.toNat < 2 ^ 51 := by
    clear * - kb2m; omega
  clear hb2m
  generalize hb3m : b3 &&& 2251799813685247#128 = b3m
  have kb3m := hb3m ▸ t_mask b3
  have bb3m : b3m.toNat < 2 ^ 51 := by
    clear * - kb3m; omega
  clear hb3m
  generalize hb4m : b4 &&& 2251799813685247#128 = b4m
  have kb4m := hb4m ▸ t_mask b4
  have bb4m : b4m.toNat < 2 ^ 51 := by
    clear * - kb4m; omega
  clear hb4m
  generalize hc0a : b0m + 19#128 = c0a
  have kc0a := hc0a ▸ t_add_const (x := b0m) (bb0m.trans (by decide)) (by decide)
  have bc0a : c0a.toNat < 2 ^ 52 := by
    clear * - kc0a bb0m; omega
  clear hc0a
  generalize hc0 : c0a + qb = c0
  have kc0 := hc0 ▸ t_add (x := c0a) (y := qb) (bc0a.trans (by decide)) (bqb.trans (by decide))
  have bc0 : c0.toNat < 2 ^ 53 := by
    clear * - kc0 bc0a bqb; omega
  clear hc0
  generalize hc1 : c0 >>> 51 + b1m = c1
  have kc1 := hc1 ▸ t_shift_add (x := c0) (y := b1m) (bb1m.trans (by decide))
  have bc1 : c1.toNat < 2 ^ 52 := by
    clear * - kc1 bc0 bb1m; omega
  clear hc1
  generalize hc2 : c1 >>> 51 + b2m = c2
  have kc2 := hc2 ▸ t_shift_add (x := c1) (y := b2m) (bb2m.trans (by decide))
  have bc2 : c2.toNat < 2 ^ 52 := by
    clear * - kc2 bc1 bb2m; omega
  clear hc2
  generalize hc3 : c2 >>> 51 + b3m = c3
  have kc3 := hc3 ▸ t_shift_add (x := c2) (y := b3m) (bb3m.trans (by decide))
  have bc3 : c3.toNat < 2 ^ 52 := by
    clear * - kc3 bc2 bb3m; omega
  clear hc3
  generalize hc4 : c3 >>> 51 + b4m = c4
  have kc4 := hc4 ▸ t_shift_add (x := c3) (y := b4m) (bb4m.trans (by decide))
  have bc4 : c4.toNat < 2 ^ 52 := by
    clear * - kc4 bc3 bb4m; omega
  clear hc4
  generalize hqc : c4 >>> 51 * 19#128 = qc
  have kqc := hqc ▸ t_carry19 (x := c4) (bc4.trans (by decide))
  have bqc : qc.toNat < 2 ^ 6 := by
    clear * - kqc bc4; omega
  clear hqc
  generalize hc0m : c0 &&& 2251799813685247#128 = c0m
  have kc0m := hc0m ▸ t_mask c0
  have bc0m : c0m.toNat < 2 ^ 51 := by
    clear * - kc0m; omega
  clear hc0m
  generalize hc1m : c1 &&& 2251799813685247#128 = c1m
  have kc1m := hc1m ▸ t_mask c1
  have bc1m : c1m.toNat < 2 ^ 51 := by
    clear * - kc1m; omega
  clear hc1m
  generalize hc2m : c2 &&& 2251799813685247#128 = c2m
  have kc2m := hc2m ▸ t_mask c2
  have bc2m : c2m.toNat < 2 ^ 51 := by
    clear * - kc2m; omega
  clear hc2m
  generalize hc3m : c3 &&& 2251799813685247#128 = c3m
  have kc3m := hc3m ▸ t_mask c3
  have bc3m : c3m.toNat < 2 ^ 51 := by
    clear * - kc3m; omega
  clear hc3m
  generalize hd0a : c0m + 2251799813685229#128 = d0a
  have kd0a := hd0a ▸ t_add_const (x := c0m) (bc0m.trans (by decide)) (by decide)
  have bd0a : d0a.toNat < 2 ^ 52 := by
    clear * - kd0a bc0m; omega
  clear hd0a
  generalize hd0 : d0a + qc = d0
  have kd0 := hd0 ▸ t_add (x := d0a) (y := qc) (bd0a.trans (by decide)) (bqc.trans (by decide))
  have bd0 : d0.toNat < 2 ^ 53 := by
    clear * - kd0 bd0a bqc; omega
  clear hd0
  generalize hd1 : c1m + 2251799813685247#128 = d1
  have kd1 := hd1 ▸ t_add_const (x := c1m) (bc1m.trans (by decide)) (by decide)
  have bd1 : d1.toNat < 2 ^ 52 := by
    clear * - kd1 bc1m; omega
  clear hd1
  generalize hd2 : c2m + 2251799813685247#128 = d2
  have kd2 := hd2 ▸ t_add_const (x := c2m) (bc2m.trans (by decide)) (by decide)
  have bd2 : d2.toNat < 2 ^ 52 := by
    clear * - kd2 bc2m; omega
  clear hd2
  generalize hd3 : c3m + 2251799813685247#128 = d3
  have kd3 := hd3 ▸ t_add_const (x := c3m) (bc3m.trans (by decide)) (by decide)
  have bd3 : d3.toNat < 2 ^ 52 := by
    clear * - kd3 bc3m; omega
  clear hd3
  generalize hd4 : c4 + 2251799813685247#128 = d4
  have kd4 := hd4 ▸ t_add_const (x := c4) (bc4.trans (by decide)) (by decide)
  have bd4 : d4.toNat < 2 ^ 53 := by
    clear * - kd4 bc4; omega
  clear hd4
  generalize he1 : d1 + d0 >>> 51 = e1
  have ke1 := he1 ▸ t_add_shift (x := d1) (y := d0) (bd1.trans (by decide))
  have be1 : e1.toNat < 2 ^ 53 := by
    clear * - ke1 bd1 bd0; omega
  clear he1
  generalize he2 : d2 + e1 >>> 51 = e2
  have ke2 := he2 ▸ t_add_shift (x := d2) (y := e1) (bd2.trans (by decide))
  have be2 : e2.toNat < 2 ^ 53 := by
    clear * - ke2 bd2 be1; omega
  clear he2
  generalize he3 : d3 + e2 >>> 51 = e3
  have ke3 := he3 ▸ t_add_shift (x := d3) (y := e2) (bd3.trans (by decide))
  have be3 : e3.toNat < 2 ^ 53 := by
    clear * - ke3 bd3 be2; omega
  clear he3
  generalize he4 : d4 + e3 >>> 51 = e4
  have ke4 := he4 ▸ t_add_shift (x := d4) (y := e3) (bd4.trans (by decide))
  have be4 : e4.toNat < 2 ^ 54 := by
    clear * - ke4 bd4 be3; omega
  clear he4
  simp only [t_low]
  refine
    ⟨⟨Nat.mod_lt _ (by decide), Nat.mod_lt _ (by decide), Nat.mod_lt _ (by decide),
        Nat.mod_lt _ (by decide), Nat.mod_lt _ (by decide)⟩,
      ?_⟩
  rw [← kz0, ← kz1, ← kz2, ← kz3, ← kz4]
  have hA := chain_nat ka1 ka2 ka3 ka4
  have hB := chain_nat kb1 kb2 kb3 kb4
  rw [final_nat (n0 := b0m.toNat + qb.toNat) (n1 := b1m.toNat) (n2 := b2m.toNat) (n3 := b3m.toNat)
      (n4 := b4m.toNat) (c1 := c1.toNat) (c2 := c2.toNat) (c3 := c3.toNat) (c4 := c4.toNat) (d0 :=
      d0.toNat) (e1 := e1.toNat) (e2 := e2.toNat) (e3 := e3.toNat) (e4 := e4.toNat)
      (by
        clear * - kb0m kqb kb4 bb3 ba4m; omega)
      (by
        clear * - kb1m; omega)
      (by
        clear * - kb2m; omega)
      (by
        clear * - kb3m; omega)
      (by
        clear * - kb4m; omega)
      (by
        clear * - kc1 kc0 kc0a; omega)
      kc2 kc3 kc4
      (by
        clear * - kd0 kd0a kc0m kqc kc0 kc0a; omega)
      (by
        clear * - ke1 kd1 kc1m; omega)
      (by
        clear * - ke2 kd2 kc2m; omega)
      (by
        clear * - ke3 kd3 kc3m; omega)
      (by
        clear * - ke4 kd4; omega)]
  have hZ :
    z0.toNat + z1.toNat * 2 ^ 51 + z2.toNat * 2 ^ 102 + z3.toNat * 2 ^ 153 + z4.toNat * 2 ^ 204 =
      b0m.toNat + qb.toNat + b1m.toNat * 2 ^ 51 + b2m.toNat * 2 ^ 102 + b3m.toNat * 2 ^ 153 +
        b4m.toNat * 2 ^ 204 +
        (a4.toNat / 2 ^ 51 + b4.toNat / 2 ^ 51) * (2 ^ 255 - 19) := by
    clear * - hA hB kb0 kqa ka0m ka1m ka2m ka3m ka4m kb0m kb1m kb2m kb3m kb4m kqb
    omega
  rw [hZ, Nat.add_mul_mod_self_right]

/-- `fe25519_reduce` is canonical for any limbs: 51-bit limbs whose number is `f`'s value's
representative in `[0, p)`. -/
public theorem fe25519_reduce.spec_val (f : Fin 5 → BitVec 64) :
    Limbs.Lt (fe25519_reduce.spec f) (2 ^ 51) ∧
      Limbs.nat (fe25519_reduce.spec f) = (Limbs.val f).val := by
  rw [Limbs.val_nat, ZMod.val_natCast]
  exact fe25519_reduce.spec_nat f

/-! ## `fe25519_tobytes`, `fe25519_frombytes` -/

/-- Packing 51-bit limbs into the four words `t0 … t3` is their 255-bit sum. -/
theorem pack_eq_sum {l0 l1 l2 l3 l4 : BitVec 64} (h0 : l0 < 0x8000000000000#64)
    (h1 : l1 < 0x8000000000000#64) (h2 : l2 < 0x8000000000000#64) (h3 : l3 < 0x8000000000000#64)
    (h4 : l4 < 0x8000000000000#64) :
    (l4 <<< 12 ||| l3 >>> 39) ++
        ((l3 <<< 25 ||| l2 >>> 26) ++ ((l2 <<< 38 ||| l1 >>> 13) ++ (l1 <<< 51 ||| l0))) =
      l0.setWidth 256 + l1.setWidth 256 <<< 51 + l2.setWidth 256 <<< 102 + l3.setWidth 256 <<< 153 +
        l4.setWidth 256 <<< 204 := by
  bv_decide

/-- The packed words' number: the limbs' number. -/
theorem pack_toNat {l0 l1 l2 l3 l4 : BitVec 64} (h0 : l0.toNat < 2 ^ 51) (h1 : l1.toNat < 2 ^ 51)
    (h2 : l2.toNat < 2 ^ 51) (h3 : l3.toNat < 2 ^ 51) (h4 : l4.toNat < 2 ^ 51) :
    ((l4 <<< 12 ||| l3 >>> 39) ++
          ((l3 <<< 25 ||| l2 >>> 26) ++ ((l2 <<< 38 ||| l1 >>> 13) ++ (l1 <<< 51 ||| l0)))).toNat =
      l0.toNat + l1.toNat * 2 ^ 51 + l2.toNat * 2 ^ 102 + l3.toNat * 2 ^ 153 +
        l4.toNat * 2 ^ 204 := by
  rw [pack_eq_sum (BitVec.lt_def.2 h0) (BitVec.lt_def.2 h1) (BitVec.lt_def.2 h2)
      (BitVec.lt_def.2 h3) (BitVec.lt_def.2 h4)]
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq]
  omega

/-- `fe25519_tobytes`'s number: that of the limbs it packs, `t`, if they are 51 bits. -/
theorem tobytes_toNat {h t : Fin 5 → BitVec 64} (ht : fe25519_reduce.spec h = t)
    (hl : Limbs.Lt t (2 ^ 51)) : (fe25519_tobytes.spec h).toNat = Limbs.nat t := by
  obtain ⟨b0, b1, b2, b3, b4⟩ := (Limbs.lt_iff _ _).1 hl
  rw [fe25519_tobytes.spec, ht]
  exact pack_toNat b0 b1 b2 b3 b4

/-- `fe25519_tobytes` is the canonical encoding: its number is `h`'s value's representative in
`[0, p)`, for any limbs. -/
public theorem fe25519_tobytes.spec_val (h : Fin 5 → BitVec 64) :
    (fe25519_tobytes.spec h).toNat = (Limbs.val h).val := by
  obtain ⟨hl, hn⟩ := fe25519_reduce.spec_val h
  rw [tobytes_toNat rfl hl, hn]

/-- Equal encodings, equal values. -/
public theorem fe25519_tobytes.spec_eq_iff (a b : Fin 5 → BitVec 64) :
    fe25519_tobytes.spec a = fe25519_tobytes.spec b ↔ Limbs.val a = Limbs.val b := by
  rw [← BitVec.toNat_inj, fe25519_tobytes.spec_val, fe25519_tobytes.spec_val]
  exact ZMod.val_injective _ |>.eq_iff

/-- `fe25519_frombytes`'s limbs, summed: the low 255 bits. -/
theorem frombytes_sum (s : BitVec 256) :
    let h := fe25519_frombytes.spec s
    (h 0).setWidth 256 + (h 1).setWidth 256 <<< 51 + (h 2).setWidth 256 <<< 102 +
        (h 3).setWidth 256 <<< 153 +
        (h 4).setWidth 256 <<< 204 =
      s &&& 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256 := by
  simp only [fe25519_frombytes.spec]
  bv_decide

/-- `fe25519_frombytes` reads the low 255 bits of `s` into 51-bit limbs. -/
public theorem fe25519_frombytes.spec_val (s : BitVec 256) :
    Limbs.Lt (fe25519_frombytes.spec s) (2 ^ 51) ∧
      Limbs.nat (fe25519_frombytes.spec s) = s.toNat % 2 ^ 255 ∧
      Limbs.val (fe25519_frombytes.spec s) = ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  have hb (i : Fin 5) : (fe25519_frombytes.spec s i).toNat < 2 ^ 51 := by
    fin_cases i <;> simp only [fe25519_frombytes.spec] <;> rw [toNat_and_mask] <;> omega
  have hn : Limbs.nat (fe25519_frombytes.spec s) = s.toNat % 2 ^ 255 := by
    have e := congrArg BitVec.toNat (frombytes_sum s)
    have := hb 0
    have := hb 1
    have := hb 2
    have := hb 3
    have := hb 4
    simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq,
      BitVec.toNat_and] at e
    rw [Limbs.nat,
      show
        (0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256 :
              BitVec 256).toNat =
          2 ^ 255 - 1
        from rfl,
      Nat.and_two_pow_sub_one_eq_mod] at *
    omega
  exact ⟨hb, hn, by rw [Limbs.val_nat, hn]⟩

/-! ## `fe25519_isnegative`, `fe25519_iszero` -/

/-- `fe25519_isnegative` is the canonical representative's parity. -/
public theorem fe25519_isnegative.spec_val (f : Fin 5 → BitVec 64) :
    (fe25519_isnegative.spec f).toNat = (Limbs.val f).val % 2 := by
  rw [fe25519_isnegative.spec, BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_setWidth,
    fe25519_tobytes.spec_val, show (1#32).toNat = 1 from rfl, Nat.and_one_is_mod]
  omega

/-- `sodium_is_zero` of 32 bytes is `1` exactly when they are all zero. -/
public theorem sodium_is_zero.spec_32 (x : BitVec 256) :
    sodium_is_zero.spec x 32 = if x = 0#256 then 1#32 else 0#32 := by
  simp only [sodium_is_zero.spec, List.range_succ, List.range_zero, List.nil_append,
    List.foldl_append, List.foldl_cons, List.foldl_nil]
  split <;> bv_decide

/-- `fe25519_iszero` is `1` exactly when the value is `0`. -/
public theorem fe25519_iszero.spec_val (f : Fin 5 → BitVec 64) :
    fe25519_iszero.spec f = if Limbs.val f = 0 then 1#32 else 0#32 := by
  rw [fe25519_iszero.spec, sodium_is_zero.spec_32]
  congr 1
  apply propext
  rw [← BitVec.toNat_inj, fe25519_tobytes.spec_val, BitVec.toNat_zero, ZMod.val_eq_zero]

end MLIR.Sodium

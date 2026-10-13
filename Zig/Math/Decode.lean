module

public import Ed25519.Decode
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.ReduceModChar
import Std.Tactic.BVDecide
public import Zig.Edwards25519_fromBytes
public import Zig.Math.Field
public import Zig.Math.Point

/-! Zig's point decoding in `ZMod p`: `Edwards25519.fromBytes` fails exactly when no point decodes,
and otherwise gives the decoded point with `z = 1`. -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Decode

/-! ## Constants -/

/-- `Fe.d` is `d`. -/
public theorem feD_val : Limbs.val Fe.d = d := by
  rw [Limbs.val_eq]
  unfold Ed25519.d
  simp [Fe.d]
  reduce_mod_char

/-- `Fe.one` is `1`. -/
public theorem feOne_val : Limbs.val Fe.one = 1 := by
  rw [Limbs.val_eq, show (Fe.one 0).toNat = 1 from rfl, show (Fe.one 1).toNat = 0 from rfl,
    show (Fe.one 2).toNat = 0 from rfl, show (Fe.one 3).toNat = 0 from rfl,
    show (Fe.one 4).toNat = 0 from rfl]
  simp

/-- `Fe.sqrtm1` is `√-1`. -/
public theorem feSqrtm1_val : Limbs.val Fe.sqrtm1 = sqrtM1 := by
  rw [Limbs.val_eq]
  unfold Ed25519.sqrtM1
  simp [Fe.sqrtm1]
  reduce_mod_char

/-- `Fe.d`'s limbs are below `2^51`. -/
public theorem feD_lt : Fe.Lt Fe.d (2 ^ 51) := by
  intro i; fin_cases i <;> decide

/-- `Fe.one`'s limbs are below `2^51`. -/
public theorem feOne_lt : Fe.Lt Fe.one (2 ^ 51) := by
  intro i; fin_cases i <;> decide

/-- `Fe.sqrtm1`'s limbs are below `2^51`. -/
public theorem feSqrtm1_lt : Fe.Lt Fe.sqrtm1 (2 ^ 51) := by
  intro i; fin_cases i <;> decide

/-! ## Bytes -/

theorem toNat_slice (b : BitVec 256) (o s : ℕ) :
    (b.extractLsb' o 64 >>> s &&& Fe.mask).toNat = b.toNat / 2 ^ o % 2 ^ 64 / 2 ^ s % 2 ^ 51 := by
  rw [toNat_and_mask, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow]

/-- `Fe.fromBytes.spec`'s number is `b`'s low 255 bits. -/
public theorem feFromBytes_nat (b : BitVec 256) :
    Limbs.nat (Fe.fromBytes.spec b) = b.toNat % 2 ^ 255 := by
  have h0 : (b.setWidth 64 &&& Fe.mask).toNat = b.toNat % 2 ^ 51 := by
    rw [toNat_and_mask, BitVec.toNat_setWidth, Nat.mod_mod_of_dvd _ (by decide)]
  simp only [Limbs.nat, Fe.fromBytes.spec, Fe.mk5, h0, toNat_slice]
  have := b.isLt
  omega

/-- `Fe.fromBytes.spec`'s value is `b`'s low 255 bits, mod `p`. -/
public theorem feFromBytes_val (b : BitVec 256) :
    Limbs.val (Fe.fromBytes.spec b) = ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  rw [Limbs.val_nat, feFromBytes_nat]

/-- `Fe.fromBytes.spec`'s limbs are below `2^51`. -/
public theorem feFromBytes_lt (b : BitVec 256) : Fe.Lt (Fe.fromBytes.spec b) (2 ^ 51) := by
  intro i; fin_cases i <;> exact mask_lt _

/-! ## `Fe.pow2523.spec` -/

/-- `l` holds `A ^ e`, limbs below `2^54`. -/
def IsPow (l : Fin 5 → BitVec 64) (A : ZMod p) (e : ℕ) : Prop :=
  Fe.Lt l (2 ^ 54) ∧ Limbs.val l = A ^ e

theorem IsPow.mul (h : IsPow l A e) (h' : IsPow m A f) : IsPow (Fe.mul.spec l m) A (e + f) :=
  ⟨(Fe.mul.spec_lt l m).mono (by norm_num), by rw [Fe.mul.spec_val h.1 h'.1, h.2, h'.2, pow_add]⟩

theorem IsPow.sq (h : IsPow l A e) : IsPow (Fe.sq.spec l) A (e * 2) :=
  ⟨(Fe.sq.spec_lt l).mono (by norm_num), by rw [Fe.sq.spec_val h.1, h.2, pow_mul]⟩

theorem IsPow.sqn (h : IsPow l A e) (n : ℕ) : IsPow (Fe.sqn.spec n l) A (e * 2 ^ n) :=
  ⟨Fe.sqn.spec_lt h.1 n, by rw [Fe.sqn.spec_val h.1, h.2, pow_mul]⟩

/-- `Fe.pow2523.spec` raises to `2^252 - 3`, for limbs below `2^54`. -/
public theorem pow2523_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
    Limbs.val (Fe.pow2523.spec a) = Limbs.val a ^ (2 ^ 252 - 3) := by
  have a1 : IsPow a (Limbs.val a) 1 := ⟨ha, (pow_one _).symm⟩
  have t0 := a1.sq
  have t1 := a1.mul t0
  have t0 := t1.mul (t1.sqn 2)
  have t0 := t0.sq.mul a1
  have t1 := (t0.sqn 5).mul t0
  have t2 := (t1.sqn 5).mul t0
  have t0 := (t2.sqn 15).mul t2
  have t2 := (t0.sqn 30).mul t0
  have t0 := (t2.sqn 60).mul t2
  have t0 := (t0.sqn 120).mul t0
  have t0 := (t0.sqn 10).mul t1
  have r := (t0.sqn 2).mul a1
  refine r.2.trans ?_
  congr 1

/-- `Fe.pow2523.spec`'s limbs are below `2^52`. -/
public theorem pow2523_lt (a : Fin 5 → BitVec 64) : Fe.Lt (Fe.pow2523.spec a) (2 ^ 52) :=
  Fe.mul.spec_lt _ _

/-! ## Square roots -/

/-- `x = (u v)^((p-5)/8) u` has `v x² = ± u` exactly when `u / v` has a root. -/
theorem sqrt_alg {u v x : ZMod p} (hv : v ≠ 0) (hx : x = (u * v) ^ (2 ^ 252 - 3) * u) :
    (x ^ 2 * v = u ∨ x ^ 2 * v = -u) ↔ ∃ r, v * r ^ 2 = u := by
  by_cases hu : u = 0
  · subst hu
    simp only [hx, mul_zero, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow, zero_mul,
      neg_zero, or_self, true_iff]
    exact ⟨0, by ring⟩
  have hw : u * v ≠ 0 := mul_ne_zero hu hv
  set c := (u * v) ^ ((p - 1) / 4) with hc
  have hcheck : x ^ 2 * v = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * (2 ^ 252 - 3) + 1 by norm_num, pow_succ (u * v), pow_mul (u * v),
      hx]
    ring
  have hc2 : c ^ 2 = (u * v) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hsq := ZMod.euler_criterion p hw
  rw [hcheck]
  constructor
  · intro h
    have h1 : c ^ 2 = 1 := by
      rcases h with h | h
      · have : u * (c - 1) = 0 := by linear_combination h
        rw [show c = 1 by linear_combination (mul_eq_zero.1 this).resolve_left hu]; ring
      · have : u * (c + 1) = 0 := by linear_combination h
        rw [show c = -1 by linear_combination (mul_eq_zero.1 this).resolve_left hu]; ring
    obtain ⟨r, hr⟩ := hsq.2 (hc2.symm.trans h1)
    have hr2 : r ^ 2 = u * v := by rw [sq, hr]
    refine ⟨r / v, ?_⟩
    rw [div_pow, hr2]
    field_simp
  · rintro ⟨r, hr⟩
    have h1 : c ^ 2 = 1 :=
      hc2.trans
        (hsq.1
          ⟨v * r, by
            rw [← hr]; ring⟩)
    rcases sq_eq_one_iff'.1 h1 with h | h
    · exact .inl (by rw [h, mul_one])
    · exact
        .inr
          (by
            rw [h]; ring)

/-! ## Decoding -/

/-- The encoded `y`: `b`'s low 255 bits, mod `p`. -/
abbrev encY (b : BitVec 256) : ZMod p :=
  ((b.toNat % 2 ^ 255 : ℕ) : ZMod p)

theorem or_ofBool (a c : Bool) : (BitVec.ofBool a ||| BitVec.ofBool c = 0#1) ↔ ¬(a ∨ c) := by
  cases a <;> cases c <;> decide

theorem flag_lt (a : Bool) : ((BitVec.ofBool a).setWidth 64 ^^^ 1#64).toNat < 2 := by
  cases a <;> decide

theorem flag_eq (a : Bool) : ((BitVec.ofBool a).setWidth 64 ^^^ 1#64) = 1#64 ↔ a = false := by
  cases a <;> decide

theorem sign_bits (a : BitVec 8) (r : BitVec 64) :
    (((a >>> 7) ^^^ (r.setWidth 8 &&& 1#8)).setWidth 64).toNat < 2 ∧
      (((a >>> 7) ^^^ (r.setWidth 8 &&& 1#8)).setWidth 64 = 1#64 ↔
        a >>> 7 ≠ r.setWidth 8 &&& 1#8) := by
  constructor
  · have : ((a >>> 7) ^^^ (r.setWidth 8 &&& 1#8)).setWidth 64 < 2#64 := by bv_decide
    exact this
  · bv_decide

/-- `Edwards25519.fromBytes.sign`'s condition: `b`'s top bit differs from `x`'s parity. -/
theorem signFlip_spec (b : BitVec 256) {x : Fin 5 → BitVec 64} (hx : Fe.Lt x (2 ^ 63)) :
    (Edwards25519.fromBytes.sign b x).toNat < 2 ∧
      (Edwards25519.fromBytes.sign b x = 1#64 ↔ b.toNat / 2 ^ 255 ≠ (Limbs.val x).val % 2) := by
  obtain ⟨h1, h2⟩ := sign_bits (b.extractLsb' 248 8) (Fe.reduce.spec x 0)
  refine ⟨h1, h2.trans ?_⟩
  have hn := Fe.reduce.spec_nat_val hx
  unfold Limbs.nat at hn
  rw [ne_eq, ← BitVec.toNat_inj, BitVec.toNat_and, BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow,
    BitVec.toNat_setWidth, show (1#8).toNat = 1 from rfl, Nat.and_one_is_mod, ← hn]
  have := b.isLt
  omega

/-- What `fromBytes` gives: `none` exactly when no `x` is on the curve with the encoded `y`, else a
point with `x` of the encoded sign, the encoded `y`, `z = 1`, `t = x y`. -/
theorem fromBytes_cases (b : BitVec 256) :
    (Edwards25519.fromBytes.spec b = none ∧ ¬∃ x, OnCurve x (encY b)) ∨
      ∃ P,
        Edwards25519.fromBytes.spec b = some P ∧
          OnCurve (Limbs.val P.x) (encY b) ∧
          (Limbs.val P.x = 0 ∨ (Limbs.val P.x).val % 2 = b.toNat / 2 ^ 255) ∧
          Limbs.val P.y = encY b ∧
          P.z = Fe.one ∧ Limbs.val P.t = Limbs.val P.x * Limbs.val P.y ∧ P.Lt (2 ^ 52) := by
  dsimp only [Edwards25519.fromBytes.spec]
  have vy := feFromBytes_val b
  have hyb := feFromBytes_lt b
  generalize Fe.fromBytes.spec b = y at *
  have vu0 := Fe.sq.spec_val (hyb.mono (by norm_num))
  have bu0 := Fe.sq.spec_lt y
  generalize Fe.sq.spec y = u0 at *
  have vv0 := Fe.mul.spec_val (bu0.mono (by norm_num)) (feD_lt.mono (by norm_num))
  have bv0 := Fe.mul.spec_lt u0 Fe.d
  generalize Fe.mul.spec u0 Fe.d = v0 at *
  have vu := Fe.sub.spec_val (bu0.mono (by norm_num)) (feOne_lt.mono (by norm_num))
  have bu := Fe.sub.spec_lt (b := Fe.one) bu0 (by norm_num)
  generalize Fe.sub.spec u0 Fe.one = u at *
  have vv := Fe.add.spec_val bv0 feOne_lt (by norm_num)
  have bv := Fe.add.spec_lt bv0 feOne_lt (by norm_num)
  generalize Fe.add.spec v0 Fe.one = v at *
  rw [vu0, vy] at vu
  rw [vv0, vu0, vy, feD_val] at vv
  rw [feOne_val] at vu vv
  unfold encY
  generalize ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) = Y at *
  have hV : Y ^ 2 * d + 1 ≠ 0 := by
    have := one_add_ne 1 Y
    intro h; apply this; linear_combination h
  have hcurve (x : ZMod p) : OnCurve x Y ↔ (Y ^ 2 * d + 1) * x ^ 2 = Y ^ 2 - 1 := onCurve_iff
  -- `x = (u v)^((p-5)/8) u`, `vxx = v x²`
  have bu' : Fe.Lt u (2 ^ 54) := bu.mono (by norm_num)
  have bv' : Fe.Lt v (2 ^ 54) := bv.mono (by norm_num)
  have vw := Fe.mul.spec_val bu' bv'
  have vp := pow2523_val ((Fe.mul.spec_lt u v).mono (by norm_num))
  have vx0 := Fe.mul.spec_val ((pow2523_lt (Fe.mul.spec u v)).mono (by norm_num)) bu'
  rw [vp, vw, vu, vv] at vx0
  have bx0 := Fe.mul.spec_lt (Fe.pow2523.spec (Fe.mul.spec u v)) u
  generalize Fe.mul.spec (Fe.pow2523.spec (Fe.mul.spec u v)) u = x0 at *
  have vxx := Fe.mul.spec_val ((Fe.sq.spec_lt x0).mono (by norm_num)) bv'
  rw [Fe.sq.spec_val (bx0.mono (by norm_num)), vv] at vxx
  have bxx := Fe.mul.spec_lt (Fe.sq.spec x0) v
  generalize Fe.mul.spec (Fe.sq.spec x0) v = xx at *
  -- the flags
  have hm := Fe.isZero.spec_eq ((Fe.sub.spec_lt (b := u) bxx (by norm_num)).mono (by norm_num))
  rw [Fe.sub.spec_val (bxx.mono (by norm_num)) (bu.mono (by norm_num)), vxx, vu] at hm
  have hp := Fe.isZero.spec_eq ((Fe.add.spec_lt bxx bu (by norm_num)).mono (by norm_num))
  rw [Fe.add.spec_val bxx bu (by norm_num), vxx, vu] at hp
  rw [hm, hp]
  have key :
    (Limbs.val x0 ^ 2 * (Y ^ 2 * d + 1) - (Y ^ 2 - 1) = 0 ∨
        Limbs.val x0 ^ 2 * (Y ^ 2 * d + 1) + (Y ^ 2 - 1) = 0) ↔
      ∃ x, OnCurve x Y := by
    simp only [hcurve, sub_eq_zero, add_eq_zero_iff_eq_neg]
    exact sqrt_alg hV vx0
  split_ifs with hc
  · left
    rw [or_ofBool, decide_eq_true_iff, decide_eq_true_iff] at hc
    exact ⟨rfl, key.not.1 hc⟩
  right
  rw [or_ofBool, decide_eq_true_iff, decide_eq_true_iff, not_not] at hc
  -- `x · √-1` when `v x² = -u`: then `v x² = u`
  have c1lt := flag_lt (decide (Limbs.val x0 ^ 2 * (Y ^ 2 * d + 1) - (Y ^ 2 - 1) = 0))
  have vx1 := Fe.cMov.spec_val (fe := x0) (a := Fe.mul.spec x0 Fe.sqrtm1) c1lt
  simp only [flag_eq, decide_eq_false_iff_not] at vx1
  rw [Fe.mul.spec_val (bx0.mono (by norm_num)) (feSqrtm1_lt.mono (by norm_num)),
    feSqrtm1_val] at vx1
  have bx1 :
    Fe.Lt
      (Fe.cMov.spec x0 (Fe.mul.spec x0 Fe.sqrtm1)
        ((BitVec.ofBool (decide (Limbs.val x0 ^ 2 * (Y ^ 2 * d + 1) - (Y ^ 2 - 1) = 0))).setWidth
            64 ^^^
          1#64))
      (2 ^ 52) := by
    rw [Fe.cMov.spec_eq _ _ _ c1lt]
    split
    · exact Fe.mul.spec_lt _ _
    · exact bx0
  generalize Fe.cMov.spec x0 (Fe.mul.spec x0 Fe.sqrtm1) _ = x1 at *
  have root : (Y ^ 2 * d + 1) * Limbs.val x1 ^ 2 = Y ^ 2 - 1 := by
    rw [vx1]
    split_ifs with h
    · linear_combination h
    · have h' := hc.resolve_left h
      linear_combination sqrtM1 ^ 2 * h' - (Y ^ 2 - 1) * sqrtM1_sq
  -- the sign fix
  obtain ⟨slt, seq⟩ := signFlip_spec b (bx1.mono (by norm_num))
  have vx := Fe.cMov.spec_val (fe := x1) (a := Fe.neg.spec x1) slt
  simp only [seq] at vx
  rw [Fe.neg.spec_val (bx1.mono (by norm_num))] at vx
  have bx :
    Fe.Lt (Fe.cMov.spec x1 (Fe.neg.spec x1) (Edwards25519.fromBytes.sign b x1)) (2 ^ 52) := by
    rw [Fe.cMov.spec_eq _ _ _ slt]
    split
    · exact Fe.neg.spec_lt (bx1.mono (by norm_num))
    · exact bx1
  generalize Fe.cMov.spec x1 (Fe.neg.spec x1) (Edwards25519.fromBytes.sign b x1) = x at *
  refine
    ⟨_, rfl, ?_, ?_, vy, rfl, Fe.mul.spec_val (bx.mono (by norm_num)) (hyb.mono (by norm_num)), bx,
      hyb.mono (by norm_num), feOne_lt.mono (by norm_num), Fe.mul.spec_lt _ _⟩
  · rw [hcurve, vx]
    split_ifs
    · rw [neg_sq]; exact root
    · exact root
  · rw [vx]
    have hb : b.toNat / 2 ^ 255 < 2 := by
      have := b.isLt; omega
    have hp2 : p % 2 = 1 := by norm_num
    have hlt := ZMod.val_lt (Limbs.val x1)
    split_ifs with h
    · by_cases h0 : Limbs.val x1 = 0
      · exact .inl (by rw [h0, neg_zero])
      · right
        rw [ZMod.neg_val, ite_eq_right h0]
        omega
    · exact .inr (by omega)

/-- `Edwards25519.fromBytes.spec` fails exactly when no point decodes. -/
public theorem fromBytes_eq_none (b : BitVec 256) :
    Edwards25519.fromBytes.spec b = none ↔ decode b = none := by
  rw [decode_eq_none, ← not_exists, exists_decodes_iff]
  rcases fromBytes_cases b with ⟨h, hn⟩ | ⟨P, h, hc, -⟩
  · exact ⟨fun _ => hn, fun _ => h⟩
  · rw [h]
    exact ⟨fun h => absurd h (by simp), fun h => absurd ⟨_, hc⟩ h⟩

/-- `fromBytes`' point is the decoded one, with `z = 1` and limbs below `2^52`. -/
public theorem fromBytes_eq_some {b : BitVec 256} {P : ZPt}
    (h : Edwards25519.fromBytes.spec b = some P) :
    ∃ Q, decode b = some Q ∧ P.Ext Q.x Q.y ∧ Limbs.val P.z = 1 ∧ P.Lt (2 ^ 52) := by
  rcases fromBytes_cases b with ⟨h', -⟩ | ⟨P', h', hc, hs, hy, hz, ht, hl⟩
  · rw [h'] at h; exact absurd h (by simp)
  rw [h, Option.some.injEq] at h'
  subst h'
  have hz1 : Limbs.val P.z = 1 := by rw [hz, feOne_val]
  refine ⟨⟨Limbs.val P.x, Limbs.val P.y, hy ▸ hc⟩, decode_eq_some ⟨hy, hs⟩, ?_, hz1, hl⟩
  refine
    ⟨by
      rw [hz1]; exact one_ne_zero, by rw [hz1, mul_one], by rw [hz1, mul_one], ?_⟩
  rw [hz1, mul_one, ht]

end Decode

end MLIR.Zig

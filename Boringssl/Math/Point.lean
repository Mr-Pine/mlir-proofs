module

public import Agave.Math.Point
public import Boringssl.Math.Field
public import Ed25519.Encode
public import Firedancer.Math.Curve
public import Boringssl.ge_p3_to_p2
public import Boringssl.x25519_ge_p1p1_to_p2
public import Boringssl.x25519_ge_p1p1_to_p3
public import Boringssl.x25519_ge_p3_to_cached
public import Boringssl.ge_p2_0
public import Boringssl.ge_p2_dbl
public import Boringssl.ge_p3_dbl
public import Boringssl.ge_madd
public import Boringssl.ge_msub
public import Boringssl.x25519_ge_add
public import Boringssl.x25519_ge_sub
public import Boringssl.x25519_ge_tobytes
public import Boringssl.x25519_ge_frombytes_vartime
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.IntervalCases

/-! ref10's point operations on the curve: each spec computes its operation on the points its
coordinates represent (`IsProj`, `IsExt`, `IsCompleted`, `IsNiels`), within fiat's bounds; the
encoding and decoding are `encode` and `decode`. -/

namespace MLIR.Boringssl

open _root_.Ed25519 Firedancer.Ref Agave

/-! ## Definitions -/

@[expose] public section

/-- The `ge_p2` `P` is `Q` in projective coordinates, tight. -/
def _root_.MLIR.GeP2.Proj (P : GeP2) (Q : Point) : Prop :=
  IsProj Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z) ∧
    Limbs.Tight P.X ∧ Limbs.Tight P.Y ∧ Limbs.Tight P.Z

/-- The `ge_p3` `P` is `Q` in extended coordinates, tight. -/
def _root_.MLIR.GeP3.Ext (P : GeP3) (Q : Point) : Prop :=
  IsExt Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.T) (Limbs.val P.Z) ∧
    Limbs.Tight P.X ∧ Limbs.Tight P.Y ∧ Limbs.Tight P.Z ∧ Limbs.Tight P.T

/-- The `ge_p1p1` `P` is `Q` in completed coordinates, loose. -/
def _root_.MLIR.GeP1p1.Compl (P : GeP1p1) (Q : Point) : Prop :=
  IsCompleted Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z) (Limbs.val P.T) ∧
    Limbs.Loose P.X ∧ Limbs.Loose P.Y ∧ Limbs.Loose P.Z ∧ Limbs.Loose P.T

/-- The `ge_cached` `P` is `Q` as `(Y + X, Y - X, Z, 2d T)`, loose. -/
def _root_.MLIR.GeCached.Niels (P : GeCached) (Q : Point) : Prop :=
  IsNiels Q.x Q.y (Limbs.val P.YplusX) (Limbs.val P.YminusX) (Limbs.val P.Z) (Limbs.val P.T2d) ∧
    Limbs.Loose P.YplusX ∧ Limbs.Loose P.YminusX ∧ Limbs.Loose P.Z ∧ Limbs.Loose P.T2d

/-- The `ge_precomp` `P` is `Q` as `(y + x, y - x, 2d x y)`, loose. -/
def _root_.MLIR.GePrecomp.Niels (P : GePrecomp) (Q : Point) : Prop :=
  IsAffineNiels Q.x Q.y (Limbs.val P.yplusx) (Limbs.val P.yminusx) (Limbs.val P.xy2d) ∧
    Limbs.Loose P.yplusx ∧ Limbs.Loose P.yminusx ∧ Limbs.Loose P.xy2d

end

/-! ## Conversions -/

section Conversions

variable {Q : Point}

/-- `ge_p3_to_p2` keeps the point. -/
public theorem ge_p3_to_p2.spec_proj {P : GeP3} (h : P.Ext Q) : (ge_p3_to_p2.spec P).Proj Q :=
  ⟨IsExt.isProj h.1, h.2.1, h.2.2.1, h.2.2.2.1⟩

/-- `x25519_ge_p1p1_to_p2` keeps the point. -/
public theorem x25519_ge_p1p1_to_p2.spec_proj {P : GeP1p1} (h : P.Compl Q) :
    (x25519_ge_p1p1_to_p2.spec P).Proj Q := by
  obtain ⟨hc, bX, bY, bZ, bT⟩ := h
  obtain ⟨vX, tX⟩ := fiat_25519_carry_mul.spec_val bX bT
  obtain ⟨vY, tY⟩ := fiat_25519_carry_mul.spec_val bY bZ
  obtain ⟨vZ, tZ⟩ := fiat_25519_carry_mul.spec_val bZ bT
  refine ⟨?_, tX, tY, tZ⟩
  simp only [x25519_ge_p1p1_to_p2.spec]
  rw [vX, vY, vZ]
  exact hc.isProj

/-- `x25519_ge_p1p1_to_p3` keeps the point. -/
public theorem x25519_ge_p1p1_to_p3.spec_ext {P : GeP1p1} (h : P.Compl Q) :
    (x25519_ge_p1p1_to_p3.spec P).Ext Q := by
  obtain ⟨hc, bX, bY, bZ, bT⟩ := h
  obtain ⟨vX, tX⟩ := fiat_25519_carry_mul.spec_val bX bT
  obtain ⟨vY, tY⟩ := fiat_25519_carry_mul.spec_val bY bZ
  obtain ⟨vZ, tZ⟩ := fiat_25519_carry_mul.spec_val bZ bT
  obtain ⟨vT, tT⟩ := fiat_25519_carry_mul.spec_val bX bY
  refine ⟨?_, tX, tY, tZ, tT⟩
  simp only [x25519_ge_p1p1_to_p3.spec]
  rw [vX, vY, vZ, vT]
  exact hc.isExt

/-- `x25519_ge_p3_to_cached` keeps the point. -/
public theorem x25519_ge_p3_to_cached.spec_niels {P : GeP3} (h : P.Ext Q) :
    (x25519_ge_p3_to_cached.spec P).Niels Q := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := h
  obtain ⟨vp, bp⟩ := fiat_25519_add.spec_val tY tX
  obtain ⟨vm, bm⟩ := fiat_25519_sub.spec_val tY tX.under2p
  obtain ⟨vk, tk⟩ := fd_f25519_k.val
  obtain ⟨vt, tt⟩ := fiat_25519_carry_mul.spec_val tT.loose tk.loose
  refine ⟨?_, bp, bm, tZ.loose, tt.loose⟩
  simp only [x25519_ge_p3_to_cached.spec]
  rw [vp, vm, vt, vk]
  exact IsExt.isNiels he

/-- `ge_p2_0` is the neutral point. -/
public theorem ge_p2_0.spec_proj : ge_p2_0.spec.Proj 0 := by
  obtain ⟨v0, t0⟩ := fe_0.spec_val
  obtain ⟨v1, t1⟩ := fe_1.spec_val
  refine ⟨?_, t0, t1, t1⟩
  simp only [ge_p2_0.spec, v0, v1, Point.zero_x, Point.zero_y]
  exact ⟨one_ne_zero, by ring, by ring⟩

end Conversions

/-! ## Doubling -/

section Doubling

variable {Q : Point}

/-- `ge_p2_dbl` doubles. -/
public theorem ge_p2_dbl.spec_compl {P : GeP2} (h : P.Proj Q) :
    (ge_p2_dbl.spec P).Compl (Q + Q) := by
  obtain ⟨hp, tX, tY, tZ⟩ := h
  have hc := isCompleted_dbl hp Q.on
  rw [Point.dbl_eq] at hc
  dsimp only at hc
  obtain ⟨vX2, tX2⟩ := fiat_25519_carry_square.spec_val tX.loose
  obtain ⟨vY2, tY2⟩ := fiat_25519_carry_square.spec_val tY.loose
  obtain ⟨vZ2, tZ2⟩ := fe_sq2_tt.spec_val tZ.loose
  obtain ⟨vs, bs⟩ := fiat_25519_add.spec_val tX tY
  obtain ⟨vt0, tt0⟩ := fiat_25519_carry_square.spec_val bs
  obtain ⟨vY, bY⟩ := fiat_25519_add.spec_val tY2 tX2
  obtain ⟨vZ, bZ⟩ := fiat_25519_sub.spec_val tY2 tX2.under2p
  obtain ⟨vcY, tcY⟩ := fiat_25519_carry.spec_val bY
  obtain ⟨vX, bX⟩ := fiat_25519_sub.spec_val tt0 tcY.under2p
  obtain ⟨vcZ, tcZ⟩ := fiat_25519_carry.spec_val bZ
  obtain ⟨vT, bT⟩ := fiat_25519_sub.spec_val tZ2 tcZ.under2p
  refine ⟨?_, bX, bY, bZ, bT⟩
  simp only [ge_p2_dbl.spec]
  simp only [vX, vY, vZ, vT, vt0, vcY, vcZ, vs, vY2, vX2, vZ2]
  exact hc

/-- `ge_p3_dbl` doubles. -/
public theorem ge_p3_dbl.spec_compl {P : GeP3} (h : P.Ext Q) : (ge_p3_dbl.spec P).Compl (Q + Q) :=
  ge_p2_dbl.spec_compl (ge_p3_to_p2.spec_proj h)

end Doubling

/-! ## Addition -/

section Addition

variable {A B : Point}

/-- `x25519_ge_add` adds. -/
public theorem x25519_ge_add.spec_compl {P : GeP3} {C : GeCached} (hP : P.Ext A) (hC : C.Niels B) :
    (x25519_ge_add.spec P C).Compl (A + B) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bz, bt⟩ := hC
  have hc := isCompleted_add_niels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fiat_25519_add.spec_val tY tX
  obtain ⟨vrY, brY⟩ := fiat_25519_sub.spec_val tY tX.under2p
  obtain ⟨vtZ, ttZ⟩ := fiat_25519_carry_mul.spec_val brX bp
  obtain ⟨vtY, ttY⟩ := fiat_25519_carry_mul.spec_val brY bm
  obtain ⟨vtT, ttT⟩ := fiat_25519_carry_mul.spec_val bt tT.loose
  obtain ⟨vtX, ttX⟩ := fiat_25519_carry_mul.spec_val tZ.loose bz
  obtain ⟨vrT, brT⟩ := fiat_25519_add.spec_val ttX ttX
  obtain ⟨vX, bX⟩ := fiat_25519_sub.spec_val ttZ ttY.under2p
  obtain ⟨vY, bY⟩ := fiat_25519_add.spec_val ttZ ttY
  obtain ⟨vcT, tcT⟩ := fiat_25519_carry.spec_val brT
  obtain ⟨vZ, bZ⟩ := fiat_25519_add.spec_val tcT ttT
  obtain ⟨vT, bT⟩ := fiat_25519_sub.spec_val tcT ttT.under2p
  refine ⟨?_, bX, bY, bZ, bT⟩
  simp only [x25519_ge_add.spec, Point.add_x, Point.add_y]
  rw [vX, vY, vZ, vT, vcT, vrT, vtZ, vtY, vtT, vtX, vrX, vrY, mul_comm (Limbs.val C.T2d)]
  exact hc

/-- `x25519_ge_sub` subtracts. -/
public theorem x25519_ge_sub.spec_compl {P : GeP3} {C : GeCached} (hP : P.Ext A) (hC : C.Niels B) :
    (x25519_ge_sub.spec P C).Compl (A - B) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bz, bt⟩ := hC
  have hc := isCompleted_sub_niels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fiat_25519_add.spec_val tY tX
  obtain ⟨vrY, brY⟩ := fiat_25519_sub.spec_val tY tX.under2p
  obtain ⟨vtZ, ttZ⟩ := fiat_25519_carry_mul.spec_val brX bm
  obtain ⟨vtY, ttY⟩ := fiat_25519_carry_mul.spec_val brY bp
  obtain ⟨vtT, ttT⟩ := fiat_25519_carry_mul.spec_val bt tT.loose
  obtain ⟨vtX, ttX⟩ := fiat_25519_carry_mul.spec_val tZ.loose bz
  obtain ⟨vrT, brT⟩ := fiat_25519_add.spec_val ttX ttX
  obtain ⟨vX, bX⟩ := fiat_25519_sub.spec_val ttZ ttY.under2p
  obtain ⟨vY, bY⟩ := fiat_25519_add.spec_val ttZ ttY
  obtain ⟨vcT, tcT⟩ := fiat_25519_carry.spec_val brT
  obtain ⟨vZ, bZ⟩ := fiat_25519_sub.spec_val tcT ttT.under2p
  obtain ⟨vT, bT⟩ := fiat_25519_add.spec_val tcT ttT
  refine ⟨?_, bX, bY, bZ, bT⟩
  simp only [x25519_ge_sub.spec, Point.sub_x, Point.sub_y]
  rw [vX, vY, vZ, vT, vcT, vrT, vtZ, vtY, vtT, vtX, vrX, vrY, mul_comm (Limbs.val C.T2d)]
  exact hc

/-- `ge_madd` adds. -/
public theorem ge_madd.spec_compl {P : GeP3} {C : GePrecomp} (hP : P.Ext A) (hC : C.Niels B) :
    (ge_madd.spec P C).Compl (A + B) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bt⟩ := hC
  have hc := isCompleted_add_affineNiels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fiat_25519_add.spec_val tY tX
  obtain ⟨vrY, brY⟩ := fiat_25519_sub.spec_val tY tX.under2p
  obtain ⟨vtZ, ttZ⟩ := fiat_25519_carry_mul.spec_val brX bp
  obtain ⟨vtY, ttY⟩ := fiat_25519_carry_mul.spec_val brY bm
  obtain ⟨vtT, ttT⟩ := fiat_25519_carry_mul.spec_val bt tT.loose
  obtain ⟨vrT, brT⟩ := fiat_25519_add.spec_val tZ tZ
  obtain ⟨vX, bX⟩ := fiat_25519_sub.spec_val ttZ ttY.under2p
  obtain ⟨vY, bY⟩ := fiat_25519_add.spec_val ttZ ttY
  obtain ⟨vcT, tcT⟩ := fiat_25519_carry.spec_val brT
  obtain ⟨vZ, bZ⟩ := fiat_25519_add.spec_val tcT ttT
  obtain ⟨vT, bT⟩ := fiat_25519_sub.spec_val tcT ttT.under2p
  refine ⟨?_, bX, bY, bZ, bT⟩
  simp only [ge_madd.spec, Point.add_x, Point.add_y]
  rw [vX, vY, vZ, vT, vcT, vrT, vtZ, vtY, vtT, vrX, vrY, mul_comm (Limbs.val C.xy2d)]
  exact hc

/-- `ge_msub` subtracts. -/
public theorem ge_msub.spec_compl {P : GeP3} {C : GePrecomp} (hP : P.Ext A) (hC : C.Niels B) :
    (ge_msub.spec P C).Compl (A - B) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bt⟩ := hC
  have hc := isCompleted_sub_affineNiels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fiat_25519_add.spec_val tY tX
  obtain ⟨vrY, brY⟩ := fiat_25519_sub.spec_val tY tX.under2p
  obtain ⟨vtZ, ttZ⟩ := fiat_25519_carry_mul.spec_val brX bm
  obtain ⟨vtY, ttY⟩ := fiat_25519_carry_mul.spec_val brY bp
  obtain ⟨vtT, ttT⟩ := fiat_25519_carry_mul.spec_val bt tT.loose
  obtain ⟨vrT, brT⟩ := fiat_25519_add.spec_val tZ tZ
  obtain ⟨vX, bX⟩ := fiat_25519_sub.spec_val ttZ ttY.under2p
  obtain ⟨vY, bY⟩ := fiat_25519_add.spec_val ttZ ttY
  obtain ⟨vcT, tcT⟩ := fiat_25519_carry.spec_val brT
  obtain ⟨vZ, bZ⟩ := fiat_25519_sub.spec_val tcT ttT.under2p
  obtain ⟨vT, bT⟩ := fiat_25519_add.spec_val tcT ttT
  refine ⟨?_, bX, bY, bZ, bT⟩
  simp only [ge_msub.spec, Point.sub_x, Point.sub_y]
  rw [vX, vY, vZ, vT, vcT, vrT, vtZ, vtY, vtT, vrX, vrY, mul_comm (Limbs.val C.xy2d)]
  exact hc

end Addition

/-! ## Encoding -/

section Encode

/-- `s[31] ^= b << 7` on bytes below `2²⁵⁵`: the bit `b` on top. -/
public theorem splice_sign {s : BitVec 256} (hs : s.toNat < 2 ^ 255) {c : ℕ} (hc : c < 2) :
    Memory.spliceBits s 248 (((BitVec.ofNat 32 c).setWidth 8 <<< 7#8) ^^^ s.extractLsb' 248 8) =
      BitVec.ofNat 256 (s.toNat + 2 ^ 255 * c) := by
  have h255 : s.getLsbD 255 = false := by rw [← BitVec.testBit_toNat, Nat.testBit_lt_two_pow hs]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [Memory.getLsbD_spliceBits]
  obtain rfl | rfl : c = 0 ∨ c = 1 := by omega
  · simp only [Nat.mul_zero, Nat.add_zero, BitVec.ofNat_toNat, BitVec.setWidth_eq]
    split
    · have : i - 248 < 8 := by omega
      simp [this, show 248 + (i - 248) = i by omega]
    · rfl
  · rw [BitVec.getLsbD_ofNat, Nat.mul_one, Nat.add_comm s.toNat]
    by_cases h : i < 255
    · rw [Nat.testBit_two_pow_add_gt h, BitVec.testBit_toNat]
      split
      · obtain ⟨hlo, -⟩ := ‹248 ≤ i ∧ i < 248 + 8 ∧ i < 256›
        interval_cases i <;> simp
      · simp [hi]
    · obtain rfl : i = 255 := by omega
      rw [Nat.testBit_two_pow_add_eq, BitVec.testBit_toNat, h255]
      simpa using h255

/-- `x25519_ge_tobytes` encodes the point. -/
public theorem x25519_ge_tobytes.spec_eq {P : GeP2} {Q : Point} (h : P.Proj Q) :
    x25519_ge_tobytes.spec P = encode Q := by
  obtain ⟨⟨hz, hx, hy⟩, tX, tY, tZ⟩ := h
  obtain ⟨vr, tr⟩ := fe_loose_invert.spec_val tZ.loose
  have hr : Limbs.val P.Z * Limbs.val (fe_loose_invert.spec P.Z) = 1 := by
    rw [vr, ← pow_succ', show p - 2 + 1 = p - 1 by norm_num, ZMod.pow_card_sub_one_eq_one hz]
  obtain ⟨vx, tx⟩ := fiat_25519_carry_mul.spec_val tX.loose tr.loose
  obtain ⟨vy, ty⟩ := fiat_25519_carry_mul.spec_val tY.loose tr.loose
  have ex : Limbs.val (fiat_25519_carry_mul.spec P.X (fe_loose_invert.spec P.Z)) = Q.x := by
    rw [vx, hx, mul_assoc, hr, mul_one]
  have ey : Limbs.val (fiat_25519_carry_mul.spec P.Y (fe_loose_invert.spec P.Z)) = Q.y := by
    rw [vy, hy, mul_assoc, hr, mul_one]
  have hs := fiat_25519_to_bytes.spec_val ty
  rw [ey] at hs
  have hsgn := fd_f25519_sgn.spec_val tx.under2p tx.nat_lt
  rw [ex] at hsgn
  have hlt : Q.y.val < 2 ^ 255 := (ZMod.val_lt Q.y).trans (by decide)
  simp only [x25519_ge_tobytes.spec]
  rw [hsgn,
    splice_sign
      (by
        rw [hs]; exact hlt)
      (Nat.mod_lt _ (by decide)),
    hs]
  rfl

end Encode

/-! ## Decoding -/

section Decode

/-- The candidate root `x = u (u v)^((p - 5) / 8)` has `v x² = ±u` exactly when `u / v` is a
square. -/
theorem root_iff {u v x : ZMod p} (hv : v ≠ 0) (hx : x = u * (u * v) ^ ((p - 5) / 8)) :
    (v * x ^ 2 = u ∨ v * x ^ 2 = -u) ↔ IsSquare (u / v) := by
  by_cases hu : u = 0
  · subst hu
    simp only [hx, zero_mul, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow, mul_zero,
      true_or, zero_div, true_iff]
    exact ⟨0, by ring⟩
  have hw : u * v ≠ 0 := mul_ne_zero hu hv
  set c := (u * v) ^ ((p - 1) / 4) with hc
  have hcheck : v * x ^ 2 = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, hx]
    ring
  have hc2 : c ^ 2 = (u * v) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hdiv : IsSquare (u / v) ↔ IsSquare (u * v) := by
    constructor
    · rintro ⟨r, hr⟩
      refine ⟨r * v, ?_⟩
      rw [div_eq_iff hv] at hr
      rw [hr]
      ring
    · rintro ⟨r, hr⟩
      refine ⟨r / v, ?_⟩
      rw [div_mul_div_comm, ← hr, mul_div_mul_right _ _ hv]
  rw [hcheck, hdiv, ZMod.euler_criterion p hw, ← hc2, sq_eq_one_iff']
  constructor
  · rintro (h | h)
    · exact .inl (mul_left_cancel₀ hu (by rw [h, mul_one]))
    · exact
        .inr
          (mul_left_cancel₀ hu
            (by
              rw [h]; ring))
  · rintro (h | h)
    · exact .inl (by rw [h, mul_one])
    · exact
        .inr
          (by
            rw [h]; ring)

/-- `BitVec.ofNat 32` is injective on bits. -/
theorem ofNat_bit_inj {a b : ℕ} (ha : a < 2) (hb : b < 2) :
    BitVec.ofNat 32 a = BitVec.ofNat 32 b ↔ a = b := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    simp only [BitVec.toNat_ofNat] at this
    omega
  · rintro rfl
    rfl

namespace x25519_ge_frombytes_vartime

/-- `y` holds `s`'s low 255 bits, tight. -/
theorem y_val (s : BitVec 256) :
    Limbs.val (y s) = ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧ Limbs.Tight (y s) :=
  fd_f25519_frombytes.spec_val s

/-- `u = y² - 1`, tight. -/
theorem u_val (s : BitVec 256) : Limbs.val (u s) = Limbs.val (y s) ^ 2 - 1 ∧ Limbs.Tight (u s) := by
  obtain ⟨-, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe_1.spec_val
  obtain ⟨vw, tw⟩ := fiat_25519_carry_square.spec_val ty.loose
  obtain ⟨vs, bs⟩ := fiat_25519_sub.spec_val tw t1.under2p
  obtain ⟨vc, tc⟩ := fiat_25519_carry.spec_val bs
  exact ⟨by rw [u, vc, vs, vw, v1], tc⟩

/-- `v = d y² + 1`, loose. -/
theorem v_val (s : BitVec 256) :
    Limbs.val (v s) = Ed25519.d * Limbs.val (y s) ^ 2 + 1 ∧ Limbs.Loose (v s) := by
  obtain ⟨-, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe_1.spec_val
  obtain ⟨vd, td⟩ := fd_f25519_d.val
  obtain ⟨vw, tw⟩ := fiat_25519_carry_square.spec_val ty.loose
  obtain ⟨vm, tm⟩ := fiat_25519_carry_mul.spec_val tw.loose td.loose
  obtain ⟨va, ba⟩ := fiat_25519_add.spec_val tm t1
  exact
    ⟨by
      rw [v, va, vm, vw, vd, v1]; ring, ba⟩

/-- The candidate `x = u (u v)^((p - 5) / 8)`, tight. -/
theorem x_val (s : BitVec 256) :
    Limbs.val (x s) = Limbs.val (u s) * (Limbs.val (u s) * Limbs.val (v s)) ^ ((p - 5) / 8) ∧
      Limbs.Tight (x s) := by
  obtain ⟨-, tu⟩ := u_val s
  obtain ⟨-, bv⟩ := v_val s
  obtain ⟨vw, tw⟩ := fiat_25519_carry_mul.spec_val tu.loose bv
  obtain ⟨vp, tp⟩ := fd_f25519_pow22523.spec_val tw.loose
  obtain ⟨vx, tx⟩ := fiat_25519_carry_mul.spec_val tp.loose tu.loose
  exact
    ⟨by
      rw [x, vx, vp, vw]; ring, tx⟩

/-- `v x²`, tight. -/
theorem vxx_val (s : BitVec 256) :
    Limbs.val (vxx s) = Limbs.val (v s) * Limbs.val (x s) ^ 2 ∧ Limbs.Tight (vxx s) := by
  obtain ⟨-, bv⟩ := v_val s
  obtain ⟨-, tx⟩ := x_val s
  obtain ⟨vq, tq⟩ := fiat_25519_carry_square.spec_val tx.loose
  obtain ⟨vm, tm⟩ := fiat_25519_carry_mul.spec_val tq.loose bv
  exact
    ⟨by
      rw [vxx, vm, vq]; ring, tm⟩

/-- The first check passes exactly when `v x² = u`. -/
theorem check₁_eq_zero (s : BitVec 256) :
    check₁ s = 0#32 ↔ Limbs.val (v s) * Limbs.val (x s) ^ 2 = Limbs.val (u s) := by
  obtain ⟨vv, tv⟩ := vxx_val s
  obtain ⟨-, tu⟩ := u_val s
  obtain ⟨vs, bs⟩ := fiat_25519_sub.spec_val tv tu.under2p
  rw [check₁, fe_isnonzero_fe_loose.spec_val bs, vs, vv]
  simp only [sub_eq_zero]
  split <;> simp_all

/-- The second check passes exactly when `v x² = -u`. -/
theorem check₂_eq_zero (s : BitVec 256) :
    check₂ s = 0#32 ↔ Limbs.val (v s) * Limbs.val (x s) ^ 2 = -Limbs.val (u s) := by
  obtain ⟨vv, tv⟩ := vxx_val s
  obtain ⟨-, tu⟩ := u_val s
  obtain ⟨va, ba⟩ := fiat_25519_add.spec_val tv tu
  rw [check₂, fe_isnonzero_fe_loose.spec_val ba, va, vv]
  simp only [add_eq_zero_iff_eq_neg]
  split <;> simp_all

/-- On the curve with `s`'s `y` exactly when `v x² = u`. -/
theorem onCurve_iff (s : BitVec 256) (a : ZMod p) :
    OnCurve a (Limbs.val (y s)) ↔ Limbs.val (v s) * a ^ 2 = Limbs.val (u s) := by
  rw [Ed25519.onCurve_iff, (v_val s).1, (u_val s).1]
  constructor <;> intro h <;> linear_combination h

/-- The sign `s` asks for: its top bit. -/
theorem sign (s : BitVec 256) :
    (s.extractLsb' 248 8 >>> 7).setWidth 32 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := s.isLt
  omega

/-- `point s X` for a root `X` is the point `s` encodes, `Z = 1`. -/
theorem point_ext {s : BitVec 256} {X : Fin 5 → BitVec 64} (hX : Limbs.Tight X)
    (hr : OnCurve (Limbs.val X) (Limbs.val (y s))) :
    ∃ Q, decode s = some Q ∧ (point s X).Ext Q ∧ Limbs.val (point s X).Z = 1 := by
  obtain ⟨vy, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe_1.spec_val
  have hb : s.toNat / 2 ^ 255 < 2 := by
    have := s.isLt
    omega
  have hpar : (Limbs.val X).val % 2 < 2 := Nat.mod_lt _ (by decide)
  -- the sign fixed: `X`, or `-X` carried
  obtain ⟨X', hX', tX', hc, hd⟩ :
    ∃ X',
      signed s X = X' ∧
        Limbs.Tight X' ∧
        (Limbs.val X' = Limbs.val X ∨ Limbs.val X' = -Limbs.val X) ∧
        (Limbs.val X' = 0 ∨ (Limbs.val X').val % 2 = s.toNat / 2 ^ 255) :=
    by
    refine ⟨_, rfl, ?_⟩
    simp only [signed, fd_f25519_sgn.spec_val hX.under2p hX.nat_lt, sign, ofNat_bit_inj hpar hb]
    split
    · exact ⟨hX, .inl rfl, .inr ‹_›⟩
    · obtain ⟨vo, bo⟩ := fiat_25519_opp.spec_val hX
      obtain ⟨vc, tc⟩ := fiat_25519_carry.spec_val bo
      refine ⟨tc, .inr (vc.trans vo), ?_⟩
      rw [vc, vo]
      by_cases h0 : Limbs.val X = 0
      · exact .inl (by rw [h0, neg_zero])
      · refine .inr ?_
        have hn : (-Limbs.val X).val = p - (Limbs.val X).val := by
          rw [ZMod.neg_val, ite_eq_right h0]
        have hlt := ZMod.val_lt (Limbs.val X)
        have hpos : 0 < (Limbs.val X).val := (ZMod.val_pos).2 h0
        have hp2 : p % 2 = 1 := by norm_num
        rw [hn]
        omega
  have hon : OnCurve (Limbs.val X') (Limbs.val (y s)) := by
    rcases hc with h | h <;> rw [h]
    · exact hr
    · exact hr.neg
  obtain ⟨vT, tT⟩ := fiat_25519_carry_mul.spec_val tX'.loose ty.loose
  refine ⟨⟨_, _, hon⟩, decode_eq_some ⟨vy, hd⟩, ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩, v1⟩
  all_goals simp only [point, hX']
  · rw [v1]; exact one_ne_zero
  · rw [v1, mul_one]
  · rw [v1, mul_one]
  · rw [vT, v1, mul_one]
  · exact ⟨tX', ty, t1, tT⟩

end x25519_ge_frombytes_vartime

open x25519_ge_frombytes_vartime in
/-- `x25519_ge_frombytes_vartime` fails exactly when `decode` does. -/
public theorem x25519_ge_frombytes_vartime.spec_eq_none_iff (s : BitVec 256) :
    x25519_ge_frombytes_vartime.spec s = none ↔ decode s = none := by
  have hv : Limbs.val (v s) ≠ 0 := by
    rw [(v_val s).1]
    exact v_ne _
  have key := root_iff (x := Limbs.val (x s)) hv (x_val s).1
  rw [decode_eq_none, ← not_exists, exists_decodes_iff, ← (y_val s).1, exists_onCurve_iff, ←
    (u_val s).1, ← (v_val s).1, ← key, ← check₁_eq_zero, ← check₂_eq_zero]
  simp only [x25519_ge_frombytes_vartime.spec]
  split_ifs <;> simp_all

open x25519_ge_frombytes_vartime in
/-- A point `x25519_ge_frombytes_vartime` decodes is the one `decode` finds, `Z = 1`. -/
public theorem x25519_ge_frombytes_vartime.spec_some {s : BitVec 256} {P : GeP3}
    (h : x25519_ge_frombytes_vartime.spec s = some P) :
    ∃ Q, decode s = some Q ∧ P.Ext Q ∧ Limbs.val P.Z = 1 := by
  obtain ⟨vx, tx⟩ := x_val s
  simp only [x25519_ge_frombytes_vartime.spec] at h
  split_ifs at h with h1 h2
  · obtain rfl := Option.some.inj h
    exact point_ext tx ((onCurve_iff s _).2 ((check₁_eq_zero s).1 h1))
  · obtain rfl := Option.some.inj h
    obtain ⟨vi, ti⟩ := fd_f25519_sqrtm1.val
    obtain ⟨vm, tm⟩ := fiat_25519_carry_mul.spec_val tx.loose ti.loose
    refine point_ext tm ((onCurve_iff s _).2 ?_)
    rw [vm, vi, mul_pow, sqrtM1_sq, ← mul_assoc, (check₂_eq_zero s).1 h2]
    ring

end Decode

end MLIR.Boringssl

module

public import Firedancer.Math.Decode
public import Firedancer.Math.R52x5.Pow
public import Firedancer.Math.R52x5.Mul
public import Firedancer.Math.R52x5.Equal
public import Firedancer.R52x5.fd_ed25519_point_frombytes_2x
import Firedancer.Math.Sqrt
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! `fd_r52x5_ge_decode2` (`FD_R52X5_GE_DECODE2`, `frombytes_2x`) as point decompression: each
encoding's checks pass exactly when a point with its `y` exists, and then the QUAD it stores is that
point, affine, of the parity its top bit asks for (any sign for `x = 0`, as Dalek and Ref). -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open MLIR.Firedancer.Ref (sqrt_ratio_iff flags_and_eq_zero ofNat_bit_inj neg_one_ne_bit)
open MLIR.Firedancer.Ref.Ed25519 (OnCurve exists_decodes_iff)
open MLIR.Firedancer.Ref.Ed25519 (v_ne exists_onCurve_iff decodes_of_decode)
open Firedancer.Avx512 (Wwl)
open fd_r52x5_ge_decode2

/-! ## Constants, `PACK` and `UNPACK` -/

section Lanes

/-- `1`, `d` and `√-1`, reduced. -/
theorem consts :
    (val fd_f25519_one.vec = 1 ∧ Below 52 fd_f25519_one.vec) ∧
      (val fd_f25519_d.vec = Ref.Ed25519.d ∧ Below 52 fd_f25519_d.vec) ∧
      (val fd_f25519_sqrtm1.vec = Ref.sqrtM1 ∧ Below 52 fd_f25519_sqrtm1.vec) := by
  refine ⟨⟨?_, by decide⟩, ⟨?_, by decide⟩, ⟨?_, by decide⟩⟩
  · rw [val, fd_f25519_one.limbs_eq]
    simp [Ref.Limbs.val_eq, Ref.fd_f25519_one.limbs]
  · rw [val, fd_f25519_d.limbs_eq]
    exact Ref.fd_f25519_d.val.1
  · rw [val, fd_f25519_sqrtm1.limbs_eq]
    exact Ref.fd_f25519_sqrtm1.val.1

/-- `PACK`'s coordinates: the field elements' limbs. -/
theorem pack_elem (x y z t : Wwl) (j : Fin 4) :
    (Quad5.pack x y z t).elem j = limbs (![x, y, z, t] j) := by
  funext i
  fin_cases j <;> fin_cases i <;> rfl

/-- `PACK` of field elements with limbs below `2^52`: their values. -/
theorem pack_is {x y z t : Wwl} (hx : Below 52 x) (hy : Below 52 y) (hz : Below 52 z)
    (ht : Below 52 t) :
    (Quad5.pack x y z t).Below 52 ∧ (Quad5.pack x y z t).val 0 = val x ∧
      (Quad5.pack x y z t).val 1 = val y ∧ (Quad5.pack x y z t).val 2 = val z ∧
      (Quad5.pack x y z t).val 3 = val t := by
  refine ⟨fun j i => ?_, ?_, ?_, ?_, ?_⟩
  · rw [pack_elem]
    fin_cases j
    exacts [hx.2 i, hy.2 i, hz.2 i, ht.2 i]
  all_goals rw [Quad5.val, pack_elem]; rfl

/-- `UNPACK`'s `x` and `y`: coordinates 0 and 1, lanes 5-7 zero. -/
theorem unpack_xy {Q : Quad5} (h : Q.Below 52) :
    (val Q.unpack.1 = Q.val 0 ∧ Below 52 Q.unpack.1) ∧
      (val Q.unpack.2.1 = Q.val 1 ∧ Below 52 Q.unpack.2.1) := by
  have e0 : limbs Q.unpack.1 = Q.elem 0 := funext fun i => by fin_cases i <;> rfl
  have e1 : limbs Q.unpack.2.1 = Q.elem 1 := funext fun i => by fin_cases i <;> rfl
  refine ⟨⟨by rw [val, e0], ⟨rfl, rfl, rfl⟩, fun i => by rw [e0]; exact h 0 i⟩,
    ⟨by rw [val, e1], ⟨rfl, rfl, rfl⟩, fun i => by rw [e1]; exact h 1 i⟩⟩

/-- The power's lanes 0 and 1: `A`'s and `B`'s `(u v⁷)^((p-5)/8)`, reduced. -/
theorem pow_unpack {A B : Pre} (hA : Below 52 A.uv7) (hB : Below 52 B.uv7) :
    let Qx := (pow22523Q (quv A B)).unpack
    (val Qx.1 = val A.uv7 ^ ((p - 5) / 8) ∧ Below 52 Qx.1) ∧
      (val Qx.2.1 = val B.uv7 ^ ((p - 5) / 8) ∧ Below 52 Qx.2.1) := by
  obtain ⟨bq, vq0, vq1, -, -⟩ := pack_is hA hB hA hB
  dsimp only [quv]
  obtain ⟨bp, vp⟩ := pow22523Q_spec bq
  obtain ⟨⟨v0, b0⟩, ⟨v1, b1⟩⟩ := unpack_xy bp
  exact ⟨⟨by rw [v0, vp, vq0], b0⟩, ⟨by rw [v1, vp, vq1], b1⟩⟩

end Lanes

/-! ## One encoding's checks -/

section Dec

/-- `buf2`'s copy: the encoding, bit 255 cleared. -/
theorem yBits_eq (s : BitVec 256) : yBits s = s &&& BitVec.ofNat 256 (2 ^ 255 - 1) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [yBits, Memory.getLsbD_spliceBits]
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_extractLsb', BitVec.getLsbD_ofNat,
    Nat.testBit_two_pow_sub_one]
  by_cases h : 248 ≤ i
  · rw [ite_eq_left ⟨h, by omega, hi⟩, show 248 + (i - 248) = i by omega]
    have : (127 : ℕ) = 2 ^ 7 - 1 := rfl
    simp only [this, Nat.testBit_two_pow_sub_one]
    by_cases h7 : i < 255
    · simp [h7, hi, show i - 248 < 7 by omega, show i - 248 < 8 by omega]
    · simp [h7, hi]; omega
  · rw [ite_eq_right (by omega)]
    simp [hi, show i < 255 by omega]

/-- `buf2`'s copy has the encoding's limbs. -/
theorem limbs_yBits (s : BitVec 256) (i : Fin 5) :
    limbs (fd_f25519_frombytes.spec (yBits s)) i = Ref.fd_f25519_frombytes.spec s i := by
  rw [fd_f25519_frombytes.limbs_spec, yBits_eq]
  obtain ⟨i, hi⟩ := i
  obtain rfl | rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 ∨ i = 4 := by omega
  all_goals
    simp only [Ref.fd_f25519_frombytes.spec, Ref.fiat_25519_from_bytes.spec]
    bv_decide

/-- The sign `x_0`: the encoding's top bit. -/
theorem sign_pre (s : BitVec 256) :
    (s.extractLsb' 248 8).setWidth 32 >>> 7 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := s.isLt
  omega

/-- One encoding up to the power: `y` its low 255 bits, `u = y² - 1`, `v = d y² + 1`, `u v³`,
`u v⁷`, all reduced, and `x_0` its top bit. -/
theorem pre_spec (s : BitVec 256) :
    let A := pre s
    let y : ZMod p := ((s.toNat % 2 ^ 255 : ℕ) : ZMod p)
    let u := y ^ 2 - 1
    let v := Ref.Ed25519.d * y ^ 2 + 1
    (val A.y = y ∧ Below 52 A.y) ∧ (val A.u = u ∧ Below 52 A.u) ∧
      (val A.v = v ∧ Below 52 A.v) ∧ (val A.uv3 = u * v ^ 3 ∧ Below 52 A.uv3) ∧
      (val A.uv7 = u * v ^ 7 ∧ Below 52 A.uv7) ∧ A.x0 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := by
  intro A y u v
  obtain ⟨⟨v1, b1⟩, ⟨vd, bd⟩, -⟩ := consts
  have hy : val A.y = y ∧ Below 52 A.y := by
    obtain ⟨hv, ht⟩ := Ref.fd_f25519_frombytes.spec_val s
    have e : limbs A.y = Ref.fd_f25519_frombytes.spec s := funext (limbs_yBits s)
    refine ⟨by rw [val, e, hv], ⟨rfl, rfl, rfl⟩, fun i => ?_⟩
    rw [e]
    exact (ht i).trans_lt (by norm_num)
  obtain ⟨vq, bq⟩ := fd_f25519_sqr.spec_val hy.2
  obtain ⟨vu, bu⟩ := fd_f25519_sub.spec_val (bq.lt (by norm_num)) (b1.lt (by norm_num))
  obtain ⟨vm, bm⟩ := fd_f25519_mul.spec_val bd bq
  obtain ⟨vv, bv⟩ := fd_f25519_add.spec_val (bm.lt (by norm_num)) (b1.lt (by norm_num))
  have hu : val A.u = u ∧ Below 52 A.u := by
    refine ⟨?_, bu⟩
    change val (fd_f25519_sub.spec (fd_f25519_sqr.spec A.y) fd_f25519_one.vec) = _
    rw [vu, vq, hy.1, v1]
  have hv : val A.v = v ∧ Below 52 A.v := by
    refine ⟨?_, bv⟩
    change val (fd_f25519_add.spec (fd_f25519_mul.spec fd_f25519_d.vec
      (fd_f25519_sqr.spec A.y)) fd_f25519_one.vec) = _
    rw [vv, vm, vq, hy.1, vd, v1]
  obtain ⟨v2, b2⟩ := fd_f25519_sqr.spec_val hv.2
  obtain ⟨v4, b4⟩ := fd_f25519_sqr.spec_val b2
  obtain ⟨v3, b3⟩ := fd_f25519_mul.spec_val hv.2 b2
  obtain ⟨w3, c3⟩ := fd_f25519_mul.spec_val hu.2 b3
  have h3 : val A.uv3 = u * v ^ 3 ∧ Below 52 A.uv3 := by
    refine ⟨?_, c3⟩
    change val (fd_f25519_mul.spec A.u (fd_f25519_mul.spec A.v (fd_f25519_sqr.spec A.v))) = _
    rw [w3, v3, v2, hu.1, hv.1]
    ring
  obtain ⟨w7, c7⟩ := fd_f25519_mul.spec_val h3.2 b4
  refine ⟨hy, hu, hv, h3, ⟨?_, c7⟩, sign_pre s⟩
  change val (fd_f25519_mul.spec A.uv3 (fd_f25519_sqr.spec (fd_f25519_sqr.spec A.v))) = _
  rw [w7, v4, v2, h3.1, hv.1]
  ring

/-- One encoding's checks, its power `xp` being `(u v⁷)^((p-5)/8)`: `x = u v³ (u v⁷)^((p-5)/8)`
the candidate root, `t1nz` and `t2nz` whether `v x² ∓ u` are nonzero. -/
theorem dec_spec (s : BitVec 256) {xp : Wwl}
    (hxp : val xp = val (pre s).uv7 ^ ((p - 5) / 8)) (bxp : Below 52 xp) :
    let D := dec (pre s) xp
    let y : ZMod p := ((s.toNat % 2 ^ 255 : ℕ) : ZMod p)
    let u := y ^ 2 - 1
    let v := Ref.Ed25519.d * y ^ 2 + 1
    (val D.y = y ∧ Below 52 D.y) ∧
      (val D.x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8) ∧ Below 52 D.x) ∧
      D.x0 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) ∧
      D.t1nz = (if v * val D.x ^ 2 - u = 0 then 0 else 1) ∧
      D.t2nz = (if v * val D.x ^ 2 + u = 0 then 0 else 1) := by
  intro D y u v
  obtain ⟨hy, ⟨vu, bu⟩, ⟨vv, bv⟩, ⟨w3, c3⟩, ⟨w7, -⟩, hx0⟩ := pre_spec s
  obtain ⟨vx, bx⟩ := fd_f25519_mul.spec_val bxp c3
  have hx : val D.x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8) ∧ Below 52 D.x := by
    refine ⟨?_, bx⟩
    change val (fd_f25519_mul.spec xp (pre s).uv3) = _
    rw [vx, hxp, w7, w3]
    generalize (p - 5) / 8 = e
    ring
  obtain ⟨vx2, bx2⟩ := fd_f25519_sqr.spec_val hx.2
  obtain ⟨vm, bm⟩ := fd_f25519_mul.spec_val bv bx2
  have hm : val (fd_f25519_mul.spec (pre s).v (fd_f25519_sqr.spec D.x)) = v * val D.x ^ 2 := by
    rw [vm, vx2, vv]
  obtain ⟨vs, -⟩ := fd_f25519_sub.spec_val (bm.lt (by norm_num)) (bu.lt (by norm_num))
  obtain ⟨va, -⟩ := fd_f25519_add.spec_val (bm.lt (by norm_num)) (bu.lt (by norm_num))
  refine ⟨hy, hx, hx0, ?_, ?_⟩
  · change fd_f25519_is_nonzero.spec (fd_f25519_sub.spec
      (fd_f25519_mul.spec (pre s).v (fd_f25519_sqr.spec D.x)) (pre s).u) = _
    rw [fd_f25519_is_nonzero.spec_val, vs, hm, vu]
  · change fd_f25519_is_nonzero.spec (fd_f25519_add.spec
      (fd_f25519_mul.spec (pre s).v (fd_f25519_sqr.spec D.x)) (pre s).u) = _
    rw [fd_f25519_is_nonzero.spec_val, va, hm, vu]

/-- `Dec.err` is the flags' `&` being nonzero. -/
theorem Dec.err_eq_false (D : Dec) : D.err = false ↔ D.t2nz &&& D.t1nz = 0#32 := by
  simp [Dec.err]

/-- An encoding's checks pass exactly when `decode` succeeds. -/
theorem dec_ok_iff (s : BitVec 256) {xp : Wwl}
    (hxp : val xp = val (pre s).uv7 ^ ((p - 5) / 8)) (bxp : Below 52 xp) :
    (dec (pre s) xp).err = false ↔ Ref.Ed25519.decode s ≠ none := by
  obtain ⟨-, ⟨hx, -⟩, -, h1, h2⟩ := dec_spec s hxp bxp
  rw [ne_eq, Ref.Ed25519.decode_eq_none, not_forall_not, exists_decodes_iff, Dec.err_eq_false,
    h1, h2, flags_and_eq_zero, exists_onCurve_iff]
  generalize ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) = y at hx ⊢
  rw [← sqrt_ratio_iff (v_ne y) hx]
  generalize val (dec (pre s) xp).x = x
  constructor
  · rintro (h | h)
    · exact .inr (by linear_combination h)
    · exact .inl (by linear_combination h)
  · rintro (h | h)
    · exact .inr (by linear_combination h)
    · exact .inl (by linear_combination h)

/-- `(x_mod_2 != x_0)` widened is zero exactly when the bits agree. -/
theorem ofBool_bne_eq_zero (a b : BitVec 32) :
    (BitVec.ofBool (a != b)).setWidth 32 = 0 ↔ a = b := by
  by_cases h : a = b
  · simp [h]
  · rw [show (a != b) = true by simpa using h, iff_false_intro h]
    decide

/-- The sign fix-up: `x` kept if its parity is `b`, else `fd_f25519_neg`ated; the result is
reduced, `±x`, and zero or of parity `b`. -/
theorem fixSign {x : Wwl} (hx : Below 52 x) {b : ℕ} (hb : b < 2) :
    let x' := fd_f25519_if.spec
      ((BitVec.ofBool (fd_f25519_sgn.spec x != BitVec.ofNat 32 b)).setWidth 32)
      (fd_f25519_neg.spec x) x
    (val x' = val x ∨ val x' = -val x) ∧ Below 52 x' ∧ (val x' = 0 ∨ (val x').val % 2 = b) := by
  dsimp only
  rw [fd_f25519_if.spec, fd_f25519_sgn.spec_val]
  obtain ⟨vn, bn⟩ := fd_f25519_neg.spec_val (hx.lt (by norm_num))
  by_cases h1 : BitVec.ofNat 32 ((val x).val % 2) = BitVec.ofNat 32 b
  · rw [ite_eq_left ((ofBool_bne_eq_zero _ _).2 h1)]
    exact ⟨.inl rfl, hx, .inr ((ofNat_bit_inj (Nat.mod_lt _ (by decide)) hb).1 h1)⟩
  rw [ite_eq_right (mt (ofBool_bne_eq_zero _ _).1 h1)]
  refine ⟨.inr vn, bn, ?_⟩
  by_cases h0 : val x = 0
  · exact .inl (by rw [vn, h0, neg_zero])
  refine .inr ?_
  have hne : (val x).val % 2 ≠ b := fun e => h1 (by rw [e])
  rw [vn, ZMod.neg_val, ite_eq_right h0]
  have := ZMod.val_lt (val x)
  have : (val x).val ≠ 0 := by rwa [ne_eq, ZMod.val_eq_zero]
  have hp : p % 2 = 1 := by norm_num
  omega

/-- A passing encoding's QUAD is the point that decodes from it, affine and reduced. -/
theorem dec_point (s : BitVec 256) {xp : Wwl}
    (hxp : val xp = val (pre s).uv7 ^ ((p - 5) / 8)) (bxp : Below 52 xp)
    (h : (dec (pre s) xp).err = false) :
    ∃ P, Ref.Ed25519.Decodes s P ∧ (dec (pre s) xp).point.Affine P.x P.y ∧
      (dec (pre s) xp).point.Below 52 := by
  obtain ⟨⟨vy, by'⟩, ⟨vx, bx⟩, ex0, h1, h2⟩ := dec_spec s hxp bxp
  obtain ⟨⟨v1, b1⟩, -, ⟨vi, bi⟩⟩ := consts
  generalize hD : dec (pre s) xp = D at vy by' vx bx ex0 h1 h2 h
  have hok := h
  rw [Dec.err_eq_false, h1, h2, flags_and_eq_zero] at hok
  have hb : s.toNat / 2 ^ 255 < 2 := by have := s.isLt; omega
  -- the root: `x`, or `x √-1` when `v x² ≠ u`
  have hroot : Below 52 (fd_f25519_mul.spec D.x
        (fd_f25519_if.spec D.t1nz fd_f25519_sqrtm1.vec fd_f25519_one.vec)) ∧
      OnCurve (val (fd_f25519_mul.spec D.x
        (fd_f25519_if.spec D.t1nz fd_f25519_sqrtm1.vec fd_f25519_one.vec))) (val D.y) := by
    rw [Ref.Ed25519.onCurve_iff, vy, fd_f25519_if.spec]
    by_cases h0 : (Ref.Ed25519.d * ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 + 1) *
        val D.x ^ 2 - (((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 - 1) = 0
    · rw [h1, ite_eq_left h0, ite_eq_left rfl]
      obtain ⟨vm, bm⟩ := fd_f25519_mul.spec_val bx b1
      refine ⟨bm, ?_⟩
      rw [vm, v1]
      linear_combination h0
    · rw [h1, ite_eq_right h0, ite_eq_right (by decide)]
      obtain ⟨vm, bm⟩ := fd_f25519_mul.spec_val bx bi
      refine ⟨bm, ?_⟩
      rw [vm, vi]
      have e := hok.resolve_right h0
      linear_combination (-1 : ZMod p) * e + val D.x ^ 2 * (Ref.Ed25519.d *
        (((s.toNat % 2 ^ 255 : ℕ) : ZMod p)) ^ 2 + 1) * Ref.sqrtM1_sq
  obtain ⟨br, hc⟩ := hroot
  have hs := fixSign br hb
  rw [← ex0] at hs
  simp only [Dec.point]
  generalize fd_f25519_mul.spec D.x
    (fd_f25519_if.spec D.t1nz fd_f25519_sqrtm1.vec fd_f25519_one.vec) = R at br hc hs ⊢
  generalize fd_f25519_if.spec ((BitVec.ofBool (fd_f25519_sgn.spec R != D.x0)).setWidth 32)
    (fd_f25519_neg.spec R) R = X at hs ⊢
  obtain ⟨hX, bX, hp⟩ := hs
  have cX : OnCurve (val X) (val D.y) := by
    rcases hX with hX | hX <;> rw [hX]
    exacts [hc, hc.neg]
  obtain ⟨vm, bm⟩ := fd_f25519_mul.spec_val bX by'
  obtain ⟨bq, vq0, vq1, vq2, vq3⟩ := pack_is bX by' b1 bm
  exact ⟨⟨val X, val D.y, cX⟩, ⟨vy, hp⟩, ⟨vq0, vq1, vq2.trans v1, vq3.trans vm⟩, bq⟩

end Dec

/-! ## The decoder -/

section Decode

open Ref.Ed25519 (decode)

/-- `fd_r52x5_ge_decode2` of the encodings `sa` and `sb`: `-1`, `Pa` untouched and `Pb` neutral when
`sa` does not decode, else `-2` and the same when `sb` does not, else `0` and the two points
`decode` finds, affine and reduced. -/
public theorem fd_r52x5_ge_decode2.spec_decode (sa sb : BitVec 256) :
    let R := fd_r52x5_ge_decode2.spec sa sb
    (decode sa = none → R = (-1, none, quadZero)) ∧
      (∀ P, decode sa = some P → decode sb = none → R = (-2, none, quadZero)) ∧
      ∀ P Q, decode sa = some P → decode sb = some Q →
        ∃ A B, R = (0, some A, B) ∧ A.Affine P.x P.y ∧ A.Below 52 ∧ B.Affine Q.x Q.y ∧
          B.Below 52 := by
  intro R
  obtain ⟨-, -, -, -, ⟨-, ba⟩, -⟩ := pre_spec sa
  obtain ⟨-, -, -, -, ⟨-, bb⟩, -⟩ := pre_spec sb
  obtain ⟨⟨va, ba'⟩, ⟨vb, bb'⟩⟩ := pow_unpack ba bb
  have hR : R = let Qx := (pow22523Q (quv (pre sa) (pre sb))).unpack
      if (dec (pre sa) Qx.1).err then (-1, none, quadZero)
      else if (dec (pre sb) Qx.2.1).err then (-2, none, quadZero)
      else (0, some (dec (pre sa) Qx.1).point, (dec (pre sb) Qx.2.1).point) := rfl
  dsimp only at hR
  clear_value R
  generalize (pow22523Q (quv (pre sa) (pre sb))).unpack = Qx at va ba' vb bb' hR
  have ea := dec_ok_iff sa va ba'
  have eb := dec_ok_iff sb vb bb'
  have pa := dec_point sa va ba'
  have pb := dec_point sb vb bb'
  generalize dec (pre sa) Qx.1 = Da at ea pa hR
  generalize dec (pre sb) Qx.2.1 = Db at eb pb hR
  rw [hR]
  refine ⟨fun ha => ?_, fun P ha hb => ?_, fun P Q ha hb => ?_⟩
  · have : Da.err = true := by
      rw [← Bool.not_eq_false, ea, ha]
      simp
    rw [ite_eq_left this]
  · have h1 : Da.err = false := ea.2 (by rw [ha]; simp)
    have h2 : Db.err = true := by
      rw [← Bool.not_eq_false, eb, hb]
      simp
    rw [ite_eq_right (by rw [h1]; decide), ite_eq_left h2]
  · have h1 : Da.err = false := ea.2 (by rw [ha]; simp)
    have h2 : Db.err = false := eb.2 (by rw [hb]; simp)
    obtain ⟨P', hP', a1, a2⟩ := pa h1
    obtain ⟨Q', hQ', b1, b2⟩ := pb h2
    rw [(decodes_of_decode ha).unique hP', (decodes_of_decode hb).unique hQ']
    rw [ite_eq_right (by rw [h1]; decide), ite_eq_right (by rw [h2]; decide)]
    exact ⟨_, _, rfl, a1, a2, b1, b2⟩

/-- `frombytes_2x` (`FD_R52X5_GE_DECODE2`): `-1`, `r1` untouched and `r2` neutral when `e1` does
not decode, else `-2` and the same when `e2` does not, else `0` and the two points `decode` finds,
affine and reduced. -/
public theorem fd_ed25519_point_frombytes_2x.spec_decode (e1 e2 : BitVec 256) :
    let R := fd_ed25519_point_frombytes_2x.spec e1 e2
    (decode e1 = none → R = (-1, none, quadZero)) ∧
      (∀ P, decode e1 = some P → decode e2 = none → R = (-2, none, quadZero)) ∧
      ∀ P Q, decode e1 = some P → decode e2 = some Q →
        ∃ A B, R = (0, some A, B) ∧ A.Affine P.x P.y ∧ A.Below 52 ∧ B.Affine Q.x Q.y ∧
          B.Below 52 :=
  fd_r52x5_ge_decode2.spec_decode e1 e2

end Decode

end MLIR.Firedancer.R52x5

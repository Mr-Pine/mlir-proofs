module

public import Firedancer.Math.Lane.Tobytes
public import Firedancer.Math.Avx512.Point
public import Firedancer.Math.Avx512.Mul
public import Firedancer.Math.Avx512.Unpack
public import Firedancer.Math.Avx512.F25519
public import Firedancer.Lane.fd_ed25519_point_frombytes
public import Ed25519.Decode
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.IntervalCases
import Std.Tactic.BVDecide

/-! `fd_ed25519_point_frombytes` as point decompression: `none` exactly when no point decodes, else
the decoded point, affine and folded. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 Firedancer.Avx512.R43x6
open _root_.Ed25519 (p)

/-- `fd_f25519_frombytes`' lanes: the encoding's low 255 bits. -/
theorem wvNat_fe (b : BitVec 256) :
    wvNat (Vector.ofFn fun i => Ty.extractVecElem 4 64 i b &&& feMask[i]) = b.toNat % 2 ^ 255 := by
  simp only [wvNat, Vector.getElem_ofFn, Ty.extractVecElem_eq, feMask, Fin.getElem_fin,
    Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
    BitVec.toNat_and, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow, BitVec.reduceToNat]
  rw [show (18446744073709551615 : ℕ) = 2 ^ 64 - 1 from rfl,
    show (9223372036854775807 : ℕ) = 2 ^ 63 - 1 from rfl]
  simp only [Nat.and_two_pow_sub_one_eq_mod]
  have := b.isLt
  omega

/-- `fd_r43x6_one()`: `1`, folded. -/
theorem one_spec : val one = 1 ∧ Folded one :=
  ⟨by decide, by decide⟩

/-- `fd_r43x6_d()`: `d`, folded. -/
theorem d_spec : val fd_r43x6_ge_decode2.d = Ed25519.d ∧ Folded fd_r43x6_ge_decode2.d :=
  ⟨by unfold Ed25519.d; decide, by decide⟩

/-- The values `spec` computes before the root: `y` the encoding's low 255 bits, `u = y² - 1`,
`v = d y² + 1`. -/
theorem frombytes_vals (b : BitVec 256) :
    val (feFrombytes b) = ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧ Folded (feFrombytes b) ∧
      val (fd_f25519_sub.spec (fd_r43x6_sqr (feFrombytes b)) one) =
        ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 - 1 ∧
      Folded (fd_f25519_sub.spec (fd_r43x6_sqr (feFrombytes b)) one) ∧
      val (Avx512.fold (wwl_add (fd_r43x6_mul (fd_r43x6_sqr (feFrombytes b))
          fd_r43x6_ge_decode2.d) one)) =
        Ed25519.d * ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 + 1 ∧
      Folded (Avx512.fold (wwl_add (fd_r43x6_mul (fd_r43x6_sqr (feFrombytes b))
          fd_r43x6_ge_decode2.d) one)) := by
  obtain ⟨hn, hv, hu, -, -⟩ :=
    fd_r43x6_unpack_spec (Vector.ofFn fun i => Ty.extractVecElem 4 64 i b &&& feMask[i])
  have fy : Folded (feFrombytes b) := by
    rw [wvNat_fe] at hn
    have := Nat.mod_lt b.toNat (show 2 ^ 255 > 0 by decide)
    obtain ⟨a0, a1, a2, a3, a4, a5, a6⟩ := hu
    unfold nat at hn
    unfold feFrombytes
    exact ⟨by omega, by omega, by omega, by omega, by omega, by omega, a6⟩
  have vy : val (feFrombytes b) = ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
    rw [feFrombytes, hv, wvNat_fe]
  have uy : Unreduced (feFrombytes b) := ⟨hu.unsigned.mono (by decide), hu.2.2.2.2.2.2⟩
  obtain ⟨vq, fq⟩ := fd_r43x6_sqr_spec uy
  obtain ⟨v1, f1⟩ := one_spec
  obtain ⟨vd, fd⟩ := d_spec
  obtain ⟨vs, fs⟩ := fd_f25519_sub_spec ((fq.unsigned.mono (by decide)).signed (by decide))
    ((f1.unsigned.mono (by decide)).signed (by decide))
  obtain ⟨vm, fm⟩ := fd_r43x6_mul_spec (fq.unsigned.mono (by decide)) fd.unreduced
  obtain ⟨va, ua⟩ := fd_r43x6_add_fast_spec_unsigned fm.unsigned f1.unsigned (by decide)
  obtain ⟨vf, ff⟩ := fold_spec (ua.mono (by decide))
  refine ⟨vy, fy, by rw [vs, vq, vy, v1], fs, ?_, ff⟩
  change val (Avx512.fold (fd_r43x6_add_fast _ one)) = _
  rw [vf, va, vm, vq, vd, vy, v1]
  ring

/-- `fd_f25519_sgn` as a byte: the value's parity. -/
theorem sgn_eq (x : Wwl) : fd_ed25519_point_frombytes.sgn x = BitVec.ofNat 8 ((val x).val % 2) := by
  rw [fd_ed25519_point_frombytes.sgn, tobytes_eq_ofNat_val]
  apply BitVec.eq_of_toNat_eq
  have h1 : (1 : BitVec 8).toNat = 1 := rfl
  simp only [BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ofNat, h1, Nat.and_one_is_mod]
  omega

/-- `buf[31] >> 7`: the encoding's top bit. -/
theorem sign_eq (b : BitVec 256) :
    fd_ed25519_point_frombytes.sign b = BitVec.ofNat 8 (b.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [fd_ed25519_point_frombytes.sign, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight,
    BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := b.isLt
  omega

/-- `fd_f25519_neg` of folded limbs: the negation, folded. -/
theorem neg_val {x : Wwl} (hx : Folded x) :
    val (fd_f25519_sqrt_ratio.neg x) = -val x ∧ Folded (fd_f25519_sqrt_ratio.neg x) := by
  obtain ⟨vn, sn⟩ := fd_r43x6_neg_fast_spec_unsigned (hx.unsigned.mono (by decide) : Unsigned 47 x)
    (by decide) (by decide)
  obtain ⟨vf, ff⟩ := fd_r43x6_fold_signed_spec (sn.mono (by decide))
  exact ⟨vf.trans vn, ff⟩

/-- `FD_R43X6_QUAD_PACK`'s elements: the four field elements. -/
theorem pack_val (x y z t : Wwl) :
    (Quad.pack x y z t).val 0 = val x ∧ (Quad.pack x y z t).val 1 = val y ∧
      (Quad.pack x y z t).val 2 = val z ∧ (Quad.pack x y z t).val 3 = val t :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- `FD_R43X6_QUAD_PACK` of folded field elements is folded. -/
theorem pack_folded {x y z t : Wwl} (hx : Folded x) (hy : Folded y) (hz : Folded z)
    (ht : Folded t) : (Quad.pack x y z t).Folded := by
  intro j hj
  interval_cases j
  · exact ⟨hx.1, hx.2.1, hx.2.2.1, hx.2.2.2.1, hx.2.2.2.2.1, hx.2.2.2.2.2.1, rfl, rfl⟩
  · exact ⟨hy.1, hy.2.1, hy.2.2.1, hy.2.2.2.1, hy.2.2.2.2.1, hy.2.2.2.2.2.1, rfl, rfl⟩
  · exact ⟨hz.1, hz.2.1, hz.2.2.1, hz.2.2.2.1, hz.2.2.2.2.1, hz.2.2.2.2.2.1, rfl, rfl⟩
  · exact ⟨ht.1, ht.2.1, ht.2.2.1, ht.2.2.2.1, ht.2.2.2.2.1, ht.2.2.2.2.2.1, rfl, rfl⟩

/-- `fd_ed25519_point_frombytes` fails exactly when no point decodes from the encoding. -/
public theorem fd_ed25519_point_frombytes.spec_eq_none_iff (b : BitVec 256) :
    fd_ed25519_point_frombytes.spec b = none ↔ Ed25519.decode b = none := by
  obtain ⟨-, -, vu, fu, vv, fv⟩ := frombytes_vals b
  have hv0 := Ed25519.v_ne ((b.toNat % 2 ^ 255 : ℕ) : ZMod p)
  obtain ⟨hsq, hns, -⟩ :=
    fd_f25519_sqrt_ratio.spec_val fu.unreduced fv.unreduced (by rw [vv]; exact hv0)
  have hD : (∀ P, ¬Ed25519.Decodes b P) ↔
      ¬IsSquare (val (fd_f25519_sub.spec (fd_r43x6_sqr (feFrombytes b)) one) /
        val (Avx512.fold (wwl_add (fd_r43x6_mul (fd_r43x6_sqr (feFrombytes b))
          fd_r43x6_ge_decode2.d) one))) := by
    rw [vu, vv, ← Ed25519.exists_onCurve_iff, ← Ed25519.exists_decodes_iff, not_exists]
  rw [Ed25519.decode_eq_none, hD]
  simp only [fd_ed25519_point_frombytes.spec]
  split_ifs with h
  · refine ⟨fun _ hs => ?_, fun _ => rfl⟩
    have := (hsq hs).1
    rw [h] at this
    exact absurd this (by decide)
  · exact ⟨fun h' => absurd h' (by simp), fun hn => absurd (hns hn) h⟩

/-- A successful `fd_ed25519_point_frombytes` gives the point that decodes from the encoding,
affine and folded. -/
public theorem fd_ed25519_point_frombytes.spec_eq_some {b : BitVec 256} {Q : Quad}
    (h : fd_ed25519_point_frombytes.spec b = some Q) :
    ∃ P, Ed25519.decode b = some P ∧ Q.Affine P.x P.y ∧ Q.Folded := by
  obtain ⟨vy, uy, vu, fu, vv, fv⟩ := frombytes_vals b
  have hv0 := Ed25519.v_ne ((b.toNat % 2 ^ 255 : ℕ) : ZMod p)
  obtain ⟨hsq, hns, fr⟩ :=
    fd_f25519_sqrt_ratio.spec_val fu.unreduced fv.unreduced (by rw [vv]; exact hv0)
  simp only [fd_ed25519_point_frombytes.spec] at h
  generalize fd_f25519_sqrt_ratio.spec _ _ = R at h hsq hns fr
  have h0 : ¬R.2 = 0 := fun h0 => by simp only [h0, ↓reduceIte, reduceCtorEq] at h
  simp only [h0, ↓reduceIte, Option.some.injEq] at h
  have hs := not_not.1 fun hn => h0 (hns hn)
  have hroot := (hsq hs).2
  rw [vu, vv] at hroot
  have hb : b.toNat / 2 ^ 255 < 2 := by have := b.isLt; omega
  -- the sign fix-up
  generalize hX : (if fd_ed25519_point_frombytes.sgn R.1 = fd_ed25519_point_frombytes.sign b then
    R.1 else fd_f25519_sqrt_ratio.neg R.1) = x at h
  have hx : (val x = val R.1 ∨ val x = -val R.1) ∧ Folded x ∧
      (val x = 0 ∨ (val x).val % 2 = b.toNat / 2 ^ 255) := by
    rw [sgn_eq, sign_eq] at hX
    have hlt := Nat.mod_lt (val R.1).val (show 2 > 0 by decide)
    by_cases e : (val R.1).val % 2 = b.toNat / 2 ^ 255
    · simp only [e, ↓reduceIte] at hX
      subst hX
      exact ⟨.inl rfl, fr, .inr e⟩
    · have hne : BitVec.ofNat 8 ((val R.1).val % 2) ≠ BitVec.ofNat 8 (b.toNat / 2 ^ 255) := by
        intro he
        apply e
        have := congrArg BitVec.toNat he
        simp only [BitVec.toNat_ofNat] at this
        omega
      simp only [hne, ↓reduceIte] at hX
      subst hX
      obtain ⟨vn, fn⟩ := neg_val fr
      refine ⟨.inr vn, fn, ?_⟩
      rw [vn]
      by_cases h0' : val R.1 = 0
      · exact .inl (by rw [h0', neg_zero])
      · refine .inr ?_
        rw [ZMod.neg_val]
        simp only [h0', ↓reduceIte]
        have := ZMod.val_lt (val R.1)
        have : (val R.1).val ≠ 0 := by rwa [ne_eq, ZMod.val_eq_zero]
        have hp : p % 2 = 1 := by norm_num
        omega
  obtain ⟨hxv, fx, hxp⟩ := hx
  have hc : Ed25519.OnCurve (val x) ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
    rw [Ed25519.onCurve_iff]
    rcases hxv with e | e <;> rw [e] <;> linear_combination hroot
  have uyr : Unreduced (feFrombytes b) := uy.unreduced
  obtain ⟨vm, fm⟩ := fd_r43x6_mul_spec (fx.unsigned.mono (by decide)) uyr
  obtain ⟨v1, f1⟩ := one_spec
  obtain ⟨p0, p1, p2, p3⟩ := pack_val x (feFrombytes b) one (fd_r43x6_mul x (feFrombytes b))
  subst h
  refine ⟨⟨val x, _, hc⟩, Ed25519.decode_eq_some ⟨rfl, hxp⟩, ⟨p0, p1.trans vy, p2.trans v1, ?_⟩,
    pack_folded fx uy f1 fm⟩
  rw [p3, vm, vy]

/-- `fd_ed25519_point_frombytes( r, buf )` of an encoding no point decodes from: `NULL`, memory
unchanged. -/
public theorem fd_ed25519_point_frombytes.call_none (r buf : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (hb : Fits s.mem buf 256)
    (hoff : buf.offset.toNat + 32 ≤ 2 ^ 64) (h : Ed25519.decode (s.mem.readAt buf 256) = none) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.args (.value r) (.value buf)) s =
      .value
        (.cons (.value Pointer.null) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem }) := by
  rw [fd_ed25519_point_frombytes.call_eq r buf s hwf hr hb hoff,
    (fd_ed25519_point_frombytes.spec_eq_none_iff _).2 h]

/-- `fd_ed25519_point_frombytes( r, buf )` of an encoding `P` decodes from: `r`, holding `P`
affine and folded. -/
public theorem fd_ed25519_point_frombytes.call_some (r buf : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (hb : Fits s.mem buf 256)
    (hoff : buf.offset.toNat + 32 ≤ 2 ^ 64) {P : Ed25519.Point}
    (h : Ed25519.decode (s.mem.readAt buf 256) = some P) :
    ∃ Q : Quad, Q.Affine P.x P.y ∧ Q.Folded ∧
      _root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.call
          (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.args (.value r) (.value buf)) s =
        .value
          (.cons (.value r) .nil,
            { alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem.storeQuad r Q }) := by
  rw [fd_ed25519_point_frombytes.call_eq r buf s hwf hr hb hoff]
  cases hs : fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256) with
  | none =>
    rw [(fd_ed25519_point_frombytes.spec_eq_none_iff _).1 hs] at h
    cases h
  | some Q =>
    obtain ⟨P', hP', hA, hF⟩ := fd_ed25519_point_frombytes.spec_eq_some hs
    rw [h, Option.some.injEq] at hP'
    subst hP'
    exact ⟨Q, hA, hF, rfl⟩

end MLIR.Firedancer.Lane

module

public import Firedancer.Math.Avx512.Curve
public import Firedancer.Math.Avx512.Pow
public import Firedancer.Math.Avx512.Unpack
public import Firedancer.Math.Verify
public import Firedancer.Avx512.fd_ed25519_point_frombytes_2x
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! `fd_r43x6_ge_decode2` (`FD_R43X6_GE_DECODE2`, `frombytes_2x`) as point decompression: each
encoding's checks pass exactly when a point with its `y` exists, and then the QUAD it stores is that
point, affine, of the parity its top bit asks for (any sign for `x = 0`, as Dalek and Ref). -/

namespace MLIR.Firedancer.Avx512

open MLIR.Firedancer.Ref (p)
open MLIR.Firedancer.Ref (sq_eq_one_iff' isSquare_div_iff)
open _root_.Ed25519 (OnCurve exists_decodes_iff)
open fd_r43x6_ge_decode2

/-! ## The compiled forms as `fd_r43x6` operations -/

section Lanes

/-- `vadd` is `fd_r43x6_add_fast`. -/
theorem vadd_eq (x y : Wwl) : vadd x y = fd_r43x6_add_fast x y := by
  ext i hi : 1
  simp [vadd, fd_r43x6_add_fast, wwl_add]

/-- `foldSignedPre`'s lanes. -/
theorem foldSignedPre_get (w : Wwl) :
    (foldSignedPre w)[0] = w[5].sshiftRight 40 + (w[0] &&& 8796093022207#64) +
      (w[5].sshiftRight 40 * 18 &&& 18446744073709551615#64) ∧
    (foldSignedPre w)[1] = w[0].sshiftRight 43 + (w[1] &&& 8796093022207#64) ∧
    (foldSignedPre w)[2] = w[1].sshiftRight 43 + (w[2] &&& 8796093022207#64) ∧
    (foldSignedPre w)[3] = w[2].sshiftRight 43 + (w[3] &&& 8796093022207#64) ∧
    (foldSignedPre w)[4] = w[3].sshiftRight 43 + (w[4] &&& 8796093022207#64) ∧
    (foldSignedPre w)[5] = w[4].sshiftRight 43 + (w[5] &&& 1099511627775#64) ∧
    (foldSignedPre w)[6] = 0 ∧ (foldSignedPre w)[7] = 0 := by
  rw [foldSignedPre]
  simp [negRot, vsar, vmul, foldShifts, foldMask, neg18, negSel, R43x6.wwl_add_get,
    R43x6.wwl_and_get]

set_option hygiene false in
/-- A vector equation lane by lane: each lane unfolded by `t`, then `bv_decide` on the lanes as
variables. -/
local macro "vec_lanes " t:tacticSeq : tactic =>
  `(tactic| (
    ext i hi : 1
    match i, hi with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ =>
      ($t)
      try (generalize_lanes; bv_decide)))

-- the lane `simp` set is shared by all lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- `fd_r43x6_fold_signed` as compiled: `foldSignedPre` of the unbiased lanes, the bias added
back. -/
theorem foldSignedPre_eq (w : Wwl) :
    vadd (foldSignedPre w) negBias = fd_r43x6_fold_signed (vadd w negBias) := by
  rw [R43x6.fd_r43x6_fold_signed_eq, foldSignedBias]
  vec_lanes simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ, vadd, Vector.getElem_ofFn, foldSignedPre_get, R43x6.wwl_add_get,
    R43x6.wwl_get0,
    R43x6.wwl_get1, R43x6.wwl_get2, R43x6.wwl_get3, R43x6.wwl_get4, R43x6.wwl_get5,
    R43x6.wwl_get6, R43x6.wwl_get7, Quad.fold_get0, Quad.fold_get1, Quad.fold_get2,
    Quad.fold_get3, Quad.fold_get4, Quad.fold_get5, Quad.fold_get6, Quad.fold_get7, negBias]

-- the lane `simp` set is shared by all lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- `fd_r43x6_sub( x, one )` as compiled: `x + (p - 1 - _b)`, the bias added back. -/
theorem pSubOne_eq (x : Wwl) : vadd (vadd x pSubOne) negBias = fd_r43x6_sub_fast x one := by
  vec_lanes simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ, vadd, Vector.getElem_ofFn, fd_r43x6_sub_fast, R43x6.wwl_add_get,
    R43x6.wwl_sub_get, fd_r43x6_p, R43x6.wwl_get0,
    R43x6.wwl_get1, R43x6.wwl_get2, R43x6.wwl_get3, R43x6.wwl_get4, R43x6.wwl_get5,
    R43x6.wwl_get6, R43x6.wwl_get7, negBias, pSubOne, one, m43, m40]

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false in
/-- `fd_r43x6_sub_fast( a, u )` for `u = pre + _b` as compiled: `(a - pre) + (p - _b)`. -/
theorem vsub_negP_eq (a pre : Wwl) :
    vadd (vsub a pre) negP = fd_r43x6_sub_fast a (vadd pre negBias) := by
  ext i hi : 1
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ =>
    simp only [fd_r43x6_sub_fast, R43x6.wwl_add_get, R43x6.wwl_sub_get, R43x6.wwl_get0,
      R43x6.wwl_get1, R43x6.wwl_get2, R43x6.wwl_get3, R43x6.wwl_get4, R43x6.wwl_get5,
      R43x6.wwl_get6, R43x6.wwl_get7, fd_r43x6_p, m43, m40]
    simp only [vadd, vsub, Vector.getElem_ofFn, Fin.getElem_fin]
    simp only [negP, negBias, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
    generalize_lanes
    bv_decide

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false in
/-- `fd_r43x6_neg` as compiled: `fd_r43x6_fold_signed( p - x )`. -/
theorem negFold_eq (x : Wwl) : negFold x = fd_r43x6_fold_signed (fd_r43x6_neg_fast x) := by
  rw [R43x6.fd_r43x6_fold_signed_eq, foldSignedBias]
  ext i hi : 1
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ =>
    simp only [Quad.fold_get0, Quad.fold_get1, Quad.fold_get2, Quad.fold_get3, Quad.fold_get4,
      Quad.fold_get5, Quad.fold_get6, Quad.fold_get7, R43x6.wwl_add_get, fd_r43x6_neg_fast,
      R43x6.wwl_sub_get, R43x6.wwl_get0, R43x6.wwl_get1, R43x6.wwl_get2, R43x6.wwl_get3,
      R43x6.wwl_get4, R43x6.wwl_get5, R43x6.wwl_get6, R43x6.wwl_get7, fd_r43x6_p, m43, m40]
    simp only [negFold, Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_zipWith,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    simp only [negP, foldMask, negBias, foldShifts, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, BitVec.reduceToNat, ↓reduceIte,
      Nat.succ_ne_zero, OfNat.ofNat_ne_zero]
    generalize_lanes
    bv_decide

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false in
/-- The decoded QUAD's elements: `fd_r43x6_fold_unsigned` of `x, y, z, t`. -/
theorem quadOf_elem (x y z t : Wwl) (j : Fin 4) :
    (quadOf (x, y, z, t)).elem j = fold (![x, y, z, t] j) := by
  obtain ⟨j, hj⟩ := j
  rw [Quad.elem_eq_nat _ _ hj]
  ext k hk : 1
  match j, hj, k, hk with
  | 0, _, 0, _ | 0, _, 1, _ | 0, _, 2, _ | 0, _, 3, _ | 0, _, 4, _ | 0, _, 5, _ | 0, _, 6, _
  | 0, _, 7, _ | 1, _, 0, _ | 1, _, 1, _ | 1, _, 2, _ | 1, _, 3, _ | 1, _, 4, _ | 1, _, 5, _
  | 1, _, 6, _ | 1, _, 7, _ | 2, _, 0, _ | 2, _, 1, _ | 2, _, 2, _ | 2, _, 3, _ | 2, _, 4, _
  | 2, _, 5, _ | 2, _, 6, _ | 2, _, 7, _ | 3, _, 0, _ | 3, _, 1, _ | 3, _, 2, _ | 3, _, 3, _
  | 3, _, 4, _ | 3, _, 5, _ | 3, _, 6, _ | 3, _, 7, _ =>
    simp only [Fin.zero_eta, Fin.mk_one, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_fin_one,
      Fin.reduceFinMk, Matrix.cons_val, Matrix.head_cons, Matrix.tail_cons, Quad.fold_get0,
      Quad.fold_get1, Quad.fold_get2, Quad.fold_get3, Quad.fold_get4, Quad.fold_get5,
      Quad.fold_get6, Quad.fold_get7]
    try simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
    try simp only [quadOf, quadFold03, quadFold14, quadFold25, quadLanes, quadFoldMask,
      Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, getElem!_pos, Nat.reduceAdd,
      Nat.reduceLT, Nat.reduceSub, dite_true, dite_false, ↓reduceDIte]
    try (generalize_lanes; bv_decide)

end Lanes

/-! ## The square-root algebra -/

section Algebra

/-- The candidate root `x = u v³ (u v⁷)^((p-5)/8)` has `v x² = ±u` exactly when `u / v` is a
square. -/
theorem sqrt_ratio_iff {u v x : ZMod p} (hv : v ≠ 0)
    (hx : x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    (v * x ^ 2 = u ∨ v * x ^ 2 = -u) ↔ IsSquare (u / v) := by
  by_cases hu : u = 0
  · subst hu
    simp only [hx, zero_mul, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
      mul_zero, true_or, zero_div, true_iff]
    exact ⟨0, by ring⟩
  have hw : u * v ^ 7 ≠ 0 := mul_ne_zero hu (pow_ne_zero _ hv)
  set c := (u * v ^ 7) ^ ((p - 1) / 4) with hc
  have hcheck : v * x ^ 2 = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, pow_succ (u * v ^ 7),
      pow_mul (u * v ^ 7), hx]
    ring
  have hc2 : c ^ 2 = (u * v ^ 7) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hsq := (isSquare_div_iff (u := u) hv).trans (ZMod.euler_criterion p hw)
  rw [hcheck, hsq, ← hc2, sq_eq_one_iff']
  constructor
  · rintro (h | h)
    · exact .inl (mul_left_cancel₀ hu (by rw [h, mul_one]))
    · exact .inr (mul_left_cancel₀ hu (by rw [h]; ring))
  · rintro (h | h)
    · exact .inl (by rw [h, mul_one])
    · exact .inr (by rw [h]; ring)

end Algebra

/-! ## One encoding's checks -/

section Dec

open R43x6 (val Folded Unsigned Unreduced)

/-- `fd_r43x6_one()`, `fd_r43x6_d()`, `fd_r43x6_imag()`: `1`, `d`, `√-1`. -/
theorem consts :
    (val one = 1 ∧ Folded one) ∧
      (val fd_r43x6_ge_decode2.d = _root_.Ed25519.d ∧ Folded fd_r43x6_ge_decode2.d) ∧
      (val fd_r43x6_ge_decode2.sqrtM1 = _root_.Ed25519.sqrtM1 ∧ Folded fd_r43x6_ge_decode2.sqrtM1) := by
  refine ⟨⟨by decide, by decide⟩, ⟨?_, by decide⟩, ⟨?_, by decide⟩⟩
  · unfold _root_.Ed25519.d; decide
  · unfold _root_.Ed25519.sqrtM1; decide

/-- The encoding's low 255 bits, as `^bb0` reads them with the sign bit cleared. -/
theorem wvNat_dec (s : BitVec 256) :
    R43x6.wvNat (Vector.ofFn fun i => Ty.extractVecElem 4 64 i
      (Memory.spliceBits s 192 (s.extractLsb' 192 64 &&& 0x7FFFFFFFFFFFFFFF))) =
      s.toNat % 2 ^ 255 := by
  simp only [R43x6.wvNat, Vector.getElem_ofFn, Ty.extractVecElem_eq, Nat.zero_mul,
    Nat.one_mul, Nat.reduceMul]
  rw [Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega),
    Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega),
    Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega),
    Memory.extractLsb'_spliceBits_self _ _ _ (by omega)]
  simp only [BitVec.extractLsb'_toNat, BitVec.toNat_and, Nat.shiftRight_eq_div_pow]
  rw [show (0x7FFFFFFFFFFFFFFF : BitVec 64).toNat = 2 ^ 63 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod]
  have := s.isLt
  omega

/-- The sign `^bb0` reads: the encoding's top bit. -/
theorem sign_dec (s : BitVec 256) :
    (s.extractLsb' 192 64 >>> 63).setWidth 32 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := s.isLt
  omega

/-- `FD_R43X6_MUL_INL`: the product, folded. -/
theorem mulF {a b : Wwl} (ha : Unreduced a) (hb : Unreduced b) :
    val (fold (fd_r43x6_mul_fast.spec a b)) = val a * val b ∧
      Folded (fold (fd_r43x6_mul_fast.spec a b)) := by
  obtain ⟨v, u, -⟩ := R43x6.fd_r43x6_mul_fast_spec ha.1 hb
  obtain ⟨v', f⟩ := R43x6.fold_spec u
  exact ⟨v'.trans v, f⟩

/-- `FD_R43X6_SQR_INL`: the square, folded. -/
theorem sqrF {a : Wwl} (ha : Unreduced a) :
    val (fold (fd_r43x6_sqr_fast.spec a)) = val a ^ 2 ∧
      Folded (fold (fd_r43x6_sqr_fast.spec a)) := by
  obtain ⟨v, u, -⟩ := R43x6.fd_r43x6_sqr_fast_spec ha
  obtain ⟨v', f⟩ := R43x6.fold_spec u
  exact ⟨v'.trans v, f⟩

/-- One encoding's checks: `y` its low 255 bits, `x = u v³ (u v⁷)^((p-5)/8)` the candidate root of
`u / v = (y² - 1) / (d y² + 1)`, `x_0` its top bit, `t1nz` and `t2nz` whether `v x² ∓ u` are
nonzero. -/
theorem dec_spec (s : BitVec 256) :
    let D := dec s
    let y : ZMod p := ((s.toNat % 2 ^ 255 : ℕ) : ZMod p)
    let u := y ^ 2 - 1
    let v := _root_.Ed25519.d * y ^ 2 + 1
    val D.y = y ∧ R43x6.Unpacked D.y ∧
      val D.x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8) ∧ Folded D.x ∧
      D.x0 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) ∧
      D.t1nz = (if v * val D.x ^ 2 - u = 0 then 0 else 1) ∧
      D.t2nz = (if v * val D.x ^ 2 + u = 0 then 0 else 1) := by
  intro D y u v
  obtain ⟨⟨v1, f1⟩, ⟨vd, fd⟩, -⟩ := consts
  have hy : val D.y = y ∧ R43x6.Unpacked D.y := by
    obtain ⟨-, hv, hu, -, -⟩ := R43x6.fd_r43x6_unpack_spec (Vector.ofFn fun i =>
      Ty.extractVecElem 4 64 i
        (Memory.spliceBits s 192 (s.extractLsb' 192 64 &&& 0x7FFFFFFFFFFFFFFF)))
    rw [wvNat_dec] at hv
    exact ⟨hv, hu⟩
  have uy : Unreduced D.y := ⟨hy.2.unsigned.mono (by decide), hy.2.2.2.2.2.2.2⟩
  -- the fields as `fd_r43x6` operations
  have e1 : D.t1nz = fd_r43x6_is_nonzero.spec (fd_r43x6_sub_fast
      (fold (fd_r43x6_mul_fast.spec D.v (fold (fd_r43x6_sqr_fast.spec D.x)))) D.u) := by
    change _ = fd_r43x6_is_nonzero.spec (fd_r43x6_sub_fast _ (vadd D.pre negBias))
    rw [← vsub_negP_eq]
    rfl
  have e2 : D.t2nz = fd_r43x6_is_nonzero.spec (fd_r43x6_add_fast
      (fold (fd_r43x6_mul_fast.spec D.v (fold (fd_r43x6_sqr_fast.spec D.x)))) D.u) := by
    rw [← vadd_eq]
    rfl
  have eu : D.u = fd_r43x6_fold_signed (fd_r43x6_sub_fast (fold (fd_r43x6_sqr_fast.spec D.y))
      one) := by
    rw [← pSubOne_eq, ← foldSignedPre_eq]
    rfl
  have ev : D.v = fd_r43x6_add_fast (fold (fd_r43x6_mul_fast.spec fd_r43x6_ge_decode2.d
      (fold (fd_r43x6_sqr_fast.spec D.y)))) one := by
    rw [← vadd_eq]
    rfl
  have ex : D.x = fold (fd_r43x6_mul_fast.spec
      (fold (fd_r43x6_mul_fast.spec D.u (fold (fd_r43x6_mul_fast.spec D.v
        (fold (fd_r43x6_sqr_fast.spec D.v))))))
      (fd_r43x6_pow22523_2.spec (fold (fd_r43x6_mul_fast.spec
        (fold (fd_r43x6_mul_fast.spec D.u (fold (fd_r43x6_mul_fast.spec D.v
          (fold (fd_r43x6_sqr_fast.spec D.v))))))
        (fold (fd_r43x6_sqr_fast.spec (fold (fd_r43x6_sqr_fast.spec D.v)))))))) := rfl
  have ex0 : D.x0 = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := sign_dec s
  -- `y²`, `u`, `v`
  obtain ⟨vq, fq⟩ := sqrF uy
  rw [hy.1] at vq
  have hu : val D.u = u ∧ Folded D.u := by
    obtain ⟨vs, is⟩ := fq.in.sub_fast f1.in (by norm_num) (by norm_num) (by norm_num)
      (by norm_num)
    obtain ⟨vf, ff⟩ := is.fold_signed (by norm_num)
    rw [eu]
    exact ⟨by rw [vf, vs, vq, v1], ff⟩
  have hv : val D.v = v ∧ Unreduced D.v := by
    obtain ⟨vm, fm⟩ := mulF fd.unreduced fq.unreduced
    obtain ⟨va, ia⟩ := fm.in.add_fast f1.in (by norm_num) (by norm_num)
    rw [ev]
    exact ⟨by rw [va, vm, vd, vq, v1],
      ia.unsigned (by norm_num), R43x6.HighZero.add_fast fm.2.2.2.2.2.2 f1.2.2.2.2.2.2⟩
  clear eu ev
  have hx : val D.x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8) ∧ Folded D.x := by
    rw [ex]
    obtain ⟨vu, fu⟩ := hu
    obtain ⟨vv, uv⟩ := hv
    generalize D.u = U at vu fu
    generalize D.v = V at vv uv
    obtain ⟨v2, f2⟩ := sqrF uv
    obtain ⟨v4, f4⟩ := sqrF f2.unreduced
    obtain ⟨v3, f3⟩ := mulF uv f2.unreduced
    obtain ⟨w3, g3⟩ := mulF fu.unreduced f3.unreduced
    obtain ⟨w7, g7⟩ := mulF g3.unreduced f4.unreduced
    obtain ⟨t0, h0⟩ := R43x6.fd_r43x6_pow22523_2_spec g7.unreduced
    obtain ⟨vx, fx⟩ := mulF g3.unreduced h0.unreduced
    refine ⟨?_, fx⟩
    rw [vx, t0, w7, w3, v3, v4, v2, vu, vv]
    generalize (p - 5) / 8 = e
    ring
  clear ex
  obtain ⟨vu, fu⟩ := hu
  obtain ⟨vv, uv⟩ := hv
  obtain ⟨vx2, fx2⟩ := sqrF hx.2.unreduced
  obtain ⟨vm, fm⟩ := mulF uv fx2.unreduced
  rw [vx2, vv] at vm
  obtain ⟨vs, is⟩ := fm.in.sub_fast fu.in (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)
  obtain ⟨va, ia⟩ := fm.in.add_fast fu.in (by norm_num) (by norm_num)
  refine ⟨hy.1, hy.2, hx.1, hx.2, ex0, ?_, ?_⟩
  · rw [e1, R43x6.fd_r43x6_is_nonzero_spec (in_signed is (by norm_num) (by norm_num)), vs, vm,
      vu]
  · rw [e2, R43x6.fd_r43x6_is_nonzero_spec (in_signed ia (by norm_num) (by norm_num)), va, vm,
      vu]

/-- `v = d y² + 1` is never zero. -/
theorem v_ne (y : ZMod p) : _root_.Ed25519.d * y ^ 2 + 1 ≠ 0 := by
  intro h
  exact _root_.Ed25519.one_add_ne 1 y (by linear_combination h)

/-- Two `is_nonzero` flags' `&` is zero exactly when one of them is. -/
theorem flags_and_eq_zero {A B : Prop} [Decidable A] [Decidable B] :
    ((if A then (0 : BitVec 32) else 1) &&& if B then 0 else 1) = 0#32 ↔ A ∨ B := by
  by_cases A <;> by_cases B <;> simp [*]

/-- A point with `y` exists exactly when `(y² - 1) / (d y² + 1)` is a square. -/
theorem exists_onCurve_iff (y : ZMod p) :
    (∃ x, OnCurve x y) ↔ IsSquare ((y ^ 2 - 1) / (_root_.Ed25519.d * y ^ 2 + 1)) := by
  simp only [_root_.Ed25519.onCurve_iff, IsSquare, div_eq_iff (v_ne y)]
  constructor <;> rintro ⟨r, hr⟩ <;> exact ⟨r, by linear_combination -hr⟩

/-- An encoding's checks pass exactly when a point decodes from it. -/
theorem dec_ok_iff (s : BitVec 256) : (dec s).ok ↔ ∃ P, _root_.Ed25519.Decodes s P := by
  obtain ⟨-, -, hx, -, -, h1, h2⟩ := dec_spec s
  rw [exists_decodes_iff, Dec.ok, h1, h2, flags_and_eq_zero, exists_onCurve_iff]
  generalize ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) = y at hx ⊢
  rw [← sqrt_ratio_iff (v_ne y) hx]
  generalize R43x6.val (dec s).x = x
  constructor
  · rintro (h | h)
    · exact .inr (by linear_combination h)
    · exact .inl (by linear_combination h)
  · rintro (h | h)
    · exact .inr (by linear_combination h)
    · exact .inl (by linear_combination h)

/-- `BitVec.ofNat 32` is injective on bits. -/
theorem ofNat_bit_inj {a b : ℕ} (ha : a < 2) (hb : b < 2) :
    BitVec.ofNat 32 a = BitVec.ofNat 32 b ↔ a = b := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    simp only [BitVec.toNat_ofNat] at this
    omega
  · rintro rfl; rfl

/-- `-1` is no bit. -/
theorem neg_one_ne_bit {b : ℕ} (hb : b < 2) : (-1 : BitVec 32) ≠ BitVec.ofNat 32 b := by
  match b, hb with
  | 0, _ | 1, _ => decide

/-- The sign fix-up: `x` kept if `diagnose` gives the sign bit `b`, else `fd_r43x6_neg`ated; the
result is folded, `±x`, and zero or of parity `b`. -/
theorem fixSign {x : Wwl} (hx : Folded x) {b : ℕ} (hb : b < 2) :
    let x' := if fd_r43x6_diagnose.spec x = BitVec.ofNat 32 b then x else negFold x
    (val x' = val x ∨ val x' = -val x) ∧ Folded x' ∧ (val x' = 0 ∨ (val x').val % 2 = b) := by
  have sx : R43x6.Signed 62 x := (hx.unsigned.signed (by decide)).mono (by decide)
  dsimp only
  rw [R43x6.fd_r43x6_diagnose_spec sx]
  split_ifs with h0 h1 h1
  · exact absurd h1 (neg_one_ne_bit hb)
  · obtain ⟨vn, sn⟩ := R43x6.fd_r43x6_neg_fast_spec_unsigned hx.unsigned (by decide) (by decide)
    obtain ⟨vf, ff⟩ := R43x6.In.fold_signed (a := -2 ^ 44) (b := 2 ^ 44)
      (fun i => ⟨(sn i).1, (sn i).2.le⟩) (by norm_num)
    rw [negFold_eq]
    exact ⟨.inr (by rw [vf, vn]), ff, .inl (by rw [vf, vn, h0, neg_zero])⟩
  · refine ⟨.inl rfl, hx, .inr ?_⟩
    exact (ofNat_bit_inj (Nat.mod_lt _ (by decide)) hb).1 h1
  · obtain ⟨vn, sn⟩ := R43x6.fd_r43x6_neg_fast_spec_unsigned hx.unsigned (by decide) (by decide)
    obtain ⟨vf, ff⟩ := R43x6.In.fold_signed (a := -2 ^ 44) (b := 2 ^ 44)
      (fun i => ⟨(sn i).1, (sn i).2.le⟩) (by norm_num)
    rw [negFold_eq]
    refine ⟨.inr (by rw [vf, vn]), ff, .inr ?_⟩
    have hne : (val x).val % 2 ≠ b := fun e => h1 (by rw [e])
    rw [vf, vn, ZMod.neg_val, ite_eq_right h0]
    have := ZMod.val_lt (val x)
    have : (val x).val ≠ 0 := by rwa [ne_eq, ZMod.val_eq_zero]
    have hp : p % 2 = 1 := by norm_num
    omega

/-- A passing encoding's QUAD is the point that decodes from it, affine and folded. -/
theorem dec_point {s : BitVec 256} (h : (dec s).ok) :
    let D := dec s
    let Q := quadOf (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec
      fd_r43x6_ge_decode2.sqrtM1 one D.x D.y D.t1nz D.x0)
    ∃ P, _root_.Ed25519.Decodes s P ∧ Q.Affine P.x P.y ∧ Q.Folded := by
  intro D Q
  obtain ⟨vy, uy, vx, fx, ex0, h1, h2⟩ := dec_spec s
  obtain ⟨⟨v1, f1⟩, -, ⟨vi, fi⟩⟩ := consts
  have hok := h
  rw [Dec.ok, h1, h2, flags_and_eq_zero] at hok
  have hb : s.toNat / 2 ^ 255 < 2 := by have := s.isLt; omega
  -- the root: `x`, or `x √-1` when `v x² ≠ u`
  have hroot : Folded (fold (fd_r43x6_mul_fast.spec D.x
        (if D.t1nz = 0 then one else fd_r43x6_ge_decode2.sqrtM1))) ∧
      OnCurve (val (fold (fd_r43x6_mul_fast.spec D.x
        (if D.t1nz = 0 then one else fd_r43x6_ge_decode2.sqrtM1)))) (val D.y) := by
    rw [_root_.Ed25519.onCurve_iff, vy]
    by_cases h0 : (_root_.Ed25519.d * ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 + 1) *
        val (dec s).x ^ 2 - (((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 - 1) = 0
    · have ht : D.t1nz = 0 := by rw [h1, ite_eq_left_of_eq_true _ _ (eq_true h0)]
      rw [ht, ite_eq_left_of_eq_true _ _ (eq_true rfl)]
      obtain ⟨vm, fm⟩ := mulF fx.unreduced f1.unreduced
      refine ⟨fm, ?_⟩
      rw [vm, v1]
      linear_combination h0
    · have ht : D.t1nz = 1 := by rw [h1, ite_eq_right_of_eq_false _ _ (eq_false h0)]
      rw [ht, ite_eq_right_of_eq_false _ _ (eq_false (by decide))]
      obtain ⟨vm, fm⟩ := mulF fx.unreduced fi.unreduced
      refine ⟨fm, ?_⟩
      rw [vm, vi]
      have e := hok.resolve_right h0
      linear_combination (-1 : ZMod p) * e + val D.x ^ 2 * (_root_.Ed25519.d *
        (((s.toNat % 2 ^ 255 : ℕ) : ZMod p)) ^ 2 + 1) * _root_.Ed25519.sqrtM1_sq
  obtain ⟨fr, hc⟩ := hroot
  have hs := fixSign fr hb
  rw [← ex0] at hs
  dsimp only [Q, decodePt]
  generalize fold (fd_r43x6_mul_fast.spec D.x
    (if D.t1nz = 0 then one else fd_r43x6_ge_decode2.sqrtM1)) = R at fr hc hs ⊢
  generalize (if fd_r43x6_diagnose.spec R = D.x0 then R else negFold R) = X at hs ⊢
  obtain ⟨hX, fX, hp⟩ := hs
  have cX : OnCurve (val X) (val D.y) := by
    rcases hX with hX | hX <;> rw [hX]
    exacts [hc, hc.neg]
  have uY : Unreduced D.y := ⟨uy.unsigned.mono (by decide), uy.2.2.2.2.2.2⟩
  obtain ⟨vm, fm⟩ := mulF fX.unreduced uY
  have el (j : Fin 4) := quadOf_elem X D.y one (fold (fd_r43x6_mul_fast.spec X D.y)) j
  have fv {w : Wwl} (hw : R43x6.Unsigned 63 w) : val (fold w) = val w := (R43x6.fold_spec hw).1
  refine ⟨⟨val X, val D.y, cX⟩, ⟨vy, hp⟩, ⟨?_, ?_, ?_, ?_⟩, fun j hj => ?_⟩
  · change val (Quad.elem _ ((0 : Fin 4) : ℕ)) = _
    rw [el, Matrix.cons_val_zero, fv (fX.unsigned.mono (by decide))]
  · change val (Quad.elem _ ((1 : Fin 4) : ℕ)) = _
    rw [el, Matrix.cons_val_one, Matrix.cons_val_zero, fv (uy.unsigned.mono (by decide))]
  · change val (Quad.elem _ ((2 : Fin 4) : ℕ)) = _
    rw [el]
    exact (fv (w := one) (f1.unsigned.mono (by decide))).trans v1
  · change val (Quad.elem _ ((3 : Fin 4) : ℕ)) = _
    rw [el]
    exact (fv (w := fold (fd_r43x6_mul_fast.spec X D.y)) (fm.unsigned.mono (by decide))).trans vm
  · rw [show j = ((⟨j, hj⟩ : Fin 4) : ℕ) from rfl, el]
    exact R43x6.fold_folded _

end Dec

/-! ## The decoder -/

section Decode

open _root_.Ed25519 (Decodes decode)

/-- `decode` finds a point that decodes. -/
theorem decodes_of_decode {buf : BitVec 256} {P : _root_.Ed25519.Point}
    (h : decode buf = some P) : Decodes buf P := by
  by_cases hex : ∃ P, Decodes buf P
  · obtain ⟨Q, hQ⟩ := hex
    rw [_root_.Ed25519.decode_eq_some hQ, Option.some.injEq] at h
    exact h ▸ hQ
  · rw [_root_.Ed25519.decode_eq_none.2 fun P hP => hex ⟨P, hP⟩] at h
    exact absurd h (by simp)

/-- An encoding's checks pass exactly when `decode` succeeds. -/
theorem dec_ok_iff_decode (s : BitVec 256) : (dec s).ok ↔ decode s ≠ none := by
  rw [dec_ok_iff, ne_eq, _root_.Ed25519.decode_eq_none]
  push Not
  rfl

/-- A passing encoding's QUAD is the point `decode` finds, affine and folded. -/
theorem dec_point_decode {s : BitVec 256} {P : _root_.Ed25519.Point} (h : decode s = some P) :
    let D := dec s
    let Q := quadOf (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec
      fd_r43x6_ge_decode2.sqrtM1 one D.x D.y D.t1nz D.x0)
    Q.Affine P.x P.y ∧ Q.Folded := by
  have hok : (dec s).ok := (dec_ok_iff_decode s).2 (by rw [h]; simp)
  obtain ⟨P', hP', hQ, hf⟩ := dec_point hok
  rw [(decodes_of_decode h).unique hP']
  exact ⟨hQ, hf⟩

/-- `fd_r43x6_ge_decode2` of the encodings `sa` and `sb`: `-1` and zeros when `sa` does not decode,
else `-2` and zeros when `sb` does not, else `0` and the two points `decode` finds, affine and
folded. -/
public theorem fd_r43x6_ge_decode2.spec_decode (sa sb : BitVec 256) :
    let R := fd_r43x6_ge_decode2.spec (dec sa) (dec sb)
    (decode sa = none → R = (-1, zeroQuad, zeroQuad)) ∧
      (∀ P, decode sa = some P → decode sb = none → R = (-2, zeroQuad, zeroQuad)) ∧
      ∀ P Q, decode sa = some P → decode sb = some Q →
        R.1 = 0 ∧ R.2.1.Affine P.x P.y ∧ R.2.1.Folded ∧ R.2.2.Affine Q.x Q.y ∧ R.2.2.Folded := by
  intro R
  refine ⟨fun ha => ?_, fun P ha hb => ?_, fun P Q ha hb => ?_⟩
  · have : ¬(dec sa).ok := by rw [dec_ok_iff_decode, ha]; simp
    simp only [R, fd_r43x6_ge_decode2.spec, this, ite_false]
  · have h1 : (dec sa).ok := (dec_ok_iff_decode sa).2 (by rw [ha]; simp)
    have h2 : ¬(dec sb).ok := by rw [dec_ok_iff_decode, hb]; simp
    simp only [R, fd_r43x6_ge_decode2.spec, h1, h2, ite_true, ite_false]
  · have h1 : (dec sa).ok := (dec_ok_iff_decode sa).2 (by rw [ha]; simp)
    have h2 : (dec sb).ok := (dec_ok_iff_decode sb).2 (by rw [hb]; simp)
    obtain ⟨a1, a2⟩ := dec_point_decode ha
    obtain ⟨b1, b2⟩ := dec_point_decode hb
    simp only [R, fd_r43x6_ge_decode2.spec, h1, h2, ite_true]
    exact ⟨trivial, a1, a2, b1, b2⟩

/-- `frombytes_2x` (`FD_R43X6_GE_DECODE2`): `-1` and zeros when `e1` does not decode, else `-2`
and zeros when `e2` does not, else `0` and the two points `decode` finds, affine and folded. -/
public theorem fd_ed25519_point_frombytes_2x.spec_decode (e1 e2 : BitVec 256) :
    let R := fd_ed25519_point_frombytes_2x.spec e1 e2
    (decode e1 = none → R = (-1, zeroQuad, zeroQuad)) ∧
      (∀ P, decode e1 = some P → decode e2 = none → R = (-2, zeroQuad, zeroQuad)) ∧
      ∀ P Q, decode e1 = some P → decode e2 = some Q →
        R.1 = 0 ∧ R.2.1.Affine P.x P.y ∧ R.2.1.Folded ∧ R.2.2.Affine Q.x Q.y ∧ R.2.2.Folded :=
  fd_r43x6_ge_decode2.spec_decode e1 e2

/-- `is_small_order` on an affine point of the group, folded (as decoding gives it): `1` exactly
when `8 P = 0`. -/
public theorem fd_ed25519_affine_is_small_order.spec_point {A : Quad} {P : _root_.Ed25519.Point}
    (hA : A.Affine P.x P.y) (hr : A.Folded) :
    fd_ed25519_affine_is_small_order.spec A = if 8 • P = 0 then 1 else 0 :=
  (fd_ed25519_affine_is_small_order.spec_val hA.1 hA.2.1 P.on hr).trans
    (if_congr (_root_.Ed25519.Point.smallOrder_iff_nsmul P) rfl rfl)

/-- `point_eq` on points of the group, projective with elements below `2^44`: `1` exactly when
they are equal. -/
public theorem fd_ed25519_point_eq.spec_point {X Y : Quad} {P Q : _root_.Ed25519.Point}
    (hX : X.Proj P.x P.y) (hY : Y.Proj Q.x Q.y) (rX : X.Unsigned 44) (rY : Y.Unsigned 44) :
    fd_ed25519_point_eq.spec X Y = if P = Q then 1 else 0 :=
  (fd_ed25519_point_eq.spec_val hX hY rX rY).trans
    (if_congr (_root_.Ed25519.Point.ext_iff (x := P) (y := Q)).symm rfl rfl)

end Decode

end MLIR.Firedancer.Avx512

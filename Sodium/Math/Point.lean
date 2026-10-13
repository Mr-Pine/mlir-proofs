module

public import Agave.Math.Point
public import Boringssl.Math.Point
public import Sodium.Math.Field
public import Sodium.Math.Encode
public import Sodium.ge25519_p3_to_p2
public import Sodium.ge25519_p1p1_to_p2
public import Sodium.ge25519_p1p1_to_p3
public import Sodium.ge25519_p3_to_cached
public import Sodium.ge25519_p2_0
public import Sodium.ge25519_p2_dbl
public import Sodium.ge25519_p3_dbl
public import Sodium.ge25519_add
public import Sodium.ge25519_sub
public import Sodium.ge25519_madd
public import Sodium.ge25519_msub
public import Sodium.ge25519_tobytes
public import Sodium.ge25519_frombytes_negate_vartime
public import Sodium.ge25519_is_canonical
public import Sodium.ge25519_has_small_order
public import Sodium.Math.Verify
public import Firedancer.Math.Sqrt
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.ReduceModChar
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! libsodium's point operations on the curve: each spec computes its operation on the points its
coordinates represent (`IsProj`, `IsExt`, `IsCompleted`, `IsNiels`), its limbs below a bound
(`2^52` out of a product, `2^54` into one); the encoding is `encode`, the decoding `decode`
negated, and the byte checks are `IsCanonical` and `HasSmallOrder`. -/

namespace MLIR.Sodium

open _root_.Ed25519 Agave

/-! ## Definitions -/

@[expose] public section

/-- The `ge25519_p2` `P` is `Q` in projective coordinates, its limbs below `b`. -/
def _root_.MLIR.GeP2.ProjLt (P : GeP2) (Q : Point) (b : ℕ) : Prop :=
  IsProj Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z) ∧
    Limbs.Lt P.X b ∧ Limbs.Lt P.Y b ∧ Limbs.Lt P.Z b

/-- The `ge25519_p3` `P` is `Q` in extended coordinates, its limbs below `b`. -/
def _root_.MLIR.GeP3.ExtLt (P : GeP3) (Q : Point) (b : ℕ) : Prop :=
  IsExt Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.T) (Limbs.val P.Z) ∧
    Limbs.Lt P.X b ∧ Limbs.Lt P.Y b ∧ Limbs.Lt P.Z b ∧ Limbs.Lt P.T b

/-- The `ge25519_p1p1` `P` is `Q` in completed coordinates, its limbs below `b`. -/
def _root_.MLIR.GeP1p1.ComplLt (P : GeP1p1) (Q : Point) (b : ℕ) : Prop :=
  IsCompleted Q.x Q.y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z) (Limbs.val P.T) ∧
    Limbs.Lt P.X b ∧ Limbs.Lt P.Y b ∧ Limbs.Lt P.Z b ∧ Limbs.Lt P.T b

/-- The `ge25519_cached` `P` is `Q` as `(Y + X, Y - X, Z, 2d T)`, its limbs below `b`. -/
def _root_.MLIR.GeCached.NielsLt (P : GeCached) (Q : Point) (b : ℕ) : Prop :=
  IsNiels Q.x Q.y (Limbs.val P.YplusX) (Limbs.val P.YminusX) (Limbs.val P.Z) (Limbs.val P.T2d) ∧
    Limbs.Lt P.YplusX b ∧ Limbs.Lt P.YminusX b ∧ Limbs.Lt P.Z b ∧ Limbs.Lt P.T2d b

/-- The `ge25519_precomp` `P` is `Q` as `(y + x, y - x, 2d x y)`, its limbs below `b`. -/
def _root_.MLIR.GePrecomp.NielsLt (P : GePrecomp) (Q : Point) (b : ℕ) : Prop :=
  IsAffineNiels Q.x Q.y (Limbs.val P.yplusx) (Limbs.val P.yminusx) (Limbs.val P.xy2d) ∧
    Limbs.Lt P.yplusx b ∧ Limbs.Lt P.yminusx b ∧ Limbs.Lt P.xy2d b

end

/-! ## Conversions -/

section Conversions

variable {Q : Point}

/-- `k = 2d`, limbs below `2^52`. -/
theorem k_val :
    Limbs.val Firedancer.Ref.fd_f25519_k.limbs = 2 * Ed25519.d ∧
      Limbs.Lt Firedancer.Ref.fd_f25519_k.limbs (2 ^ 52) :=
  ⟨Firedancer.Ref.fd_f25519_k.val.1, by
    rw [Limbs.lt_iff]; decide⟩

/-- `ge25519_p3_to_p2` keeps the point. -/
public theorem ge25519_p3_to_p2.spec_projLt {P : GeP3} {b : ℕ} (h : P.ExtLt Q b) :
    (Boringssl.ge_p3_to_p2.spec P).ProjLt Q b :=
  ⟨IsExt.isProj h.1, h.2.1, h.2.2.1, h.2.2.2.1⟩

/-- `ge25519_p1p1_to_p2` keeps the point. -/
public theorem ge25519_p1p1_to_p2.spec_projLt {P : GeP1p1} (h : P.ComplLt Q (2 ^ 54)) :
    (ge25519_p1p1_to_p2.spec P).ProjLt Q (2 ^ 52) := by
  obtain ⟨hc, bX, bY, bZ, bT⟩ := h
  obtain ⟨vX, tX⟩ := fe25519_mul.spec_val bX bT
  obtain ⟨vY, tY⟩ := fe25519_mul.spec_val bY bZ
  obtain ⟨vZ, tZ⟩ := fe25519_mul.spec_val bZ bT
  refine ⟨?_, tX, tY, tZ⟩
  simp only [ge25519_p1p1_to_p2.spec]
  rw [vX, vY, vZ]
  exact hc.isProj

/-- `ge25519_p1p1_to_p3` keeps the point. -/
public theorem ge25519_p1p1_to_p3.spec_extLt {P : GeP1p1} (h : P.ComplLt Q (2 ^ 54)) :
    (ge25519_p1p1_to_p3.spec P).ExtLt Q (2 ^ 52) := by
  obtain ⟨hc, bX, bY, bZ, bT⟩ := h
  obtain ⟨vX, tX⟩ := fe25519_mul.spec_val bX bT
  obtain ⟨vY, tY⟩ := fe25519_mul.spec_val bY bZ
  obtain ⟨vZ, tZ⟩ := fe25519_mul.spec_val bZ bT
  obtain ⟨vT, tT⟩ := fe25519_mul.spec_val bX bY
  refine ⟨?_, tX, tY, tZ, tT⟩
  simp only [ge25519_p1p1_to_p3.spec]
  rw [vX, vY, vZ, vT]
  exact hc.isExt

/-- `ge25519_p3_to_cached` keeps the point. -/
public theorem ge25519_p3_to_cached.spec_nielsLt {P : GeP3} (h : P.ExtLt Q (2 ^ 52)) :
    (ge25519_p3_to_cached.spec P).NielsLt Q (2 ^ 54) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := h
  obtain ⟨vp, bp⟩ := fe25519_add.spec_val tY tX (by norm_num)
  obtain ⟨vm, bm⟩ := fe25519_sub.spec_val tY (by norm_num) (tX.mono (by norm_num))
  obtain ⟨vk, tk⟩ := k_val
  obtain ⟨vt, tt⟩ := fe25519_mul.spec_val (tT.mono (by norm_num)) (tk.mono (by norm_num))
  refine
    ⟨?_, bp.mono (by norm_num), bm.mono (by norm_num), tZ.mono (by norm_num), tt.mono (by norm_num)⟩
  simp only [ge25519_p3_to_cached.spec]
  rw [vp, vm, vt, vk]
  exact IsExt.isNiels he

/-- `ge25519_p2_0` is the neutral point. -/
public theorem ge25519_p2_0.spec_projLt : Boringssl.ge_p2_0.spec.ProjLt 0 (2 ^ 52) := by
  obtain ⟨v0, t0⟩ := fe25519_0.spec_val
  obtain ⟨v1, t1⟩ := fe25519_1.spec_val
  refine ⟨?_, t0.mono (by norm_num), t1.mono (by norm_num), t1.mono (by norm_num)⟩
  simp only [Boringssl.ge_p2_0.spec, v0, v1, Point.zero_x, Point.zero_y]
  exact ⟨one_ne_zero, by ring, by ring⟩

end Conversions

/-! ## Doubling -/

section Doubling

variable {Q : Point}

/-- `ge25519_p2_dbl` doubles. -/
public theorem ge25519_p2_dbl.spec_complLt {P : GeP2} (h : P.ProjLt Q (2 ^ 52)) :
    (ge25519_p2_dbl.spec P).ComplLt (Q + Q) (2 ^ 54) := by
  obtain ⟨hp, tX, tY, tZ⟩ := h
  have hc := isCompleted_dbl hp Q.on
  rw [Point.dbl_eq] at hc
  dsimp only at hc
  obtain ⟨vX2, tX2⟩ := fe25519_sq.spec_val (tX.mono (by norm_num))
  obtain ⟨vY2, tY2⟩ := fe25519_sq.spec_val (tY.mono (by norm_num))
  obtain ⟨vZ2, tZ2⟩ := fe25519_sq2.spec_val (tZ.mono (by norm_num))
  obtain ⟨vs, bs⟩ := fe25519_add.spec_val tX tY (by norm_num)
  obtain ⟨vt0, tt0⟩ := fe25519_sq.spec_val (bs.mono (by norm_num))
  obtain ⟨vY, bY⟩ := fe25519_add.spec_val tY2 tX2 (by norm_num)
  obtain ⟨vZ, bZ⟩ := fe25519_sub.spec_val tY2 (by norm_num) (tX2.mono (by norm_num))
  obtain ⟨vX, bX⟩ := fe25519_sub.spec_val tt0 (by norm_num) (bY.mono (by norm_num))
  obtain ⟨vT, bT⟩ := fe25519_sub.spec_val tZ2 (by norm_num) (bZ.mono (by norm_num))
  refine
    ⟨?_, bX.mono (by norm_num), bY.mono (by norm_num), bZ.mono (by norm_num), bT.mono (by norm_num)⟩
  simp only [ge25519_p2_dbl.spec]
  rw [vX, vT, vY, vZ, vt0, vs, vY2, vX2, vZ2]
  exact hc

/-- `ge25519_p3_dbl` doubles. -/
public theorem ge25519_p3_dbl.spec_complLt {P : GeP3} (h : P.ExtLt Q (2 ^ 52)) :
    (ge25519_p3_dbl.spec P).ComplLt (Q + Q) (2 ^ 54) :=
  ge25519_p2_dbl.spec_complLt (ge25519_p3_to_p2.spec_projLt h)

end Doubling

/-! ## Addition -/

section Addition

variable {A B : Point}

/-- `ge25519_add` adds. -/
public theorem ge25519_add.spec_complLt {P : GeP3} {C : GeCached} (hP : P.ExtLt A (2 ^ 52))
    (hC : C.NielsLt B (2 ^ 54)) : (ge25519_add.spec P C).ComplLt (A + B) (2 ^ 54) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bz, bt⟩ := hC
  have hc := isCompleted_add_niels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fe25519_add.spec_val tY tX (by norm_num)
  obtain ⟨vrY, brY⟩ := fe25519_sub.spec_val tY (by norm_num) (tX.mono (by norm_num))
  obtain ⟨vtZ, ttZ⟩ := fe25519_mul.spec_val (brX.mono (by norm_num)) bp
  obtain ⟨vtY, ttY⟩ := fe25519_mul.spec_val (brY.mono (by norm_num)) bm
  obtain ⟨vtT, ttT⟩ := fe25519_mul.spec_val bt (tT.mono (by norm_num))
  obtain ⟨vtX, ttX⟩ := fe25519_mul.spec_val (tZ.mono (by norm_num)) bz
  obtain ⟨vt0, bt0⟩ := fe25519_add.spec_val ttX ttX (by norm_num)
  obtain ⟨vX, bX⟩ := fe25519_sub.spec_val ttZ (by norm_num) (ttY.mono (by norm_num))
  obtain ⟨vY, bY⟩ := fe25519_add.spec_val ttZ ttY (by norm_num)
  obtain ⟨vZ, bZ⟩ := fe25519_add.spec_val bt0 ttT (by norm_num)
  obtain ⟨vT, bT⟩ := fe25519_sub.spec_val bt0 (by norm_num) (ttT.mono (by norm_num))
  refine
    ⟨?_, bX.mono (by norm_num), bY.mono (by norm_num), bZ.mono (by norm_num), bT.mono (by norm_num)⟩
  simp only [ge25519_add.spec, Point.add_x, Point.add_y]
  rw [vX, vY, vZ, vT, vt0, vtZ, vtY, vtT, vtX, vrX, vrY, mul_comm (Limbs.val C.T2d)]
  exact hc

/-- `ge25519_sub` subtracts. -/
public theorem ge25519_sub.spec_complLt {P : GeP3} {C : GeCached} (hP : P.ExtLt A (2 ^ 52))
    (hC : C.NielsLt B (2 ^ 54)) : (ge25519_sub.spec P C).ComplLt (A - B) (2 ^ 54) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bz, bt⟩ := hC
  have hc := isCompleted_sub_niels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fe25519_add.spec_val tY tX (by norm_num)
  obtain ⟨vrY, brY⟩ := fe25519_sub.spec_val tY (by norm_num) (tX.mono (by norm_num))
  obtain ⟨vtZ, ttZ⟩ := fe25519_mul.spec_val (brX.mono (by norm_num)) bm
  obtain ⟨vtY, ttY⟩ := fe25519_mul.spec_val (brY.mono (by norm_num)) bp
  obtain ⟨vtT, ttT⟩ := fe25519_mul.spec_val bt (tT.mono (by norm_num))
  obtain ⟨vtX, ttX⟩ := fe25519_mul.spec_val (tZ.mono (by norm_num)) bz
  obtain ⟨vt0, bt0⟩ := fe25519_add.spec_val ttX ttX (by norm_num)
  obtain ⟨vX, bX⟩ := fe25519_sub.spec_val ttZ (by norm_num) (ttY.mono (by norm_num))
  obtain ⟨vY, bY⟩ := fe25519_add.spec_val ttZ ttY (by norm_num)
  obtain ⟨vZ, bZ⟩ := fe25519_sub.spec_val bt0 (by norm_num) (ttT.mono (by norm_num))
  obtain ⟨vT, bT⟩ := fe25519_add.spec_val bt0 ttT (by norm_num)
  refine
    ⟨?_, bX.mono (by norm_num), bY.mono (by norm_num), bZ.mono (by norm_num), bT.mono (by norm_num)⟩
  simp only [ge25519_sub.spec, Point.sub_x, Point.sub_y]
  rw [vX, vY, vZ, vT, vt0, vtZ, vtY, vtT, vtX, vrX, vrY, mul_comm (Limbs.val C.T2d)]
  exact hc

/-- `ge25519_madd` adds. -/
public theorem ge25519_madd.spec_complLt {P : GeP3} {C : GePrecomp} (hP : P.ExtLt A (2 ^ 52))
    (hC : C.NielsLt B (2 ^ 54)) : (ge25519_madd.spec P C).ComplLt (A + B) (2 ^ 54) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bt⟩ := hC
  have hc := isCompleted_add_affineNiels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fe25519_add.spec_val tY tX (by norm_num)
  obtain ⟨vrY, brY⟩ := fe25519_sub.spec_val tY (by norm_num) (tX.mono (by norm_num))
  obtain ⟨vtZ, ttZ⟩ := fe25519_mul.spec_val (brX.mono (by norm_num)) bp
  obtain ⟨vtY, ttY⟩ := fe25519_mul.spec_val (brY.mono (by norm_num)) bm
  obtain ⟨vtT, ttT⟩ := fe25519_mul.spec_val bt (tT.mono (by norm_num))
  obtain ⟨vt0, bt0⟩ := fe25519_add.spec_val tZ tZ (by norm_num)
  obtain ⟨vX, bX⟩ := fe25519_sub.spec_val ttZ (by norm_num) (ttY.mono (by norm_num))
  obtain ⟨vY, bY⟩ := fe25519_add.spec_val ttZ ttY (by norm_num)
  obtain ⟨vZ, bZ⟩ := fe25519_add.spec_val bt0 ttT (by norm_num)
  obtain ⟨vT, bT⟩ := fe25519_sub.spec_val bt0 (by norm_num) (ttT.mono (by norm_num))
  refine
    ⟨?_, bX.mono (by norm_num), bY.mono (by norm_num), bZ.mono (by norm_num), bT.mono (by norm_num)⟩
  simp only [ge25519_madd.spec, Point.add_x, Point.add_y]
  rw [vX, vY, vZ, vT, vt0, vtZ, vtY, vtT, vrX, vrY, mul_comm (Limbs.val C.xy2d)]
  exact hc

/-- `ge25519_msub` subtracts. -/
public theorem ge25519_msub.spec_complLt {P : GeP3} {C : GePrecomp} (hP : P.ExtLt A (2 ^ 52))
    (hC : C.NielsLt B (2 ^ 54)) : (ge25519_msub.spec P C).ComplLt (A - B) (2 ^ 54) := by
  obtain ⟨he, tX, tY, tZ, tT⟩ := hP
  obtain ⟨hn, bp, bm, bt⟩ := hC
  have hc := isCompleted_sub_affineNiels he hn A.on B.on
  obtain ⟨vrX, brX⟩ := fe25519_add.spec_val tY tX (by norm_num)
  obtain ⟨vrY, brY⟩ := fe25519_sub.spec_val tY (by norm_num) (tX.mono (by norm_num))
  obtain ⟨vtZ, ttZ⟩ := fe25519_mul.spec_val (brX.mono (by norm_num)) bm
  obtain ⟨vtY, ttY⟩ := fe25519_mul.spec_val (brY.mono (by norm_num)) bp
  obtain ⟨vtT, ttT⟩ := fe25519_mul.spec_val bt (tT.mono (by norm_num))
  obtain ⟨vt0, bt0⟩ := fe25519_add.spec_val tZ tZ (by norm_num)
  obtain ⟨vX, bX⟩ := fe25519_sub.spec_val ttZ (by norm_num) (ttY.mono (by norm_num))
  obtain ⟨vY, bY⟩ := fe25519_add.spec_val ttZ ttY (by norm_num)
  obtain ⟨vZ, bZ⟩ := fe25519_sub.spec_val bt0 (by norm_num) (ttT.mono (by norm_num))
  obtain ⟨vT, bT⟩ := fe25519_add.spec_val bt0 ttT (by norm_num)
  refine
    ⟨?_, bX.mono (by norm_num), bY.mono (by norm_num), bZ.mono (by norm_num), bT.mono (by norm_num)⟩
  simp only [ge25519_msub.spec, Point.sub_x, Point.sub_y]
  rw [vX, vY, vZ, vT, vt0, vtZ, vtY, vtT, vrX, vrY, mul_comm (Limbs.val C.xy2d)]
  exact hc

end Addition

/-! ## Encoding -/

section Encode

/-- `ge25519_tobytes` encodes the point. -/
public theorem ge25519_tobytes.spec_eq {P : GeP2} {Q : Point} (h : P.ProjLt Q (2 ^ 54)) :
    ge25519_tobytes.spec P = encode Q := by
  obtain ⟨⟨hz, hx, hy⟩, tX, tY, tZ⟩ := h
  obtain ⟨vr, tr⟩ := fe25519_invert.spec_val tZ
  have hr : Limbs.val P.Z * Limbs.val (fe25519_invert.spec P.Z) = 1 := by
    rw [vr, ← pow_succ', show p - 2 + 1 = p - 1 by norm_num, ZMod.pow_card_sub_one_eq_one hz]
  obtain ⟨vx, -⟩ := fe25519_mul.spec_val tX (tr.mono (by norm_num))
  obtain ⟨vy, -⟩ := fe25519_mul.spec_val tY (tr.mono (by norm_num))
  have ex : Limbs.val (fe25519_mul.spec P.X (fe25519_invert.spec P.Z)) = Q.x := by
    rw [vx, hx, mul_assoc, hr, mul_one]
  have ey : Limbs.val (fe25519_mul.spec P.Y (fe25519_invert.spec P.Z)) = Q.y := by
    rw [vy, hy, mul_assoc, hr, mul_one]
  have hs := fe25519_tobytes.spec_val (fe25519_mul.spec P.Y (fe25519_invert.spec P.Z))
  rw [ey] at hs
  have hsgn := fe25519_isnegative.spec_val (fe25519_mul.spec P.X (fe25519_invert.spec P.Z))
  rw [ex] at hsgn
  have hsgn' :
    fe25519_isnegative.spec (fe25519_mul.spec P.X (fe25519_invert.spec P.Z)) =
      BitVec.ofNat 32 (Q.x.val % 2) := by
    rw [← hsgn, BitVec.ofNat_toNat, BitVec.setWidth_eq]
  have hlt : Q.y.val < 2 ^ 255 := (ZMod.val_lt Q.y).trans (by decide)
  simp only [ge25519_tobytes.spec]
  rw [hsgn',
    Boringssl.splice_sign
      (by
        rw [hs]; exact hlt)
      (Nat.mod_lt _ (by decide)),
    hs]
  rfl

end Encode

/-! ## Decoding -/

section Decode

/-- The candidate root `x = u v³ (u v⁷)^((p - 5) / 8)` has `v x² = ±u` exactly when `u / v` is a
square. -/
theorem root_iff {u v x : ZMod p} (hv : v ≠ 0) (hx : x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    (v * x ^ 2 = u ∨ v * x ^ 2 = -u) ↔ IsSquare (u / v) := by
  by_cases hu : u = 0
  · subst hu
    simp only [hx, zero_mul, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow, mul_zero,
      true_or, zero_div, true_iff]
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
  rw [hcheck, Firedancer.Ref.isSquare_div_iff hv, ZMod.euler_criterion p hw, ← hc2, sq_eq_one_iff']
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

namespace ge25519_frombytes_negate_vartime

/-- `y` holds `s`'s low 255 bits, limbs below `2^51`. -/
theorem y_val (s : BitVec 256) :
    Limbs.val (y s) = ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧ Limbs.Lt (y s) (2 ^ 51) :=
  ⟨(fe25519_frombytes.spec_val s).2.2, (fe25519_frombytes.spec_val s).1⟩

/-- `u = y² - 1`, limbs below `2^53`. -/
theorem u_val (s : BitVec 256) :
    Limbs.val (u s) = Limbs.val (y s) ^ 2 - 1 ∧ Limbs.Lt (u s) (2 ^ 53) := by
  obtain ⟨-, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe25519_1.spec_val
  obtain ⟨vw, tw⟩ := fe25519_sq.spec_val (ty.mono (by norm_num))
  obtain ⟨vs, bs⟩ := fe25519_sub.spec_val tw (by norm_num) (t1.mono (by norm_num))
  exact ⟨by rw [u, vs, vw, v1], bs.mono (by norm_num)⟩

/-- `v = d y² + 1`, limbs below `2^53`. -/
theorem v_val (s : BitVec 256) :
    Limbs.val (v s) = Ed25519.d * Limbs.val (y s) ^ 2 + 1 ∧ Limbs.Lt (v s) (2 ^ 53) := by
  obtain ⟨-, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe25519_1.spec_val
  obtain ⟨vd, td⟩ := Firedancer.Ref.fd_f25519_d.val
  obtain ⟨vw, tw⟩ := fe25519_sq.spec_val (ty.mono (by norm_num))
  have td' : Limbs.Lt Firedancer.Ref.fd_f25519_d.limbs (2 ^ 54) := fun i => by
    have := td i; omega
  obtain ⟨vm, tm⟩ := fe25519_mul.spec_val (tw.mono (by norm_num)) td'
  obtain ⟨va, ba⟩ := fe25519_add.spec_val tm t1 (by norm_num)
  exact
    ⟨by
      rw [v, va, vm, vw, vd, v1]; ring, ba.mono (by norm_num)⟩

/-- `v³`, limbs below `2^52`. -/
theorem v3_val (s : BitVec 256) :
    Limbs.val (v3 s) = Limbs.val (v s) ^ 3 ∧ Limbs.Lt (v3 s) (2 ^ 52) := by
  obtain ⟨-, bv⟩ := v_val s
  obtain ⟨vq, tq⟩ := fe25519_sq.spec_val (bv.mono (by norm_num))
  obtain ⟨vm, tm⟩ := fe25519_mul.spec_val (tq.mono (by norm_num)) (bv.mono (by norm_num))
  exact
    ⟨by
      rw [v3, vm, vq]; ring, tm⟩

/-- The candidate `x = u v³ (u v⁷)^((p - 5) / 8)`, limbs below `2^52`. -/
theorem x_val (s : BitVec 256) :
    Limbs.val (x s) =
        Limbs.val (u s) * Limbs.val (v s) ^ 3 *
          (Limbs.val (u s) * Limbs.val (v s) ^ 7) ^ ((p - 5) / 8) ∧
      Limbs.Lt (x s) (2 ^ 52) := by
  obtain ⟨-, bu⟩ := u_val s
  obtain ⟨-, bv⟩ := v_val s
  obtain ⟨v3v, t3⟩ := v3_val s
  obtain ⟨vq, tq⟩ := fe25519_sq.spec_val (t3.mono (by norm_num))
  obtain ⟨vm1, tm1⟩ := fe25519_mul.spec_val (tq.mono (by norm_num)) (bv.mono (by norm_num))
  obtain ⟨vm2, tm2⟩ := fe25519_mul.spec_val (tm1.mono (by norm_num)) (bu.mono (by norm_num))
  obtain ⟨vp, tp⟩ := fe25519_pow22523.spec_val (tm2.mono (by norm_num))
  obtain ⟨vm3, tm3⟩ := fe25519_mul.spec_val (tp.mono (by norm_num)) (t3.mono (by norm_num))
  obtain ⟨vm4, tm4⟩ := fe25519_mul.spec_val (tm3.mono (by norm_num)) (bu.mono (by norm_num))
  exact
    ⟨by
      rw [x, vm4, vm3, vp, vm2, vm1, vq, v3v]; ring, tm4⟩

/-- `v x²`, limbs below `2^52`. -/
theorem vxx_val (s : BitVec 256) :
    Limbs.val (vxx s) = Limbs.val (v s) * Limbs.val (x s) ^ 2 ∧ Limbs.Lt (vxx s) (2 ^ 52) := by
  obtain ⟨-, bv⟩ := v_val s
  obtain ⟨-, tx⟩ := x_val s
  obtain ⟨vq, tq⟩ := fe25519_sq.spec_val (tx.mono (by norm_num))
  obtain ⟨vm, tm⟩ := fe25519_mul.spec_val (tq.mono (by norm_num)) (bv.mono (by norm_num))
  exact
    ⟨by
      rw [vxx, vm, vq]; ring, tm⟩

/-- The first check fails exactly when `v x² ≠ u`. -/
theorem m_root_eq_zero (s : BitVec 256) :
    fe25519_iszero.spec (m_root_check s) = 0#32 ↔
      ¬Limbs.val (v s) * Limbs.val (x s) ^ 2 = Limbs.val (u s) := by
  obtain ⟨vv, tv⟩ := vxx_val s
  obtain ⟨-, bu⟩ := u_val s
  obtain ⟨vs, -⟩ := fe25519_sub.spec_val tv (by norm_num) (bu.mono (by norm_num))
  rw [m_root_check, fe25519_iszero.spec_val, vs, vv]
  split <;> simp_all [sub_eq_zero]

/-- The second check fails exactly when `v x² ≠ -u`. -/
theorem p_root_eq_zero (s : BitVec 256) :
    fe25519_iszero.spec (p_root_check s) = 0#32 ↔
      ¬Limbs.val (v s) * Limbs.val (x s) ^ 2 = -Limbs.val (u s) := by
  obtain ⟨vv, tv⟩ := vxx_val s
  obtain ⟨-, bu⟩ := u_val s
  obtain ⟨va, -⟩ := fe25519_add.spec_val tv bu (by norm_num)
  rw [p_root_check, fe25519_iszero.spec_val, va, vv]
  split <;> simp_all [add_eq_zero_iff_eq_neg]

/-- On the curve with `s`'s `y` exactly when `v x² = u`. -/
theorem onCurve_iff (s : BitVec 256) (a : ZMod p) :
    OnCurve a (Limbs.val (y s)) ↔ Limbs.val (v s) * a ^ 2 = Limbs.val (u s) := by
  rw [Ed25519.onCurve_iff, (v_val s).1, (u_val s).1]
  constructor <;> intro h <;> linear_combination h

/-- `sign s` is `s`'s top bit. -/
theorem sign_eq (s : BitVec 256) : sign s = BitVec.ofNat 32 (s.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [sign, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := s.isLt
  omega

/-- `point s X` for a root `X` is the negation of the point `s` encodes, `Z = 1`. -/
theorem point_ext {s : BitVec 256} {X : Fin 5 → BitVec 64} (hX : Limbs.Lt X (2 ^ 52))
    (hr : OnCurve (Limbs.val X) (Limbs.val (y s))) :
    ∃ Q, decode s = some Q ∧ (point s X).ExtLt (-Q) (2 ^ 52) ∧ Limbs.val (point s X).Z = 1 := by
  obtain ⟨vy, ty⟩ := y_val s
  obtain ⟨v1, t1⟩ := fe25519_1.spec_val
  have hb : s.toNat / 2 ^ 255 < 2 := by
    have := s.isLt
    omega
  have hpar : (Limbs.val X).val % 2 < 2 := Nat.mod_lt _ (by decide)
  -- the root of the asked sign, `-X'`, and `X'` stored
  obtain ⟨X', hX', tX', hc, hd⟩ :
    ∃ X',
      negated s X = X' ∧
        Limbs.Lt X' (2 ^ 52) ∧
        (Limbs.val X' = Limbs.val X ∨ Limbs.val X' = -Limbs.val X) ∧
        (-Limbs.val X' = 0 ∨ (-Limbs.val X').val % 2 = s.toNat / 2 ^ 255) :=
    by
    refine ⟨_, rfl, ?_⟩
    have hval : ∀ a : ZMod p, a ≠ 0 → (-a).val = p - a.val := fun a ha => by
      rw [ZMod.neg_val, ite_eq_right ha]
    have hp2 : p % 2 = 1 := by norm_num
    have hsgn : fe25519_isnegative.spec X = sign s ↔ (Limbs.val X).val % 2 = s.toNat / 2 ^ 255 := by
      rw [sign_eq, ← BitVec.toNat_inj, fe25519_isnegative.spec_val, BitVec.toNat_ofNat,
        Nat.mod_eq_of_lt (a := s.toNat / 2 ^ 255) (by omega)]
    simp only [negated]
    split
    · obtain ⟨vn, tn⟩ := fe25519_neg.spec_val (hX.mono (by norm_num))
      refine ⟨tn, .inr vn, ?_⟩
      rw [vn, neg_neg]
      by_cases h0 : Limbs.val X = 0
      · exact .inl h0
      · exact .inr (hsgn.1 ‹_›)
    · refine ⟨hX, .inl rfl, ?_⟩
      by_cases h0 : Limbs.val X = 0
      · exact .inl (by rw [h0, neg_zero])
      · refine .inr ?_
        have hne := (not_congr hsgn).1 ‹_›
        have hlt := ZMod.val_lt (Limbs.val X)
        have hpos : 0 < (Limbs.val X).val := (ZMod.val_pos).2 h0
        rw [hval _ h0]
        omega
  have hon : OnCurve (-Limbs.val X') (Limbs.val (y s)) := by
    rcases hc with h | h <;> rw [h]
    · exact hr.neg
    · rw [neg_neg]; exact hr
  obtain ⟨vT, tT⟩ := fe25519_mul.spec_val (tX'.mono (by norm_num)) (ty.mono (by norm_num))
  refine ⟨⟨_, _, hon⟩, decode_eq_some ⟨vy, hd⟩, ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩, v1⟩
  all_goals simp only [point, hX', Point.neg_x, Point.neg_y, neg_neg]
  · rw [v1]; exact one_ne_zero
  · rw [v1, mul_one]
  · rw [v1, mul_one]
  · rw [vT, v1, mul_one]
  · exact ⟨tX', ty.mono (by norm_num), t1.mono (by norm_num), tT⟩

end ge25519_frombytes_negate_vartime

open ge25519_frombytes_negate_vartime in
/-- `ge25519_frombytes_negate_vartime` fails exactly when `decode` does. -/
public theorem ge25519_frombytes_negate_vartime.spec_eq_none_iff (s : BitVec 256) :
    ge25519_frombytes_negate_vartime.spec s = none ↔ decode s = none := by
  have hv : Limbs.val (v s) ≠ 0 := by
    rw [(v_val s).1]
    exact v_ne _
  have key := root_iff (x := Limbs.val (x s)) hv (x_val s).1
  rw [decode_eq_none, ← not_exists, exists_decodes_iff, ← (y_val s).1, exists_onCurve_iff, ←
    (u_val s).1, ← (v_val s).1, ← key]
  simp only [ge25519_frombytes_negate_vartime.spec]
  split_ifs with h1 h2 <;> simp_all [m_root_eq_zero, p_root_eq_zero]

open ge25519_frombytes_negate_vartime in
/-- A point `ge25519_frombytes_negate_vartime` decodes is the negation of the one `decode` finds,
`Z = 1`. -/
public theorem ge25519_frombytes_negate_vartime.spec_some {s : BitVec 256} {P : GeP3}
    (h : ge25519_frombytes_negate_vartime.spec s = some P) :
    ∃ Q, decode s = some Q ∧ P.ExtLt (-Q) (2 ^ 52) ∧ Limbs.val P.Z = 1 := by
  obtain ⟨vx, tx⟩ := x_val s
  simp only [ge25519_frombytes_negate_vartime.spec] at h
  split_ifs at h with h1 h2
  · obtain rfl := Option.some.inj h
    obtain ⟨vi, ti⟩ := Firedancer.Ref.fd_f25519_sqrtm1.val
    have ti' : Limbs.Lt Firedancer.Ref.fd_f25519_sqrtm1.limbs (2 ^ 54) := fun i => by
      have := ti i; omega
    obtain ⟨vm, tm⟩ := fe25519_mul.spec_val (tx.mono (by norm_num)) ti'
    refine point_ext tm ((onCurve_iff s _).2 ?_)
    have h2' : Limbs.val (v s) * Limbs.val (x s) ^ 2 = -Limbs.val (u s) := by
      by_contra hc
      exact h2 ((p_root_eq_zero s).2 hc)
    rw [vm, vi, mul_pow, sqrtM1_sq, ← mul_assoc, h2']
    ring
  · obtain rfl := Option.some.inj h
    exact point_ext tx ((onCurve_iff s _).2 (not_not.1 ((not_congr (m_root_eq_zero s)).1 h1)))

end Decode

/-! ## The byte checks -/

section Bytes

/-- `s`'s low 255 bits, as a number. -/
theorem toNat_and_low (s : BitVec 256) :
    (s &&& 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256).toNat =
      s.toNat % 2 ^ 255 := by
  rw [BitVec.toNat_and,
    show
      (0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256 : BitVec 256).toNat =
        2 ^ 255 - 1
      from rfl,
    Nat.and_two_pow_sub_one_eq_mod]

/-- `ge25519_is_canonical.spec` as one comparison of the low 255 bits. -/
theorem ge25519_is_canonical.spec_bv (s : BitVec 256) :
    ge25519_is_canonical.spec s =
      if
          (s &&& 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256) <
            0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed#256 then
        1#32
      else 0#32 := by
  simp only [ge25519_is_canonical.spec, orBytes]
  bv_decide

/-- `ge25519_is_canonical` is `1` exactly on `IsCanonical`. -/
public theorem ge25519_is_canonical.spec_eq (s : BitVec 256) :
    ge25519_is_canonical.spec s = if Sodium.IsCanonical s then 1#32 else 0#32 := by
  rw [ge25519_is_canonical.spec_bv]
  congr 1
  rw [BitVec.lt_def, toNat_and_low]
  rfl

/-- `ge25519_has_small_order.spec` as comparisons of the low 255 bits with the table. -/
theorem ge25519_has_small_order.spec_bv (s : BitVec 256) :
    ge25519_has_small_order.spec s =
      if
          (s &&& 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256) ∈
            ge25519_has_small_order.blacklist then
        1#32
      else 0#32 := by
  simp only [ge25519_has_small_order.spec, ge25519_has_small_order.blacklist, orBytes, List.foldl,
    List.mem_cons, List.not_mem_nil, or_false]
  bv_decide

/-- `ge25519_has_small_order` is `1` exactly on `HasSmallOrder`. -/
public theorem ge25519_has_small_order.spec_eq (s : BitVec 256) :
    ge25519_has_small_order.spec s = if Sodium.HasSmallOrder s then 1#32 else 0#32 := by
  rw [ge25519_has_small_order.spec_bv]
  congr 1
  have e (t : BitVec 256) (n : ℕ) (hn : t.toNat = n) :
    (s &&& 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256) = t ↔
      s.toNat % 2 ^ 255 = n := by
    rw [← BitVec.toNat_inj, toNat_and_low, hn]
  simp only [ge25519_has_small_order.blacklist, Sodium.HasSmallOrder, Sodium.blacklist,
    List.mem_cons, List.not_mem_nil, or_false]
  rw [e _ _ rfl, e _ _ rfl, e _ _ rfl, e _ _ rfl, e _ _ rfl, e _ _ rfl, e _ _ rfl]
  norm_num

end Bytes

end MLIR.Sodium

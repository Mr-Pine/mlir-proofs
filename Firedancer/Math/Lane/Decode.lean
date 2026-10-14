module

public import Firedancer.Math.Lane.Point
public import Ed25519.Decode
import Firedancer.Math.Decode
import Firedancer.Math.Lane.Canon
import Firedancer.Math.Lane.Pow
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! `fd_ed25519_lane_decode2` and `fd_ed25519_lane_small_order` in the group: lane `j` decodes as
`Ed25519.decode` (identity where it fails), and its small-order bit is `8 P = 0`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d sqrtM1 y8 decode)

/-! ## Lanes and bounds -/

theorem Fe.ite_val (c : BitVec 32) (a b : Fe) (j : Fin 8) :
    (Fe.ite c a b).val j = if c.getLsbD j then a.val j else b.val j := by
  simp only [Fe.val, Fe.ite_lane]
  split <;> rfl

theorem Fe.ite_le {c : BitVec 32} {a b : Fe} {B : Fin 5 → ℕ} (ha : a.Le B) (hb : b.Le B) :
    (Fe.ite c a b).Le B := fun j i => by
  rw [Fe.ite_lane]
  split
  exacts [ha j i, hb j i]

/-- `1`'s limbs. -/
theorem Fe.one_le : Fe.one.Le fun i => if i = 0 then 1 else 0 := by
  intro j i
  fin_cases i <;> simp [Fe.one, Fe.small]

/-- Carried limbs are below `2^53`, as `fd_ed25519_lane_is_zero` asks. -/
theorem Fe.Carried.le53 {a : Fe} (h : a.Carried) : a.Le fun _ => 2 ^ 53 - 1 :=
  h.mono fun i => by unfold carriedB; split <;> norm_num

theorem Fe.F52.le53 {a : Fe} (h : a.F52) : a.Le fun _ => 2 ^ 53 - 1 :=
  h.mono fun i => by norm_num

/-- Masks of lanes `0 … 7` stay masks under `|`. -/
theorem or_lt {a b : BitVec 32} (ha : a.toNat < 2 ^ 8) (hb : b.toNat < 2 ^ 8) :
    (a ||| b).toNat < 2 ^ 8 := by
  rw [BitVec.toNat_or]
  exact Nat.or_lt_two_pow ha hb

/-- The encodings' `y`: limbs below `2^51`. -/
theorem y_le (b : Fin 8 → BitVec 256) :
    (Fe.ofLanes fun j => limbsOfBytes (b j)).Le fun _ => 2 ^ 51 - 1 := fun j i => by
  rw [Fe.ofLanes_lane]
  have := limbsOfBytes_lt (b j) i
  dsimp only
  omega

theorem y_carried (b : Fin 8 → BitVec 256) : (Fe.ofLanes fun j => limbsOfBytes (b j)).Carried :=
  (y_le b).mono fun i => by unfold carriedB; split <;> norm_num

/-- `d y² + 1` from a carried `d y²`: f52. -/
theorem addRaw_one_f52 {a : Fe} (ha : a.Carried) : (addRaw a Fe.one).F52 :=
  (addRaw_le ha Fe.one_le fun i => by fin_cases i <;> simp [carriedB]).mono fun i => by
    fin_cases i <;> simp [carriedB]

/-! ## Decompression -/

/-- `decPre`'s bounds: `y`, `u`, `u v³`, `u v⁷` carried, `v` f52. -/
theorem decPre_bounded {dd : Fe} (hdb : dd.Carried) (b : Fin 8 → BitVec 256) :
    let pre := decPre dd b
    pre.y.Carried ∧ pre.u.Carried ∧ pre.v.F52 ∧ pre.uv3.Carried ∧ pre.uv7.Carried := by
  have hy := y_carried b
  have hy2 := sqr_carried hy.f52
  have hv := addRaw_one_f52 (mul_carried hy2.f52 hdb.f52)
  have hu : (sub (sqr (Fe.ofLanes fun j => limbsOfBytes (b j))) Fe.one).Carried := carry_carried _
  have hv2 := sqr_carried hv
  have hv3 := mul_carried hv2.f52 hv
  exact ⟨hy, hu, hv, mul_carried hu.f52 hv3.f52,
    mul_carried (mul_carried (sqr_carried hv3.f52).f52 hv).f52 hu.f52⟩

/-- `decPre`'s lane `j`: `y` the encoding's low 255 bits, `u = y² - 1`, `v = d y² + 1`, `u v³`,
`u v⁷`. -/
theorem decPre_val {dd : Fe} (hd : ∀ j, dd.val j = d) (hdb : dd.Carried) (b : Fin 8 → BitVec 256)
    (j : Fin 8) :
    let pre := decPre dd b
    let y : ZMod p := ((b j).toNat % 2 ^ 255 : ℕ)
    let u := y ^ 2 - 1
    let v := d * y ^ 2 + 1
    pre.y.val j = y ∧ pre.u.val j = u ∧ pre.v.val j = v ∧ pre.uv3.val j = u * v ^ 3 ∧
      pre.uv7.val j = u * v ^ 7 := by
  dsimp only
  obtain ⟨hy, hu, hv, -, -⟩ := decPre_bounded hdb b
  generalize hP : decPre dd b = P at hy hu hv
  have ey : P.y = Fe.ofLanes fun j => limbsOfBytes (b j) := by rw [← hP]; rfl
  have eu : P.u = sub (sqr P.y) Fe.one := by rw [← hP]; rfl
  have ev : P.v = addRaw (mul (sqr P.y) dd) Fe.one := by rw [← hP]; rfl
  have e3 : P.uv3 = mul P.u (mul (sqr P.v) P.v) := by rw [← hP]; rfl
  have e7 : P.uv7 = mul (mul (sqr (mul (sqr P.v) P.v)) P.v) P.u := by rw [← hP]; rfl
  have vy : P.y.val j = ((b j).toNat % 2 ^ 255 : ℕ) := by
    rw [ey, Fe.val, Fe.ofLanes_lane, limbsOfBytes_val]
  have hy2 := sqr_carried hy.f52
  have hm := mul_carried hy2.f52 hdb.f52
  have vu : P.u.val j = (((b j).toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 - 1 := by
    rw [eu, sub_val hy2.f52 Fe.one_carried.f52, sqr_val hy.f52, vy, Fe.one_val]
  have vv : P.v.val j = d * (((b j).toNat % 2 ^ 255 : ℕ) : ZMod p) ^ 2 + 1 := by
    rw [ev, addRaw_val hm Fe.one_le (fun i => by fin_cases i <;> simp [carriedB]),
      mul_val hy2.f52 hdb.f52, sqr_val hy.f52, vy, hd, Fe.one_val]
    ring
  have hv2 := sqr_carried hv
  have hv3 := mul_carried hv2.f52 hv
  have v3 : (mul (sqr P.v) P.v).val j = (P.v.val j) ^ 3 := by
    rw [mul_val hv2.f52 hv, sqr_val hv]; ring
  refine ⟨vy, vu, vv, ?_, ?_⟩
  · rw [e3, mul_val hu.f52 hv3.f52, v3, vu, vv]
  · rw [e7, mul_val (mul_carried (sqr_carried hv3.f52).f52 hv).f52 hu.f52,
      mul_val (sqr_carried hv3.f52).f52 hv, sqr_val hv3.f52, v3, vv, vu]
    ring

/-- `decFin`'s bounds from carried `y`, `u v³` and power `x0`. -/
theorem decFin_bounds {sqrtm1 : Fe} (hsb : sqrtm1.Carried) (sign : BitVec 32) {pre : DecPre}
    {x0 : Fe} (hy : pre.y.Carried) (h3 : pre.uv3.Carried) (hx0 : x0.Carried) :
    let R := decFin sqrtm1 sign pre x0
    R.1.x.F52 ∧ R.1.y.Carried ∧ R.1.z = Fe.one ∧ R.1.t.Carried ∧ R.2.toNat < 2 ^ 8 := by
  have hx := mul_carried hx0.f52 h3.f52
  have hx1 (c : BitVec 32) : (Fe.ite c (mul (mul x0 pre.uv3) sqrtm1) (mul x0 pre.uv3)).Carried :=
    Fe.ite_le (mul_carried hx.f52 hsb.f52) hx
  have hX (c c' v : BitVec 32) :
      (Fe.ite v (Fe.ite c' (neg (Fe.ite c (mul (mul x0 pre.uv3) sqrtm1) (mul x0 pre.uv3)))
        (Fe.ite c (mul (mul x0 pre.uv3) sqrtm1) (mul x0 pre.uv3))) Fe.zero).F52 :=
    Fe.ite_le (Fe.ite_le (neg_f52 (hx1 c)) (hx1 c).f52) Fe.zero_carried.f52
  have hY (v : BitVec 32) : (Fe.ite v pre.y Fe.one).Carried := Fe.ite_le hy Fe.one_carried
  exact ⟨hX _ _ _, hY _, rfl, mul_carried (hX _ _ _) (hY _).f52, or_lt (isZero_lt _) (isZero_lt _)⟩

/-- The sign fix-up: `X` negated when its parity is not `s`; `±X`, and zero or of parity `s`. -/
theorem fixSign (X : ZMod p) (s : Bool) :
    let X' := if (s ^^ decide (X.val % 2 = 1)) = true then -X else X
    (X' = X ∨ X' = -X) ∧ (X' = 0 ∨ decide (X'.val % 2 = 1) = s) := by
  intro X'
  by_cases h : (s ^^ decide (X.val % 2 = 1)) = true
  · have e : X' = -X := ite_eq_left h
    refine ⟨.inr e, ?_⟩
    rw [e]
    by_cases h0 : X = 0
    · exact .inl (by rw [h0, neg_zero])
    refine .inr ?_
    rw [ZMod.neg_val, ite_eq_right h0]
    have := ZMod.val_lt X
    have : X.val ≠ 0 := by rwa [ne_eq, ZMod.val_eq_zero]
    have hp : p % 2 = 1 := by norm_num
    cases s <;> simp only [Bool.false_xor, Bool.true_xor, decide_eq_true_eq, Bool.not_eq_true',
      decide_eq_false_iff_not] at h ⊢ <;> omega
  · have e : X' = X := ite_eq_right h
    refine ⟨.inl e, .inr ?_⟩
    rw [e]
    cases s <;> simpa using h

open _root_.Ed25519 (OnCurve) in
/-- `decFin` at lane `j`, `x0 u v³` the candidate root: the mask bit is some point having `y`; then
`x` is one, zero or of the sign bit's parity, else the lane is `(0, 1)`. -/
theorem decFin_spec {sqrtm1 : Fe} (hs : ∀ j, sqrtm1.val j = sqrtM1) (hsb : sqrtm1.Carried)
    (sign : BitVec 32) {pre : DecPre} {x0 : Fe} (hu : pre.u.Carried)
    (hv : pre.v.F52) (h3 : pre.uv3.Carried) (hx0 : x0.Carried) (j : Fin 8) {y : ZMod p}
    (vy : pre.y.val j = y) (vu : pre.u.val j = y ^ 2 - 1) (vv : pre.v.val j = d * y ^ 2 + 1)
    (vx : (mul x0 pre.uv3).val j =
      (y ^ 2 - 1) * (d * y ^ 2 + 1) ^ 3 * ((y ^ 2 - 1) * (d * y ^ 2 + 1) ^ 7) ^ ((p - 5) / 8)) :
    let R := decFin sqrtm1 sign pre x0
    (R.2.getLsbD j ↔ ∃ x, OnCurve x y) ∧
      (R.2.getLsbD j → OnCurve (R.1.x.val j) y ∧
        (R.1.x.val j = 0 ∨ decide ((R.1.x.val j).val % 2 = 1) = sign.getLsbD j) ∧
        R.1.y.val j = y) ∧
      (R.2.getLsbD j = false → R.1.x.val j = 0 ∧ R.1.y.val j = 1) := by
  dsimp only [decFin]
  have hj : (j : ℕ) < 32 := by omega
  have hx := mul_carried hx0.f52 h3.f52
  generalize mul x0 pre.uv3 = x at hx vx ⊢
  have hc := mul_carried (sqr_carried hx.f52).f52 hv
  have vc : (mul (sqr x) pre.v).val j = (d * y ^ 2 + 1) * x.val j ^ 2 := by
    rw [mul_val (sqr_carried hx.f52).f52 hv, sqr_val hx.f52, vv]; ring
  generalize mul (sqr x) pre.v = check at hc vc ⊢
  have bc : (isZero (subRaw check pre.u)).getLsbD j =
      decide ((d * y ^ 2 + 1) * x.val j ^ 2 - (y ^ 2 - 1) = 0) := by
    rw [isZero_getLsbD ((subRaw_le hc hu fun i => by fin_cases i <;> simp [carriedB]).mono
      fun i => by fin_cases i <;> simp [carriedB]), subRaw_val hc hu (fun i => by
        fin_cases i <;> simp [carriedB]), vc, vu]
  have bf : (isZero (addRaw check pre.u)).getLsbD j =
      decide ((d * y ^ 2 + 1) * x.val j ^ 2 + (y ^ 2 - 1) = 0) := by
    rw [isZero_getLsbD ((addRaw_le hc hu fun i => by fin_cases i <;> simp [carriedB]).mono
      fun i => by fin_cases i <;> simp [carriedB]), addRaw_val hc hu (fun i => by
        fin_cases i <;> simp [carriedB]), vc, vu]
  generalize isZero (subRaw check pre.u) = cor at bc ⊢
  generalize isZero (addRaw check pre.u) = fl at bf ⊢
  have hx1 : (Fe.ite (fl &&& ~~~cor) (mul x sqrtm1) x).Carried :=
    Fe.ite_le (mul_carried hx.f52 hsb.f52) hx
  have vx1 : (Fe.ite (fl &&& ~~~cor) (mul x sqrtm1) x).val j =
      if fl.getLsbD j && !cor.getLsbD j then x.val j * sqrtM1 else x.val j := by
    rw [Fe.ite_val, mul_val hx.f52 hsb.f52, hs, BitVec.getLsbD_and, BitVec.getLsbD_not,
      decide_eq_true hj, Bool.true_and]
  have par := parity_getLsbD hx1.le53 j
  generalize Fe.ite (fl &&& ~~~cor) (mul x sqrtm1) x = x1 at hx1 vx1 par ⊢
  simp only [Fe.ite_val, BitVec.getLsbD_xor, BitVec.getLsbD_or, par, neg_val hx1 j, Fe.zero_val,
    Fe.one_val, vy]
  simp only [vx1, bc, bf]
  generalize x.val j = X at vx ⊢
  have key : ((d * y ^ 2 + 1) * X ^ 2 - (y ^ 2 - 1) = 0 ∨ (d * y ^ 2 + 1) * X ^ 2 + (y ^ 2 - 1) = 0)
      ↔ ∃ x, OnCurve x y := by
    rw [Ed25519.exists_onCurve_iff, ← Ref.sqrt_ratio_iff (Ed25519.v_ne y) vx]
    constructor <;> rintro (h | h)
    exacts [.inl (by linear_combination h), .inr (by linear_combination h),
      .inl (by linear_combination h), .inr (by linear_combination h)]
  by_cases c1 : (d * y ^ 2 + 1) * X ^ 2 - (y ^ 2 - 1) = 0
  · have hc : OnCurve X y := by rw [Ed25519.onCurve_iff]; linear_combination c1
    obtain ⟨e, hz⟩ := fixSign X (sign.getLsbD j)
    simp only [c1, decide_true, Bool.true_or, Bool.not_true, Bool.and_false, Bool.false_eq_true,
      ite_false, ite_true, true_iff, true_implies, Bool.true_eq_false, false_implies, and_true]
    refine ⟨key.1 (.inl c1), ?_, hz⟩
    rcases e with e | e <;> rw [e]
    exacts [hc, hc.neg]
  by_cases c2 : (d * y ^ 2 + 1) * X ^ 2 + (y ^ 2 - 1) = 0
  · have hc : OnCurve (X * sqrtM1) y := by
      rw [Ed25519.onCurve_iff]
      linear_combination (-1 : ZMod p) * c2 + (y ^ 2 * d + 1) * X ^ 2 * Ed25519.sqrtM1_sq
    obtain ⟨e, hz⟩ := fixSign (X * sqrtM1) (sign.getLsbD j)
    simp only [c1, c2, decide_true, decide_false, Bool.false_or, Bool.not_false, Bool.and_true,
      ite_true, true_iff, true_implies, Bool.true_eq_false, false_implies, and_true]
    refine ⟨key.1 (.inr c2), ?_, hz⟩
    rcases e with e | e <;> rw [e]
    exacts [hc, hc.neg]
  · simp only [c1, c2, decide_false, Bool.false_or, Bool.false_eq_true, ite_false, false_iff,
      false_implies, and_true, true_implies, not_exists]
    exact fun x hx => (key.2 ⟨x, hx⟩).elim c1 c2

/-- The sign bit of lane `j`: the encoding's top bit. -/
theorem signs_getLsbD (b : Fin 8 → BitVec 256) (j : Fin 8) :
    (signs b).getLsbD j = decide ((b j).toNat / 2 ^ 255 % 2 = 1) := by
  rw [signs, getLsbD_lanes, BitVec.getLsbD, Nat.testBit_eq_decide_div_mod_eq]

/-- One set of `fd_ed25519_lane_decode2`: bit `j` of the mask is lane `j` decoding; a decoded
lane holds the point with `z = 1`, a failed one the identity. -/
public theorem decFin_decode {dd sqrtm1 : Fe} (hd : ∀ j, dd.val j = d) (hdb : dd.Carried)
    (hs : ∀ j, sqrtm1.val j = sqrtM1) (hsb : sqrtm1.Carried) (b : Fin 8 → BitVec 256)
    (j : Fin 8) :
    let pre := decPre dd b
    let R := decFin sqrtm1 (signs b) pre (pow22523 pre.uv7)
    R.2.getLsbD j = (decode (b j)).isSome ∧
      (∀ P, decode (b j) = some P → R.1.Ext j P) ∧
      (decode (b j) = none → R.1.Ext j 0) := by
  dsimp only
  obtain ⟨hy, hu, hv, h3, h7⟩ := decPre_bounded hdb b
  obtain ⟨vy, vu, vv, v3, v7⟩ := decPre_val hd hdb b j
  have hx0 := pow22523_carried h7.f52
  obtain ⟨hval, hok, hfail⟩ := decFin_spec hs hsb (signs b) hu hv h3 hx0 j vy vu vv
    (by rw [mul_val hx0.f52 h3.f52, pow22523_val h7.f52, v7, v3]; generalize (p - 5) / 8 = e; ring)
  obtain ⟨hxb, hyb, hz, -, -⟩ := decFin_bounds hsb (signs b) hy h3 hx0
  have ht : (decFin sqrtm1 (signs b) (decPre dd b) (pow22523 (decPre dd b).uv7)).1.t =
      mul (decFin sqrtm1 (signs b) (decPre dd b) (pow22523 (decPre dd b).uv7)).1.x
        (decFin sqrtm1 (signs b) (decPre dd b) (pow22523 (decPre dd b).uv7)).1.y := rfl
  generalize decFin sqrtm1 (signs b) (decPre dd b) (pow22523 (decPre dd b).uv7) = R at *
  have vt : R.1.t.val j = R.1.x.val j * R.1.y.val j := by rw [ht, mul_val hxb hyb.f52]
  have vz : R.1.z.val j = 1 := by rw [hz, Fe.one_val]
  rw [signs_getLsbD] at hok
  have hsome : (decode (b j)).isSome = true ↔
      ∃ x, Ed25519.OnCurve x ((b j).toNat % 2 ^ 255 : ℕ) := by
    rw [Option.isSome_iff_ne_none, ne_eq, Ed25519.decode_eq_none, not_forall_not,
      Ed25519.exists_decodes_iff]
  have hm : R.2.getLsbD j = (decode (b j)).isSome := Bool.eq_iff_iff.2 (hval.trans hsome.symm)
  refine ⟨hm, fun P hP => ?_, fun hP => ?_⟩
  · have hv : R.2.getLsbD j = true := by rw [hm, hP]; rfl
    obtain ⟨hc, hpar, hy'⟩ := hok hv
    have hQ : Ed25519.Decodes (b j) ⟨R.1.x.val j, _, hc⟩ := by
      refine ⟨rfl, hpar.imp_right fun h => ?_⟩
      have := (b j).isLt
      have : (b j).toNat / 2 ^ 255 < 2 := by omega
      have := Nat.mod_lt (R.1.x.val j).val (show 2 > 0 by norm_num)
      rw [decide_eq_decide] at h
      dsimp only
      omega
    obtain rfl := (Ed25519.decodes_of_decode hP).unique hQ
    exact ⟨by rw [vz]; exact one_ne_zero, by rw [vz, mul_one], by rw [vz, mul_one, hy'],
      by rw [vz, mul_one, vt]⟩
  · have hv : R.2.getLsbD j = false := by rw [hm, hP]; rfl
    obtain ⟨hx', hy'⟩ := hfail hv
    exact ⟨by rw [vz]; exact one_ne_zero, by rw [vz, mul_one, hx', Ed25519.Point.zero_x],
      by rw [vz, mul_one, hy', Ed25519.Point.zero_y], by rw [vz, mul_one, vt, hx', zero_mul]⟩

/-- The decoded points' bounds: `x` f52, `y`, `t` carried, `z = 1`. -/
public theorem decFin_bounded {dd sqrtm1 : Fe} (hdb : dd.Carried) (hsb : sqrtm1.Carried)
    (b : Fin 8 → BitVec 256) :
    let pre := decPre dd b
    let R := decFin sqrtm1 (signs b) pre (pow22523 pre.uv7)
    R.1.x.F52 ∧ R.1.y.Carried ∧ R.1.z = Fe.one ∧ R.1.t.Carried ∧ R.2.toNat < 2 ^ 8 :=
  let h := decPre_bounded hdb b
  decFin_bounds hsb (signs b) h.1 h.2.2.2.1 (pow22523_carried h.2.2.2.2.f52)

/-! ## Small order -/

/-- Bit `j` of `fd_ed25519_lane_small_order` is `8 P = 0` for lane `j`'s affine `P`; `y0`, `y1` the
order-8 `y`s. -/
public theorem smallOrder_getLsbD {y0 y1 : Fe} (hy0 : ∀ j, y0.val j = y8)
    (hy1 : ∀ j, y1.val j = -y8) (hy0b : y0.Carried) (hy1b : y1.Carried) {r : Point} {j : Fin 8}
    {P : Ed25519.Point} (hx : r.x.val j = P.x) (hy : r.y.val j = P.y) (hxb : r.x.F52)
    (hyb : r.y.Carried) : (smallOrder y0 y1 r).getLsbD j = decide (8 • P = 0) := by
  have hs (c : Fe) (hc : c.Carried) : (subRaw r.y c).Le fun _ => 2 ^ 53 - 1 :=
    (subRaw_le hyb hc fun i => by fin_cases i <;> simp [carriedB]).mono fun i => by
      fin_cases i <;> simp [carriedB]
  have hv (c : Fe) (hc : c.Carried) : (subRaw r.y c).val j = r.y.val j - c.val j :=
    subRaw_val hyb hc (fun i => by fin_cases i <;> simp [carriedB]) j
  rw [smallOrder, BitVec.getLsbD_or, BitVec.getLsbD_or, BitVec.getLsbD_or,
    isZero_getLsbD hxb.le53, isZero_getLsbD hyb.le53, isZero_getLsbD (hs y0 hy0b),
    isZero_getLsbD (hs y1 hy1b), hv y0 hy0b, hv y1 hy1b, hx, hy, hy0, hy1, Bool.eq_iff_iff]
  simp only [Bool.or_eq_true, decide_eq_true_eq, ← Ed25519.Point.smallOrder_iff_nsmul,
    Ed25519.smallOrder_iff P.on, sub_eq_zero, sub_neg_eq_add, ← eq_neg_iff_add_eq_zero, or_assoc]

public theorem smallOrder_lt (y0 y1 : Fe) (r : Point) : (smallOrder y0 y1 r).toNat < 2 ^ 8 :=
  or_lt (or_lt (or_lt (isZero_lt _) (isZero_lt _)) (isZero_lt _)) (isZero_lt _)

end MLIR.Firedancer.Lane

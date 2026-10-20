module

public import Firedancer.Math.R52x5.Mul
public import Firedancer.Crc.fd_r52x5_ge_add
public import Firedancer.Crc.fd_r52x5_sqr
public import Firedancer.Crc.fd_r52x5_neg
public import Firedancer.Crc.fd_r52x5_ge_dbl
public import Firedancer.Crc.fd_r52x5_ge_add_table
public import Firedancer.Crc.fd_r52x5_ge_to_table
public import Ed25519.Curve
import Ed25519.Ext
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.Ring

/-! crc's `fd_r52x5_*` specs in `ZMod p`: on elements with lanes 5-7 zero each field kernel is the
r52x5 backend's spec of the same function, so its `spec_val` theorem carries over, and
`fd_r52x5_ge_add` is the extended-coordinates addition of the points its inputs represent. -/

namespace MLIR.Firedancer.Crc

open _root_.Ed25519 (p d OnCurve IsExt isExt_add)
open Firedancer.Avx512
open Firedancer.Avx512.R43x6 (wwl_add_get wwl_sub_get wwl_and_get wwl_shl_get wwl_shru_vector_get wwl_madd52lo_get
  wwl_madd52hi_get wwl_permute_get wwl_slide_get wwl_bcast_get wwl_get0 wwl_get1 wwl_get2 wwl_get3
  wwl_get4 wwl_get5 wwl_get6 wwl_get7 wwl_zero_get getD_get madd52lo_zero madd52hi_zero
  madd52lo_zero' madd52hi_zero' madd52lo_zero_left madd52hi_zero_left)
open R52x5 (val Hi0 Below limbs mask51 bias16p)

/-! ## The fold -/

theorem wwl_shru_get (x : Wwl) (n i : ℕ) (h : i < 8) : (wwl_shru x n)[i] = x[i] >>> n := by
  simp [wwl_shru]

theorem madd52lo_comm (x y : BitVec 64) : madd52lo x y = madd52lo y x := by
  unfold madd52lo; rw [BitVec.mul_comm]

theorem madd52hi_comm (x y : BitVec 64) : madd52hi x y = madd52hi y x := by
  unfold madd52hi; rw [BitVec.mul_comm]

theorem wwl_if_get (c : BitVec 32) (x y : Wwl) (i : ℕ) (h : i < 8) :
    (wwl_if c x y)[i] = if c.getLsbD i then x[i] else y[i] := by
  simp [wwl_if]

theorem zero_shl (n : ℕ) : 0#64 <<< n = 0#64 := BitVec.zero_shiftLeft n

/-- One lane of `crcFold_eq_fold`, down to `madd52lo` of the lane's carry. -/
local macro "fold_lane" : tactic =>
  `(tactic|
    (simp only [crcFold, R52x5.fold, wwl_madd52lo_get, wwl_and_get, wwl_permute_get, wwl_shru_get,
      wwl_shru_vector_get, wwl_bcast_get, R52x5.foldMask, R52x5.foldShift, R52x5.foldPerm,
      R52x5.foldScale, wwl_get0, wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6,
      wwl_get7, getD_get, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT]))

/-- On lanes 5-7 zero, `crcFold` is `fd_f25519_fold_unsigned`. -/
public theorem crcFold_eq_fold {x : Wwl} (hx : Hi0 x) : crcFold x = R52x5.fold x := by
  obtain ⟨h5, h6, h7⟩ := hx
  apply vec_ext_fin
  intro i
  fin_cases i
  · show (crcFold x)[0] = (R52x5.fold x)[0]; fold_lane; rw [madd52lo_comm]
  · show (crcFold x)[1] = (R52x5.fold x)[1]; fold_lane; rw [madd52lo_comm]
  · show (crcFold x)[2] = (R52x5.fold x)[2]; fold_lane; rw [madd52lo_comm]
  · show (crcFold x)[3] = (R52x5.fold x)[3]; fold_lane; rw [madd52lo_comm]
  · show (crcFold x)[4] = (R52x5.fold x)[4]; fold_lane; rw [madd52lo_comm]
  · show (crcFold x)[5] = (R52x5.fold x)[5]; fold_lane; rw [h5]; simp [madd52lo_zero_left]
  · show (crcFold x)[6] = (R52x5.fold x)[6]; fold_lane; rw [h6]; simp [madd52lo_zero_left]
  · show (crcFold x)[7] = (R52x5.fold x)[7]; fold_lane; rw [h7]; simp [madd52lo_zero_left]

/-! ## `fd_r52x5_add`, `fd_r52x5_sub` -/

public theorem wwl_add_hi0 {x y : Wwl} (hx : Hi0 x) (hy : Hi0 y) : Hi0 (wwl_add x y) := by
  obtain ⟨x5, x6, x7⟩ := hx
  obtain ⟨y5, y6, y7⟩ := hy
  simp [Hi0, wwl_add, x5, x6, x7, y5, y6, y7]

public theorem wwl_sub_hi0 {x y : Wwl} (hx : Hi0 x) (hy : Hi0 y) : Hi0 (wwl_sub x y) := by
  obtain ⟨x5, x6, x7⟩ := hx
  obtain ⟨y5, y6, y7⟩ := hy
  simp [Hi0, wwl_sub, x5, x6, x7, y5, y6, y7]

public theorem bias16p_hi0 : Hi0 bias16p := ⟨rfl, rfl, rfl⟩

/-- `fd_r52x5_add` is `fd_f25519_add` on lanes 5-7 zero. -/
public theorem fd_r52x5_add.spec_eq {a b : Wwl} (ha : Hi0 a) (hb : Hi0 b) :
    fd_r52x5_add.spec a b = R52x5.fd_f25519_add.spec a b :=
  crcFold_eq_fold (wwl_add_hi0 hb ha)

/-- `fd_r52x5_sub` is `fd_f25519_sub` on lanes 5-7 zero. -/
public theorem fd_r52x5_sub.spec_eq {a b : Wwl} (ha : Hi0 a) (hb : Hi0 b) :
    fd_r52x5_sub.spec a b = R52x5.fd_f25519_sub.spec a b := by
  rw [fd_r52x5_sub.spec, R52x5.fd_f25519_sub.spec,
    crcFold_eq_fold (wwl_add_hi0 (wwl_sub_hi0 ha hb) bias16p_hi0)]
  refine congrArg R52x5.fold (vec_ext_fin fun i => ?_)
  simp only [Fin.getElem_fin, wwl_add_get, wwl_sub_get]
  rw [BitVec.sub_add_comm]

/-- `fd_r52x5_add` of lanes below `2^63`: the sum, `B(52)`. -/
public theorem fd_r52x5_add.spec_val {a b : Wwl} (ha : Below 63 a) (hb : Below 63 b) :
    val (fd_r52x5_add.spec a b) = val a + val b ∧ Below 52 (fd_r52x5_add.spec a b) := by
  rw [fd_r52x5_add.spec_eq ha.1 hb.1]
  exact R52x5.fd_f25519_add.spec_val ha.2 hb.2

/-- `fd_r52x5_sub` of `a` below `2^63` and `b` below `2^54`: the difference, `B(52)`. -/
public theorem fd_r52x5_sub.spec_val {a b : Wwl} (ha : Below 63 a) (hb : Below 54 b) :
    val (fd_r52x5_sub.spec a b) = val a - val b ∧ Below 52 (fd_r52x5_sub.spec a b) := by
  rw [fd_r52x5_sub.spec_eq ha.1 hb.1]
  exact R52x5.fd_f25519_sub.spec_val ha.2 hb.2

/-! ## `fd_r52x5_mul` -/

/-- One lane of `fd_r52x5_mul.z` and of `fd_f25519_mul.z` as lane terms of `a`, `b`. -/
local macro "mul_lane" : tactic =>
  `(tactic|
    ( unfold fd_r52x5_mul.z R52x5.fd_f25519_mul.z
      iterate 2
        try
          simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get, wwl_madd52hi_get,
            wwl_slide_get, wwl_permute_get, wwl_bcast_get, wwl_if_get, wwl_get0, wwl_get1, wwl_get2,
            wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
            Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
            Nat.reduceAdd, Nat.reduceSub, ite_true, ite_false, BitVec.getLsbD_ofNat,
            Nat.testBit, Nat.shiftRight_zero, Nat.one_and_eq_mod_two, Nat.reduceDiv,
            Nat.reduceShiftRight, decide_true, decide_false, Bool.true_eq, Nat.reduceMul,
            BitVec.neg_one_eq_allOnes, BitVec.and_allOnes]))

/-- Products with `b` first, as crc's steps give them, into `a` first, as the r52x5 spec has. -/
local macro "comm_ab" b:ident : tactic =>
  `(tactic|
    (repeat' first
      | rw [madd52lo_comm $b[0]] | rw [madd52lo_comm $b[1]] | rw [madd52lo_comm $b[2]]
      | rw [madd52lo_comm $b[3]] | rw [madd52lo_comm $b[4]]
      | rw [madd52hi_comm $b[0]] | rw [madd52hi_comm $b[1]] | rw [madd52hi_comm $b[2]]
      | rw [madd52hi_comm $b[3]] | rw [madd52hi_comm $b[4]]))

/-- `za + zb + (2 zb + 16 zb)` with `za` and `zb` each summed in another order. -/
theorem fold_sum_congr {L L' S S' : BitVec 64} (hL : L = L') (h : S = S') :
    L + S + (S <<< 1 + S <<< 4) = L' + S' + (S' <<< 1 + S' <<< 4) := by
  rw [h, hL]

/-- Lane `k` of `fd_r52x5_mul.z_eq`: lanes 5-7 of `b` zero drop crc's extra row, then the two
column sums agree up to the order of their rows. -/
local macro "z_lane" b:ident hb5:ident hb6:ident hb7:ident k:term : tactic =>
  `(tactic|
    ( mul_lane
      simp only [$hb5:ident, $hb6:ident, $hb7:ident, madd52lo_zero, madd52hi_zero,
        madd52lo_zero', madd52hi_zero', madd52lo_zero_left, madd52hi_zero_left, BitVec.zero_add,
        BitVec.add_zero, BitVec.zero_shiftLeft, BitVec.and_allOnes, BitVec.neg_one_eq_allOnes,
        BitVec.and_zero, BitVec.zero_and]
      simp only [show BitVec.getLsbD 31#32 $k = decide ($k < 5) from rfl, decide_true, decide_false,
        ite_true, ite_false, BitVec.ofNat_eq_ofNat, BitVec.zero_add, BitVec.add_zero,
        BitVec.and_allOnes, BitVec.neg_one_eq_allOnes, BitVec.and_zero, BitVec.zero_and]
      comm_ab $b
      simp only [Nat.reduceLT, decide_true, decide_false, ite_true, ite_false, BitVec.zero_add,
        BitVec.add_zero, zero_shl, Bool.false_eq_true]
      try first | (apply fold_sum_congr <;> ac_rfl) | ac_rfl))

namespace fd_r52x5_mul

-- every lane takes the three zero-lane hypotheses and the shared `simp` set, each using part
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

theorem z_lane0 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[0] = (R52x5.fd_f25519_mul.z a b)[0] := by
  z_lane b hb5 hb6 hb7 0

theorem z_lane1 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[1] = (R52x5.fd_f25519_mul.z a b)[1] := by
  z_lane b hb5 hb6 hb7 1

theorem z_lane2 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[2] = (R52x5.fd_f25519_mul.z a b)[2] := by
  z_lane b hb5 hb6 hb7 2

theorem z_lane3 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[3] = (R52x5.fd_f25519_mul.z a b)[3] := by
  z_lane b hb5 hb6 hb7 3

theorem z_lane4 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[4] = (R52x5.fd_f25519_mul.z a b)[4] := by
  z_lane b hb5 hb6 hb7 4

theorem z_lane5 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[5] = (R52x5.fd_f25519_mul.z a b)[5] := by
  z_lane b hb5 hb6 hb7 5

theorem z_lane6 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[6] = (R52x5.fd_f25519_mul.z a b)[6] := by
  z_lane b hb5 hb6 hb7 6

theorem z_lane7 {a b : Wwl} (hb5 : b[5] = 0#64) (hb6 : b[6] = 0#64) (hb7 : b[7] = 0#64) :
    (fd_r52x5_mul.z a b)[7] = (R52x5.fd_f25519_mul.z a b)[7] := by
  z_lane b hb5 hb6 hb7 7

end fd_r52x5_mul

/-- crc's `z` is `fd_f25519_mul`'s on `b` with lanes 5-7 zero: the same rows summed in another
order, and crc's extra row (`t34`, `b[5] a[0]`) zero. -/
theorem fd_r52x5_mul.z_eq {a b : Wwl} (hb : Hi0 b) :
    fd_r52x5_mul.z a b = R52x5.fd_f25519_mul.z a b := by
  obtain ⟨hb5, hb6, hb7⟩ := hb
  apply vec_ext_fin
  intro i
  fin_cases i
  · exact z_lane0 hb5 hb6 hb7
  · exact z_lane1 hb5 hb6 hb7
  · exact z_lane2 hb5 hb6 hb7
  · exact z_lane3 hb5 hb6 hb7
  · exact z_lane4 hb5 hb6 hb7
  · exact z_lane5 hb5 hb6 hb7
  · exact z_lane6 hb5 hb6 hb7
  · exact z_lane7 hb5 hb6 hb7

-- the lane `simp` set is shared by the three lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- `fd_f25519_mul.z` on `b` with lanes 5-7 zero has lanes 5-7 zero: the `0x1f` mask and the
slide of `zh` by 5. -/
theorem z_hi0 {a b : Wwl} (hb : Hi0 b) : Hi0 (R52x5.fd_f25519_mul.z a b) := by
  obtain ⟨hb5, hb6, hb7⟩ := hb
  unfold R52x5.fd_f25519_mul.z
  refine ⟨?_, ?_, ?_⟩ <;>
    simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_slide_get, wwl_madd52hi_get,
      wwl_madd52lo_get, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, Nat.reduceAdd, Nat.reduceSub,
      Nat.reduceLT, ite_true, ite_false, BitVec.and_zero, BitVec.zero_add, BitVec.add_zero,
      zero_shl, getD_get, hb5, hb6, hb7, madd52hi_zero, madd52lo_zero, madd52hi_zero',
      madd52lo_zero'] <;> simp

/-- `fd_r52x5_mul` is `fd_f25519_mul` on `b` with lanes 5-7 zero. -/
public theorem fd_r52x5_mul.spec_eq {a b : Wwl} (hb : Hi0 b) :
    fd_r52x5_mul.spec a b = R52x5.fd_f25519_mul.spec a b := by
  rw [fd_r52x5_mul.spec, R52x5.fd_f25519_mul.spec, fd_r52x5_mul.z_eq hb,
    crcFold_eq_fold (z_hi0 hb)]

/-- `fd_r52x5_mul` of `a`, `b` both `B(52)`: the product, `B(52)`. -/
public theorem fd_r52x5_mul.spec_val {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    val (fd_r52x5_mul.spec a b) = val a * val b ∧ Below 52 (fd_r52x5_mul.spec a b) := by
  rw [fd_r52x5_mul.spec_eq hb.1]
  exact R52x5.fd_f25519_mul.spec_val ha hb

/-! ## `fd_r52x5_sqr`, `fd_r52x5_neg` -/

/-- crc's `fd_r52x5_sqr` is its `fd_r52x5_mul` with both operands `a`. -/
public theorem fd_r52x5_sqr.spec_eq (a : Wwl) : fd_r52x5_sqr.spec a = fd_r52x5_mul.spec a a := by
  unfold fd_r52x5_sqr.spec fd_r52x5_mul.spec fd_r52x5_sqr.z fd_r52x5_mul.z
  rfl

/-- `fd_r52x5_sqr` of `a` `B(52)`: the square, `B(52)`. -/
public theorem fd_r52x5_sqr.spec_val {a : Wwl} (ha : Below 52 a) :
    val (fd_r52x5_sqr.spec a) = val a ^ 2 ∧ Below 52 (fd_r52x5_sqr.spec a) := by
  rw [fd_r52x5_sqr.spec_eq, sq]
  exact fd_r52x5_mul.spec_val ha ha

/-- `fd_r52x5_neg` is `fd_f25519_neg` on lanes 5-7 zero. -/
public theorem fd_r52x5_neg.spec_eq {a : Wwl} (ha : Hi0 a) :
    fd_r52x5_neg.spec a = R52x5.fd_f25519_neg.spec a :=
  crcFold_eq_fold (wwl_sub_hi0 bias16p_hi0 ha)

/-- `fd_r52x5_neg` of `a` below `2^54`: the negation, `B(52)`. -/
public theorem fd_r52x5_neg.spec_val {a : Wwl} (ha : Below 54 a) :
    val (fd_r52x5_neg.spec a) = -val a ∧ Below 52 (fd_r52x5_neg.spec a) := by
  rw [fd_r52x5_neg.spec_eq ha.1]
  exact R52x5.fd_f25519_neg.spec_val ha.2

/-! ## `fd_r52x5_ge_add` -/

/-- `k = 2d`, `B(52)`. -/
public theorem fd_r52x5_ge_add.k_val : val fd_r52x5_ge_add.k = 2 * d ∧ Below 52 fd_r52x5_ge_add.k := by
  refine ⟨?_, ⟨rfl, rfl, rfl⟩, fun i => by fin_cases i <;> decide⟩
  have e : limbs fd_r52x5_ge_add.k = fun i =>
      #v[1859910466990425#64, 932731440258426#64, 1072319116312658#64, 1815898335770999#64,
        633789495995903#64][i] := by
    funext i; fin_cases i <;> rfl
  rw [val, e, Ed25519.Limbs.val_eq]
  unfold Ed25519.d
  simp
  reduce_mod_char

/-- `fd_r52x5_ge_add` of `(X1, Y1, Z1, T1)` and `(X2, Y2, Z2, T2)`, extended coordinates of
`(x₁, y₁)` and `(x₂, y₂)` on the curve, `B(52)`: extended coordinates of their sum, `B(52)`. -/
public theorem fd_r52x5_ge_add.spec_ext {X1 Y1 Z1 T1 X2 Y2 Z2 T2 : Wwl} {x₁ y₁ x₂ y₂ : ZMod p}
    (h1 : IsExt x₁ y₁ (val X1) (val Y1) (val T1) (val Z1))
    (h2 : IsExt x₂ y₂ (val X2) (val Y2) (val T2) (val Z2))
    (c1 : OnCurve x₁ y₁) (c2 : OnCurve x₂ y₂)
    (bX1 : Below 52 X1) (bY1 : Below 52 Y1) (bZ1 : Below 52 Z1) (bT1 : Below 52 T1)
    (bX2 : Below 52 X2) (bY2 : Below 52 Y2) (bZ2 : Below 52 Z2) (bT2 : Below 52 T2) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let r := fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2
    IsExt Q.1 Q.2 (val r.1) (val r.2.1) (val r.2.2.2) (val r.2.2.1) ∧
      Below 52 r.1 ∧ Below 52 r.2.1 ∧ Below 52 r.2.2.1 ∧ Below 52 r.2.2.2 := by
  intro Q r
  have b63 {x : Wwl} (h : Below 52 x) : Below 63 x := h.mono (by decide)
  have b54 {x : Wwl} (h : Below 52 x) : Below 54 x := h.mono (by decide)
  obtain ⟨v1, b1⟩ := fd_r52x5_add.spec_val (b63 bX1) (b63 bY1)
  obtain ⟨v2, b2⟩ := fd_r52x5_add.spec_val (b63 bX2) (b63 bY2)
  obtain ⟨v3, b3⟩ := fd_r52x5_mul.spec_val b1 b2
  obtain ⟨v4, b4⟩ := fd_r52x5_sub.spec_val (b63 bY1) (b54 bX1)
  obtain ⟨v5, b5⟩ := fd_r52x5_sub.spec_val (b63 bY2) (b54 bX2)
  obtain ⟨v6, b6⟩ := fd_r52x5_mul.spec_val b4 b5
  obtain ⟨v7, b7⟩ := fd_r52x5_sub.spec_val (b63 b3) (b54 b6)
  obtain ⟨v8, b8⟩ := fd_r52x5_add.spec_val (b63 bZ1) (b63 bZ1)
  obtain ⟨v9, b9⟩ := fd_r52x5_mul.spec_val bZ2 b8
  obtain ⟨vk, bk⟩ := fd_r52x5_ge_add.k_val
  obtain ⟨v10, b10⟩ := fd_r52x5_mul.spec_val bT1 bk
  obtain ⟨v11, b11⟩ := fd_r52x5_mul.spec_val bT2 b10
  obtain ⟨v12, b12⟩ := fd_r52x5_sub.spec_val (b63 b9) (b54 b11)
  obtain ⟨v13, b13⟩ := fd_r52x5_mul.spec_val b7 b12
  obtain ⟨v14, b14⟩ := fd_r52x5_add.spec_val (b63 b11) (b63 b9)
  obtain ⟨v15, b15⟩ := fd_r52x5_add.spec_val (b63 b6) (b63 b3)
  obtain ⟨v16, b16⟩ := fd_r52x5_mul.spec_val b14 b15
  obtain ⟨v17, b17⟩ := fd_r52x5_mul.spec_val b12 b14
  obtain ⟨v18, b18⟩ := fd_r52x5_mul.spec_val b7 b15
  refine ⟨?_, b13, b16, b17, b18⟩
  show IsExt Q.1 Q.2 (val (fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2).1)
    (val (fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2).2.1)
    (val (fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2).2.2.2)
    (val (fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2).2.2.1)
  simp only [fd_r52x5_ge_add.spec]
  rw [v13, v16, v17, v18, v7, v12, v14, v15, v3, v6, v9, v11, v1, v2, v4, v5, v8, v10, vk]
  have h := isExt_add (A := (val Y1 - val X1) * (val Y2 - val X2))
    (B := (val X1 + val Y1) * (val X2 + val Y2)) (C := val T2 * (val T1 * (2 * d)))
    (D := val Z2 * (val Z1 + val Z1)) h1 h2 c1 c2 rfl (by ring) (by ring) (by ring)
  rw [mul_comm (val Z2 * (val Z1 + val Z1) - val T2 * (val T1 * (2 * d)))]
  exact h

/-! ## `fd_r52x5_ge_dbl` -/

/-- `fd_r52x5_ge_dbl` of `(X1, Y1, Z1)`, projective coordinates of `(x, y)` on the curve,
`B(52)`: extended coordinates of its double, `B(52)`. -/
public theorem fd_r52x5_ge_dbl.spec_ext {X1 Y1 Z1 : Wwl} {x y : ZMod p} (hz : val Z1 ≠ 0)
    (hx : val X1 = x * val Z1) (hy : val Y1 = y * val Z1) (hc : OnCurve x y)
    (bX1 : Below 52 X1) (bY1 : Below 52 Y1) (bZ1 : Below 52 Z1) :
    let Q := Ed25519.dbl x y
    let r := fd_r52x5_ge_dbl.spec X1 Y1 Z1
    IsExt Q.1 Q.2 (val r.1) (val r.2.1) (val r.2.2.2) (val r.2.2.1) ∧
      Below 52 r.1 ∧ Below 52 r.2.1 ∧ Below 52 r.2.2.1 ∧ Below 52 r.2.2.2 := by
  intro Q r
  have b63 {x : Wwl} (h : Below 52 x) : Below 63 x := h.mono (by decide)
  have b54 {x : Wwl} (h : Below 52 x) : Below 54 x := h.mono (by decide)
  obtain ⟨v1, b1⟩ := fd_r52x5_sqr.spec_val bX1
  obtain ⟨v2, b2⟩ := fd_r52x5_sqr.spec_val bY1
  obtain ⟨v3, b3⟩ := fd_r52x5_add.spec_val (b63 b1) (b63 b2)
  obtain ⟨v4, b4⟩ := fd_r52x5_add.spec_val (b63 bX1) (b63 bY1)
  obtain ⟨v5, b5⟩ := fd_r52x5_sqr.spec_val b4
  obtain ⟨v6, b6⟩ := fd_r52x5_sub.spec_val (b63 b3) (b54 b5)
  obtain ⟨v7, b7⟩ := fd_r52x5_sqr.spec_val bZ1
  obtain ⟨v8, b8⟩ := fd_r52x5_add.spec_val (b63 b7) (b63 b7)
  obtain ⟨v9, b9⟩ := fd_r52x5_sub.spec_val (b63 b1) (b54 b2)
  obtain ⟨v10, b10⟩ := fd_r52x5_add.spec_val (b63 b8) (b63 b9)
  obtain ⟨v11, b11⟩ := fd_r52x5_mul.spec_val b6 b10
  obtain ⟨v12, b12⟩ := fd_r52x5_mul.spec_val b3 b9
  obtain ⟨v13, b13⟩ := fd_r52x5_mul.spec_val b9 b10
  obtain ⟨v14, b14⟩ := fd_r52x5_mul.spec_val b3 b6
  refine ⟨?_, b11, b12, b13, b14⟩
  show IsExt Q.1 Q.2 (val (fd_r52x5_ge_dbl.spec X1 Y1 Z1).1) (val (fd_r52x5_ge_dbl.spec X1 Y1 Z1).2.1)
    (val (fd_r52x5_ge_dbl.spec X1 Y1 Z1).2.2.2) (val (fd_r52x5_ge_dbl.spec X1 Y1 Z1).2.2.1)
  simp only [fd_r52x5_ge_dbl.spec, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14]
  have h := Ed25519.isExt_dbl hz hx hy hc
  simp only at h
  convert h using 1 <;> ring

/-! ## `fd_r52x5_ge_add_table` -/

/-- `fd_r52x5_ge_add_table` of `(X1, Y1, Z1, T1)`, extended coordinates of `(x₁, y₁)`, and the
table entry `(Y₂ + X₂, Y₂ - X₂, Z₂, 2d T₂)` of extended coordinates of `(x₂, y₂)`, both on
the curve and `B(52)`: extended coordinates of their sum, `B(52)`. -/
public theorem fd_r52x5_ge_add_table.spec_ext {X1 Y1 Z1 T1 YpX YmX QZ QT2d : Wwl}
    {x₁ y₁ x₂ y₂ X2 Y2 T2 Z2 : ZMod p} (h1 : IsExt x₁ y₁ (val X1) (val Y1) (val T1) (val Z1))
    (h2 : IsExt x₂ y₂ X2 Y2 T2 Z2) (eYpX : val YpX = Y2 + X2) (eYmX : val YmX = Y2 - X2)
    (eQZ : val QZ = Z2) (eQT2d : val QT2d = 2 * d * T2) (c1 : OnCurve x₁ y₁)
    (c2 : OnCurve x₂ y₂)
    (bX1 : Below 52 X1) (bY1 : Below 52 Y1) (bZ1 : Below 52 Z1) (bT1 : Below 52 T1)
    (bYpX : Below 52 YpX) (bYmX : Below 52 YmX) (bQZ : Below 52 QZ) (bQT2d : Below 52 QT2d) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let r := fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d
    IsExt Q.1 Q.2 (val r.1) (val r.2.1) (val r.2.2.2) (val r.2.2.1) ∧
      Below 52 r.1 ∧ Below 52 r.2.1 ∧ Below 52 r.2.2.1 ∧ Below 52 r.2.2.2 := by
  intro Q r
  have b63 {x : Wwl} (h : Below 52 x) : Below 63 x := h.mono (by decide)
  have b54 {x : Wwl} (h : Below 52 x) : Below 54 x := h.mono (by decide)
  obtain ⟨v1, b1⟩ := fd_r52x5_add.spec_val (b63 bX1) (b63 bY1)
  obtain ⟨v2, b2⟩ := fd_r52x5_mul.spec_val bYpX b1
  obtain ⟨v3, b3⟩ := fd_r52x5_sub.spec_val (b63 bY1) (b54 bX1)
  obtain ⟨v4, b4⟩ := fd_r52x5_mul.spec_val bYmX b3
  obtain ⟨v5, b5⟩ := fd_r52x5_sub.spec_val (b63 b2) (b54 b4)
  obtain ⟨v6, b6⟩ := fd_r52x5_add.spec_val (b63 bZ1) (b63 bZ1)
  obtain ⟨v7, b7⟩ := fd_r52x5_mul.spec_val bQZ b6
  obtain ⟨v8, b8⟩ := fd_r52x5_mul.spec_val bT1 bQT2d
  obtain ⟨v9, b9⟩ := fd_r52x5_sub.spec_val (b63 b7) (b54 b8)
  obtain ⟨v10, b10⟩ := fd_r52x5_mul.spec_val b5 b9
  obtain ⟨v11, b11⟩ := fd_r52x5_add.spec_val (b63 b8) (b63 b7)
  obtain ⟨v12, b12⟩ := fd_r52x5_add.spec_val (b63 b4) (b63 b2)
  obtain ⟨v13, b13⟩ := fd_r52x5_mul.spec_val b11 b12
  obtain ⟨v14, b14⟩ := fd_r52x5_mul.spec_val b9 b11
  obtain ⟨v15, b15⟩ := fd_r52x5_mul.spec_val b5 b12
  refine ⟨?_, b10, b13, b14, b15⟩
  show IsExt Q.1 Q.2 (val (fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d).1) (val (fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d).2.1)
    (val (fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d).2.2.2) (val (fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d).2.2.1)
  simp only [fd_r52x5_ge_add_table.spec, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, eYpX, eYmX, eQZ, eQT2d]
  have h := isExt_add (A := (val Y1 - val X1) * (Y2 - X2)) (B := (val Y1 + val X1) * (Y2 + X2))
    (C := val T1 * T2 * (2 * d)) (D := (val Z1 + val Z1) * Z2) h1 h2 c1 c2 rfl rfl rfl rfl
  convert h using 1 <;> ring

/-! ## `fd_r52x5_ge_to_table` -/

/-- `fd_r52x5_ge_to_table.k = 2d`, `B(52)`. -/
public theorem fd_r52x5_ge_to_table.k_val : val fd_r52x5_ge_to_table.k = 2 * d ∧ Below 52 fd_r52x5_ge_to_table.k := by
  refine ⟨?_, ⟨rfl, rfl, rfl⟩, fun i => by fin_cases i <;> decide⟩
  have e : limbs fd_r52x5_ge_to_table.k = fun i =>
      #v[1859910466990425#64, 932731440258426#64, 1072319116312658#64, 1815898335770999#64,
        633789495995903#64][i] := by
    funext i; fin_cases i <;> rfl
  rw [val, e, Ed25519.Limbs.val_eq]
  unfold Ed25519.d
  simp
  reduce_mod_char

/-- `fd_r52x5_ge_to_table` of `B(52)` coordinates: `(Y + X, Y - X, Z, 2d T)`, `B(52)`. -/
public theorem fd_r52x5_ge_to_table.spec_val {X Y Z T : Wwl} (bX : Below 52 X) (bY : Below 52 Y) (bZ : Below 52 Z) (bT : Below 52 T) :
    let r := fd_r52x5_ge_to_table.spec X Y Z T
    val r.1 = val Y + val X ∧ val r.2.1 = val Y - val X ∧ r.2.2.1 = Z ∧
      val r.2.2.2 = 2 * d * val T ∧ Below 52 r.1 ∧ Below 52 r.2.1 ∧ Below 52 r.2.2.1 ∧ Below 52 r.2.2.2 := by
  intro r
  have b63 {x : Wwl} (h : Below 52 x) : Below 63 x := h.mono (by decide)
  have b54 {x : Wwl} (h : Below 52 x) : Below 54 x := h.mono (by decide)
  obtain ⟨v1, b1⟩ := fd_r52x5_add.spec_val (b63 bX) (b63 bY)
  obtain ⟨v2, b2⟩ := fd_r52x5_sub.spec_val (b63 bY) (b54 bX)
  obtain ⟨vk, bk⟩ := fd_r52x5_ge_to_table.k_val
  obtain ⟨v3, b3⟩ := fd_r52x5_mul.spec_val bT bk
  refine ⟨?_, ?_, rfl, ?_, b1, b2, bZ, b3⟩ <;>
    simp only [r, fd_r52x5_ge_to_table.spec, v1, v2, v3, vk] <;> ring

/-- `fd_r52x5_ge_add_table` with the entry `fd_r52x5_ge_to_table` makes of `(X2, Y2, Z2, T2)`:
the sum, as `fd_r52x5_ge_add` gives it. -/
public theorem fd_r52x5_ge_add_table.to_table_ext {X1 Y1 Z1 T1 X2 Y2 Z2 T2 : Wwl}
    {x₁ y₁ x₂ y₂ : ZMod p} (h1 : IsExt x₁ y₁ (val X1) (val Y1) (val T1) (val Z1))
    (h2 : IsExt x₂ y₂ (val X2) (val Y2) (val T2) (val Z2)) (c1 : OnCurve x₁ y₁)
    (c2 : OnCurve x₂ y₂) (bX1 : Below 52 X1) (bY1 : Below 52 Y1) (bZ1 : Below 52 Z1)
    (bT1 : Below 52 T1) (bX2 : Below 52 X2) (bY2 : Below 52 Y2) (bZ2 : Below 52 Z2)
    (bT2 : Below 52 T2) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let e := fd_r52x5_ge_to_table.spec X2 Y2 Z2 T2
    let r := fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 e.1 e.2.1 e.2.2.1 e.2.2.2
    IsExt Q.1 Q.2 (val r.1) (val r.2.1) (val r.2.2.2) (val r.2.2.1) ∧
      Below 52 r.1 ∧ Below 52 r.2.1 ∧ Below 52 r.2.2.1 ∧ Below 52 r.2.2.2 := by
  intro Q e r
  obtain ⟨e1, e2, e3, e4, b1, b2, b3, b4⟩ := fd_r52x5_ge_to_table.spec_val bX2 bY2 bZ2 bT2
  exact fd_r52x5_ge_add_table.spec_ext h1 h2 e1 e2 (congrArg val e3) e4 c1 c2 bX1 bY1 bZ1 bT1 b1
    b2 b3 b4

end MLIR.Firedancer.Crc

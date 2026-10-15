module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_affine_is_small_order
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

-- the tests' lemmas, also used where `fd_ed25519_verify` inlines this function
@[expose] public section

/-- Bit `i` of eight packed one-bit lanes: lane `i`. -/
theorem getLsbD_packLanes_bv1 (v : Vector (BitVec 1) 8) (i : Nat) (hi : i < 8) :
    (BitVec.packLanes v).getLsbD i = v[i].getLsbD 0 := by
  have h := congrArg (·.getLsbD 0) (BitVec.extractLsb'_packLanes v i (by omega))
  simpa using h

/-- A one-bit lane is its bit. -/
theorem bv1_eq_iff (x : BitVec 1) (b : Bool) : x = BitVec.ofBool b ↔ x.getLsbD 0 = b := by
  constructor
  · rintro rfl; cases b <;> rfl
  · intro h; apply BitVec.eq_of_getLsbD_eq; intro i hi
    obtain rfl : i = 0 := by omega
    cases b <;> simpa using h

/-- Eight packed one-bit lanes are all clear exactly when every lane is. -/
theorem packLanes_eq_iff_bv1 (v : Vector (BitVec 1) 8) (b : Bool) :
    BitVec.packLanes v = (if b then BitVec.allOnes 8 else 0#8) ↔
      ∀ i (hi : i < 8), v[i] = BitVec.ofBool b := by
  constructor
  · intro h i hi
    rw [bv1_eq_iff, ← getLsbD_packLanes_bv1 v i hi, h]
    cases b <;> simp
    revert hi; revert i; decide
  · intro h; apply BitVec.eq_of_getLsbD_eq; intro i hi
    rw [getLsbD_packLanes_bv1 v i hi, (bv1_eq_iff _ _).mp (h i hi)]
    cases b <;> simp
    revert hi; revert i; decide

/-- Eight packed lane tests are all clear exactly when no lane fails. -/
theorem packLanes_ofFn_eq_zero (f : Fin 8 → Bool) :
    BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i)) = 0#8 ↔ ∀ i, f i = false := by
  have := packLanes_eq_iff_bv1 (Vector.ofFn fun i => BitVec.ofBool (f i)) false
  simp only [Bool.false_eq_true, ↓reduceIte] at this
  rw [this]
  constructor
  · intro h i
    have := h i.1 i.2
    simp only [Fin.eta, Vector.getElem_ofFn] at this
    revert this; cases f i <;> decide
  · intro h i hi
    simp [h]

/-- Eight packed lane tests, widened and masked to their byte, are all set exactly when every lane
passes. -/
theorem packLanes_ofFn_and_255 (f : Fin 8 → Bool) :
    ((BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i))).setWidth 32 &&& 255 = 255) ↔
      ∀ i, f i = true := by
  have := packLanes_eq_iff_bv1 (Vector.ofFn fun i => BitVec.ofBool (f i)) true
  simp only [↓reduceIte] at this
  have hb : ∀ p : BitVec 8, (p.setWidth 32 &&& 255 = 255) ↔ p = BitVec.allOnes 8 := by
    intro p; bv_decide
  rw [hb, this]
  constructor
  · intro h i
    have := h i.1 i.2
    simp only [Fin.eta, Vector.getElem_ofFn] at this
    revert this; cases f i <;> decide
  · intro h i hi
    simp [h]

/-- The compiled tests: `1` when every lane is `0`, else when every lane is `p`'s. -/
theorem isZero_spec_eq (x : Wwl) :
    BitVec.setWidth 32
        (if
            BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
              BitVec.ofBool (x[i] != 0#64)) == 0#8) = 1#1 then 1#1
        else
          BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
            BitVec.ofBool (x[i] != fd_r43x6_p[i])) == 0#8)) =
      fd_f25519_is_zero.spec x := by
  have h0 := packLanes_ofFn_eq_zero fun i => x[i] != 0#64
  have hp := packLanes_ofFn_eq_zero fun i => x[i] != fd_r43x6_p[i]
  have e0 := packLanes_ofFn_and_255 fun i => x[i] == fd_r43x6_zero[i]
  have ep := packLanes_ofFn_and_255 fun i => x[i] == fd_r43x6_p[i]
  simp only [bne_eq_false_iff_eq, beq_iff_eq, fd_r43x6_zero, wwl_zero] at h0 hp e0 ep
  have a0 : (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[i] != 0#64)) == 0#8) =
      decide (∀ i : Fin 8, x[i] = 0#64) := by
    rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, h0]
  have ap : (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
      BitVec.ofBool (x[i] != fd_r43x6_p[i])) == 0#8) =
        decide (∀ i : Fin 8, x[i] = fd_r43x6_p[i]) := by
    rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, hp]
  rw [a0, ap, fd_f25519_is_zero.spec, wwl_eq, wwl_eq]
  simp only [fd_r43x6_zero, wwl_zero] at ⊢
  simp only [e0, ep]
  have hrep : (∀ i : Fin 8, x[i] = (Vector.replicate 8 0)[i]) ↔ ∀ i : Fin 8, x[i] = 0#64 := by
    simp
  simp only [hrep]
  by_cases hP : ∀ i : Fin 8, x[i] = 0#64 <;> by_cases hQ : ∀ i : Fin 8, x[i] = fd_r43x6_p[i] <;>
    simp only [hP, hQ] <;> decide

/-- `fd_f25519_is_zero` as compiled, its two tests before the widening. -/
def isZeroBit (x : Wwl) : BitVec 1 :=
  if
      BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
        BitVec.ofBool (x[i] != 0#64)) == 0#8) = 1#1 then 1#1
  else
    BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
      BitVec.ofBool (x[i] != fd_r43x6_p[i])) == 0#8)

/-- `isZeroBit`, widened, is `fd_f25519_is_zero`. -/
theorem isZeroBit_spec (x : Wwl) : (isZeroBit x).setWidth 32 = fd_f25519_is_zero.spec x :=
  isZero_spec_eq x

/-- `fd_f25519_sub( y, b )` as compiled for a constant `b`: `y + k` for `k = p - _b - b`, the fold
summed in the code's order. -/
def subFolded (y k : Wwl) : Wwl :=
  let x := wwl_add y k
  let c := wwl_shr_vector x foldShifts
  let c : Wwl := #v[c[5], c[0], c[1], c[2], c[3], c[4], 0#64, 0#64]
  wwl_add
    (wwl_add
      (wwl_add (wwl_and x foldMask)
        #v[159383552#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 0#64, 0#64])
      c)
    (wwl_and (wwl_mul c (Vector.replicate 8 18#64))
      #v[18446744073709551615#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64])

set_option hygiene false in
/-- `fd_f25519_sub`'s lanes against `subFolded`'s, by `bv_decide` each. -/
local macro "sub_lanes" : tactic =>
  `(tactic|
    ( apply vec_ext_fin
      intro i
      fin_cases i <;>
        simp [subFolded, fd_f25519_sub.spec, wwl_add, wwl_and, wwl_mul, wwl_shr_vector, foldMask,
          foldShifts, fd_ed25519_order8_point_y0.vec, fd_ed25519_order8_point_y1.vec, wwl,
          reduceGetElemLit] <;>
        bv_decide))

/-- `fd_f25519_sub( y, fd_ed25519_order8_point_y0 )`. -/
theorem sub_y0 (y : Wwl) :
    fd_f25519_sub.spec y fd_ed25519_order8_point_y0.vec =
      subFolded y
        #v[5761277761479#64, 1544430418697#64, 264613410264#64, 5044390432789#64, 8643434802371#64,
          1048094254319#64, 0#64, 0#64] := by
  sub_lanes

/-- `fd_f25519_sub( y, fd_ed25519_order8_point_y1 )`. -/
theorem sub_y1 (y : Wwl) :
    fd_f25519_sub.spec y fd_ed25519_order8_point_y1.vec =
      subFolded y
        #v[3034496493606#64, 7251660506358#64, 8531477514791#64, 3751700492266#64, 152656122684#64,
          51415276304#64, 0#64, 0#64] := by
  sub_lanes

/-- The widened `|` of the four tests, in the code's order. -/
theorem or4_setWidth (a b c d : BitVec 1) :
    BitVec.setWidth 32 (d ||| (a ||| b ||| c)) =
      BitVec.setWidth 32 b ||| BitVec.setWidth 32 a ||| BitVec.setWidth 32 c |||
        BitVec.setWidth 32 d := by
  bv_decide

/-- The fold's low bits plus `_b`: no overflow either way. -/
theorem foldMask_add_bias_ok (d : Wwl) :
    ∀ i : Fin 8,
      (wwl_and d foldMask)[i].saddOverflow
            #v[159383552#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 0#64,
              0#64][i] =
          false ∧
        (wwl_and d foldMask)[i].uaddOverflow
            #v[159383552#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 0#64,
              0#64][i] =
          false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | simp only [wwl_and, foldMask, Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero]
      constructor <;> bv_decide

end

/-- `fd_ed25519_affine_is_small_order` returns `spec` of the point at `a` and leaves the state as it
is. -/
public theorem fd_ed25519_affine_is_small_order.call_eq (a : Pointer) (s : GlobalState)
    (hwf : s.WF) (ha : s.mem.QuadFit a) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order.args (.value a)) s =
      .value
        (.cons (.value (fd_ed25519_affine_is_small_order.spec (s.mem.readQuad a))) .nil, s) := by
  func_init
  block_init
  iterate 23 step_pure
  iterate 2 step_pattern using runBodyFrom_insertRun
  -- the point's vectors, `X` and `Y` unpacked from them
  step_load with p03
  step_pure
  step_load with p14
  step_pure
  step_load with p25
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with x
  step_pure with y
  -- `fd_f25519_is_zero( x )`, `fd_f25519_is_zero( y )`
  step_pure [zipWith_eq_ofFn] with zx
  step_pure [zipWith_eq_ofFn] with zx8
  step_pure [zipWith_eq_ofFn] with zx0
  step_pure [zipWith_eq_ofFn] with px
  step_pure [zipWith_eq_ofFn] with px8
  step_pure [zipWith_eq_ofFn] with px0
  step_pure [zipWith_eq_ofFn] with izx
  step_pure [zipWith_eq_ofFn] with zy
  step_pure [zipWith_eq_ofFn] with zy8
  step_pure [zipWith_eq_ofFn] with zy0
  step_pure [zipWith_eq_ofFn] with py
  step_pure [zipWith_eq_ofFn] with py8
  step_pure [zipWith_eq_ofFn] with py0
  step_pure [zipWith_eq_ofFn] with izy
  step_pure [zipWith_eq_ofFn] with o1
  -- `fd_f25519_eq( y, fd_ed25519_order8_point_y0 )`: `fd_f25519_sub`'s lanes, the constant
  -- folded in
  step_pure with s0
  step_pure with s1
  step_pure with s2
  step_pure with s3
  step_pure with s4
  step_pure with s5
  have hoks := foldMask_add_bias_ok s0
  rw [← hs1] at hoks
  step_pure with s6
  step_pure with s7
  step_pure with s8
  step_pure [zipWith_eq_ofFn] with zs
  step_pure [zipWith_eq_ofFn] with zs8
  step_pure [zipWith_eq_ofFn] with zs0
  step_pure [zipWith_eq_ofFn] with ps
  step_pure [zipWith_eq_ofFn] with ps8
  step_pure [zipWith_eq_ofFn] with ps0
  step_pure [zipWith_eq_ofFn] with ies
  step_pure [zipWith_eq_ofFn] with o2
  -- `fd_f25519_eq( y, fd_ed25519_order8_point_y1 )`: `fd_f25519_sub`'s lanes, the constant
  -- folded in
  step_pure with t0
  step_pure with t1
  step_pure with t2
  step_pure with t3
  step_pure with t4
  step_pure with t5
  have hokt := foldMask_add_bias_ok t0
  rw [← ht1] at hokt
  step_pure with t6
  step_pure with t7
  step_pure with t8
  step_pure [zipWith_eq_ofFn] with zt
  step_pure [zipWith_eq_ofFn] with zt8
  step_pure [zipWith_eq_ofFn] with zt0
  step_pure [zipWith_eq_ofFn] with pt
  step_pure [zipWith_eq_ofFn] with pt8
  step_pure [zipWith_eq_ofFn] with pt0
  step_pure [zipWith_eq_ofFn] with iet
  step_pure [zipWith_eq_ofFn] with o3
  step_pure [zipWith_eq_ofFn] with o32
  finish_block
  subst hS
  have ex : x = (S.mem.readQuad a).X := by
    rw [hx, hp03, hp14, hp25]
    rfl
  have ey : y = (S.mem.readQuad a).Y := by
    rw [hy, hp03, hp14, hp25]
    rfl
  have ex0 : izx = isZeroBit x := by
    rw [hizx, hzx0, hzx8, hzx, hpx0, hpx8, hpx]
    rfl
  have ey0 : izy = isZeroBit y := by
    rw [hizy, hzy0, hzy8, hzy, hpy0, hpy8, hpy]
    rfl
  have es0 : ies = isZeroBit s8 := by
    rw [hies, hzs0, hzs8, hzs, hps0, hps8, hps]
    rfl
  have et0 : iet = isZeroBit t8 := by
    rw [hiet, hzt0, hzt8, hzt, hpt0, hpt8, hpt]
    rfl
  have es : s8 = fd_f25519_sub.spec y fd_ed25519_order8_point_y0.vec := by
    rw [sub_y0, hs8, hs7, hs6, hs5, hs4, hs3, hs2, hs1, hs0]
    rfl
  have et : t8 = fd_f25519_sub.spec y fd_ed25519_order8_point_y1.vec := by
    rw [sub_y1, ht8, ht7, ht6, ht5, ht4, ht3, ht2, ht1, ht0]
    rfl
  rw [ho32, ho3, ho2, ho1, ex0, ey0, es0, et0, or4_setWidth, isZeroBit_spec, isZeroBit_spec,
    isZeroBit_spec, isZeroBit_spec, es, et, ex, ey]
  rfl

end Proof

end MLIR.Firedancer.Lane

module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.verify_x8.Lanes
public import Firedancer.Lane.verify_x8.Tactics
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring
import Mathlib.Data.BitVec

/-! `fd_ed25519_lane_verify`'s final comparison as compiled: `is_zero( r·z - x )`, the subtraction
and the normalization fused into the product's carry, as an instruction run (`zeroRun`) with its
step lemma. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-! ### The flagged operations' lanes -/

theorem mask_add_twoP_ok (a : BitVec 64) :
    (a &&& 2251799813685247#64).saddOverflow 4503599627370494#64 = false ∧
      (a &&& 2251799813685247#64).uaddOverflow 4503599627370494#64 = false := by
  bv_decide

theorem mask_twoP_add_shr_ok (a b : BitVec 64) :
    ((a &&& 2251799813685247#64) + 4503599627370494#64).saddOverflow (b >>> 51) = false ∧
      ((a &&& 2251799813685247#64) + 4503599627370494#64).uaddOverflow (b >>> 51) = false := by
  bv_decide

theorem shr_add_twoP_ok (a : BitVec 64) :
    (a >>> 51).saddOverflow 4503599627370494#64 = false ∧
      (a >>> 51).uaddOverflow 4503599627370494#64 = false := by
  bv_decide

theorem shr_twoP_add_mask_ok (a b : BitVec 64) :
    (a >>> 51 + 4503599627370494#64).saddOverflow (b &&& 2251799813685247#64) = false ∧
      (a >>> 51 + 4503599627370494#64).uaddOverflow (b &&& 2251799813685247#64) = false := by
  bv_decide

theorem shr51_mul19_ok (a : BitVec 64) :
    (a >>> 51).smulOverflow 19#64 = false ∧ (a >>> 51).umulOverflow 19#64 = false := by bv_decide

theorem mul19_add_mask_ok (a b : BitVec 64) :
    (a >>> 51 * 19#64).saddOverflow (b &&& 2251799813685247#64) = false ∧
      (a >>> 51 * 19#64).uaddOverflow (b &&& 2251799813685247#64) = false := by
  bv_decide

/-- `m + 2p`'s limb, an `add nsw nuw`. -/
theorem zipWith_add_mask_twoP (x : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_and x (Vector.replicate 8 2251799813685247#64)))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64)) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64))
          (Vector.replicate 8 4503599627370494#64)) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simp only [wwl_and, Vector.getElem_ofFn,
      Vector.getElem_replicate, Fin.getElem_fin]
    exact mask_add_twoP_ok _

/-- `m + 2p + c`, an `add nsw nuw`. -/
theorem zipWith_add_mask_twoP_shr (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64)
          (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64))
            (Vector.replicate 8 4503599627370494#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_shru y 51)) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add
          (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64))
            (Vector.replicate 8 4503599627370494#64))
          (wwl_shru y 51)) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simp only [wwl_and, wwl_add, wwl_shru, Vector.getElem_ofFn,
      Vector.getElem_replicate, Fin.getElem_fin]
    exact mask_twoP_add_shr_ok _ _

/-- `c + 2p`'s limb, an `add nsw nuw`. -/
theorem zipWith_add_shr_twoP (y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru y 51))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64)) =
      Ty.wrap (t := .vec 8 64) (wwl_add (wwl_shru y 51) (Vector.replicate 8 4503599627370494#64)) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simp only [wwl_shru, Vector.getElem_ofFn,
      Vector.getElem_replicate, Fin.getElem_fin]
    exact shr_add_twoP_ok _

/-- `c + 2p + m`, an `add nsw nuw`. -/
theorem zipWith_add_shr_twoP_mask (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64)
          (wwl_add (wwl_shru y 51) (Vector.replicate 8 4503599627370494#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_and x (Vector.replicate 8 2251799813685247#64))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_add (wwl_shru y 51) (Vector.replicate 8 4503599627370494#64))
          (wwl_and x (Vector.replicate 8 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simp only [wwl_and, wwl_add, wwl_shru, Vector.getElem_ofFn,
      Vector.getElem_replicate, Fin.getElem_fin]
    exact shr_twoP_add_mask_ok _ _

/-- A carry times `19`, a `mul nsw nuw`. -/
theorem zipWith_mul_shru19 (x : Wwl) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru x 51))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 19#64)) =
      Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)) := by
  ext i hi
  have := shr51_mul19_ok x[i]
  simp_all [Ty.wrap_vec, wwl_mul, wwl_shru, Operation.mul]

/-- `19 c + m`, an `add nsw nuw`. -/
theorem zipWith_add_mul19_mask (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_and y (Vector.replicate 8 2251799813685247#64))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64))
          (wwl_and y (Vector.replicate 8 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simp only [wwl_and, wwl_shru, wwl_mul, Vector.getElem_ofFn,
      Vector.getElem_replicate, Fin.getElem_fin]
    exact mul19_add_mask_ok _ _

theorem zipWith_icmp_eq_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.icmp IntPred.eq (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => BitVec.ofBool (x[i] == y[i])) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.icmp]

theorem zipWith_and_i1 (x y : ⟦.vec 8 1⟧ᵣ) :
    Vector.zipWith (Operation.and (w := 1)) (Ty.wrap (t := .vec 8 1) x)
        (Ty.wrap (t := .vec 8 1) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => x[i] &&& y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.and]

theorem zipWith_or_i1 (x y : ⟦.vec 8 1⟧ᵣ) :
    Vector.zipWith (Operation.or false (w := 1)) (Ty.wrap (t := .vec 8 1) x)
        (Ty.wrap (t := .vec 8 1) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => x[i] ||| y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.or]

theorem zipWith_or_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.or false (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (Vector.ofFn fun i => x[i] ||| y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.or]

attribute [local mlir_operation] zipWith_add_mask_twoP zipWith_add_mask_twoP_shr
  zipWith_add_shr_twoP zipWith_add_shr_twoP_mask zipWith_mul_shru19 zipWith_add_mul19_mask
  zipWith_add_shru_mask zipWith_icmp_eq_wwl zipWith_and_i1 zipWith_or_i1 zipWith_or_wwl

/-! ### The zero test -/

/-- `x = a - b`'s limbs as the compiled test builds them: `a0`, then limb `i` of the product's
lazy carry plus `2p` minus `b`'s. -/
def zeroFe (A0 D0 D1 D2 D3 D4 B1 B2 B3 B4 : Wwl) : Fe :=
  ⟨A0,
    wwl_sub
      (wwl_add (wwl_add (wwl_and D1 (Vector.replicate 8 2251799813685247#64))
        (Vector.replicate 8 4503599627370494#64)) (wwl_shru D0 51)) B1,
    wwl_sub
      (wwl_add (wwl_add (wwl_shru D1 51) (Vector.replicate 8 4503599627370494#64))
        (wwl_and D2 (Vector.replicate 8 2251799813685247#64))) B2,
    wwl_sub
      (wwl_add (wwl_add (wwl_shru D2 51) (Vector.replicate 8 4503599627370494#64))
        (wwl_and D3 (Vector.replicate 8 2251799813685247#64))) B3,
    wwl_sub
      (wwl_add (wwl_add (wwl_shru D3 51) (Vector.replicate 8 4503599627370494#64))
        (wwl_and D4 (Vector.replicate 8 2251799813685247#64))) B4⟩

/-- One carry pass of `fd_ed25519_lane_normalize`. -/
def normPass (a : Fe) : Fe :=
  let mask := wwl_bcast mask51
  let l1 := wwl_add a.l1 (wwl_shru a.l0 51)
  let l0 := wwl_and a.l0 mask
  let l2 := wwl_add a.l2 (wwl_shru l1 51)
  let l1 := wwl_and l1 mask
  let l3 := wwl_add a.l3 (wwl_shru l2 51)
  let l2 := wwl_and l2 mask
  let l4 := wwl_add a.l4 (wwl_shru l3 51)
  let l3 := wwl_and l3 mask
  let l0 := wwl_add l0 (wwl_mul (wwl_shru l4 51) (wwl_bcast 19))
  let l4 := wwl_and l4 mask
  ⟨l0, l1, l2, l3, l4⟩

/-- `normPass` as compiled first: each sum with its carry last, the fold first. -/
def passR (a : Fe) : Fe :=
  let t1 := wwl_add a.l1 (wwl_shru a.l0 51)
  let t2 := wwl_add a.l2 (wwl_shru t1 51)
  let t3 := wwl_add a.l3 (wwl_shru t2 51)
  let t4 := wwl_add a.l4 (wwl_shru t3 51)
  ⟨wwl_add (wwl_mul (wwl_shru t4 51) (Vector.replicate 8 19#64))
      (wwl_and a.l0 (Vector.replicate 8 2251799813685247#64)),
    wwl_and t1 (Vector.replicate 8 2251799813685247#64),
    wwl_and t2 (Vector.replicate 8 2251799813685247#64),
    wwl_and t3 (Vector.replicate 8 2251799813685247#64),
    wwl_and t4 (Vector.replicate 8 2251799813685247#64)⟩

/-- `normPass` as compiled second: each sum with its carry first. -/
def passC (a : Fe) : Fe :=
  let t1 := wwl_add (wwl_shru a.l0 51) a.l1
  let t2 := wwl_add (wwl_shru t1 51) a.l2
  let t3 := wwl_add (wwl_shru t2 51) a.l3
  let t4 := wwl_add (wwl_shru t3 51) a.l4
  ⟨wwl_add (wwl_mul (wwl_shru t4 51) (Vector.replicate 8 19#64))
      (wwl_and a.l0 (Vector.replicate 8 2251799813685247#64)),
    wwl_and t1 (Vector.replicate 8 2251799813685247#64),
    wwl_and t2 (Vector.replicate 8 2251799813685247#64),
    wwl_and t3 (Vector.replicate 8 2251799813685247#64),
    wwl_and t4 (Vector.replicate 8 2251799813685247#64)⟩

theorem normPass_eq_passR (b : Fe) : normPass b = passR b := by
  simp only [normPass, passR, wwl_bcast, mask51, wwl_add_comm (wwl_and b.l0 _)]
  rfl

theorem normPass_eq_passC (b : Fe) : normPass b = passC b := by
  simp only [normPass, passC, wwl_bcast, mask51, wwl_add_comm b.l1, wwl_add_comm b.l2,
    wwl_add_comm b.l3, wwl_add_comm b.l4, wwl_add_comm (wwl_and b.l0 _)]
  rfl

theorem normalize_eq_pass (a : Fe) : normalize a = passC (passR a) := by
  rw [show normalize a = normPass (normPass a) from rfl, normPass_eq_passR a, normPass_eq_passC]

/-- `fd_ed25519_lane_is_zero` after the normalization. -/
def isZeroOf (a : Fe) : BitVec 32 :=
  (255 &&&
      (wwl_eq a.l0 wwl_zero &&& wwl_eq a.l1 wwl_zero &&& wwl_eq a.l2 wwl_zero &&&
          wwl_eq a.l3 wwl_zero &&& wwl_eq a.l4 wwl_zero)) |||
    (255 &&&
      (wwl_eq a.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq a.l1 (wwl_bcast mask51) &&&
            wwl_eq a.l2 (wwl_bcast mask51) &&& wwl_eq a.l3 (wwl_bcast mask51) &&&
        wwl_eq a.l4 (wwl_bcast mask51)))

theorem isZero_eq (a : Fe) : isZero a = isZeroOf (normalize a) :=
  rfl

theorem getLsbD_packLanes1 (V : Vector (BitVec 1) n) {j : Nat} (hj : j < n) :
    (BitVec.packLanes V).getLsbD j = (V[j]).getLsbD 0 := by
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt V (s := j) (w := 1) (by simpa using hj) (by omega))
  simp only [Nat.div_one, Nat.mod_one, BitVec.getLsbD_extractLsb', Nat.lt_one_iff, decide_true,
    Bool.true_and, Nat.add_zero] at h
  exact h

theorem getLsbD_wwl_eq (x y : Wwl) {j : Nat} (hj : j < 8) :
    (wwl_eq x y).getLsbD j = (x[j] == y[j]) := by
  rw [wwl_eq, BitVec.getLsbD_setWidth, getLsbD_packLanes1 _ hj]
  simp [show j < 32 by omega]

/-- The zero test on one lane. -/
theorem zeroTest_lane (a0 a1 a2 a3 a4 : BitVec 64) :
    (a1 &&& 2251799813685247#64 &&& a2 &&& a3 &&& a4 == 2251799813685247#64 &&
          a0 == 2251799813685229#64 ||
        a0 ||| (a2 ||| a1 ||| a3 ||| a4) &&& 2251799813685247#64 == 0#64) =
      (a0 == 0 && a1 &&& 2251799813685247#64 == 0 && a2 &&& 2251799813685247#64 == 0 &&
          a3 &&& 2251799813685247#64 == 0 &&
          a4 &&& 2251799813685247#64 == 0 ||
        a0 == 2251799813685247 - 18 && a1 &&& 2251799813685247#64 == 2251799813685247 &&
          a2 &&& 2251799813685247#64 == 2251799813685247 &&
          a3 &&& 2251799813685247#64 == 2251799813685247 &&
          a4 &&& 2251799813685247#64 == 2251799813685247) := by
  bv_decide

/-- The zero test as compiled, on the normalization's limbs before their last masks. -/
theorem zeroTest_compiled (n0 n1 n2 n3 n4 : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        BitVec.ofBool
          ((wwl_and (wwl_and (wwl_and (wwl_and n1 (Vector.replicate 8 2251799813685247#64)) n2) n3)
                    n4)[↑i] ==
                2251799813685247#64 &&
              n0[↑i] == 2251799813685229#64 ||
            (n0[↑i] |||
                (wwl_and (Vector.ofFn fun i : Fin 8 => n2[↑i] ||| n1[↑i] ||| n3[↑i] ||| n4[↑i])
                    (Vector.replicate 8 2251799813685247#64))[↑i] ==
              0#64))) =
      Vector.ofFn fun i =>
        BitVec.ofBool
          ((isZeroOf
                ⟨n0, wwl_and n1 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n2 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n3 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n4 (Vector.replicate 8 2251799813685247#64)⟩).getLsbD
            i) := by
  apply Vector.ext
  intro i hi
  simp only [Vector.getElem_ofFn]
  refine congrArg BitVec.ofBool ?_
  have hb : (255 : BitVec 32).getLsbD i = true := by interval_cases i <;> decide
  simp only [isZeroOf, BitVec.getLsbD_or, BitVec.getLsbD_and, getLsbD_wwl_eq _ _ hi, hb,
    Bool.true_and, wwl_and, wwl_bcast, wwl_zero, mask51, Vector.getElem_ofFn,
    Vector.getElem_replicate, Fin.getElem_fin]
  exact zeroTest_lane _ _ _ _ _

/-- `fd_ed25519_lane_is_zero( x )` of `x = a - b` (`a` a product's limbs `d`, carried lazily) as
compiled into `fd_ed25519_lane_verify`, 54 instructions: `a0 = a.l0 - b.l0`, the masked limbs
`m1 … m4` and carries `c0 … c3` of `d`, `b1 … b4`; `kP km k51 k19 kq z` holding `2p`'s limb, the
51-bit mask, `51`, `19`, `2^51 - 19` and `0`. The lane mask into `t`. -/
def zeroRun (a0 m1 m2 m3 m4 c0 c1 c2 c3 b1 b2 b3 b4 kP km k51 k19 kq z : Dst Γ V)
    (s0 u1 v1 w1 L1 n0 s1 u2 v2 w2 L2 n1 s2 u3 v3 w3 L3 n2 s3 u4 v4 w4 L4 n3 s4 e0 P0 n4 r0 Q1 o0
      r1 Q2 r2 Q3 r3 Q4 r4 e1 F0 : Dst Γ V) (bq0 : Dst Γ (.vec 8 1)) (o1 o2 o3 o4 o5 : Dst Γ V)
    (bz : Dst Γ (.vec 8 1)) (a1 a2 a3 a4 : Dst Γ V) (bq bqq t : Dst Γ (.vec 8 1)) :
    List (Instr Γ) :=
  [.binop (.vector (.lshr false)) s0 (.val a0.i a0.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u1 (.val m1.i m1.h) (.val kP.i kP.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v1 (.val u1.i u1.h) (.val c0.i c0.h),
    .binop (.vector (.sub {})) w1 (.val v1.i v1.h) (.val b1.i b1.h),
    .binop (.vector (.add {})) L1 (.val w1.i w1.h) (.val s0.i s0.h),
    .binop (.vector .and) n0 (.val a0.i a0.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) s1 (.val L1.i L1.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u2 (.val c1.i c1.h) (.val kP.i kP.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v2 (.val u2.i u2.h) (.val m2.i m2.h),
    .binop (.vector (.sub {})) w2 (.val v2.i v2.h) (.val b2.i b2.h),
    .binop (.vector (.add {})) L2 (.val w2.i w2.h) (.val s1.i s1.h),
    .binop (.vector .and) n1 (.val L1.i L1.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) s2 (.val L2.i L2.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u3 (.val c2.i c2.h) (.val kP.i kP.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v3 (.val u3.i u3.h) (.val m3.i m3.h),
    .binop (.vector (.sub {})) w3 (.val v3.i v3.h) (.val b3.i b3.h),
    .binop (.vector (.add {})) L3 (.val w3.i w3.h) (.val s2.i s2.h),
    .binop (.vector .and) n2 (.val L2.i L2.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) s3 (.val L3.i L3.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u4 (.val c3.i c3.h) (.val kP.i kP.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v4 (.val u4.i u4.h) (.val m4.i m4.h),
    .binop (.vector (.sub {})) w4 (.val v4.i v4.h) (.val b4.i b4.h),
    .binop (.vector (.add {})) L4 (.val w4.i w4.h) (.val s3.i s3.h),
    .binop (.vector .and) n3 (.val L3.i L3.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) s4 (.val L4.i L4.h) (.val k51.i k51.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) e0 (.val s4.i s4.h) (.val k19.i k19.h),
    .binop (.vector (.add { nsw := true, nuw := true })) P0 (.val e0.i e0.h) (.val n0.i n0.h),
    .binop (.vector .and) n4 (.val L4.i L4.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) r0 (.val P0.i P0.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) Q1 (.val r0.i r0.h) (.val n1.i n1.h),
    .binop (.vector .and) o0 (.val P0.i P0.h) (.val km.i km.h),
    .binop (.vector (.lshr false)) r1 (.val Q1.i Q1.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) Q2 (.val r1.i r1.h) (.val n2.i n2.h),
    .binop (.vector (.lshr false)) r2 (.val Q2.i Q2.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) Q3 (.val r2.i r2.h) (.val n3.i n3.h),
    .binop (.vector (.lshr false)) r3 (.val Q3.i Q3.h) (.val k51.i k51.h),
    .binop (.vector (.add { nsw := true, nuw := true })) Q4 (.val r3.i r3.h) (.val n4.i n4.h),
    .binop (.vector (.lshr false)) r4 (.val Q4.i Q4.h) (.val k51.i k51.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) e1 (.val r4.i r4.h) (.val k19.i k19.h),
    .binop (.vector (.add { nsw := true, nuw := true })) F0 (.val e1.i e1.h) (.val o0.i o0.h),
    .binop (.vector (.icmp .eq)) bq0 (.val F0.i F0.h) (.val kq.i kq.h),
    .binop (.vector (.or false)) o1 (.val Q2.i Q2.h) (.val Q1.i Q1.h),
    .binop (.vector (.or false)) o2 (.val o1.i o1.h) (.val Q3.i Q3.h),
    .binop (.vector (.or false)) o3 (.val o2.i o2.h) (.val Q4.i Q4.h),
    .binop (.vector .and) o4 (.val o3.i o3.h) (.val km.i km.h),
    .binop (.vector (.or false)) o5 (.val F0.i F0.h) (.val o4.i o4.h),
    .binop (.vector (.icmp .eq)) bz (.val o5.i o5.h) (.val z.i z.h),
    .binop (.vector .and) a1 (.val Q1.i Q1.h) (.val km.i km.h),
    .binop (.vector .and) a2 (.val a1.i a1.h) (.val Q2.i Q2.h),
    .binop (.vector .and) a3 (.val a2.i a2.h) (.val Q3.i Q3.h),
    .binop (.vector .and) a4 (.val a3.i a3.h) (.val Q4.i Q4.h),
    .binop (.vector (.icmp .eq)) bq (.val a4.i a4.h) (.val km.i km.h),
    .binop (.vector .and) bqq (.val bq.i bq.h) (.val bq0.i bq0.h),
    .binop (.vector (.or false)) t (.val bqq.i bqq.h) (.val bz.i bz.h)]

/-- Where the body at `pos` is `zeroRun`, `d`'s limbs `D` and `b`'s limbs `B` (`a0` holding `A0`):
running on from `pos` gives `K` if it does from `pos + 54` with `isZero` of the difference's limbs
in `t`'s lanes, whatever the intermediates hold. -/
theorem runBodyFrom_zeroRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a0 m1 m2 m3 m4 c0 c1 c2 c3 b1 b2 b3 b4 kP km k51 k19 kq z : Dst Γ V}
    {s0 u1 v1 w1 L1 n0 s1 u2 v2 w2 L2 n1 s2 u3 v3 w3 L3 n2 s3 u4 v4 w4 L4 n3 s4 e0 P0 n4 r0 Q1 o0 r1
    Q2 r2 Q3 r3 Q4 r4 e1 F0 o1 o2 o3 o4 o5 a1 a2 a3 a4 : Dst Γ V}
    {bq0 bz bq bqq t : Dst Γ (.vec 8 1)}
    {rest : List (Instr Γ)} {A0 D0 D1 D2 D3 D4 B1 B2 B3 B4 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
       zeroRun a0 m1 m2 m3 m4 c0 c1 c2 c3 b1 b2 b3 b4 kP km k51 k19 kq z s0 u1 v1 w1 L1 n0 s1 u2 v2
            w2 L2 n1 s2 u3 v3 w3 L3 n2 s3 u4 v4 w4 L4 n3 s4 e0 P0 n4 r0 Q1 o0 r1 Q2 r2 Q3 r3 Q4 r4
            e1 F0 bq0 o1 o2 o3 o4 o5 bz a1 a2 a3 a4 bq bqq t ++
          rest)
    (hR :
      E ⊨ [a0 := A0, m1 := wwl_and D1 (Vector.replicate 8 2251799813685247#64), m2 := wwl_and D2
        (Vector.replicate 8 2251799813685247#64), m3 := wwl_and D3 (Vector.replicate 8
        2251799813685247#64), m4 := wwl_and D4 (Vector.replicate 8 2251799813685247#64), c0 :=
        wwl_shru D0 51, c1 := wwl_shru D1 51, c2 := wwl_shru D2 51, c3 := wwl_shru D3 51, b1 := B1,
        b2 := B2, b3 := B3, b4 := B4, kP := Vector.replicate 8 4503599627370494#64, km :=
        Vector.replicate 8 2251799813685247#64, k51 := Vector.replicate 8 51#64, k19 :=
        Vector.replicate 8 19#64, kq := Vector.replicate 8 2251799813685229#64, z :=
        Vector.replicate 8 0#64])
    (hd :
      [a0.i, m1.i, m2.i, m3.i, m4.i, c0.i, c1.i, c2.i, c3.i, b1.i, b2.i, b3.i, b4.i, kP.i, km.i,
          k51.i, k19.i, kq.i, z.i, s0.i, u1.i, v1.i, w1.i, L1.i, n0.i, s1.i, u2.i, v2.i, w2.i, L2.i,
          n1.i, s2.i, u3.i, v3.i, w3.i, L3.i, n2.i, s3.i, u4.i, v4.i, w4.i, L4.i, n3.i, s4.i, e0.i,
          P0.i, n4.i, r0.i, Q1.i, o0.i, r1.i, Q2.i, r2.i, Q3.i, r3.i, Q4.i, r4.i, e1.i, F0.i, bq0.i,
          o1.i, o2.i, o3.i, o4.i, o5.i, bz.i, a1.i, a2.i, a3.i, a4.i, bq.i, bqq.i, t.i].Nodup)
    (hK :
     ∀ v_s0 v_u1 v_v1 v_w1 v_L1 v_n0 v_s1 v_u2 v_v2 v_w2 v_L2 v_n1 v_s2 v_u3 v_v3 v_w3 v_L3 v_n2
        v_s3 v_u4 v_v4 v_w4 v_L4 v_n3 v_s4 v_e0 v_P0 v_n4 v_r0 v_Q1 v_o0 v_r1 v_Q2 v_r2 v_Q3 v_r3
        v_Q4 v_r4 v_e1 v_F0 v_o1 v_o2 v_o3 v_o4 v_o5 v_a1 v_a2 v_a3 v_a4 : ⟦V⟧,
     ∀ v_bq0 v_bz v_bq v_bqq : ⟦.vec 8 1⟧,
        (blk.runBodyFrom
              E[s0 := v_s0, u1 := v_u1, v1 := v_v1, w1 := v_w1, L1 := v_L1, n0 := v_n0, s1 := v_s1,
                u2 := v_u2, v2 := v_v2, w2 := v_w2, L2 := v_L2, n1 := v_n1, s2 := v_s2, u3 := v_u3,
                v3 := v_v3, w3 := v_w3, L3 := v_L3, n2 := v_n2, s3 := v_s3, u4 := v_u4, v4 := v_v4,
                w4 := v_w4, L4 := v_L4, n3 := v_n3, s4 := v_s4, e0 := v_e0, P0 := v_P0, n4 := v_n4,
                r0 := v_r0, Q1 := v_Q1, o0 := v_o0, r1 := v_r1, Q2 := v_Q2, r2 := v_r2, Q3 := v_Q3,
                r3 := v_r3, Q4 := v_Q4, r4 := v_r4, e1 := v_e1, F0 := v_F0, bq0 := v_bq0, o1 :=
                v_o1, o2 := v_o2, o3 := v_o3, o4 := v_o4, o5 := v_o5, bz := v_bz, a1 := v_a1, a2 :=
                v_a2, a3 := v_a3, a4 := v_a4, bq := v_bq, bqq := v_bqq, t := Ty.wrap (Vector.ofFn
                fun i => BitVec.ofBool ((isZero (zeroFe A0 D0 D1 D2 D3 D4 B1 B2 B3 B4)).getLsbD i))]
              (pos + 54) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 53 step_pure
  step_pure with tv
  have htv' :
      tv =
        Vector.ofFn fun i =>
          BitVec.ofBool ((isZero (zeroFe A0 D0 D1 D2 D3 D4 B1 B2 B3 B4)).getLsbD i) := by
    rw [htv, isZero_eq, normalize_eq_pass]
    simp only [passC, passR, zeroFe]
    exact zeroTest_compiled _ _ _ _ _
  rw [hE, htv']
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _

/-- The registers after `fd_ed25519_lane_verify`: `live`, `valid`. -/
abbrev EnvF (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %39 :=
    Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap
    (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32, %61 := PoisonOr.value
    0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %69 := PoisonOr.value 8#64,
    %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %114 := Vector.replicate 16
    PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32,
    2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 4649 :=
    PoisonOr.value (c.X.valid)]

end

/-! ### `valid` -/

theorem twoP_eq :
    twoP = ⟨Vector.replicate 8 4503599627370458#64, Vector.replicate 8 4503599627370494#64,
      Vector.replicate 8 4503599627370494#64, Vector.replicate 8 4503599627370494#64,
      Vector.replicate 8 4503599627370494#64⟩ :=
  rfl

theorem limb1_eq (m p c b : Wwl) :
    wwl_sub (wwl_add (wwl_add m p) c) b = wwl_sub (wwl_add (wwl_add m c) p) b := by
  wwl_ring

theorem limbk_eq (c p m b : Wwl) :
    wwl_sub (wwl_add (wwl_add c p) m) b = wwl_sub (wwl_add (wwl_add m c) p) b := by
  wwl_ring

/-- The compiled test's limbs: `a·b - B` as `fd_ed25519_lane_sub_raw` leaves it, given its limb
0. -/
theorem zeroFe_eq (a b : Fe) (B0 B1 B2 B3 B4 A0 : Wwl)
    (h : A0 = (subRaw (mul a b) ⟨B0, B1, B2, B3, B4⟩).l0) :
    zeroFe A0 (mul a b false).l0 (mul a b false).l1 (mul a b false).l2 (mul a b false).l3
        (mul a b false).l4 B1 B2 B3 B4 =
      subRaw (mul a b) ⟨B0, B1, B2, B3, B4⟩ := by
  rw [h, mul_eq_carry a b]
  generalize mul a b false = D
  simp only [zeroFe, subRaw, subOff, twoP_eq, carry, Fe.zipWith, wwl_bcast,
    show mask51 = 2251799813685247#64 from rfl]
  rw [Fe.mk.injEq]
  exact ⟨rfl, limb1_eq _ _ _ _, limbk_eq _ _ _ _, limbk_eq _ _ _ _, limbk_eq _ _ _ _⟩

theorem isZero_getLsbD_of_ge (a : Fe) {j : Nat} (hj : 8 ≤ j) : (isZero a).getLsbD j = false := by
  have h : (255 : BitVec 32).getLsbD j = false := by
    rw [BitVec.ofNat_eq_ofNat, BitVec.getLsbD_ofNat,
      Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le (by decide) (Nat.pow_le_pow_right (by decide) hj)),
      Bool.and_false]
  simp only [isZero, BitVec.getLsbD_or, BitVec.getLsbD_and, h, Bool.false_and, Bool.or_false]

/-- `valid`: the lanes' two zero tests, packed. -/
theorem setWidth_packLanes_and {w : Nat} (h : 1 * 8 = w) (a b : Fe) :
    BitVec.setWidth 32
        (BitVec.cast h
          (BitVec.packLanes
            (Vector.ofFn fun i : Fin 8 =>
              BitVec.ofBool ((isZero a).getLsbD i && (isZero b).getLsbD i)))) =
      isZero a &&& isZero b := by
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  rw [BitVec.getLsbD_setWidth, BitVec.getLsbD_cast]
  by_cases h8 : j < 8
  · simp only [hj, decide_true, Bool.true_and, getLsbD_packLanes1 _ h8, Vector.getElem_ofFn,
      BitVec.getLsbD_ofBool, BitVec.getLsbD_and]
  · rw [BitVec.getLsbD_of_ge _ _ (by omega)]
    simp only [BitVec.getLsbD_and, isZero_getLsbD_of_ge _ (Nat.not_lt.mp h8), Bool.and_false]

/-- `fd_ed25519_lane_verify`'s result: `r` against the ladder's `acc`, projectively. -/
theorem Call.valid_eq (c : Call) :
    c.X.valid =
      isZero (subRaw (mul c.decR.1.x (c.acc 64).z) (c.acc 64).x) &&&
        isZero (subRaw (mul c.decR.1.y (c.acc 64).z) (c.acc 64).y) :=
  rfl

/-- A lane point's limbs, at the offsets the loads compute. -/
theorem readLanePoint_limbs (m : MemoryState) (p : Pointer) :
    (m.readLanePoint p).x =
        ⟨m.readVec p, m.readVec (p.add 64#64), m.readVec (p.add 128#64), m.readVec (p.add 192#64),
          m.readVec (p.add 256#64)⟩ ∧
      (m.readLanePoint p).y =
        ⟨m.readVec (p.add 320#64), m.readVec (p.add 384#64), m.readVec (p.add 448#64),
          m.readVec (p.add 512#64), m.readVec (p.add 576#64)⟩ ∧
      (m.readLanePoint p).z =
        ⟨m.readVec (p.add 640#64), m.readVec (p.add 704#64), m.readVec (p.add 768#64),
          m.readVec (p.add 832#64), m.readVec (p.add 896#64)⟩ := by
  refine ⟨rfl, ?_, ?_⟩ <;> simp [MemoryState.readLanePoint, MemoryState.readFe, Pointer.add_add]

/-! ### `^bb88` -/

/-- The test for the scalar loop. -/
theorem cnt_lt_eight {n : Nat} (h : n ≤ 8) : (BitVec.ofNat 64 n).ult 8#64 = true ↔ n < 8 := by
  revert n; decide

/-- The test failing: eight items. -/
theorem cnt_eq_eight {n : Nat} (h : n ≤ 8) : ¬(BitVec.ofNat 64 n).ult 8#64 = true ↔ n = 8 := by
  revert n; decide

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- 160 steps and four patterns on a 5000-instruction function
set_option maxHeartbeats 0 in
/-- `^bb88`: `fd_ed25519_lane_verify`'s comparison `valid`, the loop's arrays ended; on to the
scalar loop for `cnt < 8`, else the eight-lane loop. -/
public theorem cmp_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hE : Env88 c E) (hS : c.At88 S)
    (h97 :
      c.cnt < 8 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvF c E' →
        (E' ⊨ [rir_reg% hty 4719 := PoisonOr.value 0#64]) → c.Base S' c.mem76 →
        ((verify_x8 c.batch).runFrom E' 97 S' >>= g) = K)
    (h89 :
      c.cnt = 8 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvF c E' →
        c.Base S' c.mem76 → ((verify_x8 c.batch).runFrom E' 89 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 88 S >>= g) = K := by
  have hwf := hS.base.wf
  have hacc := hS.acc.fit
  have hr := hS.r.fit
  have hacc_read := hS.acc.read
  have hr_read := hS.r.read
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hB : c.Base S₀ c.mem76 := hS₀ ▸ hS.base
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨88, (by decide : 88 < 104)⟩ S >>= g) = K
  block_init
  -- `r->x`, `acc.z`
  step_load [MemoryState.ofFn_extractVecElem_readAt] with rx0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with rx1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with rx2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with rx3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with rx4
  step_load [MemoryState.ofFn_extractVecElem_readAt] with az0
  step_load [MemoryState.ofFn_extractVecElem_readAt] with az1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with az2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with az3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with az4
  -- `fd_ed25519_lane_mul( x, &r->x, &acc.z )`
  step_pattern using runBodyFrom_mulLooseRun
  -- its carry, the adds left for the subtraction
  iterate 11 step_pure
  -- `r->y`
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ry0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ry1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ry2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ry3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ry4
  -- `fd_ed25519_lane_mul( y, &r->y, &acc.z )`, its carry
  step_pattern using runBodyFrom_mulLooseRun
  iterate 11 step_pure
  -- limb 0 of `x - acc.x`, `y - acc.y`, with the loads of `acc.x`, `acc.y`
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ax0
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ax1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ax2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ax3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ax4
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ay0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ay1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ay2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ay3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with ay4
  -- `fd_ed25519_lane_is_zero` of both
  step_pattern using runBodyFrom_zeroRun
  step_pattern using runBodyFrom_zeroRun
  -- `valid`
  step_pure
  step_pure
  step_pure with valid
  have hv : valid = c.X.valid := by
    subst hS₀
    rw [hS] at hr_read hacc_read
    obtain ⟨hrx, hry, -⟩ := readLanePoint_limbs S₀.mem (c.s.slot 29)
    obtain ⟨hax, hay, haz⟩ := readLanePoint_limbs S₀.mem (c.s.slot 11)
    subst hrx0 hrx1 hrx2 hrx3 hrx4 hry0 hry1 hry2 hry3 hry4 haz0 haz1 haz2 haz3 haz4 hax0 hax1 hax2
      hax3 hax4 hay0 hay1 hay2 hay3 hay4
    rw [hvalid]
    erw [setWidth_packLanes_and]
    rw [zeroFe_eq _ _ (S₀.mem.readVec (c.s.slot 11)) _ _ _ _ _ ?_,
      zeroFe_eq _ _ (S₀.mem.readVec ((c.s.slot 11).add 320#64)) _ _ _ _ _ ?_, c.valid_eq,
      ← hr_read, ← hacc_read, hrx, hry, hax, hay, haz]
    all_goals
      rw [mul_eq_carry]
      ext i hi
      simp [subRaw, subOff, twoP_eq, carry, Fe.zipWith, wwl_sub, wwl_add, wwl_madd52lo, wwl_and,
        wwl_shru, wwl_bcast, madd52lo, mask51, m52]
  clear hvalid
  subst hv
  -- `acc`, `ktab`, `k2d`, `sd`, `kd` end
  iterate 5 step_pure
  step_pure
  finish_block
  · subst hS₀
    exact h97 ((cnt_lt_eight hc.cnt8).1 hbr) E S hArgs (by dsimp only [EnvF]; env_reads)
      (by env_reads) (hB.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]))
  · subst hS₀
    exact h89 ((cnt_eq_eight hc.cnt8).1 hbr) E S hArgs (by dsimp only [EnvF]; env_reads)
      (hB.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]))

end MLIR.Firedancer.Lane.VerifyX8

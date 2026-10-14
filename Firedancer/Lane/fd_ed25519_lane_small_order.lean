module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Ops
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Mlir.fd_ed25519_lane_small_order
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Mathlib.Tactic.IntervalCases

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- The encoding of `fd_ed25519_order8_point_y0`, a small-order point's `y`. -/
def order8Y0Bytes : BitVec 256 :=
  0x05fc536d880238b13933c6d305acdfd5f098eff289f4c345b027b2c28f95e826#256

/-- The encoding of `fd_ed25519_order8_point_y1`, a small-order point's `y`. -/
def order8Y1Bytes : BitVec 256 :=
  0x7a03ac9277fdc74ec6cc392cfa53202a0f67100d760b3cba4fd84d3d706a17c7#256

/-- `order8Y0Bytes`, broadcast. -/
def order8Y0 : Fe :=
  bcastBytes order8Y0Bytes

/-- `order8Y1Bytes`, broadcast. -/
def order8Y1 : Fe :=
  bcastBytes order8Y1Bytes

/-- The limbs of `fd_ed25519_order8_point_y0`. -/
def order8Y0Limbs : Wwl :=
  #v[3034655877158#64, 7251661554934#64, 8531478563367#64, 3751701540842#64, 152657171260#64,
    51416324880#64, 0#64, 0#64]

/-- The limbs of `fd_ed25519_order8_point_y1`. -/
def order8Y1Limbs : Wwl :=
  #v[5761437145031#64, 1544431467273#64, 264614458840#64, 5044391481365#64, 8643435850947#64,
    1048095302895#64, 0#64, 0#64]

end

theorem tobytes_order8Y0Limbs : tobytes order8Y0Limbs = order8Y0Bytes := by decide

theorem tobytes_order8Y1Limbs : tobytes order8Y1Limbs = order8Y1Bytes := by decide

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

theorem shr51_mul19_ok (a : BitVec 64) :
    (a >>> 51).smulOverflow 19#64 = false ∧ (a >>> 51).umulOverflow 19#64 = false := by bv_decide

theorem mul19_add_mask_ok (a b : BitVec 64) :
    (a >>> 51 * 19#64).saddOverflow (b &&& 2251799813685247#64) = false ∧
      (a >>> 51 * 19#64).uaddOverflow (b &&& 2251799813685247#64) = false := by
  bv_decide

theorem zipWith_mul_shru19 (x : Wwl) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru x 51))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 19#64)) =
      Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)) := by
  ext i hi
  have := shr51_mul19_ok x[i]
  simp_all [Ty.wrap_vec, wwl_mul, wwl_shru, Operation.mul]

theorem zipWith_add_mul19_mask (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_and y (Vector.replicate 8 2251799813685247#64))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64))
          (wwl_and y (Vector.replicate 8 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simpa [wwl_and, wwl_shru, wwl_mul] using mul19_add_mask_ok x[i] y[i]

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

attribute [local mlir_operation] zipWith_mul_shru19 zipWith_add_mul19_mask zipWith_icmp_eq_wwl
  zipWith_and_i1 zipWith_or_i1 zipWith_or_wwl

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

/-- `fd_ed25519_lane_normalize`'s carry pass as compiled: each sum with its carry first. -/
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

theorem normPass_eq (b : Fe) : normPass b = passC b := by
  simp only [normPass, passC, wwl_bcast, mask51, wwl_add_comm b.l1, wwl_add_comm b.l2,
    wwl_add_comm b.l3, wwl_add_comm b.l4, wwl_add_comm (wwl_and b.l0 _)]
  rfl

theorem normalize_eq_passC (a : Fe) : normalize a = passC (passC a) := by
  rw [show normalize a = normPass (normPass a) from rfl, normPass_eq, normPass_eq]

/-- `fd_ed25519_lane_is_zero` after the normalization. -/
def isZeroOf (a : Fe) : BitVec 32 :=
  let z :=
    wwl_eq a.l0 wwl_zero &&& wwl_eq a.l1 wwl_zero &&& wwl_eq a.l2 wwl_zero &&&
      wwl_eq a.l3 wwl_zero &&&
      wwl_eq a.l4 wwl_zero
  let m := wwl_bcast mask51
  let q :=
    wwl_eq a.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq a.l1 m &&& wwl_eq a.l2 m &&& wwl_eq a.l3 m &&&
      wwl_eq a.l4 m
  (255 &&& z) ||| (255 &&& q)

theorem isZero_eq (a : Fe) : isZero a = isZeroOf (normalize a) :=
  rfl

theorem subRaw_eq (a b : Fe) :
    subRaw a b =
      ⟨wwl_sub (wwl_add a.l0 (Vector.replicate 8 4503599627370458#64)) b.l0,
        wwl_sub (wwl_add a.l1 (Vector.replicate 8 4503599627370494#64)) b.l1,
        wwl_sub (wwl_add a.l2 (Vector.replicate 8 4503599627370494#64)) b.l2,
        wwl_sub (wwl_add a.l3 (Vector.replicate 8 4503599627370494#64)) b.l3,
        wwl_sub (wwl_add a.l4 (Vector.replicate 8 4503599627370494#64)) b.l4⟩ :=
  rfl

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

theorem isZero_getLsbD_of_ge (a : Fe) {j : Nat} (hj : 8 ≤ j) : (isZero a).getLsbD j = false := by
  have h : (255 : BitVec 32).getLsbD j = false := by
    rw [BitVec.ofNat_eq_ofNat, BitVec.getLsbD_ofNat,
      Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le (by decide) (Nat.pow_le_pow_right (by decide) hj)),
      Bool.and_false]
  simp only [isZero, BitVec.getLsbD_or, BitVec.getLsbD_and, h, Bool.false_and, Bool.or_false]

/-- The returned mask: the eight lane bits, zero-extended. -/
theorem setWidth_packLanes_isZero {w : Nat} (h : 1 * 8 = w) (a b c d : Fe) :
    BitVec.setWidth 32
        (BitVec.cast h
          (BitVec.packLanes
            (Vector.ofFn fun i : Fin 8 =>
              BitVec.ofBool
                ((isZero a).getLsbD i || (isZero b).getLsbD i || (isZero c).getLsbD i ||
                  (isZero d).getLsbD i)))) =
      isZero a ||| isZero b ||| isZero c ||| isZero d := by
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  rw [BitVec.getLsbD_setWidth, BitVec.getLsbD_cast]
  by_cases h8 : j < 8
  · simp only [hj, decide_true, Bool.true_and, getLsbD_packLanes1 _ h8, Vector.getElem_ofFn,
      BitVec.getLsbD_ofBool, BitVec.getLsbD_or]
  · rw [BitVec.getLsbD_of_ge _ _ (by omega)]
    simp only [BitVec.getLsbD_or, isZero_getLsbD_of_ge _ (Nat.not_lt.mp h8), Bool.false_or,
      Bool.and_false]

set_option maxHeartbeats 4000000 in
-- 260 instructions: four inlined zero tests of two carry passes each
/-- `fd_ed25519_lane_small_order( r )`: the mask of the lanes of `r` with `x` or `y` zero mod `p`,
or `y` one of the order-8 `y`s; its two stack field elements are freed. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_small_order.call_eq (r : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.LanePointFit r) :
    Firedancer.Lane.Mlir.fd_ed25519_lane_small_order.call
        (Firedancer.Lane.Mlir.fd_ed25519_lane_small_order.args (.value r)) s =
      .value
        (.cons (.value (smallOrder order8Y0 order8Y1 (s.mem.readLanePoint r))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 10 step_pure
  step_alloca
  step_alloca
  step_pure
  step_pure
  have hfe10 : S.mem.FeRoom v10 :=
    ⟨by
      rw [hv10_off]; decide, hroom_v10⟩
  have hfe11 : S.mem.FeRoom v11 :=
    ⟨by
      rw [hv11_off]; decide, hroom_v11⟩
  step_call using Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq
  step_call using Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y1
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y2
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y3
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y4
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_pure
  step_store
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x4
  iterate 41 step_pure
  step_pure with zx
  have hzx' :
    zx = Vector.ofFn fun i => BitVec.ofBool ((isZero ⟨x0, x1, x2, x3, x4⟩).getLsbD i) := by
    rw [hzx, isZero_eq, normalize_eq_passC]
    simp only [passC]
    exact zeroTest_compiled _ _ _ _ _
  iterate 41 step_pure
  step_pure with zy
  have hzy' :
    zy = Vector.ofFn fun i => BitVec.ofBool ((isZero ⟨y0, y1, y2, y3, y4⟩).getLsbD i) := by
    rw [hzy, wwl_add_comm y1, isZero_eq, normalize_eq_passC]
    simp only [passC]
    exact zeroTest_compiled _ _ _ _ _
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  iterate 41 step_pure
  step_pure with z0
  have hz0' :
    z0 =
      Vector.ofFn fun i =>
        BitVec.ofBool
          ((isZero (subRaw ⟨y0, y1, y2, y3, y4⟩ (bcastBytes (tobytes order8Y0Limbs)))).getLsbD
            i) := by
    rw [hz0, wwl_add_comm (wwl_sub (wwl_add y1 _) _) (wwl_shru _ 51), isZero_eq, normalize_eq_passC,
      subRaw_eq]
    simp only [passC]
    exact zeroTest_compiled _ _ _ _ _
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  step_load [MemoryState.ofFn_extractVecElem_readAt]
  iterate 41 step_pure
  step_pure with z1
  have hz1' :
    z1 =
      Vector.ofFn fun i =>
        BitVec.ofBool
          ((isZero (subRaw ⟨y0, y1, y2, y3, y4⟩ (bcastBytes (tobytes order8Y1Limbs)))).getLsbD
            i) := by
    rw [hz1, wwl_add_comm (wwl_sub (wwl_add y1 _) _) (wwl_shru _ 51), isZero_eq, normalize_eq_passC,
      subRaw_eq]
    simp only [passC]
    exact zeroTest_compiled _ _ _ _ _
  iterate 5 step_pure
  finish_block
  subst_vars
  erase_frame
  rw [MemoryState.readLanePoint_eq]
  erw [setWidth_packLanes_isZero]
  rfl

end Proof

end MLIR.Firedancer.Lane

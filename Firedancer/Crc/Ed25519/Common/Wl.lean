module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
import Std.Tactic.BVDecide

/-! The `<4 x i64>` instructions of crc's QUAD kernels that mlir-proofs' `VecRun` has no lemma for:
the lane-wise `mul` (the fold by 19 and 38 in 64-bit arithmetic) and the carry add whose operands
are the compiled way round, `shr` first. -/

namespace MLIR.Firedancer.Crc.Ed25519

open MLIR.Firedancer.R52x5

@[expose] public section

/-- `wl_mul(x, y)`: the low 64 bits of each lane's product. -/
def wl_mul (x y : Wl) : Wl :=
  Vector.ofFn fun i => x[i] * y[i]

theorem wl_mul_getElem (x y : Wl) (i : Nat) (h : i < 4) : (wl_mul x y)[i] = x[i] * y[i] := by
  simp [wl_mul]

/-- A lane-wise `mul` without flags. -/
theorem zipWith_mul_wl (x y : ⟦.vec 4 64⟧ᵣ) :
    Vector.zipWith (Operation.mul {} (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (wl_mul x y) := by
  ext i hi
  simp [Ty.wrap_vec, wl_mul, Operation.mul]

/-- `mask51_add_shr51` with the operands the other way round, on lanes. -/
theorem wl_shru_add_and_ok (x y : Wl) :
    ∀ i : Fin 4,
      (wl_shru y 51)[i].saddOverflow (wl_and x (Vector.replicate 4 2251799813685247#64))[i] =
          false ∧
        (wl_shru y 51)[i].uaddOverflow (wl_and x (Vector.replicate 4 2251799813685247#64))[i] =
          false := by
  intro i
  have h : ∀ a b : BitVec 64,
      (b >>> 51).saddOverflow (a &&& 2251799813685247#64) = false ∧
        (b >>> 51).uaddOverflow (a &&& 2251799813685247#64) = false := by
    intro a b
    bv_decide
  simpa [wl_and, wl_shru] using h x[i] y[i]

/-- The last carry of `FD_R52X5_QUAD_MUL` and `FD_R52X5_QUAD_SQR` as compiled: the `shr` operand
first, an `add nsw nuw`. -/
theorem zipWith_add_nsw_nuw_reduce' (x y : Wl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (wl_shru y 51))
        (Ty.wrap (t := .vec 4 64) (wl_and x (Vector.replicate 4 2251799813685247#64))) =
      Ty.wrap (t := .vec 4 64)
        (wl_add (wl_shru y 51) (wl_and x (Vector.replicate 4 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wl _ _ (wl_shru_add_and_ok x y)

/-- `FD_R52X5_QUAD_ZERO`: every limb zero. -/
def quad5_zero : Quad5 :=
  ⟨wl_zero, wl_zero, wl_zero, wl_zero, wl_zero⟩

/-- A load of a `<32 x i8>` as the steps give it: the bytes of `readWv`. -/
theorem ofFn_extractVecElem_wlBytes {m : MemoryState} :
    (Vector.ofFn fun i => Ty.extractVecElem 32 8 i (m.readAt p 256)) = wlBytes (m.readWv p) := by
  rw [← MemoryState.packLanes_readWv]
  ext k hk : 1
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, wlBytes]
  exact extractLsb'_packLanes_byte _ hk

/-- A lane of a `wl_t` from its eight bytes, as a byte `shufflevector` and `bitcast` leave it. -/
theorem wlBytes_lane (v : Wl) (k : Nat) (hk : k < 4) :
    (wlBytes v)[8 * k + 7] ++ (wlBytes v)[8 * k + 6] ++ (wlBytes v)[8 * k + 5] ++
            (wlBytes v)[8 * k + 4] ++ (wlBytes v)[8 * k + 3] ++ (wlBytes v)[8 * k + 2] ++
          (wlBytes v)[8 * k + 1] ++ (wlBytes v)[8 * k] =
      v[k] := by
  have e : ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 = x := by
    intro x
    bv_decide
  obtain rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 := by omega
  all_goals
    simp only [wlBytes, Vector.getElem_ofFn, Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul,
      Nat.reduceAdd, e]

theorem wlBytes_lane0 (v : Wl) :
    (wlBytes v)[7] ++ (wlBytes v)[6] ++ (wlBytes v)[5] ++ (wlBytes v)[4] ++ (wlBytes v)[3] ++
          (wlBytes v)[2] ++ (wlBytes v)[1] ++ (wlBytes v)[0] =
      v[0] := wlBytes_lane v 0 (by omega)

theorem wlBytes_lane1 (v : Wl) :
    (wlBytes v)[15] ++ (wlBytes v)[14] ++ (wlBytes v)[13] ++ (wlBytes v)[12] ++ (wlBytes v)[11] ++
          (wlBytes v)[10] ++ (wlBytes v)[9] ++ (wlBytes v)[8] =
      v[1] := wlBytes_lane v 1 (by omega)

theorem wlBytes_lane2 (v : Wl) :
    (wlBytes v)[23] ++ (wlBytes v)[22] ++ (wlBytes v)[21] ++ (wlBytes v)[20] ++ (wlBytes v)[19] ++
          (wlBytes v)[18] ++ (wlBytes v)[17] ++ (wlBytes v)[16] =
      v[2] := wlBytes_lane v 2 (by omega)

theorem wlBytes_lane3 (v : Wl) :
    (wlBytes v)[31] ++ (wlBytes v)[30] ++ (wlBytes v)[29] ++ (wlBytes v)[28] ++ (wlBytes v)[27] ++
          (wlBytes v)[26] ++ (wlBytes v)[25] ++ (wlBytes v)[24] =
      v[3] := wlBytes_lane v 3 (by omega)

/-- Lanes of a `wl_t` from its eight bytes, as the bytes of a stored `wl_t` read back give them. -/
theorem packLanes_bytes_lane0 (v : Wl) :
    (Ty.extractVecElem 32 8 7 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 6 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 5 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 4 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 3 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 2 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 1 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 0 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32))) = v[0] := by
  have e : ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 = x := by
    intro x; bv_decide
  simp only [Ty.extractVecElem_eq, Fin.isValue]
  change (BitVec.packLanes v).extractLsb' (7 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (6 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (5 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (4 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (3 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (2 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (1 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (0 * 8) 8 = v[0]
  rw [extractLsb'_packLanes_byte v (k := 7) (by omega),
    extractLsb'_packLanes_byte v (k := 6) (by omega),
    extractLsb'_packLanes_byte v (k := 5) (by omega),
    extractLsb'_packLanes_byte v (k := 4) (by omega),
    extractLsb'_packLanes_byte v (k := 3) (by omega),
    extractLsb'_packLanes_byte v (k := 2) (by omega),
    extractLsb'_packLanes_byte v (k := 1) (by omega),
    extractLsb'_packLanes_byte v (k := 0) (by omega)]
  simp only [Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul, e]

theorem packLanes_bytes_lane1 (v : Wl) :
    (Ty.extractVecElem 32 8 15 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 14 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 13 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 12 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 11 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 10 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 9 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 8 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32))) = v[1] := by
  have e : ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 = x := by
    intro x; bv_decide
  simp only [Ty.extractVecElem_eq, Fin.isValue]
  change (BitVec.packLanes v).extractLsb' (15 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (14 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (13 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (12 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (11 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (10 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (9 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (8 * 8) 8 = v[1]
  rw [extractLsb'_packLanes_byte v (k := 15) (by omega),
    extractLsb'_packLanes_byte v (k := 14) (by omega),
    extractLsb'_packLanes_byte v (k := 13) (by omega),
    extractLsb'_packLanes_byte v (k := 12) (by omega),
    extractLsb'_packLanes_byte v (k := 11) (by omega),
    extractLsb'_packLanes_byte v (k := 10) (by omega),
    extractLsb'_packLanes_byte v (k := 9) (by omega),
    extractLsb'_packLanes_byte v (k := 8) (by omega)]
  simp only [Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul, e]

theorem packLanes_bytes_lane2 (v : Wl) :
    (Ty.extractVecElem 32 8 23 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 22 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 21 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 20 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 19 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 18 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 17 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 16 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32))) = v[2] := by
  have e : ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 = x := by
    intro x; bv_decide
  simp only [Ty.extractVecElem_eq, Fin.isValue]
  change (BitVec.packLanes v).extractLsb' (23 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (22 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (21 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (20 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (19 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (18 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (17 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (16 * 8) 8 = v[2]
  rw [extractLsb'_packLanes_byte v (k := 23) (by omega),
    extractLsb'_packLanes_byte v (k := 22) (by omega),
    extractLsb'_packLanes_byte v (k := 21) (by omega),
    extractLsb'_packLanes_byte v (k := 20) (by omega),
    extractLsb'_packLanes_byte v (k := 19) (by omega),
    extractLsb'_packLanes_byte v (k := 18) (by omega),
    extractLsb'_packLanes_byte v (k := 17) (by omega),
    extractLsb'_packLanes_byte v (k := 16) (by omega)]
  simp only [Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul, e]

theorem packLanes_bytes_lane3 (v : Wl) :
    (Ty.extractVecElem 32 8 31 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 30 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 29 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 28 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 27 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 26 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 25 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32)) ++
      Ty.extractVecElem 32 8 24 ((BitVec.packLanes (we := 64) (n := 4) v :) : BitVec (8 * 32))) = v[3] := by
  have e : ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 = x := by
    intro x; bv_decide
  simp only [Ty.extractVecElem_eq, Fin.isValue]
  change (BitVec.packLanes v).extractLsb' (31 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (30 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (29 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (28 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (27 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (26 * 8) 8 ++
    (BitVec.packLanes v).extractLsb' (25 * 8) 8 ++ (BitVec.packLanes v).extractLsb' (24 * 8) 8 = v[3]
  rw [extractLsb'_packLanes_byte v (k := 31) (by omega),
    extractLsb'_packLanes_byte v (k := 30) (by omega),
    extractLsb'_packLanes_byte v (k := 29) (by omega),
    extractLsb'_packLanes_byte v (k := 28) (by omega),
    extractLsb'_packLanes_byte v (k := 27) (by omega),
    extractLsb'_packLanes_byte v (k := 26) (by omega),
    extractLsb'_packLanes_byte v (k := 25) (by omega),
    extractLsb'_packLanes_byte v (k := 24) (by omega)]
  simp only [Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul, e]

end

end MLIR.Firedancer.Crc.Ed25519

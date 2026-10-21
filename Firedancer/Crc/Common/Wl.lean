module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
import Std.Tactic.BVDecide

/-! The `<4 x i64>` instructions of crc's QUAD kernels that mlir-proofs' `VecRun` has no lemma for:
the lane-wise `mul` (the fold by 19 and 38 in 64-bit arithmetic) and the carry add whose operands
are the compiled way round, `shr` first. -/

namespace MLIR.Firedancer.Crc

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

end

end MLIR.Firedancer.Crc

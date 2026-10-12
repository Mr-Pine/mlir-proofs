module

public import MLIR.Run.Vector
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Lane-wise vector operations (the `u64x4`/`u32x8` arithmetic of dalek's `packed_simd`), and the
steps' vector instructions as them: `Vector.zipWith` of an operation on wrapped lanes, a flagged one
on lanes that do not overflow. -/

namespace MLIR.Agave

@[expose] public section

variable {w l : Nat}

/-- Lane-wise `+`. -/
def vadd (x y : Vector (BitVec w) l) : Vector (BitVec w) l :=
  Vector.ofFn fun i => x[i] + y[i]

/-- Lane-wise `*`. -/
def vmul (x y : Vector (BitVec w) l) : Vector (BitVec w) l :=
  Vector.ofFn fun i => x[i] * y[i]

/-- Lane-wise `&`. -/
def vand (x y : Vector (BitVec w) l) : Vector (BitVec w) l :=
  Vector.ofFn fun i => x[i] &&& y[i]

/-- `x + y₀ + y₁ + …` lane-wise, left to right: a sum in the code's order. -/
def vsum (x : Vector (BitVec w) l) (ys : List (Vector (BitVec w) l)) : Vector (BitVec w) l :=
  ys.foldl vadd x

/-- Each lane shifted right by `n`. -/
def vshr (x : Vector (BitVec w) l) (n : Nat) : Vector (BitVec w) l :=
  Vector.ofFn fun i => x[i] >>> n

/-- Each lane shifted left by `n`. -/
def vshl (x : Vector (BitVec w) l) (n : Nat) : Vector (BitVec w) l :=
  Vector.ofFn fun i => x[i] <<< n

@[simp]
theorem vadd_getElem (x y : Vector (BitVec w) l) (i : Nat) (h : i < l) :
    (vadd x y)[i] = x[i] + y[i] := by simp [vadd]

@[simp]
theorem vmul_getElem (x y : Vector (BitVec w) l) (i : Nat) (h : i < l) :
    (vmul x y)[i] = x[i] * y[i] := by simp [vmul]

@[simp]
theorem vand_getElem (x y : Vector (BitVec w) l) (i : Nat) (h : i < l) :
    (vand x y)[i] = x[i] &&& y[i] := by simp [vand]

@[simp]
theorem vshr_getElem (x : Vector (BitVec w) l) (n i : Nat) (h : i < l) :
    (vshr x n)[i] = x[i] >>> n := by simp [vshr]

@[simp]
theorem vshl_getElem (x : Vector (BitVec w) l) (n i : Nat) (h : i < l) :
    (vshl x n)[i] = x[i] <<< n := by simp [vshl]

/-! ### The vector instructions -/

theorem zipWith_and_vand (x y : Vector (BitVec w) l) :
    Vector.zipWith (Operation.and (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) y) =
      Ty.wrap (t := .vec l w) (vand x y) := by
  ext i hi
  simp [Ty.wrap_vec, vand, Operation.and]

theorem zipWith_add_vadd (x y : Vector (BitVec w) l) :
    Vector.zipWith (Operation.add {} (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) y) =
      Ty.wrap (t := .vec l w) (vadd x y) := by
  ext i hi
  simp [Ty.wrap_vec, vadd, Operation.add]

/-- `n < w` as a `w`-bit literal is `n`. -/
theorem toNat_ofNat_of_lt (hn : n < w) : (BitVec.ofNat w n).toNat = n := by
  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (Nat.lt_trans hn Nat.lt_two_pow_self)]

/-- A logical right shift by a splat below the width. -/
theorem zipWith_lshr_vshr (x : Vector (BitVec w) l) (hn : n < w) :
    Vector.zipWith (Operation.lshr false (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) (Vector.replicate l (BitVec.ofNat w n))) =
      Ty.wrap (t := .vec l w) (vshr x n) := by
  ext i hi
  simp [Ty.wrap_vec, vshr, Operation.lshr, toNat_ofNat_of_lt hn, Nat.not_le.mpr hn]

/-- A left shift by a splat below the width. -/
theorem zipWith_shl_vshl (x : Vector (BitVec w) l) (hn : n < w) :
    Vector.zipWith (Operation.shl {} (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) (Vector.replicate l (BitVec.ofNat w n))) =
      Ty.wrap (t := .vec l w) (vshl x n) := by
  ext i hi
  simp [Ty.wrap_vec, vshl, Operation.shl, toNat_ofNat_of_lt hn, Nat.not_le.mpr hn]

/-- `add nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_add_nsw_nuw (x y : Vector (BitVec w) l)
    (h : ∀ i : Fin l, x[i].saddOverflow y[i] = false ∧ x[i].uaddOverflow y[i] = false) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) y) =
      Ty.wrap (t := .vec l w) (vadd x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, vadd, Operation.add]

/-- `mul nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_mul_nsw_nuw (x y : Vector (BitVec w) l)
    (h : ∀ i : Fin l, x[i].smulOverflow y[i] = false ∧ x[i].umulOverflow y[i] = false) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) y) =
      Ty.wrap (t := .vec l w) (vmul x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, vmul, Operation.mul]

/-- `mul nuw` on lanes that do not overflow unsigned. -/
theorem zipWith_mul_nuw (x y : Vector (BitVec w) l)
    (h : ∀ i : Fin l, x[i].umulOverflow y[i] = false) :
    Vector.zipWith (Operation.mul { nuw := true } (w := w)) (Ty.wrap (t := .vec l w) x)
        (Ty.wrap (t := .vec l w) y) =
      Ty.wrap (t := .vec l w) (vmul x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, vmul, Operation.mul]

/-! ### `mul32`: products of lanes below `2 ^ 32` -/

/-- Each lane below `2 ^ 32`, as `mul32` reads a `u32x8`'s lane pairs. -/
def Small (x : Vector (BitVec 64) 4) : Prop :=
  ∀ i (h : i < 4), x[i].toNat < 2 ^ 32

/-- Lanes zero-extended from 32 bits (`unpack_pair`'s halves, as `u64x4`s). -/
theorem Small.zext {a b c d : BitVec 32} (h : x = #v[0#32 ++ a, 0#32 ++ b, 0#32 ++ c, 0#32 ++ d]) :
    Small x := by
  subst h
  intro i hi
  have (e : BitVec 32) : (0#32 ++ e).toNat < 2 ^ 32 := by
    rw [BitVec.toNat_append]; simp [e.isLt]
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals exact this _

/-- Lanes masked to their low 32 bits (`m_lo`'s result, as `mul32` reads it). -/
theorem Small.mask {y : Vector (BitVec 64) 4} (h : x = vand y (Vector.replicate 4 4294967295#64)) :
    Small x := by
  subst h
  intro i hi
  simp only [vand_getElem, Vector.getElem_replicate, BitVec.toNat_and]
  exact Nat.lt_of_le_of_lt Nat.and_le_right (by decide)

/-- `mul nuw` of lanes below `2 ^ 32`. -/
theorem zipWith_mul_nuw_small (hx : Small x) (hy : Small y) :
    Vector.zipWith (Operation.mul { nuw := true } (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (vmul x y) :=
  zipWith_mul_nuw _ _ fun i => by
    simp only [Fin.getElem_fin, BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le]
    calc
      x[i.1].toNat * y[i.1].toNat < 2 ^ 32 * 2 ^ 32 := Nat.mul_lt_mul'' (hx i.1 i.2) (hy i.1 i.2)
      _ = 2 ^ 64 := by rw [← Nat.pow_add]

/-- A lane below `2 ^ 32` times 19 overflows neither way. -/
theorem mul19_ok {x : BitVec 64} (h : x.toNat < 2 ^ 32) :
    x.smulOverflow 19#64 = false ∧ x.umulOverflow 19#64 = false := by
  have : x < 4294967296#64 := by
    rw [BitVec.lt_def]; simpa using h
  bv_decide

/-- `mul nsw nuw` by 19 of lanes below `2 ^ 32`. -/
theorem zipWith_mul19_small (hx : Small x) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) x) (Ty.wrap (t := .vec 4 64) (Vector.replicate 4 19#64)) =
      Ty.wrap (t := .vec 4 64) (vmul x (Vector.replicate 4 19#64)) :=
  zipWith_mul_nsw_nuw _ _ fun i => by
    simpa only [Fin.getElem_fin, Vector.getElem_replicate] using mul19_ok (hx i.1 i.2)

end

end MLIR.Agave

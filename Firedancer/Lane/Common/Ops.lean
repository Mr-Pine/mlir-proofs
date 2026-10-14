module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Fe
public import Firedancer.Avx512.Common.FoldUnsigned
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Mathlib.Data.BitVec
import Mathlib.Tactic.Ring

/-! The `<8 x i64>` instructions as the `wwl` operations they are, for the steps, and the field
operations of `fd_ed25519_lane.h` as LLVM compiles them: `x + x` as `x << 1`, the fold's
`r0 + 19 r5` as `vpmadd52luq(19 r5, a0, b0)`, a doubled degree times `19` as `38`, operands
commuted. The lanes are typed `⟦.vec 8 64⟧ᵣ`, as the steps' values are. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-! ### Lane-wise operations -/

theorem zipWith_add_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.add {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_add, Operation.add]

theorem zipWith_sub_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.sub {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_sub, Operation.sub]

theorem zipWith_and_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.and (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_and x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_and, Operation.and]

theorem zipWith_mul_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.mul {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_mul x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_mul, Operation.mul]

/-- A left shift by a splat below 64. -/
theorem zipWith_shl_wwl (x : ⟦.vec 8 64⟧ᵣ) (hn : n < 64) :
    Vector.zipWith (Operation.shl {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 (BitVec.ofNat 64 n))) =
      Ty.wrap (t := .vec 8 64) (wwl_shl x n) := by
  ext i hi
  have hn' : (BitVec.ofNat 64 n).toNat = n := by
    simp; omega
  simp [Ty.wrap_vec, wwl_shl, Operation.shl, hn', Nat.not_le.mpr hn]

/-- A logical right shift by a splat below 64. -/
theorem zipWith_lshr_wwl (x : ⟦.vec 8 64⟧ᵣ) (hn : n < 64) :
    Vector.zipWith (Operation.lshr false (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 (BitVec.ofNat 64 n))) =
      Ty.wrap (t := .vec 8 64) (wwl_shru x n) := by
  ext i hi
  have hn' : (BitVec.ofNat 64 n).toNat = n := by
    simp; omega
  simp [Ty.wrap_vec, wwl_shru, Operation.lshr, hn', Nat.not_le.mpr hn]

theorem vpmadd52l_wwl (a b c : ⟦.vec 8 64⟧ᵣ) :
    Operation.vpmadd52l (Ty.wrap (t := .vec 8 64) a) (Ty.wrap (t := .vec 8 64) b)
        (Ty.wrap (t := .vec 8 64) c) =
      Ty.wrap (t := .vec 8 64) (wwl_madd52lo a b c) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_madd52lo, madd52lo, Operation.vpmadd52l]

theorem vpmadd52h_wwl (a b c : ⟦.vec 8 64⟧ᵣ) :
    Operation.vpmadd52h (Ty.wrap (t := .vec 8 64) a) (Ty.wrap (t := .vec 8 64) b)
        (Ty.wrap (t := .vec 8 64) c) =
      Ty.wrap (t := .vec 8 64) (wwl_madd52hi a b c) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_madd52hi, madd52hi, Operation.vpmadd52h]

/-- `add nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_add_nsw_nuw_wwl (x y : ⟦.vec 8 64⟧ᵣ)
    (h : ∀ i : Fin 8, x[i].saddOverflow y[i] = false ∧ x[i].uaddOverflow y[i] = false) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) x) (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wwl_add, Operation.add]

/-! ### The carry's flagged adds -/

/-- Low 51 bits plus a carry above bit 51: no overflow either way. -/
theorem mask51_add_shr51 (a b : BitVec 64) :
    (a &&& 2251799813685247#64).saddOverflow (b >>> 51) = false ∧
      (a &&& 2251799813685247#64).uaddOverflow (b >>> 51) = false := by
  bv_decide

/-- `mask51_add_shr51`, the operands the other way round. -/
theorem shr51_add_mask51 (a b : BitVec 64) :
    (b >>> 51).saddOverflow (a &&& 2251799813685247#64) = false ∧
      (b >>> 51).uaddOverflow (a &&& 2251799813685247#64) = false := by
  bv_decide

/-- A carried limb plus a constant below `2^63 - 2^52`: no overflow either way. -/
theorem carried_add_lt (a b k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    ((a &&& 2251799813685247#64) + (b >>> 51)).saddOverflow k = false ∧
      ((a &&& 2251799813685247#64) + (b >>> 51)).uaddOverflow k = false := by
  bv_decide

/-- `fd_ed25519_lane_carry`'s `wwv_add( wwv_and( r, mask ), c )`, an `add nsw nuw`. -/
@[simp]
theorem zipWith_add_mask_shru (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_and x (Vector.replicate 8 2251799813685247#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_shru y 51)) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64)) (wwl_shru y 51)) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by simpa [wwl_and, wwl_shru] using mask51_add_shr51 x[i] y[i]

/-- `zipWith_add_mask_shru`, the operands the other way round. -/
@[simp]
theorem zipWith_add_shru_mask (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru y 51))
        (Ty.wrap (t := .vec 8 64) (wwl_and x (Vector.replicate 8 2251799813685247#64))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_shru y 51) (wwl_and x (Vector.replicate 8 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by simpa [wwl_and, wwl_shru] using shr51_add_mask51 x[i] y[i]

/-- A carried limb plus a constant below `2^63 - 2^52`, an `add nsw nuw`. -/
theorem zipWith_add_carried_lt (x y : Wwl) (k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64)
          (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64)) (wwl_shru y 51)))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 k)) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64)) (wwl_shru y 51))
          (Vector.replicate 8 k)) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simpa [wwl_and, wwl_shru, wwl_add] using carried_add_lt x[i] y[i] k hk

/-- A carried limb plus a constant below `2^63 - 2^52`, an `add nsw nuw`: limb 1 of `carry X`. -/
@[simp]
theorem zipWith_add_carry_l1 (X : Fe) (k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (carry X).l1) (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 k)) =
      Ty.wrap (t := .vec 8 64) (wwl_add (carry X).l1 (Vector.replicate 8 k)) :=
  zipWith_add_carried_lt _ _ k hk

/-- `zipWith_add_carry_l1` for limb 2. -/
@[simp]
theorem zipWith_add_carry_l2 (X : Fe) (k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (carry X).l2) (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 k)) =
      Ty.wrap (t := .vec 8 64) (wwl_add (carry X).l2 (Vector.replicate 8 k)) :=
  zipWith_add_carried_lt _ _ k hk

/-- `zipWith_add_carry_l1` for limb 3. -/
@[simp]
theorem zipWith_add_carry_l3 (X : Fe) (k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (carry X).l3) (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 k)) =
      Ty.wrap (t := .vec 8 64) (wwl_add (carry X).l3 (Vector.replicate 8 k)) :=
  zipWith_add_carried_lt _ _ k hk

/-- `zipWith_add_carry_l1` for limb 4. -/
@[simp]
theorem zipWith_add_carry_l4 (X : Fe) (k : BitVec 64) (hk : k < 0x7FF0000000000000#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (carry X).l4) (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 k)) =
      Ty.wrap (t := .vec 8 64) (wwl_add (carry X).l4 (Vector.replicate 8 k)) :=
  zipWith_add_carried_lt _ _ k hk

/-! ### Lanes -/

theorem shl_one_eq (x : BitVec 64) : x <<< 1 = 2 * x := by bv_decide

theorem shl_two_eq (x : BitVec 64) : x <<< 2 = 4 * x := by bv_decide

set_option hygiene false in
/-- A `Wwl` equation of lane-wise operations, lane by lane as a ring identity with the `madd52`
lanes as atoms. -/
macro "wwl_ring" : tactic =>
  `(tactic|
    ( apply Vector.ext
      intro i hi
      simp only [wwl_add, wwl_sub, wwl_mul, wwl_shl, wwl_madd52lo, wwl_madd52hi, wwl_bcast,
        Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_replicate, shl_one_eq, shl_two_eq,
        ← BitVec.ofNat_eq_ofNat]
      ring))

theorem wwl_add_comm (a b : Wwl) : wwl_add a b = wwl_add b a := by wwl_ring

/-! ### Constants -/

/-- `2^11 p` limbwise, as the compiled constants. -/
theorem bigP_11 : bigP 11 = Fe.bcast2 4611686018427348992#64 4611686018427385856#64 := by
  simp only [bigP, Fe.bcast2, Fe.mk.injEq]
  decide

/-- `2^12 p` limbwise, as the compiled constants. -/
theorem bigP_12 : bigP 12 = Fe.bcast2 9223372036854697984#64 9223372036854771712#64 := by
  simp only [bigP, Fe.bcast2, Fe.mk.injEq]
  decide

/-! ### The field operations as compiled -/

/-- `fd_ed25519_lane_sqr_( r, a, 0 )` as compiled. -/
theorem sqr_compiled (A0 A1 A2 A3 A4 : Wwl) :
    sqr ⟨A0, A1, A2, A3, A4⟩ false =
      ⟨(wwl_madd52lo
          (wwl_mul
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52hi
                  (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 A4) A1 A3) 1) A2
                  A2)
                A1 A4)
              A2 A3)
            (Vector.replicate 8 38#64))
          A0 A0),
        (wwl_add
          (wwl_mul
            (wwl_madd52lo
              (wwl_shl
                (wwl_madd52lo
                  (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A1 A4) A2 A3) 1) A2
                  A4)
                1)
              A3 A3)
            (Vector.replicate 8 19#64))
          (wwl_shl (wwl_madd52lo (wwl_madd52hi (Vector.replicate 8 0#64) A0 A0) A0 A1) 1)),
        (wwl_add
          (wwl_mul
            (wwl_madd52lo
              (wwl_madd52hi (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) A2 A4) 1) A3 A3) A3 A4)
            (Vector.replicate 8 38#64))
          (wwl_madd52lo
            (wwl_shl (wwl_madd52lo (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) A0 A1) 1) A0 A2)
              1)
            A1 A1)),
        (wwl_add
          (wwl_mul (wwl_madd52lo (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) A3 A4) 2) A4 A4)
            (Vector.replicate 8 19#64))
          (wwl_shl
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52hi (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) A0 A2) 1) A1 A1) A0
                A3)
              A1 A2)
            1)),
        (wwl_add (wwl_mul (wwl_madd52hi (Vector.replicate 8 0#64) A4 A4) (Vector.replicate 8 38#64))
          (wwl_madd52lo
            (wwl_shl
              (wwl_madd52lo
                (wwl_madd52lo
                  (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 A3) A1 A2) 1) A0
                  A4)
                A1 A3)
              1)
            A2 A2))⟩ := by
  simp only [sqr, fold, dbl2, Bool.false_eq_true, ↓reduceIte, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> wwl_ring

/-- `fd_ed25519_lane_mul_( r, a, b, 0 )` as compiled. -/
theorem mul_compiled (A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 : Wwl) :
    mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false =
      ⟨(wwl_madd52lo
          (wwl_mul
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52lo
                  (wwl_madd52lo
                    (wwl_shl
                      (wwl_madd52hi
                        (wwl_madd52hi
                          (wwl_madd52hi
                            (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 B4) A1 B3) A2
                            B2)
                          A3 B1)
                        A4 B0)
                      1)
                    A1 B4)
                  A2 B3)
                A3 B2)
              A4 B1)
            (Vector.replicate 8 19#64))
          A0 B0),
        (wwl_add
          (wwl_mul
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52lo
                  (wwl_shl
                    (wwl_madd52hi
                      (wwl_madd52hi
                        (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A1 B4) A2 B3) A3 B2)
                      A4 B1)
                    1)
                  A2 B4)
                A3 B3)
              A4 B2)
            (Vector.replicate 8 19#64))
          (wwl_madd52lo
            (wwl_madd52lo (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) A0 B0) 1) A0 B1) A1 B0)),
        (wwl_add
          (wwl_mul
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_shl
                  (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A2 B4) A3 B3)
                    A4 B2)
                  1)
                A3 B4)
              A4 B3)
            (Vector.replicate 8 19#64))
          (wwl_madd52lo
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 B1) A1 B0) 1) A0
                B2)
              A1 B1)
            A2 B0)),
        (wwl_add
          (wwl_mul
            (wwl_madd52lo
              (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A3 B4) A4 B3) 1) A4 B4)
            (Vector.replicate 8 19#64))
          (wwl_madd52lo
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52lo
                  (wwl_shl
                    (wwl_madd52hi
                      (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 B2) A1 B1) A2 B0)
                    1)
                  A0 B3)
                A1 B2)
              A2 B1)
            A3 B0)),
        (wwl_add (wwl_mul (wwl_madd52hi (Vector.replicate 8 0#64) A4 B4) (Vector.replicate 8 38#64))
          (wwl_madd52lo
            (wwl_madd52lo
              (wwl_madd52lo
                (wwl_madd52lo
                  (wwl_madd52lo
                    (wwl_shl
                      (wwl_madd52hi
                        (wwl_madd52hi
                          (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) A0 B3) A1 B2) A2 B1)
                        A3 B0)
                      1)
                    A0 B4)
                  A1 B3)
                A2 B2)
              A3 B1)
            A4 B0))⟩ := by
  simp only [mul, fold, dbl2, Bool.false_eq_true, ↓reduceIte, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> wwl_ring

/-- A carried product is the carried loose one. -/
theorem mul_eq_carry (a b : Fe) : mul a b = carry (mul a b false) := by
  simp only [mul, fold, ↓reduceIte, Bool.false_eq_true]

/-- A carried square is the carried loose one. -/
theorem sqr_eq_carry (a : Fe) : sqr a = carry (sqr a false) := by
  simp only [sqr, fold, ↓reduceIte, Bool.false_eq_true]

/-- `fd_ed25519_lane_carry` as compiled. -/
theorem carry_compiled (R : Fe) :
    carry R =
      ⟨wwl_madd52lo (wwl_and R.l0 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l4 51)
          (Vector.replicate 8 19#64),
        wwl_add (wwl_and R.l1 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l0 51),
        wwl_add (wwl_and R.l2 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l1 51),
        wwl_add (wwl_and R.l3 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l2 51),
        wwl_add (wwl_and R.l4 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l3 51)⟩ :=
  rfl

/-- `carry_compiled` with limb 1's add commuted, as the products' carries are compiled. -/
theorem carry_compiled' (R : Fe) :
    carry R =
      ⟨wwl_madd52lo (wwl_and R.l0 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l4 51)
          (Vector.replicate 8 19#64),
        wwl_add (wwl_shru R.l0 51) (wwl_and R.l1 (Vector.replicate 8 2251799813685247#64)),
        wwl_add (wwl_and R.l2 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l1 51),
        wwl_add (wwl_and R.l3 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l2 51),
        wwl_add (wwl_and R.l4 (Vector.replicate 8 2251799813685247#64)) (wwl_shru R.l3 51)⟩ := by
  rw [carry_compiled, wwl_add_comm (wwl_and R.l1 _)]

end

end MLIR.Firedancer.Lane

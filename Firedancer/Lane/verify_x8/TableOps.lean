module

public import Firedancer.Lane.Common.Ops
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Point
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The lane operations of `fd_ed25519_lane_to_niels` as `verify_x8` compiles it: `2p - k`'s flagged
subtractions, and the table form from the values the code computes. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

/-- `sub nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_sub_nsw_nuw_wwl (x y : ⟦.vec 8 64⟧ᵣ)
    (h : ∀ i : Fin 8, x[i].ssubOverflow y[i] = false ∧ x[i].usubOverflow y[i] = false) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) x) (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wwl_sub, Operation.sub]

/-- `2^52 - 2` less a carried limb above limb 0: no overflow either way. -/
theorem sub_2p_carried (a b : BitVec 64) :
    (4503599627370494#64).ssubOverflow ((a &&& 2251799813685247#64) + (b >>> 51)) = false ∧
      (4503599627370494#64).usubOverflow ((a &&& 2251799813685247#64) + (b >>> 51)) = false := by
  bv_decide

/-- `2^52 - 2` less a carried limb, an `sub nsw nuw`. -/
theorem zipWith_sub_2p_carried (x y : Wwl) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64)
          (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64)) (wwl_shru y 51))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_sub (Vector.replicate 8 4503599627370494#64)
          (wwl_add (wwl_and x (Vector.replicate 8 2251799813685247#64)) (wwl_shru y 51))) :=
  zipWith_sub_nsw_nuw_wwl _ _ fun i => by
    simpa [wwl_and, wwl_shru, wwl_add] using sub_2p_carried x[i] y[i]

/-- `zipWith_sub_2p_carried` for limb 1 of a product. -/
theorem zipWith_sub_2p_mul_l1 (A B : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (mul A B).l1) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (mul A B).l1) := by
  rw [mul_eq_carry]
  exact zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 2 of a product. -/
theorem zipWith_sub_2p_mul_l2 (A B : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (mul A B).l2) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (mul A B).l2) := by
  rw [mul_eq_carry]
  exact zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 3 of a product. -/
theorem zipWith_sub_2p_mul_l3 (A B : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (mul A B).l3) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (mul A B).l3) := by
  rw [mul_eq_carry]
  exact zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 4 of a product. -/
theorem zipWith_sub_2p_mul_l4 (A B : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (mul A B).l4) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (mul A B).l4) := by
  rw [mul_eq_carry]
  exact zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 1 of a carry. -/
theorem zipWith_sub_2p_carry_l1 (X : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (carry X).l1) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (carry X).l1) :=
  zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 2 of a carry. -/
theorem zipWith_sub_2p_carry_l2 (X : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (carry X).l2) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (carry X).l2) :=
  zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 3 of a carry. -/
theorem zipWith_sub_2p_carry_l3 (X : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (carry X).l3) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (carry X).l3) :=
  zipWith_sub_2p_carried _ _

/-- `zipWith_sub_2p_carried` for limb 4 of a carry. -/
theorem zipWith_sub_2p_carry_l4 (X : Fe) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) (carry X).l4) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) (carry X).l4) :=
  zipWith_sub_2p_carried _ _

/-- `fd_ed25519_lane_to_niels` as compiled: `x + y`'s limbs added `x` first, `y + 4p - x` with
`4p` as two splats, `2p - k` with `2p` as two splats. -/
def nielsC (P : Point) (K : Fe) : Niels :=
  ⟨carry ⟨wwl_add P.x.l0 P.y.l0, wwl_add P.x.l1 P.y.l1, wwl_add P.x.l2 P.y.l2,
      wwl_add P.x.l3 P.y.l3, wwl_add P.x.l4 P.y.l4⟩,
    carry ⟨wwl_sub (wwl_add P.y.l0 (Vector.replicate 8 9007199254740916#64)) P.x.l0,
      wwl_sub (wwl_add P.y.l1 (Vector.replicate 8 9007199254740988#64)) P.x.l1,
      wwl_sub (wwl_add P.y.l2 (Vector.replicate 8 9007199254740988#64)) P.x.l2,
      wwl_sub (wwl_add P.y.l3 (Vector.replicate 8 9007199254740988#64)) P.x.l3,
      wwl_sub (wwl_add P.y.l4 (Vector.replicate 8 9007199254740988#64)) P.x.l4⟩,
    mul P.t K,
    ⟨wwl_sub (Vector.replicate 8 4503599627370458#64) (mul P.t K).l0,
      wwl_sub (Vector.replicate 8 4503599627370494#64) (mul P.t K).l1,
      wwl_sub (Vector.replicate 8 4503599627370494#64) (mul P.t K).l2,
      wwl_sub (Vector.replicate 8 4503599627370494#64) (mul P.t K).l3,
      wwl_sub (Vector.replicate 8 4503599627370494#64) (mul P.t K).l4⟩,
    P.z⟩

/-- The compiled table form is `Point.toNiels`. -/
theorem nielsC_eq (P : Point) (K : Fe) : nielsC P K = P.toNiels K := by
  simp only [nielsC, Point.toNiels, Lane.add, addRaw, sub, subOff, neg, twoP, Fe.bcast2,
    wwl_bcast, Fe.zipWith, wwl_add_comm P.x.l0, wwl_add_comm P.x.l1, wwl_add_comm P.x.l2,
    wwl_add_comm P.x.l3, wwl_add_comm P.x.l4]
  rfl




attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-- `fd_ed25519_lane_carry( r )` as the products' carries compile it, 15 instructions: `carryRun`
with limb 1's add commuted (`carry_compiled'`). -/
def carryRun' (k51 km k19 x0 x1 x2 x3 x4 : Dst Γ V)
    (t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) t0 (.val x0.i x0.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t1 (.val x1.i x1.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t2 (.val x2.i x2.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t3 (.val x3.i x3.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t4 (.val x4.i x4.h) (.val k51.i k51.h),
    .binop (.vector .and) t5 (.val x0.i x0.h) (.val km.i km.h),
    .ternop .vpmadd52l d0 (.val t5.i t5.h) (.val t4.i t4.h) (.val k19.i k19.h),
    .binop (.vector .and) t7 (.val x1.i x1.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val t0.i t0.h) (.val t7.i t7.h),
    .binop (.vector .and) t9 (.val x2.i x2.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val t9.i t9.h) (.val t1.i t1.h),
    .binop (.vector .and) t11 (.val x3.i x3.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val t11.i t11.h) (.val t2.i t2.h),
    .binop (.vector .and) t13 (.val x4.i x4.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val t13.i t13.h) (.val t3.i t3.h)]

/-- Where the body at `pos` is `carryRun'` and `x0 … x4` hold `X`: running on from `pos` gives `K`
if it does from `pos + 15` with `carry X` in `d0 … d4`. -/
theorem runBodyFrom_carryRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {k51 km k19 x0 x1 x2 x3 x4 t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        carryRun' k51 km k19 x0 x1 x2 x3 x4 t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 ++ rest)
    (hR :
      E ⊨ [k51 := Vector.replicate 8 51#64, km := Vector.replicate 8 2251799813685247#64, k19 :=
        Vector.replicate 8 19#64, x0 := X0, x1 := X1, x2 := X2, x3 := X3, x4 := X4])
    (hd :
      [k51.i, km.i, k19.i, x0.i, x1.i, x2.i, x3.i, x4.i, t0.i, t1.i, t2.i, t3.i, t4.i, t5.i, d0.i,
          t7.i, d1.i, t9.i, d2.i, t11.i, d3.i, t13.i, d4.i].Nodup)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t7 v_t9 v_t11 v_t13 : ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, d0 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l0, t7 := v_t7, d1 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l1, t9 := v_t9, d2 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l2, t11 := v_t11, d3 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l3, t13 := v_t13, d4 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l4]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  rw [hE]
  rw [carry_compiled'] at hK
  exact hK _ _ _ _ _ _ _ _ _ _



end

end MLIR.Firedancer.Lane.VerifyX8

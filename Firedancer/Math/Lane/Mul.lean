module

public import Firedancer.Math.Lane.Fe
import Firedancer.Math.Avx512.Mul
import Firedancer.Math.R52x5.Mul
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-! `fd_ed25519_lane_mul_` and `fd_ed25519_lane_sqr_` in `ZMod p`: per lane, the products' 52-bit
halves summed by radix-`2^51` columns (`R52x5.mcol`, `R52x5.scol`), then folded by `19`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p)
open Firedancer.Avx512
open Firedancer.R52x5 (limbs5 mcol scol mul_core sqr_core cast_of_core madd52hi_lt52)
open Firedancer.Avx512.R43x6 (madd52lo_lt madd52_split)
open Fin.NatCast
-- the limb `simp` sets are shared by all limbs, each using part of them
set_option linter.unusedSimpArgs false

/-! ## Columns -/

/-- `madd52lo` of lane `j`'s limbs `k` of `a` and `m` of `b`. -/
def lmul (a b : Fe) (j : Fin 8) (k m : ℕ) : ℕ :=
  (madd52lo (a.lane j (k : Fin 5)) (b.lane j (m : Fin 5))).toNat

/-- `madd52hi` of lane `j`'s limbs `k` of `a` and `m` of `b`. -/
def hmul (a b : Fe) (j : Fin 8) (k m : ℕ) : ℕ :=
  (madd52hi (a.lane j (k : Fin 5)) (b.lane j (m : Fin 5))).toNat

/-- `madd52lo` of lane `j`'s limbs `k` and `m` of `a`. -/
def lsqr (a : Fe) (j : Fin 8) (k m : ℕ) : ℕ :=
  lmul a a j k m

/-- `madd52hi` of lane `j`'s limbs `k` and `m` of `a`. -/
def hsqr (a : Fe) (j : Fin 8) (k m : ℕ) : ℕ :=
  hmul a a j k m

/-- A folded product column pair of `B`-bounded halves: at most `267 B`. -/
theorem mcol_le {L H : ℕ → ℕ → ℕ} {B : ℕ} (hL : ∀ k m, L k m ≤ B) (hH : ∀ k m, H k m ≤ B)
    {d : ℕ} (hd : d < 5) : mcol L H d + 19 * mcol L H (d + 5) ≤ 267 * B := by
  have := hL 0 0; have := hH 0 0; have := hL 0 1; have := hH 0 1; have := hL 0 2; have := hH 0 2
  have := hL 0 3; have := hH 0 3; have := hL 0 4; have := hH 0 4; have := hL 1 0; have := hH 1 0
  have := hL 1 1; have := hH 1 1; have := hL 1 2; have := hH 1 2; have := hL 1 3; have := hH 1 3
  have := hL 1 4; have := hH 1 4; have := hL 2 0; have := hH 2 0; have := hL 2 1; have := hH 2 1
  have := hL 2 2; have := hH 2 2; have := hL 2 3; have := hH 2 3; have := hL 2 4; have := hH 2 4
  have := hL 3 0; have := hH 3 0; have := hL 3 1; have := hH 3 1; have := hL 3 2; have := hH 3 2
  have := hL 3 3; have := hH 3 3; have := hL 3 4; have := hH 3 4; have := hL 4 0; have := hH 4 0
  have := hL 4 1; have := hH 4 1; have := hL 4 2; have := hH 4 2; have := hL 4 3; have := hH 4 3
  have := hL 4 4; have := hH 4 4
  obtain rfl | rfl | rfl | rfl | rfl : d = 0 ∨ d = 1 ∨ d = 2 ∨ d = 3 ∨ d = 4 := by omega
  all_goals simp only [mcol, Nat.reduceAdd]; omega

/-- A folded square column pair of `B`-bounded halves: at most `267 B`. -/
theorem scol_le {L H : ℕ → ℕ → ℕ} {B : ℕ} (hL : ∀ k m, L k m ≤ B) (hH : ∀ k m, H k m ≤ B)
    {d : ℕ} (hd : d < 5) : scol L H d + 19 * scol L H (d + 5) ≤ 267 * B := by
  have := hL 0 0; have := hH 0 0; have := hL 0 1; have := hH 0 1; have := hL 0 2; have := hH 0 2
  have := hL 0 3; have := hH 0 3; have := hL 0 4; have := hH 0 4; have := hL 1 1; have := hH 1 1
  have := hL 1 2; have := hH 1 2; have := hL 1 3; have := hH 1 3; have := hL 1 4; have := hH 1 4
  have := hL 2 2; have := hH 2 2; have := hL 2 3; have := hH 2 3; have := hL 2 4; have := hH 2 4
  have := hL 3 3; have := hH 3 3; have := hL 3 4; have := hH 3 4; have := hL 4 4; have := hH 4 4
  obtain rfl | rfl | rfl | rfl | rfl : d = 0 ∨ d = 1 ∨ d = 2 ∨ d = 3 ∨ d = 4 := by omega
  all_goals simp only [scol, Nat.reduceAdd]; omega

/-- `F52` limbs, `ℕ`-indexed. -/
theorem F52.lt {a : Fe} (h : a.F52) (j : Fin 8) (k : ℕ) :
    (a.lane j (k : Fin 5)).toNat < 2 ^ 52 := by
  have := h j k
  dsimp only at this
  omega

/-! ## Limbs -/

/-- Both `madd52` halves of 52-bit operands are below `2^52`. -/
theorem madd52_lt {x y : BitVec 64} (hx : x.toNat < 2 ^ 52) (hy : y.toNat < 2 ^ 52) :
    (madd52lo x y).toNat < 2 ^ 52 ∧ (madd52hi x y).toNat < 2 ^ 52 :=
  ⟨madd52lo_lt x y, madd52hi_lt52 hx hy⟩

/-- The bounds `omega` needs on lane `j` of `a b` and their `madd52` halves. -/
local macro "mul_bounds" a:ident b:ident j:ident ha:ident hb:ident : tactic =>
  `(tactic|
    ( have ha' := fun i => (Nat.lt_of_le_of_lt ($ha $j i) (by norm_num) : _ < 2 ^ 52)
      have hb' := fun i => (Nat.lt_of_le_of_lt ($hb $j i) (by norm_num) : _ < 2 ^ 52)
      have ba0 : ((Fe.l0 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 0
      have bb0 : ((Fe.l0 $b)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := hb' 0
      have ba1 : ((Fe.l1 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 1
      have bb1 : ((Fe.l1 $b)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := hb' 1
      have ba2 : ((Fe.l2 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 2
      have bb2 : ((Fe.l2 $b)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := hb' 2
      have ba3 : ((Fe.l3 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 3
      have bb3 : ((Fe.l3 $b)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := hb' 3
      have ba4 : ((Fe.l4 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 4
      have bb4 : ((Fe.l4 $b)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := hb' 4
      have := madd52_lt ba0 bb0
      have := madd52_lt ba0 bb1
      have := madd52_lt ba0 bb2
      have := madd52_lt ba0 bb3
      have := madd52_lt ba0 bb4
      have := madd52_lt ba1 bb0
      have := madd52_lt ba1 bb1
      have := madd52_lt ba1 bb2
      have := madd52_lt ba1 bb3
      have := madd52_lt ba1 bb4
      have := madd52_lt ba2 bb0
      have := madd52_lt ba2 bb1
      have := madd52_lt ba2 bb2
      have := madd52_lt ba2 bb3
      have := madd52_lt ba2 bb4
      have := madd52_lt ba3 bb0
      have := madd52_lt ba3 bb1
      have := madd52_lt ba3 bb2
      have := madd52_lt ba3 bb3
      have := madd52_lt ba3 bb4
      have := madd52_lt ba4 bb0
      have := madd52_lt ba4 bb1
      have := madd52_lt ba4 bb2
      have := madd52_lt ba4 bb3
      have := madd52_lt ba4 bb4
      clear ha' hb'))

/-- A limb of `mul _ _ false` as its columns: lane operations, `toNat` without overflow, `ring`. -/
local macro "mul_limb" : tactic =>
  `(tactic|
    ( simp only [Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four, mul, fold,
        dbl2, Bool.false_eq_true, ↓reduceIte, getElem_wwl_add, getElem_wwl_mul,
        getElem_wwl_madd52lo, getElem_wwl_madd52hi, getElem_wwl_bcast, getElem_wwl_zero]
      simp only [mcol, lmul, hmul, Nat.cast_ofNat, Nat.cast_zero, Nat.cast_one, Fe.lane_zero,
        Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four, BitVec.toNat_add, BitVec.toNat_mul,
        show (19 : BitVec 64).toNat = 19 from rfl, show (0 : BitVec 64).toNat = 0 from rfl,
        Nat.zero_add]
      simp (disch := omega) only [Nat.mod_eq_of_lt]
      ring))

theorem mul_limb0 {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    ((mul a b false).lane j 0).toNat =
      mcol (lmul a b j) (hmul a b j) 0 + 19 * mcol (lmul a b j) (hmul a b j) 5 := by
  mul_bounds a b j ha hb
  clear ha hb
  mul_limb

theorem mul_limb1 {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    ((mul a b false).lane j 1).toNat =
      mcol (lmul a b j) (hmul a b j) 1 + 19 * mcol (lmul a b j) (hmul a b j) 6 := by
  mul_bounds a b j ha hb
  clear ha hb
  mul_limb

theorem mul_limb2 {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    ((mul a b false).lane j 2).toNat =
      mcol (lmul a b j) (hmul a b j) 2 + 19 * mcol (lmul a b j) (hmul a b j) 7 := by
  mul_bounds a b j ha hb
  clear ha hb
  mul_limb

theorem mul_limb3 {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    ((mul a b false).lane j 3).toNat =
      mcol (lmul a b j) (hmul a b j) 3 + 19 * mcol (lmul a b j) (hmul a b j) 8 := by
  mul_bounds a b j ha hb
  clear ha hb
  mul_limb

theorem mul_limb4 {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    ((mul a b false).lane j 4).toNat =
      mcol (lmul a b j) (hmul a b j) 4 + 19 * mcol (lmul a b j) (hmul a b j) 9 := by
  mul_bounds a b j ha hb
  clear ha hb
  mul_limb

/-- The bounds `omega` needs on lane `j` of `a` and its `madd52` halves. -/
local macro "sqr_bounds" a:ident j:ident ha:ident : tactic =>
  `(tactic|
    ( have ha' := fun i => (Nat.lt_of_le_of_lt ($ha $j i) (by norm_num) : _ < 2 ^ 52)
      have ba0 : ((Fe.l0 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 0
      have ba1 : ((Fe.l1 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 1
      have ba2 : ((Fe.l2 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 2
      have ba3 : ((Fe.l3 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 3
      have ba4 : ((Fe.l4 $a)[($j : ℕ)]'($j).isLt).toNat < 2 ^ 52 := ha' 4
      have := madd52_lt ba0 ba0
      have := madd52_lt ba0 ba1
      have := madd52_lt ba0 ba2
      have := madd52_lt ba0 ba3
      have := madd52_lt ba0 ba4
      have := madd52_lt ba1 ba1
      have := madd52_lt ba1 ba2
      have := madd52_lt ba1 ba3
      have := madd52_lt ba1 ba4
      have := madd52_lt ba2 ba2
      have := madd52_lt ba2 ba3
      have := madd52_lt ba2 ba4
      have := madd52_lt ba3 ba3
      have := madd52_lt ba3 ba4
      have := madd52_lt ba4 ba4
      clear ha'))

/-- A limb of `sqr _ false` as its columns: lane operations, `toNat` without overflow, `ring`. -/
local macro "sqr_limb" : tactic =>
  `(tactic|
    ( simp only [Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four, sqr, fold,
        dbl2, Bool.false_eq_true, ↓reduceIte, getElem_wwl_add, getElem_wwl_mul,
        getElem_wwl_madd52lo, getElem_wwl_madd52hi, getElem_wwl_bcast, getElem_wwl_zero]
      simp only [scol, lsqr, hsqr, lmul, hmul, Nat.cast_ofNat, Nat.cast_zero, Nat.cast_one,
        Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four, BitVec.toNat_add,
        BitVec.toNat_mul, show (19 : BitVec 64).toNat = 19 from rfl,
        show (0 : BitVec 64).toNat = 0 from rfl, Nat.zero_add]
      simp (disch := omega) only [Nat.mod_eq_of_lt]
      ring))

theorem sqr_limb0 {a : Fe} (ha : a.F52) (j : Fin 8) :
    ((sqr a false).lane j 0).toNat =
      scol (lsqr a j) (hsqr a j) 0 + 19 * scol (lsqr a j) (hsqr a j) 5 := by
  sqr_bounds a j ha
  clear ha
  sqr_limb

theorem sqr_limb1 {a : Fe} (ha : a.F52) (j : Fin 8) :
    ((sqr a false).lane j 1).toNat =
      scol (lsqr a j) (hsqr a j) 1 + 19 * scol (lsqr a j) (hsqr a j) 6 := by
  sqr_bounds a j ha
  clear ha
  sqr_limb

theorem sqr_limb2 {a : Fe} (ha : a.F52) (j : Fin 8) :
    ((sqr a false).lane j 2).toNat =
      scol (lsqr a j) (hsqr a j) 2 + 19 * scol (lsqr a j) (hsqr a j) 7 := by
  sqr_bounds a j ha
  clear ha
  sqr_limb

theorem sqr_limb3 {a : Fe} (ha : a.F52) (j : Fin 8) :
    ((sqr a false).lane j 3).toNat =
      scol (lsqr a j) (hsqr a j) 3 + 19 * scol (lsqr a j) (hsqr a j) 8 := by
  sqr_bounds a j ha
  clear ha
  sqr_limb

theorem sqr_limb4 {a : Fe} (ha : a.F52) (j : Fin 8) :
    ((sqr a false).lane j 4).toNat =
      scol (lsqr a j) (hsqr a j) 4 + 19 * scol (lsqr a j) (hsqr a j) 9 := by
  sqr_bounds a j ha
  clear ha
  sqr_limb

/-! ## Products -/

theorem limbs5_lane (a : Fe) (j : Fin 8) :
    limbs5 (fun k => (a.lane j (k : Fin 5)).toNat) = Ed25519.Limbs.nat (a.lane j) := by
  simp only [limbs5, Ed25519.Limbs.nat, Nat.cast_ofNat, Nat.cast_zero, Nat.cast_one]

theorem mul_true (a b : Fe) : mul a b = carry (mul a b false) := rfl

theorem sqr_true (a : Fe) : sqr a = carry (sqr a false) := rfl

theorem mul_val_false {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    (mul a b false).val j = a.val j * b.val j := by
  have hz : Ed25519.Limbs.nat ((mul a b false).lane j) =
      limbs5 fun n =>
        mcol (lmul a b j) (hmul a b j) n + 19 * mcol (lmul a b j) (hmul a b j) (n + 5) := by
    simp only [Ed25519.Limbs.nat, limbs5, mul_limb0 ha hb, mul_limb1 ha hb, mul_limb2 ha hb,
      mul_limb3 ha hb, mul_limb4 ha hb, Nat.reduceAdd]
  rw [Fe.val, Ed25519.Limbs.val_nat, hz,
    cast_of_core (mul_core (L := lmul a b j) (H := hmul a b j)
      (X := fun k => (a.lane j (k : Fin 5)).toNat) (Y := fun m => (b.lane j (m : Fin 5)).toNat)
      fun k m _ _ => madd52_split (F52.lt ha j k) (F52.lt hb j m)),
    limbs5_lane, limbs5_lane, Nat.cast_mul, ← Ed25519.Limbs.val_nat, ← Ed25519.Limbs.val_nat]

theorem sqr_val_false {a : Fe} (ha : a.F52) (j : Fin 8) : (sqr a false).val j = a.val j ^ 2 := by
  have hz : Ed25519.Limbs.nat ((sqr a false).lane j) =
      limbs5 fun n => scol (lsqr a j) (hsqr a j) n + 19 * scol (lsqr a j) (hsqr a j) (n + 5) := by
    simp only [Ed25519.Limbs.nat, limbs5, sqr_limb0 ha, sqr_limb1 ha, sqr_limb2 ha, sqr_limb3 ha,
      sqr_limb4 ha, Nat.reduceAdd]
  rw [Fe.val, Ed25519.Limbs.val_nat, hz,
    cast_of_core (sqr_core (L := lsqr a j) (H := hsqr a j)
      (X := fun k => (a.lane j (k : Fin 5)).toNat)
      fun k m _ _ => madd52_split (F52.lt ha j k) (F52.lt ha j m)),
    limbs5_lane, Nat.cast_mul, ← Ed25519.Limbs.val_nat, sq]

public theorem mul_val {a b : Fe} (ha : a.F52) (hb : b.F52) (c : Bool) (j : Fin 8) :
    (mul a b c).val j = a.val j * b.val j := by
  cases c
  · exact mul_val_false ha hb j
  · rw [mul_true, carry_val, mul_val_false ha hb j]

-- `carry` bounds any limbs; the hypotheses match `mul_val`'s
set_option linter.unusedVariables false in
public theorem mul_carried {a b : Fe} (ha : a.F52) (hb : b.F52) : (mul a b).Carried := by
  rw [mul_true]
  exact carry_carried _

public theorem mul_loose {a b : Fe} (ha : a.F52) (hb : b.F52) : (mul a b false).Loose := by
  intro j i
  have hL : ∀ k m, lmul a b j k m ≤ 2 ^ 52 := fun k m => (madd52lo_lt _ _).le
  have hH : ∀ k m, hmul a b j k m ≤ 2 ^ 52 := fun k m =>
    (madd52hi_lt52 (F52.lt ha j k) (F52.lt hb j m)).le
  fin_cases i
  · exact (mul_limb0 ha hb j).trans_le (mcol_le hL hH (d := 0) (by norm_num))
  · exact (mul_limb1 ha hb j).trans_le (mcol_le hL hH (d := 1) (by norm_num))
  · exact (mul_limb2 ha hb j).trans_le (mcol_le hL hH (d := 2) (by norm_num))
  · exact (mul_limb3 ha hb j).trans_le (mcol_le hL hH (d := 3) (by norm_num))
  · exact (mul_limb4 ha hb j).trans_le (mcol_le hL hH (d := 4) (by norm_num))

public theorem sqr_val {a : Fe} (ha : a.F52) (c : Bool) (j : Fin 8) :
    (sqr a c).val j = a.val j ^ 2 := by
  cases c
  · exact sqr_val_false ha j
  · rw [sqr_true, carry_val, sqr_val_false ha j]

-- `carry` bounds any limbs; the hypothesis matches `sqr_val`'s
set_option linter.unusedVariables false in
public theorem sqr_carried {a : Fe} (ha : a.F52) : (sqr a).Carried := by
  rw [sqr_true]
  exact carry_carried _

public theorem sqr_loose {a : Fe} (ha : a.F52) : (sqr a false).Loose := by
  intro j i
  have hL : ∀ k m, lsqr a j k m ≤ 2 ^ 52 := fun k m => (madd52lo_lt _ _).le
  have hH : ∀ k m, hsqr a j k m ≤ 2 ^ 52 := fun k m =>
    (madd52hi_lt52 (F52.lt ha j k) (F52.lt ha j m)).le
  fin_cases i
  · exact (sqr_limb0 ha j).trans_le (scol_le hL hH (d := 0) (by norm_num))
  · exact (sqr_limb1 ha j).trans_le (scol_le hL hH (d := 1) (by norm_num))
  · exact (sqr_limb2 ha j).trans_le (scol_le hL hH (d := 2) (by norm_num))
  · exact (sqr_limb3 ha j).trans_le (scol_le hL hH (d := 3) (by norm_num))
  · exact (sqr_limb4 ha j).trans_le (scol_le hL hH (d := 4) (by norm_num))

end MLIR.Firedancer.Lane

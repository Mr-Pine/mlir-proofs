module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! The `FD_R43X6_QUAD_*` macros as compiled, as patterns: each one's instructions over register
variables, its lane flags and shuffle masks as parameters, its result an equation to the macro's
`Quad` operation; and the code's vector constants, built lane by lane. -/

namespace MLIR

@[expose] public section

namespace Firedancer.Avx512

/-- `FD_R43X6_QUAD_PERMUTE`'s `_perm` as a shuffle mask: lanes `imm0 … imm3`, then each plus 4. -/
def permMask (i0 i1 i2 i3 : Nat) : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some (Fin.ofNat _ i0), some (Fin.ofNat _ i1), some (Fin.ofNat _ i2), some (Fin.ofNat _ i3),
    some (Fin.ofNat _ (i0 + 4)), some (Fin.ofNat _ (i1 + 4)), some (Fin.ofNat _ (i2 + 4)),
    some (Fin.ofNat _ (i3 + 4))]

/-- Lane `j` of a lane select: the first operand's where `i = 0`, else the second's. -/
def selLane (i j : Nat) : Option (Fin (2 * 8)) :=
  match i with
  | 0 => some (Fin.ofNat _ j)
  | _ => some (Fin.ofNat _ (j + 8))

/-- A lane select as a shuffle mask: lanes `j`, `j + 4` by `selLane ij`. -/
def selMask (i0 i1 i2 i3 : Nat) : Vector (Option (Fin (2 * 8))) 8 :=
  #v[selLane i0 0, selLane i1 1, selLane i2 2, selLane i3 3, selLane i0 4, selLane i1 5,
    selLane i2 6, selLane i3 7]

/-- `a` where `i = 0`, else `b`. -/
def selV (i : Nat) (a b : α) : α :=
  match i with
  | 0 => a
  | _ => b

/-- `permMask imm` on the lanes `j`, `j + 4` where `sj ≠ 0`, poison elsewhere: a permute whose
other lanes go unused. -/
def permPoisonMask (i0 i1 i2 i3 s0 s1 s2 s3 : Nat) : Vector (Option (Fin (2 * 8))) 8 :=
  #v[selV s0 none (some (Fin.ofNat _ i0)), selV s1 none (some (Fin.ofNat _ i1)),
    selV s2 none (some (Fin.ofNat _ i2)), selV s3 none (some (Fin.ofNat _ i3)),
    selV s0 none (some (Fin.ofNat _ (i0 + 4))), selV s1 none (some (Fin.ofNat _ (i1 + 4))),
    selV s2 none (some (Fin.ofNat _ (i2 + 4))), selV s3 none (some (Fin.ofNat _ (i3 + 4)))]

/-- A lane select with a permute of its second operand fused in: lanes `j`, `j + 4` of the first
operand where `sj ≠ 0`, of the second's `permMask imm` elsewhere. -/
def permSelMask (i0 i1 i2 i3 s0 s1 s2 s3 : Nat) : Vector (Option (Fin (2 * 8))) 8 :=
  #v[selV s0 (some (Fin.ofNat _ (i0 + 8))) (some 0), selV s1 (some (Fin.ofNat _ (i1 + 8))) (some 1),
    selV s2 (some (Fin.ofNat _ (i2 + 8))) (some 2), selV s3 (some (Fin.ofNat _ (i3 + 8))) (some 3),
    selV s0 (some (Fin.ofNat _ (i0 + 12))) (some 4),
    selV s1 (some (Fin.ofNat _ (i1 + 12))) (some 5),
    selV s2 (some (Fin.ofNat _ (i2 + 12))) (some 6),
    selV s3 (some (Fin.ofNat _ (i3 + 12))) (some 7)]

/-- Lanes `j`, `j + 4` of `y` where `ij ≠ 0`, of `x` where `ij = 0`. -/
def wwl_lane_sel (i0 i1 i2 i3 : Nat) (x y : Wwl) : Wwl :=
  #v[selV i0 x[0] y[0], selV i1 x[1] y[1], selV i2 x[2] y[2], selV i3 x[3] y[3], selV i0 x[4] y[4],
    selV i1 x[5] y[5], selV i2 x[6] y[6], selV i3 x[7] y[7]]

/-- Lanes `j`, `j + 4` of `v` where `ij ≠ 0`, poison where `ij = 0`: the `p` limbs
`FD_R43X6_QUAD_LANE_SUB_FAST` adds, as the code materializes them. -/
def selPoison (i0 i1 i2 i3 : Nat) (v : Wwl) : ⟦.vec 8 64⟧ :=
  #v[selV i0 .poison (.value v[0]), selV i1 .poison (.value v[1]), selV i2 .poison (.value v[2]),
    selV i3 .poison (.value v[3]), selV i0 .poison (.value v[4]), selV i1 .poison (.value v[5]),
    selV i2 .poison (.value v[6]), selV i3 .poison (.value v[7])]

/-- `FD_R43X6_GE_DBL` from `QUAD_SQR_FAST( _ta, _ta )` to `QUAD_MUL_FAST( _ta, _ta, _tb )`, on
`_ta` before the squaring. -/
def geDblMid (mul : Quad → Quad → Quad) (sqr : Quad → Quad) (T : Quad) : Quad :=
  let _ta := sqr T
  let _ta := _ta.laneAddFast 0 0 1 0 _ta _ta
  let _tb := _ta.permute 3 3 3 3
  let _BB := _ta.permute 1 1 1 1
  let _tb := _tb.laneAddFast 1 0 0 1 _tb _BB
  let _tb := _tb.laneSubFast 0 1 1 0 _tb _BB
  let _tb := _tb.laneAddFast 0 0 1 0 _tb _ta
  let _tb := _tb.laneSubFast 1 0 0 0 _tb _ta
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 1 1 0
  let _tb := _tb.permute 2 3 2 3
  mul _ta _tb

end Firedancer.Avx512

open Firedancer.Avx512 Memory

set_option hygiene false in
/-- One lane of a lane select: both cases of its flag `i`. -/
local macro "sel_lane " i:ident : tactic =>
  `(tactic|
    (rcases $i:ident with _ | _ <;>
        simp only [Operation.shufflevector, Nat.reduceMul, selMask, selLane, Fin.ofNat_eq_cast,
          Fin.natCast_zero, Fin.isValue, Nat.reduceAdd, Fin.natCast_eq_last, Fin.reduceLast,
          List.size_toArray, List.length_cons, List.length_nil, Nat.zero_add, Std.le_refl, and_self,
          Fin.getElem_fin, Vector.getElem_mk, List.getElem_toArray, Ty.wrap_vec, Vector.getElem_map,
          selPoison, selV, Vector.getElem_zipWith, Operation.add, Operation.sub, true_and,
          Bool.false_eq_true, false_and, ↓reduceIte, PoisonOr.pure_def, PoisonOr.poison_bind,
          PoisonOr.value_bind, Vector.getElem_ofFn, List.getElem_cons_zero, Fin.val_ofNat_lit,
          Nat.zero_mod, Nat.zero_lt_succ, ↓reduceDIte, wwl_lane_sel, wwl_add, wwl_sub,
          List.getElem_cons_succ, Vector.map_mk, List.map_toArray, List.map_cons, List.map_nil,
          pullWrap, wrapGetElem, PoisonOr.value_inj, Fin.val_natCast, Nat.reduceMod,
          lt_self_iff_false, Nat.sub_self, Nat.reduceLT, Nat.reduceSub, dite_false, one_sub_add_one,
          *]))

set_option hygiene false in
/-- One lane of a partial permute: both cases of its flag `s`. -/
local macro "perm_lane " s:ident : tactic =>
  `(tactic|
    (rcases $s:ident with _ | _ <;>
        simp [Operation.shufflevector, permPoisonMask, permSelMask, selPoison, selV, wwl_perm4,
          wwl_lane_sel, Ty.wrap_vec, Nat.mod_eq_of_lt, *]))

/-! ### Lanes -/

theorem one_sub_add_one (n : Nat) : 1 - (n + 1) = 0 := by omega

theorem selV_one_sub (i : Nat) (a b : α) : selV (1 - i) b a = selV i a b := by
  rcases i with _ | n
  · rfl
  · rw [show 1 - (n + 1) = 0 by omega]
    rfl

theorem wwl_lane_sel_one_sub (i0 i1 i2 i3 : Nat) (x y : Wwl) :
    wwl_lane_sel (1 - i0) (1 - i1) (1 - i2) (1 - i3) y x = wwl_lane_sel i0 i1 i2 i3 x y := by
  simp only [wwl_lane_sel, selV_one_sub]

/-- A shuffle by `permMask imm`: the lanes `wwl_perm4 imm` picks. -/
theorem shufflevector_permMask {i0 i1 i2 i3 : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = permMask i0 i1 i2 i3) (h : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (x : ⟦.vec 8 64⟧ᵣ)
    (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      Ty.wrap (t := .vec 8 64) (wwl_perm4 i0 i1 i2 i3 x) := by
  subst hm
  obtain ⟨h0, h1, h2, h3⟩ := h
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals
    first
    | omega
    | simp [Operation.shufflevector, permMask, wwl_perm4, Ty.wrap_vec,
        Nat.mod_eq_of_lt (show i0 < 16 by omega), Nat.mod_eq_of_lt (show i1 < 16 by omega),
        Nat.mod_eq_of_lt (show i2 < 16 by omega), Nat.mod_eq_of_lt (show i3 < 16 by omega),
        Nat.mod_eq_of_lt (show i0 + 4 < 16 by omega), Nat.mod_eq_of_lt (show i1 + 4 < 16 by omega),
        Nat.mod_eq_of_lt (show i2 + 4 < 16 by omega), Nat.mod_eq_of_lt (show i3 + 4 < 16 by omega),
        Nat.mod_eq_of_lt (show i0 < 8 by omega), Nat.mod_eq_of_lt (show i1 < 8 by omega),
        Nat.mod_eq_of_lt (show i2 < 8 by omega), Nat.mod_eq_of_lt (show i3 < 8 by omega),
        Nat.mod_eq_of_lt (show i0 + 4 < 8 by omega), Nat.mod_eq_of_lt (show i1 + 4 < 8 by omega),
        Nat.mod_eq_of_lt (show i2 + 4 < 8 by omega), Nat.mod_eq_of_lt (show i3 + 4 < 8 by omega),
        show i0 < 8 by omega, show i1 < 8 by omega, show i2 < 8 by omega, show i3 < 8 by omega,
        show i0 + 4 < 8 by omega, show i1 + 4 < 8 by omega, show i2 + 4 < 8 by omega,
        show i3 + 4 < 8 by omega]

/-- A shuffle by `selMask imm`: `y`'s lanes where `immj ≠ 0`, `x`'s elsewhere. -/
theorem shufflevector_selMask {i0 i1 i2 i3 : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = selMask i0 i1 i2 i3) (x y : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel i0 i1 i2 i3 x y) := by
  subst hm
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · omega

/-- A lane select with the operands swapped: the mask of `1 - ij`. -/
theorem shufflevector_selMask_swap {i0 i1 i2 i3 : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = selMask (1 - i0) (1 - i1) (1 - i2) (1 - i3)) (x y : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) y) (Ty.wrap (t := .vec 8 64) x) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel i0 i1 i2 i3 x y) := by
  rw [shufflevector_selMask hm, wwl_lane_sel_one_sub]

/-- `x + y` under the flags `f`, no lane overflowing as a set flag forbids. -/
theorem zipWith_add_flags_wrap {f : OverflowFlags} (x y : ⟦.vec 8 64⟧ᵣ)
    (hs : f.nsw = true → ∀ i : Fin 8, x[i].saddOverflow y[i] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  rcases f with ⟨_ | _, _ | _⟩
  · simp [Ty.wrap_vec, wwl_add, Operation.add]
  · simp at hu
  · have := hs rfl ⟨i, hi⟩
    simp_all [Ty.wrap_vec, wwl_add, Operation.add]
  · simp at hu

/-- `x - y` under the flags `f`, no lane overflowing as a set flag forbids. -/
theorem zipWith_sub_flags_wrap {f : OverflowFlags} (x y : ⟦.vec 8 64⟧ᵣ)
    (hs : f.nsw = true → ∀ i : Fin 8, x[i].ssubOverflow y[i] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.sub f (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub x y) := by
  ext i hi
  rcases f with ⟨_ | _, _ | _⟩
  · simp [Ty.wrap_vec, wwl_sub, Operation.sub]
  · simp at hu
  · have := hs rfl ⟨i, hi⟩
    simp_all [Ty.wrap_vec, wwl_sub, Operation.sub]
  · simp at hu

/-- `d + v` on the lanes `selPoison` keeps, under the flags `f`. -/
theorem zipWith_add_selPoison (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (d v : ⟦.vec 8 64⟧ᵣ)
    (hs : f.nsw = true → ∀ k : Fin 8, d[k].saddOverflow v[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (Ty.wrap (t := .vec 8 64) d)
        (selPoison i0 i1 i2 i3 v) =
      selPoison i0 i1 i2 i3 (wwl_add d v) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega
  · have h0 := hs rfl 0
    have h1 : d[1].saddOverflow v[1] = false := hs rfl 1
    have h2 : d[2].saddOverflow v[2] = false := hs rfl 2
    have h3 : d[3].saddOverflow v[3] = false := hs rfl 3
    have h4 : d[4].saddOverflow v[4] = false := hs rfl 4
    have h5 : d[5].saddOverflow v[5] = false := hs rfl 5
    have h6 : d[6].saddOverflow v[6] = false := hs rfl 6
    have h7 : d[7].saddOverflow v[7] = false := hs rfl 7
    clear hs
    ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
      simp_all
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- A shuffle by `selMask imm` of `t` and `selPoison imm v`: `v`'s lanes where `immj ≠ 0`. -/
theorem shufflevector_selPoison {i0 i1 i2 i3 : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = selMask i0 i1 i2 i3) (t v : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) t) (selPoison i0 i1 i2 i3 v) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel i0 i1 i2 i3 t v) := by
  subst hm
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · omega

/-- `shufflevector_selPoison` with the operands swapped: the mask of `1 - ij`. -/
theorem shufflevector_selPoison_swap {i0 i1 i2 i3 : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = selMask (1 - i0) (1 - i1) (1 - i2) (1 - i3)) (t v : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (selPoison i0 i1 i2 i3 v) (Ty.wrap (t := .vec 8 64) t) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel i0 i1 i2 i3 t v) := by
  subst hm
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · omega

/-- `a - x` on the lanes `selPoison` keeps, under the flags `f`. -/
theorem zipWith_selPoison_sub (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (a x : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, a[k].ssubOverflow x[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.sub f (w := 64)) (selPoison i0 i1 i2 i3 a)
        (Ty.wrap (t := .vec 8 64) x) =
      selPoison i0 i1 i2 i3 (wwl_sub a x) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega
  · have h0 : a[0].ssubOverflow x[0] = false := hs rfl 0
    have h1 : a[1].ssubOverflow x[1] = false := hs rfl 1
    have h2 : a[2].ssubOverflow x[2] = false := hs rfl 2
    have h3 : a[3].ssubOverflow x[3] = false := hs rfl 3
    have h4 : a[4].ssubOverflow x[4] = false := hs rfl 4
    have h5 : a[5].ssubOverflow x[5] = false := hs rfl 5
    have h6 : a[6].ssubOverflow x[6] = false := hs rfl 6
    have h7 : a[7].ssubOverflow x[7] = false := hs rfl 7
    clear hs
    ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- `a + x` on the lanes `selPoison` keeps, under the flags `f`. -/
theorem zipWith_selPoison_add (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (a x : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, a[k].saddOverflow x[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (selPoison i0 i1 i2 i3 a)
        (Ty.wrap (t := .vec 8 64) x) =
      selPoison i0 i1 i2 i3 (wwl_add a x) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega
  · have h0 : a[0].saddOverflow x[0] = false := hs rfl 0
    have h1 : a[1].saddOverflow x[1] = false := hs rfl 1
    have h2 : a[2].saddOverflow x[2] = false := hs rfl 2
    have h3 : a[3].saddOverflow x[3] = false := hs rfl 3
    have h4 : a[4].saddOverflow x[4] = false := hs rfl 4
    have h5 : a[5].saddOverflow x[5] = false := hs rfl 5
    have h6 : a[6].saddOverflow x[6] = false := hs rfl 6
    have h7 : a[7].saddOverflow x[7] = false := hs rfl 7
    clear hs
    ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- `a + x` on the lanes both `selPoison`s keep, under the flags `f`. -/
theorem zipWith_selPoison_add_selPoison (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (a x : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, a[k].saddOverflow x[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (selPoison i0 i1 i2 i3 a) (selPoison i0 i1 i2 i3 x) =
      selPoison i0 i1 i2 i3 (wwl_add a x) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega
  · have h0 : a[0].saddOverflow x[0] = false := hs rfl 0
    have h1 : a[1].saddOverflow x[1] = false := hs rfl 1
    have h2 : a[2].saddOverflow x[2] = false := hs rfl 2
    have h3 : a[3].saddOverflow x[3] = false := hs rfl 3
    have h4 : a[4].saddOverflow x[4] = false := hs rfl 4
    have h5 : a[5].saddOverflow x[5] = false := hs rfl 5
    have h6 : a[6].saddOverflow x[6] = false := hs rfl 6
    have h7 : a[7].saddOverflow x[7] = false := hs rfl 7
    clear hs
    ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- A shuffle by `permPoisonMask imm s`: lanes of `wwl_perm4 imm x` where `sj ≠ 0`. -/
theorem shufflevector_permPoisonMask {i0 i1 i2 i3 s0 s1 s2 s3 : Nat}
    {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = permPoisonMask i0 i1 i2 i3 s0 s1 s2 s3)
    (h : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (x : ⟦.vec 8 64⟧ᵣ) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 x) := by
  subst hm
  obtain ⟨h0, h1, h2, h3⟩ := h
  have : i0 < 8 ∧ i1 < 8 ∧ i2 < 8 ∧ i3 < 8 := by omega
  have : i0 + 4 < 8 ∧ i1 + 4 < 8 ∧ i2 + 4 < 8 ∧ i3 + 4 < 8 := by omega
  have : i0 < 16 ∧ i1 < 16 ∧ i2 < 16 ∧ i3 < 16 := by omega
  have : i0 + 4 < 16 ∧ i1 + 4 < 16 ∧ i2 + 4 < 16 ∧ i3 + 4 < 16 := by omega
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  · perm_lane s0
  · perm_lane s1
  · perm_lane s2
  · perm_lane s3
  · perm_lane s0
  · perm_lane s1
  · perm_lane s2
  · perm_lane s3
  · omega

/-- A shuffle by `permSelMask imm s` of `selPoison s e` and `x`: `e`'s lanes where `sj ≠ 0`,
`wwl_perm4 imm x`'s elsewhere. -/
theorem shufflevector_permSelMask {i0 i1 i2 i3 s0 s1 s2 s3 : Nat}
    {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = permSelMask i0 i1 i2 i3 s0 s1 s2 s3)
    (h : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (e x : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (selPoison s0 s1 s2 s3 e) (Ty.wrap (t := .vec 8 64) x) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 x) e) := by
  subst hm
  obtain ⟨h0, h1, h2, h3⟩ := h
  have : i0 < 8 ∧ i1 < 8 ∧ i2 < 8 ∧ i3 < 8 := by omega
  have : i0 + 4 < 8 ∧ i1 + 4 < 8 ∧ i2 + 4 < 8 ∧ i3 + 4 < 8 := by omega
  have : i0 + 8 < 16 ∧ i1 + 8 < 16 ∧ i2 + 8 < 16 ∧ i3 + 8 < 16 := by omega
  have : i0 + 12 < 16 ∧ i1 + 12 < 16 ∧ i2 + 12 < 16 ∧ i3 + 12 < 16 := by omega
  have : ¬i0 + 8 < 8 ∧ ¬i1 + 8 < 8 ∧ ¬i2 + 8 < 8 ∧ ¬i3 + 8 < 8 := by omega
  have : ¬i0 + 12 < 8 ∧ ¬i1 + 12 < 8 ∧ ¬i2 + 12 < 8 ∧ ¬i3 + 12 < 8 := by omega
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  · perm_lane s0
  · perm_lane s1
  · perm_lane s2
  · perm_lane s3
  · perm_lane s0
  · perm_lane s1
  · perm_lane s2
  · perm_lane s3
  · omega

/-- A shuffle by `selMask imm` of `selPoison (1 - imm) d` and `selPoison imm e`: the lanes each
keeps. -/
theorem shufflevector_selMask_selPoison {i0 i1 i2 i3 t0 t1 t2 t3 : Nat}
    {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = selMask i0 i1 i2 i3)
    (ht : t0 = 1 - i0 ∧ t1 = 1 - i1 ∧ t2 = 1 - i2 ∧ t3 = 1 - i3) (d e : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (selPoison t0 t1 t2 t3 d) (selPoison i0 i1 i2 i3 e) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel i0 i1 i2 i3 d e) := by
  subst hm
  obtain ⟨rfl, rfl, rfl, rfl⟩ := ht
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · sel_lane i0
  · sel_lane i1
  · sel_lane i2
  · sel_lane i3
  · omega

/-- The merged lane add and sub: `t + x` in lanes 0, 3, `t - x + p` in lanes 1, 2. -/
theorem lane_sel_add_sub (t x p : Wwl) :
    wwl_lane_sel 0 1 1 0 (wwl_lane_sel 1 0 0 1 t (wwl_add t x))
        (wwl_add (wwl_sub (wwl_lane_sel 1 0 0 1 t (wwl_add t x)) x) p) =
      wwl_lane_sel 0 1 1 0 (wwl_add t x) (wwl_add (wwl_sub t x) p) := by
  ext i hi : 1
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    |
      simp only [wwl_lane_sel, selV, wwl_add, wwl_sub, Vector.getElem_ofFn, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, Fin.getElem_fin]

/-- A `0 1 1 0` select reads `wwl_lane_sel 1 0 0 1 t d` only where it is `d`, the sum only where
it is `t + x`. -/
theorem lane_sel_sub_add (t d x : Wwl) :
    wwl_lane_sel 0 1 1 0 (wwl_lane_sel 1 0 0 1 t d) (wwl_add (wwl_lane_sel 1 0 0 1 t d) x) =
      wwl_lane_sel 0 1 1 0 d (wwl_add t x) := by
  ext k hk
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    | simp [wwl_lane_sel, selV, wwl_add]

/-- Setting all eight lanes forgets the base vector. -/
theorem Vector.set_eight {α : Type} (w : Vector α 8) (x0 x1 x2 x3 x4 x5 x6 x7 : α) :
    (((((((w.set 0 x0).set 1 x1).set 2 x2).set 3 x3).set 4 x4).set 5 x5).set 6 x6).set 7 x7 =
      #v[x0, x1, x2, x3, x4, x5, x6, x7] := by
  ext i hi
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | simp

/-! ### The macros' `Quad` operations, lane by lane -/

theorem ite_selV (i : Nat) (a b : α) :
    (if selV i false true = true then b else a) = selV i a b := by rcases i with _ | _ <;> rfl

theorem quadMask_getLsbD {i0 i1 i2 i3 : Nat} (h : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) :
    (quadMask i0 i1 i2 i3).getLsbD 0 = selV i0 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 1 = selV i1 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 2 = selV i2 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 3 = selV i3 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 4 = selV i0 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 5 = selV i1 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 6 = selV i2 false true ∧
      (quadMask i0 i1 i2 i3).getLsbD 7 = selV i3 false true := by
  obtain ⟨h0, h1, h2, h3⟩ := h
  rcases Nat.le_one_iff_eq_zero_or_eq_one.mp h0 with rfl | rfl <;>
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp h1 with rfl | rfl <;>
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp h2 with rfl | rfl <;>
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp h3 with rfl | rfl <;>
    decide

/-- `FD_R43X6_QUAD_PERMUTE` as the code's shuffles. -/
theorem Quad.permute_eq_perm4 {i0 i1 i2 i3 : Nat} (h : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4)
    (P : Quad) : P.permute i0 i1 i2 i3 = P.perm4 i0 i1 i2 i3 := by
  obtain ⟨h0, h1, h2, h3⟩ := h
  simp only [Quad.permute, Quad.perm4, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    |
      simp [wwl_permute, wwl, wwl_perm4, Nat.mod_eq_of_lt (show i0 < 2 ^ 64 by omega),
        Nat.mod_eq_of_lt (show i1 < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show i2 < 2 ^ 64 by omega),
        Nat.mod_eq_of_lt (show i3 < 2 ^ 64 by omega), Nat.add_comm 4]

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( D, T, imm0,imm1,imm2,imm3, T, X )` as the code's lane select. -/
theorem Quad.laneAddFast_sel {i0 i1 i2 i3 : Nat} (h : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (T X : Quad) :
    T.laneAddFast i0 i1 i2 i3 T X =
      ⟨wwl_lane_sel i0 i1 i2 i3 T.P03 (wwl_add T.P03 X.P03),
        wwl_lane_sel i0 i1 i2 i3 T.P14 (wwl_add T.P14 X.P14),
        wwl_lane_sel i0 i1 i2 i3 T.P25 (wwl_add T.P25 X.P25)⟩ := by
  obtain ⟨b0, b1, b2, b3, b4, b5, b6, b7⟩ := quadMask_getLsbD h
  simp only [Quad.laneAddFast, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    |
      simp only [wwv_add_if, wwl_lane_sel, wwl_add, Vector.getElem_ofFn, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, Nat.reduceAdd,
        Fin.getElem_fin, b0, b1, b2, b3, b4, b5, b6, b7, ite_selV]

/-- `FD_R43X6_QUAD_LANE_SUB_FAST( D, T, imm0,imm1,imm2,imm3, T, X )` as the code's lane select:
`T - X + p` where the code adds `p` after the difference. -/
theorem Quad.laneSubFast_sel {i0 i1 i2 i3 : Nat} (h : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (T X : Quad) :
    T.laneSubFast i0 i1 i2 i3 T X =
      ⟨wwl_lane_sel i0 i1 i2 i3 T.P03 (wwl_add (wwl_sub T.P03 X.P03) quadP.P03),
        wwl_lane_sel i0 i1 i2 i3 T.P14 (wwl_add (wwl_sub T.P14 X.P14) quadP.P14),
        wwl_lane_sel i0 i1 i2 i3 T.P25 (wwl_add (wwl_sub T.P25 X.P25) quadP.P25)⟩ := by
  obtain ⟨b0, b1, b2, b3, b4, b5, b6, b7⟩ := quadMask_getLsbD h
  simp only [Quad.laneSubFast, Quad.laneAddFast, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    |
      simp only [wwv_add_if, wwl_lane_sel, wwl_add, wwl_sub, Vector.getElem_ofFn, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, Nat.reduceAdd,
        Fin.getElem_fin, b0, b1, b2, b3, b4, b5, b6, b7, ite_selV, add_sub_comm']

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( T, T, 1,0,0,1, T, X )` then
`FD_R43X6_QUAD_LANE_SUB_FAST( T, T, 0,1,1,0, T, X )`: `T + X` in lanes 0, 3, `T - X + p` in
lanes 1, 2. -/
theorem Quad.laneAddSubFast_sel (T X : Quad) :
    (T.laneAddFast 1 0 0 1 T X).laneSubFast 0 1 1 0 (T.laneAddFast 1 0 0 1 T X) X =
      ⟨wwl_lane_sel 0 1 1 0 (wwl_add T.P03 X.P03) (wwl_add (wwl_sub T.P03 X.P03) quadP.P03),
        wwl_lane_sel 0 1 1 0 (wwl_add T.P14 X.P14) (wwl_add (wwl_sub T.P14 X.P14) quadP.P14),
        wwl_lane_sel 0 1 1 0 (wwl_add T.P25 X.P25) (wwl_add (wwl_sub T.P25 X.P25) quadP.P25)⟩ := by
  rw [Quad.laneSubFast_sel (by decide), Quad.laneAddFast_sel (by decide)]
  simp only [lane_sel_add_sub]

/-- `FD_R43X6_GE_DBL` around `geDblMid`. -/
theorem geDbl_eq_mid (mul : Quad → Quad → Quad) (sqr : Quad → Quad) (P : Quad) :
    geDbl mul sqr P =
      Quad.foldUnsigned
        (geDblMid mul sqr ((P.permute 1 1 2 0).laneAddFast 1 0 0 0 (P.permute 1 1 2 0) P)) :=
  rfl

/-! ### Bounds -/

/-- `p`'s limbs are below `2^44`. -/
theorem quadP_lt :
    (∀ i : Fin 8, quadP.P03[i] < 17592186044416#64) ∧
      (∀ i : Fin 8, quadP.P14[i] < 17592186044416#64) ∧
      ∀ i : Fin 8, quadP.P25[i] < 17592186044416#64 := by
  refine ⟨?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> decide

/-- Folded lanes less folded lanes, plus lanes below `2^44`: no signed overflow. -/
theorem sub_add_lt_ok {x y c : Wwl} (hx : ∀ i : Fin 8, x[i] < 17592186044416#64)
    (hy : ∀ i : Fin 8, y[i] < 17592186044416#64) (hc : ∀ i : Fin 8, c[i] < 17592186044416#64) :
    ∀ i : Fin 8, (wwl_sub x y)[i].saddOverflow c[i] = false := by
  intro i
  simp only [wwl_sub, Fin.getElem_fin, Vector.getElem_ofFn]
  exact sub_add_lane_ok (hx i) (hy i) (hc i)

/-! ### Patterns -/

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_shl_wrap

/-- `FD_R43X6_QUAD_PERMUTE( r, imm0,imm1,imm2,imm3, x )`: a shuffle by `m` of each of `x03 x14 x25`
(`pz` the unused operand) into `r03 r14 r25`. -/
def permuteRun (m : Vector (Option (Fin (2 * 8))) 8)
    (x03 x14 x25 pz r03 r14 r25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.shufflevector m) r03 (.val x03.i x03.h) (.val pz.i pz.h),
    .binop (.shufflevector m) r14 (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.shufflevector m) r25 (.val x25.i x25.h) (.val pz.i pz.h)]

/-- Where the body at `pos` is `permuteRun` by `permMask imm` and `x03 x14 x25` hold `X`: running
on from `pos` then `g` gives `K` if it does from `pos + 3` with `X.permute imm` (as
`p03 p14 p25`) in `r03 r14 r25`. -/
theorem runBodyFrom_permuteRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {x03 x14 x25 pz r03 r14 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {PZ : ⟦.vec 8 64⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteRun m x03 x14 x25 pz r03 r14 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25]) (hz : E.read (.val pz.i pz.h) = PZ)
    (hm : m = permMask i0 i1 i2 i3)
    (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (hd : [x03.i, x14.i, x25.i, r03.i, r14.i].Nodup)
    (hK :
      ∀ (p03 p14 p25 : Wwl)
        (_hp : Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩ = ⟨p03, p14, p25⟩),
        (blk.runBodyFrom E[r03 := Ty.wrap p03, r14 := Ty.wrap p14, r25 := Ty.wrap p25] (pos + 3)
            S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [shufflevector_permMask hm hi] with q03
  step_pure [shufflevector_permMask hm hi] with q14
  step_pure [shufflevector_permMask hm hi] with q25
  have e : Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩ = ⟨q03, q14, q25⟩ := by
    rw [Quad.permute_eq_perm4 hi, hq03, hq14, hq25]
    rfl
  rw [hE]
  exact hK _ _ _ e

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( r, t, imm0,imm1,imm2,imm3, t, x )`: `t + x` into `a03 a14 a25`
(flags `f03 f14 f25`), selected against `t` into `r03 r14 r25` by shuffles (mask `m`) of `t` and
the sums. -/
def laneAddRun (m : Vector (Option (Fin (2 * 8))) 8) (f03 f14 f25 : OverflowFlags)
    (t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.vector (.add f03)) a03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.shufflevector m) r03 (.val t03.i t03.h) (.val a03.i a03.h),
    .binop (.vector (.add f14)) a14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.shufflevector m) r14 (.val t14.i t14.h) (.val a14.i a14.h),
    .binop (.vector (.add f25)) a25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.shufflevector m) r25 (.val t25.i t25.h) (.val a25.i a25.h)]

/-- `laneAddRun` with the shuffles' operands swapped: the sums first. -/
def laneAddRun' (m : Vector (Option (Fin (2 * 8))) 8) (f03 f14 f25 : OverflowFlags)
    (t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.vector (.add f03)) a03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.shufflevector m) r03 (.val a03.i a03.h) (.val t03.i t03.h),
    .binop (.vector (.add f14)) a14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.shufflevector m) r14 (.val a14.i a14.h) (.val t14.i t14.h),
    .binop (.vector (.add f25)) a25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.shufflevector m) r25 (.val a25.i a25.h) (.val t25.i t25.h)]

/-- Where the body at `pos` is `laneAddRun` by `selMask imm`, `t03 t14 t25` hold `T` and
`x03 x14 x25` hold `X` (no lane overflowing as a set flag forbids): running on from `pos` then `g`
gives `K` if it does from `pos + 6` with `T.laneAddFast imm T X` (as `s03 s14 s25`) in
`r03 r14 r25`. -/
theorem runBodyFrom_laneAddRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8} {f03 f14 f25 : OverflowFlags}
    {t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneAddRun m f03 f14 f25 t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 ++ rest)
    (hR : E ⊨ [t03 := T03, t14 := T14, t25 := T25, x03 := X03, x14 := X14, x25 := X25])
    (hm : m = selMask i0 i1 i2 i3) (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hf : f03.nuw = false ∧ f14.nuw = false ∧ f25.nuw = false)
    (ho03 : f03.nsw = true → ∀ k : Fin 8, T03[k].saddOverflow X03[k] = false)
    (ho14 : f14.nsw = true → ∀ k : Fin 8, T14[k].saddOverflow X14[k] = false)
    (ho25 : f25.nsw = true → ∀ k : Fin 8, T25[k].saddOverflow X25[k] = false)
    (hd : [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, a03.i, r03.i, a14.i, r14.i, a25.i].Nodup)
    (hK :
      ∀ (va03 va14 va25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneAddFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[a03 := va03, r03 := Ty.wrap s03, a14 := va14, r14 := Ty.wrap s14, a25 := va25,
                r25 := Ty.wrap s25] (pos + 6) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hf03, hf14, hf25⟩ := hf
  step_pure [zipWith_add_flags_wrap _ _ ho03 hf03] with transparent sa03
  step_pure [shufflevector_selMask hm] with ss03
  step_pure [zipWith_add_flags_wrap _ _ ho14 hf14] with transparent sa14
  step_pure [shufflevector_selMask hm] with ss14
  step_pure [zipWith_add_flags_wrap _ _ ho25 hf25] with transparent sa25
  step_pure [shufflevector_selMask hm] with ss25
  have e :
      Quad.laneAddFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneAddFast_sel hi, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ e

/-- `runBodyFrom_laneAddRun` for `laneAddRun'`, by the mask of `1 - immj`. -/
theorem runBodyFrom_laneAddRun' (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8} {f03 f14 f25 : OverflowFlags}
    {t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneAddRun' m f03 f14 f25 t03 t14 t25 x03 x14 x25 a03 r03 a14 r14 a25 r25 ++ rest)
    (hR : E ⊨ [t03 := T03, t14 := T14, t25 := T25, x03 := X03, x14 := X14, x25 := X25])
    (hm : m = selMask (1 - i0) (1 - i1) (1 - i2) (1 - i3))
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hf : f03.nuw = false ∧ f14.nuw = false ∧ f25.nuw = false)
    (ho03 : f03.nsw = true → ∀ k : Fin 8, T03[k].saddOverflow X03[k] = false)
    (ho14 : f14.nsw = true → ∀ k : Fin 8, T14[k].saddOverflow X14[k] = false)
    (ho25 : f25.nsw = true → ∀ k : Fin 8, T25[k].saddOverflow X25[k] = false)
    (hd : [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, a03.i, r03.i, a14.i, r14.i, a25.i].Nodup)
    (hK :
      ∀ (va03 va14 va25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneAddFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[a03 := va03, r03 := Ty.wrap s03, a14 := va14, r14 := Ty.wrap s14, a25 := va25,
                r25 := Ty.wrap s25] (pos + 6) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hf03, hf14, hf25⟩ := hf
  step_pure [zipWith_add_flags_wrap _ _ ho03 hf03] with transparent sa03
  step_pure [shufflevector_selMask_swap hm] with ss03
  step_pure [zipWith_add_flags_wrap _ _ ho14 hf14] with transparent sa14
  step_pure [shufflevector_selMask_swap hm] with ss14
  step_pure [zipWith_add_flags_wrap _ _ ho25 hf25] with transparent sa25
  step_pure [shufflevector_selMask_swap hm] with ss25
  have e :
      Quad.laneAddFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneAddFast_sel hi, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ e

/-- `FD_R43X6_QUAD_LANE_SUB_FAST( r, t, imm0,imm1,imm2,imm3, t, x )`: `t - x` into `d03 d14 d25`
(flags `fs`), plus `p`'s limbs in `k03 k14 k25` into `e03 e14 e25` (flags `fa`), selected against
`t` into `r03 r14 r25` by shuffles (mask `m`) of the sums and `t`. -/
def laneSubRun (m : Vector (Option (Fin (2 * 8))) 8) (fs fa : OverflowFlags)
    (t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.sub fs)) d03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.vector (.add fa)) e03 (.val d03.i d03.h) (.val k03.i k03.h),
    .binop (.shufflevector m) r03 (.val e03.i e03.h) (.val t03.i t03.h),
    .binop (.vector (.sub fs)) d14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.vector (.add fa)) e14 (.val d14.i d14.h) (.val k14.i k14.h),
    .binop (.shufflevector m) r14 (.val e14.i e14.h) (.val t14.i t14.h),
    .binop (.vector (.sub fs)) d25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.vector (.add fa)) e25 (.val d25.i d25.h) (.val k25.i k25.h),
    .binop (.shufflevector m) r25 (.val e25.i e25.h) (.val t25.i t25.h)]

/-- Where the body at `pos` is `laneSubRun` by the mask of `1 - immj`, `t03 t14 t25` hold `T`,
`x03 x14 x25` hold `X` and `k03 k14 k25` `p`'s limbs where `immj ≠ 0` (no lane overflowing as a set
flag forbids): running on from `pos` then `g` gives `K` if it does from `pos + 9` with
`T.laneSubFast imm T X` (as `s03 s14 s25`) in `r03 r14 r25`. -/
theorem runBodyFrom_laneSubRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8} {fs fa : OverflowFlags}
    {t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneSubRun m fs fa t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25
            r25 ++ rest)
    (hR : E ⊨ [t03 := T03, t14 := T14, t25 := T25, x03 := X03, x14 := X14, x25 := X25])
    (hk : E.read (.val k03.i k03.h) = selPoison i0 i1 i2 i3 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison i0 i1 i2 i3 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison i0 i1 i2 i3 quadP.P25)
    (hm : m = selMask (1 - i0) (1 - i1) (1 - i2) (1 - i3)) (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hf : fs.nuw = false ∧ fa.nuw = false)
    (hs03 : fs.nsw = true → ∀ k : Fin 8, T03[k].ssubOverflow X03[k] = false)
    (hs14 : fs.nsw = true → ∀ k : Fin 8, T14[k].ssubOverflow X14[k] = false)
    (hs25 : fs.nsw = true → ∀ k : Fin 8, T25[k].ssubOverflow X25[k] = false)
    (ha03 : fa.nsw = true → ∀ k : Fin 8, (wwl_sub T03 X03)[k].saddOverflow quadP.P03[k] = false)
    (ha14 : fa.nsw = true → ∀ k : Fin 8, (wwl_sub T14 X14)[k].saddOverflow quadP.P14[k] = false)
    (ha25 : fa.nsw = true → ∀ k : Fin 8, (wwl_sub T25 X25)[k].saddOverflow quadP.P25[k] = false)
    (hd :
      [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, d03.i, e03.i, r03.i, d14.i,
          e14.i, r14.i, d25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 ve03 vd14 ve14 vd25 ve25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneSubFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, e03 := ve03, r03 := Ty.wrap s03, d14 := vd14, e14 := ve14,
                r14 := Ty.wrap s14, d25 := vd25, e25 := ve25, r25 := Ty.wrap s25] (pos + 9) S >>=
            g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hfs, hfa⟩ := hf
  step_pure [zipWith_sub_flags_wrap _ _ hs03 hfs] with transparent sd03
  step_pure [zipWith_add_selPoison _ _ _ _ _ _ ha03 hfa]
  step_pure [shufflevector_selPoison_swap hm] with ss03
  step_pure [zipWith_sub_flags_wrap _ _ hs14 hfs] with transparent sd14
  step_pure [zipWith_add_selPoison _ _ _ _ _ _ ha14 hfa]
  step_pure [shufflevector_selPoison_swap hm] with ss14
  step_pure [zipWith_sub_flags_wrap _ _ hs25 hfs] with transparent sd25
  step_pure [zipWith_add_selPoison _ _ _ _ _ _ ha25 hfa]
  step_pure [shufflevector_selPoison_swap hm] with ss25
  have e :
      Quad.laneSubFast ⟨T03, T14, T25⟩ i0 i1 i2 i3 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneSubFast_sel hi, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ e

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( r, t, 1,0,0,1, t, x )` then
`FD_R43X6_QUAD_LANE_SUB_FAST( r, r, 0,1,1,0, r, x )`, merged as compiled: `t + x` into
`a03 a14 a25`, `t - x` into `d03 d14 d25`, plus `p`'s limbs in `k03 k14 k25` into `e03 e14 e25`,
selected by `m` into `r03 r14 r25`. -/
def laneAddSubRun (m : Vector (Option (Fin (2 * 8))) 8)
    (t03 t14 t25 x03 x14 x25 k03 k14 k25 a03 a14 a25 d03 e03 r03 d14 e14 r14 d25 e25 r25 :
      Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) a03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.vector (.add {})) a14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.vector (.add {})) a25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.vector (.sub {})) d03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.vector (.add {})) e03 (.val d03.i d03.h) (.val k03.i k03.h),
    .binop (.shufflevector m) r03 (.val a03.i a03.h) (.val e03.i e03.h),
    .binop (.vector (.sub {})) d14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.vector (.add {})) e14 (.val d14.i d14.h) (.val k14.i k14.h),
    .binop (.shufflevector m) r14 (.val a14.i a14.h) (.val e14.i e14.h),
    .binop (.vector (.sub {})) d25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.vector (.add {})) e25 (.val d25.i d25.h) (.val k25.i k25.h),
    .binop (.shufflevector m) r25 (.val a25.i a25.h) (.val e25.i e25.h)]

/-- Where the body at `pos` is `laneAddSubRun` by `selMask 0 1 1 0`, `t03 t14 t25` hold `T`,
`x03 x14 x25` hold `X` and `k03 k14 k25` `p`'s limbs in lanes 1, 2: running on from `pos` then `g`
gives `K` if it does from `pos + 12` with the two macros' result (as `s03 s14 s25`) in
`r03 r14 r25`. -/
theorem runBodyFrom_laneAddSubRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {m : Vector (Option (Fin (2 * 8))) 8}
    {t03 t14 t25 x03 x14 x25 k03 k14 k25 a03 a14 a25 d03 e03 r03 d14 e14 r14 d25 e25 r25 :
      Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneAddSubRun m t03 t14 t25 x03 x14 x25 k03 k14 k25 a03 a14 a25 d03 e03 r03 d14 e14 r14
            d25 e25 r25 ++ rest)
    (hR : E ⊨ [t03 := T03, t14 := T14, t25 := T25, x03 := X03, x14 := X14, x25 := X25])
    (hk : E.read (.val k03.i k03.h) = selPoison 0 1 1 0 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison 0 1 1 0 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison 0 1 1 0 quadP.P25)
    (hm : m = selMask 0 1 1 0)
    (hd :
      [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, a03.i, a14.i, a25.i, d03.i,
          e03.i, r03.i, d14.i, e14.i, r14.i, d25.i, e25.i].Nodup)
    (hK :
      ∀ (va03 va14 va25 vd03 ve03 vd14 ve14 vd25 ve25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          (Quad.laneAddFast ⟨T03, T14, T25⟩ 1 0 0 1 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩).laneSubFast
              0 1 1 0 (Quad.laneAddFast ⟨T03, T14, T25⟩ 1 0 0 1 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩)
              ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[a03 := va03, a14 := va14, a25 := va25, d03 := vd03, e03 := ve03,
                r03 := Ty.wrap s03, d14 := vd14, e14 := ve14, r14 := Ty.wrap s14, d25 := vd25,
                e25 := ve25, r25 := Ty.wrap s25] (pos + 12) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [zipWith_add_wrap] with transparent sa03
  step_pure [zipWith_add_wrap] with transparent sa14
  step_pure [zipWith_add_wrap] with transparent sa25
  step_pure [zipWith_sub_wrap] with transparent sd03
  step_pure [zipWith_add_selPoison 0 1 1 0 (f := {}) _ _ (fun h => absurd h (by decide)) rfl]
  step_pure [shufflevector_selPoison hm] with ss03
  step_pure [zipWith_sub_wrap] with transparent sd14
  step_pure [zipWith_add_selPoison 0 1 1 0 (f := {}) _ _ (fun h => absurd h (by decide)) rfl]
  step_pure [shufflevector_selPoison hm] with ss14
  step_pure [zipWith_sub_wrap] with transparent sd25
  step_pure [zipWith_add_selPoison 0 1 1 0 (f := {}) _ _ (fun h => absurd h (by decide)) rfl]
  step_pure [shufflevector_selPoison hm] with ss25
  have e :
      (Quad.laneAddFast ⟨T03, T14, T25⟩ 1 0 0 1 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩).laneSubFast
          0 1 1 0 (Quad.laneAddFast ⟨T03, T14, T25⟩ 1 0 0 1 ⟨T03, T14, T25⟩ ⟨X03, X14, X25⟩)
          ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneAddSubFast_sel, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ e

/-- `FD_R43X6_QUAD_PERMUTE( r, imm0,imm1,imm2,imm3, P )` of the point at `p`: each vector loaded
into `x03 x14 x25` (through `g1 g2`, `p + 64` and `p + 128`), then shuffled by `m` into
`r03 r14 r25`. -/
def permuteLoadRun (m : Vector (Option (Fin (2 * 8))) 8) (p : Reg Γ .ptr)
    (x03 r03 x14 r14 x25 r25 pz : Dst Γ (.vec 8 64)) (g1 g2 : Dst Γ .ptr) : List (Instr Γ) :=
  [.load x03 p, .binop (.shufflevector m) r03 (.val x03.i x03.h) (.val pz.i pz.h),
    .unop (.gepConst { nusw := true, nuw := true } 64) g1 p, .load x14 (.val g1.i g1.h),
    .binop (.shufflevector m) r14 (.val x14.i x14.h) (.val pz.i pz.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g2 p, .load x25 (.val g2.i g2.h),
    .binop (.shufflevector m) r25 (.val x25.i x25.h) (.val pz.i pz.h)]

/-- Where the body at `pos` is `permuteLoadRun` by `permMask imm` and `p` holds the point `P`:
running on from `pos` then `g` gives `K` if it does from `pos + 8` with `P`'s vectors (as
`l03 l14 l25`) in `x03 x14 x25` and their `permute imm` (as `p03 p14 p25`) in `r03 r14 r25`. -/
theorem runBodyFrom_permuteLoadRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8} {p : Reg Γ .ptr}
    {x03 r03 x14 r14 x25 r25 pz : Dst Γ (.vec 8 64)} {g1 g2 : Dst Γ .ptr} {rest : List (Instr Γ)}
    {P : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteLoadRun m p x03 r03 x14 r14 x25 r25 pz g1 g2 ++ rest)
    (hp : E.read p = .value P) (hP : S.mem.QuadFit P) (hm : m = permMask i0 i1 i2 i3)
    (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (hpg : p ≠ .val g1.i g1.h)
    (hd : [x03.i, r03.i, x14.i, r14.i, x25.i, pz.i].Nodup)
    (hK :
      ∀ (l03 l14 l25 p03 p14 p25 : Wwl) (_hx : S.mem.readQuad P = ⟨l03, l14, l25⟩)
        (_hp : Quad.permute i0 i1 i2 i3 ⟨l03, l14, l25⟩ = ⟨p03, p14, p25⟩),
        (blk.runBodyFrom
              E[x03 := Ty.wrap l03, r03 := Ty.wrap p03, g1 := .value (P.add 64#64), x14 :=
                Ty.wrap l14, r14 := Ty.wrap p14, g2 := .value (P.add 128#64), x25 := Ty.wrap l25,
                r25 := Ty.wrap p25]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load with ql03
  step_pure [shufflevector_permMask hm hi] with q03
  step_pure
  step_load with ql14
  step_pure [shufflevector_permMask hm hi] with q14
  step_pure
  step_load with ql25
  step_pure [shufflevector_permMask hm hi] with q25
  have e : Quad.permute i0 i1 i2 i3 ⟨ql03, ql14, ql25⟩ = ⟨q03, q14, q25⟩ := by
    rw [Quad.permute_eq_perm4 hi, hq03, hq14, hq25]
    rfl
  rw [hE, hS]
  exact
    hK _ _ _ _ _ _
      (by
        rw [hql03, hql14, hql25]; rfl)
      e

/-- `runBodyFrom_permuteLoadRun` by `permPoisonMask imm s`: `r03 r14 r25` get the lanes of the
permuted vectors where `sj ≠ 0`, poison elsewhere. -/
theorem runBodyFrom_permuteLoadRun_poison (i0 i1 i2 i3 s0 s1 s2 s3 : Nat)
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {p : Reg Γ .ptr} {x03 r03 x14 r14 x25 r25 pz : Dst Γ (.vec 8 64)} {g1 g2 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {P : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteLoadRun m p x03 r03 x14 r14 x25 r25 pz g1 g2 ++ rest)
    (hp : E.read p = .value P) (hP : S.mem.QuadFit P)
    (hm : m = permPoisonMask i0 i1 i2 i3 s0 s1 s2 s3) (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4)
    (hpg : p ≠ .val g1.i g1.h) (hd : [x03.i, r03.i, x14.i, r14.i, x25.i, pz.i].Nodup)
    (hK :
      ∀ (l03 l14 l25 : Wwl) (_hx : S.mem.readQuad P = ⟨l03, l14, l25⟩),
        (blk.runBodyFrom
              E[x03 := Ty.wrap l03, r03 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 l03), g1 :=
                .value (P.add 64#64), x14 := Ty.wrap l14, r14 :=
                selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 l14), g2 := .value (P.add 128#64),
                x25 := Ty.wrap l25, r25 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 l25)]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load with ql03
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure
  step_load with ql14
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure
  step_load with ql25
  step_pure [shufflevector_permPoisonMask hm hi]
  rw [hE, hS]
  exact
    hK _ _ _
      (by
        rw [hql03, hql14, hql25]; rfl)

/-- `FD_R43X6_QUAD_LANE_SUB_FAST( r, t, imm, t, x )` on a `t` permuted from `x`, the permute fused
in: `t - x` into `d03 d14 d25`, plus `p`'s limbs in `k03 k14 k25` into `e03 e14 e25`, selected
against `x` into `r03 r14 r25` by shuffles (mask `m`) that permute `x`'s lanes. -/
def laneSubPermRun (m : Vector (Option (Fin (2 * 8))) 8)
    (t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.sub {})) d03 (.val t03.i t03.h) (.val x03.i x03.h),
    .binop (.vector (.add {})) e03 (.val d03.i d03.h) (.val k03.i k03.h),
    .binop (.shufflevector m) r03 (.val e03.i e03.h) (.val x03.i x03.h),
    .binop (.vector (.sub {})) d14 (.val t14.i t14.h) (.val x14.i x14.h),
    .binop (.vector (.add {})) e14 (.val d14.i d14.h) (.val k14.i k14.h),
    .binop (.shufflevector m) r14 (.val e14.i e14.h) (.val x14.i x14.h),
    .binop (.vector (.sub {})) d25 (.val t25.i t25.h) (.val x25.i x25.h),
    .binop (.vector (.add {})) e25 (.val d25.i d25.h) (.val k25.i k25.h),
    .binop (.shufflevector m) r25 (.val e25.i e25.h) (.val x25.i x25.h)]

/-- Where the body at `pos` is `laneSubPermRun` by `permSelMask imm s`, `t03 t14 t25` hold the lanes
`selPoison s` keeps of `X.permute imm`, `x03 x14 x25` hold `X` and `k03 k14 k25` `p`'s limbs there:
running on from `pos` then `g` gives `K` if it does from `pos + 9` with `T.laneSubFast s T X` for
`T = X.permute imm` (as `s03 s14 s25`) in `r03 r14 r25`. -/
theorem runBodyFrom_laneSubPermRun (i0 i1 i2 i3 s0 s1 s2 s3 : Nat) {blk : BasicBlock Γ tRets bp}
    {E : ⟪Γ⟫} {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneSubPermRun m t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25
            r25 ++ rest)
    (ht : E.read (.val t03.i t03.h) = selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X03) ∧
      E.read (.val t14.i t14.h) = selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X14) ∧
      E.read (.val t25.i t25.h) = selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X25))
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hk : E.read (.val k03.i k03.h) = selPoison s0 s1 s2 s3 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison s0 s1 s2 s3 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison s0 s1 s2 s3 quadP.P25)
    (hm : m = permSelMask i0 i1 i2 i3 s0 s1 s2 s3) (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4)
    (hs : s0 ≤ 1 ∧ s1 ≤ 1 ∧ s2 ≤ 1 ∧ s3 ≤ 1)
    (hd :
      [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, d03.i, e03.i, r03.i, d14.i,
          e14.i, r14.i, d25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 ve03 vd14 ve14 vd25 ve25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneSubFast (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩) s0 s1 s2 s3
              (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, e03 := ve03, r03 := Ty.wrap s03, d14 := vd14, e14 := ve14,
                r14 := Ty.wrap s14, d25 := vd25, e25 := ve25, r25 := Ty.wrap s25] (pos + 9) S >>=
            g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hf : ({} : OverflowFlags).nsw = true → ∀ k : Fin 8, False := fun h => absurd h (by decide)
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [shufflevector_permSelMask hm hi] with ss03
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [shufflevector_permSelMask hm hi] with ss14
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ (fun h => (hf h 0).elim) rfl]
  step_pure [shufflevector_permSelMask hm hi] with ss25
  have e :
      Quad.laneSubFast (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩) s0 s1 s2 s3
          (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneSubFast_sel hs, Quad.permute_eq_perm4 hi, hss03, hss14, hss25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ e

/-- `FD_R43X6_QUAD_PERMUTE( t, 1,0,3,2, x )`, `LANE_SUB_FAST( t, t, 1,0,0,1, t, x )` and
`LANE_ADD_FAST( t, t, 0,1,1,0, t, x )` fused: the permuted lanes `LANE_SUB` uses into
`p03 p14 p25` (mask `m1`), less `x` into `d03 d14 d25` (flags `fs`), plus `p`'s limbs in
`k03 k14 k25` into `e03 e14 e25` (flags `fa`); the permuted lanes `LANE_ADD` uses into
`w03 w14 w25` (mask `m2`), plus `x` into `a03 a14 a25` (flags `f03 f14 f25`); the two selected
into `r03 r14 r25` (mask `m3`). -/
def permSubAddRun (m1 m2 m3 : Vector (Option (Fin (2 * 8))) 8) (fs fa f03 f14 f25 : OverflowFlags)
    (x03 x14 x25 pz k03 k14 k25 p03 p14 p25 d03 e03 w03 d14 e14 w14 d25 e25 w25 a03 r03 a14 r14 a25
      r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.shufflevector m1) p03 (.val x03.i x03.h) (.val pz.i pz.h),
    .binop (.shufflevector m1) p14 (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.shufflevector m1) p25 (.val x25.i x25.h) (.val pz.i pz.h),
    .binop (.vector (.sub fs)) d03 (.val p03.i p03.h) (.val x03.i x03.h),
    .binop (.vector (.add fa)) e03 (.val d03.i d03.h) (.val k03.i k03.h),
    .binop (.shufflevector m2) w03 (.val x03.i x03.h) (.val pz.i pz.h),
    .binop (.vector (.sub fs)) d14 (.val p14.i p14.h) (.val x14.i x14.h),
    .binop (.vector (.add fa)) e14 (.val d14.i d14.h) (.val k14.i k14.h),
    .binop (.shufflevector m2) w14 (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.vector (.sub fs)) d25 (.val p25.i p25.h) (.val x25.i x25.h),
    .binop (.vector (.add fa)) e25 (.val d25.i d25.h) (.val k25.i k25.h),
    .binop (.shufflevector m2) w25 (.val x25.i x25.h) (.val pz.i pz.h),
    .binop (.vector (.add f03)) a03 (.val w03.i w03.h) (.val x03.i x03.h),
    .binop (.shufflevector m3) r03 (.val e03.i e03.h) (.val a03.i a03.h),
    .binop (.vector (.add f14)) a14 (.val w14.i w14.h) (.val x14.i x14.h),
    .binop (.shufflevector m3) r14 (.val e14.i e14.h) (.val a14.i a14.h),
    .binop (.vector (.add f25)) a25 (.val w25.i w25.h) (.val x25.i x25.h),
    .binop (.shufflevector m3) r25 (.val e25.i e25.h) (.val a25.i a25.h)]

/-- Where the body at `pos` is `permSubAddRun` by `permPoisonMask 1 0 3 2 1 0 0 1`,
`permPoisonMask 1 0 3 2 0 1 1 0` and `selMask 0 1 1 0`,
`x03 x14 x25` hold `X` and `k03 k14 k25` `p`'s limbs in lanes 0, 3 (no lane overflowing as a set
flag forbids): running on from `pos` then `g` gives `K` if it does from `pos + 18` with
`T.laneAddFast 0 1 1 0 T X` for `T = (X.permute 1 0 3 2).laneSubFast 1 0 0 1 … X` (as
`s03 s14 s25`) in `r03 r14 r25`. -/
theorem runBodyFrom_permSubAddRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {m1 m2 m3 : Vector (Option (Fin (2 * 8))) 8} {fs fa f03 f14 f25 : OverflowFlags}
    {x03 x14 x25 pz k03 k14 k25 p03 p14 p25 d03 e03 w03 d14 e14 w14 d25 e25 w25 a03 r03 a14 r14
      a25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        permSubAddRun m1 m2 m3 fs fa f03 f14 f25 x03 x14 x25 pz k03 k14 k25 p03 p14 p25 d03 e03
            w03 d14 e14 w14 d25 e25 w25 a03 r03 a14 r14 a25 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hk : E.read (.val k03.i k03.h) = selPoison 1 0 0 1 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison 1 0 0 1 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison 1 0 0 1 quadP.P25)
    (hm1 : m1 = permPoisonMask 1 0 3 2 1 0 0 1)
    (hm2 : m2 = permPoisonMask 1 0 3 2 0 1 1 0) (hm3 : m3 = selMask 0 1 1 0)
    (hf : fs.nuw = false ∧ fa.nuw = false ∧ f03.nuw = false ∧ f14.nuw = false ∧ f25.nuw = false)
    (hs03 : fs.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X03)[k].ssubOverflow X03[k] = false)
    (hs14 : fs.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X14)[k].ssubOverflow X14[k] = false)
    (hs25 : fs.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X25)[k].ssubOverflow X25[k] = false)
    (ha03 : fa.nsw = true → ∀ k : Fin 8,
      (wwl_sub (wwl_perm4 1 0 3 2 X03) X03)[k].saddOverflow quadP.P03[k] = false)
    (ha14 : fa.nsw = true → ∀ k : Fin 8,
      (wwl_sub (wwl_perm4 1 0 3 2 X14) X14)[k].saddOverflow quadP.P14[k] = false)
    (ha25 : fa.nsw = true → ∀ k : Fin 8,
      (wwl_sub (wwl_perm4 1 0 3 2 X25) X25)[k].saddOverflow quadP.P25[k] = false)
    (ho03 : f03.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X03)[k].saddOverflow X03[k] = false)
    (ho14 : f14.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X14)[k].saddOverflow X14[k] = false)
    (ho25 : f25.nsw = true → ∀ k : Fin 8, (wwl_perm4 1 0 3 2 X25)[k].saddOverflow X25[k] = false)
    (hd :
      [x03.i, x14.i, x25.i, pz.i, k03.i, k14.i, k25.i, p03.i, p14.i, p25.i, d03.i, e03.i, w03.i,
          d14.i, e14.i, w14.i, d25.i, e25.i, w25.i, a03.i, r03.i, a14.i, r14.i, a25.i].Nodup)
    (hK :
      ∀ (vp03 vp14 vp25 vd03 ve03 vw03 vd14 ve14 vw14 vd25 ve25 vw25 va03 va14 va25 :
          ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneAddFast
              (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
                (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) 0 1 1 0
              (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
                (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[p03 := vp03, p14 := vp14, p25 := vp25, d03 := vd03, e03 := ve03, w03 := vw03,
                d14 := vd14, e14 := ve14, w14 := vw14, d25 := vd25, e25 := ve25, w25 := vw25,
                a03 := va03, r03 := Ty.wrap s03, a14 := va14, r14 := Ty.wrap s14, a25 := va25,
                r25 := Ty.wrap s25] (pos + 18) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hfs, hfa, hf03, hf14, hf25⟩ := hf
  step_pure [shufflevector_permPoisonMask hm1 (by decide)]
  step_pure [shufflevector_permPoisonMask hm1 (by decide)]
  step_pure [shufflevector_permPoisonMask hm1 (by decide)]
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ hs03 hfs]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ ha03 hfa]
  step_pure [shufflevector_permPoisonMask hm2 (by decide)]
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ hs14 hfs]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ ha14 hfa]
  step_pure [shufflevector_permPoisonMask hm2 (by decide)]
  step_pure [zipWith_selPoison_sub _ _ _ _ _ _ hs25 hfs]
  step_pure [zipWith_selPoison_add_selPoison _ _ _ _ _ _ ha25 hfa]
  step_pure [shufflevector_permPoisonMask hm2 (by decide)]
  step_pure [zipWith_selPoison_add _ _ _ _ _ _ ho03 hf03]
  step_pure [shufflevector_selMask_selPoison (t0 := 1) (t1 := 0) (t2 := 0) (t3 := 1) hm3
      (by decide)] with ss03
  step_pure [zipWith_selPoison_add _ _ _ _ _ _ ho14 hf14]
  step_pure [shufflevector_selMask_selPoison (t0 := 1) (t1 := 0) (t2 := 0) (t3 := 1) hm3
      (by decide)] with ss14
  step_pure [zipWith_selPoison_add _ _ _ _ _ _ ho25 hf25]
  step_pure [shufflevector_selMask_selPoison (t0 := 1) (t1 := 0) (t2 := 0) (t3 := 1) hm3
      (by decide)] with ss25
  have e :
      Quad.laneAddFast
          (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
            (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) 0 1 1 0
          (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
            (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneAddFast_sel (by decide), Quad.laneSubFast_sel (by decide), Quad.permute_1032]
    simp only [Quad.perm4, lane_sel_sub_add, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- The point at `p` loaded into `x03 x14 x25`, through `g1 g2` (`p + 64` and `p + 128`). -/
def quadLoadRun (p : Reg Γ .ptr) (x03 x14 x25 : Dst Γ (.vec 8 64)) (g1 g2 : Dst Γ .ptr) :
    List (Instr Γ) :=
  [.load x03 p, .unop (.gepConst { nusw := true, nuw := true } 64) g1 p, .load x14 (.val g1.i g1.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g2 p, .load x25 (.val g2.i g2.h)]

/-- Where the body at `pos` is `quadLoadRun` and `p` holds the point `P`: running on from `pos`
then `g` gives `K` if it does from `pos + 5` with `P`'s vectors (as `l03 l14 l25`) in
`x03 x14 x25`. -/
theorem runBodyFrom_quadLoadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {p : Reg Γ .ptr}
    {x03 x14 x25 : Dst Γ (.vec 8 64)} {g1 g2 : Dst Γ .ptr} {rest : List (Instr Γ)} {P : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = quadLoadRun p x03 x14 x25 g1 g2 ++ rest) (hp : E.read p = .value P)
    (hP : S.mem.QuadFit P) (hpg : p ≠ .val g1.i g1.h)
    (hK :
      ∀ (l03 l14 l25 : Wwl) (_hx : S.mem.readQuad P = ⟨l03, l14, l25⟩),
        (blk.runBodyFrom
              E[x03 := Ty.wrap l03, g1 := .value (P.add 64#64), x14 := Ty.wrap l14, g2 :=
                .value (P.add 128#64), x25 := Ty.wrap l25]
              (pos + 5) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load with ql03
  step_pure
  step_load with ql14
  step_pure
  step_load with ql25
  rw [hE, hS]
  exact
    hK ql03 ql14 ql25
      (by
        rw [hql03, hql14, hql25]; rfl)

/-- `FD_R43X6_QUAD_MUL_FAST( q, x, y )` as compiled: `fd_r43x6_quad_mul_fast` into the slots
`z0 z1 z2`, then loaded into `q03 q14 q25`. -/
def mulRun (z0 z1 z2 : Dst Γ .ptr) (x03 x14 x25 y03 y14 y25 q03 q14 q25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 64, .lifetimeStart (.val z1.i z1.h) 64,
    .lifetimeStart (.val z2.i z2.h) 64,
    .call fd_r43x6_quad_mul_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val x03.i x03.h)
              (.cons (.val x14.i x14.h)
                (.cons (.val x25.i x25.h)
                  (.cons (.val y03.i y03.h)
                    (.cons (.val y14.i y14.h) (.cons (.val y25.i y25.h) .nil)))))))))
      .nil,
    .load q03 (.val z0.i z0.h), .load q14 (.val z1.i z1.h), .load q25 (.val z2.i z2.h),
    .lifetimeEnd (.val z2.i z2.h) 64, .lifetimeEnd (.val z1.i z1.h) 64,
    .lifetimeEnd (.val z0.i z0.h) 64]

/-- Where the body at `pos` is `mulRun`, `x03 x14 x25` hold `X`, `y03 y14 y25` hold `Y` and
`z0 z1 z2` three distinct writable slots: running on from `pos` then `g` gives `K` if it does from
`pos + 10` with `quadMul X Y` (as `m03 m14 m25`) in `q03 q14 q25` and left in the slots. -/
theorem runBodyFrom_mulRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 : Dst Γ .ptr} {x03 x14 x25 y03 y14 y25 q03 q14 q25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 Y03 Y14 Y25 : Wwl} {Z0 Z1 Z2 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = mulRun z0 z1 z2 x03 x14 x25 y03 y14 y25 q03 q14 q25 ++ rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, y03 := Y03, y14 := Y14, y25 := Y25, z0 := Z0, z1 :=
        Z1, z2 := Z2])
    (hwf : S.WF) (hZ : InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512)
    (hZw : Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2)
    (hne : Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id)
    (hK :
      ∀ (m03 m14 m25 : Wwl) (_hm : quadMul ⟨X03, X14, X25⟩ ⟨Y03, Y14, Y25⟩ = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom E[q03 := Ty.wrap m03, q14 := Ty.wrap m14, q25 := Ty.wrap m25] (pos + 10)
              { alloc := S.alloc,
                mem :=
                  ((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart Z2).storeVec Z0
                                        m03).storeVec
                                    Z1 m14).storeVec
                                Z2 m25).lifetimeEnd
                            Z2).lifetimeEnd
                        Z1).lifetimeEnd
                    Z0 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2⟩ := hZ
  obtain ⟨hw0, hw1, hw2⟩ := hZw
  obtain ⟨h01, h02, h12⟩ := hne
  iterate 3 step_pure
  step_call using fd_r43x6_quad_mul_fast.call_eq
  step_load with qm03
  step_load with qm14
  step_load with qm25
  iterate 3 step_pure
  have e : quadMul ⟨X03, X14, X25⟩ ⟨Y03, Y14, Y25⟩ = ⟨qm03, qm14, qm25⟩ := by
    rw [hqm03, hqm14, hqm25]
    rfl
  rw [hE, hS, ← hqm03, ← hqm14, ← hqm25]
  exact hK _ _ _ e

/-- `FD_R43X6_QUAD_SQR_FAST( q, x )` as compiled: `fd_r43x6_quad_sqr_fast` into the slots
`z0 z1 z2`, then loaded into `q03 q14 q25`. -/
def sqrRun (z0 z1 z2 : Dst Γ .ptr) (x03 x14 x25 q03 q14 q25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 64, .lifetimeStart (.val z1.i z1.h) 64,
    .lifetimeStart (.val z2.i z2.h) 64,
    .call fd_r43x6_quad_sqr_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val x03.i x03.h) (.cons (.val x14.i x14.h) (.cons (.val x25.i x25.h) .nil))))))
      .nil,
    .load q03 (.val z0.i z0.h), .load q14 (.val z1.i z1.h), .load q25 (.val z2.i z2.h),
    .lifetimeEnd (.val z2.i z2.h) 64, .lifetimeEnd (.val z1.i z1.h) 64,
    .lifetimeEnd (.val z0.i z0.h) 64]

/-- Where the body at `pos` is `sqrRun`, `x03 x14 x25` hold `X` and `z0 z1 z2` three distinct
writable slots: running on from `pos` then `g` gives `K` if it does from `pos + 10` with
`quadSqr X` (as `m03 m14 m25`) in `q03 q14 q25` and left in the slots. -/
theorem runBodyFrom_sqrRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 : Dst Γ .ptr} {x03 x14 x25 q03 q14 q25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {Z0 Z1 Z2 : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = sqrRun z0 z1 z2 x03 x14 x25 q03 q14 q25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25, z0 := Z0, z1 := Z1, z2 := Z2]) (hwf : S.WF)
    (hZ : InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512)
    (hZw : Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2)
    (hne : Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id)
    (hK :
      ∀ (m03 m14 m25 : Wwl) (_hm : quadSqr ⟨X03, X14, X25⟩ = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom E[q03 := Ty.wrap m03, q14 := Ty.wrap m14, q25 := Ty.wrap m25] (pos + 10)
              { alloc := S.alloc,
                mem :=
                  ((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart Z2).storeVec Z0
                                        m03).storeVec
                                    Z1 m14).storeVec
                                Z2 m25).lifetimeEnd
                            Z2).lifetimeEnd
                        Z1).lifetimeEnd
                    Z0 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2⟩ := hZ
  obtain ⟨hw0, hw1, hw2⟩ := hZw
  obtain ⟨h01, h02, h12⟩ := hne
  iterate 3 step_pure
  step_call using fd_r43x6_quad_sqr_fast.call_eq
  step_load with qm03
  step_load with qm14
  step_load with qm25
  iterate 3 step_pure
  have e : quadSqr ⟨X03, X14, X25⟩ = ⟨qm03, qm14, qm25⟩ := by
    rw [hqm03, hqm14, hqm25]
    rfl
  rw [hE, hS, ← hqm03, ← hqm14, ← hqm25]
  exact hK _ _ _ e

/-- A vector constant as the code builds it: the lanes `x0 … x7` inserted at the indices `k0 … k7`
through `v0 … v7`, into the shared undefined vector `u`. -/
def insertRun (u : Reg Γ (.vec 8 64)) (v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64))
    (x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)) (k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)) :
    List (Instr Γ) :=
  [.ternop .insertelement v0 u x0 k0, .ternop .insertelement v1 (.val v0.i v0.h) x1 k1,
    .ternop .insertelement v2 (.val v1.i v1.h) x2 k2,
    .ternop .insertelement v3 (.val v2.i v2.h) x3 k3,
    .ternop .insertelement v4 (.val v3.i v3.h) x4 k4,
    .ternop .insertelement v5 (.val v4.i v4.h) x5 k5,
    .ternop .insertelement v6 (.val v5.i v5.h) x6 k6,
    .ternop .insertelement v7 (.val v6.i v6.h) x7 k7]

/-- Where the body at `pos` is `insertRun`, `kj` holds `j` and `xj` the lane `Xj`: running on from
`pos` then `g` gives `K` if it does from `pos + 8` with `#v[X0, …, X7]` in `v7`. -/
theorem runBodyFrom_insertRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u : Reg Γ (.vec 8 64)} {v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64)}
    {x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)} {k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 X5 X6 X7 : ⟦.bv 64⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        insertRun u v0 v1 v2 v3 v4 v5 v6 v7 x0 x1 x2 x3 x4 x5 x6 x7 k0 k1 k2 k3 k4 k5 k6 k7 ++ rest)
    (hk :
      E ⊨ [k0 := 0#32, k1 := 1#32, k2 := 2#32, k3 := 3#32, k4 := 4#32, k5 := 5#32, k6 := 6#32,
        k7 := 7#32])
    (hx :
      E.read x0 = X0 ∧ E.read x1 = X1 ∧ E.read x2 = X2 ∧ E.read x3 = X3 ∧ E.read x4 = X4 ∧
        E.read x5 = X5 ∧ E.read x6 = X6 ∧ E.read x7 = X7)
    (hK :
      ∀ vv0 vv1 vv2 vv3 vv4 vv5 vv6 : ⟦.vec 8 64⟧,
        (blk.runBodyFrom
              E[v0 := vv0, v1 := vv1, v2 := vv2, v3 := vv3, v4 := vv4, v5 := vv5, v6 := vv6,
                v7 := #v[X0, X1, X2, X3, X4, X5, X6, X7]] (pos + 8) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 8 step_pure
  rw [hE, Vector.set_eight]
  exact hK _ _ _ _ _ _ _

/-- `FD_R43X6_GE_DBL` as compiled from `QUAD_SQR_FAST( _ta, _ta )` (`_ta` in `t03 t14 t25`,
squared through the slots `z0 z1 z2`) to `QUAD_MUL_FAST( _ta, _ta, _tb )` (through `z3 z4 z5`, into
`g03 g14 g25`): `s0010` holds the doubling's shifts, `pz` an unused operand, `k32 … k77` the lane
subtractions' `p` limbs, `nb03 … mk4340` the signed fold's constants. -/
def dblMidRun (z0 z1 z2 z3 z4 z5 : Dst Γ .ptr)
    (t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64))
    (nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64))
    (ua03 ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64))
    (wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64))
    (ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64))
    (fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64))
    (ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  sqrRun z0 z1 z2 t03 t14 t25 q03 q14 q25 ++
    [.binop (.vector (.shl {})) c03 (.val q03.i q03.h) (.val s0010.i s0010.h),
      .binop (.vector (.shl {})) c14 (.val q14.i q14.h) (.val s0010.i s0010.h),
      .binop (.vector (.shl {})) c25 (.val q25.i q25.h) (.val s0010.i s0010.h)] ++
    permuteRun (permMask 3 3 3 3) c03 c14 c25 pz pa03 pa14 pa25 ++
    permuteRun (permMask 1 1 1 1) c03 c14 c25 pz pb03 pb14 pb25 ++
    laneAddSubRun (selMask 0 1 1 0) pa03 pa14 pa25 pb03 pb14 pb25 k32 k41 k50 ua03 ua14 ua25 va03
      vb03 v03 va14 vb14 v14 va25 vb25 v25 ++
    laneAddRun (selMask 0 0 1 0) {} {} {} v03 v14 v25 c03 c14 c25 wa03 w03 wa14 w14 wa25 w25 ++
    laneSubRun (selMask 0 1 1 1) {} {} w03 w14 w25 c03 c14 c25 k59 k68 k77 ya03 yb03 y03 ya14 yb14
      y14 ya25 yb25 y25 ++
    foldSignedRun y03 y14 y25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 fd03 fd14 fd25 fh03 fh14
      fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 ++
    permuteRun (permMask 0 1 1 0) f03 f14 f25 pz ma03 ma14 ma25 ++
    permuteRun (permMask 2 3 2 3) f03 f14 f25 pz mb03 mb14 mb25 ++
    mulRun z3 z4 z5 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25

-- 79 instructions through ten nested patterns, two calls
set_option maxHeartbeats 600000 in
/-- Where the body at `pos` is `dblMidRun`, `t03 t14 t25` hold `T`, `z0 … z5` six distinct slots
and the others the constants: running on from `pos` then `g` gives `K` if it does from `pos + 79`
with `geDblMid quadMul quadSqr T` (as `d03 d14 d25`) in `g03 g14 g25`, the square (as
`s03 s14 s25`) and the result left in the slots. -/
theorem runBodyFrom_dblMidRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 z5 : Dst Γ .ptr}
    {t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64)}
    {nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64)}
    {ua03 ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64)}
    {wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64)}
    {ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64)}
    {fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64)}
    {ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 : Wwl} {Z0 Z1 Z2 Z3 Z4 Z5 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        dblMidRun z0 z1 z2 z3 z4 z5 t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 nb03 nb sh43
            sh4340 k19 mk43 b03 b mk4340 q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 ua03
            ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 wa03 w03 wa14 w14 wa25 w25 ya03
            yb03 y03 ya14 yb14 y14 ya25 yb25 y25 fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03
            fl14 fe14 f14 fl25 fe25 f25 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 ++ rest)
    (hR :
      E ⊨ [t03 := T03, t14 := T14, t25 := T25,
        s0010 := #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64], z0 := Z0, z1 := Z1,
        z2 := Z2, z3 := Z3, z4 := Z4, z5 := Z5])
    (hk :
      E.read (.val k32.i k32.h) = selPoison 0 1 1 0 quadP.P03 ∧
        E.read (.val k41.i k41.h) = selPoison 0 1 1 0 quadP.P14 ∧
        E.read (.val k50.i k50.h) = selPoison 0 1 1 0 quadP.P25 ∧
        E.read (.val k59.i k59.h) = selPoison 1 0 0 0 quadP.P03 ∧
        E.read (.val k68.i k68.h) = selPoison 1 0 0 0 quadP.P14 ∧
        E.read (.val k77.i k77.h) = selPoison 1 0 0 0 quadP.P25)
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hwf : S.WF)
    (hZ :
      InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512 ∧
        InBounds S.mem Z3 512 ∧ InBounds S.mem Z4 512 ∧ InBounds S.mem Z5 512)
    (hZw :
      Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2 ∧ Writable S.mem Z3 ∧
        Writable S.mem Z4 ∧ Writable S.mem Z5)
    (hne :
      Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id ∧ Z3.id ≠ Z4.id ∧ Z3.id ≠ Z5.id ∧
        Z4.id ≠ Z5.id)
    (hd :
      [z0.i, z1.i, z2.i, z3.i, z4.i, z5.i, t03.i, t14.i, t25.i, s0010.i, pz.i, k32.i, k41.i, k50.i,
          k59.i, k68.i, k77.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          q03.i, q14.i, q25.i, c03.i, c14.i, c25.i, pa03.i, pa14.i, pa25.i, pb03.i, pb14.i, pb25.i,
          ua03.i, ua14.i, ua25.i, va03.i, vb03.i, v03.i, va14.i, vb14.i,
          v14.i, va25.i, vb25.i, v25.i, wa03.i, w03.i, wa14.i, w14.i, wa25.i, w25.i, ya03.i,
          yb03.i, y03.i, ya14.i, yb14.i, y14.i, ya25.i, yb25.i, y25.i, fd03.i, fd14.i, fd25.i,
          fh03.i, fh14.i, fh25.i, fp.i, fl03.i, fc.i, fe03.i, f03.i, fl14.i, fe14.i, f14.i, fl25.i,
          fe25.i, f25.i, ma03.i, ma14.i, ma25.i, mb03.i, mb14.i, mb25.i, g03.i, g14.i].Nodup)
    (hd1 : [c03.i, c14.i, c25.i, pa03.i, pa14.i].Nodup)
    (hd2 : [c03.i, c14.i, c25.i, pb03.i, pb14.i].Nodup)
    (hd3 :
      [pa03.i, pa14.i, pa25.i, pb03.i, pb14.i, pb25.i, k32.i, k41.i, k50.i, ua03.i, ua14.i, ua25.i,
          va03.i, vb03.i, v03.i, va14.i, vb14.i, v14.i, va25.i, vb25.i].Nodup)
    (hd5 : [v03.i, v14.i, v25.i, c03.i, c14.i, c25.i, wa03.i, w03.i, wa14.i, w14.i, wa25.i].Nodup)
    (hd6 :
      [w03.i, w14.i, w25.i, c03.i, c14.i, c25.i, k59.i, k68.i, k77.i, ya03.i, yb03.i, y03.i,
          ya14.i, yb14.i, y14.i, ya25.i, yb25.i].Nodup)
    (hd7 :
      [y03.i, y14.i, y25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          fd03.i, fd14.i, fd25.i, fh03.i, fh14.i, fh25.i, fp.i, fl03.i, fc.i, fe03.i, f03.i, fl14.i,
          fe14.i, f14.i, fl25.i, fe25.i].Nodup)
    (hd8 : [f03.i, f14.i, f25.i, ma03.i, ma14.i].Nodup)
    (hd9 : [f03.i, f14.i, f25.i, mb03.i, mb14.i].Nodup)
    (hK :
      ∀ (vq03 vq14 vq25 vc03 vc14 vc25 vpa03 vpa14 vpa25 vpb03 vpb14 vpb25 : ⟦.vec 8 64⟧)
        (vua03 vua14 vua25 vva03 vvb03 vv03 vva14 vvb14 vv14 : ⟦.vec 8 64⟧)
        (vva25 vvb25 vv25 vwa03 vw03 vwa14 vw14 vwa25 vw25 : ⟦.vec 8 64⟧)
        (vya03 vyb03 vy03 vya14 vyb14 vy14 vya25 vyb25 vy25 : ⟦.vec 8 64⟧)
        (vfd03 vfd14 vfd25 vfh03 vfh14 vfh25 vfp vfl03 vfc vfe03 vf03 vfl14 : ⟦.vec 8 64⟧)
        (vfe14 vf14 vfl25 vfe25 vf25 vma03 vma14 vma25 vmb03 vmb14 vmb25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hsq : quadSqr ⟨T03, T14, T25⟩ = ⟨s03, s14, s25⟩) (d03 d14 d25 : Wwl)
        (_hdbl : geDblMid quadMul quadSqr ⟨T03, T14, T25⟩ = ⟨d03, d14, d25⟩),
        (blk.runBodyFrom
              E[q03 := vq03, q14 := vq14, q25 := vq25, c03 := vc03, c14 := vc14, c25 := vc25,
                pa03 := vpa03, pa14 := vpa14, pa25 := vpa25, pb03 := vpb03, pb14 := vpb14,
                pb25 := vpb25, ua03 := vua03, ua14 := vua14, ua25 := vua25, va03 := vva03,
                vb03 := vvb03, v03 := vv03,
                va14 := vva14, vb14 := vvb14, v14 := vv14, va25 := vva25, vb25 := vvb25,
                v25 := vv25, wa03 := vwa03, w03 := vw03, wa14 := vwa14, w14 := vw14,
                wa25 := vwa25, w25 := vw25, ya03 := vya03, yb03 := vyb03, y03 := vy03,
                ya14 := vya14, yb14 := vyb14, y14 := vy14, ya25 := vya25, yb25 := vyb25,
                y25 := vy25, fd03 := vfd03, fd14 := vfd14, fd25 := vfd25, fh03 := vfh03,
                fh14 := vfh14, fh25 := vfh25, fp := vfp, fl03 := vfl03, fc := vfc, fe03 := vfe03,
                f03 := vf03, fl14 := vfl14, fe14 := vfe14, f14 := vf14, fl25 := vfl25,
                fe25 := vfe25, f25 := vf25, ma03 := vma03, ma14 := vma14, ma25 := vma25,
                mb03 := vmb03, mb14 := vmb14, mb25 := vmb25, g03 := Ty.wrap d03,
                g14 := Ty.wrap d14, g25 := Ty.wrap d25]
              (pos + 79)
              { alloc := S.alloc,
                mem :=
                  (((((((((((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart
                                                          Z2).storeVec Z0 s03).storeVec Z1
                                                    s14).storeVec Z2 s25).lifetimeEnd
                                              Z2).lifetimeEnd Z1).lifetimeEnd Z0).lifetimeStart
                                      Z3).lifetimeStart Z4).lifetimeStart Z5).storeVec Z3
                              d03).storeVec Z4 d14).storeVec Z5 d25).lifetimeEnd Z5).lifetimeEnd
                      Z4).lifetimeEnd Z3 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hZ
  obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5⟩ := hZw
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta )
  step_pattern using runBodyFrom_sqrRun
  have e3 := _hm
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,0,1,0, _ta, _ta ): `Z` doubled by a shift
  step_pure with c03
  step_pure with c14
  step_pure with c25
  have e4 :
      Quad.laneAddFast ⟨m03, m14, m25⟩ 0 0 1 0 ⟨m03, m14, m25⟩ ⟨m03, m14, m25⟩ =
        ⟨c03, c14, c25⟩ := by
    rw [Quad.laneAddFast_0010_self, hc03, hc14, hc25]
  -- FD_R43X6_QUAD_PERMUTE( _tb, 3,3,3,3, _ta ); FD_R43X6_QUAD_PERMUTE( _BB, 1,1,1,1, _ta )
  step_pattern using runBodyFrom_permuteRun 3 3 3 3
  have e5 := _hp
  step_pattern using runBodyFrom_permuteRun 1 1 1 1
  have e6 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 1,0,0,1, _tb, _BB )
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 0,1,1,0, _tb, _BB ), merged into one select
  step_pattern using runBodyFrom_laneAddSubRun
  have e7 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,0,1,0, _tb, _ta )
  step_pattern using runBodyFrom_laneAddRun 0 0 1 0
  have e9 := _hl
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, _ta )
  step_pattern using runBodyFrom_laneSubRun 1 0 0 0
  have e10 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have e11 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,1,1,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 2,3,2,3, _tb )
  step_pattern using runBodyFrom_permuteRun 0 1 1 0
  have e12 := _hp
  step_pattern using runBodyFrom_permuteRun 2 3 2 3
  have e13 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e14 := _hm
  have e : geDblMid quadMul quadSqr ⟨T03, T14, T25⟩ = ⟨m03, m14, m25⟩ := by
    simp only [geDblMid, Quad.foldSigned_eq]
    rw [e3, e4, e5, e6, e7, e9, e10, e11, e12, e13, e14]
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e3 _ _ _ e

end Patterns

end

end MLIR

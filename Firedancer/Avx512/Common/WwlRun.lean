module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Vector
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.Avx512.Common.Wwl
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! The `Wwl` intrinsics as the steps produce them, slides with poison lanes, and `za + 152 zb`, the
reduction `fd_r43x6_mul_fast` and `fd_r43x6_sqr_fast` end with. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

/-- Lanes `0 … k-1` of `v`, the rest poison: a vector built by `insertelement`s into an undefined
one, or a shuffle's undefined lanes. -/
def lanesBelow (k : Nat) (v : Vector (BitVec 64) 8) : Vector (PoisonOr (BitVec 64)) 8 :=
  Vector.ofFn fun i => if i.val < k then .value v[i] else .poison

/-- Lanes `k …` of `v`, the rest poison. -/
def lanesFrom (k : Nat) (v : Vector (BitVec 64) 8) : Vector (PoisonOr (BitVec 64)) 8 :=
  Vector.ofFn fun i => if k ≤ i.val then .value v[i] else .poison

/-- Lanes `0 … 5` of `v`; lanes `6` and `7` poison. -/
abbrev low6 (v : Vector (BitVec 64) 8) : Vector (PoisonOr (BitVec 64)) 8 :=
  lanesBelow 6 v

/-- A slide equation, lane by lane. -/
local macro "slide_lanes" : tactic =>
  `(tactic|
    ( apply vec_ext_fin
      intro i
      fin_cases i <;> simp [wwl_slide, lanesBelow]))

/-! ### The intrinsics from their lanes, as the steps give them -/

@[mlir_operation]
theorem wwl_add_ofFn (a b : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i => a[i.1] + b[i.1]) = wwl_add a b := by simp [wwl_add]

@[mlir_operation]
theorem wwl_sub_ofFn (a b : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i => a[i.1] - b[i.1]) = wwl_sub a b := by simp [wwl_sub]

@[mlir_operation]
theorem wwl_and_ofFn (a b : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i => a[i.1] &&& b[i.1]) = wwl_and a b := by simp [wwl_and]

@[mlir_operation]
theorem wwl_shl_ofFn (a : Vector (BitVec 64) 8) (n : Nat) :
    (Vector.ofFn fun i => a[i.1] <<< n) = wwl_shl a n := by simp [wwl_shl]

theorem wwl_add_getElem (a b : Vector (BitVec 64) 8) (i : Nat) (h : i < 8) :
    a[i] + b[i] = (wwl_add a b)[i] := by simp [wwl_add]

instance : Std.Associative wwl_add :=
  ⟨fun a b c => by
    ext i hi : 1; simp [wwl_add, BitVec.add_assoc]⟩

instance : Std.Commutative wwl_add :=
  ⟨fun a b => by
    ext i hi : 1; simp [wwl_add, BitVec.add_comm]⟩

instance : Std.Associative wwl_and :=
  ⟨fun a b c => by
    ext i hi : 1; simp [wwl_and, BitVec.and_assoc]⟩

instance : Std.Commutative wwl_and :=
  ⟨fun a b => by
    ext i hi : 1; simp [wwl_and, BitVec.and_comm]⟩

theorem lanesBelow_getElem (v : Vector (BitVec 64) 8) (i : Nat) (h : i < 8) :
    (lanesBelow k v)[i] = if i < k then .value v[i] else .poison := by simp [lanesBelow]

theorem lanesFrom_getElem (v : Vector (BitVec 64) 8) (i : Nat) (h : i < 8) :
    (lanesFrom k v)[i] = if k ≤ i then .value v[i] else .poison := by simp [lanesFrom]

/-- An `and` with a mask defined on lanes `0 … k-1`. -/
@[mlir_operation]
theorem ofFn_and_lanesBelow (p m : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i => do
        let b ← (lanesBelow k m)[i.1]
        PoisonOr.value (p[i.1] &&& b)) =
      lanesBelow k (wwl_and p m) := by
  ext i hi : 1; simp [lanesBelow, wwl_and]

/-- An add of two vectors defined on lanes `0 … k-1`. -/
@[mlir_operation]
theorem ofFn_add_lanesBelow (x y : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i => do
        let a ← (lanesBelow k x)[i.1]
        let b ← (lanesBelow k y)[i.1]
        PoisonOr.value (a + b)) =
      lanesBelow k (wwl_add x y) := by
  ext i hi : 1; simp [lanesBelow, wwl_add]; omega

/-! ### Slides as the shuffles give them, lane by lane -/

@[mlir_operation]
theorem wwl_slide_zero_7 (v : Vector (BitVec 64) 8) :
    #v[0#64, v[0], v[1], v[2], v[3], v[4], v[5], v[6]] = wwl_slide wwl_zero v 7 := by slide_lanes

@[mlir_operation]
theorem wwl_slide_zero_6 (v : Vector (BitVec 64) 8) :
    #v[0#64, 0#64, v[0], v[1], v[2], v[3], v[4], v[5]] = wwl_slide wwl_zero v 6 := by slide_lanes

@[mlir_operation]
theorem wwl_slide_zero_5 (v : Vector (BitVec 64) 8) :
    #v[0#64, 0#64, 0#64, v[0], v[1], v[2], v[3], v[4]] = wwl_slide wwl_zero v 5 := by slide_lanes

@[mlir_operation]
theorem wwl_slide_zero_4 (v : Vector (BitVec 64) 8) :
    #v[0#64, 0#64, 0#64, 0#64, v[0], v[1], v[2], v[3]] = wwl_slide wwl_zero v 4 := by slide_lanes

@[mlir_operation]
theorem wwl_slide_zero_3 (v : Vector (BitVec 64) 8) :
    #v[0#64, 0#64, 0#64, 0#64, 0#64, v[0], v[1], v[2]] = wwl_slide wwl_zero v 3 := by slide_lanes

@[mlir_operation]
theorem wwl_slide_zero_2 (v : Vector (BitVec 64) 8) :
    #v[0#64, 0#64, 0#64, 0#64, 0#64, 0#64, v[0], v[1]] = wwl_slide wwl_zero v 2 := by slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_zero_7 (v : Vector (BitVec 64) 8) :
    #v[.value 0#64, .value v[0], .value v[1], .value v[2], .value v[3], .value v[4],
        .poison, .poison] =
      low6 (wwl_slide wwl_zero v 7) := by
  slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_7_zero (v : Vector (BitVec 64) 8) :
    #v[.value v[7], .value 0#64, .value 0#64, .value 0#64, .value 0#64, .value 0#64,
        .poison, .poison] =
      low6 (wwl_slide v wwl_zero 7) := by
  slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_5_zero (v : Vector (BitVec 64) 8) :
    #v[.value v[5], .value v[6], .value v[7], .value 0#64, .value 0#64, .value 0#64,
        .poison, .poison] =
      low6 (wwl_slide v wwl_zero 5) := by
  slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_4_zero (v : Vector (BitVec 64) 8) :
    #v[.value v[4], .value v[5], .value v[6], .value v[7], .value 0#64, .value 0#64,
        .poison, .poison] =
      low6 (wwl_slide v wwl_zero 4) := by
  slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_3_zero (v : Vector (BitVec 64) 8) :
    #v[.value v[3], .value v[4], .value v[5], .value v[6], .value v[7], .value 0#64,
        .poison, .poison] =
      low6 (wwl_slide v wwl_zero 3) := by
  slide_lanes

@[mlir_operation]
theorem low6_wwl_slide_2_zero (v : Vector (BitVec 64) 8) :
    #v[.value v[2], .value v[3], .value v[4], .value v[5], .value v[6], .value v[7],
        .poison, .poison] =
      low6 (wwl_slide v wwl_zero 2) := by
  slide_lanes

/-- `za + 152 zb` from the sums `zl` and `zh`: `za` is `zl`'s lanes `0 … 5`, `zb` lanes `6 …` of
`zl` then `zh`, and `152 zb` is by shifts. -/
def fold152 (zl zh : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let za := wwl_and zl #v[-1, -1, -1, -1, -1, -1, 0, 0]
  let zb := wwl_slide zl zh 6
  wwl_add (wwl_add za (wwl_shl zb 7)) (wwl_add (wwl_shl zb 4) (wwl_shl zb 3))

/-- `152 b` by shifts, as written and as compiled. -/
theorem add_mul152 (a b : BitVec 64) :
    a + b <<< 7 + (b <<< 4 + b <<< 3) = b <<< 7 + a + b * 24 := by bv_decide

/-- `24 b` by shifts, as compiled and as written. -/
theorem mul24_eq_shl (b : BitVec 64) : b * 24#64 = b <<< 4 + b <<< 3 := by
  bv_decide

/-- `fold152` as compiled, six instructions: `zb << 7`, plus `za`, plus `24 zb`, through
`za zb b7 s7 b24` into `r`. -/
def fold152Run (zl zh mask c7 c24 : Dst Γ V) (za zb b7 s7 b24 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector .and) za (.val zl.i zl.h) (.val mask.i mask.h),
    .binop (.shufflevector #v[some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13])
      zb (.val zl.i zl.h) (.val zh.i zh.h),
    .binop (.vector (.shl {})) b7 (.val zb.i zb.h) (.val c7.i c7.h),
    .binop (.vector (.add {})) s7 (.val b7.i b7.h) (.val za.i za.h),
    .binop (.vector (.mul {})) b24 (.val zb.i zb.h) (.val c24.i c24.h),
    .binop (.vector (.add {})) r (.val s7.i s7.h) (.val b24.i b24.h)]

/-- Where the body at `pos` is `fold152Run`, `zl` holds `ZL` and `zh` lanes `0 … 5` of `ZH`: `r`
gets `fold152 ZL ZH`. -/
theorem runBodyFrom_fold152Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {zl zh mask c7 c24 za zb b7 s7 b24 r : Dst Γ V} {rest : List (Instr Γ)}
    {ZL ZH : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = fold152Run zl zh mask c7 c24 za zb b7 s7 b24 r ++ rest)
    (hR :
      E ⊨ [zl := ZL, zh := low6 ZH, mask := #v[-1, -1, -1, -1, -1, -1, 0, 0], c7 :=
        Vector.replicate 8 7, c24 := Vector.replicate 8 24])
    (hd : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hK :
      ∀ vza vzb vb7 vs7 vb24 : ⟦V⟧,
        (blk.runBodyFrom
              E[za := vza, zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24, r :=
                Ty.wrap (fold152 ZL ZH)]
              (pos + 6) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vza
  step_pure [lanesBelow_getElem] with transparent vzb
  step_pure with transparent vb7
  step_pure with transparent vs7
  step_pure with transparent vb24
  step_pure with vr
  have e : vr = fold152 ZL ZH := by
    rw [hvr]
    apply vec_ext_fin
    intro i
    fin_cases i <;> simp [fold152, wwl_and, wwl_add, wwl_shl, wwl_slide, add_mul152]
  rw [hE, e]
  exact hK _ _ _ _ _

end

end MLIR.Firedancer.Avx512

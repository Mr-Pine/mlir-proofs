module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_with_opts
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `A + B`: `FD_R43X6_GE_ADD_TABLE_ALT` when `b_is_precomputed`, else `FD_R43X6_GE_ADD`;
`b_Z_is_one` and `skip_last_mul` are unused. -/
def fd_ed25519_point_add_with_opts.spec (A B : Quad) (b_is_precomputed : BitVec 32) : Quad :=
  if b_is_precomputed ≠ 0 then geAddTable quadMul A B else geAdd quadMul A B

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_add_with_opts

attribute [-mlir_operation] zipWith_eq_ofFn
attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap
  zipWith_mul_wrap zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap
  zipWith_add_nsw_nuw_wrap zipWith_sub_nsw_wrap

set_option hygiene false in
/-- One lane of a `selPoison` operation: both cases of its flag `i`. -/
local macro "sel_lane " i:ident : tactic =>
  `(tactic| (rcases $i:ident with _ | _ <;>
      simp only [selPoison, selV, Vector.getElem_zipWith, Operation.add, Operation.sub,
        Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
        Ty.wrap_vec, Vector.getElem_map, Bool.false_eq_true, false_and, true_and, ↓reduceIte,
        PoisonOr.pure_def, PoisonOr.poison_bind, PoisonOr.value_bind, wwl_add, wwl_sub,
        Vector.getElem_ofFn, Fin.getElem_fin, *]))

set_option hygiene false in
/-- A shuffle by a literal mask, lane by lane. -/
local macro "shuffle_lanes" : tactic =>
  `(tactic| (
    ext k hk
    obtain _|_|_|_|_|_|_|_|k := k
    all_goals
      first
      | omega
      | simp [Operation.shufflevector, selPoison, selV, wwl_perm4, wwl_lane_sel, selMask, selLane,
          Ty.wrap_vec]))

/-- `a - x` on the lanes `selPoison` keeps, under the flags `f`. -/
theorem zipWith_sub_selPoison (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (a x : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, a[k].ssubOverflow x[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.sub f (w := 64)) (selPoison i0 i1 i2 i3 a)
        (Ty.wrap (t := .vec 8 64) x) =
      selPoison i0 i1 i2 i3 (wwl_sub a x) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _|_|_|_|_|_|_|_|k := k
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
    obtain _|_|_|_|_|_|_|_|k := k
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
theorem zipWith_add_selPoison_wrap (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (a x : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, a[k].saddOverflow x[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (selPoison i0 i1 i2 i3 a)
        (Ty.wrap (t := .vec 8 64) x) =
      selPoison i0 i1 i2 i3 (wwl_add a x) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _|_|_|_|_|_|_|_|k := k
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
    obtain _|_|_|_|_|_|_|_|k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- `d + v` on the lanes both `selPoison`s keep, under the flags `f`. -/
theorem zipWith_add_selPoison₂ (i0 i1 i2 i3 : Nat) {f : OverflowFlags} (d v : Wwl)
    (hs : f.nsw = true → ∀ k : Fin 8, d[k].saddOverflow v[k] = false) (hu : f.nuw = false) :
    Vector.zipWith (Operation.add f (w := 64)) (selPoison i0 i1 i2 i3 d)
        (selPoison i0 i1 i2 i3 v) =
      selPoison i0 i1 i2 i3 (wwl_add d v) := by
  rcases f with ⟨_ | _, _ | _⟩ <;> simp only [Bool.true_eq_false] at hu
  · ext k hk
    obtain _|_|_|_|_|_|_|_|k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega
  · have h0 : d[0].saddOverflow v[0] = false := hs rfl 0
    have h1 : d[1].saddOverflow v[1] = false := hs rfl 1
    have h2 : d[2].saddOverflow v[2] = false := hs rfl 2
    have h3 : d[3].saddOverflow v[3] = false := hs rfl 3
    have h4 : d[4].saddOverflow v[4] = false := hs rfl 4
    have h5 : d[5].saddOverflow v[5] = false := hs rfl 5
    have h6 : d[6].saddOverflow v[6] = false := hs rfl 6
    have h7 : d[7].saddOverflow v[7] = false := hs rfl 7
    clear hs
    ext k hk
    obtain _|_|_|_|_|_|_|_|k := k
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · sel_lane i0
    · sel_lane i1
    · sel_lane i2
    · sel_lane i3
    · omega

/-- `FD_R43X6_QUAD_PERMUTE( 1,0,2,3 )` where only lanes 0, 4 are used. -/
abbrev mask1000 : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 1, none, none, none, some 5, none, none, none]

/-- `FD_R43X6_QUAD_PERMUTE( 1,0,3,2 )` where only lanes 0, 3, 4, 7 are used. -/
abbrev mask1001 : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 1, none, none, some 2, some 5, none, none, some 6]

/-- `FD_R43X6_QUAD_PERMUTE( 1,0,3,2 )` where only lanes 1, 2, 5, 6 are used. -/
abbrev mask0110 : Vector (Option (Fin (2 * 8))) 8 :=
  #v[none, some 0, some 3, none, none, some 4, some 7, none]

/-- `selMask 1 0 0 0` against `PERMUTE( 1,0,2,3 )` of the second operand. -/
abbrev maskSel1000 : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 0, some 8, some 10, some 11, some 4, some 12, some 14, some 15]

/-- A shuffle by `mask1000`: lanes 0, 4 of `wwl_perm4 1 0 2 3 x`, the others poison. -/
theorem shufflevector_mask1000 {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = mask1000)
    (x : Wwl) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 x) := by
  subst hm
  shuffle_lanes

/-- A shuffle by `mask1001`: lanes 0, 3, 4, 7 of `wwl_perm4 1 0 3 2 x`, the others poison. -/
theorem shufflevector_mask1001 {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = mask1001)
    (x : Wwl) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      selPoison 1 0 0 1 (wwl_perm4 1 0 3 2 x) := by
  subst hm
  shuffle_lanes

/-- A shuffle by `mask0110`: lanes 1, 2, 5, 6 of `wwl_perm4 1 0 3 2 x`, the others poison. -/
theorem shufflevector_mask0110 {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = mask0110)
    (x : Wwl) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      selPoison 0 1 1 0 (wwl_perm4 1 0 3 2 x) := by
  subst hm
  shuffle_lanes

/-- A shuffle by `maskSel1000`: `v`'s lanes 0, 4, `wwl_perm4 1 0 2 3 x`'s elsewhere. -/
theorem shufflevector_maskSel1000 {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = maskSel1000)
    (v x : Wwl) :
    Operation.shufflevector m (selPoison 1 0 0 0 v) (Ty.wrap (t := .vec 8 64) x) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel 1 0 0 0 (wwl_perm4 1 0 2 3 x) v) := by
  subst hm
  shuffle_lanes

/-- A shuffle by `selMask 0 1 1 0`: `e`'s lanes 1, 2, 5, 6, `d`'s elsewhere. -/
theorem shufflevector_selMask0110 {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = selMask 0 1 1 0)
    (d e : Wwl) :
    Operation.shufflevector m (selPoison 1 0 0 1 d) (selPoison 0 1 1 0 e) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel 0 1 1 0 d e) := by
  subst hm
  shuffle_lanes

/-- Setting all eight lanes forgets the base vector. -/
theorem set_eight {α : Type} (w : Vector α 8) (x0 x1 x2 x3 x4 x5 x6 x7 : α) :
    (((((((w.set 0 x0).set 1 x1).set 2 x2).set 3 x3).set 4 x4).set 5 x5).set 6 x6).set 7 x7 =
      #v[x0, x1, x2, x3, x4, x5, x6, x7] := by
  ext i hi
  obtain _|_|_|_|_|_|_|_|i := i <;> simp <;> omega

/-- A vector constant built on the undef `u`: lanes `x0 … x7` inserted at `k0 … k7` through
`v0 … v7`. -/
def insertRun (u : Reg Γ (.vec 8 64)) (v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64))
    (x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)) (k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)) :
    List (Instr Γ) :=
  [.ternop .insertelement v0 u x0 k0,
    .ternop .insertelement v1 (.val v0.i v0.h) x1 k1,
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
  rw [hE, set_eight]
  exact hK _ _ _ _ _ _ _

/-- `runBodyFrom_permuteLoadRun` for `PERMUTE( 1,0,2,3 )` with only lanes 0, 4 used (`mask1000`):
`r03 r14 r25` get those lanes of the permuted vectors, the others poison. -/
theorem runBodyFrom_permuteLoadRun1000 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8} {p : Reg Γ .ptr}
    {x03 r03 x14 r14 x25 r25 pz : Dst Γ (.vec 8 64)} {g1 g2 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteLoadRun m p x03 r03 x14 r14 x25 r25 pz g1 g2 ++ rest)
    (hp : E.read p = .value P) (hP : S.mem.QuadFit P) (hm : m = mask1000)
    (hpg : p ≠ .val g1.i g1.h) (hd : [x03.i, r03.i, x14.i, r14.i, x25.i, pz.i].Nodup)
    (hK :
      ∀ (l03 l14 l25 : Wwl) (_hx : S.mem.readQuad P = ⟨l03, l14, l25⟩),
        (blk.runBodyFrom
              E[x03 := Ty.wrap l03, r03 := selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 l03),
                g1 := .value (P.add 64#64), x14 := Ty.wrap l14,
                r14 := selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 l14), g2 := .value (P.add 128#64),
                x25 := Ty.wrap l25, r25 := selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 l25)]
              (pos + 8) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load with ql03
  step_pure [shufflevector_mask1000 hm]
  step_pure
  step_load with ql14
  step_pure [shufflevector_mask1000 hm]
  step_pure
  step_load with ql25
  step_pure [shufflevector_mask1000 hm]
  rw [hE, hS]
  exact hK _ _ _ (by rw [hql03, hql14, hql25]; rfl)

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

/-- Where the body at `pos` is `laneSubPermRun` by `maskSel1000`, `t03 t14 t25` hold lanes 0, 4 of
`X.permute 1 0 2 3`, `x03 x14 x25` hold `X` and `k03 k14 k25` `p`'s limbs there: running on from
`pos` then `g` gives `K` if it does from `pos + 9` with `T.laneSubFast 1 0 0 0 T X` for that `T`
(as `s03 s14 s25`) in `r03 r14 r25`. -/
theorem runBodyFrom_laneSubPermRun1000 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneSubPermRun m t03 t14 t25 x03 x14 x25 k03 k14 k25 d03 e03 r03 d14 e14 r14 d25 e25
            r25 ++ rest)
    (ht : E.read (.val t03.i t03.h) = selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 X03) ∧
      E.read (.val t14.i t14.h) = selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 X14) ∧
      E.read (.val t25.i t25.h) = selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 X25))
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hk : E.read (.val k03.i k03.h) = selPoison 1 0 0 0 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison 1 0 0 0 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison 1 0 0 0 quadP.P25)
    (hm : m = maskSel1000)
    (hd :
      [t03.i, t14.i, t25.i, x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, d03.i, e03.i, r03.i, d14.i,
          e14.i, r14.i, d25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 ve03 vd14 ve14 vd25 ve25 : ⟦.vec 8 64⟧) (s03 s14 s25 : Wwl)
        (_hl :
          Quad.laneSubFast (Quad.permute 1 0 2 3 ⟨X03, X14, X25⟩) 1 0 0 0
              (Quad.permute 1 0 2 3 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, e03 := ve03, r03 := Ty.wrap s03, d14 := vd14, e14 := ve14,
                r14 := Ty.wrap s14, d25 := vd25, e25 := ve25, r25 := Ty.wrap s25] (pos + 9) S >>=
            g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hs : ({} : OverflowFlags).nsw = true → ∀ k : Fin 8, False := fun h => absurd h (by decide)
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [shufflevector_maskSel1000 hm] with ss03
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [shufflevector_maskSel1000 hm] with ss14
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ (fun h => (hs h 0).elim) rfl]
  step_pure [shufflevector_maskSel1000 hm] with ss25
  have e :
      Quad.laneSubFast (Quad.permute 1 0 2 3 ⟨X03, X14, X25⟩) 1 0 0 0
          (Quad.permute 1 0 2 3 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneSubFast_sel (by decide), Quad.permute_eq_perm4 (by decide), hss03, hss14, hss25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ e

/-- A `0 1 1 0` select reads `wwl_lane_sel 1 0 0 1 t d` only where it is `d`, the sum only where
it is `t + x`. -/
theorem lane_sel_0110_1001 (t d x : Wwl) :
    wwl_lane_sel 0 1 1 0 (wwl_lane_sel 1 0 0 1 t d) (wwl_add (wwl_lane_sel 1 0 0 1 t d) x) =
      wwl_lane_sel 0 1 1 0 d (wwl_add t x) := by
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals first | omega | simp [wwl_lane_sel, selV, wwl_add]

/-- `FD_R43X6_QUAD_PERMUTE( t, 1,0,3,2, x )`, `LANE_SUB_FAST( t, t, 1,0,0,1, t, x )` and
`LANE_ADD_FAST( t, t, 0,1,1,0, t, x )` fused: the permuted lanes `LANE_SUB` uses into
`p03 p14 p25` (mask `m1`), less `x` into `d03 d14 d25` (flags `fs`), plus `p`'s limbs in
`k03 k14 k25` into `e03 e14 e25` (flags `fa`); the permuted lanes `LANE_ADD` uses into
`w03 w14 w25` (mask `m2`), plus `x` into `a03 a14 a25` (flags `f03 f14 f25`); the two selected
into `r03 r14 r25` (mask `m3`). -/
def permSubAddRun (m1 m2 m3 : Vector (Option (Fin (2 * 8))) 8)
    (fs fa f03 f14 f25 : OverflowFlags)
    (x03 x14 x25 pz k03 k14 k25 p03 p14 p25 d03 e03 w03 d14 e14 w14 d25 e25 w25 a03 r03 a14 r14
      a25 r25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
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

/-- Where the body at `pos` is `permSubAddRun` by `mask1001`, `mask0110` and `selMask 0 1 1 0`,
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
    (hm1 : m1 = mask1001) (hm2 : m2 = mask0110) (hm3 : m3 = selMask 0 1 1 0)
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
  step_pure [shufflevector_mask1001 hm1]
  step_pure [shufflevector_mask1001 hm1]
  step_pure [shufflevector_mask1001 hm1]
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ hs03 hfs]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ ha03 hfa]
  step_pure [shufflevector_mask0110 hm2]
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ hs14 hfs]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ ha14 hfa]
  step_pure [shufflevector_mask0110 hm2]
  step_pure [zipWith_sub_selPoison _ _ _ _ _ _ hs25 hfs]
  step_pure [zipWith_add_selPoison₂ _ _ _ _ _ _ ha25 hfa]
  step_pure [shufflevector_mask0110 hm2]
  step_pure [zipWith_add_selPoison_wrap _ _ _ _ _ _ ho03 hf03]
  step_pure [shufflevector_selMask0110 hm3] with ss03
  step_pure [zipWith_add_selPoison_wrap _ _ _ _ _ _ ho14 hf14]
  step_pure [shufflevector_selMask0110 hm3] with ss14
  step_pure [zipWith_add_selPoison_wrap _ _ _ _ _ _ ho25 hf25]
  step_pure [shufflevector_selMask0110 hm3] with ss25
  have e :
      Quad.laneAddFast
          (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
            (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) 0 1 1 0
          (Quad.laneSubFast (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) 1 0 0 1
            (Quad.permute 1 0 3 2 ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩) ⟨X03, X14, X25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneAddFast_sel (by decide), Quad.laneSubFast_sel (by decide), Quad.permute_1032]
    simp only [Quad.perm4, lane_sel_0110_1001, hss03, hss14, hss25]
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- A signed limb-5 carry times `19`: no signed overflow. -/
theorem sshr40_mul19_ok (x : BitVec 64) : (x.sshiftRight 40).smulOverflow 19#64 = false := by
  bv_decide

/-- A signed carry plus `_bias`, plus the next limb's low bits: no overflow either way. -/
theorem shr_add_bias_add_mask_ok' (d e m : Wwl)
    (hm : m = Vector.replicate 8 8796093022207#64 ∨ m = m4340) :
    ∀ i : Fin 8,
      (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
          (Vector.replicate 8 1048576#64))[i].saddOverflow (wwl_and e m)[i] = false ∧
        (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
          (Vector.replicate 8 1048576#64))[i].uaddOverflow (wwl_and e m)[i] = false := by
  intro i
  refine ⟨shr_add_bias_add_mask_ok d e _ m (.inl rfl) hm i, ?_⟩
  obtain ⟨i, hi⟩ := i
  rcases hm with rfl | rfl <;> obtain _|_|_|_|_|_|_|_|i := i
  all_goals
    first
    | omega
    | wwl_lanes
      bv_decide

/-- `foldSignedRun` as LLVM 23 flags it: the top carries' `19 h25` `nsw`, the last two sums
`nsw nuw`. -/
def foldSignedNswRun (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e03 (.val l03.i l03.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val c.i c.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true })) e14 (.val h03.i h03.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val e14.i e14.h) (.val l14.i l14.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true })) e25 (.val h14.i h14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val e25.i e25.h) (.val l25.i l25.h)]

/-- `foldSignedRun'` as LLVM 23 flags it: `19 h25` `nsw`, the last sum `nsw nuw`. -/
def foldSignedNswRun' (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add {})) e03 (.val c.i c.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val l03.i l03.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e14 (.val l14.i l14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true })) r14 (.val e14.i e14.h) (.val h03.i h03.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true })) e25 (.val h14.i h14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val e25.i e25.h) (.val l25.i l25.h)]

/-- `runBodyFrom_foldSignedRun` for `foldSignedNswRun`. -/
theorem runBodyFrom_foldSignedNswRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedNswRun x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03 h14
            h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          d03.i, d14.i, d25.i, h03.i, h14.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i, l14.i, e14.i,
          r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh14 vh25 vp vl03 vc ve03 vl14 ve14 vl25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hs : Quad.foldSignedC ⟨X03, X14, X25⟩ = ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h14 := vh14, h25 := vh25,
                p := vp, l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap s03, l14 := vl14,
                e14 := ve14, r14 := Ty.wrap s14, l25 := vl25, e25 := ve25, r25 := Ty.wrap s25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with sh14
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector, sshr40_mul19_ok]
    with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' : sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _|_|_|_|_|_|_|_|i := i
    all_goals first | omega | wwl_lanes
  have hok03 := mask_add_bias03_ok sd03
  rw [← hsl03] at hok03
  step_pure with se03
  step_pure [hsc03'] with sf03
  step_pure with sl14
  have hok14 := shr_add_bias_ok sd03 _ (.inl rfl)
  rw [← hsh03] at hok14
  step_pure with se14
  have hok14' := shr_add_bias_add_mask_ok' sd03 sd14 _ (.inl rfl)
  rw [← hsh03, ← hse14, ← hsl14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure with se25
  have hok25' := shr_add_bias_add_mask_ok' sd14 sd25 _ (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03,
      hsd14, hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- `runBodyFrom_foldSignedRun'` for `foldSignedNswRun'`. -/
theorem runBodyFrom_foldSignedNswRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedNswRun' x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03
            h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          d03.i, d14.i, d25.i, h03.i, h14.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i, l14.i, e14.i,
          r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh14 vh25 vp vl03 vc ve03 vl14 ve14 vl25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hs : Quad.foldSignedC' ⟨X03, X14, X25⟩ = ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h14 := vh14, h25 := vh25,
                p := vp, l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap s03, l14 := vl14,
                e14 := ve14, r14 := Ty.wrap s14, l25 := vl25, e25 := ve25, r25 := Ty.wrap s25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with sh14
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector, sshr40_mul19_ok]
    with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' : sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _|_|_|_|_|_|_|_|i := i
    all_goals first | omega | wwl_lanes
  step_pure [hsc03'] with se03
  step_pure with sf03
  step_pure with sl14
  have hok14 := mask_add_bias_ok sd14
  rw [← hsl14] at hok14
  step_pure with se14
  have hok14' := mask_add_bias_add_shr_ok sd03 sd14
  rw [← hsh03, ← hsl14, ← hse14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure with se25
  have hok25' := shr_add_bias_add_mask_ok' sd14 sd25 _ (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC' ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03,
      hsd14, hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- The entry block's constants the branches read: `_1112d`, the folds' shifts, masks and biases,
the lane subtractions' `p` limbs, and `19` for the folds' top carries. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%2452 := quad1112d.P25, %2453 := quad1112d.P14, %2454 := quad1112d.P03, %2455 := m4340,
    %2456 := Vector.replicate 8 1048576#64, %2457 := bias03,
    %2458 := Vector.replicate 8 8796093022207#64, %2460 := s4340,
    %2461 := Vector.replicate 8 43#64, %2462 := Vector.replicate 8 18446744073708503040#64,
    %2463 := negBias03, %2485 := selPoison 1 0 0 0 quadP.P03,
    %2493 := selPoison 1 0 0 0 quadP.P14, %2501 := selPoison 1 0 0 0 quadP.P25,
    %2509 := k19Lanes, %2517 := selPoison 1 0 0 1 quadP.P03,
    %2525 := selPoison 1 0 0 1 quadP.P14, %2533 := selPoison 1 0 0 1 quadP.P25]

/-- `^bb2`, `FD_R43X6_GE_ADD( P3, A, B )`, then `^bb3`: `r` gets `geAdd` of the points at `a` and
`b`, through the temporaries `z0 … z8` (block ids from `n` on). -/
theorem geAdd_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 z6 z7 z8 : Pointer)
    (n : Nat) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get)
    (hC : Consts E)
    (hZ :
      E ⊨ [%2540 := z0, %2541 := z1, %2542 := z2, %2543 := z3, %2544 := z4, %2545 := z5,
        %2546 := z6, %2547 := z7, %2548 := z8])
    (hwf : S.WF) (hr : S.mem.QuadFit r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      Fits S.mem z0 512 ∧ Fits S.mem z1 512 ∧ Fits S.mem z2 512 ∧ Fits S.mem z3 512 ∧
        Fits S.mem z4 512 ∧ Fits S.mem z5 512 ∧ Fits S.mem z6 512 ∧ Fits S.mem z7 512 ∧
        Fits S.mem z8 512)
    (hne :
      z0.id ≠ z1.id ∧ z0.id ≠ z2.id ∧ z1.id ≠ z2.id ∧ z3.id ≠ z4.id ∧ z3.id ≠ z5.id ∧
        z4.id ≠ z5.id ∧ z6.id ≠ z7.id ∧ z6.id ≠ z8.id ∧ z7.id ≠ z8.id)
    (hn :
      n ≤ z0.id.id ∧ n ≤ z1.id.id ∧ n ≤ z2.id.id ∧ n ≤ z3.id.id ∧ n ≤ z4.id.id ∧
        n ≤ z5.id.id ∧ n ≤ z6.id.id ∧ n ≤ z7.id.id ∧ n ≤ z8.id.id)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc →
        S'.mem.eraseFrom n =
          (S.mem.eraseFrom n).storeQuad r (geAdd quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
        g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 2 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5, hz6, hz7, hz8⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45, h67, h68, h78⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5, hn6, hn7, hn8⟩ := hn
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P1 ); FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P2 ), only
  -- the lanes the subtractions read
  step_pattern using runBodyFrom_permuteLoadRun1000
  have eA : A = ⟨l03, l14, l25⟩ := by rw [← hA]; simpa only [hS] using _hx
  step_pattern using runBodyFrom_permuteLoadRun1000
  have eB : B = ⟨l03, l14, l25⟩ := by rw [← hB]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, P1 ); the same for `_tb`, `P2`
  step_pattern using runBodyFrom_laneSubPermRun1000
  have e2 := _hl
  step_pattern using runBodyFrom_laneSubPermRun1000
  have e2' := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,1,0, _ta, P1 ); `( _tb, _tb, 0,1,0,0, _tb, P2 )`
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3' := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _ta, _ta ); FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedNswRun
  have eF1 := _hs
  step_pattern using runBodyFrom_foldSignedNswRun
  have eF2 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _1112d )
  step_pattern using runBodyFrom_mulRun
  have e4 := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := _hu
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e5 := _hm
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused
  step_pattern using runBodyFrom_permSubAddRun
  have e6 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedNswRun
  have eF3 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
  step_pattern using runBodyFrom_permuteRun 0 2 2 0
  have e9 := _hp
  step_pattern using runBodyFrom_permuteRun 3 1 3 1
  have e10 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e11 := _hm
  finish_block
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
  block_init
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have eU2 := _hu
  finish_block
  apply hK
  · rw [hS]
  · have e4' : quadMul _ quad1112d = _ := e4
    rw [hS]
    simp only [MemoryState.eraseFrom_storeAt, MemoryState.storeVec,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5,
      MemoryState.storeAt_eraseFrom_of_le hn6, MemoryState.storeAt_eraseFrom_of_le hn7,
      MemoryState.storeAt_eraseFrom_of_le hn8, geAdd, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e2, e2', e3, e3', eF1, eF2, e4', eU1, e5, e6, eF3, e9, e10, e11, eU2]
    subst_vars
    rfl

/-- `^bb1`, `FD_R43X6_GE_ADD_TABLE_ALT( P3, A, T )`, then `^bb3`: `r` gets `geAddTable` of the
points at `a` and `b`, through the temporaries `z0 … z5` (block ids from `n` on). -/
theorem geAddTable_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer)
    (n : Nat) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get)
    (hC : Consts E)
    (hZ : E ⊨ [%2534 := z0, %2535 := z1, %2536 := z2, %2537 := z3, %2538 := z4, %2539 := z5])
    (hwf : S.WF) (hr : S.mem.QuadFit r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      Fits S.mem z0 512 ∧ Fits S.mem z1 512 ∧ Fits S.mem z2 512 ∧ Fits S.mem z3 512 ∧
        Fits S.mem z4 512 ∧ Fits S.mem z5 512)
    (hne :
      z0.id ≠ z1.id ∧ z0.id ≠ z2.id ∧ z1.id ≠ z2.id ∧ z3.id ≠ z4.id ∧ z3.id ≠ z5.id ∧
        z4.id ≠ z5.id)
    (hn :
      n ≤ z0.id.id ∧ n ≤ z1.id.id ∧ n ≤ z2.id.id ∧ n ≤ z3.id.id ∧ n ≤ z4.id.id ∧
        n ≤ z5.id.id)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc →
        S'.mem.eraseFrom n =
          (S.mem.eraseFrom n).storeQuad r
            (geAddTable quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
        g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 1 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5⟩ := hn
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  step_pattern using runBodyFrom_quadLoadRun
  have eB : B = ⟨l03, l14, l25⟩ := by rw [← hB]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P1 ), only the lanes the subtraction reads
  step_pattern using runBodyFrom_permuteLoadRun1000
  have eA : A = ⟨l03, l14, l25⟩ := by rw [← hA]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, P1 )
  step_pattern using runBodyFrom_laneSubPermRun1000
  have e2 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, P1 )
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedNswRun
  have eF1 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e4 := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta ); its lanes are below `2^44`
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := _hu
  obtain ⟨hu03, hu14, hu25⟩ := Quad.foldUnsignedC_lt eU1
  have hpa03 := wwl_perm4_lt hu03 1 0 3 2
  have hpa14 := wwl_perm4_lt hu14 1 0 3 2
  have hpa25 := wwl_perm4_lt hu25 1 0 3 2
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused; the code's
  -- `nsw` holds
  step_pattern using runBodyFrom_permSubAddRun (hs03 := fun _ => sub_lt_ok hpa03 hu03)
    (hs14 := fun _ => sub_lt_ok hpa14 hu14) (hs25 := fun _ => sub_lt_ok hpa25 hu25)
    (ha03 := fun _ => sub_add_lt_ok hpa03 hu03 quadP_lt.1)
    (ha14 := fun _ => sub_add_lt_ok hpa14 hu14 quadP_lt.2.1)
    (ha25 := fun _ => sub_add_lt_ok hpa25 hu25 quadP_lt.2.2)
    (ho14 := fun _ k => add_lane_ok (hpa14 k) (hu14 k))
    (ho25 := fun _ k => add_lane_ok (hpa25 k) (hu25 k))
  have e5 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedNswRun'
  have eF2 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
  step_pattern using runBodyFrom_permuteRun 0 2 2 0
  have e8 := _hp
  step_pattern using runBodyFrom_permuteRun 3 1 3 1
  have e9 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e10 := _hm
  finish_block
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
  block_init
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have eU2 := _hu
  finish_block
  apply hK
  · rw [hS]
  · rw [hS]
    simp only [MemoryState.eraseFrom_storeAt, MemoryState.storeVec,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5,
      geAddTable, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e2, e3, eF1, e4, eU1, e5, Quad.foldSignedC_eq', eF2, e8, e9, e10, eU2]
    subst_vars
    rfl

end fd_ed25519_point_add_with_opts

/-- `fd_ed25519_point_add_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_add_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    fd_ed25519_point_add_with_opts.call
        (fd_ed25519_point_add_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value (.cons (.value r) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 15⟩,
          mem := s.mem.storeQuad r
            (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b) pre) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  have hrb : S.mem.readQuad b = S₀.mem.readQuad b := by rw [hS]
  block_init
  iterate 26 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  iterate 15 step_alloca
  step_pure
  have hC : fd_ed25519_point_add_with_opts.Consts E := by
    dsimp only [fd_ed25519_point_add_with_opts.Consts]
    env_reads
    · rw [hv33]; rfl
    · rw [hv41]; rfl
    · rw [hv49]; rfl
    · rw [hv57]
    · rw [hv65]; rfl
    · rw [hv73]; rfl
    · rw [hv81]; rfl
  finish_block
  · -- `!b_is_precomputed`: FD_R43X6_GE_ADD
    subst hbr
    refine fd_ed25519_point_add_with_opts.geAdd_run r a b 0 v88 v89 v90 v91 v92 v93 v94 v95
      v96 S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_
    · env_reads
    · exact ⟨hv88_fits, hv89_fits, hv90_fits, hv91_fits, hv92_fits, hv93_fits, hv94_fits,
        hv95_fits, hv96_fits⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> slot_bound
    · intro S' h1 h2
      simp only [h1, h2, hra, hrb, fd_ed25519_point_add_with_opts.spec, ne_eq]
      subst hS
      erase_frame
      rw [ite_eq_right (by decide)]
      rfl
  · -- `b_is_precomputed`: FD_R43X6_GE_ADD_TABLE_ALT
    have hpre : pre ≠ 0 := hbr
    refine fd_ed25519_point_add_with_opts.geAddTable_run r a b pre v82 v83 v84 v85 v86 v87
      S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_
    · env_reads
    · exact ⟨hv82_fits, hv83_fits, hv84_fits, hv85_fits, hv86_fits, hv87_fits⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> slot_bound
    · intro S' h1 h2
      simp only [h1, h2, hra, hrb, fd_ed25519_point_add_with_opts.spec, ne_eq, hpre,
        not_false_eq_true, ↓reduceIte]
      subst hS
      erase_frame
      rfl

end Proof

end MLIR.Firedancer.Avx512

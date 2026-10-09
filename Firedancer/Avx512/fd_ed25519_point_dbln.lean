module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Mlir.fd_ed25519_point_dbln
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `2ⁿ A`: `FD_R43X6_GE_DBL` once, then `n - 1` more times. -/
def fd_ed25519_point_dbln.spec (A : Quad) (n : Nat) : Quad :=
  Nat.repeat (geDbl quadMul quadSqr) (n - 1) (geDbl quadMul quadSqr A)

end

/-! ## Proof -/

section Proof

/-! ### LLVM 23's code, as patterns -/

/-- A vector constant as LLVM 23 builds it: lanes `x0 … x7` inserted at `k0 … k7` through
`v0 … v7`, into the shared undefined vector `u`. -/
private def insertRun (u : Reg Γ (.vec 8 64)) (v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64))
    (x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)) (k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)) :
    List (Instr Γ) :=
  [.ternop .insertelement v0 u x0 k0, .ternop .insertelement v1 (.val v0.i v0.h) x1 k1,
    .ternop .insertelement v2 (.val v1.i v1.h) x2 k2,
    .ternop .insertelement v3 (.val v2.i v2.h) x3 k3,
    .ternop .insertelement v4 (.val v3.i v3.h) x4 k4,
    .ternop .insertelement v5 (.val v4.i v4.h) x5 k5,
    .ternop .insertelement v6 (.val v5.i v5.h) x6 k6,
    .ternop .insertelement v7 (.val v6.i v6.h) x7 k7]

/-- Where the body at `pos` is `insertRun`, `u` is poison, `kj` holds `j` and `xj` the lane `Xj`:
running on from `pos` then `g` gives `K` if it does from `pos + 8` with `#v[X0, …, X7]` in
`v7`. -/
private theorem runBodyFrom_insertRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u : Reg Γ (.vec 8 64)} {v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64)}
    {x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)} {k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 X5 X6 X7 : ⟦.bv 64⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        insertRun u v0 v1 v2 v3 v4 v5 v6 v7 x0 x1 x2 x3 x4 x5 x6 x7 k0 k1 k2 k3 k4 k5 k6 k7 ++ rest)
    (hu : E.read u = Vector.replicate 8 .poison)
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
  rw [hE]
  exact hK _ _ _ _ _ _ _

/-- A top carry, shifted right by 40, times 19: no signed overflow. -/
private theorem sshiftRight40_mul19_ok (x : BitVec 64) :
    (x.sshiftRight 40).smulOverflow 19#64 = false := by
  bv_decide

/-- A signed carry by 43 plus `_bias`, plus the next limb's low bits: no overflow either way. -/
private theorem shr_add_bias_add_mask_ok' (d e m : Wwl)
    (hm : m = Vector.replicate 8 8796093022207#64 ∨ m = m4340) :
    ∀ i : Fin 8,
      (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
          (Vector.replicate 8 1048576#64))[i].saddOverflow (wwl_and e m)[i] = false ∧
        (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
          (Vector.replicate 8 1048576#64))[i].uaddOverflow (wwl_and e m)[i] = false := by
  intro ⟨i, hi⟩
  rcases hm with rfl | rfl <;> obtain _|_|_|_|_|_|_|_|i := i
  all_goals
    first
    | omega
    | wwl_lanes
      constructor <;> bv_decide

section FoldPattern

attribute [-mlir_operation] zipWith_eq_ofFn
attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap
  zipWith_mul_wrap zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap
  zipWith_add_nsw_nuw_wrap zipWith_sub_nsw_wrap

/-- `foldSignedRun` as LLVM 23 flags it: `mul nsw` for `19 h25`, `add nsw nuw` for the limbs 1
and 2. -/
private def foldSignedNuwRun (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 :
      Dst Γ (.vec 8 64))
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

/-- `runBodyFrom_foldSignedRun` for `foldSignedNuwRun`. -/
private theorem runBodyFrom_foldSignedNuwRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedNuwRun x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03 h14
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
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector, sshiftRight40_mul19_ok]
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

end FoldPattern

/-- The merged lane add and sub: `t + x` in lanes 0, 3, `t - x + p` in lanes 1, 2. -/
private theorem lane_sel_add_sub (t x p : Wwl) :
    wwl_lane_sel 0 1 1 0 (wwl_lane_sel 1 0 0 1 t (wwl_add t x))
        (wwl_add (wwl_sub (wwl_lane_sel 1 0 0 1 t (wwl_add t x)) x) p) =
      wwl_lane_sel 0 1 1 0 (wwl_add t x) (wwl_add (wwl_sub t x) p) := by
  ext i hi : 1
  obtain _|_|_|_|_|_|_|_|i := i
  all_goals
    first
    | omega
    | simp only [wwl_lane_sel, selV, wwl_add, wwl_sub, Vector.getElem_ofFn, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, Fin.getElem_fin]

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( T, T, 1,0,0,1, T, X )` then
`FD_R43X6_QUAD_LANE_SUB_FAST( T, T, 0,1,1,0, T, X )`: `T + X` in lanes 0, 3, `T - X + p` in
lanes 1, 2. -/
private theorem Quad.laneAddSubFast_sel (T X : Quad) :
    (T.laneAddFast 1 0 0 1 T X).laneSubFast 0 1 1 0 (T.laneAddFast 1 0 0 1 T X) X =
      ⟨wwl_lane_sel 0 1 1 0 (wwl_add T.P03 X.P03) (wwl_add (wwl_sub T.P03 X.P03) quadP.P03),
        wwl_lane_sel 0 1 1 0 (wwl_add T.P14 X.P14) (wwl_add (wwl_sub T.P14 X.P14) quadP.P14),
        wwl_lane_sel 0 1 1 0 (wwl_add T.P25 X.P25) (wwl_add (wwl_sub T.P25 X.P25) quadP.P25)⟩ := by
  rw [Quad.laneSubFast_sel (by decide), Quad.laneAddFast_sel (by decide)]
  simp only [lane_sel_add_sub]

section MidPattern

attribute [-mlir_operation] zipWith_eq_ofFn
attribute [local mlir_operation] zipWith_shl_wrap

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( r, t, 1,0,0,1, t, x )` then
`FD_R43X6_QUAD_LANE_SUB_FAST( r, r, 0,1,1,0, r, x )` as LLVM 23 merges them: `t + x` into
`a03 a14 a25`, `t - x` into `d03 d14 d25`, plus `p`'s limbs in `k03 k14 k25` into `e03 e14 e25`,
selected by `m` into `r03 r14 r25`. -/
private def laneAddSubRun (m : Vector (Option (Fin (2 * 8))) 8)
    (t03 t14 t25 x03 x14 x25 k03 k14 k25 a03 a14 a25 d03 e03 r03 d14 e14 r14 d25 e25 r25 :
      Dst Γ (.vec 8 64)) : List (Instr Γ) :=
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
private theorem runBodyFrom_laneAddSubRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
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

/-- `dblMidRun` as LLVM 23 compiles it: `laneAddSubRun` for the first lane add and sub,
`foldSignedNuwRun` for the fold. -/
private def dblMidRun' (z0 z1 z2 z3 z4 z5 : Dst Γ .ptr)
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
    laneSubRun (selMask 0 1 1 1) {} {} w03 w14 w25 c03 c14 c25 k59 k68 k77 ya03 yb03 y03 ya14
      yb14 y14 ya25 yb25 y25 ++
    foldSignedNuwRun y03 y14 y25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 fd03 fd14 fd25 fh03 fh14
      fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 ++
    permuteRun (permMask 0 1 1 0) f03 f14 f25 pz ma03 ma14 ma25 ++
    permuteRun (permMask 2 3 2 3) f03 f14 f25 pz mb03 mb14 mb25 ++
    mulRun z3 z4 z5 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25

-- 79 instructions through ten nested patterns, two calls
set_option maxHeartbeats 600000 in
/-- `runBodyFrom_dblMidRun` for `dblMidRun'`: on from `pos + 79`. -/
private theorem runBodyFrom_dblMidRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
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
        dblMidRun' z0 z1 z2 z3 z4 z5 t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 nb03 nb sh43
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
      Fits S.mem Z0 512 ∧ Fits S.mem Z1 512 ∧ Fits S.mem Z2 512 ∧ Fits S.mem Z3 512 ∧
        Fits S.mem Z4 512 ∧ Fits S.mem Z5 512)
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
                  (((((S.mem.storeVec Z0 s03).storeVec Z1 s14).storeVec Z2 s25).storeVec Z3
                          d03).storeVec Z4 d14).storeVec Z5 d25 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hZ
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
  step_pattern using runBodyFrom_foldSignedNuwRun
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
end MidPattern
namespace fd_ed25519_point_dbln

/-- `j` more doublings of `P`, the loop's order. -/
def iter : Nat → Quad → Quad
  | 0, P => P
  | j + 1, P => iter j (geDbl quadMul quadSqr P)

theorem repeat_eq_iter (j : Nat) (P : Quad) : Nat.repeat (geDbl quadMul quadSqr) j P = iter j P := by
  induction j generalizing P with
  | zero => rfl
  | succ j ih =>
    rw [iter, ← ih, Nat.repeat]
    clear ih
    induction j with
    | zero => rfl
    | succ j ih => rw [Nat.repeat, ih, Nat.repeat]

/-- The registers of the entry block that the loop and its exit read: the constants, the six
temporaries, and the pointers to `r`'s second and third vectors. -/
abbrev LoopEnv (E : ⟪Γ⟫) (r z0 z1 z2 z3 z4 z5 : Pointer) : Prop :=
  E ⊨ [%3041 := .value 1#8,
    %3042 := Ty.wrap #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64,
      1099511627775#64, 1099511627775#64, 1099511627775#64, 1099511627775#64],
    %3043 := Ty.wrap (Vector.replicate 8 1048576#64),
    %3044 := Ty.wrap #v[159383552#64, 159383552#64, 159383552#64, 159383552#64, 1048576#64,
      1048576#64, 1048576#64, 1048576#64],
    %3045 := Ty.wrap (Vector.replicate 8 8796093022207#64),
    %3047 := Ty.wrap #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64],
    %3048 := Ty.wrap (Vector.replicate 8 43#64),
    %3049 := Ty.wrap (Vector.replicate 8 18446744073708503040#64),
    %3050 := Ty.wrap #v[18446744073550168064#64, 18446744073550168064#64, 18446744073550168064#64,
      18446744073550168064#64, 18446744073708503040#64, 18446744073708503040#64,
      18446744073708503040#64, 18446744073708503040#64],
    %3059 := Vector.replicate 8 PoisonOr.poison,
    %3060 := Ty.wrap #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
    %3073 := #v[.poison, .value 8796093022189#64, .value 8796093022189#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %3081 := #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %3089 := #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 1099511627775#64, .value 1099511627775#64, .poison],
    %3097 := #v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64,
      .poison, .poison, .poison],
    %3105 := #v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64,
      .poison, .poison, .poison],
    %3113 := #v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64,
      .poison, .poison, .poison],
    %3121 := #v[.poison, .poison, .poison, .poison, .value 19#64, .value 19#64, .value 19#64,
      .value 19#64],
    %3128 := z0, %3129 := z1, %3130 := z2, %3131 := z3, %3132 := z4, %3133 := z5,
    %3222 := r.add 64#64, %3225 := r.add 128#64]

/-- The lanes of a folded point are below `2^44`. -/
abbrev Folded (P : Quad) : Prop :=
  (∀ i : Fin 8, P.P03[i] < 17592186044416#64) ∧ (∀ i : Fin 8, P.P14[i] < 17592186044416#64) ∧
    ∀ i : Fin 8, P.P25[i] < 17592186044416#64

theorem add_lt_ok {x y : Wwl} (hx : ∀ i : Fin 8, x[i] < 17592186044416#64)
    (hy : ∀ i : Fin 8, y[i] < 17592186044416#64) : ∀ i : Fin 8, x[i].saddOverflow y[i] = false :=
  fun i => add_lane_ok (hx i) (hy i)

theorem storeVec_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeVec p v = m.eraseFrom n :=
  MemoryState.storeAt_eraseFrom_of_le h

/-- The loop's header `^bb3` holding `P` and the counter `k`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad) (k : Nat) : ⟪Γ⟫ :=
  E[%3227 := Ty.wrap P.P25, %3228 := Ty.wrap P.P14, %3229 := Ty.wrap P.P03,
    %3230 := .value (BitVec.ofNat 8 k)]

/-- One trip through `^bb3` on `P` at counter `k`: `geDbl P` into the registers, the temporaries
written; then back to the header if `k + 1 < n`, else to the exit. -/
theorem trip (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer) (b k : Nat) (P : Quad)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value n)).get)
    (hR : LoopEnv E r z0 z1 z2 z3 z4 z5) (hP : Folded P) (hwf : S.WF) (hr : S.mem.QuadFit r)
    (h0 : Fits S.mem z0 512) (h1 : Fits S.mem z1 512) (h2 : Fits S.mem z2 512)
    (h3 : Fits S.mem z3 512) (h4 : Fits S.mem z4 512) (h5 : Fits S.mem z5 512)
    (hb0 : b ≤ z0.id.id) (hb1 : b ≤ z1.id.id) (hb2 : b ≤ z2.id.id) (hb3 : b ≤ z3.id.id)
    (hb4 : b ≤ z4.id.id) (hb5 : b ≤ z5.id.id)
    (h01 : z0.id ≠ z1.id) (h02 : z0.id ≠ z2.id) (h12 : z1.id ≠ z2.id) (h34 : z3.id ≠ z4.id)
    (h35 : z3.id ≠ z5.id) (h45 : z4.id ≠ z5.id)
    (hback :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (args (.value r) (.value a) (.value n)).get →
        LoopEnv E' r z0 z1 z2 z3 z4 z5 →
        S'.WF → S'.mem.QuadFit r → Fits S'.mem z0 512 → Fits S'.mem z1 512 →
        Fits S'.mem z2 512 → Fits S'.mem z3 512 → Fits S'.mem z4 512 → Fits S'.mem z5 512 →
        S'.alloc = S.alloc → S'.mem.eraseFrom b = S.mem.eraseFrom b →
        Folded (geDbl quadMul quadSqr P) →
        ((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
        (fd_ed25519_point_dbln.runFrom
          (hdr E' (geDbl quadMul quadSqr P) (k + 1)) 3 S' >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value n)).get →
          (E' ⊨ [%3222 := r.add 64#64, %3225 := r.add 128#64,
            %3311 := Ty.wrap (geDbl quadMul quadSqr P).P03,
            %3313 := Ty.wrap (geDbl quadMul quadSqr P).P14,
            %3315 := Ty.wrap (geDbl quadMul quadSqr P).P25]) →
          S'.WF → S'.mem.QuadFit r → S'.alloc = S.alloc →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          ¬((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) :
    (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  block_init
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, r->P ); its lanes stay below `2^44`
  step_pattern using runBodyFrom_permuteRun 1 1 2 0
  have d1 := _hp
  have d1' := (Quad.permute_1120 _).symm.trans d1
  obtain ⟨hP03, hP14, hP25⟩ := hP
  have hk03 := add_lt_ok (wwl_perm4_lt_of_eq hP03 (congrArg Quad.P03 d1')) hP03
  have hk14 := add_lt_ok (wwl_perm4_lt_of_eq hP14 (congrArg Quad.P14 d1')) hP14
  have hk25 := add_lt_ok (wwl_perm4_lt_of_eq hP25 (congrArg Quad.P25 d1')) hP25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, r->P ): the code's `nsw` holds
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0 (ho03 := fun _ => hk03)
    (ho14 := fun _ => hk14) (ho25 := fun _ => hk25)
  have d2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblMidRun'
  have d3 := _hdbl
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta ), kept in registers
  step_pattern using runBodyFrom_foldUnsignedRun
  have d15 := _hu
  -- `i++`, `i<n`
  step_pure
  step_pure
  step_pure
  have hQ : geDbl quadMul quadSqr P = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, show P = ⟨P.P03, P.P14, P.P25⟩ from rfl, d1, d2, d3, Quad.foldUnsigned_eq,
      d15]
  finish_block
  · rw [hQ] at hback
    step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · dsimp only [LoopEnv]
      env_reads
    · simp only [MemoryState.eraseFrom_storeVec, storeVec_eraseFrom_of_le hb0,
        storeVec_eraseFrom_of_le hb1, storeVec_eraseFrom_of_le hb2,
        storeVec_eraseFrom_of_le hb3, storeVec_eraseFrom_of_le hb4,
        storeVec_eraseFrom_of_le hb5]
    · exact Quad.foldUnsignedC_lt _hu
  · rw [hQ] at hexit
    step_loop using hexit
    simp only [MemoryState.eraseFrom_storeVec, storeVec_eraseFrom_of_le hb0,
      storeVec_eraseFrom_of_le hb1, storeVec_eraseFrom_of_le hb2, storeVec_eraseFrom_of_le hb3,
      storeVec_eraseFrom_of_le hb4, storeVec_eraseFrom_of_le hb5]

/-- The loop from `^bb3` at counter `k` with `P` in the registers and `m + 1` trips left: at the
exit the registers hold `iter (m + 1) P`; only the temporaries are written. -/
theorem loop (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer) (b : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m k (P : Quad) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value n)).get →
        LoopEnv E r z0 z1 z2 z3 z4 z5 →
        k + m + 1 = n.toNat → n.toNat ≤ 255 →
        Folded P → S.WF → S.mem.QuadFit r →
        Fits S.mem z0 512 → Fits S.mem z1 512 → Fits S.mem z2 512 →
        Fits S.mem z3 512 → Fits S.mem z4 512 → Fits S.mem z5 512 →
        b ≤ z0.id.id → b ≤ z1.id.id → b ≤ z2.id.id → b ≤ z3.id.id → b ≤ z4.id.id →
        b ≤ z5.id.id →
        z0.id ≠ z1.id → z0.id ≠ z2.id → z1.id ≠ z2.id → z3.id ≠ z4.id → z3.id ≠ z5.id →
        z4.id ≠ z5.id →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value n)).get →
            (E' ⊨ [%3222 := r.add 64#64, %3225 := r.add 128#64,
              %3311 := Ty.wrap (iter (m + 1) P).P03, %3313 := Ty.wrap (iter (m + 1) P).P14,
              %3315 := Ty.wrap (iter (m + 1) P).P25]) →
            S'.WF → S'.mem.QuadFit r → S'.alloc = S.alloc →
            S'.mem.eraseFrom b = S.mem.eraseFrom b →
            (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) →
        (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k P S E hArgs hR hk hn hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2 hb3 hb4 hb5 h01 h02 h12
      h34 h35 h45 hK
    refine trip r a n z0 z1 z2 z3 z4 z5 b k P S E g K hArgs hR hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1
      hb2 hb3 hb4 hb5 h01 h02 h12 h34 h35 h45 ?_ ?_
    · -- around again: impossible, the counter has reached `n`
      intro _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega
    · intro E' S' h1 h2 h3 h4 h5 h6 _
      exact hK E' S' h1 h2 h3 h4 h5 h6
  | succ m ih =>
    intro k P S E hArgs hR hk hn hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2 hb3 hb4 hb5 h01 h02 h12
      h34 h35 h45 hK
    refine trip r a n z0 z1 z2 z3 z4 z5 b k P S E g K hArgs hR hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1
      hb2 hb3 hb4 hb5 h01 h02 h12 h34 h35 h45 ?_ ?_
    · -- around again, one trip fewer
      intro E' S' g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 ha hm hF _
      exact ih (k + 1) _ S' E' g1 g2 (by omega) hn hF g3 g4 g5 g6 g7 g8 g9 g10 hb0 hb1 hb2 hb3 hb4
        hb5 h01 h02 h12 h34 h35 h45
        (fun E'' S'' f1 f2 f3 f4 f5 f6 => hK E'' S'' f1 f2 f3 f4 (f5.trans ha) (f6.trans hm))
    · -- leaving: impossible, the counter is below `n`
      intro _ _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega

end fd_ed25519_point_dbln

-- the first doubling inline: about 150 instructions
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_dbln` stores `spec` of the point at `a` (its `2ⁿ` multiple) at `r` and returns
`r`, for `n ≤ 255`; `r` may be `a`. Its twelve temporaries use up twelve block ids. -/
public theorem fd_ed25519_point_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) (hn : n.toNat ≤ 255) :
    fd_ed25519_point_dbln.call (fd_ed25519_point_dbln.args (.value r) (.value a) (.value n)) s =
      .value (.cons (.value r) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 12⟩,
          mem := s.mem.storeQuad r (fd_ed25519_point_dbln.spec (s.mem.readQuad a) n.toNat) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  block_init
  iterate 25 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  iterate 12 step_alloca
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_pattern using runBodyFrom_permuteLoadRun 1 1 2 0
  have d0 := hra ▸ _hx
  have d1 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0
  have d2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblMidRun'
  have d3 := _hdbl
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have d15 := _hu
  step_pure
  have hA : geDbl quadMul quadSqr (S₀.mem.readQuad a) = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, d0, d1, d2, d3, Quad.foldUnsigned_eq, d15]
  finish_block
  · -- `n > 1`: the loop, `n - 1` trips
    have hn2 : 2 ≤ n.toNat := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    step_loop using fd_ed25519_point_dbln.loop r a n v87 v88 v89 v90 v91 v92
      S₀.alloc.nextFreeBlock _ _ (n.toNat - 2) 1 ⟨u03, u14, u25⟩
    · dsimp only [fd_ed25519_point_dbln.LoopEnv]
      env_reads
    · exact Quad.foldUnsignedC_lt _hu
    · intro hR' hwf' hr' hal hm
      block_init
      step_store
      step_store
      step_store
      finish_block
      block_init
      finish_block
      have hiter :
          fd_ed25519_point_dbln.iter (n.toNat - 2 + 1) ⟨u03, u14, u25⟩ =
            fd_ed25519_point_dbln.spec (S₀.mem.readQuad a) n.toNat := by
        rw [fd_ed25519_point_dbln.spec, fd_ed25519_point_dbln.repeat_eq_iter, hA,
          show n.toNat - 1 = n.toNat - 2 + 1 by omega]
      have hro := hr'.1
      subst hS
      simp only [hiter, MemoryState.eraseFrom_storeAt]
      rw [hm, hal]
      subst_vars
      erase_frame
      rw [MemoryState.storeAt_quad_twice hro]
      rfl
  · -- `n ≤ 1`: no trip
    have hn1 : n.toNat - 1 = 0 := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    block_init
    finish_block
    subst hS
    erase_frame
    rw [fd_ed25519_point_dbln.spec, hn1, Nat.repeat, hA]
    subst_vars
    rfl

end Proof

end MLIR.Firedancer.Avx512

module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Mlir.fd_curve25519_into_precomputed
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `(Y-X, Y+X, Z, T)` folded, times `(1, 1, 1, 2d)`, folded: the table form of `A`. -/
def fd_curve25519_into_precomputed.spec (A : Quad) : Quad :=
  let _ta := A.permute 1 0 2 3
  let _ta := _ta.laneSubFast 1 0 0 0 _ta A
  let _ta := _ta.laneAddFast 0 1 0 0 _ta A
  let r := _ta.foldSigned
  (quadMul r quad1112d).foldUnsigned

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn
attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap
  zipWith_mul_wrap zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap
  zipWith_add_nsw_nuw_wrap zipWith_sub_nsw_wrap

/-- `FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P )`'s shuffle as LLVM 23 keeps it: lanes 1 and 5 moved
down, the others poison. -/
def perm1Mask : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 1, none, none, none, some 5, none, none, none]

/-- `QUAD_LANE_SUB_FAST`'s select after the permute, fused: lanes 0 and 4 of the difference, the
others of the unpermuted `x`. -/
def permSelMask : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 0, some 8, some 10, some 11, some 4, some 12, some 14, some 15]

/-- The permute's shuffle: `selPoison` of the permuted lanes. -/
theorem shufflevector_perm1Mask {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = perm1Mask)
    (x : ⟦.vec 8 64⟧ᵣ) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      selPoison 1 0 0 0 (wwl_perm4 1 0 2 3 x) := by
  subst hm
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals first | omega | simp [perm1Mask, Operation.shufflevector, selPoison, selV, wwl_perm4]

/-- `v - x` on the lanes `selPoison` keeps. -/
theorem zipWith_sub_selPoison (v x : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.sub {} (w := 64)) (selPoison 1 0 0 0 v) (Ty.wrap (t := .vec 8 64) x) =
      selPoison 1 0 0 0 (wwl_sub v x) := by
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals first | omega | simp [Operation.sub, selPoison, selV, wwl_sub]

/-- `d + v` on the lanes both `selPoison`s keep. -/
theorem zipWith_selPoison_add_selPoison (d v : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.add {} (w := 64)) (selPoison 1 0 0 0 d) (selPoison 1 0 0 0 v) =
      selPoison 1 0 0 0 (wwl_add d v) := by
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals first | omega | simp [Operation.add, selPoison, selV, wwl_add]

/-- The fused select: `e` in lanes 0 and 4, the permuted `x` in the others. -/
theorem shufflevector_permSelMask {m : Vector (Option (Fin (2 * 8))) 8} (hm : m = permSelMask)
    (e x : ⟦.vec 8 64⟧ᵣ) :
    Operation.shufflevector m (selPoison 1 0 0 0 e) (Ty.wrap (t := .vec 8 64) x) =
      Ty.wrap (t := .vec 8 64) (wwl_lane_sel 1 0 0 0 (wwl_perm4 1 0 2 3 x) e) := by
  subst hm
  ext k hk
  obtain _|_|_|_|_|_|_|_|k := k
  all_goals
    first
    | omega
    | simp [permSelMask, Operation.shufflevector, selPoison, selV, wwl_perm4, wwl_lane_sel]

/-- Eight lanes set over any vector: the literal. -/
theorem vector_set8 (v : Vector α 8) (x0 x1 x2 x3 x4 x5 x6 x7 : α) :
    (((((((v.set 0 x0).set 1 x1).set 2 x2).set 3 x3).set 4 x4).set 5 x5).set 6 x6).set 7 x7 =
      #v[x0, x1, x2, x3, x4, x5, x6, x7] := by
  ext i hi
  obtain _|_|_|_|_|_|_|_|i := i
  all_goals first | omega | simp

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
  rw [hE, vector_set8]
  exact hK _ _ _ _ _ _ _

/-- `FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P )` and `FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta,
1,0,0,0, _ta, P )` of the point at `p`, fused: each vector loaded into `x03 x14 x25` (through
`g1 g2`), shuffled by `m` into `q03 q14 q25`, `q - x` into `d03 d14 d25`, plus `p`'s limbs in
`k03 k14 k25` into `e03 e14 e25`, selected against `x` by `ms` into `r03 r14 r25`. -/
def permSubLoadRun (m ms : Vector (Option (Fin (2 * 8))) 8) (p : Reg Γ .ptr)
    (pz k03 k14 k25 x03 q03 x14 q14 x25 q25 : Dst Γ (.vec 8 64))
    (d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)) (g1 g2 : Dst Γ .ptr) :
    List (Instr Γ) :=
  [.load x03 p, .binop (.shufflevector m) q03 (.val x03.i x03.h) (.val pz.i pz.h),
    .unop (.gepConst 64) g1 p, .load x14 (.val g1.i g1.h),
    .binop (.shufflevector m) q14 (.val x14.i x14.h) (.val pz.i pz.h),
    .unop (.gepConst 128) g2 p, .load x25 (.val g2.i g2.h),
    .binop (.shufflevector m) q25 (.val x25.i x25.h) (.val pz.i pz.h),
    .binop (.vector (.sub {})) d03 (.val q03.i q03.h) (.val x03.i x03.h),
    .binop (.vector (.add {})) e03 (.val d03.i d03.h) (.val k03.i k03.h),
    .binop (.shufflevector ms) r03 (.val e03.i e03.h) (.val x03.i x03.h),
    .binop (.vector (.sub {})) d14 (.val q14.i q14.h) (.val x14.i x14.h),
    .binop (.vector (.add {})) e14 (.val d14.i d14.h) (.val k14.i k14.h),
    .binop (.shufflevector ms) r14 (.val e14.i e14.h) (.val x14.i x14.h),
    .binop (.vector (.sub {})) d25 (.val q25.i q25.h) (.val x25.i x25.h),
    .binop (.vector (.add {})) e25 (.val d25.i d25.h) (.val k25.i k25.h),
    .binop (.shufflevector ms) r25 (.val e25.i e25.h) (.val x25.i x25.h)]

/-- Where the body at `pos` is `permSubLoadRun`, `p` holds the point `P` and `k03 k14 k25` `p`'s
limbs in lanes 0 and 4: running on from `pos` then `g` gives `K` if it does from `pos + 17` with
`P`'s vectors (as `l03 l14 l25`) in `x03 x14 x25` and, `T` their `permute 1 0 2 3`,
`T.laneSubFast 1 0 0 0 T P` (as `s03 s14 s25`) in `r03 r14 r25`. -/
theorem runBodyFrom_permSubLoadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {m ms : Vector (Option (Fin (2 * 8))) 8} {p : Reg Γ .ptr}
    {pz k03 k14 k25 x03 q03 x14 q14 x25 q25 : Dst Γ (.vec 8 64)}
    {d03 e03 r03 d14 e14 r14 d25 e25 r25 : Dst Γ (.vec 8 64)} {g1 g2 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        permSubLoadRun m ms p pz k03 k14 k25 x03 q03 x14 q14 x25 q25 d03 e03 r03 d14 e14 r14 d25
            e25 r25 g1 g2 ++ rest)
    (hp : E.read p = .value P) (hP : S.mem.QuadFit P) (hm : m = perm1Mask)
    (hms : ms = permSelMask)
    (hk : E.read (.val k03.i k03.h) = selPoison 1 0 0 0 quadP.P03 ∧
      E.read (.val k14.i k14.h) = selPoison 1 0 0 0 quadP.P14 ∧
      E.read (.val k25.i k25.h) = selPoison 1 0 0 0 quadP.P25)
    (hpg : p ≠ .val g1.i g1.h)
    (hd :
      [k03.i, k14.i, k25.i, x03.i, q03.i, x14.i, q14.i, x25.i, q25.i, d03.i, e03.i, r03.i, d14.i,
          e14.i, r14.i, d25.i, e25.i].Nodup)
    (hK :
      ∀ (l03 l14 l25 : Wwl) (vq03 vq14 vq25 vd03 ve03 vd14 ve14 vd25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hx : S.mem.readQuad P = ⟨l03, l14, l25⟩)
        (_hl :
          (Quad.permute 1 0 2 3 ⟨l03, l14, l25⟩).laneSubFast 1 0 0 0
              (Quad.permute 1 0 2 3 ⟨l03, l14, l25⟩) ⟨l03, l14, l25⟩ =
            ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[x03 := Ty.wrap l03, q03 := vq03, g1 := .value (P.add 64#64), x14 := Ty.wrap l14,
                q14 := vq14, g2 := .value (P.add 128#64), x25 := Ty.wrap l25, q25 := vq25,
                d03 := vd03, e03 := ve03, r03 := Ty.wrap s03, d14 := vd14, e14 := ve14,
                r14 := Ty.wrap s14, d25 := vd25, e25 := ve25, r25 := Ty.wrap s25] (pos + 17) S >>=
            g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hq := shufflevector_perm1Mask hm
  have hr := shufflevector_permSelMask hms
  clear hm hms
  step_load with ql03
  step_pure [hq]
  step_pure
  step_load with ql14
  step_pure [hq]
  step_pure
  step_load with ql25
  step_pure [hq]
  step_pure [zipWith_sub_selPoison]
  step_pure [zipWith_selPoison_add_selPoison]
  step_pure [hr] with ss03
  step_pure [zipWith_sub_selPoison]
  step_pure [zipWith_selPoison_add_selPoison]
  step_pure [hr] with ss14
  step_pure [zipWith_sub_selPoison]
  step_pure [zipWith_selPoison_add_selPoison]
  step_pure [hr] with ss25
  have e :
      (Quad.permute 1 0 2 3 ⟨ql03, ql14, ql25⟩).laneSubFast 1 0 0 0
          (Quad.permute 1 0 2 3 ⟨ql03, ql14, ql25⟩) ⟨ql03, ql14, ql25⟩ =
        ⟨ss03, ss14, ss25⟩ := by
    rw [Quad.laneSubFast_sel (by decide), Quad.permute_eq_perm4 (by decide), hss03, hss14, hss25]
    rfl
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by rw [hql03, hql14, hql25]; rfl) e

/-- A signed carry by 40 times 19: no signed overflow. -/
theorem sshr40_mul19_no_overflow (x : BitVec 64) :
    (x.sshiftRight 40).smulOverflow 19#64 = false := by
  bv_decide

/-- A carry by 43 plus `_bias`, plus the next limb's low bits: no signed or unsigned overflow. -/
theorem shr43_add_bias_add_mask_ok (d e m : Wwl)
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

/-- `foldSignedRun` as LLVM 23 flags it: `mul nsw` for `19 h25`, `add nsw nuw` for the last sums of
limbs 1 and 2. -/
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
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector, sshr40_mul19_no_overflow]
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
  have hok14' := shr43_add_bias_add_mask_ok sd03 sd14 _ (.inl rfl)
  rw [← hsh03, ← hse14, ← hsl14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure with se25
  have hok25' := shr43_add_bias_add_mask_ok sd14 sd25 _ (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03,
      hsd14, hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

public theorem fd_curve25519_into_precomputed.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) :
    fd_curve25519_into_precomputed.call (fd_curve25519_into_precomputed.args (.value r)) s =
      .value (.nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
          mem := s.mem.storeQuad r (fd_curve25519_into_precomputed.spec (s.mem.readQuad r)) }) := by
  func_init
  have hrr : S.mem.readQuad r = S₀.mem.readQuad r := by rw [hS]
  block_init
  iterate 26 step_pure
  iterate 4 step_pattern using runBodyFrom_insertRun
  step_alloca with z03
  step_alloca with z14
  step_alloca with z25
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, r->P ); FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0,
  -- _ta, r->P ), fused
  step_pattern using runBodyFrom_permSubLoadRun
  have e0 := hrr ▸ _hx
  have e1 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,0,0, _ta, r->P )
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldSignedNswRun
  have e3 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( r->P, r->P, _1112d )
  step_pattern using runBodyFrom_mulRun
  have e4 : quadMul _ quad1112d = _ := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, r->P )
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have e5 := _hu
  finish_block
  subst hS
  erase_frame
  simp only [fd_curve25519_into_precomputed.spec, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
  rw [e0, e1, e2, e3, e4, e5]
  rfl

end Proof

end MLIR.Firedancer.Avx512

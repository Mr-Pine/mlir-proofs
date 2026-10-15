module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.Avx512.fd_ed25519_point_neg_precomputed
import Std.Tactic.BVDecide

/-! The register-only runs of `FD_R43X6_GE_ADD_TABLE_ALT` as `double_scalar_mul_base_split`
inlines it: `FD_R43X6_QUAD_FOLD_SIGNED` in two parts, and `fd_ed25519_point_neg_precomputed` of a
loaded entry. -/

namespace MLIR.Firedancer.Lane.Split

open Firedancer.Avx512

@[expose] public section

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-! ### Permutes of points in registers -/

/-- `runBodyFrom_permuteRun` by `permPoisonMask imm s`: the lanes of `X.permute imm` where
`sj ≠ 0`, poison elsewhere. -/
theorem runBodyFrom_permuteRun_poison (i0 i1 i2 i3 s0 s1 s2 s3 : Nat) {blk : BasicBlock Γ tRets bp}
    {E : ⟪Γ⟫} {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {x03 x14 x25 pz r03 r14 r25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)} {X03 X14 X25 : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteRun m x03 x14 x25 pz r03 r14 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hm : m = permPoisonMask i0 i1 i2 i3 s0 s1 s2 s3)
    (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (hd : [x03.i, x14.i, x25.i, r03.i, r14.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[r03 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X03),
              r14 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X14),
              r25 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X25)] (pos + 3) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure [shufflevector_permPoisonMask hm hi]
  rw [hE]
  exact hK

/-! ### `FD_R43X6_QUAD_FOLD_SIGNED` in two parts -/

/-- `-_bias` of `FD_R43X6_QUAD_FOLD_SIGNED`, as the code adds it. -/
abbrev negBias : Wwl :=
  Vector.replicate 8 18446744073708503040#64

/-- `FD_R43X6_QUAD_FOLD_SIGNED( R, x )` up to limb 0 and the low bits of limb 1, the branches'
part: `x` less the biases into `d03 d14 d25`, the carries `h03 h25`, `19 h25` into `p`, the low
bits `l03`, `c` as in `foldSignedRun`, `r03 = (c + b03) + l03` and `l14`. -/
def foldSignedHeadRun (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h25 p l03 c e03 r03 l14 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add {})) e03 (.val c.i c.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val l03.i l03.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h)]

/-- `foldSignedHeadRun` with `r03 = (l03 + b03) + c`, as `foldSignedRun` sums it. -/
def foldSignedHeadRun' (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h25 p l03 c e03 r03 l14 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e03 (.val l03.i l03.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val c.i c.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h)]

/-- The constants `foldSignedHeadRun` reads. -/
abbrev FoldSignedHeadConsts (E : ⟪Γ⟫) (nb03 nb sh43 sh4340 mk43 b03 : Dst Γ (.vec 8 64)) : Prop :=
  E ⊨ [nb03 := negBias03, nb := negBias, sh43 := Vector.replicate 8 43#64, sh4340 := s4340, mk43 :=
    Vector.replicate 8 8796093022207#64, b03 := bias03]

/-- Where the body at `pos` is `foldSignedHeadRun` and `x03 x14 x25` hold `X`: running on from
`pos` then `g` gives `K` if it does from `pos + 11` with `(Quad.foldSigned X).P03` in `r03` and
the rest of the fold's inputs in `d14 d25 h03 l14`. -/
theorem runBodyFrom_foldSignedHeadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h25 p l03 c e03 r03 l14 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedHeadRun x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 d03 d14 d25 h03 h25 p l03 c
            e03 r03 l14 ++
          rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedHeadConsts E nb03 nb sh43 sh4340 mk43 b03)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, d03.i, d14.i,
          d25.i, h03.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i].Nodup)
    (hK :
      ∀ (vd03 vh25 vp vl03 vc ve03 : ⟦.vec 8 64⟧),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := Ty.wrap (wwl_add X14 negBias), d25 :=
                Ty.wrap (wwl_add X25 negBias), h03 :=
                Ty.wrap (wwl_shr_vector (wwl_add X03 negBias03) (Vector.replicate 8 43#64)), h25 :=
                vh25, p := vp, l03 := vl03, c := vc, e03 := ve03, r03 :=
                Ty.wrap (Quad.foldSigned ⟨X03, X14, X25⟩).P03, l14 :=
                Ty.wrap (wwl_and (wwl_add X14 negBias) (Vector.replicate 8 8796093022207#64))]
              (pos + 11) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector,
    sshr40_mul19_no_overflow] with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' :
    sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  step_pure [hsc03'] with se03
  step_pure with sf03
  step_pure with sl14
  have e : (Quad.foldSigned ⟨X03, X14, X25⟩).P03 = sf03 := by
    rw [Quad.foldSigned_eq, Quad.foldSignedC_eq', hsf03, hse03, hsl03, hsd03, hsd25]
    rfl
  rw [hE, ← e, hsl14, hsh03, hsd14, hsd25, hsd03]
  exact hK _ _ _ _ _ _

/-- `runBodyFrom_foldSignedHeadRun` for `foldSignedHeadRun'`. -/
theorem runBodyFrom_foldSignedHeadRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h25 p l03 c e03 r03 l14 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedHeadRun' x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 d03 d14 d25 h03 h25 p l03 c
            e03 r03 l14 ++
          rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedHeadConsts E nb03 nb sh43 sh4340 mk43 b03)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, d03.i, d14.i,
          d25.i, h03.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i].Nodup)
    (hK :
      ∀ (vd03 vh25 vp vl03 vc ve03 : ⟦.vec 8 64⟧),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := Ty.wrap (wwl_add X14 negBias), d25 :=
                Ty.wrap (wwl_add X25 negBias), h03 :=
                Ty.wrap (wwl_shr_vector (wwl_add X03 negBias03) (Vector.replicate 8 43#64)), h25 :=
                vh25, p := vp, l03 := vl03, c := vc, e03 := ve03, r03 :=
                Ty.wrap (Quad.foldSigned ⟨X03, X14, X25⟩).P03, l14 :=
                Ty.wrap (wwl_and (wwl_add X14 negBias) (Vector.replicate 8 8796093022207#64))]
              (pos + 11) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector,
    sshr40_mul19_no_overflow] with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' :
    sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := mask_add_bias03_ok sd03
  rw [← hsl03] at hok03
  step_pure with se03
  step_pure [hsc03'] with sf03
  step_pure with sl14
  have e : (Quad.foldSigned ⟨X03, X14, X25⟩).P03 = sf03 := by
    rw [Quad.foldSigned_eq, hsf03, hse03, hsl03, hsd03, hsd25]
    rfl
  rw [hE, ← e, hsl14, hsh03, hsd14, hsd25, hsd03]
  exact hK _ _ _ _ _ _

/-- `FD_R43X6_QUAD_FOLD_SIGNED`'s low bits of limb 1 of `X`. -/
abbrev foldLow14 (X : Quad) : Wwl :=
  wwl_and (wwl_add X.P14 negBias) (Vector.replicate 8 8796093022207#64)

/-- `FD_R43X6_QUAD_FOLD_SIGNED`'s carry out of limb 0 of `X`. -/
abbrev foldHigh03 (X : Quad) : Wwl :=
  wwl_shr_vector (wwl_add X.P03 negBias03) (Vector.replicate 8 43#64)

/-- `FD_R43X6_QUAD_FOLD_SIGNED( R, x )` after `foldSignedHeadRun`: limb 1's carry `h14`,
`r14 = (l14 + b) + h03` and `r25 = (h14 + b) + l25` for limb 2's low bits `l25`. -/
def foldSignedTailRun (d14 d25 h03 l14 sh43 b mk4340 h14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e14 (.val l14.i l14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true })) r14 (.val e14.i e14.h) (.val h03.i h03.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true })) e25 (.val h14.i h14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val e25.i e25.h) (.val l25.i l25.h)]

/-- Where the body at `pos` is `foldSignedTailRun` after `foldSignedHeadRun` of `X`: running on
from `pos` then `g` gives `K` if it does from `pos + 6` with `X`'s fold's limbs 1 and 2 in
`r14 r25`. -/
theorem runBodyFrom_foldSignedTailRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {d14 d25 h03 l14 sh43 b mk4340 h14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedTailRun d14 d25 h03 l14 sh43 b mk4340 h14 e14 r14 l25 e25 r25 ++ rest)
    (hR :
      E ⊨ [d14 := wwl_add X14 negBias, d25 := wwl_add X25 negBias,
        h03 := foldHigh03 ⟨X03, X14, X25⟩, l14 := foldLow14 ⟨X03, X14, X25⟩,
        sh43 := Vector.replicate 8 43#64, b := Vector.replicate 8 1048576#64, mk4340 := m4340])
    (hd :
      [d14.i, d25.i, h03.i, l14.i, sh43.i, b.i, mk4340.i, h14.i, e14.i, r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ vh14 ve14 vl25 ve25 : ⟦.vec 8 64⟧,
        (blk.runBodyFrom
              E[h14 := vh14, e14 := ve14, r14 := Ty.wrap (Quad.foldSigned ⟨X03, X14, X25⟩).P14,
                l25 := vl25, e25 := ve25, r25 := Ty.wrap (Quad.foldSigned ⟨X03, X14, X25⟩).P25]
              (pos + 6) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hok14 := mask_add_bias_ok (wwl_add X14 negBias)
  have hok14' := mask_add_bias_add_shr_ok (wwl_add X03 negBias03) (wwl_add X14 negBias)
  step_pure with th14
  step_pure with te14
  rw [← hte14] at hok14'
  step_pure with tr14
  step_pure with tl25
  have hok25 := shr_add_bias_ok (wwl_add X14 negBias) _ (.inl rfl)
  rw [← hth14] at hok25
  step_pure with te25
  have hok25' :=
    shr43_add_bias_add_mask_ok (wwl_add X14 negBias) (wwl_add X25 negBias) _ (.inr rfl)
  rw [← hth14, ← hte25, ← htl25] at hok25'
  step_pure with tr25
  have e14 : (Quad.foldSigned ⟨X03, X14, X25⟩).P14 = tr14 := by
    rw [htr14, hte14, Quad.foldSigned_eq, Quad.foldSignedC_eq']
    rfl
  have e25 : (Quad.foldSigned ⟨X03, X14, X25⟩).P25 = tr25 := by
    rw [htr25, hte25, htl25, hth14, Quad.foldSigned_eq, Quad.foldSignedC_eq']
    rfl
  rw [hE, ← e14, ← e25]
  exact hK _ _ _ _

/-- Where the body at `pos` is `foldSignedHeadRun` then `foldSignedTailRun` and `x03 x14 x25`
hold `X`: running on from `pos` then `g` gives `K` if it does from `pos + 17` with `X`'s fold
(as `F`) in `r03 r14 r25`. -/
theorem runBodyFrom_foldSignedSplitRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h25 p l03 c e03 r03 l14 h14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedHeadRun x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 d03 d14 d25 h03 h25 p l03 c
            e03 r03 l14 ++
          (foldSignedTailRun d14 d25 h03 l14 sh43 b mk4340 h14 e14 r14 l25 e25 r25 ++ rest))
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedHeadConsts E nb03 nb sh43 sh4340 mk43 b03)
    (hb : E ⊨ [b := Vector.replicate 8 1048576#64, mk4340 := m4340])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd1 :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, d03.i, d14.i,
          d25.i, h03.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i].Nodup)
    (hd2 :
      [d14.i, d25.i, h03.i, l14.i, sh43.i, b.i, mk4340.i, h14.i, e14.i, r14.i, l25.i, e25.i].Nodup)
    (hd3 :
      [b.i, mk4340.i, d03.i, d14.i, d25.i, h03.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i,
        l14.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh25 vp vl03 vc ve03 vl14 vh14 ve14 vl25 ve25 : ⟦.vec 8 64⟧) (F : Quad)
        (_hf : Quad.foldSigned ⟨X03, X14, X25⟩ = F),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h25 := vh25, p := vp,
                l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap F.P03, l14 := vl14,
                h14 := vh14, e14 := ve14, r14 := Ty.wrap F.P14, l25 := vl25, e25 := ve25,
                r25 := Ty.wrap F.P25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern using runBodyFrom_foldSignedHeadRun inline
  step_pattern using runBodyFrom_foldSignedTailRun inline
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ rfl

/-! ### `fd_ed25519_point_neg_precomputed` of a loaded entry -/

/-- `PERMUTE( r, 1,0,2,3, r )` on one vector: lanes `0, 1` and `4, 5` swapped. -/
def swapXY (n : Wwl) : Wwl :=
  #v[n[1], n[0], n[2], n[3], n[5], n[4], n[6], n[7]]

/-- `fd_ed25519_point_neg_precomputed` as compiled: `T` replaced by `2p - T`, `X`, `Y` swapped. -/
def negPrecomputedC (A : Quad) : Quad :=
  ⟨swapXY
      #v[A.P03[0], A.P03[1], A.P03[2], 17592186044378#64 - A.P03[3], A.P03[4], A.P03[5], A.P03[6],
        17592186044414#64 - A.P03[7]],
    swapXY
      #v[A.P14[0], A.P14[1], A.P14[2], 17592186044414#64 - A.P14[3], A.P14[4], A.P14[5], A.P14[6],
        17592186044414#64 - A.P14[7]],
    swapXY
      #v[A.P25[0], A.P25[1], A.P25[2], 17592186044414#64 - A.P25[3], A.P25[4], A.P25[5], A.P25[6],
        2199023255550#64 - A.P25[7]]⟩

theorem p_add_p_sub (c x : BitVec 64) : c + (c - x) = (c + c) - x := by bv_decide

theorem neg_precomputed_spec_eq (A : Quad) :
    fd_ed25519_point_neg_precomputed.spec A = negPrecomputedC A := by
  rcases A with ⟨a, b, c⟩
  simp only [fd_ed25519_point_neg_precomputed.spec, Quad.permute, Quad.laneSubFast,
    Quad.laneAddFast, negPrecomputedC, swapXY, quadP, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [p_add_p_sub, BitVec.reduceAdd]

/-- `p`'s limbs 3 and 7, the rest poison: `FD_R43X6_QUAD_LANE_SUB_FAST( …, 0,0,0,1, _p, … )`'s. -/
abbrev negK03 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044378#64, .poison, .poison, .poison,
    .value 17592186044414#64]

/-- `negK03` for the second vector. -/
abbrev negK14 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044414#64, .poison, .poison, .poison,
    .value 17592186044414#64]

/-- `negK03` for the third vector. -/
abbrev negK25 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044414#64, .poison, .poison, .poison,
    .value 2199023255550#64]

/-- `fd_ed25519_point_neg_precomputed` of `x03 x14 x25` in registers: `p`'s limbs in
`k03 k14 k25` less them, the lanes selected into `s03 s14 s25`. -/
def negRegRun (x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.sub {})) d03 (.val k03.i k03.h) (.val x03.i x03.h),
    .binop (.vector (.sub {})) d14 (.val k14.i k14.h) (.val x14.i x14.h),
    .binop (.vector (.sub {})) d25 (.val k25.i k25.h) (.val x25.i x25.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s03
      (.val x03.i x03.h) (.val d03.i d03.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s14
      (.val x14.i x14.h) (.val d14.i d14.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s25
      (.val x25.i x25.h) (.val d25.i d25.h)]

/-- Where the body at `pos` is `negRegRun` and `x03 x14 x25` hold `X`: running on from `pos` then
`g` gives `K` if it does from `pos + 6` with `X` negated as a precomputed point in
`s03 s14 s25`. -/
theorem runBodyFrom_negRegRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = negRegRun x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hk : E ⊨ [k03 := negK03, k14 := negK14, k25 := negK25])
    (hd : [x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, d03.i, d14.i, d25.i, s03.i, s14.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 : ⟦.vec 8 64⟧) (n03 n14 n25 : Wwl)
        (_hn : fd_ed25519_point_neg_precomputed.spec ⟨X03, X14, X25⟩ = ⟨n03, n14, n25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, s03 := Ty.wrap n03, s14 := Ty.wrap n14,
                s25 := Ty.wrap n25] (pos + 6) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure with n03
  step_pure with n14
  step_pure with n25
  have e : fd_ed25519_point_neg_precomputed.spec ⟨X03, X14, X25⟩ = ⟨n03, n14, n25⟩ := by
    rw [neg_precomputed_spec_eq, hn03, hn14, hn25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ e

end

end MLIR.Firedancer.Lane.Split

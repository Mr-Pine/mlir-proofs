module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-! ### `FD_R43X6_QUAD_FOLD_SIGNED` split at the branches' join -/

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

/-- `FD_R43X6_QUAD_PERMUTE( 0,1,2,3 )` is the identity. -/
theorem Quad.permute_0123 (X : Quad) : X.permute 0 1 2 3 = X := by
  rw [Quad.permute_eq_perm4 (by decide)]
  rcases X with ⟨a, b, c⟩
  simp only [Quad.perm4, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    | simp [wwl_perm4]

/-- `FD_R43X6_QUAD_MUL_FAST( _, X, Y )` from `quadMulCore` on `X`'s halves. -/
theorem quadMul_of_core' {X Y M : Quad}
    (h :
      quadMulCore (wwl_pack_halves (X.permute 0 1 2 3).P03 0 (X.permute 0 1 2 3).P03 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 0 (X.permute 0 1 2 3).P14 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 0 (X.permute 0 1 2 3).P25 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P03 1 (X.permute 0 1 2 3).P03 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 1 (X.permute 0 1 2 3).P14 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 1 (X.permute 0 1 2 3).P25 1) Y.P03 Y.P14 Y.P25 =
        M) :
    quadMul X Y = M := by
  rw [Quad.permute_0123] at h
  rw [quadMul_eq_core]
  exact h

namespace fd_ed25519_point_add_with_opts

open _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

/-- The entry block's constants the branches read: `_1112d`, the products' and folds' shifts,
masks and biases, the lane subtractions' `p` limbs, and `19` for the folds' top carries. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := quad1112d.P25, %1 := quad1112d.P14, %2 := quad1112d.P03, %3 :=
    Vector.replicate 8 24#64, %4 := Vector.replicate 8 7#64, %5 := Vector.replicate 8 9#64, %6 :=
    Vector.replicate 8 0#64, %7 := m4340, %8 := Vector.replicate 8 1048576#64, %9 := bias03, %10 :=
    Vector.replicate 8 8796093022207#64, %12 := s4340, %13 := Vector.replicate 8 43#64, %14 :=
    negBias, %15 := negBias03, %25 := Vector.replicate 8 PoisonOr.poison, %37 :=
    #v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %45 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %53 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
      .poison, .poison],
    %61 := k19Lanes, %69 :=
    #v[.value 8796093022189#64, .poison, .poison, .value 8796093022189#64, .value 8796093022207#64,
      .poison, .poison, .value 8796093022207#64],
    %77 :=
    #v[.value 8796093022207#64, .poison, .poison, .value 8796093022207#64, .value 8796093022207#64,
      .poison, .poison, .value 8796093022207#64],
    %85 :=
    #v[.value 8796093022207#64, .poison, .poison, .value 8796093022207#64, .value 1099511627775#64,
      .poison, .poison, .value 1099511627775#64]]

/-- `FD_R43X6_QUAD_FOLD_SIGNED`'s low bits of limb 1 of `X`. -/
abbrev foldLow14 (X : Quad) : Wwl :=
  wwl_and (wwl_add X.P14 negBias) (Vector.replicate 8 8796093022207#64)

/-- `FD_R43X6_QUAD_FOLD_SIGNED`'s carry out of limb 0 of `X`. -/
abbrev foldHigh03 (X : Quad) : Wwl :=
  wwl_shr_vector (wwl_add X.P03 negBias03) (Vector.replicate 8 43#64)

/-- `^bb3`'s env: `FD_R43X6_QUAD_FOLD_SIGNED` of `X` begun, limb 0 done; `a1 a2` limb 1's low bits
and limb 0's carry, in either order. -/
abbrev hdr3 (E : ⟪Γ⟫) (X : Quad) (a1 a2 : Wwl) : ⟪Γ⟫ :=
  E[rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 541 := Ty.wrap a1,
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 542 := Ty.wrap a2,
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 543 :=
    Ty.wrap (wwl_add X.P25 negBias),
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 544 :=
    Ty.wrap (wwl_add X.P14 negBias),
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 545 :=
    Ty.wrap (Quad.foldSigned X).P03]

/-- `^bb3`, the end of `FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )` on `X` and the rest of
`FD_R43X6_GE_ADD` (`FD_R43X6_GE_ADD_TABLE_ALT`): `r` gets the sum. -/
theorem tail (r a b : Pointer) (pre : BitVec 32) (X : Quad) (a1 a2 : Wwl) (S : GlobalState)
    (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (ha12 : a1 = foldLow14 X ∧ a2 = foldHigh03 X ∨ a1 = foldHigh03 X ∧ a2 = foldLow14 X)
    (hwf : S.WF) (hr : S.mem.QuadRoom r)
    (hK :
      g
          (.cons (.value r) .nil,
            { S with
              mem :=
                S.mem.storeQuad r
                  (Quad.foldUnsigned
                    (quadMul ((Quad.foldSigned X).permute 0 2 2 0)
                      ((Quad.foldSigned X).permute 3 1 3 1))) }) =
        K) :
    (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.runFrom (hdr3 E X a1 a2) 3 S >>=
        g) =
      K := by
  block_init
  -- `(a1 + b) + a2`: no signed overflow either way round
  have hok14 : ∀ i : Fin 8, a1[i].saddOverflow (Vector.replicate 8 1048576#64)[i] = false := by
    rcases ha12 with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact fun i => (mask_add_bias_ok _ i).1
    · exact shr_add_bias_ok _ _ (.inl rfl)
  have hok14' :
    ∀ i : Fin 8, (wwl_add a1 (Vector.replicate 8 1048576#64))[i].saddOverflow a2[i] = false := by
    rcases ha12 with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact mask_add_bias_add_shr_ok _ _
    · exact fun i => (shr43_add_bias_add_mask_ok _ _ _ (.inl rfl) i).1
  step_pure with th14
  step_pure with te14
  rw [← hte14] at hok14'
  step_pure with tr14
  step_pure with tl25
  have hok25 := shr_add_bias_ok (wwl_add X.P14 negBias) _ (.inl rfl)
  rw [← hth14] at hok25
  step_pure with te25
  have hok25' :=
    shr43_add_bias_add_mask_ok (wwl_add X.P14 negBias) (wwl_add X.P25 negBias) _ (.inr rfl)
  rw [← hth14, ← hte25, ← htl25] at hok25'
  step_pure with tr25
  clear hok14 hok14' hok25 hok25'
  have eF : Quad.foldSigned X = ⟨(Quad.foldSigned X).P03, tr14, tr25⟩ := by
    rw [htr14, htr25, hte14, hte25, htl25, hth14]
    rcases ha12 with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · rw [Quad.foldSigned_eq, Quad.foldSignedC_eq']
      rfl
    · rw [Quad.foldSigned_eq]
      rfl
  -- FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb ), then FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb )
  -- fused into FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
  step_pattern using runBodyFrom_permuteRun 3 1 3 1
  have e1 := _hp
  step_pattern using runBodyFrom_halvesRun 0 2 2 0 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e2 := quadMul_of_core e1 _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have e3 := _hu
  finish_block
  rw [eF, e2, Quad.foldUnsigned_eq, e3] at hK
  subst hS hv650
  exact hK

/-- `^bb1`, `FD_R43X6_GE_ADD_TABLE_ALT( P3, A, T )`, then `^bb3`: `r` gets `geAddTable` of the
points at `a` and `b`. -/
theorem geAddTable_run (r a b : Pointer) (pre : BitVec 32) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hK :
      g
          (.cons (.value r) .nil,
            { S with
              mem :=
                S.mem.storeQuad r (geAddTable quadMul (S.mem.readQuad a) (S.mem.readQuad b)) }) =
        K) :
    (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.runFrom E 1 S >>= g) = K := by
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  step_pattern using runBodyFrom_quadLoadRun
  have eB : B = ⟨l03, l14, l25⟩ := by
    rw [← hB]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P1 ), only the lanes the subtraction reads
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eA : A = ⟨l03, l14, l25⟩ := by
    rw [← hA]; simpa only [hS] using _hx
  clear ha hb
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, P1 )
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, P1 )
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have eF1 := (Quad.foldSigned_eq _).trans _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e4 := quadMul_of_core' (Y := ⟨s03, s14, s25⟩) _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta ); its lanes are below `2^44`
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := (Quad.foldUnsigned_eq _).trans _hu
  obtain ⟨hu03, hu14, hu25⟩ := Quad.foldUnsignedC_lt _hu
  have hpa03 := wwl_perm4_lt hu03 1 0 3 2
  have hpa14 := wwl_perm4_lt hu14 1 0 3 2
  have hpa25 := wwl_perm4_lt hu25 1 0 3 2
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused; the code's
  -- `nsw` holds
  step_pattern using runBodyFrom_permSubAddRun (hs03 := fun _ => sub_lt_ok hpa03 hu03) (hs14 :=
    fun _ => sub_lt_ok hpa14 hu14) (hs25 := fun _ => sub_lt_ok hpa25 hu25) (ha03 := fun _ =>
    sub_add_lt_ok hpa03 hu03 quadP_lt.1) (ha14 := fun _ => sub_add_lt_ok hpa14 hu14 quadP_lt.2.1)
    (ha25 := fun _ => sub_add_lt_ok hpa25 hu25 quadP_lt.2.2) (ho14 := fun _ k =>
    add_lane_ok (hpa14 k) (hu14 k)) (ho25 := fun _ k => add_lane_ok (hpa25 k) (hu25 k))
  have e5 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb ), to limb 0
  step_pattern using runBodyFrom_foldSignedHeadRun inline
  have eT :
    geAddTable quadMul A B =
      Quad.foldUnsigned
        (quadMul ((Quad.foldSigned ⟨s03, s14, s25⟩).permute 0 2 2 0)
          ((Quad.foldSigned ⟨s03, s14, s25⟩).permute 3 1 3 1)) := by
    simp only [geAddTable]
    rw [eA, eB, e2, e3, eF1, e4, eU1, e5]
  rw [eT] at hK
  finish_block
  step_loop using tail r a b pre ⟨s03, s14, s25⟩ _ _ S

/-- `FD_R43X6_GE_ADD`'s operands before the folds: `P.permute 1 0 2 3` less `P` in limb `X`, plus
`P` in limbs `Y`, `Z` (`i2 = 1`). -/
def addPrep (P : Quad) (i2 : Nat) : Quad :=
  let t := P.permute 1 0 2 3
  let t := t.laneSubFast 1 0 0 0 t P
  t.laneAddFast 0 1 i2 0 t P

/-- `FD_R43X6_GE_ADD` after `FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )`, on its result `T`. -/
def geAddTail (T : Quad) : Quad :=
  let _tb := T.permute 1 0 3 2
  let _tb := _tb.laneSubFast 1 0 0 1 _tb T
  let _tb := _tb.laneAddFast 0 1 1 0 _tb T
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 2 2 0
  let _tb := _tb.permute 3 1 3 1
  let _ta := quadMul _ta _tb
  _ta.foldUnsigned

theorem geAdd_eq (A B : Quad) :
    geAdd quadMul A B =
      geAddTail
        (quadMul (quadMul (addPrep A 1).foldSigned quad1112d).foldUnsigned
          (addPrep B 0).foldSigned) :=
  rfl

theorem addPrep_fold_of {P L T2 T3 F : Quad} {i2 : Nat} (hP : P = L)
    (h2 : (L.permute 1 0 2 3).laneSubFast 1 0 0 0 (L.permute 1 0 2 3) L = T2)
    (h3 : T2.laneAddFast 0 1 i2 0 T2 L = T3) (hF : T3.foldSigned = F) :
    (addPrep P i2).foldSigned = F := by
  subst_vars
  rfl

/-- `^bb2` up to `FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )` after the product by `_1112d`, in `U`,
and `FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )` in `FB`. -/
theorem geAdd_seg {r a b : Pointer} {pre : BitVec 32} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 0 = bb2.body.drop 0) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hwf : S.WF) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hK :
      ∀ (E' : ⟪Γ⟫) (U FB : Quad),
        E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get →
          Consts E' →
          (E' ⊨ [rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 424 :=
            U.P03, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 426 :=
            U.P14, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 428 :=
            U.P25, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 328 :=
            FB.P03, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 331 :=
            FB.P14, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.hty 334 :=
            FB.P25]) →
          ∀ (_hU : (quadMul (addPrep (S.mem.readQuad a) 1).foldSigned quad1112d).foldUnsigned = U)
            (_hFB : (addPrep (S.mem.readQuad b) 0).foldSigned = FB),
            (blk.runBodyFrom E' 174 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P1 ); FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P2 ), only
  -- the lanes the subtractions read
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eA := _hx
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eB := _hx
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, P1 ); the same for `_tb`, `P2`
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2' := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,1,0, _ta, P1 ); `( _tb, _tb, 0,1,0,0, _tb, P2 )`
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3' := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _ta, _ta ); FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have eF1 := (Quad.foldSigned_eq _).trans _hs
  step_pattern using runBodyFrom_foldSignedRun
  have eF2 := (Quad.foldSigned_eq _).trans _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _1112d )
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e4 := quadMul_of_core' (Y := quad1112d) _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := (Quad.foldUnsigned_eq _).trans _hu
  subst hS
  refine hK _ ⟨u03, u14, u25⟩ _ hArgs ?_ ?_ ?_ (addPrep_fold_of eB e2' e3' eF2)
  · dsimp only [Consts]
    env_reads
  · env_reads
  · rw [addPrep_fold_of eA e2 e3 eF1, e4, eU1]

/-- `^bb2`, `FD_R43X6_GE_ADD( P3, A, B )`, then `^bb3`: `r` gets `geAdd` of the points at `a` and
`b`. -/
theorem geAdd_run (r a b : Pointer) (pre : BitVec 32) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hK :
      g
          (.cons (.value r) .nil,
            { S with
              mem := S.mem.storeQuad r (geAdd quadMul (S.mem.readQuad a) (S.mem.readQuad b)) }) =
        K) :
    (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.runFrom E 2 S >>= g) = K := by
  block_init
  step_pattern using geAdd_seg
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e5 := quadMul_of_core' (Y := FB) _hm
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused
  step_pattern using runBodyFrom_permSubAddRun
  have e6 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb ), to limb 0
  step_pattern using runBodyFrom_foldSignedHeadRun' inline
  rw [hS] at _hU _hFB
  rw [geAdd_eq, _hFB, _hU, e5] at hK
  simp only [geAddTail] at hK
  rw [e6, ← hS] at hK
  finish_block
  step_loop using tail r a b pre ⟨s03, s14, s25⟩ _ _ S

end fd_ed25519_point_add_with_opts

/-- `fd_ed25519_point_add_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_add_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts.args (.value r) (.value a)
          (.value b) (.value pre))
        s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  pre) }) := by
  func_init
  block_init
  iterate 30 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  step_pure
  finish_block
  · -- `!b_is_precomputed`: FD_R43X6_GE_ADD
    subst hbr
    step_loop using fd_ed25519_point_add_with_opts.geAdd_run r a b 0
    subst hS
    rfl
  · -- `b_is_precomputed`: FD_R43X6_GE_ADD_TABLE_ALT
    have hpre : pre ≠ 0 := hbr
    step_loop using fd_ed25519_point_add_with_opts.geAddTable_run r a b pre
    subst hS
    simp only [fd_ed25519_point_add_with_opts.spec, ne_eq, hpre, not_false_eq_true, ↓reduceIte]

end Proof

end MLIR.Firedancer.Lane

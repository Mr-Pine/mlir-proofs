module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Common.Quad

/-! Patterns of the point utilities (`fd_ed25519_point_sub`, …) as the lane build compiles them. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- A point stored vector by vector where there is room, read back. -/
@[mlir_read]
theorem _root_.MLIR.MemoryState.readQuad_storeAt_quad_self {m : MemoryState} {p : Pointer}
    {a b c : Wwl} (h : m.QuadRoom p) :
    (((m.storeAt p (BitVec.packLanes a)).storeAt (p.add 64#64) (BitVec.packLanes b)).storeAt
          (p.add 128#64) (BitVec.packLanes c)).readQuad p = ⟨a, b, c⟩ :=
  MemoryState.readQuad_storeQuad_self (P := ⟨a, b, c⟩) h

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-- `foldUnsignedStoreRun` with `q + 64` computed before, in `g1`. -/
def foldUnsignedStoreRunG2
    (x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64))
    (q : Reg Γ .ptr) (g1 g2 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) h03 (.val x03.i x03.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h14 (.val x14.i x14.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h25 (.val x25.i x25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val x03.i x03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val c.i c.h) (.val l03.i l03.h),
    .store q (.val r03.i r03.h), .binop (.vector .and) l14 (.val x14.i x14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val l14.i l14.h) (.val h03.i h03.h),
    .store (.val g1.i g1.h) (.val r14.i r14.h),
    .binop (.vector .and) l25 (.val x25.i x25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val l25.i l25.h) (.val h14.i h14.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g2 q,
    .store (.val g2.i g2.h) (.val r25.i r25.h)]

/-- `runBodyFrom_foldUnsignedStoreRun` for `foldUnsignedStoreRunG2`, `g1` holding `Q + 64`. -/
theorem runBodyFrom_foldUnsignedStoreRunG2 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64)}
    {q : Reg Γ .ptr} {g1 g2 : Dst Γ .ptr} {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldUnsignedStoreRunG2 x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14
            r14 l25 r25 q g1 g2 ++
          rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, sh43 := Vector.replicate 8 43#64, sh4340 :=
        #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], mk43 :=
        Vector.replicate 8 8796093022207#64, mk4340 :=
        #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
          1099511627775#64, 1099511627775#64, 1099511627775#64]])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes) (hq : E.read q = .value Q)
    (hg1 : E.read (.val g1.i g1.h) = .value (Q.add 64#64)) (hwf : S.WF) (hQ : S.mem.QuadRoom Q)
    (hd :
      [x03.i, x14.i, x25.i, sh43.i, sh4340.i, k19.i, mk43.i, mk4340.i, h03.i, h14.i, h25.i, p.i,
          l03.i, c.i, r03.i, l14.i, r14.i, l25.i, g1.i, r25.i, g2.i].Nodup)
    (hK :
      ∀ (vh03 vh14 vh25 vp vl03 vc vl14 vl25 : ⟦.vec 8 64⟧) (u03 u14 u25 : Wwl)
        (_hu : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨u03, u14, u25⟩),
        (blk.runBodyFrom
              E[h03 := vh03, h14 := vh14, h25 := vh25, p := vp, l03 := vl03, c := vc, r03 :=
                Ty.wrap u03, l14 := vl14, r14 := Ty.wrap u14, l25 := vl25, r25 := Ty.wrap u25,
                g2 := .value (Q.add 128#64)]
              (pos + 15)
              { alloc := S.alloc,
                mem :=
                  ((S.mem.storeAt Q (BitVec.packLanes u03)).storeAt (Q.add 64#64)
                        (BitVec.packLanes u14)).storeAt
                    (Q.add 128#64) (BitVec.packLanes u25) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent uh03
  step_pure with transparent uh14
  step_pure with transparent uh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shru_vector,
    shr40_mul19_no_overflow] with transparent up
  step_pure with ul03
  step_pure with uc
  have huc' :
    uc =
      wwl_pack_halves (wwl_mul (wwl_shru_vector X25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shru_vector X25 s4340) 0 := by
    rw [huc]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := fold_ok03 X25 X03
  rw [← hul03, ← huc'] at hok03
  step_pure with uf03
  step_store
  step_pure with ul14
  have hok14 := fold_ok _ X14 X03 (.inl rfl)
  rw [← hul14, ← huh03] at hok14
  step_pure with uf14
  step_store
  step_pure with ul25
  have hok25 := fold_ok quadFoldMask X25 X14 (.inr rfl)
  rw [← hul25, ← huh14] at hok25
  step_pure with uf25
  step_pure
  step_store
  have e : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨uf03, uf14, uf25⟩ := by
    rw [huf03, huf14, huf25, hul03, hul14, hul25]
    rfl
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ e

/-- `FD_R43X6_QUAD_PACK( r->P, x, y, one, t )` as sixteen instructions: `quadPackRun` storing at
`q`, `g1 = q + 64` and `g2 = q + 128`, each `getelementptr` just before its store. -/
def quadPackStoreRun (x y zlo zhi t a b c d e f g h q03 q14 q25 : Dst Γ V) (q : Reg Γ .ptr)
    (g1 g2 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 1, some 8, some 9, some 4, some 5, some 12, some 13]) a
      (.val x.i x.h) (.val zlo.i zlo.h),
    .binop (.shufflevector #v[some 0, some 1, some 8, some 9, some 4, some 5, some 12, some 13]) b
      (.val y.i y.h) (.val t.i t.h),
    .binop (.shufflevector #v[some 2, some 3, some 10, some 11, some 6, some 7, some 12, some 13]) c
      (.val x.i x.h) (.val zhi.i zhi.h),
    .binop (.shufflevector #v[some 2, some 3, some 10, some 11, some 6, some 7, some 12, some 13]) d
      (.val y.i y.h) (.val t.i t.h),
    .binop (.shufflevector #v[some 0, some 8, some 2, some 10, none, none, none, none]) e
      (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[none, none, none, none, some 5, some 13, some 7, some 15]) f
      (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 0, some 8, some 2, some 10, none, none, none, none]) g
      (.val c.i c.h) (.val d.i d.h),
    .binop (.shufflevector #v[some 1, some 9, some 3, some 11, none, none, none, none]) h
      (.val c.i c.h) (.val d.i d.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) q03
      (.val e.i e.h) (.val h.i h.h),
    .store q (.val q03.i q03.h),
    .binop (.shufflevector #v[some 1, some 9, some 3, some 11, some 4, some 12, some 6, some 14])
      q14 (.val a.i a.h) (.val b.i b.h),
    .unop (.gepConst { nusw := true, nuw := true } 64) g1 q,
    .store (.val g1.i g1.h) (.val q14.i q14.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      q25 (.val g.i g.h) (.val f.i f.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g2 q,
    .store (.val g2.i g2.h) (.val q25.i q25.h)]

/-- Where the body at `pos` is `quadPackStoreRun`, `x y t` hold `X Y T`, `zlo zhi` hold `oneLo
oneHi` and `q` the point `Q`: running on from `pos` then `k` gives `K` if it does from `pos + 16`
with `Quad.pack X Y one T` stored at `Q`, whatever the intermediates hold. -/
theorem runBodyFrom_quadPackStoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x y zlo zhi t a b c d e f g h q03 q14 q25 : Dst Γ V} {q : Reg Γ .ptr} {g1 g2 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {X Y T : Wwl} {Q : Pointer} {S : GlobalState}
    {k : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadPackStoreRun x y zlo zhi t a b c d e f g h q03 q14 q25 q g1 g2 ++ rest)
    (hR : E ⊨ [x := X, y := Y, zlo := oneLo, zhi := oneHi, t := T])
    (hq : E.read q = .value Q) (hqg : q ≠ .val g1.i g1.h) (hwf : S.WF) (hQ : S.mem.QuadRoom Q)
    (hd :
      [x.i, y.i, zlo.i, zhi.i, t.i, a.i, b.i, c.i, d.i, e.i, f.i, g.i, h.i, q03.i, q14.i, g1.i,
          q25.i].Nodup)
    (hK :
      ∀ va vb vc vd ve vf vg vh vq03 vq14 vq25 : ⟦V⟧,
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, e := ve, f := vf, g := vg, h := vh, q03 := vq03,
                q14 := vq14, g1 := .value (Q.add 64#64), q25 := vq25, g2 := .value (Q.add 128#64)]
              (pos + 16)
              { S with
                mem :=
                  ((S.mem.storeAt Q (BitVec.packLanes (Quad.pack X Y one T).P03)).storeAt
                        (Q.add 64#64) (BitVec.packLanes (Quad.pack X Y one T).P14)).storeAt
                    (Q.add 128#64) (BitVec.packLanes (Quad.pack X Y one T).P25) } >>=
            k) =
          K) :
    (blk.runBodyFrom E pos S >>= k) = K := by
  -- the shuffles `a … h` only feed the stored ones: left inline
  iterate 8 step_pure
  step_pure with vq03
  step_store
  step_pure with vq14
  step_pure
  step_store
  step_pure with vq25
  step_pure
  step_store
  have e03 : vq03 = (Quad.pack X Y one T).P03 := by
    rw [hvq03]; rfl
  have e14 : vq14 = (Quad.pack X Y one T).P14 := by
    rw [hvq14]; rfl
  have e25 : vq25 = (Quad.pack X Y one T).P25 := by
    rw [hvq25]; rfl
  subst hE hS
  rw [e03, e14, e25]
  exact hK _ _ _ _ _ _ _ _ _ _ _

end Patterns

end

end MLIR.Firedancer.Lane

module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Common.ModNearlyReducedLimbs
public import Firedancer.Avx512.Common.Quad
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Common.Decode
public import Firedancer.Avx512.Common.Sub
import Mathlib.Data.Fintype.Basic
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases

/-! Patterns of the point utilities (`fd_ed25519_point_sub`, …) as the lane build compiles them. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `fd_r43x6_mod_nearly_reduced_limbs(x, y)` as written: `y = x + 19` carried up, bit 255
cleared, `19` taken back off unless the carry `c` out of bit 255 is positive. -/
def modNearlyC (x : Limbs) : Limbs :=
  let y := carryLimbs (x.y0 + 19) x.y1 x.y2 x.y3 x.y4
  let y5 := x.y5 + y.c
  let c := y5.sshiftRight 40
  let y5 := y5 &&& m40
  let r := carryLimbs (y.y0 - (19 &&& (c - 1).sshiftRight 63)) y.y1 y.y2 y.y3 y.y4
  ⟨r.y0, r.y1, r.y2, r.y3, r.y4, y5 + r.c⟩

/-- `fd_r43x6_pack` of the limbs `r`: four 64-bit words, limb `k` from bit `43 k`. -/
def packWv (r : Limbs) : Wv :=
  #v[r.y0 ||| r.y1 <<< 43 ||| r.y1 <<< 43, r.y1 >>> 21 ||| r.y2 <<< 22 ||| r.y2 <<< 22,
    r.y2 >>> 42 ||| r.y3 <<< 1 ||| r.y4 <<< 44, r.y4 >>> 20 ||| r.y5 <<< 23 ||| r.y5 <<< 23]

/-- A point stored vector by vector where there is room, read back. -/
@[mlir_read]
theorem _root_.MLIR.MemoryState.readQuad_storeAt_quad_self {m : MemoryState} {p : Pointer}
    {a b c : Wwl} (h : m.QuadRoom p) :
    (((m.storeAt p (BitVec.packLanes a)).storeAt (p.add 64#64) (BitVec.packLanes b)).storeAt
          (p.add 128#64) (BitVec.packLanes c)).readQuad p = ⟨a, b, c⟩ :=
  MemoryState.readQuad_storeQuad_self (P := ⟨a, b, c⟩) h

/-- Lanes stored vector by vector where there is room, read back. -/
@[mlir_read]
theorem _root_.MLIR.MemoryState.readVec_storeAt_packLanes_self {m : MemoryState} {p : Pointer}
    {v : Wwl} (h : Room m p 512) : (m.storeAt p (BitVec.packLanes v)).readVec p = v :=
  MemoryState.readVec_storeVec_self h

/-- Lanes in another block are unaffected by `storeAt`. -/
@[mlir_state, mlir_read]
theorem _root_.MLIR.MemoryState.readVec_storeAt_of_id_ne {m : MemoryState} {x : BitVec w}
    (h : q.id ≠ p.id) : (m.storeAt q x).readVec p = m.readVec p := by
  rw [MemoryState.readVec, MemoryState.readVec, MemoryState.readAt_storeAt_disjoint]
  simp [Range.Disjoint, Range.of, h]

section SubOne

/-- `fd_r43x6_sub( x, one )` as nine instructions: `x + k` in `d`, then `negRun`'s fold: low bits
`lo`, carries `hi` rotated into `c`, `18 ×` lane 0's in `u`, summed as `lo + b`, `+ c`, `+ u` into
`r`. -/
def subOneRun (x k mask shifts b z o m18 d lo hi c t u s1 s2 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d (.val x.i x.h) (.val k.i k.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .binop (.shufflevector negRotMask) c (.val hi.i hi.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val m18.i m18.h),
    .binop (.vector (.add { nsw := true, nuw := true })) s1 (.val lo.i lo.h) (.val b.i b.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val c.i c.h),
    .binop (.vector (.add {})) r (.val s2.i s2.h) (.val u.i u.h)]

/-- Where the body at `pos` is `subOneRun`, `x` holds `X`, `k` holds `K` and the others the fold's
constants: running on from `pos` then `g` gives `K'` if it does from `pos + 9` with
`foldSignedPre (vadd X K)` plus the bias in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_subOneRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x k mask shifts b z o m18 d lo hi c t u s1 s2 r : Dst Γ V} {rest : List (Instr Γ)}
    {X K : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K' : PoisonOr β}
    (hbody : blk.body.drop pos = subOneRun x k mask shifts b z o m18 d lo hi c t u s1 s2 r ++ rest)
    (hR :
      E ⊨ [x := X, k := K, mask := foldMask, shifts := foldShifts, b := negBias, z := zeroLo,
        o := neg18, m18 := negSel])
    (hd :
      [x.i, k.i, mask.i, shifts.i, b.i, z.i, o.i, m18.i, d.i, lo.i, hi.i, c.i, t.i, u.i, s1.i,
          s2.i].Nodup)
    (hK :
      ∀ vd vlo vhi vc vt vu vs1 vs2 : ⟦V⟧,
        (blk.runBodyFrom
              E[d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 := vs1, s2 := vs2, r :=
                Ty.wrap (vadd (foldSignedPre (vadd X K)) negBias)]
              (pos + 9) S >>=
            g) =
          K') :
    (blk.runBodyFrom E pos S >>= g) = K' := by
  simp only [subOneRun] at hbody
  step_pure with transparent vd
  step_pure with transparent vlo
  step_pure [foldShifts_lt] with transparent vhi
  step_pure with transparent vc
  step_pure with transparent vt
  step_pure with transparent vu
  step_pure with transparent vs1
  step_pure with transparent vs2
  step_pure with vr
  rw [hE, ← hK]
  congr
  subst hvr
  delta foldSignedPre
  apply vec_ext_fin
  intro i
  fin_cases i <;>
    simp [Ty.wrap_vec, and40_add_b20, and43_add_bias, and_allOnes_lit, negRot, foldMask,
      foldShifts, negBias, neg18, negSel, wwl_add, wwl_and] <;>
    ac_rfl

end SubOne

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

/-- `quadPackStoreRun` with `q + 64` and `q + 128` computed before, in `g1` and `g2`. -/
def quadPackStoreRun' (x y zlo zhi t a b c d e f g h q03 q14 q25 : Dst Γ V) (q : Reg Γ .ptr)
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
    .store (.val g1.i g1.h) (.val q14.i q14.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      q25 (.val g.i g.h) (.val f.i f.h),
    .store (.val g2.i g2.h) (.val q25.i q25.h)]

/-- `runBodyFrom_quadPackStoreRun` for `quadPackStoreRun'`, `g1` and `g2` holding `Q + 64` and
`Q + 128`. -/
theorem runBodyFrom_quadPackStoreRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x y zlo zhi t a b c d e f g h q03 q14 q25 : Dst Γ V} {q : Reg Γ .ptr} {g1 g2 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {X Y T : Wwl} {Q : Pointer} {S : GlobalState}
    {k : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadPackStoreRun' x y zlo zhi t a b c d e f g h q03 q14 q25 q g1 g2 ++ rest)
    (hR : E ⊨ [x := X, y := Y, zlo := oneLo, zhi := oneHi, t := T])
    (hq : E.read q = .value Q) (hg1 : E.read (.val g1.i g1.h) = .value (Q.add 64#64))
    (hg2 : E.read (.val g2.i g2.h) = .value (Q.add 128#64)) (hwf : S.WF) (hQ : S.mem.QuadRoom Q)
    (hd :
      [x.i, y.i, zlo.i, zhi.i, t.i, a.i, b.i, c.i, d.i, e.i, f.i, g.i, h.i, q03.i, q14.i, g1.i,
          q25.i, g2.i].Nodup)
    (hK :
      ∀ va vb vc vd ve vf vg vh vq03 vq14 vq25 : ⟦V⟧,
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, e := ve, f := vf, g := vg, h := vh, q03 := vq03,
                q14 := vq14, q25 := vq25]
              (pos + 14)
              { S with
                mem :=
                  ((S.mem.storeAt Q (BitVec.packLanes (Quad.pack X Y one T).P03)).storeAt
                        (Q.add 64#64) (BitVec.packLanes (Quad.pack X Y one T).P14)).storeAt
                    (Q.add 128#64) (BitVec.packLanes (Quad.pack X Y one T).P25) } >>=
            k) =
          K) :
    (blk.runBodyFrom E pos S >>= k) = K := by
  iterate 8 step_pure
  step_pure with vq03
  step_store
  step_pure with vq14
  step_store
  step_pure with vq25
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

/-! ### `fd_r43x6_mul_fast` with its lanes 6 and 7 left undefined -/

private theorem and_allOnes_64 (x : BitVec 64) : x &&& 18446744073709551615#64 = x := by
  bv_decide

theorem zipWith_mul_wrap_low6 (x y : Wwl) :
    Vector.zipWith (Operation.mul {} (w := 64)) (Ty.wrap (t := .vec 8 64) x) (low6 y) =
      low6 (wwl_mul x y) := by
  ext i hi
  simp only [Vector.getElem_zipWith, lanesBelow_getElem, Ty.wrap_vec, Vector.getElem_map]
  split <;> simp [wwl_mul, Operation.mul]

theorem zipWith_add_wrap_low6 (x y : Wwl) :
    Vector.zipWith (Operation.add {} (w := 64)) (Ty.wrap (t := .vec 8 64) x) (low6 y) =
      low6 (wwl_add x y) := by
  ext i hi
  simp only [Vector.getElem_zipWith, lanesBelow_getElem, Ty.wrap_vec, Vector.getElem_map]
  split <;> simp [wwl_add, Operation.add]

theorem low6_congr {x y : Wwl} (h : ∀ i (hi : i < 6), x[i] = y[i]) : low6 x = low6 y := by
  ext i hi
  simp only [lanesBelow_getElem]
  split
  · rw [h i (by omega)]
  · rfl

/-- `fold152Run` without `za`'s mask, `c24` holding `24` in lanes `0 … 5` only: the lanes `6 7`
the code never reads are left undefined. -/
def fold152LowRun (zl zh c7 c24 zb b7 s7 b24 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13])
      zb (.val zl.i zl.h) (.val zh.i zh.h),
    .binop (.vector (.shl {})) b7 (.val zb.i zb.h) (.val c7.i c7.h),
    .binop (.vector (.add {})) s7 (.val b7.i b7.h) (.val zl.i zl.h),
    .binop (.vector (.mul {})) b24 (.val zb.i zb.h) (.val c24.i c24.h),
    .binop (.vector (.add {})) r (.val s7.i s7.h) (.val b24.i b24.h)]

/-- Where the body at `pos` is `fold152LowRun`, `zl` holds `ZL` and `zh` lanes `0 … 5` of `ZH`:
`r` gets lanes `0 … 5` of `fold152 ZL ZH`. -/
theorem runBodyFrom_fold152LowRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {zl zh c7 c24 zb b7 s7 b24 r : Dst Γ V} {rest : List (Instr Γ)}
    {ZL ZH : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = fold152LowRun zl zh c7 c24 zb b7 s7 b24 r ++ rest)
    (hR : E ⊨ [zl := ZL, zh := low6 ZH, c7 := Vector.replicate 8 7])
    (h24 : E.read (.val c24.i c24.h) = low6 (Vector.replicate 8 24))
    (hd : [zl.i, zh.i, c7.i, c24.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hK :
      ∀ vzb vb7 vs7 vb24 : ⟦V⟧,
        (blk.runBodyFrom
              E[zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24, r := low6 (fold152 ZL ZH)]
              (pos + 5) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [lanesBelow_getElem] with transparent vzb
  step_pure with transparent vb7
  step_pure with transparent vs7
  step_pure [lanesBelow_getElem] with transparent vb24
  step_pure [lanesBelow_getElem] with vr
  have e : vr = low6 (fold152 ZL ZH) := by
    rw [hvr, zipWith_mul_wrap_low6, zipWith_add_wrap_low6]
    refine low6_congr fun i hi => ?_
    obtain _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | simp [fold152, wwl_and, wwl_add, wwl_mul, wwl_shl, wwl_shl_vector, wwl_slide, add_mul152,
          and_allOnes_64]
  rw [hE, e]
  exact hK _ _ _ _

/-- `mulRowsRun` with `fold152LowRun` for its last two runs: `fd_r43x6_mul_fast`, unfolded, its
lanes 6 and 7 undefined. -/
def mulFastRowsRun (y : Reg Γ V)
    (x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V)
    (a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V)
    (c7 c24 zb b7 s7 b24 r : Dst Γ V) : List (Instr Γ) :=
  hiRun zr nine x0 y uh0 ph0 ++
    (loRun ph0 x1 y t1 ++
      (hiRun zr nine x1 y uh1 ph1 ++
        (loRun ph1 x2 y t2 ++
          (hiRun zr nine x2 y uh2 ph2 ++
            (loRun ph2 x3 y t3 ++
              (hiRun zr nine x3 y uh3 ph3 ++
                (loRun ph3 x4 y t4 ++
                  (hiRun zr nine x4 y uh4 ph4 ++
                    (loRun ph4 x5 y t5 ++
                      (hiRun zr nine x5 y uh5 t6 ++
                        (slidesRun a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 p1 p2 p3 q3 p4 q4
                            p5 q5 p6 q6 ++
                          (loRun p1 x0 y s1 ++
                            (sumsRun s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 s2 s3 s4 s5 zl h1 h2 zh ++
                              fold152LowRun zl zh c7 c24 zb b7 s7 b24 r)))))))))))))

/-- `mulFastRowsRun`'s constants: the splats and the slides' zero operands, `7` and `24`. -/
abbrev MulFastConsts (E : ⟪Γ⟫) (zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 c7 c24 : Dst Γ V) : Prop :=
  E ⊨ [zr := wwl_zero, nine := Vector.replicate 8 9, a1 := lanesFrom 7 wwl_zero, a2 :=
    lanesFrom 6 wwl_zero, a3 := lanesFrom 5 wwl_zero, b3 := lanesBelow 3 wwl_zero, a4 :=
    lanesFrom 4 wwl_zero, b4 := lanesBelow 2 wwl_zero, a5 := lanesFrom 3 wwl_zero, b5 :=
    lanesBelow 1 wwl_zero, a6 := lanesFrom 2 wwl_zero, c7 := Vector.replicate 8 7, c24 :=
    low6 (Vector.replicate 8 24)]

/-- Where the body at `pos` is `mulFastRowsRun` on a value `y` holding `Y`, `x0 … x5` hold `X`'s
lanes `0 … 5` broadcast and the others the constants: running on from `pos` then `g` gives `K` if
it does from `pos + 41` with lanes `0 … 5` of `fd_r43x6_mul_fast.spec X Y` in `r`, whatever the
intermediates hold. -/
theorem runBodyFrom_mulFastRowsRun (X : Wwl) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {y : Dst Γ V}
    {x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V}
    {c7 c24 zb b7 s7 b24 r : Dst Γ V} {rest : List (Instr Γ)}
    {Y : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulFastRowsRun (.val y.i y.h) x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3
            uh3 ph3 t4 uh4 ph4 t5 uh5 t6 a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6
            s1 s2 s3 s4 s5 zl h1 h2 zh c7 c24 zb b7 s7 b24 r ++
          rest)
    (hR :
      E ⊨ [y := Y, x0 := Vector.replicate 8 X[0], x1 := Vector.replicate 8 X[1], x2 :=
        Vector.replicate 8 X[2], x3 := Vector.replicate 8 X[3], x4 := Vector.replicate 8 X[4], x5 :=
        Vector.replicate 8 X[5]])
    (hC : MulFastConsts E zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 c7 c24)
    (hd :
      [y.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zr.i, nine.i, uh0.i, ph0.i, t1.i, uh1.i, ph1.i,
          t2.i, uh2.i, ph2.i, t3.i, uh3.i, ph3.i, t4.i, uh4.i, ph4.i, t5.i, uh5.i, t6.i, a1.i, a2.i,
          a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i,
          p6.i, q6.i, s1.i, s2.i, s3.i, s4.i, s5.i, zl.i, h1.i, h2.i, zh.i, c7.i, c24.i, zb.i, b7.i,
          s7.i, b24.i].Nodup)
    (hd0 : [uh0.i, nine.i].Nodup) (hd1 : [uh1.i, nine.i].Nodup) (hd2 : [uh2.i, nine.i].Nodup)
    (hd3 : [uh3.i, nine.i].Nodup) (hd4 : [uh4.i, nine.i].Nodup) (hd5 : [uh5.i, nine.i].Nodup)
    (hd6 :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i].Nodup)
    (hd7 :
      [s1.i, p2.i, p3.i, p4.i, p5.i, p6.i, q3.i, q4.i, q5.i, q6.i, s2.i, s3.i, s4.i, s5.i, zl.i,
          h1.i, h2.i].Nodup)
    (hd8 : [zl.i, zh.i, c7.i, c24.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hK :
      ∀ vuh0 vph0 vt1 vuh1 vph1 vt2 vuh2 vph2 vt3 vuh3 vph3 vt4 vuh4 vph4 vt5 vuh5 vt6 : ⟦V⟧,
        ∀ vp1 vp2 vp3 vq3 vp4 vq4 vp5 vq5 vp6 vq6 vs1 vs2 vs3 vs4 vs5 vzl vh1 vh2 vzh : ⟦V⟧,
          ∀ vzb vb7 vs7 vb24 : ⟦V⟧,
            (blk.runBodyFrom
                  E[uh0 := vuh0, ph0 := vph0, t1 := vt1, uh1 := vuh1, ph1 := vph1, t2 := vt2, uh2 :=
                    vuh2, ph2 := vph2, t3 := vt3, uh3 := vuh3, ph3 := vph3, t4 := vt4, uh4 := vuh4,
                    ph4 := vph4, t5 := vt5, uh5 := vuh5, t6 := vt6, p1 := vp1, p2 := vp2, p3 := vp3,
                    q3 := vq3, p4 := vp4, q4 := vq4, p5 := vp5, q5 := vq5, p6 := vp6, q6 := vq6,
                    s1 := vs1, s2 := vs2, s3 := vs3, s4 := vs4, s5 := vs5, zl := vzl, h1 := vh1,
                    h2 := vh2, zh := vzh, zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24, r :=
                    low6 (fd_r43x6_mul_fast.spec X Y)]
                  (pos + 41) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [mulFastRowsRun] at hbody
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_slidesRun with vq6
  subst hvq6
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_sumsRun with vzh
  subst hvzh
  step_pattern using runBodyFrom_fold152LowRun with vr
  have e : vr = low6 (fd_r43x6_mul_fast.spec X Y) := by
    rw [hvr, fd_r43x6_mul_fast.spec, MLIR.Firedancer.Lane.tail_eq]
  rw [hE, hS, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

end Patterns

end

end MLIR.Firedancer.Lane

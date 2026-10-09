module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Memory
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.Avx512.Common.Wwl
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! `FD_R43X6_QUAD_PACK( *_P, x, y, z, t )`: four field elements transposed into the QUAD layout,
limbs `0 3`, `1 4` and `2 5` of all four in one vector each, and stored.
`FD_R43X6_QUAD_FOLD_UNSIGNED` on such a QUAD in memory. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- The QUAD vector of limbs `k` and `k + 3` of `x y z t`: lanes `x[k] y[k] z[k] t[k]`, then the
same at `k + 3`. -/
def quadLanes (k : Nat) (x y z t : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  #v[x[k]!, y[k]!, z[k]!, t[k]!, x[k + 3]!, y[k + 3]!, z[k + 3]!, t[k + 3]!]

/-- `vpermi2var`'s indices pairing lanes `0 1` and `4 5` of both operands. -/
@[mlir_const]
abbrev quadIdxLo : Vector (BitVec 64) 8 :=
  #v[0, 1, 8, 9, 4, 5, 12, 13]

/-- `vpermi2var`'s indices pairing lanes `2 3` and `6 7` of both operands. -/
@[mlir_const]
abbrev quadIdxHi : Vector (BitVec 64) 8 :=
  #v[2, 3, 10, 11, 6, 7, 12, 13]

/-- `FD_R43X6_QUAD_PACK` as fourteen instructions: `x y z t` (indices in `lo hi`) through
`a b c d e f g h` into `q03 q14 q25`, each stored as soon as it is formed, at the pointer arguments
`p03 p14 p25`. -/
def quadPackRun (x y z t lo hi a b c d e f g h q03 q14 q25 : Dst Γ V)
    (p03 p14 p25 : Fin Γ.args.length) (h03 : Γ.args[p03] = .ptr) (h14 : Γ.args[p14] = .ptr)
    (h25 : Γ.args[p25] = .ptr) : List (Instr Γ) :=
  [.ternop .vpermi2var a (.val x.i x.h) (.val lo.i lo.h) (.val z.i z.h),
    .ternop .vpermi2var b (.val y.i y.h) (.val lo.i lo.h) (.val t.i t.h),
    .ternop .vpermi2var c (.val x.i x.h) (.val hi.i hi.h) (.val z.i z.h),
    .ternop .vpermi2var d (.val y.i y.h) (.val hi.i hi.h) (.val t.i t.h),
    .binop
      (.shufflevector
        (#v[some 0, some 8, some 2, some 10, some 4, some 12, some 6, some 14] :
          Vector (Option (Fin (2 * 8))) 8))
      e (.val a.i a.h) (.val b.i b.h),
    .binop
      (.shufflevector
        (#v[some 1, some 9, some 3, some 11, some 5, some 13, some 7, some 15] :
          Vector (Option (Fin (2 * 8))) 8))
      f (.val a.i a.h) (.val b.i b.h),
    .binop
      (.shufflevector
        (#v[some 0, some 8, some 2, some 10, none, none, none, none] :
          Vector (Option (Fin (2 * 8))) 8))
      g (.val c.i c.h) (.val d.i d.h),
    .binop
      (.shufflevector
        (#v[some 1, some 9, some 3, some 11, none, none, none, none] :
          Vector (Option (Fin (2 * 8))) 8))
      h (.val c.i c.h) (.val d.i d.h),
    .binop
      (.shufflevector
        (#v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11] :
          Vector (Option (Fin (2 * 8))) 8))
      q03 (.val e.i e.h) (.val h.i h.h),
    .store (.arg p03 h03) (.val q03.i q03.h),
    .binop
      (.shufflevector
        (#v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15] :
          Vector (Option (Fin (2 * 8))) 8))
      q14 (.val f.i f.h) (.val e.i e.h),
    .store (.arg p14 h14) (.val q14.i q14.h),
    .binop
      (.shufflevector
        (#v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15] :
          Vector (Option (Fin (2 * 8))) 8))
      q25 (.val g.i g.h) (.val f.i f.h),
    .store (.arg p25 h25) (.val q25.i q25.h)]

/-- Where the body at `pos` is `quadPackRun`, `x y z t` hold `X Y Z T` and `p03 p14 p25` point at
`P03 P14 P25`, each with room for a vector: running on from `pos` then `g` gives `K` if it does from
`pos + 14` with the three QUAD vectors stored there, whatever the intermediates hold. -/
theorem runBodyFrom_quadPackRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x y z t lo hi a b c d e f g h q03 q14 q25 : Dst Γ V} {p03 p14 p25 : Fin Γ.args.length}
    {h03 : Γ.args[p03] = .ptr} {h14 : Γ.args[p14] = .ptr} {h25 : Γ.args[p25] = .ptr}
    {rest : List (Instr Γ)} {X Y Z T : Vector (BitVec 64) 8} {P03 P14 P25 : Pointer}
    {S : GlobalState} {k : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadPackRun x y z t lo hi a b c d e f g h q03 q14 q25 p03 p14 p25 h03 h14 h25 ++ rest)
    (hR :
      E ⊨ [x := X, y := Y, z := Z, t := T, lo := quadIdxLo, hi := quadIdxHi, .arg p03 h03 := P03,
        .arg p14 h14 := P14, .arg p25 h25 := P25])
    (hf03 : Fits S.mem P03 512) (hf14 : Fits S.mem P14 512) (hf25 : Fits S.mem P25 512)
    (hd :
      [x.i, y.i, z.i, t.i, lo.i, hi.i, a.i, b.i, c.i, d.i, e.i, f.i, g.i, h.i, q03.i, q14.i].Nodup)
    (hK :
      ∀ va vb vc vd ve vf vg vh vq03 vq14 vq25 : ⟦V⟧,
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, e := ve, f := vf, g := vg, h := vh, q03 := vq03,
                q14 := vq14, q25 := vq25]
              (pos + 14)
              { S with
                mem :=
                  ((S.mem.storeAt P03 (BitVec.packLanes (quadLanes 0 X Y Z T))).storeAt P14
                        (BitVec.packLanes (quadLanes 1 X Y Z T))).storeAt
                    P25 (BitVec.packLanes (quadLanes 2 X Y Z T)) } >>=
            k) =
          K) :
    (blk.runBodyFrom E pos S >>= k) = K := by
  -- the shuffles `a … h` only feed the stored ones: left inline
  iterate 8 step_pure
  step_pure with vq03
  step_store
  step_pure with vq14
  step_store
  step_pure with vq25
  step_store
  have e03 : vq03 = quadLanes 0 X Y Z T := by
    rw [hvq03]; rfl
  have e14 : vq14 = quadLanes 1 X Y Z T := by
    rw [hvq14]; rfl
  have e25 : vq25 = quadLanes 2 X Y Z T := by
    rw [hvq25]; rfl
  subst hE hS
  rw [e03, e14, e25]
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s shifts: limbs `0 1 2` by `43`, limb `5` by `40`. -/
@[mlir_const]
abbrev quadShifts : Vector (BitVec 64) 8 :=
  #v[43, 43, 43, 43, 40, 40, 40, 40]

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s masks for limbs `2 5`. -/
@[mlir_const]
abbrev quadFoldMask : Vector (BitVec 64) 8 :=
  #v[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775,
    1099511627775, 1099511627775]

/-- `19` in the upper lanes, for limb `5`'s carry; the lower lanes are dropped. -/
@[mlir_const]
abbrev quad19 : Vector (PoisonOr (BitVec 64)) 8 :=
  #v[.poison, .poison, .poison, .poison, .value 19, .value 19, .value 19, .value 19]

/-- `quadShifts`' lanes, as the steps see them, are below `64`. -/
theorem quadShifts_lt (i : Fin 8) :
    ¬64 ≤ ([43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64][i.1]'(by simp)).toNat := by
  revert i; decide

/-- Limb `5`'s carry times `19` overflows neither way. -/
theorem shr40_mul19 (x : BitVec 64) :
    (x >>> 40).smulOverflow 19#64 = false ∧ (x >>> 40).umulOverflow 19#64 = false := by bv_decide

/-- A carry plus masked low bits overflows neither way. -/
theorem carry_add_low (x y : BitVec 64) :
    ((x >>> 40) * 19#64).saddOverflow (y &&& 8796093022207#64) = false ∧
      ((x >>> 40) * 19#64).uaddOverflow (y &&& 8796093022207#64) = false ∧
      (x >>> 43).saddOverflow (y &&& 8796093022207#64) = false ∧
      (x >>> 43).uaddOverflow (y &&& 8796093022207#64) = false ∧
      (y &&& 8796093022207#64).saddOverflow (x >>> 43) = false ∧
      (y &&& 8796093022207#64).uaddOverflow (x >>> 43) = false := by
  bv_decide

/-- `carry_add_low` for limbs `0 3`'s carries, as the steps see them: lane `i` of the shuffled
carries plus masked low bits. -/
theorem carry_add_low_lanes (i : Fin 8) (a0 a1 a2 a3 a4 a5 a6 a7 y : BitVec 64) :
    (([a4 >>> 40 * 19#64, a5 >>> 40 * 19#64, a6 >>> 40 * 19#64, a7 >>> 40 * 19#64, a0 >>> 43,
                a1 >>> 43, a2 >>> 43, a3 >>> 43][i.1]'(by simp)).saddOverflow
          (y &&& 8796093022207#64) =
        false) ∧
      (([a4 >>> 40 * 19#64, a5 >>> 40 * 19#64, a6 >>> 40 * 19#64, a7 >>> 40 * 19#64, a0 >>> 43,
                a1 >>> 43, a2 >>> 43, a3 >>> 43][i.1]'(by simp)).uaddOverflow
          (y &&& 8796093022207#64) =
        false) := by
  have hi := carry_add_low a4 y
  have hj := carry_add_low a5 y
  have hk := carry_add_low a6 y
  have hl := carry_add_low a7 y
  have h0 := carry_add_low a0 y
  have h1 := carry_add_low a1 y
  have h2 := carry_add_low a2 y
  have h3 := carry_add_low a3 y
  fin_cases i
  · exact ⟨hi.1, hi.2.1⟩
  · exact ⟨hj.1, hj.2.1⟩
  · exact ⟨hk.1, hk.2.1⟩
  · exact ⟨hl.1, hl.2.1⟩
  · exact ⟨h0.2.2.1, h0.2.2.2.1⟩
  · exact ⟨h1.2.2.1, h1.2.2.2.1⟩
  · exact ⟨h2.2.2.1, h2.2.2.2.1⟩
  · exact ⟨h3.2.2.1, h3.2.2.2.1⟩

/-- `carry_add_low` under `quadFoldMask`'s lanes, as the steps see them. -/
theorem low_add_carry (i : Fin 8) (x y : BitVec 64) :
    (y &&&
              ([8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64,
                  1099511627775#64, 1099511627775#64, 1099511627775#64,
                  1099511627775#64][i.1]'(by simp))).saddOverflow
          (x >>> 43) =
        false ∧
      (y &&&
              ([8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64,
                  1099511627775#64, 1099511627775#64, 1099511627775#64,
                  1099511627775#64][i.1]'(by simp))).uaddOverflow
          (x >>> 43) =
        false := by
  fin_cases i <;>
    (simp only [List.getElem_cons_zero, List.getElem_cons_succ]; bv_decide)

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s limbs `0 3`: the carries of limbs `5` (times `19`) and `2`,
plus the low 43 bits. -/
def quadFold03 (x03 x25 : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i =>
    (if h : i.1 < 4 then (x25[i.1 + 4]'(by omega) >>> 40) * 19
      else x25[i.1 - 4]'(by omega) >>> 43) +
      (x03[i] &&& 8796093022207)

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s limbs `1 4`: the low 43 bits plus the carries of limbs `0 3`. -/
def quadFold14 (x14 x03 : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => (x14[i] &&& 8796093022207) + (x03[i] >>> 43)

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s limbs `2 5`: the low 43 (40) bits plus the carries of limbs
`1 4`. -/
def quadFold25 (x25 x14 : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => (x25[i] &&& quadFoldMask[i]) + (x14[i] >>> 43)

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED` as eighteen instructions, up to its last store: the QUAD at
`p03 p14 p25` loaded, the carries shifted out by `s43 s` (`43`, `quadShifts`), limb `5`'s times
`k` (`quad19`), the low bits masked by `m43 m` (`2^43 - 1`, `quadFoldMask`); limbs `0 3` and `1 4`
stored back, limbs `2 5` left in `r25`. -/
def quadFoldRun
    (s43 s m43 m k ld03 sh03 ld14 sh14 ld25 sh25 c t lo03 r03 ld14' lo14 r14 ld25' lo25 r25 :
      Dst Γ V)
    (p03 p14 p25 : Fin Γ.args.length) (h03 : Γ.args[p03] = .ptr) (h14 : Γ.args[p14] = .ptr)
    (h25 : Γ.args[p25] = .ptr) : List (Instr Γ) :=
  [.load ld03 (.arg p03 h03),
    .binop (.vector (.lshr false)) sh03 (.val ld03.i ld03.h) (.val s43.i s43.h),
    .load ld14 (.arg p14 h14),
    .binop (.vector (.lshr false)) sh14 (.val ld14.i ld14.h) (.val s43.i s43.h),
    .load ld25 (.arg p25 h25),
    .binop (.vector (.lshr false)) sh25 (.val ld25.i ld25.h) (.val s.i s.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) c (.val sh25.i sh25.h) (.val k.i k.h),
    .binop (.vector .and) lo03 (.val ld03.i ld03.h) (.val m43.i m43.h),
    .binop
      (.shufflevector
        (#v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11] :
          Vector (Option (Fin (2 * 8))) 8))
      t (.val c.i c.h) (.val sh25.i sh25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val t.i t.h) (.val lo03.i lo03.h),
    .store (.arg p03 h03) (.val r03.i r03.h), .load ld14' (.arg p14 h14),
    .binop (.vector .and) lo14 (.val ld14'.i ld14'.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val lo14.i lo14.h)
      (.val sh03.i sh03.h),
    .store (.arg p14 h14) (.val r14.i r14.h), .load ld25' (.arg p25 h25),
    .binop (.vector .and) lo25 (.val ld25'.i ld25'.h) (.val m.i m.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val lo25.i lo25.h)
      (.val sh14.i sh14.h)]

/-- Where the body at `pos` is `quadFoldRun`, the constants are in place and `P03 P14 P25`, in
distinct blocks, hold `X03 X14 X25`: running on from `pos` then `g` gives `K` if it does from
`pos + 18` with limbs `0 3` and `1 4` folded in memory and limbs `2 5` folded in `r25`. -/
theorem runBodyFrom_quadFoldRun {blk : BasicBlock Γ tRets bp} {E₀ : ⟪Γ⟫} {pos : Nat}
    {s43 s m43 m k ld03 sh03 ld14 sh14 ld25 sh25 c t lo03 r03 ld14' lo14 r14 ld25' lo25 r25 :
      Dst Γ V}
    {p03 p14 p25 : Fin Γ.args.length} {h03 : Γ.args[p03] = .ptr} {h14 : Γ.args[p14] = .ptr}
    {h25 : Γ.args[p25] = .ptr} {rest : List (Instr Γ)} {X03 X14 X25 : Vector (BitVec 64) 8}
    {P03 P14 P25 : Pointer} {S₀ : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadFoldRun s43 s m43 m k ld03 sh03 ld14 sh14 ld25 sh25 c t lo03 r03 ld14' lo14 r14 ld25'
            lo25 r25 p03 p14 p25 h03 h14 h25 ++
          rest)
    (hR :
      E₀ ⊨ [s43 := Vector.replicate 8 43, s := quadShifts, m43 := Vector.replicate 8 8796093022207,
        m := quadFoldMask, k := quad19, .arg p03 h03 := P03, .arg p14 h14 := P14,
        .arg p25 h25 := P25])
    (hf03 : Fits S₀.mem P03 512) (hf14 : Fits S₀.mem P14 512) (hf25 : Fits S₀.mem P25 512)
    (hd0314 : P03.id ≠ P14.id) (hd0325 : P03.id ≠ P25.id) (hd1425 : P14.id ≠ P25.id)
    (hx03 : S₀.mem.readAt P03 512 = BitVec.packLanes X03)
    (hx14 : S₀.mem.readAt P14 512 = BitVec.packLanes X14)
    (hx25 : S₀.mem.readAt P25 512 = BitVec.packLanes X25)
    (hd :
      [s43.i, s.i, m43.i, m.i, k.i, ld03.i, sh03.i, ld14.i, sh14.i, ld25.i, sh25.i, c.i, t.i,
          lo03.i, r03.i, ld14'.i, lo14.i, r14.i, ld25'.i, lo25.i].Nodup)
    (hK :
      ∀ vld03 vsh03 vld14 vsh14 vld25 vsh25 vc vlo03 vt vr03 vld14' vlo14 vr14 vld25' vlo25 : ⟦V⟧,
        (blk.runBodyFrom
              E₀[ld03 := vld03, sh03 := vsh03, ld14 := vld14, sh14 := vsh14, ld25 := vld25, sh25 :=
                vsh25, c := vc, lo03 := vlo03, t := vt, r03 := vr03, ld14' := vld14', lo14 := vlo14,
                r14 := vr14, ld25' := vld25', lo25 := vlo25, r25 := Ty.wrap (quadFold25 X25 X14)]
              (pos + 18)
              { S₀ with
                mem :=
                  (S₀.mem.storeAt P03 (BitVec.packLanes (quadFold03 X03 X25))).storeAt P14
                    (BitVec.packLanes (quadFold14 X14 X03)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E₀ pos S₀ >>= g) = K := by
  step_load with vld03
  step_pure with transparent vsh03
  step_load with vld14
  step_pure with transparent vsh14
  step_load with vld25
  step_pure [quadShifts_lt] with transparent vsh25
  step_pure [quadShifts_lt, shr40_mul19] with transparent vc
  step_pure with transparent vlo03
  step_pure [shr40_mul19] with transparent vt
  step_pure [carry_add_low_lanes] with vr03
  replace hvr03 : vr03 = quadFold03 X03 X25 := by
    simp [quadFold03, hvr03]
    apply vec_ext_fin
    intro i
    fin_cases i <;> simp
  step_store
  step_load with vld14'
  step_pure with transparent vlo14
  step_pure [carry_add_low] with vr14
  replace hvr14 : vr14 = quadFold14 X14 X03 := by simp [quadFold14, hvr14]
  step_store
  step_load with vld25'
  step_pure with transparent vlo25
  step_pure [low_add_carry] with vr25
  replace hvr25 : vr25 = quadFold25 X25 X14 := by simp [quadFold25, hvr25]
  subst hE hS
  rw [hvr03, hvr14, hvr25]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

end

end MLIR.Firedancer.Avx512

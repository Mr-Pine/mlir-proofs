module

public import MLIR.Semantics.Func
public import MLIR.Run.Call
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.BiasedCarryPropagateLimbs
import Std.Tactic.BVDecide

/-! `fd_r43x6_mod_nearly_reduced_limbs(x, y)`: the reduced limbs of nearly reduced limbs `x0 … x5`:
`y = x + 19` carried up, bit 255 (`q`) cleared, and `19` taken back off unless `q` was set.
Compiled in two runs around `fd_r43x6_biased_carry_propagate_limbs`'s last two instructions; the
second leaves limbs `0 … 4` unmasked (`fd_r43x6_diagnose` masks them itself). -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- `fd_r43x6_mod_nearly_reduced_limbs(x, y)`. -/
def modNearlyReducedLimbs (x : Limbs) : Limbs :=
  -- `y = x + 19, q = y>>255, y -= q<<255`
  let y := carryLimbs (x.y0 + 19) x.y1 x.y2 x.y3 x.y4
  let y5 := x.y5 + y.c
  let c := y5.sshiftRight 40
  let y5 := y5 &&& m40
  -- `r = y - (19 & ((q-1)>>63))`: `19` unless `q` (`0` or `1` here)
  let r := carryLimbs (y.y0 - if c = 0 then 19 else 0) y.y1 y.y2 y.y3 y.y4
  ⟨r.y0, r.y1, r.y2, r.y3, r.y4, y5 + r.c⟩

/-- `modNearlyReducedLimbs` through `carrySums`: what `modSubRun` leaves in its registers. -/
theorem modNearlyReducedLimbs_eq (x : Limbs) :
    modNearlyReducedLimbs x =
      let y := carryLimbs (x.y0 + 19) x.y1 x.y2 x.y3 x.y4
      let r :=
        carrySums (y.y0 - if (x.y5 + y.c).sshiftRight 40 = 0 then 19 else 0) y.y1 y.y2 y.y3 y.y4
      ⟨r.y0 &&& m43, r.y1 &&& m43, r.y2 &&& m43, r.y3 &&& m43, r.y4 &&& m43,
        (x.y5 + y.c &&& m40) + r.c⟩ := by
  rw [modNearlyReducedLimbs, carryLimbs]

/-- `y = x + 19`'s carries as fifteen instructions: `x0 + 19` (`k19`) into `t0`, then each `tk`'s
carry `ck` (`lshr`, `s43` holds `43`) and low bits `yk` (`m43`), `x(k+1) + ck` into `t(k+1)`. -/
def modAddRun (x0 x1 x2 x3 x4 k19 s43 m43 : Dst Γ (.bv 64))
    (t0 c0 y0 t1 c1 y1 t2 c2 y2 t3 c3 y3 t4 c4 y4 : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop (.add { nsw := true, nuw := true }) t0 (.val x0.i x0.h) (.val k19.i k19.h),
    .binop (.lshr false) c0 (.val t0.i t0.h) (.val s43.i s43.h),
    .binop .and y0 (.val t0.i t0.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) t1 (.val x1.i x1.h) (.val c0.i c0.h),
    .binop (.lshr false) c1 (.val t1.i t1.h) (.val s43.i s43.h),
    .binop .and y1 (.val t1.i t1.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) t2 (.val x2.i x2.h) (.val c1.i c1.h),
    .binop (.lshr false) c2 (.val t2.i t2.h) (.val s43.i s43.h),
    .binop .and y2 (.val t2.i t2.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) t3 (.val x3.i x3.h) (.val c2.i c2.h),
    .binop (.lshr false) c3 (.val t3.i t3.h) (.val s43.i s43.h),
    .binop .and y3 (.val t3.i t3.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) t4 (.val x4.i x4.h) (.val c3.i c3.h),
    .binop (.lshr false) c4 (.val t4.i t4.h) (.val s43.i s43.h),
    .binop .and y4 (.val t4.i t4.h) (.val m43.i m43.h)]

/-- `carryLimbs`'s limbs are below `2^43`. -/
theorem carryLimbs_lt (z0 z1 z2 z3 z4 : BitVec 64) :
    (carryLimbs z0 z1 z2 z3 z4).y0 < 0x80000000000#64 ∧
      (carryLimbs z0 z1 z2 z3 z4).y1 < 0x80000000000#64 ∧
      (carryLimbs z0 z1 z2 z3 z4).y2 < 0x80000000000#64 ∧
      (carryLimbs z0 z1 z2 z3 z4).y3 < 0x80000000000#64 ∧
      (carryLimbs z0 z1 z2 z3 z4).y4 < 0x80000000000#64 := by
  simp only [carryLimbs]
  bv_decide

/-- `y = x + 19`'s carry into limb 5 is `0` or `1`. -/
theorem carryLimbs_add19_c_le (z0 z1 z2 z3 z4 : BitVec 64) :
    (carryLimbs ((carryLimbs z0 z1 z2 z3 z4).y0 + 19) (carryLimbs z0 z1 z2 z3 z4).y1
          (carryLimbs z0 z1 z2 z3 z4).y2 (carryLimbs z0 z1 z2 z3 z4).y3
          (carryLimbs z0 z1 z2 z3 z4).y4).c ≤
      1#64 := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := carryLimbs_lt z0 z1 z2 z3 z4
  generalize carryLimbs z0 z1 z2 z3 z4 = w at *
  simp only [carryLimbs, carrySums]
  bv_decide

/-- Where the body at `pos` is `modAddRun` and `x0 … x4` hold `carryLimbs`'s limbs (so below
`2^43`): running on from `pos` then `g` gives `K` if it does from `pos + 15` with `y = x + 19`'s
limbs and carry in `y0 … y4` and `c4`. -/
theorem runBodyFrom_modAddRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 x2 x3 x4 k19 s43 m43r : Dst Γ (.bv 64)}
    {t0 c0 y0 t1 c1 y1 t2 c2 y2 t3 c3 y3 t4 c4 y4 : Dst Γ (.bv 64)} {rest : List (Instr Γ)}
    {Z0 Z1 Z2 Z3 Z4 : BitVec 64} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        modAddRun x0 x1 x2 x3 x4 k19 s43 m43r t0 c0 y0 t1 c1 y1 t2 c2 y2 t3 c3 y3 t4 c4 y4 ++ rest)
    (hR :
      E ⊨ [x0 := (carryLimbs Z0 Z1 Z2 Z3 Z4).y0, x1 := (carryLimbs Z0 Z1 Z2 Z3 Z4).y1, x2 :=
        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2, x3 := (carryLimbs Z0 Z1 Z2 Z3 Z4).y3, x4 :=
        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4, k19 := 19#64, s43 := 43#64, m43r := m43])
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, k19.i, s43.i, m43r.i, t0.i, c0.i, y0.i, t1.i, c1.i, y1.i, t2.i,
          c2.i, y2.i, t3.i, c3.i, y3.i, t4.i, c4.i].Nodup)
    (hK :
      ∀ vt0 vc0 vt1 vc1 vt2 vc2 vt3 vc3 vt4 : ⟦.bv 64⟧,
        (blk.runBodyFrom
              E[t0 := vt0, c0 := vc0, y0 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0,
                t1 := vt1, c1 := vc1, y1 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1,
                t2 := vt2, c2 := vc2, y2 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2,
                t3 := vt3, c3 := vc3, y3 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3,
                t4 := vt4, c4 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c,
                y4 :=
                (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                    (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := carryLimbs_lt Z0 Z1 Z2 Z3 Z4
  generalize (carryLimbs Z0 Z1 Z2 Z3 Z4) = W at hR hK h0 h1 h2 h3 h4
  have o :
    W.y0.saddOverflow 19#64 = false ∧
      W.y0.uaddOverflow 19#64 = false ∧
      W.y1.saddOverflow ((W.y0 + 19#64) >>> 43) = false ∧
      W.y1.uaddOverflow ((W.y0 + 19#64) >>> 43) = false ∧
      W.y2.saddOverflow ((W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) = false ∧
      W.y2.uaddOverflow ((W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) = false ∧
      W.y3.saddOverflow ((W.y2 + (W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) >>> 43) = false ∧
      W.y3.uaddOverflow ((W.y2 + (W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) >>> 43) = false ∧
      W.y4.saddOverflow ((W.y3 + (W.y2 + (W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) >>> 43) >>> 43) =
        false ∧
      W.y4.uaddOverflow ((W.y3 + (W.y2 + (W.y1 + (W.y0 + 19#64) >>> 43) >>> 43) >>> 43) >>> 43) =
        false := by
    bv_decide (config := { enums := false })
  obtain ⟨o0, o0', o1, o1', o2, o2', o3, o3', o4, o4'⟩ := o
  -- the sums and carries feed only the limbs: left inline
  step_pure [o0, o0']
  step_pure [o0, o0']
  step_pure [o0, o0'] with vy0
  step_pure [o0, o0', o1, o1']
  step_pure
  step_pure with vy1
  step_pure [o2, o2']
  step_pure
  step_pure with vy2
  step_pure [o3, o3']
  step_pure
  step_pure with vy3
  step_pure [o4, o4']
  step_pure with vc4
  step_pure with vy4
  have e : carryLimbs (W.y0 + 19) W.y1 W.y2 W.y3 W.y4 = ⟨vy0, vy1, vy2, vy3, vy4, vc4⟩ := by
    subst_vars
    simp only [carryLimbs, carrySums, Carried.mk.injEq, m43]
    bv_decide (config := { enums := false })
  rw [e] at hK
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _

/-- A carry `>>43` plus a limb below `2^43` does not overflow. -/
theorem sshiftRight43_saddOverflow (a b : BitVec 64) (hb : b < 0x80000000000#64) :
    (a.sshiftRight 43).saddOverflow b = false := by bv_decide

/-- `-19` or `0` plus a limb below `2^43` does not overflow. -/
theorem saddOverflow_ite (a : BitVec 64) (ha : a < 0x80000000000#64) (p : Prop) [Decidable p] :
    (if p then 18446744073709551597#64 else 0#64).saddOverflow a = false := by split <;> bv_decide

/-- `r = y - (19 & ((q-1)>>63))` as fifteen instructions, limbs `0 … 4` left unmasked: limb 5
`x5 + c` into `t5`, masked (`m40`) into `y5`, `t5 < 2^40` (`two40`) into `q`, `-19` (`m19`) or `0`
(`zero`) by it into `f`; `f + y0` into `r0`, then each `rk`'s carry `ck` (`ashr`, `s43`) plus `y(k+1)`
into `r(k+1)`, `r5` limb 5's. -/
def modSubRun (x5 c m40 two40 m19 zero s43 y0 y1 y2 y3 y4 t5 y5 : Dst Γ (.bv 64))
    (q : Dst Γ (.bv 1)) (f r0 c0 r1 c1 r2 c2 r3 c3 r4 c4 r5 : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop (.add { nsw := true, nuw := true }) t5 (.val x5.i x5.h) (.val c.i c.h),
    .binop .and y5 (.val t5.i t5.h) (.val m40.i m40.h),
    .binop (.icmp .ult) q (.val t5.i t5.h) (.val two40.i two40.h),
    .ternop (.select (τ := .bv 64)) f (.val q.i q.h) (.val m19.i m19.h) (.val zero.i zero.h),
    .binop (.add { nsw := true }) r0 (.val f.i f.h) (.val y0.i y0.h),
    .binop (.ashr false) c0 (.val r0.i r0.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) r1 (.val c0.i c0.h) (.val y1.i y1.h),
    .binop (.ashr false) c1 (.val r1.i r1.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) r2 (.val c1.i c1.h) (.val y2.i y2.h),
    .binop (.ashr false) c2 (.val r2.i r2.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) r3 (.val c2.i c2.h) (.val y3.i y3.h),
    .binop (.ashr false) c3 (.val r3.i r3.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) r4 (.val c3.i c3.h) (.val y4.i y4.h),
    .binop (.ashr false) c4 (.val r4.i r4.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) r5 (.val c4.i c4.h) (.val y5.i y5.h)]

/-- Where the body at `pos` is `modSubRun` after `modAddRun` (`y0 … y4`, `c` hold its results), and
`x5` holds `Y5 < 2^41`: running on from `pos` then `g` gives `K` if it does from `pos + 15` with
`modNearlyReducedLimbs`'s limbs `0 … 4` before their masks in `r0 … r4`, and its limb 5 in `r5`
(`modNearlyReducedLimbs_eq`). -/
theorem runBodyFrom_modSubRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x5 c m40r two40 m19 zero s43 y0 y1 y2 y3 y4 t5 y5 : Dst Γ (.bv 64)} {q : Dst Γ (.bv 1)}
    {f r0 c0 r1 c1 r2 c2 r3 c3 r4 c4 r5 : Dst Γ (.bv 64)} {rest : List (Instr Γ)}
    {Z0 Z1 Z2 Z3 Z4 Y5 : BitVec 64} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        modSubRun x5 c m40r two40 m19 zero s43 y0 y1 y2 y3 y4 t5 y5 q f r0 c0 r1 c1 r2 c2 r3 c3 r4
            c4 r5 ++
          rest)
    (hR :
      E ⊨ [x5 := Y5, c :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c,
        y0 :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0,
        y1 :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1,
        y2 :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2,
        y3 :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3,
        y4 :=
        (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
            (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4,
        m40r := m40, two40 := 1099511627776#64, m19 := 18446744073709551597#64, zero := 0#64, s43 :=
        43#64])
    (hY5 : Y5 < 0x20000000000#64)
    (hd :
      [x5.i, c.i, m40r.i, two40.i, m19.i, zero.i, s43.i, y0.i, y1.i, y2.i, y3.i, y4.i, t5.i, y5.i,
          q.i, f.i, r0.i, c0.i, r1.i, c1.i, r2.i, c2.i, r3.i, c3.i, r4.i, c4.i].Nodup)
    (hK :
      ∀ (vt5 vy5 : ⟦.bv 64⟧) (vq : ⟦.bv 1⟧) (vf vc0 vc1 vc2 vc3 vc4 : ⟦.bv 64⟧),
        (blk.runBodyFrom
              E[t5 := vt5, y5 := vy5, q := vq, f := vf, r0 :=
                (carrySums
                    ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                      if
                          (Y5 +
                                  (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                              40 =
                            0 then
                        19
                      else 0)
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).y0,
                c0 := vc0, r1 :=
                (carrySums
                    ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                      if
                          (Y5 +
                                  (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                              40 =
                            0 then
                        19
                      else 0)
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).y1,
                c1 := vc1, r2 :=
                (carrySums
                    ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                      if
                          (Y5 +
                                  (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                              40 =
                            0 then
                        19
                      else 0)
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).y2,
                c2 := vc2, r3 :=
                (carrySums
                    ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                      if
                          (Y5 +
                                  (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                              40 =
                            0 then
                        19
                      else 0)
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).y3,
                c3 := vc3, r4 :=
                (carrySums
                    ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                      if
                          (Y5 +
                                  (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                              40 =
                            0 then
                        19
                      else 0)
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).y4,
                c4 := vc4, r5 :=
                ((Y5 +
                      (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c) &&&
                    m40) +
                  (carrySums
                      ((carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                            (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                            (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y0 -
                        if
                            (Y5 +
                                    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
                                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
                                        (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).c).sshiftRight
                                40 =
                              0 then
                          19
                        else 0)
                      (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y1
                      (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y2
                      (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y3
                      (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19)
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y1 (carryLimbs Z0 Z1 Z2 Z3 Z4).y2
                          (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4).y4).c]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hc := carryLimbs_add19_c_le Z0 Z1 Z2 Z3 Z4
  obtain ⟨h0, h1, h2, h3, h4⟩ :=
    carryLimbs_lt ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
      (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3 (carryLimbs Z0 Z1 Z2 Z3 Z4).y4
  generalize
    (carryLimbs ((carryLimbs Z0 Z1 Z2 Z3 Z4).y0 + 19) (carryLimbs Z0 Z1 Z2 Z3 Z4).y1
      (carryLimbs Z0 Z1 Z2 Z3 Z4).y2 (carryLimbs Z0 Z1 Z2 Z3 Z4).y3
      (carryLimbs Z0 Z1 Z2 Z3 Z4).y4) =
    U at hR hK hc h0 h1 h2 h3 h4
  generalize (carryLimbs Z0 Z1 Z2 Z3 Z4) = W at hK
  have o5 : Y5.saddOverflow U.c = false ∧ Y5.uaddOverflow U.c = false := by
    bv_decide (config := { enums := false })
  step_pure [o5.1, o5.2] with transparent vt5
  step_pure [o5.1, o5.2] with transparent vy5
  step_pure [o5.1, o5.2] with vq
  step_pure with transparent vf
  have h5 : (Y5 + U.c &&& 1099511627775#64) < 0x80000000000#64 := by
    bv_decide (config := { enums := false })
  step_pure [saddOverflow_ite _ h0] with vr0
  step_pure with transparent vc0
  step_pure [sshiftRight43_saddOverflow _ _ h1] with vr1
  step_pure with transparent vc1
  step_pure [sshiftRight43_saddOverflow _ _ h2] with vr2
  step_pure with transparent vc2
  step_pure [sshiftRight43_saddOverflow _ _ h3] with vr3
  step_pure with transparent vc3
  step_pure [sshiftRight43_saddOverflow _ _ h4] with vr4
  step_pure with transparent vc4
  step_pure [sshiftRight43_saddOverflow _ _ h5] with vr5
  have e :
    carrySums (U.y0 - if (Y5 + U.c).sshiftRight 40 = 0 then 19 else 0) U.y1 U.y2 U.y3 U.y4 =
      ⟨vr0, vr1, vr2, vr3, vr4, vc4⟩ := by
    subst_vars
    have hf :
      (U.y0 - if (Y5 + U.c).sshiftRight 40 = 0 then (19 : BitVec 64) else 0) =
        (if BitVec.ofBool ((Y5 + U.c).ult 1099511627776#64) = 1#1 then 18446744073709551597#64
          else 0#64) +
          U.y0 := by
      bv_decide (config := { enums := false })
    rw [hf]
    simp only [carrySums, BitVec.add_comm]
  rw [hE, ←
    hK (.value vt5) (.value vy5) (.value vq) (.value vf) (.value vc0) (.value vc1) (.value vc2)
      (.value vc3) (.value vc4),
    e]
  have e5 : (Y5 + U.c &&& m40) + vc4 = vr5 := by
    subst_vars
    simp only [m40, BitVec.add_comm]
  rw [e5]

end

end MLIR.Firedancer.Avx512

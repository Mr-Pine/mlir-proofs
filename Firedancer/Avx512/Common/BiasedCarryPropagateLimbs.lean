module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.ExtractLimbs
public import Firedancer.Avx512.Common.R43x6
import Std.Tactic.BVDecide

/-! `fd_r43x6_biased_carry_propagate_limbs(x, y, b)`: the limbs `x0 … x5` carried up serially, limb
5's carry `19 ×` into limb 0, with `b` taken from limb 5 first and added back last. Compiled in two
runs: the carries, then (after `fd_r43x6_mod_nearly_reduced_limbs`'s first carries) limb 5's
`+= _c; += _b`. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- Limbs `0 … 4`, and the carry `c` out of limb 4. -/
structure Carried where
  y0 : BitVec 64
  y1 : BitVec 64
  y2 : BitVec 64
  y3 : BitVec 64
  y4 : BitVec 64
  c : BitVec 64

/-- `_y(k+1) += _yk>>43` for `k = 0 … 4`: the limbs before their `&= _m43`, and in `c` the carry
out of limb 4. -/
def carrySums (y0 y1 y2 y3 y4 : BitVec 64) : Carried :=
  let y1 := y1 + y0.sshiftRight 43
  let y2 := y2 + y1.sshiftRight 43
  let y3 := y3 + y2.sshiftRight 43
  let y4 := y4 + y3.sshiftRight 43
  ⟨y0, y1, y2, y3, y4, y4.sshiftRight 43⟩

/-- `_c = _yk>>43; _yk &= _m43; _y(k+1) += _c` for `k = 0 … 4`, the carry out of limb 4 kept in
`c`. -/
def carryLimbs (y0 y1 y2 y3 y4 : BitVec 64) : Carried :=
  let y := carrySums y0 y1 y2 y3 y4
  ⟨y.y0 &&& m43, y.y1 &&& m43, y.y2 &&& m43, y.y3 &&& m43, y.y4 &&& m43, y.c⟩

/-- `fd_r43x6_biased_carry_propagate_limbs(x, y, b)`. -/
def biasedCarryPropagateLimbs (x : Limbs) (b : BitVec 64) : Limbs :=
  let y5 := x.y5 - b
  let c := y5.sshiftRight 40
  let y5 := y5 &&& m40
  let y := carryLimbs (x.y0 + 19 * c) x.y1 x.y2 x.y3 x.y4
  ⟨y.y0, y.y1, y.y2, y.y3, y.y4, y5 + y.c + b⟩

/-- `19 ×` a carry out of limb 5 does not overflow. -/
theorem sshiftRight40_smulOverflow (t : BitVec 64) :
    (t.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

/-- The carries as nineteen instructions: `x5 - b` (`nb` holds `-b`) into `t5`, its carry `c5`
(`s40` holds `40`) and low bits `y5` (`m40` holds `_m40`); `19 c5` (`k19`) into `d` and on to `t0`;
then each `tk`'s carry `ck` (`s43`) and low bits `yk` (`m43`), `ck + x(k+1)` into `t(k+1)`. -/
def biasedCarryRun (x0 x1 x2 x3 x4 x5 nb s40 m40 k19 s43 m43 : Dst Γ (.bv 64))
    (t5 c5 y5 d t0 c0 y0 t1 c1 y1 t2 c2 y2 t3 c3 y3 t4 c4 y4 : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop (.add {}) t5 (.val x5.i x5.h) (.val nb.i nb.h),
    .binop (.ashr false) c5 (.val t5.i t5.h) (.val s40.i s40.h),
    .binop .and y5 (.val t5.i t5.h) (.val m40.i m40.h),
    .binop (.mul { nsw := true }) d (.val c5.i c5.h) (.val k19.i k19.h),
    .binop (.add {}) t0 (.val d.i d.h) (.val x0.i x0.h),
    .binop (.ashr false) c0 (.val t0.i t0.h) (.val s43.i s43.h),
    .binop .and y0 (.val t0.i t0.h) (.val m43.i m43.h),
    .binop (.add {}) t1 (.val c0.i c0.h) (.val x1.i x1.h),
    .binop (.ashr false) c1 (.val t1.i t1.h) (.val s43.i s43.h),
    .binop .and y1 (.val t1.i t1.h) (.val m43.i m43.h),
    .binop (.add {}) t2 (.val c1.i c1.h) (.val x2.i x2.h),
    .binop (.ashr false) c2 (.val t2.i t2.h) (.val s43.i s43.h),
    .binop .and y2 (.val t2.i t2.h) (.val m43.i m43.h),
    .binop (.add {}) t3 (.val c2.i c2.h) (.val x3.i x3.h),
    .binop (.ashr false) c3 (.val t3.i t3.h) (.val s43.i s43.h),
    .binop .and y3 (.val t3.i t3.h) (.val m43.i m43.h),
    .binop (.add {}) t4 (.val c3.i c3.h) (.val x4.i x4.h),
    .binop (.ashr false) c4 (.val t4.i t4.h) (.val s43.i s43.h),
    .binop .and y4 (.val t4.i t4.h) (.val m43.i m43.h)]

/-- Where the body at `pos` is `biasedCarryRun` with `b = B`, `x0 … x5` hold `X0 … X5` and the
others the constants: running on from `pos` then `g` gives `K` if it does from `pos + 19` with `x5
- b`'s low bits in `y5`, and `carryLimbs …`'s limbs and carry in `y0 … y4` and `c4`. -/
theorem runBodyFrom_biasedCarryRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 x2 x3 x4 x5 nb s40 m40r k19 s43 m43r : Dst Γ (.bv 64)}
    {t5 c5 y5 d t0 c0 y0 t1 c1 y1 t2 c2 y2 t3 c3 y3 t4 c4 y4 : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 X5 B : BitVec 64} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        biasedCarryRun x0 x1 x2 x3 x4 x5 nb s40 m40r k19 s43 m43r t5 c5 y5 d t0 c0 y0 t1 c1 y1 t2 c2
            y2 t3 c3 y3 t4 c4 y4 ++
          rest)
    (hR :
      E ⊨ [x0 := X0, x1 := X1, x2 := X2, x3 := X3, x4 := X4, x5 := X5, nb := -B, s40 := 40#64,
        m40r := m40, k19 := 19#64, s43 := 43#64, m43r := m43])
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, nb.i, s40.i, m40r.i, k19.i, s43.i, m43r.i, t5.i, c5.i,
          y5.i, d.i, t0.i, c0.i, y0.i, t1.i, c1.i, y1.i, t2.i, c2.i, y2.i, t3.i, c3.i, y3.i, t4.i,
          c4.i].Nodup)
    (hK :
      ∀ vt5 vc5 vd vt0 vc0 vt1 vc1 vt2 vc2 vt3 vc3 vt4 : ⟦.bv 64⟧,
        (blk.runBodyFrom
              E[t5 := vt5, c5 := vc5, y5 := (X5 - B) &&& m40, d := vd, t0 := vt0, c0 := vc0, y0 :=
                (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).y0, t1 := vt1, c1 :=
                vc1, y1 := (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).y1, t2 :=
                vt2, c2 := vc2, y2 :=
                (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).y2, t3 := vt3, c3 :=
                vc3, y3 := (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).y3, t4 :=
                vt4, c4 := (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).c, y4 :=
                (carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4).y4]
              (pos + 19) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vt5
  step_pure with transparent vc5
  step_pure with vy5
  step_pure [sshiftRight40_smulOverflow] with vd
  step_pure with vt0
  step_pure with vc0
  step_pure with vy0
  step_pure with vt1
  step_pure with vc1
  step_pure with vy1
  step_pure with vt2
  step_pure with vc2
  step_pure with vy2
  step_pure with vt3
  step_pure with vc3
  step_pure with vy3
  step_pure with vt4
  step_pure with vc4
  step_pure with vy4
  have e5 : (X5 - B) &&& m40 = vy5 := by
    subst_vars
    simp only [m40, BitVec.sub_eq_add_neg]
  have e :
    carryLimbs (X0 + 19 * (X5 - B).sshiftRight 40) X1 X2 X3 X4 =
      ⟨vy0, vy1, vy2, vy3, vy4, vc4⟩ := by
    subst_vars
    simp only [carryLimbs, carrySums, m43, BitVec.sub_eq_add_neg, BitVec.ofNat_eq_ofNat,
      BitVec.add_comm, BitVec.mul_comm]
  rw [hE, ←
    hK (.value vt5) (.value vc5) (.value vd) (.value vt0) (.value vc0) (.value vt1) (.value vc1)
      (.value vt2) (.value vc2) (.value vt3) (.value vc3) (.value vt4),
    e, e5]

/-- `_y5 += _c; _y5 += _b` as compiled, `b` first: `y5 + b` (`b` holds `b`) into `t`, plus `c` into
`r`. -/
def biasedCarryTailRun (y5 b c t r : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop (.add { nsw := true, nuw := true }) t (.val y5.i y5.h) (.val b.i b.h),
    .binop (.add { nsw := true }) r (.val t.i t.h) (.val c.i c.h)]

/-- Masked limb 5 plus a bias in `[2^20, 2^21)` plus a carry out of limb 4: no overflow, below
`2^41`. -/
theorem tail_no_overflow (a b z0 z1 z2 z3 z4 : BitVec 64) (hb1 : 0x100000#64 ≤ b)
    (hb2 : b < 0x200000#64) :
    (a &&& 1099511627775#64).saddOverflow b = false ∧
      (a &&& 1099511627775#64).uaddOverflow b = false ∧
      ((a &&& 1099511627775#64) + b).saddOverflow (carryLimbs z0 z1 z2 z3 z4).c = false ∧
      (a &&& m40) + (carryLimbs z0 z1 z2 z3 z4).c + b < 0x20000000000#64 := by
  simp only [carryLimbs, carrySums]
  bv_decide

/-- Where the body at `pos` is `biasedCarryTailRun`, `y5` holds `x5 - b`'s low bits, `b` holds `b`
(in `[2^20, 2^21)`) and `c` the carry out of limb 4: running on from `pos` then `g` gives `K` if it
does from `pos + 2` with `y5 + c + b` in `r`. -/
theorem runBodyFrom_biasedCarryTailRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {y5 b c t r : Dst Γ (.bv 64)} {rest : List (Instr Γ)} {B X5 Z0 Z1 Z2 Z3 Z4 : BitVec 64}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = biasedCarryTailRun y5 b c t r ++ rest)
    (hR : E ⊨ [b := B, y5 := (X5 - B) &&& m40, c := (carryLimbs Z0 Z1 Z2 Z3 Z4).c])
    (hB1 : 0x100000#64 ≤ B) (hB2 : B < 0x200000#64) (hd : [y5.i, b.i, c.i, t.i].Nodup)
    (hK :
      ∀ vt : ⟦.bv 64⟧,
        (blk.runBodyFrom E[t := vt, r := ((X5 - B) &&& m40) + (carryLimbs Z0 Z1 Z2 Z3 Z4).c + B]
              (pos + 2) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨o1, o2, o3, -⟩ := tail_no_overflow (X5 - B) B Z0 Z1 Z2 Z3 Z4 hB1 hB2
  step_pure [o1, o2]
  step_pure [o3] with vr
  rw [hE, hvr, BitVec.add_assoc, BitVec.add_comm B, ← BitVec.add_assoc]
  exact hK _

end

end MLIR.Firedancer.Avx512

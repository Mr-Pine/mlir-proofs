module

public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide

/-! Signed bounds (`Bnd`) for the 21-bit-limb scalar code beyond `Ref`'s: products of two bounded
values, the compiler's narrowed carry masks, and a carry's residual `x - c <<< 21` from the carry's
equation `c = (x + 2^20).sshiftRight 21` (or `x.sshiftRight 21`) in context, with later additions
to `x`. -/

namespace MLIR.Firedancer.Crc.Ref.Sc

open _root_.MLIR.Firedancer.Ref (Bnd)

@[expose] public section

/-- A product of two non-negative bounded values. -/
theorem mul (x y : BitVec 64) (a b c d lo hi : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ lo = a * c ∧ hi = b * d ∧ hi ≤ 9223372036854775807) :
    Bnd (x * y) lo hi := by
  obtain ⟨ha, hc, rfl, rfl, hhi⟩ := h
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  have h1 := Int.mul_le_mul hx.2 hy.2 (by omega) (by omega)
  have h2 := Int.mul_le_mul hx.1 hy.1 hc (by omega)
  have := Int.mul_nonneg ha hc
  have hov : ¬x.smulOverflow y = true := by
    simp only [BitVec.smulOverflow]
    simp
    omega
  rw [Bnd, BitVec.toInt_mul_of_not_smulOverflow hov]
  exact ⟨h2, h1⟩

/-- `mul nsw` of two non-negative bounded values. -/
theorem smulOverflow (x y : BitVec 64) (a b c d : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ b * d ≤ 9223372036854775807) : x.smulOverflow y = false := by
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  have h1 := Int.mul_le_mul hx.2 hy.2 (by omega) (by omega)
  have h2 := Int.mul_le_mul hx.1 hy.1 h.2.1 (by omega)
  have := Int.mul_nonneg h.1 h.2.1
  simp only [BitVec.smulOverflow]
  simp
  omega

/-- `mul nuw` of two non-negative bounded values. -/
theorem umulOverflow (x y : BitVec 64) (a b c d : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ b * d < 18446744073709551616) : x.umulOverflow y = false := by
  have ex := Bnd.toInt_eq_toNat hx h.1
  have ey := Bnd.toInt_eq_toNat hy h.2.1
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  have h1 := Int.mul_le_mul hx.2 hy.2 (by omega) (by omega)
  rw [ex, ey, ← Int.natCast_mul] at h1
  simp only [BitVec.umulOverflow]
  simp
  omega

/-- `c <<< 21` is `c 2^21`, for `|c| < 2^42`. -/
theorem shl21 (c : BitVec 64) (e f lo hi : Int) (hc : Bnd c e f)
    (h : -4398046511104 ≤ e ∧ f < 4398046511104 ∧ lo = e * 2097152 ∧ hi = f * 2097152) :
    Bnd (c <<< 21) lo hi := by
  have := hc.1; have := hc.2
  have e : c <<< 21 = c * 2097152#64 := by bv_decide
  have : ¬c.smulOverflow 2097152#64 := by
    simp [BitVec.smulOverflow]; omega
  have h2 : (2097152#64).toInt = 2097152 := rfl
  rw [Bnd, e, BitVec.toInt_mul_of_not_smulOverflow this, h2]
  omega

/-- A rounded carry's residual. -/
theorem resid (y c : BitVec 64) (hc : c = (y + 1048576#64).sshiftRight 21) :
    Bnd (y - c <<< 21) (-1048576) 1048575 := by
  rw [hc, ← Bnd.and_neg_shift]
  exact Bnd.residual y

/-- A floor carry's residual. -/
theorem resid_f (y c : BitVec 64) (hc : c = y.sshiftRight 21) : Bnd (y - c <<< 21) 0 2097151 := by
  have : y - c <<< 21 = y &&& 2097151#64 := by
    subst hc; bv_decide
  rw [this]
  exact Bnd.and_nonneg _ _ 0 2097151 (by decide)

/-- A residual with `b` added after the carry. -/
theorem resid_add (x a b c : BitVec 64) (lo₁ hi₁ lo₂ hi₂ lo hi : Int) (hx : x = a + b)
    (h₁ : Bnd (a - c <<< 21) lo₁ hi₁) (h₂ : Bnd b lo₂ hi₂)
    (h : lo = lo₁ + lo₂ ∧ hi = hi₁ + hi₂ ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x - c <<< 21) lo hi := by
  have : x - c <<< 21 = (a - c <<< 21) + b := by
    subst hx; bv_decide
  rw [this]
  exact Bnd.add _ _ lo₁ hi₁ lo₂ hi₂ lo hi h₁ h₂ h

/-- `resid_add` with the sum the other way round. -/
theorem resid_add' (x a b c : BitVec 64) (lo₁ hi₁ lo₂ hi₂ lo hi : Int) (hx : x = b + a)
    (h₁ : Bnd (a - c <<< 21) lo₁ hi₁) (h₂ : Bnd b lo₂ hi₂)
    (h : lo = lo₁ + lo₂ ∧ hi = hi₁ + hi₂ ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x - c <<< 21) lo hi :=
  resid_add x a b c lo₁ hi₁ lo₂ hi₂ lo hi (hx.trans (BitVec.add_comm _ _)) h₁ h₂ h

/-- The compiler's narrowed carry masks: below `2^k`, `2^k - 2^21` clears the low 21 bits. -/
theorem and_mask (x m : BitVec 64) (a b : Int) (hx : Bnd x a b)
    (h :
      0 ≤ a ∧
        (m = 17592183947264#64 ∧ b < 17592186044416 ∨
          m = 562949951324160#64 ∧ b < 562949953421312 ∨
          m = 2251799811588096#64 ∧ b < 2251799813685248)) :
    x &&& m = x.sshiftRight 21 <<< 21 := by
  have e := Bnd.toInt_eq_toNat hx h.1
  have := hx.2
  obtain ⟨-, ⟨rfl, hb⟩ | ⟨rfl, hb⟩ | ⟨rfl, hb⟩⟩ := h
  · have : x.ult 17592186044416#64 := by
      simp [BitVec.ult]; omega
    bv_decide
  · have : x.ult 562949953421312#64 := by
      simp [BitVec.ult]; omega
    bv_decide
  · have : x.ult 2251799813685248#64 := by
      simp [BitVec.ult]; omega
    bv_decide

end

/-! ## Automation -/

public meta section

open Lean Meta Elab Tactic
open Firedancer.Ref.Bnd (atoms withSide int lo64 hi64 litVal? flagFalse)

/-- The context's equations `x = e`, by `x`. -/
def eqns : MetaM (Std.HashMap Expr (Expr × Expr)) := do
  let mut m := {}
  for d in ← getLCtx do
    if d.isImplementationDetail then
      continue
    let some (_, l, r) := (← instantiateMVars d.type).consumeMData.eq? | continue
    if l.isFVar then
      m := m.insert l (r, d.toExpr)
  return m

/-- `x * y` as a product of two values, neither a literal. -/
def mulVars? (e : Expr) : MetaM (Option (Expr × Expr)) := do
  let_expr HMul.hMul _ _ _ _ x y := e | return none
  if (← litVal? y).isSome || (← litVal? x).isSome then
    return none
  return some (x, y)

/-- A carry `c`'s operand and rounding from its equation `c = (y + 2^20).sshiftRight 21` or
`c = y.sshiftRight 21`. -/
def carryOf? (eqs : Std.HashMap Expr (Expr × Expr)) (c : Expr) :
    MetaM (Option (Expr × Bool × Expr)) := do
  let some (r, h) := eqs[c]? | return none
  let_expr BitVec.sshiftRight _ s n := r | return none
  unless n.nat? == some 21 do
    return none
  match_expr s with
  | HAdd.hAdd _ _ _ _ y k =>
    if (← litVal? k) == some 1048576 then
      return some (y, true, h)
  | _ =>
    pure ()
  return some (s, false, h)

/-- Bounds of `x - c <<< 21` for `c` a carry of `y`, `x` reaching `y` through additions. -/
partial def resid? (as : Std.HashMap Expr (Int × Int × Expr)) (eqs : Std.HashMap Expr (Expr × Expr))
    (y c hc : Expr) (rounded : Bool) (x : Expr) (depth : Nat) : MetaM (Option (Int × Int × Expr)) :=
  do
  if x == y then
    if rounded then
      return some (-1048576, 1048575, mkAppN (mkConst ``resid) #[y, c, hc])
    return some (0, 2097151, mkAppN (mkConst ``resid_f) #[y, c, hc])
  if depth == 0 then
    return none
  let (r, hx) ←
    match eqs[x]? with
    | some p =>
      pure p
    | none =>
      pure (x, ← mkEqRefl x)
  let_expr HAdd.hAdd _ _ _ _ p q := r | return none
  for (a, b, lem) in [(p, q, ``resid_add), (q, p, ``resid_add')] do
    if let some (l₁, h₁, pa)← resid? as eqs y c hc rounded a (depth - 1) then
      let (l₂, h₂, pb) ← Firedancer.Ref.Bnd.bound as b
      let lo := l₁ + l₂
      let hi := h₁ + h₂
      unless lo64 ≤ lo && hi ≤ hi64 do
        return none
      return some
          (lo, hi,
            ←
              withSide
                  (mkAppN (mkConst lem)
                    #[x, a, b, c, int l₁, int h₁, int l₂, int h₂, int lo, int hi, hx, pa, pb]))
  return none

/-- Bounds of `e` as `Ref.Bnd.bound` gives them, and for products of two values and carry
residuals. -/
def bound (as : Std.HashMap Expr (Int × Int × Expr)) (e : Expr) : MetaM (Int × Int × Expr) := do
  if let some (x, y)← mulVars? e then
    let (a, b, hx) ← Firedancer.Ref.Bnd.bound as x
    let (c, d, hy) ← Firedancer.Ref.Bnd.bound as y
    if 0 ≤ a && 0 ≤ c && b * d ≤ hi64 then
      return (a * c, b * d,
          ←
            withSide
                (mkAppN (mkConst ``mul)
                  #[x, y, int a, int b, int c, int d, int (a * c), int (b * d), hx, hy]))
  if let some (x, s) :=
      (match_expr e with
      | HSub.hSub _ _ _ _ x s => some (x, s)
      | _ => none) then
    if let some (c, n) :=
        (match_expr s with
        | HShiftLeft.hShiftLeft _ _ _ _ c n => some (c, n)
        | _ => none) then
      if n.nat? == some 21 then
        let eqs ← eqns
        let direct ← carryOf? (({} : Std.HashMap Expr (Expr × Expr)).insert c (c, ← mkEqRefl c)) c
        if let some (y, rounded, hc)← (if direct.isSome then pure direct else carryOf? eqs c) then
          if let some r← resid? as eqs y c hc rounded x 6 then
            return r
  Firedancer.Ref.Bnd.bound as e

/-- `Ref.Bnd.bound`, and `c <<< 21` for a bounded `c`. -/
def obound (as : Std.HashMap Expr (Int × Int × Expr)) (e : Expr) : MetaM (Int × Int × Expr) := do
  if let some (c, n) :=
      (match_expr e with
      | HShiftLeft.hShiftLeft _ _ _ _ c n => some (c, n)
      | _ => none) then
    if n.nat? == some 21 then
      let (a, b, hc) ← Firedancer.Ref.Bnd.bound as c
      if -4398046511104 ≤ a && b < 4398046511104 then
        return (a * 2097152, b * 2097152,
            ←
              withSide
                  (mkAppN (mkConst ``shl21)
                    #[c, int a, int b, int (a * 2097152), int (b * 2097152), hc]))
  Firedancer.Ref.Bnd.bound as e

/-- `sub nsw`, by the operands' bounds, a carry shifted back included. -/
simproc_decl nswSubS (BitVec.ssubOverflow _ _) := fun e => do
  let_expr BitVec.ssubOverflow _ x y := e | return .continue
  let as ← atoms
  let (a, b, hx) ← obound as x
  let (c, d, hy) ← obound as y
  unless lo64 ≤ a - d && b - c ≤ hi64 do
    return .continue
  flagFalse ``Firedancer.Ref.Bnd.ssubOverflow #[x, y, int a, int b, int c, int d, hx, hy]

/-- `mul nsw` of two values, by their bounds. -/
simproc_decl nswMulV (BitVec.smulOverflow _ _) := fun e => do
  let_expr BitVec.smulOverflow _ x y := e | return .continue
  if (← litVal? y).isSome then
    return .continue
  let as ← atoms
  let (a, b, hx) ← Firedancer.Ref.Bnd.bound as x
  let (c, d, hy) ← Firedancer.Ref.Bnd.bound as y
  unless 0 ≤ a && 0 ≤ c && b * d ≤ hi64 do
    return .continue
  flagFalse ``smulOverflow #[x, y, int a, int b, int c, int d, hx, hy]

/-- `mul nuw` of two values, by their bounds. -/
simproc_decl nuwMulV (BitVec.umulOverflow _ _) := fun e => do
  let_expr BitVec.umulOverflow _ x y := e | return .continue
  if (← litVal? y).isSome then
    return .continue
  let as ← atoms
  let (a, b, hx) ← Firedancer.Ref.Bnd.bound as x
  let (c, d, hy) ← Firedancer.Ref.Bnd.bound as y
  unless 0 ≤ a && 0 ≤ c && b * d < 18446744073709551616 do
    return .continue
  flagFalse ``umulOverflow #[x, y, int a, int b, int c, int d, hx, hy]

/-- The compiler's narrowed carry masks, as the cleared low bits. -/
simproc_decl andMaskN (_ &&& _) := fun e => do
  let_expr HAnd.hAnd _ _ _ _ x m := e | return .continue
  let some k ← litVal? m | return .continue
  unless k == 17592183947264 || k == 562949951324160 || k == 2251799811588096 do
    return .continue
  let (a, b, hx) ← Firedancer.Ref.Bnd.bound (← atoms) x
  let lim : Int := k + 2097152
  unless 0 ≤ a && b < lim do
    return .continue
  return .done
      {
        expr :=
          ←
            mkAppM ``HShiftLeft.hShiftLeft
                #[← mkAppM ``BitVec.sshiftRight #[x, mkNatLit 21], mkNatLit 21],
        proof? := ← withSide (mkAppN (mkConst ``and_mask) #[x, m, int a, int b, hx]) }

/-- `fold_eqs`: tag the context's equations `x = e` of `BitVec` locals as named step values', so
the steps keep `x` folded. -/
elab "fold_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      if MLIR.Tactic.isNamedEq ty then
        continue
      let some (_, l, _) := ty.consumeMData.eq? | continue
      unless l.isFVar && (← whnfR (← inferType l)).isAppOf ``BitVec do
        continue
      g ← g.replaceLocalDeclDefEq d.fvarId (MLIR.Tactic.tagNamed ty)
    replaceMainGoal [g]

/-- `sbnd x`: `hbx : Bnd x lo hi`, from `x`'s equation `hx : x = e` and `e`'s bounds. -/
elab "sbnd " x:ident : tactic =>
  withMainContext do
    let xe ← getFVarFromUserName x.getId
    let some hx ←
      (← getLCtx).findDeclRevM? fun d => do
          let some (_, l, _) := (← instantiateMVars d.type).consumeMData.eq? | return none
          return if l == xe then some d else none | throwError "sbnd: no equation for {x}"
    let some (_, _, rhs) := (← instantiateMVars hx.type).consumeMData.eq? | throwError "sbnd"
    let (lo, hi, pf) ← bound (← atoms) rhs
    let motive :=
      mkLambda `t .default (mkApp (mkConst ``BitVec) (mkNatLit 64))
        (mkApp3 (mkConst ``Bnd) (.bvar 0) (int lo) (int hi))
    let pf ← mkEqNDRec motive pf (← mkEqSymm hx.toExpr)
    let (_, g) ←
      (←
            (← getMainGoal).assert (x.getId.appendBefore "hb")
                (mkApp3 (mkConst ``Bnd) xe (int lo) (int hi)) pf).intro1P
    replaceMainGoal [g]

end

end MLIR.Firedancer.Crc.Ref.Sc

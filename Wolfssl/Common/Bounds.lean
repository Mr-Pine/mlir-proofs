module

public import MLIR.Run.Tactic
public meta import Lean.Elab.Tactic

/-! Signed bounds of 128-bit limb arithmetic, as wolfSSL's 42-bit scalar code computes it: the
`Bnd128` intervals, the `nsw` flags they discharge, and `bnd`, which bounds a named value from its
equation. -/

namespace MLIR.Wolfssl

/-- `x`, as a signed integer, lies in `[lo, hi]`. -/
@[expose]
public def Bnd128 (x : BitVec 128) (lo hi : Int) : Prop :=
  lo ≤ x.toInt ∧ x.toInt ≤ hi

namespace Bnd128

/-! Interval lemmas. Their arguments are explicit and their last hypothesis is a closed side
condition, so the `bound` prover below applies them with `decide`. -/

public theorem any (x : BitVec 128) :
    Bnd128 x (-170141183460469231731687303715884105728)
      170141183460469231731687303715884105727 := by
  have := BitVec.le_toInt x
  have := @BitVec.toInt_lt 128 x
  simp only [Nat.add_one_sub_one, Int.reduceNeg] at *
  exact ⟨by omega, by omega⟩

public theorem lit (c : BitVec 128) (lo hi : Int) (h : lo = c.toInt ∧ hi = c.toInt) :
    Bnd128 c lo hi :=
  ⟨by omega, by omega⟩

public theorem saddOverflow (x y : BitVec 128) (a b c d : Int) (hx : Bnd128 x a b)
    (hy : Bnd128 y c d)
    (h :
      -170141183460469231731687303715884105728 ≤ a + c ∧
        b + d ≤ 170141183460469231731687303715884105727) :
    x.saddOverflow y = false := by
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  simp only [BitVec.saddOverflow]
  simp
  omega

theorem mul_range {t a b k lo hi : Int} (h1 : a ≤ t) (h2 : t ≤ b)
    (h : lo ≤ a * k ∧ lo ≤ b * k ∧ a * k ≤ hi ∧ b * k ≤ hi) : lo ≤ t * k ∧ t * k ≤ hi := by
  rcases Int.le_total 0 k with hk | hk
  · have := Int.mul_le_mul_of_nonneg_right h1 hk
    have := Int.mul_le_mul_of_nonneg_right h2 hk
    omega
  · have := Int.mul_le_mul_of_nonpos_right h1 hk
    have := Int.mul_le_mul_of_nonpos_right h2 hk
    omega

public theorem smulOverflow (x : BitVec 128) (a b : Int) (hx : Bnd128 x a b) (c : BitVec 128)
    (h :
      -170141183460469231731687303715884105728 ≤ a * c.toInt ∧
        -170141183460469231731687303715884105728 ≤ b * c.toInt ∧
        a * c.toInt ≤ 170141183460469231731687303715884105727 ∧
        b * c.toInt ≤ 170141183460469231731687303715884105727) :
    x.smulOverflow c = false := by
  have := mul_range (t := x.toInt) hx.1 hx.2 h
  simp only [BitVec.smulOverflow]
  simp
  omega

public theorem add (x y : BitVec 128) (a b c d lo hi : Int) (hx : Bnd128 x a b)
    (hy : Bnd128 y c d)
    (h :
      lo = a + c ∧
        hi = b + d ∧
        -170141183460469231731687303715884105728 ≤ lo ∧
        hi ≤ 170141183460469231731687303715884105727) :
    Bnd128 (x + y) lo hi := by
  have hov := saddOverflow x y a b c d hx hy (by omega)
  rw [Bnd128, BitVec.toInt_add_of_not_saddOverflow (by simp [hov])]
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  omega

public theorem mul (x : BitVec 128) (a b lo hi : Int) (hx : Bnd128 x a b) (c : BitVec 128)
    (h :
      lo ≤ a * c.toInt ∧
        lo ≤ b * c.toInt ∧
        a * c.toInt ≤ hi ∧
        b * c.toInt ≤ hi ∧
        -170141183460469231731687303715884105728 ≤ lo ∧
        hi ≤ 170141183460469231731687303715884105727) :
    Bnd128 (x * c) lo hi := by
  have hov := smulOverflow x a b hx c (by omega)
  rw [Bnd128, BitVec.toInt_mul_of_not_smulOverflow (by simp [hov])]
  exact mul_range hx.1 hx.2 ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1⟩

public theorem sshiftRight (x : BitVec 128) (a b lo hi : Int) (hx : Bnd128 x a b) (n : Nat)
    (h : lo = a / 2 ^ n ∧ hi = b / 2 ^ n) : Bnd128 (x.sshiftRight n) lo hi := by
  rw [Bnd128, BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  have hp : (0 : Int) < ((2 ^ n : Nat) : Int) := by
    have := Nat.two_pow_pos n; omega
  push_cast at hp ⊢
  exact ⟨h.1 ▸ Int.ediv_le_ediv hp hx.1, h.2 ▸ Int.ediv_le_ediv hp hx.2⟩

public theorem and_nonneg (x c : BitVec 128) (lo hi : Int)
    (h : lo = 0 ∧ hi = c.toInt ∧ 0 ≤ c.toInt) : Bnd128 (x &&& c) lo hi := by
  have hle : (x &&& c).toNat ≤ c.toNat := by
    rw [BitVec.toNat_and]; exact Nat.and_le_right
  have hc : 2 * c.toNat < 2 ^ 128 := by
    rw [BitVec.toInt_eq_toNat_cond] at h; split at h <;> omega
  have hci : c.toInt = c.toNat := BitVec.toInt_eq_toNat_of_lt hc
  rw [Bnd128, BitVec.toInt_eq_toNat_of_lt (by omega)]
  omega

theorem toInt_ushiftRight (x : BitVec 128) (hn : 0 < n) :
    (x >>> n).toInt = ((x.toNat / 2 ^ n : Nat) : Int) := by
  have : x.toNat / 2 ^ n < 2 ^ 127 := by
    have := x.isLt
    have h2n : 2 ^ 1 ≤ 2 ^ n := Nat.pow_le_pow_right (by decide) hn
    have := Nat.div_le_div_left h2n (by decide : 0 < 2 ^ 1) (a := x.toNat)
    omega
  rw [BitVec.toInt_eq_toNat_of_lt
      (by
        rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega),
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

public theorem ushiftRight (x : BitVec 128) (a b lo hi : Int) (hx : Bnd128 x a b) (n : Nat)
    (h : 0 ≤ a ∧ lo = a / 2 ^ n ∧ hi = b / 2 ^ n ∧ 0 < n) : Bnd128 (x >>> n) lo hi := by
  have hl := hx.1; have hh := hx.2
  have h1 : x.toInt = x.toNat := by
    rw [BitVec.toInt_eq_toNat_cond] at *; split at * <;> omega
  have hp : (0 : Int) < ((2 ^ n : Nat) : Int) := by
    have := Nat.two_pow_pos n; omega
  rw [Bnd128, toInt_ushiftRight x h.2.2.2, Int.natCast_ediv]
  rw [h1] at hl hh
  push_cast at hp ⊢
  exact ⟨h.2.1 ▸ Int.ediv_le_ediv hp hl, h.2.2.1 ▸ Int.ediv_le_ediv hp hh⟩

/-- A zero-extended value of at most 64 bits: `[0, 2^v)`. -/
public theorem setWidth (y : BitVec v) (lo hi : Int) (h : lo = 0 ∧ hi = 2 ^ v - 1 ∧ v ≤ 64) :
    Bnd128 (y.setWidth 128) lo hi := by
  obtain ⟨rfl, rfl, hv⟩ := h
  have hy := y.isLt
  have hpow : 2 ^ v ≤ 2 ^ 64 := Nat.pow_le_pow_right (by decide) hv
  have hc : ((2 ^ v : Nat) : Int) = 2 ^ v := by simp
  have hlt : 2 * (y.setWidth 128).toNat < 2 ^ 128 := by
    rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]; omega
  rw [Bnd128, BitVec.toInt_eq_toNat_of_lt hlt, BitVec.toNat_setWidth,
    Nat.mod_eq_of_lt (by omega)]
  omega

/-- Two values below `2^k`: their bitwise or too. -/
public theorem or (x y : BitVec 128) (a b c d : Int) (hx : Bnd128 x a b) (hy : Bnd128 y c d)
    (k : Nat) (lo hi : Int)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ b < 2 ^ k ∧ d < 2 ^ k ∧ lo = 0 ∧ hi = 2 ^ k - 1 ∧ k ≤ 126) :
    Bnd128 (x ||| y) lo hi := by
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  have hpow : 2 ^ k ≤ 2 ^ 126 := Nat.pow_le_pow_right (by decide) h.2.2.2.2.2.2
  have hc : ((2 ^ k : Nat) : Int) = 2 ^ k := by simp
  have hxn : 2 * x.toNat < 2 ^ 128 := by
    rw [BitVec.toInt_eq_toNat_cond] at *; split at * <;> omega
  have hyn : 2 * y.toNat < 2 ^ 128 := by
    rw [BitVec.toInt_eq_toNat_cond] at *; split at * <;> omega
  rw [BitVec.toInt_eq_toNat_of_lt hxn] at *
  rw [BitVec.toInt_eq_toNat_of_lt hyn] at *
  have hor : (x ||| y).toNat < 2 ^ k := by
    rw [BitVec.toNat_or]; exact Nat.or_lt_two_pow (by omega) (by omega)
  rw [Bnd128, BitVec.toInt_eq_toNat_of_lt (by omega)]
  omega

end Bnd128

/-! ## Bounds automation -/

public meta section

open Lean Meta Elab Tactic

namespace Bnd128

/-- A `BitVec 128` literal's value as a signed integer. -/
def litVal? (e : Expr) : MetaM (Option Int) := do
  let some ⟨w, v⟩ ← getBitVecValue? e | return none
  return if w == 128 then some v.toInt else none

/-- The context's bounds: `x ↦ (lo, hi, h)` for each `h : Bnd128 x lo hi`. -/
def atoms : MetaM (Std.HashMap Expr (Int × Int × Expr)) := do
  let mut m := {}
  for d in ← getLCtx do
    if d.isImplementationDetail then
      continue
    let_expr Bnd128 x lo hi := ← instantiateMVars d.type | continue
    let some lo ← getIntValue? lo | continue
    let some hi ← getIntValue? hi | continue
    m := m.insert x (lo, hi, d.toExpr)
  return m

/-- `f h` for `f`'s last hypothesis `h`, a closed side condition, by `decide`. -/
def withSide (f : Expr) : MetaM Expr := do
  let .forallE _ p _ _ ← whnf (← inferType f) | throwError "no side condition"
  return mkApp f (← mkDecideProof p)

def int (i : Int) : Expr :=
  toExpr i

def lo128 : Int :=
  -170141183460469231731687303715884105728

def hi128 : Int :=
  170141183460469231731687303715884105727

/-- Bounds `(lo, hi)` of `e : BitVec 128` as a signed integer, and a proof of `Bnd128 e lo hi`: by
the operation, from the bounds of the operands, down to literals, zero-extended 64-bit values and
the context's `Bnd128` facts. -/
partial def bound (atoms : Std.HashMap Expr (Int × Int × Expr)) (e : Expr) :
    MetaM (Int × Int × Expr) := do
  if let some r := atoms[e]? then
    return r
  let any := return (lo128, hi128, mkApp (mkConst ``Bnd128.any) e)
  if let some v ← litVal? e then
    return (v, v, ← withSide (mkAppN (mkConst ``Bnd128.lit) #[e, int v, int v]))
  match_expr e with
  | BitVec.setWidth v _ y =>
    let some vn := v.nat? | any
    unless vn ≤ 64 do
      return ← any
    let hi : Int := 2 ^ vn - 1
    return (0, hi, ← withSide (mkAppN (mkConst ``Bnd128.setWidth) #[v, y, int 0, int hi]))
  | HOr.hOr _ _ _ _ x y =>
    let (a, b, hx) ← bound atoms x
    let (c, d, hy) ← bound atoms y
    unless 0 ≤ a && 0 ≤ c do
      return ← any
    let k := max (b.toNat.log2 + 1) (d.toNat.log2 + 1)
    unless k ≤ 126 do
      return ← any
    let hi : Int := 2 ^ k - 1
    return (0, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd128.or)
                #[x, y, int a, int b, int c, int d, hx, hy, mkNatLit k, int 0, int hi]))
  | HAdd.hAdd _ _ _ _ x y =>
    let (a, b, hx) ← bound atoms x
    let (c, d, hy) ← bound atoms y
    let lo := a + c
    let hi := b + d
    unless lo128 ≤ lo && hi ≤ hi128 do
      return ← any
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd128.add)
                #[x, y, int a, int b, int c, int d, int lo, int hi, hx, hy]))
  | HMul.hMul _ _ _ _ x c =>
    let some k ← litVal? c | any
    let (a, b, hx) ← bound atoms x
    let lo := min (a * k) (b * k)
    let hi := max (a * k) (b * k)
    unless lo128 ≤ lo && hi ≤ hi128 do
      return ← any
    return (lo, hi,
        ← withSide (mkAppN (mkConst ``Bnd128.mul) #[x, int a, int b, int lo, int hi, hx, c]))
  | HShiftRight.hShiftRight _ _ _ _ x n =>
    let some n := n.nat? | any
    unless 0 < n do
      return ← any
    let (a, b, hx) ← bound atoms x
    unless 0 ≤ a do
      return ← any
    let lo := a / 2 ^ n
    let hi := b / 2 ^ n
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd128.ushiftRight)
                #[x, int a, int b, int lo, int hi, hx, mkNatLit n]))
  | BitVec.sshiftRight _ x n =>
    let some n := n.nat? | any
    let (a, b, hx) ← bound atoms x
    let lo := a / 2 ^ n
    let hi := b / 2 ^ n
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd128.sshiftRight)
                #[x, int a, int b, int lo, int hi, hx, mkNatLit n]))
  | HAnd.hAnd _ _ _ _ x c =>
    let some k ← litVal? c | any
    unless 0 ≤ k do
      return ← any
    return (0, k, ← withSide (mkAppN (mkConst ``Bnd128.and_nonneg) #[x, c, int 0, int k]))
  | _ =>
    any

/-- The flag test rewritten to `false` by `lem` applied to `args`, if its side condition holds. -/
def flagFalse (lem : Name) (args : Array Expr) : SimpM Simp.Step := do
  return .done { expr := mkConst ``Bool.false, proof? := ← withSide (mkAppN (mkConst lem) args) }

end Bnd128

open Bnd128 in
/-- `add nsw` on 128 bits: no signed overflow, by the operands' bounds. -/
simproc_decl nswAdd128 (BitVec.saddOverflow _ _) := fun e => do
  let_expr BitVec.saddOverflow w x y := e | return .continue
  unless w.nat? == some 128 do
    return .continue
  let as ← atoms
  let (a, b, hx) ← bound as x
  let (c, d, hy) ← bound as y
  unless lo128 ≤ a + c && b + d ≤ hi128 do
    return .continue
  flagFalse ``Bnd128.saddOverflow #[x, y, int a, int b, int c, int d, hx, hy]

open Bnd128 in
/-- `mul nsw` by a literal on 128 bits: no signed overflow, by the operand's bounds. -/
simproc_decl nswMul128 (BitVec.smulOverflow _ _) := fun e => do
  let_expr BitVec.smulOverflow w x c := e | return .continue
  unless w.nat? == some 128 do
    return .continue
  let some k ← litVal? c | return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless lo128 ≤ a * k && lo128 ≤ b * k && a * k ≤ hi128 && b * k ≤ hi128 do
    return .continue
  flagFalse ``Bnd128.smulOverflow #[x, int a, int b, hx, c]

/-- `bnd x`: `hbx : Bnd128 x lo hi`, from `x`'s equation `hx : x = e` and `e`'s bounds. -/
elab "bnd " x:ident : tactic =>
  withMainContext do
    let xe ← getFVarFromUserName x.getId
    let some hx ←
      (← getLCtx).findDeclRevM? fun d => do
          let some (_, l, _) := (← instantiateMVars d.type).consumeMData.eq? | return none
          return if l == xe then some d else none | throwError "bnd: no equation for {x}"
    let some (_, _, rhs) := (← instantiateMVars hx.type).consumeMData.eq? | throwError "bnd"
    let (lo, hi, pf) ← Bnd128.bound (← Bnd128.atoms) rhs
    let motive :=
      mkLambda `t .default (mkApp (mkConst ``BitVec) (mkNatLit 128))
        (mkApp3 (mkConst ``Bnd128) (.bvar 0) (Bnd128.int lo) (Bnd128.int hi))
    let pf ← mkEqNDRec motive pf (← mkEqSymm hx.toExpr)
    let (_, g) ←
      (←
            (← getMainGoal).assert (x.getId.appendBefore "hb")
                (mkApp3 (mkConst ``Bnd128) xe (Bnd128.int lo) (Bnd128.int hi)) pf).intro1P
    replaceMainGoal [g]

end

end MLIR.Wolfssl

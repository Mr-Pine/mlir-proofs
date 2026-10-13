
/-! ## Bounds -/

namespace x25519_sc_reduce

/-- A zero-extended 24-bit value: `[0, 2^24)`. -/
public theorem bnd_setWidth24 (y : BitVec 24) : Bnd (y.setWidth 64) 0 16777215 := by
  rw [show y.setWidth 64 = y.setWidth 64 &&& 16777215#64 by bv_decide]
  exact Bnd.and_nonneg _ _ _ _ (by decide)

/-- A zero-extended 32-bit value: `[0, 2^32)`. -/
public theorem bnd_setWidth32 (y : BitVec 32) : Bnd (y.setWidth 64) 0 4294967295 := by
  rw [show y.setWidth 64 = y.setWidth 64 &&& 4294967295#64 by bv_decide]
  exact Bnd.and_nonneg _ _ _ _ (by decide)

/-- `int64_lshift21(c)` for `c` in `[a, b]`: `[2^21 a, 2^21 b]`. -/
public theorem bnd_shl21 (x : BitVec 64) (a b lo hi : Int) (hx : Bnd x a b)
    (h :
      lo ≤ a * 2097152 ∧
        lo ≤ b * 2097152 ∧
        a * 2097152 ≤ hi ∧ b * 2097152 ≤ hi ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x <<< 21) lo hi := by
  rw [show x <<< 21 = x * 2097152#64 by bv_decide]
  exact Bnd.mul x a b lo hi hx 2097152#64 h

/-- The floor carry's residual `a - (a >> 21) << 21`: `[0, 2^21)`. -/
public theorem bnd_resid_floor {a c y : BitVec 64} (hc : c = a.sshiftRight 21)
    (hy : y = c <<< 21) : Bnd (a - y) 0 2097151 := by
  subst hc hy
  rw [← Bnd.and_mask_sub]
  exact Bnd.and_nonneg _ _ _ _ (by decide)

/-- The rounded carry's residual `a - ((a + 2^20) >> 21) << 21`: `[-2^20, 2^20)`. -/
public theorem bnd_resid_round {a s c y : BitVec 64} (hs : s = a + 1048576#64)
    (hc : c = s.sshiftRight 21) (hy : y = c <<< 21) : Bnd (a - y) (-1048576) 1048575 := by
  subst hs hc hy
  rw [← Bnd.and_neg_shift]
  exact Bnd.residual a

/-- `bnd_resid_round` with the carry's shift logical. -/
public theorem bnd_resid_round_u {a s c y : BitVec 64} (hs : s = a + 1048576#64)
    (hc : c = s >>> 21) (hy : y = c <<< 21) : Bnd (a - y) (-1048576) 1048575 := by
  subst hs hc hy
  rw [show (a + 1048576#64) >>> 21 <<< 21 = (a + 1048576#64) &&& 18446744073707454464#64 by
    bv_decide]
  exact Bnd.residual a

/-- `int64_lshift21`'s range from a bound. -/
public theorem lshift21_arg {c : BitVec 64} {lo hi : Int} (hc : Bnd c lo hi)
    (h :
      -9223372036854775808 ≤ lo * (2097152#64).toInt ∧
        -9223372036854775808 ≤ hi * (2097152#64).toInt ∧
        lo * (2097152#64).toInt ≤ 9223372036854775807 ∧
          hi * (2097152#64).toInt ≤ 9223372036854775807) :
    -4398046511104 ≤ c.toInt ∧ c.toInt < 4398046511104 := by
  have := Bnd.smulOverflow c lo hi hc 2097152#64 h
  have e : (2097152#64).toInt = 2097152 := by decide
  simp only [BitVec.smulOverflow, e] at this
  simp at this
  omega

/-- `load_3(s + k)`'s pointer does not wrap. -/
public theorem off3 {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) (k : Nat) (hk : k + 3 ≤ 64) :
    ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 3#64 := by
  have e : (64#64).toNat = 64 := rfl
  simp only [BitVec.uaddOverflow, Pointer.add, e] at h ⊢
  simp at h ⊢
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

end x25519_sc_reduce

/-! ## Bounds automation -/

public meta section

open Lean Meta Elab Tactic

namespace x25519_sc_reduce

/-- The context's equation `h : x = e` (or `h : e = x`) of the local `x`, as `x = e`. -/
def eqOf? (x : Expr) : MetaM (Option (Expr × Expr)) := do
  for d in (← getLCtx).decls.toArray.reverse do
    let some d := d | continue
    if d.isImplementationDetail then continue
    let some (_, l, r) := (← instantiateMVars d.type).consumeMData.eq? | continue
    if l == x then return some (d.toExpr, r)
    if r == x && !l.isFVar then return some (← mkEqSymm d.toExpr, l)
  return none

/-- The amount of a shift by a literal `n`. -/
def shiftBy? (e : Expr) (n : Nat) : Option Expr :=
  match_expr e with
  | HShiftLeft.hShiftLeft _ _ _ _ x k => if k.nat? == some n then some x else none
  | _ => none

/-- Bounds of `e : BitVec 64` and a proof of `Bnd e lo hi`: a zero-extended narrow value, a shift
by `21`, a carry's residual through the context's equations, else `Bnd.bound`. -/
def bound (atoms : Std.HashMap Expr (Int × Int × Expr)) (e : Expr) : MetaM (Int × Int × Expr) := do
  if e.isAppOfArity ``BitVec.setWidth 3 && (e.getArg! 1).nat? == some 64 then
    match (e.getArg! 0).nat? with
    | some 24 => return (0, 16777215, mkApp (mkConst ``bnd_setWidth24) (e.getArg! 2))
    | some 32 => return (0, 4294967295, mkApp (mkConst ``bnd_setWidth32) (e.getArg! 2))
    | _ => pure ()
  if let some c := shiftBy? e 21 then
    let (a, b, hc) ← Bnd.bound atoms c
    let lo := a * 2097152
    let hi := b * 2097152
    if Bnd.lo64 ≤ lo && hi ≤ Bnd.hi64 then
      return (lo, hi, ← Bnd.withSide
        (mkAppN (mkConst ``bnd_shl21) #[c, Bnd.int a, Bnd.int b, Bnd.int lo, Bnd.int hi, hc]))
  match_expr e with
  | HSub.hSub _ _ _ _ a y =>
    if let some (hy, ye) ← eqOf? y then
      if let some c := shiftBy? ye 21 then
        if let some (hc, ce) ← eqOf? c then
          let src? : Option (Expr × Bool) :=
            match_expr ce with
            | BitVec.sshiftRight _ s n => if n.nat? == some 21 then some (s, true) else none
            | HShiftRight.hShiftRight _ _ _ _ s n => if n.nat? == some 21 then some (s, false)
                else none
            | _ => none
          if let some (s, ar) := src? then
            if s == a && ar then
              return (0, 2097151, mkAppN (mkConst ``bnd_resid_floor) #[a, c, y, hc, hy])
            if let some (hs, se) ← eqOf? s then
              let ok ← match_expr se with
                | HAdd.hAdd _ _ _ _ a' k => pure (a' == a && (← Bnd.litVal? k) == some 1048576)
                | _ => pure false
              if ok then
                let lem := if ar then ``bnd_resid_round else ``bnd_resid_round_u
                return (-1048576, 1048575, mkAppN (mkConst lem) #[a, s, c, y, hs, hc, hy])
    Bnd.bound atoms e
  | _ => Bnd.bound atoms e

end x25519_sc_reduce

/-- `bnd2 x`: `hbx : Bnd x lo hi`, from `x`'s equation `hx : x = e`, as `bnd` does, and also through
zero-extensions, `<< 21` and carry residuals. -/
elab "bnd2 " x:ident : tactic =>
  withMainContext do
    let xe ← getFVarFromUserName x.getId
    let some (hx, rhs) ← x25519_sc_reduce.eqOf? xe | throwError "bnd2: no equation for {x}"
    let (lo, hi, pf) ← x25519_sc_reduce.bound (← Bnd.atoms) rhs
    let motive :=
      mkLambda `t .default (mkApp (mkConst ``BitVec) (mkNatLit 64))
        (mkApp3 (mkConst ``Bnd) (.bvar 0) (Bnd.int lo) (Bnd.int hi))
    let pf ← mkEqNDRec motive pf (← mkEqSymm hx)
    let (_, g) ←
      (← (← getMainGoal).assert (x.getId.appendBefore "hb")
            (mkApp3 (mkConst ``Bnd) xe (Bnd.int lo) (Bnd.int hi)) pf).intro1P
    replaceMainGoal [g]

end

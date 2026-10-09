module

public import Firedancer.Math.Avx512.QuadSqr

/-! Tight lane bounds of `fd_r43x6_quad_mul_fast` and `fd_r43x6_quad_sqr_fast`: on folded inputs
the products' lanes stay below `7 · 2^59` (squares of `u45` limbs below `2^61`), as the C's
`u62`/`u61` comments say, so the sums and differences the point formulas take of them do not
overflow. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

namespace R43x6

/-! ## The `madd52` halves -/

theorem madd52lo_ult (a b : BitVec 64) : madd52lo a b < 4503599627370496#64 := by
  have := madd52lo_lt a b
  rw [BitVec.lt_def]
  simpa using this

theorem madd52hi_ult_of {a b : BitVec 64} {m n : ℕ} (ha : a.toNat < 2 ^ m) (hb : b.toNat < 2 ^ n)
    (hm : m ≤ 52) (hn : n ≤ 52) {c : BitVec 64} (hc : 2 ^ (m + n - 52) ≤ c.toNat) :
    madd52hi a b < c := by
  rw [BitVec.lt_def]
  exact lt_of_lt_of_le (madd52hi_lt ha hb hm hn) hc

theorem madd52hi_ult44 {a b : BitVec 64} (ha : a < 17592186044416#64)
    (hb : b < 17592186044416#64) : madd52hi a b < 68719476736#64 :=
  madd52hi_ult_of (m := 44) (n := 44) (BitVec.lt_def.1 ha) (BitVec.lt_def.1 hb) (by omega)
    (by omega) (by decide)

theorem madd52hi_ult45 {a b : BitVec 64} (ha : a < 35184372088832#64)
    (hb : b < 35184372088832#64) : madd52hi a b < 274877906944#64 :=
  madd52hi_ult_of (m := 45) (n := 45) (BitVec.lt_def.1 ha) (BitVec.lt_def.1 hb) (by omega)
    (by omega) (by decide)

theorem madd52hi_ult45_shl {a b : BitVec 64} (ha : a < 35184372088832#64)
    (hb : b < 35184372088832#64) : madd52hi (a <<< 1) b < 549755813888#64 := by
  have h : (a <<< 1).toNat < 2 ^ 46 := by
    rw [shl1_toNat (by have := BitVec.lt_def.1 ha; simp at this; omega)]
    have := BitVec.lt_def.1 ha
    simp at this
    omega
  exact madd52hi_ult_of (m := 46) (n := 45) h (BitVec.lt_def.1 hb) (by omega) (by omega)
    (by decide)

/-- The `madd52lo`/`madd52hi` subterms of `e`. -/
meta partial def madd52Terms (e : Lean.Expr) (acc : Array Lean.Expr) : Array Lean.Expr :=
  let acc :=
    if e.isAppOfArity ``madd52lo 2 || e.isAppOfArity ``madd52hi 2 then acc.push e else acc
  match e with
  | .app f a => madd52Terms a (madd52Terms f acc)
  | .mdata _ b => madd52Terms b acc
  | _ => acc

open Lean Meta Elab Tactic in
/-- `madd52_bounds`: the goal over its `madd52` halves as fresh variables, each bounded:
`madd52lo` below `2^52`, `madd52hi` from its operands' bounds found among the hypotheses. The
other hypotheses are dropped. -/
elab "madd52_bounds" : tactic => withMainContext do
  let tgt ← instantiateMVars (← getMainTarget)
  let mut atoms : Array Expr := #[]
  let mut pfs : Array Expr := #[]
  let mut tys : Array Expr := #[]
  for t in madd52Terms tgt #[] do
    if atoms.contains t then continue
    let pf ← if t.isAppOfArity ``madd52lo 2 then
        pure (mkApp2 (mkConst ``madd52lo_ult) t.appFn!.appArg! t.appArg!)
      else
        let mut r := none
        for lem in [``madd52hi_ult44, ``madd52hi_ult45, ``madd52hi_ult45_shl] do
          let s ← saveState
          try
            let c ← mkConstWithFreshMVarLevels lem
            let (args, _, concl) ← forallMetaTelescope (← inferType c)
            unless ← isDefEq concl.appFn!.appArg! t do throwError "no match"
            for a in args do
              unless ← a.mvarId!.isAssigned do a.mvarId!.assumption
            r := some (← instantiateMVars (mkAppN c args))
            break
          catch _ => s.restore
        let some pf := r | throwError "madd52_bounds: no bound for {t}"
        pure pf
    -- the bound on `t` itself, whatever form the lemma gave its operands
    let ty ← whnfR (← inferType pf)
    let ty := mkAppN ty.getAppFn (ty.getAppArgs.set! 2 t)
    atoms := atoms.push t
    pfs := pfs.push (← mkExpectedTypeHint pf ty)
    tys := tys.push ty
  let g ← getMainGoal
  let n := atoms.size
  let newTy ← withLocalDeclsDND (Array.ofFn fun (i : Fin n) =>
      ((Name.mkSimple s!"m{i.1}"), mkConst ``BitVec [] |>.app (mkNatLit 64))) fun vs => do
    let sub (e : Expr) : Expr := e.replace fun s =>
      match atoms.idxOf? s with
      | some i => some vs[i]!
      | none => none
    let body := tys.foldr (fun ty acc => mkForall `h .default (sub ty) acc) (sub tgt)
    mkForallFVars vs body
  let m ← mkFreshExprMVarAt {} {} newTy
  g.assign (mkAppN m (atoms ++ pfs))
  let (_, g') ← m.mvarId!.introN (2 * n)
  replaceMainGoal [g']

/-! ## The bounds -/

/-- Every lane of `x03 x14 x25` below `b`. -/
public abbrev LanesLt (x03 x14 x25 : Wwl) (b : BitVec 64) : Prop :=
  ∀ i (_ : i < 8), x03[i] < b ∧ x14[i] < b ∧ x25[i] < b

set_option hygiene false in
/-- Each lane fact of `hx`, split. -/
local macro "lane_facts " hx:ident : tactic =>
  `(tactic| (
    obtain ⟨_, _, _⟩ := $hx 0 (by decide)
    obtain ⟨_, _, _⟩ := $hx 1 (by decide)
    obtain ⟨_, _, _⟩ := $hx 2 (by decide)
    obtain ⟨_, _, _⟩ := $hx 3 (by decide)
    obtain ⟨_, _, _⟩ := $hx 4 (by decide)
    obtain ⟨_, _, _⟩ := $hx 5 (by decide)
    obtain ⟨_, _, _⟩ := $hx 6 (by decide)
    obtain ⟨_, _, _⟩ := $hx 7 (by decide)))

-- the lane `simp` set is shared by all lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- A lane of a product's spec as a sum of `madd52` halves, bounded by `omega` once the sums are
shown not to wrap. -/
local macro "lane_bound" : tactic =>
  `(tactic| (
    iterate 3
      try simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_pack_halves_get, wwl_pack_h0_h1_get, wwv_add_if_get, wwl_get0,
        wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get,
        getD_get, Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
        Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, ite_true, ite_false, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
        BitVec.reduceGetLsb, Bool.false_eq_true, ↓reduceIte, madd52lo_zero', madd52hi_zero',
        madd52lo_zero, madd52hi_zero, BitVec.add_zero]
    madd52_bounds
    simp only [BitVec.lt_def, BitVec.toNat_add, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq,
      BitVec.toNat_ofNat, BitVec.reduceToNat, Nat.reducePow, Nat.reduceMod, Nat.zero_add,
      Nat.add_zero] at *
    simp (disch := omega) only [Nat.mod_eq_of_lt]
    omega))

-- 24 lanes, each unfolded and bounded, in one declaration
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_quad_mul_fast` of lanes below `2^44`: lanes below `7 · 2^59`. -/
public theorem fd_r43x6_quad_mul_fast_lt {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : LanesLt x03 x14 x25 17592186044416#64) (hy : LanesLt y03 y14 y25 17592186044416#64) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    LanesLt z.1 z.2.1 z.2.2 4035225266123964416#64 := by
  lane_facts hx
  lane_facts hy
  clear hx hy
  intro z i hi
  unfold z fd_r43x6_quad_mul_fast.spec
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => refine ⟨?_, ?_, ?_⟩ <;> lane_bound

-- 24 lanes, each unfolded and bounded, in one declaration
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_quad_sqr_fast` of lanes below `2^45`: lanes below `2^61`. -/
public theorem fd_r43x6_quad_sqr_fast_lt {x03 x14 x25 : Wwl}
    (hx : LanesLt x03 x14 x25 35184372088832#64) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    LanesLt z.1 z.2.1 z.2.2 2305843009213693952#64 := by
  lane_facts hx
  clear hx
  intro z i hi
  unfold z fd_r43x6_quad_sqr_fast.spec
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => refine ⟨?_, ?_, ?_⟩ <;> lane_bound

end R43x6

end LeanMLIR.RIR.Firedancer.Avx512

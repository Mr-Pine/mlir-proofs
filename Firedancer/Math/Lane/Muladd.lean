module

public import Firedancer.Lane.fd_curve25519_scalar_muladd
public import Firedancer.Math.Scalar
import Std.Tactic.BVDecide
meta import Lean.Elab.Tactic

/-! `fd_curve25519_scalar_muladd.spec` computes `(a b + c) mod ℓ`, by interval arithmetic over its
lets as `Ref`'s `reduce` proof does, with products of two bounded values. -/

namespace MLIR.Firedancer.Lane

open Ref (BE)

namespace Muladd

/-- Bits `21 i … 21 i + w - 1` of `x`, as a limb. -/
public def chunk (x : BitVec 256) (i w : Nat) : BitVec 64 :=
  (x.extractLsb' (21 * i) w).setWidth 64

/-- A limb as an integer: bits `21 i …` of `x`. -/
theorem chunk_toInt (x : BitVec 256) (i w : Nat) (hw : w ≤ 62) :
    (chunk x i w).toInt = (x.toNat / 2 ^ (21 * i) % 2 ^ w : Nat) := by
  have : 2 ^ w ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) hw
  have hlt := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  have h : (chunk x i w).toNat = x.toNat / 2 ^ (21 * i) % 2 ^ w := by
    simp only [chunk, BitVec.toNat_setWidth, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (by omega)
  rw [BitVec.toInt_eq_toNat_of_lt (by omega), h]

/-- A `w`-bit limb lies in `[0, 2^w)`. -/
public theorem ofChunk (x : BitVec 256) (i w : Nat) (hi : Int)
    (h : w ≤ 62 ∧ hi = (2 ^ w - 1 : Nat)) : BE (chunk x i w) (chunk x i w).toInt 0 hi := by
  obtain ⟨hw, rfl⟩ := h
  have := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  refine ⟨rfl, ?_, ?_⟩ <;> rw [chunk_toInt x i w hw] <;> omega

/-- The limbs of `x`, weighted, sum to `x`. -/
theorem chunk_sum (x : BitVec 256) :
    (x.toNat : Int) =
      (chunk x 0 21).toInt + (chunk x 1 21).toInt * 2 ^ 21 + (chunk x 2 21).toInt * 2 ^ 42 +
        (chunk x 3 21).toInt * 2 ^ 63 + (chunk x 4 21).toInt * 2 ^ 84 +
        (chunk x 5 21).toInt * 2 ^ 105 + (chunk x 6 21).toInt * 2 ^ 126 +
        (chunk x 7 21).toInt * 2 ^ 147 + (chunk x 8 21).toInt * 2 ^ 168 +
        (chunk x 9 21).toInt * 2 ^ 189 + (chunk x 10 21).toInt * 2 ^ 210 +
        (chunk x 11 25).toInt * 2 ^ 231 := by
  have := x.isLt
  simp only [chunk_toInt x _ _ (by decide : 21 ≤ 62), chunk_toInt x _ _ (by decide : 25 ≤ 62)]
  omega

/-- A product of two non-negative values without overflow: the integers' product. -/
public theorem mulv (x y : BitVec 64) (zx zy a b c d lo hi : Int) (hx : BE x zx a b)
    (hy : BE y zy c d)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ lo = a * c ∧ hi = b * d ∧ hi ≤ 9223372036854775807) :
    BE (x * y) (zx * zy) lo hi := by
  obtain ⟨rfl, h1, h2⟩ := hx
  obtain ⟨rfl, h3, h4⟩ := hy
  obtain ⟨ha, hc, rfl, rfl, hhi⟩ := h
  have m1 := Int.mul_le_mul h2 h4 (by omega) (by omega)
  have m2 := Int.mul_le_mul h1 h3 hc (by omega)
  have := Int.mul_nonneg ha hc
  have : ¬x.smulOverflow y := by
    simp [BitVec.smulOverflow]; omega
  rw [BE, BitVec.toInt_mul_of_not_smulOverflow this]
  omega

end Muladd

/-! ## Bounds automation -/

meta section

open Lean Meta Elab Tactic

namespace Muladd

/-- An `Int` literal. -/
def intE (i : Int) : MetaM Expr := do
  let n ← mkNumeral (mkConst ``Int) i.natAbs
  if 0 ≤ i then
    return n
  else
    mkAppM ``Neg.neg #[n]

/-- `f h`, for `h` the decided proof of `f`'s last hypothesis, a closed side condition. -/
def withSide (f : Expr) : MetaM Expr := do
  let .forallE _ p _ _ ← whnf (← inferType f) | throwError "mul_lets: no side condition"
  return mkApp f (← mkDecideProof p)

/-- The integer a `BE` proof gives its value. -/
def zOf (h : Expr) : MetaM Expr :=
  return (← instantiateMVars (← inferType h)).getArg! 1

/-- The bounded values, `v ↦ (lo, hi, h : BE v v.toInt lo hi)`, and the carries,
`c ↦ (s, rounded, h : BE c (c's quotient of s) lo hi, lo, hi)`. -/
structure State where
  atoms : Std.HashMap Expr (Int × Int × Expr) := {}
  carries : Std.HashMap Expr (Expr × Bool × Expr × Int × Int) := {}

/-- The signed 64-bit range. -/
def lo64 : Int :=
  -9223372036854775808

/-- The signed 64-bit range. -/
def hi64 : Int :=
  9223372036854775807

/-- Bounds `(lo, hi)` of `e` and a proof of `BE e z lo hi`, by interval arithmetic down to the
bounded values, literals and limbs; a carry's residual is bounded by the carry. -/
partial def bound (st : State) (e : Expr) : MetaM (Int × Int × Expr) := do
  if let some r := st.atoms[e]? then
    return r
  if let some ⟨64, v⟩← getBitVecValue? e then
    let k := v.toInt
    return (k, k, ← withSide (mkAppN (mkConst ``Ref.BE.lit) #[e, ← intE k]))
  if e.isAppOfArity ``chunk 3 then
    let some w := (e.getArg! 2).nat? | throwError "mul_lets: limb width in {e}"
    let hi : Int := 2 ^ w - 1
    return (0, hi, ← withSide (mkAppN (mkConst ``ofChunk) (e.getAppArgs.push (← intE hi))))
  let ok (lo hi : Int) : MetaM Unit :=
    unless lo64 ≤ lo && hi ≤ hi64 do
      throwError "mul_lets: overflow in {e}"
  match_expr e with
  | HAdd.hAdd _ _ _ _ x y =>
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a + c) (b + d)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a + c),
        ← intE (b + d), hx, hy]
    return (a + c, b + d, ← withSide (mkAppN (mkConst ``Ref.BE.add) args))
  | HSub.hSub _ _ _ _ x y =>
    if let some (c, n) :=
        (match_expr y with
        | HShiftLeft.hShiftLeft _ _ _ _ c n => some (c, n)
        | _ => none) then
      if let some (s, rounded, hc, e', f) := st.carries[c]? then
        if s == x && n.nat? == some 21 then
          let args := #[x, c, ← intE e', ← intE f, hc]
          if rounded then
            return (-1048576, 1048575, ← withSide (mkAppN (mkConst ``Ref.BE.resid_r) args))
          return (0, 2097151, mkAppN (mkConst ``Ref.BE.resid_f) args)
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a - d) (b - c)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a - d),
        ← intE (b - c), hx, hy]
    return (a - d, b - c, ← withSide (mkAppN (mkConst ``Ref.BE.sub) args))
  | HMul.hMul _ _ _ _ x c =>
    if let some ⟨64, k⟩ ← getBitVecValue? c then
      let k := k.toInt
      let (a, b, hx) ← bound st x
      unless 0 ≤ k do
        throwError "mul_lets: negative factor in {e}"
      ok (a * k) (b * k)
      let args :=
        #[x, c, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a * k), ← intE (b * k), hx]
      return (a * k, b * k, ← withSide (mkAppN (mkConst ``Ref.BE.mul) args))
    let (a, b, hx) ← bound st x
    let (c', d, hy) ← bound st c
    unless 0 ≤ a && 0 ≤ c' do
      throwError "mul_lets: a factor of {e} may be negative"
    ok (a * c') (b * d)
    let args :=
      #[x, c, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c', ← intE d, ← intE (a * c'),
        ← intE (b * d), hx, hy]
    return (a * c', b * d, ← withSide (mkAppN (mkConst ``mulv) args))
  | BitVec.sshiftRight _ x n =>
    let some m := n.nat? | throwError "mul_lets: no bound for {e}"
    let (a, b, hx) ← bound st x
    let k : Int := 2 ^ m
    let args := #[x, n, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a / k), ← intE (b / k), hx]
    return (a / k, b / k, ← withSide (mkAppN (mkConst ``Ref.BE.sshiftRight) args))
  | _ =>
    throwError "mul_lets: no bound for {e}"

/-- The context's bounded values: `h : BE v v.toInt lo hi`, with literal bounds. -/
def scan : MetaM State := do
  let mut st : State := {}
  for d in ← getLCtx do
    if d.isImplementationDetail then
      continue
    let_expr BE v z lo hi := ← instantiateMVars d.type | continue
    unless z.isAppOfArity ``BitVec.toInt 2 && z.appArg! == v do
      continue
    let some lo ← getIntValue? lo | continue
    let some hi ← getIntValue? hi | continue
    st := { st with atoms := st.atoms.insert v (lo, hi, d.toExpr) }
  return st

/-- Introduce the goal's first `let v := e` as a plain variable, with `b_v : BE v v.toInt lo hi`
and `e_v : v.toInt = z` (`e_v : BE v z lo hi` for a carry, to keep its quotient from `omega`). -/
def step (st : State) (g : MVarId) : MetaM (State × MVarId) :=
  g.withContext do
    let .letE n ty v b _ := (← instantiateMVars (← g.getType)).consumeMData
      | throwError "mul_lets: no `let`"
    let (lo, hi, p) ← bound st v
    let z ← zOf p
    let carry? : Option (Expr × Bool) :=
      match_expr v with
      | BitVec.sshiftRight _ x _ =>
        match_expr x with
        | HAdd.hAdd _ _ _ _ s _ => some (s, true)
        | _ => some (x, false)
      | _ => none
    let loE ← intE lo
    let hiE ← intE hi
    let t ←
      withLocalDeclD n ty fun x => do
          let xi ← mkAppM ``BitVec.toInt #[x]
          let hbT ← mkAppM ``BE #[x, xi, loE, hiE]
          let heT ←
            if carry?.isSome then
              mkAppM ``BE #[x, z, loE, hiE]
            else
              mkEq xi z
          withLocalDeclD (n.appendBefore "b_") hbT fun hb =>
              withLocalDeclD (n.appendBefore "e_") heT fun he =>
                mkForallFVars #[x, hb, he] (b.instantiate1 x)
    let g' ← mkFreshExprSyntheticOpaqueMVar t (← g.getTag)
    let pe ←
      if carry?.isSome then
        pure p
      else
        mkAppM ``Ref.BE.eq #[p]
    g.assign (mkAppN g' #[v, ← mkAppM ``Ref.BE.self #[p], pe])
    let (fvs, g') ← g'.mvarId!.introNP 3
    let x := mkFVar fvs[0]!
    let mut st := { st with atoms := st.atoms.insert x (lo, hi, mkFVar fvs[1]!) }
    if let some (s, r) := carry? then
      st := { st with carries := st.carries.insert x (s, r, mkFVar fvs[2]!, lo, hi) }
    return (st, g')

end Muladd

/-- `mul_lets n`: introduce the goal's first `n` `let`s of signed 64-bit arithmetic, each with its
bounds `b_v` and its value `e_v` as an integer, both checked against overflow. -/
elab "mul_lets " n:num : tactic => do
  let mut g ← getMainGoal
  let mut st ← g.withContext Muladd.scan
  for _ in [0:n.getNat] do
    (st, g) ← Muladd.step st g
  replaceMainGoal [g]

/-- `clear_mul_eqs`: drop the values `e_v` that `mul_lets` introduced. -/
elab "clear_mul_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.userName.eraseMacroScopes.toString.startsWith "e_" then
        g ← g.clear d.fvarId
    replaceMainGoal [g]

end

/-! ## Muladd -/

/-- `muladd` computes `(a b + c) mod ℓ`. -/
public theorem fd_curve25519_scalar_muladd.spec_val (a b c : BitVec 256) :
    (fd_curve25519_scalar_muladd.spec a b c).toNat =
      (a.toNat * b.toNat + c.toNat) % Ed25519.ell := by
  unfold fd_curve25519_scalar_muladd.spec Ed25519.ell
  lift_lets
  intro ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11
    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  -- the limbs of `a`, `b`, `c`
  have ha : a0 = Muladd.chunk a 0 21 ∧ a1 = Muladd.chunk a 1 21 ∧ a2 = Muladd.chunk a 2 21 ∧ a3 =
    Muladd.chunk a 3 21 ∧ a4 = Muladd.chunk a 4 21 ∧ a5 = Muladd.chunk a 5 21 ∧ a6 = Muladd.chunk a
    6 21 ∧ a7 = Muladd.chunk a 7 21 ∧ a8 = Muladd.chunk a 8 21 ∧ a9 = Muladd.chunk a 9 21 ∧ a10 =
    Muladd.chunk a 10 21 ∧ a11 = Muladd.chunk a 11 25 := by
    simp only
      [ia0, ia1, ia2, ia3, mask, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, Muladd.chunk]
    bv_decide
  have hb : b0 = Muladd.chunk b 0 21 ∧ b1 = Muladd.chunk b 1 21 ∧ b2 = Muladd.chunk b 2 21 ∧ b3 =
    Muladd.chunk b 3 21 ∧ b4 = Muladd.chunk b 4 21 ∧ b5 = Muladd.chunk b 5 21 ∧ b6 = Muladd.chunk b
    6 21 ∧ b7 = Muladd.chunk b 7 21 ∧ b8 = Muladd.chunk b 8 21 ∧ b9 = Muladd.chunk b 9 21 ∧ b10 =
    Muladd.chunk b 10 21 ∧ b11 = Muladd.chunk b 11 25 := by
    simp only
      [ib0, ib1, ib2, ib3, mask, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, Muladd.chunk]
    bv_decide
  have hc : c0 = Muladd.chunk c 0 21 ∧ c1 = Muladd.chunk c 1 21 ∧ c2 = Muladd.chunk c 2 21 ∧ c3 =
    Muladd.chunk c 3 21 ∧ c4 = Muladd.chunk c 4 21 ∧ c5 = Muladd.chunk c 5 21 ∧ c6 = Muladd.chunk c
    6 21 ∧ c7 = Muladd.chunk c 7 21 ∧ c8 = Muladd.chunk c 8 21 ∧ c9 = Muladd.chunk c 9 21 ∧ c10 =
    Muladd.chunk c 10 21 ∧ c11 = Muladd.chunk c 11 25 := by
    simp only
      [ic0, ic1, ic2, ic3, mask, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, Muladd.chunk]
    bv_decide
  clear_value ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
    a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := ha
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := hb
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := hc
  have hA := Muladd.chunk_sum a
  have hB := Muladd.chunk_sum b
  have hC := Muladd.chunk_sum c
  -- the 23 sums of products, then `x = a b + c` as their weighted sum
  mul_lets 23
  have hx : ((a.toNat * b.toNat + c.toNat : Nat) : Int) = s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt *
    2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 + s5.toInt * 2 ^ 105 + s6.toInt * 2 ^ 126 +
    s7.toInt * 2 ^ 147 + s8.toInt * 2 ^ 168 + s9.toInt * 2 ^ 189 + s10.toInt * 2 ^ 210 + s11.toInt *
    2 ^ 231 + s12.toInt * 2 ^ 252 + s13.toInt * 2 ^ 273 + s14.toInt * 2 ^ 294 + s15.toInt * 2 ^ 315
    + s16.toInt * 2 ^ 336 + s17.toInt * 2 ^ 357 + s18.toInt * 2 ^ 378 + s19.toInt * 2 ^ 399 +
    s20.toInt * 2 ^ 420 + s21.toInt * 2 ^ 441 + s22.toInt * 2 ^ 462 := by
    rw
      [e_s0, e_s1, e_s2, e_s3, e_s4, e_s5, e_s6, e_s7, e_s8, e_s9, e_s10, e_s11, e_s12, e_s13,
      e_s14, e_s15, e_s16, e_s17, e_s18, e_s19, e_s20, e_s21, e_s22]
    rw [Int.natCast_add, Int.natCast_mul, hA, hB, hC]
    grind
  generalize a.toNat * b.toNat + c.toNat = X at hx ⊢
  clear_mul_eqs
  clear hA hB hC
  -- carry, fold, carry: limbs `s0 … s11` in `[0, 2^21)` and `s12 ∈ [-1, 0]`, worth `x` mod `ℓ`
  mul_lets 253
  obtain ⟨V, hV⟩ : ∃ V, V = s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 +
    s4.toInt * 2 ^ 84 + s5.toInt * 2 ^ 105 + s6.toInt * 2 ^ 126 + s7.toInt * 2 ^ 147 + s8.toInt * 2
    ^ 168 + s9.toInt * 2 ^ 189 + s10.toInt * 2 ^ 210 + s11.toInt * 2 ^ 231 + s12.toInt * 2 ^ 252 :=
    ⟨_, rfl⟩
  have hA : ((X : Int) - V) % (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by omega
  have l0 := b_s0.2; have l1 := b_s1.2; have l2 := b_s2.2; have l3 := b_s3.2
  have l4 := b_s4.2; have l5 := b_s5.2; have l6 := b_s6.2; have l7 := b_s7.2
  have l8 := b_s8.2; have l9 := b_s9.2; have l10 := b_s10.2; have l11 := b_s11.2
  have l12 := b_s12.2
  clear_mul_eqs
  clear hx
  -- fold `s12` and carry: limbs worth `V - ℓ s12`, in `[0, ℓ)`
  mul_lets 39
  have f0 := b_s0.2; have f1 := b_s1.2; have f2 := b_s2.2; have f3 := b_s3.2
  have f4 := b_s4.2; have f5 := b_s5.2; have f6 := b_s6.2; have f7 := b_s7.2
  have f8 := b_s8.2; have f9 := b_s9.2; have f10 := b_s10.2
  obtain ⟨F, hF⟩ : ∃ F, F = s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 +
    s4.toInt * 2 ^ 84 + s5.toInt * 2 ^ 105 + s6.toInt * 2 ^ 126 + s7.toInt * 2 ^ 147 + s8.toInt * 2
    ^ 168 + s9.toInt * 2 ^ 189 + s10.toInt * 2 ^ 210 + s11.toInt * 2 ^ 231 := ⟨_, rfl⟩
  have hF' : 0 ≤ F ∧ F < 2 ^ 252 + 27742317777372353535851937790883648493 ∧ ((X : Int) - F) %
    (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by omega
  have h11 : 0 ≤ s11.toInt ∧ s11.toInt ≤ 4194303 := by omega
  refine
    (Ref.pack_toNat s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
      h11).trans ?_
  omega

end MLIR.Firedancer.Lane

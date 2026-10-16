module

public import Firedancer.Math.Scalar
import all Firedancer.Math.Scalar
public import Firedancer.Ref.fd_curve25519_scalar_muladd
public import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Std.Tactic.BVDecide
meta import Lean.Elab.Tactic

/-! `fd_curve25519_scalar_muladd` computes `(a b + c) mod ℓ` for all 256-bit `a`, `b`, `c` (the C's
contract: no input range), with no signed overflow, and the wrappers built on it. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-! ## Products of bounded values -/

/-- A product of two non-negative bounded values without overflow: the integers' product. -/
public theorem BE.mul2 (x y : BitVec 64) (zx zy a b c d lo hi : Int) (hx : BE x zx a b)
    (hy : BE y zy c d) (h : 0 ≤ a ∧ 0 ≤ c ∧ lo = a * c ∧ hi = b * d ∧ hi ≤ 9223372036854775807) :
    BE (x * y) (zx * zy) lo hi := by
  obtain ⟨rfl, h1, h2⟩ := hx
  obtain ⟨rfl, h3, h4⟩ := hy
  obtain ⟨ha, hc, rfl, rfl, h5⟩ := h
  have m1 : a * c ≤ x.toInt * y.toInt := Int.mul_le_mul h1 h3 hc (Int.le_trans ha h1)
  have m2 : x.toInt * y.toInt ≤ b * d :=
    Int.mul_le_mul h2 h4 (Int.le_trans hc h3) (Int.le_trans ha (Int.le_trans h1 h2))
  have m0 : 0 ≤ a * c := Int.mul_nonneg ha hc
  have : ¬x.smulOverflow y := by
    simp [BitVec.smulOverflow]; omega
  rw [BE, BitVec.toInt_mul_of_not_smulOverflow this]
  omega

/-! ## Bounds automation, with products -/

meta section

open Lean Meta Elab Tactic

namespace BE2

/-- An `Int` literal. -/
def intE (i : Int) : MetaM Expr := do
  let n ← mkNumeral (mkConst ``Int) i.natAbs
  if 0 ≤ i then
    return n
  else
    mkAppM ``Neg.neg #[n]

/-- `f h`, for `h` the decided proof of `f`'s last hypothesis, a closed side condition. -/
def withSide (f : Expr) : MetaM Expr := do
  let .forallE _ p _ _ ← whnf (← inferType f) | throwError "be_lets: no side condition"
  return mkApp f (← mkDecideProof p)

/-- The integer a `BE` proof gives its value. -/
def zOf (h : Expr) : MetaM Expr :=
  return (← instantiateMVars (← inferType h)).getArg! 1

/-- The bounded values and the carries, as in `BE.State`. -/
structure State where
  atoms : Std.HashMap Expr (Int × Int × Expr) := {}
  carries : Std.HashMap Expr (Expr × Bool × Expr × Int × Int) := {}

/-- The signed 64-bit range. -/
def lo64 : Int :=
  -9223372036854775808

/-- The signed 64-bit range. -/
def hi64 : Int :=
  9223372036854775807

/-- `BE.bound` with one more case: a product of two non-negative bounded values. -/
partial def bound (st : State) (e : Expr) : MetaM (Int × Int × Expr) := do
  if let some r := st.atoms[e]? then
    return r
  if let some ⟨64, v⟩← getBitVecValue? e then
    let k := v.toInt
    return (k, k, ← withSide (mkAppN (mkConst ``BE.lit) #[e, ← intE k]))
  if e.isAppOfArity ``chunk 3 then
    let some w := (e.getArg! 2).nat? | throwError "be_lets: limb width in {e}"
    let hi : Int := 2 ^ w - 1
    return (0, hi, ← withSide (mkAppN (mkConst ``BE.ofChunk) (e.getAppArgs.push (← intE hi))))
  let ok (lo hi : Int) : MetaM Unit :=
    unless lo64 ≤ lo && hi ≤ hi64 do
      throwError "be_lets: overflow in {e}"
  match_expr e with
  | HAdd.hAdd _ _ _ _ x y =>
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a + c) (b + d)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a + c),
        ← intE (b + d), hx, hy]
    return (a + c, b + d, ← withSide (mkAppN (mkConst ``BE.add) args))
  | HSub.hSub _ _ _ _ x y =>
    if let some (c, n) :=
        (match_expr y with
        | HShiftLeft.hShiftLeft _ _ _ _ c n => some (c, n)
        | _ => none) then
      if let some (s, rounded, hc, e', f) := st.carries[c]? then
        if s == x && n.nat? == some 21 then
          let args := #[x, c, ← intE e', ← intE f, hc]
          if rounded then
            return (-1048576, 1048575, ← withSide (mkAppN (mkConst ``BE.resid_r) args))
          return (0, 2097151, mkAppN (mkConst ``BE.resid_f) args)
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a - d) (b - c)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a - d),
        ← intE (b - c), hx, hy]
    return (a - d, b - c, ← withSide (mkAppN (mkConst ``BE.sub) args))
  | HMul.hMul _ _ _ _ x c =>
    if let some ⟨64, k⟩← getBitVecValue? c then
      let k := k.toInt
      let (a, b, hx) ← bound st x
      unless 0 ≤ k do
        throwError "be_lets: negative factor in {e}"
      ok (a * k) (b * k)
      let args :=
        #[x, c, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a * k), ← intE (b * k), hx]
      return (a * k, b * k, ← withSide (mkAppN (mkConst ``BE.mul) args))
    let (a, b, hx) ← bound st x
    let (c', d, hy) ← bound st c
    unless 0 ≤ a && 0 ≤ c' do
      throwError "be_lets: signed factor in {e}"
    ok (a * c') (b * d)
    let args :=
      #[x, c, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c', ← intE d, ← intE (a * c'),
        ← intE (b * d), hx, hy]
    return (a * c', b * d, ← withSide (mkAppN (mkConst ``BE.mul2) args))
  | BitVec.sshiftRight _ x n =>
    let some m := n.nat? | throwError "be_lets: no bound for {e}"
    let (a, b, hx) ← bound st x
    let k : Int := 2 ^ m
    let args := #[x, n, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a / k), ← intE (b / k), hx]
    return (a / k, b / k, ← withSide (mkAppN (mkConst ``BE.sshiftRight) args))
  | _ =>
    throwError "be_lets: no bound for {e}"

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

/-- `BE.step` over `bound`. -/
def step (st : State) (g : MVarId) : MetaM (State × MVarId) :=
  g.withContext do
    let .letE n ty v b _ := (← instantiateMVars (← g.getType)).consumeMData
      | throwError "be_lets: no `let`"
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
        mkAppM ``BE.eq #[p]
    g.assign (mkAppN g' #[v, ← mkAppM ``BE.self #[p], pe])
    let (fvs, g') ← g'.mvarId!.introNP 3
    let x := mkFVar fvs[0]!
    let mut st := { st with atoms := st.atoms.insert x (lo, hi, mkFVar fvs[1]!) }
    if let some (s, r) := carry? then
      st := { st with carries := st.carries.insert x (s, r, mkFVar fvs[2]!, lo, hi) }
    return (st, g')

end BE2

/-- `be_lets2 n`: `be_lets n`, also bounding products of two non-negative bounded values. -/
elab "be_lets2 " n:num : tactic => do
  let mut g ← getMainGoal
  let mut st ← g.withContext BE2.scan
  for _ in [0:n.getNat] do
    (st, g) ← BE2.step st g
  replaceMainGoal [g]

/-- `clear_carry_eqs`: drop the carries' quotients `e_carry…` that `be_lets2` introduced. -/
elab "clear_carry_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.userName.eraseMacroScopes.toString.startsWith "e_carry" then
        g ← g.clear d.fvarId
    replaceMainGoal [g]

end

/-! ## `muladd` -/

/-- The C's unpacking of a 256-bit value into eleven 21-bit limbs and a 25-bit one. -/
theorem unpack (x : BitVec 256) :
    (x.extractLsb' 0 64) &&& 2097151#64 = chunk (x.setWidth 512) 0 21 ∧
      (x.extractLsb' 0 64) >>> 21 &&& 2097151#64 = chunk (x.setWidth 512) 1 21 ∧
      (x.extractLsb' 0 64) >>> 42 &&& 2097151#64 = chunk (x.setWidth 512) 2 21 ∧
      ((x.extractLsb' 0 64) >>> 63 ||| (x.extractLsb' 64 64) <<< 1) &&& 2097151#64 =
        chunk (x.setWidth 512) 3 21 ∧
      (x.extractLsb' 64 64) >>> 20 &&& 2097151#64 = chunk (x.setWidth 512) 4 21 ∧
      (x.extractLsb' 64 64) >>> 41 &&& 2097151#64 = chunk (x.setWidth 512) 5 21 ∧
      ((x.extractLsb' 64 64) >>> 62 ||| (x.extractLsb' 128 64) <<< 2) &&& 2097151#64 =
        chunk (x.setWidth 512) 6 21 ∧
      (x.extractLsb' 128 64) >>> 19 &&& 2097151#64 = chunk (x.setWidth 512) 7 21 ∧
      (x.extractLsb' 128 64) >>> 40 &&& 2097151#64 = chunk (x.setWidth 512) 8 21 ∧
      ((x.extractLsb' 128 64) >>> 61 ||| (x.extractLsb' 192 64) <<< 3) &&& 2097151#64 =
        chunk (x.setWidth 512) 9 21 ∧
      (x.extractLsb' 192 64) >>> 18 &&& 2097151#64 = chunk (x.setWidth 512) 10 21 ∧
      (x.extractLsb' 192 64) >>> 39 = chunk (x.setWidth 512) 11 25 := by
  simp only [chunk]
  bv_decide

/-- The limbs of a 256-bit value, weighted, sum to it. -/
theorem chunk_sum256 (x : BitVec 256) :
    (x.toNat : Int) =
      (chunk (x.setWidth 512) 0 21).toInt + (chunk (x.setWidth 512) 1 21).toInt * 2 ^ 21 +
        (chunk (x.setWidth 512) 2 21).toInt * 2 ^ 42 +
        (chunk (x.setWidth 512) 3 21).toInt * 2 ^ 63 +
        (chunk (x.setWidth 512) 4 21).toInt * 2 ^ 84 +
        (chunk (x.setWidth 512) 5 21).toInt * 2 ^ 105 +
        (chunk (x.setWidth 512) 6 21).toInt * 2 ^ 126 +
        (chunk (x.setWidth 512) 7 21).toInt * 2 ^ 147 +
        (chunk (x.setWidth 512) 8 21).toInt * 2 ^ 168 +
        (chunk (x.setWidth 512) 9 21).toInt * 2 ^ 189 +
        (chunk (x.setWidth 512) 10 21).toInt * 2 ^ 210 +
        (chunk (x.setWidth 512) 11 25).toInt * 2 ^ 231 := by
  have := x.isLt
  have e : (x.setWidth 512).toNat = x.toNat := by
    rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  simp only [chunk_toInt _ _ _ (by decide : 21 ≤ 62), chunk_toInt _ _ _ (by decide : 25 ≤ 62), e]
  omega

set_option maxHeartbeats 1000000 in
set_option exponentiation.threshold 600 in
/-- `muladd` computes `(a b + c) mod ℓ` for all 256-bit `a`, `b`, `c`; the proof bounds every `long`
within 64 bits, so the wrapping never happens. -/
public theorem fd_curve25519_scalar_muladd.spec_val (a b c : BitVec 256) :
    (fd_curve25519_scalar_muladd.spec a b c).toNat = (a.toNat * b.toNat + c.toNat) % ell := by
  obtain ⟨N, hNd⟩ : ∃ N : ℕ, N = a.toNat * b.toNat + c.toNat := ⟨_, rfl⟩
  rw [← hNd]
  unfold fd_curve25519_scalar_muladd.spec Ed25519.ell
  lift_lets
  intro ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11
    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  have hs := And.intro (unpack a) (And.intro (unpack b) (unpack c))
  change
    (a0 = _ ∧
        a1 = _ ∧
        a2 = _ ∧ a3 = _ ∧ a4 = _ ∧ a5 = _ ∧ a6 = _ ∧ a7 = _ ∧ a8 = _ ∧ a9 = _ ∧ a10 = _ ∧ a11 = _) ∧
      (b0 = _ ∧
        b1 = _ ∧
        b2 = _ ∧ b3 = _ ∧ b4 = _ ∧ b5 = _ ∧ b6 = _ ∧ b7 = _ ∧ b8 = _ ∧ b9 = _ ∧ b10 = _ ∧ b11 = _) ∧
      (c0 = _ ∧
        c1 = _ ∧
        c2 = _ ∧
        c3 = _ ∧ c4 = _ ∧ c5 = _ ∧ c6 = _ ∧ c7 = _ ∧ c8 = _ ∧ c9 = _ ∧ c10 = _ ∧ c11 = _) at hs
  clear_value ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
    a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  obtain
    ⟨⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩,
      ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩,
      ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩⟩ :=
    hs
  have ha := chunk_sum256 a
  have hb := chunk_sum256 b
  have hc := chunk_sum256 c
  -- the schoolbook product: limbs `s0 … s22` worth `a b + c`
  be_lets2 24
  have hN :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        s18.toInt * 2 ^ 378 +
        s19.toInt * 2 ^ 399 +
        s20.toInt * 2 ^ 420 +
        s21.toInt * 2 ^ 441 +
        s22.toInt * 2 ^ 462 +
        s23.toInt * 2 ^ 483 := by
    have p483 : (2 : Int) ^ 483 = (2 ^ 21) ^ 23 := by rw [← pow_mul]
    have p42 : (2 : Int) ^ 42 = (2 ^ 21) ^ 2 := by rw [← pow_mul]
    have p63 : (2 : Int) ^ 63 = (2 ^ 21) ^ 3 := by rw [← pow_mul]
    have p84 : (2 : Int) ^ 84 = (2 ^ 21) ^ 4 := by rw [← pow_mul]
    have p105 : (2 : Int) ^ 105 = (2 ^ 21) ^ 5 := by rw [← pow_mul]
    have p126 : (2 : Int) ^ 126 = (2 ^ 21) ^ 6 := by rw [← pow_mul]
    have p147 : (2 : Int) ^ 147 = (2 ^ 21) ^ 7 := by rw [← pow_mul]
    have p168 : (2 : Int) ^ 168 = (2 ^ 21) ^ 8 := by rw [← pow_mul]
    have p189 : (2 : Int) ^ 189 = (2 ^ 21) ^ 9 := by rw [← pow_mul]
    have p210 : (2 : Int) ^ 210 = (2 ^ 21) ^ 10 := by rw [← pow_mul]
    have p231 : (2 : Int) ^ 231 = (2 ^ 21) ^ 11 := by rw [← pow_mul]
    have p252 : (2 : Int) ^ 252 = (2 ^ 21) ^ 12 := by rw [← pow_mul]
    have p273 : (2 : Int) ^ 273 = (2 ^ 21) ^ 13 := by rw [← pow_mul]
    have p294 : (2 : Int) ^ 294 = (2 ^ 21) ^ 14 := by rw [← pow_mul]
    have p315 : (2 : Int) ^ 315 = (2 ^ 21) ^ 15 := by rw [← pow_mul]
    have p336 : (2 : Int) ^ 336 = (2 ^ 21) ^ 16 := by rw [← pow_mul]
    have p357 : (2 : Int) ^ 357 = (2 ^ 21) ^ 17 := by rw [← pow_mul]
    have p378 : (2 : Int) ^ 378 = (2 ^ 21) ^ 18 := by rw [← pow_mul]
    have p399 : (2 : Int) ^ 399 = (2 ^ 21) ^ 19 := by rw [← pow_mul]
    have p420 : (2 : Int) ^ 420 = (2 ^ 21) ^ 20 := by rw [← pow_mul]
    have p441 : (2 : Int) ^ 441 = (2 ^ 21) ^ 21 := by rw [← pow_mul]
    have p462 : (2 : Int) ^ 462 = (2 ^ 21) ^ 22 := by rw [← pow_mul]
    rw [hNd, Nat.cast_add, Nat.cast_mul, ha, hb, hc, e_s0, e_s1, e_s2, e_s3, e_s4, e_s5, e_s6, e_s7,
      e_s8, e_s9, e_s10, e_s11, e_s12, e_s13, e_s14, e_s15, e_s16, e_s17, e_s18, e_s19, e_s20,
      e_s21, e_s22, e_s23]
    rw [p42, p63, p84, p105, p126, p147, p168, p189, p210, p231, p252, p273, p294, p315, p336, p357,
      p378, p399, p420, p441, p462, p483]
    generalize (2 : Int) ^ 21 = t
    ring
  -- `lift_lets` shares every later `0#64` with this `s23`
  have z23 := e_s23
  clear_be_eqs
  clear ha hb hc hNd
  have hI0 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        s18.toInt * 2 ^ 378 +
        s19.toInt * 2 ^ 399 +
        s20.toInt * 2 ^ 420 +
        s21.toInt * 2 ^ 441 +
        s22.toInt * 2 ^ 462 +
        s23.toInt * 2 ^ 483 +
        (2 ^ 252 + 27742317777372353535851937790883648493) * 0 := by
    linarith
  clear hN
  -- phase 1: carry 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21
  be_lets2 69
  clear_carry_eqs
  have hI1 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        s18.toInt * 2 ^ 378 +
        s19.toInt * 2 ^ 399 +
        s20.toInt * 2 ^ 420 +
        s21.toInt * 2 ^ 441 +
        s22.toInt * 2 ^ 462 +
        s23.toInt * 2 ^ 483 +
        (2 ^ 252 + 27742317777372353535851937790883648493) * (0) := by
    linarith
  clear_be_eqs
  clear hI0
  -- phase 2: fold 23, 22, 21, 20, 19, 18
  obtain ⟨t23_2, ht23_2⟩ : ∃ t : Int, t = s23.toInt := ⟨_, rfl⟩
  obtain ⟨t22_2, ht22_2⟩ : ∃ t : Int, t = s22.toInt := ⟨_, rfl⟩
  obtain ⟨t21_2, ht21_2⟩ : ∃ t : Int, t = s21.toInt := ⟨_, rfl⟩
  obtain ⟨t20_2, ht20_2⟩ : ∃ t : Int, t = s20.toInt := ⟨_, rfl⟩
  obtain ⟨t19_2, ht19_2⟩ : ∃ t : Int, t = s19.toInt := ⟨_, rfl⟩
  obtain ⟨t18_2, ht18_2⟩ : ∃ t : Int, t = s18.toInt := ⟨_, rfl⟩
  be_lets2 36
  have hI2 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126) := by
    linarith
  clear_be_eqs
  clear hI1
  -- phase 3: carry 6, 8, 10, 12, 14, 16, 7, 9, 11, 13, 15
  be_lets2 33
  clear_carry_eqs
  have hI3 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126) := by
    linarith
  clear_be_eqs
  clear hI2
  -- phase 4: fold 17, 16, 15, 14, 13, 12
  obtain ⟨t17_4, ht17_4⟩ : ∃ t : Int, t = s17.toInt := ⟨_, rfl⟩
  obtain ⟨t16_4, ht16_4⟩ : ∃ t : Int, t = s16.toInt := ⟨_, rfl⟩
  obtain ⟨t15_4, ht15_4⟩ : ∃ t : Int, t = s15.toInt := ⟨_, rfl⟩
  obtain ⟨t14_4, ht14_4⟩ : ∃ t : Int, t = s14.toInt := ⟨_, rfl⟩
  obtain ⟨t13_4, ht13_4⟩ : ∃ t : Int, t = s13.toInt := ⟨_, rfl⟩
  obtain ⟨t12_4, ht12_4⟩ : ∃ t : Int, t = s12.toInt := ⟨_, rfl⟩
  be_lets2 36
  have hI4 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4) := by
    linarith
  clear_be_eqs
  clear hI3
  -- phase 5: carry 0, 2, 4, 6, 8, 10, 1, 3, 5, 7, 9, 11
  be_lets2 36
  clear_carry_eqs
  have hI5 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4) := by
    linarith
  clear_be_eqs
  clear hI4
  -- phase 6: fold 12
  obtain ⟨t12_6, ht12_6⟩ : ∃ t : Int, t = s12.toInt := ⟨_, rfl⟩
  be_lets2 6
  have hI6 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4 +
            t12_6) := by
    linarith
  clear_be_eqs
  clear hI5
  -- phase 7: carry 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
  be_lets2 36
  clear_carry_eqs
  have hI7 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4 +
            t12_6) := by
    linarith
  -- before the last fold: canonical limbs and a small top limb
  have u0 := b_s0.2; have u1 := b_s1.2; have u2 := b_s2.2; have u3 := b_s3.2; have u4 := b_s4.2;
  have u5 := b_s5.2; have u6 := b_s6.2; have u7 := b_s7.2; have u8 := b_s8.2; have u9 := b_s9.2;
  have u10 := b_s10.2; have u11 := b_s11.2; have u12 := b_s12.2
  obtain ⟨U, hU⟩ :
    ∃ U : Int,
      U =
        s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231 :=
    ⟨_, rfl⟩
  clear_be_eqs
  clear hI6
  -- phase 8: fold 12
  obtain ⟨t12_8, ht12_8⟩ : ∃ t : Int, t = s12.toInt := ⟨_, rfl⟩
  be_lets2 6
  have hI8 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4 +
            t12_6 +
            t12_8) := by
    linarith
  have hF8 :
    s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 =
      U - t12_8 * 27742317777372353535851937790883648493 := by
    linarith
  clear_be_eqs
  clear hI7
  -- phase 9: carry 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  be_lets2 33
  clear_carry_eqs
  have hI9 :
    (N : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4 +
            t12_6 +
            t12_8) := by
    linarith
  have hF9 :
    s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 =
      U - t12_8 * 27742317777372353535851937790883648493 := by
    linarith
  clear_be_eqs
  clear hI8
  -- the result: limbs worth `N mod ℓ`
  have g0 := b_s0.2; have g1 := b_s1.2; have g2 := b_s2.2; have g3 := b_s3.2; have g4 := b_s4.2;
  have g5 := b_s5.2; have g6 := b_s6.2; have g7 := b_s7.2; have g8 := b_s8.2; have g9 := b_s9.2;
  have g10 := b_s10.2
  obtain ⟨F, hF⟩ :
    ∃ F : Int,
      F =
        s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231 :=
    ⟨_, rfl⟩
  have hNF :
    (N : Int) =
      F +
        (2 ^ 252 + 27742317777372353535851937790883648493) *
          (0 + t23_2 * 2 ^ 231 + t22_2 * 2 ^ 210 + t21_2 * 2 ^ 189 + t20_2 * 2 ^ 168 +
            t19_2 * 2 ^ 147 +
            t18_2 * 2 ^ 126 +
            t17_4 * 2 ^ 105 +
            t16_4 * 2 ^ 84 +
            t15_4 * 2 ^ 63 +
            t14_4 * 2 ^ 42 +
            t13_4 * 2 ^ 21 +
            t12_4 +
            t12_6 +
            t12_8) := by
    linarith
  have hU0 : 0 ≤ U := by
    linarith [u0.1, u1.1, u2.1, u3.1, u4.1, u5.1, u6.1, u7.1, u8.1, u9.1, u10.1, u11.1]
  have hU1 : U ≤ 2 ^ 252 - 1 := by
    linarith [u0.2, u1.2, u2.2, u3.2, u4.2, u5.2, u6.2, u7.2, u8.2, u9.2, u10.2, u11.2]
  have ht : t12_8 = -1 ∨ t12_8 = 0 := by omega
  have hF0 : 0 ≤ F ∧ F < (2 ^ 252 + 27742317777372353535851937790883648493) := by
    rcases ht with h | h <;> constructor <;> linarith
  have h11 : 0 ≤ s11.toInt ∧ s11.toInt ≤ 4194303 := by
    constructor
    · have : -1 < s11.toInt := by
        linarith [g0.2, g1.2, g2.2, g3.2, g4.2, g5.2, g6.2, g7.2, g8.2, g9.2, g10.2]
      omega
    · have : s11.toInt < 4194304 := by
        linarith [g0.1, g1.1, g2.1, g3.1, g4.1, g5.1, g6.1, g7.1, g8.1, g9.1, g10.1]
      omega
  refine
    (pack_toNat s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 g0 g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 h11).trans
      ?_
  rw [← hF]
  have hm : (N : Int) % (2 ^ 252 + 27742317777372353535851937790883648493) = F := by
    rw [hNF, Int.add_mul_emod_self_left, Int.emod_eq_of_lt hF0.1 hF0.2]
  omega

/-! ## The wrappers -/

/-- A 256-bit scalar's value in `ZMod ℓ`. -/
@[expose]
public def sc (s : BitVec 256) : ZMod ell :=
  (s.toNat : ZMod ell)

/-- `zero` is `0`. -/
public theorem fd_curve25519_scalar_zero.toNat_eq : fd_curve25519_scalar_zero.toNat = 0 := by decide

/-- `one` is `1`. -/
public theorem fd_curve25519_scalar_one.toNat_eq : fd_curve25519_scalar_one.toNat = 1 := by decide

/-- `minus_one` is `ℓ - 1`. -/
public theorem fd_curve25519_scalar_minus_one.toNat_eq :
    fd_curve25519_scalar_minus_one.toNat = ell - 1 := by decide

/-- `muladd`'s result is canonical. -/
public theorem fd_curve25519_scalar_muladd.spec_lt (a b c : BitVec 256) :
    (fd_curve25519_scalar_muladd.spec a b c).toNat < ell := by
  rw [fd_curve25519_scalar_muladd.spec_val]
  exact
    Nat.mod_lt _
      (by
        unfold ell; omega)

/-- `muladd` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_muladd.spec_sc (a b c : BitVec 256) :
    sc (fd_curve25519_scalar_muladd.spec a b c) = sc a * sc b + sc c := by
  simp only [sc, fd_curve25519_scalar_muladd.spec_val, ZMod.natCast_mod, Nat.cast_add, Nat.cast_mul]

/-- `mul` computes `a b mod ℓ`. -/
public theorem fd_curve25519_scalar_mul.spec_val (a b : BitVec 256) :
    (fd_curve25519_scalar_mul.spec a b).toNat = a.toNat * b.toNat % ell := by
  rw [fd_curve25519_scalar_mul.spec, fd_curve25519_scalar_muladd.spec_val,
    fd_curve25519_scalar_zero.toNat_eq, Nat.add_zero]

/-- `add` computes `(a + b) mod ℓ`. -/
public theorem fd_curve25519_scalar_add.spec_val (a b : BitVec 256) :
    (fd_curve25519_scalar_add.spec a b).toNat = (a.toNat + b.toNat) % ell := by
  rw [fd_curve25519_scalar_add.spec, fd_curve25519_scalar_muladd.spec_val,
    fd_curve25519_scalar_one.toNat_eq, Nat.mul_one]

/-- `sub` computes `(a + (ℓ - 1) b) mod ℓ`, which is `(a - b) mod ℓ`. -/
public theorem fd_curve25519_scalar_sub.spec_val (a b : BitVec 256) :
    (fd_curve25519_scalar_sub.spec a b).toNat = (a.toNat + (ell - 1) * b.toNat) % ell := by
  rw [fd_curve25519_scalar_sub.spec, fd_curve25519_scalar_muladd.spec_val,
    fd_curve25519_scalar_minus_one.toNat_eq, Nat.add_comm]

/-- `neg` computes `(ℓ - 1) a mod ℓ`, which is `-a mod ℓ`. -/
public theorem fd_curve25519_scalar_neg.spec_val (a : BitVec 256) :
    (fd_curve25519_scalar_neg.spec a).toNat = (ell - 1) * a.toNat % ell := by
  rw [fd_curve25519_scalar_neg.spec, fd_curve25519_scalar_muladd.spec_val,
    fd_curve25519_scalar_minus_one.toNat_eq, fd_curve25519_scalar_zero.toNat_eq, Nat.add_zero]

/-- `set` copies. -/
public theorem fd_curve25519_scalar_set.spec_eq (a : BitVec 256) :
    fd_curve25519_scalar_set.spec a = a :=
  rfl

/-- `from_u64` is `x`. -/
public theorem fd_curve25519_scalar_from_u64.spec_val (x : BitVec 64) :
    (fd_curve25519_scalar_from_u64.spec x).toNat = x.toNat := by
  simp only [fd_curve25519_scalar_from_u64.spec]
  rw [BitVec.toNat_append]
  simp

/-- `ℓ - 1` is `-1` in `ZMod ℓ`. -/
theorem ell_sub_one_cast : ((ell - 1 : ℕ) : ZMod ell) = -1 := by
  rw [Nat.cast_sub
      (by
        unfold ell; omega),
    ZMod.natCast_self, Nat.cast_one, zero_sub]

/-- `mul` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_mul.spec_sc (a b : BitVec 256) :
    sc (fd_curve25519_scalar_mul.spec a b) = sc a * sc b := by
  simp only [sc, fd_curve25519_scalar_mul.spec_val, ZMod.natCast_mod, Nat.cast_mul]

/-- `add` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_add.spec_sc (a b : BitVec 256) :
    sc (fd_curve25519_scalar_add.spec a b) = sc a + sc b := by
  simp only [sc, fd_curve25519_scalar_add.spec_val, ZMod.natCast_mod, Nat.cast_add]

/-- `sub` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_sub.spec_sc (a b : BitVec 256) :
    sc (fd_curve25519_scalar_sub.spec a b) = sc a - sc b := by
  simp only [sc, fd_curve25519_scalar_sub.spec_val, ZMod.natCast_mod, Nat.cast_add, Nat.cast_mul,
    ell_sub_one_cast]
  ring

/-- `neg` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_neg.spec_sc (a : BitVec 256) :
    sc (fd_curve25519_scalar_neg.spec a) = -sc a := by
  simp only [sc, fd_curve25519_scalar_neg.spec_val, ZMod.natCast_mod, Nat.cast_mul,
    ell_sub_one_cast]
  ring

/-- `from_u64` in `ZMod ℓ`. -/
public theorem fd_curve25519_scalar_from_u64.spec_sc (x : BitVec 64) :
    sc (fd_curve25519_scalar_from_u64.spec x) = x.toNat := by
  rw [sc, fd_curve25519_scalar_from_u64.spec_val]

/-- The wrappers built on `muladd` return canonical scalars. -/
public theorem fd_curve25519_scalar_mul.spec_lt (a b : BitVec 256) :
    (fd_curve25519_scalar_mul.spec a b).toNat < ell :=
  fd_curve25519_scalar_muladd.spec_lt ..

/-- The wrappers built on `muladd` return canonical scalars. -/
public theorem fd_curve25519_scalar_add.spec_lt (a b : BitVec 256) :
    (fd_curve25519_scalar_add.spec a b).toNat < ell :=
  fd_curve25519_scalar_muladd.spec_lt ..

/-- The wrappers built on `muladd` return canonical scalars. -/
public theorem fd_curve25519_scalar_sub.spec_lt (a b : BitVec 256) :
    (fd_curve25519_scalar_sub.spec a b).toNat < ell :=
  fd_curve25519_scalar_muladd.spec_lt ..

/-- The wrappers built on `muladd` return canonical scalars. -/
public theorem fd_curve25519_scalar_neg.spec_lt (a : BitVec 256) :
    (fd_curve25519_scalar_neg.spec a).toNat < ell :=
  fd_curve25519_scalar_muladd.spec_lt ..

end MLIR.Firedancer.Ref

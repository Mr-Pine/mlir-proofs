module

public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Ref.fd_curve25519_scalar_validate
import Std.Tactic.BVDecide
meta import Lean.Elab.Tactic

namespace MLIR.Firedancer.Ref

/-! ## The group order -/

@[expose] public section

/-- `ℓ = 2^252 + 27742317777372353535851937790883648493`, the order of edwards25519's prime-order
subgroup. -/
def Ed25519.ell : Nat :=
  2 ^ 252 + 27742317777372353535851937790883648493

end

/-- `ℓ` fits in 253 bits. -/
public theorem Ed25519.ell_lt : Ed25519.ell < 2 ^ 253 := by
  unfold Ed25519.ell; omega

/-! ## Signed bounds -/

/-- `x` is the integer `z`, and `lo ≤ z ≤ hi`. -/
public def BE (x : BitVec 64) (z lo hi : Int) : Prop :=
  x.toInt = z ∧ lo ≤ z ∧ z ≤ hi

namespace BE

/-- Keep only the bounds. -/
public theorem self (h : BE x z lo hi) : BE x x.toInt lo hi := by
  obtain ⟨rfl, h⟩ := h; exact ⟨rfl, h⟩

/-- The value. -/
public theorem eq (h : BE x z lo hi) : x.toInt = z :=
  h.1

/-- A literal, exactly. -/
public theorem lit (c : BitVec 64) (k : Int) (h : c.toInt = k) : BE c k k k :=
  ⟨h, Int.le_refl _, Int.le_refl _⟩

/-- A sum without overflow: the integers' sum. -/
public theorem add (x y : BitVec 64) (zx zy a b c d lo hi : Int) (hx : BE x zx a b)
    (hy : BE y zy c d)
    (h : lo = a + c ∧ hi = b + d ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    BE (x + y) (zx + zy) lo hi := by
  obtain ⟨rfl, _, _⟩ := hx; obtain ⟨rfl, _, _⟩ := hy
  have : ¬x.saddOverflow y := by
    simp [BitVec.saddOverflow]; omega
  rw [BE, BitVec.toInt_add_of_not_saddOverflow this]
  omega

/-- A difference without overflow: the integers' difference. -/
public theorem sub (x y : BitVec 64) (zx zy a b c d lo hi : Int) (hx : BE x zx a b)
    (hy : BE y zy c d)
    (h : lo = a - d ∧ hi = b - c ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    BE (x - y) (zx - zy) lo hi := by
  obtain ⟨rfl, _, _⟩ := hx; obtain ⟨rfl, _, _⟩ := hy
  have : ¬x.ssubOverflow y := by
    simp [BitVec.ssubOverflow]; omega
  rw [BE, BitVec.toInt_sub_of_not_ssubOverflow this]
  omega

/-- A product by a non-negative literal without overflow: the integers' product. -/
public theorem mul (x c : BitVec 64) (zx a b k lo hi : Int) (hx : BE x zx a b)
    (h :
      c.toInt = k ∧
        0 ≤ k ∧ lo = a * k ∧ hi = b * k ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    BE (x * c) (zx * k) lo hi := by
  obtain ⟨rfl, h1, h2⟩ := hx
  obtain ⟨hc, hk, rfl, rfl, h3, h4⟩ := h
  have m1 := Int.mul_le_mul_of_nonneg_right h1 hk
  have m2 := Int.mul_le_mul_of_nonneg_right h2 hk
  have : ¬x.smulOverflow c := by
    simp [BitVec.smulOverflow, hc]; omega
  rw [BE, BitVec.toInt_mul_of_not_smulOverflow this, hc]
  omega

/-- An arithmetic shift right by `n`: the floor quotient by `2^n`. -/
public theorem sshiftRight (x : BitVec 64) (n : Nat) (zx a b k lo hi : Int) (hx : BE x zx a b)
    (h : k = 2 ^ n ∧ lo = a / k ∧ hi = b / k) : BE (x.sshiftRight n) (zx / k) lo hi := by
  obtain ⟨rfl, h1, h2⟩ := hx
  obtain ⟨rfl, rfl, rfl⟩ := h
  have hp : (0 : Int) < 2 ^ n := Int.pow_pos (by decide)
  rw [BE, BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  exact ⟨rfl, Int.ediv_le_ediv hp h1, Int.ediv_le_ediv hp h2⟩

/-- `c <<< 21` is `c 2^21`, for `|c| < 2^42`. -/
public theorem toInt_shl21 (c : BitVec 64) (h1 : -4398046511104 ≤ c.toInt)
    (h2 : c.toInt < 4398046511104) : (c <<< 21).toInt = c.toInt * 2097152 := by
  have e : c <<< 21 = c * 2097152#64 := by bv_decide
  have : ¬c.smulOverflow 2097152#64 := by
    simp [BitVec.smulOverflow]; omega
  rw [e, BitVec.toInt_mul_of_not_smulOverflow this]
  rfl

/-- The residual of `s`'s rounded carry `c` lies in `[-2^20, 2^20)`. -/
public theorem resid_r (s c : BitVec 64) (e f : Int) (hc : BE c ((s.toInt + 1048576) / 2097152) e f)
    (h : f < 4398046511104) :
    BE (s - c <<< 21) (s.toInt - c.toInt * 2097152) (-1048576) 1048575 := by
  obtain ⟨hc, -, hf⟩ := hc
  have := BitVec.le_toInt s; have := @BitVec.toInt_lt 64 s
  simp only [Nat.add_one_sub_one] at *
  have h := toInt_shl21 c (by omega) (by omega)
  have : ¬s.ssubOverflow (c <<< 21) := by
    simp [BitVec.ssubOverflow, h]; omega
  rw [BE, BitVec.toInt_sub_of_not_ssubOverflow this, h]
  omega

/-- The residual of `s`'s floor carry `c` lies in `[0, 2^21)`. -/
public theorem resid_f (s c : BitVec 64) (e f : Int) (hc : BE c (s.toInt / 2097152) e f) :
    BE (s - c <<< 21) (s.toInt - c.toInt * 2097152) 0 2097151 := by
  have hc := hc.1
  have := BitVec.le_toInt s; have := @BitVec.toInt_lt 64 s
  simp only [Nat.add_one_sub_one] at *
  have h := toInt_shl21 c (by omega) (by omega)
  have : ¬s.ssubOverflow (c <<< 21) := by
    simp [BitVec.ssubOverflow, h]; omega
  rw [BE, BitVec.toInt_sub_of_not_ssubOverflow this, h]
  omega

end BE

/-! ## Limbs -/

/-- Bits `21 i … 21 i + w - 1` of `x`, as a limb. -/
public def chunk (x : BitVec 512) (i w : Nat) : BitVec 64 :=
  (x.extractLsb' (21 * i) w).setWidth 64

/-- A limb as an integer: bits `21 i …` of `x`. -/
public theorem chunk_toInt (x : BitVec 512) (i w : Nat) (hw : w ≤ 62) :
    (chunk x i w).toInt = (x.toNat / 2 ^ (21 * i) % 2 ^ w : Nat) := by
  have : 2 ^ w ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) hw
  have hlt := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  have h : (chunk x i w).toNat = x.toNat / 2 ^ (21 * i) % 2 ^ w := by
    simp only [chunk, BitVec.toNat_setWidth, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (by omega)
  rw [BitVec.toInt_eq_toNat_of_lt (by omega), h]

/-- A `w`-bit limb lies in `[0, 2^w)`. -/
public theorem BE.ofChunk (x : BitVec 512) (i w : Nat) (hi : Int)
    (h : w ≤ 62 ∧ hi = (2 ^ w - 1 : Nat)) : BE (chunk x i w) (chunk x i w).toInt 0 hi := by
  obtain ⟨hw, rfl⟩ := h
  have := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  refine ⟨rfl, ?_, ?_⟩ <;> rw [chunk_toInt x i w hw] <;> omega

/-- The limbs of `x`, weighted, sum to `x`. -/
public theorem chunk_sum (x : BitVec 512) :
    (x.toNat : Int) =
      (chunk x 0 21).toInt + (chunk x 1 21).toInt * 2 ^ 21 + (chunk x 2 21).toInt * 2 ^ 42 +
        (chunk x 3 21).toInt * 2 ^ 63 +
        (chunk x 4 21).toInt * 2 ^ 84 +
        (chunk x 5 21).toInt * 2 ^ 105 +
        (chunk x 6 21).toInt * 2 ^ 126 +
        (chunk x 7 21).toInt * 2 ^ 147 +
        (chunk x 8 21).toInt * 2 ^ 168 +
        (chunk x 9 21).toInt * 2 ^ 189 +
        (chunk x 10 21).toInt * 2 ^ 210 +
        (chunk x 11 21).toInt * 2 ^ 231 +
        (chunk x 12 21).toInt * 2 ^ 252 +
        (chunk x 13 21).toInt * 2 ^ 273 +
        (chunk x 14 21).toInt * 2 ^ 294 +
        (chunk x 15 21).toInt * 2 ^ 315 +
        (chunk x 16 21).toInt * 2 ^ 336 +
        (chunk x 17 21).toInt * 2 ^ 357 +
        (chunk x 18 21).toInt * 2 ^ 378 +
        (chunk x 19 21).toInt * 2 ^ 399 +
        (chunk x 20 21).toInt * 2 ^ 420 +
        (chunk x 21 21).toInt * 2 ^ 441 +
        (chunk x 22 21).toInt * 2 ^ 462 +
        (chunk x 23 29).toInt * 2 ^ 483 := by
  have := x.isLt
  simp only [chunk_toInt x _ _ (by decide : 21 ≤ 62), chunk_toInt x _ _ (by decide : 29 ≤ 62)]
  omega

/-- The spec's packing of twelve limbs, as a sum. -/
public theorem pack_eq {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 : BitVec 64} (b0 : s0 ≤ 2097151#64)
    (b1 : s1 ≤ 2097151#64) (b2 : s2 ≤ 2097151#64) (b3 : s3 ≤ 2097151#64) (b4 : s4 ≤ 2097151#64)
    (b5 : s5 ≤ 2097151#64) (b6 : s6 ≤ 2097151#64) (b7 : s7 ≤ 2097151#64) (b8 : s8 ≤ 2097151#64)
    (b9 : s9 ≤ 2097151#64) (b10 : s10 ≤ 2097151#64) (b11 : s11 ≤ 4194303#64) :
    (s9 >>> 3 ||| s10 <<< 18 ||| s11 <<< 39) ++
        ((s6 >>> 2 ||| s7 <<< 19 ||| s8 <<< 40 ||| s9 <<< 61) ++
          ((s3 >>> 1 ||| s4 <<< 20 ||| s5 <<< 41 ||| s6 <<< 62) ++
            (s0 ||| s1 <<< 21 ||| s2 <<< 42 ||| s3 <<< 63))) =
      s0.setWidth 256 + s1.setWidth 256 <<< 21 + s2.setWidth 256 <<< 42 + s3.setWidth 256 <<< 63 +
        s4.setWidth 256 <<< 84 +
        s5.setWidth 256 <<< 105 +
        s6.setWidth 256 <<< 126 +
        s7.setWidth 256 <<< 147 +
        s8.setWidth 256 <<< 168 +
        s9.setWidth 256 <<< 189 +
        s10.setWidth 256 <<< 210 +
        s11.setWidth 256 <<< 231 := by
  bv_decide

/-- Twelve limbs, packed as the spec packs them, are their weighted sum. -/
public theorem pack_toNat (s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 : BitVec 64)
    (h0 : 0 ≤ s0.toInt ∧ s0.toInt ≤ 2097151) (h1 : 0 ≤ s1.toInt ∧ s1.toInt ≤ 2097151)
    (h2 : 0 ≤ s2.toInt ∧ s2.toInt ≤ 2097151) (h3 : 0 ≤ s3.toInt ∧ s3.toInt ≤ 2097151)
    (h4 : 0 ≤ s4.toInt ∧ s4.toInt ≤ 2097151) (h5 : 0 ≤ s5.toInt ∧ s5.toInt ≤ 2097151)
    (h6 : 0 ≤ s6.toInt ∧ s6.toInt ≤ 2097151) (h7 : 0 ≤ s7.toInt ∧ s7.toInt ≤ 2097151)
    (h8 : 0 ≤ s8.toInt ∧ s8.toInt ≤ 2097151) (h9 : 0 ≤ s9.toInt ∧ s9.toInt ≤ 2097151)
    (h10 : 0 ≤ s10.toInt ∧ s10.toInt ≤ 2097151) (h11 : 0 ≤ s11.toInt ∧ s11.toInt ≤ 4194303) :
    ((s9 >>> 3 ||| s10 <<< 18 ||| s11 <<< 39) ++
          ((s6 >>> 2 ||| s7 <<< 19 ||| s8 <<< 40 ||| s9 <<< 61) ++
            ((s3 >>> 1 ||| s4 <<< 20 ||| s5 <<< 41 ||| s6 <<< 62) ++
              (s0 ||| s1 <<< 21 ||| s2 <<< 42 ||| s3 <<< 63)))).toNat =
      (s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231).toNat := by
  have nat (s : BitVec 64) (n : Nat) (h : 0 ≤ s.toInt ∧ s.toInt ≤ n) (hn : n < 2 ^ 63) :
    s.toInt = s.toNat ∧ s.toNat ≤ n ∧ s ≤ BitVec.ofNat 64 n := by
    rw [BitVec.toInt_eq_toNat_cond] at h
    split at h
    · rw [BitVec.toInt_eq_toNat_of_lt (by omega), BitVec.le_def, BitVec.toNat_ofNat,
        Nat.mod_eq_of_lt (by omega)]
      omega
    · omega
  obtain ⟨e0, t0, b0⟩ := nat s0 2097151 h0 (by decide)
  obtain ⟨e1, t1, b1⟩ := nat s1 2097151 h1 (by decide)
  obtain ⟨e2, t2, b2⟩ := nat s2 2097151 h2 (by decide)
  obtain ⟨e3, t3, b3⟩ := nat s3 2097151 h3 (by decide)
  obtain ⟨e4, t4, b4⟩ := nat s4 2097151 h4 (by decide)
  obtain ⟨e5, t5, b5⟩ := nat s5 2097151 h5 (by decide)
  obtain ⟨e6, t6, b6⟩ := nat s6 2097151 h6 (by decide)
  obtain ⟨e7, t7, b7⟩ := nat s7 2097151 h7 (by decide)
  obtain ⟨e8, t8, b8⟩ := nat s8 2097151 h8 (by decide)
  obtain ⟨e9, t9, b9⟩ := nat s9 2097151 h9 (by decide)
  obtain ⟨e10, t10, b10⟩ := nat s10 2097151 h10 (by decide)
  obtain ⟨e11, t11, b11⟩ := nat s11 4194303 h11 (by decide)
  rw [pack_eq b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11]
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq,
    Nat.reducePow, Nat.reduceAdd]
  simp (disch := omega) only [Nat.mod_eq_of_lt]
  omega

/-! ## Bounds automation -/

meta section

open Lean Meta Elab Tactic

namespace BE

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
    let some ⟨64, k⟩ ← getBitVecValue? c | throwError "be_lets: no bound for {e}"
    let k := k.toInt
    let (a, b, hx) ← bound st x
    unless 0 ≤ k do
      throwError "be_lets: negative factor in {e}"
    ok (a * k) (b * k)
    let args := #[x, c, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a * k), ← intE (b * k), hx]
    return (a * k, b * k, ← withSide (mkAppN (mkConst ``BE.mul) args))
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

/-- Introduce the goal's first `let v := e` as a plain variable, with `b_v : BE v v.toInt lo hi`
and `e_v : v.toInt = z` (`e_v : BE v z lo hi` for a carry, to keep its quotient from `omega`). -/
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

end BE

/-- `be_lets n`: introduce the goal's first `n` `let`s of signed 64-bit arithmetic, each with its
bounds `b_v` and its value `e_v` as an integer, both checked against overflow. -/
elab "be_lets " n:num : tactic => do
  let mut g ← getMainGoal
  let mut st ← g.withContext BE.scan
  for _ in [0:n.getNat] do
    (st, g) ← BE.step st g
  replaceMainGoal [g]

/-- `clear_be_eqs`: drop the values `e_v` that `be_lets` introduced. -/
elab "clear_be_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.userName.eraseMacroScopes.toString.startsWith "e_" then
        g ← g.clear d.fvarId
    replaceMainGoal [g]

end

/-! ## Reduce -/

/-- `reduce` computes `x mod ℓ`. -/
public theorem fd_curve25519_scalar_reduce.spec_val (x : BitVec 512) :
    (fd_curve25519_scalar_reduce.spec x).toNat = x.toNat % Ed25519.ell := by
  unfold fd_curve25519_scalar_reduce.spec Ed25519.ell
  lift_lets
  intro in0 in1 in2 in3 in4 in5 in6 in7 mask s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15
    s16 s17 s18 s19 s20 s21 s22 s23
  -- the limbs of `x`
  have hs :
    s0 = chunk x 0 21 ∧
      s1 = chunk x 1 21 ∧
      s2 = chunk x 2 21 ∧
      s3 = chunk x 3 21 ∧
      s4 = chunk x 4 21 ∧
      s5 = chunk x 5 21 ∧
      s6 = chunk x 6 21 ∧
      s7 = chunk x 7 21 ∧
      s8 = chunk x 8 21 ∧
      s9 = chunk x 9 21 ∧
      s10 = chunk x 10 21 ∧
      s11 = chunk x 11 21 ∧
      s12 = chunk x 12 21 ∧
      s13 = chunk x 13 21 ∧
      s14 = chunk x 14 21 ∧
      s15 = chunk x 15 21 ∧
      s16 = chunk x 16 21 ∧
      s17 = chunk x 17 21 ∧
      s18 = chunk x 18 21 ∧
      s19 = chunk x 19 21 ∧
      s20 = chunk x 20 21 ∧ s21 = chunk x 21 21 ∧ s22 = chunk x 22 21 ∧ s23 = chunk x 23 29 := by
    simp only [in0, in1, in2, in3, in4, in5, in6, in7, mask, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9,
      s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, chunk]
    bv_decide
  clear_value in0 in1 in2 in3 in4 in5 in6 in7 mask s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14
    s15 s16 s17 s18 s19 s20 s21 s22 s23
  obtain
    ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
      rfl, rfl, rfl, rfl, rfl⟩ :=
    hs
  have hx := chunk_sum x
  -- fold, carry, fold, carry: canonical limbs `s0 … s11` and `s12 ∈ [-1, 0]`, worth `x` mod `ℓ`
  be_lets 184
  obtain ⟨V, hV⟩ :
    ∃ V,
      V =
        s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231 +
          s12.toInt * 2 ^ 252 :=
    ⟨_, rfl⟩
  have hA : ((x.toNat : Int) - V) % (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by
    omega
  have l0 := b_s0.2; have l1 := b_s1.2; have l2 := b_s2.2; have l3 := b_s3.2
  have l4 := b_s4.2; have l5 := b_s5.2; have l6 := b_s6.2; have l7 := b_s7.2
  have l8 := b_s8.2; have l9 := b_s9.2; have l10 := b_s10.2; have l11 := b_s11.2
  have l12 := b_s12.2
  clear_be_eqs
  clear hx
  -- fold `s12` and carry: limbs worth `V - ℓ s12`, in `[0, ℓ)`
  be_lets 39
  have f0 := b_s0.2; have f1 := b_s1.2; have f2 := b_s2.2; have f3 := b_s3.2
  have f4 := b_s4.2; have f5 := b_s5.2; have f6 := b_s6.2; have f7 := b_s7.2
  have f8 := b_s8.2; have f9 := b_s9.2; have f10 := b_s10.2
  obtain ⟨F, hF⟩ :
    ∃ F,
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
  have hF' :
    0 ≤ F ∧
      F < 2 ^ 252 + 27742317777372353535851937790883648493 ∧
      ((x.toNat : Int) - F) % (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by
    omega
  have h11 : 0 ≤ s11.toInt ∧ s11.toInt ≤ 4194303 := by omega
  refine
    (pack_toNat s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 h11).trans
      ?_
  omega

/-! ## Validate -/

/-- `validate` accepts exactly the scalars below `ℓ`. -/
public theorem fd_curve25519_scalar_validate.spec_iff (s : BitVec 256) :
    fd_curve25519_scalar_validate.spec s = true ↔ s.toNat < Ed25519.ell := by
  simp only [fd_curve25519_scalar_validate.spec, decide_eq_true_eq, BitVec.lt_def]
  rfl

end MLIR.Firedancer.Ref

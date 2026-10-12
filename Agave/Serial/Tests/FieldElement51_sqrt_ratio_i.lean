module

public import Agave.Serial.FieldElement51_sqrt_ratio_i

meta import Agave.Serial.FieldElement51_sqrt_ratio_i

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def u : Pointer :=
  ⟨⟨2⟩, 0⟩

private def v : Pointer :=
  ⟨⟨3⟩, 0⟩

private abbrev V :=
  Vector (BitVec 64) 5

/-- Limbs as the 320 bits they are stored as. -/
private def bits (x : V) : BitVec 320 :=
  x[4] ++ (x[3] ++ (x[2] ++ (x[1] ++ x[0])))

/-- Block 0 free (the null pointer's); `out` a 48-byte zeroed block, `u` and `v` holding limbs. -/
private def state (ub vb : V) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 48 0), (⟨2⟩, .ofBytes 40 (bits ub)), (⟨3⟩, .ofBytes 40 (bits vb))]⟩⟩

private def sq (x : V) : V :=
  Vector.ofFn (FieldElement51_square.spec x.get)

private def mul (x y : V) : V :=
  Vector.ofFn (FieldElement51_Mul_mul.spec x.get y.get)

private def neg (x : V) : V :=
  Vector.ofFn (FieldElement51_Neg_neg.spec x.get)

private def sqrN : Nat → V → V
  | 0, x => x
  | n + 1, x => sqrN n (Vector.ofFn (FieldElement51_pow2k.square x.get))

private def cassign (x y : V) (c : BitVec 8) : V :=
  Vector.ofFn (FieldElement51_ConditionallySelectable_conditional_assign.spec x.get y.get c)

/-- `pow22501`'s `t19`, each `let` a vector computed once. -/
private def t19 (z : V) : V :=
  let t0 := sq z
  let t1 := sq (sq t0)
  let t2 := mul z t1
  let t3 := mul t0 t2
  let t5 := mul t2 (sq t3)
  let t7 := mul (sqrN 5 t5) t5
  let t9 := mul (sqrN 10 t7) t7
  let t11 := mul (sqrN 20 t9) t9
  let t13 := mul (sqrN 10 t11) t7
  let t15 := mul (sqrN 50 t13) t13
  let t17 := mul (sqrN 100 t15) t15
  mul (sqrN 50 t17) t13

/-- `spec`, each `let` a vector computed once. -/
private def specMemo (u v : V) : BitVec 8 × V :=
  let ct_eq (x y : V) := FieldElement51_ConstantTimeEq_ct_eq.spec x.get y.get
  let v3 := mul (sq v) v
  let v7 := mul (sq v3) v
  let uv7 := mul u v7
  let r := mul (mul u v3) (mul uv7 (sqrN 2 (t19 uv7)))
  let check := mul v (sq r)
  let i := Vector.ofFn FieldElement51.SQRT_M1
  let correct := ct_eq check u
  let flipped := ct_eq check (neg u)
  let flipped_i := ct_eq check (mul (neg u) i)
  let r := cassign r (mul i r) (flipped_i ||| flipped)
  let r := cassign r (neg r) (FieldElement51_is_negative.spec r.get)
  (flipped ||| correct, r)

/-- The run agrees with `specMemo`: the `Choice` at `out`, `r` from `out + 8`. -/
private def agrees (ub vb : V) : Bool :=
  match
    FieldElement51_sqrt_ratio_i.eval 5
      (FieldElement51_sqrt_ratio_i.args (.value out) (.value u) (.value v)) (state ub vb) with
  | .value (some .nil, s') =>
    let (c, r) := specMemo ub vb
    s'.mem.readAt out 8 == c &&
      (List.finRange 5).all fun i => s'.mem.readLimbs (out.add 8#64) i == r.get i
  | _ => false

-- `4 / 1`: a square
#guard agrees #v[4, 0, 0, 0, 0] #v[1, 0, 0, 0, 0]

#guard (specMemo #v[4, 0, 0, 0, 0] #v[1, 0, 0, 0, 0]).1 == 1#8

-- `2 / 1`: not a square
#guard agrees #v[2, 0, 0, 0, 0] #v[1, 0, 0, 0, 0]

#guard (specMemo #v[2, 0, 0, 0, 0] #v[1, 0, 0, 0, 0]).1 == 0#8

-- wide limbs
#guard
  agrees #v[0x7ffffffffffff, 0x123456789abcd, 0x5555555555555, 0x7000000000001, 0x1]
    #v[0x3, 0x7fffffffffff0, 0x2222222222222, 0x1, 0x7ffffffffffff]

end MLIR.Agave.Serial

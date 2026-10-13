module

public import Agave.Avx2.CompressedEdwardsY_decompress

meta import Agave.Avx2.CompressedEdwardsY_decompress

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def repr : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 168-byte zeroed block, `repr` holding `bytes`. -/
private def state (bytes : BitVec 256) : GlobalState :=
  GlobalState.withGlobals CompressedEdwardsY_decompress.globals
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 168 0), (⟨2⟩, .ofBytes 32 bytes)]⟩⟩

private abbrev V :=
  Vector (BitVec 64) 5

private def sq (x : V) : V :=
  Vector.ofFn (Serial.FieldElement51_square.spec x.get)

private def mul (x y : V) : V :=
  Vector.ofFn (Serial.FieldElement51_Mul_mul.spec x.get y.get)

private def neg (x : V) : V :=
  Vector.ofFn (Serial.FieldElement51_Neg_neg.spec x.get)

private def sqrN : Nat → V → V
  | 0, x => x
  | n + 1, x => sqrN n (Vector.ofFn (Serial.FieldElement51_pow2k.square x.get))

private def cassign (x y : V) (c : BitVec 8) : V :=
  Vector.ofFn (Serial.FieldElement51_ConditionallySelectable_conditional_assign.spec x.get y.get c)

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

/-- `Serial.CompressedEdwardsY_decompress.spec`, each `let` a vector computed once (the spec's own
evaluation recomputes each callee's limbs at every use). -/
private def specMemo (buf : BitVec 256) : Option (V × V × V × V) :=
  let ct_eq (x y : V) := Serial.FieldElement51_ConstantTimeEq_ct_eq.spec x.get y.get
  let one := Vector.ofFn Serial.FieldElement51.ONE
  let Y := Vector.ofFn (Serial.FieldElement51_from_bytes.spec buf)
  let YY := sq Y
  let u := Vector.ofFn (Serial.FieldElement51_Sub_sub.spec YY.get one.get)
  let v :=
    Vector.ofFn
      (Serial.FieldElement51_Add_add.spec (mul YY (Vector.ofFn Serial.FieldElement51.EDWARDS_D)).get
        one.get)
  let v3 := mul (sq v) v
  let v7 := mul (sq v3) v
  let uv7 := mul u v7
  let r := mul (mul u v3) (mul uv7 (sqrN 2 (t19 uv7)))
  let check := mul v (sq r)
  let i := Vector.ofFn Serial.FieldElement51.SQRT_M1
  let correct := ct_eq check u
  let flipped := ct_eq check (neg u)
  let flipped_i := ct_eq check (mul (neg u) i)
  let r := cassign r (mul i r) (flipped_i ||| flipped)
  let r := cassign r (neg r) (Serial.FieldElement51_is_negative.spec r.get)
  if flipped ||| correct = 0 then none
  else
    let X := cassign r (neg r) (buf.extractLsb' 248 8 >>> 7)
    some (X, Y, one, mul X Y)

/-- The run agrees with `specMemo` on `bytes`: the tag at `out`, the point's limbs from
`out + 8`. -/
private def agrees (bytes : BitVec 256) : Bool :=
  let s := state bytes
  match
    CompressedEdwardsY_decompress.eval 5
      (CompressedEdwardsY_decompress.args (.value out) (.value repr)) s with
  | .value (some .nil, s') =>
    match specMemo bytes with
    | none => s'.mem.readAt out 64 == 0#64
    | some (X, Y, Z, T) =>
      let coord (k : Nat) (c : V) :=
        (List.finRange 5).all fun i =>
          s'.mem.readLimbs (out.add (BitVec.ofNat 64 (8 + 40 * k))) i == c.get i
      s'.mem.readAt out 64 == 1#64 && coord 0 X && coord 1 Y && coord 2 Z && coord 3 T
  | _ => false

-- the basepoint, `y = 4/5`
#guard agrees 0x6666666666666666666666666666666666666666666666666666666666666658#256

#guard (specMemo 0x6666666666666666666666666666666666666666666666666666666666666658#256).isSome

-- the basepoint negated: the sign bit set
#guard agrees 0xe666666666666666666666666666666666666666666666666666666666666658#256

-- `y = 2`: no point
#guard agrees 0x0000000000000000000000000000000000000000000000000000000000000002#256

#guard (specMemo 0x0000000000000000000000000000000000000000000000000000000000000002#256).isNone

-- `y = 1` with the sign bit set: `x = 0`, accepted
#guard agrees 0x8000000000000000000000000000000000000000000000000000000000000001#256

-- `y = p + 1`, not canonical: decoded as `y = 1`
#guard agrees 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee#256

end MLIR.Agave.Avx2

module

public import Agave.Serial.FieldElement51_pow22501

meta import Agave.Serial.FieldElement51_pow22501

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def b : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` an 80-byte zeroed block, `a` and `b` holding
`aBytes` and `bBytes`. -/
private def state (aBytes bBytes : BitVec 320) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 80 0), (⟨2⟩, .ofBytes 40 aBytes), (⟨3⟩, .ofBytes 40 bBytes)]⟩⟩

/-- Every limb `2^64 - 1`. -/
private def ones : BitVec 320 :=
  BitVec.allOnes 320

/-- Limbs `2^52 - 1, 1, 2^51, 3, 2^63`. -/
private def mixed : BitVec 320 :=
  0x8000000000000000000000000000000300080000000000000000000000000001000fffffffffffff#320

/-- Limbs `2^54 - 1, 2^53 + 5, 0, 2^54 - 19, 12345`. -/
private def wide : BitVec 320 :=
  0x0000000000003039003fffffffffffed00000000000000000020000000000005003fffffffffffff#320

/-- `sqrN` on limbs held as a vector, each pass computed once. -/
private def sqrN : Nat → Vector (BitVec 64) 5 → Vector (BitVec 64) 5
  | 0, x => x
  | n + 1, x => sqrN n (Vector.ofFn (FieldElement51_pow2k.square x.get))

/-- `spec`, each `let` a vector computed once (the spec's own evaluation recomputes each callee's
limbs at every use). -/
private def specMemo (z : Fin 5 → BitVec 64) : Vector (BitVec 64) 5 × Vector (BitVec 64) 5 :=
  let sq (x : Vector (BitVec 64) 5) := Vector.ofFn (FieldElement51_square.spec x.get)
  let mul (x y : Vector (BitVec 64) 5) := Vector.ofFn (FieldElement51_Mul_mul.spec x.get y.get)
  let z := Vector.ofFn z
  let t0 := sq z
  let t1 := sq (sq t0)
  let t2 := mul z t1
  let t3 := mul t0 t2
  let t4 := sq t3
  let t5 := mul t2 t4
  let t6 := sqrN 5 t5
  let t7 := mul t6 t5
  let t8 := sqrN 10 t7
  let t9 := mul t8 t7
  let t10 := sqrN 20 t9
  let t11 := mul t10 t9
  let t12 := sqrN 10 t11
  let t13 := mul t12 t7
  let t14 := sqrN 50 t13
  let t15 := mul t14 t13
  let t16 := sqrN 100 t15
  let t17 := mul t16 t15
  let t18 := sqrN 50 t17
  let t19 := mul t18 t13
  (t19, t3)

/-- The run agrees with `specMemo` on `s`: both outputs, at `out` and `out + 40`. -/
private def agrees (s : GlobalState) : Bool :=
  match
    FieldElement51_pow22501.eval 10 (FieldElement51_pow22501.args (.value out) (.value a)) s with
  | .value (some .nil, s') =>
    let r := specMemo (s.mem.readLimbs a)
    (List.finRange 5).all fun k =>
      s'.mem.readLimbs out k == r.1[k] && s'.mem.readLimbs (out.add 40#64) k == r.2[k]
  | _ => false

#guard agrees (state mixed 0)

#guard agrees (state wide 0)

end MLIR.Agave.Serial

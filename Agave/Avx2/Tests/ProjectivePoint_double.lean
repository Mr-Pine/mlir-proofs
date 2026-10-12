module

public import Agave.Avx2.ProjectivePoint_double

meta import Agave.Avx2.ProjectivePoint_double

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a zeroed 160-byte block, `a` holding `aBytes`. -/
private def state (aBytes : BitVec 960) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 120 aBytes)]⟩⟩

/-- A field element from its limbs, lowest first. -/
private def fe (l0 l1 l2 l3 l4 : Nat) : BitVec 320 :=
  limbsBits fun
    | 0 => BitVec.ofNat 64 l0
    | 1 => BitVec.ofNat 64 l1
    | 2 => BitVec.ofNat 64 l2
    | 3 => BitVec.ofNat 64 l3
    | 4 => BitVec.ofNat 64 l4

/-- `ED25519_BASEPOINT_POINT`'s `X, Y, Z, T`. -/
private def bX : BitVec 320 :=
  fe 1738742601995546 1146398526822698 2070867633025821 562264141797630 587772402128613

private def bY : BitVec 320 :=
  fe 1801439850948184 1351079888211148 450359962737049 900719925474099 1801439850948198

private def bZ : BitVec 320 :=
  fe 1 0 0 0 0

private def bT : BitVec 320 :=
  fe 1841354044333475 16398895984059 755974180946558 900171276175154 1821297809914039

/-- Limbs up to `2^54 - 1`. -/
private def wide : BitVec 320 :=
  fe (2 ^ 54 - 1) (2 ^ 53 + 5) 0 (2 ^ 54 - 19) 12345

private def mixed : BitVec 320 :=
  fe (2 ^ 52 - 1) 1 (2 ^ 51) 3 (2 ^ 50 + 7)

/-- The run agrees with the serial `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match ProjectivePoint_double.eval 1 (ProjectivePoint_double.args (.value out) (.value a)) s with
  | .value (some .nil, s') =>
    let Q := s'.mem.readCompleted out
    let R := Serial.ProjectivePoint_double.spec (s.mem.readProjective a)
    (List.finRange 5).all fun k =>
      Q.X k == R.X k && Q.Y k == R.Y k && Q.Z k == R.Z k && Q.T k == R.T k
  | _ => false

#guard agrees (state (bZ ++ bY ++ bX))

#guard agrees (state (mixed ++ wide ++ mixed))

end MLIR.Agave.Avx2

module

public import Agave.Serial.Scalar52_add

meta import Agave.Serial.Scalar52_add

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def b : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Limbs as the 320 bits they are stored as. -/
private def bytesOf (x : List ℕ) : BitVec 320 :=
  BitVec.ofNat 320 ((x.zipIdx.map fun (v, i) => v * 2 ^ (64 * i)).sum)

/-- Three blocks after the null block: `out` zeroed, `a` and `b` holding limbs. -/
private def state (ab bb : BitVec 320) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 0), (⟨2⟩, .ofBytes 40 ab), (⟨3⟩, .ofBytes 40 bb)]⟩⟩

/-- The run stores `spec`'s limbs, the sum mod `ℓ`. -/
private def agrees (ab bb : BitVec 320) : Bool :=
  let s := state ab bb
  match Scalar52_add.eval 1 (Scalar52_add.args (.value out) (.value a) (.value b)) s with
  | .value (some .nil, s') =>
    let r := Scalar52_add.spec (s.mem.readLimbs a) (s.mem.readLimbs b)
    (List.finRange 5).all (fun i => s'.mem.readLimbs out i == r i) &&
      Scalar52.nat r ==
        (Scalar52.nat (s.mem.readLimbs a) + Scalar52.nat (s.mem.readLimbs b)) % _root_.Ed25519.ell
  | _ => false

-- `ℓ - 1` twice
#guard
  agrees (bytesOf [0x2631a5cf5d3ec, 0xdea2f79cd6581, 0x14def9, 0, 0x100000000000])
    (bytesOf [0x2631a5cf5d3ec, 0xdea2f79cd6581, 0x14def9, 0, 0x100000000000])

#guard agrees (bytesOf [1, 2, 3, 4, 5]) (bytesOf [0xfffffffffffff, 0xfffffffffffff, 0, 0, 0])

#guard agrees (bytesOf [0, 0, 0, 0, 0]) (bytesOf [7, 0, 0, 0, 0])

end MLIR.Agave.Serial

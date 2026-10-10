module

public import Agave.Serial.Scalar52_montgomery_mul

meta import Agave.Serial.Scalar52_montgomery_mul

namespace MLIR.Agave.Serial

open _root_.Ed25519

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def b : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Three 40-byte blocks after the null block: `out` zeroed, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 320) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 0), (⟨2⟩, .ofBytes 40 ab), (⟨3⟩, .ofBytes 40 bb)]⟩⟩

/-- Limbs as the 320 bits they are stored as. -/
private def bytesOf (l : List ℕ) : BitVec 320 :=
  BitVec.ofNat 320 ((l.zipIdx.map fun (x, i) => x * 2 ^ (64 * i)).sum)

/-- Bounded limbs of a number near `2^256`. -/
private def aBytes : BitVec 320 :=
  bytesOf [0xfffffffffffff, 0x123456789abcd, 0xfedcba9876543, 0x0f0f0f0f0f0f0, 0xffffffffffff]

/-- `R = 2^260 mod ℓ`. -/
private def rBytes : BitVec 320 :=
  bytesOf
    [0x000f48bd6721e6ed, 0x0003bab5ac67e45a, 0x000fffffeb35e51b, 0x000fffffffffffff,
      0x00000fffffffffff]

/-- The output limbs, or `none` for UB / out of fuel. -/
private def outLimbs (ab bb : BitVec 320) : Option (Fin 5 → BitVec 64) :=
  match
    Scalar52_montgomery_mul.eval 1 (Scalar52_montgomery_mul.args (.value out) (.value a) (.value b))
      (state ab bb) with
  | .value (some .nil, s') => some (s'.mem.readLimbs out)
  | _ => none

-- Every limb is `spec`'s, and `a R / 2^260 = a mod ℓ`.
#guard
  match outLimbs aBytes rBytes with
  | some r =>
    let s := state aBytes rBytes
    (List.finRange 5).all
        (fun k => r k == Scalar52_montgomery_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b) k) &&
      Scalar52.nat r == Scalar52.nat (s.mem.readLimbs a) % ell
  | none => false

-- `a a / 2^260` mod `ℓ`.
#guard
  match outLimbs aBytes aBytes with
  | some r =>
    let x := Scalar52.nat ((state aBytes aBytes).mem.readLimbs a)
    Scalar52.nat r == x * x * Scalar52.Rinv % ell
  | none => false

end MLIR.Agave.Serial

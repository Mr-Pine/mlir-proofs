module

public import Agave.Serial.Scalar52_pack

meta import Agave.Serial.Scalar52_pack

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def l : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two blocks after the null block: `out` (32 bytes) zeroed, `l` holding `lb`. -/
private def state (lb : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 0), (⟨2⟩, .ofBytes 40 lb)]⟩⟩

/-- Limbs as the 320 bits they are stored as. -/
private def bytesOf (x : List ℕ) : BitVec 320 :=
  BitVec.ofNat 320 ((x.zipIdx.map fun (v, i) => v * 2 ^ (64 * i)).sum)

/-- Bounded limbs, the top one below `2^48`. -/
private def lBytes : BitVec 320 :=
  bytesOf [0xfffffffffffff, 0x123456789abcd, 0xfedcba9876543, 0x0f0f0f0f0f0f0, 0xabcdef012345]

/-- The bytes stored at `out`, or `none` for UB / out of fuel. -/
private def outBytes (lb : BitVec 320) : Option (BitVec 256) :=
  match Scalar52_pack.eval 1 (Scalar52_pack.args (.value out) (.value l)) (state lb) with
  | .value (some .nil, s') => some (s'.mem.readAt out 256)
  | _ => none

-- The bytes are `spec`'s, and the limbs' number.
#guard
  match outBytes lBytes with
  | some r =>
    r == Scalar52_pack.spec ((state lBytes).mem.readLimbs l) &&
      r.toNat == Scalar52.nat ((state lBytes).mem.readLimbs l)
  | none => false

end MLIR.Agave.Serial

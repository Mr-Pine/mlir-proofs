module

public import Firedancer.Ref.fiat_25519_from_bytes

meta import Firedancer.Ref.fiat_25519_from_bytes

namespace MLIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def buf : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A 40-byte block for `out`, zeroed, and a 32-byte block holding `bytes`. -/
private def state (bytes : BitVec 256) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 32 bytes)]⟩⟩

/-- One 40-byte block whose first 32 bytes hold `bytes`, for `out` and `buf` both. -/
private def aliased (bytes : BitVec 256) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 (bytes.setWidth 320))]⟩⟩

/-- Every bit set, bit 255 too: the masked top bit and every limb full. -/
private def ones : BitVec 256 :=
  BitVec.allOnes 256

/-- Distinct bytes `0x01 … 0x20`, little-endian. -/
private def counting : BitVec 256 :=
  0x201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504030201#256

/-- The run agrees with `spec` on the bytes at `src`, stored at `out`. -/
private def agrees (s : GlobalState) (src : Pointer) : Bool :=
  match fiat_25519_from_bytes.eval 1 (fiat_25519_from_bytes.args (.value out) (.value src)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readLimbs out k == fiat_25519_from_bytes.spec (s.mem.readAt src 256) k
  | _ => false

#guard agrees (state ones) buf

#guard agrees (state counting) buf

#guard agrees (state 0) buf

-- `out` over the input: the loads come first.
#guard agrees (aliased counting) out

-- The limbs are the input's 51-bit slices, bit 255 dropped.
#guard (List.finRange 5).all fun k => fiat_25519_from_bytes.spec ones k == 0x7ffffffffffff#64

-- A poison pointer is UB.
#guard
  match
    fiat_25519_from_bytes.eval 1 (fiat_25519_from_bytes.args (.value out) .poison)
      (state counting) with
  | .value (some _, _) => false
  | _ => true

end MLIR.Firedancer.Ref

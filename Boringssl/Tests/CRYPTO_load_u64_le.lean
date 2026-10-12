module

public import Boringssl.CRYPTO_load_u64_le

meta import Boringssl.CRYPTO_load_u64_le

namespace MLIR.Boringssl

private def p0 : Pointer :=
  ⟨⟨1⟩, 0⟩

private def p1 : Pointer :=
  ⟨⟨1⟩, 1⟩

/-- One 8-byte block holding `bytes`. -/
private def state (bytes : BitVec 64) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 8 bytes)]⟩⟩

/-- The returned value, or `none` for UB / out of fuel. -/
private def out (ptr : ⟦Ty.ptr⟧) (bytes : BitVec 64) : Option (PoisonOr (BitVec 64)) :=
  match CRYPTO_load_u64_le.eval 4 (CRYPTO_load_u64_le.args ptr) (state bytes) with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- The 8 bytes, little-endian.
#guard out (.value p0) 0x0123456789abcdef#64 == some (.value 0x0123456789abcdef#64)

-- Past the block's end: UB.
#guard out (.value p1) 0#64 == none

end MLIR.Boringssl

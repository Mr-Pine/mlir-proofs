module

public import Sodium.load64_be
public import Sodium.store64_be

meta import Sodium.load64_be
meta import Sodium.store64_be

namespace MLIR.Sodium

private def p : Pointer :=
  ⟨⟨1⟩, 3⟩

/-- Eight known bytes at offset 3 of a 16-byte block. -/
private def s0 : GlobalState :=
  ⟨⟨2⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨16, 0x00112233445566778899aabbccddeeff#128, BitVec.allOnes 128, true,
          fun _ => none, true⟩)]⟩⟩

#guard
  match load64_be.eval 1 (load64_be.args (.value p)) s0 with
  | .value (some (.cons r .nil), _) =>
    r == .value (load64_be.spec (s0.mem.readAt p 64)) &&
      load64_be.spec (s0.mem.readAt p 64) == 0xccbbaa9988776655#64
  | _ => false

-- `load64_be` of what `store64_be` stored is the word
#guard
  match store64_be.eval 1 (store64_be.args (.value p) (.value 0x0102030405060708#64)) s0 with
  | .value (some .nil, s) =>
    s.mem.readAt p 64 == store64_be.spec 0x0102030405060708#64 &&
      load64_be.spec (s.mem.readAt p 64) == 0x0102030405060708#64
  | _ => false

end MLIR.Sodium

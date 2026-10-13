module

public import Sodium.sc25519_is_canonical

meta import Sodium.sc25519_is_canonical

namespace MLIR.Sodium

/-- `s` in block 1; the returned value, or `none` for UB. -/
private def run (s : BitVec 256) : Option (BitVec 32) :=
  let st : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 s)]⟩⟩
  match
    sc25519_is_canonical.call (sc25519_is_canonical.args (.value ⟨⟨1⟩, 0⟩))
      (st.withGlobals sc25519_is_canonical.globals) with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

/-- Test scalars: `0`, `ℓ - 1`, `ℓ`, `ℓ + 1`, a byte above `ℓ`'s at `16`, and `2^256 - 1`. -/
private def xs : List (BitVec 256) :=
  [0, BitVec.ofNat 256 (Ed25519.ell - 1), BitVec.ofNat 256 Ed25519.ell,
    BitVec.ofNat 256 (Ed25519.ell + 1), BitVec.ofNat 256 (Ed25519.ell + 2 ^ 128), BitVec.allOnes 256]

-- the spec's value, `1` exactly below `ℓ`
#guard xs.all fun s => run s == some (sc25519_is_canonical.spec s)
#guard xs.map run == [some 1, some 1, some 0, some 0, some 0, some 0]

end MLIR.Sodium

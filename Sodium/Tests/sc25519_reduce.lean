module

public import Boringssl.x25519_sc_reduce
public import Sodium.Mlir.sc25519_reduce

meta import Boringssl.x25519_sc_reduce
meta import Sodium.Mlir.sc25519_reduce

namespace MLIR.Sodium

private def buf : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- `ℓ`, the order of edwards25519's prime-order subgroup. -/
private def ell : Nat :=
  2 ^ 252 + 27742317777372353535851937790883648493

/-- The 64 bytes `x` at `buf`. -/
private def state (x : BitVec 512) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 64 x)]⟩⟩

/-- The 64 bytes at `buf` after the run, or `none` for UB / out of fuel. -/
private def run (x : BitVec 512) (p : ⟦Ty.ptr⟧ := .value buf) : Option (BitVec 512) :=
  match sc25519_reduce.eval 10 (sc25519_reduce.args p) (state x) with
  | .value (some .nil, s') => some (s'.mem.readAt buf 512)
  | _ => none

private def inputs : List (BitVec 512) :=
  [0, 1, BitVec.ofNat 512 (ell - 1), BitVec.ofNat 512 ell, BitVec.ofNat 512 (ell + 5),
    BitVec.ofNat 512 (2 ^ 256 - 1), BitVec.ofNat 512 (ell * ell + 12345),
    0x0123456789abcdeffedcba9876543210_0f1e2d3c4b5a69788796a5b4c3d2e1f0#256 ++
      0x89abcdef01234567_76543210fedcba98_deadbeefcafebabe_0123456789abcdef#256,
    -1]

-- The low 32 bytes become BoringSSL's spec, `x mod ℓ`; the high 32 stay.
#guard
  inputs.all fun x =>
    run x == some (x.extractLsb' 256 256 ++ BitVec.ofNat 256 (x.toNat % ell))

-- A poison pointer is UB.
#guard (run 0 .poison).isNone

end MLIR.Sodium

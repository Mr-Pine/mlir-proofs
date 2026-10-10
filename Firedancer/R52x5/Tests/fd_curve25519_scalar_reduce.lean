module

public import Firedancer.R52x5.fd_curve25519_scalar_reduce

meta import Firedancer.R52x5.fd_curve25519_scalar_reduce

namespace MLIR.Firedancer.R52x5

private def inp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def out : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `ℓ`, the order of edwards25519's prime-order subgroup. -/
private def ell : Nat :=
  2 ^ 252 + 27742317777372353535851937790883648493

/-- The 64 bytes `x` at `inp`, 32 zero bytes at `out`. -/
private def state (x : BitVec 512) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 64 x), (⟨2⟩, .ofBytes 32 (0#256))]⟩⟩

/-- The returned pointer and the 32 bytes at `out` after the run, or `none` for UB / out of fuel. -/
private def run (x : BitVec 512) (o : ⟦Ty.ptr⟧ := .value out) :
    Option (PoisonOr Pointer × BitVec 256) :=
  match
    fd_curve25519_scalar_reduce.eval 10 (fd_curve25519_scalar_reduce.args o (.value inp))
      (state x) with
  | .value (some (.cons r .nil), s') => some (r, s'.mem.readAt out 256)
  | _ => none

/-- `out` aliasing `inp`: the 64 bytes after the run, or `none`. -/
private def runInPlace (x : BitVec 512) : Option (BitVec 512) :=
  match
    fd_curve25519_scalar_reduce.eval 10 (fd_curve25519_scalar_reduce.args (.value inp) (.value inp))
      (state x) with
  | .value (some _, s') => some (s'.mem.readAt inp 512)
  | _ => none

private def inputs : List (BitVec 512) :=
  [0, 1, BitVec.ofNat 512 (ell - 1), BitVec.ofNat 512 ell, BitVec.ofNat 512 (ell + 5),
    BitVec.ofNat 512 (2 ^ 256 - 1), BitVec.ofNat 512 (ell * ell + 12345),
    0x0123456789abcdeffedcba9876543210_0f1e2d3c4b5a69788796a5b4c3d2e1f0#256 ++
      0x89abcdef01234567_76543210fedcba98_deadbeefcafebabe_0123456789abcdef#256,
    -1]

-- The run stores the spec and returns `out`.
#guard inputs.all fun x => run x == some (.value out, Ref.fd_curve25519_scalar_reduce.spec x)

-- The spec is `x mod ℓ`.
#guard inputs.all fun x => (Ref.fd_curve25519_scalar_reduce.spec x).toNat == x.toNat % ell

-- In place: the low 32 bytes become the spec, the high 32 stay.
#guard
  inputs.all fun x =>
    runInPlace x == some (x.extractLsb' 256 256 ++ Ref.fd_curve25519_scalar_reduce.spec x)

-- A poison pointer is UB.
#guard (run 0 .poison).isNone

end MLIR.Firedancer.R52x5

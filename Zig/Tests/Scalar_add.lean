module

public import Zig.Scalar_add

meta import Zig.Scalar_add

namespace MLIR.Zig

private def outp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def ap : Pointer :=
  ⟨⟨2⟩, 0⟩

private def bp : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- The limbs of `x`'s value, as a block. -/
private def limbsBlock (x : Nat) : MemoryBlock :=
  .ofBytes 40 (limbsBits (Scalar.limbs (BitVec.ofNat 320 x)))

/-- `out` undefined, `a` and `b`'s limbs. -/
private def state (a b : Nat) : GlobalState :=
  ⟨⟨4⟩, ⟨Std.ExtHashMap.ofList
    [(⟨1⟩, ⟨40, 0, 0, true, fun _ => none, true⟩), (⟨2⟩, limbsBlock a), (⟨3⟩, limbsBlock b)]⟩⟩

/-- `out`'s value after the call, or `none` for UB / out of fuel. -/
private def out (a b : Nat) : Option Nat :=
  match
    Scalar_add.eval 1000 (Scalar_add.args (.value outp) (.value ap) (.value bp))
      ((state a b).withGlobals Scalar_add.globals) with
  | .value (some .nil, s') => some (Scalar.val (s'.mem.readLimbs outp))
  | _ => none

private def inputs : List Nat :=
  [0, 1, Ed25519.ell - 1, Ed25519.ell / 2, Ed25519.ell / 2 + 1, 2 ^ 252, 0x123456789abcdef]

-- The sum mod `ℓ`.
#guard inputs.all fun a => inputs.all fun b => out a b == some ((a + b) % Ed25519.ell)

end MLIR.Zig

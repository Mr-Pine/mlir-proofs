module

public import Zig.Edwards25519_neg

meta import Zig.Edwards25519_neg

namespace MLIR.Zig

private def outp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def pp : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- A point from 20 limbs, `is_base` set. -/
private def pt (l : Nat → Nat) : ZPt :=
  ⟨fun i => BitVec.ofNat 64 (l i), fun i => BitVec.ofNat 64 (l (5 + i)), fun i =>
    BitVec.ofNat 64 (l (10 + i)), fun i => BitVec.ofNat 64 (l (15 + i))⟩

/-- `out` undefined, the point `P` at `p`. -/
private def state (P : ZPt) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨168, 0, 0, true, fun _ => none, true⟩),
          (⟨2⟩, .ofBytes 168 ((0#63 ++ 1#1 ++ P.bits).cast (by decide)))]⟩⟩

/-- `out`'s point and `is_base` after the call, or `none` for UB / out of fuel. -/
private def out (P : ZPt) : Option (List (BitVec 64) × BitVec 1) :=
  match
    Edwards25519_neg.eval 1000 (Edwards25519_neg.args (.value outp) (.value pp))
      ((state P).withGlobals Edwards25519_neg.globals) with
  | .value (some .nil, s') =>
    let Q := s'.mem.readPt outp
    some
      (List.ofFn (n := 20) fun i => [Q.x, Q.y, Q.z, Q.t][i / 5]! (Fin.ofNat 5 i),
        s'.mem.readBase outp)
  | _ => none

private def flat (Q : ZPt) : List (BitVec 64) :=
  List.ofFn (n := 20) fun i => [Q.x, Q.y, Q.z, Q.t][i / 5]! (Fin.ofNat 5 i)

private def inputs : List ZPt :=
  [pt fun _ => 0, pt fun i => i * 0x123456789 % 2 ^ 51, pt fun i => 2 ^ 51 - 1 - i]

-- `spec`'s point, `is_base` false.
#guard inputs.all fun P => out P == some (flat (Edwards25519.neg.spec P), 0#1)

end MLIR.Zig

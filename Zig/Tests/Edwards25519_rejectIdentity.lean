module

public import Zig.Edwards25519_rejectIdentity

meta import Zig.Edwards25519_rejectIdentity

namespace MLIR.Zig

/-- A point from 20 limbs. -/
private def pt (l : Nat → Nat) : ZPt :=
  ⟨fun i => BitVec.ofNat 64 (l i), fun i => BitVec.ofNat 64 (l (5 + i)), fun i =>
    BitVec.ofNat 64 (l (10 + i)), fun i => BitVec.ofNat 64 (l (15 + i))⟩

/-- A point's 20 limbs. -/
private def flat (Q : ZPt) : List (BitVec 64) :=
  List.ofFn (n := 20) fun i => [Q.x, Q.y, Q.z, Q.t][i / 5]! (Fin.ofNat 5 i)

/-- A point's block, `is_base` set. -/
private def ptBlock (P : ZPt) : MemoryBlock :=
  .ofBytes 168 ((0#63 ++ 1#1 ++ P.bits).cast (by decide))

private def inputs : List ZPt :=
  [pt fun i => if i = 5 ∨ i = 10 then 1 else 0, pt fun i => i * 0x123456789 % 2 ^ 51,
    pt fun i => 2 ^ 51 - 1 - i]

/-- The result of `rejectIdentity` of `P`, or `none` for UB / out of fuel. -/
private def out (P : ZPt) : Option (BitVec 16) :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ptBlock P)]⟩⟩
  match
    Edwards25519_rejectIdentity.eval 1000 (Edwards25519_rejectIdentity.args (.value ⟨⟨1⟩, 0⟩))
      (s.withGlobals Edwards25519_rejectIdentity.globals) with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

-- `spec`'s code.
#guard inputs.all fun P => out P == some (Edwards25519.rejectIdentity.spec P)

#guard out (pt fun _ => 0) == some 3#16

end MLIR.Zig

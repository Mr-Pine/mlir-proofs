module

public import Zig.Edwards25519_dbl

meta import Zig.Edwards25519_dbl

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

/-- `out`'s point and `is_base` after `dbl` of `P`, or `none` for UB / out of fuel. -/
private def out (P : ZPt) : Option (List (BitVec 64) × BitVec 1) :=
  let s : GlobalState :=
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨168, 0, 0, true, fun _ => none, true⟩), (⟨2⟩, ptBlock P)]⟩⟩
  match
    Edwards25519_dbl.eval 1000 (Edwards25519_dbl.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩))
      (s.withGlobals Edwards25519_dbl.globals) with
  | .value (some .nil, s') => some (flat (s'.mem.readPt ⟨⟨1⟩, 0⟩), s'.mem.readBase ⟨⟨1⟩, 0⟩)
  | _ => none

#guard inputs.all fun P => out P == some (flat (Edwards25519.dbl.spec P), 0#1)

end MLIR.Zig

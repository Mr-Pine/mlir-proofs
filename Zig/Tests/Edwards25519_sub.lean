module

public import Zig.Edwards25519_sub

meta import Zig.Edwards25519_sub

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

private def pt0 : ZPt :=
  pt fun i => if i = 5 ∨ i = 10 then 1 else 0

private def pt1 : ZPt :=
  pt fun i => i * 0x123456789 % 2 ^ 51

private def pt2 : ZPt :=
  pt fun i => 2 ^ 51 - 1 - i

/-- `out`'s point and `is_base` after `sub` of `P`, `Q`, or `none` for UB / out of fuel. -/
private def out (P Q : ZPt) : Option (List (BitVec 64) × BitVec 1) :=
  let s : GlobalState :=
    ⟨⟨4⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨168, 0, 0, true⟩), (⟨2⟩, ptBlock P), (⟨3⟩, ptBlock Q)]⟩⟩
  match
    Edwards25519_sub.eval 1000
      (Edwards25519_sub.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value ⟨⟨3⟩, 0⟩)) s with
  | .value (some .nil, s') => some (flat (s'.mem.readPt ⟨⟨1⟩, 0⟩), s'.mem.readBase ⟨⟨1⟩, 0⟩)
  | _ => none

-- `spec`'s point, `is_base` false.
#guard
  [(pt0, pt1), (pt1, pt2)].all fun (P, Q) => out P Q == some (flat (Edwards25519.sub.spec P Q), 0#1)

end MLIR.Zig

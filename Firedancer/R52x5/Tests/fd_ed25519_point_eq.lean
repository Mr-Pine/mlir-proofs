module

public import Firedancer.R52x5.fd_ed25519_point_eq

meta import Firedancer.R52x5.fd_ed25519_point_eq

namespace MLIR.Firedancer.R52x5

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

private def b : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding `f i`. -/
private def bytes (f : Nat → Nat) : BitVec 1536 :=
  BitVec.ofNat 1536 ((List.range 24).foldl (fun acc i => acc + f i * 2 ^ (64 * i)) 0)

/-- `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 1536) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨192, ab⟩), (⟨1⟩, ⟨192, bb⟩)]⟩⟩

/-- Whether `fd_ed25519_point_eq(a, b)` returns `spec` of the points, leaves memory as it was and
moves the counter on by 22, and returns `r`. -/
private def check (ab bb : BitVec 1536) (r : BitVec 32) : Bool :=
  let s := state ab bb
  match fd_ed25519_point_eq.eval 1 (fd_ed25519_point_eq.args (.value a) (.value b)) s with
  | .value (some (.cons ret .nil), s') =>
    let v := fd_ed25519_point_eq.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b)
    ret == .value v && v == r && s'.mem.readAt a 1536 == ab && s'.mem.readAt b 1536 == bb &&
      s'.alloc.nextFreeBlock == 24
  | _ => false

/-- A point's lanes (lane `4 i + j`: limb `i` of coordinate `j`), the pad lanes 20-23 junk. -/
private def pt (i : Nat) : Nat :=
  1000003 * (i % 4 + 1) + 7919 * (i / 4)

-- a point against itself, against itself doubled, and against one with another `Y`
#guard check (bytes pt) (bytes pt) 1

#guard check (bytes pt) (bytes fun i => if i < 20 then 2 * pt i else 5) 1

#guard check (bytes pt) (bytes fun i => if i = 1 then 5 else pt i) 0

end MLIR.Firedancer.R52x5

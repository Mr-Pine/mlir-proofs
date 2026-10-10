module

public import Firedancer.R52x5.fd_ed25519_point_affine_eq

meta import Firedancer.R52x5.fd_ed25519_point_affine_eq

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
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 192 ab), (⟨1⟩, .ofBytes 192 bb)]⟩⟩

/-- Whether `fd_ed25519_point_affine_eq(a, b)` returns `spec` of the points, and that is `r`. -/
private def check (ab bb : BitVec 1536) (r : BitVec 32) : Bool :=
  let s := state ab bb
  match
    fd_ed25519_point_affine_eq.eval 1 (fd_ed25519_point_affine_eq.args (.value a) (.value b)) s with
  | .value (some (.cons ret .nil), _) =>
    let v := fd_ed25519_point_affine_eq.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b)
    ret == .value v && v == r
  | _ => false

/-- An affine point `(x, y, 1, x y)` in the lanes (lane `4 i + j`: limb `i` of coordinate `j`),
limb 0 only. -/
private def affine (x y : Nat) (i : Nat) : Nat :=
  if i = 0 then x else if i = 1 then y else if i = 2 then 1 else if i = 3 then x * y else 0

-- `(3 x, 3 y, 3, 3 x y)` against `(x, y, 1, x y)`, and against `(x, y + 1, 1, x (y + 1))`
#guard check (bytes fun i => 3 * affine 1234 5678 i) (bytes (affine 1234 5678)) 1

#guard check (bytes fun i => 3 * affine 1234 5678 i) (bytes (affine 1234 5679)) 0

end MLIR.Firedancer.R52x5

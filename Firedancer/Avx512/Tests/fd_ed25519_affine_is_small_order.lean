module

public import Firedancer.Avx512.fd_ed25519_affine_is_small_order

meta import Firedancer.Avx512.fd_ed25519_affine_is_small_order

namespace MLIR.Firedancer.Avx512

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding `f i`. -/
private def bytes (f : Nat → Nat) : BitVec 1536 :=
  BitVec.ofNat 1536 ((List.range 24).foldl (fun acc i => acc + f i * 2 ^ (64 * i)) 0)

/-- `a` holding `b`. -/
private def state (b : BitVec 1536) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 b)]⟩⟩

/-- Whether `fd_ed25519_affine_is_small_order(a)` returns `spec`, and that is `r`. -/
private def check (b : BitVec 1536) (r : BitVec 32) : Bool :=
  match
    fd_ed25519_affine_is_small_order.eval 1 (fd_ed25519_affine_is_small_order.args (.value a))
      (state b) with
  | .value (some (.cons ret .nil), _) =>
    let v := fd_ed25519_affine_is_small_order.spec ((state b).mem.readQuad a)
    ret == .value v && v == r
  | _ => false

-- a point with nonzero `X`, `Y` off the order-8 ones; and one with `X = 0`
#guard check (bytes fun i => 1000 + 37 * i) 0

#guard check (bytes fun i => if i % 4 = 0 then 0 else 1000 + 37 * i) 1

end MLIR.Firedancer.Avx512

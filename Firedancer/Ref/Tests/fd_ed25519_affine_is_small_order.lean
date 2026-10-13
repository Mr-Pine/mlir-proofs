module

public import Firedancer.Ref.fd_ed25519_affine_is_small_order

meta import Firedancer.Ref.fd_ed25519_affine_is_small_order

namespace MLIR.Firedancer.Ref

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- One 160-byte block, `a`, holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  GlobalState.withGlobals fd_ed25519_affine_is_small_order.globals
    ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 160 bytes)]⟩⟩

/-- The point with limbs `x`, `y` in `X`, `Y`, `T = 0`, `Z = 1`. -/
private def point (x y : Fin 5 → BitVec 64) : BitVec 1280 :=
  (1#1280 <<< 960) ||| ((y 4 ++ y 3 ++ y 2 ++ y 1 ++ y 0).setWidth 1280 <<< 320) |||
    (x 4 ++ x 3 ++ x 2 ++ x 1 ++ x 0).setWidth 1280

/-- The result if it is `spec` of the point, `a` is unchanged and the counter moved on by eight
blocks; else `none`. -/
private def out (bytes : BitVec 1280) : Option (BitVec 32) :=
  let s := state bytes
  match
    fd_ed25519_affine_is_small_order.eval 1 (fd_ed25519_affine_is_small_order.args (.value a))
      s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_ed25519_affine_is_small_order.spec (s.mem.readPoint a) &&
          s'.mem.readAt a 1280 == bytes &&
          s'.alloc.nextFreeBlock == 9 then
      some v
    else none
  | _ => none

private def three : Fin 5 → BitVec 64 := fun i => if i = 0 then 3 else 0

-- `X = 0`, `Y = 0`, `Y` an order-8 point's
#guard out (point 0 three) == some 1#32

#guard out (point three 0) == some 1#32

#guard out (point three fd_ed25519_order8_point_y0.limbs) == some 1#32

#guard out (point three fd_ed25519_order8_point_y1.limbs) == some 1#32

-- none of them
#guard out (point three three) == some 0#32

end MLIR.Firedancer.Ref

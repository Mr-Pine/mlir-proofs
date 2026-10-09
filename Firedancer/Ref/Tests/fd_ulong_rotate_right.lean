module

public import Firedancer.Ref.fd_ulong_rotate_right

meta import Firedancer.Ref.fd_ulong_rotate_right

namespace MLIR.Firedancer.Ref

private def s0 : GlobalState :=
  ⟨default, default⟩

/-- The returned value, or `none` if the run fails. -/
private def out (x : BitVec 64) (n : BitVec 32) : Option (PoisonOr (BitVec 64)) :=
  match fd_ulong_rotate_right.eval 1 (fd_ulong_rotate_right.args (.value x) (.value n)) s0 with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- the low bit comes round to the top; a negative count rotates left
#guard out 1#64 1#32 == some (.value 0x8000000000000000#64)

#guard out 1#64 (-1 : BitVec 32) == some (.value 2#64)

#guard fd_ulong_rotate_right.spec 0x0123456789abcdef#64 8#32 == 0xef0123456789abcd#64

#guard
  [(0x0123456789abcdef#64, 0#32), (0x0123456789abcdef#64, 64#32), (0xdeadbeef#64, 14#32),
        (0xdeadbeef#64, 41#32), (0xfedcba9876543210#64, 100#32), (5#64, (-61 : BitVec 32))].all
    fun (x, n) => out x n == some (.value (fd_ulong_rotate_right.spec x n))

end MLIR.Firedancer.Ref

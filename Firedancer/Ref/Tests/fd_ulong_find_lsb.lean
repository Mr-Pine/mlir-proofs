module

public import Firedancer.Ref.fd_ulong_find_lsb

meta import Firedancer.Ref.fd_ulong_find_lsb

namespace MLIR.Firedancer.Ref

private def s0 : GlobalState :=
  ⟨default, default⟩

/-- The returned value, or `none` if the run fails. -/
private def out (x : PoisonOr (BitVec 64)) : Option (PoisonOr (BitVec 32)) :=
  match fd_ulong_find_lsb.eval 1 (fd_ulong_find_lsb.args x) s0 with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- `0` selects `-1` over the `cttz` poison
#guard out (.value 0#64) == some (.value (-1#32))

#guard out (.value 0x8000000000000000#64) == some (.value 63#32)

#guard fd_ulong_find_lsb.spec 0x0123456789abcde0#64 == 5#32

#guard
  [0#64, 1#64, 2#64, 0xff00000000000000#64, 0x8899aabbccddeef0#64, 0x10000#64].all fun x =>
    out (.value x) == some (.value (fd_ulong_find_lsb.spec x))

-- A poison argument poisons the result.
#guard out .poison == some .poison

end MLIR.Firedancer.Ref

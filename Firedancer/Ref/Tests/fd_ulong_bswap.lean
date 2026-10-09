module

public import Firedancer.Ref.fd_ulong_bswap

meta import Firedancer.Ref.fd_ulong_bswap

namespace MLIR.Firedancer.Ref

private def s0 : GlobalState :=
  ⟨default, default⟩

/-- The returned value, or `none` if the run fails. -/
private def out (x : PoisonOr (BitVec 64)) : Option (PoisonOr (BitVec 64)) :=
  match fd_ulong_bswap.eval 1 (fd_ulong_bswap.args x) s0 with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

#guard out (.value 0x0123456789abcdef#64) == some (.value 0xefcdab8967452301#64)

#guard fd_ulong_bswap.spec 0x0123456789abcdef#64 == 0xefcdab8967452301#64

#guard
  [0#64, 1#64, 0xff00000000000000#64, 0x8899aabbccddeeff#64].all fun x =>
    out (.value x) == some (.value (fd_ulong_bswap.spec x))

-- A poison argument poisons the result.
#guard out .poison == some .poison

end MLIR.Firedancer.Ref

module

public import Firedancer.Ref.fd_int_min

meta import Firedancer.Ref.fd_int_min

namespace LeanMLIR.RIR.Firedancer.Ref

private def s0 : GlobalState :=
  ⟨default, default⟩

private def head : Vals [Ty.bv 32] → PoisonOr (BitVec 32)
  | .cons v .nil => v

/-- The returned value, or `none` if the fuel ran out. -/
private def out (x : PoisonOr (BitVec 32)) (fuel : Nat := 1) : Option (PoisonOr (BitVec 32)) :=
  match fd_int_min.eval fuel (fd_int_min.args x) s0 with
  | .value (some vs, _) => some (head vs)
  | _ => none

-- `smin` is signed: 14 wins over 20, but -5 wins over 14.
#guard out (.value 3#32) == some (.value 3#32)

#guard out (.value 20#32) == some (.value 14#32)

#guard out (.value (-5 : BitVec 32)) == some (.value (-5 : BitVec 32))

#guard out (.value 14#32) == some (.value 14#32)

#guard out (.value (-2147483648 : BitVec 32)) == some (.value (-2147483648 : BitVec 32))

-- A poison argument poisons the result.
#guard out .poison == some .poison

-- Without fuel there is no result at all.
#guard out (.value 3#32) 0 == none

end LeanMLIR.RIR.Firedancer.Ref

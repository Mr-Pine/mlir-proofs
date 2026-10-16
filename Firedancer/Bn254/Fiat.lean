module

public import Firedancer.Bn254.Bits

/-! The fiat-crypto functions the G1 code calls (`third_party/fiat-crypto/bn254_64.c`), modelled by
their documented contracts: the contract value when every input is `< m` (each function's
preconditions, and the file's NOTE at line 7), an opaque `<name>_unspec` of the inputs otherwise.
The postconditions pin `from_montgomery out1` modulo `m` and bound `eval out1 < m`; since
`from_montgomery` is multiplication by a unit, `eval out1` is the canonical residue below. Each
reads every input limb before storing `out1`, so `out1` may alias an input. -/

namespace Firedancer.Bn254

@[expose] public section

/-- `m` of `bn254_64.c:5`, the base field prime `p`. -/
def fiat_bn254_m : Nat :=
  0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

opaque fiat_bn254_add_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_bn254_add` (`bn254_64.c:858-869`): "eval (from_montgomery out1) mod m = (eval
(from_montgomery arg1) + eval (from_montgomery arg2)) mod m", pre `eval arg1 < m`, `eval arg2 <
m`. -/
def fiat_bn254_add.spec (arg1 arg2 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_bn254_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 ((limbsEval arg1 + limbsEval arg2) % m)
  else fiat_bn254_add_unspec arg1 arg2

opaque fiat_bn254_sub_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_bn254_sub` (`bn254_64.c:911-922`): "eval (from_montgomery out1) mod m = (eval
(from_montgomery arg1) - eval (from_montgomery arg2)) mod m", pre `eval arg1 < m`, `eval arg2 <
m`. -/
def fiat_bn254_sub.spec (arg1 arg2 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_bn254_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 (((limbsEval arg1 : Int) - limbsEval arg2) % (m : Int)).toNat
  else fiat_bn254_sub_unspec arg1 arg2

opaque fiat_bn254_opp_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_bn254_opp` (`bn254_64.c:955-965`): "eval (from_montgomery out1) mod m = -eval
(from_montgomery arg1) mod m", pre `eval arg1 < m`. -/
def fiat_bn254_opp.spec (arg1 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_bn254_m
  if limbsEval arg1 < m then limbsOfNat 4 ((-(limbsEval arg1 : Int)) % (m : Int)).toNat
  else fiat_bn254_opp_unspec arg1

end

end Firedancer.Bn254

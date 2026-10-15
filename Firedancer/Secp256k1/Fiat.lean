module

public import Firedancer.Secp256k1.Bits

/-! The fiat-crypto functions `fd_secp256k1_ref.c` calls (`third_party/fiat-crypto/
secp256k1_montgomery{,_scalar}_64.c`), modelled by their documented contracts: the contract value
when every input is `< m` (each function's preconditions, and the file's NOTE at line 7), an
opaque `<name>_unspec` of the inputs otherwise. The contracts pin `out1` modulo `m` and bound
`0 ≤ eval out1 < m`; the model is that unique canonical representative. `from_montgomery z` is
`eval z * ((2^64)⁻¹ mod m)^4 mod m` (`fiat_Rinv m`), so e.g. `mul` is `a * b * fiat_Rinv m mod m`
and `to_montgomery` is `a * 2^256 mod m`. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-- `((2^64)⁻¹ mod m)^4`, the factor of fiat's `from_montgomery`. -/
def fiat_Rinv (m : Nat) : Nat := invMod (2 ^ 64) m ^ 4

/-! ## `secp256k1_montgomery_64.c` -/

/-- `m` of `secp256k1_montgomery_64.c:5`. -/
def fiat_secp256k1_montgomery_m : Nat :=
  0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f

opaque fiat_secp256k1_montgomery_mul_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_mul` (`secp256k1_montgomery_64.c:156-167`): "eval (from_montgomery
out1) mod m = (eval (from_montgomery arg1) * eval (from_montgomery arg2)) mod m", pre `eval arg1
< m`, `eval arg2 < m`. -/
def fiat_secp256k1_montgomery_mul.spec (arg1 arg2 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 ((limbsEval arg1 * limbsEval arg2 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_mul_unspec arg1 arg2

opaque fiat_secp256k1_montgomery_square_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_square` (`secp256k1_montgomery_64.c:512-522`): "eval
(from_montgomery out1) mod m = (eval (from_montgomery arg1) * eval (from_montgomery arg1)) mod
m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_square.spec (arg1 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * limbsEval arg1 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_square_unspec arg1

opaque fiat_secp256k1_montgomery_add_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_add` (`secp256k1_montgomery_64.c:867-878`): "eval (from_montgomery
out1) mod m = (eval (from_montgomery arg1) + eval (from_montgomery arg2)) mod m", pre `eval arg1
< m`, `eval arg2 < m`. -/
def fiat_secp256k1_montgomery_add.spec (arg1 arg2 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 ((limbsEval arg1 + limbsEval arg2) % m)
  else fiat_secp256k1_montgomery_add_unspec arg1 arg2

opaque fiat_secp256k1_montgomery_sub_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_sub` (`secp256k1_montgomery_64.c:920-931`): "eval (from_montgomery
out1) mod m = (eval (from_montgomery arg1) - eval (from_montgomery arg2)) mod m", pre `eval arg1
< m`, `eval arg2 < m`. -/
def fiat_secp256k1_montgomery_sub.spec (arg1 arg2 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 (((limbsEval arg1 : Int) - limbsEval arg2) % (m : Int)).toNat
  else fiat_secp256k1_montgomery_sub_unspec arg1 arg2

opaque fiat_secp256k1_montgomery_opp_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_opp` (`secp256k1_montgomery_64.c:964-974`): "eval (from_montgomery
out1) mod m = -eval (from_montgomery arg1) mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_opp.spec (arg1 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m then limbsOfNat 4 ((-(limbsEval arg1 : Int)) % (m : Int)).toNat
  else fiat_secp256k1_montgomery_opp_unspec arg1

opaque fiat_secp256k1_montgomery_from_montgomery_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_from_montgomery` (`secp256k1_montgomery_64.c:1007-1017`): "eval
out1 mod m = (eval arg1 * ((2^64)⁻¹ mod m)^4) mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_from_montgomery.spec (arg1 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_from_montgomery_unspec arg1

opaque fiat_secp256k1_montgomery_to_montgomery_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_to_montgomery` (`secp256k1_montgomery_64.c:1241-1251`): "eval
(from_montgomery out1) mod m = eval arg1 mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_to_montgomery.spec (arg1 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * 2 ^ 256) % m)
  else fiat_secp256k1_montgomery_to_montgomery_unspec arg1

/-- `fiat_secp256k1_montgomery_set_one` (`secp256k1_montgomery_64.c:1861-1869`): "eval
(from_montgomery out1) mod m = 1 mod m", no precondition. -/
def fiat_secp256k1_montgomery_set_one.spec : Vector (BitVec 64) 4 :=
  limbsOfNat 4 (2 ^ 256 % fiat_secp256k1_montgomery_m)

/-! ## `secp256k1_montgomery_scalar_64.c` -/

/-- `m` of `secp256k1_montgomery_scalar_64.c:5`. -/
def fiat_secp256k1_montgomery_scalar_m : Nat :=
  0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141

opaque fiat_secp256k1_montgomery_scalar_mul_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_scalar_mul` (`secp256k1_montgomery_scalar_64.c:157-167`): "eval
(from_montgomery out1) mod m = (eval (from_montgomery arg1) * eval (from_montgomery arg2)) mod
m", pre `eval arg1 < m`, `eval arg2 < m`. -/
def fiat_secp256k1_montgomery_scalar_mul.spec (arg1 arg2 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_scalar_m
  if limbsEval arg1 < m ∧ limbsEval arg2 < m then
    limbsOfNat 4 ((limbsEval arg1 * limbsEval arg2 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_scalar_mul_unspec arg1 arg2

opaque fiat_secp256k1_montgomery_scalar_square_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_scalar_square` (`secp256k1_montgomery_scalar_64.c:513-522`):
"eval (from_montgomery out1) mod m = (eval (from_montgomery arg1) * eval (from_montgomery arg1))
mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_scalar_square.spec (arg1 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_scalar_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * limbsEval arg1 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_scalar_square_unspec arg1

opaque fiat_secp256k1_montgomery_scalar_opp_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_scalar_opp` (`secp256k1_montgomery_scalar_64.c:965-974`): "eval
(from_montgomery out1) mod m = -eval (from_montgomery arg1) mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_scalar_opp.spec (arg1 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_scalar_m
  if limbsEval arg1 < m then limbsOfNat 4 ((-(limbsEval arg1 : Int)) % (m : Int)).toNat
  else fiat_secp256k1_montgomery_scalar_opp_unspec arg1

opaque fiat_secp256k1_montgomery_scalar_from_montgomery_unspec :
  (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_scalar_from_montgomery` (`secp256k1_montgomery_scalar_64.c:
1008-1017`): "eval out1 mod m = (eval arg1 * ((2^64)⁻¹ mod m)^4) mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_scalar_from_montgomery.spec (arg1 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_scalar_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * fiat_Rinv m) % m)
  else fiat_secp256k1_montgomery_scalar_from_montgomery_unspec arg1

opaque fiat_secp256k1_montgomery_scalar_to_montgomery_unspec :
  (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `fiat_secp256k1_montgomery_scalar_to_montgomery` (`secp256k1_montgomery_scalar_64.c:
1242-1251`): "eval (from_montgomery out1) mod m = eval arg1 mod m", pre `eval arg1 < m`. -/
def fiat_secp256k1_montgomery_scalar_to_montgomery.spec (arg1 : Vector (BitVec 64) 4) :
    Vector (BitVec 64) 4 :=
  let m := fiat_secp256k1_montgomery_scalar_m
  if limbsEval arg1 < m then limbsOfNat 4 ((limbsEval arg1 * 2 ^ 256) % m)
  else fiat_secp256k1_montgomery_scalar_to_montgomery_unspec arg1

/-- `fiat_secp256k1_montgomery_scalar_set_one` (`secp256k1_montgomery_scalar_64.c:1922-1929`):
"eval (from_montgomery out1) mod m = 1 mod m", no precondition. -/
def fiat_secp256k1_montgomery_scalar_set_one.spec : Vector (BitVec 64) 4 :=
  limbsOfNat 4 (2 ^ 256 % fiat_secp256k1_montgomery_scalar_m)

end

end Firedancer.Secp256k1

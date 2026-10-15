module

public import Firedancer.Secp256k1.Bits

/-! The s2n-bignum routines `fd_secp256k1_s2n.c` calls, modelled by their documented contracts
(the banner of each `third_party/s2n-bignum/{x86,arm}/…/<name>.S` and `include/s2n-bignum.h`).
Each model is the contract value when its precondition holds, and an opaque `<name>_unspec` of
the inputs otherwise. Results stated as `… mod m` are the canonical representative in `[0, m)`. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-- `p_256k1 = 2^256 - 2^32 - 977`. -/
def p_256k1 : Nat := 2 ^ 256 - 2 ^ 32 - 977

/-- `n_256k1`, the secp256k1 group order. -/
def n_256k1 : Nat := 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141

/-! ## Fixed-size `p_256k1` and `n_256k1` routines

Every input limb is loaded before the first store to `z` (x86 and arm), so `z` may alias an
input; no contract restricts aliasing. -/

opaque bignum_add_p256k1_unspec : (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_add_p256k1` (`{x86,arm}/secp256k1/bignum_add_p256k1.S:5`): "z := (x + y) mod
p_256k1, assuming x and y reduced". -/
def bignum_add_p256k1.spec (x y : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x < p_256k1 ∧ limbsEval y < p_256k1 then
    limbsOfNat 4 ((limbsEval x + limbsEval y) % p_256k1)
  else bignum_add_p256k1_unspec x y

opaque bignum_sub_p256k1_unspec : (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_sub_p256k1` (`include/s2n-bignum.h:832`; the `.S:5` banner omits the assumption):
"z := (x - y) mod p_256k1, assuming x and y reduced". -/
def bignum_sub_p256k1.spec (x y : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x < p_256k1 ∧ limbsEval y < p_256k1 then
    limbsOfNat 4 (((limbsEval x : Int) - limbsEval y) % (p_256k1 : Int)).toNat
  else bignum_sub_p256k1_unspec x y

opaque bignum_double_p256k1_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_double_p256k1` (`{x86,arm}/secp256k1/bignum_double_p256k1.S:5`): "z := (2 * x) mod
p_256k1, assuming x reduced". -/
def bignum_double_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x < p_256k1 then limbsOfNat 4 ((2 * limbsEval x) % p_256k1)
  else bignum_double_p256k1_unspec x

opaque bignum_neg_p256k1_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_neg_p256k1` (`{x86,arm}/secp256k1/bignum_neg_p256k1.S:5`): "z := (-x) mod p_256k1,
assuming x reduced". -/
def bignum_neg_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x < p_256k1 then limbsOfNat 4 ((-(limbsEval x : Int)) % (p_256k1 : Int)).toNat
  else bignum_neg_p256k1_unspec x

/-- `bignum_triple_p256k1` (`{x86,arm}/secp256k1/bignum_triple_p256k1.S:5-10`): "z := (3 * x)
mod p_256k1"; "x can be any 4-digit bignum". -/
def bignum_triple_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  limbsOfNat 4 ((3 * limbsEval x) % p_256k1)

/-- `bignum_triple_p256k1_alt` (`x86/secp256k1/bignum_triple_p256k1_alt.S:5-10`; an alias of
`bignum_triple_p256k1` on arm): "z := (3 * x) mod p_256k1"; "x can be any 4-digit bignum". -/
def bignum_triple_p256k1_alt.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  limbsOfNat 4 ((3 * limbsEval x) % p_256k1)

/-- `bignum_tomont_p256k1` (`{x86,arm}/secp256k1/bignum_tomont_p256k1.S:5`): "z := (2^256 * x)
mod p_256k1", no assumption. -/
def bignum_tomont_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  limbsOfNat 4 ((2 ^ 256 * limbsEval x) % p_256k1)

/-- `bignum_tomont_p256k1_alt` (`x86/secp256k1/bignum_tomont_p256k1_alt.S:5`; an alias of
`bignum_tomont_p256k1` on arm): "z := (2^256 * x) mod p_256k1", no assumption. -/
def bignum_tomont_p256k1_alt.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  limbsOfNat 4 ((2 ^ 256 * limbsEval x) % p_256k1)

opaque bignum_demont_p256k1_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_demont_p256k1` (`{x86,arm}/secp256k1/bignum_demont_p256k1.S:5-10`): "z := (x /
2^256) mod p_256k1, assuming x reduced"; "assumes the input is < p_256k1 for correctness". -/
def bignum_demont_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x < p_256k1 then limbsOfNat 4 ((limbsEval x * invMod (2 ^ 256) p_256k1) % p_256k1)
  else bignum_demont_p256k1_unspec x

opaque bignum_montmul_p256k1_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_montmul_p256k1` (`x86/secp256k1/bignum_montmul_p256k1.S:5-12`): "z := (2^{-256} * x *
y) mod p_256k1, assuming that the inputs x and y satisfy x * y <= 2^256 * p_256k2" (sic:
`p_256k1` in the arm banner and the s2n-bignum.h comment). -/
def bignum_montmul_p256k1.spec (x y : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x * limbsEval y ≤ 2 ^ 256 * p_256k1 then
    limbsOfNat 4 ((limbsEval x * limbsEval y * invMod (2 ^ 256) p_256k1) % p_256k1)
  else bignum_montmul_p256k1_unspec x y

opaque bignum_montmul_p256k1_alt_unspec :
  (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_montmul_p256k1_alt` (`{x86,arm}/secp256k1/bignum_montmul_p256k1_alt.S:5-12`): "z :=
(2^{-256} * x * y) mod p_256k1, assuming that the inputs x and y satisfy x * y <= 2^256 *
p_256k1" (`p_256k2` in the x86 banner). -/
def bignum_montmul_p256k1_alt.spec (x y : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x * limbsEval y ≤ 2 ^ 256 * p_256k1 then
    limbsOfNat 4 ((limbsEval x * limbsEval y * invMod (2 ^ 256) p_256k1) % p_256k1)
  else bignum_montmul_p256k1_alt_unspec x y

opaque bignum_montsqr_p256k1_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_montsqr_p256k1` (`x86/secp256k1/bignum_montsqr_p256k1.S:5-10`): "z := (x^2 / 2^256)
mod p_256k1, assuming x^2 <= 2^256 * p_256k1". -/
def bignum_montsqr_p256k1.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x ^ 2 ≤ 2 ^ 256 * p_256k1 then
    limbsOfNat 4 ((limbsEval x ^ 2 * invMod (2 ^ 256) p_256k1) % p_256k1)
  else bignum_montsqr_p256k1_unspec x

opaque bignum_montsqr_p256k1_alt_unspec : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4

/-- `bignum_montsqr_p256k1_alt` (`{x86,arm}/secp256k1/bignum_montsqr_p256k1_alt.S:5-10`): "z :=
(x^2 / 2^256) mod p_256k1, assuming x^2 <= 2^256 * p_256k1". -/
def bignum_montsqr_p256k1_alt.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  if limbsEval x ^ 2 ≤ 2 ^ 256 * p_256k1 then
    limbsOfNat 4 ((limbsEval x ^ 2 * invMod (2 ^ 256) p_256k1) % p_256k1)
  else bignum_montsqr_p256k1_alt_unspec x

/-- `bignum_mod_n256k1_4` (`{x86,arm}/secp256k1/bignum_mod_n256k1_4.S:5`): "z := x mod n_256k1",
no assumption. -/
def bignum_mod_n256k1_4.spec (x : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  limbsOfNat 4 (limbsEval x % n_256k1)

/-! ## Generic `k`-limb routines

These take the `k` the C passes. Their banners say nothing about aliasing; the `Bool` arguments
say whether the call site's buffers overlap, and the preconditions forbid the overlaps that are
not known to be safe (see `TRANSLATION.md`). -/

opaque bignum_montmul_unspec : (k : BitVec 64) → (Vector (BitVec 64) k.toNat) →
  (Vector (BitVec 64) k.toNat) → (Vector (BitVec 64) k.toNat) → Bool → Vector (BitVec 64) k.toNat

/-- `bignum_montmul` (`{x86,arm}/generic/bignum_montmul.S:5-12`): "z := (x * y / 2^{64k}) mod m,
assuming x * y <= 2^{64k} * m"; also `m` odd (else `2^{-64k} mod m` does not exist) and `z`
disjoint from `x`, `y`, `m` (`zOverlap`; the loop stores to `z` while reading `x`). -/
def bignum_montmul.spec (k : BitVec 64) (x y m : Vector (BitVec 64) k.toNat) (zOverlap : Bool) :
    Vector (BitVec 64) k.toNat :=
  if limbsEval x * limbsEval y ≤ 2 ^ (64 * k.toNat) * limbsEval m ∧ limbsEval m % 2 = 1 ∧
      zOverlap = false then
    limbsOfNat k.toNat
      ((limbsEval x * limbsEval y * invMod (2 ^ (64 * k.toNat)) (limbsEval m)) % limbsEval m)
  else bignum_montmul_unspec k x y m zOverlap

opaque bignum_demont_unspec : (k : BitVec 64) → (Vector (BitVec 64) k.toNat) →
  (Vector (BitVec 64) k.toNat) → Bool → Vector (BitVec 64) k.toNat

/-- `bignum_demont` (`{x86,arm}/generic/bignum_demont.S:5-13`): "z := (x / 2^{64k}) mod m"; "can
handle almost-Montgomery inputs, i.e. any k-digit bignum"; also `m` odd and `z` disjoint from
`m` (`zmOverlap`). `z = x` is safe: `x` is copied to `z` before any other store. -/
def bignum_demont.spec (k : BitVec 64) (x m : Vector (BitVec 64) k.toNat) (zmOverlap : Bool) :
    Vector (BitVec 64) k.toNat :=
  if limbsEval m % 2 = 1 ∧ zmOverlap = false then
    limbsOfNat k.toNat ((limbsEval x * invMod (2 ^ (64 * k.toNat)) (limbsEval m)) % limbsEval m)
  else bignum_demont_unspec k x m zmOverlap

opaque bignum_modinv_unspec : (k : BitVec 64) → (Vector (BitVec 64) k.toNat) →
  (Vector (BitVec 64) k.toNat) → Nat → Bool → Vector (BitVec 64) k.toNat

/-- `bignum_modinv` (`{x86,arm}/generic/bignum_modinv.S:5-11`): "z = (1/a) mod b, assuming b is
an odd number > 1, coprime a", with "temporary buffer t[>=3*k]" (`tWords` words); also `z` and
`t` disjoint from each other and from `a`, `b` (`overlap`). The model is the output `z`; `t` is
scratch. -/
def bignum_modinv.spec (k : BitVec 64) (a b : Vector (BitVec 64) k.toNat) (tWords : Nat)
    (overlap : Bool) : Vector (BitVec 64) k.toNat :=
  if limbsEval b % 2 = 1 ∧ 1 < limbsEval b ∧ Nat.gcd (limbsEval a) (limbsEval b) = 1 ∧
      3 * k.toNat ≤ tWords ∧ overlap = false then
    limbsOfNat k.toNat (invMod (limbsEval a) (limbsEval b))
  else bignum_modinv_unspec k a b tWords overlap

/-- What `bignum_sub` produces: the limbs stored at `z` and the returned borrow. -/
structure bignum_sub.Result (p : BitVec 64) where
  z : Vector (BitVec 64) p.toNat
  ret : BitVec 64

/-- `bignum_sub` (`{x86,arm}/generic/bignum_sub.S:5-12`): "z := x - y … truncating modulo p words
in general and returning a top borrow (0 or 1) in the p'th place, only subtracting input words
below p (as well as m and n respectively)"; no assumption. -/
def bignum_sub.spec (p m : BitVec 64) (x : Vector (BitVec 64) m.toNat) (n : BitVec 64)
    (y : Vector (BitVec 64) n.toNat) : bignum_sub.Result p :=
  let xs := limbsEval x % 2 ^ (64 * min p.toNat m.toNat)
  let ys := limbsEval y % 2 ^ (64 * min p.toNat n.toNat)
  ⟨limbsOfNat p.toNat (((xs : Int) - ys) % (2 ^ (64 * p.toNat) : Int)).toNat,
    if xs < ys then 1#64 else 0#64⟩

end

end Firedancer.Secp256k1

module

public import Firedancer.Bn254.Bits

/-! s2n-bignum's `bignum_modinv`, called by `fd_bn254_fp_inv` under `FD_HAS_S2NBIGNUM`, modelled by
its contract: `BIGNUM_MODINV_SUBROUTINE_CORRECT` in upstream's `{x86,arm}/proofs/bignum_modinv.ml`
at cba3956 (vendored in `~/fd-specs/ref-crates/s2n-bignum/{x86,arm}/`). -/

namespace Firedancer.Bn254

@[expose] public section

opaque bignum_modinv_unspec : (k : BitVec 64) → (Vector (BitVec 64) k.toNat) →
  (Vector (BitVec 64) k.toNat) → Nat → Bool → Vector (BitVec 64) k.toNat

/-- `bignum_modinv(k, z, a, b, t)` (`{x86,arm}/generic/bignum_modinv.S:5-13`): the `z` it stores.
The HOL spec assumes `k < 2^57`, `t` of `3k` words (`tWords`) and `z`, `t` disjoint from each other
and from `a`, `b` (`overlap`); under `coprime(a, b) ∧ ODD b ∧ b ≠ 1` it gives `z < b` and
`a·z ≡ 1 (mod b)`, the canonical inverse. `a < b` is not required. `t` is scratch. -/
def bignum_modinv.spec (k : BitVec 64) (a b : Vector (BitVec 64) k.toNat) (tWords : Nat)
    (overlap : Bool) : Vector (BitVec 64) k.toNat :=
  if Nat.gcd (limbsEval a) (limbsEval b) = 1 ∧ limbsEval b % 2 = 1 ∧ limbsEval b ≠ 1 ∧
      3 * k.toNat ≤ tWords ∧ k.toNat < 2 ^ 57 ∧ overlap = false then
    limbsOfNat k.toNat (invMod (limbsEval a) (limbsEval b))
  else bignum_modinv_unspec k a b tWords overlap

end

end Firedancer.Bn254

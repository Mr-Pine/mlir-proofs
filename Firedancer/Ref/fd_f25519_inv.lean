module

public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_pow22523
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_frombytes
public import Mathlib.Data.Int.GCD

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

open fd_f25519_pow22523 in
/-- `fd_f25519_inv` (`ballet/ed25519/fd_f25519.c:100`, `FD_HAS_S2NBIGNUM` unset). -/
def fd_f25519_inv.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let t0 := fd_f25519_sqr.spec a
  let t1 := fd_f25519_sqr.spec t0
  let t1 := fd_f25519_sqr.spec t1
  let t1 := fd_f25519_mul.spec a t1
  let t0 := fd_f25519_mul.spec t0 t1
  let t2 := fd_f25519_sqr.spec t0
  let t1 := fd_f25519_mul.spec t1 t2
  let t2 := fd_f25519_sqr.spec t1
  let t2 := sqrN 4 t2 -- for( int i=1; i<  5; i++ )
  let t1 := fd_f25519_mul.spec t2 t1
  let t2 := fd_f25519_sqr.spec t1
  let t2 := sqrN 9 t2 -- for( int i=1; i< 10; i++ )
  let t2 := fd_f25519_mul.spec t2 t1
  let t3 := fd_f25519_sqr.spec t2
  let t3 := sqrN 19 t3 -- for( int i=1; i< 20; i++ )
  let t2 := fd_f25519_mul.spec t3 t2
  let t2 := sqrN 10 t2 -- for( int i=0; i< 10; i++ )
  let t1 := fd_f25519_mul.spec t2 t1
  let t2 := fd_f25519_sqr.spec t1
  let t2 := sqrN 49 t2 -- for( int i=1; i< 50; i++ )
  let t2 := fd_f25519_mul.spec t2 t1
  let t3 := fd_f25519_sqr.spec t2
  let t3 := sqrN 99 t3 -- for( int i=1; i<100; i++ )
  let t2 := fd_f25519_mul.spec t3 t2
  let t2 := fd_f25519_sqr.spec t2
  let t2 := sqrN 49 t2 -- for( int i=1; i< 50; i++ )
  let t1 := fd_f25519_mul.spec t2 t1
  let t1 := fd_f25519_sqr.spec t1
  let t1 := sqrN 4 t1 -- for( int i=1; i<  5; i++ )
  fd_f25519_mul.spec t1 t0

/-- `p_25519 = 2^255 - 19`. -/
def p_25519 : Nat :=
  2 ^ 255 - 19

/-- `bignum_inv_p25519` by s2n-bignum's `BIGNUM_INV_P25519_SUBROUTINE_CORRECT` (`cba3956c`): `0` if
`p_25519 ∣ x`, else `x⁻¹ mod p_25519`. -/
def bignum_inv_p25519.spec (x : BitVec 256) : BitVec 256 :=
  if p_25519 ∣ x.toNat then 0#256
  else BitVec.ofNat 256 (Nat.gcdA x.toNat p_25519 % (p_25519 : Int)).toNat

/-- `fd_f25519_inv` (`ballet/ed25519/fd_f25519.c:86`, `FD_HAS_S2NBIGNUM` set); `fd_msan_unpoison`
is a no-op. -/
def fd_f25519_inv.s2n (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let x := fd_f25519_tobytes.spec a
  let z := bignum_inv_p25519.spec x
  fd_f25519_frombytes.spec z

end

end MLIR.Firedancer.Ref

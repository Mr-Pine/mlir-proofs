module

public import Firedancer.Secp256k1.Private
public import Firedancer.Secp256k1.Fiat

/-! `fd_secp256k1_ref.c`, the portable backend (no `FD_HAS_S2NBIGNUM`), and the helpers of
`ballet/pcurves/fd_pcurve_ref_util.h` it instantiates. Every fiat function reads all its inputs
before storing `out1`, so in-place calls are plain calls. -/

namespace Firedancer.Secp256k1.Ref

@[expose] public section

/-! ## `fd_pcurve_ref_util.h` -/

/-- `fd_pcurve_ref_reduce_once` (`ballet/pcurves/fd_pcurve_ref_util.h:20`) with the `n = 4UL` of
its only call site, both loops unrolled: `a >= m ? a - m : a`. `r[i]` is stored after `a[i]` is
read, so `r` may alias `a`. -/
def fd_pcurve_ref_reduce_once.spec (a m : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let borrow : BitVec 64 := 0
  -- i = 0
  let ai := a[0]
  let mi := m[0]
  let d0 := ai - mi
  let b0 : BitVec 64 := if ai < mi then 1 else 0
  let d1 := d0 - borrow
  let b1 : BitVec 64 := if d0 < borrow then 1 else 0
  let t0 := d1
  let borrow := b0 ||| b1
  -- i = 1
  let ai := a[1]
  let mi := m[1]
  let d0 := ai - mi
  let b0 : BitVec 64 := if ai < mi then 1 else 0
  let d1 := d0 - borrow
  let b1 : BitVec 64 := if d0 < borrow then 1 else 0
  let t1 := d1
  let borrow := b0 ||| b1
  -- i = 2
  let ai := a[2]
  let mi := m[2]
  let d0 := ai - mi
  let b0 : BitVec 64 := if ai < mi then 1 else 0
  let d1 := d0 - borrow
  let b1 : BitVec 64 := if d0 < borrow then 1 else 0
  let t2 := d1
  let borrow := b0 ||| b1
  -- i = 3
  let ai := a[3]
  let mi := m[3]
  let d0 := ai - mi
  let b0 : BitVec 64 := if ai < mi then 1 else 0
  let d1 := d0 - borrow
  let b1 : BitVec 64 := if d0 < borrow then 1 else 0
  let t3 := d1
  let borrow := b0 ||| b1
  -- r[ i ] = fd_ulong_if( (int)borrow, a[ i ], t[ i ] );
  #v[fd_ulong_if.spec (borrow.setWidth 32) a[0] t0, fd_ulong_if.spec (borrow.setWidth 32) a[1] t1,
    fd_ulong_if.spec (borrow.setWidth 32) a[2] t2, fd_ulong_if.spec (borrow.setWidth 32) a[3] t3]

/-- The function `FD_PCURVE_REF_DEFINE_POW( fn, 4, mul, sqr, set_one )` defines
(`ballet/pcurves/fd_pcurve_ref_util.h:50`): `a^e` by a 4-bit window, MSB first. The table loop is
unrolled. In the main loop `long i` runs `252, 248, …, 0`, nonnegative in the body, so its `/`
and `%` are the natural ones. `r` is stored last, so it may alias `a`. -/
def fd_pcurve_ref_pow.spec (mul : (Vector (BitVec 64) 4) → (Vector (BitVec 64) 4) → Vector (BitVec 64) 4)
    (sqr : (Vector (BitVec 64) 4) → Vector (BitVec 64) 4) (set_one : Vector (BitVec 64) 4)
    (a e : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let tbl0 := set_one
  -- memcpy( tbl[ 1 ], a, sizeof(ulong)*(n) );
  let tbl1 := a
  -- for( ulong i=2UL; i<16UL; i++ ) mul( tbl[ i ], tbl[ i-1UL ], a );
  let tbl2 := mul tbl1 a
  let tbl3 := mul tbl2 a
  let tbl4 := mul tbl3 a
  let tbl5 := mul tbl4 a
  let tbl6 := mul tbl5 a
  let tbl7 := mul tbl6 a
  let tbl8 := mul tbl7 a
  let tbl9 := mul tbl8 a
  let tbl10 := mul tbl9 a
  let tbl11 := mul tbl10 a
  let tbl12 := mul tbl11 a
  let tbl13 := mul tbl12 a
  let tbl14 := mul tbl13 a
  let tbl15 := mul tbl14 a
  let tbl : Vector (Vector (BitVec 64) 4) 16 :=
    #v[tbl0, tbl1, tbl2, tbl3, tbl4, tbl5, tbl6, tbl7, tbl8, tbl9, tbl10, tbl11, tbl12, tbl13,
      tbl14, tbl15]
  let acc := set_one
  -- for( long i=(long)((n)*64UL)-4L; i>=0L; i-=4L ), the k-th iteration
  let acc := Nat.fold 64 (fun k _ acc =>
    let i := 252 - 4 * k
    let acc := sqr acc
    let acc := sqr acc
    let acc := sqr acc
    let acc := sqr acc
    let d := (e[i / 64]'(by omega) >>> (i % 64)) &&& 15#64
    mul acc (tbl[d.toNat]'(by
      simp only [d, BitVec.toNat_and]; exact Nat.lt_of_le_of_lt Nat.and_le_right (by decide))))
    acc
  -- memcpy( r, acc, sizeof(ulong)*(n) );
  acc

/-! ## `fd_secp256k1_ref.c` -/

/-- `fd_secp256k1_const_p_m2` (`fd_secp256k1_ref.c:18`), `p - 2`. -/
def fd_secp256k1_const_p_m2 : Vector (BitVec 64) 4 :=
  #v[0xfffffffefffffc2d, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff]

/-- `fd_secp256k1_const_n_m2` (`fd_secp256k1_ref.c:23`), `n - 2`. -/
def fd_secp256k1_const_n_m2 : Vector (BitVec 64) 4 :=
  #v[0xbfd25e8cd036413f, 0xbaaedce6af48a03b, 0xfffffffffffffffe, 0xffffffffffffffff]

/-- `fd_secp256k1_fp_pow_limbs` (`fd_secp256k1_ref.c:27`). -/
def fd_secp256k1_fp_pow_limbs.spec (a e : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  fd_pcurve_ref_pow.spec fiat_secp256k1_montgomery_mul.spec fiat_secp256k1_montgomery_square.spec
    fiat_secp256k1_montgomery_set_one.spec a e

/-- `fd_secp256k1_scalar_pow_limbs` (`fd_secp256k1_ref.c:31`). -/
def fd_secp256k1_scalar_pow_limbs.spec (a e : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  fd_pcurve_ref_pow.spec fiat_secp256k1_montgomery_scalar_mul.spec
    fiat_secp256k1_montgomery_scalar_square.spec fiat_secp256k1_montgomery_scalar_set_one.spec a e

/-! ### Scalars -/

/-- `fd_secp256k1_scalar_is_zero` (`fd_secp256k1_ref.c:39`). -/
def fd_secp256k1_scalar_is_zero.spec (r : fd_secp256k1_scalar_t) : BitVec 32 :=
  fd_uint256_eq.spec r fd_secp256k1_const_zero

/-- `fd_secp256k1_scalar_frombytes` (`fd_secp256k1_ref.c:45`): `r` is written before either check,
so it is stored on the `NULL` paths too. -/
def fd_secp256k1_scalar_frombytes.spec (input : Vector (BitVec 8) 32) :
    fd_secp256k1_scalar_frombytes.Result :=
  -- memcpy( r, input, 32 );
  let r := fd_uint256_t.ofBuf input
  let r := fd_uint256_bswap.spec r
  if (0#32).sle (fd_uint256_cmp.spec r fd_secp256k1_const_n) then ⟨r, none⟩ else
  if fd_secp256k1_scalar_is_zero.spec r ≠ 0#32 then ⟨r, none⟩ else
  ⟨r, some r⟩

/-- `fd_secp256k1_scalar_reduce` (`fd_secp256k1_ref.c:67`). -/
def fd_secp256k1_scalar_reduce.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  fd_pcurve_ref_reduce_once.spec a fd_secp256k1_const_n

/-- `fd_secp256k1_scalar_invert` (`fd_secp256k1_ref.c:77`). -/
def fd_secp256k1_scalar_invert.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  let t := fiat_secp256k1_montgomery_scalar_to_montgomery.spec a
  let t := fd_secp256k1_scalar_pow_limbs.spec t fd_secp256k1_const_n_m2
  fiat_secp256k1_montgomery_scalar_from_montgomery.spec t

/-- `fd_secp256k1_scalar_mul` (`fd_secp256k1_ref.c:88`). -/
def fd_secp256k1_scalar_mul.spec (a b : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  fiat_secp256k1_montgomery_scalar_mul.spec a b

/-- `fd_secp256k1_scalar_negate` (`fd_secp256k1_ref.c:98`). -/
def fd_secp256k1_scalar_negate.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  fiat_secp256k1_montgomery_scalar_opp.spec a

/-- `fd_secp256k1_scalar_tomont` (`fd_secp256k1_ref.c:105`). -/
def fd_secp256k1_scalar_tomont.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  fiat_secp256k1_montgomery_scalar_to_montgomery.spec a

/-- `fd_secp256k1_scalar_demont` (`fd_secp256k1_ref.c:112`). -/
def fd_secp256k1_scalar_demont.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  fiat_secp256k1_montgomery_scalar_from_montgomery.spec a

/-! ### Field -/

/-- `fd_secp256k1_fp_set` (`fd_secp256k1_ref.c:121`), limb by limb. -/
def fd_secp256k1_fp_set.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  #v[a[0], a[1], a[2], a[3]]

/-- `fd_secp256k1_fp_eq` (`fd_secp256k1_ref.c:132`). -/
def fd_secp256k1_fp_eq.spec (a b : fd_secp256k1_fp_t) : BitVec 32 :=
  fd_uint256_eq.spec a b

/-- `fd_secp256k1_fp_add` (`fd_secp256k1_ref.c:139`). -/
def fd_secp256k1_fp_add.spec (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_add.spec a b

/-- `fd_secp256k1_fp_sub` (`fd_secp256k1_ref.c:148`). -/
def fd_secp256k1_fp_sub.spec (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_sub.spec a b

/-- `fd_secp256k1_fp_dbl` (`fd_secp256k1_ref.c:157`). -/
def fd_secp256k1_fp_dbl.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_add.spec a a

/-- `fd_secp256k1_fp_triple` (`fd_secp256k1_ref.c:165`). -/
def fd_secp256k1_fp_triple.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  let t := fiat_secp256k1_montgomery_add.spec a a
  fiat_secp256k1_montgomery_add.spec t a

/-- `fd_secp256k1_fp_mul` (`fd_secp256k1_ref.c:175`). -/
def fd_secp256k1_fp_mul.spec (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_mul.spec a b

/-- `fd_secp256k1_fp_sqr` (`fd_secp256k1_ref.c:184`). -/
def fd_secp256k1_fp_sqr.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_square.spec a

/-- `fd_secp256k1_fp_negate` (`fd_secp256k1_ref.c:192`). -/
def fd_secp256k1_fp_negate.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_opp.spec a

/-- `fd_secp256k1_fp_is_odd` (`fd_secp256k1_ref.c:199`): the `ulong` `scratch[0] & 1` converted to
the `int` return. -/
def fd_secp256k1_fp_is_odd.spec (r : fd_secp256k1_fp_t) : BitVec 32 :=
  let scratch := fiat_secp256k1_montgomery_from_montgomery.spec r
  (scratch[0] &&& 1#64).setWidth 32

/-- `fd_secp256k1_fp_invert` (`fd_secp256k1_ref.c:208`). -/
def fd_secp256k1_fp_invert.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fd_secp256k1_fp_pow_limbs.spec a fd_secp256k1_const_p_m2

/-- `fd_secp256k1_fp_tomont` (`fd_secp256k1_ref.c:216`). -/
def fd_secp256k1_fp_tomont.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  fiat_secp256k1_montgomery_to_montgomery.spec a

/-- `fd_secp256k1_fp_tobytes` (`fd_secp256k1_ref.c:223`): the 32 bytes stored at `r`. -/
def fd_secp256k1_fp_tobytes.spec (a : fd_secp256k1_fp_t) : Vector (BitVec 8) 32 :=
  let swapped := fiat_secp256k1_montgomery_from_montgomery.spec a
  let swapped := fd_uint256_bswap.spec swapped
  -- memcpy( r, swapped->buf, 32 );
  swapped.buf

/-- The fiat-crypto backend. -/
def backend : Backend where
  scalar_frombytes := fd_secp256k1_scalar_frombytes.spec
  scalar_reduce := fd_secp256k1_scalar_reduce.spec
  scalar_invert := fd_secp256k1_scalar_invert.spec
  scalar_mul := fd_secp256k1_scalar_mul.spec
  scalar_negate := fd_secp256k1_scalar_negate.spec
  scalar_tomont := fd_secp256k1_scalar_tomont.spec
  scalar_demont := fd_secp256k1_scalar_demont.spec
  fp_set := fd_secp256k1_fp_set.spec
  fp_eq := fd_secp256k1_fp_eq.spec
  fp_add := fd_secp256k1_fp_add.spec
  fp_sub := fd_secp256k1_fp_sub.spec
  fp_dbl := fd_secp256k1_fp_dbl.spec
  fp_triple := fd_secp256k1_fp_triple.spec
  fp_mul := fd_secp256k1_fp_mul.spec
  fp_sqr := fd_secp256k1_fp_sqr.spec
  fp_negate := fd_secp256k1_fp_negate.spec
  fp_is_odd := fd_secp256k1_fp_is_odd.spec
  fp_invert := fd_secp256k1_fp_invert.spec
  fp_tomont := fd_secp256k1_fp_tomont.spec
  fp_tobytes := fd_secp256k1_fp_tobytes.spec

end

end Firedancer.Secp256k1.Ref

module

public import Firedancer.Secp256k1.Private
public import Firedancer.Secp256k1.S2n

/-! `fd_secp256k1_s2n.c`, the s2n-bignum backend (`FD_HAS_S2NBIGNUM`). `adx` is whether
`__ADX__` is defined: when it is not (pre-Broadwell x86, every arm build), lines 8-13 redirect
`bignum_{montmul,montsqr,tomont,triple}_p256k1` to their `_alt` variants. `fd_msan_unpoison` is a
no-op outside MSan builds (`util/sanitize/fd_msan.h:72`) and is left out. -/

namespace Firedancer.Secp256k1.S2n

@[expose] public section

/-! ## Scalars -/

/-- `fd_secp256k1_scalar_is_zero` (`fd_secp256k1_s2n.c:18`). -/
def fd_secp256k1_scalar_is_zero.spec (r : fd_secp256k1_scalar_t) : BitVec 32 :=
  fd_uint256_eq.spec r fd_secp256k1_const_zero

/-- `fd_secp256k1_scalar_frombytes` (`fd_secp256k1_s2n.c:24`): `r` is written before either check,
so it is stored on the `NULL` paths too. -/
def fd_secp256k1_scalar_frombytes.spec (input : Vector (BitVec 8) 32) :
    fd_secp256k1_scalar_frombytes.Result :=
  -- memcpy( r, input, 32 );
  let r := fd_uint256_t.ofBuf input
  let r := fd_uint256_bswap.spec r
  if (0#32).sle (fd_uint256_cmp.spec r fd_secp256k1_const_n) then ⟨r, none⟩ else
  if fd_secp256k1_scalar_is_zero.spec r ≠ 0#32 then ⟨r, none⟩ else
  ⟨r, some r⟩

/-- `fd_secp256k1_scalar_invert` (`fd_secp256k1_s2n.c:48`): `t[12]` is the scratch buffer; `r` and
`a` are distinct at the only call site. -/
def fd_secp256k1_scalar_invert.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  bignum_modinv.spec 4 a fd_secp256k1_const_n 12 false

/-- `fd_secp256k1_scalar_mul` (`fd_secp256k1_s2n.c:58`): the arguments are `restrict`. -/
def fd_secp256k1_scalar_mul.spec (a b : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  bignum_montmul.spec 4 a b fd_secp256k1_const_n false

/-- `fd_secp256k1_scalar_negate` (`fd_secp256k1_s2n.c:68`): the borrow of `bignum_sub` is
dropped. -/
def fd_secp256k1_scalar_negate.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  let t := (bignum_sub.spec 4 4 fd_secp256k1_const_n 4 a).z
  bignum_mod_n256k1_4.spec t

/-- `fd_secp256k1_scalar_tomont` (`fd_secp256k1_s2n.c:87`): `a` is copied to the local `t`, so
`bignum_montmul`'s output is disjoint from its inputs even when `r` aliases `a`. -/
def fd_secp256k1_scalar_tomont.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  -- memcpy( t, a->limbs, 32 );
  let t := a
  bignum_montmul.spec 4 t fd_secp256k1_const_scalar_rr_mont fd_secp256k1_const_n false

/-- `fd_secp256k1_scalar_demont` (`fd_secp256k1_s2n.c:99`): `r` may alias `a` (it does at both
call sites), never `fd_secp256k1_const_n`. -/
def fd_secp256k1_scalar_demont.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  bignum_demont.spec 4 a fd_secp256k1_const_n false

/-- `fd_secp256k1_scalar_reduce` (`fd_secp256k1_s2n.c:108`). -/
def fd_secp256k1_scalar_reduce.spec (a : fd_secp256k1_scalar_t) : fd_secp256k1_scalar_t :=
  bignum_mod_n256k1_4.spec a

/-! ## Field -/

/-- `fd_secp256k1_fp_set` (`fd_secp256k1_s2n.c:118`), limb by limb. -/
def fd_secp256k1_fp_set.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  #v[a[0], a[1], a[2], a[3]]

/-- `fd_secp256k1_fp_eq` (`fd_secp256k1_s2n.c:129`). -/
def fd_secp256k1_fp_eq.spec (a b : fd_secp256k1_fp_t) : BitVec 32 :=
  fd_uint256_eq.spec a b

/-- `fd_secp256k1_fp_add` (`fd_secp256k1_s2n.c:136`). -/
def fd_secp256k1_fp_add.spec (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  bignum_add_p256k1.spec a b

/-- `fd_secp256k1_fp_sub` (`fd_secp256k1_s2n.c:146`). -/
def fd_secp256k1_fp_sub.spec (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  bignum_sub_p256k1.spec a b

/-- `fd_secp256k1_fp_dbl` (`fd_secp256k1_s2n.c:156`). -/
def fd_secp256k1_fp_dbl.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  bignum_double_p256k1.spec a

/-- `fd_secp256k1_fp_mul` (`fd_secp256k1_s2n.c:165`). -/
def fd_secp256k1_fp_mul.spec (adx : Bool) (a b : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  (if adx then bignum_montmul_p256k1.spec else bignum_montmul_p256k1_alt.spec) a b

/-- `fd_secp256k1_fp_sqr` (`fd_secp256k1_s2n.c:175`). -/
def fd_secp256k1_fp_sqr.spec (adx : Bool) (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  (if adx then bignum_montsqr_p256k1.spec else bignum_montsqr_p256k1_alt.spec) a

/-- `fd_secp256k1_fp_negate` (`fd_secp256k1_s2n.c:184`). -/
def fd_secp256k1_fp_negate.spec (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  bignum_neg_p256k1.spec a

/-- `fd_secp256k1_fp_is_odd` (`fd_secp256k1_s2n.c:192`): the `ulong` `limbs[0] & 1` converted to
the `int` return. -/
def fd_secp256k1_fp_is_odd.spec (r : fd_secp256k1_fp_t) : BitVec 32 :=
  let scratch := bignum_demont_p256k1.spec r
  (scratch[0] &&& 1#64).setWidth 32

/-- `fd_secp256k1_fp_invert` (`fd_secp256k1_s2n.c:202`): `bignum_tomont_p256k1( r, r )` is in
place; `t[12]` is the scratch buffer. -/
def fd_secp256k1_fp_invert.spec (adx : Bool) (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  let ad := bignum_demont_p256k1.spec a
  let r := bignum_modinv.spec 4 ad fd_secp256k1_const_p 12 false
  (if adx then bignum_tomont_p256k1.spec else bignum_tomont_p256k1_alt.spec) r

/-- `fd_secp256k1_fp_tobytes` (`fd_secp256k1_s2n.c:216`): the 32 bytes stored at `r`. -/
def fd_secp256k1_fp_tobytes.spec (a : fd_secp256k1_fp_t) : Vector (BitVec 8) 32 :=
  let swapped := bignum_demont_p256k1.spec a
  let swapped := fd_uint256_bswap.spec swapped
  -- memcpy( r, swapped->buf, 32 );
  swapped.buf

/-- `fd_secp256k1_fp_triple` (`fd_secp256k1_s2n.c:228`). -/
def fd_secp256k1_fp_triple.spec (adx : Bool) (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  (if adx then bignum_triple_p256k1.spec else bignum_triple_p256k1_alt.spec) a

/-- `fd_secp256k1_fp_tomont` (`fd_secp256k1_s2n.c:237`). -/
def fd_secp256k1_fp_tomont.spec (adx : Bool) (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_t :=
  (if adx then bignum_tomont_p256k1.spec else bignum_tomont_p256k1_alt.spec) a

/-- The s2n-bignum backend, with or without `__ADX__`. -/
def backend (adx : Bool) : Backend where
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
  fp_triple := fd_secp256k1_fp_triple.spec adx
  fp_mul := fd_secp256k1_fp_mul.spec adx
  fp_sqr := fd_secp256k1_fp_sqr.spec adx
  fp_negate := fd_secp256k1_fp_negate.spec
  fp_is_odd := fd_secp256k1_fp_is_odd.spec
  fp_invert := fd_secp256k1_fp_invert.spec adx
  fp_tomont := fd_secp256k1_fp_tomont.spec adx
  fp_tobytes := fd_secp256k1_fp_tobytes.spec

end

end Firedancer.Secp256k1.S2n

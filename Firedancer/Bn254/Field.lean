module

public import Firedancer.Bn254.Fiat
public import Firedancer.Bn254.S2n

/-! The base field `Fp` (`fd_bn254_field.c`, `fd_bn254_field_inl.h`, `fd_bn254_internal.h`) as the
G1 code reaches it: Montgomery form with `R = 2^256`, built without `FD_HAS_X86` arithmetic (fiat
`fp_add`/`fp_sub`, C CIOS `fp_mul`). `fd_bn254_fp_inv` has both builds, `.s2n`
(`FD_HAS_S2NBIGNUM`) and `.spec` (`fp_pow( a, p-2 )`). A function writing through `r` returns the
value written. -/

namespace Firedancer.Bn254

@[expose] public section

/-! ## Types -/

/-- `fd_bn254_fp_t` (`fd_bn254_internal.h:8`). -/
abbrev fd_bn254_fp_t := fd_uint256_t

/-- `fd_bn254_scalar_t` (`fd_bn254_scalar.h:25`). -/
abbrev fd_bn254_scalar_t := fd_uint256_t

/-! ## Constants, limbs as in the C -/

/-- `FLAG_INF` (`fd_bn254_field_inl.h:18`). -/
def FLAG_INF : BitVec 8 := 0x40

/-- `FLAG_NEG` (`fd_bn254_field_inl.h:19`). -/
def FLAG_NEG : BitVec 8 := 0x80

/-- `FLAG_MASK` (`fd_bn254_field_inl.h:20`), used only as `uchar &= FLAG_MASK`. -/
def FLAG_MASK : BitVec 8 := 0x3F

/-- `fd_bn254_const_zero` (`fd_bn254_field.c:4`). -/
def fd_bn254_const_zero : fd_bn254_fp_t := #v[0x0, 0x0, 0x0, 0x0]

/-- `fd_bn254_const_one` (`fd_bn254_field.c:9`), not Montgomery. -/
def fd_bn254_const_one : fd_bn254_fp_t := #v[0x1, 0x0, 0x0, 0x0]

/-- `fd_bn254_const_rr` (`fd_bn254_field.c:15`), `R^2 mod p`. -/
def fd_bn254_const_rr : fd_bn254_fp_t :=
  #v[0xf32cfc5b538afa89, 0xb5e71911d44501fb, 0x47ab1eff0a417ff6, 0x06d89f71cab8351f]

/-- `fd_bn254_const_p` (`fd_bn254_field.c:21`), not Montgomery. -/
def fd_bn254_const_p : fd_bn254_fp_t :=
  #v[0x3c208c16d87cfd47, 0x97816a916871ca8d, 0xb85045b68181585d, 0x30644e72e131a029]

/-- `fd_bn254_const_one_mont` (`fd_bn254_field.c:27`). -/
def fd_bn254_const_one_mont : fd_bn254_fp_t :=
  #v[0xd35d438dc58f0d9d, 0x0a78eb28f5c70b3d, 0x666ea36f7879462c, 0x0e0a77c19a07df2f]

/-- `fd_bn254_const_b_mont` (`fd_bn254_field.c:39`), `3` in Montgomery form. -/
def fd_bn254_const_b_mont : fd_bn254_fp_t :=
  #v[0x7a17caa950ad28d7, 0x1f6ac17ae15521b9, 0x334bea4e696bd284, 0x2a1f6744ce179d8e]

/-- `fd_bn254_const_p_minus_one_mont` (`fd_bn254_field.c:46`). -/
def fd_bn254_const_p_minus_one_mont : fd_bn254_fp_t :=
  #v[0x68c3488912edefaa, 0x8d087f6872aabf4f, 0x51e1a24709081231, 0x2259d6b14729c0fa]

/-- `fd_bn254_const_p_minus_one_half` (`fd_bn254_field.c:53`), not Montgomery. -/
def fd_bn254_const_p_minus_one_half : fd_bn254_fp_t :=
  #v[0x9e10460b6c3e7ea3, 0xcbc0b548b438e546, 0xdc2822db40c0ac2e, 0x183227397098d014]

/-- `fd_bn254_const_sqrt_exp` (`fd_bn254_field.c:59`), `(p-3)/4`. -/
def fd_bn254_const_sqrt_exp : fd_uint256_t :=
  #v[0x4f082305b61f3f51, 0x65e05aa45a1c72a3, 0x6e14116da0605617, 0x0c19139cb84c680a]

/-- `fd_bn254_const_p_inv` (`fd_bn254_field_inl.h:39`), `-p⁻¹ mod 2^64`. -/
def fd_bn254_const_p_inv : BitVec 64 := 0x87D20782E4866389

/-- `fd_bn254_const_r` (`fd_bn254_scalar.h:30`), the group order; not used by the G1 path. -/
def fd_bn254_const_r : fd_bn254_scalar_t :=
  #v[0x43e1f593f0000001, 0x2833e84879b97091, 0xb85045b68181585d, 0x30644e72e131a029]

/-! ## `fd_bn254_internal.h` -/

/-- `fd_bn254_fp_is_zero` (`fd_bn254_internal.h:50`). -/
def fd_bn254_fp_is_zero.spec (r : fd_bn254_fp_t) : BitVec 32 :=
  if r[0] = 0 ∧ r[1] = 0 ∧ r[2] = 0 ∧ r[3] = 0 then 1 else 0

/-- `fd_bn254_fp_is_one` (`fd_bn254_internal.h:58`): equal to `fd_bn254_const_one_mont`. -/
def fd_bn254_fp_is_one.spec (r : fd_bn254_fp_t) : BitVec 32 :=
  if r[0] = fd_bn254_const_one_mont[0] ∧ r[1] = fd_bn254_const_one_mont[1] ∧
      r[2] = fd_bn254_const_one_mont[2] ∧ r[3] = fd_bn254_const_one_mont[3] then 1 else 0

/-- `fd_bn254_fp_set_zero` (`fd_bn254_internal.h:66`). -/
def fd_bn254_fp_set_zero.spec : fd_bn254_fp_t := #v[0, 0, 0, 0]

/-- `fd_bn254_fp_set_one` (`fd_bn254_internal.h:75`). -/
def fd_bn254_fp_set_one.spec : fd_bn254_fp_t :=
  #v[fd_bn254_const_one_mont[0], fd_bn254_const_one_mont[1], fd_bn254_const_one_mont[2],
    fd_bn254_const_one_mont[3]]

/-! ## `fd_bn254_field_inl.h` -/

/-- `fd_bn254_fp_is_neg_nm` (`fd_bn254_field_inl.h:42`): `x > (p-1)/2`, `x` not Montgomery. -/
def fd_bn254_fp_is_neg_nm.spec (x : fd_bn254_fp_t) : BitVec 32 :=
  if (0#32).slt (fd_uint256_cmp.spec x fd_bn254_const_p_minus_one_half) then 1 else 0

/-- What `fd_bn254_fp_frombytes_nm` does: `r` after the call, `(*is_inf, *is_neg)` after the call
(`none` when `NULL` was passed), and its return, `some r` or `none` for `NULL`. -/
structure fd_bn254_fp_frombytes_nm.Result where
  r : fd_bn254_fp_t
  flags : Option (BitVec 32 × BitVec 32)
  ret : Option fd_bn254_fp_t
deriving Repr

/-- `fd_bn254_fp_frombytes_nm` (`fd_bn254_field_inl.h:47`). `r` is the element before the call;
`flags` is `none` for `is_inf == NULL` and otherwise `(*is_inf, *is_neg)` before the call. On the
both-flags `NULL` return `r` is untouched; on the `>= p` `NULL` return it has been stored. -/
def fd_bn254_fp_frombytes_nm.spec (r : fd_bn254_fp_t) (buf : Vector (BitVec 8) 32)
    (big_endian : BitVec 32) (flags : Option (BitVec 32 × BitVec 32)) :
    fd_bn254_fp_frombytes_nm.Result :=
  let fb := if big_endian ≠ 0 then buf[0] else buf[31]
  let is_inf : BitVec 32 := if fb &&& FLAG_INF ≠ 0 then 1 else 0
  let is_neg : BitVec 32 := if fb &&& FLAG_NEG ≠ 0 then 1 else 0
  let flags := flags.map fun _ => (is_inf, is_neg)
  if flags.isSome ∧ is_inf ≠ 0 ∧ is_neg ≠ 0 then ⟨r, flags, none⟩ else
  let r := fd_uint256_t.ofBuf buf
  let r := if big_endian ≠ 0 then fd_uint256_bswap.spec r else r
  let r := if flags.isSome then fd_uint256_t.ofBuf (r.buf.set 31 (r.buf[31] &&& FLAG_MASK)) else r
  if (0#32).sle (fd_uint256_cmp.spec r fd_bn254_const_p) then ⟨r, flags, none⟩ else
  ⟨r, flags, some r⟩

/-- What `fd_bn254_fp_tobytes_nm` does: the 32 bytes at `buf`, and `a` after the call (byte-swapped
in place when `big_endian`). -/
structure fd_bn254_fp_tobytes_nm.Result where
  buf : Vector (BitVec 8) 32
  a : fd_bn254_fp_t
deriving Repr

/-- `fd_bn254_fp_tobytes_nm` (`fd_bn254_field_inl.h:79`). -/
def fd_bn254_fp_tobytes_nm.spec (a : fd_bn254_fp_t) (big_endian : BitVec 32) :
    fd_bn254_fp_tobytes_nm.Result :=
  let a := if big_endian ≠ 0 then fd_uint256_bswap.spec a else a
  ⟨a.buf, a⟩

/-- `fd_bn254_fp_eq` (`fd_bn254_field_inl.h:90`). -/
def fd_bn254_fp_eq.spec (r a : fd_bn254_fp_t) : BitVec 32 :=
  fd_uint256_eq.spec r a

/-- `fd_bn254_fp_neg_nm` (`fd_bn254_field_inl.h:96`): `p - a` for `a ≠ 0`, not Montgomery; loop
unrolled. `r->limbs[i]` is stored after `a->limbs[i]` is read, so `r` may alias `a`. -/
def fd_bn254_fp_neg_nm.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  if fd_bn254_fp_is_zero.spec a ≠ 0 then fd_bn254_fp_set_zero.spec else
  let cy : BitVec 64 := 0
  -- i = 0
  let p := fd_bn254_const_p[0]
  let b := a[0]
  let b := b + cy
  let cy : BitVec 64 := if b < cy then 1 else 0
  let cy := cy + (if p < b then 1 else 0)
  let r0 := p - b
  -- i = 1
  let p := fd_bn254_const_p[1]
  let b := a[1]
  let b := b + cy
  let cy : BitVec 64 := if b < cy then 1 else 0
  let cy := cy + (if p < b then 1 else 0)
  let r1 := p - b
  -- i = 2
  let p := fd_bn254_const_p[2]
  let b := a[2]
  let b := b + cy
  let cy : BitVec 64 := if b < cy then 1 else 0
  let cy := cy + (if p < b then 1 else 0)
  let r2 := p - b
  -- i = 3
  let p := fd_bn254_const_p[3]
  let b := a[3]
  let b := b + cy
  let cy : BitVec 64 := if b < cy then 1 else 0
  let _cy := cy + (if p < b then 1 else 0)
  let r3 := p - b
  #v[r0, r1, r2, r3]

/-- `fd_bn254_fp_set` (`fd_bn254_field_inl.h:114`). -/
def fd_bn254_fp_set.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  #v[a[0], a[1], a[2], a[3]]

/-- `fd_bn254_fp_add` (`fd_bn254_field_inl.h:125`), the non-ADX `#else`: `fiat_bn254_add`. -/
def fd_bn254_fp_add.spec (a b : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fiat_bn254_add.spec a b

/-- `fd_bn254_fp_sub` (`fd_bn254_field_inl.h:179`), the non-ADX `#else`: `fiat_bn254_sub`. -/
def fd_bn254_fp_sub.spec (a b : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fiat_bn254_sub.spec a b

/-- `fd_bn254_fp_neg` (`fd_bn254_field_inl.h:208`): `fiat_bn254_opp`. -/
def fd_bn254_fp_neg.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fiat_bn254_opp.spec a

/-- `fd_bn254_fp_mul` (`FD_UINT256_FP_MUL_IMPL`, `fd_bn254_field_inl.h:226`). -/
def fd_bn254_fp_mul.spec (a b : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fd_uint256_mul_mod_p.spec a b fd_bn254_const_p fd_bn254_const_p_inv

/-- `fd_bn254_fp_sqr` (`fd_bn254_field_inl.h:229`). -/
def fd_bn254_fp_sqr.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fd_bn254_fp_mul.spec a a

/-- `fd_bn254_fp_from_mont` (`fd_bn254_field_inl.h:239`): `fp_mul( a, 1 )`. -/
def fd_bn254_fp_from_mont.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fd_bn254_fp_mul.spec a fd_bn254_const_one

/-- `fd_bn254_fp_to_mont` (`fd_bn254_field_inl.h:246`): `fp_mul( a, R^2 )`. -/
def fd_bn254_fp_to_mont.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  fd_bn254_fp_mul.spec a fd_bn254_const_rr

/-! ## `fd_bn254_fp_pow` (`fd_bn254_field.c:74`) -/

/-- The `while( !fd_uint256_bit( b, i ) ) i--;` scan from `i`; `none` if it would step below
`0` (reading bit `-1`, a negative shift: unreachable for `b ≠ 0`). -/
def fd_bn254_fp_pow.scan (b : fd_uint256_t) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, h => if fd_uint256_bit.spec b 0 h ≠ 0 then some ⟨0, h⟩ else none
  | i + 1, h =>
    if fd_uint256_bit.spec b (i + 1) h ≠ 0 then some ⟨i + 1, h⟩
    else fd_bn254_fp_pow.scan b i (by omega)

/-- One iteration `i` of `for( ; i>=0; i-- )`: square, then multiply by `a` if bit `i` is set. -/
def fd_bn254_fp_pow.step (a b r : fd_bn254_fp_t) (i : Nat) (h : i < 256) : fd_bn254_fp_t :=
  let r := fd_bn254_fp_sqr.spec r
  if fd_uint256_bit.spec b i h ≠ 0 then fd_bn254_fp_mul.spec r a else r

/-- The loop `for( ; i>=0; i-- )` from `i` down to `0`. -/
def fd_bn254_fp_pow.loop (a b r : fd_bn254_fp_t) : (i : Nat) → i < 256 → fd_bn254_fp_t
  | 0, h => fd_bn254_fp_pow.step a b r 0 h
  | i + 1, h => fd_bn254_fp_pow.loop a b (fd_bn254_fp_pow.step a b r (i + 1) h) i (by omega)

opaque fd_bn254_fp_pow_unspec : fd_bn254_fp_t → fd_uint256_t → fd_bn254_fp_t

/-- `fd_bn254_fp_pow` (`fd_bn254_field.c:74`): `a^b`, left to right. `r` is `restrict` (stored
before `a` is read); every call site passes distinct `r`, `a`. -/
def fd_bn254_fp_pow.spec (a : fd_bn254_fp_t) (b : fd_uint256_t) : fd_bn254_fp_t :=
  let r := fd_bn254_fp_set_one.spec
  if fd_uint256_is_zero.spec b ≠ 0 then r else
  match fd_bn254_fp_pow.scan b 255 (by omega) with
  | none => fd_bn254_fp_pow_unspec a b
  | some i => fd_bn254_fp_pow.loop a b r i.val i.isLt

/-! ## `fd_bn254_fp_inv` (`fd_bn254_field_inl.h:253`) -/

/-- `fd_bn254_fp_inv` without `FD_HAS_S2NBIGNUM` (`fd_bn254_field_inl.h:267-272`):
`fp_pow( a, p-2 )`. -/
def fd_bn254_fp_inv.spec (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  let p_minus_2 := fd_bn254_fp_set.spec fd_bn254_const_p
  let p_minus_2 := p_minus_2.set 0 (p_minus_2[0] - 2)
  fd_bn254_fp_pow.spec a p_minus_2

/-- `fd_bn254_fp_inv` with `FD_HAS_S2NBIGNUM` (`fd_bn254_field_inl.h:255-266`): `bignum_modinv`
into the local `z`, then `to_mont` twice. `z` and `tmp` are locals, disjoint from `a` and
`fd_bn254_const_p`. -/
def fd_bn254_fp_inv.s2n (a : fd_bn254_fp_t) : fd_bn254_fp_t :=
  let z := bignum_modinv.spec 4 a fd_bn254_const_p 12 false
  let r := fd_bn254_fp_to_mont.spec z
  let r := fd_bn254_fp_to_mont.spec r
  r

/-- The build-dependent functions the G1 code calls: `fd_bn254_fp_inv`. -/
structure Backend where
  fp_inv : fd_bn254_fp_t → fd_bn254_fp_t

/-- The `FD_HAS_S2NBIGNUM` build (every x86-64 and arm production build). -/
def Backend.s2n : Backend := ⟨fd_bn254_fp_inv.s2n⟩

/-- The build without `FD_HAS_S2NBIGNUM`. -/
def Backend.ref : Backend := ⟨fd_bn254_fp_inv.spec⟩

/-- What `fd_bn254_fp_sqrt` does: `r` after the call (stored only on success), and its return. -/
structure fd_bn254_fp_sqrt.Result where
  r : fd_bn254_fp_t
  ret : Option fd_bn254_fp_t
deriving Repr

/-- `fd_bn254_fp_sqrt` (`fd_bn254_field_inl.h:276`): `a^((p+1)/4)` as `a1 * a` with
`a1 = a^((p-3)/4)`, `NULL` iff `a1^2 * a = -1`. `r` is the element before the call. -/
def fd_bn254_fp_sqrt.spec (r a : fd_bn254_fp_t) : fd_bn254_fp_sqrt.Result :=
  let a1 := fd_bn254_fp_pow.spec a fd_bn254_const_sqrt_exp
  let a0 := fd_bn254_fp_sqr.spec a1
  let a0 := fd_bn254_fp_mul.spec a0 a
  if fd_bn254_fp_eq.spec a0 fd_bn254_const_p_minus_one_mont ≠ 0 then ⟨r, none⟩ else
  let r := fd_bn254_fp_mul.spec a1 a
  ⟨r, some r⟩

end

end Firedancer.Bn254

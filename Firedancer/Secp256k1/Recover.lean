module

public import Firedancer.Secp256k1.Point
public import Firedancer.Secp256k1.BackendS2n
public import Firedancer.Secp256k1.BackendRef

/-! `fd_secp256k1.c`: public key recovery, for a backend `B`, and its two builds. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-- What `fd_secp256k1_recovery_y` does: the point it leaves at `r`, and its return, `some r` or
`none` for `NULL`. On `NULL` only `r->y` has been stored (by `fd_secp256k1_fp_sqrt`). -/
structure fd_secp256k1_recovery_y.Result where
  r : fd_secp256k1_point_t
  ret : Option fd_secp256k1_point_t

/-- `fd_secp256k1_recovery_y` (`fd_secp256k1.c:6`): `r` is the point before the call. -/
def fd_secp256k1_recovery_y.spec (B : Backend) (r : fd_secp256k1_point_t) (x : fd_secp256k1_fp_t)
    (odd : BitVec 32) : fd_secp256k1_recovery_y.Result :=
  let x2 := B.fp_sqr x
  let x3 := B.fp_mul x2 x
  let x3 := B.fp_add x3 fd_secp256k1_const_b_mont
  let sqrt := fd_secp256k1_fp_sqrt.spec B x3
  let r := { r with y := sqrt.r }
  match sqrt.ret with
  | none => ⟨r, none⟩
  | some _ =>
    let r := if B.fp_is_odd r.y ≠ odd then { r with y := B.fp_negate r.y } else r
    let r := { r with x := B.fp_set x }
    let r := { r with z := B.fp_set fd_secp256k1_const_one_mont }
    ⟨r, some r⟩

/-- What `fd_secp256k1_recover` does: the 64 bytes at `public_key` after the call, and its
return, `some public_key` or `none` for `NULL`. -/
structure fd_secp256k1_recover.Result where
  public_key : Vector (BitVec 8) 64
  ret : Option (Vector (BitVec 8) 64)

/-- `fd_secp256k1_recover` (`fd_secp256k1.c:29`): `public_key` is the buffer before the call; it
is stored only on success, after the last read of `msg_hash` and `sig`, so it may alias them. -/
def fd_secp256k1_recover.spec (B : Backend) (public_key : Vector (BitVec 8) 64)
    (msg_hash : Vector (BitVec 8) 32) (sig : Vector (BitVec 8) 64) (recovery_id : BitVec 32) :
    fd_secp256k1_recover.Result :=
  let fail : fd_secp256k1_recover.Result := ⟨public_key, none⟩
  if !((0#32).sle recovery_id && recovery_id.sle 3#32) then fail else
  let rs := B.scalar_frombytes (Vector.ofFn fun j => sig[j.val])
  match rs.ret with
  | none => fail
  | some _ =>
  let rs := rs.r
  let s := B.scalar_frombytes (Vector.ofFn fun j => sig[32 + j.val])
  match s.ret with
  | none => fail
  | some _ =>
  let s := s.r
  let r := B.fp_tomont rs
  -- if( recovery_id & 2 ) { if( fd_uint256_cmp( rs, p_minus_n ) >= 0 ) return NULL; … }
  let r? : Option fd_secp256k1_fp_t :=
    if recovery_id &&& 2#32 ≠ 0#32 then
      if (0#32).sle (fd_uint256_cmp.spec rs fd_secp256k1_const_p_minus_n) then none
      else some (B.fp_add r fd_secp256k1_const_n_mont)
    else some r
  match r? with
  | none => fail
  | some r =>
  let a := fd_secp256k1_recovery_y.spec B default r (recovery_id &&& 1#32)
  match a.ret with
  | none => fail
  | some _ =>
  let a := a.r
  -- memcpy( msg, msg_hash, 32 );
  let msg := fd_uint256_t.ofBuf msg_hash
  let msg := fd_uint256_bswap.spec msg
  let msg := B.scalar_reduce msg
  let msg := B.scalar_tomont msg
  let s := B.scalar_tomont s
  let rn := B.scalar_invert rs
  let rn := B.scalar_tomont rn
  let u1 := B.scalar_mul rn msg
  let u1 := B.scalar_negate u1
  let u2 := B.scalar_mul rn s
  let u2 := B.scalar_demont u2
  let u1 := B.scalar_demont u1
  let pubkey := fd_secp256k1_double_base_mul.spec B u1 a u2
  if fd_secp256k1_point_is_identity.spec B pubkey ≠ 0#32 then fail else
  let pubkey := fd_secp256k1_point_to_affine.spec B pubkey pubkey
  let public_key := storeBytes public_key 0 (B.fp_tobytes pubkey.x)
  let public_key := storeBytes public_key 32 (B.fp_tobytes pubkey.y)
  ⟨public_key, some public_key⟩

/-- `fd_secp256k1_recover` built with s2n-bignum, with or without `__ADX__`. -/
def fd_secp256k1_recover.s2n (adx : Bool) := fd_secp256k1_recover.spec (S2n.backend adx)

/-- `fd_secp256k1_recover` built with the fiat-crypto backend. -/
def fd_secp256k1_recover.ref := fd_secp256k1_recover.spec Ref.backend

end

end Firedancer.Secp256k1

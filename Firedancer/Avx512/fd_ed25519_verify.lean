module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Globals
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Avx512.fd_ed25519_point_frombytes_2x
public import Firedancer.Avx512.fd_ed25519_affine_is_small_order
public import Firedancer.Avx512.fd_ed25519_point_neg
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base
public import Firedancer.Avx512.fd_ed25519_point_eq_z1
public import Firedancer.Avx512.Mlir.fd_ed25519_verify

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification

The hashing is the ref's code, so its specs are the ref's. -/

@[expose] public section

open Firedancer.Ref

/-- Eight 64-bit words as the 64 bytes they are stored as, word 0 lowest. -/
def fd_ed25519_verify.words8Bits (v : Vector (BitVec 64) 8) : BitVec 512 :=
  v[7] ++ v[6] ++ v[5] ++ v[4] ++ v[3] ++ v[2] ++ v[1] ++ v[0]

/-- `fd_sha512_fini` after `init` on a buffer `buf0` and `append` of `r ‖ publicKey ‖ msg`: the
hash object and the digest's words. -/
def fd_ed25519_verify.hash (buf0 : BitVec 1024) (r publicKey : BitVec 256) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) : ShaState × Vector (BitVec 64) 8 :=
  let sha0 : ShaState := ⟨buf0, sha512IV, 0#64, 0#64, 0#64⟩
  let sha1 := fd_sha512_append.spec sha0 32#64 r
  let sha2 := fd_sha512_append.spec sha1 32#64 publicKey
  fd_sha512_fini.spec (fd_sha512_append.spec sha2 msgSz msg)

/-- `fd_ed25519_verify` on the signature halves `r`, `S`, the public key and the message, with
`buf0` the hash object's buffer and `tbl` the base point's table: the code it returns and the hash
object it leaves when it hashes. The checks in the C's order: `-1`/`-2`/`-3` for a bad signature,
key or message, `0` if `[S]B = R + [k]A'` holds as `fd_ed25519_point_eq_z1` decides it. -/
noncomputable def fd_ed25519_verify.spec (tbl : Nat → Quad) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat))
    (r S publicKey : BitVec 256) (buf0 : BitVec 1024) : BitVec 32 × Option ShaState :=
  if !fd_curve25519_scalar_validate.spec S then (-1#32, none)
  else
    let (res, Aprime, R) := fd_ed25519_point_frombytes_2x.spec publicKey r
    if res ≠ 0#32 then (if res = -1#32 then -2#32 else -1#32, none)
    else if fd_ed25519_affine_is_small_order.spec Aprime ≠ 0#32 then (-2#32, none)
    else if fd_ed25519_affine_is_small_order.spec R ≠ 0#32 then (-1#32, none)
    else
      let (sha4, kw) := fd_ed25519_verify.hash buf0 r publicKey msgSz msg
      let k := fd_curve25519_scalar_reduce.spec (fd_ed25519_verify.words8Bits kw)
      let Aneg := fd_ed25519_point_neg.spec Aprime
      let Rcmp := fd_ed25519_double_scalar_mul_base.spec tbl k Aneg S
      (if fd_ed25519_point_eq_z1.spec Rcmp R = 0#32 then -3#32 else 0#32, some sha4)

end

end LeanMLIR.RIR.Firedancer.Avx512

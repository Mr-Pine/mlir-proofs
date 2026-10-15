module

public import Firedancer.Secp256k1.Bits

/-! `fd_secp256k1_private.h`: the element and point types, the constants, and the interface the
shared code (`fd_secp256k1_point.c`, `fd_secp256k1.c`) expects from the backend it includes. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-! ## Types -/

/-- `fd_secp256k1_scalar_t` (`fd_secp256k1_private.h:9`). -/
abbrev fd_secp256k1_scalar_t := fd_uint256_t

/-- `fd_secp256k1_fp_t` (`fd_secp256k1_private.h:12`). -/
abbrev fd_secp256k1_fp_t := fd_uint256_t

/-- `struct fd_secp256k1_point` (`fd_secp256k1_private.h:15`), projective coordinates
(the C comment says Jacobian). -/
structure fd_secp256k1_point_t where
  x : fd_secp256k1_fp_t
  y : fd_secp256k1_fp_t
  z : fd_secp256k1_fp_t
deriving Inhabited

/-! ## Constants, limbs as in the C -/

/-- `fd_secp256k1_const_zero` (`fd_secp256k1_private.h:23`). -/
def fd_secp256k1_const_zero : fd_secp256k1_scalar_t :=
  #v[0, 0, 0, 0]

/-- `fd_secp256k1_const_n` (`fd_secp256k1_private.h:29`), not Montgomery. -/
def fd_secp256k1_const_n : fd_secp256k1_scalar_t :=
  #v[0xbfd25e8cd0364141, 0xbaaedce6af48a03b, 0xfffffffffffffffe, 0xffffffffffffffff]

/-- `fd_secp256k1_const_p_minus_n` (`fd_secp256k1_private.h:35`), not Montgomery. -/
def fd_secp256k1_const_p_minus_n : fd_secp256k1_scalar_t :=
  #v[0x402da1722fc9baee, 0x4551231950b75fc4, 0x1, 0x0]

/-- `fd_secp256k1_const_scalar_rr_mont` (`fd_secp256k1_private.h:45`), `ulong[4]`. -/
def fd_secp256k1_const_scalar_rr_mont : Vector (BitVec 64) 4 :=
  #v[0x896cf21467d7d140, 0x741496c20e7cf878, 0xe697f5e45bcd07c6, 0x9d671cd581c69bc5]

/-- `fd_secp256k1_const_one_mont` (`fd_secp256k1_private.h:50`). -/
def fd_secp256k1_const_one_mont : fd_secp256k1_fp_t :=
  #v[0x1000003d1, 0, 0, 0]

/-- `fd_secp256k1_const_b_mont` (`fd_secp256k1_private.h:55`). -/
def fd_secp256k1_const_b_mont : fd_secp256k1_fp_t :=
  #v[0x700001ab7, 0, 0, 0]

/-- `fd_secp256k1_const_n_mont` (`fd_secp256k1_private.h:61`). -/
def fd_secp256k1_const_n_mont : fd_secp256k1_fp_t :=
  #v[0xe21120489f1d95e1, 0x24a1ac9eb3fde294, 0xfffffffebaaed80d, 0xffffffffffffffff]

/-- `fd_secp256k1_const_p` (`fd_secp256k1_private.h:67`), not Montgomery. -/
def fd_secp256k1_const_p : fd_secp256k1_fp_t :=
  #v[0xfffffffefffffc2f, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff]

/-- `fd_secp256k1_const_base_x_mont` (`fd_secp256k1_private.h:73`). -/
def fd_secp256k1_const_base_x_mont : fd_secp256k1_fp_t :=
  #v[0xd7362e5a487e2097, 0x231e295329bc66db, 0x979f48c033fd129c, 0x9981e643e9089f48]

/-- `fd_secp256k1_const_base_y_mont` (`fd_secp256k1_private.h:79`). -/
def fd_secp256k1_const_base_y_mont : fd_secp256k1_fp_t :=
  #v[0xb15ea6d2d3dbabe2, 0x8dfc5d5d1f1dc64d, 0x70b6b59aac19c136, 0xcf3f851fd4a582d6]

/-! ## Backend interface -/

/-- What `fd_secp256k1_scalar_frombytes` does: the limbs it stores at `r` (always), and its return,
`some r` or `none` for `NULL`. -/
structure fd_secp256k1_scalar_frombytes.Result where
  r : fd_secp256k1_scalar_t
  ret : Option fd_secp256k1_scalar_t

/-- The `fd_secp256k1_fp_*` and `fd_secp256k1_scalar_*` functions the shared code calls, as
provided by `fd_secp256k1_s2n.c` or `fd_secp256k1_ref.c` (`fd_secp256k1_private.h:86-90`). Each
field is the value written to the output `r` (or the `int` returned), from its input values. -/
structure Backend where
  scalar_frombytes : (Vector (BitVec 8) 32) → fd_secp256k1_scalar_frombytes.Result
  scalar_reduce : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  scalar_invert : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  scalar_mul : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  scalar_negate : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  scalar_tomont : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  scalar_demont : fd_secp256k1_scalar_t → fd_secp256k1_scalar_t
  fp_set : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_eq : fd_secp256k1_fp_t → fd_secp256k1_fp_t → BitVec 32
  fp_add : fd_secp256k1_fp_t → fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_sub : fd_secp256k1_fp_t → fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_dbl : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_triple : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_mul : fd_secp256k1_fp_t → fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_sqr : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_negate : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_is_odd : fd_secp256k1_fp_t → BitVec 32
  fp_invert : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_tomont : fd_secp256k1_fp_t → fd_secp256k1_fp_t
  fp_tobytes : fd_secp256k1_fp_t → Vector (BitVec 8) 32

end

end Firedancer.Secp256k1

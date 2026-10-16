module

public import Firedancer.Bn254.Field

/-! `fd_bn254_glv.h`: the GLV scalar decomposition helpers, all `uint128` (`BitVec 128`, wrapping),
and the lattice constants of `fd_bn254_field.c:66-71` the G1 code uses. Loops are unrolled. -/

namespace Firedancer.Bn254

@[expose] public section

/-! ## Constants -/

/-- `na` (`fd_bn254_field.c:66`), `N_A`. -/
def na : Vector (BitVec 64) 2 := #v[0x8211bbeb7d4f1128, 0x6f4d8248eeb859fc]

/-- `nb` (`fd_bn254_field.c:67`), `N_B`. -/
def nb : Vector (BitVec 64) 1 := #v[0x89d3256894d213e3]

/-- `nc` (`fd_bn254_field.c:68`), `N_C`. -/
def nc : Vector (BitVec 64) 2 := #v[0x0be4e1541221250b, 0x6f4d8248eeb859fd]

/-- `g1_const_g1` (`fd_bn254_field.c:69`), `round(2^256 N_C / r)`. -/
def g1_const_g1 : Vector (BitVec 64) 3 :=
  #v[0x5398fd0300ff6565, 0x4ccef014a773d2d2, 0x0000000000000002]

/-- `g2_const` (`fd_bn254_field.c:71`), `round(2^256 N_B / r)`. -/
def g2_const : Vector (BitVec 64) 2 := #v[0xd91d232ec7e0b3d7, 0x0000000000000002]

/-- `fd_bn254_const_beta_mont` (`fd_bn254_g1.c:11`), the cube root of unity `β` in Montgomery
form. -/
def fd_bn254_const_beta_mont : fd_bn254_fp_t :=
  #v[0x3350c88e13e80b9c, 0x7dce557cdb5e56b9, 0x6001b4b8b615564a, 0x2682e617020217e0]

/-! ## Helpers -/

/-- `(uint128)x`. -/
abbrev u128 (x : BitVec 64) : BitVec 128 := x.setWidth 128

/-- `(ulong)(acc >> 64)`, widened back for the next `uint128` sum. -/
abbrev hi (acc : BitVec 128) : BitVec 128 := u128 ((acc >>> 64).setWidth 64)

/-- `fd_bn254_glv_sxg3` (`fd_bn254_glv.h:99`): the top 3 limbs of `s * g` (`>> 256`). -/
def fd_bn254_glv_sxg3.spec (s : fd_bn254_scalar_t) (g : Vector (BitVec 64) 3) :
    Vector (BitVec 64) 3 :=
  let s0 := u128 s[0]
  let s1 := u128 s[1]
  let s2 := u128 s[2]
  let s3 := u128 s[3]
  let acc := s0 * u128 g[0]
  let acc := s1 * u128 g[0] + s0 * u128 g[1] + hi acc
  let acc := s2 * u128 g[0] + s1 * u128 g[1] + s0 * u128 g[2] + hi acc
  let acc := s3 * u128 g[0] + s2 * u128 g[1] + s1 * u128 g[2] + hi acc
  let acc := s3 * u128 g[1] + s2 * u128 g[2] + hi acc
  let out0 := acc.setWidth 64
  let acc := s3 * u128 g[2] + hi acc
  let out1 := acc.setWidth 64
  let acc := hi acc
  let out2 := acc.setWidth 64
  #v[out0, out1, out2]

/-- `fd_bn254_glv_sxg2` (`fd_bn254_glv.h:118`): the top 2 limbs of `s * g` (`>> 256`). -/
def fd_bn254_glv_sxg2.spec (s : fd_bn254_scalar_t) (g : Vector (BitVec 64) 2) :
    Vector (BitVec 64) 2 :=
  let s0 := u128 s[0]
  let s1 := u128 s[1]
  let s2 := u128 s[2]
  let s3 := u128 s[3]
  let acc := s0 * u128 g[0]
  let acc := s1 * u128 g[0] + s0 * u128 g[1] + hi acc
  let acc := s2 * u128 g[0] + s1 * u128 g[1] + hi acc
  let acc := s3 * u128 g[0] + s2 * u128 g[1] + hi acc
  let acc := s3 * u128 g[1] + hi acc
  let out0 := acc.setWidth 64
  let acc := hi acc
  let out1 := acc.setWidth 64
  #v[out0, out1]

/-- `fd_bn254_glv_mul3x2` (`fd_bn254_glv.h:136`): the low 4 limbs of `a * n`. -/
def fd_bn254_glv_mul3x2.spec (a : Vector (BitVec 64) 3) (n : Vector (BitVec 64) 2) :
    Vector (BitVec 64) 4 :=
  let acc := u128 a[0] * u128 n[0]
  let out0 := acc.setWidth 64
  let acc := u128 a[1] * u128 n[0] + u128 a[0] * u128 n[1] + hi acc
  let out1 := acc.setWidth 64
  let acc := u128 a[2] * u128 n[0] + u128 a[1] * u128 n[1] + hi acc
  let out2 := acc.setWidth 64
  let acc := u128 a[2] * u128 n[1] + hi acc
  let out3 := acc.setWidth 64
  #v[out0, out1, out2, out3]

/-- `fd_bn254_glv_mul3x1` (`fd_bn254_glv.h:148`): `a * n` in 4 limbs. -/
def fd_bn254_glv_mul3x1.spec (a : Vector (BitVec 64) 3) (n : Vector (BitVec 64) 1) :
    Vector (BitVec 64) 4 :=
  let acc := u128 a[0] * u128 n[0]
  let out0 := acc.setWidth 64
  let acc := u128 a[1] * u128 n[0] + hi acc
  let out1 := acc.setWidth 64
  let acc := u128 a[2] * u128 n[0] + hi acc
  let out2 := acc.setWidth 64
  let acc := hi acc
  let out3 := acc.setWidth 64
  #v[out0, out1, out2, out3]

/-- `fd_bn254_glv_mul2x2` (`fd_bn254_glv.h:160`): `a * n` in 4 limbs. -/
def fd_bn254_glv_mul2x2.spec (a : Vector (BitVec 64) 2) (n : Vector (BitVec 64) 2) :
    Vector (BitVec 64) 4 :=
  let acc := u128 a[0] * u128 n[0]
  let out0 := acc.setWidth 64
  let acc := u128 a[1] * u128 n[0] + u128 a[0] * u128 n[1] + hi acc
  let out1 := acc.setWidth 64
  let acc := u128 a[1] * u128 n[1] + hi acc
  let out2 := acc.setWidth 64
  let acc := hi acc
  let out3 := acc.setWidth 64
  #v[out0, out1, out2, out3]

/-- `fd_bn254_glv_mul2x1` (`fd_bn254_glv.h:172`): `a * n` in the 3 limbs `out[0..2]` it stores. -/
def fd_bn254_glv_mul2x1.spec (a : Vector (BitVec 64) 2) (n : Vector (BitVec 64) 1) :
    Vector (BitVec 64) 3 :=
  let acc := u128 a[0] * u128 n[0]
  let out0 := acc.setWidth 64
  let acc := u128 a[1] * u128 n[0] + hi acc
  let out1 := acc.setWidth 64
  let acc := hi acc
  let out2 := acc.setWidth 64
  #v[out0, out1, out2]

/-- `fd_bn254_glv_add4` (`fd_bn254_glv.h:183`): `(out, carry)` of `a + b`. -/
def fd_bn254_glv_add4.spec (a b : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 × BitVec 64 :=
  let carry : BitVec 64 := 0
  -- j = 0
  let acc := u128 a[0] + u128 b[0] + u128 carry
  let out0 := acc.setWidth 64
  let carry := (acc >>> 64).setWidth 64
  -- j = 1
  let acc := u128 a[1] + u128 b[1] + u128 carry
  let out1 := acc.setWidth 64
  let carry := (acc >>> 64).setWidth 64
  -- j = 2
  let acc := u128 a[2] + u128 b[2] + u128 carry
  let out2 := acc.setWidth 64
  let carry := (acc >>> 64).setWidth 64
  -- j = 3
  let acc := u128 a[3] + u128 b[3] + u128 carry
  let out3 := acc.setWidth 64
  let carry := (acc >>> 64).setWidth 64
  (#v[out0, out1, out2, out3], carry)

/-- One limb of `fd_bn254_glv_sub4`: `(diff, borrow)`. -/
def fd_bn254_glv_sub4.limb (av bv borrow : BitVec 64) : BitVec 64 × BitVec 64 :=
  let diff := av - bv - borrow
  let borrow : BitVec 64 := if av < bv ∨ (borrow ≠ 0 ∧ av = bv) then 1 else 0
  (diff, borrow)

/-- `fd_bn254_glv_sub4` (`fd_bn254_glv.h:197`): `(out, borrow)` of `a - b`. `out[j]` is stored
after `a[j]`, `b[j]` are read. -/
def fd_bn254_glv_sub4.spec (a b : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 × BitVec 64 :=
  let borrow : BitVec 64 := 0
  let (out0, borrow) := fd_bn254_glv_sub4.limb a[0] b[0] borrow
  let (out1, borrow) := fd_bn254_glv_sub4.limb a[1] b[1] borrow
  let (out2, borrow) := fd_bn254_glv_sub4.limb a[2] b[2] borrow
  let (out3, borrow) := fd_bn254_glv_sub4.limb a[3] b[3] borrow
  (#v[out0, out1, out2, out3], borrow)

/-- `fd_bn254_glv_negate4` (`fd_bn254_glv.h:213`): two's complement of `v`, in place. -/
def fd_bn254_glv_negate4.spec (v : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  let carry : BitVec 64 := 1
  -- j = 0
  let sum := u128 (~~~v[0]) + u128 carry
  let v := v.set 0 (sum.setWidth 64)
  let carry := (sum >>> 64).setWidth 64
  -- j = 1
  let sum := u128 (~~~v[1]) + u128 carry
  let v := v.set 1 (sum.setWidth 64)
  let carry := (sum >>> 64).setWidth 64
  -- j = 2
  let sum := u128 (~~~v[2]) + u128 carry
  let v := v.set 2 (sum.setWidth 64)
  let carry := (sum >>> 64).setWidth 64
  -- j = 3
  let sum := u128 (~~~v[3]) + u128 carry
  let v := v.set 3 (sum.setWidth 64)
  let _carry := (sum >>> 64).setWidth 64
  v

end

end Firedancer.Bn254

module

public import Firedancer.Bn254.Glv

/-! `fd_bn254_g1.c`: G1 in Jacobian coordinates (`Z = 0` is the point at infinity), for a build
`B` (the `fd_bn254_fp_inv` it uses). A point function's value is the point it leaves at `r`; `r`
is the point before the call where a path stores only part of it (`fd_bn254_g1_set_zero` stores
only `Z`). -/

namespace Firedancer.Bn254

@[expose] public section

/-- `struct fd_bn254_g1` (`fd_bn254_internal.h:28`). -/
structure fd_bn254_g1_t where
  X : fd_bn254_fp_t
  Y : fd_bn254_fp_t
  Z : fd_bn254_fp_t
deriving Inhabited, Repr, DecidableEq

/-- `fd_bn254_g1_is_zero` (`fd_bn254_internal.h:174`): `Z == 0`. -/
def fd_bn254_g1_is_zero.spec (p : fd_bn254_g1_t) : BitVec 32 :=
  fd_bn254_fp_is_zero.spec p.Z

/-- `fd_bn254_g1_set` (`fd_bn254_g1.c:16`). -/
def fd_bn254_g1_set.spec (p : fd_bn254_g1_t) : fd_bn254_g1_t :=
  ⟨fd_bn254_fp_set.spec p.X, fd_bn254_fp_set.spec p.Y, fd_bn254_fp_set.spec p.Z⟩

/-- `fd_bn254_g1_set_zero` (`fd_bn254_g1.c:25`): stores only `Z = 0`; `X`, `Y` keep `r`'s. -/
def fd_bn254_g1_set_zero.spec (r : fd_bn254_g1_t) : fd_bn254_g1_t :=
  { r with Z := fd_bn254_fp_set_zero.spec }

/-- `fd_bn254_g1_to_affine` (`fd_bn254_g1.c:33`): every path stores all of `r`, and each field
of `p` is read before the same field of `r` is stored, so `r` may alias `p`. -/
def fd_bn254_g1_to_affine.spec (B : Backend) (p : fd_bn254_g1_t) : fd_bn254_g1_t :=
  if fd_bn254_fp_is_zero.spec p.Z ≠ 0 ∨ fd_bn254_fp_is_one.spec p.Z ≠ 0 then
    fd_bn254_g1_set.spec p
  else
  let iz := B.fp_inv p.Z
  let iz2 := fd_bn254_fp_sqr.spec iz
  let r_X := fd_bn254_fp_mul.spec p.X iz2
  let r_Y := fd_bn254_fp_mul.spec p.Y iz2
  let r_Y := fd_bn254_fp_mul.spec r_Y iz
  let r_Z := fd_bn254_fp_set_one.spec
  ⟨r_X, r_Y, r_Z⟩

/-- `fd_bn254_g1_tobytes` (`fd_bn254_g1.c:52`): the 64 bytes stored at `out` (all of them, on
both paths), `x ‖ y` not Montgomery, each 32 bytes in the requested endianness, no flags. -/
def fd_bn254_g1_tobytes.spec (B : Backend) (p : fd_bn254_g1_t) (big_endian : BitVec 32) :
    Vector (BitVec 8) 64 :=
  if fd_bn254_g1_is_zero.spec p ≠ 0 then Vector.replicate 64 0 else
  let r := fd_bn254_g1_to_affine.spec B p
  let r := { r with X := fd_bn254_fp_from_mont.spec r.X }
  let r := { r with Y := fd_bn254_fp_from_mont.spec r.Y }
  let out0 := (fd_bn254_fp_tobytes_nm.spec r.X big_endian).buf
  let out32 := (fd_bn254_fp_tobytes_nm.spec r.Y big_endian).buf
  out0 ++ out32

/-- `fd_bn254_g1_affine_add` (`fd_bn254_g1.c:76`), `p`, `q` affine (`Z = 1`) or zero. `r` is
stored only at the end (or by `set`/`set_zero`), so it may alias `p` or `q`. -/
def fd_bn254_g1_affine_add.spec (B : Backend) (r p q : fd_bn254_g1_t) : fd_bn254_g1_t :=
  if fd_bn254_g1_is_zero.spec p ≠ 0 then fd_bn254_g1_set.spec q else
  if fd_bn254_g1_is_zero.spec q ≠ 0 then fd_bn254_g1_set.spec p else
  let lambda? : Option fd_bn254_fp_t :=
    if fd_bn254_fp_eq.spec p.X q.X ≠ 0 then
      if fd_bn254_fp_eq.spec p.Y q.Y ≠ 0 then
        let x := fd_bn254_fp_sqr.spec p.X
        let y := fd_bn254_fp_add.spec x x
        let x := fd_bn254_fp_add.spec x y
        let y := fd_bn254_fp_add.spec p.Y p.Y
        let lambda := B.fp_inv y
        let lambda := fd_bn254_fp_mul.spec lambda x
        some lambda
      else none
    else
      let x := fd_bn254_fp_sub.spec p.X q.X
      let y := fd_bn254_fp_sub.spec p.Y q.Y
      let lambda := B.fp_inv x
      let lambda := fd_bn254_fp_mul.spec lambda y
      some lambda
  match lambda? with
  | none => fd_bn254_g1_set_zero.spec r
  | some lambda =>
  let x := fd_bn254_fp_sqr.spec lambda
  let x := fd_bn254_fp_sub.spec x p.X
  let x := fd_bn254_fp_sub.spec x q.X
  let y := fd_bn254_fp_sub.spec p.X x
  let y := fd_bn254_fp_mul.spec y lambda
  let y := fd_bn254_fp_sub.spec y p.Y
  ⟨fd_bn254_fp_set.spec x, fd_bn254_fp_set.spec y, fd_bn254_fp_set_one.spec⟩

/-- `fd_bn254_g1_dbl` (`fd_bn254_g1.c:132`), dbl-2009-l. `r->X` is stored before `p->Y`, `p->Z`
are last read, but no field of `p` is read after the same field of `r` is stored, so `r` may
alias `p` (both call sites pass `r == p`). -/
def fd_bn254_g1_dbl.spec (r p : fd_bn254_g1_t) : fd_bn254_g1_t :=
  if fd_bn254_g1_is_zero.spec p ≠ 0 then fd_bn254_g1_set_zero.spec r else
  let a := fd_bn254_fp_sqr.spec p.X
  let b := fd_bn254_fp_sqr.spec p.Y
  let c := fd_bn254_fp_sqr.spec b
  let d := fd_bn254_fp_mul.spec p.X b
  let d := fd_bn254_fp_add.spec d d
  let d := fd_bn254_fp_add.spec d d
  let e := fd_bn254_fp_add.spec a a
  let e := fd_bn254_fp_add.spec a e
  let f := fd_bn254_fp_sqr.spec e
  let r_X := fd_bn254_fp_add.spec d d
  let r_X := fd_bn254_fp_sub.spec f r_X
  let r_Z := fd_bn254_fp_mul.spec p.Y p.Z
  let r_Z := fd_bn254_fp_add.spec r_Z r_Z
  let r_Y := fd_bn254_fp_sub.spec d r_X
  let r_Y := fd_bn254_fp_mul.spec e r_Y
  let c := fd_bn254_fp_add.spec c c
  let c := fd_bn254_fp_add.spec c c
  let c := fd_bn254_fp_add.spec c c
  let r_Y := fd_bn254_fp_sub.spec r_Y c
  ⟨r_X, r_Y, r_Z⟩

/-- `fd_bn254_g1_add_mixed` (`fd_bn254_g1.c:187`), madd-2007-bl, `q` assumed affine (not
checked). `q` is fully read before `r` is stored, and each field of `p` is read before the same
field of `r` is stored, so `r` may alias `p` (every call site passes `r == p`) or `q`. -/
def fd_bn254_g1_add_mixed.spec (r p q : fd_bn254_g1_t) : fd_bn254_g1_t :=
  if fd_bn254_g1_is_zero.spec p ≠ 0 then fd_bn254_g1_set.spec q else
  let zz := fd_bn254_fp_sqr.spec p.Z
  let u2 := fd_bn254_fp_mul.spec q.X zz
  let s2 := fd_bn254_fp_mul.spec q.Y p.Z
  let s2 := fd_bn254_fp_mul.spec s2 zz
  if fd_bn254_fp_eq.spec u2 p.X ≠ 0 ∧ fd_bn254_fp_eq.spec s2 p.Y ≠ 0 then
    fd_bn254_g1_dbl.spec r p
  else
  let h := fd_bn254_fp_sub.spec u2 p.X
  let hh := fd_bn254_fp_sqr.spec h
  let i := fd_bn254_fp_add.spec hh hh
  let i := fd_bn254_fp_add.spec i i
  let j := fd_bn254_fp_mul.spec h i
  let rr := fd_bn254_fp_sub.spec s2 p.Y
  let rr := fd_bn254_fp_add.spec rr rr
  let v := fd_bn254_fp_mul.spec p.X i
  let r_X := fd_bn254_fp_sqr.spec rr
  let r_X := fd_bn254_fp_sub.spec r_X j
  let r_X := fd_bn254_fp_sub.spec r_X v
  let r_X := fd_bn254_fp_sub.spec r_X v
  let i := fd_bn254_fp_mul.spec p.Y j
  let i := fd_bn254_fp_add.spec i i
  let r_Y := fd_bn254_fp_sub.spec v r_X
  let r_Y := fd_bn254_fp_mul.spec r_Y rr
  let r_Y := fd_bn254_fp_sub.spec r_Y i
  let r_Z := fd_bn254_fp_add.spec p.Z h
  let r_Z := fd_bn254_fp_sqr.spec r_Z
  let r_Z := fd_bn254_fp_sub.spec r_Z zz
  let r_Z := fd_bn254_fp_sub.spec r_Z hh
  ⟨r_X, r_Y, r_Z⟩

/-- `int k1b = !!fd_uint256_bit( k1, i )` (and `k2b`). -/
def fd_bn254_g1_scalar_mul.bits (k1 k2_abs : fd_uint256_t) (i : Nat) (h : i < 256) :
    BitVec 32 × BitVec 32 :=
  ((if fd_uint256_bit.spec k1 i h ≠ 0 then 1 else 0),
    (if fd_uint256_bit.spec k2_abs i h ≠ 0 then 1 else 0))

/-- The first loop `for( ; i>=0; i-- )` from `i`: the first `i` with `k1b || k2b`, `none` if it
runs out (`i < 0`). -/
def fd_bn254_g1_scalar_mul.top (k1 k2_abs : fd_uint256_t) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, h =>
    let (k1b, k2b) := fd_bn254_g1_scalar_mul.bits k1 k2_abs 0 h
    if k1b ≠ 0 ∨ k2b ≠ 0 then some ⟨0, h⟩ else none
  | i + 1, h =>
    let (k1b, k2b) := fd_bn254_g1_scalar_mul.bits k1 k2_abs (i + 1) h
    if k1b ≠ 0 ∨ k2b ≠ 0 then some ⟨i + 1, h⟩ else fd_bn254_g1_scalar_mul.top k1 k2_abs i (by omega)

/-- One iteration `i` of the Shamir loop: double, then add `pt12`, `p` or `pt2`. -/
def fd_bn254_g1_scalar_mul.step (p pt2 pt12 : fd_bn254_g1_t) (k1 k2_abs : fd_uint256_t)
    (r : fd_bn254_g1_t) (i : Nat) (h : i < 256) : fd_bn254_g1_t :=
  let r := fd_bn254_g1_dbl.spec r r
  let (k1b, k2b) := fd_bn254_g1_scalar_mul.bits k1 k2_abs i h
  if k1b ≠ 0 ∧ k2b ≠ 0 then fd_bn254_g1_add_mixed.spec r r pt12
  else if k1b ≠ 0 then fd_bn254_g1_add_mixed.spec r r p
  else if k2b ≠ 0 then fd_bn254_g1_add_mixed.spec r r pt2
  else r

/-- The Shamir loop `for( i--; i >= 0; i-- )` entered with `i = n`: iterations `n-1` down to
`0`. -/
def fd_bn254_g1_scalar_mul.loop (p pt2 pt12 : fd_bn254_g1_t) (k1 k2_abs : fd_uint256_t)
    (r : fd_bn254_g1_t) : (n : Nat) → n ≤ 256 → fd_bn254_g1_t
  | 0, _ => r
  | i + 1, h =>
    fd_bn254_g1_scalar_mul.loop p pt2 pt12 k1 k2_abs
      (fd_bn254_g1_scalar_mul.step p pt2 pt12 k1 k2_abs r i (by omega)) i (by omega)

/-- `fd_bn254_g1_scalar_mul` (`fd_bn254_g1.c:250`): `[s]p` by GLV and Shamir's trick, `s` not
reduced, `p` assumed affine. `r` is the point before the call; `pt12` starts uninitialized
(`default`). `p` must not alias `r` (the syscall passes distinct `r`, `a`). -/
def fd_bn254_g1_scalar_mul.spec (B : Backend) (r p : fd_bn254_g1_t) (s : fd_bn254_scalar_t) :
    fd_bn254_g1_t :=
  if fd_uint256_is_zero.spec s ≠ 0 ∨ fd_bn254_g1_is_zero.spec p ≠ 0 then
    fd_bn254_g1_set_zero.spec r
  else
  let b1 := fd_bn254_glv_sxg3.spec s g1_const_g1
  let b2 := fd_bn254_glv_sxg2.spec s g2_const
  -- k1 = s - b1*N_A - b2*N_B
  let p11 := fd_bn254_glv_mul3x2.spec b1 na
  let p21 : Vector (BitVec 64) 4 := #v[0, 0, 0, 0]
  let o := fd_bn254_glv_mul2x1.spec b2 nb
  let p21 := #v[o[0], o[1], o[2], p21[3]]
  let (t, _) := fd_bn254_glv_add4.spec p11 p21
  let (k1, _) := fd_bn254_glv_sub4.spec s t
  -- k2 = b1*N_B - b2*N_C
  let k2_neg : BitVec 32 := 0
  let pos := fd_bn254_glv_mul3x1.spec b1 nb
  let neg := fd_bn254_glv_mul2x2.spec b2 nc
  let (k2_abs, borrow) := fd_bn254_glv_sub4.spec pos neg
  let (k2_neg, k2_abs) :=
    if borrow ≠ 0 then ((1 : BitVec 32), fd_bn254_glv_negate4.spec k2_abs) else (k2_neg, k2_abs)
  -- pt2 = phi(P) = (beta * P.x, P.y), negated if k2 < 0
  let pt2_X := fd_bn254_fp_mul.spec p.X fd_bn254_const_beta_mont
  let pt2_Y := fd_bn254_fp_set.spec p.Y
  let pt2_Z := fd_bn254_fp_set_one.spec
  let pt2_Y := if k2_neg ≠ 0 then fd_bn254_fp_neg.spec pt2_Y else pt2_Y
  let pt2 : fd_bn254_g1_t := ⟨pt2_X, pt2_Y, pt2_Z⟩
  let pt12 := fd_bn254_g1_affine_add.spec B default p pt2
  match fd_bn254_g1_scalar_mul.top k1 k2_abs 255 (by omega) with
  | none => fd_bn254_g1_set_zero.spec r
  | some i =>
    let (k1b, k2b) := fd_bn254_g1_scalar_mul.bits k1 k2_abs i.val i.isLt
    let r := fd_bn254_g1_set.spec (if k1b ≠ 0 ∧ k2b ≠ 0 then pt12 else if k1b ≠ 0 then p else pt2)
    fd_bn254_g1_scalar_mul.loop p pt2 pt12 k1 k2_abs r i.val (by omega)

/-- What `fd_bn254_g1_frombytes_internal` does: `p` after the call, and its return, `some p` or
`none` for `NULL`. -/
structure fd_bn254_g1_frombytes_internal.Result where
  p : fd_bn254_g1_t
  ret : Option fd_bn254_g1_t
deriving Repr

/-- `fd_bn254_g1_frombytes_internal` (`fd_bn254_g1.c:333`): `x`, `y` not Montgomery, `x, y < p`
(after masking `y`'s flag bits), no curve check. `p` is the point before the call. -/
def fd_bn254_g1_frombytes_internal.spec (p : fd_bn254_g1_t) (in_ : Vector (BitVec 8) 64)
    (big_endian : BitVec 32) : fd_bn254_g1_frombytes_internal.Result :=
  let zero : Vector (BitVec 8) 64 := Vector.replicate 64 0
  if fd_memeq in_ zero ≠ 0 then
    let p := fd_bn254_g1_set_zero.spec p
    ⟨p, some p⟩
  else
  let x := fd_bn254_fp_frombytes_nm.spec p.X (loadBytes in_ 0 32) big_endian none
  let p := { p with X := x.r }
  match x.ret with
  | none => ⟨p, none⟩
  | some _ =>
  -- `int is_inf, is_neg;` uninitialized, always stored by the call.
  let y := fd_bn254_fp_frombytes_nm.spec p.Y (loadBytes in_ 32 32) big_endian (some (0, 0))
  let p := { p with Y := y.r }
  match y.ret with
  | none => ⟨p, none⟩
  | some _ =>
  let (is_inf, _is_neg) := y.flags.getD (0, 0)
  if is_inf ≠ 0 then
    let p := fd_bn254_g1_set_zero.spec p
    ⟨p, some p⟩
  else
  let p := { p with Z := fd_bn254_fp_set_one.spec }
  ⟨p, some p⟩

/-- What `fd_bn254_g1_frombytes_check_subgroup` does: `p` after the call, and its return. -/
structure fd_bn254_g1_frombytes_check_subgroup.Result where
  p : fd_bn254_g1_t
  ret : Option fd_bn254_g1_t
deriving Repr

/-- `fd_bn254_g1_frombytes_check_subgroup` (`fd_bn254_g1.c:363`): `frombytes_internal`, then
(unless zero) Montgomery form, `Z = 1`, and the curve equation `y^2 = x^3 + 3`; no subgroup
check beyond that ("G1 has prime order"). -/
def fd_bn254_g1_frombytes_check_subgroup.spec (p : fd_bn254_g1_t) (in_ : Vector (BitVec 8) 64)
    (big_endian : BitVec 32) : fd_bn254_g1_frombytes_check_subgroup.Result :=
  let res := fd_bn254_g1_frombytes_internal.spec p in_ big_endian
  let p := res.p
  match res.ret with
  | none => ⟨p, none⟩
  | some _ =>
  if fd_bn254_g1_is_zero.spec p ≠ 0 then ⟨p, some p⟩ else
  let p := { p with X := fd_bn254_fp_to_mont.spec p.X }
  let p := { p with Y := fd_bn254_fp_to_mont.spec p.Y }
  let p := { p with Z := fd_bn254_fp_set_one.spec }
  let y2 := fd_bn254_fp_sqr.spec p.Y
  let x3b := fd_bn254_fp_sqr.spec p.X
  let x3b := fd_bn254_fp_mul.spec x3b p.X
  let x3b := fd_bn254_fp_add.spec x3b fd_bn254_const_b_mont
  if fd_bn254_fp_eq.spec y2 x3b = 0 then ⟨p, none⟩ else
  ⟨p, some p⟩

end

end Firedancer.Bn254

module

public import Mathlib.Logic.Function.Iterate
public import Firedancer.Secp256k1.Private

/-! `fd_secp256k1_point.c`: square root and group law, shared by both backends; every def takes
the backend `B` the C includes before it. A point function's value is the point it stores at
`r`. Uninitialized locals start as `0`/`default` and are written before they are read; array
indices are in bounds by `get_elem_tactic`. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-- What `fd_secp256k1_fp_sqrt` does: the limbs it stores at `r` (on both paths), and its return,
`some r` or `none` for `NULL`. -/
structure fd_secp256k1_fp_sqrt.Result where
  r : fd_secp256k1_fp_t
  ret : Option fd_secp256k1_fp_t

/-- `fd_secp256k1_fp_sqrt` (`fd_secp256k1_point.c:41`): `a^((p+1)/4)` by an addition chain,
`NULL` unless its square is `a`. `r` and `a` are `restrict`. Each `for( int j=0; j<k; j++ )
fd_secp256k1_fp_sqr( &x, &x )` is `k` iterations of `B.fp_sqr`. -/
def fd_secp256k1_fp_sqrt.spec (B : Backend) (a : fd_secp256k1_fp_t) : fd_secp256k1_fp_sqrt.Result :=
  let x2 := B.fp_sqr a
  let x2 := B.fp_mul x2 a
  let x3 := B.fp_sqr x2
  let x3 := B.fp_mul x3 a
  let x6 := x3
  let x6 := B.fp_sqr^[3] x6
  let x6 := B.fp_mul x6 x3
  let x9 := x6
  let x9 := B.fp_sqr^[3] x9
  let x9 := B.fp_mul x9 x3
  let x11 := x9
  let x11 := B.fp_sqr^[2] x11
  let x11 := B.fp_mul x11 x2
  let x22 := x11
  let x22 := B.fp_sqr^[11] x22
  let x22 := B.fp_mul x22 x11
  let x44 := x22
  let x44 := B.fp_sqr^[22] x44
  let x44 := B.fp_mul x44 x22
  let x88 := x44
  let x88 := B.fp_sqr^[44] x88
  let x88 := B.fp_mul x88 x44
  let x176 := x88
  let x176 := B.fp_sqr^[88] x176
  let x176 := B.fp_mul x176 x88
  let x220 := x176
  let x220 := B.fp_sqr^[44] x220
  let x220 := B.fp_mul x220 x44
  let x223 := x220
  let x223 := B.fp_sqr^[3] x223
  let x223 := B.fp_mul x223 x3
  let t1 := x223
  let t1 := B.fp_sqr^[23] t1
  let t1 := B.fp_mul t1 x22
  let t1 := B.fp_sqr^[6] t1
  let t1 := B.fp_mul t1 x2
  let t1 := B.fp_sqr t1
  let r := B.fp_sqr t1
  let t1 := B.fp_sqr r
  if B.fp_eq t1 a = 0#32 then ⟨r, none⟩ else ⟨r, some r⟩

/-- `fd_secp256k1_point_set_identity` (`fd_secp256k1_point.c:109`). -/
def fd_secp256k1_point_set_identity.spec (B : Backend) : fd_secp256k1_point_t :=
  ⟨B.fp_set fd_secp256k1_const_zero, B.fp_set fd_secp256k1_const_one_mont,
    B.fp_set fd_secp256k1_const_zero⟩

/-- `fd_secp256k1_point_set_base` (`fd_secp256k1_point.c:117`). -/
def fd_secp256k1_point_set_base.spec (B : Backend) : fd_secp256k1_point_t :=
  ⟨B.fp_set fd_secp256k1_const_base_x_mont, B.fp_set fd_secp256k1_const_base_y_mont,
    B.fp_set fd_secp256k1_const_one_mont⟩

/-- `fd_secp256k1_point_set` (`fd_secp256k1_point.c:125`). -/
def fd_secp256k1_point_set.spec (B : Backend) (a : fd_secp256k1_point_t) : fd_secp256k1_point_t :=
  ⟨B.fp_set a.x, B.fp_set a.y, B.fp_set a.z⟩

/-- `fd_secp256k1_point_add` (`fd_secp256k1_point.c:134`), eprint 2015/1060 Algorithm 7. `a` and
`b` are fully read before the first store to `r` (line 203), so `r` may alias either. -/
def fd_secp256k1_point_add.spec (B : Backend) (a b : fd_secp256k1_point_t) :
    fd_secp256k1_point_t :=
  let t0 := B.fp_mul a.x b.x
  let t1 := B.fp_mul a.y b.y
  let t2 := B.fp_mul a.z b.z
  let t3 := B.fp_add a.x a.y
  let t4 := B.fp_add b.x b.y
  let t3 := B.fp_mul t3 t4
  let t4 := B.fp_add t0 t1
  let t3 := B.fp_sub t3 t4
  let t4 := B.fp_add a.y a.z
  let X3 := B.fp_add b.y b.z
  let t4 := B.fp_mul t4 X3
  let X3 := B.fp_add t1 t2
  let t4 := B.fp_sub t4 X3
  let X3 := B.fp_add a.x a.z
  let Y3 := B.fp_add b.x b.z
  let X3 := B.fp_mul X3 Y3
  let Y3 := B.fp_add t0 t2
  let Y3 := B.fp_sub X3 Y3
  let t0 := B.fp_triple t0
  let t2_4 := B.fp_dbl t2
  let t2_4 := B.fp_dbl t2_4
  let t5 := B.fp_dbl t2_4
  let t5 := B.fp_dbl t5
  let t5 := B.fp_add t5 t2_4
  let t2 := B.fp_add t5 t2
  let Z3 := B.fp_add t1 t2
  let t1 := B.fp_sub t1 t2
  let Y3_4 := B.fp_dbl Y3
  let Y3_4 := B.fp_dbl Y3_4
  let t5 := B.fp_dbl Y3_4
  let t5 := B.fp_dbl t5
  let t5 := B.fp_add t5 Y3_4
  let Y3 := B.fp_add t5 Y3
  let X3 := B.fp_mul t4 Y3
  let t2 := B.fp_mul t3 t1
  let r_x := B.fp_sub t2 X3
  let Y3 := B.fp_mul Y3 t0
  let t1 := B.fp_mul t1 Z3
  let r_y := B.fp_add t1 Y3
  let t0 := B.fp_mul t0 t3
  let Z3 := B.fp_mul Z3 t4
  let r_z := B.fp_add Z3 t0
  ⟨r_x, r_y, r_z⟩

/-- `fd_secp256k1_point_dbl` (`fd_secp256k1_point.c:216`), eprint 2015/1060 Algorithm 9. `r->z`
is stored (line 253) before `a->x`, `a->y` are last read (line 260); for `r = a` those are still
the inputs, so `r` may alias `a`. -/
def fd_secp256k1_point_dbl.spec (B : Backend) (a : fd_secp256k1_point_t) : fd_secp256k1_point_t :=
  let t0 := B.fp_sqr a.y
  let Z3 := B.fp_dbl t0
  let Z3 := B.fp_dbl Z3
  let Z3 := B.fp_dbl Z3
  let t1 := B.fp_mul a.y a.z
  let t2 := B.fp_sqr a.z
  let t2_4 := B.fp_dbl t2
  let t2_4 := B.fp_dbl t2_4
  let t5 := B.fp_dbl t2_4
  let t5 := B.fp_dbl t5
  let t5 := B.fp_add t5 t2_4
  let t2 := B.fp_add t5 t2
  let X3 := B.fp_mul t2 Z3
  let Y3 := B.fp_add t0 t2
  let r_z := B.fp_mul t1 Z3
  let t1 := B.fp_dbl t2
  let t2 := B.fp_add t1 t2
  let t0 := B.fp_sub t0 t2
  let Y3 := B.fp_mul t0 Y3
  let t1 := B.fp_mul a.x a.y
  let r_y := B.fp_add X3 Y3
  let X3 := B.fp_mul t0 t1
  let r_x := B.fp_dbl X3
  ⟨r_x, r_y, r_z⟩

/-- `fd_secp256k1_point_neg` (`fd_secp256k1_point.c:271`). -/
def fd_secp256k1_point_neg.spec (B : Backend) (a : fd_secp256k1_point_t) : fd_secp256k1_point_t :=
  let r_x := B.fp_set a.x
  let r_z := B.fp_set a.z
  let r_y := B.fp_negate a.y
  ⟨r_x, r_y, r_z⟩

/-- `fd_secp256k1_point_sub` (`fd_secp256k1_point.c:281`). -/
def fd_secp256k1_point_sub.spec (B : Backend) (a b : fd_secp256k1_point_t) :
    fd_secp256k1_point_t :=
  let tmp := fd_secp256k1_point_neg.spec B b
  fd_secp256k1_point_add.spec B a tmp

/-- `fd_secp256k1_slide` (`fd_secp256k1_point.c:292`): the 65 `schar` digits it stores at `r`.
`int` arithmetic is on `BitVec 32`, `(schar)` truncates (GCC), `>>` on `int` is arithmetic. -/
def fd_secp256k1_slide.spec (s : Vector (BitVec 8) 32) : Vector (BitVec 8) 65 :=
  let r : Vector (BitVec 8) 65 := Vector.replicate 65 0
  -- for( ulong i=0UL; i<32UL; i++ )
  let r := Nat.fold 32 (fun i hi r =>
    let x := s[i]
    let r := r.set (i * 2 + 0) ((x.setWidth 32 &&& 0xF#32).setWidth 8)
    r.set (i * 2 + 1) (((x.setWidth 32).sshiftRight 4 &&& 0xF#32).setWidth 8))
    r
  let carry : BitVec 8 := 0
  -- for( ulong i=0UL; i<64UL; i++ )
  let st := Nat.fold 64 (fun i hi (st : Vector (BitVec 8) 65 × BitVec 8) =>
    let r := st.1
    let carry := st.2
    let r := r.set i ((r[i].signExtend 32 + carry.signExtend 32).setWidth 8)
    let carry := (((r[i].signExtend 32 + 8#32).setWidth 8).signExtend 32).sshiftRight 4 |>.setWidth 8
    let r := r.set i ((r[i].signExtend 32 - carry.signExtend 32 * 16#32).setWidth 8)
    (r, carry)) (r, carry)
  let r := st.1
  let carry := st.2
  r.set 64 carry

/-- `fd_secp256k1_precompute` (`fd_secp256k1_point.c:313`): the 9 points it stores at `r`;
`a` is not in `r`. -/
def fd_secp256k1_precompute.spec (B : Backend) (a : fd_secp256k1_point_t) :
    Vector fd_secp256k1_point_t 9 :=
  let r : Vector fd_secp256k1_point_t 9 := Vector.replicate 9 default
  let r := r.set 0 (fd_secp256k1_point_set_identity.spec B)
  let r := r.set 1 (fd_secp256k1_point_set.spec B a)
  -- for( ulong i=2UL; i<=8UL; i++ ), the k-th iteration
  Nat.fold 7 (fun k hk r =>
    let i := k + 2
    if i % 2 ≠ 0 then r.set i (fd_secp256k1_point_add.spec B r[i - 1] a)
    else r.set i (fd_secp256k1_point_dbl.spec B r[i / 2]))
    r

/-- Reading `pc[i]` of a 9-point table out of bounds (undefined behavior). -/
opaque fd_secp256k1_point_table_oob_unspec :
  Vector fd_secp256k1_point_t 9 → BitVec 64 → fd_secp256k1_point_t

/-- `pc[ i ]` for a `ulong` index into `fd_secp256k1_point_t pc[ 9 ]`. -/
def fd_secp256k1_point_table_read (pc : Vector fd_secp256k1_point_t 9) (i : BitVec 64) :
    fd_secp256k1_point_t :=
  if h : i.toNat < 9 then pc[i.toNat] else fd_secp256k1_point_table_oob_unspec pc i

/-- The loop of `fd_secp256k1_double_base_mul` (`fd_secp256k1_point.c:348`) from `pos` down,
with `r` its current value: `for( int pos = 2 * 32; ; pos -= 1 )`, `break` at `pos == 0`. -/
def fd_secp256k1_double_base_mul.loop (B : Backend) (pc1 pc2 : Vector fd_secp256k1_point_t 9)
    (e1 e2 : Vector (BitVec 8) 65) : (pos : Nat) → pos ≤ 64 → fd_secp256k1_point_t →
    fd_secp256k1_point_t
  | pos, h, r =>
    let slot1 := e1[pos]
    let r :=
      if (0#32).slt (slot1.signExtend 32) then
        fd_secp256k1_point_add.spec B r (fd_secp256k1_point_table_read pc1 (slot1.signExtend 64))
      else if (slot1.signExtend 32).slt 0#32 then
        fd_secp256k1_point_sub.spec B r
          (fd_secp256k1_point_table_read pc1 ((-(slot1.signExtend 32)).signExtend 64))
      else r
    let slot2 := e2[pos]
    let r :=
      if (0#32).slt (slot2.signExtend 32) then
        fd_secp256k1_point_add.spec B r (fd_secp256k1_point_table_read pc2 (slot2.signExtend 64))
      else if (slot2.signExtend 32).slt 0#32 then
        fd_secp256k1_point_sub.spec B r
          (fd_secp256k1_point_table_read pc2 ((-(slot2.signExtend 32)).signExtend 64))
      else r
    match pos, h with
    | 0, _ => r
    | pos + 1, h =>
      let r := fd_secp256k1_point_dbl.spec B r
      let r := fd_secp256k1_point_dbl.spec B r
      let r := fd_secp256k1_point_dbl.spec B r
      let r := fd_secp256k1_point_dbl.spec B r
      fd_secp256k1_double_base_mul.loop B pc1 pc2 e1 e2 pos (by omega) r

/-- `fd_secp256k1_double_base_mul` (`fd_secp256k1_point.c:329`): `s1 G + s2 p2`, the point stored
at `r`; `r` is written before it is read and is distinct from `p2`. -/
def fd_secp256k1_double_base_mul.spec (B : Backend) (s1 : fd_secp256k1_scalar_t)
    (p2 : fd_secp256k1_point_t) (s2 : fd_secp256k1_scalar_t) : fd_secp256k1_point_t :=
  let base := fd_secp256k1_point_set_base.spec B
  let pc1 := fd_secp256k1_precompute.spec B base
  let pc2 := fd_secp256k1_precompute.spec B p2
  let e1 := fd_secp256k1_slide.spec s1.buf
  let e2 := fd_secp256k1_slide.spec s2.buf
  let r := fd_secp256k1_point_set_identity.spec B
  fd_secp256k1_double_base_mul.loop B pc1 pc2 e1 e2 64 (by omega) r

/-- `fd_secp256k1_point_to_affine` (`fd_secp256k1_point.c:374`): stores `x` and `y` of `r`, keeps
`r->z`. `a->y` is read after `r->x` is stored, which for `r = a` is still the input. -/
def fd_secp256k1_point_to_affine.spec (B : Backend) (r a : fd_secp256k1_point_t) :
    fd_secp256k1_point_t :=
  let z := B.fp_invert a.z
  let r := { r with x := B.fp_mul a.x z }
  { r with y := B.fp_mul a.y z }

/-- `fd_secp256k1_point_is_identity` (`fd_secp256k1_point.c:384`): `int` `&` and `|` of `fp_eq`
flags. -/
def fd_secp256k1_point_is_identity.spec (B : Backend) (a : fd_secp256k1_point_t) : BitVec 32 :=
  let affine :=
    B.fp_eq a.x fd_secp256k1_const_zero &&&
      (B.fp_eq a.y fd_secp256k1_const_zero ||| B.fp_eq a.y fd_secp256k1_const_one_mont)
  B.fp_eq a.z fd_secp256k1_const_zero ||| affine

end

end Firedancer.Secp256k1

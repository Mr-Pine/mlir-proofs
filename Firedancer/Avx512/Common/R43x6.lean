module

public import Firedancer.Avx512.Common.Wwl

/-! The `fd_r43x6_t` constants and inline macros of `fd_r43x6.h`, over `Wwl`: a field element as
six radix-`2^43` limbs in lanes 0-5. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

/-- `(1L<<43)-1L`. -/
abbrev m43 : BitVec 64 :=
  8796093022207#64

/-- `(1L<<40)-1L`. -/
abbrev m40 : BitVec 64 :=
  1099511627775#64

/-- `fd_r43x6_p()`: the limbs of `p = 2^255 - 19`. -/
def fd_r43x6_p : Wwl :=
  wwl 8796093022189#64 m43 m43 m43 m43 m40 0 0

/-- `fd_r43x6_zero()`. -/
def fd_r43x6_zero : Wwl :=
  wwl_zero

/-- `fd_r43x6_add_fast(x, y)`. -/
def fd_r43x6_add_fast (x y : Wwl) : Wwl :=
  wwl_add x y

/-- `fd_r43x6_sub_fast(x, y)`: `x + (p - y)`. -/
def fd_r43x6_sub_fast (x y : Wwl) : Wwl :=
  wwl_add x (wwl_sub fd_r43x6_p y)

/-- `fd_r43x6_neg_fast(x)`: `p - x`. -/
def fd_r43x6_neg_fast (x : Wwl) : Wwl :=
  wwl_sub fd_r43x6_p x

/-- `fd_r43x6_approx_carry_propagate(x)`, the shift-and-add implementation. -/
def fd_r43x6_approx_carry_propagate (x : Wwl) : Wwl :=
  let _xl := wwl_and x (wwl m43 m43 m43 m43 m43 m40 0 0)
  let _xh := wwl_shr_vector x (wwl 43 43 43 43 43 40 0 0)
  let _c := wwl_select (wwl 5 0 1 2 3 4 8 8) _xh wwl_zero
  let _d := wwl_and (wwl_add (wwl_shl _c 1) (wwl_shl _c 4)) (wwl (-1) 0 0 0 0 0 0 0)
  wwl_add (wwl_add _xl _c) _d

/-- `fd_r43x6_fold_signed(x)`: the carry propagate of `x - _b`, plus `_b`, with
`_b = <19<<23, 1<<20, …, 1<<20, 0, 0>`. -/
def fd_r43x6_fold_signed (x : Wwl) : Wwl :=
  let _b := wwl 159383552 1048576 1048576 1048576 1048576 1048576 0 0
  wwl_add (fd_r43x6_approx_carry_propagate (wwl_sub x _b)) _b

/-- `fd_r43x6_fold_unsigned(x)`: the carry propagate by `madd52lo`, for lanes below `2^63`. -/
def fd_r43x6_fold_unsigned (x : Wwl) : Wwl :=
  wwl_madd52lo (wwl_and x (wwl m43 m43 m43 m43 m43 m40 0 0)) (wwl 19 1 1 1 1 1 0 0)
    (wwl_permute (wwl 5 0 1 2 3 4 6 7) (wwl_shru_vector x (wwl 43 43 43 43 43 40 0 0)))

end

end LeanMLIR.RIR.Firedancer.Avx512

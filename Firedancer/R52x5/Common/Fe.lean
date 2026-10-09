module

public import Firedancer.Avx512.Common.Wwl

/-! A field element `fd_f25519_t` of the r52x5 backend: one `wwl_t`, lanes 0-4 the radix-2^51 limbs,
lanes 5-7 zero; `fd_f25519_fold_unsigned` and the bias of `fd_f25519_sub` and `fd_f25519_neg`. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

open Firedancer.Avx512

/-- The limbs of a field element: its lanes 0-4. -/
def limbs (x : Wwl) : Fin 5 → BitVec 64 := fun i => x[i.val]

/-- The field element of five limbs, lanes 5-7 zero. -/
def ofLimbs (l : Fin 5 → BitVec 64) : Wwl :=
  wwl (l 0) (l 1) (l 2) (l 3) (l 4) 0 0 0

/-- `FD_F25519_LIMB_MASK`, `2^51 - 1`. -/
abbrev mask51 : BitVec 64 :=
  2251799813685247

/-- `fd_f25519_fold_unsigned`'s `mask`. -/
def foldMask : Wwl :=
  wwl mask51 mask51 mask51 mask51 mask51 0 0 0

/-- `fd_f25519_fold_unsigned`'s `shift`. -/
def foldShift : Wwl :=
  wwl 51 51 51 51 51 0 0 0

/-- `fd_f25519_fold_unsigned`'s `perm`. -/
def foldPerm : Wwl :=
  wwl 4 0 1 2 3 5 6 7

/-- `fd_f25519_fold_unsigned`'s `scale`. -/
def foldScale : Wwl :=
  wwl 19 1 1 1 1 0 0 0

/-- `fd_f25519_fold_unsigned(x)`: each limb's carry above bit 51 into the next, limb 4's times 19
into limb 0. -/
def fold (x : Wwl) : Wwl :=
  let carry := wwl_shru_vector x foldShift
  let rotated := wwl_permute foldPerm carry
  wwl_madd52lo (wwl_and x foldMask) foldScale rotated

/-- `fd_f25519_sub`'s and `fd_f25519_neg`'s `bias`, `16 p`. -/
def bias16p : Wwl :=
  wwl 0x7ffffffffffed0 0x7ffffffffffff0 0x7ffffffffffff0 0x7ffffffffffff0 0x7ffffffffffff0 0 0 0

end

end MLIR.Firedancer.R52x5

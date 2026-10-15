module

public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base

namespace MLIR.Firedancer.Ref

/-! ## Specification

The slides are `fd_curve25519_scalar_wnaf.wnaf`'s digits, as `Int`s. The table `ai` and a digit's
add are `fd_ed25519_double_scalar_mul_base`'s `aiTable` and `add1` (the same C lines). -/

@[expose] public section

namespace fd_ed25519_scalar_mul

/-- `for( i=255; i>=0; i-- ) { if( nslide[i] ) break; }` from `i` down: the `i` it stops at, if
any. -/
def start (w : Vector Int 256) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, _ => if w[0] = 0 then none else some 0
  | i + 1, h => if w[i + 1] = 0 then start w i (by omega) else some ⟨i + 1, h⟩

/-- The main loop from `i` down to `0` on `r`: `t = partial_dbl( r )` and `nslide[i]`'s add, then
`r` from `t` by the final multiplication, projective (keeping `r->T`) unless `i == 0`. -/
def ladder (ai : Nat → PointLimbs) (w : Vector Int 256) :
    (i : Nat) → i < 256 → PointLimbs → PointLimbs
  | 0, _, r =>
    fd_ed25519_point_add_final_mul.spec (fd_ed25519_double_scalar_mul_base.add1 ai w[0] r).2
  | i + 1, h, r =>
    let rt := fd_ed25519_double_scalar_mul_base.add1 ai w[i + 1] r
    ladder ai w i (by omega) (fd_ed25519_point_add_final_mul_projective.spec rt.2 rt.1.T)

end fd_ed25519_scalar_mul

open fd_ed25519_scalar_mul in
/-- `fd_ed25519_scalar_mul` (`ballet/ed25519/fd_curve25519.c:141`). -/
def fd_ed25519_scalar_mul.spec (n : BitVec 256) (A : PointLimbs) : PointLimbs :=
  let nslide := fd_curve25519_scalar_wnaf.wnaf n 4
  let a2 := fd_ed25519_point_dbln.spec A 1
  let ai := fd_ed25519_double_scalar_mul_base.aiTable a2 (fd_curve25519_into_precomputed.spec A)
  let r := fd_ed25519_point_set_zero.spec
  match start nslide 255 (by decide) with
  | some i => ladder ai nslide i i.isLt r
  | none => r

end

end MLIR.Firedancer.Ref

module

public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base

namespace MLIR.Firedancer.Ref

/-! ## Specification

A C array `T x[]` is `x : Nat → T`, `x j` its element `j`; `n j` is the scalar at `&n[32*j]`.
The base point's table `fd_ed25519_base_point_wnaf_table` is a parameter `tbl`, read only when
`base_sz` is nonzero. `nslide[32][256]` and `ai[32][8]` hold `sz ≤ 32` entries (larger `sz`
overflows them, UB, not modelled). -/

@[expose] public section

namespace fd_ed25519_multi_scalar_mul_with_opts

/-- `for( ulong j=base_sz; j<sz; j++ )` at bit `i` on `(r, t)`: `nslide[j][i]`'s add from `ai[j]`. -/
def adds (ai : Nat → Nat → PointLimbs) (nslide : Nat → Vector Int 256) (base_sz sz : BitVec 64)
    (i : Fin 256) (rt : PointLimbs × PointLimbs) : PointLimbs × PointLimbs :=
  (List.range' base_sz.toNat (sz.toNat - base_sz.toNat)).foldl
    (fun rt j =>
      let n := (nslide j)[i]
      fd_ed25519_double_scalar_mul_base.addDigit (ai j) n (if n = 1 then 1#32 else 0#32)
        (if n = -1 then 1#32 else 0#32) rt.1 rt.2)
    rt

/-- An iteration's adds on `r`: `t = partial_dbl( r )`, `nslide[0][i]`'s add from `tbl` (`Z = 1`)
when `base_sz` is nonzero, then `adds`. The new `r` and `t`. -/
def iter (tbl : Nat → PointLimbs) (ai : Nat → Nat → PointLimbs) (nslide : Nat → Vector Int 256)
    (base_sz sz : BitVec 64) (i : Fin 256) (r : PointLimbs) : PointLimbs × PointLimbs :=
  let t := fd_ed25519_partial_dbl.spec r
  let rt :=
    if base_sz ≠ 0#64 then
      fd_ed25519_double_scalar_mul_base.addDigit tbl (nslide 0)[i] 1#32 1#32 r t
    else (r, t)
  adds ai nslide base_sz sz i rt

/-- `for( int i=255; i>=0; i-- )` from `i` down to `0` on `r`; the last multiplication computes
`r->T` only at `i == 0`. -/
def ladder (tbl : Nat → PointLimbs) (ai : Nat → Nat → PointLimbs) (nslide : Nat → Vector Int 256)
    (base_sz sz : BitVec 64) : (i : Nat) → i < 256 → PointLimbs → PointLimbs
  | 0, h, r => fd_ed25519_point_add_final_mul.spec (iter tbl ai nslide base_sz sz ⟨0, h⟩ r).2
  | i + 1, h, r =>
    let rt := iter tbl ai nslide base_sz sz ⟨i + 1, h⟩ r
    ladder tbl ai nslide base_sz sz i (by omega)
      (fd_ed25519_point_add_final_mul_projective.spec rt.2 rt.1.T)

end fd_ed25519_multi_scalar_mul_with_opts

open fd_ed25519_multi_scalar_mul_with_opts in
/-- `fd_ed25519_multi_scalar_mul_with_opts` (`ballet/ed25519/fd_curve25519.c:334`). `nslide j` and
`ai j` are what the precomputation loop leaves (`ai j` set only for `j ≥ base_sz`). -/
def fd_ed25519_multi_scalar_mul_with_opts.spec (tbl : Nat → PointLimbs) (n : Nat → BitVec 256)
    (a : Nat → PointLimbs) (sz base_sz : BitVec 64) : PointLimbs :=
  let nslide : Nat → Vector Int 256 := fun j =>
    if base_sz ≠ 0#64 ∧ j = 0 then fd_curve25519_scalar_wnaf.wnaf (n 0) 8
    else fd_curve25519_scalar_wnaf.wnaf (n j) 4
  let ai : Nat → Nat → PointLimbs := fun j =>
    let a2 := fd_ed25519_point_dbln.spec (a j) 1
    fd_ed25519_double_scalar_mul_base.aiTable a2 (fd_curve25519_into_precomputed.spec (a j))
  ladder tbl ai nslide base_sz sz 255 (by decide) fd_ed25519_point_set_zero.spec

/-- With `base_sz = 0` the base table is not read. -/
theorem fd_ed25519_multi_scalar_mul_with_opts.spec_tbl (tbl tbl' : Nat → PointLimbs)
    (n : Nat → BitVec 256) (a : Nat → PointLimbs) (sz : BitVec 64) :
    fd_ed25519_multi_scalar_mul_with_opts.spec tbl n a sz 0#64 =
      fd_ed25519_multi_scalar_mul_with_opts.spec tbl' n a sz 0#64 := by
  have hiter :
    ∀ ai nslide i r, iter tbl ai nslide 0#64 sz i r = iter tbl' ai nslide 0#64 sz i r := by
    intros; simp [iter]
  have hladder :
    ∀ ai nslide i (h : i < 256) r,
      ladder tbl ai nslide 0#64 sz i h r = ladder tbl' ai nslide 0#64 sz i h r := by
    intro ai nslide i
    induction i with
    | zero =>
      intros; simp only [ladder, hiter]
    | succ i ih =>
      intros; simp only [ladder, hiter, ih]
  simp only [fd_ed25519_multi_scalar_mul_with_opts.spec, hladder]

end

end MLIR.Firedancer.Ref

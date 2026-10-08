module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Globals
public import Firedancer.Ref.fd_curve25519_scalar_wnaf
public import Firedancer.Avx512.fd_ed25519_point_set_zero
public import Firedancer.Avx512.fd_ed25519_partial_dbl
public import Firedancer.Avx512.fd_ed25519_point_dbln
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.Avx512.fd_ed25519_point_sub_with_opts
public import Firedancer.Avx512.fd_curve25519_into_precomputed
public import Firedancer.Avx512.Mlir.fd_ed25519_double_scalar_mul_base

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification

The slides are `fd_curve25519_scalar_wnaf.wnaf`'s digits, as `Int`s. The base point's table is a
parameter `tbl`; the function reads `fd_ed25519_base_point_wnaf_table.point`.
`fd_ed25519_point_add_final_mul` and its projective form copy their point. -/

@[expose] public section

namespace fd_ed25519_double_scalar_mul_base

open Firedancer.Ref

/-- `ai[i]` after the table loop `for( int i=1; i<WNAF_TBL_SZ; i++ )` from `ai[0]` and `a2`:
`t = a2 + ai[i-1]`, then `ai[i]` a copy of `t`, precomputed. -/
def aiTable (a2 ai0 : Quad) : Nat → Quad
  | 0 => ai0
  | i + 1 =>
    let t := fd_ed25519_point_add_with_opts.spec a2 (aiTable a2 ai0 i) 1#32
    fd_curve25519_into_precomputed.spec t

/-- `for( i=255; i>=0; i-- ) if( n1slide[i] || n2slide[i] ) break;` from `i` down: the `i` it
stops at, if any. -/
def start (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, _ => if w1[0] = 0 ∧ w2[0] = 0 then none else some 0
  | i + 1, h =>
    if w1[i + 1] = 0 ∧ w2[i + 1] = 0 then start w1 w2 i (by omega) else some ⟨i + 1, h⟩

/-- A digit's add, `if( d > 0 ) … else if( d < 0 ) …`: `r` a copy of `t`, then `t` as `r` plus or
minus `tbl[|d| / 2]`; nothing at `d = 0`. -/
def addDigit (tbl : Nat → Quad) (d : Int) (r t : Quad) : Quad × Quad :=
  if 0 < d then (t, fd_ed25519_point_add_with_opts.spec t (tbl (d / 2).toNat) 1#32)
  else if d < 0 then (t, fd_ed25519_point_sub_with_opts.spec t (tbl (-d / 2).toNat) 1#32)
  else (r, t)

/-- An iteration's adds on `r`: `t = partial_dbl( r )`, `n1slide[i]`'s add from `ai`, then
`n2slide[i]`'s from `tbl`; the new `r` and `t`. -/
def adds (ai tbl : Nat → Quad) (d1 d2 : Int) (r : Quad) : Quad × Quad :=
  let rt := addDigit ai d1 r (fd_ed25519_partial_dbl.spec r)
  addDigit tbl d2 rt.1 rt.2

/-- The main loop from `i` down to `0` on `r`; each iteration ends with `r` a copy of `t`. -/
def ladder (ai tbl : Nat → Quad) (w1 w2 : Vector Int 256) :
    (i : Nat) → i < 256 → Quad → Quad
  | 0, _, r => (adds ai tbl w1[0] w2[0] r).2
  | i + 1, h, r => ladder ai tbl w1 w2 i (by omega) (adds ai tbl w1[i + 1] w2[i + 1] r).2

/-- `n1 A + n2 B` as the code computes it, `B`'s odd multiples precomputed in `tbl`: the slides,
the table `ai` of `A`'s, then the main loop from the first non-zero digit on the neutral point. -/
def spec (tbl : Nat → Quad) (n1 : BitVec 256) (A : Quad) (n2 : BitVec 256) : Quad :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  let ai :=
    aiTable (fd_ed25519_point_dbln.spec A 1)
      (fd_curve25519_into_precomputed.spec A)
  match start n1slide n2slide 255 (by decide) with
  | some i => ladder ai tbl n1slide n2slide i i.isLt fd_ed25519_point_set_zero.spec
  | none => fd_ed25519_point_set_zero.spec

end fd_ed25519_double_scalar_mul_base

end

end LeanMLIR.RIR.Firedancer.Avx512

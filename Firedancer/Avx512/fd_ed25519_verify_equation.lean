module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Common.QuadMem
public import Firedancer.Common.Tactics
public import Firedancer.Avx512.Globals
public import Firedancer.Avx512.fd_ed25519_point_neg
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base
public import Firedancer.Avx512.fd_ed25519_point_eq_z1
public import Firedancer.Avx512.Mlir.fd_ed25519_verify_equation

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `[k](-A) + [S]B == R` as `fd_ed25519_point_eq_z1` decides it, `tbl` the base point's table. -/
def fd_ed25519_verify_equation.spec (tbl : Nat → Quad) (k : BitVec 256) (A : Quad) (S : BitVec 256)
    (R : Quad) : BitVec 32 :=
  fd_ed25519_point_eq_z1.spec
    (fd_ed25519_double_scalar_mul_base.spec tbl k (fd_ed25519_point_neg.spec A) S) R

/-- `Rcmp`'s block, `double_scalar_mul_base`'s and `point_eq_z1`'s three. -/
def fd_ed25519_verify_equation.blocks (k S : BitVec 256) : Nat :=
  1 + fd_ed25519_double_scalar_mul_base.blocks k S + 3

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_verify_equation` returns `spec` of the scalars at `k`, `S` and the points at `A`,
`R`, and leaves `A` negated. -/
public theorem fd_ed25519_verify_equation.call_eq (k A S R : Pointer) (s : GlobalState) (hwf : s.WF)
    (hk : Fits s.mem k (8 * 32)) (hk_off : ¬k.offset.uaddOverflow 32#64) (hA : s.mem.QuadFit A)
    (hS : Fits s.mem S (8 * 32)) (hS_off : ¬S.offset.uaddOverflow 32#64) (hR : s.mem.QuadFit R)
    (hkA : k.id ≠ A.id) (hSA : S.id ≠ A.id) (hRA : R.id ≠ A.id) :
    fd_ed25519_verify_equation.call
        (fd_ed25519_verify_equation.args (.value k) (.value A) (.value S) (.value R)) s =
      .value
        (.cons
            (.value
              (fd_ed25519_verify_equation.spec fd_ed25519_base_point_wnaf_table.point
                (s.mem.readAt k 256) (s.mem.readQuad A) (s.mem.readAt S 256) (s.mem.readQuad R)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  fd_ed25519_verify_equation.blocks (s.mem.readAt k 256) (s.mem.readAt S 256)⟩,
            mem := s.mem.storeQuad A (fd_ed25519_point_neg.spec (s.mem.readQuad A)) }) := by
  func_init
  block_init
  step_pure
  -- fd_ed25519_point_t Rcmp[1];
  step_alloca with Rc
  step_pure
  -- fd_ed25519_point_neg( A, A );
  step_call using (fd_ed25519_point_neg.call_eq (hsep := .inl rfl))
  -- fd_ed25519_double_scalar_mul_base( Rcmp, k, A, S );
  have hRc_pt := MemoryState.QuadFit.of_fits hRc_fits hRc_off
  step_call using fd_ed25519_double_scalar_mul_base.call_eq
  -- return fd_ed25519_point_eq_z1( Rcmp, R );
  step_call using fd_ed25519_point_eq_z1.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  simp only [fd_ed25519_verify_equation.spec, fd_ed25519_verify_equation.blocks, GlobalState.alloca,
    Nat.add_assoc]

end Proof

end MLIR.Firedancer.Avx512

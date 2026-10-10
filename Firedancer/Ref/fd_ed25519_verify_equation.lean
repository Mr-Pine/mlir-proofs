module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base
public import Firedancer.Ref.fd_ed25519_point_eq_z1
public import Firedancer.Ref.fd_ed25519_point_neg
public import Firedancer.Ref.Mlir.fd_ed25519_verify_equation

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_eq_z1( Rcmp, R )` for `Rcmp = [k](-A) + [S]B`, `B`'s odd multiples in
`tbl`: whether `[S]B = R + [k]A`. -/
def fd_ed25519_verify_equation.spec (tbl : Nat → PointLimbs) (k : BitVec 256) (A : PointLimbs)
    (S : BitVec 256) (R : PointLimbs) : BitVec 32 :=
  fd_ed25519_point_eq_z1.spec
    (fd_ed25519_double_scalar_mul_base.spec tbl k (fd_ed25519_point_neg.spec A) S) R

/-- `Rcmp`'s block, `double_scalar_mul_base`'s and `point_eq_z1`'s four. -/
def fd_ed25519_verify_equation.blocks (k S : BitVec 256) : Nat :=
  1 + fd_ed25519_double_scalar_mul_base.blocks k S + 4

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_verify_equation` returns `spec` of the scalars at `k`, `S` and the points at `A`,
`R`, and leaves `A` negated; `Rcmp` is freed. -/
public theorem fd_ed25519_verify_equation.call_eq (k A S R : Pointer) (s : GlobalState) (hwf : s.WF)
    (hk : Fits s.mem k (8 * 32)) (hk_off : ¬k.offset.uaddOverflow 32#64) (hA : s.mem.PointFit A)
    (hS : Fits s.mem S (8 * 32)) (hS_off : ¬S.offset.uaddOverflow 32#64) (hR : s.mem.PointFit R)
    (hkA : k.id ≠ A.id) (hSA : S.id ≠ A.id) (hRA : R.id ≠ A.id) :
    fd_ed25519_verify_equation.call
        (fd_ed25519_verify_equation.args (.value k) (.value A) (.value S) (.value R)) s =
      .value
        (.cons
            (.value
              (fd_ed25519_verify_equation.spec fd_ed25519_double_scalar_mul_base.baseTbl
                (s.mem.readAt k 256) (s.mem.readPoint A) (s.mem.readAt S 256) (s.mem.readPoint R)))
            .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  fd_ed25519_verify_equation.blocks (s.mem.readAt k 256) (s.mem.readAt S 256)⟩
            mem := s.mem.storePoint A (fd_ed25519_point_neg.spec (s.mem.readPoint A)) }) := by
  func_init
  block_init
  -- fd_ed25519_point_t Rcmp[1];
  step_pure
  step_alloca with Rcmp
  step_pure
  have hRcmp_pt := MemoryState.PointRoom.of_room hroom_Rcmp hRcmp_off
  clear hroom_Rcmp hRcmp_bounds
  -- fd_ed25519_point_neg( A, A );
  step_call using (fd_ed25519_point_neg.call_eq (hsep := .inl rfl))
  -- fd_ed25519_double_scalar_mul_base( Rcmp, k, A, S );
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

end MLIR.Firedancer.Ref

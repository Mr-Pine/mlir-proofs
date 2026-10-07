module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_add_nr
public import Firedancer.Ref.fd_f25519_sub_nr
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.Mlir.fd_curve25519_into_precomputed

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `P` in table form, `(Y - X, Y + X, k·T, Z)`; the sum and difference not carried. -/
def fd_curve25519_into_precomputed.spec (P : PointLimbs) : PointLimbs :=
  let add := fd_f25519_add_nr.spec P.Y P.X
  let sub := fd_f25519_sub_nr.spec P.Y P.X
  ⟨sub, add, fd_f25519_mul.spec P.T fd_f25519_k.limbs, P.Z⟩

end

/-! ## Proof -/

section Proof

/-- `fd_curve25519_into_precomputed` stores `spec` of the point at `r` at `r`; `fd_f25519_k` and
the two temporaries count three blocks. -/
public theorem fd_curve25519_into_precomputed.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointFit r) :
    fd_curve25519_into_precomputed.call (fd_curve25519_into_precomputed.args (.value r)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem :=
              s.mem.storePoint r (fd_curve25519_into_precomputed.spec (s.mem.readPoint r)) }) := by
  func_init
  have hr₀ : S₀.mem.PointFit r := hS ▸ hr
  block_init
  step_pure
  -- fd_f25519_k
  step_addressof fd_f25519_k.value_eq with k
  -- fd_f25519_t add[1], sub[1];
  step_alloca with add
  step_alloca with sub
  iterate 2 step_pure
  have hk_read := fd_f25519_k.readLimbs hk_fits hk_off hread_k
  have hk_limbs := MemoryState.LimbsFit.of_fits hk_fits hk_off
  have hadd_limbs := MemoryState.LimbsFit.of_fits hadd_fits hadd_off
  have hsub_limbs := MemoryState.LimbsFit.of_fits hsub_fits hsub_off
  -- reads go through the stores over the state after the `alloca`s
  have hr₁ := hS ▸ hr
  have hadd₀ := hS ▸ hadd_limbs
  have hsub₀ := hS ▸ hsub_limbs
  clear hread_k hk_fits hadd_fits hsub_fits
  -- fd_f25519_add_nr( add, r->Y, r->X );
  step_pure
  step_call using fd_f25519_add_nr.call_eq
  -- fd_f25519_sub_nr( sub, r->Y, r->X );
  step_call using fd_f25519_sub_nr.call_eq consuming hread_add
  -- fd_f25519_set( r->X, sub );
  step_call using (fd_f25519_set.call_eq (hsep := .inr ?_)) consuming hread_sub
  clear hsub_limbs hsub₀
  -- fd_f25519_set( r->Y, add );
  step_call using (fd_f25519_set.call_eq (hsep := .inr ?_)) consuming hread_r
  clear hadd_limbs hadd₀
  -- fd_f25519_mul( r->T, r->T, fd_f25519_k );
  step_pure
  step_call using fd_f25519_mul.call_eq consuming hread_r_40
  clear hk_read hk_limbs hr hr₁
  iterate 2 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  simp only [fd_curve25519_into_precomputed.spec, MemoryState.readPoint,
    MemoryState.storePoint_of_Z hr₀]
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref

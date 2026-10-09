module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_ed25519_point_neg
public import Firedancer.Avx512.fd_ed25519_point_neg_precomputed
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.Avx512.Mlir.fd_ed25519_point_sub_with_opts

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `A - B`: `B` negated as a precomputed point or not, then added with the same options. -/
def fd_ed25519_point_sub_with_opts.spec (A B : Quad) (b_is_precomputed : BitVec 32) : Quad :=
  let neg :=
    if b_is_precomputed ≠ 0 then fd_ed25519_point_neg_precomputed.spec B
    else fd_ed25519_point_neg.spec B
  fd_ed25519_point_add_with_opts.spec A neg b_is_precomputed

end

/-! ## Proof -/

/-- `fd_ed25519_point_sub_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_sub_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    fd_ed25519_point_sub_with_opts.call
        (fd_ed25519_point_sub_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value (.cons (.value r) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 16⟩,
          mem := s.mem.storeQuad r
            (fd_ed25519_point_sub_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b) pre) }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_alloca with t
  step_pure
  step_pure
  have htq : S.mem.QuadFit t := MemoryState.QuadFit.of_fits ht_fits ht_off
  have htb : t.id ≠ b.id := Ne.symm hb_ne_t
  have htb' : t = b ∨ t.id ≠ b.id := .inr htb
  finish_block
  all_goals
    block_init
    first
    | step_call using fd_ed25519_point_neg.call_eq
    | step_call using fd_ed25519_point_neg_precomputed.call_eq
    finish_block
    block_init
    step_call using fd_ed25519_point_add_with_opts.call_eq
    step_pure
    finish_block
    subst hS
    erase_frame
    simp [fd_ed25519_point_sub_with_opts.spec, hbr]

end MLIR.Firedancer.Avx512

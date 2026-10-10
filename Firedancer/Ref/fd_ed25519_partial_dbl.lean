module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_add_nr
public import Firedancer.Ref.fd_f25519_sub_nr
public import Firedancer.Ref.fd_f25519_sqr4
public import Firedancer.Ref.Mlir.fd_ed25519_partial_dbl

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- A doubling before its last multiplication (eprint 2008/522, Sec 4.4), as the C names it. -/
def fd_ed25519_partial_dbl.spec (P : PointLimbs) : PointLimbs :=
  let r1 := fd_f25519_add_nr.spec P.X P.Y
  let r2 := fd_f25519_sqr.spec P.X
  let r3 := fd_f25519_sqr.spec P.Y
  let r4 := fd_f25519_sqr.spec P.Z
  let r5 := fd_f25519_sqr.spec r1
  let r4 := fd_f25519_add.spec r4 r4
  let T := fd_f25519_add.spec r2 r3
  let Z := fd_f25519_sub.spec r2 r3
  let Y := fd_f25519_add_nr.spec r4 Z
  let X := fd_f25519_sub_nr.spec T r5
  ⟨X, Y, T, Z⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_partial_dbl` stores `spec` of the point at `a` at `r` and returns `r`; all reads of `a`
come first, so `r` may alias it. Its five temporaries count five blocks. -/
public theorem fd_ed25519_partial_dbl.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (ha : s.mem.PointFit a) :
    fd_ed25519_partial_dbl.call (fd_ed25519_partial_dbl.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storePoint r (fd_ed25519_partial_dbl.spec (s.mem.readPoint a)) }) := by
  func_init
  block_init
  step_pure
  step_alloca with r1
  step_alloca with r2
  step_alloca with r3
  step_alloca with r4
  step_alloca with r5
  iterate 5 step_pure
  limbs_room r1
  limbs_room r2
  limbs_room r3
  limbs_room r4
  limbs_room r5
  -- fd_f25519_add_nr( r1, a->X, a->Y );
  step_pure
  step_call using fd_f25519_add_nr.call_eq
  -- fd_f25519_sqr4( r2, a->X, r3, a->Y, r4, a->Z, r5, r1 );
  step_pure
  step_call using fd_f25519_sqr4.call_eq
  -- fd_f25519_add( r4, r4, r4 );
  step_call using fd_f25519_add.call_eq
  -- fd_f25519_add( r->T, r2, r3 ); fd_f25519_sub( r->Z, r2, r3 );
  step_pure
  step_call using fd_f25519_add.call_eq
  step_pure
  step_call using fd_f25519_sub.call_eq
  -- fd_f25519_add_nr( r->Y, r4, r->Z ); fd_f25519_sub_nr( r->X, r->T, r5 );
  step_pure
  step_call using fd_f25519_add_nr.call_eq
  step_call using fd_f25519_sub_nr.call_eq
  iterate 5 step_pure
  finish_block
  have hro := hr.1
  subst hS
  erase_frame
  rw [MemoryState.storePoint_of_TZYX hro]
  rfl

end Proof

end MLIR.Firedancer.Ref

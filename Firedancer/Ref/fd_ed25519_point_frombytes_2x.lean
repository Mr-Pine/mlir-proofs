module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_ed25519_point_frombytes
public import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes_2x

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `-1` when `buf1` does not decode, else `-2` when `buf2` does not, else `0`. -/
def fd_ed25519_point_frombytes_2x.spec (buf1 buf2 : BitVec 256) : BitVec 32 :=
  if (fd_ed25519_point_frombytes.spec buf1).isNone then -1#32
  else if (fd_ed25519_point_frombytes.spec buf2).isNone then -2#32 else 0#32

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_frombytes_2x` decodes `buf1` into `r1` and, if that succeeds, `buf2` into
`r2`, each as `fd_ed25519_point_frombytes` stores it, and returns `spec`. `buf2` is read after `r1`
is written, so they are in different blocks. -/
public theorem fd_ed25519_point_frombytes_2x.call_eq (r1 buf1 r2 buf2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.PointFit r1) (hbuf1 : Fits s.mem buf1 (8 * 32))
    (hbuf1_off : ¬buf1.offset.uaddOverflow 32#64) (hr2 : s.mem.PointFit r2)
    (hbuf2 : Fits s.mem buf2 (8 * 32)) (hbuf2_off : ¬buf2.offset.uaddOverflow 32#64)
    (hsep : r1.id ≠ buf2.id) :
    fd_ed25519_point_frombytes_2x.call
        (fd_ed25519_point_frombytes_2x.args (.value r1) (.value buf1) (.value r2) (.value buf2)) s =
      .value
        (.cons
            (.value
              (fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  if (fd_ed25519_point_frombytes.spec (s.mem.readAt buf1 256)).isSome then
                    79 +
                      if (fd_ed25519_point_frombytes.spec (s.mem.readAt buf2 256)).isSome then 79
                      else 57
                  else 57⟩,
            mem :=
              (s.mem.storePointOpt r1
                    (fd_ed25519_point_frombytes.spec (s.mem.readAt buf1 256))).storePointOpt
                r2
                (if (fd_ed25519_point_frombytes.spec (s.mem.readAt buf1 256)).isSome then
                  fd_ed25519_point_frombytes.spec (s.mem.readAt buf2 256)
                else none) }) := by
  func_init
  block_init
  iterate 4 step_pure
  -- res = fd_ed25519_point_frombytes( r1, buf1 );
  step_call using fd_ed25519_point_frombytes.call_eq
  -- if( res == NULL ) return -1;
  rcases h1 : fd_ed25519_point_frombytes.spec (S₀.mem.readAt buf1 256) with _ | P1
  · step_pure [h1]
    finish_block
    block_init
    finish_block
    subst hS
    erase_frame
    simp only [h1, fd_ed25519_point_frombytes_2x.spec, Option.isSome_none, Option.isNone_none,
      MemoryState.storePointOpt_none, ↓reduceIte, Bool.false_eq_true, BitVec.reduceNeg]
  · have hr1_null : (r1 == Pointer.null) = false :=
      beq_eq_false_iff_ne.mpr fun h => hwf.ne_null_of_fits hr1.2.1.2.1 (congrArg (·.id) h)
    step_pure [h1, hr1_null]
    finish_block
    -- res = fd_ed25519_point_frombytes( r2, buf2 );
    block_init
    step_call using fd_ed25519_point_frombytes.call_eq
    have hr2_null : (r2 == Pointer.null) = false :=
      beq_eq_false_iff_ne.mpr fun h => hwf.ne_null_of_fits hr2.2.1.2.1 (congrArg (·.id) h)
    -- if( res == NULL ) return -2; return 0;
    rcases h2 : fd_ed25519_point_frombytes.spec (S₀.mem.readAt buf2 256) with _ | P2 <;>
      · iterate 2 step_pure [h2, hr2_null]
        finish_block
        block_init
        finish_block
        subst hS
        erase_frame
        simp only [h1, h2, fd_ed25519_point_frombytes_2x.spec, Option.isSome_none,
          Option.isNone_none, Option.isSome_some, Option.isNone_some, ↓reduceIte,
          Bool.false_eq_true, Nat.add_assoc, BitVec.reduceNeg]

end Proof

end LeanMLIR.RIR.Firedancer.Ref

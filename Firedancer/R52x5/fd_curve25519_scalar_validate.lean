module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.R52x5.fd_ulong_load_8
public import Firedancer.R52x5.Mlir.fd_curve25519_scalar_validate
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5

open Ref (scalarL MemoryState.readAt_add_of_fits MemoryState.readAt_of_fits
  lt_add_ite add_ite_le ite_le toNat_lt_iff le_toNat_iff ite_flip)

/-! ## Proof -/

section Proof

/-- `validate` returns `p` when the 32 bytes at `p` are a canonical scalar (below `ℓ`), else
`NULL`, and leaves the state alone. -/
public theorem fd_curve25519_scalar_validate.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (8 * 32)) (hoff : ¬p.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_validate.call (fd_curve25519_scalar_validate.args (.value p)) s =
      .value
        (.cons
            (.value
              (if Ref.fd_curve25519_scalar_validate.spec (s.mem.readAt p 256) then p
              else Pointer.null))
            .nil,
          s) := by
  func_init
  block_init
  -- the constants, `NULL` and `s + 31`
  iterate 10 step_pure
  -- if( FD_UNLIKELY( s[31] & 0xF0 ) ): compiled as `s[31] < 0x10`
  step_load
  step_pure
  finish_block <;> block_init
  case isTrue =>
    -- return s;
    finish_block
    subst hS
    simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
      Nat.reduceMul] at hbr
    rw [ite_eq_left
        (by
          simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
  case isFalse =>
    -- if( FD_LIKELY( s[31] & 0xE0 ) ) return NULL;
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      subst hS
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        Nat.reduceMul] at hbr
      rw [ite_eq_right
          (by
            simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
    case isTrue =>
      -- ulong s0 = fd_ulong_load_8_fast( s ); … s3
      step_call using fd_ulong_load_8.call_eq with s0
      step_pure
      step_call using fd_ulong_load_8.call_eq with s1
      step_pure
      step_call using fd_ulong_load_8.call_eq with s2
      step_pure
      step_call using fd_ulong_load_8.call_eq with s3
      -- the `fd_ulong_sub_borrow` chain against `ℓ - 1`, as `subborrow.64`s
      iterate 10 step_pure
      finish_block
      block_init
      finish_block
      subst hS hs0 hs1 hs2 hs3
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        MemoryState.readAt_of_fits (v := 256) (w := 64) hfits, Nat.reduceMul]
      generalize S.mem.readAt p 256 = x
      clear hE hbr hArgs hfits hoff hwf
      simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]
      simp (disch := decide) only [lt_add_ite, add_ite_le, ite_le, toNat_lt_iff, le_toNat_iff,
        Nat.reduceAdd]
      congr 4
      apply ite_flip
      bv_decide

end Proof

end MLIR.Firedancer.R52x5

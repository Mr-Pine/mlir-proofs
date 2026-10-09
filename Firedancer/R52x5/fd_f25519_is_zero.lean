module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_canonical_limbs
public import Firedancer.R52x5.Mlir.fd_f25519_is_zero

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_is_zero`: `1` when every canonical limb of `a` is zero, else `0`. -/
def fd_f25519_is_zero.spec (a : Wwl) : BitVec 32 :=
  let h := fd_f25519_canonical_limbs.spec a
  if (h 0 ||| h 1 ||| h 2 ||| h 3 ||| h 4) = 0 then 1 else 0

end

/-! ## Proof -/

section Proof

/-- The compiled test: `zext (icmp eq x 0)`. -/
theorem fd_f25519_is_zero.ofBool_eq_zero (x : BitVec 64) :
    (BitVec.ofBool (x == 0#64)).setWidth 32 = if x = 0#64 then 1#32 else 0#32 := by
  by_cases hx : x = 0#64
  · simp [hx]
  · simp only [hx, ↓reduceIte, beq_eq_false_iff_ne.mpr hx]
    rfl

/-- `fd_f25519_is_zero( a )` returns `spec` of the element at `a`; its temporary and
`fd_f25519_reduce`'s are freed, the counter moves on by two blocks. -/
public theorem fd_f25519_is_zero.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) :
    fd_f25519_is_zero.call (fd_f25519_is_zero.args (.value a)) s =
      .value
        (.cons (.value (fd_f25519_is_zero.spec (s.mem.readVec a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- ulong h[5];
  step_alloca with h
  step_pure
  have hh_limbs : S.mem.LimbsFit h := .of_fits hh_fits hh_off
  rw [hS] at hh_limbs
  -- fd_f25519_canonical_limbs( h, a );
  step_call using fd_f25519_canonical_limbs.call_eq
  generalize hl : fd_f25519_canonical_limbs.spec (S₀.mem.readVec a) = l at hS
  have hread_h : S.mem.readAt h 256 = BitVec.packLanes #v[l 0, l 1, l 2, l 3] := by
    rw [hS]; exact MemoryState.readAt_storeLimbs_wv hh_limbs
  have hread_h_32 : S.mem.readAt (h.add 32#64) 64 = l 4 := by
    rw [hS]; exact congrFun (MemoryState.readLimbs_storeLimbs_self hh_limbs) 4
  -- return (h[0] | h[1] | h[2] | h[3] | h[4]) == 0;
  step_load
  step_pure
  step_load
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  finish_block
  subst hS hl
  erase_frame
  rw [fd_f25519_is_zero.ofBool_eq_zero]
  rfl

end Proof

end MLIR.Firedancer.R52x5

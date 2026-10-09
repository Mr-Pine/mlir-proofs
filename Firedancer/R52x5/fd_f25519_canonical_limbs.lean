module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_reduce
public import Firedancer.R52x5.fd_r52x5_reduce
public import Firedancer.R52x5.Mlir.fd_f25519_canonical_limbs

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_canonical_limbs`: `a` folded, then `fd_r52x5_reduce`d. -/
def fd_f25519_canonical_limbs.spec (a : Wwl) : Fin 5 → BitVec 64 :=
  fd_r52x5_reduce.spec (limbs (fold a))

end

/-! ## Proof -/

section Proof

/-- Limbs 0-3 stored and read back as one `<4 x i64>`. -/
public theorem MemoryState.readAt_storeLimbs_wv {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    (m.storeLimbs p l).readAt p 256 = BitVec.packLanes #v[l 0, l 1, l 2, l 3] := by
  have hf : Fits m p 256 := (MemoryState.LimbsFit.fits h).mono (by omega)
  rw [← MemoryState.storeLimbsV_eq h, MemoryState.storeLimbsV, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeWv_self hf]
  simp only [Range.Disjoint, Range.of]
  right; right
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    Pointer.offsetInBits_add_limb h.1 (by omega)]
  unfold Pointer.offsetInBits
  omega

/-- `fd_f25519_canonical_limbs( h, a )` stores `spec` of the element at `a` as limbs at `h`;
`fd_f25519_reduce`'s temporary moves the counter on by one block. -/
public theorem fd_f25519_canonical_limbs.call_eq (h a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsFit h) (ha : Fits s.mem a 512) :
    fd_f25519_canonical_limbs.call (fd_f25519_canonical_limbs.args (.value h) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs h (fd_f25519_canonical_limbs.spec (s.mem.readVec a)) }) := by
  func_init
  block_init
  step_load
  -- fd_f25519_reduce( h, a->el );
  step_call using fd_f25519_reduce.call_eq
  -- fd_r52x5_reduce( h );
  step_call using fd_r52x5_reduce.call_eq
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeLimbs_storeLimbs_self]
  rfl

end Proof

end MLIR.Firedancer.R52x5

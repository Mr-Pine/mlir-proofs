module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Mlir.fd_f25519_is_zero

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The limbs of `p = 2^255 - 19`. -/
def fd_f25519_is_zero.pLimbs : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 2251799813685229#64
  | _ => 2251799813685247#64

/-- `1` when the limbs are exactly those of `0` or of `p`, else `0`. -/
def fd_f25519_is_zero.spec (x : Fin 5 → BitVec 64) : BitVec 32 :=
  if (∀ k, x k = 0) ∨ (∀ k, x k = fd_f25519_is_zero.pLimbs k) then 1 else 0

end

/-! ## Proof -/

section Proof

/-- Limb `i` at `p`, as a read at its byte offset. -/
theorem fd_f25519_is_zero.readLimbs_eq {i : Fin 5} {M : MemoryState} :
    M.readLimbs p i = M.readAt (p.add (8 * i)) 64 := by fin_cases i <;> simp [MemoryState.readLimbs]

/-- Limb 0 is zero's and limb `i` is not: not zero, and not `p`. -/
theorem fd_f25519_is_zero.spec_of_ne_zero {S₀ : GlobalState} {x} {i : Fin 5}
    (h0 : S₀.mem.readAt x 64 = 0) (hnz : ¬S₀.mem.readAt (x.add (8 * i)) 64 = 0) :
    fd_f25519_is_zero.spec (S₀.mem.readLimbs x) = 0#32 := by
  rw [fd_f25519_is_zero.spec]
  simp
  refine ⟨⟨i, ?nz⟩, 0, ?z⟩ <;> simp [fd_f25519_is_zero.readLimbs_eq]
  case nz =>
    simp at hnz
    simp [hnz]
  case z =>
    simp [h0, fd_f25519_is_zero.pLimbs]
    split <;> decide

/-- Limb 0 is `p`'s and limb `i` is not: not `p`, and not zero. -/
theorem fd_f25519_is_zero.spec_of_ne_p {S₀ : GlobalState} {x} {i : Fin 5}
    (h0 : S₀.mem.readAt x 64 = 2251799813685229#64)
    (hnp : ¬S₀.mem.readAt (x.add (8 * i)) 64 = fd_f25519_is_zero.pLimbs i) :
    fd_f25519_is_zero.spec (S₀.mem.readLimbs x) = 0#32 := by
  rw [fd_f25519_is_zero.spec]
  simp
  refine ⟨⟨0, ?p⟩, i, ?np⟩ <;> simp [fd_f25519_is_zero.readLimbs_eq]
  case p => simp [h0]
  case np =>
    simp at hnp
    simp [hnp]

/-- `is_zero` returns `1` exactly when `x`'s limbs are those of `0` or of `p`. -/
public theorem fd_f25519_is_zero.call_eq (x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hx : s.mem.LimbsFit x) :
    fd_f25519_is_zero.call (fd_f25519_is_zero.args (.value x)) s =
      .value (.cons (.value (fd_f25519_is_zero.spec (s.mem.readLimbs x))) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  step_load
  finish_block <;> block_init
  case isFalse.isFalse =>
    finish_block
    block_init
    finish_block
    rw [hS, spec]
    simp
    refine ⟨⟨0, ?_⟩, 0, ?_⟩ <;> assumption
  all_goals
    have hbr0 := hbr
    step_pure
    step_load
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      block_init
      finish_block
      rw [hS]
      simp
      first
      | rw [fd_f25519_is_zero.spec_of_ne_zero (i := 1) hbr0 hbr]
      | rw [fd_f25519_is_zero.spec_of_ne_p (i := 1) hbr0 hbr]
  all_goals
    have hbr1 := hbr
    step_pure
    step_load
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      block_init
      finish_block
      rw [hS]
      simp
      first
      | rw [fd_f25519_is_zero.spec_of_ne_zero (i := 2) hbr0 hbr]
      | rw [fd_f25519_is_zero.spec_of_ne_p (i := 2) hbr0 hbr]
  all_goals
    have hbr2 := hbr
    step_pure
    step_load
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      block_init
      finish_block
      rw [hS]
      simp
      first
      | rw [fd_f25519_is_zero.spec_of_ne_zero (i := 3) hbr0 hbr]
      | rw [fd_f25519_is_zero.spec_of_ne_p (i := 3) hbr0 hbr]
  all_goals
    have hbr3 := hbr
    step_pure
    step_load
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      block_init
      finish_block
      rw [hS]
      simp
      first
      | rw [fd_f25519_is_zero.spec_of_ne_zero (i := 4) hbr0 hbr]
      | rw [fd_f25519_is_zero.spec_of_ne_p (i := 4) hbr0 hbr]
  all_goals
    have hbr4 := hbr
    finish_block
    simp [spec, hS]
    intro i
  · fin_cases i <;> simp_all [MemoryState.readLimbs]
  · intro _ k
    fin_cases k <;> simp [MemoryState.readLimbs, hbr0, hbr1, hbr2, hbr3, hbr4, pLimbs]
    rfl

end Proof

end MLIR.Firedancer.Ref

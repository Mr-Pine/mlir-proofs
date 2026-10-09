module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Mlir.fiat_25519_cmovznz_u64

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- What ends up in memory: `a` when `c = 0`, `b` otherwise. -/
def fiat_25519_cmovznz_u64.spec (c : BitVec 8) (a b : BitVec 64) : BitVec 64 :=
  if c = 0#8 then a else b

end

/-! ## Proof -/

section Proof

/-- The value case: with room at `ptr`, the function stores `spec c a b` there and changes
nothing else. -/
public theorem fiat_25519_cmovznz_u64.call_eq (ptr : Pointer) (c : BitVec 8) (a b : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hfits : Fits s.mem ptr 64) :
    fiat_25519_cmovznz_u64.call
        (fiat_25519_cmovznz_u64.args (.value ptr) (.value c) (.value a) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeAt ptr (fiat_25519_cmovznz_u64.spec c a b) }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_pure [BitVec.ofBool]
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.Ref

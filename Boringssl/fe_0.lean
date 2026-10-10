module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Boringssl.OPENSSL_memset
public import Boringssl.Mlir.fe_0

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- The limbs of `0`. -/
def fe_0.spec : Fin 5 → BitVec 64 := fun _ => 0

end

/-! ## Proof -/

section Proof

/-- `fe_0` stores `spec` (zero limbs) at `h`. -/
public theorem fe_0.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.LimbsRoom h) :
    fe_0.call (fe_0.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h fe_0.spec }) := by
  have hh320 : Room s.mem h 320 := hh.room320
  func_init
  block_init
  iterate 2 step_pure
  -- OPENSSL_memset(h, 0, sizeof(fe));
  step_call using OPENSSL_memset.call_eq
  finish_block
  rw [hS, MemoryState.storeAt_eq_storeLimbs hh.1]
  simp only [BitVec.extractLsb'_zero]
  rfl

end Proof

end MLIR.Boringssl

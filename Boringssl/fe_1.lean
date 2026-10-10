module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Boringssl.OPENSSL_memset
public import Boringssl.Mlir.fe_1

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- The limbs of `1`. -/
def fe_1.spec : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 1
  | _ => 0

end

/-! ## Proof -/

section Proof

/-- `fe_1` stores `spec` (the limbs of `1`) at `h`. -/
public theorem fe_1.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.LimbsRoom h) :
    fe_1.call (fe_1.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs h fe_1.spec }) := by
  have hh320 : Room s.mem h 320 := hh.room320
  func_init
  block_init
  iterate 3 step_pure
  -- OPENSSL_memset(h, 0, sizeof(fe));
  step_call using OPENSSL_memset.call_eq
  -- h->v[0] = 1;
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_eq_storeLimbs hh.1, MemoryState.storeLimbs_storeAt_self hh.1]
  simp only [BitVec.extractLsb'_zero]
  congr
  funext i
  fin_cases i <;> rfl

end Proof

end MLIR.Boringssl

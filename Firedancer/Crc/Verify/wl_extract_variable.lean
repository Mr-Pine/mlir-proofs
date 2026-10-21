module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.Wl
public import Firedancer.Crc.Verify.Mlir.wl_extract_variable

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5 (Wl)

/-! ## Proof -/

section Proof

/-- `wl_extract_variable( x, i )` returns lane `i` of `x`, `i` below 4; its union is freed, the
counter moves on by one block. -/
public theorem wl_extract_variable.call_eq (x : Wl) (i : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hi : i.toNat < 4) :
    wl_extract_variable.call (wl_extract_variable.args (Ty.wrap x) (.value i)) s =
      .value
        (.cons (.value x[i.toNat]) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  have hm : i.msb = false := by rw [BitVec.msb_eq_false_iff_two_mul_lt]; omega
  have hmod : i.toNat % 18446744073709551616 = i.toNat := Nat.mod_eq_of_lt (by omega)
  have hmul : i.toNat * 8 < 18446744073709551616 := by omega
  func_init
  block_init
  step_pure
  step_alloca with t
  step_pure
  step_store
  step_pure
  step_pure [hm, hmod, hmul]
  have hf := hfits_t.wl_lane ht_off hi
  have hr := MemoryState.readAt_wl_lane hfits_t ht_off hread_t hi
  step_load
  step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify

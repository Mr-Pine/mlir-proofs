module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.Wl
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_extract_variable

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5 (Wl)

/-! ## Proof -/

section Proof

/-- Lane `k` of the slot `t`: in its `Fits`. -/
private theorem lane_fits {m : MemoryState} {t : Pointer} (h : Fits m t 256) (ho : t.offset = 0)
    (hk : k < 4) : Fits m (t.add (BitVec.ofNat 64 (k * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, ho]; omega)
    (by
      simp; omega)
    h

/-- Lane `k` of the slot `t` holding `x`: `x[k]`. -/
private theorem lane_read {m : MemoryState} {t : Pointer} {x : Wl} (h : Fits m t 256)
    (ho : t.offset = 0) (hr : m.readAt t 256 = BitVec.packLanes x) (hk : k < 4) :
    m.readAt (t.add (BitVec.ofNat 64 (k * 8))) 64 = x[k] := by
  rw [MemoryState.readAt_add_of_readAt h.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr]
  have e : (BitVec.ofNat 64 (k * 8)).toNat * 8 = k * 64 := by
    simp; omega
  rw [e, BitVec.extractLsb'_packLanes x k hk]

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
  have hf := lane_fits hfits_t ht_off hi
  have hr := lane_read hfits_t ht_off hread_t hi
  step_load
  step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512

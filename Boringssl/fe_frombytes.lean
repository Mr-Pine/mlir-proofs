module

public import MLIR.Run.Tactic
public import Boringssl.OPENSSL_memcpy
public import Boringssl.fe_frombytes_strict
public import Boringssl.Mlir.fe_frombytes
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- The copy after `s_copy[31] &= 0x7f`: the bytes with bit 255 cleared. -/
theorem fe_frombytes.splice_eq (x : BitVec 256) :
    Memory.spliceBits x 248 (x.extractLsb' 248 8 &&& 127#8) = (x.setWidth 255).setWidth 256 := by
  have h127 : ∀ j < 8, (127#8).getLsbD j = decide (j < 7) := by decide
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_setWidth, BitVec.getLsbD_and,
    BitVec.getLsbD_extractLsb']
  split
  · rw [h127 _ (by omega), show 248 + (i - 248) = i by omega]
    by_cases h : i < 255
    · simp [h, hi, show i - 248 < 8 by omega, show i - 248 < 7 by omega]
    · simp [h, hi]
      omega
  · simp [hi, show i < 255 by omega]

/-- Clearing bit 255 leaves the limbs: `from_bytes` drops it. -/
theorem fe_frombytes.spec_setWidth (x : BitVec 256) :
    Firedancer.Ref.fiat_25519_from_bytes.spec ((x.setWidth 255).setWidth 256) =
      Firedancer.Ref.fiat_25519_from_bytes.spec x := by
  rw [Firedancer.Ref.fiat_25519_from_bytes.spec_eq, Firedancer.Ref.fiat_25519_from_bytes.spec_eq]
  funext i
  fin_cases i <;> simp <;> bv_decide

/-- `fe_frombytes` stores the 32 bytes at `buf`, bit 255 dropped, as limbs at `h`
(`fiat_25519_from_bytes.spec`, which drops it too). The copy's slot is freed again: only the
counter moves on. -/
public theorem fe_frombytes.call_eq (h buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hbuf : Fits s.mem buf (8 * 32)) :
    fe_frombytes.call (fe_frombytes.args (.value h) (.value buf)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_from_bytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  block_init
  iterate 3 step_pure
  -- uint8_t s_copy[32];
  step_alloca with s_copy
  step_pure
  -- OPENSSL_memcpy(s_copy, s, 32);
  step_call using OPENSSL_memcpy.call_eq
  -- s_copy[31] &= 0x7f;
  step_pure
  step_load
  step_pure
  step_store
  -- fe_frombytes_strict(h, s_copy);
  rw [fe_frombytes.splice_eq] at hread_s_copy
  have hmsb : (S.mem.readAt s_copy 256).msb = false := by
    rw [hread_s_copy]
    bv_decide
  step_call using fe_frombytes_strict.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rw [fe_frombytes.spec_setWidth]
  rfl

end Proof

end MLIR.Boringssl

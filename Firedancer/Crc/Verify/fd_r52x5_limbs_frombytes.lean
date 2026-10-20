module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_frombytes
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Verify

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_limbs_frombytes( l, b )`: the 32 bytes `b` as four little-endian words, cut into
five 51-bit limbs, bit 255 dropped. -/
def fd_r52x5_limbs_frombytes.spec (b : BitVec 256) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => (b.extractLsb' 0 51).setWidth 64
  | ⟨1, _⟩ => (b.extractLsb' 51 51).setWidth 64
  | ⟨2, _⟩ => (b.extractLsb' 102 51).setWidth 64
  | ⟨3, _⟩ => (b.extractLsb' 153 51).setWidth 64
  | ⟨4, _⟩ => (b.extractLsb' 204 51).setWidth 64

end

/-! ## Proof -/

section Proof

/-! The compiled limbs of the 32 bytes `B`. -/

private theorem limb0 (B : BitVec 256) :
    BitVec.setWidth 64 B &&& 2251799813685247#64 = (B.extractLsb' 0 51).setWidth 64 := by
  bv_decide

private theorem limb1 (B : BitVec 256) :
    BitVec.extractLsb' 64 64 ((BitVec.extractLsb' 64 64 B ++ BitVec.setWidth 64 B) <<< 13) &&&
      2251799813685247#64 = (B.extractLsb' 51 51).setWidth 64 := by
  bv_decide

private theorem limb2 (B : BitVec 256) :
    BitVec.extractLsb' 64 64 ((BitVec.extractLsb' 0 64 (BitVec.extractLsb' 128 128 B) ++
      BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 128 B)) <<< 26) &&& 2251799813685247#64 =
      (B.extractLsb' 102 51).setWidth 64 := by
  bv_decide

private theorem limb3 (B : BitVec 256) :
    BitVec.extractLsb' 64 64 ((BitVec.extractLsb' 64 64 (BitVec.extractLsb' 128 128 B) ++
      BitVec.extractLsb' 64 64 (BitVec.extractLsb' 64 128 B)) <<< 39) &&& 2251799813685247#64 =
      (B.extractLsb' 153 51).setWidth 64 := by
  bv_decide

private theorem limb4 (B : BitVec 256) :
    BitVec.extractLsb' 192 64 B >>> 12 &&& 2251799813685247#64 = (B.extractLsb' 204 51).setWidth 64 := by
  bv_decide

/-- `fd_r52x5_limbs_frombytes( l, b )` stores `spec` of the 32 bytes at `b` as limbs at `l`. -/
public theorem fd_r52x5_limbs_frombytes.call_eq (l b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hl : s.mem.LimbsRoom l) (hb : Fits s.mem b 256) (hoff : b.offset.toNat + 32 < 2 ^ 64) :
    fd_r52x5_limbs_frombytes.call (fd_r52x5_limbs_frombytes.args (.value l) (.value b)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs l (fd_r52x5_limbs_frombytes.spec (s.mem.readAt b 256)) }) := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬b.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  have hb0 : Fits s.mem b 64 := hb.mono (by omega)
  have hb8 : Fits s.mem (b.add 8#64) 64 := Fits.add_of_le (hov 8 (by omega)) (by decide) hb
  have hb8' : Fits s.mem (b.add 8#64) 128 := Fits.add_of_le (hov 8 (by omega)) (by decide) hb
  have hb16 : Fits s.mem (b.add 16#64) 128 := Fits.add_of_le (hov 16 (by omega)) (by decide) hb
  have hb24 : Fits s.mem (b.add 24#64) 64 := Fits.add_of_le (hov 24 (by omega)) (by decide) hb
  have hl256 : Room s.mem l 256 := hl.room320.mono (by omega)
  obtain ⟨B, hB⟩ : ∃ B, s.mem.readAt b 256 = B := ⟨_, rfl⟩
  have e0 := MemoryState.readAt_of_readAt_le (w := 64) (by decide) hB
  have e8 := MemoryState.readAt_add_of_readAt hb.inBounds (hov 8 (by omega)) (w := 64) (by decide) hB
  have e8' := MemoryState.readAt_add_of_readAt hb.inBounds (hov 8 (by omega)) (w := 128) (by decide) hB
  have e16 := MemoryState.readAt_add_of_readAt hb.inBounds (hov 16 (by omega)) (w := 128) (by decide) hB
  have e24 := MemoryState.readAt_add_of_readAt hb.inBounds (hov 24 (by omega)) (w := 64) (by decide) hB
  rw [← MemoryState.storeLimbsV_eq hl, hB]
  func_init
  block_init
  iterate 9 step_pure
  step_load
  iterate 3 step_pure
  iterate 4 step_load
  iterate 2 step_pure
  iterate 2 step_pure
  iterate 2 step_pure
  step_pure [expandOfFn]
  step_store
  iterate 3 step_pure
  step_store
  finish_block
  subst hS
  simp only [MemoryState.storeLimbsV, MemoryState.storeWv, Ty.extractVecElem_eq, Fin.val_zero,
    Fin.val_one, Nat.zero_mul, Nat.one_mul]
  simp only [limb0, limb1, limb2, limb3, limb4]
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify

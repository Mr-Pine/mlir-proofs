module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.BASEPOINT_ODD_LOOKUP_TABLE
public import Agave.Avx2.Mlir.NafLookupTable8_CachedPoint_select

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `BASEPOINT_ODD_LOOKUP_TABLE.select(x)` stores entry `x / 2` of the table at `out`; `x ≥ 128`
panics. The panic's `Location` and the table take a block each. -/
public theorem NafLookupTable8_CachedPoint_select.call_eq (out : Pointer) (x : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hx : x.toNat < 128) (hout : Room s.mem out 1280)
    (ho : out.offset.toNat + 160 ≤ 2 ^ 64) :
    NafLookupTable8_CachedPoint_select.call
        (NafLookupTable8_CachedPoint_select.args (.value out) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeFe4x out (BASEPOINT_ODD_LOOKUP_TABLE.point (x.toNat / 2)) }) := by
  func_init
  block_init
  iterate 3 step_pure
  step_addressof anon_e79fcfe266c5706188f989b4d452749f_38 with loc
  step_addressof BASEPOINT_ODD_LOOKUP_TABLE.value_eq with tb
  replace hread_tb : S.mem.readAt tb 81920 = BASEPOINT_ODD_LOOKUP_TABLE.bits := hread_tb
  -- self.0[x / 2]
  iterate 3 step_pure
  finish_block
  case isTrue =>
    block_init
    step_pure
    step_memcpy
    finish_block
    subst hS
    erase_frame
    have hk : (BitVec.ofNat 64 (x.toNat >>> 1 * 160)).toNat * 8 = 1280 * (x.toNat / 2) := by
      rw [BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow, Nat.mod_eq_of_lt (by omega)]
      omega
    rw [hk, ← fe4xBits_ofBits (BASEPOINT_ODD_LOOKUP_TABLE.bits.extractLsb' _ _),
      MemoryState.storeAt_fe4xBits ho]
    rfl
  case isFalse =>
    -- the bounds check's panic: not taken
    exfalso
    apply hbr
    simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega

end Proof

end MLIR.Agave.Avx2

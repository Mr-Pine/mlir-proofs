module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.Mlir.NafLookupTable5_CachedPoint_select

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `self.select(x)` stores entry `x / 2` of the table at `tbl` at `out`, another block; `x ≥ 16`
panics. -/
public theorem NafLookupTable5_CachedPoint_select.call_eq (out tbl : Pointer) (x : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals NafLookupTable5_CachedPoint_select.globals)
    (hx : x.toNat < 16) (hout : Room s.mem out 1280)
    (ho : out.offset.toNat + 160 ≤ 2 ^ 64) (htbl : s.mem.Naf5Fit tbl) (hsep : out.id ≠ tbl.id) :
    NafLookupTable5_CachedPoint_select.call
        (NafLookupTable5_CachedPoint_select.args (.value out) (.value tbl) (.value x)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeFe4x out (s.mem.readNaf5 tbl ⟨x.toNat / 2, by omega⟩) }) := by
  have hj : x.toNat >>> 1 * 160 = 160 * (x.toNat / 2) := by
    rw [Nat.shiftRight_eq_div_pow, Nat.mul_comm]
  have he := htbl.fits_entry ⟨x.toNat / 2, by omega⟩
  have hfe := htbl.entry ⟨x.toNat / 2, by omega⟩
  simp only [← hj] at he hfe
  obtain ⟨htoff, htf⟩ := htbl
  -- `hfe` about an opaque `m`, not carried by the steps
  obtain ⟨m, hm⟩ : ∃ m, m = s.mem := ⟨_, rfl⟩
  rw [← hm] at hfe
  func_init
  block_init
  iterate 3 step_pure
  step_addressof anon_e79fcfe266c5706188f989b4d452749f_25 with loc
  -- self.0[x / 2]
  iterate 3 step_pure
  finish_block
  case isTrue =>
    block_init
    step_pure
    step_memcpy
    finish_block
    subst hS
    rw [MemoryState.storeAt_readAt_fe4x (hm ▸ hfe) ho, MemoryState.readNaf5, ← hj]
  case isFalse =>
    -- the bounds check's panic: not taken
    exfalso
    apply hbr
    simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega

end Proof

end MLIR.Agave.Avx2

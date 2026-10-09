module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Scalar
public import Zig.Mlir.Scalar_toBytes
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- The 32 bytes: limbs `0 … 3`'s low 56 bits, then limb `4`'s low 32. -/
def Scalar.toBytes.spec (l : Fin 5 → BitVec 64) : BitVec 256 :=
  (l 4).setWidth 32 ++ (l 3).setWidth 56 ++ (l 2).setWidth 56 ++ (l 1).setWidth 56 ++
    (l 0).setWidth 56

end

/-! ## Proof -/

section Proof

open Memory in
/-- The five stores of `toBytes` at `p`, read back whole: their bits spliced in. -/
theorem readAt_stores_bytes {m : MemoryState} {p : Pointer} (hf : Fits m p 256) (ho : p.offset = 0)
    (v0 v1 v2 v3 : BitVec 64) (v4 : BitVec 32) :
    (((((m.storeAt p v0).storeAt (p.add 7#64) v1).storeAt (p.add 14#64) v2).storeAt (p.add 21#64)
      v3).storeAt (p.add 28#64) v4).readAt p 256 =
      spliceBits (spliceBits (spliceBits (spliceBits (spliceBits (m.readAt p 256) 0 v0) 56 v1)
        112 v2) 168 v3) 224 v4 := by
  have hov (k : BitVec 64) : ¬p.offset.uaddOverflow k := by
    simp [ho, BitVec.uaddOverflow]; omega
  have h0 := MemoryState.readAt_add_storeAt (off := 0#64) (w := 64) hf (hov _) (by decide) v0
  rw [Pointer.add_zero] at h0
  rw [MemoryState.readAt_add_storeAt (hf.storeAt.storeAt.storeAt.storeAt) (hov _) (by decide),
    MemoryState.readAt_add_storeAt (hf.storeAt.storeAt.storeAt) (hov _) (by decide),
    MemoryState.readAt_add_storeAt (hf.storeAt.storeAt) (hov _) (by decide),
    MemoryState.readAt_add_storeAt (hf.storeAt) (hov _) (by decide), h0]
  rfl

open Memory in
open Memory in
/-- The splices into zeros: the limbs' bytes. -/
theorem splice_eq (v0 v1 v2 v3 v4 : BitVec 64) :
    spliceBits (spliceBits (spliceBits (spliceBits (spliceBits (0 : BitVec 256) 0 v0) 56 v1)
        112 v2) 168 v3) 224 (v4.setWidth 32) =
      (v4.setWidth 32 ++ v3.setWidth 56 ++ v2.setWidth 56 ++ v1.setWidth 56 ++ v0.setWidth 56 : BitVec 256) := by
  simp only [spliceBits_eq]
  bv_decide

set_option maxHeartbeats 1000000 in
/-- `Scalar.toBytes` stores `spec l` at `out`, for the top limb below `2^32`. -/
public theorem Scalar_toBytes.call_eq (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 256) (hl : s.mem.LimbsFit l)
    (hl4 : (s.mem.readLimbs l 4).toNat < 2 ^ 32) :
    Scalar_toBytes.call (Scalar_toBytes.args (.value out) (.value l)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeAt out (Scalar.toBytes.spec (s.mem.readLimbs l)) }) := by
  func_init
  have hl4' := hS ▸ hl4
  have hwf₀ : S₀.WF := hS ▸ hwf
  have hl₀ : S₀.mem.LimbsFit l := hS ▸ hl
  clear hl4
  block_init
  iterate 7 step_pure
  step_alloca with buf
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure [(by decide : (0#64).smulOverflow 7#64 = false), (by decide : (0#64).umulOverflow 7#64 = false)]
  iterate 2 step_pure
  step_load with v0 hv0
  step_store
  step_pure [(by decide : (0#64).saddOverflow 1#64 = false), (by decide : (0#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure [(by decide : (1#64).smulOverflow 7#64 = false), (by decide : (1#64).umulOverflow 7#64 = false)]
  iterate 2 step_pure
  step_load with v1 hv1
  step_store
  step_pure [(by decide : (1#64).saddOverflow 1#64 = false), (by decide : (1#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure [(by decide : (2#64).smulOverflow 7#64 = false), (by decide : (2#64).umulOverflow 7#64 = false)]
  iterate 2 step_pure
  step_load with v2 hv2
  step_store
  step_pure [(by decide : (2#64).saddOverflow 1#64 = false), (by decide : (2#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure [(by decide : (3#64).smulOverflow 7#64 = false), (by decide : (3#64).umulOverflow 7#64 = false)]
  iterate 2 step_pure
  step_load with v3 hv3
  step_store
  step_pure [(by decide : (3#64).saddOverflow 1#64 = false), (by decide : (3#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  iterate 2 step_pure
  step_load with v4 hv4
  have h4 : v4 < 4294967296#64 := by
    rw [hv4, MemoryState.readAt_alloca hwf₀ hl₀.2.2.2.2.2, BitVec.lt_def]; exact hl4'
  have h4' : v4.ult 4294967296#64 = true := by simpa [BitVec.ult, BitVec.lt_def] using h4
  have h4'' : (v4.setWidth 32).setWidth 64 = v4 := by bv_decide
  iterate 4 step_pure [h4']
  finish_block
  block_init
  step_pure [h4'']
  step_store
  step_memcpy
  finish_block
  rw [hS]
  erase_frame
  have hf : Fits (S₀.alloca 32).mem buf 256 := hbuf ▸ Fits.allocaPtr (Nat.le_refl _)
  rw [MemoryState.readAt_alloca hwf₀ hl₀.2.2.2.2.2] at hv4
  rw [readAt_stores_bytes hf hbuf_off, hbuf, readAt_alloca_slot, splice_eq]
  subst hv0 hv1 hv2 hv3 hv4
  rfl

/-- `call_eq` on the limbs `L` read at `l`. -/
public theorem Scalar_toBytes.call_eq_of (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 256) (hl : s.mem.LimbsFit l) (hL : s.mem.readLimbs l = L)
    (hL4 : (L 4).toNat < 2 ^ 32) :
    Scalar_toBytes.call (Scalar_toBytes.args (.value out) (.value l)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem.storeAt out (Scalar.toBytes.spec L) }) := by
  subst hL
  exact Scalar_toBytes.call_eq out l s hwf hout hl hL4

end Proof

/-! ## Meaning -/

/-- The bytes, little-endian, are the limbs' value, for limbs below `2^56`, the top below `2^32`. -/
public theorem Scalar.toBytes.toNat_spec {l : Fin 5 → BitVec 64} (hl : Fe.Lt l (2 ^ 56))
    (h4 : (l 4).toNat < 2 ^ 32) : (Scalar.toBytes.spec l).toNat = Scalar.val l := by
  have hw : (Scalar.toBytes.spec l).setWidth 320 = Scalar.wide l := by
    rw [Fe.eta5 l] at hl h4 ⊢
    have h0 := Scalar.lt56 (hl 0); have h1 := Scalar.lt56 (hl 1); have h2 := Scalar.lt56 (hl 2)
    have h3 := Scalar.lt56 (hl 3); have h4' : l 4 < 4294967296#64 := BitVec.lt_def.mpr h4
    simp only [Scalar.toBytes.spec, Scalar.wide, Fe.mk5] at *
    bv_decide
  rw [← Scalar.toNat_wide hl, ← hw, BitVec.toNat_setWidth]
  exact (Nat.mod_eq_of_lt (by have := (Scalar.toBytes.spec l).isLt; omega)).symm

/-- Canonical limbs' top one is below `2^32`. -/
public theorem Scalar.Canonical.top_lt {l : Fin 5 → BitVec 64} (h : Scalar.Canonical l) :
    (l 4).toNat < 2 ^ 32 := by
  have := h.2; have := Ed25519.ell_lt; unfold Scalar.val at *; omega

/-- Canonical limbs' bytes are their value, below `ℓ`. -/
public theorem Scalar.toBytes.toNat_spec_canonical {l : Fin 5 → BitVec 64}
    (h : Scalar.Canonical l) : (Scalar.toBytes.spec l).toNat = Scalar.val l :=
  Scalar.toBytes.toNat_spec h.1 h.top_lt

end LeanMLIR.RIR.Zig

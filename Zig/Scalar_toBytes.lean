module

public import MLIR.Run.Tactic
public import Zig.Common.Scalar
public import Zig.Mlir.Scalar_toBytes
import Std.Tactic.BVDecide

namespace MLIR.Zig

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
/-- The five splices cover all 256 bits: the limbs' bytes. -/
theorem splice_eq (b : BitVec 256) (v0 v1 v2 v3 v4 : BitVec 64) :
    spliceBits (spliceBits (spliceBits (spliceBits (spliceBits b 0 v0) 56 v1) 112 v2) 168 v3) 224
        (v4.setWidth 32) =
      (v4.setWidth 32 ++ v3.setWidth 56 ++ v2.setWidth 56 ++ v1.setWidth 56 ++ v0.setWidth 56 :
        BitVec 256) := by
  simp only [spliceBits_eq]
  bv_decide

/-- `Scalar.toBytes` stores `spec l` at `out`, for the top limb below `2^32`. -/
public theorem Scalar_toBytes.call_eq (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 256) (hl : s.mem.LimbsFit l)
    (hl4 : (s.mem.readLimbs l 4).toNat < 2 ^ 32) :
    Scalar_toBytes.call (Scalar_toBytes.args (.value out) (.value l)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeAt out (Scalar.toBytes.spec (s.mem.readLimbs l)) }) := by
  func_init
  have hl4' := hS ▸ hl4
  clear hl4
  block_init
  iterate 7 step_pure
  step_alloca with buf
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  iterate 2 step_pure
  step_load with v0 hv0
  step_store
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  iterate 2 step_pure
  step_load with v1 hv1
  step_store
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  iterate 2 step_pure
  step_load with v2 hv2
  step_store
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  iterate 2 step_pure
  step_load with v3 hv3
  step_store
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  iterate 2 step_pure
  step_load with v4 hv4
  have h4 : v4 < 4294967296#64 := by
    rw [hv4, BitVec.lt_def]; exact hl4'
  have h4' : v4.ult 4294967296#64 = true := by simpa [BitVec.ult, BitVec.lt_def] using h4
  have h4'' : (v4.setWidth 32).setWidth 64 = v4 := by bv_decide
  step_pure [h4']
  step_assume [h4']
  step_pure [h4'']
  step_store
  -- the five overlapping stores define all 32 bytes
  have hbuf_fits : Fits S.mem buf 256 := by
    have hov (k : BitVec 64) : ¬buf.offset.uaddOverflow k := by
      simp [hbuf_off, BitVec.uaddOverflow, k.isLt]
    have h1 : Fits S.mem buf 120 :=
      Fits.append (v := 56) (hov 7#64) rfl rfl (hfits_buf.mono (by omega)) hfits_buf_7
    have h2 : Fits S.mem buf 176 :=
      Fits.append (v := 112) (hov 14#64) rfl rfl (h1.mono (by omega)) hfits_buf_14
    have h3 : Fits S.mem buf 232 :=
      Fits.append (v := 168) (hov 21#64) rfl rfl (h2.mono (by omega)) hfits_buf_21
    exact Fits.append (v := 224) (hov 28#64) rfl rfl (h3.mono (by omega)) hfits_buf_28
  step_memcpy
  finish_block
  -- the first store, spliced into the slot's (undefined) bits
  have hb : InBounds (S₀.alloca 32).mem buf 256 := by
    have h := hbuf_room
    rw [hS] at h
    simp only [Room.storeAt_iff] at h
    exact h.inBounds
  have h0 :=
    MemoryState.readAt_add_storeAt (off := 0#64) (w := 64) hb
      (by simp [hbuf_off, BitVec.uaddOverflow]) (by decide) v0
  rw [Pointer.add_zero] at h0
  rw [hS]
  erase_frame
  rw [h0, show (0#64).toNat * 8 = 0 from rfl, splice_eq]
  subst hv0 hv1 hv2 hv3 hv4
  rfl

/-- `call_eq` on the limbs `L` read at `l`. -/
public theorem Scalar_toBytes.call_eq_of (out l : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 256) (hl : s.mem.LimbsFit l) (hL : s.mem.readLimbs l = L)
    (hL4 : (L 4).toNat < 2 ^ 32) :
    Scalar_toBytes.call (Scalar_toBytes.args (.value out) (.value l)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeAt out (Scalar.toBytes.spec L) }) := by
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
  exact
    (Nat.mod_eq_of_lt
        (by
          have := (Scalar.toBytes.spec l).isLt; omega)).symm

/-- Canonical limbs' top one is below `2^32`. -/
public theorem Scalar.Canonical.top_lt {l : Fin 5 → BitVec 64} (h : Scalar.Canonical l) :
    (l 4).toNat < 2 ^ 32 := by
  have := h.2; have := Ed25519.ell_lt; unfold Scalar.val at *; omega

/-- Canonical limbs' bytes are their value, below `ℓ`. -/
public theorem Scalar.toBytes.toNat_spec_canonical {l : Fin 5 → BitVec 64}
    (h : Scalar.Canonical l) : (Scalar.toBytes.spec l).toNat = Scalar.val l :=
  Scalar.toBytes.toNat_spec h.1 h.top_lt

end MLIR.Zig

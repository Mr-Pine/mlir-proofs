module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
public import Agave.Serial.Mlir.Sha512_Update_chain_slice_u8

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace Sha512_Update_chain_slice_u8

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem)

/-- sha2's `Sha512` at `self` moved to `out`: its 208 bytes, defined where they were. -/
def copyObj (m : MemoryState) (out self : Pointer) : MemoryState :=
  m.storeDef out (m.readAt self 1664) (m.definedAt self 1664)

end Sha512_Update_chain_slice_u8

end

/-! ## Proof -/

namespace Sha512_Update_chain_slice_u8

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem
  updateMem_absorbed room_updateMem wf_updateMem)

section Proof

attribute [local mlir_transport] room_updateMem wf_updateMem

/-- `copyObj` keeps a state well-formed. -/
theorem wf_copyObj {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, copyObj m out self⟩ : GlobalState).WF :=
  GlobalState.WF.storeDef_mk h

/-- `<Sha512 as Update>::chain(self, data)`: `len` bytes at `data` absorbed by sha2's `Sha512` at
`self` (`updateMem`), which then moves to `out`. The buffer's length (its last byte) is below `128`
and as many first bytes known; `self` is apart from `data` and `out`. -/
public theorem call_eq (out self data : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Sha512_Update_chain_slice_u8.globals) (hself : Room s.mem self 1664)
    (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hpos : Fits s.mem (self.add 127#64) 8) (hP128 : (s.mem.readAt (self.add 127#64) 8).toNat < 128)
    (hbuf : Fits s.mem self (8 * (s.mem.readAt (self.add 127#64) 8).toNat))
    (hst : s.mem.Sha512Fit (self.add 128#64)) (hbl : Fits s.mem (self.add 192#64) 128)
    (hout : Room s.mem out 1664) (hdata : Fits s.mem data (8 * len.toNat))
    (hdo : data.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63)
    (hsd : self.id ≠ data.id) (hso' : self.id ≠ out.id) :
    Sha512_Update_chain_slice_u8.call (args (.value out) (.value self) (.value data) (.value len))
        s =
      .value
        (.nil,
          { s with mem := copyObj (updateMem s.mem self data len) out self }) := by
  -- the end state's `WF`, for `func_init`'s frame-free form
  have hwfU :
      ({ s with mem := copyObj (updateMem s.mem self data len) out self } : GlobalState).WF :=
    wf_copyObj (a := s.alloc) (wf_updateMem hwf)
  func_init
  clear hwfU
  block_init
  step_pure
  step_pure
  step_call using
    (BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.call_eq
      (hP128 := hP128) (hbuf := hbuf)) consuming
    hg hpos hP128 hbuf hst hbl hdata
  step_memcpy
  finish_block
  subst hS
  rfl

/-! ## The absorbed bytes -/

/-- A range of the object, known at `self`: known at `out` after the move. -/
theorem copy_fits {m : MemoryState} {out self : Pointer} {k : BitVec 64} (hout : Room m out 1664)
    (hoo : out.offset.toNat + 208 < 2 ^ 64) (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hk : k.toNat * 8 + w ≤ 1664) (hs : Fits m (self.add k) w) :
    Fits (copyObj m out self) (out.add k) w :=
  Fits.storeDef_definedAt hout hs
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by
      simp [BitVec.uaddOverflow]; omega)
    hk

/-- A range of the object, read at `out` after the move: its bits at `self`. -/
theorem copy_read {m : MemoryState} {out self : Pointer} {k : BitVec 64} (hout : Room m out 1664)
    (hself : Room m self 1664) (hoo : out.offset.toNat + 208 < 2 ^ 64)
    (hso : self.offset.toNat + 208 < 2 ^ 64) (hk : k.toNat * 8 + w ≤ 1664) :
    (copyObj m out self).readAt (out.add k) w = m.readAt (self.add k) w :=
  MemoryState.readAt_storeDef_readAt_add hout hself.inBounds
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by
      simp [BitVec.uaddOverflow]; omega)
    hk _

/-- The state words' word pointers from the object's. -/
theorem add_128 (p : Pointer) (k : BitVec 64) : (p.add 128#64).add k = p.add (128#64 + k) :=
  Pointer.add_add p _ _

/-- The object moved to `out` has absorbed what it had. -/
theorem absorbed_copy {m : MemoryState} {out self : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed self M) (hout : Room m out 1664) (hoo : out.offset.toNat + 208 < 2 ^ 64) :
    (copyObj m out self).Sha2Absorbed out M := by
  obtain ⟨hso, hroom, hpf, hp, hbf, hb, ⟨_, h0, h1, h2, h3, h4, h5, h6, h7⟩, hst, hcf, hc⟩ := h
  have hlt : M.length % 128 < 128 := Nat.mod_lt _ (by decide)
  simp only [add_128] at h1 h2 h3 h4 h5 h6 h7 hst
  refine
    ⟨hoo, Room.storeDef hout, copy_fits hout hoo hso (by decide) hpf, ?_,
      Fits.storeDef_definedAt_self hout hbf (by omega), ?_,
      ⟨by
        simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega, ?_, ?_, ?_, ?_, ?_,
        ?_, ?_, ?_⟩,
      ?_, copy_fits hout hoo hso (by decide) hcf, ?_⟩
  · rw [copy_read hout hroom hoo hso (by decide), hp]
  · rw [copyObj, MemoryState.readAt_storeDef_readAt_le hout (by omega), hb]
  · exact copy_fits hout hoo hso (by decide) h0
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h1
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h2
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h3
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h4
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h5
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h6
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h7
  · rw [← hst]
    simp (disch := decide) only [MemoryState.readSha512, add_128, copy_read hout hroom hoo hso]
  · rw [copy_read hout hroom hoo hso (by decide), hc]

end Proof

/-- `<Sha512 as Update>::chain(self, data)` against SHA-512: when sha2's `Sha512` at `self` has
absorbed `M`, the object `call_eq` leaves at `out` has absorbed `M` and then the `len` bytes at
`data`. -/
public theorem chain_absorbed {m : MemoryState} {out self data : Pointer} {len : BitVec 64}
    {M : List (BitVec 8)} (h : m.Sha2Absorbed self M) (hout : Room m out 1664)
    (hoo : out.offset.toNat + 208 < 2 ^ 64) (hdata : Fits m data (8 * len.toNat))
    (hdo : data.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63)
    (hsd : self.id ≠ data.id) :
    (copyObj (updateMem m self data len) out self).Sha2Absorbed out
      (M ++ bytesLE (m.readAt data (8 * len.toNat))) :=
  absorbed_copy (updateMem_absorbed h hdata hdo hlen hsd) (room_updateMem hout) hoo

end Sha512_Update_chain_slice_u8

end MLIR.Agave.Serial

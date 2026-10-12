module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Avx2.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
public import Agave.Serial.Sha512_Update_chain_slice_u8
public import Agave.Avx2.Mlir.Sha512_Update_chain_slice_u8

namespace MLIR.Agave.Avx2

open _root_.Ed25519

namespace Sha512_Update_chain_slice_u8

open
  Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem
  updateCalls room_updateMem wf_updateMem)
open Serial.Sha512_Update_chain_slice_u8 (copyObj)

section Proof

attribute [local mlir_transport] room_updateMem wf_updateMem

/-- Nothing at or above a well-formed state's counter. -/
theorem eraseFrom_of_wf {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    m.eraseFrom a.nextFreeBlock = m :=
  h.eraseFrom

/-- `copyObj` keeps a state well-formed. -/
theorem wf_copyObj {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, copyObj m out self⟩ : GlobalState).WF :=
  GlobalState.WF.storeDef_mk h

/-- `<Sha512 as Update>::chain(self, data)`: `len` bytes at `data` absorbed by sha2's `Sha512` at
`self` (`updateMem`), which then moves to `out` (`copyObj`; the serial `chain_absorbed` says what
it has absorbed). The buffer's length (its last byte) is below `128` and as many first bytes
known; `self` is apart from `data` and `out`. -/
public theorem call_eq (out self data : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hself : Room s.mem self 1664) (hso : self.offset.toNat + 208 < 2 ^ 64)
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
          { alloc := ⟨s.alloc.nextFreeBlock + 4 * updateCalls s.mem self len⟩
            mem := copyObj (updateMem s.mem self data len) out self }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_call using
    (BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.call_eq
      (hP128 := hP128) (hbuf := hbuf)) consuming
    hpos hP128 hbuf hst hbl hdata
  step_memcpy
  finish_block
  subst hS
  dsimp only
  rw [← copyObj, eraseFrom_of_wf (wf_copyObj (wf_updateMem hwf₀))]

end Proof

end Sha512_Update_chain_slice_u8

end MLIR.Agave.Avx2

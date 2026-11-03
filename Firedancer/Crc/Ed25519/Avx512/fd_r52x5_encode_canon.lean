module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_encode_canon
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_encode_canon( out, sign, l )`'s four words: the 51-bit limbs `l` packed little-endian
into 255 bits, operands in the compiled order. -/
def fd_r52x5_encode_canon.words (l : Fin 5 → BitVec 64) : Fin 4 → BitVec 64
  | ⟨0, _⟩ => l 1 <<< 51 ||| l 0
  | ⟨1, _⟩ => l 2 <<< 38 ||| l 1 >>> 13
  | ⟨2, _⟩ => l 3 <<< 25 ||| l 2 >>> 26
  | ⟨3, _⟩ => l 4 <<< 12 ||| l 3 >>> 39

/-- Byte 31: `sign` in bit 7 xor bits `56 … 63` of `l[4] << 12`. -/
def fd_r52x5_encode_canon.top (sign : BitVec 64) (l : Fin 5 → BitVec 64) : BitVec 8 :=
  sign.truncate 8 <<< 7 ^^^ ((l 4 <<< 12) >>> 56).truncate 8

/-- The stores of `fd_r52x5_encode_canon( out, sign, l )`: the four words, then byte 31. -/
def fd_r52x5_encode_canon.store (m : MemoryState) (out : Pointer) (sign : BitVec 64)
    (l : Fin 5 → BitVec 64) : MemoryState :=
  ((((m.storeAt out (words l 0)).storeAt (out.add 8#64) (words l 1)).storeAt (out.add 16#64)
          (words l 2)).storeAt (out.add 24#64) (words l 3)).storeAt (out.add 31#64) (top sign l)

end

/-! ## Proof -/

section Proof

/-- The top byte of a word: its `trunc nuw` to `i8` does not wrap. -/
theorem setWidth_setWidth_shr56 (x : BitVec 64) :
    BitVec.setWidth 64 (BitVec.setWidth 8 (x >>> 56)) = x >>> 56 := by bv_decide

/-- `fd_r52x5_encode_canon( out, sign, l )` writes `store` of the word at `sign` and the limbs at
`l`, `out` in another block than either. -/
public theorem fd_r52x5_encode_canon.call_eq (out sign l : Pointer) (s : GlobalState)
    (hwf : s.WF) (ho : Room s.mem out 256) (hoff : out.offset.toNat + 32 < 2 ^ 64)
    (hs : Fits s.mem sign 64) (hl : s.mem.LimbsFit l) (hne : out.id ≠ l.id)
    (hns : out.id ≠ sign.id) :
    fd_r52x5_encode_canon.call
        (fd_r52x5_encode_canon.args (.value out) (.value sign) (.value l)) s =
      .value (.nil, { s with
        mem := fd_r52x5_encode_canon.store s.mem out (s.mem.readAt sign 64) (s.mem.readLimbs l) }) := by
  have hf0 := hl.2.1
  have hf1 := hl.2.2.1
  have hf2 := hl.2.2.2.1
  have hf3 := hl.2.2.2.2.1
  have hf4 := hl.2.2.2.2.2
  have hov (k : Nat) (hk : k ≤ 32) : ¬out.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  have ho0 : Room s.mem out 64 := ho.mono (by omega)
  have ho8 : Room s.mem (out.add 8#64) 64 := Room.add_of_le (hov 8 (by omega)) (by decide) ho
  have ho16 : Room s.mem (out.add 16#64) 64 := Room.add_of_le (hov 16 (by omega)) (by decide) ho
  have ho24 : Room s.mem (out.add 24#64) 64 := Room.add_of_le (hov 24 (by omega)) (by decide) ho
  have ho31 : Room s.mem (out.add 31#64) 8 := Room.add_of_le (hov 31 (by omega)) (by decide) ho
  clear ho
  func_init
  block_init
  iterate 9 step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_pure
  step_store
  iterate 3 (step_load; step_pure; step_pure; step_load; step_pure; step_pure; step_pure; step_store)
  step_load
  iterate 4 step_pure
  step_pure [setWidth_setWidth_shr56]
  step_pure
  step_store
  finish_block
  subst hS hv35
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512

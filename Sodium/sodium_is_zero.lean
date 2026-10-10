module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Sodium.Mlir.sodium_is_zero
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `1` if the first `len` bytes of `n` (byte `i` at bits `8i …`) are zero, else `0`: their or
`d` (through the volatile `e`), then `1 & ((e - 1) >> 8)` as an `int`. -/
def sodium_is_zero.spec (n : BitVec w) (len : Nat) : BitVec 32 :=
  let d := (List.range len).foldl (fun d i => d ||| n.extractLsb' (8 * i) 8) 0#8
  1#32 &&& (d.setWidth 32 - 1#32).sshiftRight 8

end

/-! ## Proof -/

section Proof

/-- `e + 511` (`nuw nsw`) of a byte does not wrap. -/
@[local simp]
theorem byte_add_511_s (x : BitVec 8) : ¬(x.setWidth 32).saddOverflow 511#32 := by bv_decide

@[local simp]
theorem byte_add_511_u (x : BitVec 8) : ¬(x.setWidth 32).uaddOverflow 511#32 := by bv_decide

/-- `sodium_is_zero` of `nlen = 32` (the field's encodings) returns `spec` of the 32 bytes at `n`,
the vectorized loop run once; memory is unchanged, the counter moves on by `e`'s slot. -/
public theorem sodium_is_zero.call_eq (n : Pointer) (s : GlobalState) (hwf : s.WF)
    (hn : Fits s.mem n 256) (hno : n.offset.toNat + 32 < 2 ^ 64) :
    sodium_is_zero.call (sodium_is_zero.args (.value n) (.value 32#64)) s =
      .value
        (.cons (.value (sodium_is_zero.spec (s.mem.readAt n 256) 32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  have hn_lo : Fits s.mem n 128 := hn.mono (by decide)
  have hn_hi : Fits s.mem (n.add 16#64) 128 :=
    Fits.add_of_le (Pointer.not_uaddOverflow_of_limbs hno (by decide)) (by decide) hn
  func_init
  block_init
  iterate 21 step_pure
  step_alloca with e
  step_pure
  step_pure
  finish_block
  -- `^bb1`, `^bb2`: `nlen` is neither below 4 nor below 32
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  -- `^bb3`, `^bb4`: the 32-byte vector loop, once
  block_init
  iterate 2 step_pure
  finish_block
  block_init
  iterate 2 step_pure
  step_load
  step_load
  iterate 2 step_pure
  step_pure [BitVec.uaddOverflow]
  step_pure
  finish_block
  -- `^bb5`: the lanes or-ed, and `nlen` was a multiple of 32
  block_init
  step_pure
  step_pure with d
  step_pure
  finish_block
  -- `^bb12`: e = d; __asm__("" : "+r"(e) :); return 1 & ((e - 1) >> 8);
  block_init
  step_store
  step_load
  step_pure
  step_store
  step_load
  iterate 4 step_pure
  step_pure
  finish_block
  subst hS
  erase_frame
  have key : (d.setWidth 32 + 511#32) >>> 8 &&& 1#32 = spec (S₀.mem.readAt n 256) 32 := by
    rw [hd,
      MemoryState.readAt_of_readAt_le (m := S₀.mem) (p := n) (v := 256) (w := 128) (by decide) rfl,
      MemoryState.readAt_add_of_readAt (off := 16#64) (w := 128) hn₀.inBounds
        (Pointer.not_uaddOverflow_of_limbs hno (by decide)) (by decide) rfl]
    generalize S₀.mem.readAt n 256 = x
    simp only [sodium_is_zero.spec, Ty.extractVecElem_eq, List.range_succ, List.range_zero,
      List.nil_append, List.foldl_append, List.foldl_cons, List.foldl_nil, Fin.val_ofNat_lit,
      Nat.reduceMod, Nat.reduceMul, BitVec.toNat_ofNat, Nat.reducePow]
    bv_decide
  rw [key]
  rfl

end Proof

end MLIR.Sodium

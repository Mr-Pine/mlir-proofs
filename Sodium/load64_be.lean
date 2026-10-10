module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_bswap
public import Sodium.Mlir.load64_be
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `LOAD64_BE`: the 8 bytes `x` (little-endian, as memory holds them), most significant first. -/
abbrev load64_be.spec (x : BitVec 64) : BitVec 64 :=
  Firedancer.Ref.fd_ulong_bswap.spec x

end

/-! ## Proof -/

section Proof

namespace load64_be

/-- A byte shifted left by `k ≤ 56` loses no bits, unsigned or signed (`k < 56`). -/
theorem byte_shl_ushr (b : BitVec 8) (k : Nat) (hk : k ≤ 56) :
    b.setWidth 64 <<< k >>> k = b.setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_ushiftRight, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
  by_cases h8 : i < 8
  · simp [show k + i < 64 by omega, hi]
  · have : b.getLsbD i = false := BitVec.getLsbD_of_ge b i (by omega)
    have : b.getLsbD (k + i - k) = false := BitVec.getLsbD_of_ge b _ (by omega)
    simp [*]

theorem byte_shl_sshr (b : BitVec 8) (k : Nat) (hk : k < 56) :
    (b.setWidth 64 <<< k).sshiftRight k = b.setWidth 64 := by
  have hmsb : (b.setWidth 64 <<< k).msb = false := by
    rw [BitVec.msb_eq_getLsbD_last, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
    have : b.getLsbD (64 - 1 - k) = false := BitVec.getLsbD_of_ge b _ (by omega)
    simp [this]
  rw [BitVec.sshiftRight_eq_of_msb_false hmsb, byte_shl_ushr b k (by omega)]

theorem or_disj1 (b6 b7 : BitVec 8) : b6.setWidth 64 <<< 8 &&& b7.setWidth 64 = 0#64 := by bv_decide

theorem or_disj2 (b5 b6 b7 : BitVec 8) :
    (b6.setWidth 64 <<< 8 ||| b7.setWidth 64) &&& b5.setWidth 64 <<< 16 = 0#64 := by bv_decide

theorem or_disj3 (b4 b5 b6 b7 : BitVec 8) :
    (b6.setWidth 64 <<< 8 ||| b7.setWidth 64 ||| b5.setWidth 64 <<< 16) &&& b4.setWidth 64 <<< 24 =
      0#64 := by
  bv_decide

theorem or_disj4 (b3 b4 b5 b6 b7 : BitVec 8) :
    (b6.setWidth 64 <<< 8 ||| b7.setWidth 64 ||| b5.setWidth 64 <<< 16 |||
          b4.setWidth 64 <<< 24) &&&
        b3.setWidth 64 <<< 32 =
      0#64 := by
  bv_decide

/-- The bytes' shifts and `or`s, as the steps leave them, swap the bytes. -/
theorem value_eq (x : BitVec 64) :
    (x.extractLsb' 48 8).setWidth 64 <<< 8 ||| (x.extractLsb' 56 8).setWidth 64 |||
        (x.extractLsb' 40 8).setWidth 64 <<< 16 |||
        (x.extractLsb' 32 8).setWidth 64 <<< 24 |||
        (x.extractLsb' 24 8).setWidth 64 <<< 32 |||
        (x.extractLsb' 16 8).setWidth 64 <<< 40 |||
        (x.extractLsb' 8 8).setWidth 64 <<< 48 |||
        (x.setWidth 8).setWidth 64 <<< 56 =
      spec x := by
  simp only [spec, Firedancer.Ref.fd_ulong_bswap.spec]
  bv_decide

end load64_be

open load64_be in
/-- `load64_be` returns the big-endian word at `src`. -/
public theorem load64_be.call_eq (src : Pointer) (s : GlobalState) (hwf : s.WF)
    (hsrc : Fits s.mem src 64) (hsrco : ¬src.offset.uaddOverflow 8#64) :
    load64_be.call (load64_be.args (.value src)) s =
      .value (.cons (.value (load64_be.spec (s.mem.readAt src 64))) .nil, s) := by
  generalize hx : s.mem.readAt src 64 = x
  func_init
  block_init
  iterate 7 step_pure
  step_pure
  step_load
  step_pure
  iterate 6 
    step_pure
    step_load
    step_pure
    step_pure [byte_shl_ushr _ _ (by decide : 8 ≤ 56), byte_shl_ushr _ _ (by decide : 16 ≤ 56),
      byte_shl_ushr _ _ (by decide : 24 ≤ 56), byte_shl_ushr _ _ (by decide : 32 ≤ 56),
      byte_shl_ushr _ _ (by decide : 40 ≤ 56), byte_shl_ushr _ _ (by decide : 48 ≤ 56),
      byte_shl_sshr _ _ (by decide : 8 < 56), byte_shl_sshr _ _ (by decide : 16 < 56),
      byte_shl_sshr _ _ (by decide : 24 < 56), byte_shl_sshr _ _ (by decide : 32 < 56),
      byte_shl_sshr _ _ (by decide : 40 < 56), byte_shl_sshr _ _ (by decide : 48 < 56)]
    step_pure [or_disj1, or_disj2, or_disj3, or_disj4]
  step_load
  step_pure
  step_pure [byte_shl_ushr _ _ (by decide : 56 ≤ 56)]
  step_pure
  finish_block
  rw [hS, value_eq]

end Proof

end MLIR.Sodium

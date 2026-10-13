module

public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Boringssl.fe_invert
public import Boringssl.fe_mul_ttt
public import Boringssl.fe_tobytes
public import Boringssl.fe_isnegative
public import Boringssl.Mlir.x25519_ge_tobytes

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref in
/-- The encoding of the `ge_p2` `P`: `y = Y / Z`'s bytes, `s[31] ^= sgn(x) << 7` for
`x = X / Z`. -/
def x25519_ge_tobytes.spec (P : GeP2) : BitVec 256 :=
  let recip := fe_loose_invert.spec P.Z
  let x := fiat_25519_carry_mul.spec P.X recip
  let y := fiat_25519_carry_mul.spec P.Y recip
  let s := fiat_25519_to_bytes.spec y
  Memory.spliceBits s 248 (((fd_f25519_sgn.spec x).setWidth 8 <<< 7#8) ^^^ s.extractLsb' 248 8)

end

/-! ## Proof -/

section Proof

/-- A splice into a splice that covers it: one splice of the inner value. -/
private theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
private theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu}
    {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu)
    (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- A sign is a bit: its `trunc nuw nsw` to a byte and `shl nuw` by 7 do not wrap. -/
private theorem sgn_bits {v : BitVec 32} {a : Fin 5 → BitVec 64}
    (h : v = Firedancer.Ref.fd_f25519_sgn.spec a) :
    (v.setWidth 8).setWidth 32 = v ∧
      (v.setWidth 8).signExtend 32 = v ∧ v.setWidth 8 <<< 7 >>> 7 = v.setWidth 8 := by
  subst h
  unfold Firedancer.Ref.fd_f25519_sgn.spec
  generalize Firedancer.Ref.fd_f25519_tobytes.spec a = b
  bv_decide

/-- `x25519_ge_tobytes` stores `spec` of the `ge_p2` at `h` at `out`, written only after `h` is
read, so they may alias. The temporaries' and callees' blocks are freed again: only the counter
moves on, by 51 blocks. -/
public theorem x25519_ge_tobytes.call_eq (out h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hh : s.mem.Fe3Fit h) :
    x25519_ge_tobytes.call (x25519_ge_tobytes.args (.value out) (.value h)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 51⟩,
            mem := s.mem.storeAt out (x25519_ge_tobytes.spec (s.mem.readP2 h)) }) := by
  have hov31 : ¬out.offset.uaddOverflow 31#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le] at hout_off ⊢
    simp only [BitVec.toNat_ofNat] at hout_off ⊢
    omega
  func_init
  have hh₀ : S₀.mem.Fe3Fit h := hS ▸ hh
  block_init
  iterate 2 step_pure
  -- fe recip; fe x; fe y;
  step_alloca with recip
  step_alloca with x
  step_alloca with y
  iterate 3 step_pure
  limbs_room recip
  limbs_room x
  limbs_room y
  -- fe_invert(&recip, &h->Z);
  step_pure
  step_call using fe_invert.call_eq
  -- fe_mul_ttt(&x, &h->X, &recip); fe_mul_ttt(&y, &h->Y, &recip);
  step_call using fe_mul_ttt.call_eq
  step_pure
  step_call using fe_mul_ttt.call_eq
  -- fe_tobytes(s, &y);
  step_call using fe_tobytes.call_eq
  -- s[31] ^= fe_isnegative(&x) << 7;
  step_call using fe_isnegative.call_eq with sgn_x
  obtain ⟨h1, h2, h3⟩ := sgn_bits hsgn_x
  step_pure
  step_load with s31
  step_pure [h1, h2]
  step_pure [h3]
  step_pure
  step_store
  iterate 3 step_pure
  finish_block
  rw [hS]
  erase_frame
  rw [storeAt_storeAt_add hov31 (by decide)]
  subst hs31 hsgn_x
  rfl

end Proof

end MLIR.Boringssl

module

public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_sha512_append
public import Boringssl.Common.Point
public import Sodium.fe25519_invert
public import Sodium.fe25519_mul
public import Sodium.fe25519_tobytes
public import Sodium.fe25519_isnegative
public import Sodium.Mlir.ge25519_tobytes

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The encoding of the `ge25519_p2` `P`: `y = Y / Z`'s bytes, `s[31] ^= isnegative(x) << 7` for
`x = X / Z`. -/
def ge25519_tobytes.spec (P : GeP2) : BitVec 256 :=
  let recip := fe25519_invert.spec P.Z
  let x := fe25519_mul.spec P.X recip
  let y := fe25519_mul.spec P.Y recip
  let s := fe25519_tobytes.spec y
  Memory.spliceBits s 248 (((fe25519_isnegative.spec x).setWidth 8 <<< 7#8) ^^^ s.extractLsb' 248 8)

end

/-! ## Proof -/

section Proof

/-- A sign is a bit: its `trunc nuw nsw` to a byte and `shl nuw` by 7 do not wrap. -/
theorem isnegative_bits {v : BitVec 32} {a : Fin 5 → BitVec 64}
    (h : v = fe25519_isnegative.spec a) :
    (v.setWidth 8).setWidth 32 = v ∧
      (v.setWidth 8).signExtend 32 = v ∧ v.setWidth 8 <<< 7 >>> 7 = v.setWidth 8 := by
  subst h
  unfold fe25519_isnegative.spec
  generalize fe25519_tobytes.spec a = b
  bv_decide

/-- `ge25519_tobytes` stores `spec` of the `ge25519_p2` at `h` at `s`, written only after `h` is
read, so they may alias. The temporaries' and callees' blocks are freed again: only the counter
moves on, by ten blocks. -/
public theorem ge25519_tobytes.call_eq (s h : Pointer) (st : GlobalState) (hwf : st.WF)
    (hs : Room st.mem s 256) (hso : s.offset.toNat + 32 < 2 ^ 64) (hh : st.mem.Fe3Fit h) :
    ge25519_tobytes.call (ge25519_tobytes.args (.value s) (.value h)) st =
      .value
        (.nil,
          { alloc := ⟨st.alloc.nextFreeBlock + 10⟩,
            mem := st.mem.storeAt s (ge25519_tobytes.spec (st.mem.readP2 h)) }) := by
  have hov31 : ¬s.offset.uaddOverflow 31#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    omega
  func_init
  have hh₀ : S₀.mem.Fe3Fit h := hS ▸ hh
  block_init
  iterate 2 step_pure
  -- fe25519 recip; fe25519 x; fe25519 y;
  step_alloca with recip
  step_alloca with x
  step_alloca with y
  iterate 3 step_pure
  limbs_room recip
  limbs_room x
  limbs_room y
  -- fe25519_invert(recip, h->Z);
  step_pure
  step_call using fe25519_invert.call_eq
  -- fe25519_mul(x, h->X, recip); fe25519_mul(y, h->Y, recip);
  step_call using fe25519_mul.call_eq
  step_pure
  step_call using fe25519_mul.call_eq
  -- fe25519_tobytes(s, y);
  step_call using fe25519_tobytes.call_eq
  -- s[31] ^= fe25519_isnegative(x) << 7;
  step_call using fe25519_isnegative.call_eq with sgn_x
  obtain ⟨h1, h2, h3⟩ := isnegative_bits hsgn_x
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
  rw [MemoryState.storeAt_storeAt_add hov31 (by decide)]
  subst hs31 hsgn_x
  rfl

end Proof

end MLIR.Sodium

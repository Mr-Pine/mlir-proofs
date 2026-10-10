module

public import MLIR.Run.Tactic
public import Sodium.Common.Sha512
public import Sodium.SHA512_Pad
public import Sodium.be64enc_vect
public import Sodium.sodium_memzero
public import Sodium.Mlir.crypto_hash_sha512_final

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The digest's 64 bytes: the padded state's words, big-endian. -/
def crypto_hash_sha512_final.spec (v : HashState) : BitVec 512 :=
  wordsLE (fun i => store64_be.spec (SHA512_Pad.spec v).state[i]!) 8

end

/-! ## Proof -/

section Proof

/-- `crypto_hash_sha512_final(state, out)` stores the digest (`spec`) at `out` and zeroes the
struct; it returns `0`. The buffer's first `r` bytes must be known; `out` must not share the
struct's block. The block counter advances by `tmp64`'s and `SHA512_Pad`'s. -/
public theorem crypto_hash_sha512_final.call_eq (st out : Pointer) (s : GlobalState) (hwf : s.WF)
    (hst : s.mem.HashStateFit st)
    (hpre : (s.mem.readHashState st).Prefix (SHA512_Pad.r (s.mem.readHashState st)))
    (hout : Room s.mem out 512) (houto : out.offset.toNat + 64 < 2 ^ 64) (hsep : out.id ≠ st.id) :
    crypto_hash_sha512_final.call (crypto_hash_sha512_final.args (.value st) (.value out)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1 + SHA512_Pad.blocks (s.mem.readHashState st)⟩,
            mem :=
              (s.mem.storeAt out (crypto_hash_sha512_final.spec (s.mem.readHashState st))).storeAt
                st (0 : BitVec (8 * (208#64).toNat)) }) := by
  generalize hv : s.mem.readHashState st = v at hpre ⊢
  generalize hres : crypto_hash_sha512_final.spec v = res
  generalize hk : SHA512_Pad.blocks v = k
  func_init
  have hv₀ : S₀.mem.readHashState st = v := hS ▸ hv
  clear hv
  block_init
  iterate 5 step_pure
  step_alloca with tmp
  step_lifetime
  have hv₁ : S.mem.readHashState st = v := by
    rw [hS, ← hv₀]
    refine MemoryState.readHashState_of_getElem?_eq ?_
    rw [MemoryState.lifetimeStart, MemoryState.getElem?_setLifetime_ne hst_ne_tmp,
      GlobalState.getElem?_alloca]
    rw [GlobalState.allocaPtr_eq_slot, ← htmp]
    exact hst_ne_tmp
  have htmpo : ¬tmp.offset.uaddOverflow 704#64 := by
    rw [htmp_off]; decide
  -- SHA512_Pad(state, tmp64);
  step_call using
    (SHA512_Pad.call_eq (hpre :=
      (congrArg (fun w => w.Prefix (SHA512_Pad.r w)) hv₁).mpr hpre)) consuming
    htmpo
  rw [hv₁] at hS
  clear hread_st hread_tmp hv₁
  have hsto := hst.1
  have hn : (64#64 >>> 3).toNat = 8 := by decide
  have hstw : Fits S.mem st (64 * (64#64 >>> 3).toNat) := hst.2.2.mono (by decide)
  have hsto' : st.offset.toNat + 8 * (64#64 >>> 3).toNat < 2 ^ 64 := by
    have := Pointer.offset_lt_of_hashState hsto; rw [hn]; omega
  have hout' : Room S.mem out (64 * (64#64 >>> 3).toNat) := by
    rw [hn]; exact hout
  have houto' : out.offset.toNat + 8 * (64#64 >>> 3).toNat < 2 ^ 64 := by
    rw [hn]; omega
  have hdisj :
    (Range.of out (64 * (64#64 >>> 3).toNat)).Disjoint (Range.of st (64 * (64#64 >>> 3).toNat)) :=
    .inl hsep
  -- be64enc_vect(out, state->state, 64);
  step_call using be64enc_vect.call_eq consuming hstw hsto' hout' houto' hdisj
  have hz1 : Room S.mem tmp (8 * (704#64).toNat) := hroom_tmp
  -- sodium_memzero((void *) tmp64, sizeof tmp64);
  step_call using sodium_memzero.call_eq consuming hz1
  have hz2 : Room S.mem st (8 * (208#64).toNat) := hst.2.1
  -- sodium_memzero((void *) state, sizeof *state);
  step_call using sodium_memzero.call_eq consuming hz2
  step_lifetime
  finish_block
  subst hS
  erase_frame
  subst hres hk
  have hin :
    InBounds
      (((S₀.alloca 704 true).mem.lifetimeStart tmp).storeAt tmp
        (SHA512_Pad.tailTmp (SHA512_Pad.head v)))
      st 1664 :=
    ((hst₀.inBounds.alloca hwf₀).lifetimeStart).storeAt
  have hw :
    ∀ i < 8,
      be64enc_vect.spec
          ((((S₀.alloca 704 true).mem.lifetimeStart tmp).storeAt tmp
                (SHA512_Pad.tailTmp (SHA512_Pad.head v))).storeHashState
            st (SHA512_Pad.spec v))
          st i =
        store64_be.spec (SHA512_Pad.spec v).state[i]! :=
    fun i hi => by rw [be64enc_vect.spec, MemoryState.readAt_storeHashState_word hin hsto hi]
  rw [MemoryState.storeWords_eq_storeAt (by omega), wordsLE_congr hw,
    MemoryState.storeHashState_storeAt_comm hsep,
    MemoryState.storeHashState_storeAt_self (by decide)]
  rfl

end Proof

end MLIR.Sodium

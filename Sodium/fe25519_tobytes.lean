module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Common.Memory
public import Agave.Common.Limbs
public import Sodium.fe25519_reduce
public import Sodium.store64_le
public import Sodium.Mlir.fe25519_tobytes

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The 32 bytes (little-endian) of `h`'s canonical limbs `t = fe25519_reduce.spec h`, packed into
the words `t0 … t3`; `or`s in the code's operand order. -/
def fe25519_tobytes.spec (h : Fin 5 → BitVec 64) : BitVec 256 :=
  let t := fe25519_reduce.spec h
  let t0 := t 1 <<< 51 ||| t 0
  let t1 := t 2 <<< 38 ||| t 1 >>> 13
  let t2 := t 3 <<< 25 ||| t 2 >>> 26
  let t3 := t 4 <<< 12 ||| t 3 >>> 39
  t3 ++ (t2 ++ (t1 ++ t0))

end

/-! ## Proof -/

section Proof

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self

/-- `fe25519_tobytes` stores `spec h` at `s`, its four words by `store64_le`. The limbs go
through a temporary, freed again: only the counter moves on, by one block. -/
public theorem fe25519_tobytes.call_eq (s h : Pointer) (st : GlobalState) (hwf : st.WF)
    (hs : Room st.mem s 256) (hso : s.offset.toNat + 32 < 2 ^ 64) (hh : st.mem.LimbsFit h) :
    fe25519_tobytes.call (fe25519_tobytes.args (.value s) (.value h)) st =
      .value
        (.nil,
          { alloc := ⟨st.alloc.nextFreeBlock + 1⟩,
            mem := st.mem.storeAt s (fe25519_tobytes.spec (st.mem.readLimbs h)) }) := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) : ¬s.offset.uaddOverflow k :=
    Pointer.not_uaddOverflow_of_limbs hso hk
  have hs0 : Room st.mem s 64 := hs.mono (by decide)
  have hs8 : Room st.mem (s.add 8#64) 64 := Room.add_of_le (hov 8#64 (by decide)) (by decide) hs
  have hs16 : Room st.mem (s.add 16#64) 64 := Room.add_of_le (hov 16#64 (by decide)) (by decide) hs
  have hs24 : Room st.mem (s.add 24#64) 64 := Room.add_of_le (hov 24#64 (by decide)) (by decide) hs
  func_init
  block_init
  iterate 8 step_pure
  -- fe25519 t;
  step_alloca with t
  step_pure
  limbs_room t
  -- fe25519_reduce(t, h);
  step_call using fe25519_reduce.call_eq consuming hh
  have ht0 : S.mem.readAt t 64 = _ := congrFun hread_t_readLimbs 0
  have ht1 : S.mem.readAt (t.add 8#64) 64 = _ := congrFun hread_t_readLimbs 1
  have ht2 : S.mem.readAt (t.add 16#64) 64 = _ := congrFun hread_t_readLimbs 2
  have ht3 : S.mem.readAt (t.add 24#64) 64 = _ := congrFun hread_t_readLimbs 3
  have ht4 : S.mem.readAt (t.add 32#64) 64 = _ := congrFun hread_t_readLimbs 4
  clear hread_t hread_t_readLimbs
  -- t0 = t[0] | (t[1] << 51); … t3 = (t[3] >> 39) | (t[4] << 12);
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  iterate 2
    step_pure
    step_load
    iterate 3 step_pure
  step_pure
  step_load
  iterate 2 step_pure
  -- STORE64_LE(s + 0, t0); … STORE64_LE(s + 24, t3);
  step_call using store64_le.call_eq
  iterate 3
    step_pure
    step_call using store64_le.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeAt_storeAt_append (k := 8) (hov 8#64 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 16) (hov 16#64 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 24) (hov 24#64 (by decide)) rfl (by decide)]
  rfl

end Proof

end MLIR.Sodium

module

public import MLIR.Run.Tactic
public import Sodium.Common.Sha512
public import Firedancer.Ref.fd_sha512_init
public import Sodium.Mlir.crypto_hash_sha512_init
import Std.Tactic.BVDecide

namespace MLIR.Sodium

open Memory

/-! ## Specification -/

@[expose] public section

/-- `count[0] = count[1] = 0`, `state` the initial hash value (Firedancer's `sha512IV`, the same
constants); `buf` as it was. -/
def crypto_hash_sha512_init.spec (v : HashState) : HashState :=
  { v with
    state := Firedancer.Ref.sha512IV, count0 := 0#64, count1 := 0#64 }

end

/-! ## Proof -/

section Proof

public theorem crypto_hash_sha512_init_sha512_initial_state.value_eq (s : GlobalState) :
    crypto_hash_sha512_init_sha512_initial_state.value s =
      .value (Ty.wrap crypto_hash_sha512_init_sha512_initial_state.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The initial state's bits: `sha512IV`, word `0` lowest. -/
theorem crypto_hash_sha512_init_sha512_initial_state.flatBits_lit
    {hw : (Ty.array 8 (.bv 64)).width = 512} :
    Ty.flatBits (hw := hw) crypto_hash_sha512_init_sha512_initial_state.lit =
      0x5be0cd19137e2179#64 ++ 0x1f83d9abfb41bd6b#64 ++ 0x9b05688c2b3e6c1f#64 ++
        0x510e527fade682d1#64 ++
        0xa54ff53a5f1d36f1#64 ++
        0x3c6ef372fe94f82b#64 ++
        0xbb67ae8584caa73b#64 ++
        0x6a09e667f3bcc908#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.flattenRaw_array,
    crypto_hash_sha512_init_sha512_initial_state.lit]
  decide +kernel

/-- `crypto_hash_sha512_init` sets up the struct at `st` (`spec`, its `buf` kept, defined or not)
and returns `0`. -/
public theorem crypto_hash_sha512_init.call_eq (st : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem st 1664) (hsto : ¬st.offset.uaddOverflow 208#64) :
    crypto_hash_sha512_init.call (crypto_hash_sha512_init.args (.value st)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeHashState st
                (crypto_hash_sha512_init.spec (s.mem.readHashState st)) }) := by
  func_init
  block_init
  iterate 3 step_pure
  step_addressof crypto_hash_sha512_init_sha512_initial_state.value_eq with iv
  step_pure
  step_pure
  step_memset
  step_memcpy
  finish_block
  subst hS
  erase_frame
  clear hfits_st hread_st hread_st_64 hread_iv hfits_st_64 hwf hroom hiv_room hiv_fits
  erw [crypto_hash_sha512_init_sha512_initial_state.flatBits_lit]
  congr 3
  generalize hx : S₀.mem.readAt st 1664 = X
  generalize hd : S₀.mem.definedAt st 1664 = D
  have hm : S₀.mem = S₀.mem.overlay st X D := by
    rw [← hx, ← hd, MemoryState.overlay_readAt_definedAt hroom₀.inBounds]
  have e (m' : MemoryState) (x : BitVec 512) : m'.storeAt st x = m'.storeAt (st.add 0#64) x := by
    rw [Pointer.add_zero]
  rw [MemoryState.readHashState, hx, hd, MemoryState.storeHashState]
  conv_lhs => rw [hm, e]
  simp (disch :=
    first
    | decide
    |
      exact
        Pointer.not_uaddOverflow_of_hashState hsto
          (by decide)) only [MemoryState.overlay_storeAt_add]
  congr 1 <;>
    simp only [crypto_hash_sha512_init.spec, HashState.ofBits, HashState.bits, HashState.low,
      HashState.defs, Firedancer.Ref.sha512IV, spliceBits_eq, BitVec.toNat_ofNat,
      reduceGetElemLit] <;>
    bv_decide

end Proof

end MLIR.Sodium

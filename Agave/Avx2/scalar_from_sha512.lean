module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Avx2.Sha512VarCore_VariableOutputCore_finalize_variable_core
public import Agave.Serial.scalar_from_sha512
public import Agave.Serial.Scalar52_from_bytes_wide
public import Agave.Serial.Scalar52_pack
public import Agave.Serial.IterMut_u8_Zeroize_zeroize
public import Agave.Avx2.Mlir.scalar_from_sha512
public import Firedancer.Common.Tactics
import Mathlib.Tactic.Rename

namespace MLIR.Agave.Avx2

open Serial.scalar_from_sha512 (absorbed_of_block absorbed_alloca absorbed_lifetimeStart
  absorbed_storeDef absorbed_storeCopy copyObj copy_fits copy_read add_128 absorbed_copy
  absorbed_after_copy eraseFrom_storeSha512_of_le)

attribute [local mlir_transport] absorbed_alloca absorbed_lifetimeStart absorbed_storeDef
  absorbed_storeCopy

attribute [local mlir_erase high] eraseFrom_storeSha512_of_le

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

/-- The blocks `scalar_from_sha512` allocates: its seven slots, `finalize_variable_core`'s and
`from_bytes_wide`'s 38. -/
def scalar_from_sha512.frames (M : List (BitVec 8)) : Nat :=
  7 + Sha512VarCore_VariableOutputCore_finalize_variable_core.framesOf M + 38

end

/-! ## Proof -/

namespace scalar_from_sha512

section Proof

/-- `output[k] = 0` for `k` in `a … b`: each byte's address and store, its facts dropped. -/
local macro "zero_bytes " a:num b:num : tactic => do
  let ks := (List.range (b.getNat + 1 - a.getNat)).map (· + a.getNat)
  ks.foldrM (init := ← `(tactic| skip)) fun k acc => do
      let f := Lean.mkIdent (.mkSimple s!"hfits_output_{k}")
      let r := Lean.mkIdent (.mkSimple s!"hread_output_{k}")
      `(tactic| (step_pure; step_store consuming $f $r; $acc))

/-! ### sha2's `Sha512` moved by `memcpy` -/

/-- `scalar_from_sha512(out, hash)` on sha2's `Sha512` at `hash` having absorbed `M`: stores
`Serial.scalar_from_sha512.spec M`, the scalar of SHA-512 of `M`, at `out` (32 bytes). The object
is copied first, so `hash` is unchanged; the temporaries' and callees' blocks are freed, only the
counter moves on. -/
public theorem call_eq (out hash : Pointer) (M : List (BitVec 8)) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals scalar_from_sha512.globals) (hA : s.mem.Sha2Absorbed hash M)
    (hout : Room s.mem out 256) (hoo : ¬out.offset.uaddOverflow 32#64) :
    scalar_from_sha512.call (args (.value out) (.value hash)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + scalar_from_sha512.frames M⟩,
            mem := s.mem.storeAt out (Serial.scalar_from_sha512.spec M) }) := by
  have hroom := hA.room
  func_init
  block_init
  iterate 5 step_pure
  step_alloca with zero
  step_alloca with s52
  step_alloca with digest
  step_alloca with hasher
  step_alloca with iter
  step_alloca with bytes
  step_alloca with output
  step_pure
  step_pure
  step_pure
  step_memcpy
  have hA' :=
    absorbed_after_copy hS
      (by
        simp (disch := mem_fact) only [MemoryState.lifetimeStart,
          MemoryState.getElem?_setLifetime_ne hhash_ne_output,
          MemoryState.getElem?_setLifetime_ne hhash_ne_digest,
          MemoryState.getElem?_setLifetime_ne hhash_ne_hasher, GlobalState.getElem?_alloca])
      rfl rfl hA hroom_hasher (by simp [hhasher_off]) hhash_ne_hasher.symm
  step_pure
  step_call using
    (Sha512VarCore_VariableOutputCore_finalize_variable_core.call_eq_absorbed (hA := hA')) consuming
    hA hA'
  step_pure
  step_memcpy
  step_pure
  step_pure
  step_memcpy
  step_pure
  have hs52_limbs := MemoryState.LimbsRoom.of_room hroom_s52 hs52_off
  step_call using Serial.Scalar52_from_bytes_wide.call_eq
  step_call using
    (Serial.Scalar52_pack.call_eq (hout := hout) (hout_off := hoo) (hl := hs52_limbs) (hsep :=
      hout_ne_s52))
  step_pure
  step_memset
  step_memcpy
  step_pure
  step_pure
  -- `output.zeroize()`
  clear_reads
  step_store consuming hfits_output hread_output
  zero_bytes 1 63
  clear_facts output zero s52 digest hasher
  -- `bytes.zeroize()`
  step_pure
  step_pure
  step_store
  step_pure
  step_store
  step_call using Serial.IterMut_u8_Zeroize_zeroize.call_eq consuming hwf hfits_out hout hroom
    hfits_bytes hroom_bytes hiter_bounds hbytes_bounds hroom_iter hread_iter hread_iter_8
  iterate 3 step_pure
  finish_block
  subst hS
  simp only [Serial.IterMut_u8_Zeroize_zeroize.spec]
  erase_frame
  simp only [scalar_from_sha512.frames, Serial.scalar_from_sha512.spec, GlobalState.alloca]
  congr 4
  omega

end Proof

end scalar_from_sha512

end MLIR.Agave.Avx2

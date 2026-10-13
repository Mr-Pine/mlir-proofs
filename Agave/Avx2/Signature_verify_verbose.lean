module

public import Agave.Avx2.CompressedEdwardsY_decompress
public import Agave.Avx2.FieldElement51_Neg_neg
public import Agave.Avx2.Mlir.Signature_verify_verbose
public import Agave.Avx2.Sha512_Update_chain_slice_u8
public import Agave.Avx2.VerificationKey_verify_dalek_prehashed
public import Agave.Avx2.scalar_from_sha512
public import Agave.Common.Decompress
public import Agave.Common.Sha512
public import Agave.Serial.Signature_verify_verbose
public import MLIR.Run.Tactic
import all Agave.Serial.Signature_verify_verbose
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open _root_.Ed25519

/-! ## Specification

The serial tree's, with the AVX2 `verify_dalek_prehashed`; `-A`, the challenge and the hash's call
count are `Serial`'s. -/

@[expose] public section

/-- `Signature::verify_verbose(sig, pubkey, msg)`: `1` (`MalformedPublicKey`) when `pubkey` does
not decompress (`A?`, its `decompress`), else `verify_dalek_prehashed` of `-A`, the signature's `R`
and `s`, and the challenge of `R`, `pubkey` and `msg`. -/
noncomputable def Signature_verify_verbose.spec (R S pk : BitVec 256) (A? : Option EdwardsPoint)
    (msg : List (BitVec 8)) : BitVec 8 :=
  match A? with
  | none => 1#8
  | some A =>
    VerificationKey_verify_dalek_prehashed.spec (Serial.Signature_verify_verbose.minusA A) R S
      (Serial.scalar_from_sha512.spec (bytesLE R ++ bytesLE pk ++ msg))

/-- The blocks `verify_verbose` allocates: its 16 slots, `decompress`'s, and on a key the hash's (3
per `compress512` call), `scalar_from_sha512`'s and `verify_dalek_prehashed`'s. -/
def Signature_verify_verbose.blocks (R S pk : BitVec 256) (A? : Option EdwardsPoint)
    (msg : List (BitVec 8)) (len : BitVec 64) : Nat :=
  match A? with
  | none => 16 + 158
  | some A =>
    16 + 159 + 3 * Serial.Signature_verify_verbose.chainCalls 64 len +
      scalar_from_sha512.frames (bytesLE R ++ bytesLE pk ++ msg) +
      VerificationKey_verify_dalek_prehashed.blocks (Serial.Signature_verify_verbose.minusA A) R S
        (Serial.scalar_from_sha512.spec (bytesLE R ++ bytesLE pk ++ msg))

end

/-! ## Proof -/

namespace Signature_verify_verbose

section Proof

open Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
  (globals_updateMem writable_updateMem)

open Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core (readBack)
open Serial.Signature_verify_verbose (fitsBack optEdwardsRoom_of readAt_storeOptEdwards_of_id_ne
  point_of_decomp decomp_some_eq edwards_of_bits limbsRoom_at key_store edwardsBits_Y edwardsBits_Z
  lifetimeEnd_storeAt_comm sig_reads iv_words absorbed_init fits_updateMem inBounds_updateMem
  readAt_updateMem_of_id_ne fits_copyObj inBounds_copyObj room_copyObj wf_copyObj_mk
  readAt_copyObj_of_id_ne absorbed_chain updateCalls_eq eraseFrom_updateMem_of_le scalar_lt
  absorbed_lifetimeEnd)

attribute [local mlir_read] readAt_storeOptEdwards_of_id_ne readAt_updateMem_of_id_ne
  readAt_copyObj_of_id_ne

open Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
attribute [local mlir_transport] fits_updateMem inBounds_updateMem fits_copyObj inBounds_copyObj
  room_copyObj wf_copyObj_mk absorbed_lifetimeEnd room_updateMem wf_updateMem

attribute [local mlir_erase high] eraseFrom_updateMem_of_le

open Serial (anon_042b818bc72209407b52bd0e4d6c8368_139)

/-- The IV global's initializer gives its folded constant, leaving the state. -/
theorem anon_042b818bc72209407b52bd0e4d6c8368_139.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_139.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_139.lit, s) :=
  Serial.Signature_verify_verbose.anon_042b818bc72209407b52bd0e4d6c8368_139.value_eq s

/-- `-&a` with `a`'s limbs `X`. -/
theorem neg_of (out a : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.LimbsRoom out)
    (ha : s.mem.LimbsFit a) {X : Fin 5 → BitVec 64} (hX : s.mem.readLimbs a = X) :
    FieldElement51_Neg_neg.call (FieldElement51_Neg_neg.args (.value out) (.value a)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs out (Serial.FieldElement51_Neg_neg.spec X) }) := by
  rw [FieldElement51_Neg_neg.call_eq out a s hwf hout ha, hX]

open Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
    Serial.Sha512_Update_chain_slice_u8 in
/-- `chain` on sha2's `Sha512` at `self` having absorbed `M`. -/
theorem chain_of (out self data : Pointer) (len : BitVec 64) (M : List (BitVec 8)) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals Sha512_Update_chain_slice_u8.globals)
    (hA : s.mem.Sha2Absorbed self M) (hout : Room s.mem out 1664)
    (hdata : Fits s.mem data (8 * len.toNat)) (hdo : data.offset.toNat + len.toNat < 2 ^ 64)
    (hlen : len.toNat < 2 ^ 63) (hsd : self.id ≠ data.id) (hso : self.id ≠ out.id) :
    Sha512_Update_chain_slice_u8.call
        (Sha512_Update_chain_slice_u8.args (.value out) (.value self) (.value data) (.value len))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3 * updateCalls s.mem self len⟩
            mem := copyObj (updateMem s.mem self data len) out self }) := by
  have hP := hA.pos
  exact
    Sha512_Update_chain_slice_u8.call_eq out self data len s hwf hg hA.room hA.off hA.posFits
      (by omega)
      (by
        rw [hP]; exact hA.bufFits)
      hA.stateFit hA.countFits hout hdata hdo hlen hsd hso

/-- `verify_dalek_prehashed` on the key `P`, the signature's `R` and `s`, the challenge `H`. -/
theorem verify_of (self sig h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals VerificationKey_verify_dalek_prehashed.globals)
    (hself : s.mem.PointFit (self.add 32#64)) (hself_off : ¬self.offset.uaddOverflow 32#64)
    (hsig : Fits s.mem sig 512) (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hh : Fits s.mem h 256)
    {P : EdwardsPoint} {R S H : BitVec 256} (hP : s.mem.readEdwards (self.add 32#64) = P)
    (hR : s.mem.readAt sig 256 = R) (hS : s.mem.readAt (sig.add 32#64) 256 = S)
    (hH : s.mem.readAt h 256 = H) (hlt : H.toNat < 2 ^ 255) :
    VerificationKey_verify_dalek_prehashed.call
        (VerificationKey_verify_dalek_prehashed.args (.value self) (.value sig) (.value h)) s =
      .value
        (.cons (.value (VerificationKey_verify_dalek_prehashed.spec P R S H)) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + VerificationKey_verify_dalek_prehashed.blocks P R S H⟩,
            mem := s.mem }) := by
  rw [VerificationKey_verify_dalek_prehashed.call_eq self sig h s hwf hg hself hself_off hsig
      hsig_off
      hh
      (by
        rw [hH]; exact hlt),
    hP, hR, hS, hH]

-- about 200 steps over a frame of 16 blocks and 9 calls: past the default heartbeats
set_option maxHeartbeats 800000 in
/-- `Signature::verify_verbose(sig, pubkey, msg)` on the 64-byte signature at `sig`, the 32-byte
public key at `pk` and `len` bytes at `msg`: returns `spec` (`1` for a key that does not
decompress, else `verify_dalek_prehashed`'s byte) and leaves the memory as it was; only the counter
moves on (`blocks`). -/
public theorem call_eq (sig pk msg : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Signature_verify_verbose.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64)
    (hpk : Fits s.mem pk 256) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hmsg : Fits s.mem msg (8 * len.toNat)) (hmo : msg.offset.toNat + len.toNat < 2 ^ 64)
    (hlen : len.toNat < 2 ^ 63) :
    Signature_verify_verbose.call (args (.value sig) (.value pk) (.value msg) (.value len)) s =
      .value
        (.cons
            (.value
              (Signature_verify_verbose.spec (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                (bytesLE (s.mem.readAt msg (8 * len.toNat)))))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  Signature_verify_verbose.blocks (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                    (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                    (bytesLE (s.mem.readAt msg (8 * len.toNat))) len⟩,
            mem := s.mem }) := by
  have hpk_split : s.mem.readAt pk 256 = s.mem.readAt (pk.add 1#64) 248 ++ s.mem.readAt pk 8 :=
    MemoryState.readAt_append (w := 248) (v := 8)
      (by
        simp [BitVec.uaddOverflow] at hpk_off ⊢; omega)
      rfl
  have hsig_split : s.mem.readAt sig 256 = s.mem.readAt (sig.add 1#64) 248 ++ s.mem.readAt sig 8 :=
    MemoryState.readAt_append (w := 248) (v := 8)
      (by
        simp [BitVec.uaddOverflow] at hsig_off ⊢; omega)
      rfl
  obtain ⟨pk0, hpk0⟩ : ∃ b, s.mem.readAt pk 8 = b := ⟨_, rfl⟩
  obtain ⟨pk1, hpk1⟩ : ∃ b, s.mem.readAt (pk.add 1#64) 248 = b := ⟨_, rfl⟩
  obtain ⟨sig0, hsig0⟩ : ∃ b, s.mem.readAt sig 8 = b := ⟨_, rfl⟩
  obtain ⟨sig1, hsig1⟩ : ∃ b, s.mem.readAt (sig.add 1#64) 248 = b := ⟨_, rfl⟩
  obtain ⟨S_bytes, hS_bytes⟩ : ∃ b, s.mem.readAt (sig.add 32#64) 256 = b := ⟨_, rfl⟩
  obtain ⟨msgb, hmsgb⟩ : ∃ b, s.mem.readAt msg (8 * len.toNat) = b := ⟨_, rfl⟩
  rw [hpk0, hpk1] at hpk_split
  rw [hsig0, hsig1] at hsig_split
  rw [hpk_split, hsig_split, hS_bytes, hmsgb]
  func_init
  have hS_bytes₀ : S₀.mem.readAt (sig.add 32#64) 256 = S_bytes := hS ▸ hS_bytes
  block_init
  iterate 8 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_139.value_eq with iv
  generalize hivb : Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_139.lit = ivb at hread_iv
  iterate 3 step_pure
  step_alloca with hasher0
  step_alloca with hasher1
  step_alloca with hasher2
  step_alloca with hasher3
  step_alloca with k
  step_alloca with key0
  step_alloca with A
  step_alloca with decomp
  step_alloca with A1
  step_alloca with A2
  step_alloca with A_bytes
  step_alloca with sig_tail
  step_alloca with signature
  step_alloca with key1
  step_alloca with key2
  step_alloca with key
  iterate 3 step_pure
  -- `VerificationKeyBytes::try_from(pubkey_bytes)`
  step_load
  step_pure
  step_pure
  step_pure
  step_memcpy
  step_store
  rw [MemoryState.storeAt_storeAt_below (off := 1#64) (by simp [BitVec.uaddOverflow, hA_bytes_off])
      rfl] at hS
  have hread_pkb : S.mem.readAt A_bytes 256 = pk1 ++ pk0 := readBack hS hroom_A_bytes
  clear hread_A_bytes hread_A_bytes_1 hfits_A_bytes hfits_A_bytes_1
  have hfits_pkb : Fits S.mem A_bytes 256 := fitsBack hS hroom_A_bytes
  iterate 4 step_pure
  have hdecomp_opt := optEdwardsRoom_of hroom_decomp hdecomp_off
  step_call using CompressedEdwardsY_decompress.call_eq consuming hdecomp_opt
  -- the globals and the writable blocks past `storeOptEdwards`, which the step does not see
  -- through
  any_goals
    rw [hS']
    first
    | exact hg.mono MemoryState.globals_storeOptEdwards fun _ h => h
    | exact Writable.storeOptEdwards (by assumption)
  obtain ⟨Aopt, hAopt⟩ : ∃ x, Serial.CompressedEdwardsY_decompress.spec (pk1 ++ pk0) = x := ⟨_, rfl⟩
  rw [hAopt] at hS hread_decomp ⊢
  rcases Aopt with _ | Apt
  · simp only [Option.isSome_none, Bool.false_eq_true, ↓reduceIte] at hread_decomp
    step_load
    step_pure
    finish_block
    block_init
    iterate 7 step_pure
    finish_block
    block_init
    step_pure
    finish_block
    subst hS
    simp only [MemoryState.storeOptEdwards]
    erase_frame
    simp only [Signature_verify_verbose.spec, Signature_verify_verbose.blocks, GlobalState.alloca,
      Option.isSome_none, Bool.false_eq_true, ↓reduceIte]
  · simp only [Option.isSome_some, ↓reduceIte] at hread_decomp
    step_load
    step_pure
    finish_block
    block_init
    -- `-A`
    step_pure
    step_pure
    have hfits_pt := (point_of_decomp hS (optEdwardsRoom_of hroom_decomp hdecomp_off)).2
    replace hS := decomp_some_eq hS (optEdwardsRoom_of hroom_decomp hdecomp_off)
    have hfits_pt' : Fits S.mem (decomp.add 8#64) (8 * (160#64).toNat) := hfits_pt
    step_memcpy consuming hfits_pt hfits_pt'
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_pure
    have hA_pt := (edwards_of_bits hfits_A (by simp [hA_off]) hread_A).1
    have hA_fit := (edwards_of_bits hfits_A (by simp [hA_off]) hread_A).2
    step_call using
      (neg_of (hout := limbsRoom_at hroom_key0 hkey0_off (k := 32#64) (by decide) (by decide))
        (ha := hA_fit.2.1) (hX := congrArg EdwardsPoint.X hA_pt))
    clear hread_A1_6 hread_A2_6 hread_decomp
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_call using
      (neg_of (hout := limbsRoom_at hroom_key0 hkey0_off (k := 152#64) (by decide) (by decide))
        (ha := hA_fit.2.2.2.2) (hX := congrArg EdwardsPoint.T hA_pt))
    step_memcpy
    rw [edwardsBits_Y, edwardsBits_Z, key_store hkey0_off] at hS
    clear hA_pt hA_fit hread_A hfits_A hread_key0 hfits_key0 hfits_key0_112 hfits_key0_72
    have hvk_read : S.mem.readAt key0 1536 = _ := readBack hS hroom_key0
    have hvk_fits : Fits S.mem key0 1536 := fitsBack hS hroom_key0
    step_pure
    step_memcpy
    iterate 4 step_pure
    step_memcpy
    step_pure
    step_memcpy
    step_pure
    clear hread_key1_6 hread_key2_6 hread_pkb
    -- `Signature::from_slice(self.as_ref())`
    step_pure
    step_pure
    step_pure
    step_load
    step_pure
    step_memcpy
    step_pure
    step_memcpy
    rw [hS_bytes₀,
      MemoryState.storeAt_storeAt_concat (off := 31#64)
        (by simp [BitVec.uaddOverflow, hsig_tail_off]) rfl] at hS
    clear hread_sig_tail hread_sig_tail_31 hfits_sig_tail hfits_sig_tail_31 hvk_read
    have hst_read : S.mem.readAt sig_tail 504 = _ := readBack hS hroom_sig_tail
    have hst_fits : Fits S.mem sig_tail (8 * (63#64).toNat) := fitsBack hS hroom_sig_tail
    step_pure
    step_memcpy
    step_pure
    step_store
    clear hst_read hread_signature hread_signature_1 hfits_signature hfits_signature_1
    have hne : sig_tail.id ≠ signature.id := by mem_fact
    rw [lifetimeEnd_storeAt_comm (p := signature.add 1#64) hne] at hS
    have hsigF := (sig_reads hS hroom_signature hsignature_off).1
    have hsigR := (sig_reads hS hroom_signature hsignature_off).2.1
    have hsigS := (sig_reads hS hroom_signature hsignature_off).2.2
    clear hne
    -- `Sha512::default()`
    iterate 5 step_pure
    step_pure
    step_memcpy
    step_pure
    step_store
    step_pure
    step_store
    have hA0 :=
      absorbed_init hS
        (by
          rw [← hivb]; exact iv_words)
        hroom_hasher0 hhasher0_off
    clear hfits_hasher0_127 hread_hasher0_127 hread_hasher0_192 hread_hasher0_128 hfits_hasher0_192
      hfits_hasher0_128 hroom_hasher0 hhasher0_bounds hiv_live hiv_fits hread_iv hkey0_bounds
      hA_bounds hdecomp_bounds hA1_bounds hA2_bounds hA_bytes_bounds hsig_tail_bounds hkey1_bounds
      hkey2_bounds hpk0 hpk_split hpk1 hsig0 hsig_split hsig1 hS_bytes hpk hsig
    -- `.chain(&signature.r_bytes()[..])`
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA0' : m₁.Sha2Absorbed hasher0 [] := hm₁ ▸ hA0
    have hroom1' : Room m₁ hasher1 1664 := hm₁ ▸ hroom_hasher1
    have hsigF' : Fits m₁ signature (8 * (32#64).toNat) := hm₁ ▸ hsigF.mono (by decide)
    have hsigR' : m₁.readAt signature (8 * (32#64).toNat) = sig1 ++ sig0 := hm₁ ▸ hsigR
    step_call using (chain_of (M := []) (hA := hA0) (hdata := hsigF.mono (by decide))) consuming hA0
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs1 :=
      absorbed_chain hS hA0' hroom1' hhasher1_off hsigF' (by simp [hsignature_off]) (by decide)
        (by mem_fact)
    rw [updateCalls_eq hA0', ← hm₁] at hS
    rw [hsigR', List.nil_append] at hAbs1
    clear hA0' hroom1' hsigF' hsigR' hm₁ m₁
    step_pure
    -- `.chain(&self.A_bytes.0[..])`
    have hkeyR : S.mem.readAt key 256 = pk1 ++ pk0 := by
      have :=
        MemoryState.readAt_add_of_readAt (off := 0#64) (w := 256) hfits_key.inBounds
          (by simp [BitVec.uaddOverflow, hkey_off]) (by decide) hread_key
      rw [Pointer.add_zero] at this
      rw [this]
      exact BitVec.extractLsb'_append_eq_right
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA' : m₁.Sha2Absorbed hasher1 (bytesLE (sig1 ++ sig0)) := hm₁ ▸ hAbs1
    have hroom' : Room m₁ hasher2 1664 := hm₁ ▸ hroom_hasher2
    have hF' : Fits m₁ key (8 * (32#64).toNat) := hm₁ ▸ hfits_key.mono (by decide)
    have hR' : m₁.readAt key (8 * (32#64).toNat) = pk1 ++ pk0 := by
      rw [← hm₁]; exact hkeyR
    step_call using (chain_of (hA := hAbs1) (hdata := hfits_key.mono (by decide))) consuming hAbs1
      hkeyR
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs2 :=
      absorbed_chain hS hA' hroom' hhasher2_off hF' (by simp [hkey_off]) (by decide) (by mem_fact)
    rw [updateCalls_eq hA', ← hm₁] at hS
    rw [hR'] at hAbs2
    clear hA' hroom' hF' hR' hm₁ m₁
    step_pure
    -- `.chain(msg)`
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA' : m₁.Sha2Absorbed hasher2 (bytesLE (sig1 ++ sig0) ++ bytesLE (pk1 ++ pk0)) :=
      hm₁ ▸ hAbs2
    have hroom' : Room m₁ hasher3 1664 := hm₁ ▸ hroom_hasher3
    have hF' : Fits m₁ msg (8 * len.toNat) := hm₁ ▸ hmsg
    have hR' : m₁.readAt msg (8 * len.toNat) = msgb := hm₁ ▸ hmsgb
    step_call using (chain_of (hA := hAbs2)) consuming hAbs2 hmsg hmsgb
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs3 := absorbed_chain hS hA' hroom' hhasher3_off hF' hmo hlen (by mem_fact)
    rw [updateCalls_eq hA', ← hm₁] at hS
    rw [hR'] at hAbs3
    clear hA' hroom' hF' hR' hm₁ m₁
    step_pure
    -- `scalar_from_sha512(..)`
    step_call using (scalar_from_sha512.call_eq (hA := hAbs3)) consuming hAbs3
    step_pure
    -- `verify_dalek_prehashed(&signature, k)`
    have hkey_ov : ¬key.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hkey_off]
    have hkeyP :
      S.mem.readAt (key.add 32#64) 1280 =
        edwardsBits (Serial.Signature_verify_verbose.minusA Apt) := by
      rw [MemoryState.readAt_add_of_readAt hfits_key.inBounds hkey_ov (by decide) hread_key]
      exact BitVec.extractLsb'_append_eq_left
    have hkeyF : Fits S.mem (key.add 32#64) 1280 := Fits.add_of_le hkey_ov (by decide) hfits_key
    have hPt := edwards_of_bits hkeyF (by simp [Pointer.add, hkey_off]) hkeyP
    step_call using
      (verify_of key signature k (hself := hPt.2) (hP := hPt.1) (hR := hsigR) (hS := hsigS) (hH :=
        hread_k) (hlt := scalar_lt _)) consuming
      hPt hkeyP hkeyF
    step_pure
    step_pure
    finish_block
    block_init
    step_pure
    finish_block
    subst hS
    simp only [Serial.Sha512_Update_chain_slice_u8.copyObj]
    erase_frame
    have h0 :
      Serial.Signature_verify_verbose.chainCalls (([] : List (BitVec 8)).length % 128) 32#64 =
        0 := by
      decide
    have h1 :
      Serial.Signature_verify_verbose.chainCalls ((bytesLE (sig1 ++ sig0)).length % 128) 32#64 =
        0 := by
      simp only [length_bytesLE]; decide
    have h2 : (bytesLE (sig1 ++ sig0) ++ bytesLE (pk1 ++ pk0)).length % 128 = 64 := by simp
    simp only [h0, h1, h2, Signature_verify_verbose.spec, Signature_verify_verbose.blocks,
      GlobalState.alloca, Option.isSome_some, ↓reduceIte, List.append_assoc]
    congr 4
    omega

end Proof

end Signature_verify_verbose

end MLIR.Agave.Avx2

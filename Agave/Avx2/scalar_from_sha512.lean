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

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

/-- The blocks `scalar_from_sha512` allocates: its seven slots, `finalize_variable_core`'s and
`from_bytes_wide`'s. -/
def scalar_from_sha512.frames (M : List (BitVec 8)) : Nat :=
  7 + Sha512VarCore_VariableOutputCore_finalize_variable_core.framesOf M + 40

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

/-- A block unchanged keeps its object's absorbed bytes. -/
theorem absorbed_of_block {m m' : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (hb : m'[d.id]? = m[d.id]?) (h : m.Sha2Absorbed d M) : m'.Sha2Absorbed d M := by
  have hf {p : Pointer} {w : Nat} (h : Fits m p w) (hp : p.id = d.id) : Fits m' p w := by
    simpa only [Fits, hp, hb] using h
  have hr (p : Pointer) (hp : p.id = d.id) (w : Nat) : m'.readAt p w = m.readAt p w := by
    simp only [MemoryState.readAt, hp, hb]
  have hs : m'.readSha512 (d.add 128#64) = m.readSha512 (d.add 128#64) := by
    simp only [MemoryState.readSha512, MemoryState.readAt, Pointer.add_id, hb]
  obtain ⟨hoff, hroom, hpf, hp, hbf, hbuf, ⟨hso, h0, h1, h2, h3, h4, h5, h6, h7⟩, hst, hcf, hc⟩ := h
  refine
    ⟨hoff, by simpa only [Room, hb] using hroom, hf hpf rfl, by rwa [hr (d.add 127#64) rfl],
      hf hbf rfl, by rwa [hr d rfl],
      ⟨hso, hf h0 rfl, hf h1 rfl, hf h2 rfl, hf h3 rfl, hf h4 rfl, hf h5 rfl, hf h6 rfl, hf h7 rfl⟩,
      by rwa [hs], hf hcf rfl, by rwa [hr (d.add 192#64) rfl]⟩

@[local mlir_transport]
theorem absorbed_alloca {s : GlobalState} {d : Pointer} {M : List (BitVec 8)}
    (hne : d.id ≠ s.allocaPtr.id) (h : s.mem.Sha2Absorbed d M) :
    (s.alloca n b).mem.Sha2Absorbed d M :=
  absorbed_of_block (GlobalState.getElem?_alloca hne) h

@[local mlir_transport]
theorem absorbed_lifetimeStart {m : MemoryState} {d q : Pointer} {M : List (BitVec 8)}
    (hne : d.id ≠ q.id) (h : m.Sha2Absorbed d M) : (m.lifetimeStart q).Sha2Absorbed d M :=
  absorbed_of_block (MemoryState.getElem?_setLifetime_ne hne) h

@[local mlir_transport]
theorem absorbed_storeDef {m : MemoryState} {d q : Pointer} {M : List (BitVec 8)} {x y : BitVec w}
    (hne : d.id ≠ q.id) (h : m.Sha2Absorbed d M) : (m.storeDef q x y).Sha2Absorbed d M :=
  absorbed_of_block (MemoryState.getElem?_storeDef_ne hne) h

/-- sha2's `Sha512` at `self` copied to `out`: its 208 bytes, defined where they were. -/
abbrev copyObj (m : MemoryState) (out self : Pointer) : MemoryState :=
  m.storeDef out (m.readAt self 1664) (m.definedAt self 1664)

/-- A range of the object, known at `self`: known at `out` after the copy. -/
theorem copy_fits {m : MemoryState} {out self : Pointer} {k : BitVec 64} (hout : Room m out 1664)
    (hoo : out.offset.toNat + 208 < 2 ^ 64) (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hk : k.toNat * 8 + w ≤ 1664) (hs : Fits m (self.add k) w) :
    Fits (copyObj m out self) (out.add k) w :=
  Fits.storeDef_definedAt hout hs
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by
      simp [BitVec.uaddOverflow]; omega)
    hk

/-- A range of the object, read at `out` after the copy: its bits at `self`. -/
theorem copy_read {m : MemoryState} {out self : Pointer} {k : BitVec 64} (hout : Room m out 1664)
    (hself : Room m self 1664) (hoo : out.offset.toNat + 208 < 2 ^ 64)
    (hso : self.offset.toNat + 208 < 2 ^ 64) (hk : k.toNat * 8 + w ≤ 1664) :
    (copyObj m out self).readAt (out.add k) w = m.readAt (self.add k) w :=
  MemoryState.readAt_storeDef_readAt_add hout.inBounds hself.inBounds
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by
      simp [BitVec.uaddOverflow]; omega)
    hk _

/-- The state words' word pointers from the object's. -/
theorem add_128 (p : Pointer) (k : BitVec 64) : (p.add 128#64).add k = p.add (128#64 + k) :=
  Pointer.add_add p _ _

/-- The object copied to `out` has absorbed what it had. -/
theorem absorbed_copy {m : MemoryState} {out self : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed self M) (hout : Room m out 1664) (hoo : out.offset.toNat + 208 < 2 ^ 64) :
    (copyObj m out self).Sha2Absorbed out M := by
  obtain ⟨hso, hroom, hpf, hp, hbf, hb, ⟨_, h0, h1, h2, h3, h4, h5, h6, h7⟩, hst, hcf, hc⟩ := h
  have hlt : M.length % 128 < 128 := Nat.mod_lt _ (by decide)
  simp only [add_128] at h1 h2 h3 h4 h5 h6 h7 hst
  refine
    ⟨hoo, Room.storeDef hout, copy_fits hout hoo hso (by decide) hpf, ?_,
      Fits.storeDef_definedAt_self hout hbf (by omega), ?_,
      ⟨by
        simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega, ?_, ?_, ?_, ?_, ?_,
        ?_, ?_, ?_⟩,
      ?_, copy_fits hout hoo hso (by decide) hcf, ?_⟩
  · rw [copy_read hout hroom hoo hso (by decide), hp]
  · rw [copyObj, MemoryState.readAt_storeDef_readAt_le hout.inBounds (by omega), hb]
  · exact copy_fits hout hoo hso (by decide) h0
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h1
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h2
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h3
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h4
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h5
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h6
  · simp only [add_128]; exact copy_fits hout hoo hso (by decide) h7
  · rw [← hst]
    simp (disch := decide) only [MemoryState.readSha512, add_128, copy_read hout hroom hoo hso]
  · rw [copy_read hout hroom hoo hso (by decide), hc]

/-- The `memcpy` of sha2's `Sha512` at `d` to `dst`, its bits read where its block is the same:
the copy has absorbed what `d` has. -/
theorem absorbed_after_copy {S : GlobalState} {a : AllocState} {m m₀ m₁ : MemoryState}
    {d dst : Pointer} {M : List (BitVec 8)}
    (hS : S = ⟨a, m.storeDef dst (m₀.readAt d 1664) (m₁.definedAt d 1664)⟩)
    (hb₀ : m₀[d.id]? = m[d.id]?) (hb₁ : m₁[d.id]? = m[d.id]?) (hA : S.mem.Sha2Absorbed d M)
    (hroom : Room S.mem dst 1664) (hdo : dst.offset.toNat + 208 < 2 ^ 64) (hne : dst.id ≠ d.id) :
    S.mem.Sha2Absorbed dst M := by
  subst hS
  have hr : m₀.readAt d 1664 = m.readAt d 1664 := by simp only [MemoryState.readAt, hb₀]
  have hd : m₁.definedAt d 1664 = m.definedAt d 1664 := by simp only [MemoryState.definedAt, hb₁]
  simp only [hr, hd] at hA ⊢
  exact
    absorbed_copy (absorbed_of_block (MemoryState.getElem?_storeDef_ne (Ne.symm hne)).symm hA)
      (Room.storeDef_iff.1 hroom) hdo

/-- State words stored into an erased block are dropped with it. -/
@[local mlir_erase high]
theorem eraseFrom_storeSha512_of_le {m : MemoryState} {p : Pointer} {v : Vector (BitVec 64) 8}
    (h : n ≤ p.id.id) : (m.storeSha512 p v).eraseFrom n = m.eraseFrom n := by
  simp only [MemoryState.storeSha512, MemoryState.eraseFrom_storeAt_of_le (p := p.add _) h,
    MemoryState.eraseFrom_storeAt_of_le h]

/-- `scalar_from_sha512(out, hash)` on sha2's `Sha512` at `hash` having absorbed `M`: stores
`Serial.scalar_from_sha512.spec M`, the scalar of SHA-512 of `M`, at `out` (32 bytes). The object
is copied first, so `hash` is unchanged; the temporaries' and callees' blocks are freed, only the
counter moves on. -/
public theorem call_eq (out hash : Pointer) (M : List (BitVec 8)) (s : GlobalState) (hwf : s.WF)
    (hA : s.mem.Sha2Absorbed hash M) (hout : Room s.mem out 256)
    (hoo : ¬out.offset.uaddOverflow 32#64) :
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
      rfl hA hroom_hasher (by simp [hhasher_off]) hhash_ne_hasher.symm
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

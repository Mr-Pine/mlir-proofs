module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Ref.fd_sha512_init

/-! What the implementations of `fd_ed25519_verify` share: its result, the hash of
`r ‖ publicKey ‖ msg`, and the memory its SHA-512 calls leave. -/

namespace LeanMLIR.RIR.Firedancer

open Ref

/-! ## Specification -/

@[expose] public section

/-- Eight 64-bit words as the 64 bytes they are stored as, word 0 lowest. -/
def Words8.bits (v : Vector (BitVec 64) 8) : BitVec 512 :=
  v[7] ++ v[6] ++ v[5] ++ v[4] ++ v[3] ++ v[2] ++ v[1] ++ v[0]

/-- What `fd_ed25519_verify` does: the code it returns, the `fd_sha512_t` it leaves when it hashes,
and the blocks its frame and its callees' count. -/
structure fd_ed25519_verify.Result where
  ret : BitVec 32
  sha : Option ShaState
  blocks : Nat

/-- The hash objects `fd_ed25519_verify`'s SHA-512 calls leave on `r ‖ publicKey ‖ msg`, from
`init` on a buffer `buf0` to `append`'s three. -/
def fd_ed25519_verify.shaStates (buf0 : BitVec 1024) (r publicKey : BitVec 256) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) : ShaState × ShaState × ShaState × ShaState :=
  let sha0 : ShaState := ⟨buf0, sha512IV, 0#64, 0#64, 0#64⟩
  let sha1 := fd_sha512_append.spec sha0 32#64 r
  let sha2 := fd_sha512_append.spec sha1 32#64 publicKey
  (sha0, sha1, sha2, fd_sha512_append.spec sha2 msgSz msg)

/-- `fd_sha512_fini` after them: the hash object and the digest's words. -/
def fd_ed25519_verify.hash (buf0 : BitVec 1024) (r publicKey : BitVec 256) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) : ShaState × Vector (BitVec 64) 8 :=
  fd_sha512_fini.spec (fd_ed25519_verify.shaStates buf0 r publicKey msgSz msg).2.2.2

/-- The blocks the SHA-512 calls' `core` calls count. -/
def fd_ed25519_verify.hashBlocks (buf0 : BitVec 1024) (r publicKey : BitVec 256) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) : Nat :=
  let (sha0, sha1, sha2, sha3) := fd_ed25519_verify.shaStates buf0 r publicKey msgSz msg
  2 *
    (fd_sha512_append.cores sha0 32#64 + fd_sha512_append.cores sha1 32#64 +
      fd_sha512_append.cores sha2 msgSz +
      fd_sha512_fini.cores sha3)

/-- `fd_sha512_init`'s stores at `sha`. -/
def fd_sha512_init.stores (m : MemoryState) (sha : Pointer) : MemoryState :=
  (((((((((m.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64) sha512IV[1]).storeAt
                            (sha.add 144#64) sha512IV[2]).storeAt
                        (sha.add 152#64) sha512IV[3]).storeAt
                    (sha.add 160#64) sha512IV[4]).storeAt
                (sha.add 168#64) sha512IV[5]).storeAt
            (sha.add 176#64) sha512IV[6]).storeAt
        (sha.add 184#64) sha512IV[7]).storeAt
    (sha.add 200#64) 0#192)

/-- The memory after `fd_ed25519_verify`'s SHA-512 calls: `init`'s stores at `sha`, the hash
object `X` stored over them, and the digest's words `w` at `k`. -/
def fd_ed25519_verify.hashMem (m : MemoryState) (sha k : Pointer) (X : ShaState)
    (w : Vector (BitVec 64) 8) : MemoryState :=
  ((fd_sha512_init.stores m sha).storeSha sha X).storeWords8 k w

/-- The memory `fd_ed25519_verify` leaves: the hash object after `fd_sha512_fini` when it hashes,
else the memory it started with. -/
def fd_ed25519_verify.Result.mem (res : fd_ed25519_verify.Result) (m : MemoryState)
    (sha : Pointer) : MemoryState :=
  match res.sha with
  | some X => (fd_sha512_init.stores m sha).storeSha sha X
  | none => m

/-! ## Lemmas -/

/-- A comparison's flag as the comparison. -/
theorem ite_ofBool_beq {x y : BitVec w} {a b : α} :
    (if BitVec.ofBool (x == y) = 1#1 then a else b) = if x = y then a else b := by
  by_cases h : x = y
  · simp [h]
  · have hb : (x == y) = false := beq_eq_false_iff_ne.mpr h
    simp [h, hb]

/-- A pointer at a positive offset into a range that does not wrap is not null. -/
theorem _root_.LeanMLIR.RIR.Pointer.add_ne_null {p : Pointer} {a b : BitVec 64}
    (h : ¬p.offset.uaddOverflow b) (ha : 0 < a.toNat) (hab : a.toNat ≤ b.toNat) :
    p.add a ≠ Pointer.null := by
  intro he
  have hoff := congrArg (fun q : Pointer => q.offset.toNat) he
  simp only [Pointer.add, Pointer.null,
    BitVec.toNat_add_of_not_uaddOverflow (BitVec.not_uaddOverflow_of_le h hab)] at hoff
  simp at hoff
  omega

/-- A hash object stored twice: the second. -/
theorem _root_.LeanMLIR.RIR.MemoryState.storeSha_storeSha_self {m : MemoryState}
    (h : ¬p.offset.uaddOverflow 256#64) : (m.storeSha p a).storeSha p b = m.storeSha p b := by
  rw [MemoryState.storeSha.eq_1 (m.storeSha p a) p b,
    MemoryState.storeSha_storeAt_buf_base h le_rfl, MemoryState.storeSha_storeAt_bufUsed h,
    MemoryState.storeSha_storeAt_bitCntLo h, MemoryState.storeSha_storeAt_bitCntHi h,
    MemoryState.storeSha_storeWords8_state]
  have hbuf : Memory.spliceBits a.buf 0 b.buf = b.buf := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    rw [Memory.getLsbD_spliceBits]
    simp [hi]
  rw [hbuf]

/-- A framed callee's state over a hash object store keeps `WF`. -/
theorem _root_.LeanMLIR.RIR.GlobalState.WF.add_blocks_storeSha {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeSha p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeSha (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

/-- `add_blocks_storeSha`, then the digest's words. -/
theorem _root_.LeanMLIR.RIR.GlobalState.WF.add_blocks_storeSha_storeWords8 {s : GlobalState}
    (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeSha p v).storeWords8 q w⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeSha p v⟩)
    (GlobalState.WF.add_blocks_storeSha h)

/-- Eight words fit in a 64-byte block from its start. -/
theorem _root_.LeanMLIR.RIR.MemoryState.Words8Fit.of_fits {m : MemoryState} {p : Pointer}
    (h : Fits m p 512) (hoff : p.offset = 0) : m.Words8Fit p := by
  have hov (k : Nat) (hk : k ≤ 64) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp [BitVec.uaddOverflow, hoff]
    omega
  exact
    ⟨by simp [hoff], h.mono (by decide), Fits.add_of_le (hov 8 (by decide)) (by decide) h,
      Fits.add_of_le (hov 16 (by decide)) (by decide) h,
      Fits.add_of_le (hov 24 (by decide)) (by decide) h,
      Fits.add_of_le (hov 32 (by decide)) (by decide) h,
      Fits.add_of_le (hov 40 (by decide)) (by decide) h,
      Fits.add_of_le (hov 48 (by decide)) (by decide) h,
      Fits.add_of_le (hov 56 (by decide)) (by decide) h⟩

/-! ### The memory after the SHA-512 calls -/

theorem _root_.LeanMLIR.RIR.Fits.initStores_iff {m : MemoryState} :
    Fits (fd_sha512_init.stores m p) q w ↔ Fits m q w := by
  simp [fd_sha512_init.stores, Fits.storeAt_iff]

theorem _root_.LeanMLIR.RIR.Fits.hashMem_iff {m : MemoryState} :
    Fits (fd_ed25519_verify.hashMem m sha k X v) q w ↔ Fits m q w := by
  simp [fd_ed25519_verify.hashMem, Fits.storeWords8_iff, Fits.storeSha_iff, Fits.initStores_iff]

theorem _root_.LeanMLIR.RIR.Fits.hashMem {m : MemoryState} (h : Fits m q w) :
    Fits (fd_ed25519_verify.hashMem m sha k X v) q w :=
  Fits.hashMem_iff.2 h

theorem _root_.LeanMLIR.RIR.MemoryState.ShaFit.hashMem {m : MemoryState} (h : m.ShaFit q) :
    (fd_ed25519_verify.hashMem m sha k X v).ShaFit q := by
  simpa only [MemoryState.ShaFit, Fits.hashMem_iff] using h

theorem _root_.LeanMLIR.RIR.MemoryState.Words8Fit.hashMem {m : MemoryState} (h : m.Words8Fit q) :
    (fd_ed25519_verify.hashMem m sha k X v).Words8Fit q := by
  simpa only [MemoryState.Words8Fit, Fits.hashMem_iff] using h

theorem _root_.LeanMLIR.RIR.GlobalState.WF.hashMem_mk {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + n⟩, fd_ed25519_verify.hashMem s.mem sha k X v⟩ :
        GlobalState).WF := by
  have h1 : (⟨⟨s.alloc.nextFreeBlock + n⟩, s.mem⟩ : GlobalState).WF := h.add_blocks
  simp only [fd_ed25519_verify.hashMem, fd_sha512_init.stores]
  exact
    GlobalState.WF.storeWords8
      (GlobalState.WF.storeSha
        h1.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt)

/-- A read outside the hash object and the digest. -/
theorem _root_.LeanMLIR.RIR.MemoryState.readAt_hashMem_of_id_ne {m : MemoryState}
    (hsha : q.id ≠ sha.id) (hk : q.id ≠ k.id) :
    (fd_ed25519_verify.hashMem m sha k X v).readAt q w = m.readAt q w := by
  have h' (o : BitVec 64) : (sha.add o).id ≠ q.id := by simpa [Pointer.add_id] using hsha.symm
  simp only [fd_ed25519_verify.hashMem, fd_sha512_init.stores,
    MemoryState.readAt_storeWords8_of_id_ne hk, MemoryState.readAt_storeSha_of_id_ne hsha,
    Tactic.readThroughStore]

/-- A store at the start of a known read: the bits spliced in. -/
theorem _root_.LeanMLIR.RIR.MemoryState.readAt_storeAt_base {m : MemoryState} {p : Pointer}
    (hfits : Fits m p v) (hv : ¬p.offset.uaddOverflow 0#64) (hw : w ≤ v) (x : BitVec w) :
    (m.storeAt p x).readAt p v = Memory.spliceBits (m.readAt p v) 0 x := by
  have := MemoryState.readAt_add_storeAt (off := 0#64) hfits hv (by simpa using hw) x
  simpa [Pointer.add] using this

/-- The digest's 64 bytes read back from the eight words stored at `p`. -/
theorem _root_.LeanMLIR.RIR.MemoryState.readAt_storeWords8_self {m : MemoryState} {p : Pointer}
    (h : Fits m p 512) (hov : ¬p.offset.uaddOverflow 64#64) :
    (m.storeWords8 p v).readAt p 512 = Words8.bits v := by
  have hov' (o : Nat) (ho : o ≤ 64) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 o) :=
    BitVec.not_uaddOverflow_of_le hov
      (by
        simp; omega)
  unfold MemoryState.storeWords8
  rw [MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 56 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 48 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 40 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 32 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 24 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 16 (by omega))
      (by decide),
    MemoryState.readAt_add_storeAt (by simpa [Fits.storeAt_iff] using h) (hov' 8 (by omega))
      (by decide),
    MemoryState.readAt_storeAt_base h (hov' 0 (by omega)) (by decide)]
  generalize m.readAt p 512 = B
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, Words8.bits, BitVec.getLsbD_append, BitVec.toNat_ofNat,
    Nat.reduceMod, Nat.reduceMul, Nat.reducePow]
  grind

/-- The digest at `k` read back. -/
theorem _root_.LeanMLIR.RIR.MemoryState.readAt_hashMem_k {m : MemoryState} (h : Fits m k 512)
    (hov : ¬k.offset.uaddOverflow 64#64) :
    (fd_ed25519_verify.hashMem m sha k X v).readAt k 512 = Words8.bits v :=
  MemoryState.readAt_storeWords8_self (by simpa [Fits.storeSha_iff, Fits.initStores_iff] using h)
    hov

theorem _root_.LeanMLIR.RIR.MemoryState.eraseFrom_initStores {m : MemoryState} :
    (fd_sha512_init.stores m p).eraseFrom n = fd_sha512_init.stores (m.eraseFrom n) p := by
  simp [fd_sha512_init.stores, MemoryState.eraseFrom_storeAt]

/-- Eight words stored in the frame are gone once it is erased. -/
theorem _root_.LeanMLIR.RIR.MemoryState.eraseFrom_storeWords8_of_le {m : MemoryState}
    (h : n ≤ p.id.id) : (m.storeWords8 p v).eraseFrom n = m.eraseFrom n := by
  have h' (o : BitVec 64) : n ≤ (p.add o).id.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeWords8, MemoryState.eraseFrom_storeAt_of_le h,
    MemoryState.eraseFrom_storeAt_of_le (h' _)]

/-- The digest in the frame, dropped before the erase moves past it. -/
theorem _root_.LeanMLIR.RIR.MemoryState.eraseFrom_hashMem_of_le {m : MemoryState}
    (h : n ≤ k.id.id) :
    (fd_ed25519_verify.hashMem m sha k X v).eraseFrom n =
      (fd_sha512_init.stores (m.eraseFrom n) sha).storeSha sha X := by
  rw [fd_ed25519_verify.hashMem, MemoryState.eraseFrom_storeWords8_of_le h,
    MemoryState.eraseFrom_storeSha, MemoryState.eraseFrom_initStores]

end

end LeanMLIR.RIR.Firedancer

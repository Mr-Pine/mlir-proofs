module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_ed25519_affine_is_small_order
public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base
public import Firedancer.Ref.fd_ed25519_point_eq_z1
public import Firedancer.Ref.fd_ed25519_point_frombytes_2x
public import Firedancer.Ref.fd_ed25519_point_neg
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Ref.Mlir.fd_ed25519_verify

namespace LeanMLIR.RIR.Firedancer.Ref

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

/-- `fd_ed25519_verify` on the signature halves `r`, `S`, the public key and the message, with
`buf0` the hash object's buffer and `tbl` the base point's table: the checks in the C's order,
`-1`/`-2`/`-3` for a bad signature, key or message, `0` if `[S]B = R + [k]A'` holds as
`fd_ed25519_point_eq_z1` decides it. -/
def fd_ed25519_verify.spec (tbl : Nat → PointLimbs) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S publicKey : BitVec 256) (buf0 : BitVec 1024) :
    fd_ed25519_verify.Result :=
  -- the four locals' blocks, and `frombytes_2x`'s
  let frame := 4
  let fb (A? : Option PointLimbs) (R? : Option PointLimbs) : Nat :=
    if A?.isSome then 79 + if R?.isSome then 79 else 57 else 57
  if !fd_curve25519_scalar_validate.spec S then ⟨-1#32, none, frame⟩
  else
    let A? := fd_ed25519_point_frombytes.spec publicKey
    let R? := fd_ed25519_point_frombytes.spec r
    let res := fd_ed25519_point_frombytes_2x.spec publicKey r
    match A?, R? with
    | some Aprime, some R =>
      let blocks := frame + fb A? R?
      if fd_ed25519_affine_is_small_order.spec Aprime ≠ 0#32 then ⟨-2#32, none, blocks + 8⟩
      else
        if fd_ed25519_affine_is_small_order.spec R ≠ 0#32 then ⟨-1#32, none, blocks + 16⟩
        else
          let (sha4, kw) := fd_ed25519_verify.hash buf0 r publicKey msgSz msg
          let k := fd_curve25519_scalar_reduce.spec (Words8.bits kw)
          let Aneg := fd_ed25519_point_neg.spec Aprime
          let Rcmp := fd_ed25519_double_scalar_mul_base.spec tbl k Aneg S
          ⟨if fd_ed25519_point_eq_z1.spec Rcmp R = 0#32 then -3#32 else 0#32, some sha4,
            blocks + 16 + fd_ed25519_verify.hashBlocks buf0 r publicKey msgSz msg +
              fd_ed25519_double_scalar_mul_base.blocks k S +
              4⟩
    | _, _ => ⟨if res = -1#32 then -2#32 else -1#32, none, frame + fb A? R?⟩

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

end

/-! ## Proof -/

section Proof

/-- A comparison's flag as the comparison. -/
theorem ite_ofBool_beq {x y : BitVec w} {a b : α} :
    (if BitVec.ofBool (x == y) = 1#1 then a else b) = if x = y then a else b := by
  by_cases h : x = y
  · simp [h]
  · have hb : (x == y) = false := beq_eq_false_iff_ne.mpr h
    simp [h, hb]

/-- A pointer at a positive offset into a range that does not wrap is not null. -/
theorem Pointer.add_ne_null {p : Pointer} {a b : BitVec 64} (h : ¬p.offset.uaddOverflow b)
    (ha : 0 < a.toNat) (hab : a.toNat ≤ b.toNat) : p.add a ≠ Pointer.null := by
  intro he
  have hoff := congrArg (fun q : Pointer => q.offset.toNat) he
  simp only [Pointer.add, Pointer.null,
    BitVec.toNat_add_of_not_uaddOverflow (BitVec.not_uaddOverflow_of_le h hab)] at hoff
  simp at hoff
  omega

/-- A hash object stored twice: the second. -/
theorem MemoryState.storeSha_storeSha_self {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64) :
    (m.storeSha p a).storeSha p b = m.storeSha p b := by
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
theorem GlobalState.WF.add_blocks_storeSha {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeSha p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeSha (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

/-- `add_blocks_storeSha`, then the digest's words. -/
theorem GlobalState.WF.add_blocks_storeSha_storeWords8 {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeSha p v).storeWords8 q w⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeSha p v⟩)
    (GlobalState.WF.add_blocks_storeSha h)

/-- Eight words fit in a 64-byte block from its start. -/
theorem MemoryState.Words8Fit.of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 512)
    (hoff : p.offset = 0) : m.Words8Fit p := by
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

attribute [local mlir_read] MemoryState.readSha_storeSha_self

attribute [local mlir_transport] GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8

/-! ### The memory after the SHA-512 calls -/

theorem Fits.initStores_iff {m : MemoryState} :
    Fits (fd_sha512_init.stores m p) q w ↔ Fits m q w := by
  simp [fd_sha512_init.stores, Fits.storeAt_iff]

theorem Fits.hashMem_iff {m : MemoryState} :
    Fits (fd_ed25519_verify.hashMem m sha k X v) q w ↔ Fits m q w := by
  simp [fd_ed25519_verify.hashMem, Fits.storeWords8_iff, Fits.storeSha_iff, Fits.initStores_iff]

theorem Fits.hashMem {m : MemoryState} (h : Fits m q w) :
    Fits (fd_ed25519_verify.hashMem m sha k X v) q w :=
  Fits.hashMem_iff.2 h

theorem MemoryState.PointFit.hashMem {m : MemoryState} (h : m.PointFit q) :
    (fd_ed25519_verify.hashMem m sha k X v).PointFit q := by
  simpa only [MemoryState.PointFit, MemoryState.LimbsFit, Fits.hashMem_iff] using h

theorem MemoryState.ShaFit.hashMem {m : MemoryState} (h : m.ShaFit q) :
    (fd_ed25519_verify.hashMem m sha k X v).ShaFit q := by
  simpa only [MemoryState.ShaFit, Fits.hashMem_iff] using h

theorem MemoryState.Words8Fit.hashMem {m : MemoryState} (h : m.Words8Fit q) :
    (fd_ed25519_verify.hashMem m sha k X v).Words8Fit q := by
  simpa only [MemoryState.Words8Fit, Fits.hashMem_iff] using h

theorem GlobalState.WF.hashMem_mk {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + n⟩, fd_ed25519_verify.hashMem s.mem sha k X v⟩ :
        GlobalState).WF := by
  have h1 : (⟨⟨s.alloc.nextFreeBlock + n⟩, s.mem⟩ : GlobalState).WF := h.add_blocks
  simp only [fd_ed25519_verify.hashMem, fd_sha512_init.stores]
  exact
    GlobalState.WF.storeWords8
      (GlobalState.WF.storeSha
        h1.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt)

/-- A read outside the hash object and the digest. -/
theorem MemoryState.readAt_hashMem_of_id_ne {m : MemoryState} (hsha : q.id ≠ sha.id)
    (hk : q.id ≠ k.id) : (fd_ed25519_verify.hashMem m sha k X v).readAt q w = m.readAt q w := by
  have h' (o : BitVec 64) : (sha.add o).id ≠ q.id := by simpa [Pointer.add_id] using hsha.symm
  simp only [fd_ed25519_verify.hashMem, fd_sha512_init.stores,
    MemoryState.readAt_storeWords8_of_id_ne hk, MemoryState.readAt_storeSha_of_id_ne hsha,
    Tactic.readThroughStore]

/-- `readAt_hashMem_of_id_ne` for limbs. -/
theorem MemoryState.readLimbs_hashMem_of_id_ne {m : MemoryState} (hsha : q.id ≠ sha.id)
    (hk : q.id ≠ k.id) : (fd_ed25519_verify.hashMem m sha k X v).readLimbs q = m.readLimbs q := by
  have h1 (o : BitVec 64) : (q.add o).id ≠ sha.id := by simpa [Pointer.add_id] using hsha
  have h2 (o : BitVec 64) : (q.add o).id ≠ k.id := by simpa [Pointer.add_id] using hk
  funext i
  fin_cases i
  · exact MemoryState.readAt_hashMem_of_id_ne hsha hk
  all_goals exact MemoryState.readAt_hashMem_of_id_ne (h1 _) (h2 _)

/-- `readAt_hashMem_of_id_ne` for points. -/
theorem MemoryState.readPoint_hashMem_of_id_ne {m : MemoryState} (hsha : q.id ≠ sha.id)
    (hk : q.id ≠ k.id) : (fd_ed25519_verify.hashMem m sha k X v).readPoint q = m.readPoint q := by
  have h1 (o : BitVec 64) : (q.add o).id ≠ sha.id := by simpa [Pointer.add_id] using hsha
  have h2 (o : BitVec 64) : (q.add o).id ≠ k.id := by simpa [Pointer.add_id] using hk
  simp only [MemoryState.readPoint, MemoryState.readLimbs_hashMem_of_id_ne hsha hk,
    MemoryState.readLimbs_hashMem_of_id_ne (h1 _) (h2 _)]

/-- A store at the start of a known read: the bits spliced in. -/
theorem MemoryState.readAt_storeAt_base {m : MemoryState} {p : Pointer} (hfits : Fits m p v)
    (hv : ¬p.offset.uaddOverflow 0#64) (hw : w ≤ v) (x : BitVec w) :
    (m.storeAt p x).readAt p v = Memory.spliceBits (m.readAt p v) 0 x := by
  have := MemoryState.readAt_add_storeAt (off := 0#64) hfits hv (by simpa using hw) x
  simpa [Pointer.add] using this

/-- The digest's 64 bytes read back from the eight words stored at `p`. -/
theorem MemoryState.readAt_storeWords8_self {m : MemoryState} {p : Pointer} (h : Fits m p 512)
    (hov : ¬p.offset.uaddOverflow 64#64) : (m.storeWords8 p v).readAt p 512 = Words8.bits v := by
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
theorem MemoryState.readAt_hashMem_k {m : MemoryState} (h : Fits m k 512)
    (hov : ¬k.offset.uaddOverflow 64#64) :
    (fd_ed25519_verify.hashMem m sha k X v).readAt k 512 = Words8.bits v :=
  MemoryState.readAt_storeWords8_self (by simpa [Fits.storeSha_iff, Fits.initStores_iff] using h)
    hov

theorem MemoryState.eraseFrom_initStores {m : MemoryState} :
    (fd_sha512_init.stores m p).eraseFrom n = fd_sha512_init.stores (m.eraseFrom n) p := by
  simp [fd_sha512_init.stores, MemoryState.eraseFrom_storeAt]

/-- Eight words stored in the frame are gone once it is erased. -/
theorem MemoryState.eraseFrom_storeWords8_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeWords8 p v).eraseFrom n = m.eraseFrom n := by
  have h' (o : BitVec 64) : n ≤ (p.add o).id.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeWords8, MemoryState.eraseFrom_storeAt_of_le h,
    MemoryState.eraseFrom_storeAt_of_le (h' _)]

/-- The digest in the frame, dropped before the erase moves past it. -/
theorem MemoryState.eraseFrom_hashMem_of_le {m : MemoryState} (h : n ≤ k.id.id) :
    (fd_ed25519_verify.hashMem m sha k X v).eraseFrom n =
      (fd_sha512_init.stores (m.eraseFrom n) sha).storeSha sha X := by
  rw [fd_ed25519_verify.hashMem, MemoryState.eraseFrom_storeWords8_of_le h,
    MemoryState.eraseFrom_storeSha, MemoryState.eraseFrom_initStores]

attribute [local mlir_transport] Fits.hashMem MemoryState.PointFit.hashMem
  MemoryState.ShaFit.hashMem MemoryState.Words8Fit.hashMem GlobalState.WF.hashMem_mk

attribute [local mlir_read] MemoryState.readAt_hashMem_of_id_ne
  MemoryState.readLimbs_hashMem_of_id_ne MemoryState.readPoint_hashMem_of_id_ne
  MemoryState.readAt_hashMem_k

attribute [local mlir_erase high] MemoryState.eraseFrom_hashMem_of_le

/-- `fd_sha512_fini( fd_sha512_append( fd_sha512_append( fd_sha512_append( fd_sha512_init( sha ),
r, 32UL ), public_key, 32UL ), msg, msg_sz ), k )`: the hash object and the digest's words at `k`
as `fd_ed25519_verify.hash` gives them. -/
theorem fd_ed25519_verify.hash_run {E : ⟪fd_ed25519_verify.Γ⟫} {S : GlobalState}
    {g : ⟪fd_ed25519_verify.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {msg sig pk sha k : Pointer} {msgSz : BitVec 64}
    (hArgs :
      E.args =
        (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk)
            (.value sha)).get)
    (hR : E ⊨ [%5 := 32#64, %9 := k]) (hwf : S.WF) (hsha : S.mem.ShaFit sha)
    (hsig : Fits S.mem sig (8 * 32)) (hsig_off : ¬sig.offset.uaddOverflow 32#64)
    (hpk : Fits S.mem pk (8 * 32)) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hk : S.mem.Words8Fit k) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hmsg_sha : msg.id ≠ sha.id) (hk_sha : k.id ≠ sha.id)
    (hK :
      (fd_ed25519_verify.bb5.runBodyFrom
            E[%22 := .value sha, %23 := .value sha, %24 := .value sha, %25 := .value sha, %26 :=
              .value k]
            6
            {
              alloc :=
                ⟨S.alloc.nextFreeBlock +
                    fd_ed25519_verify.hashBlocks (S.mem.readAt sha 1024) (S.mem.readAt sig 256)
                      (S.mem.readAt pk 256) msgSz (S.mem.readAt msg (8 * msgSz.toNat))⟩,
              mem :=
                let h :=
                  fd_ed25519_verify.hash (S.mem.readAt sha 1024) (S.mem.readAt sig 256)
                    (S.mem.readAt pk 256) msgSz (S.mem.readAt msg (8 * msgSz.toNat))
                fd_ed25519_verify.hashMem S.mem sha k h.1 h.2 } >>=
          g) =
        K) :
    (fd_ed25519_verify.bb5.runBodyFrom E 1 S >>= g) = K := by
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  step_call using fd_sha512_init.call_eq
  rename_i S₀
  -- the hash object `init` leaves
  have hsh0 : S.mem.readSha sha = ⟨S₀.mem.readAt sha 1024, sha512IV, 0#64, 0#64, 0#64⟩ := by
    have hf : S₀.mem.ShaFit sha :=
      ⟨by
        rw [hS] at hsha_fits; simpa only [Fits.storeAt_iff] using hsha_fits, hsha_off⟩
    rw [hS]
    simpa using fd_sha512_init.readSha hf
  have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
  clear hsha_fits hread_sha_200 hread_sha_184 hread_sha_176 hread_sha_168 hread_sha_160
    hread_sha_152 hread_sha_144 hread_sha_136 hread_sha_128
  -- each `append` keeps less than a block buffered: `hu` for the call, not as a fact about `S`
  step_call using
    (fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hsh0).mpr (by simp))) consuming
    hread_sig
  step_call using
    (fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp)))) consuming
    hread_pk
  step_call using
    (fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _
          (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))) consuming
    hread_msg
  step_call using
    (fd_sha512_fini.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _
          (fd_sha512_append.spec_bufUsed_lt _ _ _
            (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))))
  subst hE hS
  rw [MemoryState.storeSha_storeSha_self hsha_off, MemoryState.storeSha_storeSha_self hsha_off,
    MemoryState.storeSha_storeSha_self hsha_off]
  convert hK using 5 <;>
    simp only [fd_ed25519_verify.hash, fd_ed25519_verify.hashBlocks, fd_ed25519_verify.shaStates,
      fd_ed25519_verify.hashMem, fd_sha512_init.stores]
  omega

/-- `fd_ed25519_verify` returns `spec`'s code and leaves `spec`'s hash object; its frame is freed.
The signature, key and message are only read, the hash object only written by the SHA-512 calls. -/
public theorem fd_ed25519_verify.call_eq (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer)
    (s : GlobalState) (hwf : s.WF) (hmsg : Fits s.mem msg (8 * msgSz.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgSz) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hmsg_sha : msg.id ≠ sha.id)
    (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id) :
    fd_ed25519_verify.call
        (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha))
        s =
      let res :=
        fd_ed25519_verify.spec fd_ed25519_double_scalar_mul_base.baseTbl msgSz
          (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem s.mem sha }) := by
  dsimp only
  generalize hres :
    fd_ed25519_verify.spec fd_ed25519_double_scalar_mul_base.baseTbl msgSz
      (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
      (s.mem.readAt pk 256) (s.mem.readAt sha 1024) =
    res
  func_init
  rw [hS] at hres
  -- `S`'s bytes past `sig + 32` do not wrap
  have hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64 :=
    Pointer.not_uaddOverflow_add_sub (a := 32#64) (b := 64#64) hsig_off (by decide)
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  -- the inputs as read facts, which the steps carry past the frame's `alloca`s and stores
  have hread_S : S.mem.readAt (sig.add 32#64) 256 = S₀.mem.readAt (sig.add 32#64) 256 := by rw [hS]
  have hread_r : S.mem.readAt sig 256 = S₀.mem.readAt sig 256 := by rw [hS]
  have hread_pk : S.mem.readAt pk 256 = S₀.mem.readAt pk 256 := by rw [hS]
  have hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = S₀.mem.readAt msg (8 * msgSz.toNat) := by
    rw [hS]
  have hread_buf : S.mem.readAt sha 1024 = S₀.mem.readAt sha 1024 := by rw [hS]
  block_init
  iterate 7 step_pure
  -- fd_ed25519_point_t Aprime[1], R[1]; uchar k[64]; fd_ed25519_point_t Rcmp[1];
  step_alloca with A
  step_alloca with R
  step_alloca with k
  step_alloca with Rc
  -- uchar const * S = sig + 32;
  step_pure
  -- if( !fd_curve25519_scalar_validate( S ) ) return FD_ED25519_ERR_SIG;
  step_call using fd_curve25519_scalar_validate.call_eq
  step_pure
  finish_block
  case isTrue =>
    -- `S` out of range: FD_ED25519_ERR_SIG
    have hv : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = false := by
      have hne := Pointer.add_ne_null (a := 32#64) hsig_off (by decide) (by decide)
      cases hc : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · rfl
      · simp [hc, hne] at hbr
    block_init
    finish_block
    subst hS hres
    erase_frame
    simp [fd_ed25519_verify.spec, hv, fd_ed25519_verify.Result.mem]
  case
    isFalse =>
    have hv : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true := by
      cases hc : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · simp [hc] at hbr
      · rfl
    clear hbr
    have hsig32 : ¬sig.offset.uaddOverflow 32#64 :=
      BitVec.not_uaddOverflow_of_le hsig_off (by decide)
    have hA_pt := MemoryState.PointFit.of_fits hA_fits hA_off
    have hR_pt := MemoryState.PointFit.of_fits hR_fits hR_off
    clear hA_fits hR_fits
    block_init
    iterate 2 step_pure
    -- reads of the decoded points go through the stores over the state after the `alloca`s
    have hA₀ := hS ▸ hA_pt
    have hR₀ := hS ▸ hR_pt
    have hk₀ := hS ▸ hk_fits
    -- int res = fd_ed25519_point_frombytes_2x( Aprime, public_key, R, r );
    step_call using fd_ed25519_point_frombytes_2x.call_eq
    step_pure
    finish_block
    case isFalse =>
      -- a decoding failed: FD_ED25519_ERR_PUBKEY for the key, else FD_ED25519_ERR_SIG
      block_init
      iterate 2 step_pure
      finish_block
      block_init
      iterate 2 step_pure
      finish_block
      block_init
      finish_block
      subst hS hres
      rcases hA? : fd_ed25519_point_frombytes.spec (S₀.mem.readAt pk 256) with _ | Ap <;>
        rcases hR? : fd_ed25519_point_frombytes.spec (S₀.mem.readAt sig 256) with _ | Rp <;>
        simp only [Option.isSome_none, Option.isSome_some, Bool.false_eq_true, ite_false, ite_true,
          MemoryState.storePointOpt_none, MemoryState.storePointOpt_some] at hbr ⊢ <;>
        erase_frame <;>
        simp [fd_ed25519_verify.spec, fd_ed25519_point_frombytes_2x.spec, hv, hA?, hR?,
          fd_ed25519_verify.Result.mem] at hbr ⊢
    case isTrue =>
      -- both decode
      rcases hA? : fd_ed25519_point_frombytes.spec (S₀.mem.readAt pk 256) with _ | Ap
      · simp [fd_ed25519_point_frombytes_2x.spec, hA?] at hbr
      rcases hR? : fd_ed25519_point_frombytes.spec (S₀.mem.readAt sig 256) with _ | Rp
      · simp [fd_ed25519_point_frombytes_2x.spec, hA?, hR?] at hbr
      simp only [hA?, hR?, Option.isSome_some, ite_true, MemoryState.storePointOpt_some] at hS
      clear hbr
      -- if( fd_ed25519_affine_is_small_order( Aprime ) ) return FD_ED25519_ERR_PUBKEY;
      block_init
      step_call using fd_ed25519_affine_is_small_order.call_eq
      step_pure
      finish_block
      case isFalse =>
        block_init
        iterate 2 step_pure
        finish_block
        block_init
        finish_block
        subst hS hres
        erase_frame
        simp [fd_ed25519_verify.spec, hv, hA?, hR?, fd_ed25519_verify.Result.mem, hbr]
      case isTrue =>
        have hsoA := hbr
        clear hbr
        -- if( fd_ed25519_affine_is_small_order( R ) ) return FD_ED25519_ERR_SIG;
        block_init
        step_call using fd_ed25519_affine_is_small_order.call_eq
        step_pure
        finish_block
        case isFalse =>
          block_init
          iterate 2 step_pure
          finish_block
          block_init
          finish_block
          subst hS hres
          erase_frame
          simp [fd_ed25519_verify.spec, hv, hA?, hR?, fd_ed25519_verify.Result.mem, hsoA, hbr]
        case isTrue =>
          have hsoR := hbr
          clear hbr
          block_init
          step_pure
          -- fd_sha512_fini( fd_sha512_append( fd_sha512_append( fd_sha512_append( fd_sha512_init( sha ),
          --   r, 32UL ), public_key, 32UL ), msg, msg_sz ), k );
          have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
          have hk_w := MemoryState.Words8Fit.of_fits hk_fits hk_off
          step_pattern using fd_ed25519_verify.hash_run
          obtain ⟨⟨sha4, kw⟩, hH⟩ :
            ∃ H,
              fd_ed25519_verify.hash (S₀.mem.readAt sha 1024) (S₀.mem.readAt sig 256)
                  (S₀.mem.readAt pk 256) msgSz (S₀.mem.readAt msg (8 * msgSz.toNat)) =
                H :=
            ⟨_, rfl⟩
          rw [hH] at hS hread_k
          clear hsha hk_w
          -- fd_curve25519_scalar_reduce( k, k );
          have hk32 : ¬k.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hk_off]
          have hk64 : ¬k.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow, hk_off]
          step_call using fd_curve25519_scalar_reduce.call_eq consuming hread_k
          -- fd_ed25519_point_neg( Aprime, Aprime );
          step_pure
          step_call using (fd_ed25519_point_neg.call_eq (hsep := .inl rfl))
          -- fd_ed25519_double_scalar_mul_base( Rcmp, k, Aprime, S );
          have hRc_pt := MemoryState.PointFit.of_fits hRc_fits hRc_off
          step_call using fd_ed25519_double_scalar_mul_base.call_eq
          -- if( fd_ed25519_point_eq_z1( Rcmp, R ) ) return FD_ED25519_SUCCESS; return FD_ED25519_ERR_MSG;
          step_call using fd_ed25519_point_eq_z1.call_eq
          iterate 4 step_pure
          finish_block
          block_init
          iterate 2 step_pure
          finish_block
          block_init
          finish_block
          subst hS hres
          erase_frame
          -- `k`'s 32 bytes as `reduce` stored them
          rw [MemoryState.readAt_storeAt_self
              (Fits.hashMem (Fits.storePoint (Fits.storePoint (hk₀.mono (by decide)))))]
          simp only [fd_ed25519_verify.spec, hv, hA?, hR?, hsoA, hsoR, hH,
            fd_ed25519_verify.Result.mem, ite_ofBool_beq]
          simp
          omega

end Proof

end LeanMLIR.RIR.Firedancer.Ref

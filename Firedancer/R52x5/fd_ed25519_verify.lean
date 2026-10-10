module

public import MLIR.Run.Tactic
public import Firedancer.Common.Verify
public import Firedancer.Common.Tactics
public import Firedancer.R52x5.Globals
public import Firedancer.R52x5.fd_curve25519_scalar_reduce
public import Firedancer.R52x5.fd_curve25519_scalar_validate
public import Firedancer.R52x5.fd_sha512_init
public import Firedancer.R52x5.fd_sha512_append
public import Firedancer.R52x5.fd_sha512_fini
public import Firedancer.R52x5.fd_ed25519_point_frombytes_2x
public import Firedancer.R52x5.fd_ed25519_affine_is_small_order
public import Firedancer.R52x5.fd_ed25519_point_neg
public import Firedancer.R52x5.fd_ed25519_double_scalar_mul_base
public import Firedancer.R52x5.fd_ed25519_point_affine_eq
public import Firedancer.R52x5.Mlir.fd_ed25519_verify

namespace MLIR.Firedancer.R52x5

/-! ## Specification

The hashing and the scalar code are the ref's, so their specs are the ref's. -/

@[expose] public section

/-- `fd_ed25519_verify` on the signature halves `r`, `S`, the public key and the message, with
`buf0` the hash object's buffer and `tbl` the base point's table: the checks in the C's order,
`-1`/`-2`/`-3` for a bad signature, key or message, `0` if `[S]B = R + [k]A'` holds as
`fd_ed25519_point_affine_eq` decides it. `frombytes_2x` gives `A'` on success. -/
noncomputable def fd_ed25519_verify.spec (tbl : Nat → Quad5) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S publicKey : BitVec 256) (buf0 : BitVec 1024) :
    fd_ed25519_verify.Result :=
  if !Ref.fd_curve25519_scalar_validate.spec S then ⟨-1#32, none, 4⟩
  else
    let (res, Aprime, R) := fd_ed25519_point_frombytes_2x.spec publicKey r
    -- the four locals' blocks, and `frombytes_2x`'s
    let blocks := 4 + fd_r52x5_ge_decode2.blocks res
    if res ≠ 0#32 then ⟨if res = -1#32 then -2#32 else -1#32, none, blocks⟩
    else
      let Aprime := Aprime.getD quadZero
      if fd_ed25519_affine_is_small_order.spec Aprime ≠ 0#32 then ⟨-2#32, none, blocks + 16⟩
      else
        if fd_ed25519_affine_is_small_order.spec R ≠ 0#32 then ⟨-1#32, none, blocks + 32⟩
        else
          let (sha4, kw) := fd_ed25519_verify.hash buf0 r publicKey msgSz msg
          let k := Ref.fd_curve25519_scalar_reduce.spec (Words8.bits kw)
          let Aneg := fd_ed25519_point_neg.spec Aprime
          let Rcmp := fd_ed25519_double_scalar_mul_base.spec tbl k Aneg S
          ⟨if fd_ed25519_point_affine_eq.spec Rcmp R = 0#32 then -3#32 else 0#32, some sha4,
            blocks + 32 + fd_ed25519_verify.hashBlocks buf0 r publicKey msgSz msg +
              fd_ed25519_double_scalar_mul_base.blocks k S +
              22⟩

end

/-! ## Proof -/

section Proof

/-- `frombytes_2x` gives `Aprime` when it succeeds. -/
theorem fd_ed25519_point_frombytes_2x.spec_some {e1 e2 : BitVec 256}
    (h : fd_ed25519_point_frombytes_2x.spec e1 e2 = (0#32, Ap, Rp)) : ∃ P, Ap = some P := by
  simp only [fd_ed25519_point_frombytes_2x.spec, fd_r52x5_ge_decode2.spec] at h
  generalize fd_r52x5_ge_decode2.decs e1 e2 = D at h
  split_ifs at h <;> simp_all
  exact ⟨_, h.1.symm⟩

/-- `frombytes_2x`'s store of `Pa`: only when it decoded. -/
def _root_.MLIR.MemoryState.storeQuad5? (m : MemoryState) (p : Pointer) : Option Quad5 → MemoryState
  | none => m
  | some P => m.storeQuad5 p P

theorem MemoryState.storeQuad5?_some {m : MemoryState} :
    m.storeQuad5? p (some P) = m.storeQuad5 p P :=
  rfl

theorem MemoryState.storeQuad5?_none {m : MemoryState} : m.storeQuad5? p none = m :=
  rfl

/-- `storeQuad5?` keeps known ranges known. -/
theorem Fits.storeQuad5? {m : MemoryState} (h : Fits m p w) : Fits (m.storeQuad5? q o) p w := by
  cases o
  · exact h
  · exact h.storeQuad5

theorem InBounds.storeQuad5? {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeQuad5? q o) p w := by
  cases o
  · exact h
  · exact h.storeQuad5

theorem MemoryState.Quad5Fit.storeQuad5? {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeQuad5? p o).Quad5Fit q := by
  cases o
  · exact h
  · exact h.storeQuad5

theorem MemoryState.Quad5Room.storeQuad5? {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeQuad5? p o).Quad5Room q := by
  cases o
  · exact h
  · exact h.storeQuad5

theorem GlobalState.WF.storeQuad5?_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeQuad5? p o⟩ : GlobalState).WF := by
  cases o
  · exact h
  · exact h.storeQuad5_mk

theorem MemoryState.readAt_storeQuad5?_of_id_ne {m : MemoryState} (h : p.id ≠ q.id) :
    (m.storeQuad5? p o).readAt q w = m.readAt q w := by
  cases o
  · rfl
  · exact MemoryState.readAt_storeQuad5_of_id_ne h

theorem MemoryState.eraseFrom_storeQuad5?_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeQuad5? p o).eraseFrom n = m.eraseFrom n := by
  cases o
  · rfl
  · exact MemoryState.eraseFrom_storeQuad5_of_le h

attribute [local simp] MemoryState.storeQuad5?_some MemoryState.storeQuad5?_none

attribute [local mlir_mem] Fits.storeQuad5? InBounds.storeQuad5? MemoryState.Quad5Fit.storeQuad5?
  MemoryState.Quad5Room.storeQuad5?

attribute [local mlir_transport] Fits.storeQuad5? InBounds.storeQuad5?
  MemoryState.Quad5Fit.storeQuad5? MemoryState.Quad5Room.storeQuad5? GlobalState.WF.storeQuad5?_mk

attribute [local mlir_read] MemoryState.readAt_storeQuad5?_of_id_ne

attribute [local mlir_erase high] MemoryState.eraseFrom_storeQuad5?_of_le

/-- `fd_ed25519_point_frombytes_2x.call_eq` with its store of `Pa` as `storeQuad5?`. -/
theorem fd_ed25519_point_frombytes_2x.call_eq' (r1 buf1 r2 buf2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.Quad5Room r1) (hr2 : s.mem.Quad5Room r2) (hb1 : Fits s.mem buf1 256)
    (hb2 : Fits s.mem buf2 256) (hb1_off : ¬buf1.offset.uaddOverflow 32#64)
    (hb2_off : ¬buf2.offset.uaddOverflow 32#64) :
    fd_ed25519_point_frombytes_2x.call
        (fd_ed25519_point_frombytes_2x.args (.value r1) (.value buf1) (.value r2) (.value buf2)) s =
      let R := fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + fd_r52x5_ge_decode2.blocks R.1⟩,
            mem := (s.mem.storeQuad5? r1 R.2.1).storeQuad5 r2 R.2.2 }) := by
  have h :=
    fd_ed25519_point_frombytes_2x.call_eq r1 buf1 r2 buf2 s hwf hr1 hr2 hb1 hb2 hb1_off hb2_off
  revert h
  generalize fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256) = R
  rcases R with ⟨_, _ | _, _⟩ <;> exact id

/-- The SHA-512 calls keep a point fitting. -/
theorem MemoryState.Quad5Fit.hashMem {m : MemoryState} (h : m.Quad5Fit q) :
    (fd_ed25519_verify.hashMem m sha k X v).Quad5Fit q :=
  ⟨h.1, h.2.1.hashMem, h.2.2.1.hashMem, h.2.2.2.1.hashMem, h.2.2.2.2.1.hashMem, h.2.2.2.2.2.hashMem⟩

/-- `readAt_hashMem_of_id_ne` for points. -/
theorem MemoryState.readQuad5_hashMem_of_id_ne {m : MemoryState} (hsha : q.id ≠ sha.id)
    (hk : q.id ≠ k.id) : (fd_ed25519_verify.hashMem m sha k X v).readQuad5 q = m.readQuad5 q := by
  have h1 (o : BitVec 64) : (q.add o).id ≠ sha.id := by simpa [Pointer.add_id] using hsha
  have h2 (o : BitVec 64) : (q.add o).id ≠ k.id := by simpa [Pointer.add_id] using hk
  simp only [MemoryState.readQuad5, MemoryState.readWv, MemoryState.readAt_hashMem_of_id_ne hsha hk,
    MemoryState.readAt_hashMem_of_id_ne (h1 _) (h2 _)]

attribute [local mlir_read] MemoryState.readSha_storeSha_self

attribute [local mlir_transport] GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8

attribute [local mlir_transport] Fits.hashMem MemoryState.Quad5Fit.hashMem
  MemoryState.ShaFit.hashMem MemoryState.Words8Fit.hashMem GlobalState.WF.hashMem_mk

attribute [local mlir_read] MemoryState.readAt_hashMem_of_id_ne
  MemoryState.readQuad5_hashMem_of_id_ne MemoryState.readAt_hashMem_k

attribute [local mlir_erase high] MemoryState.eraseFrom_hashMem_of_le

attribute [local mlir_fresh] Fits.hashMem_k

attribute [local mlir_transport] MemoryState.Words8Room.storeSha InBounds.hashMem
  MemoryState.Words8Room.hashMem

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
    (hR : E ⊨ [%299 := 32#64, %307 := k]) (hwf : S.WF) (hsha : S.mem.ShaFit sha)
    (hsig : Fits S.mem sig (8 * 32)) (hsig_off : ¬sig.offset.uaddOverflow 32#64)
    (hpk : Fits S.mem pk (8 * 32)) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hk : S.mem.Words8Room k) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hmsg_sha : msg.id ≠ sha.id) (hk_sha : k.id ≠ sha.id)
    (hK :
      (fd_ed25519_verify.bb5.runBodyFrom
            E[%320 := .value sha, %321 := .value sha, %322 := .value sha, %323 := .value sha,
              %324 := .value k]
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
  -- the hash object `init` leaves, an equation that stays about the state before it
  have hinit := Ref.fd_sha512_init.readSha hsha
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  step_call using fd_sha512_init.call_eq
  rename_i S₀
  have hsh0 : S.mem.readSha sha = ⟨S₀.mem.readAt sha 1024, Ref.sha512IV, 0#64, 0#64, 0#64⟩ := by
    rw [hS]
    simpa using hinit
  clear hinit
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
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp)))) consuming
    hread_pk
  step_call using
    (fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
          (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))) consuming
    hread_msg
  step_call using
    (fd_sha512_fini.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
          (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
            (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))))
  subst hE hS
  rw [MemoryState.storeSha_storeSha_self hsha_off, MemoryState.storeSha_storeSha_self hsha_off,
    MemoryState.storeSha_storeSha_self hsha_off]
  convert hK using 5 <;>
    simp only [fd_ed25519_verify.hash, fd_ed25519_verify.hashBlocks, fd_ed25519_verify.shaStates,
      fd_ed25519_verify.hashMem, fd_sha512_init.stores]
  omega

-- the frame's four objects: eight lifetime markers as effectful steps, each carrying the facts
set_option maxHeartbeats 300000 in
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
        fd_ed25519_verify.spec fd_ed25519_base_point_wnaf_table.point msgSz
          (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem s.mem sha }) := by
  dsimp only
  generalize hres :
    fd_ed25519_verify.spec fd_ed25519_base_point_wnaf_table.point msgSz
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
    have hv :
      Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = false := by
      have hne := Pointer.add_ne_null (a := 32#64) hsig_off (by decide) (by decide)
      cases hc : Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · rfl
      · simp [hc, hne] at hbr
    block_init
    finish_block
    subst hS hres
    erase_frame
    simp [fd_ed25519_verify.spec, hv, fd_ed25519_verify.Result.mem]
  case
    isFalse =>
    have hv :
      Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true := by
      cases hc : Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · simp [hc] at hbr
      · rfl
    clear hbr
    -- `spec`'s first test
    have hnv :
      (!Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)) ≠ true := by
      rw [hv]
      decide
    have hsig32 : ¬sig.offset.uaddOverflow 32#64 :=
      BitVec.not_uaddOverflow_of_le hsig_off (by decide)
    block_init
    iterate 2 step_pure
    have hA_pt := MemoryState.Quad5Room.of_room (hroom_A.mono (by decide)) hA_off
    have hR_pt := MemoryState.Quad5Room.of_room (hroom_R.mono (by decide)) hR_off
    clear hroom_A hroom_R hA_bounds hR_bounds
    -- reads of the decoded points go through the stores over the state after the `alloca`s
    have hk₀ := hS ▸ hk_bounds
    have hA₀ := hS ▸ hA_pt
    have hR₀ := hS ▸ hR_pt
    have hRA : R.id ≠ A.id := by simp [hA, hR, GlobalState.slot]
    -- int res = fd_ed25519_point_frombytes_2x( Aprime, public_key, R, r );
    step_call using fd_ed25519_point_frombytes_2x.call_eq'
    obtain ⟨⟨fres, Ap, Rp⟩, hfb⟩ :
      ∃ t, fd_ed25519_point_frombytes_2x.spec (S₀.mem.readAt pk 256) (S₀.mem.readAt sig 256) = t :=
      ⟨_, rfl⟩
    rw [hfb] at hS hE hread_R_readQuad5
    dsimp only at hS hread_R_readQuad5
    clear hread_R hread_R_32 hread_R_64 hread_R_96 hread_R_128
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
      rw [fd_ed25519_verify.spec, ite_eq_right hnv, hfb] at hres
      dsimp only at hres
      rw [ite_eq_left hbr] at hres
      subst hS hres
      erase_frame
      simp [fd_ed25519_verify.Result.mem, ite_ofBool_beq]
      omega
    case isTrue =>
      have hres0 := hbr
      clear hbr
      subst hres0
      obtain ⟨Aq, rfl⟩ := fd_ed25519_point_frombytes_2x.spec_some hfb
      simp only [MemoryState.storeQuad5?_some] at hS
      have hread_A : S.mem.readQuad5 A = Aq := by
        rw [hS]
        dsimp only
        rw [MemoryState.readQuad5_storeQuad5_of_id_ne hRA,
          MemoryState.readQuad5_storeQuad5_self hA₀]
      -- the decoded points are known
      have hAf : S.mem.Quad5Fit A := by
        rw [hS]
        exact (MemoryState.Quad5Fit.storeQuad5_self hA₀).storeQuad5
      have hRf : S.mem.Quad5Fit R := by
        rw [hS]
        exact MemoryState.Quad5Fit.storeQuad5_self hR₀.storeQuad5
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
        rw [fd_ed25519_verify.spec, ite_eq_right hnv, hfb] at hres
        dsimp only at hres
        rw [ite_eq_right (by simp), Option.getD_some, ite_eq_left hbr] at hres
        subst hS hres
        erase_frame
        simp [fd_ed25519_verify.Result.mem]
        omega
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
          rw [fd_ed25519_verify.spec, ite_eq_right hnv, hfb] at hres
          dsimp only at hres
          rw [ite_eq_right (by simp), Option.getD_some, ite_eq_right (not_not.mpr hsoA),
            ite_eq_left hbr] at hres
          subst hS hres
          erase_frame
          simp [fd_ed25519_verify.Result.mem]
          omega
        case isTrue =>
          have hsoR := hbr
          clear hbr
          block_init
          step_pure
          -- fd_sha512_fini( fd_sha512_append( fd_sha512_append( fd_sha512_append(
          --   fd_sha512_init( sha ), r, 32UL ), public_key, 32UL ), msg, msg_sz ), k );
          have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
          have hk_w := MemoryState.Words8Room.of_room hroom_k hk_off
          clear hroom_k hA_pt hR_pt
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
          have hRc_pt := MemoryState.Quad5Room.of_room (hroom_Rc.mono (by decide)) hRc_off
          step_call using fd_ed25519_double_scalar_mul_base.call_eq
          -- if( fd_ed25519_point_affine_eq( Rcmp, R ) ) return FD_ED25519_SUCCESS;
          -- return FD_ED25519_ERR_MSG;
          step_call using fd_ed25519_point_affine_eq.call_eq
          -- the frame's lifetimes end
          clear_facts A R Rc
          clear hfits_k hmsg hsig hpk hsha_fits
          clear hfits_k
          iterate 4 step_pure
          finish_block
          block_init
          iterate 2 step_pure
          finish_block
          block_init
          finish_block
          rw [fd_ed25519_verify.spec, ite_eq_right hnv, hfb, hH] at hres
          dsimp only at hres
          rw [ite_eq_right (by simp), Option.getD_some, ite_eq_right (not_not.mpr hsoA),
            ite_eq_right (not_not.mpr hsoR)] at hres
          subst hS hres
          erase_frame
          -- `k`'s 32 bytes as `reduce` stored them
          rw [MemoryState.readAt_storeAt_self
              (InBounds.hashMem
                (InBounds.lifetimeStart
                  (InBounds.storeQuad5 (InBounds.storeQuad5 (hk₀.mono (by decide))))))]
          simp only [fd_ed25519_verify.Result.mem, ite_ofBool_beq]
          simp
          omega

end Proof

end MLIR.Firedancer.R52x5

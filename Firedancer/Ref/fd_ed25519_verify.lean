module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Common.Verify
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_ed25519_affine_is_small_order
public import Firedancer.Ref.fd_ed25519_point_frombytes_2x
public import Firedancer.Ref.fd_ed25519_verify_equation
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Ref.Mlir.fd_ed25519_verify

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_verify` on the signature halves `r`, `S`, the public key and the message, with
`buf0` the hash object's buffer and `tbl` the base point's table: the checks in the C's order,
`-1`/`-2`/`-3` for a bad signature, key or message, `0` if `[S]B = R + [k]A'` holds as
`fd_ed25519_verify_equation` decides it. -/
def fd_ed25519_verify.spec (tbl : Nat → PointLimbs) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S publicKey : BitVec 256) (buf0 : BitVec 1024) :
    fd_ed25519_verify.Result :=
  -- the three locals' blocks, and `frombytes_2x`'s
  let frame := 3
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
          ⟨if fd_ed25519_verify_equation.spec tbl k Aprime S R = 0#32 then -3#32 else 0#32,
            some sha4,
            blocks + 16 + fd_ed25519_verify.hashBlocks buf0 r publicKey msgSz msg +
              fd_ed25519_verify_equation.blocks k S⟩
    | _, _ => ⟨if res = -1#32 then -2#32 else -1#32, none, frame + fb A? R?⟩

end

/-! ## Proof -/

section Proof

attribute [local mlir_read] MemoryState.readSha_storeSha_self

attribute [local mlir_transport] GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8

/-! ### The memory after the SHA-512 calls -/

theorem MemoryState.PointFit.hashMem {m : MemoryState} (h : m.PointFit q) :
    (fd_ed25519_verify.hashMem m sha k X v).PointFit q := by
  simpa only [MemoryState.PointFit, MemoryState.LimbsFit, Fits.hashMem_iff] using h

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
    (hR : E ⊨ [%780 := 32#64, %788 := k]) (hwf : S.WF) (hsha : S.mem.ShaFit sha)
    (hsig : Fits S.mem sig (8 * 32)) (hsig_off : ¬sig.offset.uaddOverflow 32#64)
    (hpk : Fits S.mem pk (8 * 32)) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hk : S.mem.Words8Fit k) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hmsg_sha : msg.id ≠ sha.id) (hk_sha : k.id ≠ sha.id)
    (hK :
      (fd_ed25519_verify.bb5.runBodyFrom
            E[%800 := .value sha, %801 := .value sha, %802 := .value sha, %803 := .value sha, %804 :=
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
  -- fd_ed25519_point_t Aprime[1], R[1]; uchar k[64];
  step_alloca with A
  step_alloca with R
  step_alloca with k
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
          -- if( fd_ed25519_verify_equation( k, Aprime, S, R ) ) return FD_ED25519_SUCCESS;
          -- return FD_ED25519_ERR_MSG;
          step_call using fd_ed25519_verify_equation.call_eq
          iterate 3 step_pure
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

end MLIR.Firedancer.Ref

module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_memset
public import Firedancer.Ref.fd_ulong_bswap
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Ref.Mlir.fd_sha512_fini
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

open Memory

/-! ## Specification -/

@[expose] public section

namespace fd_sha512_fini

open fd_sha512_append (copy)

/-- "Clear in progress block up to last 128-bits, append the message size … and update the hash":
zeros from `buf_used` to byte 112, the bit count's two words big-endian, then the block compressed
into `state`. -/
def last (sha : ShaState) (buf_used : BitVec 64) : ShaState :=
  let buf := copy sha.buf buf_used ((0#8).replicate (112#64 - buf_used).toNat)
  let buf := copy buf 112#64 (fd_ulong_bswap.spec sha.bitCntHi)
  let buf := copy buf 120#64 (fd_ulong_bswap.spec sha.bitCntLo)
  { sha with
    buf, state := fd_sha512_core_ref.spec (n := 1) sha.state buf }

/-- How many `fd_sha512_core` calls `fini` makes. -/
def cores (sha : ShaState) : Nat :=
  if (112#64).ult (sha.bufUsed + 1#64) then 2 else 1

end fd_sha512_fini

open fd_sha512_fini fd_sha512_append in
/-- The struct after `fini`, and the hash: `state`'s words byte-swapped (`hash[k] =
fd_ulong_bswap( state[k] )`). -/
def fd_sha512_fini.spec (sha : ShaState) : ShaState × Vector (BitVec 64) 8 :=
  let buf_used := sha.bufUsed
  let sha := { sha with buf := copy sha.buf buf_used 0x80#8 }
  let buf_used := buf_used + 1#64
  let sha :=
    if (112#64).ult buf_used then
      let buf := copy sha.buf buf_used ((0#8).replicate (128#64 - buf_used).toNat)
      last
        { sha with
          buf, state := fd_sha512_core_ref.spec (n := 1) sha.state buf }
        0#64
    else last sha buf_used
  (sha, sha.state.map fd_ulong_bswap.spec)

end

/-! ## Proof -/

section Proof

namespace fd_sha512_fini

/-- `^bb2`, the last block from `buf_used = x`. -/
abbrev hdr2 (sha : Pointer) (lo hi x : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%813 := .value 1#64, %814 := .value 112#64, %817 := .value (sha.add 128#64), %821 := .value lo,
    %823 := .value hi, %830 := .value x]

/-- The last block, then the hash stored at `hash`; returns `hash`. -/
theorem last_block (sha hash : Pointer) (lo hi x : BitVec 64) (M : MemoryState) (v : ShaState)
    (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_fini.args (.value sha) (.value hash)).get) (hwf : S₁.WF)
    (hM : S₁.mem = M.storeSha sha v) (hMf : M.ShaFit sha) (hh : S₁.mem.Words8Fit hash)
    (hsep : hash.id ≠ sha.id) (hx : x.toNat ≤ 112) (hlo : v.bitCntLo = lo) (hhi : v.bitCntHi = hi)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value hash) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2⟩,
                mem :=
                  (M.storeSha sha (last v x)).storeWords8 hash
                    ((last v x).state.map fd_ulong_bswap.spec) }) >>=
          g) =
        K) :
    (fd_sha512_fini.runFrom (hdr2 sha lo hi x E) 2 S₁ >>= g) = K := by
  subst hK
  have hSf : S₁.mem.ShaFit sha := hM ▸ hMf.storeSha
  have hov : ¬sha.offset.uaddOverflow x :=
    BitVec.not_uaddOverflow_of_le hMf.2
      (by
        simp; omega)
  have hxl : x.toNat < 18446744073709551616 := by omega
  have hsub : (112#64 - x).toNat = 112 - x.toNat :=
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)
  have hz : Fits S₁.mem (sha.add x) (8 * (112#64 - x).toNat) :=
    Fits.add_of_le hov
      (by
        rw [hsub]; omega)
      hSf.1
  have hx' : x ≤ 112#64 := by
    rw [BitVec.le_def]; simpa using hx
  have hs : (112#64).ssubOverflow x = false := by bv_decide
  have hu : (112#64).usubOverflow x = false := by bv_decide
  block_init
  -- fd_memset( buf + buf_used, 0, FD_SHA512_PRIVATE_BUF_MAX-16UL-buf_used );
  -- (`%arg59` is read through `hArgs`, passed by hand: the step does not use it)
  step_pure [hxl, hArgs, fd_sha512_fini.args, Vals.get, gep_value hov]
  step_pure [hs, hu]
  step_call using fd_memset.call_eq [↓hsub] consuming hz
  rw [hM, MemoryState.storeSha_storeAt_buf hMf.2 (by omega)] at hS
  -- *((ulong *)(buf+FD_SHA512_PRIVATE_BUF_MAX-16UL)) = fd_ulong_bswap( bit_cnt_hi ); … lo
  step_call using fd_ulong_bswap.call_eq
  step_pure
  step_store
  step_call using fd_ulong_bswap.call_eq
  step_pure
  step_store
  rw [MemoryState.storeSha_storeAt_buf hMf.2 (by decide),
    MemoryState.storeSha_storeAt_buf hMf.2 (by decide)] at hS
  -- fd_sha512_core( state, buf, 1UL );
  have hst := hSf.words8Fit
  have h1 : Fits S.mem sha (1024 * (1#64).toNat) := hSf.fits_buf (by decide)
  have h1o : sha.offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
    have := hMf.2
    simp [BitVec.uaddOverflow] at this ⊢
    omega
  have h1d : (Range.of (sha.add 128#64) 512).Disjoint (Range.of sha (1024 * (1#64).toNat)) :=
    (Range.disjoint_sha_base hMf.2 (b := 128) (by decide) (by decide)).symm
  step_call using fd_sha512_core_ref.call_eq consuming hst h1 h1o h1d
  rw [MemoryState.readWords8_storeSha_state hMf, MemoryState.readAt_storeSha_buf hMf,
    MemoryState.storeSha_storeWords8_state] at hS
  replace hS : S = { alloc := ⟨S₁.alloc.nextFreeBlock + 2⟩, mem := M.storeSha sha (last v x) } := by
    rw [hS]
    unfold last fd_sha512_append.copy
    rw [hsub, hlo, hhi]
  -- the struct's value left opaque, so the loads' values stay `vF.state[k]`
  generalize last v x = vF at hS ⊢
  -- hash[k] = fd_ulong_bswap( state[k] );
  step_load [MemoryState.readAt_storeSha_state hMf]
  step_call using fd_ulong_bswap.call_eq
  step_store
  iterate 7 
    step_pure
    step_load [MemoryState.readAt_storeSha_state hMf]
    step_call using fd_ulong_bswap.call_eq
    step_pure
    step_store
  finish_block
  rw [hS]
  simp only [MemoryState.storeWords8, Vector.getElem_map]

end fd_sha512_fini

/-- `fd_sha512_fini` pads the buffered bytes, compresses the last block (or two) into the state and
stores the state's words, byte-swapped, at `hash` (64 bytes); returns `hash`. Each
`fd_sha512_core` call leaves two blocks counted; `hash` is in another block than `sha`. -/
public theorem fd_sha512_fini.call_eq (sha hash : Pointer) (s : GlobalState) (hwf : s.WF)
    (hsha : s.mem.ShaFit sha) (hu : (s.mem.readSha sha).bufUsed.toNat < 128)
    (hh : s.mem.Words8Fit hash) (hsep : hash.id ≠ sha.id) :
    fd_sha512_fini.call (fd_sha512_fini.args (.value sha) (.value hash)) s =
      .value
        (.cons (.value hash) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2 * fd_sha512_fini.cores (s.mem.readSha sha)⟩,
            mem :=
              (s.mem.storeSha sha (fd_sha512_fini.spec (s.mem.readSha sha)).1).storeWords8 hash
                (fd_sha512_fini.spec (s.mem.readSha sha)).2 }) := by
  func_init
  have hsha₀ : S₀.mem.ShaFit sha := hS ▸ hsha
  have hu₀ : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 128 := hS ▸ hu
  clear hu
  have hov : ¬sha.offset.uaddOverflow (S₀.mem.readAt (sha.add 200#64) 64) :=
    BitVec.not_uaddOverflow_of_le hsha₀.2
      (by
        simp; omega)
  have hlt : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 18446744073709551616 := by omega
  have hb : Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64)) 8 :=
    Fits.add_of_le hov (by omega) hsha.1
  block_init
  iterate 5 step_pure
  -- ulong buf_used = sha->buf_used; ulong bit_cnt_lo = …; ulong bit_cnt_hi = …;
  step_pure
  step_pure
  step_load with transparent buf_used
  step_pure
  step_load with transparent bit_cnt_lo
  step_pure
  step_load with transparent bit_cnt_hi
  -- buf[ buf_used ] = (uchar)0x80;
  step_pure [hlt, gep_value hov]
  step_store consuming hb
  rw [MemoryState.storeAt_buf_eq hsha₀ (by omega)] at hS
  -- buf_used++;
  have hx1 :
    (S₀.mem.readAt (sha.add 200#64) 64 + 1#64).toNat =
      (S₀.mem.readAt (sha.add 200#64) 64).toNat + 1 := by
    rw [BitVec.toNat_add]
    simp
    omega
  step_pure
  step_pure
  finish_block
  · -- buf_used > 112: the block's rest zeroed and compressed, then a block from 0
    have hx : 112 ≤ (S₀.mem.readAt (sha.add 200#64) 64).toNat := by
      have := hbr
      simp [BitVec.ult, hx1] at this
      omega
    have hov1 : ¬sha.offset.uaddOverflow (S₀.mem.readAt (sha.add 200#64) 64 + 1#64) :=
      BitVec.not_uaddOverflow_of_le hsha₀.2
        (by
          rw [hx1]; simp; omega)
    have hlt1 : (S₀.mem.readAt (sha.add 200#64) 64 + 1#64).toNat < 18446744073709551616 := by omega
    have hsub :
      (127#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat =
        127 - (S₀.mem.readAt (sha.add 200#64) 64).toNat :=
      BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def]; simp; omega)
    have hz :
      Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64 + 1#64))
        (8 * (127#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) :=
      Fits.add_of_le hov1
        (by
          rw [hsub, hx1]; omega)
        hsha.1
    have hst := hsha.words8Fit
    have h1 : Fits S.mem sha (1024 * (1#64).toNat) := hsha.fits_buf (by decide)
    have h1o : sha.offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
      have := hsha₀.2
      simp [BitVec.uaddOverflow] at this ⊢
      omega
    have h1d : (Range.of (sha.add 128#64) 512).Disjoint (Range.of sha (1024 * (1#64).toNat)) :=
      (Range.disjoint_sha_base hsha₀.2 (b := 128) (by decide) (by decide)).symm
    block_init
    -- fd_memset( buf + buf_used, 0, FD_SHA512_PRIVATE_BUF_MAX-buf_used );
    step_pure [hlt1, hArgs, fd_sha512_fini.args, Vals.get, gep_value hov1]
    step_pure
    step_call using fd_memset.call_eq [↓hsub] consuming hz
    rw [MemoryState.storeSha_storeAt_buf hsha₀.2
        (by
          rw [hx1]; omega)] at hS
    -- fd_sha512_core( state, buf, 1UL );
    step_call using fd_sha512_core_ref.call_eq consuming hst h1 h1o h1d
    rw [MemoryState.readWords8_storeSha_state hsha₀, MemoryState.readAt_storeSha_buf hsha₀,
      MemoryState.storeSha_storeWords8_state] at hS
    have hM := congrArg GlobalState.mem hS
    dsimp only at hM
    finish_block
    step_loop using
      fd_sha512_fini.last_block sha hash bit_cnt_lo bit_cnt_hi 0#64 S₀.mem _ (hM := hM) (hx := by
        decide) (hlo := by
        rw [hbit_cnt_lo]; rfl) (hhi := by
        rw [hbit_cnt_hi]; rfl) (hK := ?_)
    have hc : (112#64).ult ((S₀.mem.readSha sha).bufUsed + 1#64) = true := by
      simpa [MemoryState.readSha] using hbr
    refine ⟨by simp [cores, hc], ?_⟩
    rw [MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
    have hmod :
      (18446744073709551616 - (S₀.mem.readAt (sha.add 200#64) 64).toNat + 127) %
          18446744073709551616 =
        127 - (S₀.mem.readAt (sha.add 200#64) 64).toNat := by
      omega
    have h128 :
      (128#64 - (S₀.mem.readAt (sha.add 200#64) 64 + 1#64)).toNat =
        127 - (S₀.mem.readAt (sha.add 200#64) 64).toNat := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hx1]; simp; omega),
        hx1]
      simp
    simp only [spec, hc, ite_true]
    simp only [MemoryState.readSha, fd_sha512_append.copy]
    rw [hmod, h128, hx1]
  · -- buf_used <= 112
    have hx : (S₀.mem.readAt (sha.add 200#64) 64 + 1#64).toNat ≤ 112 := by
      have := hbr
      simp [BitVec.ult, hx1] at this
      omega
    step_loop using
      fd_sha512_fini.last_block sha hash bit_cnt_lo bit_cnt_hi _ S₀.mem
        { S₀.mem.readSha sha with
          buf :=
            spliceBits (S₀.mem.readAt sha 1024) ((S₀.mem.readAt (sha.add 200#64) 64).toNat * 8)
              128#8 }
        (hM := by rw [hS]) (hx := hx) (hlo := by
        rw [hbit_cnt_lo]; rfl) (hhi := by
        rw [hbit_cnt_hi]; rfl) (hK := ?_)
    have hc : (112#64).ult ((S₀.mem.readSha sha).bufUsed + 1#64) = false := by
      simpa [MemoryState.readSha] using hbr
    refine ⟨by simp [cores, hc], ?_⟩
    rw [MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
    simp only [spec, hc, Bool.false_eq_true, ite_false]
    rfl

/-- The struct `fd_sha512_init` leaves (`fd_sha512_init.call_eq`'s memory): `sha512IV`, nothing
buffered or counted, `buf` as it was. -/
public theorem fd_sha512_init.readSha {m : MemoryState} (h : m.ShaFit sha) :
    ((((((((((m.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64) sha512IV[1]).storeAt
                                    (sha.add 144#64) sha512IV[2]).storeAt
                                (sha.add 152#64) sha512IV[3]).storeAt
                            (sha.add 160#64) sha512IV[4]).storeAt
                        (sha.add 168#64) sha512IV[5]).storeAt
                    (sha.add 176#64) sha512IV[6]).storeAt
                (sha.add 184#64) sha512IV[7]).storeAt
            (sha.add 200#64) ((0#8).replicate 24)).readSha
        sha) =
      ⟨m.readAt sha 1024, sha512IV, 0#64, 0#64, 0#64⟩ := by
  simp only [MemoryState.readSha, MemoryState.readWords8, Pointer.add_add, BitVec.reduceAdd]
  simp (disch :=
    first
    | exact Range.disjoint_sha h.2 (by decide) (by decide) (by decide)
    | exact (Range.disjoint_sha_base h.2 (by decide) (by decide)).symm
    |
      ((repeat apply Fits.storeAt); refine h.fits_add ?_;
       decide)) only [MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]
  have hov (k : Nat) (hk : k ≤ 16) : ¬(sha.add 200#64).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    have := h.2
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, not_le] at this ⊢
    omega
  have hf (m' : MemoryState) (hm : Fits m' (sha.add 200#64) 192) (x : BitVec 192) (k : Nat)
    (hk : k ≤ 16 := by decide) :
    (m'.storeAt (sha.add 200#64) x).readAt (sha.add (BitVec.ofNat 64 (200 + k))) 64 =
      x.extractLsb' (k * 8) 64 := by
    have e : sha.add (BitVec.ofNat 64 (200 + k)) = (sha.add 200#64).add (BitVec.ofNat 64 k) := by
      simp only [Pointer.add_add]
      congr 1
      apply BitVec.eq_of_toNat_eq
      simp
    rw [e,
      MemoryState.readAt_storeAt_add hm (hov k (by omega))
        (by
          simp; omega)]
    simp only [BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]
  have hm :
    Fits
      ((((((((m.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64) sha512IV[1]).storeAt
                            (sha.add 144#64) sha512IV[2]).storeAt
                        (sha.add 152#64) sha512IV[3]).storeAt
                    (sha.add 160#64) sha512IV[4]).storeAt
                (sha.add 168#64) sha512IV[5]).storeAt
            (sha.add 176#64) sha512IV[6]).storeAt
        (sha.add 184#64) sha512IV[7])
      (sha.add 200#64) 192 := by
    repeat apply Fits.storeAt
    exact h.fits_add (by decide)
  rw [hf _ hm _ 0, hf _ hm _ 8, hf _ hm _ 16]
  congr 1

end Proof

end MLIR.Firedancer.Ref

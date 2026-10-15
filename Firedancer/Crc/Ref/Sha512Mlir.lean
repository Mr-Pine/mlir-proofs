module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Crc.Ref.MemMlir
public import Firedancer.Crc.Ref.Mlir.fd_sha512_init
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_fini
public import Firedancer.Crc.Ref.Mlir.fd_sha512_clear
import Std.Tactic.BVDecide
import Firedancer.Common.Counter

/-!
# `fd_sha512_init`, `fd_sha512_append`, `fd_sha512_fini`, `fd_sha512_clear` (MLIR lift ↔ spec)

Stated with the tree's specs (`Firedancer.Ref.fd_sha512_append.spec`, `….fd_sha512_fini.spec`),
which `ShaState.Absorbed.fini` relates to `Sha512.digest`. The block core is the axiomatized
`Firedancer.R52x5.fd_sha512_core_avx2`.
-/

namespace MLIR.Firedancer.Crc.Ref

open Memory
open Firedancer.Ref (sha512IV)

/-! ## Proof -/

section Proof

/-- `fd_sha512_init` stores `sha512IV` at `state` (byte `128`) and zeroes `buf_used`, `bit_cnt_lo`
and `bit_cnt_hi` (bytes `200 … 223`), and returns `sha`. -/
public theorem fd_sha512_init.call_eq (sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem sha (8 * 256)) (hoff : ¬sha.offset.uaddOverflow 256#64) :
    fd_sha512_init.call (fd_sha512_init.args (.value sha)) s =
      .value
        (.cons (.value sha) .nil,
          { s with
            mem :=
              ((((((((s.mem.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64)
                                            sha512IV[1]).storeAt
                                        (sha.add 144#64) sha512IV[2]).storeAt
                                    (sha.add 152#64) sha512IV[3]).storeAt
                                (sha.add 160#64) sha512IV[4]).storeAt
                            (sha.add 168#64) sha512IV[5]).storeAt
                        (sha.add 176#64) sha512IV[6]).storeAt
                    (sha.add 184#64) sha512IV[7]).storeAt
                (sha.add 200#64) ((0#8).replicate 24) }) := by
  func_init
  block_init
  -- the constants
  iterate 10 step_pure
  -- `state[0 … 7]`: each word's address, then the word
  iterate 8 
    step_pure
    step_store
  -- `buf_used`'s address, the `memset` of `buf_used … bit_cnt_hi`, the return
  step_pure
  step_memset
  finish_block
  simp [hS]
  rfl

section Append

open Firedancer.Ref.fd_sha512_append (copy leftover bulk cores)

namespace fd_sha512_append

/-! ### Sizes -/

theorem toNat_and_neg128 (n : BitVec 64) :
    (n &&& 18446744073709551488#64).toNat = n.toNat / 128 * 128 := by
  have h : n &&& 18446744073709551488#64 = n - (n &&& 127#64) := by bv_decide
  rw [h,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, toNat_and_127]; omega),
    toNat_and_127]
  omega

/-! ### The leftover: `^bb7 … ^bb10` -/

/-- `^bb7`, the leftover of the `n` bytes at `d`. -/
abbrev hdr7 (sha d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%0 := .value 0#64, %6 := .value 127#64, %7 := .value 18446744073709551488#64, %10 :=
    .value (sha.add 200#64), %32 := .value d, %33 := .value n]

/-- "Buffer any leftover bytes", then return `sha`. -/
theorem leftover_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S.WF) (hM : S.mem = M.storeSha sha v) (hMf : M.ShaFit sha) (hMw : Writable M sha)
    (hd : Fits S.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hn : n.toNat < 2 ^ 63) (hD : S.mem.readAt d (8 * n.toNat) = D)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value sha) .nil, { S with mem := M.storeSha sha (leftover v n D) }) >>=
          g) =
        K) :
    (fd_sha512_append.runFrom (hdr7 sha d n E) 7 S >>= g) = K := by
  subst hK
  have hSf : S.mem.ShaFit sha := hM ▸ hMf.storeSha
  have hSw : Writable S.mem sha := hM ▸ hMw.storeSha
  block_init
  -- buf_used = sz & (FD_SHA512_PRIVATE_BUF_MAX-1UL);
  step_pure
  step_pure
  finish_block
  · block_init
    finish_block
    rw [show leftover v n D = v by simp [leftover, hbr], ← hM]
  · have htail : (n &&& 127#64).toNat < 128 := by
      rw [toNat_and_127]; omega
    have hoff : ¬d.offset.uaddOverflow (n &&& 18446744073709551488#64) :=
      BitVec.not_uaddOverflow_of_le hdo
        (by
          rw [toNat_and_neg128]; omega)
    have hsrc : Fits S.mem (d.add (n &&& 18446744073709551488#64)) (8 * (n &&& 127#64).toNat) :=
      Fits.add_of_le hoff
        (by
          rw [toNat_and_neg128, toNat_and_127]; omega)
        hd
    have hdst : Fits S.mem sha (8 * (n &&& 127#64).toNat) := hSf.fits_buf (by omega)
    have hX :
      S.mem.readAt (d.add (n &&& 18446744073709551488#64)) (8 * (n &&& 127#64).toNat) =
        D.extractLsb' (1024 * (n >>> 7).toNat) (8 * (n &&& 127#64).toNat) := by
      rw [MemoryState.readAt_add_of_readAt hd.inBounds hoff
          (by
            rw [toNat_and_neg128, toNat_and_127]; omega)
          hD,
        toNat_and_neg128, toNat_ushiftRight_7]
      congr 1
      omega
    clear hD
    block_init
    -- fd_memcpy( buf, data + (block_cnt << FD_SHA512_PRIVATE_LG_BUF_MAX), buf_used );
    have hlt : n.toNat &&& 18446744073709551488 < 18446744073709551616 :=
      Nat.lt_of_le_of_lt Nat.and_le_left n.isLt
    have hlt63 : (n &&& 18446744073709551488#64).toNat < 2 ^ 63 := by
      rw [BitVec.toNat_and]
      exact Nat.lt_of_le_of_lt Nat.and_le_left hn
    step_pure
    step_pure [hlt, gep_value hoff]
    step_call using fd_memcpy_68.call_eq
    finish_block
    block_init
    -- sha->buf_used = buf_used;
    step_store
    finish_block
    block_init
    finish_block
    rw [hS, hM, MemoryState.storeSha_storeAt_buf_base hMf.2 (by omega),
      MemoryState.storeSha_storeAt_bufUsed hMf.2]
    simp only [leftover, ne_eq, hbr, not_false_eq_true, ite_true]
    rfl

/-! ### The bulk: `^bb5`, `^bb6` -/

/-- `^bb5`, the bulk of the `n` bytes at `d`. -/
abbrev hdr5 (sha d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (hdr7 sha d n E)[%5 := .value 7#64, %9 := .value (sha.add 128#64)]

/-- "Append the bulk of the data", then the leftover. -/
theorem bulk_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeSha sha v) (hMf : M.ShaFit sha) (hMw : Writable M sha)
    (hd : Fits S₁.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hn : n.toNat < 2 ^ 63) (hD : S₁.mem.readAt d (8 * n.toNat) = D)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value sha) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2 * if n >>> 7 ≠ 0#64 then 1 else 0⟩,
                mem := M.storeSha sha (bulk v n D) }) >>=
          g) =
        K) :
    (fd_sha512_append.runFrom (hdr5 sha d n E) 5 S₁ >>= g) = K := by
  subst hK
  have hSf : S₁.mem.ShaFit sha := hM ▸ hMf.storeSha
  have hSw : Writable S₁.mem sha := hM ▸ hMw.storeSha
  block_init
  -- ulong block_cnt = sz >> FD_SHA512_PRIVATE_LG_BUF_MAX;
  step_pure
  step_pure
  finish_block
  · -- block_cnt == 0
    have h0 : n >>> 7 = 0#64 := by
      have := hbr
      bv_decide
    step_loop using leftover_block sha data d sz n D M v (hK := ?_)
    simp [bulk, h0]
  · -- fd_sha512_core( state, data, block_cnt );
    have h0 : n >>> 7 ≠ 0#64 := by
      have := hbr
      bv_decide
    have hst := hSf.words8Fit
    have hblk : Fits S₁.mem d (1024 * (n >>> 7).toNat) :=
      hd.mono
        (by
          rw [toNat_ushiftRight_7]; omega)
    have hblko : d.offset.toNat + 128 * (n >>> 7).toNat < 2 ^ 64 := by
      rw [toNat_ushiftRight_7]
      simp [BitVec.uaddOverflow] at hdo
      omega
    block_init
    step_call using Firedancer.R52x5.fd_sha512_core_avx2.call_eq
    finish_block
    have hstate : S₁.mem.readWords8 (sha.add 128#64) = v.state := by
      rw [hM]
      exact congrArg ShaState.state (MemoryState.readSha_storeSha_self hMf hMw)
    have hblock :
      S₁.mem.readAt d (1024 * (n >>> 7).toNat) = D.setWidth (1024 * (n >>> 7).toNat) := by
      rw [← hread_d]
      exact
        MemoryState.readAt_of_readAt_le
          (by
            rw [toNat_ushiftRight_7]; omega)
          hD
    rw [hstate, hblock, hM, MemoryState.storeSha_storeWords8_state] at hS
    have hM' := congrArg GlobalState.mem hS
    clear hread_d hblock hstate
    step_loop using leftover_block sha data d sz n D M _ (hK := ?_)
    simp [bulk, h0]

end fd_sha512_append

/-- `fd_sha512_append` appends the `sz` bytes at `data` to the struct at `sha` and returns `sha`.
Each `fd_sha512_core` call it makes leaves two blocks counted; `data` is in another block. -/
public theorem fd_sha512_append.call_eq (sha data : Pointer) (sz : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hu : (s.mem.readSha sha).bufUsed.toNat < 128) (hdata : Fits s.mem data (8 * sz.toNat))
    (hdo : ¬data.offset.uaddOverflow sz) (hsep : data.id ≠ sha.id) (hsz : sz.toNat < 2 ^ 63) :
    fd_sha512_append.call (fd_sha512_append.args (.value sha) (.value data) (.value sz)) s =
      .value
        (.cons (.value sha) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  2 * Firedancer.Ref.fd_sha512_append.cores (s.mem.readSha sha) sz⟩,
            mem :=
              s.mem.storeSha sha
                (Firedancer.Ref.fd_sha512_append.spec (s.mem.readSha sha) sz
                  (s.mem.readAt data (8 * sz.toNat))) }) := by
  func_init
  have hsha₀ : S₀.mem.ShaFit sha := hS ▸ hsha
  have hu₀ : (S₀.mem.readSha sha).bufUsed.toNat < 128 := hS ▸ hu
  clear hu
  block_init
  iterate 9 step_pure
  finish_block
  · -- if( FD_UNLIKELY( !sz ) ) return sha;
    block_init
    finish_block
    subst hS hbr
    simp only [Firedancer.Ref.fd_sha512_append.spec, cores, ↓reduceIte, Nat.mul_zero, Nat.add_zero,
      hwf₀.eraseFrom, MemoryState.storeSha_readSha_self hsha₀]
  · have hsz : sz ≠ 0#64 := hbr
    block_init
    -- ulong buf_used = sha->buf_used; ulong bit_cnt_lo = …; ulong bit_cnt_hi = …;
    step_pure
    step_pure
    step_load with transparent buf_used
    step_pure
    step_load with transparent bit_cnt_lo
    step_pure
    step_load with transparent bit_cnt_hi
    -- new_bit_cnt_lo, new_bit_cnt_hi
    iterate 7 step_pure
    -- sha->bit_cnt_lo = new_bit_cnt_lo; sha->bit_cnt_hi = new_bit_cnt_hi;
    step_store
    step_store
    rw [MemoryState.storeAt_bitCntLo_eq hsha₀, MemoryState.storeSha_storeAt_bitCntHi hsha₀.2] at hS
    have hM := congrArg GlobalState.mem hS
    dsimp only at hM
    have hD : S.mem.readAt data (8 * sz.toNat) = S₀.mem.readAt data (8 * sz.toNat) := by
      rw [hM, MemoryState.readAt_storeSha_of_id_ne hsep]
    step_pure
    finish_block
    · -- buf_used == 0
      step_loop using fd_sha512_append.bulk_block sha data data sz sz _ S₀.mem _ (hK := ?_)
      refine ⟨by simp [cores, MemoryState.readSha, hbr, hsz], ?_⟩
      rw [MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
      simp [Firedancer.Ref.fd_sha512_append.spec, hsz, MemoryState.readSha, hbr]
    · -- buf_used ≠ 0
      have hu0 := hbr
      have hu1 : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 128 := hu₀
      have hov : ¬sha.offset.uaddOverflow (S₀.mem.readAt (sha.add 200#64) 64) :=
        BitVec.not_uaddOverflow_of_le hsha₀.2
          (by
            simp; omega)
      have hlt : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 18446744073709551616 := by omega
      block_init
      -- ulong buf_rem = FD_SHA512_PRIVATE_BUF_MAX - buf_used;
      step_pure
      step_pure
      step_pure [hlt, gep_value hov]
      finish_block
      · -- if( FD_UNLIKELY( sz < buf_rem ) ): fd_memcpy( buf + buf_used, data, sz );
        have hbuf : Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64)) (8 * sz.toNat) :=
          Fits.add_of_le hov
            (by
              have := hbr; simp [BitVec.ult] at this; omega)
            hsha.1
        clear hM
        block_init
        step_call using fd_memcpy_68.call_eq consuming hD
        step_pure
        finish_block
        block_init
        -- sha->buf_used = buf_used + sz;
        step_store
        finish_block
        block_init
        finish_block
        have hb : (S₀.mem.readAt (sha.add 200#64) 64).toNat * 8 + 8 * sz.toNat ≤ 1024 := by
          have := hbr
          simp [BitVec.ult] at this
          omega
        rw [hS, MemoryState.storeSha_storeAt_buf hsha₀.2 hb,
          MemoryState.storeSha_storeAt_bufUsed hsha₀.2, MemoryState.eraseFrom_storeSha,
          hwf₀.eraseFrom]
        simp [Firedancer.Ref.fd_sha512_append.spec, cores, hsz, hbr, hu0, MemoryState.readSha, copy]
      · -- fd_memcpy( buf + buf_used, data, buf_rem ); data += buf_rem; sz -= buf_rem;
        have hrem :
          (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat =
            128 - (S₀.mem.readAt (sha.add 200#64) 64).toNat := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; simp; omega)]
          rfl
        have hge : 128 - (S₀.mem.readAt (sha.add 200#64) 64).toNat ≤ sz.toNat := by
          have := hbr
          simp [BitVec.ult] at this
          omega
        have hbuf :
          Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64))
            (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) :=
          Fits.add_of_le hov
            (by
              rw [hrem]; omega)
            hsha.1
        have hsrc : Fits S.mem data (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) :=
          hdata.mono
            (by
              rw [hrem]; omega)
        have hov' : ¬data.offset.uaddOverflow (128#64 - S₀.mem.readAt (sha.add 200#64) 64) :=
          BitVec.not_uaddOverflow_of_le hdo
            (by
              rw [hrem]; omega)
        have hlt' : (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat < 18446744073709551616 := by
          omega
        have hnuw : sz.usubOverflow (128#64 - S₀.mem.readAt (sha.add 200#64) 64) = false := by
          simp only [BitVec.usubOverflow, hrem, decide_eq_false_iff_not]; omega
        clear hM
        block_init
        step_call using fd_memcpy_68.call_eq consuming hsrc hbuf
        step_pure [hlt', gep_value hov']
        step_pure [hnuw]
        -- fd_sha512_core( state, buf, 1UL ); sha->buf_used = 0UL;
        have hst := hsha.words8Fit
        have h1 : Fits S.mem sha (1024 * (1#64).toNat) := hsha.fits_buf (by decide)
        have h1o : sha.offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
          simp [BitVec.uaddOverflow] at hov ⊢
          have := hsha.2
          simp [BitVec.uaddOverflow] at this
          omega
        have h1d : (Range.of (sha.add 128#64) 512).Disjoint (Range.of sha (1024 * (1#64).toNat)) :=
          (Range.disjoint_sha_base hsha.2 (b := 128) (by decide) (by decide)).symm
        step_call using Firedancer.R52x5.fd_sha512_core_avx2.call_eq
        rw [MemoryState.storeSha_storeAt_buf hsha₀.2
            (by
              rw [hrem]; omega),
          MemoryState.readWords8_storeSha_state hsha₀ hshaw₀,
          MemoryState.readAt_storeSha_buf hsha₀ hshaw₀,
          MemoryState.storeSha_storeWords8_state] at hS
        step_store
        rw [MemoryState.storeSha_storeAt_bufUsed hsha₀.2] at hS
        have hM := congrArg GlobalState.mem hS
        dsimp only at hM
        have hD' :
          S.mem.readAt (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64))
              (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) =
            (S₀.mem.readAt data (8 * sz.toNat)).extractLsb'
              (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat)
              (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) := by
          have hsub :
            (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat =
              sz.toNat - (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat :=
            BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; omega)
          rw [MemoryState.readAt_add_of_readAt hdata.inBounds hov'
              (by
                rw [hsub]; omega)
              hD]
          congr 1
          omega
        have hsub :
          (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat =
            sz.toNat - (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat :=
          BitVec.toNat_sub_of_le
            (by
              rw [BitVec.le_def]; omega)
        have hd' :
          Fits S.mem (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64))
            (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) :=
          Fits.add_of_le hov'
            (by
              rw [hsub]; omega)
            hdata
        have hdo' :
          ¬(data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).offset.uaddOverflow
              (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)) :=
          Pointer.not_uaddOverflow_add_sub hdo (by omega)
        have hsep' : (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).id ≠ sha.id := hsep
        have hpre :
          S₀.mem.readAt data (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) =
            (S₀.mem.readAt data (8 * sz.toNat)).setWidth _ :=
          MemoryState.readAt_of_readAt_le (by omega) rfl
        -- `buf_rem` and the size left as variables, so the step's simp keeps their `toNat`s folded
        have hn63 : (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat < 2 ^ 63 := by
          rw [hsub]; omega
        clear hrem hge hlt' hov' h1o h1d hsub
        generalize hr : 128#64 - S₀.mem.readAt (sha.add 200#64) 64 = rem at *
        generalize hn : sz - rem = n at *
        finish_block
        step_loop using fd_sha512_append.bulk_block sha data _ sz _ _ S₀.mem _ (hK := ?_)
        refine ⟨?_, ?_⟩
        · simp only [cores, MemoryState.readSha, hsz, hr, hbr, hn]
          split <;> simp_all
        · rw [MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
          simp only [Firedancer.Ref.fd_sha512_append.spec, MemoryState.readSha, ne_eq, hsz, hu0,
            not_false_eq_true, ite_true, ite_false]
          have hbr' : ¬sz.ult (128#64 - S₀.mem.readAt (sha.add 200#64) 64) = true := hr ▸ hbr
          simp only [hbr', Bool.false_eq_true, ite_false]
          rw [hr, hn, ← hpre]
          rfl

end Append

section Fini

open Firedancer.Ref.fd_sha512_fini (last cores)

namespace fd_sha512_fini

/-- `^bb2`, the last block from `buf_used = x`. -/
abbrev hdr2 (sha : Pointer) (lo hi x : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1 := .value 1#64, %2 := .value 112#64, %5 := .value (sha.add 128#64), %9 := .value lo, %11 :=
    .value hi, %18 := .value x]

/-- The last block, then the hash stored at `hash`; returns `hash`. -/
theorem last_block (sha hash : Pointer) (lo hi x : BitVec 64) (M : MemoryState) (v : ShaState)
    (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_fini.args (.value sha) (.value hash)).get) (hwf : S₁.WF)
    (hM : S₁.mem = M.storeSha sha v) (hMf : M.ShaFit sha) (hMw : Writable M sha)
    (hh : S₁.mem.Words8Room hash) (hsep : hash.id ≠ sha.id) (hx : x.toNat ≤ 112)
    (hlo : v.bitCntLo = lo) (hhi : v.bitCntHi = hi) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value hash) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2⟩,
                mem :=
                  (M.storeSha sha (last v x)).storeWords8 hash
                    ((last v x).state.map Firedancer.Ref.fd_ulong_bswap.spec) }) >>=
          g) =
        K) :
    (fd_sha512_fini.runFrom (hdr2 sha lo hi x E) 2 S₁ >>= g) = K := by
  subst hK
  have hSf : S₁.mem.ShaFit sha := hM ▸ hMf.storeSha
  have hSw : Writable S₁.mem sha := hM ▸ hMw.storeSha
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
  -- (`%arg0` is read through `hArgs`, passed by hand: the step does not use it)
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
  step_call using Firedancer.R52x5.fd_sha512_core_avx2.call_eq consuming hst h1 h1o h1d
  rw [MemoryState.readWords8_storeSha_state hMf hMw, MemoryState.readAt_storeSha_buf hMf hMw,
    MemoryState.storeSha_storeWords8_state] at hS
  replace hS : S = { alloc := ⟨S₁.alloc.nextFreeBlock + 2⟩, mem := M.storeSha sha (last v x) } := by
    rw [hS]
    unfold last Firedancer.Ref.fd_sha512_append.copy
    rw [hsub, hlo, hhi]
  -- the struct's value left opaque, so the loads' values stay `vF.state[k]`
  generalize last v x = vF at hS ⊢
  -- hash[k] = fd_ulong_bswap( state[k] );
  step_load [MemoryState.readAt_storeSha_state hMf hMw]
  step_call using fd_ulong_bswap.call_eq
  step_store
  iterate 7 
    step_pure
    step_load [MemoryState.readAt_storeSha_state hMf hMw]
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
    (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hu : (s.mem.readSha sha).bufUsed.toNat < 128) (hh : s.mem.Words8Room hash)
    (hsep : hash.id ≠ sha.id) :
    fd_sha512_fini.call (fd_sha512_fini.args (.value sha) (.value hash)) s =
      .value
        (.cons (.value hash) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + 2 * Firedancer.Ref.fd_sha512_fini.cores (s.mem.readSha sha)⟩,
            mem :=
              (s.mem.storeSha sha
                    (Firedancer.Ref.fd_sha512_fini.spec (s.mem.readSha sha)).1).storeWords8
                hash (Firedancer.Ref.fd_sha512_fini.spec (s.mem.readSha sha)).2 }) := by
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
    step_call using Firedancer.R52x5.fd_sha512_core_avx2.call_eq consuming hst h1 h1o h1d
    rw [MemoryState.readWords8_storeSha_state hsha₀ hshaw₀,
      MemoryState.readAt_storeSha_buf hsha₀ hshaw₀, MemoryState.storeSha_storeWords8_state] at hS
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
    simp only [Firedancer.Ref.fd_sha512_fini.spec, hc, ite_true]
    simp only [MemoryState.readSha, Firedancer.Ref.fd_sha512_append.copy]
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
    simp only [Firedancer.Ref.fd_sha512_fini.spec, hc, Bool.false_eq_true, ite_false]
    rfl

end Fini

/-- Zero bytes replicated are zero. -/
theorem replicate_zero_eq (n w : Nat) : BitVec.replicate n 0#w = 0#(w * n) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [BitVec.getLsbD_replicate]

/-- `fd_sha512_clear` runs `fd_sha512_init`, then zeroes `buf` (bytes `0 … 127`). -/
public theorem fd_sha512_clear.call_eq (sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem sha (8 * 256)) (hoff : ¬sha.offset.uaddOverflow 256#64) :
    fd_sha512_clear.call (fd_sha512_clear.args (.value sha)) s =
      .value
        (.nil,
          { s with
            mem :=
              (((((((((s.mem.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64)
                                                sha512IV[1]).storeAt
                                            (sha.add 144#64) sha512IV[2]).storeAt
                                        (sha.add 152#64) sha512IV[3]).storeAt
                                    (sha.add 160#64) sha512IV[4]).storeAt
                                (sha.add 168#64) sha512IV[5]).storeAt
                            (sha.add 176#64) sha512IV[6]).storeAt
                        (sha.add 184#64) sha512IV[7]).storeAt
                    (sha.add 200#64) ((0#8).replicate 24)).storeAt
                sha ((0#8).replicate 128) }) := by
  -- the zeroes left opaque, so `func_init` does not evaluate them
  generalize hz : (0#8).replicate 128 = z
  func_init
  block_init
  step_pure
  step_call using fd_sha512_init.call_eq
  step_call using fd_memzero_explicit.call_eq
  finish_block
  subst hz
  rw [hS, replicate_zero_eq 24 8, replicate_zero_eq 128 8]

end Proof

end MLIR.Firedancer.Crc.Ref

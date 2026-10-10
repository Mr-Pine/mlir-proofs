module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_append
public import Firedancer.R52x5.fd_memcpy
public import Firedancer.R52x5.Mlir.fd_sha512_append
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5

open Memory
open Ref.fd_sha512_append (copy leftover bulk cores)

/-! ## Proof -/

section Proof

namespace fd_sha512_append

/-! ### Sizes -/

theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

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
  E[%388 := .value 0#64, %394 := .value 127#64, %395 := .value 18446744073709551488#64, %398 :=
    .value (sha.add 200#64), %418 := .value d, %419 := .value n]

/-- "Buffer any leftover bytes", then return `sha`. -/
theorem leftover_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S.WF) (hM : S.mem = M.storeSha sha v) (hMf : M.ShaFit sha)
    (hd : Fits S.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hD : S.mem.readAt d (8 * n.toNat) = D) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value sha) .nil, { S with mem := M.storeSha sha (leftover v n D) }) >>=
          g) =
        K) :
    (fd_sha512_append.runFrom (hdr7 sha d n E) 7 S >>= g) = K := by
  subst hK
  have hSf : S.mem.ShaFit sha := hM ▸ hMf.storeSha
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
    step_pure
    step_pure [hlt, gep_value hoff]
    step_call using fd_memcpy.call_eq
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
  (hdr7 sha d n E)[%393 := .value 7#64, %397 := .value (sha.add 128#64)]

/-- "Append the bulk of the data", then the leftover. -/
theorem bulk_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeSha sha v) (hMf : M.ShaFit sha)
    (hd : Fits S₁.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hD : S₁.mem.readAt d (8 * n.toNat) = D) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
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
    step_call using fd_sha512_core_avx2.call_eq
    finish_block
    have hstate : S₁.mem.readWords8 (sha.add 128#64) = v.state := by
      rw [hM]
      exact congrArg ShaState.state (MemoryState.readSha_storeSha_self hMf)
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
    (hwf : s.WF) (hsha : s.mem.ShaFit sha) (hu : (s.mem.readSha sha).bufUsed.toNat < 128)
    (hdata : Fits s.mem data (8 * sz.toNat)) (hdo : ¬data.offset.uaddOverflow sz)
    (hsep : data.id ≠ sha.id) :
    fd_sha512_append.call (fd_sha512_append.args (.value sha) (.value data) (.value sz)) s =
      .value
        (.cons (.value sha) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + 2 * Ref.fd_sha512_append.cores (s.mem.readSha sha) sz⟩,
            mem :=
              s.mem.storeSha sha
                (Ref.fd_sha512_append.spec (s.mem.readSha sha) sz
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
    simp only [Ref.fd_sha512_append.spec, cores, ↓reduceIte, Nat.mul_zero, Nat.add_zero,
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
      simp [Ref.fd_sha512_append.spec, hsz, MemoryState.readSha, hbr]
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
        step_call using fd_memcpy.call_eq consuming hD
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
        simp [Ref.fd_sha512_append.spec, cores, hsz, hbr, hu0, MemoryState.readSha, copy]
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
        step_call using fd_memcpy.call_eq consuming hsrc hbuf
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
        step_call using fd_sha512_core_avx2.call_eq
        rw [MemoryState.storeSha_storeAt_buf hsha₀.2
            (by
              rw [hrem]; omega),
          MemoryState.readWords8_storeSha_state hsha₀, MemoryState.readAt_storeSha_buf hsha₀,
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
        clear hrem hge hlt' hov' h1o h1d hsub
        generalize hr : 128#64 - S₀.mem.readAt (sha.add 200#64) 64 = rem at *
        generalize hn : sz - rem = n at *
        finish_block
        step_loop using fd_sha512_append.bulk_block sha data _ sz _ _ S₀.mem _ (hK := ?_)
        refine ⟨?_, ?_⟩
        · simp only [cores, MemoryState.readSha, hsz, hr, hbr, hn]
          split <;> simp_all
        · rw [MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
          simp only [Ref.fd_sha512_append.spec, MemoryState.readSha, ne_eq, hsz, hu0,
            not_false_eq_true, ite_true, ite_false]
          have hbr' : ¬sz.ult (128#64 - S₀.mem.readAt (sha.add 200#64) 64) = true := hr ▸ hbr
          simp only [hbr', Bool.false_eq_true, ite_false]
          rw [hr, hn, ← hpre]
          rfl

end Proof

end MLIR.Firedancer.R52x5

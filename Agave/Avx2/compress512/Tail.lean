module

public import Agave.Avx2.compress512.Pair
public import Agave.Avx2.compress512.Words
public import Agave.Avx2.compress512.KTable

/-! `compress512` from `^bb1`: the two-block path's buffers started, its loop over the block
pairs from block `i₀`, the state words stored (`^bb17`), the buffers ended (`^bb18`). -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave
open MLIR.Agave.Serial.compress512 (compressBlocks_drop compressBlocks_drop_all)

section Proof

theorem ssub_i₀ {n : BitVec 64} {i₀ : Nat} (h : n.toNat < 2 ^ 56) (hi : i₀ ≤ n.toNat) :
    n.ssubOverflow (BitVec.ofNat 64 i₀) = false := by
  have h1 : n.toInt = n.toNat := by rw [BitVec.toInt_eq_toNat_of_lt (by omega)]
  have h2 : (BitVec.ofNat 64 i₀).toInt = i₀ := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.ssubOverflow, h1, h2]
  omega

theorem usub_i₀ {n : BitVec 64} {i₀ : Nat} (hi : i₀ ≤ n.toNat) :
    n.usubOverflow (BitVec.ofNat 64 i₀) = false := by
  simp [BitVec.usubOverflow]
  omega

theorem toNat_sub_i₀ {n : BitVec 64} {i₀ : Nat} (hi : i₀ ≤ n.toNat) :
    (n - BitVec.ofNat 64 i₀).toNat = n.toNat - i₀ := by
  rw [BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; omega)]
  simp; omega

theorem ssub_half {d : BitVec 64} (h : d.toNat < 2 ^ 63) : d.ssubOverflow (d >>> 1) = false := by
  have h1 : d.toInt = d.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  have h2 : (d >>> 1).toInt = (d >>> 1).toNat :=
    BitVec.toInt_eq_toNat_of_lt
      (by
        simp [Nat.shiftRight_eq_div_pow]; omega)
  simp only [BitVec.ssubOverflow, h1, h2, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  simp
  omega

theorem sub_half {d : BitVec 64} {k : Nat} (h : d.toNat % 2 = 0) (hk : k = d.toNat / 2) :
    d - d >>> 1 = BitVec.ofNat 64 k := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def, Nat.shiftRight_eq_div_pow]; omega)]
  simp [Nat.shiftRight_eq_div_pow]
  omega

attribute [local mlir_transport] KPairs.storeAt KPairs.lifetimeStart KPairs.lifetimeEnd
  KPairs.pairsMem KPairs.tMem

/-- `compress512` from `^bb1` at block `i₀`, the state words `H` at `st`: the remaining blocks'
pairs compressed and the words stored (`storeSha512` up to the erased buffers), or nothing stored
when no pair is left. -/
public theorem tail (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (i₀ : Nat)
    (H : Vector (BitVec 64) 8) (D : BitVec (1024 * n.toNat)) (S₀ : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (B : Nat)
    (hArgs : E.args = (compress512.args (.value st) (.value blocks) (.value n)).get) (hC : Consts E)
    (hP : Ptrs Kp ms t2 ms2 E) (hi₀ : i₀ ≤ n.toNat) (heven : (n.toNat - i₀) % 2 = 0)
    (hn56 : n.toNat < 2 ^ 56) (hdo : blocks.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hst : S₀.mem.Sha512Fit st) (hstw : Writable S₀.mem st) (hH : S₀.mem.readSha512 st = H)
    (hB : Fits S₀.mem blocks (1024 * n.toNat)) (hBr : S₀.mem.readAt blocks (1024 * n.toNat) = D)
    (hms2 : InBounds S₀.mem ms2 1024) (hms2w : Writable S₀.mem ms2) (ht2 : InBounds S₀.mem t2 5120)
    (ht2w : Writable S₀.mem t2) (hmo : ms2.offset = 0)
    (hto : t2.offset = 0) (hKo : Kp.offset = 0) (hKf : Fits S₀.mem Kp 5120) (hK : KPairs S₀.mem Kp)
    (hne1 : ms2.id ≠ Kp.id) (hne2 : t2.id ≠ Kp.id) (hne3 : t2.id ≠ ms2.id)
    (hbm : blocks.id ≠ ms2.id) (hbt : blocks.id ≠ t2.id) (hsm : st.id ≠ ms2.id)
    (hstt : st.id ≠ t2.id) (hB2 : B ≤ ms2.id.id) (hB3 : B ≤ t2.id.id)
    (hK' :
      ∀ S' : GlobalState,
        S'.alloc = S₀.alloc →
          S'.mem.eraseFrom B =
            (S₀.mem.storeSha512 st
                  (Sha512.compressBlocks H ((bytesLE D).drop (128 * i₀)))).eraseFrom
              B →
          g (.nil, S') = K) :
    (compress512.runFrom E[%3871 := BitVec.ofNat 64 i₀] 1 S₀ >>= g) = K := by
  have hself : S₀.mem.storeSha512 st H = S₀.mem := by rw [← hH, storeSha512_readSha512 hst]
  have h0 : S₀.mem.readAt st 64 = H[0] := by
    rw [← hH]; rfl
  have h1 : S₀.mem.readAt (st.add 8#64) 64 = H[1] := by
    rw [← hH]; rfl
  have h2 : S₀.mem.readAt (st.add 16#64) 64 = H[2] := by
    rw [← hH]; rfl
  have h3 : S₀.mem.readAt (st.add 24#64) 64 = H[3] := by
    rw [← hH]; rfl
  have h4 : S₀.mem.readAt (st.add 32#64) 64 = H[4] := by
    rw [← hH]; rfl
  have h5 : S₀.mem.readAt (st.add 40#64) 64 = H[5] := by
    rw [← hH]; rfl
  have h6 : S₀.mem.readAt (st.add 48#64) 64 = H[6] := by
    rw [← hH]; rfl
  have h7 : S₀.mem.readAt (st.add 56#64) 64 = H[7] := by
    rw [← hH]; rfl
  obtain ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩ := hst
  block_init
  step_lifetime
  step_lifetime
  step_pure
  step_memset
  step_pure [ssub_i₀ hn56 hi₀, usub_i₀ hi₀] with d
  have hdn : d.toNat = n.toNat - i₀ := by rw [hd, toNat_sub_i₀ hi₀]
  step_pure
  step_pure [ssub_half (d := d) (by omega),
    sub_half (d := d) (k := (n.toNat - i₀) / 2)
        (by
          rw [hdn]; exact heven)
        (by rw [hdn])]
  step_pure
  finish_block
  · have hn : n.toNat = i₀ := by
      have := eq_of_ofNat_eq hbr (by omega) (by decide); omega
    block_init
    step_lifetime
    step_lifetime
    finish_block
    refine hK' S (by rw [hS]) ?_
    rw [hS, ← hn, compressBlocks_drop_all, hself]
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hB2,
      MemoryState.eraseFrom_lifetimeEnd_of_le hB3,
      MemoryState.eraseFrom_storeAt_of_le (show B ≤ (t2.add 128#64).id.id from hB3),
      MemoryState.eraseFrom_lifetimeStart_of_le hB2, MemoryState.eraseFrom_lifetimeStart_of_le hB3]
  · block_init
    iterate 21 step_pure
    step_load consuming h0
    step_load consuming h1
    step_load consuming h2
    step_load consuming h3
    step_load consuming h4
    step_load consuming h5
    step_load consuming h6
    step_load consuming h7
    finish_block
    have hp : 1 ≤ (n.toNat - i₀) / 2 := by
      have := mt (congrArg (BitVec.ofNat 64)) hbr; omega
    have L :=
      loop9 st blocks Kp ms t2 ms2 n n.toNat D g K hmo hto hKo hne1 hne2 hne3 hbm hbt hn56 hdo
        ((n.toNat - i₀) / 2 - 1) i₀ H S
    rw [show (n.toNat - i₀) / 2 - 1 + 1 = (n.toNat - i₀) / 2 by omega] at L
    run_from using L
    intro _ _ _
    clear L
    have hstw' : Writable S.mem st := by rw [hS]; exact Writable.pairsLoop hstw
    -- `*state = current_state` (`^bb17`), then the buffers' ends (`^bb18`)
    block_init
    iterate 8 step_store
    finish_block
    block_init
    step_lifetime
    step_lifetime
    finish_block
    refine hK' S (by rw [hS]) ?_
    rw [hS, MemoryState.eraseFrom_storeSha512, storeSha512_eq_storeWords hstp]
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hB2,
      MemoryState.eraseFrom_lifetimeEnd_of_le hB3, MemoryState.eraseFrom_storeAt,
      eraseFrom_pairsLoop_of_le hB2 hB3,
      MemoryState.storeAt_eraseFrom_of_le (show B ≤ (t2.add 128#64).id.id from hB3),
      MemoryState.eraseFrom_lifetimeStart_of_le hB2, MemoryState.eraseFrom_lifetimeStart_of_le hB3]
    rfl

end Proof

end MLIR.Agave.Avx2.compress512

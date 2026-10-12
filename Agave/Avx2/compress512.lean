module

public import MLIR.Run.Tactic
public import Agave.Serial.compress512
public import Agave.Avx2.Mlir.compress512
public import Agave.Avx2.compress512.Single
public import Agave.Avx2.compress512.Tail

namespace MLIR.Agave.Avx2

open _root_.Ed25519 MLIR.Agave compress512

attribute [local mlir_transport] KPairs.storeAt KPairs.lifetimeStart KPairs.lifetimeEnd

/-- `compress512(state, blocks, n)` compresses the `n` 128-byte blocks at `blocks` into the eight
state words at `state` and stores the result there (`Serial.compress512.spec`, SHA-512's
compression of each block in order). The state is read and stored between block pairs, so it is
apart from the blocks; the `K` table and the three schedule buffers take four blocks. -/
public theorem compress512.call_eq (st blocks : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hst : s.mem.Sha512Fit st) (hn56 : n.toNat < 2 ^ 56)
    (hB : Fits s.mem blocks (1024 * n.toNat)) (hdo : blocks.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of blocks (1024 * n.toNat))) :
    compress512.call (compress512.args (.value st) (.value blocks) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              s.mem.storeSha512 st
                (Serial.compress512.spec (s.mem.readSha512 st)
                  (bytesLE (s.mem.readAt blocks (1024 * n.toNat)))) }) := by
  generalize hD : s.mem.readAt blocks (1024 * n.toNat) = D
  generalize hH : s.mem.readSha512 st = H
  func_init
  have hself : S₀.mem.storeSha512 st H = S₀.mem := by rw [← hS, ← hH, storeSha512_readSha512 hst]
  have h0 : S.mem.readAt st 64 = H[0] := by
    rw [← hH]; rfl
  have h1 : S.mem.readAt (st.add 8#64) 64 = H[1] := by
    rw [← hH]; rfl
  have h2 : S.mem.readAt (st.add 16#64) 64 = H[2] := by
    rw [← hH]; rfl
  have h3 : S.mem.readAt (st.add 24#64) 64 = H[3] := by
    rw [← hH]; rfl
  have h4 : S.mem.readAt (st.add 32#64) 64 = H[4] := by
    rw [← hH]; rfl
  have h5 : S.mem.readAt (st.add 40#64) 64 = H[5] := by
    rw [← hH]; rfl
  have h6 : S.mem.readAt (st.add 48#64) 64 = H[6] := by
    rw [← hH]; rfl
  have h7 : S.mem.readAt (st.add 56#64) 64 = H[7] := by
    rw [← hH]; rfl
  obtain ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩ := hst
  block_init
  iterate 17 step_pure
  step_addressof Serial.anon_13b8ab24e6986c1da96f68a50a4d6db2_1.value_eq with Kp
  iterate 47 step_pure
  step_alloca with ms
  step_alloca with t2
  step_alloca with ms2
  step_pure
  step_pure
  have hK := kPairs_of_readAt hKp_fits hKp_off hread_Kp
  finish_block
  · have heven : n.toNat % 2 = 0 := by
      have := congrArg BitVec.toNat hbr
      simp [BitVec.toNat_and] at this
      omega
    rw [hE] at hArgs ⊢
    refine
      tail st blocks Kp ms t2 ms2 n 0 H D S _ _ _ S₀.alloc.nextFreeBlock (by simpa using hArgs) ?_
        ?_ (Nat.zero_le _) (by omega) hn56 hdo ?_ ?_ hB hD hms2_bounds ht2_bounds hms2_off ht2_off
        hKp_off hKp_fits hK ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
    · env_reads
    · env_reads
    · exact ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩
    · simp only [MemoryState.readSha512, h0, h1, h2, h3, h4, h5, h6, h7]
      ext i hi
      rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
        first
        | rfl
        | omega
    all_goals try mem_fact
    all_goals try slot_bound
    intro S' ha he
    simp only [ha, he, hS, Nat.mul_zero, List.drop_zero, Serial.compress512.spec]
    erase_frame
    rfl
  · have hodd : n.toNat % 2 = 1 := by
      have : (n &&& 1#64).toNat ≠ 0 := fun h => hbr (BitVec.eq_of_toNat_eq (by simpa using h))
      simp [BitVec.toNat_and] at this
      omega
    have hB1 : Fits S.mem blocks 1024 := hB.mono (by omega)
    have hBr1 : S.mem.readAt blocks 1024 = D.extractLsb' 0 1024 := by
      rw [MemoryState.readAt_of_readAt_le (by omega) hD, BitVec.setWidth_eq_extractLsb' (by omega)]
    have hH' : S.mem.readSha512 st = H := by
      simp only [MemoryState.readSha512, h0, h1, h2, h3, h4, h5, h6, h7]
      ext i hi
      rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
        first
        | rfl
        | omega
    refine
      single st blocks Kp ms t2 ms2 n H (D.extractLsb' 0 1024) S E _ _ hArgs (by env_reads)
        (by env_reads) ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩ hH' hB1 hBr1 (by omega)
        hms_bounds hms_off hKp_fits hKp_off hK (by mem_fact) (by mem_fact) (by mem_fact)
        fun E' a b c => ?_
    refine
      tail st blocks Kp ms t2 ms2 n 1 (Sha512.compress H (bytesLE (D.extractLsb' 0 1024))) D _ E' _
        _ S₀.alloc.nextFreeBlock a b c (by omega) (by omega) hn56 hdo
        ⟨hstp, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ ?_ ?_ ?_ ?_ ?_ hms2_off ht2_off hKp_off ?_ ?_ ?_ ?_
        ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
    all_goals try mem_fact
    all_goals try slot_bound
    · rw [readSha512_lifetimeEnd,
        readSha512_storeWords_self hstp
          (InBounds.pairsMem
            (InBounds.lifetimeStart
              (MemoryState.Sha512Fit.fits
                  ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩).inBounds))]
    · simp only [MemoryState.readAt_lifetimeEnd]
      rw [readAt_storeWords_of_disjoint hstp hsep, readAt_pairsMem_of_id_ne (by mem_fact),
        MemoryState.readAt_lifetimeStart]
      exact hD
    · exact
        KPairs.lifetimeEnd
          (KPairs.storeWords (KPairs.pairsMem (KPairs.lifetimeStart hK) (by mem_fact))
            (by mem_fact))
    intro S' ha he
    have hms_B : S₀.alloc.nextFreeBlock ≤ ms.id.id := by slot_bound
    have hspec := compressBlocks_drop D (j := 0) (by omega) H
    simp only [Nat.mul_zero, List.drop_zero, Nat.zero_add, Nat.mul_one] at hspec
    rw [MemoryState.eraseFrom_storeSha512, MemoryState.eraseFrom_lifetimeEnd_of_le hms_B,
      eraseFrom_storeWords, eraseFrom_pairsMem_of_le hms_B,
      MemoryState.eraseFrom_lifetimeStart_of_le hms_B, storeSha512_storeWords hstp, ← hspec] at he
    simp only [ha, he, hS, Serial.compress512.spec]
    erase_frame
    rfl

end MLIR.Agave.Avx2

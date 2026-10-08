
end Sha512_round

open Sha512_round in
set_option maxHeartbeats 0 in
/-- `Sha512.round` compresses the 128-byte block at `b` into the state words of the object at `d`
(FIPS 180-4 `Sha512.compress`, the block's bytes in memory order); its frame takes two blocks. -/
public theorem Sha512_round.call_eq (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdf : Fits s.mem d 640) (hdo : d.offset.toNat + 80 < 2 ^ 64) (hbf : Fits s.mem b 1024)
    (hbo : b.offset.toNat + 128 < 2 ^ 64) :
    Sha512_round.call (Sha512_round.args (.value d) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem :=
              Sha512Obj.setState s.mem d
                (Sha512.compress (Sha512Obj.state s.mem d) (bytesLE (s.mem.readAt b 1024))) }) := by
  func_init
  block_init
  iterate 102 step_pure
  step_alloca with V
  step_alloca with W
  finish_block
  have hfit (k : Nat) (hk : k + 8 ≤ 80) : Fits S₀.mem (d.add (BitVec.ofNat 64 k)) 64 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hdf₀
  have hfitS (k : Nat) (hk : k + 8 ≤ 80) : Fits S.mem (d.add (BitVec.ofNat 64 k)) 64 := by
    rw [hS]; exact ((hfit k hk).alloca hwf₀).alloca hwf₀.alloca
  have hrd (q : Pointer) (w : Nat) (hq : Fits S₀.mem q w) : S.mem.readAt q w = S₀.mem.readAt q w := by
    rw [hS, MemoryState.readAt_alloca hwf₀.alloca (hq.alloca hwf₀), MemoryState.readAt_alloca hwf₀ hq]
  generalize hBd : S₀.mem.readAt b 1024 = B
  have hB : S.mem.readAt b 1024 = B := (hrd b 1024 hbf₀).trans hBd
  refine loop1 d b V W B _ _ hW_off hbo hb_ne_W.symm 16 0 S E rfl hArgs (by env_reads)
    (by env_reads) hwf hW_fits hbf hB fun E1 hA1 hc1 hR1 => ?_
  have h16 : HoldsW (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem) W
      (fun t => (Sha512.schedule (bytesLE B))[t]!) 16 :=
    (HoldsW.stores (N := 80) hW_off (by decide) 16 0 hW_fits holdsW_zero (by omega)).congr
      fun t ht => by simp only [Sha512.getElem!_schedule_lt _ ht, word_eq B ht]
  refine loop2 d b V W (fun t => (Sha512.schedule (bytesLE B))[t]!) _ _ hW_off (fun t h1 h2 => Sha512.getElem!_schedule_ge _ h1 h2) 64 16 _ E1
    rfl (Nat.le_refl _) hA1 hc1 hR1 (wf_stores 16 0 _ hwf) (fits_stores.2 hW_fits) h16
    fun E2 hA2 hc2 hR2 => ?_
  -- the words the rounds read and write, as `s` holds them
  have hrd2 (k : Nat) (hk : k + 8 ≤ 80) :
      (stores W (fun t => (Sha512.schedule (bytesLE B))[t]!) 16 64
          (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem)).readAt
        (d.add (BitVec.ofNat 64 k)) 64 = S₀.mem.readAt (d.add (BitVec.ofNat 64 k)) 64 := by
    rw [readAt_stores_ne (by simpa using hd_ne_W), readAt_stores_ne (by simpa using hd_ne_W),
      hrd _ _ (hfit k hk)]
  have hW80 := HoldsW.stores (N := 80) hW_off (by decide) 64 16 (fits_stores.2 hW_fits) h16 (by omega)
  refine block5 d b V W (fun t => (Sha512.schedule (bytesLE B))[t]!) _ _ _ _ _ _ _ _ E2 _ _ _ hA2 hc2
    hR2 hdo (fits_stores.2 (fits_stores.2 (hfitS 16 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 24 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 32 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 40 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 48 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 56 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 64 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 72 (by omega))))
    (hrd2 16 (by omega)) (hrd2 24 (by omega)) (hrd2 32 (by omega)) (hrd2 40 (by omega))
    (hrd2 48 (by omega)) (hrd2 56 (by omega)) (hrd2 64 (by omega)) (hrd2 72 (by omega))
    hW_off (fits_stores.2 (fits_stores.2 hW_fits)) hV_off (fits_stores.2 (fits_stores.2 hV_fits))
    hW80 fun E3 hA3 hc3 hR3 => ?_
  refine loop3 d b V (fun j => (Sha512Obj.state S₀.mem d)[j]!)
    (fun j => (rounds (fun t => (Sha512.schedule (bytesLE B))[t]!) 0 80
      #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64, S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64, S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64, S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])[j]!)
    _ _ hV_off hdo hd_ne_V.symm 8 0 _ E3 rfl hA3 hc3 ⟨hR3.2.1, hR3.2.2, hR3.1⟩ ?_ ?_ ?_ ?_ ?_ ?_
  · dsimp only
    rw [storeWords8_eq]
    exact wf_stores 8 0 _ (wf_stores 64 16 _ (wf_stores 16 0 _ hwf))
  · dsimp only
    rw [storeWords8_eq]
    exact fits_stores.2 (fits_stores.2 (fits_stores.2 hV_fits))
  · intro j hj
    dsimp only
    rw [storeWords8_eq]
    refine fits_stores.2 (fits_stores.2 (fits_stores.2 ?_))
    rw [hS]
    refine ((Fits.add_of_le ?_ ?_ hdf₀).alloca hwf₀).alloca hwf₀.alloca
    · simp [BitVec.uaddOverflow]; omega
    · simp; omega
  · intro j _ hj
    dsimp only
    rw [storeWords8_eq]
    exact HoldsW.stores (N := 8) hV_off (by decide) 8 0
      (fits_stores.2 (fits_stores.2 hV_fits)) holdsW_zero (by omega) j hj
  · intro j _ hj
    dsimp only
    have hf : Fits S₀.mem (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 := by
      refine Fits.add_of_le ?_ ?_ hdf₀
      · simp [BitVec.uaddOverflow]; omega
      · simp; omega
    rw [storeWords8_eq, readAt_stores_ne (by simpa using hd_ne_V), readAt_stores_ne (by simpa using hd_ne_W),
      readAt_stores_ne (by simpa using hd_ne_W), hrd _ _ hf]
    simp [Sha512Obj.state, hj]
  · have hstate : Sha512Obj.state S₀.mem d = #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64, S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64, S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64, S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64] := rfl
    have hWn : S₀.alloc.nextFreeBlock ≤ W.id.id := by rw [hW]; simp [GlobalState.slot]
    have hVn : S₀.alloc.nextFreeBlock ≤ V.id.id := by rw [hV]; simp [GlobalState.slot]
    dsimp only
    rw [eraseFrom_storeWords, storeWords8_eq, eraseFrom_stores hVn, eraseFrom_stores hWn,
      eraseFrom_stores hWn, hS, GlobalState.eraseFrom_alloca_of_le (by simp [GlobalState.alloca]),
      GlobalState.eraseFrom_alloca_of_le (Nat.le_refl _), hwf₀.eraseFrom, ← hstate]
    rw [storeWords_congr (g := fun j => (Sha512.compress (Sha512Obj.state S₀.mem d) (bytesLE B))[j]!) 8 0]
    · rfl
    · intro j _ hj
      have hj8 : j < 8 := by omega
      exact (compress_getElem! _ _ hj8).symm

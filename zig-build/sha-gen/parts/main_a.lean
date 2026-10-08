
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
  sorry

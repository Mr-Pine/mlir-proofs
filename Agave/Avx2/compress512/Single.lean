module

public import Agave.Avx2.compress512.Loop1

/-! `compress512`'s single-block path (`sha512_compress_x86_64_avx`, an odd block count's first
block): `^bb2`'s loads, the loops, and the sums `^bb7`. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

section Proof

attribute [local mlir_transport] KPairs.storeAt KPairs.lifetimeStart KPairs.lifetimeEnd
  KPairs.pairsMem

-- `^bb2`'s 70 steps, two loop lemmas and `^bb7`'s sums
set_option maxHeartbeats 1000000 in
/-- The single-block path from `^bb2` (`sha512_compress_x86_64_avx(state, &blocks[0])`): the
block's schedule pairs into `ms`, its 80 rounds, the sums stored at `state`; then `^bb1` from
block `1`. -/
public theorem single (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (H : Vector (BitVec 64) 8)
    (B : BitVec 1024) (S₀ : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs : E.args = (compress512.args (.value st) (.value blocks) (.value n)).get) (hC : Consts E)
    (hP : Ptrs Kp ms t2 ms2 E) (hst : S₀.mem.Sha512Fit st) (hH : S₀.mem.readSha512 st = H)
    (hB : Fits S₀.mem blocks 1024) (hBr : S₀.mem.readAt blocks 1024 = B)
    (hbo : blocks.offset.toNat + 128 < 2 ^ 64) (hms : InBounds S₀.mem ms 1024) (hmo : ms.offset = 0)
    (hKf : Fits S₀.mem Kp 5120) (hKo : Kp.offset = 0) (hK : KPairs S₀.mem Kp)
    (hst_ms : st.id ≠ ms.id) (hb_ms : blocks.id ≠ ms.id) (hms_K : ms.id ≠ Kp.id)
    (hK' :
      ∀ E' : ⟪Γ⟫,
        E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
          Consts E' →
          Ptrs Kp ms t2 ms2 E' →
          (compress512.runFrom E'[%3871 := 1#64] 1
                { S₀ with
                  mem :=
                    (storeWords (pairsMem ms (bsched B) 0 40 (S₀.mem.lifetimeStart ms)) st
                          (Sha512.compress H (bytesLE B))).lifetimeEnd
                      ms } >>=
              g) =
            K) :
    (compress512.runFrom E 2 S₀ >>= g) = K := by
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
  have hq (q : Nat) (hq : q < 8) :
    Fits S₀.mem (blocks.add (BitVec.ofNat 64 (16 * q))) 128 ∧
      S₀.mem.readAt (blocks.add (BitVec.ofNat 64 (16 * q))) 128 = B.extractLsb' (128 * q) 128 := by
    have hov : ¬blocks.offset.uaddOverflow (BitVec.ofNat 64 (16 * q)) := by
      simp [BitVec.uaddOverflow]; omega
    refine
      ⟨Fits.add_of_le hov
          (by
            simp; omega)
          hB,
        ?_⟩
    rw [MemoryState.readAt_add_of_readAt hB.inBounds hov
        (by
          simp; omega)
        hBr]
    congr 1
    simp; omega
  obtain ⟨hq0f, hq0⟩ : Fits S₀.mem blocks 128 ∧ S₀.mem.readAt blocks 128 = B.extractLsb' 0 128 := by
    simpa using hq 0 (by decide)
  obtain ⟨hq1f, hq1⟩ := hq 1 (by decide)
  simp only [Nat.reduceMul] at hq1f hq1
  obtain ⟨hq2f, hq2⟩ := hq 2 (by decide)
  simp only [Nat.reduceMul] at hq2f hq2
  obtain ⟨hq3f, hq3⟩ := hq 3 (by decide)
  simp only [Nat.reduceMul] at hq3f hq3
  obtain ⟨hq4f, hq4⟩ := hq 4 (by decide)
  simp only [Nat.reduceMul] at hq4f hq4
  obtain ⟨hq5f, hq5⟩ := hq 5 (by decide)
  simp only [Nat.reduceMul] at hq5f hq5
  obtain ⟨hq6f, hq6⟩ := hq 6 (by decide)
  simp only [Nat.reduceMul] at hq6f hq6
  obtain ⟨hq7f, hq7⟩ := hq 7 (by decide)
  simp only [Nat.reduceMul] at hq7f hq7
  obtain ⟨hstp, hs0, hs1, hs2, hs3, hs4, hs5, hs6, hs7⟩ := hst
  clear hq hB hBr
  block_init
  -- let mut current_state = *state;
  step_lifetime
  step_load consuming h0
  step_pure
  step_load consuming h1
  step_pure
  step_load consuming h2
  step_pure
  step_load consuming h3
  step_pure
  step_load consuming h4
  step_pure
  step_load consuming h5
  step_pure
  step_load consuming h6
  step_pure
  step_load consuming h7
  -- load_data_avx(&mut x, &mut ms, block.as_ptr().cast());
  step_load with d0 hd0 consuming hq0
  step_pure with sh0 hsh0
  step_pure with x0 hx0
  step_pure with y0 hy0
  have ex0 := load_lanes hd0 hsh0 hx0 (B := B) (q := 0) (by decide) (by simp)
  have ey0 := load_y hy0 ex0 (by decide) (by decide)
  clear hd0 hsh0 hx0 hy0
  subst ex0 ey0
  step_store
  step_pure
  step_load with d1 hd1 consuming hq1
  step_pure with sh1 hsh1
  step_pure with x1 hx1
  step_pure with y1 hy1
  have ex1 := load_lanes hd1 hsh1 hx1 (B := B) (q := 1) (by decide) (by simp)
  have ey1 := load_y hy1 ex1 (by decide) (by decide)
  clear hd1 hsh1 hx1 hy1
  subst ex1 ey1
  step_pure
  step_store
  step_pure
  step_load with d2 hd2 consuming hq2
  step_pure with sh2 hsh2
  step_pure with x2 hx2
  step_pure with y2 hy2
  have ex2 := load_lanes hd2 hsh2 hx2 (B := B) (q := 2) (by decide) (by simp)
  have ey2 := load_y hy2 ex2 (by decide) (by decide)
  clear hd2 hsh2 hx2 hy2
  subst ex2 ey2
  step_pure
  step_store
  step_pure
  step_load with d3 hd3 consuming hq3
  step_pure with sh3 hsh3
  step_pure with x3 hx3
  step_pure with y3 hy3
  have ex3 := load_lanes hd3 hsh3 hx3 (B := B) (q := 3) (by decide) (by simp)
  have ey3 := load_y hy3 ex3 (by decide) (by decide)
  clear hd3 hsh3 hx3 hy3
  subst ex3 ey3
  step_pure
  step_store
  step_pure
  step_load with d4 hd4 consuming hq4
  step_pure with sh4 hsh4
  step_pure with x4 hx4
  step_pure with y4 hy4
  have ex4 := load_lanes hd4 hsh4 hx4 (B := B) (q := 4) (by decide) (by simp)
  have ey4 := load_y hy4 ex4 (by decide) (by decide)
  clear hd4 hsh4 hx4 hy4
  subst ex4 ey4
  step_pure
  step_store
  step_pure
  step_load with d5 hd5 consuming hq5
  step_pure with sh5 hsh5
  step_pure with x5 hx5
  step_pure with y5 hy5
  have ex5 := load_lanes hd5 hsh5 hx5 (B := B) (q := 5) (by decide) (by simp)
  have ey5 := load_y hy5 ex5 (by decide) (by decide)
  clear hd5 hsh5 hx5 hy5
  subst ex5 ey5
  step_pure
  step_store
  step_pure
  step_load with d6 hd6 consuming hq6
  step_pure with sh6 hsh6
  step_pure with x6 hx6
  step_pure with y6 hy6
  have ex6 := load_lanes hd6 hsh6 hx6 (B := B) (q := 6) (by decide) (by simp)
  have ey6 := load_y hy6 ex6 (by decide) (by decide)
  clear hd6 hsh6 hx6 hy6
  subst ex6 ey6
  step_pure
  step_store
  step_pure
  step_load with d7 hd7 consuming hq7
  step_pure with sh7 hsh7
  step_pure with x7 hx7
  step_pure with y7 hy7
  have ex7 := load_lanes hd7 hsh7 hx7 (B := B) (q := 7) (by decide) (by simp)
  have ey7 := load_y hy7 ex7 (by decide) (by decide)
  clear hd7 hsh7 hx7 hy7
  subst ex7 ey7
  step_pure
  step_store
  -- the rounds
  finish_block
  block_init
  finish_block
  have hmem : S.mem = pairsMem ms (bsched B) 0 8 (S₀.mem.lifetimeStart ms) := by
    rw [hS]; simp [pairsMem]
  have hF :=
    fits_slots hmo hfits_ms hfits_ms_16 hfits_ms_32 hfits_ms_48 hfits_ms_64 hfits_ms_80 hfits_ms_96
      hfits_ms_112
  have hR : HoldsR S.mem ms (bsched B) 0 16 := by
    have :=
      HoldsR.pairsMem (W := bsched B) (p := 0) (n := 8) (lo := 0) hmo
        (InBounds.pairsMem_iff.1 (hmem ▸ hms)) (Nat.le_refl _) (by decide)
        (fun _ _ h => absurd h (Nat.not_lt_zero _))
    rw [hmem]; simpa using this
  clear hfits_ms hfits_ms_16 hfits_ms_32 hfits_ms_48 hfits_ms_64 hfits_ms_80 hfits_ms_96
    hfits_ms_112 hread_ms hread_ms_16 hread_ms_32 hread_ms_48 hread_ms_64 hread_ms_80 hread_ms_96
    hread_ms_112 hq0f hq1f hq2f hq3f hq4f hq5f hq6f hq7f
  have L := loop5 st Kp ms t2 ms2 H (bsched B) H g K hmo hKo hms_K (sched_bsched B) 31 0
  simp only [Nat.mul_zero, Nat.zero_add, rounds_zero, Nat.zero_div, Nat.zero_mod] at L
  step_loop using L
  intro hL
  clear L
  have hR6 : HoldsR S.mem ms (bsched B) 64 80 := by
    have :=
      HoldsR.pairsMem (W := bsched B) (p := 8) (n := 32) (lo := 0) hmo
        (InBounds.pairsMem_iff.1 (hS ▸ hms)) (by decide) (by decide) hR
    rw [hS]; simpa using this
  clear hR
  step_loop using loop6 st Kp ms t2 ms2 H (bsched B) H S g K hmo hF hR6 15 64
  intro hL
  clear hK hR6 hKf hF
  -- accumulate_state(state, &current_state);
  block_init
  step_pure [rounds_add H B (show 0 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 1 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 2 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 3 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 4 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 5 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 6 < 8 by decide)]
  step_store
  step_pure [rounds_add H B (show 7 < 8 by decide)]
  step_store
  step_lifetime
  have e40 :=
    pairsMem_add (X := ms) (W := bsched B) (mem := S₀.mem.lifetimeStart ms) (p := 0) (n := 8) (n' :=
      32)
  simp only [Nat.zero_add, Nat.reduceAdd] at e40 hmem
  replace hS :
    S =
      { S₀ with
        mem :=
          (storeWords (pairsMem ms (bsched B) 0 40 (S₀.mem.lifetimeStart ms)) st
                (Sha512.compress H (bytesLE B))).lifetimeEnd
            ms } := by
    rw [hS, ← e40, ← hmem]; rfl
  clear e40 hmem
  finish_block
  step_loop using hK'

end Proof

end MLIR.Agave.Avx2.compress512

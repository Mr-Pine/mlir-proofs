module

public import Agave.Avx2.compress512.Loop2

/-! `compress512`'s two-block path: one iteration of the loop over block pairs `^bb9` (both
blocks' loads, the loops, the sums `^bb14`, `^bb16`), and the loop. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

@[expose] public section

/-- `^bb9` at block `i`, `c` pairs left, on the state words `H`. -/
abbrev hdr9 (H : Vector (BitVec 64) 8) (i c : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 355 := H[7], rir_dst% compress512.hty 356 := H[6],
    rir_dst% compress512.hty 357 := H[5], rir_dst% compress512.hty 358 := H[4],
    rir_dst% compress512.hty 359 := H[3], rir_dst% compress512.hty 360 := H[2],
    rir_dst% compress512.hty 361 := H[1], rir_dst% compress512.hty 362 := H[0],
    rir_dst% compress512.hty 363 := BitVec.ofNat 64 i, rir_dst% compress512.hty 364 :=
    BitVec.ofNat 64 c]

/-- `^bb17` on the state words `H` after the last pair. -/
abbrev exit17 (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 703 := H[0], rir_dst% compress512.hty 704 := H[1],
    rir_dst% compress512.hty 705 := H[2], rir_dst% compress512.hty 706 := H[3],
    rir_dst% compress512.hty 707 := H[4], rir_dst% compress512.hty 708 := H[5],
    rir_dst% compress512.hty 709 := H[6], rir_dst% compress512.hty 710 := H[7]]

/-- `^bb11` entered from `^bb9`: group `1`, the pairs `0 … 7` of both blocks' schedules `W₀`,
`W₁`, and the working variables `H`. -/
abbrev hdr11 (W₀ W₁ : Nat → BitVec 64) (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 472 := 16#64, rir_dst% compress512.hty 473 := 1#64,
    rir_dst% compress512.hty 474 := xq W₀ W₁ 1, rir_dst% compress512.hty 475 := xq W₀ W₁ 0,
    rir_dst% compress512.hty 476 := xq W₀ W₁ 5, rir_dst% compress512.hty 477 := xq W₀ W₁ 4,
    rir_dst% compress512.hty 478 := xq W₀ W₁ 7, rir_dst% compress512.hty 479 := xq W₀ W₁ 2,
    rir_dst% compress512.hty 480 := xq W₀ W₁ 3, rir_dst% compress512.hty 481 := xq W₀ W₁ 6,
    rir_dst% compress512.hty 482 := H[7], rir_dst% compress512.hty 483 := H[4],
    rir_dst% compress512.hty 484 := H[6], rir_dst% compress512.hty 485 := H[5],
    rir_dst% compress512.hty 486 := H[0], rir_dst% compress512.hty 487 := H[1],
    rir_dst% compress512.hty 488 := H[2], rir_dst% compress512.hty 489 := H[3]]

/-- Two blocks' compression from `H`, the blocks the 2048 bits `X`, the first lowest. -/
def compress2 (H : Vector (BitVec 64) 8) (X : BitVec 2048) : Vector (BitVec 64) 8 :=
  Sha512.compress (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
    (bytesLE (X.extractLsb' 1024 1024))

end

@[expose] public section

/-- The pairs' buffers after `c` iterations from block `i` of the blocks `D`. -/
def pairsLoop (ms2 t2 : Pointer) (D : BitVec w) : (i c : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, c + 1, m =>
    pairsLoop ms2 t2 D (i + 2) c
      (pairMem2 ms2 t2 (bsched ((D.extractLsb' (1024 * i) 2048).extractLsb' 0 1024))
        (bsched ((D.extractLsb' (1024 * i) 2048).extractLsb' 1024 1024)) 0 40 m)

end

section Proof

variable {ms2 t2 q : Pointer} {w v i c : Nat} {D : BitVec w}

public theorem pairsLoop_succ {m : MemoryState} :
    pairsLoop ms2 t2 D i (c + 1) m =
      pairsLoop ms2 t2 D (i + 2) c
        (pairMem2 ms2 t2 (bsched ((D.extractLsb' (1024 * i) 2048).extractLsb' 0 1024))
          (bsched ((D.extractLsb' (1024 * i) 2048).extractLsb' 1024 1024)) 0 40 m) :=
  rfl

@[mlir_transport]
public theorem Fits.pairsLoop {m : MemoryState} (h : Fits m q v) :
    Fits (pairsLoop ms2 t2 D i c m) q v := by
  induction c generalizing i m with
  | zero => exact h
  | succ c ih => exact ih (Fits.tMem (Fits.pairsMem h))

@[mlir_transport]
public theorem Room.pairsLoop {m : MemoryState} (h : Room m q v) :
    Room (pairsLoop ms2 t2 D i c m) q v := by
  induction c generalizing i m with
  | zero => exact h
  | succ c ih => exact ih (Room.tMem (Room.pairsMem h))

@[mlir_transport]
public theorem InBounds.pairsLoop {m : MemoryState} (h : InBounds m q v) :
    InBounds (pairsLoop ms2 t2 D i c m) q v := by
  induction c generalizing i m with
  | zero => exact h
  | succ c ih => exact ih (InBounds.tMem (InBounds.pairsMem h))

@[mlir_transport]
public theorem MemoryState.Sha512Fit.pairsLoop {m : MemoryState} (h : m.Sha512Fit q) :
    (pairsLoop ms2 t2 D i c m).Sha512Fit q := by
  induction c generalizing i m with
  | zero => exact h
  | succ c ih => exact ih (MemoryState.Sha512Fit.tMem (MemoryState.Sha512Fit.pairsMem h))

@[mlir_read]
public theorem readAt_pairsLoop_of_id_ne {m : MemoryState} (h1 : ms2.id ≠ q.id)
    (h2 : t2.id ≠ q.id) : (pairsLoop ms2 t2 D i c m).readAt q v = m.readAt q v := by
  induction c generalizing i m with
  | zero => rfl
  | succ c ih => rw [pairsLoop_succ, ih, readAt_tMem_of_id_ne h2, readAt_pairsMem_of_id_ne h1]

@[mlir_frame, mlir_erase]
public theorem eraseFrom_pairsLoop_of_le {m : MemoryState} (h1 : B ≤ ms2.id.id)
    (h2 : B ≤ t2.id.id) : (pairsLoop ms2 t2 D i c m).eraseFrom B = m.eraseFrom B := by
  induction c generalizing i m with
  | zero => rfl
  | succ c ih => rw [pairsLoop_succ, ih, eraseFrom_tMem_of_le h2, eraseFrom_pairsMem_of_le h1]

public theorem KPairs.pairsLoop {m : MemoryState} {Kp : Pointer} (h : KPairs m Kp)
    (h1 : ms2.id ≠ Kp.id) (h2 : t2.id ≠ Kp.id) : KPairs (pairsLoop ms2 t2 D i c m) Kp := fun k hk =>
  by
  rw [readAt_pairsLoop_of_id_ne (by simpa using h1) (by simpa using h2)]
  exact h k hk

/-- The bytes from block `j` on: block `j`'s, then those from `j + 1`. -/
public theorem compressBlocks_drop {N j : Nat} (D : BitVec (1024 * N)) (hj : j < N)
    (H : Vector (BitVec 64) 8) :
    Sha512.compressBlocks H ((bytesLE D).drop (128 * j)) =
      Sha512.compressBlocks (Sha512.compress H (bytesLE (D.extractLsb' (1024 * j) 1024)))
        ((bytesLE D).drop (128 * (j + 1))) := by
  rw [Sha512.compressBlocks_of_le
      (by
        simp; omega),
    List.drop_drop, bytesLE_extractLsb' D (by omega) (by decide) (by omega)]
  simp only [show 1024 * j / 8 = 128 * j by omega, show 1024 / 8 = 128 by rfl,
    show 128 * j + 128 = 128 * (j + 1) by omega]

/-- No bytes after the last block. -/
public theorem compressBlocks_drop_all {N : Nat} (D : BitVec (1024 * N))
    (H : Vector (BitVec 64) 8) : Sha512.compressBlocks H ((bytesLE D).drop (128 * N)) = H :=
  Sha512.compressBlocks_of_lt
    (by
      simp; omega)

/-- The bytes from block `i` on: blocks `i`, `i + 1` compressed, then those from `i + 2`. -/
public theorem compressBlocks_drop2 {N i : Nat} (D : BitVec (1024 * N)) (hi : i + 2 ≤ N)
    (H : Vector (BitVec 64) 8) :
    Sha512.compressBlocks H ((bytesLE D).drop (128 * i)) =
      Sha512.compressBlocks (compress2 H (D.extractLsb' (1024 * i) 2048))
        ((bytesLE D).drop (128 * (i + 2))) := by
  rw [compressBlocks_drop D (by omega), compressBlocks_drop D (by omega), compress2,
    ext_ext _ (by decide), ext_ext _ (by decide)]
  simp only [Nat.add_zero, show 1024 * i + 1024 = 1024 * (i + 1) by omega, Nat.add_assoc]

attribute [local mlir_transport] KPairs.storeAt KPairs.lifetimeStart KPairs.lifetimeEnd
  KPairs.pairsMem KPairs.tMem

-- `^bb9`'s 104 steps, eight lane lemmas over 256-bit byte swaps
set_option maxHeartbeats 1000000 in
/-- `^bb9`'s `load_data_avx2` on the block pair at `P`: both blocks' first eight schedule pairs
stored into `ms2` and `t2`; then `^bb11`. -/
theorem load2 (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (H : Vector (BitVec 64) 8)
    (i c : Nat) (P : Pointer) (X : BitVec 2048) (S₀ : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (compress512.args (.value st) (.value blocks) (.value n)).get) (hC : Consts E)
    (hP : Ptrs Kp ms t2 ms2 E) (hP8 : Ptr8 st ms2 t2 E) (hi : i * 128 < 2 ^ 63)
    (hov : blocks.offset.toNat + i * 128 < 2 ^ 64)
    (hPe : blocks.add (BitVec.ofNat 64 (i * 128)) = P) (hPo : ¬P.offset.uaddOverflow 256#64)
    (hf : Fits S₀.mem P 2048) (hX : S₀.mem.readAt P 2048 = X) (hms2 : Room S₀.mem ms2 1024)
    (ht2 : Room S₀.mem t2 5120) (hmo : ms2.offset = 0) (hto : t2.offset = 0) (hne3 : t2.id ≠ ms2.id)
    (hPm : P.id ≠ ms2.id) (hPt : P.id ≠ t2.id)
    (hK' :
      ∀ E' : ⟪Γ⟫,
        E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
          Live2 st Kp ms t2 ms2 H i c E' →
          (compress512.runFrom
                (hdr11 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) H E') 11
                { S₀ with
                  mem :=
                    pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024))
                      (bsched (X.extractLsb' 1024 1024)) 0 8 S₀.mem } >>=
              g) =
            K) :
    (compress512.runFrom (hdr9 H i c E) 9 S₀ >>= g) = K := by
  block_init
  -- load_data_avx2(&mut x, &mut ms, &mut t2, blocks.as_ptr().add(i).cast());
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), hPe]
  step_pure
  step_load with hi0 hhi0
  step_load with lo0 hlo0
  step_pure with c0 hc0
  step_pure with b0 hb0
  step_pure with s0 hs0
  step_pure with x0 hx0
  step_pure with y0 hy0
  have ex0 :=
    load_lanes4 hlo0 hhi0 hc0 hb0 hs0 hx0 (X := X) (q := 0) (by decide)
      (by simp [BitVec.setWidth_eq_extractLsb']) rfl
  step_pure with l0 hl0
  have el0 := load_ylo hy0 ex0 (by decide) (by decide) hl0
  clear hl0
  subst el0
  step_store
  step_pure with u0 hu0
  have eu0 := load_yhi hy0 ex0 (by decide) (by decide) hu0
  clear hu0 hy0 hlo0 hhi0 hc0 hb0 hs0 hx0
  subst eu0 ex0
  step_store
  step_pure
  step_load with hi1 hhi1
  step_pure
  step_load with lo1 hlo1
  step_pure with c1 hc1
  step_pure with b1 hb1
  step_pure with s1 hs1
  step_pure with x1 hx1
  step_pure with y1 hy1
  have ex1 := load_lanes4 hlo1 hhi1 hc1 hb1 hs1 hx1 (X := X) (q := 1) (by decide) rfl rfl
  step_pure with l1 hl1
  have el1 := load_ylo hy1 ex1 (by decide) (by decide) hl1
  clear hl1
  subst el1
  step_store
  step_pure with u1 hu1
  have eu1 := load_yhi hy1 ex1 (by decide) (by decide) hu1
  clear hu1 hy1 hlo1 hhi1 hc1 hb1 hs1 hx1
  subst eu1 ex1
  step_store
  step_pure
  step_load with hi2 hhi2
  step_pure
  step_load with lo2 hlo2
  step_pure with c2 hc2
  step_pure with b2 hb2
  step_pure with s2 hs2
  step_pure with x2 hx2
  step_pure with y2 hy2
  have ex2 := load_lanes4 hlo2 hhi2 hc2 hb2 hs2 hx2 (X := X) (q := 2) (by decide) rfl rfl
  step_pure with l2 hl2
  have el2 := load_ylo hy2 ex2 (by decide) (by decide) hl2
  clear hl2
  subst el2
  step_store
  step_pure with u2 hu2
  have eu2 := load_yhi hy2 ex2 (by decide) (by decide) hu2
  clear hu2 hy2 hlo2 hhi2 hc2 hb2 hs2 hx2
  subst eu2 ex2
  step_store
  step_pure
  step_load with hi3 hhi3
  step_pure
  step_load with lo3 hlo3
  step_pure with c3 hc3
  step_pure with b3 hb3
  step_pure with s3 hs3
  step_pure with x3 hx3
  step_pure with y3 hy3
  have ex3 := load_lanes4 hlo3 hhi3 hc3 hb3 hs3 hx3 (X := X) (q := 3) (by decide) rfl rfl
  step_pure with l3 hl3
  have el3 := load_ylo hy3 ex3 (by decide) (by decide) hl3
  clear hl3
  subst el3
  step_store
  step_pure with u3 hu3
  have eu3 := load_yhi hy3 ex3 (by decide) (by decide) hu3
  clear hu3 hy3 hlo3 hhi3 hc3 hb3 hs3 hx3
  subst eu3 ex3
  step_store
  step_pure
  step_load with hi4 hhi4
  step_pure
  step_load with lo4 hlo4
  step_pure with c4 hc4
  step_pure with b4 hb4
  step_pure with s4 hs4
  step_pure with x4 hx4
  step_pure with y4 hy4
  have ex4 := load_lanes4 hlo4 hhi4 hc4 hb4 hs4 hx4 (X := X) (q := 4) (by decide) rfl rfl
  step_pure with l4 hl4
  have el4 := load_ylo hy4 ex4 (by decide) (by decide) hl4
  clear hl4
  subst el4
  step_store
  step_pure with u4 hu4
  have eu4 := load_yhi hy4 ex4 (by decide) (by decide) hu4
  clear hu4 hy4 hlo4 hhi4 hc4 hb4 hs4 hx4
  subst eu4 ex4
  step_store
  step_pure
  step_load with hi5 hhi5
  step_pure
  step_load with lo5 hlo5
  step_pure with c5 hc5
  step_pure with b5 hb5
  step_pure with s5 hs5
  step_pure with x5 hx5
  step_pure with y5 hy5
  have ex5 := load_lanes4 hlo5 hhi5 hc5 hb5 hs5 hx5 (X := X) (q := 5) (by decide) rfl rfl
  step_pure with l5 hl5
  have el5 := load_ylo hy5 ex5 (by decide) (by decide) hl5
  clear hl5
  subst el5
  step_store
  step_pure with u5 hu5
  have eu5 := load_yhi hy5 ex5 (by decide) (by decide) hu5
  clear hu5 hy5 hlo5 hhi5 hc5 hb5 hs5 hx5
  subst eu5 ex5
  step_store
  step_pure
  step_load with hi6 hhi6
  step_pure
  step_load with lo6 hlo6
  step_pure with c6 hc6
  step_pure with b6 hb6
  step_pure with s6 hs6
  step_pure with x6 hx6
  step_pure with y6 hy6
  have ex6 := load_lanes4 hlo6 hhi6 hc6 hb6 hs6 hx6 (X := X) (q := 6) (by decide) rfl rfl
  step_pure with l6 hl6
  have el6 := load_ylo hy6 ex6 (by decide) (by decide) hl6
  clear hl6
  subst el6
  step_store
  step_pure with u6 hu6
  have eu6 := load_yhi hy6 ex6 (by decide) (by decide) hu6
  clear hu6 hy6 hlo6 hhi6 hc6 hb6 hs6 hx6
  subst eu6 ex6
  step_store
  step_pure
  step_load with hi7 hhi7
  step_pure
  step_load with lo7 hlo7
  step_pure with c7 hc7
  step_pure with b7 hb7
  step_pure with s7 hs7
  step_pure with x7 hx7
  step_pure with y7 hy7
  have ex7 := load_lanes4 hlo7 hhi7 hc7 hb7 hs7 hx7 (X := X) (q := 7) (by decide) rfl rfl
  step_pure with l7 hl7
  have el7 := load_ylo hy7 ex7 (by decide) (by decide) hl7
  clear hl7
  subst el7
  step_store
  step_pure with u7 hu7
  have eu7 := load_yhi hy7 ex7 (by decide) (by decide) hu7
  clear hu7 hy7 hlo7 hhi7 hc7 hb7 hs7 hx7
  subst eu7 ex7
  step_store
  replace hS :
    S =
      { S₀ with
        mem :=
          pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) 0 8
            S₀.mem } := by
    rw [hS]
    simp only [pairMem2_succ hne3]
    simp only [pairMem2, tMem, pairsMem]
    simp
  finish_block
  step_loop using hK'

-- three loop lemmas, sixteen sums and their states' facts
set_option maxHeartbeats 1000000 in
/-- A block pair from `^bb11`: the schedules' later pairs stored, the first block's rounds and
sums (`^bb14`), the second's from `t2` and sums (`^bb16`); then the next pair or `^bb17`. -/
theorem rest2 (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (H : Vector (BitVec 64) 8)
    (i r : Nat) (X : BitVec 2048) (M : MemoryState) (S₀ : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (compress512.args (.value st) (.value blocks) (.value n)).get)
    (hL : Live2 st Kp ms t2 ms2 H i (r + 1) E) (hr : r + 1 < 2 ^ 63)
    (hmem :
      S₀.mem =
        pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) 0 8 M)
    (hms2 : Room M ms2 1024) (ht2 : Room M t2 5120) (hmo : ms2.offset = 0) (hto : t2.offset = 0)
    (hKo : Kp.offset = 0) (hKf : Fits S₀.mem Kp 5120) (hK : KPairs S₀.mem Kp)
    (hne1 : ms2.id ≠ Kp.id) (hne2 : t2.id ≠ Kp.id) (hne3 : t2.id ≠ ms2.id)
    (hnext :
      0 < r →
        ∀ E' : ⟪Γ⟫,
          E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
            Consts E' →
            Ptrs Kp ms t2 ms2 E' →
            Ptr8 st ms2 t2 E' →
            (compress512.runFrom (hdr9 (compress2 H X) (i + 2) r E') 9
                  { S₀ with
                    mem :=
                      pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024))
                        (bsched (X.extractLsb' 1024 1024)) 8 32 S₀.mem } >>=
                g) =
              K)
    (hdone :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
            Consts E' →
            Ptrs Kp ms t2 ms2 E' →
            Ptr8 st ms2 t2 E' →
            (compress512.runFrom (exit17 (compress2 H X) E') 17
                  { S₀ with
                    mem :=
                      pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024))
                        (bsched (X.extractLsb' 1024 1024)) 8 32 S₀.mem } >>=
                g) =
              K) :
    (compress512.runFrom
          (hdr11 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) H E) 11 S₀ >>=
        g) =
      K := by
  have e40 :=
    pairMem2_add (ms2 := ms2) (t2 := t2) (W₀ := bsched (X.extractLsb' 0 1024)) (W₁ :=
      bsched (X.extractLsb' 1024 1024)) (mem := M) hne3 (p := 0) (n := 8) (n' := 32)
  simp only [Nat.zero_add, Nat.reduceAdd] at e40
  have hF : Fits S₀.mem ms2 1024 := by
    rw [hmem]; exact Fits.tMem (fits_pairsMem hmo hms2 7 (by decide))
  have hR : HoldsR S₀.mem ms2 (bsched (X.extractLsb' 0 1024)) 0 16 := by
    rw [hmem]
    have :=
      HoldsR.pairsMem (W := bsched (X.extractLsb' 0 1024)) (p := 0) (n := 8) (lo := 0) hmo
        hms2.inBounds (Nat.le_refl _) (by decide) (fun _ _ h => absurd h (Nat.not_lt_zero _))
    exact HoldsR.tMem (by simpa using this) hne3
  have hR6 :
    HoldsR
      (pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) 8 32
        S₀.mem)
      ms2 (bsched (X.extractLsb' 0 1024)) 64 80 := by
    rw [hmem, e40]
    have :=
      HoldsR.pairsMem (W := bsched (X.extractLsb' 0 1024)) (p := 0) (n := 40) (lo := 0) (mem := M)
        hmo hms2.inBounds (Nat.le_refl _) (by decide) (fun _ _ h => absurd h (Nat.not_lt_zero _))
    exact HoldsR.tMem (by simpa using this) hne3
  have hT :
    HoldsT
      (pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) 8 32
        S₀.mem)
      t2 (bsched (X.extractLsb' 1024 1024)) 80 := by
    rw [hmem, e40]
    exact
      HoldsT.tMem hto (InBounds.pairsMem ht2.inBounds) (p := 0) (n := 40) (by decide)
        (fun _ h => absurd h (Nat.not_lt_zero _))
  have hFt :
    Fits
      (pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) 8 32
        S₀.mem)
      t2 5120 := by
    rw [hmem, e40]; exact fits_tMem hto (Room.pairsMem ht2) 39 (by decide)
  have hrt : Room S₀.mem t2 5120 := by
    rw [hmem]; exact Room.tMem (Room.pairsMem ht2)
  clear e40
  block_init
  -- t2[8 * i + j] = …: the group's offset into `t2`
  step_pure [ofNat_shiftLeft, ofNat_mul_ushiftRight (show 1 * 2 ^ 7 < 2 ^ 64 by decide),
    ofNat_mul_sshiftRight (show 1 * 2 ^ 7 < 2 ^ 63 by decide)]
  step_pure [gepDyn_slot hto (show 1 * 128 * 1 < 2 ^ 63 by decide) (by decide)]
  finish_block
  have L :=
    loop12 st Kp ms t2 ms2 H i (r + 1) (bsched (X.extractLsb' 0 1024))
      (bsched (X.extractLsb' 1024 1024)) H g K hmo hto hKo hne1 hne2 hne3 (sched_bsched _)
      (sched_bsched _) 31 0
  simp only [Nat.mul_zero, Nat.zero_add, rounds_zero, Nat.zero_div, Nat.zero_mod] at L
  step_loop using L
  intro hL
  clear L
  -- rounds_64_79(&mut current_state, &ms);
  step_loop using
    loop13 st Kp ms t2 ms2 H i (r + 1) (bsched (X.extractLsb' 0 1024)) H S g K hmo hF
      (by
        rw [hS]; exact hR6)
      15 64
  intro hL
  -- accumulate_state(state, &current_state);
  block_init
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 0 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 1 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 2 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 3 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 4 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 5 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 6 < 8 by decide)]
  step_pure [rounds_add H (X.extractLsb' 0 1024) (show 7 < 8 by decide)]
  finish_block
  -- process_second_block(&mut current_state, &t2);
  have L :=
    loop15 st Kp ms t2 ms2 H (Sha512.compress H (bytesLE (X.extractLsb' 0 1024))) i (r + 1)
      (bsched (X.extractLsb' 1024 1024)) (Sha512.compress H (bytesLE (X.extractLsb' 0 1024))) S g K
      hto
      (by
        rw [hS]; exact hFt)
      (by
        rw [hS]; exact hT)
      79 0
  simp only [Nat.zero_add, rounds_zero] at L
  step_loop using L
  intro hL hA
  clear L
  -- accumulate_state(state, &current_state);
  block_init
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 0 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 1 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 2 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 3 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 4 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 5 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 6 < 8 by decide)]
  step_pure [rounds_add (Sha512.compress H (bytesLE (X.extractLsb' 0 1024)))
        (X.extractLsb' 1024 1024) (show 7 < 8 by decide)]
  step_pure [← BitVec.ofNat_add]
  step_pure [ofNat_add_neg_one]
  step_pure
  finish_block
  · step_loop using hdone (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hnext
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- One block pair (`compress`'s loop body): both blocks' schedules stored in `ms2`, `t2`, the
first block's rounds and sums, the second's; then the next pair, or after the last `^bb17`. -/
theorem pair_iter (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (H : Vector (BitVec 64) 8)
    (i r : Nat) (P : Pointer) (X : BitVec 2048) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (compress512.args (.value st) (.value blocks) (.value n)).get) (hC : Consts E)
    (hP : Ptrs Kp ms t2 ms2 E) (hP8 : Ptr8 st ms2 t2 E) (hr : r + 1 < 2 ^ 63)
    (hi : i * 128 < 2 ^ 63) (hov : blocks.offset.toNat + i * 128 < 2 ^ 64)
    (hPe : blocks.add (BitVec.ofNat 64 (i * 128)) = P) (hPo : ¬P.offset.uaddOverflow 256#64)
    (hf : Fits S.mem P 2048) (hX : S.mem.readAt P 2048 = X) (hms2 : Room S.mem ms2 1024)
    (ht2 : Room S.mem t2 5120) (hmo : ms2.offset = 0) (hto : t2.offset = 0) (hKo : Kp.offset = 0)
    (hKf : Fits S.mem Kp 5120) (hK : KPairs S.mem Kp) (hne1 : ms2.id ≠ Kp.id) (hne2 : t2.id ≠ Kp.id)
    (hne3 : t2.id ≠ ms2.id) (hPm : P.id ≠ ms2.id) (hPt : P.id ≠ t2.id)
    (hnext :
      0 < r →
        ∀ E' : ⟪Γ⟫,
          E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
            Consts E' →
            Ptrs Kp ms t2 ms2 E' →
            Ptr8 st ms2 t2 E' →
            (compress512.runFrom (hdr9 (compress2 H X) (i + 2) r E') 9
                  { S with
                    mem :=
                      pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024))
                        (bsched (X.extractLsb' 1024 1024)) 0 40 S.mem } >>=
                g) =
              K)
    (hdone :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
            Consts E' →
            Ptrs Kp ms t2 ms2 E' →
            Ptr8 st ms2 t2 E' →
            (compress512.runFrom (exit17 (compress2 H X) E') 17
                  { S with
                    mem :=
                      pairMem2 ms2 t2 (bsched (X.extractLsb' 0 1024))
                        (bsched (X.extractLsb' 1024 1024)) 0 40 S.mem } >>=
                g) =
              K) :
    (compress512.runFrom (hdr9 H i (r + 1) E) 9 S >>= g) = K := by
  have e40 :=
    pairMem2_add (ms2 := ms2) (t2 := t2) (W₀ := bsched (X.extractLsb' 0 1024)) (W₁ :=
      bsched (X.extractLsb' 1024 1024)) (mem := S.mem) hne3 (p := 0) (n := 8) (n' := 32)
  simp only [Nat.zero_add, Nat.reduceAdd] at e40
  refine
    load2 st blocks Kp ms t2 ms2 n H i (r + 1) P X S E g K hArgs hC hP hP8 hi hov hPe hPo hf hX hms2
      ht2 hmo hto hne3 hPm hPt fun E' hA hL => ?_
  refine
    rest2 st blocks Kp ms t2 ms2 n H i r X S.mem _ E' g K hA hL hr rfl hms2 ht2 hmo hto hKo
      (Fits.tMem (Fits.pairsMem hKf)) (KPairs.tMem (KPairs.pairsMem hK hne1) hne2) hne1 hne2 hne3
      (fun h E'' a b c d => ?_) (fun h E'' a b c d => ?_)
  · have := hnext h E'' a b c d
    rw [← e40] at this
    exact this
  · have := hdone h E'' a b c d
    rw [← e40] at this
    exact this

/-- Pairs `i …` of the `N` blocks `D` at `blocks`, `r + 1` pairs left, from the state words `H`:
each pair's schedules stored (`pairsLoop`), then `^bb17` with the words `compressBlocks` leaves. -/
public theorem loop9 (st blocks Kp ms t2 ms2 : Pointer) (n : BitVec 64) (N : Nat)
    (D : BitVec (1024 * N)) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hmo : ms2.offset = 0) (hto : t2.offset = 0) (hKo : Kp.offset = 0) (hne1 : ms2.id ≠ Kp.id)
    (hne2 : t2.id ≠ Kp.id) (hne3 : t2.id ≠ ms2.id) (hbm : blocks.id ≠ ms2.id)
    (hbt : blocks.id ≠ t2.id) (hN : N < 2 ^ 56) (hdo : blocks.offset.toNat + 128 * N < 2 ^ 64) :
    ∀ r i (H : Vector (BitVec 64) 8) (S : GlobalState) (E : ⟪Γ⟫),
      i + 2 * (r + 1) = N →
        E.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
        Consts E →
        Ptrs Kp ms t2 ms2 E →
        Ptr8 st ms2 t2 E →
        Fits S.mem blocks (1024 * N) →
        S.mem.readAt blocks (1024 * N) = D →
        Room S.mem ms2 1024 →
        Room S.mem t2 5120 →
        Fits S.mem Kp 5120 →
        KPairs S.mem Kp →
        (∀ E' : ⟪Γ⟫,
          E'.args = (compress512.args (.value st) (.value blocks) (.value n)).get →
            Consts E' →
            Ptrs Kp ms t2 ms2 E' →
            Ptr8 st ms2 t2 E' →
            (compress512.runFrom (exit17 (Sha512.compressBlocks H ((bytesLE D).drop (128 * i))) E')
                  17 { S with mem := pairsLoop ms2 t2 D i (r + 1) S.mem } >>=
                g) =
              K) →
        (compress512.runFrom (hdr9 H i (r + 1) E) 9 S >>= g) = K := by
  intro r
  induction r with
  | zero =>
    intro i H S E hi hA hC hP hP8 hB hBr hms2 ht2 hKf hK hcont
    have hov : ¬blocks.offset.uaddOverflow (BitVec.ofNat 64 (i * 128)) := by
      simp [BitVec.uaddOverflow]; omega
    refine
      pair_iter st blocks Kp ms t2 ms2 n H i 0 (blocks.add (BitVec.ofNat 64 (i * 128)))
        (D.extractLsb' (1024 * i) 2048) S E g K hA hC hP hP8 (by omega) (by omega) (by omega) rfl
        (by
          simp [BitVec.uaddOverflow, Pointer.add]; omega)
        (Fits.add_of_le hov
          (by
            simp; omega)
          hB)
        ?_ hms2 ht2 hmo hto hKo hKf hK hne1 hne2 hne3 (by simpa using hbm) (by simpa using hbt)
        (fun h => (Nat.lt_irrefl 0 h).elim) (fun _ E' a b c d => ?_)
    · rw [MemoryState.readAt_add_of_readAt hB.inBounds hov
          (by
            simp; omega)
          hBr]
      congr 1
      simp; omega
    · have := hcont E' a b c d
      rw [compressBlocks_drop2 D (by omega), show i + 2 = N by omega,
        compressBlocks_drop_all] at this
      exact this
  | succ r ih =>
    intro i H S E hi hA hC hP hP8 hB hBr hms2 ht2 hKf hK hcont
    have hov : ¬blocks.offset.uaddOverflow (BitVec.ofNat 64 (i * 128)) := by
      simp [BitVec.uaddOverflow]; omega
    refine
      pair_iter st blocks Kp ms t2 ms2 n H i (r + 1) (blocks.add (BitVec.ofNat 64 (i * 128)))
        (D.extractLsb' (1024 * i) 2048) S E g K hA hC hP hP8 (by omega) (by omega) (by omega) rfl
        (by
          simp [BitVec.uaddOverflow, Pointer.add]; omega)
        (Fits.add_of_le hov
          (by
            simp; omega)
          hB)
        ?_ hms2 ht2 hmo hto hKo hKf hK hne1 hne2 hne3 (by simpa using hbm) (by simpa using hbt)
        (fun _ E' a b c d => ?_) (fun h => (Nat.succ_ne_zero r h).elim)
    · rw [MemoryState.readAt_add_of_readAt hB.inBounds hov
          (by
            simp; omega)
          hBr]
      congr 1
      simp; omega
    · refine
        ih (i + 2) _ _ E' (by omega) a b c d (Fits.tMem (Fits.pairsMem hB)) ?_
          (Room.tMem (Room.pairsMem hms2)) (Room.tMem (Room.pairsMem ht2))
          (Fits.tMem (Fits.pairsMem hKf)) (KPairs.tMem (KPairs.pairsMem hK hne1) hne2)
          (fun E'' a' b' c' d' => ?_)
      · rw [readAt_tMem_of_id_ne (by simpa using hbt.symm),
          readAt_pairsMem_of_id_ne (by simpa using hbm.symm)]
        exact hBr
      · have := hcont E'' a' b' c' d'
        rw [compressBlocks_drop2 D (by omega), pairsLoop_succ] at this
        exact this

end Proof

end MLIR.Agave.Avx2.compress512

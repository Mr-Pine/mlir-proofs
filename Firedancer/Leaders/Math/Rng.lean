module

public import Firedancer.Leaders.Math.Chacha

/-! Both RNG buffer state machines read the ChaCha20 keystream `u64` by `u64` from position 0. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## Counter rows -/

theorem toNat_append' {m n : Nat} (x : BitVec m) (y : BitVec n) :
    (x ++ y).toNat = x.toNat * 2 ^ n + y.toNat := by
  rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt y.isLt, Nat.shiftLeft_eq]

theorem ctrRow_0 (B : Nat) : (ctrRow B)[0] = BitVec.ofNat 32 B :=
  rfl

theorem ctrRow_1 (B : Nat) : (ctrRow B)[1] = BitVec.ofNat 32 (B / 2 ^ 32) :=
  rfl

theorem ctrRow_2 (B : Nat) : (ctrRow B)[2] = 0#32 :=
  rfl

theorem ctrRow_3 (B : Nat) : (ctrRow B)[3] = 0#32 :=
  rfl

theorem add_pos_0 (d : u32x4) (x : BitVec 64) :
    (add_pos d x)[0] = ((d[1] ++ d[0]) + x).truncate 32 :=
  rfl

theorem add_pos_1 (d : u32x4) (x : BitVec 64) :
    (add_pos d x)[1] = (((d[1] ++ d[0]) + x) >>> 32).truncate 32 :=
  rfl

theorem add_pos_2 (d : u32x4) (x : BitVec 64) : (add_pos d x)[2] = d[2] :=
  rfl

theorem add_pos_3 (d : u32x4) (x : BitVec 64) : (add_pos d x)[3] = d[3] :=
  rfl

/-- `add_pos` advances the 64-bit block counter. -/
theorem add_pos_ctrRow (B n : Nat) (hn : n < 2 ^ 64) :
    add_pos (ctrRow B) (BitVec.ofNat 64 n) = ctrRow (B + n) := by
  apply Vector.ext
  intro i hi
  match i, hi with
  | 0, _ =>
    simp only [add_pos_0, ctrRow_0, ctrRow_1]
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth, BitVec.toNat_ofNat,
      BitVec.toNat_add, toNat_append']
    omega
  | 1, _ =>
    simp only [add_pos_1, ctrRow_0, ctrRow_1]
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth, BitVec.toNat_ofNat,
      BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_add, toNat_append']
    omega
  | 2, _ => simp only [add_pos_2, ctrRow_2]
  | 3, _ => simp only [add_pos_3, ctrRow_3]

/-! ## `rand_chacha`'s `BlockRng` -/

theorem refill4_out (st : ChaCha) (B : Nat) (hd : st.d = ctrRow B) (j : Nat) (hj : j < 64) :
    (refill4 st 10).2[j] = ksWord (st.b ++ st.c) (16 * B + j) := by
  have h1 : (16 * B + j) / 16 = B + j / 16 := by omega
  have h2 : (16 * B + j) % 16 = j % 16 := by omega
  have h3 : j / 16 < 2 ^ 64 := by omega
  simp only [refill4, Vector.getElem_ofFn, refillLane_eq, d0123, hd, add_pos_ctrRow _ _ h3, ksWord,
    h1, h2]

theorem refill4_state (st : ChaCha) (B : Nat) (hd : st.d = ctrRow B) :
    (refill4 st 10).1 = { st with d := ctrRow (B + 4) } := by
  simp only [refill4, hd, add_pos_ctrRow B 4 (by decide)]

theorem generate_and_set_eq (rng : ChaCha20Rng) (n : Nat) :
    rng.generate_and_set n =
      { core := (refill4 rng.core 10).1, results := (refill4 rng.core 10).2, index := n } :=
  rfl

/-- `rng` is at keystream word `P` for key words `k`: the core has generated blocks `[0, B)`,
and the unread buffer words are the keystream words that follow `P`. -/
def AgRel (k : Vector (BitVec 32) 8) (rng : ChaCha20Rng) (P : Nat) : Prop :=
  ∃ B,
    rng.core.b ++ rng.core.c = k ∧
      rng.core.d = ctrRow B ∧
      rng.index ≤ 64 ∧
      16 * B + rng.index = P + 64 ∧
      ∀ j (hj : j < 64), rng.index ≤ j → rng.results[j] = ksWord k (P + (j - rng.index))

/-- A fresh `ChaCha20Rng` is at word 0 of the stream of its seed. -/
theorem AgRel_from_seed (seed : Vector (BitVec 8) 32) :
    AgRel
      ((init_chacha seed (Vector.replicate 8 0#8)).b ++
        (init_chacha seed (Vector.replicate 8 0#8)).c)
      (ChaCha20Rng.from_seed seed) 0 := by
  refine ⟨0, rfl, rfl, by simp [ChaCha20Rng.from_seed], by simp [ChaCha20Rng.from_seed], ?_⟩
  intro j hj h
  simp only [ChaCha20Rng.from_seed] at h
  omega

/-- `next_u64` returns the keystream `u64` at `P` and advances by two words. -/
theorem AgRel_next_u64 {k : Vector (BitVec 32) 8} {rng : ChaCha20Rng} {P : Nat}
    (h : AgRel k rng P) : rng.next_u64.1 = ks64 k P ∧ AgRel k rng.next_u64.2 (P + 2) := by
  obtain ⟨B, hk, hd, hi, hP, hr⟩ := h
  have hgen := fun n => generate_and_set_eq rng n
  unfold ChaCha20Rng.next_u64
  by_cases h1 : rng.index < 64 - 1
  · simp only [h1, ite_true]
    rw [getElem!_pos rng.results (rng.index + 1) (by omega),
      getElem!_pos rng.results rng.index (by omega), hr _ (by omega) (by omega),
      hr _ (by omega) (by omega)]
    refine
      ⟨by
        simp only [ks64]; congr 2 <;> omega, B, hk, hd, by
        simp; omega, by
        simp; omega, ?_⟩
    intro j hj hj'
    simp only at hj' ⊢
    rw [hr j hj (by omega)]; congr 1; omega
  · simp only [h1, ite_false]
    by_cases h2 : rng.index ≥ 64
    · simp only [h2, ite_true, hgen]
      rw [getElem!_pos _ 1 (by decide), getElem!_pos _ 0 (by decide),
        refill4_out _ B hd 1 (by decide), refill4_out _ B hd 0 (by decide), refill4_state _ B hd]
      refine
        ⟨by
          simp only [ks64, hk]; congr 2 <;> omega, B + 4, by simp [hk], rfl, by simp, by
          simp; omega, ?_⟩
      intro j hj hj'
      simp only at hj' ⊢
      rw [refill4_out _ B hd j hj, hk]; congr 1; omega
    · simp only [h2, ite_false, hgen]
      rw [getElem!_pos _ 0 (by decide), getElem!_pos rng.results (64 - 1) (by decide),
        refill4_out _ B hd 0 (by decide), refill4_state _ B hd, hr _ (by decide) (by omega)]
      refine
        ⟨by
          simp only [ks64, hk]; congr 2 <;> omega, B + 4, by simp [hk], rfl, by simp, by
          simp; omega, ?_⟩
      intro j hj hj'
      simp only at hj' ⊢
      rw [refill4_out _ B hd j hj, hk]; congr 1; omega

/-! ## Firedancer's portable buffer -/

/-- `rng` is at keystream word `P` for `key`: `buf_off = 4P`, `buf_fill` a block boundary less
than 256 bytes ahead, and the unread bytes of `buf` are the keystream bytes. -/
def FdRel (key : Vector (BitVec 8) 32) (rng : fd_chacha_rng_t) (P : Nat) : Prop :=
  rng.key = key ∧
    rng.algo ≠ FD_CHACHA_RNG_ALGO_CHACHA8 ∧
    rng.mode = FD_CHACHA_RNG_MODE_MOD ∧
    rng.buf_off.toNat = 4 * P ∧
    P % 2 = 0 ∧
    rng.buf_fill.toNat % 64 = 0 ∧
    4 * P ≤ rng.buf_fill.toNat ∧
    rng.buf_fill.toNat < 4 * P + 256 ∧
    ∀ q,
      4 * P ≤ q → q < rng.buf_fill.toNat → rng.buf[q % 256]! = ksByte (uintsOfBytes (k := 8) key) q

theorem idx_nonce_eq (fill : BitVec 64) :
    (#v[(fill >>> 6).setWidth 32, ((fill >>> 6) >>> 32).setWidth 32, 0#32, 0#32] :
        Vector (BitVec 32) 4) =
      ctrRow (fill.toNat / 64) := by
  apply Vector.ext
  intro i hi
  match i, hi with
  | 0, _ =>
    simp only [ctrRow_0]
    show (fill >>> 6).setWidth 32 = _
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat, BitVec.toNat_ushiftRight,
      Nat.shiftRight_eq_div_pow]
  | 1, _ =>
    simp only [ctrRow_1]
    show ((fill >>> 6) >>> 32).setWidth 32 = _
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat, BitVec.toNat_ushiftRight,
      Nat.shiftRight_eq_div_pow]
  | 2, _ => rfl
  | 3, _ => rfl

theorem bytesOfUints_getElem {k : Nat} (w : Vector (BitVec 32) k) (j : Nat) (hj : j < 4 * k) :
    (bytesOfUints w)[j] = (w[j / 4]'(by omega)).extractLsb' (8 * (j % 4)) 8 := by
  simp [bytesOfUints]

/-- The bytes `storeBytes` writes for block `fill / 64` are the keystream bytes there. -/
theorem store_block (key : Vector (BitVec 8) 32) (buf : Vector (BitVec 8) FD_CHACHA_RNG_BUFSZ)
    (fill q : Nat) (hf : fill % 64 = 0) (hq1 : fill ≤ q) (hq2 : q < fill + 64) :
    (storeBytes buf (fill % 256) (fd_chacha20_block.spec key (ctrRow (fill / 64))))[q % 256]! =
      ksByte (uintsOfBytes (k := 8) key) q := by
  rw [getElem!_pos _ _
      (by
        simp only [FD_CHACHA_RNG_BUFSZ]; omega)]
  simp only [storeBytes, Vector.getElem_ofFn]
  rw [dite_eq_left_of_eq_true (eq_true (by omega)), fd_chacha20_block_eq, bytesOfUints_getElem]
  simp only [ksByte, ksWord]
  have h1 : (q % 256 - fill % 256) / 4 = q / 4 % 16 := by omega
  have h2 : (q % 256 - fill % 256) % 4 = q % 4 := by omega
  have h3 : q / 4 / 16 = fill / 64 := by omega
  simp only [h1, h2, h3]

/-- Bytes outside `storeBytes`'s window keep their value. -/
theorem store_other (buf : Vector (BitVec 8) FD_CHACHA_RNG_BUFSZ) (o q : Nat)
    (src : Vector (BitVec 8) 64) (hq : q < 256) (h : ¬(o ≤ q ∧ q - o < 64)) :
    (storeBytes buf o src)[q]! = buf[q]! := by
  rw [getElem!_pos _ _
      (by
        simp only [FD_CHACHA_RNG_BUFSZ]; omega),
    getElem!_pos _ _
      (by
        simp only [FD_CHACHA_RNG_BUFSZ]; omega)]
  simp only [storeBytes, Vector.getElem_ofFn]
  rw [dite_eq_right_of_eq_false (eq_false h)]; rfl

theorem fill_target_eq : BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ - FD_CHACHA_BLOCK_SZ = 192#64 := by
  decide

theorem bufsz_eq : BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ = 256#64 := by decide

/-- One block appended by `refill_seq` keeps `FdRel`, with the fill one block further. -/
theorem FdRel_append (key : Vector (BitVec 8) 32) (rng : fd_chacha_rng_t) (P : Nat)
    (hb : 4 * P + 1024 < 2 ^ 64) (h : FdRel key rng P) (hc : rng.buf_fill.toNat < 4 * P + 192) :
    let idx := rng.buf_fill >>> 6
    let idx_nonce : Vector (BitVec 32) 4 :=
      #v[idx.setWidth 32, (idx >>> 32).setWidth 32, 0#32, 0#32]
    let blk := fd_chacha20_block.spec rng.key idx_nonce
    let buf := storeBytes rng.buf (rng.buf_fill % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat blk
    FdRel key
        { rng with
          buf := buf, buf_fill := rng.buf_fill + (64#32).zeroExtend 64 }
        P ∧
      (rng.buf_fill + (64#32).zeroExtend 64).toNat = rng.buf_fill.toNat + 64 := by
  obtain ⟨hk, ha, hm, ho, hP, hf, h1, h2, hbuf⟩ := h
  intro idx idx_nonce blk buf
  have hfill : (rng.buf_fill + (64#32).zeroExtend 64).toNat = rng.buf_fill.toNat + 64 := by
    simp only [BitVec.toNat_add, BitVec.toNat_setWidth]; simp; omega
  have hmod :
    (rng.buf_fill % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat = rng.buf_fill.toNat % 256 := by
    rw [bufsz_eq, BitVec.toNat_umod]; simp
  refine
    ⟨⟨hk, ha, hm, ho, hP, by
        rw [hfill]; omega, by
        rw [hfill]; omega, by
        rw [hfill]; omega, ?_⟩,
      hfill⟩
  intro q hq1 hq2
  simp only at hq2 ⊢
  rw [hfill] at hq2
  simp only [buf, blk, idx_nonce, idx, hmod, idx_nonce_eq, hk]
  by_cases hq : rng.buf_fill.toNat ≤ q
  · exact store_block key rng.buf _ q hf hq hq2
  · rw [store_other _ _ _ _ (by omega) (by omega)]
    exact hbuf q hq1 (by omega)

/-- `refill_seq` (ChaCha20) keeps `FdRel` and leaves at least 192 bytes buffered. -/
theorem FdRel_refill (key : Vector (BitVec 8) 32) (P : Nat) (hb : 4 * P + 1024 < 2 ^ 64) :
    ∀ n rng,
      4 * P + 256 - rng.buf_fill.toNat = n →
        FdRel key rng P →
        FdRel key (fd_chacha_rng_refill_seq.spec rng fd_chacha20_block.spec) P ∧
          4 * P + 192 ≤
            (fd_chacha_rng_refill_seq.spec rng fd_chacha20_block.spec).buf_fill.toNat := by
  intro n
  induction n using Nat.strongRecOn with
  | _ n ih =>
    intro rng hn h
    have hoff := h.2.2.2.1
    have hle := h.2.2.2.2.2.2.1
    have havail : (rng.buf_fill - rng.buf_off).toNat = rng.buf_fill.toNat - 4 * P := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def]; omega)];
      omega
    rw [fd_chacha_rng_refill_seq.spec]
    simp only [fill_target_eq]
    by_cases hc : rng.buf_fill.toNat < 4 * P + 192
    · rw [dite_eq_left_of_eq_true
          (eq_true
            (by
              rw [BitVec.lt_def, havail]; simp; omega))]
      obtain ⟨h', hfill⟩ := FdRel_append key rng P hb h hc
      exact
        ih (4 * P + 256 - (rng.buf_fill.toNat + 64)) (by omega) _
          (by
            dsimp only; rw [hfill])
          h'
    · rw [dite_eq_right_of_eq_false
          (eq_false
            (by
              rw [BitVec.lt_def, havail]; simp; omega))]
      exact ⟨h, by omega⟩

theorem ksByte_lo (k : Vector (BitVec 32) 8) (P j : Nat) (hj : j < 4) :
    ksByte k (4 * P + j) = (ksWord k P).extractLsb' (8 * j) 8 := by
  have h1 : (4 * P + j) / 4 = P := by omega
  have h2 : (4 * P + j) % 4 = j := by omega
  simp only [ksByte, h1, h2]

theorem ksByte_hi (k : Vector (BitVec 32) 8) (P j : Nat) (hj : j < 4) :
    ksByte k (4 * P + (4 + j)) = (ksWord k (P + 1)).extractLsb' (8 * j) 8 := by
  have h1 : (4 * P + (4 + j)) / 4 = P + 1 := by omega
  have h2 : (4 * P + (4 + j)) % 4 = j := by omega
  simp only [ksByte, h1, h2]

theorem bytes_concat (u v : BitVec 32) :
    (u.extractLsb' (8 * 3) 8 ++ u.extractLsb' (8 * 2) 8 ++ u.extractLsb' (8 * 1) 8 ++
          u.extractLsb' (8 * 0) 8 ++
          v.extractLsb' (8 * 3) 8 ++
          v.extractLsb' (8 * 2) 8 ++
          v.extractLsb' (8 * 1) 8 ++
          v.extractLsb' (8 * 0) 8 :
        BitVec 64) =
      u ++ v := by
  apply BitVec.eq_of_toNat_eq
  simp only [toNat_append', BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
  have := u.isLt; have := v.isLt
  omega

/-- With 8 bytes buffered, the `FD_LOAD` of `fd_chacha_rng_ulong` is the keystream `u64` at `P`. -/
theorem FdRel_load {key : Vector (BitVec 8) 32} {rng : fd_chacha_rng_t} {P : Nat}
    (h : FdRel key rng P) (h8 : 4 * P + 8 ≤ rng.buf_fill.toNat) :
    loadULong rng.buf (rng.buf_off % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat =
      ks64 (uintsOfBytes (k := 8) key) P := by
  obtain ⟨hk, ha, hm, ho, hP, hf, h1, h2, hbuf⟩ := h
  have hmod : (rng.buf_off % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat = 4 * P % 256 := by
    rw [bufsz_eq, BitVec.toNat_umod]; simp [ho]
  have e : ∀ j, j < 8 → 4 * P % 256 + j = (4 * P + j) % 256 := by
    intro j hj; omega
  have b :
    ∀ j, j < 8 → rng.buf[4 * P % 256 + j]! = ksByte (uintsOfBytes (k := 8) key) (4 * P + j) :=
    fun j hj => by
    rw [e j hj]; exact hbuf _ (by omega) (by omega)
  have b0 : rng.buf[4 * P % 256]! = ksByte (uintsOfBytes (k := 8) key) (4 * P + 0) := b 0 (by omega)
  rw [hmod]
  unfold loadULong
  rw [b 7 (by omega), b 6 (by omega), b 5 (by omega), b 4 (by omega), b 3 (by omega),
    b 2 (by omega), b 1 (by omega), b0]
  rw [show 4 * P + 7 = 4 * P + (4 + 3) from rfl, show 4 * P + 6 = 4 * P + (4 + 2) from rfl,
    show 4 * P + 5 = 4 * P + (4 + 1) from rfl, show 4 * P + 4 = 4 * P + (4 + 0) from rfl,
    ksByte_hi _ _ 3 (by omega), ksByte_hi _ _ 2 (by omega), ksByte_hi _ _ 1 (by omega),
    ksByte_hi _ _ 0 (by omega), ksByte_lo _ _ 3 (by omega), ksByte_lo _ _ 2 (by omega),
    ksByte_lo _ _ 1 (by omega), ksByte_lo _ _ 0 (by omega), bytes_concat]
  rfl

/-- `fd_chacha_rng_ulong` returns the keystream `u64` at `P` and advances by two words. -/
theorem FdRel_ulong {key : Vector (BitVec 8) 32} {rng : fd_chacha_rng_t} {P : Nat}
    (h : FdRel key rng P) (hb : 4 * P + 1024 < 2 ^ 64) :
    (fd_chacha_rng_ulong.spec rng).1 = ks64 (uintsOfBytes (k := 8) key) P ∧
      FdRel key (fd_chacha_rng_ulong.spec rng).2 (P + 2) := by
  have hoff := h.2.2.2.1
  have hle := h.2.2.2.2.2.2.1
  have havail : (fd_chacha_rng_avail.spec rng).toNat = rng.buf_fill.toNat - 4 * P := by
    unfold fd_chacha_rng_avail.spec
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def]; omega)];
    omega
  have h1 :
    ∃ r,
      (if fd_chacha_rng_avail.spec rng < 8#64 then
            (if rng.algo = FD_CHACHA_RNG_ALGO_CHACHA8 then fd_chacha8_rng_private_refill.spec rng
            else fd_chacha20_rng_private_refill.spec rng)
          else rng) =
          r ∧
        FdRel key r P ∧ 4 * P + 8 ≤ r.buf_fill.toNat := by
    by_cases hc : fd_chacha_rng_avail.spec rng < 8#64
    · rw [ite_eq_left hc, ite_eq_right h.2.1]
      have := FdRel_refill key P hb _ rng rfl h
      refine ⟨_, rfl, this.1, ?_⟩
      show 4 * P + 8 ≤ (fd_chacha_rng_refill_seq.spec rng fd_chacha20_block.spec).buf_fill.toNat
      omega
    · rw [ite_eq_right hc]
      rw [BitVec.lt_def, havail] at hc
      exact
        ⟨rng, rfl, h, by
          simp at hc; omega⟩
  obtain ⟨r, hr, hR, h8⟩ := h1
  unfold fd_chacha_rng_ulong.spec
  simp only [hr]
  refine ⟨FdRel_load hR h8, ?_⟩
  obtain ⟨hk, ha, hm, ho, hP, hf, h1, h2, hbuf⟩ := hR
  have hoff' : (r.buf_off + (8#32).zeroExtend 64).toNat = 4 * (P + 2) := by
    simp only [BitVec.toNat_add, BitVec.toNat_setWidth]; simp; omega
  refine
    ⟨hk, ha, hm, hoff', by omega, hf, by
      dsimp only; omega, by
      dsimp only; omega, ?_⟩
  intro q hq1 hq2
  exact hbuf q (by omega) hq2

/-- `fd_chacha_rng_init` (ChaCha20) on a `MODE_MOD` RNG is at word 0 of the stream of `key`. -/
theorem FdRel_init (rng : fd_chacha_rng_t) (hm : rng.mode = FD_CHACHA_RNG_MODE_MOD)
    (key : Vector (BitVec 8) 32) :
    FdRel key (fd_chacha_rng_init.spec rng key FD_CHACHA_RNG_ALGO_CHACHA20) 0 := by
  have h0 :
    FdRel key
      { rng with
        key := key, buf_off := 0#64, buf_fill := 0#64, algo := FD_CHACHA_RNG_ALGO_CHACHA20 }
      0 :=
    ⟨rfl, by
      dsimp only; decide, hm, rfl, rfl, rfl, by simp, by simp, fun q h1 h2 => by simp at h2⟩
  unfold fd_chacha_rng_init.spec
  rw [ite_eq_right (by decide)]
  exact (FdRel_refill key 0 (by decide) _ _ rfl h0).1

/-- Both key schedules read the seed as eight little-endian words. -/
theorem key_words_eq (key : Vector (BitVec 8) 32) :
    (init_chacha key (Vector.replicate 8 0#8)).b ++ (init_chacha key (Vector.replicate 8 0#8)).c =
      uintsOfBytes (k := 8) key := by
  apply Vector.ext
  intro i hi
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl

/-! ## The two streams -/

/-- The `(n+1)`-th `fd_chacha_rng_ulong` call from `rng`: its value and the RNG after. -/
def fdUlongs (rng : fd_chacha_rng_t) : Nat → BitVec 64 × fd_chacha_rng_t
  | 0 => fd_chacha_rng_ulong.spec rng
  | n + 1 => fd_chacha_rng_ulong.spec (fdUlongs rng n).2

/-- The `(n+1)`-th `next_u64` call from `rng`: its value and the RNG after. -/
def agNextU64s (rng : ChaCha20Rng) : Nat → BitVec 64 × ChaCha20Rng
  | 0 => rng.next_u64
  | n + 1 => (agNextU64s rng n).2.next_u64

theorem fdUlongs_spec {key : Vector (BitVec 8) 32} {rng : fd_chacha_rng_t} (h : FdRel key rng 0) :
    ∀ n,
      8 * n + 1032 < 2 ^ 64 →
        (fdUlongs rng n).1 = ks64 (uintsOfBytes (k := 8) key) (2 * n) ∧
          FdRel key (fdUlongs rng n).2 (2 * n + 2)
  | 0, _ => FdRel_ulong h (by omega)
  | n + 1, hb => by
    have ih := (fdUlongs_spec h n (by omega)).2
    exact FdRel_ulong ih (by omega)

theorem agNextU64s_spec {k : Vector (BitVec 32) 8} {rng : ChaCha20Rng} (h : AgRel k rng 0) :
    ∀ n, (agNextU64s rng n).1 = ks64 k (2 * n) ∧ AgRel k (agNextU64s rng n).2 (2 * n + 2)
  | 0 => AgRel_next_u64 h
  | n + 1 => AgRel_next_u64 (agNextU64s_spec h n).2

/-- From the same key, Firedancer's `fd_chacha_rng_ulong` and `rand_chacha`'s `next_u64` return the
same `u64`s, call for call (below 2^60 calls, where Firedancer's byte offset would wrap). -/
theorem same_stream (rng : fd_chacha_rng_t) (hm : rng.mode = FD_CHACHA_RNG_MODE_MOD)
    (key : Vector (BitVec 8) 32) (n : Nat) (hn : n < 2 ^ 60) :
    (fdUlongs (fd_chacha_rng_init.spec rng key FD_CHACHA_RNG_ALGO_CHACHA20) n).1 =
      (agNextU64s (ChaCha20Rng.from_seed key) n).1 := by
  have hA := AgRel_from_seed key
  rw [key_words_eq] at hA
  rw [(fdUlongs_spec (FdRel_init rng hm key) n (by omega)).1, (agNextU64s_spec hA n).1]

end

end Firedancer.Leaders.Math

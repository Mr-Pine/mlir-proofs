
/-! ## The schedule's loops -/

/-- The stores of `f i`, …, `f (i + n - 1)` into the slots `i … i + n - 1` of `W`. -/
def stores (W : Pointer) (f : Nat → BitVec 64) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m => stores W f (i + 1) n (m.storeAt (W.add (BitVec.ofNat 64 (8 * i))) (f i))

theorem shl3_facts {i : Nat} (hi : i < 2 ^ 60) :
    BitVec.ofNat 64 (8 * i) >>> 3 = BitVec.ofNat 64 i ∧
      (BitVec.ofNat 64 (8 * i)).sshiftRight 3 = BitVec.ofNat 64 i ∧
      BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) ∧ i % 18446744073709551616 = i ∧
      i * 8 = 8 * i ∧ 8 * i % 18446744073709551616 = 8 * i ∧ 8 * i < 18446744073709551616 := by
  have h3 : BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) := by
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
    omega
  refine ⟨?_, ?_, h3, by omega, by omega, by omega, by omega⟩
  · apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
  · rw [BitVec.sshiftRight_eq_of_msb_false]
    · apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
    · simp [BitVec.msb_eq_decide]; omega

/-- `llvm.intr.bswap` on 64 bits, as the operation unfolds. -/
abbrev bswapv (x : BitVec 64) : BitVec 64 :=
  (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1))) 0#64

/-- The counter's `+ 1` wraps neither way. -/
theorem counter_overflow {i : Nat} (h : i + 1 < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 1#64 = false ∧ (BitVec.ofNat 64 i).uaddOverflow 1#64 = false := by
  have : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  constructor
  · simp [BitVec.saddOverflow, this]; omega
  · simp [BitVec.uaddOverflow]; omega

set_option maxHeartbeats 0 in
/-- `bb1`/`bb2` from round `i`, `m` left: `W[i] = bswap(block word i)`. -/
theorem loop1 (dd blk V W : Pointer) (B : BitVec 1024) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hbo : blk.offset.toNat + 128 < 2 ^ 64) (hWb : W.id ≠ blk.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 16 →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %103 := W, %104 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem W 5120 → Fits S.mem blk 1024 → S.mem.readAt blk 1024 = B →
      (∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [%102 := V, %103 := W, %112 := 16#64]) →
        (Sha512_round.runFrom E' 3
          { S with mem := stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) i m S.mem } >>= κ) = R) →
      (Sha512_round.runFrom E 1 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hc hR hwf hWf hbf hB hK
    obtain rfl : i = 16 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
    env_reads
  | succ m ih =>
    intro i S E hi hArgs hc hR hwf hWf hbf hB hK
    obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := shl3_facts (i := i) (by omega)
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    have hfx : Fits S.mem (blk.add (BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hbf
    have hfw : Fits S.mem (W.add (BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow, hWo]; omega) (by simp; omega) hWf
    have hx : S.mem.readAt (blk.add (BitVec.ofNat 64 (8 * i))) 64 = B.extractLsb' (64 * i) 64 := by
      rw [MemoryState.readAt_add_of_readAt hbf (by simp [BitVec.uaddOverflow]; omega)
        (by simp; omega) hB]
      congr 1; simp; omega
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
      step_pure [h4, h5, h7]
      step_pure [h3, h1, h2]
      step_pure [h3, h1, h2, h6, h7]
      step_load consuming hx hfx
      step_pure
      step_store consuming hfw
      step_pure [o1, o2, ← BitVec.ofNat_add]
      finish_block
      refine ih (i + 1) S E (by omega) hArgs (by env_reads) (by env_reads) hwf hWf hbf hB
        (fun E' h1 h2 h3 => ?_)
      subst hS
      exact hK E' h1 h2 h3

/-- Slots `0 … n - 1` of `W` hold `f 0 … f (n - 1)`. -/
def HoldsW (m : MemoryState) (W : Pointer) (f : Nat → BitVec 64) (n : Nat) : Prop :=
  ∀ t, t < n → m.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = f t

theorem slot_offsetInBits {W : Pointer} (hWo : W.offset = 0) {t : Nat} (ht : t < 2 ^ 58) :
    (W.add (BitVec.ofNat 64 (8 * t))).offsetInBits = 64 * t := by
  simp [Pointer.offsetInBits, Pointer.add, hWo]
  omega

theorem fits_slot {N : Nat} {m : MemoryState} {W : Pointer} (hWo : W.offset = 0) (hN : N < 2 ^ 58)
    (hf : Fits m W (64 * N)) {t : Nat} (ht : t < N) : Fits m (W.add (BitVec.ofNat 64 (8 * t))) 64 :=
  Fits.add_of_le (by simp [BitVec.uaddOverflow, hWo]; omega) (by simp; omega) hf

/-- A store of `f n` into slot `n` extends what `W` holds. -/
theorem HoldsW.store {N : Nat} {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64} {n : Nat}
    (hWo : W.offset = 0) (hN : N < 2 ^ 58) (hf : Fits m W (64 * N)) (h : HoldsW m W f n) (hn : n < N) :
    HoldsW (m.storeAt (W.add (BitVec.ofNat 64 (8 * n))) (f n)) W f (n + 1) := by
  intro t ht
  by_cases e : t = n
  · subst e
    exact MemoryState.readAt_storeAt_self (fits_slot hWo hN hf hn) _
  · rw [MemoryState.readAt_storeAt_disjoint]
    · exact h t (by omega)
    · simp only [Range.Disjoint, Range.of, slot_offsetInBits hWo (show n < 2 ^ 58 by omega),
        slot_offsetInBits hWo (show t < 2 ^ 58 by omega)]
      omega

theorem fits_stores {m : MemoryState} : Fits (stores W f i n m) p w ↔ Fits m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [stores, ih]

/-- `stores` extends what `W` holds. -/
theorem HoldsW.stores {N : Nat} {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64}
    (hWo : W.offset = 0) (hN : N < 2 ^ 58) :
    ∀ n i, Fits m W (64 * N) → HoldsW m W f i → i + n ≤ N → HoldsW (stores W f i n m) W f (i + n) := by
  intro n
  induction n generalizing m with
  | zero => intro i _ h _; exact h
  | succ n ih =>
    intro i hf h hn
    rw [show i + (n + 1) = i + 1 + n by omega]
    exact ih (i + 1) hf.storeAt (h.store hWo hN hf (by omega)) (by omega)

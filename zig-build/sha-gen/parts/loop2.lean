
theorem sub_facts {i k c : Nat} (hc : c + k = 2 ^ 64) (hk : k ≤ i) (hk' : k ≤ 16) (hi : i < 2 ^ 60) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 c) = false ∧
      BitVec.ofNat 64 i + BitVec.ofNat 64 c = BitVec.ofNat 64 (i - k) ∧
      (i - k) % 18446744073709551616 = i - k ∧ (i - k) * 8 = 8 * (i - k) ∧
      8 * (i - k) < 18446744073709551616 := by
  refine ⟨?_, ?_, by omega, by omega, by omega⟩
  · have h1 : (BitVec.ofNat 64 i).toInt = i := by
      rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
    have h2 : (BitVec.ofNat 64 c).toInt = -(k : Int) := by
      rw [BitVec.toInt_eq_toNat_bmod]; simp [Int.bmod]; omega
    simp [BitVec.saddOverflow, h1, h2]; omega
  · apply BitVec.eq_of_toNat_eq; simp; omega

theorem rotl_63 (x : BitVec 64) : rotl x 63 = x.rotateRight 1 := by bv_decide
theorem rotl_56 (x : BitVec 64) : rotl x 56 = x.rotateRight 8 := by bv_decide
theorem rotl_45 (x : BitVec 64) : rotl x 45 = x.rotateRight 19 := by bv_decide
theorem rotl_3 (x : BitVec 64) : rotl x 3 = x.rotateRight 61 := by bv_decide

/-- A schedule word as the code computes it. -/
theorem sched_eq (x16 x7 x15 x2 : BitVec 64) :
    x7 + x16 + ((rotl x15 63 ^^^ rotl x15 56) ^^^ x15 >>> 7) + ((rotl x2 45 ^^^ rotl x2 3) ^^^ x2 >>> 6) =
      Sha512.sigma1 x2 + x7 + Sha512.sigma0 x15 + x16 := by
  simp only [rotl_63, rotl_56, rotl_45, rotl_3, Sha512.sigma0, Sha512.sigma1]
  ac_rfl

set_option maxHeartbeats 0 in
/-- `bb4`, round `i` of the schedule: `W[i]` from `W[i - 16]`, `W[i - 15]`, `W[i - 7]`, `W[i - 2]`. -/
theorem loop2_iter (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hrec : Wf i = Sha512.sigma1 (Wf (i - 2)) + Wf (i - 7) + Sha512.sigma0 (Wf (i - 15)) + Wf (i - 16))
    (S : GlobalState) (E : ⟪Γ⟫) (hi : 16 ≤ i) (hi' : i < 80)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hWf : Fits S.mem W 5120)
    (r16 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 16)))) 64 = Wf (i - 16))
    (r7 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 7)))) 64 = Wf (i - 7))
    (r15 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 15)))) 64 = Wf (i - 15))
    (r2 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 2)))) 64 = Wf (i - 2))
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
      (E' ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 (i + 1)]) →
      (Sha512_round.runFrom E' 3
        { S with mem := S.mem.storeAt (W.add (BitVec.ofNat 64 (8 * i))) (Wf i) } >>= κ) = R) :
    (Sha512_round.runFrom E 4 S >>= κ) = R := by
  obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
  obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
  obtain ⟨a1, a2, a3, a4, a5⟩ :=
    sub_facts (i := i) (k := 16) (c := 18446744073709551600) rfl hi (by omega) (by omega)
  obtain ⟨b1, b2, b3, b4, b5⟩ :=
    sub_facts (i := i) (k := 7) (c := 18446744073709551609) rfl (by omega) (by omega) (by omega)
  obtain ⟨c1, c2, c3, c4, c5⟩ :=
    sub_facts (i := i) (k := 15) (c := 18446744073709551601) rfl (by omega) (by omega) (by omega)
  obtain ⟨d1, d2, d3, d4, d5⟩ :=
    sub_facts (i := i) (k := 2) (c := 18446744073709551614) rfl (by omega) (by omega) (by omega)
  have f16 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 16) (by omega)
  have f7 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 7) (by omega)
  have f15 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 15) (by omega)
  have f2 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 2) (by omega)
  have fi := fits_slot (N := 80) hWo (by decide) hWf (t := i) (by omega)
  block_init
  step_pure [h4, h5, h7]
  step_pure [a1, a2]
  step_pure [a1, a2, a3, a4, a5]
  step_load consuming r16 f16
  step_pure [b1, b2]
  step_pure [b1, b2, b3, b4, b5]
  step_load consuming r7 f7
  step_pure
  step_pure [c1, c2]
  step_pure [c1, c2, c3, c4, c5]
  step_load consuming r15 f15
  iterate 6 step_pure
  step_pure [d1, d2]
  step_pure [d1, d2, d3, d4, d5]
  step_load consuming r2 f2
  iterate 6 step_pure
  step_store consuming fi
  step_pure [o1, o2, ← BitVec.ofNat_add]
  finish_block
  subst hS
  rw [sched_eq, ← hrec]
  exact hK E hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- `bb3`/`bb4` from round `i`, `m` left: the schedule's words `16 … 79` into `W`. -/
theorem loop2 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hrec : ∀ t, 16 ≤ t → t < 80 →
      Wf t = Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16)) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 80 → 16 ≤ i →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem W 5120 → HoldsW S.mem W Wf i →
      (∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [%102 := V, %103 := W]) →
        (Sha512_round.runFrom E' 5 { S with mem := stores W Wf i m S.mem } >>= κ) = R) →
      (Sha512_round.runFrom E 3 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi _ hArgs hc hR hwf hWf hH hK
    obtain rfl : i = 80 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
    env_reads
  | succ m ih =>
    intro i S E hi hi16 hArgs hc hR hwf hWf hH hK
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · refine loop2_iter dd blk V W Wf κ R hWo (hrec i hi16 (by omega)) S E hi16 (by omega) hArgs
        (by env_reads) (by env_reads) hwf hWf (hH _ (by omega)) (hH _ (by omega)) (hH _ (by omega))
        (hH _ (by omega)) fun E' h1 h2 h3 => ?_
      exact ih (i + 1) _ E' (by omega) (by omega) h1 h2 h3 hwf.storeAt hWf.storeAt
        (hH.store (N := 80) hWo (by decide) hWf (by omega)) fun E'' g1 g2 g3 => hK E'' g1 g2 g3

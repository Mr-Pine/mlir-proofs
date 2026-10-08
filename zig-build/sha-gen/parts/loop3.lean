
set_option maxHeartbeats 0 in
/-- `bb7`, word `i`: `state[i] += V[i]`. -/
theorem loop3_iter (dd blk V : Pointer) (i : Nat) (x y : BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hVo : V.offset = 0)
    (hdo : dd.offset.toNat + 80 < 2 ^ 64) (S : GlobalState) (E : ⟪Γ⟫) (hi : i < 8)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 i])
    (hwf : S.WF) (hVf : Fits S.mem V 512)
    (hDf : Fits S.mem (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) 64)
    (rv : S.mem.readAt (V.add (BitVec.ofNat 64 (8 * i))) 64 = y)
    (rd : S.mem.readAt (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) 64 = x)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
      (E' ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 (i + 1)]) →
      (Sha512_round.runFrom E' 6
        { S with mem := S.mem.storeAt (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) (x + y) } >>= κ) =
        R) :
    (Sha512_round.runFrom E 7 S >>= κ) = R := by
  obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
  obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
  have fv := Fits.add_of_le (p := V) (off := BitVec.ofNat 64 (8 * i)) (w := 64)
    (by simp [BitVec.uaddOverflow, hVo]; omega) (by simp; omega) hVf
  block_init
  step_pure [h4, h5, h7]
  step_pure [h4, h5, h7]
  step_load consuming rv fv
  step_load consuming rd
  step_pure
  step_store consuming hDf
  step_pure [o1, o2, ← BitVec.ofNat_add]
  finish_block
  subst hS
  exact hK E hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- `bb6`/`bb7` from word `i`, `m` left: `state[i] += V[i]`, then the return. -/
theorem loop3 (dd blk V : Pointer) (Hf vf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hVo : V.offset = 0)
    (hdo : dd.offset.toNat + 80 < 2 ^ 64) (hVd : V.id ≠ dd.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 8 →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem V 512 → (∀ j, j < 8 → Fits S.mem (dd.add (16#64 + BitVec.ofNat 64 (8 * j))) 64) →
      (∀ j, i ≤ j → j < 8 → S.mem.readAt (V.add (BitVec.ofNat 64 (8 * j))) 64 = vf j) →
      (∀ j, i ≤ j → j < 8 → S.mem.readAt (dd.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 = Hf j) →
      κ (.nil, { S with mem := Sha512Obj.storeWords dd (fun j => Hf j + vf j) i m S.mem }) = R →
      (Sha512_round.runFrom E 6 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hc hR hwf hVf hDf hv hd hfin
    obtain rfl : i = 8 := by omega
    block_init
    step_pure
    finish_block
    block_init
    finish_block
    exact hfin
  | succ m ih =>
    intro i S E hi hArgs hc hR hwf hVf hDf hv hd hfin
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · refine loop3_iter dd blk V i (Hf i) (vf i) κ R hVo hdo S E (by omega) hArgs (by env_reads)
        (by env_reads) hwf hVf (hDf i (by omega)) (hv i (by omega) (by omega))
        (hd i (by omega) (by omega)) fun E' h1 h2 h3 => ?_
      refine ih (i + 1) _ E' (by omega) h1 h2 h3 hwf.storeAt hVf.storeAt (fun j hj => (hDf j hj).storeAt)
        (fun j hj hj' => ?_) (fun j hj hj' => ?_) hfin
      · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hVd.symm))]
        exact hv j (by omega) hj'
      · rw [MemoryState.readAt_storeAt_disjoint]
        · exact hd j (by omega) hj'
        · simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
            BitVec.toNat_ofNat]
          omega


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

set_option maxHeartbeats 0 in
theorem loop2_test (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (i : Nat) (S : GlobalState) (E : ⟪Γ⟫) (hi : 16 ≤ i) (hi' : i < 80)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hWf : Fits S.mem W 5120) (hH : HoldsW S.mem W Wf i) :
    (Sha512_round.runFrom E 3 S >>= κ) = R := by
  obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
  obtain ⟨a1, a2, a3, a4, a5⟩ := sub_facts (i := i) (k := 16) (c := 18446744073709551600) rfl hi (by omega) (by omega)
  obtain ⟨b1, b2, b3, b4, b5⟩ := sub_facts (i := i) (k := 7) (c := 18446744073709551609) rfl (by omega) (by omega) (by omega)
  obtain ⟨c1, c2, c3, c4, c5⟩ := sub_facts (i := i) (k := 15) (c := 18446744073709551601) rfl (by omega) (by omega) (by omega)
  obtain ⟨d1, d2, d3, d4, d5⟩ := sub_facts (i := i) (k := 2) (c := 18446744073709551614) rfl (by omega) (by omega) (by omega)
  have r16 := hH (i - 16) (by omega)
  have r7 := hH (i - 7) (by omega)
  have r15 := hH (i - 15) (by omega)
  have r2 := hH (i - 2) (by omega)
  have f16 := fits_slot hWo hWf (t := i - 16) (by omega)
  have f7 := fits_slot hWo hWf (t := i - 7) (by omega)
  have f15 := fits_slot hWo hWf (t := i - 15) (by omega)
  have f2 := fits_slot hWo hWf (t := i - 2) (by omega)
  have fi := fits_slot hWo hWf (t := i) (by omega)
  block_init
  step_pure
  finish_block
  · sorry
  · block_init
    step_pure [h4, h5, h7]
    step_pure [a1, a2]
    step_pure [a1, a2, a3, a4, a5]
    step_load
    step_pure [b1, b2]
    step_pure [b1, b2, b3, b4, b5]
    step_load
    step_pure
    step_pure [c1, c2]
    step_pure [c1, c2, c3, c4, c5]
    step_load
    iterate 6 step_pure
    step_pure [d1, d2]
    step_pure [d1, d2, d3, d4, d5]
    step_load
    iterate 6 step_pure
    step_store
    trace_state
    sorry

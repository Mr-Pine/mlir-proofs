
set_option maxHeartbeats 0 in
theorem loop2_test (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (i : Nat) (S : GlobalState) (E : ⟪Γ⟫) (hi : 16 ≤ i) (hi' : i < 80)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hWf : Fits S.mem W 5120) (hH : HoldsW S.mem W Wf i) :
    (Sha512_round.runFrom E 3 S >>= κ) = R := by
  block_init
  step_pure
  finish_block
  · sorry
  · block_init
    sorry

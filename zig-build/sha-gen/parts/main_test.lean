
end Sha512_round

set_option maxHeartbeats 0 in
theorem Sha512_round.call_eq_test (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdf : Fits s.mem d 640) (hdo : d.offset.toNat + 80 < 2 ^ 64) (hbf : Fits s.mem b 1024)
    (hbo : b.offset.toNat + 128 < 2 ^ 64) :
    Sha512_round.call (Sha512_round.args (.value d) (.value b)) s =
      .value (.nil, { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 102 step_pure
  step_alloca with V
  step_alloca with W
  finish_block
  trace_state
  sorry

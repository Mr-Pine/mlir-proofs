
/-! ## Proof -/

section Proof

set_option maxHeartbeats 0 in
/-- `x25519_sc_reduce` stores `spec` of the 64 bytes at `p` as the 32 bytes at `p`. -/
public theorem x25519_sc_reduce.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    x25519_sc_reduce.call (x25519_sc_reduce.args (.value p)) s =
      .value (.nil,
        { s with mem := s.mem.storeAt p (x25519_sc_reduce.spec (s.mem.readAt p 512)) }) := by
  open x25519_sc_reduce in
  func_init
  block_init

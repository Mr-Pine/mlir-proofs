/-! ### The function -/

/-- `slide` stores `slide.spec` of the 32 bytes at `a` as the 256 digits at `r`, which must not alias
`a`. -/
public theorem slide.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 2048) (hr_off : ¬r.offset.uaddOverflow 256#64) (ha : Fits s.mem a 256)
    (ha_off : ¬a.offset.uaddOverflow 32#64) (hsep : r.id ≠ a.id) :
    slide.call (slide.args (.value r) (.value a)) s =
      .value (.nil,
        { s with mem := s.mem.storeAt r (BitVec.packLanes (slide.spec (s.mem.readAt a 256))) }) := by
  func_init
  have hr₀ : Room S₀.mem r 2048 := hS ▸ hr
  have ha₀ : Fits S₀.mem a 256 := hS ▸ ha
  have BL := bits_loop r a S₀ hr₀ hr_off ha₀ ha_off hsep
  have ML := main_loop r a S₀ hr₀ hr_off
  have h0 := fill_zero (B := BitVec.packLanes (bits (S₀.mem.readAt a 256))) hr₀.inBounds
  clear hr₀ ha₀
  block_init
  iterate 25 step_pure
  finish_block
  have hfill : S = { S₀ with mem := fill S₀ r (BitVec.packLanes (bits (S₀.mem.readAt a 256))) 0 } := by
    rw [h0, hS]
  rw [hfill]
  step_loop using BL _ 127 0
  step_loop using ML _ 255 0 _
  block_init
  finish_block
  rw [hS]
  rfl


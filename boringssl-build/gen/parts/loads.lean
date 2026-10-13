
/-- `load_3(s)` as the memory reads it: the low 24 bits. -/
public theorem x25519_sc_reduce.setWidth_load3 (x : BitVec 512) :
    (x.setWidth 24).setWidth 64 = x25519_sc_reduce.load3 x 0 := by
  unfold x25519_sc_reduce.load3
  bv_decide

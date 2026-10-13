
/-! ## Bounds -/

/-- `load_3(s + k)`'s pointer does not wrap. -/
theorem x25519_sc_reduce.off3 {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) (k : Nat) (hk : k + 3 ≤ 64) :
    ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 3#64 := by
  have e : (64#64).toNat = 64 := rfl
  simp only [BitVec.uaddOverflow, Pointer.add, e] at h ⊢
  simp at h ⊢
  rw [Nat.mod_eq_of_lt (by omega)]
  omega


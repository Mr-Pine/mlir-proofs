module

public import MLIR.Run.Tactic

/-! Byte buffers: reads inside a known buffer, and the flags of words assembled from bytes
(`(b as u64) << s` with `shl nuw nsw`, `or disjoint`). -/

namespace MLIR.Agave

/-! ## Reads -/

/-- The `w` bits at byte `k` of `n` bytes read as `buf`. -/
public theorem readAt_bytes {m : MemoryState} {p : Pointer} {n : Nat} {buf : BitVec (8 * n)}
    (hb : InBounds m p (8 * n)) (ho : ¬p.offset.uaddOverflow (BitVec.ofNat 64 n)) (hn : n < 2 ^ 64)
    (h : m.readAt p (8 * n) = buf) (k w : Nat) (hk : 8 * k + w ≤ 8 * n) :
    m.readAt (p.add (BitVec.ofNat 64 k)) w = buf.extractLsb' (8 * k) w := by
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le] at ho ⊢
    simp only [BitVec.toNat_ofNat] at ho ⊢
    rw [Nat.mod_eq_of_lt hn] at ho
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hk' : (BitVec.ofNat 64 k).toNat = k := by
    simp only [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt (by omega)
  rw [MemoryState.readAt_add_of_readAt hb hov (by omega) h, hk', Nat.mul_comm k 8]

/-- The first `w` bits of a read. -/
public theorem readAt_bytes0 {m : MemoryState} {p : Pointer} {buf : BitVec v}
    (h : m.readAt p v = buf) (w : Nat) (hw : w ≤ v) : m.readAt p w = buf.extractLsb' 0 w := by
  rw [MemoryState.readAt_of_readAt_le hw h]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

/-! ## Words from bytes -/

/-- A zero-extended value shifted left within the width shifts back. -/
public theorem zext_shl_ushiftRight {w s n : Nat} (b : BitVec w) (h : w + s ≤ n) :
    b.setWidth n <<< s >>> s = b.setWidth n := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_ushiftRight, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
  by_cases hiw : i < w
  · simp [hiw]
    omega
  · simp [BitVec.getLsbD_of_ge b i (by omega)]

/-- A zero-extended value shifted left below the sign bit shifts back signed too. -/
public theorem zext_shl_sshiftRight {w s n : Nat} (b : BitVec w) (h : w + s < n) :
    (b.setWidth n <<< s).sshiftRight s = b.setWidth n := by
  rw [BitVec.sshiftRight_eq_of_msb_false, zext_shl_ushiftRight b (by omega)]
  simp only [BitVec.msb_eq_getLsbD_last, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
  simp [BitVec.getLsbD_of_ge b (n - 1 - s) (by omega)]

/-- Zero-extended values shifted to separate bits share none. -/
public theorem zext_shl_and_zext_shl {w v s t n : Nat} (a : BitVec w) (b : BitVec v)
    (h : s + w ≤ t ∨ t + v ≤ s) : a.setWidth n <<< s &&& b.setWidth n <<< t = 0#n := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth,
    BitVec.getLsbD_zero]
  by_cases ha : s ≤ i ∧ i - s < w
  · by_cases hb : t ≤ i ∧ i - t < v
    · omega
    · simp only [Bool.and_eq_false_iff]
      right
      by_cases ht : i < t
      · simp [ht]
      · simp [ht, BitVec.getLsbD_of_ge b (i - t) (by omega)]
  · simp only [Bool.and_eq_false_iff]
    left
    by_cases hs : i < s
    · simp [hs]
    · simp [hs, BitVec.getLsbD_of_ge a (i - s) (by omega)]

/-- A zero-extended value shifted past another's bits shares none with it. -/
public theorem zext_shl_and_zext {w v s n : Nat} (a : BitVec w) (b : BitVec v) (h : v ≤ s) :
    a.setWidth n <<< s &&& b.setWidth n = 0#n := by
  simpa using zext_shl_and_zext_shl (t := 0) (n := n) a b (Or.inr (by omega))

/-- A zero-extended value shares no bits with another shifted past it. -/
public theorem zext_and_zext_shl {w v t n : Nat} (a : BitVec w) (b : BitVec v) (h : w ≤ t) :
    a.setWidth n &&& b.setWidth n <<< t = 0#n := by
  simpa using zext_shl_and_zext_shl (s := 0) (n := n) a b (Or.inl (by omega))

/-- The low bits of a value shifted past them are zero. -/
public theorem zext_shl_extractLsb'_low {w s k n : Nat} (a : BitVec w) (h : k ≤ s) :
    (a.setWidth n <<< s).extractLsb' 0 k = 0#k := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_shiftLeft, BitVec.getLsbD_zero]
  simp [show i < s by omega]

end MLIR.Agave

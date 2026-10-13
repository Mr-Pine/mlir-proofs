module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_sha512_core_ref
public import Boringssl.Common.Memory

/-! Runs of 64-bit words stored at consecutive addresses. -/

namespace MLIR

open Memory

@[expose] public section

/-- `p + a`, `a + b ≤ c`, does not wrap by `b` when `p` does not wrap by `c`. -/
theorem Pointer.not_uaddOverflow_add {p : Pointer} {a b c : BitVec 64}
    (h : ¬p.offset.uaddOverflow c) (hab : a.toNat + b.toNat ≤ c.toNat) :
    ¬(p.add a).offset.uaddOverflow b := by
  simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, decide_eq_true_eq, ge_iff_le,
    Nat.not_le] at h ⊢
  omega

/-- `f 0 … f (n - 1)` as `64 n` bits, `f 0` lowest. -/
def wordsLE (f : Nat → BitVec 64) : (n : Nat) → BitVec (64 * n)
  | 0 => 0#0
  | n + 1 => (f n ++ wordsLE f n).cast (by omega)

theorem wordsLE_congr {f g : Nat → BitVec 64} :
    ∀ {n : Nat}, (∀ i < n, f i = g i) → wordsLE f n = wordsLE g n
  | 0, _ => rfl
  | n + 1, h => by rw [wordsLE, wordsLE, h n (by omega), wordsLE_congr fun i hi => h i (by omega)]

/-- `f 0 … f (n - 1)` stored as 64-bit words at `p`, `p + 8`, …, in that order. -/
def MemoryState.storeWords (m : MemoryState) (p : Pointer) (f : Nat → BitVec 64) : Nat → MemoryState
  | 0 => m
  | n + 1 => (m.storeWords p f n).storeAt (p.add (BitVec.ofNat 64 (8 * n))) (f n)

theorem MemoryState.storeWords_zero {m : MemoryState} : m.storeWords p f 0 = m :=
  rfl

theorem MemoryState.storeWords_succ {m : MemoryState} :
    m.storeWords p f (n + 1) =
      (m.storeWords p f n).storeAt (p.add (BitVec.ofNat 64 (8 * n))) (f n) :=
  rfl

/-- A store of a cast is the store. -/
theorem MemoryState.storeAt_cast {m : MemoryState} {x : BitVec v} (h : v = w) :
    m.storeAt p (x.cast h) = m.storeAt p x := by
  subst h
  rfl

/-- The words as one store. -/
theorem MemoryState.storeWords_eq_storeAt {m : MemoryState} (hp : p.offset.toNat + 8 * n < 2 ^ 64) :
    m.storeWords p f n = m.storeAt p (wordsLE f n) := by
  induction n with
  | zero =>
    simp only [storeWords, wordsLE]
    exact (MemoryState.storeAt_of_width_zero rfl).symm
  | succ n
    ih =>
    have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (8 * n)) := by
      simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega
    rw [storeWords_succ, ih (by omega),
      MemoryState.storeAt_storeAt_append hov (by omega) (by omega), wordsLE, storeAt_cast]

/-- Word `t`'s pointer, offsets in bits, without overflow. -/
theorem Pointer.offsetInBits_word {p : Pointer} (hp : p.offset.toNat + 8 * n < 2 ^ 64)
    (ht : t ≤ n) : (p.add (BitVec.ofNat 64 (8 * t))).offsetInBits = p.offsetInBits + 64 * t := by
  simp only [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (a := 8 * t) (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A read disjoint from the words. -/
@[mlir_read]
theorem MemoryState.readAt_storeWords_of_disjoint {m : MemoryState}
    (hp : p.offset.toNat + 8 * n < 2 ^ 64) (h : (Range.of p (64 * n)).Disjoint (Range.of q w)) :
    (m.storeWords p f n).readAt q w = m.readAt q w := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [storeWords_succ, readAt_storeAt_disjoint, ih (by omega)]
    · simp only [Range.Disjoint, Range.of] at h ⊢
      rcases h with h | h | h
      · exact .inl h
      · exact .inr (.inl (by omega))
      · exact .inr (.inr h)
    · simp only [Range.Disjoint, Range.of, Pointer.add_id,
        Pointer.offsetInBits_word hp (Nat.le_succ n)] at h ⊢
      rcases h with h | h | h
      · exact .inl h
      · exact .inr (.inl (by omega))
      · exact .inr (.inr (by omega))

/-- `storeWords` keeps every block and its length. -/
@[simp]
theorem InBounds.storeWords_iff {m : MemoryState} :
    InBounds (m.storeWords p f n) q w ↔ InBounds m q w := by
  induction n with
  | zero => rfl
  | succ n ih => rw [MemoryState.storeWords_succ, InBounds.storeAt_iff, ih]

/-- `storeWords` keeps every block, its length and lifetime. -/
@[simp]
theorem Room.storeWords_iff {m : MemoryState} : Room (m.storeWords p f n) q w ↔ Room m q w := by
  induction n with
  | zero => rfl
  | succ n ih => rw [MemoryState.storeWords_succ, Room.storeAt_iff, ih]

/-- Word `t < n` of the words. -/
@[mlir_read]
theorem MemoryState.readAt_storeWords_self {m : MemoryState} (hm : Room m p (64 * n))
    (hp : p.offset.toNat + 8 * n < 2 ^ 64) (ht : t < n) :
    (m.storeWords p f n).readAt (p.add (BitVec.ofNat 64 (8 * t))) 64 = f t := by
  induction n with
  | zero => omega
  | succ n ih =>
    rw [storeWords_succ]
    by_cases htn : t = n
    · subst htn
      refine readAt_storeAt_self ?_ _
      rw [Room.storeWords_iff]
      obtain ⟨⟨blk, hblk, hl, hsz⟩, hw⟩ := hm
      refine ⟨⟨blk, hblk, hl, ?_⟩, hw.of_id_eq rfl⟩
      rw [Pointer.offsetInBits_word hp (Nat.le_succ t)]
      omega
    · rw [readAt_storeAt_disjoint, ih _ (by omega) (by omega)]
      · obtain ⟨⟨blk, hblk, hl, hsz⟩, hw⟩ := hm
        exact ⟨⟨blk, hblk, hl, by omega⟩, hw⟩
      · simp only [Range.Disjoint, Range.of, Pointer.add_id,
          Pointer.offsetInBits_word hp (Nat.le_succ n),
          Pointer.offsetInBits_word hp (show t ≤ n + 1 by omega)]
        omega

@[mlir_transport]
theorem InBounds.storeWords {m : MemoryState} (h : InBounds m q w) :
    InBounds (m.storeWords p f n) q w :=
  InBounds.storeWords_iff.2 h

@[mlir_transport]
theorem Room.storeWords {m : MemoryState} (h : Room m q w) : Room (m.storeWords p f n) q w :=
  Room.storeWords_iff.2 h

/-- `storeWords` keeps every block's writability. -/
@[mlir_transport]
theorem Writable.storeWords {m : MemoryState} (h : Writable m q) :
    Writable (m.storeWords p f n) q := by
  induction n with
  | zero => exact h
  | succ n ih => rw [MemoryState.storeWords_succ]; exact ih.storeAt

/-- `storeWords` keeps known bits known. -/
@[mlir_transport]
theorem Fits.storeWords {m : MemoryState} (h : Fits m q w) : Fits (m.storeWords p f n) q w := by
  induction n with
  | zero => exact h
  | succ n ih => exact ih.storeAt

/-- Word `t < n` of the words is known. -/
theorem Fits.storeWords_self {m : MemoryState} (h : Room m p (64 * n))
    (hp : p.offset.toNat + 8 * n < 2 ^ 64) (ht : t < n) :
    Fits (m.storeWords p f n) (p.add (BitVec.ofNat 64 (8 * t))) 64 := by
  induction n with
  | zero => omega
  | succ n ih =>
    rw [MemoryState.storeWords_succ]
    by_cases htn : t = n
    · subst htn
      refine Fits.storeAt_self ?_
      rw [Room.storeWords_iff]
      obtain ⟨⟨blk, hblk, hl, hsz⟩, hw⟩ := h
      refine ⟨⟨blk, hblk, hl, ?_⟩, hw.of_id_eq rfl⟩
      rw [Pointer.offsetInBits_word hp (Nat.le_succ t)]
      omega
    · refine (ih ?_ (by omega) (by omega)).storeAt
      obtain ⟨⟨blk, hblk, hl, hsz⟩, hw⟩ := h
      exact ⟨⟨blk, hblk, hl, by omega⟩, hw⟩

/-- `storeWords` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeWords {s : GlobalState} :
    ({ s with mem := m.storeWords p f n } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  induction n with
  | zero => rfl
  | succ n ih => rw [MemoryState.storeWords_succ, GlobalState.WF_storeAt, ih]

@[mlir_transport]
theorem GlobalState.WF.storeWords {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeWords p f n } : GlobalState).WF :=
  GlobalState.WF_storeWords.2 h

/-- Erasing a frame commutes with storing words. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeWords {m : MemoryState} :
    (m.storeWords p f n).eraseFrom k = (m.eraseFrom k).storeWords p f n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [storeWords_succ, eraseFrom_storeAt, ih, storeWords_succ]

/-- Words stored into an erased block: nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeWords_eraseFrom_of_le {m : MemoryState} (h : k ≤ p.id.id) :
    (m.eraseFrom k).storeWords p f n = m.eraseFrom k := by
  induction n with
  | zero => rfl
  | succ n ih => rw [storeWords_succ, ih, storeAt_eraseFrom_of_le (by simpa using h)]

end

end MLIR

module

public import MLIR.Run.Tactic
public import Ed25519.Sha512

/-! sha2's SHA-512 objects in memory: the state words `[u64; 8]`, and `Sha512` (the core's state
and block count, the block buffer), with what it has absorbed. -/

namespace MLIR

@[expose] public section

/-- The eight state words at `p`. Each word's pointer is spelled as `getelementptr` produces it,
so facts, steps and specs match syntactically. -/
def MemoryState.readSha512 (m : MemoryState) (p : Pointer) : Vector (BitVec 64) 8 :=
  #v[m.readAt p 64, m.readAt (p.add 8#64) 64, m.readAt (p.add 16#64) 64, m.readAt (p.add 24#64) 64,
    m.readAt (p.add 32#64) 64, m.readAt (p.add 40#64) 64, m.readAt (p.add 48#64) 64,
    m.readAt (p.add 56#64) 64]

/-- The eight state words stored at `p` as `compress512` stores them: words `1 … 7`, then `0`. -/
def MemoryState.storeSha512 (m : MemoryState) (p : Pointer) (v : Vector (BitVec 64) 8) :
    MemoryState :=
  (((((((m.storeAt (p.add 8#64) v[1]).storeAt (p.add 16#64) v[2]).storeAt (p.add 24#64)
                        v[3]).storeAt
                    (p.add 32#64) v[4]).storeAt
                (p.add 40#64) v[5]).storeAt
            (p.add 48#64) v[6]).storeAt
        (p.add 56#64) v[7]).storeAt
    p v[0]

/-- Each state word at `p` fits, and the word offsets do not wrap. -/
abbrev MemoryState.Sha512Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 56 < 2 ^ 64 ∧
    Fits m p 64 ∧
    Fits m (p.add 8#64) 64 ∧
    Fits m (p.add 16#64) 64 ∧
    Fits m (p.add 24#64) 64 ∧
    Fits m (p.add 32#64) 64 ∧
    Fits m (p.add 40#64) 64 ∧ Fits m (p.add 48#64) 64 ∧ Fits m (p.add 56#64) 64

end

attribute [mlir_mem] MemoryState.Sha512Fit

namespace MemoryState

@[mlir_mem, mlir_transport]
public theorem Sha512Fit.storeAt {m : MemoryState} (h : m.Sha512Fit p) :
    (m.storeAt q x).Sha512Fit p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt,
    h.2.2.2.2.2.1.storeAt, h.2.2.2.2.2.2.1.storeAt, h.2.2.2.2.2.2.2.1.storeAt,
    h.2.2.2.2.2.2.2.2.storeAt⟩

/-- A new block keeps state words that fit. -/
@[mlir_mem, mlir_transport]
public theorem Sha512Fit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Sha512Fit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Sha512Fit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.addBlock hwf, h1.addBlock hwf, h2.addBlock hwf, h3.addBlock hwf, h4.addBlock hwf,
      h5.addBlock hwf, h6.addBlock hwf, h7.addBlock hwf⟩

/-- Erasing a frame commutes with storing the state words. -/
@[mlir_frame, mlir_erase]
public theorem eraseFrom_storeSha512 {m : MemoryState} :
    (m.storeSha512 p v).eraseFrom n = (m.eraseFrom n).storeSha512 p v := by
  simp [storeSha512, eraseFrom_storeAt]

end MemoryState

@[mlir_transport]
public theorem GlobalState.WF.storeSha512 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeSha512 p v } : GlobalState).WF := by
  unfold MemoryState.storeSha512
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

/-- `storeSha512` keeps every block, its length and lifetime. -/
@[simp]
public theorem Room.storeSha512_iff {m : MemoryState} :
    Room (m.storeSha512 q v) p w ↔ Room m p w := by simp [MemoryState.storeSha512]

@[mlir_transport]
public theorem Fits.storeSha512 {m : MemoryState} (h : Fits m p w) : Fits (m.storeSha512 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
public theorem Room.storeSha512 {m : MemoryState} (h : Room m p w) : Room (m.storeSha512 q v) p w :=
  Room.storeSha512_iff.2 h

@[mlir_transport]
public theorem InBounds.storeSha512 {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeSha512 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
public theorem MemoryState.Sha512Fit.storeSha512 {m : MemoryState} (h : m.Sha512Fit p) :
    (m.storeSha512 q v).Sha512Fit p :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

/-- `WF.storeSha512` for a state written as a constructor, as a framed callee leaves it. -/
@[mlir_transport]
public theorem GlobalState.WF.storeSha512_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeSha512 p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeSha512 (s := ⟨a, m⟩) h

/-- A read outside the state words is unaffected by `storeSha512`. -/
@[mlir_read]
public theorem MemoryState.readAt_storeSha512_of_disjoint {m : MemoryState}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (h : (Range.of p 512).Disjoint (Range.of q w)) :
    (m.storeSha512 p v).readAt q w = m.readAt q w := by
  have hw :
    ∀ k : Nat, k ≤ 56 → (Range.of (p.add (BitVec.ofNat 64 k)) 64).Disjoint (Range.of q w) := by
    intro k hk
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at h ⊢
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    rcases h with h | h
    · exact Or.inl h
    · right; omega
  have h0 : (Range.of p 64).Disjoint (Range.of q w) := by simpa using hw 0 (by decide)
  unfold MemoryState.storeSha512
  rw [MemoryState.readAt_storeAt_disjoint h0,
    MemoryState.readAt_storeAt_disjoint (hw 56 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 48 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 40 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 32 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 24 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 16 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 8 (by decide))]

/-! ## sha2's `Sha512` -/

open _root_.Ed25519

@[expose] public section

/-- sha2's `Sha512` at `d`, 208 bytes: the block buffer at `d`, its length in its last byte
`d + 127`, the state words at `d + 128`, the blocks' count (`u128`) at `d + 192`. It has absorbed
the bytes `M`: their whole blocks compressed from `IV` and counted, the rest buffered. -/
structure MemoryState.Sha2Absorbed (m : MemoryState) (d : Pointer) (M : List (BitVec 8)) :
    Prop where
  off : d.offset.toNat + 208 < 2 ^ 64
  room : Room m d 1664
  posFits : Fits m (d.add 127#64) 8
  pos : (m.readAt (d.add 127#64) 8).toNat = M.length % 128
  bufFits : Fits m d (8 * (M.length % 128))
  buf : bytesLE (m.readAt d (8 * (M.length % 128))) = M.drop (M.length / 128 * 128)
  stateFit : m.Sha512Fit (d.add 128#64)
  state : m.readSha512 (d.add 128#64) = Sha512.compressBlocks Sha512.IV M
  countFits : Fits m (d.add 192#64) 128
  count : m.readAt (d.add 192#64) 128 = BitVec.ofNat 128 (M.length / 128)

/-- sha2's `Sha512` at `d` between blocks: the whole blocks `M` compressed from `IV` and counted,
the buffer's contents not needed. -/
structure MemoryState.Sha2Blocks (m : MemoryState) (d : Pointer) (M : List (BitVec 8)) : Prop where
  off : d.offset.toNat + 208 < 2 ^ 64
  room : Room m d 1664
  stateFit : m.Sha512Fit (d.add 128#64)
  state : m.readSha512 (d.add 128#64) = Sha512.compressBlocks Sha512.IV M
  countFits : Fits m (d.add 192#64) 128
  count : m.readAt (d.add 192#64) 128 = BitVec.ofNat 128 (M.length / 128)
  whole : M.length % 128 = 0

end

/-- A read of `w + v` bits: the `w` bits after the first `v`, then the first `v`. -/
public theorem MemoryState.readAt_append {m : MemoryState} {p : Pointer} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hv : off.toNat * 8 = v) :
    m.readAt p (w + v) = m.readAt (p.add off) w ++ m.readAt p v := by
  simp only [MemoryState.readAt, Pointer.add_id]
  split
  · rw [Pointer.offsetInBits_add hov, hv]
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_append, hi, decide_true, Bool.true_and]
    split
    · simp_all
    · simp only [show i - v < w by omega, decide_true, Bool.true_and]
      congr 1
      omega
  · simp

/-- The bytes of a read of `v + w` bits: the first `v`'s, then the next `w`'s. -/
public theorem MemoryState.bytesLE_readAt_append {m : MemoryState} {p : Pointer} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hv : off.toNat * 8 = v) (h8 : v % 8 = 0) :
    bytesLE (m.readAt p (v + w)) = bytesLE (m.readAt p v) ++ bytesLE (m.readAt (p.add off) w) := by
  rw [Nat.add_comm, MemoryState.readAt_append hov hv, bytesLE_append _ _ h8]

/-- The state words past a store apart from them. -/
public theorem MemoryState.readSha512_storeAt_of_disjoint {m : MemoryState} {x : BitVec v}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (h : (Range.of q v).Disjoint (Range.of p 512)) :
    (m.storeAt q x).readSha512 p = m.readSha512 p := by
  have hw :
    ∀ k : Nat, k ≤ 56 → (Range.of q v).Disjoint (Range.of (p.add (BitVec.ofNat 64 k)) 64) := by
    intro k hk
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at h ⊢
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    rcases h with h | h | h
    · exact Or.inl h
    · right; left; omega
    · right; right; omega
  have h0 : (Range.of q v).Disjoint (Range.of p 64) := by simpa using hw 0 (by decide)
  simp only [MemoryState.readSha512, MemoryState.readAt_storeAt_disjoint h0,
    MemoryState.readAt_storeAt_disjoint (hw 8 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 16 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 24 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 32 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 40 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 48 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 56 (by decide))]

/-- Two words of the state words at `p`, apart. -/
theorem word_disj {p : Pointer} (hp : p.offset.toNat + 56 < 2 ^ 64) {a b : BitVec 64}
    (ha : a.toNat ≤ 56) (hb : b.toNat ≤ 56) (h : a.toNat + 8 ≤ b.toNat ∨ b.toNat + 8 ≤ a.toNat) :
    (Range.of (p.add a) 64).Disjoint (Range.of (p.add b) 64) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- The first word of the state words at `p` and another, apart. -/
theorem word_disj0 {p : Pointer} (hp : p.offset.toNat + 56 < 2 ^ 64) {b : BitVec 64}
    (hb : b.toNat ≤ 56) (h : 8 ≤ b.toNat) : (Range.of (p.add b) 64).Disjoint (Range.of p 64) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- The state words stored at `p`, read back. -/
public theorem MemoryState.readSha512_storeSha512_self {m : MemoryState}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (h : Room m p 512) :
    (m.storeSha512 p v).readSha512 p = v := by
  have hb (k : BitVec 64) (hk : k.toNat ≤ 56) : Room m (p.add k) 64 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by omega) h
  have h0 : Room m p 64 := Room.mono (by decide) h
  simp (disch :=
    first
    |
      exact
        Room.storeAt
          (Room.storeAt
            (Room.storeAt
              (Room.storeAt
                (Room.storeAt (Room.storeAt (Room.storeAt (hb _ (by decide))))))))
    | exact h0.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
    |
      exact
        Room.storeAt
          (Room.storeAt
            (Room.storeAt
              (Room.storeAt (Room.storeAt (Room.storeAt (hb _ (by decide)))))))
    |
      exact
        Room.storeAt
          (Room.storeAt
            (Room.storeAt (Room.storeAt (Room.storeAt (hb _ (by decide))))))
    |
      exact
        Room.storeAt (Room.storeAt (Room.storeAt (Room.storeAt (hb _ (by decide)))))
    | exact Room.storeAt (Room.storeAt (Room.storeAt (hb _ (by decide))))
    | exact Room.storeAt (Room.storeAt (hb _ (by decide)))
    | exact Room.storeAt (hb _ (by decide))
    | exact hb _ (by decide)
    | (refine word_disj0 hp ?_ ?_ <;> decide)
    | (refine (word_disj0 hp ?_ ?_).symm <;> decide)
    | (refine word_disj hp ?_ ?_ ?_ <;> decide)) only [MemoryState.readSha512,
    MemoryState.storeSha512, MemoryState.readAt_storeAt_self, MemoryState.readAt_storeAt_disjoint]
  ext i hi
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    first
    | rfl
    | omega

end MLIR

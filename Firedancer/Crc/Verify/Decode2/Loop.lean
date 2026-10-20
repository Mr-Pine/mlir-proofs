module

public import Firedancer.Crc.Verify.Decode2.Frame
import Firedancer.Crc.Verify.Decode2.Tactics
import Firedancer.Crc.Verify.QuadRuns

/-! The four squaring loops of `fd_r52x5_ge_decode2`'s power: one iteration each, the loops from it. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

/-- The counter's test at `N`, back in `ℕ`. -/
theorem counter_eq {i N : Nat} (hN : N < 2 ^ 31) (hi : i + 1 ≤ N)
    (h : BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 = N := by
  have := congrArg BitVec.toNat h
  simp [BitVec.toNat_add] at this
  omega

theorem counter_ne {i N : Nat} (hN : N < 2 ^ 31) (hi : i + 1 ≤ N)
    (h : ¬BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 < N := by
  rcases Nat.lt_or_eq_of_le hi with h' | h'
  · exact h'
  · subst h'
    exact absurd (by rw [BitVec.ofNat_add]) h

section Loops

variable {β : Type} (k exit : Fin 16) (N lo hi : Nat) (hdr : ⟪Γ⟫ → Quad5 → Nat → ⟪Γ⟫)
  (Pre : ⟪Γ⟫ → Prop) (Out : ⟪Γ⟫ → Quad5 → Prop) (B : GlobalState) (M : MemoryState) (c : Nat)
  (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)

/-- One iteration of the loop at header `k` (env `hdr E X i` at counter `i`, registers
`lo … hi - 1` written): the square, count, test; on to `exit` after the `N`-th, the square in
`Out`, else around. -/
abbrev LoopIter : Prop :=
  ∀ i (S : GlobalState) (E : ⟪Γ⟫) (X : Quad5),
    Inv B M c S →
      Pre E →
      i + 1 ≤ N →
      (i + 1 = N →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          Writes E E' lo hi →
            Out E' (sqrQ X) →
            Inv B M c S' → (fd_r52x5_ge_decode2.runFrom E' exit S' >>= g) = K) →
      (i + 1 < N →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          Writes E E' lo hi →
            Inv B M c S' →
            (fd_r52x5_ge_decode2.runFrom (hdr E' (sqrQ X) (i + 1)) k S' >>= g) = K) →
      (fd_r52x5_ge_decode2.runFrom (hdr E X i) k S >>= g) = K

/-- The loop at header `k` from counter `i`, `n + 1` iterations left: `X` squared `n + 1` times. -/
abbrev Loop : Prop :=
  ∀ n i (S : GlobalState) (E : ⟪Γ⟫) (X : Quad5),
    i + n + 1 = N →
      Inv B M c S →
      Pre E →
      (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        Writes E E' lo hi →
          Out E' (sqrNQ (n + 1) X) →
          Inv B M c S' → (fd_r52x5_ge_decode2.runFrom E' exit S' >>= g) = K) →
      (fd_r52x5_ge_decode2.runFrom (hdr E X i) k S >>= g) = K

variable {k exit N lo hi hdr Pre Out B M c g K} in
/-- The loop from one iteration, by induction on the iterations left. -/
theorem loop_of_iter (h : LoopIter k exit N lo hi hdr Pre Out B M c g K)
    (hPre : ∀ E E', Writes E E' lo hi → Pre E → Pre E') :
    Loop k exit N lo hi hdr Pre Out B M c g K := by
  intro n
  induction n with
  | zero =>
    intro i S E X hi hI hP hK
    exact h i S E X hI hP (by omega) (fun _ => hK) (by omega)
  | succ n ih =>
    intro i S E X hi hI hP hK
    refine h i S E X hI hP (by omega) (by omega) fun _ E' S' hB hI' => ?_
    refine
      ih (i + 1) S' E' (sqrQ X) (by omega) hI' (hPre E E' hB hP) fun E'' S'' hB' hO hI'' => ?_
    exact hK E'' S'' (hB.trans hB') hO hI''

end Loops

private theorem ofNat_add_one32 (i : Nat) : BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 (i + 1) :=
  (BitVec.ofNat_add i 1).symm

private theorem Inv.slots {B : GlobalState} {M : MemoryState} {c : Nat} :
    ∀ s, Inv B M c s → s.WF ∧ SlotFrame B 246 s.mem := fun _ h =>
  ⟨h.wf, fun j hj => ⟨(h.frame j hj).1.mono (by unfold slotBytes; split_ifs <;> decide),
    (h.frame j hj).2⟩⟩

private theorem Inv.callTmp5_slots {B : GlobalState} {M : MemoryState} {c : Nat} :
    ∀ s j0 j1 j2 j3 j4 Q, Inv B M c s →
      Inv B M c
        ⟨s.alloc, s.mem.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q⟩ :=
  fun _ _ _ _ _ _ _ h =>
    ⟨h.wf.callTmp5, h.frame.callTmp5, eraseFrom_callTmp5_slot.trans h.erase, h.alloc⟩

/-! ### `^bb2`: `20` squarings -/

/-- `^bb2`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr2 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 648 := Ty.wrap X.P0, rir_dst% hty 649 := Ty.wrap X.P1, rir_dst% hty 650 :=
    Ty.wrap X.P2, rir_dst% hty 651 := Ty.wrap X.P3, rir_dst% hty 652 := Ty.wrap X.P4,
    rir_dst% hty 653 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb2` reads of the entry: its temporaries `B.slot 117 …`, the constants. -/
abbrev pre2 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 256 := B.slot 117, rir_reg% hty 257 := B.slot 118, rir_reg% hty 258 :=
    B.slot 119, rir_reg% hty 259 := B.slot 120, rir_reg% hty 260 := B.slot 121,
    rir_reg% hty 58 := 1#32, rir_reg% hty 47 := 20#32]

/-- `^bb2`'s square, as `^bb1` reads it. -/
abbrev out2 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 654 := Y.P0, rir_reg% hty 655 := Y.P1, rir_reg% hty 656 := Y.P2,
    rir_reg% hty 657 := Y.P3, rir_reg% hty 658 := Y.P4]

theorem iter2 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 2 1 20 648 661 hdr2 (pre2 B) out2 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  subst hQ0 hv658
  step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ‹_›
    · rw [hE]
      writes_chain
    · lemma_reads
  · subst hS
    rw [hE, ofNat_add_one32 i]
    exact hback (counter_ne (by decide) hi hbr) _ _ (by writes_chain) ‹_›

/-- The loop at `^bb2`, from `iter2`. -/
theorem loop2 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 2 1 20 648 661 hdr2 (pre2 B) out2 B M c g K :=
  loop_of_iter (iter2 B M c g K) fun _ _ hB hP => by
    unfold pre2 at hP ⊢
    chain_reads

/-! ### `^bb4`: `50` squarings -/

/-- `^bb4`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr4 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 671 := Ty.wrap X.P0, rir_dst% hty 672 := Ty.wrap X.P1, rir_dst% hty 673 :=
    Ty.wrap X.P2, rir_dst% hty 674 := Ty.wrap X.P3, rir_dst% hty 675 := Ty.wrap X.P4,
    rir_dst% hty 676 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb4` reads of the entry: its temporaries `B.slot 147 …`, the constants. -/
abbrev pre4 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 286 := B.slot 147, rir_reg% hty 287 := B.slot 148, rir_reg% hty 288 :=
    B.slot 149, rir_reg% hty 289 := B.slot 150, rir_reg% hty 290 := B.slot 151,
    rir_reg% hty 58 := 1#32, rir_reg% hty 46 := 50#32]

/-- `^bb4`'s square, as `^bb3` reads it. -/
abbrev out4 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 677 := Y.P0, rir_reg% hty 678 := Y.P1, rir_reg% hty 679 := Y.P2,
    rir_reg% hty 680 := Y.P3, rir_reg% hty 681 := Y.P4]

theorem iter4 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 4 3 50 671 684 hdr4 (pre4 B) out4 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  subst hQ0 hv681
  step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ‹_›
    · rw [hE]
      writes_chain
    · lemma_reads
  · subst hS
    rw [hE, ofNat_add_one32 i]
    exact hback (counter_ne (by decide) hi hbr) _ _ (by writes_chain) ‹_›

/-- The loop at `^bb4`, from `iter4`. -/
theorem loop4 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 4 3 50 671 684 hdr4 (pre4 B) out4 B M c g K :=
  loop_of_iter (iter4 B M c g K) fun _ _ hB hP => by
    unfold pre4 at hP ⊢
    chain_reads

/-! ### `^bb6`: `100` squarings -/

/-- `^bb6`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr6 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 694 := Ty.wrap X.P0, rir_dst% hty 695 := Ty.wrap X.P1, rir_dst% hty 696 :=
    Ty.wrap X.P2, rir_dst% hty 697 := Ty.wrap X.P3, rir_dst% hty 698 := Ty.wrap X.P4,
    rir_dst% hty 699 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb6` reads of the entry: its temporaries `B.slot 162 …`, the constants. -/
abbrev pre6 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 301 := B.slot 162, rir_reg% hty 302 := B.slot 163, rir_reg% hty 303 :=
    B.slot 164, rir_reg% hty 304 := B.slot 165, rir_reg% hty 305 := B.slot 166,
    rir_reg% hty 58 := 1#32, rir_reg% hty 45 := 100#32]

/-- `^bb6`'s square, as `^bb5` reads it. -/
abbrev out6 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 700 := Y.P0, rir_reg% hty 701 := Y.P1, rir_reg% hty 702 := Y.P2,
    rir_reg% hty 703 := Y.P3, rir_reg% hty 704 := Y.P4]

theorem iter6 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 6 5 100 694 707 hdr6 (pre6 B) out6 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  subst hQ0 hv704
  step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ‹_›
    · rw [hE]
      writes_chain
    · lemma_reads
  · subst hS
    rw [hE, ofNat_add_one32 i]
    exact hback (counter_ne (by decide) hi hbr) _ _ (by writes_chain) ‹_›

/-- The loop at `^bb6`, from `iter6`. -/
theorem loop6 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 6 5 100 694 707 hdr6 (pre6 B) out6 B M c g K :=
  loop_of_iter (iter6 B M c g K) fun _ _ hB hP => by
    unfold pre6 at hP ⊢
    chain_reads

/-! ### `^bb8`: `50` squarings -/

/-- `^bb8`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr8 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 754 := Ty.wrap X.P0, rir_dst% hty 755 := Ty.wrap X.P1, rir_dst% hty 756 :=
    Ty.wrap X.P2, rir_dst% hty 757 := Ty.wrap X.P3, rir_dst% hty 758 := Ty.wrap X.P4,
    rir_dst% hty 759 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb8` reads of the entry: its temporaries `B.slot 177 …`, the constants. -/
abbrev pre8 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 316 := B.slot 177, rir_reg% hty 317 := B.slot 178, rir_reg% hty 318 :=
    B.slot 179, rir_reg% hty 319 := B.slot 180, rir_reg% hty 320 := B.slot 181,
    rir_reg% hty 58 := 1#32, rir_reg% hty 46 := 50#32]

/-- `^bb8`'s square, as `^bb7` reads it. -/
abbrev out8 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 760 := Y.P0, rir_reg% hty 761 := Y.P1, rir_reg% hty 762 := Y.P2,
    rir_reg% hty 763 := Y.P3, rir_reg% hty 764 := Y.P4]

theorem iter8 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 8 7 50 754 767 hdr8 (pre8 B) out8 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  subst hQ0 hv764
  step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ‹_›
    · rw [hE]
      writes_chain
    · lemma_reads
  · subst hS
    rw [hE, ofNat_add_one32 i]
    exact hback (counter_ne (by decide) hi hbr) _ _ (by writes_chain) ‹_›

/-- The loop at `^bb8`, from `iter8`. -/
theorem loop8 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 8 7 50 754 767 hdr8 (pre8 B) out8 B M c g K :=
  loop_of_iter (iter8 B M c g K) fun _ _ hB hP => by
    unfold pre8 at hP ⊢
    chain_reads

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify

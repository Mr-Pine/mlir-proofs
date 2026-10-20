module

public import Firedancer.Crc.Verify.Decode2.Frame
import Firedancer.Crc.Verify.Decode2.Tactics
import Firedancer.Crc.Verify.QuadRuns

/-! The quad call sites of `fd_r52x5_ge_decode2`'s `^bb1`, `^bb3`, `^bb5` and `^bb7`. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

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

set_option maxHeartbeats 4000000 in
/-- `^bb1`'s sites `0` to `64`. -/
theorem bb1g0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1357 Q1276 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 654 := Ty.wrap Q1357.P0,
      rir_reg% hty 655 := Ty.wrap Q1357.P1,
      rir_reg% hty 656 := Ty.wrap Q1357.P2,
      rir_reg% hty 657 := Ty.wrap Q1357.P3,
      rir_reg% hty 658 := Ty.wrap Q1357.P4,
      rir_reg% hty 573 := Ty.wrap Q1276.P0,
      rir_reg% hty 574 := Ty.wrap Q1276.P1,
      rir_reg% hty 575 := Ty.wrap Q1276.P2,
      rir_reg% hty 576 := Ty.wrap Q1276.P3,
      rir_reg% hty 577 := Ty.wrap Q1276.P4,
      rir_reg% hty 261 := PoisonOr.value (B.slot 122),
      rir_reg% hty 262 := PoisonOr.value (B.slot 123),
      rir_reg% hty 263 := PoisonOr.value (B.slot 124),
      rir_reg% hty 264 := PoisonOr.value (B.slot 125),
      rir_reg% hty 265 := PoisonOr.value (B.slot 126),
      rir_reg% hty 266 := PoisonOr.value (B.slot 127),
      rir_reg% hty 267 := PoisonOr.value (B.slot 128),
      rir_reg% hty 268 := PoisonOr.value (B.slot 129),
      rir_reg% hty 269 := PoisonOr.value (B.slot 130),
      rir_reg% hty 270 := PoisonOr.value (B.slot 131),
      rir_reg% hty 271 := PoisonOr.value (B.slot 132),
      rir_reg% hty 272 := PoisonOr.value (B.slot 133),
      rir_reg% hty 273 := PoisonOr.value (B.slot 134),
      rir_reg% hty 274 := PoisonOr.value (B.slot 135),
      rir_reg% hty 275 := PoisonOr.value (B.slot 136)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 583 603 →
      (E' ⊨ [rir_reg% hty 583 := Ty.wrap (mulQ Q1357 Q1276).P0,
        rir_reg% hty 584 := Ty.wrap (mulQ Q1357 Q1276).P1,
        rir_reg% hty 585 := Ty.wrap (mulQ Q1357 Q1276).P2,
        rir_reg% hty 586 := Ty.wrap (mulQ Q1357 Q1276).P3,
        rir_reg% hty 587 := Ty.wrap (mulQ Q1357 Q1276).P4,
        rir_reg% hty 588 := Ty.wrap (sqrQ (mulQ Q1357 Q1276)).P0,
        rir_reg% hty 589 := Ty.wrap (sqrQ (mulQ Q1357 Q1276)).P1,
        rir_reg% hty 590 := Ty.wrap (sqrQ (mulQ Q1357 Q1276)).P2,
        rir_reg% hty 591 := Ty.wrap (sqrQ (mulQ Q1357 Q1276)).P3,
        rir_reg% hty 592 := Ty.wrap (sqrQ (mulQ Q1357 Q1276)).P4,
        rir_reg% hty 593 := Ty.wrap (sqrQ (sqrQ (mulQ Q1357 Q1276))).P0,
        rir_reg% hty 594 := Ty.wrap (sqrQ (sqrQ (mulQ Q1357 Q1276))).P1,
        rir_reg% hty 595 := Ty.wrap (sqrQ (sqrQ (mulQ Q1357 Q1276))).P2,
        rir_reg% hty 596 := Ty.wrap (sqrQ (sqrQ (mulQ Q1357 Q1276))).P3,
        rir_reg% hty 597 := Ty.wrap (sqrQ (sqrQ (mulQ Q1357 Q1276))).P4,
        rir_reg% hty 598 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))).P0,
        rir_reg% hty 599 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))).P1,
        rir_reg% hty 600 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))).P2,
        rir_reg% hty 601 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))).P3,
        rir_reg% hty 602 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))).P4]) →
      Inv B M c S' → (bb1.runBodyFrom E' 64 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 0 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv587 hv592 hv597 hv602 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb1`'s sites `64` to `128`. -/
theorem bb1g1_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1301 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 598 := Ty.wrap Q1301.P0,
      rir_reg% hty 599 := Ty.wrap Q1301.P1,
      rir_reg% hty 600 := Ty.wrap Q1301.P2,
      rir_reg% hty 601 := Ty.wrap Q1301.P3,
      rir_reg% hty 602 := Ty.wrap Q1301.P4,
      rir_reg% hty 271 := PoisonOr.value (B.slot 132),
      rir_reg% hty 272 := PoisonOr.value (B.slot 133),
      rir_reg% hty 273 := PoisonOr.value (B.slot 134),
      rir_reg% hty 274 := PoisonOr.value (B.slot 135),
      rir_reg% hty 275 := PoisonOr.value (B.slot 136)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 603 623 →
      (E' ⊨ [rir_reg% hty 603 := Ty.wrap (sqrQ Q1301).P0,
        rir_reg% hty 604 := Ty.wrap (sqrQ Q1301).P1,
        rir_reg% hty 605 := Ty.wrap (sqrQ Q1301).P2,
        rir_reg% hty 606 := Ty.wrap (sqrQ Q1301).P3,
        rir_reg% hty 607 := Ty.wrap (sqrQ Q1301).P4,
        rir_reg% hty 608 := Ty.wrap (sqrQ (sqrQ Q1301)).P0,
        rir_reg% hty 609 := Ty.wrap (sqrQ (sqrQ Q1301)).P1,
        rir_reg% hty 610 := Ty.wrap (sqrQ (sqrQ Q1301)).P2,
        rir_reg% hty 611 := Ty.wrap (sqrQ (sqrQ Q1301)).P3,
        rir_reg% hty 612 := Ty.wrap (sqrQ (sqrQ Q1301)).P4,
        rir_reg% hty 613 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1301))).P0,
        rir_reg% hty 614 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1301))).P1,
        rir_reg% hty 615 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1301))).P2,
        rir_reg% hty 616 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1301))).P3,
        rir_reg% hty 617 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1301))).P4,
        rir_reg% hty 618 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1301)))).P0,
        rir_reg% hty 619 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1301)))).P1,
        rir_reg% hty 620 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1301)))).P2,
        rir_reg% hty 621 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1301)))).P3,
        rir_reg% hty 622 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1301)))).P4]) →
      Inv B M c S' → (bb1.runBodyFrom E' 128 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 64 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv607 hv612 hv617 hv622 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb1`'s sites `128` to `192`. -/
theorem bb1g2_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1321 Q1221 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 618 := Ty.wrap Q1321.P0,
      rir_reg% hty 619 := Ty.wrap Q1321.P1,
      rir_reg% hty 620 := Ty.wrap Q1321.P2,
      rir_reg% hty 621 := Ty.wrap Q1321.P3,
      rir_reg% hty 622 := Ty.wrap Q1321.P4,
      rir_reg% hty 271 := PoisonOr.value (B.slot 132),
      rir_reg% hty 272 := PoisonOr.value (B.slot 133),
      rir_reg% hty 273 := PoisonOr.value (B.slot 134),
      rir_reg% hty 274 := PoisonOr.value (B.slot 135),
      rir_reg% hty 275 := PoisonOr.value (B.slot 136),
      rir_reg% hty 518 := Ty.wrap Q1221.P0,
      rir_reg% hty 519 := Ty.wrap Q1221.P1,
      rir_reg% hty 520 := Ty.wrap Q1221.P2,
      rir_reg% hty 521 := Ty.wrap Q1221.P3,
      rir_reg% hty 522 := Ty.wrap Q1221.P4,
      rir_reg% hty 276 := PoisonOr.value (B.slot 137),
      rir_reg% hty 277 := PoisonOr.value (B.slot 138),
      rir_reg% hty 278 := PoisonOr.value (B.slot 139),
      rir_reg% hty 279 := PoisonOr.value (B.slot 140),
      rir_reg% hty 280 := PoisonOr.value (B.slot 141)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 623 643 →
      (E' ⊨ [rir_reg% hty 623 := Ty.wrap (sqrQ Q1321).P0,
        rir_reg% hty 624 := Ty.wrap (sqrQ Q1321).P1,
        rir_reg% hty 625 := Ty.wrap (sqrQ Q1321).P2,
        rir_reg% hty 626 := Ty.wrap (sqrQ Q1321).P3,
        rir_reg% hty 627 := Ty.wrap (sqrQ Q1321).P4,
        rir_reg% hty 628 := Ty.wrap (sqrQ (sqrQ Q1321)).P0,
        rir_reg% hty 629 := Ty.wrap (sqrQ (sqrQ Q1321)).P1,
        rir_reg% hty 630 := Ty.wrap (sqrQ (sqrQ Q1321)).P2,
        rir_reg% hty 631 := Ty.wrap (sqrQ (sqrQ Q1321)).P3,
        rir_reg% hty 632 := Ty.wrap (sqrQ (sqrQ Q1321)).P4,
        rir_reg% hty 633 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1321))).P0,
        rir_reg% hty 634 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1321))).P1,
        rir_reg% hty 635 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1321))).P2,
        rir_reg% hty 636 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1321))).P3,
        rir_reg% hty 637 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1321))).P4,
        rir_reg% hty 638 := Ty.wrap (mulQ (sqrQ (sqrQ (sqrQ Q1321))) Q1221).P0,
        rir_reg% hty 639 := Ty.wrap (mulQ (sqrQ (sqrQ (sqrQ Q1321))) Q1221).P1,
        rir_reg% hty 640 := Ty.wrap (mulQ (sqrQ (sqrQ (sqrQ Q1321))) Q1221).P2,
        rir_reg% hty 641 := Ty.wrap (mulQ (sqrQ (sqrQ (sqrQ Q1321))) Q1221).P3,
        rir_reg% hty 642 := Ty.wrap (mulQ (sqrQ (sqrQ (sqrQ Q1321))) Q1221).P4]) →
      Inv B M c S' → (bb1.runBodyFrom E' 192 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 128 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q3
  subst hv627 hv632 hv637 hv642 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb1`'s sites `192` to `208`. -/
theorem bb1g3_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1341 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 638 := Ty.wrap Q1341.P0,
      rir_reg% hty 639 := Ty.wrap Q1341.P1,
      rir_reg% hty 640 := Ty.wrap Q1341.P2,
      rir_reg% hty 641 := Ty.wrap Q1341.P3,
      rir_reg% hty 642 := Ty.wrap Q1341.P4,
      rir_reg% hty 281 := PoisonOr.value (B.slot 142),
      rir_reg% hty 282 := PoisonOr.value (B.slot 143),
      rir_reg% hty 283 := PoisonOr.value (B.slot 144),
      rir_reg% hty 284 := PoisonOr.value (B.slot 145),
      rir_reg% hty 285 := PoisonOr.value (B.slot 146)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 643 648 →
      (E' ⊨ [rir_reg% hty 643 := Ty.wrap (sqrQ Q1341).P0,
        rir_reg% hty 644 := Ty.wrap (sqrQ Q1341).P1,
        rir_reg% hty 645 := Ty.wrap (sqrQ Q1341).P2,
        rir_reg% hty 646 := Ty.wrap (sqrQ Q1341).P3,
        rir_reg% hty 647 := Ty.wrap (sqrQ Q1341).P4]) →
      Inv B M c S' → (bb1.runBodyFrom E' 208 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 192 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  subst hv647 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb3`'s sites `0` to `32`. -/
theorem bb3g0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1380 Q1341 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 677 := Ty.wrap Q1380.P0,
      rir_reg% hty 678 := Ty.wrap Q1380.P1,
      rir_reg% hty 679 := Ty.wrap Q1380.P2,
      rir_reg% hty 680 := Ty.wrap Q1380.P3,
      rir_reg% hty 681 := Ty.wrap Q1380.P4,
      rir_reg% hty 638 := Ty.wrap Q1341.P0,
      rir_reg% hty 639 := Ty.wrap Q1341.P1,
      rir_reg% hty 640 := Ty.wrap Q1341.P2,
      rir_reg% hty 641 := Ty.wrap Q1341.P3,
      rir_reg% hty 642 := Ty.wrap Q1341.P4,
      rir_reg% hty 291 := PoisonOr.value (B.slot 152),
      rir_reg% hty 292 := PoisonOr.value (B.slot 153),
      rir_reg% hty 293 := PoisonOr.value (B.slot 154),
      rir_reg% hty 294 := PoisonOr.value (B.slot 155),
      rir_reg% hty 295 := PoisonOr.value (B.slot 156),
      rir_reg% hty 296 := PoisonOr.value (B.slot 157),
      rir_reg% hty 297 := PoisonOr.value (B.slot 158),
      rir_reg% hty 298 := PoisonOr.value (B.slot 159),
      rir_reg% hty 299 := PoisonOr.value (B.slot 160),
      rir_reg% hty 300 := PoisonOr.value (B.slot 161)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 661 671 →
      (E' ⊨ [rir_reg% hty 661 := Ty.wrap (mulQ Q1380 Q1341).P0,
        rir_reg% hty 662 := Ty.wrap (mulQ Q1380 Q1341).P1,
        rir_reg% hty 663 := Ty.wrap (mulQ Q1380 Q1341).P2,
        rir_reg% hty 664 := Ty.wrap (mulQ Q1380 Q1341).P3,
        rir_reg% hty 665 := Ty.wrap (mulQ Q1380 Q1341).P4,
        rir_reg% hty 666 := Ty.wrap (sqrQ (mulQ Q1380 Q1341)).P0,
        rir_reg% hty 667 := Ty.wrap (sqrQ (mulQ Q1380 Q1341)).P1,
        rir_reg% hty 668 := Ty.wrap (sqrQ (mulQ Q1380 Q1341)).P2,
        rir_reg% hty 669 := Ty.wrap (sqrQ (mulQ Q1380 Q1341)).P3,
        rir_reg% hty 670 := Ty.wrap (sqrQ (mulQ Q1380 Q1341)).P4]) →
      Inv B M c S' → (bb3.runBodyFrom E' 32 S' >>= g) = K) :
    (bb3.runBodyFrom Ein 0 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  subst hv665 hv670 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb5`'s sites `0` to `32`. -/
theorem bb5g0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1403 Q1364 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 700 := Ty.wrap Q1403.P0,
      rir_reg% hty 701 := Ty.wrap Q1403.P1,
      rir_reg% hty 702 := Ty.wrap Q1403.P2,
      rir_reg% hty 703 := Ty.wrap Q1403.P3,
      rir_reg% hty 704 := Ty.wrap Q1403.P4,
      rir_reg% hty 661 := Ty.wrap Q1364.P0,
      rir_reg% hty 662 := Ty.wrap Q1364.P1,
      rir_reg% hty 663 := Ty.wrap Q1364.P2,
      rir_reg% hty 664 := Ty.wrap Q1364.P3,
      rir_reg% hty 665 := Ty.wrap Q1364.P4,
      rir_reg% hty 306 := PoisonOr.value (B.slot 167),
      rir_reg% hty 307 := PoisonOr.value (B.slot 168),
      rir_reg% hty 308 := PoisonOr.value (B.slot 169),
      rir_reg% hty 309 := PoisonOr.value (B.slot 170),
      rir_reg% hty 310 := PoisonOr.value (B.slot 171),
      rir_reg% hty 311 := PoisonOr.value (B.slot 172),
      rir_reg% hty 312 := PoisonOr.value (B.slot 173),
      rir_reg% hty 313 := PoisonOr.value (B.slot 174),
      rir_reg% hty 314 := PoisonOr.value (B.slot 175),
      rir_reg% hty 315 := PoisonOr.value (B.slot 176)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 684 694 →
      (E' ⊨ [rir_reg% hty 684 := Ty.wrap (mulQ Q1403 Q1364).P0,
        rir_reg% hty 685 := Ty.wrap (mulQ Q1403 Q1364).P1,
        rir_reg% hty 686 := Ty.wrap (mulQ Q1403 Q1364).P2,
        rir_reg% hty 687 := Ty.wrap (mulQ Q1403 Q1364).P3,
        rir_reg% hty 688 := Ty.wrap (mulQ Q1403 Q1364).P4,
        rir_reg% hty 689 := Ty.wrap (sqrQ (mulQ Q1403 Q1364)).P0,
        rir_reg% hty 690 := Ty.wrap (sqrQ (mulQ Q1403 Q1364)).P1,
        rir_reg% hty 691 := Ty.wrap (sqrQ (mulQ Q1403 Q1364)).P2,
        rir_reg% hty 692 := Ty.wrap (sqrQ (mulQ Q1403 Q1364)).P3,
        rir_reg% hty 693 := Ty.wrap (sqrQ (mulQ Q1403 Q1364)).P4]) →
      Inv B M c S' → (bb5.runBodyFrom E' 32 S' >>= g) = K) :
    (bb5.runBodyFrom Ein 0 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  subst hv688 hv693 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb7`'s sites `0` to `80`. -/
theorem bb7g0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1463 Q1341 Q1156 Q1121 Q1141 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 760 := Ty.wrap Q1463.P0,
      rir_reg% hty 761 := Ty.wrap Q1463.P1,
      rir_reg% hty 762 := Ty.wrap Q1463.P2,
      rir_reg% hty 763 := Ty.wrap Q1463.P3,
      rir_reg% hty 764 := Ty.wrap Q1463.P4,
      rir_reg% hty 638 := Ty.wrap Q1341.P0,
      rir_reg% hty 639 := Ty.wrap Q1341.P1,
      rir_reg% hty 640 := Ty.wrap Q1341.P2,
      rir_reg% hty 641 := Ty.wrap Q1341.P3,
      rir_reg% hty 642 := Ty.wrap Q1341.P4,
      rir_reg% hty 321 := PoisonOr.value (B.slot 182),
      rir_reg% hty 322 := PoisonOr.value (B.slot 183),
      rir_reg% hty 323 := PoisonOr.value (B.slot 184),
      rir_reg% hty 324 := PoisonOr.value (B.slot 185),
      rir_reg% hty 325 := PoisonOr.value (B.slot 186),
      rir_reg% hty 326 := PoisonOr.value (B.slot 187),
      rir_reg% hty 327 := PoisonOr.value (B.slot 188),
      rir_reg% hty 328 := PoisonOr.value (B.slot 189),
      rir_reg% hty 329 := PoisonOr.value (B.slot 190),
      rir_reg% hty 330 := PoisonOr.value (B.slot 191),
      rir_reg% hty 331 := PoisonOr.value (B.slot 192),
      rir_reg% hty 332 := PoisonOr.value (B.slot 193),
      rir_reg% hty 333 := PoisonOr.value (B.slot 194),
      rir_reg% hty 334 := PoisonOr.value (B.slot 195),
      rir_reg% hty 335 := PoisonOr.value (B.slot 196),
      rir_reg% hty 453 := Ty.wrap Q1156.P0,
      rir_reg% hty 454 := Ty.wrap Q1156.P1,
      rir_reg% hty 455 := Ty.wrap Q1156.P2,
      rir_reg% hty 456 := Ty.wrap Q1156.P3,
      rir_reg% hty 457 := Ty.wrap Q1156.P4,
      rir_reg% hty 336 := PoisonOr.value (B.slot 197),
      rir_reg% hty 337 := PoisonOr.value (B.slot 198),
      rir_reg% hty 338 := PoisonOr.value (B.slot 199),
      rir_reg% hty 339 := PoisonOr.value (B.slot 200),
      rir_reg% hty 340 := PoisonOr.value (B.slot 201),
      rir_reg% hty 418 := Ty.wrap Q1121.P0,
      rir_reg% hty 419 := Ty.wrap Q1121.P1,
      rir_reg% hty 420 := Ty.wrap Q1121.P2,
      rir_reg% hty 421 := Ty.wrap Q1121.P3,
      rir_reg% hty 422 := Ty.wrap Q1121.P4,
      rir_reg% hty 438 := Ty.wrap Q1141.P0,
      rir_reg% hty 439 := Ty.wrap Q1141.P1,
      rir_reg% hty 440 := Ty.wrap Q1141.P2,
      rir_reg% hty 441 := Ty.wrap Q1141.P3,
      rir_reg% hty 442 := Ty.wrap Q1141.P4,
      rir_reg% hty 341 := PoisonOr.value (B.slot 202),
      rir_reg% hty 342 := PoisonOr.value (B.slot 203),
      rir_reg% hty 343 := PoisonOr.value (B.slot 204),
      rir_reg% hty 344 := PoisonOr.value (B.slot 205),
      rir_reg% hty 345 := PoisonOr.value (B.slot 206)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 707 732 →
      (E' ⊨ [rir_reg% hty 707 := Ty.wrap (mulQ Q1463 Q1341).P0,
        rir_reg% hty 708 := Ty.wrap (mulQ Q1463 Q1341).P1,
        rir_reg% hty 709 := Ty.wrap (mulQ Q1463 Q1341).P2,
        rir_reg% hty 710 := Ty.wrap (mulQ Q1463 Q1341).P3,
        rir_reg% hty 711 := Ty.wrap (mulQ Q1463 Q1341).P4,
        rir_reg% hty 712 := Ty.wrap (sqrQ (mulQ Q1463 Q1341)).P0,
        rir_reg% hty 713 := Ty.wrap (sqrQ (mulQ Q1463 Q1341)).P1,
        rir_reg% hty 714 := Ty.wrap (sqrQ (mulQ Q1463 Q1341)).P2,
        rir_reg% hty 715 := Ty.wrap (sqrQ (mulQ Q1463 Q1341)).P3,
        rir_reg% hty 716 := Ty.wrap (sqrQ (mulQ Q1463 Q1341)).P4,
        rir_reg% hty 717 := Ty.wrap (sqrQ (sqrQ (mulQ Q1463 Q1341))).P0,
        rir_reg% hty 718 := Ty.wrap (sqrQ (sqrQ (mulQ Q1463 Q1341))).P1,
        rir_reg% hty 719 := Ty.wrap (sqrQ (sqrQ (mulQ Q1463 Q1341))).P2,
        rir_reg% hty 720 := Ty.wrap (sqrQ (sqrQ (mulQ Q1463 Q1341))).P3,
        rir_reg% hty 721 := Ty.wrap (sqrQ (sqrQ (mulQ Q1463 Q1341))).P4,
        rir_reg% hty 722 := Ty.wrap (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156).P0,
        rir_reg% hty 723 := Ty.wrap (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156).P1,
        rir_reg% hty 724 := Ty.wrap (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156).P2,
        rir_reg% hty 725 := Ty.wrap (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156).P3,
        rir_reg% hty 726 := Ty.wrap (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156).P4,
        rir_reg% hty 727 := Ty.wrap (mulQ Q1121 Q1141).P0,
        rir_reg% hty 728 := Ty.wrap (mulQ Q1121 Q1141).P1,
        rir_reg% hty 729 := Ty.wrap (mulQ Q1121 Q1141).P2,
        rir_reg% hty 730 := Ty.wrap (mulQ Q1121 Q1141).P3,
        rir_reg% hty 731 := Ty.wrap (mulQ Q1121 Q1141).P4]) →
      Inv B M c S' → (bb7.runBodyFrom E' 80 S' >>= g) = K) :
    (bb7.runBodyFrom Ein 0 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q3
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q4
  subst hv711 hv716 hv721 hv726 hv731 hQ4 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb7`'s sites `80` to `144`. -/
theorem bb7g1_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1430 Q1425 Q1131 Q1121 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 727 := Ty.wrap Q1430.P0,
      rir_reg% hty 728 := Ty.wrap Q1430.P1,
      rir_reg% hty 729 := Ty.wrap Q1430.P2,
      rir_reg% hty 730 := Ty.wrap Q1430.P3,
      rir_reg% hty 731 := Ty.wrap Q1430.P4,
      rir_reg% hty 722 := Ty.wrap Q1425.P0,
      rir_reg% hty 723 := Ty.wrap Q1425.P1,
      rir_reg% hty 724 := Ty.wrap Q1425.P2,
      rir_reg% hty 725 := Ty.wrap Q1425.P3,
      rir_reg% hty 726 := Ty.wrap Q1425.P4,
      rir_reg% hty 346 := PoisonOr.value (B.slot 207),
      rir_reg% hty 347 := PoisonOr.value (B.slot 208),
      rir_reg% hty 348 := PoisonOr.value (B.slot 209),
      rir_reg% hty 349 := PoisonOr.value (B.slot 210),
      rir_reg% hty 350 := PoisonOr.value (B.slot 211),
      rir_reg% hty 351 := PoisonOr.value (B.slot 212),
      rir_reg% hty 352 := PoisonOr.value (B.slot 213),
      rir_reg% hty 353 := PoisonOr.value (B.slot 214),
      rir_reg% hty 354 := PoisonOr.value (B.slot 215),
      rir_reg% hty 355 := PoisonOr.value (B.slot 216),
      rir_reg% hty 428 := Ty.wrap Q1131.P0,
      rir_reg% hty 429 := Ty.wrap Q1131.P1,
      rir_reg% hty 430 := Ty.wrap Q1131.P2,
      rir_reg% hty 431 := Ty.wrap Q1131.P3,
      rir_reg% hty 432 := Ty.wrap Q1131.P4,
      rir_reg% hty 356 := PoisonOr.value (B.slot 217),
      rir_reg% hty 357 := PoisonOr.value (B.slot 218),
      rir_reg% hty 358 := PoisonOr.value (B.slot 219),
      rir_reg% hty 359 := PoisonOr.value (B.slot 220),
      rir_reg% hty 360 := PoisonOr.value (B.slot 221),
      rir_reg% hty 418 := Ty.wrap Q1121.P0,
      rir_reg% hty 419 := Ty.wrap Q1121.P1,
      rir_reg% hty 420 := Ty.wrap Q1121.P2,
      rir_reg% hty 421 := Ty.wrap Q1121.P3,
      rir_reg% hty 422 := Ty.wrap Q1121.P4,
      rir_reg% hty 361 := PoisonOr.value (B.slot 222),
      rir_reg% hty 362 := PoisonOr.value (B.slot 223),
      rir_reg% hty 363 := PoisonOr.value (B.slot 224),
      rir_reg% hty 364 := PoisonOr.value (B.slot 225),
      rir_reg% hty 365 := PoisonOr.value (B.slot 226)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 732 752 →
      (E' ⊨ [rir_reg% hty 732 := Ty.wrap (mulQ Q1430 Q1425).P0,
        rir_reg% hty 733 := Ty.wrap (mulQ Q1430 Q1425).P1,
        rir_reg% hty 734 := Ty.wrap (mulQ Q1430 Q1425).P2,
        rir_reg% hty 735 := Ty.wrap (mulQ Q1430 Q1425).P3,
        rir_reg% hty 736 := Ty.wrap (mulQ Q1430 Q1425).P4,
        rir_reg% hty 737 := Ty.wrap (sqrQ (mulQ Q1430 Q1425)).P0,
        rir_reg% hty 738 := Ty.wrap (sqrQ (mulQ Q1430 Q1425)).P1,
        rir_reg% hty 739 := Ty.wrap (sqrQ (mulQ Q1430 Q1425)).P2,
        rir_reg% hty 740 := Ty.wrap (sqrQ (mulQ Q1430 Q1425)).P3,
        rir_reg% hty 741 := Ty.wrap (sqrQ (mulQ Q1430 Q1425)).P4,
        rir_reg% hty 742 := Ty.wrap (mulQ Q1131 (sqrQ (mulQ Q1430 Q1425))).P0,
        rir_reg% hty 743 := Ty.wrap (mulQ Q1131 (sqrQ (mulQ Q1430 Q1425))).P1,
        rir_reg% hty 744 := Ty.wrap (mulQ Q1131 (sqrQ (mulQ Q1430 Q1425))).P2,
        rir_reg% hty 745 := Ty.wrap (mulQ Q1131 (sqrQ (mulQ Q1430 Q1425))).P3,
        rir_reg% hty 746 := Ty.wrap (mulQ Q1131 (sqrQ (mulQ Q1430 Q1425))).P4,
        rir_reg% hty 747 := Ty.wrap (fd_r52x5_quad_neg.spec Q1121).P0,
        rir_reg% hty 748 := Ty.wrap (fd_r52x5_quad_neg.spec Q1121).P1,
        rir_reg% hty 749 := Ty.wrap (fd_r52x5_quad_neg.spec Q1121).P2,
        rir_reg% hty 750 := Ty.wrap (fd_r52x5_quad_neg.spec Q1121).P3,
        rir_reg% hty 751 := Ty.wrap (fd_r52x5_quad_neg.spec Q1121).P4]) →
      Inv B M c S' → (bb7.runBodyFrom E' 144 S' >>= g) = K) :
    (bb7.runBodyFrom Ein 80 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_neg.call_eq) with Q3
  subst hv736 hv741 hv746 hv751 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads



end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify

module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Common.Runs
import Firedancer.R52x5.Decode2.Tactics

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

@[expose] public section

variable {Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer}

attribute [local mlir_env 1100] read_write_same

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl zipWith_and_wl zipWith_lshr_wl
  zipWith_add_nsw_nuw_reduce

/-- `^bb0`'s sites `354` to `447`. -/
theorem head0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q1817 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 270 := Q1817.P0, rir_reg% hty 278 := Q1817.P1, rir_reg% hty 286 :=
        Q1817.P2, rir_reg% hty 294 := Q1817.P3, rir_reg% hty 302 := Q1817.P4, rir_reg% hty 84 :=
        B.slot 41, rir_reg% hty 85 := B.slot 42, rir_reg% hty 86 := B.slot 43, rir_reg% hty 87 :=
        B.slot 44, rir_reg% hty 88 := B.slot 45, rir_reg% hty 89 := B.slot 46, rir_reg% hty 90 :=
        B.slot 47, rir_reg% hty 91 := B.slot 48, rir_reg% hty 92 := B.slot 49, rir_reg% hty 93 :=
        B.slot 50, rir_reg% hty 94 := B.slot 51, rir_reg% hty 95 := B.slot 52, rir_reg% hty 96 :=
        B.slot 53, rir_reg% hty 97 := B.slot 54, rir_reg% hty 98 := B.slot 55, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 303 363 →
          (E' ⊨ [rir_reg% hty 314 := (sqrQ Q1817).P0, rir_reg% hty 316 := (sqrQ Q1817).P1,
            rir_reg% hty 318 := (sqrQ Q1817).P2, rir_reg% hty 320 := (sqrQ Q1817).P3,
            rir_reg% hty 322 := (sqrQ Q1817).P4, rir_reg% hty 354 := (sqrQ (sqrQ (sqrQ Q1817))).P0,
            rir_reg% hty 356 := (sqrQ (sqrQ (sqrQ Q1817))).P1, rir_reg% hty 358 :=
            (sqrQ (sqrQ (sqrQ Q1817))).P2, rir_reg% hty 360 := (sqrQ (sqrQ (sqrQ Q1817))).P3,
            rir_reg% hty 362 := (sqrQ (sqrQ (sqrQ Q1817))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 447 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 354 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 41
  qp_sqr 46
  qp_sqr 51
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 41 42 43 44 45 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            46 47 48 49 50 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        51 52 53 54 55 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `447` to `540`. -/
theorem head1_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q1817 Q1901 Q1861 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 270 := Q1817.P0, rir_reg% hty 278 := Q1817.P1, rir_reg% hty 286 :=
        Q1817.P2, rir_reg% hty 294 := Q1817.P3, rir_reg% hty 302 := Q1817.P4, rir_reg% hty 354 :=
        Q1901.P0, rir_reg% hty 356 := Q1901.P1, rir_reg% hty 358 := Q1901.P2, rir_reg% hty 360 :=
        Q1901.P3, rir_reg% hty 362 := Q1901.P4, rir_reg% hty 314 := Q1861.P0, rir_reg% hty 316 :=
        Q1861.P1, rir_reg% hty 318 := Q1861.P2, rir_reg% hty 320 := Q1861.P3, rir_reg% hty 322 :=
        Q1861.P4, rir_reg% hty 99 := B.slot 56, rir_reg% hty 100 := B.slot 57, rir_reg% hty 101 :=
        B.slot 58, rir_reg% hty 102 := B.slot 59, rir_reg% hty 103 := B.slot 60, rir_reg% hty 104 :=
        B.slot 61, rir_reg% hty 105 := B.slot 62, rir_reg% hty 106 := B.slot 63, rir_reg% hty 107 :=
        B.slot 64, rir_reg% hty 108 := B.slot 65, rir_reg% hty 109 := B.slot 66, rir_reg% hty 110 :=
        B.slot 67, rir_reg% hty 111 := B.slot 68, rir_reg% hty 112 := B.slot 69, rir_reg% hty 113 :=
        B.slot 70, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 363 423 →
          (E' ⊨ [rir_reg% hty 374 := (mulQ Q1817 Q1901).P0, rir_reg% hty 376 :=
            (mulQ Q1817 Q1901).P1, rir_reg% hty 378 := (mulQ Q1817 Q1901).P2, rir_reg% hty 380 :=
            (mulQ Q1817 Q1901).P3, rir_reg% hty 382 := (mulQ Q1817 Q1901).P4, rir_reg% hty 414 :=
            (sqrQ (mulQ Q1861 (mulQ Q1817 Q1901))).P0, rir_reg% hty 416 :=
            (sqrQ (mulQ Q1861 (mulQ Q1817 Q1901))).P1, rir_reg% hty 418 :=
            (sqrQ (mulQ Q1861 (mulQ Q1817 Q1901))).P2, rir_reg% hty 420 :=
            (sqrQ (mulQ Q1861 (mulQ Q1817 Q1901))).P3, rir_reg% hty 422 :=
            (sqrQ (mulQ Q1861 (mulQ Q1817 Q1901))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 540 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 447 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 56
  qp_mul 61
  qp_sqr 66
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 56 57 58 59 60 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            61 62 63 64 65 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        66 67 68 69 70 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `540` to `633`. -/
theorem head2_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q1921 Q1961 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 374 := Q1921.P0, rir_reg% hty 376 := Q1921.P1, rir_reg% hty 378 :=
        Q1921.P2, rir_reg% hty 380 := Q1921.P3, rir_reg% hty 382 := Q1921.P4, rir_reg% hty 414 :=
        Q1961.P0, rir_reg% hty 416 := Q1961.P1, rir_reg% hty 418 := Q1961.P2, rir_reg% hty 420 :=
        Q1961.P3, rir_reg% hty 422 := Q1961.P4, rir_reg% hty 114 := B.slot 71, rir_reg% hty 115 :=
        B.slot 72, rir_reg% hty 116 := B.slot 73, rir_reg% hty 117 := B.slot 74, rir_reg% hty 118 :=
        B.slot 75, rir_reg% hty 119 := B.slot 76, rir_reg% hty 120 := B.slot 77, rir_reg% hty 121 :=
        B.slot 78, rir_reg% hty 122 := B.slot 79, rir_reg% hty 123 := B.slot 80, rir_reg% hty 124 :=
        B.slot 81, rir_reg% hty 125 := B.slot 82, rir_reg% hty 126 := B.slot 83, rir_reg% hty 127 :=
        B.slot 84, rir_reg% hty 128 := B.slot 85, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 423 483 →
          (E' ⊨ [rir_reg% hty 434 := (mulQ Q1921 Q1961).P0, rir_reg% hty 436 :=
            (mulQ Q1921 Q1961).P1, rir_reg% hty 438 := (mulQ Q1921 Q1961).P2, rir_reg% hty 440 :=
            (mulQ Q1921 Q1961).P3, rir_reg% hty 442 := (mulQ Q1921 Q1961).P4, rir_reg% hty 474 :=
            (sqrQ (sqrQ (mulQ Q1921 Q1961))).P0, rir_reg% hty 476 :=
            (sqrQ (sqrQ (mulQ Q1921 Q1961))).P1, rir_reg% hty 478 :=
            (sqrQ (sqrQ (mulQ Q1921 Q1961))).P2, rir_reg% hty 480 :=
            (sqrQ (sqrQ (mulQ Q1921 Q1961))).P3, rir_reg% hty 482 :=
            (sqrQ (sqrQ (mulQ Q1921 Q1961))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 633 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 540 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 71
  qp_sqr 76
  qp_sqr 81
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 71 72 73 74 75 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            76 77 78 79 80 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        81 82 83 84 85 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `633` to `726`. -/
theorem head3_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2021 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 474 := Q2021.P0, rir_reg% hty 476 := Q2021.P1, rir_reg% hty 478 :=
        Q2021.P2, rir_reg% hty 480 := Q2021.P3, rir_reg% hty 482 := Q2021.P4, rir_reg% hty 124 :=
        B.slot 81, rir_reg% hty 125 := B.slot 82, rir_reg% hty 126 := B.slot 83, rir_reg% hty 127 :=
        B.slot 84, rir_reg% hty 128 := B.slot 85, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 483 543 →
          (E' ⊨ [rir_reg% hty 534 := (sqrQ (sqrQ (sqrQ Q2021))).P0, rir_reg% hty 536 :=
            (sqrQ (sqrQ (sqrQ Q2021))).P1, rir_reg% hty 538 := (sqrQ (sqrQ (sqrQ Q2021))).P2,
            rir_reg% hty 540 := (sqrQ (sqrQ (sqrQ Q2021))).P3, rir_reg% hty 542 :=
            (sqrQ (sqrQ (sqrQ Q2021))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 726 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 633 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 81
  qp_sqr 81
  qp_sqr 81
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 81 82 83 84 85 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            81 82 83 84 85 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        81 82 83 84 85 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `726` to `819`. -/
theorem head4_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2081 Q1981 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 534 := Q2081.P0, rir_reg% hty 536 := Q2081.P1, rir_reg% hty 538 :=
        Q2081.P2, rir_reg% hty 540 := Q2081.P3, rir_reg% hty 542 := Q2081.P4, rir_reg% hty 434 :=
        Q1981.P0, rir_reg% hty 436 := Q1981.P1, rir_reg% hty 438 := Q1981.P2, rir_reg% hty 440 :=
        Q1981.P3, rir_reg% hty 442 := Q1981.P4, rir_reg% hty 129 := B.slot 86, rir_reg% hty 130 :=
        B.slot 87, rir_reg% hty 131 := B.slot 88, rir_reg% hty 132 := B.slot 89, rir_reg% hty 133 :=
        B.slot 90, rir_reg% hty 134 := B.slot 91, rir_reg% hty 135 := B.slot 92, rir_reg% hty 136 :=
        B.slot 93, rir_reg% hty 137 := B.slot 94, rir_reg% hty 138 := B.slot 95, rir_reg% hty 139 :=
        B.slot 96, rir_reg% hty 140 := B.slot 97, rir_reg% hty 141 := B.slot 98, rir_reg% hty 142 :=
        B.slot 99, rir_reg% hty 143 := B.slot 100, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 543 603 →
          (E' ⊨ [rir_reg% hty 554 := (mulQ Q2081 Q1981).P0, rir_reg% hty 556 :=
            (mulQ Q2081 Q1981).P1, rir_reg% hty 558 := (mulQ Q2081 Q1981).P2, rir_reg% hty 560 :=
            (mulQ Q2081 Q1981).P3, rir_reg% hty 562 := (mulQ Q2081 Q1981).P4, rir_reg% hty 594 :=
            (sqrQ (sqrQ (mulQ Q2081 Q1981))).P0, rir_reg% hty 596 :=
            (sqrQ (sqrQ (mulQ Q2081 Q1981))).P1, rir_reg% hty 598 :=
            (sqrQ (sqrQ (mulQ Q2081 Q1981))).P2, rir_reg% hty 600 :=
            (sqrQ (sqrQ (mulQ Q2081 Q1981))).P3, rir_reg% hty 602 :=
            (sqrQ (sqrQ (mulQ Q2081 Q1981))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 819 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 726 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 86
  qp_sqr 91
  qp_sqr 96
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 86 87 88 89 90 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            91 92 93 94 95 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `819` to `912`. -/
theorem head5_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2141 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 594 := Q2141.P0, rir_reg% hty 596 := Q2141.P1, rir_reg% hty 598 :=
        Q2141.P2, rir_reg% hty 600 := Q2141.P3, rir_reg% hty 602 := Q2141.P4, rir_reg% hty 139 :=
        B.slot 96, rir_reg% hty 140 := B.slot 97, rir_reg% hty 141 := B.slot 98, rir_reg% hty 142 :=
        B.slot 99, rir_reg% hty 143 := B.slot 100, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 603 663 →
          (E' ⊨ [rir_reg% hty 654 := (sqrQ (sqrQ (sqrQ Q2141))).P0, rir_reg% hty 656 :=
            (sqrQ (sqrQ (sqrQ Q2141))).P1, rir_reg% hty 658 := (sqrQ (sqrQ (sqrQ Q2141))).P2,
            rir_reg% hty 660 := (sqrQ (sqrQ (sqrQ Q2141))).P3, rir_reg% hty 662 :=
            (sqrQ (sqrQ (sqrQ Q2141))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 912 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 819 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 96
  qp_sqr 96
  qp_sqr 96
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 96 97 98 99 100 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `912` to `1005`. -/
theorem head6_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2201 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 654 := Q2201.P0, rir_reg% hty 656 := Q2201.P1, rir_reg% hty 658 :=
        Q2201.P2, rir_reg% hty 660 := Q2201.P3, rir_reg% hty 662 := Q2201.P4, rir_reg% hty 139 :=
        B.slot 96, rir_reg% hty 140 := B.slot 97, rir_reg% hty 141 := B.slot 98, rir_reg% hty 142 :=
        B.slot 99, rir_reg% hty 143 := B.slot 100, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 663 723 →
          (E' ⊨ [rir_reg% hty 714 := (sqrQ (sqrQ (sqrQ Q2201))).P0, rir_reg% hty 716 :=
            (sqrQ (sqrQ (sqrQ Q2201))).P1, rir_reg% hty 718 := (sqrQ (sqrQ (sqrQ Q2201))).P2,
            rir_reg% hty 720 := (sqrQ (sqrQ (sqrQ Q2201))).P3, rir_reg% hty 722 :=
            (sqrQ (sqrQ (sqrQ Q2201))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 1005 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 912 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 96
  qp_sqr 96
  qp_sqr 96
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 96 97 98 99 100 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `1005` to `1098`. -/
theorem head7_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2261 Q2101 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 714 := Q2261.P0, rir_reg% hty 716 := Q2261.P1, rir_reg% hty 718 :=
        Q2261.P2, rir_reg% hty 720 := Q2261.P3, rir_reg% hty 722 := Q2261.P4, rir_reg% hty 554 :=
        Q2101.P0, rir_reg% hty 556 := Q2101.P1, rir_reg% hty 558 := Q2101.P2, rir_reg% hty 560 :=
        Q2101.P3, rir_reg% hty 562 := Q2101.P4, rir_reg% hty 139 := B.slot 96, rir_reg% hty 140 :=
        B.slot 97, rir_reg% hty 141 := B.slot 98, rir_reg% hty 142 := B.slot 99, rir_reg% hty 143 :=
        B.slot 100, rir_reg% hty 144 := B.slot 101, rir_reg% hty 145 := B.slot 102,
        rir_reg% hty 146 := B.slot 103, rir_reg% hty 147 := B.slot 104, rir_reg% hty 148 :=
        B.slot 105, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 723 783 →
          (E' ⊨ [rir_reg% hty 774 := (mulQ (sqrQ (sqrQ Q2261)) Q2101).P0, rir_reg% hty 776 :=
            (mulQ (sqrQ (sqrQ Q2261)) Q2101).P1, rir_reg% hty 778 :=
            (mulQ (sqrQ (sqrQ Q2261)) Q2101).P2, rir_reg% hty 780 :=
            (mulQ (sqrQ (sqrQ Q2261)) Q2101).P3, rir_reg% hty 782 :=
            (mulQ (sqrQ (sqrQ Q2261)) Q2101).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 1098 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 1005 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 96
  qp_sqr 96
  qp_mul 101
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 96 97 98 99 100 (by decide) (by decide) (by decide) (by decide)
                (by decide)).callTmp5
            96 97 98 99 100 (by decide) (by decide) (by decide) (by decide) (by decide)).callTmp5
        101 102 103 104 105 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb0`'s sites `1098` to `1129`. -/
theorem head8_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2321 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 774 := Q2321.P0, rir_reg% hty 776 := Q2321.P1, rir_reg% hty 778 :=
        Q2321.P2, rir_reg% hty 780 := Q2321.P3, rir_reg% hty 782 := Q2321.P4, rir_reg% hty 149 :=
        B.slot 106, rir_reg% hty 150 := B.slot 107, rir_reg% hty 151 := B.slot 108,
        rir_reg% hty 152 := B.slot 109, rir_reg% hty 153 := B.slot 110, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 783 803 →
          (E' ⊨ [rir_reg% hty 794 := (sqrQ Q2321).P0, rir_reg% hty 796 := (sqrQ Q2321).P1,
            rir_reg% hty 798 := (sqrQ Q2321).P2, rir_reg% hty 800 := (sqrQ Q2321).P3,
            rir_reg% hty 802 := (sqrQ Q2321).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb0.runBodyFrom E' 1129 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 1098 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 106
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((Keeps.refl _ _).callTmp5 106 107 108 109 110 (by decide) (by decide) (by decide) (by decide)
        (by decide))

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

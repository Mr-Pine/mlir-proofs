module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Common.Runs
import Firedancer.R52x5.Decode2.Tactics
public import Firedancer.R52x5.Decode2.Loop

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

@[expose] public section

variable {Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer}

attribute [local mlir_env 1100] read_write_same

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl zipWith_and_wl zipWith_lshr_wl
  zipWith_add_nsw_nuw_reduce

/-- `^bb1`'s sites `0` to `93`. -/
theorem bb1c0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2627 Q2321 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1080 := Q2627.P0, rir_reg% hty 1082 := Q2627.P1, rir_reg% hty 1084 :=
        Q2627.P2, rir_reg% hty 1086 := Q2627.P3, rir_reg% hty 1088 := Q2627.P4, rir_reg% hty 774 :=
        Q2321.P0, rir_reg% hty 776 := Q2321.P1, rir_reg% hty 778 := Q2321.P2, rir_reg% hty 780 :=
        Q2321.P3, rir_reg% hty 782 := Q2321.P4, rir_reg% hty 159 := B.slot 116, rir_reg% hty 160 :=
        B.slot 117, rir_reg% hty 161 := B.slot 118, rir_reg% hty 162 := B.slot 119,
        rir_reg% hty 163 := B.slot 120, rir_reg% hty 164 := B.slot 121, rir_reg% hty 165 :=
        B.slot 122, rir_reg% hty 166 := B.slot 123, rir_reg% hty 167 := B.slot 124,
        rir_reg% hty 168 := B.slot 125, rir_reg% hty 169 := B.slot 126, rir_reg% hty 170 :=
        B.slot 127, rir_reg% hty 171 := B.slot 128, rir_reg% hty 172 := B.slot 129,
        rir_reg% hty 173 := B.slot 130, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 803 863 →
          (E' ⊨ [rir_reg% hty 854 := (sqrQ (sqrQ (mulQ Q2627 Q2321))).P0, rir_reg% hty 856 :=
            (sqrQ (sqrQ (mulQ Q2627 Q2321))).P1, rir_reg% hty 858 :=
            (sqrQ (sqrQ (mulQ Q2627 Q2321))).P2, rir_reg% hty 860 :=
            (sqrQ (sqrQ (mulQ Q2627 Q2321))).P3, rir_reg% hty 862 :=
            (sqrQ (sqrQ (mulQ Q2627 Q2321))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb1.runBodyFrom E' 93 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 0 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 116
  qp_sqr 121
  qp_sqr 126
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).storeTmp5 116 117 118 119 120 (by decide) (by decide) (by decide)
                (by decide) (by decide)).storeTmp5
            121 122 123 124 125 (by decide) (by decide) (by decide) (by decide)
            (by decide)).storeTmp5
        126 127 128 129 130 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb1`'s sites `93` to `186`. -/
theorem bb1c1_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2401 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 854 := Q2401.P0, rir_reg% hty 856 := Q2401.P1, rir_reg% hty 858 :=
        Q2401.P2, rir_reg% hty 860 := Q2401.P3, rir_reg% hty 862 := Q2401.P4, rir_reg% hty 169 :=
        B.slot 126, rir_reg% hty 170 := B.slot 127, rir_reg% hty 171 := B.slot 128,
        rir_reg% hty 172 := B.slot 129, rir_reg% hty 173 := B.slot 130, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 863 923 →
          (E' ⊨ [rir_reg% hty 914 := (sqrQ (sqrQ (sqrQ Q2401))).P0, rir_reg% hty 916 :=
            (sqrQ (sqrQ (sqrQ Q2401))).P1, rir_reg% hty 918 := (sqrQ (sqrQ (sqrQ Q2401))).P2,
            rir_reg% hty 920 := (sqrQ (sqrQ (sqrQ Q2401))).P3, rir_reg% hty 922 :=
            (sqrQ (sqrQ (sqrQ Q2401))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb1.runBodyFrom E' 186 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 93 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 126
  qp_sqr 126
  qp_sqr 126
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).storeTmp5 126 127 128 129 130 (by decide) (by decide) (by decide)
                (by decide) (by decide)).storeTmp5
            126 127 128 129 130 (by decide) (by decide) (by decide) (by decide)
            (by decide)).storeTmp5
        126 127 128 129 130 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb1`'s sites `186` to `279`. -/
theorem bb1c2_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2461 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 914 := Q2461.P0, rir_reg% hty 916 := Q2461.P1, rir_reg% hty 918 :=
        Q2461.P2, rir_reg% hty 920 := Q2461.P3, rir_reg% hty 922 := Q2461.P4, rir_reg% hty 169 :=
        B.slot 126, rir_reg% hty 170 := B.slot 127, rir_reg% hty 171 := B.slot 128,
        rir_reg% hty 172 := B.slot 129, rir_reg% hty 173 := B.slot 130, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 923 983 →
          (E' ⊨ [rir_reg% hty 974 := (sqrQ (sqrQ (sqrQ Q2461))).P0, rir_reg% hty 976 :=
            (sqrQ (sqrQ (sqrQ Q2461))).P1, rir_reg% hty 978 := (sqrQ (sqrQ (sqrQ Q2461))).P2,
            rir_reg% hty 980 := (sqrQ (sqrQ (sqrQ Q2461))).P3, rir_reg% hty 982 :=
            (sqrQ (sqrQ (sqrQ Q2461))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb1.runBodyFrom E' 279 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 186 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 126
  qp_sqr 126
  qp_sqr 126
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).storeTmp5 126 127 128 129 130 (by decide) (by decide) (by decide)
                (by decide) (by decide)).storeTmp5
            126 127 128 129 130 (by decide) (by decide) (by decide) (by decide)
            (by decide)).storeTmp5
        126 127 128 129 130 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb1`'s sites `279` to `372`. -/
theorem bb1c3_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2521 Q2101 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 974 := Q2521.P0, rir_reg% hty 976 := Q2521.P1, rir_reg% hty 978 :=
        Q2521.P2, rir_reg% hty 980 := Q2521.P3, rir_reg% hty 982 := Q2521.P4, rir_reg% hty 554 :=
        Q2101.P0, rir_reg% hty 556 := Q2101.P1, rir_reg% hty 558 := Q2101.P2, rir_reg% hty 560 :=
        Q2101.P3, rir_reg% hty 562 := Q2101.P4, rir_reg% hty 169 := B.slot 126, rir_reg% hty 170 :=
        B.slot 127, rir_reg% hty 171 := B.slot 128, rir_reg% hty 172 := B.slot 129,
        rir_reg% hty 173 := B.slot 130, rir_reg% hty 174 := B.slot 131, rir_reg% hty 175 :=
        B.slot 132, rir_reg% hty 176 := B.slot 133, rir_reg% hty 177 := B.slot 134,
        rir_reg% hty 178 := B.slot 135, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 983 1043 →
          (E' ⊨ [rir_reg% hty 1034 := (mulQ (sqrQ (sqrQ Q2521)) Q2101).P0, rir_reg% hty 1036 :=
            (mulQ (sqrQ (sqrQ Q2521)) Q2101).P1, rir_reg% hty 1038 :=
            (mulQ (sqrQ (sqrQ Q2521)) Q2101).P2, rir_reg% hty 1040 :=
            (mulQ (sqrQ (sqrQ Q2521)) Q2101).P3, rir_reg% hty 1042 :=
            (mulQ (sqrQ (sqrQ Q2521)) Q2101).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb1.runBodyFrom E' 372 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 279 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 126
  qp_sqr 126
  qp_mul 131
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).storeTmp5 126 127 128 129 130 (by decide) (by decide) (by decide)
                (by decide) (by decide)).storeTmp5
            126 127 128 129 130 (by decide) (by decide) (by decide) (by decide)
            (by decide)).storeTmp5
        131 132 133 134 135 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb1`'s sites `372` to `403`. -/
theorem bb1c4_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2581 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1034 := Q2581.P0, rir_reg% hty 1036 := Q2581.P1, rir_reg% hty 1038 :=
        Q2581.P2, rir_reg% hty 1040 := Q2581.P3, rir_reg% hty 1042 := Q2581.P4, rir_reg% hty 179 :=
        B.slot 136, rir_reg% hty 180 := B.slot 137, rir_reg% hty 181 := B.slot 138,
        rir_reg% hty 182 := B.slot 139, rir_reg% hty 183 := B.slot 140, rir_reg% hty 23 :=
        (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1043 1063 →
          (E' ⊨ [rir_reg% hty 1054 := (sqrQ Q2581).P0, rir_reg% hty 1056 := (sqrQ Q2581).P1,
            rir_reg% hty 1058 := (sqrQ Q2581).P2, rir_reg% hty 1060 := (sqrQ Q2581).P3,
            rir_reg% hty 1062 := (sqrQ Q2581).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb1.runBodyFrom E' 403 S' >>= g) = K) :
    (bb1.runBodyFrom Ein 372 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 136
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((Keeps.refl _ _).storeTmp5 136 137 138 139 140 (by decide) (by decide) (by decide)
        (by decide) (by decide))

/-- `^bb1`: `_t1 = _t2 _t1`, squared `10` times, `_t0 = _t1 _t0`, `_t1 = _t0²`; on to `^bb4`. -/
theorem bb1_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (Q2627 Q2321 Q2101 : Quad5)
    (hArgs : E.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      E ⊨ [rir_reg% hty 1080 := Q2627.P0, rir_reg% hty 1082 := Q2627.P1, rir_reg% hty 1084 :=
        Q2627.P2, rir_reg% hty 1086 := Q2627.P3, rir_reg% hty 1088 := Q2627.P4, rir_reg% hty 774 :=
        Q2321.P0, rir_reg% hty 776 := Q2321.P1, rir_reg% hty 778 := Q2321.P2, rir_reg% hty 780 :=
        Q2321.P3, rir_reg% hty 782 := Q2321.P4, rir_reg% hty 554 := Q2101.P0, rir_reg% hty 556 :=
        Q2101.P1, rir_reg% hty 558 := Q2101.P2, rir_reg% hty 560 := Q2101.P3, rir_reg% hty 562 :=
        Q2101.P4, rir_reg% hty 159 := B.slot 116, rir_reg% hty 160 := B.slot 117,
        rir_reg% hty 161 := B.slot 118, rir_reg% hty 162 := B.slot 119, rir_reg% hty 163 :=
        B.slot 120, rir_reg% hty 164 := B.slot 121, rir_reg% hty 165 := B.slot 122,
        rir_reg% hty 166 := B.slot 123, rir_reg% hty 167 := B.slot 124, rir_reg% hty 168 :=
        B.slot 125, rir_reg% hty 169 := B.slot 126, rir_reg% hty 170 := B.slot 127,
        rir_reg% hty 171 := B.slot 128, rir_reg% hty 172 := B.slot 129, rir_reg% hty 173 :=
        B.slot 130, rir_reg% hty 174 := B.slot 131, rir_reg% hty 175 := B.slot 132,
        rir_reg% hty 176 := B.slot 133, rir_reg% hty 177 := B.slot 134, rir_reg% hty 178 :=
        B.slot 135, rir_reg% hty 179 := B.slot 136, rir_reg% hty 180 := B.slot 137,
        rir_reg% hty 181 := B.slot 138, rir_reg% hty 182 := B.slot 139, rir_reg% hty 183 :=
        B.slot 140, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes E E' 803 1063 →
          (E' ⊨ [rir_reg% hty 1034 :=
            (mulQ
                (sqrQ
                  (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                Q2101).P0,
            rir_reg% hty 1036 :=
            (mulQ
                (sqrQ
                  (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                Q2101).P1,
            rir_reg% hty 1038 :=
            (mulQ
                (sqrQ
                  (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                Q2101).P2,
            rir_reg% hty 1040 :=
            (mulQ
                (sqrQ
                  (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                Q2101).P3,
            rir_reg% hty 1042 :=
            (mulQ
                (sqrQ
                  (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                Q2101).P4]) →
          Inv B M c S' →
          Keeps B S.mem S'.mem →
          (fd_r52x5_ge_decode2.runFrom
                (hdr4 E'
                  (sqrQ
                    (mulQ
                      (sqrQ
                        (sqrQ
                          (sqrQ
                            (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q2627 Q2321)))))))))))
                      Q2101))
                  1)
                4 S' >>=
              g) =
            K) :
    (fd_r52x5_ge_decode2.runFrom E 1 S >>= g) = K := by
  block_init
  refine bb1c0_run _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hB1 hR1 hI1 hK1 => ?_
  refine bb1c1_run _ hA1 (by chain_reads) hI1 fun E2 S2 hA2 hB2 hR2 hI2 hK2 => ?_
  refine bb1c2_run _ hA2 (by chain_reads) hI2 fun E3 S3 hA3 hB3 hR3 hI3 hK3 => ?_
  refine bb1c3_run _ _ hA3 (by chain_reads) hI3 fun E4 S4 hA4 hB4 hR4 hI4 hK4 => ?_
  refine bb1c4_run _ hA4 (by chain_reads) hI4 fun E5 S5 hA5 hB5 hR5 hI5 hK5 => ?_
  have h1560 : E5.read (rir_reg% hty 13) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  exact
    hK E5 S5 hArgs (((((hB1.mono).trans hB2.mono).trans hB3.mono).trans hB4.mono).trans hB5.mono)
      (by chain_reads) hI5 ((((hK1.trans hK2).trans hK3).trans hK4).trans hK5)

/-- `^bb3`'s sites `0` to `62`. -/
theorem bb3c0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2695 Q2581 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1148 := Q2695.P0, rir_reg% hty 1150 := Q2695.P1, rir_reg% hty 1152 :=
        Q2695.P2, rir_reg% hty 1154 := Q2695.P3, rir_reg% hty 1156 := Q2695.P4, rir_reg% hty 1034 :=
        Q2581.P0, rir_reg% hty 1036 := Q2581.P1, rir_reg% hty 1038 := Q2581.P2, rir_reg% hty 1040 :=
        Q2581.P3, rir_reg% hty 1042 := Q2581.P4, rir_reg% hty 189 := B.slot 146, rir_reg% hty 190 :=
        B.slot 147, rir_reg% hty 191 := B.slot 148, rir_reg% hty 192 := B.slot 149,
        rir_reg% hty 193 := B.slot 150, rir_reg% hty 194 := B.slot 151, rir_reg% hty 195 :=
        B.slot 152, rir_reg% hty 196 := B.slot 153, rir_reg% hty 197 := B.slot 154,
        rir_reg% hty 198 := B.slot 155, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1091 1131 →
          (E' ⊨ [rir_reg% hty 1102 := (mulQ Q2695 Q2581).P0, rir_reg% hty 1104 :=
            (mulQ Q2695 Q2581).P1, rir_reg% hty 1106 := (mulQ Q2695 Q2581).P2, rir_reg% hty 1108 :=
            (mulQ Q2695 Q2581).P3, rir_reg% hty 1110 := (mulQ Q2695 Q2581).P4, rir_reg% hty 1122 :=
            (sqrQ (mulQ Q2695 Q2581)).P0, rir_reg% hty 1124 := (sqrQ (mulQ Q2695 Q2581)).P1,
            rir_reg% hty 1126 := (sqrQ (mulQ Q2695 Q2581)).P2, rir_reg% hty 1128 :=
            (sqrQ (mulQ Q2695 Q2581)).P3, rir_reg% hty 1130 := (sqrQ (mulQ Q2695 Q2581)).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb3.runBodyFrom E' 62 S' >>= g) = K) :
    (bb3.runBodyFrom Ein 0 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 146
  qp_sqr 151
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      (((Keeps.refl _ _).storeTmp5 146 147 148 149 150 (by decide) (by decide) (by decide)
            (by decide) (by decide)).storeTmp5
        151 152 153 154 155 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb3`: `_t1 = _t1 _t0`, `_t2 = _t1²`; on to `^bb6`. -/
theorem bb3_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (Q2695 Q2581 : Quad5)
    (hArgs : E.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      E ⊨ [rir_reg% hty 1148 := Q2695.P0, rir_reg% hty 1150 := Q2695.P1, rir_reg% hty 1152 :=
        Q2695.P2, rir_reg% hty 1154 := Q2695.P3, rir_reg% hty 1156 := Q2695.P4, rir_reg% hty 1034 :=
        Q2581.P0, rir_reg% hty 1036 := Q2581.P1, rir_reg% hty 1038 := Q2581.P2, rir_reg% hty 1040 :=
        Q2581.P3, rir_reg% hty 1042 := Q2581.P4, rir_reg% hty 189 := B.slot 146, rir_reg% hty 190 :=
        B.slot 147, rir_reg% hty 191 := B.slot 148, rir_reg% hty 192 := B.slot 149,
        rir_reg% hty 193 := B.slot 150, rir_reg% hty 194 := B.slot 151, rir_reg% hty 195 :=
        B.slot 152, rir_reg% hty 196 := B.slot 153, rir_reg% hty 197 := B.slot 154,
        rir_reg% hty 198 := B.slot 155, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes E E' 1091 1131 →
          (E' ⊨ [rir_reg% hty 1102 := (mulQ Q2695 Q2581).P0, rir_reg% hty 1104 :=
            (mulQ Q2695 Q2581).P1, rir_reg% hty 1106 := (mulQ Q2695 Q2581).P2, rir_reg% hty 1108 :=
            (mulQ Q2695 Q2581).P3, rir_reg% hty 1110 := (mulQ Q2695 Q2581).P4]) →
          Inv B M c S' →
          Keeps B S.mem S'.mem →
          (fd_r52x5_ge_decode2.runFrom (hdr6 E' (sqrQ (mulQ Q2695 Q2581)) 1) 6 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 3 S >>= g) = K := by
  block_init
  refine bb3c0_run _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hB1 hR1 hI1 hK1 => ?_
  have h1560 : E1.read (rir_reg% hty 13) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  exact hK E1 S1 hArgs (hB1.mono) (by chain_reads) hI1 hK1

/-- `^bb5`'s sites `0` to `62`. -/
theorem bb5c0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2763 Q2649 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1216 := Q2763.P0, rir_reg% hty 1218 := Q2763.P1, rir_reg% hty 1220 :=
        Q2763.P2, rir_reg% hty 1222 := Q2763.P3, rir_reg% hty 1224 := Q2763.P4, rir_reg% hty 1102 :=
        Q2649.P0, rir_reg% hty 1104 := Q2649.P1, rir_reg% hty 1106 := Q2649.P2, rir_reg% hty 1108 :=
        Q2649.P3, rir_reg% hty 1110 := Q2649.P4, rir_reg% hty 204 := B.slot 161, rir_reg% hty 205 :=
        B.slot 162, rir_reg% hty 206 := B.slot 163, rir_reg% hty 207 := B.slot 164,
        rir_reg% hty 208 := B.slot 165, rir_reg% hty 209 := B.slot 166, rir_reg% hty 210 :=
        B.slot 167, rir_reg% hty 211 := B.slot 168, rir_reg% hty 212 := B.slot 169,
        rir_reg% hty 213 := B.slot 170, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1159 1199 →
          (E' ⊨ [rir_reg% hty 1190 := (sqrQ (mulQ Q2763 Q2649)).P0, rir_reg% hty 1192 :=
            (sqrQ (mulQ Q2763 Q2649)).P1, rir_reg% hty 1194 := (sqrQ (mulQ Q2763 Q2649)).P2,
            rir_reg% hty 1196 := (sqrQ (mulQ Q2763 Q2649)).P3, rir_reg% hty 1198 :=
            (sqrQ (mulQ Q2763 Q2649)).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb5.runBodyFrom E' 62 S' >>= g) = K) :
    (bb5.runBodyFrom Ein 0 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 161
  qp_sqr 166
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      (((Keeps.refl _ _).storeTmp5 161 162 163 164 165 (by decide) (by decide) (by decide)
            (by decide) (by decide)).storeTmp5
        166 167 168 169 170 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `^bb5`: `_t1 = _t2 _t1`, `_t1 = _t1²`; on to `^bb8`. -/
theorem bb5_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (Q2763 Q2649 : Quad5)
    (hArgs : E.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      E ⊨ [rir_reg% hty 1216 := Q2763.P0, rir_reg% hty 1218 := Q2763.P1, rir_reg% hty 1220 :=
        Q2763.P2, rir_reg% hty 1222 := Q2763.P3, rir_reg% hty 1224 := Q2763.P4, rir_reg% hty 1102 :=
        Q2649.P0, rir_reg% hty 1104 := Q2649.P1, rir_reg% hty 1106 := Q2649.P2, rir_reg% hty 1108 :=
        Q2649.P3, rir_reg% hty 1110 := Q2649.P4, rir_reg% hty 204 := B.slot 161, rir_reg% hty 205 :=
        B.slot 162, rir_reg% hty 206 := B.slot 163, rir_reg% hty 207 := B.slot 164,
        rir_reg% hty 208 := B.slot 165, rir_reg% hty 209 := B.slot 166, rir_reg% hty 210 :=
        B.slot 167, rir_reg% hty 211 := B.slot 168, rir_reg% hty 212 := B.slot 169,
        rir_reg% hty 213 := B.slot 170, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes E E' 1159 1199 →
          Inv B M c S' →
          Keeps B S.mem S'.mem →
          (fd_r52x5_ge_decode2.runFrom (hdr8 E' (sqrQ (mulQ Q2763 Q2649)) 1) 8 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 5 S >>= g) = K := by
  block_init
  refine bb5c0_run _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hB1 hR1 hI1 hK1 => ?_
  have h1560 : E1.read (rir_reg% hty 13) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  exact hK E1 S1 hArgs (hB1.mono) hI1 hK1

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Common.Runs
import Firedancer.R52x5.Decode2.Tactics

/-! The four squaring loops of `FD_R52X5_POW22523_QUAD`: one iteration each, the loops from it. -/

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

@[expose] public section

attribute [local mlir_env 1100] read_write_same

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl zipWith_and_wl zipWith_lshr_wl
  zipWith_add_nsw_nuw_reduce

/-- The counter's `+ 1` does not wrap, signed. -/
theorem saddOverflow_ofNat_one {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow 1#32 = false := by
  have : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, this]
  omega

/-- The counter's `+ 1` does not wrap, unsigned. -/
theorem uaddOverflow_ofNat_one {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).uaddOverflow 1#32 = false := by
  simp [BitVec.uaddOverflow]
  omega

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

variable {β : Type} (k exit : Fin 14) (N lo hi : Nat) (hdr : ⟪Γ⟫ → Quad5 → Nat → ⟪Γ⟫)
  (Pre : ⟪Γ⟫ → Prop) (Out : ⟪Γ⟫ → Quad5 → Prop) (B : GlobalState) (M : MemoryState) (c : Nat)
  (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)

/-- One iteration of the loop at header `k` (env `hdr E X i` at counter `i`, registers
`lo … hi - 1` written): `QP_SQR`, count, test; on to `exit` after the `N`-th, the square in `Out`,
else around. -/
abbrev LoopIter : Prop :=
  ∀ i (S : GlobalState) (E : ⟪Γ⟫) (X : Quad5),
    Inv B M c S →
      Pre E →
      i + 1 ≤ N →
      (i + 1 = N →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          Writes E E' lo hi →
            Out E' (sqrQ X) →
            Inv B M c S' →
            Keeps B S.mem S'.mem → (fd_r52x5_ge_decode2.runFrom E' exit S' >>= g) = K) →
      (i + 1 < N →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          Writes E E' lo hi →
            Inv B M c S' →
            Keeps B S.mem S'.mem →
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
          Inv B M c S' →
          Keeps B S.mem S'.mem → (fd_r52x5_ge_decode2.runFrom E' exit S' >>= g) = K) →
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
    refine h i S E X hI hP (by omega) (by omega) fun _ E' S' hB hI' hk => ?_
    refine
      ih (i + 1) S' E' (sqrQ X) (by omega) hI' (hPre E E' hB hP) fun E'' S'' hB' hO hI'' hk' => ?_
    exact hK E'' S'' (hB.trans hB') hO hI'' (hk.trans hk')

end Loops

/-! ### `^bb2`: `_t2` squared, `20` times in all -/

/-- `^bb2`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr2 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1063 := Ty.wrap X.P0, rir_dst% hty 1064 := Ty.wrap X.P1, rir_dst% hty 1065 :=
    Ty.wrap X.P2, rir_dst% hty 1066 := Ty.wrap X.P3, rir_dst% hty 1067 := Ty.wrap X.P4,
    rir_dst% hty 1068 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb2` reads of the entry: its temporaries `B.slot 111 …`, the constants. -/
abbrev pre2 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 154 := B.slot 111, rir_reg% hty 155 := B.slot 112, rir_reg% hty 156 :=
    B.slot 113, rir_reg% hty 157 := B.slot 114, rir_reg% hty 158 := B.slot 115, rir_reg% hty 23 :=
    (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
    (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
    (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32, rir_reg% hty 26 := 20#32]

/-- `^bb2`'s square, as `^bb1` reads it. -/
abbrev out2 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 1080 := Y.P0, rir_reg% hty 1082 := Y.P1, rir_reg% hty 1084 := Y.P2,
    rir_reg% hty 1086 := Y.P3, rir_reg% hty 1088 := Y.P4]

theorem iter2 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 2 1 20 1063 1091 hdr2 (pre2 B) out2 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 111
  step_pure [saddOverflow_ofNat_one (i := i) (by omega), uaddOverflow_ofNat_one (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
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
        (Keeps.refl _ _).storeTmp5 111 112 113 114 115 (by decide) (by decide) (by decide)
          (by decide) (by decide)
  · step_loop using hback (counter_ne (by decide) hi hbr)
    · exact (BitVec.ofNat_add i 1).symm
    · repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
    · rw [← hS]
      refine ⟨hwf, hF, ?_, ?_⟩
      · rw [hS]
        simp (disch := decide) only [eraseFrom_storeTmp5_slot]
        exact herase
      · rw [hS]
        exact halloc
    · exact
        (Keeps.refl _ _).storeTmp5 111 112 113 114 115 (by decide) (by decide) (by decide)
          (by decide) (by decide)

/-! ### `^bb4`: `_t1` squared, `50` times in all -/

/-- `^bb4`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr4 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1131 := Ty.wrap X.P0, rir_dst% hty 1132 := Ty.wrap X.P1, rir_dst% hty 1133 :=
    Ty.wrap X.P2, rir_dst% hty 1134 := Ty.wrap X.P3, rir_dst% hty 1135 := Ty.wrap X.P4,
    rir_dst% hty 1136 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb4` reads of the entry: its temporaries `B.slot 141 …`, the constants. -/
abbrev pre4 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 184 := B.slot 141, rir_reg% hty 185 := B.slot 142, rir_reg% hty 186 :=
    B.slot 143, rir_reg% hty 187 := B.slot 144, rir_reg% hty 188 := B.slot 145, rir_reg% hty 23 :=
    (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
    (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
    (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32, rir_reg% hty 27 := 50#32]

/-- `^bb4`'s square, as `^bb3` reads it. -/
abbrev out4 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 1148 := Y.P0, rir_reg% hty 1150 := Y.P1, rir_reg% hty 1152 := Y.P2,
    rir_reg% hty 1154 := Y.P3, rir_reg% hty 1156 := Y.P4]

theorem iter4 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 4 3 50 1131 1159 hdr4 (pre4 B) out4 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 141
  step_pure [saddOverflow_ofNat_one (i := i) (by omega), uaddOverflow_ofNat_one (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
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
        (Keeps.refl _ _).storeTmp5 141 142 143 144 145 (by decide) (by decide) (by decide)
          (by decide) (by decide)
  · step_loop using hback (counter_ne (by decide) hi hbr)
    · exact (BitVec.ofNat_add i 1).symm
    · repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
    · rw [← hS]
      refine ⟨hwf, hF, ?_, ?_⟩
      · rw [hS]
        simp (disch := decide) only [eraseFrom_storeTmp5_slot]
        exact herase
      · rw [hS]
        exact halloc
    · exact
        (Keeps.refl _ _).storeTmp5 141 142 143 144 145 (by decide) (by decide) (by decide)
          (by decide) (by decide)

/-! ### `^bb6`: `_t2` squared, `100` times in all -/

/-- `^bb6`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr6 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1199 := Ty.wrap X.P0, rir_dst% hty 1200 := Ty.wrap X.P1, rir_dst% hty 1201 :=
    Ty.wrap X.P2, rir_dst% hty 1202 := Ty.wrap X.P3, rir_dst% hty 1203 := Ty.wrap X.P4,
    rir_dst% hty 1204 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb6` reads of the entry: its temporaries `B.slot 156 …`, the constants. -/
abbrev pre6 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 199 := B.slot 156, rir_reg% hty 200 := B.slot 157, rir_reg% hty 201 :=
    B.slot 158, rir_reg% hty 202 := B.slot 159, rir_reg% hty 203 := B.slot 160, rir_reg% hty 23 :=
    (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
    (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
    (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32, rir_reg% hty 28 := 100#32]

/-- `^bb6`'s square, as `^bb5` reads it. -/
abbrev out6 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 1216 := Y.P0, rir_reg% hty 1218 := Y.P1, rir_reg% hty 1220 := Y.P2,
    rir_reg% hty 1222 := Y.P3, rir_reg% hty 1224 := Y.P4]

theorem iter6 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 6 5 100 1199 1227 hdr6 (pre6 B) out6 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 156
  step_pure [saddOverflow_ofNat_one (i := i) (by omega), uaddOverflow_ofNat_one (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
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
        (Keeps.refl _ _).storeTmp5 156 157 158 159 160 (by decide) (by decide) (by decide)
          (by decide) (by decide)
  · step_loop using hback (counter_ne (by decide) hi hbr)
    · exact (BitVec.ofNat_add i 1).symm
    · repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
    · rw [← hS]
      refine ⟨hwf, hF, ?_, ?_⟩
      · rw [hS]
        simp (disch := decide) only [eraseFrom_storeTmp5_slot]
        exact herase
      · rw [hS]
        exact halloc
    · exact
        (Keeps.refl _ _).storeTmp5 156 157 158 159 160 (by decide) (by decide) (by decide)
          (by decide) (by decide)

/-! ### `^bb8`: `_t1` squared, `50` times in all -/

/-- `^bb8`'s header: `X` in its parameters, the counter `i`. -/
abbrev hdr8 (E : ⟪Γ⟫) (X : Quad5) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1341 := Ty.wrap X.P0, rir_dst% hty 1342 := Ty.wrap X.P1, rir_dst% hty 1343 :=
    Ty.wrap X.P2, rir_dst% hty 1344 := Ty.wrap X.P3, rir_dst% hty 1345 := Ty.wrap X.P4,
    rir_dst% hty 1346 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- What `^bb8` reads of the entry: its temporaries `B.slot 171 …`, the constants. -/
abbrev pre8 (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 214 := B.slot 171, rir_reg% hty 215 := B.slot 172, rir_reg% hty 216 :=
    B.slot 173, rir_reg% hty 217 := B.slot 174, rir_reg% hty 218 := B.slot 175, rir_reg% hty 23 :=
    (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
    (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
    (Vector.replicate 4 19#64 : Wl), rir_reg% hty 13 := 1#32, rir_reg% hty 27 := 50#32]

/-- `^bb8`'s square, as `^bb7` reads it. -/
abbrev out8 (E : ⟪Γ⟫) (Y : Quad5) : Prop :=
  E ⊨ [rir_reg% hty 1358 := Y.P0, rir_reg% hty 1360 := Y.P1, rir_reg% hty 1362 := Y.P2,
    rir_reg% hty 1364 := Y.P3, rir_reg% hty 1366 := Y.P4]

theorem iter8 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    LoopIter 8 7 50 1341 1369 hdr8 (pre8 B) out8 B M c g K := by
  intro i S E X hI hP hi hexit hback
  block_init
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_sqr 171
  step_pure [saddOverflow_ofNat_one (i := i) (by omega), uaddOverflow_ofNat_one (i := i) (by omega)]
  step_pure
  finish_block
  · refine hexit (counter_eq (by decide) hi hbr) E S ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
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
        (Keeps.refl _ _).storeTmp5 171 172 173 174 175 (by decide) (by decide) (by decide)
          (by decide) (by decide)
  · step_loop using hback (counter_ne (by decide) hi hbr)
    · exact (BitVec.ofNat_add i 1).symm
    · repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
    · rw [← hS]
      refine ⟨hwf, hF, ?_, ?_⟩
      · rw [hS]
        simp (disch := decide) only [eraseFrom_storeTmp5_slot]
        exact herase
      · rw [hS]
        exact halloc
    · exact
        (Keeps.refl _ _).storeTmp5 171 172 173 174 175 (by decide) (by decide) (by decide)
          (by decide) (by decide)

/-- The loop at `^bb2`, from `iter2`. -/
theorem loop2 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 2 1 20 1063 1091 hdr2 (pre2 B) out2 B M c g K :=
  loop_of_iter (iter2 B M c g K) fun _ _ hB hP => by
    unfold pre2 at hP ⊢
    chain_reads

/-- The loop at `^bb4`, from `iter4`. -/
theorem loop4 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 4 3 50 1131 1159 hdr4 (pre4 B) out4 B M c g K :=
  loop_of_iter (iter4 B M c g K) fun _ _ hB hP => by
    unfold pre4 at hP ⊢
    chain_reads

/-- The loop at `^bb6`, from `iter6`. -/
theorem loop6 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 6 5 100 1199 1227 hdr6 (pre6 B) out6 B M c g K :=
  loop_of_iter (iter6 B M c g K) fun _ _ hB hP => by
    unfold pre6 at hP ⊢
    chain_reads

/-- The loop at `^bb8`, from `iter8`. -/
theorem loop8 {β : Type} (B : GlobalState) (M : MemoryState) (c : Nat)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Loop 8 7 50 1341 1369 hdr8 (pre8 B) out8 B M c g K :=
  loop_of_iter (iter8 B M c g K) fun _ _ hB hP => by
    unfold pre8 at hP ⊢
    chain_reads

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

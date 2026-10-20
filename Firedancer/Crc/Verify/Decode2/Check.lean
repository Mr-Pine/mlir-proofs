module

public import Firedancer.Crc.Verify.Decode2.Frame
import Firedancer.Crc.Verify.Decode2.Tactics

/-! The lane checks of `fd_r52x5_ge_decode2` (`^bb9` … `^bb13`) and its return (`^bb15`). -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

/-- The memory `^bb15` returns: the limbs' lifetimes ended. -/
abbrev endY (m : MemoryState) (B : GlobalState) : MemoryState :=
  (m.lifetimeEnd (B.slot 1)).lifetimeEnd (B.slot 0)

/-- `^bb15`: the limbs' lifetimes end, `r` is returned. -/
theorem bb15_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} (r : BitVec 32)
    (hR : E ⊨ [rir_reg% hty 934 := r, rir_reg% hty 139 := B.slot 0, rir_reg% hty 140 := B.slot 1]) :
    (fd_r52x5_ge_decode2.runFrom E 15 S >>= g) =
      g (.cons (.value r) .nil, { S with mem := endY S.mem B }) := by
  block_init
  iterate 2 step_pure
  finish_block
  rw [hS]

/-- `^bb12`: lane 1 has no root: `ok0` is returned. -/
theorem bb12_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState} {M : MemoryState} {c : Nat}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} (ok0 : BitVec 32)
    (hR : E ⊨ [rir_reg% hty 770 := ok0, rir_reg% hty 366 := B.slot 227,
      rir_reg% hty 367 := B.slot 228, rir_reg% hty 368 := B.slot 229, rir_reg% hty 139 := B.slot 0,
      rir_reg% hty 140 := B.slot 1])
    (hI : Inv B M c S)
    (hK : ∀ S' : GlobalState, Inv B M c S' →
      g (.cons (.value ok0) .nil, { S' with mem := endY S'.mem B }) = K) :
    (fd_r52x5_ge_decode2.runFrom E 12 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  block_init
  iterate 3 step_pure
  finish_block
  rw [bb15_run ok0 (by lemma_reads)]
  refine hK S ⟨hwf, hF, ?_, ?_⟩
  · rw [hS]
    simp (disch := decide) only [eraseFrom_lifetimeEnd_slot]
    exact herase
  · rw [hS]
    exact halloc

/-- `^bb13`: lane 1 has a root (`fix1` its fix): `2` if lane 0 has none, else on to `^bb14`. -/
theorem bb13_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState} {M : MemoryState} {c : Nat}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} (ok0 fix1 : BitVec 32)
    (hR : E ⊨ [rir_reg% hty 770 := ok0, rir_reg% hty 775 := fix1, rir_reg% hty 62 := 0#32,
      rir_reg% hty 57 := 2#32, rir_reg% hty 366 := B.slot 227,
      rir_reg% hty 367 := B.slot 228, rir_reg% hty 368 := B.slot 229, rir_reg% hty 139 := B.slot 0,
      rir_reg% hty 140 := B.slot 1])
    (hI : Inv B M c S)
    (hK15 : ok0 = 0 → ∀ S' : GlobalState, Inv B M c S' →
      g (.cons (.value 2) .nil, { S' with mem := endY S'.mem B }) = K)
    (hK14 : ok0 ≠ 0 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = E.args → Writes E E' 776 777 →
      Inv B M c S' → (fd_r52x5_ge_decode2.runFrom E' 14 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 13 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  block_init
  iterate 3 step_pure
  step_pure
  finish_block
  case isTrue =>
    rw [bb15_run 2 (by lemma_reads)]
    refine hK15 (by simpa using hbr) S ⟨hwf, hF, ?_, ?_⟩
    · rw [hS]
      simp (disch := decide) only [eraseFrom_lifetimeEnd_slot]
      exact herase
    · rw [hS]
      exact halloc
  case isFalse =>
    refine hK14 (by simpa using hbr) E S (by rw [hE]; rfl) ?_ ⟨hwf, hF, ?_, ?_⟩
    · rw [hE]
      writes_chain
    · rw [hS]
      simp (disch := decide) only [eraseFrom_lifetimeEnd_slot]
      exact herase
    · rw [hS]
      exact halloc

set_option maxHeartbeats 4000000 in
/-- `^bb7`'s sites `144` to `152`: lane 0's canonical `v x²`, `u`, `-u`, and whether the first
two are equal. -/
theorem lane0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (VX2 U NU : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 742 := VX2.P0, rir_reg% hty 743 := VX2.P1,
      rir_reg% hty 744 := VX2.P2, rir_reg% hty 745 := VX2.P3, rir_reg% hty 746 := VX2.P4,
      rir_reg% hty 418 := U.P0, rir_reg% hty 419 := U.P1, rir_reg% hty 420 := U.P2,
      rir_reg% hty 421 := U.P3, rir_reg% hty 422 := U.P4,
      rir_reg% hty 747 := NU.P0, rir_reg% hty 748 := NU.P1, rir_reg% hty 749 := NU.P2,
      rir_reg% hty 750 := NU.P3, rir_reg% hty 751 := NU.P4,
      rir_reg% hty 366 := B.slot 227, rir_reg% hty 367 := B.slot 228,
      rir_reg% hty 368 := B.slot 229, rir_reg% hty 62 := 0#32])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 752 754 →
      (E' ⊨ [rir_reg% hty 752 := fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec VX2 0)
          (fd_r52x5_quad_lane_canon.spec U 0),
        rir_reg% hty 753 := BitVec.ofBool (fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec VX2 0)
          (fd_r52x5_quad_lane_canon.spec U 0) == 0#32)]) →
      S'.mem.readLimbs (B.slot 227) = fd_r52x5_quad_lane_canon.spec VX2 0 →
      S'.mem.readLimbs (B.slot 229) = fd_r52x5_quad_lane_canon.spec NU 0 →
      S'.mem.LimbsFit (B.slot 227) → S'.mem.LimbsFit (B.slot 229) →
      Inv B M (c + 18) S' → (bb7.runBodyFrom E' 152 S' >>= g) = K) :
    (bb7.runBodyFrom Ein 144 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  obtain ⟨i0, w0⟩ := hF.limbs 227
  obtain ⟨i1, w1⟩ := hF.limbs 228
  obtain ⟨i2, w2⟩ := hF.limbs 229
  iterate 3 step_pure
  have r0 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 227) 320› rfl
  have r1 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 228) 320› rfl
  have r2 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 229) 320› rfl
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := VX2) (hl := by decide)) consuming r0
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := U) (hl := by decide)) consuming r1
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := NU) (hl := by decide)) consuming r2
  have hv := ‹S.mem.readLimbs (B.slot 227) = fd_r52x5_quad_lane_canon.spec VX2 0›
  have hn := ‹S.mem.readLimbs (B.slot 229) = fd_r52x5_quad_lane_canon.spec NU 0›
  have f0 := r0
  have f2 := r2
  step_call using fd_r52x5_limbs_eq.call_eq
  step_pure
  refine hK E S hArgs ?_ ?_ hv hn f0 f2 ⟨hwf, hF, ?_, ?_⟩
  · rw [hE]
    writes_chain
  · lemma_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeLimbs_slot, eraseFrom_lifetimeStart_slot]
    exact herase
  · rw [hS]
    simp only
    omega

theorem limbs_eq_01 (a b : Fin 5 → BitVec 64) :
    fd_r52x5_limbs_eq.spec a b = 0 ∨ fd_r52x5_limbs_eq.spec a b = 1 := by
  unfold fd_r52x5_limbs_eq.spec; split <;> simp

theorem neg_limbs_eq_nsw (a b : Fin 5 → BitVec 64) :
    (0#32).ssubOverflow (fd_r52x5_limbs_eq.spec a b) = false := by
  rcases limbs_eq_01 a b with h | h <;> rw [h] <;> decide

/-- `^bb9`: lane 0's `v x²` against `-u`: `ok0` that, `fix0` its negation. -/
theorem bb9_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    (cv cn : Fin 5 → BitVec 64)
    (hR : E ⊨ [rir_reg% hty 366 := B.slot 227, rir_reg% hty 368 := B.slot 229,
      rir_reg% hty 62 := 0#32])
    (hP : S.WF ∧ S.mem.readLimbs (B.slot 227) = cv ∧ S.mem.readLimbs (B.slot 229) = cn ∧
      S.mem.LimbsFit (B.slot 227) ∧ S.mem.LimbsFit (B.slot 229))
    (hK : ∀ E' : ⟪Γ⟫, E'.args = E.args → Writes E E' 767 771 →
      (E' ⊨ [rir_reg% hty 769 := (0 : BitVec 32) - fd_r52x5_limbs_eq.spec cv cn,
        rir_reg% hty 770 := fd_r52x5_limbs_eq.spec cv cn]) →
      (fd_r52x5_ge_decode2.runFrom E' 10 S >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 9 S >>= g) = K := by
  block_init
  obtain ⟨hwf, hv, hn, f0, f2⟩ := hP
  step_call using fd_r52x5_limbs_eq.call_eq
  step_pure [neg_limbs_eq_nsw]
  finish_block
  rw [hS]
  refine hK E (by rw [hE]; rfl) ?_ ?_
  · rw [hE]
    writes_chain
  · simp only [hE]
    lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb10`: lane 1's canonical `v x²`, `u`, `-u`, and on to `^bb13` (`fix1 = 0`) if the first
two are equal, else `^bb11`. -/
theorem bb10_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (VX2 U NU : Quad5)
    (hR : E ⊨ [rir_reg% hty 742 := VX2.P0, rir_reg% hty 743 := VX2.P1,
      rir_reg% hty 744 := VX2.P2, rir_reg% hty 745 := VX2.P3, rir_reg% hty 746 := VX2.P4,
      rir_reg% hty 418 := U.P0, rir_reg% hty 419 := U.P1, rir_reg% hty 420 := U.P2,
      rir_reg% hty 421 := U.P3, rir_reg% hty 422 := U.P4,
      rir_reg% hty 747 := NU.P0, rir_reg% hty 748 := NU.P1, rir_reg% hty 749 := NU.P2,
      rir_reg% hty 750 := NU.P3, rir_reg% hty 751 := NU.P4,
      rir_reg% hty 366 := B.slot 227, rir_reg% hty 367 := B.slot 228,
      rir_reg% hty 368 := B.slot 229, rir_reg% hty 62 := 0#32, rir_reg% hty 58 := 1#32])
    (hI : Inv B M c S)
    (hK11 : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = E.args → Writes E E' 771 773 →
      fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec VX2 1)
          (fd_r52x5_quad_lane_canon.spec U 1) = 0 →
      S'.mem.readLimbs (B.slot 227) = fd_r52x5_quad_lane_canon.spec VX2 1 →
      S'.mem.readLimbs (B.slot 229) = fd_r52x5_quad_lane_canon.spec NU 1 →
      S'.mem.LimbsFit (B.slot 227) → S'.mem.LimbsFit (B.slot 229) →
      Inv B M (c + 18) S' → (fd_r52x5_ge_decode2.runFrom E' 11 S' >>= g) = K)
    (hK13 : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = E.args → Writes E E' 771 776 →
      fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec VX2 1)
          (fd_r52x5_quad_lane_canon.spec U 1) ≠ 0 →
      (E' ⊨ [rir_reg% hty 775 := 0#32]) →
      Inv B M (c + 18) S' → (fd_r52x5_ge_decode2.runFrom E' 13 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 10 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  block_init
  iterate 3 step_pure
  obtain ⟨i0, w0⟩ := hF.limbs 227
  obtain ⟨i1, w1⟩ := hF.limbs 228
  obtain ⟨i2, w2⟩ := hF.limbs 229
  iterate 3 step_pure
  have r0 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 227) 320› rfl
  have r1 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 228) 320› rfl
  have r2 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 229) 320› rfl
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := VX2) (hl := by decide)) consuming r0
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := U) (hl := by decide)) consuming r1
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := NU) (hl := by decide)) consuming r2
  have hv := ‹S.mem.readLimbs (B.slot 227) = fd_r52x5_quad_lane_canon.spec VX2 1›
  have hn := ‹S.mem.readLimbs (B.slot 229) = fd_r52x5_quad_lane_canon.spec NU 1›
  have f0 := r0
  have f2 := r2
  step_call using fd_r52x5_limbs_eq.call_eq
  step_pure
  finish_block
  case isTrue =>
    refine hK11 E S (by rw [hE]; rfl) ?_ (by simpa using hbr) hv hn f0 f2 ⟨hwf, hF, ?_, ?_⟩
    · rw [hE]
      writes_chain
    · rw [hS]
      simp (disch := decide) only [eraseFrom_storeLimbs_slot, eraseFrom_lifetimeStart_slot,
        eraseFrom_lifetimeEnd_slot]
      exact herase
    · rw [hS]
      simp only
      omega
  case isFalse =>
    refine hK13 E S (by rw [hE]; rfl) ?_ (by simpa using hbr) ?_ ⟨hwf, hF, ?_, ?_⟩
    · rw [hE]
      writes_chain
    · lemma_reads
    · rw [hS]
      simp (disch := decide) only [eraseFrom_storeLimbs_slot, eraseFrom_lifetimeStart_slot,
        eraseFrom_lifetimeEnd_slot]
      exact herase
    · rw [hS]
      simp only
      omega

/-- `^bb11`: lane 1's `v x²` against `-u`: on to `^bb12` if unequal, else `^bb13` with
`fix1 = -1`. -/
theorem bb11_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    (cv cn : Fin 5 → BitVec 64)
    (hR : E ⊨ [rir_reg% hty 366 := B.slot 227, rir_reg% hty 368 := B.slot 229,
      rir_reg% hty 62 := 0#32, rir_reg% hty 44 := 4294967295#32])
    (hP : S.WF ∧ S.mem.readLimbs (B.slot 227) = cv ∧ S.mem.readLimbs (B.slot 229) = cn ∧
      S.mem.LimbsFit (B.slot 227) ∧ S.mem.LimbsFit (B.slot 229))
    (hK12 : ∀ E' : ⟪Γ⟫, E'.args = E.args → Writes E E' 773 775 →
      fd_r52x5_limbs_eq.spec cv cn = 0 → (fd_r52x5_ge_decode2.runFrom E' 12 S >>= g) = K)
    (hK13 : ∀ E' : ⟪Γ⟫, E'.args = E.args → Writes E E' 773 776 →
      fd_r52x5_limbs_eq.spec cv cn ≠ 0 → (E' ⊨ [rir_reg% hty 775 := 4294967295#32]) →
      (fd_r52x5_ge_decode2.runFrom E' 13 S >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 11 S >>= g) = K := by
  block_init
  obtain ⟨hwf, hv, hn, f0, f2⟩ := hP
  step_call using fd_r52x5_limbs_eq.call_eq
  step_pure
  finish_block
  case isTrue =>
    rw [hS]
    refine hK12 E (by rw [hE]; rfl) ?_ (by simpa using hbr)
    rw [hE]
    writes_chain
  case isFalse =>
    rw [hS]
    refine hK13 E (by rw [hE]; rfl) ?_ (by simpa using hbr) ?_
    · rw [hE]
      writes_chain
    · lemma_reads

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify

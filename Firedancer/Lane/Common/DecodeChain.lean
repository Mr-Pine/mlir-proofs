module

public import Firedancer.Lane.Common.DecodeStaged
public import Firedancer.Lane.fd_r43x6_ge_decode2
public import Firedancer.Math.Avx512.Decode

/-! The staged decode's chain: whatever the steps, the decode ends as `fd_r43x6_ge_decode`'s. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- One step of the chain: a squaring if the stage has one left, else the stage's multiply and the
next stage's start, else none. -/
def DecSt.op1 (D : DecSt) : DecSt :=
  if D.rem ≠ 0 then D.sqrs 1#64 else if D.stage < 12 then D.stageOp else D

/-- `k` steps of the chain. -/
def DecSt.ops : Nat → DecSt → DecSt
  | 0, D => D
  | k + 1, D => DecSt.ops k D.op1

/-- The steps of `k` stages from `t` on, each its squarings and multiply. -/
def DecSt.stagesFrom : Nat → Nat → Nat
  | 0, _ => 0
  | k + 1, t => (sqrCnt (BitVec.ofNat 64 t)).toNat + 1 + DecSt.stagesFrom k (t + 1)

/-- The steps of the stages from `t` on. -/
def DecSt.stagesLeft (t : Nat) : Nat :=
  DecSt.stagesFrom (12 - t) t

/-- The steps left to the chain's end. -/
def DecSt.left (D : DecSt) : Nat :=
  D.rem.toNat + if D.stage.toNat < 12 then 1 + DecSt.stagesLeft (D.stage.toNat + 1) else 0

/-- A state on the chain: at most twelve stages, no squarings left past the last. -/
def DecSt.Valid (D : DecSt) : Prop :=
  D.Fin ∧ D.stage.toNat ≤ 12

/-- `DecSt.stagesLeft` one stage on. -/
theorem DecSt.stagesLeft_eq (t : Nat) :
    DecSt.stagesLeft t =
      if t < 12 then (sqrCnt (BitVec.ofNat 64 t)).toNat + 1 + DecSt.stagesLeft (t + 1) else 0 := by
  unfold DecSt.stagesLeft
  split
  · rename_i h
    rw [show 12 - t = (12 - (t + 1)) + 1 by omega, DecSt.stagesFrom]
  · rw [show 12 - t = 0 by omega, DecSt.stagesFrom]

/-- The chain's steps add. -/
theorem DecSt.ops_add : ∀ (a b : Nat) (D : DecSt), DecSt.ops (a + b) D = DecSt.ops b (DecSt.ops a D)
  | 0, b, D => by simp [DecSt.ops]
  | a + 1, b, D => by
    rw [show a + 1 + b = (a + b) + 1 by omega, DecSt.ops, DecSt.ops, DecSt.ops_add a b]

/-- Squarings after squarings. -/
theorem DecSt.sqrN_add : ∀ (a b : Nat) (x : Wwl),
    Avx512.fd_r43x6_repsqr_mul2.sqrN (a + b) x =
      Avx512.fd_r43x6_repsqr_mul2.sqrN b (Avx512.fd_r43x6_repsqr_mul2.sqrN a x)
  | 0, b, x => by simp [Avx512.fd_r43x6_repsqr_mul2.sqrN]
  | a + 1, b, x => by
    rw [show a + 1 + b = (a + b) + 1 by omega, Avx512.fd_r43x6_repsqr_mul2.sqrN,
      Avx512.fd_r43x6_repsqr_mul2.sqrN, DecSt.sqrN_add a b]

/-- `k` steps within the stage's squarings are `k` squarings. -/
theorem DecSt.ops_of_le : ∀ (k : Nat) (D : DecSt), k ≤ D.rem.toNat →
    DecSt.ops k D = D.sqrs (BitVec.ofNat 64 k)
  | 0, D, _ => by simp [DecSt.ops, DecSt.sqrs_zero]
  | k + 1, D, h => by
    have h0 : D.rem ≠ 0 := fun h' => by simp [h'] at h
    have hr : (D.rem - 1#64).toNat = D.rem.toNat - 1 := by
      rw [BitVec.toNat_sub_of_le (by
        rw [BitVec.le_def]
        simp
        omega)]
      rfl
    rw [DecSt.ops, DecSt.op1, ite_eq_left h0, DecSt.ops_of_le k _ (by
      simp only [DecSt.sqrs]
      rw [hr]
      omega)]
    have hk : (BitVec.ofNat 64 (k + 1)).toNat = 1 + k := by
      rw [BitVec.toNat_ofNat]
      have := D.rem.isLt
      omega
    have hk' : (BitVec.ofNat 64 k).toNat = k := by
      rw [BitVec.toNat_ofNat]
      have := D.rem.isLt
      omega
    simp only [DecSt.sqrs, hk, hk', DecSt.sqrN_add, BitVec.sub_sub]
    congr 2
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_add, hk', hk]
    simp only [BitVec.toNat_ofNat]
    have := D.rem.isLt
    omega

/-- The stage after `s < 12`, as a number. -/
theorem DecSt.stage_succ_toNat {s : BitVec 64} (h : s.toNat < 12) :
    (s + 1).toNat = s.toNat + 1 := by
  rw [BitVec.toNat_add]
  simp
  omega

/-- `s < 12`, as numbers. -/
theorem DecSt.lt12_iff (s : BitVec 64) : s < 12 ↔ s.toNat < 12 := by
  rw [BitVec.lt_def]
  rfl

/-- A step keeps a state on the chain. -/
theorem DecSt.Valid.op1 {D : DecSt} (h : D.Valid) : D.op1.Valid := by
  unfold DecSt.op1
  by_cases h0 : D.rem ≠ 0
  · rw [ite_eq_left h0]
    exact ⟨fun h' => absurd (h.1 h') h0, h.2⟩
  · rw [ite_eq_right h0]
    by_cases hs : D.stage < 12
    · rw [ite_eq_left hs]
      have hs' := (DecSt.lt12_iff _).1 hs
      refine ⟨DecSt.Fin.stageOp D, ?_⟩
      simp only [DecSt.stageOp, DecSt.stageMul_stage]
      rw [DecSt.stage_succ_toNat hs']
      omega
    · rw [ite_eq_right hs]
      exact h

/-- A step on the chain takes one off the steps left. -/
theorem DecSt.left_op1 (D : DecSt) : D.op1.left = D.left - 1 := by
  unfold DecSt.op1
  by_cases h0 : D.rem ≠ 0
  · rw [ite_eq_left h0]
    have hr : (D.rem - 1#64).toNat = D.rem.toNat - 1 := by
      rw [BitVec.toNat_sub_of_le (by
        rw [BitVec.le_def]
        have : D.rem.toNat ≠ 0 := fun e => h0 (BitVec.eq_of_toNat_eq e)
        simp
        omega)]
      rfl
    have : D.rem.toNat ≠ 0 := fun e => h0 (BitVec.eq_of_toNat_eq e)
    unfold DecSt.left
    rw [show (D.sqrs 1#64).rem = D.rem - 1#64 from rfl, show (D.sqrs 1#64).stage = D.stage from rfl,
      hr]
    omega
  · rw [ite_eq_right h0]
    have h0' : D.rem = 0 := not_not.1 h0
    by_cases hs : D.stage < 12
    · rw [ite_eq_left hs]
      have hs' := (DecSt.lt12_iff _).1 hs
      have e := DecSt.stage_succ_toNat hs'
      have z : (0 : BitVec 64).toNat = 0 := rfl
      have k1 : D.stageOp.stage = D.stage + 1 := by
        simp only [DecSt.stageOp, DecSt.stageMul_stage]
      have k2 : D.stageOp.rem = if D.stage + 1 < 12 then sqrCnt (D.stage + 1) else 0 := by
        simp only [DecSt.stageOp, DecSt.stageMul_stage]
      unfold DecSt.left
      rw [k1, k2, h0', e, ite_eq_left hs', DecSt.stagesLeft_eq (D.stage.toNat + 1)]
      by_cases h11 : D.stage.toNat + 1 < 12
      · have hb : D.stage + 1 < 12 := (DecSt.lt12_iff _).2 (e ▸ h11)
        rw [ite_eq_left hb, ite_eq_left h11, ite_eq_left h11]
        have : BitVec.ofNat 64 (D.stage.toNat + 1) = D.stage + 1 := by
          apply BitVec.eq_of_toNat_eq
          rw [e, BitVec.toNat_ofNat]
          omega
        rw [this, z]
        omega
      · have hb : ¬D.stage + 1 < 12 := fun h' => h11 (e ▸ (DecSt.lt12_iff _).1 h')
        rw [ite_eq_right hb, ite_eq_right h11, ite_eq_right h11, z]
    · rw [ite_eq_right hs]
      have hs' : ¬D.stage.toNat < 12 := fun e => hs ((DecSt.lt12_iff _).2 e)
      have z : (0 : BitVec 64).toNat = 0 := rfl
      simp only [DecSt.left, h0', hs', ite_false, z]

/-- A chain with no steps left stays. -/
theorem DecSt.op1_of_left {D : DecSt} (h : D.left = 0) : D.op1 = D := by
  unfold DecSt.left at h
  have hr : D.rem = 0 := BitVec.eq_of_toNat_eq (by simp; omega)
  have hs : ¬D.stage < 12 := by
    rw [DecSt.lt12_iff]
    intro e
    rw [ite_eq_left e] at h
    omega
  simp only [DecSt.op1, hr, ne_eq, not_true_eq_false, ite_false, hs]

/-- `k` steps keep a state on the chain and take `k` off the steps left. -/
theorem DecSt.ops_valid_left : ∀ (k : Nat) {D : DecSt}, D.Valid →
    (DecSt.ops k D).Valid ∧ (DecSt.ops k D).left = D.left - k
  | 0, D, h => ⟨h, rfl⟩
  | k + 1, D, h => by
    obtain ⟨h1, h2⟩ := DecSt.ops_valid_left k h.op1
    refine ⟨h1, ?_⟩
    rw [DecSt.ops, h2, DecSt.left_op1 D]
    omega

/-- A chain with no steps left stays through any steps. -/
theorem DecSt.ops_of_left : ∀ (k : Nat) {D : DecSt}, D.left = 0 → DecSt.ops k D = D
  | 0, _, _ => rfl
  | k + 1, D, h => by
    rw [DecSt.ops, DecSt.op1_of_left h, DecSt.ops_of_left k h]

/-- A stage's multiply and start keep a state on the chain. -/
theorem DecSt.Valid.stageOp {D : DecSt} (hs : D.stage.toNat < 12) : D.stageOp.Valid := by
  refine ⟨DecSt.Fin.stageOp D, ?_⟩
  simp only [DecSt.stageOp, DecSt.stageMul_stage]
  rw [DecSt.stage_succ_toNat hs]
  omega

/-- One step is `op1`. -/
theorem DecSt.ops_one (D : DecSt) : DecSt.ops 1 D = D.op1 := rfl

/-- `fd_r43x6_ge_decode_step_slow`'s loop with enough rounds: `n` steps of the chain, or those
left. -/
theorem DecSt.stepSlowF_ops : ∀ (f : Nat) (D : DecSt) (n : BitVec 64), D.Valid →
    12 - D.stage.toNat < f → D.stepSlowF f n = DecSt.ops (min n.toNat D.left) D
  | 0, _, _, _, hf => absurd hf (by omega)
  | f + 1, D, n, h, hf => by
    by_cases hc : n ≠ 0 ∧ D.stage < 12
    · have hs := (DecSt.lt12_iff _).1 hc.2
      have hn : n.toNat ≠ 0 := fun e => hc.1 (BitVec.eq_of_toNat_eq e)
      rw [DecSt.stepSlowF, ite_eq_left hc]
      dsimp only
      have hL := DecSt.ops_valid_left D.rem.toNat h
      rw [DecSt.ops_of_le _ _ le_rfl, BitVec.ofNat_toNat, BitVec.setWidth_eq] at hL
      by_cases hr : D.rem.ult n
      · rw [ite_eq_left hr]
        have hr' : D.rem.toNat < n.toNat := by simpa [BitVec.ult] using hr
        have hn' : n - D.rem ≠ 0 := by
          intro e
          have := congrArg BitVec.toNat e
          rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; omega)] at this
          simp at this
          omega
        have hz : (D.sqrs D.rem).rem = 0 := by simp [DecSt.sqrs]
        rw [ite_eq_left ⟨hn', hz⟩]
        have hs' : (D.sqrs D.rem).stage.toNat < 12 := hs
        have hop : (D.sqrs D.rem).op1 = (D.sqrs D.rem).stageOp := by
          rw [DecSt.op1, ite_eq_right (not_not.2 hz),
            ite_eq_left (show (D.sqrs D.rem).stage < 12 from hc.2)]
        have hl1 := DecSt.left_op1 (D.sqrs D.rem)
        rw [hop] at hl1
        have hpos : 1 ≤ (D.sqrs D.rem).left := by
          unfold DecSt.left
          rw [ite_eq_left hs']
          omega
        rw [DecSt.stepSlowF_ops f _ _ (DecSt.Valid.stageOp hs') (by
          simp only [DecSt.stageOp, DecSt.stageMul_stage]
          rw [DecSt.stage_succ_toNat hs']
          exact Nat.lt_of_lt_of_le (by simp only [DecSt.sqrs]; omega) le_rfl)]
        have hnk : (n - D.rem - 1).toNat = n.toNat - D.rem.toNat - 1 := by
          rw [BitVec.toNat_sub_of_le (by
              rw [BitVec.le_def, BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; omega)]
              simp
              omega),
            BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; omega)]
          simp
        have hq : D.sqrs D.rem = DecSt.ops D.rem.toNat D := by
          rw [DecSt.ops_of_le _ _ le_rfl, BitVec.ofNat_toNat, BitVec.setWidth_eq]
        have hL2 := hL.2
        rw [hq] at hL2 hpos
        rw [hnk, hl1, ← hop, ← DecSt.ops_one, ← DecSt.ops_add, hq, ← DecSt.ops_add]
        congr 1
        omega
      · rw [ite_eq_right hr]
        have hr' : n.toNat ≤ D.rem.toNat := by simpa [BitVec.ult] using hr
        have hc2 : ¬(n - n ≠ 0 ∧ (D.sqrs n).rem = 0) := by simp
        have hm : min n.toNat D.left = n.toNat := by
          unfold DecSt.left
          omega
        rw [ite_eq_right hc2, BitVec.sub_self, DecSt.stepSlowF_zero, hm,
          DecSt.ops_of_le _ _ hr', BitVec.ofNat_toNat, BitVec.setWidth_eq]
    · rw [DecSt.stepSlowF_done _ hc]
      by_cases hn : n = 0
      · subst hn
        rfl
      · have hs : 12 ≤ D.stage.toNat := by
          by_contra e
          exact hc ⟨hn, (DecSt.lt12_iff _).2 (by omega)⟩
        have hr := h.1 hs
        have : D.left = 0 := by
          unfold DecSt.left
          rw [hr, ite_eq_right (by omega)]
          rfl
        rw [this, Nat.min_zero]
        rfl

/-- A stage's squarings, then its multiply and the next stage's start. -/
def DecSt.stageRun (D : DecSt) : DecSt :=
  (D.sqrs D.rem).stageOp

/-- A stage before the last, as the chain's steps: its squarings left and the multiply. -/
theorem DecSt.ops_stageRun {D : DecSt} (h : D.Valid) (hs : D.stage.toNat < 12) :
    DecSt.ops (D.rem.toNat + 1) D = D.stageRun ∧ D.stageRun.Valid ∧
      D.stageRun.left = D.left - D.rem.toNat - 1 := by
  have hq : D.sqrs D.rem = DecSt.ops D.rem.toNat D := by
    rw [DecSt.ops_of_le _ _ le_rfl, BitVec.ofNat_toNat, BitVec.setWidth_eq]
  have hz : (D.sqrs D.rem).rem = 0 := by simp [DecSt.sqrs]
  have hop : (D.sqrs D.rem).op1 = D.stageRun := by
    rw [DecSt.op1, ite_eq_right (not_not.2 hz),
      ite_eq_left (show (D.sqrs D.rem).stage < 12 from (DecSt.lt12_iff _).2 hs)]
    rfl
  have hL := (DecSt.ops_valid_left D.rem.toNat h).2
  have hl1 := DecSt.left_op1 (D.sqrs D.rem)
  rw [hop, hq, hL] at hl1
  refine ⟨?_, DecSt.Valid.stageOp hs, ?_⟩
  · rw [DecSt.ops_add, DecSt.ops_one, ← hq, hop]
  · rw [hl1]

/-- The chain from a state on it to its end: the stages left, each run whole. -/
theorem DecSt.ops_left : ∀ (k : Nat) (D : DecSt), D.Valid → 12 - D.stage.toNat = k →
    DecSt.ops D.left D = DecSt.stageRun^[k] D
  | 0, D, h, hk => by
    have hr := h.1 (by omega)
    have : D.left = 0 := by
      unfold DecSt.left
      rw [hr, ite_eq_right (by omega)]
      rfl
    rw [this]
    rfl
  | k + 1, D, h, hk => by
    have hs : D.stage.toNat < 12 := by omega
    obtain ⟨e1, e2, e3⟩ := DecSt.ops_stageRun h hs
    have hpos : D.rem.toNat + 1 ≤ D.left := by
      unfold DecSt.left
      rw [ite_eq_left hs]
      omega
    have hst : D.stageRun.stage.toNat = D.stage.toNat + 1 := by
      simp only [DecSt.stageRun, DecSt.stageOp, DecSt.stageMul_stage]
      exact DecSt.stage_succ_toNat hs
    rw [show D.left = (D.rem.toNat + 1) + D.stageRun.left by omega, DecSt.ops_add, e1,
      DecSt.ops_left k _ e2 (by omega), Function.iterate_succ_apply]

/-- A state on the decode's chain from the encoding `s`: some steps from `DecSt.init s`. -/
def DecSt.Reach (s : BitVec 256) (D : DecSt) : Prop :=
  ∃ j, D = DecSt.ops j (DecSt.init s)

/-- The start's stage. -/
theorem DecSt.init_stage (s : BitVec 256) : (DecSt.init s).stage = 0 := rfl

/-- The start's squarings. -/
theorem DecSt.init_rem (s : BitVec 256) : (DecSt.init s).rem = 1 := rfl

/-- The start is on the chain. -/
theorem DecSt.Valid.init (s : BitVec 256) : (DecSt.init s).Valid := by
  refine ⟨fun h => ?_, ?_⟩
  · rw [DecSt.init_stage] at h
    exact absurd h (by decide)
  · rw [DecSt.init_stage]
    decide

/-- The chain from the start takes `263` steps. -/
theorem DecSt.left_init (s : BitVec 256) : (DecSt.init s).left = 263 := by
  unfold DecSt.left
  rw [DecSt.init_rem, DecSt.init_stage]
  decide

/-- The start is on the chain. -/
theorem DecSt.Reach.init (s : BitVec 256) : (DecSt.init s).Reach s :=
  ⟨0, rfl⟩

/-- A state reached from the start is valid. -/
theorem DecSt.Reach.valid {D : DecSt} (h : D.Reach s) : D.Valid := by
  obtain ⟨j, rfl⟩ := h
  exact (DecSt.ops_valid_left j (DecSt.Valid.init s)).1

/-- A step keeps `Ok`. -/
theorem DecSt.Ok.op1 {D : DecSt} (h : D.Ok) : D.op1.Ok := by
  unfold DecSt.op1
  split
  · exact h.sqrs _
  split
  · exact h.stageOp ((DecSt.lt12_iff _).1 (by assumption))
  · exact h

/-- The named multipliers a state on the chain needs are set. -/
theorem DecSt.Reach.ok {D : DecSt} (h : D.Reach s) : D.Ok := by
  obtain ⟨j, rfl⟩ := h
  suffices ∀ j (D : DecSt), D.Ok → (DecSt.ops j D).Ok from this j _ (by
    refine ⟨?_, ?_, ?_, ?_⟩ <;> rw [DecSt.init_stage] <;> intro h <;> exact absurd h (by decide))
  intro j
  induction j with
  | zero => exact fun _ h => h
  | succ j ih => exact fun D h => ih _ h.op1

/-- `fd_r43x6_ge_decode_step_slow` keeps a state on the chain. -/
theorem DecSt.Reach.stepSlow {D : DecSt} (h : D.Reach s) (n : BitVec 64) :
    (D.stepSlow n).Reach s := by
  have hv := h.valid
  obtain ⟨j, rfl⟩ := h
  refine ⟨j + min n.toNat (DecSt.ops j (DecSt.init s)).left, ?_⟩
  rw [DecSt.stepSlow, DecSt.stepSlowF_ops 13 _ _ hv (by omega), DecSt.ops_add]

/-- `fd_r43x6_ge_decode_step` keeps a state on the chain. -/
theorem DecSt.Reach.step {D : DecSt} (h : D.Reach s) (n : BitVec 64) : (D.step n).Reach s := by
  rw [DecSt.step_eq_stepSlow h.valid.1]
  exact h.stepSlow n

/-- From a state on the chain, `fd_r43x6_ge_decode_fini`'s finishing step ends it: the stages
run whole from the start. -/
theorem DecSt.Reach.stepSlow_end {D : DecSt} (h : D.Reach s) :
    D.stepSlow 18446744073709551615#64 = DecSt.stageRun^[12] (DecSt.init s) := by
  have hv := h.valid
  obtain ⟨j, rfl⟩ := h
  have hl := (DecSt.ops_valid_left j (DecSt.Valid.init s)).2
  rw [DecSt.left_init] at hl
  have hend := DecSt.ops_left 12 (DecSt.init s) (DecSt.Valid.init s) rfl
  rw [DecSt.left_init] at hend
  rw [DecSt.stepSlow, DecSt.stepSlowF_ops 13 _ _ hv (by omega), hl, ← hend,
    show min (18446744073709551615#64).toNat (263 - j) = 263 - j by
      simp only [BitVec.toNat_ofNat]
      omega,
    ← DecSt.ops_add]
  by_cases hj : j ≤ 263
  · rw [show j + (263 - j) = 263 by omega]
  · have h0 : (DecSt.ops 263 (DecSt.init s)).left = 0 := by
      rw [(DecSt.ops_valid_left 263 (DecSt.Valid.init s)).2, DecSt.left_init]
    rw [show j + (263 - j) = 263 + (j - 263) by omega, DecSt.ops_add, DecSt.ops_of_left _ h0]

/-- A stage run whole: its squarings, then `decode_stage`. -/
theorem DecSt.stageRun_mk (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (st r : BitVec 64)
    (x0 : BitVec 32) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, st, r, x0⟩ =
      DecSt.stageOp ⟨Avx512.fd_r43x6_repsqr_mul2.sqrN r.toNat x, m, z, z2, z9, z10, z50, y, u, v,
        uv3, st, r - r, x0⟩ :=
  rfl

/-- Stage `0` run whole. -/
theorem DecSt.stageRun_0 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = Avx512.fd_r43x6_repsqr_mul2.sqrN 1 x) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 0, 1, x0⟩ =
      ⟨x', x', z, (some x'), z9, z10, z50, y, u, v, uv3, 1, 2, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `1` run whole. -/
theorem DecSt.stageRun_1 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 2 x) z) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 1, 2, x0⟩ =
      ⟨x', x', z, z2, (some x'), z10, z50, y, u, v, uv3, 2, 0, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `2` run whole. -/
theorem DecSt.stageRun_2 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 0 x) (z2.getD 0)) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 2, 0, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 3, 1, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `3` run whole. -/
theorem DecSt.stageRun_3 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 1 x) (z9.getD 0)) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 3, 1, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 4, 5, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `4` run whole. -/
theorem DecSt.stageRun_4 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 5 x) m) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 4, 5, x0⟩ =
      ⟨x', x', z, z2, z9, (some x'), z50, y, u, v, uv3, 5, 10, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `5` run whole. -/
theorem DecSt.stageRun_5 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 10 x) m) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 5, 10, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 6, 20, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `6` run whole. -/
theorem DecSt.stageRun_6 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 20 x) m) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 6, 20, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 7, 10, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `7` run whole. -/
theorem DecSt.stageRun_7 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 10 x) (z10.getD 0)) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 7, 10, x0⟩ =
      ⟨x', x', z, z2, z9, z10, (some x'), y, u, v, uv3, 8, 50, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `8` run whole. -/
theorem DecSt.stageRun_8 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 50 x) m) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 8, 50, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 9, 100, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `9` run whole. -/
theorem DecSt.stageRun_9 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 100 x) m) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 9, 100, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 10, 50, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `10` run whole. -/
theorem DecSt.stageRun_10 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 50 x) (z50.getD 0)) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 10, 50, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 11, 2, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- Stage `11` run whole. -/
theorem DecSt.stageRun_11 (x m z y u v uv3 : Wwl) (z2 z9 z10 z50 : Option Wwl) (x0 : BitVec 32)
    (x' : Wwl) (h : x' = fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN 2 x) z) :
    DecSt.stageRun ⟨x, m, z, z2, z9, z10, z50, y, u, v, uv3, 11, 2, x0⟩ =
      ⟨x', x', z, z2, z9, z10, z50, y, u, v, uv3, 12, 0, x0⟩ := by
  subst h
  rw [DecSt.stageRun_mk]
  simp only [BitVec.reduceToNat]
  rfl

/-- The chain's end from a start `⟨z, z, z, …⟩`: `x` is the power `fd_r43x6_pow22523` takes of `z`,
the other inputs kept. -/
theorem DecSt.stageRun_end (z y u v uv3 : Wwl) (x0 : BitVec 32) :
    let E := DecSt.stageRun^[12] ⟨z, z, z, none, none, none, none, y, u, v, uv3, 0, 1, x0⟩
    E.x = fd_r43x6_pow22523_2.spec z ∧ E.uv3 = uv3 ∧ E.v = v ∧ E.u = u ∧ E.y = y ∧
      E.x0 = x0 := by
  intro E
  obtain ⟨z2, h0⟩ : ∃ w, w = fd_r43x6_sqr z := ⟨_, rfl⟩
  obtain ⟨z9, h1⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2 z 2 := ⟨_, rfl⟩
  obtain ⟨z11, h2⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z9 z2 0 := ⟨_, rfl⟩
  obtain ⟨z2e5m1, h3⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z11 z9 1 := ⟨_, rfl⟩
  obtain ⟨z2e10m1, h4⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e5m1 z2e5m1 5 := ⟨_, rfl⟩
  obtain ⟨z2e20m1, h5⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e10m1 z2e10m1 10 := ⟨_, rfl⟩
  obtain ⟨z2e40m1, h6⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e20m1 z2e20m1 20 := ⟨_, rfl⟩
  obtain ⟨z2e50m1, h7⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e40m1 z2e10m1 10 := ⟨_, rfl⟩
  obtain ⟨z2e100m1, h8⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e50m1 z2e50m1 50 := ⟨_, rfl⟩
  obtain ⟨z2e200m1, h9⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e100m1 z2e100m1 100 := ⟨_, rfl⟩
  obtain ⟨z2e250m1, h10⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e200m1 z2e50m1 50 := ⟨_, rfl⟩
  obtain ⟨t0, h11⟩ : ∃ w, w = fd_r43x6_repsqr_mul2.spec z2e250m1 z 2 := ⟨_, rfl⟩
  have hs : fd_r43x6_pow22523_2.spec z = t0 := by
    subst h11 h10 h9 h8 h7 h6 h5 h4 h3 h2 h1 h0
    unfold fd_r43x6_pow22523_2.spec
    rfl
  rw [hs]
  simp only [E, Function.iterate_succ, Function.iterate_zero, Function.comp_apply, id_eq]
  rw [DecSt.stageRun_0 z z z y u v uv3 none none none none
    x0 _ (h0.trans rfl)]
  rw [DecSt.stageRun_1 z2 z2 z y u v uv3 (some z2) none none none
    x0 _ (h1.trans rfl)]
  rw [DecSt.stageRun_2 z9 z9 z y u v uv3 (some z2) (some z9) none none
    x0 _ (h2.trans rfl)]
  rw [DecSt.stageRun_3 z11 z11 z y u v uv3 (some z2) (some z9) none none
    x0 _ (h3.trans rfl)]
  rw [DecSt.stageRun_4 z2e5m1 z2e5m1 z y u v uv3 (some z2) (some z9) none none
    x0 _ (h4.trans rfl)]
  rw [DecSt.stageRun_5 z2e10m1 z2e10m1 z y u v uv3 (some z2) (some z9) (some z2e10m1) none
    x0 _ (h5.trans rfl)]
  rw [DecSt.stageRun_6 z2e20m1 z2e20m1 z y u v uv3 (some z2) (some z9) (some z2e10m1) none
    x0 _ (h6.trans rfl)]
  rw [DecSt.stageRun_7 z2e40m1 z2e40m1 z y u v uv3 (some z2) (some z9) (some z2e10m1) none
    x0 _ (h7.trans rfl)]
  rw [DecSt.stageRun_8 z2e50m1 z2e50m1 z y u v uv3 (some z2) (some z9) (some z2e10m1) (some z2e50m1)
    x0 _ (h8.trans rfl)]
  rw [DecSt.stageRun_9 z2e100m1 z2e100m1 z y u v uv3
    (some z2) (some z9) (some z2e10m1) (some z2e50m1) x0 _ (h9.trans rfl)]
  rw [DecSt.stageRun_10 z2e200m1 z2e200m1 z y u v uv3
    (some z2) (some z9) (some z2e10m1) (some z2e50m1) x0 _ (h10.trans rfl)]
  rw [DecSt.stageRun_11 z2e250m1 z2e250m1 z y u v uv3
    (some z2) (some z9) (some z2e10m1) (some z2e50m1) x0 _ (h11.trans rfl)]
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

open Firedancer.Avx512.fd_r43x6_ge_decode2 (Dec Dec.ok dec decodePt quadOf zeroQuad sqrtM1 d
  pSubOne vsub) in
/-- `fd_r43x6_ge_decode_fini` on a state on the chain from `s` is `fd_r43x6_ge_decode` of `s`. -/
theorem DecSt.Reach.fini {D : DecSt} (h : D.Reach s) : D.fini = fd_r43x6_ge_decode.spec s := by
  unfold DecSt.fini
  rw [h.stepSlow_end]
  have hi : DecSt.init s = ⟨(DecSt.init s).x, (DecSt.init s).x, (DecSt.init s).x, none, none, none,
      none, (DecSt.init s).y, (DecSt.init s).u, (DecSt.init s).v, (DecSt.init s).uv3, 0, 1,
      (DecSt.init s).x0⟩ := rfl
  obtain ⟨ex, euv3, ev, eu, ey, ex0⟩ := DecSt.stageRun_end (DecSt.init s).x (DecSt.init s).y
    (DecSt.init s).u (DecSt.init s).v (DecSt.init s).uv3 (DecSt.init s).x0
  rw [hi]
  dsimp only
  rw [ex, euv3, ev, eu, ey, ex0]
  have hA := fd_r43x6_ge_decode2.dec_eq s (fd_r43x6_sqr (DecSt.init s).y) (DecSt.init s).u
    (fd_r43x6_mul d (fd_r43x6_sqr (DecSt.init s).y)) (DecSt.init s).v
    (fd_r43x6_sqr (DecSt.init s).v) (fd_r43x6_sqr (fd_r43x6_sqr (DecSt.init s).v))
    (fd_r43x6_mul (DecSt.init s).v (fd_r43x6_sqr (DecSt.init s).v)) (DecSt.init s).uv3
    (DecSt.init s).x (fd_r43x6_pow22523_2.spec (DecSt.init s).x)
    (fd_r43x6_mul (DecSt.init s).uv3 (fd_r43x6_pow22523_2.spec (DecSt.init s).x))
    (fd_r43x6_sqr
      (fd_r43x6_mul (DecSt.init s).uv3 (fd_r43x6_pow22523_2.spec (DecSt.init s).x)))
    (fd_r43x6_mul (DecSt.init s).v (fd_r43x6_sqr
      (fd_r43x6_mul (DecSt.init s).uv3 (fd_r43x6_pow22523_2.spec (DecSt.init s).x))))
    rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  unfold fd_r43x6_ge_decode.spec
  rw [hA]
  have hu : (DecSt.init s).u =
      vadd (foldSignedPre (vadd (fd_r43x6_sqr (DecSt.init s).y) pSubOne)) negBias := rfl
  dsimp only
  rw [hu, vsub_u_p, ← hu]
  by_cases hc : fd_r43x6_is_nonzero.spec (vadd (fd_r43x6_mul (DecSt.init s).v (fd_r43x6_sqr
      (fd_r43x6_mul (DecSt.init s).uv3 (fd_r43x6_pow22523_2.spec (DecSt.init s).x))))
      (DecSt.init s).u) &&& fd_r43x6_is_nonzero.spec (vadd (vsub (fd_r43x6_mul (DecSt.init s).v
      (fd_r43x6_sqr (fd_r43x6_mul (DecSt.init s).uv3
      (fd_r43x6_pow22523_2.spec (DecSt.init s).x)))) (foldSignedPre
      (vadd (fd_r43x6_sqr (DecSt.init s).y) pSubOne))) negP) = 0#32
  · rw [ite_eq_left hc]
    exact (ite_eq_left hc).symm
  · rw [ite_eq_right hc]
    exact (ite_eq_right hc).symm

open Firedancer.Avx512.fd_r43x6_ge_decode2 (dec) in
/-- `fd_r43x6_ge_decode` is `fd_r43x6_ge_decode2` with the encoding twice, its first point. -/
theorem fd_r43x6_ge_decode.spec_eq_decode2 (s : BitVec 256) :
    fd_r43x6_ge_decode.spec s =
      ((fd_r43x6_ge_decode2.spec (dec s) (dec s)).1,
        (fd_r43x6_ge_decode2.spec (dec s) (dec s)).2.1) := by
  unfold fd_r43x6_ge_decode.spec fd_r43x6_ge_decode2.spec
  by_cases h : (dec s).ok
  · rw [ite_eq_left h, ite_eq_left h, ite_eq_left h]
  · rw [ite_eq_right h, ite_eq_right h]

/-- `fd_r43x6_ge_decode` of an encoding `decode` rejects: `-1` and zeros. -/
theorem fd_r43x6_ge_decode.spec_none {s : BitVec 256} (h : _root_.Ed25519.decode s = none) :
    fd_r43x6_ge_decode.spec s = (-1, fd_r43x6_ge_decode2.zeroQuad) := by
  rw [fd_r43x6_ge_decode.spec_eq_decode2, (fd_r43x6_ge_decode2.spec_decode s s).1 h]

/-- `fd_r43x6_ge_decode` of an encoding of `P`: `0` and the point, affine and folded. -/
theorem fd_r43x6_ge_decode.spec_some {s : BitVec 256} {P : _root_.Ed25519.Point}
    (h : _root_.Ed25519.decode s = some P) :
    (fd_r43x6_ge_decode.spec s).1 = 0 ∧ (fd_r43x6_ge_decode.spec s).2.Affine P.x P.y ∧
      (fd_r43x6_ge_decode.spec s).2.Folded := by
  obtain ⟨h1, h2, h3, -⟩ := (fd_r43x6_ge_decode2.spec_decode s s).2.2 P P h h
  rw [fd_r43x6_ge_decode.spec_eq_decode2]
  exact ⟨h1, h2, h3⟩

/-- `fd_r43x6_ge_decode_step`'s squarings stored: `x` squared `n` times at `st`, `rem - n` after
it, over the state `D`. -/
theorem MemoryState.storeDec_sqrs {m : MemoryState} {st : Pointer} {D : DecSt}
    (hov : ¬st.offset.uaddOverflow 724#64) (hD : m.DecHolds st D) (n : BitVec 64) :
    (m.storeAt st (BitVec.packLanes (Avx512.fd_r43x6_repsqr_mul2.sqrN n.toNat D.x))).storeAt
        (st.add 712#64) (D.rem - n) =
      m.storeDec st (D.sqrs n) := by
  rw [← MemoryState.storeDec_self hD, MemoryState.storeDec_storeAt_x hov,
    MemoryState.storeDec_storeAt_rem hov, MemoryState.storeDec_self hD]
  rfl

end

end MLIR.Firedancer.Lane

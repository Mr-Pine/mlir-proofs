module

public import Firedancer.Lane.verify_x8.FinalMem
public import Firedancer.Lane.verify_x8.FinalCmp
public import Firedancer.Lane.verify_x8.ChecksBits
public import Firedancer.Lane.verify_x8.Lanes
public import Firedancer.Lane.verify_x8.Tactics
import Mathlib.Tactic.IntervalCases

/-! `verify_x8`'s end (`^bb88 … ^bb103`): `fd_ed25519_lane_verify`'s final comparison, the live
items' codes (the eight-lane body once for `cnt = 8`, masked, else the scalar loop), and the
returns. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

@[expose] public section

/-- The scalar loop's registers at item `j`: `live`, `valid`, `j`. -/
abbrev EnvR (c : Call) (E : ⟪Γ⟫) (j : Nat) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %52 := PoisonOr.value 1#32, %61 := PoisonOr.value 0#32,
    %88 := PoisonOr.value 1#64, %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value
    (c.s.slot 27), %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 :=
    PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 4649 := PoisonOr.value (c.X.valid), rir_reg% hty 4720 := PoisonOr.value
    (BitVec.ofNat 64 j)]

/-- `^bb98`'s registers. -/
abbrev Env98 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32)]

end

/-- `j++` does not wrap. -/
theorem fin_inc {j : Nat} (hj : j < 8) :
    (BitVec.ofNat 64 j).uaddOverflow 1#64 = false ∧
      BitVec.ofNat 64 j + 1#64 = BitVec.ofNat 64 (j + 1) := by
  revert j; decide

/-- The loop's exit test. -/
theorem fin_exit {j n : Nat} (hj : j < 8) (hn : n ≤ 8) :
    (BitVec.ofNat 64 (j + 1) = BitVec.ofNat 64 n) ↔ j + 1 = n := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    simp only [BitVec.toNat_ofNat] at this
    rwa [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)] at this
  · rintro rfl; rfl

/-- `^bb98`: `hash_input`, `hashes` and `batch` end, then `^bb102`. -/
theorem fin_bb98 (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (M : MemoryState) (hA : E.args = c.args)
    (hE : Env98 c E) (hS : c.Base S M)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env102 c E' → c.Base S' M →
        ((verify_x8 c.batch).runFrom E' 102 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 98 S >>= g) = K := by
  have hwf := hS.wf
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hB : c.Base S₀ M := hS₀ ▸ hS
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨98, (by decide : 98 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure
  step_pure
  finish_block
  subst hS₀
  exact hK E S hA (by dsimp only [Env102]; env_reads)
    (hB.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]))

/-- `^bb101`: `j++`; on to item `j + 1`, or past the last to `^bb98`. -/
theorem fin_bb101 (c : Call) (hc : c.Ok) (j : Nat) (hj : j < c.cnt) (E : ⟪Γ⟫) (S : GlobalState)
    (M : MemoryState) (hA : E.args = c.args) (hE : EnvR c E j) (hS : c.Base S M)
    (hback :
      j + 1 < c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvR c E' (j + 1) →
        c.Base S' M → ((verify_x8 c.batch).runFrom E' 99 S' >>= g) = K)
    (hexit :
      j + 1 = c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env98 c E' →
        c.Base S' M → ((verify_x8 c.batch).runFrom E' 98 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 101 S >>= g) = K := by
  have h8 := hc.cnt8
  obtain ⟨hov, hadd⟩ := fin_inc (j := j) (by omega)
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨101, (by decide : 101 < 104)⟩ S >>= g) = K
  block_init
  step_pure [hov, hadd]
  step_pure
  finish_block
  · rw [fin_exit (by omega) h8] at hbr
    exact hexit hbr E S hArgs (by dsimp only [Env98]; env_reads) hS
  · rw [fin_exit (by omega) h8] at hbr
    exact hback (by omega) E S hArgs (by dsimp only [EnvR]; env_reads) hS

/-- `live`'s bit `j`: item `j` live. -/
theorem Call.liveMask_bit (c : Call) {j : Nat} (hj : j < 8) :
    (1#32 <<< j &&& c.liveMask = 0#32) ↔ c.X.liveAt j = false := by
  rw [and_bit_iff _ (by omega), Call.liveMask, getLsbD_maskOf, X8.liveAt]

/-- A live item's code: the equation's. -/
theorem Call.resultAt_live (c : Call) {j : Nat} (hl : c.X.liveAt j = true) :
    c.X.resultAt j = if c.X.valid.getLsbD j then 0#32 else errMsg := by
  unfold X8.liveAt at hl
  split at hl
  · rename_i hj
    rw [Call.live_eq] at hl
    simp only [Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true] at hl
    obtain ⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩ := hl
    simp [X8.resultAt, hj, X8.result, h1, h2, h3, h4, h5]
  · exact absurd hl (by simp)

/-- The code the scalar loop stores for a live item. -/
theorem Call.fin_code (c : Call) {j : Nat} (hj : j < 8) (hl : c.X.liveAt j = true) :
    (if BitVec.ofBool (1#32 <<< j &&& c.X.valid == 0#32) = 1#1 then 4294967293#32 else 0#32) =
      c.X.resultAt j := by
  rw [c.resultAt_live hl]
  by_cases h : 1#32 <<< j &&& c.X.valid = 0#32
  · rw [(and_bit_iff _ (by omega)).1 h]; simp [h]; rfl
  · have h' : c.X.valid.getLsbD j = true := by
      simpa using mt (and_bit_iff _ (by omega)).2 h
    have h'' : (1#32 <<< j &&& c.X.valid == 0#32) = false := by simpa using h
    simp [h'', h']

/-- Lane `j` of the eight-lane store: set for a live item, which gets its code. -/
theorem Call.lane_store (c : Call) {j : Nat} (hj : j < 8) (b : BitVec 32) (hb : 1#32 <<< j = b) :
    BitVec.ofBool (b &&& c.liveMask != 0#32) = (if c.X.liveAt j then 1#1 else 0#1) ∧
      (c.X.liveAt j = true →
        (if BitVec.ofBool (b &&& c.X.valid == 0#32) = 1#1 then 4294967293#32 else 0#32) =
          c.X.resultAt j) := by
  subst hb
  refine ⟨?_, c.fin_code hj⟩
  cases hl : c.X.liveAt j
  · have := (c.liveMask_bit hj).2 hl
    simp [this]
  · have : (1#32 <<< j &&& c.liveMask != 0#32) = true := by
      simpa using mt (c.liveMask_bit hj).1 (by simp [hl])
    simp [this]

/-- `^bb99` at item `j`: its code stored if it is live; on to item `j + 1`, or past the last to
`^bb98`. -/
theorem fin_trip (c : Call) (hc : c.Ok) (j : Nat) (hj : j < c.cnt) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvR c E j) (hS : c.Base S (c.finMem j))
    (hback :
      j + 1 < c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvR c E' (j + 1) →
        c.Base S' (c.finMem (j + 1)) → ((verify_x8 c.batch).runFrom E' 99 S' >>= g) = K)
    (hexit :
      j + 1 = c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env98 c E' →
        c.Base S' (c.finMem (j + 1)) → ((verify_x8 c.batch).runFrom E' 98 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 99 S >>= g) = K := by
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hmod : j % 4294967296 = j := Nat.mod_eq_of_lt (by omega)
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have h32 : ¬32 ≤ j := by omega
  have hov : ¬c.a.results.offset.uaddOverflow (BitVec.ofNat 64 (j * 4)) := by
    have := hc.batch.off.2.2.2.2.2
    simp [BitVec.uaddOverflow]; omega
  have hroom := hS.room_result hc (c.storesOff_finMem j) hj
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hB : c.Base S₀ (c.finMem j) := hS₀ ▸ hS
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨99, (by decide : 99 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure [hmod, h32, one_shl_shr hj8]
  step_pure
  step_pure
  finish_block
  · -- dead
    rw [c.liveMask_bit hj8] at hbr
    rw [c.finMem_succ_dead hbr] at hB
    exact fin_bb101 c hc j hj E S _ hArgs (by dsimp only [EnvR]; env_reads) (hS₀ ▸ hB) hback
      hexit
  · -- live: `results[j] = valid & (1 << j) ? SUCCESS : ERR_MSG`
    rw [c.liveMask_bit hj8, Bool.not_eq_false] at hbr
    block_init
    step_pure
    step_pure
    step_pure
    step_pure [hmod64, gep_value (f := { nusw := true, nuw := true }) hov
      (Or.inr (by simp; omega))]
    step_store
    finish_block
    rw [c.fin_code hj8 hbr] at hS
    subst hS₀
    refine fin_bb101 c hc j hj E S _ hArgs (by dsimp only [EnvR]; env_reads) ?_ hback hexit
    rw [hS, ← c.finMem_succ_live hc hj hbr, ← hB.mem, ← MemoryState.eraseFrom_storeAt]
    exact hB.of_storesOff hc (.storeAt _ (.refl _) (by simp)) rfl

/-- The scalar loop from item `j`, `n + 1` items left: on to `^bb98` with every live item's code
stored. -/
theorem fin_loop (c : Call) (hc : c.Ok)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env98 c E' →
        c.Base S' (c.finMem c.cnt) → ((verify_x8 c.batch).runFrom E' 98 S' >>= g) = K) :
    ∀ n j (E : ⟪Γ⟫) (S : GlobalState), j + n + 1 = c.cnt → E.args = c.args → EnvR c E j →
      c.Base S (c.finMem j) → ((verify_x8 c.batch).runFrom E 99 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro j E S hn hA hE hS
    refine fin_trip c hc j (by omega) E S hA hE hS (fun h => absurd h (by omega)) ?_
    intro h E' S' h1 h2 h3
    rw [h] at h3
    exact hexit E' S' h1 h2 h3
  | succ n ih =>
    intro j E S hn hA hE hS
    exact fin_trip c hc j (by omega) E S hA hE hS
      (fun _ E' S' h1 h2 h3 => ih (j + 1) E' S' (by omega) h1 h2 h3) fun h => absurd h (by omega)

-- 25 lane-wise steps and a masked store on a 5000-instruction function
set_option maxHeartbeats 1000000 in
/-- `cnt = 8` (`^bb89 … ^bb96`): the eight-lane loop once, one masked store of the live items'
codes, on to `^bb98`; the sixteen-lane loop needs `cnt ≥ 64`. -/
theorem fin_vec (c : Call) (hc : c.Ok) (hcnt : c.cnt = 8) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvF c E) (hS : c.Base S c.mem76)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env98 c E' →
        c.Base S' (x8Mem c.s.mem c.a.results c.it c.cnt) →
        ((verify_x8 c.batch).runFrom E' 98 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 89 S >>= g) = K := by
  have h64 : (BitVec.ofNat 64 c.cnt).ult 64#64 = true := by rw [hcnt]; decide
  have hand : BitVec.ofNat 64 c.cnt &&& 18446744073709551608#64 = 8#64 := by rw [hcnt]; decide
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hB : c.Base S₀ c.mem76 := hS₀ ▸ hS
  clear hS
  have hroom : ∀ j < c.cnt, Room S₀.mem (c.a.result j) 32 :=
    fun _ hj => hB.room_result hc (c.finMem_zero ▸ c.storesOff_finMem 0) hj
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨89, (by decide : 89 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  finish_block
  block_init
  iterate 9 step_pure [hand, or_lanes8]
  finish_block
  block_init
  iterate 7 step_pure [shl_lanes8, ite_value, expandOfFn]
  have hS : S = S₀ := hS₀.symm
  step_pattern using runBodyFrom_maskedStoreRun
    (hroom := c.room_lanes hc hcnt (fun j hj => by rw [hS]; exact hroom j hj) _)
  iterate 3 step_pure [ite_value, expandOfFn]
  finish_block
  block_init
  step_pure
  have h8eq : BitVec.ofNat 64 c.cnt = 8#64 := by rw [hcnt]
  finish_block
  refine hexit E S hArgs (by dsimp only [Env98]; env_reads) ?_
  rw [hS]
  refine hB.of_storesOff hc ((MemoryState.StoresOff.refl _).maskedStoreAt (fun h => h rfl) _ _) ?_
  rw [MemoryState.eraseFrom_maskedStoreAt, hB.mem]
  refine c.mem76_maskedStoreAt hc hcnt fun j hj => ?_
  interval_cases j
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)
  · exact c.lane_store (by decide) _ (by decide)

/-- `^bb88 … ^bb101`: `valid`, the live items' codes; on to the return with `verify_x8`'s memory
outside the frame. -/
public theorem final_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env88 c E) (hS : c.At88 S)
    (h102 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env102 c E' →
        c.Base S' (x8Mem c.s.mem c.a.results c.it c.cnt) →
        ((verify_x8 c.batch).runFrom E' 102 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 88 S >>= g) = K := by
  have h3 := hc.cnt3
  have h98 (E' : ⟪Γ⟫) (S' : GlobalState) (hA : E'.args = c.args) (hE : Env98 c E')
      (hS : c.Base S' (x8Mem c.s.mem c.a.results c.it c.cnt)) :
      ((verify_x8 c.batch).runFrom E' 98 S' >>= g) = K :=
    fin_bb98 c E' S' _ hA hE hS h102
  refine cmp_run c hc E S hA hE hS ?_ fun h8 E S hA hE hS => fin_vec c hc h8 E S hA hE hS h98
  intro _ E S hA hE h0 hS
  split_reads hE h0
  show ((verify_x8 c.batch).runFrom E ⟨97, (by decide : 97 < 104)⟩ S >>= g) = K
  block_init
  finish_block
  refine fin_loop c hc (fun E S hA hE hS => h98 E S hA hE (c.finMem_cnt ▸ hS)) (c.cnt - 1) 0 E S
    (by omega) hArgs (by dsimp only [EnvR]; env_reads) (c.finMem_zero ▸ hS)

/-- `^bb103`: `k` and `s` end; the return, with the memory outside the frame kept. -/
public theorem ret103 (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (M : MemoryState)
    (hE : Env103 c E) (hS : c.Base S M)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc → S'.mem.eraseFrom c.s.alloc.nextFreeBlock = M →
        g (.nil, S') = K) :
    ((verify_x8 c.batch).runFrom E 103 S >>= g) = K := by
  have hm := hS.mem
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨103, (by decide : 103 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure
  finish_block
  refine hK S (by rw [hS]) ?_
  rw [hS]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le (by simp [GlobalState.slot]),
    MemoryState.eraseFrom_lifetimeEnd_of_le (by simp [GlobalState.slot])]
  exact hm

/-- `^bb102`: `a` and `r` end, then `^bb103`. -/
public theorem ret102 (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (M : MemoryState)
    (hE : Env102 c E) (hS : c.Base S M)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc → S'.mem.eraseFrom c.s.alloc.nextFreeBlock = M →
        g (.nil, S') = K) :
    ((verify_x8 c.batch).runFrom E 102 S >>= g) = K := by
  have hwf := hS.wf
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hB : c.Base S₀ M := hS₀ ▸ hS
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨102, (by decide : 102 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure
  finish_block
  subst hS₀
  refine ret103 c E S M (by dsimp only [Env103]; env_reads)
    (hB.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS])) fun S' ha hm => ?_
  exact hK S' (ha.trans (by rw [hS])) hm

end MLIR.Firedancer.Lane.VerifyX8

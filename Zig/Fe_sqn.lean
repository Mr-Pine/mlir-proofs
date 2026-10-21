module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Fe_sq
public import Zig.Mlir.Fe_sqn

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `a` squared `n` times. -/
def Fe.sqn.spec : Nat → (Fin 5 → BitVec 64) → Fin 5 → BitVec 64
  | 0, x => x
  | n + 1, x => Fe.sqn.spec n (Fe.sq.spec x)

namespace Fe_sqn

/-- One iteration: `tmp ← fe²`, then `fe ← tmp`; `Fe.sq` takes two blocks. -/
def step (tmp fe : Pointer) (S : GlobalState) : GlobalState :=
  let L := Fe.sq.spec (S.mem.readLimbs fe)
  { alloc := ⟨S.alloc.nextFreeBlock + 2⟩, mem := (S.mem.storeLimbs tmp L).storeLimbs fe L }

/-- `m` iterations. -/
def iter (tmp fe : Pointer) : Nat → GlobalState → GlobalState
  | 0, S => S
  | m + 1, S => iter tmp fe m (step tmp fe S)

end Fe_sqn

end

/-- `a^(2^n)`'s limbs stay below `2^54`. -/
public theorem Fe.sqn.spec_lt {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
    ∀ n, Fe.Lt (Fe.sqn.spec n a) (2 ^ 54)
  | 0 => ha
  | n + 1 => Fe.sqn.spec_lt ((Fe.sq.spec_lt a).mono (by decide)) n

/-! ## Proof -/

section Proof

namespace Fe_sqn

/-- `sq` keeps limbs below `2^54`. -/
theorem sq_lt (x : Fin 5 → BitVec 64) : Fe.Lt (Fe.sq.spec x) (2 ^ 54) := fun i =>
  (Fe.carry128.spec_lt _ i).trans (by decide)

/-- An iteration keeps the facts the next one needs. -/
theorem step_facts {tmp fe : Pointer} {S : GlobalState} (hwf : S.WF) (ht : S.mem.LimbsRoom tmp)
    (hf : S.mem.LimbsFit fe) (hw : Writable S.mem fe) :
    (step tmp fe S).WF ∧
      (step tmp fe S).mem.LimbsRoom tmp ∧
      (step tmp fe S).mem.LimbsFit fe ∧
      Writable (step tmp fe S).mem fe ∧
      (step tmp fe S).mem.readLimbs fe = Fe.sq.spec (S.mem.readLimbs fe) := by
  refine
    ⟨?_, ht.storeLimbs.storeLimbs, .storeLimbs_self (hf.room hw).storeLimbs,
      (hf.room hw).storeLimbs.storeLimbs.2.1.writable, ?_⟩
  · have h2 := hwf.storeLimbs (p := tmp) (l := Fe.sq.spec (S.mem.readLimbs fe))
    have h3 := h2.storeLimbs (p := fe) (l := Fe.sq.spec (S.mem.readLimbs fe))
    exact
      ⟨fun k hk => Nat.lt_of_lt_of_le (h3.bound k hk) (by simp [step]), by simp [step], h3.null,
        h3.global, h3.merged⟩
  · exact MemoryState.readLimbs_storeLimbs_self (hf.room hw).storeLimbs

/-- The iterations' facts, `fe` holding `m` squares. -/
theorem iter_facts {tmp fe : Pointer} :
    ∀ m (S : GlobalState),
      S.WF →
        S.mem.LimbsRoom tmp →
        S.mem.LimbsFit fe →
        Writable S.mem fe →
        (iter tmp fe m S).WF ∧
          (iter tmp fe m S).mem.LimbsRoom tmp ∧
          (iter tmp fe m S).mem.LimbsFit fe ∧
          Writable (iter tmp fe m S).mem fe ∧
          (iter tmp fe m S).mem.readLimbs fe = Fe.sqn.spec m (S.mem.readLimbs fe) ∧
          (iter tmp fe m S).alloc = ⟨S.alloc.nextFreeBlock + 2 * m⟩ := by
  intro m
  induction m with
  | zero =>
    intro S hwf ht hf hw; exact ⟨hwf, ht, hf, hw, rfl, rfl⟩
  | succ m ih =>
    intro S hwf ht hf hw
    obtain ⟨w1, t1, f1, hw1, r1⟩ := step_facts hwf ht hf hw
    obtain ⟨w, t, f, hw', r, a⟩ := ih _ w1 t1 f1 hw1
    refine ⟨w, t, f, hw', ?_, ?_⟩
    · rw [iter, r, r1]; rfl
    · rw [iter, a]; simp [step]; omega

/-- The iterations keep room for every field element. -/
theorem iter_limbsRoom {tmp fe q : Pointer} :
    ∀ m (S : GlobalState), S.mem.LimbsRoom q → (iter tmp fe m S).mem.LimbsRoom q := by
  intro m
  induction m with
  | zero =>
    intro S h; exact h
  | succ m ih =>
    intro S h; exact ih _ h.storeLimbs.storeLimbs

/-- Erasing a frame holding `tmp` and `fe` forgets the iterations. -/
theorem iter_erase {tmp fe : Pointer} {b : Nat} (ht : b ≤ tmp.id.id) (hf : b ≤ fe.id.id) :
    ∀ m (S : GlobalState), (iter tmp fe m S).mem.eraseFrom b = S.mem.eraseFrom b := by
  intro m
  induction m with
  | zero =>
    intro S; rfl
  | succ m ih =>
    intro S
    rw [iter, ih]
    simp only [step]
    rw [MemoryState.eraseFrom_storeLimbs_of_le hf, MemoryState.eraseFrom_storeLimbs_of_le ht]

/-- The loop at `^bb1`, counter `i`, `m` iterations left: at the exit `fe` holds `m` more
squares. -/
theorem loop (out a tmp fe : Pointer) (n : BitVec 64) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value a) (.value n)).get →
        (E ⊨ [%1 := 40#64, %3 := 1#64, %4 := tmp, %5 := fe, %6 := BitVec.ofNat 64 i]) →
        i + m = n.toNat →
        n.toNat < 2 ^ 63 →
        S.WF →
        S.mem.LimbsRoom tmp →
        S.mem.LimbsFit fe →
        Writable S.mem fe →
        tmp.id ≠ fe.id →
        Fe.Lt (S.mem.readLimbs fe) (2 ^ 54) →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value n)).get →
            (E' ⊨ [%1 := 40#64, %5 := fe]) →
            S' = iter tmp fe m S → (Fe_sqn.runFrom E' ^bb3 S' >>= g) = K) →
        (Fe_sqn.runFrom E ^bb1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E hArgs hR hi hn hwf ht hf hfw hsep hb hK
    block_init
    step_pure
    finish_block
    · run_from using hK
      rfl
    · exfalso
      simp [BitVec.toNat_eq] at hbr
      omega
  | succ m ih =>
    intro i S E hArgs hR hi hn hwf ht hf hfw hsep hb hK
    block_init
    step_pure
    finish_block
    · exfalso
      simp [BitVec.toNat_eq] at hbr
      omega
    · have hfo := hf.1
      block_init
      step_call using Fe_sq.call_eq consuming hb
      have hT320 := ht.fits
      have hF320 := (hf.room hfw).room320
      step_memcpy consuming hT320 hF320
      step_pure [counter_overflow (show i + 1 < 2 ^ 63 by omega)]
      finish_block
      rename_i S₁ _ htr
      have ht₁ : S₁.mem.LimbsRoom tmp := by
        have := htr; rw [hS] at this; simpa [MemoryState.LimbsRoom] using this
      have hf₁ : S₁.mem.LimbsRoom fe := by
        have := hf.room hfw; rw [hS] at this; simpa [MemoryState.LimbsRoom] using this
      have hst : S = step tmp fe S₁ := by
        rw [hS]
        simp only [step]
        rw [MemoryState.storeAt_readAt_eq_storeLimbs (.storeLimbs_self ht₁) hfo,
          MemoryState.readLimbs_storeLimbs_self ht₁]
      have hb' : Fe.Lt (S.mem.readLimbs fe) (2 ^ 54) := by
        rw [hst]
        simp only [step]
        rw [MemoryState.readLimbs_storeLimbs_self hf₁.storeLimbs]
        exact sq_lt _
      refine
        ih (i + 1) S E hArgs ?_ (by omega) hn hwf htr hf
          (hst ▸ hf₁.storeLimbs.storeLimbs.2.1.writable) hsep hb'
          (fun E' S' h1 h2 h3 => hK E' S' h1 h2 (h3.trans ?_))
      · refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
        rw [BitVec.ofNat_add]
      · rw [hst]
        rfl

end Fe_sqn

/-- `Fe.sqn` stores `a` squared `n` times at `out`, for limbs below `2^54` and `n < 2^63`. -/
public theorem Fe_sqn.call_eq (out a : Pointer) (n : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 54))
    (hn : n.toNat < 2 ^ 63) :
    Fe_sqn.call (Fe_sqn.args (.value out) (.value a) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2 + 2 * n.toNat⟩,
            mem := s.mem.storeLimbs out (Fe.sqn.spec n.toNat (s.mem.readLimbs a)) }) := by
  func_init
  have haL₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have ha'₀ : Fe.Lt (S₀.mem.readLimbs a) (2 ^ 54) := hS ▸ ha'
  have hoa : out.offset.toNat + 32 < 2 ^ 64 := hout.1
  block_init
  iterate 4 step_pure
  step_alloca with tmp
  step_alloca with fe
  limbs_room tmp
  limbs_room fe
  have hfeA := hS ▸ hfe_limbs
  have ha320 := ha.fits
  have hfe320 := hfe_limbs.room320
  step_memcpy consuming ha320 hfe320 ha'
  have hfeF := MemoryState.LimbsFit.of_fits' hfits_fe hfe_limbs.1
  finish_block
  have hsep : tmp.id ≠ fe.id := by
    rw [htmp, hfe]; simp [GlobalState.slot]
  have hcopy : S.mem.readLimbs fe = S₀.mem.readLimbs a := by
    rw [hS]
    dsimp only
    rw [MemoryState.storeAt_readAt_eq_storeLimbs haL₀ hfeA.1,
      MemoryState.readLimbs_storeLimbs_self hfeA]
  refine
    Fe_sqn.loop out a tmp fe n _ _ n.toNat 0 S E hArgs ?_ (by simp) hn hwf htmp_limbs hfeF
      hfe_limbs.2.1.writable hsep (hcopy ▸ ha'₀) ?_
  · refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
  · intro E' S' h1 h2 h3
    obtain ⟨hw', -, hf', -, hr', hal'⟩ :=
      Fe_sqn.iter_facts n.toNat S hwf htmp_limbs hfeF hfe_limbs.2.1.writable
    have hout' := Fe_sqn.iter_limbsRoom (tmp := tmp) (fe := fe) n.toNat S hout
    have herase :=
      Fe_sqn.iter_erase (tmp := tmp) (fe := fe) (b := S₀.alloc.nextFreeBlock)
        (by
          rw [htmp]; simp [GlobalState.slot])
        (by
          rw [hfe]; simp [GlobalState.slot])
        n.toNat S
    have hcp (m : MemoryState) := MemoryState.storeAt_readAt_eq_storeLimbs (m := m) hf' hoa
    rw [← h3] at hw' hf' hout'
    clear hwf hout ha htmp_limbs hfe_limbs hfeF hfits_fe
    block_init
    have hout320 := hout'.room320
    have hf320 := hf'.fits
    step_memcpy consuming hout320 hf320
    finish_block
    rw [hS]
    dsimp only
    rw [hcp, hr', hcopy, hal', MemoryState.eraseFrom_storeLimbs, herase]
    subst_vars
    erase_frame
    simp [GlobalState.alloca]

end Proof

end MLIR.Zig

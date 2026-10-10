/-! ### The `i` loop -/

/-- The loop at `i < 256`: `r[i]`'s window if set, then `i + 1`. -/
theorem loop_step {v : Vector (BitVec 8) 256} (hi : i < 256) :
    loop v i = loop (if v[i] ≠ 0#8 then window v i 1 else v) (i + 1) := by
  rw [loop, dite_eq_left hi]

/-- The loop past `255`: done. -/
theorem loop_done {v : Vector (BitVec 8) 256} (hi : 256 ≤ i) : loop v i = v := by
  rw [loop, dite_eq_right (by omega)]

/-- `254 - i - 1`. -/
theorem cnt_succ (i : Nat) :
    254#32 - BitVec.ofNat 32 i + 4294967295#32 = 254#32 - BitVec.ofNat 32 (i + 1) := by
  rw [BitVec.ofNat_add]
  generalize BitVec.ofNat 32 i = y
  bv_decide

/-- `254 - i - 1` does not overflow, for `i ≤ 255`. -/
theorem cnt_sadd (hi : i < 256) : (254#32 - BitVec.ofNat 32 i).saddOverflow 4294967295#32 = false := by
  have hy : BitVec.ofNat 32 i ≤ 255#32 := by
    rw [BitVec.le_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  generalize BitVec.ofNat 32 i = y at hy
  bv_decide

/-- `^bb56` at `i = 255`: on to `^bb57`. -/
theorem latch_exit (r a : Pointer) (Sb : GlobalState) (K : PoisonOr (Vals [] × GlobalState))
    (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫)
    (hArgs : E.args = (slide.args (.value r) (.value a)).get)
    (hK : ∀ E' : ⟪slide.Γ⟫, E'.args = E.args → slide.runFrom E' ^bb57 (st Sb r v) = K) :
    slide.runFrom (hdrI E 255) ^bb56 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  block_init
  step_pure [saddOverflow_one64 (i := 255) (by omega), uaddOverflow_one64 (i := 255) (by omega),
    ← BitVec.ofNat_add]
  step_pure [saddOverflow_one64 (i := 256) (by omega), uaddOverflow_one64 (i := 256) (by omega),
    ← BitVec.ofNat_add]
  step_pure [cnt_sadd (by decide : 255 < 256), cnt_succ]
  step_pure
  finish_block
  step_loop using hK

/-- `^bb56` at `i < 255`: back to `^bb2` at `i + 1`. -/
theorem latch_next (r a : Pointer) (Sb : GlobalState) (i : Nat) (hi : i < 255)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫)
    (hArgs : E.args = (slide.args (.value r) (.value a)).get)
    (hK : ∀ E' : ⟪slide.Γ⟫, E'.args = E.args →
      slide.runFrom (hdrI E' (i + 1)) ^bb2 (st Sb r v) = K) :
    slide.runFrom (hdrI E i) ^bb56 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  block_init
  step_pure [saddOverflow_one64 (i := i) (by omega), uaddOverflow_one64 (i := i) (by omega),
    ← BitVec.ofNat_add]
  step_pure [saddOverflow_one64 (i := i + 1) (by omega), uaddOverflow_one64 (i := i + 1) (by omega),
    ← BitVec.ofNat_add]
  step_pure [cnt_sadd (show i < 256 by omega), cnt_succ]
  step_pure
  finish_block
  · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
  · step_loop using hK

/-- The `i` loop's test, as the code selects it. -/
theorem sel_iff {c : Prop} [Decidable c] (hi : i < 256) :
    (if c then BitVec.ofBool ((BitVec.ofNat 64 i).ult 255#64) else 0#1) = 1#1 ↔ c ∧ i < 255 := by
  have : (BitVec.ofNat 64 i).ult 255#64 = decide (i < 255) := by
    simp [BitVec.ult, Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega)]
  by_cases hc : c <;> by_cases hl : i < 255 <;> simp [hc, this, hl]

/-- No window at `i`: on to `i + 1`. -/
theorem loop_skip {v : Vector (BitVec 8) 256} (hi : i < 256) (h : ¬(v[i] ≠ 0#8 ∧ i < 255)) :
    loop v i = loop v (i + 1) := by
  rw [loop_step hi]
  by_cases h0 : v[i] ≠ 0#8
  · have : ¬i < 255 := fun hl => h ⟨h0, hl⟩
    rw [ite_eq_left h0, window_stop (by omega)]
  · rw [ite_eq_right h0]

/-- The window at `i`: on to `i + 1`. -/
theorem loop_window {v : Vector (BitVec 8) 256} (hi : i < 256) (h : v[i] ≠ 0#8 ∧ i < 255) :
    loop v i = loop (window v i 1) (i + 1) := by
  rw [loop_step hi, ite_eq_left h.1]

/-- `^bb2`, the `i` loop from `i`: on to `^bb57` with `loop v i`. -/
theorem main_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n i (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫),
      E.args = (slide.args (.value r) (.value a)).get → i + n = 255 →
        (∀ E' : ⟪slide.Γ⟫, E'.args = E.args → slide.runFrom E' ^bb57 (st Sb r (loop v i)) = K) →
        slide.runFrom (hdrI E i) ^bb2 (st Sb r v) = K := by
  intro n
  induction n with
  | zero =>
    intro i v E hArgs hn hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hi0 : i < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hi0]
    step_pure
    step_pure
    step_pure
    finish_block
    · exact absurd ((sel_iff hi0).1 hbr).2 (by omega)
    · rw [loop_skip hi0 (fun h => hbr ((sel_iff hi0).2 h)), loop_done (by omega)] at hK
      obtain rfl : i = 255 := by omega
      step_loop using latch_exit r a Sb K v
      step_loop using hK
  | succ n ih =>
    intro i v E hArgs hn hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hi0 : i < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hi0]
    step_pure
    step_pure
    step_pure
    finish_block
    · rw [loop_window hi0 ((sel_iff hi0).1 hbr)] at hK
      step_loop using window1 r a Sb hr hr_off i ((sel_iff hi0).1 hbr).2 K v
      step_loop using latch_next r a Sb i ((sel_iff hi0).1 hbr).2 K (window v i 1)
      step_loop using ih (i + 1) (window v i 1) _ _ (by omega)
      step_loop using hK
    · rw [loop_skip hi0 (fun h => hbr ((sel_iff hi0).2 h))] at hK
      step_loop using latch_next r a Sb i (by omega) K v
      step_loop using ih (i + 1) v _ _ (by omega)
      step_loop using hK


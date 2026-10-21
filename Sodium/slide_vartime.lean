module

public import MLIR.Run.Tactic
public import Boringssl.slide
public import Sodium.Mlir.slide_vartime
import Firedancer.Common.Memory
import Firedancer.Common.Counter
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `slide_vartime` is BoringSSL's `slide`: the same digits, `slide.spec`. -/

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

open MLIR.Boringssl MLIR.Boringssl.slide MLIR.Firedancer

/-- The constants the `i` loop reads. -/
abbrev consts (E : ⟪slide_vartime.Γ⟫) : ⟪slide_vartime.Γ⟫ :=
  E[%2483 := .value 3#64, %2486 := .value 1#8, %2487 := .value 1#64, %2489 := .value 2#64, %2490 :=
    .value 256#64, %2492 := .value 0#8, %2493 := .value 255#64, %2494 := .value 0#1, %2495 :=
    .value 5#32, %2496 := .value 2#32, %2497 := .value 1#32, %2498 := .value 16#32, %2499 :=
    .value 4294967281#32, %2500 := .value 0#32, %2501 := .value 3#32, %2502 := .value 4#32, %2503 :=
    .value 4#64, %2504 := .value 5#64, %2505 := .value 6#32, %2506 := .value 4294967295#32]

/-- The `i` loop's registers at `i`: `%2530` counts down from `254`. -/
abbrev hdrI (E : ⟪slide_vartime.Γ⟫) (i : Nat) : ⟪slide_vartime.Γ⟫ :=
  (consts E)[%2529 := .value (BitVec.ofNat 64 i), %2530 := .value (254#32 - BitVec.ofNat 32 i),
    %2531 := .value (BitVec.ofNat 64 (i + 1))]

/-- The `b` loop's registers at `i`: `r + i`, and `%2538 = min(254 - i, 5) + 2`. -/
abbrev hdrB (r : Pointer) (E : ⟪slide_vartime.Γ⟫) (i : Nat) : ⟪slide_vartime.Γ⟫ :=
  (hdrI E i)[%2532 := .value (r.add (BitVec.ofNat 64 i)), %2538 :=
    .value (BitVec.ofNat 32 (min (254 - i) 5 + 2))]

/-- Else `r[i] - (r[i + b] << b) >= -15`: `r[i] -= r[i + b] << b` and the carry from `i + b`. -/
theorem window_sub {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : ¬(v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true)
    (h' :
      ¬((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b).slt 4294967281#32 = true) :
    window v i b =
      window
        (carry
          (v.setIfInBounds i
            (((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b).setWidth 8))
          (i + b))
        i (b + 1) := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by
    intro x y; bv_decide
  have e' : ∀ x : BitVec 32, (-15#32).sle x = !x.slt 4294967281#32 := by
    intro x; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, e', h, h', Bool.false_eq_true, Bool.not_false]

/-- Else: the window ends. -/
theorem window_break {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : ¬(v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true)
    (h' :
      ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b).slt 4294967281#32 = true) :
    window v i b = v := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by
    intro x y; bv_decide
  have e' : ∀ x : BitVec 32, (-15#32).sle x = !x.slt 4294967281#32 := by
    intro x; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, e', h, h', Bool.false_eq_true, Bool.not_true]

/-- `^bb52`, the carry loop of `b = 6` from `k`: on to `^bb56` with `carry v k`. -/
theorem carry6_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrI E i)[%2656 := .value (BitVec.ofNat 64 k)]) ^bb52 (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb47`, the window at `b = 6`: on to `^bb56` with `window v i 6`. -/
theorem window6 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i + 5 < 256)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 6)) = K) :
    slide_vartime.runFrom (hdrB r E i) ^bb47 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- i + b, i + b < 256
  step_pure [saddOverflow_ofNat64 (i := i + 1) (k := 5) (by omega),
    uaddOverflow_ofNat64 (i := i + 1) (k := 5) (by omega), ← BitVec.ofNat_add,
    show i + 1 + 5 = i + 6 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 6) (by decide) hbr; omega)] at hK
    run_from using hK
  have hib : i + 6 < 256 := by
    have := guard_ne (b := 6) (by decide) hi hbr; omega
  have C := carry6_loop r a Sb hr hr_off i K (255 - (i + 6)) (i + 6)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    rw [window_stop (by omega)] at hK
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 6 = 1 ∨ 6 = 2 ∨ 6 = 3 ∨ 6 = 4 ∨ 6 = 5 ∨ 6 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 6 = 1 ∨ 6 = 2 ∨ 6 = 3 ∨ 6 = 4 ∨ 6 = 5 ∨ 6 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    rw [window_stop (by omega)] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 6 = 1 ∨ 6 = 2 ∨ 6 = 3 ∨ 6 = 4 ∨ 6 = 5 ∨ 6 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  rw [window_stop (by omega)] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using hK

/-- `^bb43`, the carry loop of `b = 5` from `k`: on to `^bb47` with `carry v k`. -/
theorem carry5_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrB r E' i) ^bb47 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrB r E i)[%2635 := .value (BitVec.ofNat 64 k)]) ^bb43
            (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb38`, the window at `b = 5`: on to `^bb56` with `window v i 5`. -/
theorem window5 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i + 4 < 256)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 5)) = K) :
    slide_vartime.runFrom (hdrB r E i) ^bb38 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- i + b, i + b < 256
  step_pure [saddOverflow_ofNat64 (i := i + 1) (k := 4) (by omega),
    uaddOverflow_ofNat64 (i := i + 1) (k := 4) (by omega), ← BitVec.ofNat_add,
    show i + 1 + 4 = i + 5 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 5) (by decide) hbr; omega)] at hK
    run_from using hK
  have hib : i + 5 < 256 := by
    have := guard_ne (b := 5) (by decide) hi hbr; omega
  have W := window6 r a Sb hr hr_off i hib K
  have C := carry5_loop r a Sb hr hr_off i K (255 - (i + 5)) (i + 5)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    run_from using W _
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 5 = 1 ∨ 5 = 2 ∨ 5 = 3 ∨ 5 = 4 ∨ 5 = 5 ∨ 5 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 5 = 1 ∨ 5 = 2 ∨ 5 = 3 ∨ 5 = 4 ∨ 5 = 5 ∨ 5 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using W _
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 5 = 1 ∨ 5 = 2 ∨ 5 = 3 ∨ 5 = 4 ∨ 5 = 5 ∨ 5 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using W _
  run_from using hK

/-- `^bb34`, the carry loop of `b = 4` from `k`: on to `^bb38` with `carry v k`. -/
theorem carry4_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrB r E' i) ^bb38 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrB r E i)[%2614 := .value (BitVec.ofNat 64 k)]) ^bb34
            (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb29`, the window at `b = 4`: on to `^bb56` with `window v i 4`. -/
theorem window4 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i + 3 < 256)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 4)) = K) :
    slide_vartime.runFrom (hdrB r E i) ^bb29 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- i + b, i + b < 256
  step_pure [saddOverflow_ofNat64 (i := i + 1) (k := 3) (by omega),
    uaddOverflow_ofNat64 (i := i + 1) (k := 3) (by omega), ← BitVec.ofNat_add,
    show i + 1 + 3 = i + 4 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 4) (by decide) hbr; omega)] at hK
    run_from using hK
  have hib : i + 4 < 256 := by
    have := guard_ne (b := 4) (by decide) hi hbr; omega
  have W := window5 r a Sb hr hr_off i hib K
  have C := carry4_loop r a Sb hr hr_off i K (255 - (i + 4)) (i + 4)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    run_from using W _
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 4 = 1 ∨ 4 = 2 ∨ 4 = 3 ∨ 4 = 4 ∨ 4 = 5 ∨ 4 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 4 = 1 ∨ 4 = 2 ∨ 4 = 3 ∨ 4 = 4 ∨ 4 = 5 ∨ 4 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using W _
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 4 = 1 ∨ 4 = 2 ∨ 4 = 3 ∨ 4 = 4 ∨ 4 = 5 ∨ 4 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using W _
  run_from using hK

/-- `^bb25`, the carry loop of `b = 3` from `k`: on to `^bb29` with `carry v k`. -/
theorem carry3_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrB r E' i) ^bb29 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrB r E i)[%2593 := .value (BitVec.ofNat 64 k)]) ^bb25
            (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb20`, the window at `b = 3`: on to `^bb56` with `window v i 3`. -/
theorem window3 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i + 2 < 256)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 3)) = K) :
    slide_vartime.runFrom (hdrB r E i) ^bb20 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- i + b, i + b < 256
  step_pure [saddOverflow_ofNat64 (i := i + 1) (k := 2) (by omega),
    uaddOverflow_ofNat64 (i := i + 1) (k := 2) (by omega), ← BitVec.ofNat_add,
    show i + 1 + 2 = i + 3 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 3) (by decide) hbr; omega)] at hK
    run_from using hK
  have hib : i + 3 < 256 := by
    have := guard_ne (b := 3) (by decide) hi hbr; omega
  have W := window4 r a Sb hr hr_off i hib K
  have C := carry3_loop r a Sb hr hr_off i K (255 - (i + 3)) (i + 3)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    run_from using W _
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 3 = 1 ∨ 3 = 2 ∨ 3 = 3 ∨ 3 = 4 ∨ 3 = 5 ∨ 3 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 3 = 1 ∨ 3 = 2 ∨ 3 = 3 ∨ 3 = 4 ∨ 3 = 5 ∨ 3 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using W _
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 3 = 1 ∨ 3 = 2 ∨ 3 = 3 ∨ 3 = 4 ∨ 3 = 5 ∨ 3 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using W _
  run_from using hK

/-- `^bb16`, the carry loop of `b = 2` from `k`: on to `^bb20` with `carry v k`. -/
theorem carry2_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrB r E' i) ^bb20 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrB r E i)[%2572 := .value (BitVec.ofNat 64 k)]) ^bb16
            (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb11`, the window at `b = 2`: on to `^bb56` with `window v i 2`. -/
theorem window2 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i < 255)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 2)) = K) :
    slide_vartime.runFrom (hdrB r E i) ^bb11 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- i + b, i + b < 256
  step_pure [saddOverflow_ofNat64 (i := i + 1) (k := 1) (by omega),
    uaddOverflow_ofNat64 (i := i + 1) (k := 1) (by omega), ← BitVec.ofNat_add,
    show i + 1 + 1 = i + 2 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := cnt_eq hi hbr; omega)] at hK
    run_from using hK
  have hib : i + 2 < 256 := by
    have := cnt_ne hi hbr; omega
  have W := window3 r a Sb hr hr_off i hib K
  have C := carry2_loop r a Sb hr hr_off i K (255 - (i + 2)) (i + 2)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    run_from using W _
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 2 = 1 ∨ 2 = 2 ∨ 2 = 3 ∨ 2 = 4 ∨ 2 = 5 ∨ 2 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 2 = 1 ∨ 2 = 2 ∨ 2 = 3 ∨ 2 = 4 ∨ 2 = 5 ∨ 2 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using W _
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 2 = 1 ∨ 2 = 2 ∨ 2 = 3 ∨ 2 = 4 ∨ 2 = 5 ∨ 2 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using W _
  run_from using hK

/-- `^bb8`, the carry loop of `b = 1` from `k`: on to `^bb11` with `carry v k`. -/
theorem carry1_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        k + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom (hdrB r E' i) ^bb11 (st Sb r (carry v k)) = K) →
        slide_vartime.runFrom ((hdrB r E i)[%2552 := .value (BitVec.ofNat 64 k)]) ^bb8 (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK

/-- `^bb3`, the window at `b = 1`: on to `^bb56` with `window v i 1`. -/
theorem window1 (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (hi : i < 255)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i 1)) = K) :
    slide_vartime.runFrom ((hdrI E i)[%2532 := .value (r.add (BitVec.ofNat 64 i))]) ^bb3
        (st Sb r v) =
      K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init
  -- min(254 - i, 5) + 2
  step_pure [umin_cnt hi]
  step_pure [saddOverflow_ofNat32 (i := min (254 - i) 5) (k := 2) (by omega),
    uaddOverflow_ofNat32 (i := min (254 - i) 5) (k := 2) (by omega), ← BitVec.ofNat_add]
  have hib : i + 1 < 256 := by omega
  have W := window2 r a Sb hr hr_off i hi K
  have C := carry1_loop r a Sb hr hr_off i K (255 - (i + 1)) (i + 1)
  -- if (r[i + b])
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    run_from using W _
    run_from using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 1 = 1 ∨ 1 = 2 ∨ 1 = 3 ∨ 1 = 4 ∨ 1 = 5 ∨ 1 = 6)]
  step_load [readAt_byte hr hr_off hi0]
  step_pure
  step_pure [sext_add _ _ (by decide : 1 = 1 ∨ 1 = 2 ∨ 1 = 3 ∨ 1 = 4 ∨ 1 = 5 ∨ 1 = 6)]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
    run_from using W _
    run_from using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 1 = 1 ∨ 1 = 2 ∨ 1 = 3 ∨ 1 = 4 ∨ 1 = 5 ∨ 1 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    run_from using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  run_from using C
  run_from using W _
  run_from using hK

/-! ### The `i` loop -/

/-- `^bb56` at `i = 255`: on to `^bb57`. -/
theorem latch_exit (r a : Pointer) (Sb : GlobalState) (K : PoisonOr (Vals [] × GlobalState))
    (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫, E'.args = E.args → slide_vartime.runFrom E' ^bb57 (st Sb r v) = K) :
    slide_vartime.runFrom (hdrI E 255) ^bb56 (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  block_init
  step_pure [saddOverflow_one64 (i := 255) (by omega), uaddOverflow_one64 (i := 255) (by omega),
    ← BitVec.ofNat_add]
  step_pure [saddOverflow_one64 (i := 256) (by omega), uaddOverflow_one64 (i := 256) (by omega),
    ← BitVec.ofNat_add]
  step_pure [cnt_sadd (by decide : 255 < 256), cnt_succ]
  step_pure
  finish_block
  run_from using hK

/-- `^bb56` at `i < 255`: back to `^bb2` at `i + 1`. -/
theorem latch_next (r a : Pointer) (Sb : GlobalState) (i : Nat) (hi : i < 255)
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫)
    (hArgs : E.args = (slide_vartime.args (.value r) (.value a)).get)
    (hK :
      ∀ E' : ⟪slide_vartime.Γ⟫,
        E'.args = E.args → slide_vartime.runFrom (hdrI E' (i + 1)) ^bb2 (st Sb r v) = K) :
    slide_vartime.runFrom (hdrI E i) ^bb56 (st Sb r v) = K := by
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
  · run_from using hK

/-- `^bb2`, the `i` loop from `i`: on to `^bb57` with `loop v i`. -/
theorem main_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n i (v : Vector (BitVec 8) 256) (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        i + n = 255 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args → slide_vartime.runFrom E' ^bb57 (st Sb r (loop v i)) = K) →
        slide_vartime.runFrom (hdrI E i) ^bb2 (st Sb r v) = K := by
  intro n
  induction n with
  | zero =>
    intro i v E hArgs hn hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hi0 : i < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hi0]
    step_pure
    step_pure
    step_pure
    finish_block
    · exact absurd ((sel_iff hi0).1 hbr).2 (by omega)
    · rw [loop_skip hi0 (fun h => hbr ((sel_iff hi0).2 h)), loop_done (by omega)] at hK
      obtain rfl : i = 255 := by omega
      run_from using latch_exit r a Sb K v
      run_from using hK
  | succ n ih =>
    intro i v E hArgs hn hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hi0 : i < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr hr_off hi0]
    step_pure
    step_pure
    step_pure
    finish_block
    · rw [loop_window hi0 ((sel_iff hi0).1 hbr)] at hK
      run_from using window1 r a Sb hr hr_off i ((sel_iff hi0).1 hbr).2 K v
      run_from using latch_next r a Sb i ((sel_iff hi0).1 hbr).2 K (window v i 1)
      run_from using ih (i + 1) (window v i 1) _ _ (by omega)
      run_from using hK
    · rw [loop_skip hi0 (fun h => hbr ((sel_iff hi0).2 h))] at hK
      run_from using latch_next r a Sb i (by omega) K v
      run_from using ih (i + 1) v _ _ (by omega)
      run_from using hK

/-! ### The bit loop -/

/-- The constants the bit loop reads. -/
abbrev consts1 (E : ⟪slide_vartime.Γ⟫) : ⟪slide_vartime.Γ⟫ :=
  E[%2482 := .value 0#64, %2483 := .value 3#64, %2484 := .value 536870911#64, %2485 := .value 6#8,
    %2486 := .value 1#8, %2487 := .value 1#64, %2488 := .value 7#8, %2489 := .value 2#64, %2490 :=
    .value 256#64, %2491 := .value 254#32, %2492 := .value 0#8, %2493 := .value 255#64, %2494 :=
    .value 0#1, %2495 := .value 5#32, %2496 := .value 2#32, %2497 := .value 1#32, %2498 :=
    .value 16#32, %2499 := .value 4294967281#32, %2500 := .value 0#32, %2501 := .value 3#32,
    %2502 := .value 4#32, %2503 := .value 4#64, %2504 := .value 5#64, %2505 := .value 6#32, %2506 :=
    .value 4294967295#32]

/-- `^bb1`, the bit loop from `j`, two bits a round: on to `^bb2` at `i = 0` with `bits A`. -/
theorem bits_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (ha : Fits Sb.mem a 256)
    (ha_off : ¬a.offset.uaddOverflow 32#64) (hsep : r.id ≠ a.id)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n j (E : ⟪slide_vartime.Γ⟫),
      E.args = (slide_vartime.args (.value r) (.value a)).get →
        j + 2 * n = 254 →
        j % 2 = 0 →
        (∀ E' : ⟪slide_vartime.Γ⟫,
          E'.args = E.args →
            slide_vartime.runFrom (hdrI E' 0) ^bb2 (st Sb r (bits (Sb.mem.readAt a 256))) = K) →
        slide_vartime.runFrom ((consts1 E)[%2507 := .value (BitVec.ofNat 64 j)]) ^bb1
            { Sb with mem := fill Sb r (BitVec.packLanes (bits (Sb.mem.readAt a 256))) j } =
          K := by
  intro n
  induction n with
  | zero =>
    intro j E hArgs hj he hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hj0 : j < 256 := by omega
    block_init
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    have hk : j / 8 < 32 := by omega
    have hsh := sh_eq j hj0 he
    have hm : ¬8 ≤ j % 8 := by omega
    have hm' : ¬8 ≤ (j + 1) % 8 := by omega
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.1]
    step_pure [toNat_mod8, hm]
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ hj0 _ rfl, fill_step hr_off hj0] at hS
    step_pure [(or_one hj0 he).1, (or_one hj0 he).2]
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.2]
    step_pure [toNat_mod8, hm']
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ (show j + 1 < 256 by omega) (j / 8) (by omega),
      fill_step hr_off (show j + 1 < 256 by omega)] at hS
    step_pure [saddOverflow_ofNat64 (i := j) (k := 2) (by omega),
      uaddOverflow_ofNat64 (i := j) (k := 2) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · rw [show j + 1 + 1 = 256 by omega, fill_full] at hS
      run_from using hK
    · exact absurd (by rw [show j + 2 = 256 by omega]) hbr
  | succ n ih =>
    intro j E hArgs hj he hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hj0 : j < 256 := by omega
    block_init
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    have hk : j / 8 < 32 := by omega
    have hsh := sh_eq j hj0 he
    have hm : ¬8 ≤ j % 8 := by omega
    have hm' : ¬8 ≤ (j + 1) % 8 := by omega
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.1]
    step_pure [toNat_mod8, hm]
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ hj0 _ rfl, fill_step hr_off hj0] at hS
    step_pure [(or_one hj0 he).1, (or_one hj0 he).2]
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.2]
    step_pure [toNat_mod8, hm']
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ (show j + 1 < 256 by omega) (j / 8) (by omega),
      fill_step hr_off (show j + 1 < 256 by omega)] at hS
    step_pure [saddOverflow_ofNat64 (i := j) (k := 2) (by omega),
      uaddOverflow_ofNat64 (i := j) (k := 2) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
    · run_from using ih (j + 2) _ _ (by omega) (by omega)
      run_from using hK

/-! ### The function -/

/-- `slide_vartime` stores `slide.spec` of the 32 bytes at `a` as the 256 digits at `r`, which
must not alias `a`. -/
public theorem slide_vartime.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 2048) (hr_off : ¬r.offset.uaddOverflow 256#64) (ha : Fits s.mem a 256)
    (ha_off : ¬a.offset.uaddOverflow 32#64) (hsep : r.id ≠ a.id) :
    slide_vartime.call (slide_vartime.args (.value r) (.value a)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeAt r (BitVec.packLanes (slide.spec (s.mem.readAt a 256))) }) := by
  func_init
  have hr₀ : Room S₀.mem r 2048 := hS ▸ hr
  have ha₀ : Fits S₀.mem a 256 := hS ▸ ha
  have BL := bits_loop r a S₀ hr₀ hr_off ha₀ ha_off hsep
  have ML := main_loop r a S₀ hr₀ hr_off
  have h0 := fill_zero (B := BitVec.packLanes (bits (S₀.mem.readAt a 256))) hr₀.inBounds
  clear hr₀ ha₀
  block_init
  iterate 25 step_pure
  finish_block
  have hfill :
    S = { S₀ with mem := fill S₀ r (BitVec.packLanes (bits (S₀.mem.readAt a 256))) 0 } := by
    rw [h0, hS]
  rw [hfill]
  run_from using BL _ 127 0
  run_from using ML _ 255 0 _
  block_init
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Sodium

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

/-! ### `r` in memory -/

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- Splicing byte `j` into 256 packed bytes sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 8) 256} (hj : j < 256) (y : BitVec 8) :
    Memory.spliceBits (BitVec.packLanes u) (j * 8) y = BitVec.packLanes (u.setIfInBounds j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hl :
    ∀ (v : Vector (BitVec 8) 256),
      (BitVec.packLanes v).getLsbD m = (v[m / 8]'(by omega)).getLsbD (m % 8) :=
    fun v => by
    have h := BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (by omega) (by omega)
    simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h
  rw [Memory.getLsbD_spliceBits, hl, hl, Vector.getElem_setIfInBounds]
  by_cases h : m / 8 = j
  · subst h
    have hc : m / 8 * 8 ≤ m ∧ m < m / 8 * 8 + 8 ∧ m < 8 * 256 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(j * 8 ≤ m ∧ m < j * 8 + 8 ∧ m < 8 * 256) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- `r[j]`'s offset `j`, which does not wrap. -/
theorem byte_offset {r : Pointer} (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (BitVec.ofNat 64 j).toNat = j ∧ ¬r.offset.uaddOverflow (BitVec.ofNat 64 j) := by
  have h : (BitVec.ofNat 64 j).toNat = j := by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  exact
    ⟨h,
      BitVec.not_uaddOverflow_of_le hov
        (by
          rw [h]; show j ≤ 256; omega)⟩

/-- `r[j]`, read from the stored digits. -/
theorem readAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hr : InBounds m r 2048) (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (m.storeAt r (BitVec.packLanes v)).readAt (r.add (BitVec.ofNat 64 j)) 8 = v[j] := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [MemoryState.readAt_storeAt_add hr hov' (by omega), h8, BitVec.extractLsb'_packLanes v j hj]

/-- A store of `r[j]` into the stored digits: `r[j]` set. -/
theorem storeAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) (y : BitVec 8) :
    (m.storeAt r (BitVec.packLanes v)).storeAt (r.add (BitVec.ofNat 64 j)) y =
      m.storeAt r (BitVec.packLanes (v.setIfInBounds j y)) := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [storeAt_storeAt_add hov'
      (by
        rw [h8]; omega),
    h8, spliceBits_packLanes hj]

/-- The digits `v` stored at `r` over `S`. -/
abbrev st (S : GlobalState) (r : Pointer) (v : Vector (BitVec 8) 256) : GlobalState :=
  { S with mem := S.mem.storeAt r (BitVec.packLanes v) }

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

/-- Distinct small counters differ as `long`s. -/
theorem ofNat64_ne {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) (h : a ≠ b) :
    BitVec.ofNat 64 a ≠ BitVec.ofNat 64 b := by
  intro e
  have := congrArg BitVec.toNat e
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at this
  exact h this

/-- The carry at a clear `r[k]`: set it. -/
theorem carry_set {v : Vector (BitVec 8) 256} (hk : k < 256) (h : v[k] = 0#8) :
    carry v k = v.setIfInBounds k 1#8 := by
  rw [carry]
  simp [hk, h]

/-- The carry at a set `r[k]`: clear it, carry on. -/
theorem carry_clear {v : Vector (BitVec 8) 256} (hk : k < 256) (h : ¬v[k] = 0#8) :
    carry v k = carry (v.setIfInBounds k 0#8) (k + 1) := by
  rw [carry]
  simp [hk, h]

/-- The carry past `r[255]`: nothing. -/
theorem carry_done {v : Vector (BitVec 8) 256} (hk : 256 ≤ k) : carry v k = v := by
  rw [carry]
  simp [show ¬k < 256 by omega]

/-- `x + c` on a small `long` counter does not overflow, signed. -/
theorem sadd64 {x c : Nat} (h : x + c < 2 ^ 63) :
    (BitVec.ofNat 64 x).saddOverflow (BitVec.ofNat 64 c) = false := by
  have h1 : (BitVec.ofNat 64 x).toInt = x := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 c).toInt = c := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, h1, h2]
  omega

/-- Nor unsigned. -/
theorem uadd64 {x c : Nat} (h : x + c < 2 ^ 64) :
    (BitVec.ofNat 64 x).uaddOverflow (BitVec.ofNat 64 c) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `%2538 = min(254 - i, 5) + 2` is `b`, for `3 ≤ b ≤ 6`: `256 ≤ i + b`. -/
theorem guard_eq (hb : 3 ≤ b ∧ b ≤ 6)
    (h : BitVec.ofNat 32 (min (254 - i) 5 + 2) = BitVec.ofNat 32 b) : 256 ≤ i + b := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)] at this
  omega

/-- It is not: `i + b < 256`. -/
theorem guard_ne (hb : 3 ≤ b ∧ b ≤ 6) (hi : i + (b - 1) < 256)
    (h : ¬BitVec.ofNat 32 (min (254 - i) 5 + 2) = BitVec.ofNat 32 b) : i + b < 256 := by
  apply Classical.byContradiction
  intro hc
  exact h (congrArg (BitVec.ofNat 32) (by omega))

/-- The countdown `254 - i` for `i < 255`. -/
theorem toNat_cnt (hi : i < 255) : (254#32 - BitVec.ofNat 32 i).toNat = 254 - i := by
  rw [BitVec.toNat_sub, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (a := i) (by omega)]
  simp
  omega

/-- The countdown is not yet `0`: `i < 254`. -/
theorem cnt_ne (hi : i < 255) (h : ¬254#32 - BitVec.ofNat 32 i = 0#32) : i < 254 := by
  have := toNat_cnt hi
  have h2 : (254#32 - BitVec.ofNat 32 i).toNat ≠ 0 := fun e =>
    h
      (BitVec.eq_of_toNat_eq
        (by
          rw [e]; rfl))
  omega

/-- The countdown is `0`: `i = 254`. -/
theorem cnt_eq (hi : i < 255) (h : 254#32 - BitVec.ofNat 32 i = 0#32) : i = 254 := by
  have := toNat_cnt hi
  rw [h] at this
  simp at this
  omega

/-- `r[i + b] << b` for `b ≤ 6` keeps its sign: the `shl nsw` holds. -/
theorem sext_shl (x : BitVec 8) (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6) :
    (x.signExtend 32 <<< b).sshiftRight b = x.signExtend 32 := by
  rcases hb with rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `(r[i + b] << b) + r[i]` does not overflow. -/
theorem sext_add (x y : BitVec 8) (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6) :
    (x.signExtend 32 <<< b).saddOverflow (y.signExtend 32) = false := by
  rcases hb with rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `r[i] - (r[i + b] << b)` does not overflow. -/
theorem sext_sub (x y : BitVec 8) (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6) :
    (y.signExtend 32).ssubOverflow (x.signExtend 32 <<< b) = false := by
  rcases hb with rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `r[i] + (r[i + b] << b) <= 15`, as the code tests it: `r[i]` takes in `r[i + b]`, cleared. -/
theorem window_add {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : (v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true) :
    window v i b =
      window
        ((v.setIfInBounds i
              ((v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).setWidth
                8)).setIfInBounds
          (i + b) 0#8)
        i (b + 1) := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by
    intro x y; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, h, BitVec.add_comm (BitVec.signExtend 32 (v[i]'(by omega)))]

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

/-- `x + c` on a small `int` counter does not overflow, signed. -/
theorem sadd32 {x c : Nat} (h : x + c < 2 ^ 31) :
    (BitVec.ofNat 32 x).saddOverflow (BitVec.ofNat 32 c) = false := by
  have h1 : (BitVec.ofNat 32 x).toInt = x := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 c).toInt = c := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, h1, h2]
  omega

/-- Nor unsigned. -/
theorem uadd32 {x c : Nat} (h : x + c < 2 ^ 32) :
    (BitVec.ofNat 32 x).uaddOverflow (BitVec.ofNat 32 c) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `umin(254 - i, 5)` for `i < 255`. -/
theorem umin_cnt (hi : i < 255) :
    (if (254#32 - BitVec.ofNat 32 i).ult 5#32 = true then 254#32 - BitVec.ofNat 32 i else 5#32) =
      BitVec.ofNat 32 (min (254 - i) 5) := by
  have h := toNat_cnt hi
  apply BitVec.eq_of_toNat_eq
  split
  · rename_i hlt
    simp only [BitVec.ult, h, decide_eq_true_eq] at hlt
    simp at hlt
    rw [h, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  · rename_i hlt
    simp only [BitVec.ult, h, decide_eq_true_eq] at hlt
    simp at hlt
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    simp
    omega

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd64 (x := i + 1) (c := 5) (by omega), uadd64 (x := i + 1) (c := 5) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 5 = i + 6 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 6) (by decide) hbr; omega)] at hK
    step_loop using hK
  have hib : i + 6 < 256 := by
    have := guard_ne (b := 6) (by decide) hi hbr; omega
  have C := carry6_loop r a Sb hr hr_off i K (255 - (i + 6)) (i + 6)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    rw [window_stop (by omega)] at hK
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 6 = 1 ∨ 6 = 2 ∨ 6 = 3 ∨ 6 = 4 ∨ 6 = 5 ∨ 6 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 6 = 1 ∨ 6 = 2 ∨ 6 = 3 ∨ 6 = 4 ∨ 6 = 5 ∨ 6 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  rw [window_stop (by omega)] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using hK

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd64 (x := i + 1) (c := 4) (by omega), uadd64 (x := i + 1) (c := 4) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 4 = i + 5 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 5) (by decide) hbr; omega)] at hK
    step_loop using hK
  have hib : i + 5 < 256 := by
    have := guard_ne (b := 5) (by decide) hi hbr; omega
  have W := window6 r a Sb hr hr_off i hib K
  have C := carry5_loop r a Sb hr hr_off i K (255 - (i + 5)) (i + 5)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    step_loop using W _
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 5 = 1 ∨ 5 = 2 ∨ 5 = 3 ∨ 5 = 4 ∨ 5 = 5 ∨ 5 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using W _
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 5 = 1 ∨ 5 = 2 ∨ 5 = 3 ∨ 5 = 4 ∨ 5 = 5 ∨ 5 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using W _
  step_loop using hK

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd64 (x := i + 1) (c := 3) (by omega), uadd64 (x := i + 1) (c := 3) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 3 = i + 4 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 4) (by decide) hbr; omega)] at hK
    step_loop using hK
  have hib : i + 4 < 256 := by
    have := guard_ne (b := 4) (by decide) hi hbr; omega
  have W := window5 r a Sb hr hr_off i hib K
  have C := carry4_loop r a Sb hr hr_off i K (255 - (i + 4)) (i + 4)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    step_loop using W _
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 4 = 1 ∨ 4 = 2 ∨ 4 = 3 ∨ 4 = 4 ∨ 4 = 5 ∨ 4 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using W _
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 4 = 1 ∨ 4 = 2 ∨ 4 = 3 ∨ 4 = 4 ∨ 4 = 5 ∨ 4 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using W _
  step_loop using hK

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd64 (x := i + 1) (c := 2) (by omega), uadd64 (x := i + 1) (c := 2) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 2 = i + 3 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := guard_eq (b := 3) (by decide) hbr; omega)] at hK
    step_loop using hK
  have hib : i + 3 < 256 := by
    have := guard_ne (b := 3) (by decide) hi hbr; omega
  have W := window4 r a Sb hr hr_off i hib K
  have C := carry3_loop r a Sb hr hr_off i K (255 - (i + 3)) (i + 3)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    step_loop using W _
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 3 = 1 ∨ 3 = 2 ∨ 3 = 3 ∨ 3 = 4 ∨ 3 = 5 ∨ 3 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using W _
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 3 = 1 ∨ 3 = 2 ∨ 3 = 3 ∨ 3 = 4 ∨ 3 = 5 ∨ 3 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using W _
  step_loop using hK

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd64 (x := i + 1) (c := 1) (by omega), uadd64 (x := i + 1) (c := 1) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 1 = i + 2 from rfl]
  step_pure
  finish_block
  · rw [window_stop
        (by
          have := cnt_eq hi hbr; omega)] at hK
    step_loop using hK
  have hib : i + 2 < 256 := by
    have := cnt_ne hi hbr; omega
  have W := window3 r a Sb hr hr_off i hib K
  have C := carry2_loop r a Sb hr hr_off i K (255 - (i + 2)) (i + 2)
  -- if (r[i + b])
  block_init
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    step_loop using W _
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 2 = 1 ∨ 2 = 2 ∨ 2 = 3 ∨ 2 = 4 ∨ 2 = 5 ∨ 2 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using W _
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 2 = 1 ∨ 2 = 2 ∨ 2 = 3 ∨ 2 = 4 ∨ 2 = 5 ∨ 2 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using W _
  step_loop using hK

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
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · rw [carry_done (by omega)] at hK
        step_loop using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      step_loop using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · step_loop using ih (k + 1)
        step_loop using hK

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
  step_pure [sadd32 (x := min (254 - i) 5) (c := 2) (by omega),
    uadd32 (x := min (254 - i) 5) (c := 2) (by omega), ← BitVec.ofNat_add]
  have hib : i + 1 < 256 := by omega
  have W := window2 r a Sb hr hr_off i hi K
  have C := carry1_loop r a Sb hr hr_off i K (255 - (i + 1)) (i + 1)
  -- if (r[i + b])
  step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK
    step_loop using W _
    step_loop using hK
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_pure
  step_pure [sext_shl _ (by decide : 1 = 1 ∨ 1 = 2 ∨ 1 = 3 ∨ 1 = 4 ∨ 1 = 5 ∨ 1 = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
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
    step_loop using W _
    step_loop using hK
  have h1 := hbr
  -- if (cmp < -15) break
  block_init
  step_pure [sext_sub _ _ (by decide : 1 = 1 ∨ 1 = 2 ∨ 1 = 3 ∨ 1 = 4 ∨ 1 = 5 ∨ 1 = 6)]
  step_pure
  finish_block
  · rw [window_break (by decide) hib h0 h1 hbr] at hK
    step_loop using hK
  rw [window_sub (by decide) hib h0 h1 hbr] at hK
  simp only [Nat.reduceAdd] at hK
  block_init
  step_pure
  step_store
  rw [storeAt_byte hr_off hi0] at hS
  finish_block
  step_loop using C
  step_loop using W _
  step_loop using hK

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
theorem cnt_sadd (hi : i < 256) :
    (254#32 - BitVec.ofNat 32 i).saddOverflow 4294967295#32 = false := by
  have hy : BitVec.ofNat 32 i ≤ 255#32 := by
    rw [BitVec.le_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  generalize BitVec.ofNat 32 i = y at hy
  bv_decide

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
  step_loop using hK

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
    loop v i = loop (window v i 1) (i + 1) := by rw [loop_step hi, ite_eq_left h.1]

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

/-! ### The bit loop -/

/-- The low `8 j` bits of the 256 bytes. -/
abbrev lowMask (j : Nat) : BitVec 2048 :=
  BitVec.allOnes 2048 >>> (2048 - 8 * j)

/-- `r` after the bit loop's first `j` stores over `Sb`: the bytes of `B` below `j`, `Sb`'s above,
defined as stored. -/
abbrev fill (Sb : GlobalState) (r : Pointer) (B : BitVec 2048) (j : Nat) : MemoryState :=
  Sb.mem.storeDef r (B &&& lowMask j ||| Sb.mem.readAt r 2048 &&& ~~~lowMask j)
    (lowMask j ||| Sb.mem.definedAt r 2048 &&& ~~~lowMask j)

/-- A store inside a range stored with definedness: one such store, both spliced. -/
theorem storeDef_storeAt_add {m : MemoryState} {p : Pointer} {u d : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeDef p u d).storeAt (p.add off) y =
      m.storeDef p (Memory.spliceBits u (off.toNat * 8) y)
        (Memory.spliceBits d (off.toNat * 8) (BitVec.allOnes wy)) := by
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw]

/-- Before the loop: `Sb`'s memory. -/
theorem fill_zero {Sb : GlobalState} {r : Pointer} (hr : InBounds Sb.mem r 2048) (B : BitVec 2048) :
    fill Sb r B 0 = Sb.mem := by
  have h0 : lowMask 0 = 0#2048 := by
    apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp [BitVec.getLsbD_ushiftRight]
  simp only [fill, h0, BitVec.and_zero, BitVec.zero_or, BitVec.not_zero, BitVec.and_allOnes]
  exact MemoryState.storeDef_readAt_definedAt hr

/-- After it: `B` stored. -/
theorem fill_full {Sb : GlobalState} {r : Pointer} (B : BitVec 2048) :
    fill Sb r B 256 = Sb.mem.storeAt r B := by
  have h1 : lowMask 256 = BitVec.allOnes 2048 := by simp [lowMask]
  simp only [fill, h1, BitVec.and_allOnes, BitVec.not_allOnes, BitVec.and_zero, BitVec.or_zero]
  rfl

/-- The store of byte `j` of `B`: one byte more. -/
theorem fill_step {Sb : GlobalState} {r : Pointer} {B : BitVec 2048}
    (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (fill Sb r B j).storeAt (r.add (BitVec.ofNat 64 j)) (B.extractLsb' (j * 8) 8) =
      fill Sb r B (j + 1) := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [storeDef_storeAt_add hov'
      (by
        rw [h8]; omega),
    h8]
  congr 1
  · apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
      BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes, BitVec.getLsbD_extractLsb']
    by_cases h : j * 8 ≤ k ∧ k < j * 8 + 8 ∧ k < 2048
    · simp only [h, and_self, ite_true]
      simp [show k - j * 8 < 8 by omega, show j * 8 + (k - j * 8) = k by omega, hk,
        show 2048 - 8 * (j + 1) + k < 2048 by omega]
    · simp only [h, ite_false]
      simp [hk]
      grind
  · apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
      BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes]
    by_cases h : j * 8 ≤ k ∧ k < j * 8 + 8 ∧ k < 2048
    · simp only [h, and_self, ite_true]
      simp [show k - j * 8 < 8 by omega, hk, show 2048 - 8 * (j + 1) + k < 2048 by omega]
    · simp only [h, ite_false]
      simp [hk]
      grind

/-- `a[i >> 3]`'s index. -/
theorem idx_eq (hj : j < 256) :
    BitVec.ofNat 64 j >>> 3 &&& 536870911#64 = BitVec.ofNat 64 (j / 8) := by
  have : ∀ j < 256, BitVec.ofNat 64 j >>> 3 &&& 536870911#64 = BitVec.ofNat 64 (j / 8) := by
    decide +kernel
  exact this j hj

/-- `a[k]`, read from the 32 bytes at `a`. -/
theorem readAt_a {m : MemoryState} {a : Pointer} (ha : InBounds m a 256)
    (hov : ¬a.offset.uaddOverflow 32#64) (hk : k < 32) :
    m.readAt (a.add (BitVec.ofNat 64 k)) 8 = (m.readAt a 256).extractLsb' (k * 8) 8 := by
  have h8 : (BitVec.ofNat 64 k).toNat = k := by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [MemoryState.readAt_add_of_readAt ha
      (BitVec.not_uaddOverflow_of_le hov
        (by
          rw [h8]; show k ≤ 32; omega))
      (by
        rw [h8]; omega)
      rfl,
    h8]

/-- `i & 6` and `(i | 1) & 7` on an even `i`: `i % 8` and `(i + 1) % 8`. -/
theorem sh_eq :
    ∀ j < 256,
      j % 2 = 0 →
        BitVec.ofNat 8 j &&& 6#8 = BitVec.ofNat 8 (j % 8) ∧
          BitVec.ofNat 8 (j + 1) &&& 7#8 = BitVec.ofNat 8 ((j + 1) % 8) := by
  decide +kernel

/-- `i | 1` on an even `i`: `i + 1`. -/
theorem or_one (hj : j < 256) (he : j % 2 = 0) :
    BitVec.ofNat 64 j &&& 1#64 = 0#64 ∧ BitVec.ofNat 64 j ||| 1#64 = BitVec.ofNat 64 (j + 1) := by
  have :
    ∀ j < 256,
      j % 2 = 0 →
        BitVec.ofNat 64 j &&& 1#64 = 0#64 ∧
          BitVec.ofNat 64 j ||| 1#64 = BitVec.ofNat 64 (j + 1) := by
    decide +kernel
  exact this j hj he

/-- `(a[i >> 3] >> (i & 7)) & 1` as the code computes it: byte `i` of the bits. -/
theorem bit_byte (A : BitVec 256) (hj : j < 256) (k : Nat) (hk : k = j / 8) :
    A.extractLsb' (k * 8) 8 >>> (j % 8) &&& 1#8 =
      (BitVec.packLanes (bits A)).extractLsb' (j * 8) 8 := by
  rw [BitVec.extractLsb'_packLanes (bits A) j hj]
  simp only [bits, Vector.getElem_ofFn, hk, Nat.mul_comm (j / 8), BitVec.and_comm]

/-- The shift amount `i % 8 < 8`. -/
theorem toNat_mod8 : (BitVec.ofNat 8 (j % 8)).toNat = j % 8 := by
  simp only [BitVec.toNat_ofNat]
  omega

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
    step_pure [sadd64 (x := j) (c := 2) (by omega), uadd64 (x := j) (c := 2) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    finish_block
    · rw [show j + 1 + 1 = 256 by omega, fill_full] at hS
      step_loop using hK
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
    step_pure [sadd64 (x := j) (c := 2) (by omega), uadd64 (x := j) (c := 2) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    finish_block
    · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
    · step_loop using ih (j + 2) _ _ (by omega) (by omega)
      step_loop using hK

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
  step_loop using BL _ 127 0
  step_loop using ML _ 255 0 _
  block_init
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Sodium

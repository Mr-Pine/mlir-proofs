/-- `x + c` on a small `long` counter does not overflow, signed. -/
theorem sadd64 {x c : Nat} (h : x + c < 2 ^ 63) :
    (BitVec.ofNat 64 x).saddOverflow (BitVec.ofNat 64 c) = false := by
  have h1 : (BitVec.ofNat 64 x).toInt = x := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 c).toInt = c := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, h1, h2]
  omega

/-- Nor unsigned. -/
theorem uadd64 {x c : Nat} (h : x + c < 2 ^ 64) :
    (BitVec.ofNat 64 x).uaddOverflow (BitVec.ofNat 64 c) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `%262 = min(254 - i, 5) + 2` is `b`, for `3 ≤ b ≤ 6`: `256 ≤ i + b`. -/
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
    h (BitVec.eq_of_toNat_eq (by rw [e]; rfl))
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

/-- Past `b = 6` or `r[255]`: the window is done. -/
theorem window_stop {v : Vector (BitVec 8) 256} (h : ¬(b ≤ 6 ∧ i + b < 256)) : window v i b = v := by
  rw [window, dite_eq_right h]

/-- A clear `r[i + b]`: on to `b + 1`. -/
theorem window_skip {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : v[i + b] = 0#8) : window v i b = window v i (b + 1) := by
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte]

/-- `r[i] + (r[i + b] << b) <= 15`, as the code tests it: `r[i] += r[i + b] << b`, `r[i + b] = 0`. -/
theorem window_add {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : (v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true) :
    window v i b =
      window ((v.setIfInBounds i ((v[i + b].signExtend 32 <<< b +
        (v[i]'(by omega)).signExtend 32).setWidth 8)).setIfInBounds (i + b) 0#8) i (b + 1) := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by intro x y; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, h, BitVec.add_comm (BitVec.signExtend 32 (v[i]'(by omega)))]

/-- Else `r[i] - (r[i + b] << b) >= -15`: `r[i] -= r[i + b] << b` and the carry from `i + b`. -/
theorem window_sub {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : ¬(v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true)
    (h' : (4294967280#32).slt ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b) =
      true) :
    window v i b =
      window (carry (v.setIfInBounds i (((v[i]'(by omega)).signExtend 32 -
        v[i + b].signExtend 32 <<< b).setWidth 8)) (i + b)) i (b + 1) := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by intro x y; bv_decide
  have e' : ∀ x : BitVec 32, (-15#32).sle x = (4294967280#32).slt x := by intro x; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, e', h, h', Bool.false_eq_true]

/-- Else: the window ends. -/
theorem window_break {v : Vector (BitVec 8) 256} (hb : b ≤ 6) (hib : i + b < 256)
    (h0 : ¬v[i + b] = 0#8)
    (h : ¬(v[i + b].signExtend 32 <<< b + (v[i]'(by omega)).signExtend 32).slt 16#32 = true)
    (h' : ¬(4294967280#32).slt ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b) =
      true) :
    window v i b = v := by
  have e : ∀ x y : BitVec 32, (x + y).sle 15#32 = (y + x).slt 16#32 := by intro x y; bv_decide
  have e' : ∀ x : BitVec 32, (-15#32).sle x = (4294967280#32).slt x := by intro x; bv_decide
  rw [window, dite_eq_left ⟨hb, hib⟩]
  simp only [h0, ↓reduceIte, e, e', h, h', Bool.false_eq_true]

/-- `x + c` on a small `int` counter does not overflow, signed. -/
theorem sadd32 {x c : Nat} (h : x + c < 2 ^ 31) :
    (BitVec.ofNat 32 x).saddOverflow (BitVec.ofNat 32 c) = false := by
  have h1 : (BitVec.ofNat 32 x).toInt = x := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 c).toInt = c := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
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


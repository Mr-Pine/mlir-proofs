module

public import Ed25519.Decode
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Mathlib.Tactic.Linarith

/-! The constant-time byte comparison behind Zig's `scalar.rejectNonCanonical`, as numbers. -/

namespace MLIR.Zig

/-! ## Definitions -/

@[expose] public section

/-- `c` gains `n`'s bit where `x < y`: the borrow of `x - y` in 16 bits, masked by `n`. -/
def ltScan.cStep (c n x y : BitVec 8) : BitVec 8 :=
  c ||| ((x.setWidth 16 - y.setWidth 16) >>> 8).setWidth 8 &&& n

/-- `n` keeps its bit where `x = y`: the borrow of `(x ^ y) - 1` in 16 bits. -/
def ltScan.nStep (n x y : BitVec 8) : BitVec 8 :=
  n &&& (((x.setWidth 16 ^^^ y.setWidth 16) - 1) >>> 8).setWidth 8

/-- Zig's scan of bytes `i`, `i - 1`, …, `0` of `s` against `o`, from flags `c`, `n`. -/
def ltScan (s o : ℕ → BitVec 8) : ℕ → BitVec 8 → BitVec 8 → BitVec 8
  | 0, c, n => ltScan.cStep c n (s 0) (o 0)
  | i + 1, c, n =>
    ltScan s o i (ltScan.cStep c n (s (i + 1)) (o (i + 1))) (ltScan.nStep n (s (i + 1)) (o (i + 1)))

/-- Bytes `0` to `i - 1` as a little-endian number. -/
def bytesVal (s : ℕ → BitVec 8) : ℕ → ℕ
  | 0 => 0
  | i + 1 => bytesVal s i + (s i).toNat * 256 ^ i

end

/-! ## The scan compares -/

public theorem ltScan.cStep_eq {c n x y : BitVec 8} :
    ltScan.cStep c n x y = c ||| (n &&& if x.toNat < y.toNat then 255#8 else 0#8) := by
  unfold ltScan.cStep
  split <;> rename_i h
  · have : x < y := by
      rw [BitVec.lt_def]; exact h
    bv_decide
  · have : ¬x < y := by
      rw [BitVec.lt_def]; exact h
    bv_decide

public theorem ltScan.nStep_eq {n x y : BitVec 8} :
    ltScan.nStep n x y = n &&& if x = y then 255#8 else 0#8 := by
  unfold ltScan.nStep
  split <;> rename_i h
  · subst h; bv_decide
  · bv_decide

public theorem bytesVal_lt (s : ℕ → BitVec 8) (i : ℕ) : bytesVal s i < 256 ^ i := by
  induction i with
  | zero => simp [bytesVal]
  | succ i ih =>
    have := (s i).isLt
    simp only [bytesVal, pow_succ]
    nlinarith

/-- Two-digit numbers in base `B` compare by their top digits first. -/
public theorem lex_lt {a b x y B : ℕ} (ha : a < B) (hb : b < B) :
    a + x * B < b + y * B ↔ x < y ∨ x = y ∧ a < b := by
  constructor
  · intro h
    rcases Nat.lt_trichotomy x y with hxy | rfl | hxy
    · exact .inl hxy
    · exact .inr ⟨rfl, by omega⟩
    · have : (y + 1) * B ≤ x * B := Nat.mul_le_mul_right _ hxy
      rw [Nat.succ_mul] at this
      omega
  · rintro (hxy | ⟨rfl, hab⟩)
    · have : (x + 1) * B ≤ y * B := Nat.mul_le_mul_right _ hxy
      rw [Nat.succ_mul] at this
      omega
    · omega

set_option linter.unusedSimpArgs false in
/-- The scan from bit flags `c`, `n`: `c`, or `n` where bytes `0..i` of `s` are below `o`'s. -/
public theorem ltScan_eq (s o : ℕ → BitVec 8) (i : ℕ) (c n : BitVec 8) (hc : c = 0 ∨ c = 1)
    (hn : n = 0 ∨ n = 1) :
    ltScan s o i c n = c ||| (n &&& if bytesVal s (i + 1) < bytesVal o (i + 1) then 1 else 0) := by
  induction i generalizing c n with
  | zero =>
    simp only [ltScan, ltScan.cStep_eq, bytesVal, zero_add, pow_zero, mul_one]
    by_cases h : (s 0).toNat < (o 0).toNat <;> simp only [h, ↓reduceIte] <;>
      rcases hc with rfl | rfl <;>
      rcases hn with rfl | rfl <;>
      decide
  | succ i
    ih =>
    have hc' :
      ltScan.cStep c n (s (i + 1)) (o (i + 1)) = 0 ∨
        ltScan.cStep c n (s (i + 1)) (o (i + 1)) = 1 := by
      rw [ltScan.cStep_eq]
      rcases hc with rfl | rfl <;> rcases hn with rfl | rfl <;> split <;> decide
    have hn' :
      ltScan.nStep n (s (i + 1)) (o (i + 1)) = 0 ∨ ltScan.nStep n (s (i + 1)) (o (i + 1)) = 1 := by
      rw [ltScan.nStep_eq]
      rcases hn with rfl | rfl <;> split <;> decide
    rw [ltScan, ih _ _ hc' hn', ltScan.cStep_eq, ltScan.nStep_eq]
    have hv :
      bytesVal s (i + 1 + 1) < bytesVal o (i + 1 + 1) ↔
        (s (i + 1)).toNat < (o (i + 1)).toNat ∨
          (s (i + 1)).toNat = (o (i + 1)).toNat ∧ bytesVal s (i + 1) < bytesVal o (i + 1) :=
      lex_lt (bytesVal_lt s (i + 1)) (bytesVal_lt o (i + 1))
    have he : s (i + 1) = o (i + 1) ↔ (s (i + 1)).toNat = (o (i + 1)).toNat := BitVec.toNat_inj.symm
    by_cases h1 : (s (i + 1)).toNat < (o (i + 1)).toNat <;>
      by_cases h2 : (s (i + 1)).toNat = (o (i + 1)).toNat <;>
      by_cases h3 : bytesVal s (i + 1) < bytesVal o (i + 1) <;>
      have hV := hv <;>
      simp only [h1, h2, h3, true_or, false_or, true_and, false_and, or_false, or_true,
        lt_self_iff_false, iff_true, iff_false] at hV <;>
      simp only [hV, he, h1, h2, h3, lt_self_iff_false, ↓reduceIte] <;>
      rcases hc with rfl | rfl <;>
      rcases hn with rfl | rfl <;>
      decide

end MLIR.Zig

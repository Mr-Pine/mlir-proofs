module

public import Ed25519.Group
public import Ed25519.Sha512
import Mathlib.Tactic.LinearCombination

/-! Points decoded from 32 bytes, and bytes as little-endian numbers. -/

open Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Ed25519

/-- `P` is a point `buf` encodes: `y` the low 255 bits mod `p`, `x` of the top bit's parity, any
sign accepted for `x = 0` (non-canonical encodings accepted, as Dalek does). -/
def Decodes (buf : BitVec 256) (P : Point) : Prop :=
  P.y = ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧ (P.x = 0 ∨ P.x.val % 2 = buf.toNat / 2 ^ 255)

instance : DecidableEq Point := fun P Q =>
  decidable_of_iff (P.x = Q.x ∧ P.y = Q.y) (by rw [Point.ext_iff])

/-- Bytes as a little-endian number. -/
def natLE : List (BitVec 8) → ℕ
  | [] => 0
  | b :: l => b.toNat + 256 * natLE l

/-- The point `buf` encodes, if any. -/
noncomputable def decode (buf : BitVec 256) : Option Point :=
  open Classical in
  if h : ∃ P, Decodes buf P then some (Classical.choose h) else none

end Ed25519

end

/-! ## Bytes -/

section Bytes

public theorem Ed25519.natLE_ofFn (x : BitVec w) (o m : ℕ) :
    Ed25519.natLE (List.ofFn fun i : Fin m => x.extractLsb' (o + 8 * i) 8) =
      x.toNat / 2 ^ o % 2 ^ (8 * m) := by
  induction m generalizing o with
  | zero => simp [Ed25519.natLE, Nat.mod_one]
  | succ m ih =>
    rw [List.ofFn_succ, Ed25519.natLE]
    have e : (fun i : Fin m => x.extractLsb' (o + 8 * (i.succ : ℕ)) 8) =
        fun i : Fin m => x.extractLsb' ((o + 8) + 8 * (i : ℕ)) 8 := by
      funext i
      simp only [Fin.val_succ]
      congr 1
      omega
    simp only [Fin.val_zero, mul_zero, add_zero, e, ih, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, pow_add, ← Nat.div_div_eq_div_mul]
    generalize x.toNat / 2 ^ o = q
    rw [show 8 * (m + 1) = 8 + 8 * m by omega, pow_add, Nat.mod_mul]
    rfl

/-- `bytesLE` read back as a little-endian number is the bit vector's value. -/
public theorem Ed25519.natLE_bytesLE (x : BitVec (8 * n)) :
    Ed25519.natLE (bytesLE x) = x.toNat := by
  have h := Ed25519.natLE_ofFn x 0 n
  simp only [zero_add, pow_zero, Nat.div_one] at h
  rw [bytesLE, show 8 * n / 8 = n by omega]
  rw [h]
  exact Nat.mod_eq_of_lt x.isLt

end Bytes

/-! ## Decoding -/

section Decode

namespace Ed25519

/-- On the curve, `y` fixes `x²`. -/
public theorem sq_eq_of_onCurve {x x' y : ZMod p} (h : OnCurve x y) (h' : OnCurve x' y) :
    x ^ 2 = x' ^ 2 := by
  have hne := one_add_ne 1 y
  unfold OnCurve at h h'
  have : (1 + d * 1 ^ 2 * y ^ 2) * (x ^ 2 - x' ^ 2) = 0 := by linear_combination h' - h
  exact sub_eq_zero.1 ((mul_eq_zero.1 this).resolve_left hne)

/-- At most one point decodes from `buf`. -/
public theorem Decodes.unique {buf : BitVec 256} {P Q : Point} (hP : Decodes buf P)
    (hQ : Decodes buf Q) : P = Q := by
  have hy : P.y = Q.y := hP.1.trans hQ.1.symm
  have hx2 := sq_eq_of_onCurve P.on (hy ▸ Q.on)
  have : (P.x - Q.x) * (P.x + Q.x) = 0 := by linear_combination hx2
  ext
  · rcases mul_eq_zero.1 this with h | h
    · exact sub_eq_zero.1 h
    · -- `Q.x = -P.x`: the parities differ unless both are zero
      have hq : Q.x = -P.x := by linear_combination h
      rcases eq_or_ne P.x 0 with h0 | h0
      · rw [hq, h0, neg_zero]
      · exfalso
        have hp : (-P.x).val = p - P.x.val := by rw [ZMod.neg_val, ite_eq_right h0]
        have hlt := ZMod.val_lt P.x
        have hpos : 0 < P.x.val := (ZMod.val_pos).2 h0
        have hp2 : p % 2 = 1 := by norm_num
        rcases hP.2 with hP0 | hP2
        · exact h0 hP0
        rcases hQ.2 with hQ0 | hQ2
        · exact h0 (by rw [hq] at hQ0; exact neg_eq_zero.1 hQ0)
        rw [hq, hp] at hQ2
        omega
  · exact hy

/-- `decode` finds the point that decodes. -/
public theorem decode_eq_some {buf : BitVec 256} {P : Point} (h : Decodes buf P) :
    decode buf = some P := by
  have hex : ∃ P, Decodes buf P := ⟨P, h⟩
  simp only [decode, hex, dite_true, Option.some.injEq]
  exact (Classical.choose_spec hex).unique h

/-- `decode` fails exactly when no point decodes. -/
public theorem decode_eq_none {buf : BitVec 256} : decode buf = none ↔ ∀ P, ¬Decodes buf P := by
  simp only [decode]
  split
  · next h => simp only [reduceCtorEq, false_iff, not_forall, not_not]; exact h
  · next h => simpa using h

/-- A point with `buf`'s `y` exists exactly when one decodes: `x` or `-x` has the right parity. -/
public theorem exists_decodes_iff (buf : BitVec 256) :
    (∃ P, Decodes buf P) ↔ ∃ x, OnCurve x ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  constructor
  · rintro ⟨P, hy, -⟩
    exact ⟨P.x, hy ▸ P.on⟩
  · rintro ⟨x, hx⟩
    have hb : buf.toNat / 2 ^ 255 < 2 := by have := buf.isLt; omega
    by_cases h : x = 0 ∨ x.val % 2 = buf.toNat / 2 ^ 255
    · exact ⟨⟨x, _, hx⟩, rfl, h⟩
    · refine ⟨⟨-x, _, hx.neg⟩, rfl, .inr ?_⟩
      push Not at h
      rw [ZMod.neg_val, ite_eq_right h.1]
      have hlt := ZMod.val_lt x
      have hp2 : p % 2 = 1 := by norm_num
      omega

end Ed25519

end Decode

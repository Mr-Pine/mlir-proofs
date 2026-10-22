module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_curve25519_scalar_validate
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.Ref (scalarL MemoryState.readAt_add_of_fits MemoryState.readAt_of_fits)

/-! ## Proof -/

section Proof

/-! `subborrow`'s borrow out is `a.toNat < b.toNat + c'`; these turn the chain into compares
`bv_decide` reads. -/

private theorem lt_add_ite {a n : Nat} {c : Prop} [Decidable c] :
    (a < n + if c then 0 else 1) ↔ c ∧ a < n ∨ ¬c ∧ a < n + 1 := by split <;> simp [*]

private theorem add_ite_le {a n : Nat} {c : Prop} [Decidable c] :
    (n + (if c then 0 else 1) ≤ a) ↔ c ∧ n ≤ a ∨ ¬c ∧ n + 1 ≤ a := by split <;> simp [*]

private theorem ite_le {a : Nat} {c : Prop} [Decidable c] :
    ((if c then 0 else 1) ≤ a) ↔ c ∨ 1 ≤ a := by
  split <;> simp [*]

private theorem toNat_lt_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    x.toNat < n ↔ x < BitVec.ofNat 64 n := by simp [BitVec.lt_def, Nat.mod_eq_of_lt h]

private theorem le_toNat_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    n ≤ x.toNat ↔ BitVec.ofNat 64 n ≤ x := by simp [BitVec.le_def, Nat.mod_eq_of_lt h]

private theorem ite_flip {α : Type} {x y : α} {A B : Prop} [Decidable A] [Decidable B]
    (h : A ↔ ¬B) : (if A then x else y) = if B then y else x := by by_cases hb : B <;> simp [h, hb]

/-- `validate` returns `p` when the 32 bytes at `p` are a canonical scalar (below `ℓ`), else
`NULL`, and leaves the state alone; the loads inline, as mlir-proofs' proof otherwise. -/
public theorem fd_curve25519_scalar_validate.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (8 * 32)) (hoff : ¬p.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_validate.call (fd_curve25519_scalar_validate.args (.value p)) s =
      .value
        (.cons
            (.value
              (if Ref.fd_curve25519_scalar_validate.spec (s.mem.readAt p 256) then p
              else Pointer.null))
            .nil,
          s) := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq] at hoff ⊢; omega
  have hf0 : Fits s.mem p 64 := hfits.mono (by omega)
  have hf8 : Fits s.mem (p.add 8#64) 64 := Fits.add_of_le (hov 8 (by omega)) (by decide) hfits
  have hf16 : Fits s.mem (p.add 16#64) 64 := Fits.add_of_le (hov 16 (by omega)) (by decide) hfits
  have hf24 : Fits s.mem (p.add 24#64) 64 := Fits.add_of_le (hov 24 (by omega)) (by decide) hfits
  func_init
  block_init
  iterate 10 step_pure
  step_load
  step_pure
  finish_block <;> block_init
  case isTrue =>
    finish_block
    subst hS
    simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
      Nat.reduceMul] at hbr
    rw [ite_eq_left
        (by
          simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
  case isFalse =>
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      subst hS
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        Nat.reduceMul] at hbr
      rw [ite_eq_right
          (by
            simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
    case isTrue =>
      step_load
      iterate 3 (step_pure; step_load)
      step_pure
      step_pure
      generalize hc0 : (if _ < 6346243789798364141 then 1#8 else 0#8) = c0 at hE
      step_pure
      step_pure
      generalize hc1 : (if _ < 1503914060200516822 + _ then 1#8 else 0#8) = c1 at hE
      step_pure
      step_pure
      generalize hc2 :
        (if (S.mem.readAt (p.add 16#64) 64).toNat < (if c1 = 0#8 then 0 else 1) then 1#8 else 0#8) = c2 at hE
      step_pure
      step_pure
      generalize hc3 : (if _ < 1152921504606846976 + _ then 1#8 else 0#8) = c3 at hE
      iterate 2 step_pure
      finish_block
      block_init
      finish_block
      subst hS hc3 hc2 hc1 hc0
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        MemoryState.readAt_of_fits (v := 256) (w := 64) hfits, Nat.reduceMul]
      generalize S.mem.readAt p 256 = x
      clear hE hbr hArgs hfits hoff hwf hf0 hf8 hf16 hf24 hov
      simp only [Ref.fd_curve25519_scalar_validate.spec, scalarL]
      simp (disch := decide) only [lt_add_ite, ite_le, toNat_lt_iff, le_toNat_iff,
        Nat.reduceAdd]
      congr 4
      apply ite_flip
      bv_decide

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512

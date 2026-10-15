module

public import Firedancer.Lane.verify_x8.ChecksMem
public import Firedancer.Lane.verify_x8.ChecksBits

/-! The codes `verify_x8` stores: the lane masks' bits, `x8`'s live items, and the memories of the
early returns as `x8Mem`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref

@[expose] public section

/-- Without long live items nothing is streamed. -/
theorem streamMem_of_not_long {m : MemoryState} {it : Nat → Item} {long : Nat → Bool} :
    ∀ {n : Nat}, (∀ j < n, long j = false) → streamMem m it long n = m
  | 0, _ => rfl
  | n + 1, h => by
    simp only [streamMem, h n (by omega), Bool.false_eq_true, ite_false]
    exact streamMem_of_not_long fun j hj => h j (by omega)

/-- An empty mask: no lane. -/
theorem maskOf_eq_zero {f : Fin 8 → Bool} (h : maskOf f = 0) (j : Fin 8) : f j = false := by
  have := getLsbD_maskOf f j
  simp only [h, j.isLt, ↓reduceDIte] at this
  exact (this.symm.trans BitVec.getLsbD_zero)

/-- `x8`'s live items: candidates with both decodings valid and neither of small order. -/
theorem x8Of_live (m : MemoryState) (it : Nat → Item) (cnt : Nat) (j : Fin 8) :
    (x8Of m it cnt).live j =
      ((x8Of m it cnt).cand j && (x8Of m it cnt).aValid.getLsbD j &&
        (x8Of m it cnt).rValid.getLsbD j && !(x8Of m it cnt).aSmall.getLsbD j &&
        !(x8Of m it cnt).rSmall.getLsbD j) :=
  rfl

namespace Call

variable (c : Call)

/-- A dead item's code is the checks'. -/
theorem code1_of_not_live {j : Nat} (hl : c.X.liveAt j = false) : c.code1 j = c.X.resultAt j := by
  unfold code1 X8.resultAt X8.liveAt at *
  split
  · rename_i h
    simp only [h, ↓reduceDIte, x8Of_live] at hl
    simp only [X8.result]
    revert hl
    cases c.X.cand ⟨j, h⟩ <;> cases c.X.aValid.getLsbD j <;> cases c.X.rValid.getLsbD j <;>
      cases c.X.aSmall.getLsbD j <;> cases c.X.rSmall.getLsbD j <;> simp
  · rfl

/-- Without candidates the first loop's codes are `verify_x8`'s memory. -/
theorem mem38_eq (hc : c.Ok) (h : c.candMask = 0) :
    c.mem38 = x8Mem c.s.mem c.a.results c.it c.cnt := by
  have hcand := maskOf_eq_zero h
  have hlive (j : Nat) : c.X.liveAt j = false := by
    unfold X8.liveAt
    split
    · rename_i hj
      rw [x8Of_live]
      simp [hcand ⟨j, hj⟩]
    · rfl
  rw [mem38, x8Mem, streamMem_of_not_long fun j _ => by simp [hlive j]]
  refine storeResults_congr fun j hj => ?_
  have h8 : j < 8 := by have := hc.cnt8; omega
  simp only [X8.resultAt, h8, ↓reduceDIte, X8.result, hcand ⟨j, h8⟩]
  rfl

/-- Without live items the checks' codes are `verify_x8`'s memory. -/
theorem mem62_eq (h : c.liveMask = 0) :
    c.mem62 = x8Mem c.s.mem c.a.results c.it c.cnt := by
  have hlive (j : Nat) : c.X.liveAt j = false := by
    unfold X8.liveAt
    split
    · rename_i hj; exact maskOf_eq_zero h ⟨j, hj⟩
    · rfl
  rw [mem62, x8Mem, streamMem_of_not_long fun j _ => by simp [hlive j]]
  exact storeResults_congr fun j _ => c.code1_of_not_live (hlive j)

end Call

end

end MLIR.Firedancer.Lane.VerifyX8

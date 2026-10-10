module

public import MLIR.Run.Tactic
public import Sodium.Mlir.rotr64
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `(x >> b) | (x << (64 - b))`. -/
def rotr64.spec (x : BitVec 64) (b : BitVec 32) : BitVec 64 :=
  (x <<< (64 - b.toNat)) ||| (x >>> b.toNat)

end

/-! ## Proof -/

section Proof

/-- `rotr64` is `rotateRight` for `b < 64`. -/
public theorem rotr64.spec_eq (x : BitVec 64) (b : BitVec 32) (h : b.toNat < 64) :
    rotr64.spec x b = x.rotateRight b.toNat := by
  rw [rotr64.spec, BitVec.rotateRight_def, Nat.mod_eq_of_lt h, BitVec.or_comm]

/-- The lifted value, as the steps leave it, for `0 < b < 64`. -/
theorem rotr64.value_eq (x : BitVec 64) (b : BitVec 32) (h0 : 0 < b.toNat) (h : b.toNat < 64) :
    (if (64#32).ssubOverflow b = true then PoisonOr.poison
      else
        if (64#32).usubOverflow b = true then PoisonOr.poison
        else
          if (64#32 - b).msb = true then PoisonOr.poison
          else
            if 64 ≤ (4294967296 - b.toNat + 64) % 4294967296 % 18446744073709551616 then
              PoisonOr.poison
            else
              if b.msb = true then PoisonOr.poison
              else
                if 64 ≤ b.toNat % 18446744073709551616 then PoisonOr.poison
                else
                  PoisonOr.value
                    (x <<< ((4294967296 - b.toNat + 64) % 4294967296 % 18446744073709551616) |||
                      x >>> (b.toNat % 18446744073709551616))) =
      PoisonOr.value (rotr64.spec x b) := by
  have hb : b < 64#32 := by
    rw [BitVec.lt_def]; exact h
  have hb0 : 0#32 < b := by
    rw [BitVec.lt_def]; exact h0
  have h1 : (64#32).ssubOverflow b = false := by bv_decide
  have h2 : (64#32).usubOverflow b = false := by bv_decide
  have h3 : (64#32 - b).msb = false := by bv_decide
  have h4 : b.msb = false := by bv_decide
  have e1 : (4294967296 - b.toNat + 64) % 4294967296 % 18446744073709551616 = 64 - b.toNat := by
    omega
  have e2 : b.toNat % 18446744073709551616 = b.toNat := by omega
  simp only [h1, h2, h3, h4, e1, e2, Bool.false_eq_true, ↓reduceIte, rotr64.spec,
    show ¬64 ≤ 64 - b.toNat by omega, show ¬64 ≤ b.toNat by omega]

/-- `rotr64` returns `spec x b` for `0 < b < 64`. -/
public theorem rotr64.call_eq (x : BitVec 64) (b : BitVec 32) (s : GlobalState) (hwf : s.WF)
    (h0 : 0 < b.toNat) (h : b.toNat < 64) :
    rotr64.call (rotr64.args (.value x) (.value b)) s =
      .value (.cons (.value (rotr64.spec x b)) .nil, s) := by
  func_init
  block_init
  iterate 6 step_pure
  step_pure [rotr64.value_eq x b h0 h]
  finish_block
  rw [hS]

end Proof

end MLIR.Sodium

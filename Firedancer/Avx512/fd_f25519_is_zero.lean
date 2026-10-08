module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.R43x6
public import Firedancer.Avx512.Mlir.fd_f25519_is_zero
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_is_zero(a)`: `1` when all eight lanes are those of `0` or all those of `p`. -/
def fd_f25519_is_zero.spec (a : Wwl) : BitVec 32 :=
  if (wwl_eq a fd_r43x6_zero &&& 0xFF) = 0xFF ∨ (wwl_eq a fd_r43x6_p &&& 0xFF) = 0xFF then 1 else 0

end

/-! ## Proof -/

section Proof

/-- Bit `i` of eight packed one-bit lanes: lane `i`. -/
theorem getLsbD_packLanes_bv1 (v : Vector (BitVec 1) 8) (i : Nat) (hi : i < 8) :
    (BitVec.packLanes v).getLsbD i = v[i].getLsbD 0 := by
  have h := congrArg (·.getLsbD 0) (BitVec.extractLsb'_packLanes v i (by omega))
  simpa using h

/-- A one-bit lane is its bit. -/
theorem bv1_eq_iff (x : BitVec 1) (b : Bool) : x = BitVec.ofBool b ↔ x.getLsbD 0 = b := by
  constructor
  · rintro rfl; cases b <;> rfl
  · intro h; apply BitVec.eq_of_getLsbD_eq; intro i hi
    obtain rfl : i = 0 := by omega
    cases b <;> simpa using h

/-- Eight packed one-bit lanes are all clear exactly when every lane is. -/
theorem packLanes_eq_iff_bv1 (v : Vector (BitVec 1) 8) (b : Bool) :
    BitVec.packLanes v = (if b then BitVec.allOnes 8 else 0#8) ↔
      ∀ i (hi : i < 8), v[i] = BitVec.ofBool b := by
  constructor
  · intro h i hi
    rw [bv1_eq_iff, ← getLsbD_packLanes_bv1 v i hi, h]
    cases b <;> simp
    revert hi; revert i; decide
  · intro h; apply BitVec.eq_of_getLsbD_eq; intro i hi
    rw [getLsbD_packLanes_bv1 v i hi, (bv1_eq_iff _ _).mp (h i hi)]
    cases b <;> simp
    revert hi; revert i; decide

/-- Eight packed lane tests are all clear exactly when no lane fails. -/
theorem packLanes_ofFn_eq_zero (f : Fin 8 → Bool) :
    BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i)) = 0#8 ↔ ∀ i, f i = false := by
  have := packLanes_eq_iff_bv1 (Vector.ofFn fun i => BitVec.ofBool (f i)) false
  simp only [Bool.false_eq_true, ↓reduceIte] at this
  rw [this]
  constructor
  · intro h i
    have := h i.1 i.2
    simp only [Fin.eta, Vector.getElem_ofFn] at this
    revert this; cases f i <;> decide
  · intro h i hi
    simp [h]

/-- Eight packed lane tests, widened and masked to their byte, are all set exactly when every lane
passes. -/
theorem packLanes_ofFn_and_255 (f : Fin 8 → Bool) :
    ((BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i))).setWidth 32 &&& 255 = 255) ↔
      ∀ i, f i = true := by
  have := packLanes_eq_iff_bv1 (Vector.ofFn fun i => BitVec.ofBool (f i)) true
  simp only [↓reduceIte] at this
  have hb : ∀ p : BitVec 8, (p.setWidth 32 &&& 255 = 255) ↔ p = BitVec.allOnes 8 := by
    intro p; bv_decide
  rw [hb, this]
  constructor
  · intro h i
    have := h i.1 i.2
    simp only [Fin.eta, Vector.getElem_ofFn] at this
    revert this; cases f i <;> decide
  · intro h i hi
    simp [h]

/-- The compiled tests: `1` when every lane is `0`, else when every lane is `p`'s. -/
theorem fd_f25519_is_zero.spec_eq (x : Wwl) :
    BitVec.setWidth 32
        (if
            BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
              BitVec.ofBool (x[i] != 0#64)) == 0#8) = 1#1 then 1#1
        else
          BitVec.ofBool (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
            BitVec.ofBool (x[i] != fd_r43x6_p[i])) == 0#8)) =
      fd_f25519_is_zero.spec x := by
  have h0 := packLanes_ofFn_eq_zero fun i => x[i] != 0#64
  have hp := packLanes_ofFn_eq_zero fun i => x[i] != fd_r43x6_p[i]
  have e0 := packLanes_ofFn_and_255 fun i => x[i] == fd_r43x6_zero[i]
  have ep := packLanes_ofFn_and_255 fun i => x[i] == fd_r43x6_p[i]
  simp only [bne_eq_false_iff_eq, beq_iff_eq, fd_r43x6_zero, wwl_zero] at h0 hp e0 ep
  have a0 : (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[i] != 0#64)) == 0#8) =
      decide (∀ i : Fin 8, x[i] = 0#64) := by
    rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, h0]
  have ap : (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
      BitVec.ofBool (x[i] != fd_r43x6_p[i])) == 0#8) =
        decide (∀ i : Fin 8, x[i] = fd_r43x6_p[i]) := by
    rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, hp]
  rw [a0, ap, fd_f25519_is_zero.spec, wwl_eq, wwl_eq]
  simp only [fd_r43x6_zero, wwl_zero] at ⊢
  simp only [e0, ep]
  have hrep : (∀ i : Fin 8, x[i] = (Vector.replicate 8 0)[i]) ↔ ∀ i : Fin 8, x[i] = 0#64 := by
    simp
  simp only [hrep]
  by_cases hP : ∀ i : Fin 8, x[i] = 0#64 <;> by_cases hQ : ∀ i : Fin 8, x[i] = fd_r43x6_p[i] <;>
    simp only [hP, hQ] <;> decide

/-- `fd_f25519_is_zero` returns `spec` of the lanes at `a` and leaves the state as it is. -/
public theorem fd_f25519_is_zero.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) :
    fd_f25519_is_zero.call (fd_f25519_is_zero.args (.value a)) s =
      .value (.cons (.value (fd_f25519_is_zero.spec (s.mem.readVec a))) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  step_load with x
  step_pure with e0
  step_pure with m0
  step_pure with z0
  step_pure with ep
  step_pure with mp
  step_pure with zp
  step_pure with r
  step_pure with r32
  finish_block
  clear hArgs hE
  subst_vars
  rw [← fd_f25519_is_zero.spec_eq]
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512

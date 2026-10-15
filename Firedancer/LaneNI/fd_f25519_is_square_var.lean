module

public import Firedancer.LaneNI.fd_f25519_jacobi_var
public import Firedancer.LaneNI.fd_f25519_sqrt_ratio
public import Firedancer.LaneNI.fd_f25519_one
public import Firedancer.LaneNI.fd_f25519_tobytes
public import Firedancer.LaneNI.Mlir.fd_f25519_is_square_var
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.LaneNI

open MLIR.Firedancer.Lane Firedancer.Lane.Jacobi Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

namespace fd_f25519_is_square_var

/-- `x[5]`: the four little-endian words `a0 … a3` of the canonical bytes as 62-bit limbs. -/
def limbs (a0 a1 a2 a3 : BitVec 64) : Vector (BitVec 64) 5 :=
  #v[a0 &&& m62, (a0 >>> 62 ||| a1 <<< 2) &&& m62, (a1 >>> 60 ||| a2 <<< 4) &&& m62,
    (a2 >>> 58 ||| a3 <<< 6) &&& m62, a3 >>> 56]

/-- `fd_f25519_is_square_var( a )`: `1` for zero, else the Jacobi symbol's sign of the canonical
limbs, or `sqrt_ratio( r, a, 1 )`'s flag if it did not converge. -/
def spec (a : Wwl) : BitVec 32 :=
  let t := tobytes a
  let a0 := t.extractLsb' 0 64
  let a1 := t.extractLsb' 64 64
  let a2 := t.extractLsb' 128 64
  let a3 := t.extractLsb' 192 64
  if a0 ||| a1 ||| a2 ||| a3 = 0 then 1
  else
    let j := jacobi (limbs a0 a1 a2 a3)
    if j = 0 then (fd_f25519_sqrt_ratio.spec a fd_f25519_one.vec).2
    else if (0#32).slt j then 1 else 0

/-- The blocks `fd_f25519_is_square_var( a )` and its callees allocate: 3 slots, then 4 for
`jacobi_var`, then 18 for `sqrt_ratio`. -/
def blocks (a : Wwl) : Nat :=
  let t := tobytes a
  let a0 := t.extractLsb' 0 64
  let a1 := t.extractLsb' 64 64
  let a2 := t.extractLsb' 128 64
  let a3 := t.extractLsb' 192 64
  if a0 ||| a1 ||| a2 ||| a3 = 0 then 3
  else if jacobi (limbs a0 a1 a2 a3) = 0 then 25 else 7

end fd_f25519_is_square_var

end

/-! ## Proof -/

section Proof

open Firedancer.LaneNI.Mlir

private theorem fshl2 (a b : BitVec 64) :
    BitVec.extractLsb' 64 64 ((b ++ a) <<< 2) = a >>> 62 ||| b <<< 2 := by
  bv_decide

private theorem fshl4 (a b : BitVec 64) :
    BitVec.extractLsb' 64 64 ((b ++ a) <<< 4) = a >>> 60 ||| b <<< 4 := by
  bv_decide

private theorem fshl6 (a b : BitVec 64) :
    BitVec.extractLsb' 64 64 ((b ++ a) <<< 6) = a >>> 58 ||| b <<< 6 := by
  bv_decide

private theorem lo62 (x : BitVec 64) : x &&& m62 < 4611686018427387904#64 := by
  bv_decide

private theorem or_zero_iff (a b c d : BitVec 64) :
    a ||| c ||| b ||| d = 0#64 ↔ a ||| b ||| c ||| d = 0 := by
  constructor <;> intro h <;> bv_decide

/-- The words `fd_ulong_load_8_fast` reads from the canonical bytes. -/
private theorem words (T : BitVec 256) :
    BitVec.setWidth 64 T = T.extractLsb' 0 64 ∧
      (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (T.extractLsb' 64 128))[0] =
        T.extractLsb' 64 64 ∧
      (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (T.extractLsb' 64 128))[1] =
        T.extractLsb' 128 64 ∧
      (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (T.extractLsb' 128 128))[0] =
        T.extractLsb' 128 64 ∧
      (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (T.extractLsb' 128 128))[1] =
        T.extractLsb' 192 64 := by
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- `fd_f25519_is_square_var( a )` returns `spec` of the element at `a`, the memory as it was; the
counter moves on by the `blocks` it and its callees allocate. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_is_square_var.call_eq (a : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Firedancer.LaneNI.Mlir.fd_f25519_is_square_var.globals)
    (ha : Fits s.mem a 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_is_square_var.call
        (Firedancer.LaneNI.Mlir.fd_f25519_is_square_var.args (.value a)) s =
      .value (.cons (.value (fd_f25519_is_square_var.spec (s.mem.readVec a))) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + fd_f25519_is_square_var.blocks (s.mem.readVec a)⟩,
          mem := s.mem }) := by
  obtain ⟨X, hX⟩ : ∃ X, s.mem.readAt a 512 = X := ⟨_, rfl⟩
  have hRV : s.mem.readVec a = Vector.ofFn fun i => Ty.extractVecElem 8 64 i X := by
    rw [← hX]; rfl
  rw [hRV]
  func_init
  block_init
  iterate 10 step_pure
  step_addressof Firedancer.LaneNI.Mlir.fd_f25519_one.value_eq with one
  iterate 3 step_alloca
  step_lifetime
  step_load with A
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54.call_eq
  step_load with a0
  iterate 2 step_pure
  step_load with w1
  step_load with w2
  have hw := words (tobytes A)
  rw [← hw1, ← hw2, ← ha0] at hw
  have hz : a0 ||| w2[0] ||| w1[0] ||| w2[1] = 0#64 ↔
      (tobytes A).extractLsb' 0 64 ||| (tobytes A).extractLsb' 64 64 |||
        (tobytes A).extractLsb' 128 64 ||| (tobytes A).extractLsb' 192 64 = 0 := by
    rw [hw.1, hw.2.1, hw.2.2.2.1, hw.2.2.2.2]
    exact or_zero_iff _ _ _ _
  iterate 7 step_pure
  finish_block
  · block_init
    step_lifetime
    finish_block
    subst hS
    erase_frame
    have h0 := hz.1 hbr
    simp only [fd_f25519_is_square_var.spec, fd_f25519_is_square_var.blocks, h0,
      ↓reduceIte]
    simp
  · have hnz := fun q => hbr (hz.2 q)
    block_init
    step_lifetime
    iterate 7 step_pure
    have hr256 : Room S.mem v12 256 := hroom_v12.mono (by omega)
    step_store
    step_pure
    step_pure
    step_store
    have hL : limbsAt S.mem v12 = fd_f25519_is_square_var.limbs a0 w1[0] w2[0] w2[1] := by
      rw [limbsAt_of_256 hv12_bounds (by simp [BitVec.uaddOverflow, hv12_off]) hread_v12
        hread_v12_32]
      rw [(extract_packLanes4 _).1, (extract_packLanes4 _).2.1, (extract_packLanes4 _).2.2.1,
        (extract_packLanes4 _).2.2.2]
      simp only [Vector.getElem_ofFn, fshl2, fshl4, fshl6, fd_f25519_is_square_var.limbs,
        hw.2.2.1.trans hw.2.2.2.1.symm]
      rfl
    have hf320 : Fits S.mem v12 320 :=
      Fits.append (by simp [BitVec.uaddOverflow, hv12_off]) (by decide) rfl hfits_v12 hfits_v12_32
    have hx0 : S.mem.readAt v12 64 < 4611686018427387904#64 := by
      have := congrArg (·[0]) hL
      simp only [limbsAt, Vector.getElem_ofFn, fd_f25519_is_square_var.limbs] at this
      simp only [Nat.mul_zero, Firedancer.Lane.Jacobi.add_zero] at this
      rw [this]
      exact lo62 _
    step_call using (Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var.call_eq (hx := hf320)
      (hxo := by simp [BitVec.uaddOverflow, hv12_off]) (hx0 := hx0)) with j
    have hL2 := hL
    rw [hS] at hL2
    rw [hL2, hw.1, hw.2.1, hw.2.2.2.1, hw.2.2.2.2] at hj
    step_pure
    finish_block
    · -- `jac == 0`: `sqrt_ratio( r, a, 1 )`
      block_init
      step_lifetime
      have hRo : S.mem.readVec one = fd_f25519_one.vec :=
        Firedancer.LaneNI.Mlir.fd_f25519_one.readVec hread_one
      have hRa : S.mem.readVec a = A := by
        rw [hA]; simp only [MemoryState.readVec, hX]
      step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio.call_eq with f
      step_lifetime
      finish_block
      block_init
      step_lifetime
      finish_block
      block_init
      step_lifetime
      finish_block
      subst hS
      erase_frame
      subst hf
      have hb0 : j = 0 := hbr
      simp only [fd_f25519_is_square_var.spec, fd_f25519_is_square_var.blocks]
      rw [ite_eq_right_of_eq_false _ _ (eq_false hnz), ite_eq_right_of_eq_false _ _ (eq_false hnz),
        ← hj, ite_eq_left_of_eq_true _ _ (eq_true hb0),
        ite_eq_left_of_eq_true _ _ (eq_true hb0)]
      simp
    · block_init
      iterate 2 step_pure
      finish_block
      block_init
      step_lifetime
      finish_block
      block_init
      step_lifetime
      finish_block
      subst hS
      erase_frame
      have hb0 : ¬j = 0 := hbr
      simp only [fd_f25519_is_square_var.spec, fd_f25519_is_square_var.blocks]
      rw [ite_eq_right_of_eq_false _ _ (eq_false hnz), ite_eq_right_of_eq_false _ _ (eq_false hnz),
        ← hj, ite_eq_right_of_eq_false _ _ (eq_false hb0),
        ite_eq_right_of_eq_false _ _ (eq_false hb0)]
      by_cases hs : (0#32).slt j <;> simp [hs]

end Proof

end MLIR.Firedancer.LaneNI

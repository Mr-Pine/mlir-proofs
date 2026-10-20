module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.Common.LimbBits
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_is_zero
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Verify

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_limbs_is_zero( c )`: `1` when the five limbs are all zero, else `0`. -/
def fd_r52x5_limbs_is_zero.spec (c : Fin 5 → BitVec 64) : BitVec 32 :=
  if (c 0 ||| c 1 ||| c 2 ||| c 3 ||| c 4) = 0 then 1 else 0

end

/-! ## Proof -/

section Proof

/-- Limbs `0 … 3` of known limbs read as 256 bits. -/
theorem MemoryState.readAt_limbs0123 {m : MemoryState} (hf : m.LimbsFit p) :
    m.readAt p 256 = BitVec.packLanes #v[m.readLimbs p 0, m.readLimbs p 1, m.readLimbs p 2,
      m.readLimbs p 3] := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    have := hf.1
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega
  have hf256 : InBounds m p 256 := hf.fits.inBounds.mono (by omega)
  have e0 := MemoryState.readAt_of_readAt_le (m := m) (p := p) (v := 256) (w := 64) (by decide) rfl
  have e1 := MemoryState.readAt_add_of_readAt hf256 (hov 8 (by omega)) (w := 64) (by decide) rfl
  have e2 := MemoryState.readAt_add_of_readAt hf256 (hov 16 (by omega)) (w := 64) (by decide) rfl
  have e3 := MemoryState.readAt_add_of_readAt hf256 (hov 24 (by omega)) (w := 64) (by decide) rfl
  simp only [BitVec.reduceToNat, Nat.reduceMul] at e1 e2 e3
  rw [BitVec.packLanes_four]
  change
    _ =
      (m.readAt (p.add 24#64) 64 ++
            (m.readAt (p.add 16#64) 64 ++ (m.readAt (p.add 8#64) 64 ++ m.readAt p 64))).cast
        _
  rw [e0, e1, e2, e3]
  generalize m.readAt p 256 = x
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_cast, BitVec.getLsbD_append, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_setWidth]
  grind

/-- The compiled test on the limbs at `c`: the OR of lanes `0 … 3` and limb `4`,
`zext (icmp eq · 0)`. -/
theorem fd_r52x5_limbs_is_zero.ofBool (m : MemoryState) (c : Pointer) :
    (BitVec.ofBool (#v[m.readLimbs c 0, m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3][0] |||
          #v[m.readLimbs c 0, m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3][1] |||
          #v[m.readLimbs c 0, m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3][2] |||
          #v[m.readLimbs c 0, m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3][3] |||
          m.readAt (c.add 32#64) 64 == 0#64)).setWidth 32 =
      fd_r52x5_limbs_is_zero.spec (m.readLimbs c) := by
  unfold fd_r52x5_limbs_is_zero.spec
  change (BitVec.ofBool (m.readLimbs c 0 ||| m.readLimbs c 1 ||| m.readLimbs c 2 |||
    m.readLimbs c 3 ||| m.readLimbs c 4 == 0#64)).setWidth 32 = _
  generalize m.readLimbs c 0 = x0
  generalize m.readLimbs c 1 = x1
  generalize m.readLimbs c 2 = x2
  generalize m.readLimbs c 3 = x3
  generalize m.readLimbs c 4 = x4
  split <;> bv_decide

/-- `fd_r52x5_limbs_is_zero( c )` returns `spec` of the limbs at `c`. -/
public theorem fd_r52x5_limbs_is_zero.call_eq (c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hc : s.mem.LimbsFit c) :
    fd_r52x5_limbs_is_zero.call (fd_r52x5_limbs_is_zero.args (.value c)) s =
      .value (.cons (.value (fd_r52x5_limbs_is_zero.spec (s.mem.readLimbs c))) .nil, s) := by
  have hf256 : Fits s.mem c 256 := hc.fits.mono (by omega)
  have hf4 := hc.2.2.2.2.2
  func_init
  block_init
  step_pure
  step_load
  step_pure
  step_load
  iterate 4 step_pure
  finish_block
  subst_vars
  rw [MemoryState.readAt_limbs0123 hc]
  simp only [Ty.extractVecElem_packLanes]
  erw [fd_r52x5_limbs_is_zero.ofBool]

end Proof

end MLIR.Firedancer.Crc.Verify

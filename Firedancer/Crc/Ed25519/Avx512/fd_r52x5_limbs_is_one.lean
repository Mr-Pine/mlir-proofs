module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.LimbBits
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_one
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_limbs_is_one( c )`: `1` when the limbs are `(1, 0, 0, 0, 0)`, else `0`. -/
def fd_r52x5_limbs_is_one.spec (c : Fin 5 → BitVec 64) : BitVec 32 :=
  if ((c 0 ^^^ 1) ||| c 1 ||| c 2 ||| c 3 ||| c 4) = 0 then 1 else 0

end

/-! ## Proof -/

section Proof

/-- Limbs `1 … 4` of known limbs read as 256 bits. -/
theorem MemoryState.readAt_limbs1234 {m : MemoryState} (hf : m.LimbsFit p) :
    m.readAt (p.add 8#64) 256 = BitVec.packLanes #v[m.readLimbs p 1, m.readLimbs p 2,
      m.readLimbs p 3, m.readLimbs p 4] := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    have := hf.1
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega
  have hf320 : InBounds m p 320 := hf.fits.inBounds
  have e1 := MemoryState.readAt_add_of_readAt hf320 (hov 8 (by omega)) (w := 256) (by decide) rfl
  have f1 := MemoryState.readAt_add_of_readAt hf320 (hov 8 (by omega)) (w := 64) (by decide) rfl
  have f2 := MemoryState.readAt_add_of_readAt hf320 (hov 16 (by omega)) (w := 64) (by decide) rfl
  have f3 := MemoryState.readAt_add_of_readAt hf320 (hov 24 (by omega)) (w := 64) (by decide) rfl
  have f4 := MemoryState.readAt_add_of_readAt hf320 (hov 32 (by omega)) (w := 64) (by decide) rfl
  simp only [BitVec.reduceToNat, Nat.reduceMul] at e1 f1 f2 f3 f4
  rw [BitVec.packLanes_four]
  change
    _ =
      (m.readAt (p.add 32#64) 64 ++
            (m.readAt (p.add 24#64) 64 ++ (m.readAt (p.add 16#64) 64 ++ m.readAt (p.add 8#64) 64))).cast
        _
  rw [e1, f1, f2, f3, f4]
  generalize m.readAt p 320 = x
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_cast, BitVec.getLsbD_append, BitVec.getLsbD_extractLsb']
  grind

/-- The compiled test on the limbs at `c`: limb `0` xor `1`, OR the lanes of limbs `1 … 4`,
`zext (icmp eq · 0)`. -/
theorem fd_r52x5_limbs_is_one.ofBool (m : MemoryState) (c : Pointer) :
    (BitVec.ofBool (#v[m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3, m.readLimbs c 4][0] |||
          #v[m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3, m.readLimbs c 4][1] |||
          #v[m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3, m.readLimbs c 4][2] |||
          #v[m.readLimbs c 1, m.readLimbs c 2, m.readLimbs c 3, m.readLimbs c 4][3] |||
          (m.readAt c 64 ^^^ 1#64) == 0#64)).setWidth 32 =
      fd_r52x5_limbs_is_one.spec (m.readLimbs c) := by
  unfold fd_r52x5_limbs_is_one.spec
  change (BitVec.ofBool (m.readLimbs c 1 ||| m.readLimbs c 2 ||| m.readLimbs c 3 |||
    m.readLimbs c 4 ||| (m.readLimbs c 0 ^^^ 1#64) == 0#64)).setWidth 32 = _
  generalize m.readLimbs c 0 = x0
  generalize m.readLimbs c 1 = x1
  generalize m.readLimbs c 2 = x2
  generalize m.readLimbs c 3 = x3
  generalize m.readLimbs c 4 = x4
  split <;> bv_decide

/-- `fd_r52x5_limbs_is_one( c )` returns `spec` of the limbs at `c`. -/
public theorem fd_r52x5_limbs_is_one.call_eq (c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hc : s.mem.LimbsFit c) :
    fd_r52x5_limbs_is_one.call (fd_r52x5_limbs_is_one.args (.value c)) s =
      .value (.cons (.value (fd_r52x5_limbs_is_one.spec (s.mem.readLimbs c))) .nil, s) := by
  have hf0 := hc.2.1
  have hf8 : Fits s.mem (c.add 8#64) 256 :=
    Fits.add_of_le (Pointer.not_uaddOverflow_of_limbs hc.1 (by decide)) (by decide) hc.fits
  func_init
  block_init
  iterate 2 step_pure
  step_load
  step_pure
  step_pure
  step_load
  iterate 4 step_pure
  finish_block
  subst_vars
  rw [MemoryState.readAt_limbs1234 hc]
  simp only [Ty.extractVecElem_packLanes]
  erw [fd_r52x5_limbs_is_one.ofBool]

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512

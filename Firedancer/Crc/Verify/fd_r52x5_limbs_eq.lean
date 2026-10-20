module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.Common.LimbBits
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_eq
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Verify

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_limbs_eq( a, b )`: `1` when the five limbs agree, else `0`. -/
def fd_r52x5_limbs_eq.spec (a b : Fin 5 → BitVec 64) : BitVec 32 :=
  if a 0 = b 0 ∧ a 1 = b 1 ∧ a 2 = b 2 ∧ a 3 = b 3 ∧ a 4 = b 4 then 1 else 0

end

/-! ## Proof -/

section Proof

/-- Limbs `0 … 3` of known limbs read as 256 bits. -/
private theorem readAt_limbs0123 {m : MemoryState} (hf : m.LimbsFit p) :
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

/-- A `<4 x i1>` mask as an `i4`: zero when every lane is false. -/
theorem packLanes_ofBool4_eq_zero (c0 c1 c2 c3 : Bool) (h : 1 * 4 = 4) :
    (BitVec.cast h (BitVec.packLanes (#v[BitVec.ofBool c0, BitVec.ofBool c1, BitVec.ofBool c2,
      BitVec.ofBool c3] : Vector (BitVec 1) 4)) == 0#4) = (!c0 && !c1 && !c2 && !c3) := by
  cases c0 <;> cases c1 <;> cases c2 <;> cases c3 <;>
    simp [BitVec.packLanes, Vector.tail]

/-- `fd_r52x5_limbs_eq( a, b )` returns `spec` of the limbs at `a` and `b`. -/
public theorem fd_r52x5_limbs_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    fd_r52x5_limbs_eq.call (fd_r52x5_limbs_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_r52x5_limbs_eq.spec (s.mem.readLimbs a) (s.mem.readLimbs b))) .nil, s) := by
  have ha256 : Fits s.mem a 256 := ha.fits.mono (by omega)
  have hb256 : Fits s.mem b 256 := hb.fits.mono (by omega)
  have ha4 := ha.2.2.2.2.2
  have hb4 := hb.2.2.2.2.2
  func_init
  block_init
  step_pure
  step_pure
  step_load
  step_pure
  step_load
  step_load
  step_load
  iterate 6 step_pure
  finish_block
  subst_vars
  rw [readAt_limbs0123 ha, readAt_limbs0123 hb]
  simp only [Ty.extractVecElem_packLanes]
  have e : ∀ x0 x1 x2 x3 y0 y1 y2 y3 : BitVec 64,
      (Vector.ofFn fun i : Fin 4 => BitVec.ofBool (#v[x0, x1, x2, x3][i] != #v[y0, y1, y2, y3][i])) =
        #v[BitVec.ofBool (x0 != y0), BitVec.ofBool (x1 != y1), BitVec.ofBool (x2 != y2),
          BitVec.ofBool (x3 != y3)] := by
    intro x0 x1 x2 x3 y0 y1 y2 y3; ext i hi
    obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
    all_goals rfl
  rw [e]
  erw [packLanes_ofBool4_eq_zero]
  congr 3
  unfold fd_r52x5_limbs_eq.spec
  rw [show S.mem.readAt (a.add 32#64) 64 = S.mem.readLimbs a 4 from rfl,
    show S.mem.readAt (b.add 32#64) 64 = S.mem.readLimbs b 4 from rfl]
  generalize S.mem.readLimbs a 0 = x0
  generalize S.mem.readLimbs a 1 = x1
  generalize S.mem.readLimbs a 2 = x2
  generalize S.mem.readLimbs a 3 = x3
  generalize S.mem.readLimbs b 0 = y0
  generalize S.mem.readLimbs b 1 = y1
  generalize S.mem.readLimbs b 2 = y2
  generalize S.mem.readLimbs b 3 = y3
  generalize S.mem.readLimbs a 4 = x4
  generalize S.mem.readLimbs b 4 = y4
  by_cases h0 : x0 = y0 <;> by_cases h1 : x1 = y1 <;> by_cases h2 : x2 = y2 <;>
    by_cases h3 : x3 = y3 <;> by_cases h4 : x4 = y4 <;> simp [h0, h1, h2, h3, h4, bne, beq_eq_false_iff_ne.mpr]

end Proof

end MLIR.Firedancer.Crc.Verify

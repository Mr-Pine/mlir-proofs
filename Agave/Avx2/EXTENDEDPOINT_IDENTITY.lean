module

public import MLIR.Run.Tactic
public import Agave.Avx2.BASEPOINT_ODD_LOOKUP_TABLE
public import Agave.Avx2.Mlir.EXTENDEDPOINT_IDENTITY

namespace MLIR.Agave.Avx2

/-! ## Specification -/

@[expose] public section

/-- `EXTENDEDPOINT_IDENTITY`'s registers: `(0, 1, 1, 0)`, register 0's lanes
`(0, 1, 0, 0, 1, 0, 0, 0)`, the others zero. -/
def EXTENDEDPOINT_IDENTITY.point : Fe2625x4 :=
  ![#v[0, 1, 0, 0, 1, 0, 0, 0], #v[0, 0, 0, 0, 0, 0, 0, 0], #v[0, 0, 0, 0, 0, 0, 0, 0],
    #v[0, 0, 0, 0, 0, 0, 0, 0], #v[0, 0, 0, 0, 0, 0, 0, 0]]

end

/-! ## Proof -/

/-- The global's value: its literal. -/
public theorem EXTENDEDPOINT_IDENTITY.value_eq (s : GlobalState) :
    EXTENDEDPOINT_IDENTITY.value s = .value (Ty.wrap EXTENDEDPOINT_IDENTITY.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The literal's bits: bytes 4 and 16 one, the rest zero. -/
public theorem EXTENDEDPOINT_IDENTITY.flatBits_lit {hw : (Ty.array 160 (.bv 8)).width = 1280} :
    Ty.flatBits (t := .array 160 (.bv 8)) EXTENDEDPOINT_IDENTITY.lit (hw := hw) =
      BitVec.ofNat 1280 (2 ^ 32 + 2 ^ 128) := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.toNat_flattenRaw, BitVec.toNat_ofNat]
  decide +kernel

/-- Those bits as registers: the identity's. -/
public theorem EXTENDEDPOINT_IDENTITY.ofBits_eq :
    Fe2625x4.ofBits (BitVec.ofNat 1280 (2 ^ 32 + 2 ^ 128)) = EXTENDEDPOINT_IDENTITY.point := by
  funext i
  fin_cases i <;> decide +kernel

/-- The global's block, read as registers: the identity. -/
public theorem EXTENDEDPOINT_IDENTITY.readFe4x {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 160 (.bv 8)).width = 1280} (hb : InBounds m p 1280)
    (ho : p.offset.toNat + 128 < 2 ^ 64)
    (h :
      m.readAt p 1280 =
        Ty.flatBits (t := .array 160 (.bv 8)) EXTENDEDPOINT_IDENTITY.lit (hw := hw)) :
    m.readFe4x p = EXTENDEDPOINT_IDENTITY.point := by
  rw [← EXTENDEDPOINT_IDENTITY.ofBits_eq]
  exact
    MemoryState.readFe4x_of_readAt hb ho
      (h.trans (EXTENDEDPOINT_IDENTITY.flatBits_lit.trans (fe4xBits_ofBits _).symm))

end MLIR.Agave.Avx2

module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.Mlir.BASEPOINT_ODD_LOOKUP_TABLE

namespace MLIR.Agave.Avx2

/-! ## Specification -/

@[expose] public section

/-- `BASEPOINT_ODD_LOOKUP_TABLE`'s bits, byte 0 lowest. -/
noncomputable def BASEPOINT_ODD_LOOKUP_TABLE.bits : BitVec 81920 :=
  Ty.flatBits (t := .array 10240 (.bv 8)) BASEPOINT_ODD_LOOKUP_TABLE.lit (hw := rfl)

/-- Entry `j` of `BASEPOINT_ODD_LOOKUP_TABLE`, a `CachedPoint`: its bytes `160 j` to
`160 j + 159`. -/
noncomputable def BASEPOINT_ODD_LOOKUP_TABLE.point (j : Nat) : Fe2625x4 :=
  Fe2625x4.ofBits (BASEPOINT_ODD_LOOKUP_TABLE.bits.extractLsb' (1280 * j) 1280)

end

/-! ## Proof -/

/-- The global's value: its literal. -/
public theorem BASEPOINT_ODD_LOOKUP_TABLE.value_eq (s : GlobalState) :
    BASEPOINT_ODD_LOOKUP_TABLE.value s = .value (Ty.wrap BASEPOINT_ODD_LOOKUP_TABLE.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

end MLIR.Agave.Avx2

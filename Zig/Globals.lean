module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Zig.Mlir.Fe_zero
public import Zig.Mlir.Fe_one
public import Zig.Mlir.Fe_edwards25519d
public import Zig.Mlir.Fe_edwards25519d2
public import Zig.Mlir.Fe_sqrtm1

/-! The field-element globals: their initializers' values, and their limbs read back from the block
`addressof` gives them. -/

namespace LeanMLIR.RIR.Zig

/-- The limbs of a field element global's block, read back: its initializer's limbs. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readLimbs_of_readAt_fe {m : MemoryState}
    {p : Pointer} {v : Vector (BitVec 64) 5} {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320}
    (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits (t := .struct [.array 5 (.bv 64)]) v (hw := hw)) :
    m.readLimbs p = fun i => v[i] := by
  rw [Ty.flatBits_eq] at h
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;>
    simp (disch := decide) only [BitVec.extractLsb'_cast, Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_struct_singleton, Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.padding, Ty.align]

public theorem Fe_zero.value_eq (s : GlobalState) :
    Fe_zero.value s = .value (Ty.wrap Fe_zero.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_one.value_eq (s : GlobalState) :
    Fe_one.value s = .value (Ty.wrap Fe_one.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_edwards25519d.value_eq (s : GlobalState) :
    Fe_edwards25519d.value s = .value (Ty.wrap Fe_edwards25519d.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_edwards25519d2.value_eq (s : GlobalState) :
    Fe_edwards25519d2.value s = .value (Ty.wrap Fe_edwards25519d2.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_sqrtm1.value_eq (s : GlobalState) :
    Fe_sqrtm1.value s = .value (Ty.wrap Fe_sqrtm1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

end LeanMLIR.RIR.Zig

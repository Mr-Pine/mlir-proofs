module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Globals
public import Boringssl.Mlir.d
public import Boringssl.Mlir.d2
public import Boringssl.Mlir.sqrtm1
import Mathlib.Tactic.FinCases

/-! The field-element globals `d`, `d2` and `sqrtm1`: their initializers' values, and their limbs
read back from the block `addressof` gives them, Firedancer's `fd_f25519_d`, `fd_f25519_k` and
`fd_f25519_sqrtm1`. -/

namespace MLIR

/-- A `struct fe`'s limbs, read from a block holding its bits. -/
public theorem MemoryState.readLimbs_of_readAt_flatBits {m : MemoryState} {p : Pointer}
    {v : Vector (BitVec 64) 5} {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320}
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

namespace Boringssl

public theorem d.value_eq (s : GlobalState) : d.value s = .value (Ty.wrap d.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `d`'s limbs, at the block `addressof` stores them in. -/
public theorem d.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits d.lit (hw := hw)) :
    m.readLimbs p = Firedancer.Ref.fd_f25519_d.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flatBits hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem d2.value_eq (s : GlobalState) : d2.value s = .value (Ty.wrap d2.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `d2`'s limbs (`2d`), at the block `addressof` stores them in. -/
public theorem d2.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits d2.lit (hw := hw)) :
    m.readLimbs p = Firedancer.Ref.fd_f25519_k.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flatBits hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem sqrtm1.value_eq (s : GlobalState) :
    sqrtm1.value s = .value (Ty.wrap sqrtm1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `sqrtm1`'s limbs, at the block `addressof` stores them in. -/
public theorem sqrtm1.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits sqrtm1.lit (hw := hw)) :
    m.readLimbs p = Firedancer.Ref.fd_f25519_sqrtm1.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flatBits hf ho h]
  funext i
  fin_cases i <;> rfl

end Boringssl

end MLIR

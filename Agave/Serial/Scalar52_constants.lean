module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Agave.Math.Scalar
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_40
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_41
import Mathlib.Tactic.FinCases
import all MLIR.Ty

/-! The `Scalar52` constants `R` and `RR`, as the globals `from_bytes_wide` passes to
`montgomery_mul`: their initializers' values and their limbs read back. -/

namespace MLIR.Agave.Serial

public theorem anon_042b818bc72209407b52bd0e4d6c8368_41.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_41.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_41.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `constants::R`'s limbs, in the global's block. -/
public theorem anon_042b818bc72209407b52bd0e4d6c8368_41.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 40 (.bv 8)).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_41.lit (hw := hw)) :
    m.readLimbs p = Scalar52.R := by
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;> clear h hf ho <;> decide +kernel +revert

public theorem anon_042b818bc72209407b52bd0e4d6c8368_40.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_40.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_40.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `constants::RR`'s limbs, in the global's block. -/
public theorem anon_042b818bc72209407b52bd0e4d6c8368_40.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 40 (.bv 8)).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_40.lit (hw := hw)) :
    m.readLimbs p = Scalar52.RR := by
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;> clear h hf ho <;> decide +kernel +revert

end MLIR.Agave.Serial

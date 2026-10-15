module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.Wwl
public import Firedancer.LaneNI.Mlir.fd_f25519_one
public import Firedancer.LaneNI.Mlir.fd_f25519_one_86

/-! `fd_f25519_one`: its value, and its lanes read back from the block `addressof` gives it. -/

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

@[expose] public section

/-- The lanes of `fd_f25519_one`, 1. -/
def fd_f25519_one.vec : Wwl :=
  wwl 1 0 0 0 0 0 0 0

end

/-- `fd_f25519_one`'s initializer gives its folded constant, leaving the state. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_one.value_eq (s : GlobalState) :
    Firedancer.LaneNI.Mlir.fd_f25519_one.value s =
      .value (Ty.wrap Firedancer.LaneNI.Mlir.fd_f25519_one.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_one_86`'s initializer gives its folded constant, leaving the state. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_one_86.value_eq (s : GlobalState) :
    Firedancer.LaneNI.Mlir.fd_f25519_one_86.value s =
      .value (Ty.wrap Firedancer.LaneNI.Mlir.fd_f25519_one_86.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_one`'s lanes, at the block `addressof` stores them in. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_one.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits Firedancer.LaneNI.Mlir.fd_f25519_one.lit (hw := hw)) :
    m.readVec p = fd_f25519_one.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_f25519_one_86`'s lanes, at the block `addressof` stores them in. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_one_86.readVec {m : MemoryState}
    {p : Pointer} {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits Firedancer.LaneNI.Mlir.fd_f25519_one_86.lit (hw := hw)) :
    m.readVec p = fd_f25519_one.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

end MLIR.Firedancer.LaneNI

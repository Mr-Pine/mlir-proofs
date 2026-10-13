module

public import Firedancer.Common.Point

/-! Writability and the globals table through the object stores of `Firedancer.Common.Point`;
staged here for that module. -/

namespace MLIR

@[expose] public section

/-- A field element's store keeps every block's writability. -/
theorem Writable.storeLimbs {m : MemoryState} (h : Writable m p) : Writable (m.storeLimbs q l) p :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

/-- A point's store keeps every block's writability. -/
theorem Writable.storePoint {m : MemoryState} (h : Writable m p) : Writable (m.storePoint q P) p :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

/-- An optional point's store keeps every block's writability. -/
theorem Writable.storePointOpt {m : MemoryState} (h : Writable m p) :
    Writable (m.storePointOpt q P?) p := by
  cases P? with
  | none => exact h
  | some P => exact h.storePoint

/-- An optional point's store keeps the globals table. -/
theorem MemoryState.globals_storePointOpt {m : MemoryState} :
    (m.storePointOpt q P?).globals = m.globals := by cases P? <;> rfl

end

end MLIR

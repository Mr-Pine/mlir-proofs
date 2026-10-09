module

public import SSA.Projects.RIR.Run.Tactic
public import Common.LimbsBits
public import Zig.Fe

/-! Step helpers for proofs whose state `S` has an equation `hS : S = …`: loads the facts do not
resolve, five-limb stores read back, and checkpoints hiding `hS` from later steps. -/

namespace LeanMLIR.RIR.Zig

/-- The five stores at `p` on top of `hS`, of `x`'s limbs, read back as `hr`. -/
macro "read_stores " p:term ", " x:term " with " hr:ident : tactic =>
  `(tactic|
    ( have hf : (GlobalState.mem $(Lean.mkIdent `S)).LimbsFit $p := by assumption
      rw [$(Lean.mkIdent `hS):ident] at hf
      dsimp only at hf
      rw [MemoryState.limbsFit_storeAt_iff, MemoryState.limbsFit_storeAt_iff,
        MemoryState.limbsFit_storeAt_iff, MemoryState.limbsFit_storeAt_iff,
        MemoryState.limbsFit_storeAt_iff] at hf
      have $hr:ident : (GlobalState.mem $(Lean.mkIdent `S)).readLimbs $p = $x := by
        rw [$(Lean.mkIdent `hS):ident]; exact MemoryState.readLimbs_stores hf $x
      clear hf))

/-- `hS` kept reversed as `hck`, not `S`'s equation: later states build on an opaque `S`. -/
macro "checkpoint " hck:ident : tactic =>
  `(tactic| (have $hck:ident := $(Lean.mkIdent `hS).symm; clear $(Lean.mkIdent `hS)))

/-- A loaded value `v` (`hv : v = S's read`) as the read fact `h` gives it; `h`'s copy cleared. -/
macro "fix_load " v:ident hv:ident h:term : tactic =>
  `(tactic|
    ( have h' := $h; try simp only [MemoryState.readLimbs] at h'
      rw [$(Lean.mkIdent `hS):ident] at h'; try dsimp only at h'
      rw [h'] at $hv:ident
      subst $v:ident
      clear h'))

end LeanMLIR.RIR.Zig

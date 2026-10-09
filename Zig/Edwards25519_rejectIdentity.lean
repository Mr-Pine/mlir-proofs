module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Fe_isZero
public import Zig.Mlir.Edwards25519_rejectIdentity

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `error.IdentityElement` (`3`) if `P.x` is zero, else no error (`0`). -/
def Edwards25519.rejectIdentity.spec (P : ZPt) : BitVec 16 :=
  if Fe.isZero.spec P.x = 1#1 then 3#16 else 0#16

end

/-! ## Proof -/

section Proof

/-- `Edwards25519.rejectIdentity` returns `spec P`, for `x` below `2^63`. -/
public theorem Edwards25519_rejectIdentity.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.PtFit p) (hx : Fe.Lt (s.mem.readPt p).x (2 ^ 63)) :
    Edwards25519_rejectIdentity.call (Edwards25519_rejectIdentity.args (.value p)) s =
      .value
        (.cons (.value (Edwards25519.rejectIdentity.spec (s.mem.readPt p))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  have hpx := hp.limbsFit_x
  simp only [MemoryState.readPt] at hx
  block_init
  iterate 2 step_pure
  step_call using Fe_isZero.call_eq
  step_pure
  finish_block
  rw [hS]
  erase_frame
  simp only [Edwards25519.rejectIdentity.spec, MemoryState.readPt]
  congr

end Proof

end MLIR.Zig

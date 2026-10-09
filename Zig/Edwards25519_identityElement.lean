module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Point
public import Zig.Mlir.Edwards25519_identityElement
import all SSA.Projects.RIR.Ty

/-! The `Edwards25519` struct as a global's value, and `Edwards25519.identityElement`'s: its
initializer's literal, and the point read back from the block `addressof` gives it. -/

namespace LeanMLIR.RIR.Zig

@[expose] public section

/-- Zig's `Edwards25519` struct type. -/
abbrev EdTy : Ty :=
  Edwards25519_identityElement.t

/-- An `Edwards25519` value as raw bits: `P`'s limbs, `is_base` `b`, zero padding. -/
def ZPt.raw (P : ZPt) (b : BitVec 1) : ⟦EdTy⟧ᵣ :=
  (Vector.ofFn P.x, Vector.ofFn P.y, Vector.ofFn P.z, Vector.ofFn P.t, b, Vector.replicate 7 0)

/-- The identity `(0, 1, 1, 0)`. -/
def Edwards25519.identity : ZPt :=
  ⟨Fe.mk5 0 0 0 0 0, Fe.mk5 1 0 0 0 0, Fe.mk5 1 0 0 0 0, Fe.mk5 0 0 0 0 0⟩

end

/-- An `Edwards25519` struct is 168 bytes. -/
public theorem width_edTy : EdTy.width = 1344 := by decide

/-- The initializer's literal: the identity, `is_base` false. -/
public theorem Edwards25519_identityElement.lit_eq :
    Edwards25519_identityElement.lit = Edwards25519.identity.raw 0 := by decide +kernel

/-- The initializer's value: its literal. -/
public theorem Edwards25519_identityElement.value_eq (s : GlobalState) :
    Edwards25519_identityElement.value s = .value (Ty.wrap Edwards25519_identityElement.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The literal's bits: the identity's, `rest` zero. -/
theorem identity_bits :
    Ty.flatBits Edwards25519_identityElement.lit (hw := width_edTy) =
      Edwards25519.identity.bits 0#64 := by
  decide +kernel

/-- The identity global's block (`step_addressof … value_eq`'s facts) read back. -/
public theorem _root_.LeanMLIR.RIR.MemoryState.readPt_identity {m : MemoryState} {p : Pointer}
    {hw : EdTy.width = 1344} (hf : Fits m p 1344) (ho : p.offset = 0)
    (hr : m.readAt p 1344 = Ty.flatBits Edwards25519_identityElement.lit (hw := hw)) :
    m.PtFit p ∧ m.readPt p = Edwards25519.identity ∧ m.readRest p = 0#64 := by
  have hp : m.PtFit p := ⟨by simp [ho], hf⟩
  exact ⟨hp, MemoryState.readPt_of_readAt hp (hr.trans identity_bits)⟩

end LeanMLIR.RIR.Zig

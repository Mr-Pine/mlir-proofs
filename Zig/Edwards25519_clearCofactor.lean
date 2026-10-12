module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_clearCofactor

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `8P`: three doublings. -/
def Edwards25519.clearCofactor.spec (P : ZPt) : ZPt :=
  Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))

end

/-! ## Proof -/

section Proof

/-- `Edwards25519.clearCofactor` copies `spec P`, `is_base` false, to `out` from a fresh slot, for
`x, y, z` below `2^53`; `out` may be `p`. -/
public theorem Edwards25519_clearCofactor.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hX : Fe.Lt (s.mem.readPt p).x (2 ^ 53))
    (hY : Fe.Lt (s.mem.readPt p).y (2 ^ 53)) (hZ : Fe.Lt (s.mem.readPt p).z (2 ^ 53)) :
    Edwards25519_clearCofactor.call (Edwards25519_clearCofactor.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 87⟩,
            mem :=
              s.mem.storePtCopy out (Edwards25519.clearCofactor.spec (s.mem.readPt p)) 0#1 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hX hY hZ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  block_init
  iterate 2 step_pure
  step_alloca with t1
  step_alloca with t2
  step_alloca with t3
  have ht1R := MemoryState.PtRoom.of_room ht1_room ht1_off
  have ht2R := MemoryState.PtRoom.of_room ht2_room ht2_off
  have ht3R := MemoryState.PtRoom.of_room ht3_room ht3_off
  have ht1A : (((S₀.alloca 168).alloca 168).alloca 168).mem.PtRoom t1 := hS ▸ ht1R
  -- `t1` is fresh: its bits zero, none defined
  have hz : (((S₀.alloca 168).alloca 168).alloca 168).mem.readAt t1 1344 = 0 := by
    rw [ht1, ← GlobalState.allocaPtr_eq_slot,
      MemoryState.readAt_alloca_of_fits hwf₀.alloca.alloca
        (InBounds.alloca hwf₀.alloca (InBounds.allocaPtr (by omega))),
      MemoryState.readAt_alloca_of_fits hwf₀.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.readAt_alloca_allocaPtr]
  have hzd : (((S₀.alloca 168).alloca 168).alloca 168).mem.definedAt t1 1344 = 0 := by
    rw [ht1, ← GlobalState.allocaPtr_eq_slot,
      MemoryState.definedAt_alloca hwf₀.alloca.alloca
        (InBounds.alloca hwf₀.alloca (InBounds.allocaPtr (by omega))),
      MemoryState.definedAt_alloca hwf₀.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.definedAt_alloca_allocaPtr]
  step_call using Edwards25519_dbl.call_eq_of
  have hD := (Edwards25519.dbl.spec_lt P).mono53
  have h1 := hD.1
  have h2 := hD.2.1
  have h3 := hD.2.2.1
  clear hD
  step_call using Edwards25519_dbl.call_eq_of consuming h1 h2 h3
  have hD := (Edwards25519.dbl.spec_lt (Edwards25519.dbl.spec P)).mono53
  have h1 := hD.1
  have h2 := hD.2.1
  have h3 := hD.2.2.1
  clear hD
  step_call using Edwards25519_dbl.call_eq_of consuming h1 h2 h3
  step_memcpy consuming hp
  -- the copy: `8P` as a fresh slot holds it
  have h21 : t2.id ≠ t1.id := by
    subst ht1 ht2; exact GlobalState.slot_id_ne (by decide)
  have h31 : t3.id ≠ t1.id := by
    subst ht1 ht3; exact GlobalState.slot_id_ne (by decide)
  rw [MemoryState.readAt_storePt_self ht1A.storePt.storePt,
    MemoryState.definedAt_storePt_self ht1A.storePt.storePt,
    MemoryState.readAt_storePt_of_id_ne h21, MemoryState.definedAt_storePt_of_id_ne h21,
    MemoryState.readAt_storePt_of_id_ne h31, MemoryState.definedAt_storePt_of_id_ne h31, hz,
    hzd] at hS
  finish_block
  rw [hS]
  erase_frame
  rw [hP₀]
  rfl

end Proof

end MLIR.Zig

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Edwards25519_add
public import Zig.Edwards25519_neg
public import Zig.Mlir.Edwards25519_sub

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `P - Q`: `P + (-Q)`. -/
def Edwards25519.sub.spec (P Q : ZPt) : ZPt :=
  Edwards25519.add.spec P (Edwards25519.neg.spec Q)

end

/-- `P - Q`'s limbs are below `2^52`. -/
public theorem Edwards25519.sub.spec_lt (P Q : ZPt) : (Edwards25519.sub.spec P Q).Lt (2 ^ 52) :=
  Edwards25519.add.spec_lt _ _

/-! ## Proof -/

section Proof

/-- `Edwards25519.sub` copies `spec P Q`, `is_base` false, to `out` from a fresh slot, for limbs
below `2^53`. -/
public theorem Edwards25519_sub.call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hq : s.mem.PtLimbsFit q)
    (hP : (s.mem.readPt p).Lt (2 ^ 53)) (hQ : (s.mem.readPt q).Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 47⟩,
            mem :=
              s.mem.storePtCopy out (Edwards25519.sub.spec (s.mem.readPt p) (s.mem.readPt q))
                0#1 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hQd : S.mem.readPt q = Q at hQ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hQ₀ : S₀.mem.readPt q = Q := hS ▸ hQd
  block_init
  iterate 2 step_pure
  step_alloca with t2
  step_alloca with t3
  have ht2R := MemoryState.PtRoom.of_room ht2_room ht2_off
  have ht3R := MemoryState.PtRoom.of_room ht3_room ht3_off
  have ht2A : ((S₀.alloca 168).alloca 168).mem.PtRoom t2 := hS ▸ ht2R
  -- `t2` is fresh: its bits zero, none defined
  have hz : ((S₀.alloca 168).alloca 168).mem.readAt t2 1344 = 0 := by
    rw [ht2, ← GlobalState.allocaPtr_eq_slot,
      MemoryState.readAt_alloca_of_fits hwf₀.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.readAt_alloca_allocaPtr]
  have hzd : ((S₀.alloca 168).alloca 168).mem.definedAt t2 1344 = 0 := by
    rw [ht2, ← GlobalState.allocaPtr_eq_slot,
      MemoryState.definedAt_alloca hwf₀.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.definedAt_alloca_allocaPtr]
  have h1 := hQ.1.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hQ.2.2.2.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Edwards25519_neg.call_eq_of consuming h1 h2
  have hN := Edwards25519.neg.spec_lt hQ
  step_call using Edwards25519_add.call_eq_of consuming hN hP
  step_memcpy consuming hp hq
  -- the copy: the sum as a fresh slot holds it
  have h32 : t3.id ≠ t2.id := by
    subst ht2 ht3; exact GlobalState.slot_id_ne (by decide)
  rw [MemoryState.readAt_storePt_self ht2A.storePt, MemoryState.definedAt_storePt_self ht2A.storePt,
    MemoryState.readAt_storePt_of_id_ne h32, MemoryState.definedAt_storePt_of_id_ne h32, hz,
    hzd] at hS
  finish_block
  rw [hS]
  erase_frame
  rw [hP₀, hQ₀]
  rfl

end Proof

end MLIR.Zig

module

public import MLIR.Run.Tactic
public import Common.Tactics
public import Zig.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_clearCofactor
import Std.Data.ExtHashMap.Lemmas

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `8P`: three doublings. -/
def Edwards25519.clearCofactor.spec (P : ZPt) : ZPt :=
  Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec P))

end

/-! ## Proof -/

section Proof

/-- `Edwards25519.clearCofactor` stores `spec P` at `out`, its last 8 bytes zero, for `x, y, z`
below `2^53`; `out` may be `p`. -/
public theorem Edwards25519_clearCofactor.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hX : Fe.Lt (s.mem.readPt p).x (2 ^ 53))
    (hY : Fe.Lt (s.mem.readPt p).y (2 ^ 53)) (hZ : Fe.Lt (s.mem.readPt p).z (2 ^ 53)) :
    Edwards25519_clearCofactor.call (Edwards25519_clearCofactor.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 87⟩,
            mem :=
              s.mem.storePt out (Edwards25519.clearCofactor.spec (s.mem.readPt p)) 0#64 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hX hY hZ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  have hout₀ : S₀.mem.PtFit out := hS ▸ hout
  clear hPd
  block_init
  iterate 2 step_pure
  step_alloca with t2
  step_alloca with t3
  step_alloca with t4
  have ht2P := MemoryState.PtFit.of_fits ht2_fits ht2_off
  have ht3P := MemoryState.PtFit.of_fits ht3_fits ht3_off
  have ht4P := MemoryState.PtFit.of_fits ht4_fits ht4_off
  clear ht2_fits ht3_fits ht4_fits
  have hread_p : S.mem.readPt p = P := by
    rw [hS, MemoryState.readPt_alloca hwf₀.alloca.alloca ((hp₀.alloca hwf₀).alloca hwf₀.alloca),
      MemoryState.readPt_alloca hwf₀.alloca (hp₀.alloca hwf₀), MemoryState.readPt_alloca hwf₀ hp₀,
      hP₀]
  -- 2P
  step_call using Edwards25519_dbl.call_eq_of
  have hM : _ := ht4P
  rw [hS] at hM
  have hread_4 : S.mem.readPt t4 = Edwards25519.dbl.spec P := by
    rw [hS]; exact (MemoryState.readPt_storePt_self ⟨hM.1, Fits.storeAt_iff.mp hM.2⟩).1
  clear hM
  have hD := Edwards25519.dbl.spec_lt P
  have h1 := hD.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  have h2 := hD.2.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  have h3 := hD.2.2.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  -- 4P
  step_call using Edwards25519_dbl.call_eq_of consuming h1 h2 h3
  have hM : _ := ht3P
  rw [hS] at hM
  have hread_3 : S.mem.readPt t3 = Edwards25519.dbl.spec (Edwards25519.dbl.spec P) := by
    rw [hS]; exact (MemoryState.readPt_storePt_self ⟨hM.1, Fits.storeAt_iff.mp hM.2⟩).1
  clear hM
  have hD := Edwards25519.dbl.spec_lt (Edwards25519.dbl.spec P)
  have h1 := hD.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  have h2 := hD.2.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  have h3 := hD.2.2.1.mono (show 2 ^ 52 ≤ 2 ^ 53 by decide)
  -- 8P
  step_call using Edwards25519_dbl.call_eq_of consuming h1 h2 h3
  -- `t2`'s bytes: `8P`, its last 8 bytes those of a fresh block
  have hM : _ := ht2P
  rw [hS] at hM
  have hF : (S₀.alloca 168).mem.PtFit S₀.allocaPtr :=
    MemoryState.PtFit.of_fits Fits.allocaPtr_self (by simp [GlobalState.allocaPtr])
  have h32 : t3.id ≠ t2.id := by
    subst ht2 ht3; exact GlobalState.slot_id_ne (by decide)
  have h42 : t4.id ≠ t2.id := by
    subst ht2 ht4; exact GlobalState.slot_id_ne (by decide)
  have hcopy : S.mem.readAt t2 1344 = (Edwards25519.clearCofactor.spec P).bits 0#64 := by
    rw [hS]; dsimp only
    rw [MemoryState.readAt_storeAt_self (Fits.storeAt_iff.mp hM.2),
      MemoryState.readRest_storeAt_of_id_ne h32, MemoryState.readRest_storeAt_of_id_ne h42]
    subst ht2
    rw [← GlobalState.allocaPtr_eq_slot,
      MemoryState.readRest_alloca hwf₀.alloca.alloca (hF.alloca hwf₀.alloca),
      MemoryState.readRest_alloca hwf₀.alloca hF]
    unfold MemoryState.readRest
    rw [readAt_alloca_self]; rfl
  clear hM h32 h42 hF
  have f1 := hout.2
  have f2 := ht2P.2
  step_memcpy consuming f1 f2 hcopy
  finish_block
  rw [hS]
  erase_frame
  rw [hP₀]
  simp [GlobalState.alloca]

end Proof

end MLIR.Zig

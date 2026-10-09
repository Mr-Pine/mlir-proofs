module

public import MLIR.Run.Tactic
public import Common.Tactics
public import Zig.Edwards25519_add
public import Zig.Edwards25519_neg
public import Zig.Mlir.Edwards25519_sub
import Std.Data.ExtHashMap.Lemmas

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

/-- `neg`'s `call_eq` on the point `Q` read at `p`. -/
public theorem Edwards25519_neg.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hsep : out.id ≠ p.id) (hQ : s.mem.readPt p = Q)
    (hx : Fe.Lt Q.x (2 ^ 63)) (ht : Fe.Lt Q.t (2 ^ 63)) :
    Edwards25519_neg.call (Edwards25519_neg.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storePt out (Edwards25519.neg.spec Q)
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  subst hQ
  exact Edwards25519_neg.call_eq out p s hwf hout hp hsep hx ht

/-- `add`'s `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
public theorem Edwards25519_add.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hq : s.mem.PtFit q) (hPd : s.mem.readPt p = P)
    (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_add.call (Edwards25519_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 38⟩,
            mem :=
              s.mem.storePt out (Edwards25519.add.spec P Q)
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  subst hPd hQd
  exact Edwards25519_add.call_eq out p q s hwf hout hp hq hP hQ

/-- `Edwards25519.sub` stores `spec P Q` at `out`, its last 8 bytes zero, for limbs below
`2^53`. -/
public theorem Edwards25519_sub.call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hq : s.mem.PtFit q)
    (hP : (s.mem.readPt p).Lt (2 ^ 53)) (hQ : (s.mem.readPt q).Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 47⟩,
            mem :=
              s.mem.storePt out (Edwards25519.sub.spec (s.mem.readPt p) (s.mem.readPt q))
                0#64 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hQd : S.mem.readPt q = Q at hQ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hQ₀ : S₀.mem.readPt q = Q := hS ▸ hQd
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  have hq₀ : S₀.mem.PtFit q := hS ▸ hq
  have hout₀ : S₀.mem.PtFit out := hS ▸ hout
  clear hPd hQd
  block_init
  iterate 2 step_pure
  step_alloca with t2
  step_alloca with t3
  have ht2P := MemoryState.PtFit.of_fits ht2_fits ht2_off
  have ht3P := MemoryState.PtFit.of_fits ht3_fits ht3_off
  clear ht2_fits ht3_fits
  have hA : ((S₀.alloca 168).alloca 168).mem.readPt p = P := by
    rw [MemoryState.readPt_alloca hwf₀.alloca (hp₀.alloca hwf₀), MemoryState.readPt_alloca hwf₀ hp₀,
      hP₀]
  have hB : ((S₀.alloca 168).alloca 168).mem.readPt q = Q := by
    rw [MemoryState.readPt_alloca hwf₀.alloca (hq₀.alloca hwf₀), MemoryState.readPt_alloca hwf₀ hq₀,
      hQ₀]
  have hread_q : S.mem.readPt q = Q := by
    rw [hS]; exact hB
  have h1 := hQ.1.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hQ.2.2.2.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Edwards25519_neg.call_eq_of consuming h1 h2
  have hM : ((S₀.alloca 168).alloca 168).mem.PtFit t3 := by
    have h := ht3P; rw [hS] at h; exact ⟨h.1, Fits.storeAt_iff.mp h.2⟩
  have hread_p : S.mem.readPt p = P := by
    rw [hS]; dsimp only; rw [MemoryState.readPt_storeAt_of_id_ne hp_ne_t3.symm]; exact hA
  have hread_n : S.mem.readPt t3 = Edwards25519.neg.spec Q := by
    rw [hS]; exact (MemoryState.readPt_storePt_self hM).1
  have hN : (Edwards25519.neg.spec Q).Lt (2 ^ 53) := by
    have hz : Fe.Lt (fun _ => 0#64) 1 := fun _ => show (0#64).toNat < 1 by decide
    refine
      ⟨(Fe.sub.spec_lt hz (by decide)).mono (by decide), hQ.2.1, hQ.2.2.1,
        (Fe.sub.spec_lt hz (by decide)).mono (by decide)⟩
  clear hA hB hM
  step_call using Edwards25519_add.call_eq_of
  have f1 := hout.2
  have f2 := ht2P.2
  step_memcpy consuming f1 f2
  finish_block
  rw [hS]
  erase_frame
  have hF : (S₀.alloca 168).mem.PtFit S₀.allocaPtr :=
    MemoryState.PtFit.of_fits Fits.allocaPtr_self (by simp [GlobalState.allocaPtr])
  have hF' := hF.alloca (n := 168) hwf₀.alloca
  have hz : ((S₀.alloca 168).alloca 168).mem.readRest t2 = 0#64 := by
    subst ht2
    rw [← GlobalState.allocaPtr_eq_slot]
    unfold MemoryState.readRest
    rw [MemoryState.readAt_alloca hwf₀.alloca hF.fits_rest, readAt_alloca_self]; rfl
  have h32 : t3.id ≠ S₀.allocaPtr.id := by
    subst ht3; rw [GlobalState.allocaPtr_eq_slot]; exact GlobalState.slot_id_ne (by decide)
  subst ht2
  rw [← GlobalState.allocaPtr_eq_slot] at hz ⊢
  simp only [MemoryState.storePt]
  rw [MemoryState.readAt_storeAt_self (Fits.storeAt hF'.2),
    MemoryState.readRest_storeAt_of_id_ne h32, hz, hP₀, hQ₀]
  simp [GlobalState.alloca, Edwards25519.sub.spec, ZPt.flag]

/-- `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
public theorem Edwards25519_sub.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hq : s.mem.PtFit q) (hPd : s.mem.readPt p = P)
    (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 47⟩,
            mem := s.mem.storePt out (Edwards25519.sub.spec P Q) 0#64 }) := by
  subst hPd hQd
  exact Edwards25519_sub.call_eq out p q s hwf hout hp hq hP hQ

end Proof

end MLIR.Zig

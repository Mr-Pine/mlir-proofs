module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Fe_neg
public import Zig.Mlir.Edwards25519_neg

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `-P`: `x` and `t` negated. -/
def Edwards25519.neg.spec (P : ZPt) : ZPt :=
  ⟨Fe.neg.spec P.x, P.y, P.z, Fe.neg.spec P.t⟩

end

/-! ## Proof -/

section Proof

/-- `Edwards25519.neg` stores `spec P` at `out`, `is_base` false, for `x, t` below `2^63`; `out` is
apart from `p`. -/
public theorem Edwards25519_neg.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hsep : out.id ≠ p.id)
    (hx : Fe.Lt (s.mem.readPt p).x (2 ^ 63)) (ht : Fe.Lt (s.mem.readPt p).t (2 ^ 63)) :
    Edwards25519_neg.call (Edwards25519_neg.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storePt out (Edwards25519.neg.spec (s.mem.readPt p))
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  func_init
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  have hout₀ : S₀.mem.PtFit out := hS ▸ hout
  -- `p` below the three `alloca`s, as the steps read it
  have hp1 := hp₀.alloca (n := 40) hwf₀
  have hp2 := hp1.alloca (n := 40) hwf₀.alloca
  have hp3 := hp2.alloca (n := 168) hwf₀.alloca.alloca
  have hP : (((S₀.alloca 40).alloca 40).alloca 168).mem.readAt p 1344 = S₀.mem.readAt p 1344 := by
    rw [MemoryState.readAt_alloca_of_fits hwf₀.alloca.alloca hp2.2,
      MemoryState.readAt_alloca_of_fits hwf₀.alloca hp1.2, MemoryState.readAt_alloca_of_fits hwf₀ hp₀.2]
  simp only [MemoryState.readPt] at hx ht
  block_init
  iterate 4 step_pure
  step_alloca with t4
  step_alloca with t5
  step_alloca with t6
  limbs_fit t4
  limbs_fit t5
  have ht6P := MemoryState.PtFit.of_fits ht6_fits ht6_off
  have ht6A : (((S₀.alloca 40).alloca 40).alloca 168).mem.PtFit t6 := hS ▸ ht6P
  clear ht6_fits
  have hp1344 := hp.2
  step_memcpy consuming hp1344
  -- the copy's fields are `p`'s
  have hcopy : S.mem.readPt t6 = S.mem.readPt p := by
    have hpA := hp
    have ht6A := ht6P
    rw [hS, ← hP] at hpA ht6A ⊢
    simp only [MemoryState.PtFit, Fits.storeAt_iff] at hpA ht6A
    rw [(MemoryState.readPt_storeAt_readAt hpA ht6A).1,
      MemoryState.readPt_storeAt_of_id_ne hp_ne_t6.symm]
  have ht6t : Fe.Lt (S.mem.readLimbs (t6.add 120#64)) (2 ^ 63) := by
    have := congrArg ZPt.t hcopy
    simp only [MemoryState.readPt] at this
    rw [this]; exact ht
  clear hcopy
  step_call using Fe_neg.call_eq
  have f1 := hout.limbsFit_x.fits
  have f2 := ht5_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits ht5_limbs.fits ht5_limbs.1
  step_memcpy consuming f1 f2 hx hv
  step_pure
  step_pure
  have f1 := hout.limbsFit_y.fits
  have f2 := hp.limbsFit_y.fits
  step_memcpy consuming f1 f2
  step_pure
  step_pure
  have f1 := hout.limbsFit_z.fits
  have f2 := hp.limbsFit_z.fits
  step_memcpy consuming f1 f2
  step_pure
  step_pure
  step_call using Fe_neg.call_eq
  have f1 := hout.limbsFit_t.fits
  have f2 := ht4_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits ht4_limbs.fits ht4_limbs.1
  step_memcpy consuming f1 f2 ht ht6t hv
  step_pure
  have f1 := hout.fits_rest.mono (show 1 ≤ 64 by omega)
  step_store consuming f1
  finish_block
  rw [hS]
  erase_frame
  -- `p` and its copy at `t6`, as `S₀` holds them
  have hR : (((S₀.alloca 40).alloca 40).alloca 168).mem.readPt p = S₀.mem.readPt p := by
    rw [MemoryState.readPt_alloca hwf₀.alloca.alloca hp2, MemoryState.readPt_alloca hwf₀.alloca hp1,
      MemoryState.readPt_alloca hwf₀ hp₀]
  rw [MemoryState.readAt_eq_limbsBits ?fy (Pointer.field_offset hp₀.1 (a := 40) (by omega)),
    MemoryState.readAt_eq_limbsBits ?fz (Pointer.field_offset hp₀.1 (a := 80) (by omega))]
  · have e40 : t5.id ≠ (p.add 40#64).id := by simpa [Pointer.add_id] using hp_ne_t5.symm
    have e80 : t5.id ≠ (p.add 80#64).id := by simpa [Pointer.add_id] using hp_ne_t5.symm
    have f40 : t6.id ≠ (p.add 40#64).id := by simpa [Pointer.add_id] using hp_ne_t6.symm
    have f80 : t6.id ≠ (p.add 80#64).id := by simpa [Pointer.add_id] using hp_ne_t6.symm
    have hc := congrArg ZPt.t (MemoryState.readPt_storeAt_readAt hp3 ht6A).1
    rw [hP] at hc
    have hy := congrArg ZPt.y hR
    have hz := congrArg ZPt.z hR
    have ht' := congrArg ZPt.t hR
    simp only [MemoryState.readPt] at hc hy hz ht'
    simp only [MemoryState.readLimbs_storeLimbs_of_id_ne e40,
      MemoryState.readLimbs_storeLimbs_of_id_ne e80, MemoryState.readLimbs_storeAt_of_id_ne f40,
      MemoryState.readLimbs_storeAt_of_id_ne f80, hc, hy, hz, ht']
    rw [MemoryState.storeAt_fields_eq hout₀]
    simp [GlobalState.alloca, Edwards25519.neg.spec, MemoryState.readPt]
  · simp only [Fits.storeLimbs_iff, Fits.storeAt_iff]; exact hp3.limbsFit_z.fits
  · simp only [Fits.storeLimbs_iff, Fits.storeAt_iff]; exact hp3.limbsFit_y.fits

end Proof

end MLIR.Zig

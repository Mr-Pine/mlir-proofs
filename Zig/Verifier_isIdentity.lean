module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Fe_isZero
public import Zig.Fe_sub
public import Zig.Mlir.Verifier_isIdentity

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `1` iff `P.x` is zero and `P.y - P.z` is zero. -/
def Verifier.isIdentity.spec (P : ZPt) : BitVec 1 :=
  if Fe.isZero.spec P.x = 1#1 then Fe.isZero.spec (Fe.sub.spec P.y P.z) else 0#1

end

/-! ## Proof -/

section Proof

/-- `Verifier.isIdentity` returns `spec P`, for `x`, `z` below `2^63` and `y` below `2^62`. -/
public theorem Verifier_isIdentity.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.PtFit p) (hx : Fe.Lt (s.mem.readPt p).x (2 ^ 63))
    (hy : Fe.Lt (s.mem.readPt p).y (2 ^ 62)) (hz : Fe.Lt (s.mem.readPt p).z (2 ^ 63)) :
    Verifier_isIdentity.call (Verifier_isIdentity.args (.value p)) s =
      .value
        (.cons (.value (Verifier.isIdentity.spec (s.mem.readPt p))) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + if Fe.isZero.spec (s.mem.readPt p).x = 1#1 then 4 else 3⟩,
            mem := s.mem }) := by
  func_init
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  simp only [MemoryState.readPt] at hx hy hz
  block_init
  iterate 3 step_pure
  step_alloca with t
  step_alloca with c
  limbs_fit t
  have hcP := MemoryState.PtFit.of_fits hc_fits hc_off
  clear hc_fits
  have hp1344 := hp.2
  step_memcpy consuming hp1344
  have hpx := hp.limbsFit_x
  step_call using Fe_isZero.call_eq
  finish_block
  · block_init
    iterate 3 step_pure
    have hA :
      (((S₀.alloca 40).alloca 168).mem.storeAt c (S₀.mem.readAt p 1344)).readPt p =
        S₀.mem.readPt p := by
      rw [MemoryState.readPt_storeAt_of_id_ne hp_ne_c.symm,
        MemoryState.readPt_alloca hwf₀.alloca (hp₀.alloca hwf₀), MemoryState.readPt_alloca hwf₀ hp₀]
    have hR : S.mem.readPt c = S₀.mem.readPt p := by
      have h2 := hcP
      rw [hS] at h2 ⊢
      exact (MemoryState.readPt_storeAt_readAt hp₀ ⟨h2.1, Fits.storeAt_iff.mp h2.2⟩).1
    have hYd : S.mem.readLimbs (c.add 40#64) = (S₀.mem.readPt p).y := congrArg ZPt.y hR
    have hZd : S.mem.readLimbs (p.add 80#64) = (S₀.mem.readPt p).z := by
      rw [hS]; exact congrArg ZPt.z hA
    have hcy : Fe.Lt (S₀.mem.readPt p).y (2 ^ 62) := by
      rw [← congrArg ZPt.y hA]; rw [hS] at hy; exact hy
    rw [hZd] at hz
    clear hR hA
    have hcyL := hcP.limbsFit_y
    have hpzL := hp.limbsFit_z
    have h1 := hcy.mono (show 2 ^ 62 ≤ 2 ^ 63 by decide)
    step_call using Fe_sub.call_eq_of consuming h1 hz hYd hZd
    have h2 :=
      (Fe.sub.spec_lt (b := (S₀.mem.readPt p).z) hcy (by decide)).mono
        (show 2 ^ 62 + 2 ^ 52 ≤ 2 ^ 63 by decide)
    step_call using Fe_isZero.call_eq_of consuming h2
    step_pure
    finish_block
    block_init
    finish_block
    rw [hS]
    erase_frame
    simp [GlobalState.alloca, Verifier.isIdentity.spec, MemoryState.readPt, hbr]
  · block_init
    finish_block
    rw [hS]
    erase_frame
    simp [GlobalState.alloca, Verifier.isIdentity.spec, MemoryState.readPt, hbr]

end Proof

end MLIR.Zig

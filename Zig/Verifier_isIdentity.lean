module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.PointCopy
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
    (hp : s.mem.PtLimbsFit p) (hx : Fe.Lt (s.mem.readPt p).x (2 ^ 63))
    (hy : Fe.Lt (s.mem.readPt p).y (2 ^ 62)) (hz : Fe.Lt (s.mem.readPt p).z (2 ^ 63)) :
    Verifier_isIdentity.call (Verifier_isIdentity.args (.value p)) s =
      .value
        (.cons (.value (Verifier.isIdentity.spec (s.mem.readPt p))) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + if Fe.isZero.spec (s.mem.readPt p).x = 1#1 then 4 else 3⟩,
            mem := s.mem }) := by
  func_init
  simp only [MemoryState.readPt] at hx hy hz
  have hy₀ : Fe.Lt (S₀.mem.readLimbs (p.add 40#64)) (2 ^ 62) := hS ▸ hy
  block_init
  iterate 3 step_pure
  step_alloca with t
  step_alloca with c
  have hcR := MemoryState.PtRoom.of_room hc_room hc_off
  have hpA : ((S₀.alloca 40 true).alloca 168).mem.PtLimbsFit p := hS ▸ hp
  have hcA : ((S₀.alloca 40 true).alloca 168).mem.PtRoom c := hS ▸ hcR
  have hbits : ((S₀.alloca 40 true).alloca 168).mem.readAt p 1344 = S₀.mem.readAt p 1344 := by
    simp (disch := mem_fact) only [MemoryState.readAt_alloca_of_fits]
  step_memcpy
  clear hfits_c hread_c_readAt hread_c_readLimbs hread_c_readPt hread_c hc_room
  step_call using Fe_isZero.call_eq
  finish_block
  · block_init
    iterate 2 step_pure
    have hYd : S.mem.readLimbs (c.add 40#64) = S₀.mem.readLimbs (p.add 40#64) := by
      rw [hS]
      dsimp only
      rw [MemoryState.readLimbs_copy_of (a := 40) hcA hpA.ptLive (by omega) hbits]
      simp (disch := mem_fact) only [MemoryState.readLimbs_alloca]
    have hZd : S.mem.readLimbs (p.add 80#64) = S₀.mem.readLimbs (p.add 80#64) := by
      rw [hS]
      simp (disch := mem_fact) only [MemoryState.readLimbs_storeCopy_of_id_ne,
        MemoryState.readLimbs_alloca]
    have hz₀ : Fe.Lt (S₀.mem.readLimbs (p.add 80#64)) (2 ^ 63) := hZd ▸ hz
    clear hbits hcA hpA hz hy hx
    step_pure
    limbs_room t
    have h1 := hy₀.mono (show 2 ^ 62 ≤ 2 ^ 63 by decide)
    step_call using Fe_sub.call_eq_of consuming h1 hz₀ hYd hZd
    have h2 :=
      (Fe.sub.spec_lt (b := S₀.mem.readLimbs (p.add 80#64)) hy₀ (by decide)).mono
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

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.PointCopy
public import Zig.Fe_neg
public import Zig.Mlir.Edwards25519_neg

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `-P`: `x` and `t` negated. -/
def Edwards25519.neg.spec (P : ZPt) : ZPt :=
  ⟨Fe.neg.spec P.x, P.y, P.z, Fe.neg.spec P.t⟩

end

/-- `-P`'s limbs are below `2^53` where `P`'s are. -/
public theorem Edwards25519.neg.spec_lt {P : ZPt} (h : P.Lt (2 ^ 53)) :
    (Edwards25519.neg.spec P).Lt (2 ^ 53) :=
  ⟨Fe.neg.spec_lt53 _, h.2.1, h.2.2.1, Fe.neg.spec_lt53 _⟩

/-! ## Proof -/

section Proof

/-- `Fe_neg.call_eq` on the limbs `A` read at `a`. -/
private theorem fe_neg_call_eq_of (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Fe_neg.globals) (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a)
    (hA : s.mem.readLimbs a = A) (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_neg.call (Fe_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs out (Fe.neg.spec A) }) := by
  subst hA
  exact Fe_neg.call_eq out a s hwf hg hout ha hA'

/-- `Edwards25519.neg` stores `spec P` at `out`, `is_base` false, for `x, t` below `2^63`; `out` is
apart from `p`. -/
public theorem Edwards25519_neg.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_neg.globals) (hout : s.mem.PtRoom out)
    (hp : s.mem.PtLimbsFit p) (hsep : out.id ≠ p.id) (hx : Fe.Lt (s.mem.readPt p).x (2 ^ 63))
    (ht : Fe.Lt (s.mem.readPt p).t (2 ^ 63)) :
    Edwards25519_neg.call (Edwards25519_neg.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storePt out (Edwards25519.neg.spec (s.mem.readPt p)) 0#1 }) := by
  func_init
  have hpL₀ : S₀.mem.PtLimbsFit p := hS ▸ hp
  have hpy₀ := hpL₀.limbsFit_y.fits
  have hpz₀ := hpL₀.limbsFit_z.fits
  have ho := hout.1
  simp only [MemoryState.readPt] at hx ht
  have ht₀ : Fe.Lt (S₀.mem.readLimbs (p.add 120#64)) (2 ^ 63) := hS ▸ ht
  block_init
  iterate 4 step_pure
  step_alloca with t4
  step_alloca with t5
  step_alloca with t6
  limbs_room t4
  limbs_room t5
  have ht6P := MemoryState.PtRoom.of_room ht6_room ht6_off
  -- the copy's `t`, read later
  step_memcpy
  have hT : S.mem.readLimbs (t6.add 120#64) = S₀.mem.readLimbs (p.add 120#64) := by
    rw [show S.mem.readLimbs (t6.add 120#64) = (S.mem.readPt t6).t from rfl, hread_t6_readPt]; rfl
  clear hfits_t6 hread_t6_readAt hread_t6_readLimbs hread_t6_readPt hread_t6 ht6_room
  step_call using Fe_neg.call_eq
  have htm := hS ▸ ht5_limbs
  have htr := hS ▸ hread_t5_readLimbs
  have f2 := ht5_limbs.fits
  step_memcpy consuming f2 hread_t5_readLimbs hread_t5 hread_t5_8 hread_t5_16 hread_t5_24
    hread_t5_32 hfits_out
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (by omega), htr] at hS
  clear htm htr
  iterate 2 step_pure
  have f1 := hout.limbsRoom_y.room320
  have f2 := hp.limbsFit_y.fits
  step_memcpy consuming f1 f2 hfits_out_40
  rw [MemoryState.storeAt_readAt_eq_storeLimbs hpL₀.limbsFit_y
      (Pointer.field_offset ho (a := 40) (by omega))] at hS
  iterate 2 step_pure
  have f1 := hout.limbsRoom_z.room320
  have f2 := hp.limbsFit_z.fits
  step_memcpy consuming f1 f2 hfits_out_80
  rw [MemoryState.storeAt_readAt_eq_storeLimbs hpL₀.limbsFit_z
      (Pointer.field_offset ho (a := 80) (by omega))] at hS
  iterate 2 step_pure
  step_call using fe_neg_call_eq_of consuming hT ht₀
  have htm := hS ▸ ht4_limbs
  have htr := hS ▸ hread_t4_readLimbs
  have f1 := hout.limbsRoom_t.room320
  have f2 := ht4_limbs.fits
  step_memcpy consuming f1 f2 hread_t4_readLimbs hread_t4 hread_t4_8 hread_t4_16 hread_t4_24
    hread_t4_32 hfits_out_120
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 120) (by omega)),
    htr] at hS
  clear htm htr
  step_pure
  have f1 := hout.room_base
  step_store consuming f1
  finish_block
  rw [hS]
  erase_frame
  rfl

/-- `call_eq` on the point `Q` read at `p`. -/
public theorem Edwards25519_neg.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_neg.globals) (hout : s.mem.PtRoom out)
    (hp : s.mem.PtLimbsFit p) (hsep : out.id ≠ p.id)
    (hQ : s.mem.readPt p = Q) (hx : Fe.Lt Q.x (2 ^ 63)) (ht : Fe.Lt Q.t (2 ^ 63)) :
    Edwards25519_neg.call (Edwards25519_neg.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storePt out (Edwards25519.neg.spec Q) 0#1 }) := by
  subst hQ
  exact Edwards25519_neg.call_eq out p s hwf hg hout hp hsep hx ht

end Proof

end MLIR.Zig

module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Mlir.Fe_rejectNonCanonical
import Std.Tactic.BVDecide

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `error.NonCanonical` (`1`) iff the 32 bytes, little-endian, top bit ignored, are at least
`2^255 - 19`; else no error (`0`). -/
def Fe.rejectNonCanonical.spec (y : BitVec 256) : BitVec 16 :=
  if y.toNat % 2 ^ 255 < 2 ^ 255 - 19 then 0#16 else 1#16

end

/-! ## Proof -/

section Proof

/-- `spec` as a comparison of the low 255 bits, for `bv_decide`. -/
theorem Fe.rejectNonCanonical.spec_eq (y : BitVec 256) :
    Fe.rejectNonCanonical.spec y =
      if y.setWidth 255 < BitVec.ofNat 255 (2 ^ 255 - 19) then 0#16 else 1#16 := by
  have h :
    (y.setWidth 255 < BitVec.ofNat 255 (2 ^ 255 - 19)) ↔ y.toNat % 2 ^ 255 < 2 ^ 255 - 19 := by
    rw [BitVec.lt_def, BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  simp only [Fe.rejectNonCanonical.spec, h]

/-- Byte `k` of 32 bytes read at `p`. -/
theorem byte_at {m : MemoryState} {p : Pointer} {x : BitVec 256} (hf : Fits m p 256)
    (ho : ¬p.offset.uaddOverflow 32#64) (hx : m.readAt p 256 = x) (hk : k < 32) :
    Fits m (p.add (BitVec.ofNat 64 k)) 8 ∧
      m.readAt (p.add (BitVec.ofNat 64 k)) 8 = x.extractLsb' (8 * k) 8 := by
  have hin : (BitVec.ofNat 64 k).toNat = k := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le ho
      (by
        rw [hin]; show k ≤ 32; omega)
  have hw : (BitVec.ofNat 64 k).toNat * 8 + 8 ≤ 256 := by
    rw [hin]; omega
  refine ⟨Fits.add_of_le hov hw hf, ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf hov hw hx, hin, Nat.mul_comm]

/-- `Fe.rejectNonCanonical` returns `spec` of the 32 bytes at `p`. -/
public theorem Fe_rejectNonCanonical.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hpo : ¬p.offset.uaddOverflow 32#64) :
    Fe_rejectNonCanonical.call (Fe_rejectNonCanonical.args (.value p)) s =
      .value (.cons (.value (Fe.rejectNonCanonical.spec (s.mem.readAt p 256))) .nil, s) := by
  func_init
  generalize hx : S.mem.readAt p 256 = x
  have hx₀ : S₀.mem.readAt p 256 = x := hS ▸ hx
  rw [hx₀]
  have ⟨hf1, hb1⟩ := byte_at hp hpo hx (k := 1) (by omega)
  have ⟨hf2, hb2⟩ := byte_at hp hpo hx (k := 2) (by omega)
  have ⟨hf3, hb3⟩ := byte_at hp hpo hx (k := 3) (by omega)
  have ⟨hf4, hb4⟩ := byte_at hp hpo hx (k := 4) (by omega)
  have ⟨hf5, hb5⟩ := byte_at hp hpo hx (k := 5) (by omega)
  have ⟨hf6, hb6⟩ := byte_at hp hpo hx (k := 6) (by omega)
  have ⟨hf7, hb7⟩ := byte_at hp hpo hx (k := 7) (by omega)
  have ⟨hf8, hb8⟩ := byte_at hp hpo hx (k := 8) (by omega)
  have ⟨hf9, hb9⟩ := byte_at hp hpo hx (k := 9) (by omega)
  have ⟨hf10, hb10⟩ := byte_at hp hpo hx (k := 10) (by omega)
  have ⟨hf11, hb11⟩ := byte_at hp hpo hx (k := 11) (by omega)
  have ⟨hf12, hb12⟩ := byte_at hp hpo hx (k := 12) (by omega)
  have ⟨hf13, hb13⟩ := byte_at hp hpo hx (k := 13) (by omega)
  have ⟨hf14, hb14⟩ := byte_at hp hpo hx (k := 14) (by omega)
  have ⟨hf15, hb15⟩ := byte_at hp hpo hx (k := 15) (by omega)
  have ⟨hf16, hb16⟩ := byte_at hp hpo hx (k := 16) (by omega)
  have ⟨hf17, hb17⟩ := byte_at hp hpo hx (k := 17) (by omega)
  have ⟨hf18, hb18⟩ := byte_at hp hpo hx (k := 18) (by omega)
  have ⟨hf19, hb19⟩ := byte_at hp hpo hx (k := 19) (by omega)
  have ⟨hf20, hb20⟩ := byte_at hp hpo hx (k := 20) (by omega)
  have ⟨hf21, hb21⟩ := byte_at hp hpo hx (k := 21) (by omega)
  have ⟨hf22, hb22⟩ := byte_at hp hpo hx (k := 22) (by omega)
  have ⟨hf23, hb23⟩ := byte_at hp hpo hx (k := 23) (by omega)
  have ⟨hf24, hb24⟩ := byte_at hp hpo hx (k := 24) (by omega)
  have ⟨hf25, hb25⟩ := byte_at hp hpo hx (k := 25) (by omega)
  have ⟨hf26, hb26⟩ := byte_at hp hpo hx (k := 26) (by omega)
  have ⟨hf27, hb27⟩ := byte_at hp hpo hx (k := 27) (by omega)
  have ⟨hf28, hb28⟩ := byte_at hp hpo hx (k := 28) (by omega)
  have ⟨hf29, hb29⟩ := byte_at hp hpo hx (k := 29) (by omega)
  have ⟨hf30, hb30⟩ := byte_at hp hpo hx (k := 30) (by omega)
  have ⟨hf31, hb31⟩ := byte_at hp hpo hx (k := 31) (by omega)
  have hb0 : S.mem.readAt p 8 = x.setWidth 8 := MemoryState.readAt_of_readAt_le (by omega) hx
  have hf0 : Fits S.mem p 8 := hp.mono (by omega)
  block_init
  iterate 6 step_pure
  step_pure
  step_load
  step_pure
  step_pure with c9 hc9
  step_pure
  step_load
  step_pure
  step_load
  step_pure with a29 ha29
  step_pure
  step_load
  step_pure with a28 ha28
  step_pure
  step_load
  step_pure with a27 ha27
  step_pure
  step_load
  step_pure with a26 ha26
  step_pure
  step_load
  step_pure with a25 ha25
  step_pure
  step_load
  step_pure with a24 ha24
  step_pure
  step_load
  step_pure with a23 ha23
  step_pure
  step_load
  step_pure with a22 ha22
  step_pure
  step_load
  step_pure with a21 ha21
  step_pure
  step_load
  step_pure with a20 ha20
  step_pure
  step_load
  step_pure with a19 ha19
  step_pure
  step_load
  step_pure with a18 ha18
  step_pure
  step_load
  step_pure with a17 ha17
  step_pure
  step_load
  step_pure with a16 ha16
  step_pure
  step_load
  step_pure with a15 ha15
  step_pure
  step_load
  step_pure with a14 ha14
  step_pure
  step_load
  step_pure with a13 ha13
  step_pure
  step_load
  step_pure with a12 ha12
  step_pure
  step_load
  step_pure with a11 ha11
  step_pure
  step_load
  step_pure with a10 ha10
  step_pure
  step_load
  step_pure with a9 ha9
  step_pure
  step_load
  step_pure with a8 ha8
  step_pure
  step_load
  step_pure with a7 ha7
  step_pure
  step_load
  step_pure with a6 ha6
  step_pure
  step_load
  step_pure with a5 ha5
  step_pure
  step_load
  step_pure with a4 ha4
  step_pure
  step_load
  step_pure with a3 ha3
  step_pure
  step_load
  step_pure with a2 ha2
  step_pure
  step_load
  step_pure with a1 ha1
  step_pure with c99 hc99
  step_pure with c100 hc100
  step_pure with c101 hc101
  have o1 : c101.saddOverflow 511#16 = false := by
    subst hc101; bv_decide
  have o2 : c101.uaddOverflow 511#16 = false := by
    subst hc101; bv_decide
  step_pure [o1, o2] with c102 hc102
  step_load
  step_pure with c104 hc104
  have o3 : (236#16).ssubOverflow c104 = false := by
    subst hc104; bv_decide
  step_pure [o3] with c105 hc105
  iterate 3 step_pure
  finish_block
  have key : (c102 &&& c105) >>> 8 &&& 1#16 = Fe.rejectNonCanonical.spec x := by
    rw [Fe.rejectNonCanonical.spec_eq]
    subst hc105 hc104 hc102 hc101 hc100 hc99 hc9 ha1 ha2 ha3 ha4 ha5 ha6 ha7 ha8 ha9 ha10 ha11 ha12
      ha13 ha14 ha15 ha16 ha17 ha18 ha19 ha20 ha21 ha22 ha23 ha24 ha25 ha26 ha27 ha28 ha29
    bv_decide
  rw [hS, key]

end Proof

end LeanMLIR.RIR.Zig

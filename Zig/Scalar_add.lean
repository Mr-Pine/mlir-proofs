module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Scalar
public import Zig.Mlir.Scalar_add
import Std.Tactic.BVDecide
import Mathlib.Tactic.ClearExcept

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `x + y`: the limbs added with carries, `ℓ` subtracted with borrows, the difference kept unless
it borrowed out. -/
def Scalar.add.spec (x y : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let s0 := x 0 + y 0
  let s1 := x 1 + y 1 + (s0 >>> 56)
  let s2 := x 2 + y 2 + (s1 >>> 56)
  let s3 := x 3 + y 3 + (s2 >>> 56)
  let t0 := s0 &&& Scalar.mask
  let t1 := s1 &&& Scalar.mask
  let t2 := s2 &&& Scalar.mask
  let t3 := s3 &&& Scalar.mask
  let t4 := x 4 + y 4 + (s3 >>> 56)
  let b0 := (t0 - Scalar.ell 0) >>> 63
  let u0 := (b0 <<< 56) + t0 - Scalar.ell 0
  let b1 := (t1 - (Scalar.ell 1 + b0)) >>> 63
  let u1 := (b1 <<< 56) + t1 - (Scalar.ell 1 + b0)
  let b2 := (t2 - (Scalar.ell 2 + b1)) >>> 63
  let u2 := (b2 <<< 56) + t2 - (Scalar.ell 2 + b1)
  let b3 := (t3 - (Scalar.ell 3 + b2)) >>> 63
  let u3 := (b3 <<< 56) + t3 - (Scalar.ell 3 + b2)
  let b4 := (t4 - (Scalar.ell 4 + b3)) >>> 63
  let u4 := (b4 <<< 56) + t4 - (Scalar.ell 4 + b3)
  let m := b4 - 1#64
  Fe.mk5 (t0 ^^^ (m &&& (t0 ^^^ u0))) (t1 ^^^ (m &&& (t1 ^^^ u1))) (t2 ^^^ (m &&& (t2 ^^^ u2)))
    (t3 ^^^ (m &&& (t3 ^^^ u3))) (t4 ^^^ (m &&& (t4 ^^^ u4)))

end

/-! ## Proof -/

section Proof

set_option maxHeartbeats 1000000 in
/-- `Scalar.add` stores `spec a b` at `out`, for limbs below `2^56`. -/
public theorem Scalar_add.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 56)) (hb' : Fe.Lt (s.mem.readLimbs b) (2 ^ 56)) :
    Scalar_add.call (Scalar_add.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (Scalar.add.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have ha0 := Scalar.lt56 ((hS ▸ ha') 0)
  have ha1 := Scalar.lt56 ((hS ▸ ha') 1)
  have ha2 := Scalar.lt56 ((hS ▸ ha') 2)
  have ha3 := Scalar.lt56 ((hS ▸ ha') 3)
  have ha4 := Scalar.lt56 ((hS ▸ ha') 4)
  have hb0 := Scalar.lt56 ((hS ▸ hb') 0)
  have hb1 := Scalar.lt56 ((hS ▸ hb') 1)
  have hb2 := Scalar.lt56 ((hS ▸ hb') 2)
  have hb3 := Scalar.lt56 ((hS ▸ hb') 3)
  have hb4 := Scalar.lt56 ((hS ▸ hb') 4)
  clear ha' hb'
  block_init
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_load with x14 hx14
  have b14 : x14 < 72057594037927936#64 := by rw [hx14]; exact ha0
  step_load with x15 hx15
  have b15 : x15 < 72057594037927936#64 := by rw [hx15]; exact hb0
  have c16_0 : (x15).uaddOverflow (x14) = false := by clear * - hx14 b14 hx15 b15; bv_decide
  step_pure [c16_0] with x16 hx16
  clear c16_0
  step_pure with x17 hx17
  step_pure with x18 hx18
  step_pure
  step_load with x20 hx20
  have b20 : x20 < 72057594037927936#64 := by rw [hx20]; exact ha1
  step_pure
  step_load with x22 hx22
  have b22 : x22 < 72057594037927936#64 := by rw [hx22]; exact hb1
  have c23_0 : (x22).uaddOverflow (x20) = false := by clear * - hx20 b20 hx22 b22; bv_decide
  step_pure [c23_0] with x23 hx23
  clear c23_0
  have c24_0 : (x23).uaddOverflow (x17) = false := by clear * - hx16 hx17 hx20 b20 hx22 b22 hx23; bv_decide
  step_pure [c24_0] with x24 hx24
  clear c24_0
  step_pure with x25 hx25
  step_pure with x26 hx26
  step_pure
  step_load with x28 hx28
  have b28 : x28 < 72057594037927936#64 := by rw [hx28]; exact ha2
  step_pure
  step_load with x30 hx30
  have b30 : x30 < 72057594037927936#64 := by rw [hx30]; exact hb2
  have c31_0 : (x30).uaddOverflow (x28) = false := by clear * - hx28 b28 hx30 b30; bv_decide
  step_pure [c31_0] with x31 hx31
  clear c31_0
  have c32_0 : (x31).uaddOverflow (x25) = false := by clear * - hx24 hx25 hx28 b28 hx30 b30 hx31; bv_decide
  step_pure [c32_0] with x32 hx32
  clear c32_0
  step_pure with x33 hx33
  step_pure with x34 hx34
  step_pure
  step_load with x36 hx36
  have b36 : x36 < 72057594037927936#64 := by rw [hx36]; exact ha3
  step_pure
  step_load with x38 hx38
  have b38 : x38 < 72057594037927936#64 := by rw [hx38]; exact hb3
  have c39_0 : (x38).uaddOverflow (x36) = false := by clear * - hx36 b36 hx38 b38; bv_decide
  step_pure [c39_0] with x39 hx39
  clear c39_0
  have c40_0 : (x39).uaddOverflow (x33) = false := by clear * - hx32 hx33 hx36 b36 hx38 b38 hx39; bv_decide
  step_pure [c40_0] with x40 hx40
  clear c40_0
  step_pure with x41 hx41
  step_pure with x42 hx42
  step_pure
  step_load with x44 hx44
  have b44 : x44 < 72057594037927936#64 := by rw [hx44]; exact ha4
  step_pure
  step_load with x46 hx46
  have b46 : x46 < 72057594037927936#64 := by rw [hx46]; exact hb4
  have c47_0 : (x46).uaddOverflow (x44) = false := by clear * - hx44 b44 hx46 b46; bv_decide
  step_pure [c47_0] with x47 hx47
  clear c47_0
  have c48_0 : (x47).uaddOverflow (x41) = false := by clear * - hx40 hx41 hx44 b44 hx46 b46 hx47; bv_decide
  step_pure [c48_0] with x48 hx48
  clear c48_0
  have c49_0 : (x18).saddOverflow (18441568559248845843#64) = false := by clear * - hx18; bv_decide
  step_pure [c49_0] with x49 hx49
  clear c49_0
  step_pure with x50 hx50
  have c51_0 : (x50) <<< 56 >>> 56 = x50 := by clear * - hx50; bv_decide
  have c51_1 : ((x50) <<< 56).sshiftRight 56 = x50 := by clear * - hx50; bv_decide
  step_pure [c51_0, c51_1] with x51 hx51
  clear c51_0 c51_1
  have c52_0 : (x49).saddOverflow (x51) = false := by clear * - hx18 hx49 hx50 hx51; bv_decide
  step_pure [c52_0] with x52 hx52
  clear c52_0
  have c53_0 : (x50) &&& (70332060721272408#64) = 0#64 := by clear * - hx50; bv_decide
  step_pure [c53_0] with x53 hx53
  clear c53_0
  step_pure with x54 hx54
  step_pure with x55 hx55
  have c56_0 : (x26).ssubOverflow (x53) = false := by clear * - hx24 hx26 hx50 hx53; bv_decide
  step_pure [c56_0] with x56 hx56
  clear c56_0
  have c57_0 : (x56).saddOverflow (x55) = false := by clear * - hx24 hx26 hx50 hx53 hx54 hx55 hx56; bv_decide
  step_pure [c57_0] with x57 hx57
  clear c57_0
  step_pure with x58 hx58
  step_pure with x59 hx59
  step_pure with x60 hx60
  step_pure with x61 hx61
  step_pure with x62 hx62
  have c63_0 : (x58).saddOverflow (x34) = false := by clear * - hx34 hx58; bv_decide
  step_pure [c63_0] with x63 hx63
  clear c63_0
  have c64_0 : (x63).saddOverflow (x62) = false := by clear * - hx34 hx58 hx60 hx62 hx63; bv_decide
  step_pure [c64_0] with x64 hx64
  clear c64_0
  step_pure with x65 hx65
  step_pure with x66 hx66
  step_pure with x67 hx67
  have c68_0 : (x42).saddOverflow (x61) = false := by clear * - hx42 hx61; bv_decide
  step_pure [c68_0] with x68 hx68
  clear c68_0
  have c69_0 : (x68).saddOverflow (x67) = false := by clear * - hx42 hx61 hx66 hx67 hx68; bv_decide
  step_pure [c69_0] with x69 hx69
  clear c69_0
  step_pure with x70 hx70
  step_pure with x71 hx71
  step_pure with x72 hx72
  have c73_0 : (x72) <<< 56 >>> 56 = x72 := by clear * - hx72; bv_decide
  have c73_1 : ((x72) <<< 56).sshiftRight 56 = x72 := by clear * - hx72; bv_decide
  step_pure [c73_0, c73_1] with x73 hx73
  clear c73_0 c73_1
  step_pure with x74 hx74
  have c75_0 : (x72).saddOverflow (18446744073709551615#64) = false := by clear * - hx72; bv_decide
  step_pure [c75_0] with x75 hx75
  clear c75_0
  step_pure with x76 hx76
  step_pure with x77 hx77
  step_pure with x78 hx78
  step_pure with x79 hx79
  step_pure with x80 hx80
  step_pure with x81 hx81
  step_pure with x82 hx82
  step_pure with x83 hx83
  step_pure with x84 hx84
  step_pure with x85 hx85
  step_pure with x86 hx86
  step_pure with x87 hx87
  step_pure with x88 hx88
  step_pure with x89 hx89
  step_pure with x90 hx90
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  finish_block
  have hA : S₀.mem.readLimbs a = Fe.mk5 x14 x20 x28 x36 x44 := by
    funext i
    fin_cases i
    · exact hx14.symm
    · exact hx20.symm
    · exact hx28.symm
    · exact hx36.symm
    · exact hx44.symm
  have hB : S₀.mem.readLimbs b = Fe.mk5 x15 x22 x30 x38 x46 := by
    funext i
    fin_cases i
    · exact hx15.symm
    · exact hx22.symm
    · exact hx30.symm
    · exact hx38.symm
    · exact hx46.symm
  rw [hS, hA, hB, storeLimbs_of_eq ?_ ?_ ?_ ?_ ?_] <;>
    clear hA hB hS hE <;> simp only [Scalar.add.spec, Scalar.ell, Fe.mk5] <;> bv_decide

/-- `call_eq` on the limbs `A`, `B` read at `a`, `b`. -/
public theorem Scalar_add.call_eq_of (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hA : s.mem.readLimbs a = A) (hB : s.mem.readLimbs b = B) (hA' : Fe.Lt A (2 ^ 56))
    (hB' : Fe.Lt B (2 ^ 56)) :
    Scalar_add.call (Scalar_add.args (.value out) (.value a) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs out (Scalar.add.spec A B) }) := by
  subst hA hB
  exact Scalar_add.call_eq out a b s hwf hout ha hb hA' hB'

end Proof

/-! ## Meaning -/

section Meaning

/-- `spec` on limbs below `2^56` and wide values below `ℓ`: limbs below `2^56`, the sum less `ℓ` unless
below it. -/
theorem Scalar.add.wide_spec (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : BitVec 64)
    (hx0 : x0 < 72057594037927936#64) (hx1 : x1 < 72057594037927936#64)
    (hx2 : x2 < 72057594037927936#64) (hx3 : x3 < 72057594037927936#64)
    (hx4 : x4 < 72057594037927936#64)
    (hy0 : y0 < 72057594037927936#64) (hy1 : y1 < 72057594037927936#64)
    (hy2 : y2 < 72057594037927936#64) (hy3 : y3 < 72057594037927936#64)
    (hy4 : y4 < 72057594037927936#64)
    (hX : Scalar.wide (Fe.mk5 x0 x1 x2 x3 x4) < Scalar.ell320)
    (hY : Scalar.wide (Fe.mk5 y0 y1 y2 y3 y4) < Scalar.ell320) :
    (∀ i, Scalar.add.spec (Fe.mk5 x0 x1 x2 x3 x4) (Fe.mk5 y0 y1 y2 y3 y4) i < 72057594037927936#64) ∧
    Scalar.wide (Scalar.add.spec (Fe.mk5 x0 x1 x2 x3 x4) (Fe.mk5 y0 y1 y2 y3 y4)) =
      (let s := Scalar.wide (Fe.mk5 x0 x1 x2 x3 x4) + Scalar.wide (Fe.mk5 y0 y1 y2 y3 y4)
       if s < Scalar.ell320 then s else s - Scalar.ell320) := by
  simp only [Scalar.wide, Fe.mk5] at *
  refine ⟨fun i => ?_, ?_⟩
  · fin_cases i <;> simp only [Scalar.add.spec, Scalar.ell, Fe.mk5] <;> bv_decide
  · simp only [Scalar.add.spec, Scalar.ell, Fe.mk5]
    bv_decide

/-- `spec` of canonical limbs is canonical, of the sum mod `ℓ`. -/
public theorem Scalar.add.spec_canonical {x y : Fin 5 → BitVec 64} (hx : Scalar.Canonical x)
    (hy : Scalar.Canonical y) :
    Scalar.Canonical (Scalar.add.spec x y) ∧
      Scalar.val (Scalar.add.spec x y) = (Scalar.val x + Scalar.val y) % Ed25519.ell := by
  obtain ⟨x0, x1, x2, x3, x4, rfl⟩ : ∃ x0 x1 x2 x3 x4, x = Fe.mk5 x0 x1 x2 x3 x4 :=
    ⟨_, _, _, _, _, Fe.eta5 x⟩
  obtain ⟨y0, y1, y2, y3, y4, rfl⟩ : ∃ y0 y1 y2 y3 y4, y = Fe.mk5 y0 y1 y2 y3 y4 :=
    ⟨_, _, _, _, _, Fe.eta5 y⟩
  obtain ⟨hxl, hxv⟩ := hx
  obtain ⟨hyl, hyv⟩ := hy
  obtain ⟨hz, hw⟩ := Scalar.add.wide_spec x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 (Scalar.lt56 (hxl 0)) (Scalar.lt56 (hxl 1))
    (Scalar.lt56 (hxl 2)) (Scalar.lt56 (hxl 3)) (Scalar.lt56 (hxl 4)) (Scalar.lt56 (hyl 0)) (Scalar.lt56 (hyl 1)) (Scalar.lt56 (hyl 2))
    (Scalar.lt56 (hyl 3)) (Scalar.lt56 (hyl 4)) (Scalar.wide_lt_ell ⟨hxl, hxv⟩) (Scalar.wide_lt_ell ⟨hyl, hyv⟩)
  have hzl : Fe.Lt (Scalar.add.spec (Fe.mk5 x0 x1 x2 x3 x4) (Fe.mk5 y0 y1 y2 y3 y4)) (2 ^ 56) :=
    fun i => BitVec.lt_def.mp (hz i)
  have hzw := Scalar.toNat_wide hzl
  have hxw := Scalar.toNat_wide hxl
  have hyw := Scalar.toNat_wide hyl
  have hell : Ed25519.ell < 2 ^ 253 := Ed25519.ell_lt
  have hL := Scalar.toNat_ell320
  have hmod : (Scalar.val (Fe.mk5 x0 x1 x2 x3 x4) + Scalar.val (Fe.mk5 y0 y1 y2 y3 y4)) %
      Ed25519.ell = if Scalar.val (Fe.mk5 x0 x1 x2 x3 x4) + Scalar.val (Fe.mk5 y0 y1 y2 y3 y4) <
        Ed25519.ell then Scalar.val (Fe.mk5 x0 x1 x2 x3 x4) + Scalar.val (Fe.mk5 y0 y1 y2 y3 y4)
      else Scalar.val (Fe.mk5 x0 x1 x2 x3 x4) + Scalar.val (Fe.mk5 y0 y1 y2 y3 y4) - Ed25519.ell := by
    split
    · exact Nat.mod_eq_of_lt ‹_›
    · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]
  rw [hmod]
  refine ⟨⟨hzl, ?_⟩, ?_⟩ <;> rw [← hzw, hw] <;> dsimp only <;>
    generalize Scalar.wide (Fe.mk5 x0 x1 x2 x3 x4) = X at * <;>
    generalize Scalar.wide (Fe.mk5 y0 y1 y2 y3 y4) = Y at * <;>
    generalize Scalar.ell320 = L at * <;>
    generalize Ed25519.ell = l at * <;>
    split <;> rename_i h <;>
    simp only [BitVec.lt_def, BitVec.toNat_add] at h <;>
    (try rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, BitVec.toNat_add]; omega)]) <;>
    simp only [BitVec.toNat_add] <;> (try split) <;> omega

end Meaning

end LeanMLIR.RIR.Zig

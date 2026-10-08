module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Scalar
public import Zig.Mlir.Scalar_fromBytes
import Std.Tactic.BVDecide
import Mathlib.Tactic.ClearExcept

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- Barrett reduction of the bytes `b` (little-endian): the quotient estimate `k` from the top
byte and `μ = ⌊2^512 / ℓ⌋`, then `b - k ℓ`, less `ℓ` unless below it. -/
def Scalar.fromBytes.spec (b : BitVec 256) : Fin 5 → BitVec 64 :=
  let x := b.setWidth 320
  let k :=
    ((x >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#320) >>>
      264
  let r := x - k * Scalar.ell320
  Scalar.limbs (if r < Scalar.ell320 then r else r - Scalar.ell320)

end

/-! ## Proof -/

section Proof

set_option maxHeartbeats 4000000 in
/-- `Scalar.fromBytes` stores `spec b` at `out`, for the 32 bytes `b` at `p`. -/
public theorem Scalar_fromBytes.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hp : Fits s.mem p 256) :
    Scalar_fromBytes.call (Scalar_fromBytes.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Scalar.fromBytes.spec (s.mem.readAt p 256)) }) := by
  func_init
  have hwf₀ : S₀.WF := hS ▸ hwf
  have hp₀ : Fits S₀.mem p 256 := hS ▸ hp
  block_init
  iterate 28 step_pure
  step_alloca with lw
  step_alloca with buf
  have hlwL : S.mem.LimbsFit lw := MemoryState.LimbsFit.of_fits (hlw_fits.mono (by omega)) hlw_off
  iterate 2 step_pure
  step_memcpy
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (0#64).smulOverflow 7#64 = false), (by decide : (0#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld0 hld0
  step_pure with m0 hm0
  step_store
  step_pure [(by decide : (0#64).saddOverflow 1#64 = false), (by decide : (0#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (1#64).smulOverflow 7#64 = false), (by decide : (1#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld1 hld1
  step_pure with m1 hm1
  step_store
  step_pure [(by decide : (1#64).saddOverflow 1#64 = false), (by decide : (1#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (2#64).smulOverflow 7#64 = false), (by decide : (2#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld2 hld2
  step_pure with m2 hm2
  step_store
  step_pure [(by decide : (2#64).saddOverflow 1#64 = false), (by decide : (2#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_pure [(by decide : (3#64).smulOverflow 7#64 = false), (by decide : (3#64).umulOverflow 7#64 = false)]
  step_pure
  step_load with ld3 hld3
  step_pure with m3 hm3
  step_store
  step_pure [(by decide : (3#64).saddOverflow 1#64 = false), (by decide : (3#64).uaddOverflow 1#64 = false)]
  finish_block
  block_init
  step_pure
  finish_block
  block_init
  step_pure
  step_load with x39 hx39
  step_pure with x40 hx40
  step_load with x41 hx41
  step_pure
  step_load with x43 hx43
  step_pure
  step_load with x45 hx45
  step_pure
  step_load with x47 hx47
  step_pure
  step_pure
  step_pure with x48 hx48
  have c49_0 : (x48).msb = false := by clear * - hx48; bv_decide
  step_pure [c49_0] with x49 hx49
  clear c49_0
  have c50_0 : (x49).smulOverflow (44162584779952923#128) = false := by clear * - hx49; bv_decide
  have c50_1 : (x49).umulOverflow (44162584779952923#128) = false := by clear * - hx49; bv_decide
  step_pure [c50_0, c50_1] with x50 hx50
  clear c50_0 c50_1
  have c51_0 : (x49).smulOverflow (9390964836247533#128) = false := by clear * - hx49; bv_decide
  have c51_1 : (x49).umulOverflow (9390964836247533#128) = false := by clear * - hx49; bv_decide
  step_pure [c51_0, c51_1] with x51 hx51
  clear c51_0 c51_1
  have c52_0 : (x49).smulOverflow (72057594036560134#128) = false := by clear * - hx49; bv_decide
  have c52_1 : (x49).umulOverflow (72057594036560134#128) = false := by clear * - hx49; bv_decide
  step_pure [c52_0, c52_1] with x52 hx52
  clear c52_0 c52_1
  have c53_0 : (x49).smulOverflow (72057594037927935#128) = false := by clear * - hx49; bv_decide
  have c53_1 : (x49).umulOverflow (72057594037927935#128) = false := by clear * - hx49; bv_decide
  step_pure [c53_0, c53_1] with x53 hx53
  clear c53_0 c53_1
  have c54_0 : (x49).smulOverflow (68719476735#128) = false := by clear * - hx49; bv_decide
  have c54_1 : (x49).umulOverflow (68719476735#128) = false := by clear * - hx49; bv_decide
  step_pure [c54_0, c54_1] with x54 hx54
  clear c54_0 c54_1
  step_pure with x55 hx55
  have c56_0 : (x55).saddOverflow (x51) = false := by clear * - hx49 hx50 hx51 hx55; bv_decide
  have c56_1 : (x55).uaddOverflow (x51) = false := by clear * - hx49 hx50 hx51 hx55; bv_decide
  step_pure [c56_0, c56_1] with x56 hx56
  clear c56_0 c56_1
  step_pure with x57 hx57
  have c58_0 : (x57).saddOverflow (x52) = false := by clear * - hx49 hx52 hx56 hx57; bv_decide
  have c58_1 : (x57).uaddOverflow (x52) = false := by clear * - hx49 hx52 hx56 hx57; bv_decide
  step_pure [c58_0, c58_1] with x58 hx58
  clear c58_0 c58_1
  step_pure with x59 hx59
  have c60_0 : (x59).saddOverflow (x53) = false := by clear * - hx49 hx53 hx58 hx59; bv_decide
  have c60_1 : (x59).uaddOverflow (x53) = false := by clear * - hx49 hx53 hx58 hx59; bv_decide
  step_pure [c60_0, c60_1] with x60 hx60
  clear c60_0 c60_1
  step_pure with x61 hx61
  have c62_0 : (x61).saddOverflow (x54) = false := by clear * - hx49 hx54 hx60 hx61; bv_decide
  have c62_1 : (x61).uaddOverflow (x54) = false := by clear * - hx49 hx54 hx60 hx61; bv_decide
  step_pure [c62_0, c62_1] with x62 hx62
  clear c62_0 c62_1
  have c63_0 : ((x62).setWidth 64).setWidth 128 = x62 := by clear * - hx39 hx40 hx48 hx49 hx52 hx53 hx54 hx57 hx58 hx59 hx60 hx61 hx62; bv_decide
  have c63_1 : ((x62).setWidth 64).signExtend 128 = x62 := by clear * - hx39 hx40 hx48 hx49 hx52 hx53 hx54 hx57 hx58 hx59 hx60 hx61 hx62; bv_decide
  step_pure [c63_0, c63_1] with x63 hx63
  clear c63_0 c63_1
  step_pure with x64 hx64
  have c65_0 : (x64).msb = false := by clear * - hx64; bv_decide
  step_pure [c65_0] with x65 hx65
  clear c65_0
  have c66_0 : (x65).smulOverflow (5175514460705773#128) = false := by clear * - hx65; bv_decide
  have c66_1 : (x65).umulOverflow (5175514460705773#128) = false := by clear * - hx65; bv_decide
  step_pure [c66_0, c66_1] with x66 hx66
  clear c66_0 c66_1
  have c67_0 : (x65).smulOverflow (70332060721272408#128) = false := by clear * - hx65; bv_decide
  have c67_1 : (x65).umulOverflow (70332060721272408#128) = false := by clear * - hx65; bv_decide
  step_pure [c67_0, c67_1] with x67 hx67
  clear c67_0 c67_1
  have c68_0 : (x65).smulOverflow (18446744073709546274#128) = false := by clear * - hx64 hx65; bv_decide
  have c68_1 : (x65).umulOverflow (18446744073709546274#128) = false := by clear * - hx65; bv_decide
  step_pure [c68_0, c68_1] with x68 hx68
  clear c68_0 c68_1
  have c69_0 : (x64) <<< 28 >>> 28 = x64 := by clear * - hx64; bv_decide
  have c69_1 : ((x64) <<< 28).sshiftRight 28 = x64 := by clear * - hx64; bv_decide
  step_pure [c69_0, c69_1] with x69 hx69
  clear c69_0 c69_1
  step_pure with x70 hx70
  have c71_0 : ((x66).setWidth 64).setWidth 128 = x66 := by clear * - hx39 hx40 hx48 hx49 hx50 hx51 hx52 hx53 hx54 hx55 hx56 hx57 hx58 hx59 hx60 hx61 hx62 hx63 hx64 hx65 hx66; bv_decide
  have c71_1 : ((x66).setWidth 64).signExtend 128 = x66 := by clear * - hx39 hx40 hx48 hx49 hx50 hx51 hx52 hx53 hx54 hx55 hx56 hx57 hx58 hx59 hx60 hx61 hx62 hx63 hx64 hx65 hx66; bv_decide
  step_pure [c71_0, c71_1] with x71 hx71
  clear c71_0 c71_1
  step_pure with x72 hx72
  have c73_0 : (x70).saddOverflow (x67) = false := by clear * - hx65 hx66 hx67 hx70; bv_decide
  have c73_1 : (x70).uaddOverflow (x67) = false := by clear * - hx65 hx66 hx67 hx70; bv_decide
  step_pure [c73_0, c73_1] with x73 hx73
  clear c73_0 c73_1
  step_pure with x74 hx74
  have c75_0 : ((x73).setWidth 64).setWidth 128 = x73 := by clear * - hx39 hx40 hx48 hx49 hx50 hx51 hx52 hx53 hx54 hx55 hx56 hx57 hx58 hx59 hx60 hx61 hx62 hx63 hx64 hx65 hx66 hx67 hx70 hx73; bv_decide
  have c75_1 : ((x73).setWidth 64).signExtend 128 = x73 := by clear * - hx39 hx40 hx48 hx49 hx50 hx51 hx52 hx53 hx54 hx55 hx56 hx57 hx58 hx59 hx60 hx61 hx62 hx63 hx64 hx65 hx66 hx67 hx70 hx73; bv_decide
  step_pure [c75_0, c75_1] with x75 hx75
  clear c75_0 c75_1
  step_pure with x76 hx76
  have c77_0 : (x68).ssubOverflow (x74) = false := by clear * - hx64 hx65 hx67 hx68 hx70 hx73 hx74; bv_decide
  step_pure [c77_0] with x77 hx77
  clear c77_0
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
  step_pure with x91 hx91
  step_pure with x92 hx92
  step_pure with x93 hx93
  step_pure with x94 hx94
  have c95_0 : (x94) <<< 56 >>> 56 = x94 := by clear * - hx94; bv_decide
  have c95_1 : ((x94) <<< 56).sshiftRight 56 = x94 := by clear * - hx94; bv_decide
  step_pure [c95_0, c95_1] with x95 hx95
  clear c95_0 c95_1
  step_pure with x96 hx96
  step_pure with x97 hx97
  step_pure with x98 hx98
  have c99_0 : (x98) <<< 56 >>> 56 = x98 := by clear * - hx98; bv_decide
  have c99_1 : ((x98) <<< 56).sshiftRight 56 = x98 := by clear * - hx98; bv_decide
  step_pure [c99_0, c99_1] with x99 hx99
  clear c99_0 c99_1
  step_pure with x100 hx100
  step_pure with x101 hx101
  have c102_0 : (x98) &&& (x79) = 0#64 := by clear * - hx79 hx98; bv_decide
  step_pure [c102_0] with x102 hx102
  clear c102_0
  step_pure with x103 hx103
  step_pure with x104 hx104
  have c105_0 : (x104) &&& (x40) = 0#64 := by clear * - hx104 hx40; bv_decide
  step_pure [c105_0] with x105 hx105
  clear c105_0
  have c106_0 : (x105).ssubOverflow (x102) = false := by clear * - hx102 hx104 hx105 hx40 hx79 hx98; bv_decide
  step_pure [c106_0] with x106 hx106
  clear c106_0
  step_pure with x107 hx107
  step_pure with x108 hx108
  have c109_0 : (x108) <<< 56 >>> 56 = x108 := by clear * - hx108; bv_decide
  have c109_1 : ((x108) <<< 56).sshiftRight 56 = x108 := by clear * - hx108; bv_decide
  step_pure [c109_0, c109_1] with x109 hx109
  clear c109_0 c109_1
  step_pure with x110 hx110
  have c111_0 : (x108) &&& (70332060721272408#64) = 0#64 := by clear * - hx108; bv_decide
  step_pure [c111_0] with x111 hx111
  clear c111_0
  step_pure with x112 hx112
  step_pure with x113 hx113
  have c114_0 : (x113) <<< 56 >>> 56 = x113 := by clear * - hx113; bv_decide
  have c114_1 : ((x113) <<< 56).sshiftRight 56 = x113 := by clear * - hx113; bv_decide
  step_pure [c114_0, c114_1] with x114 hx114
  clear c114_0 c114_1
  step_pure with x115 hx115
  have c116_0 : (x113) &&& (5342#64) = 0#64 := by clear * - hx113; bv_decide
  step_pure [c116_0] with x116 hx116
  clear c116_0
  step_pure with x117 hx117
  step_pure with x118 hx118
  step_pure with x119 hx119
  have c120_0 : (x119) <<< 56 >>> 56 = x119 := by clear * - hx119; bv_decide
  have c120_1 : ((x119) <<< 56).sshiftRight 56 = x119 := by clear * - hx119; bv_decide
  step_pure [c120_0, c120_1] with x120 hx120
  clear c120_0 c120_1
  step_pure with x121 hx121
  step_pure with x122 hx122
  step_pure with x123 hx123
  have c124_0 : (x123) <<< 56 >>> 56 = x123 := by clear * - hx123; bv_decide
  have c124_1 : ((x123) <<< 56).sshiftRight 56 = x123 := by clear * - hx123; bv_decide
  step_pure [c124_0, c124_1] with x124 hx124
  clear c124_0 c124_1
  step_pure with x125 hx125
  step_pure with x126 hx126
  have c127_0 : (x123) &&& (268435456#64) = 0#64 := by clear * - hx123; bv_decide
  step_pure [c127_0] with x127 hx127
  clear c127_0
  step_pure with x128 hx128
  step_pure with x129 hx129
  step_pure with x130 hx130
  step_pure with x131 hx131
  step_pure with x132 hx132
  step_pure with x133 hx133
  have c134_0 : (x106).ssubOverflow (x133) = false := by clear * - hx102 hx104 hx105 hx106 hx123 hx127 hx128 hx133 hx40 hx79 hx98; bv_decide
  step_pure [c134_0] with x134 hx134
  clear c134_0
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
  have hF : Fits ((S₀.alloca 80).alloca 32).mem lw 640 := by
    have := hlw_fits; rw [hS] at this; simpa [Fits.storeAt_iff] using this
  obtain ⟨-, -, f1, f2, f3, -⟩ := MemoryState.LimbsFit.of_fits (hF.mono (by omega)) hlw_off
  simp only [Tactic.readThroughStore] at hx43 hx45 hx47
  have hc : Scalar.fromBytes.spec (S₀.mem.readAt p 256) 0 = x129 ∧
      Scalar.fromBytes.spec (S₀.mem.readAt p 256) 1 = x130 ∧
      Scalar.fromBytes.spec (S₀.mem.readAt p 256) 2 = x131 ∧
      Scalar.fromBytes.spec (S₀.mem.readAt p 256) 3 = x132 ∧
      Scalar.fromBytes.spec (S₀.mem.readAt p 256) 4 = x134 := by
    clear hS hE hArgs
    simp only [Scalar.fromBytes.spec, Scalar.limbs, Scalar.ell320, Fe.mk5]
    bv_decide
  obtain ⟨c0, c1, c2, c3, c4⟩ := hc
  rw [hS, storeLimbs_of_eq c0 c1 c2 c3 c4]
  erase_frame
  rfl

end Proof

/-! ## Meaning -/

section Meaning

/-- Barrett's bound for 32 bytes with top byte `q`: `k ℓ ≤ q 2^248` and `(q + 1) 2^248 ≤ (k + 2) ℓ`
for the estimate `k`. -/
theorem Scalar.fromBytes.barrett : ∀ q < 256,
    q * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 * Ed25519.ell ≤ q * 2 ^ 248 ∧
      (q + 1) * 2 ^ 248 ≤ (q * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 + 2) * Ed25519.ell := by
  unfold Ed25519.ell
  decide +kernel

set_option exponentiation.threshold 320 in
/-- `spec b` is canonical, of the bytes' value mod `ℓ`. -/
public theorem Scalar.fromBytes.spec_canonical (b : BitVec 256) :
    Scalar.Canonical (Scalar.fromBytes.spec b) ∧
      Scalar.val (Scalar.fromBytes.spec b) = b.toNat % Ed25519.ell := by
  have hN := b.isLt
  have hell := Ed25519.ell_lt
  have hL := Scalar.toNat_ell320
  have hx : (b.setWidth 320).toNat = b.toNat := by
    rw [BitVec.toNat_setWidth]; exact Nat.mod_eq_of_lt (by omega)
  have hq : b.toNat / 2 ^ 248 < 256 := by omega
  have hk : (((b.setWidth 320 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#320) >>> 264).toNat =
      b.toNat / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 := by
    rw [BitVec.toNat_ushiftRight, BitVec.toNat_mul, BitVec.toNat_ushiftRight, hx,
      Nat.shiftRight_eq_div_pow, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
    congr 1
    omega
  obtain ⟨hb1, hb2⟩ := Scalar.fromBytes.barrett _ hq
  generalize hK : b.toNat / 2 ^ 248 * 1852673427797059126777135760139006525645217721299241702126143248052143860224795 / 2 ^ 264 = K at hk hb1 hb2
  have hK16 : K < 16 := by subst hK; omega
  have hkL : ((((b.setWidth 320 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#320) >>> 264) * Scalar.ell320).toNat = K * Ed25519.ell := by
    rw [BitVec.toNat_mul, hk, hL]
    exact Nat.mod_eq_of_lt (by
      have : K * Ed25519.ell ≤ 15 * Ed25519.ell := Nat.mul_le_mul_right _ (by omega)
      omega)
  have hle : K * Ed25519.ell ≤ b.toNat := by omega
  have hr : (b.setWidth 320 - (((b.setWidth 320 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#320) >>> 264) * Scalar.ell320).toNat =
      b.toNat - K * Ed25519.ell := by
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hkL, hx]; exact hle), hkL, hx]
  have hmod : (b.toNat - K * Ed25519.ell) % Ed25519.ell = b.toNat % Ed25519.ell := by
    have := Nat.sub_mul_mod (show Ed25519.ell * K ≤ b.toNat by rw [Nat.mul_comm]; exact hle)
    rwa [Nat.mul_comm] at this
  unfold Scalar.fromBytes.spec
  dsimp only
  generalize b.setWidth 320 - (((b.setWidth 320 >>> 248) * 1852673427797059126777135760139006525645217721299241702126143248052143860224795#320) >>> 264) * Scalar.ell320 = r at hr
  rw [Nat.add_mul, Nat.add_mul] at hb2
  generalize K * Ed25519.ell = P at hle hb1 hb2 hr hmod
  have hlt : b.toNat - P < 2 * Ed25519.ell := by omega
  split
  · rename_i h
    rw [BitVec.lt_def, hr, hL] at h
    obtain ⟨h1, h2⟩ := Scalar.limbs_lt_val (z := r) (by omega)
    rw [Nat.mod_eq_of_lt h] at hmod
    exact ⟨⟨h1, by omega⟩, by omega⟩
  · rename_i h
    rw [BitVec.lt_def, hr, hL] at h
    have hs : (r - Scalar.ell320).toNat = b.toNat - P - Ed25519.ell := by
      rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hr, hL]; omega), hr, hL]
    obtain ⟨h1, h2⟩ := Scalar.limbs_lt_val (z := r - Scalar.ell320) (by omega)
    rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)] at hmod
    exact ⟨⟨h1, by omega⟩, by omega⟩

end Meaning

end LeanMLIR.RIR.Zig

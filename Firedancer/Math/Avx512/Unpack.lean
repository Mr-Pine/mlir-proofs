module

public import Firedancer.Math.Avx512.R43x6
public import Firedancer.Avx512.fd_r43x6_unpack
import Std.Tactic.BVDecide
import Mathlib.Tactic.NormNum

/-! `fd_r43x6_unpack` in `ZMod p`: the 256-bit little-endian integer of a `wv_t`, cut into five
43-bit limbs and a 41-bit one. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

open LeanMLIR.RIR.Firedancer.Ref (p)

namespace R43x6

@[expose] public section

/-- A `wv_t`'s 256-bit integer, lane 0 lowest. -/
def wvNat (u : Wv) : ℕ :=
  u[0].toNat + u[1].toNat * 2 ^ 64 + u[2].toNat * 2 ^ 128 + u[3].toNat * 2 ^ 192

end

/-! ## Lanes -/

theorem extract64_0 (x : BitVec 512) :
    x.extractLsb' 0 64 =
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
        x.extractLsb' 24 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 0 8 := by
  bv_decide

theorem extract64_1 (x : BitVec 512) :
    x.extractLsb' 64 64 =
      x.extractLsb' 120 8 ++ x.extractLsb' 112 8 ++ x.extractLsb' 104 8 ++ x.extractLsb' 96 8 ++
        x.extractLsb' 88 8 ++ x.extractLsb' 80 8 ++ x.extractLsb' 72 8 ++ x.extractLsb' 64 8 := by
  bv_decide

theorem extract64_2 (x : BitVec 512) :
    x.extractLsb' 128 64 =
      x.extractLsb' 184 8 ++ x.extractLsb' 176 8 ++ x.extractLsb' 168 8 ++ x.extractLsb' 160 8 ++
        x.extractLsb' 152 8 ++ x.extractLsb' 144 8 ++ x.extractLsb' 136 8 ++
        x.extractLsb' 128 8 := by
  bv_decide

theorem extract64_3 (x : BitVec 512) :
    x.extractLsb' 192 64 =
      x.extractLsb' 248 8 ++ x.extractLsb' 240 8 ++ x.extractLsb' 232 8 ++ x.extractLsb' 224 8 ++
        x.extractLsb' 216 8 ++ x.extractLsb' 208 8 ++ x.extractLsb' 200 8 ++
        x.extractLsb' 192 8 := by
  bv_decide

theorem extract64_4 (x : BitVec 512) :
    x.extractLsb' 256 64 =
      x.extractLsb' 312 8 ++ x.extractLsb' 304 8 ++ x.extractLsb' 296 8 ++ x.extractLsb' 288 8 ++
        x.extractLsb' 280 8 ++ x.extractLsb' 272 8 ++ x.extractLsb' 264 8 ++
        x.extractLsb' 256 8 := by
  bv_decide

theorem extract64_5 (x : BitVec 512) :
    x.extractLsb' 320 64 =
      x.extractLsb' 376 8 ++ x.extractLsb' 368 8 ++ x.extractLsb' 360 8 ++ x.extractLsb' 352 8 ++
        x.extractLsb' 344 8 ++ x.extractLsb' 336 8 ++ x.extractLsb' 328 8 ++
        x.extractLsb' 320 8 := by
  bv_decide

theorem extract64_6 (x : BitVec 512) :
    x.extractLsb' 384 64 =
      x.extractLsb' 440 8 ++ x.extractLsb' 432 8 ++ x.extractLsb' 424 8 ++ x.extractLsb' 416 8 ++
        x.extractLsb' 408 8 ++ x.extractLsb' 400 8 ++ x.extractLsb' 392 8 ++
        x.extractLsb' 384 8 := by
  bv_decide

theorem extract64_7 (x : BitVec 512) :
    x.extractLsb' 448 64 =
      x.extractLsb' 504 8 ++ x.extractLsb' 496 8 ++ x.extractLsb' 488 8 ++ x.extractLsb' 480 8 ++
        x.extractLsb' 472 8 ++ x.extractLsb' 464 8 ++ x.extractLsb' 456 8 ++
        x.extractLsb' 448 8 := by
  bv_decide

/-- `perm`'s byte indices. -/
theorem perm_idx :
    permutexvarIdx
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f) =
      #v[0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16,
        17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63,
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63] := by
  ext i hi : 1
  simp only [permutexvarIdx, wwl, Vector.getElem_ofFn]
  revert i; decide

set_option hygiene false in
/-- A lane of `fd_r43x6_unpack` as bits of the 256-bit integer, by `bv_decide`. -/
local macro "unpack_lane" : tactic =>
  `(tactic| (
    simp only [fd_r43x6_unpack.spec, mm512_permutexvar_epi8, permutexvarBytes, perm_idx]
    simp only [wwl_and_get, wwl_shru_vector_get, wwl_bcast_get, wwl_get0, wwl_get1, wwl_get2,
      wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, Vector.getElem_ofFn, BitVec.reduceToNat]
    simp only [Fin.isValue, Fin.val_zero, Fin.val_one, Fin.val_two, Fin.coe_ofNat_eq_mod,
      Nat.reduceMod, Nat.reduceMul, Nat.zero_mul, extract64_0, extract64_1, extract64_2,
      extract64_3, extract64_4, extract64_5, extract64_6, extract64_7]
    simp (disch := decide) only [BitVec.extractLsb'_packLanes_of_lt, Nat.reduceDiv,
      Nat.reduceMod, Vector.getElem_map, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, Nat.reduceMul]
    simp (disch := decide) only [BitVec.extractLsb'_packLanes_of_lt, Nat.reduceDiv,
      Nat.reduceMod, mm512_inserti64x4, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, Nat.reduceMul, wwl_zero_get]
    generalize u[0] = u0, u[1] = u1, u[2] = u2, u[3] = u3
    bv_decide))

theorem unpack_lane0 (u : Wv) : (fd_r43x6_unpack.spec u)[0] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 0 43).setWidth 64 := by
  unpack_lane

theorem unpack_lane1 (u : Wv) : (fd_r43x6_unpack.spec u)[1] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 43 43).setWidth 64 := by
  unpack_lane

theorem unpack_lane2 (u : Wv) : (fd_r43x6_unpack.spec u)[2] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 86 43).setWidth 64 := by
  unpack_lane

theorem unpack_lane3 (u : Wv) : (fd_r43x6_unpack.spec u)[3] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 129 43).setWidth 64 := by
  unpack_lane

theorem unpack_lane4 (u : Wv) : (fd_r43x6_unpack.spec u)[4] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 172 43).setWidth 64 := by
  unpack_lane

theorem unpack_lane5 (u : Wv) : (fd_r43x6_unpack.spec u)[5] =
    ((u[3] ++ u[2] ++ u[1] ++ u[0]).extractLsb' 215 41).setWidth 64 := by
  unpack_lane

theorem unpack_lane67 (u : Wv) :
    (fd_r43x6_unpack.spec u)[6] = 0 ∧ (fd_r43x6_unpack.spec u)[7] = 0 := by
  constructor <;> unpack_lane

/-! ## Value -/

/-- An `fd_r43x6_t`'s limbs packed into 320 bits, limb `i` at bit `43 i`. -/
def pack320w (x : Wwl) : BitVec 320 :=
  x[0].zeroExtend 320 + (x[1].zeroExtend 320 <<< 43) + (x[2].zeroExtend 320 <<< 86) +
    (x[3].zeroExtend 320 <<< 129) + (x[4].zeroExtend 320 <<< 172) + (x[5].zeroExtend 320 <<< 215)

/-- A `wv_t`'s lanes packed into 320 bits. -/
def wv320 (u : Wv) : BitVec 320 :=
  u[0].zeroExtend 320 + (u[1].zeroExtend 320 <<< 64) + (u[2].zeroExtend 320 <<< 128) +
    (u[3].zeroExtend 320 <<< 192)

theorem pack320w_toNat (x : Wwl) : (pack320w x).toNat = nat x := by
  have := x[0].isLt
  have := x[1].isLt
  have := x[2].isLt
  have := x[3].isLt
  have := x[4].isLt
  have := x[5].isLt
  simp only [pack320w, nat, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  simp (disch := omega) only [Nat.mod_eq_of_lt]

theorem wv320_toNat (u : Wv) : (wv320 u).toNat = wvNat u := by
  have := u[0].isLt
  have := u[1].isLt
  have := u[2].isLt
  have := u[3].isLt
  simp only [wv320, wvNat, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  simp (disch := omega) only [Nat.mod_eq_of_lt]

theorem unpack_pack (u : Wv) : pack320w (fd_r43x6_unpack.spec u) = wv320 u := by
  rw [pack320w, unpack_lane0, unpack_lane1, unpack_lane2, unpack_lane3, unpack_lane4,
    unpack_lane5, wv320]
  generalize u[0] = u0, u[1] = u1, u[2] = u2, u[3] = u3
  bv_decide

public theorem wvNat_lt (u : Wv) : wvNat u < 2 ^ 256 := by
  have := u[0].isLt
  have := u[1].isLt
  have := u[2].isLt
  have := u[3].isLt
  unfold wvNat
  omega

/-- `fd_r43x6_unpack` cuts a `wv_t`'s 256-bit integer into unpacked limbs, with lanes 6 and 7
zero: nearly reduced if the integer is below `2p`, reduced if below `p`. -/
public theorem fd_r43x6_unpack_spec (u : Wv) :
    nat (fd_r43x6_unpack.spec u) = wvNat u ∧ val (fd_r43x6_unpack.spec u) = (wvNat u : ZMod p) ∧
      Unpacked (fd_r43x6_unpack.spec u) ∧
      (wvNat u < 2 * p → NearlyReduced (fd_r43x6_unpack.spec u)) ∧
      (wvNat u < p → Reduced (fd_r43x6_unpack.spec u)) := by
  have hn : nat (fd_r43x6_unpack.spec u) = wvNat u := by
    rw [← pack320w_toNat, unpack_pack, wv320_toNat]
  have hu : Unpacked (fd_r43x6_unpack.spec u) := by
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, unpack_lane67 u⟩ <;>
      simp only [unpack_lane0, unpack_lane1, unpack_lane2, unpack_lane3, unpack_lane4,
        unpack_lane5, BitVec.toNat_setWidth] <;>
      exact lt_of_le_of_lt (Nat.mod_le _ _) (BitVec.isLt _)
  refine ⟨hn, ?_, hu, fun h => ⟨hu, by rw [hn]; exact h⟩, fun h => ⟨hu, ?_, by rw [hn]; exact h⟩⟩
  · rw [val_eq_nat (hu.unsigned.mono (by norm_num)), hn]
  · have := p_add
    have e := hn
    unfold nat at e
    omega

end R43x6

end LeanMLIR.RIR.Firedancer.Avx512

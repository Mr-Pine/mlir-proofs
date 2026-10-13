module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Bytes
public import Agave.Common.Copy
public import Agave.Common.Scalar
public import Agave.Serial.Scalar52_from_bytes
public import Agave.Serial.Scalar52_sub
public import Agave.Serial.Scalar52_pack
public import Agave.Serial.Mlir.Scalar_reduce
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `UnpackedScalar::mul_internal(&x, &constants::R)`: the nine columns of `x R`, in the compiled
operand order, `R`'s limbs as constants. -/
def Scalar_reduce.columns (x : Fin 5 → BitVec 64) : Fin 9 → BitVec 128 :=
  let r0 := 0x000f48bd6721e6ed#128
  let r1 := 0x0003bab5ac67e45a#128
  let r2 := 0x000fffffeb35e51b#128
  let r3 := 0x000fffffffffffff#128
  let r4 := 0x00000fffffffffff#128
  let m (i : Fin 5) (r : BitVec 128) := (x i).setWidth 128 * r
  fun
  | ⟨0, _⟩ => m 0 r0
  | ⟨1, _⟩ => m 1 r0 + m 0 r1
  | ⟨2, _⟩ => m 1 r1 + m 0 r2 + m 2 r0
  | ⟨3, _⟩ => m 1 r2 + m 0 r3 + m 2 r1 + m 3 r0
  | ⟨4, _⟩ => m 1 r3 + m 0 r4 + m 2 r2 + m 3 r1 + m 4 r0
  | ⟨5, _⟩ => m 2 r3 + m 1 r4 + m 3 r2 + m 4 r1
  | ⟨6, _⟩ => m 3 r3 + m 2 r4 + m 4 r2
  | ⟨7, _⟩ => m 4 r3 + m 3 r4
  | ⟨8, _⟩ => m 4 r4

/-- `Scalar::reduce(self)`: `self.unpack()` times `R`, Montgomery-reduced, packed. -/
def Scalar_reduce.spec (bytes : BitVec 256) : BitVec 256 :=
  let x := Scalar52_from_bytes.spec bytes
  let xR := Scalar_reduce.columns x
  let x_mod_l := Scalar52_montgomery_reduce.spec xR
  Scalar52_pack.spec x_mod_l

end

/-! ## Proof -/

section Proof

namespace Scalar_reduce

/-! Bounds: every 128-bit value of `mul_internal` and `montgomery_reduce` stays below `2^126`, so
their `add nuw nsw`s hold. -/

/-- Values below `2^127` neither wrap nor overflow signed when added. -/
theorem add_ok {a b : BitVec 128} {i j : Nat} (ha : a.toNat < 2 ^ i) (hb : b.toNat < 2 ^ j)
    (h : max i j < 127) : ¬a.uaddOverflow b ∧ ¬a.saddOverflow b := by
  have hi : 2 ^ i ≤ 2 ^ 126 := Nat.pow_le_pow_right (by decide) (by omega)
  have hj : 2 ^ j ≤ 2 ^ 126 := Nat.pow_le_pow_right (by decide) (by omega)
  have hai : a.toInt = a.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  have hbi : b.toInt = b.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  simp only [BitVec.uaddOverflow, BitVec.saddOverflow, hai, hbi]
  constructor
  · simp only [ge_iff_le, decide_eq_true_eq, not_le]
    omega
  · simp only [Nat.reduceSub, ge_iff_le, Bool.or_eq_true, decide_eq_true_eq, not_or, not_le, not_lt]
    omega

/-- A sum's bound. -/
theorem add_lt {s a b : BitVec 128} {i j k : Nat} (hs : s = a + b) (ha : a.toNat < 2 ^ i)
    (hb : b.toNat < 2 ^ j) (hk : max i j < k) (h : k ≤ 128) : s.toNat < 2 ^ k := by
  subst hs
  have hi : 2 ^ i ≤ 2 ^ (k - 1) := Nat.pow_le_pow_right (by decide) (by omega)
  have hj : 2 ^ j ≤ 2 ^ (k - 1) := Nat.pow_le_pow_right (by decide) (by omega)
  have hk2 : 2 ^ k = 2 * 2 ^ (k - 1) := by
    rw [← Nat.pow_succ']
    congr 1
    omega
  have hk128 : 2 ^ k ≤ 2 ^ 128 := Nat.pow_le_pow_right (by decide) h
  rw [BitVec.toNat_add_of_lt (by omega)]
  omega

/-- A zero-extended product's bound. -/
theorem mul_lt {p : BitVec 128} {x : BitVec 64} {c : BitVec 128} {i k : Nat}
    (hp : p = x.setWidth 128 * c) (hx : x.toNat < 2 ^ i) (hc : c.toNat * 2 ^ i ≤ 2 ^ k)
    (h : k ≤ 128) : p.toNat < 2 ^ k := by
  subst hp
  have hk : 2 ^ k ≤ 2 ^ 128 := Nat.pow_le_pow_right (by decide) h
  have hlt : x.toNat * c.toNat < 2 ^ k := by
    rcases Nat.eq_zero_or_pos c.toNat with h0 | h0
    · rw [h0, Nat.mul_zero]
      exact Nat.two_pow_pos k
    · calc
        x.toNat * c.toNat < 2 ^ i * c.toNat := Nat.mul_lt_mul_of_pos_right hx h0
        _ = c.toNat * 2 ^ i := Nat.mul_comm _ _
        _ ≤ 2 ^ k := hc
  have hx' := x.isLt
  rw [BitVec.toNat_mul, BitVec.toNat_setWidth, Nat.mod_eq_of_lt (a := x.toNat) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  exact hlt

/-- A zero-extended 64-bit value times a constant below `2^63` does not wrap. -/
theorem zext_umul (x : BitVec 64) (c : BitVec 128) (hc : c.toNat < 2 ^ 63) :
    ¬(x.setWidth 128).umulOverflow c := by
  have hx := x.isLt
  have : x.toNat * c.toNat < 2 ^ 64 * 2 ^ 63 := Nat.mul_lt_mul'' hx hc
  simp only [BitVec.umulOverflow, BitVec.toNat_setWidth,
    Nat.mod_eq_of_lt (a := x.toNat) (by omega : x.toNat < 2 ^ 128), ge_iff_le, decide_eq_true_eq,
    not_le]
  omega

/-- A zero-extended 64-bit value times a constant below `2^63` does not overflow signed. -/
theorem zext_smul (x : BitVec 64) (c : BitVec 128) (hc : c.toNat < 2 ^ 63) :
    ¬(x.setWidth 128).smulOverflow c := by
  have hx := x.isLt
  have : x.toNat * c.toNat < 2 ^ 64 * 2 ^ 63 := Nat.mul_lt_mul'' hx hc
  have hxs : (x.setWidth 128).toNat = x.toNat := by
    rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  have hxi : (x.setWidth 128).toInt = x.toNat := by rw [BitVec.toInt_eq_toNat_of_lt (by omega), hxs]
  have hci : c.toInt = c.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
  simp only [BitVec.smulOverflow, hxi, hci, Nat.reduceSub, ge_iff_le, Bool.or_eq_true,
    decide_eq_true_eq, not_or, not_le, not_lt]
  rw [← Int.natCast_mul]
  omega

/-- A carry's bound. -/
theorem shr_lt {c a : BitVec 128} {i k : Nat} (hc : c = a >>> 52) (ha : a.toNat < 2 ^ i)
    (hk : i ≤ k + 52) : c.toNat < 2 ^ k := by
  subst hc
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, Nat.div_lt_iff_lt_mul (by decide), ←
    Nat.pow_add]
  exact lt_of_lt_of_le ha (Nat.pow_le_pow_right (by decide) hk)

/-- A multiplier shifted to bit 44: below `2^96`. -/
theorem shl_lt {s : BitVec 128} {n : BitVec 64} (hs : s = n.setWidth 128 <<< 44)
    (hn : n.toNat < 2 ^ 52) : s.toNat < 2 ^ 96 := by
  subst hs
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq,
    Nat.mod_eq_of_lt (a := n.toNat) (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A multiplier is below `2^52`. -/
theorem n_lt {n x : BitVec 64} (hn : n = x &&& 4503599627370495#64) : n.toNat < 2 ^ 52 := by
  subst hn
  rw [BitVec.toNat_and]
  exact lt_of_le_of_lt Nat.and_le_right (by decide)

/-- A multiplier is nonnegative (its `zext nneg`). -/
theorem n_msb {n x : BitVec 64} (hn : n = x &&& 4503599627370495#64) : n.msb = false := by
  subst hn
  bv_decide

/-- The last carry, below `2^63`, truncates without loss (`trunc nuw nsw`). -/
theorem trunc_ok {c : BitVec 128} (h : c.toNat < 2 ^ 63) :
    (c.setWidth 64).setWidth 128 = c ∧ (c.setWidth 64).signExtend 128 = c := by
  have h1 : (c.setWidth 64).setWidth 128 = c := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_setWidth, BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
  refine ⟨h1, ?_⟩
  rw [BitVec.signExtend_eq_setWidth_of_msb_false, h1]
  rw [BitVec.msb_eq_false_iff_two_mul_lt, BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  omega

/-- Five limbs. -/
def mk5 (x0 x1 x2 x3 x4 : BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => x0
  | ⟨1, _⟩ => x1
  | ⟨2, _⟩ => x2
  | ⟨3, _⟩ => x3
  | ⟨4, _⟩ => x4

end Scalar_reduce

open Scalar_reduce

set_option hygiene false in
/-- `bmul p x k`: `p = (x as u128) * c` for a constant `c`, its flags and `hp_lt : p < 2^k`. -/
local macro "bmul " p:ident x:ident k:num : tactic => do
  let hp := Lean.mkIdent (.mkSimple s!"h{p.getId}")
  let hpl := Lean.mkIdent (.mkSimple s!"h{p.getId}_lt")
  let hxl := Lean.mkIdent (.mkSimple s!"h{x.getId}_lt")
  `(tactic|
      ( step_pure [zext_umul, zext_smul] with $p:ident
        have $hpl:ident := mul_lt (k := $k) $hp $hxl (by decide) (by decide)))

set_option hygiene false in
/-- `badd s a b k`: `s = a + b`, its flags from `a`'s and `b`'s bounds, and `hs_lt : s < 2^k`. -/
local macro "badd " s:ident a:ident b:ident k:num : tactic => do
  let hs := Lean.mkIdent (.mkSimple s!"h{s.getId}")
  let hsl := Lean.mkIdent (.mkSimple s!"h{s.getId}_lt")
  let hal := Lean.mkIdent (.mkSimple s!"h{a.getId}_lt")
  let hbl := Lean.mkIdent (.mkSimple s!"h{b.getId}_lt")
  `(tactic|
      ( step_pure [(add_ok $hal $hbl (by decide)).1, (add_ok $hal $hbl (by decide)).2] with $s:ident
        have $hsl:ident := add_lt (k := $k) $hs $hal $hbl (by decide) (by decide)))

set_option hygiene false in
/-- `bshr c a k`: the carry `c = a >> 52` and `hc_lt : c < 2^k`. -/
local macro "bshr " c:ident a:ident k:num : tactic => do
  let hc := Lean.mkIdent (.mkSimple s!"h{c.getId}")
  let hcl := Lean.mkIdent (.mkSimple s!"h{c.getId}_lt")
  let hal := Lean.mkIdent (.mkSimple s!"h{a.getId}_lt")
  `(tactic|
      ( step_pure with $c:ident
        have $hcl:ident := shr_lt (k := $k) $hc $hal (by decide)))

set_option hygiene false in
/-- `bshl s n`: `s = (n as u128) << 44`, its flags and `hs_lt : s < 2^96`. -/
local macro "bshl " s:ident n:ident : tactic => do
  let hs := Lean.mkIdent (.mkSimple s!"h{s.getId}")
  let hsl := Lean.mkIdent (.mkSimple s!"h{s.getId}_lt")
  let hnl := Lean.mkIdent (.mkSimple s!"h{n.getId}_lt")
  `(tactic|
      ( step_pure [Agave.zext_shl_ushiftRight, Agave.zext_shl_sshiftRight] with $s:ident
        have $hsl:ident := shl_lt $hs $hnl))

set_option hygiene false in
/-- `bn n`: `part1`'s multiplier `n = (sum as u64).wrapping_mul(LFACTOR) & mask`, its bound and
sign, and its `zext nneg`. -/
local macro "bn " n:ident : tactic => do
  let hn := Lean.mkIdent (.mkSimple s!"h{n.getId}")
  let hnl := Lean.mkIdent (.mkSimple s!"h{n.getId}_lt")
  let hnm := Lean.mkIdent (.mkSimple s!"h{n.getId}_msb")
  `(tactic|
      ( step_pure
        step_pure
        step_pure with $n:ident
        have $hnl:ident := n_lt $hn
        have $hnm:ident := n_msb $hn
        step_pure [$hnm:ident]))

set_option hygiene false in
/-- `ldx x h`: the limb `x` loaded by its read fact `h`, with its bound, and zero-extended. -/
local macro "ldx " x:ident h:ident : tactic => do
  let hxl := Lean.mkIdent (.mkSimple s!"h{x.getId}_lt")
  `(tactic|
      (step_load [$h:ident] with $x:ident consuming $h; have $hxl:ident := ($x).isLt; step_pure))

-- about 300 steps in one block, each with bound facts: past the default heartbeats
set_option maxHeartbeats 2000000 in
/-- `Scalar::reduce(self)` for the 32 bytes at `self` stores `spec` at `out` (32 bytes, one 256-bit
value). The temporaries' blocks and the callees' are freed again: only the counter moves on. `self`
is read before `out` is written, so they may alias. -/
public theorem Scalar_reduce.call_eq (out self : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hself : Fits s.mem self 256) (hself_off : ¬self.offset.uaddOverflow 32#64) :
    Scalar_reduce.call (Scalar_reduce.args (.value out) (.value self)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 19⟩
            mem := s.mem.storeAt out (Scalar_reduce.spec (s.mem.readAt self 256)) }) := by
  func_init
  block_init
  iterate 16 step_pure
  step_alloca with zt1
  step_alloca with zt0
  step_alloca with r
  step_alloca with x_mod_l
  step_alloca with xR0
  step_alloca with xR1
  step_alloca with xR2
  step_alloca with xR3
  step_alloca with xR4
  step_alloca with xR5
  step_alloca with xR6
  step_alloca with xR7
  step_alloca with xR8
  step_alloca with x
  -- `let mut x = self.unpack();`
  step_pure
  limbs_room x
  step_call using Scalar52_from_bytes.call_eq
  iterate 9 step_pure
  obtain ⟨X, hX⟩ : ∃ l, Scalar52_from_bytes.spec (S₀.mem.readAt self 256) = l := ⟨_, rfl⟩
  rw [hX] at hread_x_readLimbs
  have hx0r : S.mem.readAt x 64 = X 0 := congrFun hread_x_readLimbs 0
  clear hread_x
  -- `let mut xR = UnpackedScalar::mul_internal(&x, &constants::R);`
  ldx x0 hx0r
  bmul z0 x0 116
  step_store
  bmul p01 x0 116
  step_pure
  have hx1r : S.mem.readAt (x.add 8#64) 64 = X 1 := congrFun hread_x_readLimbs 1
  ldx x1 hx1r
  bmul p10 x1 116
  badd z1 p10 p01 117
  step_store
  bmul p02 x0 116
  bmul p11 x1 116
  badd s2a p11 p02 117
  step_pure
  have hx2r : S.mem.readAt (x.add 16#64) 64 = X 2 := congrFun hread_x_readLimbs 2
  ldx x2 hx2r
  bmul p20 x2 116
  badd z2 s2a p20 118
  step_store
  bmul p03 x0 116
  bmul p12 x1 116
  badd s3a p12 p03 117
  bmul p21 x2 116
  badd s3b s3a p21 118
  step_pure
  have hx3r : S.mem.readAt (x.add 24#64) 64 = X 3 := congrFun hread_x_readLimbs 3
  ldx x3 hx3r
  bmul p30 x3 116
  badd z3 s3b p30 119
  step_store
  bmul p04 x0 108
  bmul p13 x1 116
  badd s4a p13 p04 117
  bmul p22 x2 116
  badd s4b s4a p22 118
  bmul p31 x3 116
  badd s4c s4b p31 119
  step_pure
  have hx4r : S.mem.readAt (x.add 32#64) 64 = X 4 := congrFun hread_x_readLimbs 4
  ldx x4 hx4r
  clear hread_x_readLimbs
  bmul p40 x4 116
  badd z4 s4c p40 120
  step_store
  bmul p14 x1 108
  bmul p23 x2 116
  badd s5a p23 p14 117
  bmul p32 x3 116
  badd s5b s5a p32 118
  bmul p41 x4 116
  badd z5 s5b p41 119
  step_store
  bmul p24 x2 108
  bmul p33 x3 116
  badd s6a p33 p24 117
  bmul p42 x4 116
  badd z6 s6a p42 118
  step_store
  bmul p34 x3 108
  bmul p43 x4 116
  badd z7 p43 p34 117
  step_store
  bmul z8 x4 108
  step_store
  clear hx0_lt hx1_lt hx2_lt hx3_lt hx4_lt hp01_lt hp10_lt hp02_lt hp11_lt hp20_lt hp03_lt hp12_lt
    hp21_lt hp30_lt hp04_lt hp13_lt hp22_lt hp31_lt hp40_lt hp14_lt hp23_lt hp32_lt hp41_lt hp24_lt
    hp33_lt hp42_lt hp34_lt hp43_lt hs2a_lt hs3a_lt hs3b_lt hs4a_lt hs4b_lt hs4c_lt hs5a_lt hs5b_lt
    hs6a_lt
  -- `let mut x_mod_l = UnpackedScalar::montgomery_reduce(&xR);`
  step_pure
  limbs_room x_mod_l
  -- `part1(limbs[0])`, `part1(sum)` …: `n`, then `(sum + m(n, L[0])) >> 52`
  bn n0
  bmul q00 n0 104
  badd c0a q00 z0 117
  bshr carry0 c0a 65
  bmul q01 n0 104
  badd s1a q01 z1 118
  badd sum1 s1a carry0 119
  bn n1
  bmul q10 n1 104
  badd c1a q10 sum1 120
  bshr carry1 c1a 68
  bmul q02 n0 104
  bmul q11 n1 104
  badd s2a' q02 z2 119
  badd s2b' s2a' q11 120
  badd sum2 s2b' carry1 121
  bn n2
  bmul q20 n2 104
  badd c2a q20 sum2 122
  bshr carry2 c2a 70
  bmul q12 n1 104
  bmul q21 n2 104
  badd s3a' q12 z3 120
  badd s3b' s3a' q21 121
  badd sum3 s3b' carry2 122
  bn n3
  bmul q30 n3 104
  badd c3a q30 sum3 123
  bshr carry3 c3a 71
  bshl sh0 n0
  bmul q22 n2 104
  bmul q31 n3 104
  badd s4a' z4 sh0 121
  badd s4b' s4a' q22 122
  badd s4c' s4b' q31 123
  badd sum4 s4c' carry3 124
  bn n4
  bmul q40 n4 104
  badd c4a q40 sum4 125
  bshr carry4 c4a 73
  -- `part2(sum)`: `(sum >> 52, (sum as u64) & mask)`
  bshl sh1 n1
  bmul q32 n3 104
  bmul q41 n4 104
  badd s5a' sh1 z5 120
  badd s5b' s5a' q32 121
  badd s5c' s5b' q41 122
  badd sum5 s5c' carry4 123
  step_pure
  step_pure with transparent r0
  bshr c5 sum5 71
  bshl sh2 n2
  bmul q42 n4 104
  badd s6a' sh2 z6 119
  badd s6b' s6a' q42 120
  badd sum6 s6b' c5 121
  step_pure
  step_pure with transparent r1
  bshr c6 sum6 69
  bshl sh3 n3
  badd s7a sh3 z7 118
  badd sum7 s7a c6 119
  step_pure
  step_pure with transparent r2
  bshr c7 sum7 67
  bshl sh4 n4
  badd s8a sh4 z8 109
  badd sum8 s8a c7 110
  step_pure
  step_pure with transparent r3
  bshr c8 sum8 58
  have hc8 := trunc_ok (lt_of_lt_of_le hc8_lt (by decide))
  step_pure [hc8.1, hc8.2] with transparent r4
  clear hc8 hc8_lt hc7_lt hc6_lt hc5_lt hcarry0_lt hcarry1_lt hcarry2_lt hcarry3_lt hcarry4_lt
    hsum1_lt hsum2_lt hsum3_lt hsum4_lt hsum5_lt hsum6_lt hsum7_lt hsum8_lt hz0_lt hz1_lt hz2_lt
    hz3_lt hz4_lt hz5_lt hz6_lt hz7_lt hz8_lt hn0_lt hn1_lt hn2_lt hn3_lt hn4_lt hn0_msb hn1_msb
    hn2_msb hn3_msb hn4_msb hq00_lt hq01_lt hq10_lt hq02_lt hq11_lt hq20_lt hq12_lt hq21_lt hq30_lt
    hq22_lt hq31_lt hq40_lt hq32_lt hq41_lt hq42_lt hc0a_lt hc1a_lt hc2a_lt hc3a_lt hc4a_lt hs1a_lt
    hs2a'_lt hs2b'_lt hs3a'_lt hs3b'_lt hs4a'_lt hs4b'_lt hs4c'_lt hs5a'_lt hs5b'_lt hs5c'_lt
    hs6a'_lt hs6b'_lt hs7a_lt hs8a_lt hsh0_lt hsh1_lt hsh2_lt hsh3_lt hsh4_lt
  -- `Scalar52::sub(&Scalar52([r0, r1, r2, r3, r4]), l)`
  step_pure
  step_store
  iterate 4
    step_pure
    step_store
  have hr_fit : S.mem.LimbsFit r :=
    ⟨by
      rw [hr_off]; decide, hfits_r, hfits_r_8, hfits_r_16, hfits_r_24, hfits_r_32⟩
  have hrl : S.mem.readLimbs r = mk5 _ _ _ _ _ :=
    readLimbs_of_reads hread_r hread_r_8 hread_r_16 hread_r_24 hread_r_32
  step_call using Scalar52_sub.call_eq [hrl] consuming hrl
  step_pure
  -- `let scalar = x_mod_l.pack();`
  step_call using Scalar52_pack.call_eq
  -- `x.zeroize(); xR.zeroize(); x_mod_l.zeroize();`
  step_pure
  step_memset
  have hdst := Agave.room_of_limbsRoom (hx_limbs.room (by mem_fact))
  step_memcpy consuming hdst
  step_pure
  iterate 9 step_store
  step_pure
  step_memset
  have hdst := Agave.room_of_limbsRoom (hx_mod_l_limbs.room (by mem_fact))
  step_memcpy consuming hdst
  iterate 12 step_pure
  finish_block
  -- `montgomery_reduce`'s `sum2` with its first two terms in the source order
  rw [BitVec.add_comm q02 z2] at hs2a'
  clear_reads
  subst_vars
  erase_frame
  simp only [GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
  rfl

end Proof

end MLIR.Agave.Serial

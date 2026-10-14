module

public import Firedancer.Math.Lane.Point
public import Ed25519.BasePoint
public import Ed25519.Decode
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Module

/-! `fd_ed25519_lane_verify` in the group: the signed recodings sum to the scalars, the window
ladder computes `[k](-A) + [S]B`, and bit `j` of the result is lane `j`'s group equation. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d basePoint)

/-! ## Definitions -/

@[expose] public section

/-- Fixed-base limbs `off … off + 4` of entry `e`, in every lane. -/
def baseFe (tbl : Nat → BitVec 64) (e off : Nat) : Fe :=
  Fe.ofLanes fun _ => baseLimbs tbl e off

/-- `tbl`'s entries `0 … 128` are `[e]B` in the affine table form `y + x, y - x, 2dxy, -2dxy`,
the first three carried, the last f52. -/
def BaseOk (tbl : Nat → BitVec 64) : Prop :=
  ∀ e ≤ 128, (∀ j, Operand (baseFe tbl e 0) (baseFe tbl e 5) (baseFe tbl e 10) Fe.one j
      (e • basePoint) ∧ (baseFe tbl e 15).val j = -(baseFe tbl e 10).val j) ∧
    (baseFe tbl e 0).Carried ∧ (baseFe tbl e 5).Carried ∧ (baseFe tbl e 10).Carried ∧
    (baseFe tbl e 15).F52

end

/-! ## Recodings -/

/-- One window of `fd_ed25519_lane_recode4`: nibble `n` and carry `c` give the carry
`(n + c + 8) / 16` out and the digit `n + c - 16` times it. -/
theorem recode4_step {n c : BitVec 32} (hn : n.toNat < 16) (hc : c.toNat < 2) :
    ((n + c + 8).sshiftRight 4).toNat = (n.toNat + c.toNat + 8) / 2 ^ 4 ∧
      ((n + c - 16 * (n + c + 8).sshiftRight 4).setWidth 8).toInt =
        n.toNat + c.toNat - 16 * (((n.toNat + c.toNat + 8) / 2 ^ 4 : ℕ) : ℤ) := by
  have h1 : (n + c + 8).toNat = n.toNat + c.toNat + 8 := by bv_omega
  have h3 := BitVec.sshiftRight_eq_of_msb_false (s := 4)
    (BitVec.msb_eq_false_iff_two_mul_lt.2 (by rw [h1]; omega))
  rw [h3, BitVec.toNat_ushiftRight, h1, Nat.shiftRight_eq_div_pow]
  refine ⟨rfl, ?_⟩
  rw [BitVec.toInt_eq_toNat_cond, BitVec.toNat_setWidth, BitVec.toNat_sub, BitVec.toNat_mul,
    BitVec.toNat_ushiftRight, h1, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  simp only [BitVec.reduceToNat]
  split <;> omega

/-- One window of `fd_ed25519_lane_recode8`. -/
theorem recode8_step {n c : BitVec 32} (hn : n.toNat < 256) (hc : c.toNat < 2) :
    ((n + c + 128).sshiftRight 8).toNat = (n.toNat + c.toNat + 128) / 2 ^ 8 ∧
      ((n + c - 256 * (n + c + 128).sshiftRight 8).setWidth 16).toInt =
        n.toNat + c.toNat - 256 * (((n.toNat + c.toNat + 128) / 2 ^ 8 : ℕ) : ℤ) := by
  have h1 : (n + c + 128).toNat = n.toNat + c.toNat + 128 := by bv_omega
  have h3 := BitVec.sshiftRight_eq_of_msb_false (s := 8)
    (BitVec.msb_eq_false_iff_two_mul_lt.2 (by rw [h1]; omega))
  rw [h3, BitVec.toNat_ushiftRight, h1, Nat.shiftRight_eq_div_pow]
  refine ⟨rfl, ?_⟩
  rw [BitVec.toInt_eq_toNat_cond, BitVec.toNat_setWidth, BitVec.toNat_sub, BitVec.toNat_mul,
    BitVec.toNat_ushiftRight, h1, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  simp only [BitVec.reduceToNat]
  split <;> omega

/-- `s`'s `k`-bit window `w`, as the C's 32-bit `int`. -/
theorem window_toNat (s : BitVec 256) (k w : ℕ) (hk : k ≤ 32) :
    ((s >>> (k * w)).setWidth 32 &&& BitVec.ofNat 32 (2 ^ k - 1)).toNat =
      s.toNat / (2 ^ k) ^ w % 2 ^ k := by
  have h2 := Nat.pow_le_pow_right (n := 2) (by omega) hk
  rw [BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt (a := 2 ^ k - 1) (by omega),
    Nat.and_two_pow_sub_one_eq_mod, Nat.shiftRight_eq_div_pow, ← pow_mul,
    Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 hk)]

/-- Nibble `w` of `s`: `s / 16^w mod 16`. -/
theorem nib_toNat (s : BitVec 256) (w : ℕ) : (nib s w).toNat = s.toNat / 16 ^ w % 16 :=
  window_toNat s 4 w (by omega)

theorem byte_toNat (s : BitVec 256) (w : ℕ) : (byte s w).toNat = s.toNat / 256 ^ w % 256 :=
  window_toNat s 8 w (by omega)

/-- `fd_ed25519_lane_recode4`'s carries are `0` or `1`. -/
theorem carry4_lt (s : BitVec 256) : ∀ w, (carry4 s w).toNat < 2
  | 0 => by rw [carry4]; decide
  | w + 1 => by
    have hn : (nib s w).toNat < 16 := by rw [nib_toNat]; omega
    rw [carry4, (recode4_step hn (carry4_lt s w)).1]
    have := carry4_lt s w
    omega

theorem carry8_lt (s : BitVec 256) : ∀ w, (carry8 s w).toNat < 2
  | 0 => by rw [carry8]; decide
  | w + 1 => by
    have hn : (byte s w).toNat < 256 := by rw [byte_toNat]; omega
    rw [carry8, (recode8_step hn (carry8_lt s w)).1]
    have := carry8_lt s w
    omega

/-- Digit `w` of `fd_ed25519_lane_recode4`: nibble plus carry in, less `16` times the carry out. -/
theorem recode4_toInt (s : BitVec 256) (w : ℕ) :
    (recode4 s w).toInt = (nib s w).toNat + (carry4 s w).toNat - 16 * (carry4 s (w + 1)).toNat := by
  have hn : (nib s w).toNat < 16 := by rw [nib_toNat]; omega
  have h := recode4_step hn (carry4_lt s w)
  rw [carry4, h.1]
  exact h.2

theorem recode8_toInt (s : BitVec 256) (w : ℕ) :
    (recode8 s w).toInt =
      (byte s w).toNat + (carry8 s w).toNat - 256 * (carry8 s (w + 1)).toNat := by
  have hn : (byte s w).toNat < 256 := by rw [byte_toNat]; omega
  have h := recode8_step hn (carry8_lt s w)
  rw [carry8, h.1]
  exact h.2

/-- `fd_ed25519_lane_recode4`'s digits lie in `[-8, 8)`, for any scalar. -/
public theorem recode4_range (s : BitVec 256) {w : ℕ} (_hw : w < 64) :
    -8 ≤ (recode4 s w).toInt ∧ (recode4 s w).toInt < 8 := by
  have hn : (nib s w).toNat < 16 := by rw [nib_toNat]; omega
  have h := (recode4_step hn (carry4_lt s w)).2
  have := carry4_lt s w
  rw [recode4, h]
  omega

/-- The low `N` digits: `s mod 16^N` less the carry out. -/
theorem recode4_partial (s : BitVec 256) (N : ℕ) :
    ∑ w ∈ Finset.range N, (recode4 s w).toInt * 16 ^ w =
      ((s.toNat % 16 ^ N : ℕ) : ℤ) - 16 ^ N * (carry4 s N).toNat := by
  induction N with
  | zero => simp [carry4]
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, recode4_toInt, nib_toNat, Nat.mod_pow_succ]
    push_cast
    ring

/-- Below `2^253`, `fd_ed25519_lane_recode4`'s digits are the scalar's radix-16 signed digits. -/
public theorem recode4_sum {s : BitVec 256} (hs : s.toNat < 2 ^ 253) :
    ∑ w : Fin 64, (recode4 s w).toInt * 16 ^ (w : ℕ) = s.toNat := by
  rw [Fin.sum_univ_eq_sum_range (fun w => (recode4 s w).toInt * 16 ^ w), recode4_partial,
    Nat.mod_eq_of_lt (by omega)]
  have hn : (nib s 63).toNat < 16 := by rw [nib_toNat]; omega
  have h := (recode4_step hn (carry4_lt s 63)).1
  have := carry4_lt s 63
  rw [nib_toNat] at h
  rw [carry4, h, Nat.div_eq_of_lt (a := _ / 16 ^ 63 % 16 + _ + 8) (by omega)]
  simp

/-- `fd_ed25519_lane_recode8`'s digits lie in `[-128, 128)`, for any scalar. -/
public theorem recode8_range (s : BitVec 256) {w : ℕ} (_hw : w < 32) :
    -128 ≤ (recode8 s w).toInt ∧ (recode8 s w).toInt < 128 := by
  have hn : (byte s w).toNat < 256 := by rw [byte_toNat]; omega
  have h := (recode8_step hn (carry8_lt s w)).2
  have := carry8_lt s w
  rw [recode8, h]
  omega

theorem recode8_partial (s : BitVec 256) (N : ℕ) :
    ∑ w ∈ Finset.range N, (recode8 s w).toInt * 256 ^ w =
      ((s.toNat % 256 ^ N : ℕ) : ℤ) - 256 ^ N * (carry8 s N).toNat := by
  induction N with
  | zero => simp [carry8]
  | succ N ih =>
    rw [Finset.sum_range_succ, ih, recode8_toInt, byte_toNat, Nat.mod_pow_succ]
    push_cast
    ring

public theorem recode8_sum {s : BitVec 256} (hs : s.toNat < 2 ^ 253) :
    ∑ w : Fin 32, (recode8 s w).toInt * 256 ^ (w : ℕ) = s.toNat := by
  rw [Fin.sum_univ_eq_sum_range (fun w => (recode8 s w).toInt * 256 ^ w), recode8_partial,
    Nat.mod_eq_of_lt (by omega)]
  have hn : (byte s 31).toNat < 256 := by rw [byte_toNat]; omega
  have h := (recode8_step hn (carry8_lt s 31)).1
  have := carry8_lt s 31
  rw [byte_toNat] at h
  rw [carry8, h, Nat.div_eq_of_lt (a := _ / 256 ^ 31 % 256 + _ + 128) (by omega)]
  simp

/-! ## The table of `[e](-A)` -/

/-- `T` stays when not computed, so a carried point stays carried. -/
theorem Point.dbl_carried' {P : Point} (hb : P.Carried) (withT : Bool) :
    (P.dbl withT P.t).Carried := by
  cases withT
  · exact ⟨Point.dbl_carriedXYZ hb.xyz false P.t, hb.2⟩
  · exact Point.dbl_carried hb.xyz P.t

theorem Point.addQ_carried' {P : Point} {qp qm qk qz : Fe} {affine : Bool} (hb : P.Carried)
    (hqb : qp.F52 ∧ qm.F52 ∧ qk.F52) (hz : affine = false → qz.F52) (withT : Bool) :
    (P.addQ qp qm qk qz affine withT P.t).Carried := by
  cases withT
  · exact ⟨Point.addQ_carriedXYZ hb hqb hz false P.t, hb.2⟩
  · exact Point.addQ_carried hb hqb hz P.t

/-- Doubling `[m]Q` in extended coordinates. -/
theorem Point.dbl_nsmul {P : Point} {j : Fin 8} {Q : Ed25519.Point} {m : ℕ} (h : P.Ext j (m • Q))
    (hb : P.Carried) (t0 : Fe) : (P.dbl true t0).Ext j ((2 * m) • Q) := by
  rw [two_mul, add_nsmul]
  exact Point.dbl_ext h.proj hb.xyz t0

/-- Adding the table form of `a`, `z = 1`, to `[m]Q`. -/
theorem Point.add_toNiels {a P : Point} {k2d : Fe} {j : Fin 8} {Q : Ed25519.Point} {m : ℕ}
    (ha : a.Ext j Q) (hz : a.z = Fe.one) (hab : a.Carried) (hk : k2d.val j = 2 * d)
    (hkb : k2d.F52) (h : P.Ext j (m • Q)) (hb : P.Carried) :
    (P.add (a.toNiels k2d) true true Fe.zero).Ext j ((m + 1) • Q) := by
  have hn := Point.toNiels_is ha hab hk hkb
  have hnb := Point.toNiels_bounded hab hkb
  have hq : Operand (a.toNiels k2d).p (a.toNiels k2d).m (a.toNiels k2d).k Fe.one j Q := by
    rw [← hz]
    exact hn.1
  rw [succ_nsmul]
  exact Point.addQ_ext (affine := true) (qz := (a.toNiels k2d).z) h hb hq
    ⟨hnb.1.f52, hnb.2.1.f52, hnb.2.2.1.f52⟩ nofun Fe.zero

theorem Point.add_toNiels_carried {a P : Point} {k2d : Fe} (hab : a.Carried) (hkb : k2d.F52)
    (hb : P.Carried) : (P.add (a.toNiels k2d) true true Fe.zero).Carried :=
  have hnb := Point.toNiels_bounded hab hkb
  Point.addQ_carried (affine := true) (qz := (a.toNiels k2d).z) hb
    ⟨hnb.1.f52, hnb.2.1.f52, hnb.2.2.1.f52⟩ nofun Fe.zero

/-- Entry `e ≤ 8` of the table is `[e]a`, for `a` with `z = 1`. -/
public theorem ktab_is {a : Point} {k2d : Fe} {j : Fin 8} {Q : Ed25519.Point} (h : a.Ext j Q)
    (hz : a.z = Fe.one) (hb : a.Carried) (hk : k2d.val j = 2 * d) (hkb : k2d.F52) {e : ℕ}
    (he : e ≤ 8) : (ktab a k2d e).Is j (e • Q) := by
  have h1 : a.Ext j (1 • Q) := by rwa [one_smul]
  have e2 := Point.dbl_nsmul h1 hb Fe.zero
  have c2 := Point.dbl_carried hb.xyz Fe.zero
  have e3 := Point.add_toNiels h hz hb hk hkb e2 c2
  have c3 := Point.add_toNiels_carried hb hkb c2
  have e4 := Point.dbl_nsmul e2 c2 Fe.zero
  have c4 := Point.dbl_carried c2.xyz Fe.zero
  have e5 := Point.add_toNiels h hz hb hk hkb e4 c4
  have c5 := Point.add_toNiels_carried hb hkb c4
  have e6 := Point.dbl_nsmul e3 c3 Fe.zero
  have c6 := Point.dbl_carried c3.xyz Fe.zero
  have e7 := Point.add_toNiels h hz hb hk hkb e6 c6
  have c7 := Point.add_toNiels_carried hb hkb c6
  have e8 := Point.dbl_nsmul e4 c4 Fe.zero
  have c8 := Point.dbl_carried c4.xyz Fe.zero
  interval_cases e
  · rw [zero_smul]
    exact Niels.zero_is j
  · exact Point.toNiels_is h1 hb hk hkb
  · exact Point.toNiels_is e2 c2 hk hkb
  · exact Point.toNiels_is e3 c3 hk hkb
  · exact Point.toNiels_is e4 c4 hk hkb
  · exact Point.toNiels_is e5 c5 hk hkb
  · exact Point.toNiels_is e6 c6 hk hkb
  · exact Point.toNiels_is e7 c7 hk hkb
  · exact Point.toNiels_is e8 c8 hk hkb

public theorem ktab_bounded {a : Point} {k2d : Fe} (_hz : a.z = Fe.one) (hb : a.Carried)
    (hkb : k2d.F52) (e : ℕ) : (ktab a k2d e).Bounded := by
  have c2 := Point.dbl_carried hb.xyz Fe.zero
  have c3 := Point.add_toNiels_carried hb hkb c2
  have c4 := Point.dbl_carried c2.xyz Fe.zero
  have c5 := Point.add_toNiels_carried hb hkb c4
  have c6 := Point.dbl_carried c3.xyz Fe.zero
  have c7 := Point.add_toNiels_carried hb hkb c6
  have c8 := Point.dbl_carried c4.xyz Fe.zero
  rcases e with _ | _ | _ | _ | _ | _ | _ | _ | e
  · exact Niels.zero_bounded
  · exact Point.toNiels_bounded hb hkb
  · exact Point.toNiels_bounded c2 hkb
  · exact Point.toNiels_bounded c3 hkb
  · exact Point.toNiels_bounded c4 hkb
  · exact Point.toNiels_bounded c5 hkb
  · exact Point.toNiels_bounded c6 hkb
  · exact Point.toNiels_bounded c7 hkb
  · exact Point.toNiels_bounded c8 hkb

/-! ## The window operands -/

theorem Fe.ofLanes_val (f : Fin 8 → Fin 5 → BitVec 64) (j : Fin 8) :
    (Fe.ofLanes f).val j = Ed25519.Limbs.val (f j) := by
  rw [Fe.val, Fe.ofLanes_lane]

theorem Fe.ofLanes_le {f : Fin 8 → Fin 5 → BitVec 64} {b : Fin 5 → ℕ}
    (h : ∀ j i, (f j i).toNat ≤ b i) : (Fe.ofLanes f).Le b := fun j i => by
  rw [Fe.ofLanes_lane]
  exact h j i

/-- A digit in `(-n, n)` times `Q`, by sign: `|e| Q` or its negation. -/
theorem zsmul_natAbs {e : ℤ} (Q : Ed25519.Point) :
    e • Q = if e < 0 then -(e.natAbs • Q) else e.natAbs • Q := by
  split
  · rw [← natCast_zsmul, ← neg_zsmul]
    congr 1
    omega
  · rw [← natCast_zsmul]
    congr 1
    omega

/-- The `[k]` operand of lane `j` is its digit times `Q`, the table holding `[e]Q`. -/
theorem selK_operand {tab : ℕ → Niels} {j : Fin 8} {Q : Ed25519.Point}
    (htab : ∀ e ≤ 8, (tab e).Is j (e • Q)) {d : Fin 8 → BitVec 8}
    (hd : -8 ≤ (d j).toInt ∧ (d j).toInt < 8) :
    Operand (selK tab d).1 (selK tab d).2.1 (selK tab d).2.2.1 (selK tab d).2.2.2 j
      ((d j).toInt • Q) := by
  have he := htab (d j).toInt.natAbs (by omega)
  rw [zsmul_natAbs]
  simp only [selK]
  split
  · refine he.operand_neg.congr ?_ ?_ ?_ ?_ <;> rw [Fe.ofLanes_val] <;>
      simp only [*, decide_true, ↓reduceIte]
  · refine he.operand.congr ?_ ?_ ?_ ?_ <;> rw [Fe.ofLanes_val] <;>
      simp only [*, decide_false, Bool.false_eq_true, ↓reduceIte]

theorem selK_f52 {tab : ℕ → Niels} (htab : ∀ e, (tab e).Bounded) (d : Fin 8 → BitVec 8) :
    (selK tab d).1.F52 ∧ (selK tab d).2.1.F52 ∧ (selK tab d).2.2.1.F52 ∧
      (selK tab d).2.2.2.F52 := by
  simp only [selK]
  refine ⟨Fe.ofLanes_le fun j i => ?_, Fe.ofLanes_le fun j i => ?_,
    Fe.ofLanes_le fun j i => ?_, Fe.ofLanes_le fun j i => ?_⟩
  · split
    · exact (htab _).2.1.f52 j i
    · exact (htab _).1.f52 j i
  · split
    · exact (htab _).1.f52 j i
    · exact (htab _).2.1.f52 j i
  · split
    · exact (htab _).2.2.2.1 j i
    · exact (htab _).2.2.1.f52 j i
  · exact (htab _).2.2.2.2.f52 j i

theorem baseFe_val (tbl : ℕ → BitVec 64) (e off : ℕ) (j : Fin 8) :
    (baseFe tbl e off).val j = Ed25519.Limbs.val (baseLimbs tbl e off) :=
  Fe.ofLanes_val _ j

/-- The `[S]` operand of lane `j` is its digit times `B`. -/
theorem selB_operand {tbl : ℕ → BitVec 64} (htbl : BaseOk tbl) {j : Fin 8}
    {d : Fin 8 → BitVec 16} (hd : -128 ≤ (d j).toInt ∧ (d j).toInt < 128) :
    Operand (selB tbl d).1 (selB tbl d).2.1 (selB tbl d).2.2 Fe.one j
      ((d j).toInt • basePoint) := by
  have he := ((htbl (d j).toInt.natAbs (by omega)).1 j)
  have hn := he.2
  rw [baseFe_val, baseFe_val] at hn
  rw [zsmul_natAbs]
  simp only [selB]
  split
  · refine (he.1.neg he.2).congr ?_ ?_ ?_ rfl <;> rw [Fe.ofLanes_val] <;>
      simp only [*, decide_true, ↓reduceIte, baseFe_val]
  · refine he.1.congr ?_ ?_ ?_ rfl <;> rw [Fe.ofLanes_val] <;>
      simp only [*, decide_false, Bool.false_eq_true, ↓reduceIte, baseFe_val]

theorem selB_f52 {tbl : ℕ → BitVec 64} (htbl : BaseOk tbl) (s : Fin 8 → BitVec 256) {w : ℕ}
    (hw : w < 32) :
    (selB tbl fun j => recode8 (s j) w).1.F52 ∧ (selB tbl fun j => recode8 (s j) w).2.1.F52 ∧
      (selB tbl fun j => recode8 (s j) w).2.2.F52 := by
  have hb (j : Fin 8) := htbl (recode8 (s j) w).toInt.natAbs (by
    have := recode8_range (s j) hw
    omega)
  have hl (j : Fin 8) (e off : ℕ) : baseLimbs tbl e off = (baseFe tbl e off).lane j :=
    (Fe.ofLanes_lane (fun _ => baseLimbs tbl e off) j).symm
  simp only [selB]
  refine ⟨Fe.ofLanes_le fun j i => ?_, Fe.ofLanes_le fun j i => ?_, Fe.ofLanes_le fun j i => ?_⟩
  all_goals
    rw [hl j]
    split
  · exact (hb j).2.2.1.f52 j i
  · exact (hb j).2.1.f52 j i
  · exact (hb j).2.1.f52 j i
  · exact (hb j).2.2.1.f52 j i
  · exact (hb j).2.2.2.2 j i
  · exact (hb j).2.2.2.1.f52 j i

/-! ## The ladder -/

/-- The four doublings of a window. -/
def dbl4 (acc : Point) : Point :=
  let acc := acc.dbl false acc.t
  let acc := acc.dbl false acc.t
  let acc := acc.dbl false acc.t
  acc.dbl true acc.t

/-- A window with its doublings folded and its operands as projections. -/
theorem window_eq (tab : ℕ → Niels) (tbl : ℕ → BitVec 64) (k s : Fin 8 → BitVec 256) (w : ℕ)
    (acc : Point) :
    window tab tbl k s w acc =
      let acc := if w = 63 then acc else dbl4 acc
      let q := selK tab fun j => recode4 (k j) w
      let acc := acc.addQ q.1 q.2.1 q.2.2.1 q.2.2.2 false (w % 2 = 0) acc.t
      if w % 2 = 0 then
        let b := selB tbl fun j => recode8 (s j) (w / 2)
        acc.addQ b.1 b.2.1 b.2.2 Fe.one true false acc.t
      else acc :=
  rfl

/-- `[2m]V` projective from `[m]V`. -/
theorem Point.dbl_proj_nsmul {P : Point} {j : Fin 8} {V : Ed25519.Point} {m : ℕ}
    (h : P.Proj j (m • V)) (hb : P.Carried) (withT : Bool) :
    (P.dbl withT P.t).Proj j ((2 * m) • V) := by
  rw [two_mul, add_nsmul]
  exact Point.dbl_proj h hb.xyz withT P.t

/-- Four doublings of projective `V`: extended `16 V`. -/
theorem dbl4_ext {acc : Point} {j : Fin 8} {V : Ed25519.Point} (h : acc.Proj j V)
    (hb : acc.Carried) : (dbl4 acc).Ext j (16 • V) ∧ (dbl4 acc).Carried := by
  have p1 : acc.Proj j (1 • V) := by rwa [one_smul]
  have p2 := Point.dbl_proj_nsmul p1 hb false
  have c2 := Point.dbl_carried' hb false
  have p3 := Point.dbl_proj_nsmul p2 c2 false
  have c3 := Point.dbl_carried' c2 false
  have p4 := Point.dbl_proj_nsmul p3 c3 false
  have c4 := Point.dbl_carried' c3 false
  refine ⟨?_, Point.dbl_carried c4.xyz _⟩
  have e5 := Point.dbl_ext p4 c4.xyz
  rw [← add_nsmul] at e5
  exact e5 _

/-- Window `w` on `acc`, projective `V` (extended, `V = 0` at the top window): `16 V` plus the
window's digits. -/
theorem window_proj {tab : ℕ → Niels} {tbl : ℕ → BitVec 64} {k s : Fin 8 → BitVec 256}
    {j : Fin 8} {A : Ed25519.Point} (htab : ∀ e ≤ 8, (tab e).Is j (e • A))
    (htabb : ∀ e, (tab e).Bounded) (htbl : BaseOk tbl) {w : ℕ} (hw : w < 64) {acc : Point}
    {V : Ed25519.Point} (h : acc.Proj j V) (hb : acc.Carried)
    (h63 : w = 63 → acc.Ext j V ∧ V = 0) :
    (window tab tbl k s w acc).Proj j (16 • V + (recode4 (k j) w).toInt • A +
        (if w % 2 = 0 then (recode8 (s j) (w / 2)).toInt else 0) • basePoint) ∧
      (window tab tbl k s w acc).Carried := by
  rw [window_eq]
  dsimp only
  have ⟨e1, c1⟩ : (if w = 63 then acc else dbl4 acc).Ext j (16 • V) ∧
      (if w = 63 then acc else dbl4 acc).Carried := by
    split
    · obtain ⟨he, rfl⟩ := h63 ‹_›
      rw [smul_zero]
      exact ⟨he, hb⟩
    · exact dbl4_ext h hb
  generalize (if w = 63 then acc else dbl4 acc) = acc1 at e1 c1 ⊢
  have hq := selK_operand htab (d := fun j => recode4 (k j) w) (recode4_range _ hw)
  have hqb := selK_f52 htabb fun j => recode4 (k j) w
  generalize selK tab (fun j => recode4 (k j) w) = q at hq hqb ⊢
  have hq3 : q.1.F52 ∧ q.2.1.F52 ∧ q.2.2.1.F52 := ⟨hqb.1, hqb.2.1, hqb.2.2.1⟩
  have c2 := Point.addQ_carried' (affine := false) c1 hq3 (fun _ => hqb.2.2.2)
    (decide (w % 2 = 0))
  split
  · rename_i hw2
    have e2 := Point.addQ_ext (affine := false) e1 c1 hq hq3 (fun _ => hqb.2.2.2) acc1.t
    have hb' := selB_operand htbl (j := j) (d := fun j => recode8 (s j) (w / 2))
      (recode8_range _ (by omega))
    have hbb := selB_f52 htbl s (w := w / 2) (by omega)
    simp only [hw2, decide_true] at c2 ⊢
    exact ⟨Point.addQ_proj (affine := true) e2 c2 hb' hbb nofun false _,
      Point.addQ_carried' (affine := true) c2 hbb nofun false⟩
  · rw [zero_smul, add_zero]
    exact ⟨Point.addQ_proj (affine := false) e1 c1 hq hq3 (fun _ => hqb.2.2.2) _ _, c2⟩

/-- `k`'s digits from window `64 - n` up, Horner from the top. -/
def kacc (k : BitVec 256) : ℕ → ℤ
  | 0 => 0
  | n + 1 => 16 * kacc k n + (recode4 k (63 - n)).toInt

/-- `S`'s digits from window `64 - n` up, at the even windows. -/
def sacc (s : BitVec 256) : ℕ → ℤ
  | 0 => 0
  | n + 1 => 16 * sacc s n + if (63 - n) % 2 = 0 then (recode8 s ((63 - n) / 2)).toInt else 0

/-- `n` windows from the identity: projective `[kacc n] A + [sacc n] B`, extended before the
first. -/
theorem ladder_proj {tab : ℕ → Niels} {tbl : ℕ → BitVec 64} {k s : Fin 8 → BitVec 256}
    {j : Fin 8} {A : Ed25519.Point} (htab : ∀ e ≤ 8, (tab e).Is j (e • A))
    (htabb : ∀ e, (tab e).Bounded) (htbl : BaseOk tbl) :
    ∀ n ≤ 64,
      (ladder tab tbl k s n Point.zero).Proj j (kacc (k j) n • A + sacc (s j) n • basePoint) ∧
      (ladder tab tbl k s n Point.zero).Carried ∧
      (n = 0 →
        (ladder tab tbl k s n Point.zero).Ext j (kacc (k j) n • A + sacc (s j) n • basePoint))
  | 0, _ => by
    simp only [ladder, kacc, sacc, zero_smul, add_zero]
    exact ⟨(Point.zero_ext j).proj, Point.zero_carried, fun _ => Point.zero_ext j⟩
  | n + 1, hn => by
    obtain ⟨h, hb, h0⟩ := ladder_proj (k := k) (s := s) htab htabb htbl n (by omega)
    have hw := window_proj htab htabb htbl (k := k) (s := s) (w := 63 - n) (by omega) h hb
      fun h63 => ⟨h0 (by omega), by
        obtain rfl : n = 0 := by omega
        simp [kacc, sacc]⟩
    refine ⟨?_, hw.2, nofun⟩
    have e : 16 • (kacc (k j) n • A + sacc (s j) n • basePoint) +
        (recode4 (k j) (63 - n)).toInt • A +
        (if (63 - n) % 2 = 0 then (recode8 (s j) ((63 - n) / 2)).toInt else 0) • basePoint =
        kacc (k j) (n + 1) • A + sacc (s j) (n + 1) • basePoint := by
      simp only [kacc, sacc]
      module
    rw [← e]
    exact hw.1

/-- The digits Horner-summed from the top: the low windows' sum plus the rest scaled. -/
theorem kacc_sum (k : BitVec 256) : ∀ n ≤ 64,
    kacc k n * 16 ^ (64 - n) + ∑ w ∈ Finset.range (64 - n), (recode4 k w).toInt * 16 ^ w =
      ∑ w ∈ Finset.range 64, (recode4 k w).toInt * 16 ^ w
  | 0, _ => by simp [kacc]
  | n + 1, hn => by
    rw [← kacc_sum k n (by omega), show 64 - n = 63 - n + 1 by omega, Finset.sum_range_succ,
      kacc, show 64 - (n + 1) = 63 - n by omega, pow_succ]
    ring

theorem sacc_sum (s : BitVec 256) : ∀ n ≤ 64,
    sacc s n * 16 ^ (64 - n) + ∑ w ∈ Finset.range (64 - n),
        (if w % 2 = 0 then (recode8 s (w / 2)).toInt else 0) * 16 ^ w =
      ∑ w ∈ Finset.range 64, (if w % 2 = 0 then (recode8 s (w / 2)).toInt else 0) * 16 ^ w
  | 0, _ => by simp [sacc]
  | n + 1, hn => by
    rw [← sacc_sum s n (by omega), show 64 - n = 63 - n + 1 by omega, Finset.sum_range_succ,
      sacc, show 64 - (n + 1) = 63 - n by omega, pow_succ]
    ring

/-- The even windows' digits are the radix-256 digits. -/
theorem sum_even (f : ℕ → ℤ) : ∀ m, ∑ w ∈ Finset.range (2 * m),
    (if w % 2 = 0 then f (w / 2) else 0) * 16 ^ w = ∑ u ∈ Finset.range m, f u * 256 ^ u
  | 0 => by simp
  | m + 1 => by
    have h1 : 2 * m % 2 = 0 := by omega
    have h2 : 2 * m / 2 = m := by omega
    have h3 : (2 * m + 1) % 2 = 1 := by omega
    rw [show 2 * (m + 1) = 2 * m + 1 + 1 by ring, Finset.sum_range_succ, Finset.sum_range_succ,
      sum_even f m, Finset.sum_range_succ, h1, h2, h3, pow_mul]
    norm_num

theorem kacc_64 {k : BitVec 256} (hk : k.toNat < 2 ^ 253) : kacc k 64 = k.toNat := by
  have := kacc_sum k 64 le_rfl
  rw [← recode4_sum hk, Fin.sum_univ_eq_sum_range (fun w => (recode4 k w).toInt * 16 ^ w)]
  simpa using this

theorem sacc_64 {s : BitVec 256} (hs : s.toNat < 2 ^ 253) : sacc s 64 = s.toNat := by
  have := sacc_sum s 64 le_rfl
  rw [← recode8_sum hs, Fin.sum_univ_eq_sum_range (fun w => (recode8 s w).toInt * 256 ^ w),
    ← sum_even _ 32]
  simpa using this

/-! ## The equation -/

theorem carriedB_add_le (i : Fin 5) : carriedB i + 2 ^ 52 ≤ 2 ^ 53 - 1 := by
  unfold carriedB
  split <;> norm_num

/-- `R z - x` of a carried `x` and an f52 `R`. -/
theorem subRaw_mul_val {r z x : Fe} (hr : r.F52) (hz : z.Carried) (hx : x.Carried) (j : Fin 8) :
    (subRaw (mul r z) x).Le (fun _ => 2 ^ 53 - 1) ∧
      (subRaw (mul r z) x).val j = r.val j * z.val j - x.val j := by
  have hm := mul_carried hr hz.f52
  have hc (i : Fin 5) : carriedB i < 2 ^ 63 := by
    have := carriedB_add_le i
    omega
  refine ⟨(subRaw_le hm hx hc).mono carriedB_add_le, ?_⟩
  rw [subRaw_val hm hx hc, mul_val hr hz.f52]

/-- Bit `j` of `fd_ed25519_lane_verify` is `[k](-A) + [S]B = R` in lane `j`: `a = -A` with `z = 1`
and `x, y, t` carried, `R` f52 with `z = 1`, the scalars below `2^253`. -/
public theorem verify_getLsbD {k2d : Fe} {tbl : ℕ → BitVec 64} {a r : Point}
    {k s : Fin 8 → BitVec 256} {j : Fin 8} {A R : Ed25519.Point} (hk2d : k2d.val j = 2 * d)
    (hk2db : k2d.F52) (htbl : BaseOk tbl) (ha : a.Ext j (-A)) (haz : a.z = Fe.one)
    (hab : a.Carried) (hrx : r.x.val j = R.x) (hry : r.y.val j = R.y) (hrb : r.x.F52 ∧ r.y.F52)
    (hk : (k j).toNat < 2 ^ 253) (hs : (s j).toNat < 2 ^ 253) :
    (verify k2d tbl a r k s).getLsbD j =
      decide ((k j).toNat • -A + (s j).toNat • basePoint = R) := by
  obtain ⟨hP, hC, -⟩ := ladder_proj (k := k) (s := s)
    (fun e he => ktab_is ha haz hab hk2d hk2db he) (ktab_bounded haz hab hk2db) htbl 64 le_rfl
  rw [kacc_64 hk, sacc_64 hs, natCast_zsmul, natCast_zsmul] at hP
  simp only [verify]
  generalize ladder (ktab a k2d) tbl k s 64 Point.zero = acc at hP hC ⊢
  generalize (k j).toNat • -A + (s j).toNat • basePoint = P at hP ⊢
  obtain ⟨hz0, ex, ey⟩ := hP
  obtain ⟨bx, vx⟩ := subRaw_mul_val hrb.1 hC.1.2.2 hC.1.1 j
  obtain ⟨by', vy⟩ := subRaw_mul_val hrb.2 hC.1.2.2 hC.1.2.1 j
  rw [BitVec.getLsbD_and, isZero_getLsbD bx, isZero_getLsbD by', vx, vy, ex, ey, hrx, hry,
    ← Bool.decide_and]
  refine decide_eq_decide.2 ?_
  rw [_root_.Ed25519.Point.ext_iff, ← sub_mul, ← sub_mul, mul_eq_zero, mul_eq_zero, sub_eq_zero,
    sub_eq_zero]
  simp only [hz0, or_false]
  exact ⟨fun ⟨h1, h2⟩ => ⟨h1.symm, h2.symm⟩, fun ⟨h1, h2⟩ => ⟨h1.symm, h2.symm⟩⟩

public theorem verify_lt (k2d : Fe) (tbl : ℕ → BitVec 64) (a r : Point)
    (k s : Fin 8 → BitVec 256) : (verify k2d tbl a r k s).toNat < 2 ^ 8 := by
  simp only [verify]
  rw [BitVec.toNat_and]
  exact lt_of_le_of_lt Nat.and_le_left (isZero_lt _)

end MLIR.Firedancer.Lane

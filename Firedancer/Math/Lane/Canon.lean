module

public import Firedancer.Math.Lane.Fe
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum

/-! `fd_ed25519_lane_normalize` below `2^255`, and the canonical parity `fd_ed25519_lane_decode2`
reads from it: the normalized limbs are below `2^51`, so only `p … p + 18` are noncanonical, and
`geP` detects exactly those. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p)
open Firedancer.Avx512

/-! ## Lanes -/

theorem lane_wwl_add (x y : Wwl) (j : Fin 8) : (wwl_add x y)[j] = x[j] + y[j] := by
  simp [wwl_add]

theorem lane_wwl_and (x y : Wwl) (j : Fin 8) : (wwl_and x y)[j] = x[j] &&& y[j] := by
  simp [wwl_and]

theorem lane_wwl_mul (x y : Wwl) (j : Fin 8) : (wwl_mul x y)[j] = x[j] * y[j] := by
  simp [wwl_mul]

theorem lane_wwl_shru (x : Wwl) (n : ℕ) (j : Fin 8) : (wwl_shru x n)[j] = x[j] >>> n := by
  simp [wwl_shru]

theorem lane_wwl_zero (j : Fin 8) : (wwl_zero)[j] = 0 := by
  simp

theorem lane_wwl_bcast (x : BitVec 64) (j : Fin 8) : (wwl_bcast x)[j] = x := by
  simp [wwl_bcast]

/-! ## Normalization -/

/-- One pass of `fd_ed25519_lane_normalize` on a lane's limbs. -/
def normL (l : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let l1 := l 1 + (l 0 >>> 51)
  let l0 := l 0 &&& mask51
  let l2 := l 2 + (l1 >>> 51)
  let l1 := l1 &&& mask51
  let l3 := l 3 + (l2 >>> 51)
  let l2 := l2 &&& mask51
  let l4 := l 4 + (l3 >>> 51)
  let l3 := l3 &&& mask51
  ![l0 + (l4 >>> 51) * 19, l1, l2, l3, l4 &&& mask51]

theorem Fe.lane0 (a : Fe) (j : Fin 8) : a.lane j 0 = a.l0[j] := rfl
theorem Fe.lane1 (a : Fe) (j : Fin 8) : a.lane j 1 = a.l1[j] := rfl
theorem Fe.lane2 (a : Fe) (j : Fin 8) : a.lane j 2 = a.l2[j] := rfl
theorem Fe.lane3 (a : Fe) (j : Fin 8) : a.lane j 3 = a.l3[j] := rfl
theorem Fe.lane4 (a : Fe) (j : Fin 8) : a.lane j 4 = a.l4[j] := rfl

/-- `normalize` lane by lane: two passes. -/
theorem normalize_lane (a : Fe) (j : Fin 8) :
    (normalize a).lane j = normL (normL (a.lane j)) := by
  funext i
  fin_cases i <;>
    simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, Fe.lane0, Fe.lane1, Fe.lane2, Fe.lane3,
      Fe.lane4, normalize, lane_wwl_add, lane_wwl_and, lane_wwl_shru, lane_wwl_mul,
      lane_wwl_bcast] <;>
    rfl

theorem toNat_add' {x y : BitVec 64} (h : x.toNat + y.toNat < 2 ^ 64) :
    (x + y).toNat = x.toNat + y.toNat := by
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt h]

/-- A pass in `ℕ`: carries `t1 … t4` up, the top one folded by `19`. -/
theorem normL_toNat (l : Fin 5 → BitVec 64) (h : ∀ i, (l i).toNat < 2 ^ 62) :
    let t1 := (l 1).toNat + (l 0).toNat / 2 ^ 51
    let t2 := (l 2).toNat + t1 / 2 ^ 51
    let t3 := (l 3).toNat + t2 / 2 ^ 51
    let t4 := (l 4).toNat + t3 / 2 ^ 51
    (normL l 0).toNat = (l 0).toNat % 2 ^ 51 + t4 / 2 ^ 51 * 19 ∧ (normL l 1).toNat = t1 % 2 ^ 51 ∧
      (normL l 2).toNat = t2 % 2 ^ 51 ∧ (normL l 3).toNat = t3 % 2 ^ 51 ∧
      (normL l 4).toNat = t4 % 2 ^ 51 := by
  intro t1 t2 t3 t4
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3; have h4 := h 4
  have e1 : (l 1 + (l 0 >>> 51)).toNat = t1 := by
    rw [toNat_add' (by rw [Ed25519.toNat_shift]; omega), Ed25519.toNat_shift]
  have e2 : (l 2 + ((l 1 + (l 0 >>> 51)) >>> 51)).toNat = t2 := by
    rw [toNat_add' (by rw [Ed25519.toNat_shift]; omega), Ed25519.toNat_shift, e1]
  have e3 : (l 3 + ((l 2 + ((l 1 + (l 0 >>> 51)) >>> 51)) >>> 51)).toNat = t3 := by
    rw [toNat_add' (by rw [Ed25519.toNat_shift]; omega), Ed25519.toNat_shift, e2]
  have e4 : (l 4 + ((l 3 + ((l 2 + ((l 1 + (l 0 >>> 51)) >>> 51)) >>> 51)) >>> 51)).toNat = t4 := by
    rw [toNat_add' (by rw [Ed25519.toNat_shift]; omega), Ed25519.toNat_shift, e3]
  have m (x : BitVec 64) : (x &&& mask51).toNat = x.toNat % 2 ^ 51 := Ed25519.toNat_and_mask x
  have : t4 / 2 ^ 51 < 2 ^ 12 := by omega
  have e19 : ((l 4 + ((l 3 + ((l 2 + ((l 1 + (l 0 >>> 51)) >>> 51)) >>> 51)) >>> 51)) >>> 51 *
      19).toNat = t4 / 2 ^ 51 * 19 := by
    rw [BitVec.toNat_mul, Ed25519.toNat_shift, e4, show (19 : BitVec 64).toNat = 19 from rfl]; omega
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · change ((l 0 &&& mask51) + _).toNat = _
    rw [toNat_add' (by rw [m, e19]; omega), m, e19]
  · change (_ &&& mask51).toNat = _; rw [m, e1]
  · change (_ &&& mask51).toNat = _; rw [m, e2]
  · change (_ &&& mask51).toNat = _; rw [m, e3]
  · change (_ &&& mask51).toNat = _; rw [m, e4]

/-- A pass keeps the number mod `p`: the top carry `c` leaves as `2^255 c` and returns as `19 c`. -/
theorem normL_val {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : ℕ}
    (h0 : y0 = x0 % 2 ^ 51 +
      (x4 + (x3 + (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51 * 19)
    (h1 : y1 = (x1 + x0 / 2 ^ 51) % 2 ^ 51)
    (h2 : y2 = (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) % 2 ^ 51)
    (h3 : y3 = (x3 + (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) % 2 ^ 51)
    (h4 : y4 = (x4 + (x3 + (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) % 2 ^ 51) :
    ((y0 + y1 * 2 ^ 51 + y2 * 2 ^ 102 + y3 * 2 ^ 153 + y4 * 2 ^ 204 : ℕ) : ZMod p) =
      ((x0 + x1 * 2 ^ 51 + x2 * 2 ^ 102 + x3 * 2 ^ 153 + x4 * 2 ^ 204 : ℕ) : ZMod p) := by
  generalize hc : (x4 + (x3 + (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51 = c
    at h0
  have e : y0 + y1 * 2 ^ 51 + y2 * 2 ^ 102 + y3 * 2 ^ 153 + y4 * 2 ^ 204 + 2 ^ 255 * c =
      x0 + x1 * 2 ^ 51 + x2 * 2 ^ 102 + x3 * 2 ^ 153 + x4 * 2 ^ 204 + 19 * c := by omega
  have := congrArg (Nat.cast (R := ZMod p)) e
  push_cast at this ⊢
  linear_combination this - (c : ZMod p) * Ed25519.two_pow_255

/-- `fd_ed25519_lane_normalize` of limbs below `2^53`: limbs below `2^51`, a number below `2^255`,
the same value. -/
public theorem normalize_canon {a : Fe} (ha : a.Le fun _ => 2 ^ 53 - 1) (j : Fin 8) :
    (∀ i, ((normalize a).lane j i).toNat < 2 ^ 51) ∧
      Ed25519.Limbs.nat ((normalize a).lane j) < 2 ^ 255 ∧
      Ed25519.Limbs.val ((normalize a).lane j) = a.val j := by
  rw [normalize_lane, show a.val j = Ed25519.Limbs.val (a.lane j) from rfl]
  have hl := ha j
  generalize a.lane j = l at hl ⊢
  have b0 := hl 0; have b1 := hl 1; have b2 := hl 2; have b3 := hl 3; have b4 := hl 4
  obtain ⟨f0, f1, f2, f3, f4⟩ := normL_toNat l fun i => (hl i).trans_lt (by norm_num)
  generalize normL l = m at f0 f1 f2 f3 f4
  have hm : ∀ i, (m i).toNat < 2 ^ 62 := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega
  obtain ⟨g0, g1, g2, g3, g4⟩ := normL_toNat m hm
  generalize normL m = n at g0 g1 g2 g3 g4
  simp only [Ed25519.Limbs.nat] at *
  refine ⟨fun i => ?_, by omega, ?_⟩
  · fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega
  · rw [Ed25519.Limbs.val_nat, Ed25519.Limbs.val_nat, Ed25519.Limbs.nat, Ed25519.Limbs.nat,
      normL_val g0 g1 g2 g3 g4, normL_val f0 f1 f2 f3 f4]

/-! ## Masks -/

/-- Bit `j` of eight packed lane tests, widened: lane `j`'s test. -/
public theorem getLsbD_lanes (f : Fin 8 → Bool) (j : Fin 8) :
    ((BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (f i))).setWidth 32).getLsbD j =
      f j := by
  have h := congrArg (·.getLsbD 0)
    (BitVec.extractLsb'_packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (f i)) j j.2)
  simp only [mul_one, BitVec.getLsbD_extractLsb', Nat.add_zero, Nat.lt_one_iff, decide_true,
    Bool.true_and, Vector.getElem_ofFn, BitVec.getLsbD_ofBool, Fin.eta] at h
  rw [BitVec.getLsbD_setWidth, h, show decide ((j : ℕ) < 32) = true by simp; omega,
    Bool.true_and]

/-- `geP`: limbs below `2^51` reach `p` exactly when limb 0 is at least `2^51 - 19` and the others
are `2^51 - 1`. -/
theorem geP_eq {l : Fin 5 → BitVec 64} (hl : ∀ i, (l i).toNat < 2 ^ 51) :
    (decide (mask51 - 18 ≤ l 0) && l 1 == mask51 && l 2 == mask51 && l 3 == mask51 &&
      l 4 == mask51) = decide (p ≤ Ed25519.Limbs.nat l) := by
  have b0 := hl 0; have b1 := hl 1; have b2 := hl 2; have b3 := hl 3; have b4 := hl 4
  rw [Bool.eq_iff_iff]
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, BitVec.le_def, ← BitVec.toNat_inj,
    Ed25519.Limbs.nat, show (mask51 - 18).toNat = 2 ^ 51 - 19 from rfl,
    show mask51.toNat = 2 ^ 51 - 1 from rfl, show p = 2 ^ 255 - 19 from rfl]
  omega

/-- `fd_ed25519_lane_decode2`'s parity of limbs below `2^53`: limb 0's low bit after `normalize`,
flipped by `geP` (the number in `p … p + 18`), is the reduced value's. -/
public theorem parity_getLsbD {a : Fe} (ha : a.Le fun _ => 2 ^ 53 - 1) (j : Fin 8) :
    (wwl_ne (wwl_and (normalize a).l0 wwl_one) wwl_zero ^^^
        (wwl_geu (normalize a).l0 (wwl_bcast (mask51 - 18)) &&&
          wwl_eq (normalize a).l1 (wwl_bcast mask51) &&&
          wwl_eq (normalize a).l2 (wwl_bcast mask51) &&&
          wwl_eq (normalize a).l3 (wwl_bcast mask51) &&&
          wwl_eq (normalize a).l4 (wwl_bcast mask51))).getLsbD j =
      decide ((a.val j).val % 2 = 1) := by
  obtain ⟨hl, hn, hv⟩ := normalize_canon ha j
  have g := geP_eq hl
  simp only [Fe.lane0, Fe.lane1, Fe.lane2, Fe.lane3, Fe.lane4] at g hl hn hv
  rw [← hv]
  simp only [BitVec.getLsbD_xor, BitVec.getLsbD_and, wwl_ne, wwl_geu, wwl_eq, getLsbD_lanes,
    lane_wwl_and, lane_wwl_bcast, wwl_one, lane_wwl_zero]
  simp only [BitVec.le_def] at g ⊢
  rw [g, Ed25519.Limbs.val_nat, ZMod.val_natCast]
  have h1 (x : BitVec 64) : (x &&& 1 != 0) = decide (x.toNat % 2 = 1) := by
    have e : (x &&& 1).toNat = x.toNat % 2 := by
      rw [BitVec.toNat_and, show (1 : BitVec 64).toNat = 1 from rfl, Nat.and_one_is_mod]
    rw [Bool.eq_iff_iff, bne_iff_ne, ne_eq, decide_eq_true_iff, ← BitVec.toNat_inj, e,
      show (0 : BitVec 64).toNat = 0 from rfl]
    omega
  rw [h1]
  have hp : p = 2 ^ 255 - 19 := rfl
  have e0 : Ed25519.Limbs.nat ((normalize a).lane j) % 2 = (normalize a).l0[j].toNat % 2 := by
    simp only [Ed25519.Limbs.nat, Fe.lane0]
    omega
  generalize Ed25519.Limbs.nat ((normalize a).lane j) = N at hn e0
  generalize (normalize a).l0[j].toNat = l0 at e0
  by_cases h : p ≤ N
  · rw [decide_eq_true h, Bool.xor_true, ← decide_not, decide_eq_decide,
      Nat.mod_eq_sub_mod h, Nat.mod_eq_of_lt (a := N - p) (b := p) (by omega)]
    omega
  · rw [decide_eq_false h, Bool.xor_false, decide_eq_decide,
      Nat.mod_eq_of_lt (a := N) (b := p) (by omega)]
    omega

end MLIR.Firedancer.Lane

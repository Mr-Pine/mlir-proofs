module

public import Firedancer.Math.Lane.Verify
public import Firedancer.Lane.Mlir.fd_ed25519_lane_base_table
public import Firedancer.Math.BaseTable
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! `fd_ed25519_lane_base_table`: entry `e ≤ 128` is `[e]B` in the affine table form
`y + x, y - x, 2dxy, 2p - 2dxy`. The kernel checks the global's ulongs in one pass, mod `p`:
entry 0 is the identity, each next one the previous plus `B`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d basePoint)
open Firedancer.Ref (addOk dN dN_eq add_of_ok)

/-! ## Definitions -/

@[expose] public section

/-- `fd_ed25519_lane_base_table[i]`, the global's ulongs. -/
noncomputable def laneTbl (i : ℕ) : BitVec 64 :=
  if h : i < 2580 then Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit[i] else 0

end

/-! ## The check -/

/-- The global's ulongs, in order. -/
noncomputable abbrev tblList : List (BitVec 64) :=
  Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit.toList

/-- Five limbs at the head of `l`, radix `2^51`. -/
def nat5 (l : List (BitVec 64)) : ℕ :=
  (l.getD 0 0).toNat + (l.getD 1 0).toNat * 2 ^ 51 + (l.getD 2 0).toNat * 2 ^ 102 +
    (l.getD 3 0).toNat * 2 ^ 153 + (l.getD 4 0).toNat * 2 ^ 204

/-- The five limbs at the head of `l` below `c`. -/
def lt5 (l : List (BitVec 64)) (c : ℕ) : Bool :=
  (l.getD 0 0).toNat < c && (l.getD 1 0).toNat < c && (l.getD 2 0).toNat < c &&
    (l.getD 3 0).toNat < c && (l.getD 4 0).toNat < c

/-- An entry's affine point, from its `y + x`, `y - x`: half their difference and sum, mod `p`. -/
def entryXY (e : List (BitVec 64)) : ℕ × ℕ :=
  ((nat5 e + p - nat5 (e.drop 5) % p) * ((p + 1) / 2) % p,
    (nat5 e + nat5 (e.drop 5)) * ((p + 1) / 2) % p)

/-- The entry's `2dxy` and `2p - 2dxy`, and its limb ranges. -/
def entryOk (e : List (BitVec 64)) : Bool :=
  nat5 (e.drop 10) % p == 2 * dN * (entryXY e).1 * (entryXY e).2 % p &&
    (nat5 (e.drop 15) + nat5 (e.drop 10)) % p == 0 &&
    lt5 e (2 ^ 51) && lt5 (e.drop 5) (2 ^ 51) && lt5 (e.drop 10) (2 ^ 51) &&
    lt5 (e.drop 15) (2 ^ 52)

/-- `n` more entries of `l`, each fine and the previous one's point plus `B`. -/
def tblChk : ℕ → List (BitVec 64) → ℕ → ℕ → Bool
  | 0, _, _, _ => true
  | n + 1, l, px, py =>
    entryOk (l.take 20) &&
      addOk px py Ed25519.Bx.val Ed25519.By.val (entryXY (l.take 20)).1 (entryXY (l.take 20)).2 &&
      tblChk n (l.drop 20) (entryXY (l.take 20)).1 (entryXY (l.take 20)).2

theorem tbl_ok :
    (entryOk (tblList.take 20) && entryXY (tblList.take 20) == (0, 1) &&
      tblChk 128 (tblList.drop 20) 0 1) = true := by
  decide +kernel

/-! ## Entries -/

/-- Entry `k`'s 20 ulongs. -/
noncomputable def ent (k : ℕ) : List (BitVec 64) :=
  (tblList.drop (20 * k)).take 20

theorem tblList_length : tblList.length = 2580 :=
  Vector.length_toList

theorem tblChk_ents {n k : ℕ} (h : tblChk n (tblList.drop (20 * (k + 1))) (entryXY (ent k)).1
    (entryXY (ent k)).2 = true) :
    ∀ m < n, entryOk (ent (k + 1 + m)) = true ∧
      addOk (entryXY (ent (k + m))).1 (entryXY (ent (k + m))).2 Ed25519.Bx.val Ed25519.By.val
        (entryXY (ent (k + 1 + m))).1 (entryXY (ent (k + 1 + m))).2 = true := by
  induction n generalizing k with
  | zero => intro m hm; omega
  | succ n ih =>
    simp only [tblChk, Bool.and_eq_true] at h
    obtain ⟨⟨h1, h2⟩, h3⟩ := h
    have he : (tblList.drop (20 * (k + 1))).take 20 = ent (k + 1) := rfl
    have hd : (tblList.drop (20 * (k + 1))).drop 20 = tblList.drop (20 * (k + 1 + 1)) := by
      rw [List.drop_drop]; congr 1
    rw [he] at h1 h2 h3
    rw [hd] at h3
    intro m hm
    rcases m with _ | m
    · exact ⟨h1, h2⟩
    · have := ih h3 m (by omega)
      rw [show k + 1 + 1 + m = k + 1 + (m + 1) by ring,
        show k + 1 + m = k + (m + 1) by ring] at this
      exact this

/-- Every entry fine, entry 0 the identity, each next one the previous plus `B`. -/
theorem ents_ok :
    (∀ k ≤ 128, entryOk (ent k) = true) ∧ entryXY (ent 0) = (0, 1) ∧
      ∀ k < 128, addOk (entryXY (ent k)).1 (entryXY (ent k)).2 Ed25519.Bx.val Ed25519.By.val
        (entryXY (ent (k + 1))).1 (entryXY (ent (k + 1))).2 = true := by
  have h := tbl_ok
  simp only [Bool.and_eq_true, beq_iff_eq] at h
  obtain ⟨⟨h0, hxy⟩, hc⟩ := h
  have e0 : tblList.take 20 = ent 0 := by simp [ent]
  rw [e0] at h0 hxy
  have hc' := tblChk_ents (k := 0) (n := 128) (by rw [hxy]; simpa using hc)
  refine ⟨fun k hk => ?_, hxy, fun k hk => ?_⟩
  · rcases k with _ | k
    · exact h0
    · have := (hc' k (by omega)).1
      rwa [show 0 + 1 + k = k + 1 by omega] at this
  · have := (hc' k hk).2
    rwa [show 0 + 1 + k = k + 1 by omega, Nat.zero_add] at this

/-- Ulong `i` from `off` of entry `e ≤ 128` is the table's. -/
theorem ent_getD {e off i : ℕ} (he : e ≤ 128) (hi : off + i < 20) :
    ((ent e).drop off).getD i 0 = laneTbl (20 * e + off + i) := by
  have hlt : 20 * e + off + i < 2580 := by omega
  simp only [ent, List.getD_eq_getElem?_getD, List.getElem?_drop, List.getElem?_take, hi,
    ↓reduceIte, laneTbl, hlt, dite_true]
  rw [List.getElem?_eq_getElem (by rw [tblList_length]; omega)]
  simp [tblList, Nat.add_assoc]

/-- Entry `e`'s limbs at `off` are `nat5` of its ulongs from `off`. -/
theorem nat_baseLimbs {e off : ℕ} (he : e ≤ 128) (hoff : off ≤ 15) :
    Ed25519.Limbs.nat (baseLimbs laneTbl e off) = nat5 ((ent e).drop off) := by
  have h (i : ℕ) (hi : off + i < 20) := ent_getD (e := e) he hi
  simp only [Ed25519.Limbs.nat, baseLimbs, nat5]
  rw [h 0 (by omega), h 1 (by omega), h 2 (by omega), h 3 (by omega), h 4 (by omega)]
  rfl

theorem lt_baseLimbs {e off c : ℕ} (he : e ≤ 128) (hoff : off ≤ 15)
    (h : lt5 ((ent e).drop off) c = true) (i : Fin 5) : (baseLimbs laneTbl e off i).toNat < c := by
  have g (i : ℕ) (hi : off + i < 20) := ent_getD (e := e) he hi
  simp only [lt5, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨h0, h1⟩, h2⟩, h3⟩, h4⟩ := h
  rw [g 0 (by omega)] at h0
  rw [g 1 (by omega)] at h1
  rw [g 2 (by omega)] at h2
  rw [g 3 (by omega)] at h3
  rw [g 4 (by omega)] at h4
  fin_cases i
  exacts [h0, h1, h2, h3, h4]

/-! ## Points -/

/-- `(p + 1) / 2` is `1 / 2`. -/
theorem half_mul_two : (((p + 1) / 2 : ℕ) : ZMod p) * 2 = 1 := by
  rw [← Nat.cast_ofNat (R := ZMod p) (n := 2), ← Nat.cast_mul,
    show (p + 1) / 2 * 2 = p + 1 by unfold Ed25519.p; norm_num, Nat.cast_add, ZMod.natCast_self,
    zero_add, Nat.cast_one]

/-- An entry's `y + x`, `y - x` from its point. -/
theorem entryXY_val (e : List (BitVec 64)) :
    ((nat5 e : ℕ) : ZMod p) = ((entryXY e).2 : ZMod p) + (entryXY e).1 ∧
      ((nat5 (e.drop 5) : ℕ) : ZMod p) = ((entryXY e).2 : ZMod p) - (entryXY e).1 := by
  have hx : ((entryXY e).1 : ZMod p) =
      ((nat5 e : ZMod p) - nat5 (e.drop 5)) * (((p + 1) / 2 : ℕ) : ZMod p) := by
    have hm := Nat.mod_lt (nat5 (e.drop 5)) (show 0 < p by unfold Ed25519.p; norm_num)
    simp only [entryXY, ZMod.natCast_mod]
    rw [Nat.cast_mul, Nat.cast_sub (by omega), Nat.cast_add, ZMod.natCast_self, ZMod.natCast_mod]
    ring
  have hy : ((entryXY e).2 : ZMod p) =
      ((nat5 e : ZMod p) + nat5 (e.drop 5)) * (((p + 1) / 2 : ℕ) : ZMod p) := by
    simp only [entryXY, ZMod.natCast_mod]
    rw [Nat.cast_mul, Nat.cast_add]
  have h2 := half_mul_two
  constructor
  · rw [hx, hy]; linear_combination (-(nat5 e : ZMod p)) * h2
  · rw [hx, hy]; linear_combination (-(nat5 (e.drop 5) : ZMod p)) * h2

/-- Entry `k`'s point is `[k]B`. -/
theorem entryXY_smul {k : ℕ} (hk : k ≤ 128) :
    ((entryXY (ent k)).1 : ZMod p) = (k • basePoint).x ∧
      ((entryXY (ent k)).2 : ZMod p) = (k • basePoint).y := by
  induction k with
  | zero =>
    rw [ents_ok.2.1]
    simp [Ed25519.Point.zero_x, Ed25519.Point.zero_y]
  | succ k ih =>
    obtain ⟨hx, hy⟩ := ih (by omega)
    have ha := add_of_ok (ents_ok.2.2 k (by omega))
    rw [ZMod.natCast_zmod_val, ZMod.natCast_zmod_val, hx, hy] at ha
    rw [succ_nsmul, Ed25519.Point.add_x, Ed25519.Point.add_y,
      show basePoint.x = Ed25519.Bx from rfl, show basePoint.y = Ed25519.By from rfl, ha]
    exact ⟨rfl, rfl⟩

/-- Lane `j` of `baseFe` is the entry's limbs. -/
theorem baseFe_val {e off : ℕ} (he : e ≤ 128) (hoff : off ≤ 15) (j : Fin 8) :
    (baseFe laneTbl e off).val j = ((nat5 ((ent e).drop off) : ℕ) : ZMod p) := by
  rw [Fe.val, baseFe, Fe.ofLanes_lane, Ed25519.Limbs.val_nat, nat_baseLimbs he hoff]

theorem baseFe_le {e off c : ℕ} (he : e ≤ 128) (hoff : off ≤ 15)
    (h : lt5 ((ent e).drop off) (c + 1) = true) : (baseFe laneTbl e off).Le fun _ => c :=
  fun j i => by
    rw [baseFe, Fe.ofLanes_lane]
    have := lt_baseLimbs he hoff h i
    show _ ≤ c
    omega

/-- `fd_ed25519_lane_base_table` holds `[e]B`, `e ≤ 128`, in the affine table form. -/
public theorem laneTbl_ok : BaseOk laneTbl := by
  intro e he
  have hok := ents_ok.1 e he
  simp only [entryOk, Bool.and_eq_true, beq_iff_eq] at hok
  obtain ⟨⟨⟨⟨⟨hK, hNK⟩, l0⟩, l5⟩, l10⟩, l15⟩ := hok
  obtain ⟨hP, hM⟩ := entryXY_val (ent e)
  obtain ⟨hx, hy⟩ := entryXY_smul he
  have carried {off : ℕ} (hoff : off ≤ 15) (h : lt5 ((ent e).drop off) (2 ^ 51) = true) :
      (baseFe laneTbl e off).Carried :=
    (baseFe_le he hoff (c := 2 ^ 51 - 1) h).mono fun i => by unfold carriedB; split <;> norm_num
  refine ⟨fun j => ⟨⟨(e • basePoint).x, (e • basePoint).y, (e • basePoint).x * (e • basePoint).y,
      1, ⟨one_ne_zero, (mul_one _).symm, (mul_one _).symm, by ring⟩, ?_, ?_, ?_, Fe.one_val j⟩, ?_⟩,
    carried (by omega) (by simpa using l0), carried (by omega) l5, carried (by omega) l10,
    baseFe_le he (by omega) (c := 2 ^ 52 - 1) l15⟩
  · rw [baseFe_val he (by omega), List.drop_zero, hP, hx, hy]
  · rw [baseFe_val he (by omega), hM, hx, hy]
  · rw [baseFe_val he (by omega), Ed25519.natCast_eq hK]
    push_cast [dN_eq]
    rw [hx, hy]
    ring
  · rw [baseFe_val he (by omega), baseFe_val he (by omega)]
    have h := Ed25519.natCast_eq (b := 0) hNK
    push_cast at h
    linear_combination h

end MLIR.Firedancer.Lane

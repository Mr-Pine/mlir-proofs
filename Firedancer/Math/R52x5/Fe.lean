module

public import Firedancer.Math.Field
public import Firedancer.R52x5.fd_f25519_add
public import Firedancer.R52x5.fd_f25519_neg
public import Firedancer.R52x5.fd_f25519_sub
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide

/-! The value in `ZMod p` of an r52x5 field element (lanes 0-4, Ref's limbs), its limb ranges, and
the values and ranges of `fd_f25519_fold_unsigned` and of `fd_f25519_add`, `sub`, `neg`. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open Firedancer.Avx512

/-! ## Definitions -/

@[expose] public section

/-- The field element of lanes 0-4. -/
abbrev val (x : Wwl) : ZMod p :=
  Ref.Limbs.val (limbs x)

/-- Lanes 5-7 zero. -/
abbrev Hi0 (x : Wwl) : Prop :=
  x[5] = 0 ∧ x[6] = 0 ∧ x[7] = 0

/-- The C's `B(n)`: lanes 0-4 below `2^n`, lanes 5-7 zero. -/
abbrev Below (n : ℕ) (x : Wwl) : Prop :=
  Hi0 x ∧ ∀ i, (limbs x i).toNat < 2 ^ n

/-- Canonical limbs: each below `2^51`, the number below `p`. -/
abbrev Canon (l : Fin 5 → BitVec 64) : Prop :=
  (∀ i, (l i).toNat < 2 ^ 51) ∧ Ref.Limbs.nat l < p

end

/-! ## Ranges -/

public theorem Below.lt {x : Wwl} (h : Below m x) (hmn : m ≤ n) : ∀ i, (limbs x i).toNat < 2 ^ n :=
  fun i => (h.2 i).trans_le (Nat.pow_le_pow_right (by decide) hmn)

public theorem Below.mono {x : Wwl} (h : Below m x) (hmn : m ≤ n) : Below n x :=
  ⟨h.1, h.lt hmn⟩

public theorem Below.tight {x : Wwl} (h : Below 51 x) : Ref.Limbs.Tight (limbs x) := fun i =>
  (h.2 i).le

public theorem Canon.tight {l : Fin 5 → BitVec 64} (h : Canon l) : Ref.Limbs.Tight l := fun i =>
  (h.1 i).le

public theorem Canon.under2p {l : Fin 5 → BitVec 64} (h : Canon l) : Ref.Limbs.Under2p l :=
  h.tight.under2p

public theorem Canon.nat_lt {l : Fin 5 → BitVec 64} (h : Canon l) : Ref.Limbs.nat l < 2 * p := by
  have := h.2
  omega

/-! ## Values of limbwise sums -/

/-- Limbs summing limbwise in `ℕ` sum in value. -/
public theorem val_of_toNat {r x y : Fin 5 → BitVec 64}
    (h : ∀ i, (r i).toNat = (x i).toNat + (y i).toNat) :
    Ref.Limbs.val r = Ref.Limbs.val x + Ref.Limbs.val y := by
  simp only [Ref.Limbs.val_eq, h]
  push_cast
  ring

/-! ## `fd_f25519_fold_unsigned` -/

theorem fold_get0 (x : Wwl) : (fold x)[0] = (x[0] &&& mask51) + madd52lo 19 (x[4] >>> 51) := by
  simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
    foldScale, wwl]

theorem fold_get1 (x : Wwl) : (fold x)[1] = (x[1] &&& mask51) + madd52lo 1 (x[0] >>> 51) := by
  simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
    foldScale, wwl]

theorem fold_get2 (x : Wwl) : (fold x)[2] = (x[2] &&& mask51) + madd52lo 1 (x[1] >>> 51) := by
  simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
    foldScale, wwl]

theorem fold_get3 (x : Wwl) : (fold x)[3] = (x[3] &&& mask51) + madd52lo 1 (x[2] >>> 51) := by
  simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
    foldScale, wwl]

theorem fold_get4 (x : Wwl) : (fold x)[4] = (x[4] &&& mask51) + madd52lo 1 (x[3] >>> 51) := by
  simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
    foldScale, wwl]

theorem fold_hi0 (x : Wwl) : Hi0 (fold x) := by
  refine ⟨?_, ?_, ?_⟩ <;>
    simp [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift, foldPerm,
      foldScale, wwl, madd52lo]

theorem madd52lo_19 (y : BitVec 64) : madd52lo 19 (y >>> 51) = 19 * (y >>> 51) := by
  unfold madd52lo; bv_decide

theorem madd52lo_1 (y : BitVec 64) : madd52lo 1 (y >>> 51) = y >>> 51 := by
  unfold madd52lo; bv_decide

public theorem toNat_and_mask51 (x : BitVec 64) : (x &&& mask51).toNat = x.toNat % 2 ^ 51 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]
  rfl

/-- A fold lane in `ℕ`: low 51 bits plus `c` times a carry, `c ≤ 19`. -/
theorem fold_lane_toNat (x y c : BitVec 64) (hc : c.toNat ≤ 19)
    (hm : madd52lo c (y >>> 51) = c * (y >>> 51)) :
    ((x &&& mask51) + madd52lo c (y >>> 51)).toNat =
      x.toNat % 2 ^ 51 + c.toNat * (y.toNat / 2 ^ 51) := by
  have hy := y.isLt
  have hd : c.toNat * (y.toNat / 2 ^ 51) ≤ 19 * (2 ^ 13 - 1) := Nat.mul_le_mul hc (by omega)
  have hs : (c * (y >>> 51)).toNat = c.toNat * (y.toNat / 2 ^ 51) := by
    rw [BitVec.toNat_mul, Ref.toNat_shift, Nat.mod_eq_of_lt (by omega)]
  rw [hm, BitVec.toNat_add, toNat_and_mask51, hs, Nat.mod_eq_of_lt (by omega)]

/-- `fold`'s limbs in `ℕ`. -/
public theorem fold_toNat (x : Wwl) :
    (limbs (fold x) 0).toNat = x[0].toNat % 2 ^ 51 + 19 * (x[4].toNat / 2 ^ 51) ∧
      (limbs (fold x) 1).toNat = x[1].toNat % 2 ^ 51 + x[0].toNat / 2 ^ 51 ∧
      (limbs (fold x) 2).toNat = x[2].toNat % 2 ^ 51 + x[1].toNat / 2 ^ 51 ∧
      (limbs (fold x) 3).toNat = x[3].toNat % 2 ^ 51 + x[2].toNat / 2 ^ 51 ∧
      (limbs (fold x) 4).toNat = x[4].toNat % 2 ^ 51 + x[3].toNat / 2 ^ 51 := by
  have l19 y := fold_lane_toNat x[0] y 19 (by decide) (madd52lo_19 y)
  have l1 x y := fold_lane_toNat x y 1 (by decide) ((madd52lo_1 y).trans (BitVec.one_mul _).symm)
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact (congrArg BitVec.toNat (fold_get0 x)).trans (l19 _)
  · exact (congrArg BitVec.toNat (fold_get1 x)).trans ((l1 _ _).trans (by simp))
  · exact (congrArg BitVec.toNat (fold_get2 x)).trans ((l1 _ _).trans (by simp))
  · exact (congrArg BitVec.toNat (fold_get3 x)).trans ((l1 _ _).trans (by simp))
  · exact (congrArg BitVec.toNat (fold_get4 x)).trans ((l1 _ _).trans (by simp))

/-- `fold` keeps the value of lanes 0-4 and gives `B(52)`. -/
public theorem fold.spec_val (x : Wwl) : val (fold x) = val x ∧ Below 52 (fold x) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := fold_toNat x
  refine ⟨?_, fold_hi0 x, fun i => ?_⟩
  · have e (y : ℕ) : ((y % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (y / 2 ^ 51 : ℕ) = y := by
      exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div y (2 ^ 51))
    show Ref.Limbs.val _ = Ref.Limbs.val _
    rw [Ref.Limbs.val_eq, Ref.Limbs.val_eq, h0, h1, h2, h3, h4]
    change
      _ =
        ((x[0].toNat : ℕ) : ZMod p) + (x[1].toNat : ℕ) * 2 ^ 51 + (x[2].toNat : ℕ) * 2 ^ 102 +
          (x[3].toNat : ℕ) * 2 ^ 153 +
          (x[4].toNat : ℕ) * 2 ^ 204
    push_cast
    linear_combination
      e x[0].toNat + 2 ^ 51 * e x[1].toNat + 2 ^ 102 * e x[2].toNat + 2 ^ 153 * e x[3].toNat +
          2 ^ 204 * e x[4].toNat -
        (x[4].toNat / 2 ^ 51 : ℕ) * Ref.two_pow_255
  · have := x[0].isLt; have := x[1].isLt; have := x[2].isLt; have := x[3].isLt; have := x[4].isLt
    fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, h0, h1, h2, h3, h4] <;>
      omega

/-- `fold`'s output number is below `2p`. -/
public theorem fold.nat_lt (x : Wwl) : Ref.Limbs.nat (limbs (fold x)) < 2 * p := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := fold_toNat x
  have := x[0].isLt; have := x[1].isLt; have := x[2].isLt; have := x[3].isLt; have := x[4].isLt
  unfold Ref.Limbs.nat
  rw [h0, h1, h2, h3, h4]
  change _ < 2 * (2 ^ 255 - 19)
  omega

/-! ## `fd_f25519_add`, `sub`, `neg` -/

public theorem limbs_wwl_add (x y : Wwl) (i : Fin 5) :
    limbs (wwl_add x y) i = limbs x i + limbs y i := by simp [limbs, wwl_add]

public theorem limbs_wwl_sub (x y : Wwl) (i : Fin 5) :
    limbs (wwl_sub x y) i = limbs x i - limbs y i := by simp [limbs, wwl_sub]

theorem bias16p_toNat (i : Fin 5) :
    (limbs bias16p i).toNat = if i = 0 then 2 ^ 55 - 304 else 2 ^ 55 - 16 := by fin_cases i <;> rfl

public theorem val_bias16p : val bias16p = 0 := by
  rw [val, Ref.Limbs.val_nat,
    show Ref.Limbs.nat (limbs bias16p) = 16 * p by
      unfold Ref.Limbs.nat; rfl]
  rw [Nat.cast_mul, ZMod.natCast_self, mul_zero]

/-- `fd_f25519_add`: lanes below `2^63`. -/
public theorem fd_f25519_add.spec_val {a b : Wwl} (ha : ∀ i, (limbs a i).toNat < 2 ^ 63)
    (hb : ∀ i, (limbs b i).toNat < 2 ^ 63) :
    val (fd_f25519_add.spec a b) = val a + val b ∧ Below 52 (fd_f25519_add.spec a b) := by
  refine ⟨(fold.spec_val _).1.trans ?_, (fold.spec_val _).2⟩
  rw [val, val_of_toNat (x := limbs b) (y := limbs a), add_comm]
  intro i
  have := ha i; have := hb i
  rw [limbs_wwl_add, BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]

/-- `fd_f25519_sub`: `a` below `2^63`, `b` below `2^54` (under the `16 p` bias). -/
public theorem fd_f25519_sub.spec_val {a b : Wwl} (ha : ∀ i, (limbs a i).toNat < 2 ^ 63)
    (hb : ∀ i, (limbs b i).toNat < 2 ^ 54) :
    val (fd_f25519_sub.spec a b) = val a - val b ∧ Below 52 (fd_f25519_sub.spec a b) := by
  refine ⟨(fold.spec_val _).1.trans ?_, (fold.spec_val _).2⟩
  have hs : val (wwl_add a bias16p) = val (wwl_sub (wwl_add a bias16p) b) + val b :=
    val_of_toNat fun i => by
      have := ha i; have := hb i; have := bias16p_toNat i
      rw [limbs_wwl_sub, limbs_wwl_add, BitVec.toNat_sub, BitVec.toNat_add]
      split at this <;> omega
  have ha' : val (wwl_add a bias16p) = val a + val bias16p :=
    val_of_toNat fun i => by
      have := ha i; have := bias16p_toNat i
      rw [limbs_wwl_add, BitVec.toNat_add, Nat.mod_eq_of_lt (by split at this <;> omega)]
  rw [eq_sub_iff_add_eq, ← hs, ha', val_bias16p, add_zero]

/-- `fd_f25519_neg`: `a` below `2^54` (under the `16 p` bias). -/
public theorem fd_f25519_neg.spec_val {a : Wwl} (ha : ∀ i, (limbs a i).toNat < 2 ^ 54) :
    val (fd_f25519_neg.spec a) = -val a ∧ Below 52 (fd_f25519_neg.spec a) := by
  refine ⟨(fold.spec_val _).1.trans ?_, (fold.spec_val _).2⟩
  have h : val bias16p = val (wwl_sub bias16p a) + val a :=
    val_of_toNat fun i => by
      have := ha i; have := bias16p_toNat i
      rw [limbs_wwl_sub, BitVec.toNat_sub]
      split at this <;> omega
  rw [eq_neg_iff_add_eq_zero, ← h, val_bias16p]

end MLIR.Firedancer.R52x5

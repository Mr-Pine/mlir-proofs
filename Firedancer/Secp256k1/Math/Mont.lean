module

public import Firedancer.Secp256k1.BackendRef
public import Firedancer.Secp256k1.Fiat
public import Firedancer.Secp256k1.Math.Limbs
public import Mathlib.Algebra.Field.ZMod
import Mathlib.FieldTheory.Finite.Basic

/-! Residues of 4-limb values modulo a prime `m < 2^256`: plain and Montgomery (`R = 2^256`)
value maps, the canonical-output lemmas the library models need, and the ref backend's
windowed power. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-- The residue a Montgomery-form 4-limb value stands for modulo `m`: `a · 2⁻²⁵⁶`. -/
def montVal (m : ℕ) (a : Vector (BitVec 64) 4) : ZMod m :=
  (limbsEval a : ZMod m) * ((2 : ZMod m) ^ 256)⁻¹

end

variable {m : ℕ}

/-! ## Outputs `limbsOfNat 4 (x mod m)` -/

public theorem limbsEval_limbsOfNat_mod (hm : m ≤ 2 ^ 256) (hm0 : 0 < m) (x : ℕ) :
    limbsEval (limbsOfNat 4 (x % m)) = x % m :=
  limbsEval_limbsOfNat_of_lt (lt_of_lt_of_le (Nat.mod_lt _ hm0) hm)

public theorem emod_toNat_lt (hm0 : 0 < m) (z : ℤ) : (z % (m : ℤ)).toNat < m := by
  have := Int.emod_lt_of_pos z (by omega : (0 : ℤ) < m)
  omega

public theorem natCast_emod_toNat (hm0 : 0 < m) (z : ℤ) :
    (((z % (m : ℤ)).toNat : ℕ) : ZMod m) = (z : ZMod m) := by
  have h := Int.emod_nonneg z (by omega : (m : ℤ) ≠ 0)
  rw [← Int.cast_natCast, Int.toNat_of_nonneg h, ZMod.intCast_mod]

public theorem limbsEval_limbsOfNat_emod (hm : m ≤ 2 ^ 256) (hm0 : 0 < m) (z : ℤ) :
    limbsEval (limbsOfNat 4 (z % (m : ℤ)).toNat) = (z % (m : ℤ)).toNat :=
  limbsEval_limbsOfNat_of_lt (lt_of_lt_of_le (emod_toNat_lt hm0 z) hm)

/-! ## Inverses modulo a prime -/

section Prime

variable [hp : Fact m.Prime]

/-- `invMod a m` is `a⁻¹` in `ZMod m` when `m ∤ a`. -/
public theorem natCast_invMod_eq_inv {a : ℕ} (h : (a : ZMod m) ≠ 0) :
    ((invMod a m : ℕ) : ZMod m) = (a : ZMod m)⁻¹ := by
  have hc : Nat.Coprime a m :=
    Nat.coprime_comm.1
      ((Nat.Prime.coprime_iff_not_dvd hp.out).2 fun hd => h ((ZMod.natCast_eq_zero_iff a m).2 hd))
  exact (eq_inv_of_mul_eq_one_right (natCast_mul_invMod hp.out.pos hc)).symm ▸ rfl

public theorem natCast_invMod_two_pow (h2 : (2 : ZMod m) ≠ 0) :
    ((invMod (2 ^ 256) m : ℕ) : ZMod m) = ((2 : ZMod m) ^ 256)⁻¹ := by
  rw [natCast_invMod_eq_inv
      (by
        rw [Nat.cast_pow, Nat.cast_ofNat]; exact pow_ne_zero _ h2),
    Nat.cast_pow, Nat.cast_ofNat]

public theorem natCast_fiat_Rinv (h2 : (2 : ZMod m) ≠ 0) :
    ((fiat_Rinv m : ℕ) : ZMod m) = ((2 : ZMod m) ^ 256)⁻¹ := by
  unfold fiat_Rinv
  rw [Nat.cast_pow,
    natCast_invMod_eq_inv
      (by
        rw [Nat.cast_pow, Nat.cast_ofNat]; exact pow_ne_zero _ h2),
    Nat.cast_pow, Nat.cast_ofNat, ← inv_pow, ← pow_mul, inv_pow]

/-- Distinct canonical values have distinct residues. -/
public theorem montVal_inj (h2 : (2 : ZMod m) ≠ 0) {a b : Vector (BitVec 64) 4}
    (ha : limbsEval a < m) (hb : limbsEval b < m) : montVal m a = montVal m b ↔ a = b := by
  refine ⟨fun h => limbsEval_injective ?_, fun h => h ▸ rfl⟩
  have h' := mul_right_cancel₀ (inv_ne_zero (pow_ne_zero 256 h2)) h
  have := congrArg ZMod.val h'
  rwa [ZMod.val_cast_of_lt ha, ZMod.val_cast_of_lt hb] at this

/-- Fermat's inverse, `0` at `0`. -/
public theorem pow_sub_two_eq_inv (hm : 2 < m) (x : ZMod m) : x ^ (m - 2) = x⁻¹ := by
  rcases eq_or_ne x 0 with rfl | hx
  · rw [inv_zero, zero_pow (by omega)]
  · apply eq_inv_of_mul_eq_one_left
    rw [← pow_succ, show m - 2 + 1 = m - 1 by omega, ZMod.pow_card_sub_one_eq_one hx]

end Prime

/-! ## The ref backend's power -/

/-- Induction over `Nat.fold`. -/
public theorem fold_induct {α : Type} (n : ℕ) (f : (i : ℕ) → i < n → α → α) (init : α)
    (P : ℕ → α → Prop) (h0 : P 0 init) (hs : ∀ i (hi : i < n) x, P i x → P (i + 1) (f i hi x)) :
    P n (Nat.fold n f init) := by
  induction n generalizing init with
  | zero =>
    rw [Nat.fold_zero]; exact h0
  | succ n ih =>
    rw [Nat.fold_succ]
    exact hs n _ _ (ih (fun i h => f i (by omega)) init h0 fun i hi x hx => hs i _ x hx)

/-- `fd_pcurve_ref_pow` computes `a ^ e` for any `mul`/`sqr`/`set_one` that act as a monoid's
product, square and one on values satisfying `good`. -/
public theorem fd_pcurve_ref_pow.spec_val {M : Type} [Monoid M] (good : Vector (BitVec 64) 4 → Prop)
    (val : Vector (BitVec 64) 4 → M)
    {mul : Vector (BitVec 64) 4 → Vector (BitVec 64) 4 → Vector (BitVec 64) 4}
    {sqr : Vector (BitVec 64) 4 → Vector (BitVec 64) 4} {one : Vector (BitVec 64) 4}
    (hmul : ∀ x y, good x → good y → good (mul x y) ∧ val (mul x y) = val x * val y)
    (hsqr : ∀ x, good x → good (sqr x) ∧ val (sqr x) = val x ^ 2) (hone : good one ∧ val one = 1)
    {a : Vector (BitVec 64) 4} (ha : good a) (e : Vector (BitVec 64) 4) :
    good (Ref.fd_pcurve_ref_pow.spec mul sqr one a e) ∧
      val (Ref.fd_pcurve_ref_pow.spec mul sqr one a e) = val a ^ limbsEval e := by
  unfold Ref.fd_pcurve_ref_pow.spec
  extract_lets  tbl0 tbl1 tbl2 tbl3 tbl4 tbl5 tbl6 tbl7 tbl8 tbl9 tbl10 tbl11 tbl12 tbl13 tbl14
    tbl15 tbl acc
  have step :
    ∀ x k, good x ∧ val x = val a ^ k → good (mul x a) ∧ val (mul x a) = val a ^ (k + 1) :=
    fun x k ⟨hg, hv⟩ => by
    obtain ⟨g', v'⟩ := hmul x a hg ha
    exact ⟨g', by rw [v', hv, pow_succ]⟩
  have h0 : good tbl0 ∧ val tbl0 = val a ^ 0 := by
    rw [pow_zero]; exact hone
  have h1 : good tbl1 ∧ val tbl1 = val a ^ 1 := ⟨ha, (pow_one _).symm⟩
  have h2 := step _ _ h1
  have h3 := step _ _ h2
  have h4 := step _ _ h3
  have h5 := step _ _ h4
  have h6 := step _ _ h5
  have h7 := step _ _ h6
  have h8 := step _ _ h7
  have h9 := step _ _ h8
  have h10 := step _ _ h9
  have h11 := step _ _ h10
  have h12 := step _ _ h11
  have h13 := step _ _ h12
  have h14 := step _ _ h13
  have h15 := step _ _ h14
  have htbl : ∀ (d : ℕ) (hd : d < 16), good tbl[d] ∧ val tbl[d] = val a ^ d := by
    intro d hd
    interval_cases d
    exacts [h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, h15]
  have hE := limbsEval_lt e
  rw [show limbsEval e = limbsEval e / 2 ^ (256 - 4 * 64) by simp]
  refine
    fold_induct (P := fun k x => good x ∧ val x = val a ^ (limbsEval e / 2 ^ (256 - 4 * k))) 64 _
      tbl0
      (by
        rw [Nat.div_eq_of_lt hE, pow_zero]; exact hone)
      (fun i hi x ⟨hg, hv⟩ => by
        dsimp only
        obtain ⟨g1, v1⟩ := hsqr x hg
        obtain ⟨g2, v2⟩ := hsqr _ g1
        obtain ⟨g3, v3⟩ := hsqr _ g2
        obtain ⟨g4, v4⟩ := hsqr _ g3
        have hw := window_eq e (i := 252 - 4 * i) (by omega) (by omega)
        obtain ⟨gt, vt⟩ :=
          htbl ((e[(252 - 4 * i) / 64]'(by omega) >>> ((252 - 4 * i) % 64)) &&& 15#64).toNat
            (by
              rw [hw]; exact Nat.mod_lt _ (by norm_num))
        obtain ⟨g5, v5⟩ := hmul _ _ g4 gt
        refine ⟨g5, ?_⟩
        rw [v5, v4, v3, v2, v1, vt, hw, hv, ← pow_mul, ← pow_mul, ← pow_mul, ← pow_mul, ← pow_add]
        congr 1
        have e1 : 256 - 4 * i = (252 - 4 * i) + 4 := by omega
        have e2 : 256 - 4 * (i + 1) = 252 - 4 * i := by omega
        rw [e1, e2, pow_add, ← Nat.div_div_eq_div_mul]
        have := Nat.div_add_mod (limbsEval e / 2 ^ (252 - 4 * i)) 16
        norm_num at this ⊢
        omega)

end Firedancer.Secp256k1

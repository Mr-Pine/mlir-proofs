module

public import Firedancer.Math.R52x5.Fe
public import Firedancer.R52x5.fd_f25519_canonical_limbs
import Mathlib.Tactic.LinearCombination

/-! `fd_r52x5_reduce` below `2p`: `q` is `1` exactly when the number plus `19` reaches `2^255`, so
it subtracts `p` at most once and leaves canonical limbs; with `fold` this is
`fd_f25519_canonical_limbs`. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open Firedancer.Avx512 (Wwl)

/-- The `q` chain is `(nat + 19) / 2^255`. -/
theorem chain_q {a0 a1 a2 a3 a4 Q0 Q1 Q2 Q3 Q4 : ℕ} (hQ0 : Q0 = (a0 + 19) / 2 ^ 51)
    (hQ1 : Q1 = (a1 + Q0) / 2 ^ 51) (hQ2 : Q2 = (a2 + Q1) / 2 ^ 51) (hQ3 : Q3 = (a3 + Q2) / 2 ^ 51)
    (hQ4 : Q4 = (a4 + Q3) / 2 ^ 51) :
    Q4 = (a0 + a1 * 2 ^ 51 + a2 * 2 ^ 102 + a3 * 2 ^ 153 + a4 * 2 ^ 204 + 19) / 2 ^ 255 := by omega

/-- The carry chain's digits and top carry are the number plus `19 q`. -/
theorem chain_r {a0 a1 a2 a3 a4 q X0 X1 X2 X3 X4 : ℕ} (hX0 : X0 = a0 + 19 * q)
    (hX1 : X1 = a1 + X0 / 2 ^ 51) (hX2 : X2 = a2 + X1 / 2 ^ 51) (hX3 : X3 = a3 + X2 / 2 ^ 51)
    (hX4 : X4 = a4 + X3 / 2 ^ 51) :
    X0 % 2 ^ 51 + X1 % 2 ^ 51 * 2 ^ 51 + X2 % 2 ^ 51 * 2 ^ 102 + X3 % 2 ^ 51 * 2 ^ 153 +
        X4 % 2 ^ 51 * 2 ^ 204 +
        X4 / 2 ^ 51 * 2 ^ 255 =
      a0 + a1 * 2 ^ 51 + a2 * 2 ^ 102 + a3 * 2 ^ 153 + a4 * 2 ^ 204 + 19 * q := by
  omega

theorem toNat_add_lt {x y : BitVec 64} (h : x.toNat + y.toNat < 2 ^ 64) :
    (x + y).toNat = x.toNat + y.toNat := by rw [BitVec.toNat_add, Nat.mod_eq_of_lt h]

/-- `fd_r52x5_reduce` on limbs below `2^52` and a number below `2p`: canonical, same value. -/
public theorem fd_r52x5_reduce.spec_canon {l : Fin 5 → BitVec 64} (hl : ∀ i, (l i).toNat < 2 ^ 52)
    (hn : Ref.Limbs.nat l < 2 * p) :
    Canon (fd_r52x5_reduce.spec l) ∧ Ref.Limbs.val (fd_r52x5_reduce.spec l) = Ref.Limbs.val l := by
  simp only [fd_r52x5_reduce.spec]
  have h0 := hl 0; have h1 := hl 1; have h2 := hl 2; have h3 := hl 3; have h4 := hl 4
  have hc19 : (19#64).toNat = 19 := rfl
  have eQ0 : ((l 0 + 19#64) >>> 51).toNat = ((l 0).toNat + 19) / 2 ^ 51 := by
    rw [Ref.toNat_shift, toNat_add_lt (by omega), hc19]
  generalize (l 0 + 19#64) >>> 51 = q0 at eQ0 ⊢
  have eQ1 : ((l 1 + q0) >>> 51).toNat = ((l 1).toNat + q0.toNat) / 2 ^ 51 := by
    rw [Ref.toNat_shift, toNat_add_lt (by omega)]
  generalize (l 1 + q0) >>> 51 = q1 at eQ1 ⊢
  have eQ2 : ((l 2 + q1) >>> 51).toNat = ((l 2).toNat + q1.toNat) / 2 ^ 51 := by
    rw [Ref.toNat_shift, toNat_add_lt (by omega)]
  generalize (l 2 + q1) >>> 51 = q2 at eQ2 ⊢
  have eQ3 : ((l 3 + q2) >>> 51).toNat = ((l 3).toNat + q2.toNat) / 2 ^ 51 := by
    rw [Ref.toNat_shift, toNat_add_lt (by omega)]
  generalize (l 3 + q2) >>> 51 = q3 at eQ3 ⊢
  have eQ4 : ((l 4 + q3) >>> 51).toNat = ((l 4).toNat + q3.toNat) / 2 ^ 51 := by
    rw [Ref.toNat_shift, toNat_add_lt (by omega)]
  generalize (l 4 + q3) >>> 51 = q at eQ4 ⊢
  have hq := chain_q eQ0 eQ1 eQ2 eQ3 eQ4
  have hN :
    Ref.Limbs.nat l =
      (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
        (l 4).toNat * 2 ^ 204 :=
    rfl
  rw [hN] at hn
  change _ < 2 * (2 ^ 255 - 19) at hn
  have hq1 : q.toNat ≤ 1 := by omega
  have eX0 : (l 0 + 19#64 * q).toNat = (l 0).toNat + 19 * q.toNat := by
    have e19 : (19#64 * q).toNat = 19 * q.toNat := by
      rw [BitVec.toNat_mul, hc19, Nat.mod_eq_of_lt (by omega)]
    rw [toNat_add_lt (by omega), e19]
  generalize l 0 + 19#64 * q = x0 at eX0 ⊢
  have eX1 : (l 1 + (x0 >>> 51)).toNat = (l 1).toNat + x0.toNat / 2 ^ 51 := by
    rw [toNat_add_lt
        (by
          rw [Ref.toNat_shift]; omega),
      Ref.toNat_shift]
  generalize l 1 + (x0 >>> 51) = x1 at eX1 ⊢
  have eX2 : (l 2 + (x1 >>> 51)).toNat = (l 2).toNat + x1.toNat / 2 ^ 51 := by
    rw [toNat_add_lt
        (by
          rw [Ref.toNat_shift]; omega),
      Ref.toNat_shift]
  generalize l 2 + (x1 >>> 51) = x2 at eX2 ⊢
  have eX3 : (l 3 + (x2 >>> 51)).toNat = (l 3).toNat + x2.toNat / 2 ^ 51 := by
    rw [toNat_add_lt
        (by
          rw [Ref.toNat_shift]; omega),
      Ref.toNat_shift]
  generalize l 3 + (x2 >>> 51) = x3 at eX3 ⊢
  have eX4 : (l 4 + (x3 >>> 51)).toNat = (l 4).toNat + x3.toNat / 2 ^ 51 := by
    rw [toNat_add_lt
        (by
          rw [Ref.toNat_shift]; omega),
      Ref.toNat_shift]
  generalize l 4 + (x3 >>> 51) = x4 at eX4 ⊢
  have hr := chain_r eX0 eX1 eX2 eX3 eX4
  have hT : x4.toNat / 2 ^ 51 = q.toNat := by omega
  rw [Ref.Limbs.val_nat, Ref.Limbs.val_nat, hN]
  simp only [Ref.Limbs.nat, Ref.toNat_and_mask]
  refine ⟨⟨fun i => ?_, ?_⟩, ?_⟩
  · fin_cases i <;> simp only [Ref.toNat_and_mask] <;> omega
  · simp only [Ref.Limbs.nat, Ref.toNat_and_mask]
    change _ < 2 ^ 255 - 19
    omega
  · rw [hT] at hr
    have H := congrArg (Nat.cast (R := ZMod p)) hr
    push_cast at H ⊢
    linear_combination H - (q.toNat : ZMod p) * Ref.two_pow_255

/-- `fd_f25519_canonical_limbs`: canonical limbs of `a`'s value. -/
public theorem fd_f25519_canonical_limbs.spec_val (a : Wwl) :
    Canon (fd_f25519_canonical_limbs.spec a) ∧
      Ref.Limbs.val (fd_f25519_canonical_limbs.spec a) = val a :=
  let h := fd_r52x5_reduce.spec_canon (fold.spec_val a).2.2 (fold.nat_lt a)
  ⟨h.1, h.2.trans (fold.spec_val a).1⟩

end MLIR.Firedancer.R52x5

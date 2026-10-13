module

public import Agave.Math.Field
public import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64
public import Agave.Avx2.FieldElement2625x4_Mul_mul_impl_mul
public import Agave.Avx2.FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The AVX2 `FieldElement2625x4` arithmetic in `ZMod p`, element by element (`Fe2625x4.val`):
`reduce64` keeps the value of its ten `u64x4` limbs (below `2^64 - 2^40`) and leaves limbs below
`2^26` and `2^25 + 2^19`; `mul` multiplies limbs below `5 · 2^26` (even) and `5 · 2^25 + 2^21`
(odd) on the left, `3 · 2^26` and `3 · 2^25 + 2^21` on the right; `square_and_negate_D` squares
(negating `D`) limbs below `2^27 + 2^13` and `2^26 + 2^20`. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Fe2625x4

/-- Even limbs below `ev`, odd limbs below `od`, in every element. -/
def Bounded (v : Fe2625x4) (ev od : ℕ) : Prop :=
  ∀ i e, (v i)[evenLane e].toNat < ev ∧ (v i)[oddLane e].toNat < od

end Fe2625x4

end

namespace Avx2

open Fe2625x4

/-! ## Lanes -/

theorem repack_even (x y : Vector (BitVec 64) 4) (mx my : BitVec 32) (e : Fin 4) :
    (repack x y mx my)[evenLane e] = x[(e : ℕ)].extractLsb' 0 32 &&& mx := by fin_cases e <;> rfl

theorem repack_odd (x y : Vector (BitVec 64) 4) (mx my : BitVec 32) (e : Fin 4) :
    (repack x y mx my)[oddLane e] = y[(e : ℕ)].extractLsb' 0 32 &&& my := by fin_cases e <;> rfl

theorem repack'_even (x y : Vector (BitVec 64) 4) (mx : BitVec 32) (e : Fin 4) :
    (repack' x y mx)[evenLane e] = x[(e : ℕ)].extractLsb' 0 32 &&& mx := by fin_cases e <;> rfl

theorem repack'_odd (x y : Vector (BitVec 64) 4) (mx : BitVec 32) (e : Fin 4) :
    (repack' x y mx)[oddLane e] = y[(e : ℕ)].extractLsb' 0 32 := by fin_cases e <;> rfl

/-! ## Limb bits -/

theorem toNat_and26 (x : BitVec 64) : (x &&& 67108863#64).toNat = x.toNat % 2 ^ 26 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]; rfl

theorem toNat_and25 (x : BitVec 64) : (x &&& 33554431#64).toNat = x.toNat % 2 ^ 25 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]; rfl

theorem toNat_shr64 (x : BitVec 64) (k : ℕ) : (x >>> k).toNat = x.toNat / 2 ^ k := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

theorem toNat_lo32 (x : BitVec 64) : (x.extractLsb' 0 32).toNat = x.toNat % 2 ^ 32 := by
  simp [BitVec.extractLsb'_toNat]

theorem toNat_lo32_and26 (x : BitVec 64) :
    (x.extractLsb' 0 32 &&& 67108863#32).toNat = x.toNat % 2 ^ 26 := by
  rw [BitVec.toNat_and, toNat_lo32, ← Nat.and_two_pow_sub_one_eq_mod, Nat.and_assoc,
    show (2 ^ 32 - 1 &&& (67108863#32).toNat) = 2 ^ 26 - 1 by decide,
    Nat.and_two_pow_sub_one_eq_mod]

theorem toNat_lo32_and25 (x : BitVec 64) :
    (x.extractLsb' 0 32 &&& 33554431#32).toNat = x.toNat % 2 ^ 25 := by
  rw [BitVec.toNat_and, toNat_lo32, ← Nat.and_two_pow_sub_one_eq_mod, Nat.and_assoc,
    show (2 ^ 32 - 1 &&& (33554431#32).toNat) = 2 ^ 25 - 1 by decide,
    Nat.and_two_pow_sub_one_eq_mod]

/-! ## `reduce64` -/

/-- `x`'s low `k` bits and its carry, in `ZMod p`. -/
theorem mod_add_div (x k : ℕ) : ((x % 2 ^ k : ℕ) : ZMod p) + 2 ^ k * (x / 2 ^ k : ℕ) = x := by
  exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ k))

/-- `reduce64`'s carry chain keeps the value, in `ℕ` cast to `ZMod p`: limbs `n0 … n9` carried
as the code does (two chains, the top carry split at bit 26 and times 19 into limbs 0 and 1). -/
theorem reduce64_val {n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 t1 t2 t3 t4 t5 t6 t7 t8 t9 s5 u0 u1 : ℕ}
    (h1 : t1 = n1 + n0 / 2 ^ 26) (h5 : t5 = n5 + n4 / 2 ^ 26) (h2 : t2 = n2 + t1 / 2 ^ 25)
    (h6 : t6 = n6 + t5 / 2 ^ 25) (h3 : t3 = n3 + t2 / 2 ^ 26) (h7 : t7 = n7 + t6 / 2 ^ 26)
    (h4 : t4 = n4 % 2 ^ 26 + t3 / 2 ^ 25) (h8 : t8 = n8 + t7 / 2 ^ 25)
    (hs5 : s5 = t5 % 2 ^ 25 + t4 / 2 ^ 26) (h9 : t9 = n9 + t8 / 2 ^ 26)
    (hu0 : u0 = t9 / 2 ^ 25 % 2 ^ 26 * 19 + n0 % 2 ^ 26)
    (hu1 : u1 = t9 / 2 ^ 51 * 19 + t1 % 2 ^ 25 + u0 / 2 ^ 26) :
    ((u0 % 2 ^ 26 : ℕ) : ZMod p) + (u1 : ℕ) * 2 ^ 26 + (t2 % 2 ^ 26 : ℕ) * 2 ^ 51 +
        (t3 % 2 ^ 25 : ℕ) * 2 ^ 77 +
        (t4 % 2 ^ 26 : ℕ) * 2 ^ 102 +
        (s5 : ℕ) * 2 ^ 128 +
        (t6 % 2 ^ 26 : ℕ) * 2 ^ 153 +
        (t7 % 2 ^ 25 : ℕ) * 2 ^ 179 +
        (t8 % 2 ^ 26 : ℕ) * 2 ^ 204 +
        (t9 % 2 ^ 25 : ℕ) * 2 ^ 230 =
      n0 + n1 * 2 ^ 26 + n2 * 2 ^ 51 + n3 * 2 ^ 77 + n4 * 2 ^ 102 + n5 * 2 ^ 128 + n6 * 2 ^ 153 +
        n7 * 2 ^ 179 +
        n8 * 2 ^ 204 +
        n9 * 2 ^ 230 := by
  have D : t9 / 2 ^ 25 % 2 ^ 26 + 2 ^ 26 * (t9 / 2 ^ 51) = t9 / 2 ^ 25 := by
    rw [show 2 ^ 51 = 2 ^ 25 * 2 ^ 26 by norm_num, ← Nat.div_div_eq_div_mul]
    exact Nat.mod_add_div _ _
  have D' := congrArg (Nat.cast (R := ZMod p)) D
  have T1 := congrArg (Nat.cast (R := ZMod p)) h1
  have T2 := congrArg (Nat.cast (R := ZMod p)) h2
  have T3 := congrArg (Nat.cast (R := ZMod p)) h3
  have T4 := congrArg (Nat.cast (R := ZMod p)) h4
  have T5 := congrArg (Nat.cast (R := ZMod p)) h5
  have T6 := congrArg (Nat.cast (R := ZMod p)) h6
  have T7 := congrArg (Nat.cast (R := ZMod p)) h7
  have T8 := congrArg (Nat.cast (R := ZMod p)) h8
  have T9 := congrArg (Nat.cast (R := ZMod p)) h9
  have S5 := congrArg (Nat.cast (R := ZMod p)) hs5
  have U0 := congrArg (Nat.cast (R := ZMod p)) hu0
  have U1 := congrArg (Nat.cast (R := ZMod p)) hu1
  push_cast at D' T1 T2 T3 T4 T5 T6 T7 T8 T9 S5 U0 U1 ⊢
  linear_combination
    mod_add_div u0 26 + 2 ^ 26 * U1 + U0 + 19 * D' + 2 ^ 230 * mod_add_div t9 25 -
        ((t9 / 2 ^ 25 : ℕ) : ZMod p) * two_pow_255 +
      2 ^ 230 * T9 +
      2 ^ 204 * mod_add_div t8 26 +
      2 ^ 204 * T8 +
      2 ^ 179 * mod_add_div t7 25 +
      2 ^ 179 * T7 +
      2 ^ 153 * mod_add_div t6 26 +
      2 ^ 153 * T6 +
      2 ^ 128 * S5 +
      2 ^ 128 * mod_add_div t5 25 +
      2 ^ 128 * T5 +
      2 ^ 102 * mod_add_div t4 26 +
      2 ^ 102 * T4 +
      2 ^ 102 * mod_add_div n4 26 +
      2 ^ 77 * mod_add_div t3 25 +
      2 ^ 77 * T3 +
      2 ^ 51 * mod_add_div t2 26 +
      2 ^ 51 * T2 +
      2 ^ 26 * mod_add_div t1 25 +
      2 ^ 26 * T1 +
      mod_add_div n0 26

theorem spec_lane_explicit (z : Fin 10 → Vector (BitVec 64) 4) (e : Fin 4)
    (hz : ∀ k, (z k)[(e : ℕ)].toNat < 2 ^ 64 - 2 ^ 40) :
    val (FieldElement2625x4_reduce64_impl_reduce64.spec z) e =
        ((z 0)[(e : ℕ)].toNat : ZMod p) + ((z 1)[(e : ℕ)].toNat : ZMod p) * 2 ^ 26 +
          ((z 2)[(e : ℕ)].toNat : ZMod p) * 2 ^ 51 +
          ((z 3)[(e : ℕ)].toNat : ZMod p) * 2 ^ 77 +
          ((z 4)[(e : ℕ)].toNat : ZMod p) * 2 ^ 102 +
          ((z 5)[(e : ℕ)].toNat : ZMod p) * 2 ^ 128 +
          ((z 6)[(e : ℕ)].toNat : ZMod p) * 2 ^ 153 +
          ((z 7)[(e : ℕ)].toNat : ZMod p) * 2 ^ 179 +
          ((z 8)[(e : ℕ)].toNat : ZMod p) * 2 ^ 204 +
          ((z 9)[(e : ℕ)].toNat : ZMod p) * 2 ^ 230 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 0)[evenLane e].toNat < 2 ^ 26 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 0)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 1)[evenLane e].toNat < 2 ^ 26 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 1)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 2)[evenLane e].toNat < 2 ^ 26 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 2)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 3)[evenLane e].toNat < 2 ^ 26 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 3)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 4)[evenLane e].toNat < 2 ^ 26 ∧
      (FieldElement2625x4_reduce64_impl_reduce64.spec z 4)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 := by
  have h0 := hz 0
  have h1 := hz 1
  have h2 := hz 2
  have h3 := hz 3
  have h4 := hz 4
  have h5 := hz 5
  have h6 := hz 6
  have h7 := hz 7
  have h8 := hz 8
  have h9 := hz 9
  clear hz
  rw [val, nat_eq]
  simp only [FieldElement2625x4_reduce64_impl_reduce64.spec, repack_even, repack_odd, repack'_even,
    repack'_odd, vadd_getElem, vand_getElem, vshr_getElem, vmul_getElem, Vector.getElem_replicate]
  generalize (z 0)[(e : ℕ)] = a0 at *
  generalize (z 1)[(e : ℕ)] = a1 at *
  generalize (z 2)[(e : ℕ)] = a2 at *
  generalize (z 3)[(e : ℕ)] = a3 at *
  generalize (z 4)[(e : ℕ)] = a4 at *
  generalize (z 5)[(e : ℕ)] = a5 at *
  generalize (z 6)[(e : ℕ)] = a6 at *
  generalize (z 7)[(e : ℕ)] = a7 at *
  generalize (z 8)[(e : ℕ)] = a8 at *
  generalize (z 9)[(e : ℕ)] = a9 at *
  generalize ht1 : a1 + a0 >>> 26 = t1
  generalize ht5 : a5 + a4 >>> 26 = t5
  generalize ht2 : a2 + t1 >>> 25 = t2
  generalize ht6 : a6 + t5 >>> 25 = t6
  generalize ht3 : a3 + t2 >>> 26 = t3
  generalize ht7 : a7 + t6 >>> 26 = t7
  generalize ht4 : (a4 &&& 67108863#64) + t3 >>> 25 = t4
  generalize ht8 : a8 + t7 >>> 25 = t8
  generalize hs5 : (t5 &&& 33554431#64) + t4 >>> 26 = s5
  generalize ht9 : a9 + t8 >>> 26 = t9
  generalize hu0 : (t9 >>> 25 &&& 67108863#64) * 19#64 + (a0 &&& 67108863#64) = u0
  generalize hu1 : t9 >>> 51 * 19#64 + (t1 &&& 33554431#64) + u0 >>> 26 = u1
  have k1 : t1.toNat = a1.toNat + a0.toNat / 2 ^ 26 := by
    rw [← ht1, BitVec.toNat_add, toNat_shr64]; omega
  have k5 : t5.toNat = a5.toNat + a4.toNat / 2 ^ 26 := by
    rw [← ht5, BitVec.toNat_add, toNat_shr64]; omega
  have k2 : t2.toNat = a2.toNat + t1.toNat / 2 ^ 25 := by
    rw [← ht2, BitVec.toNat_add, toNat_shr64]; omega
  have k6 : t6.toNat = a6.toNat + t5.toNat / 2 ^ 25 := by
    rw [← ht6, BitVec.toNat_add, toNat_shr64]; omega
  have k3 : t3.toNat = a3.toNat + t2.toNat / 2 ^ 26 := by
    rw [← ht3, BitVec.toNat_add, toNat_shr64]; omega
  have k7 : t7.toNat = a7.toNat + t6.toNat / 2 ^ 26 := by
    rw [← ht7, BitVec.toNat_add, toNat_shr64]; omega
  have k4 : t4.toNat = a4.toNat % 2 ^ 26 + t3.toNat / 2 ^ 25 := by
    rw [← ht4, BitVec.toNat_add, toNat_shr64, toNat_and26]; omega
  have k8 : t8.toNat = a8.toNat + t7.toNat / 2 ^ 25 := by
    rw [← ht8, BitVec.toNat_add, toNat_shr64]; omega
  have ks5 : s5.toNat = t5.toNat % 2 ^ 25 + t4.toNat / 2 ^ 26 := by
    rw [← hs5, BitVec.toNat_add, toNat_shr64, toNat_and25]; omega
  have k9 : t9.toNat = a9.toNat + t8.toNat / 2 ^ 26 := by
    rw [← ht9, BitVec.toNat_add, toNat_shr64]; omega
  have hlt9 := t9.isLt
  have ku0 : u0.toNat = t9.toNat / 2 ^ 25 % 2 ^ 26 * 19 + a0.toNat % 2 ^ 26 := by
    rw [← hu0, BitVec.toNat_add, BitVec.toNat_mul, toNat_and26, toNat_shr64, toNat_and26,
      show (19#64).toNat = 19 from rfl]
    omega
  have ku1 : u1.toNat = t9.toNat / 2 ^ 51 * 19 + t1.toNat % 2 ^ 25 + u0.toNat / 2 ^ 26 := by
    rw [← hu1, BitVec.toNat_add, BitVec.toNat_add, BitVec.toNat_mul, toNat_shr64, toNat_shr64,
      toNat_and25, show (19#64).toNat = 19 from rfl]
    omega
  have bu1 : u1.toNat < 2 ^ 25 + 2 ^ 19 := by omega
  have bs5 : s5.toNat < 2 ^ 25 + 2 ^ 19 := by omega
  simp only [toNat_lo32_and26, toNat_lo32_and25, toNat_lo32,
    Nat.mod_eq_of_lt (by omega : u1.toNat < 2 ^ 32),
    Nat.mod_eq_of_lt (by omega : s5.toNat < 2 ^ 32)]
  refine
    ⟨?_, by omega, bu1, by omega, by omega, by omega, bs5, by omega, by omega, by omega, by omega⟩
  push_cast [← reduce64_val k1 k5 k2 k6 k3 k7 k4 k8 ks5 k9 ku0 ku1]
  rfl

/-- `reduce64` keeps element `e`'s value: lane `e` of the ten limbs, each below `2^64 - 2^40` and
limb `k` weighing `2^⌈25.5 k⌉`, comes out in limbs below `2^26` (even) and `2^25 + 2^19` (odd). -/
public theorem FieldElement2625x4_reduce64_impl_reduce64.spec_lane
    (z : Fin 10 → Vector (BitVec 64) 4) (e : Fin 4)
    (hz : ∀ k, (z k)[(e : ℕ)].toNat < 2 ^ 64 - 2 ^ 40) :
    val (FieldElement2625x4_reduce64_impl_reduce64.spec z) e =
        ((z 0)[(e : ℕ)].toNat : ZMod p) + ((z 1)[(e : ℕ)].toNat : ZMod p) * 2 ^ 26 +
          ((z 2)[(e : ℕ)].toNat : ZMod p) * 2 ^ 51 +
          ((z 3)[(e : ℕ)].toNat : ZMod p) * 2 ^ 77 +
          ((z 4)[(e : ℕ)].toNat : ZMod p) * 2 ^ 102 +
          ((z 5)[(e : ℕ)].toNat : ZMod p) * 2 ^ 128 +
          ((z 6)[(e : ℕ)].toNat : ZMod p) * 2 ^ 153 +
          ((z 7)[(e : ℕ)].toNat : ZMod p) * 2 ^ 179 +
          ((z 8)[(e : ℕ)].toNat : ZMod p) * 2 ^ 204 +
          ((z 9)[(e : ℕ)].toNat : ZMod p) * 2 ^ 230 ∧
      ∀ i,
        (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[evenLane e].toNat < 2 ^ 26 ∧
          (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[oddLane e].toNat <
            2 ^ 25 + 2 ^ 19 := by
  obtain ⟨hv, b0, b0', b1, b1', b2, b2', b3, b3', b4, b4'⟩ := spec_lane_explicit z e hz
  refine ⟨hv, fun i => ?_⟩
  fin_cases i
  exacts [⟨b0, b0'⟩, ⟨b1, b1'⟩, ⟨b2, b2'⟩, ⟨b3, b3'⟩, ⟨b4, b4'⟩]

/-- `spec_lane` over limbs known through `ValLe`. -/
public theorem FieldElement2625x4_reduce64_impl_reduce64.spec_valLe
    {z : Fin 10 → Vector (BitVec 64) 4} {e : Fin 4} {v : ZMod p}
    {n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 : ℕ}
    (h0 : ValLe (z 0)[(e : ℕ)] n0 M0) (h1 : ValLe (z 1)[(e : ℕ)] n1 M1)
    (h2 : ValLe (z 2)[(e : ℕ)] n2 M2) (h3 : ValLe (z 3)[(e : ℕ)] n3 M3)
    (h4 : ValLe (z 4)[(e : ℕ)] n4 M4) (h5 : ValLe (z 5)[(e : ℕ)] n5 M5)
    (h6 : ValLe (z 6)[(e : ℕ)] n6 M6) (h7 : ValLe (z 7)[(e : ℕ)] n7 M7)
    (h8 : ValLe (z 8)[(e : ℕ)] n8 M8) (h9 : ValLe (z 9)[(e : ℕ)] n9 M9)
    (hM :
      M0 < 2 ^ 64 - 2 ^ 40 ∧
        M1 < 2 ^ 64 - 2 ^ 40 ∧
        M2 < 2 ^ 64 - 2 ^ 40 ∧
        M3 < 2 ^ 64 - 2 ^ 40 ∧
        M4 < 2 ^ 64 - 2 ^ 40 ∧
        M5 < 2 ^ 64 - 2 ^ 40 ∧
        M6 < 2 ^ 64 - 2 ^ 40 ∧ M7 < 2 ^ 64 - 2 ^ 40 ∧ M8 < 2 ^ 64 - 2 ^ 40 ∧ M9 < 2 ^ 64 - 2 ^ 40)
    (hv :
      (n0 : ZMod p) + n1 * 2 ^ 26 + n2 * 2 ^ 51 + n3 * 2 ^ 77 + n4 * 2 ^ 102 + n5 * 2 ^ 128 +
          n6 * 2 ^ 153 +
          n7 * 2 ^ 179 +
          n8 * 2 ^ 204 +
          n9 * 2 ^ 230 =
        v) :
    val (FieldElement2625x4_reduce64_impl_reduce64.spec z) e = v ∧
      ∀ i,
        (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[evenLane e].toNat < 2 ^ 26 ∧
          (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[oddLane e].toNat <
            2 ^ 25 + 2 ^ 19 := by
  obtain ⟨hM0, hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, hM9⟩ := hM
  have hz : ∀ k, (z k)[(e : ℕ)].toNat < 2 ^ 64 - 2 ^ 40 := by
    intro k
    fin_cases k
    exacts [h0.1 ▸ h0.2.trans_lt hM0, h1.1 ▸ h1.2.trans_lt hM1, h2.1 ▸ h2.2.trans_lt hM2,
      h3.1 ▸ h3.2.trans_lt hM3, h4.1 ▸ h4.2.trans_lt hM4, h5.1 ▸ h5.2.trans_lt hM5,
      h6.1 ▸ h6.2.trans_lt hM6, h7.1 ▸ h7.2.trans_lt hM7, h8.1 ▸ h8.2.trans_lt hM8,
      h9.1 ▸ h9.2.trans_lt hM9]
  obtain ⟨hv', hb⟩ := FieldElement2625x4_reduce64_impl_reduce64.spec_lane z e hz
  refine ⟨?_, hb⟩
  rw [hv', h0.1, h1.1, h2.1, h3.1, h4.1, h5.1, h6.1, h7.1, h8.1, h9.1, hv]

/-- `spec_lane` over limbs bounded by `M_k` and of value `v_k` in `ZMod p`. -/
public theorem FieldElement2625x4_reduce64_impl_reduce64.spec_valZ
    {z : Fin 10 → Vector (BitVec 64) 4} {e : Fin 4} {v v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 : ZMod p}
    {M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 : ℕ}
    (h0 : (z 0)[(e : ℕ)].toNat ≤ M0 ∧ ((z 0)[(e : ℕ)].toNat : ZMod p) = v0)
    (h1 : (z 1)[(e : ℕ)].toNat ≤ M1 ∧ ((z 1)[(e : ℕ)].toNat : ZMod p) = v1)
    (h2 : (z 2)[(e : ℕ)].toNat ≤ M2 ∧ ((z 2)[(e : ℕ)].toNat : ZMod p) = v2)
    (h3 : (z 3)[(e : ℕ)].toNat ≤ M3 ∧ ((z 3)[(e : ℕ)].toNat : ZMod p) = v3)
    (h4 : (z 4)[(e : ℕ)].toNat ≤ M4 ∧ ((z 4)[(e : ℕ)].toNat : ZMod p) = v4)
    (h5 : (z 5)[(e : ℕ)].toNat ≤ M5 ∧ ((z 5)[(e : ℕ)].toNat : ZMod p) = v5)
    (h6 : (z 6)[(e : ℕ)].toNat ≤ M6 ∧ ((z 6)[(e : ℕ)].toNat : ZMod p) = v6)
    (h7 : (z 7)[(e : ℕ)].toNat ≤ M7 ∧ ((z 7)[(e : ℕ)].toNat : ZMod p) = v7)
    (h8 : (z 8)[(e : ℕ)].toNat ≤ M8 ∧ ((z 8)[(e : ℕ)].toNat : ZMod p) = v8)
    (h9 : (z 9)[(e : ℕ)].toNat ≤ M9 ∧ ((z 9)[(e : ℕ)].toNat : ZMod p) = v9)
    (hM :
      M0 < 2 ^ 64 - 2 ^ 40 ∧
        M1 < 2 ^ 64 - 2 ^ 40 ∧
        M2 < 2 ^ 64 - 2 ^ 40 ∧
        M3 < 2 ^ 64 - 2 ^ 40 ∧
        M4 < 2 ^ 64 - 2 ^ 40 ∧
        M5 < 2 ^ 64 - 2 ^ 40 ∧
        M6 < 2 ^ 64 - 2 ^ 40 ∧ M7 < 2 ^ 64 - 2 ^ 40 ∧ M8 < 2 ^ 64 - 2 ^ 40 ∧ M9 < 2 ^ 64 - 2 ^ 40)
    (hv :
      v0 + v1 * 2 ^ 26 + v2 * 2 ^ 51 + v3 * 2 ^ 77 + v4 * 2 ^ 102 + v5 * 2 ^ 128 + v6 * 2 ^ 153 +
          v7 * 2 ^ 179 +
          v8 * 2 ^ 204 +
          v9 * 2 ^ 230 =
        v) :
    val (FieldElement2625x4_reduce64_impl_reduce64.spec z) e = v ∧
      ∀ i,
        (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[evenLane e].toNat < 2 ^ 26 ∧
          (FieldElement2625x4_reduce64_impl_reduce64.spec z i)[oddLane e].toNat <
            2 ^ 25 + 2 ^ 19 := by
  obtain ⟨hM0, hM1, hM2, hM3, hM4, hM5, hM6, hM7, hM8, hM9⟩ := hM
  have hz : ∀ k, (z k)[(e : ℕ)].toNat < 2 ^ 64 - 2 ^ 40 := by
    intro k
    fin_cases k
    exacts [h0.1.trans_lt hM0, h1.1.trans_lt hM1, h2.1.trans_lt hM2, h3.1.trans_lt hM3,
      h4.1.trans_lt hM4, h5.1.trans_lt hM5, h6.1.trans_lt hM6, h7.1.trans_lt hM7, h8.1.trans_lt hM8,
      h9.1.trans_lt hM9]
  obtain ⟨hv', hb⟩ := FieldElement2625x4_reduce64_impl_reduce64.spec_lane z e hz
  refine ⟨?_, hb⟩
  rw [hv', h0.2, h1.2, h2.2, h3.2, h4.2, h5.2, h6.2, h7.2, h8.2, h9.2, hv]

/-! ## Products -/

/-- Lane `k` of `v` zero-extended: a limb as `mul32` reads it. -/
def zx (v : Vector (BitVec 32) 8) (k : Fin 8) : BitVec 64 :=
  0#32 ++ v[k]

/-- Lane `k` of `v` doubled in 32 bits, zero-extended. -/
def zx2 (v : Vector (BitVec 32) 8) (k : Fin 8) : BitVec 64 :=
  0#32 ++ v[k] <<< 1

theorem ValLe.zx {v : Vector (BitVec 32) 8} {k : Fin 8} (h : v[k].toNat ≤ M) :
    ValLe (zx v k) v[k].toNat M :=
  ⟨by
    rw [Avx2.zx, BitVec.toNat_append]; simp, h⟩

theorem ValLe.zx2 {v : Vector (BitVec 32) 8} {k : Fin 8} (h : v[k].toNat ≤ M)
    (hM : M * 2 < 2 ^ 32) : ValLe (zx2 v k) (v[k].toNat * 2) (M * 2) := by
  refine ⟨?_, Nat.mul_le_mul_right 2 h⟩
  rw [Avx2.zx2, BitVec.toNat_append, BitVec.toNat_shiftLeft]
  simp only [BitVec.toNat_ofNat, Nat.zero_mod, Nat.shiftLeft_eq]
  rw [Nat.mod_eq_of_lt (by omega)]
  simp

theorem ValLe.mask32 {x : BitVec 64} (hx : ValLe x n M) (h : M < 2 ^ 32) :
    ValLe (x &&& 4294967295#64) n M := by
  obtain ⟨rfl, hn⟩ := hx
  refine ⟨?_, hn⟩
  rw [BitVec.toNat_and, show (4294967295#64).toNat = 2 ^ 32 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod, Nat.mod_eq_of_lt (by omega)]

theorem ValLe.c19 : ValLe (19#64) 19 19 :=
  ⟨rfl, le_rfl⟩

theorem unpackLo_lane (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackLo v)[(e : ℕ)] = zx v (evenLane e) := by fin_cases e <;> rfl

theorem unpackHi_lane (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackHi v)[(e : ℕ)] = zx v (oddLane e) := by fin_cases e <;> rfl

theorem unpackLo2_lane (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackLo2 v)[(e : ℕ)] = zx2 v (evenLane e) := by fin_cases e <;> rfl

theorem unpackHi2_lane (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackHi2 v)[(e : ℕ)] = zx2 v (oddLane e) := by fin_cases e <;> rfl

/-- Lane `D` of `negate_D(x, c)`: `c - x`, its value in `ZMod p`, when `x` is at most `c`. -/
theorem negateD_lane3 {x : Vector (BitVec 64) 4} {c : ℕ} {e : Fin 4} (he : e = 3)
    (hx : ValLe x[(e : ℕ)] n M) (hc : c < 2 ^ 64) (hM : M ≤ c) :
    (negateD x (BitVec.ofNat 64 c))[(e : ℕ)].toNat ≤ c ∧
      ((negateD x (BitVec.ofNat 64 c))[(e : ℕ)].toNat : ZMod p) = c - n := by
  subst he
  obtain ⟨hn, hle⟩ := hx
  change x[3].toNat = n at hn
  change
    (negateD x (BitVec.ofNat 64 c))[3].toNat ≤ c ∧
      ((negateD x (BitVec.ofNat 64 c))[3].toNat : ZMod p) = c - n
  have hsub : (negateD x (BitVec.ofNat 64 c))[3].toNat = c - n := by
    show (BitVec.ofNat 64 c - x[3]).toNat = c - n
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hc]; omega),
      BitVec.toNat_ofNat, Nat.mod_eq_of_lt hc, hn]
  refine ⟨by omega, ?_⟩
  rw [hsub, Nat.cast_sub (by omega)]

/-- A lane through `ZMod p`. -/
theorem ValLe.toZ {x : BitVec 64} (hx : ValLe x n M) : x.toNat ≤ M ∧ (x.toNat : ZMod p) = n :=
  ⟨hx.1 ▸ hx.2, by rw [hx.1]⟩

-- the lane rules unify by heads, without unfolding a bound into its bits
attribute [local irreducible] ValLe evenLane oddLane zx zx2

/-- `&x * &y` multiplies each element: `x`'s limbs below `5 · 2^26` (even) and `5 · 2^25 + 2^21`
(odd), `y`'s below `3 · 2^26` and `3 · 2^25 + 2^21`, into limbs below `2^26` and `2^25 + 2^19`. -/
public theorem FieldElement2625x4_Mul_mul_impl_mul.spec_val {x y : Fe2625x4}
    (hx : Bounded x (5 * 2 ^ 26) (5 * 2 ^ 25 + 2 ^ 21))
    (hy : Bounded y (3 * 2 ^ 26) (3 * 2 ^ 25 + 2 ^ 21)) :
    (∀ e, val (FieldElement2625x4_Mul_mul_impl_mul.spec x y) e = val x e * val y e) ∧
      Bounded (FieldElement2625x4_Mul_mul_impl_mul.spec x y) (2 ^ 26) (2 ^ 25 + 2 ^ 19) := by
  have key (e : Fin 4) :
    val (FieldElement2625x4_Mul_mul_impl_mul.spec x y) e = val x e * val y e ∧
      ∀ i,
        (FieldElement2625x4_Mul_mul_impl_mul.spec x y i)[evenLane e].toNat < 2 ^ 26 ∧
          (FieldElement2625x4_Mul_mul_impl_mul.spec x y i)[oddLane e].toNat < 2 ^ 25 + 2 ^ 19 := by
    have hX i : ValLe (zx (x i) (evenLane e)) (x i)[evenLane e].toNat (5 * 2 ^ 26 - 1) :=
      ValLe.zx
        (by
          have := (hx i e).1; omega)
    have hX' i : ValLe (zx (x i) (oddLane e)) (x i)[oddLane e].toNat (5 * 2 ^ 25 + 2 ^ 21 - 1) :=
      ValLe.zx
        (by
          have := (hx i e).2; omega)
    have hX2 i :
      ValLe (zx2 (x i) (oddLane e)) ((x i)[oddLane e].toNat * 2) ((5 * 2 ^ 25 + 2 ^ 21 - 1) * 2) :=
      ValLe.zx2
        (by
          have := (hx i e).2; omega)
        (by decide)
    have hY i : ValLe (zx (y i) (evenLane e)) (y i)[evenLane e].toNat (3 * 2 ^ 26 - 1) :=
      ValLe.zx
        (by
          have := (hy i e).1; omega)
    have hY' i : ValLe (zx (y i) (oddLane e)) (y i)[oddLane e].toNat (3 * 2 ^ 25 + 2 ^ 21 - 1) :=
      ValLe.zx
        (by
          have := (hy i e).2; omega)
    simp only [FieldElement2625x4_Mul_mul_impl_mul.spec]
    apply FieldElement2625x4_reduce64_impl_reduce64.spec_valLe
    iterate 10
      · simp only [Matrix.cons_val, vsum, List.foldl, vadd_getElem, vmul_getElem, vand_getElem,
          Vector.getElem_replicate, unpackLo_lane, unpackHi_lane, unpackHi2_lane]
        repeat
          first
          | apply ValLe.add
          | apply ValLe.mul
          | apply ValLe.mask32
          | exact ValLe.c19
          | exact hX _
          | exact hX' _
          | exact hX2 _
          | exact hY _
          | exact hY' _
          | decide
    · decide
    · rw [val, val, nat_eq, nat_eq]
      push_cast
      generalize ((x 0)[evenLane e].toNat : ZMod p) = X0
      generalize ((x 0)[oddLane e].toNat : ZMod p) = X1
      generalize ((x 1)[evenLane e].toNat : ZMod p) = X2
      generalize ((x 1)[oddLane e].toNat : ZMod p) = X3
      generalize ((x 2)[evenLane e].toNat : ZMod p) = X4
      generalize ((x 2)[oddLane e].toNat : ZMod p) = X5
      generalize ((x 3)[evenLane e].toNat : ZMod p) = X6
      generalize ((x 3)[oddLane e].toNat : ZMod p) = X7
      generalize ((x 4)[evenLane e].toNat : ZMod p) = X8
      generalize ((x 4)[oddLane e].toNat : ZMod p) = X9
      generalize ((y 0)[evenLane e].toNat : ZMod p) = Y0
      generalize ((y 0)[oddLane e].toNat : ZMod p) = Y1
      generalize ((y 1)[evenLane e].toNat : ZMod p) = Y2
      generalize ((y 1)[oddLane e].toNat : ZMod p) = Y3
      generalize ((y 2)[evenLane e].toNat : ZMod p) = Y4
      generalize ((y 2)[oddLane e].toNat : ZMod p) = Y5
      generalize ((y 3)[evenLane e].toNat : ZMod p) = Y6
      generalize ((y 3)[oddLane e].toNat : ZMod p) = Y7
      generalize ((y 4)[evenLane e].toNat : ZMod p) = Y8
      generalize ((y 4)[oddLane e].toNat : ZMod p) = Y9
      linear_combination
        (-(2 * X1 * Y9 + X2 * Y8 + X2 * Y9 * 2 ^ 26 + 2 * X3 * Y7 + X3 * Y8 * 2 ^ 26 +
              2 * X3 * Y9 * 2 ^ 51 +
              X4 * Y6 +
              X4 * Y7 * 2 ^ 26 +
              X4 * Y8 * 2 ^ 51 +
              X4 * Y9 * 2 ^ 77 +
              2 * X5 * Y5 +
              X5 * Y6 * 2 ^ 26 +
              2 * X5 * Y7 * 2 ^ 51 +
              X5 * Y8 * 2 ^ 77 +
              2 * X5 * Y9 * 2 ^ 102 +
              X6 * Y4 +
              X6 * Y5 * 2 ^ 26 +
              X6 * Y6 * 2 ^ 51 +
              X6 * Y7 * 2 ^ 77 +
              X6 * Y8 * 2 ^ 102 +
              X6 * Y9 * 2 ^ 128 +
              2 * X7 * Y3 +
              X7 * Y4 * 2 ^ 26 +
              2 * X7 * Y5 * 2 ^ 51 +
              X7 * Y6 * 2 ^ 77 +
              2 * X7 * Y7 * 2 ^ 102 +
              X7 * Y8 * 2 ^ 128 +
              2 * X7 * Y9 * 2 ^ 153 +
              X8 * Y2 +
              X8 * Y3 * 2 ^ 26 +
              X8 * Y4 * 2 ^ 51 +
              X8 * Y5 * 2 ^ 77 +
              X8 * Y6 * 2 ^ 102 +
              X8 * Y7 * 2 ^ 128 +
              X8 * Y8 * 2 ^ 153 +
              X8 * Y9 * 2 ^ 179 +
              2 * X9 * Y1 +
              X9 * Y2 * 2 ^ 26 +
              2 * X9 * Y3 * 2 ^ 51 +
              X9 * Y4 * 2 ^ 77 +
              2 * X9 * Y5 * 2 ^ 102 +
              X9 * Y6 * 2 ^ 128 +
              2 * X9 * Y7 * 2 ^ 153 +
              X9 * Y8 * 2 ^ 179 +
              2 * X9 * Y9 * 2 ^ 204)) *
          two_pow_255
  exact ⟨fun e => (key e).1, fun i e => (key e).2 i⟩

theorem negateD_lane {x : Vector (BitVec 64) 4} {c : BitVec 64} {e : Fin 4} (he : (e : ℕ) < 3) :
    (negateD x c)[(e : ℕ)] = x[(e : ℕ)] := by
  fin_cases e
  all_goals
    first
    | rfl
    | simp at he

/-- `2^37 p` in `negate_D`'s limbs is zero in `ZMod p`. -/
theorem p37_val :
    ((9223369425514659840 : ℕ) : ZMod p) + ((4611685880988434432 : ℕ) : ZMod p) * 2 ^ 26 +
        ((9223371899415822336 : ℕ) : ZMod p) * 2 ^ 51 +
        ((4611685880988434432 : ℕ) : ZMod p) * 2 ^ 77 +
        ((9223371899415822336 : ℕ) : ZMod p) * 2 ^ 102 +
        ((4611685880988434432 : ℕ) : ZMod p) * 2 ^ 128 +
        ((9223371899415822336 : ℕ) : ZMod p) * 2 ^ 153 +
        ((4611685880988434432 : ℕ) : ZMod p) * 2 ^ 179 +
        ((9223371899415822336 : ℕ) : ZMod p) * 2 ^ 204 +
        ((4611685880988434432 : ℕ) : ZMod p) * 2 ^ 230 =
      0 := by
  have h : ((2 ^ 37 * p : ℕ) : ZMod p) = 0 := by simp
  rw [← h]
  norm_num [p]

/-- `x.square_and_negate_D()` squares each element and negates `D`: limbs below `2^27 + 2^13`
(even) and `2^26 + 2^20` (odd) in, limbs below `2^26` and `2^25 + 2^19` out. -/
public theorem FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec_val
    {x : Fe2625x4} (hx : Bounded x (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20)) :
    (∀ e,
        val (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec x) e =
          if e = 3 then -val x e ^ 2 else val x e ^ 2) ∧
      Bounded (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec x) (2 ^ 26)
        (2 ^ 25 + 2 ^ 19) := by
  have key (e : Fin 4) :
    val (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec x) e =
        (if e = 3 then -val x e ^ 2 else val x e ^ 2) ∧
      ∀ i,
        (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec x
                  i)[evenLane e].toNat <
            2 ^ 26 ∧
          (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec x
                  i)[oddLane e].toNat <
            2 ^ 25 + 2 ^ 19 := by
    have hX i : ValLe (zx (x i) (evenLane e)) (x i)[evenLane e].toNat (2 ^ 27 + 2 ^ 13 - 1) :=
      ValLe.zx
        (by
          have := (hx i e).1; omega)
    have hX' i : ValLe (zx (x i) (oddLane e)) (x i)[oddLane e].toNat (2 ^ 26 + 2 ^ 20 - 1) :=
      ValLe.zx
        (by
          have := (hx i e).2; omega)
    have hX2 i :
      ValLe (zx2 (x i) (evenLane e)) ((x i)[evenLane e].toNat * 2) ((2 ^ 27 + 2 ^ 13 - 1) * 2) :=
      ValLe.zx2
        (by
          have := (hx i e).1; omega)
        (by decide)
    have hX2' i :
      ValLe (zx2 (x i) (oddLane e)) ((x i)[oddLane e].toNat * 2) ((2 ^ 26 + 2 ^ 20 - 1) * 2) :=
      ValLe.zx2
        (by
          have := (hx i e).2; omega)
        (by decide)
    have hval :
      val x e =
        ((x 0)[evenLane e].toNat : ZMod p) + ((x 0)[oddLane e].toNat : ZMod p) * 2 ^ 26 +
          ((x 1)[evenLane e].toNat : ZMod p) * 2 ^ 51 +
          ((x 1)[oddLane e].toNat : ZMod p) * 2 ^ 77 +
          ((x 2)[evenLane e].toNat : ZMod p) * 2 ^ 102 +
          ((x 2)[oddLane e].toNat : ZMod p) * 2 ^ 128 +
          ((x 3)[evenLane e].toNat : ZMod p) * 2 ^ 153 +
          ((x 3)[oddLane e].toNat : ZMod p) * 2 ^ 179 +
          ((x 4)[evenLane e].toNat : ZMod p) * 2 ^ 204 +
          ((x 4)[oddLane e].toNat : ZMod p) * 2 ^ 230 := by
      rw [val, nat_eq]; push_cast; ring
    simp only [FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec]
    rcases (show (e : ℕ) < 3 ∨ e = 3 by omega) with he | he
    · have hne : e ≠ 3 := by
        rintro rfl; simp at he
      rw [ite_eq_right_of_eq_false _ _ (eq_false hne)]
      apply FieldElement2625x4_reduce64_impl_reduce64.spec_valLe
      iterate 10
        · simp only [Matrix.cons_val, negateD_lane he, vsum, List.foldl, vadd_getElem, vmul_getElem,
            vand_getElem, vshl_getElem, Vector.getElem_replicate, unpackLo_lane, unpackHi_lane,
            unpackLo2_lane, unpackHi2_lane]
          repeat
            first
            | apply ValLe.add
            | apply ValLe.mul
            | apply ValLe.shl
            | apply ValLe.mask32
            | exact ValLe.c19
            | exact hX _
            | exact hX' _
            | exact hX2 _
            | exact hX2' _
            | decide
      · decide
      · rw [hval]
        push_cast
        generalize ((x 0)[evenLane e].toNat : ZMod p) = X0
        generalize ((x 0)[oddLane e].toNat : ZMod p) = X1
        generalize ((x 1)[evenLane e].toNat : ZMod p) = X2
        generalize ((x 1)[oddLane e].toNat : ZMod p) = X3
        generalize ((x 2)[evenLane e].toNat : ZMod p) = X4
        generalize ((x 2)[oddLane e].toNat : ZMod p) = X5
        generalize ((x 3)[evenLane e].toNat : ZMod p) = X6
        generalize ((x 3)[oddLane e].toNat : ZMod p) = X7
        generalize ((x 4)[evenLane e].toNat : ZMod p) = X8
        generalize ((x 4)[oddLane e].toNat : ZMod p) = X9
        linear_combination
          (-(2 * X1 * X9 + X2 * X8 + X2 * X9 * 2 ^ 26 + 2 * X3 * X7 + X3 * X8 * 2 ^ 26 +
                2 * X3 * X9 * 2 ^ 51 +
                X4 * X6 +
                X4 * X7 * 2 ^ 26 +
                X4 * X8 * 2 ^ 51 +
                X4 * X9 * 2 ^ 77 +
                2 * X5 * X5 +
                X5 * X6 * 2 ^ 26 +
                2 * X5 * X7 * 2 ^ 51 +
                X5 * X8 * 2 ^ 77 +
                2 * X5 * X9 * 2 ^ 102 +
                X6 * X4 +
                X6 * X5 * 2 ^ 26 +
                X6 * X6 * 2 ^ 51 +
                X6 * X7 * 2 ^ 77 +
                X6 * X8 * 2 ^ 102 +
                X6 * X9 * 2 ^ 128 +
                2 * X7 * X3 +
                X7 * X4 * 2 ^ 26 +
                2 * X7 * X5 * 2 ^ 51 +
                X7 * X6 * 2 ^ 77 +
                2 * X7 * X7 * 2 ^ 102 +
                X7 * X8 * 2 ^ 128 +
                2 * X7 * X9 * 2 ^ 153 +
                X8 * X2 +
                X8 * X3 * 2 ^ 26 +
                X8 * X4 * 2 ^ 51 +
                X8 * X5 * 2 ^ 77 +
                X8 * X6 * 2 ^ 102 +
                X8 * X7 * 2 ^ 128 +
                X8 * X8 * 2 ^ 153 +
                X8 * X9 * 2 ^ 179 +
                2 * X9 * X1 +
                X9 * X2 * 2 ^ 26 +
                2 * X9 * X3 * 2 ^ 51 +
                X9 * X4 * 2 ^ 77 +
                2 * X9 * X5 * 2 ^ 102 +
                X9 * X6 * 2 ^ 128 +
                2 * X9 * X7 * 2 ^ 153 +
                X9 * X8 * 2 ^ 179 +
                2 * X9 * X9 * 2 ^ 204)) *
            two_pow_255
    · rw [ite_eq_left_of_eq_true _ _ (eq_true he)]
      apply FieldElement2625x4_reduce64_impl_reduce64.spec_valZ
      iterate 10
        · simp only [Matrix.cons_val]
          apply negateD_lane3 he
          · simp only [vsum, List.foldl, vadd_getElem, vmul_getElem, vand_getElem, vshl_getElem,
              Vector.getElem_replicate, unpackLo_lane, unpackHi_lane, unpackLo2_lane,
              unpackHi2_lane]
            repeat
              first
              | apply ValLe.add
              | apply ValLe.mul
              | apply ValLe.shl
              | apply ValLe.mask32
              | exact ValLe.c19
              | exact hX _
              | exact hX' _
              | exact hX2 _
              | exact hX2' _
              | decide
          · decide
          · decide
      · decide
      · rw [hval]
        have h37 := p37_val
        push_cast at h37 ⊢
        generalize ((x 0)[evenLane e].toNat : ZMod p) = X0
        generalize ((x 0)[oddLane e].toNat : ZMod p) = X1
        generalize ((x 1)[evenLane e].toNat : ZMod p) = X2
        generalize ((x 1)[oddLane e].toNat : ZMod p) = X3
        generalize ((x 2)[evenLane e].toNat : ZMod p) = X4
        generalize ((x 2)[oddLane e].toNat : ZMod p) = X5
        generalize ((x 3)[evenLane e].toNat : ZMod p) = X6
        generalize ((x 3)[oddLane e].toNat : ZMod p) = X7
        generalize ((x 4)[evenLane e].toNat : ZMod p) = X8
        generalize ((x 4)[oddLane e].toNat : ZMod p) = X9
        linear_combination
          h37 +
            (2 * X1 * X9 + X2 * X8 + X2 * X9 * 2 ^ 26 + 2 * X3 * X7 + X3 * X8 * 2 ^ 26 +
                2 * X3 * X9 * 2 ^ 51 +
                X4 * X6 +
                X4 * X7 * 2 ^ 26 +
                X4 * X8 * 2 ^ 51 +
                X4 * X9 * 2 ^ 77 +
                2 * X5 * X5 +
                X5 * X6 * 2 ^ 26 +
                2 * X5 * X7 * 2 ^ 51 +
                X5 * X8 * 2 ^ 77 +
                2 * X5 * X9 * 2 ^ 102 +
                X6 * X4 +
                X6 * X5 * 2 ^ 26 +
                X6 * X6 * 2 ^ 51 +
                X6 * X7 * 2 ^ 77 +
                X6 * X8 * 2 ^ 102 +
                X6 * X9 * 2 ^ 128 +
                2 * X7 * X3 +
                X7 * X4 * 2 ^ 26 +
                2 * X7 * X5 * 2 ^ 51 +
                X7 * X6 * 2 ^ 77 +
                2 * X7 * X7 * 2 ^ 102 +
                X7 * X8 * 2 ^ 128 +
                2 * X7 * X9 * 2 ^ 153 +
                X8 * X2 +
                X8 * X3 * 2 ^ 26 +
                X8 * X4 * 2 ^ 51 +
                X8 * X5 * 2 ^ 77 +
                X8 * X6 * 2 ^ 102 +
                X8 * X7 * 2 ^ 128 +
                X8 * X8 * 2 ^ 153 +
                X8 * X9 * 2 ^ 179 +
                2 * X9 * X1 +
                X9 * X2 * 2 ^ 26 +
                2 * X9 * X3 * 2 ^ 51 +
                X9 * X4 * 2 ^ 77 +
                2 * X9 * X5 * 2 ^ 102 +
                X9 * X6 * 2 ^ 128 +
                2 * X9 * X7 * 2 ^ 153 +
                X9 * X8 * 2 ^ 179 +
                2 * X9 * X9 * 2 ^ 204) *
              two_pow_255
  exact ⟨fun e => (key e).1, fun i e => (key e).2 i⟩

end Avx2

end MLIR.Agave

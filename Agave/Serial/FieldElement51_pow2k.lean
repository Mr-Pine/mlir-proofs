module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.FieldElement51
public import Agave.Serial.Mlir.FieldElement51_pow2k

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- One pass of `pow2k`'s loop, named as in the Rust: the column sums `c0 … c4` of `a²` (cross
terms doubled, `2 * (x + y)` as `x <<< 1 + y <<< 1`; `a3_19 a4_19` for the wrapped ones), carried
as in `mul`; in the code's operand order. -/
def FieldElement51_pow2k.square (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let a3_19 := a 3 * 19#64
  let a4_19 := a 4 * 19#64
  let c0 := mulWide (a 1) a4_19 <<< 1 + mulWide (a 2) a3_19 <<< 1 + mulWide (a 0) (a 0)
  let c1 := mulWide (a 0) (a 1) <<< 1 + mulWide (a 2) a4_19 <<< 1 + mulWide a3_19 (a 3)
  let c2 := mulWide (a 0) (a 2) <<< 1 + mulWide a3_19 (a 4) <<< 1 + mulWide (a 1) (a 1)
  let c3 := mulWide (a 0) (a 3) <<< 1 + mulWide (a 1) (a 2) <<< 1 + mulWide a4_19 (a 4)
  let c4 := mulWide (a 0) (a 4) <<< 1 + mulWide (a 1) (a 3) <<< 1 + mulWide (a 2) (a 2)
  let c1 := c1 + carry128 c0
  let a0 := c0.setWidth 64 &&& mask51
  let c2 := c2 + carry128 c1
  let a1 := c1.setWidth 64 &&& mask51
  let c3 := c3 + carry128 c2
  let a2 := c2.setWidth 64 &&& mask51
  let c4 := c4 + carry128 c3
  let a3 := c3.setWidth 64 &&& mask51
  let carry := (c4 >>> 51).setWidth 64
  let a4 := c4.setWidth 64 &&& mask51
  let a0 := carry * 19#64 + a0
  let a1 := a0 >>> 51 + a1
  fun
  | 0 => a0 &&& mask51
  | 1 => a1
  | 2 => a2
  | 3 => a3
  | 4 => a4

/-- `k` passes of the loop. -/
def FieldElement51_pow2k.sqrN : Nat → (Fin 5 → BitVec 64) → Fin 5 → BitVec 64
  | 0, a => a
  | n + 1, a => FieldElement51_pow2k.sqrN n (FieldElement51_pow2k.square a)

/-- `self.pow2k(k)`: `self` squared `k` times. -/
abbrev FieldElement51_pow2k.spec (a : Fin 5 → BitVec 64) (k : Nat) : Fin 5 → BitVec 64 :=
  FieldElement51_pow2k.sqrN k a

end

/-! ## Proof -/

section Proof

/-- `^bb1`'s env: the constants, the limbs `a` (`%2095` is `a[0]`) and the counter `k`. -/
abbrev FieldElement51_pow2k.hdr (E : ⟪FieldElement51_pow2k.Γ⟫) (a : Fin 5 → BitVec 64) (k : Nat) :
    ⟪FieldElement51_pow2k.Γ⟫ :=
  E[%2074 := .value 19#64, %2075 := .value 1#128, %2076 := .value 51#128, %2077 :=
    .value 18446744073709551615#128, %2078 := .value 2251799813685247#64, %2079 := .value 51#64,
    %2080 := .value 4294967295#32, %2081 := .value 0#32, %2091 := .value (a 4), %2092 :=
    .value (a 3), %2093 := .value (a 2), %2094 := .value (a 1), %2095 := .value (a 0), %2096 :=
    .value (BitVec.ofNat 32 k)]

/-- `^bb2`'s env on leaving the loop: the limbs `a` (`%2171` is `a[0]`). -/
abbrev FieldElement51_pow2k.exit (E : ⟪FieldElement51_pow2k.Γ⟫) (a : Fin 5 → BitVec 64) :
    ⟪FieldElement51_pow2k.Γ⟫ :=
  E[%2167 := .value (a 2), %2168 := .value (a 3), %2169 := .value (a 4), %2170 := .value (a 1),
    %2171 := .value (a 0)]

/-- The counter's `k - 1` (`add nsw k, -1`) does not overflow. -/
theorem dec_nsw (k : Nat) (h0 : 0 < k) (h : k < 2 ^ 31) :
    ¬(BitVec.ofNat 32 k).saddOverflow 4294967295#32 := by
  have hx : (BitVec.ofNat 32 k).toInt = k := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp [BitVec.toNat_ofNat] <;> omega
  have hm : (4294967295#32).toInt = -1 := by decide
  simp only [BitVec.saddOverflow, hx, hm]
  simp
  omega

/-- The counter's `k - 1`. -/
theorem dec_eq (k : Nat) (h0 : 0 < k) :
    BitVec.ofNat 32 k + 4294967295#32 = BitVec.ofNat 32 (k - 1) := by
  apply BitVec.eq_of_toNat_eq
  rw [show (4294967295#32) = -1#32 from rfl, BitVec.toNat_add, BitVec.toNat_ofNat,
    BitVec.toNat_ofNat, BitVec.toNat_neg, BitVec.toNat_ofNat]
  omega

/-- The loop from `^bb1` with counter `k`, in continuation form: after `k` passes, `^bb2` runs on
`sqrN k a`. -/
theorem FieldElement51_pow2k.loop (S : GlobalState) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ k (a : Fin 5 → BitVec 64) E,
      0 < k →
        k < 2 ^ 31 →
        (FieldElement51_pow2k.ContAt ^bb2 E
          (FieldElement51_pow2k.exit · (FieldElement51_pow2k.sqrN k a)) S K) →
        FieldElement51_pow2k.runFrom (FieldElement51_pow2k.hdr E a k) ^bb1 S = K := by
  intro k
  induction k with
  | zero =>
    intros
    omega
  | succ k ih =>
    intro a E h0 h hK
    block_init
    iterate 68 step_pure
    step_pure [dec_nsw (k + 1) h0 h, dec_eq (k + 1) h0]
    step_pure
    finish_block
    · -- exit, after the last pass
      obtain rfl : k = 0 := by
        simp [BitVec.toNat_eq] at hbr
        omega
      run_from using hK
    · -- back to the header, one pass fewer
      run_from using ih (FieldElement51_pow2k.square a)
      · simp [BitVec.toNat_eq] at hbr
        omega
      run_from using hK

/-- `a.pow2k(k)` stores `spec a k` at `out`, for `0 < k < 2^31` (the counter's `k -= 1` is
`nsw`). The loads all come before the stores, so `out` may alias `a`. -/
public theorem FieldElement51_pow2k.call_eq (out a : Pointer) (k : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hk0 : 0 < k.toNat)
    (hk : k.toNat < 2 ^ 31) :
    FieldElement51_pow2k.call (FieldElement51_pow2k.args (.value out) (.value a) (.value k)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (FieldElement51_pow2k.spec (s.mem.readLimbs a) k.toNat) }) := by
  func_init
  block_init
  iterate 8 step_pure
  -- let mut a: [u64; 5] = self.0;
  step_load
  iterate 4
    step_pure
    step_load
  finish_block
  run_from using FieldElement51_pow2k.loop _ _ k.toNat (S₀.mem.readLimbs a)
  block_init
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Agave.Serial

module

public import Firedancer.Math.Field
public import Boringssl.fe_0
public import Boringssl.fe_1
public import Boringssl.fe_sq2_tt
public import Boringssl.fe_loose_invert
public import Boringssl.fe_isnonzero_fe_loose
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases

/-! BoringSSL's field functions in `ZMod p`, beyond Firedancer's fiat specs (whose meaning
`Firedancer.Math.Field` proves): the constants, `fe_sq2_tt`, `fe_loose_invert` and
`fe_isnonzero`. -/

namespace MLIR.Boringssl

open _root_.Ed25519 Firedancer.Ref

/-! ## Constants -/

/-- `fe_0` stores a tight `0`. -/
public theorem fe_0.spec_val : Limbs.val fe_0.spec = 0 ∧ Limbs.Tight fe_0.spec := by
  refine ⟨?_, fun i => ?_⟩
  · simp [Limbs.val, fe_0.spec]
  · simp [fe_0.spec]

/-- `fe_1` stores a tight `1`. -/
public theorem fe_1.spec_val : Limbs.val fe_1.spec = 1 ∧ Limbs.Tight fe_1.spec := by
  have h (i : Fin 5) : fe_1.spec i = if i = 0 then 1 else 0 := by fin_cases i <;> rfl
  refine ⟨?_, fun i => ?_⟩
  · simp [Limbs.val, h, Fin.sum_univ_five]
  · rw [h]
    split <;> simp

/-! ## `fe_sq2_tt` -/

/-- `fe_sq2_tt` doubles a loose field element's square into a tight one. -/
public theorem fe_sq2_tt.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Loose f) :
    Limbs.val (fe_sq2_tt.spec f) = 2 * Limbs.val f ^ 2 ∧ Limbs.Tight (fe_sq2_tt.spec f) := by
  obtain ⟨hv, ht⟩ := fd_f25519_sqr.spec_val hf
  obtain ⟨hv', ht'⟩ := fd_f25519_add.spec_val ht ht
  refine ⟨?_, ht'⟩
  rw [show fe_sq2_tt.spec f = fd_f25519_add.spec (fd_f25519_sqr.spec f) (fd_f25519_sqr.spec f) from
      rfl,
    hv', hv]
  ring

/-! ## `fe_loose_invert` -/

/-- `l` is loose with value `z ^ e`. -/
def IsPow (l z : Fin 5 → BitVec 64) (e : ℕ) : Prop :=
  Limbs.val l = Limbs.val z ^ e ∧ Limbs.Loose l

theorem IsPow.self {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z) : IsPow z z 1 :=
  ⟨(pow_one _).symm, hz⟩

theorem IsPow.sqr (h : IsPow l z e) : IsPow (fd_f25519_sqr.spec l) z (e * 2) := by
  obtain ⟨hv, ht⟩ := fd_f25519_sqr.spec_val h.2
  exact ⟨by rw [hv, h.1, pow_mul], ht.loose⟩

theorem IsPow.mul (h : IsPow l z e) (h' : IsPow m z f) :
    IsPow (fd_f25519_mul.spec l m) z (e + f) := by
  obtain ⟨hv, ht⟩ := fd_f25519_mul.spec_val h.2 h'.2
  exact ⟨by rw [hv, h.1, h'.1, pow_add], ht.loose⟩

theorem IsPow.sqrN (h : IsPow l z e) : IsPow (fd_f25519_pow22523.sqrN n l) z (e * 2 ^ n) := by
  induction n generalizing l e with
  | zero => simpa [fd_f25519_pow22523.sqrN] using h
  | succ n ih =>
    rw [fd_f25519_pow22523.sqrN, pow_succ', ← mul_assoc]
    exact ih h.sqr

/-- `fe_loose_invert` raises a loose field element to `p - 2`, tight: its inverse, `0` at `0`. -/
public theorem fe_loose_invert.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z) :
    Limbs.val (fe_loose_invert.spec z) = Limbs.val z ^ (p - 2) ∧
      Limbs.Tight (fe_loose_invert.spec z) := by
  have h0 := IsPow.self hz
  have h1 := h0.sqr
  have h2 := h1.sqr
  have h3 := h2.sqr
  have h4 := h0.mul h3
  have h5 := h1.mul h4
  have h6 := h5.sqr
  have h7 := h4.mul h6
  have h8 := h7.sqr
  have h9 := h8.sqrN (n := 4)
  have h10 := h9.mul h7
  have h11 := h10.sqr
  have h12 := h11.sqrN (n := 9)
  have h13 := h12.mul h10
  have h14 := h13.sqr
  have h15 := h14.sqrN (n := 19)
  have h16 := h15.mul h13
  have h17 := h16.sqrN (n := 10)
  have h18 := h17.mul h10
  have h19 := h18.sqr
  have h20 := h19.sqrN (n := 49)
  have h21 := h20.mul h18
  have h22 := h21.sqr
  have h23 := h22.sqrN (n := 99)
  have h24 := h23.mul h21
  have h25 := h24.sqrN (n := 50)
  have h26 := h25.mul h18
  have h27 := h26.sqrN (n := 5)
  obtain ⟨hv, ht⟩ := fd_f25519_mul.spec_val h27.2 h5.2
  exact
    ⟨hv.trans
        (by
          rw [h27.1, h5.1, ← pow_add]; norm_num [p]),
      ht⟩

/-! ## `fe_isnonzero` -/

/-- Two 32-byte strings are equal when their bytes are. -/
theorem bytes_eq_iff {x y : BitVec 256} :
    (∀ i < 32, x.extractLsb' (8 * i) 8 = y.extractLsb' (8 * i) 8) ↔ x = y := by
  refine ⟨fun h => ?_, fun h _ _ => h ▸ rfl⟩
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have := congrArg (·.getLsbD (j % 8)) (h (j / 8) (by omega))
  simpa [BitVec.getLsbD_extractLsb', show j % 8 < 8 by omega,
    show 8 * (j / 8) + j % 8 = j by omega] using this

/-- `fe_isnonzero` of a tight field element: `0` exactly at `0`. -/
public theorem fe_isnonzero_fe.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Tight f) :
    fe_isnonzero_fe.spec f = if Limbs.val f = 0 then 0#32 else 1#32 := by
  have hs := fiat_25519_to_bytes.spec_val hf
  have key : CRYPTO_memcmp.spec (fiat_25519_to_bytes.spec f) 0#256 32 = 0#32 ↔ Limbs.val f = 0 := by
    rw [CRYPTO_memcmp.spec_eq_zero_iff, bytes_eq_iff, ← ZMod.val_eq_zero, ← hs]
    constructor
    · intro h
      rw [h]
      rfl
    · intro h
      exact BitVec.eq_of_toNat_eq (by simpa using h)
  unfold fe_isnonzero_fe.spec
  by_cases h : Limbs.val f = 0
  · simp [h, key.mpr h]
  · have hne : CRYPTO_memcmp.spec (fiat_25519_to_bytes.spec f) 0#256 32 ≠ 0#32 := fun h' =>
      h (key.mp h')
    simp [h, bne_iff_ne.mpr hne]

/-- `fe_isnonzero` of a loose field element: `0` exactly at `0`. -/
public theorem fe_isnonzero_fe_loose.spec_val {f : Fin 5 → BitVec 64} (hf : Limbs.Loose f) :
    fe_isnonzero_fe_loose.spec f = if Limbs.val f = 0 then 0#32 else 1#32 := by
  obtain ⟨hv, ht⟩ := fiat_25519_carry.spec_val hf
  rw [fe_isnonzero_fe_loose.spec, fe_isnonzero_fe.spec_val ht, hv]

end MLIR.Boringssl

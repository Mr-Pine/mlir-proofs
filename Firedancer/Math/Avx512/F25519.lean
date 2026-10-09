module

public import Firedancer.Math.Avx512.R43x6
public import Firedancer.Avx512.fd_f25519_sub
public import Firedancer.Avx512.fd_f25519_is_zero
public import Firedancer.Avx512.fd_f25519_eq
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases

/-! `fd_f25519_sub`, `fd_f25519_is_zero` and `fd_f25519_eq` in `ZMod p`: `sub` is
`fd_r43x6_fold_signed` of `fd_r43x6_sub_fast`; `is_zero` tests for the lanes of `0` and of `p`,
which decides `val = 0` on folded or nearly reduced inputs, so `eq` decides equality. -/

namespace MLIR.Firedancer.Avx512

open MLIR.Firedancer.Ref (p)

namespace R43x6

/-! ## `fd_f25519_sub` -/

/-- `fd_f25519_sub` as compiled is `fd_r43x6_fold_signed(fd_r43x6_sub_fast(a, b))`. -/
public theorem fd_f25519_sub_eq (a b : Wwl) :
    fd_f25519_sub.spec a b = fd_r43x6_fold_signed (fd_r43x6_sub_fast a b) := by
  unfold fd_f25519_sub.spec fd_r43x6_fold_signed fd_r43x6_approx_carry_propagate
    fd_r43x6_sub_fast fd_r43x6_p
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    iterate 2
      try simp only [wwl_add_get, wwl_sub_get, wwl_and_get, wwl_shl_get, wwl_shr_vector_get,
        wwl_select_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6,
        wwl_get7, wwl_zero_get, getD_get, Vector.getElem_zipWith, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ, BitVec.reduceToNat,
        Nat.reduceMod, Nat.reduceLT, Nat.reduceSub, Nat.reduceAdd, ite_true, ite_false]
    generalize a[0] = a0, a[1] = a1, a[2] = a2, a[3] = a3, a[4] = a4, a[5] = a5, a[6] = a6,
      a[7] = a7, b[0] = b0, b[1] = b1, b[2] = b2, b[3] = b3, b[4] = b4, b[5] = b5, b[6] = b6,
      b[7] = b7
    bv_decide

/-- `fd_f25519_sub` subtracts `s61` limbs into folded ones. -/
public theorem fd_f25519_sub_spec {a b : Wwl} (ha : Signed 61 a) (hb : Signed 61 b) :
    val (fd_f25519_sub.spec a b) = val a - val b ∧ Folded (fd_f25519_sub.spec a b) := by
  obtain ⟨lane, v⟩ := sub_fast_lanes (x := a) (y := b) fun i => by
    have := ha i
    have := hb i
    omega
  have lb : ∀ i : Fin 6, (-2 ^ 63 + 19 * 2 ^ 23 : ℤ) ≤ (fd_r43x6_sub_fast a b)[(i : ℕ)].toInt :=
    fun i => by
      have := ha i
      have := hb i
      have := p_lane i
      rw [lane i]
      omega
  obtain ⟨v', f⟩ := fd_r43x6_fold_signed_spec_of_ge (lb 0) fun i => le_trans (by norm_num) (lb i)
  rw [fd_f25519_sub_eq]
  exact ⟨v'.trans v, f⟩

/-! ## `fd_f25519_is_zero` -/

theorem getLsbD_packLanes_bv1 (v : Vector (BitVec 1) 8) (i : Nat) (hi : i < 8) :
    (BitVec.packLanes v).getLsbD i = v[i].getLsbD 0 := by
  have h := congrArg (·.getLsbD 0) (BitVec.extractLsb'_packLanes v i (by omega))
  simpa using h

/-- Eight packed lane tests, widened and masked to their byte, are all set exactly when every lane
passes. -/
theorem packLanes_ofFn_and_255 (f : Fin 8 → Bool) :
    ((BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i))).setWidth 32 &&& 255 = 255) ↔
      ∀ i, f i = true := by
  have hb : ∀ q : BitVec 8, (q.setWidth 32 &&& 255 = 255) ↔ q = BitVec.allOnes 8 := by
    intro q; bv_decide
  rw [hb]
  constructor
  · intro h i
    have := getLsbD_packLanes_bv1 (Vector.ofFn fun i => BitVec.ofBool (f i)) i.1 i.2
    rw [h, BitVec.getLsbD_allOnes] at this
    simpa using this.symm
  · intro h
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    rw [getLsbD_packLanes_bv1 _ i hi, BitVec.getLsbD_allOnes]
    simp [h ⟨i, hi⟩, hi]

/-- `wwl_eq(x, y) & 0xFF == 0xFF` exactly when `x = y`. -/
public theorem wwl_eq_mask_iff (x y : Wwl) : (wwl_eq x y &&& 0xFF) = 0xFF ↔ x = y := by
  rw [wwl_eq, show (0xFF : BitVec 32) = 255 by rfl, packLanes_ofFn_and_255]
  simp only [beq_iff_eq]
  exact ⟨vec_ext_fin, fun h _ => h ▸ rfl⟩

/-- Folded limbs pack to below `2p`. -/
public theorem Folded.nat_lt {x : Wwl} (h : Folded x) : nat x < 2 * p := by
  obtain ⟨h0, h1, h2, h3, h4, h5, -⟩ := h
  have := p_add
  unfold nat
  omega

/-- A folded or nearly reduced `fd_r43x6_t` is zero exactly when its lanes are `0`'s or `p`'s. -/
theorem val_eq_zero_iff {x : Wwl} (h : Folded x ∨ NearlyReduced x) :
    val x = 0 ↔ x = fd_r43x6_zero ∨ x = fd_r43x6_p := by
  have b : x[0].toNat < 2 ^ 44 - 19 ∧ x[1].toNat < 2 ^ 44 - 1 ∧ x[2].toNat < 2 ^ 44 - 1 ∧
      x[3].toNat < 2 ^ 44 - 1 ∧ x[4].toNat < 2 ^ 44 - 1 ∧ x[5].toNat < 2 ^ 41 ∧
      HighZero x ∧ nat x < 2 * p := by
    rcases h with h | ⟨⟨h0, h1, h2, h3, h4, h5, h67⟩, hn⟩
    · obtain ⟨h0, h1, h2, h3, h4, h5, h67⟩ := h
      exact ⟨by omega, by omega, by omega, by omega, by omega, by omega, h67, Folded.nat_lt
        ⟨h0, h1, h2, h3, h4, h5, h67⟩⟩
    · exact ⟨by omega, by omega, by omega, by omega, by omega, by omega, h67, hn⟩
  obtain ⟨b0, b1, b2, b3, b4, b5, ⟨h6, h7⟩, hn⟩ := b
  have hu : Unsigned 63 x := by
    intro i; fin_cases i <;> simp <;> omega
  constructor
  · intro hv
    rw [val_eq_nat hu, ZMod.natCast_eq_zero_iff] at hv
    obtain ⟨k, hk⟩ := hv
    have hk2 : k < 2 := by
      by_contra hc
      have : p * 2 ≤ p * k := Nat.mul_le_mul_left p (by omega)
      omega
    have pa := p_add
    interval_cases k
    · left
      simp only [Nat.mul_zero, nat] at hk
      apply vec_ext_fin
      intro i
      fin_cases i <;> simp only [fd_r43x6_zero, wwl_zero] <;> (try simp [h6, h7]) <;>
        apply BitVec.eq_of_toNat_eq <;> simp <;> omega
    · right
      simp only [Nat.mul_one, nat] at hk
      have e : x[0].toNat = 8796093022189 ∧ x[1].toNat = 8796093022207 ∧
          x[2].toNat = 8796093022207 ∧ x[3].toNat = 8796093022207 ∧
          x[4].toNat = 8796093022207 ∧ x[5].toNat = 1099511627775 := by
        omega
      obtain ⟨e0, e1, e2, e3, e4, e5⟩ := e
      apply vec_ext_fin
      intro i
      fin_cases i <;> apply BitVec.eq_of_toNat_eq <;>
        simp [fd_r43x6_p, wwl, h6, h7, e0, e1, e2, e3, e4, e5]
  · rintro (rfl | rfl)
    · simp [val, int, fd_r43x6_zero, wwl_zero]
    · exact val_p

/-- `fd_f25519_is_zero` decides `val x = 0` on a folded or nearly reduced `fd_r43x6_t`. -/
public theorem fd_f25519_is_zero_spec {x : Wwl} (h : Folded x ∨ NearlyReduced x) :
    fd_f25519_is_zero.spec x = if val x = 0 then 1 else 0 := by
  rw [fd_f25519_is_zero.spec]
  simp only [wwl_eq_mask_iff, val_eq_zero_iff h]

/-! ## `fd_f25519_eq` -/

/-- `fd_f25519_eq` decides `val a = val b` on `s61` limbs. -/
public theorem fd_f25519_eq_spec {a b : Wwl} (ha : Signed 61 a) (hb : Signed 61 b) :
    fd_f25519_eq.spec a b = if val a = val b then 1 else 0 := by
  obtain ⟨v, f⟩ := fd_f25519_sub_spec ha hb
  rw [fd_f25519_eq.spec, fd_f25519_is_zero_spec (.inl f), v]
  simp only [sub_eq_zero]

end R43x6


end MLIR.Firedancer.Avx512

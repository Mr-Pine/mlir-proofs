module

public import Firedancer.Math.ScalarOps
public import Firedancer.Math.RistrettoSpec
public import Firedancer.Math.Msm
public import Firedancer.Ref.fd_zksdk_common
public import Mathlib.Algebra.Module.ZMod
public import Firedancer.Math.EllPrime
import Mathlib.LinearAlgebra.Dual.Lemmas
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.Polynomial.Eval.SMul
import Ed25519.BasePoint
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.ReduceModChar
public import Mathlib.Tactic.IntervalCases
import Std.Tactic.BVDecide

/-! The ristretto group `Dom / E[4]` as the sigma verifiers see it: decoded points, the basepoints
`G` and `H`, and the MSM-then-`eq` check they end with. -/

namespace Ed25519.Ristretto

/-! ## The ristretto group -/

@[expose] public section

/-- The ristretto group: `Dom` modulo `E[4]`. -/
abbrev RGroup : Type :=
  Dom ⧸ E4.addSubgroupOf Dom

/-- `Dom / E[4]` has exponent `ℓ`. True as `#E = 8ℓ`, not proved here (`Zksdk/CommonWIP.lean`);
a hypothesis wherever scalars act through `ZMod ℓ`. -/
class PrimeOrder : Prop where
  ell_nsmul_mem : ∀ P ∈ Dom, ell • P ∈ E4

instance : NeZero ell :=
  ⟨by
    unfold ell; omega⟩

/-- Under `PrimeOrder`, `ZMod ℓ` acts on the ristretto group. -/
instance [h : PrimeOrder] : Module (ZMod ell) RGroup :=
  AddCommGroup.zmodModule fun x => by
    induction x using QuotientAddGroup.induction_on with
    | H
      P =>
      rw [← QuotientAddGroup.mk_nsmul, QuotientAddGroup.eq_zero_iff, AddSubgroup.mem_addSubgroupOf,
        AddSubgroup.coe_nsmul]
      exact h.ell_nsmul_mem P P.2

/-- `b` decodes to a point of the class `x`. -/
def DecodesTo (b : BitVec 256) (x : RGroup) : Prop :=
  ∃ P : Dom, decode b = some (P : Point) ∧ (P : RGroup) = x

/-- `H`'s `x`. -/
def Hx : ZMod p :=
  32222932629776879811669602791249070039951768561812677975384713941242916316850

/-- `H`'s `y`. -/
def Hy : ZMod p :=
  30828795894175983001134965706862553632588963373726840206328944991670664296646

end

/-- `H` is on the curve. -/
public theorem onCurve_H : OnCurve Hx Hy := by
  unfold OnCurve Hx Hy d
  reduce_mod_char

/-- The Pedersen basepoint `H` (`fd_zksdk_basepoint_H`). -/
@[expose]
public def Hpt : Point :=
  ⟨Hx, Hy, onCurve_H⟩

/-- `G` (the base point) lies in `Dom`. -/
public theorem basePoint_mem_Dom : basePoint ∈ Dom :=
  mem_Dom.2
    ⟨34737626771194858627071295502606372355980995399692169211837275202373938891970, by
      show 1 - By ^ 2 = _
      unfold By
      reduce_mod_char⟩

/-- `H` lies in `Dom`. -/
public theorem Hpt_mem_Dom : Hpt ∈ Dom :=
  mem_Dom.2
    ⟨52270222501098189977832413181679660175189577614782344933847663525179043991476, by
      show 1 - Hy ^ 2 = _
      unfold Hy
      reduce_mod_char⟩

/-- The basepoint `G` in the ristretto group. -/
@[expose]
public noncomputable def G : RGroup :=
  ((⟨basePoint, basePoint_mem_Dom⟩ : Dom) : RGroup)

/-- The basepoint `H` in the ristretto group. -/
@[expose]
public noncomputable def H : RGroup :=
  ((⟨Hpt, Hpt_mem_Dom⟩ : Dom) : RGroup)

/-- `G` is the base point's class. -/
public theorem mk_basePoint : ((⟨basePoint, basePoint_mem_Dom⟩ : Dom) : RGroup) = G :=
  rfl

/-- `H` is `Hpt`'s class. -/
public theorem mk_Hpt : ((⟨Hpt, Hpt_mem_Dom⟩ : Dom) : RGroup) = H :=
  rfl

/-! ## Classes and `E[4]` -/

/-- Two points of `Dom` have the same class exactly when they differ by `E[4]`. -/
public theorem mk_eq_mk_iff (P Q : Dom) : (P : RGroup) = Q ↔ (P : Point) - Q ∈ E4 := by
  rw [QuotientAddGroup.eq, AddSubgroup.mem_addSubgroupOf, ← E4.neg_mem_iff]
  simp only [AddSubgroup.coe_add, AddSubgroup.coe_neg, neg_add_rev, neg_neg]
  rw [sub_eq_add_neg, add_comm]

/-- Under `PrimeOrder`, `ℕ` multiples are `ZMod ℓ` multiples. -/
public theorem nsmul_eq_smul [PrimeOrder] (n : ℕ) (x : RGroup) : n • x = (n : ZMod ell) • x :=
  (Nat.cast_smul_eq_nsmul (ZMod ell) n x).symm

/-- A decoding is unique. -/
public theorem DecodesTo.unique {b : BitVec 256} {x y : RGroup} (hx : DecodesTo b x)
    (hy : DecodesTo b y) : x = y := by
  obtain ⟨P, hP, rfl⟩ := hx
  obtain ⟨Q, hQ, rfl⟩ := hy
  rw [hP, Option.some.injEq] at hQ
  rw [Subtype.ext hQ]

/-- Points indexed as the verifiers store them, `0` past the end. -/
@[expose]
public def ptsOf (l : List Dom) (j : ℕ) : Dom :=
  l.getD j 0

/-! ## Combined equations -/

@[expose] public section

/-- The verifiers' batched equation `Σₖ wᵏ Eₖ`. -/
noncomputable def comb [PrimeOrder] {n : ℕ} (w : ZMod ell) (E : Fin n → RGroup) : RGroup :=
  ∑ k : Fin n, w ^ k.val • E k

open Classical in
/-- The challenges `w` with `Σₖ wᵏ Eₖ = 0`. -/
noncomputable def badW [PrimeOrder] {n : ℕ} (E : Fin n → RGroup) : Finset (ZMod ell) :=
  Finset.univ.filter fun w => comb w E = 0

end

/-- If every `Eₖ` vanishes, so does `Σₖ wᵏ Eₖ`. -/
public theorem comb_eq_zero [PrimeOrder] {n : ℕ} (w : ZMod ell) {E : Fin n → RGroup}
    (h : ∀ k, E k = 0) : comb w E = 0 := by simp [comb, h]

/-- A vanishing batched equation: every `Eₖ` vanishes, or `w` is one of the `≤ n - 1` bad
challenges. -/
public theorem eq_zero_or_mem_badW [PrimeOrder] {n : ℕ} {w : ZMod ell} {E : Fin n → RGroup}
    (h : comb w E = 0) : (∀ k, E k = 0) ∨ w ∈ badW E := by
  classical
  by_cases hE : ∀ k, E k = 0
  · exact .inl hE
  · refine .inr ?_
    simp only [badW, Finset.mem_filter, Finset.mem_univ, true_and]
    convert h

/-- Not all `Eₖ` zero: at most `n - 1` challenges `w` give `Σₖ wᵏ Eₖ = 0`. -/
public theorem card_badW_le [PrimeOrder] {n : ℕ} (E : Fin n → RGroup) (h : ∃ k, E k ≠ 0) :
    (badW E).card ≤ n - 1 := by
  classical
  obtain ⟨k0, hk0⟩ := h
  obtain ⟨f, hf⟩ := Module.Projective.exists_dual_ne_zero (ZMod ell) hk0
  set q : Polynomial (ZMod ell) := ∑ k : Fin n, Polynomial.C (f (E k)) * Polynomial.X ^ (k : ℕ)
  have hcoeff : q.coeff k0 = f (E k0) := by
    simp only [q, Polynomial.finsetSum_coeff, Polynomial.coeff_C_mul_X_pow]
    rw [Finset.sum_eq_single k0
        (fun b _ hb => by
          simp only [ite_eq_right_iff]; exact fun e => absurd (Fin.ext e.symm) hb)
        (fun h => absurd (Finset.mem_univ _) h)]
    simp
  have hq0 : q ≠ 0 := fun h0 => hf (by rw [← hcoeff, h0, Polynomial.coeff_zero])
  have hdeg : q.natDegree ≤ n - 1 :=
    Polynomial.natDegree_sum_le_of_forall_le _ _ fun k _ =>
      (Polynomial.natDegree_C_mul_X_pow_le _ _).trans
        (by
          have := k.2; omega)
  have hsub : badW E ⊆ q.roots.toFinset := by
    intro w hw
    rw [badW, Finset.mem_filter] at hw
    rw [Multiset.mem_toFinset, Polynomial.mem_roots hq0, Polynomial.IsRoot.def]
    have : f (comb w E) = 0 := by rw [hw.2, map_zero]
    rw [comb, map_sum] at this
    simp only [map_smul, smul_eq_mul] at this
    simp only [q, Polynomial.eval_finsetSum, Polynomial.eval_mul, Polynomial.eval_C,
      Polynomial.eval_pow, Polynomial.eval_X]
    rw [← this]
    exact Finset.sum_congr rfl fun k _ => mul_comm _ _
  calc
    (badW E).card ≤ q.roots.toFinset.card := Finset.card_le_card hsub
    _ ≤ q.roots.card := Multiset.toFinset_card_le _
    _ ≤ q.natDegree := Polynomial.card_roots' q
    _ ≤ n - 1 := hdeg

end Ed25519.Ristretto

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

/-! ## Decompression -/

/-- A point `decompress` returns represents (with `Z = 1`) a point of `Dom` whose class is the one
`b` decodes to. -/
public theorem fd_ristretto255_point_decompress.some {b : BitVec 256} {A : PointLimbs}
    (h : fd_ristretto255_point_decompress b = some A) :
    ∃ P : Dom, (A.Rep P ∧ Limbs.val A.Z = 1) ∧ ∀ x, DecodesTo b x ↔ x = P := by
  obtain ⟨P, hd, hA, hZ⟩ := fd_ristretto255_point_frombytes.spec_rep h
  refine ⟨⟨P, decode_mem_Dom hd⟩, ⟨hA, hZ⟩, fun x => ⟨fun hx => ?_, fun hx => ⟨_, hd, hx.symm⟩⟩⟩
  exact (hx.unique ⟨_, hd, rfl⟩)

/-- Nothing decodes where `decompress` fails. -/
public theorem fd_ristretto255_point_decompress.none {b : BitVec 256}
    (h : fd_ristretto255_point_decompress b = none) (x : RGroup) : ¬DecodesTo b x := by
  rintro ⟨P, hP, -⟩
  rw [(fd_ristretto255_point_frombytes.spec_eq_none_iff b).1 h] at hP
  cases hP

/-- The zero encoding decodes to the identity class. -/
public theorem decodesTo_compressed_zero (x : RGroup) :
    DecodesTo fd_ristretto255_compressed_zero x ↔ x = 0 := by
  have h0 : fd_ristretto255_compressed_zero = 0#256 := by decide
  have hd : Ristretto.decode 0#256 = some ((0 : Dom) : Point) :=
    Ristretto.decode_eq_some.2 ⟨by decide, by decide, by simp [Canon]⟩
  rw [h0]
  exact
    ⟨fun hx => (hx.unique ⟨0, hd, rfl⟩).trans (QuotientAddGroup.mk_zero _), fun hx =>
      ⟨0, hd, hx ▸ (QuotientAddGroup.mk_zero _)⟩⟩

/-! ## Basepoints -/

/-- `fd_zksdk_basepoint_G` represents `G`, with `Z = 1`. -/
public theorem fd_zksdk_basepoint_G.rep :
    fd_zksdk_basepoint_G.Rep basePoint ∧ Limbs.val fd_zksdk_basepoint_G.Z = 1 := by
  have hZ : Limbs.val fd_zksdk_basepoint_G.Z = 1 := by decide +kernel
  refine ⟨⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_, ?_, ?_⟩, hZ⟩
  · rw [hZ]; exact one_ne_zero
  · rw [hZ, mul_one]; decide +kernel
  · rw [hZ, mul_one]; decide +kernel
  · rw [hZ, mul_one]; decide +kernel
  all_goals decide +kernel

/-- `fd_zksdk_basepoint_H` represents `H`, with `Z = 1` (its `X` limbs are uncarried). -/
public theorem fd_zksdk_basepoint_H.rep :
    fd_zksdk_basepoint_H.Rep Hpt ∧ Limbs.val fd_zksdk_basepoint_H.Z = 1 := by
  have hZ : Limbs.val fd_zksdk_basepoint_H.Z = 1 := by decide +kernel
  refine ⟨⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_, ?_, ?_⟩, hZ⟩
  · rw [hZ]; exact one_ne_zero
  · rw [hZ, mul_one]; decide +kernel
  · rw [hZ, mul_one]; decide +kernel
  · rw [hZ, mul_one]; decide +kernel
  all_goals decide +kernel

/-! ## The final check -/

/-- The verifiers' final check: `eq( MSM( s, pts ), Y )` is nonzero exactly when `Σ sⱼ Pⱼ = Q` in
the ristretto group, for canonical `sⱼ` and affine representatives. -/
public theorem msm_eq_iff [PrimeOrder] (s : ℕ → BitVec 256) (pts : ℕ → PointLimbs) (sz : BitVec 64)
    (P : ℕ → Dom) (hs : ∀ j < sz.toNat, (s j).toNat < ell)
    (hp : ∀ j < sz.toNat, (pts j).Rep (P j) ∧ Limbs.val (pts j).Z = 1) {Y : PointLimbs} {Q : Dom}
    (hY : Y.Rep Q) :
    fd_ristretto255_point_eq.spec (fd_ristretto255_multi_scalar_mul s pts sz) Y ≠ 0#32 ↔
      ∑ j ∈ Finset.range sz.toNat, sc (s j) • (P j : RGroup) = Q := by
  have hm := fd_ed25519_multi_scalar_mul.spec_rep s pts sz hp
  have e :
    ∑ j ∈ Finset.range sz.toNat, ((s j).toNat % 2 ^ 255) • ((P j : Dom) : Point) =
      ((∑ j ∈ Finset.range sz.toNat, (s j).toNat • P j : Dom) : Point) := by
    rw [AddSubgroup.val_finsetSum]
    refine Finset.sum_congr rfl fun j hj => ?_
    rw [AddSubgroup.coe_nsmul,
      Nat.mod_eq_of_lt
        ((hs j (Finset.mem_range.1 hj)).trans
          (by
            unfold ell; omega))]
  rw [e] at hm
  rw [fd_ristretto255_point_eq.spec_rep hm hY, ← mk_eq_mk_iff]
  have e2 :
    ((∑ j ∈ Finset.range sz.toNat, (s j).toNat • P j : Dom) : RGroup) =
      ∑ j ∈ Finset.range sz.toNat, sc (s j) • (P j : RGroup) := by
    rw [← QuotientAddGroup.mk'_apply, map_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [map_nsmul, QuotientAddGroup.mk'_apply, nsmul_eq_smul, sc]
  rw [e2]
  split_ifs with h
  · exact iff_of_true (by decide) h
  · exact iff_of_false (by decide) h

end MLIR.Firedancer.Ref

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto

/-! ## Scalar validation -/

/-- `validate` accepts a canonical scalar. -/
public theorem fd_curve25519_scalar_validate.eq_true {s : BitVec 256} (h : s.toNat < ell) :
    fd_curve25519_scalar_validate.spec s = true :=
  (fd_curve25519_scalar_validate.spec_iff s).2 h

/-- `validate` rejects a non-canonical scalar. -/
public theorem fd_curve25519_scalar_validate.eq_false {s : BitVec 256} (h : ¬s.toNat < ell) :
    fd_curve25519_scalar_validate.spec s = false := by
  rw [Bool.eq_false_iff, ne_eq, fd_curve25519_scalar_validate.spec_iff]; exact h

/-- `decompress_cases b with A P hA hP`: split on `fd_ristretto255_point_decompress b`, closing the
`none` case (the verifier rejects, nothing decodes); in the `some A` case `P : Dom` is the point,
`hA` its representation, `hP` that `b` decodes exactly to `P`'s class. -/
macro "decompress_cases " b:term " with " A:ident P:ident hA:ident hP:ident : tactic =>
  `(tactic|
    ( rcases hd : fd_ristretto255_point_decompress $b with _ | $A:ident
      · simp [fd_ristretto255_point_decompress.none hd]
      obtain ⟨$P:ident, $hA:ident, $hP:ident⟩ := fd_ristretto255_point_decompress.some hd
      dsimp only))

/-! ## Results -/

/-- A verifier's `return`ed code. -/
@[simp]
public theorem fd_zksdk_verify_result.pure_ret (x : fd_zksdk_verify_result) :
    (pure x : Id fd_zksdk_verify_result).ret = x.ret :=
  rfl

/-- The error code is not success. -/
@[simp]
public theorem FD_ZKSDK_VERIFY_PROOF_ERROR_ne :
    (FD_ZKSDK_VERIFY_PROOF_ERROR = FD_ZKSDK_VERIFY_PROOF_SUCCESS) = False := by decide

/-! ## Transcript validation -/

/-- `validate_and_append_point`'s status: `-1` exactly for the zero encoding. -/
public theorem fd_rangeproofs_transcript_validate_and_append_point.snd (t : fd_merlin_transcript_t)
    (l : List (BitVec 8)) (P : BitVec 256) :
    (fd_rangeproofs_transcript_validate_and_append_point t l P).2 =
      if P = fd_ristretto255_compressed_zero then FD_TRANSCRIPT_ERROR
      else FD_TRANSCRIPT_SUCCESS := by
  unfold fd_rangeproofs_transcript_validate_and_append_point
  split <;> rfl

/-- `validate_and_append_point` appends a nonzero encoding. -/
public theorem fd_rangeproofs_transcript_validate_and_append_point.fst (t : fd_merlin_transcript_t)
    (l : List (BitVec 8)) {P : BitVec 256} (h : P ≠ fd_ristretto255_compressed_zero) :
    (fd_rangeproofs_transcript_validate_and_append_point t l P).1 =
      fd_rangeproofs_transcript_append_point t l P := by
  unfold fd_rangeproofs_transcript_validate_and_append_point
  simp only [h, ↓reduceIte]

/-- A transcript challenge is canonical. -/
public theorem fd_rangeproofs_transcript_challenge_scalar.snd_lt (t : fd_merlin_transcript_t)
    (l : List (BitVec 8)) : (fd_rangeproofs_transcript_challenge_scalar t l).2.toNat < ell := by
  simp only [fd_rangeproofs_transcript_challenge_scalar, fd_curve25519_scalar_reduce.spec_val]
  exact
    Nat.mod_lt _
      (by
        unfold ell; omega)

/-- Or-ing a success status. -/
@[simp]
public theorem FD_TRANSCRIPT_SUCCESS_or (x : BitVec 32) : FD_TRANSCRIPT_SUCCESS ||| x = x := by
  simp [FD_TRANSCRIPT_SUCCESS]

/-- Or-ing an error status. -/
@[simp]
public theorem FD_TRANSCRIPT_ERROR_or (x : BitVec 32) :
    FD_TRANSCRIPT_ERROR ||| x = FD_TRANSCRIPT_ERROR := by
  simp only [FD_TRANSCRIPT_ERROR]; bv_decide

/-- The error status is not success. -/
@[simp]
public theorem FD_TRANSCRIPT_ERROR_ne : (FD_TRANSCRIPT_ERROR = FD_TRANSCRIPT_SUCCESS) = False := by
  decide

/-- A verifier's last step: success exactly when `Σ sⱼ Pⱼ = Q`. -/
public theorem ret_ite_msm [PrimeOrder] {s : ℕ → BitVec 256} {pts : ℕ → PointLimbs} {sz : BitVec 64}
    (P : ℕ → Dom) {Y : PointLimbs} {Q : Dom} (hs : ∀ j < sz.toNat, (s j).toNat < ell)
    (hp : ∀ j < sz.toNat, (pts j).Rep (P j) ∧ Limbs.val (pts j).Z = 1) (hY : Y.Rep Q)
    (t₁ t₂ : fd_merlin_transcript_t) :
    ((if fd_ristretto255_point_eq.spec (fd_ristretto255_multi_scalar_mul s pts sz) Y ≠ 0#32 then
              pure ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, t₁⟩
            else pure ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, t₂⟩ :
            Id fd_zksdk_verify_result).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) ↔
      ∑ j ∈ Finset.range sz.toNat, sc (s j) • (P j : RGroup) = Q := by
  rw [← msm_eq_iff s pts sz P hs hp hY]
  split_ifs with h <;> simp [h]

/-- `scalar_lt`: a scalar the verifiers pass to the MSM is canonical. -/
macro "scalar_lt" : tactic =>
  `(tactic|
    first
    | assumption
    | exact fd_curve25519_scalar_muladd.spec_lt _ _ _
    | exact fd_curve25519_scalar_mul.spec_lt _ _
    | exact fd_curve25519_scalar_add.spec_lt _ _
    | exact fd_curve25519_scalar_sub.spec_lt _ _
    | exact fd_curve25519_scalar_neg.spec_lt _)

/-- `point_rep`: a point the verifiers pass to the MSM is an affine representative. -/
macro "point_rep" : tactic =>
  `(tactic|
    first
    | assumption
    | exact fd_zksdk_basepoint_G.rep
    | exact fd_zksdk_basepoint_H.rep
    | exact ⟨fd_zksdk_basepoint_G.rep.1, trivial⟩
    | exact ⟨fd_zksdk_basepoint_H.rep.1, trivial⟩)

/-- `store_simp`: evaluate `store` chains and `ptsOf` lists at literal indices. -/
macro "store_simp" : tactic =>
  `(tactic|
    simp (config := { decide := true }) only [MLIR.Firedancer.Ref.fd_zksdk.store,
      _root_.Ed25519.Ristretto.ptsOf, fd_ristretto255_point_set, fd_curve25519_scalar_set.spec_eq,
      ↓reduceIte, List.getD_cons_zero, List.getD_cons_succ])

/-- `msm_sides n`: close `ret_ite_msm`'s side goals for an `n`-term MSM. -/
macro "msm_sides " n:num : tactic =>
  `(tactic|
    ( · intro j hj
        have : j < $n := hj
        interval_cases j <;> store_simp <;> scalar_lt
      · intro j hj
        have : j < $n := hj
        interval_cases j <;> store_simp <;> point_rep))

/-- `msm_sum_simp`: expand `ret_ite_msm`'s sum over its literal range into scalar-times-class
terms. -/
macro "msm_sum_simp" : tactic =>
  `(tactic|
    simp (config := { decide := true }) only [BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod,
      Finset.sum_range_succ, Finset.sum_range_zero, zero_add, MLIR.Firedancer.Ref.fd_zksdk.store,
      _root_.Ed25519.Ristretto.ptsOf, ↓reduceIte, List.getD_cons_zero, List.getD_cons_succ,
      _root_.Ed25519.Ristretto.mk_basePoint, _root_.Ed25519.Ristretto.mk_Hpt,
      fd_curve25519_scalar_muladd.spec_sc, fd_curve25519_scalar_mul.spec_sc,
      fd_curve25519_scalar_add.spec_sc, fd_curve25519_scalar_sub.spec_sc,
      fd_curve25519_scalar_neg.spec_sc, fd_curve25519_scalar_from_u64.spec_sc,
      fd_curve25519_scalar_set.spec_eq])

end MLIR.Firedancer.Ref

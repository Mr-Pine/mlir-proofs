module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_percentage_with_cap
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! `fd_zksdk_verify_proof_percentage_with_cap` against zk-sdk's percentage-with-cap proof
(`sigma_proofs/percentage_with_cap.rs`), an OR of a max proof (challenge `c_max`) and an equality
proof (challenge `c - c_max`). The C batches the equations as `E_max - w E_δ - w² E_cl`, zk-sdk as
its negation. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_percentage_with_cap.challenges
    (proof : fd_zksdk_percentage_with_cap_proof_t)
    (percentage_commitment delta_commitment claimed_commitment : BitVec 256) (max_value : BitVec 64)
    (transcript : fd_merlin_transcript_t) : BitVec 256 × BitVec 256 :=
  let transcript :=
    percentage_with_cap_hash_context transcript percentage_commitment delta_commitment
      claimed_commitment max_value
  let transcript := fd_zksdk_transcript_domsep_percentage_with_cap_proof transcript
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_max_proof")
      proof.percentage_max_proof.y_max
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_delta")
      proof.percentage_equality_proof.y_delta
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_claimed")
      proof.percentage_equality_proof.y_claimed
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript :=
    fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z_max")
      proof.percentage_max_proof.z_max
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "c_max_proof")
      proof.percentage_max_proof.c_max
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x")
      proof.percentage_equality_proof.z_x
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_delta_real")
      proof.percentage_equality_proof.z_delta
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_claimed")
      proof.percentage_equality_proof.z_claimed
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

/-- zk-sdk's equations, each as `lhs - rhs`, with `c_eq = c - c_max`:
`z_max H = c_max (C_pct - m G) + Y_max`, `z_x G + z_δ H = c_eq C_δ + Y_δ`,
`z_x G + z_cl H = c_eq C_cl + Y_cl`. -/
noncomputable def PercentageWithCap.eqns [PrimeOrder] (z_max c_max z_x z_δ z_cl c m : ZMod ell)
    (C_pct C_δ C_cl Y_max Y_δ Y_cl : RGroup) : Fin 3 → RGroup :=
  ![z_max • H - c_max • (C_pct - m • G) - Y_max, z_x • G + z_δ • H - (c - c_max) • C_δ - Y_δ,
    z_x • G + z_cl • H - (c - c_max) • C_cl - Y_cl]

/-- The C's batching coefficients: `E_max, -E_δ, -E_cl`. -/
noncomputable def PercentageWithCap.signed [PrimeOrder] (E : Fin 3 → RGroup) : Fin 3 → RGroup :=
  ![E 0, -E 1, -E 2]

end

/-- The verifier accepts exactly when the commitments and `Y`s are not the zero encoding, the five
scalars are canonical, everything decodes, and `E_max - w E_δ - w² E_cl = 0` for zk-sdk's equations,
`m = max_value` and the transcript's `c`, `w`. -/
public theorem fd_zksdk_verify_proof_percentage_with_cap.ret_eq_success_iff [PrimeOrder]
    (proof : fd_zksdk_percentage_with_cap_proof_t)
    (percentage_commitment delta_commitment claimed_commitment : BitVec 256) (max_value : BitVec 64)
    (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_percentage_with_cap proof percentage_commitment delta_commitment
            claimed_commitment max_value transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      percentage_commitment ≠ fd_ristretto255_compressed_zero ∧
        delta_commitment ≠ fd_ristretto255_compressed_zero ∧
          claimed_commitment ≠ fd_ristretto255_compressed_zero ∧
            proof.percentage_max_proof.y_max ≠ fd_ristretto255_compressed_zero ∧
              proof.percentage_equality_proof.y_delta ≠ fd_ristretto255_compressed_zero ∧
                proof.percentage_equality_proof.y_claimed ≠ fd_ristretto255_compressed_zero ∧
                  proof.percentage_max_proof.z_max.toNat < ell ∧
                    proof.percentage_max_proof.c_max.toNat < ell ∧
                      proof.percentage_equality_proof.z_x.toNat < ell ∧
                        proof.percentage_equality_proof.z_delta.toNat < ell ∧
                          proof.percentage_equality_proof.z_claimed.toNat < ell ∧
                            ∃ C_pct C_δ C_cl Y_max Y_δ Y_cl,
                              DecodesTo percentage_commitment C_pct ∧
                                DecodesTo delta_commitment C_δ ∧
                                  DecodesTo claimed_commitment C_cl ∧
                                    DecodesTo proof.percentage_max_proof.y_max Y_max ∧
                                      DecodesTo proof.percentage_equality_proof.y_delta Y_δ ∧
                                        DecodesTo proof.percentage_equality_proof.y_claimed Y_cl ∧
                                          let cw :=
                                            fd_zksdk_verify_proof_percentage_with_cap.challenges
                                              proof percentage_commitment delta_commitment
                                              claimed_commitment max_value transcript
                                          comb (sc cw.2)
                                              (PercentageWithCap.signed
                                                (PercentageWithCap.eqns
                                                  (sc proof.percentage_max_proof.z_max)
                                                  (sc proof.percentage_max_proof.c_max)
                                                  (sc proof.percentage_equality_proof.z_x)
                                                  (sc proof.percentage_equality_proof.z_delta)
                                                  (sc proof.percentage_equality_proof.z_claimed)
                                                  (sc cw.1) (max_value.toNat : ZMod ell) C_pct C_δ
                                                  C_cl Y_max Y_δ Y_cl)) =
                                            0 := by
  unfold fd_zksdk_verify_proof_percentage_with_cap
  simp only [Id.run]
  by_cases hz :
    percentage_commitment = fd_ristretto255_compressed_zero ∨
      delta_commitment = fd_ristretto255_compressed_zero ∨
      claimed_commitment = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, -⟩
    rcases hz with h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  obtain ⟨hz1, hz2, hz3⟩ := hz
  by_cases s1 : proof.percentage_max_proof.z_max.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_false s1, s1]
  by_cases s2 : proof.percentage_max_proof.c_max.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true s1, fd_curve25519_scalar_validate.eq_false s2, s2]
  by_cases s3 : proof.percentage_equality_proof.z_x.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true s1, fd_curve25519_scalar_validate.eq_true s2,
      fd_curve25519_scalar_validate.eq_false s3, s3]
  by_cases s4 : proof.percentage_equality_proof.z_delta.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true s1, fd_curve25519_scalar_validate.eq_true s2,
      fd_curve25519_scalar_validate.eq_true s3, fd_curve25519_scalar_validate.eq_false s4, s4]
  by_cases s5 : proof.percentage_equality_proof.z_claimed.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true s1, fd_curve25519_scalar_validate.eq_true s2,
      fd_curve25519_scalar_validate.eq_true s3, fd_curve25519_scalar_validate.eq_true s4,
      fd_curve25519_scalar_validate.eq_false s5, s5]
  simp only [fd_curve25519_scalar_validate.eq_true s1, fd_curve25519_scalar_validate.eq_true s2,
    fd_curve25519_scalar_validate.eq_true s3, fd_curve25519_scalar_validate.eq_true s4,
    fd_curve25519_scalar_validate.eq_true s5, Bool.not_true, Bool.false_eq_true, ↓reduceIte]
  decompress_cases percentage_commitment with A₀ C_pct hA₀ hC_pct
  decompress_cases proof.percentage_equality_proof.y_delta with A₁ Y_δ hA₁ hY_δ
  decompress_cases delta_commitment with A₂ C_δ hA₂ hC_δ
  decompress_cases proof.percentage_equality_proof.y_claimed with A₃ Y_cl hA₃ hY_cl
  decompress_cases claimed_commitment with A₄ C_cl hA₄ hC_cl
  decompress_cases proof.percentage_max_proof.y_max with A₅ Y_max hA₅ hY_max
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.percentage_max_proof.y_max = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.percentage_equality_proof.y_delta = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  by_cases hy2 : proof.percentage_equality_proof.y_claimed = fd_ristretto255_compressed_zero
  · simp [hy0, hy1, hy2]
  simp only [hy0, hy1, hy2, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy2]
  have hwlt := fd_rangeproofs_transcript_challenge_scalar.snd_lt
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hw : w.toNat < ell := hwd ▸ hwlt _ _
  have hcw :
    fd_zksdk_verify_proof_percentage_with_cap.challenges proof percentage_commitment
        delta_commitment claimed_commitment max_value transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, C_pct, Y_δ, C_δ, Y_cl, C_cl]) ?_
      ?_ hA₅.1]
  rotate_left
  msm_sides 7
  msm_sum_simp
  simp only [ne_eq, hz1, hz2, hz3, hy0, hy1, hy2, not_false_eq_true, s1, s2, s3, s4, s5, true_and,
    hC_pct, hC_δ, hC_cl, hY_max, hY_δ, hY_cl, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_three, PercentageWithCap.signed, PercentageWithCap.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- zk-sdk's batching `-E_max + w E_δ + w² E_cl` is the negation of the C's: they accept the same
proofs. -/
public theorem PercentageWithCap.comb_rust [PrimeOrder] (w : ZMod ell) (E : Fin 3 → RGroup) :
    -E 0 + w • E 1 + w ^ 2 • E 2 = -comb w (PercentageWithCap.signed E) := by
  simp only [comb, Fin.sum_univ_three, PercentageWithCap.signed]
  simp
  module

/-- Completeness: if zk-sdk's three equations hold for the transcript's `c` (and the encodings
decode and pass the zero checks, the scalars canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_percentage_with_cap.complete [PrimeOrder]
    {proof : fd_zksdk_percentage_with_cap_proof_t}
    {percentage_commitment delta_commitment claimed_commitment : BitVec 256} {max_value : BitVec 64}
    {transcript : fd_merlin_transcript_t} {C_pct C_δ C_cl Y_max Y_δ Y_cl : RGroup}
    (hz :
      percentage_commitment ≠ fd_ristretto255_compressed_zero ∧
        delta_commitment ≠ fd_ristretto255_compressed_zero ∧
        claimed_commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.percentage_max_proof.y_max ≠ fd_ristretto255_compressed_zero ∧
        proof.percentage_equality_proof.y_delta ≠ fd_ristretto255_compressed_zero ∧
        proof.percentage_equality_proof.y_claimed ≠ fd_ristretto255_compressed_zero)
    (hs :
      proof.percentage_max_proof.z_max.toNat < ell ∧
        proof.percentage_max_proof.c_max.toNat < ell ∧
        proof.percentage_equality_proof.z_x.toNat < ell ∧
        proof.percentage_equality_proof.z_delta.toNat < ell ∧
        proof.percentage_equality_proof.z_claimed.toNat < ell)
    (hd :
      DecodesTo percentage_commitment C_pct ∧
        DecodesTo delta_commitment C_δ ∧
        DecodesTo claimed_commitment C_cl ∧
        DecodesTo proof.percentage_max_proof.y_max Y_max ∧
        DecodesTo proof.percentage_equality_proof.y_delta Y_δ ∧
        DecodesTo proof.percentage_equality_proof.y_claimed Y_cl)
    (hE :
      ∀ k,
        PercentageWithCap.eqns (sc proof.percentage_max_proof.z_max)
            (sc proof.percentage_max_proof.c_max) (sc proof.percentage_equality_proof.z_x)
            (sc proof.percentage_equality_proof.z_delta)
            (sc proof.percentage_equality_proof.z_claimed)
            (sc
              (fd_zksdk_verify_proof_percentage_with_cap.challenges proof percentage_commitment
                  delta_commitment claimed_commitment max_value transcript).1)
            (max_value.toNat : ZMod ell) C_pct C_δ C_cl Y_max Y_δ Y_cl k =
          0) :
    (fd_zksdk_verify_proof_percentage_with_cap proof percentage_commitment delta_commitment
          claimed_commitment max_value transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4, z5, z6⟩ := hz
  obtain ⟨s1, s2, s3, s4, s5⟩ := hs
  obtain ⟨d1, d2, d3, d4, d5, d6⟩ := hd
  refine
    (fd_zksdk_verify_proof_percentage_with_cap.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, z6, s1, s2, s3, s4, s5, C_pct, C_δ, C_cl, Y_max, Y_δ, Y_cl, d1, d2, d3,
        d4, d5, d6, comb_eq_zero _ fun k => ?_⟩
  fin_cases k <;> simp [PercentageWithCap.signed, hE]

/-- Soundness: if the verifier accepts, zk-sdk's three equations hold for the transcript's `c`, or
the transcript's `w` is one of the at most two roots of `E_max - E_δ X - E_cl X²`
(`card_badW_le`). -/
public theorem fd_zksdk_verify_proof_percentage_with_cap.sound [PrimeOrder]
    {proof : fd_zksdk_percentage_with_cap_proof_t}
    {percentage_commitment delta_commitment claimed_commitment : BitVec 256} {max_value : BitVec 64}
    {transcript : fd_merlin_transcript_t} {C_pct C_δ C_cl Y_max Y_δ Y_cl : RGroup}
    (hd :
      DecodesTo percentage_commitment C_pct ∧
        DecodesTo delta_commitment C_δ ∧
        DecodesTo claimed_commitment C_cl ∧
        DecodesTo proof.percentage_max_proof.y_max Y_max ∧
        DecodesTo proof.percentage_equality_proof.y_delta Y_δ ∧
        DecodesTo proof.percentage_equality_proof.y_claimed Y_cl)
    (h :
      (fd_zksdk_verify_proof_percentage_with_cap proof percentage_commitment delta_commitment
            claimed_commitment max_value transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_percentage_with_cap.challenges proof percentage_commitment
        delta_commitment claimed_commitment max_value transcript
    let E :=
      PercentageWithCap.eqns (sc proof.percentage_max_proof.z_max)
        (sc proof.percentage_max_proof.c_max) (sc proof.percentage_equality_proof.z_x)
        (sc proof.percentage_equality_proof.z_delta) (sc proof.percentage_equality_proof.z_claimed)
        (sc cw.1) (max_value.toNat : ZMod ell) C_pct C_δ C_cl Y_max Y_δ Y_cl
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW (PercentageWithCap.signed E) := by
  obtain ⟨d1, d2, d3, d4, d5, d6⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, -, -, -, -, C_pct', C_δ', C_cl', Y_max', Y_δ', Y_cl', e1, e2, e3, e4, e5,
      e6, hc⟩ :=
    (fd_zksdk_verify_proof_percentage_with_cap.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6] at hc
  rcases eq_zero_or_mem_badW hc with h0 | h0
  · refine .inl fun k => ?_
    have := h0 k
    fin_cases k <;> simpa [PercentageWithCap.signed] using this
  · exact .inr h0

end MLIR.Firedancer.Ref

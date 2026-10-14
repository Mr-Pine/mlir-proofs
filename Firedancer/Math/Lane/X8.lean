module

public import Firedancer.Lane.Common.X8
public import Firedancer.Math.Lane.Verify
public import Firedancer.Math.Lane.Decode
public import Firedancer.Math.Scalar
public import Ed25519.Firedancer
import Mathlib.Tactic.Abel

/-! `verify_x8`'s result for item `j` is `Ed25519.Firedancer.verify`'s, the return code of
`fd_ed25519_verify`, whatever the other lanes hold. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d sqrtM1 y8 basePoint decode bytesLE)
open Firedancer.Ref (fd_curve25519_scalar_validate.spec fd_curve25519_scalar_reduce.spec
  fd_curve25519_scalar_validate.spec_iff fd_curve25519_scalar_reduce.spec_val)

/-! ## Definitions -/

@[expose] public section

/-- The constants' meaning: broadcast `d`, `√-1`, `2d`, `y8`, `-y8`, canonical limbs; the base
table of `[e]B`. -/
structure Consts.Ok (C : Consts) : Prop where
  d : ∀ j, C.d.val j = Ed25519.d
  dB : C.d.Carried
  sqrtm1 : ∀ j, C.sqrtm1.val j = sqrtM1
  sqrtm1B : C.sqrtm1.Carried
  k2d : ∀ j, C.k2d.val j = 2 * Ed25519.d
  k2dB : C.k2d.F52
  y0 : ∀ j, C.y0.val j = y8
  y0B : C.y0.Carried
  y1 : ∀ j, C.y1.val j = -y8
  y1B : C.y1.Carried
  tbl : BaseOk C.tbl

end

/-! ## Lanes -/

/-- A lane in extended coordinates with `z = 1` holds the point's affine coordinates. -/
theorem Point.Ext.affine {P : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Ext j Q)
    (hz : P.z = Fe.one) : P.x.val j = Q.x ∧ P.y.val j = Q.y := by
  obtain ⟨-, hx, hy, -⟩ := h
  rw [hz, Fe.one_val, mul_one] at hx hy
  exact ⟨hx, hy⟩

/-- `-A` from `A`: `x` and `t` subtracted from zero. -/
theorem Point.Ext.negXT {P : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Ext j Q)
    (hx : P.x.F52) (ht : P.t.F52) :
    (⟨sub Fe.zero P.x, P.y, P.z, sub Fe.zero P.t⟩ : Point).Ext j (-Q) := by
  have := h.neg
  unfold Point.Ext
  rw [sub_val Fe.zero_carried.f52 hx, sub_val Fe.zero_carried.f52 ht, Fe.zero_val, zero_sub,
    zero_sub, Ed25519.Point.neg_x, Ed25519.Point.neg_y]
  exact this

/-! ## The result -/

/-- Item `j < cnt` of `verify_x8`, with `H j` the digest of `R j ‖ A j ‖ msg`, returns what
`fd_ed25519_verify` returns for it. -/
public theorem x8_result {C : Consts} (hC : C.Ok) {cnt : ℕ} {R S A : Fin 8 → BitVec 256}
    {H : Fin 8 → BitVec 512} {j : Fin 8} (hj : j.val < cnt) {msg : List (BitVec 8)}
    (hH : bytesLE (H j) = Ed25519.Sha512.digest (bytesLE (R j) ++ bytesLE (A j) ++ msg)) :
    (x8 C cnt R S A H).result j = Ed25519.Firedancer.verify msg (R j) (S j) (A j) := by
  have hval := fd_curve25519_scalar_validate.spec_iff (S j)
  obtain ⟨hAv, hAe, hAn⟩ := decFin_decode hC.d hC.dB hC.sqrtm1 hC.sqrtm1B (x8Buf cnt S A) j
  obtain ⟨hAxb, hAyb, hAz, hAtb, -⟩ :=
    decFin_bounded (sqrtm1 := C.sqrtm1) hC.dB hC.sqrtm1B (x8Buf cnt S A)
  obtain ⟨hRv, hRe, hRn⟩ := decFin_decode hC.d hC.dB hC.sqrtm1 hC.sqrtm1B (x8Buf cnt S R) j
  obtain ⟨hRxb, hRyb, hRz, -, -⟩ :=
    decFin_bounded (sqrtm1 := C.sqrtm1) hC.dB hC.sqrtm1B (x8Buf cnt S R)
  -- restated over `x8Dec`, which stays folded
  change (x8Dec C cnt S A).2.getLsbD j = _ at hAv
  change ∀ P, _ → (x8Dec C cnt S A).1.Ext j P at hAe
  change (x8Dec C cnt S A).1.x.F52 at hAxb
  change (x8Dec C cnt S A).1.y.Carried at hAyb
  change (x8Dec C cnt S A).1.z = Fe.one at hAz
  change (x8Dec C cnt S A).1.t.Carried at hAtb
  change (x8Dec C cnt S R).2.getLsbD j = _ at hRv
  change ∀ P, _ → (x8Dec C cnt S R).1.Ext j P at hRe
  change (x8Dec C cnt S R).1.x.F52 at hRxb
  change (x8Dec C cnt S R).1.y.Carried at hRyb
  change (x8Dec C cnt S R).1.z = Fe.one at hRz
  clear hAn hRn
  unfold X8.result x8
  dsimp only
  unfold Ed25519.Firedancer.verify
  by_cases hS : Ed25519.ell ≤ (S j).toNat
  · have hc : fd_curve25519_scalar_validate.spec (S j) = false := by
      cases h : fd_curve25519_scalar_validate.spec (S j)
      · rfl
      · exact absurd (hval.1 h) (Nat.not_lt.2 hS)
    simp only [x8Cand, hc, Bool.and_false, Bool.not_false, ite_true, hS]
  have hc : fd_curve25519_scalar_validate.spec (S j) = true := hval.2 (Nat.lt_of_not_le hS)
  have hcand : x8Cand cnt S j = true := by simp [x8Cand, hj, hc]
  have hAj : x8Buf cnt S A j = A j := by simp only [x8Buf, hcand, ite_true]
  have hRj : x8Buf cnt S R j = R j := by simp only [x8Buf, hcand, ite_true]
  rw [hAj] at hAv hAe
  rw [hRj] at hRv hRe
  simp only [hcand, hS, Bool.not_true, Bool.false_eq_true, ite_false]
  rcases hdA : decode (A j) with _ | PA
  · simp only [hdA, Option.isSome_none] at hAv
    simp only [hAv, Bool.not_false, ite_true]
  rcases hdR : decode (R j) with _ | PR
  · simp only [hdA, Option.isSome_some] at hAv
    simp only [hdR, Option.isSome_none] at hRv
    simp only [hAv, hRv, Bool.not_true, Bool.not_false, Bool.false_eq_true, ite_false, ite_true]
  simp only [hdA, Option.isSome_some] at hAv
  simp only [hdR, Option.isSome_some] at hRv
  have hA := hAe PA hdA
  have hR := hRe PR hdR
  obtain ⟨hAx, hAy⟩ := hA.affine hAz
  obtain ⟨hRx, hRy⟩ := hR.affine hRz
  have hsA := smallOrder_getLsbD hC.y0 hC.y1 hC.y0B hC.y1B hAx hAy hAxb hAyb
  have hsR := smallOrder_getLsbD hC.y0 hC.y1 hC.y0B hC.y1B hRx hRy hRxb hRyb
  simp only [hAv, hRv, hsA, hsR, Bool.not_true, Bool.false_eq_true, ite_false]
  by_cases h8A : 8 • PA = 0
  · simp only [h8A, decide_true, ite_true]
  by_cases h8R : 8 • PR = 0
  · simp only [h8A, h8R, decide_true, decide_false, Bool.false_eq_true, ite_true, ite_false]
  simp only [h8A, h8R, decide_false, Bool.false_eq_true, ite_false]
  -- the equation, on `-A`
  have hab : (⟨sub Fe.zero (x8Dec C cnt S A).1.x, (x8Dec C cnt S A).1.y, (x8Dec C cnt S A).1.z,
      sub Fe.zero (x8Dec C cnt S A).1.t⟩ : Point).Carried :=
    ⟨⟨carry_carried _, hAyb, hAz ▸ Fe.one_carried⟩, carry_carried _⟩
  rw [verify_getLsbD (hC.k2d j) hC.k2dB hC.tbl (hA.negXT hAxb hAtb.f52) hAz hab hRx hRy
    ⟨hRxb, hRyb.f52⟩ ?hk ?hs]
  case hk | hs =>
    simp only [hcand, hAv, hRv, hsA, hsR, h8A, h8R, decide_false, Bool.not_false, Bool.and_self,
      ite_true]
    first
    | exact (fd_curve25519_scalar_reduce.spec_val _).trans_lt
        ((Nat.mod_lt _ (by unfold Ed25519.ell; decide)).trans Ed25519.ell_lt)
    | exact (Nat.lt_of_not_le hS).trans Ed25519.ell_lt
  simp only [hcand, hAv, hRv, hsA, hsR, h8A, h8R, decide_false, Bool.not_false, Bool.and_self,
    ite_true]
  have hk : (fd_curve25519_scalar_reduce.spec (H j)).toNat =
      Ed25519.natLE (Ed25519.Sha512.digest (bytesLE (R j) ++ bytesLE (A j) ++ msg)) %
        Ed25519.ell := by
    rw [fd_curve25519_scalar_reduce.spec_val, ← hH, Ed25519.natLE_bytesLE (n := 64)]
  rw [hk]
  generalize Ed25519.natLE (Ed25519.Sha512.digest (bytesLE (R j) ++ bytesLE (A j) ++ msg)) %
    Ed25519.ell = n
  have key : n • -PA + (S j).toNat • basePoint = PR ↔ (S j).toNat • basePoint = PR + n • PA := by
    rw [smul_neg]
    constructor <;> intro h
    · rw [← h]; abel
    · rw [h]; abel
  by_cases hq : (S j).toNat • basePoint = PR + n • PA
  · rw [ite_eq_left (decide_eq_true (key.2 hq)), ite_eq_left hq]
  · rw [ite_eq_right (by simpa using mt key.1 hq), ite_eq_right hq]

end MLIR.Firedancer.Lane

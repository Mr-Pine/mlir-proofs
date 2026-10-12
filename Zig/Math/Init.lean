module

public import Zig.Verifier_init
public import Zig.Math.Verify
public import Zig.Math.Decode
public import Zig.Math.PointDbl

/-! `Verifier.init`'s error code is `verify`'s rejection before hashing: `-code` when nonzero. -/

namespace MLIR.Zig

open _root_.Ed25519

/-- A failed `init`: `verify` rejects with `-code`. -/
public theorem Verifier.init.verify_of_code_ne (msg : List (BitVec 8)) {r S A : BitVec 256}
    (hc : Verifier.init.code r S A ≠ 0#16) :
    verify msg r S A = -(Verifier.init.code r S A).setWidth 32 := by
  unfold Verifier.init.code at hc ⊢
  unfold verify
  rw [scalar.rejectNonCanonical.spec_eq] at hc ⊢
  by_cases hS : S.toNat < ell
  swap
  · simp [hS]
  simp only [hS, ite_true, ne_eq, not_true_eq_false, ite_false,
    show ¬ell ≤ S.toNat by omega] at hc ⊢
  rcases hA : Edwards25519.fromBytes.spec A with _ | a
  · rw [(Decode.fromBytes_eq_none A).1 hA]
    rfl
  obtain ⟨PA, hPA, hext, -, hlt⟩ := Decode.fromBytes_eq_some hA
  rw [hPA]
  rw [hA] at hc
  simp only at hc ⊢
  rw [Edwards25519.rejectIdentity.spec_eq hext (hlt.1.mono (by decide))] at hc ⊢
  by_cases hx : PA.x = 0
  · simp [hx]
  simp only [hx, ite_false, not_true_eq_false] at hc ⊢
  rw [Fe.rejectNonCanonical.spec] at hc ⊢
  by_cases hr : r.toNat % 2 ^ 255 < 2 ^ 255 - 19
  swap
  · have : p ≤ r.toNat % 2 ^ 255 := by
      simp only [p]; omega
    simp only [hr, this, ite_true, ite_false]
    rfl
  have : ¬p ≤ r.toNat % 2 ^ 255 := by
    simp only [p]; omega
  simp only [hr, this, ite_true, ite_false, not_true_eq_false] at hc ⊢
  rcases hR : Edwards25519.fromBytes.spec r with _ | R
  · rw [(Decode.fromBytes_eq_none r).1 hR]
    rfl
  obtain ⟨PR, hPR, hextR, -, hltR⟩ := Decode.fromBytes_eq_some hR
  rw [hPR]
  rw [hR] at hc
  simp only at hc ⊢
  rw [Edwards25519.rejectIdentity.spec_eq hextR (hltR.1.mono (by decide))] at hc ⊢
  by_cases hxR : PR.x = 0
  · simp [hxR]
  · simp [hxR] at hc

/-- A successful `init`: `verify`'s checks before hashing pass, its points those `fromBytes` gives,
with `z = 1` and limbs below `2^52`. -/
public theorem Verifier.init.checks_of_code_eq {r S A : BitVec 256}
    (hc : Verifier.init.code r S A = 0#16) :
    S.toNat < ell ∧
      ¬p ≤ r.toNat % 2 ^ 255 ∧
      ∃ a R PA PR,
        Edwards25519.fromBytes.spec A = some a ∧
          Edwards25519.fromBytes.spec r = some R ∧
          decode A = some PA ∧
          decode r = some PR ∧
          a.Ext PA.x PA.y ∧
          R.Ext PR.x PR.y ∧
          Limbs.val a.z = 1 ∧
          Limbs.val R.z = 1 ∧ a.Lt (2 ^ 52) ∧ R.Lt (2 ^ 52) ∧ PA.x ≠ 0 ∧ PR.x ≠ 0 := by
  unfold Verifier.init.code at hc
  rw [scalar.rejectNonCanonical.spec_eq] at hc
  by_cases hS : S.toNat < ell
  swap
  · simp [hS] at hc
  simp only [hS, ite_true, ne_eq, not_true_eq_false, ite_false] at hc
  rcases hA : Edwards25519.fromBytes.spec A with _ | a
  · rw [hA] at hc
    simp at hc
  obtain ⟨PA, hPA, hext, hz, hlt⟩ := Decode.fromBytes_eq_some hA
  rw [hA] at hc
  simp only at hc
  rw [Edwards25519.rejectIdentity.spec_eq hext (hlt.1.mono (by decide))] at hc
  by_cases hx : PA.x = 0
  · simp [hx] at hc
  simp only [hx, ite_false, not_true_eq_false] at hc
  rw [Fe.rejectNonCanonical.spec] at hc
  by_cases hr : r.toNat % 2 ^ 255 < 2 ^ 255 - 19
  swap
  · simp only [hr, ite_false, BitVec.reduceEq, not_false_eq_true, ite_true] at hc
  simp only [hr, ite_true, not_true_eq_false, ite_false] at hc
  rcases hR : Edwards25519.fromBytes.spec r with _ | R
  · rw [hR] at hc
    simp at hc
  obtain ⟨PR, hPR, hextR, hzR, hltR⟩ := Decode.fromBytes_eq_some hR
  rw [hR] at hc
  simp only at hc
  rw [Edwards25519.rejectIdentity.spec_eq hextR (hltR.1.mono (by decide))] at hc
  by_cases hxR : PR.x = 0
  · simp [hxR] at hc
  exact
    ⟨hS, by
      simp only [p]; omega, a, R, PA, PR, rfl, rfl, hPA, hPR, hext, hextR, hz, hzR, hlt, hltR, hx,
      hxR⟩

end MLIR.Zig

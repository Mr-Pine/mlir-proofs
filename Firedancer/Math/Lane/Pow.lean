module

public import Firedancer.Math.Lane.Mul

/-! `fd_ed25519_lane_pow22523_2`'s chain in `ZMod p`: each lane to the power `(p - 5) / 8`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p)

/-- `Q` is f52, each lane `A`'s to the power `e`. -/
def IsPow (Q A : Fe) (e : ℕ) : Prop :=
  Q.F52 ∧ ∀ j, Q.val j = A.val j ^ e

theorem IsPow.self {A : Fe} (h : A.F52) : IsPow A A 1 :=
  ⟨h, fun _ => (pow_one _).symm⟩

theorem IsPow.sqr {Q A : Fe} (h : IsPow Q A e) : IsPow (sqr Q) A (e * 2) :=
  ⟨(sqr_carried h.1).f52, fun j => by rw [sqr_val h.1, h.2 j, pow_mul]⟩

theorem IsPow.mul {Q R A : Fe} (h : IsPow Q A e) (h' : IsPow R A f) :
    IsPow (mul Q R) A (e + f) :=
  ⟨(mul_carried h.1 h'.1).f52, fun j => by rw [mul_val h.1 h'.1, h.2 j, h'.2 j, pow_add]⟩

theorem IsPow.sqrN {Q A : Fe} (h : IsPow Q A e) : IsPow (Lane.sqrN n Q) A (e * 2 ^ n) := by
  induction n with
  | zero => simpa [Lane.sqrN] using h
  | succ n ih =>
    rw [Lane.sqrN, pow_succ, ← mul_assoc]
    exact ih.sqr

/-- The chain's powers; the last product is carried. -/
theorem pow22523_isPow {A : Fe} (hA : A.F52) :
    IsPow (pow22523 A) A ((p - 5) / 8) ∧ (pow22523 A).Carried := by
  have h0 := IsPow.self hA
  have h1 := h0.sqr
  have h2 := h1.sqrN (n := 2)
  have h3 := h0.mul h2
  have h4 := h1.mul h3
  have h5 := h4.sqr
  have h6 := h3.mul h5
  have h7 := h6.sqrN (n := 5)
  have h8 := h7.mul h6
  have h9 := h8.sqrN (n := 10)
  have h10 := h9.mul h8
  have h11 := h10.sqrN (n := 20)
  have h12 := h11.mul h10
  have h13 := h12.sqrN (n := 10)
  have h14 := h13.mul h8
  have h15 := h14.sqrN (n := 50)
  have h16 := h15.mul h14
  have h17 := h16.sqrN (n := 100)
  have h18 := h17.mul h16
  have h19 := h18.sqrN (n := 50)
  have h20 := h19.mul h14
  have h21 := h20.sqrN (n := 2)
  have h22 := h21.mul h0
  have hc := mul_carried h21.1 hA
  exact ⟨h22, hc⟩

public theorem pow22523_val {a : Fe} (ha : a.F52) (j : Fin 8) :
    (pow22523 a).val j = a.val j ^ ((p - 5) / 8) :=
  (pow22523_isPow ha).1.2 j

public theorem pow22523_carried {a : Fe} (ha : a.F52) : (pow22523 a).Carried :=
  (pow22523_isPow ha).2

end MLIR.Firedancer.Lane

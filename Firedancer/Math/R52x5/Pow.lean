module

public import Firedancer.Math.R52x5.QuadSqr
public import Firedancer.R52x5.Decode2.Spec

/-! `FD_R52X5_POW22523_QUAD` in `ZMod p`: each lane to the power `(p - 5) / 8`. -/

namespace MLIR.Firedancer.R52x5

open _root_.Ed25519 (p)

namespace fd_r52x5_ge_decode2

/-- `Q` is reduced, each lane `A`'s to the power `e`. -/
def IsPow (Q A : Quad5) (e : ℕ) : Prop :=
  Q.Below 52 ∧ ∀ j, Q.val j = A.val j ^ e

theorem IsPow.self {A : Quad5} (h : A.Below 52) : IsPow A A 1 :=
  ⟨h, fun _ => (pow_one _).symm⟩

theorem IsPow.sqr {Q A : Quad5} (h : IsPow Q A e) : IsPow (sqrQ Q) A (e * 2) :=
  ⟨Quad5.reduce_below _, fun j => by
    rw [sqrQ, (Quad5.reduce_is _).val j, (fd_r52x5_quad_sqr_fast.spec_lane h.1 j).1, h.2 j,
      pow_mul]⟩

theorem IsPow.mul {Q R A : Quad5} (h : IsPow Q A e) (h' : IsPow R A f) :
    IsPow (mulQ Q R) A (e + f) :=
  ⟨Quad5.reduce_below _, fun j => by
    rw [mulQ, (Quad5.reduce_is _).val j, (fd_r52x5_quad_mul_fast.spec_lane h.1 h'.1 j).1, h.2 j,
      h'.2 j, pow_add]⟩

theorem IsPow.sqrN {Q A : Quad5} (h : IsPow Q A e) : IsPow (sqrNQ n Q) A (e * 2 ^ n) := by
  induction n generalizing Q e with
  | zero => simpa [sqrNQ] using h
  | succ n ih =>
    rw [sqrNQ, pow_succ', ← mul_assoc]
    exact ih h.sqr

/-- `FD_R52X5_POW22523_QUAD` of a reduced QUAD: each lane to the power `(p - 5) / 8`, reduced. -/
public theorem pow22523Q_spec {A : Quad5} (hA : A.Below 52) :
    (pow22523Q A).Below 52 ∧ ∀ j, (pow22523Q A).val j = A.val j ^ ((p - 5) / 8) := by
  have h0 := IsPow.self hA
  have h1 := h0.sqr
  have h2 := h1.sqr
  have h3 := h2.sqrN (n := 1)
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
  have h17 := h16.sqr
  have h18 := h17.sqrN (n := 9)
  have h19 := h18.mul h10
  have h20 := h19.sqr
  have h21 := h20.sqrN (n := 49)
  have h22 := h21.mul h19
  have h23 := h22.sqr
  have h24 := h23.sqrN (n := 99)
  have h25 := h24.mul h22
  have h26 := h25.sqr
  have h27 := h26.sqrN (n := 49)
  have h28 := h27.mul h19
  have h29 := h28.sqr
  have h30 := h29.sqrN (n := 1)
  have h31 := h30.mul h0
  refine ⟨h31.1, fun j => (h31.2 j).trans ?_⟩
  congr 1

end fd_r52x5_ge_decode2

end MLIR.Firedancer.R52x5

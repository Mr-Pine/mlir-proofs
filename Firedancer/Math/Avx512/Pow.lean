module

public import Firedancer.Math.Avx512.Mul
public import Firedancer.Avx512.fd_r43x6_repsqr_mul2
public import Firedancer.Avx512.fd_r43x6_pow22523_2
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! `fd_r43x6_repsqr_mul2`'s repeated squaring and multiply, and `fd_r43x6_pow22523_2`'s
`z^((p - 5) / 8)`, in `ZMod p`. -/

namespace MLIR.Firedancer.Avx512

open MLIR.Firedancer.Ref (p)

namespace R43x6

/-- `fd_r43x6_repsqr_mul2.sqrN n` raises an unreduced `fd_r43x6_t` to `2^n`, unreduced. -/
public theorem sqrN_spec {x : Wwl} (hx : Unreduced x) (n : ℕ) :
    val (fd_r43x6_repsqr_mul2.sqrN n x) = val x ^ 2 ^ n ∧
      Unreduced (fd_r43x6_repsqr_mul2.sqrN n x) := by
  induction n generalizing x with
  | zero => exact ⟨by simp [fd_r43x6_repsqr_mul2.sqrN], hx⟩
  | succ n ih =>
    obtain ⟨v, f⟩ := fd_r43x6_sqr_spec hx
    obtain ⟨v', f'⟩ := ih f.unreduced
    refine ⟨?_, f'⟩
    rw [fd_r43x6_repsqr_mul2.sqrN, v', v, ← pow_mul, pow_succ, mul_comm]

/-- `fd_r43x6_repsqr_mul2.spec x y n` is `x^(2^n) y`, folded. -/
public theorem fd_r43x6_repsqr_mul2_spec {x y : Wwl} (hx : Unreduced x) (hy : Unreduced y)
    (n : ℕ) :
    val (fd_r43x6_repsqr_mul2.spec x y n) = val x ^ 2 ^ n * val y ∧
      Folded (fd_r43x6_repsqr_mul2.spec x y n) := by
  obtain ⟨v, u⟩ := sqrN_spec hx n
  obtain ⟨v', f⟩ := fd_r43x6_mul_spec u.1 hy
  exact ⟨by rw [fd_r43x6_repsqr_mul2.spec, v', v], f⟩

/-- `l` is folded with value `z ^ e`. -/
def IsPow (l z : Wwl) (e : ℕ) : Prop :=
  val l = val z ^ e ∧ Folded l

theorem IsPow.repsqr_mul {l m z : Wwl} (h : IsPow l z e) (h' : IsPow m z f) (n : ℕ) :
    IsPow (fd_r43x6_repsqr_mul2.spec l m n) z (e * 2 ^ n + f) := by
  obtain ⟨v, g⟩ := fd_r43x6_repsqr_mul2_spec h.2.unreduced h'.2.unreduced n
  exact ⟨by rw [v, h.1, h'.1, ← pow_mul, pow_add], g⟩

/-- `fd_r43x6_pow22523_2.spec` raises an unreduced `fd_r43x6_t` to `(p - 5) / 8`, folded. -/
public theorem fd_r43x6_pow22523_2_spec {z : Wwl} (hz : Unreduced z) :
    val (fd_r43x6_pow22523_2.spec z) = val z ^ ((p - 5) / 8) ∧
      Folded (fd_r43x6_pow22523_2.spec z) := by
  obtain ⟨v2, f2⟩ := fd_r43x6_sqr_spec hz
  have h2 : IsPow (fd_r43x6_sqr z) z 2 := ⟨v2, f2⟩
  have hz1 : IsPow (fd_r43x6_repsqr_mul2.spec (fd_r43x6_sqr z) z 2) z 9 := by
    obtain ⟨v, f⟩ := fd_r43x6_repsqr_mul2_spec f2.unreduced hz 2
    exact ⟨by rw [v, v2]; ring, f⟩
  have h11 := hz1.repsqr_mul h2 0
  have h31 := h11.repsqr_mul hz1 1
  have h10 := h31.repsqr_mul h31 5
  have h20 := h10.repsqr_mul h10 10
  have h40 := h20.repsqr_mul h20 20
  have h50 := h40.repsqr_mul h10 10
  have h100 := h50.repsqr_mul h50 50
  have h200 := h100.repsqr_mul h100 100
  have h250 := h200.repsqr_mul h50 50
  obtain ⟨v, f⟩ := fd_r43x6_repsqr_mul2_spec h250.2.unreduced hz 2
  rw [fd_r43x6_pow22523_2.spec]
  refine ⟨?_, f⟩
  rw [v, h250.1, ← pow_mul, ← pow_succ]
  congr 1

end R43x6

end MLIR.Firedancer.Avx512

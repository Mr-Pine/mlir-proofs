module

public import Firedancer.Secp256k1.Math.Ops
public import Firedancer.Secp256k1.Point
import Mathlib.NumberTheory.LegendreSymbol.Basic

/-! `fd_secp256k1_fp_sqrt` on any backend meeting `Backend.Spec`: the root `a^((p+1)/4)`
(`p ≡ 3 mod 4`), and Euler's criterion for when it is returned. -/

namespace Firedancer.Secp256k1

/-- `x^((p+1)/2) = x` exactly on squares (Euler's criterion). -/
public theorem pow_half_succ_eq_self_iff (x : ZMod p_256k1) :
    x ^ ((p_256k1 + 1) / 2) = x ↔ IsSquare x := by
  have he : (p_256k1 + 1) / 2 = p_256k1 / 2 + 1 := by norm_num [p_256k1]
  rcases eq_or_ne x 0 with rfl | hx
  · simp [he]
  · rw [ZMod.euler_criterion _ hx, he, pow_succ]
    constructor
    · intro h;
      exact
        mul_left_cancel₀ hx
          (by
            rw [mul_one, mul_comm]; exact h)
    · intro h; rw [h, one_mul]

open scoped Classical in
/-- `fd_secp256k1_fp_sqrt` stores `a^((p+1)/4)`, canonical, and returns it exactly when `a` is a
square, in which case it squares to `a`. -/
public theorem fd_secp256k1_fp_sqrt.spec_val {B : Backend} (hB : B.Spec) {a : fd_secp256k1_fp_t}
    (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_sqrt.spec B a).r ∧
      toF (fd_secp256k1_fp_sqrt.spec B a).r = toF a ^ ((p_256k1 + 1) / 4) ∧
      (fd_secp256k1_fp_sqrt.spec B a).ret =
        (if IsSquare (toF a) then some (fd_secp256k1_fp_sqrt.spec B a).r else none) ∧
      (IsSquare (toF a) → toF (fd_secp256k1_fp_sqrt.spec B a).r ^ 2 = toF a) := by
  let P (x : fd_secp256k1_fp_t) (e : ℕ) : Prop := fpCanon x ∧ toF x = toF a ^ e
  have mul : ∀ {x y e f} (g : ℕ), P x e → P y f → e + f = g → P (B.fp_mul x y) g :=
    fun g hx hy he =>
    ⟨(hB.fp_mul hx.1 hy.1).1, by rw [(hB.fp_mul hx.1 hy.1).2, hx.2, hy.2, ← pow_add, he]⟩
  have sqk : ∀ (k : ℕ) {x e} (g : ℕ), P x e → e * 2 ^ k = g → P (B.fp_sqr^[k] x) g := by
    intro k
    induction k with
    | zero =>
      intro x e g hx he; simpa [← he] using hx
    | succ k ih =>
      intro x e g hx he
      rw [Function.iterate_succ_apply']
      obtain ⟨c, v⟩ := ih (e * 2 ^ k) hx rfl
      exact ⟨(hB.fp_sqr c).1, by rw [(hB.fp_sqr c).2, v, ← pow_mul, ← he, pow_succ, mul_assoc]⟩
  have sq : ∀ {x e} (g : ℕ), P x e → e * 2 = g → P (B.fp_sqr x) g := fun g hx he =>
    sqk 1 g hx
      (by
        rw [pow_one]; exact he)
  have h1 : P a 1 := ⟨ha, (pow_one _).symm⟩
  unfold fd_secp256k1_fp_sqrt.spec
  extract_lets  x2a x2b x3a x3b x6a x6b x6c x9a x9b x9c x11a x11b x11c x22a x22b x22c x44a x44b x44c
    x88a x88b x88c x176a x176b x176c x220a x220b x220c x223a x223b x223c u0 u1 u2 u3 u4 u5 r u6
  have h2a : P x2a 2 := sq 2 h1 rfl
  have h2b : P x2b 3 := mul 3 h2a h1 rfl
  have h3a : P x3a 6 := sq 6 h2b rfl
  have h3b : P x3b 7 := mul 7 h3a h1 rfl
  have h6b : P x6b 56 := sqk 3 56 h3b rfl
  have h6c : P x6c 63 := mul 63 h6b h3b rfl
  have h9b : P x9b 504 := sqk 3 504 h6c rfl
  have h9c : P x9c 511 := mul 511 h9b h3b rfl
  have h11b : P x11b 2044 := sqk 2 2044 h9c rfl
  have h11c : P x11c (2 ^ 11 - 1) := mul _ h11b h2b rfl
  have h22b : P x22b ((2 ^ 11 - 1) * 2 ^ 11) := sqk 11 _ h11c rfl
  have h22c : P x22c (2 ^ 22 - 1) := mul _ h22b h11c (by norm_num)
  have h44b : P x44b ((2 ^ 22 - 1) * 2 ^ 22) := sqk 22 _ h22c rfl
  have h44c : P x44c (2 ^ 44 - 1) := mul _ h44b h22c (by norm_num)
  have h88b : P x88b ((2 ^ 44 - 1) * 2 ^ 44) := sqk 44 _ h44c rfl
  have h88c : P x88c (2 ^ 88 - 1) := mul _ h88b h44c (by norm_num)
  have h176b : P x176b ((2 ^ 88 - 1) * 2 ^ 88) := sqk 88 _ h88c rfl
  have h176c : P x176c (2 ^ 176 - 1) := mul _ h176b h88c (by norm_num)
  have h220b : P x220b ((2 ^ 176 - 1) * 2 ^ 44) := sqk 44 _ h176c rfl
  have h220c : P x220c (2 ^ 220 - 1) := mul _ h220b h44c (by norm_num)
  have h223b : P x223b ((2 ^ 220 - 1) * 2 ^ 3) := sqk 3 _ h220c rfl
  have h223c : P x223c (2 ^ 223 - 1) := mul _ h223b h3b (by norm_num)
  have hu1 : P u1 ((2 ^ 223 - 1) * 2 ^ 23) := sqk 23 _ h223c rfl
  have hu2 : P u2 ((2 ^ 223 - 1) * 2 ^ 23 + (2 ^ 22 - 1)) := mul _ hu1 h22c rfl
  have hu3 : P u3 (((2 ^ 223 - 1) * 2 ^ 23 + (2 ^ 22 - 1)) * 2 ^ 6) := sqk 6 _ hu2 rfl
  have hu4 : P u4 (((2 ^ 223 - 1) * 2 ^ 23 + (2 ^ 22 - 1)) * 2 ^ 6 + 3) := mul _ hu3 h2b rfl
  have hu5 : P u5 ((((2 ^ 223 - 1) * 2 ^ 23 + (2 ^ 22 - 1)) * 2 ^ 6 + 3) * 2) := sq _ hu4 rfl
  have hr : P r ((p_256k1 + 1) / 4) := sq _ hu5 (by norm_num [p_256k1])
  have hu6 : P u6 ((p_256k1 + 1) / 2) := sq _ hr (by norm_num [p_256k1])
  have hsq : toF r ^ 2 = toF a ^ ((p_256k1 + 1) / 2) := by
    rw [hr.2, ← pow_mul]; congr 1
  rw [hB.fp_eq hu6.1 ha, hu6.2]
  by_cases h : IsSquare (toF a)
  · have h' := (pow_half_succ_eq_self_iff _).2 h
    rw [ite_eq_left h', ite_eq_right (by decide), ite_eq_left h]
    exact ⟨hr.1, hr.2, rfl, fun _ => by rw [hsq, h']⟩
  · have h' := mt (pow_half_succ_eq_self_iff _).1 h
    rw [ite_eq_right h', ite_eq_left rfl, ite_eq_right h]
    exact ⟨hr.1, hr.2, rfl, fun h'' => absurd h'' h⟩

end Firedancer.Secp256k1

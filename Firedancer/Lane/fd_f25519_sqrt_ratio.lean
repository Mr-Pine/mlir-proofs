module

public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.Lane.fd_f25519_pow22523
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio
public import MLIR.Run.Tactic
public import Firedancer.Math.Sqrt
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.LinearCombination

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 SqrtRatio

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_sqrt_ratio( r, u, v )`: `r` and the flag. `r = (u v³) (u v⁷)^((p-5)/8)`, then
`√-1 r` if `v r²` is `-u` or `-u √-1`, then `|r|`; the flag says whether `v r²` was `u` or `-u`. -/
@[irreducible]
def fd_f25519_sqrt_ratio.spec (u v : Wwl) : Wwl × BitVec 32 :=
  let sqr := fd_r43x6_sqr
  let mul := fd_r43x6_mul
  let v2 := sqr v
  let v3 := mul v2 v
  let uv3 := mul u v3
  let v6 := sqr v3
  let v7 := mul v6 v
  let uv7 := mul u v7
  let r := fd_f25519_pow22523.spec uv7
  let r := mul r uv3
  let check := sqr r
  let check := mul check v
  let u_neg := fd_f25519_sqrt_ratio.neg u
  let u_neg_sqrtm1 := mul u_neg fd_f25519_sqrt_ratio.sqrtm1
  let correct_sign_sqrt := fd_f25519_eq.spec check u
  let flipped_sign_sqrt := fd_f25519_eq.spec check u_neg
  let flipped_sign_sqrt_i := fd_f25519_eq.spec check u_neg_sqrtm1
  let r_prime := mul r fd_f25519_sqrt_ratio.sqrtm1
  let r := fd_f25519_sqrt_ratio.ifc (flipped_sign_sqrt ||| flipped_sign_sqrt_i) r_prime r
  let r := fd_f25519_sqrt_ratio.abs r
  (r, correct_sign_sqrt ||| flipped_sign_sqrt)

end

/-! ## Value -/

namespace fd_f25519_sqrt_ratio

open _root_.Ed25519 (p sqrtM1 sqrtM1_sq sq_eq_one_iff')
open R43x6

/-- `neg` negates `u47` limbs, folded. -/
theorem neg_spec {x : Wwl} (hx : Unsigned 47 x) : val (neg x) = -val x ∧ Folded (neg x) := by
  obtain ⟨vn, sn⟩ := fd_r43x6_neg_fast_spec_unsigned hx (by decide) (by decide)
  obtain ⟨vf, f⟩ := fd_r43x6_fold_signed_spec (sn.mono (by decide))
  exact ⟨vf.trans vn, f⟩

/-- `√-1`'s limbs, folded. -/
theorem sqrtm1_spec : val sqrtm1 = sqrtM1 ∧ Folded sqrtm1 := by
  refine ⟨?_, ?_⟩
  · simp only [val, int, sqrtm1]
    norm_num [sqrtM1, BitVec.toInt]
  · simp [Folded, HighZero, sqrtm1]

/-- `ifc`'s value: `a1`'s when the flag is clear, else `a0`'s. -/
theorem ifc_val (c : BitVec 32) (a0 a1 : Wwl) :
    val (ifc c a0 a1) = if c = 0 then val a1 else val a0 := by
  unfold ifc
  split <;> rfl

/-- `abs` of folded limbs: `±` their value, folded. -/
theorem abs_spec {x : Wwl} (hx : Folded x) :
    (val (abs x) = val x ∨ val (abs x) = -val x) ∧ Folded (abs x) := by
  obtain ⟨vn, fn⟩ := neg_spec (hx.unsigned.mono (by decide))
  unfold abs ifc
  split
  · exact ⟨.inl rfl, hx⟩
  · exact ⟨.inr vn, fn⟩

/-- `sqrt_ratio`'s algebra: `β = u v³ (u v⁷)^((p-5)/8)` has `v β² = u c` with `c² = 1` exactly when
`u / v` is a square; the flags then pick `β` or `β √-1` as a root. -/
theorem sqrt_ratio_alg {u v β : ZMod p} (hv : v ≠ 0)
    (hβ : β = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    let fc := β ^ 2 * v = u
    let ff := β ^ 2 * v = -u
    let fi := β ^ 2 * v = -u * sqrtM1
    let r := if fi ∨ ff then β * sqrtM1 else β
    (IsSquare (u / v) → (ff ∨ fc) ∧ v * r ^ 2 = u) ∧ (¬IsSquare (u / v) → ¬(ff ∨ fc)) := by
  intro fc ff fi r
  by_cases hu : u = 0
  · subst hu
    have hβ0 : β = 0 := by simp [hβ]
    have hff : ff := by simp [ff, hβ0]
    refine ⟨fun _ => ⟨.inl hff, ?_⟩, fun h => absurd ⟨0, by simp⟩ h⟩
    simp only [r, ite_eq_left (Or.inr hff), hβ0]
    ring
  have hw : u * v ^ 7 ≠ 0 := mul_ne_zero hu (pow_ne_zero _ hv)
  set c := (u * v ^ 7) ^ ((p - 1) / 4) with hc
  have hcheck : β ^ 2 * v = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, pow_succ (u * v ^ 7),
      pow_mul (u * v ^ 7), hβ]
    ring
  have hc2 : c ^ 2 = (u * v ^ 7) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hFermat : ((u * v ^ 7) ^ (p / 2)) ^ 2 = 1 := by
    rw [← pow_mul, show p / 2 * 2 = p - 1 by norm_num]
    exact ZMod.pow_card_sub_one_eq_one hw
  have hsq := (Ref.isSquare_div_iff (u := u) hv).trans (ZMod.euler_criterion p hw)
  have hne : (1 : ZMod p) ≠ -1 := by decide
  constructor
  · intro h
    have h1 : c ^ 2 = 1 := hc2.trans (hsq.1 h)
    rcases sq_eq_one_iff'.1 h1 with h1 | h1
    · have hfc : fc := by simp [fc, hcheck, h1]
      have hfi : ¬fi := by
        intro hfi
        have : u * (1 + sqrtM1) = 0 := by linear_combination hfc.symm.trans hfi
        rcases mul_eq_zero.1 this with h | h
        · exact hu h
        · have := sqrtM1_sq
          rw [show sqrtM1 = -1 by linear_combination h] at this
          exact hne (by linear_combination this)
      have hff : ¬ff := by
        intro hff
        have : 2 * u = 0 := by linear_combination hfc.symm.trans hff
        exact hu ((mul_eq_zero.1 this).resolve_left (by decide))
      refine ⟨.inr hfc, ?_⟩
      simp only [r, ite_eq_right (not_or.2 ⟨hfi, hff⟩)]
      linear_combination hfc
    · have hff : ff := by simp [ff, hcheck, h1]
      refine ⟨.inl hff, ?_⟩
      simp only [r, ite_eq_left (Or.inr hff)]
      linear_combination sqrtM1 ^ 2 * hff - u * sqrtM1_sq
  · intro h hf
    have hm : (u * v ^ 7) ^ (p / 2) = -1 := by
      have : ((u * v ^ 7) ^ (p / 2) - 1) * ((u * v ^ 7) ^ (p / 2) + 1) = 0 := by
        linear_combination hFermat
      rcases mul_eq_zero.1 this with h' | h'
      · exact absurd (hsq.2 (by linear_combination h')) h
      · linear_combination h'
    have hc' : c ^ 2 = -1 := hc2.trans hm
    rcases hf with hf | hf
    · have : u * (c + 1) = 0 := by linear_combination hcheck.symm.trans hf
      have hc1 : c = -1 := by linear_combination (mul_eq_zero.1 this).resolve_left hu
      rw [hc1] at hc'
      exact hne (by linear_combination hc')
    · have : u * (c - 1) = 0 := by linear_combination hcheck.symm.trans hf
      have hc1 : c = 1 := by linear_combination (mul_eq_zero.1 this).resolve_left hu
      rw [hc1] at hc'
      exact hne (by linear_combination hc')

end fd_f25519_sqrt_ratio

open fd_f25519_sqrt_ratio R43x6 _root_.Ed25519 in
/-- `sqrt_ratio` on unreduced `u` and `v ≠ 0`: when `u / v` is a square, the flag is `1` and `r` a
root of it, `v r² = u`; else the flag is `0`. `r` is folded either way. -/
public theorem fd_f25519_sqrt_ratio.spec_val {u v : Wwl} (hu : Unreduced u) (hv : Unreduced v)
    (hv0 : val v ≠ 0) :
    let R := fd_f25519_sqrt_ratio.spec u v
    (IsSquare (val u / val v) → R.2 = 1 ∧ val v * val R.1 ^ 2 = val u) ∧
      (¬IsSquare (val u / val v) → R.2 = 0) ∧ Folded R.1 := by
  have m47 {x : Wwl} (h : Folded x) : Unsigned 47 x := h.unsigned.mono (by decide)
  have s61 {x : Wwl} (h : Folded x) : Signed 61 x :=
    (h.unsigned.mono (by decide)).signed (by decide)
  obtain ⟨v2v, v2f⟩ := fd_r43x6_sqr_spec hv
  obtain ⟨v3v, v3f⟩ := fd_r43x6_mul_spec (m47 v2f) hv
  obtain ⟨uv3v, uv3f⟩ := fd_r43x6_mul_spec hu.1 v3f.unreduced
  obtain ⟨v6v, v6f⟩ := fd_r43x6_sqr_spec v3f.unreduced
  obtain ⟨v7v, v7f⟩ := fd_r43x6_mul_spec (m47 v6f) hv
  obtain ⟨uv7v, uv7f⟩ := fd_r43x6_mul_spec hu.1 v7f.unreduced
  obtain ⟨pv, pf⟩ := fd_f25519_pow22523.spec_val uv7f.unreduced
  obtain ⟨rv, rf⟩ := fd_r43x6_mul_spec (m47 pf) uv3f.unreduced
  obtain ⟨c1v, c1f⟩ := fd_r43x6_sqr_spec rf.unreduced
  obtain ⟨ckv, ckf⟩ := fd_r43x6_mul_spec (m47 c1f) hv
  obtain ⟨unv, unf⟩ := neg_spec hu.1
  obtain ⟨sv, sf⟩ := sqrtm1_spec
  obtain ⟨univ, unif⟩ := fd_r43x6_mul_spec (m47 unf) sf.unreduced
  obtain ⟨rpv, rpf⟩ := fd_r43x6_mul_spec (m47 rf) sf.unreduced
  have su : Signed 61 u := (hu.1.mono (by decide)).signed (by decide)
  delta fd_f25519_sqrt_ratio.spec
  simp only
  set v3 := fd_r43x6_mul (fd_r43x6_sqr v) v
  set uv7 := fd_r43x6_mul u (fd_r43x6_mul (fd_r43x6_sqr v3) v)
  set r₀ := fd_r43x6_mul (fd_f25519_pow22523.spec uv7) (fd_r43x6_mul u v3)
  have alg := sqrt_ratio_alg hv0 (u := val u) (β := val r₀)
    (by rw [rv, pv, uv7v, v7v, v6v, uv3v, v3v, v2v]; ring)
  set rr := ifc (fd_f25519_eq.spec (fd_r43x6_mul (fd_r43x6_sqr r₀) v) (neg u) |||
      fd_f25519_eq.spec (fd_r43x6_mul (fd_r43x6_sqr r₀) v) (fd_r43x6_mul (neg u) sqrtm1))
    (fd_r43x6_mul r₀ sqrtm1) r₀ with hrr
  have hrrf : Folded rr ∧
      val rr = if val r₀ ^ 2 * val v = -val u * sqrtM1 ∨ val r₀ ^ 2 * val v = -val u then
        val r₀ * sqrtM1 else val r₀ := by
    rw [hrr]
    unfold ifc
    rw [fd_f25519_eq_spec (s61 ckf) (s61 unf), fd_f25519_eq_spec (s61 ckf) (s61 unif), ckv, c1v,
      univ, unv, sv]
    by_cases h1 : val r₀ ^ 2 * val v = -val u <;>
      by_cases h2 : val r₀ ^ 2 * val v = -val u * sqrtM1
    · rw [ite_eq_left h1, ite_eq_left h2, ite_eq_right (by decide), ite_eq_left (Or.inl h2)]
      exact ⟨rpf, by rw [rpv, sv]⟩
    · rw [ite_eq_left h1, ite_eq_right h2, ite_eq_right (by decide), ite_eq_left (Or.inr h1)]
      exact ⟨rpf, by rw [rpv, sv]⟩
    · rw [ite_eq_right h1, ite_eq_left h2, ite_eq_right (by decide), ite_eq_left (Or.inl h2)]
      exact ⟨rpf, by rw [rpv, sv]⟩
    · rw [ite_eq_right h1, ite_eq_right h2, ite_eq_left (by decide),
        ite_eq_right (not_or.2 ⟨h2, h1⟩)]
      exact ⟨rf, rfl⟩
  obtain ⟨habs, hf⟩ := abs_spec hrrf.1
  obtain ⟨hsq, hnsq⟩ := alg
  rw [fd_f25519_eq_spec (s61 ckf) su, fd_f25519_eq_spec (s61 ckf) (s61 unf), ckv, c1v, unv]
  refine ⟨fun h => ?_, fun h => ?_, hf⟩
  · obtain ⟨hff, hr⟩ := hsq h
    refine ⟨by rcases hff with e | e <;> simp only [e, ↓reduceIte] <;> split <;> decide, ?_⟩
    rcases habs with e | e <;> rw [e, hrrf.2] <;> linear_combination hr
  · have := hnsq h
    simp only [not_or] at this
    simp [this.1, this.2]

/-! ## Proof -/

section Proof

namespace fd_f25519_sqrt_ratio

open Firedancer.Lane.Mlir Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio
open fd_f25519_sqrt_ratio (neg ifc abs sqrtm1)

/-! ### `fd_r43x6_mod`'s flags: none of its `nsw`/`nuw` adds overflows, whatever the limbs -/

private theorem nsw_mask_sshr (a b : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow (b.sshiftRight 43) = false := by bv_decide

private theorem nsw_sshr_neg1 (b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow 18446744073709551615#64 = false := by bv_decide

private theorem nsw_sshr_neg1_mask (b c : BitVec 64) :
    (b.sshiftRight 43 + 18446744073709551615#64).saddOverflow (c &&& 1099511627775#64) = false := by
  bv_decide

private theorem nsw_sshr40_sshr40 (t y : BitVec 64) :
    (t.sshiftRight 40).saddOverflow (y.sshiftRight 40) = false := by bv_decide

private theorem nsw_mul19 (t y : BitVec 64) :
    (t.sshiftRight 40 + y.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

private theorem nsw_mul19_mask (t y z : BitVec 64) :
    ((t.sshiftRight 40 + y.sshiftRight 40) * 19#64).saddOverflow (z &&& 8796093022207#64) =
      false := by
  bv_decide

private theorem nsw_carry_sshr (a b u : BitVec 64) :
    ((a &&& 8796093022207#64) + b.sshiftRight 43).saddOverflow (u.sshiftRight 43) = false := by
  bv_decide

private theorem nuw_mask43_19 (x : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (x &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  bv_decide

private theorem nuw_mask43_shr43 (x y : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow (y >>> 43) = false ∧
      (x &&& 8796093022207#64).uaddOverflow (y >>> 43) = false := by
  bv_decide

private theorem nuw_mask40_1 (x : BitVec 64) :
    (x &&& 1099511627775#64).saddOverflow 1#64 = false ∧
      (x &&& 1099511627775#64).uaddOverflow 1#64 = false := by
  bv_decide

private theorem nsw_mask40_1_sshr (x z : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64).saddOverflow (z.sshiftRight 43) = false := by bv_decide

private theorem nuw_top (x a b u w : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).saddOverflow
          (w >>> 43) =
        false ∧
      ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).uaddOverflow
          (w >>> 43) =
        false := by
  bv_decide

private theorem nsw_sshr43_mask43 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 8796093022207#64) = false := by bv_decide

private theorem nsw_sshr43_mask40 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 1099511627775#64) = false := by bv_decide

private theorem nsw_sel19_mask43 (c : Prop) [Decidable c] (x : BitVec 64) :
    (if c then 18446744073709551597#64 else 0#64).saddOverflow (x &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

attribute [local simp] nsw_mask_sshr nsw_sshr_neg1 nsw_sshr_neg1_mask nsw_sshr40_sshr40 nsw_mul19
  nsw_mul19_mask nsw_carry_sshr nuw_mask43_19 nuw_mask43_shr43 nuw_mask40_1 nsw_mask40_1_sshr
  nuw_top nsw_sshr43_mask43 nsw_sshr43_mask40 nsw_sel19_mask43

/-- The sign test's `(buf[0] & 1) - 1`: no overflow. -/
private theorem nsw_bit_sub1 (b : BitVec 8) : (b &&& 1#8).saddOverflow 255#8 = false := by
  bv_decide

attribute [local simp] nsw_bit_sub1


section Pieces

/-- The entry block's constants the runs after them read. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 255#8, %1 := .value 1#8, %6 :=
    Ty.wrap #v[8796093022207#64, 18446744073709551615#64], %7 := Vector.replicate 2 PoisonOr.poison,
    %8 := Ty.wrap (Vector.replicate 4 8796093022207#64), %9 := Vector.replicate 4 PoisonOr.poison,
    %10 := .value 18446744073709551597#64, %11 := .value 1099511627776#64, %12 := .value 19#64,
    %13 := .value 1099511627775#64, %14 := .value 43#64, %15 := .value 40#64, %16 :=
    .value 8796093022207#64, %17 := .value 5#64, %18 := .value 4#64, %19 := .value 3#64, %20 :=
    .value 2#64, %21 := .value 1#64, %22 := .value 1#1, %23 :=
    Ty.wrap #v[8796093022189#64, 8796093022207#64, 8796093022207#64, 8796093022207#64,
      8796093022207#64, 1099511627775#64, 0#64, 0#64], %24 :=
    .value 0#8, %25 :=
    Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
      4526638806224#64, 373767602335#64, 0#64, 0#64],
    %26 := Ty.wrap negBias, %27 := Ty.wrap negSel, %28 :=
    Ty.wrap neg18, %29 := Ty.wrap negP, %30 := Vector.replicate 6 PoisonOr.poison, %31 :=
    Ty.wrap foldK, %32 := Ty.wrap foldShifts, %33 := Ty.wrap foldMask, %34 :=
    Ty.wrap (Vector.replicate 8 24#64), %35 := Ty.wrap (Vector.replicate 8 7#64), %36 :=
    Ty.wrap
      #v[18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64,
        18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64, 0#64, 0#64],
    %44 := Vector.replicate 8 PoisonOr.poison, %45 :=
    Ty.wrap #v[0#64, 1#64, 1#64, 1#64, 1#64, 1#64, 0#64, 1#64], %46 :=
    Ty.wrap #v[0#64, 1#64, 0#64, 1#64, 1#64, 1#64, 1#64, 1#64], %47 :=
    Ty.wrap #v[1#64, 1#64, 0#64, 1#64, 0#64, 1#64, 1#64, 1#64], %48 := .value 0#64, %49 :=
    Ty.wrap (Vector.replicate 8 0#64), %50 := Ty.wrap (Vector.replicate 8 9#64), %51 :=
    Ty.wrap
      #v[0#64, 0#64, 18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64,
        18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64],
    %52 :=
    Ty.wrap
      #v[0#64, 18446744073709551615#64, 0#64, 18446744073709551615#64, 18446744073709551615#64,
        18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64],
    %54 := .value 18446744073709551615#64, %64 :=
    lanesBelow 6 sqrMask1, %72 := lanesBelow 6 sqrMask2, %80 := lanesBelow 5 sqrMask1, %88 :=
    lanesBelow 5 sqrMask2, %96 := lanesFrom 7 wwl_zero, %104 := lanesBelow 5 wwl_zero, %112 :=
    lanesFrom 6 wwl_zero, %120 := lanesFrom 5 wwl_zero, %128 := lanesBelow 3 wwl_zero, %136 :=
    lanesFrom 4 wwl_zero, %144 := lanesBelow 2 wwl_zero, %152 := lanesFrom 3 wwl_zero, %160 :=
    lanesBelow 1 wwl_zero, %168 := lanesFrom 2 wwl_zero, %176 :=
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value 0#64) (by decide)).set 1
                              (PoisonOr.value 21#64) (by decide)).set
                          2 (PoisonOr.value 42#64) (by decide)).set
                      3 PoisonOr.poison (by decide)).set
                  4 (PoisonOr.value 20#64) (by decide)).set
              5 PoisonOr.poison (by decide)).set
          6 PoisonOr.poison (by decide)).set
      7 PoisonOr.poison (by decide),
    %180 :=
    (((Vector.replicate 4 PoisonOr.poison).set 1 (PoisonOr.value 43#64) (by decide)).set 2
          PoisonOr.poison (by decide)).set
      3 PoisonOr.poison (by decide)]

/-- The entry block's constants, the masks and the slides' zero operands. -/
theorem consts_run (r u v : Pointer) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value u) (.value v)).get)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value u) (.value v)).get →
          Consts E' → (entry.runBodyFrom E' 181 S >>= g) = K) :
    (entry.runBodyFrom E 0 S >>= g) = K := by
  iterate 57 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  iterate 12 step_pure
  subst hv64 hv72 hv80 hv88 hv96 hv104 hv112 hv120 hv128 hv136 hv144 hv152 hv160 hv168 hS
  exact hK _ hArgs (by env_reads)

/-- The run after `u`'s second load: `-u`, `-u √-1`, the three `fd_f25519_eq`s, `r_prime` and the
`if`; the flags `correct` and `flipped` in `%712 %729`, the `if`'s root in `%803`. -/
theorem tail_if (r u v P : Pointer) (R1 C U : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value u) (.value v)).get) (hL : Consts E)
    (hP : E.read (rir_reg% hty 181) = .value P) (hR1 : E.read (rir_reg% hty 533) = Ty.wrap R1)
    (hC : E.read (rir_reg% hty 633) = Ty.wrap C) (hU : E.read (rir_reg% hty 634) = Ty.wrap U)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value u) (.value v)).get →
          Consts E' →
          E'.read (rir_reg% hty 181) = .value P →
          E'.read (rir_reg% hty 712) = .value ((fd_f25519_eq.spec C U).setWidth 1) →
          E'.read (rir_reg% hty 729) = .value ((fd_f25519_eq.spec C (neg U)).setWidth 1) →
          E'.read (rir_reg% hty 803) =
              Ty.wrap
                (ifc
                  (fd_f25519_eq.spec C (neg U) |||
                    fd_f25519_eq.spec C (fd_r43x6_mul (neg U) sqrtm1))
                  (fd_r43x6_mul R1 sqrtm1) R1) →
          (entry.runBodyFrom E' 807 S >>= g) = K) :
    (entry.runBodyFrom E 638 S >>= g) = K := by
  split_reads hL
  step_pattern using runBodyFrom_negRun with u_neg
  step_pattern using runBodyFrom_mulRun with u_neg_sqrtm1
  -- the three `fd_f25519_eq`s
  step_pattern using runBodyFrom_eqRun with correct
  step_pattern using runBodyFrom_eqRun with flipped
  step_pattern using runBodyFrom_eqRun with flipped_i
  -- `r_prime = r √-1`, `fd_f25519_if( r, flipped|flipped_i, r_prime, r )`
  step_pattern using runBodyFrom_mulRun with r_prime
  iterate 4 step_pure
  step_pure with r2
  rw [negFold_eq_neg] at hu_neg
  have er2 :
      r2 =
        ifc (fd_f25519_eq.spec C u_neg ||| fd_f25519_eq.spec C u_neg_sqrtm1) r_prime R1 := by
    rw [hr2, hflipped, hflipped_i]
    exact ifc_compiled _ (eq_spec_01 _ _) (eq_spec_01 _ _) R1 r_prime
  subst er2 hr_prime hu_neg_sqrtm1 hu_neg hcorrect hflipped hS
  exact hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

-- the 110 steps of `fd_r43x6_mod`'s reduction and the pack in one run: over 330000 heartbeats
set_option maxHeartbeats 400000 in
/-- `fd_f25519_abs( r, r )`: `-r`, `fd_f25519_sgn( r )` through `fd_r43x6_mod`'s limb 0 and the
pack's low byte, and the select; `abs R2` in `%912`. -/
theorem tail_abs (r u v P : Pointer) (R2 : Wwl) (c f : BitVec 1) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value u) (.value v)).get) (hL : Consts E)
    (hP : E.read (rir_reg% hty 181) = .value P) (h712 : E.read (rir_reg% hty 712) = .value c)
    (h729 : E.read (rir_reg% hty 729) = .value f) (hR2 : E.read (rir_reg% hty 803) = Ty.wrap R2)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value u) (.value v)).get →
          E'.read (rir_reg% hty 181) = .value P →
          E'.read (rir_reg% hty 712) = .value c →
          E'.read (rir_reg% hty 729) = .value f →
          E'.read (rir_reg% hty 912) = Ty.wrap (abs R2) →
          (entry.runBodyFrom E' 916 S >>= g) = K) :
    (entry.runBodyFrom E 807 S >>= g) = K := by
  split_reads hL
  -- `fd_f25519_abs( r, r )`: `-r`, then `fd_f25519_sgn( r )`'s `fd_r43x6_mod`
  step_pattern using runBodyFrom_negRun with nr
  step_pure with y0
  step_pure with y1
  step_pure with y2
  step_pure with y3
  step_pure with y4
  step_pure with y5
  iterate 17 step_pure
  step_pure with t5
  iterate 4 step_pure
  step_pure with u0
  iterate 2 step_pure
  step_pure with u1
  iterate 2 step_pure
  step_pure with u2
  iterate 2 step_pure
  step_pure with u3
  iterate 2 step_pure
  step_pure with transparent u4
  iterate 2 step_pure
  step_pure with v0
  iterate 2 step_pure
  step_pure with v1
  iterate 2 step_pure
  step_pure with v2
  iterate 2 step_pure
  step_pure with v3
  iterate 2 step_pure
  step_pure with v4
  iterate 4 step_pure
  step_pure with w5
  iterate 3 step_pure
  step_pure with r0
  step_pure
  step_pure with r1
  step_pure
  step_pure with r2'
  step_pure
  step_pure with r3
  iterate 6 step_pure
  step_pure with r4
  step_pure
  step_pure with r5
  -- `fd_r43x6_pack`'s low byte, `& 1`, as the select's mask
  iterate 14 step_pure
  step_pure with transparent bytes
  step_pure with transparent b0
  step_pure with transparent sb
  step_pure with transparent sb1
  step_pure with mk
  step_pure with r3'
  rw [negFold_eq_neg] at hnr
  have hm := mod_y0_compiled ht5 hu0 hu1 hu2 hu3 hv0 hv1 hv2 hv3 hv4 hw5 hr0
  rw [show (⟨y0, y1, y2, y3, y4, y5⟩ : Limbs) = extractLimbs R2 by
    rw [hy0, hy1, hy2, hy3, hy4, hy5]; rfl] at hm
  have er3 : r3' = abs R2 := by
    rw [hr3', hmk]
    refine (abs_compiled _ _ R2 nr).trans ?_
    rw [sgn_compiled hm, hnr]
    rfl
  subst er3 hS
  exact hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads)

end Pieces

-- nine inlined products and squares between the loads, stores and the call: over 200000 heartbeats
set_option maxHeartbeats 300000 in
/-- `fd_f25519_sqrt_ratio( r, u, v )` stores `spec`'s root of the elements at `u` and `v` at `r`
and returns its flag; `r` is in another block than `u` and `v`, its temporary is freed. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio.call_eq (r u v : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hu : Fits s.mem u 512)
    (hv : Fits s.mem v 512) (hru : r.id ≠ u.id) (hrv : r.id ≠ v.id) :
    Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio.call
        (Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio.args (.value r) (.value u) (.value v)) s =
      .value
        (.cons (.value (fd_f25519_sqrt_ratio.spec (s.mem.readVec u) (s.mem.readVec v)).2) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeVec r
                (fd_f25519_sqrt_ratio.spec (s.mem.readVec u) (s.mem.readVec v)).1 }) := by
  func_init
  block_init
  refine consts_run r u v S E ‹_› fun E hA hL => ?_
  split_reads hL
  step_alloca with _uv7
  step_load with V
  -- `v2 = v^2`, `v3 = v2 v`
  step_pattern using runBodyFrom_r43SqrRun with v2
  step_pattern using runBodyFrom_mulRun with v3
  -- `uv3 = u v3`, `u`'s lanes broadcast once for `uv7` too
  step_load with U
  step_pure with bu0
  step_pure with bu1
  step_pure with bu2
  step_pure with bu3
  step_pure with bu4
  step_pure with bu5
  step_pattern using runBodyFrom_mulRowsRun (lanes6 U) with uv3
  -- `v6 = v3^2`, `v7 = v6 v`, `uv7 = u v7`
  step_pattern using runBodyFrom_r43SqrRun with v6
  step_pattern using runBodyFrom_mulRun with v7
  step_pure
  step_pattern using runBodyFrom_mulRowsRun (lanes6 U) with uv7
  have hroom7 := hS ▸ hroom__uv7
  step_store
  -- `fd_f25519_pow22523( r, uv7 )`, `r = r uv3`
  step_call using Firedancer.Lane.Mlir.fd_f25519_pow22523.call_eq
  step_load with R0
  step_pure with br0
  step_pure with br1
  step_pure with br2
  step_pure with br3
  step_pure with br4
  step_pure with br5
  step_pattern using runBodyFrom_mulRowsRun (lanes6 R0) with R1
  step_store
  -- `check = r^2 v`
  step_pattern using runBodyFrom_r43SqrRun with c1
  step_load with V'
  step_pattern using runBodyFrom_mulRun with check
  -- `u_neg = -u`, `u_neg_sqrtm1 = u_neg √-1`
  step_load with U'
  refine tail_if r u v _ _ _ _ S E hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads)
    (by env_reads) fun E hA hL hP h712 h729 h803 => ?_
  refine tail_abs r u v _ _ _ _ S E hA hL hP h712 h729 h803 fun E hA hP h712 h729 h912 => ?_
  step_store
  -- `return correct_sign_sqrt|flipped_sign_sqrt`
  step_pure with ret
  step_pure with ret32
  step_pure
  finish_block
  simp [hS]
  erase_frame
  -- the loads, the temporary's read-back, the inlined `neg`, `if`, `abs` and the flags
  have eU (k : Nat) (hk : k < 6) : (lanes6 U)[k] = (S₀.mem.readVec u)[k] := by
    rw [hU]
    exact lanes6_readAt _ _ k hk
  rw [fd_r43x6_mul_congr_left _ eU] at huv3 huv7
  have eP (k : Nat) (hk : k < 6) : (lanes6 R0)[k] = (fd_f25519_pow22523.spec uv7)[k] := by
    rw [hR0, lanes6_packLanes _ k hk,
      MemoryState.readVec_packLanes (MemoryState.readAt_storeAt_self hroom7 _)]
  rw [fd_r43x6_mul_congr_left _ eP] at hR1
  have eret : ret32 = fd_f25519_eq.spec check U' ||| fd_f25519_eq.spec check (neg U') := by
    rw [hret32, hret]
    exact or_compiled (eq_spec_01 _ _) (eq_spec_01 _ _)
  rw [MemoryState.storeVec, MemoryState.storeVec, MemoryState.storeAt_storeAt_self,
    MemoryState.storeAt_storeAt_self, eret]
  subst hcheck hc1 hV' hR1 huv3 huv7 hv7 hv6 hv3 hv2 hV hU'
  delta fd_f25519_sqrt_ratio.spec
  exact ⟨rfl, rfl⟩

end fd_f25519_sqrt_ratio

end Proof

end MLIR.Firedancer.Lane

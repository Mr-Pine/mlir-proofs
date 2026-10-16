module

public import Firedancer.Bn254.Math.Limbs
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.LinearCombination
import Mathlib.Data.ZMod.Basic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `fd_uint256_mul_mod_p` (portable CIOS): on inputs below `p < 2^254` it returns the canonical
`a · b · 2⁻²⁵⁶ mod p`. -/

namespace Firedancer.Bn254

/-! ## Carry primitives -/

public theorem toNat_mul_lo_hi (x y : BitVec 64) :
    ((x.setWidth 128 * y.setWidth 128).setWidth 64).toNat +
        (((x.setWidth 128 * y.setWidth 128) >>> 64).setWidth 64).toNat * 2 ^ 64 =
      x.toNat * y.toNat := by
  have hxy : x.toNat * y.toNat < 2 ^ 128 := by
    have := Nat.mul_lt_mul'' x.isLt y.isLt; omega
  simp only [BitVec.toNat_setWidth, BitVec.toNat_mul, BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (a := x.toNat)
      (by
        have := x.isLt; omega),
    Nat.mod_eq_of_lt (a := y.toNat)
      (by
        have := y.isLt; omega),
    Nat.mod_eq_of_lt hxy, Nat.mod_eq_of_lt (a := x.toNat * y.toNat / 2 ^ 64) (by omega)]
  omega

public theorem vec_mul_lo_hi (a : Vector (BitVec 64) 4) (b : BitVec 64) (j : ℕ) (hj : j < 4) :
    (fd_ulong_vec_mul.spec a b).1[j].toNat + (fd_ulong_vec_mul.spec a b).2[j].toNat * 2 ^ 64 =
      a[j].toNat * b.toNat := by
  interval_cases j <;> exact toNat_mul_lo_hi _ _

public theorem add_carry4_lo_hi (a0 a1 a2 : BitVec 64) (a3 : BitVec 8) :
    (fd_ulong_add_carry4.spec a0 a1 a2 a3).1.toNat +
          (fd_ulong_add_carry4.spec a0 a1 a2 a3).2.toNat * 2 ^ 64 =
        a0.toNat + a1.toNat + a2.toNat + a3.toNat ∧
      (fd_ulong_add_carry4.spec a0 a1 a2 a3).2.toNat < 4 := by
  have := a0.isLt; have := a1.isLt; have := a2.isLt; have := a3.isLt
  simp only [fd_ulong_add_carry4.spec, BitVec.toNat_setWidth, BitVec.toNat_add,
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (a := a0.toNat) (by omega), Nat.mod_eq_of_lt (a := a1.toNat) (by omega),
    Nat.mod_eq_of_lt (a := a2.toNat) (by omega), Nat.mod_eq_of_lt (a := a3.toNat) (by omega)]
  constructor <;> omega

public theorem vec4_eta {α : Type} (t : Vector α 4) : t = #v[t[0], t[1], t[2], t[3]] := by
  ext i hi; interval_cases i <;> rfl

/-- One CIOS iteration with every read resolved to an input. -/
public theorem iter_eq (a p : Vector (BitVec 64) 4) (p_inv bi t0 t1 t2 t3 : BitVec 64) :
    fd_uint256_mul_mod_p.iter a p p_inv #v[t0, t1, t2, t3] bi =
      let v := fd_ulong_vec_mul.spec a bi
      let c0 := fd_ulong_add_carry4.spec t0 v.1[0] 0 0
      let c1 := fd_ulong_add_carry4.spec t1 v.1[1] v.2[0] c0.2
      let c2 := fd_ulong_add_carry4.spec t2 v.1[2] v.2[1] c1.2
      let c3 := fd_ulong_add_carry4.spec t3 v.1[3] v.2[2] c2.2
      let w := fd_ulong_vec_mul.spec p (c0.1 * p_inv)
      let d0 := fd_ulong_add_carry4.spec c0.1 w.1[0] 0 0
      let d1 := fd_ulong_add_carry4.spec c1.1 w.1[1] w.2[0] d0.2
      let d2 := fd_ulong_add_carry4.spec c2.1 w.1[2] w.2[1] d1.2
      let d3 := fd_ulong_add_carry4.spec c3.1 w.1[3] w.2[2] d2.2
      #v[d1.1, d2.1, d3.1, v.2[3] + w.2[3] + c3.2.setWidth 64 + d3.2.setWidth 64] :=
  rfl

/-- Montgomery's `m` clears the low limb. -/
public theorem redc_low (c p0 p_inv : BitVec 64)
    (hinv : (p0.toNat * p_inv.toNat) % 2 ^ 64 = 2 ^ 64 - 1) :
    (c.toNat + p0.toNat * (c * p_inv).toNat) % 2 ^ 64 = 0 := by
  have hinv' : p0.toNat * p_inv.toNat + 1 ≡ 0 [MOD 2 ^ 64] := by
    unfold Nat.ModEq; omega
  have hm' : (c * p_inv).toNat ≡ c.toNat * p_inv.toNat [MOD 2 ^ 64] := by
    rw [BitVec.toNat_mul]; exact Nat.mod_modEq _ _
  have key : c.toNat + p0.toNat * (c * p_inv).toNat ≡ 0 [MOD 2 ^ 64] :=
    calc
      c.toNat + p0.toNat * (c * p_inv).toNat ≡ c.toNat + p0.toNat * (c.toNat * p_inv.toNat) [MOD
          2 ^ 64] :=
        Nat.ModEq.add_left _ (Nat.ModEq.mul_left _ hm')
      _ = c.toNat * (p0.toNat * p_inv.toNat + 1) := by ring
      _ ≡ c.toNat * 0 [MOD 2 ^ 64] := Nat.ModEq.mul_left _ hinv'
  exact key

public theorem low_zero {d e c w1 w2 x : ℕ} (hd : d < 2 ^ 64) (f0 : d + e * 2 ^ 64 = c + w1)
    (hw : w1 + w2 * 2 ^ 64 = x) (key : (c + x) % 2 ^ 64 = 0) : d = 0 := by omega

public theorem toNat_top (x y : BitVec 64) (c d : BitVec 8)
    (h : x.toNat + y.toNat + c.toNat + d.toNat < 2 ^ 64) :
    (x + y + c.setWidth 64 + d.setWidth 64).toNat = x.toNat + y.toNat + c.toNat + d.toNat := by
  have := c.isLt; have := d.isLt
  simp only [BitVec.toNat_add, BitVec.toNat_setWidth]
  omega

/-- The CIOS top limb cannot wrap when the full sum is below `2^320`. -/
public theorem top_bound
    {t0 t1 t2 t3 v10 v11 v12 v13 v20 v21 v22 v23 w10 w11 w12 w13 w20 w21 w22 w23 c01 c02 c11 c12 c21
      c22 c31 c32 d01 d02 d11 d12 d21 d22 d31 d32 ab0 ab1 ab2 ab3 pm0 pm1 pm2 pm3 : ℕ}
    (e0 : c01 + c02 * 2 ^ 64 = t0 + v10) (e1 : c11 + c12 * 2 ^ 64 = t1 + v11 + v20 + c02)
    (e2 : c21 + c22 * 2 ^ 64 = t2 + v12 + v21 + c12)
    (e3 : c31 + c32 * 2 ^ 64 = t3 + v13 + v22 + c22) (f0 : d01 + d02 * 2 ^ 64 = c01 + w10)
    (f1 : d11 + d12 * 2 ^ 64 = c11 + w11 + w20 + d02)
    (f2 : d21 + d22 * 2 ^ 64 = c21 + w12 + w21 + d12)
    (f3 : d31 + d32 * 2 ^ 64 = c31 + w13 + w22 + d22) (hv0 : v10 + v20 * 2 ^ 64 = ab0)
    (hv1 : v11 + v21 * 2 ^ 64 = ab1) (hv2 : v12 + v22 * 2 ^ 64 = ab2)
    (hv3 : v13 + v23 * 2 ^ 64 = ab3) (hw0 : w10 + w20 * 2 ^ 64 = pm0)
    (hw1 : w11 + w21 * 2 ^ 64 = pm1) (hw2 : w12 + w22 * 2 ^ 64 = pm2)
    (hw3 : w13 + w23 * 2 ^ 64 = pm3)
    (hb :
      t0 + t1 * 2 ^ 64 + t2 * 2 ^ 128 + t3 * 2 ^ 192 + ab0 + ab1 * 2 ^ 64 + ab2 * 2 ^ 128 +
          ab3 * 2 ^ 192 +
          pm0 +
          pm1 * 2 ^ 64 +
          pm2 * 2 ^ 128 +
          pm3 * 2 ^ 192 <
        2 ^ 256 * 2 ^ 64) :
    v23 + w23 + c32 + d32 < 2 ^ 64 := by omega

/-- The CIOS iteration's value identity, carries and products as variables. -/
public theorem cios_eq
    {t0 t1 t2 t3 v10 v11 v12 v13 v20 v21 v22 v23 w10 w11 w12 w13 w20 w21 w22 w23 c01 c02 c11 c12 c21
      c22 c31 c32 d01 d02 d11 d12 d21 d22 d31 d32 ab0 ab1 ab2 ab3 pm0 pm1 pm2 pm3 : ℕ}
    (e0 : c01 + c02 * 2 ^ 64 = t0 + v10) (e1 : c11 + c12 * 2 ^ 64 = t1 + v11 + v20 + c02)
    (e2 : c21 + c22 * 2 ^ 64 = t2 + v12 + v21 + c12)
    (e3 : c31 + c32 * 2 ^ 64 = t3 + v13 + v22 + c22) (f0 : d01 + d02 * 2 ^ 64 = c01 + w10)
    (f1 : d11 + d12 * 2 ^ 64 = c11 + w11 + w20 + d02)
    (f2 : d21 + d22 * 2 ^ 64 = c21 + w12 + w21 + d12)
    (f3 : d31 + d32 * 2 ^ 64 = c31 + w13 + w22 + d22) (hv0 : v10 + v20 * 2 ^ 64 = ab0)
    (hv1 : v11 + v21 * 2 ^ 64 = ab1) (hv2 : v12 + v22 * 2 ^ 64 = ab2)
    (hv3 : v13 + v23 * 2 ^ 64 = ab3) (hw0 : w10 + w20 * 2 ^ 64 = pm0)
    (hw1 : w11 + w21 * 2 ^ 64 = pm1) (hw2 : w12 + w22 * 2 ^ 64 = pm2)
    (hw3 : w13 + w23 * 2 ^ 64 = pm3) (hd0 : d01 = 0) :
    (d11 + d21 * 2 ^ 64 + d31 * 2 ^ 128 + (v23 + w23 + c32 + d32) * 2 ^ 192) * 2 ^ 64 =
      t0 + t1 * 2 ^ 64 + t2 * 2 ^ 128 + t3 * 2 ^ 192 +
        (ab0 + ab1 * 2 ^ 64 + ab2 * 2 ^ 128 + ab3 * 2 ^ 192) +
        (pm0 + pm1 * 2 ^ 64 + pm2 * 2 ^ 128 + pm3 * 2 ^ 192) := by
  omega

public theorem iter_spec (a p t : Vector (BitVec 64) 4) (p_inv bi : BitVec 64)
    (hinv : (p[0].toNat * p_inv.toNat) % 2 ^ 64 = 2 ^ 64 - 1)
    (hb : limbsEval t + limbsEval a * bi.toNat + 2 ^ 64 * limbsEval p < 2 ^ 256 * 2 ^ 64) :
    ∃ m < 2 ^ 64,
      limbsEval (fd_uint256_mul_mod_p.iter a p p_inv t bi) * 2 ^ 64 =
        limbsEval t + limbsEval a * bi.toNat + m * limbsEval p := by
  have hv := vec_mul_lo_hi a bi
  have hw := vec_mul_lo_hi p
  rw [vec4_eta t, iter_eq] at *
  simp only [limbsEval_four, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ] at hb ⊢
  generalize fd_ulong_vec_mul.spec a bi = v at hv ⊢
  obtain ⟨e0, b0⟩ := add_carry4_lo_hi t[0] v.1[0] 0 0
  generalize fd_ulong_add_carry4.spec t[0] v.1[0] 0 0 = c0 at e0 b0 ⊢
  obtain ⟨e1, b1⟩ := add_carry4_lo_hi t[1] v.1[1] v.2[0] c0.2
  generalize fd_ulong_add_carry4.spec t[1] v.1[1] v.2[0] c0.2 = c1 at e1 b1 ⊢
  obtain ⟨e2, b2⟩ := add_carry4_lo_hi t[2] v.1[2] v.2[1] c1.2
  generalize fd_ulong_add_carry4.spec t[2] v.1[2] v.2[1] c1.2 = c2 at e2 b2 ⊢
  obtain ⟨e3, b3⟩ := add_carry4_lo_hi t[3] v.1[3] v.2[2] c2.2
  generalize fd_ulong_add_carry4.spec t[3] v.1[3] v.2[2] c2.2 = c3 at e3 b3 ⊢
  have key := redc_low c0.1 p[0] p_inv hinv
  refine ⟨(c0.1 * p_inv).toNat, BitVec.isLt _, ?_⟩
  have hw := hw (c0.1 * p_inv)
  generalize c0.1 * p_inv = m at key hw ⊢
  generalize fd_ulong_vec_mul.spec p m = w at hw ⊢
  obtain ⟨f0, g0⟩ := add_carry4_lo_hi c0.1 w.1[0] 0 0
  generalize fd_ulong_add_carry4.spec c0.1 w.1[0] 0 0 = d0 at f0 g0 ⊢
  obtain ⟨f1, g1⟩ := add_carry4_lo_hi c1.1 w.1[1] w.2[0] d0.2
  generalize fd_ulong_add_carry4.spec c1.1 w.1[1] w.2[0] d0.2 = d1 at f1 g1 ⊢
  obtain ⟨f2, g2⟩ := add_carry4_lo_hi c2.1 w.1[2] w.2[1] d1.2
  generalize fd_ulong_add_carry4.spec c2.1 w.1[2] w.2[1] d1.2 = d2 at f2 g2 ⊢
  obtain ⟨f3, g3⟩ := add_carry4_lo_hi c3.1 w.1[3] w.2[2] d2.2
  generalize fd_ulong_add_carry4.spec c3.1 w.1[3] w.2[2] d2.2 = d3 at f3 g3 ⊢
  have hv0 := hv 0 (by omega); have hv1 := hv 1 (by omega)
  have hv2 := hv 2 (by omega); have hv3 := hv 3 (by omega)
  have hw0 := hw 0 (by omega); have hw1 := hw 1 (by omega)
  have hw2 := hw 2 (by omega); have hw3 := hw 3 (by omega)
  clear hv hw
  simp only [show (0 : BitVec 8).toNat = 0 from rfl, show (0 : BitVec 64).toNat = 0 from rfl,
    add_zero] at e0 f0
  have hd0 := low_zero d0.1.isLt f0 hw0 key
  have hA :
    (a[0].toNat + a[1].toNat * 2 ^ 64 + a[2].toNat * 2 ^ 128 + a[3].toNat * 2 ^ 192) * bi.toNat =
      a[0].toNat * bi.toNat + a[1].toNat * bi.toNat * 2 ^ 64 + a[2].toNat * bi.toNat * 2 ^ 128 +
        a[3].toNat * bi.toNat * 2 ^ 192 := by
    ring
  have hP :
    m.toNat * (p[0].toNat + p[1].toNat * 2 ^ 64 + p[2].toNat * 2 ^ 128 + p[3].toNat * 2 ^ 192) =
      p[0].toNat * m.toNat + p[1].toNat * m.toNat * 2 ^ 64 + p[2].toNat * m.toNat * 2 ^ 128 +
        p[3].toNat * m.toNat * 2 ^ 192 := by
    ring
  have hmP :=
    Nat.mul_le_mul_right
      (p[0].toNat + p[1].toNat * 2 ^ 64 + p[2].toNat * 2 ^ 128 + p[3].toNat * 2 ^ 192)
      (le_of_lt m.isLt)
  clear key
  have hb' :
    t[0].toNat + t[1].toNat * 2 ^ 64 + t[2].toNat * 2 ^ 128 + t[3].toNat * 2 ^ 192 +
        a[0].toNat * bi.toNat +
        a[1].toNat * bi.toNat * 2 ^ 64 +
        a[2].toNat * bi.toNat * 2 ^ 128 +
        a[3].toNat * bi.toNat * 2 ^ 192 +
        p[0].toNat * m.toNat +
        p[1].toNat * m.toNat * 2 ^ 64 +
        p[2].toNat * m.toNat * 2 ^ 128 +
        p[3].toNat * m.toNat * 2 ^ 192 <
      2 ^ 256 * 2 ^ 64 := by
    linarith
  have hX := top_bound e0 e1 e2 e3 f0 f1 f2 f3 hv0 hv1 hv2 hv3 hw0 hw1 hw2 hw3 hb'
  rw [toNat_top _ _ _ _ hX, hA, hP]
  exact cios_eq e0 e1 e2 e3 f0 f1 f2 f3 hv0 hv1 hv2 hv3 hw0 hw1 hw2 hw3 hd0

/-! ## The conditional subtraction -/

public theorem sub_borrow_lo_hi (a0 a1 : BitVec 64) (bi : BitVec 32) (hbi : bi = 0 ∨ bi = 1) :
    (fd_ulong_sub_borrow.spec a0 a1 bi).1.toNat + a1.toNat + bi.toNat =
        a0.toNat + (fd_ulong_sub_borrow.spec a0 a1 bi).2.toNat * 2 ^ 64 ∧
      ((fd_ulong_sub_borrow.spec a0 a1 bi).2 = 0 ∨ (fd_ulong_sub_borrow.spec a0 a1 bi).2 = 1) := by
  have hbv :
    ((fd_ulong_sub_borrow.spec a0 a1 bi).1.setWidth 66 + a1.setWidth 66 + bi.setWidth 66 =
        a0.setWidth 66 + (fd_ulong_sub_borrow.spec a0 a1 bi).2.setWidth 66 <<< 64) ∧
      ((fd_ulong_sub_borrow.spec a0 a1 bi).2 = 0 ∨ (fd_ulong_sub_borrow.spec a0 a1 bi).2 = 1) := by
    unfold fd_ulong_sub_borrow.spec; dsimp only; rcases hbi with rfl | rfl <;> bv_decide
  refine ⟨?_, hbv.2⟩
  have h := congrArg BitVec.toNat hbv.1
  have := a0.isLt; have := a1.isLt; have := (fd_ulong_sub_borrow.spec a0 a1 bi).1.isLt
  have hb2 : (fd_ulong_sub_borrow.spec a0 a1 bi).2.toNat ≤ 1 := by
    rcases hbv.2 with h | h <;> rw [h] <;> decide
  have hbi' : bi.toNat ≤ 1 := by rcases hbi with rfl | rfl <;> decide
  simp only [BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_shiftLeft] at h
  rw [Nat.shiftLeft_eq] at h
  omega

/-- The borrow chain on `#v[x0, x1, x2, x3]`, every read resolved. -/
public theorem sub_chain_eq (x0 x1 x2 x3 : BitVec 64) (p : fd_uint256_t) :
    (let r : fd_uint256_t := #v[x0, x1, x2, x3]
     let b : BitVec 32 := 0
      let (r0, b) := fd_ulong_sub_borrow.spec r[0] p[0] b
      let r := r.set 0 r0
      let (r1, b) := fd_ulong_sub_borrow.spec r[1] p[1] b
      let r := r.set 1 r1
      let (r2, b) := fd_ulong_sub_borrow.spec r[2] p[2] b
      let r := r.set 2 r2
      let (r3, _b) := fd_ulong_sub_borrow.spec r[3] p[3] b
      let r := r.set 3 r3
      r) =
      let s0 := fd_ulong_sub_borrow.spec x0 p[0] 0
      let s1 := fd_ulong_sub_borrow.spec x1 p[1] s0.2
      let s2 := fd_ulong_sub_borrow.spec x2 p[2] s1.2
      let s3 := fd_ulong_sub_borrow.spec x3 p[3] s2.2
      #v[s0.1, s1.1, s2.1, s3.1] :=
  rfl

public theorem sub_chain_val (x0 x1 x2 x3 : BitVec 64) (p : fd_uint256_t)
    (h : limbsEval p ≤ limbsEval #v[x0, x1, x2, x3]) :
    limbsEval
        (let s0 := fd_ulong_sub_borrow.spec x0 p[0] 0
         let s1 := fd_ulong_sub_borrow.spec x1 p[1] s0.2
         let s2 := fd_ulong_sub_borrow.spec x2 p[2] s1.2
         let s3 := fd_ulong_sub_borrow.spec x3 p[3] s2.2
         #v[s0.1, s1.1, s2.1, s3.1]) =
      limbsEval #v[x0, x1, x2, x3] - limbsEval p := by
  dsimp only
  obtain ⟨e0, b0⟩ := sub_borrow_lo_hi x0 p[0] 0 (.inl rfl)
  generalize fd_ulong_sub_borrow.spec x0 p[0] 0 = s0 at e0 b0 ⊢
  obtain ⟨e1, b1⟩ := sub_borrow_lo_hi x1 p[1] s0.2 b0
  generalize fd_ulong_sub_borrow.spec x1 p[1] s0.2 = s1 at e1 b1 ⊢
  obtain ⟨e2, b2⟩ := sub_borrow_lo_hi x2 p[2] s1.2 b1
  generalize fd_ulong_sub_borrow.spec x2 p[2] s1.2 = s2 at e2 b2 ⊢
  obtain ⟨e3, b3⟩ := sub_borrow_lo_hi x3 p[3] s2.2 b2
  generalize fd_ulong_sub_borrow.spec x3 p[3] s2.2 = s3 at e3 b3 ⊢
  simp only [limbsEval_four, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ] at h ⊢
  have := s0.1.isLt; have := s1.1.isLt; have := s2.1.isLt; have := s3.1.isLt
  rcases b0 with h0 | h0 <;> rcases b1 with h1 | h1 <;> rcases b2 with h2 | h2 <;>
    rcases b3 with h3 | h3 <;>
    simp only [h0, h1, h2, h3] at e0 e1 e2 e3 <;>
    simp only [show (0 : BitVec 32).toNat = 0 from rfl,
      show (1 : BitVec 32).toNat = 1 from rfl] at e0 e1 e2 e3 <;>
    omega

/-! ## `fd_uint256_mul_mod_p` -/

public theorem cios_pre {T A b P : ℕ} (hT : T < 2 * P) (hA : A < P) (hb : b < 2 ^ 64)
    (hP : P < 2 ^ 254) : T + A * b + 2 ^ 64 * P < 2 ^ 256 * 2 ^ 64 := by
  have := Nat.mul_le_mul hA.le hb.le
  omega

public theorem cios_step_bound {T A b m P T' : ℕ} (hT : T < 2 * P) (hA : A < P) (hb : b < 2 ^ 64)
    (hm : m < 2 ^ 64) (h : T' * 2 ^ 64 = T + A * b + m * P) : T' < 2 * P := by
  obtain ⟨Q, rfl⟩ : ∃ Q, P = Q + 1 := ⟨P - 1, by omega⟩
  have h1 := Nat.mul_le_mul (Nat.le_of_lt_succ hA) (Nat.le_sub_one_of_lt hb)
  have h2 := Nat.mul_le_mul_right (Q + 1) (Nat.le_sub_one_of_lt hm)
  omega

/-- The tail of `fd_uint256_mul_mod_p` after the loop: copy out of `t`, subtract `p` if `≥ p`. -/
@[expose]
public def mulFinish (p t : fd_uint256_t) : fd_uint256_t :=
  let r : fd_uint256_t := #v[t[0], t[1], t[2], t[3]]
  if (0#32).sle (fd_uint256_cmp.spec r p) then
    let b : BitVec 32 := 0
    let (r0, b) := fd_ulong_sub_borrow.spec r[0] p[0] b
    let r := r.set 0 r0
    let (r1, b) := fd_ulong_sub_borrow.spec r[1] p[1] b
    let r := r.set 1 r1
    let (r2, b) := fd_ulong_sub_borrow.spec r[2] p[2] b
    let r := r.set 2 r2
    let (r3, _b) := fd_ulong_sub_borrow.spec r[3] p[3] b
    let r := r.set 3 r3
    r
  else r

public theorem spec_eq_mulFinish (a b p : fd_uint256_t) (p_inv : BitVec 64) :
    fd_uint256_mul_mod_p.spec a b p p_inv =
      mulFinish p
        (fd_uint256_mul_mod_p.iter a p p_inv
          (fd_uint256_mul_mod_p.iter a p p_inv
            (fd_uint256_mul_mod_p.iter a p p_inv
              (fd_uint256_mul_mod_p.iter a p p_inv #v[0, 0, 0, 0] b[0]) b[1])
            b[2])
          b[3]) :=
  rfl

public theorem mulFinish_eq (p t : fd_uint256_t) :
    mulFinish p t =
      if (0#32).sle (fd_uint256_cmp.spec #v[t[0], t[1], t[2], t[3]] p) then
        let s0 := fd_ulong_sub_borrow.spec t[0] p[0] 0
        let s1 := fd_ulong_sub_borrow.spec t[1] p[1] s0.2
        let s2 := fd_ulong_sub_borrow.spec t[2] p[2] s1.2
        let s3 := fd_ulong_sub_borrow.spec t[3] p[3] s2.2
        #v[s0.1, s1.1, s2.1, s3.1]
      else #v[t[0], t[1], t[2], t[3]] :=
  rfl

public theorem mulFinish_val {p t : fd_uint256_t} {x : ZMod (limbsEval p)}
    (ht : limbsEval t < 2 * limbsEval p) (hx : (limbsEval t : ZMod (limbsEval p)) = x) :
    limbsEval (mulFinish p t) < limbsEval p ∧
      (limbsEval (mulFinish p t) : ZMod (limbsEval p)) = x := by
  rw [vec4_eta t] at ht hx
  rw [mulFinish_eq, fd_uint256_cmp.spec_sle]
  by_cases hc : limbsEval p ≤ limbsEval #v[t[0], t[1], t[2], t[3]]
  · simp only [decide_eq_true hc, ↓reduceIte]
    rw [sub_chain_val _ _ _ _ _ hc]
    refine ⟨by omega, ?_⟩
    rw [Nat.cast_sub hc, ZMod.natCast_self, sub_zero, hx]
  · simp only [decide_eq_false hc, Bool.false_eq_true, ↓reduceIte]
    exact ⟨by omega, hx⟩

/-- CIOS `fd_uint256_mul_mod_p` on `a < p < 2^254`: the canonical `a · b · 2⁻²⁵⁶ mod p`. -/
public theorem fd_uint256_mul_mod_p.spec_val (a b p : fd_uint256_t) (p_inv : BitVec 64)
    (hinv : (p[0].toNat * p_inv.toNat) % 2 ^ 64 = 2 ^ 64 - 1) (hp : limbsEval p < 2 ^ 254)
    (ha : limbsEval a < limbsEval p) :
    limbsEval (fd_uint256_mul_mod_p.spec a b p p_inv) < limbsEval p ∧
      (limbsEval (fd_uint256_mul_mod_p.spec a b p p_inv) : ZMod (limbsEval p)) * 2 ^ 256 =
        (limbsEval a : ZMod (limbsEval p)) * limbsEval b := by
  have hb0 := b[0].isLt; have hb1 := b[1].isLt; have hb2 := b[2].isLt; have hb3 := b[3].isLt
  have h0 : limbsEval (#v[0, 0, 0, 0] : Vector (BitVec 64) 4) = 0 := by simp [limbsEval_four]
  obtain ⟨m0, hm0, e0⟩ :=
    iter_spec a p #v[0, 0, 0, 0] p_inv b[0] hinv (cios_pre (by omega) ha hb0 hp)
  have t1 := cios_step_bound (by omega) ha hb0 hm0 e0
  obtain ⟨m1, hm1, e1⟩ := iter_spec a p _ p_inv b[1] hinv (cios_pre t1 ha hb1 hp)
  have t2 := cios_step_bound t1 ha hb1 hm1 e1
  obtain ⟨m2, hm2, e2⟩ := iter_spec a p _ p_inv b[2] hinv (cios_pre t2 ha hb2 hp)
  have t3 := cios_step_bound t2 ha hb2 hm2 e2
  obtain ⟨m3, hm3, e3⟩ := iter_spec a p _ p_inv b[3] hinv (cios_pre t3 ha hb3 hp)
  have t4 := cios_step_bound t3 ha hb3 hm3 e3
  rw [h0] at e0
  have c0 := congrArg (Nat.cast : ℕ → ZMod (limbsEval p)) e0
  have c1 := congrArg (Nat.cast : ℕ → ZMod (limbsEval p)) e1
  have c2 := congrArg (Nat.cast : ℕ → ZMod (limbsEval p)) e2
  have c3 := congrArg (Nat.cast : ℕ → ZMod (limbsEval p)) e3
  push_cast [ZMod.natCast_self] at c0 c1 c2 c3
  rw [spec_eq_mulFinish]
  obtain ⟨hlt, hval⟩ := mulFinish_val t4 rfl
  refine ⟨hlt, ?_⟩
  rw [hval, limbsEval_four b]
  push_cast
  linear_combination
    c0 + (2 : ZMod (limbsEval p)) ^ 64 * c1 + (2 : ZMod (limbsEval p)) ^ 128 * c2 +
      (2 : ZMod (limbsEval p)) ^ 192 * c3

end Firedancer.Bn254

module

public import Firedancer.Ref.fd_f25519_posdivsteps_62_var
import Mathlib.Data.Nat.ModEq
public import Mathlib.NumberTheory.LegendreSymbol.JacobiSymbol
import Std.Tactic.BVDecide

/-! `fd_f25519_posdivsteps_62_var` on the low 64 bits of odd `F` and any `G`: a transition matrix
with nonnegative rows of sum at most `2^62` taking `(F, G)` to `2^62 (F', G')`, `F'` odd, and the
Jacobi symbol `J(G | F)` times the sign of `jac`'s bit 0 kept. -/

namespace MLIR.Firedancer.Ref

open fd_f25519_posdivsteps_62_var

/-! ## Signs -/

@[expose] public section

/-- The sign a bit stands for: `-1` when set. -/
def bitSign (b : Bool) : ℤ :=
  if b then -1 else 1

end

public theorem bitSign_xor (a b : Bool) : bitSign (a ^^ b) = bitSign a * bitSign b := by
  cases a <;> cases b <;> rfl

public theorem bitSign_mul_self (a : Bool) : bitSign a * bitSign a = 1 := by cases a <;> rfl

/-! ## The Jacobi symbol's moves -/

/-- Dividing `G` by `2^z`: a sign for odd `z` and `F ≡ 3, 5 (mod 8)`. -/
public theorem jacobi_shift {F G₁ : ℕ} (hF : F % 2 = 1) (z : ℕ) :
    jacobiSym ((2 ^ z * G₁ : ℕ) : ℤ) F =
      bitSign (decide (z % 2 = 1) && decide (F % 8 = 3 ∨ F % 8 = 5)) * jacobiSym G₁ F := by
  push_cast
  rw [jacobiSym.mul_left, jacobiSym.pow_left, jacobiSym.at_two (Nat.odd_iff.2 hF),
    ZMod.χ₈_nat_eq_if_mod_eight]
  have h8 : F % 8 = 1 ∨ F % 8 = 3 ∨ F % 8 = 5 ∨ F % 8 = 7 := by omega
  have h2 : F % 2 ≠ 0 := by omega
  rcases Nat.even_or_odd z with he | ho
  · have : z % 2 = 0 := Nat.even_iff.1 he
    rcases h8 with h | h | h | h <;> simp [h2, h, this, bitSign, he.neg_one_pow]
  · have : z % 2 = 1 := Nat.odd_iff.1 ho
    rcases h8 with h | h | h | h <;> simp [h2, h, this, bitSign, ho.neg_one_pow]

/-- Swapping odd `F` and `G`: a sign when both are `3 (mod 4)`. -/
public theorem jacobi_swap {F G : ℕ} (hF : F % 2 = 1) (hG : G % 2 = 1) :
    jacobiSym G F = bitSign (decide (F % 4 = 3) && decide (G % 4 = 3)) * jacobiSym F G := by
  rw [← jacobiSym.quadratic_reciprocity_if hG hF]
  by_cases h : G % 4 = 3 ∧ F % 4 = 3
  · simp [h, bitSign]
  · rw [ite_eq_right h]
    have : ¬(F % 4 = 3 ∧ G % 4 = 3) := fun h' => h ⟨h'.2, h'.1⟩
    have e : (decide (F % 4 = 3) && decide (G % 4 = 3)) = false := by simpa using this
    rw [e]
    simp [bitSign]

/-- Adding a multiple of `F` to `G`. -/
public theorem jacobi_add (F G w : ℕ) : jacobiSym ((G + w * F : ℕ) : ℤ) F = jacobiSym G F := by
  apply jacobiSym.mod_left'
  push_cast
  exact Int.add_mul_emod_self_right _ _ _

namespace fd_f25519_posdivsteps_62_var

/-! ## Bits -/

theorem modEq_of_mod {a b m : ℕ} (hm : m ≤ 64) (h : a = b % 2 ^ 64) : a ≡ b [MOD 2 ^ m] := by
  subst h
  exact (Nat.mod_modEq _ _).of_dvd (Nat.pow_dvd_pow 2 hm)

theorem add_modEq (a b : BitVec 64) {m : ℕ} (hm : m ≤ 64) :
    (a + b).toNat ≡ a.toNat + b.toNat [MOD 2 ^ m] :=
  modEq_of_mod hm (BitVec.toNat_add a b)

theorem mul_modEq (a b : BitVec 64) {m : ℕ} (hm : m ≤ 64) :
    (a * b).toNat ≡ a.toNat * b.toNat [MOD 2 ^ m] :=
  modEq_of_mod hm (BitVec.toNat_mul a b)

/-- `find_lsb( g | (ULONG_MAX << i) )` for `1 ≤ i ≤ 62`: `z ≤ i` low zero bits of `g`, a set bit
`z` below `i`, and every count of low zero bits up to `i` at most `z`. -/
theorem zeros_spec (g : BitVec 64) {n : ℕ} (h1 : 1 ≤ n) (h62 : n ≤ 62) :
    ∃ z,
      fd_ulong_find_lsb.spec (g ||| BitVec.allOnes 64 <<< n) = BitVec.ofNat 32 z ∧
        z ≤ n ∧
        g.toNat % 2 ^ z = 0 ∧
        (z < n → g.toNat / 2 ^ z % 2 = 1) ∧ ∀ c ≤ n, g.toNat % 2 ^ c = 0 → c ≤ z := by
  set y := g ||| BitVec.allOnes 64 <<< n with hy
  have hbit (k : ℕ) (hk : k < 64) : y.getLsbD k = (g.toNat.testBit k || decide (n ≤ k)) := by
    simp only [hy, BitVec.getLsbD_or, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_allOnes,
      BitVec.testBit_toNat]
    by_cases h : n ≤ k
    · simp [h, hk]; omega
    · simp [h, hk]
  have hy0 : y ≠ 0#64 := by
    intro h
    have := hbit n (by omega)
    rw [h] at this
    simp at this
  have hz := BitVec.getLsbD_true_ctz_of_ne_zero hy0
  have hzl : y.ctz.toNat ≤ n := by
    by_contra hc
    have := BitVec.getLsbD_false_of_lt_ctz (x := y) (i := n) (by omega)
    rw [hbit n (by omega)] at this
    simp at this
  have hlow (k : ℕ) (hk : k < y.ctz.toNat) : g.toNat.testBit k = false := by
    have := BitVec.getLsbD_false_of_lt_ctz hk
    rw [hbit k (by omega)] at this
    simp only [Bool.or_eq_false_iff] at this
    exact this.1
  refine ⟨y.ctz.toNat, ?_, hzl, ?_, ?_, ?_⟩
  · rw [fd_ulong_find_lsb.spec, ite_eq_right hy0]
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  · apply Nat.eq_of_testBit_eq
    intro k
    rw [Nat.testBit_mod_two_pow, Nat.zero_testBit]
    by_cases hk : k < y.ctz.toNat
    · simp [hk, hlow k hk]
    · simp [hk]
  · intro hzn
    rw [hbit _ (by omega)] at hz
    have : g.toNat.testBit y.ctz.toNat = true := by simpa [show ¬n ≤ y.ctz.toNat by omega] using hz
    rw [Nat.testBit_eq_decide_div_mod_eq] at this
    simpa using this
  · intro c hc hgc
    by_contra hlt
    rw [hbit _ (by omega)] at hz
    have : g.toNat.testBit y.ctz.toNat = true := by simpa [show ¬n ≤ y.ctz.toNat by omega] using hz
    have h2 := Nat.testBit_mod_two_pow g.toNat c y.ctz.toNat
    rw [hgc, Nat.zero_testBit, this] at h2
    simp at h2
    omega

/-! ## The pass's pieces -/

/-- The masks `(ULONG_MAX >> (64 - limit)) & 63` and `& 15`: `2^min(limit, 6) - 1`,
`2^min(limit, 4) - 1`. -/
theorem mask_spec (lim : BitVec 32) (h1 : 1 ≤ lim.toNat) (h62 : lim.toNat ≤ 62) :
    ((BitVec.allOnes 64 >>> (64#32 - lim).toNat) &&& 63#64).toNat = 2 ^ min lim.toNat 6 - 1 ∧
      ((BitVec.allOnes 64 >>> (64#32 - lim).toNat) &&& 15#64).toNat = 2 ^ min lim.toNat 4 - 1 := by
  generalize hL : lim.toNat = L at h1 h62 ⊢
  obtain rfl : lim = BitVec.ofNat 32 L := by
    rw [← hL]; simp
  interval_cases L <;> decide

/-- A mask `2^k - 1`, `1 ≤ k ≤ 6`, as `cancel6`/`cancel4` take it. -/
theorem mask_low {m : BitVec 64} {k : ℕ} (hm : m.toNat = 2 ^ k - 1) (h1 : 1 ≤ k) (h6 : k ≤ 6) :
    m &&& (m + 1#64) = 0#64 ∧ m ≤ 63#64 := by
  obtain rfl : m = BitVec.ofNat 64 (2 ^ k - 1) := by
    apply BitVec.eq_of_toNat_eq
    rw [hm, BitVec.toNat_ofNat, Nat.mod_eq_of_lt]
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) h6
    omega
  interval_cases k <;> decide

/-- Masking with `2^k - 1` keeps `k` bits. -/
theorem and_mask_toNat (x : BitVec 64) {m : BitVec 64} {k : ℕ} (hm : m.toNat = 2 ^ k - 1) :
    (x &&& m).toNat = x.toNat % 2 ^ k := by
  rw [BitVec.toNat_and, hm, Nat.and_two_pow_sub_one_eq_mod]

/-- `g + f w` cancels `k ≤ 6` low bits for odd `f`, `w` from `f g (f² - 2)`. -/
theorem cancel6 (f g m : BitVec 64) (hf : f &&& 1#64 = 1#64) (hm : m &&& (m + 1#64) = 0#64)
    (hm6 : m ≤ 63#64) : (g + f * ((f * g * (f * f - 2#64)) &&& m)) &&& m = 0#64 := by bv_decide

/-- `g + f w` cancels `k ≤ 4` low bits for odd `f`, `w` from `-(f + ((f + 1) & 4) << 1) g`. -/
theorem cancel4 (f g m : BitVec 64) (hf : f &&& 1#64 = 1#64) (hm : m &&& (m + 1#64) = 0#64)
    (hm4 : m ≤ 15#64) :
    (g + f * ((-(f + (((f + 1#64) &&& 4#64) <<< 1)) * g) &&& m)) &&& m = 0#64 := by bv_decide

/-- `fd_int_min( (int)eta + 1, i )` for `0 ≤ eta ≤ 2^30` and `1 ≤ i ≤ 62`: in `[1, i]`. -/
theorem limit_spec (e : BitVec 64) (i : BitVec 32) (he0 : 0 ≤ e.toInt) (he1 : e.toInt ≤ 2 ^ 30)
    (hi1 : 1 ≤ i.toNat) (hi62 : i.toNat ≤ 62) :
    1 ≤ (fd_int_min (e.setWidth 32 + 1#32) i).toNat ∧
      (fd_int_min (e.setWidth 32 + 1#32) i).toNat ≤ i.toNat := by
  have h0 : (0#64).sle e := by
    rw [BitVec.sle_iff_toInt_le]; simpa using he0
  have h1 : e.sle (BitVec.ofNat 64 (2 ^ 30)) := by
    rw [BitVec.sle_iff_toInt_le]
    exact he1.trans (by decide)
  have h2 : 1#32 ≤ i := by
    rw [BitVec.le_def]; simpa using hi1
  have h3 : i ≤ 62#32 := by
    rw [BitVec.le_def]; simpa using hi62
  have : 1#32 ≤ fd_int_min (e.setWidth 32 + 1#32) i ∧ fd_int_min (e.setWidth 32 + 1#32) i ≤ i := by
    unfold fd_int_min
    bv_decide
  rw [BitVec.le_def, BitVec.le_def] at this
  simpa using this

/-- `eta - zeros` without overflow. -/
theorem eta_sub (e : BitVec 64) {z : ℕ} (hz : z ≤ 62) (he : |e.toInt| ≤ 2 ^ 31) :
    (e - (BitVec.ofNat 32 z).signExtend 64).toInt = e.toInt - z := by
  have hz' : ((BitVec.ofNat 32 z).signExtend 64).toInt = z := by
    rw [BitVec.toInt_signExtend_of_le (by decide), BitVec.toInt_ofNat', Int.bmod_eq_of_le] <;>
      push_cast <;>
      omega
  rw [BitVec.toInt_sub, hz', Int.bmod_eq_of_le] <;> push_cast <;> rw [abs_le] at he <;> omega

/-- `-eta` without overflow. -/
theorem eta_neg (e : BitVec 64) (he : |e.toInt| ≤ 2 ^ 31) : (-e).toInt = -e.toInt := by
  rw [BitVec.toInt_neg, Int.bmod_eq_of_le] <;> push_cast <;> rw [abs_le] at he <;> omega

/-- `jac ^= zeros & ((f >> 1) ^ (f >> 2))` on bit 0. -/
theorem jbit_shift (j : BitVec 32) (f : BitVec 64) (z : ℕ) :
    (j ^^^ ((BitVec.ofNat 32 z).signExtend 64 &&& (f >>> 1 ^^^ f >>> 2)).setWidth 32).getLsbD 0 =
      (j.getLsbD 0 ^^ (decide (z % 2 = 1) && (f.toNat.testBit 1 ^^ f.toNat.testBit 2))) := by
  simp only [BitVec.getLsbD_xor, BitVec.getLsbD_setWidth, BitVec.getLsbD_and,
    BitVec.getLsbD_signExtend, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_ofNat,
    BitVec.testBit_toNat]
  simp [Nat.testBit_eq_decide_div_mod_eq]

/-- `jac ^= (f & g) >> 1` on bit 0. -/
theorem jbit_swap (j : BitVec 32) (a b : BitVec 64) :
    (j ^^^ ((a &&& b) >>> 1).setWidth 32).getLsbD 0 =
      (j.getLsbD 0 ^^ (a.toNat.testBit 1 && b.toNat.testBit 1)) := by
  simp only [BitVec.getLsbD_xor, BitVec.getLsbD_setWidth, BitVec.getLsbD_ushiftRight,
    BitVec.getLsbD_and, BitVec.testBit_toNat]
  simp

/-- Bits 1, 2 of the low bits of an odd `F`. -/
theorem testBit_odd {x F : ℕ} (h : x ≡ F [MOD 8]) (hF : F % 2 = 1) :
    (x.testBit 1 ^^ x.testBit 2) = decide (F % 8 = 3 ∨ F % 8 = 5) ∧
      x.testBit 1 = decide (F % 4 = 3) := by
  simp only [Nat.testBit_eq_decide_div_mod_eq, pow_one, Nat.reducePow]
  have hx : x % 8 = F % 8 := h
  have e1 : x / 2 % 2 = F % 8 / 2 % 2 := by omega
  have e2 : x / 4 % 2 = F % 8 / 4 % 2 := by omega
  have e3 : F % 4 = F % 8 % 4 := by omega
  have ho : F % 8 % 2 = 1 := by omega
  have hr : F % 8 < 8 := Nat.mod_lt _ (by decide)
  rw [e1, e2, e3]
  generalize F % 8 = r at *
  interval_cases r <;> simp_all

/-- An odd bit vector's low bit. -/
theorem and_one_of_odd {x : BitVec 64} (h : x.toNat % 2 = 1) : x &&& 1#64 = 1#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (1#64).toNat = 1 from rfl, Nat.and_one_is_mod, h]

/-- A masked value vanishes mod `2^k`. -/
theorem mod_of_and_mask {x m : BitVec 64} {k : ℕ} (hm : m.toNat = 2 ^ k - 1) (h : x &&& m = 0#64) :
    x.toNat % 2 ^ k = 0 := by
  rw [← and_mask_toNat x hm, h]
  rfl

/-- Adding `w` times the `F` row to the `G` row at scale `2^(62-n)`, `w < 2^k` cancelling `k ≤ n`
low bits of `g`: the new `G` row, its bound `2^(62-n+k)`, `g`'s low bits, `k` zero bits. -/
theorem add_step {F₀ G₀ n k : ℕ} {uA vA qA rA fA gA w : BitVec 64} {FA GA : ℕ} (hn : n ≤ 62)
    (hk : k ≤ n) (eF : uA.toNat * F₀ + vA.toNat * G₀ = 2 ^ (62 - n) * FA)
    (eG : qA.toNat * F₀ + rA.toNat * G₀ = 2 ^ (62 - n) * GA)
    (bF : uA.toNat + vA.toNat ≤ 2 ^ (62 - n)) (bG : qA.toNat + rA.toNat ≤ 2 ^ (62 - n))
    (mf : fA.toNat ≡ FA [MOD 2 ^ (n + 2)]) (mg : gA.toNat ≡ GA [MOD 2 ^ (n + 2)])
    (hw : w.toNat < 2 ^ k) (hc : (gA + fA * w).toNat % 2 ^ k = 0) :
    (qA + uA * w).toNat * F₀ + (rA + vA * w).toNat * G₀ = 2 ^ (62 - n) * (GA + w.toNat * FA) ∧
      (qA + uA * w).toNat + (rA + vA * w).toNat ≤ 2 ^ (62 - n + k) ∧
      (gA + fA * w).toNat ≡ GA + w.toNat * FA [MOD 2 ^ (n + 2)] ∧
      (GA + w.toNat * FA) % 2 ^ k = 0 := by
  have hPQ : 2 ^ (62 - n + k) = 2 ^ (62 - n) * 2 ^ k := pow_add _ _ _
  have hle : 2 ^ (62 - n + k) ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) (by omega)
  have hk1 : 1 ≤ 2 ^ k := Nat.one_le_two_pow
  have huw : uA.toNat * w.toNat + vA.toNat * w.toNat ≤ 2 ^ (62 - n) * (2 ^ k - 1) := by
    rw [← add_mul]; exact Nat.mul_le_mul bF (by omega)
  have hmul : 2 ^ (62 - n) * (2 ^ k - 1) + 2 ^ (62 - n) = 2 ^ (62 - n + k) := by
    rw [hPQ, Nat.mul_sub_one, Nat.sub_add_cancel (Nat.le_mul_of_pos_right _ (by omega))]
  have h62 : (2 : ℕ) ^ 62 < 2 ^ 64 := by decide
  have ha : uA.toNat * w.toNat ≤ 2 ^ (62 - n) * (2 ^ k - 1) := Nat.mul_le_mul (by omega) (by omega)
  have hb : vA.toNat * w.toNat ≤ 2 ^ (62 - n) * (2 ^ k - 1) := Nat.mul_le_mul (by omega) (by omega)
  have hq : (qA + uA * w).toNat = qA.toNat + uA.toNat * w.toNat := by
    rw [BitVec.toNat_add, BitVec.toNat_mul, Nat.mod_eq_of_lt (a := uA.toNat * w.toNat) (by omega),
      Nat.mod_eq_of_lt (by omega)]
  have hr : (rA + vA * w).toNat = rA.toNat + vA.toNat * w.toNat := by
    rw [BitVec.toNat_add, BitVec.toNat_mul, Nat.mod_eq_of_lt (a := vA.toNat * w.toNat) (by omega),
      Nat.mod_eq_of_lt (by omega)]
  have mg' : (gA + fA * w).toNat ≡ GA + w.toNat * FA [MOD 2 ^ (n + 2)] := by
    refine (add_modEq gA (fA * w) (by omega)).trans ?_
    refine Nat.ModEq.add mg ((mul_modEq fA w (by omega)).trans ?_)
    rw [mul_comm w.toNat]
    exact mf.mul_right _
  refine
    ⟨?_, by
      rw [hq, hr]; omega, mg', ?_⟩
  · rw [hq, hr]
    calc
      (qA.toNat + uA.toNat * w.toNat) * F₀ + (rA.toNat + vA.toNat * w.toNat) * G₀ =
          (qA.toNat * F₀ + rA.toNat * G₀) + w.toNat * (uA.toNat * F₀ + vA.toNat * G₀) :=
        by ring
      _ = 2 ^ (62 - n) * (GA + w.toNat * FA) := by
        rw [eF, eG]; ring
  · have := (mg'.of_dvd (Nat.pow_dvd_pow 2 (show k ≤ n + 2 by omega))).symm
    unfold Nat.ModEq at this
    rw [this, hc]

/-! ## The invariant -/

/-- The invariant at the head of a pass, at scale `2^(62-i)`: the matrix takes `(F₀, G₀)` to
`(F, G)` scaled, rows bounded (`G`'s by `2^c` more, `G` having `c` low zero bits), `f`, `g` the low
`i + 2` bits of `F`, `G`, `F` odd, the signed Jacobi symbol `K`, `|eta|` grown by at most the steps
done. -/
structure Inv (F₀ G₀ : ℕ) (K : ℤ) (E : ℕ) (s : State) (c F G : ℕ) : Prop where
  i1 : 1 ≤ s.i.toNat
  i62 : s.i.toNat ≤ 62
  c_le : c ≤ s.i.toNat
  eF : s.u.toNat * F₀ + s.v.toNat * G₀ = 2 ^ (62 - s.i.toNat) * F
  eG : s.q.toNat * F₀ + s.r.toNat * G₀ = 2 ^ (62 - s.i.toNat) * G
  bF : s.u.toNat + s.v.toNat ≤ 2 ^ (62 - s.i.toNat)
  bG : s.q.toNat + s.r.toNat ≤ 2 ^ (62 - s.i.toNat + c)
  mf : s.f.toNat ≡ F [MOD 2 ^ (s.i.toNat + 2)]
  mg : s.g.toNat ≡ G [MOD 2 ^ (s.i.toNat + 2)]
  oF : F % 2 = 1
  dG : G % 2 ^ c = 0
  jac : jacobiSym G F * bitSign (s.j.getLsbD 0) = K
  eta : |s.eta.toInt| ≤ E + (62 - s.i.toNat)

/-- The state at `break`: the matrix takes `(F₀, G₀)` to `2^62 (F, G)`, rows at most `2^62`, `F`
odd, the signed Jacobi symbol `K`, `|eta| ≤ E + 62`. -/
def Done (F₀ G₀ : ℕ) (K : ℤ) (E : ℕ) (s : State) : Prop :=
  ∃ F G : ℕ,
    s.u.toNat * F₀ + s.v.toNat * G₀ = 2 ^ 62 * F ∧
      s.q.toNat * F₀ + s.r.toNat * G₀ = 2 ^ 62 * G ∧
      s.u.toNat + s.v.toNat ≤ 2 ^ 62 ∧
      s.q.toNat + s.r.toNat ≤ 2 ^ 62 ∧
      F % 2 = 1 ∧ jacobiSym G F * bitSign (s.j.getLsbD 0) = K ∧ |s.eta.toInt| ≤ E + 62

/-- One pass: `Done` at `break`, else the invariant again with `c ≥ 1`, `i` lower unless `c` was
`0`. -/
theorem body_spec {F₀ G₀ : ℕ} {K : ℤ} {E : ℕ} {s : State} {c F G : ℕ} (P : Inv F₀ G₀ K E s c F G)
    (hE : E + 62 ≤ 2 ^ 30) :
    if (body s).2 then Done F₀ G₀ K E (body s).1
    else
      ∃ c' F' G',
        Inv F₀ G₀ K E (body s).1 c' F' G' ∧
          1 ≤ c' ∧ (body s).1.i.toNat + 1 ≤ s.i.toNat + (if c = 0 then 1 else 0) := by
  obtain ⟨z, hzs, hzn, hgz, hodd, hmax⟩ := zeros_spec s.g P.i1 P.i62
  have hn62 := P.i62
  have hn1 := P.i1
  have ez : (BitVec.ofNat 32 z).toNat = z := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt (by omega)
  -- the shift
  have hcz : c ≤ z :=
    hmax c P.c_le
      (by
        have :=
          P.mg.of_dvd
            (Nat.pow_dvd_pow 2
              (show c ≤ s.i.toNat + 2 by
                have := P.c_le; omega))
        unfold Nat.ModEq at this
        rw [this, P.dG])
  have hGz : G % 2 ^ z = 0 := by
    have := P.mg.of_dvd (Nat.pow_dvd_pow 2 (show z ≤ s.i.toNat + 2 by omega))
    unfold Nat.ModEq at this
    rw [← this, hgz]
  obtain ⟨G₁, rfl⟩ : ∃ G₁, G = 2 ^ z * G₁ :=
    ⟨G / 2 ^ z, (Nat.mul_div_cancel' (Nat.dvd_of_mod_eq_zero hGz)).symm⟩
  have hpz : 2 ^ (62 - s.i.toNat) * 2 ^ z = 2 ^ (62 - (s.i.toNat - z)) := by
    rw [← pow_add]; congr 1; omega
  have hle62 : 2 ^ (62 - (s.i.toNat - z)) ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) (by omega)
  have h64 : (2 : ℕ) ^ 62 < 2 ^ 64 := by decide
  have fi1 : (s.i - BitVec.ofNat 32 z).toNat = s.i.toNat - z := by
    rw [BitVec.toNat_sub, ez]; omega
  have fu1 : (s.u <<< z).toNat = s.u.toNat * 2 ^ z := by
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt]
    have :=
      Nat.mul_le_mul_right (2 ^ z)
        (show s.u.toNat ≤ 2 ^ (62 - s.i.toNat) by
          have := P.bF; omega)
    omega
  have fv1 : (s.v <<< z).toNat = s.v.toNat * 2 ^ z := by
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt]
    have :=
      Nat.mul_le_mul_right (2 ^ z)
        (show s.v.toNat ≤ 2 ^ (62 - s.i.toNat) by
          have := P.bF; omega)
    omega
  have fg1 : (s.g >>> z).toNat = s.g.toNat / 2 ^ z := by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have heta := P.eta
  have feta1 : (s.eta - (BitVec.ofNat 32 z).signExtend 64).toInt = s.eta.toInt - z :=
    eta_sub s.eta (by omega) (heta.trans (by omega))
  obtain ⟨b8, b4f⟩ :=
    testBit_odd (P.mf.of_dvd (Nat.pow_dvd_pow 2 (show 3 ≤ s.i.toNat + 2 by omega))) P.oF
  have fj1 := jbit_shift s.j s.f z
  rw [b8] at fj1
  have eF1 : (s.u <<< z).toNat * F₀ + (s.v <<< z).toNat * G₀ = 2 ^ (62 - (s.i.toNat - z)) * F := by
    rw [fu1, fv1, ← hpz]
    calc
      s.u.toNat * 2 ^ z * F₀ + s.v.toNat * 2 ^ z * G₀ = 2 ^ z * (s.u.toNat * F₀ + s.v.toNat * G₀) :=
        by ring
      _ = _ := by
        rw [P.eF]; ring
  have eG1 : s.q.toNat * F₀ + s.r.toNat * G₀ = 2 ^ (62 - (s.i.toNat - z)) * G₁ := by
    rw [P.eG, ← hpz]; ring
  have bF1 : (s.u <<< z).toNat + (s.v <<< z).toNat ≤ 2 ^ (62 - (s.i.toNat - z)) := by
    rw [fu1, fv1, ← add_mul, ← hpz]; exact Nat.mul_le_mul_right _ P.bF
  have bG1 : s.q.toNat + s.r.toNat ≤ 2 ^ (62 - (s.i.toNat - z)) :=
    P.bG.trans (Nat.pow_le_pow_right (by decide) (by omega))
  have mg1 : (s.g >>> z).toNat ≡ G₁ [MOD 2 ^ (s.i.toNat - z + 2)] := by
    have h := P.mg
    unfold Nat.ModEq at h ⊢
    have e : 2 ^ (s.i.toNat + 2) = 2 ^ z * 2 ^ (s.i.toNat - z + 2) := by
      rw [← pow_add]; congr 1; omega
    rw [fg1, ← Nat.mod_mul_right_div_self, ← e, h, e, Nat.mod_mul_right_div_self,
      Nat.mul_div_cancel_left _ (Nat.two_pow_pos z)]
  have mf1 : s.f.toNat ≡ F [MOD 2 ^ (s.i.toNat - z + 2)] :=
    P.mf.of_dvd (Nat.pow_dvd_pow 2 (by omega))
  have jac1 :
    jacobiSym G₁ F *
        bitSign
          ((s.j ^^^
                ((BitVec.ofNat 32 z).signExtend 64 &&& (s.f >>> 1 ^^^ s.f >>> 2)).setWidth
                  32).getLsbD
            0) =
      K := by
    rw [fj1, bitSign_xor, ← P.jac, jacobi_shift P.oF]
    ring
  unfold body
  dsimp only
  rw [hzs]
  simp only [ez]
  generalize s.u <<< z = u₁ at *
  generalize s.v <<< z = v₁ at *
  generalize s.g >>> z = g₁ at *
  generalize s.eta - (BitVec.ofNat 32 z).signExtend 64 = eta₁ at *
  generalize s.i - BitVec.ofNat 32 z = i₁ at *
  generalize s.j ^^^ ((BitVec.ofNat 32 z).signExtend 64 &&& (s.f >>> 1 ^^^ s.f >>> 2)).setWidth 32 =
    j₁ at *
  have heta1 : |eta₁.toInt| ≤ E + (62 - ((s.i.toNat - z : ℕ) : ℤ)) := by
    rw [abs_le] at heta ⊢; rw [feta1]; push_cast [Nat.cast_sub hzn]; omega
  by_cases hz0 : i₁ = 0#32
  · -- `break`
    have hzn' : z = s.i.toNat := by
      have := congrArg BitVec.toNat hz0; rw [fi1] at this; simp at this; omega
    simp only [hz0, ite_true]
    refine ⟨F, G₁, ?_, ?_, ?_, ?_, P.oF, jac1, ?_⟩
    · rw [eF1, hzn', Nat.sub_self]
    · rw [eG1, hzn', Nat.sub_self]
    · rw [hzn', Nat.sub_self] at bF1; exact bF1
    · rw [hzn', Nat.sub_self] at bG1; exact bG1
    · rw [hzn', Nat.sub_self] at heta1; simpa using heta1
  have hzl : z < s.i.toNat := by
    rcases Nat.lt_or_ge z s.i.toNat with h | h
    · exact h
    · exact
        absurd
          (BitVec.eq_of_toNat_eq
            (by
              rw [fi1]; simp; omega))
          hz0
  have oG1 : G₁ % 2 = 1 := by
    have h := mg1.of_dvd (Nat.pow_dvd_pow 2 (show 1 ≤ s.i.toNat - z + 2 by omega))
    unfold Nat.ModEq at h
    rw [pow_one, fg1, hodd hzl] at h
    exact h.symm
  obtain ⟨g8, g4⟩ :=
    testBit_odd (mg1.of_dvd (Nat.pow_dvd_pow 2 (show 3 ≤ s.i.toNat - z + 2 by omega))) oG1
  have hmeas : i₁.toNat + 1 ≤ s.i.toNat + (if c = 0 then 1 else 0) := by
    rw [fi1]; split_ifs <;> omega
  have hi1 : 1 ≤ i₁.toNat := by omega
  have hi62 : i₁.toNat ≤ 62 := by omega
  simp only [hz0, ite_false]
  by_cases hneg : eta₁.slt 0#64 = true
  · -- swap `f`, `g`, then cancel up to 6 bits
    simp only [hneg, ite_true]
    have hlt : eta₁.toInt < 0 := by
      rw [BitVec.slt_iff_toInt_lt] at hneg; simpa using hneg
    have hn' : (-eta₁).toInt = -eta₁.toInt := eta_neg eta₁ (heta1.trans (by omega))
    obtain ⟨hL1, hL2⟩ :=
      limit_spec (-eta₁) i₁
        (by
          rw [hn']; omega)
        (by
          rw [hn']; rw [abs_le] at heta1; omega)
        hi1 hi62
    have hm := (mask_spec _ hL1 (by omega)).1
    generalize
      BitVec.allOnes 64 >>> (64#32 - fd_int_min (BitVec.setWidth 32 (-eta₁) + 1#32) i₁).toNat &&&
        63#64 =
      m at hm ⊢
    generalize hk : min (fd_int_min (BitVec.setWidth 32 (-eta₁) + 1#32) i₁).toNat 6 = k at hm
    have hk1 : 1 ≤ k := by omega
    have hkn : k ≤ i₁.toNat := by omega
    obtain ⟨ml, m63⟩ := mask_low hm hk1 (by omega)
    have hc :=
      mod_of_and_mask hm
        (cancel6 g₁ s.f m
          (and_one_of_odd
            (by
              have h := mg1.of_dvd (Nat.pow_dvd_pow 2 (show 1 ≤ s.i.toNat - z + 2 by omega))
              unfold Nat.ModEq at h; rw [pow_one] at h; rw [h, oG1]))
          ml m63)
    have hw : (g₁ * s.f * (g₁ * g₁ - 2#64) &&& m).toNat < 2 ^ k := by
      rw [and_mask_toNat _ hm]; exact Nat.mod_lt _ (Nat.two_pow_pos k)
    generalize g₁ * s.f * (g₁ * g₁ - 2#64) &&& m = w at hc hw ⊢
    rw [← fi1] at eG1 eF1 bG1 bF1 mg1 mf1
    obtain ⟨eG', bG', mg', dG'⟩ :=
      add_step (F₀ := F₀) (G₀ := G₀) (uA := s.q) (vA := s.r) (qA := u₁) (rA := v₁) (fA := g₁) (gA :=
        s.f) hi62 hkn eG1 eF1 bG1 bF1 mg1 mf1 hw hc
    refine
      ⟨k, G₁, F + w.toNat * G₁, ⟨hi1, hi62, hkn, eG1, eG', bG1, bG', mg1, mg', oG1, dG', ?_, ?_⟩,
        hk1, hmeas⟩
    · dsimp only
      rw [jacobi_add, jbit_swap, bitSign_xor, g4, b4f, ← jac1, jacobi_swap P.oF oG1, Bool.and_comm]
      ring
    · dsimp only
      rw [hn', abs_neg, fi1]
      exact heta1
  · -- cancel up to 4 bits
    simp only [hneg, Bool.false_eq_true, ite_false]
    have hge : 0 ≤ eta₁.toInt := by
      rw [BitVec.slt_iff_toInt_lt] at hneg; simpa using hneg
    obtain ⟨hL1, hL2⟩ :=
      limit_spec eta₁ i₁ hge
        (by
          rw [abs_le] at heta1; omega)
        hi1 hi62
    have hm := (mask_spec _ hL1 (by omega)).2
    generalize
      BitVec.allOnes 64 >>> (64#32 - fd_int_min (BitVec.setWidth 32 eta₁ + 1#32) i₁).toNat &&&
        15#64 =
      m at hm ⊢
    generalize hk : min (fd_int_min (BitVec.setWidth 32 eta₁ + 1#32) i₁).toNat 4 = k at hm
    have hk1 : 1 ≤ k := by omega
    have hkn : k ≤ i₁.toNat := by omega
    obtain ⟨ml, m63⟩ := mask_low hm hk1 (by omega)
    have m15 : m ≤ 15#64 := by
      rw [BitVec.le_def, hm]
      have := Nat.pow_le_pow_right (show 0 < 2 by decide) (show k ≤ 4 by omega)
      simp only [BitVec.toNat_ofNat]; omega
    have hc :=
      mod_of_and_mask hm
        (cancel4 s.f g₁ m
          (and_one_of_odd
            (by
              have h := mf1.of_dvd (Nat.pow_dvd_pow 2 (show 1 ≤ s.i.toNat - z + 2 by omega))
              unfold Nat.ModEq at h; rw [pow_one] at h; rw [h, P.oF]))
          ml m15)
    have hw : (-(s.f + (s.f + 1#64 &&& 4#64) <<< 1) * g₁ &&& m).toNat < 2 ^ k := by
      rw [and_mask_toNat _ hm]; exact Nat.mod_lt _ (Nat.two_pow_pos k)
    generalize -(s.f + (s.f + 1#64 &&& 4#64) <<< 1) * g₁ &&& m = w at hc hw ⊢
    rw [← fi1] at eG1 eF1 bG1 bF1 mg1 mf1
    obtain ⟨eG', bG', mg', dG'⟩ :=
      add_step (F₀ := F₀) (G₀ := G₀) (uA := u₁) (vA := v₁) (qA := s.q) (rA := s.r) (fA := s.f)
        (gA := g₁) hi62 hkn eF1 eG1 bF1 bG1 mf1 mg1 hw hc
    refine
      ⟨k, F, G₁ + w.toNat * F, ⟨hi1, hi62, hkn, eF1, eG', bF1, bG', mf1, mg', P.oF, dG', ?_, ?_⟩,
        hk1, hmeas⟩
    · dsimp only
      rw [jacobi_add, jac1]
    · dsimp only
      rw [fi1]
      exact heta1

/-- The loop reaches `break` within `i + 1` passes (one more while `c = 0`). -/
theorem loop_done {F₀ G₀ : ℕ} {K : ℤ} {E : ℕ} (hE : E + 62 ≤ 2 ^ 30) :
    ∀ fuel (s : State) c F G,
      Inv F₀ G₀ K E s c F G →
        s.i.toNat + 1 + (if c = 0 then 1 else 0) ≤ fuel → Done F₀ G₀ K E (loop fuel s)
  | 0, s, c, F, G, _, h => by omega
  | fuel + 1, s, c, F, G, P, h => by
    have hb := body_spec P hE
    rw [loop]
    by_cases hd : (body s).2 = true
    · rw [ite_eq_left_of_eq_true _ _ (eq_true hd)] at hb ⊢
      exact hb
    · rw [ite_eq_right_of_eq_false _ _ (eq_false hd)] at hb ⊢
      obtain ⟨c', F', G', P', hc', hm⟩ := hb
      refine loop_done hE fuel _ c' F' G' P' ?_
      split_ifs at h hm ⊢ <;> omega

end fd_f25519_posdivsteps_62_var

open fd_f25519_posdivsteps_62_var in
/-- `posdivsteps` from `eta` and the low 64 bits of odd `F₀` and of `G₀`: a matrix `t` with
nonnegative rows of sum at most `2^62` taking `(F₀, G₀)` to `2^62 (F₁, G₁)`, `F₁` odd, the Jacobi
symbol times `jac`'s bit-0 sign kept, `|eta|` grown by at most 62. -/
public theorem fd_f25519_posdivsteps_62_var.spec_val {F₀ G₀ E : ℕ} (hF : F₀ % 2 = 1)
    (eta f₀ g₀ : BitVec 64) (jac : BitVec 32) (hf : f₀.toNat = F₀ % 2 ^ 64)
    (hg : g₀.toNat = G₀ % 2 ^ 64) (heta : |eta.toInt| ≤ E) (hE : E + 62 ≤ 2 ^ 30) :
    let R := fd_f25519_posdivsteps_62_var.spec eta f₀ g₀ jac
    ∃ F₁ G₁ : ℕ,
      R.t[0].toNat * F₀ + R.t[1].toNat * G₀ = 2 ^ 62 * F₁ ∧
        R.t[2].toNat * F₀ + R.t[3].toNat * G₀ = 2 ^ 62 * G₁ ∧
        R.t[0].toNat + R.t[1].toNat ≤ 2 ^ 62 ∧
        R.t[2].toNat + R.t[3].toNat ≤ 2 ^ 62 ∧
        F₁ % 2 = 1 ∧
        jacobiSym G₁ F₁ * bitSign (R.jac.getLsbD 0) = jacobiSym G₀ F₀ * bitSign (jac.getLsbD 0) ∧
        |R.eta.toInt| ≤ E + 62 := by
  have P :
    Inv F₀ G₀ (jacobiSym G₀ F₀ * bitSign (jac.getLsbD 0)) E
      ⟨1#64, 0#64, 0#64, 1#64, f₀, g₀, eta, 62#32, jac⟩ 0 F₀ G₀ :=
    { i1 := by simp, i62 := by simp, c_le := by simp, eF := by simp, eG := by simp, bF := by simp,
      bG := by simp,
      mf := by
        rw [hf]; exact Nat.mod_modEq _ _
      mg := by
        rw [hg]; exact Nat.mod_modEq _ _
      oF := hF, dG := Nat.mod_one _, jac := rfl, eta := by simpa using heta }
  obtain ⟨F₁, G₁, h1, h2, h3, h4, h5, h6, h7⟩ := loop_done hE fuel _ 0 F₀ G₀ P (by simp [fuel])
  exact ⟨F₁, G₁, h1, h2, h3, h4, h5, h6, h7⟩

end MLIR.Firedancer.Ref

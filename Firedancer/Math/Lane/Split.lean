module

public import Firedancer.Math.Avx512.Dsmb
public import Firedancer.Lane.Common.Split
import Mathlib.Tactic.Module

/-! The split double-scalar multiplication computes `n1 A + n2 B`: its tables hold the odd
multiples of `2^(32 j) A` and `2^(32 j) B` for the eight 32-bit segments `j` of the scalars, and
its ladder over 32 bits adds every segment's digits at each bit. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (Point basePoint)
open Firedancer.Avx512
open Avx512.fd_ed25519_double_scalar_mul_base (addDigit)
open Ref.fd_ed25519_double_scalar_mul_base (low low_succ low_256 low_add)

namespace double_scalar_mul_base_split

/-! ## The point operations on the group -/

/-- `R` is `P` in extended coordinates, folded, as the point operations give it. -/
def ExtF (R : Quad) (P : Point) : Prop :=
  R.Ext P.x P.y ∧ R.Folded

/-- `T` is `P` precomputed, folded, as the adds take their table operand. -/
def PreF (T : Quad) (P : Point) : Prop :=
  T.Pre P.x P.y ∧ T.Folded

/-- `ExtF` of equal points. -/
theorem ExtF.congr {R : Quad} {P Q : Point} (h : ExtF R P) (e : P = Q) : ExtF R Q :=
  e ▸ h

/-- `add_with_opts` of an extended operand: `Q + P`. -/
theorem addExt_extF {t b : Quad} {Q P : Point} (ht : ExtF t Q) (hb : ExtF b P) :
    ExtF (fd_ed25519_point_add_with_opts.spec t b 0#32) (Q + P) :=
  have h0 : (0#32 : BitVec 32) = 0 := rfl
  fd_ed25519_point_add_with_opts.spec_ext ht.1
    (by rw [Quad.Operand, ite_eq_left h0]; exact hb.1) Q.on P.on
    (ht.2.unsigned.mono (by decide)) (by rw [ite_eq_left h0]; exact hb.2.unsigned.mono (by decide))

/-- `add_with_opts` of a precomputed operand: `Q + P`. -/
theorem add_extF {t b : Quad} {Q P : Point} (ht : ExtF t Q) (hb : PreF b P) :
    ExtF (fd_ed25519_point_add_with_opts.spec t b 1#32) (Q + P) := by
  have hpre : ¬(1#32 = 0) := by decide
  refine fd_ed25519_point_add_with_opts.spec_ext ht.1 ?_ Q.on P.on
    (ht.2.unsigned.mono (by decide)) ?_
  · rw [Quad.Operand, ite_eq_right hpre]
    exact hb.1
  · rw [ite_eq_right hpre]
    exact hb.2.unsigned.mono (by decide)

/-- `sub_with_opts` of a precomputed operand: `Q - P`. -/
theorem sub_extF {t b : Quad} {Q P : Point} (ht : ExtF t Q) (hb : PreF b P) :
    ExtF (fd_ed25519_point_sub_with_opts.spec t b 1#32) (Q - P) :=
  fd_ed25519_point_sub_with_opts.spec_ext ht.1
    (by rw [Quad.Operand, ite_eq_right (by decide)]; exact hb.1) Q.on P.on
    (ht.2.unsigned.mono (by decide)) hb.2

/-- `partial_dbl`: `Q + Q`. -/
theorem dbl_extF {r : Quad} {Q : Point} (hr : ExtF r Q) :
    ExtF (fd_ed25519_partial_dbl.spec r) (Q + Q) := by
  have h := fd_ed25519_partial_dbl.spec_ext hr.1.proj Q.on hr.2.unsigned
  rw [Ed25519.Point.dbl_eq] at h
  exact h

/-- `dbln` by `n ≥ 1`: `2^n Q`. -/
theorem dbln_extF {r : Quad} {Q : Point} (hr : ExtF r Q) {n : ℕ} (hn : 1 ≤ n) :
    ExtF (fd_ed25519_point_dbln.spec r n) (2 ^ n • Q) := by
  have h := fd_ed25519_point_dbln.spec_ext hr.1.proj Q.on hr.2.unsigned hn
  rw [Ed25519.Point.dblN_eq] at h
  exact h

/-- `into_precomputed`: `Q` precomputed. -/
theorem pre_preF {r : Quad} {Q : Point} (hr : ExtF r Q) :
    PreF (fd_curve25519_into_precomputed.spec r) Q :=
  fd_curve25519_into_precomputed.spec_pre hr.1 (hr.2.unsigned.mono (by decide))

/-! ## The tables -/

/-- `split_odd_table`'s raw entry `i` of `p2 = 2 P` and `P`: `(2i + 1) P`. -/
theorem raw_extF {P2 P : Quad} {Q : Point} (h2 : ExtF P2 (2 • Q)) (h : ExtF P Q) :
    ∀ i, ExtF (split_odd_table.raw P2 P i) ((2 * i + 1) • Q)
  | 0 => by simpa [split_odd_table.raw] using h
  | i + 1 => by
    refine (addExt_extF h2 (raw_extF h2 h i)).congr ?_
    rw [← add_smul]
    congr 1
    ring

/-- `split_odd_table`'s entry `i` of `P`: `(2i + 1) P`, precomputed. -/
theorem odd_preF {P : Quad} {Q : Point} (h : ExtF P Q) (i : ℕ) :
    PreF (split_odd_table.spec P i) ((2 * i + 1) • Q) :=
  pre_preF (raw_extF ((dbln_extF h le_rfl).congr (by rw [pow_one])) h i)

/-- Segment `j`'s point: `2^(32 j) A`. -/
theorem seg_extF {A : Quad} {Q : Point} (h : ExtF A Q) :
    ∀ j, ExtF (fd_ed25519_split_table_a.seg A j) (2 ^ (32 * j) • Q)
  | 0 => by simpa [fd_ed25519_split_table_a.seg] using h
  | j + 1 => by
    refine (dbln_extF (seg_extF h j) (by decide)).congr ?_
    rw [smul_smul, ← pow_add]
    congr 2
    ring

/-- `B`'s value lanes, `X, Y, Z, T` with `Z = 1`, and their ranges. -/
theorem base_ok :
    (R43x6.nat (fd_ed25519_split_table_b.base.elem 0) : ZMod Ed25519.p) = Ed25519.Bx ∧
      (R43x6.nat (fd_ed25519_split_table_b.base.elem 1) : ZMod Ed25519.p) = Ed25519.By ∧
      (R43x6.nat (fd_ed25519_split_table_b.base.elem 2) : ZMod Ed25519.p) = 1 ∧
      (R43x6.nat (fd_ed25519_split_table_b.base.elem 3) : ZMod Ed25519.p) =
        Ed25519.Bx * Ed25519.By ∧
      fd_ed25519_split_table_b.base.Folded := by
  decide +kernel

/-- `fd_ed25519_split_table_b`'s base point is `B`, extended. -/
theorem base_extF : ExtF fd_ed25519_split_table_b.base basePoint := by
  obtain ⟨e0, e1, e2, e3, hf⟩ := base_ok
  have hv (j : ℕ) (hj : j < 4) :
      fd_ed25519_split_table_b.base.val j =
        (R43x6.nat (fd_ed25519_split_table_b.base.elem j) : ZMod Ed25519.p) :=
    R43x6.val_eq_nat ((hf j hj).unsigned.mono (by decide))
  refine ⟨?_, hf⟩
  rw [Quad.Ext, hv 0 (by decide), hv 1 (by decide), hv 2 (by decide), hv 3 (by decide), e0, e1, e2,
    e3]
  exact ⟨one_ne_zero, (mul_one _).symm, (mul_one _).symm, mul_one _⟩

/-! ## The ladder -/

/-- The digits at bit `i` of segments `0 … J-1`, at their weights:
`Σ_{j < J} w[32 j + i] 2^(32 j)`. -/
def segSum (w : Vector Int 256) (i J : ℕ) : ℤ :=
  ∑ j ∈ Finset.range J, digit w (32 * j + i) * 2 ^ (32 * j)

/-- The digits at bits `0 … i-1` of every segment, at their weights. -/
def bitSum (w : Vector Int 256) (i : ℕ) : ℤ :=
  ∑ b ∈ Finset.range i, segSum w b 8 * 2 ^ b

theorem bitSum_succ (w : Vector Int 256) (i : ℕ) :
    bitSum w (i + 1) = bitSum w i + segSum w i 8 * 2 ^ i :=
  Finset.sum_range_succ _ _

/-- A digit's add from a table of `n` odd multiples of `P`: `Q + d P`. -/
theorem addDigit_tbl {tb : ℕ → Quad} {P Q : Point} {n : ℕ} {d : ℤ} {r t : Quad} (ht : ExtF t Q)
    (htb : ∀ k < n, PreF (tb k) ((2 * k + 1) • P)) (hd : d = 0 ∨ Odd d)
    (hn : d.natAbs / 2 < n) : ExtF (addDigit tb d r t).2 (Q + d • P) := by
  have hodd {e : ℤ} (he : 0 < e) (ho : Odd e) (hn : e.natAbs / 2 < n) :
      PreF (tb (e / 2).toNat) (e • P) := by
    obtain ⟨m, rfl⟩ := ho
    have h2 : ((2 * ((2 * m + 1) / 2).toNat + 1 : ℕ) : ℤ) = 2 * m + 1 := by omega
    have := htb ((2 * m + 1) / 2).toNat (by omega)
    rwa [← natCast_zsmul, h2] at this
  unfold addDigit
  split_ifs with h1 h2
  · exact add_extF ht (hodd h1 (hd.resolve_left (by omega)) hn)
  · rw [show Q + d • P = Q - (-d) • P by rw [neg_smul, sub_neg_eq_add]]
    exact sub_extF ht (hodd (by omega) (hd.resolve_left (by omega)).neg (by omega))
  · obtain rfl : d = 0 := by omega
    rw [zero_smul, add_zero]
    exact ht

/-- Digits `0` or odd, with `|d| / 2 < n`, `0` past the slides. -/
abbrev Digs (w : Vector Int 256) (n : ℕ) : Prop :=
  ∀ k, (digit w k = 0 ∨ Odd (digit w k)) ∧ (digit w k).natAbs / 2 < n

/-- Segments `0 … J-1`'s adds at bit `i` take `t`, `Q`, to `Q` plus their digits' multiples. -/
theorem segAdds_extF {ta tb : ℕ → Quad} {PA PB Q : Point} {w1 w2 : Vector Int 256} {i : ℕ}
    (hta : ∀ j < 8, ∀ k < 4, PreF (ta (4 * j + k)) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PA)))
    (htb : ∀ j < 8, ∀ k < 128, PreF (btab tb j k) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PB)))
    (hw1 : Digs w1 4) (hw2 : Digs w2 128) :
    ∀ J, J ≤ 8 → ∀ {r t : Quad}, ExtF t Q →
      ExtF (segAdds ta tb w1 w2 i J (r, t)).2 (Q + segSum w1 i J • PA + segSum w2 i J • PB)
  | 0, _, r, t, ht => by simpa [segAdds, segSum] using ht
  | J + 1, hJ, r, t, ht => by
    have ih := segAdds_extF hta htb hw1 hw2 (i := i) J (by omega) ht (r := r)
    have h1 := addDigit_tbl ih (fun k hk => hta J (by omega) k hk) (hw1 (32 * J + i)).1
      (hw1 (32 * J + i)).2 (r := (segAdds ta tb w1 w2 i J (r, t)).1)
    have h2 := addDigit_tbl h1 (htb J (by omega)) (hw2 (32 * J + i)).1 (hw2 (32 * J + i)).2
      (r := (addDigit (fun k => ta (4 * J + k)) (digit w1 (32 * J + i))
        (segAdds ta tb w1 w2 i J (r, t)).1 (segAdds ta tb w1 w2 i J (r, t)).2).1)
    refine h2.congr ?_
    simp only [segSum, Finset.sum_range_succ, add_smul, smul_smul]
    module

/-- An iteration at bit `i` on `r`, `R`: `2 R` plus the digits at `i`. -/
theorem iter_extF {ta tb : ℕ → Quad} {PA PB R : Point} {w1 w2 : Vector Int 256} {i : ℕ} {r : Quad}
    (hta : ∀ j < 8, ∀ k < 4, PreF (ta (4 * j + k)) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PA)))
    (htb : ∀ j < 8, ∀ k < 128, PreF (btab tb j k) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PB)))
    (hw1 : Digs w1 4) (hw2 : Digs w2 128) (hr : ExtF r R) :
    ExtF (iter ta tb w1 w2 i r) ((2 : ℤ) • R + segSum w1 i 8 • PA + segSum w2 i 8 • PB) := by
  refine (segAdds_extF hta htb hw1 hw2 8 le_rfl (dbl_extF hr) (r := r)).congr ?_
  rw [two_zsmul]

/-- The main loop from bit `i` on `r`, `R`: `2^(i+1) R` plus the digits at bits `0 … i`. -/
theorem ladder_extF {ta tb : ℕ → Quad} {PA PB : Point} {w1 w2 : Vector Int 256}
    (hta : ∀ j < 8, ∀ k < 4, PreF (ta (4 * j + k)) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PA)))
    (htb : ∀ j < 8, ∀ k < 128, PreF (btab tb j k) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PB)))
    (hw1 : Digs w1 4) (hw2 : Digs w2 128) :
    ∀ i {r : Quad} {R : Point}, ExtF r R →
      ExtF (ladder ta tb w1 w2 i r)
        ((2 : ℤ) ^ (i + 1) • R + bitSum w1 (i + 1) • PA + bitSum w2 (i + 1) • PB)
  | 0, r, R, hr => by
    refine (iter_extF hta htb hw1 hw2 hr (i := 0)).congr ?_
    simp [bitSum]
  | i + 1, r, R, hr => by
    refine (ladder_extF hta htb hw1 hw2 i (iter_extF hta htb hw1 hw2 hr (i := i + 1))).congr ?_
    rw [bitSum_succ w1 (i + 1), bitSum_succ w2 (i + 1)]
    module

/-! ## The first bit with a digit -/

/-- `start` from `i` stops at a bit up to `i`. -/
theorem start_le {w1 w2 : Vector Int 256} : ∀ i {j : ℕ}, start w1 w2 i = some j → j ≤ i
  | 0, _, hs => by
    rw [start] at hs
    split_ifs at hs
    obtain rfl := Option.some.inj hs
    rfl
  | i + 1, _, hs => by
    rw [start] at hs
    split_ifs at hs
    · exact Nat.le_succ_of_le (start_le i hs)
    · exact (Option.some.inj hs).ge

/-- `start` stops at `j`: no segment has a digit at the bits above it, up to `i`. -/
theorem start_some {w1 w2 : Vector Int 256} :
    ∀ i {j : ℕ}, start w1 w2 i = some j → ∀ b, j < b → b ≤ i → zeroAt w1 w2 b
  | 0, _, _, _, hjb, hbi => absurd hjb (by omega)
  | i + 1, j, hs, b, hjb, hbi => by
    rw [start] at hs
    split_ifs at hs with hz
    · by_cases hb : b = i + 1
      · exact hb ▸ hz
      · exact start_some i hs b hjb (by omega)
    · obtain rfl := Option.some.inj hs
      omega

/-- `start` finds nothing: no segment has a digit at the bits up to `i`. -/
theorem start_none {w1 w2 : Vector Int 256} :
    ∀ i, start w1 w2 i = none → ∀ b ≤ i, zeroAt w1 w2 b
  | 0, hs, b, hb => by
    rw [start] at hs
    split_ifs at hs with hz
    exact (show b = 0 by omega) ▸ hz
  | i + 1, hs, b, hb => by
    rw [start] at hs
    split_ifs at hs with hz
    by_cases hb' : b = i + 1
    · exact hb' ▸ hz
    · exact start_none i hs b (by omega)

/-- No digit at bit `b` of any segment: nothing at `b`. -/
theorem segSum_eq_zero {w : Vector Int 256} {b : ℕ} (h : ∀ j < 8, digit w (32 * j + b) = 0) :
    segSum w b 8 = 0 :=
  Finset.sum_eq_zero fun j hj => by rw [h j (Finset.mem_range.1 hj), zero_mul]

/-- No digits above bit `i`: the bits up to `i` are all of them. -/
theorem bitSum_add {w : Vector Int 256} {i : ℕ} (h : ∀ b, i < b → b < 32 → segSum w b 8 = 0) :
    ∀ m, i + 1 + m ≤ 32 → bitSum w (i + 1 + m) = bitSum w (i + 1)
  | 0, _ => rfl
  | m + 1, hm => by
    rw [← Nat.add_assoc, bitSum_succ, h _ (by omega) (by omega), zero_mul, add_zero,
      bitSum_add h m (by omega)]

/-- A sum over `32 J` terms, in blocks of 32. -/
theorem sum_range_32 (f : ℕ → ℤ) : ∀ J, ∑ k ∈ Finset.range (32 * J), f k =
    ∑ j ∈ Finset.range J, ∑ b ∈ Finset.range 32, f (32 * j + b)
  | 0 => rfl
  | J + 1 => by
    rw [Nat.mul_succ, Finset.sum_range_add, Finset.sum_range_succ (n := J), sum_range_32 f J]

/-- The segments' bits are all the digits: `w`'s value. -/
theorem bitSum_32 (w : Vector Int 256) : bitSum w 32 = low w 256 := by
  rw [low, show Finset.range 256 = Finset.range (32 * 8) from rfl, sum_range_32 _ 8,
    Finset.sum_comm, bitSum]
  refine Finset.sum_congr rfl fun b hb => ?_
  rw [segSum, Finset.sum_mul]
  refine Finset.sum_congr rfl fun j hj => ?_
  have hb := Finset.mem_range.1 hb
  have hj := Finset.mem_range.1 hj
  rw [digit, dite_eq_left (by omega), dite_eq_left (by omega), pow_add, mul_assoc]

/-- The slides' digits: `0` or odd, below `2^bits` in absolute value. -/
theorem digs_wnaf (x : BitVec 256) {bits n : ℕ} (hb : 1 ≤ bits) (hn : 2 ^ bits ≤ 2 * n) :
    Digs (Ref.fd_curve25519_scalar_wnaf.wnaf x bits) n := fun k => by
  have := Nat.one_le_two_pow (n := bits)
  unfold digit
  split
  · rename_i hk
    obtain ⟨h1, h2⟩ := Ref.fd_curve25519_scalar_wnaf.wnaf_digit x hb hk
    refine ⟨h1, lt_of_le_of_lt (Nat.div_le_div_right h2) ?_⟩
    omega
  · exact ⟨Or.inl rfl, by rw [Int.natAbs_zero]; omega⟩

/-- `2^n` as an integer multiple: the natural one. -/
theorem zpow_smul (n : ℕ) (P : Point) : ((2 : ℤ) ^ n) • P = 2 ^ n • P := by
  rw [← natCast_zsmul]
  push_cast
  rfl

end double_scalar_mul_base_split

/-! ## The tables -/

open double_scalar_mul_base_split in
/-- Entry `k` of `fd_ed25519_split_table_a` of `A`, extended and folded (as decoding gives it):
`(2 (k % 4) + 1) 2^(32 (k / 4)) A`, precomputed and folded. -/
public theorem fd_ed25519_split_table_a.spec_pre {A : Quad} (PA : Point) (hA : A.Ext PA.x PA.y)
    (hAF : A.Folded) (k : ℕ) :
    let T := fd_ed25519_split_table_a.spec A k
    let P := (2 * (k % 4) + 1) • 2 ^ (32 * (k / 4)) • PA
    T.Pre P.x P.y ∧ T.Folded :=
  odd_preF (seg_extF ⟨hA, hAF⟩ (k / 4)) (k % 4)

open double_scalar_mul_base_split in
/-- Entry `k` of `fd_ed25519_split_table_b`: `(2 (k % 128) + 1) 2^(32 (k / 128 + 1)) B`,
precomputed and folded. -/
public theorem fd_ed25519_split_table_b.spec_pre (k : ℕ) :
    let T := fd_ed25519_split_table_b.spec k
    let P := (2 * (k % 128) + 1) • 2 ^ (32 * (k / 128 + 1)) • basePoint
    T.Pre P.x P.y ∧ T.Folded :=
  odd_preF (seg_extF base_extF (k / 128 + 1)) (k % 128)

/-! ## `n1 A + n2 B` -/

open double_scalar_mul_base_split in
/-- `double_scalar_mul_base_split` computes `n1 A + n2 B`, folded, for `ta` holding the odd
multiples of `2^(32 j) A` and `tb` those of `2^(32 j) B` for `j ≥ 1`, as `fd_ed25519_split_table_a`
and `fd_ed25519_split_table_b` store them, precomputed and folded. -/
public theorem double_scalar_mul_base_split.spec_val {ta tb : ℕ → Quad} {n1 n2 : BitVec 256}
    (PA : Point)
    (hta : ∀ k < 32,
      (ta k).Pre ((2 * (k % 4) + 1) • 2 ^ (32 * (k / 4)) • PA).x
          ((2 * (k % 4) + 1) • 2 ^ (32 * (k / 4)) • PA).y ∧
        (ta k).Folded)
    (htb : ∀ k < 896,
      (tb k).Pre ((2 * (k % 128) + 1) • 2 ^ (32 * (k / 128 + 1)) • basePoint).x
          ((2 * (k % 128) + 1) • 2 ^ (32 * (k / 128 + 1)) • basePoint).y ∧
        (tb k).Folded)
    (h1 : n1.toNat < 2 ^ 255) (h2 : n2.toNat < 2 ^ 255) :
    let R := double_scalar_mul_base_split.spec ta tb n1 n2
    let Q := n1.toNat • PA + n2.toNat • basePoint
    R.Ext Q.x Q.y ∧ R.Folded := by
  show ExtF _ (n1.toNat • PA + n2.toNat • basePoint)
  have hta' : ∀ j < 8, ∀ k < 4,
      PreF (ta (4 * j + k)) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • PA)) := fun j hj k hk => by
    have h := hta (4 * j + k) (by omega)
    rw [show (4 * j + k) % 4 = k by omega, show (4 * j + k) / 4 = j by omega] at h
    rw [zpow_smul]
    exact h
  have htb' : ∀ j < 8, ∀ k < 128,
      PreF (btab tb j k) ((2 * k + 1) • ((2 : ℤ) ^ (32 * j) • basePoint)) := fun j hj k hk => by
    rw [zpow_smul, btab]
    split
    · rename_i h0
      subst h0
      obtain ⟨e0, e1, e2, e3, hf, -⟩ := fd_ed25519_base_point_wnaf_table.point_operand hk
      rw [Ref.Ed25519.oddMul_eq_nsmul] at e0 e1 e3
      rw [Nat.mul_zero, pow_zero, one_smul]
      exact ⟨Quad.Pre.of_affine e0 e1 e2 e3, hf⟩
    · have h := htb (128 * (j - 1) + k) (by omega)
      rw [show (128 * (j - 1) + k) % 128 = k by omega,
        show (128 * (j - 1) + k) / 128 + 1 = j by omega] at h
      exact h
  have hw1 := digs_wnaf n1 (bits := 3) (n := 4) (by decide) (by decide)
  have hw2 := digs_wnaf n2 (bits := 8) (n := 128) (by decide) (by decide)
  have s1 := Ref.fd_curve25519_scalar_wnaf.wnaf_sum n1 (bits := 3) (by decide) h1
  have s2 := Ref.fd_curve25519_scalar_wnaf.wnaf_sum n2 (bits := 8) (by decide) h2
  rw [← low_256, ← bitSum_32] at s1 s2
  rw [← natCast_zsmul, ← natCast_zsmul, ← s1, ← s2]
  unfold double_scalar_mul_base_split.spec
  dsimp only
  generalize Ref.fd_curve25519_scalar_wnaf.wnaf n1 3 = w1 at *
  generalize Ref.fd_curve25519_scalar_wnaf.wnaf n2 8 = w2 at *
  split
  · rename_i i hs
    have hz (b : ℕ) (hib : i < b) (hb : b < 32) := start_some 31 hs b hib (by omega)
    have hi : i < 32 := Nat.lt_succ_of_le (start_le 31 hs)
    have e1 := bitSum_add (w := w1) (i := i)
      (fun b hib hb => segSum_eq_zero fun j hj => ((hz b hib hb) j hj).1) (31 - i) (by omega)
    have e2 := bitSum_add (w := w2) (i := i)
      (fun b hib hb => segSum_eq_zero fun j hj => ((hz b hib hb) j hj).2) (31 - i) (by omega)
    rw [show i + 1 + (31 - i) = 32 by omega] at e1 e2
    refine (ladder_extF hta' htb' hw1 hw2 i (R := 0) fd_ed25519_point_set_zero.spec_ext).congr ?_
    rw [e1, e2, smul_zero, zero_add]
  · rename_i hs
    have hz (b : ℕ) (hb : b ≤ 31) := start_none 31 hs b hb
    have e (w : Vector Int 256) (hw : ∀ b ≤ 31, segSum w b 8 = 0) : bitSum w 32 = 0 := by
      have := bitSum_add (w := w) (i := 0)
        (fun b _ hb => hw b (by omega)) 31 (by omega)
      rw [this, bitSum_succ, hw 0 (by omega)]
      simp [bitSum]
    rw [e w1 fun b hb => segSum_eq_zero fun j hj => ((hz b hb) j hj).1,
      e w2 fun b hb => segSum_eq_zero fun j hj => ((hz b hb) j hj).2, zero_smul, zero_smul,
      add_zero]
    exact fd_ed25519_point_set_zero.spec_ext

end MLIR.Firedancer.Lane

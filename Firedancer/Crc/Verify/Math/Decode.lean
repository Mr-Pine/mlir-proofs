module

public import Firedancer.Crc.Verify.VerifyCore.SmallOrder
public import Firedancer.Crc.Verify.Math.Quad
import Firedancer.Math.Sqrt
import Firedancer.Math.Curve
import Firedancer.Math.Decode
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! crc's `fd_r52x5_ge_decode2` in `ZMod p`: lanes 0 and 1 decode `sa` and `sb` as `decode` does. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p OnCurve)
open fd_r52x5_ge_decode2

/-! ## Lanes of the fixed quads -/

theorem oneQ_elem (j : Fin 4) : oneQ.elem j = Ref.fd_f25519_one.limbs := by
  funext i; fin_cases j <;> fin_cases i <;> rfl

theorem dQ_elem (j : Fin 4) : dQ.elem j = Ref.fd_f25519_d.limbs := by
  funext i; fin_cases j <;> fin_cases i <;> rfl

theorem sqrtm1Q_elem (j : Fin 4) : sqrtm1Q.elem j = Ref.fd_f25519_sqrtm1.limbs := by
  funext i; fin_cases j <;> fin_cases i <;> rfl

theorem one_val : Ed25519.Limbs.val Ref.fd_f25519_one.limbs = 1 := by
  simp [Ed25519.Limbs.val_eq, Ref.fd_f25519_one.limbs]

theorem one_le (i : Fin 5) : (Ref.fd_f25519_one.limbs i).toNat ≤ 1 := by
  fin_cases i <;> decide

theorem oneQ_is : oneQ.Is (fun _ => 1) (fun _ => 1) := fun j =>
  ⟨by rw [Quad5.val, oneQ_elem, one_val], fun i => by rw [oneQ_elem]; exact one_le i⟩

theorem dQ_is : dQ.Is (fun _ => Ed25519.d) (fun _ => 2 ^ 51) := fun j =>
  ⟨by rw [Quad5.val, dQ_elem, Ref.fd_f25519_d.val.1],
    fun i => by rw [dQ_elem]; exact Ref.fd_f25519_d.val.2 i⟩

theorem sqrtm1Q_is : sqrtm1Q.Is (fun _ => Ed25519.sqrtM1) (fun _ => 2 ^ 51) := fun j =>
  ⟨by rw [Quad5.val, sqrtm1Q_elem, Ref.fd_f25519_sqrtm1.val.1],
    fun i => by rw [sqrtm1Q_elem]; exact Ref.fd_f25519_sqrtm1.val.2 i⟩

/-! ## `Y` -/

theorem frombytes_toNat (s : BitVec 256) (i : Fin 5) :
    (fd_r52x5_limbs_frombytes.spec s i).toNat = s.toNat / 2 ^ (51 * i.val) % 2 ^ 51 := by
  obtain ⟨i, hi⟩ := i
  obtain rfl | rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 ∨ i = 4 := by omega
  all_goals
    simp only [fd_r52x5_limbs_frombytes.spec, BitVec.toNat_setWidth, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, Nat.reducePow, Nat.reduceMul, Nat.mul_zero, pow_zero, Nat.div_one]
    omega

/-- `fd_r52x5_limbs_frombytes` reads the low 255 bits, each limb below `2^51`. -/
theorem frombytes_val (s : BitVec 256) :
    Ed25519.Limbs.val (fd_r52x5_limbs_frombytes.spec s) = ((s.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧
      ∀ i, (fd_r52x5_limbs_frombytes.spec s i).toNat < 2 ^ 51 := by
  refine ⟨?_, fun i => by rw [frombytes_toNat]; omega⟩
  rw [Ed25519.Limbs.val_nat, Ed25519.Limbs.nat, frombytes_toNat, frombytes_toNat, frombytes_toNat,
    frombytes_toNat, frombytes_toNat]
  congr 1
  simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod, Nat.reduceMul, Nat.reducePow,
    mul_zero, pow_zero, Nat.div_one]
  omega

theorem yQ_elem0 (sa sb : BitVec 256) : (yQ sa sb).elem 0 = fd_r52x5_limbs_frombytes.spec sa := by
  funext i; fin_cases i <;> rfl

theorem yQ_elem1 (sa sb : BitVec 256) : (yQ sa sb).elem 1 = fd_r52x5_limbs_frombytes.spec sb := by
  funext i; fin_cases i <;> rfl

theorem yQ_elem2 (sa sb : BitVec 256) : (yQ sa sb).elem 2 = fun _ => 0 := by
  funext i; fin_cases i <;> rfl

theorem yQ_elem3 (sa sb : BitVec 256) : (yQ sa sb).elem 3 = fun _ => 0 := by
  funext i; fin_cases i <;> rfl

theorem zero_val : Ed25519.Limbs.val (fun _ : Fin 5 => (0 : BitVec 64)) = 0 := by
  simp [Ed25519.Limbs.val_eq]

/-- The low 255 bits of `s` in `ZMod p`. -/
abbrev yOf (s : BitVec 256) : ZMod p := ((s.toNat % 2 ^ 255 : ℕ) : ZMod p)

theorem zero_le (i : Fin 5) : ((fun _ : Fin 5 => (0 : BitVec 64)) i).toNat ≤ 2 ^ 51 := by
  simp

theorem yQ_is (sa sb : BitVec 256) :
    (yQ sa sb).Is (![yOf sa, yOf sb, 0, 0]) (fun _ => 2 ^ 51)
  | 0 => ⟨by rw [Quad5.val, yQ_elem0, (frombytes_val sa).1]; rfl,
      fun i => by rw [yQ_elem0]; exact ((frombytes_val sa).2 i).le⟩
  | 1 => ⟨by rw [Quad5.val, yQ_elem1, (frombytes_val sb).1]; rfl,
      fun i => by rw [yQ_elem1]; exact ((frombytes_val sb).2 i).le⟩
  | 2 => ⟨by rw [Quad5.val, yQ_elem2, zero_val]; rfl, fun i => by rw [yQ_elem2]; exact zero_le i⟩
  | 3 => ⟨by rw [Quad5.val, yQ_elem3, zero_val]; rfl, fun i => by rw [yQ_elem3]; exact zero_le i⟩

/-! ## The quads before the lane checks -/

/-- The uniform output bound of the kernels. -/
abbrev kb : Fin 4 → ℕ := fun _ => 2 ^ 51 + 2 ^ 18

theorem kb_lt52 : ∀ j, kb j < 2 ^ 52 := fun _ => by norm_num
theorem kb_lt63 : ∀ j, kb j < 2 ^ 63 := fun _ => by norm_num
theorem kb_le55 : ∀ j, kb j ≤ 2 ^ 55 - 304 := fun _ => by norm_num

theorem sqrQ_is {S : Quad5} (hS : S.Is v b) (hb : ∀ j, b j < 2 ^ 52) :
    (sqrQ S).Is (fun j => v j ^ 2) kb :=
  fd_r52x5_quad_sqr.spec_is hS hb

theorem mulQ_is {S T : Quad5} (hS : S.Is v b) (hT : T.Is w c) (hb : ∀ j, b j < 2 ^ 52)
    (hc : ∀ j, c j < 2 ^ 52) : (mulQ S T).Is (fun j => v j * w j) kb :=
  fd_r52x5_quad_mul.spec_is hS hT hb hc

/-- `Q` has limbs below `2^52`, each lane `A`'s to the power `e`. -/
def IsPow (Q A : Quad5) (e : ℕ) : Prop := Q.Below 52 ∧ ∀ j, Q.val j = A.val j ^ e

theorem IsPow.is {Q A : Quad5} (h : IsPow Q A e) :
    Q.Is (fun j => A.val j ^ e) (fun _ => 2 ^ 52 - 1) :=
  h.1.is.congr h.2 fun _ => le_rfl

theorem b52_lt : ∀ j : Fin 4, (fun _ : Fin 4 => 2 ^ 52 - 1) j < 2 ^ 52 := fun _ => by norm_num

theorem IsPow.sqr {Q A : Quad5} (h : IsPow Q A e) : IsPow (sqrQ Q) A (e * 2) :=
  have h' := sqrQ_is h.is b52_lt
  ⟨h'.below kb_lt52, fun j => by rw [h'.val, pow_mul]⟩

theorem IsPow.mul {Q R A : Quad5} (h : IsPow Q A e) (h' : IsPow R A f) :
    IsPow (mulQ Q R) A (e + f) :=
  have h'' := mulQ_is h.is h'.is b52_lt b52_lt
  ⟨h''.below kb_lt52, fun j => by rw [h''.val, pow_add]⟩

theorem IsPow.sqrN {Q A : Quad5} (h : IsPow Q A e) : IsPow (sqrNQ n Q) A (e * 2 ^ n) := by
  induction n generalizing Q e with
  | zero => simpa [sqrNQ] using h
  | succ n ih =>
    rw [sqrNQ, pow_succ', ← mul_assoc]
    exact ih h.sqr

/-- `FD_R52X5_QUAD_POW22523` of a QUAD with limbs below `2^52`: each lane to `(p - 5) / 8`. -/
theorem pow22523Q_is {A : Quad5} (hA : A.Is v b) (hb : ∀ j, b j < 2 ^ 52) :
    (pow22523Q A).Is (fun j => v j ^ ((p - 5) / 8)) kb := by
  have h0 : IsPow A A 1 := ⟨hA.below hb, fun _ => (pow_one _).symm⟩
  have h1 := h0.sqr
  have h2 := h1.sqr.sqr
  have h3 := h0.mul h2
  have h4 := h1.mul h3
  have h5 := h4.sqr
  have h6 := h3.mul h5
  have h7 := h6.sqr.sqr.sqr.sqr.sqr
  have h8 := h7.mul h6
  have h9 := h8.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr
  have h10 := h9.mul h8
  have h11 := h10.sqr.sqrN (n := 19)
  have h12 := h11.mul h10
  have h13 := h12.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr.sqr
  have h14 := h13.mul h8
  have h15 := h14.sqr.sqrN (n := 49)
  have h16 := h15.mul h14
  have h17 := h16.sqr.sqrN (n := 99)
  have h18 := h17.mul h16
  have h19 := h18.sqr.sqrN (n := 49)
  have h20 := h19.mul h14
  have h21 := h20.sqr.sqr
  have h22 := mulQ_is h21.is h0.is b52_lt b52_lt
  refine h22.congr (fun j => ?_) fun _ => le_rfl
  rw [pow_one, ← pow_succ, hA.val]
  congr 1

/-- The lane values of `pre`: `y`, `u = y² - 1`, `v = d y² + 1`, `v³`, the root candidate
`x = u v³ (u v⁷)^((p-5)/8)`, `v x²` and `-u`, all with limbs at most `kb`. -/
theorem pre_is (sa sb : BitVec 256) :
    let P := pre sa sb
    let y := ![yOf sa, yOf sb, 0, 0]
    let u := fun j => y j ^ 2 - 1
    let v := fun j => Ed25519.d * y j ^ 2 + 1
    P.y.Is y (fun _ => 2 ^ 51) ∧ P.u.Is u kb ∧ P.v.Is v kb ∧ P.v3.Is (fun j => v j ^ 3) kb ∧
      P.x.Is (fun j => u j * v j ^ 3 * (u j * v j ^ 7) ^ ((p - 5) / 8)) kb ∧
      P.vx2.Is (fun j => v j * (u j * v j ^ 3 * (u j * v j ^ 7) ^ ((p - 5) / 8)) ^ 2) kb ∧
      P.nu.Is (fun j => -u j) kb := by
  intro P y u v
  have b51 : ∀ j : Fin 4, (fun _ : Fin 4 => 2 ^ 51) j < 2 ^ 52 := fun _ => by norm_num
  have hy := yQ_is sa sb
  have hy2 := sqrQ_is hy b51
  have hu := fd_r52x5_quad_sub.spec_is hy2 oneQ_is kb_lt63 (fun _ => by norm_num)
  have hv := fd_r52x5_quad_add.spec_is (mulQ_is hy2 dQ_is kb_lt52 b51) oneQ_is
    (fun _ => by norm_num)
  have hv2 := sqrQ_is hv kb_lt52
  have hv3 := mulQ_is hv2 hv kb_lt52 kb_lt52
  have hv7 := mulQ_is (sqrQ_is hv3 kb_lt52) hv kb_lt52 kb_lt52
  have huv7 := mulQ_is hu hv7 kb_lt52 kb_lt52
  have he := pow22523Q_is huv7 kb_lt52
  have hx := mulQ_is (mulQ_is hu hv3 kb_lt52 kb_lt52) he kb_lt52 kb_lt52
  have hx2 := sqrQ_is hx kb_lt52
  have hvx2 := mulQ_is hv hx2 kb_lt52 kb_lt52
  have hnu := fd_r52x5_quad_neg.spec_is hu kb_le55
  generalize (p - 5) / 8 = e at he hx hvx2
  refine ⟨hy, hu, hv.congr (fun j => ?_) fun _ => le_rfl, hv3.congr (fun j => ?_) fun _ => le_rfl,
    hx.congr (fun j => ?_) fun _ => le_rfl, hvx2.congr (fun j => ?_) fun _ => le_rfl, hnu⟩
  · simp only [v]; ring
  · simp only [v]; ring
  · simp only [u, v]; ring
  · simp only [u, v]; ring

/-! ## The lane checks -/

theorem lane_canon_eq {A B : Quad5} (j : Fin 4) :
    fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec A j) (fd_r52x5_quad_lane_canon.spec B j) =
      if A.val j = B.val j then 1 else 0 := by
  obtain ⟨ca, va⟩ := fd_r52x5_canon.spec_canon (A.elem j)
  obtain ⟨cb, vb⟩ := fd_r52x5_canon.spec_canon (B.elem j)
  unfold fd_r52x5_quad_lane_canon.spec
  rw [Canon.limbs_eq ca cb, va, vb]

/-- Lane `j`'s check, for `vx2`, `u` and `nu` of values `w`, `a` and `-a`: `ok` is whether
`w = ±a`, `c` whether `w = -a ≠ a`. -/
theorem laneCheck_eq {vx2 u nu : Quad5} {w a : ZMod p} (j : Fin 4) (hw : vx2.val j = w)
    (ha : u.val j = a) (hn : nu.val j = -a) :
    laneCheck vx2 u nu j =
      (if w = a ∨ w = -a then 1 else 0, if w ≠ a ∧ w = -a then 1 else 0) := by
  simp only [laneCheck]
  rw [lane_canon_eq, lane_canon_eq, hw, ha, hn]
  by_cases h1 : w = a <;> by_cases h2 : w = -a <;> simp [h1, h2]
  subst h2
  rw [ite_eq_right h1, ite_eq_right h1]

/-! ## The points -/

theorem blend2Q_limb (b0 b1 : Bool) (S T : Quad5) (i : Fin 5) :
    (blend2Q b0 b1 S T).limb i = wlBlend b0 b1 false false (S.limb i) (T.limb i) := by
  fin_cases i <;> rfl

theorem blend2Q_elem (b0 b1 : Bool) (S T : Quad5) (j : Fin 4) :
    (blend2Q b0 b1 S T).elem j = if j = 0 then cond b0 (S.elem j) (T.elem j)
      else if j = 1 then cond b1 (S.elem j) (T.elem j) else T.elem j := by
  funext i
  simp only [Quad5.elem, blend2Q_limb]
  fin_cases j <;> cases b0 <;> cases b1 <;> rfl

theorem blend2Q_is {S T : Quad5} (b0 b1 : Bool) (hS : S.Is v b) (hT : T.Is w c) :
    (blend2Q b0 b1 S T).Is
      (fun j => if j = 0 then cond b0 (v j) (w j) else if j = 1 then cond b1 (v j) (w j) else w j)
      (fun j => if j = 0 then cond b0 (b j) (c j) else if j = 1 then cond b1 (b j) (c j) else c j) := by
  intro j
  simp only [Quad5.val, blend2Q_elem]
  split
  · cases b0
    · exact hT j
    · exact hS j
  split
  · cases b1
    · exact hT j
    · exact hS j
  exact hT j

theorem point_elem (X Y T : Quad5) (j : Fin 4) :
    (point X Y T j).elem 0 = X.elem j ∧ (point X Y T j).elem 1 = Y.elem j ∧
      (point X Y T j).elem 2 = Ref.fd_f25519_one.limbs ∧ (point X Y T j).elem 3 = T.elem j := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> funext i <;> fin_cases i <;> rfl

/-- `point` of reduced quads: the affine point `(x, y)` of lane `j`, its `T` being `x y`. -/
theorem point_affine {X Y T : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (hT : T.Below 52)
    (j : Fin 4) (ht : T.val j = X.val j * Y.val j) :
    (point X Y T j).Affine (X.val j) (Y.val j) ∧ (point X Y T j).Below 52 := by
  obtain ⟨e0, e1, e2, e3⟩ := point_elem X Y T j
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩
  · rw [Quad5.val, e0]
  · rw [Quad5.val, e1]
  · rw [Quad5.val, e2, one_val]
  · rw [Quad5.val, e3]; exact ht
  · intro k i
    match k with
    | 0 => rw [e0]; exact hX j i
    | 1 => rw [e1]; exact hY j i
    | 2 => rw [e2]; exact (one_le i).trans_lt (by norm_num)
    | 3 => rw [e3]; exact hT j i

/-! ## The sign fix-up -/

/-- `flip X j e`: whether the parity of lane `j`'s canonical value differs from `e`'s top bit. -/
theorem flip_iff (X : Quad5) (j : Fin 4) (e : BitVec 256) :
    fd_r52x5_ge_decode2.flip X j e = true ↔ (X.val j).val % 2 ≠ e.toNat / 2 ^ 255 := by
  obtain ⟨hc, hv⟩ := fd_r52x5_canon.spec_canon (X.elem j)
  have hn : (X.val j).val = Ed25519.Limbs.nat (fd_r52x5_canon.spec (X.elem j)) := by
    rw [Quad5.val, ← hv, Ed25519.Limbs.val_nat, ZMod.val_natCast, Nat.mod_eq_of_lt hc.2]
  have he := e.isLt
  have h0 := hc.1 0
  unfold fd_r52x5_ge_decode2.flip fd_r52x5_quad_lane_canon.spec
  rw [bne_iff_ne, ne_eq, ne_eq, BitVec.toNat_eq, hn]
  simp only [BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight,
    BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow, Ed25519.Limbs.nat,
    show (1#32).toNat = 1 from rfl]
  rw [Nat.and_one_is_mod]
  omega

/-! ## The decoded points -/

/-- Lane `j` of `points`' `x` (before the sign): `x0`, or `x0 √-1` where `c = 1`. -/
theorem points_x {x0 : Quad5} (hx : x0.Is v b) (hb : ∀ j, b j < 2 ^ 52) (c0 c1 : BitVec 32) :
    let xs := mulQ x0 sqrtm1Q
    let x := blend2Q (c0 == 1) (c1 == 1) xs x0
    x.Is (fun j => if j = 0 then cond (c0 == 1) (v j * Ed25519.sqrtM1) (v j)
        else if j = 1 then cond (c1 == 1) (v j * Ed25519.sqrtM1) (v j) else v j)
      (fun _ => 2 ^ 52 - 1) := by
  intro xs x
  have hs := mulQ_is hx sqrtm1Q_is hb fun _ => by norm_num
  refine (blend2Q_is _ _ hs hx).congr (fun j => rfl) fun j => ?_
  have := hb j
  split
  · cases c0 == 1
    · rw [Bool.cond_false]; omega
    · rw [Bool.cond_true]; norm_num
  split
  · cases c1 == 1
    · rw [Bool.cond_false]; omega
    · rw [Bool.cond_true]; norm_num
  omega

/-- The sign fix-up of lane `j ∈ {0, 1}` of `x`: `±x`, zero or of the parity `e`'s top bit asks
for, reduced. -/
theorem points_sign {x : Quad5} (hx : x.Is v b) (hb : ∀ j, b j < 2 ^ 52) (sa sb : BitVec 256) :
    let nx := fd_r52x5_quad_neg.spec x
    let x' := blend2Q (fd_r52x5_ge_decode2.flip x 0 sa) (fd_r52x5_ge_decode2.flip x 1 sb) nx x
    x'.Below 52 ∧ ∀ (j : Fin 4) (e : BitVec 256), (j = 0 ∧ e = sa) ∨ (j = 1 ∧ e = sb) →
      (x'.val j = v j ∨ x'.val j = -v j) ∧ (x'.val j = 0 ∨ (x'.val j).val % 2 = e.toNat / 2 ^ 255) := by
  intro nx x'
  have hn := fd_r52x5_quad_neg.spec_is hx fun j => (hb j).le.trans (by norm_num)
  have h := blend2Q_is (fd_r52x5_ge_decode2.flip x 0 sa) (fd_r52x5_ge_decode2.flip x 1 sb) hn hx
  refine ⟨h.below fun j => ?_, fun j e hj => ?_⟩
  · have := hb j
    split
    · cases fd_r52x5_ge_decode2.flip x 0 sa
      · rw [Bool.cond_false]; omega
      · rw [Bool.cond_true]; norm_num
    split
    · cases fd_r52x5_ge_decode2.flip x 1 sb
      · rw [Bool.cond_false]; omega
      · rw [Bool.cond_true]; norm_num
    omega
  · have hvj := h.val j
    have hlt := ZMod.val_lt (v j)
    have hp : p % 2 = 1 := by norm_num
    have he : e.toNat / 2 ^ 255 < 2 := by have := e.isLt; omega
    have key (f : Bool) (hf : f = true ↔ (v j).val % 2 ≠ e.toNat / 2 ^ 255)
        (hv : x'.val j = cond f (-v j) (v j)) :
        (x'.val j = v j ∨ x'.val j = -v j) ∧
          (x'.val j = 0 ∨ (x'.val j).val % 2 = e.toNat / 2 ^ 255) := by
      rw [hv]
      cases f with
      | false =>
        simp only [cond, true_or, true_and]
        have := mt hf.2 (by simp)
        push Not at this
        exact .inr this
      | true =>
        simp only [cond, or_true, true_and]
        have hne := hf.1 rfl
        by_cases h0 : v j = 0
        · exact .inl (by rw [h0, neg_zero])
        · refine .inr ?_
          rw [ZMod.neg_val, ite_eq_right h0]
          have : (v j).val ≠ 0 := by rwa [ne_eq, ZMod.val_eq_zero]
          omega
    rcases hj with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · refine key _ (by rw [flip_iff, hx.val]) ?_
      rw [hvj]; simp only [reduceIte]
    · refine key _ (by rw [flip_iff, hx.val]) ?_
      rw [hvj]; simp only [reduceIte, Fin.reduceEq]

/-! ## The decoder -/

/-- One lane's check: `ok` is whether the encoding decodes, and the chosen root is on the curve
with `y`. -/
theorem lane_root (e : BitVec 256) {x0 : ZMod p} {ex : ℕ} (hex : ex = (p - 5) / 8)
    (hx0 : x0 = (yOf e ^ 2 - 1) * (Ed25519.d * yOf e ^ 2 + 1) ^ 3 *
      ((yOf e ^ 2 - 1) * (Ed25519.d * yOf e ^ 2 + 1) ^ 7) ^ ex) :
    let u := yOf e ^ 2 - 1
    let v := Ed25519.d * yOf e ^ 2 + 1
    ((v * x0 ^ 2 = u ∨ v * x0 ^ 2 = -u) ↔ Ed25519.decode e ≠ none) ∧
      ((v * x0 ^ 2 = u ∨ v * x0 ^ 2 = -u) →
        OnCurve (cond (decide (v * x0 ^ 2 ≠ u ∧ v * x0 ^ 2 = -u)) (x0 * Ed25519.sqrtM1) x0)
          (yOf e)) := by
  intro u v
  subst hex
  refine ⟨?_, fun h => ?_⟩
  · rw [ne_eq, Ed25519.decode_eq_none, not_forall_not, Ed25519.exists_decodes_iff,
      Ed25519.exists_onCurve_iff, Ref.sqrt_ratio_iff (Ed25519.v_ne _) hx0]
  · rw [Ed25519.onCurve_iff]
    by_cases h1 : v * x0 ^ 2 = u
    · rw [decide_eq_false (by simp [h1]), Bool.cond_false]
      linear_combination h1
    · have h2 := h.resolve_left h1
      rw [decide_eq_true ⟨h1, h2⟩, Bool.cond_true]
      linear_combination (-1 : ZMod p) * h2 + x0 ^ 2 * v * Ed25519.sqrtM1_sq

theorem beq_one_ite (c : Prop) [Decidable c] :
    ((if c then (1 : BitVec 32) else 0) == (1 : BitVec 32)) = decide c := by
  by_cases h : c <;> simp [h]

/-- `points` on the root candidates `X` and `Y` of both lanes passing their checks: the points
decoding from `sa` and `sb`, affine and reduced. -/
theorem points_spec {X Y : Quad5} {vx vy : Fin 4 → ZMod p} {bx by' : Fin 4 → ℕ} (hX : X.Is vx bx)
    (hbx : ∀ j, bx j < 2 ^ 52) (hY : Y.Is vy by') (hby : ∀ j, by' j < 2 ^ 52) (sa sb : BitVec 256)
    (hya : vy 0 = yOf sa) (hyb : vy 1 = yOf sb) (ca cb : Prop) [Decidable ca] [Decidable cb]
    (ha : OnCurve (cond (decide ca) (vx 0 * Ed25519.sqrtM1) (vx 0)) (yOf sa))
    (hb : OnCurve (cond (decide cb) (vx 1 * Ed25519.sqrtM1) (vx 1)) (yOf sb)) :
    ∃ P Q, Ed25519.Decodes sa P ∧ Ed25519.Decodes sb Q ∧
      (points sa sb X Y (if ca then 1 else 0) (if cb then 1 else 0)).1.Affine P.x P.y ∧
      (points sa sb X Y (if ca then 1 else 0) (if cb then 1 else 0)).1.Below 52 ∧
      (points sa sb X Y (if ca then 1 else 0) (if cb then 1 else 0)).2.Affine Q.x Q.y ∧
      (points sa sb X Y (if ca then 1 else 0) (if cb then 1 else 0)).2.Below 52 := by
  simp only [points, beq_one_ite]
  have h1 := points_x hX hbx (if ca then 1 else 0) (if cb then 1 else 0)
  simp only [beq_one_ite] at h1
  obtain ⟨bX', hX'⟩ := points_sign h1 b52_lt sa sb
  generalize blend2Q (decide ca) (decide cb) (mulQ X sqrtm1Q) X = X1 at h1 bX' hX' ⊢
  generalize blend2Q (fd_r52x5_ge_decode2.flip X1 0 sa) (fd_r52x5_ge_decode2.flip X1 1 sb)
    (fd_r52x5_quad_neg.spec X1) X1 = X' at bX' hX' ⊢
  obtain ⟨sa1, sa2⟩ := hX' 0 sa (.inl ⟨rfl, rfl⟩)
  obtain ⟨sb1, sb2⟩ := hX' 1 sb (.inr ⟨rfl, rfl⟩)
  simp only [reduceIte, Fin.reduceEq] at sa1 sb1
  have hT := mulQ_is bX'.is hY b52_lt hby
  have pa := point_affine bX' (hY.below hby) (hT.below kb_lt52) 0 (by rw [hT.val, hY.val])
  have pb := point_affine bX' (hY.below hby) (hT.below kb_lt52) 1 (by rw [hT.val, hY.val])
  have ca' : OnCurve (X'.val 0) (yOf sa) := by
    rcases sa1 with h | h <;> rw [h]
    exacts [ha, ha.neg]
  have cb' : OnCurve (X'.val 1) (yOf sb) := by
    rcases sb1 with h | h <;> rw [h]
    exacts [hb, hb.neg]
  refine ⟨⟨_, _, ca'⟩, ⟨_, _, cb'⟩, ⟨rfl, sa2⟩, ⟨rfl, sb2⟩, ?_, pa.2, ?_, pb.2⟩
  · have := pa.1; rwa [hY.val, hya] at this
  · have := pb.1; rwa [hY.val, hyb] at this

theorem tail_eq (sa sb : BitVec 256) (X Y VX2 U NU : Quad5) {a0 b0 a1 b1 : BitVec 32}
    (hc0 : laneCheck VX2 U NU 0 = (a0, b0)) (hc1 : laneCheck VX2 U NU 1 = (a1, b1)) :
    tail sa sb X Y VX2 U NU =
      if a1 = 0 then (a0, none) else if a0 = 0 then (2, none)
      else (3, some (points sa sb X Y b0 b1)) := by
  simp only [tail, hc0, hc1]

/-- `fd_r52x5_ge_decode2` decodes as `decode` does. -/
public theorem decodeSpec : DecodeSpec := by
  intro sa sb D
  obtain ⟨hy, hu, hv, hv3, hx, hvx2, hnu⟩ := pre_is sa sb
  have hD : D = tail sa sb (pre sa sb).x (pre sa sb).y (pre sa sb).vx2 (pre sa sb).u (pre sa sb).nu :=
    rfl
  clear_value D
  generalize (pre sa sb).x = X at hx hD
  generalize (pre sa sb).y = Y at hy hD
  generalize (pre sa sb).vx2 = VX2 at hvx2 hD
  generalize (pre sa sb).u = U at hu hD
  generalize (pre sa sb).nu = NU at hnu hD
  clear hv hv3
  generalize hex : (p - 5) / 8 = ex at hx hvx2
  have hx0 := hx.val 0
  have hx1 := hx.val 1
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one] at hx0 hx1
  have hw0 : VX2.val 0 = (Ed25519.d * yOf sa ^ 2 + 1) * X.val 0 ^ 2 := by
    rw [hvx2.val 0, hx0]; simp only [Matrix.cons_val_zero]
  have hw1 : VX2.val 1 = (Ed25519.d * yOf sb ^ 2 + 1) * X.val 1 ^ 2 := by
    rw [hvx2.val 1, hx1]; simp only [Matrix.cons_val_one, Matrix.cons_val_zero]
  have hu0 : U.val 0 = yOf sa ^ 2 - 1 := by rw [hu.val 0]; simp only [Matrix.cons_val_zero]
  have hu1 : U.val 1 = yOf sb ^ 2 - 1 := by
    rw [hu.val 1]; simp only [Matrix.cons_val_one, Matrix.cons_val_zero]
  have hn0 : NU.val 0 = -(yOf sa ^ 2 - 1) := by rw [hnu.val 0]; simp only [Matrix.cons_val_zero]
  have hn1 : NU.val 1 = -(yOf sb ^ 2 - 1) := by
    rw [hnu.val 1]; simp only [Matrix.cons_val_one, Matrix.cons_val_zero]
  -- the lane checks
  have c0 := laneCheck_eq 0 hw0 hu0 hn0
  have c1 := laneCheck_eq 1 hw1 hu1 hn1
  have ra := lane_root sa hex.symm hx0
  have rb := lane_root sb hex.symm hx1
  rw [hD, tail_eq sa sb X Y VX2 U NU c0 c1]
  have hX52 := hx.below kb_lt52
  clear c0 c1 hD hx0 hx1 hvx2 hu hnu hx hex hw0 hw1 hu0 hu1 hn0 hn1
  obtain ⟨ra1, ra2⟩ := ra
  obtain ⟨rb1, rb2⟩ := rb
  have h10 : ¬ ((1 : BitVec 32) = 0) := by decide
  by_cases ha : (Ed25519.d * yOf sa ^ 2 + 1) * X.val 0 ^ 2 = yOf sa ^ 2 - 1 ∨
      (Ed25519.d * yOf sa ^ 2 + 1) * X.val 0 ^ 2 = -(yOf sa ^ 2 - 1)
  <;> by_cases hb : (Ed25519.d * yOf sb ^ 2 + 1) * X.val 1 ^ 2 = yOf sb ^ 2 - 1 ∨
      (Ed25519.d * yOf sb ^ 2 + 1) * X.val 1 ^ 2 = -(yOf sb ^ 2 - 1)
  · -- both lanes decode
    have da : Ed25519.decode sa ≠ none := ra1.1 ha
    have db : Ed25519.decode sb ≠ none := rb1.1 hb
    simp only [ite_eq_left ha, ite_eq_left hb, h10, ↓reduceIte]
    refine ⟨fun h => absurd h da, fun _ _ h => absurd h db, fun P Q hP hQ => ?_⟩
    obtain ⟨P', Q', dP, dQ, aP, bP, aQ, bQ⟩ :=
      points_spec hX52.is b52_lt hy (fun _ => by norm_num) sa sb rfl rfl _ _ (ra2 ha) (rb2 hb)
    rw [(Ed25519.decodes_of_decode hP).unique dP, (Ed25519.decodes_of_decode hQ).unique dQ]
    exact ⟨_, _, rfl, aP, bP, aQ, bQ⟩
  · -- lane 0 decodes, lane 1 fails
    have da : Ed25519.decode sa ≠ none := ra1.1 ha
    have db : Ed25519.decode sb = none := by
      by_contra h; exact hb (rb1.2 h)
    simp only [ite_eq_left ha, ite_eq_right hb, ↓reduceIte]
    refine ⟨fun h => absurd h da, fun _ _ _ => ⟨trivial, by decide⟩, fun _ _ _ hQ => ?_⟩
    rw [db] at hQ; exact absurd hQ (by simp)
  · -- lane 0 fails
    have da : Ed25519.decode sa = none := by
      by_contra h; exact ha (ra1.2 h)
    simp only [ite_eq_right ha, ite_eq_left hb, h10, ↓reduceIte]
    refine ⟨fun _ => ⟨trivial, by decide⟩, fun _ hP => ?_, fun _ _ hP => ?_⟩
    all_goals rw [da] at hP; exact absurd hP (by simp)
  · have da : Ed25519.decode sa = none := by
      by_contra h; exact ha (ra1.2 h)
    simp only [ite_eq_right ha, ite_eq_right hb, ↓reduceIte]
    refine ⟨fun _ => ⟨trivial, by decide⟩, fun _ hP => ?_, fun _ _ hP => ?_⟩
    all_goals rw [da] at hP; exact absurd hP (by simp)

open fd_r52x5_double_scalar_mul_base in
/-- `fd_ed25519_verify.call_ret'` with the decoder discharged: the result is
`Ed25519.Firedancer.verify` given the equation spec of the base table. -/
public theorem fd_ed25519_verify.call_ret'' (msg : Pointer) (msgSz : BitVec 64)
    (sig pk sha : Pointer) (TB : Nat → Quad5) (heq : EquationSpec TB)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_ed25519_verify.globals) (flB tbB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hfl : Fits s.mem ⟨flB, 0⟩ 1) (hset : s.mem.readAt ⟨flB, 0⟩ 1 = 1)
    (hTB : TableAt s.mem ⟨tbB, 0⟩ 128 TB)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hsha_fl : sha.id ≠ flB) (hsha_tb : sha.id ≠ tbB) :
    ∃ s',
      fd_ed25519_verify.call
          (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha))
          s =
        .value
          (.cons
              (.value
                (Ed25519.Firedancer.verify (Ed25519.bytesLE (s.mem.readAt msg (8 * msgSz.toNat)))
                  (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
              .nil,
            s') :=
  fd_ed25519_verify.call_ret' msg msgSz sig pk sha TB decodeSpec heq s hwf hg flB tbB hgf hgb hfl
    hset hTB hmsg hmsg_off hmsgSz hsig hsig_off hpk hpk_off hsha hshaw hmsg_sha hsig_sha hpk_sha
    hsha_fl hsha_tb

end MLIR.Firedancer.Crc.Verify

module

public import Ed25519.Decode
public import Ed25519.Order
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar

/-! The group has `8 ℓ` points: at most `2 p`, as `y` and `x`'s parity fix a point; a multiple of
`ℓ`, prime, the base point's order; and a multiple of 8, a point's order. -/

namespace Ed25519

/-! ## Proof macros -/

/-- `Nat.Prime n` by `prime_of_pratt a fs`; `norm_num` proves the factors prime except `hs`'s. As in
`Ed25519.Field`. -/
local macro "pratt " a:term:max fs:term:max " [" hs:term,* "]" : tactic =>
  `(tactic| (
    refine $(Lean.mkIdent `prime_of_pratt) $a $fs ?_ ?_ ?_ ?_
    · norm_num
    · simp only [List.forall_mem_cons, List.not_mem_nil, IsEmpty.forall_iff, implies_true,
        and_true, true_and, $[$hs:term],*]
      norm_num
    · reduce_mod_char
    · simp only [List.forall_mem_cons, List.not_mem_nil, IsEmpty.forall_iff, implies_true,
        and_true]
      repeat' apply And.intro
      all_goals reduce_mod_char; decide))

/-! ## `ℓ` is prime -/

section Prime

public theorem prime_1224481 : Nat.Prime 1224481 := by
  pratt 13 [(2, 5), (3, 1), (5, 1), (2551, 1)] []

public theorem prime_14741173 : Nat.Prime 14741173 := by
  pratt 2 [(2, 2), (3, 2), (409477, 1)] []

public theorem prime_58964693 : Nat.Prime 58964693 := by
  pratt 2 [(2, 2), (14741173, 1)] [prime_14741173]

public theorem prime_292386187 : Nat.Prime 292386187 := by
  pratt 2 [(2, 1), (3, 4), (307, 1), (5879, 1)] []

public theorem prime_213441916511 : Nat.Prime 213441916511 := by
  pratt 13 [(2, 1), (5, 1), (73, 1), (292386187, 1)] [prime_292386187]

public theorem prime_1257559732178653 : Nat.Prime 1257559732178653 := by
  pratt 2 [(2, 2), (3, 1), (7, 1), (23, 1), (531581, 1), (1224481, 1)] [prime_1224481]

public theorem prime_4434155615661930479 : Nat.Prime 4434155615661930479 := by
  pratt 17 [(2, 1), (41, 1), (43, 1), (1257559732178653, 1)] [prime_1257559732178653]

public theorem prime_3044861653679985063343 : Nat.Prime 3044861653679985063343 := by
  pratt 5 [(2, 1), (3, 1), (11, 1), (30703, 1), (82163, 1), (132667, 1), (137849, 1)] []

public theorem prime_172054593956031949258510691 : Nat.Prime 172054593956031949258510691 := by
  pratt 2 [(2, 1), (5, 1), (1361, 1), (2851, 1), (4434155615661930479, 1)]
    [prime_4434155615661930479]

public theorem prime_198211423230930754013084525763697 :
    Nat.Prime 198211423230930754013084525763697 := by
  pratt 5 [(2, 4), (3, 1), (23, 1), (58964693, 1), (3044861653679985063343, 1)]
    [prime_58964693, prime_3044861653679985063343]

public theorem prime_19757330305831588566944191468367130476339 :
    Nat.Prime 19757330305831588566944191468367130476339 := by
  pratt 2 [(2, 1), (269, 1), (213441916511, 1), (172054593956031949258510691, 1)]
    [prime_213441916511, prime_172054593956031949258510691]

public theorem prime_276602624281642239937218680557139826668747 :
    Nat.Prime 276602624281642239937218680557139826668747 := by
  pratt 2 [(2, 1), (7, 1), (19757330305831588566944191468367130476339, 1)]
    [prime_19757330305831588566944191468367130476339]

public theorem prime_ell : ell.Prime := by
  rw [show ell = 7237005577332262213973186563042994240857116359379907606001950938285454250989 by
    unfold ell; norm_num]
  pratt 2
    [(2, 2), (3, 1), (11, 1), (198211423230930754013084525763697, 1),
      (276602624281642239937218680557139826668747, 1)]
    [prime_198211423230930754013084525763697, prime_276602624281642239937218680557139826668747]

public instance fact_prime_ell : Fact ell.Prime :=
  ⟨prime_ell⟩

end Prime

/-! ## At most `2 p` points -/

/-- `P` decodes from `y`'s value plus `2²⁵⁵` times `x`'s parity. -/
theorem decodes_parity (P : Point) :
    Decodes (BitVec.ofNat 256 (P.y.val + 2 ^ 255 * (P.x.val % 2))) P := by
  have h1 : P.y.val < 2 ^ 255 := (ZMod.val_lt P.y).trans (by decide)
  have h2 := Nat.mod_lt P.x.val (by decide : 0 < 2)
  have e : (BitVec.ofNat 256 (P.y.val + 2 ^ 255 * (P.x.val % 2))).toNat =
      P.y.val + 2 ^ 255 * (P.x.val % 2) := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨?_, .inr ?_⟩ <;> rw [e]
  · rw [Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt h1, ZMod.natCast_zmod_val]
  · omega

/-- A point is fixed by `y` and `x`'s parity. -/
public theorem Point.injective_y_parity :
    Function.Injective fun P : Point => (P.y, (P.x.val : ZMod 2)) := by
  intro P Q h
  obtain ⟨hy, hx⟩ := Prod.mk.inj h
  rw [ZMod.natCast_eq_natCast_iff'] at hx
  refine (decodes_parity P).unique ?_
  rw [hy, hx]
  exact decodes_parity Q

public instance : Finite Point :=
  .of_injective _ Point.injective_y_parity

/-- At most `2 p` points. -/
public theorem Point.card_le : Nat.card Point ≤ 2 * p := by
  have h := Nat.card_le_card_of_injective _ Point.injective_y_parity
  rwa [Nat.card_prod, Nat.card_zmod, Nat.card_zmod, mul_comm] at h

/-! ## A point of order 8 -/

/-- An order-8 point's `x`, the even root for `y8`. -/
@[expose]
public def x8 : ZMod p :=
  14399317868200118260347934320527232580618823971194345261214217575416788799818

public theorem onCurve_8 : OnCurve x8 y8 := by
  unfold OnCurve x8 y8 d
  reduce_mod_char

/-- `(x8, y8)` has order 8: its double has `y = 0`, so order 4. -/
public theorem addOrderOf_8 : addOrderOf (⟨x8, y8, onCurve_8⟩ : Point) = 8 := by
  set T : Point := ⟨x8, y8, onCurve_8⟩
  have h2 : (2 • T).y = 0 := by
    have e := Point.dbl_eq T
    rw [← two_smul ℕ] at e
    rw [show (2 • T).y = (dbl T.x T.y).2 by rw [e]]
    exact (dbl_snd_eq_zero T.on).2 ((sq_add_sq_eq_zero T.on).2 (.inl rfl))
  have h4 : ¬2 ^ 2 • T = 0 := by
    intro h
    have e := Point.dbl_eq (2 • T)
    rw [← two_smul ℕ (2 • T), smul_smul, dbl_of_snd (2 • T).on h2] at e
    have hy := congrArg Prod.snd e
    rw [show 2 * 2 = 2 ^ 2 from rfl, h, Point.zero_y] at hy
    exact absurd hy (by decide)
  have h8 : 2 ^ 3 • T = 0 :=
    (Point.smallOrder_iff_nsmul T).1 ((smallOrder_iff T.on).2 (.inr (.inr (.inl rfl))))
  exact addOrderOf_eq_prime_pow h4 h8

/-! ## The group's order -/

/-- `B ≠ 0`. -/
public theorem basePoint_ne_zero : basePoint ≠ 0 := fun h => by
  have hx := congrArg Point.x h
  rw [Point.zero_x] at hx
  exact absurd hx (by unfold basePoint Bx; decide)

/-- The group has `8 ℓ` points. -/
public theorem Point.card : Nat.card Point = 8 * ell := by
  have hℓ : ell ∣ Nat.card Point :=
    addOrderOf_eq_prime ell_smul_basePoint basePoint_ne_zero ▸ addOrderOf_dvd_natCard _
  have h8 : 8 ∣ Nat.card Point := addOrderOf_8 ▸ addOrderOf_dvd_natCard _
  obtain ⟨k, hk⟩ := (Nat.Coprime.mul_dvd_of_dvd_of_dvd (by unfold ell; decide) h8 hℓ :
    8 * ell ∣ Nat.card Point)
  have hpos : 0 < Nat.card Point := Nat.card_pos
  have hle := Point.card_le
  have hp : 2 * p < 8 * ell * 2 := by unfold ell; decide
  rw [hk] at hpos hle
  have : k < 2 := Nat.lt_of_mul_lt_mul_left (hle.trans_lt hp)
  have : k ≠ 0 := by rintro rfl; simp at hpos
  rw [hk, show k = 1 by omega, mul_one]

end Ed25519

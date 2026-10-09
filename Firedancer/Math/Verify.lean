module

public import Firedancer.Math.Group
public import Firedancer.Math.Curve
public import Firedancer.Math.Sha512
public import Firedancer.Math.Scalar
public import Firedancer.Math.Dsmb
public import Firedancer.Ref.fd_ed25519_verify
import Mathlib.Tactic.Abel
import Mathlib.Tactic.LinearCombination

/-! Ed25519 verification as mathematics: decoding points from 32 bytes, and the checks
`fd_ed25519_verify` performs, in its order. -/

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Definitions -/

@[expose] public section

namespace Ed25519

/-- `P` is a point `buf` encodes: `y` the low 255 bits mod `p`, `x` of the top bit's parity, any
sign accepted for `x = 0` (non-canonical encodings accepted, as Dalek does). -/
def Decodes (buf : BitVec 256) (P : Point) : Prop :=
  P.y = ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧ (P.x = 0 ∨ P.x.val % 2 = buf.toNat / 2 ^ 255)

instance : DecidableEq Point := fun P Q =>
  decidable_of_iff (P.x = Q.x ∧ P.y = Q.y) (by rw [Point.ext_iff])

/-- Bytes as a little-endian number. -/
def natLE : List (BitVec 8) → ℕ
  | [] => 0
  | b :: l => b.toNat + 256 * natLE l

/-- The point `buf` encodes, if any. -/
noncomputable def decode (buf : BitVec 256) : Option Point :=
  open Classical in
  if h : ∃ P, Decodes buf P then some (Classical.choose h) else none

/-- Ed25519 verification of `S`, `r` against the key `A` and message `msg`, in
`fd_ed25519_verify`'s order and error codes: `S < ℓ`; `A`, `R` decode and are not of small order;
then `[S]B = R + [k]A` for `k` the SHA-512 digest of `r ‖ A ‖ msg`, mod `ℓ`. -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 32 :=
  if ell ≤ S.toNat then -1#32
  else
    match decode A, decode r with
    | some PA, some PR =>
      if 8 • PA = 0 then -2#32
      else if 8 • PR = 0 then -1#32
      else
        let k := natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell
        if S.toNat • basePoint = PR + k • PA then 0#32 else -3#32
    | none, _ => -2#32
    | some _, none => -1#32

end Ed25519

end

/-! ## Bytes -/

section Bytes

theorem Ed25519.natLE_ofFn (x : BitVec w) (o m : ℕ) :
    Ed25519.natLE (List.ofFn fun i : Fin m => x.extractLsb' (o + 8 * i) 8) =
      x.toNat / 2 ^ o % 2 ^ (8 * m) := by
  induction m generalizing o with
  | zero => simp [Ed25519.natLE, Nat.mod_one]
  | succ m ih =>
    rw [List.ofFn_succ, Ed25519.natLE]
    have e : (fun i : Fin m => x.extractLsb' (o + 8 * (i.succ : ℕ)) 8) =
        fun i : Fin m => x.extractLsb' ((o + 8) + 8 * (i : ℕ)) 8 := by
      funext i
      simp only [Fin.val_succ]
      congr 1
      omega
    simp only [Fin.val_zero, mul_zero, add_zero, e, ih, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, pow_add, ← Nat.div_div_eq_div_mul]
    generalize x.toNat / 2 ^ o = q
    rw [show 8 * (m + 1) = 8 + 8 * m by omega, pow_add, Nat.mod_mul]
    rfl

/-- `bytesLE` read back as a little-endian number is the bit vector's value. -/
public theorem Ed25519.natLE_bytesLE (x : BitVec (8 * n)) :
    Ed25519.natLE (bytesLE x) = x.toNat := by
  have h := Ed25519.natLE_ofFn x 0 n
  simp only [zero_add, pow_zero, Nat.div_one] at h
  rw [bytesLE, show 8 * n / 8 = n by omega]
  rw [h]
  exact Nat.mod_eq_of_lt x.isLt

end Bytes

/-! ## Decoding -/

section Decode

namespace Ed25519

/-- On the curve, `y` fixes `x²`. -/
theorem sq_eq_of_onCurve {x x' y : ZMod p} (h : OnCurve x y) (h' : OnCurve x' y) :
    x ^ 2 = x' ^ 2 := by
  have hne := one_add_ne 1 y
  unfold OnCurve at h h'
  have : (1 + d * 1 ^ 2 * y ^ 2) * (x ^ 2 - x' ^ 2) = 0 := by linear_combination h' - h
  exact sub_eq_zero.1 ((mul_eq_zero.1 this).resolve_left hne)

/-- At most one point decodes from `buf`. -/
public theorem Decodes.unique {buf : BitVec 256} {P Q : Point} (hP : Decodes buf P)
    (hQ : Decodes buf Q) : P = Q := by
  have hy : P.y = Q.y := hP.1.trans hQ.1.symm
  have hx2 := sq_eq_of_onCurve P.on (hy ▸ Q.on)
  have : (P.x - Q.x) * (P.x + Q.x) = 0 := by linear_combination hx2
  ext
  · rcases mul_eq_zero.1 this with h | h
    · exact sub_eq_zero.1 h
    · -- `Q.x = -P.x`: the parities differ unless both are zero
      have hq : Q.x = -P.x := by linear_combination h
      rcases eq_or_ne P.x 0 with h0 | h0
      · rw [hq, h0, neg_zero]
      · exfalso
        have hp : (-P.x).val = p - P.x.val := by rw [ZMod.neg_val, ite_eq_right h0]
        have hlt := ZMod.val_lt P.x
        have hpos : 0 < P.x.val := (ZMod.val_pos).2 h0
        have hp2 : p % 2 = 1 := by norm_num
        rcases hP.2 with hP0 | hP2
        · exact h0 hP0
        rcases hQ.2 with hQ0 | hQ2
        · exact h0 (by rw [hq] at hQ0; exact neg_eq_zero.1 hQ0)
        rw [hq, hp] at hQ2
        omega
  · exact hy

/-- `decode` finds the point that decodes. -/
public theorem decode_eq_some {buf : BitVec 256} {P : Point} (h : Decodes buf P) :
    decode buf = some P := by
  have hex : ∃ P, Decodes buf P := ⟨P, h⟩
  simp only [decode, hex, dite_true, Option.some.injEq]
  exact (Classical.choose_spec hex).unique h

/-- `decode` fails exactly when no point decodes. -/
public theorem decode_eq_none {buf : BitVec 256} : decode buf = none ↔ ∀ P, ¬Decodes buf P := by
  simp only [decode]
  split
  · next h => simp only [reduceCtorEq, false_iff, not_forall, not_not]; exact h
  · next h => simpa using h

/-- A point with `buf`'s `y` exists exactly when one decodes: `x` or `-x` has the right parity. -/
public theorem exists_decodes_iff (buf : BitVec 256) :
    (∃ P, Decodes buf P) ↔ ∃ x, OnCurve x ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  constructor
  · rintro ⟨P, hy, -⟩
    exact ⟨P.x, hy ▸ P.on⟩
  · rintro ⟨x, hx⟩
    have hb : buf.toNat / 2 ^ 255 < 2 := by have := buf.isLt; omega
    by_cases h : x = 0 ∨ x.val % 2 = buf.toNat / 2 ^ 255
    · exact ⟨⟨x, _, hx⟩, rfl, h⟩
    · refine ⟨⟨-x, _, hx.neg⟩, rfl, .inr ?_⟩
      push Not at h
      rw [ZMod.neg_val, ite_eq_right h.1]
      have hlt := ZMod.val_lt x
      have hp2 : p % 2 = 1 := by norm_num
      omega

end Ed25519

/-- `frombytes` fails exactly when `decode` does. -/
public theorem fd_ed25519_point_frombytes.spec_eq_none_iff_decode (buf : BitVec 256) :
    fd_ed25519_point_frombytes.spec buf = none ↔ Ed25519.decode buf = none := by
  rw [fd_ed25519_point_frombytes.spec_eq_none_iff, Ed25519.decode_eq_none, ← not_exists,
    ← not_exists, Ed25519.exists_decodes_iff]

/-- A point `frombytes` returns is the one `decode` finds, affine, with the limb bounds the
callers need. -/
public theorem fd_ed25519_point_frombytes.spec_some_decode {buf : BitVec 256} {P : PointLimbs}
    (h : fd_ed25519_point_frombytes.spec buf = some P) :
    ∃ Q, Ed25519.decode buf = some Q ∧ P.Ext Q.x Q.y ∧ Limbs.val P.Z = 1 ∧ Limbs.Under2p P.X ∧
      Limbs.nat P.X < 2 * p ∧ Limbs.Tight P.Y ∧ Limbs.Tight P.T ∧ Limbs.Tight P.Z := by
  obtain ⟨x, he, hc, hpar, hz, hX, hXn, hY, hT, hZ⟩ := fd_ed25519_point_frombytes.spec_some h
  exact ⟨⟨x, _, hc⟩, Ed25519.decode_eq_some ⟨rfl, hpar⟩, he, hz, hX, hXn, hY, hT, hZ⟩

/-- An affine point's limbs hold its coordinates. -/
theorem PointLimbs.ext_val_xy {P : PointLimbs} {x y : ZMod p} (h : P.Ext x y)
    (hz : Limbs.val P.Z = 1) : Limbs.val P.X = x ∧ Limbs.val P.Y = y := by
  obtain ⟨-, hx, hy, -⟩ := h
  exact ⟨by rw [hx, hz, mul_one], by rw [hy, hz, mul_one]⟩

/-- `is_small_order` on a decoded point decides `8 P = 0`. -/
theorem fd_ed25519_affine_is_small_order.spec_decoded {P : PointLimbs} {Q : Ed25519.Point}
    (he : P.Ext Q.x Q.y) (hz : Limbs.val P.Z = 1) (hX : Limbs.Under2p P.X)
    (hXn : Limbs.nat P.X < 2 * p) (hY : Limbs.Tight P.Y) :
    fd_ed25519_affine_is_small_order.spec P = if 8 • Q = 0 then 1#32 else 0#32 := by
  obtain ⟨vx, vy⟩ := PointLimbs.ext_val_xy he hz
  rw [fd_ed25519_affine_is_small_order.spec_val hX hXn hY (by rw [vx, vy]; exact Q.on), vx, vy]
  exact if_congr (Ed25519.Point.smallOrder_iff_nsmul Q) rfl rfl

end Decode

/-! ## Verification -/

section Verify

open fd_ed25519_double_scalar_mul_base in
/-- `fd_ed25519_verify`'s return code, on the base point's table, is `Ed25519.verify`'s. -/
public theorem fd_ed25519_verify.spec_ret (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat))
    (r S A : BitVec 256) (buf0 : BitVec 1024) :
    (fd_ed25519_verify.spec baseTbl msgSz msg r S A buf0).ret =
      Ed25519.verify (bytesLE msg) r S A := by
  have hval := fd_curve25519_scalar_validate.spec_iff S
  -- the table stays opaque: unfolded, the kernel would evaluate its 20 KB literal
  generalize hT : baseTbl = tbl
  -- by the equations: unfolding under `.ret` by defeq makes the kernel evaluate `validate S`
  rw [fd_ed25519_verify.spec, Ed25519.verify]
  by_cases hS : Ed25519.ell ≤ S.toNat
  · have : fd_curve25519_scalar_validate.spec S = false := by
      cases h : fd_curve25519_scalar_validate.spec S
      · rfl
      · exact absurd (hval.1 h) (Nat.not_lt.2 hS)
    rw [ite_eq_left (by rw [this]; rfl), ite_eq_left hS]
  have hv : fd_curve25519_scalar_validate.spec S = true := hval.2 (Nat.lt_of_not_le hS)
  have hSl : S.toNat < Ed25519.ell := Nat.lt_of_not_le hS
  -- `rw`, not `simp`: changing the `if`'s condition re-checks its instance, `validate S` unfolded
  rw [ite_eq_right (by rw [hv]; decide), ite_eq_right hS]
  -- both decodings as constructors, so the `match`es reduce without evaluating `frombytes`
  rcases hAo : fd_ed25519_point_frombytes.spec A with _ | Ap <;>
    rcases hRo : fd_ed25519_point_frombytes.spec r with _ | Rp
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -1#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo]; rfl
    rw [(fd_ed25519_point_frombytes.spec_eq_none_iff_decode A).1 hAo, hres]
    rfl
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -1#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo]; rfl
    rw [(fd_ed25519_point_frombytes.spec_eq_none_iff_decode A).1 hAo, hres]
    rfl
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -2#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo, hRo]; rfl
    obtain ⟨PA, hdA, -⟩ := fd_ed25519_point_frombytes.spec_some_decode hAo
    rw [hdA, (fd_ed25519_point_frombytes.spec_eq_none_iff_decode r).1 hRo, hres]
    rfl
  obtain ⟨PA, hdA, heA, hzA, hXA, hXnA, hYA, hTA, hZA⟩ :=
    fd_ed25519_point_frombytes.spec_some_decode hAo
  obtain ⟨PR, hdR, heR, hzR, hXR, hXnR, hYR, hTR, hZR⟩ :=
    fd_ed25519_point_frombytes.spec_some_decode hRo
  rw [hdA, hdR]
  dsimp only
  rw [fd_ed25519_affine_is_small_order.spec_decoded heA hzA hXA hXnA hYA,
    fd_ed25519_affine_is_small_order.spec_decoded heR hzR hXR hXnR hYR]
  by_cases h8A : 8 • PA = 0
  · rw [ite_eq_left h8A, ite_eq_left (by decide), ite_eq_left h8A]
  rw [ite_eq_right h8A, ite_eq_right (by decide), ite_eq_right h8A]
  by_cases h8R : 8 • PR = 0
  · rw [ite_eq_left h8R, ite_eq_left (by decide), ite_eq_left h8R]
  rw [ite_eq_right h8R, ite_eq_right (by decide), ite_eq_right h8R]
  -- the hash, reduced
  have hd := fd_ed25519_verify.hash_eq buf0 r A msgSz msg
  generalize fd_ed25519_verify.hash buf0 r A msgSz msg = H at hd ⊢
  obtain ⟨sha4, kw⟩ := H
  have hk : (fd_curve25519_scalar_reduce.spec (Words8.bits kw)).toNat =
      Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell := by
    rw [fd_curve25519_scalar_reduce.spec_val, ← hd, Ed25519.natLE_bytesLE (n := 64)]
  generalize fd_curve25519_scalar_reduce.spec (Words8.bits kw) = k at hk ⊢
  have hkl : k.toNat < 2 ^ 255 := by
    have := Nat.mod_lt (Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
      (show 0 < Ed25519.ell by unfold Ed25519.ell; decide)
    have := Ed25519.ell_lt
    omega
  -- `-A'`, then `k (-A') + S B`
  obtain ⟨heN, bXN, bTN⟩ := fd_ed25519_point_neg.spec_ext heA hXA hTA.under2p
  obtain ⟨heQ, bQ⟩ := fd_ed25519_double_scalar_mul_base.spec_val_base (-PA)
    (A := fd_ed25519_point_neg.spec Ap) (n1 := k) (n2 := S) heN bXN hYA bTN hZA hzA hkl
    (by have := Ed25519.ell_lt; omega)
  rw [hT] at heQ bQ
  rw [fd_ed25519_point_eq_z1.spec_val ⟨heQ.1, heQ.2.1, heQ.2.2.1⟩ bQ.1 bQ.2.1 bQ.2.2.2.loose
    hXR.loose hYR.loose]
  obtain ⟨vx, vy⟩ := PointLimbs.ext_val_xy heR hzR
  rw [vx, vy, hk]
  generalize Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell = n
  have key : (PR.x = (n • -PA + S.toNat • Ed25519.basePoint).x ∧
      PR.y = (n • -PA + S.toNat • Ed25519.basePoint).y) ↔
      S.toNat • Ed25519.basePoint = PR + n • PA := by
    rw [← Ed25519.Point.ext_iff, smul_neg]
    constructor <;> intro h
    · rw [h]; abel
    · rw [← sub_eq_iff_eq_add.2 h]; abel
  by_cases hq : S.toNat • Ed25519.basePoint = PR + n • PA
  · rw [ite_eq_left (key.2 hq), ite_eq_right (by decide), ite_eq_left hq]
  · rw [ite_eq_right (mt key.1 hq), ite_eq_left rfl, ite_eq_right hq]

end Verify

end LeanMLIR.RIR.Firedancer.Ref

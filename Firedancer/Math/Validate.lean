module

import all Firedancer.Math.Curve
public import Firedancer.Math.GroupOps
public import Firedancer.Math.Jacobi
public import Firedancer.Ref.fd_ed25519_point_validate
public import Firedancer.Ref.fd_f25519_is_square_var
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.FieldSimp
import Std.Tactic.BVDecide

/-! `fd_f25519_is_square_var` decides squares in `ZMod p` on every input (the Jacobi symbol when
`jacobi_var` converges, `sqrt_ratio` when not), and `fd_ed25519_point_validate` accepts exactly the
encodings `fd_ed25519_point_frombytes` decodes. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 fd_f25519_update_fg_62_var

namespace fd_f25519_is_square_var

/-- The four `ulong`s of `buf` are all zero exactly when `buf` is. -/
theorem words_eq_zero (buf : BitVec 256) :
    (buf.extractLsb' 0 64 ||| buf.extractLsb' 64 64 ||| buf.extractLsb' 128 64 |||
          buf.extractLsb' 192 64) =
        0#64 ↔
      buf = 0#256 := by
  bv_decide

/-- The 62-bit limbs `is_square_var` builds from `buf`'s words. -/
theorem limbs_eq (buf : BitVec 256) :
    let a0 := buf.extractLsb' 0 64
    let a1 := buf.extractLsb' 64 64
    let a2 := buf.extractLsb' 128 64
    let a3 := buf.extractLsb' 192 64
    a0 &&& M62 = (buf >>> 0).setWidth 64 &&& M62 ∧
      ((a0 >>> 62) ||| (a1 <<< 2)) &&& M62 = (buf >>> 62).setWidth 64 &&& M62 ∧
      ((a1 >>> 60) ||| (a2 <<< 4)) &&& M62 = (buf >>> 124).setWidth 64 &&& M62 ∧
      ((a2 >>> 58) ||| (a3 <<< 6)) &&& M62 = (buf >>> 186).setWidth 64 &&& M62 ∧
      a3 >>> 56 = (buf >>> 248).setWidth 64 := by
  simp only [M62]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- A masked window of `buf`. -/
theorem toNat_window (buf : BitVec 256) (o : ℕ) :
    ((buf >>> o).setWidth 64 &&& M62).toNat = buf.toNat / 2 ^ o % 2 ^ 62 := by
  have hM : M62.toNat = 2 ^ 62 - 1 := by decide
  rw [BitVec.toNat_and, hM, Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_setWidth,
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, Nat.mod_mod_of_dvd _ (by decide)]

/-- `is_square_var`'s body after `tobytes`, on `buf` the canonical bytes of `a`. -/
theorem core {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) (buf : BitVec 256)
    (hb : buf.toNat = (Limbs.val a).val) :
    (let a0 := buf.extractLsb' 0 64
    let a1 := buf.extractLsb' 64 64
      let a2 := buf.extractLsb' 128 64
      let a3 := buf.extractLsb' 192 64
      if (a0 ||| a1 ||| a2 ||| a3) = 0#64 then 1#32
      else
        let x : Vector (BitVec 64) 5 :=
          #v[a0 &&& M62, ((a0 >>> 62) ||| (a1 <<< 2)) &&& M62, ((a1 >>> 60) ||| (a2 <<< 4)) &&& M62,
            ((a2 >>> 58) ||| (a3 <<< 6)) &&& M62, a3 >>> 56]
        let jac := fd_f25519_jacobi_var.spec x
        if jac = 0#32 then (fd_f25519_sqrt_ratio.spec a fd_f25519_one.limbs).ret
        else if (0#32).slt jac then 1#32 else 0#32) =
      if IsSquare (Limbs.val a) then 1#32 else 0#32 := by
  have hva : Limbs.val a = (buf.toNat : ZMod p) := by rw [hb, ZMod.natCast_zmod_val]
  obtain ⟨e0, e1, e2, e3, e4⟩ := limbs_eq buf
  by_cases hz : buf = 0#256
  · rw [ite_eq_left_of_eq_true _ _ (eq_true ((words_eq_zero buf).2 hz)), hva, hz]
    simp
  rw [ite_eq_right_of_eq_false _ _ (eq_false (mt (words_eq_zero buf).1 hz)), e0, e1, e2, e3, e4]
  set x : Vector (BitVec 64) 5 :=
    #v[(buf >>> 0).setWidth 64 &&& M62, (buf >>> 62).setWidth 64 &&& M62,
      (buf >>> 124).setWidth 64 &&& M62, (buf >>> 186).setWidth 64 &&& M62,
      (buf >>> 248).setWidth 64] with
    hx
  have hB := buf.isLt
  have h4 : ((buf >>> 248).setWidth 64).toNat = buf.toNat / 2 ^ 248 := by
    rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
      Nat.mod_eq_of_lt (by omega)]
  have hl (k : ℕ) :
    limb x k =
      if k < 4 then buf.toNat / 2 ^ (62 * k) % 2 ^ 62
      else if k = 4 then buf.toNat / 2 ^ 248 else 0 := by
    rcases Nat.lt_or_ge k 5 with h | h
    · interval_cases k
      · show ((buf >>> 0).setWidth 64 &&& M62).toNat = _; rw [toNat_window]; rfl
      · show ((buf >>> 62).setWidth 64 &&& M62).toNat = _; rw [toNat_window]; rfl
      · show ((buf >>> 124).setWidth 64 &&& M62).toNat = _; rw [toNat_window]; rfl
      · show ((buf >>> 186).setWidth 64 &&& M62).toNat = _; rw [toNat_window]; rfl
      · show ((buf >>> 248).setWidth 64).toNat = _; rw [h4]; rfl
    · rw [limb_of_ge h, ite_eq_right (by omega), ite_eq_right (by omega)]
  have lx : Limbs62 x 5 := by
    refine ⟨fun k => ?_, fun k hk => limb_of_ge hk⟩
    rw [hl]
    split_ifs
    · exact Nat.mod_lt _ (by decide)
    · omega
    · exact Nat.two_pow_pos _
  have vx : val x = buf.toNat := by
    unfold val
    simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty, hl]
    norm_num
    omega
  have hbp : buf.toNat < p := hb ▸ ZMod.val_lt _
  have hne : ((buf.toNat : ℤ) : ZMod p) ≠ 0 := by
    rw [Int.cast_natCast, Ne, ZMod.natCast_eq_zero_iff]
    intro hd
    exact
      hz
        (BitVec.eq_of_toNat_eq
          (by
            rw [Nat.eq_zero_of_dvd_of_lt hd hbp]; rfl))
  dsimp only
  rcases fd_f25519_jacobi_var.spec_val lx with h0 | ⟨h1, hj⟩ | ⟨h1, hj⟩
  · rw [h0, ite_eq_left_of_eq_true _ _ (eq_true rfl)]
    obtain ⟨v1, b1⟩ := fd_f25519_one.val
    obtain ⟨hsq, hnsq, -⟩ :=
      fd_f25519_sqrt_ratio.spec_val ha b1
        (by
          rw [v1]; exact one_ne_zero)
    rw [v1, div_one] at hsq hnsq
    split_ifs with h
    · exact (hsq h).1
    · exact hnsq h
  · rw [h1, ite_eq_right_of_eq_false _ _ (eq_false (by decide)),
      ite_eq_left_of_eq_true _ _ (eq_true (by decide))]
    rw [vx, ← jacobiSym.legendreSym.to_jacobiSym, legendreSym.eq_one_iff p hne,
      Int.cast_natCast] at hj
    rw [ite_eq_left_of_eq_true _ _ (eq_true (hva ▸ hj))]
  · rw [h1, ite_eq_right_of_eq_false _ _ (eq_false (by decide)),
      ite_eq_right_of_eq_false _ _ (eq_false (by decide))]
    rw [vx, ← jacobiSym.legendreSym.to_jacobiSym, legendreSym.eq_neg_one_iff p,
      Int.cast_natCast] at hj
    rw [ite_eq_right_of_eq_false _ _ (eq_false (hva ▸ hj))]

end fd_f25519_is_square_var

/-- `is_square_var` on a tight field element: `1` exactly when it is a square in `ZMod p` (zero
included), whether or not `jacobi_var` converges. -/
public theorem fd_f25519_is_square_var.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    fd_f25519_is_square_var.spec a = if IsSquare (Limbs.val a) then 1#32 else 0#32 :=
  fd_f25519_is_square_var.core ha _ (fd_f25519_tobytes.spec_val ha.under2p ha.nat_lt)

/-- For `V ≠ 0`, `U V` is a square exactly when `U / V` is. -/
theorem isSquare_mul_iff_div {U V : ZMod p} (hV : V ≠ 0) : IsSquare (U * V) ↔ IsSquare (U / V) := by
  constructor
  · rintro ⟨r, hr⟩
    exact
      ⟨r / V, by
        rw [div_mul_div_comm, ← hr]; field_simp⟩
  · rintro ⟨r, hr⟩
    refine ⟨r * V, ?_⟩
    rw [show U = U / V * V by field_simp, hr]
    ring

/-- `validate` accepts `buf` exactly when `frombytes` decodes it. -/
public theorem fd_ed25519_point_validate.spec_val (buf : BitVec 256) :
    fd_ed25519_point_validate.spec buf =
      if (fd_ed25519_point_frombytes.spec buf).isSome then 1#32 else 0#32 := by
  obtain ⟨yv, -⟩ := fd_f25519_frombytes.spec_val buf
  obtain ⟨⟨uv, ub⟩, ⟨vv, vb⟩⟩ := fd_ed25519_point_frombytes.uv buf
  have hv0 := fd_ed25519_point_frombytes.v_ne buf
  unfold fd_ed25519_point_validate.spec
  dsimp only
  obtain ⟨mv, mb⟩ := fd_f25519_mul.spec_val ub.loose vb.loose
  rw [fd_f25519_is_square_var.spec_val mb, mv]
  refine if_congr ?_ rfl rfl
  rw [isSquare_mul_iff_div hv0, uv, vv,
    show
      Limbs.val (fd_f25519_frombytes.spec buf) ^ 2 * d + 1 =
        d * Limbs.val (fd_f25519_frombytes.spec buf) ^ 2 + 1
      by ring,
    ← Ed25519.exists_onCurve_iff, yv, Option.isSome_iff_ne_none, Ne,
    fd_ed25519_point_frombytes.spec_eq_none_iff]
  simp only [not_forall, not_not]

/-- `validate` accepts `buf` exactly when it decodes to a point (RFC 8032 decoding, non-canonical
`y` and `x = 0` with the sign bit set accepted). -/
public theorem fd_ed25519_point_validate.spec_decode (buf : BitVec 256) :
    fd_ed25519_point_validate.spec buf = if (Ed25519.decode buf).isSome then 1#32 else 0#32 := by
  rw [fd_ed25519_point_validate.spec_val]
  refine if_congr ?_ rfl rfl
  rw [Option.isSome_iff_ne_none, Option.isSome_iff_ne_none, Ne, Ne,
    fd_ed25519_point_frombytes.spec_eq_none_iff_decode]

end MLIR.Firedancer.Ref

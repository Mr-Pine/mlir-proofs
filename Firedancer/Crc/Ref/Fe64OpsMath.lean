module

public import Firedancer.Crc.Ref.Fe64Ops
public import Ed25519.Field
import Std.Tactic.BVDecide

/-!
# 4×64 field kernels: `add`, `sub`, `neg`

For any 256-bit inputs, `Fe64.add X Y` is `X + Y` mod `p` and below `2^255 + 57`. `Fe64.sub X Y`
and `Fe64.neg X` add `2p - Y` (resp. take `2p - X`) mod `2^256` and fold: below `2^255 + 57`
(resp. `2^255 + 19`) for any input, `X - Y` (resp. `-X`) mod `p` when `Y` (resp. `X`) is at most
`2p`, as the kernels' weakly reduced values are.
-/

namespace MLIR.Firedancer.Crc.Ref.Fe64

open _root_.Ed25519

@[expose] public section

/-- `s` folded at `2^255`: its low 255 bits plus `19` per `2^255` above them. -/
abbrev fold (s : BitVec 258) : BitVec 258 :=
  (s.setWidth 255).setWidth 258 + (s >>> 255) * 19#258

/-- `2p` as 256 bits. -/
abbrev twoP : BitVec 256 :=
  BitVec.ofNat 256 (2 * p)

end

/-! ## Word facts -/

theorem fold_toNat {s : BitVec 258} (hs : s.toNat < 2 ^ 257) :
    (fold s).toNat = s.toNat % 2 ^ 255 + s.toNat / 2 ^ 255 * 19 := by
  simp only [fold, BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_mul,
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  omega

theorem fold_mod (s : Nat) : (s % 2 ^ 255 + s / 2 ^ 255 * 19) % p = s % p := by
  unfold p
  omega

theorem twoP_sub_toNat {y : BitVec 256} (hy : y.toNat ≤ 2 * p) :
    (twoP - y).toNat = 2 * p - y.toNat := by
  have h2 : twoP.toNat = 2 * p := by
    simp only [BitVec.toNat_ofNat]; unfold p; omega
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h2]; exact hy),
    h2]

theorem toNat_add_setWidth (x y : BitVec 256) :
    (x.setWidth 258 + y.setWidth 258).toNat = x.toNat + y.toNat := by
  have := x.isLt
  have := y.isLt
  simp only [BitVec.toNat_add, BitVec.toNat_setWidth]
  omega

theorem add_bv (X Y : BitVec 256) :
    (add X Y).setWidth 258 = fold (X.setWidth 258 + Y.setWidth 258) := by
  simp only [add]
  bv_decide

/-- `sub` is `add` of `2p - Y`, mod `2^256`. -/
public theorem sub_eq_add (X Y : BitVec 256) : sub X Y = add X (twoP - Y) := by
  simp only [sub, add]
  bv_decide

theorem neg_bv (X : BitVec 256) : (neg X).setWidth 258 = fold ((twoP - X).setWidth 258) := by
  simp only [neg]
  bv_decide

/-! ## Results -/

/-- `add X Y` is `X + Y` folded at `2^255`. -/
public theorem add_toNat (X Y : BitVec 256) :
    (add X Y).toNat = (X.toNat + Y.toNat) % 2 ^ 255 + (X.toNat + Y.toNat) / 2 ^ 255 * 19 := by
  have h := congrArg BitVec.toNat (add_bv X Y)
  have := X.isLt
  have := Y.isLt
  rw [fold_toNat
      (by
        rw [toNat_add_setWidth]; omega),
    toNat_add_setWidth, BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)] at h
  exact h

public theorem add_mod (X Y : BitVec 256) : (add X Y).toNat % p = (X.toNat + Y.toNat) % p := by
  rw [add_toNat, fold_mod]

/-- `add X Y` is `X + Y` in the field. -/
public theorem add_val (X Y : BitVec 256) : ((add X Y).toNat : ZMod p) = X.toNat + Y.toNat := by
  have := (ZMod.natCast_eq_natCast_iff' _ _ p).mpr (add_mod X Y)
  push_cast at this
  exact this

/-- `add`'s result is weakly reduced. -/
public theorem add_lt (X Y : BitVec 256) : (add X Y).toNat < 2 ^ 255 + 57 := by
  have := X.isLt
  have := Y.isLt
  rw [add_toNat]
  omega

public theorem sub_mod (X Y : BitVec 256) (hY : Y.toNat ≤ 2 * p) :
    ((sub X Y).toNat + Y.toNat) % p = X.toNat % p := by
  rw [Nat.add_mod, sub_eq_add, add_mod, twoP_sub_toNat hY, ← Nat.add_mod]
  unfold p at hY ⊢
  omega

/-- `sub X Y` is `X - Y` in the field, for `Y ≤ 2p`. -/
public theorem sub_val (X Y : BitVec 256) (hY : Y.toNat ≤ 2 * p) :
    ((sub X Y).toNat : ZMod p) = X.toNat - Y.toNat := by
  have := (ZMod.natCast_eq_natCast_iff' _ _ p).mpr (sub_mod X Y hY)
  push_cast at this
  exact eq_sub_of_add_eq this

/-- `sub`'s result is weakly reduced. -/
public theorem sub_lt (X Y : BitVec 256) : (sub X Y).toNat < 2 ^ 255 + 57 := by
  rw [sub_eq_add]
  exact add_lt _ _

/-- `neg X` is `2p - X`, mod `2^256`, folded at `2^255`. -/
public theorem neg_toNat (X : BitVec 256) :
    (neg X).toNat = (twoP - X).toNat % 2 ^ 255 + (twoP - X).toNat / 2 ^ 255 * 19 := by
  have h := congrArg BitVec.toNat (neg_bv X)
  have := (twoP - X).isLt
  have := (neg X).isLt
  rw [fold_toNat
      (by
        rw [BitVec.toNat_setWidth]; omega),
    BitVec.toNat_setWidth, BitVec.toNat_setWidth] at h
  omega

public theorem neg_mod (X : BitVec 256) (hX : X.toNat ≤ 2 * p) :
    ((neg X).toNat + X.toNat) % p = 0 := by
  rw [Nat.add_mod, neg_toNat, fold_mod, twoP_sub_toNat hX, ← Nat.add_mod]
  unfold p at hX ⊢
  omega

/-- `neg X` is `-X` in the field, for `X ≤ 2p`. -/
public theorem neg_val (X : BitVec 256) (hX : X.toNat ≤ 2 * p) :
    ((neg X).toNat : ZMod p) = -X.toNat := by
  have := (ZMod.natCast_eq_natCast_iff' _ 0 p).mpr (by rw [neg_mod X hX, Nat.zero_mod])
  push_cast at this
  exact eq_neg_of_add_eq_zero_left this

/-- `neg`'s result is weakly reduced. -/
public theorem neg_lt (X : BitVec 256) : (neg X).toNat < 2 ^ 255 + 19 := by
  have := (twoP - X).isLt
  rw [neg_toNat]
  omega

end MLIR.Firedancer.Crc.Ref.Fe64

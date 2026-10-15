module

public import Firedancer.Math.Lane.Tobytes
public import Firedancer.Math.Avx512.Point
public import Firedancer.Math.Avx512.Mul
public import Firedancer.Lane.fd_ed25519_point_tobytes
public import Ed25519.Encode
import Std.Tactic.BVDecide

/-! `fd_ed25519_point_tobytes` writes `Ed25519.encode` of the affine point. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 Firedancer.Avx512.R43x6
open _root_.Ed25519 (p)

/-- A store inside an earlier one: the earlier bits with the later spliced in. -/
public theorem _root_.MLIR.MemoryState.readAt_storeAt_storeAt_add {m : MemoryState} {q : Pointer}
    {v : BitVec w} {x : BitVec u} {off : BitVec 64} (h : Room m q w)
    (hov : ¬q.offset.uaddOverflow off) (hw : off.toNat * 8 + u ≤ w) :
    ((m.storeAt q v).storeAt (q.add off) x).readAt q w = Memory.spliceBits v (off.toNat * 8) x := by
  rw [MemoryState.readAt_add_storeAt h.storeAt hov hw, MemoryState.readAt_storeAt_self h]

/-- `fd_ed25519_point_tobytes`' two stores, read back as 32 bytes: `spec`. -/
public theorem fd_ed25519_point_tobytes.readAt_eq {m : MemoryState} {out : Pointer} (Q : Quad)
    (h : Room m out 256) (hoff : out.offset.toNat + 32 ≤ 2 ^ 64) :
    ((m.storeAt out (fd_ed25519_point_tobytes.yBytes Q)).storeAt (out.add 31#64)
          (fd_ed25519_point_tobytes.top Q)).readAt out 256 =
      fd_ed25519_point_tobytes.spec Q := by
  rw [MemoryState.readAt_storeAt_storeAt_add h
    (by simp only [BitVec.uaddOverflow, decide_eq_true_eq]; simp; omega) (by decide)]
  rfl

/-- An element of a QUAD with `u47` limbs is unreduced. -/
theorem elem_unreduced {Q : Quad} (h : Q.Unsigned 47) {j : ℕ} (hj : j < 4) :
    Unreduced (Q.elem j) :=
  ⟨h j hj, rfl, rfl⟩

/-- `spliceBits` as masks and shifts, for `bv_decide`. -/
theorem spliceBits_eq' {n w : Nat} (b : BitVec n) (off : Nat) (x : BitVec w) :
    Memory.spliceBits b off x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-- The encoding's byte 31: `y`'s with `x`'s parity on top, for values below `p`. -/
theorem splice_top (ny nx : ℕ) (hy : ny < p) :
    Memory.spliceBits (BitVec.ofNat 256 ny) 248
        ((BitVec.ofNat 256 ny).extractLsb' 248 8 ^^^
          ((BitVec.ofNat 256 nx).extractLsb' 0 8 &&& 1) <<< 7) =
      BitVec.ofNat 256 (ny + 2 ^ 255 * (nx % 2)) := by
  have hb : BitVec.ofNat 256 ny < BitVec.ofNat 256 (2 ^ 255) := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
    have := p_add
    omega
  have e : Memory.spliceBits (BitVec.ofNat 256 ny) 248
        ((BitVec.ofNat 256 ny).extractLsb' 248 8 ^^^
          ((BitVec.ofNat 256 nx).extractLsb' 0 8 &&& 1) <<< 7) =
      BitVec.ofNat 256 ny + ((BitVec.ofNat 256 nx &&& 1) <<< 255) := by
    generalize BitVec.ofNat 256 ny = b at hb ⊢
    generalize BitVec.ofNat 256 nx = c
    rw [spliceBits_eq']
    bv_decide
  rw [e]
  apply BitVec.eq_of_toNat_eq
  have := p_add
  have h2 := Nat.mod_lt nx (show 2 > 0 by decide)
  have h1 : (1 : BitVec 256).toNat = 1 := rfl
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_and, BitVec.toNat_ofNat, h1,
    Nat.and_one_is_mod, Nat.shiftLeft_eq, Nat.mod_mod_of_dvd _ (by decide : 2 ∣ 2 ^ 256)]
  omega

/-- `fd_ed25519_point_tobytes` of a projective `Q` for `P` with `u47` limbs: `P`'s encoding. -/
public theorem fd_ed25519_point_tobytes.spec_encode {Q : Quad} {P : Ed25519.Point}
    (hQ : Q.Proj P.x P.y) (hU : Q.Unsigned 47) :
    fd_ed25519_point_tobytes.spec Q = Ed25519.encode P := by
  obtain ⟨hz, hx, hy⟩ := hQ
  have hX : Q.X = Q.elem 0 := rfl
  have hY : Q.Y = Q.elem 1 := rfl
  have hZ : Q.Z = Q.elem 2 := rfl
  obtain ⟨vzi, fzi⟩ := fd_f25519_inv.spec_val (hZ ▸ elem_unreduced hU (j := 2) (by decide))
  obtain ⟨vx, -⟩ := fd_r43x6_mul_spec (hX ▸ (elem_unreduced hU (j := 0) (by decide)).1)
    fzi.unreduced
  obtain ⟨vy, -⟩ := fd_r43x6_mul_spec (hY ▸ (elem_unreduced hU (j := 1) (by decide)).1)
    fzi.unreduced
  have ex : val (fd_r43x6_mul Q.X (fd_f25519_inv.spec Q.Z)) = P.x := by
    rw [vx, vzi, hX, hZ]
    change Q.val 0 * (Q.val 2)⁻¹ = P.x
    rw [hx, mul_assoc, mul_inv_cancel₀ hz, mul_one]
  have ey : val (fd_r43x6_mul Q.Y (fd_f25519_inv.spec Q.Z)) = P.y := by
    rw [vy, vzi, hY, hZ]
    change Q.val 1 * (Q.val 2)⁻¹ = P.y
    rw [hy, mul_assoc, mul_inv_cancel₀ hz, mul_one]
  simp only [fd_ed25519_point_tobytes.spec, fd_ed25519_point_tobytes.top,
    fd_ed25519_point_tobytes.topByte, fd_ed25519_point_tobytes.yBytes,
    fd_ed25519_point_tobytes.affine, tobytes_eq_ofNat_val, ex, ey]
  exact splice_top _ _ (ZMod.val_lt _)

/-- `fd_ed25519_point_tobytes( out, a )` of a projective point for `P` with `u47` limbs leaves `P`'s
encoding in the 32 bytes at `out`. -/
public theorem fd_ed25519_point_tobytes.call_encode (out a : Pointer) (s : GlobalState)
    (hwf : s.WF) (ho : Room s.mem out 256) (hoff : out.offset.toNat + 32 ≤ 2 ^ 64)
    (ha : s.mem.QuadFit a) {P : Ed25519.Point} (hQ : (s.mem.readQuad a).Proj P.x P.y)
    (hU : (s.mem.readQuad a).Unsigned 47) :
    ∃ s',
      _root_.Firedancer.Lane.Mlir.fd_ed25519_point_tobytes.call
          (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_tobytes.args (.value out) (.value a)) s =
        .value (.cons (.value out) .nil, s') ∧
      s'.mem.readAt out 256 = Ed25519.encode P :=
  ⟨_, fd_ed25519_point_tobytes.call_eq out a s hwf ho hoff ha,
    (fd_ed25519_point_tobytes.readAt_eq _ ho hoff).trans
      (fd_ed25519_point_tobytes.spec_encode hQ hU)⟩

end MLIR.Firedancer.Lane

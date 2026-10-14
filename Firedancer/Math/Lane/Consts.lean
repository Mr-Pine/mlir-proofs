module

public import Firedancer.Math.Lane.X8
public import Firedancer.Math.Lane.BaseTable
import Mathlib.Tactic.NormNum

/-! `verify_x8`'s constants mean what `Consts.Ok` asks: canonical broadcasts of `d`, `√-1`, `2d`,
`y8`, `-y8`, and the base table of `[e]B`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d sqrtM1 y8)

/-- A broadcast encoding below `2^255`: lane `j`'s value is the encoding's number. -/
theorem bcastBytes_val {b : BitVec 256} (hb : b.toNat < 2 ^ 255) (j : Fin 8) :
    (bcastBytes b).val j = (b.toNat : ZMod p) := by
  rw [Fe.val, bcastBytes, Fe.ofLanes_lane, limbsOfBytes_val, Nat.mod_eq_of_lt hb]

theorem bcastBytes_carried (b : BitVec 256) : (bcastBytes b).Carried := fun j i => by
  rw [bcastBytes, Fe.ofLanes_lane]
  have := limbsOfBytes_lt b i
  unfold carriedB
  split <;> omega

/-- `verify_x8`'s constants, on `fd_ed25519_lane_base_table`. -/
public theorem laneConsts_ok : (laneConsts laneTbl).Ok where
  d j := by rw [laneConsts, bcastBytes_val (by decide)]; rfl
  dB := bcastBytes_carried _
  sqrtm1 j := by rw [laneConsts, bcastBytes_val (by decide)]; rfl
  sqrtm1B := bcastBytes_carried _
  k2d j := by
    rw [laneConsts, bcastBytes_val (by decide)]
    unfold Ed25519.d
    decide
  k2dB := (bcastBytes_carried _).f52
  y0 j := by rw [laneConsts, bcastBytes_val (by decide)]; rfl
  y0B := bcastBytes_carried _
  y1 j := by
    rw [laneConsts, bcastBytes_val (by decide)]
    unfold Ed25519.y8
    decide
  y1B := bcastBytes_carried _
  tbl := laneTbl_ok

/-- Item `j < cnt` of `verify_x8`, on its constants and table, with `H j` the digest of
`R j ‖ A j ‖ msg`, returns what `fd_ed25519_verify` returns for it. -/
public theorem x8_result_lane {cnt : ℕ} {R S A : Fin 8 → BitVec 256} {H : Fin 8 → BitVec 512}
    {j : Fin 8} (hj : j.val < cnt) {msg : List (BitVec 8)}
    (hH : Ed25519.bytesLE (H j) =
      Ed25519.Sha512.digest (Ed25519.bytesLE (R j) ++ Ed25519.bytesLE (A j) ++ msg)) :
    (x8 (laneConsts laneTbl) cnt R S A H).result j =
      Ed25519.Firedancer.verify msg (R j) (S j) (A j) :=
  x8_result laneConsts_ok hj hH

end MLIR.Firedancer.Lane

module

public import Firedancer.Crc.Verify.fd_r52x5_canon
public import Firedancer.Math.R52x5.Canon
public import Firedancer.Math.R52x5.Equal
public import Firedancer.Crc.Verify.fd_r52x5_ge_is_small_order_affine
public import Firedancer.Crc.Verify.VerifyCore.Top
import Std.Tactic.BVDecide
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.FinCases

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open Firedancer.Avx512

/-- The fold `fd_r52x5_canon` starts with, limb by limb. -/
def canonFold (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => (a 4 >>> 51) * 19#64 + (a 0 &&& 2251799813685247#64)
  | ⟨1, _⟩ => (a 1 &&& 2251799813685247#64) + (a 0 >>> 51)
  | ⟨2, _⟩ => (a 1 >>> 51) + (a 2 &&& 2251799813685247#64)
  | ⟨3, _⟩ => (a 2 >>> 51) + (a 3 &&& 2251799813685247#64)
  | ⟨4, _⟩ => (a 3 >>> 51) + (a 4 &&& 2251799813685247#64)

theorem canon_eq_reduce (a : Fin 5 → BitVec 64) :
    fd_r52x5_canon.spec a = fd_r52x5_reduce.spec (canonFold a) := by
  funext i
  fin_cases i <;> simp only [fd_r52x5_canon.spec, fd_r52x5_reduce.spec, canonFold] <;> ac_rfl

theorem shr51_mul19_toNat (x : BitVec 64) : ((x >>> 51) * 19#64).toNat = 19 * (x.toNat / 2 ^ 51) := by
  have := x.isLt
  rw [BitVec.toNat_mul, Ed25519.toNat_shift, show (19#64).toNat = 19 from rfl,
    Nat.mod_eq_of_lt (by omega), Nat.mul_comm]

theorem add_toNat_lt {x y : BitVec 64} (h : x.toNat + y.toNat < 2 ^ 64) :
    (x + y).toNat = x.toNat + y.toNat := by rw [BitVec.toNat_add, Nat.mod_eq_of_lt h]

theorem canonFold_toNat (a : Fin 5 → BitVec 64) :
    (canonFold a 0).toNat = (a 0).toNat % 2 ^ 51 + 19 * ((a 4).toNat / 2 ^ 51) ∧
      (canonFold a 1).toNat = (a 1).toNat % 2 ^ 51 + (a 0).toNat / 2 ^ 51 ∧
      (canonFold a 2).toNat = (a 2).toNat % 2 ^ 51 + (a 1).toNat / 2 ^ 51 ∧
      (canonFold a 3).toNat = (a 3).toNat % 2 ^ 51 + (a 2).toNat / 2 ^ 51 ∧
      (canonFold a 4).toNat = (a 4).toNat % 2 ^ 51 + (a 3).toNat / 2 ^ 51 := by
  have h0 := (a 0).isLt; have h1 := (a 1).isLt; have h2 := (a 2).isLt; have h3 := (a 3).isLt
  have h4 := (a 4).isLt
  simp only [canonFold]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [add_toNat_lt] <;> rw [shr51_mul19_toNat, Ed25519.toNat_and_mask] <;> omega
  · rw [add_toNat_lt] <;> rw [Ed25519.toNat_shift, Ed25519.toNat_and_mask]; omega
  · rw [add_toNat_lt] <;> rw [Ed25519.toNat_shift, Ed25519.toNat_and_mask] <;> omega
  · rw [add_toNat_lt] <;> rw [Ed25519.toNat_shift, Ed25519.toNat_and_mask] <;> omega
  · rw [add_toNat_lt] <;> rw [Ed25519.toNat_shift, Ed25519.toNat_and_mask] <;> omega

/-- `fd_r52x5_canon`: canonical limbs of the same value, for any limbs. -/
public theorem fd_r52x5_canon.spec_canon (a : Fin 5 → BitVec 64) :
    Canon (fd_r52x5_canon.spec a) ∧
      Ed25519.Limbs.val (fd_r52x5_canon.spec a) = Ed25519.Limbs.val a := by
  obtain ⟨e0, e1, e2, e3, e4⟩ := canonFold_toNat a
  have h0 := (a 0).isLt; have h1 := (a 1).isLt; have h2 := (a 2).isLt; have h3 := (a 3).isLt
  have h4 := (a 4).isLt
  have hl : ∀ i, (canonFold a i).toNat < 2 ^ 52 := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, e0, e1, e2, e3, e4] <;> omega
  have hn : Ed25519.Limbs.nat (canonFold a) < 2 * Ed25519.p := by
    unfold Ed25519.Limbs.nat
    rw [e0, e1, e2, e3, e4]
    change _ < 2 * (2 ^ 255 - 19)
    omega
  have hv : Ed25519.Limbs.val (canonFold a) = Ed25519.Limbs.val a := by
    have e (y : ℕ) : ((y % 2 ^ 51 : ℕ) : ZMod Ed25519.p) + 2 ^ 51 * (y / 2 ^ 51 : ℕ) = y := by
      exact_mod_cast congrArg (Nat.cast (R := ZMod Ed25519.p)) (Nat.mod_add_div y (2 ^ 51))
    rw [Ed25519.Limbs.val_eq, Ed25519.Limbs.val_eq, e0, e1, e2, e3, e4]
    push_cast
    linear_combination
      e (a 0).toNat + 2 ^ 51 * e (a 1).toNat + 2 ^ 102 * e (a 2).toNat + 2 ^ 153 * e (a 3).toNat +
          2 ^ 204 * e (a 4).toNat -
        ((a 4).toNat / 2 ^ 51 : ℕ) * Ed25519.two_pow_255
  have h := fd_r52x5_reduce.spec_canon hl hn
  rw [canon_eq_reduce]
  exact ⟨h.1, h.2.trans hv⟩

/-- Canonical limbs are equal exactly when their values are. -/
public theorem Canon.limbs_eq {a b : Fin 5 → BitVec 64} (ha : Canon a) (hb : Canon b) :
    fd_r52x5_limbs_eq.spec a b = if Ed25519.Limbs.val a = Ed25519.Limbs.val b then 1 else 0 := by
  unfold fd_r52x5_limbs_eq.spec
  refine if_congr ?_ rfl rfl
  rw [Ed25519.Limbs.val_nat, Ed25519.Limbs.val_nat]
  constructor
  · rintro ⟨h0, h1, h2, h3, h4⟩
    simp [Ed25519.Limbs.nat, h0, h1, h2, h3, h4]
  · intro h
    have hn : Ed25519.Limbs.nat a = Ed25519.Limbs.nat b := by
      have := (ZMod.natCast_eq_natCast_iff' _ _ _).1 h
      rwa [Nat.mod_eq_of_lt ha.2, Nat.mod_eq_of_lt hb.2] at this
    have a0 := ha.1 0; have a1 := ha.1 1; have a2 := ha.1 2; have a3 := ha.1 3; have a4 := ha.1 4
    have b0 := hb.1 0; have b1 := hb.1 1; have b2 := hb.1 2; have b3 := hb.1 3; have b4 := hb.1 4
    unfold Ed25519.Limbs.nat at hn
    refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> apply BitVec.eq_of_toNat_eq <;> omega

theorem order8_y0_eq : fd_r52x5_order8_y0.limbs = Ref.fd_ed25519_order8_point_y0.limbs := by
  funext i; fin_cases i <;> rfl

theorem order8_y1_eq : fd_r52x5_order8_y1.limbs = Ref.fd_ed25519_order8_point_y1.limbs := by
  funext i; fin_cases i <;> rfl

theorem order8_canon : Canon fd_r52x5_order8_y0.limbs ∧ Canon fd_r52x5_order8_y1.limbs := by
  refine ⟨⟨fun i => ?_, ?_⟩, ⟨fun i => ?_, ?_⟩⟩
  all_goals first | (fin_cases i <;> decide) | decide

/-- `fd_r52x5_ge_is_small_order_affine` on an affine point on the curve: `0` exactly when
`8 (x, y)` is not the neutral point. -/
public theorem fd_r52x5_ge_is_small_order_affine.spec_val {A : Quad5} {x y : ZMod Ed25519.p}
    (hx : A.val 0 = x) (hy : A.val 1 = y) (hc : Ed25519.OnCurve x y) :
    fd_r52x5_ge_is_small_order_affine.spec A = if Ed25519.SmallOrder x y then 1 else 0 := by
  obtain ⟨⟨v0, -⟩, ⟨v1, -⟩⟩ := Ref.fd_ed25519_order8_point_y.val
  obtain ⟨cx, vx⟩ := fd_r52x5_canon.spec_canon (A.elem 0)
  obtain ⟨cy, vy⟩ := fd_r52x5_canon.spec_canon (A.elem 1)
  replace vx := vx.trans hx
  replace vy := vy.trans hy
  have e0 : fd_r52x5_limbs_is_zero.spec (fd_r52x5_quad_lane_canon.spec A 0) =
      if x = 0 then 1 else 0 := by
    unfold fd_r52x5_limbs_is_zero.spec fd_r52x5_quad_lane_canon.spec
    rw [cx.isZero, vx]
  have e1 : fd_r52x5_limbs_is_zero.spec (fd_r52x5_quad_lane_canon.spec A 1) =
      if y = 0 then 1 else 0 := by
    unfold fd_r52x5_limbs_is_zero.spec fd_r52x5_quad_lane_canon.spec
    rw [cy.isZero, vy]
  have e2 : fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec A 1) fd_r52x5_order8_y0.limbs =
      if y = Ed25519.y8 then 1 else 0 := by
    unfold fd_r52x5_quad_lane_canon.spec
    rw [Canon.limbs_eq cy order8_canon.1, vy, order8_y0_eq, v0]
  have e3 : fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec A 1) fd_r52x5_order8_y1.limbs =
      if y = -Ed25519.y8 then 1 else 0 := by
    unfold fd_r52x5_quad_lane_canon.spec
    rw [Canon.limbs_eq cy order8_canon.2, vy, order8_y1_eq, v1]
  unfold fd_r52x5_ge_is_small_order_affine.spec fd_r52x5_affine_is_small_order.spec
  rw [e0, e1, e2, e3]
  refine Eq.trans ?_ (if_congr (Ed25519.smallOrder_iff hc).symm rfl rfl)
  by_cases h1 : x = 0 <;> by_cases h2 : y = 0 <;> by_cases h3 : y = Ed25519.y8 <;>
    by_cases h4 : y = -Ed25519.y8 <;> simp [h1, h2, h3, h4]

/-- On an affine point of the group: `0` exactly when `8 P ≠ 0`. -/
public theorem smallOrderSpec : SmallOrderSpec := by
  intro A P hA _
  rw [fd_r52x5_ge_is_small_order_affine.spec_val hA.1 hA.2.1 P.on,
    ← Ed25519.Point.smallOrder_iff_nsmul P]
  split <;> simp_all


open fd_r52x5_double_scalar_mul_base in
/-- `fd_ed25519_verify.call_ret` with the small-order check discharged. -/
public theorem fd_ed25519_verify.call_ret' (msg : Pointer) (msgSz : BitVec 64)
    (sig pk sha : Pointer) (TB : Nat → Quad5) (hdec : DecodeSpec) (heq : EquationSpec TB)
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
  fd_ed25519_verify.call_ret msg msgSz sig pk sha TB hdec smallOrderSpec heq s hwf hg flB tbB hgf
    hgb hfl hset hTB hmsg hmsg_off hmsgSz hsig hsig_off hpk hpk_off hsha hshaw hmsg_sha hsig_sha
    hpk_sha hsha_fl hsha_tb

end MLIR.Firedancer.Crc.Verify

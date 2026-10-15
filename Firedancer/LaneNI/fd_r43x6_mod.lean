module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.ExtractLimbs
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.LaneNI.Mlir.fd_r43x6_mod
public import Firedancer.LaneNI.Mlir.fd_r43x6_mod_89
public import Firedancer.LaneNI.Mlir.fd_r43x6_mod_57
public import Firedancer.LaneNI.Mlir.fd_r43x6_mod_40
public import Firedancer.LaneNI.Mlir.fd_r43x6_mod_31
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512
open MLIR.Firedancer.Lane (r43x6Mod approxCarryPropagateLimbs)

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_mod(x)`: `r43x6Mod` of `x`'s limbs, lanes 6 and 7 zero. -/
def fd_r43x6_mod.spec (x : Wwl) : Wwl :=
  let r := r43x6Mod (extractLimbs x)
  wwl r.y0 r.y1 r.y2 r.y3 r.y4 r.y5 0 0

end

/-! ## Proof -/

section Proof

/-! The compiled no-overflow facts of the carries. -/

private theorem nsw_mask_sshr (a b : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow (b.sshiftRight 43) = false := by bv_decide

private theorem nsw_sshr_neg1 (b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow 18446744073709551615#64 = false := by bv_decide

private theorem nsw_sshr_neg1_mask (b c : BitVec 64) :
    (b.sshiftRight 43 + 18446744073709551615#64).saddOverflow (c &&& 1099511627775#64) = false := by
  bv_decide

private theorem nsw_sshr40_sshr40 (t y : BitVec 64) :
    (t.sshiftRight 40).saddOverflow (y.sshiftRight 40) = false := by bv_decide

private theorem nsw_mul19 (t y : BitVec 64) :
    (t.sshiftRight 40 + y.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

private theorem nsw_mul19_mask (t y z : BitVec 64) :
    ((t.sshiftRight 40 + y.sshiftRight 40) * 19#64).saddOverflow (z &&& 8796093022207#64) =
      false := by
  bv_decide

private theorem nsw_carry_sshr (a b u : BitVec 64) :
    ((a &&& 8796093022207#64) + b.sshiftRight 43).saddOverflow (u.sshiftRight 43) = false := by
  bv_decide

private theorem nuw_mask43_19 (x : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (x &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  bv_decide

private theorem nuw_mask43_shr43 (x y : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow (y >>> 43) = false ∧
      (x &&& 8796093022207#64).uaddOverflow (y >>> 43) = false := by
  bv_decide

private theorem nuw_mask40_1 (x : BitVec 64) :
    (x &&& 1099511627775#64).saddOverflow 1#64 = false ∧
      (x &&& 1099511627775#64).uaddOverflow 1#64 = false := by
  bv_decide

private theorem nsw_mask40_1_sshr (x z : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64).saddOverflow (z.sshiftRight 43) = false := by bv_decide

private theorem nuw_top (x a b u w : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).saddOverflow
          (w >>> 43) =
        false ∧
      ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).uaddOverflow
          (w >>> 43) =
        false := by
  bv_decide

private theorem nsw_sshr43_mask43 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 8796093022207#64) = false := by bv_decide

private theorem nsw_sshr43_mask40 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 1099511627775#64) = false := by bv_decide

private theorem nsw_sel19_mask43 (c : Prop) [Decidable c] (x : BitVec 64) :
    (if c then 18446744073709551597#64 else 0#64).saddOverflow (x &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

attribute [local simp] nsw_mask_sshr nsw_sshr_neg1 nsw_sshr_neg1_mask nsw_sshr40_sshr40 nsw_mul19
  nsw_mul19_mask nsw_carry_sshr nuw_mask43_19 nuw_mask43_shr43 nuw_mask40_1 nsw_mask40_1_sshr
  nuw_top nsw_sshr43_mask43 nsw_sshr43_mask40 nsw_sel19_mask43

/-- The approximate and biased carries as compiled: limbs `0 … 4` from `u0 … u3` and the next
sum, limb 5 from `t5` and that sum's carry. -/
private theorem mod_biased
    {y0 y1 y2 y3 y4 y5 t5 u0 u1 u2 u3 : BitVec 64}
    (ht5 : t5 = y4.sshiftRight 43 + 18446744073709551615#64 + (y5 &&& 1099511627775#64))
    (hu0 : u0 = (t5.sshiftRight 40 + y5.sshiftRight 40) * 19#64 + (y0 &&& 8796093022207#64))
    (hu1 : u1 = (y1 &&& 8796093022207#64) + y0.sshiftRight 43 + u0.sshiftRight 43)
    (hu2 : u2 = (y2 &&& 8796093022207#64) + y1.sshiftRight 43 + u1.sshiftRight 43)
    (hu3 : u3 = (y3 &&& 8796093022207#64) + y2.sshiftRight 43 + u2.sshiftRight 43) :
    biasedCarryPropagateLimbs (approxCarryPropagateLimbs ⟨y0, y1, y2, y3, y4, y5⟩) 1 =
      ⟨u0 &&& m43, u1 &&& m43, u2 &&& m43, u3 &&& m43,
        (y4 &&& m43) + y3.sshiftRight 43 + u3.sshiftRight 43 &&& m43,
        (t5 &&& m40) + 1#64 +
          ((y4 &&& m43) + y3.sshiftRight 43 + u3.sshiftRight 43).sshiftRight 43⟩ := by
  simp only [biasedCarryPropagateLimbs, approxCarryPropagateLimbs, carryLimbs, carrySums,
    Limbs.mk.injEq]
  have e5 : (y5 &&& m40) + y4.sshiftRight 43 - 1 = t5 := by subst ht5; bv_decide
  have e0 : (y0 &&& m43) + 19 * y5.sshiftRight 40 + 19 * t5.sshiftRight 40 = u0 := by
    subst hu0; bv_decide
  rw [e5, e0]
  subst hu1 hu2 hu3
  refine ⟨rfl, ?_, ?_, ?_, ?_, ?_⟩
  all_goals bv_decide

/-- The near reduction as compiled, `>>>` where the sums are nonnegative, the `ult` test for the
carry out of bit 255. -/
private theorem mod_nearly {z0 z1 z2 z3 z4 t q v0 v1 v2 v3 v4 w5 r0 r1 r2 r3 r4 r5 : BitVec 64}
    (hv0 : v0 = (z0 &&& 8796093022207#64) + 19#64)
    (hv1 : v1 = (z1 &&& 8796093022207#64) + v0 >>> 43)
    (hv2 : v2 = (z2 &&& 8796093022207#64) + v1 >>> 43)
    (hv3 : v3 = (z3 &&& 8796093022207#64) + v2 >>> 43)
    (hv4 : v4 = (z4 &&& 8796093022207#64) + v3 >>> 43)
    (hw5 : w5 = (t &&& 1099511627775#64) + 1#64 + q.sshiftRight 43 + v4 >>> 43)
    (hr0 :
      r0 =
        (if BitVec.ofBool (w5.ult 1099511627776#64) = 1#1 then 18446744073709551597#64 else 0#64) +
          (v0 &&& 8796093022207#64))
    (hr1 : r1 = r0.sshiftRight 43 + (v1 &&& 8796093022207#64))
    (hr2 : r2 = r1.sshiftRight 43 + (v2 &&& 8796093022207#64))
    (hr3 : r3 = r2.sshiftRight 43 + (v3 &&& 8796093022207#64))
    (hr4 : r4 = r3.sshiftRight 43 + (v4 &&& 8796093022207#64))
    (hr5 : r5 = r4.sshiftRight 43 + (w5 &&& 1099511627775#64)) :
    modNearlyReducedLimbs ⟨z0 &&& m43, z1 &&& m43, z2 &&& m43, z3 &&& m43, z4 &&& m43,
        (t &&& m40) + 1#64 + q.sshiftRight 43⟩ =
      ⟨r0 &&& 8796093022207#64, r1 &&& 8796093022207#64, r2 &&& 8796093022207#64,
        r3 &&& 8796093022207#64, r4 &&& 8796093022207#64, r5⟩ := by
  subst_vars
  simp only [modNearlyReducedLimbs, carryLimbs, carrySums, m43, m40, Limbs.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Lane 5's mask, `-1`. -/
private theorem and_allOnes (x : BitVec 64) : (x &&& 18446744073709551615#64) = x := by
  bv_decide

/-- `r43x6Mod` of the extracted limbs, as compiled. -/
private theorem mod_compiled
    {y0 y1 y2 y3 y4 y5 t5 u0 u1 u2 u3 v0 v1 v2 v3 v4 w5 r0 r1 r2 r3 r4 r5 : BitVec 64}
    (ht5 : t5 = y4.sshiftRight 43 + 18446744073709551615#64 + (y5 &&& 1099511627775#64))
    (hu0 : u0 = (t5.sshiftRight 40 + y5.sshiftRight 40) * 19#64 + (y0 &&& 8796093022207#64))
    (hu1 : u1 = (y1 &&& 8796093022207#64) + y0.sshiftRight 43 + u0.sshiftRight 43)
    (hu2 : u2 = (y2 &&& 8796093022207#64) + y1.sshiftRight 43 + u1.sshiftRight 43)
    (hu3 : u3 = (y3 &&& 8796093022207#64) + y2.sshiftRight 43 + u2.sshiftRight 43)
    (hv0 : v0 = (u0 &&& 8796093022207#64) + 19#64)
    (hv1 : v1 = (u1 &&& 8796093022207#64) + v0 >>> 43)
    (hv2 : v2 = (u2 &&& 8796093022207#64) + v1 >>> 43)
    (hv3 : v3 = (u3 &&& 8796093022207#64) + v2 >>> 43)
    (hv4 :
      v4 =
        ((y4 &&& 8796093022207#64) + y3.sshiftRight 43 + u3.sshiftRight 43 &&& 8796093022207#64) +
          v3 >>> 43)
    (hw5 :
      w5 =
        (t5 &&& 1099511627775#64) + 1#64 +
          ((y4 &&& 8796093022207#64) + y3.sshiftRight 43 + u3.sshiftRight 43).sshiftRight 43 +
          v4 >>> 43)
    (hr0 :
      r0 =
        (if BitVec.ofBool (w5.ult 1099511627776#64) = 1#1 then 18446744073709551597#64 else 0#64) +
          (v0 &&& 8796093022207#64))
    (hr1 : r1 = r0.sshiftRight 43 + (v1 &&& 8796093022207#64))
    (hr2 : r2 = r1.sshiftRight 43 + (v2 &&& 8796093022207#64))
    (hr3 : r3 = r2.sshiftRight 43 + (v3 &&& 8796093022207#64))
    (hr4 : r4 = r3.sshiftRight 43 + (v4 &&& 8796093022207#64))
    (hr5 : r5 = r4.sshiftRight 43 + (w5 &&& 1099511627775#64)) :
    r43x6Mod ⟨y0, y1, y2, y3, y4, y5⟩ =
      ⟨r0 &&& 8796093022207#64, r1 &&& 8796093022207#64, r2 &&& 8796093022207#64,
        r3 &&& 8796093022207#64, r4 &&& 8796093022207#64, r5⟩ := by
  rw [r43x6Mod, mod_biased ht5 hu0 hu1 hu2 hu3]
  exact mod_nearly hv0 hv1 hv2 hv3 hv4 hw5 hr0 hr1 hr2 hr3 hr4 hr5

/-- `fd_r43x6_mod` returns `spec x` and leaves the state as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_mod.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_mod.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mod.spec x)) .nil, s) := by
  func_init
  block_init
  iterate 36 step_pure
  step_pure with y0
  step_pure with y1
  step_pure with y2
  step_pure with y3
  step_pure with y4
  step_pure with y5
  iterate 17 step_pure
  step_pure with t5
  iterate 4 step_pure
  step_pure with u0
  iterate 2 step_pure
  step_pure with u1
  iterate 2 step_pure
  step_pure with u2
  iterate 2 step_pure
  step_pure with u3
  iterate 2 step_pure
  step_pure with transparent u4
  iterate 2 step_pure
  step_pure with v0
  iterate 2 step_pure
  step_pure with v1
  iterate 2 step_pure
  step_pure with v2
  iterate 2 step_pure
  step_pure with v3
  iterate 2 step_pure
  step_pure with v4
  iterate 4 step_pure
  step_pure with w5
  iterate 3 step_pure
  step_pure with r0
  step_pure
  step_pure with r1
  step_pure
  step_pure with r2
  step_pure
  step_pure with r3
  iterate 6 step_pure
  step_pure with r4
  step_pure
  step_pure with r5
  have hm := mod_compiled ht5 hu0 hu1 hu2 hu3 hv0 hv1 hv2 hv3 hv4 hw5 hr0 hr1 hr2 hr3 hr4 hr5
  iterate 6 step_pure
  step_pure with z
  finish_block
  have hx : (⟨y0, y1, y2, y3, y4, y5⟩ : Limbs) = extractLimbs x := by
    rw [hy0, hy1, hy2, hy3, hy4, hy5]
    rfl
  have e : z = fd_r43x6_mod.spec x := by
    simp only [hz, fd_r43x6_mod.spec, ← hx, hm, and_allOnes, wwl]
    rfl
  rw [hS, e]

/-- `fd_r43x6_mod_31` is `fd_r43x6_mod` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_mod_31.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_mod_31.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_mod_31.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mod.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq x s hwf

/-- `fd_r43x6_mod_40` is `fd_r43x6_mod` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_mod_40.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_mod_40.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_mod_40.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mod.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq x s hwf

/-- `fd_r43x6_mod_57` is `fd_r43x6_mod` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_mod_57.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_mod_57.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_mod_57.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mod.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq x s hwf

/-- `fd_r43x6_mod_89` is `fd_r43x6_mod` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_mod_89.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_mod_89.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_mod_89.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mod.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq x s hwf

end Proof

end MLIR.Firedancer.LaneNI

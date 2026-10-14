module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Tactics
public import Firedancer.Lane.Common.Verify
public import Firedancer.Avx512.Common.ModNearlyReducedLimbs
public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_approx_carry_propagate_limbs`. -/
def approxCarryPropagateLimbs (x : Limbs) : Limbs :=
  ⟨(x.y0 &&& m43) + 19 * x.y5.sshiftRight 40, (x.y1 &&& m43) + x.y0.sshiftRight 43,
    (x.y2 &&& m43) + x.y1.sshiftRight 43, (x.y3 &&& m43) + x.y2.sshiftRight 43,
    (x.y4 &&& m43) + x.y3.sshiftRight 43, (x.y5 &&& m40) + x.y4.sshiftRight 43⟩

/-- `fd_r43x6_mod` on extracted limbs. -/
def r43x6Mod (x : Limbs) : Limbs :=
  modNearlyReducedLimbs (biasedCarryPropagateLimbs (approxCarryPropagateLimbs x) 1)

/-- `fd_r43x6_pack`: the 256 bits of lanes `0 … 3`, lane 0 lowest. -/
def r43x6Pack (r : Limbs) : BitVec 256 :=
  let u0 := r.y0 ||| r.y1 <<< 43 ||| r.y1 <<< 43
  let u1 := r.y1 >>> 21 ||| r.y2 <<< 22 ||| r.y2 <<< 22
  let u2 := r.y2 >>> 42 ||| r.y3 <<< 1 ||| r.y4 <<< 44
  let u3 := r.y4 >>> 20 ||| r.y5 <<< 23 ||| r.y5 <<< 23
  u3 ++ u2 ++ u1 ++ u0

/-- `fd_f25519_tobytes` of an `fd_f25519_t` whose `el` is `a`. -/
def tobytes (a : Wwl) : BitVec 256 :=
  r43x6Pack (r43x6Mod (extractLimbs a))

end

/-! ## Proof -/

section Proof

theorem cell_bcast (b : BitVec 256) (k : Nat) (hk : k < 40) :
    (BitVec.packLanes (bcastBytes b).l4 ++
              (BitVec.packLanes (bcastBytes b).l3 ++
                (BitVec.packLanes (bcastBytes b).l2 ++
                  (BitVec.packLanes (bcastBytes b).l1 ++ BitVec.packLanes (bcastBytes b).l0))) :
            BitVec (64 * 40)).extractLsb'
        (64 * k) 64 =
      limbsOfBytes b ⟨k / 8, by omega⟩ := by
  interval_cases k <;>
    simp (disch := decide) only [Nat.reduceMul, BitVec.extractLsb'_append_eq_of_add_le,
      BitVec.extractLsb'_append_eq_of_le, Nat.reduceSub]
  all_goals
    rw [BitVec.extractLsb'_packLanes_of_lt _ (by decide) (by decide)]
    simp only [Nat.reduceDiv, Nat.reduceMod, BitVec.extractLsb'_eq_self, bcastBytes, Fe.ofLanes,
      Vector.getElem_ofFn]
    first
    | rfl
    | norm_num

theorem nsw_mask_sshr (a b : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow (b.sshiftRight 43) = false := by bv_decide

theorem nsw_sshr_neg1 (b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow 18446744073709551615#64 = false := by bv_decide

theorem nsw_sshr_neg1_mask (b c : BitVec 64) :
    (b.sshiftRight 43 + 18446744073709551615#64).saddOverflow (c &&& 1099511627775#64) = false := by
  bv_decide

theorem nsw_sshr40_sshr40 (t y : BitVec 64) :
    (t.sshiftRight 40).saddOverflow (y.sshiftRight 40) = false := by bv_decide

theorem nsw_mul19 (t y : BitVec 64) :
    (t.sshiftRight 40 + y.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

theorem nsw_mul19_mask (t y z : BitVec 64) :
    ((t.sshiftRight 40 + y.sshiftRight 40) * 19#64).saddOverflow (z &&& 8796093022207#64) =
      false := by
  bv_decide

theorem nsw_carry_sshr (a b u : BitVec 64) :
    ((a &&& 8796093022207#64) + b.sshiftRight 43).saddOverflow (u.sshiftRight 43) = false := by
  bv_decide

theorem nuw_mask43_19 (x : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (x &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  bv_decide

theorem nuw_mask43_shr43 (x y : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow (y >>> 43) = false ∧
      (x &&& 8796093022207#64).uaddOverflow (y >>> 43) = false := by
  bv_decide

theorem nuw_mask40_1 (x : BitVec 64) :
    (x &&& 1099511627775#64).saddOverflow 1#64 = false ∧
      (x &&& 1099511627775#64).uaddOverflow 1#64 = false := by
  bv_decide

theorem nsw_mask40_1_sshr (x z : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64).saddOverflow (z.sshiftRight 43) = false := by bv_decide

theorem nuw_top (x a b u w : BitVec 64) :
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

theorem nsw_sshr43_mask43 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 8796093022207#64) = false := by bv_decide

theorem nsw_sshr43_mask40 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 1099511627775#64) = false := by bv_decide

theorem nsw_sel19_mask43 (c : Prop) [Decidable c] (x : BitVec 64) :
    (if c then 18446744073709551597#64 else 0#64).saddOverflow (x &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

attribute [local simp] nsw_mask_sshr nsw_sshr_neg1 nsw_sshr_neg1_mask nsw_sshr40_sshr40 nsw_mul19
  nsw_mul19_mask nsw_carry_sshr nuw_mask43_19 nuw_mask43_shr43 nuw_mask40_1 nsw_mask40_1_sshr
  nuw_top nsw_sshr43_mask43 nsw_sshr43_mask40 nsw_sel19_mask43

theorem setWidth_packLanes' (v : Vector (BitVec 64) (n + 1)) :
    (BitVec.packLanes v).setWidth 64 = v[0] := by
  unfold BitVec.packLanes
  exact BitVec.setWidth_append_eq_right

-- `bv_decide` over the whole reduction, about 90 s
set_option maxHeartbeats 0 in
theorem mod_compiled
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
  subst_vars
  simp only [r43x6Mod, modNearlyReducedLimbs, biasedCarryPropagateLimbs, approxCarryPropagateLimbs,
    carryLimbs, carrySums, m43, m40, Limbs.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide (config := { timeout := 120 })

theorem limbsOfBytes_0 (b : BitVec 256) : limbsOfBytes b 0 = b.extractLsb' 0 64 &&& mask51 :=
  rfl

theorem limbsOfBytes_1 (b : BitVec 256) :
    limbsOfBytes b 1 = (b.extractLsb' 48 64 >>> 3) &&& mask51 :=
  rfl

theorem limbsOfBytes_2 (b : BitVec 256) :
    limbsOfBytes b 2 = (b.extractLsb' 96 64 >>> 6) &&& mask51 :=
  rfl

theorem limbsOfBytes_3 (b : BitVec 256) :
    limbsOfBytes b 3 = (b.extractLsb' 152 64 >>> 1) &&& mask51 :=
  rfl

theorem limbsOfBytes_4 (b : BitVec 256) :
    limbsOfBytes b 4 = (b.extractLsb' 192 64 >>> 12) &&& mask51 :=
  rfl

theorem cells_of {A : Wwl} {y0 y1 y2 y3 y4 y5 r0 r1 r2 r3 r4 r5 : BitVec 64}
    (hx : (⟨y0, y1, y2, y3, y4, y5⟩ : Limbs) = extractLimbs A)
    (hm :
      r43x6Mod ⟨y0, y1, y2, y3, y4, y5⟩ =
        ⟨r0 &&& 8796093022207#64, r1 &&& 8796093022207#64, r2 &&& 8796093022207#64,
          r3 &&& 8796093022207#64, r4 &&& 8796093022207#64, r5⟩) :
    BitVec.setWidth 64
            (((r4 &&& 8796093022207#64) >>> 20 ||| (r5 &&& 18446744073709551615#64) <<< 23 |||
                (r5 &&& 18446744073709551615#64) <<< 23) ++
              ((r2 &&& 8796093022207#64) >>> 42 ||| (r3 &&& 8796093022207#64) <<< 1 |||
                (r4 &&& 8796093022207#64) <<< 44) ++
              ((r1 &&& 8796093022207#64) >>> 21 ||| (r2 &&& 8796093022207#64) <<< 22 |||
                (r2 &&& 8796093022207#64) <<< 22) ++
              (r0 &&& 8796093022207#64 ||| (r1 &&& 8796093022207#64) <<< 43 |||
                (r1 &&& 8796093022207#64) <<< 43)) &&&
          2251799813685247#64 =
        limbsOfBytes (tobytes A) 0 ∧
      BitVec.setWidth 64
            ((((r4 &&& 8796093022207#64) >>> 20 ||| (r5 &&& 18446744073709551615#64) <<< 23 |||
                  (r5 &&& 18446744073709551615#64) <<< 23) ++
                ((r2 &&& 8796093022207#64) >>> 42 ||| (r3 &&& 8796093022207#64) <<< 1 |||
                  (r4 &&& 8796093022207#64) <<< 44) ++
                ((r1 &&& 8796093022207#64) >>> 21 ||| (r2 &&& 8796093022207#64) <<< 22 |||
                  (r2 &&& 8796093022207#64) <<< 22) ++
                (r0 &&& 8796093022207#64 ||| (r1 &&& 8796093022207#64) <<< 43 |||
                  (r1 &&& 8796093022207#64) <<< 43)) >>>
              51) &&&
          2251799813685247#64 =
        limbsOfBytes (tobytes A) 1 ∧
      BitVec.setWidth 64
            ((((r4 &&& 8796093022207#64) >>> 20 ||| (r5 &&& 18446744073709551615#64) <<< 23 |||
                  (r5 &&& 18446744073709551615#64) <<< 23) ++
                ((r2 &&& 8796093022207#64) >>> 42 ||| (r3 &&& 8796093022207#64) <<< 1 |||
                  (r4 &&& 8796093022207#64) <<< 44) ++
                ((r1 &&& 8796093022207#64) >>> 21 ||| (r2 &&& 8796093022207#64) <<< 22 |||
                  (r2 &&& 8796093022207#64) <<< 22) ++
                (r0 &&& 8796093022207#64 ||| (r1 &&& 8796093022207#64) <<< 43 |||
                  (r1 &&& 8796093022207#64) <<< 43)) >>>
              102) &&&
          2251799813685247#64 =
        limbsOfBytes (tobytes A) 2 ∧
      BitVec.setWidth 64
            ((((r4 &&& 8796093022207#64) >>> 20 ||| (r5 &&& 18446744073709551615#64) <<< 23 |||
                  (r5 &&& 18446744073709551615#64) <<< 23) ++
                ((r2 &&& 8796093022207#64) >>> 42 ||| (r3 &&& 8796093022207#64) <<< 1 |||
                  (r4 &&& 8796093022207#64) <<< 44) ++
                ((r1 &&& 8796093022207#64) >>> 21 ||| (r2 &&& 8796093022207#64) <<< 22 |||
                  (r2 &&& 8796093022207#64) <<< 22) ++
                (r0 &&& 8796093022207#64 ||| (r1 &&& 8796093022207#64) <<< 43 |||
                  (r1 &&& 8796093022207#64) <<< 43)) >>>
              153) &&&
          2251799813685247#64 =
        limbsOfBytes (tobytes A) 3 ∧
      (((r4 &&& 8796093022207#64) >>> 20 ||| (r5 &&& 18446744073709551615#64) <<< 23 |||
              (r5 &&& 18446744073709551615#64) <<< 23) >>>
            12 &&&
          2251799813685247#64) =
        limbsOfBytes (tobytes A) 4 := by
  rw [tobytes, ← hx, hm]
  simp only [limbsOfBytes_0, limbsOfBytes_1, limbsOfBytes_2, limbsOfBytes_3, limbsOfBytes_4,
    r43x6Pack, mask51]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

set_option hygiene false in
/-- One iteration of the broadcast's loop: `fd_f25519_tobytes` of `values[j]`, its limbs stored;
`t` closes the read-back of the limbs. -/
local macro "bcast_body" t:tactic : tactic =>
  `(tactic|
    ( step_pure
      step_load with y0
      step_pure
      step_load with y1
      step_pure
      step_load with y2
      step_pure
      step_load with y3
      step_pure
      step_load with y4
      step_pure
      step_load with y5
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
      have hx : (⟨y0, y1, y2, y3, y4, y5⟩ : Limbs) = extractLimbs A := by
        rw [hy0, hy1, hy2, hy3, hy4, hy5]
        $t:tactic
      have hc := cells_of hx hm
      iterate 18 step_pure
      step_pure with c0
      rw [hc.1] at hc0
      step_pure
      step_store
      subst hc0
      iterate 2 step_pure
      step_pure with c1
      rw [hc.2.1] at hc1
      step_pure
      step_store
      subst hc1
      iterate 2 step_pure
      step_pure with c2
      rw [hc.2.2.1] at hc2
      step_pure
      step_store
      subst hc2
      iterate 2 step_pure
      step_pure with c3
      rw [hc.2.2.2.1] at hc3
      step_pure
      step_store
      subst hc3
      iterate 2 step_pure
      step_pure with c4
      rw [hc.2.2.2.2] at hc4
      step_pure
      step_store
      subst hc4
      iterate 2 step_pure))

/-- The entry block's constants the loop reads. -/
abbrev Consts (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) : Prop :=
  E ⊨ [%0 := .value 12#64, %1 := .value 153#256, %2 := .value 102#256, %3 := .value 51#256, %4 :=
    .value 2251799813685247#64, %8 := Vector.replicate 8 PoisonOr.poison, %19 := .value 320#64,
    %20 := .value 0#64, %21 := .value 8#64, %22 := .value 40#64, %23 := .value 8796093022207#64,
    %24 := .value 43#64, %25 := .value 1099511627775#64, %26 := .value 18446744073709551615#64,
    %27 := .value 19#64, %28 := .value 1#64, %29 := .value 1099511627776#64, %30 :=
    .value 18446744073709551597#64, %31 := Vector.replicate 4 PoisonOr.poison, %32 := .value 2#64,
    %33 := .value 3#64, %34 := Ty.wrap (Vector.replicate 4 8796093022207#64), %35 :=
    Vector.replicate 2 PoisonOr.poison, %36 :=
    Ty.wrap #v[8796093022207#64, 18446744073709551615#64], %47 :=
    ((Vector.replicate 8 PoisonOr.poison).set 6 (PoisonOr.value 0#64) (by decide)).set 7
      (PoisonOr.value 0#64) (by decide),
    %55 :=
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value 0#64) (by decide)).set 1
                              (PoisonOr.value 21#64) (by decide)).set
                          2 (PoisonOr.value 42#64) (by decide)).set
                      3 PoisonOr.poison (by decide)).set
                  4 (PoisonOr.value 20#64) (by decide)).set
              5 PoisonOr.poison (by decide)).set
          6 PoisonOr.poison (by decide)).set
      7 PoisonOr.poison (by decide),
    %63 :=
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value 0#64) (by decide)).set 1
                              (PoisonOr.value 43#64) (by decide)).set
                          2 (PoisonOr.value 22#64) (by decide)).set
                      3 (PoisonOr.value 1#64) (by decide)).set
                  4 PoisonOr.poison (by decide)).set
              5 (PoisonOr.value 23#64) (by decide)).set
          6 PoisonOr.poison (by decide)).set
      7 PoisonOr.poison (by decide),
    %71 :=
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value 0#64) (by decide)).set 1
                              (PoisonOr.value 43#64) (by decide)).set
                          2 (PoisonOr.value 22#64) (by decide)).set
                      3 PoisonOr.poison (by decide)).set
                  4 (PoisonOr.value 44#64) (by decide)).set
              5 (PoisonOr.value 23#64) (by decide)).set
          6 PoisonOr.poison (by decide)).set
      7 PoisonOr.poison (by decide)]

/-- The loop's pointers: `limbs` at `L`, `values` at `V`, the counter at `k`. -/
abbrev Ptrs (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (L V : Pointer) (k : Nat) :
    Prop :=
  E ⊨ [%72 := .value L, %73 := .value V, %81 := .value (L.add 64#64), %82 := .value (L.add 128#64),
    %83 := .value (L.add 192#64), %84 := .value (L.add 256#64), %85 := .value (BitVec.ofNat 64 k)]

/-- The pointers the exit reads. -/
abbrev ExitPtrs (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (L V : Pointer) : Prop :=
  E ⊨ [%72 := .value L, %73 := .value V]

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter0 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 0) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 1 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt L (limbsOfBytes (tobytes A) 0)).storeAt (L.add 64#64)
                              (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 128#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 192#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 256#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body (simp only [setWidth_packLanes', Vector.getElem_ofFn, Nat.zero_mod]; rfl)
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter1 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 1) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 2 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 8#64) (limbsOfBytes (tobytes A) 0)).storeAt (L.add 72#64)
                              (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 136#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 200#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 264#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter2 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 2) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 3 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 16#64) (limbsOfBytes (tobytes A) 0)).storeAt (L.add 80#64)
                              (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 144#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 208#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 272#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter3 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 3) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_16 : Fits S.mem (L.add 16#64) 64)
    (hread_L_16 : S.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_80 : Fits S.mem (L.add 80#64) 64)
    (hread_L_80 : S.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_144 : Fits S.mem (L.add 144#64) 64)
    (hread_L_144 : S.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_208 : Fits S.mem (L.add 208#64) 64)
    (hread_L_208 : S.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_272 : Fits S.mem (L.add 272#64) 64)
    (hread_L_272 : S.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 4 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 24#64) (limbsOfBytes (tobytes A) 0)).storeAt (L.add 88#64)
                              (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 152#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 216#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 280#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 24#64) 64 →
          S'.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 88#64) 64 →
          S'.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 152#64) 64 →
          S'.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 216#64) 64 →
          S'.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 280#64) 64 →
          S'.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
      hread_L_216 hfits_L_280 hread_L_280
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter4 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 4) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_16 : Fits S.mem (L.add 16#64) 64)
    (hread_L_16 : S.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_80 : Fits S.mem (L.add 80#64) 64)
    (hread_L_80 : S.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_144 : Fits S.mem (L.add 144#64) 64)
    (hread_L_144 : S.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_208 : Fits S.mem (L.add 208#64) 64)
    (hread_L_208 : S.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_272 : Fits S.mem (L.add 272#64) 64)
    (hread_L_272 : S.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_24 : Fits S.mem (L.add 24#64) 64)
    (hread_L_24 : S.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_88 : Fits S.mem (L.add 88#64) 64)
    (hread_L_88 : S.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_152 : Fits S.mem (L.add 152#64) 64)
    (hread_L_152 : S.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_216 : Fits S.mem (L.add 216#64) 64)
    (hread_L_216 : S.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_280 : Fits S.mem (L.add 280#64) 64)
    (hread_L_280 : S.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 5 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 32#64) (limbsOfBytes (tobytes A) 0)).storeAt (L.add 96#64)
                              (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 160#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 224#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 288#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 24#64) 64 →
          S'.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 88#64) 64 →
          S'.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 152#64) 64 →
          S'.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 216#64) 64 →
          S'.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 280#64) 64 →
          S'.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 32#64) 64 →
          S'.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 96#64) 64 →
          S'.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 160#64) 64 →
          S'.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 224#64) 64 →
          S'.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 288#64) 64 →
          S'.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
      hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
      hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter5 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 5) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_16 : Fits S.mem (L.add 16#64) 64)
    (hread_L_16 : S.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_80 : Fits S.mem (L.add 80#64) 64)
    (hread_L_80 : S.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_144 : Fits S.mem (L.add 144#64) 64)
    (hread_L_144 : S.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_208 : Fits S.mem (L.add 208#64) 64)
    (hread_L_208 : S.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_272 : Fits S.mem (L.add 272#64) 64)
    (hread_L_272 : S.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_24 : Fits S.mem (L.add 24#64) 64)
    (hread_L_24 : S.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_88 : Fits S.mem (L.add 88#64) 64)
    (hread_L_88 : S.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_152 : Fits S.mem (L.add 152#64) 64)
    (hread_L_152 : S.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_216 : Fits S.mem (L.add 216#64) 64)
    (hread_L_216 : S.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_280 : Fits S.mem (L.add 280#64) 64)
    (hread_L_280 : S.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_32 : Fits S.mem (L.add 32#64) 64)
    (hread_L_32 : S.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_96 : Fits S.mem (L.add 96#64) 64)
    (hread_L_96 : S.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_160 : Fits S.mem (L.add 160#64) 64)
    (hread_L_160 : S.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_224 : Fits S.mem (L.add 224#64) 64)
    (hread_L_224 : S.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_288 : Fits S.mem (L.add 288#64) 64)
    (hread_L_288 : S.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 6 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 40#64) (limbsOfBytes (tobytes A) 0)).storeAt
                              (L.add 104#64) (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 168#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 232#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 296#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 24#64) 64 →
          S'.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 88#64) 64 →
          S'.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 152#64) 64 →
          S'.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 216#64) 64 →
          S'.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 280#64) 64 →
          S'.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 32#64) 64 →
          S'.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 96#64) 64 →
          S'.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 160#64) 64 →
          S'.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 224#64) 64 →
          S'.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 288#64) 64 →
          S'.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 40#64) 64 →
          S'.mem.readAt (L.add 40#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 104#64) 64 →
          S'.mem.readAt (L.add 104#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 168#64) 64 →
          S'.mem.readAt (L.add 168#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 232#64) 64 →
          S'.mem.readAt (L.add 232#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 296#64) 64 →
          S'.mem.readAt (L.add 296#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
      hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
      hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
      hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter6 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 6) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_16 : Fits S.mem (L.add 16#64) 64)
    (hread_L_16 : S.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_80 : Fits S.mem (L.add 80#64) 64)
    (hread_L_80 : S.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_144 : Fits S.mem (L.add 144#64) 64)
    (hread_L_144 : S.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_208 : Fits S.mem (L.add 208#64) 64)
    (hread_L_208 : S.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_272 : Fits S.mem (L.add 272#64) 64)
    (hread_L_272 : S.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_24 : Fits S.mem (L.add 24#64) 64)
    (hread_L_24 : S.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_88 : Fits S.mem (L.add 88#64) 64)
    (hread_L_88 : S.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_152 : Fits S.mem (L.add 152#64) 64)
    (hread_L_152 : S.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_216 : Fits S.mem (L.add 216#64) 64)
    (hread_L_216 : S.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_280 : Fits S.mem (L.add 280#64) 64)
    (hread_L_280 : S.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_32 : Fits S.mem (L.add 32#64) 64)
    (hread_L_32 : S.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_96 : Fits S.mem (L.add 96#64) 64)
    (hread_L_96 : S.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_160 : Fits S.mem (L.add 160#64) 64)
    (hread_L_160 : S.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_224 : Fits S.mem (L.add 224#64) 64)
    (hread_L_224 : S.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_288 : Fits S.mem (L.add 288#64) 64)
    (hread_L_288 : S.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_40 : Fits S.mem (L.add 40#64) 64)
    (hread_L_40 : S.mem.readAt (L.add 40#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_104 : Fits S.mem (L.add 104#64) 64)
    (hread_L_104 : S.mem.readAt (L.add 104#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_168 : Fits S.mem (L.add 168#64) 64)
    (hread_L_168 : S.mem.readAt (L.add 168#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_232 : Fits S.mem (L.add 232#64) 64)
    (hread_L_232 : S.mem.readAt (L.add 232#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_296 : Fits S.mem (L.add 296#64) 64)
    (hread_L_296 : S.mem.readAt (L.add 296#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          Ptrs E' L V 7 →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 48#64) (limbsOfBytes (tobytes A) 0)).storeAt
                              (L.add 112#64) (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 176#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 240#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 304#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 24#64) 64 →
          S'.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 88#64) 64 →
          S'.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 152#64) 64 →
          S'.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 216#64) 64 →
          S'.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 280#64) 64 →
          S'.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 32#64) 64 →
          S'.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 96#64) 64 →
          S'.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 160#64) 64 →
          S'.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 224#64) 64 →
          S'.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 288#64) 64 →
          S'.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 40#64) 64 →
          S'.mem.readAt (L.add 40#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 104#64) 64 →
          S'.mem.readAt (L.add 104#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 168#64) 64 →
          S'.mem.readAt (L.add 168#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 232#64) 64 →
          S'.mem.readAt (L.add 232#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 296#64) 64 →
          S'.mem.readAt (L.add 296#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 48#64) 64 →
          S'.mem.readAt (L.add 48#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 112#64) 64 →
          S'.mem.readAt (L.add 112#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 176#64) 64 →
          S'.mem.readAt (L.add 176#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 240#64) 64 →
          S'.mem.readAt (L.add 240#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 304#64) 64 →
          S'.mem.readAt (L.add 304#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 1 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
      hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
      hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
      hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296 hfits_L_48
      hread_L_48 hfits_L_112 hread_L_112 hfits_L_176 hread_L_176 hfits_L_240 hread_L_240 hfits_L_304
      hread_L_304
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [Ptrs] at hP ⊢; env_reads

-- one loop iteration, 125 instructions
set_option maxHeartbeats 3000000 in
theorem iter7 (A : Wwl) (L V : Pointer) (hLo : L.offset = 0) (hVo : V.offset = 0)
    (hLV : L.id ≠ V.id) (S : GlobalState) (E : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫)
    (g : Vals Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.tRets × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hC : Consts E) (hP : Ptrs E L V 7) (hwf : S.WF) (hV : Fits S.mem V 4096)
    (hval : S.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]))
    (hL : Room S.mem L 2560) (R : Pointer) (hR : Room S.mem R 2560) (hfits_L : Fits S.mem L 64)
    (hread_L : S.mem.readAt L 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_64 : Fits S.mem (L.add 64#64) 64)
    (hread_L_64 : S.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_128 : Fits S.mem (L.add 128#64) 64)
    (hread_L_128 : S.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_192 : Fits S.mem (L.add 192#64) 64)
    (hread_L_192 : S.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_256 : Fits S.mem (L.add 256#64) 64)
    (hread_L_256 : S.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_8 : Fits S.mem (L.add 8#64) 64)
    (hread_L_8 : S.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_72 : Fits S.mem (L.add 72#64) 64)
    (hread_L_72 : S.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_136 : Fits S.mem (L.add 136#64) 64)
    (hread_L_136 : S.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_200 : Fits S.mem (L.add 200#64) 64)
    (hread_L_200 : S.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_264 : Fits S.mem (L.add 264#64) 64)
    (hread_L_264 : S.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_16 : Fits S.mem (L.add 16#64) 64)
    (hread_L_16 : S.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_80 : Fits S.mem (L.add 80#64) 64)
    (hread_L_80 : S.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_144 : Fits S.mem (L.add 144#64) 64)
    (hread_L_144 : S.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_208 : Fits S.mem (L.add 208#64) 64)
    (hread_L_208 : S.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_272 : Fits S.mem (L.add 272#64) 64)
    (hread_L_272 : S.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_24 : Fits S.mem (L.add 24#64) 64)
    (hread_L_24 : S.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_88 : Fits S.mem (L.add 88#64) 64)
    (hread_L_88 : S.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_152 : Fits S.mem (L.add 152#64) 64)
    (hread_L_152 : S.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_216 : Fits S.mem (L.add 216#64) 64)
    (hread_L_216 : S.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_280 : Fits S.mem (L.add 280#64) 64)
    (hread_L_280 : S.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_32 : Fits S.mem (L.add 32#64) 64)
    (hread_L_32 : S.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_96 : Fits S.mem (L.add 96#64) 64)
    (hread_L_96 : S.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_160 : Fits S.mem (L.add 160#64) 64)
    (hread_L_160 : S.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_224 : Fits S.mem (L.add 224#64) 64)
    (hread_L_224 : S.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_288 : Fits S.mem (L.add 288#64) 64)
    (hread_L_288 : S.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_40 : Fits S.mem (L.add 40#64) 64)
    (hread_L_40 : S.mem.readAt (L.add 40#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_104 : Fits S.mem (L.add 104#64) 64)
    (hread_L_104 : S.mem.readAt (L.add 104#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_168 : Fits S.mem (L.add 168#64) 64)
    (hread_L_168 : S.mem.readAt (L.add 168#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_232 : Fits S.mem (L.add 232#64) 64)
    (hread_L_232 : S.mem.readAt (L.add 232#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_296 : Fits S.mem (L.add 296#64) 64)
    (hread_L_296 : S.mem.readAt (L.add 296#64) 64 = limbsOfBytes (tobytes A) 4)
    (hfits_L_48 : Fits S.mem (L.add 48#64) 64)
    (hread_L_48 : S.mem.readAt (L.add 48#64) 64 = limbsOfBytes (tobytes A) 0)
    (hfits_L_112 : Fits S.mem (L.add 112#64) 64)
    (hread_L_112 : S.mem.readAt (L.add 112#64) 64 = limbsOfBytes (tobytes A) 1)
    (hfits_L_176 : Fits S.mem (L.add 176#64) 64)
    (hread_L_176 : S.mem.readAt (L.add 176#64) 64 = limbsOfBytes (tobytes A) 2)
    (hfits_L_240 : Fits S.mem (L.add 240#64) 64)
    (hread_L_240 : S.mem.readAt (L.add 240#64) 64 = limbsOfBytes (tobytes A) 3)
    (hfits_L_304 : Fits S.mem (L.add 304#64) 64)
    (hread_L_304 : S.mem.readAt (L.add 304#64) 64 = limbsOfBytes (tobytes A) 4)
    (hK :
      ∀ (E' : ⟪Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.Γ⟫) (S' : GlobalState),
        E'.args = E.args →
          Consts E' →
          ExitPtrs E' L V →
          S' =
            { S with
              mem :=
                (((((S.mem.storeAt (L.add 56#64) (limbsOfBytes (tobytes A) 0)).storeAt
                              (L.add 120#64) (limbsOfBytes (tobytes A) 1)).storeAt
                          (L.add 184#64) (limbsOfBytes (tobytes A) 2)).storeAt
                      (L.add 248#64) (limbsOfBytes (tobytes A) 3)).storeAt
                  (L.add 312#64) (limbsOfBytes (tobytes A) 4)) } →
          S'.WF →
          Fits S'.mem V 4096 →
          S'.mem.readAt V 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) →
          Room S'.mem L 2560 →
          Room S'.mem R 2560 →
          Fits S'.mem L 64 →
          S'.mem.readAt L 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 64#64) 64 →
          S'.mem.readAt (L.add 64#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 128#64) 64 →
          S'.mem.readAt (L.add 128#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 192#64) 64 →
          S'.mem.readAt (L.add 192#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 256#64) 64 →
          S'.mem.readAt (L.add 256#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 8#64) 64 →
          S'.mem.readAt (L.add 8#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 72#64) 64 →
          S'.mem.readAt (L.add 72#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 136#64) 64 →
          S'.mem.readAt (L.add 136#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 200#64) 64 →
          S'.mem.readAt (L.add 200#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 264#64) 64 →
          S'.mem.readAt (L.add 264#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 16#64) 64 →
          S'.mem.readAt (L.add 16#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 80#64) 64 →
          S'.mem.readAt (L.add 80#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 144#64) 64 →
          S'.mem.readAt (L.add 144#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 208#64) 64 →
          S'.mem.readAt (L.add 208#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 272#64) 64 →
          S'.mem.readAt (L.add 272#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 24#64) 64 →
          S'.mem.readAt (L.add 24#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 88#64) 64 →
          S'.mem.readAt (L.add 88#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 152#64) 64 →
          S'.mem.readAt (L.add 152#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 216#64) 64 →
          S'.mem.readAt (L.add 216#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 280#64) 64 →
          S'.mem.readAt (L.add 280#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 32#64) 64 →
          S'.mem.readAt (L.add 32#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 96#64) 64 →
          S'.mem.readAt (L.add 96#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 160#64) 64 →
          S'.mem.readAt (L.add 160#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 224#64) 64 →
          S'.mem.readAt (L.add 224#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 288#64) 64 →
          S'.mem.readAt (L.add 288#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 40#64) 64 →
          S'.mem.readAt (L.add 40#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 104#64) 64 →
          S'.mem.readAt (L.add 104#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 168#64) 64 →
          S'.mem.readAt (L.add 168#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 232#64) 64 →
          S'.mem.readAt (L.add 232#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 296#64) 64 →
          S'.mem.readAt (L.add 296#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 48#64) 64 →
          S'.mem.readAt (L.add 48#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 112#64) 64 →
          S'.mem.readAt (L.add 112#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 176#64) 64 →
          S'.mem.readAt (L.add 176#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 240#64) 64 →
          S'.mem.readAt (L.add 240#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 304#64) 64 →
          S'.mem.readAt (L.add 304#64) 64 = limbsOfBytes (tobytes A) 4 →
          Fits S'.mem (L.add 56#64) 64 →
          S'.mem.readAt (L.add 56#64) 64 = limbsOfBytes (tobytes A) 0 →
          Fits S'.mem (L.add 120#64) 64 →
          S'.mem.readAt (L.add 120#64) 64 = limbsOfBytes (tobytes A) 1 →
          Fits S'.mem (L.add 184#64) 64 →
          S'.mem.readAt (L.add 184#64) 64 = limbsOfBytes (tobytes A) 2 →
          Fits S'.mem (L.add 248#64) 64 →
          S'.mem.readAt (L.add 248#64) 64 = limbsOfBytes (tobytes A) 3 →
          Fits S'.mem (L.add 312#64) 64 →
          S'.mem.readAt (L.add 312#64) 64 = limbsOfBytes (tobytes A) 4 →
          (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E' 2 S' >>= g) = K) :
    (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.runFrom E 1 S >>= g) = K := by
  block_init
  bcast_body rfl
  finish_block
  refine
    hK E S ?_ ?_ ?_ hS hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
      hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
      hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
      hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
      hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
      hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
      hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
      hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296 hfits_L_48
      hread_L_48 hfits_L_112 hread_L_112 hfits_L_176 hread_L_176 hfits_L_240 hread_L_240 hfits_L_304
      hread_L_304 hfits_L_56 hread_L_56 hfits_L_120 hread_L_120 hfits_L_184 hread_L_184 hfits_L_248
      hread_L_248 hfits_L_312 hread_L_312
  · rw [hE]; simp only [Env.write_args]
  · dsimp only [Consts] at hC ⊢; env_reads
  · dsimp only [ExitPtrs, Ptrs] at hP ⊢; env_reads

-- 72 constants and the stores of the entry, eight loop iterations, the copy out
set_option maxHeartbeats 4000000 in
/-- `fd_ed25519_lane_bcast_fe( r, a )` stores at `r` the broadcast limbs of `fd_f25519_tobytes(a)`,
`a` an `fd_f25519_t` by value; its two stack arrays are freed. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq (r : Pointer) (A : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.FeRoom r) :
    Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call
        (Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.args (.value r) (Ty.wrap A)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeFe r (bcastBytes (tobytes A)) }) := by
  func_init
  block_init
  iterate 72 step_pure
  step_alloca
  step_alloca
  step_pure
  step_store
  iterate 7 (step_pure; step_store)
  have hov (o : BitVec 64) (ho : o.toNat < 4096 := by decide) : ¬v73.offset.uaddOverflow o := by
    rw [hv73_off]; simp [BitVec.uaddOverflow]; omega
  have hv73_fits : Fits S.mem v73 4096 :=
    Fits.append (v := 3584) (hov 448#64) (by decide) (by decide)
      (Fits.append (v := 3072) (hov 384#64) (by decide) (by decide)
        (Fits.append (v := 2560) (hov 320#64) (by decide) (by decide)
          (Fits.append (v := 2048) (hov 256#64) (by decide) (by decide)
            (Fits.append (v := 1536) (hov 192#64) (by decide) (by decide)
              (Fits.append (v := 1024) (hov 128#64) (by decide) (by decide)
                (Fits.append (v := 512) (hov 64#64) (by decide) (by decide) hfits_v73 hfits_v73_64)
                hfits_v73_128)
              hfits_v73_192)
            hfits_v73_256)
          hfits_v73_320)
        hfits_v73_384)
      hfits_v73_448
  have hval :
    S.mem.readAt v73 4096 = BitVec.packLanes (Vector.ofFn fun k : Fin 64 => A[k.val % 8]) := by
    refine MemoryState.readAt_eq_of_cells512 (n := 8) hv73_fits.inBounds (hov _) (by decide) ?_
    intro k hk
    rw [packLanes_rep8_cell A k hk]
    interval_cases k <;> simp only [Nat.reduceMul, Pointer.add_zero]
    exacts [hread_v73, hread_v73_64, hread_v73_128, hread_v73_192, hread_v73_256, hread_v73_320,
      hread_v73_384, hread_v73_448]
  have hne : v72.id ≠ v73.id := by
    rw [hv72, hv73]; exact GlobalState.slot_id_ne (by decide)
  clear hov hfits_v73 hfits_v73_64 hfits_v73_128 hfits_v73_192 hfits_v73_256 hfits_v73_320
    hfits_v73_384 hfits_v73_448 hread_v73 hread_v73_64 hread_v73_128 hread_v73_192 hread_v73_256
    hread_v73_320 hread_v73_384 hread_v73_448
  iterate 5 step_pure
  finish_block
  refine
    iter0 A v72 v73 hv72_off hv73_off hne S E _ _
      (by
        dsimp only [Consts]; env_reads)
      (by
        dsimp only [Ptrs]; env_reads)
      hwf hv73_fits hval hroom_v72 r hr.2 ?_
  intro E S hA hC hP hS1 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter1 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      ?_
  intro E S hA hC hP hS2 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter2 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 ?_
  intro E S hA hC hP hS3 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter3 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 hfits_L_16 hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144
      hfits_L_208 hread_L_208 hfits_L_272 hread_L_272 ?_
  intro E S hA hC hP hS4 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
    hread_L_216 hfits_L_280 hread_L_280
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter4 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 hfits_L_16 hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144
      hfits_L_208 hread_L_208 hfits_L_272 hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88
      hfits_L_152 hread_L_152 hfits_L_216 hread_L_216 hfits_L_280 hread_L_280 ?_
  intro E S hA hC hP hS5 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
    hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
    hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter5 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 hfits_L_16 hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144
      hfits_L_208 hread_L_208 hfits_L_272 hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88
      hfits_L_152 hread_L_152 hfits_L_216 hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32
      hfits_L_96 hread_L_96 hfits_L_160 hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288
      ?_
  intro E S hA hC hP hS6 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
    hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
    hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
    hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter6 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 hfits_L_16 hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144
      hfits_L_208 hread_L_208 hfits_L_272 hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88
      hfits_L_152 hread_L_152 hfits_L_216 hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32
      hfits_L_96 hread_L_96 hfits_L_160 hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288
      hfits_L_40 hread_L_40 hfits_L_104 hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232
      hfits_L_296 hread_L_296 ?_
  intro E S hA hC hP hS7 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
    hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
    hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
    hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296 hfits_L_48
    hread_L_48 hfits_L_112 hread_L_112 hfits_L_176 hread_L_176 hfits_L_240 hread_L_240 hfits_L_304
    hread_L_304
  replace hArgs := hA.trans hArgs
  clear hA
  refine
    iter7 A v72 v73 hv72_off hv73_off hne S E _ _ hC hP hwf hV hval hL r hR hfits_L hread_L
      hfits_L_64 hread_L_64 hfits_L_128 hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256
      hfits_L_8 hread_L_8 hfits_L_72 hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200
      hfits_L_264 hread_L_264 hfits_L_16 hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144
      hfits_L_208 hread_L_208 hfits_L_272 hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88
      hfits_L_152 hread_L_152 hfits_L_216 hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32
      hfits_L_96 hread_L_96 hfits_L_160 hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288
      hfits_L_40 hread_L_40 hfits_L_104 hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232
      hfits_L_296 hread_L_296 hfits_L_48 hread_L_48 hfits_L_112 hread_L_112 hfits_L_176 hread_L_176
      hfits_L_240 hread_L_240 hfits_L_304 hread_L_304 ?_
  intro E S hA hC hP hS8 hwf hV hval hL hR hfits_L hread_L hfits_L_64 hread_L_64 hfits_L_128
    hread_L_128 hfits_L_192 hread_L_192 hfits_L_256 hread_L_256 hfits_L_8 hread_L_8 hfits_L_72
    hread_L_72 hfits_L_136 hread_L_136 hfits_L_200 hread_L_200 hfits_L_264 hread_L_264 hfits_L_16
    hread_L_16 hfits_L_80 hread_L_80 hfits_L_144 hread_L_144 hfits_L_208 hread_L_208 hfits_L_272
    hread_L_272 hfits_L_24 hread_L_24 hfits_L_88 hread_L_88 hfits_L_152 hread_L_152 hfits_L_216
    hread_L_216 hfits_L_280 hread_L_280 hfits_L_32 hread_L_32 hfits_L_96 hread_L_96 hfits_L_160
    hread_L_160 hfits_L_224 hread_L_224 hfits_L_288 hread_L_288 hfits_L_40 hread_L_40 hfits_L_104
    hread_L_104 hfits_L_168 hread_L_168 hfits_L_232 hread_L_232 hfits_L_296 hread_L_296 hfits_L_48
    hread_L_48 hfits_L_112 hread_L_112 hfits_L_176 hread_L_176 hfits_L_240 hread_L_240 hfits_L_304
    hread_L_304 hfits_L_56 hread_L_56 hfits_L_120 hread_L_120 hfits_L_184 hread_L_184 hfits_L_248
    hread_L_248 hfits_L_312 hread_L_312
  replace hArgs := hA.trans hArgs
  clear hA
  have hov72 (o : BitVec 64) (ho : o.toNat ≤ 2560 := by decide) : ¬v72.offset.uaddOverflow o := by
    rw [hv72_off]; simp [BitVec.uaddOverflow]; omega
  have c1 := Fits.append (v := 64) (u := 128) (hov72 8#64) (by decide) (by decide) hfits_L hfits_L_8
  have c2 := Fits.append (v := 128) (u := 192) (hov72 16#64) (by decide) (by decide) c1 hfits_L_16
  have c3 := Fits.append (v := 192) (u := 256) (hov72 24#64) (by decide) (by decide) c2 hfits_L_24
  have c4 := Fits.append (v := 256) (u := 320) (hov72 32#64) (by decide) (by decide) c3 hfits_L_32
  have c5 := Fits.append (v := 320) (u := 384) (hov72 40#64) (by decide) (by decide) c4 hfits_L_40
  have c6 := Fits.append (v := 384) (u := 448) (hov72 48#64) (by decide) (by decide) c5 hfits_L_48
  have c7 := Fits.append (v := 448) (u := 512) (hov72 56#64) (by decide) (by decide) c6 hfits_L_56
  have c8 := Fits.append (v := 512) (u := 576) (hov72 64#64) (by decide) (by decide) c7 hfits_L_64
  have c9 := Fits.append (v := 576) (u := 640) (hov72 72#64) (by decide) (by decide) c8 hfits_L_72
  have c10 := Fits.append (v := 640) (u := 704) (hov72 80#64) (by decide) (by decide) c9 hfits_L_80
  have c11 := Fits.append (v := 704) (u := 768) (hov72 88#64) (by decide) (by decide) c10 hfits_L_88
  have c12 := Fits.append (v := 768) (u := 832) (hov72 96#64) (by decide) (by decide) c11 hfits_L_96
  have c13 :=
    Fits.append (v := 832) (u := 896) (hov72 104#64) (by decide) (by decide) c12 hfits_L_104
  have c14 :=
    Fits.append (v := 896) (u := 960) (hov72 112#64) (by decide) (by decide) c13 hfits_L_112
  have c15 :=
    Fits.append (v := 960) (u := 1024) (hov72 120#64) (by decide) (by decide) c14 hfits_L_120
  have c16 :=
    Fits.append (v := 1024) (u := 1088) (hov72 128#64) (by decide) (by decide) c15 hfits_L_128
  have c17 :=
    Fits.append (v := 1088) (u := 1152) (hov72 136#64) (by decide) (by decide) c16 hfits_L_136
  have c18 :=
    Fits.append (v := 1152) (u := 1216) (hov72 144#64) (by decide) (by decide) c17 hfits_L_144
  have c19 :=
    Fits.append (v := 1216) (u := 1280) (hov72 152#64) (by decide) (by decide) c18 hfits_L_152
  have c20 :=
    Fits.append (v := 1280) (u := 1344) (hov72 160#64) (by decide) (by decide) c19 hfits_L_160
  have c21 :=
    Fits.append (v := 1344) (u := 1408) (hov72 168#64) (by decide) (by decide) c20 hfits_L_168
  have c22 :=
    Fits.append (v := 1408) (u := 1472) (hov72 176#64) (by decide) (by decide) c21 hfits_L_176
  have c23 :=
    Fits.append (v := 1472) (u := 1536) (hov72 184#64) (by decide) (by decide) c22 hfits_L_184
  have c24 :=
    Fits.append (v := 1536) (u := 1600) (hov72 192#64) (by decide) (by decide) c23 hfits_L_192
  have c25 :=
    Fits.append (v := 1600) (u := 1664) (hov72 200#64) (by decide) (by decide) c24 hfits_L_200
  have c26 :=
    Fits.append (v := 1664) (u := 1728) (hov72 208#64) (by decide) (by decide) c25 hfits_L_208
  have c27 :=
    Fits.append (v := 1728) (u := 1792) (hov72 216#64) (by decide) (by decide) c26 hfits_L_216
  have c28 :=
    Fits.append (v := 1792) (u := 1856) (hov72 224#64) (by decide) (by decide) c27 hfits_L_224
  have c29 :=
    Fits.append (v := 1856) (u := 1920) (hov72 232#64) (by decide) (by decide) c28 hfits_L_232
  have c30 :=
    Fits.append (v := 1920) (u := 1984) (hov72 240#64) (by decide) (by decide) c29 hfits_L_240
  have c31 :=
    Fits.append (v := 1984) (u := 2048) (hov72 248#64) (by decide) (by decide) c30 hfits_L_248
  have c32 :=
    Fits.append (v := 2048) (u := 2112) (hov72 256#64) (by decide) (by decide) c31 hfits_L_256
  have c33 :=
    Fits.append (v := 2112) (u := 2176) (hov72 264#64) (by decide) (by decide) c32 hfits_L_264
  have c34 :=
    Fits.append (v := 2176) (u := 2240) (hov72 272#64) (by decide) (by decide) c33 hfits_L_272
  have c35 :=
    Fits.append (v := 2240) (u := 2304) (hov72 280#64) (by decide) (by decide) c34 hfits_L_280
  have c36 :=
    Fits.append (v := 2304) (u := 2368) (hov72 288#64) (by decide) (by decide) c35 hfits_L_288
  have c37 :=
    Fits.append (v := 2368) (u := 2432) (hov72 296#64) (by decide) (by decide) c36 hfits_L_296
  have c38 :=
    Fits.append (v := 2432) (u := 2496) (hov72 304#64) (by decide) (by decide) c37 hfits_L_304
  have c39 :=
    Fits.append (v := 2496) (u := 2560) (hov72 312#64) (by decide) (by decide) c38 hfits_L_312
  have hX :
    S.mem.readAt v72 2560 =
      (BitVec.packLanes (bcastBytes (tobytes A)).l4 ++
        (BitVec.packLanes (bcastBytes (tobytes A)).l3 ++
          (BitVec.packLanes (bcastBytes (tobytes A)).l2 ++
            (BitVec.packLanes (bcastBytes (tobytes A)).l1 ++
              BitVec.packLanes (bcastBytes (tobytes A)).l0)))) := by
    refine MemoryState.readAt_eq_of_cells (n := 40) c39.inBounds (hov72 _) (by decide) ?_
    intro k hk
    rw [cell_bcast (tobytes A) k hk]
    interval_cases k <;> simp only [Nat.reduceMul, Pointer.add_zero, Nat.reduceDiv]
    exacts [hread_L, hread_L_8, hread_L_16, hread_L_24, hread_L_32, hread_L_40, hread_L_48,
      hread_L_56, hread_L_64, hread_L_72, hread_L_80, hread_L_88, hread_L_96, hread_L_104,
      hread_L_112, hread_L_120, hread_L_128, hread_L_136, hread_L_144, hread_L_152, hread_L_160,
      hread_L_168, hread_L_176, hread_L_184, hread_L_192, hread_L_200, hread_L_208, hread_L_216,
      hread_L_224, hread_L_232, hread_L_240, hread_L_248, hread_L_256, hread_L_264, hread_L_272,
      hread_L_280, hread_L_288, hread_L_296, hread_L_304, hread_L_312]
  block_init
  step_memcpy
  step_pure
  step_pure
  finish_block
  have hr320 := hr.1
  clear_cells v72
  subst_vars
  erase_frame
  rw [MemoryState.storeFe_eq_storeAt hr320]
  rfl

end Proof

end MLIR.Firedancer.Lane

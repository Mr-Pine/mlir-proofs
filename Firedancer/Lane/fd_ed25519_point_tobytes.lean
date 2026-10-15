module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.fd_f25519_inv
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.Mlir.fd_ed25519_point_tobytes
import Mathlib.Tactic.ClearExcept
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `x = X/Z` and `y = Y/Z` of `P`: `fd_f25519_inv` of `Z`, then `fd_f25519_mul2`. -/
def fd_ed25519_point_tobytes.affine (P : Quad) : Wwl × Wwl :=
  let zi := fd_f25519_inv.spec P.Z
  (fd_r43x6_mul P.X zi, fd_r43x6_mul P.Y zi)

/-- `fd_f25519_tobytes( out, y )`: `y`'s bytes. -/
def fd_ed25519_point_tobytes.yBytes (P : Quad) : BitVec 256 :=
  tobytes (fd_ed25519_point_tobytes.affine P).2

/-- `out[31] ^= fd_f25519_sgn( x ) << 7` after `fd_f25519_tobytes( out, y )`: `y`'s byte 31 with
`x`'s low bit on top. -/
def fd_ed25519_point_tobytes.topByte (x y : Wwl) : BitVec 8 :=
  (tobytes y).extractLsb' 248 8 ^^^ ((tobytes x).extractLsb' 0 8 &&& 1) <<< 7

/-- `topByte` of `P`'s `x` and `y`. -/
def fd_ed25519_point_tobytes.top (P : Quad) : BitVec 8 :=
  fd_ed25519_point_tobytes.topByte (fd_ed25519_point_tobytes.affine P).1
    (fd_ed25519_point_tobytes.affine P).2

/-- The 32 bytes `fd_ed25519_point_tobytes` leaves at `out`. -/
def fd_ed25519_point_tobytes.spec (P : Quad) : BitVec 256 :=
  Memory.spliceBits (fd_ed25519_point_tobytes.yBytes P) 248 (fd_ed25519_point_tobytes.top P)

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

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

theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

theorem packLanes_packWv (r : Limbs) : BitVec.packLanes (packWv r) = r43x6Pack r := by
  rw [packLanes_four]
  simp only [packWv, r43x6Pack, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  bv_decide

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

set_option hygiene false in
/-- A step of the scalar tail: lanes expanded, the no-overflow facts as simp arguments, the value
unfolded in later steps. -/
local macro "tb_tr" : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, lanesFrom_getElem,
      Vector.getElem_set, nsw_mask_sshr, nsw_sshr_neg1, nsw_sshr_neg1_mask, nsw_sshr40_sshr40,
      nsw_mul19, nsw_mul19_mask, nsw_carry_sshr, nuw_mask43_19, nuw_mask43_shr43, nuw_mask40_1,
      nsw_mask40_1_sshr, nuw_top, nsw_sshr43_mask43, nsw_sshr43_mask40, nsw_sel19_mask43]
      named transparent)

set_option hygiene false in
/-- `tb_tr`, the value named `x` and kept folded. -/
local macro "tb_nm_with " x:ident : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, lanesFrom_getElem,
      Vector.getElem_set, nsw_mask_sshr, nsw_sshr_neg1, nsw_sshr_neg1_mask, nsw_sshr40_sshr40,
      nsw_mul19, nsw_mul19_mask, nsw_carry_sshr, nuw_mask43_19, nuw_mask43_shr43, nuw_mask40_1,
      nsw_mask40_1_sshr, nuw_top, nsw_sshr43_mask43, nsw_sshr43_mask40, nsw_sel19_mask43]
      with $x:ident)

set_option hygiene false in
/-- `tb_tr`, the value named and kept folded. -/
local macro "tb_nm" : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, lanesFrom_getElem,
      Vector.getElem_set, nsw_mask_sshr, nsw_sshr_neg1, nsw_sshr_neg1_mask, nsw_sshr40_sshr40,
      nsw_mul19, nsw_mul19_mask, nsw_carry_sshr, nuw_mask43_19, nuw_mask43_shr43, nuw_mask40_1,
      nsw_mask40_1_sshr, nuw_top, nsw_sshr43_mask43, nsw_sshr43_mask40, nsw_sel19_mask43]
      named)

namespace fd_ed25519_point_tobytes

open _root_.Firedancer.Lane.Mlir.fd_ed25519_point_tobytes

/-- The entry block's constants its tail reads. -/
abbrev TailConsts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 7#8, %1 := .value 31#64,
    %9 := Ty.wrap #v[8796093022207#64, 18446744073709551615#64],
    %10 := Vector.replicate 2 .poison, %11 := Ty.wrap (Vector.replicate 4 8796093022207#64),
    %12 := .value 3#64, %13 := .value 2#64, %14 := Vector.replicate 4 .poison, %15 := .value 43#64,
    %16 := .value 18446744073709551597#64, %17 := Ty.wrap (Vector.replicate 2 1099511627776#64),
    %18 := .value 1099511627775#64, %19 := Ty.wrap (Vector.replicate 2 1#64),
    %20 := .value 8796093022207#64, %21 := Ty.wrap (Vector.replicate 2 19#64),
    %22 := Ty.wrap (Vector.replicate 2 40#64),
    %23 := Ty.wrap (Vector.replicate 2 18446744073709551615#64),
    %24 := Ty.wrap (Vector.replicate 2 43#64), %25 := Ty.wrap (Vector.replicate 2 1099511627775#64),
    %26 := Ty.wrap (Vector.replicate 2 8796093022207#64), %35 := Vector.replicate 8 .poison,
    %43 := .value 0#64, %44 := .value 1#64, %71 := lanesFrom 6 wwl_zero,
    %135 := #v[.value 0#64, .value 21#64, .value 42#64, .poison, .value 20#64, .poison, .poison,
      .poison],
    %143 := #v[.value 0#64, .value 43#64, .value 22#64, .value 1#64, .poison, .value 23#64, .poison,
      .poison],
    %151 := #v[.value 0#64, .value 43#64, .value 22#64, .poison, .value 44#64, .value 23#64,
      .poison, .poison],
    %155 := #v[.poison, .value 43#64, .poison, .poison]]

-- 156 steps of scalar and two-lane code in one block
set_option maxHeartbeats 6000000 in
/-- The entry block from `%275`: `fd_f25519_tobytes` of `y` and `x` in two lanes, `y`'s bytes
stored at `out` and byte 31 with `x`'s sign. -/
theorem tail (out a zp tp : Pointer) (X Y : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (E : ⟪Γ⟫) (hC : TailConsts E)
    (hR : E ⊨ [%222 := Ty.wrap X, %274 := Ty.wrap Y])
    (hA : E.args = (args (.value out) (.value a)).get)
    (hzp : E.read (%156) = .value zp) (htp : E.read (%157) = .value tp)
    (hwf : S.WF) (ho : Room S.mem out 256) (hov : ¬out.offset.uaddOverflow 31#64)
    (ho31 : Room S.mem (out.add 31#64) 8)
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (args (.value out) (.value a)).get → E'.read (%156) = .value zp →
        E'.read (%157) = .value tp →
        (entry.runBodyFrom E' 435
              { S with
                mem := (S.mem.storeAt out (tobytes Y)).storeAt (out.add 31#64) (topByte X Y) } >>=
            g) =
          K) :
    (entry.runBodyFrom E 279 S >>= g) = K := by
  split_reads hC hR
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_nm
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm_with vy
  step_store
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  tb_tr
  tb_nm
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_tr
  tb_nm
  step_pure [hov] named
  tb_tr
  tb_nm
  tb_tr
  tb_nm_with vb
  step_store
  have h26 : v426 = (vy[3]).extractLsb' 56 8 := by
    subst_vars
    clear * -
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
  have hmY := mod_compiled (y0 := Y[0]) (y1 := Y[1]) (y2 := Y[2]) (y3 := Y[3]) (y4 := Y[4])
    (y5 := Y[5]) rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have eY : vy = packWv (r43x6Mod (extractLimbs Y)) := by
    rw [show extractLimbs Y = ⟨Y[0], Y[1], Y[2], Y[3], Y[4], Y[5]⟩ from rfl, hmY]
    subst_vars
    clear * -
    ext i hi : 1
    obtain _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | simp only [packWv, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
          List.getElem_cons_succ]
        bv_decide
  have hmX := mod_compiled (y0 := X[0]) (y1 := X[1]) (y2 := X[2]) (y3 := X[3]) (y4 := X[4])
    (y5 := X[5]) rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have eX : v423 = ((packWv (r43x6Mod (extractLimbs X)))[0]).extractLsb' 0 8 := by
    rw [show extractLimbs X = ⟨X[0], X[1], X[2], X[3], X[4], X[5]⟩ from rfl, hmX]
    subst_vars
    clear * -
    simp only [packWv, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
    bv_decide
  have eb : vb = topByte X Y := by
    rw [hvb, h26, eX, eY]
    clear * -
    simp only [topByte, tobytes, r43x6Pack, packWv, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    bv_decide
  subst hS hv424
  rw [eY, eb, packLanes_packWv]
  exact hK E (by assumption) (by env_reads) (by env_reads)

end fd_ed25519_point_tobytes

-- the entry block's two inlined multiplications and their constants
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_tobytes( out, a )` stores `y`'s bytes at `out`, then byte 31 with `x`'s sign,
and returns `out`; its temporaries are freed. -/
public theorem fd_ed25519_point_tobytes.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ho : Room s.mem out 256) (hoff : out.offset.toNat + 32 ≤ 2 ^ 64) (ha : s.mem.QuadFit a) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_tobytes.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_tobytes.args (.value out) (.value a)) s =
      .value
        (.cons (.value out) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              (s.mem.storeAt out (fd_ed25519_point_tobytes.yBytes (s.mem.readQuad a))).storeAt
                (out.add 31#64) (fd_ed25519_point_tobytes.top (s.mem.readQuad a)) }) := by
  func_init
  block_init
  iterate 48 step_pure
  iterate 13 step_pattern using runBodyFrom_insertRun
  iterate 4 step_pure
  -- fd_ed25519_point_to( x, y, z, t, a ): `z` and `t` into their `fd_f25519_t`s
  step_alloca with zp
  step_alloca with tp
  step_pure
  step_pure
  step_load with transparent p03
  step_pure
  step_load with transparent p14
  step_pure
  step_load with transparent p25
  iterate 4 step_pure
  step_pure with z
  replace hz : z = (S₀.mem.readQuad a).Z := by rw [hz]; rfl
  step_store
  step_pure
  step_store
  -- fd_f25519_inv( t, z ), then fd_f25519_mul2( x, x, t, y, y, t )
  step_call using _root_.Firedancer.Lane.Mlir.fd_f25519_inv.call_eq
  step_load with zi
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  step_pure with x5
  replace hx0 : x0 = Vector.replicate 8 (S₀.mem.readQuad a).X[0] := by rw [hx0]; rfl
  replace hx1 : x1 = Vector.replicate 8 (S₀.mem.readQuad a).X[1] := by rw [hx1]; rfl
  replace hx2 : x2 = Vector.replicate 8 (S₀.mem.readQuad a).X[2] := by rw [hx2]; rfl
  replace hx3 : x3 = Vector.replicate 8 (S₀.mem.readQuad a).X[3] := by rw [hx3]; rfl
  replace hx4 : x4 = Vector.replicate 8 (S₀.mem.readQuad a).X[4] := by rw [hx4]; rfl
  replace hx5 : x5 = Vector.replicate 8 (S₀.mem.readQuad a).X[5] := by rw [hx5]; rfl
  step_pattern using runBodyFrom_mulRowsRun (S₀.mem.readQuad a).X with x
  step_pure with y0
  step_pure with y1
  step_pure with y2
  step_pure with y3
  step_pure with y4
  step_pure with y5
  replace hy0 : y0 = Vector.replicate 8 (S₀.mem.readQuad a).Y[0] := by rw [hy0]; rfl
  replace hy1 : y1 = Vector.replicate 8 (S₀.mem.readQuad a).Y[1] := by rw [hy1]; rfl
  replace hy2 : y2 = Vector.replicate 8 (S₀.mem.readQuad a).Y[2] := by rw [hy2]; rfl
  replace hy3 : y3 = Vector.replicate 8 (S₀.mem.readQuad a).Y[3] := by rw [hy3]; rfl
  replace hy4 : y4 = Vector.replicate 8 (S₀.mem.readQuad a).Y[4] := by rw [hy4]; rfl
  replace hy5 : y5 = Vector.replicate 8 (S₀.mem.readQuad a).Y[5] := by rw [hy5]; rfl
  step_pattern using runBodyFrom_mulRowsRun (S₀.mem.readQuad a).Y with y
  replace hv71 : v71 = lanesFrom 6 wwl_zero := by rw [hv71]; rfl
  subst hv71 hv135 hv143 hv151
  have hov : ¬out.offset.uaddOverflow 31#64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq]
    simp
    omega
  refine fd_ed25519_point_tobytes.tail out a zp tp _ _ S E (by env_reads) (by env_reads) hArgs
    (by env_reads) (by env_reads) hwf ho hov (Room.add_of_le hov (by decide) ho)
    fun E' hA' hzp' htp' => ?_
  step_pure
  step_pure
  finish_block
  subst_vars
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Lane

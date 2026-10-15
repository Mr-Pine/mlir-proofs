module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.ModNearlyReducedLimbs
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.fd_r43x6_invert
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.Mlir.fd_r43x6_ge_encode
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `x` (from `fd_r43x6_mul_fast`) extracted, carried with bias `0`, reduced. -/
def encLimbs (x : Wwl) : Limbs :=
  modNearlyC (biasedCarryPropagateLimbs (extractLimbs x) 0)

/-- The encoding of `(x, y)` from `x = X/Z` and `y = Y/Z` before their carries: `y`'s reduced
limbs packed, `x`'s low bit as bit 255. -/
def encPack (x y : Wwl) : Wv :=
  let x := encLimbs x
  let y := encLimbs y
  packWv ⟨y.y0, y.y1, y.y2, y.y3, y.y4, y.y5 ||| (x.y0 &&& 1) <<< 40⟩

/-- `fd_r43x6_ge_encode(P)`: `Z` inverted, `x = X/Z`, `y = Y/Z` by `fd_r43x6_mul_fast`,
`encPack x y`. -/
def fd_r43x6_ge_encode.spec (P : Quad) : Wv :=
  let oneZ := fd_r43x6_invert.spec P.Z
  encPack (fd_r43x6_mul_fast.spec P.X oneZ) (fd_r43x6_mul_fast.spec P.Y oneZ)

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

theorem nsw_sshr43_mask40 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 1099511627775#64) = false := by bv_decide

theorem nsw_sshr43_mask43 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 8796093022207#64) = false := by bv_decide

theorem nuw_mask43_19 (x : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (x &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  bv_decide

theorem nuw_mask43_shr43 (x y : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow (y >>> 43) = false ∧
      (x &&& 8796093022207#64).uaddOverflow (y >>> 43) = false := by
  bv_decide

theorem nsw_top (a b c : BitVec 64) :
    (a.sshiftRight 43 + (b &&& 1099511627775#64)).saddOverflow (c >>> 43) = false := by
  bv_decide

theorem nsw_sel19_mask43 (c : Prop) [Decidable c] (x : BitVec 64) :
    (if c then 18446744073709551597#64 else 0#64).saddOverflow (x &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

set_option hygiene false in
/-- A step of the scalar tail: lanes expanded, the no-overflow facts as simp arguments. -/
local macro "enc_step" : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, sshiftRight40_smulOverflow,
      nsw_sshr43_mask40, nsw_sshr43_mask43, nuw_mask43_19, nuw_mask43_shr43, nsw_top,
      nsw_sel19_mask43, Vector.getElem_set, lanesFrom_getElem])

set_option hygiene false in
/-- `enc_step`, its value named `x`, unfolded in later steps. -/
local macro "enc_step_tr " x:ident : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, sshiftRight40_smulOverflow,
      nsw_sshr43_mask40, nsw_sshr43_mask43, nuw_mask43_19, nuw_mask43_shr43, nsw_top,
      nsw_sel19_mask43, Vector.getElem_set, lanesFrom_getElem] with transparent $x:ident)

set_option hygiene false in
/-- `enc_step`, its value named `x`. -/
local macro "enc_step_with " x:ident : tactic =>
  `(tactic|
    step_pure [zipWith_eq_ofFn, expandOfFn, lanesBelow_getElem, sshiftRight40_smulOverflow,
      nsw_sshr43_mask40, nsw_sshr43_mask43, nuw_mask43_19, nuw_mask43_shr43, nsw_top,
      nsw_sel19_mask43, Vector.getElem_set, lanesFrom_getElem] with $x:ident)

namespace fd_r43x6_ge_encode

open _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_encode

-- `bv_decide` over the reductions and the packing
set_option maxHeartbeats 0 in
/-- The tail's values, as compiled, are `encPack X Y`. -/
theorem tail_compiled {X Y : Wwl} {c5 e5 l0 t0 l1 t1 l2 t2 l3 t3 l4 t4 u0 u1 u2 u3 u4 w5 hand hor :
      Vector (BitVec 64) 2}
    {q : Vector (BitVec 1) 2} {qx qy : BitVec 1}
    {t0x u0x xb a0 a1 a2 a3 a4 a5 z0 z1 z2 z3 z4 z5 xs xm : BitVec 64}
    {o res : Vector (BitVec 64) 4}
    (hc5 : c5 = #v[Y[5], X[5]])
    (he5 : e5 = #v[c5[0].sshiftRight 40 * 19#64, c5[1].sshiftRight 40 * 19#64])
    (hl0 : l0 = #v[Y[0], X[0]])
    (ht0 : t0 = #v[e5[0] + l0[0], e5[1] + l0[1]])
    (hl1 : l1 = #v[Y[1], X[1]])
    (ht1 : t1 = #v[t0[0].sshiftRight 43 + l1[0], t0[1].sshiftRight 43 + l1[1]])
    (hl2 : l2 = #v[Y[2], X[2]])
    (ht2 : t2 = #v[t1[0].sshiftRight 43 + l2[0], t1[1].sshiftRight 43 + l2[1]])
    (hl3 : l3 = #v[Y[3], X[3]])
    (ht3 : t3 = #v[t2[0].sshiftRight 43 + l3[0], t2[1].sshiftRight 43 + l3[1]])
    (hl4 : l4 = #v[Y[4], X[4]])
    (ht4 : t4 = #v[t3[0].sshiftRight 43 + l4[0], t3[1].sshiftRight 43 + l4[1]])
    (hu0 : u0 = #v[(t0[0] &&& 8796093022207#64) + 19#64, (t0[1] &&& 8796093022207#64) + 19#64])
    (hu1 :
      u1 =
        #v[(t1[0] &&& 8796093022207#64) + u0[0] >>> 43,
          (t1[1] &&& 8796093022207#64) + u0[1] >>> 43])
    (hu2 :
      u2 =
        #v[(t2[0] &&& 8796093022207#64) + u1[0] >>> 43,
          (t2[1] &&& 8796093022207#64) + u1[1] >>> 43])
    (hu3 :
      u3 =
        #v[(t3[0] &&& 8796093022207#64) + u2[0] >>> 43,
          (t3[1] &&& 8796093022207#64) + u2[1] >>> 43])
    (hu4 :
      u4 =
        #v[(t4[0] &&& 8796093022207#64) + u3[0] >>> 43,
          (t4[1] &&& 8796093022207#64) + u3[1] >>> 43])
    (hw5 :
      w5 =
        #v[t4[0].sshiftRight 43 + (c5[0] &&& 1099511627775#64) + u4[0] >>> 43,
          t4[1].sshiftRight 43 + (c5[1] &&& 1099511627775#64) + u4[1] >>> 43])
    (hq :
      q =
        #v[BitVec.ofBool (w5[0].slt 1099511627776#64), BitVec.ofBool (w5[1].slt 1099511627776#64)])
    (hqx : qx = q[1])
    (ht0x : t0x = t0[1])
    (hu0x : u0x = u0[1])
    (hxb : xb = if qx = 1#1 then t0x else u0x)
    (ha0 : a0 = u0[0])
    (ha1 : a1 = u1[0])
    (ha2 : a2 = u2[0])
    (ha3 : a3 = u3[0])
    (ha4 : a4 = u4[0])
    (ha5 : a5 = w5[0])
    (hqy : qy = q[0])
    (hz0 : z0 = (if qy = 1#1 then 18446744073709551597#64 else 0#64) + (a0 &&& 8796093022207#64))
    (hz1 : z1 = z0.sshiftRight 43 + (a1 &&& 8796093022207#64))
    (hz2 : z2 = z1.sshiftRight 43 + (a2 &&& 8796093022207#64))
    (hz3 : z3 = z2.sshiftRight 43 + (a3 &&& 8796093022207#64))
    (hz4 : z4 = z3.sshiftRight 43 + (a4 &&& 8796093022207#64))
    (hz5 : z5 = z4.sshiftRight 43 + (a5 &&& 1099511627775#64))
    (ho :
      o =
        #v[z0 &&& 8796093022207#64, z1 &&& 8796093022207#64, z2 &&& 8796093022207#64,
          z3 &&& 8796093022207#64])
    (hxs : xs = xb <<< 40)
    (hxm : xm = xs &&& 1099511627776#64)
    (hhand : hand = #v[z4 &&& 8796093022207#64, z5 &&& xm])
    (hhor : hor = #v[z4 ||| 8796093022207#64, z5 ||| xm])
    (hres :
      res =
        #v[o[0] ||| o[1] <<< 43 ||| o[1] <<< 43, o[1] >>> 21 ||| o[2] <<< 22 ||| o[2] <<< 22,
          o[2] >>> 42 ||| o[3] <<< 1 ||| hand[0] <<< 44,
          hand[0] >>> 20 ||| hor[1] <<< 23 ||| hor[1] <<< 23]) :
    res = encPack X Y := by
  subst_vars
  ext i hi : 1
  obtain _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | simp only [encPack, encLimbs, modNearlyC, packWv, biasedCarryPropagateLimbs, extractLimbs,
        carryLimbs, carrySums, m43, m40, Vector.getElem_mk, List.getElem_toArray,
        List.getElem_cons_zero, List.getElem_cons_succ]
      simp only [reduceGetElemLit]
      bv_decide (config := { timeout := 120 })

/-- The entry block's constants its tail reads. -/
abbrev TailConsts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%7 := Vector.replicate 2 .poison, %8 := .value 1099511627776#64, %9 := .value 40#64,
    %10 := Ty.wrap (Vector.replicate 4 8796093022207#64), %11 := .value 3#64, %12 := .value 2#64,
    %13 := Vector.replicate 4 .poison, %14 := .value 43#64, %15 := .value 18446744073709551597#64,
    %16 := .value 1099511627775#64, %17 := .value 8796093022207#64,
    %18 := Ty.wrap (Vector.replicate 2 1099511627776#64),
    %19 := Ty.wrap (Vector.replicate 2 8796093022207#64), %20 := Ty.wrap (Vector.replicate 2 43#64),
    %21 := Ty.wrap (Vector.replicate 2 1099511627775#64), %22 := Ty.wrap (Vector.replicate 2 19#64),
    %23 := Ty.wrap (Vector.replicate 2 40#64), %33 := .value 0#64, %34 := .value 1#64,
    %35 := Vector.replicate 8 .poison, %56 := lanesFrom 6 wwl_zero,
    %122 := #v[.value 8796093022207#64, .poison],
    %130 := #v[.value 0#64, .value 21#64, .value 42#64, .poison, .value 20#64, .poison, .poison,
      .poison],
    %138 := #v[.value 0#64, .value 43#64, .value 22#64, .value 1#64, .poison, .value 23#64, .poison,
      .poison],
    %146 := #v[.value 0#64, .value 43#64, .value 22#64, .poison, .value 44#64, .value 23#64,
      .poison, .poison]]

-- ninety steps of scalar and two-lane code in one block
set_option maxHeartbeats 1000000 in
/-- The entry block from `%245`: the scalar carries and reductions of `y` and `x` in two lanes, and
the packing. -/
theorem tail (X Y : Wwl) (S : GlobalState) {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (E : ⟪Γ⟫) (hC : TailConsts E)
    (hR : E ⊨ [%197 := low6 X, %244 := low6 Y])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.read (%334) = Ty.wrap (encPack X Y) →
        (entry.runBodyFrom E' 335 S >>= g) = K) :
    (entry.runBodyFrom E 245 S >>= g) = K := by
  split_reads hC hR
  enc_step_with c5
  enc_step_tr d5
  enc_step_with e5
  enc_step_tr m5
  enc_step_with l0
  enc_step_with t0
  enc_step_tr h0
  enc_step_tr k0
  enc_step_with l1
  enc_step_with t1
  enc_step_tr h1
  enc_step_tr k1
  enc_step_with l2
  enc_step_with t2
  enc_step_tr h2
  enc_step_tr k2
  enc_step_with l3
  enc_step_with t3
  enc_step_tr h3
  enc_step_tr k3
  enc_step_with l4
  enc_step_with t4
  enc_step_tr h4
  enc_step_tr k4
  enc_step_tr n5
  -- fd_r43x6_mod_nearly_reduced_limbs( x, x ), y likewise
  enc_step_with u0
  enc_step_tr v0
  enc_step_with u1
  enc_step_tr v1
  enc_step_with u2
  enc_step_tr v2
  enc_step_with u3
  enc_step_tr v3
  enc_step_with u4
  enc_step_tr v4
  enc_step_with w5
  enc_step_with q
  enc_step_with qx
  enc_step_with t0x
  enc_step_with u0x
  enc_step_with xb
  enc_step_with a0
  enc_step_tr r0
  enc_step_with a1
  enc_step_tr r1
  enc_step_with a2
  enc_step_tr r2
  enc_step_with a3
  enc_step_tr r3
  enc_step_with a4
  enc_step_tr r4
  enc_step_with a5
  enc_step_tr r5
  enc_step_with qy
  enc_step_tr sel
  enc_step_with z0
  enc_step_tr g0
  enc_step_with z1
  enc_step_tr g1
  enc_step_with z2
  enc_step_tr g2
  enc_step_with z3
  enc_step_tr g3
  iterate 4 enc_step
  enc_step_with o
  enc_step_with xs
  enc_step_with xm
  enc_step_with z4
  enc_step_tr g4
  enc_step_with z5
  step_pure with transparent i0
  step_pure with transparent hi
  step_pure with transparent xv
  enc_step_with hand
  enc_step_with hor
  enc_step_tr lo4
  enc_step_tr lo6
  enc_step_tr hi2
  enc_step_tr w
  enc_step_tr t0s
  enc_step_tr t1s
  enc_step_tr t2s
  enc_step_tr u0s
  enc_step_tr u1s
  enc_step_tr o1
  enc_step_tr u2s
  enc_step_with res
  have e := tail_compiled hc5 he5 hl0 ht0 hl1 ht1 hl2 ht2 hl3 ht3 hl4 ht4 hu0 hu1 hu2 hu3 hu4 hw5
    hq hqx ht0x hu0x hxb ha0 ha1 ha2 ha3 ha4 ha5 hqy hz0 hz1 hz2 hz3 hz4 hz5 ho hxs hxm hhand hhor
    hres
  subst e
  exact hK E (by env_reads)

end fd_r43x6_ge_encode

/-- `fd_r43x6_ge_encode` returns `spec` of the point `P`. -/
public theorem fd_r43x6_ge_encode.call_eq (P : Quad) (s : GlobalState) (hwf : s.WF) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_encode.call
        (_root_.Firedancer.Lane.Mlir.fd_r43x6_ge_encode.args (Ty.wrap P.P03) (Ty.wrap P.P14)
          (Ty.wrap P.P25))
        s =
      .value (.cons (Ty.wrap (fd_r43x6_ge_encode.spec P)) .nil, s) := by
  func_init
  block_init
  iterate 41 step_pure
  iterate 10 step_pattern using runBodyFrom_insertRun
  iterate 2 step_pure
  iterate 3 step_pattern using runBodyFrom_insertRun
  -- FD_R43X6_QUAD_UNPACK( X,Y,Z,T, P ), one_Z = fd_r43x6_invert( Z )
  step_pure
  step_pure
  step_pure with z
  replace hz : z = P.Z := hz
  subst hz
  step_call using _root_.Firedancer.Lane.Mlir.fd_r43x6_invert.call_eq
  -- x = fd_r43x6_mul_fast( X, one_Z ), y likewise
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  step_pure with x5
  replace hx0 : x0 = Vector.replicate 8 P.X[0] := by rw [hx0]; rfl
  replace hx1 : x1 = Vector.replicate 8 P.X[1] := by rw [hx1]; rfl
  replace hx2 : x2 = Vector.replicate 8 P.X[2] := by rw [hx2]; rfl
  replace hx3 : x3 = Vector.replicate 8 P.X[3] := by rw [hx3]; rfl
  replace hx4 : x4 = Vector.replicate 8 P.X[4] := by rw [hx4]; rfl
  replace hx5 : x5 = Vector.replicate 8 P.X[5] := by rw [hx5]; rfl
  step_pattern using runBodyFrom_mulFastRowsRun P.X with x
  step_pure with y0
  step_pure with y1
  step_pure with y2
  step_pure with y3
  step_pure with y4
  step_pure with y5
  replace hy0 : y0 = Vector.replicate 8 P.Y[0] := by rw [hy0]; rfl
  replace hy1 : y1 = Vector.replicate 8 P.Y[1] := by rw [hy1]; rfl
  replace hy2 : y2 = Vector.replicate 8 P.Y[2] := by rw [hy2]; rfl
  replace hy3 : y3 = Vector.replicate 8 P.Y[3] := by rw [hy3]; rfl
  replace hy4 : y4 = Vector.replicate 8 P.Y[4] := by rw [hy4]; rfl
  replace hy5 : y5 = Vector.replicate 8 P.Y[5] := by rw [hy5]; rfl
  step_pattern using runBodyFrom_mulFastRowsRun P.Y with y
  subst hx hy
  replace hv56 : v56 = lanesFrom 6 wwl_zero := by rw [hv56]; rfl
  subst hv56 hv130 hv138 hv146
  refine fd_r43x6_ge_encode.tail _ _ S E (by env_reads) (by env_reads) fun E' h334 => ?_
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Lane

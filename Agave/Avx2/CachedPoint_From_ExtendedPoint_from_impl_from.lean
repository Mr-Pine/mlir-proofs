module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Common.Simd
public import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64
public import Agave.Avx2.Mlir.CachedPoint_From_ExtendedPoint_from_impl_from
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open Fe2625x4

/-! ## Specification -/

@[expose] public section

/-- `x * (s₀, s₁, s₂, s₃)`: each limb times its element's scalar (`mul32` of the `unpack_pair`
halves, the scalars as `u64x4` lanes `c`), then `reduce64`. -/
def mulScalars (x : Fe2625x4) (c : Vector (BitVec 64) 4) : Fe2625x4 :=
  FieldElement2625x4_reduce64_impl_reduce64.spec
    ![vmul (unpackLo (x 0)) c, vmul (unpackHi (x 0)) c, vmul (unpackLo (x 1)) c,
      vmul (unpackHi (x 1)) c, vmul (unpackLo (x 2)) c, vmul (unpackHi (x 2)) c,
      vmul (unpackLo (x 3)) c, vmul (unpackHi (x 3)) c, vmul (unpackLo (x 4)) c,
      vmul (unpackHi (x 4)) c]

/-- `CachedPoint::from(P)`: `(Y - X, Y + X, Z, T)` by `diff_sum`, times
`(121666, 121666, 2 · 121666, 2 · 121665)`, `D` negated. -/
def CachedPoint_From_ExtendedPoint_from_impl_from.spec (P : Fe2625x4) : Fe2625x4 :=
  let x := blend P (diffSum P) Lanes.AB
  let x := mulScalars x #v[121666, 121666, 2 * 121666, 2 * 121665]
  blend x (neg x) Lanes.D

end

/-! ## Proof -/

section Proof

/-- Register 0 of `x.blend(-x, Lanes::D)` as the code computes it: `n = 16p - y`, `n4` register 4's;
lane `D` alone reduced, `c9 · 19` in 64 bits. -/
def negDReg0 (y n n4 : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[y[0], y[1], y[2], y[3], y[4],
    (n[5] &&& 67108863#32) + BitVec.extractLsb' 0 32 ((0#32 ++ (n4[7] >>> 25 &&& 127#32)) * 19#64),
    y[6],
    n[5] >>> 26 + (n[7] &&& 33554431#32) +
      BitVec.extractLsb' 32 32 ((0#32 ++ (n4[7] >>> 25 &&& 127#32)) * 19#64)]

/-- Register `i > 0` of `x.blend(-x, Lanes::D)` as the code computes it, `m` register `i - 1`'s
`16p - y`. -/
def negDReg (y n m : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[y[0], y[1], y[2], y[3], y[4], m[7] >>> 25 + (n[5] &&& 67108863#32), y[6],
    n[5] >>> 26 + (n[7] &&& 33554431#32)]

theorem blendD_reg0 (y n n4 : Vector (BitVec 32) 8) :
    blendLanes y (reduceReg n fun e => carries n4 e * 19) Lanes.D = negDReg0 y n n4 := by
  simp only [blendLanes, reduceReg, carries, negDReg0, Lanes.D]
  simp
  simp only [reduceGetElemLit]
  constructor <;> bv_decide

theorem blendD_reg (y n m : Vector (BitVec 32) 8) :
    blendLanes y (reduceReg n (carries m)) Lanes.D = negDReg y n m := by
  simp only [blendLanes, reduceReg, carries, negDReg, Lanes.D]
  simp [BitVec.add_comm]

theorem negD_eq (y : Fe2625x4) :
    blend y (neg y) Lanes.D =
      ![negDReg0 (y 0) (subLanes p16Lo (y 0)) (subLanes p16Hi (y 4)),
        negDReg (y 1) (subLanes p16Hi (y 1)) (subLanes p16Lo (y 0)),
        negDReg (y 2) (subLanes p16Hi (y 2)) (subLanes p16Hi (y 1)),
        negDReg (y 3) (subLanes p16Hi (y 3)) (subLanes p16Hi (y 2)),
        negDReg (y 4) (subLanes p16Hi (y 4)) (subLanes p16Hi (y 3))] := by
  funext i
  fin_cases i
  · exact blendD_reg0 _ _ _
  all_goals exact blendD_reg _ _ _

attribute [local simp] carry25_add_ok carry26_add_ok zero_add_ok c9_mul_ok c9_add_ok c9_hi_add_ok

/-- A lane below `2 ^ 32` times a scalar below `2 ^ 18` overflows neither way. -/
theorem mulScalar_ok {x : BitVec 64} (h : x.toNat < 2 ^ 32) {k : BitVec 64}
    (hk : k = 121666#64 ∨ k = 243332#64 ∨ k = 243330#64) :
    x.smulOverflow k = false ∧ x.umulOverflow k = false := by
  have : x < 4294967296#64 := by
    rw [BitVec.lt_def]; simpa using h
  rcases hk with rfl | rfl | rfl <;> bv_decide

/-- `mul nsw nuw` by `(121666, 121666, 2 · 121666, 2 · 121665)` of lanes below `2 ^ 32`. -/
theorem zipWith_mulScalars_small {x : Vector (BitVec 64) 4} (hx : Small x) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) #v[121666#64, 121666#64, 243332#64, 243330#64]) =
      Ty.wrap (t := .vec 4 64) (vmul x #v[121666#64, 121666#64, 243332#64, 243330#64]) :=
  zipWith_mul_nsw_nuw _ _ fun i => by
    refine mulScalar_ok (hx i.1 i.2) ?_
    obtain ⟨i, hi⟩ := i
    obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
    all_goals simp

set_option maxHeartbeats 4000000 in
attribute [-mlir_operation] zipWith_eq_ofFn in
/-- `CachedPoint::from(P)` stores `spec P` at `out`; `P` is read first, so `out` may alias it. -/
public theorem CachedPoint_From_ExtendedPoint_from_impl_from.call_eq (out x : Pointer)
    (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out) (hx : s.mem.Fe4xFit x) :
    CachedPoint_From_ExtendedPoint_from_impl_from.call
        (CachedPoint_From_ExtendedPoint_from_impl_from.args (.value out) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeFe4x out
                (CachedPoint_From_ExtendedPoint_from_impl_from.spec (s.mem.readFe4x x)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hxoff, hxf0, hxf1, hxf2, hxf3, hxf4⟩ := hx
  block_init
  iterate 77 step_pure
  step_alloca
  step_alloca
  step_load with a0
  step_pure
  step_load with a1
  step_pure
  step_load with a2
  step_pure
  step_load with a3
  step_pure
  step_load with a4
  iterate 5 step_pure
  iterate 5 step_pure [expandZipWith]
  iterate 5 step_pure
  iterate 5 step_pure [expandZipWith]
  -- x = x.blend(x.diff_sum(), Lanes::AB);
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  step_pure
  -- x = x * (121666, 121666, 2 * 121666, 2 * 121665);
  iterate 2 step_pure
  step_pure with b0
  step_pure with b1
  iterate 2 step_pure
  step_pure with b2
  step_pure with b3
  iterate 2 step_pure
  step_pure with b4
  step_pure with b5
  iterate 2 step_pure
  step_pure with b6
  step_pure with b7
  iterate 2 step_pure
  step_pure with b8
  step_pure with b9
  step_pure
  step_pure [zipWith_mulScalars_small (Small.zext hb0)] with m0
  step_pure [zipWith_mulScalars_small (Small.zext hb1)] with m1
  step_pure [zipWith_mulScalars_small (Small.zext hb2)] with m2
  step_pure [zipWith_mulScalars_small (Small.zext hb3)] with m3
  step_pure [zipWith_mulScalars_small (Small.zext hb4)] with m4
  step_pure [zipWith_mulScalars_small (Small.zext hb5)] with m5
  step_pure [zipWith_mulScalars_small (Small.zext hb6)] with m6
  step_pure [zipWith_mulScalars_small (Small.zext hb7)] with m7
  step_pure [zipWith_mulScalars_small (Small.zext hb8)] with m8
  step_pure [zipWith_mulScalars_small (Small.zext hb9)] with m9
  step_store
  iterate 9 
    step_pure
    step_store
  rw [MemoryState.storeZ10_eq] at hS
  have hv78_fe4 := MemoryState.Fe4xRoom.of_room hroom_v78 (by simp [hv78_off])
  step_call using
    (FieldElement2625x4_reduce64_impl_reduce64.call_eq (hout := hv78_fe4) (hz :=
      ⟨by
        rw [hv77_off]; decide, hfits_v77, hfits_v77_32, hfits_v77_64, hfits_v77_96, hfits_v77_128,
        hfits_v77_160, hfits_v77_192, hfits_v77_224, hfits_v77_256, hfits_v77_288⟩))
  name_fe4 y
  obtain ⟨-, hyf0, hyf1, hyf2, hyf3, hyf4⟩ := hv78_fe4
  step_pure
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
  -- x = x.blend(-x, Lanes::D);
  step_pure [expandZipWith] with n0
  step_pure [expandZipWith] with n1
  step_pure [expandZipWith] with n2
  step_pure [expandZipWith] with n3
  step_pure [expandZipWith] with n4
  step_pure [expandZipWith]
  step_pure
  step_pure
  step_pure [expandZipWith]
  step_pure [expandZipWith]
  iterate 4 
    step_pure [expandZipWith]
    step_pure
    step_pure [expandZipWith]
    step_pure [expandZipWith]
  step_pure [expandZipWith]
  step_pure
  step_pure
  step_pure [expandZipWith]
  step_pure
  step_pure
  step_pure [expandZipWith]
  step_pure with r0
  step_pure with r1
  step_pure with r2
  step_pure with r3
  step_pure with r4
  step_store
  iterate 4 
    step_pure
    step_store
  finish_block
  rw [MemoryState.storeFe4x_eq] at hS
  simp only [MemoryState.readAt_alloca_alloca hwf₀ hx₀_1.inBounds,
    MemoryState.readAt_alloca_alloca hwf₀ hx₀_2.inBounds,
    MemoryState.readAt_alloca_alloca hwf₀ hx₀_3.inBounds,
    MemoryState.readAt_alloca_alloca hwf₀ hx₀_4.inBounds] at ha1 ha2 ha3 ha4
  change a0 = S₀.mem.readFe4x x 0 at ha0
  change a1 = S₀.mem.readFe4x x 1 at ha1
  change a2 = S₀.mem.readFe4x x 2 at ha2
  change a3 = S₀.mem.readFe4x x 3 at ha3
  change a4 = S₀.mem.readFe4x x 4 at ha4
  change x0 = dsReg a0 134217690 67108862 at hx0
  change x1 = dsReg a1 134217726 67108862 at hx1
  change x2 = dsReg a2 134217726 67108862 at hx2
  change x3 = dsReg a3 134217726 67108862 at hx3
  change x4 = dsReg a4 134217726 67108862 at hx4
  change b0 = unpackLo x0 at hb0
  change b1 = unpackHi x0 at hb1
  change b2 = unpackLo x1 at hb2
  change b3 = unpackHi x1 at hb3
  change b4 = unpackLo x2 at hb4
  change b5 = unpackHi x2 at hb5
  change b6 = unpackLo x3 at hb6
  change b7 = unpackHi x3 at hb7
  change b8 = unpackLo x4 at hb8
  change b9 = unpackHi x4 at hb9
  rw [← hy] at hy0 hy1 hy2 hy3 hy4
  change n0 = subLanes p16Lo y0 at hn0
  change n1 = subLanes p16Hi y1 at hn1
  change n2 = subLanes p16Hi y2 at hn2
  change n3 = subLanes p16Hi y3 at hn3
  change n4 = subLanes p16Hi y4 at hn4
  change r0 = negDReg0 y0 n0 n4 at hr0
  change r1 = negDReg y1 n1 n0 at hr1
  change r2 = negDReg y2 n2 n1 at hr2
  change r3 = negDReg y3 n3 n2 at hr3
  change r4 = negDReg y4 n4 n3 at hr4
  subst hr0 hr1 hr2 hr3 hr4 hn0 hn1 hn2 hn3 hn4 hy0 hy1 hy2 hy3 hy4
  rw [← negD_eq y] at hS
  subst hS
  erase_frame
  subst hy hm0 hm1 hm2 hm3 hm4 hm5 hm6 hm7 hm8 hm9 hb0 hb1 hb2 hb3 hb4 hb5 hb6 hb7 hb8 hb9
  have hX := ds_eq (S₀.mem.readFe4x x)
  subst hx0 hx1 hx2 hx3 hx4 ha0 ha1 ha2 ha3 ha4
  rw [CachedPoint_From_ExtendedPoint_from_impl_from.spec, hX]
  rfl

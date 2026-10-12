module

public import MLIR.Run.Tactic
public import Agave.Common.Simd
public import Agave.Common.Fe2625x4
public import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64
public import Agave.Avx2.Mlir.FieldElement2625x4_Mul_mul_impl_mul

namespace MLIR.Agave.Avx2

/-! ## Specification -/

@[expose] public section

/-- `&x * &y`, named as in the Rust: the limbs `x0 … x9`, `y0 … y9` of `unpack_pair`, the odd
`x` limbs doubled (`twice`), `y1_19 … y9_19` (`m_lo(v19, y)`: the products' low 32 bits), the
column sums `z0 … z9` (`sum10` of the `m(x, y)`, in the code's order), then `reduce64`. -/
def FieldElement2625x4_Mul_mul_impl_mul.spec (x y : Fe2625x4) : Fe2625x4 :=
  let x0 := unpackLo (x 0)
  let x1 := unpackHi (x 0)
  let x2 := unpackLo (x 1)
  let x3 := unpackHi (x 1)
  let x4 := unpackLo (x 2)
  let x5 := unpackHi (x 2)
  let x6 := unpackLo (x 3)
  let x7 := unpackHi (x 3)
  let x8 := unpackLo (x 4)
  let x9 := unpackHi (x 4)
  let y0 := unpackLo (y 0)
  let y1 := unpackHi (y 0)
  let y2 := unpackLo (y 1)
  let y3 := unpackHi (y 1)
  let y4 := unpackLo (y 2)
  let y5 := unpackHi (y 2)
  let y6 := unpackLo (y 3)
  let y7 := unpackHi (y 3)
  let y8 := unpackLo (y 4)
  let y9 := unpackHi (y 4)
  let x1_2 := unpackHi2 (x 0)
  let x3_2 := unpackHi2 (x 1)
  let x5_2 := unpackHi2 (x 2)
  let x7_2 := unpackHi2 (x 3)
  let x9_2 := unpackHi2 (x 4)
  let y1_19 := vand (vmul y1 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y2_19 := vand (vmul y2 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y3_19 := vand (vmul y3 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y4_19 := vand (vmul y4 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y5_19 := vand (vmul y5 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y6_19 := vand (vmul y6 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y7_19 := vand (vmul y7 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y8_19 := vand (vmul y8 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let y9_19 := vand (vmul y9 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let z0 :=
    vsum (vmul y1_19 x9_2)
      [vmul y0 x0, vmul y2_19 x8, vmul y3_19 x7_2, vmul y4_19 x6, vmul y5_19 x5_2, vmul y6_19 x4,
        vmul y7_19 x3_2, vmul y8_19 x2, vmul y9_19 x1_2]
  let z1 :=
    vsum (vmul y0 x1)
      [vmul y1 x0, vmul y3_19 x8, vmul y2_19 x9, vmul y5_19 x6, vmul y4_19 x7, vmul y7_19 x4,
        vmul y6_19 x5, vmul y9_19 x2, vmul y8_19 x3]
  let z2 :=
    vsum (vmul y0 x2)
      [vmul y1 x1_2, vmul y2 x0, vmul y3_19 x9_2, vmul y4_19 x8, vmul y5_19 x7_2, vmul y6_19 x6,
        vmul y7_19 x5_2, vmul y8_19 x4, vmul y9_19 x3_2]
  let z3 :=
    vsum (vmul y0 x3)
      [vmul y1 x2, vmul y3 x0, vmul y2 x1, vmul y5_19 x8, vmul y4_19 x9, vmul y7_19 x6,
        vmul y6_19 x7, vmul y9_19 x4, vmul y8_19 x5]
  let z4 :=
    vsum (vmul y0 x4)
      [vmul y1 x3_2, vmul y2 x2, vmul y3 x1_2, vmul y4 x0, vmul y5_19 x9_2, vmul y6_19 x8,
        vmul y7_19 x7_2, vmul y8_19 x6, vmul y9_19 x5_2]
  let z5 :=
    vsum (vmul y0 x5)
      [vmul y1 x4, vmul y3 x2, vmul y2 x3, vmul y5 x0, vmul y4 x1, vmul y7_19 x8, vmul y6_19 x9,
        vmul y9_19 x6, vmul y8_19 x7]
  let z6 :=
    vsum (vmul y0 x6)
      [vmul y1 x5_2, vmul y3 x3_2, vmul y2 x4, vmul y4 x2, vmul y5 x1_2, vmul y6 x0,
        vmul y7_19 x9_2, vmul y8_19 x8, vmul y9_19 x7_2]
  let z7 :=
    vsum (vmul y0 x7)
      [vmul y1 x6, vmul y3 x4, vmul y2 x5, vmul y5 x2, vmul y4 x3, vmul y7 x0, vmul y6 x1,
        vmul y9_19 x8, vmul y8_19 x9]
  let z8 :=
    vsum (vmul y1 x7_2)
      [vmul y0 x8, vmul y2 x6, vmul y3 x5_2, vmul y4 x4, vmul y5 x3_2, vmul y6 x2, vmul y7 x1_2,
        vmul y8 x0, vmul y9_19 x9_2]
  let z9 :=
    vsum (vmul y0 x9)
      [vmul y1 x8, vmul y3 x6, vmul y2 x7, vmul y5 x4, vmul y4 x5, vmul y7 x2, vmul y6 x3,
        vmul y9 x0, vmul y8 x1]
  FieldElement2625x4_reduce64_impl_reduce64.spec ![z0, z1, z2, z3, z4, z5, z6, z7, z8, z9]

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_add_vadd zipWith_and_vand zipWith_shl_vshl

-- 329 steps in one block and a call: past the default heartbeats
set_option maxHeartbeats 4000000 in
/-- `&x * &y` stores `spec x y` at `out`. The loads all come before the stores, so `out` may alias
`x` or `y`; the `nuw`/`nsw` flags never fire. -/
public theorem FieldElement2625x4_Mul_mul_impl_mul.call_eq (out x y : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.Fe4Room out) (hx : s.mem.Fe4Fit x) (hy : s.mem.Fe4Fit y) :
    FieldElement2625x4_Mul_mul_impl_mul.call
        (FieldElement2625x4_Mul_mul_impl_mul.args (.value out) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeFe4 out
                (FieldElement2625x4_Mul_mul_impl_mul.spec (s.mem.readFe4 x)
                  (s.mem.readFe4 y)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hxoff, hxf0, hxf1, hxf2, hxf3, hxf4⟩ := hx
  obtain ⟨hyoff, hyf0, hyf1, hyf2, hyf3, hyf4⟩ := hy
  block_init
  iterate 29 step_pure
  step_alloca
  step_load with a0
  iterate 2 step_pure
  step_pure with x0
  step_pure with x1
  step_pure
  step_load with a1
  iterate 2 step_pure
  step_pure with x2
  step_pure with x3
  step_pure
  step_load with a2
  iterate 2 step_pure
  step_pure with x4
  step_pure with x5
  step_pure
  step_load with a3
  iterate 2 step_pure
  step_pure with x6
  step_pure with x7
  step_pure
  step_load with a4
  iterate 2 step_pure
  step_pure with x8
  step_pure with x9
  step_load with b0
  iterate 2 step_pure
  step_pure with y0
  step_pure with y1
  step_pure
  step_load with b1
  iterate 2 step_pure
  step_pure with y2
  step_pure with y3
  step_pure
  step_load with b2
  iterate 2 step_pure
  step_pure with y4
  step_pure with y5
  step_pure
  step_load with b3
  iterate 2 step_pure
  step_pure with y6
  step_pure with y7
  step_pure
  step_load with b4
  iterate 2 step_pure
  step_pure with y8
  step_pure with y9
  step_pure [zipWith_mul19_small (Small.zext hy1)]
  step_pure [zipWith_mul19_small (Small.zext hy2)]
  step_pure [zipWith_mul19_small (Small.zext hy3)]
  step_pure [zipWith_mul19_small (Small.zext hy4)]
  step_pure [zipWith_mul19_small (Small.zext hy5)]
  step_pure [zipWith_mul19_small (Small.zext hy6)]
  step_pure [zipWith_mul19_small (Small.zext hy7)]
  step_pure [zipWith_mul19_small (Small.zext hy8)]
  step_pure [zipWith_mul19_small (Small.zext hy9)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx0)]
  step_pure
  step_pure [vshl_getElem] with x1_2
  step_pure with y9_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx1_2)]
  step_pure with y8_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx2)]
  step_pure
  step_pure [vshl_getElem] with x3_2
  step_pure with y7_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx3_2)]
  step_pure with y6_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx4)]
  step_pure
  step_pure [vshl_getElem] with x5_2
  step_pure with y5_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy5_19) (Small.zext hx5_2)]
  step_pure with y4_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy4_19) (Small.zext hx6)]
  step_pure
  step_pure [vshl_getElem] with x7_2
  step_pure with y3_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy3_19) (Small.zext hx7_2)]
  step_pure with y2_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy2_19) (Small.zext hx8)]
  step_pure
  step_pure [vshl_getElem] with x9_2
  step_pure with y1_19
  step_pure [zipWith_mul_nuw_small (Small.mask hy1_19) (Small.zext hx9_2)]
  iterate 8 step_pure
  step_pure with z0
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx5)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy5_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy4_19) (Small.zext hx7)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy3_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy2_19) (Small.zext hx9)]
  iterate 8 step_pure
  step_pure with z1
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy5_19) (Small.zext hx7_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy4_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy3_19) (Small.zext hx9_2)]
  iterate 8 step_pure
  step_pure with z2
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx5)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx7)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy5_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy4_19) (Small.zext hx9)]
  iterate 8 step_pure
  step_pure with z3
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx7_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy5_19) (Small.zext hx9_2)]
  iterate 8 step_pure
  step_pure with z4
  step_pure [zipWith_mul_nuw_small (Small.zext hy5) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx5)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx7)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy6_19) (Small.zext hx9)]
  iterate 8 step_pure
  step_pure with z5
  step_pure [zipWith_mul_nuw_small (Small.zext hy6) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy5) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx7_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy7_19) (Small.zext hx9_2)]
  iterate 8 step_pure
  step_pure with z6
  step_pure [zipWith_mul_nuw_small (Small.zext hy7) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy6) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy5) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx5)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx7)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy8_19) (Small.zext hx9)]
  iterate 8 step_pure
  step_pure with z7
  step_pure [zipWith_mul_nuw_small (Small.zext hy8) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy7) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy6) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy5) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx7_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hy9_19) (Small.zext hx9_2)]
  iterate 8 step_pure
  step_pure with z8
  step_pure [zipWith_mul_nuw_small (Small.zext hy9) (Small.zext hx0)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy8) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy7) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy6) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy5) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy4) (Small.zext hx5)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy3) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy2) (Small.zext hx7)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy1) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.zext hy0) (Small.zext hx9)]
  iterate 8 step_pure
  step_pure with z9
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  rw [MemoryState.storeZ10_eq] at hS
  step_call using
    (FieldElement2625x4_reduce64_impl_reduce64.call_eq (hout := ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩)
      (hz :=
      ⟨by
        rw [hv29_off]; decide, hfits_v29, hfits_v29_32, hfits_v29_64, hfits_v29_96, hfits_v29_128,
        hfits_v29_160, hfits_v29_192, hfits_v29_224, hfits_v29_256, hfits_v29_288⟩))
  step_pure
  finish_block
  -- the loads as the entry state's registers, the limbs as the spec names them
  simp only [MemoryState.readAt_alloca_of_fits hwf₀ hx₀_1.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hx₀_2.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hx₀_3.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hx₀_4.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hy₀_1.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hy₀_2.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hy₀_3.inBounds,
    MemoryState.readAt_alloca_of_fits hwf₀ hy₀_4.inBounds] at ha1 ha2 ha3 ha4 hb1 hb2 hb3 hb4
  change a0 = S₀.mem.readFe4 x 0 at ha0
  change a1 = S₀.mem.readFe4 x 1 at ha1
  change a2 = S₀.mem.readFe4 x 2 at ha2
  change a3 = S₀.mem.readFe4 x 3 at ha3
  change a4 = S₀.mem.readFe4 x 4 at ha4
  change b0 = S₀.mem.readFe4 y 0 at hb0
  change b1 = S₀.mem.readFe4 y 1 at hb1
  change b2 = S₀.mem.readFe4 y 2 at hb2
  change b3 = S₀.mem.readFe4 y 3 at hb3
  change b4 = S₀.mem.readFe4 y 4 at hb4
  change x0 = unpackLo a0 at hx0
  change x1 = unpackHi a0 at hx1
  change x2 = unpackLo a1 at hx2
  change x3 = unpackHi a1 at hx3
  change x4 = unpackLo a2 at hx4
  change x5 = unpackHi a2 at hx5
  change x6 = unpackLo a3 at hx6
  change x7 = unpackHi a3 at hx7
  change x8 = unpackLo a4 at hx8
  change x9 = unpackHi a4 at hx9
  change y0 = unpackLo b0 at hy0
  change y1 = unpackHi b0 at hy1
  change y2 = unpackLo b1 at hy2
  change y3 = unpackHi b1 at hy3
  change y4 = unpackLo b2 at hy4
  change y5 = unpackHi b2 at hy5
  change y6 = unpackLo b3 at hy6
  change y7 = unpackHi b3 at hy7
  change y8 = unpackLo b4 at hy8
  change y9 = unpackHi b4 at hy9
  change x1_2 = unpackHi2 a0 at hx1_2
  change x3_2 = unpackHi2 a1 at hx3_2
  change x5_2 = unpackHi2 a2 at hx5_2
  change x7_2 = unpackHi2 a3 at hx7_2
  change x9_2 = unpackHi2 a4 at hx9_2
  subst_vars
  erase_frame
  rfl

end Proof

end MLIR.Agave.Avx2

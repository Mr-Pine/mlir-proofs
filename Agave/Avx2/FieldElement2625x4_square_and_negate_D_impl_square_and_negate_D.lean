module

public import MLIR.Run.Tactic
public import Agave.Common.Simd
public import Agave.Common.Fe2625x4
public import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64
public import Agave.Avx2.Mlir.FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D

namespace MLIR.Agave.Avx2

/-! ## Specification -/

@[expose] public section

/-- `negate_D(x, p)`: lanes `A, B, C` of `x`, lane `D` replaced by `p - x`. -/
def negateD (x : Vector (BitVec 64) 4) (p : BitVec 64) : Vector (BitVec 64) 4 :=
  #v[x[0], x[1], x[2], p - x[3]]

/-- `x.square_and_negate_D()`, named as in the Rust: the limbs `x0 … x9` of `unpack_pair`, the
doubled `x0_2 … x7_2`, `x5_19 … x9_19` (`m_lo(v19, x)`: the products' low 32 bits), the column
sums `z0 … z9` (in the code's order; `.shl::<1>()` doubles the 19 terms), `negate_D` of each (lane
`D` subtracted from a multiple of `p`'s limb), then `reduce64`. -/
def FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec (x : Fe2625x4) :
    Fe2625x4 :=
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
  let x0_2 := unpackLo2 (x 0)
  let x1_2 := unpackHi2 (x 0)
  let x2_2 := unpackLo2 (x 1)
  let x3_2 := unpackHi2 (x 1)
  let x4_2 := unpackLo2 (x 2)
  let x5_2 := unpackHi2 (x 2)
  let x6_2 := unpackLo2 (x 3)
  let x7_2 := unpackHi2 (x 3)
  let x5_19 := vand (vmul x5 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let x6_19 := vand (vmul x6 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let x7_19 := vand (vmul x7 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let x8_19 := vand (vmul x8 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let x9_19 := vand (vmul x9 (Vector.replicate 4 19#64)) (Vector.replicate 4 4294967295#64)
  let z0 :=
    vsum (vmul x6_19 x4_2)
      [vmul x0 x0, vmul x8_19 x2_2,
        vshl (vsum (vmul x7_19 x3_2) [vmul x5_19 x5, vmul x9_19 x1_2]) 1]
  let z1 :=
    vsum (vmul x6_19 x5_2)
      [vmul x0_2 x1, vmul x8_19 x3_2, vshl (vadd (vmul x9_19 x2) (vmul x7_19 x4)) 1]
  let z2 :=
    vsum (vmul x1_2 x1)
      [vmul x2 x0_2, vmul x6_19 x6, vmul x8_19 x4_2,
        vshl (vadd (vmul x9_19 x3_2) (vmul x7_19 x5_2)) 1]
  let z3 :=
    vsum (vmul x2 x1_2)
      [vmul x3 x0_2, vmul x8_19 x5_2, vshl (vadd (vmul x9_19 x4) (vmul x7_19 x6)) 1]
  let z4 :=
    vsum (vmul x4 x0_2)
      [vmul x2 x2, vmul x3_2 x1_2, vmul x8_19 x6_2, vshl (vadd (vmul x9_19 x5_2) (vmul x7_19 x7)) 1]
  let z5 :=
    vsum (vmul x4 x1_2) [vmul x5 x0_2, vmul x2_2 x3, vmul x8_19 x7_2, vshl (vmul x9_19 x6) 1]
  let z6 :=
    vsum (vmul x3_2 x3)
      [vmul x4 x2_2, vmul x6 x0_2, vmul x5_2 x1_2, vmul x8_19 x8, vshl (vmul x9_19 x7_2) 1]
  let z7 := vsum (vmul x4 x3_2) [vmul x5 x2_2, vmul x7 x0_2, vmul x6 x1_2, vshl (vmul x9_19 x8) 1]
  let z8 :=
    vsum (vmul x6 x2_2)
      [vmul x4 x4, vmul x5_2 x3_2, vmul x8 x0_2, vmul x7_2 x1_2, vshl (vmul x9_19 x9) 1]
  let z9 := vsum (vmul x6 x3_2) [vmul x7 x2_2, vmul x4_2 x5, vmul x9 x0_2, vmul x8 x1_2]
  -- low__p37, odd__p37, even_p37: 0x3ffffed << 37, 0x1ffffff << 37, 0x3ffffff << 37
  let z0 := negateD z0 9223369425514659840#64
  let z1 := negateD z1 4611685880988434432#64
  let z2 := negateD z2 9223371899415822336#64
  let z3 := negateD z3 4611685880988434432#64
  let z4 := negateD z4 9223371899415822336#64
  let z5 := negateD z5 4611685880988434432#64
  let z6 := negateD z6 9223371899415822336#64
  let z7 := negateD z7 4611685880988434432#64
  let z8 := negateD z8 9223371899415822336#64
  let z9 := negateD z9 4611685880988434432#64
  FieldElement2625x4_reduce64_impl_reduce64.spec ![z0, z1, z2, z3, z4, z5, z6, z7, z8, z9]

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

-- `x * x` stays a `zipWith`, which `zipWith_mul_nuw_small` reads
attribute [-simp] Vector.zipWith_self

attribute [local mlir_operation] zipWith_add_vadd zipWith_and_vand zipWith_shl_vshl

-- 255 steps in one block and a call: past the default heartbeats
set_option maxHeartbeats 4000000 in
/-- `x.square_and_negate_D()` stores `spec x` at `out`. The loads all come before the stores, so
`out` may alias `x`; the `nuw`/`nsw` flags never fire. -/
public theorem FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.call_eq
    (out x : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out)
    (hx : s.mem.Fe4xFit x) :
    FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.call
        (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.args (.value out)
          (.value x))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeFe4x out
                (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec
                  (s.mem.readFe4x x)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hxoff, hxf0, hxf1, hxf2, hxf3, hxf4⟩ := hx
  block_init
  iterate 47 step_pure
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
  step_pure
  step_pure [vshl_getElem] with x0_2
  step_pure
  step_pure [vshl_getElem] with x1_2
  step_pure
  step_pure [vshl_getElem] with x2_2
  step_pure
  step_pure [vshl_getElem] with x3_2
  step_pure
  step_pure [vshl_getElem] with x4_2
  step_pure
  step_pure [vshl_getElem] with x5_2
  step_pure
  step_pure [vshl_getElem] with x6_2
  step_pure
  step_pure [vshl_getElem] with x7_2
  step_pure [zipWith_mul19_small (Small.zext hx5)]
  step_pure [zipWith_mul19_small (Small.zext hx6)]
  step_pure [zipWith_mul19_small (Small.zext hx7)]
  step_pure [zipWith_mul19_small (Small.zext hx8)]
  step_pure [zipWith_mul19_small (Small.zext hx9)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx0) (Small.zext hx0)]
  step_pure with x8_19
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx2_2)]
  step_pure with x6_19
  step_pure [zipWith_mul_nuw_small (Small.mask hx6_19) (Small.zext hx4_2)]
  step_pure with x9_19
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx1_2)]
  step_pure with x7_19
  step_pure [zipWith_mul_nuw_small (Small.mask hx7_19) (Small.zext hx3_2)]
  step_pure with x5_19
  step_pure [zipWith_mul_nuw_small (Small.mask hx5_19) (Small.zext hx5)]
  iterate 5 step_pure
  step_pure with z0
  step_pure [zipWith_mul_nuw_small (Small.zext hx0_2) (Small.zext hx1)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx6_19) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx7_19) (Small.zext hx4)]
  iterate 4 step_pure
  step_pure with z1
  step_pure [zipWith_mul_nuw_small (Small.zext hx2) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx1_2) (Small.zext hx1)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx4_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx6_19) (Small.zext hx6)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx7_19) (Small.zext hx5_2)]
  iterate 4 step_pure
  step_pure with z2
  step_pure [zipWith_mul_nuw_small (Small.zext hx3) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx2) (Small.zext hx1_2)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx5_2)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx7_19) (Small.zext hx6)]
  iterate 2 step_pure
  step_pure with z3
  step_pure [zipWith_mul_nuw_small (Small.zext hx4) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx3_2) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx2) (Small.zext hx2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx6_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx5_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx7_19) (Small.zext hx7)]
  iterate 5 step_pure
  step_pure with z4
  step_pure [zipWith_mul_nuw_small (Small.zext hx5) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx4) (Small.zext hx1_2)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.zext hx2_2) (Small.zext hx3)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx7_2)]
  step_pure
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx6)]
  step_pure
  step_pure with z5
  step_pure [zipWith_mul_nuw_small (Small.zext hx6) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx5_2) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx4) (Small.zext hx2_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx3_2) (Small.zext hx3)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx8_19) (Small.zext hx8)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx7_2)]
  iterate 5 step_pure
  step_pure with z6
  step_pure [zipWith_mul_nuw_small (Small.zext hx7) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx6) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx5) (Small.zext hx2_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx4) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx8)]
  iterate 4 step_pure
  step_pure with z7
  step_pure [zipWith_mul_nuw_small (Small.zext hx8) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx7_2) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx6) (Small.zext hx2_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx5_2) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx4) (Small.zext hx4)]
  step_pure [zipWith_mul_nuw_small (Small.mask hx9_19) (Small.zext hx9)]
  iterate 5 step_pure
  step_pure with z8
  step_pure [zipWith_mul_nuw_small (Small.zext hx9) (Small.zext hx0_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx8) (Small.zext hx1_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx7) (Small.zext hx2_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx6) (Small.zext hx3_2)]
  step_pure [zipWith_mul_nuw_small (Small.zext hx4_2) (Small.zext hx5)]
  iterate 3 step_pure
  step_pure with z9
  step_pure [expandZipWith]
  step_pure with z0'
  step_pure [expandZipWith]
  step_pure with z1'
  step_pure [expandZipWith]
  step_pure with z2'
  step_pure [expandZipWith]
  step_pure with z3'
  step_pure [expandZipWith]
  step_pure with z4'
  step_pure [expandZipWith]
  step_pure with z5'
  step_pure [expandZipWith]
  step_pure with z6'
  step_pure [expandZipWith]
  step_pure with z7'
  step_pure [expandZipWith]
  step_pure with z8'
  step_pure [expandZipWith]
  step_pure with z9'
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
        rw [hv47_off]; decide, hfits_v47, hfits_v47_32, hfits_v47_64, hfits_v47_96, hfits_v47_128,
        hfits_v47_160, hfits_v47_192, hfits_v47_224, hfits_v47_256, hfits_v47_288⟩))
  step_pure
  finish_block
  -- the loads as the entry state's registers, the limbs as the spec names them
  change a0 = S₀.mem.readFe4x x 0 at ha0
  change a1 = S₀.mem.readFe4x x 1 at ha1
  change a2 = S₀.mem.readFe4x x 2 at ha2
  change a3 = S₀.mem.readFe4x x 3 at ha3
  change a4 = S₀.mem.readFe4x x 4 at ha4
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
  change x0_2 = unpackLo2 a0 at hx0_2
  change x1_2 = unpackHi2 a0 at hx1_2
  change x2_2 = unpackLo2 a1 at hx2_2
  change x3_2 = unpackHi2 a1 at hx3_2
  change x4_2 = unpackLo2 a2 at hx4_2
  change x5_2 = unpackHi2 a2 at hx5_2
  change x6_2 = unpackLo2 a3 at hx6_2
  change x7_2 = unpackHi2 a3 at hx7_2
  change z0' = negateD z0 9223369425514659840#64 at hz0'
  change z1' = negateD z1 4611685880988434432#64 at hz1'
  change z2' = negateD z2 9223371899415822336#64 at hz2'
  change z3' = negateD z3 4611685880988434432#64 at hz3'
  change z4' = negateD z4 9223371899415822336#64 at hz4'
  change z5' = negateD z5 4611685880988434432#64 at hz5'
  change z6' = negateD z6 9223371899415822336#64 at hz6'
  change z7' = negateD z7 4611685880988434432#64 at hz7'
  change z8' = negateD z8 9223371899415822336#64 at hz8'
  change z9' = negateD z9 4611685880988434432#64 at hz9'
  subst_vars
  erase_frame
  rfl

end Proof

end MLIR.Agave.Avx2

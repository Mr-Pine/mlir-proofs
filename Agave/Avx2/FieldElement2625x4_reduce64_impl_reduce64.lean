module

public import MLIR.Run.Tactic
public import Agave.Common.Simd
public import Agave.Common.Fe2625x4
public import Agave.Avx2.Mlir.FieldElement2625x4_reduce64_impl_reduce64
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

/-! ## Specification -/

@[expose] public section

/-- `repack_pair(x, y)` of two `u64x4`s: the low 32 bits of `x`'s lanes 0, 1 and `y`'s lanes 0, 1,
then of `x`'s and `y`'s lanes 2, 3; `x`'s and-ed with `mx`, `y`'s with `my` (the carry masks, which
the code applies here). -/
def repack (x y : Vector (BitVec 64) 4) (mx my : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[x[0].extractLsb' 0 32 &&& mx, x[1].extractLsb' 0 32 &&& mx, y[0].extractLsb' 0 32 &&& my,
    y[1].extractLsb' 0 32 &&& my, x[2].extractLsb' 0 32 &&& mx, x[3].extractLsb' 0 32 &&& mx,
    y[2].extractLsb' 0 32 &&& my, y[3].extractLsb' 0 32 &&& my]

/-- `repack` with `y`'s lanes not masked. -/
def repack' (x y : Vector (BitVec 64) 4) (mx : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[x[0].extractLsb' 0 32 &&& mx, x[1].extractLsb' 0 32 &&& mx, y[0].extractLsb' 0 32,
    y[1].extractLsb' 0 32, x[2].extractLsb' 0 32 &&& mx, x[3].extractLsb' 0 32 &&& mx,
    y[2].extractLsb' 0 32, y[3].extractLsb' 0 32]

/-- `FieldElement2625x4::reduce64(z)`, named as in the Rust: the two carry chains
`carry(0), carry(4), …, carry(4), carry(8)`, the top carry `c` split into `c0 + c1 2^26` and times
19 into `z[0]` and `z[1]`, one more `carry(0)`, then `repack_pair`. The masks `carry` applies to
limbs nothing reads again are taken in `repack`; `mul32` by 19 is a 64-bit product, of operands
below `2^32`. -/
def FieldElement2625x4_reduce64_impl_reduce64.spec (z : Fin 10 → Vector (BitVec 64) 4) : Fe2625x4 :=
  let z1 := vadd (z 1) (vshr (z 0) 26)
  let z0 := vand (z 0) (Vector.replicate 4 67108863#64)
  let z5 := vadd (z 5) (vshr (z 4) 26)
  let z4 := vand (z 4) (Vector.replicate 4 67108863#64)
  let z2 := vadd (z 2) (vshr z1 25)
  let z1 := vand z1 (Vector.replicate 4 33554431#64)
  let z6 := vadd (z 6) (vshr z5 25)
  let z5 := vand z5 (Vector.replicate 4 33554431#64)
  let z3 := vadd (z 3) (vshr z2 26)
  let z7 := vadd (z 7) (vshr z6 26)
  let z4 := vadd z4 (vshr z3 25)
  let z8 := vadd (z 8) (vshr z7 25)
  let z5 := vadd z5 (vshr z4 26)
  let z9 := vadd (z 9) (vshr z8 26)
  let c := vshr z9 25
  let c0 := vmul (vand c (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64)
  let c1 := vmul (vshr z9 51) (Vector.replicate 4 19#64)
  let z0 := vadd c0 z0
  let z1 := vadd (vadd c1 z1) (vshr z0 26)
  fun
  | 0 => repack' z0 z1 67108863#32
  | 1 => repack z2 z3 67108863#32 33554431#32
  | 2 => repack' z4 z5 67108863#32
  | 3 => repack z6 z7 67108863#32 33554431#32
  | 4 => repack z8 z9 67108863#32 33554431#32

end

/-! ## Proof -/

section Proof

/-! The flagged instructions, on lanes that overflow neither way. -/

local macro "lanes" : tactic =>
  `(tactic|
    ( intro i
      simp only [vand, vshr, vmul, vadd, Fin.getElem_fin, Vector.getElem_ofFn,
        Vector.getElem_replicate]
      bv_decide))

variable (x y u v : Vector (BitVec 64) 4)

/-- `z[4] & LOW_26 + z[3] >> 25`. -/
theorem add_and26_shr25 :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (vand x (Vector.replicate 4 67108863#64)))
        (Ty.wrap (t := .vec 4 64) (vshr y 25)) =
      Ty.wrap (t := .vec 4 64) (vadd (vand x (Vector.replicate 4 67108863#64)) (vshr y 25)) :=
  zipWith_add_nsw_nuw _ _ (by lanes)

/-- `z[5] & LOW_25 + z[4] >> 26`. -/
theorem add_and25_shr26 :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (vand x (Vector.replicate 4 33554431#64)))
        (Ty.wrap (t := .vec 4 64) (vshr y 26)) =
      Ty.wrap (t := .vec 4 64) (vadd (vand x (Vector.replicate 4 33554431#64)) (vshr y 26)) :=
  zipWith_add_nsw_nuw _ _ (by lanes)

/-- `c0 * 19`. -/
theorem mul_and26_19 :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (vand x (Vector.replicate 4 67108863#64)))
        (Ty.wrap (t := .vec 4 64) (Vector.replicate 4 19#64)) =
      Ty.wrap (t := .vec 4 64)
        (vmul (vand x (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64)) :=
  zipWith_mul_nsw_nuw _ _ (by lanes)

/-- `c1 * 19`. -/
theorem mul_shr51_19 :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (vshr x 51))
        (Ty.wrap (t := .vec 4 64) (Vector.replicate 4 19#64)) =
      Ty.wrap (t := .vec 4 64) (vmul (vshr x 51) (Vector.replicate 4 19#64)) :=
  zipWith_mul_nsw_nuw _ _ (by lanes)

/-- `z[0] + c0 * 19`. -/
theorem add_c0 :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64)
          (vmul (vand x (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64)))
        (Ty.wrap (t := .vec 4 64) (vand y (Vector.replicate 4 67108863#64))) =
      Ty.wrap (t := .vec 4 64)
        (vadd (vmul (vand x (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64))
          (vand y (Vector.replicate 4 67108863#64))) :=
  zipWith_add_nsw_nuw _ _ (by lanes)

/-- `z[1] + c1 * 19`. -/
theorem add_c1 :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (vmul (vshr x 51) (Vector.replicate 4 19#64)))
        (Ty.wrap (t := .vec 4 64) (vand y (Vector.replicate 4 33554431#64))) =
      Ty.wrap (t := .vec 4 64)
        (vadd (vmul (vshr x 51) (Vector.replicate 4 19#64))
          (vand y (Vector.replicate 4 33554431#64))) :=
  zipWith_add_nsw_nuw _ _ (by lanes)

/-- The last `carry(0)`'s `z[1] += z[0] >> 26`. -/
theorem add_carry0 :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64)
          (vadd (vmul (vshr x 51) (Vector.replicate 4 19#64))
            (vand y (Vector.replicate 4 33554431#64))))
        (Ty.wrap (t := .vec 4 64)
          (vshr
            (vadd (vmul (vand u (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64))
              (vand v (Vector.replicate 4 67108863#64)))
            26)) =
      Ty.wrap (t := .vec 4 64)
        (vadd
          (vadd (vmul (vshr x 51) (Vector.replicate 4 19#64))
            (vand y (Vector.replicate 4 33554431#64)))
          (vshr
            (vadd (vmul (vand u (Vector.replicate 4 67108863#64)) (Vector.replicate 4 19#64))
              (vand v (Vector.replicate 4 67108863#64)))
            26)) :=
  zipWith_add_nsw_nuw _ _ (by lanes)

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_add_vadd zipWith_and_vand zipWith_lshr_vshr

-- 119 steps in one block: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `FieldElement2625x4::reduce64(z)` stores `spec` of the ten `u64x4`s at `z` at `out`. The loads
all come before the stores, so `out` may alias `z`; the `nuw`/`nsw` flags never fire. -/
public theorem FieldElement2625x4_reduce64_impl_reduce64.call_eq (out z : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.Fe4xRoom out) (hz : s.mem.Z10Fit z) :
    FieldElement2625x4_reduce64_impl_reduce64.call
        (FieldElement2625x4_reduce64_impl_reduce64.args (.value out) (.value z)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeFe4x out
                (FieldElement2625x4_reduce64_impl_reduce64.spec (s.mem.readZ10 z)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  block_init
  iterate 35 step_pure
  -- carry(&mut z, 0); carry(&mut z, 4);
  step_load with z0
  step_load with z1
  step_pure
  step_pure with z1a
  step_pure with transparent z0a
  iterate 2 step_pure
  step_load with z4
  step_load with z5
  step_pure
  step_pure with z5a
  step_pure with transparent z4a
  step_pure
  -- carry(&mut z, 1); carry(&mut z, 5);
  step_load with z2
  step_pure
  step_pure with z2a
  step_pure with transparent z1b
  step_pure
  step_load with z6
  step_pure
  step_pure with z6a
  step_pure with transparent z5b
  step_pure
  -- carry(&mut z, 2); carry(&mut z, 6);
  step_load with z3
  step_pure
  step_pure with z3a
  step_pure
  step_load with z7
  step_pure
  step_pure with z7a
  -- carry(&mut z, 3); carry(&mut z, 7); carry(&mut z, 4); carry(&mut z, 8);
  step_pure
  step_pure [add_and26_shr25] with z4b
  step_pure
  step_load with z8
  step_pure
  step_pure with z8a
  step_pure
  step_pure [add_and25_shr26] with z5c
  step_pure
  step_load with z9
  step_pure
  step_pure with z9a
  -- let c = z[9].shr::<25>(); … z[0] += c0; z[1] += c1; carry(&mut z, 0);
  step_pure with c
  step_pure with transparent c0
  step_pure with transparent c1
  step_pure [mul_and26_19] with transparent c0_19
  step_pure [mul_shr51_19] with transparent c1_19
  step_pure [add_c0] with transparent z0b
  step_pure [add_c1] with transparent z1c
  step_pure
  step_pure [add_carry0] with z1d
  -- repack_pair(z[0].into(), z[1].into()), …
  step_pure
  step_pure [expandZipWith]
  step_pure
  step_pure with r0
  step_pure
  step_pure [expandZipWith]
  step_pure
  step_pure [expandZipWith]
  step_pure with r1
  step_pure
  step_pure
  step_pure [expandZipWith]
  step_pure with r2
  step_pure
  step_pure [expandZipWith]
  step_pure
  step_pure [expandZipWith]
  step_pure with r3
  step_pure
  step_pure [expandZipWith]
  step_pure
  step_pure [expandZipWith]
  step_pure with r4
  clear hz
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Agave.Avx2

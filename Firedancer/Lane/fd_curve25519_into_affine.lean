module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.fd_f25519_inv
public import Firedancer.Lane.Mlir.fd_curve25519_into_affine

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `(X/Z, Y/Z, 1, XY/Z²)` of `P`: `X Y Z` unpacked, `Z` inverted, `x = X/Z`, `y = Y/Z`. -/
def fd_curve25519_into_affine.spec (P : Quad) : Quad :=
  let zi := fd_f25519_inv.spec P.Z
  let x := fd_r43x6_mul P.X zi
  let y := fd_r43x6_mul P.Y zi
  Quad.pack x y one (fd_r43x6_mul x y)

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `fd_curve25519_into_affine` stores `spec` of the point at `r` at `r` and returns `r`. -/
public theorem fd_curve25519_into_affine.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (hf : s.mem.QuadFit r) :
    _root_.Firedancer.Lane.Mlir.fd_curve25519_into_affine.call
        (_root_.Firedancer.Lane.Mlir.fd_curve25519_into_affine.args (.value r)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeQuad r (fd_curve25519_into_affine.spec (s.mem.readQuad r)) }) := by
  func_init
  block_init
  iterate 21 step_pure
  iterate 11 step_pattern using runBodyFrom_insertRun
  -- FD_R43X6_QUAD_UNPACK( x, y, z, t, r->P ), `z` into its `fd_f25519_t`
  step_alloca with zp
  step_pure
  step_load with transparent p03
  step_pure
  step_load with transparent p14
  step_pure
  step_load with transparent p25
  step_pure
  step_pure
  step_pure with z
  step_store
  -- fd_f25519_inv( z, z ), then fd_f25519_mul( x, x, z )
  step_call using _root_.Firedancer.Lane.Mlir.fd_f25519_inv.call_eq
  step_load with zi
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  step_pure with x5
  replace hx0 : x0 = Vector.replicate 8 (S₀.mem.readQuad r).X[0] := by rw [hx0]; rfl
  replace hx1 : x1 = Vector.replicate 8 (S₀.mem.readQuad r).X[1] := by rw [hx1]; rfl
  replace hx2 : x2 = Vector.replicate 8 (S₀.mem.readQuad r).X[2] := by rw [hx2]; rfl
  replace hx3 : x3 = Vector.replicate 8 (S₀.mem.readQuad r).X[3] := by rw [hx3]; rfl
  replace hx4 : x4 = Vector.replicate 8 (S₀.mem.readQuad r).X[4] := by rw [hx4]; rfl
  replace hx5 : x5 = Vector.replicate 8 (S₀.mem.readQuad r).X[5] := by rw [hx5]; rfl
  step_pattern using runBodyFrom_mulRowsRun (S₀.mem.readQuad r).X with x
  -- fd_f25519_mul( y, y, z )
  step_pure with y0
  step_pure with y1
  step_pure with y2
  step_pure with y3
  step_pure with y4
  step_pure with y5
  replace hy0 : y0 = Vector.replicate 8 (S₀.mem.readQuad r).Y[0] := by rw [hy0]; rfl
  replace hy1 : y1 = Vector.replicate 8 (S₀.mem.readQuad r).Y[1] := by rw [hy1]; rfl
  replace hy2 : y2 = Vector.replicate 8 (S₀.mem.readQuad r).Y[2] := by rw [hy2]; rfl
  replace hy3 : y3 = Vector.replicate 8 (S₀.mem.readQuad r).Y[3] := by rw [hy3]; rfl
  replace hy4 : y4 = Vector.replicate 8 (S₀.mem.readQuad r).Y[4] := by rw [hy4]; rfl
  replace hy5 : y5 = Vector.replicate 8 (S₀.mem.readQuad r).Y[5] := by rw [hy5]; rfl
  step_pattern using runBodyFrom_mulRowsRun (S₀.mem.readQuad r).Y with y
  -- fd_f25519_mul( t, x, y ), FD_R43X6_QUAD_PACK( r->P, x, y, one, t )
  step_pattern using runBodyFrom_mulRun with t
  step_pattern using runBodyFrom_quadPackStoreRun'
  step_pure
  finish_block
  replace hz : z = (S₀.mem.readQuad r).Z := by rw [hz]; rfl
  subst hS
  erase_frame
  simp only [GlobalState.alloca]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane

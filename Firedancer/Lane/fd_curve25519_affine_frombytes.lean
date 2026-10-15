module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.Mlir.fd_curve25519_affine_frombytes

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `fd_f25519_frombytes`'s mask: bit 255 cleared. -/
def feMask : Wv :=
  #v[0xFFFFFFFFFFFFFFFF#64, 0xFFFFFFFFFFFFFFFF#64, 0xFFFFFFFFFFFFFFFF#64, 0x7FFFFFFFFFFFFFFF#64]

/-- `fd_f25519_frombytes`: the encoding's lanes, bit 255 cleared, unpacked. -/
def feFrombytes (b : BitVec 256) : Wwl :=
  fd_r43x6_unpack.spec (Vector.ofFn fun i => Ty.extractVecElem 4 64 i b &&& feMask[i])

/-- The affine point `(x, y)` from the encodings of `x` and `y`: `Z = 1`, `T = x y`. -/
def fd_curve25519_affine_frombytes.spec (bx bY : BitVec 256) : Quad :=
  let x := feFrombytes bx
  let y := feFrombytes bY
  Quad.pack x y one (fd_r43x6_mul x y)

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `fd_curve25519_affine_frombytes` stores `spec` of the encodings at `x` and `y` at `r` and
returns `r`. -/
public theorem fd_curve25519_affine_frombytes.call_eq (r x y : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256) :
    _root_.Firedancer.Lane.Mlir.fd_curve25519_affine_frombytes.call
        (_root_.Firedancer.Lane.Mlir.fd_curve25519_affine_frombytes.args (.value r) (.value x)
          (.value y))
        s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeQuad r
                (fd_curve25519_affine_frombytes.spec (s.mem.readAt x 256)
                  (s.mem.readAt y 256)) }) := by
  func_init
  block_init
  iterate 27 step_pure
  iterate 11 step_pattern using runBodyFrom_insertRun
  -- fd_f25519_frombytes( x, _x ), fd_f25519_frombytes( y, _y )
  step_load with transparent lx
  step_pure [zipWith_eq_ofFn] with ux
  step_pattern using runBodyFrom_unpackRun with X
  step_load with transparent ly
  step_pure [zipWith_eq_ofFn] with uy
  step_pattern using runBodyFrom_unpackRun with Y
  -- fd_f25519_mul( t, x, y )
  step_pattern using runBodyFrom_mulRun with T
  -- FD_R43X6_QUAD_PACK( r->P, x->el, y->el, z->el, t->el )
  step_pattern using runBodyFrom_quadPackStoreRun inline
  finish_block
  subst hS
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane

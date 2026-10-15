module

public import MLIR.Run.Tactic
public import Firedancer.LaneNI.fd_f25519_frombytes
public import Firedancer.LaneNI.fd_f25519_sqr
public import Firedancer.LaneNI.fd_f25519_mul
public import Firedancer.LaneNI.fd_f25519_sub
public import Firedancer.LaneNI.fd_f25519_add
public import Firedancer.LaneNI.fd_f25519_is_square_var
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_validate
public import Firedancer.Avx512.fd_r43x6_ge_decode2

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512 MLIR.Firedancer.Lane

@[expose] public section

/-- `u v` of `fd_ed25519_point_validate`, with `y` from the encoding, `u = y² - 1`, `v = d y² + 1`.
-/
def fd_ed25519_point_validate.uv (b : BitVec 256) : Wwl :=
  let y := feFrombytes b
  let u := fd_r43x6_sqr y
  let v := fd_r43x6_mul u fd_r43x6_ge_decode2.d
  let u := fd_f25519_sub.spec u fd_f25519_one.vec
  let v := fd_f25519_add.spec v fd_f25519_one.vec
  fd_r43x6_mul u v

/-- `fd_ed25519_point_validate( buf )`: `fd_f25519_is_square_var( u v )`. -/
def fd_ed25519_point_validate.spec (b : BitVec 256) : BitVec 32 :=
  fd_f25519_is_square_var.spec (fd_ed25519_point_validate.uv b)

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_validate( buf )` returns `spec` of the 32 bytes at `buf`; its three slots and
`fd_f25519_is_square_var`'s blocks are allocated. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_point_validate.call_eq (buf : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Firedancer.LaneNI.Mlir.fd_ed25519_point_validate.globals)
    (hb : Fits s.mem buf 256) :
    Firedancer.LaneNI.Mlir.fd_ed25519_point_validate.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_point_validate.args (.value buf)) s =
      .value
        (.cons (.value (fd_ed25519_point_validate.spec (s.mem.readAt buf 256))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3 +
              fd_f25519_is_square_var.blocks (fd_ed25519_point_validate.uv (s.mem.readAt buf 256))⟩,
            mem := s.mem }) := by
  obtain ⟨w, hw⟩ : ∃ w, fd_ed25519_point_validate.uv (s.mem.readAt buf 256) = w := ⟨_, rfl⟩
  rw [fd_ed25519_point_validate.spec, hw]
  func_init
  block_init
  step_pure
  step_pure
  step_alloca with yp
  step_alloca with up
  step_alloca with vp
  iterate 3 step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call_eq
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr.call_eq
  step_load with u
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sub.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_add.call_eq
  step_load with u'
  step_load with v'
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_is_square_var.call_eq
  iterate 3 step_pure
  finish_block
  have e : fd_r43x6_mul u' v' = w := by
    rw [← hw, hu', hv', hv, hu, hy]
    rfl
  subst hS
  erase_frame
  simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd, e]

end Proof

end MLIR.Firedancer.LaneNI

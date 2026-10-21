module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Mlir.fd_r52x5_reduce

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_reduce( x )`: the carry `q` of `x + 19` out of bit 255, added back as `19 q`, then
one carry pass, each limb masked to 51 bits. -/
def fd_r52x5_reduce.spec (x : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64
  let q := (x 0 + 19#64) >>> 51
  let q := (x 1 + q) >>> 51
  let q := (x 2 + q) >>> 51
  let q := (x 3 + q) >>> 51
  let q := (x 4 + q) >>> 51
  let x0 := x 0 + 19#64 * q
  let c := x0 >>> 51
  let x1 := x 1 + c
  let c := x1 >>> 51
  let x2 := x 2 + c
  let c := x2 >>> 51
  let x3 := x 3 + c
  let c := x3 >>> 51
  let x4 := x 4 + c
  fun
  | ⟨0, _⟩ => x0 &&& mask
  | ⟨1, _⟩ => x1 &&& mask
  | ⟨2, _⟩ => x2 &&& mask
  | ⟨3, _⟩ => x3 &&& mask
  | ⟨4, _⟩ => x4 &&& mask

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_reduce( x )` replaces the limbs at `x` by `spec` of them. -/
public theorem fd_r52x5_reduce.call_eq (x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hx : s.mem.LimbsFit x) (hxw : Writable s.mem x) :
    fd_r52x5_reduce.call (fd_r52x5_reduce.args (.value x)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeLimbs x (fd_r52x5_reduce.spec (s.mem.readLimbs x)) }) := by
  have hx256 : Room s.mem x 256 := (hx.room hxw).room320.mono (by omega)
  rw [MemoryState.storeLimbsV_eq (hx.room hxw)]
  func_init
  block_init
  iterate 9 step_pure
  -- ulong q = (x[0] + 19) >> 51; q = (x[1] + q) >> 51; … q = (x[4] + q) >> 51;
  step_load with x0
  step_pure
  step_pure with q
  step_pure
  step_load with x1
  step_pure
  step_pure with q
  step_pure
  step_load with x2
  step_pure
  step_pure with q
  step_pure
  step_load with x3
  step_pure
  step_pure with q
  step_pure
  step_load with x4
  step_pure
  step_pure with transparent q
  -- x[0] += 19 * q; then the carry pass
  step_pure [shr51_mul19]
  step_pure with x0'
  step_pure with c
  step_pure with x1'
  step_pure with c
  step_pure with x2'
  step_pure with c
  step_pure with x3'
  step_pure with c
  -- x[0..3] &= FD_F25519_LIMB_MASK, stored as one vector
  iterate 4 step_pure
  step_pure [expandOfFn]
  step_store
  -- x[4] += c; x[4] &= FD_F25519_LIMB_MASK;
  step_pure with x4'
  step_pure
  step_store
  finish_block
  rw [hS]
  clear hS hE hArgs
  subst_vars
  simp only [MemoryState.storeLimbsV, MemoryState.storeWv, fd_r52x5_reduce.spec,
    MemoryState.readLimbs]
  ac_rfl

end Proof

end MLIR.Firedancer.R52x5

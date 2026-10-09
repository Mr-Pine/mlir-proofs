module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Mlir.fd_f25519_sub
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_fold_signed(fd_r43x6_sub_fast(a, b))`, as compiled: `a - b + (p - _b)`, then the
shift-and-add `fd_r43x6_approx_carry_propagate`, then `+ _b`. -/
def fd_f25519_sub.spec (a b : Wwl) : Wwl :=
  -- `p - _b`, the masks `_m43`/`_m40`, the shifts, and the bias `_b`
  let pb : Wwl :=
    #v[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0,
      0]
  let m : Wwl :=
    #v[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0,
      0]
  let sh : Wwl := #v[43, 43, 43, 43, 43, 40, 0, 0]
  let _b : Wwl := #v[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]
  let _x := Vector.zipWith (· + ·) (Vector.zipWith (· - ·) a b) pb
  let _xl := Vector.zipWith (· &&& ·) _x m
  let _xh := Vector.zipWith (fun x s => x.sshiftRight s.toNat) _x sh
  let _c : Wwl := #v[_xh[5], _xh[0], _xh[1], _xh[2], _xh[3], _xh[4], 0, 0]
  let _d : Wwl := #v[18 * _c[0], 0, 0, 0, 0, 0, 0, 0]
  Vector.zipWith (· + ·) (Vector.zipWith (· + ·) (Vector.zipWith (· + ·) _c _b) _xl) _d

end

/-! ## Proof -/

section Proof

/-- `sub` stores `spec a b` at `r` and returns `r`. `r` may alias `a` or `b`. -/
public theorem fd_f25519_sub.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Fits s.mem r 512) (ha : Fits s.mem a 512) (hb : Fits s.mem b 512) :
    fd_f25519_sub.call (fd_f25519_sub.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r (fd_f25519_sub.spec (s.mem.readVec a) (s.mem.readVec b)) }) := by
  rw [MemoryState.storeVec]
  func_init
  block_init
  step_pure with _b
  step_pure with d_mask
  step_pure with eighteen
  -- lane indices `7 … 1`
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with pb
  step_pure with m
  step_pure with sh
  -- `wwl_zero()` as `#v[0, poison, …]`: the rotation reads only its lane 0
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_load with x
  step_load with y
  -- `fd_r43x6_sub_fast`
  step_pure
  step_pure with _x
  -- `fd_r43x6_fold_signed`
  step_pure with _xl
  step_pure opaque [hsh, expandOfFn] with _xh
  step_pure with _c
  step_pure [heighteen]
  step_pure [hd_mask] with _d
  step_pure opaque [h_xl, hm, h_b, expandOfFn, and_add_no_overflow] with _xl_b
  step_pure
  step_pure
  step_store
  finish_block
  rw [hS]
  subst_vars
  congr 1; congr 1; congr 1; congr 1; congr 1
  apply vec_ext_fin
  intro i
  fin_cases i
  all_goals try simp [spec, MemoryState.readVec, Ty.extractVecElem_eq]
  -- the compiled sum is `_xl + _b + _c + _d`; lane 0: `(c * 18) &&& -1 = 18 * c`
  · rw [show (18446744073709551615#64) = BitVec.allOnes 64 by decide, BitVec.and_allOnes]
    ac_rfl
  all_goals ac_rfl

end Proof

end MLIR.Firedancer.Avx512

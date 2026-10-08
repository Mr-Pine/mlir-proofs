module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Mlir.fd_f25519_sub

namespace LeanMLIR.RIR.Firedancer.Avx512

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
  step_pure with p
  step_pure with reduced_mask
  step_pure with shift_amounts
  step_pure with rotl_idxs
  step_pure with zero
  step_pure with eightteen
  step_pure with first_elem_mask
  step_pure with b
  step_load with x
  step_load with y
  step_pure opaque
  step_pure with sub_fast
  -- fold_signed
  step_pure opaque named transparent
  step_pure opaque [hshift_amounts] named transparent
  step_pure [hrotl_idxs, hzero, expandOfFn, Ty.wrap_vec] named transparent
  step_pure [heightteen] with multiplied
  step_pure opaque [hfirst_elem_mask, hmultiplied, expandOfFn, List.getElem_cons_zero,
    List.getElem_cons_succ, BitVec.and_zero] named
  step_pure
  step_pure
  step_pure
  step_store
  finish_block
  rw [hS]
  subst_vars
  congr 1; congr 1; congr 1; congr 1; congr 1
  apply Vector.ext
  intro i hi
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals try simp [spec, MemoryState.readVec, Ty.extractVecElem_eq]
  all_goals try omega
  -- lane 0: `(c * 18) &&& -1 = 18 * c`
  rw [show (18446744073709551615#64) = BitVec.allOnes 64 by decide, BitVec.and_allOnes,
    BitVec.mul_comm]

end Proof

end LeanMLIR.RIR.Firedancer.Avx512

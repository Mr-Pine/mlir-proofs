module

public import Firedancer.Lane.fd_f25519_sqrt_ratio
public import Firedancer.LaneNI.fd_f25519_sqr
public import Firedancer.LaneNI.fd_f25519_mul
public import Firedancer.LaneNI.fd_f25519_neg
public import Firedancer.LaneNI.fd_f25519_eq
public import Firedancer.LaneNI.fd_f25519_if
public import Firedancer.LaneNI.fd_f25519_abs
public import Firedancer.LaneNI.fd_f25519_pow22523
public import Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.LaneNI

open MLIR.Firedancer.Lane

/-! ## Proof -/

section Proof

/-- The `or` of two `0`/`1` flags is `0` or `1`. -/
private theorem or01 {a b : BitVec 32} (ha : a = 0 ∨ a = 1) (hb : b = 0 ∨ b = 1) :
    a ||| b = 0 ∨ a ||| b = 1 := by
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;> decide

-- 18 calls and 10 slots: carrying the slots' facts across the calls exceeds the default budget
set_option maxHeartbeats 400000 in
/-- `fd_f25519_sqrt_ratio( r, u, v )` stores the Lane `spec`'s root at `r` and returns its flag; the
callees' and its own slots are freed, the counter moves on by 18 blocks. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio.call_eq (r u v : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hu : Fits s.mem u 512)
    (hv : Fits s.mem v 512) (hru : r.id ≠ u.id) (hrv : r.id ≠ v.id) :
    Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio.args (.value r) (.value u) (.value v)) s =
      .value
        (.cons (.value (fd_f25519_sqrt_ratio.spec (s.mem.readVec u) (s.mem.readVec v)).2) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 18⟩,
            mem :=
              s.mem.storeVec r
                (fd_f25519_sqrt_ratio.spec (s.mem.readVec u) (s.mem.readVec v)).1 }) := by
  generalize hres : fd_f25519_sqrt_ratio.spec (s.mem.readVec u) (s.mem.readVec v) = res
  func_init
  block_init
  iterate 2 step_pure
  iterate 10 step_alloca
  step_lifetime
  step_load with V
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_lifetime
  step_load with x2
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_lifetime
  step_load with U
  step_load with x3
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_lifetime
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_lifetime
  step_load with x6
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_lifetime
  step_load with x7
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_pow22523.call_eq
  step_load with R0
  step_load with xuv3
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_lifetime
  step_load with R1
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with c0
  step_load with V'
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_lifetime
  step_load with U'
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_neg_70.call_eq
  step_lifetime
  step_load with un
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with chk
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq with e1
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq with e2
  step_load with uni
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq with e3
  step_lifetime
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_pure
  step_load with rp
  step_call using (Firedancer.LaneNI.Mlir.fd_f25519_if.call_eq (cond := e3 ||| e2)
    (hc := by rw [he3, he2]; exact or01 (SqrtRatio.eq_spec_01 _ _) (SqrtRatio.eq_spec_01 _ _)))
  step_load with ri
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_abs.call_eq
  step_pure
  iterate 10 step_lifetime
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeVec_storeVec_self, MemoryState.storeVec_storeVec_self,
    MemoryState.storeVec_storeVec_self, BitVec.or_comm e2 e1]
  rw [BitVec.or_comm e3 e2] at hri
  have hres' : res = (fd_f25519_sqrt_ratio.abs ri, e1 ||| e2) := by
    subst_vars
    delta fd_f25519_sqrt_ratio.spec
    rfl
  subst hres'
  simp

end Proof

end MLIR.Firedancer.LaneNI

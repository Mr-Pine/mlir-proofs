module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.ExtractLimbs
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_90
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_58
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_41
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_32
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_18
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512
open MLIR.Firedancer.Lane (r43x6Pack)

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_pack(x)`: four 64-bit words, limb `k` of `x` from bit `43 k`. -/
def fd_r43x6_pack.spec (x : Wwl) : Wv :=
  #v[x[0] ||| x[1] <<< 43 ||| x[1] <<< 43, x[1] >>> 21 ||| x[2] <<< 22 ||| x[2] <<< 22,
    x[2] >>> 42 ||| x[3] <<< 1 ||| x[4] <<< 44, x[4] >>> 20 ||| x[5] <<< 23 ||| x[5] <<< 23]

end

/-- Four lanes packed: lane 0 lowest. -/
private theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

/-- `spec`'s words, packed, are `r43x6Pack` of the limbs. -/
public theorem fd_r43x6_pack.packLanes_spec (x : Wwl) :
    BitVec.packLanes (fd_r43x6_pack.spec x) = r43x6Pack (extractLimbs x) := by
  rw [packLanes_four]
  simp only [fd_r43x6_pack.spec, r43x6Pack, extractLimbs, Vector.getElem_mk,
    List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  generalize x[0] = a0, x[1] = a1, x[2] = a2, x[3] = a3, x[4] = a4, x[5] = a5
  bv_decide

/-! ## Proof -/

section Proof

/-- `fd_r43x6_pack` returns `spec x` and leaves the state as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) := by
  func_init
  block_init
  iterate 51 step_pure
  step_pure with z
  have e : z = fd_r43x6_pack.spec x := by
    rw [hz]
    ext i hi : 1
    rcases i with _ | _ | _ | _ | i <;> first | omega | simp [fd_r43x6_pack.spec]
  finish_block
  rw [hS]

/-- `fd_r43x6_pack_18` is `fd_r43x6_pack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack_18.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack_18.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack_18.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq x s hwf

/-- `fd_r43x6_pack_32` is `fd_r43x6_pack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack_32.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack_32.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack_32.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq x s hwf

/-- `fd_r43x6_pack_41` is `fd_r43x6_pack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack_41.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack_41.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack_41.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq x s hwf

/-- `fd_r43x6_pack_58` is `fd_r43x6_pack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack_58.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack_58.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack_58.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq x s hwf

/-- `fd_r43x6_pack_90` is `fd_r43x6_pack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_pack_90.call_eq (x : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_pack_90.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_pack_90.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (t := .vec 4 64) (fd_r43x6_pack.spec x)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq x s hwf

end Proof

end MLIR.Firedancer.LaneNI

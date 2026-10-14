module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Lane.Mlir.fd_sha512_init
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Lane

open Ref (sha512IV)

/-! ## Proof -/

section Proof

/-- Eight packed lanes: lane 0 lowest. -/
theorem packLanes_oct (v : Vector (BitVec 64) 8) :
    BitVec.packLanes v =
      v[7] ++ (v[6] ++ (v[5] ++ (v[4] ++ (v[3] ++ (v[2] ++ (v[1] ++ v[0])))))) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d, v[4] = e, v[5] = f, v[6] = g, v[7] = h
  bv_decide

/-- `fd_sha512_init` stores `sha512IV` at `state` (byte `128`) and zeroes `buf_used`, `bit_cnt_lo`
and `bit_cnt_hi` (bytes `200 … 223`), and returns `sha`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_sha512_init.call_eq (sha : Pointer) (s : GlobalState)
    (hwf : s.WF) (hroom : Room s.mem sha (8 * 256)) (hoff : ¬sha.offset.uaddOverflow 256#64) :
    Firedancer.Lane.Mlir.fd_sha512_init.call
        (Firedancer.Lane.Mlir.fd_sha512_init.args (.value sha)) s =
      .value
        (.cons (.value sha) .nil,
          { s with
            mem :=
              ((((((((s.mem.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64)
                                            sha512IV[1]).storeAt
                                        (sha.add 144#64) sha512IV[2]).storeAt
                                    (sha.add 152#64) sha512IV[3]).storeAt
                                (sha.add 160#64) sha512IV[4]).storeAt
                            (sha.add 168#64) sha512IV[5]).storeAt
                        (sha.add 176#64) sha512IV[6]).storeAt
                    (sha.add 184#64) sha512IV[7]).storeAt
                (sha.add 200#64) ((0#8).replicate 24) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_store
  step_pure
  step_memset
  finish_block
  have hov (k : Nat) (hk : k ≤ 56) :
    ¬(sha.add 128#64).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, not_le] at hoff ⊢
    omega
  -- the eight word stores of the statement, merged into the one vector store
  rw [hS, show sha.add 136#64 = (sha.add 128#64).add (BitVec.ofNat 64 8) by simp,
    show sha.add 144#64 = (sha.add 128#64).add (BitVec.ofNat 64 16) by simp,
    show sha.add 152#64 = (sha.add 128#64).add (BitVec.ofNat 64 24) by simp,
    show sha.add 160#64 = (sha.add 128#64).add (BitVec.ofNat 64 32) by simp,
    show sha.add 168#64 = (sha.add 128#64).add (BitVec.ofNat 64 40) by simp,
    show sha.add 176#64 = (sha.add 128#64).add (BitVec.ofNat 64 48) by simp,
    show sha.add 184#64 = (sha.add 128#64).add (BitVec.ofNat 64 56) by simp,
    MemoryState.storeAt_storeAt_append (a := 64) (hov 8 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 128) (hov 16 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 192) (hov 24 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 256) (hov 32 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 320) (hov 40 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 384) (hov 48 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 448) (hov 56 (by decide)) rfl (by decide),
    show BitVec.replicate 24 0#8 = 0#192 by decide]
  rw [packLanes_oct]
  rfl

end Proof

end MLIR.Firedancer.Lane

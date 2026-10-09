module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_init
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.R52x5.Mlir.fd_sha512_init
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5

open Ref (sha512IV)

/-! ## Proof -/

section Proof

/-- Four lanes packed: lane `0` lowest. -/
theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  have h (x : BitVec 256) :
    x =
      x.extractLsb' (3 * 64) 64 ++
        (x.extractLsb' (2 * 64) 64 ++
          (x.extractLsb' (1 * 64) 64 ++ x.extractLsb' (0 * 64) 64)) := by
    bv_decide
  rw [h (BitVec.packLanes v), BitVec.extractLsb'_packLanes, BitVec.extractLsb'_packLanes,
    BitVec.extractLsb'_packLanes, BitVec.extractLsb'_packLanes]

/-- `fd_sha512_init` stores `sha512IV` at `state` (byte `128`) and zeroes `buf_used`, `bit_cnt_lo`
and `bit_cnt_hi` (bytes `200 … 223`), and returns `sha`. -/
public theorem fd_sha512_init.call_eq (sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem sha (8 * 256)) (hoff : ¬sha.offset.uaddOverflow 256#64) :
    fd_sha512_init.call (fd_sha512_init.args (.value sha)) s =
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
  -- the constants
  iterate 4 step_pure
  -- `state[0 … 3]` and `state[4 … 7]`, one `<4 x i64>` store each
  step_pure
  step_store
  step_pure
  step_store
  -- `buf_used`'s address, the `memset` of `buf_used … bit_cnt_hi`, the return
  step_pure
  step_memset
  finish_block
  have hov (a k : Nat) (ha : a ≤ 160) (hk : k ≤ 24) :
    ¬(sha.add (BitVec.ofNat 64 a)).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, not_le] at hoff ⊢
    omega
  -- the eight word stores of the statement, merged into the two vector stores
  rw [hS, show sha.add 136#64 = (sha.add 128#64).add (BitVec.ofNat 64 8) by simp,
    show sha.add 144#64 = (sha.add 128#64).add (BitVec.ofNat 64 16) by simp,
    show sha.add 152#64 = (sha.add 128#64).add (BitVec.ofNat 64 24) by simp,
    show sha.add 168#64 = (sha.add 160#64).add (BitVec.ofNat 64 8) by simp,
    show sha.add 176#64 = (sha.add 160#64).add (BitVec.ofNat 64 16) by simp,
    show sha.add 184#64 = (sha.add 160#64).add (BitVec.ofNat 64 24) by simp,
    Ref.MemoryState.storeAt_storeAt_add (a := 64) (hov 128 8 (by decide) (by decide)) rfl
      (by decide),
    Ref.MemoryState.storeAt_storeAt_add (a := 128) (hov 128 16 (by decide) (by decide)) rfl
      (by decide),
    Ref.MemoryState.storeAt_storeAt_add (a := 192) (hov 128 24 (by decide) (by decide)) rfl
      (by decide),
    Ref.MemoryState.storeAt_storeAt_add (a := 64) (hov 160 8 (by decide) (by decide)) rfl
      (by decide),
    Ref.MemoryState.storeAt_storeAt_add (a := 128) (hov 160 16 (by decide) (by decide)) rfl
      (by decide),
    Ref.MemoryState.storeAt_storeAt_add (a := 192) (hov 160 24 (by decide) (by decide)) rfl
      (by decide),
    packLanes_four, packLanes_four, show BitVec.replicate 24 0#8 = 0#192 by decide]
  rfl

end Proof

end MLIR.Firedancer.R52x5

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_ulong_bswap
public import Sodium.Mlir.store64_be
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `STORE64_BE`: `w`'s bytes, most significant first, as memory holds them (little-endian). -/
abbrev store64_be.spec (w : BitVec 64) : BitVec 64 :=
  Firedancer.Ref.fd_ulong_bswap.spec w

end

/-! ## Proof -/

section Proof

namespace store64_be

/-- A store just below a stored range: one store of both, the lower value low. -/
theorem storeAt_storeAt_below {m : MemoryState} {q : Pointer} {x : BitVec a} {y : BitVec b}
    (hov : ¬q.offset.uaddOverflow (BitVec.ofNat 64 k)) (ha : a = 8 * k) (hk : k < 2 ^ 64) :
    (m.storeAt (q.add (BitVec.ofNat 64 k)) y).storeAt q x = m.storeAt q (y ++ x) := by
  rw [← MemoryState.storeAt_storeAt_append hov ha hk, MemoryState.storeAt_comm]
  simp only [Range.Disjoint, Range.of, Pointer.add_id, ne_eq, not_true_eq_false, false_or,
    Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hk]
  omega

/-- `p + (k + 1)` as `(p + k) + 1`, for the merges. -/
theorem add_split (p : Pointer) (k : Nat) :
    p.add (BitVec.ofNat 64 (k + 1)) = (p.add (BitVec.ofNat 64 k)).add (BitVec.ofNat 64 1) := by
  rw [Pointer.add_add, BitVec.ofNat_add]

/-- The eight byte stores, from the top byte down: one store of `w`'s bytes in that order. -/
theorem storeBytes_eq {m : MemoryState} {p : Pointer} (hov : ¬p.offset.uaddOverflow 8#64)
    (b0 b1 b2 b3 b4 b5 b6 b7 : BitVec 8) :
    (((((((m.storeAt (p.add 7#64) b7).storeAt (p.add 6#64) b6).storeAt (p.add 5#64) b5).storeAt
                        (p.add 4#64) b4).storeAt
                    (p.add 3#64) b3).storeAt
                (p.add 2#64) b2).storeAt
            (p.add 1#64) b1).storeAt
        p b0 =
      m.storeAt p (b7 ++ b6 ++ b5 ++ b4 ++ b3 ++ b2 ++ b1 ++ b0) := by
  have hk (k : Nat) (hk : k < 8) : ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 1#64 := by
    simp only [BitVec.uaddOverflow, Pointer.add] at hov ⊢
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat, decide_eq_true_eq] at hov ⊢
    omega
  rw [show (7#64) = BitVec.ofNat 64 (6 + 1) from rfl, add_split p 6,
    storeAt_storeAt_below (hk 6 (by decide)) rfl (by decide),
    show (6#64) = BitVec.ofNat 64 (5 + 1) from rfl, add_split p 5,
    storeAt_storeAt_below (hk 5 (by decide)) rfl (by decide),
    show (5#64) = BitVec.ofNat 64 (4 + 1) from rfl, add_split p 4,
    storeAt_storeAt_below (hk 4 (by decide)) rfl (by decide),
    show (4#64) = BitVec.ofNat 64 (3 + 1) from rfl, add_split p 3,
    storeAt_storeAt_below (hk 3 (by decide)) rfl (by decide),
    show (3#64) = BitVec.ofNat 64 (2 + 1) from rfl, add_split p 2,
    storeAt_storeAt_below (hk 2 (by decide)) rfl (by decide),
    show (2#64) = BitVec.ofNat 64 (1 + 1) from rfl, add_split p 1,
    storeAt_storeAt_below (hk 1 (by decide)) rfl (by decide),
    show (1#64) = BitVec.ofNat 64 1 from rfl,
    storeAt_storeAt_below (by simpa using hk 0 (by decide)) rfl (by decide)]

theorem bytes_eq (w : BitVec 64) :
    w.setWidth 8 ++ (w >>> 8).setWidth 8 ++ (w >>> 16).setWidth 8 ++ (w >>> 24).setWidth 8 ++
        (w >>> 32).setWidth 8 ++
        (w >>> 40).setWidth 8 ++
        (w >>> 48).setWidth 8 ++
        (w >>> 56).setWidth 8 =
      spec w := by
  simp only [spec, Firedancer.Ref.fd_ulong_bswap.spec]
  bv_decide

theorem trunc_ushr_56 (w : BitVec 64) : ((w >>> 56).setWidth 8).setWidth 64 = w >>> 56 := by
  bv_decide

end store64_be

open store64_be in
/-- `store64_be` stores `w` big-endian at `dst`. -/
public theorem store64_be.call_eq (dst : Pointer) (w : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hdst : Room s.mem dst 64) (hdsto : ¬dst.offset.uaddOverflow 8#64) :
    store64_be.call (store64_be.args (.value dst) (.value w)) s =
      .value (.nil, { s with mem := s.mem.storeAt dst (store64_be.spec w) }) := by
  func_init
  block_init
  iterate 7 step_pure
  step_pure
  step_pure
  step_store
  iterate 6
    step_pure
    step_pure
    step_pure
    step_store
  step_pure
  step_pure [trunc_ushr_56]
  step_store
  finish_block
  rw [hS, storeBytes_eq hdsto, bytes_eq]

end Proof

end MLIR.Sodium

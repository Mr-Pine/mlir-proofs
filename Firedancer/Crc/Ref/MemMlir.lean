module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_bswap
public import Firedancer.Crc.Ref.Mlir.fd_memcpy
public import Firedancer.Crc.Ref.Mlir.fd_memcpy_68
public import Firedancer.Crc.Ref.Mlir.fd_memset
public import Firedancer.Crc.Ref.Mlir.fd_memzero_explicit
public import Firedancer.Crc.Ref.Mlir.fd_ulong_bswap
import Std.Tactic.BVDecide

/-!
# `fd_memcpy`, `fd_memset`, `fd_memzero_explicit`, `fd_ulong_bswap` (MLIR lift ↔ spec)

The out-of-line helpers the SHA-512 lifts call. Both `fd_memcpy` copies return `d`.
-/

namespace MLIR.Firedancer.Crc.Ref

section Proof

/-- `fd_memcpy` copies the `sz` bytes at `src` to `d` (disjoint, `FD_RESTRICT`) and returns `d`. -/
public theorem fd_memcpy.call_eq (d src : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Room s.mem d (8 * sz.toNat)) (hsrc : Fits s.mem src (8 * sz.toNat))
    (hsep : (Range.of d (8 * sz.toNat)).Disjoint (Range.of src (8 * sz.toNat))) :
    fd_memcpy.call (fd_memcpy.args (.value d) (.value src) (.value sz)) s =
      .value
        (.cons (.value d) .nil,
          { s with mem := s.mem.storeAt d (s.mem.readAt src (8 * sz.toNat)) }) := by
  func_init
  block_init
  step_memcpy
  finish_block
  rw [hS]

/-- `fd_memcpy.68`, the same as `fd_memcpy.call_eq`. -/
public theorem fd_memcpy_68.call_eq (d src : Pointer) (sz : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d (8 * sz.toNat)) (hsrc : Fits s.mem src (8 * sz.toNat))
    (hsep : (Range.of d (8 * sz.toNat)).Disjoint (Range.of src (8 * sz.toNat))) :
    fd_memcpy_68.call (fd_memcpy_68.args (.value d) (.value src) (.value sz)) s =
      .value
        (.cons (.value d) .nil,
          { s with mem := s.mem.storeAt d (s.mem.readAt src (8 * sz.toNat)) }) := by
  func_init
  block_init
  step_memcpy
  finish_block
  rw [hS]

/-- `fd_memset( d, 0, sz )`, the only call the lift keeps: `sz` zero bytes at `d`; returns `d`. -/
public theorem fd_memset.call_eq (d : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Room s.mem d (8 * sz.toNat)) :
    fd_memset.call (fd_memset.args (.value d) (.value sz)) s =
      .value
        (.cons (.value d) .nil, { s with mem := s.mem.storeAt d ((0#8).replicate sz.toNat) }) := by
  func_init
  block_init
  step_pure
  step_memset
  finish_block
  rw [hS]

/-- `fd_memzero_explicit` stores `sz` zero bytes at `d` (the compiler barrier is no instruction). -/
public theorem fd_memzero_explicit.call_eq (d : Pointer) (sz : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d (8 * sz.toNat)) :
    fd_memzero_explicit.call (fd_memzero_explicit.args (.value d) (.value sz)) s =
      .value (.nil, { s with mem := s.mem.storeAt d ((0#8).replicate sz.toNat) }) := by
  func_init
  block_init
  step_pure
  step_memset
  finish_block
  rw [hS]

/-- `llvm.intr.bswap`'s byte loop computes `Ref.fd_ulong_bswap.spec`. -/
theorem fd_ulong_bswap.foldl_eq (x : BitVec 64) :
    (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1)))
        0#64 =
      Firedancer.Ref.fd_ulong_bswap.spec x := by
  simp only [List.range_succ, List.range_zero, List.nil_append, List.foldl_cons, List.foldl_nil,
    List.foldl_append, Firedancer.Ref.fd_ulong_bswap.spec]
  bv_decide

/-- `fd_ulong_bswap` returns `Ref.fd_ulong_bswap.spec x`. -/
public theorem fd_ulong_bswap.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_bswap.call (fd_ulong_bswap.args (.value x)) s =
      .value (.cons (.value (Firedancer.Ref.fd_ulong_bswap.spec x)) .nil, s) := by
  func_init
  block_init
  step_pure [fd_ulong_bswap.foldl_eq]
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.Crc.Ref

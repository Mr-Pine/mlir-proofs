module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_align
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_leave
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_hit_cnt
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_miss_cnt
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_insert_cnt

/-!
# Cache getter refinements (MLIR lift ↔ spec)

The `call_eq` theorems for the cache accessors of PR firedancer #12267
(`crc/ref/fd_ed25519_ref_cache.c`): `cache_align` returns the fixed alignment, `cache_leave`
returns its argument, and the three counters read their `ulong` field (`hit_cnt`/`miss_cnt`/
`insert_cnt` at offsets 48/56/64), all leaving the state unchanged.
-/

namespace MLIR.Firedancer.Crc.Ref

section Proof

/-- `fd_ed25519_cache_align` returns `FD_ED25519_CACHE_ALIGN = 128`. -/
public theorem fd_ed25519_cache_align.call_eq (s : GlobalState) (hwf : s.WF) :
    fd_ed25519_cache_align.call fd_ed25519_cache_align.args s =
      .value (.cons (.value 128#64) .nil, s) := by
  func_init
  block_init
  step_pure
  finish_block
  rw [hS]

/-- `fd_ed25519_cache_leave` returns the cache pointer unchanged. -/
public theorem fd_ed25519_cache_leave.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF) :
    fd_ed25519_cache_leave.call (fd_ed25519_cache_leave.args (.value p)) s =
      .value (.cons (.value p) .nil, s) := by
  func_init
  block_init
  finish_block
  rw [hS]

/-- `fd_ed25519_cache_hit_cnt` returns the `hit_cnt` field (offset 48), state unchanged. -/
public theorem fd_ed25519_cache_hit_cnt.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hoff : ¬ p.offset.uaddOverflow 48#64) (hfits : Fits s.mem (p.add 48#64) 64) :
    fd_ed25519_cache_hit_cnt.call (fd_ed25519_cache_hit_cnt.args (.value p)) s =
      .value (.cons (.value (s.mem.readAt (p.add 48#64) 64)) .nil, s) := by
  func_init
  block_init
  step_pure [gep_value hoff (.inr (by decide))]
  step_load
  finish_block
  rw [hv1, hS]

/-- `fd_ed25519_cache_miss_cnt` returns the `miss_cnt` field (offset 56), state unchanged. -/
public theorem fd_ed25519_cache_miss_cnt.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hoff : ¬ p.offset.uaddOverflow 56#64) (hfits : Fits s.mem (p.add 56#64) 64) :
    fd_ed25519_cache_miss_cnt.call (fd_ed25519_cache_miss_cnt.args (.value p)) s =
      .value (.cons (.value (s.mem.readAt (p.add 56#64) 64)) .nil, s) := by
  func_init
  block_init
  step_pure [gep_value hoff (.inr (by decide))]
  step_load
  finish_block
  rw [hv1, hS]

/-- `fd_ed25519_cache_insert_cnt` returns the `insert_cnt` field (offset 64), state unchanged. -/
public theorem fd_ed25519_cache_insert_cnt.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hoff : ¬ p.offset.uaddOverflow 64#64) (hfits : Fits s.mem (p.add 64#64) 64) :
    fd_ed25519_cache_insert_cnt.call (fd_ed25519_cache_insert_cnt.args (.value p)) s =
      .value (.cons (.value (s.mem.readAt (p.add 64#64) 64)) .nil, s) := by
  func_init
  block_init
  step_pure [gep_value hoff (.inr (by decide))]
  step_load
  finish_block
  rw [hv1, hS]

end Proof

end MLIR.Firedancer.Crc.Ref

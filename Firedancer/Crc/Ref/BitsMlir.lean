module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Mlir.fd_ulong_hash
public import Firedancer.Crc.Ref.Mlir.fd_ulong_align_up
public import Firedancer.Crc.Ref.Mlir.fd_ulong_is_pow2
public import Firedancer.Crc.Ref.Mlir.fd_ulong_is_aligned
public import Firedancer.Crc.Ref.Mlir.fd_ulong_is_aligned_56
public import Firedancer.Crc.Ref.Mlir.fd_ulong_min
public import Firedancer.Crc.Ref.Mlir.fd_ulong_if
import Std.Tactic.BVDecide

/-!
# `fd_bits` helper refinements (MLIR lift ↔ spec)

`fd_ulong_hash`, `fd_ulong_align_up`, `fd_ulong_is_pow2`, `fd_ulong_is_aligned`, `fd_ulong_min` and
`fd_ulong_if` as their C definitions. Several lifts are specialised to their one caller's constant
argument.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

/-- `fd_ulong_hash`: the Murmur3 64-bit finalizer. -/
def fd_ulong_hash.spec (x : BitVec 64) : BitVec 64 :=
  let x := x ^^^ x >>> 33
  let x := x * 0xff51afd7ed558ccd#64
  let x := x ^^^ x >>> 33
  let x := x * 0xc4ceb9fe1a85ec53#64
  x ^^^ x >>> 33

/-- `fd_ulong_align_up(x, a)`: `x` rounded up to a multiple of the power of two `a`. -/
def fd_ulong_align_up.spec (x a : BitVec 64) : BitVec 64 :=
  (x + (a - 1)) &&& -a

/-- `fd_ulong_is_pow2(x)`: `1` iff `x` is a power of two. -/
def fd_ulong_is_pow2.spec (x : BitVec 64) : BitVec 32 :=
  if x ≠ 0 ∧ x &&& (x - 1) = 0 then 1 else 0

/-- `fd_ulong_is_aligned(x, a)`: `1` iff `x` is a multiple of the power of two `a`. -/
def fd_ulong_is_aligned.spec (x a : BitVec 64) : BitVec 32 :=
  if x &&& (a - 1) = 0 then 1 else 0

/-- `fd_ulong_min(a, b)`. -/
def fd_ulong_min.spec (a b : BitVec 64) : BitVec 64 :=
  if a < b then a else b

/-- `fd_ulong_if(c, t, f)`: `c ? t : f`. -/
def fd_ulong_if.spec (c : BitVec 32) (t f : BitVec 64) : BitVec 64 :=
  if c ≠ 0 then t else f

end

section Proof

public theorem fd_ulong_hash.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_hash.call (fd_ulong_hash.args (.value x)) s =
      .value (.cons (.value (fd_ulong_hash.spec x)) .nil, s) := by
  func_init
  block_init
  iterate 11 step_pure
  finish_block
  rw [hS, spec]
  simp only [BitVec.xor_comm]

theorem neg_ssubOverflow {a : BitVec 64} (ha : a ≠ 0x8000000000000000#64) :
    (0#64).ssubOverflow a = false := by bv_decide

/-- The lift negates `a` with `nsw`, so `a = 2^63` is excluded. -/
public theorem fd_ulong_align_up.call_eq (x a : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (ha : a ≠ 0x8000000000000000#64) :
    fd_ulong_align_up.call (fd_ulong_align_up.args (.value x) (.value a)) s =
      .value (.cons (.value (fd_ulong_align_up.spec x a)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  step_pure [neg_ssubOverflow ha]
  finish_block
  rw [hS, spec, show x + 18446744073709551615#64 + a = x + (a - 1) by bv_decide]

theorem cpop_lt_two {x : BitVec 64} (hx : x ≠ 0) :
    BitVec.setWidth 32 (BitVec.ofBool (x.cpop.ult 2#64)) = fd_ulong_is_pow2.spec x := by
  unfold fd_ulong_is_pow2.spec
  split <;> bv_decide

/-- The lift tests `popcount x < 2`, which is the C test only for `x ≠ 0` (its one caller's
range). -/
public theorem fd_ulong_is_pow2.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hx : x ≠ 0) :
    fd_ulong_is_pow2.call (fd_ulong_is_pow2.args (.value x)) s =
      .value (.cons (.value (fd_ulong_is_pow2.spec x)) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  finish_block
  rw [hS, cpop_lt_two hx]

/-- The lift is specialised to `a = 128`. -/
public theorem fd_ulong_is_aligned.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_is_aligned.call (fd_ulong_is_aligned.args (.value x)) s =
      .value (.cons (.value (fd_ulong_is_aligned.spec x 128)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  finish_block
  rw [hS, spec]
  congr 3; split <;> bv_decide

public theorem fd_ulong_is_aligned_56.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_is_aligned_56.call (fd_ulong_is_aligned_56.args (.value x)) s =
      .value (.cons (.value (fd_ulong_is_aligned.spec x 128)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  finish_block
  rw [hS, fd_ulong_is_aligned.spec]
  congr 3; split <;> bv_decide

/-- The lift is specialised to `b = 512`. -/
public theorem fd_ulong_min.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_min.call (fd_ulong_min.args (.value x)) s =
      .value (.cons (.value (fd_ulong_min.spec x 512)) .nil, s) := by
  func_init
  block_init
  iterate 2 step_pure
  finish_block
  rw [hS, spec]
  congr 3; split <;> bv_decide

public theorem fd_ulong_if.call_eq (c : BitVec 32) (a b : BitVec 64) (s : GlobalState)
    (hwf : s.WF) :
    fd_ulong_if.call (fd_ulong_if.args (.value c) (.value a) (.value b)) s =
      .value (.cons (.value (fd_ulong_if.spec c a b)) .nil, s) := by
  func_init
  block_init
  iterate 3 step_pure
  finish_block
  rw [hS, spec]
  congr 3; split <;> bv_decide

end Proof

end MLIR.Firedancer.Crc.Ref

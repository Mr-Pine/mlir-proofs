module

public import MLIR.Run.Tactic
public import Sodium.crypto_verify_n
public import Sodium.Mlir.crypto_verify_32

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `crypto_verify_32(x, y)`: `0` if the 32 bytes at `x` and at `y` agree, `-1` if not; memory
unchanged, the counter advanced by `crypto_verify_n`'s six locals. -/
public theorem crypto_verify_32.call_eq (x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hx : Fits s.mem x 256) (hy : Fits s.mem y 256) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crypto_verify_32.call (crypto_verify_32.args (.value x) (.value y)) s =
      .value
        (.cons (.value (if s.mem.readAt x 256 = s.mem.readAt y 256 then 0#32 else -1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_call using crypto_verify_n.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Sodium

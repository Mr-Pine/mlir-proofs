module

public import MLIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.fiat_25519_from_bytes
public import Firedancer.Ref.Mlir.fd_f25519_frombytes

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The 32 little-endian bytes `buf` as a field element's limbs, bit 255 dropped. -/
def fd_f25519_frombytes.spec (buf : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_from_bytes.spec buf

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_frombytes` stores `spec` of the 32 bytes at `buf` as limbs at `r`, and returns `r`;
`r` may alias `buf`. -/
public theorem fd_f25519_frombytes.call_eq (r buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsFit r) (hbuf : Fits s.mem buf (8 * 32))
    (hbuf_off : ¬buf.offset.uaddOverflow 32#64) :
    fd_f25519_frombytes.call (fd_f25519_frombytes.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeLimbs r (fd_f25519_frombytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  block_init
  step_call using fiat_25519_from_bytes.call_eq
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.Ref

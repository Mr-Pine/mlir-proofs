module

public import MLIR.Run.Tactic
public import Boringssl.BCM_sha512_init
public import Boringssl.Mlir.SHA512_Init

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `SHA512_Init` sets up the struct at `c` as `BCM_sha512_init` does and returns `1`. -/
public theorem SHA512_Init.call_eq (c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem c 1664) (hco : ¬c.offset.uaddOverflow 208#64) :
    SHA512_Init.call (SHA512_Init.args (.value c)) s =
      .value
        (.cons (.value 1#32) .nil,
          { s with mem := s.mem.storeShaCtx c (BCM_sha512_init.spec (s.mem.readShaCtx c)) }) := by
  func_init
  block_init
  step_pure
  step_call using BCM_sha512_init.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl

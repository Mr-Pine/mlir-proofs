module

public import MLIR.Run.Tactic
public import Boringssl.BCM_sha512_update
public import Boringssl.Mlir.SHA512_Update

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

open BCM_sha512_update in
/-- `SHA512_Update` appends the `len` bytes at `data` to the struct at `c` as `BCM_sha512_update`
does and returns `1`. -/
public theorem SHA512_Update.call_eq (c data : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hc : s.mem.ShaCtxFit c) (hv : (s.mem.readShaCtx c).Valid)
    (hdata : Fits s.mem data (8 * len.toNat)) (hdo : ¬data.offset.uaddOverflow len)
    (hsep : data.id ≠ c.id) (hlen63 : len.toNat < 2 ^ 63) :
    SHA512_Update.call (SHA512_Update.args (.value c) (.value data) (.value len)) s =
      .value
        (.cons (.value 1#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2 * cores (s.mem.readShaCtx c) len⟩,
            mem :=
              s.mem.storeShaCtx c
                (BCM_sha512_update.spec (s.mem.readShaCtx c) len
                  (s.mem.readAt data (8 * len.toNat))) }) := by
  func_init
  block_init
  step_pure
  step_call using BCM_sha512_update.call_eq consuming hv
  finish_block
  subst hS
  erase_frame

end Proof

end MLIR.Boringssl

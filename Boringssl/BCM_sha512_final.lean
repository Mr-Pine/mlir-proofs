module

public import MLIR.Run.Tactic
public import Boringssl.sha512_final_impl
public import Boringssl.Mlir.BCM_sha512_final

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

open sha512_final_impl in
/-- `BCM_sha512_final` finishes the struct at `c` (`sha512_final_impl` with its `md_len`, `64` as
`BCM_sha512_init` sets it), stores the 64-byte digest at `out` and returns `0` (`approved`). -/
public theorem BCM_sha512_final.call_eq (out c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hc : s.mem.ShaCtxFit c) (hv : (s.mem.readShaCtx c).Valid)
    (hmd : (s.mem.readShaCtx c).mdLen = 64#16) (hout : s.mem.Words8Room out)
    (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ c.id) :
    BCM_sha512_final.call (BCM_sha512_final.args (.value out) (.value c)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (2 * cores (s.mem.readShaCtx c) + 10)⟩,
            mem :=
              (s.mem.storeShaCtx c (sha512_final_impl.spec (s.mem.readShaCtx c))).storeWords8 out
                ((sha512_final_impl.spec (s.mem.readShaCtx c)).h.map
                  Firedancer.Ref.fd_ulong_bswap.spec) }) := by
  func_init
  have hco : ¬c.offset.uaddOverflow 208#64 := hc.1
  have hmd₀ : (S₀.mem.readShaCtx c).mdLen = 64#16 := hS ▸ hmd
  have hlen : S₀.mem.readAt (c.add 66#64) 16 = 64#16 := by
    rw [← MemoryState.readShaCtx_mdLen (hS ▸ hc).2.1.inBounds hco, hmd₀]
  clear hmd
  block_init
  step_pure
  step_pure
  step_load [hlen]
  step_pure
  step_call using sha512_final_impl.call_eq consuming hv
  finish_block
  rw [hS, MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]

end Proof

end MLIR.Boringssl

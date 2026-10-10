module

public import MLIR.Run.Tactic
public import Boringssl.BCM_sha512_final
public import Boringssl.Mlir.SHA512_Final

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

open sha512_final_impl in
/-- `SHA512_Final` finishes the struct at `c` as `BCM_sha512_final` does, the 64-byte digest at
`out` (not null: it has room), and returns `1`. -/
public theorem SHA512_Final.call_eq (out c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hc : s.mem.ShaCtxFit c) (hv : (s.mem.readShaCtx c).Valid)
    (hmd : (s.mem.readShaCtx c).mdLen = 64#16) (hout : s.mem.Words8Room out)
    (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ c.id) :
    SHA512_Final.call (SHA512_Final.args (.value out) (.value c)) s =
      .value
        (.cons (.value 1#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (2 * cores (s.mem.readShaCtx c) + 10)⟩,
            mem :=
              (s.mem.storeShaCtx c (sha512_final_impl.spec (s.mem.readShaCtx c))).storeWords8 out
                ((sha512_final_impl.spec (s.mem.readShaCtx c)).h.map
                  Firedancer.Ref.fd_ulong_bswap.spec) }) := by
  have hnn : (out == Pointer.null) = false := by
    have := hwf.ne_null_of_inBounds hout.2.1.inBounds
    simp only [beq_eq_false_iff_ne, ne_eq]
    exact fun h => this (congrArg Pointer.id h)
  func_init
  block_init
  iterate 3 step_pure
  -- if (out == nullptr) return 0;
  step_pure [hnn]
  finish_block
  block_init
  step_call using BCM_sha512_final.call_eq consuming hv hmd
  finish_block
  block_init
  finish_block
  rw [hS, MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]

end Proof

end MLIR.Boringssl

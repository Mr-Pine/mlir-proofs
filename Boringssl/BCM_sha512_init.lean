module

public import MLIR.Run.Tactic
public import Boringssl.Common.Sha512
public import Firedancer.Ref.fd_sha512_init
public import Boringssl.Mlir.BCM_sha512_init
import Std.Tactic.BVDecide

namespace MLIR.Boringssl

open Memory

/-! ## Specification -/

@[expose] public section

/-- `h` set to SHA-512's initial hash value (Firedancer's `sha512IV`, the same constants), nothing
counted or buffered, `md_len = SHA512_DIGEST_LENGTH`; `p` as it was. -/
def BCM_sha512_init.spec (v : Sha512Ctx) : Sha512Ctx :=
  { v with
    h := Firedancer.Ref.sha512IV, num := 0#16, mdLen := 64#16, hi := 0#32, lo := 0#64 }

end

/-! ## Proof -/

section Proof

/-- `BCM_sha512_init` sets up the struct at `c` (`spec`, its `p` kept, defined or not) and returns
`0` (`approved`). -/
public theorem BCM_sha512_init.call_eq (c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem c 1664) (hco : ¬c.offset.uaddOverflow 208#64) :
    BCM_sha512_init.call (BCM_sha512_init.args (.value c)) s =
      .value
        (.cons (.value 0#32) .nil,
          { s with mem := s.mem.storeShaCtx c (BCM_sha512_init.spec (s.mem.readShaCtx c)) }) := by
  func_init
  have hroom₀ : Room S₀.mem c 1664 := hS ▸ hroom
  block_init
  iterate 12 step_pure
  -- sha->h[0 … 7] = …;
  step_store
  iterate 7
    step_pure
    step_store
  -- sha->bytes_so_far_low = 0; sha->bytes_so_far_high = 0; sha->num = 0; sha->md_len = 64;
  iterate 4
    step_pure
    step_store
  finish_block
  rw [hS]
  congr 3
  generalize hx : S₀.mem.readAt c 1664 = X
  generalize hd : S₀.mem.definedAt c 1664 = D
  have hm : S₀.mem = S₀.mem.overlay c X D := by
    rw [← hx, ← hd, MemoryState.overlay_readAt_definedAt hroom₀.inBounds]
  have e (m' : MemoryState) (x : BitVec 64) : m'.storeAt c x = m'.storeAt (c.add 0#64) x := by
    rw [Pointer.add_zero]
  rw [MemoryState.readShaCtx, hx, hd, MemoryState.storeShaCtx]
  conv_lhs => rw [hm, e]
  simp (disch :=
    first
    | decide
    | exact Pointer.not_uaddOverflow_of_ctx hco (by decide)) only [MemoryState.overlay_storeAt_add]
  congr 1 <;>
    simp only [BCM_sha512_init.spec, Sha512Ctx.ofBits, Sha512Ctx.bits, Sha512Ctx.low,
      Sha512Ctx.defs, Firedancer.Ref.sha512IV, spliceBits_eq, BitVec.toNat_ofNat,
      reduceGetElemLit] <;>
    bv_decide

/-- `init` leaves nothing buffered. -/
public theorem BCM_sha512_init.spec_valid (v : Sha512Ctx) : (BCM_sha512_init.spec v).Valid :=
  ⟨show (0#16).toNat < 128 by decide, Sha512Ctx.prefix_zero _⟩

end Proof

end MLIR.Boringssl

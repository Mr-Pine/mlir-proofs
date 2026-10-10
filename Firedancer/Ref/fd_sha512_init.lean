module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Mlir.fd_sha512_init

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- SHA-512's initial hash value `H⁽⁰⁾`, `fd_sha512_private.state`. -/
def sha512IV : Vector (BitVec 64) 8 :=
  #v[0x6a09e667f3bcc908#64, 0xbb67ae8584caa73b#64, 0x3c6ef372fe94f82b#64, 0xa54ff53a5f1d36f1#64,
    0x510e527fade682d1#64, 0x9b05688c2b3e6c1f#64, 0x1f83d9abfb41bd6b#64, 0x5be0cd19137e2179#64]

end

/-! ## Proof -/

section Proof

/-- `fd_sha512_init` stores `sha512IV` at `state` (byte `128`) and zeroes `buf_used`, `bit_cnt_lo`
and `bit_cnt_hi` (bytes `200 … 223`), and returns `sha`. -/
public theorem fd_sha512_init.call_eq (sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hroom : Room s.mem sha (8 * 256)) (hoff : ¬sha.offset.uaddOverflow 256#64) :
    fd_sha512_init.call (fd_sha512_init.args (.value sha)) s =
      .value
        (.cons (.value sha) .nil,
          { s with
            mem :=
              ((((((((s.mem.storeAt (sha.add 128#64) sha512IV[0]).storeAt (sha.add 136#64)
                                            sha512IV[1]).storeAt
                                        (sha.add 144#64) sha512IV[2]).storeAt
                                    (sha.add 152#64) sha512IV[3]).storeAt
                                (sha.add 160#64) sha512IV[4]).storeAt
                            (sha.add 168#64) sha512IV[5]).storeAt
                        (sha.add 176#64) sha512IV[6]).storeAt
                    (sha.add 184#64) sha512IV[7]).storeAt
                (sha.add 200#64) ((0#8).replicate 24) }) := by
  func_init
  block_init
  -- the constants
  iterate 10 step_pure
  -- `state[0 … 7]`: each word's address, then the word
  iterate 8 
    step_pure
    step_store
  -- `buf_used`'s address; next, the `memset` of `buf_used … bit_cnt_hi` (no `step_memset` yet) and
  -- the return
  step_pure
  step_memset
  finish_block
  simp [hS]
  rfl

end Proof

end MLIR.Firedancer.Ref

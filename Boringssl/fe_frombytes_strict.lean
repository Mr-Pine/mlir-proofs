module

public import MLIR.Run.Tactic
public import Boringssl.fiat_25519_from_bytes
public import Boringssl.Mlir.fe_frombytes_strict

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_frombytes_strict` stores the 32 bytes at `buf` as limbs at `h`
(`fiat_25519_from_bytes.spec`); bit 255 must be clear. `h` may alias the bytes. -/
public theorem fe_frombytes_strict.call_eq (h buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hbuf : Fits s.mem buf (8 * 32))
    (hbuf_off : ¬buf.offset.uaddOverflow 32#64) (hmsb : (s.mem.readAt buf 256).msb = false) :
    fe_frombytes_strict.call (fe_frombytes_strict.args (.value h) (.value buf)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_from_bytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  block_init
  step_call using fiat_25519_from_bytes.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl

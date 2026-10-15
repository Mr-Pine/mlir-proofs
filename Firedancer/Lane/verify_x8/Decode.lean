module

public import Firedancer.Lane.verify_x8.Defs

/-! `fd_ed25519_lane_decode2` inlined into `verify_x8` (`^bb38 … ^bb41`): `d` and `sqrtm1`
broadcast, the first loop (`^bb40`, `n = 0, 1`), `fd_ed25519_lane_pow22523_2` (`^bb39`), the
second loop (`^bb41`, `n = 0, 1`). -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `fd_ed25519_lane_decode2( &a, a_buf, &a_valid, &r, r_buf, &r_valid )`: the decodings at `a`
and `r`, the masks in registers. -/
public theorem decode_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env38 c E) (hS : c.At38 S)
    (h42 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env42 c E' → c.At42 S' →
        ((verify_x8 c.batch).runFrom E' 42 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 38 S >>= g) = K := by
  sorry

end MLIR.Firedancer.Lane.VerifyX8

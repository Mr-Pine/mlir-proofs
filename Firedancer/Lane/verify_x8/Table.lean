module

public import Firedancer.Lane.verify_x8.TableA
public import Firedancer.Lane.verify_x8.TableB2
public import Firedancer.Lane.verify_x8.TableB3
public import Firedancer.Lane.verify_x8.TableB4
public import Firedancer.Lane.verify_x8.TableB5
public import Firedancer.Lane.verify_x8.TableB6
public import Firedancer.Lane.verify_x8.TableB7
public import Firedancer.Lane.verify_x8.TableB8
public import Firedancer.Lane.verify_x8.TableT

/-! `fd_ed25519_lane_verify`'s table inlined into `verify_x8` (`^bb79`): `k2d` broadcast, the nine
entries `[e](-A)` stored into `ktab` by `fd_ed25519_lane_to_niels` (inlined) and
`fd_ed25519_lane_point_dbl`/`_add`, then `acc` zeroed. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb79`: `ktab`, `acc = 0`. -/
public theorem table_run (c : Call) (_hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env79 c E) (hS : c.At79 S)
    (h83 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env83 c E' → c.At83 S' →
        ((verify_x8 c.batch).runFrom E' 83 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 79 S >>= g) = K := by
  have hp : Ptrs c (c.s.slot 3) (c.s.slot 4) (c.s.slot 5) (c.s.slot 6) (c.s.slot 7) (c.s.slot 8)
      (c.s.slot 9) (c.s.slot 10) (c.s.slot 11) (c.s.slot 28) :=
    ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩
  have h0 : StT0 c S.mem (c.s.slot 3) (c.s.slot 4) (c.s.slot 5) (c.s.slot 6) (c.s.slot 7)
      (c.s.slot 8) (c.s.slot 9) (c.s.slot 10) (c.s.slot 11) (c.s.slot 28) S :=
    ⟨hS.base.wf, MemoryState.FrameOn.refl _, hS.base.slots 3 (by decide), hS.base.writable 3 (by
      decide), hS.base.slots 4 (by decide), hS.base.writable 4 (by decide), hS.base.slots 5 (by
      decide), hS.base.writable 5 (by decide), hS.base.slots 6 (by decide), hS.base.writable 6 (by
      decide), hS.base.slots 7 (by decide), hS.base.writable 7 (by decide), hS.base.slots 8 (by
      decide), hS.base.writable 8 (by decide), hS.base.slots 9 (by decide), hS.base.writable 9 (by
      decide), hS.base.slots 10 (by decide), hS.base.writable 10 (by decide), hS.base.slots 11 (by
      decide), hS.base.writable 11 (by decide), hS.a.fit, hS.a.read⟩
  block_init
  change (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 0 S >>= G79 c g) = K
  refine segA c S.mem _ _ _ _ _ _ _ _ _ _ hp E S hA hE h0 fun E1 S1 hA1 hE1 hS1 => ?_
  refine segB2 c S.mem _ _ _ _ _ _ _ _ _ _ hp E1 S1 hA1 hE1 hS1 fun E2 S2 hA2 hE2 hS2 => ?_
  refine segB3 c S.mem _ _ _ _ _ _ _ _ _ _ hp E2 S2 hA2 hE2 hS2 fun E3 S3 hA3 hE3 hS3 => ?_
  refine segB4 c S.mem _ _ _ _ _ _ _ _ _ _ hp E3 S3 hA3 hE3 hS3 fun E4 S4 hA4 hE4 hS4 => ?_
  refine segB5 c S.mem _ _ _ _ _ _ _ _ _ _ hp E4 S4 hA4 hE4 hS4 fun E5 S5 hA5 hE5 hS5 => ?_
  refine segB6 c S.mem _ _ _ _ _ _ _ _ _ _ hp E5 S5 hA5 hE5 hS5 fun E6 S6 hA6 hE6 hS6 => ?_
  refine segB7 c S.mem _ _ _ _ _ _ _ _ _ _ hp E6 S6 hA6 hE6 hS6 fun E7 S7 hA7 hE7 hS7 => ?_
  refine segB8 c S.mem _ _ _ _ _ _ _ _ _ _ hp E7 S7 hA7 hE7 hS7 fun E8 S8 hA8 hE8 hS8 => ?_
  exact segT c S hS.base hS.kd_fits hS.kd_read hS.sd_fits hS.sd_read hS.r _ _ _ _ _ _ _ _ _ _ hp
    E8 S8 hA8 hE8 hS8 h83

end MLIR.Firedancer.Lane.VerifyX8

module

public import MLIR.Run.Tactic
import Firedancer.Common.Tactics
public import Firedancer.R52x5.fd_ed25519_point_from
public import Firedancer.R52x5.Mlir.fd_mlir_ed25519_point_from

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_mlir_ed25519_point_from` is `fd_ed25519_point_from`. -/
public theorem fd_mlir_ed25519_point_from.call_eq (r x y z t : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.Quad5Room r) (hx : Fits s.mem x 512) (hy : Fits s.mem y 512)
    (hz : Fits s.mem z 512) (ht : Fits s.mem t 512) :
    fd_mlir_ed25519_point_from.call
        (fd_mlir_ed25519_point_from.args (.value r) (.value x) (.value y) (.value z) (.value t)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              s.mem.storeQuad5 r
                (Quad5.pack (s.mem.readVec x) (s.mem.readVec y) (s.mem.readVec z)
                  (s.mem.readVec t)) }) := by
  func_init
  block_init
  step_call using fd_ed25519_point_from.call_eq
  finish_block
  clear_reads
  subst hS
  erase_frame

end Proof

end MLIR.Firedancer.R52x5

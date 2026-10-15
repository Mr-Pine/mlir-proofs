module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split
public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

open Split in
/-- `fd_ed25519_double_scalar_mul_base_split` stores `double_scalar_mul_base_split.spec` of the
split tables at `ta`, `tb` and the scalars at `n1`, `n2` at `r` and returns `r`: the split
multiplication without the decode steps. `r` lies outside the tables; the scalars may alias it. Its
frame is `double_scalar_mul_base_split`'s six blocks. -/
public theorem fd_ed25519_double_scalar_mul_base_split.call_eq (r n1 ta n2 tb : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg :
      s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split.globals)
    (hr : s.mem.QuadRoom r) (hn1 : Fits s.mem n1 (8 * 32)) (hn2 : Fits s.mem n2 (8 * 32))
    (hta : Fits s.mem ta (1536 * 32)) (htao : ta.offset.toNat + 192 * 32 < 2 ^ 64)
    (htb : Fits s.mem tb (1536 * 896)) (htbo : tb.offset.toNat + 192 * 896 < 2 ^ 64)
    (hrta : r.id ≠ ta.id) (hrtb : r.id ≠ tb.id) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split.args (.value r)
          (.value n1) (.value ta) (.value n2) (.value tb)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              s.mem.storeQuad r
                (double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
                  (s.mem.readAt n1 256) (s.mem.readAt n2 256)) }) := by
  generalize hP :
    double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
      (s.mem.readAt n1 256) (s.mem.readAt n2 256) = P
  func_init
  block_init
  step_pure
  step_call using double_scalar_mul_base_split.call_eq
  finish_block
  rw [hS, ← hP]
  dsimp only
  erase_frame

end Proof

end MLIR.Firedancer.Lane

module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split
public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

open Split in
/-- `fd_ed25519_double_scalar_mul_base_split_decode` stores `double_scalar_mul_base_split.spec` of
the split tables at `ta`, `tb` and the scalars at `n1`, `n2` at `r`, advances the decode state `D`
at `dec` by `specDec`'s steps, and returns `r`. `r` lies outside the tables and `dec`; the scalars
may alias it. Its frame is `double_scalar_mul_base_split`'s six blocks. -/
public theorem fd_ed25519_double_scalar_mul_base_split_decode.call_eq (r n1 ta n2 tb dec : Pointer)
    (D : DecSt) (s : GlobalState) (hwf : s.WF)
    (hg :
      s.mem.Globals
        _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode.globals)
    (hr : s.mem.QuadRoom r) (hn1 : Fits s.mem n1 (8 * 32)) (hn2 : Fits s.mem n2 (8 * 32))
    (hta : Fits s.mem ta (1536 * 32)) (htao : ta.offset.toNat + 192 * 32 < 2 ^ 64)
    (htb : Fits s.mem tb (1536 * 896)) (htbo : tb.offset.toNat + 192 * 896 < 2 ^ 64)
    (hrta : r.id ≠ ta.id) (hrtb : r.id ≠ tb.id) (hdr : s.mem.DecRoom dec)
    (hD : s.mem.DecHolds dec D) (hOk : D.Ok) (hrd : r.id ≠ dec.id) (hdta : dec.id ≠ ta.id)
    (hdtb : dec.id ≠ tb.id) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode.args
          (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              (s.mem.storeDec dec
                  (double_scalar_mul_base_split.specDec (s.mem.readAt n1 256) (s.mem.readAt n2 256)
                    D)).storeQuad r
                (double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
                  (s.mem.readAt n1 256) (s.mem.readAt n2 256)) }) := by
  generalize hP :
    double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
      (s.mem.readAt n1 256) (s.mem.readAt n2 256) = P
  generalize hPD :
    double_scalar_mul_base_split.specDec (s.mem.readAt n1 256) (s.mem.readAt n2 256) D = PD
  func_init
  block_init
  step_call using double_scalar_mul_base_split.call_eq_dec consuming hwf hD hdr hr hg
  finish_block
  rw [hS, ← hP, ← hPD]
  dsimp only
  erase_frame

end Proof

end MLIR.Firedancer.Lane

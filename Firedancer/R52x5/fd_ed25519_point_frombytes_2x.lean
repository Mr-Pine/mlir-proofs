module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_r52x5_ge_decode2
public import Firedancer.R52x5.Mlir.fd_ed25519_point_frombytes_2x

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_frombytes_2x( r1, buf1, r2, buf2 )`: `FD_R52X5_GE_DECODE2` of the encodings,
into `r1->P` and `r2->P`. -/
abbrev fd_ed25519_point_frombytes_2x.spec (e1 e2 : BitVec 256) : BitVec 32 × Option Quad5 × Quad5 :=
  fd_r52x5_ge_decode2.spec e1 e2

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_frombytes_2x` stores `spec`'s points of the encodings at `buf1` and `buf2`
at `r1` (when the first decodes), then `r2`, and returns its value. -/
public theorem fd_ed25519_point_frombytes_2x.call_eq (r1 buf1 r2 buf2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.Quad5Room r1) (hr2 : s.mem.Quad5Room r2) (hb1 : Fits s.mem buf1 256)
    (hb2 : Fits s.mem buf2 256) (hb1_off : ¬buf1.offset.uaddOverflow 32#64)
    (hb2_off : ¬buf2.offset.uaddOverflow 32#64) :
    fd_ed25519_point_frombytes_2x.call
        (fd_ed25519_point_frombytes_2x.args (.value r1) (.value buf1) (.value r2) (.value buf2)) s =
      let R := fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + fd_r52x5_ge_decode2.blocks R.1⟩,
            mem :=
              (match R.2.1 with
                  | none => s.mem
                  | some P => s.mem.storeQuad5 r1 P).storeQuad5
                r2 R.2.2 }) := by
  generalize hR :
    fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256) = R
  func_init
  block_init
  iterate 8 step_pure
  step_call using
    (fd_r52x5_ge_decode2.call_eq _ _ _ _ _ _ _ _ _ _ _ _ _ hwf
      ⟨hr1.room_0, hr1.room_1, hr1.room_2, hr1.room_3, hr1.room_4, hr2.room_0, hr2.room_1,
        hr2.room_2, hr2.room_3, hr2.room_4⟩
      hb1 hb2 hb1_off hb2_off) consuming
    hwf hr1 hr2 hb1 hb2
  finish_block
  rw [hS]
  simp only [hR]
  obtain ⟨r, P, Q⟩ := R
  cases P <;>
    simp only [fd_r52x5_ge_decode2.storeOut, MemoryState.storeQuad5,
      MemoryState.eraseFrom_storeTmp5, hwf₀.eraseFrom]

end Proof

end MLIR.Firedancer.R52x5

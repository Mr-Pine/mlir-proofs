module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack
public import Firedancer.Avx512.fd_r43x6_unpack
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack_23
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack_49
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack_51
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack_92
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `perm`'s byte indices, as the shuffle's mask. -/
theorem fd_r43x6_unpack.perm_idx :
    permutexvarIdx
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f) =
      #v[0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16,
        17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63,
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63] := by
  ext i hi : 1
  simp only [permutexvarIdx, wwl, Vector.getElem_ofFn]
  revert i; decide

/-- `fd_r43x6_unpack` returns `spec u` and leaves the state as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call_eq (u : Wv)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_unpack.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) := by
  func_init
  block_init
  -- the constants, `_mm512_inserti64x4( zero, u, 0 )`, its bytes and their shuffle
  iterate 10 step_pure
  -- back to lanes: `_mm512_permutexvar_epi8( perm, … )`, its poison tests decided
  step_pure with b
  -- `wwl_shru_vector( …, rshift )`, `wwl_and( …, mask )`
  step_pure [expandOfFn]
  step_pure [expandOfFn] with r
  finish_block
  have e :
      b = mm512_permutexvar_epi8
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f)
        (mm512_inserti64x4 wwl_zero u) := by
    rw [hb, mm512_permutexvar_epi8, permutexvarBytes, fd_r43x6_unpack.perm_idx]
    simp [mlir_operation, mm512_inserti64x4]
  suffices h : r = fd_r43x6_unpack.spec u by rw [hS, h]
  rw [hr, fd_r43x6_unpack.spec, ← e]
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp [wwl_and, wwl_shru_vector, wwl, wwl_bcast]

/-- `fd_r43x6_unpack_23` is `fd_r43x6_unpack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_unpack_23.call_eq (u : Wv)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_unpack_23.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_unpack_23.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call_eq u s hwf

/-- `fd_r43x6_unpack_49` is `fd_r43x6_unpack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_unpack_49.call_eq (u : Wv)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_unpack_49.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_unpack_49.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call_eq u s hwf

/-- `fd_r43x6_unpack_51` is `fd_r43x6_unpack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_unpack_51.call_eq (u : Wv)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_unpack_51.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_unpack_51.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call_eq u s hwf

/-- `fd_r43x6_unpack_92` is `fd_r43x6_unpack` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_r43x6_unpack_92.call_eq (u : Wv)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_r43x6_unpack_92.call
        (Firedancer.LaneNI.Mlir.fd_r43x6_unpack_92.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) :=
  Firedancer.LaneNI.Mlir.fd_r43x6_unpack.call_eq u s hwf

end Proof

end MLIR.Firedancer.LaneNI

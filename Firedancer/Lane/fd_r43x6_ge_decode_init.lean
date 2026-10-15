module

public import Firedancer.Lane.fd_r43x6_ge_decode2
public import Firedancer.Lane.Common.DecodeStaged
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_init
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane.fd_r43x6_ge_decode_init

open Firedancer.Avx512
open Firedancer.Avx512.fd_r43x6_ge_decode2 (d pSubOne)

-- the entry block in one walk: some 80 steps and patterns, over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_ge_decode_init( st, buf )` stores `DecSt.init` of the encoding at `buf` at `st`. -/
public theorem call_eq (st buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hbuf : Fits s.mem buf 256) (hbo : ¬buf.offset.uaddOverflow 32#64) (hst : s.mem.DecRoom st) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_init.call
        (_root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode_init.args (.value st) (.value buf)) s =
      .value (.nil, { s with mem := s.mem.storeDec st (DecSt.init (s.mem.readAt buf 256)) }) := by
  obtain ⟨hov, hroom⟩ := hst
  -- folded for `func_init`, whose frame-free check would unfold it
  generalize hD : DecSt.init (s.mem.readAt buf 256) = D
  func_init
  have hbuf₀ : Fits S₀.mem buf 256 := hS ▸ hbuf
  have hb24 : ¬buf.offset.uaddOverflow 24#64 := BitVec.not_uaddOverflow_of_le hbo (by decide)
  have hs448 : ¬st.offset.uaddOverflow 448#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs512 : ¬st.offset.uaddOverflow 512#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs576 : ¬st.offset.uaddOverflow 576#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs640 : ¬st.offset.uaddOverflow 640#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs128 : ¬st.offset.uaddOverflow 128#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs64 : ¬st.offset.uaddOverflow 64#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs704 : ¬st.offset.uaddOverflow 704#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs712 : ¬st.offset.uaddOverflow 712#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  have hs720 : ¬st.offset.uaddOverflow 720#64 := BitVec.not_uaddOverflow_of_le hov (by decide)
  block_init
  iterate 45 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  step_pure
  step_pure
  step_load with y3
  step_load with ld
  step_pure
  step_pure [Avx512.fd_r43x6_ge_decode2.shr63_trunc] with x0
  step_store
  step_pure with ua
  step_pattern using runBodyFrom_unpackRun with y
  step_pattern using runBodyFrom_sqrRunNW (hX := unpack_lt _) with ysq
  step_pattern using runBodyFrom_subRunB with u
  step_pattern using runBodyFrom_mulRowsRun d with dysq
  step_pure with v
  step_pattern using runBodyFrom_r43SqrRun with v2
  step_pattern using runBodyFrom_r43SqrRun with v4
  step_pattern using runBodyFrom_mulRun with v3
  step_pattern using runBodyFrom_mulRun with uv3
  step_pattern using runBodyFrom_mulRun with uv7
  step_pure
  step_store
  iterate 4 (step_pure; step_store)
  step_store
  iterate 3 (step_pure; step_store)
  finish_block
  have hy3' : y3 = (S₀.mem.readAt buf 256).extractLsb' 192 64 := by
    rw [hy3, MemoryState.readAt_add_of_readAt hbuf₀.inBounds hb24 (by decide) rfl]
    rfl
  rw [hld, decLanes_mask, ← hy3'] at hua
  rw [hS, MemoryState.storeDec_initOrder hov]
  clear hy3
  clear_reads
  subst_vars
  rfl

end MLIR.Firedancer.Lane.fd_r43x6_ge_decode_init

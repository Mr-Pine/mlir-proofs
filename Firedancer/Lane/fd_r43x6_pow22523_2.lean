module

public import Firedancer.Avx512.fd_r43x6_pow22523_2
public import Firedancer.Lane.Mlir.fd_r43x6_pow22523_2
public import Firedancer.Lane.fd_r43x6_repsqr_mul2
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- A `fd_r43x6_repsqr_mul2` call on the loads of `a` and `b`, their slots' facts dropped. -/
local macro "repsqr_mul2 " a:ident b:ident : tactic =>
  let h (x : Lean.Ident) (suf : String) := Lean.mkIdent (.mkSimple s!"hread__{x.getId}{suf}")
  let slot (x : Lean.Ident) := Lean.mkIdent (.mkSimple s!"_{x.getId}")
  `(tactic|
    ( step_load with $a:ident consuming $(h a "") $(h a "_readAt")
      step_load with $b:ident consuming $(h b "") $(h b "_readAt")
      clear_facts $(slot a) $(slot b)
      step_call using fd_r43x6_repsqr_mul2.call_eq))

-- the eighteen temporaries' facts through every step, and the four inlined runs: over 300000
-- heartbeats
set_option maxHeartbeats 500000 in
/-- `fd_r43x6_pow22523_2` stores `spec za` at `_za`, then `spec zb` at `_zb`; its `18`
temporaries are freed again, the counter moves on by `18` blocks. -/
public theorem fd_r43x6_pow22523_2.call_eq (_za _zb : Pointer) (za zb : Wwl) (s : GlobalState)
    (hwf : s.WF) (h_za : Room s.mem _za 512) (h_zb : Room s.mem _zb 512) :
    Firedancer.Lane.Mlir.fd_r43x6_pow22523_2.call
        (Firedancer.Lane.Mlir.fd_r43x6_pow22523_2.args (.value _za) (Ty.wrap za) (.value _zb)
          (Ty.wrap zb))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 18⟩,
            mem :=
              (s.mem.storeVec _za (Avx512.fd_r43x6_pow22523_2.spec za)).storeVec _zb
                (Avx512.fd_r43x6_pow22523_2.spec zb) }) := by
  func_init
  block_init
  -- the constants, left inline: the patterns read them as literals
  iterate 33 step_pure
  -- the masks and the slides' zero operands, by `insertelement`s
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  -- the temporaries, one per `repsqr_mul2` output
  step_alloca with _z9a
  step_alloca with _z9b
  step_alloca with _z2e5m1a
  step_alloca with _z2e5m1b
  step_alloca with _z2e10m1a
  step_alloca with _z2e10m1b
  step_alloca with _z2e20m1a
  step_alloca with _z2e20m1b
  step_alloca with _z2e40m1a
  step_alloca with _z2e40m1b
  step_alloca with _z2e50m1a
  step_alloca with _z2e50m1b
  step_alloca with _z2e100m1a
  step_alloca with _z2e100m1b
  step_alloca with _z2e200m1a
  step_alloca with _z2e200m1b
  step_alloca with _z2e250m1a
  step_alloca with _z2e250m1b
  -- `FD_R43X6_SQR2_INL( z2a, za, z2b, zb )`
  step_pattern using runBodyFrom_sqrRunA with z2a
  step_pattern using runBodyFrom_sqrRunA with z2b
  -- `fd_r43x6_repsqr_mul2( &z9a, z2a, za, …, 2UL )`, `b` likewise
  iterate 2 step_pure
  step_call using fd_r43x6_repsqr_mul2.call_eq
  -- `fd_r43x6_repsqr_mul2( &z11a, z9a, z2a, …, 0UL )`, `b` likewise: no squaring, so inlined to
  -- `FD_R43X6_MUL2_INL`
  step_load with z9a consuming hread__z9a hread__z9a_readAt
  step_load with z9b consuming hread__z9b hread__z9b_readAt
  clear_facts _z9a _z9b
  step_pattern using runBodyFrom_mulRun with z11a
  step_pattern using runBodyFrom_mulRun with z11b
  -- `fd_r43x6_repsqr_mul2( &z2e5m1a, z11a, z9a, …, 1UL )`, `b` likewise
  iterate 2 step_pure
  step_call using fd_r43x6_repsqr_mul2.call_eq
  -- `fd_r43x6_repsqr_mul2( &z2e10m1a, z2e5m1a, z2e5m1a, …, 5UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e5m1a z2e5m1b
  -- `fd_r43x6_repsqr_mul2( &z2e20m1a, z2e10m1a, z2e10m1a, …, 10UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e10m1a z2e10m1b
  -- `fd_r43x6_repsqr_mul2( &z2e40m1a, z2e20m1a, z2e20m1a, …, 20UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e20m1a z2e20m1b
  -- `fd_r43x6_repsqr_mul2( &z2e50m1a, z2e40m1a, z2e10m1a, …, 10UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e40m1a z2e40m1b
  -- `fd_r43x6_repsqr_mul2( &z2e100m1a, z2e50m1a, z2e50m1a, …, 50UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e50m1a z2e50m1b
  -- `fd_r43x6_repsqr_mul2( &z2e200m1a, z2e100m1a, z2e100m1a, …, 100UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e100m1a z2e100m1b
  -- `fd_r43x6_repsqr_mul2( &z2e250m1a, z2e200m1a, z2e50m1a, …, 50UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z2e200m1a z2e200m1b
  -- `fd_r43x6_repsqr_mul2( _za, z2e250m1a, za, …, 2UL )`, `_zb` likewise
  repsqr_mul2 z2e250m1a z2e250m1b
  -- the lifetimes' ends
  iterate 18 step_pure
  finish_block
  simp [hS]
  erase_frame
  -- the frame: the slots' stores and blocks are erased
  delta Avx512.fd_r43x6_pow22523_2.spec
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane

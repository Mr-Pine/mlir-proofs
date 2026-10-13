module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Common.Tactics
public import Firedancer.Avx512.fd_r43x6_repsqr_mul2
public import Firedancer.Avx512.Mlir.fd_r43x6_pow22523_2

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `z^(2^252 - 3)`, as `fd_r43x6_pow22523_2` computes it on each argument. -/
@[irreducible]
def fd_r43x6_pow22523_2.spec (z : Wwl) : Wwl :=
  let repsqr_mul := fd_r43x6_repsqr_mul2.spec
  let z2 := fd_r43x6_sqr z
  let z9 := repsqr_mul z2 z 2
  let z11 := repsqr_mul z9 z2 0
  let z2e5m1 := repsqr_mul z11 z9 1
  let z2e10m1 := repsqr_mul z2e5m1 z2e5m1 5
  let z2e20m1 := repsqr_mul z2e10m1 z2e10m1 10
  let z2e40m1 := repsqr_mul z2e20m1 z2e20m1 20
  let z2e50m1 := repsqr_mul z2e40m1 z2e10m1 10
  let z2e100m1 := repsqr_mul z2e50m1 z2e50m1 50
  let z2e200m1 := repsqr_mul z2e100m1 z2e100m1 100
  let z2e250m1 := repsqr_mul z2e200m1 z2e50m1 50
  repsqr_mul z2e250m1 z 2

end

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

-- the twenty temporaries' facts, `Writable` ones among them, through every step: over 200000
-- heartbeats
set_option maxHeartbeats 400000 in
/-- `fd_r43x6_pow22523_2` stores `spec za` at `_za`, then `spec zb` at `_zb`; its `20`
temporaries are freed again, the counter moves on by `20` blocks. -/
public theorem fd_r43x6_pow22523_2.call_eq (_za _zb : Pointer) (za zb : Wwl) (s : GlobalState)
    (hwf : s.WF) (h_za : Room s.mem _za 512) (h_zb : Room s.mem _zb 512) :
    fd_r43x6_pow22523_2.call
        (fd_r43x6_pow22523_2.args (.value _za) (Ty.wrap za) (.value _zb) (Ty.wrap zb)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 20⟩,
            mem :=
              (s.mem.storeVec _za (fd_r43x6_pow22523_2.spec za)).storeVec _zb
                (fd_r43x6_pow22523_2.spec zb) }) := by
  func_init
  block_init
  -- the constants, left inline: the patterns read them as literals
  iterate 13 step_pure
  -- the temporaries, one per `repsqr_mul2` output
  step_alloca with _z9a
  step_alloca with _z9b
  step_alloca with _z11a
  step_alloca with _z11b
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
  -- `FD_R43X6_SQR2_INL( z2a, za, z2b, zb )`: `za`, `zb` are arguments, not `sqrInlRun`'s values
  step_call using fd_r43x6_sqr_fast.call_eq
  step_pattern using runBodyFrom_foldRun with z2a
  step_call using fd_r43x6_sqr_fast.call_eq
  step_pattern using runBodyFrom_foldRun with z2b
  -- `fd_r43x6_repsqr_mul2( &z9a, z2a, za, …, 2UL )`, `b` likewise
  iterate 2 step_pure
  step_call using fd_r43x6_repsqr_mul2.call_eq
  -- `fd_r43x6_repsqr_mul2( &z11a, z9a, z2a, …, 0UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z9a z9b
  -- `fd_r43x6_repsqr_mul2( &z2e5m1a, z11a, z9a, …, 1UL )`, `b` likewise
  iterate 2 step_pure
  repsqr_mul2 z11a z11b
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
  iterate 20 step_pure
  finish_block
  simp [hS]
  erase_frame
  -- the frame: the slots' stores and blocks are erased
  delta fd_r43x6_pow22523_2.spec
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512

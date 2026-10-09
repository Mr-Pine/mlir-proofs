module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_int_if
public import Firedancer.Avx512.Common.ExtractLimbs
public import Firedancer.Avx512.Common.ModNearlyReducedLimbs
public import Firedancer.Avx512.Mlir.fd_r43x6_diagnose
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_diagnose(x)`: `x` reduced; `-1` if it is zero, else its low bit. -/
@[irreducible]
def fd_r43x6_diagnose.spec (x : Wwl) : BitVec 32 :=
  let l := extractLimbs x
  -- `l` is signed
  let l := biasedCarryPropagateLimbs l (1 <<< 20)
  -- `l` is nearly reduced
  let l := modNearlyReducedLimbs l
  -- `l` is reduced; `fd_int_if( !(l0|l1|l2|l3|l4|l5), -1, (int)(l0 & 1L) )`
  if l.y0 ||| l.y1 ||| l.y2 ||| l.y3 ||| l.y4 ||| l.y5 = 0 then -1 else (l.y0 &&& 1).truncate 32

end

/-! ## Proof -/

section Proof

/-- `fd_r43x6_diagnose` returns `spec x` and leaves the state as it is. -/
public theorem fd_r43x6_diagnose.call_eq (x : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r43x6_diagnose.call (fd_r43x6_diagnose.args (Ty.wrap x)) s =
      .value (.cons (.value (fd_r43x6_diagnose.spec x)) .nil, s) := by
  func_init
  block_init
  -- the constants, left inline: the patterns read them as literals
  iterate 16 step_pure
  -- `fd_r43x6_extract_limbs( x, l )`
  step_pattern using runBodyFrom_extractLimbsRun with l5
  subst l5
  -- `fd_r43x6_biased_carry_propagate_limbs( l, l, 1L<<20 )`, up to its last two lines
  step_pattern using runBodyFrom_biasedCarryRun (B := 0x100000#64) with y4
  subst y4
  -- `fd_r43x6_mod_nearly_reduced_limbs( l, l )`: `y = x + 19`'s carries
  step_pattern using runBodyFrom_modAddRun with y4
  subst y4
  -- `fd_r43x6_biased_carry_propagate_limbs`'s `_y5 += _c; _y5 += _b`
  step_pattern using runBodyFrom_biasedCarryTailRun with l5
  have hl5 : l5 < 0x20000000000#64 := by
    rw [‹l5 = _›]
    exact (tail_no_overflow _ _ _ _ _ _ _ (by decide) (by decide)).2.2.2
  -- `fd_r43x6_mod_nearly_reduced_limbs`: the rest
  step_pattern using runBodyFrom_modSubRun with l5'
  -- `fd_int_if( !(l0|l1|l2|l3|l4|l5), -1, (int)(l0 & 1L) )`
  iterate 5 step_pure
  step_pure with ors
  step_pure with nz
  step_pure with nz32
  step_pure with l0_32
  step_pure with l0_1
  step_call using fd_int_if.call_eq with r
  finish_block
  subst_vars
  congr 4
  simp only [fd_r43x6_diagnose.spec, biasedCarryPropagateLimbs, modNearlyReducedLimbs_eq,
    BitVec.ofNat_eq_ofNat, m40, m43, show (1 <<< 20 : BitVec 64) = 1048576 from rfl]
  bv_decide (config := { enums := false })

end Proof

end MLIR.Firedancer.Avx512

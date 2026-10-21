module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_pow22523
public import Boringssl.fe_sq_tt
public import Boringssl.fe_mul_ttt
public import Boringssl.fe_sq_tl
public import Boringssl.fe_mul_tlt
public import Boringssl.Mlir.fe_loose_invert
public import Boringssl.Common.Pow

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref fd_f25519_pow22523 in
/-- The limbs stored at `out`: `lN` is the `N`-th call's (or loop's) result, of carried squares
(`fe_sq_tl`, `fe_sq_tt`) and products (`fe_mul_tlt`, `fe_mul_ttt`). The code keeps them in the
temporaries `t0 … t3`, reusing each. -/
def fe_loose_invert.spec (z : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let sq := fiat_25519_carry_square.spec
  let mul := fiat_25519_carry_mul.spec
  let l1 := sq z
  let l2 := sq l1
  let l3 := sq l2
  let l4 := mul z l3
  let l5 := mul l1 l4
  let l6 := sq l5
  let l7 := mul l4 l6
  let l8 := sq l7
  let l9 := sqrN 4 l8
  let l10 := mul l9 l7
  let l11 := sq l10
  let l12 := sqrN 9 l11
  let l13 := mul l12 l10
  let l14 := sq l13
  let l15 := sqrN 19 l14
  let l16 := mul l15 l13
  let l17 := sqrN 10 l16
  let l18 := mul l17 l10
  let l19 := sq l18
  let l20 := sqrN 49 l19
  let l21 := mul l20 l18
  let l22 := sq l21
  let l23 := sqrN 99 l22 -- `^bb1`
  let l24 := mul l23 l21
  let l25 := sqrN 50 l24
  let l26 := mul l25 l18
  let l27 := sqrN 5 l26
  mul l27 l5

end

/-! ## Proof -/

section Proof

-- the proof macros first: a macro defined between proofs waits for them

/-- A square, its result's limbs named `x`. -/
local macro "sqr " x:ident : tactic =>
  `(tactic|
    ( step_call using fe_sq_tt.call_eq
      name_limbs $x))

/-- A product, its result's limbs named `x`. -/
local macro "mul " x:ident : tactic =>
  `(tactic|
    ( step_call using fe_mul_ttt.call_eq
      name_limbs $x))

/-- `n + 1` in-place squarings, their result's limbs named `x`. -/
local macro "sqrs " x:ident " using " n:num : tactic =>
  `(tactic|
    ( step_pattern using (runBodyFrom_sqRun $n)
      name_limbs $x))

-- the step tactics simplify each new state with these: limb reads resolve through the stores
-- and `alloca`s
attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.readLimbs_alloca
  MemoryState.LimbsFit.storeLimbs

namespace fe_loose_invert

/-- The live registers at the loop's header `^bb1`, at counter `i`. -/
abbrev hdr (t0 t1 t2 t3 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%1613 := .value 1#32, %1614 := .value 100#32, %1615 := .value t0, %1616 := .value t1, %1617 :=
    .value t2, %1618 := .value t3, %1619 := .value (BitVec.ofNat 32 i)]

/-- The live registers at the loop's exit `^bb2`. -/
abbrev exit (t0 t1 t2 t3 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1613 := .value 1#32, %1614 := .value 100#32, %1615 := .value t0, %1616 := .value t1, %1617 :=
    .value t2, %1618 := .value t3]

/-- `^bb1` from counter `i`, `n + 1` iterations left: `t3` squared `n + 1` times, then `^bb2`. -/
theorem loop (t0 t1 t2 t3 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ n i (S : GlobalState) (E : ⟪Γ⟫),
      S.WF →
        S.mem.LimbsFit t3 →
        Writable S.mem t3 →
        i + n + 1 = 100 →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            (fe_loose_invert.runFrom (exit t0 t1 t2 t3 E') 2
                  { S with
                    mem :=
                      S.mem.storeLimbs t3
                        (Firedancer.Ref.fd_f25519_pow22523.sqrN (n + 1) (S.mem.readLimbs t3)) } >>=
                g) =
              K) →
        (fe_loose_invert.runFrom (hdr t0 t1 t2 t3 E i) 1 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro i S E hwf ht htw hi hK
    block_init
    step_call using fe_sq_tt.call_eq
    step_pure [Firedancer.saddOverflow_one32 (i := i) (by omega),
      Firedancer.uaddOverflow_one32 (i := i) (by omega)]
    step_pure
    finish_block
    · run_from using hK
    · simp [BitVec.toNat_eq] at hbr
      omega
  | succ n ih =>
    intro i S E hwf ht htw hi hK
    block_init
    step_call using fe_sq_tt.call_eq
    step_pure [Firedancer.saddOverflow_one32 (i := i) (by omega),
      Firedancer.uaddOverflow_one32 (i := i) (by omega)]
    step_pure
    finish_block
    · simp [BitVec.toNat_eq] at hbr
      omega
    · run_from using ih (i + 1) _ _ hwf ht htw (by omega)
      · exact (BitVec.ofNat_add i 1).symm
      · rw [hS, MemoryState.storeLimbs_storeLimbs_self]
        run_from using hK

end fe_loose_invert

open fe_loose_invert in
/-- `fe_loose_invert` stores `spec z` (`z ^ (p - 2)`) at `out`; `out` may alias `z`. The four
temporaries are freed again: only the counter moves on, by four blocks. -/
public theorem fe_loose_invert.call_eq (out z : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hz : s.mem.LimbsFit z) :
    fe_loose_invert.call (fe_loose_invert.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem := s.mem.storeLimbs out (fe_loose_invert.spec (s.mem.readLimbs z)) }) := by
  func_init
  block_init
  -- fe t0; fe t1; fe t2; fe t3;
  iterate 2 step_pure
  step_alloca with t0
  step_alloca with t1
  step_alloca with t2
  step_alloca with t3
  iterate 4 step_pure
  limbs_room t0
  limbs_room t1
  limbs_room t2
  limbs_room t3
  -- `^bb0`
  step_call using fe_sq_tl.call_eq
  name_limbs l1
  sqr l2
  sqr l3
  step_call using fe_mul_tlt.call_eq
  name_limbs l4
  mul l5
  sqr l6
  mul l7
  sqr l8
  sqrs l9 using 3
  mul l10
  sqr l11
  sqrs l12 using 8
  mul l13
  sqr l14
  sqrs l15 using 18
  mul l16
  sqrs l17 using 9
  mul l18
  sqr l19
  sqrs l20 using 48
  mul l21
  sqr l22
  finish_block
  -- `^bb1`: 99 squarings of `t3`
  run_from using loop t0 t1 t2 t3 _ _ 98 1
  name_limbs l23
  -- `^bb2`
  block_init
  mul l24
  sqrs l25 using 49
  mul l26
  sqrs l27 using 4
  mul l28
  -- the temporaries' lifetimes end
  iterate 4 step_pure
  finish_block
  simp [hS]
  erase_frame
  congr 3
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Boringssl

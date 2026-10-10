module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Sodium.fe25519_sq
public import Sodium.fe25519_mul
public import Sodium.Common.Pow
public import Sodium.Mlir.fe25519_pow22523

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The limbs stored at `out`: `lN` is the `N`-th call's (or loop's) result. The code keeps them
in the temporaries `t0`, `t1`, `t2`, reusing each. -/
def fe25519_pow22523.spec (z : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let sq := fe25519_sq.spec
  let mul := fe25519_mul.spec
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
  let l27 := sq l26
  let l28 := sq l27
  mul l28 z

end

/-! ## Proof -/

section Proof

-- the proof macros first: a macro defined between proofs waits for them

/-- A square, its result's limbs named `x`. -/
local macro "sqr " x:ident : tactic =>
  `(tactic|
    ( step_call using fe25519_sq.call_eq
      name_limbs $x))

/-- A product, its result's limbs named `x`. -/
local macro "mul " x:ident : tactic =>
  `(tactic|
    ( step_call using fe25519_mul.call_eq
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

namespace fe25519_pow22523

/-- The live registers at the loop's header `^bb1`, at counter `i`. -/
abbrev hdr (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2819 := .value 1#32, %2820 := .value 100#32, %2821 := .value t0, %2822 := .value t1, %2823 :=
    .value t2, %2824 := .value (BitVec.ofNat 32 i)]

/-- The live registers at the loop's exit `^bb2`. -/
abbrev exit (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2819 := .value 1#32, %2820 := .value 100#32, %2821 := .value t0, %2822 := .value t1, %2823 :=
    .value t2]

/-- `^bb1` from counter `i`, `n + 1` iterations left: `t2` squared `n + 1` times, then `^bb2`. -/
theorem loop (t0 t1 t2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ n i (S : GlobalState) (E : ⟪Γ⟫),
      S.WF →
        S.mem.LimbsFit t2 →
        i + n + 1 = 100 →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            (fe25519_pow22523.runFrom (exit t0 t1 t2 E') 2
                  { S with mem := S.mem.storeLimbs t2 (sqrN (n + 1) (S.mem.readLimbs t2)) } >>=
                g) =
              K) →
        (fe25519_pow22523.runFrom (hdr t0 t1 t2 E i) 1 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro i S E hwf ht hi hK
    block_init
    step_call using fe25519_sq.call_eq
    step_pure [Boringssl.saddOverflow_ofNat_one (i := i) (by omega),
      Boringssl.uaddOverflow_ofNat_one (i := i) (by omega)]
    step_pure
    finish_block
    · step_loop using hK
    · simp [BitVec.toNat_eq] at hbr
      omega
  | succ n ih =>
    intro i S E hwf ht hi hK
    block_init
    step_call using fe25519_sq.call_eq
    step_pure [Boringssl.saddOverflow_ofNat_one (i := i) (by omega),
      Boringssl.uaddOverflow_ofNat_one (i := i) (by omega)]
    step_pure
    finish_block
    · simp [BitVec.toNat_eq] at hbr
      omega
    · step_loop using ih (i + 1) _ _ hwf ht (by omega)
      · exact (BitVec.ofNat_add i 1).symm
      · rw [hS, MemoryState.storeLimbs_storeLimbs_self]
        step_loop using hK

end fe25519_pow22523

open fe25519_pow22523 in
/-- `fe25519_pow22523` stores `spec z` at `out`; `out` may alias `z`. The three temporaries are
freed again: only the counter moves on, by three blocks. -/
public theorem fe25519_pow22523.call_eq (out z : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hz : s.mem.LimbsFit z) :
    fe25519_pow22523.call (fe25519_pow22523.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem := s.mem.storeLimbs out (fe25519_pow22523.spec (s.mem.readLimbs z)) }) := by
  func_init
  block_init
  -- fe25519 t0; fe25519 t1; fe25519 t2;
  iterate 2 step_pure
  step_alloca with t0
  step_alloca with t1
  step_alloca with t2
  iterate 3 step_pure
  limbs_room t0
  limbs_room t1
  limbs_room t2
  sqr l1
  sqr l2
  sqr l3
  mul l4
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
  -- `^bb1`: 99 squarings of `t2`
  step_loop using loop t0 t1 t2 _ _ 98 1
  name_limbs l23
  -- `^bb2`
  block_init
  mul l24
  sqrs l25 using 49
  mul l26
  sqr l27
  sqr l28
  mul l29
  -- the temporaries' lifetimes end
  iterate 3 step_pure
  finish_block
  simp [hS]
  erase_frame
  congr 3
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Sodium

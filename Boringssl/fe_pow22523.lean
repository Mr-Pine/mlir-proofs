module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_pow22523
public import Boringssl.fe_sq_tt
public import Boringssl.fe_mul_ttt
public import Boringssl.Mlir.fe_pow22523
public import Boringssl.Common.Pow

namespace MLIR.Boringssl

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

namespace fe_pow22523

/-- The live registers at the loop's header `^bb1`, at counter `i`. -/
abbrev hdr (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%1468 := .value 1#32, %1469 := .value 100#32, %1470 := .value t0, %1471 := .value t1, %1472 :=
    .value t2, %1473 := .value (BitVec.ofNat 32 i)]

/-- The live registers at the loop's exit `^bb2`. -/
abbrev exit (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1468 := .value 1#32, %1469 := .value 100#32, %1470 := .value t0, %1471 := .value t1, %1472 :=
    .value t2]

/-- `^bb1` from counter `i`, `n + 1` iterations left: `t2` squared `n + 1` times, then `^bb2`. -/
theorem loop (t0 t1 t2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ n i (S : GlobalState) (E : ⟪Γ⟫),
      S.WF →
        S.mem.LimbsFit t2 →
        Writable S.mem t2 →
        i + n + 1 = 100 →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            (fe_pow22523.runFrom (exit t0 t1 t2 E') 2
                  { S with
                    mem :=
                      S.mem.storeLimbs t2
                        (Firedancer.Ref.fd_f25519_pow22523.sqrN (n + 1) (S.mem.readLimbs t2)) } >>=
                g) =
              K) →
        (fe_pow22523.runFrom (hdr t0 t1 t2 E i) 1 S >>= g) = K := by
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
    · step_loop using hK
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
    · step_loop using ih (i + 1) _ _ hwf ht htw (by omega)
      · exact (BitVec.ofNat_add i 1).symm
      · rw [hS, MemoryState.storeLimbs_storeLimbs_self]
        step_loop using hK

end fe_pow22523

open fe_pow22523 in
/-- `fe_pow22523` stores Firedancer's `fd_f25519_pow22523.spec z` (the same chain of squarings and
products, `z ^ ((p - 5) / 8)`) at `out`; `out` may alias `z`. The three temporaries are freed
again: only the counter moves on, by three blocks. -/
public theorem fe_pow22523.call_eq (out z : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hz : s.mem.LimbsFit z) :
    fe_pow22523.call (fe_pow22523.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem :=
              s.mem.storeLimbs out
                (Firedancer.Ref.fd_f25519_pow22523.spec (s.mem.readLimbs z)) }) := by
  func_init
  block_init
  -- fe t0; fe t1; fe t2;
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
  sqr l17
  sqrs l18 using 8
  mul l19
  sqr l20
  sqrs l21 using 48
  mul l22
  sqr l23
  finish_block
  -- `^bb1`: 99 squarings of `t2`
  step_loop using loop t0 t1 t2 _ _ 98 1
  name_limbs l24
  -- `^bb2`
  block_init
  mul l25
  sqrs l27 using 49
  mul l28
  sqr l29
  sqr l30
  mul l31
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

end MLIR.Boringssl

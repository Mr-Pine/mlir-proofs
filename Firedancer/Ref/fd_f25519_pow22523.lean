module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.Mlir.fd_f25519_pow22523
import Firedancer.Common.Counter

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `n` in-place squarings, as a loop does them. -/
def fd_f25519_pow22523.sqrN : Nat → (Fin 5 → BitVec 64) → Fin 5 → BitVec 64
  | 0, x => x
  | n + 1, x => fd_f25519_pow22523.sqrN n (fd_f25519_sqr.spec x)

open fd_f25519_pow22523 in
/-- The limbs stored at `r`: `lN` is the `N`-th call's (or loop's) result. The code keeps them in
the temporaries `t0`, `t1`, `t2`, reusing each. -/
def fd_f25519_pow22523.spec (z : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let sq := fd_f25519_sqr.spec
  let mul := fd_f25519_mul.spec
  let l1 := sq z
  let l2 := sq l1
  let l3 := sq l2
  let l4 := mul z l3
  let l5 := mul l1 l4
  let l6 := sq l5
  let l7 := mul l4 l6
  let l8 := sq l7
  let l9 := sqrN 4 l8 -- `^bb2`
  let l10 := mul l9 l7
  let l11 := sq l10
  let l12 := sqrN 9 l11 -- `^bb4`
  let l13 := mul l12 l10
  let l14 := sq l13
  let l15 := sqrN 19 l14 -- `^bb6`
  let l16 := mul l15 l13
  let l17 := sq l16
  let l18 := sqrN 9 l17 -- `^bb8`
  let l19 := mul l18 l10
  let l20 := sq l19
  let l21 := sqrN 49 l20 -- `^bb10`
  let l22 := mul l21 l19
  let l23 := sq l22
  let l24 := sqrN 99 l23 -- `^bb12`
  let l25 := mul l24 l22
  let l26 := sq l25
  let l27 := sqrN 49 l26 -- `^bb14`
  let l28 := mul l27 l19
  let l29 := sq l28
  let l30 := sq l29
  mul l30 z

end

/-! ## Proof -/

section Proof

-- the proof macros first: a macro defined between proofs waits for them

set_option hygiene false in
/-- An iteration: square, count, test; then exit or go around. -/
local macro "iter_proof" : tactic =>
  `(tactic|
    ( intro i S E hwf ht htr hi hexit hback
      dsimp only [hdr2, hdr4, hdr6, hdr8, hdr10, hdr12, hdr14]
      block_init
      step_call using fd_f25519_sqr.call_eq
      step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
      step_pure
      finish_block
      · step_loop using
          hexit
            (by
              simp [BitVec.toNat_eq] at hbr; omega)
      · step_loop using
          hback
            (by
              simp [BitVec.toNat_eq] at hbr; omega)
        exact (BitVec.ofNat_add i 1).symm))

set_option hygiene false in
/-- A block between two loops: its two calls, then the jump. -/
local macro "mul_sqr_proof" : tactic =>
  `(tactic|
    ( intro S E hwf ho ha hb ho' hK
      dsimp only [exit2, exit4, exit6, exit8, exit10, exit12]
      block_init
      step_call using fd_f25519_mul.call_eq
      step_call using fd_f25519_sqr.call_eq
      finish_block
      step_loop using hK))

/-- A square, its result's limbs named `x`. -/
local macro "sqr " x:ident : tactic =>
  `(tactic|
    ( step_call using fd_f25519_sqr.call_eq
      name_limbs $x))

/-- A product, its result's limbs named `x`. -/
local macro "mul " x:ident : tactic =>
  `(tactic|
    ( step_call using fd_f25519_mul.call_eq
      name_limbs $x))

set_option hygiene false in
/-- A loop from counter `1`, `n + 1` squarings, its limbs named `x`. -/
local macro "loop " x:ident " using " it:ident n:num : tactic =>
  `(tactic|
    ( step_loop using loop_of_iter ($it _ _ _) $n 1
      name_limbs $x))

/-- A block between two loops: its product named `x`, the square `y`. -/
local macro "between " x:ident y:ident " using " b:ident : tactic =>
  `(tactic|
    ( step_loop using $b _ _ _
      name_limbs $y
      name_limbs $x))

-- the step tactics simplify each new state with these: limb reads resolve through the stores
-- and `alloca`s
attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.readLimbs_alloca
  MemoryState.LimbsFit.storeLimbs

namespace fd_f25519_pow22523

/-- `WF_storeLimbs` for a state written as a constructor, as after a loop. -/
@[mlir_mem]
theorem GlobalState.WF_mk_storeLimbs {a : AllocState} {m : MemoryState} :
    (⟨a, m.storeLimbs p l⟩ : GlobalState).WF ↔ (⟨a, m⟩ : GlobalState).WF :=
  GlobalState.WF_storeLimbs (s := ⟨a, m⟩)

/-! The live registers at each loop's header (at counter `i`) and exit. -/

abbrev hdr2 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2060 := .value 5#32, %2061 := .value 10#32, %2062 := .value 20#32,
    %2063 := .value 50#32, %2064 := .value 100#32, %2065 := .value t0, %2066 := .value t1, %2067 :=
    .value t2, %2078 := .value (BitVec.ofNat 32 i)]

abbrev exit2 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2062 := .value 20#32, %2063 := .value 50#32,
    %2064 := .value 100#32, %2065 := .value t0, %2066 := .value t1, %2067 := .value t2]

abbrev hdr4 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2062 := .value 20#32, %2063 := .value 50#32,
    %2064 := .value 100#32, %2065 := .value t0, %2066 := .value t1, %2067 := .value t2, %2084 :=
    .value (BitVec.ofNat 32 i)]

abbrev exit4 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2062 := .value 20#32, %2063 := .value 50#32,
    %2064 := .value 100#32, %2065 := .value t0, %2066 := .value t1, %2067 := .value t2]

abbrev hdr6 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2062 := .value 20#32, %2063 := .value 50#32,
    %2064 := .value 100#32, %2065 := .value t0, %2066 := .value t1, %2067 := .value t2, %2090 :=
    .value (BitVec.ofNat 32 i)]

abbrev exit6 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2063 := .value 50#32, %2064 := .value 100#32,
    %2065 := .value t0, %2066 := .value t1, %2067 := .value t2]

abbrev hdr8 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2061 := .value 10#32, %2063 := .value 50#32, %2064 := .value 100#32,
    %2065 := .value t0, %2066 := .value t1, %2067 := .value t2, %2096 := .value (BitVec.ofNat 32 i)]

abbrev exit8 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2064 := .value 100#32, %2065 := .value t0,
    %2066 := .value t1, %2067 := .value t2]

abbrev hdr10 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2064 := .value 100#32, %2065 := .value t0,
    %2066 := .value t1, %2067 := .value t2, %2102 := .value (BitVec.ofNat 32 i)]

abbrev exit10 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2064 := .value 100#32, %2065 := .value t0,
    %2066 := .value t1, %2067 := .value t2]

abbrev hdr12 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2064 := .value 100#32, %2065 := .value t0,
    %2066 := .value t1, %2067 := .value t2, %2108 := .value (BitVec.ofNat 32 i)]

abbrev exit12 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2065 := .value t0, %2066 := .value t1, %2067 :=
    .value t2]

abbrev hdr14 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2063 := .value 50#32, %2065 := .value t0, %2066 := .value t1, %2067 :=
    .value t2, %2116 := .value (BitVec.ofNat 32 i)]

abbrev exit14 (t0 t1 t2 : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2059 := .value 1#32, %2065 := .value t0, %2066 := .value t1, %2067 := .value t2]

/-- One in-place squaring of the limbs at `t`: a loop iteration's state. -/
abbrev sqAt (t : Pointer) (S : GlobalState) : GlobalState :=
  { S with mem := S.mem.storeLimbs t (fd_f25519_sqr.spec (S.mem.readLimbs t)) }

/-- One iteration of the squaring loop at header `k`: on to `exit` after the last, else around.
`envIn E i` is the header's env at counter `i`, `envOut E` the exit's. -/
abbrev LoopIter (k exit : Fin 15) (t : Pointer) (N : Nat) (envIn : ⟪Γ⟫ → Nat → ⟪Γ⟫)
    (envOut : ⟪Γ⟫ → ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) : Prop :=
  ∀ i (S : GlobalState) (E : ⟪Γ⟫),
    S.WF →
      S.mem.LimbsFit t →
      S.mem.LimbsRoom t →
      i + 1 ≤ N →
      (i + 1 = N →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args → (fd_f25519_pow22523.runFrom (envOut E') exit (sqAt t S) >>= g) = K) →
      (i + 1 < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            (fd_f25519_pow22523.runFrom (envIn E' (i + 1)) k (sqAt t S) >>= g) = K) →
      (fd_f25519_pow22523.runFrom (envIn E i) k S >>= g) = K

/-- The squaring loop at header `k` from counter `i`, `n + 1` iterations left: `t` squared
`n + 1` times, then `exit`. -/
abbrev Loop (k exit : Fin 15) (t : Pointer) (N : Nat) (envIn : ⟪Γ⟫ → Nat → ⟪Γ⟫) (envOut : ⟪Γ⟫ → ⟪Γ⟫)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) : Prop :=
  ∀ n i (S : GlobalState) (E : ⟪Γ⟫),
    S.WF →
      S.mem.LimbsFit t →
      S.mem.LimbsRoom t →
      i + n + 1 = N →
      (∀ E' : ⟪Γ⟫,
        E'.args = E.args →
          (fd_f25519_pow22523.runFrom (envOut E') exit
                { S with mem := S.mem.storeLimbs t (sqrN (n + 1) (S.mem.readLimbs t)) } >>=
              g) =
            K) →
      (fd_f25519_pow22523.runFrom (envIn E i) k S >>= g) = K

/-- The template: a loop from one iteration, by induction on the iterations left. -/
theorem loop_of_iter (h : LoopIter k exit t N envIn envOut g K) :
    Loop k exit t N envIn envOut g K := by
  intro n
  induction n with
  | zero =>
    intro i S E hwf ht htr hi hK
    exact h i S E hwf ht htr (by omega) (fun _ => hK) (by omega)
  | succ n ih =>
    intro i S E hwf ht htr hi hK
    refine h i S E hwf ht htr (by omega) (by omega) fun _ E' hE' => ?_
    refine
      ih (i + 1) (sqAt t S) E' hwf.storeLimbs ht.storeLimbs htr.storeLimbs (by omega)
        fun E'' hE'' => ?_
    simp only [MemoryState.readLimbs_storeLimbs_self htr, MemoryState.storeLimbs_storeLimbs_self]
    exact hK E'' (hE''.trans hE')

/-- `^bb2`: square `t1`, `5` times in all, then `^bb1`. -/
theorem iter2 (t0 t1 t2 : Pointer) :
    LoopIter 2 1 t1 5 (hdr2 t0 t1 t2) (exit2 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb4`: square `t1`, `10` times in all, then `^bb3`. -/
theorem iter4 (t0 t1 t2 : Pointer) :
    LoopIter 4 3 t1 10 (hdr4 t0 t1 t2) (exit4 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb6`: square `t2`, `20` times in all, then `^bb5`. -/
theorem iter6 (t0 t1 t2 : Pointer) :
    LoopIter 6 5 t2 20 (hdr6 t0 t1 t2) (exit6 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb8`: square `t1`, `10` times in all, then `^bb7`. -/
theorem iter8 (t0 t1 t2 : Pointer) :
    LoopIter 8 7 t1 10 (hdr8 t0 t1 t2) (exit8 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb10`: square `t1`, `50` times in all, then `^bb9`. -/
theorem iter10 (t0 t1 t2 : Pointer) :
    LoopIter 10 9 t1 50 (hdr10 t0 t1 t2) (exit10 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb12`: square `t2`, `100` times in all, then `^bb11`. -/
theorem iter12 (t0 t1 t2 : Pointer) :
    LoopIter 12 11 t2 100 (hdr12 t0 t1 t2) (exit12 t0 t1 t2) (β := β) g K := by iter_proof

/-- `^bb14`: square `t1`, `50` times in all, then `^bb13`. -/
theorem iter14 (t0 t1 t2 : Pointer) :
    LoopIter 14 13 t1 50 (hdr14 t0 t1 t2) (exit14 t0 t1 t2) (β := β) g K := by iter_proof

/-- Two calls, `o ← a * b` then `o' ← o²`: the state after them. -/
abbrev mulSqr (o a b o' : Pointer) (S : GlobalState) : GlobalState :=
  let x := fd_f25519_mul.spec (S.mem.readLimbs a) (S.mem.readLimbs b)
  { S with mem := (S.mem.storeLimbs o x).storeLimbs o' (fd_f25519_sqr.spec x) }

/-- The block `k` between two loops: `o ← a * b`, `o' ← o²`, then `next`. -/
abbrev MulSqr (k next : Fin 15) (o a b o' : Pointer) (envIn envOut : ⟪Γ⟫ → ⟪Γ⟫)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) : Prop :=
  ∀ (S : GlobalState) (E : ⟪Γ⟫),
    S.WF →
      S.mem.LimbsRoom o →
      S.mem.LimbsFit a →
      S.mem.LimbsFit b →
      S.mem.LimbsRoom o' →
      (∀ E' : ⟪Γ⟫,
        E'.args = E.args →
          (fd_f25519_pow22523.runFrom (envOut E') next (mulSqr o a b o' S) >>= g) = K) →
      (fd_f25519_pow22523.runFrom (envIn E) k S >>= g) = K

/-- `^bb1`: `t0 ← t1 * t0`, `t1 ← t0²`, then `^bb4`. -/
theorem block1 (t0 t1 t2 : Pointer) :
    MulSqr 1 4 t0 t1 t0 t1 (exit2 t0 t1 t2) (hdr4 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

/-- `^bb3`: `t1 ← t1 * t0`, `t2 ← t1²`, then `^bb6`. -/
theorem block3 (t0 t1 t2 : Pointer) :
    MulSqr 3 6 t1 t1 t0 t2 (exit4 t0 t1 t2) (hdr6 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

/-- `^bb5`: `t1 ← t2 * t1`, `t1 ← t1²`, then `^bb8`. -/
theorem block5 (t0 t1 t2 : Pointer) :
    MulSqr 5 8 t1 t2 t1 t1 (exit6 t0 t1 t2) (hdr8 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

/-- `^bb7`: `t0 ← t1 * t0`, `t1 ← t0²`, then `^bb10`. -/
theorem block7 (t0 t1 t2 : Pointer) :
    MulSqr 7 10 t0 t1 t0 t1 (exit8 t0 t1 t2) (hdr10 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

/-- `^bb9`: `t1 ← t1 * t0`, `t2 ← t1²`, then `^bb12`. -/
theorem block9 (t0 t1 t2 : Pointer) :
    MulSqr 9 12 t1 t1 t0 t2 (exit10 t0 t1 t2) (hdr12 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

/-- `^bb11`: `t1 ← t2 * t1`, `t1 ← t1²`, then `^bb14`. -/
theorem block11 (t0 t1 t2 : Pointer) :
    MulSqr 11 14 t1 t2 t1 t1 (exit12 t0 t1 t2) (hdr14 t0 t1 t2 · 1) (β := β) g K := by mul_sqr_proof

end fd_f25519_pow22523

open fd_f25519_pow22523

/-- `pow22523` stores `spec` of `a`'s limbs at `r` and returns `r`; `r` may alias `a`. The three
temporaries are freed again: only the counter moves on, by three blocks. -/
public theorem fd_f25519_pow22523.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsRoom r) (ha : s.mem.LimbsFit a) :
    fd_f25519_pow22523.call (fd_f25519_pow22523.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem := s.mem.storeLimbs r (fd_f25519_pow22523.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  -- the counters' constants, the temporaries `t0, t1, t2` and their lifetimes
  iterate 6 step_pure
  iterate 3 step_alloca
  iterate 3 step_pure
  limbs_room v6
  limbs_room v7
  limbs_room v8
  -- `^bb0`
  sqr l1
  sqr l2
  sqr l3
  mul l4
  mul l5
  sqr l6
  mul l7
  sqr l8
  finish_block
  -- the loops, each between two calls
  loop l9 using iter2 3
  between l10 l11 using block1
  loop l12 using iter4 8
  between l13 l14 using block3
  loop l15 using iter6 18
  between l16 l17 using block5
  loop l18 using iter8 8
  between l19 l20 using block7
  loop l21 using iter10 48
  between l22 l23 using block9
  loop l24 using iter12 98
  between l25 l26 using block11
  loop l27 using iter14 48
  block_init
  mul l28
  sqr l29
  sqr l30
  mul l31
  -- the lifetimes' ends
  iterate 3 step_pure
  finish_block
  simp [hS]
  erase_frame
  congr 3
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Ref

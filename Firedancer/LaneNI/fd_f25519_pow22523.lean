module

public import MLIR.Run.Tactic
public import Firedancer.Lane.fd_f25519_pow22523
public import Firedancer.Lane.Common.Mem
public import Firedancer.LaneNI.fd_f25519_sqr
public import Firedancer.LaneNI.fd_f25519_mul
public import Firedancer.LaneNI.Mlir.fd_f25519_pow22523
import Firedancer.Lane.verify_x8.Tactics

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512
open MLIR.Firedancer.Lane.FieldPow (sqrN_succ' counter_eq counter_ne)

/-! ## Proof -/

section Proof

namespace fd_f25519_pow22523

open Firedancer.LaneNI.Mlir Firedancer.LaneNI.Mlir.fd_f25519_pow22523

local notation "sqrN" => fd_r43x6_repsqr_mul2.sqrN

/-- The counter's `i + 1`, `nsw`: no signed overflow. -/
theorem saddOverflow_one32 {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow 1#32 = false := by
  have : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, this]
  omega

/-- The counter's `i + 1`, `nuw`: no unsigned overflow. -/
theorem uaddOverflow_one32 {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).uaddOverflow 1#32 = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- The counter's `i + 1`. -/
theorem ofNat_add_one32 (i : Nat) : BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 (i + 1) :=
  (BitVec.ofNat_add i 1).symm

/-- The entry block's constants and temporaries the other blocks read, `a`'s value `A` in `%9`. -/
abbrev Consts (t0 t1 t2 : Pointer) (A : Wwl) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 1#32, %1 := .value 5#32, %2 := .value 10#32, %3 := .value 20#32, %4 :=
    .value 50#32, %5 := .value 100#32, %6 := .value t0, %7 := .value t1, %8 := .value t2, %9 :=
    Ty.wrap A]

section Loops

variable (r a p : Pointer) (k ex : Fin 15) (N : Nat) (hdr : ⟪Γ⟫ → Nat → ⟪Γ⟫)
  (Live : ⟪Γ⟫ → Prop) (X : Wwl) (S : GlobalState)
  {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)

/-- One pass through the squaring loop at header `k` (env `hdr E i` at counter `i`, `sqrN i X` at
`p`; `Live` what it and the blocks after it read): a load, a squaring stored back, the test
`i + 1 == N`, then on to `ex`, or around with `i + 1`. -/
abbrev LoopIter : Prop :=
  ∀ i (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      i + 1 ≤ N →
      (i + 1 = N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
              (fd_f25519_pow22523.runFrom E' ex { S with mem := S.mem.storeVec p (sqrN N X) } >>=
                  g) = K) →
      (i + 1 < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
              (fd_f25519_pow22523.runFrom (hdr E' (i + 1)) k
                  { S with mem := S.mem.storeVec p (sqrN (i + 1) X) } >>= g) = K) →
      (fd_f25519_pow22523.runFrom (hdr E i) k { S with mem := S.mem.storeVec p (sqrN i X) } >>= g) =
        K

/-- The loop at header `k` from counter `i`, `n` passes after this one. -/
abbrev Loop : Prop :=
  ∀ n i (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      i + n + 1 = N →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Live E' →
            (fd_f25519_pow22523.runFrom E' ex { S with mem := S.mem.storeVec p (sqrN N X) } >>=
                g) = K) →
      (fd_f25519_pow22523.runFrom (hdr E i) k { S with mem := S.mem.storeVec p (sqrN i X) } >>= g) =
        K

variable {r a p k ex N hdr Live X S g K} in
/-- The loop from one pass, by induction on the passes left. -/
theorem loop_of_iter (h : LoopIter r a p k ex N hdr Live X S g K) :
    Loop r a p k ex N hdr Live X S g K := by
  intro n
  induction n with
  | zero =>
    intro i E hA hL hi hK
    exact h i E hA hL (by omega) (fun _ => hK) (by omega)
  | succ n ih =>
    intro i E hA hL hi hK
    exact h i E hA hL (by omega) (by omega) fun _ E' hA' hL' => ih (i + 1) E' hA' hL' (by omega) hK

end Loops

/-- `S` with `v` stored at `p`. -/
abbrev stored (S : GlobalState) (p : Pointer) (v : Wwl) : GlobalState :=
  { S with mem := S.mem.storeVec p v }

/-- What the blocks need of a state: well-formed, room at `r` and the temporaries. -/
abbrev Ok (r t0 t1 t2 : Pointer) (S : GlobalState) : Prop :=
  S.WF ∧ Room S.mem r 512 ∧ Room S.mem t0 512 ∧ Room S.mem t1 512 ∧ Room S.mem t2 512

/-- `Ok` past a store. -/
theorem Ok.upd {r t0 t1 t2 : Pointer} {S : GlobalState} (h : Ok r t0 t1 t2 S) (p : Pointer)
    (v : Wwl) : Ok r t0 t1 t2 (stored S p v) :=
  ⟨h.1.storeVec, h.2.1.storeVec, h.2.2.1.storeVec, h.2.2.2.1.storeVec, h.2.2.2.2.storeVec⟩

/-- A state after a squaring's store, as the loops take it: the state before it, with
`sqrN 1 v` stored. -/
theorem state_split {S : GlobalState} {X : AllocState} {M : MemoryState} {p : Pointer} {v : Wwl}
    (h : S = { alloc := X, mem := M.storeVec p (fd_r43x6_sqr v) }) :
    ∃ B : GlobalState, B = ⟨X, M⟩ ∧ S = stored B p (sqrN 1 v) :=
  ⟨_, rfl, h⟩

/-- `Ok` past two stores. -/
theorem Ok.upd2 {r t0 t1 t2 : Pointer} {S : GlobalState} {p q : Pointer} {v w : Wwl}
    (h : Ok r t0 t1 t2 S) : Ok r t0 t1 t2 (stored (stored S p v) q w) :=
  (h.upd p v).upd q w

/-- What `^bb2` and `^bb1` read: the constants, `U` in `%23`. -/
abbrev live2 (t0 t1 t2 : Pointer) (A U : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts t0 t1 t2 A E ∧ E ⊨ [%23 := Ty.wrap U]

/-- What `^bb4`, `^bb3` (and `^bb8`, `^bb7`) read: the constants, `V` in `%27`. -/
abbrev live4 (t0 t1 t2 : Pointer) (A V : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts t0 t1 t2 A E ∧ E ⊨ [%27 := Ty.wrap V]

/-- What `^bb6` and `^bb5` read: the constants, `V W` in `%27 %36`. -/
abbrev live6 (t0 t1 t2 : Pointer) (A V W : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts t0 t1 t2 A E ∧ E ⊨ [%27 := Ty.wrap V, %36 := Ty.wrap W]

/-- What `^bb10`, `^bb9` (and `^bb14`, `^bb13`) read: the constants, `Z` in `%54`. -/
abbrev live10 (t0 t1 t2 : Pointer) (A Z : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts t0 t1 t2 A E ∧ E ⊨ [%54 := Ty.wrap Z]

/-- What `^bb12` and `^bb11` read: the constants, `Z Q` in `%54 %63`. -/
abbrev live12 (t0 t1 t2 : Pointer) (A Z Q : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts t0 t1 t2 A E ∧ E ⊨ [%54 := Ty.wrap Z, %63 := Ty.wrap Q]

set_option hygiene false in
/-- A pass of a squaring loop (`LoopIter`): load, square, count, test; out, or around. -/
local macro "iter_proof" : tactic =>
  `(tactic|
    ( intro i E hA hL hi hexit hback
      split_reads hL
      block_init
      step_load with x
      step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
      step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega),
        ofNat_add_one32]
      step_pure
      finish_block
      · have hN := counter_eq (by omega) (by omega) hbr
        rw [MemoryState.storeVec_storeVec_self, hx, ← sqrN_succ', hN] at hS
        step_loop using hexit hN
      · rw [MemoryState.storeVec_storeVec_self, hx, ← sqrN_succ'] at hS
        step_loop using hback (by have := counter_ne hbr; omega)))

/-- `^bb2`'s env: the counter `i`. -/
abbrev hdr2 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%29 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb2`: a pass of `for( i=1; i<5; i++ ) sqr t1, t1`. -/
theorem iter2 (r a t0 t1 t2 : Pointer) (A U X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t1 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t1 2 1 5 hdr2 (live2 t0 t1 t2 A U) X S g K := by
  iter_proof

/-- `^bb4`'s env: the counter `i`. -/
abbrev hdr4 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%38 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb4`: a pass of `for( i=1; i<10; i++ ) sqr t1, t1`. -/
theorem iter4 (r a t0 t1 t2 : Pointer) (A V X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t1 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t1 4 3 10 hdr4 (live4 t0 t1 t2 A V) X S g K := by
  iter_proof

/-- `^bb6`'s env: the counter `i`. -/
abbrev hdr6 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%47 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb6`: a pass of `for( i=1; i<20; i++ ) sqr t2, t2`. -/
theorem iter6 (r a t0 t1 t2 : Pointer) (A V W X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t2 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t2 6 5 20 hdr6 (live6 t0 t1 t2 A V W) X S g K := by
  iter_proof

/-- `^bb8`'s env: the counter `i`. -/
abbrev hdr8 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%56 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb8`: a pass of `for( i=1; i<10; i++ ) sqr t1, t1`. -/
theorem iter8 (r a t0 t1 t2 : Pointer) (A V X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t1 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t1 8 7 10 hdr8 (live4 t0 t1 t2 A V) X S g K := by
  iter_proof

/-- `^bb10`'s env: the counter `i`. -/
abbrev hdr10 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%65 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb10`: a pass of `for( i=1; i<50; i++ ) sqr t1, t1`. -/
theorem iter10 (r a t0 t1 t2 : Pointer) (A Z X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t1 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t1 10 9 50 hdr10 (live10 t0 t1 t2 A Z) X S g K := by
  iter_proof

/-- `^bb12`'s env: the counter `i`. -/
abbrev hdr12 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%74 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb12`: a pass of `for( i=1; i<100; i++ ) sqr t2, t2`. -/
theorem iter12 (r a t0 t1 t2 : Pointer) (A Z Q X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t2 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t2 12 11 100 hdr12 (live12 t0 t1 t2 A Z Q) X S g K := by
  iter_proof

/-- `^bb14`'s env: the counter `i`. -/
abbrev hdr14 (E : ⟪Γ⟫) (i : Nat) : ⟪Γ⟫ :=
  E[%87 := PoisonOr.value (BitVec.ofNat 32 i)]

/-- `^bb14`: a pass of `for( i=1; i<50; i++ ) sqr t1, t1`. -/
theorem iter14 (r a t0 t1 t2 : Pointer) (A Z X : Wwl) (S : GlobalState) (hwf : S.WF)
    (hp : Room S.mem t1 512) {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    LoopIter r a t1 14 13 50 hdr14 (live10 t0 t1 t2 A Z) X S g K := by
  iter_proof

/-- `^bb1`, then the loop at `^bb4`: `mul t0, t1, t0`, then `sqr t1, t0` and its loop. -/
theorem bb1 (r a t0 t1 t2 : Pointer) (A U : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live2 t0 t1 t2 A U E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live4 t0 t1 t2 A (fd_r43x6_mul (sqrN 5 U) U) E' →
            (fd_f25519_pow22523.runFrom E' 3
                (stored (stored (stored S t1 (sqrN 5 U)) t0 (fd_r43x6_mul (sqrN 5 U) U)) t1
                  (sqrN 10 (fd_r43x6_mul (sqrN 5 U) U))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 1 (stored S t1 (sqrN 5 U)) >>= g) = K := by
  have hS' := (hS.upd t1 (sqrN 5 U)).upd t0 (fd_r43x6_mul (sqrN 5 U) U)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter4 r a t0 t1 t2 A (fd_r43x6_mul (sqrN 5 U) U) (fd_r43x6_mul (sqrN 5 U) U)
        (stored (stored S t1 (sqrN 5 U)) t0 (fd_r43x6_mul (sqrN 5 U) U))
        hS'.1 hS'.2.2.2.1 g K)
      8 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb3`, then the loop at `^bb6`: `mul t1, t1, t0`, then `sqr t2, t1` and its loop. -/
theorem bb3 (r a t0 t1 t2 : Pointer) (A V : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live4 t0 t1 t2 A V E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live6 t0 t1 t2 A V (fd_r43x6_mul (sqrN 10 V) V) E' →
            (fd_f25519_pow22523.runFrom E' 5
                (stored (stored (stored S t1 (sqrN 10 V)) t1 (fd_r43x6_mul (sqrN 10 V) V)) t2
                  (sqrN 20 (fd_r43x6_mul (sqrN 10 V) V))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 3 (stored S t1 (sqrN 10 V)) >>= g) = K := by
  have hS' := (hS.upd t1 (sqrN 10 V)).upd t1 (fd_r43x6_mul (sqrN 10 V) V)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter6 r a t0 t1 t2 A V (fd_r43x6_mul (sqrN 10 V) V) (fd_r43x6_mul (sqrN 10 V) V)
        (stored (stored S t1 (sqrN 10 V)) t1 (fd_r43x6_mul (sqrN 10 V) V))
        hS'.1 hS'.2.2.2.2 g K)
      18 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb5`, then the loop at `^bb8`: `mul t1, t2, t1`, then `sqr t1, t1` and its loop. -/
theorem bb5 (r a t0 t1 t2 : Pointer) (A V W : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live6 t0 t1 t2 A V W E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live4 t0 t1 t2 A V E' →
            (fd_f25519_pow22523.runFrom E' 7
                (stored (stored (stored S t2 (sqrN 20 W)) t1 (fd_r43x6_mul (sqrN 20 W) W)) t1
                  (sqrN 10 (fd_r43x6_mul (sqrN 20 W) W))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 5 (stored S t2 (sqrN 20 W)) >>= g) = K := by
  have hS' := (hS.upd t2 (sqrN 20 W)).upd t1 (fd_r43x6_mul (sqrN 20 W) W)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter8 r a t0 t1 t2 A V (fd_r43x6_mul (sqrN 20 W) W)
        (stored (stored S t2 (sqrN 20 W)) t1 (fd_r43x6_mul (sqrN 20 W) W))
        hS'.1 hS'.2.2.2.1 g K)
      8 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb7`, then the loop at `^bb10`: `mul t0, t1, t0`, then `sqr t1, t0` and its loop. -/
theorem bb7 (r a t0 t1 t2 : Pointer) (A V X : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live4 t0 t1 t2 A V E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live10 t0 t1 t2 A (fd_r43x6_mul (sqrN 10 X) V) E' →
            (fd_f25519_pow22523.runFrom E' 9
                (stored (stored (stored S t1 (sqrN 10 X)) t0 (fd_r43x6_mul (sqrN 10 X) V)) t1
                  (sqrN 50 (fd_r43x6_mul (sqrN 10 X) V))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 7 (stored S t1 (sqrN 10 X)) >>= g) = K := by
  have hS' := (hS.upd t1 (sqrN 10 X)).upd t0 (fd_r43x6_mul (sqrN 10 X) V)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter10 r a t0 t1 t2 A (fd_r43x6_mul (sqrN 10 X) V) (fd_r43x6_mul (sqrN 10 X) V)
        (stored (stored S t1 (sqrN 10 X)) t0 (fd_r43x6_mul (sqrN 10 X) V))
        hS'.1 hS'.2.2.2.1 g K)
      48 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb9`, then the loop at `^bb12`: `mul t1, t1, t0`, then `sqr t2, t1` and its loop. -/
theorem bb9 (r a t0 t1 t2 : Pointer) (A Z : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live10 t0 t1 t2 A Z E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live12 t0 t1 t2 A Z (fd_r43x6_mul (sqrN 50 Z) Z) E' →
            (fd_f25519_pow22523.runFrom E' 11
                (stored (stored (stored S t1 (sqrN 50 Z)) t1 (fd_r43x6_mul (sqrN 50 Z) Z)) t2
                  (sqrN 100 (fd_r43x6_mul (sqrN 50 Z) Z))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 9 (stored S t1 (sqrN 50 Z)) >>= g) = K := by
  have hS' := (hS.upd t1 (sqrN 50 Z)).upd t1 (fd_r43x6_mul (sqrN 50 Z) Z)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter12 r a t0 t1 t2 A Z (fd_r43x6_mul (sqrN 50 Z) Z) (fd_r43x6_mul (sqrN 50 Z) Z)
        (stored (stored S t1 (sqrN 50 Z)) t1 (fd_r43x6_mul (sqrN 50 Z) Z))
        hS'.1 hS'.2.2.2.2 g K)
      98 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb11`, then the loop at `^bb14`: `mul t1, t2, t1`, then `sqr t1, t1` and its loop. -/
theorem bb11 (r a t0 t1 t2 : Pointer) (A Z Q : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live12 t0 t1 t2 A Z Q E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live10 t0 t1 t2 A Z E' →
            (fd_f25519_pow22523.runFrom E' 13
                (stored (stored (stored S t2 (sqrN 100 Q)) t1 (fd_r43x6_mul (sqrN 100 Q) Q)) t1
                  (sqrN 50 (fd_r43x6_mul (sqrN 100 Q) Q))) >>= g) = K) :
    (fd_f25519_pow22523.runFrom E 11 (stored S t2 (sqrN 100 Q)) >>= g) = K := by
  have hS' := (hS.upd t2 (sqrN 100 Q)).upd t1 (fd_r43x6_mul (sqrN 100 Q) Q)
  dsimp only [stored] at hK ⊢
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with v
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  subst hv hy hS
  step_loop using
    loop_of_iter
      (iter14 r a t0 t1 t2 A Z (fd_r43x6_mul (sqrN 100 Q) Q)
        (stored (stored S t2 (sqrN 100 Q)) t1 (fd_r43x6_mul (sqrN 100 Q) Q))
        hS'.1 hS'.2.2.2.1 g K)
      48 1
  intro hL'
  subst hS
  exact hK _ (by assumption) hL'

/-- `^bb13`: `mul t0, t1, t0`, `sqr t0, t0` twice, `mul r, t0, a`; stores at `r`, returns `r`. -/
theorem bb13 (r a t0 t1 t2 : Pointer) (A Z X : Wwl) (S : GlobalState) (hS : Ok r t0 t1 t2 S)
    {β : Type} (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live10 t0 t1 t2 A Z E)
    (hK :
      let F := fd_r43x6_mul (sqrN 50 X) Z
      g
          (.cons (.value r) .nil,
            { S with
              mem :=
                ((((((((S.mem.storeVec t1 (sqrN 50 X)).storeVec t0 F).storeVec t0
                                  (fd_r43x6_sqr F)).storeVec t0
                              (fd_r43x6_sqr (fd_r43x6_sqr F))).storeVec r
                          (fd_r43x6_mul (fd_r43x6_sqr (fd_r43x6_sqr F)) A)).lifetimeEnd
                      t2).lifetimeEnd
                    t1).lifetimeEnd t0) }) =
        K) :
    (fd_f25519_pow22523.runFrom E 13 (stored S t1 (sqrN 50 X)) >>= g) = K := by
  dsimp only [stored]
  obtain ⟨hwf, hr, h0, h1, h2⟩ := hS
  split_reads hL
  block_init
  step_load with y
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with f0
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with f1
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with f2
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  iterate 3 step_pure
  finish_block
  subst hS hy hf0 hf1 hf2
  exact hK

end fd_f25519_pow22523

open fd_f25519_pow22523 in
/-- `fd_f25519_pow22523( r, a )` stores `spec` of the element at `a` at `r` and returns `r`; it
loads `a` before it stores, so `r` may be `a`. Its three temporaries are freed, the counter moves on
by three blocks. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_pow22523.call_eq (r a : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (ha : Fits s.mem a 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_pow22523.call
        (Firedancer.LaneNI.Mlir.fd_f25519_pow22523.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem :=
              s.mem.storeVec r
                (MLIR.Firedancer.Lane.fd_f25519_pow22523.spec (s.mem.readVec a)) }) := by
  generalize hres : MLIR.Firedancer.Lane.fd_f25519_pow22523.spec (s.mem.readVec a) = res
  func_init
  block_init
  iterate 6 step_pure
  step_alloca with t0
  step_alloca with t1
  step_alloca with t2
  iterate 3 step_pure
  step_load with A
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with u0
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with u1
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with u2
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with u3
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with u4
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  step_load with u5
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq
  step_load with U
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq
  finish_block
  obtain ⟨B, hB, hS2⟩ := state_split hS
  have hO : Ok r t0 t1 t2 B := by
    subst hB
    refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
  clear hS
  subst hS2
  step_loop using loop_of_iter (iter2 r a t0 t1 t2 A U U B hO.1 hO.2.2.2.1 _ _) 3 1
  intro hL
  subst hS
  refine bb1 r a t0 t1 t2 A U _ hO _ _ E₀ (by assumption) hL fun E hAr hL => ?_
  refine bb3 r a t0 t1 t2 A _ _ hO.upd2 _ _ E hAr hL fun E hAr hL => ?_
  refine bb5 r a t0 t1 t2 A _ _ _ hO.upd2.upd2 _ _ E hAr hL fun E hAr hL => ?_
  refine bb7 r a t0 t1 t2 A _ _ _ hO.upd2.upd2.upd2 _ _ E hAr hL fun E hAr hL => ?_
  refine bb9 r a t0 t1 t2 A _ _ hO.upd2.upd2.upd2.upd2 _ _ E hAr hL
    fun E hAr hL => ?_
  refine bb11 r a t0 t1 t2 A _ _ _ hO.upd2.upd2.upd2.upd2.upd2 _ _ E hAr
    hL fun E hAr hL => ?_
  refine bb13 r a t0 t1 t2 A _ _ _ hO.upd2.upd2.upd2.upd2.upd2.upd2 _ _ E hAr hL ?_
  intro F
  dsimp only
  erase_frame
  subst hres hU hu5 hu4 hu3 hu2 hu1 hu0 hA
  delta MLIR.Firedancer.Lane.fd_f25519_pow22523.spec
  rfl


end Proof

end MLIR.Firedancer.LaneNI

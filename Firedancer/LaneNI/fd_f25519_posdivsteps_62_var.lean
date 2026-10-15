module

public import Firedancer.LaneNI.Common.Divsteps
public import Firedancer.LaneNI.fd_int_min
public import Firedancer.LaneNI.fd_ulong_find_lsb
public import Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var
public import MLIR.Run.Tactic
import Firedancer.Lane.verify_x8.Tactics

namespace MLIR.Firedancer.LaneNI

open Firedancer.Lane.Jacobi

/-! ## Proof -/

section Proof

namespace fd_f25519_posdivsteps_62_var

open Firedancer.LaneNI.Mlir Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var

/-- `^bb2`'s env: the loop state. -/
abbrev hdr2 (E : ⟪Γ⟫) (s : PD) : ⟪Γ⟫ :=
  E[%28 := .value s.j, %29 := .value s.i, %30 := .value s.eta, %31 := .value s.v, %32 :=
    .value s.u, %33 := .value s.g, %34 := .value s.f, %35 := .value s.r, %36 := .value s.q]

/-- `^bb6`'s env: the final state's matrix, `eta` and `j`. -/
abbrev hdr6 (E : ⟪Γ⟫) (s : PD) : ⟪Γ⟫ :=
  E[%101 := .value s.q, %102 := .value s.r, %103 := .value s.u, %104 := .value s.v, %105 :=
    .value s.eta, %106 := .value s.j]

/-- The entry block's constants the loop reads. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := .value 1#64, %2 := .value 2#64, %4 := .value 0#64, %5 := .value 1#32, %6 :=
    .value 64#32, %7 := .value 18446744073709551615#64, %8 := .value 8#64, %9 := .value 15#64,
    %10 := .value 62#64, %11 := .value 63#64, %12 := .value 0#32]

set_option hygiene false in
/-- `^bb5`: `g += f w` and the matrix's rows, then the divide and the test `i == 0`. -/
local macro "bb5_steps" : tactic =>
  `(tactic|
    ( block_init
      iterate 6 step_pure
      step_pure [hi.2.1]
      step_pure [hi.1, hi.2.2.1, hi.2.2.2]
      step_pure with x
      step_call using
        (Firedancer.LaneNI.Mlir.fd_ulong_find_lsb.call_eq (hx := hx ▸ shl_or_ne_zero hs _)) with z
      have hzf := z_facts (hx ▸ shl_or_ne_zero hs _)
      rw [← hz] at hzf
      iterate 13 step_pure [hzf.1, hzf.2.1, hzf.2.2]
      finish_block))

/-- A pass of the loop at `^bb2` from a `Good` state `s`: on to `^bb6` at `s.cancel.divide` when
its `i` is `0`, else around. -/
theorem iter (eta0 f0 g0 : BitVec 64) (t jac : Pointer) (C : BitVec 64)
    (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) (s : PD) (hs : Good C s) (S : GlobalState)
    (hwf : S.WF) (K : PoisonOr (Vals [.bv 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get)
    (hL : Consts E)
    (hexit :
      (s.cancel.divide).i = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get →
            fd_f25519_posdivsteps_62_var.runFrom (hdr6 E' s.cancel.divide) 6 S = K)
    (hback :
      (s.cancel.divide).i ≠ 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get →
            Consts E' → fd_f25519_posdivsteps_62_var.runFrom (hdr2 E' s.cancel.divide) 2 S = K) :
    fd_f25519_posdivsteps_62_var.runFrom (hdr2 E s) 2 S = K := by
  split_reads hL
  have hi := i_facts hs
  block_init
  step_pure
  finish_block
  · -- `eta < 0`: swap, cancel up to 6 bits
    have hpass := cancel_divide_neg s hbr
    block_init
    iterate 7 step_pure
    step_call using Firedancer.LaneNI.Mlir.fd_int_min.call_eq with lim
    step_pure with d
    have hlf := lim_neg hC hC0 hs hbr
    rw [← hlim, ← hd] at hlf
    step_pure [hlf.1] with dz
    step_pure [not_le_toNat_of_lt64 (hdz ▸ hlf.2)] with m
    iterate 6 step_pure
    finish_block
    bb5_steps
    · subst hz hx hm hdz hd hlim
      step_loop using hexit (by rw [hpass]; exact hbr)
    · subst hz hx hm hdz hd hlim
      simp only [hpass] at hback
      step_loop using hback (by exact hbr)
  · -- `eta >= 0`: cancel up to 4 bits
    have hpass := cancel_divide_nonneg s hbr
    block_init
    iterate 2 step_pure
    step_call using Firedancer.LaneNI.Mlir.fd_int_min.call_eq with lim
    step_pure with d
    have hlf := lim_nonneg hC hC0 hs hbr
    rw [← hlim, ← hd] at hlf
    step_pure [hlf.1] with dz
    step_pure [not_le_toNat_of_lt64 (hdz ▸ hlf.2)] with m
    iterate 8 step_pure
    finish_block
    bb5_steps
    · subst hz hx hm hdz hd hlim
      step_loop using hexit (by rw [hpass]; exact hbr)
    · subst hz hx hm hdz hd hlim
      simp only [hpass] at hback
      step_loop using hback (by exact hbr)

/-- `^bb6`: the matrix stored at `t`, `j` at `jac`, `eta` returned. -/
theorem exit6 (eta0 f0 g0 : BitVec 64) (t jac : Pointer) (S : GlobalState) (hwf : S.WF)
    (ht : Room S.mem t 256) (hoff : ¬t.offset.uaddOverflow 24#64) (hjac : Room S.mem jac 32)
    (s : PD) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get) :
    fd_f25519_posdivsteps_62_var.runFrom (hdr6 E s) 6 S =
      .value
        (.cons (.value s.eta) .nil,
          { S with
            mem :=
              ((((S.mem.storeAt t s.u).storeAt (t.add 8#64) s.v).storeAt (t.add 16#64)
                s.q).storeAt (t.add 24#64) s.r).storeAt jac s.j }) := by
  have h8 : ¬t.offset.uaddOverflow 8#64 := by
    simp [BitVec.uaddOverflow] at *
    omega
  have h16 : ¬t.offset.uaddOverflow 16#64 := by
    simp [BitVec.uaddOverflow] at *
    omega
  have ht8 := Room.add_of_le (w := 64) h8 (by simp) ht
  have ht16 := Room.add_of_le (w := 64) h16 (by simp) ht
  have ht24 := Room.add_of_le (w := 64) hoff (by simp) ht
  have ht0 := Room.mono (v := 64) (by omega) ht
  block_init
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_store
  finish_block
  subst hS
  rfl

/-- The loop from `^bb2` at a divided state `s` with `i ≤ n`: it leaves through `^bb6` at
`pdLoop n s.cancel`. -/
theorem loop (eta0 f0 g0 : BitVec 64) (t jac : Pointer) (C : BitVec 64)
    (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) (S : GlobalState) (hwf : S.WF)
    (K : PoisonOr (Vals [.bv 64] × GlobalState)) (n : Nat) :
    ∀ (s : PD), Good C s → s.i.toNat ≤ n → ∀ E : ⟪Γ⟫,
      E.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get →
      Consts E →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value eta0) (.value f0) (.value g0) (.value t) (.value jac)).get →
          fd_f25519_posdivsteps_62_var.runFrom (hdr6 E' (pdLoop n s.cancel)) 6 S = K) →
      fd_f25519_posdivsteps_62_var.runFrom (hdr2 E s) 2 S = K := by
  induction n with
  | zero =>
    intro s hs hn
    have := hs.2.2.1
    rw [BitVec.le_def] at this
    simp at this
    omega
  | succ n ih =>
    intro s hs hn E hA hL hK
    have hst := good_step hC hC0 hs
    refine iter eta0 f0 g0 t jac C hC hC0 s hs S hwf K E hA hL ?_ ?_
    · intro h0 E' hA'
      have := hK E' hA'
      simpa only [pdLoop, h0, ↓reduceIte] using this
    · intro h0 E' hA' hL'
      refine ih _ (hst.2 h0) ?_ E' hA' hL' ?_
      · have := hst.1
        rw [BitVec.lt_def] at this
        omega
      · intro E'' hA''
        have := hK E'' hA''
        simpa only [pdLoop, h0, ↓reduceIte] using this

end fd_f25519_posdivsteps_62_var

/-- `fd_f25519_posdivsteps_62_var( eta, f0, g0, t, &jac )` for odd `f0` and `|eta| ≤ 2^30`: the
final `posdivsteps` state's matrix stored at `t` as `[u, v, q, r]`, its `j` at `jac`, its `eta`
returned. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var.call_eq
    (eta f0 g0 : BitVec 64) (t jac : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : f0 &&& 1 = 1) (he : eta.sle 1073741824#64) (he' : (-1073741824#64).sle eta)
    (ht : Room s.mem t 256) (hoff : ¬t.offset.uaddOverflow 24#64) (hjac : Fits s.mem jac 32)
    (hjacr : Room s.mem jac 32) :
    Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var.call
        (Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var.args (.value eta) (.value f0)
          (.value g0) (.value t) (.value jac)) s =
      let pd := posdivsteps eta f0 g0 (s.mem.readAt jac 32)
      .value
        (.cons (.value pd.eta) .nil,
          { s with
            mem :=
              ((((s.mem.storeAt t pd.u).storeAt (t.add 8#64) pd.v).storeAt (t.add 16#64)
                pd.q).storeAt (t.add 24#64) pd.r).storeAt jac pd.j }) := by
  func_init
  block_init
  iterate 13 step_pure
  step_load with j0
  step_pure with x
  have hi := init_z g0
  simp only at hi
  rw [← hx] at hi
  have hx0 := hi.1
  step_call using (Firedancer.LaneNI.Mlir.fd_ulong_find_lsb.call_eq (hx := hx0)) with z
  have hzf := z_facts hx0
  rw [← hz] at hzf hi
  step_pure [hzf.1] with z64
  rw [← hz64] at hi
  step_pure [hi.2.2.2.1, hi.2.2.2.2] with u0
  iterate 8 step_pure
  have hd := init_divide eta f0 g0 j0
  simp only at hd
  rw [← hx, ← hz, ← hz64, ← hu0] at hd
  finish_block
  · -- `zeros == 62`: done
    subst hS
    have hp : posdivsteps eta f0 g0 j0 = (⟨eta, f0, g0, 1, 0, 0, 1, 62, j0⟩ : PD).divide := by
      simp only [posdivsteps, pdLoop, hd, hbr]
      rfl
    rw [hp, hd]
    step_loop using fd_f25519_posdivsteps_62_var.exit6 eta f0 g0 t jac _ ‹_› ‹_› hoff ‹_›
    rw [← hx, ← hz, hbr]
  · subst hS
    block_init
    step_pure [hi.2.2.1]
    step_pure [hi.2.2.2.1]
    finish_block
    have h0 : (62#32 - z) ≠ 0#32 := fun h => hbr (by bv_decide)
    have hg : Good 1073741886#64 ⟨eta - z64, f0, g0 >>> z64.toNat, u0, 0, 0, 1, 62#32 - z,
        z &&& (BitVec.setWidth 32 (f0 >>> 1) ^^^ BitVec.setWidth 32 (f0 >>> 2)) ^^^ j0⟩ := by
      have := good_init (B := 1073741824#64) (g := g0) (u := 1) (v := 0) (q := 0) (r := 1)
        (j := j0) (by decide) (by decide) hf he he'
      simp only at this
      rw [hd] at this
      exact this h0
    have hq : posdivsteps eta f0 g0 j0 = pdLoop 62 (PD.cancel ⟨eta - z64, f0, g0 >>> z64.toNat, u0,
        0, 0, 1, 62#32 - z,
        z &&& (BitVec.setWidth 32 (f0 >>> 1) ^^^ BitVec.setWidth 32 (f0 >>> 2)) ^^^ j0⟩) := by
      rw [posdivsteps, pdLoop.eq_2]
      simp only [hd]
      exact ite_eq_right_of_eq_false _ _ (eq_false h0)
    have hle : (62#32 - z).toNat ≤ 62 := by
      have := hg.2.2.2.1
      rw [BitVec.le_def] at this
      simpa using this
    rw [hq]
    step_loop using fd_f25519_posdivsteps_62_var.loop eta f0 g0 t jac 1073741886#64 (by decide)
      (by decide) _ ‹_› _ 62 _ hg hle
    step_loop using fd_f25519_posdivsteps_62_var.exit6 eta f0 g0 t jac _ ‹_› ‹_› hoff ‹_›

end Proof

end MLIR.Firedancer.LaneNI

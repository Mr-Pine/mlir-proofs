module

public import Firedancer.LaneNI.Common.JacobiInv
public import Firedancer.LaneNI.Common.Limbs
public import Firedancer.LaneNI.fd_f25519_posdivsteps_62_var
public import Firedancer.LaneNI.fd_f25519_update_fg_62_var
public import Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var
public import MLIR.Run.Tactic
import Firedancer.Lane.verify_x8.Tactics

namespace MLIR.Firedancer.LaneNI

open Firedancer.Lane.Jacobi

/-! ## Proof -/

section Proof

namespace fd_f25519_jacobi_var

open Firedancer.LaneNI.Mlir Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var

/-- `^bb1`'s env: `f[0]`, the batch count, `eta`, `len`. -/
abbrev hdr1 (E : ⟪Γ⟫) (f0 : BitVec 64) (cnt : BitVec 32) (eta : BitVec 64) (len : BitVec 32) :
    ⟪Γ⟫ :=
  E[%28 := .value f0, %29 := .value cnt, %30 := .value eta, %31 := .value len]

/-- The entry block's constants and pointers the loop reads. -/
abbrev Consts (fp gp jp tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 1#32, %1 := .value 8#64, %4 := .value 0#32, %6 :=
    .value 18446744073709551615#64, %8 := .value 62#64, %9 := .value 1#64, %10 := .value 9#32,
    %11 := .value 0#64, %12 := .value 18446744073709551608#64, %13 :=
    Ty.wrap (Vector.replicate 8 0#64), %14 := .value 4294967295#32, %15 := .value 25#32, %16 :=
    .value 2#32, %17 := .value fp, %18 := .value gp, %19 := .value jp, %20 := .value tp, %21 :=
    .value (fp.add 8#64), %23 := .value (gp.add 8#64)]

/-- The registers `^bb1` leaves for the blocks after it. -/
abbrev Regs (k : Nat) (st : JS) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%29 := .value (BitVec.ofNat 32 k), %31 := .value (BitVec.ofNat 32 st.len), %39 :=
    .value st.pd.eta, %40 := .value st.FG.1[0], %42 :=
    .value (BitVec.ofBool ((1#32).slt (BitVec.ofNat 32 st.len)))]

/-- The state facts at `^bb1` for the loop state `st`. -/
abbrev Hdr (fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState) (st : JS)
    (S : GlobalState) : Prop :=
  S.WF ∧ S.alloc = A ∧ S.mem.eraseFrom b = M0 ∧ limbsAt S.mem fp = st.f ∧
    limbsAt S.mem gp = st.g ∧ S.mem.readAt jp 32 = st.jac ∧ Fits S.mem fp 320 ∧
      Fits S.mem gp 320 ∧ Room S.mem fp 320 ∧ Room S.mem gp 320 ∧ Fits S.mem jp 32 ∧
        Room S.mem jp 32 ∧ InBounds S.mem tp 256 ∧ Writable S.mem tp

/-- Around the loop at `^bb1`, for batch `k` from the state `st`. -/
abbrev Back (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState) (k : Nat)
    (st : JS) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) : Prop :=
  ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (args (.value x)).get →
    Consts fp gp jp tp E' → Hdr fp gp jp tp A b M0 st S' →
      (fd_f25519_jacobi_var.runFrom
          (hdr1 E' st.f[0] (BitVec.ofNat 32 k) st.eta (BitVec.ofNat 32 st.len)) 1 S' >>= g) = K

/-- Out of the loop to `^bb14` with the result `r`. -/
abbrev Out (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (r : BitVec 32) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) : Prop :=
  ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (args (.value x)).get →
    Consts fp gp jp tp E' → S'.WF → S'.alloc = A →
    S'.mem.eraseFrom b = M0 → (fd_f25519_jacobi_var.runFrom E'[%85 := .value r] 14 S' >>= g) = K

set_option hygiene false in
/-- `^bb13`: `t`'s lifetime ended, the count up; out after 25 batches, else around. -/
local macro "bb13_steps" : tactic =>
  `(tactic|
    ( block_init
      step_lifetime
      step_pure [hc.2.1, hc.2.2.1]
      step_pure
      finish_block
      · -- out after 25 batches
        have h24 : k = 24 := hc.2.2.2.1 (hc.1 ▸ hbr)
        subst h24
        have hr : jacLoop (25 - 24) st = 0#32 := by
          rw [show 25 - 24 = 0 + 1 from rfl, jacLoop_succ,
            ite_eq_right_of_eq_false _ _ (eq_false hnd)]
          rfl
        rw [hr] at hexit
        step_loop using hexit
        rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
        exact her
      · -- around
        have hk1 : k + 1 < 25 := by
          have : k ≠ 24 := fun h => hbr (hc.1 ▸ hc.2.2.2.mpr h)
          omega
        have hH : Hdr fp gp jp tp A b M0 st.next S := by
          refine ⟨‹_›, ?_, ?_, ?_, ?_, ?_, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›⟩
          · rw [hS]; exact hal
          · rw [hS]; simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]; exact her
          · rw [hS]; simp only [limbsAt_lifetimeEnd]; exact hF
          · rw [hS]; simp only [limbsAt_lifetimeEnd]; exact hG
          · first
            | exact hJ
            | (rw [hS]; simp only [MemoryState.readAt_lifetimeEnd]; exact hJ)
        have hb' := hback hnd hk1
        simp only [Back, hnl] at hb'
        rw [hc.1] at hE
        step_loop using hb'))

/-- The pointers' facts: four distinct blocks at or above `b`, at offset `0`. -/
abbrev Ptrs (fp gp jp tp : Pointer) (b : Nat) : Prop :=
  fp.id ≠ gp.id ∧ fp.id ≠ jp.id ∧ fp.id ≠ tp.id ∧ gp.id ≠ jp.id ∧ gp.id ≠ tp.id ∧ jp.id ≠ tp.id ∧
    fp.offset = 0 ∧ gp.offset = 0 ∧ jp.offset = 0 ∧ tp.offset = 0 ∧ b ≤ fp.id.id ∧
      b ≤ gp.id.id ∧ b ≤ jp.id.id ∧ b ≤ tp.id.id

/-- The state facts after `^bb1`'s calls, for the loop state `st`. -/
abbrev Mid (fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState) (st : JS)
    (S : GlobalState) : Prop :=
  S.WF ∧ S.alloc = A ∧ S.mem.eraseFrom b = M0 ∧ limbsAt S.mem fp = st.FG.1 ∧
    limbsAt S.mem gp = st.FG.2 ∧ S.mem.readAt jp 32 = st.pd.j ∧ Fits S.mem fp 320 ∧
      Fits S.mem gp 320 ∧ Room S.mem fp 320 ∧ Room S.mem gp 320 ∧ Fits S.mem jp 32 ∧
        Room S.mem jp 32 ∧ InBounds S.mem tp 256 ∧ Writable S.mem tp

set_option hygiene false in
/-- The tails' prologue: the facts unbundled, the limbs, the registers. -/
local macro "tail_prologue" : tactic =>
  `(tactic|
    ( obtain ⟨hfg, hfj, hft, hgj, hgt, hjt, hfo, hgo, hjo, hto, hbf, hbg, hbj, hbt⟩ := hp
      obtain ⟨hwf, hal, her, hF, hG, hJ, hf, hg, hfr, hgr, hj, hjr, htb, htw⟩ := hm
      have hc := cnt_succ hk
      obtain ⟨hF0, hF1, hF2, hF3, hF4⟩ := fits_limbs hf (by simp [BitVec.uaddOverflow, hfo])
      obtain ⟨hG0, hG1, hG2, hG3, hG4⟩ := fits_limbs hg (by simp [BitVec.uaddOverflow, hgo])
      dsimp only [Consts, Regs] at hL hR
      split_reads hL hR
      rw [hl1] at hR_1 hR_4))

/-- `^bb10` for `len = 1`. -/
theorem tail10_1 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 1) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  tail_prologue
  have hnd : ¬st.done := fun h => hne h.1
  have hnl : BitVec.ofNat 32 st.next.len = 1#32 := by simp [hl1]
  block_init
  finish_block
  bb13_steps

/-- `^bb10` for `len = 2`. -/
theorem tail10_2 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 2) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  tail_prologue
  have hnd : ¬st.done := fun h => hne h.1
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 8#64) 64 = st.FG.2[1] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[1] ||| st.FG.1[1] == 0#64) = 1#1 then 1#32 else 2#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[1] ||| st.FG.1[1] = 0#64
    · have h' : st.FG.1[1] ||| st.FG.2[1] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[1] ||| st.FG.2[1] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[1] ||| st.FG.1[1] == 0#64) = 1#1 := by
        rw [show (st.FG.2[1] ||| st.FG.1[1] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure
  step_pure [show (1#32).msb = false from rfl]
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  finish_block
  bb13_steps

/-- `^bb10` for `len = 3`. -/
theorem tail10_3 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 3) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  tail_prologue
  have hnd : ¬st.done := fun h => hne h.1
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 16#64) 64 = st.FG.2[2] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[2] ||| st.FG.1[2] == 0#64) = 1#1 then 2#32 else 3#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[2] ||| st.FG.1[2] = 0#64
    · have h' : st.FG.1[2] ||| st.FG.2[2] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[2] ||| st.FG.2[2] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[2] ||| st.FG.1[2] == 0#64) = 1#1 := by
        rw [show (st.FG.2[2] ||| st.FG.1[2] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure
  step_pure [show (2#32).msb = false from rfl]
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  finish_block
  bb13_steps

/-- `^bb10` for `len = 4`. -/
theorem tail10_4 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 4) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  tail_prologue
  have hnd : ¬st.done := fun h => hne h.1
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have ef3 : S.mem.readAt (fp.add 24#64) 64 = st.FG.1[3] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 24#64) 64 = st.FG.2[3] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[3] ||| st.FG.1[3] == 0#64) = 1#1 then 3#32 else 4#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[3] ||| st.FG.1[3] = 0#64
    · have h' : st.FG.1[3] ||| st.FG.2[3] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[3] ||| st.FG.2[3] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[3] ||| st.FG.1[3] == 0#64) = 1#1 := by
        rw [show (st.FG.2[3] ||| st.FG.1[3] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure
  step_pure [show (3#32).msb = false from rfl]
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  finish_block
  bb13_steps

/-- `^bb10` for `len = 5`. -/
theorem tail10_5 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 5) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  tail_prologue
  have hnd : ¬st.done := fun h => hne h.1
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have ef3 : S.mem.readAt (fp.add 24#64) 64 = st.FG.1[3] := by
    rw [← hF]; simp [limbsAt]
  have ef4 : S.mem.readAt (fp.add 32#64) 64 = st.FG.1[4] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 32#64) 64 = st.FG.2[4] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[4] ||| st.FG.1[4] == 0#64) = 1#1 then 4#32 else 5#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[4] ||| st.FG.1[4] = 0#64
    · have h' : st.FG.1[4] ||| st.FG.2[4] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[4] ||| st.FG.2[4] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[4] ||| st.FG.1[4] == 0#64) = 1#1 := by
        rw [show (st.FG.2[4] ||| st.FG.1[4] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure
  step_pure [show (4#32).msb = false from rfl]
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  finish_block
  bb13_steps

/-- `^bb2` for `len = 1`. -/
theorem tail2_1 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (_hst : JInv k st)
    (hl1 : st.len = 1) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (_hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  tail_prologue
  have hrs := res_eq st.pd.j
  have hdone : st.done → jacLoop (25 - k) st = 1 - 2 * (st.pd.j &&& 1) := by
    intro hd
    rw [show 25 - k = (24 - k) + 1 by omega, jacLoop_succ, ite_eq_left_of_eq_true _ _ (eq_true hd)]
  have hnl : BitVec.ofNat 32 st.next.len = 1#32 := by simp [hl1]
  have hd : st.done := ⟨h1, by simp [hiOr, hl1]⟩
  rw [hdone hd] at hexit
  block_init
  finish_block
  block_init
  step_load
  step_pure
  step_pure
  step_pure [hrs.1]
  step_lifetime
  finish_block
  rw [hrs.2] at hE
  step_loop using hexit
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
  exact her

/-- `^bb2` for `len = 2`. -/
theorem tail2_2 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 2) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  tail_prologue
  have hrs := res_eq st.pd.j
  have hdone : st.done → jacLoop (25 - k) st = 1 - 2 * (st.pd.j &&& 1) := by
    intro hd
    rw [show 25 - k = (24 - k) + 1 by omega, jacLoop_succ, ite_eq_left_of_eq_true _ _ (eq_true hd)]
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 8#64) 64 = st.FG.2[1] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[1] ||| st.FG.1[1] == 0#64) = 1#1 then 1#32 else 2#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[1] ||| st.FG.1[1] = 0#64
    · have h' : st.FG.1[1] ||| st.FG.2[1] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[1] ||| st.FG.2[1] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[1] ||| st.FG.1[1] == 0#64) = 1#1 := by
        rw [show (st.FG.2[1] ||| st.FG.1[1] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure [show (2#32).msb = false from rfl]
  step_pure
  step_pure
  finish_block
  block_init
  finish_block
  iterate 1
    block_init
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
  block_init
  step_pure
  finish_block
  · -- `hi == 0`: done
    have hd : st.done := ⟨h1, by rw [hl1, (hiOr_eq _).1]; exact hbr⟩
    rw [hdone hd] at hexit
    block_init
    step_load
    step_pure
    step_pure
    step_pure [hrs.1]
    step_lifetime
    finish_block
    rw [hrs.2] at hE
    step_loop using hexit
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
    exact her
  · -- `hi != 0`: on
    have hnd : ¬st.done := fun hd => hbr (by
      have := hd.2
      rw [hl1, (hiOr_eq _).1] at this
      exact this)
    block_init
    step_pure
    step_pure [show (1#32).msb = false from rfl]
    step_pure
    step_load
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
    bb13_steps

/-- `^bb2` for `len = 3`. -/
theorem tail2_3 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 3) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  tail_prologue
  have hrs := res_eq st.pd.j
  have hdone : st.done → jacLoop (25 - k) st = 1 - 2 * (st.pd.j &&& 1) := by
    intro hd
    rw [show 25 - k = (24 - k) + 1 by omega, jacLoop_succ, ite_eq_left_of_eq_true _ _ (eq_true hd)]
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 16#64) 64 = st.FG.2[2] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[2] ||| st.FG.1[2] == 0#64) = 1#1 then 2#32 else 3#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[2] ||| st.FG.1[2] = 0#64
    · have h' : st.FG.1[2] ||| st.FG.2[2] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[2] ||| st.FG.2[2] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[2] ||| st.FG.1[2] == 0#64) = 1#1 := by
        rw [show (st.FG.2[2] ||| st.FG.1[2] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure [show (3#32).msb = false from rfl]
  step_pure
  step_pure
  finish_block
  block_init
  finish_block
  iterate 2
    block_init
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
  block_init
  step_pure
  finish_block
  · -- `hi == 0`: done
    have hd : st.done := ⟨h1, by rw [hl1, (hiOr_eq _).2.1]; exact hbr⟩
    rw [hdone hd] at hexit
    block_init
    step_load
    step_pure
    step_pure
    step_pure [hrs.1]
    step_lifetime
    finish_block
    rw [hrs.2] at hE
    step_loop using hexit
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
    exact her
  · -- `hi != 0`: on
    have hnd : ¬st.done := fun hd => hbr (by
      have := hd.2
      rw [hl1, (hiOr_eq _).2.1] at this
      exact this)
    block_init
    step_pure
    step_pure [show (2#32).msb = false from rfl]
    step_pure
    step_load
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
    bb13_steps

/-- `^bb2` for `len = 4`. -/
theorem tail2_4 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 4) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  tail_prologue
  have hrs := res_eq st.pd.j
  have hdone : st.done → jacLoop (25 - k) st = 1 - 2 * (st.pd.j &&& 1) := by
    intro hd
    rw [show 25 - k = (24 - k) + 1 by omega, jacLoop_succ, ite_eq_left_of_eq_true _ _ (eq_true hd)]
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have ef3 : S.mem.readAt (fp.add 24#64) 64 = st.FG.1[3] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 24#64) 64 = st.FG.2[3] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[3] ||| st.FG.1[3] == 0#64) = 1#1 then 3#32 else 4#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[3] ||| st.FG.1[3] = 0#64
    · have h' : st.FG.1[3] ||| st.FG.2[3] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[3] ||| st.FG.2[3] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[3] ||| st.FG.1[3] == 0#64) = 1#1 := by
        rw [show (st.FG.2[3] ||| st.FG.1[3] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure [show (4#32).msb = false from rfl]
  step_pure
  step_pure
  finish_block
  block_init
  finish_block
  iterate 3
    block_init
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
  block_init
  step_pure
  finish_block
  · -- `hi == 0`: done
    have hd : st.done := ⟨h1, by rw [hl1, (hiOr_eq _).2.2.1]; exact hbr⟩
    rw [hdone hd] at hexit
    block_init
    step_load
    step_pure
    step_pure
    step_pure [hrs.1]
    step_lifetime
    finish_block
    rw [hrs.2] at hE
    step_loop using hexit
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
    exact her
  · -- `hi != 0`: on
    have hnd : ¬st.done := fun hd => hbr (by
      have := hd.2
      rw [hl1, (hiOr_eq _).2.2.1] at this
      exact this)
    block_init
    step_pure
    step_pure [show (3#32).msb = false from rfl]
    step_pure
    step_load
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
    bb13_steps

/-- `^bb2` for `len = 5`. -/
theorem tail2_5 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (hl1 : st.len = 5) (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S)
    (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  tail_prologue
  have hrs := res_eq st.pd.j
  have hdone : st.done → jacLoop (25 - k) st = 1 - 2 * (st.pd.j &&& 1) := by
    intro hd
    rw [show 25 - k = (24 - k) + 1 by omega, jacLoop_succ, ite_eq_left_of_eq_true _ _ (eq_true hd)]
  have ef1 : S.mem.readAt (fp.add 8#64) 64 = st.FG.1[1] := by
    rw [← hF]; simp [limbsAt]
  have ef2 : S.mem.readAt (fp.add 16#64) 64 = st.FG.1[2] := by
    rw [← hF]; simp [limbsAt]
  have ef3 : S.mem.readAt (fp.add 24#64) 64 = st.FG.1[3] := by
    rw [← hF]; simp [limbsAt]
  have ef4 : S.mem.readAt (fp.add 32#64) 64 = st.FG.1[4] := by
    rw [← hF]; simp [limbsAt]
  have eg : S.mem.readAt (gp.add 32#64) 64 = st.FG.2[4] := by
    rw [← hG]; simp [limbsAt]
  have hnl : BitVec.ofNat 32 st.next.len =
      if BitVec.ofBool (st.FG.2[4] ||| st.FG.1[4] == 0#64) = 1#1 then 4#32 else 5#32 := by
    simp only [hl1]
    by_cases h : st.FG.2[4] ||| st.FG.1[4] = 0#64
    · have h' : st.FG.1[4] ||| st.FG.2[4] = 0#64 := by rw [BitVec.or_comm]; exact h
      simp [h, h']
    · have h' : ¬st.FG.1[4] ||| st.FG.2[4] = 0#64 := by rw [BitVec.or_comm]; exact h
      have h'' : ¬BitVec.ofBool (st.FG.2[4] ||| st.FG.1[4] == 0#64) = 1#1 := by
        rw [show (st.FG.2[4] ||| st.FG.1[4] == 0#64) = false by simpa using h]
        decide
      simp [h', h'']
  block_init
  finish_block
  block_init
  step_pure [show (5#32).msb = false from rfl]
  step_pure
  step_pure
  finish_block
  block_init
  finish_block
  iterate 4
    block_init
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
  block_init
  step_pure
  finish_block
  · -- `hi == 0`: done
    have hd : st.done := ⟨h1, by rw [hl1, (hiOr_eq _).2.2.2]; exact hbr⟩
    rw [hdone hd] at hexit
    block_init
    step_load
    step_pure
    step_pure
    step_pure [hrs.1]
    step_lifetime
    finish_block
    rw [hrs.2] at hE
    step_loop using hexit
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le hbt]
    exact her
  · -- `hi != 0`: on
    have hnd : ¬st.done := fun hd => hbr (by
      have := hd.2
      rw [hl1, (hiOr_eq _).2.2.2] at this
      exact this)
    block_init
    step_pure
    step_pure [show (4#32).msb = false from rfl]
    step_pure
    step_load
    step_pure
    step_load
    iterate 3 step_pure
    finish_block
    bb13_steps

/-- `^bb10`, `f[0] != 1`: the top limb dropped when zero in both, then the next batch or out. -/
theorem tail10 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S) (hne : st.FG.1[0] ≠ 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 10 S >>= g) = K := by
  have hl := hst.len
  obtain hl1 | hl1 | hl1 | hl1 | hl1 :
      st.len = 1 ∨ st.len = 2 ∨ st.len = 3 ∨ st.len = 4 ∨ st.len = 5 := by omega
  · exact tail10_1 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm hne K g E hA hL hR hexit hback
  · exact tail10_2 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm hne K g E hA hL hR hexit hback
  · exact tail10_3 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm hne K g E hA hL hR hexit hback
  · exact tail10_4 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm hne K g E hA hL hR hexit hback
  · exact tail10_5 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm hne K g E hA hL hR hexit hback

/-- `^bb2`, `f[0] == 1`: done when `f[1 … len-1]` are zero, else as `^bb10`. -/
theorem tail2 (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (S : GlobalState) (hm : Mid fp gp jp tp A b M0 st S) (h1 : st.FG.1[0] = 1#64)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E) (hR : Regs k st E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom E 2 S >>= g) = K := by
  have hl := hst.len
  obtain hl1 | hl1 | hl1 | hl1 | hl1 :
      st.len = 1 ∨ st.len = 2 ∨ st.len = 3 ∨ st.len = 4 ∨ st.len = 5 := by omega
  · exact tail2_1 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm h1 K g E hA hL hR hexit hback
  · exact tail2_2 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm h1 K g E hA hL hR hexit hback
  · exact tail2_3 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm h1 K g E hA hL hR hexit hback
  · exact tail2_4 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm h1 K g E hA hL hR hexit hback
  · exact tail2_5 x fp gp jp tp A b M0 hp k hk st hst hl1 S hm h1 K g E hA hL hR hexit hback

theorem iter (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (k : Nat) (hk : k < 25) (st : JS) (hst : JInv k st)
    (S : GlobalState) (hh : Hdr fp gp jp tp A b M0 st S)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value x)).get) (hL : Consts fp gp jp tp E)
    (hexit : Out x fp gp jp tp A b M0 (jacLoop (25 - k) st) K g)
    (hback : ¬st.done → k + 1 < 25 → Back x fp gp jp tp A b M0 (k + 1) st.next K g) :
    (fd_f25519_jacobi_var.runFrom
        (hdr1 E st.f[0] (BitVec.ofNat 32 k) st.eta (BitVec.ofNat 32 st.len)) 1 S >>= g) = K := by
  have hp' := hp
  obtain ⟨hfg, hfj, hft, hgj, hgt, hjt, hfo, hgo, hjo, hto, hbf, hbg, hbj, hbt⟩ := hp'
  obtain ⟨hwf, hal, her, hF, hG, hJ, hf, hg, hfr, hgr, hj, hjr, htb, htw⟩ := hh
  have hL' := hL
  obtain ⟨hF0, hF1, hF2, hF3, hF4⟩ := fits_limbs hf (by simp [BitVec.uaddOverflow, hfo])
  obtain ⟨hG0, hG1, hG2, hG3, hG4⟩ := fits_limbs hg (by simp [BitVec.uaddOverflow, hgo])
  have hfo' : ¬fp.offset.uaddOverflow 40#64 := by simp [BitVec.uaddOverflow, hfo]
  have hgo' : ¬gp.offset.uaddOverflow 40#64 := by simp [BitVec.uaddOverflow, hgo]
  have e1 : (S.mem.readAt fp 320).extractLsb' 64 64 = st.f[1] := by
    rw [← hF]; exact extract_limb hf.inBounds hfo' (k := 1) (by omega)
  have e2 : S.mem.readAt gp 64 = st.g[0] := by
    rw [← hG]; simp [limbsAt]
  have e3 : (S.mem.readAt gp 320).extractLsb' 64 64 = st.g[1] := by
    rw [← hG]; exact extract_limb hg.inBounds hgo' (k := 1) (by omega)
  have he := hst.eta_le hk
  have hlen : 1 ≤ (BitVec.ofNat 32 st.len).toNat ∧ (BitVec.ofNat 32 st.len).toNat ≤ 5 := by
    have := hst.len
    simp only [BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hodd : (st.f[1] <<< 62 ||| st.f[0]) &&& 1 = 1 := by
    rw [BitVec.or_comm]; exact hst.f0_odd
  dsimp only [Consts] at hL'
  block_init
  step_lifetime
  step_load with f1
  rw [e1] at hf1
  subst hf1
  step_pure
  step_pure
  step_load with g0
  subst hg0
  step_load with g1
  rw [e3] at hg1
  subst hg1
  step_pure
  step_pure
  step_call using (Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var.call_eq (hf := hodd)
    (he := he.1) (he' := he.2)) with eta'
  have ht256 := fits_256 hto hfits_tp hfits_tp_8 hfits_tp_16 hfits_tp_24
  step_call using (Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var.call_eq (hlen := hlen)
    (hfo := hfo') (hgo := hgo') (hto := by simp [BitVec.uaddOverflow, hto]))
  case htw => rw [hS']; exact writable_storeFG htw
  have hpd : posdivsteps st.eta (st.f[1] <<< 62 ||| st.f[0]) (st.g[1] <<< 62 ||| st.g[0]) st.jac =
      st.pd := by
    rw [BitVec.or_comm (st.f[1] <<< 62), BitVec.or_comm (st.g[1] <<< 62)]
  have hlenN : (BitVec.ofNat 32 st.len).toNat = st.len := by
    have := hst.len
    simp only [BitVec.toNat_ofNat]
    exact Nat.mod_eq_of_lt (by omega)
  simp only [hpd, hlenN, limbsAt_storeAt, limbsAt_storeAt_add, limbsAt_lifetimeStart, ne_eq,
    hfj.symm, hft.symm, hgj.symm, hgt.symm, not_false_eq_true, hF, hG] at hS
  have hF' : limbsAt S.mem fp = st.FG.1 := by
    have hr := hfr
    rw [hS] at hr ⊢
    refine limbsAt_storeFG_f hfg (room_storeFG_iff.1 hr) hfo' hst.len.2 ?_
    intro k hk hlk
    rw [(updateFg_above hst.len _ _ _ _ _ _ k hlk hk).1]
    simp only [limbsAt_storeAt, limbsAt_storeAt_add, limbsAt_lifetimeStart, ne_eq, hfj.symm,
      hft.symm, not_false_eq_true, hF]
  have hG' : limbsAt S.mem gp = st.FG.2 := by
    have hr := hgr
    rw [hS] at hr ⊢
    refine limbsAt_storeFG_g hfg (room_storeFG_iff.1 hr) hgo' hst.len.2 ?_
    intro k hk hlk
    rw [(updateFg_above hst.len _ _ _ _ _ _ k hlk hk).2]
    simp only [limbsAt_storeAt, limbsAt_storeAt_add, limbsAt_lifetimeStart, ne_eq, hgj.symm,
      hgt.symm, not_false_eq_true, hG]
  have hJ' : S.mem.readAt jp 32 = st.pd.j := by
    have hr := hjr
    rw [hS] at hr ⊢
    simp only at hr ⊢
    rw [room_storeFG_iff, Room.storeAt_iff] at hr
    rw [readAt_storeFG_of_ne hfj hgj, MemoryState.readAt_storeAt_self hr]
  have e40 : S.mem.readAt fp 64 = st.FG.1[0] := by
    rw [← hF']; simp [limbsAt]
  have hal' : S.alloc = A := by rw [hS]; exact hal
  have her' : S.mem.eraseFrom b = M0 := by
    rw [hS]
    simp only
    rw [eraseFrom_storeFG hbf hbg, MemoryState.eraseFrom_storeAt_of_le hbj,
      MemoryState.eraseFrom_storeAt_of_le (p := tp.add _) hbt,
      MemoryState.eraseFrom_storeAt_of_le (p := tp.add _) hbt,
      MemoryState.eraseFrom_storeAt_of_le (p := tp.add _) hbt,
      MemoryState.eraseFrom_storeAt_of_le hbt, MemoryState.eraseFrom_lifetimeStart_of_le hbt]
    exact her
  have hm : Mid fp gp jp tp A b M0 st S :=
    ⟨‹_›, hal', her', hF', hG', hJ', ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›, ‹_›⟩
  rw [hpd] at heta'
  subst heta'
  step_load with f0'
  subst hf0'
  iterate 2 step_pure
  finish_block
  · exact tail2 x fp gp jp tp A b M0 hp k hk st hst S hm hbr K g E hArgs
      (by dsimp only [Consts]; env_reads) (by dsimp only [Regs]; env_reads) hexit hback
  · exact tail10 x fp gp jp tp A b M0 hp k hk st hst S hm hbr K g E hArgs
      (by dsimp only [Consts]; env_reads) (by dsimp only [Regs]; env_reads) hexit hback

/-- The loop from `^bb1` at batch `k` with `m = 25 - k` batches left: out with `jacLoop m st`. -/
theorem loop (x fp gp jp tp : Pointer) (A : AllocState) (b : Nat) (M0 : MemoryState)
    (hp : Ptrs fp gp jp tp b) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (g : Vals [.bv 32] × GlobalState → PoisonOr (Vals [.bv 32] × GlobalState)) (m : Nat) :
    ∀ (k : Nat) (st : JS) (S : GlobalState) (E : ⟪Γ⟫), k + m = 25 → k < 25 → JInv k st →
      Hdr fp gp jp tp A b M0 st S → E.args = (args (.value x)).get → Consts fp gp jp tp E →
      Out x fp gp jp tp A b M0 (jacLoop m st) K g →
      (fd_f25519_jacobi_var.runFrom
          (hdr1 E st.f[0] (BitVec.ofNat 32 k) st.eta (BitVec.ofNat 32 st.len)) 1 S >>= g) = K := by
  induction m with
  | zero => intro k _ _ _ h1 h2; omega
  | succ m ih =>
    intro k st S E hkm hk hst hh hA hL hK
    have hm : 25 - k = m + 1 := by omega
    refine iter x fp gp jp tp A b M0 hp k hk st hst S hh K g E hA hL (hm ▸ hK) ?_
    intro hnd hk1 E' S' hA' hL' hh'
    refine ih (k + 1) st.next S' E' (by omega) hk1 (hst.next hk) hh' hA' hL' ?_
    rw [jacLoop_succ, ite_eq_right_of_eq_false _ _ (eq_false hnd)] at hK
    exact hK

/-- `fd_f25519_jacobi_var( x )` for `x`'s five limbs, the bottom one below `2^62`: the Jacobi
symbol `jacobi` of the limbs, the state as before but for the frame's four slots. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var.call_eq (x : Pointer)
    (s : GlobalState) (hwf : s.WF) (hx : Fits s.mem x 320) (hxo : ¬x.offset.uaddOverflow 40#64)
    (hx0 : s.mem.readAt x 64 < 4611686018427387904#64) :
    Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var.call
        (Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var.args (.value x)) s =
      .value (.cons (.value (jacobi (limbsAt s.mem x))) .nil,
        {alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem}) := by
  obtain ⟨hX0, hX1, hX2, hX3, hX4⟩ := fits_limbs hx hxo
  have hx0' : (limbsAt s.mem x)[0] < 4611686018427387904#64 := by simpa [limbsAt] using hx0
  clear hx0
  generalize hX : limbsAt s.mem x = X at hx0' ⊢
  func_init
  block_init
  iterate 17 step_pure
  iterate 4 step_alloca
  step_lifetime
  step_pure
  step_store
  step_pure
  step_store
  step_lifetime
  step_pure
  step_load
  step_store
  step_pure
  step_pure
  step_load
  step_store
  step_lifetime
  step_store
  finish_block
  have hov : ∀ (p : Pointer) (off : BitVec 64), p.offset = 0 → ¬p.offset.uaddOverflow off := by
    intro p off h; simp [BitVec.uaddOverflow, h, off.isLt]
  have hp : Ptrs v17 v18 v19 v20 S₀.alloc.nextFreeBlock := by
    subst hv17 hv18 hv19 hv20
    simp [Ptrs, GlobalState.slot]
  have hF17 : limbsAt S.mem v17 = pLimbs := by
    obtain ⟨e0, e1, e2, e3⟩ := extract_packLanes4 #v[4611686018427387885#64,
      4611686018427387903#64, 4611686018427387903#64, 4611686018427387903#64]
    rw [limbsAt_of_256 hv17_bounds (hov _ _ hv17_off) hread_v17 hread_v17_32, e0, e1, e2, e3]
    rfl
  have hF18 : limbsAt S.mem v18 = X := by
    rw [← hX]
    rw [limbsAt_of_256 hv18_bounds (hov _ _ hv18_off) hread_v18 hread_v18_32,
      limbsAt_of_256 hx₀.inBounds hxo rfl rfl]
    obtain ⟨e0, e1, e2, e3⟩ := extract_packLanes4
      (Vector.ofFn fun i => Ty.extractVecElem 4 64 i (S₀.mem.readAt x 256))
    rw [e0, e1, e2, e3]
    simp [Ty.extractVecElem_eq]
  have hJ0 : JInv 0 ⟨pLimbs, X, 5, 18446744073709551615#64, 0#32⟩ := by
    unfold JInv
    refine ⟨by show 1 ≤ 5; omega, by show 5 ≤ 5; omega, by show pLimbs[0] &&& 1 = 1; decide,
      fun _ => ⟨by show pLimbs[0] < 4611686018427387904#64; decide, hx0'⟩,
      fun h => absurd h (by show ¬5 = 1; omega),
      by show (18446744073709551615#64).sle (bnd 0) = true; decide,
      by show (-bnd 0).sle 18446744073709551615#64 = true; decide⟩
  have hA0 : S.alloc = ⟨S₀.alloc.nextFreeBlock + 4⟩ := by
    rw [hS]
    simp
  have hM0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    obtain ⟨-, -, -, -, -, -, -, -, -, -, h17, h18, h19, h20⟩ := hp
    rw [hS]
    simp only [MemoryState.eraseFrom_storeAt_of_le h19,
      MemoryState.eraseFrom_storeAt_of_le (p := v18.add _) h18,
      MemoryState.eraseFrom_storeAt_of_le h18,
      MemoryState.eraseFrom_storeAt_of_le (p := v17.add _) h17,
      MemoryState.eraseFrom_storeAt_of_le h17, MemoryState.eraseFrom_lifetimeStart_of_le h17,
      MemoryState.eraseFrom_lifetimeStart_of_le h18, MemoryState.eraseFrom_lifetimeStart_of_le h19]
    rw [GlobalState.eraseFrom_alloca_of_le (by simp; omega),
      GlobalState.eraseFrom_alloca_of_le (by simp; omega),
      GlobalState.eraseFrom_alloca_of_le (by simp), GlobalState.eraseFrom_alloca,
      mem_eraseFrom_self hwf₀]
  have hf17 : Fits S.mem v17 320 :=
    Fits.append (hov _ 32#64 hv17_off) (by decide) rfl hfits_v17 hfits_v17_32
  have hf18 : Fits S.mem v18 320 :=
    Fits.append (hov _ 32#64 hv18_off) (by decide) rfl hfits_v18 hfits_v18_32
  have hH : Hdr v17 v18 v19 v20 S.alloc S₀.alloc.nextFreeBlock
      (S.mem.eraseFrom S₀.alloc.nextFreeBlock) ⟨pLimbs, X, 5, 18446744073709551615#64, 0#32⟩ S :=
    ⟨hwf, rfl, rfl, hF17, hF18, hread_v19, hf17, hf18, hroom_v17, hroom_v18, hfits_v19, hroom_v19,
      hv20_bounds, hwritable_v20⟩
  step_loop using loop x v17 v18 v19 v20 S.alloc S₀.alloc.nextFreeBlock
    (S.mem.eraseFrom S₀.alloc.nextFreeBlock) hp _ _ 25 0
    ⟨pLimbs, X, 5, 18446744073709551615#64, 0#32⟩
    S _ rfl (by decide) hJ0 hH
  intro hC' hwf' hal' her'
  block_init
  iterate 3 step_lifetime
  finish_block
  subst hS
  dsimp only at hal'
  obtain ⟨-, -, -, -, -, -, -, -, -, -, h17, h18, h19, -⟩ := hp
  simp only [MemoryState.eraseFrom_lifetimeEnd_of_le h17,
    MemoryState.eraseFrom_lifetimeEnd_of_le h18, MemoryState.eraseFrom_lifetimeEnd_of_le h19, her',
    hM0, hal', hA0]
  rfl

end fd_f25519_jacobi_var

end Proof

end MLIR.Firedancer.LaneNI

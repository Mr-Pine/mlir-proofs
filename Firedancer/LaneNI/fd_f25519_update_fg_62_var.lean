module

public import Firedancer.LaneNI.Common.Limbs
public import Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.LaneNI

open Firedancer.Lane.Jacobi

/-! ## Proof -/

section Proof

namespace fd_f25519_update_fg_62_var

open Firedancer.LaneNI.Mlir Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var

set_option hygiene false in
/-- The entry block: `t`, `f[0]`, `g[0]`, the first carries, the test `len > 1`. -/
local macro "entry_steps" : tactic =>
  `(tactic|
    ( obtain ⟨hF0, hF1, hF2, hF3, hF4⟩ := fits_limbs hf hfo
      obtain ⟨hG0, hG1, hG2, hG3, hG4⟩ := fits_limbs hg hgo
      obtain ⟨hFr0, hFr1, hFr2, hFr3, hFr4⟩ := room_limbs hfr hfo
      obtain ⟨hGr0, hGr1, hGr2, hGr3, hGr4⟩ := room_limbs hgr hgo
      func_init
      block_init
      iterate 6 step_pure
      step_load with u
      step_pure
      step_load with v
      step_pure
      step_load with q
      step_pure
      step_load with r
      step_pure
      step_load with f0
      iterate 3 step_pure [sext_mul_noov]
      step_load with g0
      iterate 13 step_pure [sext_mul_noov]
      finish_block))

/-- A pass of the loop: limb `i` into the carries, limb `i - 1` stored. -/
local macro "loop_steps" : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_load
      iterate 3 step_pure [sext_mul_noov]
      step_load
      iterate 2 step_pure [sext_mul_noov]
      step_pure [add_noov]
      iterate 3 step_pure [sext_mul_noov]
      step_pure [add_noov]
      iterate 5 step_pure
      step_store
      iterate 3 step_pure
      step_store
      iterate 4 step_pure
      finish_block))

set_option hygiene false in
/-- The top limbs stored, and the result. -/
local macro "exit_steps" : tactic =>
  `(tactic|
    ( block_init
      iterate 3 step_pure
      step_store
      step_pure
      step_store
      finish_block
      subst hS
      rw [carry_init u v f0 g0, carry_init q r f0 g0]
      simp only [carry_step]
      subst hu hv hq hr hf0 hg0
      simp only [MemoryState.eraseFrom_storeAt, mem_eraseFrom_self hwf₀]
      simp [storeFG, updateFg, updLoop, limbsAt]))

/-- The call's hypotheses: `f` and `g` five limbs each, in distinct blocks, `t` four. -/
abbrev Pre (f g t : Pointer) (s : GlobalState) : Prop :=
  s.WF ∧ Fits s.mem f 320 ∧ Fits s.mem g 320 ∧ Room s.mem f 320 ∧ Room s.mem g 320 ∧
    Fits s.mem t 256 ∧ f.id ≠ g.id ∧ ¬f.offset.uaddOverflow 40#64 ∧
      ¬g.offset.uaddOverflow 40#64 ∧ ¬t.offset.uaddOverflow 32#64

/-- The call's result for `len`: `[f, g] = t [f, g] / 2^62` on the low `len` limbs. -/
abbrev Post (len : Nat) (f g t : Pointer) (s : GlobalState) :
    PoisonOr (Vals [] × GlobalState) :=
  let FG := updateFg len (limbsAt s.mem f) (limbsAt s.mem g) (s.mem.readAt t 64)
    (s.mem.readAt (t.add 8#64) 64) (s.mem.readAt (t.add 16#64) 64)
    (s.mem.readAt (t.add 24#64) 64)
  .value (.nil, {s with mem := storeFG s.mem f g FG.1 FG.2 len})

/-- `len = 1`. -/
theorem len1 (f g t : Pointer) (s : GlobalState) (h : Pre f g t s) :
    fd_f25519_update_fg_62_var.call (args (.value 1#32) (.value f) (.value g) (.value t)) s =
      Post 1 f g t s := by
  obtain ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩ := h
  entry_steps
  exit_steps

/-- `len = 2`. -/
theorem len2 (f g t : Pointer) (s : GlobalState) (h : Pre f g t s) :
    fd_f25519_update_fg_62_var.call (args (.value 2#32) (.value f) (.value g) (.value t)) s =
      Post 2 f g t s := by
  obtain ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩ := h
  entry_steps
  block_init
  step_pure [show (2#32).msb = false from rfl]
  finish_block
  iterate 1 loop_steps
  block_init
  iterate 2 step_pure
  finish_block
  exit_steps

/-- `len = 3`. -/
theorem len3 (f g t : Pointer) (s : GlobalState) (h : Pre f g t s) :
    fd_f25519_update_fg_62_var.call (args (.value 3#32) (.value f) (.value g) (.value t)) s =
      Post 3 f g t s := by
  obtain ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩ := h
  entry_steps
  block_init
  step_pure [show (3#32).msb = false from rfl]
  finish_block
  iterate 2 loop_steps
  block_init
  iterate 2 step_pure
  finish_block
  exit_steps

/-- `len = 4`. -/
theorem len4 (f g t : Pointer) (s : GlobalState) (h : Pre f g t s) :
    fd_f25519_update_fg_62_var.call (args (.value 4#32) (.value f) (.value g) (.value t)) s =
      Post 4 f g t s := by
  obtain ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩ := h
  entry_steps
  block_init
  step_pure [show (4#32).msb = false from rfl]
  finish_block
  iterate 3 loop_steps
  block_init
  iterate 2 step_pure
  finish_block
  exit_steps

/-- `len = 5`. -/
theorem len5 (f g t : Pointer) (s : GlobalState) (h : Pre f g t s) :
    fd_f25519_update_fg_62_var.call (args (.value 5#32) (.value f) (.value g) (.value t)) s =
      Post 5 f g t s := by
  obtain ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩ := h
  entry_steps
  block_init
  step_pure [show (5#32).msb = false from rfl]
  finish_block
  iterate 4 loop_steps
  block_init
  iterate 2 step_pure
  finish_block
  exit_steps

end fd_f25519_update_fg_62_var

/-- `fd_f25519_update_fg_62_var( len, f, g, t )` for `len` in `[1, 5]`: `[f, g] = t [f, g] / 2^62`
on the low `len` limbs, stored limb by limb. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var.call_eq (len : BitVec 32)
    (f g t : Pointer) (s : GlobalState) (hwf : s.WF) (hlen : 1 ≤ len.toNat ∧ len.toNat ≤ 5)
    (hf : Fits s.mem f 320) (hg : Fits s.mem g 320) (hfr : Room s.mem f 320)
    (hgr : Room s.mem g 320) (ht : Fits s.mem t 256) (hfg : f.id ≠ g.id)
    (hfo : ¬f.offset.uaddOverflow 40#64) (hgo : ¬g.offset.uaddOverflow 40#64)
    (hto : ¬t.offset.uaddOverflow 32#64) :
    Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var.call
        (Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var.args (.value len) (.value f)
          (.value g) (.value t)) s =
      let FG := updateFg len.toNat (limbsAt s.mem f) (limbsAt s.mem g) (s.mem.readAt t 64)
        (s.mem.readAt (t.add 8#64) 64) (s.mem.readAt (t.add 16#64) 64)
        (s.mem.readAt (t.add 24#64) 64)
      .value (.nil, {s with mem := storeFG s.mem f g FG.1 FG.2 len.toNat}) := by
  have h : fd_f25519_update_fg_62_var.Pre f g t s := ⟨hwf, hf, hg, hfr, hgr, ht, hfg, hfo, hgo, hto⟩
  have hl : len = 1#32 ∨ len = 2#32 ∨ len = 3#32 ∨ len = 4#32 ∨ len = 5#32 := by
    have : len.toNat = 1 ∨ len.toNat = 2 ∨ len.toNat = 3 ∨ len.toNat = 4 ∨ len.toNat = 5 := by
      omega
    rcases this with h | h | h | h | h <;> simp [← h]
  rcases hl with rfl | rfl | rfl | rfl | rfl
  · exact fd_f25519_update_fg_62_var.len1 f g t s h
  · exact fd_f25519_update_fg_62_var.len2 f g t s h
  · exact fd_f25519_update_fg_62_var.len3 f g t s h
  · exact fd_f25519_update_fg_62_var.len4 f g t s h
  · exact fd_f25519_update_fg_62_var.len5 f g t s h

end Proof

end MLIR.Firedancer.LaneNI

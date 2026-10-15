module

public import Firedancer.Lane.verify_x8.ScalarsDefs
public import Firedancer.Lane.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Common.Tactics

/-! `verify_x8`'s scalars (`^bb76 … ^bb78`, `^bb75`): per live item `k[j]` the reduced digest and
`s[j]` its `S`; then `a.x`, `a.t` negated, and `kd`, `sd` started. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl zipWith_add_wwl zipWith_sub_wwl zipWith_and_wwl
  zipWith_lshr_wwl

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb76` at item `j`: for a live one (`^bb77`) `fd_curve25519_scalar_reduce( k[j], hashes[j] )`
and `fd_memcpy( s[j], sigs[j]+32, 32 )`; on to `^bb78`. -/
theorem scal_trip (c : Call) (hc : c.Ok) (j : Nat) (hj : j < c.cnt) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvS c E j) (hS : c.InvS j S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvS c E' j →
        c.InvS (j + 1) S' → ((verify_x8 c.batch).runFrom E' 78 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 76 S >>= g) = K := by
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hmod : j % 4294967296 = j := Nat.mod_eq_of_lt (by omega)
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have h32 : ¬32 ≤ j := by omega
  have hwf := hS.base.wf
  have hkr := hS.ks.room_k (hS.base.writable 26 (by decide)) hj8
  have hsr := hS.ks.room_s (hS.base.writable 27 (by decide)) hj8
  obtain ⟨hsb, hsl, hso, hsf, hsrd, hso32, hslt, hsglt⟩ := hS.base.sig76 hc hj
  have hin_off := slot_row_ov c.s 31 (j := j) (n := 64) hj8 (by decide)
  have hdig (hl : c.X.liveAt j = true) := hS.hashes j hj hl
  rw [Nat.mul_comm 64 j] at hdig
  have hin (hl : c.X.liveAt j = true) := (hdig hl).1
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hI : c.InvS j S₀ := hS₀ ▸ hS
  rw [← hS₀] at hsl hsrd hdig
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨76, (by decide : 76 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure [hmod, h32, one_shl_shr hj8]
  step_pure
  step_pure
  finish_block
  · rw [c.liveAt_of_bit hj8] at hbr
    exact hK E S hArgs (by dsimp only [EnvS]; env_reads) (hS₀ ▸ hI.dead hj8 hbr)
  · rw [c.liveAt_of_bit hj8, Bool.not_eq_false] at hbr
    replace hin := hin hbr
    have hdr := (hdig hbr).2
    clear hdig
    block_init
    step_pure [hmod64]
    step_pure [hmod64]
    step_call using fd_curve25519_scalar_reduce.call_eq
    subst hS₀
    step_pure [hmod64]
    step_pure [hmod64]
    step_load [MemoryState.loadPtr_storeAt_disjoint
      (Range.disjoint_of_id_ne (slot_id_ne hsglt 26 _ (BitVec.ofNat 64 (j * 8)))), hsl]
    step_pure
    have hdisj : (Range.of ((c.s.slot 27).add (BitVec.ofNat 64 (j * 32))) (8 * 32)).Disjoint
        (Range.of ((c.it j).sig.add 32#64) (8 * 32)) :=
      Range.disjoint_of_id_ne (slot_id_ne hslt 27 _ _)
    step_memcpy consuming hsf hdisj
    finish_block
    refine hK E S hArgs (by dsimp only [EnvS]; env_reads) ?_
    rw [hS, hdr, MemoryState.readAt_storeAt_disjoint
      (Range.disjoint_of_id_ne (slot_id_ne hslt 26 _ 32#64)), hsrd]
    exact hI.live hbr

/-- `^bb78`: `j++`; on to item `j + 1`, or past the last to `^bb75`. -/
theorem scal_bb78 (c : Call) (hc : c.Ok) (j : Nat) (hj : j < c.cnt) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvS c E j) (hS : c.InvS (j + 1) S)
    (hback :
      j + 1 < c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvS c E' (j + 1) →
        c.InvS (j + 1) S' → ((verify_x8 c.batch).runFrom E' 76 S' >>= g) = K)
    (hexit :
      j + 1 = c.cnt → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvS c E' j →
        c.InvS c.cnt S' → ((verify_x8 c.batch).runFrom E' 75 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 78 S >>= g) = K := by
  have h8 := hc.cnt8
  obtain ⟨hov, hadd⟩ := scal_inc (j := j) (by omega)
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨78, (by decide : 78 < 104)⟩ S >>= g) = K
  block_init
  step_pure [hov, hadd]
  step_pure
  finish_block
  · rw [scal_exit (by omega) h8] at hbr
    exact hexit hbr E S hArgs (by dsimp only [EnvS]; env_reads) (hbr ▸ hS)
  · rw [scal_exit (by omega) h8] at hbr
    exact hback (by omega) E S hArgs (by dsimp only [EnvS]; env_reads) hS

/-- `^bb75` from position 34, `a.x` negated: `a.t` negated, `kd` and `sd` started; on to
`^bb80`. -/
theorem scal_negT (c : Call) (S₀ : GlobalState) (hI : c.InvS c.cnt S₀) (X : Fe)
    (hX : X = sub Fe.zero c.decA.1.x) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hE : EnvN c E) (hm : S.mem = S₀.mem.storeFe (c.s.slot 28) X) (hwf : S.WF)
    (hal : S.alloc = S₀.alloc) (ha : S.mem.LanePointFit (c.s.slot 28))
    (har : S.mem.LanePointRoom (c.s.slot 28))
    (h80 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env80 c E' → c.At80 S' →
        ((verify_x8 c.batch).runFrom E' 80 S' >>= g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb75.runBodyFrom E 34 S >>= G75 c g) = K := by
  obtain ⟨S₁, hS₁⟩ : ∃ S₁, S₁ = S := ⟨S, rfl⟩
  rw [← hS₁] at hm hal
  split_reads hE
  unfold G75
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t0
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t1
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t2
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t3
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t4
  step_pure
  iterate 11 step_pure
  step_store
  subst hS₁
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  step_pure
  step_pure
  finish_block
  have hT : sub Fe.zero ⟨t0, t1, t2, t3, t4⟩ = sub Fe.zero c.decA.1.t := by
    have h1 : S₁.mem.readFe ((c.s.slot 28).add 960#64) = c.decA.1.t := by
      rw [hm, MemoryState.readFe_storeFe_base_apart hI.a.fit.1 (by decide) (by decide)]
      exact congrArg Point.t hI.a.read
    rw [ht0, ht1, ht2, ht3, ht4, ← h1]
    simp only [MemoryState.readFe, Pointer.add_add, BitVec.reduceAdd]
  refine h80 E S hArgs (by dsimp only [Env80]; env_reads)
    (hI.at80 hX hT ?_ hwf (by rw [hS]; exact hal))
  rw [hS]
  dsimp only
  rw [hm]
  simp only [MemoryState.storeFe, MemoryState.storeVec, Pointer.add_add, BitVec.reduceAdd,
    sub_zero_eq]

/-- `^bb75`: `a.x` negated, then `scal_negT`. -/
theorem scal_neg (c : Call) (j : Nat) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvS c E j) (hS : c.InvS c.cnt S)
    (h80 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env80 c E' → c.At80 S' →
        ((verify_x8 c.batch).runFrom E' 80 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 75 S >>= g) = K := by
  have hwf := hS.base.wf
  have ha := hS.a.fit
  have har : S.mem.LanePointRoom (c.s.slot 28) := ha.room (hS.base.writable 28 (by decide))
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  have hI : c.InvS c.cnt S₀ := hS₀ ▸ hS
  clear hS
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨75, (by decide : 75 < 104)⟩ S >>= g) = K
  block_init
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x0
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x1
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x2
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x3
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x4
  step_pure
  iterate 7 step_pure
  step_store
  subst hS₀
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  iterate 2 step_pure
  step_store
  clear_stored
  have hX : sub Fe.zero ⟨x0, x1, x2, x3, x4⟩ = sub Fe.zero c.decA.1.x := by
    rw [hx0, hx1, hx2, hx3, hx4, ← congrArg Point.x hI.a.read]
    rfl
  refine scal_negT c S₀ hI _ hX E S hArgs (by dsimp only [EnvN]; env_reads) ?_ hwf (by rw [hS])
    ha har h80
  rw [hS]
  dsimp only
  simp only [MemoryState.storeFe, MemoryState.storeVec, sub_zero_eq]

/-- The loop from item `j`, `n + 1` items left: on to `^bb75` with `k` and `s` filled. -/
theorem scal_loop (c : Call) (hc : c.Ok)
    (hexit :
      ∀ (j : Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvS c E' j →
        c.InvS c.cnt S' → ((verify_x8 c.batch).runFrom E' 75 S' >>= g) = K) :
    ∀ n j (E : ⟪Γ⟫) (S : GlobalState), j + n + 1 = c.cnt → E.args = c.args → EnvS c E j →
      c.InvS j S → ((verify_x8 c.batch).runFrom E 76 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro j E S hn hA hE hS
    refine scal_trip c hc j (by omega) E S hA hE hS fun E' S' hA' hE' hS' => ?_
    exact scal_bb78 c hc j (by omega) E' S' hA' hE' hS' (fun h => absurd h (by omega))
      fun _ => hexit j
  | succ n ih =>
    intro j E S hn hA hE hS
    refine scal_trip c hc j (by omega) E S hA hE hS fun E' S' hA' hE' hS' => ?_
    exact scal_bb78 c hc j (by omega) E' S' hA' hE' hS'
      (fun _ E'' S'' h1 h2 h3 => ih (j + 1) E'' S'' (by omega) h1 h2 h3)
      fun h => absurd h (by omega)

/-- The loop at `^bb76`, then `^bb75`. -/
public theorem scalars_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env76 c E) (hS : c.At76 S)
    (h80 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env80 c E' → c.At80 S' →
        ((verify_x8 c.batch).runFrom E' 80 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 76 S >>= g) = K := by
  have h3 := hc.cnt3
  refine scal_loop c hc (fun j E' S' hA' hE' hS' => scal_neg c j E' S' hA' hE' hS' h80)
    (c.cnt - 1) 0 E S (by omega) hA hE ?_
  exact ⟨hS.base, by rw [Call.kUpTo_zero, Call.sUpTo_zero]; exact hS.ks, hS.a, hS.r, hS.hashes⟩

end MLIR.Firedancer.Lane.VerifyX8

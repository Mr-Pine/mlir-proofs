module

public import Firedancer.Lane.verify_x8.Cand
public import Firedancer.Lane.verify_x8.Decode
public import Firedancer.Lane.verify_x8.Checks
public import Firedancer.Lane.verify_x8.Hash
public import Firedancer.Lane.verify_x8.Scalars
public import Firedancer.Lane.verify_x8.Recode
public import Firedancer.Lane.verify_x8.Table
public import Firedancer.Lane.verify_x8.Ladder
public import Firedancer.Lane.verify_x8.Final
public import Firedancer.Lane.verify_x8.Codes

/-! `verify_x8` conforms to `X8CallSpec`: its stages chained. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

/-- `verify_x8` returns with its memory outside the frame, the counter past the entry's. -/
theorem run_ok (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global)
    (nb) (hb : BatchCallEq batch G nb) (a : Arrays) (it : Nat → Item) (cnt : Nat)
    (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals ((verify_x8 batch).globals ++ G))
    (h3 : 3 ≤ cnt) (h8 : cnt ≤ 8) (hB : BatchOk s.mem a it cnt) :
    ∃ s',
      (verify_x8 batch).call
          (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results)
            (.value (BitVec.ofNat 64 cnt)))
          s =
        .value (.nil, s') ∧
      s'.mem = x8Mem s.mem a.results it cnt ∧ s.alloc.nextFreeBlock ≤ s'.alloc.nextFreeBlock := by
  suffices h :
      ((verify_x8 batch).call
          (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results)
            (.value (BitVec.ofNat 64 cnt)))
          s >>= fun p =>
        PoisonOr.value
          (p.2.mem = x8Mem s.mem a.results it cnt ∧
            s.alloc.nextFreeBlock ≤ p.2.alloc.nextFreeBlock)) =
        .value True by
    revert h
    cases (verify_x8 batch).call
        (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value a.msgs) (.value a.msgSzs)
          (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results)
          (.value (BitVec.ofNat 64 cnt))) s with
    | poison => intro h; cases h
    | value p =>
      obtain ⟨r, s'⟩ := p
      intro h
      cases r
      injection h with h
      injection h with h
      exact ⟨s', rfl, (of_eq_true h).1, (of_eq_true h).2⟩
  func_init
  subst hS
  simp only [bind_assoc, PoisonOr.value_bind]
  have hc : Call.Ok ⟨batch, G, a, it, cnt, S⟩ := ⟨hwf, hg, h3, h8, hB⟩
  -- the return: the memory outside the frame and the counter, from a stage's `Base`
  have hret (S' : GlobalState) (M : MemoryState) (hM : M = x8Mem S.mem a.results it cnt)
      (hS' : Call.Base ⟨batch, G, a, it, cnt, S⟩ S' M) (S'' : GlobalState)
      (ha : S''.alloc = S'.alloc) (hm : S''.mem.eraseFrom S.alloc.nextFreeBlock = M) :
      PoisonOr.value
          (S''.mem.eraseFrom S.alloc.nextFreeBlock = x8Mem S.mem a.results it cnt ∧
            S.alloc.nextFreeBlock ≤ S''.alloc.nextFreeBlock) =
        PoisonOr.value True := by
    refine congrArg _ (eq_true ⟨hm.trans hM, ?_⟩)
    have := hS'.frame
    dsimp only at this
    rw [ha]
    omega
  refine cand_run ⟨batch, G, a, it, cnt, S⟩ hc E hEargs ?_ ?_
  · intro E S1 hA hE hS1 _
    refine decode_run _ hc E S1 hA hE hS1 fun E S2 hA hE hS2 => ?_
    refine checks_run _ hc E S2 hA hE hS2 ?_ ?_
    · intro E S3 hA hE hS3 hlive
      refine hash_run _ hc nb hb E S3 hA hE hS3 hlive fun E S4 hA hE hS4 => ?_
      refine scalars_run _ hc E S4 hA hE hS4 fun E S5 hA hE hS5 => ?_
      refine recode_run _ hc E S5 hA hE hS5 fun E S6 hA hE hS6 => ?_
      refine table_run _ hc E S6 hA hE hS6 fun E S7 hA hE hS7 => ?_
      refine ladder_run _ E S7 hA hE hS7 fun E S8 hA hE hS8 => ?_
      refine final_run _ hc E S8 hA hE hS8 fun E S9 hA hE hS9 => ?_
      exact ret102 _ E S9 _ hE hS9 (hret S9 _ rfl hS9)
    · intro E S3 hA hE hS3 hlive
      exact ret102 _ E S3 _ hE hS3 (hret S3 _ (Call.mem62_eq _ hlive) hS3)
  · intro E S1 hA hE hS1 hcand
    exact ret103 _ E S1 _ hE hS1 (hret S1 _ (Call.mem38_eq _ hc hcand) hS1)

end MLIR.Firedancer.Lane.VerifyX8

open MLIR MLIR.Firedancer.Lane
open _root_.Firedancer.Lane.Mlir (verify_x8)

/-- `verify_x8` on a batch of `3 ≤ cnt ≤ 8` items stores each item's `x8` code at `results[j]` and
the streamed items' hash objects (`X8CallSpec`), given the multi-buffer SHA-512's interface. -/
public theorem _root_.Firedancer.Lane.Mlir.verify_x8.call_spec
    (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global)
    (hb : BatchSpec batch G) : X8CallSpec batch G := by
  obtain ⟨nb, hb⟩ := hb
  classical
  -- the frame: the blocks the call leaves allocated past the entry's counter
  let nbx : Arrays → (Nat → Item) → Nat → GlobalState → Nat := fun a it cnt s =>
    match (verify_x8 batch).call
        (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value a.msgs) (.value a.msgSzs)
          (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results)
          (.value (BitVec.ofNat 64 cnt))) s with
    | .value (_, s') => s'.alloc.nextFreeBlock - s.alloc.nextFreeBlock
    | .poison => 0
  refine ⟨nbx, fun a it cnt s hwf hg h3 h8 hB => ?_⟩
  obtain ⟨s', hcall, hmem, hle⟩ :=
    VerifyX8.run_ok batch G nb hb a it cnt.toNat s hwf hg h3 h8 hB
  rw [BitVec.ofNat_toNat, BitVec.setWidth_eq] at hcall
  have hn : nbx a it cnt.toNat s = s'.alloc.nextFreeBlock - s.alloc.nextFreeBlock := by
    simp only [nbx, BitVec.ofNat_toNat, BitVec.setWidth_eq, hcall]
  rw [hcall, hn, ← hmem, Nat.add_sub_cancel' hle]

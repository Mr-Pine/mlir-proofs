module

public import Firedancer.Lane.verify_x8.Codes

/-! The memory of `verify_x8`'s last loop: the live items' codes stored over the checks', item by
item (`finMem`) or by one masked store, ending in `x8Mem`; `Base` past such stores. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref

@[expose] public section

namespace Call

variable (c : Call)

/-- `results[j]` once the items `j < k` are done: a live one's code, else the checks'. -/
noncomputable def finCode (k j : Nat) : BitVec 32 :=
  if j < k ∧ c.X.liveAt j = true then c.X.resultAt j else c.code1 j

/-- The memory outside the frame once the items `j < k` are done. -/
noncomputable def finMem (k : Nat) : MemoryState :=
  storeResults (streamMem c.s.mem c.it c.long c.cnt) c.a.results (c.finCode k) c.cnt

theorem finMem_zero : c.finMem 0 = c.mem76 :=
  storeResults_congr fun j _ => by simp [finCode]

/-- A live item's code stored. -/
theorem finMem_succ_live (hc : c.Ok) {k : Nat} (hk : k < c.cnt) (hl : c.X.liveAt k = true) :
    (c.finMem k).storeAt (c.a.result k) (c.X.resultAt k) = c.finMem (k + 1) := by
  rw [finMem, Arrays.result, storeResults_storeAt hk hc.batch.off.2.2.2.2.2]
  refine storeResults_congr fun j _ => ?_
  by_cases hj : j = k
  · subst hj; simp [finCode, hl]
  · rw [Function.update_of_ne hj]
    simp only [finCode, show j < k + 1 ↔ j < k by omega]

/-- A dead item skipped. -/
theorem finMem_succ_dead {k : Nat} (hl : c.X.liveAt k = false) : c.finMem k = c.finMem (k + 1) :=
  storeResults_congr fun j _ => by
    by_cases hj : j = k
    · subst hj; simp [finCode, hl]
    · simp only [finCode, show j < k + 1 ↔ j < k by omega]

/-- All items done: `verify_x8`'s memory. -/
theorem finMem_cnt : c.finMem c.cnt = x8Mem c.s.mem c.a.results c.it c.cnt := by
  refine storeResults_congr fun j hj => ?_
  simp only [finCode, hj, true_and]
  split
  · rfl
  · rename_i hl
    exact c.code1_of_not_live (by simpa using hl)

/-- The eight-lane store: lane `j` the code of a live item `j`. -/
theorem mem76_maskedStoreAt (hc : c.Ok) (h8 : c.cnt = 8) {V : Vector (BitVec 32) 8}
    {M : Vector (BitVec 1) 8}
    (hV : ∀ (j : Nat) (h : j < 8), M[j] = (if c.X.liveAt j then 1#1 else 0#1) ∧
      (c.X.liveAt j = true → V[j] = c.X.resultAt j)) :
    c.mem76.maskedStoreAt c.a.results V M = x8Mem c.s.mem c.a.results c.it c.cnt := by
  rw [mem76, storeResults_maskedStoreAt (by omega) hc.batch.off.2.2.2.2.2, ← finMem_cnt]
  refine storeResults_congr fun j hj => ?_
  have hj8 : j < 8 := by omega
  obtain ⟨hM, hV⟩ := hV j hj8
  simp only [hj8, dite_true, hM, finCode, hj, true_and]
  cases hl : c.X.liveAt j
  · simp
  · simp [hV hl]

variable {c} in
/-- `Base` past stores into `results`' block. -/
theorem Base.of_storesOff (hc : c.Ok) {S : GlobalState} {M M' : MemoryState} (h : c.Base S M)
    {m' : MemoryState} (hst : S.mem.StoresOff (· ≠ c.a.results.id) m')
    (hM : m'.eraseFrom c.s.alloc.nextFreeBlock = M') : c.Base ⟨S.alloc, m'⟩ M' := by
  have hso := hst.sameOn
  have ht := (c.tbl_ro hc).2
  have hi := (c.idp_ro hc).2
  refine ⟨hst.wf h.wf, hst.globals h.globals, h.frame, fun k hk => hst.inBounds (h.slots k hk),
    fun k hk => hst.writable (h.writable k hk), hM, h.tbl_lt, h.idp_lt, hso.fits ht h.tbl_fits,
    (hso.readAt ht).trans h.tbl_read, hso.fits hi h.idp_fits, (hso.readAt hi).trans h.idp_read⟩

variable {c} in
/-- `results[j]` has room where `Base` holds. -/
theorem Base.room_result (hc : c.Ok) {S : GlobalState} {M : MemoryState} (h : c.Base S M)
    (hM : (c.s.mem).StoresOff (fun _ => False) M) {j : Nat} (hj : j < c.cnt) :
    Room S.mem (c.a.result j) 32 := by
  have hr := hc.batch.room j hj
  have hlt : (c.a.result j).id.id < c.s.alloc.nextFreeBlock := hc.wf.id_lt_of_inBounds hr.inBounds
  exact h.sameOn.room hlt (hM.room hr)

/-- `finMem`'s stores. -/
theorem storesOff_finMem (k : Nat) : (c.s.mem).StoresOff (fun _ => False) (c.finMem k) :=
  (MemoryState.StoresOff.streamMem c.cnt fun _ _ _ h => h).trans
    (MemoryState.StoresOff.storeResults (fun h => h) _ c.cnt)

end Call

end

end MLIR.Firedancer.Lane.VerifyX8

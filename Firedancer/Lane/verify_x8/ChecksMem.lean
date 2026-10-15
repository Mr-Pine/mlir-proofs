module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.Common.MaskedStore
import Std.Data.ExtHashMap.Lemmas

/-! The memory of `verify_x8`'s checks: `fd_ed25519_lane_decode2`'s temporaries freed (`endMem`),
then the codes stored into `results`, by the scalar loop (`scalarMem`) or by masked stores; the
state they leave at `^bb62` from the one at `^bb42` (`at62_of`). -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)

@[expose] public section

/-! ### Stores into one block -/

/-- A second store to the same bits replaces the first. -/
theorem storeAt_twice {m : MemoryState} {p : Pointer} {x y : BitVec w} :
    (m.storeAt p x).storeAt p y = m.storeAt p y := by
  simp only [MemoryState.storeAt, MemoryState.modifyBlock, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  by_cases hk : p.id = k
  · subst hk
    simp only [ite_true]
    cases m.mem[p.id]? with
    | none => rfl
    | some b =>
      by_cases hw : b.writable <;> simp [MemoryBlock.update, hw, Memory.spliceBits_spliceBits_self]
  · simp [hk]

/-- Stores to disjoint bits commute. -/
theorem storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec v} {y : BitVec w}
    (h : p.id ≠ q.id ∨ p.offsetInBits + v ≤ q.offsetInBits ∨ q.offsetInBits + w ≤ p.offsetInBits) :
    (m.storeAt p x).storeAt q y = (m.storeAt q y).storeAt p x := by
  simp only [MemoryState.storeAt, MemoryState.modifyBlock, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  by_cases hp : p.id = k <;> by_cases hq : q.id = k
  · subst hp
    have hd : p.offsetInBits + v ≤ q.offsetInBits ∨ q.offsetInBits + w ≤ p.offsetInBits := by
      rcases h with h | h
      · exact absurd hq.symm h
      · exact h
    simp only [hq, ite_true]
    cases m.mem[p.id]? with
    | none => rfl
    | some b =>
      by_cases hw : b.writable
      · simp only [Option.map_some, MemoryBlock.update, hw, ite_true,
          Option.some.injEq, MemoryBlock.mk.injEq, true_and, and_true]
        exact ⟨heq_of_eq (Memory.spliceBits_comm_of_disjoint _ _ _ _ _ hd.symm),
          heq_of_eq (Memory.spliceBits_comm_of_disjoint _ _ _ _ _ hd.symm)⟩
      · simp [MemoryBlock.update, hw]
  · simp [hp, hq]
  · simp [hp, hq]
  · simp [hp, hq]

/-! ### The codes in `results` -/

/-- `storeResults` reads its codes below `n` only. -/
theorem storeResults_congr {m : MemoryState} {r : Pointer} {f f' : Nat → BitVec 32} {n : Nat}
    (h : ∀ j < n, f j = f' j) : storeResults m r f n = storeResults m r f' n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [storeResults]
    rw [ih fun j hj => h j (by omega), h n (by omega)]

/-- Code `j < n` stored again: `storeResults` with code `j` replaced. -/
theorem storeResults_storeAt {m : MemoryState} {r : Pointer} {f : Nat → BitVec 32} {n j : Nat}
    (hj : j < n) (hoff : r.offset.toNat + 4 * n < 2 ^ 64) (x : BitVec 32) :
    (storeResults m r f n).storeAt (r.add (BitVec.ofNat 64 (j * 4))) x =
      storeResults m r (Function.update f j x) n := by
  induction n with
  | zero => omega
  | succ n ih =>
    simp only [storeResults]
    by_cases hjn : j = n
    · subst hjn
      rw [storeAt_twice, Function.update_self]
      congr 1
      exact (storeResults_congr fun k hk => Function.update_of_ne (Nat.ne_of_lt hk) _ _).symm
    · have h1 : ¬r.offset.uaddOverflow (BitVec.ofNat 64 (n * 4)) := by
        simp [BitVec.uaddOverflow]; omega
      have h2 : ¬r.offset.uaddOverflow (BitVec.ofNat 64 (j * 4)) := by
        simp [BitVec.uaddOverflow]; omega
      rw [storeAt_comm, ih (by omega) (by omega), Function.update_of_ne (Ne.symm hjn)]
      right
      rw [Pointer.offsetInBits_add h1, Pointer.offsetInBits_add h2, BitVec.toNat_ofNat,
        BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
      omega

/-- The lanes of `l ≤ n` codes stored under a mask, lane `j` at `results[j]`: `storeResults` with
the set lanes' codes replaced. -/
theorem storeResults_maskedStoreAt {m : MemoryState} {r : Pointer} {f : Nat → BitVec 32} {n : Nat}
    {V : Vector (BitVec 32) l} {M : Vector (BitVec 1) l} (hl : l ≤ n)
    (hoff : r.offset.toNat + 4 * n < 2 ^ 64) :
    (storeResults m r f n).maskedStoreAt r V M =
      storeResults m r (fun j => if h : j < l then (if M[j] = 1#1 then V[j] else f j) else f j)
        n := by
  unfold MemoryState.maskedStoreAt
  suffices H : ∀ (L : List (Fin l)) (f : Nat → BitVec 32), L.Nodup →
      L.foldl
          (fun m (i : Fin l) =>
            if M[i] = 1#1 then m.storeAt (Operation.lanePtr r 32 i) V[i] else m)
          (storeResults m r f n) =
        storeResults m r
          (fun j => if h : j < l then (if ⟨j, h⟩ ∈ L ∧ M[j] = 1#1 then V[j] else f j) else f j) n by
    rw [H _ f (List.nodup_finRange l)]
    exact storeResults_congr fun j _ => by simp [List.mem_finRange]
  intro L
  induction L with
  | nil => intro f _; exact storeResults_congr fun j _ => by split <;> simp
  | cons i L ih =>
    intro f hnd
    have hi : (i : Nat) < n := by omega
    have hiL : i ∉ L := (List.nodup_cons.1 hnd).1
    simp only [List.foldl_cons]
    let f1 : Nat → BitVec 32 := if M[i] = 1#1 then Function.update f i V[i] else f
    have hstep :
        (if M[i] = 1#1 then (storeResults m r f n).storeAt (Operation.lanePtr r 32 i) V[i]
          else storeResults m r f n) = storeResults m r f1 n := by
      simp only [f1]
      split
      · exact storeResults_storeAt hi hoff _
      · rfl
    rw [hstep, ih f1 (List.nodup_cons.1 hnd).2]
    refine storeResults_congr fun j _ => ?_
    by_cases hj : j = i
    · subst hj
      by_cases hm : M[(i : Nat)] = 1#1 <;> simp [f1, hm, hiL, Fin.getElem_fin]
    · have hne : ∀ h : j < l, (⟨j, h⟩ : Fin l) ≠ i := fun h e => hj (by rw [← e])
      have hf1 : f1 j = f j := by
        simp only [f1]; split
        · exact Function.update_of_ne hj _ _
        · rfl
      split
      · rename_i h
        simp only [hf1, List.mem_cons, hne h, false_or]
      · exact hf1

/-! ### `verify_x8`'s constant globals -/

/-- A global's image is constant as its initializer is. -/
theorem GlobalInitializer.image_constant (g : GlobalInitializer) :
    g.image.constant = g.constant := by
  unfold GlobalInitializer.image
  split <;> rfl

/-- A constant global of `verify_x8`'s: its block below the frame, and not `results`'. -/
theorem Call.global_ro {c : Call} (hc : c.Ok) {g : Global} (hg : g ∈ (verify_x8 c.batch).globals)
    (hcst : g.init.constant = true) :
    (c.s.mem.globalBlock g.sym).id < c.s.alloc.nextFreeBlock ∧
      c.s.mem.globalBlock g.sym ≠ c.a.results.id := by
  obtain ⟨b, hb⟩ := hc.globals g (List.mem_append_left _ hg)
  have hgb : c.s.mem.globalBlock g.sym = b := by simp [MemoryState.globalBlock, hb]
  have hblk := hc.wf.global _ _ _ hb
  rw [GlobalInitializer.image_constant, hcst, ite_eq_left rfl] at hblk
  have hmem : b ∈ c.s.mem.mem := by
    rw [Std.ExtHashMap.mem_iff_isSome_getElem?, ← MemoryState.getElem?_eq, hblk]; rfl
  have hw : Writable c.s.mem (c.a.result 0) := (hc.batch.room 0 (by have := hc.cnt3; omega)).2
  refine ⟨hgb ▸ hc.wf.lt hmem, hgb ▸ fun h => ?_⟩
  exact Writable.ne_of_readOnly hw hblk
    (MemoryState.imageBlock_writable (by rw [GlobalInitializer.image_constant, hcst])) h.symm

/-- `fd_ed25519_lane_base_table`'s block: below the frame, not `results`'. -/
theorem Call.tbl_ro {c : Call} (hc : c.Ok) :
    c.tbl.id.id < c.s.alloc.nextFreeBlock ∧ c.tbl.id ≠ c.a.results.id :=
  Call.global_ro (g := ⟨"fd_ed25519_lane_base_table",
    _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table⟩) hc (by simp) rfl

/-- `identity`'s block: below the frame, not `results`'. -/
theorem Call.idp_ro {c : Call} (hc : c.Ok) :
    c.idp.id.id < c.s.alloc.nextFreeBlock ∧ c.idp.id ≠ c.a.results.id :=
  Call.global_ro (g := ⟨"verify_x8.identity", _root_.Firedancer.Lane.Mlir.verify_x8_identity⟩) hc
    (by simp) rfl

/-! ### `fd_ed25519_lane_decode2`'s temporaries freed -/

/-- `^bb42`'s `lifetime.end`s of slots 16 … 25. -/
def Call.endMem (c : Call) (m : MemoryState) : MemoryState :=
  (((((((((m.lifetimeEnd (c.s.slot 24)).lifetimeEnd (c.s.slot 25)).lifetimeEnd
                                (c.s.slot 23)).lifetimeEnd (c.s.slot 22)).lifetimeEnd
                        (c.s.slot 21)).lifetimeEnd (c.s.slot 20)).lifetimeEnd
                (c.s.slot 19)).lifetimeEnd (c.s.slot 18)).lifetimeEnd (c.s.slot 16)).lifetimeEnd
    (c.s.slot 17)

/-- The blocks `endMem` keeps: all but slots 16 … 25. -/
def Call.Kept (c : Call) (b : BlockId) : Prop :=
  b.id < c.s.alloc.nextFreeBlock + 16 ∨ c.s.alloc.nextFreeBlock + 26 ≤ b.id

theorem Call.sameOn_endMem (c : Call) (m : MemoryState) : m.SameOn (c.endMem m) c.Kept := by
  refine ⟨fun b hb => ?_, rfl, rfl⟩
  have hne (k : Nat) (h1 : 16 ≤ k) (h2 : k < 26) : b ≠ (c.s.slot k).id := by
    rintro rfl
    simp only [Call.Kept, GlobalState.slot_id_id] at hb
    omega
  simp only [Call.endMem, MemoryState.lifetimeEnd, MemoryState.setLifetime]
  rw [MemoryState.getElem?_modifyBlock_ne (hne 17 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 16 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 18 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 19 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 20 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 21 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 22 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 23 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 25 (by decide) (by decide)),
    MemoryState.getElem?_modifyBlock_ne (hne 24 (by decide) (by decide))]

theorem Call.eraseFrom_endMem (c : Call) (m : MemoryState) :
    (c.endMem m).eraseFrom c.s.alloc.nextFreeBlock = m.eraseFrom c.s.alloc.nextFreeBlock := by
  simp only [Call.endMem]
  repeat rw [MemoryState.eraseFrom_lifetimeEnd_of_le (by simp)]

theorem Call.inBounds_endMem (c : Call) {m : MemoryState} (h : InBounds m p w) :
    InBounds (c.endMem m) p w := by
  simp only [Call.endMem]
  repeat apply InBounds.lifetimeEnd
  exact h

theorem Call.writable_endMem (c : Call) {m : MemoryState} (h : Writable m p) :
    Writable (c.endMem m) p := by
  simp only [Call.endMem]
  repeat apply Writable.lifetimeEnd
  exact h

theorem Call.wf_endMem (c : Call) {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, c.endMem m⟩ : GlobalState).WF := by
  simp only [Call.endMem]
  repeat apply GlobalState.WF.lifetimeEnd_mk
  exact h

/-! ### The scalar loop's stores -/

/-- The second loop stores item `j`'s code: a candidate with a bad or small-order `A`, or a bad
`R`. -/
noncomputable def Call.stores (c : Call) (j : Nat) : Bool :=
  if h : j < 8 then
    c.X.cand ⟨j, h⟩ && (!c.X.aValid.getLsbD j || !c.X.rValid.getLsbD j || c.X.aSmall.getLsbD j)
  else false

/-- An item whose code is not stored keeps `FD_ED25519_ERR_SIG`. -/
theorem Call.code1_of_not_stores {c : Call} {j : Nat} (hj : j < 8) (h : c.stores j = false) :
    c.code1 j = errSig := by
  simp only [Call.stores, hj, dite_true] at h
  simp only [Call.code1, hj, dite_true]
  cases hc : c.X.cand ⟨j, hj⟩ <;> cases ha : c.X.aValid.getLsbD j <;>
    cases hr : c.X.rValid.getLsbD j <;> cases hs : c.X.aSmall.getLsbD j <;> simp_all

/-- The scalar loop's memory past items `j < i`: their codes stored where it stores them. -/
noncomputable def Call.scalarMem (c : Call) (m : MemoryState) : Nat → MemoryState
  | 0 => m
  | i + 1 =>
    if c.stores i then (c.scalarMem m i).storeAt (c.a.result i) (c.code1 i) else c.scalarMem m i

theorem Call.scalarMem_succ_store {c : Call} {m : MemoryState} {i : Nat} (h : c.stores i = true) :
    c.scalarMem m (i + 1) = (c.scalarMem m i).storeAt (c.a.result i) (c.code1 i) := by
  simp [Call.scalarMem, h]

theorem Call.scalarMem_succ_keep {c : Call} {m : MemoryState} {i : Nat} (h : c.stores i = false) :
    c.scalarMem m (i + 1) = c.scalarMem m i := by
  simp [Call.scalarMem, h]

theorem Call.storesOff_scalarMem (c : Call) (m : MemoryState) (i : Nat) :
    m.StoresOff (· ≠ c.a.results.id) (c.scalarMem m i) := by
  induction i with
  | zero => exact .refl m
  | succ i ih =>
    simp only [Call.scalarMem]
    split
    · exact .storeAt _ ih (by simp)
    · exact ih

/-- The scalar loop's memory, framed: `results[j]` the code of item `j < i`, `ERR_SIG` past it. -/
theorem Call.eraseFrom_scalarMem {c : Call} (hc : c.Ok) {m : MemoryState}
    (hm : m.eraseFrom c.s.alloc.nextFreeBlock = c.mem38) {i : Nat} (hi : i ≤ c.cnt) :
    (c.scalarMem m i).eraseFrom c.s.alloc.nextFreeBlock =
      storeResults c.s.mem c.a.results (fun j => if j < i then c.code1 j else errSig) c.cnt := by
  induction i with
  | zero => rw [Call.scalarMem, hm]; rfl
  | succ i ih =>
    have ih := ih (by omega)
    simp only [Call.scalarMem]
    split
    · rename_i hs
      rw [MemoryState.eraseFrom_storeAt, ih,
        storeResults_storeAt (by omega) hc.batch.off.2.2.2.2.2]
      refine storeResults_congr fun j _ => ?_
      by_cases hj : j = i
      · subst hj; simp
      · rw [Function.update_of_ne hj]
        simp only [show j < i + 1 ↔ j < i by omega]
    · rename_i hs
      rw [ih]
      refine storeResults_congr fun j _ => ?_
      by_cases hj : j = i
      · subst hj
        have h8 := hc.cnt8
        simp [Call.code1_of_not_stores (j := j) (by omega) (by simpa using hs)]
      · simp only [show j < i + 1 ↔ j < i by omega]

/-! ### The state at `^bb62` -/

/-- `results`' block is below the frame. -/
theorem Call.results_lt {c : Call} (hc : c.Ok) : c.a.results.id.id < c.s.alloc.nextFreeBlock :=
  hc.wf.id_lt_of_inBounds (q := c.a.result 0) (hc.batch.room 0 (by have := hc.cnt3; omega)).inBounds

/-- Slot `k ≥ 26` is kept by `endMem` and is not `results`. -/
theorem Call.kept_slot {c : Call} (hc : c.Ok) {k : Nat} (hk : 26 ≤ k) :
    c.Kept (c.s.slot k).id ∧ (c.s.slot k).id ≠ c.a.results.id := by
  have := c.results_lt hc
  refine ⟨Or.inr (by simp; omega), fun h => ?_⟩
  have := congrArg BlockId.id h
  simp only [GlobalState.slot_id_id] at this
  omega

/-- `results[j]` has room at `^bb42`, once `fd_ed25519_lane_decode2`'s temporaries are freed. -/
theorem Call.room_result {c : Call} (hc : c.Ok) {S₀ : GlobalState} (hS : c.At42 S₀) {j : Nat}
    (hj : j < c.cnt) : Room (c.endMem S₀.mem) (c.a.result j) 32 := by
  have hr := hc.batch.room j hj
  have hlt : (c.a.result j).id.id < c.s.alloc.nextFreeBlock := hc.wf.id_lt_of_inBounds hr.inBounds
  have h38 : Room c.mem38 (c.a.result j) 32 :=
    (MemoryState.StoresOff.storeResults (K := fun _ => False) (m := c.s.mem) (fun h => h) _
      c.cnt).room hr
  exact (c.sameOn_endMem _).room (Or.inl (by omega)) (hS.base.sameOn.room hlt h38)

theorem _root_.MLIR.MemoryState.SameOn.readLanePoint_eq {m m' : MemoryState}
    {K : BlockId → Prop} {p : Pointer} (h : m.SameOn m' K) (hp : K p.id) :
    m'.readLanePoint p = m.readLanePoint p := by
  have h1 (o : BitVec 64) (w : Nat) : m'.readAt (p.add o) w = m.readAt (p.add o) w := h.readAt hp
  have h2 (o o' : BitVec 64) (w : Nat) :
      m'.readAt ((p.add o).add o') w = m.readAt ((p.add o).add o') w :=
    h.readAt hp
  simp only [MemoryState.readLanePoint, MemoryState.readFe, MemoryState.readVec, h.readAt hp, h1,
    h2]

/-- `^bb62`'s state: `^bb42`'s with `fd_ed25519_lane_decode2`'s temporaries freed, the two calls'
blocks, and stores into `results` leaving `mem62` outside the frame. -/
theorem Call.at62_of {c : Call} (hc : c.Ok) {S₀ : GlobalState} (hS : c.At42 S₀) {M : MemoryState}
    (hst : (c.endMem S₀.mem).StoresOff (· ≠ c.a.results.id) M)
    (hM : M.eraseFrom c.s.alloc.nextFreeBlock = c.mem62) :
    c.At62 ⟨⟨S₀.alloc.nextFreeBlock + 6 + 6⟩, M⟩ := by
  have hso : S₀.mem.SameOn M fun b => c.Kept b ∧ b ≠ c.a.results.id :=
    ((c.sameOn_endMem _).mono fun _ h => h.1).trans (hst.sameOn.mono fun _ h => h.2)
  have hkt : c.Kept c.tbl.id ∧ c.tbl.id ≠ c.a.results.id :=
    ⟨Or.inl (by have := (c.tbl_ro hc).1; omega), (c.tbl_ro hc).2⟩
  have hki : c.Kept c.idp.id ∧ c.idp.id ≠ c.a.results.id :=
    ⟨Or.inl (by have := (c.idp_ro hc).1; omega), (c.idp_ro hc).2⟩
  have h26 := c.kept_slot hc (k := 26) (by decide)
  have h27 := c.kept_slot hc (k := 27) (by decide)
  have h28 := c.kept_slot hc (k := 28) (by decide)
  have h29 := c.kept_slot hc (k := 29) (by decide)
  have hb := hS.base
  refine ⟨⟨?_, ?_, ?_, ?_, ?_, hM, hb.tbl_lt, hb.idp_lt, ?_, ?_, ?_, ?_⟩, ⟨?_, ?_, ?_, ?_⟩,
    ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩
  · exact hst.wf (c.wf_endMem ((hb.wf.add_blocks (k := 6)).add_blocks (k := 6)))
  · exact hst.globals ((c.sameOn_endMem _).globals hb.globals)
  · have := hb.frame
    dsimp only
    omega
  · exact fun k hk => hst.inBounds (c.inBounds_endMem (hb.slots k hk))
  · exact fun k hk => hst.writable (c.writable_endMem (hb.writable k hk))
  · exact hso.fits hkt hb.tbl_fits
  · exact (hso.readAt hkt).trans hb.tbl_read
  · exact hso.fits hki hb.idp_fits
  · exact (hso.readAt hki).trans hb.idp_read
  · exact hso.fits h26 hS.ks.k_fits
  · exact (hso.readAt h26).trans hS.ks.k_read
  · exact hso.fits h27 hS.ks.s_fits
  · exact (hso.readAt h27).trans hS.ks.s_read
  · exact ⟨hS.a.fit.1, hso.fits h28 hS.a.fit.2⟩
  · exact (hso.readLanePoint_eq h28).trans hS.a.read
  · exact ⟨hS.r.fit.1, hso.fits h29 hS.r.fit.2⟩
  · exact (hso.readLanePoint_eq h29).trans hS.r.read

/-! ### The eight-lane loop's stores -/

/-- A masked store into a block outside `K`. -/
theorem _root_.MLIR.MemoryState.StoresOff.maskedStoreAt {K : BlockId → Prop} {m m' : MemoryState}
    (h : m.StoresOff K m') {p : Pointer} (hp : ¬K p.id) (V : Vector (BitVec w) l)
    (M : Vector (BitVec 1) l) : m.StoresOff K (m'.maskedStoreAt p V M) :=
  MemoryState.foldl_storeAt_induct (m.StoresOff K ·) _ (fun i : Fin l => M[i] = 1#1)
    (fun i => Operation.lanePtr p w i) (fun i => V[i]) m' h fun _ _ hm _ => .storeAt _ hm hp

/-- The eight-lane loop's memory, framed: its three masked stores of `ERR_PUBKEY`, `ERR_SIG` and
`ERR_PUBKEY` give item `j` code `code1 j`. -/
theorem Call.eraseFrom_masked {c : Call} (hc : c.Ok) {m : MemoryState}
    (hm : m.eraseFrom c.s.alloc.nextFreeBlock = c.mem38) (h8 : c.cnt = 8)
    {Ma Mb Mc : Vector (BitVec 1) 8}
    (hcode :
      ∀ (j : Nat) (h : j < 8),
        (if Mc[j] = 1#1 then 4294967294#32
          else if Mb[j] = 1#1 then 4294967295#32
          else if Ma[j] = 1#1 then 4294967294#32 else errSig) = c.code1 j) :
    (((m.maskedStoreAt c.a.results (Vector.replicate 8 4294967294#32) Ma).maskedStoreAt
            c.a.results (Vector.replicate 8 4294967295#32) Mb).maskedStoreAt
        c.a.results (Vector.replicate 8 4294967294#32) Mc).eraseFrom c.s.alloc.nextFreeBlock =
      c.mem62 := by
  have hoff := hc.batch.off.2.2.2.2.2
  rw [MemoryState.eraseFrom_maskedStoreAt, MemoryState.eraseFrom_maskedStoreAt,
    MemoryState.eraseFrom_maskedStoreAt, hm, Call.mem38,
    storeResults_maskedStoreAt (by omega) hoff, storeResults_maskedStoreAt (by omega) hoff,
    storeResults_maskedStoreAt (by omega) hoff, Call.mem62]
  refine storeResults_congr fun j hj => ?_
  have hj8 : j < 8 := by omega
  simp only [hj8, dite_true, Vector.getElem_replicate]
  exact hcode j hj8

end

end MLIR.Firedancer.Lane.VerifyX8

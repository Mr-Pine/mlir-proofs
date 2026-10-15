module

public import Firedancer.Lane.verify_x8.RecodeDefs
public import Firedancer.Lane.Common.MaskedStore

/-! The memory of `verify_x8`'s recodings: a masked store's set lanes and the bytes it keeps, a run
of stores at a stride, and `Rec` from lane `j` to `j + 1`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

section Folds

variable {α : Type} (c : α → Prop) [DecidablePred c] (q : α → Pointer) {w : Nat}
  (x : α → BitVec w)

/-- A store per `a ∈ L` where `c a`, first to last. -/
abbrev condStores (L : List α) (m : MemoryState) : MemoryState :=
  L.foldl (fun m a => if c a then m.storeAt (q a) (x a) else m) m

/-- Bits apart from every store stay. -/
theorem condStores_keep {L : List α} {m : MemoryState} {t : Pointer} {v : Nat} {y : BitVec v}
    (hd : ∀ a ∈ L, c a → (Range.of (q a) w).Disjoint (Range.of t v))
    (h : Fits m t v ∧ m.readAt t v = y) :
    Fits (condStores c q x L m) t v ∧ (condStores c q x L m).readAt t v = y := by
  induction L generalizing m with
  | nil => exact h
  | cons a L ih =>
    simp only [condStores, List.foldl_cons]
    refine ih (fun b hb hcb => hd b (List.mem_cons_of_mem _ hb) hcb) ?_
    by_cases hca : c a
    · simp only [hca, ite_true]
      exact ⟨h.1.storeAt,
        (MemoryState.readAt_storeAt_disjoint (hd a List.mem_cons_self hca) _).trans h.2⟩
    · simp only [hca, ite_false]
      exact h

/-- A store's bits, apart from the later ones, are read back. -/
theorem condStores_lane {L : List α} (hnd : L.Nodup) {m : MemoryState} {i : α} (hi : i ∈ L)
    (hci : c i) (hr : Room m (q i) w)
    (hd : ∀ a ∈ L, a ≠ i → c a → (Range.of (q a) w).Disjoint (Range.of (q i) w)) :
    Fits (condStores c q x L m) (q i) w ∧ (condStores c q x L m).readAt (q i) w = x i := by
  induction L generalizing m with
  | nil => cases hi
  | cons a L ih =>
    obtain ⟨hnot, hnd'⟩ := List.nodup_cons.1 hnd
    simp only [condStores, List.foldl_cons]
    by_cases hai : a = i
    · subst hai
      refine condStores_keep c q x (fun b hb hcb => hd b (List.mem_cons_of_mem _ hb)
        (fun e => hnot (e ▸ hb)) hcb) ?_
      simp only [hci, ite_true]
      exact ⟨Fits.storeAt_self hr, MemoryState.readAt_storeAt_self hr _⟩
    · have hi' : i ∈ L := by
        rcases List.mem_cons.1 hi with e | e
        · exact absurd e.symm hai
        · exact e
      refine ih hnd' hi' ?_ fun b hb hbi hcb => hd b (List.mem_cons_of_mem _ hb) hbi hcb
      by_cases hca : c a
      · simp only [hca, ite_true]; exact hr.storeAt
      · simp only [hca, ite_false]; exact hr

end Folds

/-! ### `kd`'s column -/

/-- A masked store as `condStores`. -/
theorem maskedStoreAt_eq {m : MemoryState} {p : Pointer} {l w : Nat} {V : Vector (BitVec w) l}
    {M : Vector (BitVec 1) l} :
    m.maskedStoreAt p V M =
      condStores (fun i : Fin l => M[i] = 1#1) (fun i => Operation.lanePtr p w i) (fun i => V[i])
        (List.finRange l) m :=
  rfl

/-- `kdMask`'s set lanes: every eighth. -/
theorem kdMask_get (i : Fin 505) : kdMask[i] = 1#1 ↔ i.val % 8 = 0 := by
  simp only [kdMask, Fin.getElem_fin, Vector.getElem_ofFn]
  split <;> simp_all

/-- Lane `i` of the store into `kd`'s column `j`: byte `j + i` of `kd`. -/
theorem kd_lanePtr (c : Call) (j : Nat) (i : Nat) :
    Operation.lanePtr ((c.s.slot 0).add (BitVec.ofNat 64 j)) 8 i =
      (c.s.slot 0).add (BitVec.ofNat 64 (j + i)) := by
  rw [Operation.lanePtr, Nat.div_self (by decide), Nat.mul_one, add_ofNat_add_ofNat]

/-- `kd`'s column `j` after its masked store: `D`. -/
theorem kd_col_store (c : Call) {m : MemoryState} (hr : Room m (c.s.slot 0) 4096) {j : Nat}
    (hj : j < 8) (D : Vector (BitVec 8) 64) {w : Nat} (hw : w < 64) :
    Fits (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j))
        (Vector.ofFn fun i : Fin 505 => D[i.val / 8]) kdMask) (c.kdPtr j w) 8 ∧
      (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j))
        (Vector.ofFn fun i : Fin 505 => D[i.val / 8]) kdMask).readAt (c.kdPtr j w) 8 = D[w] := by
  have hp : c.kdPtr j w =
      Operation.lanePtr ((c.s.slot 0).add (BitVec.ofNat 64 j)) 8 (⟨8 * w, by omega⟩ : Fin 505) := by
    rw [kd_lanePtr, Call.kdPtr, Nat.add_comm]
  rw [hp, maskedStoreAt_eq]
  have := condStores_lane (fun i : Fin 505 => kdMask[i] = 1#1)
    (fun i => Operation.lanePtr ((c.s.slot 0).add (BitVec.ofNat 64 j)) 8 i)
    (fun i : Fin 505 => (Vector.ofFn fun i : Fin 505 => D[i.val / 8])[i])
    (List.nodup_finRange 505) (m := m) (i := ⟨8 * w, by omega⟩) (List.mem_finRange _)
    ((kdMask_get _).2 (by simp))
    (by rw [kd_lanePtr]; exact slot_room c.s 0 hr (by omega) (by decide))
    (fun a _ ha _ => by
      rw [kd_lanePtr, kd_lanePtr]
      exact recode_slot_disjoint c.s 0 (by omega) (by omega)
        (by have := Fin.val_ne_of_ne ha; simp at this; omega))
  simpa [show 8 * w / 8 = w by omega] using this

/-- `kd`'s other columns after column `j`'s masked store. -/
theorem kd_other_store (c : Call) {m : MemoryState} {j : Nat} (hj : j < 8)
    (D : Vector (BitVec 8) 64) {i w : Nat} (hi : i < 8) (hij : i ≠ j) (hw : w < 64) {y : BitVec 8}
    (h : Fits m (c.kdPtr i w) 8 ∧ m.readAt (c.kdPtr i w) 8 = y) :
    Fits (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j))
        (Vector.ofFn fun i : Fin 505 => D[i.val / 8]) kdMask) (c.kdPtr i w) 8 ∧
      (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j))
        (Vector.ofFn fun i : Fin 505 => D[i.val / 8]) kdMask).readAt (c.kdPtr i w) 8 = y := by
  rw [maskedStoreAt_eq]
  refine condStores_keep _ _ _ (fun a _ ha => ?_) h
  rw [kd_lanePtr, Call.kdPtr]
  have := (kdMask_get a).1 ha
  exact recode_slot_disjoint c.s 0 (by omega) (by omega) (by omega)

/-- Bits outside `kd` after a masked store into it. -/
theorem kd_apart_store (c : Call) {m : MemoryState} {j : Nat} {V : Vector (BitVec 8) 505}
    {t : Pointer} {v : Nat} {y : BitVec v} (ht : t.id ≠ (c.s.slot 0).id)
    (h : Fits m t v ∧ m.readAt t v = y) :
    Fits (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j)) V kdMask) t v ∧
      (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j)) V kdMask).readAt t v = y := by
  rw [maskedStoreAt_eq]
  exact condStores_keep _ _ _ (fun a _ _ => Range.disjoint_of_id_ne (Ne.symm ht)) h

/-! ### `sd`'s column -/

/-- `s[j]`'s digits stored at `R`, `R + 16`, …, the first `n`. -/
def sdStores (m : MemoryState) (R : Pointer) (s : BitVec 256) : Nat → MemoryState
  | 0 => m
  | n + 1 => (sdStores m R s n).storeAt (R.add (BitVec.ofNat 64 (16 * n))) (recode8 s n)

/-- `sd[w][j]`, from `sd`'s column `j`. -/
theorem sd_ptr (c : Call) (j w : Nat) :
    ((c.s.slot 1).add (BitVec.ofNat 64 (j * 2))).add (BitVec.ofNat 64 (16 * w)) = c.sdPtr j w := by
  rw [add_ofNat_add_ofNat, Call.sdPtr, show j * 2 + 16 * w = 2 * (8 * w + j) by omega]

/-- `sdStores` keeps `Room`. -/
theorem sdStores_room {m : MemoryState} {R : Pointer} {s : BitVec 256} {t : Pointer} {v : Nat}
    (h : Room m t v) : ∀ n, Room (sdStores m R s n) t v
  | 0 => h
  | n + 1 => (sdStores_room h n).storeAt

/-- Bits apart from the stores stay. -/
theorem sdStores_keep {m : MemoryState} {R : Pointer} {s : BitVec 256} {t : Pointer} {v : Nat}
    {y : BitVec v} (h : Fits m t v ∧ m.readAt t v = y) :
    ∀ n, (∀ k < n, (Range.of (R.add (BitVec.ofNat 64 (16 * k))) 16).Disjoint (Range.of t v)) →
      Fits (sdStores m R s n) t v ∧ (sdStores m R s n).readAt t v = y
  | 0, _ => h
  | n + 1, hd => by
    have ih := sdStores_keep (s := s) h n fun k hk => hd k (by omega)
    exact ⟨ih.1.storeAt,
      (MemoryState.readAt_storeAt_disjoint (hd n (by omega)) _).trans ih.2⟩

/-- `sd`'s column `j` after its stores: `s`'s digits. -/
theorem sd_col_store (c : Call) {m : MemoryState} (hr : Room m (c.s.slot 1) 4096) {j : Nat}
    (hj : j < 8) (s : BitVec 256) :
    ∀ n ≤ 32, ∀ w < n,
      Fits (sdStores m ((c.s.slot 1).add (BitVec.ofNat 64 (j * 2))) s n) (c.sdPtr j w) 16 ∧
        (sdStores m ((c.s.slot 1).add (BitVec.ofNat 64 (j * 2))) s n).readAt (c.sdPtr j w) 16 =
          recode8 s w
  | 0, _, w, hw => absurd hw (by omega)
  | n + 1, hn, w, hw => by
    have hR : Room (sdStores m ((c.s.slot 1).add (BitVec.ofNat 64 (j * 2))) s n)
        (c.sdPtr j n) 16 :=
      sdStores_room (slot_room c.s 1 hr (b := 2 * (8 * n + j)) (by omega) (by decide)) n
    simp only [sdStores, sd_ptr]
    by_cases hwn : w = n
    · subst hwn
      exact ⟨Fits.storeAt_self hR, MemoryState.readAt_storeAt_self hR _⟩
    · obtain ⟨hf, hrd⟩ := sd_col_store c hr hj s n (by omega) w (by omega)
      refine ⟨hf.storeAt, ?_⟩
      rw [MemoryState.readAt_storeAt_disjoint (p := c.sdPtr j n) (q := c.sdPtr j w)
        (recode_slot_disjoint c.s 1 (by omega) (by omega) (by omega)), hrd]

/-! ### From lane `j` to `j + 1` -/

/-- Stores into the frame keep `FrameOps`. -/
theorem condStores_frameOps {α : Type} (c : α → Prop) [DecidablePred c] (q : α → Pointer)
    {w : Nat} (x : α → BitVec w) {n : Nat} {m₀ m : MemoryState} (h : FrameOps n m₀ m)
    (hq : ∀ a, n ≤ (q a).id.id) : ∀ L, FrameOps n m₀ (condStores c q x L m) := by
  intro L
  induction L generalizing m with
  | nil => exact h
  | cons a L ih =>
    simp only [condStores, List.foldl_cons]
    refine ih ?_
    split
    · exact h.storeAt (hq a)
    · exact h

/-- `sdStores` into the frame keeps `FrameOps`. -/
theorem sdStores_frameOps {n : Nat} {m₀ m : MemoryState} {R : Pointer} {s : BitVec 256}
    (h : FrameOps n m₀ m) (hR : n ≤ R.id.id) : ∀ k, FrameOps n m₀ (sdStores m R s k)
  | 0 => h
  | k + 1 => (sdStores_frameOps h hR k).storeAt (by rw [Pointer.add_id]; exact hR)

/-- A point in another block stays. -/
theorem condStores_readLanePoint {α : Type} (c : α → Prop) [DecidablePred c] (q : α → Pointer)
    {w : Nat} (x : α → BitVec w) {p : Pointer} (hq : ∀ a, (q a).id ≠ p.id) :
    ∀ (L : List α) (m : MemoryState),
      (condStores c q x L m).readLanePoint p = m.readLanePoint p := by
  intro L
  induction L with
  | nil => intro m; rfl
  | cons a L ih =>
    intro m
    simp only [condStores, List.foldl_cons]
    rw [ih]
    split
    · exact readLanePoint_storeAt_of_id_ne (hq a)
    · rfl

/-- `sdStores`: a point in another block stays. -/
theorem sdStores_readLanePoint {m : MemoryState} {R p : Pointer} {s : BitVec 256}
    (h : R.id ≠ p.id) : ∀ k, (sdStores m R s k).readLanePoint p = m.readLanePoint p
  | 0 => rfl
  | k + 1 => by
    rw [sdStores, readLanePoint_storeAt_of_id_ne (by rw [Pointer.add_id]; exact h),
      sdStores_readLanePoint h k]

/-- The lanes of the masked store into `kd`'s column `j`: `kj[i / 8]`. -/
noncomputable def Call.kdV (c : Call) (j : Fin 8) : Vector (BitVec 8) 505 :=
  Vector.ofFn fun i : Fin 505 => (Vector.ofFn fun w : Fin 64 => recode4 (c.kS j) w)[i.val / 8]

/-- The memory `^bb82` leaves at lane `j`: `kj`'s digits into `kd`'s column, `s[j]`'s into `sd`'s,
`kj` ended. -/
noncomputable def Call.colMem (c : Call) (j : Fin 8) (m : MemoryState) : MemoryState :=
  (sdStores (m.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val)) (c.kdV j) kdMask)
      ((c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2))) (c.sS j) 32).lifetimeEnd (c.s.slot 2)

/-- `^bb82` at lane `j`: `Rec` on to lane `j + 1`. -/
theorem Call.Rec.col {c : Call} {j : Fin 8} {S₀ S : GlobalState} (h : c.Rec j S₀)
    (hm : S.mem = c.colMem j S₀.mem) (hwf : S.WF) (ha : S.alloc = S₀.alloc) :
    c.Rec (j.val + 1) S := by
  have hb := h.base
  have ne (k l : Nat) (hkl : k ≠ l) : (c.s.slot k).id ≠ (c.s.slot l).id := slot_ne c.s hkl
  -- a fact about a block other than `kd`'s, `sd`'s, `kj`'s, carried
  have far {t : Pointer} {v : Nat} {y : BitVec v} (h0 : t.id ≠ (c.s.slot 0).id)
      (h1 : t.id ≠ (c.s.slot 1).id) (h2 : t.id ≠ (c.s.slot 2).id)
      (hf : Fits S₀.mem t v ∧ S₀.mem.readAt t v = y) : Fits S.mem t v ∧ S.mem.readAt t v = y := by
    have := sdStores_keep (s := c.sS j) (R := (c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2)))
      (kd_apart_store c (j := j.val) (V := c.kdV j) h0 hf) 32
      fun k _ => Range.disjoint_of_id_ne (by rw [Pointer.add_id, Pointer.add_id]; exact Ne.symm h1)
    rw [hm, Call.colMem]
    exact ⟨this.1.lifetimeEnd h2, by rw [MemoryState.readAt_lifetimeEnd]; exact this.2⟩
  have lp {p : Pointer} (h0 : p.id ≠ (c.s.slot 0).id) (h1 : p.id ≠ (c.s.slot 1).id) :
      S.mem.readLanePoint p = S₀.mem.readLanePoint p := by
    rw [hm, Call.colMem, MemoryState.readLanePoint_lifetimeEnd, sdStores_readLanePoint
      (by rw [Pointer.add_id]; exact Ne.symm h1), maskedStoreAt_eq,
      condStores_readLanePoint _ _ _ (fun a => by
        rw [Operation.lanePtr, Pointer.add_id, Pointer.add_id]; exact Ne.symm h0)]
  have fitP {p : Pointer} (h0 : p.id ≠ (c.s.slot 0).id) (h1 : p.id ≠ (c.s.slot 1).id)
      (h2 : p.id ≠ (c.s.slot 2).id) (hf : S₀.mem.LanePointFit p) : S.mem.LanePointFit p := by
    refine ⟨hf.1, ?_⟩
    rw [hm, Call.colMem]
    exact (sdStores_keep (s := c.sS j) (R := (c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2)))
      (y := S₀.mem.readAt p 10240) (kd_apart_store c (j := j.val) (V := c.kdV j) h0 ⟨hf.2, rfl⟩) 32
      fun k _ => Range.disjoint_of_id_ne
        (by rw [Pointer.add_id, Pointer.add_id]; exact Ne.symm h1)).1.lifetimeEnd h2
  have roomS {k : Nat} (hk : k ≠ 2) (hr : Room S₀.mem (c.s.slot k) 4096) :
      Room S.mem (c.s.slot k) 4096 := by
    rw [hm, Call.colMem]
    exact (sdStores_room hr.maskedStoreAt 32).lifetimeEnd (ne k 2 hk)
  have hk26 := far (y := rows32 c.kS) (ne 26 0 (by decide)) (ne 26 1 (by decide))
    (ne 26 2 (by decide)) ⟨h.ks.k_fits, h.ks.k_read⟩
  have hs27 := far (y := rows32 c.sS) (ne 27 0 (by decide)) (ne 27 1 (by decide))
    (ne 27 2 (by decide)) ⟨h.ks.s_fits, h.ks.s_read⟩
  refine ⟨hb.frameOps ?_ hwf ha, ⟨hk26.1, hk26.2, hs27.1, hs27.2⟩,
    ⟨fitP (ne 28 0 (by decide)) (ne 28 1 (by decide)) (ne 28 2 (by decide)) h.a.fit, ?_⟩,
    ⟨fitP (ne 29 0 (by decide)) (ne 29 1 (by decide)) (ne 29 2 (by decide)) h.r.fit, ?_⟩,
    roomS (by decide) h.kd, roomS (by decide) h.sd, fun i hi w hw => ?_, fun i hi w hw => ?_⟩
  · rw [hm, Call.colMem]
    refine (sdStores_frameOps ?_ (by simp) 32).lifetimeEnd (by simp)
    rw [maskedStoreAt_eq]
    exact condStores_frameOps _ _ _ (FrameOps.refl _ _) (fun a => by
      rw [Operation.lanePtr, Pointer.add_id, Pointer.add_id]; simp) _
  · rw [lp (ne 28 0 (by decide)) (ne 28 1 (by decide)), h.a.read]
  · rw [lp (ne 29 0 (by decide)) (ne 29 1 (by decide)), h.r.read]
  · -- `kd`'s columns
    have hkd : Fits (S₀.mem.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val))
          (c.kdV j) kdMask)
          (c.kdPtr i w) 8 ∧
        (S₀.mem.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val))
          (c.kdV j) kdMask).readAt
          (c.kdPtr i w) 8 = recode4 (c.kS i) w := by
      by_cases hij : i = j
      · subst hij
        have := kd_col_store c h.kd i.isLt
          (Vector.ofFn fun w : Fin 64 => recode4 (c.kS i) w) hw
        rw [Vector.getElem_ofFn] at this
        exact this
      · exact kd_other_store c j.isLt _ i.isLt (fun e => hij (Fin.ext e)) hw
          (h.kcol i (by have := Fin.val_ne_of_ne hij; omega) w hw)
    have := sdStores_keep (s := c.sS j) (R := (c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2)))
      hkd 32 fun k _ => Range.disjoint_of_id_ne
        (by
          rw [Pointer.add_id, Pointer.add_id, Call.kdPtr, Pointer.add_id]
          exact ne 1 0 (by decide))
    rw [hm, Call.colMem]
    exact ⟨this.1.lifetimeEnd (by rw [Call.kdPtr, Pointer.add_id]; exact ne 0 2 (by decide)),
      by rw [MemoryState.readAt_lifetimeEnd]; exact this.2⟩
  · -- `sd`'s columns
    have hm1 : Room (S₀.mem.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val))
        (c.kdV j) kdMask) (c.s.slot 1) 4096 :=
      h.sd.maskedStoreAt
    have hsd : Fits (sdStores (S₀.mem.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val))
          (c.kdV j) kdMask)
          ((c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2))) (c.sS j) 32) (c.sdPtr i w) 16 ∧
        (sdStores (S₀.mem.maskedStoreAt ((c.s.slot 0).add (BitVec.ofNat 64 j.val))
          (c.kdV j) kdMask)
          ((c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2))) (c.sS j) 32).readAt
          (c.sdPtr i w) 16 = recode8 (c.sS i) w := by
      by_cases hij : i = j
      · subst hij
        exact sd_col_store c hm1 i.isLt (c.sS i) 32 le_rfl w hw
      · have hne : i.val ≠ j.val := fun e => hij (Fin.ext e)
        refine sdStores_keep (kd_apart_store c (j := j.val) (V := c.kdV j)
          (by rw [Call.sdPtr, Pointer.add_id]; exact ne 1 0 (by decide))
          (h.scol i (by omega) w hw)) 32 fun k _ => ?_
        rw [sd_ptr]
        simp only [Call.sdPtr]
        exact recode_slot_disjoint c.s 1 (by omega) (by omega) (by omega)
    rw [hm, Call.colMem]
    exact ⟨hsd.1.lifetimeEnd (by rw [Call.sdPtr, Pointer.add_id]; exact ne 1 2 (by decide)),
      by rw [MemoryState.readAt_lifetimeEnd]; exact hsd.2⟩

/-- `lifetime.start` of `kj` keeps `Rec`, and gives `kj` room. -/
theorem Call.Rec.start2 {c : Call} {j : Nat} {S : GlobalState} (h : c.Rec j S) :
    c.Rec j { S with mem := S.mem.lifetimeStart (c.s.slot 2) } ∧
      Room (S.mem.lifetimeStart (c.s.slot 2)) (c.s.slot 2) 512 := by
  have hb := h.base
  have ne (k l : Nat) (hkl : k ≠ l) : (c.s.slot k).id ≠ (c.s.slot l).id := slot_ne c.s hkl
  have ne' (k : Nat) (hk : k ≠ 2) (b : BitVec 64) : ((c.s.slot k).add b).id ≠ (c.s.slot 2).id :=
    slot_ne_slot c.s hk b
  have h2 := hb.slots 2 (by decide)
  simp only [slotBytes, List.getElem_cons_zero, List.getElem_cons_succ] at h2
  refine ⟨⟨hb.frameOps ((FrameOps.refl _ _).lifetimeStart (by simp)) hb.wf.lifetimeStart rfl,
    ⟨h.ks.k_fits.lifetimeStart (ne 26 2 (by decide)), ?_,
      h.ks.s_fits.lifetimeStart (ne 27 2 (by decide)), ?_⟩,
    ⟨h.a.fit.lifetimeStart (ne 28 2 (by decide)), ?_⟩,
    ⟨h.r.fit.lifetimeStart (ne 29 2 (by decide)), ?_⟩,
    h.kd.lifetimeStart (ne 0 2 (by decide)), h.sd.lifetimeStart (ne 1 2 (by decide)),
    fun i hi w hw => ⟨(h.kcol i hi w hw).1.lifetimeStart (ne' 0 (by decide) _), ?_⟩,
    fun i hi w hw => ⟨(h.scol i hi w hw).1.lifetimeStart (ne' 1 (by decide) _), ?_⟩⟩,
    Room.lifetimeStart_self h2 (hb.writable 2 (by decide))⟩
  · dsimp only; rw [MemoryState.readAt_lifetimeStart, h.ks.k_read]
  · dsimp only; rw [MemoryState.readAt_lifetimeStart, h.ks.s_read]
  · dsimp only; rw [MemoryState.readLanePoint_lifetimeStart, h.a.read]
  · dsimp only; rw [MemoryState.readLanePoint_lifetimeStart, h.r.read]
  · dsimp only; rw [MemoryState.readAt_lifetimeStart, (h.kcol i hi w hw).2]
  · dsimp only; rw [MemoryState.readAt_lifetimeStart, (h.scol i hi w hw).2]

/-- `^bb79`'s state after the eight lanes. -/
theorem Call.Rec.at79 {c : Call} {S : GlobalState} (h : c.Rec 8 S) : c.At79 S := by
  have hkf : ∀ k < 511 + 1, Fits S.mem ((c.s.slot 0).add (BitVec.ofNat 64 (1 * k))) 8 := by
    intro k hk
    have := (h.kcol ⟨k % 8, by omega⟩ (by simp; omega) (k / 8) (by omega)).1
    rwa [Call.kdPtr, show 8 * (k / 8) + k % 8 = 1 * k by omega] at this
  have hsf : ∀ k < 255 + 1, Fits S.mem ((c.s.slot 1).add (BitVec.ofNat 64 (2 * k))) 16 := by
    intro k hk
    have := (h.scol ⟨k % 8, by omega⟩ (by simp; omega) (k / 8) (by omega)).1
    rwa [Call.sdPtr, show 2 * (8 * (k / 8) + k % 8) = 2 * k by omega] at this
  refine ⟨h.base, fits_cells8 (by simp) 511 hkf (by decide), ?_, fits_cells16 (by simp) 255 hsf
    (by decide), ?_, h.a, h.r⟩
  · refine readAt_cells8 (n := 512) (by simp) h.kd.inBounds (by decide) fun k => ?_
    have := (h.kcol ⟨k.val % 8, by omega⟩ (by simp; omega) (k.val / 8) (by omega)).2
    rwa [Call.kdPtr, show 8 * (k.val / 8) + k.val % 8 = 1 * k.val by omega] at this
  · refine readAt_cells16 (n := 256) (by simp) h.sd.inBounds (by decide) fun k => ?_
    have := (h.scol ⟨k.val % 8, by omega⟩ (by simp; omega) (k.val / 8) (by omega)).2
    rwa [Call.sdPtr, show 2 * (8 * (k.val / 8) + k.val % 8) = 2 * k.val by omega] at this

end

end MLIR.Firedancer.Lane.VerifyX8

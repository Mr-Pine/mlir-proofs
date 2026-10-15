module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split.Loop
public import Firedancer.Lane.Common.SplitDec
public import Firedancer.Lane.fd_r43x6_ge_decode_step_slow

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

@[expose] public section

namespace double_scalar_mul_base_split

open _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split
open Split

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.runFrom

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.hty $k)

set_option hygiene false in
/-- An add's decode step, from its first block to the join: the state's facts named, the slow
step, the done chain and the three squarings, each on to the join with `D.step 3`. -/
local macro "dec_site" : tactic =>
  `(tactic|
    (
      have hself := MemoryState.storeDec_self hD
      have hx := decRoom_room hdr 0#64 512
      have hr := decRoom_room hdr 712#64 64
      rw [Pointer.add_zero] at hx
      have hov := hdr.1
      obtain ⟨⟨fx, rx⟩, -, -, -, -, -, -, -, -, -, -, ⟨fs, rs⟩, ⟨fr, rr⟩, -⟩ := id hD
      obtain ⟨hC, hL⟩ := hL
      split_env hC hL hR
      block_init
      step_load
      step_pure
      finish_block
      · have hlt := hbr
        block_init
        step_load
        step_pure
        finish_block
        · have hs : D.stage < 12 := BitVec.ult_iff_lt.mp hbr
          block_init
          step_call using fd_r43x6_ge_decode_step_slow.call_eq consuming hD hg
          finish_block
          rw [DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_left hs] at hK
          rw [hS]
          exact hK E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
        · have hs : ¬D.stage < 12 := fun h => hbr (BitVec.ult_iff_lt.mpr h)
          rw [DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_right hs, hself] at hK
          rw [hS]
          exact hK E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
      · rw [DecSt.step, ite_eq_left hbr, ← MemoryState.storeDec_sqrs hov (hS ▸ hD)] at hK
        clear hD hdr
        block_init
        step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with x'
        step_pattern using runBodyFrom_r43SqrRun with x1
        step_pattern using runBodyFrom_r43SqrRun with x2
        step_pattern using runBodyFrom_r43SqrRun with x3
        step_store
        step_pure [sub3_eq]
        step_store
        finish_block
        rw [hS, hx3, hx2, hx1, hx']
        exact hK E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)))

/-- `dec`'s registers in the main loop: `dec != NULL`, `&dec->rem`, `&dec->stage`. -/
abbrev LiveD (r n1s n2s bt tp dec : Pointer) (i : Nat) (E : ⟪Γ⟫) : Prop :=
  Live r n1s n2s bt tp 0#1 (.value (dec.add 712#64)) (.value (dec.add 704#64)) i E

/-- `rem - 3`, as the code adds `-3`. -/
theorem sub3_eq (x : BitVec 64) : x + 18446744073709551613#64 = x - 3#64 := by
  bv_decide

/-! ### The decode state beside the loop's memory -/

/-- `P`, folded: kept out of the walks, whose tactics scan the context. -/
def Held (P : Prop) : Prop := P

/-- `dec`'s block apart from the loop's others. -/
structure DecSep (dec r n1s n2s bt ta tp : Pointer) (btp : Nat → Pointer) : Prop where
  r : dec.id ≠ r.id
  n1 : dec.id ≠ n1s.id
  n2 : dec.id ≠ n2s.id
  bt : dec.id ≠ bt.id
  ta : dec.id ≠ ta.id
  tp : dec.id ≠ tp.id
  bp : ∀ j < 8, dec.id ≠ (btp j).id

/-- The loop's memory facts past a store of the decode state. -/
theorem Base.storeDec {M : MemoryState} {r n1s n2s bt ta tp dec : Pointer} {btp : Nat → Pointer}
    {w1 w2 : Vector Int 256} {TA : Nat → Quad} {TB : Nat → Nat → Quad} {D : DecSt}
    (h : Base M r n1s n2s bt ta btp w1 w2 TA TB) (hs : DecSep dec r n1s n2s bt ta tp btp) :
    Base (M.storeDec dec D) r n1s n2s bt ta btp w1 w2 TA TB where
  roomR := MemoryState.QuadRoom.storeDec h.roomR
  s1 k hk := ⟨Fits.storeDec (h.s1 k hk).1, by
    rw [MemoryState.readAt_storeDec_of_id_ne (by rw [Pointer.add_id]; exact hs.n1)]
    exact (h.s1 k hk).2⟩
  s2 k hk := ⟨Fits.storeDec (h.s2 k hk).1, by
    rw [MemoryState.readAt_storeDec_of_id_ne (by rw [Pointer.add_id]; exact hs.n2)]
    exact (h.s2 k hk).2⟩
  n1o := h.n1o
  n2o := h.n2o
  rn1 := h.rn1
  rn2 := h.rn2
  rbt := h.rbt
  rta := h.rta
  rbp := h.rbp
  tao := h.tao
  tap k hk := ⟨MemoryState.QuadFit.storeDec (h.tap k hk).1, by
    rw [MemoryState.readQuad_storeDec_of_id_ne (by rw [Pointer.add_id]; exact hs.ta)]
    exact (h.tap k hk).2⟩
  bto := h.bto
  bt j hj := ⟨InBounds.storeDec (h.bt j hj).1, by
    rw [MemoryState.loadPtr_storeDec_of_id_ne (by rw [Pointer.add_id]; exact hs.bt)]
    exact (h.bt j hj).2⟩
  btpo := h.btpo
  btq j hj k hk := ⟨MemoryState.QuadFit.storeDec (h.btq j hj k hk).1, by
    rw [MemoryState.readQuad_storeDec_of_id_ne (by rw [Pointer.add_id]; exact hs.bp j hj)]
    exact (h.btq j hj k hk).2⟩

/-- The decode state past changes outside its block. -/
theorem decHolds_of {m m' : MemoryState} {st : Pointer} {D : DecSt}
    (hf : ∀ (p : Pointer) (w : Nat), p.id = st.id → Fits m p w → Fits m' p w)
    (hr : ∀ (p : Pointer) (w : Nat), p.id = st.id → m'.readAt p w = m.readAt p w)
    (h : m.DecHolds st D) : m'.DecHolds st D := by
  have e (o : BitVec 64) : (st.add o).id = st.id := Pointer.add_id st o
  have ho (o : BitVec 64) (x : Option Wwl) (hx : m.OptHolds (st.add o) x) :
      m'.OptHolds (st.add o) x := by
    cases x
    · trivial
    · exact ⟨hf _ _ (e o) hx.1, (hr _ _ (e o)).trans hx.2⟩
  obtain ⟨⟨f1, r1⟩, ⟨f2, r2⟩, ⟨f3, r3⟩, o2, o9, o10, o50, ⟨f4, r4⟩, ⟨f5, r5⟩, ⟨f6, r6⟩, ⟨f7, r7⟩,
    ⟨f8, r8⟩, ⟨f9, r9⟩, ⟨f10, r10⟩⟩ := h
  exact ⟨⟨hf _ _ rfl f1, (hr _ _ rfl).trans r1⟩, ⟨hf _ _ (e _) f2, (hr _ _ (e _)).trans r2⟩,
    ⟨hf _ _ (e _) f3, (hr _ _ (e _)).trans r3⟩, ho _ _ o2, ho _ _ o9, ho _ _ o10, ho _ _ o50,
    ⟨hf _ _ (e _) f4, (hr _ _ (e _)).trans r4⟩, ⟨hf _ _ (e _) f5, (hr _ _ (e _)).trans r5⟩,
    ⟨hf _ _ (e _) f6, (hr _ _ (e _)).trans r6⟩, ⟨hf _ _ (e _) f7, (hr _ _ (e _)).trans r7⟩,
    ⟨hf _ _ (e _) f8, (hr _ _ (e _)).trans r8⟩, ⟨hf _ _ (e _) f9, (hr _ _ (e _)).trans r9⟩,
    ⟨hf _ _ (e _) f10, (hr _ _ (e _)).trans r10⟩⟩

/-- The decode state past a point store to another block. -/
theorem decHolds_storeQuad {m : MemoryState} {st p : Pointer} {P : Quad} {D : DecSt}
    (h : m.DecHolds st D) (hne : p.id ≠ st.id) : (m.storeQuad p P).DecHolds st D :=
  decHolds_of (fun _ _ _ hf => Fits.storeQuad hf)
    (fun _ _ hq => MemoryState.readAt_storeQuad_of_id_ne (by rw [hq]; exact hne)) h

/-- The decode state past a store to another block. -/
theorem decHolds_storeAt {m : MemoryState} {st q : Pointer} {x : BitVec w} {D : DecSt}
    (h : m.DecHolds st D) (hne : st.id ≠ q.id) : (m.storeAt q x).DecHolds st D :=
  decHolds_of (fun _ _ _ hf => Fits.storeAt hf)
    (fun p _ hp => MemoryState.readAt_storeAt_disjoint
      (Or.inl (by simpa [Range.of, hp] using hne.symm)) _) h

/-- The decode state past a pointer store to another block. -/
theorem decHolds_storePtr {m : MemoryState} {st q x : Pointer} {D : DecSt}
    (h : m.DecHolds st D) (hne : st.id ≠ q.id) : (m.storePtr q x).DecHolds st D :=
  decHolds_of (fun _ _ hp hf => Fits.storePtr_of_disjoint hf
      (Or.inl (by simpa [Range.of, hp] using hne.symm)))
    (fun p _ hp => MemoryState.readAt_storePtr_disjoint
      (Or.inl (by simpa [Range.of, hp] using hne.symm))) h

/-- Room for the decode state past a store. -/
theorem decRoom_storeAt {m : MemoryState} {st q : Pointer} {x : BitVec w} (h : m.DecRoom st) :
    (m.storeAt q x).DecRoom st :=
  ⟨h.1, Room.storeAt h.2⟩

/-- Room for the decode state past a pointer store. -/
theorem decRoom_storePtr {m : MemoryState} {st q x : Pointer} (h : m.DecRoom st) :
    (m.storePtr q x).DecRoom st :=
  ⟨h.1, Room.storePtr h.2⟩

/-- A point store keeps the globals' table. -/
theorem globals_storeQuad {m : MemoryState} {p : Pointer} {P : Quad} :
    (m.storeQuad p P).globals = m.globals :=
  rfl

/-- The memory an add's decode step leaves: the state `D'` in place of `D`, beneath `r`. -/
theorem step_mem {M X : MemoryState} {r dec : Pointer} {R T : Quad} {D D' : DecSt}
    (hX : X = (M.storeDec dec D).storeQuad r R) (hrd : r.id ≠ dec.id)
    (hro : r.offset.toNat + 192 ≤ 2 ^ 64) (hov : ¬dec.offset.uaddOverflow 724#64)
    (hm : D.Mono D') : (X.storeQuad r T).storeDec dec D' = (M.storeDec dec D').storeQuad r T := by
  rw [hX, MemoryState.storeQuad_storeQuad_self hro, MemoryState.storeQuad_storeDec hrd,
    MemoryState.storeDec_storeDec hov hm]

/-- The facts an add's decode step needs, at `r`'s copy of `t` over the state `D`. -/
theorem step_facts {M X : MemoryState} {r dec : Pointer} {R T : Quad} {D : DecSt}
    {G : List Global} (hX : X = (M.storeDec dec D).storeQuad r R) (hrd : r.id ≠ dec.id)
    (hdr : M.DecRoom dec) (hg : M.Globals G) :
    (X.storeQuad r T).DecRoom dec ∧ (X.storeQuad r T).DecHolds dec D ∧
      (X.storeQuad r T).Globals G := by
  subst hX
  refine ⟨⟨hdr.1, Room.storeQuad (Room.storeQuad (Room.storeDec hdr.2))⟩,
    decHolds_storeQuad (decHolds_storeQuad (MemoryState.DecHolds.storeDec hdr) hrd) hrd, ?_⟩
  exact ((MemoryState.Globals.storeDec hg).mono globals_storeQuad fun _ h => h).mono
    globals_storeQuad fun _ h => h

/-- `^bb7`, the doubling's decode step `fd_ed25519_point_decode_step( dec, 3 )`: on to `^bb11`
with `D.step 3` at `dec`. -/
theorem dbl_dec (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (i : Nat) (D : DecSt)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E) (hwf : S.WF)
    (hg : S.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hdr : S.mem.DecRoom dec) (hD : S.mem.DecHolds dec D) (hOk : D.Ok)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (runD E' 11 { S with mem := S.mem.storeDec dec (D.step 3#64) } >>= g) = K) :
    (runD E 7 S >>= g) = K := by
  have hself := MemoryState.storeDec_self hD
  have hx := decRoom_room hdr 0#64 512
  have hr := decRoom_room hdr 712#64 64
  rw [Pointer.add_zero] at hx
  have hov := hdr.1
  obtain ⟨⟨fx, rx⟩, -, -, -, -, -, -, -, -, -, -, ⟨fs, rs⟩, ⟨fr, rr⟩, -⟩ := id hD
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL
  block_init
  step_load
  step_pure
  finish_block
  · -- `rem < 3`: the slow step, unless the chain is done
    have hlt := hbr
    block_init
    step_load
    step_pure
    finish_block
    · have hs : D.stage < 12 := BitVec.ult_iff_lt.mp hbr
      block_init
      step_call using fd_r43x6_ge_decode_step_slow.call_eq consuming hD hg
      finish_block
      rw [DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_left hs] at hK
      rw [hS]
      exact hK E hArgs ⟨by env_reads, by env_reads⟩
    · have hs : ¬D.stage < 12 := fun h => hbr (BitVec.ult_iff_lt.mpr h)
      rw [DecSt.step, ite_eq_right (not_not.2 hlt), ite_eq_right hs, hself] at hK
      rw [hS]
      exact hK E hArgs ⟨by env_reads, by env_reads⟩
  · -- `3 ≤ rem`: three squarings
    rw [DecSt.step, ite_eq_left hbr, ← MemoryState.storeDec_sqrs hov (hS ▸ hD)] at hK
    clear hD hdr
    block_init
    step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with x'
    step_pattern using runBodyFrom_r43SqrRun with x1
    step_pattern using runBodyFrom_r43SqrRun with x2
    step_pattern using runBodyFrom_r43SqrRun with x3
    step_store
    step_pure [sub3_eq]
    step_store
    finish_block
    rw [hS, hx3, hx2, hx1, hx']
    exact hK E hArgs ⟨by env_reads, by env_reads⟩

/-- `^bb15`, the decode step after `n1slide`'s add: on to `^bb25`. -/
theorem add1_dec (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (i j : Nat) (d2 : BitVec 16) (T : Quad)
    (D : DecSt) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2, %%764 := T.P03, %%766 := T.P14,
      %%768 := T.P25]) (hwf : S.WF)
    (hg : S.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hdr : S.mem.DecRoom dec) (hD : S.mem.DecHolds dec D) (hOk : D.Ok)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2, %%1343 := T.P25, %%1344 := T.P14,
            %%1345 := T.P03]) →
          (runD E' 25 { S with mem := S.mem.storeDec dec (D.step 3#64) } >>= g) = K) :
    (runD E 15 S >>= g) = K := by
  dec_site

/-- `^bb21`, the decode step after `n1slide`'s sub: on to `^bb25`. -/
theorem sub1_dec (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (i j : Nat) (d2 : BitVec 16) (T : Quad)
    (D : DecSt) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2, %%1191 := T.P03, %%1193 := T.P14,
      %%1195 := T.P25]) (hwf : S.WF)
    (hg : S.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hdr : S.mem.DecRoom dec) (hD : S.mem.DecHolds dec D) (hOk : D.Ok)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2, %%1343 := T.P25, %%1344 := T.P14,
            %%1345 := T.P03]) →
          (runD E' 25 { S with mem := S.mem.storeDec dec (D.step 3#64) } >>= g) = K) :
    (runD E 21 S >>= g) = K := by
  dec_site

/-- `^bb27`, the decode step after `n2slide`'s add: on to `^bb37`. -/
theorem add2_dec (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (i j : Nat) (T : Quad) (D : DecSt)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%1614 := T.P03, %%1616 := T.P14,
      %%1618 := T.P25]) (hwf : S.WF)
    (hg : S.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hdr : S.mem.DecRoom dec) (hD : S.mem.DecHolds dec D) (hOk : D.Ok)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%2192 := T.P25, %%2193 := T.P14,
            %%2194 := T.P03]) →
          (runD E' 37 { S with mem := S.mem.storeDec dec (D.step 3#64) } >>= g) = K) :
    (runD E 27 S >>= g) = K := by
  dec_site

/-- `^bb33`, the decode step after `n2slide`'s sub: on to `^bb37`. -/
theorem sub2_dec (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (i j : Nat) (T : Quad) (D : DecSt)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%2040 := T.P03, %%2042 := T.P14,
      %%2044 := T.P25]) (hwf : S.WF)
    (hg : S.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hdr : S.mem.DecRoom dec) (hD : S.mem.DecHolds dec D) (hOk : D.Ok)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%2192 := T.P25, %%2193 := T.P14,
            %%2194 := T.P03]) →
          (runD E' 37 { S with mem := S.mem.storeDec dec (D.step 3#64) } >>= g) = K) :
    (runD E 33 S >>= g) = K := by
  dec_site

end double_scalar_mul_base_split

end

end MLIR.Firedancer.Lane

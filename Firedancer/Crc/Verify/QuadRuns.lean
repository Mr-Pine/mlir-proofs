module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.wl_permute
public import Firedancer.Crc.Verify.Reads

/-! The instruction runs of crc's QUAD composites, as patterns: each one's instructions over
register variables, and a continuation-form lemma stepping them (`step_pattern`). -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

/-- `wl_permute`'s argument for a lane index. -/
abbrev laneIdx (i : Nat) : BitVec 32 :=
  BitVec.ofNat 32 i

theorem laneIdx_toNat {j : Nat} (h : j < 4) : (laneIdx j).toNat = j := by
  simp only [laneIdx, BitVec.toNat_ofNat]
  omega

/-- The `shufflevector` mask of a lane blend: lane `k` of the first operand where `ik` is not `0`,
else of the second. -/
def blendMask (i0 i1 i2 i3 : Nat) : Vector (Option (Fin (2 * 4))) 4 :=
  #v[some (if i0 = 0 then 4 else 0), some (if i1 = 0 then 5 else 1), some (if i2 = 0 then 6 else 2),
    some (if i3 = 0 then 7 else 3)]

theorem shufflevector_blendMask {i0 i1 i2 i3 : Nat} (h0 : i0 ≤ 1) (h1 : i1 ≤ 1) (h2 : i2 ≤ 1)
    (h3 : i3 ≤ 1) (a b : Wl) :
    Operation.shufflevector (blendMask i0 i1 i2 i3) (Ty.wrap (t := .vec 4 64) a)
        (Ty.wrap (t := .vec 4 64) b) =
      Ty.wrap (t := .vec 4 64) (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) a b) := by
  ext k hk : 1
  simp only [Operation.shufflevector, blendMask, wlBlend, Ty.wrap_vec, Vector.getElem_ofFn,
    Vector.getElem_map]
  obtain rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 := by omega
  · obtain rfl | rfl : i0 = 0 ∨ i0 = 1 := by omega
    all_goals simp
  · obtain rfl | rfl : i1 = 0 ∨ i1 = 1 := by omega
    all_goals simp
  · obtain rfl | rfl : i2 = 0 ∨ i2 = 1 := by omega
    all_goals simp
  · obtain rfl | rfl : i3 = 0 ∨ i3 = 1 := by omega
    all_goals simp

/-! ### A frame of `alloca` slots -/

/-- `s` after `n` `alloca`s of a `wl_t` each, dead until started. -/
def allocaIter : Nat → GlobalState → GlobalState
  | 0, s => s
  | n + 1, s => (allocaIter n s).alloca 32 true

theorem allocaIter_alloc {s : GlobalState} :
    (allocaIter n s).alloc = ⟨s.alloc.nextFreeBlock + n⟩ := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [allocaIter, GlobalState.alloca_alloc, ih, Nat.add_assoc]

theorem allocaIter_allocaPtr {s : GlobalState} : (allocaIter n s).allocaPtr = s.slot n := by
  simp only [GlobalState.allocaPtr, allocaIter_alloc, GlobalState.slot]
  rfl

theorem _root_.MLIR.GlobalState.WF.allocaIter {s : GlobalState} (h : s.WF) : (allocaIter n s).WF := by
  induction n with
  | zero => exact h
  | succ n ih => exact ih.alloca

theorem _root_.MLIR.Room.allocaIter {s : GlobalState} (hwf : s.WF) (h : Room s.mem p w) :
    Room (allocaIter n s).mem p w := by
  induction n with
  | zero => exact h
  | succ n ih => exact ih.alloca hwf.allocaIter

theorem eraseFrom_allocaIter {s : GlobalState} :
    (allocaIter n s).mem.eraseFrom s.alloc.nextFreeBlock = s.mem.eraseFrom s.alloc.nextFreeBlock := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [allocaIter, GlobalState.eraseFrom_alloca_of_le (by simp [allocaIter_alloc]), ih]

/-- Slots `0 … n-1` of `B` in bounds for a `wl_t` and writable: the `alloca` slots of a frame. -/
def SlotFrame (B : GlobalState) (n : Nat) (m : MemoryState) : Prop :=
  ∀ j, j < n → InBounds m (B.slot j) 256 ∧ Writable m (B.slot j)

theorem SlotFrame.allocaIter {B : GlobalState} (hwf : B.WF) : SlotFrame B n (allocaIter n B).mem := by
  induction n with
  | zero => intro j hj; omega
  | succ n ih =>
    intro j hj
    rcases Nat.lt_succ_iff_lt_or_eq.mp hj with hj | rfl
    · exact ⟨(ih j hj).1.alloca hwf.allocaIter, (ih j hj).2.alloca hwf.allocaIter⟩
    · rw [← allocaIter_allocaPtr]
      exact ⟨InBounds.allocaPtr (Nat.le_refl _), Writable.allocaPtr⟩

theorem SlotFrame.of {B : GlobalState} {m m' : MemoryState}
    (hb : ∀ p w, InBounds m p w → InBounds m' p w) (hw : ∀ p, Writable m p → Writable m' p)
    (h : SlotFrame B n m) : SlotFrame B n m' :=
  fun j hj => ⟨hb _ _ (h j hj).1, hw _ (h j hj).2⟩

@[mlir_transport]
theorem SlotFrame.storeAt {B : GlobalState} {m : MemoryState} {x : BitVec w}
    (h : SlotFrame B n m) : SlotFrame B n (m.storeAt p x) :=
  h.of (fun _ _ => InBounds.storeAt) fun _ => Writable.storeAt

@[mlir_transport]
theorem SlotFrame.storeTmp5 {B : GlobalState} {m : MemoryState} (h : SlotFrame B n m) :
    SlotFrame B n (m.storeTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.storeTmp5) fun _ => Writable.storeTmp5

@[mlir_transport]
theorem SlotFrame.callTmp5 {B : GlobalState} {m : MemoryState} (h : SlotFrame B n m) :
    SlotFrame B n (m.callTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.callTmp5) fun _ => Writable.callTmp5

/-- Room below `B`'s slots survives a callee's temporaries in them. -/
theorem room_callTmp5_slots {m : MemoryState} {B : GlobalState} {p : Pointer} {a b c d e : Nat}
    (h : Room m p w) (hp : p.id.id < B.alloc.nextFreeBlock) :
    Room (m.callTmp5 (B.slot a) (B.slot b) (B.slot c) (B.slot d) (B.slot e) Q) p w := by
  have ne : ∀ k, p.id ≠ (B.slot k).id := fun k he => by
    have := congrArg BlockId.id he
    rw [GlobalState.slot_id_id] at this
    omega
  exact Room.callTmp5 h (ne a) (ne b) (ne c) (ne d) (ne e)

@[mlir_transport]
theorem SlotFrame.lifetimeStart {B : GlobalState} {m : MemoryState} (h : SlotFrame B n m) :
    SlotFrame B n (m.lifetimeStart p) :=
  h.of (fun _ _ => InBounds.lifetimeStart) fun _ => Writable.lifetimeStart

@[mlir_transport]
theorem SlotFrame.lifetimeEnd {B : GlobalState} {m : MemoryState} (h : SlotFrame B n m) :
    SlotFrame B n (m.lifetimeEnd p) :=
  h.of (fun _ _ => InBounds.lifetimeEnd) fun _ => Writable.lifetimeEnd

/-- The env after `alloca`s into `ds`: `ds[i]` holds slot `k + i` of `B`. -/
def writeSlots (E : ⟪Γ⟫) (B : GlobalState) : Nat → List (Dst Γ .ptr) → ⟪Γ⟫
  | _, [] => E
  | k, d :: ds => writeSlots (E.write d (.value (B.slot k))) B (k + 1) ds

/-- `allocaIter` as the body runs it: `alloca`s of a `wl_t` into `ds`, from slot `k` of `B`. -/
theorem runBodyFrom_allocas_aux {blk : BasicBlock Γ tRets bp} {B : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {rest : List (Instr Γ)} :
    ∀ (ds : List (Dst Γ .ptr)) (E : ⟪Γ⟫) (k pos : Nat),
      blk.body.drop pos = ds.map (fun d => Instr.alloca d 32 true) ++ rest →
      (blk.runBodyFrom (writeSlots E B k ds) (pos + ds.length) (allocaIter (k + ds.length) B) >>=
          g) = K →
      (blk.runBodyFrom E pos (allocaIter k B) >>= g) = K
  | [], E, k, pos, _, hK => by simpa [writeSlots] using hK
  | d :: ds, E, k, pos, hbody, hK => by
    have hb : blk.body.drop pos = Instr.alloca d 32 true :: (ds.map (fun d => Instr.alloca d 32 true) ++ rest) := by
      simpa using hbody
    rw [BasicBlock.runBodyFrom_step_of_run (List.lt_length_of_drop_eq_cons hb)
      (by rw [List.getElem_of_drop_eq_cons hb]; rfl)]
    have h := runBodyFrom_allocas_aux ds (E.write d (.value (B.slot k))) (k + 1) (pos + 1)
      (List.drop_succ_of_drop_eq_cons hb)
      (by simpa [writeSlots, Nat.add_assoc, Nat.add_comm 1] using hK)
    rw [allocaIter_allocaPtr]
    exact h

/-- Where the body at `pos` is `alloca`s of a `wl_t` into `ds`: running on from `pos` then `g` gives
`K` if it does from past them with `ds[i]` holding `S.slot i`, on a state `S'` whose slots
`0 … |ds|-1` are a `SlotFrame`, `|ds|` blocks on, with `S`'s rooms and frame. -/
theorem runBodyFrom_allocas {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {rest : List (Instr Γ)}
    (ds : List (Dst Γ .ptr)) (hbody : blk.body.drop pos = ds.map (fun d => Instr.alloca d 32 true) ++ rest)
    (hwf : S.WF)
    (hK :
      ∀ S' : GlobalState, S'.WF → SlotFrame S ds.length S'.mem →
        (∀ p w, Room S.mem p w → Room S'.mem p w) →
        S'.alloc = ⟨S.alloc.nextFreeBlock + ds.length⟩ →
        S'.mem.eraseFrom S.alloc.nextFreeBlock = S.mem.eraseFrom S.alloc.nextFreeBlock →
        (blk.runBodyFrom (writeSlots E S 0 ds) (pos + ds.length) S' >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_allocas_aux (B := S) ds E 0 pos hbody
    (by
      simpa using hK _ hwf.allocaIter (SlotFrame.allocaIter hwf) (fun _ _ h => h.allocaIter hwf)
        (by simp [allocaIter_alloc]) eraseFrom_allocaIter)

theorem slot_ids_ne {B : GlobalState} {k0 k1 k2 k3 k4 : Nat} (h : [k0, k1, k2, k3, k4].Nodup) :
    (B.slot k1).id ≠ (B.slot k0).id ∧ (B.slot k2).id ≠ (B.slot k0).id ∧
      (B.slot k3).id ≠ (B.slot k0).id ∧ (B.slot k4).id ≠ (B.slot k0).id ∧
      (B.slot k2).id ≠ (B.slot k1).id ∧ (B.slot k3).id ≠ (B.slot k1).id ∧
      (B.slot k4).id ≠ (B.slot k1).id ∧ (B.slot k3).id ≠ (B.slot k2).id ∧
      (B.slot k4).id ≠ (B.slot k2).id ∧ (B.slot k4).id ≠ (B.slot k3).id := by
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, or_false, not_or] at h
  obtain ⟨⟨h01, h02, h03, h04⟩, ⟨h12, h13, h14⟩, ⟨h23, h24⟩, h34, -⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    exact GlobalState.slot_id_ne (by omega)

/-- A `<32 x i8>` load of a stored `wl_t`, as the steps give it: its bytes. -/
theorem ofFn_extractVecElem_packLanes (v : Wl) :
    (Vector.ofFn fun i => Ty.extractVecElem 32 8 i (BitVec.packLanes (we := 64) v)) = wlBytes v := by
  ext k hk : 1
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, wlBytes]
  exact extractLsb'_packLanes_byte _ hk

theorem Quad5.laneIf_P0 : (Quad5.laneIf i0 i1 i2 i3 S T).P0 = wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) S.P0 T.P0 := rfl
theorem Quad5.laneIf_P1 : (Quad5.laneIf i0 i1 i2 i3 S T).P1 = wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) S.P1 T.P1 := rfl
theorem Quad5.laneIf_P2 : (Quad5.laneIf i0 i1 i2 i3 S T).P2 = wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) S.P2 T.P2 := rfl
theorem Quad5.laneIf_P3 : (Quad5.laneIf i0 i1 i2 i3 S T).P3 = wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) S.P3 T.P3 := rfl
theorem Quad5.laneIf_P4 : (Quad5.laneIf i0 i1 i2 i3 S T).P4 = wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) S.P4 T.P4 := rfl
theorem quad5_zero_P0 : quad5_zero.P0 = wl_zero := rfl
theorem quad5_zero_P1 : quad5_zero.P1 = wl_zero := rfl
theorem quad5_zero_P2 : quad5_zero.P2 = wl_zero := rfl
theorem quad5_zero_P3 : quad5_zero.P3 = wl_zero := rfl
theorem quad5_zero_P4 : quad5_zero.P4 = wl_zero := rfl
theorem bne_one_zero : ((1 : Nat) != 0) = true := rfl
theorem bne_zero_zero : ((0 : Nat) != 0) = false := rfl

/-- A `wl_t`'s bytes cast back: the `wl_t`. -/
theorem bitcast_wrap_wlBytes (v : Wl) (h : (Ty.vec 32 8).width = (Ty.vec 4 64).width) :
    Operation.bitcast h (Ty.wrap (t := .vec 32 8) (wlBytes v)) = Ty.wrap (t := .vec 4 64) v := by
  ext k hk
  simp only [Operation.bitcast, Ty.wrap_vec, Vector.getElem_ofFn, Vector.getElem_map,
    Operation.bitcastPoison_map_value, Operation.poisonIf_false, map_getValue_map_value,
    packLanes_wlBytes]
  congr 1
  rw [BitVec.extractLsb'_cast]
  exact BitVec.extractLsb'_packLanes v k hk

section Patterns

/-- `FD_R52X5_QUAD_PERMUTE( d, j0,j1,j2,j3, x )` as compiled: five `wl_permute` calls, of `x0 … x4`
by the immediates in `c0 … c3`, into `r0 … r4`. -/
def permuteRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64))
    (r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.call wl_permute.call (.cons x0 (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil))))) (.cons r0 .nil),
    .call wl_permute.call (.cons x1 (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil))))) (.cons r1 .nil),
    .call wl_permute.call (.cons x2 (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil))))) (.cons r2 .nil),
    .call wl_permute.call (.cons x3 (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil))))) (.cons r3 .nil),
    .call wl_permute.call (.cons x4 (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil))))) (.cons r4 .nil)]

/-- Where the body at `pos` is `permuteRun`, `c0 … c3` hold the indices (each below 4) and
`x0 … x4` hold `X`: running on from `pos` then `g` gives `K` if it does from `pos + 5` with
`X.permute j0 j1 j2 j3` in `r0 … r4`, five blocks on (the calls' freed unions). -/
theorem runBodyFrom_permuteRun (j0 j1 j2 j3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64)}
    {r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)} {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteRun c0 c1 c2 c3 x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 ++ rest)
    (hR :
      E ⊨ [c0 := laneIdx j0, c1 := laneIdx j1, c2 := laneIdx j2, c3 := laneIdx j3, x0 := X.P0,
        x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4])
    (hj : j0 < 4 ∧ j1 < 4 ∧ j2 < 4 ∧ j3 < 4) (hwf : S.WF)
    (hd :
      [x0, x1, x2, x3, x4, .val r0.i r0.h, .val r1.i r1.h, .val r2.i r2.h, .val r3.i r3.h].Nodup)
    (hK :
      ∀ Q : Quad5, Q = X.permute j0 j1 j2 j3 →
      (blk.runBodyFrom
            E[r0 := Ty.wrap Q.P0, r1 := Ty.wrap Q.P1,
              r2 := Ty.wrap Q.P2, r3 := Ty.wrap Q.P3,
              r4 := Ty.wrap Q.P4]
            (pos + 5) { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hj
  have e0 := laneIdx_toNat h0
  have e1 := laneIdx_toNat h1
  have e2 := laneIdx_toNat h2
  have e3 := laneIdx_toNat h3
  have hi :
    (laneIdx j0).toNat < 4 ∧
      (laneIdx j1).toNat < 4 ∧ (laneIdx j2).toNat < 4 ∧ (laneIdx j3).toNat < 4 := by
    simp only [e0, e1, e2, e3]
    exact ⟨h0, h1, h2, h3⟩
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  rw [hE, hS]
  exact hK (X.permute j0 j1 j2 j3) rfl

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, a, b )` as compiled: five `shufflevector`s by
`blendMask`, of `ak` and `bk` into `rk`. -/
def blendRun (m : Vector (Option (Fin (2 * 4))) 4) (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Reg Γ (.vec 4 64))
    (r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.binop (.shufflevector m) r0 a0 b0, .binop (.shufflevector m) r1 a1 b1,
    .binop (.shufflevector m) r2 a2 b2, .binop (.shufflevector m) r3 a3 b3,
    .binop (.shufflevector m) r4 a4 b4]

/-- Where the body at `pos` is `blendRun (blendMask i0 i1 i2 i3)`, `a0 … a4` hold `A` and
`b0 … b4` hold `B`: running on from `pos` then `g` gives `K` if it does from `pos + 5` with
`Quad5.laneIf i0 i1 i2 i3 A B` in `r0 … r4`. -/
theorem runBodyFrom_blendRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Reg Γ (.vec 4 64)} {r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {A B : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        blendRun (blendMask i0 i1 i2 i3) a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 r0 r1 r2 r3 r4 ++ rest)
    (hR :
      E ⊨ [a0 := A.P0, a1 := A.P1, a2 := A.P2, a3 := A.P3, a4 := A.P4, b0 := B.P0, b1 := B.P1,
        b2 := B.P2, b3 := B.P3, b4 := B.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd :
      [a1, b1, a2, b2, a3, b3, a4, b4, .val r0.i r0.h, .val r1.i r1.h, .val r2.i r2.h,
          .val r3.i r3.h].Nodup)
    (hK :
      ∀ Q : Quad5, Q = Quad5.laneIf i0 i1 i2 i3 A B →
      (blk.runBodyFrom
            E[r0 := Ty.wrap Q.P0, r1 :=
              Ty.wrap Q.P1, r2 :=
              Ty.wrap Q.P2, r3 :=
              Ty.wrap Q.P3, r4 :=
              Ty.wrap Q.P4]
            (pos + 5) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pure [shufflevector_blendMask h0 h1 h2 h3]
  step_pure [shufflevector_blendMask h0 h1 h2 h3]
  step_pure [shufflevector_blendMask h0 h1 h2 h3]
  step_pure [shufflevector_blendMask h0 h1 h2 h3]
  step_pure [shufflevector_blendMask h0 h1 h2 h3]
  rw [hE]
  exact hK (Quad5.laneIf i0 i1 i2 i3 A B) rfl

/-- A one-QUAD leaf's call: `f( z0 … z4, x0 … x4 )` into five slots started for it, read back into
`q0 … q4`, the slots ended. -/
def leafRun1
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.lifetimeStart z0 32, .lifetimeStart z1 32, .lifetimeStart z2 32, .lifetimeStart z3 32,
    .lifetimeStart z4 32,
    .call f
      (.cons z0 (.cons z1 (.cons z2 (.cons z3 (.cons z4
        (.cons x0 (.cons x1 (.cons x2 (.cons x3 (.cons x4 .nil))))))))))
      .nil,
    .load q0 z0, .load q1 z1, .load q2 z2, .load q3 z3, .load q4 z4, .lifetimeEnd z4 32,
    .lifetimeEnd z3 32, .lifetimeEnd z2 32, .lifetimeEnd z1 32, .lifetimeEnd z0 32]

/-- Where the body at `pos` is `leafRun1 f`, `f` storing `spec X` at its five out-pointers (`hf`, a
leaf's `call_eq`), `x0 … x4` hold `X` and `z0 … z4` five slots in distinct blocks: running on from
`pos` then `g` gives `K` if it does from `pos + 16` with `spec X` in `q0 … q4` and left in the
slots, their lifetimes ended (`callTmp5`). -/
theorem runBodyFrom_leafRun1
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) .nil))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = leafRun1 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, z0 := B.slot k0, z1 := B.slot k1,
        z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16) { alloc := S.alloc, mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X) rfl

/-- A two-QUAD leaf's call: `f( z0 … z4, x0 … x4, y0 … y4 )` into five slots started for it, read
back into `q0 … q4`, the slots ended. -/
def leafRun2
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.lifetimeStart z0 32, .lifetimeStart z1 32, .lifetimeStart z2 32, .lifetimeStart z3 32,
    .lifetimeStart z4 32,
    .call f
      (.cons z0 (.cons z1 (.cons z2 (.cons z3 (.cons z4
        (.cons x0 (.cons x1 (.cons x2 (.cons x3 (.cons x4
          (.cons y0 (.cons y1 (.cons y2 (.cons y3 (.cons y4 .nil)))))))))))))))
      .nil,
    .load q0 z0, .load q1 z1, .load q2 z2, .load q3 z3, .load q4 z4, .lifetimeEnd z4 32,
    .lifetimeEnd z3 32, .lifetimeEnd z2 32, .lifetimeEnd z1 32, .lifetimeEnd z0 32]

/-- `runBodyFrom_leafRun1` for a two-QUAD leaf: `spec X Y` in `q0 … q4` and the slots. -/
theorem runBodyFrom_leafRun2
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5 → Quad5}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X Y : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) (.cons (Ty.wrap Y.P0)
                  (.cons (Ty.wrap Y.P1) (.cons (Ty.wrap Y.P2) (.cons (Ty.wrap Y.P3)
                    (.cons (Ty.wrap Y.P4) .nil)))))))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X Y) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X Y : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        leafRun2 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1,
        y2 := Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := B.slot k0, z1 := B.slot k1, z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X Y →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16) { alloc := S.alloc, mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X Y) rfl

/-- A one-QUAD leaf's call: `f( z0 … z4, x0 … x4 )` into five slots started for it, read back as
bytes into `q0 … q4`, the slots ended. -/
def leafRun1B
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 32 8)) : List (Instr Γ) :=
  [.lifetimeStart z0 32, .lifetimeStart z1 32, .lifetimeStart z2 32, .lifetimeStart z3 32,
    .lifetimeStart z4 32,
    .call f
      (.cons z0 (.cons z1 (.cons z2 (.cons z3 (.cons z4
        (.cons x0 (.cons x1 (.cons x2 (.cons x3 (.cons x4 .nil))))))))))
      .nil,
    .load q0 z0, .load q1 z1, .load q2 z2, .load q3 z3, .load q4 z4, .lifetimeEnd z4 32,
    .lifetimeEnd z3 32, .lifetimeEnd z2 32, .lifetimeEnd z1 32, .lifetimeEnd z0 32]

/-- Where the body at `pos` is `leafRun1B f`, `f` storing `spec X` at its five out-pointers (`hf`, a
leaf's `call_eq`), `x0 … x4` hold `X` and `z0 … z4` five slots in distinct blocks: running on from
`pos` then `g` gives `K` if it does from `pos + 16` with `spec X` in `q0 … q4` and left in the
slots, their lifetimes ended (`callTmp5`). -/
theorem runBodyFrom_leafRun1B
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) .nil))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 32 8)}
    {rest : List (Instr Γ)} {X : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = leafRun1B f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, z0 := B.slot k0, z1 := B.slot k1,
        z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X →
      (blk.runBodyFrom
            E[q0 := Ty.wrap (wlBytes Q.P0), q1 := Ty.wrap (wlBytes Q.P1), q2 := Ty.wrap (wlBytes Q.P2),
              q3 := Ty.wrap (wlBytes Q.P3), q4 := Ty.wrap (wlBytes Q.P4)]
            (pos + 16) { alloc := S.alloc, mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X) rfl

/-- `leafRun1` of a composite: its call moves the counter `a` blocks on. -/
def leafRun1A
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  leafRun1 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4

/-- `runBodyFrom_leafRun1` for a composite `f` whose call moves the counter `a` blocks on: the
continuation's state is `a` blocks on from `S`. -/
theorem runBodyFrom_leafRun1A
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5} {a : Nat}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) .nil))))))))))
              s =
            .value
              (.nil,
                { alloc := ⟨s.alloc.nextFreeBlock + a⟩,
                  mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = leafRun1A f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, z0 := B.slot k0, z1 := B.slot k1,
        z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16)
            { alloc := ⟨S.alloc.nextFreeBlock + a⟩,
              mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  simp only [leafRun1A] at hbody
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X) rfl

/-- `leafRun2` of a composite: its call moves the counter `a` blocks on. -/
def leafRun2A
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  leafRun2 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4

/-- `runBodyFrom_leafRun1A` for a two-QUAD composite: `spec X Y` in `q0 … q4` and the slots. -/
theorem runBodyFrom_leafRun2A
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5 → Quad5} {a : Nat}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X Y : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) (.cons (Ty.wrap Y.P0)
                  (.cons (Ty.wrap Y.P1) (.cons (Ty.wrap Y.P2) (.cons (Ty.wrap Y.P3)
                    (.cons (Ty.wrap Y.P4) .nil)))))))))))))))
              s =
            .value
              (.nil,
                { alloc := ⟨s.alloc.nextFreeBlock + a⟩,
                  mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X Y) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X Y : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        leafRun2A f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1,
        y2 := Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := B.slot k0, z1 := B.slot k1, z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X Y →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16)
            { alloc := ⟨S.alloc.nextFreeBlock + a⟩,
              mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  simp only [leafRun2A] at hbody
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X Y) rfl

/-- A two-QUAD leaf's call: `f( z0 … z4, x0 … x4, y0 … y4 )` into five slots started for it, read
back as bytes into `q0 … q4`, the slots ended. -/
def leafRun2B
    (f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals []))
    (z0 z1 z2 z3 z4 : Reg Γ .ptr) (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64))
    (q0 q1 q2 q3 q4 : Dst Γ (.vec 32 8)) : List (Instr Γ) :=
  [.lifetimeStart z0 32, .lifetimeStart z1 32, .lifetimeStart z2 32, .lifetimeStart z3 32,
    .lifetimeStart z4 32,
    .call f
      (.cons z0 (.cons z1 (.cons z2 (.cons z3 (.cons z4
        (.cons x0 (.cons x1 (.cons x2 (.cons x3 (.cons x4
          (.cons y0 (.cons y1 (.cons y2 (.cons y3 (.cons y4 .nil)))))))))))))))
      .nil,
    .load q0 z0, .load q1 z1, .load q2 z2, .load q3 z3, .load q4 z4, .lifetimeEnd z4 32,
    .lifetimeEnd z3 32, .lifetimeEnd z2 32, .lifetimeEnd z1 32, .lifetimeEnd z0 32]

/-- `runBodyFrom_leafRun1` for a two-QUAD leaf: `spec X Y` in `q0 … q4` and the slots. -/
theorem runBodyFrom_leafRun2B
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5 → Quad5}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X Y : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) (.cons (Ty.wrap Y.P0)
                  (.cons (Ty.wrap Y.P1) (.cons (Ty.wrap Y.P2) (.cons (Ty.wrap Y.P3)
                    (.cons (Ty.wrap Y.P4) .nil)))))))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X Y) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 32 8)}
    {rest : List (Instr Γ)} {X Y : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        leafRun2B f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1,
        y2 := Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := B.slot k0, z1 := B.slot k1, z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hwf : S.WF) (hF : SlotFrame B n S.mem) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X Y →
      (blk.runBodyFrom
            E[q0 := Ty.wrap (wlBytes Q.P0), q1 := Ty.wrap (wlBytes Q.P1), q2 := Ty.wrap (wlBytes Q.P2),
              q3 := Ty.wrap (wlBytes Q.P3), q4 := Ty.wrap (wlBytes Q.P4)]
            (pos + 16) { alloc := S.alloc, mem := S.mem.callTmp5 (B.slot k0) (B.slot k1) (B.slot k2) (B.slot k3) (B.slot k4) Q } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk0, hk1, hk2, hk3, hk4⟩ := hk
  obtain ⟨hz0, hw0⟩ := hF k0 hk0
  obtain ⟨hz1, hw1⟩ := hF k1 hk1
  obtain ⟨hz2, hw2⟩ := hF k2 hk2
  obtain ⟨hz3, hw3⟩ := hF k3 hk3
  obtain ⟨hz4, hw4⟩ := hF k4 hk4
  have hd := slot_ids_ne (B := B) hne
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hd
  clear hF
  iterate 5 step_pure
  clear hz0 hw0 hz1 hw1 hz2 hw2 hz3 hw3 hz4 hw4
  step_call using hf
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  step_load [ofFn_extractVecElem_packLanes] inline
  -- the lifetime ends need none of the memory facts
  clear * - hbody hR hK hE hS
  iterate 5 step_pure
  rw [hE, hS]
  exact hK (spec X Y) rfl

/-- `runBodyFrom_leafRun1` with the state's facts as one invariant `I`, which gives the slot frame
(`hIw`) and survives a call's temporaries in slots of `B` (`hIc`): the continuation's state is a
fresh `S'` with `I S'`. -/
theorem runBodyFrom_leafRun1I
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5} {I : GlobalState → Prop}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) .nil))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hIw : ∀ s, I s → s.WF ∧ SlotFrame B n s.mem)
    (hIc : ∀ s j0 j1 j2 j3 j4 Q, I s →
      I { alloc := s.alloc, mem := s.mem.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q })
    (hbody :
      blk.body.drop pos = leafRun1 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, z0 := B.slot k0, z1 := B.slot k1,
        z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hI : I S) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X → ∀ S' : GlobalState, I S' →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16) S' >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_leafRun1 hf hbody hR (hIw S hI).1 (hIw S hI).2 hk hne fun Q hQ =>
    hK Q hQ _ (hIc S k0 k1 k2 k3 k4 Q hI)

/-- `runBodyFrom_leafRun1I` for a two-QUAD leaf. -/
theorem runBodyFrom_leafRun2I
    {f :
      Vals [.ptr, .ptr, .ptr, .ptr, .ptr, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64,
          .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64] →
        EffectM (Vals [])}
    {spec : Quad5 → Quad5 → Quad5} {I : GlobalState → Prop}
    (hf :
      ∀ (z0 z1 z2 z3 z4 : Pointer) (X Y : Quad5) (s : GlobalState), s.WF → Room s.mem z0 256 →
        Room s.mem z1 256 → Room s.mem z2 256 → Room s.mem z3 256 → Room s.mem z4 256 →
          f (.cons (.value z0) (.cons (.value z1) (.cons (.value z2) (.cons (.value z3)
              (.cons (.value z4) (.cons (Ty.wrap X.P0) (.cons (Ty.wrap X.P1) (.cons (Ty.wrap X.P2)
                (.cons (Ty.wrap X.P3) (.cons (Ty.wrap X.P4) (.cons (Ty.wrap Y.P0)
                  (.cons (Ty.wrap Y.P1) (.cons (Ty.wrap Y.P2) (.cons (Ty.wrap Y.P3)
                    (.cons (Ty.wrap Y.P4) .nil)))))))))))))))
              s =
            .value (.nil, { s with mem := s.mem.storeTmp5 z0 z1 z2 z3 z4 (spec X Y) }))
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {z0 z1 z2 z3 z4 : Reg Γ .ptr}
    {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Reg Γ (.vec 4 64)} {q0 q1 q2 q3 q4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {X Y : Quad5} {B : GlobalState} {n k0 k1 k2 k3 k4 : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hIw : ∀ s, I s → s.WF ∧ SlotFrame B n s.mem)
    (hIc : ∀ s j0 j1 j2 j3 j4 Q, I s →
      I { alloc := s.alloc, mem := s.mem.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q })
    (hbody :
      blk.body.drop pos =
        leafRun2 f z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1,
        y2 := Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := B.slot k0, z1 := B.slot k1, z2 := B.slot k2, z3 := B.slot k3, z4 := B.slot k4])
    (hI : I S) (hk : k0 < n ∧ k1 < n ∧ k2 < n ∧ k3 < n ∧ k4 < n)
    (hne : [k0, k1, k2, k3, k4].Nodup)
    (hK :
      ∀ Q : Quad5, Q = spec X Y → ∀ S' : GlobalState, I S' →
      (blk.runBodyFrom
            E[q0 := Ty.wrap Q.P0, q1 := Ty.wrap Q.P1, q2 := Ty.wrap Q.P2,
              q3 := Ty.wrap Q.P3, q4 := Ty.wrap Q.P4]
            (pos + 16) S' >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_leafRun2 hf hbody hR (hIw S hI).1 (hIw S hI).2 hk hne fun Q hQ =>
    hK Q hQ _ (hIc S k0 k1 k2 k3 k4 Q hI)

/-- A write of a vector misses a read of a scalar. -/
theorem read_write_vec_of_bv (env : ⟪Γ⟫) (d : Dst Γ (.vec l w)) (r : Reg Γ (.bv w')) :
    (env.write d v).read r = env.read r :=
  Env.read_write_of_ty_ne _ _ _ Ty.noConfusion

/-- One `insertelement` at the literal lane `k`: lane `k` of `V` set to `a`, into `d`. -/
theorem runBodyFrom_insertelement_at {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {p : Nat}
    {v : Reg Γ (.vec l w)} {x : Reg Γ (.bv w)} {i : Reg Γ (.bv 32)} {d : Dst Γ (.vec l w)}
    {rest : List (Instr Γ)} {V : ⟦.vec l w⟧} {a : ⟦.bv w⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (k : Nat) (hk : k < l)
    (hb : blk.body.drop p = .ternop .insertelement d v x i :: rest)
    (hv : E.read v = V) (hx : E.read x = a) (hi : E.read i = .value (BitVec.ofNat 32 k))
    (hk32 : k < 2 ^ 32)
    (hK :
      blk.body.drop (p + 1) = rest →
        (blk.runBodyFrom E[d := V.set k a hk] (p + 1) S >>= g) = K) :
    (blk.runBodyFrom E p S >>= g) = K := by
  rw [BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb)
      (by rw [List.getElem_of_drop_eq_cons hb]; rfl)]
  simp only [TernOp.compute, Operation.insertelement, hv, hx, hi, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt hk32, hk, dite_true]
  exact hK (List.drop_succ_of_drop_eq_cons hb)

/-- A lane blend on bytes as compiled: the bytes `c`, zero where lane `k`'s bit is `0`, shuffled with a
`wl_t`'s bytes `x` (lane `k` from `x` where its bit is `1`) into `s`, cast back into `r`. -/
def byteBlendRun_0010 (c x : Reg Γ (.vec 32 8)) (s : Dst Γ (.vec 32 8)) (r : Dst Γ (.vec 4 64)) :
    List (Instr Γ) :=
  [.binop (.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 24, some 25, some 26, some 27, some 28, some 29, some 30, some 31] : Vector (Option (Fin (2 * 32))) 32)) s c x,
    .unop (.bitcast (by decide)) r (.val s.i s.h)]

/-- `byteBlendRun_0010`'s `shufflevector` on a `wl_t`'s bytes: the bytes of the blend with zero. -/
theorem shufflevector_byteBlend_0010 {C : ⟦.vec 32 8⟧} (a : Wl) (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8 ∧ C[8] = .value 0#8 ∧ C[9] = .value 0#8 ∧ C[10] = .value 0#8 ∧ C[11] = .value 0#8 ∧ C[12] = .value 0#8 ∧ C[13] = .value 0#8 ∧ C[14] = .value 0#8 ∧ C[15] = .value 0#8 ∧ C[24] = .value 0#8 ∧ C[25] = .value 0#8 ∧ C[26] = .value 0#8 ∧ C[27] = .value 0#8 ∧ C[28] = .value 0#8 ∧ C[29] = .value 0#8 ∧ C[30] = .value 0#8 ∧ C[31] = .value 0#8) :
    Operation.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 24, some 25, some 26, some 27, some 28, some 29, some 30, some 31] : Vector (Option (Fin (2 * 32))) 32) C
        (Ty.wrap (t := .vec 32 8) (wlBytes a)) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wlBlend false false true false a wl_zero)) := by
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e24, e25, e26, e27, e28, e29, e30, e31⟩ := hC
  rw [wlBytes_eq, wlBytes_eq]
  simp only [reduceShufflevector, wlBlend, wl_zero, Vector.getElem_replicate, Bool.cond_true, Bool.cond_false, Ty.wrap_vec,
    Vector.map_mk, List.map_toArray, List.map_cons, List.map_nil, reduceGetElemLit, e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e24, e25, e26, e27, e28, e29, e30, e31]
  rfl

theorem runBodyFrom_byteBlendRun_0010 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c x : Reg Γ (.vec 32 8)} {s : Dst Γ (.vec 32 8)} {r : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {C : ⟦.vec 32 8⟧} {a : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = byteBlendRun_0010 c x s r ++ rest)
    (hc : E.read c = C) (hx : E ⊨ [x := wlBytes a])
    (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8 ∧ C[8] = .value 0#8 ∧ C[9] = .value 0#8 ∧ C[10] = .value 0#8 ∧ C[11] = .value 0#8 ∧ C[12] = .value 0#8 ∧ C[13] = .value 0#8 ∧ C[14] = .value 0#8 ∧ C[15] = .value 0#8 ∧ C[24] = .value 0#8 ∧ C[25] = .value 0#8 ∧ C[26] = .value 0#8 ∧ C[27] = .value 0#8 ∧ C[28] = .value 0#8 ∧ C[29] = .value 0#8 ∧ C[30] = .value 0#8 ∧ C[31] = .value 0#8)
    (hK :
      ∀ v : ⟦.vec 32 8⟧,
        (blk.runBodyFrom E[s := v, r := Ty.wrap (wlBlend false false true false a wl_zero)] (pos + 2) S >>= g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hb : blk.body.drop pos = _ :: _ :: rest := hbody
  have hb1 := List.drop_succ_of_drop_eq_cons hb
  rw [BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb)
      (by rw [List.getElem_of_drop_eq_cons hb]; rfl),
    BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb1)
      (by rw [List.getElem_of_drop_eq_cons hb1]; rfl)]
  simp only [Env.read_write_dst, BinOp.compute, UnOp.compute, hc, hx,
    shufflevector_byteBlend_0010 a hC, bitcast_wrap_wlBytes]
  exact hK _

/-- `byteBlendRun_0010` per limb: `Quad5.laneIf 0 0 1 0 A quad5_zero` into `r0 … r4`. -/
def byteBlendQuadRun_0010 (c x0 x1 x2 x3 x4 : Reg Γ (.vec 32 8)) (s0 s1 s2 s3 s4 : Dst Γ (.vec 32 8))
    (r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  byteBlendRun_0010 c x0 s0 r0 ++ byteBlendRun_0010 c x1 s1 r1 ++ byteBlendRun_0010 c x2 s2 r2 ++
    byteBlendRun_0010 c x3 s3 r3 ++ byteBlendRun_0010 c x4 s4 r4

theorem runBodyFrom_byteBlendQuadRun_0010 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c x0 x1 x2 x3 x4 : Reg Γ (.vec 32 8)} {s0 s1 s2 s3 s4 : Dst Γ (.vec 32 8)}
    {r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)} {rest : List (Instr Γ)} {C : ⟦.vec 32 8⟧} {A : Quad5}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = byteBlendQuadRun_0010 c x0 x1 x2 x3 x4 s0 s1 s2 s3 s4 r0 r1 r2 r3 r4 ++ rest)
    (hc : E.read c = C)
    (hx :
      E ⊨ [x0 := wlBytes A.P0, x1 := wlBytes A.P1, x2 := wlBytes A.P2, x3 := wlBytes A.P3,
        x4 := wlBytes A.P4])
    (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8 ∧ C[8] = .value 0#8 ∧ C[9] = .value 0#8 ∧ C[10] = .value 0#8 ∧ C[11] = .value 0#8 ∧ C[12] = .value 0#8 ∧ C[13] = .value 0#8 ∧ C[14] = .value 0#8 ∧ C[15] = .value 0#8 ∧ C[24] = .value 0#8 ∧ C[25] = .value 0#8 ∧ C[26] = .value 0#8 ∧ C[27] = .value 0#8 ∧ C[28] = .value 0#8 ∧ C[29] = .value 0#8 ∧ C[30] = .value 0#8 ∧ C[31] = .value 0#8)
    (hd : [c, x1, x2, x3, x4, .val s0.i s0.h, .val s1.i s1.h, .val s2.i s2.h, .val s3.i s3.h].Nodup)
    (hK :
      ∀ Q : Quad5, Q = Quad5.laneIf 0 0 1 0 A quad5_zero →
        ∀ v0 v1 v2 v3 v4 : ⟦.vec 32 8⟧,
          (blk.runBodyFrom
                E[s0 := v0, r0 := Ty.wrap Q.P0, s1 := v1, r1 := Ty.wrap Q.P1, s2 := v2,
                  r2 := Ty.wrap Q.P2, s3 := v3, r3 := Ty.wrap Q.P3, s4 := v4, r4 := Ty.wrap Q.P4]
                (pos + 10) S >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern' using runBodyFrom_byteBlendRun_0010 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0010 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0010 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0010 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0010 (hC := hC)
  subst hE hS hvr0 hvr1 hvr2 hvr3 hvr4
  simpa only [Quad5.laneIf_P0, Quad5.laneIf_P1, Quad5.laneIf_P2, Quad5.laneIf_P3, Quad5.laneIf_P4,
    quad5_zero_P0, quad5_zero_P1, quad5_zero_P2, quad5_zero_P3, quad5_zero_P4, bne_one_zero,
    bne_zero_zero] using hK _ rfl _ _ _ _ _


/-- A lane blend on bytes as compiled: the bytes `c`, zero where lane `k`'s bit is `0`, shuffled with a
`wl_t`'s bytes `x` (lane `k` from `x` where its bit is `1`) into `s`, cast back into `r`. -/
def byteBlendRun_0111 (c x : Reg Γ (.vec 32 8)) (s : Dst Γ (.vec 32 8)) (r : Dst Γ (.vec 4 64)) :
    List (Instr Γ) :=
  [.binop (.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 40, some 41, some 42, some 43, some 44, some 45, some 46, some 47, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63] : Vector (Option (Fin (2 * 32))) 32)) s c x,
    .unop (.bitcast (by decide)) r (.val s.i s.h)]

/-- `byteBlendRun_0111`'s `shufflevector` on a `wl_t`'s bytes: the bytes of the blend with zero. -/
theorem shufflevector_byteBlend_0111 {C : ⟦.vec 32 8⟧} (a : Wl) (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8) :
    Operation.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 40, some 41, some 42, some 43, some 44, some 45, some 46, some 47, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63] : Vector (Option (Fin (2 * 32))) 32) C
        (Ty.wrap (t := .vec 32 8) (wlBytes a)) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wlBlend false true true true a wl_zero)) := by
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ := hC
  rw [wlBytes_eq, wlBytes_eq]
  simp only [reduceShufflevector, wlBlend, wl_zero, Vector.getElem_replicate, Bool.cond_true, Bool.cond_false, Ty.wrap_vec,
    Vector.map_mk, List.map_toArray, List.map_cons, List.map_nil, reduceGetElemLit, e0, e1, e2, e3, e4, e5, e6, e7]
  rfl

theorem runBodyFrom_byteBlendRun_0111 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c x : Reg Γ (.vec 32 8)} {s : Dst Γ (.vec 32 8)} {r : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {C : ⟦.vec 32 8⟧} {a : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = byteBlendRun_0111 c x s r ++ rest)
    (hc : E.read c = C) (hx : E ⊨ [x := wlBytes a])
    (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8)
    (hK :
      ∀ v : ⟦.vec 32 8⟧,
        (blk.runBodyFrom E[s := v, r := Ty.wrap (wlBlend false true true true a wl_zero)] (pos + 2) S >>= g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hb : blk.body.drop pos = _ :: _ :: rest := hbody
  have hb1 := List.drop_succ_of_drop_eq_cons hb
  rw [BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb)
      (by rw [List.getElem_of_drop_eq_cons hb]; rfl),
    BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb1)
      (by rw [List.getElem_of_drop_eq_cons hb1]; rfl)]
  simp only [Env.read_write_dst, BinOp.compute, UnOp.compute, hc, hx,
    shufflevector_byteBlend_0111 a hC, bitcast_wrap_wlBytes]
  exact hK _

/-- `byteBlendRun_0111` per limb: `Quad5.laneIf 0 1 1 1 A quad5_zero` into `r0 … r4`. -/
def byteBlendQuadRun_0111 (c x0 x1 x2 x3 x4 : Reg Γ (.vec 32 8)) (s0 s1 s2 s3 s4 : Dst Γ (.vec 32 8))
    (r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  byteBlendRun_0111 c x0 s0 r0 ++ byteBlendRun_0111 c x1 s1 r1 ++ byteBlendRun_0111 c x2 s2 r2 ++
    byteBlendRun_0111 c x3 s3 r3 ++ byteBlendRun_0111 c x4 s4 r4

theorem runBodyFrom_byteBlendQuadRun_0111 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c x0 x1 x2 x3 x4 : Reg Γ (.vec 32 8)} {s0 s1 s2 s3 s4 : Dst Γ (.vec 32 8)}
    {r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)} {rest : List (Instr Γ)} {C : ⟦.vec 32 8⟧} {A : Quad5}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = byteBlendQuadRun_0111 c x0 x1 x2 x3 x4 s0 s1 s2 s3 s4 r0 r1 r2 r3 r4 ++ rest)
    (hc : E.read c = C)
    (hx :
      E ⊨ [x0 := wlBytes A.P0, x1 := wlBytes A.P1, x2 := wlBytes A.P2, x3 := wlBytes A.P3,
        x4 := wlBytes A.P4])
    (hC : C[0] = .value 0#8 ∧ C[1] = .value 0#8 ∧ C[2] = .value 0#8 ∧ C[3] = .value 0#8 ∧ C[4] = .value 0#8 ∧ C[5] = .value 0#8 ∧ C[6] = .value 0#8 ∧ C[7] = .value 0#8)
    (hd : [c, x1, x2, x3, x4, .val s0.i s0.h, .val s1.i s1.h, .val s2.i s2.h, .val s3.i s3.h].Nodup)
    (hK :
      ∀ Q : Quad5, Q = Quad5.laneIf 0 1 1 1 A quad5_zero →
        ∀ v0 v1 v2 v3 v4 : ⟦.vec 32 8⟧,
          (blk.runBodyFrom
                E[s0 := v0, r0 := Ty.wrap Q.P0, s1 := v1, r1 := Ty.wrap Q.P1, s2 := v2,
                  r2 := Ty.wrap Q.P2, s3 := v3, r3 := Ty.wrap Q.P3, s4 := v4, r4 := Ty.wrap Q.P4]
                (pos + 10) S >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern' using runBodyFrom_byteBlendRun_0111 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0111 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0111 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0111 (hC := hC)
  step_pattern' using runBodyFrom_byteBlendRun_0111 (hC := hC)
  subst hE hS hvr0 hvr1 hvr2 hvr3 hvr4
  simpa only [Quad5.laneIf_P0, Quad5.laneIf_P1, Quad5.laneIf_P2, Quad5.laneIf_P3, Quad5.laneIf_P4,
    quad5_zero_P0, quad5_zero_P1, quad5_zero_P2, quad5_zero_P3, quad5_zero_P4, bne_one_zero,
    bne_zero_zero] using hK _ rfl _ _ _ _ _


/-- A lane blend against a constant `c` whose lanes `k` with bit `0` are zero, as compiled: one
`shufflevector` of `x` and `c` into `r`. -/
def zeroBlendRun_1001 (x c : Reg Γ (.vec 4 64)) (r : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.binop (.shufflevector (#v[some 0, some 5, some 6, some 3] : Vector (Option (Fin (2 * 4))) 4)) r x c]

theorem runBodyFrom_zeroBlendRun_1001 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x c : Reg Γ (.vec 4 64)} {r : Dst Γ (.vec 4 64)} {rest : List (Instr Γ)} {C : ⟦.vec 4 64⟧}
    {a : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = zeroBlendRun_1001 x c r ++ rest) (hc : E.read c = C)
    (hx : E ⊨ [x := a]) (hC : C[1] = .value 0#64 ∧ C[2] = .value 0#64)
    (hK : (blk.runBodyFrom E[r := Ty.wrap (wlBlend true false false true a wl_zero)] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨e1, e2⟩ := hC
  step_pure [e1, e2]
  rw [hE]
  convert hK using 4
  simp only [Ty.wrap_vec, wlBlend, wl_zero]
  rfl

/-- `zeroBlendRun_1001` per limb: `Quad5.laneIf 1 0 0 1 A quad5_zero` into `r0 … r4`. -/
def zeroBlendQuadRun_1001 (x0 x1 x2 x3 x4 c : Reg Γ (.vec 4 64)) (r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)) :
    List (Instr Γ) :=
  zeroBlendRun_1001 x0 c r0 ++ zeroBlendRun_1001 x1 c r1 ++ zeroBlendRun_1001 x2 c r2 ++
    zeroBlendRun_1001 x3 c r3 ++ zeroBlendRun_1001 x4 c r4

theorem runBodyFrom_zeroBlendQuadRun_1001 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 x2 x3 x4 c : Reg Γ (.vec 4 64)} {r0 r1 r2 r3 r4 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {C : ⟦.vec 4 64⟧} {A : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = zeroBlendQuadRun_1001 x0 x1 x2 x3 x4 c r0 r1 r2 r3 r4 ++ rest)
    (hc : E.read c = C)
    (hx : E ⊨ [x0 := A.P0, x1 := A.P1, x2 := A.P2, x3 := A.P3, x4 := A.P4])
    (hC : C[1] = .value 0#64 ∧ C[2] = .value 0#64)
    (hd : [c, x1, x2, x3, x4, .val r0.i r0.h, .val r1.i r1.h, .val r2.i r2.h, .val r3.i r3.h].Nodup)
    (hK :
      ∀ Q : Quad5, Q = Quad5.laneIf 1 0 0 1 A quad5_zero →
        (blk.runBodyFrom
              E[r0 := Ty.wrap Q.P0, r1 := Ty.wrap Q.P1, r2 := Ty.wrap Q.P2, r3 := Ty.wrap Q.P3,
                r4 := Ty.wrap Q.P4]
              (pos + 5) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern' using runBodyFrom_zeroBlendRun_1001 (hC := hC)
  step_pattern' using runBodyFrom_zeroBlendRun_1001 (hC := hC)
  step_pattern' using runBodyFrom_zeroBlendRun_1001 (hC := hC)
  step_pattern' using runBodyFrom_zeroBlendRun_1001 (hC := hC)
  step_pattern' using runBodyFrom_zeroBlendRun_1001 (hC := hC)
  subst hE hS hvr0 hvr1 hvr2 hvr3 hvr4
  simpa only [Quad5.laneIf_P0, Quad5.laneIf_P1, Quad5.laneIf_P2, Quad5.laneIf_P3, Quad5.laneIf_P4,
    quad5_zero_P0, quad5_zero_P1, quad5_zero_P2, quad5_zero_P3, quad5_zero_P4, bne_one_zero,
    bne_zero_zero] using hK _ rfl

/-- A full `insertelement` chain on a `<4 x i64>`: lane `k` of the vector before set to `xk` at
index `ik`, into `dk`. -/
def insertRun_4_64 (v : Reg Γ (.vec 4 64)) (x0 x1 x2 x3 : Reg Γ (.bv 64))
    (i0 i1 i2 i3 : Reg Γ (.bv 32)) (d0 d1 d2 d3 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.ternop .insertelement d0 v x0 i0,
    .ternop .insertelement d1 (.val d0.i d0.h) x1 i1,
    .ternop .insertelement d2 (.val d1.i d1.h) x2 i2,
    .ternop .insertelement d3 (.val d2.i d2.h) x3 i3]

theorem set_chain_4 {α : Type} (V : Vector α 4) (a0 a1 a2 a3 : α) :
    ((((V.set 0 a0 (by omega)).set 1 a1 (by omega)).set 2 a2 (by omega)).set 3 a3 (by omega)) = #v[a0, a1, a2, a3] := by
  ext i hi
  simp only [Vector.getElem_set]
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | _ + 4, h => exact absurd h (by omega)

/-- Where the body at `pos` is `insertRun_4_64`, `i0 … i3` hold `0 … 3` and `xk` holds `ak`:
running on from `pos` then `g` gives `K` if it does from `pos + 4` with the vector of the `ak` in
`d3`. -/
theorem runBodyFrom_insertRun_4_64 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {v : Reg Γ (.vec 4 64)} {x0 x1 x2 x3 : Reg Γ (.bv 64)}
    {i0 i1 i2 i3 : Reg Γ (.bv 32)} {d0 d1 d2 d3 : Dst Γ (.vec 4 64)}
    {rest : List (Instr Γ)} {a0 a1 a2 a3 : ⟦.bv 64⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = insertRun_4_64 v x0 x1 x2 x3 i0 i1 i2 i3 d0 d1 d2 d3 ++ rest)
    (hR :
      E ⊨ [i0 := (0#32 : BitVec 32),
        i1 := (1#32 : BitVec 32),
        i2 := (2#32 : BitVec 32),
        i3 := (3#32 : BitVec 32),
        x0 := a0,
        x1 := a1,
        x2 := a2,
        x3 := a3])
    (hK :
      ∀ v0 v1 v2 : ⟦.vec 4 64⟧,
        (blk.runBodyFrom
              E[d0 := v0,
                d1 := v1,
                d2 := v2,
                d3 := (#v[a0, a1, a2, a3] : ⟦.vec 4 64⟧)]
              (pos + 4) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hb : blk.body.drop pos = _ :: _ := hbody
  refine runBodyFrom_insertelement_at (a := a0) 0 (by decide) hb rfl
    hR.2.2.2.2.1
    hR.1 (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a1) 1 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a2) 2 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a3) 3 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.1]) (by decide) fun hb => ?_
  rw [set_chain_4]
  exact hK _ _ _

/-- A full `insertelement` chain on a `<8 x i32>`: lane `k` of the vector before set to `xk` at
index `ik`, into `dk`. -/
def insertRun_8_32 (v : Reg Γ (.vec 8 32)) (x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 32))
    (i0 i1 i2 i3 i4 i5 i6 i7 : Reg Γ (.bv 32)) (d0 d1 d2 d3 d4 d5 d6 d7 : Dst Γ (.vec 8 32)) : List (Instr Γ) :=
  [.ternop .insertelement d0 v x0 i0,
    .ternop .insertelement d1 (.val d0.i d0.h) x1 i1,
    .ternop .insertelement d2 (.val d1.i d1.h) x2 i2,
    .ternop .insertelement d3 (.val d2.i d2.h) x3 i3,
    .ternop .insertelement d4 (.val d3.i d3.h) x4 i4,
    .ternop .insertelement d5 (.val d4.i d4.h) x5 i5,
    .ternop .insertelement d6 (.val d5.i d5.h) x6 i6,
    .ternop .insertelement d7 (.val d6.i d6.h) x7 i7]

theorem set_chain_8 {α : Type} (V : Vector α 8) (a0 a1 a2 a3 a4 a5 a6 a7 : α) :
    ((((((((V.set 0 a0 (by omega)).set 1 a1 (by omega)).set 2 a2 (by omega)).set 3 a3 (by omega)).set 4 a4 (by omega)).set 5 a5 (by omega)).set 6 a6 (by omega)).set 7 a7 (by omega)) = #v[a0, a1, a2, a3, a4, a5, a6, a7] := by
  ext i hi
  simp only [Vector.getElem_set]
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl
  | _ + 8, h => exact absurd h (by omega)

/-- Where the body at `pos` is `insertRun_8_32`, `i0 … i7` hold `0 … 7` and `xk` holds `ak`:
running on from `pos` then `g` gives `K` if it does from `pos + 8` with the vector of the `ak` in
`d7`. -/
theorem runBodyFrom_insertRun_8_32 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {v : Reg Γ (.vec 8 32)} {x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 32)}
    {i0 i1 i2 i3 i4 i5 i6 i7 : Reg Γ (.bv 32)} {d0 d1 d2 d3 d4 d5 d6 d7 : Dst Γ (.vec 8 32)}
    {rest : List (Instr Γ)} {a0 a1 a2 a3 a4 a5 a6 a7 : ⟦.bv 32⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = insertRun_8_32 v x0 x1 x2 x3 x4 x5 x6 x7 i0 i1 i2 i3 i4 i5 i6 i7 d0 d1 d2 d3 d4 d5 d6 d7 ++ rest)
    (hR :
      E ⊨ [i0 := (0#32 : BitVec 32),
        i1 := (1#32 : BitVec 32),
        i2 := (2#32 : BitVec 32),
        i3 := (3#32 : BitVec 32),
        i4 := (4#32 : BitVec 32),
        i5 := (5#32 : BitVec 32),
        i6 := (6#32 : BitVec 32),
        i7 := (7#32 : BitVec 32),
        x0 := a0,
        x1 := a1,
        x2 := a2,
        x3 := a3,
        x4 := a4,
        x5 := a5,
        x6 := a6,
        x7 := a7])
    (hK :
      ∀ v0 v1 v2 v3 v4 v5 v6 : ⟦.vec 8 32⟧,
        (blk.runBodyFrom
              E[d0 := v0,
                d1 := v1,
                d2 := v2,
                d3 := v3,
                d4 := v4,
                d5 := v5,
                d6 := v6,
                d7 := (#v[a0, a1, a2, a3, a4, a5, a6, a7] : ⟦.vec 8 32⟧)]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hb : blk.body.drop pos = _ :: _ := hbody
  refine runBodyFrom_insertelement_at (a := a0) 0 (by decide) hb rfl
    hR.2.2.2.2.2.2.2.2.1
    hR.1 (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a1) 1 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a2) 2 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a3) 3 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a4) 4 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a5) 5 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a6) 6 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a7) 7 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  rw [set_chain_8]
  exact hK _ _ _ _ _ _ _

/-- A full `insertelement` chain on a `<32 x i8>`: lane `k` of the vector before set to `xk` at
index `ik`, into `dk`. -/
def insertRun_32_8 (v : Reg Γ (.vec 32 8)) (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 : Reg Γ (.bv 8))
    (i0 i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i16 i17 i18 i19 i20 i21 i22 i23 i24 i25 i26 i27 i28 i29 i30 i31 : Reg Γ (.bv 32)) (d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30 d31 : Dst Γ (.vec 32 8)) : List (Instr Γ) :=
  [.ternop .insertelement d0 v x0 i0,
    .ternop .insertelement d1 (.val d0.i d0.h) x1 i1,
    .ternop .insertelement d2 (.val d1.i d1.h) x2 i2,
    .ternop .insertelement d3 (.val d2.i d2.h) x3 i3,
    .ternop .insertelement d4 (.val d3.i d3.h) x4 i4,
    .ternop .insertelement d5 (.val d4.i d4.h) x5 i5,
    .ternop .insertelement d6 (.val d5.i d5.h) x6 i6,
    .ternop .insertelement d7 (.val d6.i d6.h) x7 i7,
    .ternop .insertelement d8 (.val d7.i d7.h) x8 i8,
    .ternop .insertelement d9 (.val d8.i d8.h) x9 i9,
    .ternop .insertelement d10 (.val d9.i d9.h) x10 i10,
    .ternop .insertelement d11 (.val d10.i d10.h) x11 i11,
    .ternop .insertelement d12 (.val d11.i d11.h) x12 i12,
    .ternop .insertelement d13 (.val d12.i d12.h) x13 i13,
    .ternop .insertelement d14 (.val d13.i d13.h) x14 i14,
    .ternop .insertelement d15 (.val d14.i d14.h) x15 i15,
    .ternop .insertelement d16 (.val d15.i d15.h) x16 i16,
    .ternop .insertelement d17 (.val d16.i d16.h) x17 i17,
    .ternop .insertelement d18 (.val d17.i d17.h) x18 i18,
    .ternop .insertelement d19 (.val d18.i d18.h) x19 i19,
    .ternop .insertelement d20 (.val d19.i d19.h) x20 i20,
    .ternop .insertelement d21 (.val d20.i d20.h) x21 i21,
    .ternop .insertelement d22 (.val d21.i d21.h) x22 i22,
    .ternop .insertelement d23 (.val d22.i d22.h) x23 i23,
    .ternop .insertelement d24 (.val d23.i d23.h) x24 i24,
    .ternop .insertelement d25 (.val d24.i d24.h) x25 i25,
    .ternop .insertelement d26 (.val d25.i d25.h) x26 i26,
    .ternop .insertelement d27 (.val d26.i d26.h) x27 i27,
    .ternop .insertelement d28 (.val d27.i d27.h) x28 i28,
    .ternop .insertelement d29 (.val d28.i d28.h) x29 i29,
    .ternop .insertelement d30 (.val d29.i d29.h) x30 i30,
    .ternop .insertelement d31 (.val d30.i d30.h) x31 i31]

theorem set_chain_32 {α : Type} (V : Vector α 32) (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30 a31 : α) :
    ((((((((((((((((((((((((((((((((V.set 0 a0 (by omega)).set 1 a1 (by omega)).set 2 a2 (by omega)).set 3 a3 (by omega)).set 4 a4 (by omega)).set 5 a5 (by omega)).set 6 a6 (by omega)).set 7 a7 (by omega)).set 8 a8 (by omega)).set 9 a9 (by omega)).set 10 a10 (by omega)).set 11 a11 (by omega)).set 12 a12 (by omega)).set 13 a13 (by omega)).set 14 a14 (by omega)).set 15 a15 (by omega)).set 16 a16 (by omega)).set 17 a17 (by omega)).set 18 a18 (by omega)).set 19 a19 (by omega)).set 20 a20 (by omega)).set 21 a21 (by omega)).set 22 a22 (by omega)).set 23 a23 (by omega)).set 24 a24 (by omega)).set 25 a25 (by omega)).set 26 a26 (by omega)).set 27 a27 (by omega)).set 28 a28 (by omega)).set 29 a29 (by omega)).set 30 a30 (by omega)).set 31 a31 (by omega)) = #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31] := by
  ext i hi
  simp only [Vector.getElem_set]
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl
  | 8, _ => rfl
  | 9, _ => rfl
  | 10, _ => rfl
  | 11, _ => rfl
  | 12, _ => rfl
  | 13, _ => rfl
  | 14, _ => rfl
  | 15, _ => rfl
  | 16, _ => rfl
  | 17, _ => rfl
  | 18, _ => rfl
  | 19, _ => rfl
  | 20, _ => rfl
  | 21, _ => rfl
  | 22, _ => rfl
  | 23, _ => rfl
  | 24, _ => rfl
  | 25, _ => rfl
  | 26, _ => rfl
  | 27, _ => rfl
  | 28, _ => rfl
  | 29, _ => rfl
  | 30, _ => rfl
  | 31, _ => rfl
  | _ + 32, h => exact absurd h (by omega)

/-- Where the body at `pos` is `insertRun_32_8`, `i0 … i31` hold `0 … 31` and `xk` holds `ak`:
running on from `pos` then `g` gives `K` if it does from `pos + 32` with the vector of the `ak` in
`d31`. -/
theorem runBodyFrom_insertRun_32_8 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {v : Reg Γ (.vec 32 8)} {x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 : Reg Γ (.bv 8)}
    {i0 i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i16 i17 i18 i19 i20 i21 i22 i23 i24 i25 i26 i27 i28 i29 i30 i31 : Reg Γ (.bv 32)} {d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30 d31 : Dst Γ (.vec 32 8)}
    {rest : List (Instr Γ)} {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30 a31 : ⟦.bv 8⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = insertRun_32_8 v x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 i0 i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i16 i17 i18 i19 i20 i21 i22 i23 i24 i25 i26 i27 i28 i29 i30 i31 d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30 d31 ++ rest)
    (hR :
      E ⊨ [i0 := (0#32 : BitVec 32),
        i1 := (1#32 : BitVec 32),
        i2 := (2#32 : BitVec 32),
        i3 := (3#32 : BitVec 32),
        i4 := (4#32 : BitVec 32),
        i5 := (5#32 : BitVec 32),
        i6 := (6#32 : BitVec 32),
        i7 := (7#32 : BitVec 32),
        i8 := (8#32 : BitVec 32),
        i9 := (9#32 : BitVec 32),
        i10 := (10#32 : BitVec 32),
        i11 := (11#32 : BitVec 32),
        i12 := (12#32 : BitVec 32),
        i13 := (13#32 : BitVec 32),
        i14 := (14#32 : BitVec 32),
        i15 := (15#32 : BitVec 32),
        i16 := (16#32 : BitVec 32),
        i17 := (17#32 : BitVec 32),
        i18 := (18#32 : BitVec 32),
        i19 := (19#32 : BitVec 32),
        i20 := (20#32 : BitVec 32),
        i21 := (21#32 : BitVec 32),
        i22 := (22#32 : BitVec 32),
        i23 := (23#32 : BitVec 32),
        i24 := (24#32 : BitVec 32),
        i25 := (25#32 : BitVec 32),
        i26 := (26#32 : BitVec 32),
        i27 := (27#32 : BitVec 32),
        i28 := (28#32 : BitVec 32),
        i29 := (29#32 : BitVec 32),
        i30 := (30#32 : BitVec 32),
        i31 := (31#32 : BitVec 32),
        x0 := a0,
        x1 := a1,
        x2 := a2,
        x3 := a3,
        x4 := a4,
        x5 := a5,
        x6 := a6,
        x7 := a7,
        x8 := a8,
        x9 := a9,
        x10 := a10,
        x11 := a11,
        x12 := a12,
        x13 := a13,
        x14 := a14,
        x15 := a15,
        x16 := a16,
        x17 := a17,
        x18 := a18,
        x19 := a19,
        x20 := a20,
        x21 := a21,
        x22 := a22,
        x23 := a23,
        x24 := a24,
        x25 := a25,
        x26 := a26,
        x27 := a27,
        x28 := a28,
        x29 := a29,
        x30 := a30,
        x31 := a31])
    (hK :
      ∀ v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 : ⟦.vec 32 8⟧,
        (blk.runBodyFrom
              E[d0 := v0,
                d1 := v1,
                d2 := v2,
                d3 := v3,
                d4 := v4,
                d5 := v5,
                d6 := v6,
                d7 := v7,
                d8 := v8,
                d9 := v9,
                d10 := v10,
                d11 := v11,
                d12 := v12,
                d13 := v13,
                d14 := v14,
                d15 := v15,
                d16 := v16,
                d17 := v17,
                d18 := v18,
                d19 := v19,
                d20 := v20,
                d21 := v21,
                d22 := v22,
                d23 := v23,
                d24 := v24,
                d25 := v25,
                d26 := v26,
                d27 := v27,
                d28 := v28,
                d29 := v29,
                d30 := v30,
                d31 := (#v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31] : ⟦.vec 32 8⟧)]
              (pos + 32) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hb : blk.body.drop pos = _ :: _ := hbody
  refine runBodyFrom_insertelement_at (a := a0) 0 (by decide) hb rfl
    hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
    hR.1 (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a1) 1 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a2) 2 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a3) 3 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a4) 4 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a5) 5 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a6) 6 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a7) 7 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a8) 8 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a9) 9 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a10) 10 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a11) 11 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a12) 12 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a13) 13 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a14) 14 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a15) 15 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a16) 16 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a17) 17 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a18) 18 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a19) 19 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a20) 20 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a21) 21 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a22) 22 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a23) 23 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a24) 24 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a25) 25 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a26) 26 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a27) 27 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a28) 28 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a29) 29 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a30) 30 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  refine runBodyFrom_insertelement_at (a := a31) 31 (by decide) hb (Env.read_write_dst _ _ _)
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2])
    (by simp only [read_write_vec_of_bv, hR.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1]) (by decide) fun hb => ?_
  rw [set_chain_32]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- A QUAD's five stores: `qk` to `pk`. -/
def storeRun (q0 q1 q2 q3 q4 : Reg Γ (.vec 4 64)) (p0 p1 p2 p3 p4 : Reg Γ .ptr) : List (Instr Γ) :=
  [.store p0 q0, .store p1 q1, .store p2 q2, .store p3 q3, .store p4 q4]

/-- Where the body at `pos` is `storeRun`, `q0 … q4` hold `Q` and `p0 … p4` point to room for a
`wl_t` each: running on from `pos` then `g` gives `K` if it does from `pos + 5` with `Q` stored
there (`storeTmp5`). -/
theorem runBodyFrom_storeRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {q0 q1 q2 q3 q4 : Reg Γ (.vec 4 64)} {p0 p1 p2 p3 p4 : Reg Γ .ptr} {rest : List (Instr Γ)}
    {Q : Quad5} {P0 P1 P2 P3 P4 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = storeRun q0 q1 q2 q3 q4 p0 p1 p2 p3 p4 ++ rest)
    (hR :
      E ⊨ [q0 := Q.P0, q1 := Q.P1, q2 := Q.P2, q3 := Q.P3, q4 := Q.P4, p0 := P0, p1 := P1,
        p2 := P2, p3 := P3, p4 := P4])
    (hP :
      Room S.mem P0 256 ∧ Room S.mem P1 256 ∧ Room S.mem P2 256 ∧ Room S.mem P3 256 ∧
        Room S.mem P4 256)
    (hK :
      (blk.runBodyFrom E (pos + 5)
            { alloc := S.alloc, mem := S.mem.storeTmp5 P0 P1 P2 P3 P4 Q } >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hp0, hp1, hp2, hp3, hp4⟩ := hP
  have e : S.mem.storeTmp5 P0 P1 P2 P3 P4 Q =
      ((((S.mem.storeAt P0 (BitVec.packLanes Q.P0)).storeAt P1 (BitVec.packLanes Q.P1)).storeAt P2
        (BitVec.packLanes Q.P2)).storeAt P3 (BitVec.packLanes Q.P3)).storeAt P4
        (BitVec.packLanes Q.P4) := rfl
  rw [e] at hK
  iterate 5 step_store
  rw [hS]
  exact hK

/-- The point at `p` loaded into `x0 … x4`, through `g1 … g4` (`p + 32`, …, `p + 128`). -/
def quad5LoadRun (p : Reg Γ .ptr) (x0 x1 x2 x3 x4 : Dst Γ (.vec 4 64)) (g1 g2 g3 g4 : Dst Γ .ptr) :
    List (Instr Γ) :=
  [.load x0 p, .unop (.gepConst { nusw := true, nuw := true } 32) g1 p, .load x1 (.val g1.i g1.h),
    .unop (.gepConst { nusw := true, nuw := true } 64) g2 p, .load x2 (.val g2.i g2.h),
    .unop (.gepConst { nusw := true, nuw := true } 96) g3 p, .load x3 (.val g3.i g3.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g4 p, .load x4 (.val g4.i g4.h)]

/-- Where the body at `pos` is `quad5LoadRun` and `p` holds the point `P`: running on from `pos`
then `g` gives `K` if it does from `pos + 9` with `S.mem.readQuad5 P` in `x0 … x4`. -/
theorem runBodyFrom_quad5LoadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p : Reg Γ .ptr} {x0 x1 x2 x3 x4 : Dst Γ (.vec 4 64)} {g1 g2 g3 g4 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = quad5LoadRun p x0 x1 x2 x3 x4 g1 g2 g3 g4 ++ rest)
    (hp : E.read p = .value P) (hP : S.mem.Quad5Fit P)
    (hpg : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hK :
      ∀ Q : Quad5, Q = S.mem.readQuad5 P →
        (blk.runBodyFrom
              E[x0 := Ty.wrap Q.P0, g1 := .value (P.add 32#64), x1 := Ty.wrap Q.P1,
                g2 := .value (P.add 64#64), x2 := Ty.wrap Q.P2, g3 := .value (P.add 96#64),
                x3 := Ty.wrap Q.P3, g4 := .value (P.add 128#64), x4 := Ty.wrap Q.P4]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hpg1, hpg2, hpg3⟩ := hpg
  obtain ⟨hw, h0, h1, h2, h3, h4⟩ := hP
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  subst hE hS
  have := hK _ rfl
  simp only [MemoryState.readQuad5] at this
  exact this

@[mlir_transport]
theorem SlotFrame.storeQuad5 {B : GlobalState} {m : MemoryState} (h : SlotFrame B n m) :
    SlotFrame B n (m.storeQuad5 p Q) :=
  h.storeTmp5

/-- A QUAD stored as a point at `p`: `qk` to `p + 32 k` (`gk` the offsets). -/
def storeQuad5Run (p : Reg Γ .ptr) (q0 q1 q2 q3 q4 : Reg Γ (.vec 4 64))
    (g1 g2 g3 g4 : Dst Γ .ptr) : List (Instr Γ) :=
  [.store p q0,
    .unop (.gepConst { nusw := true, nuw := true } 32) g1 p, .store (.val g1.i g1.h) q1,
    .unop (.gepConst { nusw := true, nuw := true } 64) g2 p, .store (.val g2.i g2.h) q2,
    .unop (.gepConst { nusw := true, nuw := true } 96) g3 p, .store (.val g3.i g3.h) q3,
    .unop (.gepConst { nusw := true, nuw := true } 128) g4 p, .store (.val g4.i g4.h) q4]

/-- Where the body at `pos` is `storeQuad5Run`, `qk` hold `Q` and `p` a point with room: running
on from `pos` then `g` gives `K` if it does from `pos + 9` with `Q` stored at `P`. -/
theorem runBodyFrom_storeQuad5Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p : Reg Γ .ptr} {q0 q1 q2 q3 q4 : Reg Γ (.vec 4 64)} {g1 g2 g3 g4 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {Q : Quad5} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = storeQuad5Run p q0 q1 q2 q3 q4 g1 g2 g3 g4 ++ rest)
    (hR : E ⊨ [p := P, q0 := Q.P0, q1 := Q.P1, q2 := Q.P2, q3 := Q.P3, q4 := Q.P4])
    (hd : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hP : S.mem.Quad5Room P)
    (hK :
      (blk.runBodyFrom
            E[g1 := .value (P.add 32#64), g2 := .value (P.add 64#64), g3 := .value (P.add 96#64),
              g4 := .value (P.add 128#64)]
            (pos + 9) { alloc := S.alloc, mem := S.mem.storeQuad5 P Q } >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := hP
  obtain ⟨hp1, hp2, hp3⟩ := hd
  have o1 : ¬P.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow]; omega
  have o2 : ¬P.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow]; omega
  have o3 : ¬P.offset.uaddOverflow 96#64 := by simp [BitVec.uaddOverflow]; omega
  have o4 : ¬P.offset.uaddOverflow 128#64 := by simp [BitVec.uaddOverflow]; omega
  step_store
  step_pure [o1]
  step_store
  step_pure [o2]
  step_store
  step_pure [o3]
  step_store
  step_pure [o4]
  step_store
  rw [hE, hS]
  exact hK

/-- A point in a block below the counter is unaffected by `alloca`. -/
theorem MemoryState.readQuad5_alloca_lt {s : GlobalState} (h : p.id.id < s.alloc.nextFreeBlock) :
    (s.alloca n d).mem.readQuad5 p = s.mem.readQuad5 p :=
  MemoryState.readQuad5_alloca fun e => by simp [e, GlobalState.allocaPtr] at h

end Patterns

end

end MLIR.Firedancer.Crc.Verify

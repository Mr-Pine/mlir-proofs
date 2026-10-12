module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Zig.Common.Sha512
public import Zig.Sha512_round
public import Zig.Mlir.Sha512_update
import Std.Tactic.BVDecide

/-! `Sha512.update`: the state it leaves (`post`), and that the object then has absorbed the bytes
(`absorbed`). Its loop over whole blocks calls `Sha512.round` (`Sha512_round.call_eq`). -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Sha512_update

/-! ## Specification -/

@[expose] public section

/-- The state after `Sha512.round` on the block at `p`, as its `call_eq` gives it. -/
def roundState (s : GlobalState) (d p : Pointer) : GlobalState :=
  { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
    mem :=
      Sha512Obj.setState s.mem d
        (Sha512.compress (Sha512Obj.state s.mem d) (bytesLE (s.mem.readAt p 1024))) }

/-- `c` rounds on the blocks at `b + off`, `b + off + 128`, …. -/
def blocksState (d b : Pointer) : (off c : Nat) → GlobalState → GlobalState
  | _, 0, s => s
  | off, c + 1, s => blocksState d b (off + 128) c (roundState s d (b.add (BitVec.ofNat 64 off)))

/-- `bb6`'s stores: the bytes left after offset `off` into `buf` at `buf_len`, the new `buf_len`,
`total_len + n`. -/
def tailMem (m : MemoryState) (d b : Pointer) (n : BitVec 64) (off : Nat) : MemoryState :=
  ((m.storeAt (d.add (80#64 + BitVec.setWidth 64 (Sha512Obj.bufLen m d)))
            (m.readAt (b.add (BitVec.ofNat 64 off))
              (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat))).storeAt
        (d.add 208#64) (Sha512Obj.bufLen m d + BitVec.ofNat 8 (n.toNat - off))).storeAt
    d (Sha512Obj.totalLen m d + BitVec.setWidth 128 n)

/-- `bb2`: the buffer filled from `b`, its block's round, `buf_len` zeroed. -/
def headState (s : GlobalState) (d b : Pointer) (bl : BitVec 8) : GlobalState :=
  let s1 :=
    roundState
      { s with
        mem :=
          s.mem.storeAt (d.add (80#64 + BitVec.setWidth 64 bl))
            (s.mem.readAt b (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat)) }
      d (d.add 80#64)
  { s1 with mem := s1.mem.storeAt (d.add 208#64) 0#8 }

/-- From `bb3` at offset `off`: the whole blocks' rounds, then `bb6`'s stores. -/
def fromState (s : GlobalState) (d b : Pointer) (n : BitVec 64) (off : Nat) : GlobalState :=
  let s2 := blocksState d b off ((n.toNat - off) / 128) s
  { s2 with mem := tailMem s2.mem d b n (off + 128 * ((n.toNat - off) / 128)) }

/-- The state `Sha512.update` leaves: a partial buffer filled and compressed first, if the bytes
reach a block; then the whole blocks of `b`; then the rest buffered and the counts updated. -/
def post (s : GlobalState) (d b : Pointer) (n : BitVec 64) : GlobalState :=
  let bl := Sha512Obj.bufLen s.mem d
  if bl ≠ 0 ∧ 127 < n.toNat + bl.toNat then fromState (headState s d b bl) d b n (128 - bl.toNat)
  else fromState s d b n 0

/-- `^bb3`'s env at offset `off`: `128`, `256`, `&buf_len`. -/
abbrev env3 (d : Pointer) (off : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3896 := .value 128#64, %3897 := .value 256#64, %3898 := .value (d.add 208#64), %3908 :=
    .value (BitVec.ofNat 64 off)]

/-- `^bb4`'s env at offset `off`: `128`, `256`, `&buf_len`. -/
abbrev env4 (d : Pointer) (off : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3896 := .value 128#64, %3897 := .value 256#64, %3898 := .value (d.add 208#64), %3909 :=
    .value (BitVec.ofNat 64 off)]

/-- `^bb6`'s env at offset `off`: `256`, `&buf_len`, `b + off`. -/
abbrev env6 (d b : Pointer) (off : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3897 := .value 256#64, %3898 := .value (d.add 208#64), %3909 := .value (BitVec.ofNat 64 off),
    %3912 := .value (b.add (BitVec.ofNat 64 off))]

end

/-! ## The object through `Sha512.round` -/

/-- A read beside the state words is unaffected by storing them. -/
public theorem readAt_storeWords {m : MemoryState} {d q : Pointer} {f : Nat → BitVec 64} {w : Nat}
    (hdo : d.offset.toNat + 80 < 2 ^ 64)
    (h : (Range.of (d.add 16#64) 512).Disjoint (Range.of q w)) :
    ∀ n i, i + n ≤ 8 → (Sha512Obj.storeWords d f i n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; rfl
  | succ n ih =>
    intro i hi
    rw [Sha512Obj.storeWords, ih (i + 1) (by omega), MemoryState.readAt_storeAt_disjoint]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at h ⊢
    rcases h with h | h | h
    · exact Or.inl h
    · right; left; omega
    · right; right; omega

public theorem Fits.storeWords {m : MemoryState} {d : Pointer} {f : Nat → BitVec 64}
    (h : Fits m p w) : ∀ n i, Fits (Sha512Obj.storeWords d f i n m) p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; exact h
  | succ n ih =>
    intro i; exact ih h.storeAt (i + 1)

public theorem inBounds_storeWords {m : MemoryState} {d : Pointer} {f : Nat → BitVec 64} :
    ∀ n i, InBounds (Sha512Obj.storeWords d f i n m) p w ↔ InBounds m p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; rfl
  | succ n ih =>
    intro i; rw [Sha512Obj.storeWords, ih]; simp

public theorem room_storeWords {m : MemoryState} {d : Pointer} {f : Nat → BitVec 64} :
    ∀ n i, Room (Sha512Obj.storeWords d f i n m) p w ↔ Room m p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; rfl
  | succ n ih =>
    intro i; rw [Sha512Obj.storeWords, ih]; simp

public theorem wf_storeWords {s : GlobalState} {d : Pointer} {f : Nat → BitVec 64} :
    ∀ n i (m : MemoryState),
      ({ s with mem := m } : GlobalState).WF →
        ({ s with mem := Sha512Obj.storeWords d f i n m } : GlobalState).WF := by
  intro n
  induction n with
  | zero =>
    intro _ _ h; exact h
  | succ n ih =>
    intro i m h; exact ih (i + 1) _ (GlobalState.WF_storeAt.2 h)

public theorem roundState_wf {s : GlobalState} (h : s.WF) : (roundState s d p).WF := by
  have h' :=
    wf_storeWords (s := s) (d := d) (f := fun i =>
      (Sha512.compress (Sha512Obj.state s.mem d) (bytesLE (s.mem.readAt p 1024)))[i]!) 8 0 s.mem h
  obtain ⟨hb, hp, hn⟩ := h'
  exact ⟨fun k hk => Nat.lt_of_lt_of_le (hb k hk) (by simp [roundState]), by simp [roundState], hn⟩

public theorem Fits.roundState {s : GlobalState} (h : Fits s.mem q w) :
    Fits (Sha512_update.roundState s d p).mem q w :=
  Fits.storeWords h 8 0

public theorem InBounds.roundState {s : GlobalState} (h : InBounds s.mem q w) :
    InBounds (Sha512_update.roundState s d p).mem q w :=
  (inBounds_storeWords 8 0).2 h

public theorem inBounds_roundState {s : GlobalState} :
    InBounds (roundState s d p).mem q w ↔ InBounds s.mem q w :=
  inBounds_storeWords 8 0

public theorem room_roundState {s : GlobalState} :
    Room (roundState s d p).mem q w ↔ Room s.mem q w :=
  room_storeWords 8 0

public theorem roundState_readAt {s : GlobalState} (hdo : d.offset.toNat + 80 < 2 ^ 64)
    (h : (Range.of (d.add 16#64) 512).Disjoint (Range.of q w)) :
    (roundState s d p).mem.readAt q w = s.mem.readAt q w :=
  readAt_storeWords hdo h 8 0 (by omega)

/-- `setState` keeps what is known. -/
public theorem Fits.setState {m : MemoryState} {d : Pointer} {v : Vector (BitVec 64) 8}
    (h : Fits m p w) : Fits (Sha512Obj.setState m d v) p w :=
  Fits.storeWords h 8 0

/-! ## Proof -/

/-- `bb4`, offset `off`: `bb6` past the last whole block, else the round on the block at `b + off`
and back. -/
theorem loop_iter (d b : Pointer) (n : BitVec 64) (off : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_update.args (.value d) (.value b) (.value n)).get)
    (hoffn : off ≤ n.toNat) (hn : n.toNat + 128 < 2 ^ 63) (hwf : S.WF) (hdf : Fits S.mem d 640)
    (hdo : d.offset.toNat + 80 < 2 ^ 64) (hbf : Fits S.mem b (8 * n.toNat))
    (hbo : b.offset.toNat + n.toNat < 2 ^ 64)
    (hexit :
      n.toNat < off + 128 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_update.args (.value d) (.value b) (.value n)).get →
            Sha512_update.runFrom (env6 d b off E') 6 S = R)
    (hback :
      off + 128 ≤ n.toNat →
        ∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_update.args (.value d) (.value b) (.value n)).get →
            Sha512_update.runFrom (env4 d (off + 128) E') 4
                (roundState S d (b.add (BitVec.ofNat 64 off))) =
              R) :
    Sha512_update.runFrom (env4 d off E) 4 S = R := by
  have ho : (BitVec.ofNat 64 off).uaddOverflow 128#64 = false := by
    simp [BitVec.uaddOverflow]; omega
  have h1 : off % 18446744073709551616 = off := by omega
  have h2 : off < 18446744073709551616 := by omega
  block_init
  step_pure [ho, ← BitVec.ofNat_add]
  step_pure
  step_pure [h1, h2]
  finish_block
  · step_loop using
      hexit
        (by
          simp [BitVec.ult] at hbr; omega)
  · have hoff : off + 128 ≤ n.toNat := by
      simp [BitVec.ult] at hbr
      omega
    have hfb : Fits S.mem (b.add (BitVec.ofNat 64 off)) 1024 :=
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hbf
    have hbo' : (b.add (BitVec.ofNat 64 off)).offset.toNat + 128 < 2 ^ 64 := by
      simp [Pointer.add, BitVec.toNat_add]; omega
    block_init
    step_call using Sha512_round.call_eq consuming hwf hdf hfb hbf
    finish_block
    step_loop using hback hoff

/-- `bb4`/`bb5` from offset `off`, `c` whole blocks left: their rounds, then `bb6`. -/
theorem loop (d b : Pointer) (n : BitVec 64) (R : PoisonOr (Vals [] × GlobalState))
    (hn : n.toNat + 128 < 2 ^ 63) (hdo : d.offset.toNat + 80 < 2 ^ 64)
    (hbo : b.offset.toNat + n.toNat < 2 ^ 64) :
    ∀ c off (S : GlobalState) (E : ⟪Γ⟫),
      n.toNat < off + 128 * (c + 1) →
        off + 128 * c ≤ n.toNat →
        E.args = (Sha512_update.args (.value d) (.value b) (.value n)).get →
        S.WF →
        Fits S.mem d 640 →
        Fits S.mem b (8 * n.toNat) →
        (∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_update.args (.value d) (.value b) (.value n)).get →
            Sha512_update.runFrom (env6 d b (off + 128 * c) E') 6 (blocksState d b off c S) = R) →
        Sha512_update.runFrom (env4 d off E) 4 S = R := by
  intro c
  induction c with
  | zero =>
    intro off S E h1 h2 hArgs hwf hdf hbf hK
    exact
      loop_iter d b n off S E R hArgs (by omega) hn hwf hdf hdo hbf hbo (fun _ E' g => hK E' g)
        (fun h => absurd h (by omega))
  | succ c ih =>
    intro off S E h1 h2 hArgs hwf hdf hbf hK
    refine
      loop_iter d b n off S E R hArgs (by omega) hn hwf hdf hdo hbf hbo
        (fun h => absurd h (by omega)) fun _ E' g => ?_
    refine
      ih (off + 128) _ E' (by omega) (by omega) g (roundState_wf hwf) (Fits.roundState hdf)
        (Fits.roundState hbf) fun E'' k => ?_
    rw [show off + 128 + 128 * c = off + 128 * (c + 1) by omega]
    exact hK E'' k

/-- `bb6` from offset `off`: the bytes left into the buffer, `buf_len` and `total_len` updated. -/
theorem tail (d b : Pointer) (n : BitVec 64) (off : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_update.args (.value d) (.value b) (.value n)).get)
    (hoffn : off ≤ n.toNat) (hoff : n.toNat < off + 128) (hn : n.toNat + 128 < 2 ^ 63) (hwf : S.WF)
    (hdr : Room S.mem d 1792) (hdf : Fits S.mem d 640) (hf208 : Fits S.mem (d.add 208#64) 8)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbf : Fits S.mem b (8 * n.toNat))
    (hbo : b.offset.toNat + n.toNat < 2 ^ 64) (bl : BitVec 8)
    (hbl : S.mem.readAt (d.add 208#64) 8 = bl) (hbl' : bl.toNat + (n.toNat - off) < 128)
    (T : BitVec 128) (hT : S.mem.readAt d 128 = T) (hT' : T.toNat + n.toNat < 2 ^ 128)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n.toNat)))
    (hfin : .value (.nil, { S with mem := tailMem S.mem d b n off }) = R) :
    Sha512_update.runFrom (env6 d b off E) 6 S = R := by
  rw [tailMem, Sha512Obj.bufLen, Sha512Obj.totalLen, hbl, hT] at hfin
  have hsub : n.usubOverflow (BitVec.ofNat 64 off) = false := by
    simp [BitVec.usubOverflow]; omega
  have hsub' : n - BitVec.ofNat 64 off = BitVec.ofNat 64 (n.toNat - off) := by
    apply BitVec.eq_of_toNat_eq; simp; omega
  have hblm : bl.toNat % 18446744073709551616 = bl.toNat := Nat.mod_eq_of_lt (by omega)
  have hblt : bl.toNat < 18446744073709551616 := by omega
  have hk : (BitVec.ofNat 64 (n.toNat - off)).toNat = n.toNat - off := by
    simp; omega
  have hdst :
    Room S.mem (d.add (80#64 + BitVec.setWidth 64 bl))
      (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) := by
    rw [hk];
    exact
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hdr
  have hsrc :
    Fits S.mem (b.add (BitVec.ofNat 64 off)) (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) := by
    rw [hk];
    exact
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hbf
  have hdis :
    (Range.of (d.add (80#64 + BitVec.setWidth 64 bl))
          (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat)).Disjoint
      (Range.of (b.add (BitVec.ofNat 64 off)) (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat)) := by
    rw [hk]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add] at hsep ⊢
    simp only [BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_ofNat] at hsep ⊢
    rcases hsep with h | h | h
    · exact Or.inl h
    · right; left; omega
    · right; right; omega
  have hdisB :
    (Range.of (d.add (80#64 + BitVec.setWidth 64 bl))
          (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat)).Disjoint
      (Range.of (d.add 208#64) 8) := by
    rw [hk]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; left; omega
  have hdisT :
    (Range.of (d.add (80#64 + BitVec.setWidth 64 bl))
          (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat)).Disjoint
      (Range.of d 128) := by
    rw [hk]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; right; omega
  have hult : (BitVec.ofNat 64 (n.toNat - off)).ult 256#64 = true := by
    simp [BitVec.ult]; omega
  have htr :
    BitVec.setWidth 64 (BitVec.ofNat 8 (n.toNat - off)) = BitVec.ofNat 64 (n.toNat - off) := by
    apply BitVec.eq_of_toNat_eq; simp; omega
  have hov8 : bl.uaddOverflow (BitVec.ofNat 8 (n.toNat - off)) = false := by
    simp [BitVec.uaddOverflow]; omega
  have hov128 : T.uaddOverflow (BitVec.setWidth 128 n) = false := by
    simp [BitVec.uaddOverflow]; omega
  block_init
  step_pure [hsub, hsub']
  step_pure
  step_load
  step_pure
  step_pure [hblm, hblt]
  step_memcpy consuming hdst hsrc hdis
  step_load
  step_pure [hult]
  step_assume
  step_pure [htr]
  step_pure [htr, hov8]
  step_store
  step_load
  step_pure
  step_pure [hov128]
  step_store
  finish_block
  subst hS
  exact hfin

theorem blocksState_wf {d b : Pointer} :
    ∀ c off (s : GlobalState), s.WF → (blocksState d b off c s).WF := by
  intro c
  induction c with
  | zero =>
    intro _ _ h; exact h
  | succ c ih =>
    intro off s h; exact ih _ _ (roundState_wf h)

theorem Fits.blocksState {d b : Pointer} :
    ∀ c off {s : GlobalState}, Fits s.mem q w → Fits (blocksState d b off c s).mem q w := by
  intro c
  induction c with
  | zero =>
    intro _ _ h; exact h
  | succ c ih =>
    intro off s h; exact ih _ (Fits.roundState h)

theorem room_blocksState {d b : Pointer} :
    ∀ c off (s : GlobalState), Room (blocksState d b off c s).mem q w ↔ Room s.mem q w := by
  intro c
  induction c with
  | zero =>
    intro _ _; rfl
  | succ c ih =>
    intro off s; rw [blocksState, ih]; exact room_roundState

theorem inBounds_blocksState {d b : Pointer} :
    ∀ c off (s : GlobalState), InBounds (blocksState d b off c s).mem q w ↔ InBounds s.mem q w := by
  intro c
  induction c with
  | zero =>
    intro _ _; rfl
  | succ c ih =>
    intro off s; rw [blocksState, ih]; exact inBounds_storeWords 8 0

theorem blocksState_readAt {d b : Pointer} (hdo : d.offset.toNat + 80 < 2 ^ 64)
    (h : (Range.of (d.add 16#64) 512).Disjoint (Range.of q w)) :
    ∀ c off (s : GlobalState), (blocksState d b off c s).mem.readAt q w = s.mem.readAt q w := by
  intro c
  induction c with
  | zero =>
    intro _ _; rfl
  | succ c ih =>
    intro off s; rw [blocksState, ih, roundState_readAt hdo h]

public theorem disjoint_bufLen {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    (Range.of (d.add 16#64) 512).Disjoint (Range.of (d.add 208#64) 8) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right; left; omega

public theorem disjoint_totalLen {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    (Range.of (d.add 16#64) 512).Disjoint (Range.of d 128) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right; right; omega

/-- `bb3` from offset `off`: the whole blocks from `b + off`, then `bb6`. -/
theorem fromBB3 (d b : Pointer) (n : BitVec 64) (off : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_update.args (.value d) (.value b) (.value n)).get)
    (hoffn : off ≤ n.toNat) (hn : n.toNat + 128 < 2 ^ 63) (hwf : S.WF) (hdr : Room S.mem d 1792)
    (hdf : Fits S.mem d 640) (hf208 : Fits S.mem (d.add 208#64) 8)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbf : Fits S.mem b (8 * n.toNat))
    (hbo : b.offset.toNat + n.toNat < 2 ^ 64)
    (hbl : (Sha512Obj.bufLen S.mem d).toNat + (n.toNat - off) % 128 < 128)
    (hT : (Sha512Obj.totalLen S.mem d).toNat + n.toNat < 2 ^ 128)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n.toNat)))
    (hfin : .value (.nil, fromState S d b n off) = R) :
    Sha512_update.runFrom (env3 d off E) 3 S = R := by
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  block_init
  finish_block
  step_loop using loop d b n R hn hdo' hbo ((n.toNat - off) / 128) off S
  have hA : E₀.args = (Sha512_update.args (.value d) (.value b) (.value n)).get := by
    rw [hE] at hArgs; simpa only [Env.write_args] using hArgs
  rw [hE, hS]
  refine
    tail d b n _ _ E₀ R hA (by omega) (by omega) hn (blocksState_wf _ _ _ hwf)
      ((room_blocksState _ _ _).2 hdr) (Fits.blocksState _ _ hdf) (Fits.blocksState _ _ hf208) hdo
      (Fits.blocksState _ _ hbf) hbo _ (blocksState_readAt hdo' (disjoint_bufLen hdo) _ _ _) ?_ _
      (blocksState_readAt hdo' (disjoint_totalLen hdo) _ _ _) ?_ hsep hfin
  · have := hbl; simp only [Sha512Obj.bufLen] at this; omega
  · have := hT; simp only [Sha512Obj.totalLen] at this; omega

/-! ### Blocks kept -/

/-- `m` and `m'` hold the same blocks. -/
@[expose]
public def SameBlocks (m m' : MemoryState) : Prop :=
  ∀ k, k ∈ m.mem ↔ k ∈ m'.mem

public theorem SameBlocks.storeAt {m m' : MemoryState} (h : SameBlocks m m') {p : Pointer}
    {x : BitVec w} : SameBlocks (m.storeAt p x) m' := fun k => MemoryState.mem_storeAt.trans (h k)

public theorem SameBlocks.storeWords {m m' : MemoryState} (h : SameBlocks m m') {d : Pointer}
    {f : Nat → BitVec 64} : ∀ n i, SameBlocks (Sha512Obj.storeWords d f i n m) m' := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; exact h
  | succ n ih =>
    intro i; exact ih h.storeAt (i + 1)

public theorem SameBlocks.roundState {s : GlobalState} {m' : MemoryState}
    (h : SameBlocks s.mem m') : SameBlocks (Sha512_update.roundState s d p).mem m' :=
  h.storeWords 8 0

public theorem SameBlocks.blocksState {m' : MemoryState} {d b : Pointer} :
    ∀ c off (s : GlobalState),
      SameBlocks s.mem m' → SameBlocks (Sha512_update.blocksState d b off c s).mem m' := by
  intro c
  induction c with
  | zero =>
    intro _ _ h; exact h
  | succ c ih =>
    intro off s h; exact ih _ _ h.roundState

public theorem SameBlocks.fromState {s : GlobalState} {m' : MemoryState} (h : SameBlocks s.mem m') :
    SameBlocks (Sha512_update.fromState s d b n off).mem m' :=
  (SameBlocks.blocksState _ _ _ h).storeAt.storeAt.storeAt

public theorem SameBlocks.headState {s : GlobalState} {m' : MemoryState} (h : SameBlocks s.mem m') :
    SameBlocks (Sha512_update.headState s d b bl).mem m' :=
  (SameBlocks.roundState (s := { s with mem := _ }) h.storeAt).storeAt

/-- Erasing from a `WF` state's counter keeps a memory with its blocks. -/
public theorem SameBlocks.eraseFrom {s : GlobalState} {m : MemoryState} (hwf : s.WF)
    (h : SameBlocks m s.mem) : m.eraseFrom s.alloc.nextFreeBlock = m := by
  have hw : ({ s with mem := m } : GlobalState).WF :=
    ⟨fun k hk => hwf.bound k ((h k).1 hk), hwf.pos, fun hk => hwf.null ((h _).1 hk)⟩
  exact congrArg GlobalState.mem (GlobalState.eraseFrom_self hw)

theorem headState_wf {s : GlobalState} (h : s.WF) : (headState s d b bl).WF :=
  GlobalState.WF.storeAt (roundState_wf (GlobalState.WF.storeAt h))

theorem room_headState {s : GlobalState} : Room (headState s d b bl).mem q w ↔ Room s.mem q w := by
  simp only [headState]
  rw [Room.storeAt_iff, room_roundState, Room.storeAt_iff]

theorem inBounds_headState {s : GlobalState} :
    InBounds (headState s d b bl).mem q w ↔ InBounds s.mem q w := by
  simp only [headState]
  rw [InBounds.storeAt_iff, inBounds_roundState, InBounds.storeAt_iff]

theorem Fits.headState {s : GlobalState} (h : Fits s.mem q w) :
    Fits (Sha512_update.headState s d b bl).mem q w :=
  (Fits.roundState (s := { s with mem := _ }) h.storeAt).storeAt

theorem headState_bufLen {s : GlobalState} (hr : Room s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) : Sha512Obj.bufLen (headState s d b bl).mem d = 0#8 := by
  simp only [headState, Sha512Obj.bufLen]
  exact
    MemoryState.readAt_storeAt_self
      (Room.add_of_le
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by simp) (room_roundState.2 hr.storeAt)).inBounds
      _

theorem headState_totalLen {s : GlobalState} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hbl : bl.toNat < 128) :
    Sha512Obj.totalLen (headState s d b bl).mem d = Sha512Obj.totalLen s.mem d := by
  simp only [headState, Sha512Obj.totalLen]
  rw [MemoryState.readAt_storeAt_disjoint, roundState_readAt (by omega) (disjoint_totalLen hdo),
    MemoryState.readAt_storeAt_disjoint]
  · simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; right; omega
  · simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat]
    right; right; omega

theorem fin_eq {s X : GlobalState} (hwf : s.WF) (h : SameBlocks (fromState X d b n off).mem s.mem) :
    PoisonOr.value
        ((Vals.nil, fromState X d b n off).fst,
          ({  alloc := (Vals.nil, fromState X d b n off).snd.alloc
              mem := (Vals.nil, fromState X d b n off).snd.mem.eraseFrom s.alloc.nextFreeBlock } :
            GlobalState)) =
      PoisonOr.value (Vals.nil, fromState X d b n off) := by
  simp only [h.eraseFrom hwf]

/-- `Sha512.update` of the `n` bytes at `b` into the object at `d` leaves `post`; the bytes apart
from the object, `buf_len` below 128 with that many bytes of `buf` known, the counts not
wrapping. -/
public theorem call_eq (d b : Pointer) (n : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Sha512Obj.Fit s.mem d)
    (hbuf : Fits s.mem (d.add 80#64) (8 * (Sha512Obj.bufLen s.mem d).toNat))
    (hbf : Fits s.mem b (8 * n.toNat)) (hbo : b.offset.toNat + n.toNat < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n.toNat))) (hn : n.toNat + 128 < 2 ^ 63)
    (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (hT : (Sha512Obj.totalLen s.mem d).toNat + n.toNat < 2 ^ 128) :
    Sha512_update.call (Sha512_update.args (.value d) (.value b) (.value n)) s =
      .value (.nil, post s d b n) := by
  obtain ⟨hdo, hdr, hdf, hf208⟩ := hd
  generalize hbl0 : Sha512Obj.bufLen s.mem d = bl at hbl hbuf
  have hblr : s.mem.readAt (d.add 208#64) 8 = bl := hbl0
  func_init
  have hb0 : Sha512Obj.bufLen S₀.mem d = bl := hS ▸ hbl0
  have hT0 : (Sha512Obj.totalLen S₀.mem d).toNat + n.toNat < 2 ^ 128 := hS ▸ hT
  clear hbl0 hT
  block_init
  iterate 7 step_pure
  step_load
  step_pure
  finish_block
  · have h1 : (Sha512Obj.bufLen S.mem d).toNat + (n.toNat - 0) % 128 < 128 := by
      rw [hS, hb0, hbr]; simp; omega
    have h2 : (Sha512Obj.totalLen S.mem d).toNat + n.toNat < 2 ^ 128 := by
      rw [hS]; omega
    have hrun : Sha512_update.runFrom E 3 S = .value (.nil, fromState S d b n 0) := by
      step_loop using fromBB3 d b n 0 S (hbl := h1) (hT := h2) (hfin := rfl)
    rw [hrun, PoisonOr.value_bind]
    subst hS
    simp only [post, hb0, hbr]
    rw [ite_eq_right_of_eq_false _ _ (by simp)]
    exact fin_eq hwf₀ (SameBlocks.fromState fun _ => Iff.rfl)
  · have hnz : bl.toNat ≠ 0 := fun h => hbr (BitVec.eq_of_toNat_eq (by simpa using h))
    have hov : n.uaddOverflow (BitVec.setWidth 64 bl) = false := by
      simp [BitVec.uaddOverflow]; omega
    block_init
    step_pure
    step_pure [hov]
    step_pure
    finish_block
    · have hbr' : 127 < n.toNat + bl.toNat := by
        simp [BitVec.ult] at hbr; omega
      have hs8 : (128#8).usubOverflow bl = false := by
        simp [BitVec.usubOverflow]; omega
      have hmsb : (128#8 - bl).msb = false := by
        simp [BitVec.msb_eq_decide, BitVec.toNat_sub]; omega
      have hk : BitVec.setWidth 64 (128#8 - bl) = BitVec.ofNat 64 (128 - bl.toNat) := by
        apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_sub]; omega
      have hkn : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by
        simp; omega
      have hblm : bl.toNat % 18446744073709551616 = bl.toNat := Nat.mod_eq_of_lt (by omega)
      have hblt : bl.toNat < 18446744073709551616 := by omega
      have hdst :
        Room S.mem (d.add (80#64 + BitVec.setWidth 64 bl))
          (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat) := by
        rw [hkn];
        exact
          Room.add_of_le
            (by
              simp [BitVec.uaddOverflow]; omega)
            (by
              simp; omega)
            hdr
      have hsrc : Fits S.mem b (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat) := by
        rw [hkn]; exact hbf.mono (by omega)
      have hdis :
        (Range.of (d.add (80#64 + BitVec.setWidth 64 bl))
              (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat)).Disjoint
          (Range.of b (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat)) := by
        rw [hkn]
        simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add] at hsep ⊢
        simp only [BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_ofNat] at hsep ⊢
        rcases hsep with h | h | h
        · exact Or.inl h
        · right; left; omega
        · right; right; omega
      block_init
      step_pure [hs8]
      step_pure [hs8, hmsb, hk]
      step_pure
      step_pure [hblm, hblt]
      step_memcpy consuming hdst hsrc hdis
      have hd80 : Fits S.mem (d.add 80#64) 1024 := by
        have h2 :
          Fits S.mem ((d.add 80#64).add (BitVec.setWidth 64 bl)) (8 * (128 - bl.toNat)) := by
          rw [Pointer.add_add]; rw [hkn] at hfits_d_0; exact hfits_d_0
        exact
          Fits.append (off := BitVec.setWidth 64 bl)
            (by
              simp [Pointer.add, BitVec.uaddOverflow]; omega)
            (by
              simp; omega)
            (by omega) hbuf h2
      have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
        simp [Pointer.add, BitVec.toNat_add]; omega
      have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
      clear hfits_d_0 hread_d_0 hbuf
      step_call using Sha512_round.call_eq consuming hwf hdf hd80 hbf hf208 hdr
      have hr208 : Room S.mem (d.add 208#64) 8 := by
        rw [hS]
        exact
          (room_storeWords 8 0).2
            (Room.add_of_le
              (by
                simp [BitVec.uaddOverflow]; omega)
              (by simp) hdr₀.storeAt)
      step_store consuming hr208
      finish_block
      have hSh : S = headState S₀ d b bl := hS
      clear hfits_d_208 hread_d_208
      subst hSh
      have h1 :
        (Sha512Obj.bufLen (headState S₀ d b bl).mem d).toNat + (n.toNat - (128 - bl.toNat)) % 128 <
          128 := by
        rw [headState_bufLen hdr₀ hdo]; simp; omega
      have h2 : (Sha512Obj.totalLen (headState S₀ d b bl).mem d).toNat + n.toNat < 2 ^ 128 := by
        rw [headState_totalLen hdo hbl]; omega
      have hrun :
        Sha512_update.runFrom E 3 (headState S₀ d b bl) =
          .value (.nil, fromState (headState S₀ d b bl) d b n (128 - bl.toNat)) := by
        step_loop using
          fromBB3 d b n (128 - bl.toNat) (headState S₀ d b bl) (hoffn := by omega) (hwf :=
            headState_wf hwf₀) (hdr := room_headState.2 hdr₀) (hdf := Fits.headState hdf₀) (hf208 :=
            Fits.headState hf208₀) (hbf := Fits.headState hbf₀) (hbl := h1) (hT := h2) (hfin := rfl)
      rw [hrun, PoisonOr.value_bind]
      simp only [post, hb0]
      rw [ite_eq_left_of_eq_true _ _ (eq_true ⟨fun h => hnz (by simp [h]), hbr'⟩)]
      exact fin_eq hwf₀ (SameBlocks.fromState (SameBlocks.headState fun _ => Iff.rfl))
    · have hle : n.toNat + bl.toNat ≤ 127 := by
        simp [BitVec.ult] at hbr; omega
      have h1 : (Sha512Obj.bufLen S.mem d).toNat + (n.toNat - 0) % 128 < 128 := by
        rw [hS, hb0]; omega
      have h2 : (Sha512Obj.totalLen S.mem d).toNat + n.toNat < 2 ^ 128 := by
        rw [hS]; omega
      have hrun : Sha512_update.runFrom E 3 S = .value (.nil, fromState S d b n 0) := by
        step_loop using fromBB3 d b n 0 S (hbl := h1) (hT := h2) (hfin := rfl)
      rw [hrun, PoisonOr.value_bind]
      subst hS
      simp only [post, hb0]
      rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))]
      exact fin_eq hwf₀ (SameBlocks.fromState fun _ => Iff.rfl)

/-! ## What the object has absorbed -/

/-- `Absorbed` without `total_len`: the whole blocks of `P` compressed, the rest buffered. -/
public structure Pend (m : MemoryState) (d : Pointer) (P : List (BitVec 8)) : Prop where
  state : Sha512Obj.state m d = Sha512.compressBlocks Sha512.IV P
  bufLen : (Sha512Obj.bufLen m d).toNat = P.length % 128
  buf : (bytesLE (Sha512Obj.buf m d)).take (P.length % 128) = P.drop (P.length / 128 * 128)
  bufFits : Fits m (d.add 80#64) (8 * (P.length % 128))

/-- No bits are known when there is room for none. -/
public theorem fits_zero {m : MemoryState} {p : Pointer} (h : Room m p 0) : Fits m p 0 := by
  obtain ⟨b, hb, hl, hw⟩ := h
  exact ⟨b, hb, hl, hw, BitVec.eq_of_getLsbD_eq fun i hi => by omega⟩

/-- The bytes of a splice into `buf` at byte `bl`: `buf`'s first `bl`, then `x`'s. -/
public theorem take_bytesLE_splice (buf : BitVec 1024) {k : Nat} (x : BitVec (8 * k)) {bl : Nat}
    (h : bl + k ≤ 128) :
    (bytesLE (Memory.spliceBits buf (8 * bl) x)).take (bl + k) =
      (bytesLE buf).take bl ++ bytesLE x := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_take, List.length_append]; omega
  · intro i h1 h2
    simp only [length_bytesLE, List.length_take, List.length_append] at h1 h2
    rw [List.getElem_take, getElem_bytesLE, List.getElem_append]
    split <;> rename_i hi <;> simp only [List.length_take, length_bytesLE] at hi
    · rw [Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega), List.getElem_take,
        getElem_bytesLE]
    · rw [Memory.extractLsb'_spliceBits_of_subrange _ _ _ _ (by omega) (by omega) (by omega),
        getElem_bytesLE]
      simp only [List.length_take, length_bytesLE]
      congr 1
      omega

/-- The bytes at `b + off`: those of `b`'s from `off`. -/
public theorem bytesLE_readAt_add {m : MemoryState} {b : Pointer} {n off k : Nat}
    (hf : InBounds m b (8 * n)) (ho : b.offset.toNat + n < 2 ^ 64) (h : off + k ≤ n) :
    bytesLE (m.readAt (b.add (BitVec.ofNat 64 off)) (8 * k)) =
      ((bytesLE (m.readAt b (8 * n))).drop off).take k := by
  rw [MemoryState.readAt_add_of_readAt hf
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      rfl,
    show (BitVec.ofNat 64 off).toNat * 8 = 8 * off by
      simp; omega,
    bytesLE_extractLsb' _ (by omega) (by omega) (by omega)]
  simp only [show 8 * off / 8 = off by omega, show 8 * k / 8 = k by omega]

/-- Whole blocks `P`, then one more block. -/
public theorem compressBlocks_block {P B : List (BitVec 8)} (hP : P.length % 128 = 0)
    (hB : B.length = 128) :
    Sha512.compressBlocks H (P ++ B) = Sha512.compress (Sha512.compressBlocks H P) B := by
  rw [Sha512.compressBlocks_append _ hP, Sha512.compressBlocks_of_le (by omega),
    List.take_of_length_le (by omega), List.drop_of_length_le (by omega),
    Sha512.compressBlocks_of_lt (by simp)]

/-! ### The object's fields through the stores -/

public theorem state_storeAt {m : MemoryState} {d p : Pointer} {x : BitVec w}
    (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (h : (Range.of p w).Disjoint (Range.of (d.add 16#64) 512)) :
    Sha512Obj.state (m.storeAt p x) d = Sha512Obj.state m d := by
  apply Vector.ext
  intro i hi
  simp only [Sha512Obj.state, Vector.getElem_ofFn]
  apply MemoryState.readAt_storeAt_disjoint
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat] at h ⊢
  rcases h with h | h | h
  · exact Or.inl h
  · right; left; omega
  · right; right; omega

public theorem word_disjoint {d : Pointer} {i j : Nat} (hi : i < 8) (hj : j < 8) (h : i ≠ j) :
    (Range.of (d.add (16#64 + BitVec.ofNat 64 (8 * i))) 64).Disjoint
      (Range.of (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  omega

/-- Word `j` after storing words `i … i + n - 1`. -/
public theorem readAt_storeWords_word {m : MemoryState} {d : Pointer} {f : Nat → BitVec 64}
    (hr : Room m d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) {j : Nat} (hj : j < 8) :
    ∀ n i,
      i + n ≤ 8 →
        (Sha512Obj.storeWords d f i n m).readAt (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 =
          if i ≤ j ∧ j < i + n then f j
          else m.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 := by
  intro n
  induction n generalizing m with
  | zero =>
    intro i _; rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))]; rfl
  | succ n ih =>
    intro i h
    rw [Sha512Obj.storeWords, ih hr.storeAt (i + 1) (by omega)]
    by_cases e : j = i
    · subst e
      rw [ite_eq_right_of_eq_false _ _ (eq_false (show ¬(j + 1 ≤ j ∧ j < j + 1 + n) by omega)),
        ite_eq_left_of_eq_true _ _ (eq_true (show j ≤ j ∧ j < j + (n + 1) by omega))]
      exact
        MemoryState.readAt_storeAt_self
          (Room.add_of_le
              (by
                simp [BitVec.uaddOverflow]; omega)
              (by
                simp; omega)
              hr).inBounds
          _
    · by_cases r : i + 1 ≤ j ∧ j < i + 1 + n
      · rw [ite_eq_left_of_eq_true _ _ (eq_true r),
          ite_eq_left_of_eq_true _ _ (eq_true (show i ≤ j ∧ j < i + (n + 1) by omega))]
      · rw [ite_eq_right_of_eq_false _ _ (eq_false r),
          ite_eq_right_of_eq_false _ _ (eq_false (show ¬(i ≤ j ∧ j < i + (n + 1)) by omega))]
        exact MemoryState.readAt_storeAt_disjoint (word_disjoint (by omega) hj (Ne.symm e)) _

/-- The state words of `setState`: `v`. -/
public theorem state_setState {m : MemoryState} {d : Pointer} (hr : Room m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (v : Vector (BitVec 64) 8) :
    Sha512Obj.state (Sha512Obj.setState m d v) d = v := by
  apply Vector.ext
  intro j hj
  simp only [Sha512Obj.state, Sha512Obj.setState, Vector.getElem_ofFn]
  rw [readAt_storeWords_word hr hdo hj 8 0 (by omega),
    ite_eq_left_of_eq_true _ _ (eq_true ⟨by omega, by omega⟩), getElem!_pos v j hj]

/-! ### `Pend` through the code's steps -/

public theorem disjoint_buf {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    (Range.of (d.add 16#64) 512).Disjoint (Range.of (d.add 80#64) 1024) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right; left; omega

/-- A round on a whole block `B` read at `p`, after whole blocks `P`. -/
theorem pend_round {s : GlobalState} {d p : Pointer} {P : List (BitVec 8)} (hP : Pend s.mem d P)
    (h0 : P.length % 128 = 0) (hr : Room s.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    Pend (roundState s d p).mem d (P ++ bytesLE (s.mem.readAt p 1024)) := by
  have hB : (bytesLE (s.mem.readAt p 1024)).length = 128 := by simp
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [roundState, state_setState hr hdo, hP.state, compressBlocks_block h0 hB]
  · rw [Sha512Obj.bufLen, roundState_readAt (by omega) (disjoint_bufLen hdo), ← Sha512Obj.bufLen,
      hP.bufLen, List.length_append, hB]
    omega
  · simp only [List.length_append, hB, show (P.length + 128) % 128 = 0 by omega, List.take_zero]
    rw [List.drop_eq_nil_of_le]
    simp only [List.length_append, hB]
    omega
  · simp only [List.length_append, hB, show (P.length + 128) % 128 = 0 by omega, Nat.mul_zero]
    exact
      fits_zero
        (room_roundState.2
          (Room.add_of_le
            (by
              simp [BitVec.uaddOverflow]; omega)
            (by simp) hr))

/-- The rounds on the whole blocks of `b` from `off`, after `P = M ++ D[0, off)`. -/
theorem pend_blocks {d b : Pointer} {n : Nat} {M : List (BitVec 8)}
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbo : b.offset.toNat + n < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n))) :
    ∀ c off (s : GlobalState),
      off + 128 * c ≤ n →
        (c ≠ 0 → (M.length + off) % 128 = 0) →
        Room s.mem d 1792 →
        InBounds s.mem b (8 * n) →
        Pend s.mem d (M ++ (bytesLE (s.mem.readAt b (8 * n))).take off) →
        Pend (blocksState d b off c s).mem d
            (M ++ (bytesLE (s.mem.readAt b (8 * n))).take (off + 128 * c)) ∧
          (blocksState d b off c s).mem.readAt b (8 * n) = s.mem.readAt b (8 * n) := by
  have hdisb : (Range.of (d.add 16#64) 512).Disjoint (Range.of b (8 * n)) := by
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at hsep ⊢
    rcases hsep with h | h | h
    · exact Or.inl h
    · right; left; omega
    · right; right; omega
  intro c
  induction c with
  | zero =>
    intro off s _ _ _ _ h; exact ⟨h, rfl⟩
  | succ c ih =>
    intro off s h1 h2 hr hbf hP
    have hrd :
      (roundState s d (b.add (BitVec.ofNat 64 off))).mem.readAt b (8 * n) =
        s.mem.readAt b (8 * n) :=
      roundState_readAt (by omega) hdisb
    have hblk := bytesLE_readAt_add (k := 128) hbf hbo (by omega) (off := off)
    have hP' :=
      pend_round (p := b.add (BitVec.ofNat 64 off)) hP
        (by
          simp; have := h2 (by omega); omega)
        hr hdo
    rw [show 8 * 128 = 1024 from rfl] at hblk
    rw [hblk, List.append_assoc, ← List.take_add] at hP'
    have :=
      ih (off + 128) (roundState s d (b.add (BitVec.ofNat 64 off))) (by omega)
        (fun _ => by
          have := h2 (by omega); omega)
        (room_roundState.2 hr) (InBounds.roundState hbf)
        (by
          rw [hrd]; exact hP')
    rw [hrd, show off + 128 + 128 * c = off + 128 * (c + 1) by omega] at this
    exact this

public theorem setWidth_ofNat (x : BitVec 8) : BitVec.setWidth 64 x = BitVec.ofNat 64 x.toNat := by
  apply BitVec.eq_of_toNat_eq; simp

/-- `buf` after a store at byte `bl` of it: the store's bits spliced in. -/
public theorem buf_storeAt {m : MemoryState} {d : Pointer} (hr : Room m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) {bl k : Nat} (h : bl + k ≤ 128) (x : BitVec (8 * k)) :
    Sha512Obj.buf (m.storeAt (d.add (80#64 + BitVec.ofNat 64 bl)) x) d =
      Memory.spliceBits (Sha512Obj.buf m d) (8 * bl) x := by
  have hf80 : InBounds m (d.add 80#64) 1024 :=
    (Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by simp) hr).inBounds
  rw [Sha512Obj.buf, ← Pointer.add_add,
    MemoryState.readAt_add_storeAt hf80
      (by
        simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega)
      (by
        simp; omega)]
  congr 1
  simp; omega

/-- Ranges inside the object, by byte offsets: apart when the byte ranges are. -/
public theorem obj_disjoint {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) {a c : BitVec 64}
    {v w : Nat} (ha : a.toNat ≤ 224) (hc : c.toNat ≤ 224)
    (h : a.toNat * 8 + v ≤ c.toNat * 8 ∨ c.toNat * 8 + w ≤ a.toNat * 8) :
    (Range.of (d.add a) v).Disjoint (Range.of (d.add c) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  right
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A range inside the object, apart from what the object is apart from. -/
public theorem obj_disjoint_q {d q : Pointer} {w : Nat} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of q w)) {a : BitVec 64} {v : Nat}
    (ha : a.toNat * 8 + v ≤ 1792) : (Range.of (d.add a) v).Disjoint (Range.of q w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add,
    BitVec.toNat_add] at hsep ⊢
  rcases hsep with h | h | h
  · exact Or.inl h
  · right; left; rw [Nat.mod_eq_of_lt (by omega)]; omega
  · right; right; rw [Nat.mod_eq_of_lt (by omega)]; omega

/-- A partial block's bytes completed by `T`: one more block compressed. -/
public theorem compressBlocks_fill {M T : List (BitVec 8)} (h : M.length % 128 + T.length = 128) :
    Sha512.compressBlocks H (M ++ T) =
      Sha512.compress (Sha512.compressBlocks H M) (M.drop (M.length / 128 * 128) ++ T) := by
  have e : M ++ T = M.take (M.length / 128 * 128) ++ (M.drop (M.length / 128 * 128) ++ T) := by
    rw [← List.append_assoc, List.take_append_drop]
  rw [e,
    compressBlocks_block
      (by
        simp; omega)
      (by
        simp; omega),
    Sha512.compressBlocks_take M]

/-- `bb2`: the buffered `M`'s block completed from `b` and compressed, `buf_len` zeroed. -/
theorem pend_head {s : GlobalState} {d b : Pointer} {n : Nat} {M : List (BitVec 8)}
    (hP : Pend s.mem d M) (hk : 128 - (Sha512Obj.bufLen s.mem d).toNat ≤ n) (hr : Room s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n))) :
    Pend (headState s d b (Sha512Obj.bufLen s.mem d)).mem d
        (M ++ (bytesLE (s.mem.readAt b (8 * n))).take (128 - (Sha512Obj.bufLen s.mem d).toNat)) ∧
      (headState s d b (Sha512Obj.bufLen s.mem d)).mem.readAt b (8 * n) =
        s.mem.readAt b (8 * n) := by
  generalize hb8 : Sha512Obj.bufLen s.mem d = bl8 at hk
  have hblM : bl8.toNat = M.length % 128 := hb8 ▸ hP.bufLen
  have hblt : bl8.toNat < 128 := by omega
  generalize hX : s.mem.readAt b (8 * (BitVec.ofNat 64 (128 - bl8.toNat)).toNat) = X
  have hkn : (BitVec.ofNat 64 (128 - bl8.toNat)).toNat = 128 - bl8.toNat := by
    simp; omega
  -- the store into the buffer
  generalize hm1 : s.mem.storeAt (d.add (80#64 + BitVec.setWidth 64 bl8)) X = m1
  have hptr :
    d.add (80#64 + BitVec.setWidth 64 bl8) = d.add (80#64 + BitVec.ofNat 64 bl8.toNat) := by
    rw [setWidth_ofNat]
  have hoff : (80#64 + BitVec.ofNat 64 bl8.toNat).toNat = 80 + bl8.toNat := by
    simp; omega
  have hdisX (c : BitVec 64) (w : Nat) (hc : c.toNat ≤ 224)
    (h : c.toNat * 8 + w ≤ 640 ∨ 1664 ≤ c.toNat * 8) :
    (Range.of (d.add (80#64 + BitVec.ofNat 64 bl8.toNat))
          (8 * (BitVec.ofNat 64 (128 - bl8.toNat)).toNat)).Disjoint
      (Range.of (d.add c) w) :=
    obj_disjoint hdo
      (by
        rw [hoff]; omega)
      hc
      (by
        rw [hoff, hkn]; omega)
  have hstate1 : Sha512Obj.state m1 d = Sha512Obj.state s.mem d := by
    rw [← hm1, hptr]
    refine state_storeAt hdo ?_
    simpa using hdisX 16#64 512 (by decide) (by simp)
  have hbuf1 :
    Sha512Obj.buf m1 d = Memory.spliceBits (Sha512Obj.buf s.mem d) (8 * bl8.toNat) X := by
    rw [← hm1, hptr]
    exact
      buf_storeAt hr hdo
        (by
          rw [hkn]; omega)
        X
  -- the block compressed: the buffered bytes, then `b`'s first
  have hbytesX : bytesLE X = (bytesLE (s.mem.readAt b (8 * n))).take (128 - bl8.toNat) := by
    rw [← hX,
      MemoryState.readAt_of_readAt_le (v := 8 * n)
        (by
          rw [hkn]; omega)
        rfl,
      bytesLE_setWidth _ (by omega)
        (by
          rw [hkn]; omega),
      hkn]
    simp only [show 8 * (128 - bl8.toNat) / 8 = 128 - bl8.toNat by omega]
  have hblock :
    bytesLE (Sha512Obj.buf m1 d) =
      M.drop (M.length / 128 * 128) ++
        (bytesLE (s.mem.readAt b (8 * n))).take (128 - bl8.toNat) := by
    have h1 :=
      take_bytesLE_splice (Sha512Obj.buf s.mem d) X (bl := bl8.toNat)
        (by
          rw [hkn]; omega)
    rw [← hbuf1,
      List.take_of_length_le
        (by
          simp; omega)] at h1
    rw [h1, hbytesX, hblM, hP.buf]
  have hr1 : Room m1 d 1792 := hm1 ▸ hr.storeAt
  have hT :
    ((bytesLE (s.mem.readAt b (8 * n))).take (128 - bl8.toNat)).length = 128 - bl8.toNat := by
    simp; omega
  have h208 : (Range.of (d.add 208#64) 8).Disjoint (Range.of (d.add 16#64) 512) :=
    obj_disjoint hdo (by decide) (by decide) (by simp)
  simp only [headState]
  rw [hX, hm1]
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩
  · rw [state_storeAt hdo h208, roundState, state_setState hr1 hdo, hstate1, hP.state]
    rw [show m1.readAt (d.add 80#64) 1024 = Sha512Obj.buf m1 d from rfl, hblock,
      compressBlocks_fill
        (by
          rw [hT]; omega)]
  · rw [Sha512Obj.bufLen, MemoryState.readAt_storeAt_self]
    · simp; omega
    · exact
        (room_roundState.2
            (Room.add_of_le
              (by
                simp [BitVec.uaddOverflow]; omega)
              (by simp) hr1)).inBounds
  · rw [show (M ++ _).length % 128 = 0 by
        simp; omega,
      List.take_zero, List.drop_eq_nil_of_le]
    simp; omega
  · rw [show (M ++ _).length % 128 = 0 by
        simp; omega,
      Nat.mul_zero]
    exact
      fits_zero
        (room_roundState.2
            (Room.add_of_le
              (by
                simp [BitVec.uaddOverflow]; omega)
              (by simp) hr1)).storeAt
  · rw [MemoryState.readAt_storeAt_disjoint (obj_disjoint_q hdo hsep (by simp)),
      roundState_readAt (by omega) (obj_disjoint_q hdo hsep (by simp)), ← hm1, hptr,
      MemoryState.readAt_storeAt_disjoint
        (obj_disjoint_q hdo hsep
          (by
            rw [hoff, hkn]; omega))]

/-- `bb6`'s stores after `P = M ++ D[0, off)`: the object has absorbed `M ++ D`. -/
theorem absorbed_tail {m : MemoryState} {d b : Pointer} {n : BitVec 64} {off : Nat}
    {M : List (BitVec 8)} (hP : Pend m d (M ++ (bytesLE (m.readAt b (8 * n.toNat))).take off))
    (hTl : Sha512Obj.totalLen m d = BitVec.ofNat 128 M.length) (hoff : off ≤ n.toNat)
    (hbl : (Sha512Obj.bufLen m d).toNat + (n.toNat - off) < 128) (hr : Room m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbf : InBounds m b (8 * n.toNat))
    (hbo : b.offset.toNat + n.toNat < 2 ^ 64) :
    Sha512Obj.Absorbed (tailMem m d b n off) d (M ++ bytesLE (m.readAt b (8 * n.toNat))) := by
  generalize hD : bytesLE (m.readAt b (8 * n.toNat)) = D at hP
  have hDl : D.length = n.toNat := by
    rw [← hD]; simp
  generalize hP' : M ++ D.take off = P at hP
  have hPl : P.length = M.length + off := by
    rw [← hP']; simp; omega
  have hMD : M ++ D = P ++ D.drop off := by rw [← hP', List.append_assoc, List.take_append_drop]
  generalize hb8 : Sha512Obj.bufLen m d = bl8 at hbl
  have hblP : bl8.toNat = P.length % 128 := hb8 ▸ hP.bufLen
  have hkn : (BitVec.ofNat 64 (n.toNat - off)).toNat = n.toNat - off := by
    simp; omega
  have hoffb : (80#64 + BitVec.ofNat 64 bl8.toNat).toNat = 80 + bl8.toNat := by
    simp; omega
  simp only [tailMem, hb8]
  rw [setWidth_ofNat, hTl]
  generalize hX :
    m.readAt (b.add (BitVec.ofNat 64 off)) (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) = X
  have hXb : bytesLE X = D.drop off := by
    rw [← hX, ← hD,
      bytesLE_readAt_add hbf hbo
        (by
          rw [hkn]; omega),
      hkn,
      List.take_of_length_le
        (by
          simp; try omega)]
  have hk : (D.drop off).length = n.toNat - off := by
    simp; omega
  have hoffx : (80#64 + BitVec.ofNat 64 bl8.toNat).toNat ≤ 224 := by
    rw [hoffb]; omega
  have hDX16 :=
    obj_disjoint (a := 80#64 + BitVec.ofNat 64 bl8.toNat) (c := 16#64) (v :=
      8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) (w := 512) hdo hoffx (by decide)
      (by
        rw [hoffb, hkn]; simp; omega)
  have hD20816 :=
    obj_disjoint (a := 208#64) (c := 16#64) (v := 8) (w := 512) hdo (by decide) (by decide)
      (by simp)
  have hD016 : (Range.of d 128).Disjoint (Range.of (d.add 16#64) 512) := by
    simpa using
      obj_disjoint (a := 0#64) (c := 16#64) (v := 128) (w := 512) hdo (by decide) (by decide)
        (by simp)
  have hD0208 : (Range.of d 128).Disjoint (Range.of (d.add 208#64) 8) := by
    simpa using
      obj_disjoint (a := 0#64) (c := 208#64) (v := 128) (w := 8) hdo (by decide) (by decide)
        (by simp)
  have hD080 : (Range.of d 128).Disjoint (Range.of (d.add 80#64) 1024) := by
    simpa using
      obj_disjoint (a := 0#64) (c := 80#64) (v := 128) (w := 1024) hdo (by decide) (by decide)
        (by simp)
  have hD20880 :=
    obj_disjoint (a := 208#64) (c := 80#64) (v := 8) (w := 1024) hdo (by decide) (by decide)
      (by simp)
  have hr1 :
    Room m (d.add (80#64 + BitVec.ofNat 64 bl8.toNat))
      (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        rw [hoffb, hkn]; omega)
      hr
  have hf208 :
    InBounds (m.storeAt (d.add (80#64 + BitVec.ofNat 64 bl8.toNat)) X) (d.add 208#64) 8 :=
    (Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by simp) hr).storeAt.inBounds
  have hf0 :
    InBounds
      ((m.storeAt (d.add (80#64 + BitVec.ofNat 64 bl8.toNat)) X).storeAt (d.add 208#64)
        (bl8 + BitVec.ofNat 8 (n.toNat - off)))
      d 128 :=
    (hr.mono (by omega)).storeAt.storeAt.inBounds
  have hlen : (M ++ D).length % 128 = bl8.toNat + (BitVec.ofNat 64 (n.toNat - off)).toNat := by
    simp [hDl, hkn]; omega
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [state_storeAt hdo hD016, state_storeAt hdo hD20816, state_storeAt hdo hDX16, hP.state, hMD,
      Sha512.compressBlocks_append_short
        (by
          rw [hk]; omega)]
  · rw [Sha512Obj.bufLen, MemoryState.readAt_storeAt_disjoint hD0208,
      MemoryState.readAt_storeAt_self hf208]
    simp [BitVec.toNat_add, hDl]
    omega
  · rw [Sha512Obj.buf, MemoryState.readAt_storeAt_disjoint hD080,
      MemoryState.readAt_storeAt_disjoint hD20880, ← Sha512Obj.buf,
      buf_storeAt hr hdo
        (by
          rw [hkn]; omega)
        X,
      hlen,
      take_bytesLE_splice _ _
        (by
          rw [hkn]; omega),
      hXb, hblP, hP.buf, hMD,
      List.drop_append_of_le_length
        (by
          simp only [List.length_append]; omega)]
    congr 2
    simp [hk]
    omega
  · rw [Sha512Obj.totalLen, MemoryState.readAt_storeAt_self hf0]
    apply BitVec.eq_of_toNat_eq
    simp [hDl]
    try omega
  · rw [hlen, Nat.mul_add]
    have h2 :
      Fits (m.storeAt (d.add (80#64 + BitVec.ofNat 64 bl8.toNat)) X)
        ((d.add 80#64).add (BitVec.ofNat 64 bl8.toNat))
        (8 * (BitVec.ofNat 64 (n.toNat - off)).toNat) := by
      rw [Pointer.add_add]; exact Fits.storeAt_self hr1
    have h1 :
      Fits (m.storeAt (d.add (80#64 + BitVec.ofNat 64 bl8.toNat)) X) (d.add 80#64)
        (8 * bl8.toNat) := by
      rw [hblP]; exact hP.bufFits.storeAt
    have hov : ¬(d.add 80#64).offset.uaddOverflow (BitVec.ofNat 64 bl8.toNat) := by
      simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega
    exact
      (Fits.append hov
          (by
            simp; omega)
          rfl h1 h2).storeAt.storeAt

/-- `post` leaves an object that has absorbed `b`'s `n` bytes after `M`. -/
public theorem absorbed {s : GlobalState} {d b : Pointer} {n : BitVec 64} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed s.mem d M) (hd : Sha512Obj.Fit s.mem d)
    (hbf : InBounds s.mem b (8 * n.toNat)) (hbo : b.offset.toNat + n.toNat < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n.toNat))) :
    Sha512Obj.Absorbed (post s d b n).mem d (M ++ bytesLE (s.mem.readAt b (8 * n.toNat))) := by
  obtain ⟨hdo, hr, -, -⟩ := hd
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have hP0 : Pend s.mem d M := ⟨hA.state, hA.bufLen, hA.buf, hA.bufFits⟩
  have hbl := hA.bufLen
  simp only [post]
  split
  · rename_i hc
    obtain ⟨-, hgt⟩ := hc
    obtain ⟨hP1, hr1⟩ := pend_head (n := n.toNat) hP0 (by omega) hr hdo hsep
    generalize hk : 128 - (Sha512Obj.bufLen s.mem d).toNat = k at hP1
    simp only [fromState]
    have hb :=
      pend_blocks (M := M) hdo hbo hsep ((n.toNat - k) / 128) k _ (by omega) (fun _ => by omega)
        (room_headState.2 hr) (inBounds_headState.2 hbf)
        (by
          rw [hr1]; exact hP1)
    rw [hr1] at hb
    obtain ⟨hP2, hr2⟩ := hb
    have :=
      absorbed_tail (n := n) (off := k + 128 * ((n.toNat - k) / 128)) (M := M)
        (by
          rw [hr2]; exact hP2)
        (by
          rw [Sha512Obj.totalLen, blocksState_readAt hdo' (disjoint_totalLen hdo), ←
            Sha512Obj.totalLen, headState_totalLen hdo (by omega), hA.totalLen])
        (by omega)
        (by
          rw [Sha512Obj.bufLen, blocksState_readAt hdo' (disjoint_bufLen hdo), ← Sha512Obj.bufLen,
            headState_bufLen hr hdo];
          simp; omega)
        ((room_blocksState _ _ _).2 (room_headState.2 hr)) hdo
        ((inBounds_blocksState _ _ _).2 (inBounds_headState.2 hbf)) hbo
    rw [hr2] at this
    exact this
  · rename_i hc
    simp only [fromState]
    have hb :=
      pend_blocks (M := M) hdo hbo hsep (n.toNat / 128) 0 s (by omega)
        (fun h => by
          have : (Sha512Obj.bufLen s.mem d) = 0 :=
            Classical.byContradiction fun hne => hc ⟨hne, by omega⟩
          rw [this] at hbl; simp at hbl; omega)
        hr hbf (by simpa using hP0)
    obtain ⟨hP2, hr2⟩ := hb
    have :=
      absorbed_tail (n := n) (off := 0 + 128 * (n.toNat / 128)) (M := M)
        (by
          rw [hr2]; simpa using hP2)
        (by
          rw [Sha512Obj.totalLen, blocksState_readAt hdo' (disjoint_totalLen hdo), ←
            Sha512Obj.totalLen, hA.totalLen])
        (by omega)
        (by
          rw [Sha512Obj.bufLen, blocksState_readAt hdo' (disjoint_bufLen hdo), ← Sha512Obj.bufLen]
          by_cases h0 : Sha512Obj.bufLen s.mem d = 0
          · rw [h0]; simp; omega
          · have : n.toNat + (Sha512Obj.bufLen s.mem d).toNat ≤ 127 :=
              Classical.byContradiction fun h => hc ⟨h0, by omega⟩
            omega)
        ((room_blocksState _ _ _).2 hr) hdo ((inBounds_blocksState _ _ _).2 hbf) hbo
    rw [hr2] at this
    simpa using this

/-- An object that has absorbed bytes: `buf_len` below 128. -/
public theorem bufLen_lt {m : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed m d M) : (Sha512Obj.bufLen m d).toNat < 128 := by
  rw [hA.bufLen]; omega

/-- An object that has absorbed bytes: its `buf_len` bytes of `buf` known. -/
public theorem fits_buf {m : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed m d M) : Fits m (d.add 80#64) (8 * (Sha512Obj.bufLen m d).toNat) := by
  rw [hA.bufLen]; exact hA.bufFits

/-! ### What else `post` keeps -/

public theorem Fits.post {s : GlobalState} (h : Fits s.mem q w) :
    Fits (Sha512_update.post s d b n).mem q w := by
  simp only [Sha512_update.post]
  split <;>
    exact
      (Fits.blocksState _ _
          (by
            first
            | exact Fits.headState h
            | exact h)).storeAt.storeAt.storeAt

public theorem room_post {s : GlobalState} : Room (post s d b n).mem q w ↔ Room s.mem q w := by
  simp only [post]
  split <;> simp only [fromState, tailMem, Room.storeAt_iff, room_blocksState, room_headState]

public theorem post_wf {s : GlobalState} (h : s.WF) : (post s d b n).WF := by
  simp only [post]
  split <;> simp only [fromState, tailMem] <;>
    exact
      GlobalState.WF.storeAt
        (GlobalState.WF.storeAt
          (GlobalState.WF.storeAt
            (blocksState_wf _ _ _
              (by
                first
                | exact headState_wf h
                | exact h))))

/-- `post` keeps the object's known fields. -/
public theorem Fit.post {s : GlobalState} (h : Sha512Obj.Fit s.mem d) :
    Sha512Obj.Fit (Sha512_update.post s d b n).mem d :=
  ⟨h.1, room_post.2 h.2.1, Fits.post h.2.2.1, Fits.post h.2.2.2⟩

theorem tailMem_readAt {m : MemoryState} {d q : Pointer} {w off : Nat}
    (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hbl : (Sha512Obj.bufLen m d).toNat + (n.toNat - off) ≤ 128)
    (h : (Range.of d 1792).Disjoint (Range.of q w)) :
    (tailMem m d b n off).readAt q w = m.readAt q w := by
  have hb8 : (Sha512Obj.bufLen m d).toNat < 256 := (Sha512Obj.bufLen m d).isLt
  simp only [tailMem]
  rw [MemoryState.readAt_storeAt_disjoint
      (by simpa using obj_disjoint_q (a := 0#64) (v := 128) hdo h (by simp)),
    MemoryState.readAt_storeAt_disjoint (obj_disjoint_q hdo h (by simp)),
    MemoryState.readAt_storeAt_disjoint
      (obj_disjoint_q hdo h
        (by
          simp; omega))]

theorem headState_readAt {s : GlobalState} {d q : Pointer} {w : Nat} {bl : BitVec 8}
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : bl.toNat < 128)
    (h : (Range.of d 1792).Disjoint (Range.of q w)) :
    (headState s d b bl).mem.readAt q w = s.mem.readAt q w := by
  simp only [headState]
  rw [MemoryState.readAt_storeAt_disjoint (obj_disjoint_q hdo h (by simp)),
    roundState_readAt (by omega) (obj_disjoint_q hdo h (by simp)),
    MemoryState.readAt_storeAt_disjoint
      (obj_disjoint_q hdo h
        (by
          simp; omega))]

/-- `post` keeps every read apart from the object. -/
public theorem post_readAt {s : GlobalState} (hr : Room s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (h : (Range.of d 1792).Disjoint (Range.of q w)) :
    (post s d b n).mem.readAt q w = s.mem.readAt q w := by
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have h16 := obj_disjoint_q (a := 16#64) (v := 512) hdo h (by simp)
  simp only [post]
  split
  · rename_i hc
    simp only [fromState]
    rw [tailMem_readAt hdo ?_ h, blocksState_readAt hdo' h16, headState_readAt hdo hbl h]
    rw [Sha512Obj.bufLen, blocksState_readAt hdo' (disjoint_bufLen hdo), ← Sha512Obj.bufLen,
      headState_bufLen hr hdo]
    simp
    omega
  · rename_i hc
    simp only [fromState]
    rw [tailMem_readAt hdo ?_ h, blocksState_readAt hdo' h16]
    rw [Sha512Obj.bufLen, blocksState_readAt hdo' (disjoint_bufLen hdo), ← Sha512Obj.bufLen]
    by_cases h0 : Sha512Obj.bufLen s.mem d = 0
    · rw [h0]; simp; omega
    · have : n.toNat + (Sha512Obj.bufLen s.mem d).toNat ≤ 127 :=
        Classical.byContradiction fun h' => hc ⟨h0, by omega⟩
      omega

end Sha512_update

end MLIR.Zig

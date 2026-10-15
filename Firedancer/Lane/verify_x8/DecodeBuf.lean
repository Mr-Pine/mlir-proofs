module

public import Firedancer.Lane.verify_x8.CandDefs
public import Firedancer.Lane.verify_x8.TableMem

/-! The encodings `fd_ed25519_lane_decode2` reads (`a_buf[j]`, `r_buf[j]` at `^bb38`), the blocks it
leaves alone, and reads past its stores into other blocks. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512 Firedancer.Ref

@[expose] public section

/-- The blocks `fd_ed25519_lane_decode2` leaves alone from its start: below the call's frame, `k`
and `s`. -/
def DKeep0 (c : Call) (b : BlockId) : Prop :=
  b.id < c.s.alloc.nextFreeBlock ∨ b = (c.s.slot 26).id ∨ b = (c.s.slot 27).id

/-- The blocks it leaves alone past `^bb38`: `r[]`'s two pointers and `sqrtm1`. -/
def DKeep1 (c : Call) (b : BlockId) : Prop :=
  b = (c.s.slot 16).id ∨ b = (c.s.slot 17).id ∨ b = (c.s.slot 23).id

/-- A slot `k ≥ 16` but `k` and `s` is outside `DKeep0`. -/
theorem not_dkeep0 (c : Call) {k : Nat} (hk : 16 ≤ k) (h26 : k ≠ 26) (h27 : k ≠ 27) :
    ¬DKeep0 c (c.s.slot k).id := by
  simp only [DKeep0, GlobalState.slot, BlockId.mk.injEq, not_or]
  omega

/-- A slot but `r[]` and `sqrtm1` is outside `DKeep1`. -/
theorem not_dkeep1 (c : Call) {k : Nat} (h16 : k ≠ 16) (h17 : k ≠ 17) (h23 : k ≠ 23) :
    ¬DKeep1 c (c.s.slot k).id := by
  simp only [DKeep1, GlobalState.slot, BlockId.mk.injEq, not_or]
  omega

/-- `FrameOn` past a pointer store to a block outside `K`. -/
theorem frameOn_storePtr {m m' : MemoryState} {K : BlockId → Prop} {p q : Pointer}
    (h : m.FrameOn m' K) (hp : ¬K p.id) : m.FrameOn (m'.storePtr p q) K :=
  h.modifyBlock hp fun _ => ⟨rfl, rfl⟩

section LoadPtr

variable {m : MemoryState} {p q : Pointer}

/-- A pointer in another block than a store: the one before it. -/
theorem lp_storeAt {v : Nat} (h : p.id ≠ q.id) (y : BitVec v) :
    (m.storeAt p y).loadPtr q = m.loadPtr q :=
  MemoryState.loadPtr_storeAt_disjoint (Range.disjoint_of_id_ne h) y

/-- A pointer in another block than a pointer store: the one before it. -/
theorem lp_storePtr {x : Pointer} (h : p.id ≠ q.id) : (m.storePtr p x).loadPtr q = m.loadPtr q :=
  MemoryState.loadPtr_storePtr_disjoint (Range.disjoint_of_id_ne h)

/-- A pointer in another block than a lifetime start: the one before it. -/
theorem lp_lifetimeStart (h : p.id ≠ q.id) : (m.lifetimeStart p).loadPtr q = m.loadPtr q :=
  MemoryState.loadPtr_lifetimeStart h.symm

/-- A pointer in another block than a field element store: the one before it. -/
theorem lp_storeFe {a : Fe} (h : p.id ≠ q.id) : (m.storeFe p a).loadPtr q = m.loadPtr q := by
  have h' (o : BitVec 64) : (p.add o).id ≠ q.id := by simpa [Pointer.add] using h
  simp only [MemoryState.storeFe, MemoryState.storeVec, lp_storeAt (h' _), lp_storeAt h]

/-- A read in another block than a store: the one before it. -/
theorem ra_storeAt {v w : Nat} (h : p.id ≠ q.id) (y : BitVec v) :
    (m.storeAt p y).readAt q w = m.readAt q w :=
  MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h) y

end LoadPtr

/-- `identity`'s bits: `{1}`. -/
theorem identity_flatBits :
    Ty.flatBits _root_.Firedancer.Lane.Mlir.verify_x8_identity.lit (hw := rfl) = identityBytes := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast]
  decide +kernel

/-- The pointers `buf j` (an item's `pt` for a candidate, else `identity`) hold `x8Buf` of `X`, the
items' 32 bytes at `pt`, at a stage whose memory outside the frame is `mem38`. -/
theorem buf_facts (c : Call) (hc : c.Ok) {S : GlobalState} (hb : c.Base S c.mem38)
    (pt : Item → Pointer) (X : Fin 8 → BitVec 256) (buf : Fin 8 → Pointer)
    (hbuf : ∀ j, buf j = if c.X.cand j then pt (c.it j) else c.idp)
    (hX : ∀ j : Fin 8, j.val < c.cnt → X j = c.s.mem.readAt (pt (c.it j)) 256)
    (hpt : ∀ j < c.cnt, Fits c.s.mem (pt (c.it j)) 256 ∧
      ¬(pt (c.it j)).offset.uaddOverflow 32#64 ∧ (pt (c.it j)).id ≠ c.a.results.id)
    (j : Fin 8) :
    Fits S.mem (buf j) 256 ∧ S.mem.readAt (buf j) 256 = x8Buf c.cnt c.S X j ∧
      ¬(buf j).offset.uaddOverflow 32#64 ∧ (buf j).id.id < c.s.alloc.nextFreeBlock := by
  have hcand : c.X.cand j = x8Cand c.cnt c.S j := rfl
  rw [hbuf j, x8Buf, ← hcand]
  by_cases h : c.X.cand j
  · have hj : j.val < c.cnt := by
      by_contra hn
      rw [c.cand_ge' (by omega)] at h
      exact absurd h (by decide)
    obtain ⟨hf, ho, hr⟩ := hpt j hj
    have hlt := hc.wf.id_lt_of_inBounds hf.inBounds
    have hK : (fun b : BlockId => b ≠ c.a.results.id) (pt (c.it j)).id := hr
    have h1 := (MemoryState.StoresOff.storeResults (K := fun b => b ≠ c.a.results.id)
      (m := c.s.mem) (results := c.a.results) (by simp) (fun _ => errSig) c.cnt).sameOn
    have h2 := hb.sameOn
    simp only [h, ite_true]
    refine ⟨h2.fits hlt (h1.fits hK hf), ?_, ho, hlt⟩
    rw [h2.readAt hlt, Call.mem38, h1.readAt hK, hX j hj]
  · simp only [h, Bool.false_eq_true, ite_false]
    refine ⟨hb.idp_fits, hb.idp_read.trans identity_flatBits, by
      simp [Call.idp, BitVec.uaddOverflow], hb.idp_lt⟩

end

/-- `slot_ne`: `p.id ≠ q.id` for two distinct slots, maybe moved on by offsets. -/
macro "slot_ne" : tactic =>
  `(tactic| ((try simp only [Pointer.add_id]); refine GlobalState.slot_id_ne ?_; omega))

/-- `keep_ne`: a slot is outside `DKeep0`/`DKeep1`. -/
macro "keep_ne" : tactic =>
  `(tactic| first
    | assumption
    | exact not_dkeep0 _ (by decide) (by decide) (by decide)
    | exact not_dkeep1 _ (by decide) (by decide) (by decide))

/-- `frame_on`: `m.FrameOn m' K` for `m'` built from a known `FrameOn` by stores, pointer stores
and lifetime starts into slots outside `K`. -/
macro "frame_on" : tactic =>
  `(tactic|
    repeat
      first
      | assumption
      | refine MemoryState.FrameOn.storeAt ?_ (by keep_ne)
      | refine MemoryState.FrameOn.storeVec ?_ (by keep_ne)
      | refine MemoryState.FrameOn.storeFe ?_ (by keep_ne)
      | refine MemoryState.FrameOn.lifetimeStart ?_ (by keep_ne)
      | refine frameOn_storePtr ?_ (by keep_ne))

end MLIR.Firedancer.Lane.VerifyX8.Decode

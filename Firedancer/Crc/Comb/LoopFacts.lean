module

public import MLIR.Run.Tactic
public import Firedancer.Common.Dsmb
public import Firedancer.R52x5.Common.QuadMem

/-! The frame of `fd_r52x5_scalar_mul_base_ct`'s loops:
`e` (64 signed digits), `t` (the selected entry) and `R` (the accumulator) are
its stack slots, `r` the output. `LoopFacts` holds at each loop header and is kept by an
iteration's stores to `t` and `R`. -/

namespace MLIR.Firedancer.Crc

open MLIR.Firedancer

@[expose] public section

/-- The 64 `schar`s `d` at `p`. -/
def DigitsAt (m : MemoryState) (p : Pointer) (d : Vector Int 64) : Prop :=
  ∀ k (hk : k < 64),
    Fits m (p.add (BitVec.ofNat 64 k)) 8 ∧ m.readAt (p.add (BitVec.ofNat 64 k)) 8 = BitVec.ofInt 8 d[k]

end

/-- `DigitsAt` past a point store into another block. -/
theorem DigitsAt.storeQuad5 {m : MemoryState} {q : Pointer} {d : Vector Int 64} (h : DigitsAt m q d)
    (hne : p.id ≠ q.id) : DigitsAt (m.storeQuad5 p P) q d := fun k hk => by
  have h' (c : BitVec 64) : (p.add c).id ≠ (q.add (BitVec.ofNat 64 k)).id := by
    simpa [Pointer.add_id] using hne
  refine ⟨Fits.storeQuad5 (h k hk).1, ?_⟩
  rw [MemoryState.storeQuad5,
    MemoryState.readAt_storeTmp5_of_id_ne (by simpa using h' 0#64) (h' _) (h' _) (h' _) (h' _)]
  exact (h k hk).2

namespace fd_r52x5_scalar_mul_base_ct

@[expose] public section

/-- `fd_r52x5_scalar_mul_base_ct`'s slots: each in its own block, the digits' offsets not wrapping. -/
structure Layout (r t R e : Pointer) : Prop where
  rt : r.id ≠ t.id
  rR : r.id ≠ R.id
  re : r.id ≠ e.id
  tR : t.id ≠ R.id
  te : t.id ≠ e.id
  Re : R.id ≠ e.id
  eo : e.offset.toNat + 64 < 2 ^ 64

/-- What every loop of the comb needs of a state: the point slots fit and are writable, the
output has room, the digits in place. -/
structure LoopFacts (S : GlobalState) (r t R e : Pointer) (d : Vector Int 64) :
    Prop where
  wf : S.WF
  fitR : S.mem.Quad5Fit R
  wrR : Writable S.mem R
  fitT : S.mem.Quad5Fit t
  wrT : Writable S.mem t
  roomR : S.mem.Quad5Room r
  digits : DigitsAt S.mem e d

end

/-- `LoopFacts` after `t` and `R` are stored, the counter advanced. -/
theorem LoopFacts.store {S : GlobalState} (h : LoopFacts S r t R e d)
    (hL : Layout r t R e) (hn : S.alloc.nextFreeBlock ≤ n) :
    LoopFacts ⟨⟨n⟩, (S.mem.storeQuad5 t T).storeQuad5 R R'⟩ r t R e d
    where
  wf := (GlobalState.WF.bump h.wf hn).storeQuad5_mk.storeQuad5_mk
  fitR := h.fitR.storeQuad5.storeQuad5
  wrR := h.wrR.storeQuad5.storeQuad5
  fitT := h.fitT.storeQuad5.storeQuad5
  wrT := h.wrT.storeQuad5.storeQuad5
  roomR := h.roomR.storeQuad5.storeQuad5
  digits := (h.digits.storeQuad5 hL.te).storeQuad5 hL.Re

/-- The `odd` loop's counter `i` at its header: from 1 by 2, exiting at `i ≥ 64`. -/
def odd.Counter (i : Nat) : Prop :=
  1 ≤ i ∧ i ≤ 65 ∧ (i - 1) % 2 = 0

theorem odd.counter_start : odd.Counter 1 := by
  unfold odd.Counter
  omega

theorem odd.counter_step {i : Nat} (h : odd.Counter i) (hi : i < 64) :
    odd.Counter (i + 2) := by
  unfold odd.Counter at h ⊢
  omega

/-- The `dbl` loop's counter `i` at its header: from 0 by 1, exiting at `i ≥ 4`. -/
def dbl.Counter (i : Nat) : Prop :=
  i ≤ 4

theorem dbl.counter_start : dbl.Counter 0 := by
  unfold dbl.Counter
  omega

theorem dbl.counter_step {i : Nat} (h : dbl.Counter i) (hi : i < 4) :
    dbl.Counter (i + 1) := by
  unfold dbl.Counter at h ⊢
  omega

/-- The `even` loop's counter `i` at its header: from 0 by 2, exiting at `i ≥ 64`. -/
def even.Counter (i : Nat) : Prop :=
  i ≤ 64 ∧ i % 2 = 0

theorem even.counter_start : even.Counter 0 := by
  unfold even.Counter
  omega

theorem even.counter_step {i : Nat} (h : even.Counter i) (hi : i < 64) :
    even.Counter (i + 2) := by
  unfold even.Counter at h ⊢
  omega

end fd_r52x5_scalar_mul_base_ct

end MLIR.Firedancer.Crc

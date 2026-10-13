module

public import MLIR.Run.Tactic
public import Firedancer.Common.Memory
public import Agave.Serial.Mlir.IterMut_u8_Zeroize_zeroize

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `<IterMut<u8> as Zeroize>::zeroize` on the iterator at `it` over the `n` bytes at `p`: the
bytes zeroed, the iterator's start advanced to its end `p + n`. -/
def IterMut_u8_Zeroize_zeroize.spec (m : MemoryState) (it p : Pointer) (n : BitVec 64) :
    MemoryState :=
  (m.storeAt p (0#(8 * n.toNat))).storePtr it (p.add n)

end

/-! ## Proof -/

namespace IterMut_u8_Zeroize_zeroize

section Proof

open Memory in
/-- A second pointer store to the same place overwrites the first. -/
theorem storePtr_storePtr_self {m : MemoryState} {p x y : Pointer} :
    (m.storePtr p x).storePtr p y = m.storePtr p y := by
  simp only [MemoryState.storePtr, MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, spliceBits_spliceBits_self, MemoryBlock.mk.injEq, true_and,
    and_true]
  refine ⟨HEq.rfl, HEq.rfl, ?_⟩
  funext o
  simp only [MemoryBlock.clearPtrs, show (0#64 = BitVec.allOnes 64) = False by decide, ↓reduceIte]
  split <;> simp_all <;> omega

/-- A pointer store and a store into another block commute. -/
theorem storeAt_storePtr_comm {m : MemoryState} {p q x : Pointer} {v : BitVec w} (h : q.id ≠ p.id) :
    (m.storePtr p x).storeAt q v = (m.storeAt q v).storePtr p x :=
  MemoryState.modifyBlock_comm (Ne.symm h)

/-- Zero bytes stored at `q`, then one more after them: one store of zeros. -/
theorem storeAt_zero_succ {m : MemoryState} {q : Pointer} (hov : ¬q.offset.uaddOverflow 1#64)
    (j : Nat) :
    (m.storeAt q (0#8)).storeAt (q.add 1#64) (0#(8 * j)) = m.storeAt q (0#(8 * (j + 1))) := by
  rw [MemoryState.storeAt_storeAt_append (k := 1) hov rfl (by decide)]
  have h : 8 * j + 8 = 8 * (j + 1) := by omega
  rw [BitVec.zero_append_zero]
  exact h ▸ rfl

/-- `p + a` and `p + b` are equal iff `a` and `b` are. -/
theorem add_beq_add (p : Pointer) (a b : BitVec 64) : (p.add a == p.add b) = (a == b) := by
  rw [Bool.eq_iff_iff]
  simp [Pointer.add, Pointer.mk.injEq]

/-- The end `p + n` of `n > 0` bytes is not their start. -/
theorem self_ne_add {p : Pointer} {n : BitVec 64} (hn : 0 < n.toNat)
    (hpo : p.offset.toNat + n.toNat < 2 ^ 64) : ¬p = p.add n := by
  intro h
  have := congrArg (·.offset.toNat) h
  simp only [Pointer.add, BitVec.toNat_add] at this
  rw [Nat.mod_eq_of_lt hpo] at this
  omega

/-- The next byte's offset `k + 1`, below the end `n`. -/
theorem succ_eq_iff {k : Nat} {n : BitVec 64} (hk : k + 1 ≤ n.toNat) :
    BitVec.ofNat 64 k + 1#64 = n ↔ k + 1 = n.toNat := by
  rw [← BitVec.ofNat_add, BitVec.toNat_eq, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]

/-- The byte pointer `p + k` steps by one without wrapping. -/
theorem succ_noOverflow {p : Pointer} {k : Nat} {n : BitVec 64} (hk : k + 1 ≤ n.toNat)
    (hpo : p.offset.toNat + n.toNat < 2 ^ 64) :
    ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 1#64 := by
  simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mod_eq_of_lt (by omega)]
  simp
  omega

/-- One iteration's stores, then the rest's: the stores of `j + 2` iterations. -/
theorem iter_mem {m : MemoryState} {it p q : Pointer} {k : Nat}
    (hov : ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 1#64) (hsep : it.id ≠ p.id) (j : Nat) :
    (((m.storePtr it (p.add (BitVec.ofNat 64 k + 1#64))).storeAt (p.add (BitVec.ofNat 64 k))
                (0#8)).storeAt
            (p.add (BitVec.ofNat 64 (k + 1))) (0#(8 * (j + 1)))).storePtr
        it q =
      (m.storeAt (p.add (BitVec.ofNat 64 k)) (0#(8 * (j + 1 + 1)))).storePtr it q := by
  rw [BitVec.ofNat_add, ← Pointer.add_add, storeAt_zero_succ hov,
    storeAt_storePtr_comm (q := p.add _) (Ne.symm hsep), storePtr_storePtr_self]

/-- The loop at `^bb1` on the current byte `p + k`, `j + 1` bytes left to the end `p + n`: zeroes
them and leaves the iterator's start at `p + n`. -/
theorem zero_loop (it p : Pointer) (n : BitVec 64) (K : PoisonOr (Vals [] × GlobalState))
    (hsep : it.id ≠ p.id) (hpo : p.offset.toNat + n.toNat < 2 ^ 64) :
    ∀ j k (S : GlobalState) (E : ⟪Γ⟫),
      k + j + 1 = n.toNat →
        E.args = (args (.value it)).get →
        (E ⊨ [%415 := 0#8, %416 := it.add 8#64, %420 := p.add (BitVec.ofNat 64 k)]) →
        S.WF →
        Room S.mem it 64 →
        InBounds S.mem (it.add 8#64) 64 →
        Room S.mem (p.add (BitVec.ofNat 64 k)) (8 * (j + 1)) →
        S.mem.loadPtr (it.add 8#64) = .value (p.add n) →
        (∀ E' : ⟪Γ⟫,
          E'.args = (args (.value it)).get →
            IterMut_u8_Zeroize_zeroize.runFrom E' 2
                { S with
                  mem :=
                    (S.mem.storeAt (p.add (BitVec.ofNat 64 k)) (0#(8 * (j + 1)))).storePtr it
                      (p.add n) } =
              K) →
        IterMut_u8_Zeroize_zeroize.runFrom E 1 S = K := by
  intro j
  induction j with
  | zero =>
    intro k S E hk hA hR hwf hit hit8 hq hend hK
    block_init
    step_pure
    step_store
    step_store
    step_load
    step_load
    step_pure [add_beq_add]
    finish_block
    case isTrue =>
      subst hS
      rw [storeAt_storePtr_comm (q := p.add _) (Ne.symm hsep), hbr]
      exact hK E hArgs
    case isFalse => exact absurd ((succ_eq_iff (by omega)).2 (by omega)) hbr
  | succ j ih =>
    intro k S E hk hA hR hwf hit hit8 hq hend hK
    have hov := succ_noOverflow (k := k) (by omega) hpo
    have hq8 : Room S.mem (p.add (BitVec.ofNat 64 k)) 8 := hq.mono (by omega)
    block_init
    step_pure
    step_store
    step_store
    step_load
    step_load
    step_pure [add_beq_add]
    finish_block
    case isTrue => exact absurd ((succ_eq_iff (by omega)).1 hbr) (by omega)
    case
      isFalse =>
      have hq' : Room S.mem (p.add (BitVec.ofNat 64 (k + 1))) (8 * (j + 1)) := by
        rw [BitVec.ofNat_add, ← Pointer.add_add]
        exact
          Room.add_of_le hov
            (by
              simp; omega)
            hq
      refine ih (k + 1) S E (by omega) hArgs ?_ hwf hit hit8 hq' hend ?_
      · rw [BitVec.ofNat_add]
        env_reads
      · intro E' hA'
        have e := hK E' hA'
        subst hS
        rw [iter_mem hov hsep]
        exact e

end Proof

end IterMut_u8_Zeroize_zeroize

open IterMut_u8_Zeroize_zeroize in
/-- `<IterMut<u8> as Zeroize>::zeroize` on the iterator at `it` (start `p`, end `p + n` stored at
`it` and `it + 8`) over `n > 0` bytes: zeroes them and leaves the start at `p + n` (`spec`). The
bytes need only room, in another block than `it`. -/
public theorem IterMut_u8_Zeroize_zeroize.call_eq (it p : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hit : Room s.mem it 128) (hio : ¬it.offset.uaddOverflow 16#64)
    (hstart : s.mem.loadPtr it = .value p) (hend : s.mem.loadPtr (it.add 8#64) = .value (p.add n))
    (hp : Room s.mem p (8 * n.toNat)) (hn : 0 < n.toNat) (hpo : p.offset.toNat + n.toNat < 2 ^ 64)
    (hsep : it.id ≠ p.id) :
    IterMut_u8_Zeroize_zeroize.call (IterMut_u8_Zeroize_zeroize.args (.value it)) s =
      .value (.nil, { s with mem := IterMut_u8_Zeroize_zeroize.spec s.mem it p n }) := by
  have hit0 : Room s.mem it 64 := hit.mono (by decide)
  have hit8 : InBounds s.mem (it.add 8#64) 64 :=
    (Room.add_of_le
        (by
          simp [BitVec.uaddOverflow] at hio ⊢; omega)
        (by decide) hit).inBounds
  unfold IterMut_u8_Zeroize_zeroize.spec
  func_init
  block_init
  step_pure
  step_pure
  step_load
  step_load
  step_pure
  finish_block
  case isTrue => exact absurd hbr (self_ne_add hn hpo)
  case
    isFalse =>
    refine
      zero_loop it p n _ hsep hpo (n.toNat - 1) 0 S E (by omega) hArgs ?_ hwf hit0 hit8 ?_ hend ?_
    · rw [Pointer.add_zero]
      env_reads
    · rw [Pointer.add_zero, show n.toNat - 1 + 1 = n.toNat by omega]
      exact hp
    · intro E' hA'
      block_init
      finish_block
      subst hS
      rw [Pointer.add_zero, show n.toNat - 1 + 1 = n.toNat by omega, hv3]

end MLIR.Agave.Serial

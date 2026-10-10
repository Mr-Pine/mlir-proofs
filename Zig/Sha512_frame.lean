module

public import Zig.Sha512_update
import Std.Data.ExtHashMap.Lemmas

/-! `Sha512.update` writes only the object's block: memories that agree off it erase alike. -/

namespace MLIR.Zig

open Sha512_update

/-- `m` and `m'` hold the same blocks other than `b`, and the same unspecified choices. -/
@[expose]
public def SameOff (b : BlockId) (m m' : MemoryState) : Prop :=
  m.unspec = m'.unspec ∧ ∀ k, k ≠ b → m[k]? = m'[k]?

theorem SameOff.refl (b : BlockId) (m : MemoryState) : SameOff b m m :=
  ⟨rfl, fun _ _ => rfl⟩

theorem SameOff.trans {b : BlockId} {m m' m'' : MemoryState} (h : SameOff b m m')
    (h' : SameOff b m' m'') : SameOff b m m'' :=
  ⟨h.1.trans h'.1, fun k hk => (h.2 k hk).trans (h'.2 k hk)⟩

theorem SameOff.storeAt {b : BlockId} {m m' : MemoryState} {p : Pointer} {x : BitVec w}
    (hp : p.id = b) (h : SameOff b m m') : SameOff b (m.storeAt p x) m' :=
  ⟨MemoryState.unspec_storeAt.trans h.1, fun k hk => by
    rw [MemoryState.getElem?_storeAt_ne (p := p) (q := ⟨k, 0⟩)
        (by
          rw [hp]; exact hk)]
    exact h.2 k hk⟩

theorem SameOff.storeWords {d : Pointer} {f : Nat → BitVec 64} :
    ∀ n i {m m' : MemoryState}, SameOff d.id m m' → SameOff d.id (Sha512Obj.storeWords d f i n m) m'
  | 0, _, _, _, h => h
  | n + 1, i, _, _, h => SameOff.storeWords n (i + 1) (SameOff.storeAt (by simp) h)

theorem SameOff.roundState {d p : Pointer} {s : GlobalState} {m' : MemoryState}
    (h : SameOff d.id s.mem m') : SameOff d.id (roundState s d p).mem m' :=
  SameOff.storeWords 8 0 h

theorem SameOff.blocksState {d b : Pointer} :
    ∀ (off c : Nat) {s : GlobalState} {m' : MemoryState},
      SameOff d.id s.mem m' → SameOff d.id (blocksState d b off c s).mem m'
  | _, 0, _, _, h => h
  | off, c + 1, _, _, h => SameOff.blocksState (off + 128) c (SameOff.roundState h)

theorem SameOff.update {s : GlobalState} {d b : Pointer} {n : BitVec 64} :
    SameOff d.id (Sha512_update.post s d b n).mem s.mem := by
  have ht {m m' : MemoryState} {off : Nat} (h : SameOff d.id m m') :
    SameOff d.id (tailMem m d b n off) m' :=
    SameOff.storeAt rfl (SameOff.storeAt (by simp) (SameOff.storeAt (by simp) h))
  unfold Sha512_update.post Sha512_update.fromState
  dsimp only
  split
  · refine ht (SameOff.blocksState _ _ ?_)
    unfold headState
    exact
      SameOff.storeAt (by simp) (SameOff.roundState (SameOff.storeAt (by simp) (SameOff.refl _ _)))
  · exact ht (SameOff.blocksState _ _ (SameOff.refl _ _))

/-- Memories alike off a block at or past `N` erase alike from `N`. -/
public theorem SameOff.eraseFrom {b : BlockId} {m m' : MemoryState} (h : SameOff b m m')
    (hb : N ≤ b.id) : m.eraseFrom N = m'.eraseFrom N := by
  unfold MemoryState.eraseFrom
  congr 1
  · apply Std.ExtHashMap.ext_getElem?
    intro k
    simp only [Std.ExtHashMap.getElem?_filter']
    by_cases hk : k.id < N
    · have hne : k ≠ b := fun e => by
        subst e; omega
      have := h.2 k hne
      simp only [MemoryState.getElem?_eq] at this
      rw [this]
    · simp [hk]
  · exact h.1

/-- `update`'s memory, erased from `N` at or below the object's block: as before it. -/
public theorem post_eraseFrom_of_le {s : GlobalState} {d b : Pointer} {n : BitVec 64}
    (h : N ≤ d.id.id) : (Sha512_update.post s d b n).mem.eraseFrom N = s.mem.eraseFrom N :=
  SameOff.update.eraseFrom h

theorem blocksState_alloc {d b : Pointer} :
    ∀ (off c : Nat) (s : GlobalState),
      (blocksState d b off c s).alloc.nextFreeBlock = s.alloc.nextFreeBlock + 2 * c
  | _, 0, _ => rfl
  | off, c + 1, s => by
    rw [blocksState, blocksState_alloc (off + 128) c]; simp only [roundState]; omega

/-- `update` allocates two blocks per compressed block: `(buf_len + n) / 128` of them. -/
public theorem post_alloc {s : GlobalState} {d b : Pointer} {n : BitVec 64}
    (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128) :
    (Sha512_update.post s d b n).alloc.nextFreeBlock =
      s.alloc.nextFreeBlock + 2 * (((Sha512Obj.bufLen s.mem d).toNat + n.toNat) / 128) := by
  unfold Sha512_update.post Sha512_update.fromState
  dsimp only
  split
  · rename_i h
    rw [blocksState_alloc]
    simp only [headState, roundState]
    have :
      ((n.toNat - (128 - (Sha512Obj.bufLen s.mem d).toNat)) / 128) + 1 =
        ((Sha512Obj.bufLen s.mem d).toNat + n.toNat) / 128 := by
      omega
    omega
  · rename_i h
    rw [blocksState_alloc]
    have : n.toNat / 128 = ((Sha512Obj.bufLen s.mem d).toNat + n.toNat) / 128 := by
      by_cases h0 : Sha512Obj.bufLen s.mem d = 0
      · subst_vars; simp [h0]
      · have : ¬(127 < n.toNat + (Sha512Obj.bufLen s.mem d).toNat) := fun h' => h ⟨h0, h'⟩
        omega
    simp only [Nat.sub_zero]; omega

end MLIR.Zig

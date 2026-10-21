module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
import Std.Data.ExtHashMap.Lemmas

/-! What the proofs of functions with a stack frame share: a run of `alloca`s and the slots it
leaves, the registers a run writes (`Writes`), and the memory below an erased frame. -/

namespace MLIR.Firedancer

@[expose] public section

/-- A register read right after its write, whatever the proofs of its type: no cast to reduce,
which for a register past the `500`th unfolds `Γ`'s types to it (the steps take it as a local
`mlir_env` lemma). -/
theorem read_write_same {Γ : Ctx} {t : Ty} (env : ⟪Γ⟫) (i : Fin Γ.n) (h h' : Γ.ty i = t)
    (v : ⟦t⟧) : (env.write ⟨i, h⟩ v).read (.val i h') = v := by
  subst h
  exact Env.read_write_dst env ⟨i, rfl⟩ v

/-! ### A run of `alloca`s -/

section Allocas

variable {Γ : Ctx}

/-- `alloca`s into `d` of `n` bytes, one per `(d, n)`, dead until their `lifetime.start`s. -/
def allocaRun : List (Dst Γ .ptr × Nat) → List (Instr Γ)
  | [] => []
  | (d, n) :: ds => .alloca d n true :: allocaRun ds

/-- `s` after dead `alloca`s of the sizes `ns`. -/
def allocas (s : GlobalState) : List Nat → GlobalState
  | [] => s
  | n :: ns => allocas (s.alloca n true) ns

/-- `E` with the slots `B.slot k`, `B.slot (k + 1)`, … written to the destinations of `ds`. -/
def writeSlots (E : ⟪Γ⟫) (B : GlobalState) (k : Nat) : List (Dst Γ .ptr × Nat) → ⟪Γ⟫
  | [] => E
  | (d, _) :: ds => writeSlots (E.write d (.value (B.slot k))) B (k + 1) ds

theorem runBodyFrom_allocaRun {blk : BasicBlock Γ tRets bp} {rest : List (Instr Γ)}
    (B : GlobalState) :
    ∀ (ds : List (Dst Γ .ptr × Nat)) (E : ⟪Γ⟫) (s : GlobalState) (pos k : Nat),
      s.alloc.nextFreeBlock = B.alloc.nextFreeBlock + k →
        blk.body.drop pos = allocaRun ds ++ rest →
        blk.runBodyFrom E pos s =
          blk.runBodyFrom (writeSlots E B k ds) (pos + ds.length) (allocas s (ds.map (·.2)))
  | [], E, s, pos, k, _, _ => rfl
  | (d, n) :: ds, E, s, pos, k, hk, hbody => by
    have hb : blk.body.drop pos = .alloca d n true :: (allocaRun ds ++ rest) := hbody
    have hptr : s.allocaPtr = B.slot k := by
      simp only [GlobalState.allocaPtr, GlobalState.slot, hk]; rfl
    rw [BasicBlock.runBodyFrom_step_of_run (List.lt_length_of_drop_eq_cons hb)
        (by
          rw [List.getElem_of_drop_eq_cons hb]; rfl),
      hptr,
      runBodyFrom_allocaRun B ds _ _ (pos + 1) (k + 1)
        (by
          simp [hk]; omega)
        (List.drop_succ_of_drop_eq_cons hb)]
    simp only [writeSlots, allocas, List.length_cons, List.map_cons, Nat.add_assoc, Nat.add_comm 1]

theorem writeSlots_args (B : GlobalState) :
    ∀ (ds : List (Dst Γ .ptr × Nat)) (E : ⟪Γ⟫) (k : Nat), (writeSlots E B k ds).args = E.args
  | [], _, _ => rfl
  | _ :: ds, _, k => (writeSlots_args B ds _ (k + 1)).trans rfl

end Allocas

theorem WF_allocas : ∀ (ns : List Nat) (s : GlobalState), s.WF → (allocas s ns).WF
  | [], _, h => h
  | _ :: ns, _, h => WF_allocas ns _ h.alloca

theorem fits_allocas_of {p : Pointer} {w : Nat} :
    ∀ (ns : List Nat) (s : GlobalState), s.WF → Fits s.mem p w → Fits (allocas s ns).mem p w
  | [], _, _, h => h
  | _ :: ns, _, hwf, h => fits_allocas_of ns _ hwf.alloca (h.alloca hwf)

theorem writable_allocas_of {p : Pointer} :
    ∀ (ns : List Nat) (s : GlobalState), s.WF → Writable s.mem p → Writable (allocas s ns).mem p
  | [], _, _, h => h
  | _ :: ns, _, hwf, h => writable_allocas_of ns _ hwf.alloca (h.alloca hwf)

theorem inBounds_allocas_of {p : Pointer} {w : Nat} :
    ∀ (ns : List Nat) (s : GlobalState), s.WF → InBounds s.mem p w → InBounds (allocas s ns).mem p w
  | [], _, _, h => h
  | _ :: ns, _, hwf, h => inBounds_allocas_of ns _ hwf.alloca (h.alloca hwf)

theorem alloc_allocas :
    ∀ (ns : List Nat) (s : GlobalState),
      (allocas s ns).alloc.nextFreeBlock = s.alloc.nextFreeBlock + ns.length
  | [], _ => rfl
  | _ :: ns, s => by simp [allocas, alloc_allocas ns, Nat.add_assoc, Nat.add_comm 1]

/-- The slots after their `alloca`s, from slot `k` on: each in bounds for its bytes. -/
theorem fits_allocas (B : GlobalState) :
    ∀ (ns : List Nat) (s : GlobalState) (k j : Nat),
      s.WF →
        s.alloc.nextFreeBlock = B.alloc.nextFreeBlock + k →
        j < ns.length → InBounds (allocas s ns).mem (B.slot (k + j)) (8 * ns[j]!)
  | [], _, _, _, _, _, hj => absurd hj (by simp)
  | n :: ns, s, k, j, hwf, hk, hj => by
    simp only [allocas]
    cases j with
    | zero =>
      have : s.allocaPtr = B.slot k := by
        simp only [GlobalState.allocaPtr, GlobalState.slot, hk]; rfl
      simpa [← this] using
        inBounds_allocas_of ns _ hwf.alloca (InBounds.allocaPtr (n := n) (d := true) (le_refl _))
    | succ
      j =>
      have :=
        fits_allocas B ns (s.alloca n true) (k + 1) j hwf.alloca
          (by
            simp [hk]; omega)
          (by simpa using hj)
      simpa [Nat.add_assoc, Nat.add_comm 1] using this

/-- The slots after their `alloca`s, from slot `k` on: each writable. -/
theorem writable_allocas (B : GlobalState) :
    ∀ (ns : List Nat) (s : GlobalState) (k j : Nat),
      s.WF →
        s.alloc.nextFreeBlock = B.alloc.nextFreeBlock + k →
        j < ns.length → Writable (allocas s ns).mem (B.slot (k + j))
  | [], _, _, _, _, _, hj => absurd hj (by simp)
  | n :: ns, s, k, j, hwf, hk, hj => by
    simp only [allocas]
    cases j with
    | zero =>
      have : s.allocaPtr = B.slot k := by
        simp only [GlobalState.allocaPtr, GlobalState.slot, hk]; rfl
      simpa [← this] using
        writable_allocas_of ns _ hwf.alloca (Writable.allocaPtr (n := n) (d := true))
    | succ
      j =>
      have :=
        writable_allocas B ns (s.alloca n true) (k + 1) j hwf.alloca
          (by
            simp [hk]; omega)
          (by simpa using hj)
      simpa [Nat.add_assoc, Nat.add_comm 1] using this

/-- The memory below `n` after `alloca`s from `n` on. -/
theorem eraseFrom_allocas {n : Nat} :
    ∀ (ns : List Nat) (s : GlobalState),
      n ≤ s.alloc.nextFreeBlock → (allocas s ns).mem.eraseFrom n = s.mem.eraseFrom n
  | [], _, _ => rfl
  | _ :: ns, s, h => by
    rw [allocas,
      eraseFrom_allocas ns _
        (by
          simp; omega),
      GlobalState.eraseFrom_alloca_of_le h]

/-! ### Registers a run writes -/

section Writes

variable {Γ : Ctx}

/-- `E` is `E₁` written in the registers `lo … hi - 1` only: the same arguments, the same values
elsewhere. -/
def Writes (E₁ E : ⟪Γ⟫) (lo hi : Nat) : Prop :=
  E.args = E₁.args ∧ ∀ i : Fin Γ.n, (i.val < lo ∨ hi ≤ i.val) → E.vals i = E₁.vals i

theorem Writes.refl (E : ⟪Γ⟫) (lo hi : Nat) : Writes E E lo hi :=
  ⟨rfl, fun _ _ => rfl⟩

theorem Writes.mono {E₁ E : ⟪Γ⟫} (h : Writes E₁ E lo hi) (hlo : lo' ≤ lo := by decide)
    (hhi : hi ≤ hi' := by decide) : Writes E₁ E lo' hi' :=
  ⟨h.1, fun i hi => h.2 i (by omega)⟩

theorem Writes.trans {E₁ E₂ E₃ : ⟪Γ⟫} (h₁ : Writes E₁ E₂ lo hi) (h₂ : Writes E₂ E₃ lo hi) :
    Writes E₁ E₃ lo hi :=
  ⟨h₂.1.trans h₁.1, fun i hi => (h₂.2 i hi).trans (h₁.2 i hi)⟩

theorem Writes.write {E₁ E : ⟪Γ⟫} {d : Dst Γ t} {v : ⟦t⟧} (h : Writes E₁ E lo hi)
    (hd : lo ≤ d.i.val ∧ d.i.val < hi := by decide) : Writes E₁ (E.write d v) lo hi := by
  refine ⟨h.1, fun i hi' => ?_⟩
  have hne : i ≠ d.i := fun he => by subst he; omega
  simp only [Env.write, Env.set, hne, ↓reduceDIte]
  exact h.2 i hi'

theorem Writes.read {E₁ E : ⟪Γ⟫} (h : Writes E₁ E lo hi) {i : Fin Γ.n}
    (hi : i.val < lo ∨ hi ≤ i.val := by decide) {ht : Γ.ty i = t} :
    E.read (.val i ht) = E₁.read (.val i ht) := by simp only [Env.read, h.2 i hi]

end Writes

/-! ### Below an erased frame -/

theorem readAt_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readAt p w = m.readAt p w := by
  simp only [MemoryState.readAt, MemoryState.eraseFrom, MemoryState.getElem?_eq,
    Std.ExtHashMap.getElem?_filter', h, decide_true]
  cases m.mem[p.id]? <;> rfl

theorem readQuad5_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readQuad5 p = m.readQuad5 p := by
  have h' : ∀ o : BitVec 64, (p.add o).id.id < n := fun o => by simpa using h
  simp only [MemoryState.readQuad5, MemoryState.readWv, readAt_eraseFrom_of_lt h,
    readAt_eraseFrom_of_lt (h' _)]

theorem fits_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  refine ⟨b, ?_, hl, hw, hd⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem quad5Fit_of_eraseFrom {m : MemoryState} {p : Pointer} (h : (m.eraseFrom n).Quad5Fit p) :
    m.Quad5Fit p :=
  ⟨h.1, fits_of_eraseFrom h.2.1, fits_of_eraseFrom h.2.2.1, fits_of_eraseFrom h.2.2.2.1,
    fits_of_eraseFrom h.2.2.2.2.1, fits_of_eraseFrom h.2.2.2.2.2⟩

theorem room_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Room (m.eraseFrom n) p w) :
    Room m p w := by
  obtain ⟨b, hb, hl, hw, hwr⟩ := h.block
  refine Room.of_block ?_ hl hw hwr
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem eraseFrom_eraseFrom {m : MemoryState} (h : n ≤ n') :
    (m.eraseFrom n').eraseFrom n = m.eraseFrom n := by
  simp only [MemoryState.eraseFrom]
  congr 1
  ext q v
  simp only [Std.ExtHashMap.getElem?_filter']
  by_cases hq : q.id < n
  · simp [hq, show q.id < n' by omega]
  · simp [hq]

end

end MLIR.Firedancer

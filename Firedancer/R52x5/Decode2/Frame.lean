module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Globals
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Mlir.fd_r52x5_ge_decode2
import Std.Data.ExtHashMap.Lemmas

/-! The frame `fd_r52x5_ge_decode2` works in: its `201` stack slots, allocated in one run, the facts
every block after the entry keeps (`Inv`), and the registers a run writes (`Writes`). -/

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

@[expose] public section

namespace fd_r52x5_ge_decode2

/-- The arguments: `Pa0 … Pa4`, `sa`, `Pb0 … Pb4`, `sb`. -/
abbrev argsOf (Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer) : Vals Γ.args :=
  args (.value Pa0) (.value Pa1) (.value Pa2) (.value Pa3) (.value Pa4) (.value sa) (.value Pb0)
    (.value Pb1) (.value Pb2) (.value Pb3) (.value Pb4) (.value sb)

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

/-! ### Registers the entry writes -/

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

/-! ### The slots -/

/-- The `201` slots of `^bb0`, as allocated: destination and bytes. -/
def slotDsts : List (Dst Γ .ptr × Nat) :=
  List.flatten
    [[(rir_dst% fd_r52x5_ge_decode2.hty 46, 64), (rir_dst% fd_r52x5_ge_decode2.hty 47, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 48, 64), (rir_dst% fd_r52x5_ge_decode2.hty 49, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 50, 64), (rir_dst% fd_r52x5_ge_decode2.hty 51, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 52, 64), (rir_dst% fd_r52x5_ge_decode2.hty 53, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 54, 64), (rir_dst% fd_r52x5_ge_decode2.hty 55, 64)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 56, 64), (rir_dst% fd_r52x5_ge_decode2.hty 57, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 58, 64), (rir_dst% fd_r52x5_ge_decode2.hty 59, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 60, 64), (rir_dst% fd_r52x5_ge_decode2.hty 61, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 62, 64), (rir_dst% fd_r52x5_ge_decode2.hty 63, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 64, 64), (rir_dst% fd_r52x5_ge_decode2.hty 65, 64)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 66, 64), (rir_dst% fd_r52x5_ge_decode2.hty 67, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 68, 64), (rir_dst% fd_r52x5_ge_decode2.hty 69, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 70, 64), (rir_dst% fd_r52x5_ge_decode2.hty 71, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 72, 64), (rir_dst% fd_r52x5_ge_decode2.hty 73, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 74, 64), (rir_dst% fd_r52x5_ge_decode2.hty 75, 64)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 76, 64), (rir_dst% fd_r52x5_ge_decode2.hty 77, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 78, 64), (rir_dst% fd_r52x5_ge_decode2.hty 79, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 80, 32), (rir_dst% fd_r52x5_ge_decode2.hty 81, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 82, 64), (rir_dst% fd_r52x5_ge_decode2.hty 83, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 84, 32), (rir_dst% fd_r52x5_ge_decode2.hty 85, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 86, 32), (rir_dst% fd_r52x5_ge_decode2.hty 87, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 88, 32), (rir_dst% fd_r52x5_ge_decode2.hty 89, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 90, 32), (rir_dst% fd_r52x5_ge_decode2.hty 91, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 92, 32), (rir_dst% fd_r52x5_ge_decode2.hty 93, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 94, 32), (rir_dst% fd_r52x5_ge_decode2.hty 95, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 96, 32), (rir_dst% fd_r52x5_ge_decode2.hty 97, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 98, 32), (rir_dst% fd_r52x5_ge_decode2.hty 99, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 100, 32), (rir_dst% fd_r52x5_ge_decode2.hty 101, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 102, 32), (rir_dst% fd_r52x5_ge_decode2.hty 103, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 104, 32), (rir_dst% fd_r52x5_ge_decode2.hty 105, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 106, 32), (rir_dst% fd_r52x5_ge_decode2.hty 107, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 108, 32), (rir_dst% fd_r52x5_ge_decode2.hty 109, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 110, 32), (rir_dst% fd_r52x5_ge_decode2.hty 111, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 112, 32), (rir_dst% fd_r52x5_ge_decode2.hty 113, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 114, 32), (rir_dst% fd_r52x5_ge_decode2.hty 115, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 116, 32), (rir_dst% fd_r52x5_ge_decode2.hty 117, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 118, 32), (rir_dst% fd_r52x5_ge_decode2.hty 119, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 120, 32), (rir_dst% fd_r52x5_ge_decode2.hty 121, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 122, 32), (rir_dst% fd_r52x5_ge_decode2.hty 123, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 124, 32), (rir_dst% fd_r52x5_ge_decode2.hty 125, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 126, 32), (rir_dst% fd_r52x5_ge_decode2.hty 127, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 128, 32), (rir_dst% fd_r52x5_ge_decode2.hty 129, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 130, 32), (rir_dst% fd_r52x5_ge_decode2.hty 131, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 132, 32), (rir_dst% fd_r52x5_ge_decode2.hty 133, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 134, 32), (rir_dst% fd_r52x5_ge_decode2.hty 135, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 136, 32), (rir_dst% fd_r52x5_ge_decode2.hty 137, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 138, 32), (rir_dst% fd_r52x5_ge_decode2.hty 139, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 140, 32), (rir_dst% fd_r52x5_ge_decode2.hty 141, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 142, 32), (rir_dst% fd_r52x5_ge_decode2.hty 143, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 144, 32), (rir_dst% fd_r52x5_ge_decode2.hty 145, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 146, 32), (rir_dst% fd_r52x5_ge_decode2.hty 147, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 148, 32), (rir_dst% fd_r52x5_ge_decode2.hty 149, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 150, 32), (rir_dst% fd_r52x5_ge_decode2.hty 151, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 152, 32), (rir_dst% fd_r52x5_ge_decode2.hty 153, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 154, 32), (rir_dst% fd_r52x5_ge_decode2.hty 155, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 156, 32), (rir_dst% fd_r52x5_ge_decode2.hty 157, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 158, 32), (rir_dst% fd_r52x5_ge_decode2.hty 159, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 160, 32), (rir_dst% fd_r52x5_ge_decode2.hty 161, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 162, 32), (rir_dst% fd_r52x5_ge_decode2.hty 163, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 164, 32), (rir_dst% fd_r52x5_ge_decode2.hty 165, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 166, 32), (rir_dst% fd_r52x5_ge_decode2.hty 167, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 168, 32), (rir_dst% fd_r52x5_ge_decode2.hty 169, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 170, 32), (rir_dst% fd_r52x5_ge_decode2.hty 171, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 172, 32), (rir_dst% fd_r52x5_ge_decode2.hty 173, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 174, 32), (rir_dst% fd_r52x5_ge_decode2.hty 175, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 176, 32), (rir_dst% fd_r52x5_ge_decode2.hty 177, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 178, 32), (rir_dst% fd_r52x5_ge_decode2.hty 179, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 180, 32), (rir_dst% fd_r52x5_ge_decode2.hty 181, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 182, 32), (rir_dst% fd_r52x5_ge_decode2.hty 183, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 184, 32), (rir_dst% fd_r52x5_ge_decode2.hty 185, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 186, 32), (rir_dst% fd_r52x5_ge_decode2.hty 187, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 188, 32), (rir_dst% fd_r52x5_ge_decode2.hty 189, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 190, 32), (rir_dst% fd_r52x5_ge_decode2.hty 191, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 192, 32), (rir_dst% fd_r52x5_ge_decode2.hty 193, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 194, 32), (rir_dst% fd_r52x5_ge_decode2.hty 195, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 196, 32), (rir_dst% fd_r52x5_ge_decode2.hty 197, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 198, 32), (rir_dst% fd_r52x5_ge_decode2.hty 199, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 200, 32), (rir_dst% fd_r52x5_ge_decode2.hty 201, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 202, 32), (rir_dst% fd_r52x5_ge_decode2.hty 203, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 204, 32), (rir_dst% fd_r52x5_ge_decode2.hty 205, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 206, 32), (rir_dst% fd_r52x5_ge_decode2.hty 207, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 208, 32), (rir_dst% fd_r52x5_ge_decode2.hty 209, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 210, 32), (rir_dst% fd_r52x5_ge_decode2.hty 211, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 212, 32), (rir_dst% fd_r52x5_ge_decode2.hty 213, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 214, 32), (rir_dst% fd_r52x5_ge_decode2.hty 215, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 216, 32), (rir_dst% fd_r52x5_ge_decode2.hty 217, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 218, 32), (rir_dst% fd_r52x5_ge_decode2.hty 219, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 220, 32), (rir_dst% fd_r52x5_ge_decode2.hty 221, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 222, 32), (rir_dst% fd_r52x5_ge_decode2.hty 223, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 224, 32), (rir_dst% fd_r52x5_ge_decode2.hty 225, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 226, 32), (rir_dst% fd_r52x5_ge_decode2.hty 227, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 228, 32), (rir_dst% fd_r52x5_ge_decode2.hty 229, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 230, 32), (rir_dst% fd_r52x5_ge_decode2.hty 231, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 232, 32), (rir_dst% fd_r52x5_ge_decode2.hty 233, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 234, 32), (rir_dst% fd_r52x5_ge_decode2.hty 235, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 236, 32), (rir_dst% fd_r52x5_ge_decode2.hty 237, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 238, 32), (rir_dst% fd_r52x5_ge_decode2.hty 239, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 240, 64), (rir_dst% fd_r52x5_ge_decode2.hty 241, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 242, 64), (rir_dst% fd_r52x5_ge_decode2.hty 243, 64),
        (rir_dst% fd_r52x5_ge_decode2.hty 244, 64), (rir_dst% fd_r52x5_ge_decode2.hty 245, 64)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 246, 64)]]

theorem bb0_slots : bb0.body.drop 46 = allocaRun slotDsts ++ bb0.body.drop 247 :=
  rir_rfl%

/-- The bytes of the frame's slot `j` (`B.slot j` for the entry state `B`; slots `0 … 2` are the
globals): `34` field elements, the two copies `buf2a buf2b`, the arrays `ea eb`, `155` QUAD
temporaries `wl_t`, the `8` arrays of the two `FD_R52X5_QUAD_PACK`s. -/
def slotBytes (j : Nat) : Nat :=
  if j < 37 then 64 else if j < 39 then 32 else if j < 41 then 64 else if j < 196 then 32 else 64

/-- The sizes of `slotDsts`, slot by slot. -/
theorem slotDsts_sizes : slotDsts.map (·.2) = (List.range' 3 201).map slotBytes :=
  rir_rfl%

/-- Every frame slot of `B` is in bounds for its bytes, the field elements' (slots `3 … 36`, live
from the entry to the return) live. -/
def Frame (B : GlobalState) (m : MemoryState) : Prop :=
  (∀ j, 3 ≤ j → j < 204 → InBounds m (B.slot j) (8 * slotBytes j)) ∧
    ∀ j, 3 ≤ j → j < 37 → Room m (B.slot j) 512

theorem Frame.vec {B : GlobalState} {m : MemoryState} (h : Frame B m) (j : Nat)
    (hj : 3 ≤ j ∧ j < 37 := by decide) : Room m (B.slot j) 512 :=
  h.2 j hj.1 hj.2

theorem Frame.arr {B : GlobalState} {m : MemoryState} (h : Frame B m) (j : Nat)
    (hj : 39 ≤ j ∧ j < 41 ∨ 196 ≤ j ∧ j < 204 := by decide) : InBounds m (B.slot j) 512 := by
  have := h.1 j (by omega) (by omega)
  unfold slotBytes at this
  split_ifs at this <;>
    first
    | exact this
    | omega

theorem Frame.tmp {B : GlobalState} {m : MemoryState} (h : Frame B m) (j : Nat)
    (hj : 37 ≤ j ∧ j < 39 ∨ 41 ≤ j ∧ j < 196 := by decide) : InBounds m (B.slot j) 256 := by
  have := h.1 j (by omega) (by omega)
  unfold slotBytes at this
  split_ifs at this <;>
    first
    | exact this
    | omega

theorem Frame.of {B : GlobalState} {m m' : MemoryState}
    (hb : ∀ p w, InBounds m p w → InBounds m' p w)
    (hr : ∀ j, 3 ≤ j → j < 37 → Room m (B.slot j) 512 → Room m' (B.slot j) 512) (h : Frame B m) :
    Frame B m' :=
  ⟨fun j h3 hj => hb _ _ (h.1 j h3 hj), fun j h3 hj => hr j h3 hj (h.2 j h3 hj)⟩

@[mlir_transport]
theorem Frame.storeAt {B : GlobalState} {m : MemoryState} {x : BitVec w} (h : Frame B m) :
    Frame B (m.storeAt p x) :=
  h.of (fun _ _ => InBounds.storeAt) fun _ _ _ => Room.storeAt

@[mlir_transport]
theorem Frame.storeVec {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeVec p v) :=
  h.of (fun _ _ => InBounds.storeVec) fun _ _ _ => Room.storeVec

@[mlir_transport]
theorem Frame.storeTmp5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.storeTmp5) fun _ _ _ => Room.storeTmp5

/-- A slot past the field elements' started: the frame kept. The slot as `k + 37`, which unifies
with a literal. -/
@[mlir_transport]
theorem Frame.lifetimeStart_slot {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeStart (B.slot (k + 37))) :=
  h.of (fun _ _ => InBounds.lifetimeStart) fun _ _ hj hr =>
    hr.lifetimeStart (GlobalState.slot_id_ne (by omega))

/-- A slot past the field elements' ended: the frame kept. -/
@[mlir_transport]
theorem Frame.lifetimeEnd_slot {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeEnd (B.slot (k + 37))) :=
  h.of (fun _ _ => InBounds.lifetimeEnd) fun _ _ hj hr =>
    hr.lifetimeEnd (GlobalState.slot_id_ne (by omega))

/-- A call's temporaries in slots past the field elements: the frame kept. -/
@[mlir_transport]
theorem Frame.callTmp5_slots {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B
      (m.callTmp5 (B.slot (k0 + 37)) (B.slot (k1 + 37)) (B.slot (k2 + 37)) (B.slot (k3 + 37))
        (B.slot (k4 + 37)) Q) :=
  h.of (fun _ _ => InBounds.callTmp5) fun _ _ hj hr =>
    hr.callTmp5 (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega))

theorem WF_allocas : ∀ (ns : List Nat) (s : GlobalState), s.WF → (allocas s ns).WF
  | [], _, h => h
  | _ :: ns, _, h => WF_allocas ns _ h.alloca

theorem fits_allocas_of {p : Pointer} {w : Nat} :
    ∀ (ns : List Nat) (s : GlobalState), s.WF → Fits s.mem p w → Fits (allocas s ns).mem p w
  | [], _, _, h => h
  | _ :: ns, _, hwf, h => fits_allocas_of ns _ hwf.alloca (h.alloca hwf)

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

/-- The slots' sizes. -/
abbrev slotSizes : List Nat :=
  (List.range' 3 201).map slotBytes

/-- `^bb0`'s `alloca`s: the slots of `B`, its counter at `s`'s, in their destinations. -/
theorem bb0_allocas {E : ⟪Γ⟫} {s B : GlobalState}
    (hs : s.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 3) :
    bb0.runBodyFrom E 46 s =
      bb0.runBodyFrom (writeSlots E B 3 slotDsts) 247 (allocas s slotSizes) := by
  rw [runBodyFrom_allocaRun B _ _ _ _ 3 hs bb0_slots, slotDsts_sizes,
    show 46 + slotDsts.length = 247 from rir_rfl%]

/-- The field elements' slots `B.slot 3 … B.slot 36` started, as `^bb0`'s `lifetime.start`s. -/
def startFields (m : MemoryState) (B : GlobalState) : MemoryState :=
  (List.range' 3 34).foldl (fun m j => m.lifetimeStart (B.slot j)) m

theorem inBounds_startFields_of {m : MemoryState} {B : GlobalState} (h : InBounds m p w) :
    InBounds (startFields m B) p w := by
  unfold startFields
  generalize List.range' 3 34 = l
  induction l generalizing m with
  | nil => exact h
  | cons j l ih => exact ih h.lifetimeStart

theorem room_foldl_start {m : MemoryState} {B : GlobalState} {l : List Nat} (hj : j ∉ l)
    (h : Room m (B.slot j) w) :
    Room (l.foldl (fun m k => m.lifetimeStart (B.slot k)) m) (B.slot j) w := by
  induction l generalizing m with
  | nil => exact h
  | cons k l ih =>
    simp only [List.mem_cons, not_or] at hj
    exact ih hj.2 (h.lifetimeStart (GlobalState.slot_id_ne hj.1))

theorem room_foldl_start_mem {m : MemoryState} {B : GlobalState} {l : List Nat} (hl : l.Nodup)
    (hj : j ∈ l) (h : InBounds m (B.slot j) w) :
    Room (l.foldl (fun m k => m.lifetimeStart (B.slot k)) m) (B.slot j) w := by
  induction l generalizing m with
  | nil => simp at hj
  | cons k l ih =>
    simp only [List.foldl_cons]
    rcases List.mem_cons.1 hj with rfl | hj'
    · exact room_foldl_start (List.nodup_cons.1 hl).1 (Room.lifetimeStart_self h)
    · exact ih (List.nodup_cons.1 hl).2 hj' h.lifetimeStart

theorem room_startFields {m : MemoryState} {B : GlobalState} (hj : 3 ≤ j ∧ j < 37)
    (h : InBounds m (B.slot j) w) : Room (startFields m B) (B.slot j) w :=
  room_foldl_start_mem List.nodup_range' (List.mem_range'_1.2 (by omega)) h

/-- `^bb0`'s `lifetime.start`s of the field elements, `247` to `281`. -/
theorem starts_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hR :
      E ⊨ [rir_reg% hty 46 := B.slot 3, rir_reg% hty 47 := B.slot 4, rir_reg% hty 48 := B.slot 5,
        rir_reg% hty 49 := B.slot 6, rir_reg% hty 50 := B.slot 7, rir_reg% hty 51 := B.slot 8,
        rir_reg% hty 52 := B.slot 9, rir_reg% hty 53 := B.slot 10, rir_reg% hty 54 := B.slot 11,
        rir_reg% hty 55 := B.slot 12, rir_reg% hty 56 := B.slot 13, rir_reg% hty 57 := B.slot 14,
        rir_reg% hty 58 := B.slot 15, rir_reg% hty 59 := B.slot 16, rir_reg% hty 60 := B.slot 17,
        rir_reg% hty 61 := B.slot 18, rir_reg% hty 62 := B.slot 19, rir_reg% hty 63 := B.slot 20,
        rir_reg% hty 64 := B.slot 21, rir_reg% hty 65 := B.slot 22, rir_reg% hty 66 := B.slot 23,
        rir_reg% hty 67 := B.slot 24, rir_reg% hty 68 := B.slot 25, rir_reg% hty 69 := B.slot 26,
        rir_reg% hty 70 := B.slot 27, rir_reg% hty 71 := B.slot 28, rir_reg% hty 72 := B.slot 29,
        rir_reg% hty 73 := B.slot 30, rir_reg% hty 74 := B.slot 31, rir_reg% hty 75 := B.slot 32,
        rir_reg% hty 76 := B.slot 33, rir_reg% hty 77 := B.slot 34, rir_reg% hty 78 := B.slot 35,
        rir_reg% hty 79 := B.slot 36])
    (hK : (bb0.runBodyFrom E 281 { S with mem := startFields S.mem B } >>= g) = K) :
    (bb0.runBodyFrom E 247 S >>= g) = K := by
  iterate 34 step_pure
  rw [hS]
  exact hK

/-- The slots after their `alloca`s and the field elements' starts: the frame. -/
theorem frame_allocas {s B : GlobalState} (hwf : s.WF)
    (hs : s.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 3) :
    Frame B (startFields (allocas s slotSizes).mem B) := by
  have hb (j : Nat) (h3 : 3 ≤ j) (hj : j < 204) :
    InBounds (allocas s slotSizes).mem (B.slot j) (8 * slotBytes j) := by
    have :=
      fits_allocas B slotSizes s 3 (j - 3) hwf hs
        (by
          simp; omega)
    simpa [show 3 + (j - 3) = j by omega, List.getElem!_eq_getElem?_getD, List.getElem?_range',
      show j - 3 < 201 by omega] using this
  refine ⟨fun j h3 hj => inBounds_startFields_of (hb j h3 hj), fun j h3 hj => ?_⟩
  have := hb j h3 (by omega)
  rw [show slotBytes j = 64 by simp [slotBytes, show j < 37 by omega]] at this
  exact room_startFields ⟨h3, hj⟩ this

/-! ### Field elements past other writes -/

@[mlir_state, mlir_read]
theorem readVec_storeAt_of_id_ne {m : MemoryState} {x : BitVec w} (h : q.id ≠ p.id) :
    (m.storeAt q x).readVec p = m.readVec p := by
  rw [MemoryState.readVec, MemoryState.readVec, MemoryState.readAt_storeAt_disjoint]
  simp [Range.Disjoint, Range.of, h]

@[mlir_state, mlir_read]
theorem readVec_storeTmp5_of_id_ne {m : MemoryState} {Q : Quad5} (h0 : t0.id ≠ p.id)
    (h1 : t1.id ≠ p.id) (h2 : t2.id ≠ p.id) (h3 : t3.id ≠ p.id) (h4 : t4.id ≠ p.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readVec p = m.readVec p := by
  simp only [MemoryState.readVec, MemoryState.readAt_storeTmp5_of_id_ne h0 h1 h2 h3 h4]

@[mlir_state, mlir_read]
theorem readVec_callTmp5_of_id_ne {m : MemoryState} {Q : Quad5} (h0 : t0.id ≠ p.id)
    (h1 : t1.id ≠ p.id) (h2 : t2.id ≠ p.id) (h3 : t3.id ≠ p.id) (h4 : t4.id ≠ p.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).readVec p = m.readVec p := by
  simp only [MemoryState.readVec, MemoryState.readAt_callTmp5_of_id_ne h0 h1 h2 h3 h4]

/-- Lane `0` of packed 64-bit lanes, as a load of the first `i64` gives it. -/
theorem setWidth_packLanes (v : Vector (BitVec 64) (n + 1)) :
    (BitVec.packLanes v).setWidth 64 = v[0] := by
  have h := BitVec.extractLsb'_packLanes v 0 (by omega)
  rw [Nat.zero_mul] at h
  rw [BitVec.setWidth_eq_extractLsb' (by omega), h]

/-- Four lanes inserted into a poison vector: `wl a b c d`. -/
theorem insert4_eq (a b c d : BitVec 64) (h0 h1 h2 h3) :
    ((((Vector.replicate 4 (PoisonOr.poison : PoisonOr (BitVec 64))).set 0 (.value a) h0).set 1
                (.value b) h1).set
            2 (.value c) h2).set
        3 (.value d) h3 =
      (Ty.wrap (wl a b c d) : ⟦Ty.vec 4 64⟧) := by
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [Ty.wrap_vec, wl]

/-- The env after `^bb0`'s entry: its constants over `E₀`, the globals `B.slot 0 … 2`, the
slots. -/
def entryEnv (E₀ : ⟪Γ⟫) (B : GlobalState) : ⟪Γ⟫ :=
  writeSlots
    (E₀[%1547 := Ty.wrap #v[1#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64], %1548 :=
      PoisonOr.value (B.slot 0), %1549 := PoisonOr.value 4294967294#32, %1550 :=
      PoisonOr.value 4294967295#32, %1551 := Ty.wrap (Vector.replicate 4 0#64), %1552 :=
      Ty.wrap #v[0#64, 1#64, 1#64, 0#64], %1560 := PoisonOr.value 1#32, %1561 :=
      PoisonOr.value 32#64, %1562 := PoisonOr.value 127#8, %1563 := PoisonOr.value (B.slot 1),
      %1564 := PoisonOr.value (B.slot 2), %1565 := Vector.replicate 4 PoisonOr.poison, %1566 :=
      PoisonOr.value 0#64, %1567 := PoisonOr.value 1#64, %1568 := PoisonOr.value 2#64, %1569 :=
      PoisonOr.value 3#64, %1570 := Ty.wrap (Vector.replicate 4 51#64), %1571 :=
      Ty.wrap (Vector.replicate 4 2251799813685247#64), %1572 := Ty.wrap (Vector.replicate 4 19#64),
      %1573 := PoisonOr.value 20#32, %1574 := PoisonOr.value 50#32, %1575 := PoisonOr.value 100#32,
      %1576 := PoisonOr.value 7#8, %1580 := PoisonOr.value 0#32, %1584 :=
      ((((Vector.replicate 4 PoisonOr.poison).set 0 (PoisonOr.value 2251799813685247#64)
                    (by decide)).set
                1 (PoisonOr.value 2251799813685247#64) (by decide)).set
            2 PoisonOr.poison (by decide)).set
        3 PoisonOr.poison (by decide),
      %1592 :=
      (((Vector.replicate 8 PoisonOr.poison).set 5 (PoisonOr.value 0#64) (by decide)).set 6
            (PoisonOr.value 0#64) (by decide)).set
        7 (PoisonOr.value 0#64) (by decide)])
    B 3 slotDsts

/-- 512 bits read are the lanes `readVec` takes from them, packed. -/
theorem readAt_eq_packLanes_readVec {m : MemoryState} {p : Pointer} :
    m.readAt p 512 = BitVec.packLanes (m.readVec p) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := BitVec.extractLsb'_packLanes (m.readVec p) (i / 64) (by omega)
  have hb := congrArg (fun y => y.getLsbD (i % 64)) hk
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega] at hb
  rw [hb]
  simp only [MemoryState.readVec, Vector.getElem_ofFn, Ty.extractVecElem_eq,
    BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega]

/-! ### The state after the entry -/

theorem readAt_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readAt p w = m.readAt p w := by
  simp only [MemoryState.readAt, MemoryState.eraseFrom, MemoryState.getElem?_eq,
    Std.ExtHashMap.getElem?_filter', h, decide_true]
  cases m.mem[p.id]? <;> rfl

theorem eraseFrom_eraseFrom {m : MemoryState} (h : n ≤ n') :
    (m.eraseFrom n').eraseFrom n = m.eraseFrom n := by
  simp only [MemoryState.eraseFrom, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_filter']
  cases m.mem[k]? <;> simp only [Option.filter_none, Option.filter_some]
  by_cases hk : k.id < n
  · simp [hk, show k.id < n' by omega]
  · simp [hk]

/-- The state at each point after the entry: well-formed, the frame's slots fit, below the frame
(`B`'s blocks and the globals') still `M`, and the counter `c` blocks past the frame. -/
structure Inv (B : GlobalState) (M : MemoryState) (c : Nat) (S : GlobalState) : Prop where
  wf : S.WF
  frame : Frame B S.mem
  erase : S.mem.eraseFrom (B.alloc.nextFreeBlock + 3) = M
  alloc : S.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 204 + c

/-- A block below the frame is none of its slots. -/
theorem ne_slot {B : GlobalState} {p : Pointer} (h : p.id.id < B.alloc.nextFreeBlock + 3)
    (hj : 3 ≤ j := by decide) : p.id ≠ (B.slot j).id := fun he => by
  have := congrArg BlockId.id he
  simp at this
  omega

/-- Below the frame, `S` reads as `M`. -/
theorem Inv.readAt {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hp : p.id.id < B.alloc.nextFreeBlock + 3) : S.mem.readAt p w = M.readAt p w := by
  rw [← h.erase, readAt_eraseFrom_of_lt hp]

/-- `Inv.readAt` for a field element. -/
theorem Inv.readVec {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hp : p.id.id < B.alloc.nextFreeBlock + 3) : S.mem.readVec p = M.readVec p := by
  simp only [MemoryState.readVec, h.readAt hp]

theorem fits_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  refine ⟨b, ?_, hl, hw, hd⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

/-- Below the frame, what fits in `M` fits in `S`. -/
theorem Inv.fits {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : Fits M p w) : Fits S.mem p w :=
  fits_of_eraseFrom (h.erase ▸ hf)

theorem room_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Room (m.eraseFrom n) p w) :
    Room m p w := by
  obtain ⟨b, hb, hl, hw⟩ := h
  refine ⟨b, ?_, hl, hw⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

/-- Below the frame, room in `M` is room in `S`. -/
theorem Inv.room {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : Room M p w) : Room S.mem p w :=
  room_of_eraseFrom (h.erase ▸ hf)

/-! Writes into the frame, dropped below it. -/

theorem eraseFrom_storeVec_slot {B : GlobalState} {m : MemoryState} {v : Wwl} (hj : 3 ≤ j) :
    (m.storeVec (B.slot j) v).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_storeVec_of_le
    (by
      simp; omega)

theorem eraseFrom_storeAt_slot {B : GlobalState} {m : MemoryState} {x : BitVec w} (hj : 3 ≤ j) :
    (m.storeAt (B.slot j) x).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_storeAt_of_le
    (by
      simp; omega)

theorem eraseFrom_storeAt_slot_add {B : GlobalState} {m : MemoryState} {x : BitVec w}
    {o : BitVec 64} (hj : 3 ≤ j) :
    (m.storeAt ((B.slot j).add o) x).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_storeAt_of_le
    (by
      simp [Pointer.add]; omega)

theorem eraseFrom_lifetimeStart_slot {B : GlobalState} {m : MemoryState} (hj : 3 ≤ j) :
    (m.lifetimeStart (B.slot j)).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_lifetimeStart_of_le
    (by
      simp; omega)

theorem eraseFrom_lifetimeEnd_slot {B : GlobalState} {m : MemoryState} (hj : 3 ≤ j) :
    (m.lifetimeEnd (B.slot j)).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_lifetimeEnd_of_le
    (by
      simp; omega)

theorem WF_startFields {s : GlobalState} {B : GlobalState} (h : s.WF) :
    ({ s with mem := startFields s.mem B } : GlobalState).WF := by
  unfold startFields
  generalize List.range' 3 34 = l
  induction l generalizing s with
  | nil => exact h
  | cons j l ih => exact ih (s := { s with mem := s.mem.lifetimeStart (B.slot j) }) h.lifetimeStart

theorem fits_startFields_of {m : MemoryState} {B : GlobalState} (h : Fits m p w)
    (hp : p.id.id < B.alloc.nextFreeBlock + 3) : Fits (startFields m B) p w := by
  unfold startFields
  have hl : ∀ j ∈ List.range' 3 34, 3 ≤ j := fun j hj => (List.mem_range'_1.1 hj).1
  generalize List.range' 3 34 = l at hl
  induction l generalizing m with
  | nil => exact h
  | cons j l ih =>
    exact ih (h.lifetimeStart (ne_slot hp (hl j (by simp)))) fun k hk => hl k (by simp [hk])

theorem eraseFrom_startFields {B : GlobalState} {m : MemoryState} :
    (startFields m B).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) := by
  unfold startFields
  have hl : ∀ j ∈ List.range' 3 34, 3 ≤ j := fun j hj => (List.mem_range'_1.1 hj).1
  generalize List.range' 3 34 = l at hl
  induction l generalizing m with
  | nil => rfl
  | cons j l ih =>
    rw [List.foldl_cons, ih fun k hk => hl k (by simp [hk]),
      eraseFrom_lifetimeStart_slot (hl j (by simp))]

theorem eraseFrom_callTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} (h0 : 3 ≤ j0)
    (h1 : 3 ≤ j1) (h2 : 3 ≤ j2) (h3 : 3 ≤ j3) (h4 : 3 ≤ j4) :
    (m.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_callTmp5_of_le
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)

theorem eraseFrom_storeTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} (h0 : 3 ≤ j0)
    (h1 : 3 ≤ j1) (h2 : 3 ≤ j2) (h3 : 3 ≤ j3) (h4 : 3 ≤ j4) :
    (m.storeTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_storeTmp5_of_le
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)
    (by
      simp; omega)

/-- `^bb13`'s `lifetime.end`s: the copies' and field elements' slots, `B.slot 38` first. -/
def endFields (m : MemoryState) (B : GlobalState) : MemoryState :=
  (List.range' 3 36).foldr (fun j m => m.lifetimeEnd (B.slot j)) m

theorem eraseFrom_endFields {B : GlobalState} {m : MemoryState} :
    (endFields m B).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) := by
  unfold endFields
  have hl : ∀ j ∈ List.range' 3 36, 3 ≤ j := fun j hj => (List.mem_range'_1.1 hj).1
  generalize List.range' 3 36 = l at hl
  induction l with
  | nil => rfl
  | cons j l ih =>
    rw [List.foldr_cons, eraseFrom_lifetimeEnd_slot (hl j (by simp)),
      ih fun k hk => hl k (by simp [hk])]

/-- The slots `^bb13` ends, in the registers. -/
abbrev EndRegs (B : GlobalState) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% hty 46 := B.slot 3, rir_reg% hty 47 := B.slot 4, rir_reg% hty 48 := B.slot 5,
    rir_reg% hty 49 := B.slot 6, rir_reg% hty 50 := B.slot 7, rir_reg% hty 51 := B.slot 8,
    rir_reg% hty 52 := B.slot 9, rir_reg% hty 53 := B.slot 10, rir_reg% hty 54 := B.slot 11,
    rir_reg% hty 55 := B.slot 12, rir_reg% hty 56 := B.slot 13, rir_reg% hty 57 := B.slot 14,
    rir_reg% hty 58 := B.slot 15, rir_reg% hty 59 := B.slot 16, rir_reg% hty 60 := B.slot 17,
    rir_reg% hty 61 := B.slot 18, rir_reg% hty 62 := B.slot 19, rir_reg% hty 63 := B.slot 20,
    rir_reg% hty 64 := B.slot 21, rir_reg% hty 65 := B.slot 22, rir_reg% hty 66 := B.slot 23,
    rir_reg% hty 67 := B.slot 24, rir_reg% hty 68 := B.slot 25, rir_reg% hty 69 := B.slot 26,
    rir_reg% hty 70 := B.slot 27, rir_reg% hty 71 := B.slot 28, rir_reg% hty 72 := B.slot 29,
    rir_reg% hty 73 := B.slot 30, rir_reg% hty 74 := B.slot 31, rir_reg% hty 75 := B.slot 32,
    rir_reg% hty 76 := B.slot 33, rir_reg% hty 77 := B.slot 34, rir_reg% hty 78 := B.slot 35,
    rir_reg% hty 79 := B.slot 36, rir_reg% hty 80 := B.slot 37, rir_reg% hty 81 := B.slot 38]

/-- `m'` holds `m`'s field elements, copies and arrays (slots `3 … 40`), known where they were:
only QUAD temporaries written in between. -/
def Keeps (B : GlobalState) (m m' : MemoryState) : Prop :=
  ∀ j,
    3 ≤ j →
      j < 41 →
      m'.readVec (B.slot j) = m.readVec (B.slot j) ∧
        (Fits m (B.slot j) 512 → Fits m' (B.slot j) 512)

theorem Keeps.refl (B : GlobalState) (m : MemoryState) : Keeps B m m := fun _ _ _ => ⟨rfl, id⟩

theorem Keeps.trans {B : GlobalState} {m₁ m₂ m₃ : MemoryState} (h₁ : Keeps B m₁ m₂)
    (h₂ : Keeps B m₂ m₃) : Keeps B m₁ m₃ := fun j h3 hj =>
  ⟨(h₂ j h3 hj).1.trans (h₁ j h3 hj).1, fun h => (h₂ j h3 hj).2 ((h₁ j h3 hj).2 h)⟩

/-- Five temporaries stored: the field elements kept. -/
theorem Keeps.storeTmp5 {B : GlobalState} {m m' : MemoryState} (h : Keeps B m m') {Q : Quad5}
    (j0 j1 j2 j3 j4 : Nat) (h0 : 41 ≤ j0) (h1 : 41 ≤ j1) (h2 : 41 ≤ j2) (h3 : 41 ≤ j3)
    (h4 : 41 ≤ j4) :
    Keeps B m (m'.storeTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q) := by
  intro j h3' hj
  refine ⟨?_, fun hf => ((h j h3' hj).2 hf).storeTmp5⟩
  rw [readVec_storeTmp5_of_id_ne (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))]
  exact (h j h3' hj).1

/-- A call's five temporaries: the field elements kept. -/
theorem Keeps.callTmp5 {B : GlobalState} {m m' : MemoryState} (h : Keeps B m m') {Q : Quad5}
    (j0 j1 j2 j3 j4 : Nat) (h0 : 41 ≤ j0) (h1 : 41 ≤ j1) (h2 : 41 ≤ j2) (h3 : 41 ≤ j3)
    (h4 : 41 ≤ j4) :
    Keeps B m (m'.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q) := by
  intro j h3' hj
  refine
    ⟨?_, fun hf =>
      ((h j h3' hj).2 hf).callTmp5 (GlobalState.slot_id_ne (by omega))
        (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
        (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))⟩
  rw [readVec_callTmp5_of_id_ne (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
      (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))]
  exact (h j h3' hj).1

/-- The globals in `M`: `√-1`, `1` and `d` at `B.slot 0 … 2`. -/
structure Globals (B : GlobalState) (M : MemoryState) : Prop where
  sqrtm1_fits : Fits M (B.slot 0) 512
  one_fits : Fits M (B.slot 1) 512
  d_fits : Fits M (B.slot 2) 512
  sqrtm1 : M.readVec (B.slot 0) = fd_f25519_sqrtm1.vec
  one : M.readVec (B.slot 1) = fd_f25519_one.vec
  d : M.readVec (B.slot 2) = fd_f25519_d.vec

/-! `FD_R52X5_QUAD_REDUCE`'s limbs as the steps give them, folded back into the QUAD. -/

theorem reduce_P0 (Q : Quad5) :
    wl_madd52lo (wl_and Q.P0 (Vector.replicate 4 2251799813685247#64)) (wl_shru Q.P4 51)
        (Vector.replicate 4 19#64) =
      Q.reduce.P0 :=
  rfl

theorem reduce_P1 (Q : Quad5) :
    wl_add (wl_and Q.P1 (Vector.replicate 4 2251799813685247#64)) (wl_shru Q.P0 51) = Q.reduce.P1 :=
  rfl

theorem reduce_P2 (Q : Quad5) :
    wl_add (wl_and Q.P2 (Vector.replicate 4 2251799813685247#64)) (wl_shru Q.P1 51) = Q.reduce.P2 :=
  rfl

theorem reduce_P3 (Q : Quad5) :
    wl_add (wl_and Q.P3 (Vector.replicate 4 2251799813685247#64)) (wl_shru Q.P2 51) = Q.reduce.P3 :=
  rfl

theorem reduce_P4 (Q : Quad5) :
    wl_add (wl_and Q.P4 (Vector.replicate 4 2251799813685247#64)) (wl_shru Q.P3 51) = Q.reduce.P4 :=
  rfl

theorem reduce_sqr (X : Quad5) : (fd_r52x5_quad_sqr_fast.spec X).reduce = sqrQ X :=
  rfl

theorem reduce_mul (X Y : Quad5) : (fd_r52x5_quad_mul_fast.spec X Y).reduce = mulQ X Y :=
  rfl

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.R52x5

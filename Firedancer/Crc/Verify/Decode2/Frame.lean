module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.wl_permute
public import Firedancer.Crc.Verify.fd_r52x5_quad_sqr
public import Firedancer.Crc.Verify.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.fd_r52x5_quad_add
public import Firedancer.Crc.Verify.fd_r52x5_quad_sub
public import Firedancer.Crc.Verify.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Verify.fd_r52x5_limbs_eq
public import Firedancer.Crc.Verify.fd_r52x5_limbs_frombytes
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_decode2
public import Firedancer.Common.Counter
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas

/-! `fd_r52x5_ge_decode2`'s frame: its `246` stack slots, the facts every run keeps (`Inv`), the
registers a run writes (`Writes`), the entry's env and the specification. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2



/-- A register read right after its write, whatever the proofs of its type: no cast to reduce,
which for a register past the `500`th unfolds `Γ`'s types to it (the steps take it as a local
`mlir_env` lemma). -/
theorem read_write_same {Γ : Ctx} {t : Ty} (env : ⟪Γ⟫) (i : Fin Γ.n) (h h' : Γ.ty i = t)
    (v : ⟦t⟧) : (env.write ⟨i, h⟩ v).read (.val i h') = v := by
  subst h
  exact Env.read_write_dst env ⟨i, rfl⟩ v

attribute [local mlir_env 1100] read_write_same

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

def slotDsts : List (Dst Γ .ptr × Nat) :=
  List.flatten
    [[(rir_dst% fd_r52x5_ge_decode2.hty 139, 40),
        (rir_dst% fd_r52x5_ge_decode2.hty 140, 40),
        (rir_dst% fd_r52x5_ge_decode2.hty 141, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 142, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 143, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 144, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 145, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 146, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 147, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 148, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 149, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 150, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 151, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 152, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 153, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 154, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 155, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 156, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 157, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 158, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 159, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 160, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 161, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 162, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 163, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 164, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 165, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 166, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 167, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 168, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 169, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 170, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 171, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 172, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 173, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 174, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 175, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 176, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 177, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 178, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 179, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 180, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 181, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 182, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 183, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 184, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 185, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 186, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 187, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 188, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 189, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 190, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 191, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 192, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 193, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 194, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 195, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 196, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 197, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 198, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 199, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 200, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 201, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 202, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 203, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 204, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 205, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 206, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 207, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 208, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 209, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 210, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 211, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 212, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 213, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 214, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 215, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 216, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 217, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 218, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 219, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 220, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 221, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 222, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 223, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 224, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 225, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 226, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 227, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 228, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 229, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 230, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 231, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 232, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 233, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 234, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 235, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 236, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 237, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 238, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 239, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 240, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 241, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 242, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 243, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 244, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 245, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 246, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 247, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 248, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 249, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 250, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 251, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 252, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 253, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 254, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 255, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 256, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 257, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 258, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 259, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 260, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 261, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 262, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 263, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 264, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 265, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 266, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 267, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 268, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 269, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 270, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 271, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 272, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 273, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 274, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 275, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 276, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 277, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 278, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 279, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 280, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 281, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 282, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 283, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 284, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 285, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 286, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 287, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 288, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 289, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 290, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 291, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 292, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 293, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 294, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 295, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 296, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 297, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 298, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 299, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 300, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 301, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 302, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 303, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 304, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 305, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 306, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 307, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 308, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 309, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 310, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 311, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 312, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 313, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 314, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 315, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 316, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 317, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 318, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 319, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 320, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 321, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 322, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 323, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 324, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 325, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 326, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 327, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 328, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 329, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 330, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 331, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 332, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 333, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 334, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 335, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 336, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 337, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 338, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 339, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 340, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 341, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 342, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 343, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 344, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 345, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 346, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 347, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 348, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 349, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 350, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 351, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 352, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 353, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 354, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 355, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 356, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 357, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 358, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 359, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 360, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 361, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 362, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 363, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 364, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 365, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 366, 40),
        (rir_dst% fd_r52x5_ge_decode2.hty 367, 40),
        (rir_dst% fd_r52x5_ge_decode2.hty 368, 40)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 369, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 370, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 371, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 372, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 373, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 374, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 375, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 376, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 377, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 378, 32)],
      [(rir_dst% fd_r52x5_ge_decode2.hty 379, 40),
        (rir_dst% fd_r52x5_ge_decode2.hty 380, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 381, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 382, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 383, 32),
        (rir_dst% fd_r52x5_ge_decode2.hty 384, 32)]]


theorem bb0_slots : bb0.body.drop 139 = allocaRun slotDsts ++ bb0.body.drop 385 :=
  rir_rfl%

/-- The bytes of slot `j`: `40` for the six `fd_r52x5_limbs_t`, `32` for the QUAD temporaries. -/
def slotBytes (j : Nat) : Nat :=
  if j < 2 ∨ (227 ≤ j ∧ j < 230) ∨ j = 240 then 40 else 32

theorem slotDsts_sizes : slotDsts.map (·.2) = (List.range' 0 246).map slotBytes :=
  rir_rfl%

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

/-- The slots' sizes. -/
abbrev slotSizes : List Nat :=
  (List.range' 0 246).map slotBytes

theorem bb0_allocas {E : ⟪Γ⟫} {s B : GlobalState}
    (hs : s.alloc.nextFreeBlock = B.alloc.nextFreeBlock) :
    bb0.runBodyFrom E 139 s =
      bb0.runBodyFrom (writeSlots E B 0 slotDsts) 385 (allocas s slotSizes) := by
  rw [runBodyFrom_allocaRun B _ _ _ _ 0 hs bb0_slots, slotDsts_sizes,
    show 139 + slotDsts.length = 385 from rir_rfl%]

/-- Every slot of `B` in bounds for its bytes and writable. -/
def Frame (B : GlobalState) (m : MemoryState) : Prop :=
  ∀ j, j < 246 → InBounds m (B.slot j) (8 * slotBytes j) ∧ Writable m (B.slot j)

theorem Frame.of {B : GlobalState} {m m' : MemoryState}
    (hb : ∀ p w, InBounds m p w → InBounds m' p w)
    (hw : ∀ p, Writable m p → Writable m' p) (h : Frame B m) : Frame B m' :=
  fun j hj => ⟨hb _ _ (h j hj).1, hw _ (h j hj).2⟩

theorem Frame.tmp {B : GlobalState} {m : MemoryState} (h : Frame B m) (j : Nat)
    (hj : (2 ≤ j ∧ j < 227) ∨ (230 ≤ j ∧ j < 240) ∨ (241 ≤ j ∧ j < 246) := by decide) :
    InBounds m (B.slot j) 256 ∧ Writable m (B.slot j) := by
  have := h j (by omega)
  rwa [show slotBytes j = 32 by unfold slotBytes; split_ifs <;> omega] at this

theorem Frame.limbs {B : GlobalState} {m : MemoryState} (h : Frame B m) (j : Nat)
    (hj : j < 2 ∨ (227 ≤ j ∧ j < 230) ∨ j = 240 := by decide) :
    InBounds m (B.slot j) 320 ∧ Writable m (B.slot j) := by
  have := h j (by omega)
  rwa [show slotBytes j = 40 by unfold slotBytes; split_ifs; omega] at this

@[mlir_transport]
theorem Frame.storeAt {B : GlobalState} {m : MemoryState} {x : BitVec w} (h : Frame B m) :
    Frame B (m.storeAt p x) :=
  h.of (fun _ _ => InBounds.storeAt) fun _ => Writable.storeAt

@[mlir_transport]
theorem Frame.storeTmp5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.storeTmp5) fun _ => Writable.storeTmp5

@[mlir_transport]
theorem Frame.storeLimbs {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeLimbs p l) :=
  h.of (fun _ _ => InBounds.storeLimbs) fun _ h => h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem Frame.lifetimeStart {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeStart p) :=
  h.of (fun _ _ => InBounds.lifetimeStart) fun _ => Writable.lifetimeStart

@[mlir_transport]
theorem Frame.lifetimeEnd {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeEnd p) :=
  h.of (fun _ _ => InBounds.lifetimeEnd) fun _ => Writable.lifetimeEnd

@[mlir_transport]
theorem Frame.callTmp5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.callTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.callTmp5) fun _ => Writable.callTmp5

/-- The slots after their `alloca`s: the frame. -/
theorem frame_allocas {s B : GlobalState} (hwf : s.WF)
    (hs : s.alloc.nextFreeBlock = B.alloc.nextFreeBlock) :
    Frame B (allocas s slotSizes).mem := by
  intro j hj
  constructor
  · have := fits_allocas B slotSizes s 0 j hwf hs (by simp; omega)
    simpa [List.getElem!_eq_getElem?_getD, List.getElem?_range', hj] using this
  · have := writable_allocas B slotSizes s 0 j hwf hs (by simp; omega)
    simpa using this

theorem readAt_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readAt p w = m.readAt p w := by
  simp only [MemoryState.readAt, MemoryState.eraseFrom, MemoryState.getElem?_eq,
    Std.ExtHashMap.getElem?_filter', h, decide_true]
  cases m.mem[p.id]? <;> rfl

theorem fits_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  refine ⟨b, ?_, hl, hw, hd⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

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

/-- The state at each point of the function: well-formed, the frame in bounds, the memory
below the frame `M`, and `c` blocks past the frame. -/
structure Inv (B : GlobalState) (M : MemoryState) (c : Nat) (S : GlobalState) : Prop where
  wf : S.WF
  frame : Frame B S.mem
  erase : S.mem.eraseFrom B.alloc.nextFreeBlock = M
  alloc : S.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 246 + c

theorem ne_slot {B : GlobalState} {p : Pointer} (h : p.id.id < B.alloc.nextFreeBlock) :
    p.id ≠ (B.slot j).id := fun he => by
  have := congrArg BlockId.id he
  simp [GlobalState.slot] at this
  omega

theorem Inv.readAt {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hp : p.id.id < B.alloc.nextFreeBlock) : S.mem.readAt p w = M.readAt p w := by
  rw [← h.erase, readAt_eraseFrom_of_lt hp]

theorem Inv.fits {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : Fits M p w) : Fits S.mem p w :=
  fits_of_eraseFrom (h.erase ▸ hf)

theorem Inv.quad5Room {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hq : M.Quad5Room p) : S.mem.Quad5Room p :=
  ⟨hq.1, room_of_eraseFrom (h.erase ▸ hq.2.1), room_of_eraseFrom (h.erase ▸ hq.2.2.1),
    room_of_eraseFrom (h.erase ▸ hq.2.2.2.1), room_of_eraseFrom (h.erase ▸ hq.2.2.2.2.1),
    room_of_eraseFrom (h.erase ▸ hq.2.2.2.2.2)⟩

theorem Inv.room {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : Room M p w) : Room S.mem p w :=
  room_of_eraseFrom (h.erase ▸ hf)

theorem eraseFrom_storeAt_slot {B : GlobalState} {m : MemoryState} {x : BitVec w} :
    (m.storeAt (B.slot j) x).eraseFrom B.alloc.nextFreeBlock = m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_storeAt_of_le (by simp [GlobalState.slot])

theorem eraseFrom_storeAt_slot_add {B : GlobalState} {m : MemoryState} {x : BitVec w}
    {o : BitVec 64} :
    (m.storeAt ((B.slot j).add o) x).eraseFrom B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_storeAt_of_le (by simp [Pointer.add, GlobalState.slot])

theorem eraseFrom_lifetimeStart_slot {B : GlobalState} {m : MemoryState} :
    (m.lifetimeStart (B.slot j)).eraseFrom B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_lifetimeStart_of_le (by simp [GlobalState.slot])

theorem eraseFrom_lifetimeEnd_slot {B : GlobalState} {m : MemoryState} :
    (m.lifetimeEnd (B.slot j)).eraseFrom B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_lifetimeEnd_of_le (by simp [GlobalState.slot])

theorem eraseFrom_storeLimbs_slot {B : GlobalState} {m : MemoryState} {l : Fin 5 → BitVec 64} :
    (m.storeLimbs (B.slot j) l).eraseFrom B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_storeLimbs_of_le (by simp [GlobalState.slot])

theorem eraseFrom_storeTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} :
    (m.storeTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_storeTmp5_of_le (by simp [GlobalState.slot]) (by simp [GlobalState.slot])
    (by simp [GlobalState.slot]) (by simp [GlobalState.slot]) (by simp [GlobalState.slot])

theorem eraseFrom_callTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} :
    (m.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_callTmp5_of_le (by simp [GlobalState.slot]) (by simp [GlobalState.slot])
    (by simp [GlobalState.slot]) (by simp [GlobalState.slot]) (by simp [GlobalState.slot])

/-! ### The entry env -/

/-- `%769`: lanes `0`, `1` poison, lanes `2`, `3` zero. -/
def yUndef : ⟦Ty.vec 4 64⟧ :=
  ((((Vector.replicate 4 (PoisonOr.poison : PoisonOr (BitVec 64))).set 0 .poison (by decide)).set 1
          .poison (by decide)).set
      2 (.value 0#64) (by decide)).set
    3 (.value 0#64) (by decide)

theorem insert_y_eq (a b : BitVec 64) (h0 h1) :
    (yUndef.set 0 (.value a) h0).set 1 (.value b) h1 = (Ty.wrap (wl a b 0 0) : ⟦Ty.vec 4 64⟧) := by
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [yUndef, wl]


/-- `%777`: the mask vector before its lanes `0 … 3` are set. -/
abbrev m8Undef : ⟦Ty.vec 8 32⟧ :=
  #v[PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.value 0#32, PoisonOr.value 0#32, PoisonOr.value 0#32, PoisonOr.value 0#32]

/-- `%809`: bytes `16 … 23` the `i64` `1`, the rest poison. -/
abbrev mask1Bytes : ⟦Ty.vec 32 8⟧ :=
  #v[PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.value 1#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]

/-- `%841`: bytes `16 … 23` the `i64` `0`, the rest poison. -/
abbrev mask0Bytes : ⟦Ty.vec 32 8⟧ :=
  #v[PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]

/-- The env after `^bb0`'s constants and allocas, `E₀` the entry's: the constants the blocks read
(the steps leave out the others). -/
def entryEnv (E₀ : ⟪Γ⟫) (B : GlobalState) : ⟪Γ⟫ :=
  writeSlots
    (E₀[%730 := Ty.wrap (Vector.replicate 2 7#8),
      %731 := Vector.replicate 2 PoisonOr.poison,
      %732 := Ty.wrap (Vector.replicate 2 1#32),
      %733 := Vector.replicate 2 PoisonOr.poison,
      %734 := PoisonOr.value 3#64,
      %735 := PoisonOr.value 2#64,
      %742 := Ty.wrap (Vector.replicate 4 765476049583133#64),
      %743 := Ty.wrap (Vector.replicate 4 2117202627021982#64),
      %744 := Ty.wrap (Vector.replicate 4 2233514472574048#64),
      %745 := Ty.wrap (Vector.replicate 4 234908883556509#64),
      %746 := Ty.wrap (Vector.replicate 4 1718705420411056#64),
      %747 := PoisonOr.value 4294967295#32,
      %748 := PoisonOr.value 100#32,
      %749 := PoisonOr.value 50#32,
      %750 := PoisonOr.value 20#32,
      %751 := Ty.wrap (Vector.replicate 4 1442794654840575#64),
      %752 := Ty.wrap (Vector.replicate 4 2033849074728123#64),
      %753 := Ty.wrap (Vector.replicate 4 1662059464998953#64),
      %754 := Ty.wrap (Vector.replicate 4 466365720129213#64),
      %755 := Ty.wrap (Vector.replicate 4 929955233495203#64),
      %756 := Ty.wrap (Vector.replicate 4 0#64),
      %757 := Ty.wrap (Vector.replicate 4 1#64),
      %758 := PoisonOr.value 1#64,
      %759 := PoisonOr.value 3#32,
      %760 := PoisonOr.value 2#32,
      %761 := PoisonOr.value 1#32,
      %762 := PoisonOr.value 0#64,
      %765 := PoisonOr.value 0#32,
      %769 := ((Vector.replicate 4 PoisonOr.poison).set 2 (PoisonOr.value 0#64) (by decide)).set 3 (PoisonOr.value 0#64) (by decide),
      %777 := ((((Vector.replicate 8 PoisonOr.poison).set 4 (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6 (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
      %809 := ((((((((((((((((Vector.replicate 32 PoisonOr.poison).set 16 (PoisonOr.value 1#8) (by decide)).set 17 (PoisonOr.value 0#8) (by decide)).set 18 (PoisonOr.value 0#8) (by decide)).set 19 (PoisonOr.value 0#8) (by decide)).set 20 (PoisonOr.value 0#8) (by decide)).set 21 (PoisonOr.value 0#8) (by decide)).set 22 (PoisonOr.value 0#8) (by decide)).set 23 (PoisonOr.value 0#8) (by decide)).set 24 PoisonOr.poison (by decide)).set 25 PoisonOr.poison (by decide)).set 26 PoisonOr.poison (by decide)).set 27 PoisonOr.poison (by decide)).set 28 PoisonOr.poison (by decide)).set 29 PoisonOr.poison (by decide)).set 30 PoisonOr.poison (by decide)).set 31 PoisonOr.poison (by decide),
      %841 := ((((((((((((((((Vector.replicate 32 PoisonOr.poison).set 16 (PoisonOr.value 0#8) (by decide)).set 17 (PoisonOr.value 0#8) (by decide)).set 18 (PoisonOr.value 0#8) (by decide)).set 19 (PoisonOr.value 0#8) (by decide)).set 20 (PoisonOr.value 0#8) (by decide)).set 21 (PoisonOr.value 0#8) (by decide)).set 22 (PoisonOr.value 0#8) (by decide)).set 23 (PoisonOr.value 0#8) (by decide)).set 24 PoisonOr.poison (by decide)).set 25 PoisonOr.poison (by decide)).set 26 PoisonOr.poison (by decide)).set 27 PoisonOr.poison (by decide)).set 28 PoisonOr.poison (by decide)).set 29 PoisonOr.poison (by decide)).set 30 PoisonOr.poison (by decide)).set 31 PoisonOr.poison (by decide)])
    B 0 slotDsts

/-- The constants of `^bb0` as its steps leave them, in the forms the blocks read. -/
theorem yUndef_eq : yUndef = (((Vector.replicate 4 PoisonOr.poison).set 2 (PoisonOr.value 0#64) (by decide)).set 3 (PoisonOr.value 0#64) (by decide) : ⟦Ty.vec 4 64⟧) := by
  rfl

/-! ### The specification -/

/-- `FD_R52X5_QUAD_SQR( D, S )`. -/
abbrev sqrQ (S : Quad5) : Quad5 :=
  fd_r52x5_quad_sqr.spec S

/-- `FD_R52X5_QUAD_MUL( D, A, B )`. -/
abbrev mulQ (A B : Quad5) : Quad5 :=
  fd_r52x5_quad_mul.spec A B

/-- `n` in-place `FD_R52X5_QUAD_SQR`s, as a loop does them. -/
def sqrNQ : Nat → Quad5 → Quad5
  | 0, S => S
  | n + 1, S => sqrNQ n (sqrQ S)

/-- `FD_R52X5_QUAD_POW22523( D, A )`: each lane to the power `2^252 - 3`. -/
def pow22523Q (A : Quad5) : Quad5 :=
  let t0 := sqrQ A
  let t1 := sqrQ (sqrQ t0)
  let t1 := mulQ A t1
  let t0 := mulQ t0 t1
  let t0 := sqrQ t0
  let t0 := mulQ t1 t0
  let t1 := sqrQ (sqrQ (sqrQ (sqrQ (sqrQ t0))))
  let t0 := mulQ t1 t0
  let t1 := sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ t0)))))))))
  let t1 := mulQ t1 t0
  let t2 := sqrNQ 19 (sqrQ t1)
  let t1 := mulQ t2 t1
  let t1 := sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ t1)))))))))
  let t0 := mulQ t1 t0
  let t1 := sqrNQ 49 (sqrQ t0)
  let t1 := mulQ t1 t0
  let t2 := sqrNQ 99 (sqrQ t1)
  let t1 := mulQ t2 t1
  let t1 := sqrNQ 49 (sqrQ t1)
  let t0 := mulQ t1 t0
  let t0 := sqrQ (sqrQ t0)
  mulQ t0 A

/-- `fd_r52x5_q_one` in every lane. -/
abbrev oneQ : Quad5 :=
  ⟨Vector.replicate 4 1#64, Vector.replicate 4 0#64, Vector.replicate 4 0#64,
    Vector.replicate 4 0#64, Vector.replicate 4 0#64⟩

/-- `fd_r52x5_q_d` in every lane. -/
abbrev dQ : Quad5 :=
  ⟨Vector.replicate 4 929955233495203#64, Vector.replicate 4 466365720129213#64,
    Vector.replicate 4 1662059464998953#64, Vector.replicate 4 2033849074728123#64,
    Vector.replicate 4 1442794654840575#64⟩

/-- `fd_r52x5_q_sqrtm1` in every lane. -/
abbrev sqrtm1Q : Quad5 :=
  ⟨Vector.replicate 4 1718705420411056#64, Vector.replicate 4 234908883556509#64,
    Vector.replicate 4 2233514472574048#64, Vector.replicate 4 2117202627021982#64,
    Vector.replicate 4 765476049583133#64⟩

/-- `Y`: `sa`'s limbs in lane 0, `sb`'s in lane 1. -/
def yQ (sa sb : BitVec 256) : Quad5 :=
  let fa := fd_r52x5_limbs_frombytes.spec sa
  let fb := fd_r52x5_limbs_frombytes.spec sb
  ⟨wl (fa 0) (fb 0) 0 0, wl (fa 1) (fb 1) 0 0, wl (fa 2) (fb 2) 0 0, wl (fa 3) (fb 3) 0 0,
    wl (fa 4) (fb 4) 0 0⟩

/-- The quads before the lane checks: `Y`, `U`, `V`, `V3`, `X`, `VX2` and `NU`. -/
structure Pre where
  y : Quad5
  u : Quad5
  v : Quad5
  v3 : Quad5
  x : Quad5
  vx2 : Quad5
  nu : Quad5

/-- Both encodings up to `VX2` and `NU`. -/
def pre (sa sb : BitVec 256) : Pre :=
  let y := yQ sa sb
  let y2 := sqrQ y
  let u := fd_r52x5_quad_sub.spec y2 oneQ
  let v := fd_r52x5_quad_add.spec (mulQ y2 dQ) oneQ
  let v2 := sqrQ v
  let v3 := mulQ v2 v
  let v7 := mulQ (sqrQ v3) v
  let uv7 := mulQ u v7
  let e := pow22523Q uv7
  let x := mulQ (mulQ u v3) e
  let x2 := sqrQ x
  let vx2 := mulQ v x2
  let nu := fd_r52x5_quad_neg.spec u
  ⟨y, u, v, v3, x, vx2, nu⟩

/-- Lane `j`'s check: `ok` (`0` or `1`) and `c` (`1` when `v x² = -u`, else `0`). -/
def laneCheck (vx2 u nu : Quad5) (j : Fin 4) : BitVec 32 × BitVec 32 :=
  let cv := fd_r52x5_quad_lane_canon.spec vx2 j
  let cu := fd_r52x5_quad_lane_canon.spec u j
  let cn := fd_r52x5_quad_lane_canon.spec nu j
  let e1 := fd_r52x5_limbs_eq.spec cv cu
  let e2 := fd_r52x5_limbs_eq.spec cv cn
  if e1 = 0 then (e2, e2) else (1, 0)

/-- `FD_R52X5_QUAD_LANE_IF( D, b0,b1,0,0, S, T )`. -/
def blend2Q (b0 b1 : Bool) (S T : Quad5) : Quad5 :=
  ⟨wlBlend b0 b1 false false S.P0 T.P0, wlBlend b0 b1 false false S.P1 T.P1,
    wlBlend b0 b1 false false S.P2 T.P2, wlBlend b0 b1 false false S.P3 T.P3,
    wlBlend b0 b1 false false S.P4 T.P4⟩

/-- Whether lane `j`'s canonical `x` has the parity `e`'s bit 255 does not ask for. -/
def flip (X : Quad5) (j : Fin 4) (e : BitVec 256) : Bool :=
  ((fd_r52x5_quad_lane_canon.spec X j 0).setWidth 32 &&& 1#32) !=
    ((e.extractLsb' 248 8) >>> 7).setWidth 32

/-- `(X, Y, 1, X Y)` of lane `j` of `X`, `Y` and `T`. -/
def point (X Y T : Quad5) (j : Fin 4) : Quad5 :=
  ⟨wl X.P0[j] Y.P0[j] 1 T.P0[j], wl X.P1[j] Y.P1[j] 0 T.P1[j], wl X.P2[j] Y.P2[j] 0 T.P2[j],
    wl X.P3[j] Y.P3[j] 0 T.P3[j], wl X.P4[j] Y.P4[j] 0 T.P4[j]⟩

/-- Both points once both lanes decoded, `c0`/`c1` whether a lane's `x` takes `√-1`. -/
def points (sa sb : BitVec 256) (x0 y : Quad5) (c0 c1 : BitVec 32) : Quad5 × Quad5 :=
  let xs := mulQ x0 sqrtm1Q
  let x := blend2Q (c0 == 1) (c1 == 1) xs x0
  let nx := fd_r52x5_quad_neg.spec x
  let x := blend2Q (flip x 0 sa) (flip x 1 sb) nx x
  let t := mulQ x y
  (point x y t 0, point x y t 1)

/-- The lane checks of `v x²` (`vx2`) against `u` and `-u` (`nu`) and on: the lane mask of the
decoded lanes, and both points when it is `3`. -/
def tail (sa sb : BitVec 256) (x y vx2 u nu : Quad5) : BitVec 32 × Option (Quad5 × Quad5) :=
  let c0 := laneCheck vx2 u nu 0
  let c1 := laneCheck vx2 u nu 1
  if c1.1 = 0 then (c0.1, none)
  else if c0.1 = 0 then (2, none)
  else (3, some (points sa sb x y c0.2 c1.2))

/-- `fd_r52x5_ge_decode2` of the encodings `sa` and `sb`: the lane mask of the decoded lanes, and
both points when it is `3`. -/
def spec (sa sb : BitVec 256) : BitVec 32 × Option (Quad5 × Quad5) :=
  let P := pre sa sb
  tail sa sb P.x P.y P.vx2 P.u P.nu

theorem spec_eq_tail (sa sb : BitVec 256) :
    spec sa sb = tail sa sb (pre sa sb).x (pre sa sb).y (pre sa sb).vx2 (pre sa sb).u (pre sa sb).nu :=
  rfl

/-- The output memory: `a` and `b` written when both lanes decoded. -/
def storeOut (m : MemoryState) (a b : Pointer) (R : BitVec 32 × Option (Quad5 × Quad5)) :
    MemoryState :=
  match R.2 with
  | none => m
  | some (PA, PB) => (m.storeQuad5 a PA).storeQuad5 b PB

/-- The blocks the call allocates: the frame, the lane checks' `fd_r52x5_quad_lane_canon`s, and
when both lanes decoded, `fd_r52x5_quad_lane_canon`s and `wl_permute`s of the output. -/
def blocks (R : BitVec 32 × Option (Quad5 × Quad5)) : Nat :=
  match R.2 with
  | none => 246 + 36
  | some _ => 246 + 36 + 12 + 30

theorem blocks_eq (n : Nat) (R : BitVec 32 × Option (Quad5 × Quad5)) :
    n + 246 + (0 + 36 + (match R.2 with | none => 0 | some _ => 42)) = n + blocks R := by
  unfold blocks
  rcases R with ⟨r, _ | _⟩ <;> simp only []

theorem readAt_storeLimbs_0 {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (h : m.LimbsRoom p) : (m.storeLimbs p l).readAt p 64 = l 0 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 0

/-- Bytes of a stored `wl_t` loaded as `<32 x i8>`, as the steps give them. -/
theorem ofFn_extractVecElem_packLanes (v : Wl) :
    (Vector.ofFn fun i => Ty.extractVecElem 32 8 i (BitVec.packLanes (we := 64) (n := 4) v)) =
      wlBytes v := by
  ext k hk : 1
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, wlBytes]
  exact extractLsb'_packLanes_byte _ hk

/-- `-c` for `c` `0` or `1`, in the lanes `0, 0, 1, 1` of an `<8 x i32>`. -/
def fixMask (c0 c1 : BitVec 32) : Wl :=
  wl ((-c0) ++ (-c0)) ((-c1) ++ (-c1)) 0 0

/-- The `<8 x i32>` mask `(-c0, -c0, -c1, -c1, 0, 0, 0, 0)` as bytes, as a `bitcast` step leaves
it. -/
theorem fixMask_bytes (c0 c1 : BitVec 32) :
    (#v[BitVec.extractLsb' 0 8 (-c0), BitVec.extractLsb' 8 8 (-c0), BitVec.extractLsb' 16 8 (-c0),
        BitVec.extractLsb' 24 8 (-c0), BitVec.extractLsb' 0 8 (-c0), BitVec.extractLsb' 8 8 (-c0),
        BitVec.extractLsb' 16 8 (-c0), BitVec.extractLsb' 24 8 (-c0), BitVec.extractLsb' 0 8 (-c1),
        BitVec.extractLsb' 8 8 (-c1), BitVec.extractLsb' 16 8 (-c1), BitVec.extractLsb' 24 8 (-c1),
        BitVec.extractLsb' 0 8 (-c1), BitVec.extractLsb' 8 8 (-c1), BitVec.extractLsb' 16 8 (-c1),
        BitVec.extractLsb' 24 8 (-c1), 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8, 0#8,
        0#8, 0#8, 0#8, 0#8] : Vector (BitVec 8) 32) = wlBytes (fixMask c0 c1) := by
  have e (x : BitVec 32) :
      (x ++ x).extractLsb' 0 8 = x.extractLsb' 0 8 ∧ (x ++ x).extractLsb' 8 8 = x.extractLsb' 8 8 ∧
        (x ++ x).extractLsb' 16 8 = x.extractLsb' 16 8 ∧
        (x ++ x).extractLsb' 24 8 = x.extractLsb' 24 8 ∧
        (x ++ x).extractLsb' 32 8 = x.extractLsb' 0 8 ∧ (x ++ x).extractLsb' 40 8 = x.extractLsb' 8 8 ∧
        (x ++ x).extractLsb' 48 8 = x.extractLsb' 16 8 ∧
        (x ++ x).extractLsb' 56 8 = x.extractLsb' 24 8 := by
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide
  obtain ⟨a0, a1, a2, a3, a4, a5, a6, a7⟩ := e (-c0)
  obtain ⟨b0, b1, b2, b3, b4, b5, b6, b7⟩ := e (-c1)
  simp only [wlBytes_eq, fixMask, wl, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_zero, List.getElem_cons_succ, a0, a1, a2, a3, a4, a5, a6, a7, b0, b1, b2,
    b3, b4, b5, b6, b7]
  rfl

/-- The byte blend by `fixMask c0 c1`: lane `j < 2` from `x` where `cj = 1`, else `y`. -/
theorem pblendvb_fixMask {c0 c1 : BitVec 32} (h0 : c0 = 0 ∨ c0 = 1) (h1 : c1 = 0 ∨ c1 = 1)
    (x y : Wl) :
    Operation.pblendvb (Ty.wrap (t := .vec 32 8) (wlBytes y)) (Ty.wrap (t := .vec 32 8) (wlBytes x))
        (Ty.wrap (t := .vec 32 8) (wlBytes (fixMask c0 c1))) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wlBlend (c0 == 1) (c1 == 1) false false x y)) := by
  have := pblendvb_wcBcast h0 h1 (Or.inl rfl) (Or.inl rfl) x y
  simpa [wcBcast, fixMask, wl] using this

/-- A lane's `sext` of a flip bit: `-c` for `c` the bit as `0` or `1`. -/
theorem signExtend_ofBool (b : Bool) :
    BitVec.signExtend 32 (BitVec.ofBool b) = -(if b then 1#32 else 0#32) := by
  cases b <;> decide

theorem setWidth_shr7 (b : BitVec 8) :
    BitVec.setWidth 32 (b >>> 7) = BitVec.setWidth 32 b >>> 7 := by bv_decide

/-- The flip bit as the code computes it. -/
theorem flip_eq (X : Quad5) (j : Fin 4) (e : BitVec 256) :
    ((if BitVec.setWidth 32 (fd_r52x5_quad_lane_canon.spec X j 0) &&& 1#32 =
        BitVec.setWidth 32 (e.extractLsb' 248 8) >>> 7 then 0#32 else 1#32) == 1#32) =
      flip X j e := by
  unfold flip
  rw [setWidth_shr7]
  split <;> simp_all

/-! ### `^bb0`'s `Y` -/

abbrev argsOf (a ea b eb : Pointer) : Vals Γ.args :=
  args (.value a) (.value ea) (.value b) (.value eb)


/-! ### Reads of the entry's env -/

section EntryReads

variable {Γ : Ctx}

/-- `writeSlots` over destinations `a, a + 1, …` writes only those registers. -/
theorem writeSlots_writes (B : GlobalState) :
    ∀ (ds : List (Dst Γ .ptr × Nat)) (E : ⟪Γ⟫) (k a : Nat),
      ds.map (fun d => d.1.i.val) = List.range' a ds.length →
      Writes E (writeSlots E B k ds) a (a + ds.length)
  | [], _, _, _, _ => Writes.refl _ _ _
  | (d, _) :: ds, E, k, a, h => by
    simp only [List.map_cons, List.length_cons, List.range'_succ, List.cons.injEq] at h
    obtain ⟨h0, h1⟩ := h
    have ih := writeSlots_writes B ds (E.write d (.value (B.slot k))) (k + 1) (a + 1) h1
    have hw : Writes E (E.write d (.value (B.slot k))) a (a + (ds.length + 1)) :=
      Writes.write (Writes.refl _ _ _) (by omega)
    exact hw.trans (ih.mono (by omega) (by omega))

/-- `writeSlots` over destinations `a, a + 1, …`: register `a + j` holds slot `k + j`. -/
theorem writeSlots_read_slot (B : GlobalState) :
    ∀ (ds : List (Dst Γ .ptr × Nat)) (E : ⟪Γ⟫) (k a j : Nat),
      ds.map (fun d => d.1.i.val) = List.range' a ds.length → j < ds.length →
      ∀ (i : Fin Γ.n) (ht : Γ.ty i = .ptr), i.val = a + j →
        (writeSlots E B k ds).read (.val i ht) = .value (B.slot (k + j))
  | [], _, _, _, _, _, hj, _, _, _ => absurd hj (Nat.not_lt_zero _)
  | (d, _) :: ds, E, k, a, j, h, hj, i, ht, hi => by
    simp only [List.map_cons, List.length_cons, List.range'_succ, List.cons.injEq] at h
    obtain ⟨h0, h1⟩ := h
    show (writeSlots (E.write d (.value (B.slot k))) B (k + 1) ds).read (.val i ht) = _
    cases j with
    | zero =>
      have hw := writeSlots_writes B ds (E.write d (.value (B.slot k))) (k + 1) (a + 1) h1
      rw [hw.read (i := i) (by omega)]
      have he : i = d.i := Fin.ext (by omega)
      subst he
      exact Env.read_write_dst E d _
    | succ j =>
      rw [writeSlots_read_slot B ds _ (k + 1) (a + 1) j h1 (by simp at hj; omega) i ht (by omega),
        show k + 1 + j = k + (j + 1) by omega]

end EntryReads

theorem slotDsts_idx : slotDsts.map (fun d => d.1.i.val) = List.range' 139 246 := by
  decide +kernel

theorem slotDsts_length : slotDsts.length = 246 := by
  decide +kernel

/-- The entry's slot writes touch only the registers `139 … 384`. -/
theorem entry_writes (E : ⟪Γ⟫) (B : GlobalState) : Writes E (writeSlots E B 0 slotDsts) 139 385 := by
  have h := slotDsts_idx
  rw [← slotDsts_length] at h
  have := writeSlots_writes B slotDsts E 0 139 h
  rwa [slotDsts_length] at this

/-- Register `139 + j` of the entry holds slot `j`. -/
theorem entry_slot (E : ⟪Γ⟫) (B : GlobalState) (j : Nat) (hj : j < 246) (i : Fin Γ.n)
    (ht : Γ.ty i = .ptr) (hi : i.val = 139 + j) :
    (writeSlots E B 0 slotDsts).read (.val i ht) = .value (B.slot j) := by
  have h := slotDsts_idx
  rw [← slotDsts_length] at h
  have := writeSlots_read_slot B slotDsts E 0 139 j h (by rw [slotDsts_length]; exact hj) i ht hi
  rwa [Nat.zero_add] at this

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify

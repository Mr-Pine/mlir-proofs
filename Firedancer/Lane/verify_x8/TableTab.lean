module

public import Firedancer.Lane.verify_x8.TableMem
import Mathlib.Tactic.FinCases

/-! `ktab` as `At83` states it: the nine stored entries as `tabBits`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

variable {m : MemoryState} {q : Pointer} {c : Call}

/-- Cell `k` of `ktab`: lanes `8 k … 8 k + 7`. -/
theorem tabBits_cell (k : Nat) :
    BitVec.packLanes ((c.tab (k / 25)).comp ⟨k % 25 / 5, by omega⟩ |>.limb ⟨k % 25 % 5, by omega⟩) =
      BitVec.packLanes (Vector.ofFn fun l : Fin 8 => c.tabQword (8 * k + l)) := by
  congr 1
  ext l hl
  simp only [Vector.getElem_ofFn, Call.tabQword]
  have h1 : (8 * k + l) / 200 = k / 25 := by omega
  have h2 : (8 * k + l) % 200 / 40 = k % 25 / 5 := by omega
  have h3 : (8 * k + l) % 40 / 8 = k % 25 % 5 := by omega
  have h4 : (8 * k + l) % 8 = l := by omega
  simp only [h1, h2, h3, h4, Fe.lane]
  rfl

/-- The 225 cells of `ktab`, packed: `tabBits`. -/
theorem tabBits_eq :
    BitVec.packLanes (Vector.ofFn fun k : Fin 225 =>
        BitVec.packLanes (Vector.ofFn fun l : Fin 8 => c.tabQword (8 * k + l))) = c.tabBits := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [getLsbD_packLanes _ hi, Vector.getElem_ofFn, getLsbD_packLanes _ (by omega),
    Vector.getElem_ofFn, Call.tabBits, getLsbD_packLanes _ (by omega), Vector.getElem_ofFn]
  simp only [show 8 * (i / 512) + i % 512 / 64 = i / 64 by omega,
    show i % 512 % 64 = i % 64 by omega]

/-- `ktab`'s bits from its nine entries. -/
theorem readAt_tab (hq : q.offset = 0) (hb : InBounds m q 115200)
    (h0 : m.readAt (q.add 0#64) 12800 = (c.tab 0).bits)
    (h1 : m.readAt (q.add 1600#64) 12800 = (c.tab 1).bits)
    (h2 : m.readAt (q.add 3200#64) 12800 = (c.tab 2).bits)
    (h3 : m.readAt (q.add 4800#64) 12800 = (c.tab 3).bits)
    (h4 : m.readAt (q.add 6400#64) 12800 = (c.tab 4).bits)
    (h5 : m.readAt (q.add 8000#64) 12800 = (c.tab 5).bits)
    (h6 : m.readAt (q.add 9600#64) 12800 = (c.tab 6).bits)
    (h7 : m.readAt (q.add 11200#64) 12800 = (c.tab 7).bits)
    (h8 : m.readAt (q.add 12800#64) 12800 = (c.tab 8).bits) :
    m.readAt q (64 * 1800) = c.tabBits := by
  have H : ∀ e : Fin 9, m.readAt (q.add (BitVec.ofNat 64 (1600 * e))) 12800 = (c.tab e).bits := by
    intro e
    fin_cases e
    exacts [h0, h1, h2, h3, h4, h5, h6, h7, h8]
  have hb0 : InBounds m (q.add (BitVec.ofNat 64 0)) 115200 := by rw [add_ofNat_zero]; exact hb
  rw [← tabBits_eq, ← add_ofNat_zero (q := q)]
  refine readAt_cells (o := 0) (n := 225) hq hb0 (by omega) fun k => ?_
  have hk := k.isLt
  have he : k.val / 25 < 9 := by omega
  rw [readAt_sub hq (o := 1600 * (k.val / 25))
      (inBounds_sub (o := 0) hq hb0 (by omega) (by omega) (by omega)) (H ⟨k.val / 25, he⟩)
      (by omega) (by omega) (by omega),
    show 8 * (0 + 64 * k.val - 1600 * (k.val / 25)) = 512 * (k.val % 25) by omega,
    niels_bits_extract _ _ (by omega), ← tabBits_cell k.val]

/-- `ktab` fits when its nine entries do. -/
theorem fits_tab (hq : q.offset = 0) (h0 : Fits m (q.add 0#64) 12800)
    (h1 : Fits m (q.add 1600#64) 12800) (h2 : Fits m (q.add 3200#64) 12800)
    (h3 : Fits m (q.add 4800#64) 12800) (h4 : Fits m (q.add 6400#64) 12800)
    (h5 : Fits m (q.add 8000#64) 12800) (h6 : Fits m (q.add 9600#64) 12800)
    (h7 : Fits m (q.add 11200#64) 12800) (h8 : Fits m (q.add 12800#64) 12800) :
    Fits m q (64 * 1800) := by
  rw [Pointer.add_zero] at h0
  show Fits m q 115200
  exact fits_append_at hq 12800 (fits_append_at hq 11200 (fits_append_at hq 9600
    (fits_append_at hq 8000 (fits_append_at hq 6400 (fits_append_at hq 4800
      (fits_append_at hq 3200 (fits_append_at hq 1600 h0 h1 rfl (by omega)) h2 rfl (by omega))
      h3 rfl (by omega)) h4 rfl (by omega)) h5 rfl (by omega)) h6 rfl (by omega)) h7 rfl
    (by omega)) h8 rfl (by omega)

end

end MLIR.Firedancer.Lane.VerifyX8

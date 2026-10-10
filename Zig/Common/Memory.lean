module

public import MLIR.Run.Tactic
public import Firedancer.Common.Counter
import Std.Data.ExtHashMap.Lemmas

/-! Memory and counter facts the Zig proofs share: `spliceBits` as bit operations, reads below an
erased frame, a loop counter's increment. -/

namespace MLIR.Zig

open Memory

/-- `spliceBits` as bit operations. -/
public theorem spliceBits_eq {n w : Nat} (bytes : BitVec n) (off : Nat) (x : BitVec w) :
    spliceBits bytes off x =
      (bytes &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  by_cases h1 : off ≤ i
  · by_cases h2 : i < off + w
    · have h3 : i - off < n := by omega
      have h4 : i - off < w := by omega
      simp [h1, h2, hi, h3, h4, show ¬i < off by omega]
    · have h4 : ¬i - off < w := by omega
      have hx : x.getLsbD (i - off) = false := BitVec.getLsbD_of_ge x _ (by omega)
      simp [h1, h2, hi, h4, hx]
  · simp [h1, hi, show i < off by omega]

/-- A loop counter below `2^63 - 1` increments without signed or unsigned overflow. -/
public theorem counter_overflow {i : Nat} (h : i + 1 < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 1#64 = false ∧ (BitVec.ofNat 64 i).uaddOverflow 1#64 = false :=
  ⟨Firedancer.saddOverflow_one64 h, Firedancer.uaddOverflow_one64 (by omega)⟩

/-- Reads of a block held alike. -/
public theorem readAt_congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) :
    m'.readAt p w = m.readAt p w := by
  unfold MemoryState.readAt; rw [h]

/-- Erasing from `N` keeps the blocks below it. -/
public theorem getElem?_eraseFrom {m : MemoryState} {b : BlockId} (hb : b.id < N) :
    (m.eraseFrom N)[b]? = m[b]? := by
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter', hb,
    decide_true]
  cases m.mem[b]? <;> rfl

/-- Reads below `N`, after erasing from it. -/
public theorem readAt_eraseFrom {m : MemoryState} {p : Pointer} (hp : p.id.id < N) :
    (m.eraseFrom N).readAt p w = m.readAt p w :=
  readAt_congr (getElem?_eraseFrom hp)

/-- Known bits below `N` stay known after erasing from it. -/
public theorem Fits.eraseFrom {m : MemoryState} {p : Pointer} (hp : p.id.id < N) (h : Fits m p w) :
    Fits (m.eraseFrom N) p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  exact ⟨b, (getElem?_eraseFrom hp).trans hb, hl, hw, hd⟩

/-- Memories erasing alike from `N` hold the blocks below it alike. -/
public theorem getElem?_of_eraseFrom {m m' : MemoryState} {b : BlockId}
    (he : m'.eraseFrom N = m.eraseFrom N) (hb : b.id < N) : m'[b]? = m[b]? := by
  rw [← getElem?_eraseFrom (m := m') hb, he, getElem?_eraseFrom hb]

/-- A read below two `alloca`s: the read before them. -/
public theorem readAt_alloca₂ {s : GlobalState} {q : Pointer} (hwf : s.WF)
    (h : InBounds s.mem q w) : ((s.alloca n d).alloca n' d').mem.readAt q w = s.mem.readAt q w := by
  rw [MemoryState.readAt_alloca_of_fits hwf.alloca (InBounds.alloca hwf h),
    MemoryState.readAt_alloca_of_fits hwf h]

end MLIR.Zig

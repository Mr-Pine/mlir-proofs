module

public import Firedancer.Common.Point
public import Zig.Common.Memory
import MLIR.Run.Tactic.Memory
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
public import Mathlib.Data.BitVec
import Std.Tactic.BVDecide

/-! Field elements as Zig's `Fe` holds them: five 64-bit limbs of 51 bits' weight, at the layout
`readLimbs` reads; the five 128-bit columns of a product. -/

namespace MLIR.Zig

open Memory

@[expose] public section

/-- Every limb below `c`. -/
abbrev Fe.Lt (l : Fin 5 → BitVec 64) (c : ℕ) : Prop :=
  ∀ i, (l i).toNat < c

/-- Five limbs, lowest first. -/
def Fe.mk5 (a0 a1 a2 a3 a4 : BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => a0
  | ⟨1, _⟩ => a1
  | ⟨2, _⟩ => a2
  | ⟨3, _⟩ => a3
  | ⟨4, _⟩ => a4

/-- `MASK51`. -/
abbrev Fe.mask : BitVec 64 :=
  0x7ffffffffffff#64

/-- The limbs' bits, limb `0` lowest. -/
def limbsBits (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- The five 128-bit columns of a product, as `_carry128` reads them at `p`. -/
def _root_.MLIR.MemoryState.readWide (m : MemoryState) (p : Pointer) : Fin 5 → BitVec 128
  | ⟨0, _⟩ => m.readAt p 128
  | ⟨1, _⟩ => m.readAt (p.add 16#64) 128
  | ⟨2, _⟩ => m.readAt (p.add 32#64) 128
  | ⟨3, _⟩ => m.readAt (p.add 48#64) 128
  | ⟨4, _⟩ => m.readAt (p.add 64#64) 128

/-- The columns `1 … 4` written back at `p`, as `_carry128` writes them. -/
abbrev _root_.MLIR.MemoryState.storeWideTail (m : MemoryState) (p : Pointer)
    (x : Fin 5 → BitVec 128) : MemoryState :=
  (((m.storeAt (p.add 16#64) (x 1)).storeAt (p.add 32#64) (x 2)).storeAt (p.add 48#64)
        (x 3)).storeAt
    (p.add 64#64) (x 4)

/-- The five columns at `p` are known, and their offsets do not wrap. -/
abbrev _root_.MLIR.MemoryState.WideFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 64 < 2 ^ 64 ∧
    Fits m p 128 ∧
    Fits m (p.add 16#64) 128 ∧
    Fits m (p.add 32#64) 128 ∧ Fits m (p.add 48#64) 128 ∧ Fits m (p.add 64#64) 128

/-- Room for the five columns at `p`, their offsets not wrapping. -/
abbrev _root_.MLIR.MemoryState.WideRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 64 < 2 ^ 64 ∧
    Room m p 128 ∧
    Room m (p.add 16#64) 128 ∧
    Room m (p.add 32#64) 128 ∧ Room m (p.add 48#64) 128 ∧ Room m (p.add 64#64) 128

attribute [mlir_mem] MemoryState.WideFit MemoryState.WideRoom

end

/-- Limbs are their five values. -/
public theorem Fe.eta5 (x : Fin 5 → BitVec 64) : x = Fe.mk5 (x 0) (x 1) (x 2) (x 3) (x 4) := by
  funext i
  fin_cases i <;> rfl

/-- `storeLimbs` as the five stores the code makes, given each limb. -/
public theorem storeLimbs_of_eq {m : MemoryState} {p : Pointer} {x : Fin 5 → BitVec 64}
    {y0 y1 y2 y3 y4 : BitVec 64} (h0 : x 0 = y0) (h1 : x 1 = y1) (h2 : x 2 = y2) (h3 : x 3 = y3)
    (h4 : x 4 = y4) :
    m.storeLimbs p x =
      ((((m.storeAt p y0).storeAt (p.add 8#64) y1).storeAt (p.add 16#64) y2).storeAt (p.add 24#64)
            y3).storeAt
        (p.add 32#64) y4 := by
  subst h0 h1 h2 h3 h4
  rfl

/-! ### Limbs as one 320-bit value -/

/-- Bit `j` of the limbs' bits: bit `j % 64` of limb `j / 64`. -/
public theorem getLsbD_limbsBits (l : Fin 5 → BitVec 64) (j : Nat) :
    (limbsBits l).getLsbD j =
      if j < 64 then (l 0).getLsbD j
      else
        if j < 128 then (l 1).getLsbD (j - 64)
        else
          if j < 192 then (l 2).getLsbD (j - 128)
          else if j < 256 then (l 3).getLsbD (j - 192) else (l 4).getLsbD (j - 256) := by
  simp only [limbsBits, BitVec.getLsbD_append]
  simp only [Nat.sub_sub, Nat.reduceAdd]
  split_ifs <;>
    first
    | (exfalso; omega)
    | rfl

/-- Five limbs spliced in one after another: their bits spliced in at once. -/
theorem splice5 {n : Nat} (b : BitVec n) (o : Nat) (l : Fin 5 → BitVec 64) :
    spliceBits
        (spliceBits (spliceBits (spliceBits (spliceBits b o (l 0)) (o + 64) (l 1)) (o + 128) (l 2))
          (o + 192) (l 3))
        (o + 256) (l 4) =
      spliceBits b o (limbsBits l) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits, getLsbD_limbsBits]
  by_cases h0 : o ≤ i <;> by_cases h1 : i < o + 64 <;> by_cases h2 : i < o + 128 <;>
    by_cases h3 : i < o + 192 <;>
    by_cases h4 : i < o + 256 <;>
    by_cases h5 : i < o + 320 <;>
    simp (disch := omega) only [ite_eq_left, ite_eq_right, Nat.sub_sub] <;>
    omega

/-- All-ones limbs' bits are all ones. -/
theorem limbsBits_allOnes : limbsBits (fun _ => BitVec.allOnes 64) = BitVec.allOnes 320 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_limbsBits, BitVec.getLsbD_allOnes]
  split_ifs <;> simp <;> omega

/-- Storing limbs is storing their bits at once. -/
public theorem _root_.MLIR.MemoryState.storeLimbs_eq_storeAt {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeLimbs p l = m.storeAt p (limbsBits l) := by
  have hp : p.offsetInBits = 8 * p.offset.toNat := rfl
  have o (k : Nat) (hk : k ≤ 32) :
    (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + 8 * k :=
    hp ▸ Pointer.offsetInBits_add_limb h hk
  simp only [MemoryState.storeLimbs, MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
  rw [o 8 (by omega), o 16 (by omega), o 24 (by omega), o 32 (by omega)]
  refine ⟨heq_of_eq (splice5 _ _ l), heq_of_eq ?_⟩
  rw [← limbsBits_allOnes]
  exact splice5 _ _ (fun _ => BitVec.allOnes 64)

/-- Limbs whose 320 bits are known, offsets not wrapping, are limbs that fit. -/
public theorem _root_.MLIR.MemoryState.LimbsFit.of_fits' {m : MemoryState} {p : Pointer}
    (h : Fits m p 320) (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 32 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) h

/-- Limbs that fit are 320 known bits. -/
public theorem _root_.MLIR.MemoryState.LimbsFit.fits {m : MemoryState} {p : Pointer}
    (h : m.LimbsFit p) : Fits m p 320 := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 32 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    have := h.1
    omega
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := h
  have a1 := Fits.append (hov 8#64 (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (hov 16#64 (by decide)) (by decide) rfl a1 h2
  have a3 := Fits.append (hov 24#64 (by decide)) (by decide) rfl a2 h3
  exact Fits.append (hov 32#64 (by decide)) (by decide) rfl a3 h4

/-- Room for limbs is room for their 320 bits. -/
public theorem _root_.MLIR.MemoryState.LimbsRoom.room {m : MemoryState} {p : Pointer}
    (h : m.LimbsRoom p) : Room m p 320 := by
  obtain ⟨ho, ⟨blk, hblk, hl, -⟩, -, -, -, ⟨blk', hblk', -, hsz⟩⟩ := h
  have hb : blk' = blk := Option.some.inj (hblk'.symm.trans hblk)
  subst hb
  have o32 := Pointer.offsetInBits_add_limb (k := 32) ho (by omega)
  have hp : p.offsetInBits = 8 * p.offset.toNat := rfl
  refine ⟨blk', hblk, hl, ?_⟩
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, o32] at hsz
  omega

/-- The 320 bits at limbs that fit: the limbs' bits. -/
public theorem _root_.MLIR.MemoryState.readAt_eq_limbsBits {m : MemoryState} {p : Pointer}
    (h : m.LimbsFit p) : m.readAt p 320 = limbsBits (m.readLimbs p) := by
  conv_lhs => rw [← MemoryState.storeLimbs_readLimbs_self h]
  rw [MemoryState.storeLimbs_eq_storeAt h.1, MemoryState.readAt_storeAt_self h.fits.inBounds]

/-- A field element copied whole (a `memcpy` of 40 bytes): its limbs stored. -/
public theorem _root_.MLIR.MemoryState.storeAt_readAt_eq_storeLimbs {m m' : MemoryState}
    {p q : Pointer} (hq : m'.LimbsFit q) (hp : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeAt p (m'.readAt q 320) = m.storeLimbs p (m'.readLimbs q) := by
  rw [MemoryState.readAt_eq_limbsBits hq, MemoryState.storeLimbs_eq_storeAt hp]

/-- Five limb stores at `p`, read back. -/
public theorem _root_.MLIR.MemoryState.readLimbs_stores {m : MemoryState} {p : Pointer}
    (h : m.LimbsRoom p) (x : Fin 5 → BitVec 64) :
    (((((m.storeAt p (x 0)).storeAt (p.add 8#64) (x 1)).storeAt (p.add 16#64) (x 2)).storeAt
                (p.add 24#64) (x 3)).storeAt
            (p.add 32#64) (x 4)).readLimbs
        p =
      x := by
  rw [← storeLimbs_of_eq rfl rfl rfl rfl rfl]
  exact MemoryState.readLimbs_storeLimbs_self h

/-! ### Limbs read past stores -/

/-- Limbs in another block are unaffected by a store. -/
@[mlir_read]
public theorem _root_.MLIR.MemoryState.readLimbs_storeAt_of_id_ne {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : q.id ≠ p.id) : (m.storeAt q x).readLimbs p = m.readLimbs p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, Tactic.readThroughStore]

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storeLimbs_0 {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.LimbsRoom p) : (m.storeLimbs p l).readAt p 64 = l 0 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 0

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storeLimbs_1 {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.LimbsRoom p) : (m.storeLimbs p l).readAt (p.add 8#64) 64 = l 1 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 1

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storeLimbs_2 {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.LimbsRoom p) :
    (m.storeLimbs p l).readAt (p.add 16#64) 64 = l 2 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 2

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storeLimbs_3 {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.LimbsRoom p) :
    (m.storeLimbs p l).readAt (p.add 24#64) 64 = l 3 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 3

@[mlir_read]
public theorem _root_.MLIR.MemoryState.readAt_storeLimbs_4 {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.LimbsRoom p) :
    (m.storeLimbs p l).readAt (p.add 32#64) 64 = l 4 :=
  congrFun (MemoryState.readLimbs_storeLimbs_self (l := l) h) 4

/-! ### Limb bounds carried across steps -/

public theorem Fe.Lt.mono {l : Fin 5 → BitVec 64} {a b : ℕ} (h : Fe.Lt l a) (hab : a ≤ b) :
    Fe.Lt l b := fun i => Nat.lt_of_lt_of_le (h i) hab

@[mlir_transport]
public theorem Fe.Lt.alloca {s : GlobalState} {p : Pointer} {c : ℕ} (hne : p.id ≠ s.allocaPtr.id)
    (h : Fe.Lt (s.mem.readLimbs p) c) : Fe.Lt ((s.alloca n d).mem.readLimbs p) c := by
  rwa [MemoryState.readLimbs_alloca hne]

@[mlir_transport]
public theorem Fe.Lt.addBlock {s : GlobalState} {p : Pointer} {c : ℕ} {x : BitVec v} (hwf : s.WF)
    (hp : s.mem.LimbsRoom p) (h : Fe.Lt (s.mem.readLimbs p) c) :
    Fe.Lt ((s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).readLimbs p) c := by
  rwa [MemoryState.readLimbs_addBlock hwf hp]

@[mlir_transport]
public theorem Fe.Lt.storeLimbs {m : MemoryState} {p q : Pointer} {c : ℕ} {l : Fin 5 → BitVec 64}
    (hne : q.id ≠ p.id) (h : Fe.Lt (m.readLimbs p) c) :
    Fe.Lt ((m.storeLimbs q l).readLimbs p) c := by
  rwa [MemoryState.readLimbs_storeLimbs_of_id_ne hne]

@[mlir_transport]
public theorem Fe.Lt.storeLimbs_of_disjoint {m : MemoryState} {p q : Pointer} {c : ℕ}
    {l : Fin 5 → BitVec 64} (hd : (Range.of q 320).Disjoint (Range.of p 320))
    (hq : q.offset.toNat + 32 < 2 ^ 64) (hp : p.offset.toNat + 32 < 2 ^ 64)
    (h : Fe.Lt (m.readLimbs p) c) : Fe.Lt ((m.storeLimbs q l).readLimbs p) c := by
  rwa [MemoryState.readLimbs_storeLimbs_of_disjoint hd hq hp]

@[mlir_transport]
public theorem Fe.Lt.storeAt {m : MemoryState} {p q : Pointer} {c : ℕ} {x : BitVec w}
    (hne : q.id ≠ p.id) (h : Fe.Lt (m.readLimbs p) c) : Fe.Lt ((m.storeAt q x).readLimbs p) c := by
  rwa [MemoryState.readLimbs_storeAt_of_id_ne hne]

@[mlir_transport]
public theorem Fe.Lt.lifetimeStart {m : MemoryState} {p q : Pointer} {c : ℕ}
    (h : Fe.Lt (m.readLimbs p) c) : Fe.Lt ((m.lifetimeStart q).readLimbs p) c := by
  rwa [MemoryState.readLimbs_lifetimeStart]

@[mlir_transport]
public theorem Fe.Lt.lifetimeEnd {m : MemoryState} {p q : Pointer} {c : ℕ}
    (h : Fe.Lt (m.readLimbs p) c) : Fe.Lt ((m.lifetimeEnd q).readLimbs p) c := by
  rwa [MemoryState.readLimbs_lifetimeEnd]

/-! ### Columns -/

/-- Stores keep every block's length and lifetime, so the columns keep their room. -/
@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.WideRoom.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.WideRoom p) : (m.storeAt q x).WideRoom p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt, h.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.WideRoom.storeLimbs {m : MemoryState} {p q : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.WideRoom p) : (m.storeLimbs q l).WideRoom p := by
  unfold MemoryState.storeLimbs
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt

/-- A store keeps known bits known, so the columns stay known. -/
@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.WideFit.storeAt {m : MemoryState} {p q : Pointer}
    {x : BitVec w} (h : m.WideFit p) : (m.storeAt q x).WideFit p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt, h.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
public theorem _root_.MLIR.MemoryState.WideFit.storeLimbs {m : MemoryState} {p q : Pointer}
    {l : Fin 5 → BitVec 64} (h : m.WideFit p) : (m.storeLimbs q l).WideFit p :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.1.storeLimbs, h.2.2.2.2.1.storeLimbs,
    h.2.2.2.2.2.storeLimbs⟩

public theorem _root_.MLIR.MemoryState.WideFit.room {m : MemoryState} {p : Pointer}
    (h : m.WideFit p) : m.WideRoom p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.1.room, h.2.2.2.2.1.room, h.2.2.2.2.2.room⟩

/-- An 80-byte live block from its start has room for five columns. -/
public theorem _root_.MLIR.MemoryState.WideRoom.of_room {m : MemoryState} {p : Pointer}
    (h : Room m p 640) (ho : p.offset = 0) : m.WideRoom p := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 64 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp [ho, BitVec.uaddOverflow]
    omega
  refine ⟨by simp [ho], h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) h

/-- Five columns stored where there is room, lowest first, read back. -/
public theorem _root_.MLIR.MemoryState.readWide_stores {m : MemoryState} {p : Pointer}
    (h : m.WideRoom p) (x0 x1 x2 x3 x4 : BitVec 128) :
    (((((m.storeAt p x0).storeAt (p.add 16#64) x1).storeAt (p.add 32#64) x2).storeAt (p.add 48#64)
                x3).storeAt
            (p.add 64#64) x4).readWide
        p =
      fun
      | ⟨0, _⟩ => x0
      | ⟨1, _⟩ => x1
      | ⟨2, _⟩ => x2
      | ⟨3, _⟩ => x3
      | ⟨4, _⟩ => x4 := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  funext i
  fin_cases i <;> simp only [MemoryState.readWide, Tactic.readThroughStore]

/-- Five columns stored where there is room are known. -/
public theorem _root_.MLIR.MemoryState.WideFit.stores {m : MemoryState} {p : Pointer}
    (h : m.WideRoom p) (x0 x1 x2 x3 x4 : BitVec 128) :
    (((((m.storeAt p x0).storeAt (p.add 16#64) x1).storeAt (p.add 32#64) x2).storeAt (p.add 48#64)
              x3).storeAt
          (p.add 64#64) x4).WideFit
      p := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact
    ⟨ho, (Fits.storeAt_self h0).storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h1.storeAt).storeAt.storeAt.storeAt,
      (Fits.storeAt_self h2.storeAt.storeAt).storeAt.storeAt,
      (Fits.storeAt_self h3.storeAt.storeAt.storeAt).storeAt,
      Fits.storeAt_self h4.storeAt.storeAt.storeAt.storeAt⟩

/-! ### Limb arithmetic -/

/-- A `shl nuw` by one does not overflow below `2^63`. -/
public theorem shl1_shr1 {x : BitVec 64} (h : x.toNat < 2 ^ 63) : x <<< 1 >>> 1 = x := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_ushiftRight, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq,
    Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (by omega)]; omega

/-- `x <<< 1` doubles `x` below `2^63`. -/
public theorem shl1_toNat {x : BitVec 64} (h : x.toNat < 2 ^ 63) :
    (x <<< 1).toNat = 2 * x.toNat := by
  simp only [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
  rw [Nat.mod_eq_of_lt (by omega)]; omega

/-- `-19`, as the code multiplies by it. -/
public theorem neg19_eq : (18446744073709551597#64) = -19#64 := by decide

/-- A masked limb is below `2^51`. -/
public theorem mask_lt (x : BitVec 64) : (x &&& Fe.mask).toNat < 2 ^ 51 := by
  have : (x &&& Fe.mask).toNat ≤ 2251799813685247 := by
    rw [BitVec.toNat_and]; exact Nat.and_le_right
  omega

/-- A carry plus a masked limb is below `2^52`. -/
public theorem shr_add_mask_lt (x y : BitVec 64) :
    ((x >>> 51) + (y &&& Fe.mask)).toNat < 2 ^ 52 := by
  have h1 := mask_lt y
  have h2 : (x >>> 51).toNat < 2 ^ 13 := by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; have := x.isLt; omega
  rw [BitVec.toNat_add]; omega

/-- A sum below `2^64` does not overflow. -/
public theorem uaddOverflow_eq_false {x y : BitVec 64} (h : y.toNat + x.toNat < 2 ^ 64) :
    x.uaddOverflow y = false := by
  simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, not_le]
  omega

/-- A carry, below `2^13`, added to a limb below `2^63` does not overflow. -/
public theorem shr51_uaddOverflow {x y : BitVec 64} (hy : y.toNat < 2 ^ 63) :
    (x >>> 51).uaddOverflow y = false := by
  apply uaddOverflow_eq_false
  have := x.isLt
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

/-- The same, the limb first. -/
public theorem uaddOverflow_shr51 {x y : BitVec 64} (hy : y.toNat < 2 ^ 63) :
    y.uaddOverflow (x >>> 51) = false := by
  apply uaddOverflow_eq_false
  have := x.isLt
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

/-- A carry times `-19` does not overflow. -/
public theorem shr51_smulOverflow (x : BitVec 64) :
    (x >>> 51).smulOverflow 18446744073709551597#64 = false := by bv_decide

/-- `2^52 - 2`, `2p`'s high limbs, added to a limb below `2^63`, does not overflow. -/
public theorem uaddOverflow_twoP {x : BitVec 64} (h : x.toNat < 2 ^ 63) :
    x.uaddOverflow 4503599627370494#64 = false := by
  have : (4503599627370494#64).toNat = 4503599627370494 := rfl
  exact uaddOverflow_eq_false (by omega)

/-- A masked limb is below `2^52 - 2`, so subtracting it from `x + 2^52 - 2` does not wrap. -/
public theorem usubOverflow_twoP {x : BitVec 64} (y : BitVec 64) (h : x.toNat < 2 ^ 63) :
    (x + 4503599627370494#64).usubOverflow (y &&& 2251799813685247#64) = false := by
  have h1 : (y &&& 2251799813685247#64).toNat ≤ 2251799813685247 := by
    rw [BitVec.toNat_and]; exact Nat.and_le_right
  have h2 : (x + 4503599627370494#64).toNat = x.toNat + 4503599627370494 := by
    rw [BitVec.toNat_add]
    have : (4503599627370494#64).toNat = 4503599627370494 := rfl
    rw [this]
    exact Nat.mod_eq_of_lt (by omega)
  simp only [BitVec.usubOverflow, decide_eq_false_iff_not, Nat.not_lt]
  omega

/-! ### Column arithmetic -/

/-- A column below `2^115` passes `_carry128`'s range check. -/
public theorem ult_two115 {x : BitVec 128} (h : x.toNat < 2 ^ 115) :
    x.ult 41538374868278621028243970633760768#128 = true := by
  simp only [BitVec.ult, decide_eq_true_eq]
  have : (41538374868278621028243970633760768#128).toNat = 2 ^ 115 := rfl
  omega

/-- A carry added to a column, exactly. -/
public theorem toNat_add_shr51 {x y : BitVec 128} (hx : x.toNat < 2 ^ 115 - 2 ^ 64)
    (hy : y.toNat < 2 ^ 115) : (x + (y >>> 51)).toNat = x.toNat + y.toNat / 2 ^ 51 := by
  rw [BitVec.toNat_add, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  apply Nat.mod_eq_of_lt
  have : y.toNat / 2 ^ 51 < 2 ^ 64 := by omega
  omega

/-- The same sum stays below `2^115`. -/
public theorem add_shr51_lt {x y : BitVec 128} (hx : x.toNat < 2 ^ 115 - 2 ^ 64)
    (hy : y.toNat < 2 ^ 115) : (x + (y >>> 51)).toNat < 2 ^ 115 := by
  rw [toNat_add_shr51 hx hy]; omega

/-- The same sum, below `x + 2^64`. -/
public theorem add_shr51_lt_add {x y : BitVec 128} (hx : x.toNat < 2 ^ 115 - 2 ^ 64)
    (hy : y.toNat < 2 ^ 115) : (x + (y >>> 51)).toNat < x.toNat + 2 ^ 64 := by
  rw [toNat_add_shr51 hx hy]; omega

/-- The same sum overflows neither unsigned nor signed. -/
public theorem add_shr51_overflow {x y : BitVec 128} (hx : x.toNat < 2 ^ 115 - 2 ^ 64)
    (hy : y.toNat < 2 ^ 115) :
    x.uaddOverflow (y >>> 51) = false ∧ x.saddOverflow (y >>> 51) = false := by
  have hs : (y >>> 51).toNat < 2 ^ 64 := by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
  constructor
  · simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le]; omega
  · simp only [BitVec.saddOverflow, Bool.or_eq_false_iff, decide_eq_false_iff_not, Int.not_le,
      Int.not_lt]
    rw [BitVec.toInt_eq_toNat_of_lt (by omega), BitVec.toInt_eq_toNat_of_lt (by omega)]
    omega

/-- A column's carry. -/
public theorem toNat_shr51 {x : BitVec 128} : (x >>> 51).toNat = x.toNat / 2 ^ 51 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- The carry of a column below `2^115` fits in 64 bits. -/
public theorem setWidth_shr51 {x : BitVec 128} (h : x.toNat < 2 ^ 115) :
    BitVec.setWidth 128 (BitVec.setWidth 64 (x >>> 51)) = x >>> 51 := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, toNat_shr51]
  rw [Nat.mod_eq_of_lt (a := x.toNat / 2 ^ 51 % 2 ^ 64) (by omega), Nat.mod_eq_of_lt (by omega)]

/-- The top carry, of a column below `3 · 2^109 + 2^64`. -/
public theorem toNat_top {x : BitVec 128} (h : x.toNat < 3 * 2 ^ 109 + 2 ^ 64) :
    (BitVec.setWidth 64 (x >>> 51)).toNat = x.toNat / 2 ^ 51 := by
  simp only [BitVec.toNat_setWidth, toNat_shr51]
  omega

/-- `19` times the top carry does not overflow. -/
public theorem top_umulOverflow {x : BitVec 128} (h : x.toNat < 3 * 2 ^ 109 + 2 ^ 64) :
    (BitVec.setWidth 64 (x >>> 51)).umulOverflow 19#64 = false := by
  have : (19#64).toNat = 19 := rfl
  simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_top h, this]
  omega

/-- Nor does adding a masked limb to it. -/
public theorem top_uaddOverflow {x : BitVec 128} (h : x.toNat < 3 * 2 ^ 109 + 2 ^ 64)
    (y : BitVec 64) :
    (BitVec.setWidth 64 (x >>> 51) * 19#64).uaddOverflow (y &&& 2251799813685247#64) = false := by
  have hy : (y &&& 2251799813685247#64).toNat ≤ 2251799813685247 := by
    rw [BitVec.toNat_and]; exact Nat.and_le_right
  have : (19#64).toNat = 19 := rfl
  have hm : (BitVec.setWidth 64 (x >>> 51) * 19#64).toNat = x.toNat / 2 ^ 51 * 19 := by
    rw [BitVec.toNat_mul, toNat_top h, this]; omega
  simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le, hm]
  omega

/-- A carry plus a masked limb overflows neither unsigned nor signed. -/
public theorem shr51_mask_overflow (x y : BitVec 64) :
    (x >>> 51).uaddOverflow (y &&& 2251799813685247#64) = false ∧
      (x >>> 51).saddOverflow (y &&& 2251799813685247#64) = false := by
  constructor <;> bv_decide

/-! ### Products -/

/-- A zero-extended limb. -/
public theorem toNat_zext (x : BitVec 64) : (BitVec.setWidth 128 x).toNat = x.toNat := by
  rw [BitVec.toNat_setWidth]
  exact
    Nat.mod_eq_of_lt
      (by
        have := x.isLt; omega)

/-- A zero-extended limb times 19 overflows neither way. -/
public theorem zext_mul19_overflow (x : BitVec 64) :
    (BitVec.setWidth 128 x).smulOverflow 19#128 = false ∧
      (BitVec.setWidth 128 x).umulOverflow 19#128 = false := by
  constructor <;> bv_decide

/-- A zero-extended limb times 19, exactly. -/
public theorem toNat_zext_mul19 (x : BitVec 64) :
    (BitVec.setWidth 128 x * 19#128).toNat = x.toNat * 19 := by
  have := x.isLt
  rw [BitVec.toNat_mul, toNat_zext]
  have : (19#128).toNat = 19 := rfl
  rw [this]; omega

/-- A product of zero-extended limbs does not overflow. -/
public theorem zmul_umul (x y : BitVec 64) :
    (BitVec.setWidth 128 x).umulOverflow (BitVec.setWidth 128 y) = false := by
  have := Nat.mul_lt_mul'' x.isLt y.isLt
  simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_zext]
  omega

/-- Nor does one with a factor 19, for limbs below `2^54`. -/
public theorem zmul19_umul {x y : BitVec 64} (hx : x.toNat < 2 ^ 54) (hy : y.toNat < 2 ^ 54) :
    (BitVec.setWidth 128 x * 19#128).umulOverflow (BitVec.setWidth 128 y) = false := by
  have := Nat.mul_lt_mul'' hx hy
  simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_zext, toNat_zext_mul19]
  rw [Nat.mul_right_comm]
  omega

/-- A product of limbs below `2^54` is below `2^108`. -/
public theorem zmul_lt {x y : BitVec 64} (hx : x.toNat < 2 ^ 54) (hy : y.toNat < 2 ^ 54) :
    (BitVec.setWidth 128 x * BitVec.setWidth 128 y).toNat < 2 ^ 108 := by
  have := Nat.mul_lt_mul'' hx hy
  rw [BitVec.toNat_mul, toNat_zext, toNat_zext]
  omega

/-- With a factor 19, below `19 · 2^108`. -/
public theorem zmul19_lt {x y : BitVec 64} (hx : x.toNat < 2 ^ 54) (hy : y.toNat < 2 ^ 54) :
    (BitVec.setWidth 128 x * 19#128 * BitVec.setWidth 128 y).toNat < 19 * 2 ^ 108 := by
  have := Nat.mul_lt_mul'' hx hy
  rw [BitVec.toNat_mul, toNat_zext_mul19, toNat_zext, Nat.mul_right_comm,
    Nat.mod_eq_of_lt (by omega)]
  omega

/-- A zero-extended limb times a constant below `2^63` overflows neither way. -/
public theorem zext_mulk_overflow (x : BitVec 64) {k : Nat} (hk : k < 2 ^ 63) :
    (BitVec.setWidth 128 x).smulOverflow (BitVec.ofNat 128 k) = false ∧
      (BitVec.setWidth 128 x).umulOverflow (BitVec.ofNat 128 k) = false := by
  have hx := x.isLt
  have hkn : (BitVec.ofNat 128 k).toNat = k := by
    simp; omega
  have hp : x.toNat * k < 2 ^ 127 := by
    calc
      x.toNat * k < 2 ^ 64 * 2 ^ 63 := Nat.mul_lt_mul'' hx hk
      _ = 2 ^ 127 := by norm_num
  constructor
  · simp only [BitVec.smulOverflow, Bool.or_eq_false_iff, decide_eq_false_iff_not, Int.not_le,
      Int.not_lt]
    rw [BitVec.toInt_eq_toNat_of_lt
        (by
          rw [toNat_zext]; omega),
      BitVec.toInt_eq_toNat_of_lt (by omega), toNat_zext, hkn]
    constructor <;> push_cast <;> omega
  · simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_zext, hkn]
    omega

/-- The same product, exactly. -/
public theorem toNat_zext_mulk (x : BitVec 64) {k : Nat} (hk : k < 2 ^ 63) :
    (BitVec.setWidth 128 x * BitVec.ofNat 128 k).toNat = x.toNat * k := by
  have hx := x.isLt
  have hkn : (BitVec.ofNat 128 k).toNat = k := by
    simp; omega
  have hp : x.toNat * k < 2 ^ 127 := by
    calc
      x.toNat * k < 2 ^ 64 * 2 ^ 63 := Nat.mul_lt_mul'' hx hk
      _ = 2 ^ 127 := by norm_num
  rw [BitVec.toNat_mul, toNat_zext, hkn]; omega

/-- A product of limbs below `2^54` with a factor `k` is below `k · 2^108` and does not overflow. -/
public theorem zmulk_lt {x y : BitVec 64} {k : Nat} (hk0 : 0 < k) (hk : k < 2 ^ 19)
    (hx : x.toNat < 2 ^ 54) (hy : y.toNat < 2 ^ 54) :
    (BitVec.setWidth 128 x * BitVec.ofNat 128 k * BitVec.setWidth 128 y).toNat < k * 2 ^ 108 ∧
      (BitVec.setWidth 128 x * BitVec.ofNat 128 k).umulOverflow (BitVec.setWidth 128 y) =
        false := by
  have := Nat.mul_lt_mul'' hx hy
  have hkk : k * (x.toNat * y.toNat) ≤ k * (2 ^ 54 * 2 ^ 54) :=
    Nat.mul_le_mul_left _ (Nat.le_of_lt this)
  have e : x.toNat * k * y.toNat = k * (x.toNat * y.toNat) := by ring
  constructor
  · rw [BitVec.toNat_mul, toNat_zext_mulk x (by omega), toNat_zext, Nat.mod_eq_of_lt (by omega)]
    calc
      x.toNat * k * y.toNat = k * (x.toNat * y.toNat) := e
      _ < k * 2 ^ 108 := Nat.mul_lt_mul_of_pos_left (by omega) hk0
  · simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_zext,
      toNat_zext_mulk x (by omega : k < 2 ^ 63)]
    omega

/-- A zero-extended limb doubled by a shift. -/
public theorem toNat_zext_shl1 (x : BitVec 64) :
    (BitVec.setWidth 128 x <<< 1).toNat = 2 * x.toNat := by
  have := x.isLt
  rw [BitVec.toNat_shiftLeft, toNat_zext, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
  omega

/-- A shift by one is a doubling. -/
public theorem shl1_eq (x : BitVec 128) : x <<< 1 = 2#128 * x := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_mul, Nat.shiftLeft_eq]
  have : (2#128).toNat = 2 := rfl
  rw [this]; omega

/-- Doubling a zero-extended limb by a shift loses no bit. -/
public theorem zext_shl1 (x : BitVec 64) :
    BitVec.setWidth 128 x <<< 1 >>> 1 = BitVec.setWidth 128 x ∧
      (BitVec.setWidth 128 x <<< 1).sshiftRight 1 = BitVec.setWidth 128 x := by
  constructor <;> bv_decide

/-- A doubled product of limbs below `2^54` is below `2 · 2^108` and does not overflow. -/
public theorem zshl_lt {x y : BitVec 64} (hx : x.toNat < 2 ^ 54) (hy : y.toNat < 2 ^ 54) :
    ((BitVec.setWidth 128 x <<< 1) * BitVec.setWidth 128 y).toNat < 2 * 2 ^ 108 ∧
      (BitVec.setWidth 128 x <<< 1).umulOverflow (BitVec.setWidth 128 y) = false := by
  have := Nat.mul_lt_mul'' hx hy
  constructor
  · rw [BitVec.toNat_mul, toNat_zext_shl1, toNat_zext, Nat.mul_assoc, Nat.mod_eq_of_lt (by omega)]
    omega
  · simp only [BitVec.umulOverflow, decide_eq_false_iff_not, Nat.not_le, toNat_zext,
      toNat_zext_shl1, Nat.mul_assoc]
    omega

end MLIR.Zig

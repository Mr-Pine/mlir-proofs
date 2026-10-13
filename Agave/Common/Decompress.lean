module

public import Agave.Common.Point
import MLIR.Run.Tactic.Memory

/-! `CompressedEdwardsY::decompress`'s `Option<EdwardsPoint>` in memory: the tag as a `u64` at byte
0 (`0` for `None`), the point at byte 8 (`storeEdwards`, `X, Y, Z, T` at 8, 48, 88, 128). -/

namespace MLIR.Agave

open Memory

@[expose] public section

/-- Store `decompress`'s result at `p` as the code does: the point, then the tag; `none` stores only
the tag `0`. -/
def _root_.MLIR.MemoryState.storeOptEdwards (m : MemoryState) (p : Pointer) :
    Option EdwardsPoint → MemoryState
  | none => m.storeAt p 0#64
  | some P => (m.storeEdwards (p.add 8#64) P).storeAt p 1#64

/-- Room for `decompress`'s result at `p`: its 168 bytes' offsets do not wrap, room for the tag and
the point. -/
abbrev _root_.MLIR.MemoryState.OptEdwardsRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 168 ≤ 2 ^ 64 ∧ Room m p 64 ∧ Room m (p.add 8#64) 1280

/-- A point's 1280 bits, `X` lowest. -/
def edwardsBits (P : EdwardsPoint) : BitVec 1280 :=
  limbsBits P.T ++ (limbsBits P.Z ++ (limbsBits P.Y ++ limbsBits P.X))

end

/-! ## A point's bits -/

/-- Two adjacent reads: one read of both. -/
public theorem readAt_append {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hb : InBounds m p (w + v)) (hov : ¬p.offset.uaddOverflow off)
    (hv : off.toNat * 8 = v) (h1 : m.readAt p v = x) (h2 : m.readAt (p.add off) w = y) :
    m.readAt p (w + v) = y ++ x := by
  subst h1 h2
  obtain ⟨blk, hblk, hsz⟩ := hb
  have hblk' : m[(p.add off).id]? = some blk := hblk
  simp only [MemoryState.readAt, hblk, hblk', Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_append, hi, decide_true, Bool.true_and]
  split
  · simp [*]
  · have : i - v < w := by omega
    simp only [this, decide_true, Bool.true_and]
    congr 1
    omega

/-- The 1280 bits at a point read coordinate by coordinate. -/
public theorem readAt_edwardsBits {m : MemoryState} {p : Pointer} {P : EdwardsPoint}
    (hb : InBounds m p 1280) (ho : p.offset.toNat + 160 ≤ 2 ^ 64)
    (hX : m.readAt p 320 = limbsBits P.X) (hY : m.readAt (p.add 40#64) 320 = limbsBits P.Y)
    (hZ : m.readAt (p.add 80#64) 320 = limbsBits P.Z)
    (hT : m.readAt (p.add 120#64) 320 = limbsBits P.T) : m.readAt p 1280 = edwardsBits P := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 120) : ¬p.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    omega
  have h1 :=
    readAt_append (v := 320) (w := 320) (hb.mono (by decide)) (hov 40#64 (by decide)) (by decide) hX
      hY
  have h2 :=
    readAt_append (v := 640) (w := 320) (hb.mono (by decide)) (hov 80#64 (by decide)) (by decide) h1
      hZ
  exact readAt_append (v := 960) (w := 320) hb (hov 120#64 (by decide)) (by decide) h2 hT

/-- Storing a point's bits is storing the point. -/
public theorem storeAt_edwardsBits {m : MemoryState} {p : Pointer} {P : EdwardsPoint}
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.storeAt p (edwardsBits P) = m.storeEdwards p P := by
  have hov (k : Nat) (hk : k ≤ 120) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hl (k : Nat) (hk : k ≤ 120) : (p.add (BitVec.ofNat 64 k)).offset.toNat + 32 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    omega
  simp only [MemoryState.storeEdwards, MemoryState.storeFe4]
  rw [storeLimbs_eq_storeAt (p := p) (by omega), storeLimbs_eq_storeAt (hl 40 (by omega)),
    storeLimbs_eq_storeAt (hl 80 (by omega)), storeLimbs_eq_storeAt (hl 120 (by omega)),
    MemoryState.storeAt_storeAt_append (k := 40) (hov 40 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 80) (hov 80 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 120) (hov 120 (by omega)) rfl (by decide)]
  rfl

/-! ## The stored result -/

section OptEdwards

variable {m : MemoryState} {p q : Pointer} {P : EdwardsPoint} {P? : Option EdwardsPoint}

/-- Room for 1280 bits that do not wrap: room for a point. -/
public theorem pointRoom_of_room (h : Room m q 1280) (ho : q.offset.toNat + 160 ≤ 2 ^ 64) :
    m.PointRoom q := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 152) : ¬q.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    omega
  have hl (k : BitVec 64) (hk : k.toNat ≤ 120) : m.LimbsRoom (q.add k) := by
    have hr : Room m (q.add k) 320 := Room.add_of_le (hov k (by omega)) (by omega) h
    have hoff : (q.add k).offset.toNat = q.offset.toNat + k.toNat := by
      simp only [Pointer.add, BitVec.toNat_add]
      omega
    have hov' (off : BitVec 64) (hoff' : off.toNat ≤ 32) : ¬(q.add k).offset.uaddOverflow off := by
      simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, hoff]
      omega
    refine ⟨by omega, hr.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
      exact Room.add_of_le (hov' _ (by decide)) (by decide) hr
  exact
    ⟨ho, by simpa [Pointer.add_zero'] using hl 0#64 (by decide), hl 40#64 (by decide),
      hl 80#64 (by decide), hl 120#64 (by decide)⟩

/-- The point at `p + 8` of `decompress`'s result. -/
public theorem optEdwardsRoom_pointRoom (h : m.OptEdwardsRoom p) : m.PointRoom (p.add 8#64) :=
  pointRoom_of_room h.2.2
    (by
      simp only [Pointer.add, BitVec.toNat_add, show (8#64).toNat = 8 from rfl]; omega)

theorem optEdwardsRoom_disjoint (h : m.OptEdwardsRoom p) :
    (Range.of (p.add 8#64) 1280).Disjoint (Range.of p 64) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add, ne_eq,
    not_true_eq_false, false_or]
  right
  have := h.1
  rw [Nat.mod_eq_of_lt
      (by
        simp; omega)]
  simp
  omega

/-- A point result as a tag store below the point store. -/
public theorem storeOptEdwards_some (h : m.OptEdwardsRoom p) :
    m.storeOptEdwards p (some P) = (m.storeAt p 1#64).storeEdwards (p.add 8#64) P := by
  have ho : (p.add 8#64).offset.toNat + 160 ≤ 2 ^ 64 := (optEdwardsRoom_pointRoom h).1
  rw [MemoryState.storeOptEdwards, ← storeAt_edwardsBits ho, ← storeAt_edwardsBits ho,
    MemoryState.storeAt_comm (optEdwardsRoom_disjoint h)]

/-- The tag read back: `1` for a point, `0` for `none`. -/
@[mlir_read]
public theorem readAt_storeOptEdwards_tag (h : m.OptEdwardsRoom p) :
    (m.storeOptEdwards p P?).readAt p 64 = if P?.isSome then 1#64 else 0#64 := by
  cases P? with
  | none => exact MemoryState.readAt_storeAt_self h.2.1 _
  | some P =>
    rw [MemoryState.storeOptEdwards]
    exact MemoryState.readAt_storeAt_self (h.2.1.storeEdwards) _

/-- The point read back. -/
@[mlir_read]
public theorem readEdwards_storeOptEdwards (h : m.OptEdwardsRoom p) :
    (m.storeOptEdwards p (some P)).readEdwards (p.add 8#64) = P := by
  rw [storeOptEdwards_some h]
  exact MemoryState.readEdwards_storeEdwards_self ((optEdwardsRoom_pointRoom h).storeAt)

/-- The point's 1280 bits read back (a `memcpy` of it). -/
@[mlir_read]
public theorem readAt_storeOptEdwards_point (h : m.OptEdwardsRoom p) :
    (m.storeOptEdwards p (some P)).readAt (p.add 8#64) 1280 = edwardsBits P := by
  have ho : (p.add 8#64).offset.toNat + 160 ≤ 2 ^ 64 := (optEdwardsRoom_pointRoom h).1
  rw [MemoryState.storeOptEdwards, ← storeAt_edwardsBits ho,
    MemoryState.storeAt_comm (optEdwardsRoom_disjoint h)]
  exact MemoryState.readAt_storeAt_self (h.2.2.storeAt) _

/-- The tag is known. -/
@[mlir_fresh]
public theorem fits_storeOptEdwards_tag (h : m.OptEdwardsRoom p) :
    Fits (m.storeOptEdwards p P?) p 64 := by
  cases P? with
  | none => exact Fits.storeAt_self h.2.1
  | some P => exact Fits.storeAt_self h.2.1.storeEdwards

/-- A point result is known. -/
@[mlir_fresh]
public theorem pointFit_storeOptEdwards (h : m.OptEdwardsRoom p) :
    (m.storeOptEdwards p (some P)).PointFit (p.add 8#64) := by
  rw [storeOptEdwards_some h]
  exact MemoryState.PointFit.storeEdwards_self (optEdwardsRoom_pointRoom h).storeAt

@[mlir_transport]
public theorem fits_storeOptEdwards (h : Fits m q w) : Fits (m.storeOptEdwards p P?) q w := by
  cases P? <;> simp only [MemoryState.storeOptEdwards]
  · exact h.storeAt
  · exact h.storeEdwards.storeAt

@[mlir_transport]
public theorem room_storeOptEdwards (h : Room m q w) : Room (m.storeOptEdwards p P?) q w := by
  cases P? <;> simp only [MemoryState.storeOptEdwards]
  · exact h.storeAt
  · exact h.storeEdwards.storeAt

@[mlir_transport]
public theorem live_storeOptEdwards (h : Live m q w) : Live (m.storeOptEdwards p P?) q w := by
  cases P? <;>
    simp only [MemoryState.storeOptEdwards, MemoryState.storeEdwards, MemoryState.storeFe4,
      MemoryState.storeLimbs] <;>
    (repeat apply Live.storeAt) <;>
    exact h

/-- `decompress`'s stores keep every block's writability (the steps do not see through the
`match`). -/
public theorem _root_.MLIR.Writable.storeOptEdwards (h : Writable m q) :
    Writable (m.storeOptEdwards p P?) q := by
  cases P? <;>
    simp only [MemoryState.storeOptEdwards, MemoryState.storeEdwards, MemoryState.storeFe4,
      MemoryState.storeLimbs] <;>
    (repeat apply Writable.storeAt) <;>
    exact h

/-- `decompress`'s stores keep the globals table. -/
public theorem _root_.MLIR.MemoryState.globals_storeOptEdwards :
    (m.storeOptEdwards p P?).globals = m.globals := by
  cases P? <;> rfl

@[mlir_transport]
public theorem inBounds_storeOptEdwards (h : InBounds m q w) :
    InBounds (m.storeOptEdwards p P?) q w := by
  cases P? <;> simp only [MemoryState.storeOptEdwards]
  · exact h.storeAt
  · exact h.storeEdwards.storeAt

@[mlir_mem, mlir_transport]
public theorem limbsFit_storeOptEdwards (h : m.LimbsFit q) :
    (m.storeOptEdwards p P?).LimbsFit q := by
  cases P? <;> simp only [MemoryState.storeOptEdwards]
  · exact h.storeAt
  · exact h.storeEdwards.storeAt

@[mlir_mem, mlir_transport]
public theorem pointFit_storeOptEdwards' (h : m.PointFit q) :
    (m.storeOptEdwards p P?).PointFit q := by
  cases P? <;> simp only [MemoryState.storeOptEdwards]
  · exact h.storeAt
  · exact h.storeEdwards.storeAt

@[simp, mlir_mem]
public theorem wf_storeOptEdwards {s : GlobalState} :
    ({ s with mem := m.storeOptEdwards p P? } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  cases P? <;> simp [MemoryState.storeOptEdwards]

/-- `WF` past the result's store, for a state written as a constructor. -/
@[mlir_transport]
public theorem wf_storeOptEdwards_mk {a : AllocState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m.storeOptEdwards p P?⟩ : GlobalState).WF :=
  (wf_storeOptEdwards (s := ⟨a, m⟩)).mpr h

@[mlir_frame, mlir_erase]
public theorem eraseFrom_storeOptEdwards :
    (m.storeOptEdwards p P?).eraseFrom n = (m.eraseFrom n).storeOptEdwards p P? := by
  cases P? <;>
    simp only [MemoryState.storeOptEdwards, MemoryState.eraseFrom_storeAt,
      MemoryState.eraseFrom_storeEdwards]

end OptEdwards

end MLIR.Agave

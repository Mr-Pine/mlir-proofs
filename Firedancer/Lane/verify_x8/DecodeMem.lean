module

public import Firedancer.Lane.verify_x8.DecodeLib
public import Firedancer.Lane.verify_x8.DecodeBuf
import Std.Data.ExtHashMap.Lemmas

/-! Reading `fd_ed25519_lane_decode2`'s field elements back through its stores, lane vector by
lane vector. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512

@[expose] public section

section ReadVec

variable {m : MemoryState} {p q : Pointer}

/-- A store apart from a lane vector's 64 bytes. -/
theorem rv_storeAt_disj {v : Nat} (h : (Range.of p v).Disjoint (Range.of q 512)) (y : BitVec v) :
    (m.storeAt p y).readVec q = m.readVec q := by
  rw [MemoryState.readVec, MemoryState.readVec, MemoryState.readAt_storeAt_disjoint h]

/-- Lanes stored where there is room read back. -/
theorem rv_storeAt_self (h : Room m q 512) (v : Wwl) :
    (m.storeAt q (BitVec.packLanes v)).readVec q = v :=
  MemoryState.readVec_storeVec_self h

/-- A lane vector inside 256 zero bytes stored where there is room: zero. -/
theorem rv_storeAt_zero (h : Room m p 2048) (hp : ¬p.offset.uaddOverflow 256#64) {o : BitVec 64}
    (ho : o.toNat * 8 + 512 ≤ 2048) : (m.storeAt p 0#2048).readVec (p.add o) = wwl_zero := by
  have hf : Fits (m.storeAt p 0#2048) p 2048 := Fits.storeAt_self h
  have hr : (m.storeAt p 0#2048).readAt p 2048 = 0 := MemoryState.readAt_storeAt_self h _
  obtain ⟨_, hz⟩ := zero_limb hp hf hr (o := o) ho
  rw [MemoryState.readVec, hz]
  exact zeroVec_eq

end ReadVec

section Point

variable {m : MemoryState} {P : Pointer}

/-- The side conditions of reads inside a point: ranges apart, room. -/
local macro "pt_side" : tactic =>
  `(tactic| first
    | assumption
    | (refine disjoint_add_le ?_ ?_ ?_ ?_ <;> first | assumption | simp)
    | (refine disjoint_base_le ?_ ?_ ?_ <;> first | assumption | simp)
    | (refine disjoint_le_base ?_ ?_ ?_ <;> first | assumption | simp)
    | ((repeat apply Room.storeAt); exact room_add_le (by assumption) (by assumption) (by simp))
    | ((repeat apply Room.storeAt); exact (by assumption : Room _ _ 10240).mono (by simp))
    | simp)

/-- Offsets inside a point do not wrap. -/
theorem ovf_pt (hP : ¬P.offset.uaddOverflow 1280#64) (a b : BitVec 64)
    (h : a.toNat + b.toNat ≤ 1280) : ¬(P.add a).offset.uaddOverflow b := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, not_le] at hP ⊢
  simp only [Pointer.add, BitVec.toNat_add]
  simp at hP ⊢
  omega

/-- A field element's 320 bytes known from its five limbs'. -/
theorem fits_fe_of_limbs {p : Pointer} (hov : ¬p.offset.uaddOverflow 320#64) (h0 : Fits m p 512)
    (h1 : Fits m (p.add 64#64) 512) (h2 : Fits m (p.add 128#64) 512)
    (h3 : Fits m (p.add 192#64) 512) (h4 : Fits m (p.add 256#64) 512) : Fits m p 2560 :=
  have o (a : BitVec 64) (ha : a.toNat ≤ 320) : ¬p.offset.uaddOverflow a :=
    BitVec.not_uaddOverflow_of_le hov (by simpa using ha)
  Fits.append (v := 2048) (o 256#64 (by decide)) (by decide) (by decide)
    (Fits.append (v := 1536) (o 192#64 (by decide)) (by decide) (by decide)
      (Fits.append (v := 1024) (o 128#64 (by decide)) (by decide) (by decide)
        (Fits.append (v := 512) (o 64#64 (by decide)) (by decide) (by decide) h0 h1) h2) h3) h4

/-- A point's 1280 bytes known from its four field elements'. -/
theorem fits_point_of_fe (hov : ¬P.offset.uaddOverflow 1280#64) (hx : Fits m P 2560)
    (hy : Fits m (P.add 320#64) 2560) (hz : Fits m (P.add 640#64) 2560)
    (ht : Fits m (P.add 960#64) 2560) : Fits m P 10240 :=
  have o (a : BitVec 64) (ha : a.toNat ≤ 1280) : ¬P.offset.uaddOverflow a :=
    BitVec.not_uaddOverflow_of_le hov (by simpa using ha)
  Fits.append (v := 7680) (o 960#64 (by decide)) (by decide) (by decide)
    (Fits.append (v := 5120) (o 640#64 (by decide)) (by decide) (by decide)
      (Fits.append (v := 2560) (o 320#64 (by decide)) (by decide) (by decide) hx hy) hz) ht

/-- A lane vector at offset `b` inside 256 zero bytes stored at offset `a` of a point: zero. -/
theorem rv_storeAt_zero_pt (hP : ¬P.offset.uaddOverflow 1280#64) {a b : BitVec 64}
    (h : Room m (P.add a) 2048) (hab : a.toNat ≤ b.toNat) (hb : b.toNat + 64 ≤ a.toNat + 256)
    (ha : a.toNat + 256 ≤ 1280) :
    (m.storeAt (P.add a) 0#2048).readVec (P.add b) = wwl_zero := by
  have he : P.add b = (P.add a).add (b - a) := by
    rw [Pointer.add_add]
    congr 1
    bv_omega
  have hov : ¬(P.add a).offset.uaddOverflow 256#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, not_le] at hP ⊢
    simp only [Pointer.add, BitVec.toNat_add]
    have : (P.offset.toNat + a.toNat) % 2 ^ 64 = P.offset.toNat + a.toNat := Nat.mod_eq_of_lt (by
      simp at hP; omega)
    simp at hP ⊢
    omega
  rw [he]
  exact rv_storeAt_zero h hov (by simp; omega)

/-- `pointMem`'s `y`. -/
theorem pointMem_readFe_y (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    (pointMem m P Y).readFe (P.add 320#64) = Y := by
  simp only [pointMem, MemoryState.readFe, Pointer.add_add, BitVec.reduceAdd]
  simp (disch := pt_side) only [rv_storeAt_disj, rv_storeAt_self]

/-- `pointMem`'s `z`: one. -/
theorem pointMem_readFe_z (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    (pointMem m P Y).readFe (P.add 640#64) = Fe.one := by
  simp only [pointMem, MemoryState.readFe, Pointer.add_add, BitVec.reduceAdd]
  simp (disch := pt_side) only [rv_storeAt_disj, rv_storeAt_self]
  simp (disch := pt_side) only [rv_storeAt_zero_pt]
  rfl

/-- `pointMem`'s `y` is known. -/
theorem pointMem_fits_y (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    Fits (pointMem m P Y) (P.add 320#64) 2560 := by
  refine fits_fe_of_limbs (ovf_pt hP 320#64 320#64 (by simp)) ?_ ?_ ?_ ?_ ?_ <;>
    simp only [pointMem, Pointer.add_add, BitVec.reduceAdd]
  · iterate 4 apply Fits.storeAt
    exact Fits.storeAt_self (by pt_side)
  · iterate 3 apply Fits.storeAt
    exact Fits.storeAt_self (by pt_side)
  · iterate 2 apply Fits.storeAt
    exact Fits.storeAt_self (by pt_side)
  · apply Fits.storeAt
    exact Fits.storeAt_self (by pt_side)
  · exact Fits.storeAt_self (by pt_side)

/-- `pointMem`'s `z` is known. -/
theorem pointMem_fits_z1 (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    Fits (pointMem m P Y) (P.add 640#64) 2560 := by
  have hz := pointMem_fits_z hP hR Y
  have hov : ¬(P.add 704#64).offset.uaddOverflow 256#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, not_le] at hP ⊢
    simp only [Pointer.add, BitVec.toNat_add]
    simp at hP ⊢
    omega
  have hl (o : BitVec 64) (ho : o.toNat * 8 + 512 ≤ 2048) : Fits (pointMem m P Y)
      ((P.add 704#64).add o) 512 :=
    hz.add_of_le (BitVec.not_uaddOverflow_of_le hov (by simp; omega)) ho
  refine fits_fe_of_limbs (ovf_pt hP 640#64 320#64 (by simp)) ?_ ?_ ?_ ?_ ?_
  · simp only [pointMem]
    iterate 7 apply Fits.storeAt
    have hr : Room (((m.storeAt P 0#2560).storeAt (P.add 960#64)
        (BitVec.packLanes (Vector.replicate 8 0#64)))) (P.add 640#64) 512 :=
      (room_add_le hP hR (by simp)).storeAt.storeAt
    exact Fits.storeAt_self hr
  · simpa only [Pointer.add_add, BitVec.reduceAdd] using hl 0#64 (by decide)
  · simpa only [Pointer.add_add, BitVec.reduceAdd] using hl 64#64 (by decide)
  · simpa only [Pointer.add_add, BitVec.reduceAdd] using hl 128#64 (by decide)
  · simpa only [Pointer.add_add, BitVec.reduceAdd] using hl 192#64 (by decide)

/-- `xyMem`'s `x`. -/
theorem xyMem_readFe_x (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (x y : Fe) :
    (xyMem m P x y).readFe P = x := by
  simp only [xyMem, MemoryState.readFe]
  simp (disch := pt_side) only [rv_storeAt_disj, rv_storeAt_self]

/-- `xyMem`'s `y`. -/
theorem xyMem_readFe_y (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (x y : Fe) :
    (xyMem m P x y).readFe (P.add 320#64) = y := by
  simp only [xyMem, MemoryState.readFe, Pointer.add_add, BitVec.reduceAdd]
  simp (disch := pt_side) only [rv_storeAt_disj, rv_storeAt_self]

/-- `xyMem` past its 640 bytes: `z`. -/
theorem xyMem_readFe_z (hP : ¬P.offset.uaddOverflow 1280#64) (x y : Fe) :
    (xyMem m P x y).readFe (P.add 640#64) = m.readFe (P.add 640#64) := by
  simp only [xyMem, MemoryState.readFe, Pointer.add_add, BitVec.reduceAdd]
  simp (disch := pt_side) only [rv_storeAt_disj]

end Point

section Peel

variable {m : MemoryState} {p q : Pointer}

/-- An object at offset 0: offsets up to 1280 do not wrap. -/
theorem ovf0 (hp : p.offset = 0) {c : BitVec 64} (hc : c.toNat ≤ 1280) :
    ¬p.offset.uaddOverflow c := by
  rw [hp]; simp [BitVec.uaddOverflow]; omega

/-- A field element `b ≥ 320` bytes past a store of one at a slot's start. -/
theorem rf_base_apart {x : Fe} {s : GlobalState} {k : Nat} {b : BitVec 64}
    (hb : b.toNat + 320 ≤ 1280) (h : 320 ≤ b.toNat) :
    (m.storeFe (s.slot k) x).readFe ((s.slot k).add b) = m.readFe ((s.slot k).add b) :=
  MemoryState.readFe_storeFe_base_apart (c := 1280#64) (ovf0 rfl (by decide)) (by simpa using hb) h

/-- A field element at a slot's start, before a store `a ≥ 320` bytes on. -/
theorem rf_apart_base {x : Fe} {s : GlobalState} {k : Nat} {a : BitVec 64}
    (ha : a.toNat + 320 ≤ 1280) (h : 320 ≤ a.toNat) :
    (m.storeFe ((s.slot k).add a) x).readFe (s.slot k) = m.readFe (s.slot k) :=
  MemoryState.readFe_storeFe_apart_base (c := 1280#64) (ovf0 rfl (by decide)) (by simpa using ha) h

/-- Two field elements inside a slot, apart. -/
theorem rf_apart {x : Fe} {s : GlobalState} {k : Nat} {a b : BitVec 64}
    (ha : a.toNat + 320 ≤ 1280) (hb : b.toNat + 320 ≤ 1280)
    (hab : a.toNat + 320 ≤ b.toNat ∨ b.toNat + 320 ≤ a.toNat) :
    (m.storeFe ((s.slot k).add a) x).readFe ((s.slot k).add b) =
      m.readFe ((s.slot k).add b) :=
  MemoryState.readFe_storeFe_apart (c := 1280#64) (ovf0 rfl (by decide)) (by simpa using ha)
    (by simpa using hb) hab

/-- `pointMem` in another block. -/
theorem pointMem_readFe_of_id_ne {P : Pointer} {Y : Fe} (h : P.id ≠ q.id) :
    (pointMem m P Y).readFe q = m.readFe q := by
  simp only [pointMem, readFe_storeAt_of_id_ne _ h, readFe_storeAt_add_of_id_ne _ _ h]

/-- `pointMem` in another block. -/
theorem pointMem_readAt_of_id_ne {P : Pointer} {Y : Fe} {w : Nat} (h : P.id ≠ q.id) :
    (pointMem m P Y).readAt q w = m.readAt q w := by
  have h' (o : BitVec 64) : (P.add o).id ≠ q.id := by simpa [Pointer.add] using h
  simp only [pointMem, ra_storeAt h, ra_storeAt (h' _)]

/-- `xyMem` in another block. -/
theorem xyMem_readFe_of_id_ne {P : Pointer} {x y : Fe} (h : P.id ≠ q.id) :
    (xyMem m P x y).readFe q = m.readFe q := by
  simp only [xyMem, readFe_storeAt_of_id_ne _ h, readFe_storeAt_add_of_id_ne _ _ h]

/-- `xyMem` in another block. -/
theorem xyMem_readAt_of_id_ne {P : Pointer} {x y : Fe} {w : Nat} (h : P.id ≠ q.id) :
    (xyMem m P x y).readAt q w = m.readAt q w := by
  have h' (o : BitVec 64) : (P.add o).id ≠ q.id := by simpa [Pointer.add] using h
  simp only [xyMem, ra_storeAt h, ra_storeAt (h' _)]

/-- Known bits stay known past `pointMem`. -/
theorem Fits.pointMem {P : Pointer} {Y : Fe} {w : Nat} (h : Fits m q w) :
    Fits (Decode.pointMem m P Y) q w := by
  simp only [Decode.pointMem]
  iterate 10 apply Fits.storeAt
  exact h

/-- Known bits stay known past `xyMem`. -/
theorem Fits.xyMem {P : Pointer} {x y : Fe} {w : Nat} (h : Fits m q w) :
    Fits (Decode.xyMem m P x y) q w := by
  simp only [Decode.xyMem]
  iterate 10 apply Fits.storeAt
  exact h

end Peel

/-- A hand-over's `Base` past writes into `fd_ed25519_lane_decode2`'s blocks. -/
theorem Call.Base.of_frameOn_d {c : Call} {S₀ S : GlobalState} {M : MemoryState}
    (h : c.Base S₀ M) (hf : S₀.mem.FrameOn S.mem (DKeep0 c)) (hwf : S.WF) : c.Base S M where
  wf := hwf
  globals := hf.sameOn.globals h.globals
  frame := by
    obtain ⟨b, hb, -⟩ := hf.inBounds (h.slots 32 (by decide))
    have := hwf.bound (c.s.slot 32).id (by
      rw [Std.ExtHashMap.mem_iff_isSome_getElem?, ← MemoryState.getElem?_eq, hb]; rfl)
    simp only [GlobalState.slot_id_id] at this
    omega
  slots k hk := hf.inBounds (h.slots k hk)
  writable k hk := hf.writable (h.writable k hk)
  mem := by
    rw [← h.mem]
    exact eraseFrom_eq_of_sameOn (hf.sameOn.mono fun _ hb => Or.inl hb)
  tbl_lt := h.tbl_lt
  idp_lt := h.idp_lt
  tbl_fits := hf.sameOn.fits (Or.inl h.tbl_lt) h.tbl_fits
  tbl_read := by rw [hf.sameOn.readAt (Or.inl h.tbl_lt)]; exact h.tbl_read
  idp_fits := hf.sameOn.fits (Or.inl h.idp_lt) h.idp_fits
  idp_read := by rw [hf.sameOn.readAt (Or.inl h.idp_lt)]; exact h.idp_read

/-- `k` and `s` past writes into `fd_ed25519_lane_decode2`'s blocks. -/
theorem Call.KS.of_frameOn_d {c : Call} {S₀ S : GlobalState} {K Sv : BitVec 2048}
    (h : c.KS S₀ K Sv) (hf : S₀.mem.FrameOn S.mem (DKeep0 c)) : c.KS S K Sv :=
  ⟨hf.sameOn.fits (Or.inr (Or.inl rfl)) h.k_fits,
    (hf.sameOn.readAt (Or.inr (Or.inl rfl))).trans h.k_read,
    hf.sameOn.fits (Or.inr (Or.inr rfl)) h.s_fits,
    (hf.sameOn.readAt (Or.inr (Or.inr rfl))).trans h.s_read⟩

/-- `rd_side`: the side conditions of `rd`: slots apart, offsets. -/
macro "rd_side" : tactic =>
  `(tactic| first | slot_ne | simp)

/-- `rd`: a read through stores into slots, store by store. -/
macro "rd" : tactic =>
  `(tactic|
    repeat
      first
      | (rw [MemoryState.readFe_storeFe_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [readFe_storeAt_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [readFe_storeAt_add_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [pointMem_readFe_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [xyMem_readFe_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [rf_base_apart]; rotate_left; (· simp); (· simp))
      | (rw [rf_apart_base]; rotate_left; (· simp); (· simp))
      | (rw [rf_apart]; rotate_left; (· simp); (· simp); (· simp))
      | (rw [MemoryState.readAt_storeFe_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [ra_storeAt]; rotate_left; (· slot_ne))
      | (rw [pointMem_readAt_of_id_ne]; rotate_left; (· slot_ne))
      | (rw [xyMem_readAt_of_id_ne]; rotate_left; (· slot_ne)))

/-- `rd_room`: room at a slot through stores, from the facts. -/
macro "rd_room" : tactic =>
  `(tactic|
    repeat (first | apply Room.storeAt | apply Room.storeFe | apply Room.storeVec | mem_fact))

end

end MLIR.Firedancer.Lane.VerifyX8.Decode

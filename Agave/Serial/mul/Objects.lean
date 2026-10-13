module

public import Agave.Common.Decompress
public import Agave.Serial.mul.Spec
public import MLIR.Run.Tactic
import Firedancer.Common.Writable
import Std.Data.ExtHashMap.Lemmas

/-! `vartime_double_base::mul`'s objects in memory: facts past a partly defined global's block, the
main loop's slots, the tables' entries and the NAFs' digits read from their blocks. -/

namespace MLIR.Agave.Serial.mul

/-! ### Past a partly defined global's block -/

section StoreDef

variable {m : MemoryState} {p q : Pointer} {x d : BitVec v}

@[mlir_transport]
public theorem limbsRoom_storeDef (h : m.LimbsRoom q) : (m.storeDef p x d).LimbsRoom q :=
  ⟨h.1, h.2.1.storeDef, h.2.2.1.storeDef, h.2.2.2.1.storeDef, h.2.2.2.2.1.storeDef,
    h.2.2.2.2.2.storeDef⟩

@[mlir_transport]
public theorem pointRoom_storeDef (h : m.PointRoom q) : (m.storeDef p x d).PointRoom q :=
  ⟨h.1, limbsRoom_storeDef h.2.1, limbsRoom_storeDef h.2.2.1, limbsRoom_storeDef h.2.2.2.1,
    limbsRoom_storeDef h.2.2.2.2⟩

@[mlir_transport]
public theorem limbsFit_storeDef (h : m.LimbsFit q) (hne : p.id ≠ q.id) :
    (m.storeDef p x d).LimbsFit q :=
  ⟨h.1, h.2.1.storeDef_of_disjoint (Range.disjoint_of_id_ne hne),
    h.2.2.1.storeDef_of_disjoint (Range.disjoint_of_id_ne hne),
    h.2.2.2.1.storeDef_of_disjoint (Range.disjoint_of_id_ne hne),
    h.2.2.2.2.1.storeDef_of_disjoint (Range.disjoint_of_id_ne hne),
    h.2.2.2.2.2.storeDef_of_disjoint (Range.disjoint_of_id_ne hne)⟩

@[mlir_transport]
public theorem pointFit_storeDef (h : m.PointFit q) (hne : p.id ≠ q.id) :
    (m.storeDef p x d).PointFit q :=
  ⟨h.1, limbsFit_storeDef h.2.1 hne, limbsFit_storeDef h.2.2.1 hne, limbsFit_storeDef h.2.2.2.1 hne,
    limbsFit_storeDef h.2.2.2.2 hne⟩

@[mlir_read]
public theorem readLimbs_storeDef_of_id_ne (h : p.id ≠ q.id) :
    (m.storeDef p x d).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  funext i
  fin_cases i
  · exact MemoryState.readAt_storeDef_disjoint (Range.disjoint_of_id_ne h) _ _
  all_goals exact MemoryState.readAt_storeDef_disjoint (Range.disjoint_of_id_ne (h' _)) _ _

@[mlir_read]
public theorem readEdwards_storeDef_of_id_ne (h : p.id ≠ q.id) :
    (m.storeDef p x d).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeDef_of_id_ne h,
    readLimbs_storeDef_of_id_ne (h' _)]

end StoreDef

/-- Erasing from `k`, then from `n ≤ k`: erasing from `n`. -/
public theorem eraseFrom_eraseFrom_of_le {m : MemoryState} {n k : Nat} (h : n ≤ k) :
    (m.eraseFrom k).eraseFrom n = m.eraseFrom n := by
  simp only [MemoryState.eraseFrom]
  congr 1
  apply Std.ExtHashMap.ext_getElem?
  intro i
  simp only [Std.ExtHashMap.getElem?_filter']
  by_cases hi : i.id < n
  · simp [hi, show i.id < k by omega]
  · cases m.mem[i]? <;> simp [hi]

/-! ### The main loop's slots -/

/-- The main loop's temporaries from `B`'s counter on are in bounds: field elements at slots
`0 … 18`, points at `19 … 23`; they and `r` (slot `24`) are writable. -/
@[expose]
public def SlotsIn (m : MemoryState) (B : GlobalState) : Prop :=
  (∀ k, k ≤ 23 → InBounds m (B.slot k) (if k ≤ 18 then 320 else 1280)) ∧
    ∀ k, k ≤ 24 → Writable m (B.slot k)

section Slots

variable {m : MemoryState} {B : GlobalState}

/-- A field element's slot. -/
public theorem SlotsIn.fe (h : SlotsIn m B) (k : Nat) (h18 : k ≤ 18 := by decide) :
    InBounds m (B.slot k) 320 := by
  simpa [h18] using h.1 k (by omega)

/-- A point's slot. -/
public theorem SlotsIn.pt (h : SlotsIn m B) (k : Nat) (h19 : 19 ≤ k := by decide)
    (h23 : k ≤ 23 := by decide) : InBounds m (B.slot k) 1280 := by
  simpa [show ¬k ≤ 18 by omega] using h.1 k h23

/-- A writable slot. -/
public theorem SlotsIn.writable (h : SlotsIn m B) (k : Nat) (h24 : k ≤ 24 := by decide) :
    Writable m (B.slot k) :=
  h.2 k h24

/-- A point's stores keep every block's writability. -/
theorem _root_.MLIR.Writable.storeCompleted (h : Writable m q) :
    Writable (m.storeCompleted p P) q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem _root_.MLIR.Writable.storeEdwards (h : Writable m q) : Writable (m.storeEdwards p P) q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem _root_.MLIR.Writable.storeProjective (h : Writable m q) :
    Writable (m.storeProjective p P) q :=
  h.storeLimbs.storeLimbs.storeLimbs

@[mlir_transport]
public theorem SlotsIn.lifetimeStart (h : SlotsIn m B) : SlotsIn (m.lifetimeStart q) B :=
  ⟨fun k hk => (h.1 k hk).lifetimeStart, fun k hk => (h.2 k hk).lifetimeStart⟩

@[mlir_transport]
public theorem SlotsIn.lifetimeEnd (h : SlotsIn m B) : SlotsIn (m.lifetimeEnd q) B :=
  ⟨fun k hk => (h.1 k hk).lifetimeEnd, fun k hk => (h.2 k hk).lifetimeEnd⟩

@[mlir_transport]
public theorem SlotsIn.storeLimbs (h : SlotsIn m B) : SlotsIn (m.storeLimbs q l) B :=
  ⟨fun k hk => (h.1 k hk).storeLimbs, fun k hk => (h.2 k hk).storeLimbs⟩

@[mlir_transport]
public theorem SlotsIn.storeCompleted (h : SlotsIn m B) : SlotsIn (m.storeCompleted q P) B :=
  ⟨fun k hk => (h.1 k hk).storeCompleted, fun k hk => (h.2 k hk).storeCompleted⟩

@[mlir_transport]
public theorem SlotsIn.storeEdwards (h : SlotsIn m B) : SlotsIn (m.storeEdwards q P) B :=
  ⟨fun k hk => (h.1 k hk).storeEdwards, fun k hk => (h.2 k hk).storeEdwards⟩

@[mlir_transport]
public theorem SlotsIn.storeProjective (h : SlotsIn m B) : SlotsIn (m.storeProjective q P) B :=
  ⟨fun k hk => (h.1 k hk).storeProjective, fun k hk => (h.2 k hk).storeProjective⟩

end Slots

/-! ### Objects inside known blocks -/

/-- Two byte offsets from `p`, as one. -/
theorem add_ofNat_add {p : Pointer} {a c : Nat} :
    (p.add (BitVec.ofNat 64 a)).add (BitVec.ofNat 64 c) = p.add (BitVec.ofNat 64 (a + c)) := by
  rw [Pointer.add_add, BitVec.ofNat_add]

/-- No wrap `o` bytes into a block from its start. -/
theorem noOverflow_at {p : Pointer} (ho : p.offset = 0) {o : Nat} :
    ¬p.offset.uaddOverflow (BitVec.ofNat 64 o) := by
  simp [BitVec.uaddOverflow, ho]
  omega

/-- Limbs `o` bytes into a block that fits from its start. -/
public theorem limbsFit_at {m : MemoryState} {p : Pointer} {o : Nat} (h : Fits m p v)
    (ho : p.offset = 0) (hv : 8 * (o + 40) ≤ v) (ho' : o + 40 ≤ 2 ^ 64) :
    m.LimbsFit (p.add (BitVec.ofNat 64 o)) := by
  have hf (c : Nat) (hc : c ≤ 32) :
    Fits m ((p.add (BitVec.ofNat 64 o)).add (BitVec.ofNat 64 c)) 64 := by
    rw [add_ofNat_add]
    exact
      Fits.add_of_le (noOverflow_at ho)
        (by
          simp; omega)
        h
  have h0 := hf 0 (by omega)
  rw [Pointer.add_zero'] at h0
  exact
    ⟨by
      simp [Pointer.add, ho]; omega, h0, hf 8 (by omega), hf 16 (by omega), hf 24 (by omega),
      hf 32 (by omega)⟩

/-- The limbs at byte `o` of a known read from a block's start: its bits. -/
public theorem readLimbs_at {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : InBounds m p v)
    (ho : p.offset = 0) (h : m.readAt p v = x) (ho' : o + 40 ≤ 2 ^ 64) (hv : 8 * o + 320 ≤ v) :
    m.readLimbs (p.add (BitVec.ofNat 64 o)) = fun i => x.extractLsb' (8 * o + 64 * i.val) 64 := by
  have hr (c : Nat) (hc : c ≤ 32) :
    m.readAt (p.add (BitVec.ofNat 64 (o + c))) 64 = x.extractLsb' (8 * o + 8 * c) 64 := by
    rw [MemoryState.readAt_add_of_readAt hf (noOverflow_at ho)
        (by
          simp; omega)
        h]
    congr 1
    simp
    omega
  have h0 := hr 0 (by omega)
  simp only [Nat.add_zero, Nat.mul_zero] at h0
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, add_ofNat_add]
  · exact h0
  · exact hr 8 (by omega)
  · exact hr 16 (by omega)
  · exact hr 24 (by omega)
  · exact hr 32 (by omega)

/-- The point `o` bytes into a block that fits from its start. -/
public theorem pointFit_at {m : MemoryState} {p : Pointer} {o : Nat} (h : Fits m p v)
    (ho : p.offset = 0) (hv : 8 * (o + 160) ≤ v) (ho' : o + 160 ≤ 2 ^ 64) :
    m.PointFit (p.add (BitVec.ofNat 64 o)) := by
  refine
      ⟨by
        simp [Pointer.add, ho]; omega, limbsFit_at h ho (by omega) (by omega), ?_, ?_, ?_⟩ <;>
    · rw [add_ofNat_add]
      exact limbsFit_at h ho (by omega) (by omega)

/-- Room for limbs from room for their 320 bits. -/
theorem limbsRoom_of_room {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsRoom p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 32) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) h

/-- No wrap at a coordinate's offset. -/
theorem coord_noOverflow {p : Pointer} (ho : p.offset.toNat + 160 ≤ 2 ^ 64) {k : BitVec 64}
    (hk : k.toNat < 160) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega

/-- Room for a point from room for its 1280 bits. -/
theorem pointRoom_of_room {m : MemoryState} {p : Pointer} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.PointRoom p :=
  ⟨ho, limbsRoom_of_room (h.mono (by decide)) (by omega),
    limbsRoom_of_room (Room.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 40) (by omega)),
    limbsRoom_of_room (Room.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 80) (by omega)),
    limbsRoom_of_room (Room.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 120) (by omega))⟩

/-- The `ProjectiveNielsPoint` at `p`, from the 1280 bits there. -/
theorem readNiels_of_readAt {m : MemoryState} {p : Pointer} {P : ProjectiveNielsPoint}
    (hf : Fits m p 1280) (ho : p.offset.toNat + 160 ≤ 2 ^ 64) (h : m.readAt p 1280 = nielsBits P) :
    m.readNiels p = P := by
  -- in a copy of `m` with `p`'s block writable, which reads the same
  have hr (q : Pointer) (w : Nat) : (m.makeWritable p.id).readAt q w = m.readAt q w :=
    MemoryState.readAt_makeWritable
  have hl (q : Pointer) : (m.makeWritable p.id).readLimbs q = m.readLimbs q := by
    funext i; fin_cases i <;> simp only [MemoryState.readLimbs, hr]
  have hn : (m.makeWritable p.id).readNiels p = m.readNiels p := by
    simp only [MemoryState.readNiels, hl]
  have hfw : Fits (m.makeWritable p.id) p 1280 := hf.makeWritable
  have hs :
      (m.makeWritable p.id).storeAt p (nielsBits P) = (m.makeWritable p.id).storeNiels p P :=
    storeAt_edwardsBits (P := ⟨P.Y_plus_X, P.Y_minus_X, P.Z, P.T2d⟩) ho
  rw [← hn, ← MemoryState.storeAt_readAt_self hfw, hr, h, hs]
  exact
    MemoryState.readNiels_storeNiels_self (pointRoom_of_room (Room.makeWritable_self hf.live) ho)

/-! ### `table_A` -/

/-- The `ProjectiveNielsPoint` `j` of a `NafLookupTable5`'s bits: `nielsBits (T j)`. -/
theorem extractLsb'_nafBits (T : Fin 8 → ProjectiveNielsPoint) (j : Fin 8) :
    (nafBits T).extractLsb' (1280 * j.val) 1280 = nielsBits (T j) := by
  fin_cases j <;>
    simp (disch := omega) only [nafBits, BitVec.extractLsb'_append_eq_of_add_le,
      BitVec.extractLsb'_append_eq_of_le, Fin.isValue, Nat.mul_zero, Nat.sub_self,
      BitVec.extractLsb'_eq_self] <;>
    rfl

/-- Entry `k` of the `NafLookupTable5` at a block's start: it fits, and it is `T k`. -/
public theorem tableA_entry {m : MemoryState} {p : Pointer} {T : Fin 8 → ProjectiveNielsPoint}
    (hf : Fits m p 10240) (ho : p.offset = 0) (hr : m.readAt p 10240 = nafBits T) (k : Nat)
    (hk : k < 8) :
    m.PointFit (p.add (BitVec.ofNat 64 (160 * k))) ∧
      m.readNiels (p.add (BitVec.ofNat 64 (160 * k))) = T ⟨k, hk⟩ := by
  have hf' : Fits m (p.add (BitVec.ofNat 64 (160 * k))) 1280 :=
    Fits.add_of_le (noOverflow_at ho)
      (by
        rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)
      hf
  refine ⟨pointFit_at hf ho (by omega) (by omega), readNiels_of_readAt hf' ?_ ?_⟩
  · simp [Pointer.add, ho, Nat.mod_eq_of_lt (show 160 * k < 18446744073709551616 by omega)]
    omega
  · rw [MemoryState.readAt_add_of_readAt hf.inBounds (noOverflow_at ho)
        (by
          rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)
        hr]
    rw [← extractLsb'_nafBits T ⟨k, hk⟩, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    congr 1
    dsimp only
    omega

/-- `tableA_entry`'s field elements, at the pointers the steps spell: each fits and is `T k`'s. -/
public theorem tableA_coords {m : MemoryState} {p : Pointer} {T : Fin 8 → ProjectiveNielsPoint}
    (hf : Fits m p 10240) (ho : p.offset = 0) (hr : m.readAt p 10240 = nafBits T) (k : Nat)
    (hk : k < 8) :
    m.LimbsFit (p.add (BitVec.ofNat 64 (160 * k))) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (160 * k))) = (T ⟨k, hk⟩).Y_plus_X ∧
      m.LimbsFit (p.add (BitVec.ofNat 64 (160 * k) + 40#64)) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (160 * k) + 40#64)) = (T ⟨k, hk⟩).Y_minus_X ∧
      m.LimbsFit (p.add (BitVec.ofNat 64 (160 * k) + 80#64)) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (160 * k) + 80#64)) = (T ⟨k, hk⟩).Z ∧
      m.LimbsFit (p.add (BitVec.ofNat 64 (160 * k) + 120#64)) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (160 * k) + 120#64)) = (T ⟨k, hk⟩).T2d := by
  obtain ⟨hpf, hpr⟩ := tableA_entry hf ho hr k hk
  have h1 := hpf.2.2.1
  have h2 := hpf.2.2.2.1
  have h3 := hpf.2.2.2.2
  have r1 := congrArg ProjectiveNielsPoint.Y_minus_X hpr
  have r2 := congrArg ProjectiveNielsPoint.Z hpr
  have r3 := congrArg ProjectiveNielsPoint.T2d hpr
  simp only [MemoryState.readNiels, Pointer.add_add] at h1 h2 h3 r1 r2 r3
  exact ⟨hpf.2.1, congrArg ProjectiveNielsPoint.Y_plus_X hpr, h1, r1, h2, r2, h3, r3⟩

/-- `NafLookupTable5::from`'s `call_eq`, its store spelled as the store of its bits, past which the
facts carry. -/
public theorem tableA_call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.globals)
    (hout : Room s.mem out 10240) (ha : s.mem.PointFit a) :
    NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.call
        (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.args (.value out) (.value a))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 64⟩
            mem :=
              s.mem.storeAt out
                (nafBits
                  (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.spec
                    (s.mem.readEdwards a))) }) :=
  NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.call_eq out a s hwf hg hout ha

/-! ### `table_B` -/

/-- Entry `j` of 64 `AffineNielsPoint`s at a block's start, of known bits `x`, at the pointers the
steps spell: its three field elements fit, and they are `affineAt x (960 j)`'s. -/
public theorem tableB_coords {m : MemoryState} {p : Pointer} {x : BitVec 61440}
    (hf : Fits m p 61440) (ho : p.offset = 0) (hr : m.readAt p 61440 = x) (j : Nat) (hj : j < 64) :
    m.LimbsFit (p.add (BitVec.ofNat 64 (120 * j))) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (120 * j))) = (affineAt x (960 * j)).y_plus_x ∧
      m.LimbsFit (p.add (BitVec.ofNat 64 (120 * j) + 40#64)) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (120 * j) + 40#64)) = (affineAt x (960 * j)).y_minus_x ∧
      m.LimbsFit (p.add (BitVec.ofNat 64 (120 * j) + 80#64)) ∧
      m.readLimbs (p.add (BitVec.ofNat 64 (120 * j) + 80#64)) = (affineAt x (960 * j)).xy2d := by
  have e40 : BitVec.ofNat 64 (120 * j) + 40#64 = BitVec.ofNat 64 (120 * j + 40) :=
    (BitVec.ofNat_add _ _).symm
  have e80 : BitVec.ofNat 64 (120 * j) + 80#64 = BitVec.ofNat 64 (120 * j + 80) :=
    (BitVec.ofNat_add _ _).symm
  rw [e40, e80]
  refine
      ⟨limbsFit_at hf ho (by omega) (by omega), ?_, limbsFit_at hf ho (by omega) (by omega), ?_,
        limbsFit_at hf ho (by omega) (by omega), ?_⟩ <;>
    · rw [readLimbs_at hf.inBounds ho hr (by omega) (by omega)]
      funext i
      simp only [affineAt]
      congr 1
      omega

end MLIR.Agave.Serial.mul

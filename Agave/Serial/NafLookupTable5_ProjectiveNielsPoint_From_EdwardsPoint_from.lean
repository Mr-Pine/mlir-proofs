module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Agave.Common.Decompress
public import Agave.Common.Tactics
public import Firedancer.Common.Tactics
public import Agave.Serial.ProjectivePoint_double
public import Agave.Serial.CompletedPoint_as_extended
public import Agave.Serial.EdwardsPoint_as_projective_niels
public import Agave.Serial.EdwardsPoint_Add_ProjectiveNielsPoint_add
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Serial.Mlir.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

namespace NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

/-- `A.double()`: `A` as projective, doubled, as extended. -/
def double (A : EdwardsPoint) : EdwardsPoint :=
  CompletedPoint_as_extended.spec (ProjectivePoint_double.spec ⟨A.X, A.Y, A.Z⟩)

/-- `Ai[i]`: `Ai[0] = A.as_projective_niels()`,
`Ai[i + 1] = (&A2 + &Ai[i]).as_extended().as_projective_niels()`, `A2 = A.double()`. -/
def Ai (A : EdwardsPoint) : Nat → ProjectiveNielsPoint
  | 0 => EdwardsPoint_as_projective_niels.spec A
  | i + 1 =>
    EdwardsPoint_as_projective_niels.spec
      (CompletedPoint_as_extended.spec
        (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec (double A) (Ai A i)))

/-- `NafLookupTable5::<ProjectiveNielsPoint>::from(A)`: `A, 3A, …, 15A`. -/
def spec (A : EdwardsPoint) : Fin 8 → ProjectiveNielsPoint := fun i => Ai A i

end NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

/-- A `ProjectiveNielsPoint`'s 1280 bits, `Y_plus_X` lowest. -/
def nielsBits (P : ProjectiveNielsPoint) : BitVec 1280 :=
  limbsBits P.T2d ++ (limbsBits P.Z ++ (limbsBits P.Y_minus_X ++ limbsBits P.Y_plus_X))

/-- A `NafLookupTable5<ProjectiveNielsPoint>`'s 10240 bits, point `0` lowest. -/
def nafBits (T : Fin 8 → ProjectiveNielsPoint) : BitVec 10240 :=
  nielsBits (T 7) ++
    (nielsBits (T 6) ++
      (nielsBits (T 5) ++
        (nielsBits (T 4) ++
          (nielsBits (T 3) ++ (nielsBits (T 2) ++ (nielsBits (T 1) ++ nielsBits (T 0)))))))

/-- Store a `NafLookupTable5<ProjectiveNielsPoint>` at `p`, point `i` at byte `160 i`. -/
def _root_.MLIR.MemoryState.storeNafTable (m : MemoryState) (p : Pointer)
    (T : Fin 8 → ProjectiveNielsPoint) : MemoryState :=
  m.storeAt p (nafBits T)

end

/-! ## Proof -/

namespace NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

section Proof

set_option hygiene false in
/-- `Ai[i + 1] = (&A2 + &Ai[i]).as_extended().as_projective_niels();`, `Ai[i]` at the entry with
fit `hf` and bits `hr`, its offset bound `ho`; the points named `c`, `x`, `n`. -/
local macro "naf_iter " ho:term:max hf:ident hr:ident c:ident x:ident n:ident : tactic =>
  `(tactic|
    ( iterate 3 step_pure
      have hv456_point := MemoryState.PointRoom.of_room hroom_v456 hv456_off
      have hv457_point := MemoryState.PointRoom.of_room hroom_v457 hv457_off
      have hv458_point := MemoryState.PointRoom.of_room hroom_v458 hv458_off
      have he := pointFit_of_fits $hf $ho
      have hne := readNiels_of_readAt $hf $ho $hr
      step_call using EdwardsPoint_Add_ProjectiveNielsPoint_add.call_eq consuming he hne
      name_point $c
      step_call using CompletedPoint_as_extended.call_eq consuming hread_v456 hread_v456_readLimbs
        hread_v456_40 hread_v456_80 hread_v456_120
      name_point $x
      step_call using EdwardsPoint_as_projective_niels.call_eq consuming hread_v457
        hread_v457_readLimbs hread_v457_40 hread_v457_80 hread_v457_120
      name_point $n
      have hb := (readAt_nielsBits hv458_point).trans (congrArg nielsBits hread_v458)
      have hf458 := fits_of_pointFit hv458_point
      step_memcpy consuming hb hf458 hread_v458 hread_v458_readLimbs hread_v458_40 hread_v458_80
        hread_v458_120
      clear hv456_point hv457_point hv458_point hroom_v456 hroom_v457 hroom_v458
      iterate 3 step_pure))

/-- Room for limbs from room for their 320 bits. -/
theorem limbsRoom_of_room {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsRoom p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 32) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) h

/-- Limbs that fit from their 320 bits that fit. -/
theorem limbsFit_of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 32) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) h

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

/-- A point that fits from its 1280 bits that fit. -/
theorem pointFit_of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.PointFit p :=
  ⟨ho, limbsFit_of_fits (h.mono (by decide)) (by omega),
    limbsFit_of_fits (Fits.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 40) (by omega)),
    limbsFit_of_fits (Fits.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 80) (by omega)),
    limbsFit_of_fits (Fits.add_of_le (coord_noOverflow ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 120) (by omega))⟩

/-- A point's 1280 bits fit where its coordinates do. -/
theorem fits_of_pointFit {m : MemoryState} {p : Pointer} (h : m.PointFit p) : Fits m p 1280 := by
  have a1 :=
    Fits.append (coord_noOverflow h.1 (by decide)) (by decide) rfl (fits_of_limbsFit h.limbsFit_X)
      (fits_of_limbsFit h.limbsFit_Y)
  have a2 :=
    Fits.append (coord_noOverflow h.1 (by decide)) (by decide) rfl a1
      (fits_of_limbsFit h.limbsFit_T)
  exact
    Fits.append (coord_noOverflow h.1 (by decide)) (by decide) rfl a2
      (fits_of_limbsFit h.limbsFit_Z)

/-- The 1280 bits of a `ProjectiveNielsPoint` that fits. -/
theorem readAt_nielsBits {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    m.readAt p 1280 = nielsBits (m.readNiels p) :=
  readAt_edwardsBits (P :=
    ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64),
      m.readLimbs (p.add 120#64)⟩)
    (fits_of_pointFit h).inBounds h.1 (readAt_eq_limbsBits h.limbsFit_X)
    (readAt_eq_limbsBits h.limbsFit_Y) (readAt_eq_limbsBits h.limbsFit_T)
    (readAt_eq_limbsBits h.limbsFit_Z)

/-- Storing a `ProjectiveNielsPoint`'s bits is storing the point. -/
theorem storeAt_nielsBits {m : MemoryState} {p : Pointer} {P : ProjectiveNielsPoint}
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.storeAt p (nielsBits P) = m.storeNiels p P :=
  storeAt_edwardsBits (P := ⟨P.Y_plus_X, P.Y_minus_X, P.Z, P.T2d⟩) ho

/-- Limbs at `p`, from the 320 bits there. -/
theorem readLimbs_of_readAt {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (hf : Fits m p 320) (ho : p.offset.toNat + 32 < 2 ^ 64) (h : m.readAt p 320 = limbsBits l) :
    m.readLimbs p = l := by
  -- in a copy of `m` with `p`'s block writable, which reads the same
  have hr (q : Pointer) (w : Nat) : (m.makeWritable p.id).readAt q w = m.readAt q w :=
    MemoryState.readAt_makeWritable
  have hl : (m.makeWritable p.id).readLimbs p = m.readLimbs p := by
    funext i; fin_cases i <;> simp only [MemoryState.readLimbs, hr]
  have hfw : Fits (m.makeWritable p.id) p 320 := hf.makeWritable
  rw [← hl, ← MemoryState.storeAt_readAt_self hfw, hr, h, ← storeLimbs_eq_storeAt ho]
  exact
    MemoryState.readLimbs_storeLimbs_self (limbsRoom_of_room (Room.makeWritable_self hf.live) ho)

/-- A table entry's offsets do not wrap. -/
theorem entry_off {t : Pointer} (ho : t.offset = 0) {k : BitVec 64} (hk : k.toNat ≤ 1120) :
    (t.add k).offset.toNat + 160 ≤ 2 ^ 64 := by
  simp [Pointer.add, ho]; omega

/-- No wrap at a table entry's offset. -/
theorem entry_noOverflow {t : Pointer} (ho : t.offset = 0) {k : BitVec 64} (hk : k.toNat ≤ 1120) :
    ¬t.offset.uaddOverflow k := by
  simp [BitVec.uaddOverflow, ho]; omega

/-- A table's 10240 bits fit where its eight entries' do. -/
theorem fits_table {m : MemoryState} {t : Pointer} (ho : t.offset = 0) (h0 : Fits m t 1280)
    (h1 : Fits m (t.add 160#64) 1280) (h2 : Fits m (t.add 320#64) 1280)
    (h3 : Fits m (t.add 480#64) 1280) (h4 : Fits m (t.add 640#64) 1280)
    (h5 : Fits m (t.add 800#64) 1280) (h6 : Fits m (t.add 960#64) 1280)
    (h7 : Fits m (t.add 1120#64) 1280) : Fits m t 10240 := by
  have a1 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a1 h2
  have a3 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a2 h3
  have a4 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a3 h4
  have a5 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a4 h5
  have a6 := Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a5 h6
  exact Fits.append (entry_noOverflow ho (by decide)) (by decide) rfl a6 h7

/-- A table's 10240 bits, read entry by entry. -/
theorem readAt_table {m : MemoryState} {t : Pointer} {T : Fin 8 → ProjectiveNielsPoint}
    (ho : t.offset = 0) (hb : InBounds m t 10240) (h0 : m.readAt t 1280 = nielsBits (T 0))
    (h1 : m.readAt (t.add 160#64) 1280 = nielsBits (T 1))
    (h2 : m.readAt (t.add 320#64) 1280 = nielsBits (T 2))
    (h3 : m.readAt (t.add 480#64) 1280 = nielsBits (T 3))
    (h4 : m.readAt (t.add 640#64) 1280 = nielsBits (T 4))
    (h5 : m.readAt (t.add 800#64) 1280 = nielsBits (T 5))
    (h6 : m.readAt (t.add 960#64) 1280 = nielsBits (T 6))
    (h7 : m.readAt (t.add 1120#64) 1280 = nielsBits (T 7)) : m.readAt t 10240 = nafBits T := by
  have a1 :=
    readAt_append (v := 1280) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) h0 h1
  have a2 :=
    readAt_append (v := 2560) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a1 h2
  have a3 :=
    readAt_append (v := 3840) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a2 h3
  have a4 :=
    readAt_append (v := 5120) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a3 h4
  have a5 :=
    readAt_append (v := 6400) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a4 h5
  have a6 :=
    readAt_append (v := 7680) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a5 h6
  exact readAt_append (v := 8960) (w := 1280) hb (entry_noOverflow ho (by decide)) (by decide) a6 h7

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
  rw [← hn, ← MemoryState.storeAt_readAt_self hfw, hr, h, storeAt_nielsBits ho]
  exact
    MemoryState.readNiels_storeNiels_self (pointRoom_of_room (Room.makeWritable_self hf.live) ho)

-- about 130 steps over a frame of 8 slots and 22 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `NafLookupTable5::<ProjectiveNielsPoint>::from(A)` stores `spec A` at `out`, the `sret` slot; `A`
is read before `out` is written, so they may alias. Its slots and its callees' temporaries are
freed again: the counter moves on by 64 blocks. -/
public theorem call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.globals)
    (hout : Room s.mem out 10240) (ha : s.mem.PointFit a) :
    NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.call (args (.value out) (.value a))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 64⟩
            mem := s.mem.storeNafTable out (spec (s.mem.readEdwards a)) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_alloca with v454
  step_alloca with v455
  step_alloca with v456
  step_alloca with v457
  step_alloca with v458
  step_alloca with v459
  step_alloca with v460
  step_alloca with tbl
  step_pure
  have hv460_point := MemoryState.PointRoom.of_room hroom_v460 hv460_off
  step_call using EdwardsPoint_as_projective_niels.call_eq
  name_point n0
  have hb_n0 : S.mem.readAt v460 1280 = nielsBits n0 := by
    rw [readAt_nielsBits hv460_point, hread_v460]
  have hfits_v460 := fits_of_pointFit hv460_point
  step_memcpy
  -- let mut Ai = [A.as_projective_niels(); 8];
  iterate 7
    step_pure
    step_memcpy
  clear hb_n0 hread_v460_readLimbs hread_v460_40 hread_v460_80 hread_v460_120 hread_v460 hfits_v460
  step_pure
  -- let A2 = A.double();
  iterate 3 step_pure
  have hv454_proj := MemoryState.ProjectiveRoom.of_room hroom_v454 hv454_off
  have hv455_point := MemoryState.PointRoom.of_room hroom_v455 hv455_off
  have hv459_point := MemoryState.PointRoom.of_room hroom_v459 hv459_off
  step_pure
  step_pure
  have h1 := room_of_limbsRoom hv454_proj.limbsRoom_Y
  have h2 := fits_of_limbsFit ha.limbsFit_Y
  have hY := readAt_eq_limbsBits ha.limbsFit_Y
  step_memcpy consuming h1 h2 hY
  step_pure
  step_pure
  have h1 := room_of_limbsRoom hv454_proj.limbsRoom_Z
  have h2 := fits_of_limbsFit ha.limbsFit_T
  have hZ := readAt_eq_limbsBits ha.limbsFit_T
  step_memcpy consuming h1 h2 hZ
  have h1 := room_of_limbsRoom hv454_proj.limbsRoom_X
  have h2 := fits_of_limbsFit ha.limbsFit_X
  have hX := readAt_eq_limbsBits ha.limbsFit_X
  step_memcpy consuming h1 h2 hX
  have ho454 : v454.offset.toNat + 120 ≤ 2 ^ 64 := by simp [hv454_off]
  have hv454_fit : S.mem.ProjectiveFit v454 :=
    ⟨ho454, limbsFit_of_fits hfits_v454 (by omega),
      limbsFit_of_fits hfits_v454_40 (Pointer.coord_offset_le (a := 40) ho454 (by omega)),
      limbsFit_of_fits hfits_v454_80 (Pointer.coord_offset_le (a := 80) ho454 (by omega))⟩
  have hread_v454_proj :
    S.mem.readProjective v454 =
      ⟨S₀.mem.readLimbs a, S₀.mem.readLimbs (a.add 40#64), S₀.mem.readLimbs (a.add 80#64)⟩ := by
    simp only [MemoryState.readProjective, readLimbs_of_readAt hfits_v454 (by omega) hread_v454,
      readLimbs_of_readAt hfits_v454_40 (Pointer.coord_offset_le (a := 40) ho454 (by omega))
          hread_v454_40,
      readLimbs_of_readAt hfits_v454_80 (Pointer.coord_offset_le (a := 80) ho454 (by omega))
          hread_v454_80]
  clear hread_v454 hread_v454_40 hread_v454_80 hfits_v454 hfits_v454_40 hfits_v454_80 hv454_proj
    ho454
  step_call using ProjectivePoint_double.call_eq consuming hread_v454_proj
  name_point r
  step_call using CompletedPoint_as_extended.call_eq
  name_point a2
  clear hread_v455 hread_v455_readLimbs hread_v455_40 hread_v455_80 hread_v455_120
    hread_v459_readLimbs hread_v459_40 hread_v459_80 hread_v459_120 ha hroom_v459 hv454_bounds
    hv455_bounds hv460_bounds
  step_pure
  step_pure
  -- for i in 0..7 { Ai[i + 1] = (&A2 + &Ai[i]).as_extended().as_projective_niels(); }
  naf_iter (by simp [htbl_off])hfits_tbl hread_tbl c1 x1 n1
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_160 hread_tbl_160 c2 x2 n2
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_320 hread_tbl_320 c3 x3 n3
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_480 hread_tbl_480 c4 x4 n4
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_640 hread_tbl_640 c5 x5 n5
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_800 hread_tbl_800 c6 x6 n6
  naf_iter (entry_off htbl_off (by decide))hfits_tbl_960 hread_tbl_960 c7 x7 n7
  -- NafLookupTable5(Ai)
  have hfits_tbl_all :=
    fits_table htbl_off hfits_tbl hfits_tbl_160 hfits_tbl_320 hfits_tbl_480 hfits_tbl_640
      hfits_tbl_800 hfits_tbl_960 hfits_tbl_1120
  have hread_tbl_all :=
    readAt_table (T := fun i => #v[n0, n1, n2, n3, n4, n5, n6, n7][i]) htbl_off
      hfits_tbl_all.inBounds hread_tbl hread_tbl_160 hread_tbl_320 hread_tbl_480 hread_tbl_640
      hread_tbl_800 hread_tbl_960 hread_tbl_1120
  clear hread_tbl hread_tbl_160 hread_tbl_320 hread_tbl_480 hread_tbl_640 hread_tbl_800
    hread_tbl_960 hread_tbl_1120 hfits_tbl hfits_tbl_160 hfits_tbl_320 hfits_tbl_480 hfits_tbl_640
    hfits_tbl_800 hfits_tbl_960 hfits_tbl_1120
  step_memcpy
  step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  simp only [MemoryState.storeNafTable, nafBits]
  rfl

end Proof

end NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

end MLIR.Agave.Serial

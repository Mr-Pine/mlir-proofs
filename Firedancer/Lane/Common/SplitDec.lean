module

public import Firedancer.Lane.Common.Split
public import Firedancer.Lane.Common.DecodeChain

/-! The split double-scalar multiplication's decode steps: their count as a spec, and the decode
state's memory past the point stores. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

set_option hygiene false in
/-- Stores to the state's fields, sorted by offset and the overwritten ones dropped. -/
local macro "dec_norm" h:term : tactic =>
  `(tactic|
    simp (disch := decide) only [MemoryState.storeDec, MemoryState.storeVec, storeAt_comm_dec $h,
      storeAt_comm_dec0 $h, storeOpt_comm_dec $h, storeOpt_comm_dec0 $h,
      MemoryState.storeAt_storeAt_self, storeOpt_storeAt_self])

@[expose] public section

/-! ## The steps -/

namespace double_scalar_mul_base_split

/-- A point operation's decode step, `fd_ed25519_point_decode_step( dec, 3 )`, unless the digit
`d` skips the operation. -/
def decAt (d : Int) (D : DecSt) : DecSt :=
  if d = 0 then D else D.step 3#64

/-- Segment `j`'s steps at bit `i`: one per digit with an add. -/
def segDec (w1 w2 : Vector Int 256) (i j : Nat) (D : DecSt) : DecSt :=
  decAt (digit w2 (32 * j + i)) (decAt (digit w1 (32 * j + i)) D)

/-- Segments `0 … j-1`'s steps at bit `i`. -/
def segDecs (w1 w2 : Vector Int 256) (i : Nat) : Nat → DecSt → DecSt
  | 0, D => D
  | j + 1, D => segDec w1 w2 i j (segDecs w1 w2 i j D)

/-- An iteration's steps at bit `i`: the doubling's, then the eight segments'. -/
def iterDec (w1 w2 : Vector Int 256) (i : Nat) (D : DecSt) : DecSt :=
  segDecs w1 w2 i 8 (D.step 3#64)

/-- The main loop's steps from bit `i` down to `0`. -/
def ladderDec (w1 w2 : Vector Int 256) : Nat → DecSt → DecSt
  | 0, D => iterDec w1 w2 0 D
  | i + 1, D => ladderDec w1 w2 i (iterDec w1 w2 (i + 1) D)

end double_scalar_mul_base_split

open double_scalar_mul_base_split in
/-- The decode state after `double_scalar_mul_base_split` on `D`: a step per point operation. -/
def double_scalar_mul_base_split.specDec (n1 n2 : BitVec 256) (D : DecSt) : DecSt :=
  let n1slide := Ref.fd_curve25519_scalar_wnaf.wnaf n1 3
  let n2slide := Ref.fd_curve25519_scalar_wnaf.wnaf n2 8
  match start n1slide n2slide 31 with
  | some i => ladderDec n1slide n2slide i D
  | none => D

namespace double_scalar_mul_base_split

/-- A property every `step 3` keeps holds past `decAt`. -/
theorem decAt_of {P : DecSt → Prop} (hP : ∀ D, P D → P (D.step 3#64)) (d : Int) {D : DecSt}
    (h : P D) : P (decAt d D) := by
  unfold decAt
  split
  · exact h
  · exact hP D h

/-- … and past `segDecs`. -/
theorem segDecs_of {P : DecSt → Prop} (hP : ∀ D, P D → P (D.step 3#64))
    (w1 w2 : Vector Int 256) (i : Nat) : ∀ j {D : DecSt}, P D → P (segDecs w1 w2 i j D)
  | 0, _, h => h
  | j + 1, _, h => decAt_of hP _ (decAt_of hP _ (segDecs_of hP w1 w2 i j h))

/-- … and past `ladderDec`. -/
theorem ladderDec_of {P : DecSt → Prop} (hP : ∀ D, P D → P (D.step 3#64))
    (w1 w2 : Vector Int 256) : ∀ i {D : DecSt}, P D → P (ladderDec w1 w2 i D)
  | 0, _, h => segDecs_of hP w1 w2 0 8 (hP _ h)
  | i + 1, _, h => ladderDec_of hP w1 w2 i (segDecs_of hP w1 w2 (i + 1) 8 (hP _ h))

end double_scalar_mul_base_split

open double_scalar_mul_base_split in
/-- The steps keep the chain: a later `fini` gives the decode. -/
theorem double_scalar_mul_base_split.specDec_reach {s : BitVec 256} {D : DecSt} (h : D.Reach s)
    (n1 n2 : BitVec 256) : (double_scalar_mul_base_split.specDec n1 n2 D).Reach s := by
  unfold double_scalar_mul_base_split.specDec
  dsimp only
  split
  · exact ladderDec_of (fun D h => h.step 3#64) _ _ _ h
  · exact h

/-! ## The state's named multipliers only get set -/

/-- `D'`'s named multipliers are set where `D`'s are. -/
def DecSt.Mono (D D' : DecSt) : Prop :=
  (D.z2.isSome → D'.z2.isSome) ∧ (D.z9.isSome → D'.z9.isSome) ∧
    (D.z2e10m1.isSome → D'.z2e10m1.isSome) ∧ (D.z2e50m1.isSome → D'.z2e50m1.isSome)

/-- `Mono` is reflexive. -/
theorem DecSt.Mono.refl (D : DecSt) : D.Mono D :=
  ⟨id, id, id, id⟩

/-- `Mono` is transitive. -/
theorem DecSt.Mono.trans {D D' D'' : DecSt} (h : D.Mono D') (h' : D'.Mono D'') : D.Mono D'' :=
  ⟨h'.1 ∘ h.1, h'.2.1 ∘ h.2.1, h'.2.2.1 ∘ h.2.2.1, h'.2.2.2 ∘ h.2.2.2⟩

/-- A stage's multiply only sets named multipliers. -/
theorem DecSt.mono_stageOp (D : DecSt) : D.Mono D.stageOp := by
  simp only [DecSt.Mono, DecSt.stageOp, DecSt.stageMul]
  split <;> simp

/-- So does the slow step's loop. -/
theorem DecSt.mono_stepSlowF : ∀ (f : Nat) (D : DecSt) (n : BitVec 64), D.Mono (D.stepSlowF f n)
  | 0, D, _ => DecSt.Mono.refl D
  | f + 1, D, n => by
    simp only [DecSt.stepSlowF]
    split
    · generalize (if D.rem.ult n then D.rem else n) = k
      have h1 : D.Mono (D.sqrs k) := ⟨id, id, id, id⟩
      split
      · exact h1.trans ((DecSt.mono_stageOp _).trans (DecSt.mono_stepSlowF f _ _))
      · exact h1.trans (DecSt.mono_stepSlowF f _ _)
    · exact DecSt.Mono.refl D

/-- So does a step. -/
theorem DecSt.mono_step (D : DecSt) (n : BitVec 64) : D.Mono (D.step n) := by
  unfold DecSt.step
  split
  · exact DecSt.Mono.refl D
  · split
    · exact DecSt.mono_stepSlowF 13 D n
    · exact DecSt.Mono.refl D

/-! ## The state in memory -/

section Mem

variable {m : MemoryState} {st : Pointer}

-- unfolding it makes the normalizer's matches `st.add a =?= st` time out
attribute [local irreducible] Pointer.add

/-- A store to `z` over the state. -/
theorem MemoryState.storeDec_storeAt_z (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 128#64) (BitVec.packLanes v) =
      m.storeDec st { D with z := v } := by
  dec_norm h

/-- A store to `y` over the state. -/
theorem MemoryState.storeDec_storeAt_y (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 448#64) (BitVec.packLanes v) =
      m.storeDec st { D with y := v } := by
  dec_norm h

/-- A store to `u` over the state. -/
theorem MemoryState.storeDec_storeAt_u (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 512#64) (BitVec.packLanes v) =
      m.storeDec st { D with u := v } := by
  dec_norm h

/-- A store to `v` over the state. -/
theorem MemoryState.storeDec_storeAt_v (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 576#64) (BitVec.packLanes v) =
      m.storeDec st { D with v := v } := by
  dec_norm h

/-- A store to `uv3` over the state. -/
theorem MemoryState.storeDec_storeAt_uv3 (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 640#64) (BitVec.packLanes v) =
      m.storeDec st { D with uv3 := v } := by
  dec_norm h

/-- A store to `x0` over the state. -/
theorem MemoryState.storeDec_storeAt_x0 (v : BitVec 32) :
    (m.storeDec st D).storeAt (st.add 720#64) v =
      m.storeDec st { D with x0 := v } := by
  simp only [MemoryState.storeDec, MemoryState.storeAt_storeAt_self]

/-- A state stored over one whose named multipliers it sets: the later one. -/
theorem MemoryState.storeDec_storeDec (h : ¬st.offset.uaddOverflow 724#64) {D' : DecSt}
    (hm : D.Mono D') : (m.storeDec st D).storeDec st D' = m.storeDec st D' := by
  generalize hM : m.storeDec st D = M
  rcases D' with ⟨x', mm', z', z2', z9', z10', z50', y', u', v', uv3', sg', rem', x0'⟩
  obtain ⟨h2, h9, h10, h50⟩ := hm
  simp only at h2 h9 h10 h50
  rw [MemoryState.storeDec]
  subst hM
  cases z2' <;> cases z9' <;> cases z10' <;> cases z50' <;>
    (try simp only [Option.isSome_none, Bool.false_eq_true, imp_false, Option.isSome_iff_ne_none,
      not_not] at h2 h9 h10 h50) <;>
    simp only [MemoryState.storeOpt, MemoryState.storeVec, MemoryState.storeDec_storeAt_x h,
      MemoryState.storeDec_storeAt_m h, MemoryState.storeDec_storeAt_z h,
      MemoryState.storeDec_storeAt_z2 h, MemoryState.storeDec_storeAt_z9 h,
      MemoryState.storeDec_storeAt_z2e10m1 h, MemoryState.storeDec_storeAt_z2e50m1 h,
      MemoryState.storeDec_storeAt_y h, MemoryState.storeDec_storeAt_u h,
      MemoryState.storeDec_storeAt_v h, MemoryState.storeDec_storeAt_uv3 h,
      MemoryState.storeDec_storeAt_stage h, MemoryState.storeDec_storeAt_rem h,
      MemoryState.storeDec_storeAt_x0] <;>
    rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩ <;>
    simp_all

/-- A store to another block commutes with the state's. -/
theorem MemoryState.storeAt_storeDec {p : Pointer} {x : BitVec w} (h : p.id ≠ st.id) :
    (m.storeAt p x).storeDec st D = (m.storeDec st D).storeAt p x := by
  have d (o : BitVec 64) (v : Nat) : (Range.of p w).Disjoint (Range.of (st.add o) v) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have d0 (v : Nat) : (Range.of p w).Disjoint (Range.of st v) :=
    Or.inl (by simpa [Range.of] using h)
  have dO (o : BitVec 64) (z : Option Wwl) (m' : MemoryState) :
      (m'.storeAt p x).storeOpt (st.add o) z = (m'.storeOpt (st.add o) z).storeAt p x := by
    cases z
    · rfl
    · exact MemoryState.storeAt_comm (d o 512)
  simp only [MemoryState.storeDec, MemoryState.storeVec, dO, MemoryState.storeAt_comm (d _ _),
    MemoryState.storeAt_comm (d0 _)]

/-- A point store to another block commutes with the state's. -/
theorem MemoryState.storeQuad_storeDec {p : Pointer} {P : Quad} (h : p.id ≠ st.id) :
    (m.storeQuad p P).storeDec st D = (m.storeDec st D).storeQuad p P := by
  have h' (o : BitVec 64) : (p.add o).id ≠ st.id := by rw [Pointer.add_id]; exact h
  simp only [MemoryState.storeQuad, MemoryState.storeVec, MemoryState.storeAt_storeDec (h' _),
    MemoryState.storeAt_storeDec h]

/-- A pointer load from another block is unaffected by `storeDec`. -/
theorem MemoryState.loadPtr_storeDec_of_id_ne {q : Pointer} (h : st.id ≠ q.id) :
    (m.storeDec st D).loadPtr q = m.loadPtr q := by
  have d (o : BitVec 64) (v : Nat) : (Range.of (st.add o) v).Disjoint (Range.of q 64) := by
    simp [Range.Disjoint, Range.of, Pointer.add, h]
  have d0 (v : Nat) : (Range.of st v).Disjoint (Range.of q 64) := by
    simp [Range.Disjoint, Range.of, h]
  have dO (o : BitVec 64) (x : Option Wwl) (m' : MemoryState) :
      (m'.storeOpt (st.add o) x).loadPtr q = m'.loadPtr q := by
    cases x
    · rfl
    · exact MemoryState.loadPtr_storeAt_disjoint (d o 512) _
  simp only [MemoryState.storeDec, MemoryState.storeVec, dO,
    MemoryState.loadPtr_storeAt_disjoint (d _ _), MemoryState.loadPtr_storeAt_disjoint (d0 _)]

/-- A point read from another block is unaffected by `storeDec`. -/
theorem MemoryState.readQuad_storeDec_of_id_ne {q : Pointer} (h : st.id ≠ q.id) :
    (m.storeDec st D).readQuad q = m.readQuad q := by
  have h' (o : BitVec 64) : st.id ≠ (q.add o).id := by rw [Pointer.add_id]; exact h
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt_storeDec_of_id_ne (h' _),
    MemoryState.readAt_storeDec_of_id_ne h]

/-- A point that fits still does past `storeDec`. -/
theorem MemoryState.QuadFit.storeDec {q : Pointer} (h' : m.QuadFit q) :
    (m.storeDec st D).QuadFit q :=
  ⟨h'.1, Fits.storeDec h'.2.1, Fits.storeDec h'.2.2.1, Fits.storeDec h'.2.2.2⟩

end Mem

end

end MLIR.Firedancer.Lane

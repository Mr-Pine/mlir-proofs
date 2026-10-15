module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Verify
public meta import Lean.Elab.Tactic
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `fd_ed25519_lane_decode2`'s inlined code as `verify_x8` compiles it: the runs the steps take
in one, and the lemmas relating its values to `decPre` and `decFin`. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512


/-! ## Tactics -/

public meta section

open Lean Meta in
/-- The conjuncts of `pf : ty` (through reducible abbreviations), with their proofs. -/
partial def envConjuncts (pf ty : Expr) (acc : Array (Expr × Expr)) :
    MetaM (Array (Expr × Expr)) := do
  match_expr ← whnfR ty with
  | And a b =>
    envConjuncts (mkApp3 (mkConst ``And.right) a b pf) b
        (← envConjuncts (mkApp3 (mkConst ``And.left) a b pf) a acc)
  | _ =>
    return acc.push (pf, ty)

open Lean Elab Tactic Meta in
/-- `split_env h…`: each conjunction `h` (an `E ⊨ […]`, also behind an abbreviation) as one fact
per read, so the steps seal the env past them. -/
elab "split_env" hs:(ppSpace colGt ident)+ : tactic =>
  for h in hs do
    withMainContext do
        let d ← getLocalDeclFromUserName h.getId
        let parts ← envConjuncts d.toExpr (← instantiateMVars d.type) #[]
        let (_, g) ←
          (← getMainGoal).assertHypotheses
              (parts.mapIdx fun i (pf, ty) =>
                { userName := h.getId.appendIndexAfter i, type := ty, value := pf })
        replaceMainGoal [← g.clear d.fvarId]

open Lean Elab Tactic Meta in
/-- `subst_limb4`: substitute the locals `v = x.l4` a pattern names after its last write, so the env
reads `x.l4`. -/
elab "subst_limb4" : tactic => do
  let vs ←
    withMainContext do
        let mut vs := #[]
        for d in ← getLCtx do
          if d.isImplementationDetail then
            continue
          let some (_, .fvar v, r) := (← instantiateMVars d.type).consumeMData.eq? | continue
          if r.isAppOfArity ``Fe.l4 1 then
            vs := vs.push v
        pure vs
  for v in vs do
    liftMetaTactic fun g => return [← substVar g v]

end

@[expose] public section

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-! ## Lanes -/

/-- Bit `j` of eight packed bits. -/
theorem getLsbD_packLanes1 (V : Vector (BitVec 1) n) {j : Nat} (hj : j < n) :
    (BitVec.packLanes V).getLsbD j = (V[j]).getLsbD 0 := by
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt V (s := j) (w := 1) (by simpa using hj) (by omega))
  simp only [Nat.div_one, Nat.mod_one, BitVec.getLsbD_extractLsb', Nat.lt_one_iff, decide_true,
    Bool.true_and, Nat.add_zero] at h
  exact h

/-- Eight values inserted into a poison vector, lane by lane. -/
theorem insert8_wrap (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    (((((((((Vector.replicate 8 (PoisonOr.poison : PoisonOr (BitVec 64))).set 0 (.value a0)
      (by decide)).set 1 (.value a1) (by decide)).set 2 (.value a2) (by decide)).set 3 (.value a3)
      (by decide)).set 4 (.value a4) (by decide)).set 5 (.value a5) (by decide)).set 6
      (.value a6) (by decide)).set 7 (.value a7) (by decide)) =
      Ty.wrap (t := .vec 8 64) #v[a0, a1, a2, a3, a4, a5, a6, a7] := by
  ext i hi
  simp only [Ty.wrap_vec]
  interval_cases i <;> simp

/-! ## The sign bits -/

/-- The sign word as compiled: bit 63 of each encoding's last qword, moved to its lane. -/
theorem sign_word (X : Fin 8 → BitVec 256) :
    (BitVec.extractLsb' 192 64 (X 1) >>> 62 &&& 2#64 |||
          BitVec.extractLsb' 192 64 (X 2) >>> 61 &&& 4#64 |||
        BitVec.extractLsb' 192 64 (X 3) >>> 60 &&& 8#64 |||
      BitVec.extractLsb' 192 64 (X 4) >>> 59 &&& 16#64 |||
      BitVec.extractLsb' 192 64 (X 5) >>> 58 &&& 32#64 |||
      BitVec.extractLsb' 192 64 (X 6) >>> 57 &&& 64#64 |||
      BitVec.extractLsb' 192 64 (X 7) >>> 56 &&& 128#64 |||
      BitVec.extractLsb' 192 64 (X 0) >>> 63 &&& 4294967295#64) = (signs X).setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [signs, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_ushiftRight,
    BitVec.getLsbD_extractLsb', BitVec.getLsbD_setWidth]
  by_cases h8 : i < 8
  · rw [getLsbD_packLanes1 _ h8]
    interval_cases i <;> simp
  · have h8' : 1 * 8 ≤ i := by omega
    simp only [BitVec.getLsbD_of_ge _ i h8', Bool.and_false]
    interval_cases i <;> simp

/-- The sign word is below `2^8`: its sign extension is its zero extension. -/
theorem signs_signExtend (X : Fin 8 → BitVec 256) :
    (signs X).signExtend 64 = (signs X).setWidth 64 := by
  apply BitVec.signExtend_eq_setWidth_of_msb_false
  rw [BitVec.msb_eq_getLsbD_last]
  simp only [signs, BitVec.getLsbD_setWidth]
  exact BitVec.getLsbD_of_ge _ _ (by decide)

/-! ## Distinct registers -/

/-- Whether `a` is among `l`. -/
def memB (a : Nat) : List Nat → Bool
  | [] => false
  | b :: l => a.beq b || memB a l

/-- Whether the elements of `l` are pairwise distinct: a pattern's register premise, decided on the
indices without unfolding the context. -/
def distinctB : List Nat → Bool
  | [] => true
  | a :: l => !memB a l && distinctB l

/-- `memB` is membership. -/
theorem memB_iff {a : Nat} {l : List Nat} : memB a l = true ↔ a ∈ l := by
  induction l with
  | nil => simp [memB]
  | cons b l ih => simp [memB, ih, Nat.beq_eq]

/-- `distinctB` of the indices gives `Nodup`. -/
theorem nodup_of_distinctB {n : Nat} {l : List (Fin n)} (h : distinctB (l.map Fin.val) = true) :
    l.Nodup := by
  induction l with
  | nil => exact List.nodup_nil
  | cons a l ih =>
    simp only [List.map, distinctB, Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true] at h
    refine List.nodup_cons.2 ⟨fun ha => ?_, ih h.2⟩
    have : memB a.val (l.map Fin.val) = true := memB_iff.2 (List.mem_map_of_mem ha)
    rw [this] at h
    exact absurd h.1 (by decide)

/-- A field element is its limbs. -/
@[simp]
theorem fe_eta (x : Fe) : (⟨x.l0, x.l1, x.l2, x.l3, x.l4⟩ : Fe) = x :=
  rfl

/-- Limb 0 of `readFe`, as a load reads it. -/
theorem readFe_l0 {m : MemoryState} {p : Pointer} :
    (m.readFe p).l0 = m.readVec p :=
  rfl

/-- Limb 1 of `readFe`, as a load reads it. -/
theorem readFe_l1 {m : MemoryState} {p : Pointer} :
    (m.readFe p).l1 = m.readVec (p.add 64#64) :=
  rfl

/-- Limb 2 of `readFe`, as a load reads it. -/
theorem readFe_l2 {m : MemoryState} {p : Pointer} :
    (m.readFe p).l2 = m.readVec (p.add 128#64) :=
  rfl

/-- Limb 3 of `readFe`, as a load reads it. -/
theorem readFe_l3 {m : MemoryState} {p : Pointer} :
    (m.readFe p).l3 = m.readVec (p.add 192#64) :=
  rfl

/-- Limb 4 of `readFe`, as a load reads it. -/
theorem readFe_l4 {m : MemoryState} {p : Pointer} :
    (m.readFe p).l4 = m.readVec (p.add 256#64) :=
  rfl

/-- Limb 0 of a field element as a load inside its known 320 bytes reads it. -/
theorem vec_readFe_l0 {m : MemoryState} {p : Pointer} :
    (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i (BitVec.setWidth 512 (m.readAt p 2560)))
        =
      (m.readFe p).l0 := by
  rw [readFe_l0, MemoryState.readVec,
      MemoryState.readAt_of_readAt_le (w := 512) (v := 2560) (by decide) rfl]

/-- Limb 1 of a field element as a load inside its known 320 bytes reads it. -/
theorem vec_readFe_l1 {m : MemoryState} {p : Pointer} (hf : InBounds m p 2560)
    (hov : ¬p.offset.uaddOverflow 320#64) :
    (Vector.ofFn fun i : Fin 8 =>
        Ty.extractVecElem 8 64 i (BitVec.extractLsb' 512 512 (m.readAt p 2560))) =
      (m.readFe p).l1 := by
  rw [readFe_l1, MemoryState.readVec,
    MemoryState.readAt_add_of_readAt hf (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide)
        rfl]
  rfl

/-- Limb 2 of a field element as a load inside its known 320 bytes reads it. -/
theorem vec_readFe_l2 {m : MemoryState} {p : Pointer} (hf : InBounds m p 2560)
    (hov : ¬p.offset.uaddOverflow 320#64) :
    (Vector.ofFn fun i : Fin 8 =>
        Ty.extractVecElem 8 64 i (BitVec.extractLsb' 1024 512 (m.readAt p 2560))) =
      (m.readFe p).l2 := by
  rw [readFe_l2, MemoryState.readVec,
    MemoryState.readAt_add_of_readAt hf (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide)
        rfl]
  rfl

/-- Limb 3 of a field element as a load inside its known 320 bytes reads it. -/
theorem vec_readFe_l3 {m : MemoryState} {p : Pointer} (hf : InBounds m p 2560)
    (hov : ¬p.offset.uaddOverflow 320#64) :
    (Vector.ofFn fun i : Fin 8 =>
        Ty.extractVecElem 8 64 i (BitVec.extractLsb' 1536 512 (m.readAt p 2560))) =
      (m.readFe p).l3 := by
  rw [readFe_l3, MemoryState.readVec,
    MemoryState.readAt_add_of_readAt hf (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide)
        rfl]
  rfl

/-- Limb 4 of a field element as a load inside its known 320 bytes reads it. -/
theorem vec_readFe_l4 {m : MemoryState} {p : Pointer} (hf : InBounds m p 2560)
    (hov : ¬p.offset.uaddOverflow 320#64) :
    (Vector.ofFn fun i : Fin 8 =>
        Ty.extractVecElem 8 64 i (BitVec.extractLsb' 2048 512 (m.readAt p 2560))) =
      (m.readFe p).l4 := by
  rw [readFe_l4, MemoryState.readVec,
    MemoryState.readAt_add_of_readAt hf (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide)
        rfl]
  rfl

/-- A field element's limb `k`, read from a known field element: its lanes, and known. -/
theorem fe_limb {m : MemoryState} {p : Pointer} {U : Fe} (hf : Fits m p 2560)
    (hov : ¬p.offset.uaddOverflow 320#64) (h : m.readFe p = U) {o : BitVec 64} (k : Fin 5)
    (ho : o = BitVec.ofNat 64 (64 * k.val)) :
    Fits m (p.add o) 512 ∧ m.readAt (p.add o) 512 = BitVec.packLanes (U.limb k) := by
  subst ho
  have hov' : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (64 * k.val)) :=
    BitVec.not_uaddOverflow_of_le hov (by have := k.isLt; simp; omega)
  have hw : (BitVec.ofNat 64 (64 * k.val)).toNat * 8 + 512 ≤ 2560 := by
    have := k.isLt; simp; omega
  refine ⟨Fits.add_of_le hov' hw hf, ?_⟩
  rw [← BitVec.packLanes_extractVecElem8 (m.readAt _ 512), ← h]
  congr 1
  fin_cases k <;> simp [MemoryState.readFe, Fe.limb, MemoryState.readVec]

/-! ## Decoding -/

/-- The limbs of eight encodings, lane `j` from `X j`: `decPre`'s `y`. -/
def yOf (X : Fin 8 → BitVec 256) : Fe :=
  Fe.ofLanes fun j => limbsOfBytes (X j)

/-- `y`'s limbs as the code extracts them from the qwords at bytes 0, 6, 12, 19, 24. -/
theorem yOf_eq (X : Fin 8 → BitVec 256) :
    (⟨Vector.ofFn fun i : Fin 8 =>
        [BitVec.setWidth 64 (X 0), BitVec.setWidth 64 (X 1), BitVec.setWidth 64 (X 2),
        BitVec.setWidth 64 (X 3), BitVec.setWidth 64 (X 4), BitVec.setWidth 64 (X 5),
        BitVec.setWidth 64 (X 6), BitVec.setWidth 64 (X 7)][i.val] &&& 2251799813685247#64,
      Vector.ofFn fun i : Fin 8 =>
          [BitVec.extractLsb' 48 64 (X 0), BitVec.extractLsb' 48 64 (X 1),
          BitVec.extractLsb' 48 64 (X 2), BitVec.extractLsb' 48 64 (X 3),
          BitVec.extractLsb' 48 64 (X 4), BitVec.extractLsb' 48 64 (X 5),
          BitVec.extractLsb' 48 64 (X 6), BitVec.extractLsb' 48 64 (X 7)][i.val] >>> 3 &&&
          2251799813685247#64,
      Vector.ofFn fun i : Fin 8 =>
          [BitVec.extractLsb' 96 64 (X 0), BitVec.extractLsb' 96 64 (X 1),
          BitVec.extractLsb' 96 64 (X 2), BitVec.extractLsb' 96 64 (X 3),
          BitVec.extractLsb' 96 64 (X 4), BitVec.extractLsb' 96 64 (X 5),
          BitVec.extractLsb' 96 64 (X 6), BitVec.extractLsb' 96 64 (X 7)][i.val] >>> 6 &&&
          2251799813685247#64,
      Vector.ofFn fun i : Fin 8 =>
          [BitVec.extractLsb' 152 64 (X 0), BitVec.extractLsb' 152 64 (X 1),
          BitVec.extractLsb' 152 64 (X 2), BitVec.extractLsb' 152 64 (X 3),
          BitVec.extractLsb' 152 64 (X 4), BitVec.extractLsb' 152 64 (X 5),
          BitVec.extractLsb' 152 64 (X 6), BitVec.extractLsb' 152 64 (X 7)][i.val] >>> 1 &&&
          2251799813685247#64,
      Vector.ofFn fun i : Fin 8 =>
          [BitVec.extractLsb' 192 64 (X 0), BitVec.extractLsb' 192 64 (X 1),
          BitVec.extractLsb' 192 64 (X 2), BitVec.extractLsb' 192 64 (X 3),
          BitVec.extractLsb' 192 64 (X 4), BitVec.extractLsb' 192 64 (X 5),
          BitVec.extractLsb' 192 64 (X 6), BitVec.extractLsb' 192 64 (X 7)][i.val] >>> 12 &&&
          2251799813685247#64⟩ : Fe) = yOf X := by
  simp only [yOf, Fe.ofLanes, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    (apply Vector.ext; intro i hi; interval_cases i <;> simp
        [limbsOfBytes, BitVec.setWidth_eq_extractLsb'])

/-- A decoding's point after `fd_ed25519_lane_zero` and the stores of `y`, at `P`: `x`, `t` zero,
`z` one, `y` from `Y`. -/
def pointMem (m : MemoryState) (P : Pointer) (Y : Fe) : MemoryState :=
  (((((((((m.storeAt P 0#2560).storeAt (P.add 960#64)
      (BitVec.packLanes (Vector.replicate 8 0#64))).storeAt
                            (P.add 640#64) (BitVec.packLanes (Vector.replicate 8 1#64))).storeAt
                        (P.add 704#64) 0#2048).storeAt
                    (P.add 1024#64) 0#2048).storeAt
                (P.add 320#64) (BitVec.packLanes Y.l0)).storeAt
            (P.add 384#64) (BitVec.packLanes Y.l1)).storeAt
        (P.add 448#64) (BitVec.packLanes Y.l2)).storeAt
    (P.add 512#64) (BitVec.packLanes Y.l3)).storeAt (P.add 576#64) (BitVec.packLanes Y.l4)

/-- The zero limbs a load of zeroed memory gives. -/
theorem zeroVec_eq : (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512) = wwl_zero := by
  apply Vector.ext
  intro i hi
  simp [Ty.extractVecElem_eq]

/-- `fd_ed25519_lane_sub( &u, &y, &z )` as compiled for `z = 1` (its limbs past the first loaded,
zero): `sub y 1`. -/
theorem subOne_eq (Y : Fe) :
    (⟨wwl_madd52lo
        (wwl_and (wwl_add Y.l0 (Vector.replicate 8 9007199254740915#64))
        (Vector.replicate 8 2251799813685247#64))
        (wwl_shru
        (wwl_sub (wwl_add Y.l4 (Vector.replicate 8 9007199254740988#64))
        (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512)) 51)
        (Vector.replicate 8 19#64),
      wwl_add (wwl_and (wwl_add Y.l1 (Vector.replicate 8 9007199254740988#64))
          (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_add Y.l0 (Vector.replicate 8 9007199254740915#64)) 51),
      wwl_add (wwl_and
          (wwl_sub (wwl_add Y.l2 (Vector.replicate 8 9007199254740988#64))
          (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512))
          (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_add Y.l1 (Vector.replicate 8 9007199254740988#64)) 51),
      wwl_add (wwl_and
          (wwl_sub (wwl_add Y.l3 (Vector.replicate 8 9007199254740988#64))
          (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512))
          (Vector.replicate 8 2251799813685247#64))
          (wwl_shru
          (wwl_sub (wwl_add Y.l2 (Vector.replicate 8 9007199254740988#64))
          (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512)) 51),
      wwl_add (wwl_and
          (wwl_sub (wwl_add Y.l4 (Vector.replicate 8 9007199254740988#64))
          (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512))
          (Vector.replicate 8 2251799813685247#64))
          (wwl_shru
          (wwl_sub (wwl_add Y.l3 (Vector.replicate 8 9007199254740988#64))
          (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512)) 51)⟩ : Fe) = sub Y
          Fe.one := by
  have hc0 : (2 * (2 ^ 52 - 38) : BitVec 64) = 9007199254740916#64 := by decide
  have hc1 : (2 * (2 ^ 52 - 2) : BitVec 64) = 9007199254740988#64 := by decide
  have e0 (x : BitVec 64) : x + 9007199254740915#64 = x + 9007199254740916#64 - 1#64 := by
    bv_decide
  have h0 : wwl_add Y.l0 (Vector.replicate 8 9007199254740915#64) =
      wwl_sub (wwl_add Y.l0 (wwl_bcast 9007199254740916#64)) (wwl_bcast 1) := by
    apply Vector.ext; intro i hi; simp [wwl_add, wwl_sub, wwl_bcast, e0]
  have h1 (x : Wwl) : wwl_add x (Vector.replicate 8 9007199254740988#64) =
      wwl_sub (wwl_add x (wwl_bcast 9007199254740988#64)) wwl_zero := by
    apply Vector.ext; intro i hi; simp [wwl_add, wwl_sub, wwl_bcast]
  rw [zeroVec_eq, sub, carry_compiled, hc0, hc1, h0, h1 Y.l1]
  rfl

/-- `fd_ed25519_lane_add_raw( &v, &v, &z )` as compiled for `z = 1`: `addRaw v 1`. -/
theorem addOne_eq (V : Fe) :
    (⟨wwl_add V.l0 (Vector.replicate 8 1#64), V.l1,
        wwl_add V.l2 (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512),
      wwl_add V.l3 (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512),
          wwl_add V.l4 (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i 0#512)⟩ : Fe) = addRaw
          V Fe.one := by
  rw [zeroVec_eq]
  have h1 : V.l1 = wwl_add V.l1 wwl_zero := by
    apply Vector.ext; intro i hi; simp [wwl_add]
  have h0 : Vector.replicate 8 1#64 = wwl_bcast 1 := rfl
  rw [h0]
  conv_lhs => rw [h1]
  rfl

/-! ## The zero test -/

/-- A carry times 19: no overflow either way. -/
theorem shr51_mul19_ok (a : BitVec 64) :
    (a >>> 51).smulOverflow 19#64 = false ∧ (a >>> 51).umulOverflow 19#64 = false := by bv_decide

/-- A carry times 19 plus 51 masked bits: no overflow either way. -/
theorem mul19_add_mask_ok (a b : BitVec 64) :
    (a >>> 51 * 19#64).saddOverflow (b &&& 2251799813685247#64) = false ∧
      (a >>> 51 * 19#64).uaddOverflow (b &&& 2251799813685247#64) = false := by
  bv_decide

/-- `normalize`'s `mul nsw nuw` of a carry by 19. -/
theorem zipWith_mul_shru19 (x : Wwl) :
    Vector.zipWith (Operation.mul { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru x 51))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 19#64)) =
      Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)) := by
  ext i hi
  have := shr51_mul19_ok x[i]
  simp_all [Ty.wrap_vec, wwl_mul, wwl_shru, Operation.mul]

/-- `normalize`'s `add nsw nuw` of a carry times 19 and 51 masked bits. -/
theorem zipWith_add_mul19_mask (x y : Wwl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64)))
        (Ty.wrap (t := .vec 8 64) (wwl_and y (Vector.replicate 8 2251799813685247#64))) =
      Ty.wrap (t := .vec 8 64)
        (wwl_add (wwl_mul (wwl_shru x 51) (Vector.replicate 8 19#64))
          (wwl_and y (Vector.replicate 8 2251799813685247#64))) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simpa [wwl_and, wwl_shru, wwl_mul] using mul19_add_mask_ok x[i] y[i]

/-- `icmp eq` on lanes. -/
theorem zipWith_icmp_eq_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.icmp IntPred.eq (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => BitVec.ofBool (x[i] == y[i])) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.icmp]

/-- `icmp ugt` on lanes. -/
theorem zipWith_icmp_ugt_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.icmp IntPred.ugt (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => BitVec.ofBool (y[i].ult x[i])) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.icmp]

/-- `and` on lane bits. -/
theorem zipWith_and_i1 (x y : ⟦.vec 8 1⟧ᵣ) :
    Vector.zipWith (Operation.and (w := 1)) (Ty.wrap (t := .vec 8 1) x)
        (Ty.wrap (t := .vec 8 1) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => x[i] &&& y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.and]

/-- `or` on lane bits. -/
theorem zipWith_or_i1 (x y : ⟦.vec 8 1⟧ᵣ) :
    Vector.zipWith (Operation.or false (w := 1)) (Ty.wrap (t := .vec 8 1) x)
        (Ty.wrap (t := .vec 8 1) y) =
      Ty.wrap (t := .vec 8 1) (Vector.ofFn fun i => x[i] ||| y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.or]

/-- `or` on lanes. -/
theorem zipWith_or_wwl (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.or false (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (Vector.ofFn fun i => x[i] ||| y[i]) := by
  ext i hi
  simp [Ty.wrap_vec, Operation.or]

attribute [local mlir_operation] zipWith_mul_shru19 zipWith_add_mul19_mask zipWith_icmp_eq_wwl
  zipWith_and_i1 zipWith_or_i1 zipWith_or_wwl

/-- Bit `j < 8` of `wwl_eq`: lane `j`'s test. -/
theorem getLsbD_wwl_eq (x y : Wwl) {j : Nat} (hj : j < 8) :
    (wwl_eq x y).getLsbD j = (x[j] == y[j]) := by
  rw [wwl_eq, BitVec.getLsbD_setWidth, getLsbD_packLanes1 _ hj]
  simp [show j < 32 by omega]

/-- `fd_ed25519_lane_normalize`'s carry pass as compiled: each sum with its carry first. -/
def passC (a : Fe) : Fe :=
  let t1 := wwl_add (wwl_shru a.l0 51) a.l1
  let t2 := wwl_add (wwl_shru t1 51) a.l2
  let t3 := wwl_add (wwl_shru t2 51) a.l3
  let t4 := wwl_add (wwl_shru t3 51) a.l4
  ⟨wwl_add (wwl_mul (wwl_shru t4 51) (Vector.replicate 8 19#64))
      (wwl_and a.l0 (Vector.replicate 8 2251799813685247#64)),
    wwl_and t1 (Vector.replicate 8 2251799813685247#64),
    wwl_and t2 (Vector.replicate 8 2251799813685247#64),
    wwl_and t3 (Vector.replicate 8 2251799813685247#64),
    wwl_and t4 (Vector.replicate 8 2251799813685247#64)⟩

/-- One carry pass of `fd_ed25519_lane_normalize`. -/
def normPass (a : Fe) : Fe :=
  let mask := wwl_bcast mask51
  let l1 := wwl_add a.l1 (wwl_shru a.l0 51)
  let l0 := wwl_and a.l0 mask
  let l2 := wwl_add a.l2 (wwl_shru l1 51)
  let l1 := wwl_and l1 mask
  let l3 := wwl_add a.l3 (wwl_shru l2 51)
  let l2 := wwl_and l2 mask
  let l4 := wwl_add a.l4 (wwl_shru l3 51)
  let l3 := wwl_and l3 mask
  let l0 := wwl_add l0 (wwl_mul (wwl_shru l4 51) (wwl_bcast 19))
  let l4 := wwl_and l4 mask
  ⟨l0, l1, l2, l3, l4⟩

/-- One pass of `normalize` is `passC`. -/
theorem normPass_eq (b : Fe) : normPass b = passC b := by
  simp only [normPass, passC, wwl_bcast, mask51, wwl_add_comm b.l1, wwl_add_comm b.l2,
    wwl_add_comm b.l3, wwl_add_comm b.l4, wwl_add_comm (wwl_and b.l0 _)]
  rfl

/-- `normalize` is two `passC`s. -/
theorem normalize_eq_passC (a : Fe) : normalize a = passC (passC a) := by
  rw [show normalize a = normPass (normPass a) from rfl, normPass_eq, normPass_eq]

/-- `fd_ed25519_lane_is_zero` after the normalization. -/
def isZeroOf (a : Fe) : BitVec 32 :=
  let z :=
    wwl_eq a.l0 wwl_zero &&& wwl_eq a.l1 wwl_zero &&& wwl_eq a.l2 wwl_zero &&&
      wwl_eq a.l3 wwl_zero &&&
      wwl_eq a.l4 wwl_zero
  let m := wwl_bcast mask51
  let q :=
    wwl_eq a.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq a.l1 m &&& wwl_eq a.l2 m &&& wwl_eq a.l3 m &&&
      wwl_eq a.l4 m
  (255 &&& z) ||| (255 &&& q)

/-- `isZero` tests the normalized limbs. -/
theorem isZero_eq (a : Fe) : isZero a = isZeroOf (normalize a) :=
  rfl

/-- `subRaw` with `2p`'s limbs as literals. -/
theorem subRaw_eq (a b : Fe) :
    subRaw a b =
      ⟨wwl_sub (wwl_add a.l0 (Vector.replicate 8 4503599627370458#64)) b.l0,
        wwl_sub (wwl_add a.l1 (Vector.replicate 8 4503599627370494#64)) b.l1,
        wwl_sub (wwl_add a.l2 (Vector.replicate 8 4503599627370494#64)) b.l2,
        wwl_sub (wwl_add a.l3 (Vector.replicate 8 4503599627370494#64)) b.l3,
        wwl_sub (wwl_add a.l4 (Vector.replicate 8 4503599627370494#64)) b.l4⟩ :=
  rfl

/-- The zero test on one lane. -/
theorem zeroTest_lane (a0 a1 a2 a3 a4 : BitVec 64) :
    (a1 &&& 2251799813685247#64 &&& a2 &&& a3 &&& a4 == 2251799813685247#64 &&
          a0 == 2251799813685229#64 ||
        a0 ||| (a2 ||| a1 ||| a3 ||| a4) &&& 2251799813685247#64 == 0#64) =
      (a0 == 0 && a1 &&& 2251799813685247#64 == 0 && a2 &&& 2251799813685247#64 == 0 &&
          a3 &&& 2251799813685247#64 == 0 &&
          a4 &&& 2251799813685247#64 == 0 ||
        a0 == 2251799813685247 - 18 && a1 &&& 2251799813685247#64 == 2251799813685247 &&
          a2 &&& 2251799813685247#64 == 2251799813685247 &&
          a3 &&& 2251799813685247#64 == 2251799813685247 &&
          a4 &&& 2251799813685247#64 == 2251799813685247) := by
  bv_decide

/-- The zero test as compiled, on the normalization's limbs before their last masks. -/
theorem zeroTest_compiled (n0 n1 n2 n3 n4 : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        BitVec.ofBool
          ((wwl_and (wwl_and (wwl_and (wwl_and n1 (Vector.replicate 8 2251799813685247#64)) n2) n3)
                    n4)[↑i] ==
                2251799813685247#64 &&
              n0[↑i] == 2251799813685229#64 ||
            (n0[↑i] |||
                (wwl_and (Vector.ofFn fun i : Fin 8 => n2[↑i] ||| n1[↑i] ||| n3[↑i] ||| n4[↑i])
                    (Vector.replicate 8 2251799813685247#64))[↑i] ==
              0#64))) =
      Vector.ofFn fun i =>
        BitVec.ofBool
          ((isZeroOf
                ⟨n0, wwl_and n1 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n2 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n3 (Vector.replicate 8 2251799813685247#64),
                  wwl_and n4 (Vector.replicate 8 2251799813685247#64)⟩).getLsbD
            i) := by
  apply Vector.ext
  intro i hi
  simp only [Vector.getElem_ofFn]
  refine congrArg BitVec.ofBool ?_
  have hb : (255 : BitVec 32).getLsbD i = true := by interval_cases i <;> decide
  simp only [isZeroOf, BitVec.getLsbD_or, BitVec.getLsbD_and, getLsbD_wwl_eq _ _ hi, hb,
    Bool.true_and, wwl_and, wwl_bcast, wwl_zero, mask51, Vector.getElem_ofFn,
    Vector.getElem_replicate, Fin.getElem_fin]
  exact zeroTest_lane _ _ _ _ _

/-- `isZero` has no bits past 8. -/
theorem isZero_getLsbD_of_ge (a : Fe) {j : Nat} (hj : 8 ≤ j) : (isZero a).getLsbD j = false := by
  have h : (255 : BitVec 32).getLsbD j = false := by
    rw [BitVec.ofNat_eq_ofNat, BitVec.getLsbD_ofNat,
      Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le (by decide) (Nat.pow_le_pow_right (by decide) hj)),
      Bool.and_false]
  simp only [isZero, BitVec.getLsbD_or, BitVec.getLsbD_and, h, Bool.false_and, Bool.or_false]


/-- A lane mask's low eight bits, as an `i8` holds them. -/
def z8 (m : BitVec 32) : BitVec 8 :=
  m.setWidth 8

/-- Eight lane bits of a mask, packed as the `bitcast` to an `i8` does: its low byte. -/
theorem z8_eq (m : BitVec 32) (h : (Ty.vec 8 1).width = (Ty.vec 8 1).width) :
    @BitVec.cast 8 8 h
        (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (m.getLsbD i))) =
      z8 m := by
  change (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (m.getLsbD i)) :
    BitVec 8) = z8 m
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [getLsbD_packLanes1 _ hi]
  simp [z8, hi]

/-- `~m`'s low byte. -/
theorem z8_not (m : BitVec 32) : z8 m ^^^ 255#8 = z8 (~~~m) := by
  simp only [z8]; bv_decide

/-- `a & b`'s low byte. -/
theorem z8_and (a b : BitVec 32) : z8 a &&& z8 b = z8 (a &&& b) := by
  simp only [z8]; bv_decide

/-- `a | b`'s low byte. -/
theorem z8_or (a b : BitVec 32) : z8 a ||| z8 b = z8 (a ||| b) := by
  simp only [z8]; bv_decide

/-- `fd_ed25519_lane_decode2`'s `ge_p` of normalized limbs `t`. -/
def gePOf (t : Fe) : BitVec 32 :=
  wwl_geu t.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq t.l1 (wwl_bcast mask51) &&&
    wwl_eq t.l2 (wwl_bcast mask51) &&& wwl_eq t.l3 (wwl_bcast mask51) &&&
    wwl_eq t.l4 (wwl_bcast mask51)

/-- `fd_ed25519_lane_decode2`'s `parity` of normalized limbs `t`. -/
def parityOf (t : Fe) : BitVec 32 :=
  wwl_ne (wwl_and t.l0 wwl_one) wwl_zero ^^^ gePOf t

/-- Bit `j < 8` of `wwl_geu`: lane `j`'s test. -/
theorem getLsbD_wwl_geu (x y : Wwl) {j : Nat} (hj : j < 8) :
    (wwl_geu x y).getLsbD j = decide (y[j] ≤ x[j]) := by
  rw [wwl_geu, BitVec.getLsbD_setWidth, getLsbD_packLanes1 _ hj]
  simp [show j < 32 by omega]

/-- Bit `j < 8` of `wwl_ne`: lane `j`'s test. -/
theorem getLsbD_wwl_ne (x y : Wwl) {j : Nat} (hj : j < 8) :
    (wwl_ne x y).getLsbD j = (x[j] != y[j]) := by
  rw [wwl_ne, BitVec.getLsbD_setWidth, getLsbD_packLanes1 _ hj]
  simp [show j < 32 by omega]

/-- `ge_p` on one lane, as compiled and as the C writes it. -/
theorem geP_lane (a0 a1 a2 a3 a4 : BitVec 64) :
    (a1 &&& 2251799813685247#64 &&& a2 &&& a3 &&& a4 == 2251799813685247#64 &&
        (2251799813685228#64).ult a0) =
      (decide (2251799813685247 - 18 ≤ a0) && a1 &&& 2251799813685247 == 2251799813685247 &&
          a2 &&& 2251799813685247 == 2251799813685247 &&
          a3 &&& 2251799813685247 == 2251799813685247 &&
          a4 &&& 2251799813685247 == 2251799813685247) := by
  bv_decide

/-- `ge_p` as compiled, on the normalization's limbs before their last masks. -/
theorem geP_compiled (n0 n1 n2 n3 n4 : Wwl) (h : (Ty.vec 8 1).width = (Ty.vec 8 1).width) :
    @BitVec.cast 8 8 h
        (BitVec.packLanes (Vector.ofFn fun i : Fin 8 =>
          BitVec.ofBool
            ((wwl_and (wwl_and (wwl_and (wwl_and n1 (Vector.replicate 8 2251799813685247#64)) n2)
                  n3) n4)[(i : Nat)] == 2251799813685247#64 &&
              (2251799813685228#64).ult n0[(i : Nat)]))) =
      z8 (gePOf ⟨n0, wwl_and n1 (Vector.replicate 8 2251799813685247#64),
        wwl_and n2 (Vector.replicate 8 2251799813685247#64),
        wwl_and n3 (Vector.replicate 8 2251799813685247#64),
        wwl_and n4 (Vector.replicate 8 2251799813685247#64)⟩) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  change @BitVec.getLsbD (1 * 8) (BitVec.packLanes _) i = _
  rw [getLsbD_packLanes1 _ hi]
  simp only [z8, gePOf, BitVec.getLsbD_setWidth, hi, decide_true, Bool.true_and,
    BitVec.getLsbD_and, getLsbD_wwl_eq _ _ hi, getLsbD_wwl_geu _ _ hi, Vector.getElem_ofFn,
    wwl_and, wwl_bcast, mask51, Vector.getElem_replicate, Fin.getElem_fin, BitVec.getLsbD_ofBool]
  exact geP_lane _ _ _ _ _

/-- The parity bits as compiled (`trunc` to `i1`): lane `i`'s low bit. -/
theorem par_compiled (n0 : Wwl) (h : (Ty.vec 8 1).width = (Ty.vec 8 1).width) :
    @BitVec.cast 8 8 h
        (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.setWidth 1 n0[(i : Nat)])) =
      z8 (wwl_ne (wwl_and n0 wwl_one) wwl_zero) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  change @BitVec.getLsbD (1 * 8) (BitVec.packLanes _) i = _
  rw [getLsbD_packLanes1 _ hi]
  simp only [z8, BitVec.getLsbD_setWidth, hi, decide_true, Bool.true_and,
    getLsbD_wwl_ne _ _ hi, Vector.getElem_ofFn, wwl_and, wwl_one, wwl_zero, wwl_bcast,
    Vector.getElem_replicate, Fin.getElem_fin]
  generalize n0[i] = a
  bv_decide

/-- The sign test's `i8` xors: the low byte of `sign ^ (parity ^ ge_p)`. -/
theorem z8_sign_xor (t : Fe) (sg : BitVec 32) :
    z8 (wwl_ne (wwl_and t.l0 wwl_one) wwl_zero) ^^^ BitVec.setWidth 8 sg ^^^ z8 (gePOf t) =
      z8 (sg ^^^ parityOf t) := by
  simp only [z8, parityOf]
  generalize wwl_ne (wwl_and t.l0 wwl_one) wwl_zero = a
  generalize gePOf t = b
  bv_decide

/-- A lane bit of a mask's low byte, `bitcast` to lane bits. -/
theorem sel_bit (m : BitVec 32) (h : (Ty.bv 8).width = (Ty.bv 8).width) (i : Fin 8) :
    (Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 m)) = 1#1) = (m.getLsbD i = true) := by
  have key : Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 m)) = BitVec.ofBool (m.getLsbD i) := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    obtain rfl : j = 0 := by omega
    rw [Ty.extractVecElem_eq]
    simp only [z8, BitVec.getLsbD_extractLsb', BitVec.getLsbD_ofBool]
    change (BitVec.setWidth 8 m).getLsbD (i * 1 + 0) = _
    simp [i.isLt]
  rw [key]
  cases m.getLsbD i <;> decide

/-- A `select` on a mask's low byte, `bitcast` to lane bits: `wwl_if`. -/
theorem sel_z8 (m : BitVec 32) (h : (Ty.bv 8).width = (Ty.bv 8).width) (a b : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 m)) = 1#1 then a[(i : Nat)]
        else b[(i : Nat)]) =
      wwl_if m a b := by
  simp only [sel_bit]
  rfl

/-- `sel_z8` against a splat. -/
theorem sel_z8_k (m : BitVec 32) (h : (Ty.bv 8).width = (Ty.bv 8).width) (a : Wwl)
    (k : BitVec 64) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 m)) = 1#1 then a[(i : Nat)] else k) =
      wwl_if m a (Vector.replicate 8 k) := by
  simp only [sel_bit, wwl_if, Fin.getElem_fin, Vector.getElem_replicate]

/-- Two `sel_z8`s, the outer against a splat. -/
theorem sel_z8_2k (m n : BitVec 32) (h : (Ty.bv 8).width = (Ty.bv 8).width) (a b : Wwl)
    (k : BitVec 64) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 m)) = 1#1 then
          if Ty.extractVecElem 8 1 i (@BitVec.cast 8 8 h (z8 n)) = 1#1 then a[(i : Nat)]
          else b[(i : Nat)]
        else k) =
      wwl_if m (wwl_if n a b) (Vector.replicate 8 k) := by
  simp only [sel_bit, wwl_if, Fin.getElem_fin, Vector.getElem_replicate, Vector.getElem_ofFn]

/-- `addRaw` as compiled: each sum's operands the other way round. -/
theorem addRaw_comm (a b : Fe) :
    addRaw a b = ⟨wwl_add b.l0 a.l0, wwl_add b.l1 a.l1, wwl_add b.l2 a.l2, wwl_add b.l3 a.l3,
      wwl_add b.l4 a.l4⟩ := by
  simp only [addRaw, Fe.zipWith, wwl_add_comm a.l0, wwl_add_comm a.l1, wwl_add_comm a.l2,
    wwl_add_comm a.l3, wwl_add_comm a.l4]


/-- `fd_ed25519_lane_normalize`'s first pass as compiled: the carry into limb 0 added before it. -/
theorem normPass_compiled (a : Fe) :
    normPass a =
      let t1 := wwl_add a.l1 (wwl_shru a.l0 51)
      let t2 := wwl_add a.l2 (wwl_shru t1 51)
      let t3 := wwl_add a.l3 (wwl_shru t2 51)
      let t4 := wwl_add a.l4 (wwl_shru t3 51)
      ⟨wwl_add (wwl_mul (wwl_shru t4 51) (Vector.replicate 8 19#64))
          (wwl_and a.l0 (Vector.replicate 8 2251799813685247#64)),
        wwl_and t1 (Vector.replicate 8 2251799813685247#64),
        wwl_and t2 (Vector.replicate 8 2251799813685247#64),
        wwl_and t3 (Vector.replicate 8 2251799813685247#64),
        wwl_and t4 (Vector.replicate 8 2251799813685247#64)⟩ := by
  simp only [normPass, wwl_bcast, mask51]
  rw [wwl_add_comm (wwl_and a.l0 _)]
  rfl

/-- `fd_ed25519_lane_normalize`'s two passes as compiled: the first adds each limb's carry after
it, the second before. -/
theorem normalize_compiled (a0 a1 a2 a3 a4 : Wwl) :
    normalize ⟨a0, a1, a2, a3, a4⟩ =
      ⟨(wwl_add (wwl_mul (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_shru
          (wwl_add (wwl_shru (wwl_add (wwl_mul (wwl_shru (wwl_add a4 (wwl_shru (wwl_add a3
          (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51)) 51)) 51)
          (Vector.replicate 8 19#64)) (wwl_and a0 (Vector.replicate 8 2251799813685247#64))) 51)
          (wwl_and (wwl_add a1 (wwl_shru a0 51)) (Vector.replicate 8 2251799813685247#64))) 51)
          (wwl_and (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) (Vector.replicate 8
          2251799813685247#64))) 51) (wwl_and (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add
          a1 (wwl_shru a0 51)) 51)) 51)) (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and
          (wwl_add a4 (wwl_shru (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru
          a0 51)) 51)) 51)) 51)) (Vector.replicate 8 2251799813685247#64))) 51) (Vector.replicate 8
          19#64)) (wwl_and (wwl_add (wwl_mul (wwl_shru (wwl_add a4 (wwl_shru (wwl_add a3 (wwl_shru
          (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51)) 51)) 51) (Vector.replicate
          8 19#64)) (wwl_and a0 (Vector.replicate 8 2251799813685247#64))) (Vector.replicate 8
          2251799813685247#64))),
        wwl_and (wwl_add (wwl_shru (wwl_add (wwl_mul (wwl_shru (wwl_add a4 (wwl_shru (wwl_add a3
          (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51)) 51)) 51)
          (Vector.replicate 8 19#64)) (wwl_and a0 (Vector.replicate 8 2251799813685247#64))) 51)
          (wwl_and (wwl_add a1 (wwl_shru a0 51)) (Vector.replicate 8 2251799813685247#64)))
          (Vector.replicate 8 2251799813685247#64),
        wwl_and (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_mul (wwl_shru (wwl_add a4
          (wwl_shru (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51))
          51)) 51)) 51) (Vector.replicate 8 19#64)) (wwl_and a0 (Vector.replicate 8
          2251799813685247#64))) 51) (wwl_and (wwl_add a1 (wwl_shru a0 51)) (Vector.replicate 8
          2251799813685247#64))) 51) (wwl_and (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51))
          51)) (Vector.replicate 8 2251799813685247#64))) (Vector.replicate 8 2251799813685247#64),
        wwl_and (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_mul
          (wwl_shru (wwl_add a4 (wwl_shru (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1
          (wwl_shru a0 51)) 51)) 51)) 51)) 51) (Vector.replicate 8 19#64)) (wwl_and a0
          (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add a1 (wwl_shru a0 51))
          (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add a2 (wwl_shru (wwl_add a1
          (wwl_shru a0 51)) 51)) (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add
          a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51))
          (Vector.replicate 8 2251799813685247#64))) (Vector.replicate 8 2251799813685247#64),
        wwl_and (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_shru (wwl_add (wwl_shru
          (wwl_add (wwl_mul (wwl_shru (wwl_add a4 (wwl_shru (wwl_add a3 (wwl_shru (wwl_add a2
          (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51)) 51)) 51) (Vector.replicate 8 19#64))
          (wwl_and a0 (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add a1 (wwl_shru
          a0 51)) (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add a2 (wwl_shru
          (wwl_add a1 (wwl_shru a0 51)) 51)) (Vector.replicate 8 2251799813685247#64))) 51)
          (wwl_and (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51))
          51)) (Vector.replicate 8 2251799813685247#64))) 51) (wwl_and (wwl_add a4 (wwl_shru
          (wwl_add a3 (wwl_shru (wwl_add a2 (wwl_shru (wwl_add a1 (wwl_shru a0 51)) 51)) 51)) 51))
          (Vector.replicate 8 2251799813685247#64))) (Vector.replicate 8 2251799813685247#64)⟩ := by
  rw [show normalize ⟨a0, a1, a2, a3, a4⟩ = passC (normPass ⟨a0, a1, a2, a3, a4⟩) from
    normPass_eq _, normPass_compiled]
  rfl

/-- Limbs 1 to 4 of every lane at most `2^52 - 2`, as `carry` leaves them: `normalize`'s first
pass and `neg` don't wrap. -/
def Carried (a : Fe) : Prop :=
  ∀ i : Fin 8, a.l1[i] ≤ 4503599627370494#64 ∧ a.l2[i] ≤ 4503599627370494#64 ∧
    a.l3[i] ≤ 4503599627370494#64 ∧ a.l4[i] ≤ 4503599627370494#64

/-- `Carried` of a `wwl_if` of two. -/
theorem Carried.ite {a b : Fe} (ha : Carried a) (hb : Carried b) (m : BitVec 32) :
    Carried (Fe.ite m a b) := by
  intro i
  simp only [Fe.ite, Fe.zipWith, wwl_if, Fin.getElem_fin, Vector.getElem_ofFn]
  obtain ⟨a1, a2, a3, a4⟩ := ha i
  obtain ⟨b1, b2, b3, b4⟩ := hb i
  refine ⟨?_, ?_, ?_, ?_⟩ <;> split <;> assumption

/-- Limb 1 of a `Carried` `wwl_if`, lane by lane. -/
theorem Carried.if_l1 {a b : Fe} (ha : Carried a) (hb : Carried b) (m : BitVec 32) :
    ∀ i : Fin 8, (wwl_if m a.l1 b.l1)[(i : Nat)] ≤ 4503599627370494#64 :=
  fun i => (ha.ite hb m i).1

/-- Limb 2 of a `Carried` `wwl_if`, lane by lane. -/
theorem Carried.if_l2 {a b : Fe} (ha : Carried a) (hb : Carried b) (m : BitVec 32) :
    ∀ i : Fin 8, (wwl_if m a.l2 b.l2)[(i : Nat)] ≤ 4503599627370494#64 :=
  fun i => (ha.ite hb m i).2.1

/-- Limb 3 of a `Carried` `wwl_if`, lane by lane. -/
theorem Carried.if_l3 {a b : Fe} (ha : Carried a) (hb : Carried b) (m : BitVec 32) :
    ∀ i : Fin 8, (wwl_if m a.l3 b.l3)[(i : Nat)] ≤ 4503599627370494#64 :=
  fun i => (ha.ite hb m i).2.2.1

/-- Limb 4 of a `Carried` `wwl_if`, lane by lane. -/
theorem Carried.if_l4 {a b : Fe} (ha : Carried a) (hb : Carried b) (m : BitVec 32) :
    ∀ i : Fin 8, (wwl_if m a.l4 b.l4)[(i : Nat)] ≤ 4503599627370494#64 :=
  fun i => (ha.ite hb m i).2.2.2

/-- A carry plus a limb at most `2^52 - 2`: no overflow either way. -/
theorem shr51_add_le_ok (a b : BitVec 64) (hb : b ≤ 4503599627370494#64) :
    (a >>> 51).saddOverflow b = false ∧ (a >>> 51).uaddOverflow b = false := by
  bv_decide

/-- `2^52 - 2` minus a limb at most that: no overflow either way. -/
theorem sub_le_ok (b : BitVec 64) (hb : b ≤ 4503599627370494#64) :
    (4503599627370494#64).ssubOverflow b = false ∧
      (4503599627370494#64).usubOverflow b = false := by
  bv_decide

/-- `normalize`'s first-pass `add nsw nuw` of a carry and a limb at most `2^52 - 2`. -/
theorem zipWith_add_shru_le (x y : Wwl) (hy : ∀ i : Fin 8, y[(i : Nat)] ≤ 4503599627370494#64) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (wwl_shru x 51)) (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add (wwl_shru x 51) y) :=
  zipWith_add_nsw_nuw_wwl _ _ fun i => by
    simpa [wwl_shru] using shr51_add_le_ok x[i] y[i] (hy i)

/-- `fd_ed25519_lane_neg`'s `sub nsw nuw` of a limb at most `2^52 - 2` from `2^52 - 2`. -/
theorem zipWith_sub_le (y : Wwl) (hy : ∀ i : Fin 8, y[(i : Nat)] ≤ 4503599627370494#64) :
    Vector.zipWith (Operation.sub { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) (Vector.replicate 8 4503599627370494#64))
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub (Vector.replicate 8 4503599627370494#64) y) := by
  ext i hi
  have := sub_le_ok y[i] (hy ⟨i, hi⟩)
  simp_all [Ty.wrap_vec, wwl_sub, Operation.sub]

/-- `neg` as compiled: `2p` limbwise as literals. -/
def negC (a : Fe) : Fe :=
  ⟨wwl_sub (Vector.replicate 8 4503599627370458#64) a.l0,
    wwl_sub (Vector.replicate 8 4503599627370494#64) a.l1,
    wwl_sub (Vector.replicate 8 4503599627370494#64) a.l2,
    wwl_sub (Vector.replicate 8 4503599627370494#64) a.l3,
    wwl_sub (Vector.replicate 8 4503599627370494#64) a.l4⟩

/-- `neg` is `negC`. -/
theorem neg_eq_negC (a : Fe) : neg a = negC a := by
  simp only [neg, negC, twoP, Fe.bcast2, Fe.zipWith, wwl_bcast]
  rfl

/-- `^bb41`'s stores into the point at `P`: `x`'s and `y`'s limbs, alternating. -/
def xyMem (m : MemoryState) (P : Pointer) (x y : Fe) : MemoryState :=
  let m := m.storeAt P (BitVec.packLanes x.l0)
  let m := m.storeAt (P.add 320#64) (BitVec.packLanes y.l0)
  let m := m.storeAt (P.add 64#64) (BitVec.packLanes x.l1)
  let m := m.storeAt (P.add 384#64) (BitVec.packLanes y.l1)
  let m := m.storeAt (P.add 128#64) (BitVec.packLanes x.l2)
  let m := m.storeAt (P.add 448#64) (BitVec.packLanes y.l2)
  let m := m.storeAt (P.add 192#64) (BitVec.packLanes x.l3)
  let m := m.storeAt (P.add 512#64) (BitVec.packLanes y.l3)
  let m := m.storeAt (P.add 256#64) (BitVec.packLanes x.l4)
  m.storeAt (P.add 576#64) (BitVec.packLanes y.l4)

/-- A carried limb: at most `2^52 - 2`. -/
theorem carried_lane (a b : BitVec 64) :
    (a &&& 2251799813685247#64) + b >>> 51 ≤ 4503599627370494#64 := by
  bv_decide

/-- `carry` leaves its limbs 1 to 4 `Carried`. -/
theorem Carried.carry (r : Fe) : Carried (carry r) := by
  intro i
  simp only [MLIR.Firedancer.Lane.carry, wwl_add, wwl_and, wwl_shru, wwl_bcast, mask51,
    Vector.getElem_ofFn, Vector.getElem_replicate, Fin.getElem_fin]
  exact ⟨carried_lane _ _, carried_lane _ _, carried_lane _ _, carried_lane _ _⟩

/-- A carried product is `Carried`. -/
theorem Carried.mul (a b : Fe) : Carried (mul a b) := by
  rw [mul_eq_carry]
  exact Carried.carry _

/-- The success mask's `zext` of its `i8`: the mask, which has no bits above 8. -/
theorem z8_isZero_or (a b : Fe) :
    BitVec.setWidth 32 (z8 (isZero a ||| isZero b)) = isZero a ||| isZero b := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  by_cases h8 : i < 8
  · simp [z8, h8, hi]
  · simp only [BitVec.getLsbD_or, isZero_getLsbD_of_ge _ (Nat.le_of_not_lt h8), Bool.or_false]
    simp [z8, h8]

/-- `decFin` with the success mask's operands as compiled and `neg` as `negC`. -/
theorem decFin_eq (Q : Fe) (sg : BitVec 32) (pre : DecPre) (x : Fe) :
    decFin Q sg pre x =
      let x1 := mul x pre.uv3
      let C := mul (sqr x1) pre.v
      let c := isZero (subRaw C pre.u)
      let f := isZero (addRaw C pre.u)
      let XT := Fe.ite (f &&& ~~~c) (mul x1 Q) x1
      let X2 := Fe.ite (f ||| c) (Fe.ite (sg ^^^ parityOf (normalize XT)) (negC XT) XT) Fe.zero
      let Y2 := Fe.ite (f ||| c) pre.y Fe.one
      (⟨X2, Y2, Fe.one, mul X2 Y2⟩, f ||| c) := by
  simp only [decFin, neg_eq_negC, parityOf, gePOf,
    BitVec.or_comm (isZero (subRaw (mul (sqr (mul x pre.uv3)) pre.v) pre.u))]

/-- A field element in another block than a store: the one before it. -/
theorem readFe_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {w : Nat} (x : BitVec w)
    (h : p.id ≠ q.id) : (m.storeAt p x).readFe q = m.readFe q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa [Pointer.add] using h
  simp only [MemoryState.readFe, MemoryState.readVec,
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h),
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (h' _))]

/-- `readFe_storeAt_of_id_ne` for a store at `p` plus an offset. -/
theorem readFe_storeAt_add_of_id_ne {m : MemoryState} {p q : Pointer} {w : Nat} (o : BitVec 64)
    (x : BitVec w) (h : p.id ≠ q.id) : (m.storeAt (p.add o) x).readFe q = m.readFe q :=
  readFe_storeAt_of_id_ne x (by simpa [Pointer.add] using h)

/-! ## The point's memory -/

section PointMem

variable {m : MemoryState} {P : Pointer}

/-- An offset inside a point's 1280 bytes, in bits. -/
theorem offsetInBits_add_le (hP : ¬P.offset.uaddOverflow 1280#64) {a : BitVec 64}
    (ha : a.toNat ≤ 1280) : (P.add a).offsetInBits = P.offsetInBits + 8 * a.toNat := by
  have hov : ¬P.offset.uaddOverflow a := BitVec.not_uaddOverflow_of_le hP (by simpa using ha)
  rw [Pointer.offsetInBits_add hov]
  omega

/-- Two ranges at offsets inside a point, apart. -/
theorem disjoint_add_le (hP : ¬P.offset.uaddOverflow 1280#64) {a b : BitVec 64} {wa wb : Nat}
    (ha : a.toNat ≤ 1280) (hb : b.toNat ≤ 1280)
    (h : 8 * a.toNat + wa ≤ 8 * b.toNat ∨ 8 * b.toNat + wb ≤ 8 * a.toNat) :
    (Range.of (P.add a) wa).Disjoint (Range.of (P.add b) wb) := by
  simp only [Range.Disjoint, Range.of, offsetInBits_add_le hP ha, offsetInBits_add_le hP hb]
  omega

/-- `disjoint_add_le` with the first range at the point's start. -/
theorem disjoint_base_le (hP : ¬P.offset.uaddOverflow 1280#64) {b : BitVec 64} {wa wb : Nat}
    (hb : b.toNat ≤ 1280) (h : wa ≤ 8 * b.toNat) :
    (Range.of P wa).Disjoint (Range.of (P.add b) wb) := by
  simp only [Range.Disjoint, Range.of, offsetInBits_add_le hP hb]
  omega

/-- `disjoint_base_le` the other way round. -/
theorem disjoint_le_base (hP : ¬P.offset.uaddOverflow 1280#64) {b : BitVec 64} {wa wb : Nat}
    (hb : b.toNat ≤ 1280) (h : wa ≤ 8 * b.toNat) :
    (Range.of (P.add b) wb).Disjoint (Range.of P wa) := by
  simp only [Range.Disjoint, Range.of, offsetInBits_add_le hP hb]
  omega

/-- Room inside a point's 1280 bytes. -/
theorem room_add_le (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) {a : BitVec 64}
    {w : Nat} (h : 8 * a.toNat + w ≤ 10240) : Room m (P.add a) w :=
  Room.add_of_le (BitVec.not_uaddOverflow_of_le hP (by simp; omega)) (by omega) hR

/-- The disjointness and room side conditions of reads through a point's stores. -/
macro "point_side" : tactic =>
  `(tactic|
    first
      | (refine disjoint_add_le ?_ ?_ ?_ ?_ <;> first | assumption | decide)
      | (refine disjoint_base_le ?_ ?_ ?_ <;> first | assumption | decide)
      | (refine disjoint_le_base ?_ ?_ ?_ <;> first | assumption | decide))

/-- `pointMem`'s `z` limbs past the first: zero. -/
theorem pointMem_readAt_z (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    (pointMem m P Y).readAt (P.add 704#64) 2048 = 0 := by
  unfold pointMem
  simp (disch := point_side) only [MemoryState.readAt_storeAt_disjoint]
  rw [MemoryState.readAt_storeAt_self]
  · rfl
  repeat apply Room.storeAt
  exact room_add_le hP hR (by decide)

/-- Room at a point survives the point's stores, both ways. -/
theorem room_pointMem_iff (Y : Fe) {q : Pointer} {w : Nat} :
    Room (pointMem m P Y) q w ↔ Room m q w := by
  simp only [pointMem, Room.storeAt_iff]

/-- `pointMem`'s `z` limbs past the first are known. -/
theorem pointMem_fits_z (hP : ¬P.offset.uaddOverflow 1280#64) (hR : Room m P 10240) (Y : Fe) :
    Fits (pointMem m P Y) (P.add 704#64) 2048 := by
  unfold pointMem
  iterate 6 apply Fits.storeAt
  exact Fits.storeAt_self (by (repeat apply Room.storeAt); exact room_add_le hP hR (by decide))

/-- A 512-bit limb inside zeroed 2048 bits: zero, and known. -/
theorem zero_limb {m : MemoryState} {q : Pointer} (hov : ¬q.offset.uaddOverflow 256#64)
    (hf : Fits m q 2048) (h : m.readAt q 2048 = 0) {o : BitVec 64} (ho : o.toNat * 8 + 512 ≤ 2048) :
    Fits m (q.add o) 512 ∧ m.readAt (q.add o) 512 = 0 := by
  have hov' : ¬q.offset.uaddOverflow o := BitVec.not_uaddOverflow_of_le hov (by simp; omega)
  refine ⟨Fits.add_of_le hov' ho hf, ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov' ho h]
  simp

end PointMem

/-! ## Registers -/

open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty) in
/-- The registers `fd_ed25519_lane_decode2` reads or keeps for later stages: `Env42`'s but the
masks, its own constants, `u`, `v`, `uv3`, `uv7`'s second halves and the `r_buf` pointers. -/
abbrev EnvD (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64,
    %25 := Ty.wrap
        #v[3934839304537#64, 507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64,
        309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64,
    %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64,
    %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32, %76 := PoisonOr.value 5#64,
    %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap
        #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32,
        14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
        2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
        (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
        (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %192 := PoisonOr.value (c.bufR 0),
    %222 := PoisonOr.value (c.bufR 1), %252 := PoisonOr.value (c.bufR 2),
    %424 := PoisonOr.value ((c.s.slot 18).add 320#64),
    %425 := PoisonOr.value ((c.s.slot 19).add 320#64),
    %426 := PoisonOr.value ((c.s.slot 20).add 320#64),
    %427 := PoisonOr.value ((c.s.slot 21).add 320#64), %428 := PoisonOr.value (c.candMask),
    %430 := PoisonOr.value (c.bufR 7), %432 := PoisonOr.value (c.bufR 5),
    %434 := PoisonOr.value (c.bufR 3), %435 := PoisonOr.value (c.bufR 4),
    %437 := PoisonOr.value (c.bufR 6)]

/-! ## Runs -/

/-- Eight `insertelement`s into the poison vector `p`, lane `k` from `ak` at index `ik`, into
`d0 … d7`. -/
def insert8Run (p : Dst Γ V) (i0 i1 i2 i3 i4 i5 i6 i7 a0 a1 a2 a3 a4 a5 a6 a7 : Dst Γ (.bv 64))
    (d0 d1 d2 d3 d4 d5 d6 d7 : Dst Γ V) : List (Instr Γ) :=
  [.ternop .insertelement d0 (.val p.i p.h) (.val a0.i a0.h) (.val i0.i i0.h),
    .ternop .insertelement d1 (.val d0.i d0.h) (.val a1.i a1.h) (.val i1.i i1.h),
    .ternop .insertelement d2 (.val d1.i d1.h) (.val a2.i a2.h) (.val i2.i i2.h),
    .ternop .insertelement d3 (.val d2.i d2.h) (.val a3.i a3.h) (.val i3.i i3.h),
    .ternop .insertelement d4 (.val d3.i d3.h) (.val a4.i a4.h) (.val i4.i i4.h),
    .ternop .insertelement d5 (.val d4.i d4.h) (.val a5.i a5.h) (.val i5.i i5.h),
    .ternop .insertelement d6 (.val d5.i d5.h) (.val a6.i a6.h) (.val i6.i i6.h),
    .ternop .insertelement d7 (.val d6.i d6.h) (.val a7.i a7.h) (.val i7.i i7.h)]

/-- Where the body at `pos` is `insert8Run` and `a0 … a7` hold `A0 … A7`: running on from `pos`
gives `K` if it does from `pos + 8` with the vector `A0 … A7` in `d7`. -/
theorem runBodyFrom_insert8Run {nb : Nat} {tRets : List Ty} {bp : Fin nb → List Ty}
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p : Dst Γ V} {i0 i1 i2 i3 i4 i5 i6 i7 a0 a1 a2 a3 a4 a5 a6 a7 : Dst Γ (.bv 64)}
    {d0 d1 d2 d3 d4 d5 d6 d7 : Dst Γ V} {rest : List (Instr Γ)}
    {A0 A1 A2 A3 A4 A5 A6 A7 : BitVec 64} {S : GlobalState} {β : Type}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        insert8Run p i0 i1 i2 i3 i4 i5 i6 i7 a0 a1 a2 a3 a4 a5 a6 a7 d0 d1 d2 d3 d4 d5 d6 d7 ++
            rest)
    (hR :
      E ⊨ [p := (Vector.replicate 8 PoisonOr.poison : ⟦V⟧), i0 := 0#64, i1 := 1#64, i2 := 2#64,
        i3 := 3#64, i4 := 4#64, i5 := 5#64, i6 := 6#64, i7 := 7#64, a0 := A0, a1 := A1,
        a2 := A2, a3 := A3, a4 := A4, a5 := A5, a6 := A6, a7 := A7])
    (hd :
      distinctB
          [d0.i.val, d1.i.val, d2.i.val, d3.i.val, d4.i.val, d5.i.val, d6.i.val, d7.i.val, p.i.val,
            i0.i.val, i1.i.val, i2.i.val, i3.i.val, i4.i.val, i5.i.val, i6.i.val, i7.i.val,
            a0.i.val, a1.i.val, a2.i.val, a3.i.val, a4.i.val, a5.i.val, a6.i.val, a7.i.val] =
        true)
    (hK :
      ∀ v0 v1 v2 v3 v4 v5 v6 : ⟦V⟧,
        (blk.runBodyFrom
              E[d0 := v0, d1 := v1, d2 := v2, d3 := v3, d4 := v4, d5 := v5, d6 := v6,
                d7 := Ty.wrap #v[A0, A1, A2, A3, A4, A5, A6, A7]] (pos + 8) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
      [d0.i, d1.i, d2.i, d3.i, d4.i, d5.i, d6.i, d7.i, p.i, i0.i, i1.i, i2.i, i3.i, i4.i, i5.i,
        i6.i, i7.i, a0.i, a1.i, a2.i, a3.i, a4.i, a5.i, a6.i, a7.i].Nodup :=
    nodup_of_distinctB hd
  iterate 8 step_pure
  rw [← insert8_wrap] at hK
  rw [hE]
  exact hK _ _ _ _ _ _ _

end

end MLIR.Firedancer.Lane.VerifyX8.Decode

module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.fd_ed25519_lane_small_order
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases

/-! The lanes of `verify_x8`'s checks: the vector operations the eight-lane loop runs, as raw lanes;
the mask bits it tests; `live` as the loops collect it. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref

@[expose] public section

/-! ### Vector operations on known lanes -/

section Lanes

variable {n w : Nat}

theorem zipWith_and_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.and (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n w) (Vector.ofFn fun i => x[i] &&& y[i]) := by
  ext i hi; simp [Ty.wrap_vec, Operation.and]

theorem zipWith_or_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.or false (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n w) (Vector.ofFn fun i => x[i] ||| y[i]) := by
  ext i hi; simp [Ty.wrap_vec, Operation.or]

theorem zipWith_xor_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.xor (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n w) (Vector.ofFn fun i => x[i] ^^^ y[i]) := by
  ext i hi; simp [Ty.wrap_vec, Operation.xor]

theorem zipWith_add_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.add {} (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n w) (Vector.ofFn fun i => x[i] + y[i]) := by
  ext i hi; simp [Ty.wrap_vec, Operation.add]

theorem zipWith_icmp_eq_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.icmp .eq (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n 1) (Vector.ofFn fun i => BitVec.ofBool (x[i] == y[i])) := by
  ext i hi; simp [Ty.wrap_vec, Operation.icmp]

theorem zipWith_icmp_ne_wrap (x y : Vector (BitVec w) n) :
    Vector.zipWith (Operation.icmp .ne (w := w)) (Ty.wrap (t := .vec n w) x)
        (Ty.wrap (t := .vec n w) y) =
      Ty.wrap (t := .vec n 1) (Vector.ofFn fun i => BitVec.ofBool (x[i] != y[i])) := by
  ext i hi; simp [Ty.wrap_vec, Operation.icmp]

end Lanes

/-- `j`'s lane indices: `0 … 7` past a disjoint `or` with zero. -/
theorem or_lanes8 :
    Vector.zipWith (Operation.or true (w := 32))
        (Ty.wrap (t := .vec 8 32) #v[0#32, 0#32, 0#32, 0#32, 0#32, 0#32, 0#32, 0#32])
        (Ty.wrap (t := .vec 8 32) #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32]) =
      Ty.wrap (t := .vec 8 32) #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32] := by
  ext i hi
  interval_cases i <;> simp [Ty.wrap_vec, Operation.or]

/-- `1 << j` in lane `j`. -/
theorem shl_lanes8 (f : OverflowFlags) :
    Vector.zipWith (Operation.shl f (w := 32)) (Ty.wrap (t := .vec 8 32) (Vector.replicate 8 1#32))
        (Ty.wrap (t := .vec 8 32) #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32]) =
      Ty.wrap (t := .vec 8 32) #v[1#32, 2#32, 4#32, 8#32, 16#32, 32#32, 64#32, 128#32] := by
  ext i hi
  rcases f with ⟨_ | _, _ | _⟩ <;> interval_cases i <;> simp [Ty.wrap_vec, Operation.shl]

/-- The eight-lane loop's `live` before its first iteration: lane 0 set to zero. -/
theorem live0_lanes8 (h0 h1 h2 h3 h4 h5 h6 h7) :
    ((((((((Vector.replicate 8 (PoisonOr.poison : PoisonOr (BitVec 32))).set 1 (.value 0#32)
                                h1).set 2 (.value 0#32) h2).set 3 (.value 0#32) h3).set 4
                    (.value 0#32) h4).set 5 (.value 0#32) h5).set 6 (.value 0#32) h6).set 7
            (.value 0#32) h7).set 0 (.value 0#32) h0 =
      Ty.wrap (t := .vec 8 32) (Vector.replicate 8 0#32) := by
  ext i hi
  interval_cases i <;> simp [Ty.wrap_vec]

theorem ite_value {p : Prop} [Decidable p] {a b : BitVec w} :
    (if p then PoisonOr.value a else PoisonOr.value b) = PoisonOr.value (if p then a else b) := by
  split <;> rfl

/-! ### `i1` lanes as `Bool`s -/

theorem ofBool_eq_one (b : Bool) : (BitVec.ofBool b = 1#1) = (b = true) := by
  cases b <;> decide

theorem ite_ofBool (c : Prop) [Decidable c] (x y : Bool) :
    (if c then BitVec.ofBool x else BitVec.ofBool y) = BitVec.ofBool (if c then x else y) := by
  split <;> rfl

theorem ite_ofBool_zero (c : Prop) [Decidable c] (x : Bool) :
    (if c then BitVec.ofBool x else 0#1) = BitVec.ofBool (decide c && x) := by
  by_cases h : c <;> simp [h]

theorem ite_one_ofBool (c : Prop) [Decidable c] (y : Bool) :
    (if c then 1#1 else BitVec.ofBool y) = BitVec.ofBool (decide c || y) := by
  by_cases h : c <;> simp [h]

theorem ofBool_xor_one (x : Bool) : BitVec.ofBool x ^^^ 1#1 = BitVec.ofBool (!x) := by
  cases x <;> decide

/-! ### Mask bits -/

/-- Bit `j` of a mask as the code tests it: `1 << j & x`, zero or not. -/
theorem and_bit_iff (x : BitVec 32) {j : Nat} (hj : j < 32) :
    (1#32 <<< j &&& x = 0#32 ↔ x.getLsbD j = false) := by
  constructor
  · intro h
    have := congrArg (·.getLsbD j) h
    simpa [hj] using this
  · intro h
    apply BitVec.eq_of_getLsbD_eq
    intro k hk
    by_cases hkj : k = j
    · subst hkj; simp [h]
    · simp only [BitVec.getLsbD_and, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_zero]
      simp
      intros
      omega

theorem and_bit0 (x : BitVec 32) :
    ((1#32 &&& x = 0#32) = (x.getLsbD 0 = false)) ∧ ((1#32 &&& x == 0#32) = !x.getLsbD 0) ∧
      ((1#32 &&& x != 0#32) = x.getLsbD 0) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit1 (x : BitVec 32) :
    ((2#32 &&& x = 0#32) = (x.getLsbD 1 = false)) ∧ ((2#32 &&& x == 0#32) = !x.getLsbD 1) ∧
      ((2#32 &&& x != 0#32) = x.getLsbD 1) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit2 (x : BitVec 32) :
    ((4#32 &&& x = 0#32) = (x.getLsbD 2 = false)) ∧ ((4#32 &&& x == 0#32) = !x.getLsbD 2) ∧
      ((4#32 &&& x != 0#32) = x.getLsbD 2) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit3 (x : BitVec 32) :
    ((8#32 &&& x = 0#32) = (x.getLsbD 3 = false)) ∧ ((8#32 &&& x == 0#32) = !x.getLsbD 3) ∧
      ((8#32 &&& x != 0#32) = x.getLsbD 3) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit4 (x : BitVec 32) :
    ((16#32 &&& x = 0#32) = (x.getLsbD 4 = false)) ∧ ((16#32 &&& x == 0#32) = !x.getLsbD 4) ∧
      ((16#32 &&& x != 0#32) = x.getLsbD 4) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit5 (x : BitVec 32) :
    ((32#32 &&& x = 0#32) = (x.getLsbD 5 = false)) ∧ ((32#32 &&& x == 0#32) = !x.getLsbD 5) ∧
      ((32#32 &&& x != 0#32) = x.getLsbD 5) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit6 (x : BitVec 32) :
    ((64#32 &&& x = 0#32) = (x.getLsbD 6 = false)) ∧ ((64#32 &&& x == 0#32) = !x.getLsbD 6) ∧
      ((64#32 &&& x != 0#32) = x.getLsbD 6) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩
theorem and_bit7 (x : BitVec 32) :
    ((128#32 &&& x = 0#32) = (x.getLsbD 7 = false)) ∧ ((128#32 &&& x == 0#32) = !x.getLsbD 7) ∧
      ((128#32 &&& x != 0#32) = x.getLsbD 7) := by
  refine ⟨propext (by bv_decide), by bv_decide, by bv_decide⟩

/-- `1 << i` shifted back, for an item `i < 8`: `shl nuw` keeps it. -/
theorem one_shl_shr {i : Nat} (hi : i < 8) : 1#32 <<< i >>> i = 1#32 := by
  revert i; decide

/-- Lane `j` of a 1-bit-lane `packLanes`. -/
theorem getLsbD_packLanes_bit (V : Vector (BitVec 1) n) {j : Nat} (hj : j < n) :
    (BitVec.packLanes V).getLsbD j = (V[j]).getLsbD 0 := by
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt V (s := j) (w := 1) (by simpa using hj) (by omega))
  simp only [Nat.div_one, Nat.mod_one, BitVec.getLsbD_extractLsb', Nat.lt_one_iff, decide_true,
    Bool.true_and, Nat.add_zero] at h
  exact h

/-- Bit `j` of `maskOf f`: `f j`, none past the lanes. -/
theorem getLsbD_maskOf (f : Fin 8 → Bool) (j : Nat) :
    (maskOf f).getLsbD j = if h : j < 8 then f ⟨j, h⟩ else false := by
  rw [maskOf, BitVec.getLsbD_setWidth]
  split
  · rename_i h
    rw [getLsbD_packLanes_bit _ (by omega)]
    have : j < 32 := by omega
    simp [this]
  · rename_i h
    rw [BitVec.getLsbD_of_ge _ _ (by omega)]
    simp

/-- `candidates`' bit `j`: item `j` a candidate. -/
theorem Call.getLsbD_candMask (c : Call) {j : Nat} (h : j < 8) :
    c.candMask.getLsbD j = c.X.cand ⟨j, h⟩ := by
  simp [Call.candMask, getLsbD_maskOf, h]

/-- A live item is a candidate, valid both ways, of neither small order. -/
theorem Call.live_eq (c : Call) (j : Fin 8) :
    c.X.live j =
      (c.X.cand j && c.X.aValid.getLsbD j && c.X.rValid.getLsbD j && !c.X.aSmall.getLsbD j &&
        !c.X.rSmall.getLsbD j) :=
  rfl

/-- A candidate is an item. -/
theorem Call.lt_of_cand {c : Call} {j : Fin 8} (h : c.X.cand j = true) : j.val < c.cnt := by
  have : c.X.cand j = x8Cand c.cnt c.S j := rfl
  simp only [this, x8Cand, Bool.and_eq_true, decide_eq_true_eq] at h
  exact h.1

/-- The eight lanes of `results` have room and do not wrap. -/
theorem Call.room_lanes {c : Call} (hc : c.Ok) (hcnt : c.cnt = 8) {m : MemoryState}
    (hm : ∀ j < c.cnt, Room m (c.a.result j) 32) (M : Vector (BitVec 1) 8) :
    ∀ i : Fin 8, M[i] = 1#1 →
      c.a.results.offset.toNat + i * (32 / 8) < 2 ^ 64 ∧
        Room m (Operation.lanePtr c.a.results 32 i) 32 := by
  intro i _
  have := hc.batch.off.2.2.2.2.2
  exact ⟨by omega, hm i (by omega)⟩

/-! ### `live` -/

/-- `live` past items `j < i`, bit `j` for a live item `j`, as the scalar loop collects it. -/
noncomputable def Call.liveUpTo (c : Call) : Nat → BitVec 32
  | 0 => 0#32
  | i + 1 => (if c.X.liveAt i then 1#32 <<< i else 0#32) ||| c.liveUpTo i

theorem Call.getLsbD_liveUpTo (c : Call) {i : Nat} (hi : i ≤ 8) (k : Nat) :
    (c.liveUpTo i).getLsbD k = (decide (k < i) && c.X.liveAt k) := by
  induction i with
  | zero => simp [Call.liveUpTo]
  | succ i ih =>
    rw [Call.liveUpTo, BitVec.getLsbD_or, ih (by omega)]
    by_cases hk : k = i
    · subst hk
      split <;> simp_all [show k < 32 by omega]
    · have : k < i + 1 ↔ k < i := by omega
      split
      · simp only [this, BitVec.getLsbD_shiftLeft]
        simp
        intros
        omega
      · simp [this]

/-- All items' `live` bits: `live`. -/
theorem Call.liveUpTo_cnt {c : Call} (hc : c.Ok) : c.liveUpTo c.cnt = c.liveMask := by
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  rw [c.getLsbD_liveUpTo hc.cnt8, Call.liveMask, getLsbD_maskOf, X8.liveAt]
  split
  · rename_i h8
    by_cases hl : c.X.live ⟨k, h8⟩
    · have hcd : c.X.cand ⟨k, h8⟩ = true := by
        have h := hl
        rw [Call.live_eq] at h
        simp only [Bool.and_eq_true] at h
        exact h.1.1.1.1
      have : k < c.cnt := Call.lt_of_cand hcd
      simp [this, hl]
    · simp [hl]
  · simp

/-! ### The eight-lane loop's lanes -/

/-- Lane `k`'s code past the three masked stores: `code1 k`. -/
theorem Call.code1_lane (c : Call) (k : Nat) (hk : k < 8) :
    (if BitVec.ofBool (c.candMask[k]'(by omega) && !c.X.aValid[k]'(by omega)) = 1#1 then
        4294967294#32
      else if
          BitVec.ofBool
              (c.candMask[k]'(by omega) && c.X.aValid[k]'(by omega) &&
                !c.X.rValid[k]'(by omega)) = 1#1 then 4294967295#32
      else if
          BitVec.ofBool
              (c.candMask[k]'(by omega) && c.X.aValid[k]'(by omega) && c.X.rValid[k]'(by omega) &&
                c.X.aSmall[k]'(by omega)) = 1#1 then 4294967294#32
      else errSig) = c.code1 k := by
  have hcm := c.getLsbD_candMask hk
  simp only [← BitVec.getLsbD_eq_getElem, hcm, Call.code1, hk, dite_true]
  cases c.X.cand ⟨k, hk⟩ <;> cases c.X.aValid.getLsbD k <;> cases c.X.rValid.getLsbD k <;>
    cases c.X.aSmall.getLsbD k <;> rfl

/-- Lane `k`'s `live` test in the eight-lane loop. -/
abbrev Call.liveP (c : Call) (k : Nat) (hk : k < 8) : Prop :=
  (c.candMask[k]'(by omega) = true ∧
        (((c.candMask[k]'(by omega) = false ∨ c.X.aValid[k]'(by omega) = false) ∨
              c.X.rValid[k]'(by omega) = true) ∧
            (((c.candMask[k]'(by omega) = false ∨ c.X.aValid[k]'(by omega) = false) ∨
                c.X.rValid[k]'(by omega) = false) ∨ c.X.aSmall[k]'(by omega) = false)) ∧
        (c.candMask[k]'(by omega) = false ∨ c.X.aValid[k]'(by omega) = true)) ∧
    c.X.rSmall[k]'(by omega) = false

/-- Lane `k`'s `live` test: item `k` live. -/
theorem Call.live_lane (c : Call) (k : Nat) (hk : k < 8) :
    c.liveP k hk ↔ c.X.live ⟨k, hk⟩ = true := by
  have hcm := c.getLsbD_candMask hk
  simp only [Call.liveP, ← BitVec.getLsbD_eq_getElem, hcm, Call.live_eq]
  cases c.X.cand ⟨k, hk⟩ <;> cases c.X.aValid.getLsbD k <;> cases c.X.rValid.getLsbD k <;>
    cases c.X.aSmall.getLsbD k <;> cases c.X.rSmall.getLsbD k <;> decide

/-- The OR of lane `j`'s bit where `p j`: the mask of `f`, `p j` meaning `f j`. -/
theorem or_lanes_maskOf (f : Fin 8 → Bool) (p : Fin 8 → Prop) [∀ j, Decidable (p j)]
    (hp : ∀ j, p j ↔ f j = true) :
    ((((((((if p 0 then 1#32 else 0#32) ||| if p 1 then 2#32 else 0#32) |||
                    if p 2 then 4#32 else 0#32) ||| if p 3 then 8#32 else 0#32) |||
                if p 4 then 16#32 else 0#32) ||| if p 5 then 32#32 else 0#32) |||
            if p 6 then 64#32 else 0#32) ||| if p 7 then 128#32 else 0#32) =
      maskOf f := by
  simp only [hp]
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  rw [getLsbD_maskOf]
  simp only [BitVec.getLsbD_or, apply_ite (BitVec.getLsbD · k)]
  interval_cases k <;> simp

end

end MLIR.Firedancer.Lane.VerifyX8

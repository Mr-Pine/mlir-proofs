module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! The `<4 x i64>` instructions as the `wl_t` operations they are, for the steps: lane-wise binary
operations, `vpmadd52`, the byte view of `pblendvb`, and the no-overflow facts of
`FD_R52X5_QUAD_REDUCE`'s flagged adds. The lanes are typed `⟦.vec 4 64⟧ᵣ`, as the steps' values
are. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

open Firedancer.Avx512 (madd52lo madd52hi)

/-- A load of a `<4 x i64>` as the steps give it: `readWv`. -/
theorem ofFn_extractVecElem_readAt {m : MemoryState} :
    (Vector.ofFn fun i => Ty.extractVecElem 4 64 i (m.readAt p 256)) = m.readWv p :=
  rfl

/-! ### Lane-wise operations -/

theorem zipWith_and_wl (x y : ⟦.vec 4 64⟧ᵣ) :
    Vector.zipWith (Operation.and (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (wl_and x y) := by
  ext i hi
  simp [Ty.wrap_vec, wl_and, Operation.and]

theorem zipWith_add_wl (x y : ⟦.vec 4 64⟧ᵣ) :
    Vector.zipWith (Operation.add {} (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (wl_add x y) := by
  ext i hi
  simp [Ty.wrap_vec, wl_add, Operation.add]

theorem zipWith_sub_wl (x y : ⟦.vec 4 64⟧ᵣ) :
    Vector.zipWith (Operation.sub {} (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (wl_sub x y) := by
  ext i hi
  simp [Ty.wrap_vec, wl_sub, Operation.sub]

/-- `add nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_add_nsw_nuw_wl (x y : ⟦.vec 4 64⟧ᵣ)
    (h : ∀ i : Fin 4, x[i].saddOverflow y[i] = false ∧ x[i].uaddOverflow y[i] = false) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) x) (Ty.wrap (t := .vec 4 64) y) =
      Ty.wrap (t := .vec 4 64) (wl_add x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wl_add, Operation.add]

/-- A logical right shift by a splat below 64. -/
theorem zipWith_lshr_wl (x : ⟦.vec 4 64⟧ᵣ) (hn : n < 64) :
    Vector.zipWith (Operation.lshr false (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) (Vector.replicate 4 (BitVec.ofNat 64 n))) =
      Ty.wrap (t := .vec 4 64) (wl_shru x n) := by
  ext i hi
  have hn' : (BitVec.ofNat 64 n).toNat = n := by
    simp; omega
  simp [Ty.wrap_vec, wl_shru, Operation.lshr, hn', Nat.not_le.mpr hn]

/-- A left shift by a splat below 64. -/
theorem zipWith_shl_wl (x : ⟦.vec 4 64⟧ᵣ) (hn : n < 64) :
    Vector.zipWith (Operation.shl {} (w := 64)) (Ty.wrap (t := .vec 4 64) x)
        (Ty.wrap (t := .vec 4 64) (Vector.replicate 4 (BitVec.ofNat 64 n))) =
      Ty.wrap (t := .vec 4 64) (wl_shl x n) := by
  ext i hi
  have hn' : (BitVec.ofNat 64 n).toNat = n := by
    simp; omega
  simp [Ty.wrap_vec, wl_shl, Operation.shl, hn', Nat.not_le.mpr hn]

theorem vpmadd52l_wl (a b c : ⟦.vec 4 64⟧ᵣ) :
    Operation.vpmadd52l (Ty.wrap (t := .vec 4 64) a) (Ty.wrap (t := .vec 4 64) b)
        (Ty.wrap (t := .vec 4 64) c) =
      Ty.wrap (t := .vec 4 64) (wl_madd52lo a b c) := by
  ext i hi
  simp [Ty.wrap_vec, wl_madd52lo, madd52lo, Operation.vpmadd52l]

theorem vpmadd52h_wl (a b c : ⟦.vec 4 64⟧ᵣ) :
    Operation.vpmadd52h (Ty.wrap (t := .vec 4 64) a) (Ty.wrap (t := .vec 4 64) b)
        (Ty.wrap (t := .vec 4 64) c) =
      Ty.wrap (t := .vec 4 64) (wl_madd52hi a b c) := by
  ext i hi
  simp [Ty.wrap_vec, wl_madd52hi, madd52hi, Operation.vpmadd52h]

/-- An `extractelement` at a literal lane. -/
theorem extractelement_wl (v : ⟦.vec 4 64⟧ᵣ) (hk : k < 4) :
    Operation.extractelement (Ty.wrap (t := .vec 4 64) v)
        (.value (BitVec.ofNat 64 k) : PoisonOr (BitVec 64)) =
      .value (v[k]'hk) := by
  have hk' : (BitVec.ofNat 64 k).toNat = k := by
    simp; omega
  simp [Operation.extractelement, hk', hk, Ty.wrap_vec]

/-! ### `FD_R52X5_QUAD_REDUCE`'s flagged adds -/

/-- Low 51 bits plus a carry above bit 51: no overflow either way. -/
theorem mask51_add_shr51 (a b : BitVec 64) :
    (a &&& 2251799813685247#64).saddOverflow (b >>> 51) = false ∧
      (a &&& 2251799813685247#64).uaddOverflow (b >>> 51) = false := by
  bv_decide

/-- `mask51_add_shr51` on lanes, as `zipWith_add_nsw_nuw_wl` takes it. -/
theorem wl_and_add_shru_ok (x y : Wl) :
    ∀ i : Fin 4,
      (wl_and x (Vector.replicate 4 2251799813685247#64))[i].saddOverflow (wl_shru y 51)[i] =
          false ∧
        (wl_and x (Vector.replicate 4 2251799813685247#64))[i].uaddOverflow (wl_shru y 51)[i] =
          false := by
  intro i
  simpa [wl_and, wl_shru] using mask51_add_shr51 x[i] y[i]

/-- `FD_R52X5_QUAD_REDUCE`'s `wl_add( wl_and( s, mask ), c )` as compiled, an `add nsw nuw`. -/
theorem zipWith_add_nsw_nuw_reduce (x y : Wl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 4 64) (wl_and x (Vector.replicate 4 2251799813685247#64)))
        (Ty.wrap (t := .vec 4 64) (wl_shru y 51)) =
      Ty.wrap (t := .vec 4 64)
        (wl_add (wl_and x (Vector.replicate 4 2251799813685247#64)) (wl_shru y 51)) :=
  zipWith_add_nsw_nuw_wl _ _ (wl_and_add_shru_ok x y)

/-- A top carry times 19: no overflow either way (`fd_r52x5_reduce`'s `19 * q`). -/
theorem shr51_mul19 (a : BitVec 64) :
    (a >>> 51).smulOverflow 19#64 = false ∧ (a >>> 51).umulOverflow 19#64 = false := by bv_decide

/-! ### `pblendvb` on a `wc_bcast_wide` mask -/

/-- The 32 bytes of a `wl_t`, as a `bitcast` to `<32 x i8>` gives them. -/
def wlBytes (v : Wl) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun k => (v[k.val / 8]'(by omega)).extractLsb' (8 * (k.val % 8)) 8

/-- `wlBytes` lane by lane, as a `bitcast` step leaves it: rewrite a step's value back with it. -/
theorem wlBytes_eq (v : Wl) :
    wlBytes v =
      #v[v[0].extractLsb' 0 8, v[0].extractLsb' 8 8, v[0].extractLsb' 16 8, v[0].extractLsb' 24 8,
        v[0].extractLsb' 32 8, v[0].extractLsb' 40 8, v[0].extractLsb' 48 8, v[0].extractLsb' 56 8,
        v[1].extractLsb' 0 8, v[1].extractLsb' 8 8, v[1].extractLsb' 16 8, v[1].extractLsb' 24 8,
        v[1].extractLsb' 32 8, v[1].extractLsb' 40 8, v[1].extractLsb' 48 8, v[1].extractLsb' 56 8,
        v[2].extractLsb' 0 8, v[2].extractLsb' 8 8, v[2].extractLsb' 16 8, v[2].extractLsb' 24 8,
        v[2].extractLsb' 32 8, v[2].extractLsb' 40 8, v[2].extractLsb' 48 8, v[2].extractLsb' 56 8,
        v[3].extractLsb' 0 8, v[3].extractLsb' 8 8, v[3].extractLsb' 16 8, v[3].extractLsb' 24 8,
        v[3].extractLsb' 32 8, v[3].extractLsb' 40 8, v[3].extractLsb' 48 8,
        v[3].extractLsb' 56 8] := by
  simp only [wlBytes, expandOfFn, Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul]

/-- Byte `k` of packed lanes: its slice of lane `k / 8`. -/
theorem extractLsb'_packLanes_byte (v : Wl) (hk : k < 32) :
    (BitVec.packLanes v).extractLsb' (k * 8) 8 =
      (v[k / 8]'(by omega)).extractLsb' (8 * (k % 8)) 8 := by
  rw [BitVec.extractLsb'_packLanes_of_lt v (by omega) (by omega)]
  have e1 : k * 8 / 64 = k / 8 := by omega
  have e2 : k * 8 % 64 = 8 * (k % 8) := by omega
  simp only [e1, e2]

theorem bitcast_wlBytes (v : ⟦.vec 4 64⟧ᵣ) (h : (Ty.vec 4 64).width = (Ty.vec 32 8).width) :
    Operation.bitcast h (Ty.wrap (t := .vec 4 64) v) = Ty.wrap (t := .vec 32 8) (wlBytes v) := by
  ext k hk
  simp only [Operation.bitcast, Ty.wrap_vec, Vector.getElem_ofFn, Vector.getElem_map]
  have hp : Operation.bitcastPoison (v.map PoisonOr.value) 64 8 k = false := by
    simp [Operation.bitcastPoison]
  rw [Vector.map_map]
  simp only [Function.comp_def, PoisonOr.getValue_value, Vector.map_id', hp, Operation.poisonIf,
    wlBytes, Vector.getElem_ofFn, extractLsb'_packLanes_byte v hk, Bool.cond_false]

/-- `-c` in both halves, for `c` 0 or 1: its byte's top bit is whether `c = 1`. -/
theorem wcLane_msb {c : BitVec 32} (hc : c = 0 ∨ c = 1) (hj : j < 8) :
    (((-c) ++ (-c)).extractLsb' (8 * j) 8).msb = (c == 1) := by
  rcases hc with rfl | rfl <;> revert j <;> decide

theorem pblendvb_wcBcast {c0 c1 c2 c3 : BitVec 32} (h0 : c0 = 0 ∨ c0 = 1) (h1 : c1 = 0 ∨ c1 = 1)
    (h2 : c2 = 0 ∨ c2 = 1) (h3 : c3 = 0 ∨ c3 = 1) (x y : Wl) :
    Operation.pblendvb (Ty.wrap (t := .vec 32 8) (wlBytes y)) (Ty.wrap (t := .vec 32 8) (wlBytes x))
        (Ty.wrap (t := .vec 32 8) (wlBytes (wcBcast c0 c1 c2 c3))) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wlBlend (c0 == 1) (c1 == 1) (c2 == 1) (c3 == 1) x y)) := by
  ext k hk
  simp only [Operation.pblendvb, Ty.wrap_vec, Vector.getElem_ofFn, Fin.getElem_fin,
    Vector.getElem_map, PoisonOr.value_bind, wlBytes]
  have hj : k % 8 < 8 := Nat.mod_lt _ (by decide)
  obtain h | h | h | h : k / 8 = 0 ∨ k / 8 = 1 ∨ k / 8 = 2 ∨ k / 8 = 3 := by omega
  all_goals
    simp only [h, wcBcast, wlBlend, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
  · rw [wcLane_msb h0 hj]; cases c0 == 1 <;> rfl
  · rw [wcLane_msb h1 hj]; cases c1 == 1 <;> rfl
  · rw [wcLane_msb h2 hj]; cases c2 == 1 <;> rfl
  · rw [wcLane_msb h3 hj]; cases c3 == 1 <;> rfl

/-- A `wl_t`'s bytes, packed: its bits. -/
theorem packLanes_wlBytes (v : Wl) :
    BitVec.packLanes (wlBytes v) = (BitVec.packLanes v).cast (by decide) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hb :=
    congrArg (fun y => y.getLsbD (i % 8))
      (BitVec.extractLsb'_packLanes (wlBytes v) (i / 8) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show i % 8 < 8 by omega, decide_true, Bool.true_and,
    show i / 8 * 8 + i % 8 = i by omega] at hb
  rw [hb, BitVec.getLsbD_cast, BitVec.getLsbD_packLanes_wl v (by omega)]
  simp only [wlBytes, Vector.getElem_ofFn, BitVec.getLsbD_extractLsb', show i % 8 < 8 by omega,
    decide_true, Bool.true_and]
  have e1 : i / 8 / 8 = i / 64 := by omega
  have e2 : 8 * (i / 8 % 8) + i % 8 = i % 64 := by omega
  simp only [e1, e2]

/-- A store of a `wl_t`'s bytes: `storeWv`. -/
theorem MemoryState.storeAt_packLanes_wlBytes {m : MemoryState} :
    m.storeAt p (BitVec.packLanes (wlBytes v)) = m.storeWv p v := by
  rw [packLanes_wlBytes, MemoryState.storeAt_cast]
  rfl

end

end MLIR.Firedancer.R52x5

module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.R52x5.fd_f25519_fold_unsigned
public import Firedancer.R52x5.Mlir.fd_f25519_mul
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-- A broadcast lane by lane. -/
local macro "bcast_lanes" : tactic =>
  `(tactic| (apply vec_ext_fin; intro i; fin_cases i <;> simp [wwl_permute, wwl_bcast]))

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_mul`'s `z`: the column sums `zl` and `zh` of the rows `t0 … t5`, folded by
`za + 19 zb`. -/
@[irreducible]
def fd_f25519_mul.z (a b : Wwl) : Wwl :=
  let zero := wwl_zero
  let ax := a
  let x0 := wwl_permute (wwl_bcast 0) ax
  let x1 := wwl_permute (wwl_bcast 1) ax
  let x2 := wwl_permute (wwl_bcast 2) ax
  let x3 := wwl_permute (wwl_bcast 3) ax
  let x4 := wwl_permute (wwl_bcast 4) ax
  let y := b
  let t0 := wwl_madd52lo zero x0 y
  let t1 := wwl_madd52lo (wwl_shl (wwl_madd52hi zero x0 y) 1) x1 y
  let t2 := wwl_madd52lo (wwl_shl (wwl_madd52hi zero x1 y) 1) x2 y
  let t3 := wwl_madd52lo (wwl_shl (wwl_madd52hi zero x2 y) 1) x3 y
  let t4 := wwl_madd52lo (wwl_shl (wwl_madd52hi zero x3 y) 1) x4 y
  let t5 := wwl_shl (wwl_madd52hi zero x4 y) 1
  let p0j := t0
  let p1j := wwl_slide zero t1 7
  let p2j := wwl_slide zero t2 6
  let p3j := wwl_slide zero t3 5
  let p4j := wwl_slide zero t4 4
  let q4j := wwl_slide t4 zero 4
  let p5j := wwl_slide zero t5 3
  let q5j := wwl_slide t5 zero 3
  let zl := wwl_add (wwl_add (wwl_add p0j p1j) (wwl_add p2j p3j)) (wwl_add p4j p5j)
  let zh := wwl_add q4j q5j
  let za := wwl_and zl (wwl (-1) (-1) (-1) (-1) (-1) 0 0 0)
  let zb := wwl_slide zl zh 5
  wwl_add (wwl_add za zb) (wwl_add (wwl_shl zb 1) (wwl_shl zb 4))

/-- `fd_f25519_mul(r, a, b)`'s element: `fd_f25519_fold_unsigned(z)`. -/
@[irreducible]
def fd_f25519_mul.spec (a b : Wwl) : Wwl :=
  fold (fd_f25519_mul.z a b)

end

/-! ## Lanes as the steps give them -/

@[expose] public section

/-- Lanes `0 … 4` of a `<5 x i64>` load: the element's first five lanes. -/
theorem ofFn_extractVecElem_readAt_320 (m : MemoryState) (p : Pointer) :
    (Vector.ofFn fun i : Fin 5 => Ty.extractVecElem 5 64 i (m.readAt p 320)) =
      #v[(m.readVec p)[0], (m.readVec p)[1], (m.readVec p)[2], (m.readVec p)[3],
        (m.readVec p)[4]] := by
  rw [MemoryState.readAt_of_readAt_le (show 320 ≤ 512 by decide) rfl]
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp [MemoryState.readVec, Ty.extractVecElem_eq] <;>
    rw [BitVec.extractLsb'_setWidth_of_le (by decide)]

/-- A `<8 x i64>` load: `readVec`. -/
theorem ofFn_extractVecElem_readAt_512 (m : MemoryState) (p : Pointer) :
    (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i (m.readAt p 512)) = m.readVec p :=
  rfl

/-- `wwl_madd52hi(wwl_zero(), x, y)` as a step gives it. -/
theorem ofFn_madd52hi (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        BitVec.setWidth 64
          (((BitVec.setWidth 128 x[i.1] &&& 4503599627370495#128) *
              (BitVec.setWidth 128 y[i.1] &&& 4503599627370495#128)) >>>
            52)) =
      wwl_madd52hi wwl_zero x y := by
  ext i hi : 1; simp [wwl_madd52hi, madd52hi]

/-- `wwl_madd52lo(a, x, y)` as a step gives it. -/
theorem ofFn_madd52lo (a x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        a[i.1] +
          ((x[i.1] &&& 4503599627370495#64) * (y[i.1] &&& 4503599627370495#64) &&&
            4503599627370495#64)) =
      wwl_madd52lo a x y := by
  ext i hi : 1; simp [wwl_madd52lo, madd52lo]

/-- The accumulator of `wwl_madd52lo` as an add. -/
theorem wwl_madd52lo_eq_add (a x y : Wwl) :
    wwl_madd52lo a x y = wwl_add (wwl_madd52lo wwl_zero x y) a := by
  ext i hi : 1; simp [wwl_add, wwl_madd52lo]; ac_rfl

/-- `za`: lanes `0 … 4` of `zl`. -/
theorem ofFn_and_mask5 (x : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        x[i.1] &&&
          [18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64,
              18446744073709551615#64, 18446744073709551615#64, 0#64, 0#64, 0#64][i.1]) =
      wwl_and x (wwl (-1) (-1) (-1) (-1) (-1) 0 0 0) := by
  apply vec_ext_fin; intro i; fin_cases i <;> simp [wwl_and, wwl]

/-- `zb`: `zl`'s lanes `5 … 7`, then `zh`'s `0 … 4`. -/
theorem wrap_slide_5 (x y : Wwl) :
    #v[.value x[5], .value x[6], .value x[7], .value y[0], .value y[1], .value y[2], .value y[3],
        .value y[4]] =
      Ty.wrap (t := .vec 8 64) (wwl_slide x y 5) := by
  apply vec_ext_fin; intro i; fin_cases i <;> simp [wwl_slide, Ty.wrap_vec]

/-- `(zb << 1) + (zb << 4)` as written is `18 zb` as compiled. -/
theorem shl_1_add_shl_4 (x : BitVec 64) : x <<< 1 + x <<< 4 = x * 18 := by bv_decide

/-- `18 zb` as compiled, by shifts as written. -/
theorem ofFn_mul18 (x : Wwl) :
    (Vector.ofFn fun i : Fin 8 => x[i.1] * 18#64) = wwl_add (wwl_shl x 1) (wwl_shl x 4) := by
  ext i hi : 1; simp [wwl_add, wwl_shl, shl_1_add_shl_4]

end

namespace fd_f25519_mul

theorem permute_bcast_0 (v : Wwl) :
    #v[v[0], v[0], v[0], v[0], v[0], v[0], v[0], v[0]] = wwl_permute (wwl_bcast 0) v := by
  bcast_lanes

theorem permute_bcast_1 (v : Wwl) :
    #v[v[1], v[1], v[1], v[1], v[1], v[1], v[1], v[1]] = wwl_permute (wwl_bcast 1) v := by
  bcast_lanes

theorem permute_bcast_2 (v : Wwl) :
    #v[v[2], v[2], v[2], v[2], v[2], v[2], v[2], v[2]] = wwl_permute (wwl_bcast 2) v := by
  bcast_lanes

theorem permute_bcast_3 (v : Wwl) :
    #v[v[3], v[3], v[3], v[3], v[3], v[3], v[3], v[3]] = wwl_permute (wwl_bcast 3) v := by
  bcast_lanes

theorem permute_bcast_4 (v : Wwl) :
    #v[v[4], v[4], v[4], v[4], v[4], v[4], v[4], v[4]] = wwl_permute (wwl_bcast 4) v := by
  bcast_lanes

/-- `q4j` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_4_zero (v : Wwl) :
    #v[.value v[4], .value v[5], .value v[6], .value v[7], .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 4) := by
  apply vec_ext_fin; intro i; fin_cases i <;> simp [wwl_slide, lanesBelow]

/-- `q5j` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_3_zero (v : Wwl) :
    #v[.value v[3], .value v[4], .value v[5], .value v[6], .value v[7], .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 3) := by
  apply vec_ext_fin; intro i; fin_cases i <;> simp [wwl_slide, lanesBelow]

end fd_f25519_mul

/-! ## Proof -/

section Proof

-- folded, so the steps' terms and the spec compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

open fd_f25519_mul in
/-- `fd_f25519_mul( r, a, b )` stores `spec` of the elements at `a` and `b` at `r` and returns
`r`; `r` may alias `a` or `b`. -/
public theorem fd_f25519_mul.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Fits s.mem r 512) (ha : Fits s.mem a 512) (hb : Fits s.mem b 512) :
    fd_f25519_mul.call (fd_f25519_mul.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeVec r (fd_f25519_mul.spec (s.mem.readVec a) (s.mem.readVec b)) }) := by
  rw [MemoryState.storeVec, fd_f25519_mul.spec]
  func_init
  block_init
  -- the constants and the slides' `wwl_zero()` operands
  iterate 65 step_pure
  step_load with ax
  rw [ofFn_extractVecElem_readAt_320] at hax
  subst hax
  step_pure with x0
  rw [permute_bcast_0] at hx0
  step_pure with x1
  rw [permute_bcast_1] at hx1
  step_pure with x2
  rw [permute_bcast_2] at hx2
  step_pure with x3
  rw [permute_bcast_3] at hx3
  step_pure with x4
  rw [permute_bcast_4] at hx4
  step_load with y
  rw [ofFn_extractVecElem_readAt_512] at hy
  -- `t1 … t5`: row `k - 1`'s high half doubled, plus row `k`'s low half
  step_pure with hi0
  rw [ofFn_madd52hi] at hhi0
  step_pure with c0
  rw [wwl_shl_ofFn] at hc0
  step_pure with t1
  rw [ofFn_madd52lo] at ht1
  step_pure with hi1
  rw [ofFn_madd52hi] at hhi1
  step_pure with c1
  rw [wwl_shl_ofFn] at hc1
  step_pure with t2
  rw [ofFn_madd52lo] at ht2
  step_pure with hi2
  rw [ofFn_madd52hi] at hhi2
  step_pure with c2
  rw [wwl_shl_ofFn] at hc2
  step_pure with t3
  rw [ofFn_madd52lo] at ht3
  step_pure with hi3
  rw [ofFn_madd52hi] at hhi3
  step_pure with c3
  rw [wwl_shl_ofFn] at hc3
  step_pure with t4
  rw [ofFn_madd52lo] at ht4
  step_pure with hi4
  rw [ofFn_madd52hi] at hhi4
  step_pure with t5
  rw [wwl_shl_ofFn] at ht5
  step_pure with p1j
  rw [← wwl_slide_zero_7] at hp1j
  step_pure with p2j
  rw [← wwl_slide_zero_6] at hp2j
  step_pure with p3j
  rw [← wwl_slide_zero_5] at hp3j
  step_pure with p4j
  rw [← wwl_slide_zero_4] at hp4j
  step_pure with q4j
  rw [lanes5_slide_4_zero] at hq4j
  step_pure with p5j
  rw [← wwl_slide_zero_3] at hp5j
  step_pure with q5j
  rw [lanes5_slide_3_zero] at hq5j
  -- `p0j + p1j` as `wwl_madd52lo(p1j, x0, y)`, then `zl`'s other terms
  step_pure with p01j
  rw [ofFn_madd52lo] at hp01j
  step_pure with zl0
  step_pure with zl1
  step_pure with zl2
  step_pure with zl
  rw [wwl_add_ofFn] at hzl0 hzl1 hzl2 hzl
  step_pure with zh
  subst hq4j hq5j
  rw [ofFn_add_lanesBelow] at hzh
  step_pure with za
  rw [ofFn_and_mask5] at hza
  step_pure [hzh, lanesBelow_getElem, wrap_slide_5] with zb
  step_pure with zab
  step_pure with zb18
  step_pure with z
  rw [wwl_add_ofFn] at hzab hz
  rw [ofFn_mul18] at hzb18
  step_call using fd_f25519_fold_unsigned.call_eq
  step_store
  finish_block
  rw [hS]
  suffices e : z = fd_f25519_mul.z (S₀.mem.readVec a) (S₀.mem.readVec b) by rw [e]
  simp only [fd_f25519_mul.z]
  rw [← hy, ← hx0, ← hx1, ← hx2, ← hx3, ← hx4, ← hhi0, ← hhi1, ← hhi2, ← hhi3, ← hhi4, ← hc0, ← hc1,
    ← hc2, ← hc3, ← ht1, ← ht2, ← ht3, ← ht4, ← ht5, ← hp1j, ← hp2j, ← hp3j, ← hp4j, ← hp5j]
  rw [hz, hzab, hzb18, hza, hzb, hzl, hzl2, hzl1, hzl0, hp01j, wwl_madd52lo_eq_add p1j]
  ac_rfl

end Proof

end MLIR.Firedancer.R52x5

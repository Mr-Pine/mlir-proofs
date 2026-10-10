module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_f25519_mul
public import Firedancer.R52x5.Mlir.fd_f25519_sqr
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-- A vector equation lane by lane. -/
local macro "vec_lanes" : tactic =>
  `(tactic|
    (apply vec_ext_fin; intro i;
      fin_cases i <;> simp [wwl_permute, wwl_shl_vector, wwl_slide, lanesBelow, wwl]))

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_sqr`'s `z`: the products `p0`, `p1`, `p2` of permuted lanes, doubled by shifts where
the square has a symmetric pair, summed into `zl` and `zh` and folded by `za + 19 zb`. -/
@[irreducible]
def fd_f25519_sqr.z (a : Wwl) : Wwl :=
  let zero := wwl_zero
  let aa := a
  let x0 := wwl_permute (wwl 0 0 0 0 0 2 3 3) aa
  let x1 := wwl_permute (wwl 0 1 2 3 4 3 3 4) aa
  let x2 := wwl_permute (wwl 4 5 1 1 1 1 2 5) aa
  let x3 := wwl_permute (wwl 4 5 1 2 3 4 4 5) aa
  let x4 := wwl_permute (wwl 5 5 5 5 2 5 5 5) aa
  let p0l := wwl_madd52lo zero x0 x1
  let p0h := wwl_madd52hi zero x0 x1
  let p1l := wwl_madd52lo zero x2 x3
  let p1h := wwl_madd52hi zero x2 x3
  let p2l := wwl_madd52lo zero x4 x4
  let p2h := wwl_madd52hi zero x4 x4
  let p0l := wwl_shl_vector p0l (wwl 0 1 1 1 1 1 0 1)
  let p0h := wwl_shl_vector p0h (wwl 1 2 2 2 2 2 1 2)
  let p1l := wwl_shl_vector p1l (wwl 0 0 0 1 1 1 1 0)
  let p1h := wwl_shl_vector p1h (wwl 1 0 1 2 2 2 2 0)
  let p2h := wwl_shl p2h 1
  let mask1 := wwl (-1) 0 0 0 0 0 0 0
  let zll := wwl_add (wwl_add p0l (wwl_andnot mask1 p1l)) p2l
  let zlh := wwl_add (wwl_add p0h (wwl_andnot mask1 p1h)) p2h
  let zhl := wwl_and mask1 p1l
  let zhh := wwl_and mask1 p1h
  let zl := wwl_add zll (wwl_slide zero zlh 7)
  let zh := wwl_add zhl (wwl_add (wwl_slide zero zhh 7) (wwl_slide zlh zero 7))
  let za := wwl_and zl (wwl (-1) (-1) (-1) (-1) (-1) 0 0 0)
  let zb := wwl_slide zl zh 5
  wwl_add (wwl_add za zb) (wwl_add (wwl_shl zb 1) (wwl_shl zb 4))

/-- `fd_f25519_sqr(r, a)`'s element: `fd_f25519_fold_unsigned(z)`. -/
@[irreducible]
def fd_f25519_sqr.spec (a : Wwl) : Wwl :=
  fold (fd_f25519_sqr.z a)

end

/-! ## Lanes as the steps give them -/

namespace fd_f25519_sqr

/-- Lanes `0 … 5` of a `<6 x i64>` load: the element's first six lanes. -/
theorem ofFn_extractVecElem_readAt_384 (m : MemoryState) (p : Pointer) :
    (Vector.ofFn fun i : Fin 6 => Ty.extractVecElem 6 64 i (m.readAt p 384)) =
      #v[(m.readVec p)[0], (m.readVec p)[1], (m.readVec p)[2], (m.readVec p)[3], (m.readVec p)[4],
        (m.readVec p)[5]] := by
  rw [MemoryState.readAt_of_readAt_le (show 384 ≤ 512 by decide) rfl]
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp [MemoryState.readVec, Ty.extractVecElem_eq] <;>
    rw [BitVec.extractLsb'_setWidth_of_le (by decide)]

/-- `x0`, as the shuffle gives it. -/
theorem permute_x0 (v : Wwl) :
    #v[v[0], v[0], v[0], v[0], v[0], v[2], v[3], v[3]] = wwl_permute (wwl 0 0 0 0 0 2 3 3) v := by
  vec_lanes

/-- `x1`, as the shuffle gives it. -/
theorem permute_x1 (v : Wwl) :
    #v[v[0], v[1], v[2], v[3], v[4], v[3], v[3], v[4]] = wwl_permute (wwl 0 1 2 3 4 3 3 4) v := by
  vec_lanes

/-- `x2`, as the shuffle gives it. -/
theorem permute_x2 (v : Wwl) :
    #v[v[4], v[5], v[1], v[1], v[1], v[1], v[2], v[5]] = wwl_permute (wwl 4 5 1 1 1 1 2 5) v := by
  vec_lanes

/-- `x3`, as the shuffle gives it. -/
theorem permute_x3 (v : Wwl) :
    #v[v[4], v[5], v[1], v[2], v[3], v[4], v[4], v[5]] = wwl_permute (wwl 4 5 1 2 3 4 4 5) v := by
  vec_lanes

/-- `x4`, as the shuffle gives it. -/
theorem permute_x4 (v : Wwl) :
    #v[v[5], v[5], v[5], v[5], v[2], v[5], v[5], v[5]] = wwl_permute (wwl 5 5 5 5 2 5 5 5) v := by
  vec_lanes

/-- `wwl_madd52lo(wwl_zero(), x, y)` as a step gives it. -/
theorem ofFn_madd52lo_zero (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        (x[i.1] &&& 4503599627370495#64) * (y[i.1] &&& 4503599627370495#64) &&&
          4503599627370495#64) =
      wwl_madd52lo wwl_zero x y := by
  ext i hi : 1; simp [wwl_madd52lo, madd52lo]

/-- `p0l`'s shift by a vector, as the expanded lanes give it. -/
theorem shl_p0l (x : Wwl) :
    #v[x[0], x[1] <<< 1, x[2] <<< 1, x[3] <<< 1, x[4] <<< 1, x[5] <<< 1, x[6], x[7] <<< 1] =
      wwl_shl_vector x (wwl 0 1 1 1 1 1 0 1) := by
  vec_lanes

/-- `p0h`'s shift by a vector, as the expanded lanes give it. -/
theorem shl_p0h (x : Wwl) :
    #v[x[0] <<< 1, x[1] <<< 2, x[2] <<< 2, x[3] <<< 2, x[4] <<< 2, x[5] <<< 2, x[6] <<< 1,
        x[7] <<< 2] =
      wwl_shl_vector x (wwl 1 2 2 2 2 2 1 2) := by
  vec_lanes

/-- `p1l`'s shift by a vector, as the expanded lanes give it. -/
theorem shl_p1l (x : Wwl) :
    #v[x[0], x[1], x[2], x[3] <<< 1, x[4] <<< 1, x[5] <<< 1, x[6] <<< 1, x[7]] =
      wwl_shl_vector x (wwl 0 0 0 1 1 1 1 0) := by
  vec_lanes

/-- `p1h`'s shift by a vector, as the expanded lanes give it. -/
theorem shl_p1h (x : Wwl) :
    #v[x[0] <<< 1, x[1], x[2] <<< 1, x[3] <<< 2, x[4] <<< 2, x[5] <<< 2, x[6] <<< 2, x[7]] =
      wwl_shl_vector x (wwl 1 0 1 2 2 2 2 0) := by
  vec_lanes

theorem allOnes_eq : 18446744073709551615#64 = BitVec.allOnes 64 := by decide

theorem not_neg_one : ~~~(-1 : BitVec 64) = 0#64 := by decide

theorem not_zero : ~~~(0 : BitVec 64) = BitVec.allOnes 64 := by decide

/-- `wwl_andnot(mask1, x)` as compiled, an `and` with lane 0 clear. -/
theorem andnot_mask1 (x : Wwl) :
    #v[0#64, x[1] &&& 18446744073709551615#64, x[2] &&& 18446744073709551615#64,
        x[3] &&& 18446744073709551615#64, x[4] &&& 18446744073709551615#64,
        x[5] &&& 18446744073709551615#64, x[6] &&& 18446744073709551615#64,
        x[7] &&& 18446744073709551615#64] =
      wwl_andnot (wwl (-1) 0 0 0 0 0 0 0) x := by
  -- propositional steps only: the kernel does not replay `~~~` on literal lanes
  rw [allOnes_eq]
  apply vec_ext_fin; intro i
  fin_cases i <;>
    simp only [wwl_andnot, wwl, Vector.getElem_ofFn, Fin.zero_eta, Fin.isValue, Fin.getElem_fin,
      Fin.val_ofNat_lit, Fin.mk_one, Fin.reduceFinMk, Nat.reduceMod, Nat.reduceAdd,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
      not_neg_one, not_zero, BitVec.zero_and, BitVec.allOnes_and, BitVec.and_allOnes]

/-- `wwl_and(mask1, x)` as compiled, operands swapped. -/
theorem and_mask1 (x : Wwl) :
    wwl_and x (wwl 18446744073709551615#64 0#64 0#64 0#64 0#64 0#64 0#64 0#64) =
      wwl_and (wwl (-1) 0 0 0 0 0 0 0) x := by
  apply vec_ext_fin; intro i
  fin_cases i <;> simp [wwl_and, wwl]
  exact BitVec.and_comm _ _

/-- `mask1` for `zhl`, lanes `5 … 7` undefined. -/
theorem set_lanesBelow_5 (c0 c1 c2 c3 c4 : BitVec 64) :
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value c0)).set 1
                                (PoisonOr.value c1)).set
                            2 (PoisonOr.value c2)).set
                        3 (PoisonOr.value c3)).set
                    4 (PoisonOr.value c4)).set
                5 PoisonOr.poison).set
            6 PoisonOr.poison).set
        7 PoisonOr.poison =
      lanesBelow 5 (wwl c0 c1 c2 c3 c4 0 0 0) := by
  vec_lanes

/-- `mask1` for `zhh`, lanes `4 … 7` undefined. -/
theorem set_lanesBelow_4 (c0 c1 c2 c3 : BitVec 64) :
    ((((((((Vector.replicate 8 PoisonOr.poison).set 0 (PoisonOr.value c0)).set 1
                                (PoisonOr.value c1)).set
                            2 (PoisonOr.value c2)).set
                        3 (PoisonOr.value c3)).set
                    4 PoisonOr.poison).set
                5 PoisonOr.poison).set
            6 PoisonOr.poison).set
        7 PoisonOr.poison =
      lanesBelow 4 (wwl c0 c1 c2 c3 0 0 0 0) := by
  vec_lanes

/-- `wwl_slide(zero, zhh, 7)` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_zero_7 (v : Wwl) :
    #v[.value 0#64, .value v[0], .value v[1], .value v[2], .value v[3], .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide wwl_zero v 7) := by
  vec_lanes

/-- `wwl_slide(zlh, zero, 7)` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_7_zero (v : Wwl) :
    #v[.value v[7], .value 0#64, .value 0#64, .value 0#64, .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 7) := by
  vec_lanes

end fd_f25519_sqr

/-! ## Proof -/

section Proof

-- folded, so the steps' terms and the spec compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

open fd_f25519_sqr in
/-- `fd_f25519_sqr( r, a )` stores `spec` of the element at `a` at `r` and returns `r`; `r` may
alias `a`. -/
public theorem fd_f25519_sqr.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 512) (ha : Fits s.mem a 512) :
    fd_f25519_sqr.call (fd_f25519_sqr.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_sqr.spec (s.mem.readVec a)) }) := by
  rw [MemoryState.storeVec, fd_f25519_sqr.spec]
  func_init
  block_init
  -- the constants and the slides' `wwl_zero()` operands
  iterate 54 step_pure
  step_load with aa
  rw [ofFn_extractVecElem_readAt_384] at haa
  subst haa
  step_pure with x0
  rw [permute_x0] at hx0
  step_pure with x1
  rw [permute_x1] at hx1
  step_pure with x2
  rw [permute_x2] at hx2
  step_pure with x3
  rw [permute_x3] at hx3
  step_pure with x4
  rw [permute_x4] at hx4
  step_pure with p0l
  rw [ofFn_madd52lo_zero] at hp0l
  step_pure with p0h
  rw [ofFn_madd52hi] at hp0h
  step_pure with p1l
  rw [ofFn_madd52lo_zero] at hp1l
  step_pure with p1h
  rw [ofFn_madd52hi] at hp1h
  step_pure with p2h
  rw [ofFn_madd52hi] at hp2h
  -- the shifts by vectors, lane by lane
  step_pure [expandOfFn] with p0l'
  rw [shl_p0l] at hp0l'
  step_pure [expandOfFn] with p0h'
  rw [shl_p0h] at hp0h'
  step_pure [expandOfFn] with p1l'
  rw [shl_p1l] at hp1l'
  step_pure [expandOfFn] with p1h'
  rw [shl_p1h] at hp1h'
  step_pure with p2h'
  rw [wwl_shl_ofFn] at hp2h'
  -- `zll` and `zlh`, `p2l` as `wwl_madd52lo(_, x4, x4)`
  step_pure [expandOfFn] with n1l
  rw [andnot_mask1] at hn1l
  step_pure with zll0
  rw [wwl_add_ofFn] at hzll0
  step_pure with zll
  rw [ofFn_madd52lo] at hzll
  step_pure [expandOfFn] with n1h
  rw [andnot_mask1] at hn1h
  step_pure with zlh0
  step_pure with zlh
  rw [wwl_add_ofFn] at hzlh0 hzlh
  -- `zhl`, `zhh` and `zh` on their defined lanes `0 … 4`
  step_pure [set_lanesBelow_5, ofFn_and_lanesBelow] with zhl
  step_pure [set_lanesBelow_4, ofFn_and_lanesBelow] with zhh
  step_pure with slh
  rw [← wwl_slide_zero_7] at hslh
  step_pure with zl
  rw [wwl_add_ofFn] at hzl
  step_pure [hzhh, lanesBelow_getElem, lanes5_slide_zero_7] with shh
  step_pure [lanes5_slide_7_zero] with slh'
  step_pure [hshh, hzhl, ofFn_add_lanesBelow] with zh0
  step_pure [hzh0, hslh', ofFn_add_lanesBelow] with zh
  step_pure with za
  rw [ofFn_and_mask5] at hza
  step_pure [hzh, lanesBelow_getElem, wrap_slide_5] with zb
  step_pure with zba
  step_pure with zb18
  step_pure with z
  rw [wwl_add_ofFn] at hzba hz
  rw [ofFn_mul18] at hzb18
  step_call using fd_f25519_fold_unsigned.call_eq
  step_store
  finish_block
  rw [hS]
  suffices e : z = fd_f25519_sqr.z (S₀.mem.readVec a) by rw [e]
  simp only [fd_f25519_sqr.z]
  rw [← hx0, ← hx1, ← hx2, ← hx3, ← hx4, ← hp0l, ← hp0h, ← hp1l, ← hp1h, ← hp2h, ← hp0l', ← hp0h', ←
    hp1l', ← hp1h', ← hp2h', ← hn1l, ← hn1h]
  rw [hz, hzba, hzb18, hza, hzb, hzl, hslh, hzll, wwl_madd52lo_eq_add zll0, hzll0, hzlh, hzlh0,
    and_mask1, and_mask1]
  ac_rfl

end Proof

end MLIR.Firedancer.R52x5

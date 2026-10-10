module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Sodium.Mlir.fe25519_sub
public import Mathlib.Tactic.FinCases
import Mathlib.Data.BitVec
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `f - g`: `g` carried once (`h1 += h0 >> 51; h0 &= mask; …`, the top carry times 19 into
`h0`), then subtracted from `f + 2p` limbwise. -/
def fe25519_sub.spec (f g : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#64
  let h1 := g 1 + g 0 >>> 51
  let h0 := g 0 &&& mask
  let h2 := g 2 + h1 >>> 51
  let h1 := h1 &&& mask
  let h3 := g 3 + h2 >>> 51
  let h2 := h2 &&& mask
  let h4 := g 4 + h3 >>> 51
  let h3 := h3 &&& mask
  let h0 := h0 + 19#64 * (h4 >>> 51)
  let h4 := h4 &&& mask
  fun
  | 0 => f 0 + 0xfffffffffffda#64 - h0
  | 1 => f 1 + 0xffffffffffffe#64 - h1
  | 2 => f 2 + 0xffffffffffffe#64 - h2
  | 3 => f 3 + 0xffffffffffffe#64 - h3
  | 4 => f 4 + 0xffffffffffffe#64 - h4

end

/-! ## Proof -/

section Proof

open Agave

/-- The top carry times `-19` (`nsw`) does not wrap. -/
@[local simp]
theorem shift_mul_neg19_no_smulOverflow (x : BitVec 64) :
    ¬(x >>> 51).smulOverflow 18446744073709551597#64 := by bv_decide

/-- Limbs stored as limb 0, then the pairs at bytes 8 and 24. -/
theorem storeAt_limb0_pairs {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    (x0 : BitVec 64) (v12 v34 : Vector (BitVec 64) 2) :
    ((m.storeAt p x0).storeAt (p.add 8#64) (BitVec.packLanes v12)).storeAt (p.add 24#64)
        (BitVec.packLanes v34) =
      m.storeLimbs p fun
        | 0 => x0
        | 1 => v12[0]
        | 2 => v12[1]
        | 3 => v34[0]
        | 4 => v34[1] := by
  rw [storeAt_packLanes_limb h (k := 8#64) (by decide),
    storeAt_packLanes_limb h (k := 24#64) (by decide)]
  rfl

/-- `spec` as the code computes it: `f - h + c` per limb (`c` the offset, `2^52 - 38` and
`2^52 - 2`), the top carry times `-19` into limb 0. -/
theorem fe25519_sub.spec_eq (f g : Fin 5 → BitVec 64) :
    fe25519_sub.spec f g =
      let h1 := g 1 + g 0 >>> 51
      let h2 := h1 >>> 51 + g 2
      let h3 := h2 >>> 51 + g 3
      let h4 := h3 >>> 51 + g 4
      fun
      | 0 =>
        f 0 - (g 0 &&& 2251799813685247#64) + 4503599627370458#64 +
          h4 >>> 51 * 18446744073709551597#64
      | 1 => f 1 - (h1 &&& 2251799813685247#64) + 4503599627370494#64
      | 2 => f 2 - (h2 &&& 2251799813685247#64) + 4503599627370494#64
      | 3 => f 3 + 0#64 - (h3 &&& 2251799813685247#64) + 4503599627370494#64
      | 4 => f 4 + 4503599627370494#64 - (h4 &&& 2251799813685247#64) + 0#64 := by
  funext i
  rw [show (18446744073709551597#64 : BitVec 64) = -19#64 from rfl]
  fin_cases i <;> simp only [fe25519_sub.spec, BitVec.add_zero] <;> ring_nf

/-- `fe25519_sub` stores `spec f g` at `h`, limbs 1–4 as two vector pairs. The loads all come
before the stores, so `h` may alias `f` or `g`. -/
public theorem fe25519_sub.call_eq (h f g : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hg : s.mem.LimbsFit g) :
    fe25519_sub.call (fe25519_sub.args (.value h) (.value f) (.value g)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h (fe25519_sub.spec (s.mem.readLimbs f) (s.mem.readLimbs g)) }) := by
  func_init
  have hf₀ : S₀.mem.LimbsFit f := hS ▸ hf
  have hf_8 := fits_pair hf (k := 8#64) (by decide)
  have hf_24 := fits_pair hf (k := 24#64) (by decide)
  have hh_8 := room_pair hh (k := 8#64) (by decide)
  have hh_24 := room_pair hh (k := 24#64) (by decide)
  have hoff := hh.1
  block_init
  iterate 11 step_pure
  -- h0 = g[0]; … h4 = g[4];
  step_load
  iterate 4 
    step_pure
    step_load
  iterate 2 step_pure
  step_load
  iterate 9 step_pure
  iterate 2 step_pure [MLIR.reduceVectorSet]
  step_pure
  step_load
  iterate 3 step_pure
  step_load
  iterate 5 step_pure
  iterate 2 step_pure [MLIR.reduceVectorSet]
  iterate 5 step_pure
  step_store
  step_store
  step_store
  finish_block
  rw [hS, storeAt_limb0_pairs hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, lane0_readAt,
    lane1_readAt hf₀ (k := 8#64) (by decide), lane1_readAt hf₀ (k := 24#64) (by decide)]
  rw [fe25519_sub.spec_eq]
  simp only [MemoryState.readLimbs, BitVec.reduceAdd, List.getElem_cons_zero,
    List.getElem_cons_succ]

end Proof

end MLIR.Sodium

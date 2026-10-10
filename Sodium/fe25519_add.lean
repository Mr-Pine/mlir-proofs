module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Firedancer.Ref.fiat_25519_add
public import Sodium.Mlir.fe25519_add
public import Mathlib.Tactic.FinCases

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `fe25519_add` stores `f + g` limbwise, Firedancer's `fiat_25519_add.spec f g` (the same sums
in the same operand order), at `h`, its first four limbs as two vector pairs. The loads all come
before the stores, so `h` may alias `f` or `g`. -/
public theorem fe25519_add.call_eq (h f g : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) (hg : s.mem.LimbsFit g) :
    fe25519_add.call (fe25519_add.args (.value h) (.value f) (.value g)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h
                (Firedancer.Ref.fiat_25519_add.spec (s.mem.readLimbs f)
                  (s.mem.readLimbs g)) }) := by
  func_init
  have hf₀ : S₀.mem.LimbsFit f := hS ▸ hf
  have hg₀ : S₀.mem.LimbsFit g := hS ▸ hg
  have hf_lo := hf.fits_lo
  have hf_hi := hf.fits_hi
  have hg_lo := hg.fits_lo
  have hg_hi := hg.fits_hi
  have hh_lo := hh.room_lo
  have hh_hi := hh.room_hi
  have hoff := hh.1
  block_init
  iterate 3 step_pure
  -- uint64_t h4 = f[4] + g[4];
  step_load
  step_pure
  step_load
  step_pure
  -- h0, h1 and h2, h3 as vector pairs
  step_load
  step_load
  step_pure
  step_pure
  step_load
  step_load
  step_pure
  step_store
  step_store
  step_pure
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_packLanes_limbs hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, MemoryState.extractVecElem_zero_readAt,
    hf₀.extractVecElem_one_lo, hg₀.extractVecElem_one_lo, hf₀.extractVecElem_one_hi,
    hg₀.extractVecElem_one_hi]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Sodium

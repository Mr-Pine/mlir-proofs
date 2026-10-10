module

public import MLIR.Run.Tactic
public import Boringssl.Common.Limbs
public import Firedancer.Ref.fiat_25519_opp
public import Boringssl.Mlir.fiat_25519_opp
public import Mathlib.Tactic.FinCases

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fiat_25519_opp` stores Firedancer's `fiat_25519_opp.spec x` (the same fiat-crypto C) at
`out`, its first four limbs as two vector pairs. The loads all come before the stores, so `out` may
alias `x`. -/
public theorem fiat_25519_opp.call_eq (out x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hx : s.mem.LimbsFit x) :
    fiat_25519_opp.call (fiat_25519_opp.args (.value out) (.value x)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (Firedancer.Ref.fiat_25519_opp.spec (s.mem.readLimbs x)) }) := by
  func_init
  have hx₀ : S₀.mem.LimbsFit x := hS ▸ hx
  have hx_lo := hx.fits_lo
  have hx_hi := hx.fits_hi
  have hout_lo := hout.room_lo
  have hout_hi := hout.room_hi
  have hoff := hout.1
  block_init
  iterate 5 step_pure
  step_load
  -- the last limb, then the pairs
  step_pure
  step_load
  step_pure
  step_pure
  step_load
  step_pure
  step_store
  step_store
  step_pure
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_packLanes_limbs hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, MemoryState.extractVecElem_zero_readAt,
    hx₀.extractVecElem_one_lo, hx₀.extractVecElem_one_hi]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Boringssl

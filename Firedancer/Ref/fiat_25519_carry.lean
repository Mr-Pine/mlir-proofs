module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.Fiat
public import Firedancer.Ref.Mlir.fiat_25519_carry

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- One carry pass over the 51-bit limbs, the top carry folded back into limb 0 times 19
(`2^255 ≡ 19 mod p`), then one more carry out of limbs 0 and 1. Named as in fiat-crypto's C. -/
def fiat_25519_carry.spec (arg1 : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64 -- `2^51 - 1`
  let x1 := arg1 0
  let x2 := (x1 >>> 51) + arg1 1
  let x3 := (x2 >>> 51) + arg1 2
  let x4 := (x3 >>> 51) + arg1 3
  let x5 := (x4 >>> 51) + arg1 4
  let x6 := (x5 >>> 51) * 19 + (x1 &&& mask)
  let x7 := (x6 >>> 51) + (x2 &&& mask)
  let x8 := x6 &&& mask
  let x9 := x7 &&& mask
  let x10 := (x7 >>> 51) + (x3 &&& mask)
  let x11 := x4 &&& mask
  let x12 := x5 &&& mask
  fun
  | ⟨0, _⟩ => x8
  | ⟨1, _⟩ => x9
  | ⟨2, _⟩ => x10
  | ⟨3, _⟩ => x11
  | ⟨4, _⟩ => x12

end

/-! ## Proof -/

section Proof

/-- `carry` stores one carry pass of `x` at `out`. The loads all come before the stores, so `out`
may alias `x`; the `nsw`/`nuw` flags never fire, since every flagged operand is below `2^52`. -/
public theorem fiat_25519_carry.call_eq (out x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hx : s.mem.LimbsFit x) :
    fiat_25519_carry.call (fiat_25519_carry.args (.value out) (.value x)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeLimbs out (fiat_25519_carry.spec (s.mem.readLimbs x)) }) := by
  func_init
  block_init
  -- %0 … %2: the constants
  iterate 3 step_pure
  -- %3 … %19: the carry chain, `load`, then `lshr`, `gep`, `load`, `add` per limb
  step_load with x1
  step_pure opaque -- lshr
  step_pure -- gep
  step_load
  step_pure with x2 -- add
  step_pure opaque -- lshr
  step_pure -- gep
  step_load
  step_pure with x3 -- add
  step_pure opaque -- lshr
  step_pure -- gep
  step_load
  step_pure with x4 -- add
  step_pure opaque -- lshr
  step_pure -- gep
  step_load
  step_pure with x5 -- add
  -- x6 = ((x1 & UINT64_C(0x7ffffffffffff)) + ((x5 >> 51) * UINT8_C(0x13)));
  step_pure opaque
  step_pure opaque
  step_pure
  step_pure with x6
  -- x7 = ((fiat_25519_uint1)(x6 >> 51) + (x2 & UINT64_C(0x7ffffffffffff)));
  step_pure opaque
  step_pure opaque
  step_pure with x7
  -- x8 = (x6 & UINT64_C(0x7ffffffffffff));
  step_pure with x8
  -- x9 = (x7 & UINT64_C(0x7ffffffffffff));
  step_pure with x9
  -- x10 = ((fiat_25519_uint1)(x7 >> 51) + (x3 & UINT64_C(0x7ffffffffffff)));
  step_pure opaque
  step_pure opaque
  step_pure with x10
  -- x11 = (x4 & UINT64_C(0x7ffffffffffff));
  step_pure with x11
  -- x12 = (x5 & UINT64_C(0x7ffffffffffff));
  step_pure with x12
  -- the five stores: `step_store` needs each stored value to be `.value _`, i.e. the overflow
  -- tests above already gone
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  finish_block
  -- the final state against the spec, limb by limb
  simp only [hS, fiat_25519_carry.spec, MemoryState.storeLimbs, MemoryState.readLimbs]
  dsimp
  congr <;> simp [*]

end Proof

end LeanMLIR.RIR.Firedancer.Ref

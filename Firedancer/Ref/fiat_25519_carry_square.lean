module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Fiat
public import Firedancer.Ref.Mlir.fiat_25519_carry_square

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The five `i128` column sums of `a²`, columns 5 … 8 folded back times 19 (`2^255 ≡ 19 mod p`),
carried through; then the top carry folded into limb 0 times 19, and one more carry out of limbs 0
and 1. -/
def fiat_25519_carry_square.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64 -- `2^51 - 1`
  let lo := 18446744073709551615#128 -- `2^64 - 1`
  let m (x y : BitVec 64) : BitVec 128 := x.setWidth 128 * y.setWidth 128
  let c0 := m (a 1) (a 4 * 38) + m (a 2) (a 3 * 38) + m (a 0) (a 0)
  let c1 := m (a 2) (a 4 * 38) + m (a 3 * 19) (a 3) + m (a 0) (a 1 <<< 1)
  let c2 := m (a 1) (a 1) + m (a 3) (a 4 * 38) + m (a 0) (a 2 <<< 1)
  let c3 := m (a 1) (a 2 <<< 1) + m (a 4 * 19) (a 4) + m (a 0) (a 3 <<< 1)
  let c4 := m (a 1) (a 3 <<< 1) + m (a 2) (a 2) + m (a 0) (a 4 <<< 1)
  let r1 := c1 + (c0 >>> 51 &&& lo)
  let r2 := c2 + (r1 >>> 51 &&& lo)
  let r3 := c3 + (r2 >>> 51 &&& lo)
  let r4 := c4 + (r3 >>> 51 &&& lo)
  let u0 := (r4 >>> 51).setWidth 64 * 19 + (c0.setWidth 64 &&& mask)
  let u1 := (u0 >>> 51) + (r1.setWidth 64 &&& mask)
  fun
  | ⟨0, _⟩ => u0 &&& mask
  | ⟨1, _⟩ => u1 &&& mask
  | ⟨2, _⟩ => (u1 >>> 51) + (r2.setWidth 64 &&& mask)
  | ⟨3, _⟩ => r3.setWidth 64 &&& mask
  | ⟨4, _⟩ => r4.setWidth 64 &&& mask

end

/-! ## Proof -/

section Proof

/-- `carry_square` stores the carried square of `a` at `out`. The loads all come before the stores,
so `out` may alias `a`; the `nuw` products are of zero-extended limbs, and the `nsw nuw` adds are
of a 13-bit carry and a 51-bit limb, so no flag ever fires. -/
public theorem fiat_25519_carry_square.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) :
    fiat_25519_carry_square.call (fiat_25519_carry_square.args (.value out) (.value a)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeLimbs out (fiat_25519_carry_square.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  -- %0 … %6: the constants
  iterate 7 step_pure
  -- %7 … %22: the limbs, loaded top down, scaled by `19`, `38` and `2`
  step_pure -- gep
  step_load with a4
  iterate 3 step_pure opaque
  step_pure -- gep
  step_load with a3
  iterate 3 step_pure opaque
  step_pure -- gep
  step_load with a2
  step_pure opaque
  step_pure -- gep
  step_load with a1
  step_pure opaque
  -- %23 … %51: the products; each `zext` stays inline, so `nuw` sees both operands are 64-bit
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_load with a0
  step_pure opaque
  step_pure opaque
  iterate 3 step_pure opaque
  step_pure opaque
  iterate 2 step_pure opaque
  -- %52 … %85: the column sums and their carry chain
  iterate 17 step_pure opaque
  step_pure opaque
  iterate 4 step_pure opaque
  step_pure opaque
  iterate 11 step_pure opaque
  -- %86 … %93: the reduction; `%88, %91` and `%69, %74` inline, for the `nsw nuw` lemmas
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  -- the five stores
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
  -- the stored limbs are the spec's, by definition
  subst_vars
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref

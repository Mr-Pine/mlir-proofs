module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.Fiat
public import Firedancer.Ref.Mlir.fiat_25519_carry_mul

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The product of two field elements in 51-bit limbs, named as in fiat-crypto's C: 128-bit
column sums (limbs past the top wrap round times 19, `2^255 ≡ 19 mod p`), carried at bit 51, then
the top carry times 19 into limb 0 and two more carries. Operands in the IR's order. -/
def fiat_25519_carry_mul.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64 -- `2^51 - 1`
  let mask' := 18446744073709551615#128 -- `2^64 - 1`
  let z (x : BitVec 64) : BitVec 128 := x.setWidth 128
  let x1 := z (b 4 * 19) * z (a 4)
  let x2 := z (b 3 * 19) * z (a 4)
  let x3 := z (b 2 * 19) * z (a 4)
  let x4 := z (b 1 * 19) * z (a 4)
  let x5 := z (a 3) * z (b 4 * 19)
  let x6 := z (a 3) * z (b 3 * 19)
  let x7 := z (a 3) * z (b 2 * 19)
  let x8 := z (a 2) * z (b 4 * 19)
  let x9 := z (a 2) * z (b 3 * 19)
  let x10 := z (a 1) * z (b 4 * 19)
  let x11 := z (b 0) * z (a 4)
  let x12 := z (a 3) * z (b 1)
  let x13 := z (b 0) * z (a 3)
  let x14 := z (a 2) * z (b 2)
  let x15 := z (a 2) * z (b 1)
  let x16 := z (b 0) * z (a 2)
  let x17 := z (a 1) * z (b 3)
  let x18 := z (a 1) * z (b 2)
  let x19 := z (a 1) * z (b 1)
  let x20 := z (b 0) * z (a 1)
  let x21 := z (a 0) * z (b 4)
  let x22 := z (a 0) * z (b 3)
  let x23 := z (a 0) * z (b 2)
  let x24 := z (a 0) * z (b 1)
  let x25 := z (a 0) * z (b 0)
  let x26 := x7 + x4 + x9 + x10 + x25
  let x28 := x26.setWidth 64 &&& mask
  let x32 := x6 + x3 + x8 + x20 + x24
  let x33 := x32 + (x26 >>> 51 &&& mask')
  let x35 := x33.setWidth 64 &&& mask
  let x31 := x5 + x2 + x19 + x16 + x23
  let x36 := x31 + (x33 >>> 51 &&& mask')
  let x38 := x36.setWidth 64 &&& mask
  let x30 := x15 + x1 + x18 + x13 + x22
  let x39 := x30 + (x36 >>> 51 &&& mask')
  let x41 := x39.setWidth 64 &&& mask
  let x29 := x14 + x12 + x17 + x11 + x21
  let x42 := x29 + (x39 >>> 51 &&& mask')
  let x43 := (x42 >>> 51).setWidth 64
  let x44 := x42.setWidth 64 &&& mask
  let x45 := x43 * 19
  let x46 := x45 + x28
  let x47 := x46 >>> 51
  let x48 := x46 &&& mask
  let x49 := x47 + x35
  let x50 := x49 >>> 51
  let x51 := x49 &&& mask
  let x52 := x50 + x38
  fun
  | ⟨0, _⟩ => x48
  | ⟨1, _⟩ => x51
  | ⟨2, _⟩ => x52
  | ⟨3, _⟩ => x41
  | ⟨4, _⟩ => x44

end

/-! ## Proof -/

section Proof

/-- `mul` stores the product of `a` and `b` at `out`. The loads all come before the stores, so
`out` may alias `a` or `b`; the `nuw`/`nsw` flags never fire. -/
public theorem fiat_25519_carry_mul.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    fiat_25519_carry_mul.call (fiat_25519_carry_mul.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (fiat_25519_carry_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  block_init
  -- the constants
  iterate 5 step_pure
  -- the limbs, zero-extended, `b i * 19` for the wrapped products, and `x1 … x25`
  step_pure
  step_load with a4
  step_pure opaque
  step_pure
  step_load with b4
  step_pure opaque
  step_pure opaque
  step_pure with x1
  step_pure
  step_load with b3
  step_pure opaque
  step_pure opaque
  step_pure with x2
  step_pure
  step_load with b2
  step_pure opaque
  step_pure opaque
  step_pure with x3
  step_pure
  step_load with b1
  step_pure opaque
  step_pure opaque
  step_pure with x4
  step_pure
  step_load with a3
  step_pure opaque
  step_pure with x5
  step_pure with x6
  step_pure with x7
  step_pure
  step_load with a2
  step_pure opaque
  step_pure with x8
  step_pure with x9
  step_pure
  step_load with a1
  step_pure opaque
  step_pure with x10
  step_load with b0
  step_pure opaque
  step_pure with x11
  step_pure opaque
  step_pure with x12
  step_pure with x13
  step_pure opaque
  step_pure with x14
  step_pure with x15
  step_pure with x16
  step_pure opaque
  step_pure with x17
  step_pure with x18
  step_pure with x19
  step_pure with x20
  step_load with a0
  step_pure opaque
  step_pure opaque
  step_pure with x21
  step_pure with x22
  step_pure with x23
  step_pure with x24
  step_pure with x25
  -- x26 … x44: the column sums, each plus the previous carry, split at bit 51
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure with x26
  step_pure opaque
  step_pure opaque
  step_pure with x28
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure with x32
  step_pure opaque
  step_pure with x33
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure with x31
  step_pure with x36
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure with x30
  step_pure with x39
  step_pure opaque
  step_pure opaque
  step_pure with x41
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure opaque
  step_pure with x29
  step_pure with x42
  step_pure opaque
  step_pure with x43
  step_pure opaque
  step_pure with x44
  -- x45 … x52: the top carry, times 19, into limb 0, and two more carries
  step_pure with x45
  step_pure with x46
  step_pure opaque
  step_pure with x48
  step_pure with x49
  step_pure opaque
  step_pure with x51
  step_pure with x52
  -- the stores
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
  -- the final state against the spec: substitute every named value, then syntactic
  subst hS
  subst_vars
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref

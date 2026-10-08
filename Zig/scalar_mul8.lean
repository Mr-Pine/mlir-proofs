module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Scalar_fromBytes
public import Zig.Scalar_add
public import Zig.Scalar_toBytes
public import Zig.Mlir.scalar_mul8
public import Common.Tactics

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `8 s`: `s` unpacked, doubled three times, packed. -/
def scalar.mul8.spec (b : BitVec 256) : BitVec 256 :=
  let x := Scalar.fromBytes.spec b
  let x := Scalar.add.spec x x
  let x := Scalar.add.spec x x
  let x := Scalar.add.spec x x
  Scalar.toBytes.spec x

end

/-! ## Proof -/

section Proof

/-- `scalar.mul8` stores `spec s` at `out`, for the 32 bytes `s` at `p`. -/
public theorem scalar_mul8.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 256) (hp : Fits s.mem p 256) :
    scalar_mul8.call (scalar_mul8.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem := s.mem.storeAt out (scalar.mul8.spec (s.mem.readAt p 256)) }) := by
  func_init
  obtain ⟨c1, -⟩ := Scalar.fromBytes.spec_canonical (S₀.mem.readAt p 256)
  obtain ⟨c2, -⟩ := Scalar.add.spec_canonical c1 c1
  obtain ⟨c3, -⟩ := Scalar.add.spec_canonical c2 c2
  obtain ⟨c4, -⟩ := Scalar.add.spec_canonical c3 c3
  have l1 := c1.1
  have l2 := c2.1
  have l3 := c3.1
  have l4 := c4.top_lt
  clear c1 c2 c3 c4
  block_init
  iterate 2 step_pure
  step_alloca with t
  step_alloca with r3
  step_alloca with r2
  step_alloca with r1
  limbs_fit r3
  limbs_fit r2
  limbs_fit r1
  step_call using Scalar_fromBytes.call_eq
  have h1 := l1
  step_call using Scalar_add.call_eq_of consuming l1 h1
  have h2 := l2
  step_call using Scalar_add.call_eq_of consuming l2 h2
  have h3 := l3
  step_call using Scalar_add.call_eq_of consuming l3 h3
  step_call using Scalar_toBytes.call_eq_of consuming l4
  step_memcpy
  finish_block
  rw [hS]
  erase_frame
  rfl

end Proof

/-! ## Meaning -/

/-- `spec b`, little-endian, is `8 b mod ℓ`. -/
public theorem scalar.mul8.toNat_spec (b : BitVec 256) :
    (scalar.mul8.spec b).toNat = 8 * b.toNat % Ed25519.ell := by
  obtain ⟨c1, v1⟩ := Scalar.fromBytes.spec_canonical b
  obtain ⟨c2, v2⟩ := Scalar.add.spec_canonical c1 c1
  obtain ⟨c3, v3⟩ := Scalar.add.spec_canonical c2 c2
  obtain ⟨c4, v4⟩ := Scalar.add.spec_canonical c3 c3
  rw [scalar.mul8.spec, Scalar.toBytes.toNat_spec_canonical c4, v4, v3, v2, v1]
  simp only [Nat.add_mod_mod, Nat.mod_add_mod]
  congr 1
  omega

end LeanMLIR.RIR.Zig

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Copy
public import Agave.Common.Scalar
public import Agave.Serial.Scalar52_sub
public import Agave.Serial.Mlir.Scalar52_add

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `Scalar52::add(a, b)`'s `sum` before the `sub` of `ℓ`: `carry = a[i] + b[i] + (carry >> 52)`,
`sum[i] = carry & mask`, in the compiled operand order. -/
def Scalar52_add.sum (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 0xfffffffffffff#64
  let carry0 := a 0 + b 0
  let carry1 := a 1 + (carry0 >>> 52) + b 1
  let carry2 := a 2 + (carry1 >>> 52) + b 2
  let carry3 := a 3 + (carry2 >>> 52) + b 3
  let carry4 := a 4 + (carry3 >>> 52) + b 4
  fun
  | ⟨0, _⟩ => carry0 &&& mask
  | ⟨1, _⟩ => carry1 &&& mask
  | ⟨2, _⟩ => carry2 &&& mask
  | ⟨3, _⟩ => carry3 &&& mask
  | ⟨4, _⟩ => carry4 &&& mask

/-- `Scalar52::add(a, b)`: `sum`, less `ℓ` when possible. -/
def Scalar52_add.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Scalar52_sub.spec (Scalar52_add.sum a b)

end

/-! ## Proof -/

section Proof

/-- `Scalar52::add(a, b)` stores `spec a b` at `out`, through `sub` of a stack temporary: the
temporary and `sub`'s `black_box` leave two blocks counted. The loads all come before the store to
`out`, so `out` may alias `a` or `b`. -/
public theorem Scalar52_add.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    Scalar52_add.call (Scalar52_add.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem :=
              s.mem.storeLimbs out
                (Scalar52_add.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  -- the inputs' limbs, read before the slot is allocated
  have hra0 : S.mem.readAt a 64 = S₀.mem.readLimbs a 0 := by
    rw [hS]; rfl
  have hra1 : S.mem.readAt (a.add 8#64) 64 = S₀.mem.readLimbs a 1 := by
    rw [hS]; rfl
  have hra2 : S.mem.readAt (a.add 16#64) 64 = S₀.mem.readLimbs a 2 := by
    rw [hS]; rfl
  have hra3 : S.mem.readAt (a.add 24#64) 64 = S₀.mem.readLimbs a 3 := by
    rw [hS]; rfl
  have hra4 : S.mem.readAt (a.add 32#64) 64 = S₀.mem.readLimbs a 4 := by
    rw [hS]; rfl
  have hrb0 : S.mem.readAt b 64 = S₀.mem.readLimbs b 0 := by
    rw [hS]; rfl
  have hrb1 : S.mem.readAt (b.add 8#64) 64 = S₀.mem.readLimbs b 1 := by
    rw [hS]; rfl
  have hrb2 : S.mem.readAt (b.add 16#64) 64 = S₀.mem.readLimbs b 2 := by
    rw [hS]; rfl
  have hrb3 : S.mem.readAt (b.add 24#64) 64 = S₀.mem.readLimbs b 3 := by
    rw [hS]; rfl
  have hrb4 : S.mem.readAt (b.add 32#64) 64 = S₀.mem.readLimbs b 4 := by
    rw [hS]; rfl
  block_init
  iterate 3 step_pure
  step_alloca with sum
  step_pure
  -- `carry = a[i] + b[i] + (carry >> 52); sum[i] = carry & mask;`
  step_load [hra0] consuming hra0
  step_load [hrb0] consuming hrb0
  step_pure with transparent carry0
  step_pure
  step_store
  step_pure
  step_load [hra1] consuming hra1
  step_pure
  step_load [hrb1] consuming hrb1
  iterate 5 step_pure
  step_store
  step_pure
  step_load [hra2] consuming hra2
  step_pure
  step_load [hrb2] consuming hrb2
  iterate 5 step_pure
  step_store
  step_pure
  step_load [hra3] consuming hra3
  step_pure
  step_load [hrb3] consuming hrb3
  iterate 5 step_pure
  step_store
  step_pure
  step_load [hra4] consuming hra4
  step_pure
  step_load [hrb4] consuming hrb4
  iterate 5 step_pure
  step_store
  -- `Scalar52::sub(&sum, &constants::L)`
  have hsum_limbs : S.mem.LimbsFit sum :=
    ⟨by
      rw [hsum_off]; decide, hfits_sum, hfits_sum_8, hfits_sum_16, hfits_sum_24, hfits_sum_32⟩
  have hsl :=
    readLimbs_of_reads (l := Scalar52_add.sum (S₀.mem.readLimbs a) (S₀.mem.readLimbs b)) hread_sum
      hread_sum_8 hread_sum_16 hread_sum_24 hread_sum_32
  step_call using Scalar52_sub.call_eq [hsl]
  step_pure
  finish_block
  subst hS
  erase_frame
  simp only [GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
  rfl

end Proof

end MLIR.Agave.Serial

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Scalar
public import Agave.Serial.Scalar52_sub
public import Agave.Serial.Mlir.Scalar52_montgomery_mul
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

/-! The `nsw`/`nuw`/`nneg` flags: products of two 64-bit numbers, of one and a part of `ℓ` below
`2^52`, and shifts of a 64-bit number by `44` never overflow 128 bits. -/

@[simp]
theorem zext_umulOverflow (x y : BitVec 64) : ¬(x.setWidth 128).umulOverflow (y.setWidth 128) := by
  bv_decide

@[simp]
theorem zext_mul_l0_umulOverflow (x : BitVec 64) :
    ¬(x.setWidth 128).umulOverflow 671914833335277#128 := by bv_decide

@[simp]
theorem zext_mul_l0_smulOverflow (x : BitVec 64) :
    ¬(x.setWidth 128).smulOverflow 671914833335277#128 := by bv_decide

@[simp]
theorem zext_mul_l1_umulOverflow (x : BitVec 64) :
    ¬(x.setWidth 128).umulOverflow 3916664325105025#128 := by bv_decide

@[simp]
theorem zext_mul_l1_smulOverflow (x : BitVec 64) :
    ¬(x.setWidth 128).smulOverflow 3916664325105025#128 := by bv_decide

@[simp]
theorem zext_mul_l2_umulOverflow (x : BitVec 64) : ¬(x.setWidth 128).umulOverflow 1367801#128 := by
  bv_decide

@[simp]
theorem zext_mul_l2_smulOverflow (x : BitVec 64) : ¬(x.setWidth 128).smulOverflow 1367801#128 := by
  bv_decide

@[simp]
theorem msb_and_mask (x : BitVec 64) : (x &&& 4503599627370495#64).msb = false := by bv_decide

@[simp]
theorem zext_shl44_ushiftRight (x : BitVec 64) : x.setWidth 128 <<< 44 >>> 44 = x.setWidth 128 := by
  bv_decide

@[simp]
theorem zext_shl44_sshiftRight (x : BitVec 64) :
    (x.setWidth 128 <<< 44).sshiftRight 44 = x.setWidth 128 := by bv_decide

/-- Five limbs. -/
def mk5 (x0 x1 x2 x3 x4 : BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => x0
  | ⟨1, _⟩ => x1
  | ⟨2, _⟩ => x2
  | ⟨3, _⟩ => x3
  | ⟨4, _⟩ => x4

-- 268 instructions in one block: the steps need more than 400000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `Scalar52::montgomery_mul(a, b)` stores `spec a b` at `out`, through `sub` of a stack temporary;
`limbs`' nine slots and the temporary leave ten blocks counted, `sub`'s `black_box` one more. The
loads all come before the stores, so `out` may alias `a` or `b`. -/
public theorem Scalar52_montgomery_mul.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    Scalar52_montgomery_mul.call (Scalar52_montgomery_mul.args (.value out) (.value a) (.value b))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 11⟩
            mem :=
              s.mem.storeLimbs out
                (Scalar52_montgomery_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  -- the inputs' limbs, read before the slots are allocated
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
  iterate 9 step_pure
  step_alloca with r
  step_alloca with limbs0
  step_alloca with limbs1
  step_alloca with limbs2
  step_alloca with limbs3
  step_alloca with limbs4
  step_alloca with limbs5
  step_alloca with limbs6
  step_alloca with limbs7
  step_alloca with limbs8
  iterate 9 step_pure
  -- `let mut limbs = Scalar52::mul_internal(a, b);`
  step_load [hra0] consuming hra0
  step_load [hrb0] consuming hrb0
  iterate 2 step_pure
  step_pure with z0
  step_pure
  step_load [hrb1] consuming hrb1
  iterate 2 step_pure
  step_pure
  step_load [hra1] consuming hra1
  iterate 2 step_pure
  step_pure with z1
  step_store
  step_pure
  step_load [hrb2] consuming hrb2
  iterate 4 step_pure
  step_pure
  step_load [hra2] consuming hra2
  iterate 2 step_pure
  step_pure with z2
  step_store
  step_pure
  step_load [hrb3] consuming hrb3
  iterate 4 step_pure
  step_pure
  step_load [hra3] consuming hra3
  iterate 4 step_pure
  step_pure with z3
  step_store
  step_pure
  step_load [hrb4] consuming hrb4
  iterate 5 step_pure
  step_pure
  step_load [hra4] consuming hra4
  iterate 5 step_pure
  step_pure with z4
  step_store
  iterate 6 step_pure
  step_pure with z5
  step_store
  iterate 4 step_pure
  step_pure with z6
  step_store
  iterate 2 step_pure
  step_pure with z7
  step_store
  step_pure with z8
  step_store
  -- `let product = Scalar52::montgomery_reduce(&limbs);`
  iterate 2 step_pure
  step_pure with n0
  have hn0m : n0.msb = false := by
    rw [hn0]; exact msb_and_mask _
  step_pure [hn0m]
  iterate 2 step_pure
  step_pure with carry0
  iterate 2 step_pure
  step_pure with sum1
  iterate 2 step_pure
  step_pure with n1
  have hn1m : n1.msb = false := by
    rw [hn1]; exact msb_and_mask _
  step_pure [hn1m]
  iterate 2 step_pure
  step_pure with carry1
  iterate 4 step_pure
  step_pure with sum2
  iterate 2 step_pure
  step_pure with n2
  have hn2m : n2.msb = false := by
    rw [hn2]; exact msb_and_mask _
  step_pure [hn2m]
  iterate 2 step_pure
  step_pure with carry2
  iterate 4 step_pure
  step_pure with sum3
  iterate 2 step_pure
  step_pure with n3
  have hn3m : n3.msb = false := by
    rw [hn3]; exact msb_and_mask _
  step_pure [hn3m]
  iterate 2 step_pure
  step_pure with carry3
  iterate 6 step_pure
  step_pure with sum4
  iterate 2 step_pure
  step_pure with n4
  have hn4m : n4.msb = false := by
    rw [hn4]; exact msb_and_mask _
  step_pure [hn4m]
  iterate 2 step_pure
  step_pure with carry4
  iterate 6 step_pure
  step_pure with sum5
  step_pure
  step_pure with transparent r0
  step_pure
  iterate 4 step_pure
  step_pure with sum6
  step_pure
  step_pure with transparent r1
  step_pure
  iterate 2 step_pure
  step_pure with sum7
  step_pure
  step_pure with transparent r2
  step_pure
  iterate 2 step_pure
  step_pure with sum8
  step_pure
  step_pure with transparent r3
  step_pure
  step_pure with transparent r4
  -- `Scalar52::sub(&Scalar52([r0, r1, r2, r3, r4]), l)`
  step_pure
  step_store
  iterate 4
    step_pure
    step_store
  have hr_limbs : S.mem.LimbsFit r :=
    ⟨by
      rw [hr_off]; decide, hfits_r, hfits_r_8, hfits_r_16, hfits_r_24, hfits_r_32⟩
  have hrl :
    S.mem.readLimbs r =
      mk5 (sum5.setWidth 64 &&& 0xfffffffffffff#64) (sum6.setWidth 64 &&& 0xfffffffffffff#64)
        (sum7.setWidth 64 &&& 0xfffffffffffff#64) (sum8.setWidth 64 &&& 0xfffffffffffff#64)
        ((sum8 >>> 52).setWidth 64) := by
    funext i
    fin_cases i
    exacts [hread_r, hread_r_8, hread_r_16, hread_r_24, hread_r_32]
  step_call using Scalar52_sub.call_eq [hrl]
  step_pure
  -- `limbs.zeroize()`
  iterate 9 step_store
  iterate 9 step_pure
  finish_block
  subst hS
  erase_frame
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial

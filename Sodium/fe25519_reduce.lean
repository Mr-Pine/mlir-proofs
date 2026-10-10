module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Sodium.Mlir.fe25519_reduce
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `f` reduced to its canonical limbs, named as in the C (`t[i]` as `ti`, 128 bits): two carry
passes, `+ 19` and a third pass, `+ 2^255 - 19` limbwise, a last pass without the top carry.
In the code's form: `t[0] += 19` added before the second pass's top carry, the third pass's top
carry after `2^51 - 19`, and `t[4]` masked only at the end. -/
def fe25519_reduce.spec (f : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#128
  let t0 := (f 0).setWidth 128
  let t1 := (f 1).setWidth 128
  let t2 := (f 2).setWidth 128
  let t3 := (f 3).setWidth 128
  let t4 := (f 4).setWidth 128
  -- t[1] += t[0] >> 51; t[0] &= mask; … t[0] += 19 * (t[4] >> 51); t[4] &= mask;
  let t1 := t0 >>> 51 + t1
  let t0 := t0 &&& mask
  let t2 := t1 >>> 51 + t2
  let t1 := t1 &&& mask
  let t3 := t2 >>> 51 + t3
  let t2 := t2 &&& mask
  let t4 := t3 >>> 51 + t4
  let t3 := t3 &&& mask
  let t0 := t4 >>> 51 * 19#128 + t0
  let t4 := t4 &&& mask
  -- again
  let t1 := t0 >>> 51 + t1
  let t0 := t0 &&& mask
  let t2 := t1 >>> 51 + t2
  let t1 := t1 &&& mask
  let t3 := t2 >>> 51 + t3
  let t2 := t2 &&& mask
  let t4 := t3 >>> 51 + t4
  let t3 := t3 &&& mask
  -- … t[0] += 19 * (t[4] >> 51); t[4] &= mask; t[0] += 19ULL;
  let t0 := t0 + 19#128 + t4 >>> 51 * 19#128
  let t4 := t4 &&& mask
  -- t[1] += t[0] >> 51; t[0] &= mask; … t[4] += t[3] >> 51; t[3] &= mask;
  let t1 := t0 >>> 51 + t1
  let t0 := t0 &&& mask
  let t2 := t1 >>> 51 + t2
  let t1 := t1 &&& mask
  let t3 := t2 >>> 51 + t3
  let t2 := t2 &&& mask
  let t4 := t3 >>> 51 + t4
  let t3 := t3 &&& mask
  -- t[0] += 19 * (t[4] >> 51) + 0x8000000000000 - 19ULL; t[1] += 0x8000000000000 - 1ULL; …
  let t0 := t0 + 0x7ffffffffffed#128 + t4 >>> 51 * 19#128
  let t1 := t1 + mask
  let t2 := t2 + mask
  let t3 := t3 + mask
  let t4 := t4 + mask
  -- t[1] += t[0] >> 51; … t[4] += t[3] >> 51; t[4] &= mask; h[i] = t[i] & mask;
  let t1 := t1 + t0 >>> 51
  let t2 := t2 + t1 >>> 51
  let t3 := t3 + t2 >>> 51
  let t4 := t4 + t3 >>> 51
  let mask := 0x7ffffffffffff#64
  fun
  | 0 => t0.setWidth 64 &&& mask
  | 1 => t1.setWidth 64 &&& mask
  | 2 => t2.setWidth 64 &&& mask
  | 3 => t3.setWidth 64 &&& mask
  | 4 => t4.setWidth 64 &&& mask

end

/-! ## Proof -/

section Proof

/-! The `nuw nsw` flags: every flagged operand is a carry (`x >> 51`, below `2^77`), a masked or
zero-extended limb, or one of these plus a constant or a carry, so no sum leaves 127 bits. -/

@[local simp]
theorem carry_add_limb_s (x : BitVec 128) (y : BitVec 64) :
    ¬(x >>> 51).saddOverflow (y.setWidth 128) := by bv_decide

@[local simp]
theorem carry_add_limb_u (x : BitVec 128) (y : BitVec 64) :
    ¬(x >>> 51).uaddOverflow (y.setWidth 128) := by bv_decide

@[local simp]
theorem carry_add_mask_s (x y : BitVec 128) :
    ¬(x >>> 51).saddOverflow (y &&& 2251799813685247#128) := by bv_decide

@[local simp]
theorem carry_add_mask_u (x y : BitVec 128) :
    ¬(x >>> 51).uaddOverflow (y &&& 2251799813685247#128) := by bv_decide

@[local simp]
theorem carry19_add_mask_s (x y : BitVec 128) :
    ¬(x >>> 51 * 19#128).saddOverflow (y &&& 2251799813685247#128) := by bv_decide

@[local simp]
theorem carry19_add_mask_u (x y : BitVec 128) :
    ¬(x >>> 51 * 19#128).uaddOverflow (y &&& 2251799813685247#128) := by bv_decide

@[local simp]
theorem mask_add_19_s (y : BitVec 128) : ¬(y &&& 2251799813685247#128).saddOverflow 19#128 := by
  bv_decide

@[local simp]
theorem mask_add_19_u (y : BitVec 128) : ¬(y &&& 2251799813685247#128).uaddOverflow 19#128 := by
  bv_decide

@[local simp]
theorem mask_add_19_add_carry19_s (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 19#128).saddOverflow (x >>> 51 * 19#128) := by bv_decide

@[local simp]
theorem mask_add_19_add_carry19_u (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 19#128).uaddOverflow (x >>> 51 * 19#128) := by bv_decide

@[local simp]
theorem mask_add_c0_s (y : BitVec 128) :
    ¬(y &&& 2251799813685247#128).saddOverflow 2251799813685229#128 := by bv_decide

@[local simp]
theorem mask_add_c0_u (y : BitVec 128) :
    ¬(y &&& 2251799813685247#128).uaddOverflow 2251799813685229#128 := by bv_decide

@[local simp]
theorem mask_add_c0_add_carry19_s (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 2251799813685229#128).saddOverflow (x >>> 51 * 19#128) := by
  bv_decide

@[local simp]
theorem mask_add_c0_add_carry19_u (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 2251799813685229#128).uaddOverflow (x >>> 51 * 19#128) := by
  bv_decide

@[local simp]
theorem mask_add_mask_s (y : BitVec 128) :
    ¬(y &&& 2251799813685247#128).saddOverflow 2251799813685247#128 := by bv_decide

@[local simp]
theorem mask_add_mask_u (y : BitVec 128) :
    ¬(y &&& 2251799813685247#128).uaddOverflow 2251799813685247#128 := by bv_decide

@[local simp]
theorem carry_add_mask_add_mask_s (x y : BitVec 128) :
    ¬(x >>> 51 + (y &&& 2251799813685247#128)).saddOverflow 2251799813685247#128 := by bv_decide

@[local simp]
theorem carry_add_mask_add_mask_u (x y : BitVec 128) :
    ¬(x >>> 51 + (y &&& 2251799813685247#128)).uaddOverflow 2251799813685247#128 := by bv_decide

@[local simp]
theorem mask_add_mask_add_carry_s (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 2251799813685247#128).saddOverflow (x >>> 51) := by bv_decide

@[local simp]
theorem mask_add_mask_add_carry_u (x y : BitVec 128) :
    ¬((y &&& 2251799813685247#128) + 2251799813685247#128).uaddOverflow (x >>> 51) := by bv_decide

@[local simp]
theorem carry_add_mask_add_mask_add_carry_s (x y z : BitVec 128) :
    ¬(x >>> 51 + (y &&& 2251799813685247#128) + 2251799813685247#128).saddOverflow (z >>> 51) := by
  bv_decide

@[local simp]
theorem carry_add_mask_add_mask_add_carry_u (x y z : BitVec 128) :
    ¬(x >>> 51 + (y &&& 2251799813685247#128) + 2251799813685247#128).uaddOverflow (z >>> 51) := by
  bv_decide

/-! The `trunc nuw nsw` of the last pass's limbs: each is below `2^53`, as the shapes of the
limbs it carries from show. -/

/-- `t[0]` before the last pass: a masked limb, `2^51 - 19` and a carry of a carry, times 19. -/
abbrev last0 (a p q : BitVec 128) : BitVec 128 :=
  (a &&& 2251799813685247#128) + 2251799813685229#128 +
    (p >>> 51 + (q &&& 2251799813685247#128)) >>> 51 * 19#128

/-- `t[1]` after the last pass. -/
abbrev last1 (y a p q : BitVec 128) : BitVec 128 :=
  (y &&& 2251799813685247#128) + 2251799813685247#128 + last0 a p q >>> 51

/-- `t[2]` after the last pass. -/
abbrev last2 (z y a p q : BitVec 128) : BitVec 128 :=
  (z &&& 2251799813685247#128) + 2251799813685247#128 + last1 y a p q >>> 51

/-- `t[3]` after the last pass. -/
abbrev last3 (w z y a p q : BitVec 128) : BitVec 128 :=
  (w &&& 2251799813685247#128) + 2251799813685247#128 + last2 z y a p q >>> 51

/-- `t[4]` after the last pass: unmasked, a carry of a carry plus a masked limb. -/
abbrev last4 (r s v w z y a p q : BitVec 128) : BitVec 128 :=
  (r >>> 51 + (s &&& 2251799813685247#128)) >>> 51 + (v &&& 2251799813685247#128) +
    2251799813685247#128 +
    last3 w z y a p q >>> 51

@[local simp]
theorem last0_zext (a p q : BitVec 128) :
    ((last0 a p q).setWidth 64).setWidth 128 = last0 a p q := by bv_decide

@[local simp]
theorem last0_sext (a p q : BitVec 128) :
    ((last0 a p q).setWidth 64).signExtend 128 = last0 a p q := by bv_decide

@[local simp]
theorem last1_zext (y a p q : BitVec 128) :
    ((last1 y a p q).setWidth 64).setWidth 128 = last1 y a p q := by bv_decide

@[local simp]
theorem last1_sext (y a p q : BitVec 128) :
    ((last1 y a p q).setWidth 64).signExtend 128 = last1 y a p q := by bv_decide

@[local simp]
theorem last2_zext (z y a p q : BitVec 128) :
    ((last2 z y a p q).setWidth 64).setWidth 128 = last2 z y a p q := by bv_decide

@[local simp]
theorem last2_sext (z y a p q : BitVec 128) :
    ((last2 z y a p q).setWidth 64).signExtend 128 = last2 z y a p q := by bv_decide

@[local simp]
theorem last3_zext (w z y a p q : BitVec 128) :
    ((last3 w z y a p q).setWidth 64).setWidth 128 = last3 w z y a p q := by bv_decide

@[local simp]
theorem last3_sext (w z y a p q : BitVec 128) :
    ((last3 w z y a p q).setWidth 64).signExtend 128 = last3 w z y a p q := by bv_decide

@[local simp]
theorem last4_zext (r s v w z y a p q : BitVec 128) :
    ((last4 r s v w z y a p q).setWidth 64).setWidth 128 = last4 r s v w z y a p q := by bv_decide

@[local simp]
theorem last4_sext (r s v w z y a p q : BitVec 128) :
    ((last4 r s v w z y a p q).setWidth 64).signExtend 128 = last4 r s v w z y a p q := by bv_decide

@[local simp]
theorem carry_mul19_s (x : BitVec 128) : ¬(x >>> 51).smulOverflow 19#128 := by bv_decide

@[local simp]
theorem carry_mul19_u (x : BitVec 128) : ¬(x >>> 51).umulOverflow 19#128 := by bv_decide

/-- `fe25519_reduce` stores `spec f` at `h`. The loads all come before the stores, so `h` may
alias `f`; the `nuw`/`nsw` flags never fire. -/
public theorem fe25519_reduce.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe25519_reduce.call (fe25519_reduce.args (.value h) (.value f)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs h (fe25519_reduce.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  iterate 5 step_pure
  -- t[0] = f[0]; … t[4] = f[4];
  step_load
  step_pure
  iterate 4 
    step_pure
    step_load
    step_pure
  iterate 61 step_pure
  -- h[0] = t[0]; … h[4] = t[4];
  iterate 2 step_pure
  step_store
  iterate 4 
    iterate 3 step_pure
    step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Sodium

module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Fe64
public import Firedancer.Crc.Ref.Fe64Carry
public import Firedancer.Crc.Ref.Mlir.crc_fe64_add_c
public import Firedancer.Crc.Ref.Mlir.crc_fe64_add_c_11
public import Firedancer.Crc.Ref.Mlir.crc_fe64_add_c_41
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sub_c
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sub_c_12
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sub_c_38
public import Firedancer.Crc.Ref.Mlir.crc_fe64_neg_c
public import Firedancer.Crc.Ref.Mlir.crc_fe64_neg_c_15
public import Firedancer.Crc.Ref.Mlir.crc_fe64_neg_c_31
import Std.Tactic.BVDecide

/-!
# `crc_fe64_add_c`, `crc_fe64_sub_c`, `crc_fe64_neg_c` refinements (MLIR lift ↔ spec)

Each copy stores `Fe64.add`, `Fe64.sub` or `Fe64.neg` of the 256-bit values at its inputs at `r`
(their values: `Fe64OpsMath`). The copies `_41` and `_38` are `add`/`sub` with `y` the constant
`1`, folded in by the compiler.
-/

namespace MLIR.Firedancer.Crc.Ref

namespace Fe64

@[expose] public section

/-- `crc_fe64_sbb`'s borrow out. -/
abbrev borrow (a b : BitVec 64) : BitVec 64 :=
  (BitVec.ofBool (a.usubOverflow b)).setWidth 64

/-- `crc_fe64_add_c( r, x, y )`'s `r`, in the program's operand order (C's names). -/
def add (X Y : BitVec 256) : BitVec 256 :=
  let x0 := X.extractLsb' 0 64
  let x1 := X.extractLsb' 64 64
  let x2 := X.extractLsb' 128 64
  let x3 := X.extractLsb' 192 64
  let y0 := Y.extractLsb' 0 64
  let y1 := Y.extractLsb' 64 64
  let y2 := Y.extractLsb' 128 64
  let y3 := Y.extractLsb' 192 64
  let t8_lo := x1 + y1
  let t8_hi := carry x1 y1
  let t15_lo := x2 + y2
  let t15_hi := carry x2 y2
  let t22_lo := x3 + y3
  let t22_hi := carry x3 y3
  let t1_lo := x0 + y0
  let t1_hi := carry x0 y0
  let t11_lo := t1_hi + t8_lo
  let t11_hi := carry t1_hi t8_lo ||| t8_hi
  let t18_lo := t11_hi + t15_lo
  let t18_hi := carry t11_hi t15_lo ||| t15_hi
  let t25_lo := t18_hi + t22_lo
  let t25_hi := carry t18_hi t22_lo ||| t22_hi
  let t34 := ((t25_hi ++ t25_lo) <<< 1).extractLsb' 64 64 * 19#64
  let t35_lo := t1_lo + t34
  let t35_hi := carry t1_lo t34
  let t44_lo := t11_lo + t35_hi
  let t44_hi := carry t11_lo t35_hi
  let t53_lo := t18_lo + t44_hi
  let t53_hi := carry t18_lo t44_hi
  let t61 := t53_hi + (t25_lo &&& 9223372036854775807#64)
  t61 ++ (t53_lo ++ (t44_lo ++ t35_lo))

/-- `crc_fe64_sub_c( r, x, y )`'s `r`, in the program's operand order (C's names): `2p - y` by a
borrow chain, then `add`'s carries and fold. -/
def sub (X Y : BitVec 256) : BitVec 256 :=
  let x0 := X.extractLsb' 0 64
  let x1 := X.extractLsb' 64 64
  let x2 := X.extractLsb' 128 64
  let x3 := X.extractLsb' 192 64
  let y0 := Y.extractLsb' 0 64
  let y1 := Y.extractLsb' 64 64
  let y2 := Y.extractLsb' 128 64
  let y3 := Y.extractLsb' 192 64
  let t2 := 18446744073709551578#64 - y0
  let t10 := borrow 18446744073709551578#64 y0
  let t12 := 18446744073709551615#64 - y1 - t10
  let t20 := borrow (18446744073709551615#64 - y1) t10
  let t21 := 18446744073709551615#64 - y2 - t20
  let t29 := borrow (18446744073709551615#64 - y2) t20
  let t30 := (y3 ^^^ 18446744073709551615#64) - t29
  let t13_lo := x1 + t12
  let t13_hi := carry x1 t12
  let t22_lo := x2 + t21
  let t22_hi := carry x2 t21
  let t31_lo := x3 + t30
  let t31_hi := carry x3 t30
  let t3_lo := x0 + t2
  let t3_hi := carry x0 t2
  let t16_lo := t3_hi + t13_lo
  let t16_hi := carry t3_hi t13_lo ||| t13_hi
  let t25_lo := t16_hi + t22_lo
  let t25_hi := carry t16_hi t22_lo ||| t22_hi
  let t34_lo := t25_hi + t31_lo
  let t34_hi := carry t25_hi t31_lo ||| t31_hi
  let t43 := ((t34_hi ++ t34_lo) <<< 1).extractLsb' 64 64 * 19#64
  let t44_lo := t3_lo + t43
  let t44_hi := carry t3_lo t43
  let t53_lo := t16_lo + t44_hi
  let t53_hi := carry t16_lo t44_hi
  let t62_lo := t25_lo + t53_hi
  let t62_hi := carry t25_lo t53_hi
  let t70 := t62_hi + (t34_lo &&& 9223372036854775807#64)
  t70 ++ (t62_lo ++ (t53_lo ++ t44_lo))

/-- `crc_fe64_neg_c( r, x )`'s `r`, in the program's operand order (C's names): `2p - x` by a
borrow chain, folded at `2^255`. -/
def neg (X : BitVec 256) : BitVec 256 :=
  let x0 := X.extractLsb' 0 64
  let x1 := X.extractLsb' 64 64
  let x2 := X.extractLsb' 128 64
  let x3 := X.extractLsb' 192 64
  let t2 := 18446744073709551578#64 - x0
  let t5 := borrow 18446744073709551578#64 x0
  let t18 := 18446744073709551615#64 - x1 - t5
  let t7 := borrow (18446744073709551615#64 - x1) t5
  let t26 := 18446744073709551615#64 - x2 - t7
  let t8 := borrow (18446744073709551615#64 - x2) t7
  let t9 := (x3 ^^^ 18446744073709551615#64) - t8
  let t12 := if BitVec.ofBool (t9.slt 0#64) = 1#1 then 19#64 else 0#64
  let t13_lo := t2 + t12
  let t13_hi := carry t2 t12
  let t21_lo := t18 + t13_hi
  let t21_hi := carry t18 t13_hi
  let t29_lo := t26 + t21_hi
  let t29_hi := carry t26 t21_hi
  let t37 := t29_hi + (t9 &&& 9223372036854775807#64)
  t37 ++ (t29_lo ++ (t21_lo ++ t13_lo))

end

end Fe64

open Fe64

/-! ## Proof -/

section Proof

theorem carry_or_carry_le (a b c d : BitVec 64) : carry a b ||| carry c d ≤ 1#64 := by bv_decide

/-- The fold's `(h << 1 | l >> 63) * 19` does not wrap for `h ≤ 1`. -/
theorem fold_umulOverflow {h l : BitVec 64} (hh : h ≤ 1#64) :
    (BitVec.extractLsb' 64 64 ((h ++ l) <<< 1)).umulOverflow 19#64 = false := by bv_decide

theorem fold_smulOverflow {h l : BitVec 64} (hh : h ≤ 1#64) :
    (BitVec.extractLsb' 64 64 ((h ++ l) <<< 1)).smulOverflow 19#64 = false := by bv_decide

/-- The top limb's `carry + (l & (2^63 - 1))` does not wrap. -/
@[local simp]
theorem carry_add_mask_uaddOverflow (a b l : BitVec 64) :
    (carry a b).uaddOverflow (l &&& 9223372036854775807#64) = false := by bv_decide

set_option hygiene false in
/-- The limb loads `h0 … h3` of the element at `hf`'s pointer as extracts of its 256 bits. -/
local macro "read_limbs " hf:ident ho:ident h0:ident h1:ident h2:ident h3:ident : tactic =>
  `(tactic|
    ( rw [readAt_limb0] at $h0:ident
      rw [readAt_limb (off := 8#64) $hf $ho (by decide)] at $h1:ident
      rw [readAt_limb (off := 16#64) $hf $ho (by decide)] at $h2:ident
      rw [readAt_limb (off := 24#64) $hf $ho (by decide)] at $h3:ident))

set_option hygiene false in
/-- The steps `add` and `sub` share after their four limb sums: the carry chain, the fold and the
stores. -/
local macro "add_fold " addc:ident : tactic =>
  `(tactic|
    (
      -- t11 = t8_hi | addc( t1_hi, t8_lo )
      step_pure
      step_load with u1 consuming hread_sa
      clear hfits_sa hroom_sa hwritable_sa hsa_bounds
      step_call using $addc
      step_pure with c1
      -- t18 = t15_hi | addc( t11_hi, t15_lo )
      step_pure
      step_load with u2 consuming hread_sb
      clear hfits_sb hroom_sb hwritable_sb hsb_bounds
      step_call using $addc
      step_pure with c2
      -- t25 = t22_hi | addc( t18_hi, t22_lo )
      step_pure
      step_load with u3 consuming hread_sc
      clear hfits_sc hroom_sc hwritable_sc hsc_bounds
      step_call using $addc
      step_pure with c3
      step_load with u3' consuming hread_s25
      clear hfits_s25 hroom_s25 hwritable_s25 hs25_bounds
      -- t33 = t25_hi * 2 + (t25_lo >> 63), t58 = t25_lo & (2^63 - 1), t34 = t33 * 19
      step_pure with transparent f
      step_pure with transparent m
      have hc3le : c3 ≤ 1#64 := by
        rw [hc3, hd3]; exact carry_or_carry_le ..
      step_pure [fold_umulOverflow hc3le, fold_smulOverflow hc3le] with f19
      -- t35 = addc( t1_lo, t34 ), t44 = addc( t11_lo, t35_hi ), t53 = addc( t18_lo, t44_hi )
      step_pure
      step_load with w0 consuming hread_sd
      clear hfits_sd hroom_sd hwritable_sd hsd_bounds
      step_call using $addc with e0
      step_pure
      step_load with w1 consuming hread_s11
      clear hfits_s11 hroom_s11 hwritable_s11 hs11_bounds
      step_call using $addc with e1
      step_pure
      step_load with w2 consuming hread_s18
      clear hfits_s18 hroom_s18 hwritable_s18 hs18_bounds
      step_call using $addc with transparent e2
      -- t61 = t58 + t53_hi
      step_pure with top
      -- r[0..3] = t35_lo, t44_lo, t53_lo, t61
      step_load consuming hread_s35
      clear hfits_s35 hroom_s35 hwritable_s35 hs35_bounds
      step_store
      step_load consuming hread_s44
      clear hfits_s44 hroom_s44 hwritable_s44 hs44_bounds
      step_pure
      step_store
      step_load consuming hread_s53
      clear hfits_s53 hroom_s53 hwritable_s53 hs53_bounds
      step_pure
      step_store
      step_pure
      step_store))

set_option hygiene false in
/-- The end of a kernel: the frame erased, the four stores as one, the values substituted. -/
local macro "finish_kernel" : tactic =>
  `(tactic|
    ( rw [hS]
      clear hS hread_r hread_r_8 hread_r_16 hread_r_24
      erase_frame
      simp only [storeAt_limbs hro, GlobalState.alloca_alloc]
      subst_vars
      rfl))

set_option hygiene false in
/-- `crc_fe64_add_c`'s steps, its callee `addc`. -/
local macro "add_walk " addc:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      iterate 4 step_pure
      step_alloca with sa
      step_alloca with sb
      step_alloca with sc
      step_alloca with sd
      step_alloca with s11
      step_alloca with s18
      step_alloca with s25
      step_alloca with s35
      step_alloca with s44
      step_alloca with s53
      -- t8 = addc( x[1], y[1] ), t15 = addc( x[2], y[2] ), t22 = addc( x[3], y[3] )
      step_pure
      step_pure
      step_load with x1
      step_pure
      step_load with y1
      step_call using $addc with d1
      step_pure
      step_pure
      step_load with x2
      step_pure
      step_load with y2
      step_call using $addc with d2
      step_pure
      step_pure
      step_load with x3
      step_pure
      step_load with y3
      step_call using $addc with d3
      -- t1 = addc( x[0], y[0] )
      step_pure
      step_load with x0
      step_load with y0
      step_call using $addc with d0
      add_fold $addc
      iterate 10 step_pure
      finish_block
      read_limbs hx₀ hxo hx0 hx1 hx2 hx3
      read_limbs hy₀ hyo hy0 hy1 hy2 hy3
      finish_kernel))

set_option hygiene false in
/-- `crc_fe64_sub_c`'s steps, its callees `subb`, `sbb`, `addc`. -/
local macro "sub_walk " subb:ident sbb:ident addc:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      iterate 5 step_pure
      step_alloca with b0
      step_alloca with b1
      step_alloca with b2
      step_alloca with sa
      step_alloca with sb
      step_alloca with sc
      step_alloca with sd
      step_alloca with s11
      step_alloca with s18
      step_alloca with s25
      step_alloca with s35
      step_alloca with s44
      step_alloca with s53
      -- t10 = subb( 2^64 - 38, y[0], &t2 )
      step_pure
      step_load with y0
      step_call using $subb with t10
      -- t20 = sbb( 2^64 - 1, y[1], t10, &t12 ), t29 = sbb( 2^64 - 1, y[2], t20, &t21 )
      step_pure
      step_pure
      step_load with y1
      step_call using $sbb with t20
      step_pure
      step_pure
      step_load with y2
      step_call using $sbb with t29
      -- t30 = 2^64 - 1 - y[3] - t29
      step_pure
      step_load with y3
      step_pure
      step_pure with t30
      -- t13 = addc( x[1], t12 ), t22 = addc( x[2], t21 ), t31 = addc( x[3], t30 )
      step_pure
      step_pure
      step_load with x1
      step_load with t12 consuming hread_b1
      clear hfits_b1 hroom_b1 hwritable_b1 hb1_bounds
      step_call using $addc with d1
      step_pure
      step_pure
      step_load with x2
      step_load with t21 consuming hread_b2
      clear hfits_b2 hroom_b2 hwritable_b2 hb2_bounds
      step_call using $addc with d2
      step_pure
      step_pure
      step_load with x3
      step_call using $addc with d3
      -- t3 = addc( x[0], t2 )
      step_pure
      step_load with x0
      step_load with t2 consuming hread_b0
      clear hfits_b0 hroom_b0 hwritable_b0 hb0_bounds
      step_call using $addc with d0
      add_fold $addc
      iterate 13 step_pure
      finish_block
      read_limbs hx₀ hxo hx0 hx1 hx2 hx3
      read_limbs hy₀ hyo hy0 hy1 hy2 hy3
      finish_kernel))

set_option hygiene false in
/-- `crc_fe64_neg_c`'s steps, its callees `subb`, `sbb`, `addc`. -/
local macro "neg_walk " subb:ident sbb:ident addc:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      iterate 5 step_pure
      step_alloca with b0
      step_alloca with b1
      step_alloca with b2
      step_alloca with s13
      step_alloca with s21
      step_alloca with s29
      -- t5 = subb( 2^64 - 38, x[0], &t2 )
      step_pure
      step_load with x0
      step_call using $subb with t5
      -- t7 = sbb( 2^64 - 1, x[1], t5, &t18 ), t8 = sbb( 2^64 - 1, x[2], t7, &t26 )
      step_pure
      step_pure
      step_load with x1
      step_call using $sbb with t7
      step_pure
      step_pure
      step_load with x2
      step_call using $sbb with t8
      -- t9 = 2^64 - 1 - x[3] - t8, t34 = t9 & (2^63 - 1), t12 = 19 (t9 >> 63)
      step_pure
      step_load with x3
      step_pure
      step_pure with transparent t9
      step_pure with transparent t34
      step_pure
      step_pure with t12
      -- t13 = addc( t2, t12 ), t21 = addc( t18, t13_hi ), t29 = addc( t26, t21_hi )
      step_pure
      step_load with t2 consuming hread_b0
      clear hfits_b0 hroom_b0 hwritable_b0 hb0_bounds
      step_call using $addc with t13_hi
      step_pure
      step_load with t18 consuming hread_b1
      clear hfits_b1 hroom_b1 hwritable_b1 hb1_bounds
      step_call using $addc with t21_hi
      step_pure
      step_load with t26 consuming hread_b2
      clear hfits_b2 hroom_b2 hwritable_b2 hb2_bounds
      step_call using $addc with transparent t29_hi
      -- t37 = t34 + t29_hi
      step_pure with t37
      -- r[0..3] = t13_lo, t21_lo, t29_lo, t37
      step_load consuming hread_s13
      clear hfits_s13 hroom_s13 hwritable_s13 hs13_bounds
      step_store
      step_load consuming hread_s21
      clear hfits_s21 hroom_s21 hwritable_s21 hs21_bounds
      step_pure
      step_store
      step_load consuming hread_s29
      clear hfits_s29 hroom_s29 hwritable_s29 hs29_bounds
      step_pure
      step_store
      step_pure
      step_store
      iterate 6 step_pure
      finish_block
      read_limbs hx₀ hxo hx0 hx1 hx2 hx3
      finish_kernel))

/-- `crc_fe64_add_c( r, x, y )` stores `add` of the values at `x` and `y` at `r`; its ten carry words
are frame slots. `r` may alias `x` or `y`. -/
public theorem crc_fe64_add_c.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_add_c.call (crc_fe64_add_c.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 10⟩
            mem := s.mem.storeAt r (Fe64.add (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  add_walk crc_fe64_addc.call_eq

public theorem crc_fe64_add_c_11.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_add_c_11.call (crc_fe64_add_c_11.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 10⟩
            mem := s.mem.storeAt r (Fe64.add (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  add_walk crc_fe64_addc_7.call_eq

-- 13 frame slots' facts carried through 70 steps: about 350000 heartbeats
set_option maxHeartbeats 400000 in
/-- `crc_fe64_sub_c( r, x, y )` stores `sub` of the values at `x` and `y` at `r`; its thirteen borrow
and carry words are frame slots. `r` may alias `x` or `y`. -/
public theorem crc_fe64_sub_c.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_sub_c.call (crc_fe64_sub_c.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 13⟩
            mem := s.mem.storeAt r (Fe64.sub (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  sub_walk crc_fe64_subb.call_eq crc_fe64_sbb.call_eq crc_fe64_addc.call_eq

-- as `crc_fe64_sub_c`
set_option maxHeartbeats 400000 in
public theorem crc_fe64_sub_c_12.call_eq (r x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hy : Fits s.mem y 256)
    (hro : ¬r.offset.uaddOverflow 32#64) (hxo : ¬x.offset.uaddOverflow 32#64)
    (hyo : ¬y.offset.uaddOverflow 32#64) :
    crc_fe64_sub_c_12.call (crc_fe64_sub_c_12.args (.value r) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 13⟩
            mem := s.mem.storeAt r (Fe64.sub (s.mem.readAt x 256) (s.mem.readAt y 256)) }) := by
  sub_walk crc_fe64_subb_13.call_eq crc_fe64_sbb_14.call_eq crc_fe64_addc_7.call_eq

/-- `crc_fe64_neg_c( r, x )` stores `neg` of the value at `x` at `r`; its six borrow and carry words
are frame slots. `r` may alias `x`. -/
public theorem crc_fe64_neg_c.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_neg_c.call (crc_fe64_neg_c.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩
            mem := s.mem.storeAt r (Fe64.neg (s.mem.readAt x 256)) }) := by
  neg_walk crc_fe64_subb.call_eq crc_fe64_sbb.call_eq crc_fe64_addc.call_eq

public theorem crc_fe64_neg_c_15.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_neg_c_15.call (crc_fe64_neg_c_15.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩
            mem := s.mem.storeAt r (Fe64.neg (s.mem.readAt x 256)) }) := by
  neg_walk crc_fe64_subb_13.call_eq crc_fe64_sbb_14.call_eq crc_fe64_addc_7.call_eq

public theorem crc_fe64_neg_c_31.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_neg_c_31.call (crc_fe64_neg_c_31.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩
            mem := s.mem.storeAt r (Fe64.neg (s.mem.readAt x 256)) }) := by
  neg_walk crc_fe64_subb_32.call_eq crc_fe64_sbb_33.call_eq crc_fe64_addc_34.call_eq

/-- `crc_fe64_add_c( r, x, crc_adx_one )`, the constant folded in: stores `add` of the value at `x`
and `1` at `r`. -/
public theorem crc_fe64_add_c_41.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_add_c_41.call (crc_fe64_add_c_41.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 10⟩
            mem := s.mem.storeAt r (Fe64.add (s.mem.readAt x 256) 1#256) }) := by
  func_init
  block_init
  iterate 5 step_pure
  step_alloca with sa
  step_alloca with sb
  step_alloca with sc
  step_alloca with sd
  step_alloca with s11
  step_alloca with s18
  step_alloca with s25
  step_alloca with s35
  step_alloca with s44
  step_alloca with s53
  -- t8 = addc( x[1], 0 ), t15 = addc( x[2], 0 ), t22 = addc( x[3], 0 ), t1 = addc( x[0], 1 )
  step_pure
  step_pure
  step_load with x1
  step_call using crc_fe64_addc_34.call_eq with d1
  step_pure
  step_pure
  step_load with x2
  step_call using crc_fe64_addc_34.call_eq with d2
  step_pure
  step_pure
  step_load with x3
  step_call using crc_fe64_addc_34.call_eq with d3
  step_pure
  step_load with x0
  step_call using crc_fe64_addc_34.call_eq with d0
  add_fold crc_fe64_addc_34.call_eq
  iterate 10 step_pure
  finish_block
  read_limbs hx₀ hxo hx0 hx1 hx2 hx3
  rw [hS]
  clear hS hread_r hread_r_8 hread_r_16 hread_r_24
  erase_frame
  simp only [storeAt_limbs hro, GlobalState.alloca_alloc]
  have h : top ++ (w2 + e1 ++ (w1 + e0 ++ (w0 + f19))) = Fe64.add (S₀.mem.readAt x 256) 1#256 := by
    clear hc3le
    subst_vars
    simp only [Fe64.add]
    bv_decide
  rw [h]

-- 13 frame slots' facts carried through 60 steps: over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `crc_fe64_sub_c( r, x, crc_adx_one )`, the constant folded in: stores `sub` of the value at `x`
and `1` at `r`. -/
public theorem crc_fe64_sub_c_38.call_eq (r x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hx : Fits s.mem x 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hxo : ¬x.offset.uaddOverflow 32#64) :
    crc_fe64_sub_c_38.call (crc_fe64_sub_c_38.args (.value r) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 13⟩
            mem := s.mem.storeAt r (Fe64.sub (s.mem.readAt x 256) 1#256) }) := by
  func_init
  block_init
  iterate 6 step_pure
  step_alloca with b0
  step_alloca with b1
  step_alloca with b2
  step_alloca with sa
  step_alloca with sb
  step_alloca with sc
  step_alloca with sd
  step_alloca with s11
  step_alloca with s18
  step_alloca with s25
  step_alloca with s35
  step_alloca with s44
  step_alloca with s53
  -- t10 = subb( 2^64 - 38, 1, &t2 ), t20 = sbb( 2^64 - 1, 0, t10, &t12 ), t29 = sbb( …, t20, &t21 )
  step_pure
  step_call using crc_fe64_subb_32.call_eq with t10
  step_pure
  step_call using crc_fe64_sbb_33.call_eq with t20
  step_pure
  step_call using crc_fe64_sbb_33.call_eq with t29
  -- t30 = 2^64 - 1 - 0 - t29
  step_pure with t30
  -- t13 = addc( x[1], t12 ), t22 = addc( x[2], t21 ), t31 = addc( x[3], t30 )
  step_pure
  step_pure
  step_load with x1
  step_load with t12 consuming hread_b1
  clear hfits_b1 hroom_b1 hwritable_b1 hb1_bounds
  step_call using crc_fe64_addc_34.call_eq with d1
  step_pure
  step_pure
  step_load with x2
  step_load with t21 consuming hread_b2
  clear hfits_b2 hroom_b2 hwritable_b2 hb2_bounds
  step_call using crc_fe64_addc_34.call_eq with d2
  step_pure
  step_pure
  step_load with x3
  step_call using crc_fe64_addc_34.call_eq with d3
  -- t3 = addc( x[0], t2 )
  step_pure
  step_load with x0
  step_load with t2 consuming hread_b0
  clear hfits_b0 hroom_b0 hwritable_b0 hb0_bounds
  step_call using crc_fe64_addc_34.call_eq with d0
  add_fold crc_fe64_addc_34.call_eq
  iterate 13 step_pure
  finish_block
  read_limbs hx₀ hxo hx0 hx1 hx2 hx3
  rw [hS]
  clear hS hread_r hread_r_8 hread_r_16 hread_r_24
  erase_frame
  simp only [storeAt_limbs hro, GlobalState.alloca_alloc]
  have h : top ++ (w2 + e1 ++ (w1 + e0 ++ (w0 + f19))) = Fe64.sub (S₀.mem.readAt x 256) 1#256 := by
    clear hc3le
    subst_vars
    simp only [Fe64.sub]
    bv_decide
  rw [h]

end Proof

end MLIR.Firedancer.Crc.Ref

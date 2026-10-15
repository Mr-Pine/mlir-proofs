module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_7
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_subb
public import Firedancer.Crc.Ref.Mlir.crc_fe64_subb_13
public import Firedancer.Crc.Ref.Mlir.crc_fe64_subb_32
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sbb
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sbb_14
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sbb_33
public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow
public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow_51
import Std.Tactic.BVDecide

/-!
# Carry and borrow helpers (MLIR lift ↔ spec)

`crc_fe64_addc`, `crc_fe64_subb`, `crc_fe64_sbb` (as specialized by the compiler: `subb`'s `a`
fixed to `2^64 - 38`, `sbb`'s to `2^64 - 1`) and `fd_ulong_sub_borrow`, each copy.
-/

namespace MLIR.Firedancer.Crc.Ref

/-- A helper's straight-line body: every instruction, then the return. -/
local macro "helper_walk" : tactic => `(tactic| (
  func_init
  block_init
  repeat (first | step_store | step_pure)
  finish_block
  subst_vars))

private theorem xor_allOnes (b : BitVec 64) : b ^^^ 18446744073709551615#64 = -1#64 - b := by
  bv_decide

section Proof

/-- `crc_fe64_addc( a, b, d )`: stores `a + b` at `d`, returns the carry. -/
public theorem crc_fe64_addc.call_eq (a b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_addc.call (crc_fe64_addc.args (.value a) (.value b) (.value d)) s =
      .value (.cons (.value ((BitVec.ofBool (a.uaddOverflow b)).setWidth 64)) .nil,
        { s with mem := s.mem.storeAt d (a + b) }) := by
  helper_walk
  rfl

@[inherit_doc crc_fe64_addc.call_eq]
public theorem crc_fe64_addc_7.call_eq (a b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_addc_7.call (crc_fe64_addc_7.args (.value a) (.value b) (.value d)) s =
      .value (.cons (.value ((BitVec.ofBool (a.uaddOverflow b)).setWidth 64)) .nil,
        { s with mem := s.mem.storeAt d (a + b) }) := by
  helper_walk
  rfl

@[inherit_doc crc_fe64_addc.call_eq]
public theorem crc_fe64_addc_34.call_eq (a b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_addc_34.call (crc_fe64_addc_34.args (.value a) (.value b) (.value d)) s =
      .value (.cons (.value ((BitVec.ofBool (a.uaddOverflow b)).setWidth 64)) .nil,
        { s with mem := s.mem.storeAt d (a + b) }) := by
  helper_walk
  rfl

/-- `crc_fe64_subb( 2^64 - 38, b, d )`: stores `2^64 - 38 - b` at `d`, returns the borrow. -/
public theorem crc_fe64_subb.call_eq (b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_subb.call (crc_fe64_subb.args (.value b) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((18446744073709551578#64).usubOverflow b)).setWidth 64))
          .nil, { s with mem := s.mem.storeAt d (18446744073709551578#64 - b) }) := by
  helper_walk
  rfl

@[inherit_doc crc_fe64_subb.call_eq]
public theorem crc_fe64_subb_13.call_eq (b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_subb_13.call (crc_fe64_subb_13.args (.value b) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((18446744073709551578#64).usubOverflow b)).setWidth 64))
          .nil, { s with mem := s.mem.storeAt d (18446744073709551578#64 - b) }) := by
  helper_walk
  rfl

@[inherit_doc crc_fe64_subb.call_eq]
public theorem crc_fe64_subb_32.call_eq (b : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_subb_32.call (crc_fe64_subb_32.args (.value b) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((18446744073709551578#64).usubOverflow b)).setWidth 64))
          .nil, { s with mem := s.mem.storeAt d (18446744073709551578#64 - b) }) := by
  helper_walk
  rfl

/-- `crc_fe64_sbb( 2^64 - 1, b, c, d )`: stores `2^64 - 1 - b - c` at `d`, returns the borrow
(`2^64 - 1 - b` never borrows). -/
public theorem crc_fe64_sbb.call_eq (b c : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_sbb.call (crc_fe64_sbb.args (.value b) (.value c) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((-1#64 - b).usubOverflow c)).setWidth 64)) .nil,
          { s with mem := s.mem.storeAt d (-1#64 - b - c) }) := by
  helper_walk
  rw [xor_allOnes]

@[inherit_doc crc_fe64_sbb.call_eq]
public theorem crc_fe64_sbb_14.call_eq (b c : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_sbb_14.call (crc_fe64_sbb_14.args (.value b) (.value c) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((-1#64 - b).usubOverflow c)).setWidth 64)) .nil,
          { s with mem := s.mem.storeAt d (-1#64 - b - c) }) := by
  helper_walk
  rw [xor_allOnes]

@[inherit_doc crc_fe64_sbb.call_eq]
public theorem crc_fe64_sbb_33.call_eq (b c : BitVec 64) (d : Pointer) (s : GlobalState)
    (hwf : s.WF) (hd : Room s.mem d 64) :
    crc_fe64_sbb_33.call (crc_fe64_sbb_33.args (.value b) (.value c) (.value d)) s =
      .value
        (.cons (.value ((BitVec.ofBool ((-1#64 - b).usubOverflow c)).setWidth 64)) .nil,
          { s with mem := s.mem.storeAt d (-1#64 - b - c) }) := by
  helper_walk
  rw [xor_allOnes]

/-- `fd_ulong_sub_borrow( r, b, a0, a1, bi )`: stores `a0 - a1 - (bi ≠ 0)` (`bi` cast to
`uchar`) at `r`, then the borrow out at `b`. -/
public theorem fd_ulong_sub_borrow.call_eq (r b : Pointer) (a0 a1 : BitVec 64) (bi : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 64) (hb : Room s.mem b 32) :
    fd_ulong_sub_borrow.call
        (fd_ulong_sub_borrow.args (.value r) (.value b) (.value a0) (.value a1) (.value bi)) s =
      .value (.nil,
        { s with
          mem :=
            (s.mem.storeAt r (a0 - a1 - .ofNat 64 (if bi.setWidth 8 = 0 then 0 else 1))).storeAt b
              ((if a0.toNat < a1.toNat + (if bi.setWidth 8 = 0 then 0 else 1) then 1#8
                else 0#8).setWidth 32) }) := by
  helper_walk
  rfl

@[inherit_doc fd_ulong_sub_borrow.call_eq]
public theorem fd_ulong_sub_borrow_51.call_eq (r b : Pointer) (a0 a1 : BitVec 64) (bi : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 64) (hb : Room s.mem b 32) :
    fd_ulong_sub_borrow.call
        (fd_ulong_sub_borrow_51.args (.value r) (.value b) (.value a0) (.value a1) (.value bi)) s =
      .value (.nil,
        { s with
          mem :=
            (s.mem.storeAt r (a0 - a1 - .ofNat 64 (if bi.setWidth 8 = 0 then 0 else 1))).storeAt b
              ((if a0.toNat < a1.toNat + (if bi.setWidth 8 = 0 then 0 else 1) then 1#8
                else 0#8).setWidth 32) }) := by
  helper_walk
  rfl

end Proof

end MLIR.Firedancer.Crc.Ref

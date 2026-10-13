module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fiat_25519_addcarryx_u51
public import Firedancer.Ref.fiat_25519_subborrowx_u51
public import Firedancer.Ref.fiat_25519_to_bytes
public import Boringssl.fiat_25519_cmovznz_u64
public import Boringssl.Mlir.fiat_25519_to_bytes
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

open Lean in
/-- Load the out-parameter `x` from its slot `p`, then drop `p`'s facts. -/
local macro "load_out " x:ident " from " p:ident : tactic =>
  let n := p.getId.toString
  `(tactic|
    ( step_load with $x:ident consuming $(mkIdent (.mkSimple s!"hread_{n}")):ident
      clear $(mkIdent (.mkSimple s!"hfits_{n}")) $(mkIdent (.mkSimple s!"hroom_{n}"))))

set_option hygiene false in
/-- `out1[k] = …`: the address, the store, then the store merged into the bytes before it, so the
state keeps one store at `out1`. -/
local macro "store_byte" : tactic =>
  `(tactic|
    ( step_pure
      step_store
      clear_reads
      rw [MemoryState.storeAt_storeAt_concat (BitVec.not_uaddOverflow_of_le hout1_off (by decide))
          (by decide)] at hS))

/-! ## Helpers -/

set_option maxHeartbeats 400000 in
/-- From `%1839` up to the lifetimes' ends: `x12 … x20`'s bytes, stored at `out1`, as
`pack x12 x14 x16 x18 x20`. -/
theorem fiat_25519_to_bytes.store_bytes {E : ⟪fiat_25519_to_bytes.Γ⟫} {S : GlobalState}
    {g : ⟪fiat_25519_to_bytes.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {out1 arg1 : Pointer}
    {x12 x14 x16 x18 x20 : BitVec 64}
    {px1 px2 px3 px4 px5 px6 px7 px8 px9 px10 px11 px12 px13 px14 px15 px16 px17 px18 px19 px20
      px21 : Pointer}
    (hArgs : E.args = (fiat_25519_to_bytes.args (.value out1) (.value arg1)).get)
    (hR :
      E ⊨ [%1770 := 8#64, %1772 := 16#64, %1773 := 24#64, %1774 := 32#64, %1779 := 40#64, %1780 :=
        48#64, %1781 := 255#64, %1782 := 56#64, %1831 := x20 <<< 4, %1833 := x18 <<< 1, %1835 :=
        x16 <<< 6, %1837 := x14 <<< 3, %1838 := x12])
    (hpx :
      E ⊨ [%1783 := px1, %1784 := px2, %1785 := px3, %1786 := px4, %1787 := px5, %1788 := px6,
        %1789 := px7, %1790 := px8, %1791 := px9, %1792 := px10, %1793 := px11, %1794 := px12,
        %1795 := px13, %1796 := px14, %1797 := px15, %1798 := px16, %1799 := px17, %1800 := px18,
        %1801 := px19, %1802 := px20, %1803 := px21])
    (hwf : S.WF) (hout1 : Room S.mem out1 (8 * 32)) (hout1_off : ¬out1.offset.uaddOverflow 32#64)
    (hK :
      ∀ E',
        E' ⊨ [%1783 := px1, %1784 := px2, %1785 := px3, %1786 := px4, %1787 := px5, %1788 := px6,
            %1789 := px7, %1790 := px8, %1791 := px9, %1792 := px10, %1793 := px11, %1794 := px12,
            %1795 := px13, %1796 := px14, %1797 := px15, %1798 := px16, %1799 := px17, %1800 :=
            px18, %1801 := px19, %1802 := px20, %1803 := px21] →
          (fiat_25519_to_bytes.entry.runBodyFrom E' 237
                { S with
                  mem :=
                    S.mem.storeAt out1
                      (Firedancer.Ref.fiat_25519_to_bytes.pack x12 x14 x16 x18 x20) } >>=
              g) =
            K) :
    (fiat_25519_to_bytes.entry.runBodyFrom E 104 S >>= g) = K := by
  -- x26 … x36: x12's low six bytes
  iterate 11 step_pure
  -- x38 = (x25 + (uint64_t)x37);
  step_pure
  step_pure
  step_pure with x38
  -- x39 … x49: x38's low six bytes
  iterate 11 step_pure
  -- x51 = (x24 + (uint64_t)x50);
  step_pure
  step_pure
  step_pure with x51
  -- x52 … x64: x51's low seven bytes
  iterate 13 step_pure
  -- x66 = (x23 + (uint64_t)x65);
  step_pure
  step_pure with x66
  -- x67 … x77: x66's low six bytes
  iterate 11 step_pure
  -- x79 = (x22 + (uint64_t)x78);
  step_pure
  step_pure
  step_pure with x79
  -- x80 … x91: x79's low seven bytes
  iterate 13 step_pure
  -- out1[0] = x26; … out1[31] = x91;
  step_store
  clear_reads
  iterate 31 store_byte
  rw [hS, Firedancer.Ref.fiat_25519_to_bytes.pack_eq hx38 hx51 hx66 hx79]
  exact hK E (by env_reads)

-- 106 steps early in a 260-instruction block (each step rescans the rest of the block): just under
-- 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `to_bytes` stores Firedancer's `fiat_25519_to_bytes.spec` (the same fiat-crypto C) of `arg1`'s
limbs at `out1` (32 bytes, one 256-bit value). The loads all come before the stores, so `out1` may
alias `arg1`. Its 21 out-parameter slots are freed again: only the counter moves on, by 21
blocks. -/
public theorem fiat_25519_to_bytes.call_eq (out1 arg1 : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout1 : Room s.mem out1 (8 * 32)) (hout1_off : ¬out1.offset.uaddOverflow 32#64)
    (harg1 : s.mem.LimbsFit arg1) :
    fiat_25519_to_bytes.call (fiat_25519_to_bytes.args (.value out1) (.value arg1)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 21⟩,
            mem :=
              s.mem.storeAt out1
                (Firedancer.Ref.fiat_25519_to_bytes.spec (s.mem.readLimbs arg1)) }) := by
  func_init
  -- `arg1`'s limbs as read facts, which the steps carry past the `alloca`s
  have harg1_0 : S.mem.readAt arg1 64 = S₀.mem.readLimbs arg1 0 := by
    rw [hS]; rfl
  have harg1_1 : S.mem.readAt (arg1.add 8#64) 64 = S₀.mem.readLimbs arg1 1 := by
    rw [hS]; rfl
  have harg1_2 : S.mem.readAt (arg1.add 16#64) 64 = S₀.mem.readLimbs arg1 2 := by
    rw [hS]; rfl
  have harg1_3 : S.mem.readAt (arg1.add 24#64) 64 = S₀.mem.readLimbs arg1 3 := by
    rw [hS]; rfl
  have harg1_4 : S.mem.readAt (arg1.add 32#64) 64 = S₀.mem.readLimbs arg1 4 := by
    rw [hS]; rfl
  block_init
  iterate 16 step_pure
  -- the out-parameters `x1 … x21`, each in its own slot `pxk`
  step_alloca with px1
  step_alloca with px2
  step_alloca with px3
  step_alloca with px4
  step_alloca with px5
  step_alloca with px6
  step_alloca with px7
  step_alloca with px8
  step_alloca with px9
  step_alloca with px10
  step_alloca with px11
  step_alloca with px12
  step_alloca with px13
  step_alloca with px14
  step_alloca with px15
  step_alloca with px16
  step_alloca with px17
  step_alloca with px18
  step_alloca with px19
  step_alloca with px20
  step_alloca with px21
  -- the slots' lifetimes start
  iterate 21 step_pure
  -- unused: the slots' offsets, `out1` apart from them, `arg1` apart from those written after
  -- its last load
  clear hout1_ne_px1 hout1_ne_px2 hout1_ne_px3 hout1_ne_px4 hout1_ne_px5 hout1_ne_px6 hout1_ne_px7
    hout1_ne_px8 hout1_ne_px9 hout1_ne_px10 hout1_ne_px11 hout1_ne_px12 hout1_ne_px13 hout1_ne_px14
    hout1_ne_px15 hout1_ne_px16 hout1_ne_px17 hout1_ne_px18 hout1_ne_px19 hout1_ne_px20
    hout1_ne_px21 hpx1_off hpx2_off hpx3_off hpx4_off hpx5_off hpx6_off hpx7_off hpx8_off hpx9_off
    hpx10_off hpx11_off hpx12_off hpx13_off hpx14_off hpx15_off hpx16_off hpx17_off hpx18_off
    hpx19_off hpx20_off hpx21_off hpx1_bounds hpx2_bounds hpx3_bounds hpx4_bounds hpx5_bounds
    hpx6_bounds hpx7_bounds hpx8_bounds hpx9_bounds hpx10_bounds hpx11_bounds hpx12_bounds
    hpx13_bounds hpx14_bounds hpx15_bounds hpx16_bounds hpx17_bounds hpx18_bounds hpx19_bounds
    hpx20_bounds hpx21_bounds harg1_ne_px9 harg1_ne_px10 harg1_ne_px11 harg1_ne_px12 harg1_ne_px13
    harg1_ne_px14 harg1_ne_px15 harg1_ne_px16 harg1_ne_px17 harg1_ne_px18 harg1_ne_px19
    harg1_ne_px20 harg1_ne_px21
  -- fiat_25519_subborrowx_u51(&x1, &x2, 0x0, (arg1[0]), UINT64_C(0x7ffffffffffed));
  step_load inline consuming harg1_0
  step_call using Firedancer.Ref.fiat_25519_subborrowx_u51.call_eq
  load_out x2 from px2
  -- fiat_25519_subborrowx_u51(&x3, &x4, x2, (arg1[1]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_1
  step_call using Firedancer.Ref.fiat_25519_subborrowx_u51.call_eq
  load_out x4 from px4
  -- fiat_25519_subborrowx_u51(&x5, &x6, x4, (arg1[2]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_2
  step_call using Firedancer.Ref.fiat_25519_subborrowx_u51.call_eq
  load_out x6 from px6
  -- fiat_25519_subborrowx_u51(&x7, &x8, x6, (arg1[3]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_3
  step_call using Firedancer.Ref.fiat_25519_subborrowx_u51.call_eq
  load_out x8 from px8
  -- fiat_25519_subborrowx_u51(&x9, &x10, x8, (arg1[4]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_4
  clear harg1 harg1_ne_px1 harg1_ne_px2 harg1_ne_px3 harg1_ne_px4 harg1_ne_px5 harg1_ne_px6
    harg1_ne_px7 harg1_ne_px8
  step_call using Firedancer.Ref.fiat_25519_subborrowx_u51.call_eq
  load_out x10 from px10
  -- fiat_25519_cmovznz_u64(&x11, x10, 0x0, UINT64_C(0xffffffffffffffff)); as `(&x11, x10)`
  step_call using fiat_25519_cmovznz_u64.call_eq
  -- fiat_25519_addcarryx_u51(&x12, &x13, 0x0, x1, (x11 & UINT64_C(0x7ffffffffffed)));
  load_out x1 from px1
  load_out x11 from px11
  step_pure
  step_call using Firedancer.Ref.fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x14, &x15, x13, x3, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x13 from px13
  load_out x3 from px3
  step_pure
  step_call using Firedancer.Ref.fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x16, &x17, x15, x5, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x15 from px15
  load_out x5 from px5
  step_call using Firedancer.Ref.fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x18, &x19, x17, x7, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x17 from px17
  load_out x7 from px7
  step_call using Firedancer.Ref.fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x20, &x21, x19, x9, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x19 from px19
  load_out x9 from px9
  step_call using Firedancer.Ref.fiat_25519_addcarryx_u51.call_eq
  -- x21, the last carry, is never read
  clear hread_px21 hfits_px21 hroom_px21
  -- x22 … x25: the limbs' shifts
  load_out x20 from px20
  step_pure
  load_out x18 from px18
  step_pure
  load_out x16 from px16
  step_pure
  load_out x14 from px14
  step_pure
  load_out x12 from px12
  -- x26 … x91, `out1[0] … out1[31]`
  step_pattern using fiat_25519_to_bytes.store_bytes
  -- the slots' lifetimes end; `out1`'s facts, apart from them, no longer needed
  clear hout1 hfits_out1
  iterate 21 step_pure
  finish_block
  subst hS
  erase_frame
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Boringssl

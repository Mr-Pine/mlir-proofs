module

public import MLIR.Run.Tactic
public import Common.Limbs
public import Common.Tactics
public import Firedancer.Ref.fiat_25519_addcarryx_u51
public import Firedancer.Ref.fiat_25519_subborrowx_u51
public import Firedancer.Ref.fiat_25519_cmovznz_u64
public import Firedancer.Ref.Mlir.fiat_25519_to_bytes
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- C's `x22 … x91`: the 51-bit limbs `x12 … x20` cut into 32 bytes, byte `k` at bits `8k …`. -/
def fiat_25519_to_bytes.pack (x12 x14 x16 x18 x20 : BitVec 64) : BitVec 256 :=
  let x22 := x20 <<< 4
  let x23 := x18 * 2
  let x24 := x16 <<< 6
  let x25 := x14 <<< 3
  let x26 := (x12 &&& 0xff).setWidth 8
  let x27 := x12 >>> 8
  let x28 := (x27 &&& 0xff).setWidth 8
  let x29 := x27 >>> 8
  let x30 := (x29 &&& 0xff).setWidth 8
  let x31 := x29 >>> 8
  let x32 := (x31 &&& 0xff).setWidth 8
  let x33 := x31 >>> 8
  let x34 := (x33 &&& 0xff).setWidth 8
  let x35 := x33 >>> 8
  let x36 := (x35 &&& 0xff).setWidth 8
  let x37 := (x35 >>> 8).setWidth 8
  let x38 := x25 + x37.setWidth 64
  let x39 := (x38 &&& 0xff).setWidth 8
  let x40 := x38 >>> 8
  let x41 := (x40 &&& 0xff).setWidth 8
  let x42 := x40 >>> 8
  let x43 := (x42 &&& 0xff).setWidth 8
  let x44 := x42 >>> 8
  let x45 := (x44 &&& 0xff).setWidth 8
  let x46 := x44 >>> 8
  let x47 := (x46 &&& 0xff).setWidth 8
  let x48 := x46 >>> 8
  let x49 := (x48 &&& 0xff).setWidth 8
  let x50 := (x48 >>> 8).setWidth 8
  let x51 := x24 + x50.setWidth 64
  let x52 := (x51 &&& 0xff).setWidth 8
  let x53 := x51 >>> 8
  let x54 := (x53 &&& 0xff).setWidth 8
  let x55 := x53 >>> 8
  let x56 := (x55 &&& 0xff).setWidth 8
  let x57 := x55 >>> 8
  let x58 := (x57 &&& 0xff).setWidth 8
  let x59 := x57 >>> 8
  let x60 := (x59 &&& 0xff).setWidth 8
  let x61 := x59 >>> 8
  let x62 := (x61 &&& 0xff).setWidth 8
  let x63 := x61 >>> 8
  let x64 := (x63 &&& 0xff).setWidth 8
  let x65 := (x63 >>> 8).setWidth 8
  let x66 := x23 + x65.setWidth 64
  let x67 := (x66 &&& 0xff).setWidth 8
  let x68 := x66 >>> 8
  let x69 := (x68 &&& 0xff).setWidth 8
  let x70 := x68 >>> 8
  let x71 := (x70 &&& 0xff).setWidth 8
  let x72 := x70 >>> 8
  let x73 := (x72 &&& 0xff).setWidth 8
  let x74 := x72 >>> 8
  let x75 := (x74 &&& 0xff).setWidth 8
  let x76 := x74 >>> 8
  let x77 := (x76 &&& 0xff).setWidth 8
  let x78 := (x76 >>> 8).setWidth 8
  let x79 := x22 + x78.setWidth 64
  let x80 := (x79 &&& 0xff).setWidth 8
  let x81 := x79 >>> 8
  let x82 := (x81 &&& 0xff).setWidth 8
  let x83 := x81 >>> 8
  let x84 := (x83 &&& 0xff).setWidth 8
  let x85 := x83 >>> 8
  let x86 := (x85 &&& 0xff).setWidth 8
  let x87 := x85 >>> 8
  let x88 := (x87 &&& 0xff).setWidth 8
  let x89 := x87 >>> 8
  let x90 := (x89 &&& 0xff).setWidth 8
  let x91 := (x89 >>> 8).setWidth 8
  x91 ++ x90 ++ x88 ++ x86 ++ x84 ++ x82 ++ x80 ++ x77 ++ x75 ++ x73 ++ x71 ++ x69 ++ x67 ++ x64 ++
    x62 ++
    x60 ++
    x58 ++
    x56 ++
    x54 ++
    x52 ++
    x49 ++
    x47 ++
    x45 ++
    x43 ++
    x41 ++
    x39 ++
    x36 ++
    x34 ++
    x32 ++
    x30 ++
    x28 ++
    x26

/-- The 32 bytes `out1[0] … out1[31]` (byte `k` at bits `8k …`): `arg1` minus `p` with borrows,
`p` added back if that borrowed, then packed. Named as in fiat-crypto's C. -/
def fiat_25519_to_bytes.spec (arg1 : Fin 5 → BitVec 64) : BitVec 256 :=
  let sub := fiat_25519_subborrowx_u51.spec
  let add := fiat_25519_addcarryx_u51.spec
  let (x1, x2) := sub 0 (arg1 0) 0x7ffffffffffed
  let (x3, x4) := sub x2 (arg1 1) 0x7ffffffffffff
  let (x5, x6) := sub x4 (arg1 2) 0x7ffffffffffff
  let (x7, x8) := sub x6 (arg1 3) 0x7ffffffffffff
  let (x9, x10) := sub x8 (arg1 4) 0x7ffffffffffff
  let x11 := fiat_25519_cmovznz_u64.spec x10 0 0xffffffffffffffff
  let (x12, x13) := add 0 x1 (x11 &&& 0x7ffffffffffed)
  let (x14, x15) := add x13 x3 (x11 &&& 0x7ffffffffffff)
  let (x16, x17) := add x15 x5 (x11 &&& 0x7ffffffffffff)
  let (x18, x19) := add x17 x7 (x11 &&& 0x7ffffffffffff)
  let (x20, _) := add x19 x9 (x11 &&& 0x7ffffffffffff)
  fiat_25519_to_bytes.pack x12 x14 x16 x18 x20

end

/-! ## Proof -/

section Proof

open Lean in
/-- Load the out-parameter `x` from its slot `p`, then drop `p`'s facts. -/
local macro "load_out " x:ident " from " p:ident : tactic =>
  let n := p.getId.toString
  `(tactic|
    ( step_load with $x:ident consuming $(mkIdent (.mkSimple s!"hread_{n}")):ident
      clear $(mkIdent (.mkSimple s!"h{n}_fits"))))

set_option hygiene false in
/-- `out1[k] = …`: the address, the store, then the store merged into the bytes before it, so the
state keeps one store at `out1`. -/
local macro "store_byte" : tactic =>
  `(tactic|
    ( step_pure
      step_store
      clear_reads
      rw [MemoryState.storeAt_storeAt_add (BitVec.not_uaddOverflow_of_le hout1_off (by decide))
          (by decide)] at hS))

/-! ## Staged for Common -/

private theorem insert_insert_self' (m : Std.ExtHashMap BlockId MemoryBlock) (k : BlockId)
    (v v' : MemoryBlock) : (m.insert k v).insert k v' = m.insert k v' := by
  apply Std.ExtHashMap.ext_getElem?
  intro a
  simp only [Std.ExtHashMap.getElem?_insert]
  split <;> rfl

/-- A store right after another: one store of both. -/
private theorem MemoryState.storeAt_storeAt_add {m : MemoryState} {p : Pointer} {off : BitVec 64}
    {x : BitVec v} {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (y ++ x) := by
  cases hblk : m[p.id]? with
  | none => simp [MemoryState.storeAt, hblk, Pointer.add_id]
  | some
    blk =>
    simp only [MemoryState.storeAt, hblk, MemoryState.getElem?_eq, Pointer.add_id,
      insert_insert_self', Std.ExtHashMap.getElem?_insert_self, Pointer.offsetInBits_add hov, hoff]
    congr 3
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append]
    grind

/-- The stored bytes, as the code computes them: `pack`'s. -/
theorem fiat_25519_to_bytes.pack_eq {x12 x14 x16 x18 x20 x38 x51 x66 x79 : BitVec 64}
    (hx38 : x38 = (x12 >>> 48 &&& 255#64) + x14 <<< 3)
    (hx51 : x51 = (x38 >>> 48 &&& 255#64) + x16 <<< 6) (hx66 : x66 = x51 >>> 56 + x18 <<< 1)
    (hx79 : x79 = (x66 >>> 48 &&& 255#64) + x20 <<< 4) :
    (x79 >>> 48).setWidth 8 ++
        ((x79 >>> 40).setWidth 8 ++
          ((x79 >>> 32).setWidth 8 ++
            ((x79 >>> 24).setWidth 8 ++
              ((x79 >>> 16).setWidth 8 ++
                ((x79 >>> 8).setWidth 8 ++
                  (x79.setWidth 8 ++
                    ((x66 >>> 40).setWidth 8 ++
                      ((x66 >>> 32).setWidth 8 ++
                        ((x66 >>> 24).setWidth 8 ++
                          ((x66 >>> 16).setWidth 8 ++
                            ((x66 >>> 8).setWidth 8 ++
                              (x66.setWidth 8 ++
                                ((x51 >>> 48).setWidth 8 ++
                                  ((x51 >>> 40).setWidth 8 ++
                                    ((x51 >>> 32).setWidth 8 ++
                                      ((x51 >>> 24).setWidth 8 ++
                                        ((x51 >>> 16).setWidth 8 ++
                                          ((x51 >>> 8).setWidth 8 ++
                                            (x51.setWidth 8 ++
                                              ((x38 >>> 40).setWidth 8 ++
                                                ((x38 >>> 32).setWidth 8 ++
                                                  ((x38 >>> 24).setWidth 8 ++
                                                    ((x38 >>> 16).setWidth 8 ++
                                                      ((x38 >>> 8).setWidth 8 ++
                                                        (x38.setWidth 8 ++
                                                          ((x12 >>> 40).setWidth 8 ++
                                                            ((x12 >>> 32).setWidth 8 ++
                                                              ((x12 >>> 24).setWidth 8 ++
                                                                ((x12 >>> 16).setWidth 8 ++
                                                                  ((x12 >>> 8).setWidth 8 ++
                                                                    x12.setWidth
                                                                      8)))))))))))))))))))))))))))))) =
      fiat_25519_to_bytes.pack x12 x14 x16 x18 x20 := by
  subst hx38 hx51 hx66 hx79
  simp only [fiat_25519_to_bytes.pack]
  bv_decide

-- 154 steps late in a 260-instruction block: just under 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- From `%74` on: `x12 … x20`'s bytes, stored at `out1`, as `pack x12 x14 x16 x18 x20`. -/
theorem fiat_25519_to_bytes.store_bytes {E : ⟪fiat_25519_to_bytes.Γ⟫} {S : GlobalState}
    {g : ⟪fiat_25519_to_bytes.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {out1 arg1 : Pointer}
    {x12 x14 x16 x18 x20 : BitVec 64}
    (hArgs : E.args = (fiat_25519_to_bytes.args (.value out1) (.value arg1)).get)
    (hR :
      E ⊨ [%10 := 8#64, %11 := 16#64, %12 := 24#64, %13 := 32#64, %14 := 40#64, %15 := 48#64, %16 :=
        255#64, %17 := 56#64, %66 := x20 <<< 4, %68 := x18 <<< 1, %70 := x16 <<< 6, %72 :=
        x14 <<< 3, %73 := x12])
    (hwf : S.WF) (hout1 : Fits S.mem out1 (8 * 32)) (hout1_off : ¬out1.offset.uaddOverflow 32#64)
    (hK :
      ∀ E',
        (fiat_25519_to_bytes.entry.runBodyFrom E' 260
              { S with
                mem := S.mem.storeAt out1 (fiat_25519_to_bytes.pack x12 x14 x16 x18 x20) } >>=
            g) =
          K) :
    (fiat_25519_to_bytes.entry.runBodyFrom E 106 S >>= g) = K := by
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
  -- the slots' lifetimes end
  iterate 21 step_pure
  rw [hS, fiat_25519_to_bytes.pack_eq hx38 hx51 hx66 hx79]
  exact hK E

-- 106 steps early in a 260-instruction block (each step rescans the rest of the block): just under
-- 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `to_bytes` stores `spec` of `arg1`'s limbs at `out1` (32 bytes, one 256-bit value). The loads
all come before the stores, so `out1` may alias `arg1`. Its 21 out-parameter slots are freed again:
only the counter moves on, by 21 blocks. -/
public theorem fiat_25519_to_bytes.call_eq (out1 arg1 : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout1 : Fits s.mem out1 (8 * 32)) (hout1_off : ¬out1.offset.uaddOverflow 32#64)
    (harg1 : s.mem.LimbsFit arg1) :
    fiat_25519_to_bytes.call (fiat_25519_to_bytes.args (.value out1) (.value arg1)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 21⟩,
            mem := s.mem.storeAt out1 (fiat_25519_to_bytes.spec (s.mem.readLimbs arg1)) }) := by
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
  iterate 18 step_pure
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
  -- unused: the slots' offsets, `out1` apart from them, `arg1` apart from those written after
  -- its last load
  clear hout1_ne_px1 hout1_ne_px2 hout1_ne_px3 hout1_ne_px4 hout1_ne_px5 hout1_ne_px6 hout1_ne_px7
    hout1_ne_px8 hout1_ne_px9 hout1_ne_px10 hout1_ne_px11 hout1_ne_px12 hout1_ne_px13 hout1_ne_px14
    hout1_ne_px15 hout1_ne_px16 hout1_ne_px17 hout1_ne_px18 hout1_ne_px19 hout1_ne_px20
    hout1_ne_px21 hpx1_off hpx2_off hpx3_off hpx4_off hpx5_off hpx6_off hpx7_off hpx8_off hpx9_off
    hpx10_off hpx11_off hpx12_off hpx13_off hpx14_off hpx15_off hpx16_off hpx17_off hpx18_off
    hpx19_off hpx20_off hpx21_off harg1_ne_px9 harg1_ne_px10 harg1_ne_px11 harg1_ne_px12
    harg1_ne_px13 harg1_ne_px14 harg1_ne_px15 harg1_ne_px16 harg1_ne_px17 harg1_ne_px18
    harg1_ne_px19 harg1_ne_px20 harg1_ne_px21
  iterate 21 step_pure
  -- fiat_25519_subborrowx_u51(&x1, &x2, 0x0, (arg1[0]), UINT64_C(0x7ffffffffffed));
  step_load inline consuming harg1_0
  step_call using fiat_25519_subborrowx_u51.call_eq
  load_out x2 from px2
  -- fiat_25519_subborrowx_u51(&x3, &x4, x2, (arg1[1]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_1
  step_call using fiat_25519_subborrowx_u51.call_eq
  load_out x4 from px4
  -- fiat_25519_subborrowx_u51(&x5, &x6, x4, (arg1[2]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_2
  step_call using fiat_25519_subborrowx_u51.call_eq
  load_out x6 from px6
  -- fiat_25519_subborrowx_u51(&x7, &x8, x6, (arg1[3]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_3
  step_call using fiat_25519_subborrowx_u51.call_eq
  load_out x8 from px8
  -- fiat_25519_subborrowx_u51(&x9, &x10, x8, (arg1[4]), UINT64_C(0x7ffffffffffff));
  step_pure
  step_load inline consuming harg1_4
  clear harg1 harg1_ne_px1 harg1_ne_px2 harg1_ne_px3 harg1_ne_px4 harg1_ne_px5 harg1_ne_px6
    harg1_ne_px7 harg1_ne_px8
  step_call using fiat_25519_subborrowx_u51.call_eq
  load_out x10 from px10
  -- fiat_25519_cmovznz_u64(&x11, x10, 0x0, UINT64_C(0xffffffffffffffff));
  step_call using fiat_25519_cmovznz_u64.call_eq
  -- fiat_25519_addcarryx_u51(&x12, &x13, 0x0, x1, (x11 & UINT64_C(0x7ffffffffffed)));
  load_out x1 from px1
  load_out x11 from px11
  step_pure
  step_call using fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x14, &x15, x13, x3, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x13 from px13
  load_out x3 from px3
  step_pure
  step_call using fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x16, &x17, x15, x5, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x15 from px15
  load_out x5 from px5
  step_call using fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x18, &x19, x17, x7, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x17 from px17
  load_out x7 from px7
  step_call using fiat_25519_addcarryx_u51.call_eq
  -- fiat_25519_addcarryx_u51(&x20, &x21, x19, x9, (x11 & UINT64_C(0x7ffffffffffff)));
  load_out x19 from px19
  load_out x9 from px9
  step_call using fiat_25519_addcarryx_u51.call_eq
  -- x21, the last carry, is never read
  clear hread_px21 hpx21_fits
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
  -- x26 … x91, `out1[0] … out1[31]`, the lifetimes' ends
  step_pattern using fiat_25519_to_bytes.store_bytes
  finish_block
  subst hS
  erase_frame
  clear_reads
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Ref

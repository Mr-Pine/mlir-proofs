module

public import MLIR.Run.Tactic
public import Std.Tactic.BVDecide
public meta import Std.Tactic.BVDecide.Reflect
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fiat_25519_from_bytes
public import Boringssl.Mlir.fiat_25519_from_bytes

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `xk = ((uint64_t)(arg1[i]) << n)`: the byte's `getelementptr`, `load`, `zext` and `shl`. -/
local macro "byte_shl " x:ident : tactic =>
  `(tactic|
    ( step_pure
      step_load
      step_pure
      step_pure [byte_shiftLeft_ushiftRight, byte_shiftLeft_sshiftRight] with $x:ident))

open Firedancer.Ref (byte_shiftLeft_ushiftRight byte_shiftLeft_sshiftRight
  MemoryState.readAt_of_readAt_low)
open Firedancer.Ref.fiat_25519_from_bytes (x39_eq x47_eq x13to19 x7to12 x55_no_overflow x55_eq
  x63_no_overflow x63_eq mask_eq byteAt x39_disjoint x47_disjoint x55_disjoint x63_disjoint)

/-! ### The limbs -/

/-- With bit 255 clear, byte 31 is its low seven bits. -/
theorem fiat_25519_from_bytes.x1_mask {x : BitVec 256} (h : x.msb = false) :
    (x.extractLsb' 248 8).setWidth 64 = (x.extractLsb' 248 8).setWidth 64 &&& 127#64 := by bv_decide

/-- `x1 … x6` as the code ors them. -/
abbrev fiat_25519_from_bytes.x1to6 (x : BitVec 256) : BitVec 64 :=
  BitVec.setWidth 64 (x.extractLsb' 240 8) <<< 36 |||
    (BitVec.setWidth 64 (x.extractLsb' 248 8) &&& 127#64) <<< 44 |||
    BitVec.setWidth 64 (x.extractLsb' 232 8) <<< 28 |||
    BitVec.setWidth 64 (x.extractLsb' 224 8) <<< 20 |||
    BitVec.setWidth 64 (x.extractLsb' 216 8) <<< 12 |||
    BitVec.setWidth 64 (x.extractLsb' 208 8) <<< 4

/-- `x71`'s `add nsw nuw` holds: `x1 … x6` stay below `2^51`. -/
theorem fiat_25519_from_bytes.x71_no_overflow (x : BitVec 256) (y : BitVec 64) :
    ¬(x1to6 x).saddOverflow (y >>> 51) ∧ ¬(x1to6 x).uaddOverflow (y >>> 51) := by bv_decide

/-- Limb 3's carry plus `x1 … x6` (byte 31 as its low seven bits): bits `204 … 254`. -/
theorem fiat_25519_from_bytes.x71_eq {x : BitVec 256} (h : y = (x.extractLsb' 153 55).setWidth 64) :
    x1to6 x + y >>> 51 = (x.extractLsb' 204 51).setWidth 64 := by
  subst h
  bv_decide

/-- `x1 | … | x6`'s `or disjoint`s hold. -/
theorem fiat_25519_from_bytes.x71_disjoint (x : BitVec 256) :
    byteAt x 240 <<< 36 &&& (byteAt x 248 &&& 127#64) <<< 44 = 0#64 ∧
      (byteAt x 240 <<< 36 ||| (byteAt x 248 &&& 127#64) <<< 44) &&& byteAt x 232 <<< 28 = 0#64 ∧
      (byteAt x 240 <<< 36 ||| (byteAt x 248 &&& 127#64) <<< 44 ||| byteAt x 232 <<< 28) &&&
          byteAt x 224 <<< 20 =
        0#64 ∧
      (byteAt x 240 <<< 36 ||| (byteAt x 248 &&& 127#64) <<< 44 ||| byteAt x 232 <<< 28 |||
            byteAt x 224 <<< 20) &&&
          byteAt x 216 <<< 12 =
        0#64 ∧
      (byteAt x 240 <<< 36 ||| (byteAt x 248 &&& 127#64) <<< 44 ||| byteAt x 232 <<< 28 |||
            byteAt x 224 <<< 20 |||
            byteAt x 216 <<< 12) &&&
          byteAt x 208 <<< 4 =
        0#64 := by
  bv_decide

-- 194 instructions in one block: the steps need more than 300000 heartbeats
set_option maxHeartbeats 400000 in
/-- `fiat_25519_from_bytes` stores Firedancer's `fiat_25519_from_bytes.spec` of the 32 bytes at
`arg1` as limbs at `out1`. BoringSSL's fiat code does not mask bit 255 (`arg1[31] & 0x7F`), so it
must be clear. The loads all come before the stores, so `out1` may alias `arg1`. -/
public theorem fiat_25519_from_bytes.call_eq (out1 arg1 : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout1 : s.mem.LimbsRoom out1) (harg1 : Fits s.mem arg1 (8 * 32))
    (harg1_off : ¬arg1.offset.uaddOverflow 32#64) (hmsb : (s.mem.readAt arg1 256).msb = false) :
    fiat_25519_from_bytes.call (fiat_25519_from_bytes.args (.value out1) (.value arg1)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out1
                (Firedancer.Ref.fiat_25519_from_bytes.spec (s.mem.readAt arg1 256)) }) := by
  func_init
  -- the 32 bytes, read once: each byte load is a slice of `x`
  obtain ⟨x, hx⟩ : ∃ x, S₀.mem.readAt arg1 256 = x := ⟨_, rfl⟩
  rw [hx]
  rw [hS, hx] at hmsb
  rw [← hS] at hx
  block_init
  -- the constants
  iterate 34 step_pure
  -- x1 = ((uint64_t)(arg1[31]) << 44); bit 255 is clear
  byte_shl x1
  rw [x1_mask hmsb] at hx1
  -- x2 = ((uint64_t)(arg1[30]) << 36); … x28 = ((uint64_t)(arg1[4]) << 32);
  byte_shl x2
  byte_shl x3
  byte_shl x4
  byte_shl x5
  byte_shl x6
  byte_shl x7
  byte_shl x8
  byte_shl x9
  byte_shl x10
  byte_shl x11
  byte_shl x12
  byte_shl x13
  byte_shl x14
  byte_shl x15
  byte_shl x16
  byte_shl x17
  byte_shl x18
  byte_shl x19
  byte_shl x20
  byte_shl x21
  byte_shl x22
  byte_shl x23
  byte_shl x24
  byte_shl x25
  byte_shl x26
  byte_shl x27
  byte_shl x28
  -- x39 = (x38 & UINT64_C(0x7ffffffffffff)); the code ors `arg1[0 … 3]` (one 32-bit load), `x27`,
  -- `x28` and `x26`'s low bits
  have hw := MemoryState.readAt_of_readAt_low (w := 32) harg1 (by decide) hx
  step_load consuming hw
  iterate 4 step_pure
  step_pure [hx26, hx27, hx28, x39_disjoint] with x39
  rw [x39_eq] at hx39
  -- x47 = (x46 & UINT64_C(0x7ffffffffffff)); the code ors `x40` (`arg1[6] >> 3`), `x21 … x25` and
  -- `x20`'s low bits
  iterate 7 step_pure
  step_pure [hx20, hx21, hx22, hx23, hx24, hx25, x47_disjoint] with x47
  rw [x47_eq] at hx47
  -- x55 = (x13 + x54); the code adds `x48` (`arg1[12] >> 6`) to `x13 | … | x19`
  iterate 7 step_pure
  step_pure [hx13, hx14, hx15, hx16, hx17, hx18, hx19, x55_disjoint, x55_no_overflow] with x55
  rw [x55_eq] at hx55
  -- x56 = (x55 & UINT64_C(0x7ffffffffffff));
  step_pure with x56
  rw [mask_eq hx55] at hx56
  -- x63 = (x7 + x62); the code adds `x57` (`x55 >> 51`) to `x7 | … | x12`
  iterate 6 step_pure
  step_pure [hx7, hx8, hx9, hx10, hx11, hx12, x63_disjoint, x63_no_overflow] with x63
  rw [x63_eq hx55] at hx63
  -- x64 = (x63 & UINT64_C(0x7ffffffffffff));
  step_pure with x64
  rw [mask_eq hx63] at hx64
  -- x71 = (x1 + x70); the code adds `x65` (`x63 >> 51`) to `x1 | … | x6`
  iterate 6 step_pure
  step_pure [hx1, hx2, hx3, hx4, hx5, hx6, x71_disjoint, x71_no_overflow] with x71
  rw [x71_eq hx63] at hx71
  -- out1[0] = x39; … out1[4] = x71;
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  clear_reads
  subst_vars
  rw [Firedancer.Ref.fiat_25519_from_bytes.spec_eq]
  rfl

end Proof

end MLIR.Boringssl

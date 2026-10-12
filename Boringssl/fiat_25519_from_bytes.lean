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

/-! ### Helpers -/

/-- A byte shifted left by at most `55` bits shifts back. -/
theorem byte_shiftLeft_ushiftRight (b : BitVec 8) (h : s ≤ 55) :
    (b.setWidth 64 <<< s) >>> s = b.setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_ushiftRight, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
  by_cases hi8 : i < 8
  · simp
    omega
  · simp [BitVec.getLsbD_of_ge b i (by omega)]

/-- A byte shifted left by at most `55` bits stays nonnegative, so it shifts back signed too. -/
theorem byte_shiftLeft_sshiftRight (b : BitVec 8) (h : s ≤ 55) :
    (b.setWidth 64 <<< s).sshiftRight s = b.setWidth 64 := by
  rw [BitVec.sshiftRight_eq_of_msb_false, byte_shiftLeft_ushiftRight b h]
  simp only [BitVec.msb_eq_getLsbD_last, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
  simp [BitVec.getLsbD_of_ge b (63 - s) (by omega)]

/-- A read at the start of a known read: its low bits. -/
theorem MemoryState.readAt_of_readAt_low {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hfits : Fits m p v) (hw : w ≤ v) (h : m.readAt p v = x) :
    m.readAt p w = x.extractLsb' 0 w := by
  have :=
    MemoryState.readAt_add_of_readAt (off := 0#64) hfits.inBounds
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simpa using hw) h
  simpa [Pointer.add] using this

/-! ### The limbs -/

/-- With bit 255 clear, byte 31 is its low seven bits. -/
theorem fiat_25519_from_bytes.x1_mask {x : BitVec 256} (h : x.msb = false) :
    (x.extractLsb' 248 8).setWidth 64 = (x.extractLsb' 248 8).setWidth 64 &&& 127#64 := by bv_decide

/-- Limb 0 as the code builds it: bits `0 … 50`. -/
theorem fiat_25519_from_bytes.x39_eq (x : BitVec 256) :
    (BitVec.setWidth 64 (x.extractLsb' 40 8) <<< 40 ||| BitVec.setWidth 64 (x.extractLsb' 0 32) |||
        BitVec.setWidth 64 (x.extractLsb' 32 8) <<< 32 |||
        BitVec.setWidth 64 (x.extractLsb' 48 8) <<< 48 &&& 1970324836974592#64) =
      (x.extractLsb' 0 51).setWidth 64 := by
  bv_decide

/-- Limb 1 as the code builds it: bits `51 … 101`. -/
theorem fiat_25519_from_bytes.x47_eq (x : BitVec 256) :
    (BitVec.setWidth 64 (x.extractLsb' 88 8) <<< 37 |||
        BitVec.setWidth 64 (x.extractLsb' 96 8) <<< 45 &&& 2216615441596416#64 |||
        BitVec.setWidth 64 (x.extractLsb' 80 8) <<< 29 |||
        BitVec.setWidth 64 (x.extractLsb' 72 8) <<< 21 |||
        BitVec.setWidth 64 (x.extractLsb' 64 8) <<< 13 |||
        BitVec.setWidth 64 (x.extractLsb' 56 8) <<< 5 |||
        BitVec.setWidth 64 (x.extractLsb' 48 8) >>> 3) =
      (x.extractLsb' 51 51).setWidth 64 := by
  bv_decide

/-- `x13 … x19` as the code ors them. -/
abbrev fiat_25519_from_bytes.x13to19 (x : BitVec 256) : BitVec 64 :=
  BitVec.setWidth 64 (x.extractLsb' 144 8) <<< 42 |||
    BitVec.setWidth 64 (x.extractLsb' 152 8) <<< 50 |||
    BitVec.setWidth 64 (x.extractLsb' 136 8) <<< 34 |||
    BitVec.setWidth 64 (x.extractLsb' 128 8) <<< 26 |||
    BitVec.setWidth 64 (x.extractLsb' 120 8) <<< 18 |||
    BitVec.setWidth 64 (x.extractLsb' 112 8) <<< 10 |||
    BitVec.setWidth 64 (x.extractLsb' 104 8) <<< 2

/-- `x7 … x12` as the code ors them. -/
abbrev fiat_25519_from_bytes.x7to12 (x : BitVec 256) : BitVec 64 :=
  BitVec.setWidth 64 (x.extractLsb' 192 8) <<< 39 |||
    BitVec.setWidth 64 (x.extractLsb' 200 8) <<< 47 |||
    BitVec.setWidth 64 (x.extractLsb' 184 8) <<< 31 |||
    BitVec.setWidth 64 (x.extractLsb' 176 8) <<< 23 |||
    BitVec.setWidth 64 (x.extractLsb' 168 8) <<< 15 |||
    BitVec.setWidth 64 (x.extractLsb' 160 8) <<< 7

/-- `x1 … x6` as the code ors them. -/
abbrev fiat_25519_from_bytes.x1to6 (x : BitVec 256) : BitVec 64 :=
  BitVec.setWidth 64 (x.extractLsb' 240 8) <<< 36 |||
    (BitVec.setWidth 64 (x.extractLsb' 248 8) &&& 127#64) <<< 44 |||
    BitVec.setWidth 64 (x.extractLsb' 232 8) <<< 28 |||
    BitVec.setWidth 64 (x.extractLsb' 224 8) <<< 20 |||
    BitVec.setWidth 64 (x.extractLsb' 216 8) <<< 12 |||
    BitVec.setWidth 64 (x.extractLsb' 208 8) <<< 4

/-- `x55`'s `add nsw nuw` holds: `x13 … x19` stay below `2^58`. -/
theorem fiat_25519_from_bytes.x55_no_overflow (x : BitVec 256) :
    ¬(x13to19 x).saddOverflow (BitVec.setWidth 64 (x.extractLsb' 96 8) >>> 6) ∧
      ¬(x13to19 x).uaddOverflow (BitVec.setWidth 64 (x.extractLsb' 96 8) >>> 6) := by
  bv_decide

/-- Byte 12's top bits plus `x13 … x19`: bits `102 … 159`. -/
theorem fiat_25519_from_bytes.x55_eq (x : BitVec 256) :
    x13to19 x + BitVec.setWidth 64 (x.extractLsb' 96 8) >>> 6 =
      (x.extractLsb' 102 58).setWidth 64 := by
  bv_decide

/-- `x63`'s `add nsw nuw` holds: `x7 … x12` stay below `2^55`. -/
theorem fiat_25519_from_bytes.x63_no_overflow (x : BitVec 256) (y : BitVec 64) :
    ¬(x7to12 x).saddOverflow (y >>> 51) ∧ ¬(x7to12 x).uaddOverflow (y >>> 51) := by bv_decide

/-- Limb 2's carry plus `x7 … x12`: bits `153 … 207`. -/
theorem fiat_25519_from_bytes.x63_eq {x : BitVec 256} (h : y = (x.extractLsb' 102 58).setWidth 64) :
    x7to12 x + y >>> 51 = (x.extractLsb' 153 55).setWidth 64 := by
  subst h
  bv_decide

/-- `x71`'s `add nsw nuw` holds: `x1 … x6` stay below `2^51`. -/
theorem fiat_25519_from_bytes.x71_no_overflow (x : BitVec 256) (y : BitVec 64) :
    ¬(x1to6 x).saddOverflow (y >>> 51) ∧ ¬(x1to6 x).uaddOverflow (y >>> 51) := by bv_decide

/-- Limb 3's carry plus `x1 … x6` (byte 31 as its low seven bits): bits `204 … 254`. -/
theorem fiat_25519_from_bytes.x71_eq {x : BitVec 256} (h : y = (x.extractLsb' 153 55).setWidth 64) :
    x1to6 x + y >>> 51 = (x.extractLsb' 204 51).setWidth 64 := by
  subst h
  bv_decide

/-- A carried limb masked: its low `51` bits. -/
theorem fiat_25519_from_bytes.mask_eq {x : BitVec 256} (h : y = (x.extractLsb' k n).setWidth 64)
    (hn : 51 ≤ n := by decide) : y &&& 2251799813685247#64 = (x.extractLsb' k 51).setWidth 64 := by
  subst h
  rw [show 2251799813685247#64 = (BitVec.allOnes 51).setWidth 64 by decide]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_setWidth, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_allOnes]
  by_cases h51 : i < 51
  · simp [h51, hi, Nat.lt_of_lt_of_le h51 hn]
  · simp [h51]

/-- Bits `i … i + 7` of `x`, widened. -/
abbrev fiat_25519_from_bytes.byteAt (x : BitVec 256) (i : Nat) : BitVec 64 :=
  (x.extractLsb' i 8).setWidth 64

/-- `x39`'s `or disjoint`s hold: `arg1[0 … 3]`, `x27`, `x28` and `x26`'s low bits do not overlap. -/
theorem fiat_25519_from_bytes.x39_disjoint (x : BitVec 256) :
    byteAt x 40 <<< 40 &&& BitVec.setWidth 64 (x.extractLsb' 0 32) = 0#64 ∧
      (byteAt x 40 <<< 40 ||| BitVec.setWidth 64 (x.extractLsb' 0 32)) &&& byteAt x 32 <<< 32 =
        0#64 ∧
      (byteAt x 40 <<< 40 ||| BitVec.setWidth 64 (x.extractLsb' 0 32) ||| byteAt x 32 <<< 32) &&&
          (byteAt x 48 <<< 48 &&& 1970324836974592#64) =
        0#64 := by
  bv_decide

/-- `x47`'s `or disjoint`s hold: `x40`, `x21 … x25` and `x20`'s low bits do not overlap. -/
theorem fiat_25519_from_bytes.x47_disjoint (x : BitVec 256) :
    byteAt x 88 <<< 37 &&& (byteAt x 96 <<< 45 &&& 2216615441596416#64) = 0#64 ∧
      (byteAt x 88 <<< 37 ||| (byteAt x 96 <<< 45 &&& 2216615441596416#64)) &&& byteAt x 80 <<< 29 =
        0#64 ∧
      (byteAt x 88 <<< 37 ||| (byteAt x 96 <<< 45 &&& 2216615441596416#64) |||
            byteAt x 80 <<< 29) &&&
          byteAt x 72 <<< 21 =
        0#64 ∧
      (byteAt x 88 <<< 37 ||| (byteAt x 96 <<< 45 &&& 2216615441596416#64) |||
            byteAt x 80 <<< 29 |||
            byteAt x 72 <<< 21) &&&
          byteAt x 64 <<< 13 =
        0#64 ∧
      (byteAt x 88 <<< 37 ||| (byteAt x 96 <<< 45 &&& 2216615441596416#64) |||
            byteAt x 80 <<< 29 |||
            byteAt x 72 <<< 21 |||
            byteAt x 64 <<< 13) &&&
          byteAt x 56 <<< 5 =
        0#64 ∧
      (byteAt x 88 <<< 37 ||| (byteAt x 96 <<< 45 &&& 2216615441596416#64) |||
            byteAt x 80 <<< 29 |||
            byteAt x 72 <<< 21 |||
            byteAt x 64 <<< 13 |||
            byteAt x 56 <<< 5) &&&
          byteAt x 48 >>> 3 =
        0#64 := by
  bv_decide

/-- `x13 | … | x19`'s `or disjoint`s hold. -/
theorem fiat_25519_from_bytes.x55_disjoint (x : BitVec 256) :
    byteAt x 144 <<< 42 &&& byteAt x 152 <<< 50 = 0#64 ∧
      (byteAt x 144 <<< 42 ||| byteAt x 152 <<< 50) &&& byteAt x 136 <<< 34 = 0#64 ∧
      (byteAt x 144 <<< 42 ||| byteAt x 152 <<< 50 ||| byteAt x 136 <<< 34) &&&
          byteAt x 128 <<< 26 =
        0#64 ∧
      (byteAt x 144 <<< 42 ||| byteAt x 152 <<< 50 ||| byteAt x 136 <<< 34 |||
            byteAt x 128 <<< 26) &&&
          byteAt x 120 <<< 18 =
        0#64 ∧
      (byteAt x 144 <<< 42 ||| byteAt x 152 <<< 50 ||| byteAt x 136 <<< 34 |||
            byteAt x 128 <<< 26 |||
            byteAt x 120 <<< 18) &&&
          byteAt x 112 <<< 10 =
        0#64 ∧
      (byteAt x 144 <<< 42 ||| byteAt x 152 <<< 50 ||| byteAt x 136 <<< 34 |||
            byteAt x 128 <<< 26 |||
            byteAt x 120 <<< 18 |||
            byteAt x 112 <<< 10) &&&
          byteAt x 104 <<< 2 =
        0#64 := by
  bv_decide

/-- `x7 | … | x12`'s `or disjoint`s hold. -/
theorem fiat_25519_from_bytes.x63_disjoint (x : BitVec 256) :
    byteAt x 192 <<< 39 &&& byteAt x 200 <<< 47 = 0#64 ∧
      (byteAt x 192 <<< 39 ||| byteAt x 200 <<< 47) &&& byteAt x 184 <<< 31 = 0#64 ∧
      (byteAt x 192 <<< 39 ||| byteAt x 200 <<< 47 ||| byteAt x 184 <<< 31) &&&
          byteAt x 176 <<< 23 =
        0#64 ∧
      (byteAt x 192 <<< 39 ||| byteAt x 200 <<< 47 ||| byteAt x 184 <<< 31 |||
            byteAt x 176 <<< 23) &&&
          byteAt x 168 <<< 15 =
        0#64 ∧
      (byteAt x 192 <<< 39 ||| byteAt x 200 <<< 47 ||| byteAt x 184 <<< 31 |||
            byteAt x 176 <<< 23 |||
            byteAt x 168 <<< 15) &&&
          byteAt x 160 <<< 7 =
        0#64 := by
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

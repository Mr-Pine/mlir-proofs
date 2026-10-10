module

public import MLIR.Run.Tactic
public import Agave.Serial.black_box_u8
public import Agave.Serial.Mlir.slice_u8_ConstantTimeEq_ct_eq
public import Std.Tactic.BVDecide
public meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- Byte `i` of 32 bytes. -/
abbrev byte32 (x : BitVec 256) (i : Nat) : BitVec 8 :=
  x.extractLsb' (8 * i) 8

/-- `x` after `i` bytes of `for (ai, bi) in … { x &= ai.ct_eq(bi).unwrap_u8(); }`, from `x = 1`;
`u8::ct_eq` is `ai == bi` as a `u8` (through `black_box`, which returns it). -/
def slice_u8_ConstantTimeEq_ct_eq.acc (a b : BitVec 256) : Nat → BitVec 8
  | 0 => 1#8
  | i + 1 =>
    (BitVec.ofBool (byte32 a i == byte32 b i)).setWidth 8 &&&
      slice_u8_ConstantTimeEq_ct_eq.acc a b i

/-- `<[u8] as ConstantTimeEq>::ct_eq` on 32 bytes. -/
abbrev slice_u8_ConstantTimeEq_ct_eq.spec (a b : BitVec 256) : BitVec 8 :=
  slice_u8_ConstantTimeEq_ct_eq.acc a b 32

end

/-- `spec a b` is `1` if the bytes are equal, else `0`. -/
public theorem slice_u8_ConstantTimeEq_ct_eq.spec_eq (a b : BitVec 256) :
    slice_u8_ConstantTimeEq_ct_eq.spec a b = if a = b then 1#8 else 0#8 := by
  simp only [slice_u8_ConstantTimeEq_ct_eq.spec, slice_u8_ConstantTimeEq_ct_eq.acc, byte32]
  bv_decide

/-! ## Proof -/

section Proof

/-- `x &= a[i].ct_eq(b[i]).unwrap_u8();` for `i > 0`, the new `x` named. -/
local macro "byte_eq " x:ident : tactic =>
  `(tactic|
    ( step_pure
      step_pure
      step_load
      step_load
      step_pure
      step_pure
      step_call using black_box_u8.call_eq
      step_pure with $x:ident))

/-- Byte `k` of a 256-bit read. -/
theorem readAt_byte {m : MemoryState} {p : Pointer} (h : InBounds m p 256)
    (hov : ¬p.offset.uaddOverflow 32#64) (k : Nat) (hk : k < 32) :
    m.readAt (p.add (BitVec.ofNat 64 k)) 8 = byte32 (m.readAt p 256) k := by
  rw [MemoryState.readAt_add_of_readAt (w := 8) h
      (BitVec.not_uaddOverflow_of_le hov
        (by
          simp; omega))
      (by
        simp; omega)
      rfl]
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), byte32]
  congr 1
  omega

/-- Byte 0 of a 256-bit read. -/
theorem readAt_byte0 {m : MemoryState} {p : Pointer} : m.readAt p 8 = byte32 (m.readAt p 256) 0 :=
  (MemoryState.readAt_of_readAt_le (v := 256) (by decide) rfl).trans
    (by
      ext; simp [byte32])

/-- `a.ct_eq(b)` on two 32-byte arrays returns `spec a b`, `1` iff they are equal
(`spec_eq`). Each byte's `black_box` frees its slot again: only the counter moves on, by 33
blocks. -/
public theorem slice_u8_ConstantTimeEq_ct_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 256) (ha_off : ¬a.offset.uaddOverflow 32#64) (hb : Fits s.mem b 256)
    (hb_off : ¬b.offset.uaddOverflow 32#64) :
    slice_u8_ConstantTimeEq_ct_eq.call (slice_u8_ConstantTimeEq_ct_eq.args (.value a) (.value b))
        s =
      .value
        (.cons
            (.value (slice_u8_ConstantTimeEq_ct_eq.spec (s.mem.readAt a 256) (s.mem.readAt b 256)))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 33⟩, mem := s.mem }) := by
  func_init
  have ha₀ := ha₀.inBounds
  have hb₀ := hb₀.inBounds
  block_init
  -- x &= a[0].ct_eq(b[0]).unwrap_u8();
  step_pure
  step_load
  step_load
  step_pure
  step_pure
  step_call using black_box_u8.call_eq
  step_pure with x0
  -- x &= a[i].ct_eq(b[i]).unwrap_u8(); for i = 1 … 31
  byte_eq x1
  byte_eq x2
  byte_eq x3
  byte_eq x4
  byte_eq x5
  byte_eq x6
  byte_eq x7
  byte_eq x8
  byte_eq x9
  byte_eq x10
  byte_eq x11
  byte_eq x12
  byte_eq x13
  byte_eq x14
  byte_eq x15
  byte_eq x16
  byte_eq x17
  byte_eq x18
  byte_eq x19
  byte_eq x20
  byte_eq x21
  byte_eq x22
  byte_eq x23
  byte_eq x24
  byte_eq x25
  byte_eq x26
  byte_eq x27
  byte_eq x28
  byte_eq x29
  byte_eq x30
  byte_eq x31
  -- x.into()
  step_call using black_box_u8.call_eq
  finish_block
  subst hS
  erase_frame
  subst_vars
  simp (disch := decide) only [readAt_byte ha₀ ha_off, readAt_byte hb₀ hb_off, readAt_byte0]
  rfl

end Proof

end MLIR.Agave.Serial

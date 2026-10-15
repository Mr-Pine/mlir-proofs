module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Fe64
public import Firedancer.Crc.Ref.Fe64Canon
public import Firedancer.Crc.Ref.Mlir.crc_adx_store8_le
public import Firedancer.Crc.Ref.Mlir.crc_adx_store8_le_6
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sgn
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sgn_3
public import Firedancer.Crc.Ref.Mlir.crc_fe64_sgn_43
public import Firedancer.Crc.Ref.Mlir.crc_fe64_is_zero
public import Firedancer.Crc.Ref.Mlir.crc_fe64_eq
public import Firedancer.Crc.Ref.Mlir.crc_fe64_eq_48
public import Firedancer.Crc.Ref.Mlir.crc_fe64_frombytes
public import Firedancer.Crc.Ref.Mlir.crc_fe64_frombytes_36
public import Firedancer.Crc.Ref.Mlir.crc_fe64_tobytes
import Std.Tactic.BVDecide

/-!
# Byte conversion and checks over `crc_fe64_canon` (MLIR lift ↔ spec)

Every copy of `crc_adx_store8_le`, `crc_fe64_frombytes` (the 32 bytes with bit 255 cleared),
`crc_fe64_tobytes` (the canonical value's 32 bytes), `crc_fe64_eq`, `crc_fe64_is_zero` and
`crc_fe64_sgn`, stated in terms of `Fe64.canon` (its value: `Fe64CanonMath`).
-/

namespace MLIR.Firedancer.Crc.Ref

namespace Fe64

@[expose] public section

/-- `crc_fe64_frombytes( r, b )`'s `r`: the 256 bits at `b` with bit 255 cleared. -/
def frombytes (B : BitVec 256) : BitVec 256 :=
  (B.setWidth 255).setWidth 256

end

end Fe64

open Fe64

section Proof

set_option hygiene false in
/-- An iteration of `crc_fe64_frombytes`'s loop: `r[i] = load8_le( b + 8*i )`, the load named. -/
local macro "frombytes_iter " x:ident : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_pure
      step_load with $x:ident
      step_pure
      step_store
      step_pure
      step_pure
      finish_block))

set_option hygiene false in
/-- `crc_fe64_frombytes`'s steps, any copy. -/
local macro "frombytes_proof" : tactic =>
  `(tactic|
    ( func_init
      have hr₀ : Room S₀.mem r 256 := hS ▸ hr
      have hb₀ : Fits S₀.mem b 256 := hS ▸ hb
      block_init
      iterate 5 step_pure
      finish_block
      -- `r[i] = load8_le( b + 8*i )`
      frombytes_iter b0
      frombytes_iter b1
      frombytes_iter b2
      frombytes_iter b3
      -- `r[3] &= 0x7fffffffffffffff`
      block_init
      step_pure
      step_load with r3
      step_pure
      step_store
      finish_block
      rw [readAt_limb0] at hb0
      rw [readAt_limb (off := 8#64) hb₀ hbo (by decide)] at hb1
      rw [readAt_limb (off := 16#64) hb₀ hbo (by decide)] at hb2
      rw [readAt_limb (off := 24#64) hb₀ hbo (by decide)] at hb3
      rw [hS, MemoryState.storeAt_storeAt_self, storeAt_limbs hro, hb0, hb1, hb2, hb3,
        frombytes_limbs]))

set_option hygiene false in
/-- `crc_fe64_eq`'s steps, its `canon` copy's `call_eq` given. -/
local macro "eq_proof " canon:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      step_pure
      step_alloca with ca
      step_alloca with cb
      step_pure
      step_pure
      step_call using $canon
      step_call using $canon
      step_load with x0
      step_load with y0
      step_pure
      step_load with x1
      step_pure
      step_load with y1
      step_pure
      step_load with x2
      step_pure
      step_load with y2
      step_pure
      step_load with x3
      step_pure
      step_load with y3
      iterate 10 step_pure
      finish_block
      rw [hS]
      clear hS hread_ca hread_cb
      erase_frame
      rw [hx0, hx1, hx2, hx3, hy0, hy1, hy2, hy3, eq_bits]
      simp only [GlobalState.alloca_alloc]))

set_option hygiene false in
/-- An iteration of `crc_fe64_tobytes`'s loop: `store8_le( out + 8*i, c[i] )`. -/
local macro "tobytes_iter" : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_pure
      step_pure
      step_load
      step_call using crc_adx_store8_le_6.call_eq
      step_pure
      step_pure
      finish_block))

set_option hygiene false in
/-- `crc_fe64_sgn`'s steps, its `canon` copy's `call_eq` given. -/
local macro "sgn_proof " canon:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      step_pure
      step_alloca with cs
      step_pure
      step_call using $canon
      step_load with c0
      step_pure
      step_pure
      step_pure
      finish_block
      rw [hS]
      clear hS hread_cs
      erase_frame
      rw [hc0, BitVec.setWidth_setWidth_of_le _ (by decide)]
      simp only [GlobalState.alloca_alloc]))

/-- The four limbs or-ed are zero exactly when the value is. -/
theorem is_zero_bits (C : BitVec 256) :
    (BitVec.ofBool
            (C.extractLsb' 64 64 ||| C.setWidth 64 ||| C.extractLsb' 128 64 |||
                C.extractLsb' 192 64 ==
              0#64)).setWidth
        32 =
      if C = 0#256 then 1#32 else 0#32 := by
  bv_decide

/-- The four limbs compared are all equal exactly when the values are. -/
theorem eq_bits (C D : BitVec 256) :
    (BitVec.ofBool
            (C.setWidth 64 == D.setWidth 64 && C.extractLsb' 64 64 == D.extractLsb' 64 64 &&
              C.extractLsb' 128 64 == D.extractLsb' 128 64 &&
              C.extractLsb' 192 64 == D.extractLsb' 192 64)).setWidth
        32 =
      if C = D then 1#32 else 0#32 := by
  bv_decide

/-- The four limbs, the top one masked, are `frombytes`; at the offsets `readAt_limb` gives. -/
theorem frombytes_limbs (B : BitVec 256) :
    (B.extractLsb' ((24#64).toNat * 8) 64 &&& 9223372036854775807#64) ++
        (B.extractLsb' ((16#64).toNat * 8) 64 ++
          (B.extractLsb' ((8#64).toNat * 8) 64 ++ B.extractLsb' 0 64)) =
      frombytes B := by
  have h :
    (B.extractLsb' 192 64 &&& 9223372036854775807#64) ++
        (B.extractLsb' 128 64 ++ (B.extractLsb' 64 64 ++ B.extractLsb' 0 64)) =
      frombytes B := by
    simp only [frombytes]
    bv_decide
  exact h

/-- The four limbs of `C`, reassembled, the low one as `setWidth`. -/
theorem limbs_setWidth (C : BitVec 256) :
    C.extractLsb' 192 64 ++ (C.extractLsb' 128 64 ++ (C.extractLsb' 64 64 ++ C.setWidth 64)) =
      C := by
  bv_decide

/-- `crc_adx_store8_le( p, v )` stores `v` little-endian at `p`. -/
public theorem crc_adx_store8_le.call_eq (p : Pointer) (v : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hp : Room s.mem p 64) :
    crc_adx_store8_le.call (crc_adx_store8_le.args (.value p) (.value v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p v }) := by
  func_init
  block_init
  step_store
  finish_block
  rw [hS]

@[inherit_doc crc_adx_store8_le.call_eq]
public theorem crc_adx_store8_le_6.call_eq (p : Pointer) (v : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hp : Room s.mem p 64) :
    crc_adx_store8_le_6.call (crc_adx_store8_le_6.args (.value p) (.value v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p v }) := by
  func_init
  block_init
  step_store
  finish_block
  rw [hS]

/-- `crc_fe64_frombytes( r, b )` stores `frombytes` of the 32 bytes at `b` at `r`, a block other
than `b`'s. -/
public theorem crc_fe64_frombytes.call_eq (r b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hb : Fits s.mem b 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hbo : ¬b.offset.uaddOverflow 32#64) (hrb : r.id ≠ b.id) :
    crc_fe64_frombytes.call (crc_fe64_frombytes.args (.value r) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeAt r (frombytes (s.mem.readAt b 256)) }) := by
  frombytes_proof

@[inherit_doc crc_fe64_frombytes.call_eq]
public theorem crc_fe64_frombytes_36.call_eq (r b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 256) (hb : Fits s.mem b 256) (hro : ¬r.offset.uaddOverflow 32#64)
    (hbo : ¬b.offset.uaddOverflow 32#64) (hrb : r.id ≠ b.id) :
    crc_fe64_frombytes_36.call (crc_fe64_frombytes_36.args (.value r) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeAt r (frombytes (s.mem.readAt b 256)) }) := by
  frombytes_proof

/-- `crc_fe64_sgn( a )` returns bit 0 of `canon` of the value at `a` (its parity); its `c[4]` and
`canon`'s two slots are frame blocks. -/
public theorem crc_fe64_sgn.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_sgn.globals) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_sgn.call (crc_fe64_sgn.args (.value a)) s =
      .value
        (.cons (.value ((canon (s.mem.readAt a 256)).setWidth 32 &&& 1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  sgn_proof crc_fe64_canon.call_eq

@[inherit_doc crc_fe64_sgn.call_eq]
public theorem crc_fe64_sgn_3.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_sgn_3.globals) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_sgn_3.call (crc_fe64_sgn_3.args (.value a)) s =
      .value
        (.cons (.value ((canon (s.mem.readAt a 256)).setWidth 32 &&& 1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  sgn_proof crc_fe64_canon_4.call_eq

@[inherit_doc crc_fe64_sgn.call_eq]
public theorem crc_fe64_sgn_43.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_sgn_43.globals) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_sgn_43.call (crc_fe64_sgn_43.args (.value a)) s =
      .value
        (.cons (.value ((canon (s.mem.readAt a 256)).setWidth 32 &&& 1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  sgn_proof crc_fe64_canon_45.call_eq

/-- `crc_fe64_is_zero( a )` returns `1` when `canon` of the value at `a` is zero, else `0`. -/
public theorem crc_fe64_is_zero.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_is_zero.globals) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_is_zero.call (crc_fe64_is_zero.args (.value a)) s =
      .value
        (.cons (.value (if canon (s.mem.readAt a 256) = 0#256 then 1#32 else 0#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_alloca with cs
  step_pure
  step_call using crc_fe64_canon.call_eq
  step_load with c0
  step_pure
  step_load with c1
  step_pure
  step_pure
  step_load with c2
  step_pure
  step_pure
  step_load with c3
  iterate 4 step_pure
  finish_block
  rw [hS]
  clear hS hread_cs
  erase_frame
  rw [hc0, hc1, hc2, hc3, is_zero_bits]
  simp only [GlobalState.alloca_alloc]

/-- `crc_fe64_eq( a, b )` returns `1` when `canon` of the values at `a` and `b` agree, else `0`. -/
public theorem crc_fe64_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_eq.globals) (ha : Fits s.mem a 256) (hb : Fits s.mem b 256)
    (hao : ¬a.offset.uaddOverflow 32#64) (hbo : ¬b.offset.uaddOverflow 32#64) :
    crc_fe64_eq.call (crc_fe64_eq.args (.value a) (.value b)) s =
      .value
        (.cons
            (.value
              (if canon (s.mem.readAt a 256) = canon (s.mem.readAt b 256) then 1#32 else 0#32))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem }) := by
  eq_proof crc_fe64_canon.call_eq

@[inherit_doc crc_fe64_eq.call_eq]
public theorem crc_fe64_eq_48.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_eq_48.globals) (ha : Fits s.mem a 256) (hb : Fits s.mem b 256)
    (hao : ¬a.offset.uaddOverflow 32#64) (hbo : ¬b.offset.uaddOverflow 32#64) :
    crc_fe64_eq_48.call (crc_fe64_eq_48.args (.value a) (.value b)) s =
      .value
        (.cons
            (.value
              (if canon (s.mem.readAt a 256) = canon (s.mem.readAt b 256) then 1#32 else 0#32))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem }) := by
  eq_proof crc_fe64_canon_45.call_eq

/-- `crc_fe64_tobytes( out, a )` stores `canon` of the value at `a` at `out`, as 32 little-endian
bytes; its `c[4]` and `canon`'s two slots are frame blocks. `out` may alias `a`. -/
public theorem crc_fe64_tobytes.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_tobytes.globals) (hout : Room s.mem out 256)
    (ha : Fits s.mem a 256) (houto : ¬out.offset.uaddOverflow 32#64)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_tobytes.call (crc_fe64_tobytes.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩
            mem := s.mem.storeAt out (canon (s.mem.readAt a 256)) }) := by
  func_init
  block_init
  iterate 5 step_pure
  step_alloca with cs
  step_pure
  step_call using crc_fe64_canon_4.call_eq
  finish_block
  tobytes_iter
  tobytes_iter
  tobytes_iter
  tobytes_iter
  block_init
  step_pure
  finish_block
  rw [hS]
  clear hS hread_out hread_out_8 hread_out_16 hread_out_24 hread_cs
  erase_frame
  rw [storeAt_limbs houto, limbs_setWidth]
  simp only [GlobalState.alloca_alloc]

end Proof

end MLIR.Firedancer.Crc.Ref

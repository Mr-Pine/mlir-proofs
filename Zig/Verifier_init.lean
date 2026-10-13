module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.Block
public import Zig.Common.Globals
public import Zig.Common.PointCopy
public import Zig.Sha512_update
public import Zig.Edwards25519_fromBytes
public import Zig.Edwards25519_rejectIdentity
public import Zig.Fe_rejectNonCanonical
public import Zig.scalar_rejectNonCanonical
public import Zig.Mlir.Verifier_init
import Zig.Math.Decode
import Std.Tactic.BVDecide
import Mathlib.Tactic.Rename

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

set_option hygiene false in
/-- Two of a frame's slots differ. -/
local macro "slot_ne" : tactic =>
  `(tactic|
    ( simp only [GlobalState.allocaPtr, GlobalState.alloca, GlobalState.slot, ne_eq,
        BlockId.mk.injEq]
      omega))

set_option hygiene false in
/-- After a copy into the `Verifier` slot `v`: its bits and definedness from `hV`, the step's facts
about `v` dropped but its room. -/
local macro "v_post" : tactic =>
  `(tactic|
    ( obtain ⟨hv_zb, hv_zd⟩ := hV _ _ _ (congrArg GlobalState.mem hS)
      have hvr : Room S.mem v 4736 ∧ True := ⟨hv_room, trivial⟩
      clear hV
      clear_facts v
      have hv_room := hvr.1
      clear hvr))

namespace MLIR.Zig

open _root_.Ed25519 Memory

/-! ## Specification -/

@[expose] public section

namespace Verifier.init

/-- The IV's state words, `s[0]` lowest. -/
def ivState : BitVec 512 :=
  0x5be0cd19137e2179#64 ++ 0x1f83d9abfb41bd6b#64 ++ 0x9b05688c2b3e6c1f#64 ++
    0x510e527fade682d1#64 ++
    0xa54ff53a5f1d36f1#64 ++
    0x3c6ef372fe94f82b#64 ++
    0xbb67ae8584caa73b#64 ++
    0x6a09e667f3bcc908#64

/-- The hash object's 224 bytes after `iv`, `update(r)`, `update(A)`: `total_len` 64, the IV's
state, `r ++ A` buffered, `buf_len` 64; the rest the `Sha512.iv` global's undefined bits, zero. -/
def hashBits (r A : BitVec 256) : BitVec 1792 :=
  0#120 ++ 64#8 ++ 0#512 ++ A ++ r ++ ivState ++ 64#128

/-- Which of them are defined: all but the rest of `buf` and the padding. -/
def hashDefs : BitVec 1792 :=
  0#120 ++ BitVec.allOnes 8 ++ 0#512 ++ BitVec.allOnes 1152

/-- A decoded point's 168 bytes as `fromBytes` leaves them in a fresh slot: its field elements, then
zeros. -/
abbrev ptBits (P : ZPt) : BitVec 1344 :=
  0#64 ++ P.bits

/-- Which of them are defined: the field elements'. -/
abbrev ptDefs : BitVec 1344 :=
  0#64 ++ BitVec.allOnes 1280

/-- The first error code: `S`'s, `A`'s decoding (`2`) and identity check, `r`'s, `R`'s decoding
(`2`) and identity check; `0` if none. -/
def code (r S A : BitVec 256) : BitVec 16 :=
  if scalar.rejectNonCanonical.spec S ≠ 0#16 then scalar.rejectNonCanonical.spec S
  else
    match Edwards25519.fromBytes.spec A with
    | none => 2#16
    | some a =>
      if Edwards25519.rejectIdentity.spec a ≠ 0#16 then Edwards25519.rejectIdentity.spec a
      else
        if Fe.rejectNonCanonical.spec r ≠ 0#16 then Fe.rejectNonCanonical.spec r
        else
          match Edwards25519.fromBytes.spec r with
          | none => 2#16
          | some R => Edwards25519.rejectIdentity.spec R

/-- The blocks allocated: `7` (the IV's, five slots, `scalar.rejectNonCanonical`'s), then the
calls'. -/
def blocks (r S A : BitVec 256) : Nat :=
  7 +
    if scalar.rejectNonCanonical.spec S ≠ 0#16 then 0
    else
      match Edwards25519.fromBytes.spec A with
      | none => 595
      | some a =>
        602 +
          if Edwards25519.rejectIdentity.spec a ≠ 0#16 ∨ Fe.rejectNonCanonical.spec r ≠ 0#16 then 0
          else
            match Edwards25519.fromBytes.spec r with
            | none => 595
            | some _ => 602

/-- `fromBytes`' point bits, zero when the bytes do not decode. -/
def ptBitsOf : Option ZPt → BitVec 1344
  | some P => ptBits P
  | none => 0#1344

/-- The `Verifier`'s 592 bytes on success: the hash object, `a`, `expected_r`, `s`. -/
def bits (r S A : BitVec 256) : BitVec 4736 :=
  S ++ ptBitsOf (Edwards25519.fromBytes.spec r) ++ ptBitsOf (Edwards25519.fromBytes.spec A) ++
    hashBits r A

/-- Which of them are defined. -/
def defs : BitVec 4736 :=
  BitVec.allOnes 256 ++ ptDefs ++ ptDefs ++ hashDefs

/-- `out` after `init`: the code at byte 592, the `Verifier` before it on success. -/
def mem (m : MemoryState) (out : Pointer) (r S A : BitVec 256) : MemoryState :=
  if code r S A = 0#16 then (m.storeAt (out.add 592#64) 0#16).storeDef out (bits r S A) defs
  else m.storeAt (out.add 592#64) (code r S A)

end Verifier.init

end

/-- `bits` on decoded points. -/
public theorem Verifier.init.bits_eq {r S A : BitVec 256} {a R : ZPt}
    (hA : Edwards25519.fromBytes.spec A = some a) (hR : Edwards25519.fromBytes.spec r = some R) :
    Verifier.init.bits r S A =
      S ++ Verifier.init.ptBits R ++ Verifier.init.ptBits a ++ Verifier.init.hashBits r A := by
  rw [Verifier.init.bits, hA, hR]
  rfl

/-! ## Proof -/

section Proof

open Verifier.init

/-- A slot an `alloca` made, held alike: its bits zero, none defined. -/
theorem fresh_slot {s : GlobalState} {m : MemoryState} {q : Pointer} (hq : q = s.allocaPtr)
    (h : m[q.id]? = (s.alloca n z).mem[q.id]?) : m.readAt q w = 0 ∧ m.definedAt q w = 0 := by
  subst hq
  exact
    ⟨(readAt_congr h).trans MemoryState.readAt_alloca_allocaPtr,
      (definedAt_congr h).trans MemoryState.definedAt_alloca_allocaPtr⟩

/-- `scalar.rejectNonCanonical`'s `call_eq` on the bytes `b` read at `p`. -/
theorem scalar_rejectNonCanonical.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hpo : p.offset.toNat + 32 < 2 ^ 64) (hb : s.mem.readAt p 256 = b) :
    scalar_rejectNonCanonical.call (scalar_rejectNonCanonical.args (.value p)) s =
      .value
        (.cons (.value (scalar.rejectNonCanonical.spec b)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  subst hb
  exact scalar_rejectNonCanonical.call_eq p s hwf hp hpo

/-- `Fe.rejectNonCanonical`'s `call_eq` on the bytes `b` read at `p`. -/
theorem Fe_rejectNonCanonical.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hpo : ¬p.offset.uaddOverflow 32#64) (hb : s.mem.readAt p 256 = b) :
    Fe_rejectNonCanonical.call (Fe_rejectNonCanonical.args (.value p)) s =
      .value (.cons (.value (Fe.rejectNonCanonical.spec b)) .nil, s) := by
  subst hb
  exact Fe_rejectNonCanonical.call_eq p s hwf hp hpo

/-- `rejectIdentity`'s `call_eq` on the point `P` read at `p`. -/
theorem Edwards25519_rejectIdentity.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.LimbsFit p) (hP : s.mem.readPt p = P) (hx : Fe.Lt P.x (2 ^ 63)) :
    Edwards25519_rejectIdentity.call (Edwards25519_rejectIdentity.args (.value p)) s =
      .value
        (.cons (.value (Edwards25519.rejectIdentity.spec P)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  subst hP
  exact Edwards25519_rejectIdentity.call_eq p s hwf hp hx

/-- `fromBytes`' `call_eq` when the bytes decode to `P`: its stores spelled out. -/
theorem Edwards25519_fromBytes.call_eq_some (out buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64) (hbuf : Fits s.mem buf 256)
    (hbo : buf.offset.toNat + 32 ≤ 2 ^ 64) (hb : s.mem.readAt buf 256 = b)
    (hP : Edwards25519.fromBytes.spec b = some P) :
    Edwards25519_fromBytes.call (Edwards25519_fromBytes.args (.value out) (.value buf)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 601⟩,
            mem :=
              ((s.mem.storeAt (out.add 168#64) 0#16).storeAt out P.bits).storeDef (out.add 160#64)
                0#8 0#8 }) := by
  rw [Edwards25519_fromBytes.call_eq out buf s hwf hout hoo hbuf hbo, hb, hP]
  rfl

/-- `fromBytes`' `call_eq` when the bytes do not decode: the `InvalidEncoding` global copied. -/
theorem Edwards25519_fromBytes.call_eq_none (out buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64) (hbuf : Fits s.mem buf 256)
    (hbo : buf.offset.toNat + 32 ≤ 2 ^ 64) (hb : s.mem.readAt buf 256 = b)
    (hP : Edwards25519.fromBytes.spec b = none) :
    Edwards25519_fromBytes.call (Edwards25519_fromBytes.args (.value out) (.value buf)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 595⟩,
            mem :=
              s.mem.storeDef out Edwards25519_fromBytes_invalid.bits
                Edwards25519.fromBytes.invalidDef }) := by
  rw [Edwards25519_fromBytes.call_eq out buf s hwf hout hoo hbuf hbo, hb, hP]
  rfl

/-- Two ranges of one block at offsets `a`, `b` bytes from its start, apart. -/
theorem disjoint_add {p : Pointer} (ho : p.offset = 0) {a b v w : Nat} (ha : a < 2 ^ 32)
    (hb : b < 2 ^ 32) (h : a * 8 + v ≤ b * 8 ∨ b * 8 + w ≤ a * 8) :
    (Range.of (p.add (BitVec.ofNat 64 a)) v).Disjoint (Range.of (p.add (BitVec.ofNat 64 b)) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, ho, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (a := a) (by omega), Nat.mod_eq_of_lt (a := b) (by omega)]
  simp only [show (0 : BitVec 64).toNat = 0 from rfl, Nat.zero_add]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- What `fromBytes` leaves in a fresh slot when the bytes decode to `P`: error code `0`, the
point's bits and definedness (`ptBits`, `ptDefs`). -/
theorem fromBytes_some_facts {m m' : MemoryState} {p : Pointer} {P : ZPt}
    (hm : m' = ((m.storeAt (p.add 168#64) 0#16).storeAt p P.bits).storeDef (p.add 160#64) 0#8 0#8)
    (hr : Room m p 1408) (ho : p.offset = 0) (hb : m.readAt p 1344 = 0)
    (hd : m.definedAt p 1344 = 0) :
    Fits m' (p.add 168#64) 16 ∧
      m'.readAt (p.add 168#64) 16 = 0#16 ∧
      m'.readAt p 1344 = ptBits P ∧ m'.definedAt p 1344 = ptDefs := by
  subst hm
  have hi : InBounds m p 1344 := hr.inBounds.mono (by omega)
  have h0 :=
    disjoint_add (p := p) ho (a := 0) (b := 168) (v := 1344) (w := 16) (by omega) (by omega)
      (by omega)
  have h1 :=
    disjoint_add (p := p) ho (a := 160) (b := 168) (v := 8) (w := 16) (by omega) (by omega)
      (by omega)
  have h2 :=
    disjoint_add (p := p) ho (a := 0) (b := 168) (v := 1280) (w := 16) (by omega) (by omega)
      (by omega)
  simp only [Pointer.add_zero'] at h0 h1 h2
  have hov : ¬p.offset.uaddOverflow 160#64 := by simp [BitVec.uaddOverflow, ho]
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact
      Fits.storeDef_of_disjoint
        (Fits.storeAt
          (Fits.storeAt_self (hr.add_of_le (by simp [BitVec.uaddOverflow, ho]) (by simp))))
        h1
  · rw [MemoryState.readAt_storeDef_disjoint h1, MemoryState.readAt_storeAt_disjoint h2,
      MemoryState.readAt_storeAt_self
        (hr.add_of_le (by simp [BitVec.uaddOverflow, ho]) (by simp)).inBounds]
  · rw [MemoryState.readAt_add_storeDef hi.storeAt.storeAt hov (by simp),
      MemoryState.readAt_storeAt_over hi.storeAt (by omega),
      MemoryState.readAt_storeAt_disjoint h0.symm, hb]
    simp only [spliceBits_eq, ptBits, show (160#64).toNat * 8 = 1280 from rfl]
    generalize P.bits = B
    bv_decide
  · rw [MemoryState.definedAt_add_storeDef hi.storeAt.storeAt hov (by simp),
      MemoryState.definedAt_storeAt_over hi.storeAt (by omega),
      MemoryState.definedAt_storeAt_disjoint h0.symm, hd]
    simp only [spliceBits_eq, ptDefs, show (160#64).toNat * 8 = 1280 from rfl]
    bv_decide

/-- `InvalidEncoding`'s code in its bits. -/
theorem invalid_code : (Edwards25519_fromBytes_invalid.bits).extractLsb' 1344 16 = 2#16 := by
  decide +kernel

/-- What `fromBytes` leaves when the bytes do not decode: error code `2`. -/
theorem fromBytes_none_facts {m m' : MemoryState} {p : Pointer}
    (hm : m' = m.storeDef p Edwards25519_fromBytes_invalid.bits Edwards25519.fromBytes.invalidDef)
    (hr : Room m p 1408) (ho : p.offset = 0) :
    Fits m' (p.add 168#64) 16 ∧ m'.readAt (p.add 168#64) 16 = 2#16 := by
  subst hm
  have hov : ¬p.offset.uaddOverflow 168#64 := by simp [BitVec.uaddOverflow, ho]
  refine ⟨Fits.storeDef_of_mask hr hov (by simp) (by decide +kernel), ?_⟩
  rw [MemoryState.readAt_storeDef_add hr.inBounds hov (by simp)]
  exact invalid_code

/-- A decoded point in a fresh slot, by `ptBits`, `ptDefs`: its field elements known, the point. -/
theorem pt_of_bits {m : MemoryState} {p : Pointer} {P : ZPt} (hr : m.PtRoom p)
    (hb : m.readAt p 1344 = ptBits P) (hd : m.definedAt p 1344 = ptDefs) :
    m.PtLimbsFit p ∧ m.readPt p = P := by
  refine
    ⟨.of_definedAt hr
        (by
          rw [hd]; simp only [ptDefs]; bv_decide),
      ?_⟩
  refine MemoryState.readPt_of_readAt (hr.2.inBounds.mono (by omega)) hr.1 ?_
  rw [MemoryState.readAt_of_readAt_le (by omega) hb]
  simp only [ptBits]
  generalize P.bits = B
  bv_decide

/-- A decoded point's `x` limbs are below `2^63`. -/
theorem fromBytes_x_lt {b : BitVec 256} {P : ZPt} (h : Edwards25519.fromBytes.spec b = some P) :
    Fe.Lt P.x (2 ^ 63) := by
  obtain ⟨-, -, -, -, hl⟩ := Decode.fromBytes_eq_some h
  exact hl.1.mono (by decide)

/-- `update`'s object bits after 32 bytes `x` at `buf_len = bl`, `total_len = T`. -/
abbrev upd32 (X : BitVec 1792) (bl : BitVec 8) (T : BitVec 128) (x : BitVec 256) : BitVec 1792 :=
  spliceBits (spliceBits (spliceBits X ((80 + bl.toNat) * 8) x) 1664 (bl + 32#8)) 0 (T + 32#128)

/-- Their definedness. -/
abbrev upd32Def (D : BitVec 1792) (bl : BitVec 8) : BitVec 1792 :=
  spliceBits
    (spliceBits (spliceBits D ((80 + bl.toNat) * 8) (BitVec.allOnes 256)) 1664 (BitVec.allOnes 8)) 0
    (BitVec.allOnes 128)

/-- A hash object known by its bits `X` and definedness `D`: its fields. -/
theorem hash_facts {m : MemoryState} {d : Pointer} {X D : BitVec 1792} {bl : BitVec 8}
    {T : BitVec 128} (hr : Room m d 1792) (ho : d.offset = 0) (hX : m.readAt d 1792 = X)
    (hD : m.definedAt d 1792 = D) (hbl : X.extractLsb' 1664 8 = bl) (hT : X.extractLsb' 0 128 = T)
    (hb : bl.toNat < 128) (h1 : D.extractLsb' 0 640 = BitVec.allOnes 640)
    (h2 : D.extractLsb' 1664 8 = BitVec.allOnes 8)
    (h3 : D.extractLsb' 640 (8 * bl.toNat) = BitVec.allOnes (8 * bl.toNat)) :
    Sha512Obj.Fit m d ∧
      Fits m (d.add 80#64) (8 * bl.toNat) ∧
      Sha512Obj.bufLen m d = bl ∧ Sha512Obj.totalLen m d = T := by
  subst hbl hT
  have hov (k : BitVec 64) (hk : k.toNat ≤ 224) : ¬d.offset.uaddOverflow k := by
    simp [BitVec.uaddOverflow, ho]; omega
  refine ⟨⟨by simp [ho], hr, ?_, ?_⟩, ?_, ?_, ?_⟩
  · simpa [Pointer.add_zero'] using
      Fits.of_definedAt_add (off := 0#64) hr (hov _ (by decide)) (by simp) hD (by simpa using h1)
  · exact Fits.of_definedAt_add hr (hov _ (by decide)) (by simp) hD (by simpa using h2)
  · exact
      Fits.of_definedAt_add hr (hov _ (by decide))
        (by
          rw [show (80#64).toNat = 80 from rfl]; omega)
        hD (by simpa using h3)
  · rw [Sha512Obj.bufLen,
      MemoryState.readAt_add_of_readAt hr.inBounds (hov _ (by decide)) (by simp) hX]
    rfl
  · rw [Sha512Obj.totalLen, MemoryState.readAt_of_readAt_le (by omega) hX]
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [hi]

/-- `update`'s three stores of 32 bytes over a hash object known by its bits and definedness. -/
theorem upd32_facts {m m' : MemoryState} {d : Pointer} {X D : BitVec 1792} {bl : BitVec 8}
    {T : BitVec 128} {x : BitVec 256}
    (hm :
      m' =
        ((m.storeAt (d.add (80#64 + bl.setWidth 64)) x).storeAt (d.add 208#64) (bl + 32#8)).storeAt
          d (T + 32#128))
    (hr : Room m d 1792) (ho : d.offset = 0) (hX : m.readAt d 1792 = X)
    (hD : m.definedAt d 1792 = D) (hbl : bl.toNat < 96) :
    m'.readAt d 1792 = upd32 X bl T x ∧ m'.definedAt d 1792 = upd32Def D bl := by
  subst hm
  have hi := hr.inBounds
  have hk : (80#64 + bl.setWidth 64).toNat = 80 + bl.toNat := by
    simp [BitVec.toNat_add]; omega
  have hov : ¬d.offset.uaddOverflow (80#64 + bl.setWidth 64) := by
    simp [BitVec.uaddOverflow, ho, hk]; omega
  have hov' : ¬d.offset.uaddOverflow 208#64 := by simp [BitVec.uaddOverflow, ho]
  constructor
  · rw [MemoryState.readAt_storeAt_over hi.storeAt.storeAt (by omega),
      MemoryState.readAt_add_storeAt hi.storeAt hov' (by simp),
      MemoryState.readAt_add_storeAt hi hov
        (by
          rw [hk]; omega),
      hX, hk]
    rfl
  · rw [MemoryState.definedAt_storeAt_over hi.storeAt.storeAt (by omega),
      MemoryState.definedAt_add_storeAt hi.storeAt hov' (by simp),
      MemoryState.definedAt_add_storeAt hi hov
        (by
          rw [hk]; omega),
      hD, hk]
    rfl

/-- The object after `update(r)`: `r` buffered, both counts 32. -/
abbrev hash1 (r : BitVec 256) : BitVec 1792 :=
  0#120 ++ 32#8 ++ 0#768 ++ r ++ ivState ++ 32#128

/-- Its definedness. -/
abbrev hash1Def : BitVec 1792 :=
  0#120 ++ BitVec.allOnes 8 ++ 0#768 ++ BitVec.allOnes 896

theorem upd1_eq (r : BitVec 256) :
    upd32 (0#1152 ++ ivState ++ 0#128) 0#8 0#128 r = hash1 r ∧
      upd32Def (0#120 ++ BitVec.allOnes 8 ++ 0#1024 ++ BitVec.allOnes 640) 0#8 = hash1Def := by
  simp only [upd32, upd32Def, spliceBits_eq, hash1, hash1Def, show (0#8).toNat = 0 from rfl]
  generalize ivState = I
  constructor <;> bv_decide

theorem hash1_fields (r : BitVec 256) :
    (hash1 r).extractLsb' 1664 8 = 32#8 ∧ (hash1 r).extractLsb' 0 128 = 32#128 := by
  simp only [hash1]
  generalize ivState = I
  constructor <;> bv_decide

theorem upd2_eq (r A : BitVec 256) : upd32 (hash1 r) 32#8 32#128 A = hashBits r A := by
  simp only [upd32, spliceBits_eq, hash1, hashBits, show (32#8).toNat = 32 from rfl]
  generalize ivState = I
  bv_decide

theorem upd2_def : upd32Def hash1Def 32#8 = hashDefs := by
  rw [upd32Def, spliceBits_eq, spliceBits_eq, spliceBits_eq]
  decide +kernel

/-- A masked store at a block's start, over its bits and definedness: spliced in. -/
theorem splice_def0 {m m' : MemoryState} {p : Pointer} {X D : BitVec V} {x d : BitVec w}
    (hm : m' = m.storeDef p x d) (hi : InBounds m p V) (hw : w ≤ V) (hX : m.readAt p V = X)
    (hD : m.definedAt p V = D) :
    m'.readAt p V = spliceBits X 0 x ∧ m'.definedAt p V = spliceBits D 0 d := by
  subst hm hX hD
  have h0 : ¬p.offset.uaddOverflow 0#64 := by simp [BitVec.uaddOverflow, p.offset.isLt]
  have e1 := MemoryState.readAt_add_storeDef (off := 0#64) hi h0 (by simpa) x d
  have e2 := MemoryState.definedAt_add_storeDef (off := 0#64) hi h0 (by simpa) x d
  simp only [Pointer.add_zero', BitVec.toNat_ofNat, Nat.zero_mod, Nat.zero_mul] at e1 e2
  exact ⟨e1, e2⟩

/-- A masked store inside a block, over its bits and definedness: spliced in. -/
theorem splice_def {m m' : MemoryState} {p : Pointer} {off : BitVec 64} {X D : BitVec V}
    {x d : BitVec w} (hm : m' = m.storeDef (p.add off) x d) (hi : InBounds m p V)
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + w ≤ V) (hX : m.readAt p V = X)
    (hD : m.definedAt p V = D) :
    m'.readAt p V = spliceBits X (off.toNat * 8) x ∧
      m'.definedAt p V = spliceBits D (off.toNat * 8) d := by
  subst hm hX hD
  exact
    ⟨MemoryState.readAt_add_storeDef hi hov hw x d,
      MemoryState.definedAt_add_storeDef hi hov hw x d⟩

/-- A store inside a block, over its bits and definedness: spliced in, defined. -/
theorem splice_at {m m' : MemoryState} {p : Pointer} {off : BitVec 64} {X D : BitVec V}
    {x y : BitVec w} (hm : m' = m.storeAt (p.add off) x) (hx : x = y) (hi : InBounds m p V)
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + w ≤ V) (hX : m.readAt p V = X)
    (hD : m.definedAt p V = D) :
    m'.readAt p V = spliceBits X (off.toNat * 8) y ∧
      m'.definedAt p V = spliceBits D (off.toNat * 8) (BitVec.allOnes w) := by
  subst hm hX hD hx
  exact ⟨MemoryState.readAt_add_storeAt hi hov hw x, MemoryState.definedAt_add_storeAt hi hov hw x⟩

/-- The `Verifier` assembled in its fresh slot: `h`, `s`, `a`, `expected_r`. -/
theorem assemble_eq (H : BitVec 1792) (S : BitVec 256) (A R : BitVec 1344) :
    spliceBits (spliceBits (spliceBits (spliceBits (0#4736) 0 H) 4480 S) 1792 A) 3136 R =
      S ++ R ++ A ++ H := by
  simp only [spliceBits_eq]
  bv_decide

/-- Its definedness. -/
theorem assemble_def :
    spliceBits
        (spliceBits (spliceBits (spliceBits (0#4736) 0 hashDefs) 4480 (BitVec.allOnes 256)) 1792
          ptDefs)
        3136 ptDefs =
      defs := by
  rw [spliceBits_eq, spliceBits_eq, spliceBits_eq, spliceBits_eq]
  decide +kernel

/-- `Sha512.update` of 32 bytes `x` that leave the buffer partial: three stores. -/
theorem Sha512_update.call_eq_32 (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hd : Sha512Obj.Fit s.mem d) (hbuf : Fits s.mem (d.add 80#64) (8 * bl.toNat))
    (hbf : Fits s.mem b 256) (hbo : b.offset.toNat + 32 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of b 256)) (hbl : Sha512Obj.bufLen s.mem d = bl)
    (hbl' : bl.toNat < 96) (hT : Sha512Obj.totalLen s.mem d = T) (hT' : T.toNat < 2 ^ 64)
    (hx : s.mem.readAt b 256 = x) :
    Sha512_update.call (Sha512_update.args (.value d) (.value b) (.value 32#64)) s =
      .value
        (.nil,
          { alloc := s.alloc,
            mem :=
              ((s.mem.storeAt (d.add (80#64 + bl.setWidth 64)) x).storeAt (d.add 208#64)
                    (bl + 32#8)).storeAt
                d (T + 32#128) }) := by
  subst hbl hT hx
  rw [Sha512_update.call_eq d b 32#64 s hwf hd (by simpa using hbuf) (by simpa using hbf)
      (by simpa using hbo) (by simpa using hsep) (by simp) (by omega)
      (by
        simp; omega)]
  simp only [Sha512_update.post]
  rw [ite_eq_right_iff.mpr
      (fun h =>
        absurd h.2
          (by
            simp; omega))]
  simp only [Sha512_update.fromState, Sha512_update.tailMem]
  simp [Sha512_update.blocksState]

-- thirteen blocks, seven calls, each step carrying the facts
set_option maxHeartbeats 4000000 in
set_option exponentiation.threshold 1792 in
/-- `Verifier.init` of the signature `r ‖ S` at `sig` and the key `A` at `pk` stores `mem` at
`out`. -/
public theorem Verifier_init.call_eq (out sig pk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 4752) (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) :
    Verifier_init.call (Verifier_init.args (.value out) (.value sig) (.value pk)) s =
      .value
        (.nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem :=
              mem s.mem out (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                (s.mem.readAt pk 256) }) := by
  have hsig32 : Fits s.mem (sig.add 32#64) 256 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hsig
  have hsig0 : Fits s.mem sig 256 := hsig.mono (by omega)
  have hout592 : Room s.mem (out.add 592#64) 16 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hout
  have hsig32o : (sig.add 32#64).offset.toNat + 32 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  generalize hr : s.mem.readAt sig 256 = r
  generalize hSc : s.mem.readAt (sig.add 32#64) 256 = Sc
  generalize hA : s.mem.readAt pk 256 = Ae
  func_init
  block_init
  iterate 5 step_pure
  step_addressof Sha512_iv with iv
  have hiv_b : S.mem.readAt iv 1792 = 0#1152 ++ ivState ++ 0#128 :=
    hread_iv.trans (by decide +kernel)
  have hiv_d :
    S.mem.definedAt iv 1792 = 0#120 ++ BitVec.allOnes 8 ++ 0#1024 ++ BitVec.allOnes 640 := by
    rw [hS, hiv]
    exact
      (MemoryState.definedAt_storeDef_self (InBounds.allocaPtr (by omega)) _ _).trans
        (by decide +kernel)
  clear hread_iv
  checkpoint hck0
  rename' S => S₁
  step_pure
  step_alloca with v
  step_alloca with h
  step_alloca with pr
  step_alloca with pa
  step_alloca with rc
  have hpr_z : S.mem.readAt pr 1344 = 0 ∧ S.mem.definedAt pr 1344 = 0 :=
    fresh_slot (s := (S₁.alloca 592).alloca 224)
      (by rw [hpr, GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot, GlobalState.alloca_slot])
      (by
        rw [hS, hpr]
        rw [GlobalState.getElem?_alloca (by slot_ne), GlobalState.getElem?_alloca (by slot_ne)])
  have hpa_z : S.mem.readAt pa 1344 = 0 ∧ S.mem.definedAt pa 1344 = 0 :=
    fresh_slot (s := ((S₁.alloca 592).alloca 224).alloca 176)
      (by
        rw [hpa, GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
          GlobalState.alloca_slot])
      (by
        rw [hS, hpa]
        rw [GlobalState.getElem?_alloca (by slot_ne)])
  have hv_z : S.mem.readAt v 4736 = 0 ∧ S.mem.definedAt v 4736 = 0 :=
    fresh_slot (s := S₁) (by rw [hv, GlobalState.allocaPtr_eq_slot])
      (by
        rw [hS, hv]
        rw [GlobalState.getElem?_alloca (by slot_ne), GlobalState.getElem?_alloca (by slot_ne),
          GlobalState.getElem?_alloca (by slot_ne), GlobalState.getElem?_alloca (by slot_ne)])
  obtain ⟨hv_zb, hv_zd⟩ := hv_z
  obtain ⟨hpr_zb, hpr_zd⟩ := hpr_z
  obtain ⟨hpa_zb, hpa_zd⟩ := hpa_z
  step_memcpy
  step_pure
  step_call using scalar_rejectNonCanonical.call_eq_of
  step_pure
  finish_block
  case isFalse =>
    block_init
    step_pure
    step_store
    finish_block
    block_init
    finish_block
    rw [hS]
    clear_reads
    subst_vars
    erase_frame
    simp [mem, code, blocks, hbr, GlobalState.alloca]
  case isTrue =>
    have hc1 := hbr
    clear hbr
    have hpo' : pk.offset.toNat + 32 ≤ 2 ^ 64 := by omega
    have hpao : pa.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hpa_off]
    block_init
    rcases hoA : Edwards25519.fromBytes.spec Ae with _ | a
    · checkpoint hck1
      have hT := fun m' hm => fromBytes_none_facts (m' := m') hm hpa_room hpa_off
      clear hpa_zb hpa_zd
      step_call using Edwards25519_fromBytes.call_eq_none
      obtain ⟨hcf, hcr⟩ := hT S.mem (congrArg GlobalState.mem hS)
      clear hT
      step_pure
      step_load consuming hcf hcr
      step_pure
      finish_block
      case isTrue => exact absurd (invalid_code.symm.trans hbr) (by decide)
      case isFalse =>
        block_init
        step_pure
        step_store
        finish_block
        block_init
        finish_block
        rw [hS]
        clear_reads
        subst_vars
        erase_frame
        simp [mem, code, blocks, hc1, hoA, invalid_code, GlobalState.alloca]
    checkpoint hck1
    have hT := fun m' hm =>
      fromBytes_some_facts (P := a) (m' := m') hm hpa_room hpa_off hpa_zb hpa_zd
    clear hpa_zb hpa_zd
    step_call using Edwards25519_fromBytes.call_eq_some
    obtain ⟨hcf, hcr, hpab, hpad⟩ := hT S.mem (congrArg GlobalState.mem hS)
    clear hT
    step_pure
    step_load only [hcr] consuming hcf hcr
    step_pure
    finish_block
    obtain ⟨hpaF, hpaP⟩ := pt_of_bits ⟨hpao.trans' (by omega), hpa_room.mono (by omega)⟩ hpab hpad
    have hax := fromBytes_x_lt hoA
    block_init
    step_call using (Edwards25519_rejectIdentity.call_eq_of (P := a)) consuming hpaP hax
    step_pure
    finish_block
    case isFalse =>
      block_init
      step_pure
      step_store
      finish_block
      block_init
      finish_block
      rw [hS]
      clear_reads
      subst_vars
      erase_frame
      simp [mem, code, blocks, hc1, hoA, hbr, GlobalState.alloca]
    case isTrue =>
      have hc3 := hbr
      clear hbr
      have hrco : ¬rc.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hrc_off]
      block_init
      step_call using Fe_rejectNonCanonical.call_eq_of
      step_pure
      finish_block
      case isFalse =>
        block_init
        step_pure
        step_store
        finish_block
        block_init
        finish_block
        rw [hS]
        clear_reads
        subst_vars
        erase_frame
        simp [mem, code, blocks, hc1, hoA, hc3, hbr, GlobalState.alloca]
      case isTrue =>
        have hc4 := hbr
        clear hbr
        have hsigo' : sig.offset.toNat + 32 ≤ 2 ^ 64 := by omega
        have hpro : pr.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hpr_off]
        block_init
        rcases hoR : Edwards25519.fromBytes.spec r with _ | R
        · checkpoint hck2
          have hT := fun m' hm => fromBytes_none_facts (m' := m') hm hpr_room hpr_off
          clear hpr_zb hpr_zd
          step_call using Edwards25519_fromBytes.call_eq_none
          obtain ⟨hcf, hcr⟩ := hT S.mem (congrArg GlobalState.mem hS)
          clear hT
          step_pure
          step_load only [hcr] consuming hcf hcr
          step_pure
          finish_block
          case isTrue => exact absurd (invalid_code.symm.trans hbr) (by decide)
          case isFalse =>
            block_init
            step_pure
            step_store
            finish_block
            block_init
            finish_block
            rw [hS]
            clear_reads
            subst_vars
            erase_frame
            simp [mem, code, blocks, hc1, hoA, hc3, hc4, hoR, invalid_code, GlobalState.alloca]
        checkpoint hck2
        have hT := fun m' hm =>
          fromBytes_some_facts (P := R) (m' := m') hm hpr_room hpr_off hpr_zb hpr_zd
        clear hpr_zb hpr_zd
        step_call using Edwards25519_fromBytes.call_eq_some
        obtain ⟨hcf, hcr, hprb, hprd⟩ := hT S.mem (congrArg GlobalState.mem hS)
        clear hT
        step_pure
        step_load only [hcr] consuming hcf hcr
        step_pure
        finish_block
        obtain ⟨hprF, hprP⟩ :=
          pt_of_bits ⟨hpro.trans' (by omega), hpr_room.mono (by omega)⟩ hprb hprd
        have hRx := fromBytes_x_lt hoR
        block_init
        step_call using (Edwards25519_rejectIdentity.call_eq_of (P := R)) consuming hprP hRx
        step_pure
        finish_block
        case isFalse =>
          block_init
          step_pure
          step_store
          finish_block
          block_init
          finish_block
          rw [hS]
          clear_reads
          subst_vars
          erase_frame
          simp [mem, code, blocks, hc1, hoA, hc3, hc4, hoR, hbr, GlobalState.alloca]
        case isTrue =>
          have hc5 := hbr
          clear hbr
          checkpoint hck3
          block_init
          step_memcpy
          have hhb : S.mem.readAt h 1792 = 0#1152 ++ ivState ++ 0#128 := by
            have hi := hh_room.inBounds
            rw [hS] at hi ⊢
            exact MemoryState.readAt_storeDef_self (InBounds.storeDef_iff.mp hi) _ _
          have hhd :
            S.mem.definedAt h 1792 = 0#120 ++ BitVec.allOnes 8 ++ 0#1024 ++ BitVec.allOnes 640 := by
            have hi := hh_room.inBounds
            rw [hS] at hi ⊢
            exact
              (MemoryState.definedAt_storeDef_self (InBounds.storeDef_iff.mp hi) _ _).trans
                (by decide +kernel)
          obtain ⟨hFit, hbuf, hbl, hT⟩ :=
            hash_facts (bl := 0#8) (T := 0#128) hh_room hh_off hhb hhd (by decide +kernel)
              (by decide +kernel) (by decide) (by decide +kernel) (by decide +kernel)
              (by decide +kernel)
          have hsep : (Range.of h 1792).Disjoint (Range.of sig 256) := .inl hsig_ne_h.symm
          have hsigo32 : sig.offset.toNat + 32 < 2 ^ 64 := by omega
          checkpoint hck4
          have hU := fun m' hm =>
            upd32_facts (bl := 0#8) (T := 0#128) (x := r) (m' := m') hm hh_room hh_off hhb hhd
              (by decide)
          clear hhb hhd
          step_call using Sha512_update.call_eq_32 consuming hFit hbuf hbl hT hsep
          obtain ⟨hhb, hhd⟩ := hU S.mem (congrArg GlobalState.mem hS)
          clear hU
          rw [(upd1_eq r).1] at hhb
          rw [(upd1_eq r).2] at hhd
          obtain ⟨hFit, hbuf, hbl, hT⟩ :=
            hash_facts hh_room hh_off hhb hhd (hash1_fields r).1 (hash1_fields r).2 (by decide)
              (by decide +kernel) (by decide +kernel) (by decide +kernel)
          have hsep : (Range.of h 1792).Disjoint (Range.of pk 256) := .inl hpk_ne_h.symm
          checkpoint hck5
          have hU := fun m' hm =>
            upd32_facts (bl := 32#8) (T := 32#128) (x := Ae) (m' := m') hm hh_room hh_off hhb hhd
              (by decide)
          clear hhb hhd
          step_call using Sha512_update.call_eq_32 consuming hFit hbuf hbl hT hsep
          obtain ⟨hhb, hhd⟩ := hU S.mem (congrArg GlobalState.mem hS)
          clear hU
          rw [upd2_eq r Ae] at hhb
          rw [upd2_def] at hhd
          have hov (k : BitVec 64) (hk : k.toNat ≤ 592) : ¬v.offset.uaddOverflow k := by
            simp [BitVec.uaddOverflow, hv_off]; omega
          checkpoint hck6
          have hV := fun m' (x d : BitVec 1792) hm =>
            splice_def0 (m' := m') (x := x) (d := d) hm hv_room.inBounds (by omega) hv_zb hv_zd
          clear hv_zb hv_zd
          step_memcpy
          v_post
          clear_facts h
          step_pure
          have hV := fun m' hm =>
            splice_at (m' := m') (off := 560#64) hm hSc hv_room.inBounds (hov _ (by decide))
              (by simp) hv_zb hv_zd
          clear hv_zb hv_zd
          checkpoint hck7
          step_memcpy
          obtain ⟨hv_zb, hv_zd⟩ := hV _ (congrArg GlobalState.mem hS)
          have hvr : Room S.mem v 4736 ∧ True := ⟨hv_room, trivial⟩
          clear hV
          clear_facts v
          have hv_room := hvr.1
          clear hvr
          step_pure
          checkpoint hck8
          have hV := fun m' (x d : BitVec 1344) hm =>
            splice_def (m' := m') (x := x) (d := d) (off := 224#64) hm hv_room.inBounds
              (hov _ (by decide)) (by simp) hv_zb hv_zd
          clear hv_zb hv_zd
          step_memcpy
          v_post
          step_pure
          checkpoint hck9
          have hV := fun m' (x d : BitVec 1344) hm =>
            splice_def (m' := m') (x := x) (d := d) (off := 392#64) hm hv_room.inBounds
              (hov _ (by decide)) (by simp) hv_zb hv_zd
          clear hv_zb hv_zd
          step_memcpy
          v_post
          simp only [show (560#64).toNat * 8 = 4480 from rfl,
            show (224#64).toNat * 8 = 1792 from rfl,
            show (392#64).toNat * 8 = 3136 from rfl] at hv_zb hv_zd
          have hvb : S.mem.readAt v 4736 = bits r Sc Ae := by
            rw [hv_zb, assemble_eq, bits_eq hoA hoR]
          have hvd : S.mem.definedAt v 4736 = defs := hv_zd.trans assemble_def
          clear hv_zb hv_zd
          have hout4736 : Room S.mem out 4736 := hout.mono (by omega)
          clear hsig hpk hsig32 hsig0 hr hSc hA
          step_pure
          step_store
          step_memcpy consuming hfits_out_592
          finish_block
          block_init
          finish_block
          rw [hS]
          clear_reads
          subst_vars
          erase_frame
          have hcode : code r Sc Ae = 0#16 := by simp [code, hc1, hoA, hc3, hc4, hoR, hc5]
          simp [mem, hcode, blocks, hc1, hoA, hc3, hc4, hoR, GlobalState.alloca]

/-! ## The result, for callers -/

/-- `hashBits`' fields. -/
theorem hashBits_fields (r A : BitVec 256) :
    (hashBits r A).extractLsb' 1664 8 = 64#8 ∧
      (hashBits r A).extractLsb' 0 128 = 64#128 ∧ (hashBits r A).extractLsb' 640 512 = A ++ r := by
  simp only [hashBits]
  generalize ivState = I
  refine ⟨?_, ?_, ?_⟩ <;> bv_decide

/-- `hashBits`' state words: the IV's. -/
theorem hashBits_state (r A : BitVec 256) (i : Fin 8) :
    (hashBits r A).extractLsb' ((16 + 8 * i.val) * 8) 64 = Sha512.IV[i] := by
  have e :
    (hashBits r A).extractLsb' ((16 + 8 * i.val) * 8) 64 = ivState.extractLsb' (64 * i) 64 := by
    simp only [hashBits]
    generalize ivState = I
    fin_cases i <;> simp only [Nat.reduceMul, Nat.reduceAdd] <;> bv_decide
  rw [e]
  fin_cases i <;> decide +kernel

/-- An object holding `hashBits r A`, its definedness `hashDefs`, has absorbed `r ++ A`. -/
public theorem Verifier.init.absorbed {m : MemoryState} {d : Pointer} {r A : BitVec 256}
    (hr : Room m d 1792) (ho : d.offset = 0) (hX : m.readAt d 1792 = hashBits r A)
    (hD : m.definedAt d 1792 = hashDefs) :
    Sha512Obj.Fit m d ∧ Sha512Obj.Absorbed m d (bytesLE r ++ bytesLE A) := by
  obtain ⟨hbl, hT, hbuf⟩ := hashBits_fields r A
  obtain ⟨hFit, hfb, hbl', hT'⟩ :=
    hash_facts hr ho hX hD hbl hT (by decide) (by decide +kernel) (by decide +kernel)
      (by decide +kernel)
  have hrd (k w : Nat) (hk : k * 8 + w ≤ 1792) :
    m.readAt (d.add (BitVec.ofNat 64 k)) w = (hashBits r A).extractLsb' (k * 8) w := by
    rw [MemoryState.readAt_add_of_readAt hr.inBounds
        (by
          simp [BitVec.uaddOverflow, ho]; omega)
        (by
          simp; omega)
        hX]
    congr 1
    simp
    omega
  have hlen : (bytesLE r ++ bytesLE A).length = 64 := by simp
  refine ⟨hFit, ⟨?_, ?_, ?_, ?_, ?_⟩⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    apply Vector.ext
    intro i hi
    simp only [Sha512Obj.state, Vector.getElem_ofFn]
    rw [show 16#64 + BitVec.ofNat 64 (8 * i) = BitVec.ofNat 64 (16 + 8 * i) by
        apply BitVec.eq_of_toNat_eq; simp,
      hrd _ _ (by omega)]
    exact hashBits_state r A ⟨i, hi⟩
  · rw [hbl', hlen]; rfl
  · rw [Sha512Obj.buf, hrd 80 1024 (by omega), hlen]
    have e : (hashBits r A).extractLsb' (80 * 8) 1024 = 0#512 ++ A ++ r := by
      simp only [hashBits]
      generalize ivState = I
      bv_decide
    rw [e, bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide), ← List.append_assoc,
      List.take_left' (by simp)]
    simp
  · rw [hT', hlen]
  · rw [hlen, show (64 : Nat) % 128 = 64 from rfl]
    exact hfb

/-- The `Verifier`'s fields in its bits. -/
theorem bits_fields (S : BitVec 256) (B1 B2 : BitVec 1344) (H : BitVec 1792) :
    (S ++ B1 ++ B2 ++ H).extractLsb' 0 1792 = H ∧
      (S ++ B1 ++ B2 ++ H).extractLsb' 1792 1344 = B2 ∧
      (S ++ B1 ++ B2 ++ H).extractLsb' 3136 1344 = B1 ∧
      (S ++ B1 ++ B2 ++ H).extractLsb' 4480 256 = S := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Their definedness. -/
theorem defs_fields :
    defs.extractLsb' 0 1792 = hashDefs ∧
      defs.extractLsb' 1792 1344 = ptDefs ∧
      defs.extractLsb' 3136 1344 = ptDefs ∧ defs.extractLsb' 4480 256 = BitVec.allOnes 256 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> decide +kernel

/-- A block holding the `Verifier` `init` builds on success, as bits and definedness: the hash
object has absorbed `r ++ A`, `a` and `expected_r` are the decoded points (field elements known),
`s` is `S`. -/
public theorem Verifier.init.facts {m : MemoryState} {p : Pointer} {r S A : BitVec 256} {a R : ZPt}
    (hr : Room m p 4736) (ho : p.offset = 0) (hb : m.readAt p 4736 = bits r S A)
    (hd : m.definedAt p 4736 = defs) (hA : Edwards25519.fromBytes.spec A = some a)
    (hR : Edwards25519.fromBytes.spec r = some R) :
    Sha512Obj.Fit m p ∧
      Sha512Obj.Absorbed m p (bytesLE r ++ bytesLE A) ∧
      m.PtLimbsFit (p.add 224#64) ∧
      m.readPt (p.add 224#64) = a ∧
      m.PtLimbsFit (p.add 392#64) ∧
      m.readPt (p.add 392#64) = R ∧
      Fits m (p.add 560#64) 256 ∧ m.readAt (p.add 560#64) 256 = S := by
  rw [bits_eq hA hR] at hb
  obtain ⟨e1, e2, e3, e4⟩ := bits_fields S (ptBits R) (ptBits a) (hashBits r A)
  obtain ⟨d1, d2, d3, d4⟩ := defs_fields
  have hov (k : BitVec 64) (hk : k.toNat ≤ 592) : ¬p.offset.uaddOverflow k := by
    simp [BitVec.uaddOverflow, ho]; omega
  have hrd (k : BitVec 64) (w : Nat) (hk : k.toNat * 8 + w ≤ 4736) :
    m.readAt (p.add k) w =
      (S ++ ptBits R ++ ptBits a ++ hashBits r A).extractLsb' (k.toNat * 8) w :=
    MemoryState.readAt_add_of_readAt hr.inBounds (hov k (by omega : k.toNat ≤ 592)) hk hb
  have hdd (k : BitVec 64) (w : Nat) (hk : k.toNat * 8 + w ≤ 4736) :
    m.definedAt (p.add k) w = defs.extractLsb' (k.toNat * 8) w :=
    MemoryState.definedAt_add_of_definedAt hr.inBounds (hov k (by omega : k.toNat ≤ 592)) hk hd
  have hpt (k : BitVec 64) (hk : k.toNat * 8 + 1344 ≤ 4736) : m.PtRoom (p.add k) :=
    ⟨by
      simp [Pointer.add, ho]; omega, Room.add_of_le (hov k (by omega : k.toNat ≤ 592)) hk hr⟩
  have hX : m.readAt p 1792 = hashBits r A := by
    rw [MemoryState.readAt_of_readAt_le (w := 1792) (by omega) hb,
      BitVec.setWidth_eq_extractLsb' (by omega), e1]
  have hD : m.definedAt p 1792 = hashDefs := by
    rw [MemoryState.definedAt_le (w := 1792) (v := 4736) (by omega), hd, d1]
  obtain ⟨hFit, hAbs⟩ := Verifier.init.absorbed (hr.mono (by omega : 1792 ≤ 4736)) ho hX hD
  obtain ⟨ha1, ha2⟩ :=
    pt_of_bits (hpt 224#64 (by decide))
      (by
        rw [hrd 224#64 1344 (by decide)]; exact e2)
      (by
        rw [hdd 224#64 1344 (by decide)]; exact d2)
  obtain ⟨hR1, hR2⟩ :=
    pt_of_bits (hpt 392#64 (by decide))
      (by
        rw [hrd 392#64 1344 (by decide)]; exact e3)
      (by
        rw [hdd 392#64 1344 (by decide)]; exact d3)
  refine ⟨hFit, hAbs, ha1, ha2, hR1, hR2, ?_, ?_⟩
  · exact Fits.of_definedAt_add hr (hov _ (by decide)) (by decide) hd d4
  · rw [hrd 560#64 256 (by decide)]; exact e4

end Proof

end MLIR.Zig

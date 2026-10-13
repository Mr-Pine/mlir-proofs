module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.PointCopy
public import Zig.Common.Globals
public import Zig.Common.Tactics
public import Zig.Fe_mul
public import Zig.Fe_sq
public import Zig.Fe_sqn
public import Zig.Fe_isZero
public import Zig.Fe_cMov
public import Zig.Fe_neg
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_reduce
public import Zig.Mlir.Edwards25519_fromBytes
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas
import Mathlib.Tactic.Rename
import all MLIR.Ty
import Mathlib.Tactic.FinCases
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Zig

open Memory

/-! ## Specification -/

@[expose] public section

/-- `d`'s limbs. -/
def Fe.d : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 929955233495203
  | ⟨1, _⟩ => 466365720129213
  | ⟨2, _⟩ => 1662059464998953
  | ⟨3, _⟩ => 2033849074728123
  | ⟨4, _⟩ => 1442794654840575

/-- `1`'s limbs. -/
def Fe.one : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 1
  | _ => 0

/-- `√-1`'s limbs. -/
def Fe.sqrtm1 : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 1718705420411056
  | ⟨1, _⟩ => 234908883556509
  | ⟨2, _⟩ => 2233514472574048
  | ⟨3, _⟩ => 2117202627021982
  | ⟨4, _⟩ => 765476049583133

/-- `Fe.fromBytes`, inlined: five 51-bit limbs of `b` (bit 255 dropped), each from a 64-bit load at
byte 0, 6, 12, 19, 24. -/
def Fe.fromBytes.spec (b : BitVec 256) : Fin 5 → BitVec 64 :=
  Fe.mk5 (b.setWidth 64 &&& Fe.mask) (b.extractLsb' 48 64 >>> 3 &&& Fe.mask)
    (b.extractLsb' 96 64 >>> 6 &&& Fe.mask) (b.extractLsb' 152 64 >>> 1 &&& Fe.mask)
    (b.extractLsb' 192 64 >>> 12 &&& Fe.mask)

/-- `Fe.pow2523`, inlined: `a^(2^252 - 3)`, by the program's chain of squarings. -/
def Fe.pow2523.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let t0 := Fe.sq.spec a
  let t1 := Fe.mul.spec a t0
  let t0 := Fe.sqn.spec 2 t1
  let t0 := Fe.mul.spec t1 t0
  let t0 := Fe.mul.spec (Fe.sq.spec t0) a
  let t1 := Fe.mul.spec (Fe.sqn.spec 5 t0) t0
  let t2 := Fe.mul.spec (Fe.sqn.spec 5 t1) t0
  let t0 := Fe.mul.spec (Fe.sqn.spec 15 t2) t2
  let t2 := Fe.mul.spec (Fe.sqn.spec 30 t0) t0
  let t0 := Fe.mul.spec (Fe.sqn.spec 60 t2) t2
  let t0 := Fe.mul.spec (Fe.sqn.spec 120 t0) t0
  let t0 := Fe.mul.spec (Fe.sqn.spec 10 t0) t1
  Fe.mul.spec (Fe.sqn.spec 2 t0) a

/-- `x`'s sign fix: `b`'s top bit xor the low bit of `x` reduced. -/
def Edwards25519.fromBytes.sign (b : BitVec 256) (x : Fin 5 → BitVec 64) : BitVec 64 :=
  ((b.extractLsb' 248 8 >>> 7) ^^^ ((Fe.reduce.spec x 0).setWidth 8 &&& 1#8)).setWidth 64

/-- The point `b` encodes, `none` for `InvalidEncoding`: `y` from `b`, `x = √((y² - 1)/(d y² + 1))`
by `pow2523`, `√-1` and `b`'s top bit fixing its root and sign; `z = 1`, `t = x y`. -/
def Edwards25519.fromBytes.spec (b : BitVec 256) : Option ZPt :=
  let y := Fe.fromBytes.spec b
  let u := Fe.sq.spec y
  let v := Fe.mul.spec u Fe.d
  let u := Fe.sub.spec u Fe.one
  let v := Fe.add.spec v Fe.one
  let x := Fe.mul.spec (Fe.pow2523.spec (Fe.mul.spec u v)) u
  let vxx := Fe.mul.spec (Fe.sq.spec x) v
  let hm := Fe.isZero.spec (Fe.sub.spec vxx u)
  let hp := Fe.isZero.spec (Fe.add.spec vxx u)
  if hm ||| hp = 0#1 then none
  else
    let x := Fe.cMov.spec x (Fe.mul.spec x Fe.sqrtm1) (hm.setWidth 64 ^^^ 1#64)
    let x := Fe.cMov.spec x (Fe.neg.spec x) (Edwards25519.fromBytes.sign b x)
    some ⟨x, y, Fe.one, Fe.mul.spec x y⟩

/-- `error.InvalidEncoding`'s definedness: its code's bits only. -/
def Edwards25519.fromBytes.invalidDef : BitVec 1408 :=
  (Ty.flattenDef Edwards25519_fromBytes_invalid.t
        (ZPt.undef, .value 2, Vector.replicate 6 .poison)).2.cast
    (by decide)

/-- The `EncodingError!Edwards25519` `fromBytes` stores at `out`, 176 bytes: the point's field
elements, an undefined `is_base` byte (a poison byte, loaded from the `i1` `false` stored in a
byte) and error code `0`; or a copy of the `InvalidEncoding` global, error code `2`. -/
def _root_.MLIR.MemoryState.storeFromBytes (m : MemoryState) (out : Pointer) :
    Option ZPt → MemoryState
  | some P =>
    ((m.storeAt (out.add 168#64) 0#16).storeAt out P.bits).storeDef (out.add 160#64) 0#8 0#8
  | none => m.storeDef out Edwards25519_fromBytes_invalid.bits Edwards25519.fromBytes.invalidDef

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

set_option hygiene false in
/-- Drop a dead temporary's facts: its limbs' reads and its fit. -/
local macro "drop " x:ident : tactic => do
  let n := x.getId.toString
  let h (s : String) := Lean.mkIdent (.mkSimple s!"hread_{n}{s}")
  `(tactic|
      ( try clear $(h "_readLimbs")
        try clear $(h "")
        try clear $(h "_8")
        try clear $(h "_16")
        try clear $(h "_24")
        try clear $(h "_32")
        clear_facts $x:ident))

set_option hygiene false in
/-- `step_load` by the read fact `h`, with the load's `Fits` from `r` in the width the step states
(`mem_fact` misses it inside a limbs fact). -/
local macro "load_by " h:ident r:term:max : tactic =>
  `(tactic|
    ( have hl : Fits _ _ (Ty.bv 64).width := $r
      step_load [$h:ident] consuming $h:ident hl))

set_option hygiene false in
/-- Move a named value's equation `h` into `hdefs`, out of the steps' reach. -/
local macro "stash " h:ident : tactic => `(tactic| (replace hdefs := And.intro $h hdefs; clear $h))

set_option hygiene false in
/-- Peel `hdefs`'s equations, substituting each. -/
local macro "subst_defs" : tactic => `(tactic| repeat (obtain ⟨h, hdefs⟩ := hdefs; subst h))

set_option hygiene false in
/-- `Fe.mul` of the named `a`, `b`: the result named `n`, its bound `n_lt`, its equation stashed. -/
local macro "fe_mul " a:ident ", " b:ident " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(Lean.mkIdent (a.getId.appendAfter "_lt")).mono (by decide)
      have h2 : Fe.Lt $b (2 ^ 54) := $(Lean.mkIdent (b.getId.appendAfter "_lt")).mono (by decide)
      clear_limb_reads
      step_call using Fe_mul.call_eq_of consuming h1 h2
      have $(Lean.mkIdent (n.getId.appendAfter "_lt")) := Fe.mul.spec_lt $a $b
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

set_option hygiene false in
/-- `Fe.sq` of the named `a`, as `fe_mul`. -/
local macro "fe_sq " a:ident " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(Lean.mkIdent (a.getId.appendAfter "_lt")).mono (by decide)
      clear_limb_reads
      step_call using Fe_sq.call_eq_of consuming h1
      have $(Lean.mkIdent (n.getId.appendAfter "_lt")) := Fe.sq.spec_lt $a
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

set_option hygiene false in
/-- `Fe.sqn` of the named `a`, `k` times, as `fe_mul`. -/
local macro "fe_sqn " a:ident ", " k:num " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(Lean.mkIdent (a.getId.appendAfter "_lt")).mono (by decide)
      clear_limb_reads
      step_call using fe_sqn_call_eq_of consuming h1
      have $(Lean.mkIdent (n.getId.appendAfter "_lt")) :=
        Fe.sqn.spec_lt ($(Lean.mkIdent (a.getId.appendAfter "_lt")).mono (by decide)) $k
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

/-- `Fe_sqn.call_eq` on the limbs `A` read at `a`. -/
private theorem fe_sqn_call_eq_of (out a : Pointer) (n : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A)
    (hA' : Fe.Lt A (2 ^ 54)) (hn : n.toNat < 2 ^ 63) :
    Fe_sqn.call (Fe_sqn.args (.value out) (.value a) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (2 + 2 * n.toNat)⟩,
            mem := s.mem.storeLimbs out (Fe.sqn.spec n.toNat A) }) := by
  subst hA
  rw [Fe_sqn.call_eq out a n s hwf hout ha hA' hn, Nat.add_assoc]

/-- `Fe_neg.call_eq` on the limbs `A` read at `a`. -/
private theorem fe_neg_call_eq_of (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A)
    (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_neg.call (Fe_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Fe.neg.spec A) }) := by
  subst hA
  exact Fe_neg.call_eq out a s hwf hout ha hA'

/-- `Fe_reduce.call_eq` on the limbs `A` read at `fe`. -/
private theorem fe_reduce_call_eq_of (fe : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfe : s.mem.LimbsFit fe) (hA : s.mem.readLimbs fe = A) (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_reduce.call (Fe_reduce.args (.value fe)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs fe (Fe.reduce.spec A) }) := by
  subst hA
  exact Fe_reduce.call_eq fe s hwf hfe hA'

/-- `Fe_cMov.call_eq` on the limbs `F`, `A` read at `fe`, `a`. -/
private theorem fe_cMov_call_eq_of (fe a : Pointer) (c : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hfe : s.mem.LimbsFit fe) (ha : s.mem.LimbsFit a) (hF : s.mem.readLimbs fe = F)
    (hA : s.mem.readLimbs a = A) (hc : c.toNat < 2) :
    Fe_cMov.call (Fe_cMov.args (.value fe) (.value a) (.value c)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs fe (Fe.cMov.spec F A c) }) := by
  subst hF hA
  exact Fe_cMov.call_eq fe a c s hwf hfe ha hc

/-- The point's fields stored into a 160-byte block (`t` first), read back whole. -/
theorem readAt_fields {m : MemoryState} {p : Pointer} (hf : Room m p 1280) (ho : p.offset = 0)
    (x y z t : Fin 5 → BitVec 64) :
    ((((m.storeLimbs (p.add 120#64) t).storeAt p (limbsBits x)).storeAt (p.add 40#64)
                (limbsBits y)).storeAt
            (p.add 80#64) (limbsBits z)).readAt
        p 1280 =
      limbsBits t ++ limbsBits z ++ limbsBits y ++ limbsBits x := by
  have hi : InBounds m p 1280 := hf.inBounds
  have hov (k : BitVec 64) (hk : k.toNat ≤ 160) : ¬p.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq, Nat.not_le]; simp; omega
  rw [MemoryState.readAt_add_storeAt hi.storeLimbs.storeAt.storeAt (hov _ (by decide)) (by decide),
    MemoryState.readAt_add_storeAt hi.storeLimbs.storeAt (hov _ (by decide)) (by decide),
    MemoryState.readAt_storeAt_over hi.storeLimbs (by decide),
    MemoryState.storeLimbs_eq_storeAt (by simp [Pointer.add, ho]),
    MemoryState.readAt_add_storeAt hi (hov _ (by decide)) (by decide),
    show (120#64).toNat * 8 = 960 from rfl, show (40#64).toNat * 8 = 320 from rfl,
    show (80#64).toNat * 8 = 640 from rfl]
  generalize m.readAt p 1280 = W
  generalize limbsBits x = a
  generalize limbsBits y = b
  generalize limbsBits z = c
  generalize limbsBits t = d
  simp only [spliceBits_eq]
  bv_decide

/-- Bits known after another object's `lifetime.start`: known before it. -/
theorem Fits.of_lifetimeStart {m : MemoryState} {p q : Pointer} (hne : p.id ≠ q.id)
    (h : Fits (m.lifetimeStart q) p w) : Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  exact ⟨b, (MemoryState.getElem?_setLifetime_ne hne).symm.trans hb, hl, hw, hd⟩

/-- Limbs known after another object's `lifetime.start`: known before it. -/
theorem LimbsFit.of_lifetimeStart {m : MemoryState} {p q : Pointer} (hne : p.id ≠ q.id)
    (h : (m.lifetimeStart q).LimbsFit p) : m.LimbsFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact
    ⟨ho, Fits.of_lifetimeStart hne h0, Fits.of_lifetimeStart (hne' _) h1,
      Fits.of_lifetimeStart (hne' _) h2, Fits.of_lifetimeStart (hne' _) h3,
      Fits.of_lifetimeStart (hne' _) h4⟩

/-- Definedness in another object than a `lifetime.start`'s: as before it. -/
public theorem definedAt_lifetimeStart_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.lifetimeStart q).definedAt p w = m.definedAt p w :=
  definedAt_congr (MemoryState.getElem?_setLifetime_ne h.symm)

/-- Definedness in another object than a `lifetime.end`'s: as before it. -/
public theorem definedAt_lifetimeEnd_of_id_ne {m : MemoryState} {p q : Pointer} (h : q.id ≠ p.id) :
    (m.lifetimeEnd q).definedAt p w = m.definedAt p w :=
  definedAt_congr (MemoryState.getElem?_setLifetime_ne h.symm)

attribute [local mlir_read] definedAt_lifetimeStart_of_id_ne definedAt_lifetimeEnd_of_id_ne

/-- Room for the field element at byte `k` of a block's room from its start. -/
theorem limbsRoom_of_block {m : MemoryState} {p : Pointer} {v : Nat} (k : Nat) (h : Room m p v)
    (ho : p.offset = 0) (hk : 8 * k + 320 ≤ v) (hk' : k < 2 ^ 32) :
    m.LimbsRoom (p.add (BitVec.ofNat 64 k)) := by
  have hkn : (BitVec.ofNat 64 k).toNat = k := by
    rw [BitVec.toNat_ofNat]; omega
  have hr : Room m (p.add (BitVec.ofNat 64 k)) 320 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, ho, hkn]; omega)
      (by omega) h
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 32) :
    ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow off := by
    simp [BitVec.uaddOverflow, Pointer.add, ho, hkn]; omega
  refine
      ⟨by
        simp [Pointer.add, ho, hkn]; omega, hr.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) hr

/-- `readAt_fields`, with room for the block after the stores. -/
theorem readAt_fields' {m : MemoryState} {p : Pointer} (x y z t : Fin 5 → BitVec 64)
    (hf :
      Room
        ((((m.storeLimbs (p.add 120#64) t).storeAt p (limbsBits x)).storeAt (p.add 40#64)
              (limbsBits y)).storeAt
          (p.add 80#64) (limbsBits z))
        p 1280)
    (ho : p.offset = 0) :
    ((((m.storeLimbs (p.add 120#64) t).storeAt p (limbsBits x)).storeAt (p.add 40#64)
                (limbsBits y)).storeAt
            (p.add 80#64) (limbsBits z)).readAt
        p 1280 =
      limbsBits t ++ limbsBits z ++ limbsBits y ++ limbsBits x := by
  simp only [Room.storeAt_iff, Room.storeLimbs_iff] at hf
  exact readAt_fields hf ho x y z t

/-- A byte with one defined bit: poison, stored as an undefined zero byte. -/
theorem flattenDef_poison_byte (x : BitVec 8) :
    Ty.flattenDef (.bv 8) ((Ty.bv 8).unflattenDef x 1#8) = (0#8, 0#8) :=
  rfl

/-- The sign condition as the program computes it, widened first: Zig's, widened last. -/
theorem sign_eq (a : BitVec 8) (r : BitVec 64) :
    (BitVec.setWidth 64 a >>> 7 ^^^ BitVec.setWidth 64 (BitVec.setWidth 8 r) &&& 1#64) =
      (a >>> 7 ^^^ BitVec.setWidth 8 r &&& 1#8).setWidth 64 := by
  bv_decide

/-- A bit not `1` is `0`. -/
theorem bv1_eq_zero {x : BitVec 1} (h : ¬x = 1#1) : x = 0#1 := by bv_decide

/-- `cMov`'s condition `1 - has_m_root`, below `2`. -/
theorem setWidth_xor_one_lt (b : BitVec 1) : (BitVec.setWidth 64 b ^^^ 1#64).toNat < 2 := by
  have h : BitVec.setWidth 64 b ^^^ 1#64 < 2#64 := by bv_decide
  exact h

/-- `cMov`'s condition `is_negative ^ (s[31] >> 7)`, below `2`. -/
theorem sign_lt (a : BitVec 8) (b : BitVec 64) :
    (BitVec.setWidth 64 (a >>> 7 ^^^ BitVec.setWidth 8 b &&& 1#8)).toNat < 2 := by
  have h : BitVec.setWidth 64 (a >>> 7 ^^^ BitVec.setWidth 8 b &&& 1#8) < 2#64 := by bv_decide
  exact h

/-- `cMov` keeps a bound both inputs have. -/
theorem Fe.cMov.spec_lt' {F A : Fin 5 → BitVec 64} {c : BitVec 64} {C : Nat} (hF : Fe.Lt F C)
    (hA : Fe.Lt A C) (hc : c.toNat < 2) : Fe.Lt (Fe.cMov.spec F A c) C := by
  rw [Fe.cMov.spec_eq _ _ _ hc]; split <;> assumption

/-- `fromBytes`'s limbs are below `2^51`. -/
theorem Fe.fromBytes.spec_lt (b : BitVec 256) : Fe.Lt (Fe.fromBytes.spec b) (2 ^ 51) := by
  intro i; fin_cases i <;> exact mask_lt _

-- 39 slots and globals, 45 calls, 38 lifetime markers in one block, each step carrying the facts
set_option maxHeartbeats 4500000 in
/-- `Edwards25519.fromBytes` stores `spec` of the 32 bytes at `buf` at `out` (`storeFromBytes`):
the error union, 176 bytes. `buf` is read before `out` is written, so they may alias. -/
public theorem Edwards25519_fromBytes.call_eq (out buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 1408) (hout_off : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hbuf : Fits s.mem buf 256) (hbuf_off : buf.offset.toNat + 32 ≤ 2 ^ 64) :
    Edwards25519_fromBytes.call (Edwards25519_fromBytes.args (.value out) (.value buf)) s =
      .value
        (.nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  if (Edwards25519.fromBytes.spec (s.mem.readAt buf 256)).isSome then 601 else 595⟩,
            mem :=
              s.mem.storeFromBytes out (Edwards25519.fromBytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  have hB : S.mem.readAt buf 256 = S₀.mem.readAt buf 256 := by rw [hS]
  generalize S₀.mem.readAt buf 256 = B at hB ⊢
  block_init
  iterate 7 step_pure
  step_addressof Fe_edwards25519d.value_eq with gd
  have hgd_ne : gd.id ≠ S.allocaPtr.id := by
    subst hgd hS; simp [GlobalState.allocaPtr, GlobalState.slot]
  step_addressof Fe_one.value_eq with gone
  have hgd_ne : gd.id ≠ S.allocaPtr.id := by
    subst hgd hS; simp [GlobalState.allocaPtr, GlobalState.slot]; omega
  have hgone_ne : gone.id ≠ S.allocaPtr.id := by
    subst hgone hS; simp [GlobalState.allocaPtr, GlobalState.slot]
  iterate 8 step_pure
  step_addressof Edwards25519_fromBytes_invalid.value_eq with ginv
  have hginv_b : S.mem.readAt ginv 1408 = Edwards25519_fromBytes_invalid.bits :=
    hread_ginv.trans (by decide +kernel)
  have hginv_d : S.mem.definedAt ginv 1408 = Edwards25519.fromBytes.invalidDef := by
    rw [hS, hginv]
    exact
      (MemoryState.definedAt_storeDef_self (InBounds.allocaPtr (by omega)) _ _).trans
        (by decide +kernel)
  clear hread_ginv
  checkpoint hck0
  rename' S => S₁
  step_pure
  step_addressof Fe_sqrtm1.value_eq with gsq
  checkpoint hck1
  rename' S => S₂
  iterate 6 step_pure
  step_alloca with r
  step_alloca with p27
  step_alloca with p28
  step_alloca with p29
  step_alloca with p30
  step_alloca with p31
  step_alloca with p32
  step_alloca with p33
  step_alloca with p34
  step_alloca with p35
  step_alloca with p36
  step_alloca with p37
  step_alloca with p38
  step_alloca with p39
  step_alloca with p40
  step_alloca with p41
  step_alloca with p42
  step_alloca with p43
  step_alloca with bytes
  step_alloca with pt
  step_alloca with flag
  have hflag0 : S.mem.definedAt flag 8 = 0 := by
    rw [hS, hflag]; exact MemoryState.definedAt_alloca_allocaPtr
  step_alloca with nx
  step_alloca with xs
  step_alloca with pv
  step_alloca with mv
  step_alloca with vxx
  step_alloca with x2
  step_alloca with pw
  step_alloca with uv
  step_alloca with x
  step_alloca with v
  step_alloca with u
  step_alloca with v0
  step_alloca with u0
  step_alloca with y
  -- the globals' limbs
  have hrd : S.mem.readLimbs gd = Fe.d := by
    rw [MemoryState.readLimbs_of_readAt_fe hgd_fits hgd_off hread_gd]; funext i; fin_cases i <;> rfl
  have hro : S.mem.readLimbs gone = Fe.one := by
    rw [MemoryState.readLimbs_of_readAt_fe hgone_fits hgone_off hread_gone]
    funext i; fin_cases i <;> rfl
  have hrs : S.mem.readLimbs gsq = Fe.sqrtm1 := by
    rw [MemoryState.readLimbs_of_readAt_fe hgsq_fits hgsq_off hread_gsq]
    funext i; fin_cases i <;> rfl
  clear hread_gd hread_gone hread_gsq
  limbs_fit gd
  limbs_fit gone
  limbs_fit gsq
  -- y = Fe.fromBytes(s)
  step_pure
  step_memcpy
  step_load
  step_pure
  iterate 4
    step_pure
    step_load
    step_pure
    step_pure
  obtain ⟨hyo, r0, r8, r16, r24, r32⟩ := MemoryState.LimbsRoom.of_room hy_room hy_off
  step_store consuming r0
  step_pure
  step_store consuming r8
  step_pure
  step_store consuming r16
  step_pure
  step_store consuming r24
  step_pure
  step_store consuming r32
  step_pure
  have hry : S.mem.readLimbs y = Fe.fromBytes.spec B :=
    MemoryState.readLimbs_of_reads hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32
  have hy_limbs : S.mem.LimbsFit y := ⟨hyo, hfits_y, hfits_y_8, hfits_y_16, hfits_y_24, hfits_y_32⟩
  clear hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32 hfits_y hfits_y_8 hfits_y_16 hfits_y_24
    hfits_y_32 hyo
  checkpoint hck2
  clear hread_bytes
  -- the values as opaque names; literal limbs would whnf-time-out
  have Y_lt := Fe.fromBytes.spec_lt B
  generalize hYd : Fe.fromBytes.spec B = Y at Y_lt hry
  have D_lt : Fe.Lt Fe.d (2 ^ 51) := by
    intro i; fin_cases i <;> decide
  have ONE_lt : Fe.Lt Fe.one (2 ^ 51) := by
    intro i; fin_cases i <;> decide
  have SQ_lt : Fe.Lt Fe.sqrtm1 (2 ^ 51) := by
    intro i; fin_cases i <;> decide
  generalize hDd : Fe.d = D at D_lt hrd
  generalize hOd : Fe.one = ONE at ONE_lt hro
  generalize hQd : Fe.sqrtm1 = SQ at SQ_lt hrs
  have hdefs : True := trivial
  -- u = y², v = u d, u = u - 1, v = v + 1
  limbs_room u0
  fe_sq Y as U0
  limbs_room v0
  fe_mul U0, D as V0
  limbs_room u
  have h1 := U0_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := ONE_lt.mono (by decide : (2 : Nat) ^ 51 ≤ 2 ^ 63)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have U_lt :=
    (Fe.sub.spec_lt (b := ONE) U0_lt (by decide)).mono
      (by decide : (2 : Nat) ^ 52 + 2 ^ 52 ≤ 2 ^ 53)
  name_limbs U
  stash hU
  have htm := hS ▸ hu_limbs
  have htr := hS ▸ hread_u_readLimbs
  have hdR := hS ▸ hu0_limbs
  have f1 := hu0_limbs.fits.room
  have f2 := hu_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm hdR.1, htr] at hS
  have hru0 : S.mem.readLimbs u0 = U := by
    rw [hS]; exact MemoryState.readLimbs_storeLimbs_self hdR.room
  clear htm htr hdR
  have h1 := V0_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := ONE_lt.mono (by decide : (2 : Nat) ^ 51 ≤ 2 ^ 63)
  limbs_room v
  step_call using Fe_add.call_eq_of consuming h1 h2
  have V_lt :=
    (Fe.add.spec_lt V0_lt ONE_lt (by decide)).mono (by decide : (2 : Nat) ^ 52 + 2 ^ 51 ≤ 2 ^ 53)
  name_limbs V
  stash hV
  -- x = (u v)^(2^252 - 3) u, `pow2523` inlined
  drop v0
  limbs_room uv
  fe_mul U, V as UV
  checkpoint hck3
  clear_limb_reads
  iterate 17 step_pure
  limbs_room p27
  limbs_room p28
  limbs_room p29
  limbs_room p30
  limbs_room p31
  limbs_room p32
  limbs_room p33
  limbs_room p34
  limbs_room p35
  limbs_room p36
  limbs_room p37
  limbs_room p38
  limbs_room p39
  limbs_room p40
  limbs_room p41
  limbs_room p42
  limbs_room p43
  checkpoint hck4
  fe_sq UV as T0
  fe_mul UV, T0 as T1
  fe_sqn T1, 2 as T2
  fe_mul T1, T2 as T3
  fe_sq T3 as T4
  fe_mul T4, UV as T5
  fe_sqn T5, 5 as T6
  fe_mul T6, T5 as T7
  fe_sqn T7, 5 as T8
  fe_mul T8, T5 as T9
  checkpoint hck5
  fe_sqn T9, 15 as T10
  fe_mul T10, T9 as T11
  fe_sqn T11, 30 as T12
  fe_mul T12, T11 as T13
  fe_sqn T13, 60 as T14
  fe_mul T14, T13 as T15
  checkpoint hck6
  fe_sqn T15, 120 as T16
  fe_mul T16, T15 as T17
  fe_sqn T17, 10 as T18
  fe_mul T18, T7 as T19
  fe_sqn T19, 2 as T20
  limbs_room pw
  fe_mul T20, UV as PW
  iterate 17 step_pure
  limbs_room x
  fe_mul PW, U as X
  checkpoint hck7
  -- has_m_root = (x² v - u = 0)
  limbs_room x2
  fe_sq X as X2
  limbs_room vxx
  fe_mul X2, V as VXX
  limbs_room mv
  have h1 := VXX_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := U_lt.mono (by decide : (2 : Nat) ^ 53 ≤ 2 ^ 63)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have MV_lt :=
    (Fe.sub.spec_lt (b := U) VXX_lt (by decide)).mono (by decide : (2 : Nat) ^ 52 + 2 ^ 52 ≤ 2 ^ 63)
  name_limbs MV
  stash hMV
  step_call using Fe_isZero.call_eq_of with hasM
  checkpoint hck8
  -- vxx + u, inline
  have hpo (i : Fin 5) : (U i).uaddOverflow (VXX i) = false :=
    uaddOverflow_eq_false
      (by
        have := U_lt i; have := VXX_lt i; omega)
  have hu0_0 : S.mem.readAt u0 64 = U 0 := congrFun hru0 0
  have hu0_8 : S.mem.readAt (u0.add 8#64) 64 = U 1 := congrFun hru0 1
  have hu0_16 : S.mem.readAt (u0.add 16#64) 64 = U 2 := congrFun hru0 2
  have hu0_24 : S.mem.readAt (u0.add 24#64) 64 = U 3 := congrFun hru0 3
  have hu0_32 : S.mem.readAt (u0.add 32#64) 64 = U 4 := congrFun hru0 4
  obtain ⟨hvo, fv0, fv8, fv16, fv24, fv32⟩ := hvxx_limbs
  obtain ⟨huo, fu0, fu8, fu16, fu24, fu32⟩ := hu0_limbs
  load_by hread_vxx fv0
  load_by hu0_0 fu0
  step_pure [hpo 0]
  step_pure
  load_by hread_vxx_8 fv8
  step_pure
  load_by hu0_8 fu8
  step_pure [hpo 1]
  step_pure
  load_by hread_vxx_16 fv16
  step_pure
  load_by hu0_16 fu16
  step_pure [hpo 2]
  step_pure
  load_by hread_vxx_24 fv24
  step_pure
  load_by hu0_24 fu24
  step_pure [hpo 3]
  step_pure
  load_by hread_vxx_32 fv32
  step_pure
  load_by hu0_32 fu32
  step_pure [hpo 4]
  clear hpo hvo huo fv0 fv8 fv16 fv24 fv32 fu0 fu8 fu16 fu24 fu32
  obtain ⟨hpvo, r0, r8, r16, r24, r32⟩ := MemoryState.LimbsRoom.of_room hpv_room hpv_off
  step_store consuming r0
  step_pure
  step_store consuming r8
  step_pure
  step_store consuming r16
  step_pure
  step_store consuming r24
  step_pure
  step_store consuming r32
  have hrpv : S.mem.readLimbs pv = Fe.add.spec VXX U :=
    MemoryState.readLimbs_of_reads hread_pv hread_pv_8 hread_pv_16 hread_pv_24 hread_pv_32
  have hpv_limbs : S.mem.LimbsFit pv :=
    ⟨hpvo, hfits_pv, hfits_pv_8, hfits_pv_16, hfits_pv_24, hfits_pv_32⟩
  clear hread_pv hread_pv_8 hread_pv_16 hread_pv_24 hread_pv_32 hfits_pv hfits_pv_8 hfits_pv_16
    hfits_pv_24 hfits_pv_32 hpvo
  have h1 :=
    (Fe.add.spec_lt VXX_lt U_lt (by decide)).mono (by decide : (2 : Nat) ^ 52 + 2 ^ 53 ≤ 2 ^ 63)
  step_call using Fe_isZero.call_eq_of with hasP consuming h1 hrpv
  step_pure
  finish_block
  case isFalse =>
    block_init
    step_memcpy consuming hout hbuf hB
    finish_block
    block_init
    finish_block
    rw [hS]
    clear hS
    subst hck8 hck7 hck6 hck5 hck4 hck3 hck2 hck1 hck0
    erase_frame
    have hsp : Edwards25519.fromBytes.spec B = none := by
      have hn := bv1_eq_zero hbr
      clear * - hdefs hhasM hhasP hn hYd hDd hOd hQd
      subst hYd hDd hOd hQd hhasM hhasP
      subst_defs
      simp only [Edwards25519.fromBytes.spec, Fe.pow2523.spec, hn, ↓reduceIte]
    rw [hsp]
    rfl
  case isTrue =>
    -- x.cMov(x √-1, 1 - has_m_root)
    block_init
    limbs_room xs
    fe_mul X, SQ as XS
    step_pure
    step_pure
    have hc1 := setWidth_xor_one_lt hasM
    step_call using fe_cMov_call_eq_of consuming hc1
    have X1_lt := Fe.cMov.spec_lt' X_lt XS_lt (setWidth_xor_one_lt hasM)
    name_limbs X1
    stash hX1
    have h1 := X1_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 63)
    limbs_room nx
    step_call using fe_neg_call_eq_of consuming h1
    have NX_lt := Fe.neg.spec_lt53 X1
    name_limbs NX
    stash hNX
    checkpoint hck9
    rename' S => S₉
    step_pure
    limbs_room r
    have hxr : x.id ≠ r.id := by
      rw [hx, hr]; exact GlobalState.slot_id_ne (by decide)
    have htm : S₉.mem.LimbsFit x := by
      have h := hx_limbs; rw [hS] at h; exact LimbsFit.of_lifetimeStart hxr h
    have htr : S₉.mem.readLimbs x = X1 := by
      have h := hread_x_readLimbs; rw [hS] at h; simpa [MemoryState.readLimbs_lifetimeStart] using h
    have hdR := hS ▸ hr_limbs
    have f1 := hr_limbs.room
    have f2 := hx_limbs.fits
    step_memcpy consuming f1 f2
    rw [MemoryState.storeAt_readAt_eq_storeLimbs htm hdR.1, htr] at hS
    have hrr : S.mem.readLimbs r = X1 := by
      rw [hS]; exact MemoryState.readLimbs_storeLimbs_self hdR
    have hr_limbs : S.mem.LimbsFit r := by
      rw [hS]; exact MemoryState.LimbsFit.storeLimbs_self hdR
    clear htm htr hdR
    have h1 := X1_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 63)
    step_call using fe_reduce_call_eq_of consuming h1 hrr
    load_by hread_r hr_limbs.2.1
    step_pure
    step_pure
    have hb31 : S.mem.readAt (buf.add 31#64) 8 = B.extractLsb' 248 8 :=
      MemoryState.readAt_add_of_readAt hbuf.inBounds
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by decide) hB
    have hf31 : Fits S.mem (buf.add 31#64) 8 :=
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by decide) hbuf
    step_load [hb31] consuming hb31 hf31
    iterate 5 step_pure
    rw [sign_eq] at hE
    have hc2 := sign_lt (BitVec.extractLsb' 248 8 B) (Fe.reduce.spec X1 0)
    generalize hC2 :
      BitVec.setWidth 64
        (BitVec.extractLsb' 248 8 B >>> 7 ^^^ BitVec.setWidth 8 (Fe.reduce.spec X1 0) &&& 1#8) =
      C2 at hE hc2
    have hc2' := hc2
    step_call using fe_cMov_call_eq_of consuming hc2
    have XF_lt := Fe.cMov.spec_lt' (X1_lt.mono (by decide : (2 : Nat) ^ 52 ≤ 2 ^ 53)) NX_lt hc2'
    name_limbs XF
    stash hXF
    checkpoint hck10
    -- t = x y, then the point's fields copied
    step_pure
    have h1 := XF_lt.mono (by decide : (2 : Nat) ^ 53 ≤ 2 ^ 54)
    have h2 := Y_lt.mono (by decide : (2 : Nat) ^ 51 ≤ 2 ^ 54)
    have hp120 := limbsRoom_of_block 120 hpt_room hpt_off (by decide) (by decide)
    step_call using Fe_mul.call_eq_of consuming h1 h2 hp120
    name_limbs T
    stash hT
    have hxb : S.mem.readAt x 320 = limbsBits XF := by
      rw [MemoryState.readAt_eq_limbsBits hx_limbs, hread_x_readLimbs]
    have f2 := hx_limbs.fits
    step_memcpy consuming f2 hxb
    step_pure
    have hyb : S.mem.readAt y 320 = limbsBits Y := by
      rw [MemoryState.readAt_eq_limbsBits hy_limbs, hry]
    have f2 := hy_limbs.fits
    step_memcpy consuming f2 hyb
    step_pure
    have hob : S.mem.readAt gone 320 = limbsBits ONE := by
      rw [MemoryState.readAt_eq_limbsBits hgone_limbs, hro]
    have f2 := hgone_limbs.fits
    step_memcpy consuming f2 hob
    have hptv :
      S.mem.readAt pt 1280 = limbsBits T ++ limbsBits ONE ++ limbsBits Y ++ limbsBits XF := by
      have h := hpt_room
      rw [hS] at h ⊢
      exact readAt_fields' _ _ _ _ h hpt_off
    checkpoint hck11
    -- reversed, so it stays about the state before the store
    have hfl : (0 : BitVec 8) = S.mem.definedAt flag 8 := hflag0.symm
    have f1 : Room S.mem flag 1 := hflag_room.mono (by omega)
    step_store consuming f1
    have hfd : S.mem.definedAt flag 8 = 1#8 := by
      have h := hflag_room
      rw [hS] at h ⊢
      rw [MemoryState.definedAt_storeAt_over (Room.storeAt_iff.mp h).inBounds (by omega), ← hfl,
        spliceBits_eq]
      decide
    clear hfl
    step_pure
    have f1 : Room S.mem (out.add 168#64) 16 :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by decide) hout
    step_store consuming f1
    have hov (k : BitVec 64) (hk : k.toNat ≤ 160) : ¬pt.offset.uaddOverflow k := by
      simp only [BitVec.uaddOverflow, hpt_off, decide_eq_true_eq, Nat.not_le]; simp; omega
    have a0 : Fits S.mem pt 320 := by mem_fact
    have a1 : Fits S.mem (pt.add 40#64) 320 := by mem_fact
    have a2 : Fits S.mem (pt.add 80#64) 320 := by mem_fact
    have a3 : Fits S.mem (pt.add 120#64) 320 :=
      (show S.mem.LimbsFit (pt.add 120#64) by mem_fact).fits
    have a01 : Fits S.mem pt 640 :=
      Fits.append (hov 40#64 (by decide)) (by decide) (by decide) a0 a1
    have a02 : Fits S.mem pt 960 :=
      Fits.append (hov 80#64 (by decide)) (by decide) (by decide) a01 a2
    have f2 : Fits S.mem pt 1280 :=
      Fits.append (hov 120#64 (by decide)) (by decide) (by decide) a02 a3
    clear hov a0 a1 a2 a3 a01 a02
    step_memcpy consuming f2 hptv hfits_out_168 hbuf
    step_pure
    step_impure [hfd] => exact run_loadDef (by mem_fact)
    have f1 : Room S.mem (out.add 160#64) 8 ∧ True :=
      ⟨Room.add_of_le
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by decide) hout,
        trivial⟩
    -- `out`'s facts are done with; the byte is poison, stored undefined
    clear_facts out
    step_impure consuming f1 => exact run_storeDef f1.1 (by simp [Ty.hasPtr])
    simp only [flattenDef_poison_byte] at hS
    finish_block
    block_init
    finish_block
    rw [hS]
    clear hS
    subst hck11 hck10 hck9 hck8 hck7 hck6 hck5 hck4 hck3 hck2 hck1 hck0
    erase_frame
    have hsp : Edwards25519.fromBytes.spec B = some ⟨XF, Y, ONE, T⟩ := by
      have hn : ¬hasM ||| hasP = 0#1 := by
        rw [hbr]; decide
      clear * - hdefs hhasM hhasP hn hYd hDd hOd hQd hC2
      subst hYd hDd hOd hQd hhasM hhasP hC2
      subst_defs
      simp only [Edwards25519.fromBytes.spec, Fe.pow2523.spec, Edwards25519.fromBytes.sign, hn,
        ↓reduceIte]
    rw [hsp]
    rfl

end Proof

end MLIR.Zig

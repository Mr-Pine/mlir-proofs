module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Globals
public import Zig.Steps
public import Zig.Fe_mul
public import Zig.Fe_sq
public import Zig.Fe_sqn
public import Zig.Fe_isZero
public import Zig.Fe_cMov
public import Zig.Fe_neg
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Mlir.Edwards25519_fromBytes
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas
import all MLIR.Ty

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

/-- The `InvalidEncoding` result's bits: a zero point, error code `2` at byte 168. -/
def Edwards25519.fromBytes.invalidBits : BitVec 1408 :=
  2#1408 <<< 1344

/-- The `EncodingError!Edwards25519` `fromBytes` stores at `out`, 176 bytes: a point with `is_base`
byte `0` (the rest byte's others kept) and error code `0`; or the `InvalidEncoding` constant, a
zero point and error code `2`. -/
def _root_.MLIR.MemoryState.storeFromBytes (m : MemoryState) (out : Pointer) :
    Option ZPt → MemoryState
  | some P => (m.storeAt (out.add 168#64) 0#16).storePt out P (m.readRest out &&& 0xffffffffffffff00#64)
  | none => m.storeAt out Edwards25519.fromBytes.invalidBits

end

/-! ## Proof -/

section Proof

/-- The invalid-encoding global: a zero point, error code `2`. -/
public theorem Edwards25519_fromBytes_invalid.value_eq (s : GlobalState) :
    Edwards25519_fromBytes_invalid.value s =
      .value (Ty.wrap Edwards25519_fromBytes_invalid.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `Fe_sqn.call_eq` on the limbs `A` read at `a`. -/
theorem Fe_sqn.call_eq_of (out a : Pointer) (n : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A)
    (hA' : Fe.Lt A (2 ^ 54)) (hn : n.toNat < 2 ^ 63) :
    Fe_sqn.call (Fe_sqn.args (.value out) (.value a) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (2 + 2 * n.toNat)⟩,
            mem := s.mem.storeLimbs out (Fe.sqn.spec n.toNat A) }) := by
  subst hA
  rw [Fe_sqn.call_eq out a n s hwf hout ha hA' hn, Nat.add_assoc]

/-- `Fe_neg.call_eq` on the limbs `A` read at `a`. -/
theorem Fe_neg.call_eq_of (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A)
    (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_neg.call (Fe_neg.args (.value out) (.value a)) s =
      .value
        (.nil, { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem.storeLimbs out (Fe.neg.spec A) }) := by
  subst hA
  exact Fe_neg.call_eq out a s hwf hout ha hA'

/-- `Fe_reduce.call_eq` on the limbs `A` read at `fe`. -/
theorem Fe_reduce.call_eq_of (fe : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfe : s.mem.LimbsFit fe) (hA : s.mem.readLimbs fe = A) (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_reduce.call (Fe_reduce.args (.value fe)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs fe (Fe.reduce.spec A) }) := by
  subst hA
  exact Fe_reduce.call_eq fe s hwf hfe hA'

/-- `Fe_cMov.call_eq` on the limbs `F`, `A` read at `fe`, `a`. -/
theorem Fe_cMov.call_eq_of (fe a : Pointer) (c : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hfe : s.mem.LimbsFit fe) (ha : s.mem.LimbsFit a) (hF : s.mem.readLimbs fe = F)
    (hA : s.mem.readLimbs a = A) (hc : c.toNat < 2) :
    Fe_cMov.call (Fe_cMov.args (.value fe) (.value a) (.value c)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs fe (Fe.cMov.spec F A c) }) := by
  subst hF hA
  exact Fe_cMov.call_eq fe a c s hwf hfe ha hc

/-- A field element's bits stored where its limbs fit read back as it. -/
theorem readLimbs_storeAt_limbsBits {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (hp : m.LimbsFit p) : (m.storeAt p (limbsBits l)).readLimbs p = l := by
  rw [← MemoryState.storeLimbs_eq_storeAt hp.1, MemoryState.readLimbs_storeLimbs_self hp]

/-- The field element at byte `k` of a block read from its start. -/
theorem limbsFit_of_block {m : MemoryState} {p : Pointer} {v : Nat} (k : Nat) (h : Fits m p v)
    (ho : p.offset = 0) (hk : 8 * k + 320 ≤ v) (hk' : k < 2 ^ 32) :
    m.LimbsFit (p.add (BitVec.ofNat 64 k)) := by
  have hkn : (BitVec.ofNat 64 k).toNat = k := by rw [BitVec.toNat_ofNat]; omega
  refine MemoryState.LimbsFit.of_fits' (Fits.add_of_le ?_ (by omega) h) ?_
  · simp [BitVec.uaddOverflow, ho, hkn]; omega
  · simp [Pointer.add, ho, hkn]; omega

/-- `readAt`, as a fact the steps carry only past writes to other blocks. -/
def _root_.MLIR.MemoryState.readBlk (m : MemoryState) (p : Pointer) (w : Nat) : BitVec w :=
  m.readAt p w

@[mlir_read]
theorem _root_.MLIR.MemoryState.readBlk_storeAt_of_id_ne {m : MemoryState}
    {p q : Pointer} {x : BitVec v} (h : q.id ≠ p.id) :
    (m.storeAt q x).readBlk p w = m.readBlk p w :=
  MemoryState.readAt_storeAt_disjoint (by simp only [Range.Disjoint, Range.of]; exact .inl h) x

@[mlir_read]
theorem _root_.MLIR.MemoryState.readBlk_storeLimbs_of_id_ne {m : MemoryState}
    {p q : Pointer} {l : Fin 5 → BitVec 64} (h : q.id ≠ p.id) :
    (m.storeLimbs q l).readBlk p w = m.readBlk p w := by
  have h' (k : BitVec 64) : (q.add k).id ≠ p.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeLimbs, MemoryState.readBlk_storeAt_of_id_ne h,
    MemoryState.readBlk_storeAt_of_id_ne (h' _)]

/-- `readBlk` past an `alloca`. -/
@[mlir_read]
theorem _root_.MLIR.MemoryState.readBlk_alloca {s : GlobalState} {p : Pointer}
    (hwf : s.WF) (h : Fits s.mem p w) : (s.alloca n).mem.readBlk p w = s.mem.readBlk p w :=
  MemoryState.readAt_alloca hwf h

/-- A store inside a block read whole from its start: spliced into the read. -/
theorem _root_.MLIR.MemoryState.readBlk_storeAt_add {m : MemoryState} {p : Pointer}
    {off : BitVec 64} {x : BitVec w} (hf : Fits m p v) (ho : p.offset = 0)
    (hw : off.toNat * 8 + w ≤ v) :
    (m.storeAt (p.add off) x).readBlk p v = spliceBits (m.readBlk p v) (off.toNat * 8) x := by
  have hov : ¬p.offset.uaddOverflow off := by
    have := off.isLt
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq, Nat.not_le]
    simpa using this
  rw [MemoryState.storeAt_add_eq hf hov hw]
  exact MemoryState.readAt_storeAt_self hf _

/-- The same at the block's start. -/
@[mlir_read]
theorem _root_.MLIR.MemoryState.readBlk_storeAt_base {m : MemoryState} {p : Pointer}
    {x : BitVec w} (hf : Fits m p v) (ho : p.offset = 0) (hw : w ≤ v) :
    (m.storeAt p x).readBlk p v = spliceBits (m.readBlk p v) 0 x := by
  have := MemoryState.readBlk_storeAt_add (off := 0#64) (x := x) hf ho (by simpa using hw)
  simpa [Pointer.add_zero] using this

/-- Limbs stored inside a block read whole from its start: their bits spliced into the read. -/
theorem _root_.MLIR.MemoryState.readBlk_storeLimbs_add {m : MemoryState} {p : Pointer}
    {off : BitVec 64} {l : Fin 5 → BitVec 64} (hf : Fits m p v) (ho : p.offset = 0)
    (hw : off.toNat * 8 + 320 ≤ v) (hv : v < 2 ^ 32) :
    (m.storeLimbs (p.add off) l).readBlk p v =
      spliceBits (m.readBlk p v) (off.toNat * 8) (limbsBits l) := by
  rw [MemoryState.storeLimbs_eq_storeAt (by simp [Pointer.add, ho]; omega)]
  exact MemoryState.readBlk_storeAt_add hf ho hw

/-- The point's fields stored into a 160-byte block (`t` first), read back whole. -/
theorem readAt_fields {m : MemoryState} {p : Pointer} (hf : Fits m p 1280) (ho : p.offset = 0)
    (x y z t : Fin 5 → BitVec 64) :
    ((((m.storeLimbs (p.add 120#64) t).storeAt p (limbsBits x)).storeAt (p.add 40#64)
            (limbsBits y)).storeAt (p.add 80#64) (limbsBits z)).readAt p 1280 =
      limbsBits t ++ limbsBits z ++ limbsBits y ++ limbsBits x := by
  change MemoryState.readBlk _ p 1280 = _
  rw [MemoryState.readBlk_storeAt_add hf.storeLimbs.storeAt.storeAt ho (by decide),
    MemoryState.readBlk_storeAt_add hf.storeLimbs.storeAt ho (by decide),
    MemoryState.readBlk_storeAt_base hf.storeLimbs ho (by decide),
    MemoryState.readBlk_storeLimbs_add hf ho (by decide) (by decide),
    show (120#64).toNat * 8 = 960 from rfl, show (40#64).toNat * 8 = 320 from rfl,
    show (80#64).toNat * 8 = 640 from rfl]
  generalize m.readBlk p 1280 = W
  generalize limbsBits x = a
  generalize limbsBits y = b
  generalize limbsBits z = c
  generalize limbsBits t = d
  simp only [spliceBits_eq]
  bv_decide

/-- A store past a point's last 8 bytes leaves them. -/
theorem readRest_storeAt_168 {m : MemoryState} {p : Pointer} (ho : p.offset.toNat + 176 ≤ 2 ^ 64)
    (x : BitVec 16) : (m.storeAt (p.add 168#64) x).readRest p = m.readRest p := by
  apply MemoryState.readAt_storeAt_disjoint
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  right; right
  have h1 : (168#64).toNat = 168 := rfl
  have h2 : (160#64).toNat = 160 := rfl
  rw [h1, h2, Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- The point's fields, then a zero `is_base` byte: a point store, the rest byte's others kept. -/
theorem storeAt_point_eq {m : MemoryState} {p : Pointer} (h : m.PtFit p)
    (x y z t : Fin 5 → BitVec 64) :
    (m.storeAt p (limbsBits t ++ limbsBits z ++ limbsBits y ++ limbsBits x)).storeAt
        (p.add 160#64) 0#8 =
      m.storePt p ⟨x, y, z, t⟩ (m.readRest p &&& 0xffffffffffffff00#64) := by
  have hov (k : Nat) (hk : k < 168) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have e0 := MemoryState.storeAt_add_eq (off := 0#64) h.2 (hov 0 (by omega)) (by simp)
    (limbsBits t ++ limbsBits z ++ limbsBits y ++ limbsBits x)
  rw [Pointer.add_zero] at e0
  rw [e0, MemoryState.storeAt_add_eq h.2.storeAt (hov 160 (by omega)) (by simp),
    MemoryState.readAt_storeAt_self h.2, MemoryState.storeAt_storeAt_self]
  have hr : m.readRest p = (m.readAt p 1344).extractLsb' 1280 64 := by
    rw [MemoryState.readRest,
      MemoryState.readAt_add_of_readAt (off := 160#64) (w := 64) h.2 (hov 160 (by omega)) (by simp)
        rfl]
    rfl
  rw [MemoryState.storePt, hr]
  congr 1
  simp only [ZPt.bits]
  generalize m.readAt p 1344 = W
  generalize limbsBits x = a
  generalize limbsBits y = b
  generalize limbsBits z = c
  generalize limbsBits t = d
  simp only [spliceBits_eq, show (0#64).toNat * 8 = 0 from rfl,
    show (160#64).toNat * 8 = 1280 from rfl]
  bv_decide

/-- The invalid-encoding global is 176 bytes. -/
theorem width_invTy : Edwards25519_fromBytes_invalid.t.width = 1408 := by decide

/-- Its bits: `invalidBits`. -/
theorem invalid_bits :
    Ty.flatBits Edwards25519_fromBytes_invalid.lit (hw := width_invTy) =
      Edwards25519.fromBytes.invalidBits := by
  decide +kernel

/-- The sign condition as the program computes it, widened first: Zig's, widened last. -/
theorem sign_eq (a : BitVec 8) (r : BitVec 64) :
    (BitVec.setWidth 64 a >>> 7 ^^^ BitVec.setWidth 64 (BitVec.setWidth 8 r) &&& 1#64) =
      (a >>> 7 ^^^ BitVec.setWidth 8 r &&& 1#8).setWidth 64 := by
  bv_decide

/-- A bit not `1` is `0`. -/
theorem bv1_eq_zero {x : BitVec 1} (h : ¬x = 1#1) : x = 0#1 := by bv_decide

/-- Peel `hdefs`'s equations, substituting each. -/
macro "subst_defs" : tactic =>
  `(tactic| repeat (obtain ⟨h, $(Lean.mkIdent `hdefs)⟩ := $(Lean.mkIdent `hdefs); subst h))

/-- A fresh block reads zero. -/
theorem readAt_alloca_fresh {s : GlobalState} {p : Pointer} (h : p.id.id = s.alloc.nextFreeBlock) :
    (s.alloca n).mem.readBlk p w = 0#w := by
  have : p.id = ⟨s.alloc.nextFreeBlock⟩ := by cases hp : p.id; simp_all
  simp [MemoryState.readBlk, MemoryState.readAt, GlobalState.alloca, MemoryState.getElem?_eq, this]

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

/-- Move a named value's equation `h` into `hdefs`, out of the steps' reach. -/
macro "stash " h:ident : tactic =>
  `(tactic| (replace $(Lean.mkIdent `hdefs) := And.intro $h $(Lean.mkIdent `hdefs); clear $h))

/-- `a`'s bound `a_lt`, for a field call's input. -/
meta def ltIdent (a : Lean.Ident) : Lean.Ident :=
  Lean.mkIdent (a.getId.appendAfter "_lt")

/-- `Fe.mul` of the named `a`, `b`: the result named `n`, its bound `n_lt`, its equation stashed. -/
macro "fe_mul " a:ident ", " b:ident " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(ltIdent a).mono (by decide)
      have h2 : Fe.Lt $b (2 ^ 54) := $(ltIdent b).mono (by decide)
      step_call using Fe_mul.call_eq_of consuming h1 h2
      have $(ltIdent n) := Fe.mul.spec_lt $a $b
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

/-- `Fe.sq` of the named `a`, as `fe_mul`. -/
macro "fe_sq " a:ident " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(ltIdent a).mono (by decide)
      step_call using Fe_sq.call_eq_of consuming h1
      have $(ltIdent n) := Fe.sq.spec_lt $a
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

/-- `Fe.sqn` of the named `a`, `k` times, as `fe_mul`. -/
macro "fe_sqn " a:ident ", " k:num " as " n:ident : tactic =>
  `(tactic|
    ( have h1 : Fe.Lt $a (2 ^ 54) := $(ltIdent a).mono (by decide)
      step_call using Fe_sqn.call_eq_of consuming h1
      have $(ltIdent n) := Fe.sqn.spec_lt ($(ltIdent a).mono (by decide)) $k
      name_limbs $n
      stash $(Lean.mkIdent (n.getId.appendBefore "h"))))

set_option maxHeartbeats 4000000 in
/-- `Edwards25519.fromBytes` stores `spec` of the 32 bytes at `buf` at `out` (`storeFromBytes`): the
error union, 176 bytes. `buf` is read before `out` is written, so they may alias. -/
public theorem Edwards25519_fromBytes.call_eq (out buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 1408) (hout_off : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hbuf : Fits s.mem buf 256) (hbuf_off : buf.offset.toNat + 32 ≤ 2 ^ 64) :
    Edwards25519_fromBytes.call (Edwards25519_fromBytes.args (.value out) (.value buf)) s =
      .value
        (.nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  if (Edwards25519.fromBytes.spec (s.mem.readAt buf 256)).isSome then 601 else 595⟩,
            mem := s.mem.storeFromBytes out (Edwards25519.fromBytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  have hB : S.mem.readAt buf 256 = S₀.mem.readAt buf 256 := by rw [hS]
  generalize S₀.mem.readAt buf 256 = B at hB ⊢
  block_init
  iterate 7 step_pure
  step_addressof Fe_edwards25519d.value_eq with gd
  step_addressof Fe_one.value_eq with gone
  iterate 8 step_pure
  step_addressof Edwards25519_fromBytes_invalid.value_eq with ginv
  step_pure
  step_addressof Fe_sqrtm1.value_eq with gsq
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
  have hrfl : S.mem.readBlk flag 8 = 0#8 := by
    rw [hS]
    exact readAt_alloca_fresh (by rw [hflag]; simp only [GlobalState.slot_id_id, GlobalState.alloca_alloc])
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
  limbs_fit r
  limbs_fit p27
  limbs_fit p28
  limbs_fit p29
  limbs_fit p30
  limbs_fit p31
  limbs_fit p32
  limbs_fit p33
  limbs_fit p34
  limbs_fit p35
  limbs_fit p36
  limbs_fit p37
  limbs_fit p38
  limbs_fit p39
  limbs_fit p40
  limbs_fit p41
  limbs_fit p42
  limbs_fit p43
  limbs_fit nx
  limbs_fit xs
  limbs_fit pv
  limbs_fit mv
  limbs_fit vxx
  limbs_fit x2
  limbs_fit pw
  limbs_fit uv
  limbs_fit x
  limbs_fit v
  limbs_fit u
  limbs_fit v0
  limbs_fit u0
  limbs_fit y
  -- the globals' limbs
  have hrd : S.mem.readLimbs gd = Fe.d := by
    rw [MemoryState.readLimbs_of_readAt_fe hgd_fits hgd_off hread_gd]; funext i; fin_cases i <;> rfl
  have hro : S.mem.readLimbs gone = Fe.one := by
    rw [MemoryState.readLimbs_of_readAt_fe hgone_fits hgone_off hread_gone]; funext i; fin_cases i <;> rfl
  have hrs : S.mem.readLimbs gsq = Fe.sqrtm1 := by
    rw [MemoryState.readLimbs_of_readAt_fe hgsq_fits hgsq_off hread_gsq]; funext i; fin_cases i <;> rfl
  clear hread_gd hread_gone hread_gsq
  limbs_fit gd
  limbs_fit gone
  limbs_fit gsq
  -- reads of blocks only the frame's writes miss, as `readBlk` facts
  have hrbuf : S.mem.readBlk buf 256 = B := hB
  have hrinv : S.mem.readBlk ginv 1408 = Ty.flatBits Edwards25519_fromBytes_invalid.lit := hread_ginv
  have hpt0 := limbsFit_of_block 0 hpt_fits hpt_off (by decide) (by decide)
  have hpt40 := limbsFit_of_block 40 hpt_fits hpt_off (by decide) (by decide)
  have hpt80 := limbsFit_of_block 80 hpt_fits hpt_off (by decide) (by decide)
  have hpt120 := limbsFit_of_block 120 hpt_fits hpt_off (by decide) (by decide)
  rw [Pointer.add_zero] at hpt0
  -- y = Fe.fromBytes(s)
  step_pure
  have f1 := hbytes_fits
  step_memcpy consuming f1
  have hrb : S.mem.readAt bytes 256 = B := by
    have h := hbytes_fits
    rw [hS] at h ⊢
    rw [Fits.storeAt_iff] at h
    exact MemoryState.readAt_storeAt_self h B
  step_load
  step_pure
  iterate 4
    step_pure
    step_load
    step_pure
    step_pure
  step_store
  iterate 4
    step_pure
    step_store
  step_pure
  read_stores y, Fe.fromBytes.spec B with hry
  checkpoint hck0
  -- the values as opaque names; literal limbs would whnf-time-out
  have Y_lt := Fe.fromBytes.spec_lt B
  generalize hYd : Fe.fromBytes.spec B = Y at Y_lt hry
  have D_lt : Fe.Lt Fe.d (2 ^ 51) := by intro i; fin_cases i <;> decide
  have ONE_lt : Fe.Lt Fe.one (2 ^ 51) := by intro i; fin_cases i <;> decide
  have SQ_lt : Fe.Lt Fe.sqrtm1 (2 ^ 51) := by intro i; fin_cases i <;> decide
  generalize hDd : Fe.d = D at D_lt hrd
  generalize hOd : Fe.one = ONE at ONE_lt hro
  generalize hQd : Fe.sqrtm1 = SQ at SQ_lt hrs
  have hdefs : True := trivial
  -- u = y², v = u d, u = u - 1, v = v + 1
  fe_sq Y as U0
  fe_mul U0, D as V0
  have h1 := U0_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := ONE_lt.mono (by decide : (2:Nat) ^ 51 ≤ 2 ^ 63)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have U_lt := (Fe.sub.spec_lt (b := ONE) U0_lt (by decide)).mono
    (by decide : (2:Nat) ^ 52 + 2 ^ 52 ≤ 2 ^ 53)
  name_limbs U
  stash hU
  have f1 := hu0_limbs.fits
  have f2 := hu_limbs.fits
  have hcv := MemoryState.readAt_eq_limbsBits hu_limbs.fits hu_limbs.1
  step_memcpy consuming f1 f2 hcv
  have hru0 : S.mem.readLimbs u0 = U := by
    have h := hu0_limbs
    rw [hS] at h ⊢
    rw [MemoryState.limbsFit_storeAt_iff] at h
    exact readLimbs_storeAt_limbsBits h
  have h1 := V0_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := ONE_lt.mono (by decide : (2:Nat) ^ 51 ≤ 2 ^ 63)
  step_call using Fe_add.call_eq_of consuming h1 h2
  have V_lt := (Fe.add.spec_lt V0_lt ONE_lt (by decide)).mono
    (by decide : (2:Nat) ^ 52 + 2 ^ 51 ≤ 2 ^ 53)
  name_limbs V
  stash hV
  -- x = (u v)^(2^252 - 3) u, `pow2523` inlined
  fe_mul U, V as UV
  iterate 17 step_pure
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
  fe_sqn T9, 15 as T10
  fe_mul T10, T9 as T11
  fe_sqn T11, 30 as T12
  fe_mul T12, T11 as T13
  fe_sqn T13, 60 as T14
  fe_mul T14, T13 as T15
  fe_sqn T15, 120 as T16
  fe_mul T16, T15 as T17
  fe_sqn T17, 10 as T18
  fe_mul T18, T7 as T19
  fe_sqn T19, 2 as T20
  fe_mul T20, UV as PW
  iterate 17 step_pure
  fe_mul PW, U as X
  -- has_m_root = (x² v - u = 0)
  fe_sq X as X2
  fe_mul X2, V as VXX
  have h1 := VXX_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 63)
  have h2 := U_lt.mono (by decide : (2:Nat) ^ 53 ≤ 2 ^ 63)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have MV_lt := (Fe.sub.spec_lt (b := U) VXX_lt (by decide)).mono
    (by decide : (2:Nat) ^ 52 + 2 ^ 52 ≤ 2 ^ 63)
  name_limbs MV
  stash hMV
  step_call using Fe_isZero.call_eq_of with hasM
  -- vxx + u, inline
  have hpo (i : Fin 5) : (U i).uaddOverflow (VXX i) = false :=
    uaddOverflow_eq_false (by have := U_lt i; have := VXX_lt i; omega)
  have hu0_0 : S.mem.readAt u0 64 = U 0 := congrFun hru0 0
  have hu0_8 : S.mem.readAt (u0.add 8#64) 64 = U 1 := congrFun hru0 1
  have hu0_16 : S.mem.readAt (u0.add 16#64) 64 = U 2 := congrFun hru0 2
  have hu0_24 : S.mem.readAt (u0.add 24#64) 64 = U 3 := congrFun hru0 3
  have hu0_32 : S.mem.readAt (u0.add 32#64) 64 = U 4 := congrFun hru0 4
  have hvx_0 : S.mem.readAt vxx 64 = VXX 0 := congrFun hread_vxx_readLimbs 0
  have hvx_8 : S.mem.readAt (vxx.add 8#64) 64 = VXX 1 := congrFun hread_vxx_readLimbs 1
  have hvx_16 : S.mem.readAt (vxx.add 16#64) 64 = VXX 2 := congrFun hread_vxx_readLimbs 2
  have hvx_24 : S.mem.readAt (vxx.add 24#64) 64 = VXX 3 := congrFun hread_vxx_readLimbs 3
  have hvx_32 : S.mem.readAt (vxx.add 32#64) 64 = VXX 4 := congrFun hread_vxx_readLimbs 4
  iterate 2 step_load
  step_pure [hpo 0]
  step_pure
  step_load with a1
  fix_load a1 ha1 hvx_8
  step_pure
  step_load with b1
  fix_load b1 hb1 hu0_8
  step_pure [hpo 1]
  step_pure
  step_load with a2
  fix_load a2 ha2 hvx_16
  step_pure
  step_load with b2
  fix_load b2 hb2 hu0_16
  step_pure [hpo 2]
  step_pure
  step_load with a3
  fix_load a3 ha3 hvx_24
  step_pure
  step_load with b3
  fix_load b3 hb3 hu0_24
  step_pure [hpo 3]
  step_pure
  step_load with a4
  fix_load a4 ha4 hvx_32
  step_pure
  step_load with b4
  fix_load b4 hb4 hu0_32
  step_pure [hpo 4]
  step_store
  iterate 4
    step_pure
    step_store
  read_stores pv, Fe.add.spec VXX U with hrpv
  clear hu0_0 hu0_8 hu0_16 hu0_24 hu0_32 hvx_0 hvx_8 hvx_16 hvx_24 hvx_32
  have h1 := (Fe.add.spec_lt VXX_lt U_lt (by decide)).mono (by decide : (2:Nat) ^ 52 + 2 ^ 53 ≤ 2 ^ 63)
  step_call using Fe_isZero.call_eq_of with hasP consuming h1
  step_pure
  finish_block
  case isFalse =>
    block_init
    have f1 := hout
    have f2 := hginv_fits
    have hv : S.mem.readAt ginv 1408 = Edwards25519.fromBytes.invalidBits := hrinv.trans invalid_bits
    step_memcpy consuming f1 f2 hv
    finish_block
    block_init
    finish_block
    rw [hS, ← hck0]
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
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
  fe_mul X, SQ as XS
  step_pure
  step_pure
  have hc1 := setWidth_xor_one_lt hasM
  step_call using Fe_cMov.call_eq_of consuming hc1
  have X1_lt := Fe.cMov.spec_lt' X_lt XS_lt (setWidth_xor_one_lt hasM)
  name_limbs X1
  stash hX1
  have h1 := X1_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 63)
  step_call using Fe_neg.call_eq_of consuming h1
  have NX_lt := Fe.neg.spec_lt53 X1
  name_limbs NX
  stash hNX
  step_pure
  have f1 := hr_limbs.fits
  have f2 := hx_limbs.fits
  have hcv := MemoryState.readAt_eq_limbsBits hx_limbs.fits hx_limbs.1
  step_memcpy consuming f1 f2 hcv
  have hrr : S.mem.readLimbs r = X1 := by
    have h := hr_limbs
    rw [hS] at h ⊢
    rw [MemoryState.limbsFit_storeAt_iff] at h
    exact readLimbs_storeAt_limbsBits h
  have h1 := X1_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 63)
  step_call using Fe_reduce.call_eq_of consuming h1
  step_load
  step_pure
  step_pure
  have hb31 : S.mem.readAt (buf.add 31#64) 8 = B.extractLsb' 248 8 :=
    MemoryState.readAt_add_of_readAt hbuf (by simp [BitVec.uaddOverflow]; omega) (by decide) hrbuf
  have hf31 : Fits S.mem (buf.add 31#64) 8 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by decide) hbuf
  step_load with s31
  fix_load s31 hs31 hb31
  iterate 5 step_pure
  rw [sign_eq] at hE
  have hc2 := sign_lt (BitVec.extractLsb' 248 8 B) (Fe.reduce.spec X1 0)
  generalize hC2 : BitVec.setWidth 64
    (BitVec.extractLsb' 248 8 B >>> 7 ^^^ BitVec.setWidth 8 (Fe.reduce.spec X1 0) &&& 1#8) = C2 at hE hc2
  have hc2' := hc2
  step_call using Fe_cMov.call_eq_of consuming hc2
  have XF_lt := (Fe.cMov.spec_lt' (X1_lt.mono (by decide : (2:Nat) ^ 52 ≤ 2 ^ 53)) NX_lt
    hc2')
  name_limbs XF
  stash hXF
  -- t = x y, then the point's fields copied
  step_pure
  have h1 := XF_lt.mono (by decide : (2:Nat) ^ 53 ≤ 2 ^ 54)
  have h2 := Y_lt.mono (by decide : (2:Nat) ^ 51 ≤ 2 ^ 54)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  name_limbs T
  stash hT
  have f1 := hpt0.fits
  have f2 := hx_limbs.fits
  have hcv := MemoryState.readAt_eq_limbsBits hx_limbs.fits hx_limbs.1
  step_memcpy consuming f1 f2 hcv
  step_pure
  have f1 := hpt40.fits
  have f2 := hy_limbs.fits
  have hcv := MemoryState.readAt_eq_limbsBits hy_limbs.fits hy_limbs.1
  step_memcpy consuming f1 f2 hcv
  step_pure
  have f1 := hpt80.fits
  have f2 := hgone_limbs.fits
  have hcv := MemoryState.readAt_eq_limbsBits hgone_limbs.fits hgone_limbs.1
  step_memcpy consuming f1 f2 hcv
  have f1 := hflag_fits.mono (show 1 ≤ 8 by omega)
  step_store consuming f1
  step_pure
  have f1 : Fits S.mem (out.add 168#64) 16 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by decide) hout
  step_store consuming f1
  have hptv : S.mem.readAt pt 1280 = limbsBits T ++ limbsBits ONE ++ limbsBits Y ++ limbsBits XF := by
    have d1 : (out.add 168#64).id ≠ pt.id := by simpa [Pointer.add_id] using hout_ne_pt
    have d2 : flag.id ≠ pt.id := by rw [hflag, hpt]; simp [GlobalState.slot]
    have hf := hpt_fits
    rw [hS] at hf ⊢
    dsimp only at hf ⊢
    rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne d1),
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne d2)]
    exact readAt_fields (by simpa only [Fits.storeAt_iff, Fits.storeLimbs_iff] using hf) hpt_off _ _ _ _
  have f1 := hout.mono (show 1280 ≤ 1408 by omega)
  have f2 := hpt_fits
  step_memcpy consuming f1 f2 hptv
  step_pure
  have hz : S.mem.readAt flag 8 = 0#8 := hrfl.trans (by simp only [spliceBits_eq]; bv_decide)
  step_load
  have f1 : Fits S.mem (out.add 160#64) 8 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by decide) hout
  step_store consuming f1
  finish_block
  block_init
  finish_block
  rw [hS, ← hck0]
  erase_frame
  simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  have hsp : Edwards25519.fromBytes.spec B = some ⟨XF, Y, ONE, T⟩ := by
    have hn : ¬hasM ||| hasP = 0#1 := by rw [hbr]; decide
    clear * - hdefs hhasM hhasP hn hYd hDd hOd hQd hC2
    subst hYd hDd hOd hQd hhasM hhasP hC2
    subst_defs
    simp only [Edwards25519.fromBytes.spec, Fe.pow2523.spec, Edwards25519.fromBytes.sign, hn,
      ↓reduceIte]
  have hPt : (S₀.mem.storeAt (out.add 168#64) 0#16).PtFit out :=
    ⟨by omega, (hout₀.mono (by omega)).storeAt⟩
  rw [hsp, storeAt_point_eq hPt, readRest_storeAt_168 hout_off]
  rfl

end Proof

end MLIR.Zig

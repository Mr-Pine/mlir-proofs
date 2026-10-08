module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Point
public import Zig.Sha512
public import Zig.Sha512_iv
public import Zig.Sha512_update
public import Zig.Edwards25519_fromBytes
public import Zig.Edwards25519_rejectIdentity
public import Zig.Fe_rejectNonCanonical
public import Zig.scalar_rejectNonCanonical
public import Zig.Mlir.Verifier_init
import all SSA.Projects.RIR.Ty
import all Zig.Edwards25519_fromBytes
import all Zig.Sha512_iv
import all Zig.Point
import Std.Tactic.BVDecide

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519 Memory

/-! ## Specification -/

@[expose] public section

namespace Verifier.init

/-- The IV's state words, `s[0]` lowest. -/
def ivState : BitVec 512 :=
  0x5be0cd19137e2179#64 ++ 0x1f83d9abfb41bd6b#64 ++ 0x9b05688c2b3e6c1f#64 ++ 0x510e527fade682d1#64 ++
    0xa54ff53a5f1d36f1#64 ++ 0x3c6ef372fe94f82b#64 ++ 0xbb67ae8584caa73b#64 ++ 0x6a09e667f3bcc908#64

/-- The hash object after `iv`, `update(r)`, `update(A)`: the IV's state, `r ++ A` buffered,
`buf_len` and `total_len` 64. -/
def hashBits (r A : BitVec 256) : BitVec 1792 :=
  0#120 ++ 64#8 ++ 0#512 ++ A ++ r ++ ivState ++ 64#128

/-- The first error code: `S`'s, `A`'s decoding (`2`) and identity check, `r`'s, `R`'s decoding
(`2`) and identity check; `0` if none. -/
def code (r S A : BitVec 256) : BitVec 16 :=
  if scalar.rejectNonCanonical.spec S ≠ 0#16 then scalar.rejectNonCanonical.spec S
  else
    match Edwards25519.fromBytes.spec A with
    | none => 2#16
    | some a =>
      if Edwards25519.rejectIdentity.spec a ≠ 0#16 then Edwards25519.rejectIdentity.spec a
      else if Fe.rejectNonCanonical.spec r ≠ 0#16 then Fe.rejectNonCanonical.spec r
      else
        match Edwards25519.fromBytes.spec r with
        | none => 2#16
        | some R => Edwards25519.rejectIdentity.spec R

/-- `fromBytes`' blocks: `601` on success, else `595`. -/
def fbBlocks (o : Option ZPt) : Nat :=
  if o.isSome then 601 else 595

/-- The blocks allocated: `7` (the IV's, five `alloca`s, `scalar.rejectNonCanonical`'s), then the
calls' made. -/
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

/-- The `Verifier`'s 592 bytes from `s`, `h` and the decoded `a`, `R`: `h`, `a`, `expected_r` (last
8 bytes zero), `s`; zero if a decoding failed. -/
def bitsOf (S : BitVec 256) (H : BitVec 1792) : Option ZPt → Option ZPt → BitVec 4736
  | some a, some R => S ++ R.bits 0#64 ++ a.bits 0#64 ++ H
  | _, _ => 0#4736

/-- The `Verifier`'s 592 bytes on success. -/
def bits (r S A : BitVec 256) : BitVec 4736 :=
  bitsOf S (hashBits r A) (Edwards25519.fromBytes.spec A) (Edwards25519.fromBytes.spec r)

/-- `out` after `init`: the code at byte 592, the `Verifier` before it on success. -/
def mem (m : MemoryState) (out : Pointer) (r S A : BitVec 256) : MemoryState :=
  if code r S A = 0#16 then (m.storeAt (out.add 592#64) 0#16).storeAt out (bits r S A)
  else m.storeAt (out.add 592#64) (code r S A)

end Verifier.init

/-- `fromBytes`' 176 bytes on a zero block: the point, its last 8 bytes and error code zero; or
`invalidBits`. -/
def Edwards25519.fromBytes.bits : Option ZPt → BitVec 1408
  | some P => 0#64 ++ P.bits 0#64
  | none => Edwards25519.fromBytes.invalidBits

end

/-! ## Proof -/

section Proof

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
    (hp : s.mem.PtFit p) (hP : s.mem.readPt p = P) (hx : Fe.Lt P.x (2 ^ 63)) :
    Edwards25519_rejectIdentity.call (Edwards25519_rejectIdentity.args (.value p)) s =
      .value
        (.cons (.value (Edwards25519.rejectIdentity.spec P)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  subst hP
  exact Edwards25519_rejectIdentity.call_eq p s hwf hp hx

/-- On a zero block, `storeFromBytes` stores `fromBytes.bits`. -/
theorem storeFromBytes_eq {m : MemoryState} {out : Pointer} (hf : Fits m out 1408)
    (ho : out.offset.toNat + 176 ≤ 2 ^ 64) (hz : m.readAt out 1408 = 0) (o : Option ZPt) :
    m.storeFromBytes out o = m.storeAt out (Edwards25519.fromBytes.bits o) := by
  cases o with
  | none => rfl
  | some P =>
    have hrest : m.readRest out = 0#64 := by
      rw [MemoryState.readRest,
        MemoryState.readAt_add_of_readAt hf (by simp [BitVec.uaddOverflow]; omega) (by simp) hz]
      simp
    simp only [MemoryState.storeFromBytes, MemoryState.storePt, hrest]
    rw [MemoryState.storeAt_add_eq hf (by simp [BitVec.uaddOverflow]; omega) (by simp), hz]
    have e0 := MemoryState.storeAt_add_eq (off := 0#64)
      (Fits.storeAt (q := out) (x := spliceBits (0 : BitVec 1408) ((168#64).toNat * 8) 0#16) hf)
      (by simp [BitVec.uaddOverflow]; exact out.offset.isLt) (by simp)
      (P.bits (0#64 &&& 0xffffffffffffff00#64))
    rw [Pointer.add_zero] at e0
    rw [e0, MemoryState.readAt_storeAt_self hf, MemoryState.storeAt_storeAt_self]
    congr 1
    simp only [Edwards25519.fromBytes.bits, spliceBits_eq', show (0#64).toNat * 8 = 0 from rfl,
      show (168#64).toNat * 8 = 1344 from rfl, show (0#64 &&& 0xffffffffffffff00#64) = 0#64 from rfl]
    generalize P.bits 0#64 = B
    bv_decide

/-- `fromBytes`' `call_eq` into a zero block: one store, of `fromBytes.bits`. -/
theorem Edwards25519_fromBytes.call_eq_zero (out buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hz : s.mem.readBlk out 1408 = 0#1408) (hbuf : Fits s.mem buf 256)
    (hbo : buf.offset.toNat + 32 ≤ 2 ^ 64) (hb : s.mem.readAt buf 256 = b) :
    Edwards25519_fromBytes.call (Edwards25519_fromBytes.args (.value out) (.value buf)) s =
      .value
        (.nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock + Verifier.init.fbBlocks (Edwards25519.fromBytes.spec b)⟩,
            mem :=
              s.mem.storeAt out (Edwards25519.fromBytes.bits (Edwards25519.fromBytes.spec b)) }) := by
  rw [Edwards25519_fromBytes.call_eq out buf s hwf hout hoo hbuf hbo, hb,
    storeFromBytes_eq hout hoo hz]
  rfl

/-- `Sha512.update` of 32 bytes `x` that leave the buffer partial: three stores. -/
theorem Sha512_update.call_eq_32 (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hd : Sha512Obj.Fit s.mem d) (hbf : Fits s.mem b 256) (hbo : b.offset.toNat + 32 < 2 ^ 64)
    (hsep : d.id ≠ b.id) (hbl : Sha512Obj.bufLen s.mem d = bl) (hbl' : bl.toNat < 96)
    (hT : Sha512Obj.totalLen s.mem d = T) (hT' : T.toNat < 2 ^ 64) (hx : s.mem.readAt b 256 = x) :
    Sha512_update.call (Sha512_update.args (.value d) (.value b) (.value 32#64)) s =
      .value
        (.nil,
          { alloc := s.alloc,
            mem :=
              ((s.mem.storeAt (d.add (80#64 + bl.setWidth 64)) x).storeAt (d.add 208#64)
                  (bl + 32#8)).storeAt d (T + 32#128) }) := by
  rw [Sha512_update.call_eq d b 32#64 s hwf hd (by simpa using hbf) (by simpa using hbo)
    (Range.disjoint_of_id_ne hsep) (by simp) (by rw [hbl]; omega) (by rw [hT]; simp; omega)]
  simp only [Sha512_update.post, hbl]
  rw [ite_eq_right (by simp; omega)]
  simp only [Sha512_update.fromState, Sha512_update.tailMem]
  show
    PoisonOr.value
        (Vals.nil,
          (⟨s.alloc,
            ((s.mem.storeAt (d.add (80#64 + BitVec.setWidth 64 (Sha512Obj.bufLen s.mem d)))
                    (s.mem.readAt (b.add 0#64) 256)).storeAt
                (d.add 208#64) (Sha512Obj.bufLen s.mem d + 32#8)).storeAt d
              (Sha512Obj.totalLen s.mem d + 32#128)⟩ : GlobalState)) = _
  rw [Pointer.add_zero, hx, hbl, hT]

/-- `fromBytes`' error code, at byte 168 of its bits. -/
def fbCode (o : Option ZPt) : BitVec 16 :=
  if o.isSome then 0#16 else 2#16

/-- The code in `fromBytes.bits`. -/
theorem fbBits_code (o : Option ZPt) :
    (Edwards25519.fromBytes.bits o).extractLsb' 1344 16 = fbCode o := by
  cases o with
  | none => decide +kernel
  | some P =>
    simp only [Edwards25519.fromBytes.bits, fbCode, Option.isSome_some, ite_true]
    generalize P.bits 0#64 = B
    bv_decide

/-- A point's bits read where it fits: the point and its last 8 bytes. -/
theorem readPt_of_bits {m : MemoryState} {p : Pointer} {P : ZPt} {rest : BitVec 64} (hpf : m.PtFit p)
    (h : m.readAt p 1344 = P.bits rest) : m.readPt p = P ∧ m.readRest p = rest := by
  have e := MemoryState.readAt_eq_ptBits hpf.2 hpf.1
  rw [h] at e
  obtain ⟨sx, sy, sz, st, sr⟩ := slices_bits P rest
  obtain ⟨sx', sy', sz', st', sr'⟩ := slices_bits (m.readPt p) (m.readRest p)
  rw [← e] at sx' sy' sz' st' sr'
  have hx := sx'.symm.trans sx
  have hy := sy'.symm.trans sy
  have hz := sz'.symm.trans sz
  have ht := st'.symm.trans st
  refine ⟨?_, sr'.symm.trans sr⟩
  generalize m.readPt p = Q at hx hy hz ht ⊢
  obtain ⟨x, y, z, t⟩ := P
  obtain ⟨x', y', z', t'⟩ := Q
  simp only at hx hy hz ht
  subst hx hy hz ht
  rfl

/-- A block holding `fromBytes.bits (some P)`: the point `P` there. -/
theorem fb_point {m : MemoryState} {p : Pointer} {P : ZPt} (hf : Fits m p 1408) (ho : p.offset = 0)
    (h : m.readAt p 1408 = Edwards25519.fromBytes.bits (some P)) :
    m.PtFit p ∧ m.readPt p = P ∧ m.readAt p 1344 = P.bits 0#64 := by
  have h1344 : m.readAt p 1344 = P.bits 0#64 := by
    rw [MemoryState.readAt_of_readAt_le (by omega) h]
    simp only [Edwards25519.fromBytes.bits]
    generalize P.bits 0#64 = B
    bv_decide
  have hpf : m.PtFit p := ⟨by simp [ho], Sha512_update.fits_le hf (by omega)⟩
  exact ⟨hpf, (readPt_of_bits hpf h1344).1, h1344⟩

/-- A decoded point's `x` limbs are below `2^63`. -/
theorem fromBytes_x_lt {b : BitVec 256} {P : ZPt} (h : Edwards25519.fromBytes.spec b = some P) :
    Fe.Lt P.x (2 ^ 63) := by
  unfold Edwards25519.fromBytes.spec at h
  extract_lets y u v u' v' x vxx hm hp at h
  split at h
  · cases h
  · cases h
    have h1 := Fe.cMov.spec_lt' (Fe.mul.spec_lt (Fe.pow2523.spec (Fe.mul.spec u' v')) u')
      (Fe.mul.spec_lt x Fe.sqrtm1) (setWidth_xor_one_lt hm)
    exact (Fe.cMov.spec_lt' (h1.mono (by decide)) (Fe.neg.spec_lt _)
      (sign_lt (b.extractLsb' 248 8) _)).mono (by decide)

/-- A full-width splice at `0` replaces. -/
theorem spliceBits_full (X B : BitVec n) : spliceBits X 0 B = B := by
  simp only [spliceBits_eq']
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

-- `readBlk` facts carried through copies into a block
attribute [local mlir_read] MemoryState.readBlk_storeAt_add

/-- `run_memcpy` with the bits read at `src` known: `x`. -/
theorem run_memcpy_eq {Γ : Ctx} {env : ⟪Γ⟫} {s : GlobalState} {dst src : Pointer} {len : BitVec w}
    {n : Nat} {x : BitVec (8 * n)} (hn : len.toNat = n)
    (hd : (Range.of dst (8 * n)).Disjoint (Range.of src (8 * n))) (hfd : Fits s.mem dst (8 * n))
    (hfs : Fits s.mem src (8 * n)) (hx : s.mem.readAt src (8 * n) = x) :
    (Operation.memcpy (.value dst) (.value src) (.value len)) env s =
      .value (env, { s with mem := s.mem.storeAt dst x }) := by
  rw [run_memcpy hn hd hfd hfs, hx]

/-- `step_memcpy`, the copied bits `hx` gives. -/
macro "step_copy " hx:term : tactic =>
  `(tactic|
    step_impure =>
      expect_values
      exact run_memcpy_eq (by rfl) (by mem_fact) (by mem_fact) (by mem_fact) $hx)

/-- `Sha512.iv`'s bytes: the IV's state words, the rest zero. -/
theorem flatBits_iv_eq {hw : Sha512_iv.t.width = 1792} :
    Ty.flatBits Sha512_iv.lit (hw := hw) = 0#1152 ++ Verifier.init.ivState ++ 0#128 := by
  have e : Ty.flatBits Sha512_iv.lit (hw := hw) =
      Ty.flatBits Sha512_iv.lit (hw := (by decide : Sha512_iv.t.width = 1792)) := rfl
  rw [e, flatBits_iv]
  decide +kernel

/-- `update`'s object bits after 32 bytes `x` at `buf_len = bl`, `total_len = T`. -/
def upd32 (X : BitVec 1792) (bl : BitVec 8) (T : BitVec 128) (x : BitVec 256) : BitVec 1792 :=
  spliceBits (spliceBits (spliceBits X ((80#64 + bl.setWidth 64).toNat * 8) x) 1664 (bl + 32#8)) 0
    (T + 32#128)

/-- `call_eq_32` with the object read whole as `X`: one store, of `upd32`. -/
theorem Sha512_update.call_eq_32' (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdf : Fits s.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbf : Fits s.mem b 256)
    (hbo : b.offset.toNat + 32 < 2 ^ 64) (hsep : d.id ≠ b.id) (hX : s.mem.readBlk d 1792 = X)
    (hbl : X.extractLsb' 1664 8 = bl) (hbl' : bl.toNat < 96) (hT : X.extractLsb' 0 128 = T)
    (hT' : T.toNat < 2 ^ 64) (hx : s.mem.readAt b 256 = x) :
    Sha512_update.call (Sha512_update.args (.value d) (.value b) (.value 32#64)) s =
      .value (.nil, { alloc := s.alloc, mem := s.mem.storeAt d (upd32 X bl T x) }) := by
  have hX' : s.mem.readAt d 1792 = X := hX
  have hb : Sha512Obj.bufLen s.mem d = bl := by
    rw [Sha512Obj.bufLen, MemoryState.readAt_add_of_readAt hdf
      (by simp [BitVec.uaddOverflow]; omega) (by simp) hX', ← hbl]
    rfl
  have hT0 : Sha512Obj.totalLen s.mem d = T := by
    rw [Sha512Obj.totalLen, MemoryState.readAt_of_readAt_le (by omega) hX', ← hT]
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [hi]
  rw [Sha512_update.call_eq_32 d b s hwf ⟨hdf, hdo⟩ hbf hbo hsep hb hbl' hT0 hT' hx]
  have hov : (80#64 + bl.setWidth 64).toNat = 80 + bl.toNat := by
    simp [BitVec.toNat_add]; omega
  rw [MemoryState.storeAt_add_eq hdf (by simp [BitVec.uaddOverflow, hov]; omega) (by rw [hov]; omega),
    MemoryState.storeAt_add_eq hdf.storeAt (by simp [BitVec.uaddOverflow]; omega) (by simp),
    MemoryState.readAt_storeAt_self hdf, MemoryState.storeAt_storeAt_self, hX']
  have e0 := MemoryState.storeAt_add_eq (off := 0#64) (m := s.mem.storeAt d
    (spliceBits (spliceBits X ((80#64 + BitVec.setWidth 64 bl).toNat * 8) x) ((208#64).toNat * 8)
      (bl + 32#8))) hdf.storeAt (by simp [BitVec.uaddOverflow]; exact d.offset.isLt) (by simp)
    (T + 32#128)
  rw [Pointer.add_zero] at e0
  rw [e0, MemoryState.readAt_storeAt_self hdf, MemoryState.storeAt_storeAt_self]
  rfl

/-- The object after `update(r)`: `r` buffered, both counts 32. -/
abbrev hash1 (r : BitVec 256) : BitVec 1792 :=
  0#120 ++ 32#8 ++ 0#768 ++ r ++ Verifier.init.ivState ++ 32#128

/-- `update(r)` on the IV's object. -/
theorem upd1_eq (r : BitVec 256) :
    spliceBits (0#1152 ++ Verifier.init.ivState ++ 0#128) 0
        (upd32 (0#1152 ++ Verifier.init.ivState ++ 0#128) 0#8 0#128 r) = hash1 r := by
  rw [spliceBits_full]
  simp only [upd32, spliceBits_eq', hash1, BitVec.setWidth_zero, BitVec.add_zero, BitVec.toNat_ofNat]
  generalize Verifier.init.ivState = I
  bv_decide

/-- `buf_len`, `total_len` after `update(r)`. -/
theorem hbl_T1 (r : BitVec 256) :
    (hash1 r).extractLsb' 1664 8 = 32#8 ∧ (hash1 r).extractLsb' 0 128 = 32#128 := by
  simp only [hash1]
  constructor <;>
  · generalize Verifier.init.ivState = I
    bv_decide

/-- `update(A)` after `update(r)`. -/
theorem upd2_eq (r A : BitVec 256) :
    spliceBits (hash1 r) 0 (upd32 (hash1 r) 32#8 32#128 A) = Verifier.init.hashBits r A := by
  rw [spliceBits_full]
  simp only [upd32, spliceBits_eq', hash1, Verifier.init.hashBits]
  generalize Verifier.init.ivState = I
  bv_decide

/-- The `Verifier` assembled in its zero slot: `h`, `s`, `a`, `expected_r`. -/
theorem assemble_eq (H : BitVec 1792) (S : BitVec 256) (A R : BitVec 1344) :
    spliceBits (spliceBits (spliceBits (spliceBits (0#4736) 0 H) 4480 S) 1792 A) 3136 R =
      S ++ R ++ A ++ H := by
  simp only [spliceBits_eq']
  bv_decide

/-- `bits` on decoded points. -/
theorem bits_eq {r S A : BitVec 256} {a R : ZPt} (hA : Edwards25519.fromBytes.spec A = some a)
    (hR : Edwards25519.fromBytes.spec r = some R) :
    Verifier.init.bits r S A = S ++ R.bits 0#64 ++ a.bits 0#64 ++ Verifier.init.hashBits r A := by
  rw [Verifier.init.bits, hA, hR]
  rfl

set_option maxHeartbeats 4000000 in
/-- `Verifier.init` of the signature `r ‖ S` at `sig` and the key `A` at `pk` stores `mem` at
`out`. -/
public theorem Verifier_init.call_eq (out sig pk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 4752) (hoo : out.offset.toNat + 594 ≤ 2 ^ 64)
    (hsig : Fits s.mem sig 512) (hso : sig.offset.toNat + 64 < 2 ^ 64)
    (hpk : Fits s.mem pk 256) (hpo : pk.offset.toNat + 32 < 2 ^ 64) :
    Verifier_init.call (Verifier_init.args (.value out) (.value sig) (.value pk)) s =
      .value
        (.nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  Verifier.init.blocks (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem :=
              Verifier.init.mem s.mem out (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                (s.mem.readAt pk 256) }) := by
  have hsig32 : Fits s.mem (sig.add 32#64) 256 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hsig
  have hsig32o : (sig.add 32#64).offset.toNat + 32 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  have hsigr : Fits s.mem sig 256 := Sha512_update.fits_le hsig (by omega)
  have hsigov : ¬sig.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow]; omega
  have hsigo : sig.offset.toNat + 32 < 2 ^ 64 := by omega
  have hsigo' : sig.offset.toNat + 32 ≤ 2 ^ 64 := by omega
  have hpo' : pk.offset.toNat + 32 ≤ 2 ^ 64 := by omega
  have hout592ov : ¬out.offset.uaddOverflow 592#64 := by simp [BitVec.uaddOverflow]; omega
  have hout592 : Fits s.mem (out.add 592#64) 16 := Fits.add_of_le hout592ov (by simp) hout
  have hout4736 : Fits s.mem out 4736 := Sha512_update.fits_le hout (by omega)
  func_init
  have hR : S.mem.readAt sig 256 = S₀.mem.readAt sig 256 := by rw [hS]
  have hSc : S.mem.readAt (sig.add 32#64) 256 = S₀.mem.readAt (sig.add 32#64) 256 := by rw [hS]
  have hA : S.mem.readAt pk 256 = S₀.mem.readAt pk 256 := by rw [hS]
  generalize S₀.mem.readAt sig 256 = r at hR ⊢
  generalize S₀.mem.readAt (sig.add 32#64) 256 = Sc at hSc ⊢
  generalize S₀.mem.readAt pk 256 = Ae at hA ⊢
  block_init
  iterate 5 step_pure
  step_addressof Sha512_iv.value_eq with giv
  have hiv : S.mem.readAt giv 1792 = 0#1152 ++ Verifier.init.ivState ++ 0#128 :=
    hread_giv.trans flatBits_iv_eq
  clear hread_giv
  step_pure
  step_alloca with v
  have hvB : S.mem.readBlk v 4736 = 0#4736 := by
    rw [hS]
    exact readAt_alloca_fresh (by rw [hv]; simp only [GlobalState.slot_id_id])
  step_alloca with h
  have hhB : S.mem.readBlk h 1792 = 0#1792 := by
    rw [hS]
    exact readAt_alloca_fresh (by rw [hh]; simp only [GlobalState.slot_id_id, GlobalState.alloca_alloc])
  step_alloca with pr
  have hprB : S.mem.readBlk pr 1408 = 0#1408 := by
    rw [hS]
    exact readAt_alloca_fresh (by rw [hpr]; simp only [GlobalState.slot_id_id, GlobalState.alloca_alloc])
  step_alloca with pa
  have hpaB : S.mem.readBlk pa 1408 = 0#1408 := by
    rw [hS]
    exact readAt_alloca_fresh (by rw [hpa]; simp only [GlobalState.slot_id_id, GlobalState.alloca_alloc])
  step_alloca with rc
  have hR' := hR
  step_memcpy consuming hR'
  have hrc_r : S.mem.readAt rc 256 = r := by
    have hf := hrc_fits
    rw [hS] at hf ⊢
    exact MemoryState.readAt_storeAt_self (Fits.storeAt_iff.mp hf) r
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
    erase_frame
    simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, hbr, GlobalState.alloca]
  case isTrue =>
  have hc1 := hbr
  clear hbr
  block_init
  have hpa_o : pa.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hpa_off]
  step_call using Edwards25519_fromBytes.call_eq_zero
  generalize hoA : Edwards25519.fromBytes.spec Ae = oA at *
  clear hpaB
  step_pure
  step_load
  step_pure
  finish_block
  case isFalse =>
    rw [fbBits_code] at hbr
    block_init
    step_pure
    step_store
    finish_block
    block_init
    finish_block
    rw [hS]
    erase_frame
    cases oA with
    | some a => simp [fbCode] at hbr
    | none =>
      simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, Verifier.init.fbBlocks, hc1,
        hoA, fbBits_code, fbCode, GlobalState.alloca]
  case isTrue =>
  rw [fbBits_code] at hbr
  obtain ⟨a, rfl⟩ : ∃ a, oA = some a := by
    cases oA with
    | none => simp [fbCode] at hbr
    | some a => exact ⟨a, rfl⟩
  clear hbr
  obtain ⟨hpaP, hpaR, hpa1344⟩ := fb_point hpa_fits hpa_off hread_pa
  have hax := fromBytes_x_lt hoA
  block_init
  step_call using Edwards25519_rejectIdentity.call_eq_of
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
    erase_frame
    simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, Verifier.init.fbBlocks, hc1,
      hoA, hbr, GlobalState.alloca]
  case isTrue =>
  have hc3 := hbr
  clear hbr
  have hrc_ov : ¬rc.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hrc_off]
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
    erase_frame
    simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, Verifier.init.fbBlocks, hc1,
      hoA, hc3, hbr, GlobalState.alloca]
  case isTrue =>
  have hc4 := hbr
  clear hbr
  have hpr_o : pr.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hpr_off]
  block_init
  step_call using Edwards25519_fromBytes.call_eq_zero
  generalize hoR : Edwards25519.fromBytes.spec r = oR at *
  clear hprB
  step_pure
  step_load
  step_pure
  finish_block
  case isFalse =>
    rw [fbBits_code] at hbr
    block_init
    step_pure
    step_store
    finish_block
    block_init
    finish_block
    rw [hS]
    erase_frame
    cases oR with
    | some R => simp [fbCode] at hbr
    | none =>
      simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, Verifier.init.fbBlocks, hc1,
        hoA, hc3, hc4, hoR, fbBits_code, fbCode, GlobalState.alloca]
  case isTrue =>
  rw [fbBits_code] at hbr
  obtain ⟨R, rfl⟩ : ∃ R, oR = some R := by
    cases oR with
    | none => simp [fbCode] at hbr
    | some R => exact ⟨R, rfl⟩
  clear hbr
  obtain ⟨hprP, hprR, hpr1344⟩ := fb_point hpr_fits hpr_off hread_pr
  have hRx := fromBytes_x_lt hoR
  block_init
  step_call using Edwards25519_rejectIdentity.call_eq_of
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
    erase_frame
    simp [Verifier.init.mem, Verifier.init.code, Verifier.init.blocks, Verifier.init.fbBlocks, hc1,
      hoA, hc3, hc4, hoR, hbr, GlobalState.alloca]
  case isTrue =>
  have hc5 := hbr
  clear hbr
  block_init
  step_memcpy
  have hX1 : S.mem.readBlk h 1792 = 0#1152 ++ Verifier.init.ivState ++ 0#128 := by
    have hf := hh_fits
    rw [hS] at hf ⊢
    exact MemoryState.readAt_storeAt_self (Fits.storeAt_iff.mp hf) _
  have hbl1 : (0#1152 ++ Verifier.init.ivState ++ 0#128).extractLsb' 1664 8 = 0#8 := by
    decide +kernel
  have hT1 : (0#1152 ++ Verifier.init.ivState ++ 0#128).extractLsb' 0 128 = 0#128 := by
    decide +kernel
  have hh_o : h.offset.toNat + 224 < 2 ^ 64 := by simp [hh_off]
  have hsep1 := hsig_ne_h.symm
  step_call using Sha512_update.call_eq_32'
  replace hX1 := hX1.trans (upd1_eq r)
  clear hbl1 hT1
  have hbl1 := (hbl_T1 r).1
  have hT1 := (hbl_T1 r).2
  have hsep2 := hpk_ne_h.symm
  step_call using Sha512_update.call_eq_32'
  replace hX1 := hX1.trans (upd2_eq r Ae)
  clear hbl1 hT1
  have hhV : S.mem.readAt h 1792 = Verifier.init.hashBits r Ae := hX1
  clear hX1
  have hv1792 : Fits S.mem v 1792 := Sha512_update.fits_le hv_fits (by omega)
  step_copy hhV
  have hv560 : Fits S.mem (v.add 560#64) 256 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow, hv_off]) (by simp) hv_fits
  have hv224 : Fits S.mem (v.add 224#64) 1344 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow, hv_off]) (by simp) hv_fits
  have hv392 : Fits S.mem (v.add 392#64) 1344 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow, hv_off]) (by simp) hv_fits
  step_pure
  step_copy hSc
  step_pure
  step_copy hpa1344
  step_pure
  step_copy hpr1344
  have hvV : S.mem.readAt v 4736 = Verifier.init.bits r Sc Ae := by
    rw [bits_eq hoA hoR]
    exact hvB.trans (assemble_eq _ _ _ _)
  clear hvB
  step_pure
  step_store
  step_copy hvV
  finish_block
  block_init
  finish_block
  rw [hS]
  erase_frame
  have hcode : Verifier.init.code r Sc Ae = 0#16 := by
    simp [Verifier.init.code, hc1, hoA, hc3, hc4, hoR, hc5]
  rw [Verifier.init.mem, ite_eq_left hcode]
  simp [Verifier.init.blocks, Verifier.init.fbBlocks, hc1, hoA, hc3, hc4, hoR, GlobalState.alloca]

/-! ## The result, for callers -/

/-- An object holding `hashBits r A` has absorbed `r ++ A`. -/
public theorem Verifier.init.absorbed {m : MemoryState} {d : Pointer} {r A : BitVec 256}
    (hf : Sha512Obj.Fit m d) (h : m.readAt d 1792 = Verifier.init.hashBits r A) :
    Sha512Obj.Absorbed m d (bytesLE r ++ bytesLE A) := by
  obtain ⟨hf, ho⟩ := hf
  have hr (k w : Nat) (hk : k * 8 + w ≤ 1792) :
      m.readAt (d.add (BitVec.ofNat 64 k)) w = (Verifier.init.hashBits r A).extractLsb' (k * 8) w := by
    rw [MemoryState.readAt_add_of_readAt hf (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) h]
    congr 1
    simp
    omega
  have hlen : (bytesLE r ++ bytesLE A).length = 64 := by simp
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    apply Vector.ext
    intro i hi
    simp only [Sha512Obj.state, Vector.getElem_ofFn]
    rw [show 16#64 + BitVec.ofNat 64 (8 * i) = BitVec.ofNat 64 (16 + 8 * i) by
      apply BitVec.eq_of_toNat_eq; simp, hr _ _ (by omega)]
    clear hr h
    have e : (Verifier.init.hashBits r A).extractLsb' ((16 + 8 * i) * 8) 64 =
        Verifier.init.ivState.extractLsb' (64 * i) 64 := by
      simp only [Verifier.init.hashBits]
      generalize Verifier.init.ivState = I
      match i, hi with
      | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => bv_decide
    rw [e]
    clear e
    match i, hi with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => decide +kernel +revert
  · rw [Sha512Obj.bufLen, hr 208 8 (by omega), hlen]
    have : (Verifier.init.hashBits r A).extractLsb' (208 * 8) 8 = 64#8 := by
      simp only [Verifier.init.hashBits]
      bv_decide
    rw [this]
    rfl
  · rw [Sha512Obj.buf, hr 80 1024 (by omega), hlen]
    have : (Verifier.init.hashBits r A).extractLsb' (80 * 8) 1024 = 0#512 ++ A ++ r := by
      simp only [Verifier.init.hashBits]
      bv_decide
    rw [this, bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide), ← List.append_assoc,
      List.take_left' (by simp)]
    simp
  · rw [Sha512Obj.totalLen, MemoryState.readAt_of_readAt_le (by omega) h, hlen]
    simp only [Verifier.init.hashBits]
    bv_decide

/-- The `Verifier`'s fields, read back from its bits. -/
theorem assemble_extract (S : BitVec 256) (B1 B2 : BitVec 1344) (H : BitVec 1792) :
    (S ++ B1 ++ B2 ++ H).setWidth 1792 = H ∧ (S ++ B1 ++ B2 ++ H).extractLsb' (224 * 8) 1344 = B2 ∧
      (S ++ B1 ++ B2 ++ H).extractLsb' (392 * 8) 1344 = B1 ∧
      (S ++ B1 ++ B2 ++ H).extractLsb' (560 * 8) 256 = S := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- `mem`'s blocks fit as before. -/
public theorem Verifier.init.fits_mem {m : MemoryState} {out q : Pointer} {r S A : BitVec 256} :
    Fits (Verifier.init.mem m out r S A) q w ↔ Fits m q w := by
  unfold Verifier.init.mem
  split <;> simp only [Fits.storeAt_iff]

/-- `mem` keeps reads apart from `out`'s 594 bytes. -/
public theorem Verifier.init.readAt_mem {m : MemoryState} {out q : Pointer} {r S A : BitVec 256}
    (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) (h : (Range.of out 4752).Disjoint (Range.of q w)) :
    (Verifier.init.mem m out r S A).readAt q w = m.readAt q w := by
  have h592 : (Range.of (out.add 592#64) 16).Disjoint (Range.of q w) := by
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add] at h ⊢
    have h592 : (592#64).toNat = 592 := by simp
    rw [h592, Nat.mod_eq_of_lt (by omega)]
    rcases h with h | h | h
    · exact Or.inl h
    all_goals
      clear hoo h592
      generalize out.offset.toNat = a at *
      generalize q.offset.toNat = b at *
    · right; left; simpa only [Nat.mul_add, Nat.add_assoc] using h
    · right; right; exact Nat.le_trans h (Nat.mul_le_mul_left 8 (Nat.le_add_right a 592))
  have h0 : (Range.of out 4736).Disjoint (Range.of q w) := by
    simp only [Range.Disjoint, Range.of] at h ⊢
    rcases h with h | h | h
    · exact Or.inl h
    · right; left; omega
    · right; right; omega
  unfold Verifier.init.mem
  split
  · rw [MemoryState.readAt_storeAt_disjoint h0, MemoryState.readAt_storeAt_disjoint h592]
  · rw [MemoryState.readAt_storeAt_disjoint h592]

/-- `mem`'s stores commute with erasing a frame. -/
public theorem Verifier.init.eraseFrom_mem {m : MemoryState} {out : Pointer} {r S A : BitVec 256} :
    (Verifier.init.mem m out r S A).eraseFrom n = Verifier.init.mem (m.eraseFrom n) out r S A := by
  unfold Verifier.init.mem
  split <;> simp only [MemoryState.eraseFrom_storeAt]

/-- `mem` into a block of an erased frame is lost. -/
public theorem Verifier.init.eraseFrom_mem_of_le {m : MemoryState} {out : Pointer}
    {r S A : BitVec 256} (h : n ≤ out.id.id) :
    (Verifier.init.mem m out r S A).eraseFrom n = m.eraseFrom n := by
  unfold Verifier.init.mem
  split <;>
    simp only [MemoryState.eraseFrom_storeAt_of_le (p := out.add _) (by simpa [Pointer.add_id] using h),
      MemoryState.eraseFrom_storeAt_of_le h]

/-- The state `call_eq` leaves is `WF`. -/
public theorem Verifier.init.wf {s : GlobalState} {out : Pointer} {r S A : BitVec 256} (hwf : s.WF)
    (k : Nat) :
    ({ alloc := ⟨s.alloc.nextFreeBlock + k⟩, mem := Verifier.init.mem s.mem out r S A } :
      GlobalState).WF := by
  have hb : (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩ : GlobalState).WF :=
    ⟨fun j hj => Nat.lt_of_lt_of_le (hwf.bound j hj) (Nat.le_add_right _ _),
      Nat.lt_of_lt_of_le hwf.pos (Nat.le_add_right _ _), hwf.null⟩
  unfold Verifier.init.mem
  split
  · exact GlobalState.WF.storeAt (GlobalState.WF.storeAt (s := ⟨_, s.mem⟩) hb)
  · exact GlobalState.WF.storeAt (s := ⟨_, s.mem⟩) hb

/-- The code `mem` stores at byte 592. -/
public theorem Verifier.init.readAt_mem_code {m : MemoryState} {out : Pointer} {r S A : BitVec 256}
    (hf : Fits m out 4752) (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) :
    (Verifier.init.mem m out r S A).readAt (out.add 592#64) 16 = Verifier.init.code r S A := by
  have hf592 : Fits m (out.add 592#64) 16 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf
  unfold Verifier.init.mem
  split
  · rename_i hc
    rw [MemoryState.readAt_storeAt_disjoint, MemoryState.readAt_storeAt_self hf592, hc]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
    have h592 : (592#64).toNat = 592 := by simp
    rw [h592, Nat.mod_eq_of_lt (by omega)]
    right; left; omega
  · exact MemoryState.readAt_storeAt_self hf592 _

/-- On success `out` holds the `Verifier`: `h` has absorbed `r ++ A`, `a` and `expected_r` are the
decoded points (last 8 bytes zero), `s` is `S`. -/
public theorem Verifier.init.mem_ok {m : MemoryState} {out : Pointer} {r S A : BitVec 256}
    (hf : Fits m out 4752) (hoo : out.offset.toNat + 594 ≤ 2 ^ 64)
    (hc : Verifier.init.code r S A = 0#16) :
    ∃ a R, Edwards25519.fromBytes.spec A = some a ∧ Edwards25519.fromBytes.spec r = some R ∧
      Sha512Obj.Absorbed (Verifier.init.mem m out r S A) out (bytesLE r ++ bytesLE A) ∧
      (Verifier.init.mem m out r S A).readAt out 1792 = Verifier.init.hashBits r A ∧
      (Verifier.init.mem m out r S A).PtFit (out.add 224#64) ∧
      (Verifier.init.mem m out r S A).readPt (out.add 224#64) = a ∧
      (Verifier.init.mem m out r S A).readRest (out.add 224#64) = 0#64 ∧
      (Verifier.init.mem m out r S A).PtFit (out.add 392#64) ∧
      (Verifier.init.mem m out r S A).readPt (out.add 392#64) = R ∧
      (Verifier.init.mem m out r S A).readRest (out.add 392#64) = 0#64 ∧
      (Verifier.init.mem m out r S A).readAt (out.add 560#64) 256 = S := by
  obtain ⟨a, ha⟩ : ∃ a, Edwards25519.fromBytes.spec A = some a := by
    cases h : Edwards25519.fromBytes.spec A with
    | some a => exact ⟨a, rfl⟩
    | none =>
      simp only [Verifier.init.code, h] at hc
      split_ifs at hc <;> simp_all
  obtain ⟨R, hR⟩ : ∃ R, Edwards25519.fromBytes.spec r = some R := by
    cases h : Edwards25519.fromBytes.spec r with
    | some R => exact ⟨R, rfl⟩
    | none =>
      simp only [Verifier.init.code, h, ha] at hc
      split_ifs at hc <;> simp_all
  refine ⟨a, R, ha, hR, ?_⟩
  have hm : Verifier.init.mem m out r S A =
      (m.storeAt (out.add 592#64) 0#16).storeAt out (S ++ R.bits 0#64 ++ a.bits 0#64 ++
        Verifier.init.hashBits r A) := by
    rw [Verifier.init.mem, ite_eq_left hc, bits_eq ha hR]
  rw [hm]
  generalize hV : S ++ R.bits 0#64 ++ a.bits 0#64 ++ Verifier.init.hashBits r A = V
  obtain ⟨m', hm'⟩ : ∃ m', (m.storeAt (out.add 592#64) 0#16).storeAt out V = m' := ⟨_, rfl⟩
  rw [hm']
  have hF : Fits m' out 4736 :=
    hm' ▸ Fits.storeAt (Fits.storeAt (Sha512_update.fits_le hf (by omega)))
  have hv : m'.readAt out 4736 = V :=
    hm' ▸ MemoryState.readAt_storeAt_self (Fits.storeAt (q := out.add 592#64) (x := 0#16)
      (Sha512_update.fits_le hf (by omega))) V
  have hr (k w : Nat) (hk : k * 8 + w ≤ 4736) :
      m'.readAt (out.add (BitVec.ofNat 64 k)) w = V.extractLsb' (k * 8) w := by
    rw [MemoryState.readAt_add_of_readAt hF (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hv]
    congr 1
    simp
    omega
  have hpt (k : Nat) (hk : k ≤ 392) : m'.PtFit (out.add (BitVec.ofNat 64 k)) := by
    refine ⟨?_, Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hF⟩
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    omega
  obtain ⟨e1, e2, e3, e4⟩ := assemble_extract S (R.bits 0#64) (a.bits 0#64) (Verifier.init.hashBits r A)
  rw [hV] at e1 e2 e3 e4
  have hH : m'.readAt out 1792 = Verifier.init.hashBits r A := by
    rw [MemoryState.readAt_of_readAt_le (by omega) hv, e1]
  have hA : m'.readAt (out.add 224#64) 1344 = a.bits 0#64 ∧
      m'.readAt (out.add 392#64) 1344 = R.bits 0#64 ∧ m'.readAt (out.add 560#64) 256 = S :=
    ⟨(hr 224 1344 (by omega)).trans e2, (hr 392 1344 (by omega)).trans e3,
      (hr 560 256 (by omega)).trans e4⟩
  have ha' := readPt_of_bits (hpt 224 (by omega)) hA.1
  have hR' := readPt_of_bits (hpt 392 (by omega)) hA.2.1
  exact ⟨Verifier.init.absorbed ⟨Sha512_update.fits_le hF (by omega), by omega⟩ hH, hH,
    hpt 224 (by omega), ha'.1, ha'.2, hpt 392 (by omega), hR'.1, hR'.2, hA.2.2⟩

end Proof

end LeanMLIR.RIR.Zig

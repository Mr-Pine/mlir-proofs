module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.Block
public import Zig.Sha512_final
public import Zig.scalar_reduce64
public import Zig.scalar_mul8
public import Zig.Edwards25519_clearCofactor
public import Zig.Edwards25519_neg
public import Zig.Edwards25519_sub
public import Zig.Edwards25519_mulDoubleBasePublic
public import Zig.Verifier_isIdentity
public import Zig.Mlir.Verifier_verify
public import Ed25519.Decode
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Rename

namespace MLIR.Zig

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace Verifier.verify

/-- `Sha512.final`'s padding at the object `d`: a round first if the length no longer fits. -/
def padState (s : GlobalState) (d : Pointer) : GlobalState :=
  let bl := Sha512Obj.bufLen s.mem d
  let s1 : GlobalState := { s with mem := Sha512_final.padMem s.mem d bl }
  if 111 < bl.toNat then
    let r := Sha512_update.roundState s1 d (d.add 80#64)
    { r with mem := r.mem.storeAt (d.add 80#64) 0#1024 }
  else s1

/-- The hash object at `d` after `Sha512.final`: `post`'s state but the digest's stores. -/
def finalState (s : GlobalState) (d : Pointer) : GlobalState :=
  Sha512_update.roundState (Sha512_final.lenState (padState s d) d) d (d.add 80#64)

/-- `finalState`'s memory. -/
def finalMem (m : MemoryState) (d : Pointer) : MemoryState :=
  (finalState ⟨⟨0⟩, m⟩ d).mem

/-- SHA-512 of `M` as the 64 bytes `Sha512.final` stores, little-endian. -/
def digestBits (M : List (BitVec 8)) : BitVec 512 :=
  BitVec.ofNat 512 (natLE (Sha512.digest M))

/-- `-(8 A)`, `mulDoubleBasePublic`'s point. -/
def negA (A : ZPt) : ZPt :=
  Edwards25519.neg.spec (Edwards25519.clearCofactor.spec A)

/-- `mulDoubleBasePublic`'s result: `[8 S] B - [k] (8 A)`, or `none` for a weak key. -/
def sbAh (M : List (BitVec 8)) (sb : BitVec 256) (A : ZPt) : Option ZPt :=
  Edwards25519.mulDoubleBasePublic.spec (scalar.mul8.spec sb) 0#1 (negA A)
    (scalar.reduce64.spec (digestBits M))

/-- `check`: `sb_ah - 8 R`. -/
def check (Q R : ZPt) : ZPt :=
  Edwards25519.sub.spec Q (Edwards25519.clearCofactor.spec R)

/-- The code for `mulDoubleBasePublic`'s result: `4` (WeakPublicKey), else `0` if `check` is the
identity, else `5` (SignatureVerificationFailed). -/
def codeOf (r : Option ZPt) (R : ZPt) : BitVec 16 :=
  match r with
  | none => 4#16
  | some Q => if Verifier.isIdentity.spec (check Q R) = 1#1 then 0#16 else 5#16

/-- The returned code. -/
def code (M : List (BitVec 8)) (sb : BitVec 256) (A R : ZPt) : BitVec 16 :=
  codeOf (sbAh M sb A) R

/-- Blocks allocated after `mulDoubleBasePublic`: `clearCofactor`'s, `sub`'s and `isIdentity`'s
on success. -/
def blocksOf (r : Option ZPt) (R : ZPt) : Nat :=
  match r with
  | none => 0
  | some Q => 87 + 44 + if Fe.isZero.spec (check Q R).x = 1#1 then 4 else 3

/-- Blocks the function allocates, its callees' included. -/
def blocks (M : List (BitVec 8)) (sb : BitVec 256) (A R : ZPt) : Nat :=
  8 + (if 111 < M.length % 128 then 4 else 2) + 5 + 7 + 87 + 5 +
    Edwards25519.mulDoubleBasePublic.blocks (scalar.mul8.spec sb) 0#1 (negA A)
      (scalar.reduce64.spec (digestBits M)) +
    blocksOf (sbAh M sb A) R

end Verifier.verify

end

/-! ## Proof -/

section Proof

open Verifier.verify

/-! ### `Sha512.final`'s memory past a frame erase -/

theorem eraseFrom_lenStores {d : Pointer} :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      (Sha512_final.lenStores d x i n m).eraseFrom N =
        Sha512_final.lenStores d x i n (m.eraseFrom N)
  | 0, _, _, _ => rfl
  | n + 1, i, x, m => by
    rw [Sha512_final.lenStores, eraseFrom_lenStores n, MemoryState.eraseFrom_storeAt]; rfl

theorem eraseFrom_outStores {out : Pointer} {f : Nat → BitVec 64} (h : N ≤ out.id.id) :
    ∀ n j (m : MemoryState), (Sha512_final.outStores out f j n m).eraseFrom N = m.eraseFrom N
  | 0, _, _ => rfl
  | n + 1, j, m => by
    rw [Sha512_final.outStores, eraseFrom_outStores h n,
      MemoryState.eraseFrom_storeAt_of_le
        (by
          rw [Pointer.add_id]; exact h)]

theorem state_eraseFrom {m : MemoryState} {d : Pointer} (hd : d.id.id < N) :
    Sha512Obj.state (m.eraseFrom N) d = Sha512Obj.state m d := by
  have h (k : BitVec 64) : (m.eraseFrom N).readAt (d.add k) 64 = m.readAt (d.add k) 64 :=
    readAt_eraseFrom
      (by
        rw [Pointer.add_id]; exact hd)
  simp only [Sha512Obj.state, h]

theorem roundState_eraseFrom {s : GlobalState} {d p : Pointer} (hd : d.id.id < N) (hp : p.id.id < N)
    (a : AllocState) :
    (Sha512_update.roundState s d p).mem.eraseFrom N =
      (Sha512_update.roundState ⟨a, s.mem.eraseFrom N⟩ d p).mem := by
  simp only [Sha512_update.roundState, Sha512Obj.setState, Sha512Obj.eraseFrom_storeWords,
    state_eraseFrom hd, readAt_eraseFrom hp]

theorem padMem_eraseFrom {m : MemoryState} {d : Pointer} {bl : BitVec 8} :
    (Sha512_final.padMem m d bl).eraseFrom N = Sha512_final.padMem (m.eraseFrom N) d bl := by
  simp only [Sha512_final.padMem, MemoryState.eraseFrom_storeAt]

theorem padState_eraseFrom {s : GlobalState} {d : Pointer} (hd : d.id.id < N) (a : AllocState) :
    (padState s d).mem.eraseFrom N = (padState ⟨a, s.mem.eraseFrom N⟩ d).mem := by
  have h80 : (d.add 80#64).id.id < N := by
    rw [Pointer.add_id]; exact hd
  have hbl : Sha512Obj.bufLen (s.mem.eraseFrom N) d = Sha512Obj.bufLen s.mem d :=
    readAt_eraseFrom
      (by
        rw [Pointer.add_id]; exact hd)
  unfold padState
  dsimp only
  rw [hbl]
  split
  · rw [MemoryState.eraseFrom_storeAt, roundState_eraseFrom hd h80 a]
    dsimp only
    rw [padMem_eraseFrom]
  · exact padMem_eraseFrom

theorem lenState_eraseFrom {s : GlobalState} {d : Pointer} (hd : d.id.id < N) (a : AllocState) :
    (Sha512_final.lenState s d).mem.eraseFrom N =
      (Sha512_final.lenState ⟨a, s.mem.eraseFrom N⟩ d).mem := by
  have htl : Sha512Obj.totalLen (s.mem.eraseFrom N) d = Sha512Obj.totalLen s.mem d :=
    readAt_eraseFrom hd
  simp only [Sha512_final.lenState, eraseFrom_lenStores, MemoryState.eraseFrom_storeAt, htl]

theorem finalState_eraseFrom {s : GlobalState} {d : Pointer} (hd : d.id.id < N) :
    (finalState s d).mem.eraseFrom N = finalMem (s.mem.eraseFrom N) d := by
  have h80 : (d.add 80#64).id.id < N := by
    rw [Pointer.add_id]; exact hd
  unfold finalMem finalState
  rw [roundState_eraseFrom hd h80 ⟨0⟩, lenState_eraseFrom hd ⟨0⟩, padState_eraseFrom hd ⟨0⟩]
  rfl

/-- A frame above the object commutes with `finalMem`. -/
public theorem finalMem_eraseFrom {m : MemoryState} {d : Pointer} (hd : d.id.id < N) :
    (finalMem m d).eraseFrom N = finalMem (m.eraseFrom N) d :=
  finalState_eraseFrom (s := ⟨⟨0⟩, m⟩) hd

/-- `post`'s memory with a frame holding `out` erased: `finalMem`'s. -/
theorem post_eraseFrom {s : GlobalState} {d out : Pointer} (hd : d.id.id < N) (ho : N ≤ out.id.id) :
    (Sha512_final.post s d out).mem.eraseFrom N = finalMem (s.mem.eraseFrom N) d := by
  show (Sha512_final.outStores out _ 0 8 (finalState s d).mem).eraseFrom N = _
  rw [eraseFrom_outStores ho, finalState_eraseFrom hd]

/-! ### `finalMem`'s frame -/

theorem eraseFrom_storeWords_of_le {d : Pointer} {f : Nat → BitVec 64} (h : n ≤ d.id.id) :
    ∀ k i (m : MemoryState), (Sha512Obj.storeWords d f i k m).eraseFrom n = m.eraseFrom n
  | 0, _, _ => rfl
  | k + 1, i, m => by
    rw [Sha512Obj.storeWords, eraseFrom_storeWords_of_le h k,
      MemoryState.eraseFrom_storeAt_of_le
        (by
          rw [Pointer.add_id]; exact h)]

theorem eraseFrom_lenStores_of_le {d : Pointer} (h : n ≤ d.id.id) :
    ∀ k i (x : BitVec 128) (m : MemoryState),
      (Sha512_final.lenStores d x i k m).eraseFrom n = m.eraseFrom n
  | 0, _, _, _ => rfl
  | k + 1, i, x, m => by
    rw [Sha512_final.lenStores, eraseFrom_lenStores_of_le h k,
      MemoryState.eraseFrom_storeAt_of_le
        (by
          rw [Pointer.add_id]; exact h)]

/-- A frame holding the object drops `finalMem`'s writes. -/
public theorem finalMem_eraseFrom_of_le {m : MemoryState} {d : Pointer} (h : n ≤ d.id.id) :
    (finalMem m d).eraseFrom n = m.eraseFrom n := by
  have h' (k : BitVec 64) : n ≤ (d.add k).id.id := by
    rw [Pointer.add_id]; exact h
  have hp : (padState ⟨⟨0⟩, m⟩ d).mem.eraseFrom n = m.eraseFrom n := by
    unfold padState
    dsimp only
    split
    · simp only [Sha512_update.roundState, Sha512Obj.setState, Sha512_final.padMem,
        MemoryState.eraseFrom_storeAt_of_le (h' _), eraseFrom_storeWords_of_le h]
    · simp only [Sha512_final.padMem, MemoryState.eraseFrom_storeAt_of_le (h' _)]
  simp only [finalMem, finalState, Sha512_update.roundState, Sha512Obj.setState,
    eraseFrom_storeWords_of_le h, Sha512_final.lenState, eraseFrom_lenStores_of_le h,
    MemoryState.eraseFrom_storeAt_of_le (h' _), hp]

/-! ### What `Sha512.final` keeps -/

/-- `Absorbed` in a memory holding the object's block alike. -/
theorem Absorbed.congr {m m' : MemoryState} {d : Pointer} (h : m'[d.id]? = m[d.id]?)
    (hA : Sha512Obj.Absorbed m d M) : Sha512Obj.Absorbed m' d M := by
  have hr (k : BitVec 64) (w : Nat) : m'.readAt (d.add k) w = m.readAt (d.add k) w :=
    readAt_congr
      (by
        rw [Pointer.add_id]; exact h)
  have hr0 (w : Nat) : m'.readAt d w = m.readAt d w := readAt_congr h
  have hf : Fits m' (d.add 80#64) (8 * (M.length % 128)) := by
    obtain ⟨b, hb, hl, hw, hdf⟩ := hA.bufFits
    exact
      ⟨b,
        (by
          rw [Pointer.add_id] at hb ⊢; exact h.trans hb),
        hl, hw, hdf⟩
  obtain ⟨h1, h2, h3, h4, -⟩ := hA
  refine ⟨?_, ?_, ?_, ?_, hf⟩ <;>
    simp only [Sha512Obj.state, Sha512Obj.bufLen, Sha512Obj.buf, Sha512Obj.totalLen, hr,
      hr0] at * <;>
    assumption

/-- A point apart from the object and `out`: `post` keeps it. -/
theorem post_pt {s : GlobalState} {d out p : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (h1 : (Range.of d 1792).Disjoint (Range.of p 1344))
    (h2 : (Range.of out 512).Disjoint (Range.of p 1344)) (hp : s.mem.PtLimbsFit p) :
    (Sha512_final.post s d out).mem.PtLimbsFit p ∧
      (Sha512_final.post s d out).mem.readPt p = s.mem.readPt p := by
  obtain ⟨ho, hr, hx, hy, hz, ht⟩ := hp
  have hl (q : Pointer) (h : s.mem.LimbsFit q) : (Sha512_final.post s d out).mem.LimbsFit q :=
    ⟨h.1, Sha512_final.Fits.post h.2.1, Sha512_final.Fits.post h.2.2.1,
      Sha512_final.Fits.post h.2.2.2.1, Sha512_final.Fits.post h.2.2.2.2.1,
      Sha512_final.Fits.post h.2.2.2.2.2⟩
  have hpl : Live (Sha512_final.post s d out).mem p 1344 := Sha512_final.live_post.2 hr
  refine ⟨⟨ho, hpl, hl _ hx, hl _ hy, hl _ hz, hl _ ht⟩, ?_⟩
  refine MemoryState.readPt_of_readAt (hpl.inBounds.mono (by omega)) ho ?_
  rw [MemoryState.readAt_of_readAt_le (w := 1280) (by omega)
      (Sha512_final.post_readAt hdo hoo hbl h1 h2),
    BitVec.setWidth_eq_extractLsb' (by omega)]
  exact MemoryState.readAt_pt_bits hr.inBounds ho

/-- Bits apart from the object and `out`: `post` keeps them known. -/
theorem post_bits {s : GlobalState} {d out q : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (h1 : (Range.of d 1792).Disjoint (Range.of q w))
    (h2 : (Range.of out 512).Disjoint (Range.of q w)) (hq : Fits s.mem q w) :
    Fits (Sha512_final.post s d out).mem q w ∧
      (Sha512_final.post s d out).mem.readAt q w = s.mem.readAt q w :=
  ⟨Sha512_final.Fits.post hq, Sha512_final.post_readAt hdo hoo hbl h1 h2⟩

/-- `post`'s counter: two blocks per round, two rounds if the length no longer fits. -/
theorem post_alloc (s : GlobalState) (d out : Pointer) :
    (Sha512_final.post s d out).alloc.nextFreeBlock =
      s.alloc.nextFreeBlock + if 111 < (Sha512Obj.bufLen s.mem d).toNat then 4 else 2 := by
  simp only [Sha512_final.post, Sha512_final.fromLen, Sha512_update.roundState,
    Sha512_final.lenState]
  split <;> rfl

/-- The 64 bytes `bytesLE` reads as `M`'s digest are `digestBits M`. -/
theorem eq_digestBits {x : BitVec 512} (h : bytesLE x = Sha512.digest M) : x = digestBits M := by
  apply BitVec.eq_of_toNat_eq
  rw [digestBits, ← h, BitVec.toNat_ofNat, Ed25519.natLE_bytesLE (n := 64) x,
    Nat.mod_eq_of_lt x.isLt]

/-- Definedness over `out`'s word `j`: set. -/
theorem definedAt_storeAt_out {m : MemoryState} {out : Pointer} (hfo : Room m out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) {j : Nat} (hj : j < 8) (x : BitVec 64) :
    (m.storeAt (out.add (BitVec.ofNat 64 (8 * j))) x).definedAt out 512 =
      Memory.spliceBits (m.definedAt out 512) (64 * j) (BitVec.allOnes 64) := by
  rw [MemoryState.definedAt_add_storeAt hfo
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)]
  congr 1
  simp
  omega

/-- The 64 bytes `outStores` writes are known. -/
theorem fits_outStores {X : MemoryState} {out : Pointer} {f : Nat → BitVec 64}
    (h : Room (Sha512_final.outStores out f 0 8 X) out 512) (hoo : out.offset.toNat + 64 < 2 ^ 64) :
    Fits (Sha512_final.outStores out f 0 8 X) out 512 := by
  refine Fits.of_definedAt h.live ?_
  simp only [Sha512_final.outStores] at h ⊢
  simp only [Room.storeAt_iff] at h
  have hfo := h
  rw [definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 7) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 6) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 5) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 4) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 3) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 2) (by omega),
    definedAt_storeAt_out (by simp [Room.storeAt_iff, hfo]) hoo (j := 1) (by omega),
    definedAt_storeAt_out hfo hoo (j := 0) (by omega)]
  generalize X.definedAt out 512 = D
  simp only [spliceBits_eq]
  bv_decide

/-- `Sha512.final`'s digest at `out` is known. -/
theorem fits_post_out {s : GlobalState} {d out : Pointer} (hr : Room s.mem out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) : Fits (Sha512_final.post s d out).mem out 512 := by
  have h := Sha512_final.room_post (d := d) (out := out) |>.2 hr
  simp only [Sha512_final.post, Sha512_final.fromLen] at h ⊢
  exact fits_outStores h hoo

/-! ### Callees on named values -/

/-- `Sha512.final`'s `call_eq` with `buf_len` `bl`. -/
theorem Sha512_final.call_eq_of (d out : Pointer) (s : GlobalState) (hwf : s.WF)
    (hd : Sha512Obj.Fit s.mem d) (hb : Sha512Obj.bufLen s.mem d = bl)
    (hbuf : Fits s.mem (d.add 80#64) (8 * bl.toNat)) (hbl : bl.toNat < 128)
    (ho : Room s.mem out 512) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of out 512)) :
    Sha512_final.call (Sha512_final.args (.value d) (.value out)) s =
      .value (.nil, Sha512_final.post s d out) := by
  subst hb
  exact Sha512_final.call_eq d out s hwf hd hbuf hbl ho hoo hsep

/-- `scalar.reduce64`'s `call_eq` on the bytes `x` read at `p`. -/
theorem scalar_reduce64.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 256) (hp : Fits s.mem p 512) (hpo : p.offset.toNat + 64 < 2 ^ 64)
    (hx : s.mem.readAt p 512 = x) :
    scalar_reduce64.call (scalar_reduce64.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storeAt out (scalar.reduce64.spec x) }) := by
  subst hx
  exact scalar_reduce64.call_eq out p s hwf hout hp hpo

/-- `scalar.mul8`'s `call_eq` on the bytes `x` read at `p`. -/
theorem scalar_mul8.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 256) (hp : Fits s.mem p 256) (hx : s.mem.readAt p 256 = x) :
    scalar_mul8.call (scalar_mul8.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem := s.mem.storeAt out (scalar.mul8.spec x) }) := by
  subst hx
  exact scalar_mul8.call_eq out p s hwf hout hp

/-- `clearCofactor`'s `call_eq` on the point `P` read at `p`. -/
theorem Edwards25519_clearCofactor.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hPd : s.mem.readPt p = P)
    (hP : P.Lt (2 ^ 53)) :
    Edwards25519_clearCofactor.call (Edwards25519_clearCofactor.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 87⟩,
            mem := s.mem.storePtCopy out (Edwards25519.clearCofactor.spec P) 0#1 }) := by
  subst hPd
  exact Edwards25519_clearCofactor.call_eq out p s hwf hout hp hP.1 hP.2.1 hP.2.2.1

/-- `sub`'s `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
theorem Edwards25519_sub.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_sub.globals) (hout : s.mem.PtRoom out)
    (hp : s.mem.PtLimbsFit p) (hq : s.mem.PtLimbsFit q)
    (hPd : s.mem.readPt p = P) (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53))
    (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 44⟩,
            mem := s.mem.storePtCopy out (Edwards25519.sub.spec P Q) 0#1 }) := by
  subst hPd hQd
  exact Edwards25519_sub.call_eq out p q s hwf hg hout hp hq hP hQ

/-- `isIdentity`'s `call_eq` on the point `P` read at `p`. -/
theorem Verifier_isIdentity.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.PtLimbsFit p) (hPd : s.mem.readPt p = P) (hP : P.Lt (2 ^ 52)) :
    Verifier_isIdentity.call (Verifier_isIdentity.args (.value p)) s =
      .value
        (.cons (.value (Verifier.isIdentity.spec P)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + if Fe.isZero.spec P.x = 1#1 then 4 else 3⟩,
            mem := s.mem }) := by
  subst hPd
  exact
    Verifier_isIdentity.call_eq p s hwf hp (hP.1.mono (by decide)) (hP.2.1.mono (by decide))
      (hP.2.2.1.mono (by decide))

/-- `mulDoubleBasePublic`'s `call_eq` on named inputs, a weak key: the `WeakPublicKey` copy. -/
theorem Edwards25519_mulDoubleBasePublic.call_eq_none (out s1 p2 s2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals Edwards25519_mulDoubleBasePublic.globals)
    (hout : Room s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hs1 : Fits s.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hx1 : s.mem.readAt s1 256 = x1) (hm1 : x1.msb = false) (hp2 : s.mem.PtFit p2)
    (hP2d : s.mem.readPt p2 = P2) (hb : s.mem.readBase p2 = b) (hP2 : P2.Lt (2 ^ 53))
    (hs2 : Fits s.mem s2 256) (hs2o : ¬s2.offset.uaddOverflow 32#64)
    (hx2 : s.mem.readAt s2 256 = x2) (hm2 : x2.msb = false)
    (hres : Edwards25519.mulDoubleBasePublic.spec x1 b P2 x2 = none) :
    Edwards25519_mulDoubleBasePublic.call
        (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Edwards25519.mulDoubleBasePublic.blocks x1 b P2 x2⟩,
            mem :=
              s.mem.storeDef out Edwards25519_mulDoubleBasePublic_weak.bits
                Edwards25519.mulDoubleBasePublic.weakDef }) := by
  subst hx1 hx2 hP2d hb
  rw [Edwards25519_mulDoubleBasePublic.call_eq out s1 p2 s2 s hwf hg hout hoo hs1 hs1o hm1 hp2 hP2
      hs2 hs2o hm2,
    hres]
  rfl

/-- `mulDoubleBasePublic`'s `call_eq` on named inputs, a point `Q`: error code `0`, `Q`. -/
theorem Edwards25519_mulDoubleBasePublic.call_eq_some (out s1 p2 s2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals Edwards25519_mulDoubleBasePublic.globals)
    (hout : Room s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hs1 : Fits s.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hx1 : s.mem.readAt s1 256 = x1) (hm1 : x1.msb = false) (hp2 : s.mem.PtFit p2)
    (hP2d : s.mem.readPt p2 = P2) (hb : s.mem.readBase p2 = b) (hP2 : P2.Lt (2 ^ 53))
    (hs2 : Fits s.mem s2 256) (hs2o : ¬s2.offset.uaddOverflow 32#64)
    (hx2 : s.mem.readAt s2 256 = x2) (hm2 : x2.msb = false)
    (hres : Edwards25519.mulDoubleBasePublic.spec x1 b P2 x2 = some Q) :
    Edwards25519_mulDoubleBasePublic.call
        (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Edwards25519.mulDoubleBasePublic.blocks x1 b P2 x2⟩,
            mem := (s.mem.storeAt (out.add 168#64) 0#16).storePtCopy out Q 0#1 }) := by
  subst hx1 hx2 hP2d hb
  rw [Edwards25519_mulDoubleBasePublic.call_eq out s1 p2 s2 s hwf hg hout hoo hs1 hs1o hm1 hp2 hP2
      hs2 hs2o hm2,
    hres]
  rfl

/-- `WeakPublicKey`'s code in its bits. -/
theorem weak_code_val :
    (Edwards25519_mulDoubleBasePublic_weak.bits).extractLsb' 1344 16 = 4#16 := by decide +kernel

/-- What `mulDoubleBasePublic` leaves for a weak key: error code `4`. -/
theorem weak_code {m : MemoryState} {p : Pointer} (hr : Room m p 1408)
    (hov : ¬p.offset.uaddOverflow 168#64) :
    Fits
        (m.storeDef p Edwards25519_mulDoubleBasePublic_weak.bits
          Edwards25519.mulDoubleBasePublic.weakDef)
        (p.add 168#64) 16 ∧
      (m.storeDef p Edwards25519_mulDoubleBasePublic_weak.bits
              Edwards25519.mulDoubleBasePublic.weakDef).readAt
          (p.add 168#64) 16 =
        4#16 := by
  refine ⟨Fits.storeDef_of_mask hr hov (by simp) (by decide +kernel), ?_⟩
  rw [MemoryState.readAt_storeDef_add hr hov (by simp)]
  exact weak_code_val

/-- What `mulDoubleBasePublic` leaves for a point `Q`: error code `0`, `Q`. -/
theorem some_code {m : MemoryState} {p : Pointer} (hr : Room m p 1408) (ho : p.offset = 0)
    (Q : ZPt) :
    Fits ((m.storeAt (p.add 168#64) 0#16).storePtCopy p Q 0#1) (p.add 168#64) 16 ∧
      ((m.storeAt (p.add 168#64) 0#16).storePtCopy p Q 0#1).readAt (p.add 168#64) 16 = 0#16 ∧
      ((m.storeAt (p.add 168#64) 0#16).storePtCopy p Q 0#1).PtLimbsFit p ∧
      ((m.storeAt (p.add 168#64) 0#16).storePtCopy p Q 0#1).readPt p = Q := by
  have hov : ¬p.offset.uaddOverflow 168#64 := by simp [BitVec.uaddOverflow, ho]
  have h168 : Room m (p.add 168#64) 16 := Room.add_of_le hov (by simp) hr
  have hdj : (Range.of p 1344).Disjoint (Range.of (p.add 168#64) 16) := by
    right; left
    simp [Range.of, Pointer.offsetInBits, Pointer.add, ho]
  have hpr : (m.storeAt (p.add 168#64) 0#16).PtRoom p :=
    ⟨by simp [ho], (hr.mono (by omega)).storeAt⟩
  refine
    ⟨Fits.storeDef_of_disjoint (Fits.storeAt_self h168) hdj, ?_,
      (MemoryState.PtFit.storePtCopy_self hpr).ptLimbsFit, MemoryState.readPt_storePtCopy_self hpr⟩
  rw [MemoryState.readAt_storeDef_disjoint hdj, MemoryState.readAt_storeAt_self h168]

/-- `ladder` keeps limbs below `2^53`. -/
theorem ladder_lt {T : Nat → ZPt} {x1 x2 : BitVec 256} :
    ∀ i (Q : ZPt),
      Q.Lt (2 ^ 53) → (Edwards25519.mulDoubleBasePublic.ladder T x1 x2 i Q).Lt (2 ^ 53) := by
  have hd (tbl : Nat → ZPt) (d : BitVec 8) (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) :
    (Edwards25519.mulDoubleBasePublic.digitStep tbl d Q).Lt (2 ^ 53) := by
    unfold Edwards25519.mulDoubleBasePublic.digitStep
    split
    · exact ZPt.Lt.mono53 (Edwards25519.add.spec_lt _ _)
    · split
      · exact ZPt.Lt.mono53 (Edwards25519.sub.spec_lt _ _)
      · exact hQ
  intro i
  induction i with
  | zero => exact fun Q hQ => hd _ _ _ (hd _ _ _ hQ)
  | succ i ih =>
    intro Q _
    exact ih _ (ZPt.Lt.mono53 (Edwards25519.dbl.spec_lt _))

/-- `mulDoubleBasePublic`'s point has limbs below `2^53`. -/
theorem mdbp_lt (h : Edwards25519.mulDoubleBasePublic.spec x1 b P2 x2 = some Q) :
    Q.Lt (2 ^ 53) := by
  have hid : Edwards25519.identity.Lt (2 ^ 53) := by
    refine ⟨?_, ?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> decide
  unfold Edwards25519.mulDoubleBasePublic.spec at h
  split at h
  · cases h; exact ladder_lt 63 _ hid
  · split at h
    · cases h; exact ladder_lt 63 _ hid
    · cases h

/-- A scalar below `ℓ` has its top bit clear. -/
public theorem msb_of_lt_ell {x : BitVec 256} (h : x.toNat < ell) : x.msb = false := by
  rw [BitVec.msb_eq_false_iff_two_mul_lt]; have := Ed25519.ell_lt; omega

/-- `8 A`'s limbs are below `2^52`. -/
public theorem clearCofactor_lt (P : ZPt) : (Edwards25519.clearCofactor.spec P).Lt (2 ^ 52) :=
  Edwards25519.dbl.spec_lt _

/-- `-(8 A)`'s limbs are below `2^53`. -/
public theorem negA_lt (P : ZPt) : (negA P).Lt (2 ^ 53) :=
  Edwards25519.neg.spec_lt (ZPt.Lt.mono53 (clearCofactor_lt P))

attribute [local mlir_erase high] post_eraseFrom

theorem Room.post {s : GlobalState} {d out q : Pointer} (h : Room s.mem q w) :
    Room (Sha512_final.post s d out).mem q w :=
  Sha512_final.room_post.2 h

/-- `post` only stores: the global table is kept (the steps cannot see it through its `if`). -/
theorem Globals.post {s : GlobalState} {d out : Pointer} {G : List Global} (h : s.mem.Globals G) :
    (Sha512_final.post s d out).mem.Globals G :=
  h.mono
    (by
      unfold Sha512_final.post
      dsimp only
      split <;> rfl)
    fun _ h => h

attribute [local mlir_transport] Room.post Sha512_final.Fits.post Sha512_final.post_wf

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

/-- `Verifier.verify` on `self` returns `code` of the bytes `M` its hash object has absorbed, its
scalar's bytes (`+560`) and points (`+224`, `+392`, limbs below `2^53`); the hash object is left
as `finalMem`, the rest of memory as it was. -/
public theorem Verifier_verify.call_eq (self : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Verifier_verify.globals)
    (hself : Room s.mem self 4736) (hso : self.offset.toNat + 592 < 2 ^ 64) (M : List (BitVec 8))
    (hd : Sha512Obj.Fit s.mem self) (hM : Sha512Obj.Absorbed s.mem self M)
    (hpa : s.mem.PtLimbsFit (self.add 224#64)) (hpr : s.mem.PtLimbsFit (self.add 392#64))
    (hsf : Fits s.mem (self.add 560#64) 256) (hA : (s.mem.readPt (self.add 224#64)).Lt (2 ^ 53))
    (hR : (s.mem.readPt (self.add 392#64)).Lt (2 ^ 53)) :
    Verifier_verify.call (Verifier_verify.args (.value self)) s =
      .value
        (.cons
            (.value
              (code M (s.mem.readAt (self.add 560#64) 256) (s.mem.readPt (self.add 224#64))
                (s.mem.readPt (self.add 392#64))))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks M (s.mem.readAt (self.add 560#64) 256) (s.mem.readPt (self.add 224#64))
                    (s.mem.readPt (self.add 392#64))⟩,
            mem := finalMem s.mem self }) := by
  generalize hAe : s.mem.readPt (self.add 224#64) = A at hA
  generalize hRe : s.mem.readPt (self.add 392#64) = R at hR
  generalize hSe : s.mem.readAt (self.add 560#64) 256 = Sc
  have hbuf := Sha512_update.fits_buf hM
  have hbl := Sha512_update.bufLen_lt hM
  generalize hbl0 : Sha512Obj.bufLen s.mem self = bl at hbuf hbl
  obtain ⟨hdo, hdr, hdf, hdf208⟩ := hd
  func_init
  have hM₀ := hS ▸ hM
  have hbl₀ := hS ▸ hbl0
  clear hM hbl0
  block_init
  iterate 3 step_pure
  step_alloca with chk
  step_alloca with cR
  step_alloca with sa
  step_alloca with p2
  step_alloca with cA
  step_alloca with s8
  step_alloca with hr
  step_alloca with h64
  have hN : self.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Room.mem hself₀)
  have hE₀ : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem.eraseFrom S₀.alloc.nextFreeBlock := by
    rw [hS, hwf₀.eraseFrom]; erase_frame
  have hb₀ : S.mem[self.id]? = S₀.mem[self.id]? := getElem?_of_eraseFrom hE₀ hN
  have hM' := Absorbed.congr hb₀ hM₀
  have hbl' : Sha512Obj.bufLen S.mem self = bl :=
    (readAt_congr
          (by
            rw [Pointer.add_id]; exact hb₀)).trans
      hbl₀
  have hoo : h64.offset.toNat + 64 < 2 ^ 64 := by simp [hh64_off]
  have hsep : (Range.of self 1792).Disjoint (Range.of h64 512) := .inl hself_ne_h64
  have hdisj (k : BitVec 64) (w : Nat) (hk : 224 ≤ k.toNat) (hkw : 8 * k.toNat + w ≤ 4736) :
    (Range.of self 1792).Disjoint (Range.of (self.add k) w) := by
    right; left
    simp only [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have hdisj' (k : BitVec 64) (w : Nat) : (Range.of h64 512).Disjoint (Range.of (self.add k) w) :=
    .inl hself_ne_h64.symm
  have hA8 : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 8 := by
    rw [hS]; simp [GlobalState.alloca]
  have hbl8 : bl.toNat = M.length % 128 := by rw [← hbl₀, hM₀.bufLen]
  checkpoint hck
  have hXa := fun X (hX : X = Sha512_final.post S self h64) =>
    (hX ▸ by rw [post_alloc, hbl', hbl8, hA8] :
      X.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 8 + if 111 < M.length % 128 then 4 else 2)
  have hpost := fun X (hX : X = Sha512_final.post S self h64) =>
    (hX ▸
        ⟨eq_digestBits (Sha512_final.digest hM' ⟨hdo, hdr, hdf, hdf208⟩ hh64_room hoo),
          fits_post_out hh64_room hoo,
          post_pt hdo hoo (hbl'.symm ▸ hbl) (hdisj 224#64 1344 (by decide) (by decide))
            (hdisj' 224#64 1344) hpa,
          post_pt hdo hoo (hbl'.symm ▸ hbl) (hdisj 392#64 1344 (by decide) (by decide))
            (hdisj' 392#64 1344) hpr,
          post_bits hdo hoo (hbl'.symm ▸ hbl) (hdisj 560#64 256 (by decide) (by decide))
            (hdisj' 560#64 256) hsf⟩ :
      X.mem.readAt h64 512 = digestBits M ∧
        Fits X.mem h64 512 ∧
        (X.mem.PtLimbsFit (self.add 224#64) ∧
          X.mem.readPt (self.add 224#64) = S.mem.readPt (self.add 224#64)) ∧
        (X.mem.PtLimbsFit (self.add 392#64) ∧
          X.mem.readPt (self.add 392#64) = S.mem.readPt (self.add 392#64)) ∧
        (Fits X.mem (self.add 560#64) 256 ∧
          X.mem.readAt (self.add 560#64) 256 = S.mem.readAt (self.add 560#64) 256))
  rw [hAe, hRe, hSe] at hpost
  have hFit : Sha512Obj.Fit S.mem self := ⟨hdo, hdr, hdf, hdf208⟩
  have hgp := fun X (hX : X = Sha512_final.post S self h64) =>
    (hX ▸ Globals.post hg : X.mem.Globals _)
  step_call using Sha512_final.call_eq_of consuming hM' hbl' hbuf hsep hpa hpr hsf hdf hdf208 hFit
    hg
  obtain ⟨hdig, hf64, ⟨hpa, hAd⟩, ⟨hpr, hRd⟩, ⟨hsf, hSd⟩⟩ := hpost S hS
  have hXa := hXa S hS
  have hg := hgp S hS
  clear hgp
  clear hpost
  have hpo64 : h64.offset.toNat + 64 < 2 ^ 64 := hoo
  step_call using scalar_reduce64.call_eq_of consuming hf64 hdig hpo64
  step_pure
  step_call using scalar_mul8.call_eq_of consuming hsf hSd
  step_pure
  have hcAr : S.mem.PtRoom cA := .of_room hcA_room hcA_off
  step_call using Edwards25519_clearCofactor.call_eq_of consuming hAd hA hcAr hpa
  have hp2r : S.mem.PtRoom p2 := .of_room hp2_room hp2_off
  have hcAl : S.mem.PtLimbsFit cA := hcAr.ptLimbsFit
  have hsep2 : p2.id ≠ cA.id := by
    rw [hp2, hcA]; exact GlobalState.slot_id_ne (by decide)
  have hcx := ((clearCofactor_lt A).1).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have hct := ((clearCofactor_lt A).2.2.2).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Edwards25519_neg.call_eq_of consuming hp2r hcAl hsep2 hread_cA_readPt hcx hct
  have hm1 : (scalar.mul8.spec Sc).msb = false :=
    msb_of_lt_ell
      (by
        rw [scalar.mul8.toNat_spec]; exact Nat.mod_lt _ (by decide))
  have hm2 : (scalar.reduce64.spec (digestBits M)).msb = false :=
    msb_of_lt_ell
      (by
        rw [scalar.reduce64.toNat_spec]; exact Nat.mod_lt _ (by decide))
  have hnl := negA_lt A
  have hP2d : S.mem.readPt p2 = negA A := hread_p2_readPt
  clear hread_p2_readPt
  have hs8o : ¬s8.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hs8_off]
  have hhro : ¬hr.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hhr_off]
  have hsao : sa.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hsa_off]
  have hsa168 : ¬sa.offset.uaddOverflow 168#64 := by simp [BitVec.uaddOverflow, hsa_off]
  checkpoint hck2
  rcases hres : sbAh M Sc A with _ | Q
  · have hcode :=
      fun m'
        (hm :
          m' =
            S.mem.storeDef sa Edwards25519_mulDoubleBasePublic_weak.bits
              Edwards25519.mulDoubleBasePublic.weakDef) =>
      hm ▸ weak_code hsa_room hsa168
    step_call using
      (Edwards25519_mulDoubleBasePublic.call_eq_none (x1 := scalar.mul8.spec Sc) (b := 0#1) (P2 :=
        negA A) (x2 := scalar.reduce64.spec (digestBits M)) (hres := hres)) consuming
      hread_s8 hm1 hP2d hread_p2 hnl hread_hr hm2
    obtain ⟨hcf, hcr⟩ := hcode _ (congrArg GlobalState.mem hS)
    clear hcode
    step_pure
    step_load only [hcr] consuming hcf hcr
    step_pure
    finish_block
    case isTrue => exact absurd (weak_code_val.symm.trans hbr) (by decide)
    case isFalse =>
      block_init
      finish_block
      rw [hS]
      clear_reads
      clear hRd hbl₀ hbl8
      subst_vars
      erase_frame
      rw [hXa, weak_code_val, code, hres, blocks, hres]
      simp only [codeOf, blocksOf]
      generalize (if 111 < M.length % 128 then 4 else 2) = r1
      generalize Edwards25519.mulDoubleBasePublic.blocks _ _ _ _ = r2
      rw [show
          S₀.alloc.nextFreeBlock + 8 + r1 + 5 + 7 + 87 + 5 + r2 =
            S₀.alloc.nextFreeBlock + (8 + r1 + 5 + 7 + 87 + 5 + r2 + 0)
          by omega]
  · have hcode := fun m' (hm : m' = (S.mem.storeAt (sa.add 168#64) 0#16).storePtCopy sa Q 0#1) =>
      hm ▸ some_code hsa_room hsa_off Q
    have hQl := mdbp_lt hres
    step_call using
      (Edwards25519_mulDoubleBasePublic.call_eq_some (x1 := scalar.mul8.spec Sc) (b := 0#1) (P2 :=
        negA A) (x2 := scalar.reduce64.spec (digestBits M)) (hres := hres)) consuming
      hread_s8 hm1 hP2d hread_p2 hnl hread_hr hm2
    obtain ⟨hcf, hcr, hsal, hsap⟩ := hcode _ (congrArg GlobalState.mem hS)
    clear hcode
    step_pure
    step_load only [hcr] consuming hcf hcr
    step_pure
    finish_block
    block_init
    step_pure
    have hcRr : S.mem.PtRoom cR := .of_room hcR_room hcR_off
    step_call using Edwards25519_clearCofactor.call_eq_of consuming hRd hR hcRr hpr
    have hchkr : S.mem.PtRoom chk := .of_room hchk_room hchk_off
    have hcRl : S.mem.PtLimbsFit cR := hcRr.ptLimbsFit
    have hcl := ZPt.Lt.mono53 (clearCofactor_lt R)
    step_call using Edwards25519_sub.call_eq_of consuming hchkr hsal hcRl hsap hread_cR_readPt hQl
      hcl
    have hchkl : S.mem.PtLimbsFit chk := hchkr.ptLimbsFit
    have hchkd : S.mem.readPt chk = check Q R := hread_chk_readPt
    have hckl : (check Q R).Lt (2 ^ 52) := Edwards25519.sub.spec_lt _ _
    step_call using Verifier_isIdentity.call_eq_of consuming hchkl hchkd hckl
    step_pure
    finish_block
    block_init
    finish_block
    rw [hS]
    clear_reads
    clear hbl₀ hbl8
    subst_vars
    erase_frame
    rw [hXa, code, hres, blocks, hres]
    simp only [codeOf, blocksOf]
    generalize (if 111 < M.length % 128 then 4 else 2) = r1
    generalize Edwards25519.mulDoubleBasePublic.blocks _ _ _ _ = r2
    generalize (if Fe.isZero.spec (check Q R).x = 1#1 then 4 else 3) = r3
    rw [show
        S₀.alloc.nextFreeBlock + 8 + r1 + 5 + 7 + 87 + 5 + r2 + 87 + 44 + r3 =
          S₀.alloc.nextFreeBlock + (8 + r1 + 5 + 7 + 87 + 5 + r2 + (87 + 44 + r3))
        by omega]

end Proof

end MLIR.Zig

module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Tactics
public import Zig.Sha512_final
public import Zig.Edwards25519_clearCofactor
public import Zig.Edwards25519_neg
public import Zig.Edwards25519_sub
public import Zig.Edwards25519_mulDoubleBasePublic
public import Zig.Verifier_isIdentity
public import Zig.scalar_mul8
public import Zig.Steps
public import Ed25519.Decode
public import Zig.Mlir.Verifier_verify
import Std.Data.ExtHashMap.Lemmas

namespace LeanMLIR.RIR.Zig

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

/-- Stand-in for `scalar.reduce64`'s spec (its proof unfinished): `x mod ℓ`. -/
def reduce64 (x : BitVec 512) : BitVec 256 :=
  BitVec.ofNat 256 (x.toNat % ell)

/-- `-(8 A)`, `mulDoubleBasePublic`'s point. -/
def negA (A : ZPt) : ZPt :=
  Edwards25519.neg.spec (Edwards25519.clearCofactor.spec A)

/-- `mulDoubleBasePublic`'s result: `[8 S] B - [k] (8 A)`, or `none` for a weak key. -/
def sbAh (M : List (BitVec 8)) (sb : BitVec 256) (A : ZPt) : Option ZPt :=
  Edwards25519.mulDoubleBasePublic.spec (scalar.mul8.spec sb) 0#1 (negA A) (reduce64 (digestBits M))

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
  | some Q => 87 + 47 + if Fe.isZero.spec (check Q R).x = 1#1 then 4 else 3

/-- Blocks the function allocates, its callees' included. -/
def blocks (M : List (BitVec 8)) (sb : BitVec 256) (A R : ZPt) : Nat :=
  8 + (if 111 < M.length % 128 then 4 else 2) + 5 + 7 + 87 + 7 +
    Edwards25519.mulDoubleBasePublic.blocks (scalar.mul8.spec sb) 0#1 (negA A)
      (reduce64 (digestBits M)) +
    blocksOf (sbAh M sb A) R

end Verifier.verify

/-- Stand-in for `scalar_reduce64.call_eq` (its proof unfinished): `reduce64` of the 64 bytes at
`p` stored at `out`, five blocks allocated. -/
def Reduce64Call : Prop :=
  ∀ (out p : Pointer) (s : GlobalState),
    s.WF →
      Fits s.mem out 256 →
      Fits s.mem p 512 →
      out.offset.toNat + 32 < 2 ^ 64 →
      p.offset.toNat + 64 < 2 ^ 64 →
      out.id ≠ p.id →
      scalar_reduce64.call (scalar_reduce64.args (.value out) (.value p)) s =
        .value
          (.nil,
            { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
              mem := s.mem.storeAt out (Verifier.verify.reduce64 (s.mem.readAt p 512)) })

end

/-! ## Proof -/

section Proof

open Verifier.verify

/-! ### Blocks held alike -/

/-- Reads in a block two memories hold alike agree. -/
theorem readAt_congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) :
    m'.readAt p w = m.readAt p w := by
  unfold MemoryState.readAt; rw [h]

/-- Erasing from `N` keeps the blocks below it. -/
theorem getElem?_eraseFrom {m : MemoryState} {b : BlockId} (hb : b.id < N) :
    (m.eraseFrom N)[b]? = m[b]? := by
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter', hb,
    decide_true]
  cases m.mem[b]? <;> rfl

/-- Reads below `N` survive erasing from it. -/
theorem readAt_eraseFrom {m : MemoryState} {p : Pointer} (hp : p.id.id < N) :
    (m.eraseFrom N).readAt p w = m.readAt p w :=
  readAt_congr (getElem?_eraseFrom hp)

/-- `Absorbed` in a memory holding the object's block alike. -/
theorem Absorbed.congr {m m' : MemoryState} {d : Pointer} (h : m'[d.id]? = m[d.id]?)
    (hA : Sha512Obj.Absorbed m d M) : Sha512Obj.Absorbed m' d M := by
  have hr (k : BitVec 64) (w : Nat) : m'.readAt (d.add k) w = m.readAt (d.add k) w :=
    readAt_congr
      (by
        rw [Pointer.add_id]; exact h)
  have hr0 (w : Nat) : m'.readAt d w = m.readAt d w := readAt_congr h
  obtain ⟨h1, h2, h3, h4⟩ := hA
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    simp only [Sha512Obj.state, Sha512Obj.bufLen, Sha512Obj.buf, Sha512Obj.totalLen, hr,
      hr0] at * <;>
    assumption

/-! ### `Sha512.final`'s memory past a frame erase -/

theorem eraseFrom_storeWords {d : Pointer} {f : Nat → BitVec 64} :
    ∀ n i (m : MemoryState),
      (Sha512Obj.storeWords d f i n m).eraseFrom N = Sha512Obj.storeWords d f i n (m.eraseFrom N)
  | 0, _, _ => rfl
  | n + 1, i, m => by
    rw [Sha512Obj.storeWords, eraseFrom_storeWords n, MemoryState.eraseFrom_storeAt]; rfl

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
  simp only [Sha512_update.roundState, Sha512Obj.setState, eraseFrom_storeWords, state_eraseFrom hd,
    readAt_eraseFrom hp]

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

theorem lenStores_fits {d : Pointer} :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      Fits (Sha512_final.lenStores d x i n m) q w ↔ Fits m q w
  | 0, _, _, _ => Iff.rfl
  | n + 1, i, x, m => by rw [Sha512_final.lenStores, lenStores_fits n, Fits.storeAt_iff]

theorem lenStores_sameBlocks {d : Pointer} :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      Sha512_update.SameBlocks (Sha512_final.lenStores d x i n m) m
  | 0, _, _, _ => fun _ => Iff.rfl
  | n + 1, i, x, m => fun k => by
    rw [Sha512_final.lenStores]
    exact (lenStores_sameBlocks n _ _ _ k).trans MemoryState.mem_storeAt

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

/-- `finalMem` keeps the blocks. -/
public theorem finalMem_sameBlocks (m : MemoryState) (d : Pointer) :
    Sha512_update.SameBlocks (finalMem m d) m := by
  have hp : Sha512_update.SameBlocks (padState ⟨⟨0⟩, m⟩ d).mem m := by
    unfold padState
    dsimp only
    have h0 : Sha512_update.SameBlocks (Sha512_final.padMem m d (Sha512Obj.bufLen m d)) m :=
      fun _ => MemoryState.mem_storeAt.trans (MemoryState.mem_storeAt.trans MemoryState.mem_storeAt)
    split
    · exact (Sha512_update.SameBlocks.roundState (s := { mem := _, alloc := _ }) h0).storeAt
    · exact h0
  refine Sha512_update.SameBlocks.roundState fun k => ?_
  exact (lenStores_sameBlocks 15 1 _ _ k).trans (MemoryState.mem_storeAt.trans (hp k))

/-- `finalMem` keeps what fits. -/
public theorem finalMem_fits {m : MemoryState} {d q : Pointer} :
    Fits (finalMem m d) q w ↔ Fits m q w := by
  have hp : Fits (padState ⟨⟨0⟩, m⟩ d).mem q w ↔ Fits m q w := by
    unfold padState
    dsimp only
    split
    · simp only [Fits.storeAt_iff, Sha512_update.roundState_fits, Sha512_final.padMem]
    · simp only [Fits.storeAt_iff, Sha512_final.padMem]
  simp only [finalMem, finalState, Sha512_update.roundState_fits, Sha512_final.lenState,
    lenStores_fits, Fits.storeAt_iff, hp]

/-- `finalMem` keeps a state `WF`. -/
public theorem finalMem_wf {s : GlobalState} (hwf : s.WF) (d : Pointer) :
    ({ s with mem := finalMem s.mem d } : GlobalState).WF :=
  have h := finalMem_sameBlocks s.mem d
  ⟨fun k hk => hwf.bound k ((h k).1 hk), hwf.pos, fun hk => hwf.null ((h _).1 hk)⟩

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

/-- `finalMem` keeps every read apart from the object. -/
public theorem finalMem_readAt {s : GlobalState} {d q : Pointer} (hwf : s.WF)
    (hd : Fits s.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128) (hq : Fits s.mem q w)
    (h1 : (Range.of d 1792).Disjoint (Range.of q w)) :
    (finalMem s.mem d).readAt q w = s.mem.readAt q w := by
  have hN := hwf.lt (Fits.mem hd)
  have hqN := hwf.lt (Fits.mem hq)
  have he := post_eraseFrom (s := s) (out := s.allocaPtr) hN (by simp [GlobalState.allocaPtr])
  rw [hwf.eraseFrom] at he
  have hne : (Range.of s.allocaPtr 512).Disjoint (Range.of q w) := by
    left
    simp only [Range.of]
    intro h
    rw [← h] at hqN
    simp [GlobalState.allocaPtr] at hqN
  rw [← he, readAt_eraseFrom hqN,
    Sha512_final.post_readAt hdo (by simp [GlobalState.allocaPtr]) hbl h1 hne]

/-- Blocks below `N` alike in memories alike below it. -/
theorem getElem?_of_eraseFrom {m m' : MemoryState} {b : BlockId}
    (he : m'.eraseFrom N = m.eraseFrom N) (hb : b.id < N) : m'[b]? = m[b]? := by
  rw [← getElem?_eraseFrom (m := m') hb, he, getElem?_eraseFrom hb]

/-- `readPt` in a memory holding its block alike. -/
theorem readPt_congr {m m' : MemoryState} {p : Pointer} (h : m'[p.id]? = m[p.id]?) :
    m'.readPt p = m.readPt p := by
  have hl (q : Pointer) (hq : q.id = p.id) : m'.readLimbs q = m.readLimbs q := by
    have hr (k : BitVec 64) : m'.readAt (q.add k) 64 = m.readAt (q.add k) 64 :=
      readAt_congr
        (by
          rw [Pointer.add_id, hq]; exact h)
    funext i
    fin_cases i <;> simp only [MemoryState.readLimbs, hr]
    exact readAt_congr (hq ▸ h)
  simp only [MemoryState.readPt, hl p rfl, hl _ (Pointer.add_id _ _)]

/-- A point apart from the object and `out`: `post` keeps it. -/
theorem readPt_post {s : GlobalState} {d out p : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (h1 : (Range.of d 1792).Disjoint (Range.of p 1344))
    (h2 : (Range.of out 512).Disjoint (Range.of p 1344)) (hp : s.mem.PtFit p) :
    (Sha512_final.post s d out).mem.readPt p = s.mem.readPt p := by
  have hr := Sha512_final.post_readAt (s := s) hdo hoo hbl h1 h2
  have hp' : (Sha512_final.post s d out).mem.PtFit p := ⟨hp.1, Sha512_final.post_fits.2 hp.2⟩
  calc
    (Sha512_final.post s d out).mem.readPt p =
        ((Sha512_final.post s d out).mem.storeAt p
              ((Sha512_final.post s d out).mem.readAt p 1344)).readPt
          p :=
      by rw [MemoryState.storeAt_readAt_self hp'.2]
    _ = s.mem.readPt p := by
      rw [hr]; exact (MemoryState.readPt_storeAt_readAt hp hp').1

/-- The 64 bytes `bytesLE` reads as `M`'s digest are `digestBits M`. -/
theorem eq_digestBits {x : BitVec 512} (h : bytesLE x = Sha512.digest M) : x = digestBits M := by
  apply BitVec.eq_of_toNat_eq
  rw [digestBits, ← h, BitVec.toNat_ofNat, Ed25519.natLE_bytesLE (n := 64) x,
    Nat.mod_eq_of_lt x.isLt]

/-- `Absorbed` past a frame's blocks and writes. -/
theorem Absorbed.of_eraseFrom {m m₀ : MemoryState} {d : Pointer}
    (he : m.eraseFrom N = m₀.eraseFrom N) (hN : d.id.id < N) (hM : Sha512Obj.Absorbed m₀ d M) :
    Sha512Obj.Absorbed m d M :=
  Absorbed.congr (getElem?_of_eraseFrom he hN) hM

/-- The object's other bytes, read after `post`: as `m₀` holds them. -/
theorem readAt_post {X : GlobalState} {m₀ : MemoryState} {d out p : Pointer}
    (he : X.mem.eraseFrom N = m₀.eraseFrom N) (hN : d.id.id < N) (hM : Sha512Obj.Absorbed m₀ d M)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hoo : out.offset.toNat + 64 < 2 ^ 64) (hpd : p.id = d.id)
    (hout : out.id ≠ d.id) (h1 : (Range.of d 1792).Disjoint (Range.of p w)) :
    (Sha512_final.post X d out).mem.readAt p w = m₀.readAt p w := by
  have hbl : (Sha512Obj.bufLen X.mem d).toNat < 128 := by
    rw [(Absorbed.of_eraseFrom he hN hM).bufLen]; omega
  rw [Sha512_final.post_readAt hdo hoo hbl h1
      (.inl
        (by
          simp only [Range.of]; rw [hpd]; exact hout))]
  exact readAt_congr (hpd ▸ getElem?_of_eraseFrom he hN)

/-- The same for a point. -/
theorem readPt_post' {X : GlobalState} {m₀ : MemoryState} {d out p : Pointer}
    (he : X.mem.eraseFrom N = m₀.eraseFrom N) (hN : d.id.id < N) (hM : Sha512Obj.Absorbed m₀ d M)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hoo : out.offset.toNat + 64 < 2 ^ 64) (hpd : p.id = d.id)
    (hout : out.id ≠ d.id) (h1 : (Range.of d 1792).Disjoint (Range.of p 1344))
    (hp : X.mem.PtFit p) : (Sha512_final.post X d out).mem.readPt p = m₀.readPt p := by
  have hbl : (Sha512Obj.bufLen X.mem d).toNat < 128 := by
    rw [(Absorbed.of_eraseFrom he hN hM).bufLen]; omega
  rw [readPt_post hdo hoo hbl h1
      (.inl
        (by
          simp only [Range.of]; rw [hpd]; exact hout))
      hp]
  exact readPt_congr (hpd ▸ getElem?_of_eraseFrom he hN)

/-- The digest `post` stores at `out`. -/
theorem readAt_post_out {X : GlobalState} {m₀ : MemoryState} {d out : Pointer}
    (he : X.mem.eraseFrom N = m₀.eraseFrom N) (hN : d.id.id < N) (hM : Sha512Obj.Absorbed m₀ d M)
    (hf : Fits X.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) (hfo : Fits X.mem out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) :
    (Sha512_final.post X d out).mem.readAt out 512 = digestBits M :=
  eq_digestBits (Sha512_final.digest (Absorbed.of_eraseFrom he hN hM) hf hdo hfo hoo)

/-- `clearCofactor`'s `call_eq` on the point `P` read at `p`. -/
theorem Edwards25519_clearCofactor.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hPd : s.mem.readPt p = P) (hP : P.Lt (2 ^ 53)) :
    Edwards25519_clearCofactor.call (Edwards25519_clearCofactor.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 87⟩,
            mem := s.mem.storePt out (Edwards25519.clearCofactor.spec P) 0#64 }) := by
  subst hPd
  exact Edwards25519_clearCofactor.call_eq out p s hwf hout hp hP.1 hP.2.1 hP.2.2.1

/-- `mulDoubleBasePublic`'s `call_eq` on the scalars `x1`, `x2` and the point `P2` read. -/
theorem Edwards25519_mulDoubleBasePublic.call_eq_of (out s1 p2 s2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Fits s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hs1 : Fits s.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hx1 : s.mem.readAt s1 256 = x1) (hm1 : x1.msb = false) (hp2 : s.mem.PtFit p2)
    (hP2d : s.mem.readPt p2 = P2) (hP2 : P2.Lt (2 ^ 53))
    (hb : (s.mem.readRest p2).extractLsb' 0 1 = b) (hs2 : Fits s.mem s2 256)
    (hs2o : ¬s2.offset.uaddOverflow 32#64) (hx2 : s.mem.readAt s2 256 = x2) (hm2 : x2.msb = false) :
    Edwards25519_mulDoubleBasePublic.call
        (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Edwards25519.mulDoubleBasePublic.blocks x1 b P2 x2⟩,
            mem :=
              Edwards25519.mulDoubleBasePublic.store s.mem out
                (Edwards25519.mulDoubleBasePublic.spec x1 b P2 x2) }) := by
  subst hx1 hP2d hb hx2
  exact
    Edwards25519_mulDoubleBasePublic.call_eq out s1 p2 s2 s hwf hout hoo hs1 hs1o hm1 hp2 hP2 hs2
      hs2o hm2

/-- A scalar below `ℓ` has its top bit clear. -/
public theorem msb_of_lt_ell {x : BitVec 256} (h : x.toNat < ell) : x.msb = false := by
  rw [BitVec.msb_eq_false_iff_two_mul_lt]; have := Ed25519.ell_lt; omega

/-- `8 A`'s limbs are below `2^52`. -/
public theorem clearCofactor_lt (P : ZPt) : (Edwards25519.clearCofactor.spec P).Lt (2 ^ 52) :=
  Edwards25519.dbl.spec_lt _

/-- `-(8 A)`'s limbs are below `2^53`. -/
public theorem negA_lt (P : ZPt) : (negA P).Lt (2 ^ 53) := by
  have hQ := ZPt.Lt.mono53 (clearCofactor_lt P)
  have hz : Fe.Lt (fun _ => 0#64) 1 := fun _ => show (0#64).toNat < 1 by decide
  exact
    ⟨(Fe.sub.spec_lt hz (by decide)).mono (by decide), hQ.2.1, hQ.2.2.1,
      (Fe.sub.spec_lt hz (by decide)).mono (by decide)⟩

/-- Clearing `is_base`. -/
theorem flag_isBase (r : BitVec 64) : (ZPt.flag r 0#1).extractLsb' 0 1 = 0#1 := by
  simp only [ZPt.flag]; bv_decide

/-- The error code `mulDoubleBasePublic` stores at `out + 168`: `4` for the weak key, else `0`. -/
theorem readAt_store_code {m : MemoryState} {out : Pointer} (hf : Fits m out 1408)
    (ho : out.offset = 0) (r : Option ZPt) :
    (Edwards25519.mulDoubleBasePublic.store m out r).readAt (out.add 168#64) 16 =
      (match r with
      | none => 4#16
      | some _ => 0#16) := by
  have hov : ¬out.offset.uaddOverflow 168#64 := by simp [BitVec.uaddOverflow, ho]
  cases r with
  | none =>
    rw [Edwards25519.mulDoubleBasePublic.store,
      MemoryState.readAt_add_of_readAt (Fits.storeAt hf) hov (by decide)
        (MemoryState.readAt_storeAt_self hf _),
      show (168#64).toNat * 8 = 1344 from rfl]
    unfold Edwards25519.mulDoubleBasePublic.weakBits
    bv_decide
  | some
    Q =>
    have hd : (Range.of out 1344).Disjoint (Range.of (out.add 168#64) 16) := by
      right; left
      simp [Range.of, Pointer.offsetInBits, Pointer.add, ho]
    rw [Edwards25519.mulDoubleBasePublic.store, MemoryState.storePt,
      MemoryState.readAt_storeAt_disjoint hd,
      MemoryState.readAt_storeAt_self (Fits.add_of_le hov (by decide) hf)]

/-- `post`'s counter: two blocks per round, two rounds if the length no longer fits. -/
theorem post_alloc (s : GlobalState) (d out : Pointer) :
    (Sha512_final.post s d out).alloc.nextFreeBlock =
      s.alloc.nextFreeBlock + if 111 < (Sha512Obj.bufLen s.mem d).toNat then 4 else 2 := by
  simp only [Sha512_final.post, Sha512_final.fromLen, Sha512_update.roundState,
    Sha512_final.lenState]
  split <;> rfl

/-- `add`'s limbs are below `2^52`. -/
theorem add_lt (P Q : ZPt) : (Edwards25519.add.spec P Q).Lt (2 ^ 52) :=
  ⟨Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _⟩

/-- `ladder` keeps limbs below `2^53`. -/
theorem ladder_lt {T : Nat → ZPt} {x1 x2 : BitVec 256} :
    ∀ i (Q : ZPt),
      Q.Lt (2 ^ 53) → (Edwards25519.mulDoubleBasePublic.ladder T x1 x2 i Q).Lt (2 ^ 53) := by
  have hd (tbl : Nat → ZPt) (d : BitVec 8) (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) :
    (Edwards25519.mulDoubleBasePublic.digitStep tbl d Q).Lt (2 ^ 53) := by
    unfold Edwards25519.mulDoubleBasePublic.digitStep
    split
    · exact ZPt.Lt.mono53 (add_lt _ _)
    · split
      · exact ZPt.Lt.mono53 (add_lt _ _)
      · exact hQ
  have hp (i : Nat) (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) :
    (Edwards25519.mulDoubleBasePublic.posStep T x1 x2 i Q).Lt (2 ^ 53) := hd _ _ _ (hd _ _ _ hQ)
  intro i
  induction i with
  | zero => exact hp 0
  | succ i ih =>
    intro Q hQ
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

/-- `sub`'s `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
theorem Edwards25519_sub.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hq : s.mem.PtFit q) (hPd : s.mem.readPt p = P)
    (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_sub.call (Edwards25519_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 47⟩,
            mem := s.mem.storePt out (Edwards25519.sub.spec P Q) 0#64 }) := by
  subst hPd hQd
  exact Edwards25519_sub.call_eq out p q s hwf hout hp hq hP hQ

/-- `isIdentity`'s `call_eq` on the point `P` read at `p`. -/
theorem Verifier_isIdentity.call_eq_of (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : s.mem.PtFit p) (hPd : s.mem.readPt p = P) (hP : P.Lt (2 ^ 52)) :
    Verifier_isIdentity.call (Verifier_isIdentity.args (.value p)) s =
      .value
        (.cons (.value (Verifier.isIdentity.spec P)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + if Fe.isZero.spec P.x = 1#1 then 4 else 3⟩,
            mem := s.mem }) := by
  subst hPd
  exact
    Verifier_isIdentity.call_eq p s hwf hp (hP.1.mono (by decide)) (hP.2.1.mono (by decide))
      (hP.2.2.1.mono (by decide))

/-! ### Steps past `post` and `store` -/

theorem Fits.post {s : GlobalState} {d out p : Pointer} (h : Fits s.mem p w) :
    Fits (Sha512_final.post s d out).mem p w :=
  Sha512_final.post_fits.2 h

theorem GlobalState.WF.post {s : GlobalState} {d out : Pointer} (h : s.WF) :
    (Sha512_final.post s d out).WF :=
  Sha512_final.post_wf h

theorem Fits.mdbpStore {m : MemoryState} {out p : Pointer} {r : Option ZPt} (h : Fits m p w) :
    Fits (Edwards25519.mulDoubleBasePublic.store m out r) p w := by
  cases r
  · exact h.storeAt
  · exact h.storeAt.storeAt

theorem Fits.mdbpStore_iff {m : MemoryState} {out p : Pointer} {r : Option ZPt} :
    Fits (Edwards25519.mulDoubleBasePublic.store m out r) p w ↔ Fits m p w := by
  cases r <;>
    simp only [Edwards25519.mulDoubleBasePublic.store, MemoryState.storePt, Fits.storeAt_iff]

theorem PtFit.mdbpStore {m : MemoryState} {out p : Pointer} {r : Option ZPt} (h : m.PtFit p) :
    (Edwards25519.mulDoubleBasePublic.store m out r).PtFit p :=
  ⟨h.1, Fits.mdbpStore h.2⟩

theorem GlobalState.WF.mdbpStore_mk {a : AllocState} {m : MemoryState} {out : Pointer}
    {r : Option ZPt} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, Edwards25519.mulDoubleBasePublic.store m out r⟩ : GlobalState).WF := by
  cases r
  · exact h.storeAt_mk
  · exact h.storeAt_mk.storeAt_mk

theorem eraseFrom_mdbpStore_of_le {m : MemoryState} {out : Pointer} {r : Option ZPt}
    (h : N ≤ out.id.id) :
    (Edwards25519.mulDoubleBasePublic.store m out r).eraseFrom N = m.eraseFrom N := by
  have h' : N ≤ (out.add 168#64).id.id := by
    rw [Pointer.add_id]; exact h
  cases r <;>
    simp only [Edwards25519.mulDoubleBasePublic.store, MemoryState.storePt,
      MemoryState.eraseFrom_storeAt_of_le h, MemoryState.eraseFrom_storeAt_of_le h']

attribute [local mlir_erase high] eraseFrom_mdbpStore_of_le post_eraseFrom

attribute [local mlir_transport] Fits.post GlobalState.WF.post Fits.mdbpStore PtFit.mdbpStore
  GlobalState.WF.mdbpStore_mk

/-- `Verifier.verify` on `self` returns `code` of the bytes `M` its hash object has absorbed, its
scalar's bytes (`+560`) and points (`+224`, `+392`, limbs below `2^53`); the hash object is left
as `finalMem`, the rest of memory as it was. `hred` stands in for `scalar.reduce64`. -/
public theorem Verifier_verify.call_eq (hred : Reduce64Call) (self : Pointer) (s : GlobalState)
    (hwf : s.WF) (hself : Fits s.mem self 4736) (hso : self.offset.toNat + 592 < 2 ^ 64)
    (M : List (BitVec 8)) (hM : Sha512Obj.Absorbed s.mem self M)
    (hA : (s.mem.readPt (self.add 224#64)).Lt (2 ^ 53))
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
  func_init
  have hM₀ : Sha512Obj.Absorbed S₀.mem self M := hS ▸ hM
  have hA₀ : (S₀.mem.readPt (self.add 224#64)).Lt (2 ^ 53) := hS ▸ hA
  have hR₀ : (S₀.mem.readPt (self.add 392#64)).Lt (2 ^ 53) := hS ▸ hR
  clear hM hA hR
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
  have hN : self.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Fits.mem hself₀)
  have hE₀ : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [hS]; erase_frame
  have hb₀ : S.mem[self.id]? = S₀.mem[self.id]? := by rw [← getElem?_eraseFrom hN, hE₀]
  have hd : Fits S.mem self 1792 := hself.mono (by omega)
  have hdo : self.offset.toNat + 224 < 2 ^ 64 := by omega
  have hoo : h64.offset.toNat + 64 < 2 ^ 64 := by simp [hh64_off]
  have hsep : (Range.of self 1792).Disjoint (Range.of h64 512) := .inl hself_ne_h64
  have hbl : (Sha512Obj.bufLen S.mem self).toNat < 128 := by
    rw [(Absorbed.congr hb₀ hM₀).bufLen]; omega
  clear hb₀ hE₀
  step_call using Sha512_final.call_eq consuming hd hsep hbl
  -- the digest at `h64`, `self`'s scalar and points as `S₀` holds them
  have hd : Fits S.mem self 1792 := hself.mono (by omega)
  have hdisj (k : Nat) (w : Nat) (hk : 224 ≤ k) (hkw : 8 * k + w ≤ 4736) :
    (Range.of self 1792).Disjoint (Range.of (self.add (BitVec.ofNat 64 k)) w) := by
    right; left
    simp only [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hfx (k : Nat) (w : Nat) (hkw : 8 * k + w ≤ 4736) :
    Fits S.mem (self.add (BitVec.ofNat 64 k)) w :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp only [BitVec.toNat_ofNat]; omega)
      hself
  have hdig : S.mem.readAt h64 512 = digestBits M := by
    have h1 := hd
    have h2 := hh64_fits
    rw [hS] at h1 h2 ⊢
    exact
      readAt_post_out (by erase_frame) hN hM₀ (Sha512_final.post_fits.1 h1) hdo
        (Sha512_final.post_fits.1 h2) hoo
  have hsb : S.mem.readAt (self.add 560#64) 256 = S₀.mem.readAt (self.add 560#64) 256 := by
    rw [hS]
    exact
      readAt_post (by erase_frame) hN hM₀ hdo hoo (Pointer.add_id _ _) hself_ne_h64.symm
        (hdisj 560 256 (by omega) (by omega))
  have hAd : S.mem.readPt (self.add 224#64) = S₀.mem.readPt (self.add 224#64) := by
    have h1 := hfx 224 1344 (by omega)
    rw [hS] at h1 ⊢
    exact
      readPt_post' (by erase_frame) hN hM₀ hdo hoo (Pointer.add_id _ _) hself_ne_h64.symm
        (hdisj 224 1344 (by omega) (by omega))
        ⟨by
          simp [Pointer.add]; omega, Sha512_final.post_fits.1 h1⟩
  have hRd : S.mem.readPt (self.add 392#64) = S₀.mem.readPt (self.add 392#64) := by
    have h1 := hfx 392 1344 (by omega)
    rw [hS] at h1 ⊢
    exact
      readPt_post' (by erase_frame) hN hM₀ hdo hoo (Pointer.add_id _ _) hself_ne_h64.symm
        (hdisj 392 1344 (by omega) (by omega))
        ⟨by
          simp [Pointer.add]; omega, Sha512_final.post_fits.1 h1⟩
  clear hdisj hfx hd
  have hsbX := hsb
  rw [hS] at hsbX
  have hRdX := hRd
  rw [hS] at hRdX
  have hpa :
    S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 8 + if 111 < M.length % 128 then 4 else 2 := by
    rw [hS, post_alloc, (Absorbed.of_eraseFrom (by erase_frame) hN hM₀).bufLen]
    simp [GlobalState.alloca]
  rw [hS] at hpa
  generalize hAe : S₀.mem.readPt (self.add 224#64) = A at hA₀ hAd ⊢
  generalize hRe : S₀.mem.readPt (self.add 392#64) = R at hR₀ hRd hRdX ⊢
  generalize hsbe : S₀.mem.readAt (self.add 560#64) 256 = sb at hsb hsbX ⊢
  have hhr_ne : hr.id ≠ h64.id := by
    rw [hhr, hh64]; exact GlobalState.slot_id_ne (by decide)
  step_call using hred
  have hov560 : ¬self.offset.uaddOverflow 560#64 := by
    simp [BitVec.uaddOverflow]; omega
  have hov224 : ¬self.offset.uaddOverflow 224#64 := by
    simp [BitVec.uaddOverflow]; omega
  have hov392 : ¬self.offset.uaddOverflow 392#64 := by
    simp [BitVec.uaddOverflow]; omega
  have hf560 : Fits S.mem (self.add 560#64) 256 := Fits.add_of_le hov560 (by simp) hself
  have hp224 : S.mem.PtFit (self.add 224#64) :=
    ⟨by
      simp [Pointer.add]; omega, Fits.add_of_le hov224 (by simp) hself⟩
  have hp392 : S.mem.PtFit (self.add 392#64) :=
    ⟨by
      simp [Pointer.add]; omega, Fits.add_of_le hov392 (by simp) hself⟩
  have hcAP := MemoryState.PtFit.of_fits hcA_fits hcA_off
  have hp2P := MemoryState.PtFit.of_fits hp2_fits hp2_off
  have hcRP := MemoryState.PtFit.of_fits hcR_fits hcR_off
  have hchkP := MemoryState.PtFit.of_fits hchk_fits hchk_off
  clear hcA_fits hp2_fits hcR_fits hchk_fits
  step_pure
  step_call using scalar_mul8.call_eq consuming hf560
  step_pure
  step_call using Edwards25519_clearCofactor.call_eq_of consuming hp224
  have hcAd : S.mem.readPt cA = Edwards25519.clearCofactor.spec A := by
    have h := hcAP; rw [hS] at h ⊢
    exact (MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).1
  have hp2cA : p2.id ≠ cA.id := by
    rw [hp2, hcA]; exact GlobalState.slot_id_ne (by decide)
  have hcx := ((clearCofactor_lt A).1).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have hct := ((clearCofactor_lt A).2.2.2).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Edwards25519_neg.call_eq_of consuming hcAd hcx hct hp2cA
  have hp2d : S.mem.readPt p2 = negA A ∧ (S.mem.readRest p2).extractLsb' 0 1 = 0#1 := by
    have h := hp2P; rw [hS] at h ⊢
    refine ⟨(MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).1, ?_⟩
    rw [(MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).2, flag_isBase]
  obtain ⟨hp2d, hp2b⟩ := hp2d
  have ne (i j : Nat) (h : i ≠ j) : (S₀.slot i).id ≠ (S₀.slot j).id := GlobalState.slot_id_ne h
  have hs8d : S.mem.readAt s8 256 = scalar.mul8.spec sb := by
    have h := hs8_fits; rw [hS] at h ⊢
    simp only [MemoryState.storePt, Fits.storeAt_iff] at h ⊢
    rw [MemoryState.readAt_storeAt_disjoint
        (.inl
          (show p2.id ≠ s8.id by
            rw [hp2, hs8]; exact ne 3 5 (by decide))),
      MemoryState.readAt_storeAt_disjoint
        (.inl
          (show cA.id ≠ s8.id by
            rw [hcA, hs8]; exact ne 4 5 (by decide))),
      MemoryState.readAt_storeAt_self h.storeAt, hsbX]
  have hhrd : S.mem.readAt hr 256 = reduce64 (digestBits M) := by
    have h := hhr_fits; rw [hS] at h ⊢
    simp only [MemoryState.storePt, Fits.storeAt_iff] at h ⊢
    rw [MemoryState.readAt_storeAt_disjoint
        (.inl
          (show p2.id ≠ hr.id by
            rw [hp2, hhr]; exact ne 3 6 (by decide))),
      MemoryState.readAt_storeAt_disjoint
        (.inl
          (show cA.id ≠ hr.id by
            rw [hcA, hhr]; exact ne 4 6 (by decide))),
      MemoryState.readAt_storeAt_disjoint
        (.inl
          (show s8.id ≠ hr.id by
            rw [hs8, hhr]; exact ne 5 6 (by decide))),
      MemoryState.readAt_storeAt_self h]
  clear ne
  have hm1 : (scalar.mul8.spec sb).msb = false :=
    msb_of_lt_ell
      (by
        rw [scalar.mul8.toNat_spec]; exact Nat.mod_lt _ (by decide))
  have hm2 : (reduce64 (digestBits M)).msb = false :=
    msb_of_lt_ell
      (by
        rw [reduce64, BitVec.toNat_ofNat]
        exact Nat.lt_of_le_of_lt (Nat.mod_le _ _) (Nat.mod_lt _ (by decide)))
  have hsao : sa.offset.toNat + 176 ≤ 2 ^ 64 := by simp [hsa_off]
  have hs8o : ¬s8.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hs8_off]
  have hhro : ¬hr.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hhr_off]
  have hnl := negA_lt A
  step_call using Edwards25519_mulDoubleBasePublic.call_eq_of consuming hs8d hm1 hp2d hnl hp2b hhrd
    hm2
  generalize hres :
    Edwards25519.mulDoubleBasePublic.spec (scalar.mul8.spec sb) 0#1 (negA A)
      (reduce64 (digestBits M)) =
    res at hS
  have hov168 : ¬sa.offset.uaddOverflow 168#64 := by simp [BitVec.uaddOverflow, hsa_off]
  have hf168 : Fits S.mem (sa.add 168#64) 16 := Fits.add_of_le hov168 (by decide) hsa_fits
  cases res with
  | none =>
    have hcode : S.mem.readAt (sa.add 168#64) 16 = 4#16 := by
      have h := hsa_fits; rw [hS] at h ⊢
      exact readAt_store_code (Fits.mdbpStore_iff.1 h) hsa_off none
    step_pure
    step_load with v hv
    fix_load v hv hcode
    step_pure
    finish_block
    block_init
    finish_block
    rw [hS]
    simp only [MemoryState.storePt]
    erase_frame
    have hsb' : sbAh M sb A = none := hres
    rw [code, blocks, hsb', hpa]
    simp only [codeOf, blocksOf]
    congr 4
    omega
  | some
    Q =>
    have hcode : S.mem.readAt (sa.add 168#64) 16 = 0#16 := by
      have h := hsa_fits; rw [hS] at h ⊢
      exact readAt_store_code (Fits.mdbpStore_iff.1 h) hsa_off (some Q)
    have hQl := mdbp_lt hres
    step_pure
    step_load with v hv
    fix_load v hv hcode
    step_pure
    finish_block
    block_init
    step_pure
    have hRS : S.mem.readPt (self.add 392#64) = R := by
      rw [hS]
      simp (disch :=
        (simp only [Pointer.add_id];
         exact Ne.symm (by assumption))) only [Edwards25519.mulDoubleBasePublic.store,
        MemoryState.storePt, MemoryState.readPt_storeAt_of_id_ne]
      exact hRdX
    step_call using Edwards25519_clearCofactor.call_eq_of consuming hp392 hRS hR₀
    have hcRd : S.mem.readPt cR = Edwards25519.clearCofactor.spec R := by
      have h := hcRP; rw [hS] at h ⊢
      exact (MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).1
    have hQd : S.mem.readPt sa = Q := by
      have hne : cR.id ≠ sa.id := by
        rw [hcR, hsa]; exact GlobalState.slot_id_ne (by decide)
      have h := hsa_fits; rw [hS] at h
      rw [hS, MemoryState.readPt_storeAt_of_id_ne hne]
      simp only [Edwards25519.mulDoubleBasePublic.store, MemoryState.storePt]
      have hf := (Fits.mdbpStore_iff.1 (Fits.storeAt_iff.mp h)).mono (show 1344 ≤ 1408 by decide)
      exact (MemoryState.readPt_storePt_self ⟨by simp [hsa_off], hf.storeAt⟩).1
    have hsaP := MemoryState.PtFit.of_fits (hsa_fits.mono (by decide)) hsa_off
    have hcl := ZPt.Lt.mono53 (clearCofactor_lt R)
    step_call using Edwards25519_sub.call_eq_of consuming hsaP hQd hcRd hQl hcl
    have hchkd : S.mem.readPt chk = check Q R := by
      have h := hchkP; rw [hS] at h ⊢
      exact (MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).1
    have hckl : (check Q R).Lt (2 ^ 52) := add_lt _ _
    step_call using Verifier_isIdentity.call_eq_of consuming hchkd hckl
    step_pure
    finish_block
    block_init
    finish_block
    rw [hS]
    simp only [MemoryState.storePt]
    erase_frame
    have hsb' : sbAh M sb A = some Q := hres
    rw [code, blocks, hsb', hpa]
    simp only [codeOf, blocksOf]
    congr 4
    omega

end Proof

end LeanMLIR.RIR.Zig

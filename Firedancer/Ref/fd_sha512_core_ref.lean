module

public import MLIR.Run.Tactic
public import Firedancer.Common.Memory
import Std.Data.ExtHashMap.Lemmas
public import Firedancer.Ref.fd_ulong_bswap
public import Firedancer.Ref.fd_ulong_rotate_right
public import Firedancer.Ref.Mlir.fd_sha512_core_ref
import Std.Tactic.BVDecide

namespace MLIR

/-! ## Staged for Common -/

@[expose] public section

/-- The eight 64-bit words at `p` (a SHA-512 state). Each word's pointer is spelled as
`getelementptr` produces it, so facts, steps and specs match syntactically. -/
def MemoryState.readWords8 (m : MemoryState) (p : Pointer) : Vector (BitVec 64) 8 :=
  #v[m.readAt p 64, m.readAt (p.add 8#64) 64, m.readAt (p.add 16#64) 64, m.readAt (p.add 24#64) 64,
    m.readAt (p.add 32#64) 64, m.readAt (p.add 40#64) 64, m.readAt (p.add 48#64) 64,
    m.readAt (p.add 56#64) 64]

/-- Store eight 64-bit words at `p`, lowest first, as the lifted code does. -/
def MemoryState.storeWords8 (m : MemoryState) (p : Pointer) (v : Vector (BitVec 64) 8) :
    MemoryState :=
  (((((((m.storeAt p v[0]).storeAt (p.add 8#64) v[1]).storeAt (p.add 16#64) v[2]).storeAt
                    (p.add 24#64) v[3]).storeAt
                (p.add 32#64) v[4]).storeAt
            (p.add 40#64) v[5]).storeAt
        (p.add 48#64) v[6]).storeAt
    (p.add 56#64) v[7]

/-- Each of the eight words at `p` fits in `m`, and the word offsets do not wrap. -/
abbrev MemoryState.Words8Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 56 < 2 ^ 64 ∧
    Fits m p 64 ∧
    Fits m (p.add 8#64) 64 ∧
    Fits m (p.add 16#64) 64 ∧
    Fits m (p.add 24#64) 64 ∧
    Fits m (p.add 32#64) 64 ∧
    Fits m (p.add 40#64) 64 ∧ Fits m (p.add 48#64) 64 ∧ Fits m (p.add 56#64) 64

/-- Room for the eight words at `p` (an output), and the word offsets do not wrap. -/
abbrev MemoryState.Words8Room (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 56 < 2 ^ 64 ∧
    Room m p 64 ∧
    Room m (p.add 8#64) 64 ∧
    Room m (p.add 16#64) 64 ∧
    Room m (p.add 24#64) 64 ∧
    Room m (p.add 32#64) 64 ∧
    Room m (p.add 40#64) 64 ∧ Room m (p.add 48#64) 64 ∧ Room m (p.add 56#64) 64

attribute [mlir_mem] MemoryState.Words8Fit MemoryState.Words8Room

theorem MemoryState.Words8Fit.room {m : MemoryState} (h : m.Words8Fit p) : m.Words8Room p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.1.room, h.2.2.2.2.1.room, h.2.2.2.2.2.1.room,
    h.2.2.2.2.2.2.1.room, h.2.2.2.2.2.2.2.1.room, h.2.2.2.2.2.2.2.2.room⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.storeAt (h : MemoryState.Words8Fit m p) :
    MemoryState.Words8Fit (m.storeAt q x) p :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt,
    h.2.2.2.2.2.1.storeAt, h.2.2.2.2.2.2.1.storeAt, h.2.2.2.2.2.2.2.1.storeAt,
    h.2.2.2.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.storeAt (h : MemoryState.Words8Room m p) :
    MemoryState.Words8Room (m.storeAt q x) p := by
  unfold MemoryState.Words8Room at h ⊢
  simpa using h

/-- A new block keeps words that fit. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Words8Fit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Words8Fit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.addBlock hwf, h1.addBlock hwf, h2.addBlock hwf, h3.addBlock hwf, h4.addBlock hwf,
      h5.addBlock hwf, h6.addBlock hwf, h7.addBlock hwf⟩

/-- A new block keeps room for words. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Words8Room p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Words8Room p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.addBlock hwf, h1.addBlock hwf, h2.addBlock hwf, h3.addBlock hwf, h4.addBlock hwf,
      h5.addBlock hwf, h6.addBlock hwf, h7.addBlock hwf⟩

/-- `alloca` keeps words that fit. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.Words8Fit p) :
    (s.alloca n d).mem.Words8Fit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.alloca hwf, h1.alloca hwf, h2.alloca hwf, h3.alloca hwf, h4.alloca hwf, h5.alloca hwf,
      h6.alloca hwf, h7.alloca hwf⟩

/-- `alloca` keeps room for words. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.Words8Room p) :
    (s.alloca n d).mem.Words8Room p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.alloca hwf, h1.alloca hwf, h2.alloca hwf, h3.alloca hwf, h4.alloca hwf, h5.alloca hwf,
      h6.alloca hwf, h7.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Words8Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Words8Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.lifetimeStart hne, h1.lifetimeStart (hne' _), h2.lifetimeStart (hne' _),
      h3.lifetimeStart (hne' _), h4.lifetimeStart (hne' _), h5.lifetimeStart (hne' _),
      h6.lifetimeStart (hne' _), h7.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Words8Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Words8Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.lifetimeEnd hne, h1.lifetimeEnd (hne' _), h2.lifetimeEnd (hne' _),
      h3.lifetimeEnd (hne' _), h4.lifetimeEnd (hne' _), h5.lifetimeEnd (hne' _),
      h6.lifetimeEnd (hne' _), h7.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Words8Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Words8Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.lifetimeStart hne, h1.lifetimeStart (hne' _), h2.lifetimeStart (hne' _),
      h3.lifetimeStart (hne' _), h4.lifetimeStart (hne' _), h5.lifetimeStart (hne' _),
      h6.lifetimeStart (hne' _), h7.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Words8Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Words8Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, h0.lifetimeEnd hne, h1.lifetimeEnd (hne' _), h2.lifetimeEnd (hne' _),
      h3.lifetimeEnd (hne' _), h4.lifetimeEnd (hne' _), h5.lifetimeEnd (hne' _),
      h6.lifetimeEnd (hne' _), h7.lifetimeEnd (hne' _)⟩

/-- `storeWords8` keeps every block, its length and lifetime. -/
@[simp]
theorem Room.storeWords8_iff {m : MemoryState} : Room (m.storeWords8 q v) p w ↔ Room m p w := by
  simp [MemoryState.storeWords8]

/-- `storeWords8` keeps known bits known. -/
@[mlir_transport]
theorem Fits.storeWords8 {m : MemoryState} (h : Fits m p w) : Fits (m.storeWords8 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem Room.storeWords8 {m : MemoryState} (h : Room m p w) : Room (m.storeWords8 q v) p w :=
  Room.storeWords8_iff.2 h

@[mlir_transport]
theorem InBounds.storeWords8 {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeWords8 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem MemoryState.Words8Fit.storeWords8 (h : MemoryState.Words8Fit m p) :
    MemoryState.Words8Fit (m.storeWords8 q v) p :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem MemoryState.Words8Room.storeWords8 (h : MemoryState.Words8Room m p) :
    MemoryState.Words8Room (m.storeWords8 q v) p :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

/-- Eight words stored where there is room are known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.Words8Fit.storeWords8_self {m : MemoryState} {p : Pointer}
    (h : m.Words8Room p) : (m.storeWords8 p v).Words8Fit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact
    ⟨ho, (Fits.storeAt_self h0).storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h1.storeAt).storeAt.storeAt.storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h2.storeAt.storeAt).storeAt.storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h3.storeAt.storeAt.storeAt).storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h4.storeAt.storeAt.storeAt.storeAt).storeAt.storeAt.storeAt,
      (Fits.storeAt_self h5.storeAt.storeAt.storeAt.storeAt.storeAt).storeAt.storeAt,
      (Fits.storeAt_self h6.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt).storeAt,
      Fits.storeAt_self h7.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt⟩

@[mlir_transport]
theorem GlobalState.WF.storeWords8 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeWords8 p v } : GlobalState).WF := by
  unfold MemoryState.storeWords8
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

open Memory in
/-- Storing eight words twice at the same place keeps the second. -/
theorem MemoryState.storeWords8_storeWords8_self {m : MemoryState} {p : Pointer} :
    (m.storeWords8 p v).storeWords8 p v' = m.storeWords8 p v' := by
  simp only [MemoryState.storeWords8, MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits, MemoryBlock.mk.injEq, true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits] <;>
    grind

/-- Erasing a frame commutes with storing eight words. -/
theorem MemoryState.eraseFrom_storeWords8 {m : MemoryState} :
    (m.storeWords8 p v).eraseFrom n = (m.eraseFrom n).storeWords8 p v := by
  simp [MemoryState.storeWords8, MemoryState.eraseFrom_storeAt]

/-- A read outside the eight words is unaffected by `storeWords8`. -/
theorem MemoryState.readAt_storeWords8_of_disjoint {m : MemoryState}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (h : (Range.of p 512).Disjoint (Range.of q w)) :
    (m.storeWords8 p v).readAt q w = m.readAt q w := by
  have hw :
    ∀ k : Nat, k ≤ 56 → (Range.of (p.add (BitVec.ofNat 64 k)) 64).Disjoint (Range.of q w) := by
    intro k hk
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at h ⊢
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    rcases h with h | h
    · exact Or.inl h
    · right; omega
  have h0 : (Range.of p 64).Disjoint (Range.of q w) := by simpa using hw 0 (by decide)
  unfold MemoryState.storeWords8
  rw [MemoryState.readAt_storeAt_disjoint (hw 56 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 48 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 40 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 32 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 24 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 16 (by decide)),
    MemoryState.readAt_storeAt_disjoint (hw 8 (by decide)), MemoryState.readAt_storeAt_disjoint h0]

-- last among the transports, as `LimbsFit.room`
attribute [mlir_transport] MemoryState.Words8Fit.room

end

end MLIR

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

namespace fd_sha512_core_ref

/-- `K`, the 80 round constants. -/
def K : Vector (BitVec 64) 80 :=
  #v[0x428a2f98d728ae22#64, 0x7137449123ef65cd#64, 0xb5c0fbcfec4d3b2f#64, 0xe9b5dba58189dbbc#64,
    0x3956c25bf348b538#64, 0x59f111f1b605d019#64, 0x923f82a4af194f9b#64, 0xab1c5ed5da6d8118#64,
    0xd807aa98a3030242#64, 0x12835b0145706fbe#64, 0x243185be4ee4b28c#64, 0x550c7dc3d5ffb4e2#64,
    0x72be5d74f27b896f#64, 0x80deb1fe3b1696b1#64, 0x9bdc06a725c71235#64, 0xc19bf174cf692694#64,
    0xe49b69c19ef14ad2#64, 0xefbe4786384f25e3#64, 0x0fc19dc68b8cd5b5#64, 0x240ca1cc77ac9c65#64,
    0x2de92c6f592b0275#64, 0x4a7484aa6ea6e483#64, 0x5cb0a9dcbd41fbd4#64, 0x76f988da831153b5#64,
    0x983e5152ee66dfab#64, 0xa831c66d2db43210#64, 0xb00327c898fb213f#64, 0xbf597fc7beef0ee4#64,
    0xc6e00bf33da88fc2#64, 0xd5a79147930aa725#64, 0x06ca6351e003826f#64, 0x142929670a0e6e70#64,
    0x27b70a8546d22ffc#64, 0x2e1b21385c26c926#64, 0x4d2c6dfc5ac42aed#64, 0x53380d139d95b3df#64,
    0x650a73548baf63de#64, 0x766a0abb3c77b2a8#64, 0x81c2c92e47edaee6#64, 0x92722c851482353b#64,
    0xa2bfe8a14cf10364#64, 0xa81a664bbc423001#64, 0xc24b8b70d0f89791#64, 0xc76c51a30654be30#64,
    0xd192e819d6ef5218#64, 0xd69906245565a910#64, 0xf40e35855771202a#64, 0x106aa07032bbd1b8#64,
    0x19a4c116b8d2d0c8#64, 0x1e376c085141ab53#64, 0x2748774cdf8eeb99#64, 0x34b0bcb5e19b48a8#64,
    0x391c0cb3c5c95a63#64, 0x4ed8aa4ae3418acb#64, 0x5b9cca4f7763e373#64, 0x682e6ff3d6b2b8a3#64,
    0x748f82ee5defb2fc#64, 0x78a5636f43172f60#64, 0x84c87814a1f0ab72#64, 0x8cc702081a6439ec#64,
    0x90befffa23631e28#64, 0xa4506cebde82bde9#64, 0xbef9a3f7b2c67915#64, 0xc67178f2e372532b#64,
    0xca273eceea26619c#64, 0xd186b8c721c0c207#64, 0xeada7dd6cde0eb1e#64, 0xf57d4f7fee6ed178#64,
    0x06f067aa72176fba#64, 0x0a637dc5a2c898a6#64, 0x113f9804bef90dae#64, 0x1b710b35131c471b#64,
    0x28db77f523047d84#64, 0x32caab7b40c72493#64, 0x3c9ebe0a15c9bebc#64, 0x431d67c49c100d4c#64,
    0x4cc5d4becb3e42b6#64, 0x597f299cfc657e2a#64, 0x5fcb6fab3ad6faec#64, 0x6c44198c4a475817#64]

/-- `ROTR`, `fd_ulong_rotate_right`. -/
abbrev ROTR (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  fd_ulong_rotate_right.spec x n

def Sigma0 (x : BitVec 64) : BitVec 64 :=
  ROTR x 28#32 ^^^ ROTR x 34#32 ^^^ ROTR x 39#32

def Sigma1 (x : BitVec 64) : BitVec 64 :=
  ROTR x 14#32 ^^^ ROTR x 18#32 ^^^ ROTR x 41#32

def sigma0 (x : BitVec 64) : BitVec 64 :=
  ROTR x 1#32 ^^^ ROTR x 8#32 ^^^ x >>> 7

def sigma1 (x : BitVec 64) : BitVec 64 :=
  ROTR x 19#32 ^^^ ROTR x 61#32 ^^^ x >>> 6

def Ch (x y z : BitVec 64) : BitVec 64 :=
  x &&& y ^^^ ~~~x &&& z

def Maj (x y z : BitVec 64) : BitVec 64 :=
  x &&& y ^^^ x &&& z ^^^ y &&& z

/-- One round on the working variables `a … h` (`v[0] … v[7]`), with `X[i] = x` and `K[i] = k`. -/
def round (v : Vector (BitVec 64) 8) (x k : BitVec 64) : Vector (BitVec 64) 8 :=
  let a := v[0]
  let b := v[1]
  let c := v[2]
  let d := v[3]
  let e := v[4]
  let f := v[5]
  let g := v[6]
  let h := v[7]
  let T1 := x + h + Sigma1 e + Ch e f g + k
  let T2 := Sigma0 a + Maj a b c
  #v[T1 + T2, a, b, c, d + T1, e, f, g]

/-- `X` after the first loop: `X[i] = fd_ulong_bswap( W[i] )`, `W[i]` the block's `i`-th 64-bit
word as loaded (little-endian). -/
def X0 (block : BitVec 1024) : Vector (BitVec 64) 16 :=
  Vector.ofFn fun i => fd_ulong_bswap.spec (block.extractLsb' (64 * i.val) 64)

/-- `for( i=0UL; i<16UL; i++ )` from `i`: the rounds on `X[i] = fd_ulong_bswap( W[i] )`. -/
def loop1 (block : BitVec 1024) (i : Nat) (v : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  if h : i < 16 then
    let x := fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)
    loop1 block (i + 1) (round v x K[i])
  else v
termination_by 16 - i

/-- The new `X[i & 0xf]`: `X[i & 0xf] += s0 + s1 + X[(i + 9) & 0xf]`. -/
def xNext (X : Vector (BitVec 64) 16) (i : Nat) : BitVec 64 :=
  let s0 := sigma0 X[(i + 1) % 16]
  let s1 := sigma1 X[(i + 14) % 16]
  X[i % 16] + (s0 + s1 + X[(i + 9) % 16])

/-- `for( ; i<80UL; i++ )` from `i`: the message schedule's next word into `X[i & 0xf]`, then
the round on it. -/
def loop2 (i : Nat) (v : Vector (BitVec 64) 8) (X : Vector (BitVec 64) 16) : Vector (BitVec 64) 8 :=
  if h : i < 80 then
    let x := xNext X i
    loop2 (i + 1) (round v x K[i]) (X.set (i % 16) x)
  else v
termination_by 80 - i

/-- `state[0] += a; … state[7] += h;`. -/
def addWords (state v : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  #v[state[0] + v[0], state[1] + v[1], state[2] + v[2], state[3] + v[3], state[4] + v[4],
    state[5] + v[5], state[6] + v[6], state[7] + v[7]]

/-- One block: the 80 rounds from `state`, then `state[k] += …`. -/
def compress (state : Vector (BitVec 64) 8) (block : BitVec 1024) : Vector (BitVec 64) 8 :=
  addWords state (loop2 16 (loop1 block 0 state) (X0 block))

/-- The blocks `j, j + 1, …` of `data`, `n` of them, compressed into `state` in order
(`W += 16UL*sizeof(ulong)`). -/
def compressFrom (data : BitVec w) : (j n : Nat) → Vector (BitVec 64) 8 → Vector (BitVec 64) 8
  | _, 0, state => state
  | j, n + 1, state =>
    compressFrom data (j + 1) n (compress state (data.extractLsb' (1024 * j) 1024))

end fd_sha512_core_ref

/-- The state after compressing the `n` 128-byte blocks of `data` into `state`. -/
def fd_sha512_core_ref.spec (state : Vector (BitVec 64) 8) {n : Nat} (data : BitVec (1024 * n)) :
    Vector (BitVec 64) 8 :=
  fd_sha512_core_ref.compressFrom data 0 n state

end

/-! ## Proof -/

section Proof

namespace fd_sha512_core_ref

/-! ### The code's forms of the spec's operations -/

theorem Sigma0_eq (x : BitVec 64) : ROTR x 34#32 ^^^ ROTR x 28#32 ^^^ ROTR x 39#32 = Sigma0 x := by
  rw [Sigma0, BitVec.xor_comm (ROTR x 34#32)]

theorem Sigma1_eq (x : BitVec 64) : ROTR x 18#32 ^^^ ROTR x 14#32 ^^^ ROTR x 41#32 = Sigma1 x := by
  rw [Sigma1, BitVec.xor_comm (ROTR x 18#32)]

theorem sigma0_eq (x : BitVec 64) : ROTR x 1#32 ^^^ x >>> 7 ^^^ ROTR x 8#32 = sigma0 x := by
  rw [sigma0]; ac_rfl

theorem sigma1_eq (x : BitVec 64) : ROTR x 19#32 ^^^ x >>> 6 ^^^ ROTR x 61#32 = sigma1 x := by
  rw [sigma1]; ac_rfl

theorem Ch_eq (x y z : BitVec 64) :
    x &&& y ||| z &&& (x ^^^ 18446744073709551615#64) = Ch x y z := by
  rw [Ch]; bv_decide

/-- `Ch`'s `or disjoint` holds: `x & y` and `~x & z` do not overlap. -/
theorem Ch_disjoint (x y z : BitVec 64) :
    x &&& y &&& (z &&& (x ^^^ 18446744073709551615#64)) = 0#64 := by bv_decide

theorem Maj_eq (x y z : BitVec 64) : x &&& (y ^^^ z) ^^^ y &&& z = Maj x y z := by
  rw [Maj]; bv_decide

theorem T1_eq (x h e f g k : BitVec 64) :
    Ch e f g + h + x + Sigma1 e + k = x + h + Sigma1 e + Ch e f g + k := by ac_rfl

theorem e_eq (x h e f g k d : BitVec 64) :
    x + h + Sigma1 e + Ch e f g + k + d = d + (x + h + Sigma1 e + Ch e f g + k) := by ac_rfl

theorem a_eq (t a b c : BitVec 64) : t + Maj a b c + Sigma0 a = t + (Sigma0 a + Maj a b c) := by
  ac_rfl

theorem xNext_eq (x0 x1 x9 x14 : BitVec 64) :
    x9 + sigma0 x1 + sigma1 x14 + x0 = x0 + (sigma0 x1 + sigma1 x14 + x9) := by ac_rfl

/-! ### Offsets -/

theorem saddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 k) = false := by
  have hi : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 64 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

theorem uaddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow (BitVec.ofNat 64 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

theorem eq_of_ofNat_eq {m n : Nat} (h : BitVec.ofNat 64 m = BitVec.ofNat 64 n) (hm : m < 2 ^ 64)
    (hn : n < 2 ^ 64) : m = n := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  omega

/-- `m & 0xf`, the slot of `X` round `m` uses: `m % 16`. -/
theorem and_15 (m : Nat) : BitVec.ofNat 64 m &&& 15#64 = BitVec.ofNat 64 (m % 16) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (15#64).toNat = 2 ^ 4 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

theorem mod16_mod (m : Nat) : m % 16 % 18446744073709551616 = m % 16 :=
  Nat.mod_eq_of_lt (by omega)

theorem mod16_mul8_lt (m : Nat) : m % 16 * 8 < 18446744073709551616 := by omega

/-- `getelementptr` to slot `m % 16` of `X`. -/
theorem gep_slot {X : Pointer} (hX : X.offset = 0) (m : Nat) :
    Operation.gep (.value (BitVec.ofNat 64 (m % 16 * 8))) (.value X) =
      .value (X.add (BitVec.ofNat 64 (m % 16 * 8))) := by
  rw [gep_value]
  simp [BitVec.uaddOverflow, hX]
  omega

/-- `getelementptr` by `8 * i` from a block's start. -/
theorem gep_of_offset_zero {p : Pointer} (hp : p.offset = 0) (i : Nat) :
    Operation.gep (.value (BitVec.ofNat 64 (i * 8))) (.value p) =
      .value (p.add (BitVec.ofNat 64 (i * 8))) := by
  rw [gep_value]
  simp [BitVec.uaddOverflow, hp]
  omega

/-- `i << 3`, `W`'s byte offset of word `i`: `i * 8`. -/
theorem ofNat_shiftLeft_3 (i : Nat) : BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (i * 8) := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]

/-- `i << 3`'s `nuw` holds: no bit is shifted out. -/
theorem ofNat_mul8_ushiftRight_3 {i : Nat} (h : i < 16) :
    BitVec.ofNat 64 (i * 8) >>> 3 = BitVec.ofNat 64 i := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

/-- `i << 3`'s `nsw` holds: the result's sign is clear. -/
theorem ofNat_mul8_sshiftRight_3 {i : Nat} (h : i < 16) :
    (BitVec.ofNat 64 (i * 8)).sshiftRight 3 = BitVec.ofNat 64 i := by
  rw [BitVec.sshiftRight_eq_of_msb_false
      (by
        simp [BitVec.msb_eq_decide]; omega),
    ← BitVec.ushiftRight_eq]
  exact ofNat_mul8_ushiftRight_3 h

/-- Slot `m % 16` of `X` fits. -/
theorem fits_slot {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (h : Fits m X 1024)
    (k : Nat) : Fits m (X.add (BitVec.ofNat 64 (k % 16 * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, hX]; omega)
    (by
      simp; omega)
    h

/-- `K[i]` fits. -/
theorem fits_K {m : MemoryState} {Kp : Pointer} (hK : Kp.offset = 0) (h : Fits m Kp 5120) {i : Nat}
    (hi : i < 80) : Fits m (Kp.add (BitVec.ofNat 64 (i * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, hK]; omega)
    (by
      simp; omega)
    h

/-! ### The blocks' envs -/

/-- `^bb0`'s constants, which every later block reads. -/
abbrev consts (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%868 := .value 1#32, %869 := .value 16#64, %870 := .value 0#64, %871 := .value 3#64, %872 :=
    .value 14#32, %873 := .value 18#32, %874 := .value 41#32, %875 :=
    .value 18446744073709551615#64, %877 := .value 28#32, %878 := .value 34#32, %879 :=
    .value 39#32, %880 := .value 1#64, %881 := .value 15#64, %882 := .value 14#64, %883 :=
    .value 8#32, %884 := .value 7#64, %885 := .value 19#32, %886 := .value 61#32, %887 :=
    .value 6#64, %888 := .value 9#64, %889 := .value 80#64]

/-- `^bb1`, a block's start: the constants, `K`, `X`, `&state[1 … 7]`, the state words
`h0 … h7` (also `a … h`), `W` and the blocks left. -/
abbrev hdr1 (st X Kp Wp : Pointer) (h0 h1 h2 h3 h4 h5 h6 h7 cnt : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (consts E)[%876 := .value Kp, %890 := .value X, %891 := .value (st.add 8#64), %892 :=
    .value (st.add 16#64), %893 := .value (st.add 24#64), %894 := .value (st.add 32#64), %895 :=
    .value (st.add 40#64), %896 := .value (st.add 48#64), %897 := .value (st.add 56#64), %906 :=
    .value h7, %907 := .value h6, %908 := .value h5, %909 := .value h4, %910 := .value h3, %911 :=
    .value h2, %912 := .value h1, %913 := .value h0, %914 := .value Wp, %915 := .value cnt]

/-- `hdr1` with the state words `H`. -/
abbrev hdr1v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  hdr1 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E

/-- `T1`, as the code computes it: `X[i] + h + Sigma1(e) + Ch(e, f, g) + K[i]`. -/
abbrev T1 (x h e f g k : BitVec 64) : BitVec 64 :=
  x + h + Sigma1 e + Ch e f g + k

/-- `T2 = Sigma0(a) + Maj(a, b, c)`. -/
abbrev T2 (a b c : BitVec 64) : BitVec 64 :=
  Sigma0 a + Maj a b c

/-- The new `X[i & 0xf]` from the old one `x0` and `X[(i + 1, 9, 14) & 0xf]`. -/
abbrev xNew (x0 x1 x9 x14 : BitVec 64) : BitVec 64 :=
  x0 + (sigma0 x1 + sigma1 x14 + x9)

/-- `^bb2`, the first loop at round `i`, on `a … h`. -/
abbrev hdr2 (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) (i : Nat) : ⟪Γ⟫ :=
  (hdr1v st X Kp Wp H cnt E)[%916 := .value a, %917 := .value b, %918 := .value c, %919 := .value d,
    %920 := .value e, %921 := .value f, %922 := .value (BitVec.ofNat 64 i), %923 := .value h,
    %924 := .value g]

/-- `^bb3`, the second loop at round `i`, on `a … h`. -/
abbrev hdr3 (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) (i : Nat) : ⟪Γ⟫ :=
  (hdr1v st X Kp Wp H cnt E)[%959 := .value a, %960 := .value b, %961 := .value c, %962 := .value d,
    %963 := .value e, %964 := .value f, %965 := .value (BitVec.ofNat 64 i), %966 := .value h,
    %967 := .value g]

/-- `^bb4`, after the last round, with `a … h`. -/
abbrev exit3 (st X Kp Wp : Pointer) (h0 h1 h2 h3 h4 h5 h6 h7 cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) : ⟪Γ⟫ :=
  (hdr1 st X Kp Wp h0 h1 h2 h3 h4 h5 h6 h7 cnt E)[%959 := .value b, %960 := .value c, %961 :=
    .value d, %963 := .value f, %964 := .value g, %967 := .value h, %1020 := .value e, %1022 :=
    .value a]

/-- `hdr2` on `a … h = v`. -/
abbrev hdr2v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) (i : Nat) : ⟪Γ⟫ :=
  hdr2 st X Kp Wp H cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] i

/-- `hdr3` on `a … h = v`. -/
abbrev hdr3v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) (i : Nat) : ⟪Γ⟫ :=
  hdr3 st X Kp Wp H cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] i

/-- `exit3` on `a … h = v`. -/
abbrev exit3v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) : ⟪Γ⟫ :=
  exit3 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6]
    v[7]

theorem loop1_lt {block : BitVec 1024} {v : Vector (BitVec 64) 8} (h : i < 16) :
    loop1 block i v =
      loop1 block (i + 1) (round v (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)) K[i]) := by
  rw [loop1]
  simp only [h, ↓reduceDIte]

theorem loop1_16 {block : BitVec 1024} {v : Vector (BitVec 64) 8} : loop1 block 16 v = v := by
  rw [loop1]
  simp

theorem loop2_lt {v : Vector (BitVec 64) 8} {Xv : Vector (BitVec 64) 16} (h : i < 80) :
    loop2 i v Xv = loop2 (i + 1) (round v (xNext Xv i) K[i]) (Xv.set (i % 16) (xNext Xv i)) := by
  rw [loop2]
  simp only [h, ↓reduceDIte]

theorem loop2_80 {v : Vector (BitVec 64) 8} {Xv : Vector (BitVec 64) 16} : loop2 80 v Xv = v := by
  rw [loop2]
  simp

/-! ### Memory: `K`, `W`, the slots of `X` -/

/-- `K[i]` read from the global's block. -/
theorem readAt_K {m : MemoryState} {Kp : Pointer} {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hf : Fits m Kp 5120) (ho : Kp.offset = 0)
    (h : m.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw)) {i : Nat}
    (hi : i < 80) : m.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = K[i] := by
  have hs : (Ty.bv 64).stride = 64 := rfl
  have hK : fd_sha512_core_ref_K.lit = K := by decide
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    Ty.flatBits_eq, BitVec.extractLsb'_cast,
    show (BitVec.ofNat 64 (i * 8)).toNat * 8 = i * 64 by
      simp; omega,
    Ty.extractLsb'_flattenRaw_array _
      (by
        rw [hs]; omega)
      (by
        rw [hs, Nat.mul_mod_left]; decide)]
  simp only [hs, Nat.mul_mod_left, Nat.mul_div_cancel _ (by decide : 0 < 64),
    Ty.extractLsb'_flattenRaw_bv, hK, BitVec.extractLsb'_eq_self]

/-- Word `i` of a block, read where the block was read whole. -/
theorem readAt_word {m : MemoryState} {Wp : Pointer} (hf : Fits m Wp 1024)
    (ho : Wp.offset.toNat + 128 < 2 ^ 64) {block : BitVec 1024} (h : m.readAt Wp 1024 = block)
    {i : Nat} (hi : i < 16) :
    m.readAt (Wp.add (BitVec.ofNat 64 (i * 8))) 64 = block.extractLsb' (64 * i) 64 := by
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h]
  congr 1
  simp
  omega

/-- The slot `k` of `X`. -/
abbrev slot (X : Pointer) (k : Nat) : Pointer :=
  X.add (BitVec.ofNat 64 (k * 8))

/-- `X` holds the words `Xv`. -/
abbrev HoldsX (m : MemoryState) (X : Pointer) (Xv : Vector (BitVec 64) 16) : Prop :=
  ∀ k (hk : k < 16), m.readAt (slot X k) 64 = Xv[k]

theorem slot_offsetInBits {X : Pointer} (hX : X.offset = 0) {k : Nat} (hk : k < 16) :
    (slot X k).offsetInBits = 64 * k := by
  simp [slot, Pointer.offsetInBits, Pointer.add, hX]
  omega

theorem readAt_slot_storeAt_self {m : MemoryState} {X : Pointer} (hX : X.offset = 0)
    (hf : InBounds m X 1024) {k : Nat} (hk : k < 16) (x : BitVec 64) :
    (m.storeAt (slot X k) x).readAt (slot X k) 64 = x :=
  MemoryState.readAt_storeAt_self
    (InBounds.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hf)
    x

theorem readAt_slot_storeAt_ne {m : MemoryState} {X : Pointer} (hX : X.offset = 0) {j k : Nat}
    (hj : j < 16) (hk : k < 16) (hjk : j ≠ k) (x : BitVec 64) :
    (m.storeAt (slot X j) x).readAt (slot X k) 64 = m.readAt (slot X k) 64 := by
  apply MemoryState.readAt_storeAt_disjoint
  simp only [Range.Disjoint, Range.of, slot_offsetInBits hX hj, slot_offsetInBits hX hk]
  omega

/-- A store into slot `j` sets word `j`. -/
theorem HoldsX.store {m : MemoryState} {X : Pointer} {Xv : Vector (BitVec 64) 16}
    (hX : X.offset = 0) (hf : Fits m X 1024) (h : HoldsX m X Xv) {j : Nat} (hj : j < 16)
    (x : BitVec 64) : HoldsX (m.storeAt (slot X j) x) X (Xv.set j x) := by
  intro k hk
  by_cases hjk : j = k
  · subst hjk
    rw [readAt_slot_storeAt_self hX hf.inBounds hj, Vector.getElem_set_self]
  · rw [readAt_slot_storeAt_ne hX hj hk hjk, h k hk, Vector.getElem_set_ne _ _ hjk]

/-- The memory after the first loop's rounds `i … i + n - 1` stored
`X[i] = fd_ulong_bswap( W[i] )`. -/
def mem1 (X : Pointer) (block : BitVec 1024) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m =>
    mem1 X block (i + 1) n
      (m.storeAt (slot X i) (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)))

/-- The memory after the second loop's rounds `i … i + n - 1` stored their new `X[i & 0xf]`, from
`X = Xv`. -/
def mem2 (X : Pointer) : (i n : Nat) → Vector (BitVec 64) 16 → MemoryState → MemoryState
  | _, 0, _, m => m
  | i, n + 1, Xv, m =>
    mem2 X (i + 1) n (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide)))
      (m.storeAt (slot X (i % 16)) (xNext Xv i))

theorem room_mem1 {m : MemoryState} : Room (mem1 X block i n m) p w ↔ Room m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [mem1, ih]

theorem room_mem2 {m : MemoryState} : Room (mem2 X i n Xv m) p w ↔ Room m p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih => simp [mem2, ih]

theorem inBounds_mem1 {m : MemoryState} : InBounds (mem1 X block i n m) p w ↔ InBounds m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [mem1, ih]

theorem inBounds_mem2 {m : MemoryState} : InBounds (mem2 X i n Xv m) p w ↔ InBounds m p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih => simp [mem2, ih]

theorem Fits.mem1 {m : MemoryState} (h : Fits m p w) : Fits (mem1 X block i n m) p w := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Fits.mem2 {m : MemoryState} (h : Fits m p w) : Fits (mem2 X i n Xv m) p w := by
  induction n generalizing i Xv m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Room.mem1 {m : MemoryState} (h : Room m p w) : Room (mem1 X block i n m) p w :=
  room_mem1.2 h

theorem Room.mem2 {m : MemoryState} (h : Room m p w) : Room (mem2 X i n Xv m) p w :=
  room_mem2.2 h

theorem InBounds.mem1 {m : MemoryState} (h : InBounds m p w) : InBounds (mem1 X block i n m) p w :=
  inBounds_mem1.2 h

theorem InBounds.mem2 {m : MemoryState} (h : InBounds m p w) : InBounds (mem2 X i n Xv m) p w :=
  inBounds_mem2.2 h

theorem Words8Fit.mem1 {m : MemoryState} (h : m.Words8Fit p) :
    (mem1 X block i n m).Words8Fit p := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Words8Fit.mem2 {m : MemoryState} (h : m.Words8Fit p) : (mem2 X i n Xv m).Words8Fit p := by
  induction n generalizing i Xv m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

/-- The first loop's stores from `X[i]` on into room for them: those words are known. -/
theorem fits_slot_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) {k : Nat} (hk : k < 16)
    (hik : i ≤ k) (hkn : k < i + n) (h : Room m X 1024) :
    Fits (mem1 X block i n m) (slot X k) 64 := by
  induction n generalizing i m with
  | zero => omega
  | succ n ih =>
    rw [mem1]
    by_cases hki : k = i
    · subst hki
      have hr : Room m (slot X k) 64 :=
        Room.add_of_le
          (by
            simp [BitVec.uaddOverflow, hX]; omega)
          (by
            simp; omega)
          h
      exact Fits.mem1 (Fits.storeAt_self hr)
    · exact ih (by omega) (by omega) h.storeAt

/-- After the first loop into room for `X`, all of `X` is known. -/
theorem fits_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (h : Room m X 1024) :
    Fits (mem1 X block 0 16 m) X 1024 := by
  have hs (k : Nat) (hk : k < 16) :=
    fits_slot_mem1 (block := block) (i := 0) (n := 16) hX hk (by omega) (by omega) h
  have hov (k : Nat) (hk : k < 16) : ¬X.offset.uaddOverflow (BitVec.ofNat 64 (k * 8)) := by
    simp [BitVec.uaddOverflow, hX]; omega
  have key : ∀ j, 0 < j → j ≤ 16 → Fits (mem1 X block 0 16 m) X (64 * j) := by
    intro j
    induction j with
    | zero =>
      intro h0; omega
    | succ j ih =>
      intro _ hj
      rcases Nat.eq_zero_or_pos j with rfl | hj0
      · simpa [slot, Pointer.add] using hs 0 (by omega)
      · exact
          Fits.append (hov j (by omega))
            (by
              simp; omega)
            (by omega) (ih hj0 (by omega)) (hs j (by omega))
  exact key 16 (by omega) (Nat.le_refl _)

/-- Reads outside `X`'s block are unaffected by `mem1`. -/
theorem readAt_mem1 {m : MemoryState} (h : p.id ≠ X.id) :
    (mem1 X block i n m).readAt p w = m.readAt p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih =>
    rw [mem1, ih,
      MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne h.symm)]

theorem readAt_mem2 {m : MemoryState} (h : p.id ≠ X.id) :
    (mem2 X i n Xv m).readAt p w = m.readAt p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih =>
    rw [mem2, ih,
      MemoryState.readAt_storeAt_disjoint (p := slot X (i % 16)) (Range.disjoint_of_id_ne h.symm)]

theorem WF_mem1 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem1 X block i n s.mem } : GlobalState).WF := by
  induction n generalizing i s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

theorem WF_mem2 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem2 X i n Xv s.mem } : GlobalState).WF := by
  induction n generalizing i Xv s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

attribute [local mlir_transport] Fits.mem1 Fits.mem2 Room.mem1 Room.mem2 InBounds.mem1 InBounds.mem2
  Words8Fit.mem1 Words8Fit.mem2 WF_mem1 WF_mem2

attribute [local mlir_read] readAt_mem1 readAt_mem2

/-- A block's stores into `X` keep the state `WF`. -/
theorem WF_mem12 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem2 X i n Xv (mem1 X block i' n' s.mem) } : GlobalState).WF :=
  WF_mem2 (s := { s with mem := mem1 X block i' n' s.mem }) (WF_mem1 h)

/-- After the first loop, `X` holds the block's words, byte-swapped. -/
theorem holdsX_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (hf : InBounds m X 1024)
    (block : BitVec 1024) : HoldsX (mem1 X block 0 16 m) X (X0 block) := by
  suffices
    ∀ n i (m : MemoryState),
      i + n = 16 →
        InBounds m X 1024 →
        (∀ k (hk : k < 16), k < i → m.readAt (slot X k) 64 = (X0 block)[k]) →
        HoldsX (mem1 X block i n m) X (X0 block)
    from this 16 0 m rfl hf (fun _ _ hk => absurd hk (by omega))
  intro n
  induction n with
  | zero =>
    intro i m hi _ h k hk
    exact h k hk (by omega)
  | succ n ih =>
    intro i m hi hf h
    refine ih (i + 1) _ (by omega) hf.storeAt fun k hk hki' => ?_
    by_cases hki : k = i
    · subst hki
      rw [readAt_slot_storeAt_self hX hf hk, X0, Vector.getElem_ofFn]
    · rw [readAt_slot_storeAt_ne hX (by omega) hk (Ne.symm hki)]
      exact h k hk (by omega)

/-! ### The first loop -/

/-- A round of the first loop: `X[i] = fd_ulong_bswap( W[i] )`, the round on it; then `^bb3`
after round `15`, else round `i + 1`. -/
theorem words_iter (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (i : Nat)
    (hi : i < 16) (a b c d e f g h w k : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState)) (hwf : S.WF) (hX : X.offset = 0) (hKo : Kp.offset = 0)
    (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id) (hXf : Room S.mem X 1024)
    (hKf : Fits S.mem Kp 5120) (hWf : Fits S.mem Wp 1024)
    (hw : S.mem.readAt (Wp.add (BitVec.ofNat 64 (i * 8))) 64 = w)
    (hk : S.mem.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = k)
    (hexit :
      i + 1 = 16 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr3 st X Kp Wp H cnt E' (T1 (fd_ulong_bswap.spec w) h e f g k + T2 a b c) a b c
                  (d + T1 (fd_ulong_bswap.spec w) h e f g k) e f g 16)
                3
                { S with
                  mem := S.mem.storeAt (X.add (BitVec.ofNat 64 (i * 8))) (fd_ulong_bswap.spec w) } =
              R)
    (hback :
      i + 1 < 16 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr2 st X Kp Wp H cnt E' (T1 (fd_ulong_bswap.spec w) h e f g k + T2 a b c) a b c
                  (d + T1 (fd_ulong_bswap.spec w) h e f g k) e f g (i + 1))
                2
                { S with
                  mem := S.mem.storeAt (X.add (BitVec.ofNat 64 (i * 8))) (fd_ulong_bswap.spec w) } =
              R) :
    fd_sha512_core_ref.runFrom (hdr2 st X Kp Wp H cnt E a b c d e f g h i) 2 S = R := by
  have fw : Fits S.mem (Wp.add (BitVec.ofNat 64 (i * 8))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      hWf
  have fx : Room S.mem (X.add (BitVec.ofNat 64 (i * 8))) 64 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hXf
  have fk := fits_K hKo hKf (by omega : i < 80)
  have hi64 : i % 18446744073709551616 = i := Nat.mod_eq_of_lt (by omega)
  have hi8 : i * 8 < 18446744073709551616 := by omega
  have o1 := saddOverflow_ofNat (i := i) (k := 1) (by omega)
  have o1' := uaddOverflow_ofNat (i := i) (k := 1) (by omega)
  block_init
  -- X[i] = fd_ulong_bswap( FD_LOAD( ulong, W + i*sizeof(ulong) ) );
  step_pure [ofNat_shiftLeft_3, ofNat_mul8_ushiftRight_3 hi, ofNat_mul8_sshiftRight_3 hi]
  step_pure [Nat.mod_eq_of_lt hi8, hi8]
  step_load consuming hw
  step_call using fd_ulong_bswap.call_eq
  step_pure [hi64, hi8, gep_of_offset_zero hX i]
  step_store
  -- ulong T1 = X[i] + h + Sigma1(e) + Ch(e, f, g) + K[i];
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_call using fd_ulong_rotate_right.call_eq
  step_pure [Sigma1_eq]
  step_pure
  step_pure
  step_pure
  step_pure [Ch_disjoint, Ch_eq]
  step_pure [hi64, hi8, gep_of_offset_zero hKo i]
  step_load consuming hk
  step_pure
  step_pure
  step_pure
  step_pure [T1_eq]
  -- ulong T2 = Sigma0(a) + Maj(a, b, c);
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_call using fd_ulong_rotate_right.call_eq
  step_pure [Sigma0_eq]
  step_pure
  step_pure
  step_pure
  step_pure [Maj_eq]
  -- e = d + T1; a = T1 + T2;
  step_pure [e_eq]
  step_pure
  step_pure [a_eq]
  -- i++, i < 16
  step_pure [o1, o1', ← BitVec.ofNat_add]
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- The first loop from round `i`, `n + 1` rounds left: `X[i …] = fd_ulong_bswap( W[i …] )`
stored, then `^bb3` on `loop1`'s working variables. -/
theorem words_loop (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (block : BitVec 1024) (R : PoisonOr (Vals [] × GlobalState)) (hX : X.offset = 0)
    (hKo : Kp.offset = 0) (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id)
    (hXW : X.id ≠ Wp.id) {hw : (Ty.array 80 (.bv 64)).width = 5120} :
    ∀ n i (v : Vector (BitVec 64) 8) (S : GlobalState) (E : ⟪Γ⟫),
      i + n + 1 = 16 →
        S.WF →
        Room S.mem X 1024 →
        Fits S.mem Kp 5120 →
        Fits S.mem Wp 1024 →
        S.mem.readAt Wp 1024 = block →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom (hdr3v st X Kp Wp H cnt E' (loop1 block i v) 16) 3
                { S with mem := mem1 X block i (n + 1) S.mem } =
              R) →
        fd_sha512_core_ref.runFrom (hdr2v st X Kp Wp H cnt E v i) 2 S = R := by
  intro n
  induction n with
  | zero =>
    intro i v S E hi hwf hXf hKf hWf hW hKr hK
    refine
      words_iter st X Kp Wp H cnt i (by omega) v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] _ K[i] S E R
        hwf hX hKo hWo hXK hXf hKf hWf (readAt_word hWf hWo hW (by omega))
        (readAt_K hKf hKo hKr (by omega)) (fun _ E' hE' => ?_) (fun h => absurd h (by omega))
    have := hK E' hE'
    rw [loop1_lt (by omega), show i + 1 = 16 by omega, loop1_16] at this
    exact this
  | succ n ih =>
    intro i v S E hi hwf hXf hKf hWf hW hKr hK
    refine
      words_iter st X Kp Wp H cnt i (by omega) v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] _ K[i] S E R
        hwf hX hKo hWo hXK hXf hKf hWf (readAt_word hWf hWo hW (by omega))
        (readAt_K hKf hKo hKr (by omega)) (fun h => absurd h (by omega)) (fun _ E' hE' => ?_)
    refine
      ih (i + 1) (round v (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)) K[i])
        { S with
          mem := S.mem.storeAt (slot X i) (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)) }
        E' (by omega) hwf.storeAt hXf.storeAt hKf.storeAt hWf.storeAt ?_ ?_ fun E'' hE'' => ?_
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne hXW)]
      exact hW
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne hXK)]
      exact hKr
    · have := hK E'' (hE''.trans hE')
      rw [loop1_lt (by omega)] at this
      exact this

/-! ### The second loop -/

/-- A round of the second loop: the four reads of `X`, its new word `x` into `X[i & 0xf]`, the
round on it; then `^bb4` after round `79`, else round `i + 1`. -/
theorem schedule_iter (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (i : Nat)
    (hi : i < 80) (a b c d e f g h x0 x1 x9 x14 k : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState)) (hwf : S.WF) (hX : X.offset = 0) (hKo : Kp.offset = 0)
    (hXK : X.id ≠ Kp.id) (hXf : Fits S.mem X 1024) (hKf : Fits S.mem Kp 5120)
    (h1 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 1) % 16 * 8))) 64 = x1)
    (h14 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 14) % 16 * 8))) 64 = x14)
    (h9 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 9) % 16 * 8))) 64 = x9)
    (h0 : S.mem.readAt (X.add (BitVec.ofNat 64 (i % 16 * 8))) 64 = x0)
    (hk : S.mem.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = k)
    (hexit :
      i + 1 = 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (exit3 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E'
                  (T1 (xNew x0 x1 x9 x14) h e f g k + T2 a b c) a b c
                  (d + T1 (xNew x0 x1 x9 x14) h e f g k) e f g)
                4
                { S with
                  mem :=
                    S.mem.storeAt (X.add (BitVec.ofNat 64 (i % 16 * 8))) (xNew x0 x1 x9 x14) } =
              R)
    (hback :
      i + 1 < 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr3 st X Kp Wp H cnt E' (T1 (xNew x0 x1 x9 x14) h e f g k + T2 a b c) a b c
                  (d + T1 (xNew x0 x1 x9 x14) h e f g k) e f g (i + 1))
                3
                { S with
                  mem :=
                    S.mem.storeAt (X.add (BitVec.ofNat 64 (i % 16 * 8))) (xNew x0 x1 x9 x14) } =
              R) :
    fd_sha512_core_ref.runFrom (hdr3 st X Kp Wp H cnt E a b c d e f g h i) 3 S = R := by
  have f1 := fits_slot hX hXf (i + 1)
  have f14 := fits_slot hX hXf (i + 14)
  have f9 := fits_slot hX hXf (i + 9)
  have f0 := fits_slot hX hXf i
  have fk := fits_K hKo hKf hi
  have hi64 : i % 18446744073709551616 = i := Nat.mod_eq_of_lt (by omega)
  have hi8 : i * 8 < 18446744073709551616 := by omega
  have o1 := saddOverflow_ofNat (i := i) (k := 1) (by omega)
  have o1' := uaddOverflow_ofNat (i := i) (k := 1) (by omega)
  have o14 := saddOverflow_ofNat (i := i) (k := 14) (by omega)
  have o14' := uaddOverflow_ofNat (i := i) (k := 14) (by omega)
  have o9 := saddOverflow_ofNat (i := i) (k := 9) (by omega)
  have o9' := uaddOverflow_ofNat (i := i) (k := 9) (by omega)
  block_init
  -- ulong s0 = X[(i +  1UL) & 0x0fUL];
  step_pure [o1, o1', ← BitVec.ofNat_add]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h1
  -- ulong s1 = X[(i + 14UL) & 0x0fUL];
  step_pure [o14, o14', ← BitVec.ofNat_add]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h14
  -- s0 = sigma0(s0);
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_pure
  step_pure [sigma0_eq]
  -- s1 = sigma1(s1);
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_pure
  step_pure [sigma1_eq]
  -- X[i & 0xfUL] += s0 + s1 + X[(i + 9UL) & 0xfUL];
  step_pure [o9, o9', ← BitVec.ofNat_add]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h9
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h0
  step_pure
  step_pure
  step_pure [xNext_eq]
  step_store
  -- ulong T1 = X[i & 0xfUL ] + h + Sigma1(e) + Ch(e, f, g) + K[i];
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_call using fd_ulong_rotate_right.call_eq
  step_pure [Sigma1_eq]
  step_pure
  step_pure
  step_pure
  step_pure [Ch_disjoint, Ch_eq]
  step_pure [hi64, hi8, gep_of_offset_zero hKo i]
  step_load consuming hk
  step_pure
  step_pure
  step_pure
  step_pure [T1_eq]
  -- ulong T2 = Sigma0(a) + Maj(a, b, c);
  step_call using fd_ulong_rotate_right.call_eq
  step_call using fd_ulong_rotate_right.call_eq
  step_pure
  step_call using fd_ulong_rotate_right.call_eq
  step_pure [Sigma0_eq]
  step_pure
  step_pure
  step_pure
  step_pure [Maj_eq]
  -- e = d + T1; a = T1 + T2;
  step_pure [e_eq]
  step_pure
  step_pure [a_eq]
  -- i++, i < 80
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- The second loop from round `i`, `n + 1` rounds left, `X` holding `Xv`: the message schedule's
words stored, then `^bb4` on `loop2`'s working variables. -/
theorem schedule_loop (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (R : PoisonOr (Vals [] × GlobalState)) (hX : X.offset = 0) (hKo : Kp.offset = 0)
    (hXK : X.id ≠ Kp.id) {hw : (Ty.array 80 (.bv 64)).width = 5120} :
    ∀ n i (v : Vector (BitVec 64) 8) (Xv : Vector (BitVec 64) 16) (S : GlobalState) (E : ⟪Γ⟫),
      i + n + 1 = 80 →
        S.WF →
        Fits S.mem X 1024 →
        Fits S.mem Kp 5120 →
        HoldsX S.mem X Xv →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom (exit3v st X Kp Wp H cnt E' (loop2 i v Xv)) 4
                { S with mem := mem2 X i (n + 1) Xv S.mem } =
              R) →
        fd_sha512_core_ref.runFrom (hdr3v st X Kp Wp H cnt E v i) 3 S = R := by
  intro n
  induction n with
  | zero =>
    intro i v Xv S E hi hwf hXf hKf hXv hKr hK
    refine
      schedule_iter st X Kp Wp H cnt i (by omega) v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] Xv[i % 16]
        Xv[(i + 1) % 16] Xv[(i + 9) % 16] Xv[(i + 14) % 16] K[i] S E R hwf hX hKo hXK hXf hKf
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (readAt_K hKf hKo hKr (by omega)) (fun _ E' hE' => ?_) (fun h => absurd h (by omega))
    have := hK E' hE'
    rw [loop2_lt (by omega), show i + 1 = 80 by omega, loop2_80] at this
    exact this
  | succ n ih =>
    intro i v Xv S E hi hwf hXf hKf hXv hKr hK
    refine
      schedule_iter st X Kp Wp H cnt i (by omega) v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] Xv[i % 16]
        Xv[(i + 1) % 16] Xv[(i + 9) % 16] Xv[(i + 14) % 16] K[i] S E R hwf hX hKo hXK hXf hKf
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (readAt_K hKf hKo hKr (by omega)) (fun h => absurd h (by omega)) (fun _ E' hE' => ?_)
    refine
      ih (i + 1) (round v (xNext Xv i) K[i]) (Xv.set (i % 16) (xNext Xv i))
        { S with mem := S.mem.storeAt (slot X (i % 16)) (xNext Xv i) } E' (by omega) hwf.storeAt
        hXf.storeAt hKf.storeAt (hXv.store hX hXf (Nat.mod_lt _ (by decide)) (xNext Xv i)) ?_
        fun E'' hE'' => ?_
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X (i % 16)) (Range.disjoint_of_id_ne hXK)]
      exact hKr
    · have := hK E'' (hE''.trans hE')
      rw [loop2_lt (by omega)] at this
      exact this

/-! ### A block's end, and the blocks -/

theorem saddOverflow_sub_one {r : Nat} (h : r + 1 < 2 ^ 63) :
    (BitVec.ofNat 64 (r + 1)).saddOverflow 18446744073709551615#64 = false := by
  have hr : (BitVec.ofNat 64 (r + 1)).toInt = r + 1 := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hr]
  omega

theorem ofNat_add_neg_one (r : Nat) :
    BitVec.ofNat 64 (r + 1) + 18446744073709551615#64 = BitVec.ofNat 64 r := by
  rw [BitVec.ofNat_add]
  generalize BitVec.ofNat 64 r = x
  bv_decide

/-- `^bb4`: `state[k] += …`, `W += 16UL*sizeof(ulong)`, `X`'s lifetime's end, `--block_cnt`; then
`^bb5` after the last block, else `^bb1`. -/
theorem update_block (st data X Kp Wp : Pointer) (n : BitVec 64)
    (h0 h1 h2 h3 h4 h5 h6 h7 a b c d e f g h : BitVec 64) (r : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get)
    (hwf : S.WF) (hst : S.mem.Words8Fit st) (hstX : st.id ≠ X.id)
    (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hr : r + 1 < 2 ^ 63)
    (hexit :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5
                { S with
                  mem :=
                    (S.mem.storeWords8 st
                          #v[h0 + a, h1 + b, h2 + c, h3 + d, h4 + e, h5 + f, h6 + g,
                            h7 + h]).lifetimeEnd
                      X } =
              R)
    (hback :
      r ≠ 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr1 st X Kp (Wp.add 128#64) (h0 + a) (h1 + b) (h2 + c) (h3 + d) (h4 + e) (h5 + f)
                  (h6 + g) (h7 + h) (BitVec.ofNat 64 r) E')
                1
                { S with
                  mem :=
                    (S.mem.storeWords8 st
                          #v[h0 + a, h1 + b, h2 + c, h3 + d, h4 + e, h5 + f, h6 + g,
                            h7 + h]).lifetimeEnd
                      X } =
              R) :
    fd_sha512_core_ref.runFrom
        (exit3 st X Kp Wp h0 h1 h2 h3 h4 h5 h6 h7 (BitVec.ofNat 64 (r + 1)) E a b c d e f g h) 4 S =
      R := by
  block_init
  -- state[0] += a; … state[7] += h;
  step_pure [BitVec.add_comm a h0]
  step_store
  step_pure [BitVec.add_comm b h1]
  step_store
  step_pure [BitVec.add_comm c h2]
  step_store
  step_pure [BitVec.add_comm d h3]
  step_store
  step_pure [BitVec.add_comm e h4]
  step_store
  step_pure [BitVec.add_comm f h5]
  step_store
  step_pure [BitVec.add_comm g h6]
  step_store
  step_pure [BitVec.add_comm h h7]
  step_store
  -- W += 16UL*sizeof(ulong); } while( --block_cnt );
  step_pure
  step_pure
  step_pure [saddOverflow_sub_one hr, ofNat_add_neg_one]
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          rintro rfl; exact hbr rfl)

/-! ### The blocks -/

theorem block_offset {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j < N) :
    (data.add (BitVec.ofNat 64 (128 * j))).offset.toNat = data.offset.toNat + 128 * j := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : 128 * j < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]

theorem block_noOverflow {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j < N) : ¬data.offset.uaddOverflow (BitVec.ofNat 64 (128 * j)) := by
  simp [BitVec.uaddOverflow]
  omega

/-- Block `j` of `N` fits. -/
theorem fits_block {m : MemoryState} {data : Pointer} {N j : Nat} (hf : Fits m data (1024 * N))
    (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N) :
    Fits m (data.add (BitVec.ofNat 64 (128 * j))) 1024 :=
  Fits.add_of_le (block_noOverflow hdo hj)
    (by
      simp; omega)
    hf

/-- Block `j` of `N`, read where the `N` blocks were read whole. -/
theorem readAt_block {m : MemoryState} {data : Pointer} {N j : Nat} {D : BitVec (1024 * N)}
    (hf : Fits m data (1024 * N)) (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N)
    (h : m.readAt data (1024 * N) = D) :
    m.readAt (data.add (BitVec.ofNat 64 (128 * j))) 1024 = D.extractLsb' (1024 * j) 1024 := by
  rw [MemoryState.readAt_add_of_readAt hf.inBounds (block_noOverflow hdo hj)
      (by
        simp; omega)
      h]
  congr 1
  simp
  omega

theorem add_block {data : Pointer} (j : Nat) :
    (data.add (BitVec.ofNat 64 (128 * j))).add 128#64 =
      data.add (BitVec.ofNat 64 (128 * (j + 1))) := by
  rw [Pointer.add_add, Nat.mul_succ, BitVec.ofNat_add]

/-- The memory a block leaves: its stores into `X` within `X`'s lifetime, then its state words. -/
def memBlock (st X : Pointer) (block : BitVec 1024) (H : Vector (BitVec 64) 8) (m : MemoryState) :
    MemoryState :=
  ((mem2 X 16 64 (X0 block) (mem1 X block 0 16 (m.lifetimeStart X))).storeWords8 st
        (compress H block)).lifetimeEnd
    X

/-- The memory after blocks `j … j + n - 1`. -/
def memBlocks (st X : Pointer) (D : BitVec w) :
    (j n : Nat) → Vector (BitVec 64) 8 → MemoryState → MemoryState
  | _, 0, _, m => m
  | j, n + 1, H, m =>
    let block := D.extractLsb' (1024 * j) 1024
    memBlocks st X D (j + 1) n (compress H block) (memBlock st X block H m)

theorem WF_memBlock {s : GlobalState} (h : s.WF) :
    ({ s with mem := memBlock st X block H s.mem } : GlobalState).WF := by
  have h₁ :=
    WF_mem12 (X := X) (Xv := X0 block) (block := block) (i := 16) (n := 64) (i' := 0) (n' := 16)
      (s := { s with mem := s.mem.lifetimeStart X }) h.lifetimeStart
  exact (GlobalState.WF.storeWords8 (p := st) (v := compress H block) h₁).lifetimeEnd (p := X)

theorem Words8Fit.memBlock {m : MemoryState} (h : m.Words8Fit p) (hne : p.id ≠ X.id) :
    (memBlock st X block H m).Words8Fit p :=
  (Words8Fit.mem2 (Words8Fit.mem1 (h.lifetimeStart hne))).storeWords8.lifetimeEnd hne

theorem InBounds.memBlock {m : MemoryState} (h : InBounds m p w) :
    InBounds (memBlock st X block H m) p w :=
  (InBounds.mem2 (InBounds.mem1 h.lifetimeStart)).storeWords8.lifetimeEnd

theorem Fits.memBlock {m : MemoryState} (h : Fits m p w) (hne : p.id ≠ X.id) :
    Fits (memBlock st X block H m) p w :=
  (Fits.mem2 (Fits.mem1 (h.lifetimeStart hne))).storeWords8.lifetimeEnd hne

/-- A read outside `X` and the state words: the read before the block. -/
theorem readAt_memBlock {m : MemoryState} (hst : st.offset.toNat + 56 < 2 ^ 64)
    (hd : (Range.of st 512).Disjoint (Range.of q w)) (hne : q.id ≠ X.id) :
    (memBlock st X block H m).readAt q w = m.readAt q w := by
  rw [memBlock, MemoryState.readAt_lifetimeEnd, MemoryState.readAt_storeWords8_of_disjoint hst hd,
    readAt_mem2 hne, readAt_mem1 hne, MemoryState.readAt_lifetimeStart]

/-- `X`'s stores are gone once its frame is erased. -/
theorem eraseFrom_mem1 {m : MemoryState} (h : B ≤ X.id.id) :
    (mem1 X block i n m).eraseFrom B = m.eraseFrom B := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih =>
    rw [mem1, ih, MemoryState.eraseFrom_storeAt,
      MemoryState.storeAt_eraseFrom_of_le (p := slot X i) h]

theorem eraseFrom_mem2 {m : MemoryState} (h : B ≤ X.id.id) :
    (mem2 X i n Xv m).eraseFrom B = m.eraseFrom B := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih =>
    rw [mem2, ih, MemoryState.eraseFrom_storeAt,
      MemoryState.storeAt_eraseFrom_of_le (p := slot X (i % 16)) h]

/-- Once `X`'s frame is erased, the blocks leave only the last state words. -/
theorem eraseFrom_memBlocks {m : MemoryState} {D : BitVec w} (h : B ≤ X.id.id) :
    (memBlocks st X D j (n + 1) H m).eraseFrom B =
      (m.eraseFrom B).storeWords8 st (compressFrom D j (n + 1) H) := by
  induction n generalizing j H m with
  | zero =>
    simp only [memBlocks, memBlock, compressFrom, MemoryState.eraseFrom_lifetimeEnd_of_le h,
      MemoryState.eraseFrom_storeWords8, eraseFrom_mem2 h, eraseFrom_mem1 h,
      MemoryState.eraseFrom_lifetimeStart_of_le h]
  | succ n
    ih =>
    rw [memBlocks, ih, memBlock, MemoryState.eraseFrom_lifetimeEnd_of_le h,
      MemoryState.eraseFrom_storeWords8, eraseFrom_mem2 h, eraseFrom_mem1 h,
      MemoryState.eraseFrom_lifetimeStart_of_le h, MemoryState.storeWords8_storeWords8_self]
    rfl

/-- `update_block` on the state words `H` and the working variables `v`. -/
theorem update_block_vec (st data X Kp Wp : Pointer) (n : BitVec 64) (H v : Vector (BitVec 64) 8)
    (r : Nat) (S : GlobalState) (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get)
    (hwf : S.WF) (hst : S.mem.Words8Fit st) (hstX : st.id ≠ X.id)
    (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hr : r + 1 < 2 ^ 63)
    (hexit :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5
                { S with mem := (S.mem.storeWords8 st (addWords H v)).lifetimeEnd X } =
              R)
    (hback :
      r ≠ 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr1v st X Kp (Wp.add 128#64) (addWords H v) (BitVec.ofNat 64 r) E') 1
                { S with mem := (S.mem.storeWords8 st (addWords H v)).lifetimeEnd X } =
              R) :
    fd_sha512_core_ref.runFrom (exit3v st X Kp Wp H (BitVec.ofNat 64 (r + 1)) E v) 4 S = R :=
  update_block st data X Kp Wp n H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] v[0] v[1] v[2] v[3] v[4]
    v[5] v[6] v[7] r S E R hArgs hwf hst hstX hWo hr hexit hback

-- the continuation's 48 env reads through the loops' envs, and `X`'s lifetime start: just over
-- 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- A block's rounds from `^bb1`: the two loops, then `^bb4`. -/
theorem rounds_block (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (block : BitVec 1024) (S : GlobalState) (E₁ : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    {hw : (Ty.array 80 (.bv 64)).width = 5120} (hwf : S.WF) (hX : X.offset = 0)
    (hKo : Kp.offset = 0) (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id)
    (hXW : X.id ≠ Wp.id) (hXb : InBounds S.mem X 1024) (hKf : Fits S.mem Kp 5120)
    (hWf : Fits S.mem Wp 1024) (hW : S.mem.readAt Wp 1024 = block)
    (hKr : S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw))
    (hcont :
      ∀ E' : ⟪Γ⟫,
        E'.args = E₁.args →
          fd_sha512_core_ref.runFrom
              (exit3v st X Kp Wp H cnt E' (loop2 16 (loop1 block 0 H) (X0 block))) 4
              { S with
                mem := mem2 X 16 64 (X0 block) (mem1 X block 0 16 (S.mem.lifetimeStart X)) } =
            R) :
    fd_sha512_core_ref.runFrom (hdr1v st X Kp Wp H cnt E₁) 1 S = R := by
  block_init
  -- "llvm.intr.lifetime.start"
  step_pure
  finish_block
  -- the args through the env's writes, so the loops' continuations chain them without unfolding
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]
  step_loop using words_loop st X Kp Wp H cnt block R hX hKo hWo hXK hXW 15 0 H
  -- the stores into the started `X` make it known
  have hXr := room_mem1.1 (hS ▸ hroom_X)
  have hXf : Fits S.mem X 1024 := by
    rw [hS]
    exact fits_mem1 hX hXr
  have hXv : HoldsX S.mem X (X0 block) := by
    rw [hS]
    exact holdsX_mem1 hX hXr.inBounds block
  clear hXr hroom_X
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]; exact hArgs₀
  step_loop using schedule_loop st X Kp Wp H cnt R hX hKo hXK 63 16 (loop1 block 0 H) (X0 block)
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]; exact hArgs₀
  step_loop using hcont

/-- The blocks from `j`, `r + 1` of them left, on the state words `H`: each block's rounds and
`state[k] += …`; then `^bb5` on `memBlocks`. -/
theorem blocks_loop (st data X Kp : Pointer) (n : BitVec 64) (N : Nat) (D : BitVec (1024 * N))
    (R : PoisonOr (Vals [] × GlobalState)) {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hX : X.offset = 0) (hKo : Kp.offset = 0) (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hXK : X.id ≠ Kp.id) (hXd : X.id ≠ data.id) (hKst : Kp.id ≠ st.id) (hstX : st.id ≠ X.id)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * N))) :
    ∀ r j (H : Vector (BitVec 64) 8) (S : GlobalState) (E : ⟪Γ⟫),
      j + r + 1 = N →
        E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get →
        S.WF →
        S.mem.Words8Fit st →
        InBounds S.mem X 1024 →
        Fits S.mem Kp 5120 →
        Fits S.mem data (1024 * N) →
        S.mem.readAt data (1024 * N) = D →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5 { S with mem := memBlocks st X D j (r + 1) H S.mem } =
              R) →
        fd_sha512_core_ref.runFrom
            (hdr1v st X Kp (data.add (BitVec.ofNat 64 (128 * j))) H (BitVec.ofNat 64 (r + 1)) E) 1
            S =
          R := by
  intro r
  induction r with
  | zero =>
    intro j H S E hj hA hwf hst hXb hKf hdf hD hKr hK
    exact
      rounds_block st X Kp _ H _ _ S E R hwf hX hKo
        (by
          rw [block_offset hdo (by omega)]; omega)
        hXK hXd hXb hKf (fits_block hdf hdo (by omega)) (readAt_block hdf hdo (by omega) hD) hKr
        fun E₁ h₁ =>
        update_block_vec st data X Kp _ n H _ 0 _ E₁ R (h₁.trans hA) (WF_mem12 hwf.lifetimeStart)
          (Words8Fit.mem2 (Words8Fit.mem1 (hst.lifetimeStart hstX))) hstX
          (by
            rw [block_offset hdo (by omega)]; omega)
          (by decide) (fun _ E₂ h₂ => hK E₂ (h₂.trans h₁)) (fun h => absurd rfl h)
  | succ r ih =>
    intro j H S E hj hA hwf hst hXb hKf hdf hD hKr hK
    refine
      rounds_block st X Kp _ H _ _ S E R hwf hX hKo
        (by
          rw [block_offset hdo (by omega)]; omega)
        hXK hXd hXb hKf (fits_block hdf hdo (by omega)) (readAt_block hdf hdo (by omega) hD) hKr
        fun E₁ h₁ =>
        update_block_vec st data X Kp _ n H _ (r + 1) _ E₁ R (h₁.trans hA)
          (WF_mem12 hwf.lifetimeStart) (Words8Fit.mem2 (Words8Fit.mem1 (hst.lifetimeStart hstX)))
          hstX
          (by
            rw [block_offset hdo (by omega)]; omega)
          (by omega) (fun h => absurd h (by omega)) (fun _ E₂ h₂ => ?_)
    rw [add_block]
    -- the block's memory, as `memBlock`
    change
      fd_sha512_core_ref.runFrom _ 1
          { S with mem := memBlock st X (D.extractLsb' (1024 * j) 1024) H S.mem } =
        R
    apply ih (j + 1)
    · omega
    · exact h₂.trans (h₁.trans hA)
    · exact WF_memBlock hwf
    · exact Words8Fit.memBlock hst hstX
    · exact InBounds.memBlock hXb
    · exact Fits.memBlock hKf hXK.symm
    · exact Fits.memBlock hdf hXd.symm
    · rw [readAt_memBlock hst.1 hsep hXd.symm]
      exact hD
    · rw [readAt_memBlock hst.1 (Range.disjoint_of_id_ne hKst.symm) hXK.symm]
      exact hKr
    · exact fun E₃ h₃ => hK E₃ (h₃.trans (h₂.trans h₁))

/-- A read of the entry state's memory, through `K`'s block and `X`'s `alloca`. -/
theorem readAt_frame {s : GlobalState} {x : BitVec v} (hwf : s.WF) (h : InBounds s.mem q w) :
    (({ alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ k x } :
                GlobalState).alloca
            b d).mem.readAt
        q w =
      s.mem.readAt q w := by
  rw [MemoryState.readAt_alloca hwf.addBlock (h.addBlock hwf), MemoryState.readAt_addBlock hwf h]

end fd_sha512_core_ref

open fd_sha512_core_ref

/-- `fd_sha512_core_ref.K`'s initializer gives its folded constant, leaving the state. -/
public theorem fd_sha512_core_ref_K.value_eq (s : GlobalState) :
    fd_sha512_core_ref_K.value s = .value (Ty.wrap fd_sha512_core_ref_K.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_sha512_core_ref` compresses the `n` 128-byte blocks at `data` into the eight state words
at `st` and stores the result there. The state and the blocks must not overlap; `K` and `X` leave
two blocks counted. -/
public theorem fd_sha512_core_ref.call_eq (st data : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hst : s.mem.Words8Fit st) (hn : n ≠ 0) (hdata : Fits s.mem data (1024 * n.toNat))
    (hdo : data.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * n.toNat))) :
    fd_sha512_core_ref.call (fd_sha512_core_ref.args (.value st) (.value data) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeWords8 st
                (fd_sha512_core_ref.spec (s.mem.readWords8 st)
                  (s.mem.readAt data (1024 * n.toNat))) }) := by
  func_init
  have hdata₀ : Fits S₀.mem data (1024 * n.toNat) := hS ▸ hdata
  block_init
  iterate 8 step_pure
  step_addressof fd_sha512_core_ref_K.value_eq with Kp
  iterate 13 step_pure
  step_alloca with X
  iterate 7 step_pure
  -- ulong a = state[0]; … ulong h = state[7];
  iterate 8 step_load inline
  finish_block
  have hD : S.mem.readAt data (1024 * n.toNat) = S₀.mem.readAt data (1024 * n.toNat) := by
    rw [hS]
    exact readAt_frame hwf₀ hdata₀.inBounds
  have hN : n.toNat - 1 + 1 = n.toNat :=
    Nat.sub_add_cancel
      (Nat.pos_of_ne_zero
        (by
          intro h; exact hn (BitVec.eq_of_toNat_eq h)))
  have hXK : X.id ≠ Kp.id := by
    rw [hX, hKp]; exact GlobalState.slot_id_ne (by decide)
  have hrun :
    fd_sha512_core_ref.runFrom E 1 S =
      .value
        (.nil,
          { S with
            mem :=
              memBlocks st X (S₀.mem.readAt data (1024 * n.toNat)) 0 (n.toNat - 1 + 1)
                (S₀.mem.readWords8 st) S.mem }) := by
    step_loop using
      blocks_loop st data X Kp n n.toNat _ _ hX_off hKp_off hdo hXK hdata_ne_X.symm hst_ne_Kp.symm
        hst_ne_X hsep (n.toNat - 1) 0 (S₀.mem.readWords8 st)
    block_init
    finish_block
    rfl
  rw [hrun, PoisonOr.value_bind]
  subst hS
  congr 2
  rw [eraseFrom_memBlocks
      (by
        rw [hX]; simp),
    GlobalState.eraseFrom_alloca_of_le (by simp),
    MemoryState.eraseFrom_addBlock_of_le (Nat.le_refl _), hwf₀.eraseFrom, hN]
  rfl

end Proof

end MLIR.Firedancer.Ref

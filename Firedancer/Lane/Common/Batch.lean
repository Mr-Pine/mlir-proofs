module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.X8
public import Firedancer.Avx512.fd_ed25519_verify
public import Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg
public import Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg_cached

/-! The callees of `fd_ed25519_verify_batch_multi_msg(_cached)` as interfaces their proofs
discharge: `fd_ed25519_verify` (cached or not), `verify_x8`, and the multi-buffer SHA-512 that
`verify_x8` calls; the batch's items as the pointer arrays give them. -/

namespace MLIR

@[expose] public section

/-! ## Stores off a set of blocks -/

/-- `m'` agrees with `m` on the blocks `K`: the same blocks there, and the same addresses and
globals. -/
def MemoryState.SameOn (m m' : MemoryState) (K : BlockId → Prop) : Prop :=
  (∀ b, K b → m'[b]? = m[b]?) ∧ m'.unspec = m.unspec ∧ m'.table = m.table

namespace MemoryState.SameOn

variable {K K' : BlockId → Prop} {m m' m'' : MemoryState}

theorem refl (m : MemoryState) : m.SameOn m K :=
  ⟨fun _ _ => rfl, rfl, rfl⟩

theorem trans (h : m.SameOn m' K) (h' : m'.SameOn m'' K) : m.SameOn m'' K :=
  ⟨fun b hb => (h'.1 b hb).trans (h.1 b hb), h'.2.1.trans h.2.1, h'.2.2.trans h.2.2⟩

theorem mono (h : m.SameOn m' K) (hK : ∀ b, K' b → K b) : m.SameOn m' K' :=
  ⟨fun b hb => h.1 b (hK b hb), h.2⟩

theorem readAt (h : m.SameOn m' K) (hq : K q.id) : m'.readAt q w = m.readAt q w := by
  simp only [MemoryState.readAt, h.1 _ hq]

theorem loadPtr (h : m.SameOn m' K) (hq : K q.id) : m'.loadPtr q = m.loadPtr q := by
  have ha : m'.addr = m.addr := by unfold MemoryState.addr; rw [h.2.1]
  unfold MemoryState.loadPtr MemoryState.ptrAt
  rw [h.1 _ hq, ha]

theorem fits (h : m.SameOn m' K) (hq : K q.id) (hf : Fits m q w) : Fits m' q w := by
  simpa only [Fits, h.1 _ hq] using hf

theorem inBounds (h : m.SameOn m' K) (hq : K q.id) (hf : InBounds m q w) : InBounds m' q w := by
  simpa only [InBounds, h.1 _ hq] using hf

theorem writable (h : m.SameOn m' K) (hq : K q.id) (hf : Writable m q) : Writable m' q := by
  simpa only [Writable, h.1 _ hq] using hf

theorem room (h : m.SameOn m' K) (hq : K q.id) (hf : Room m q w) : Room m' q w := by
  simpa only [Room, Live, Writable, h.1 _ hq] using hf

theorem shaFit (h : m.SameOn m' K) (hq : K q.id) (hf : m.ShaFit q) : m'.ShaFit q :=
  ⟨h.fits hq hf.1, hf.2⟩

theorem globals (h : m.SameOn m' K) (hg : m.Globals G) : m'.Globals G :=
  hg.mono (by unfold MemoryState.globals; rw [h.2.2]) fun _ h => h

end MemoryState.SameOn

/-- `m'` is `m` after stores into blocks outside `K`. -/
inductive MemoryState.StoresOff (K : BlockId → Prop) : MemoryState → MemoryState → Prop
  | refl (m : MemoryState) : MemoryState.StoresOff K m m
  | storeAt {m m' : MemoryState} {p : Pointer} {w : Nat} (x : BitVec w) :
    MemoryState.StoresOff K m m' → ¬K p.id → MemoryState.StoresOff K m (m'.storeAt p x)

namespace MemoryState.StoresOff

variable {K K' : BlockId → Prop} {m m' m'' : MemoryState}

theorem trans (h : m.StoresOff K m') (h' : m'.StoresOff K m'') : m.StoresOff K m'' := by
  induction h' with
  | refl => exact h
  | storeAt x _ hp ih => exact .storeAt x ih hp

theorem mono (h : m.StoresOff K m') (hK : ∀ b, K' b → K b) : m.StoresOff K' m' := by
  induction h with
  | refl => exact .refl _
  | storeAt x _ hp ih => exact .storeAt x ih fun h => hp (hK _ h)

/-- A store after them. -/
theorem store (h : m.StoresOff K m') (hp : ¬K p.id) (x : BitVec w) :
    m.StoresOff K (m'.storeAt p x) :=
  .storeAt x h hp

/-- The blocks in `K` are kept, and the addresses and globals. -/
theorem sameOn (h : m.StoresOff K m') : m.SameOn m' K := by
  induction h with
  | refl => exact ⟨fun _ _ => rfl, rfl, rfl⟩
  | storeAt x _ hp ih =>
    refine ⟨fun b hb => ?_, ih.2.1, ih.2.2⟩
    rw [MemoryState.storeAt,
      MemoryState.getElem?_modifyBlock_ne fun e => hp (by rw [← e]; exact hb), ih.1 b hb]

/-- Each block keeps its shape. -/
theorem sameShape (h : m.StoresOff K m') : m'.SameShape m := by
  induction h with
  | refl => exact fun _ => rfl
  | storeAt x _ _ ih => exact fun i => (MemoryState.sameShape_storeAt i).trans (ih i)

/-- `WF` under any allocation counter. -/
theorem wf (h : m.StoresOff K m') {a : AllocState} (hwf : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m'⟩ : GlobalState).WF := by
  induction h with
  | refl => exact hwf
  | storeAt x _ _ ih => exact GlobalState.WF.storeAt (s := ⟨a, _⟩) ih

theorem room (h : m.StoresOff K m') (hp : Room m p w) : Room m' p w :=
  hp.of_sameShape h.sameShape.symm

theorem inBounds (h : m.StoresOff K m') (hp : InBounds m p w) : InBounds m' p w :=
  hp.of_sameShape h.sameShape.symm

theorem writable (h : m.StoresOff K m') (hp : Writable m p) : Writable m' p :=
  hp.of_sameShape h.sameShape.symm

theorem globals (h : m.StoresOff K m') (hg : m.Globals G) : m'.Globals G :=
  h.sameOn.globals hg

/-- `fd_sha512_init`'s stores. -/
theorem initStores {p : Pointer} (hp : ¬K p.id) :
    m.StoresOff K (Firedancer.fd_sha512_init.stores m p) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := by rw [Pointer.add_id]; exact hp
  unfold Firedancer.fd_sha512_init.stores
  repeat refine .storeAt _ ?_ (hp' _)
  exact .refl m

theorem storeWords8 {p : Pointer} (h : m.StoresOff K m') (hp : ¬K p.id) :
    m.StoresOff K (m'.storeWords8 p v) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := by rw [Pointer.add_id]; exact hp
  unfold MemoryState.storeWords8
  repeat refine .storeAt _ ?_ (hp' _)
  exact .storeAt _ h hp

theorem storeSha {p : Pointer} (h : m.StoresOff K m') (hp : ¬K p.id) :
    m.StoresOff K (m'.storeSha p v) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := by rw [Pointer.add_id]; exact hp
  unfold MemoryState.storeSha
  refine storeWords8 ?_ (hp' _)
  repeat refine .storeAt _ ?_ (hp' _)
  exact .storeAt _ h hp

/-- `fd_ed25519_verify`'s memory. -/
theorem resultMem (hp : ¬K sha.id) (res : Firedancer.fd_ed25519_verify.Result) :
    m.StoresOff K (res.mem m sha) := by
  unfold Firedancer.fd_ed25519_verify.Result.mem
  split
  · exact (initStores hp).storeSha hp
  · exact .refl m

end MemoryState.StoresOff

/-! ### Facts past `fd_ed25519_verify`'s memory -/

theorem Room.resultMem {m : MemoryState} {res : Firedancer.fd_ed25519_verify.Result}
    (h : Room m q w) : Room (res.mem m sha) q w :=
  (MemoryState.StoresOff.resultMem (K := fun _ => False) (m := m) (fun h => h) res).room h

theorem MemoryState.Globals.resultMem {m : MemoryState}
    {res : Firedancer.fd_ed25519_verify.Result} (h : m.Globals G) : (res.mem m sha).Globals G :=
  (MemoryState.StoresOff.resultMem (K := fun _ => False) (m := m) (fun h => h) res).globals h

theorem GlobalState.WF.resultMem_mk {s : GlobalState}
    {res : Firedancer.fd_ed25519_verify.Result} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, res.mem s.mem sha⟩ : GlobalState).WF :=
  (MemoryState.StoresOff.resultMem (K := fun _ => False) (m := s.mem) (fun h => h) res).wf
    h.add_blocks

end

end MLIR

namespace MLIR.Firedancer.Lane

open Ref

@[expose] public section

/-! ## Items -/

/-- Item `j` of a batch: `msgs[j]`, `msg_szs[j]`, `sigs[j]`, `public_keys[j]`, `shas[j]`. -/
structure Item where
  msg : Pointer
  msgSz : BitVec 64
  sig : Pointer
  pk : Pointer
  sha : Pointer

/-- A batch's arrays: `msgs`, `msg_szs`, `sigs`, `public_keys`, `shas`, `results`. -/
structure Arrays where
  msgs : Pointer
  msgSzs : Pointer
  sigs : Pointer
  pks : Pointer
  shas : Pointer
  results : Pointer

/-- The arrays `k` entries on. -/
def Arrays.drop (a : Arrays) (k : Nat) : Arrays :=
  ⟨a.msgs.add (BitVec.ofNat 64 (k * 8)), a.msgSzs.add (BitVec.ofNat 64 (k * 8)),
    a.sigs.add (BitVec.ofNat 64 (k * 8)), a.pks.add (BitVec.ofNat 64 (k * 8)),
    a.shas.add (BitVec.ofNat 64 (k * 8)), a.results.add (BitVec.ofNat 64 (k * 4))⟩

/-- `results[j]`. -/
abbrev Arrays.result (a : Arrays) (j : Nat) : Pointer :=
  a.results.add (BitVec.ofNat 64 (j * 4))

/-- Entry `j` of the five input arrays holds `it`: each entry in bounds, the pointers stored
there, the size known. -/
def Arrays.Holds (m : MemoryState) (a : Arrays) (j : Nat) (it : Item) : Prop :=
  InBounds m (a.msgs.add (BitVec.ofNat 64 (j * 8))) 64 ∧
    m.loadPtr (a.msgs.add (BitVec.ofNat 64 (j * 8))) = .value it.msg ∧
    Fits m (a.msgSzs.add (BitVec.ofNat 64 (j * 8))) 64 ∧
    m.readAt (a.msgSzs.add (BitVec.ofNat 64 (j * 8))) 64 = it.msgSz ∧
    InBounds m (a.sigs.add (BitVec.ofNat 64 (j * 8))) 64 ∧
    m.loadPtr (a.sigs.add (BitVec.ofNat 64 (j * 8))) = .value it.sig ∧
    InBounds m (a.pks.add (BitVec.ofNat 64 (j * 8))) 64 ∧
    m.loadPtr (a.pks.add (BitVec.ofNat 64 (j * 8))) = .value it.pk ∧
    InBounds m (a.shas.add (BitVec.ofNat 64 (j * 8))) 64 ∧
    m.loadPtr (a.shas.add (BitVec.ofNat 64 (j * 8))) = .value it.sha

/-- `fd_ed25519_verify`'s preconditions on an item: the message's `msgSz` bytes, the signature's
64 and the key's 32 known, their offsets not wrapping; the hash object fits and is writable. -/
def Item.Ok (m : MemoryState) (it : Item) : Prop :=
  Fits m it.msg (8 * it.msgSz.toNat) ∧ ¬it.msg.offset.uaddOverflow it.msgSz ∧
    it.msgSz.toNat < 2 ^ 63 ∧ Fits m it.sig (8 * 64) ∧ ¬it.sig.offset.uaddOverflow 64#64 ∧
    Fits m it.pk (8 * 32) ∧ ¬it.pk.offset.uaddOverflow 32#64 ∧ m.ShaFit it.sha ∧
    Writable m it.sha

/-- The blocks a batch of `N` items only reads: the input arrays' and the items' messages',
signatures' and keys'. -/
def Arrays.ReadOnly (a : Arrays) (it : Nat → Item) (N : Nat) (b : BlockId) : Prop :=
  b = a.msgs.id ∨ b = a.msgSzs.id ∨ b = a.sigs.id ∨ b = a.pks.id ∨ b = a.shas.id ∨
    ∃ j < N, b = (it j).msg.id ∨ b = (it j).sig.id ∨ b = (it j).pk.id

/-- The written blocks are apart: `results`' and each hash object's block holds no input, and the
hash objects are in distinct blocks, none `results`'. -/
def Arrays.Sep (a : Arrays) (it : Nat → Item) (N : Nat) : Prop :=
  ¬a.ReadOnly it N a.results.id ∧
    (∀ j < N, ¬a.ReadOnly it N (it j).sha.id ∧ (it j).sha.id ≠ a.results.id) ∧
    ∀ j < N, ∀ k < N, j ≠ k → (it j).sha.id ≠ (it k).sha.id

/-- What the C asks of a batch of `N` items: the arrays hold them, each item's inputs are known,
`results` has room for `N` codes, the arrays' offsets do not wrap, the written blocks are apart. -/
structure BatchOk (m : MemoryState) (a : Arrays) (it : Nat → Item) (N : Nat) : Prop where
  holds : ∀ j < N, a.Holds m j (it j)
  ok : ∀ j < N, (it j).Ok m
  room : ∀ j < N, Room m (a.result j) 32
  len : 8 * N < 2 ^ 63
  off : a.msgs.offset.toNat + 8 * N < 2 ^ 64 ∧ a.msgSzs.offset.toNat + 8 * N < 2 ^ 64 ∧
    a.sigs.offset.toNat + 8 * N < 2 ^ 64 ∧ a.pks.offset.toNat + 8 * N < 2 ^ 64 ∧
    a.shas.offset.toNat + 8 * N < 2 ^ 64 ∧ a.results.offset.toNat + 4 * N < 2 ^ 64
  sep : a.Sep it N

/-- Item `it`'s `R` (the signature's first half). -/
def Item.readR (m : MemoryState) (it : Item) : BitVec 256 :=
  m.readAt it.sig 256

/-- Item `it`'s `S` (the signature's second half). -/
def Item.readS (m : MemoryState) (it : Item) : BitVec 256 :=
  m.readAt (it.sig.add 32#64) 256

/-- Item `it`'s public key. -/
def Item.readA (m : MemoryState) (it : Item) : BitVec 256 :=
  m.readAt it.pk 256

/-- Item `it`'s message. -/
def Item.readMsg (m : MemoryState) (it : Item) : BitVec (8 * it.msgSz.toNat) :=
  m.readAt it.msg (8 * it.msgSz.toNat)

/-- `fd_ed25519_verify` on item `it` at `m`, on the base point's table. -/
noncomputable def Item.verifySpec (m : MemoryState) (it : Item) : fd_ed25519_verify.Result :=
  Avx512.fd_ed25519_verify.spec Avx512.fd_ed25519_base_point_wnaf_table.point it.msgSz
    (it.readMsg m) (it.readR m) (it.readS m) (it.readA m) (m.readAt it.sha 1024)

/-! ## `fd_ed25519_verify` -/

/-- The lift of `fd_ed25519_verify` does what `Avx512.fd_ed25519_verify.call_eq` says of the
older lift, its frame `nb …` blocks: the same preconditions, code and memory. -/
def VerifyCallEq (nb : Pointer → BitVec 64 → Pointer → Pointer → Pointer → GlobalState → Nat) :
    Prop :=
  ∀ (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer) (s : GlobalState), s.WF →
    s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.globals →
    Fits s.mem msg (8 * msgSz.toNat) → ¬msg.offset.uaddOverflow msgSz → msgSz.toNat < 2 ^ 63 →
    Fits s.mem sig (8 * 64) → ¬sig.offset.uaddOverflow 64#64 → Fits s.mem pk (8 * 32) →
    ¬pk.offset.uaddOverflow 32#64 → s.mem.ShaFit sha → Writable s.mem sha →
    msg.id ≠ sha.id → sig.id ≠ sha.id → pk.id ≠ sha.id →
    _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_verify.args (.value msg) (.value msgSz)
          (.value sig) (.value pk) (.value sha))
        s =
      let res :=
        Avx512.fd_ed25519_verify.spec Avx512.fd_ed25519_base_point_wnaf_table.point msgSz
          (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + nb msg msgSz sig pk sha s⟩,
            mem := res.mem s.mem sha })

/-- `VerifyCallEq` for some frame size. -/
def VerifyCallSpec : Prop :=
  ∃ nb, VerifyCallEq nb

/-- `fd_ed25519_verify_cached`'s type, a parameter of the `_cached` lift. -/
abbrev VerifyCached :=
  Vals [.ptr, .bv 64, .ptr, .ptr, .ptr, .ptr] → EffectM (Vals [.bv 32])

/-- `fd_ed25519_verify_cached( msg, msg_sz, sig, public_key, sha, cache )` returns what
`fd_ed25519_verify` returns: `verifyCached` returns the code `VerifyCallSpec` gives, leaves a
`WF` state, and changes only the hash object's and the cache's blocks and blocks it allocates.
`G` are the globals it needs. -/
def VerifyCachedCallSpec (verifyCached : VerifyCached) (G : List Global) (cache : Pointer) :
    Prop :=
  ∀ (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer) (s : GlobalState), s.WF →
    s.mem.Globals G → Fits s.mem msg (8 * msgSz.toNat) → ¬msg.offset.uaddOverflow msgSz →
    msgSz.toNat < 2 ^ 63 → Fits s.mem sig (8 * 64) → ¬sig.offset.uaddOverflow 64#64 →
    Fits s.mem pk (8 * 32) → ¬pk.offset.uaddOverflow 32#64 → s.mem.ShaFit sha →
    Writable s.mem sha → msg.id ≠ sha.id → sig.id ≠ sha.id → pk.id ≠ sha.id →
    msg.id ≠ cache.id → sig.id ≠ cache.id → pk.id ≠ cache.id → sha.id ≠ cache.id →
    ∃ s',
      verifyCached
          (.cons (.value msg) (.cons (.value msgSz) (.cons (.value sig) (.cons (.value pk)
            (.cons (.value sha) (.cons (.value cache) .nil)))))) s =
        .value
          (.cons
              (.value
                (Avx512.fd_ed25519_verify.spec Avx512.fd_ed25519_base_point_wnaf_table.point
                    msgSz (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                    (s.mem.readAt sha 1024)).ret)
              .nil,
            s') ∧
        s'.WF ∧
        s.mem.SameOn s'.mem fun b => b ≠ sha.id ∧ b ≠ cache.id ∧ b.id < s.alloc.nextFreeBlock

/-! ## `verify_x8` -/

/-- `fd_ed25519_lane_base_table`'s ulongs. -/
noncomputable def x8Tbl (i : Nat) : BitVec 64 :=
  if h : i < 2580 then _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit[i] else 0

/-- The digest `verify_x8` uses for item `it` at `m`: SHA-512 of `R ‖ A ‖ msg` by Ref's streaming
hash (from any buffer: `fd_ed25519_verify.hash_eq`). -/
def Item.digest (m : MemoryState) (it : Item) : BitVec 512 :=
  Words8.bits (fd_ed25519_verify.hash 0#1024 (it.readR m) (it.readA m) it.msgSz (it.readMsg m)).2

/-- `verify_x8`'s lanes on the items `it j`, `j < cnt`, at `m` (`0` in the lanes past them,
which `x8` does not read). -/
noncomputable def x8Of (m : MemoryState) (it : Nat → Item) (cnt : Nat) : X8 :=
  x8 (laneConsts x8Tbl) cnt (fun j => if j.val < cnt then (it j).readR m else 0)
    (fun j => if j.val < cnt then (it j).readS m else 0)
    (fun j => if j.val < cnt then (it j).readA m else 0)
    (fun j => if j.val < cnt then (it j).digest m else 0)

/-- Item `j`'s code (`0` past the lanes). -/
def X8.resultAt (X : X8) (j : Nat) : BitVec 32 :=
  if h : j < 8 then X.result ⟨j, h⟩ else 0

/-- Item `j` is live (`false` past the lanes). -/
def X8.liveAt (X : X8) (j : Nat) : Bool :=
  if h : j < 8 then X.live ⟨j, h⟩ else false

/-- `codes j` stored at `results[j]` for `j < n`, in order. -/
def storeResults (m : MemoryState) (results : Pointer) (codes : Nat → BitVec 32) :
    Nat → MemoryState
  | 0 => m
  | n + 1 =>
    (storeResults m results codes n).storeAt (results.add (BitVec.ofNat 64 (n * 4))) (codes n)

/-- The hash object `verify_x8` leaves for item `it`, its inputs read at `m₀`: `fd_sha512_fini`'s
after `init` and the appends of `R`, `A` and the message. -/
def Item.shaState (m₀ : MemoryState) (it : Item) : ShaState :=
  (fd_ed25519_verify.hash (m₀.readAt it.sha 1024) (it.readR m₀) (it.readA m₀) it.msgSz
      (it.readMsg m₀)).1

/-- The hash objects of the items `j < n` with `long j` after their streaming SHA-512, in order:
`init`'s stores, then `shaState`. -/
def streamMem (m₀ : MemoryState) (it : Nat → Item) (long : Nat → Bool) : Nat → MemoryState
  | 0 => m₀
  | n + 1 =>
    let m := streamMem m₀ it long n
    if long n then (fd_sha512_init.stores m (it n).sha).storeSha (it n).sha ((it n).shaState m₀)
    else m

/-- The memory `verify_x8` leaves on `cnt` items at `m`: the hash objects of the live items whose
messages are longer than `LANE_HASH_COPY_MAX` (1232) bytes after the streaming SHA-512, then the
codes at `results[j]`. -/
noncomputable def x8Mem (m : MemoryState) (results : Pointer) (it : Nat → Item) (cnt : Nat) :
    MemoryState :=
  let X := x8Of m it cnt
  storeResults (streamMem m it (fun j => X.liveAt j && 1232 < (it j).msgSz.toNat) cnt) results
    X.resultAt cnt

/-- `verify_x8( msgs, msg_szs, sigs, public_keys, shas, results, cnt )` on a batch of `cnt ≤ 8`
items stores each item's `x8` code at `results[j]` and the streamed items' hash objects
(`x8Mem`); its frame `nb …` blocks. -/
def X8CallEq (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global)
    (nb : Arrays → (Nat → Item) → Nat → GlobalState → Nat) : Prop :=
  ∀ (a : Arrays) (it : Nat → Item) (cnt : BitVec 64) (s : GlobalState), s.WF →
    s.mem.Globals ((_root_.Firedancer.Lane.Mlir.verify_x8 batch).globals ++ G) →
    cnt.toNat ≤ 8 → BatchOk s.mem a it cnt.toNat →
    (_root_.Firedancer.Lane.Mlir.verify_x8 batch).call
        (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value a.msgs) (.value a.msgSzs)
          (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value cnt))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + nb a it cnt.toNat s⟩,
            mem := x8Mem s.mem a.results it cnt.toNat })

/-- `X8CallEq` for some frame size. -/
def X8CallSpec (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global) :
    Prop :=
  ∃ nb, X8CallEq batch G nb

/-! ## The multi-buffer SHA-512 -/

/-- SHA-512 of the `sz` bytes `data` as `fd_sha512_fini` stores it: Ref's streaming hash, one
`append` after `init`. -/
def sha512Bits (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) : BitVec 512 :=
  Words8.bits
    (fd_sha512_fini.spec (fd_sha512_append.spec ⟨0#1024, sha512IV, 0#64, 0#64, 0#64⟩ sz data)).2

/-- The digests of the `n i` bytes at `d i` (read at `m₀`) stored at `h i`, `i < k`, in order. -/
def storeDigests (m₀ : MemoryState) (d : Nat → Pointer) (n : Nat → BitVec 64)
    (h : Nat → Pointer) : Nat → MemoryState
  | 0 => m₀
  | k + 1 =>
    (storeDigests m₀ d n h k).storeAt (h k) (sha512Bits (n k) (m₀.readAt (d k) (8 * (n k).toNat)))

/-- `fd_sha512_private_batch_avx512( cnt, data, sz, hash )`, `1 ≤ cnt ≤ 8`: with `data[i]`,
`sz[i]`, `hash[i]` holding `d i`, `n i`, `h i`, the inputs known and room at the outputs, each
output apart from the arrays, the inputs and the other outputs, it stores the digests
(`storeDigests`); its frame `nb …` blocks. -/
def BatchCallEq (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global)
    (nb : BitVec 64 → Pointer → Pointer → Pointer → GlobalState → Nat) : Prop :=
  ∀ (cnt : BitVec 64) (data sz hash : Pointer) (d : Nat → Pointer) (n : Nat → BitVec 64)
    (h : Nat → Pointer) (s : GlobalState), s.WF → s.mem.Globals G → 0 < cnt.toNat →
    cnt.toNat ≤ 8 →
    (∀ i < cnt.toNat,
        InBounds s.mem (data.add (BitVec.ofNat 64 (i * 8))) 64 ∧
          s.mem.loadPtr (data.add (BitVec.ofNat 64 (i * 8))) = .value (d i) ∧
          Fits s.mem (sz.add (BitVec.ofNat 64 (i * 8))) 64 ∧
          s.mem.readAt (sz.add (BitVec.ofNat 64 (i * 8))) 64 = n i ∧
          InBounds s.mem (hash.add (BitVec.ofNat 64 (i * 8))) 64 ∧
          s.mem.loadPtr (hash.add (BitVec.ofNat 64 (i * 8))) = .value (h i) ∧
          Fits s.mem (d i) (8 * (n i).toNat) ∧ ¬(d i).offset.uaddOverflow (n i) ∧
          Room s.mem (h i) 512) →
    (∀ i < cnt.toNat,
        (Range.of (h i) 512).Disjoint (Range.of data 512) ∧
          (Range.of (h i) 512).Disjoint (Range.of sz 512) ∧
          (Range.of (h i) 512).Disjoint (Range.of hash 512) ∧
          (∀ k < cnt.toNat, (Range.of (h i) 512).Disjoint (Range.of (d k) (8 * (n k).toNat))) ∧
          ∀ k < cnt.toNat, i ≠ k → (Range.of (h i) 512).Disjoint (Range.of (h k) 512)) →
    batch (.cons (.value cnt) (.cons (.value data) (.cons (.value sz) (.cons (.value hash) .nil))))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + nb cnt data sz hash s⟩,
            mem := storeDigests s.mem d n h cnt.toNat })

/-- `BatchCallEq` for some frame size. -/
def BatchSpec (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (G : List Global) :
    Prop :=
  ∃ nb, BatchCallEq batch G nb

/-! ## Lemmas -/

/-- `storeResults`' stores. -/
theorem _root_.MLIR.MemoryState.StoresOff.storeResults {K : BlockId → Prop} {m : MemoryState}
    (hp : ¬K results.id) (codes : Nat → BitVec 32) (n : Nat) :
    m.StoresOff K (Lane.storeResults m results codes n) := by
  induction n with
  | zero => exact .refl m
  | succ n ih => exact .storeAt _ ih hp

/-- The streamed hash objects' stores. -/
theorem _root_.MLIR.MemoryState.StoresOff.streamMem {K : BlockId → Prop} {m : MemoryState}
    {it : Nat → Item} {long : Nat → Bool} (n : Nat)
    (hp : ∀ j < n, long j = true → ¬K (it j).sha.id) :
    m.StoresOff K (Lane.streamMem m it long n) := by
  induction n with
  | zero => exact .refl m
  | succ n ih =>
    have ih := ih fun j hj => hp j (by omega)
    simp only [Lane.streamMem]
    split
    · rename_i hl
      have hn := hp n (by omega) hl
      exact ((ih.trans (MemoryState.StoresOff.initStores hn)).storeSha hn)
    · exact ih

/-- `verify_x8`'s memory. -/
theorem _root_.MLIR.MemoryState.StoresOff.x8Mem {K : BlockId → Prop} {m : MemoryState}
    {results : Pointer} {cnt : Nat} {it : Nat → Item} (hr : ¬K results.id)
    (hs : ∀ j < cnt, ¬K (it j).sha.id) : m.StoresOff K (Lane.x8Mem m results it cnt) :=
  (MemoryState.StoresOff.streamMem cnt fun j hj _ => hs j hj).trans
    (MemoryState.StoresOff.storeResults hr _ cnt)

/-! ### Facts past `verify_x8`'s memory -/

theorem _root_.MLIR.Room.x8Mem {m : MemoryState} {results : Pointer} {it : Nat → Item}
    {cnt : Nat} (h : Room m q w) : Room (x8Mem m results it cnt) q w :=
  (MemoryState.StoresOff.x8Mem (K := fun _ => False) (m := m) (fun h => h)
    fun _ _ h => h).room h

theorem _root_.MLIR.MemoryState.Globals.x8Mem {m : MemoryState} {results : Pointer}
    {it : Nat → Item} {cnt : Nat} (h : m.Globals G) : (x8Mem m results it cnt).Globals G :=
  (MemoryState.StoresOff.x8Mem (K := fun _ => False) (m := m) (fun h => h)
    fun _ _ h => h).globals h

theorem _root_.MLIR.GlobalState.WF.x8Mem_mk {s : GlobalState} {results : Pointer}
    {it : Nat → Item} {cnt : Nat} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, x8Mem s.mem results it cnt⟩ : GlobalState).WF :=
  (MemoryState.StoresOff.x8Mem (K := fun _ => False) (m := s.mem) (fun h => h)
    fun _ _ h => h).wf h.add_blocks

/-! ### Reading back `verify_x8`'s codes -/

/-- `results[j]` after the codes `j < n` are stored: code `j`. -/
theorem readAt_storeResults {m : MemoryState} {results : Pointer} {codes : Nat → BitVec 32}
    {n j : Nat} (hj : j < n) (hoff : results.offset.toNat + 4 * n < 2 ^ 64)
    (hroom : Room m (results.add (BitVec.ofNat 64 (j * 4))) 32) :
    (storeResults m results codes n).readAt (results.add (BitVec.ofNat 64 (j * 4))) 32 =
      codes j := by
  induction n with
  | zero => omega
  | succ n ih =>
    simp only [storeResults]
    by_cases hjn : j = n
    · subst hjn
      exact MemoryState.readAt_storeAt_self
        ((MemoryState.StoresOff.storeResults (K := fun _ => False) (m := m) (fun h => h) codes
          j).room hroom) _
    · rw [MemoryState.readAt_storeAt_disjoint, ih (by omega) (by omega)]
      have h1 : ¬results.offset.uaddOverflow (BitVec.ofNat 64 (n * 4)) := by
        simp [BitVec.uaddOverflow]; omega
      have h2 : ¬results.offset.uaddOverflow (BitVec.ofNat 64 (j * 4)) := by
        simp [BitVec.uaddOverflow]; omega
      simp only [Range.Disjoint, Range.of, Pointer.offsetInBits_add h1,
        Pointer.offsetInBits_add h2, BitVec.toNat_ofNat]
      right
      rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
      omega

/-- A read outside `results`' first `n` codes: as before them. -/
theorem readAt_storeResults_of_disjoint {m : MemoryState} {results q : Pointer}
    {codes : Nat → BitVec 32} {n w : Nat}
    (hq : ∀ j < n,
      (Range.of (results.add (BitVec.ofNat 64 (j * 4))) 32).Disjoint (Range.of q w)) :
    (storeResults m results codes n).readAt q w = m.readAt q w := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [storeResults]
    rw [MemoryState.readAt_storeAt_disjoint (hq n (by omega)), ih fun j hj => hq j (by omega)]

/-- `verify_x8`'s code for item `j < cnt` at `results[j]`. -/
theorem readAt_x8Mem {m : MemoryState} {results : Pointer} {it : Nat → Item} {cnt j : Nat}
    (hj : j < cnt) (hoff : results.offset.toNat + 4 * cnt < 2 ^ 64)
    (hroom : Room m (results.add (BitVec.ofNat 64 (j * 4))) 32) :
    (x8Mem m results it cnt).readAt (results.add (BitVec.ofNat 64 (j * 4))) 32 =
      (x8Of m it cnt).resultAt j :=
  readAt_storeResults hj hoff
    ((MemoryState.StoresOff.streamMem (K := fun _ => False) (m := m) (it := it) cnt
      fun _ _ _ h => h).room hroom)

/-- A read outside `results`' first `cnt` codes and the hash objects: as before `verify_x8`. -/
theorem readAt_x8Mem_of_disjoint {m : MemoryState} {results q : Pointer} {it : Nat → Item}
    {cnt w : Nat} (hsha : ∀ j < cnt, q.id ≠ (it j).sha.id)
    (hq : ∀ j < cnt,
      (Range.of (results.add (BitVec.ofNat 64 (j * 4))) 32).Disjoint (Range.of q w)) :
    (x8Mem m results it cnt).readAt q w = m.readAt q w := by
  rw [x8Mem, readAt_storeResults_of_disjoint hq]
  exact (MemoryState.StoresOff.streamMem (K := fun b => b = q.id) (m := m) (it := it) cnt
    fun j hj _ h => hsha j hj h.symm).sameOn.readAt rfl

end

end MLIR.Firedancer.Lane

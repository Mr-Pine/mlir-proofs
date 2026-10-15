module

public import Firedancer.Lane.verify_x8.Codes
public import Firedancer.Lane.verify_x8.Lanes
public import Firedancer.Math.Sha512
import Std.Data.ExtHashMap.Lemmas

/-! The memory of `verify_x8`'s hashes: writes that keep blocks' shapes (`Mods`), the hash inputs
`hash_input[j]`, the digests `hashes[j]`, the batch's queue, and the loop's invariant `Inv`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Ed25519
open _root_.Firedancer.Lane.Mlir (verify_x8)

@[expose] public section

/-! ## Writes keeping blocks' shapes -/

/-- `m'` is `m` after writes into blocks outside `K`, each keeping its block's shape. -/
inductive Mods (K : BlockId → Prop) : MemoryState → MemoryState → Prop
  | refl (m : MemoryState) : Mods K m m
  | modify {m m' : MemoryState} {i : BlockId} (f : MemoryBlock → MemoryBlock) :
    Mods K m m' → ¬K i → (∀ b, (f b).shape = b.shape) → Mods K m (m'.modifyBlock i f)

namespace Mods

variable {K : BlockId → Prop} {m m' : MemoryState}

/-- The blocks in `K` are kept, and the addresses and globals. -/
theorem sameOn (h : Mods K m m') : m.SameOn m' K := by
  induction h with
  | refl => exact MemoryState.SameOn.refl _
  | @modify _ i f _ hi _ ih =>
    refine ⟨fun b hb => ?_, ih.2.1, ih.2.2⟩
    have hne : b ≠ i := fun e => hi (e ▸ hb)
    rw [MemoryState.getElem?_modifyBlock_ne hne, ih.1 b hb]

/-- Each block keeps its shape. -/
theorem sameShape (h : Mods K m m') : m'.SameShape m := by
  induction h with
  | refl => exact fun _ => rfl
  | modify f _ _ hf ih => exact fun i => (MemoryState.sameShape_modifyBlock hf i).trans (ih i)

/-- `WF` under any allocation counter. -/
theorem wf (h : Mods K m m') {a : AllocState} (hwf : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m'⟩ : GlobalState).WF := by
  induction h with
  | refl => exact hwf
  | modify f _ _ hf ih =>
    refine (GlobalState.WF_modifyBlock (s := ⟨a, m⟩) (m := _) (i := _) fun b => ?_).2 ih
    have := hf b
    simp only [MemoryBlock.shape, Prod.mk.injEq] at this
    exact ⟨this.1, this.2.2⟩

theorem inBounds (h : Mods K m m') (hp : InBounds m p w) : InBounds m' p w :=
  hp.of_sameShape h.sameShape.symm

theorem room (h : Mods K m m') (hp : Room m p w) : Room m' p w :=
  hp.of_sameShape h.sameShape.symm

theorem writable (h : Mods K m m') (hp : Writable m p) : Writable m' p :=
  hp.of_sameShape h.sameShape.symm

theorem storeAt (h : Mods K m m') (hp : ¬K p.id) (x : BitVec w) : Mods K m (m'.storeAt p x) :=
  .modify _ h hp fun _ => rfl

theorem storePtr (h : Mods K m m') (hp : ¬K p.id) (x : Pointer) : Mods K m (m'.storePtr p x) :=
  .modify _ h hp fun _ => rfl

theorem storeWords8 (h : Mods K m m') (hp : ¬K p.id) (v : Vector (BitVec 64) 8) :
    Mods K m (m'.storeWords8 p v) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := hp
  unfold MemoryState.storeWords8
  repeat refine storeAt ?_ (hp' _) _
  exact h.storeAt hp _

theorem storeSha (h : Mods K m m') (hp : ¬K p.id) (v : ShaState) : Mods K m (m'.storeSha p v) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := hp
  unfold MemoryState.storeSha
  refine storeWords8 ?_ (hp' _) _
  repeat refine storeAt ?_ (hp' _) _
  exact h.storeAt hp _

theorem initStores (h : Mods K m m') (hp : ¬K p.id) : Mods K m (fd_sha512_init.stores m' p) := by
  have hp' (o : BitVec 64) : ¬K (p.add o).id := hp
  unfold fd_sha512_init.stores
  repeat refine storeAt ?_ (hp' _) _
  exact h

theorem hashMem (h : Mods K m m') (hp : ¬K p.id) (hk : ¬K k.id) (X : ShaState)
    (v : Vector (BitVec 64) 8) : Mods K m (fd_ed25519_verify.hashMem m' p k X v) :=
  ((h.initStores hp).storeSha hp X).storeWords8 hk v

theorem storeDigests {d : Nat → Pointer} {n : Nat → BitVec 64} {hs : Nat → Pointer} (k : Nat)
    (hk : ∀ i < k, ¬K (hs i).id) : Mods K m (Lane.storeDigests m d n hs k) := by
  induction k with
  | zero => exact .refl m
  | succ k ih => exact (ih fun i hi => hk i (by omega)).storeAt (hk k (by omega)) _

end Mods

/-! ## The items' inputs -/

/-- Item `j` is hashed by the batch: live, its message at most `LANE_HASH_COPY_MAX` bytes. -/
noncomputable def Call.short (c : Call) (j : Nat) : Bool :=
  c.X.liveAt j && decide ((c.it j).msgSz.toNat < 1233)

/-- `hash_input[j]`. -/
abbrev Call.row (c : Call) (j : Nat) : Pointer :=
  (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296))

/-- `hashes[j]`. -/
abbrev Call.hashAt (c : Call) (j : Nat) : Pointer :=
  (c.s.slot 31).add (BitVec.ofNat 64 (j * 64))

/-- The memory outside the frame once the items below `j` are hashed: the long ones' hash objects
streamed, the codes stored. -/
noncomputable def Call.memJ (c : Call) (j : Nat) : MemoryState :=
  storeResults (streamMem c.s.mem c.it c.long j) c.a.results c.code1 c.cnt

/-- The blocks below the frame that the items below `j` leave as they were: not `results`', not a
streamed hash object's. -/
def Call.Keep (c : Call) (j : Nat) (b : BlockId) : Prop :=
  b.id < c.s.alloc.nextFreeBlock ∧ b ≠ c.a.results.id ∧
    ∀ i < j, c.long i = true → b ≠ (c.it i).sha.id

/-- Below the frame, outside `results` and the streamed hash objects, a state at `memJ j` holds the
entry memory. -/
theorem Call.sameOn_keep (c : Call) {S : GlobalState} {j : Nat} (hB : c.Base S (c.memJ j)) :
    c.s.mem.SameOn S.mem (c.Keep j) := by
  have h1 : c.s.mem.StoresOff (fun b => b ≠ c.a.results.id ∧
      ∀ i < j, c.long i = true → b ≠ (c.it i).sha.id) (c.memJ j) :=
    (MemoryState.StoresOff.streamMem j fun i hi hl h => h.2 i hi hl rfl).trans
      (MemoryState.StoresOff.storeResults (fun h => h.1 rfl) _ _)
  exact (h1.sameOn.mono fun _ h => h.2).trans (hB.sameOn.mono fun _ h => h.1)

/-- A live item is one of the batch's. -/
theorem Call.lt_cnt_of_live (c : Call) {i : Nat} (h : c.X.liveAt i = true) : i < c.cnt := by
  unfold X8.liveAt at h
  split at h
  · rename_i hi
    rw [x8Of_live] at h
    simp only [Bool.and_eq_true] at h
    have h1 : (decide (i < c.cnt) && _) = true := h.1.1.1.1
    rw [Bool.and_eq_true] at h1
    simpa using h1.1
  · simp at h

/-- An input block below the frame is kept. -/
theorem Call.keep_ro (c : Call) (hc : c.Ok) {j : Nat} {b : BlockId}
    (hb : c.a.ReadOnly c.it c.cnt b) (hlt : b.id < c.s.alloc.nextFreeBlock) : c.Keep j b := by
  have hsep := hc.batch.sep
  refine ⟨hlt, fun h => hsep.1 (h ▸ hb), fun i hi hl h => ?_⟩
  have hic : i < c.cnt :=
    c.lt_cnt_of_live (by simp only [Call.long, Bool.and_eq_true] at hl; exact hl.1)
  exact (hsep.2.1 i hic).1 (h ▸ hb)

/-- Item `j`'s inputs at a state at `memJ j`: its array entries, signature, key, message and hash
object, as at the entry. -/
structure Call.ItemAt (c : Call) (j : Nat) (S : GlobalState) : Prop where
  szf : Fits S.mem (c.a.msgSzs.add (BitVec.ofNat 64 (j * 8))) 64
  szr : S.mem.readAt (c.a.msgSzs.add (BitVec.ofNat 64 (j * 8))) 64 = (c.it j).msgSz
  sigb : InBounds S.mem (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) 64
  sigr : S.mem.loadPtr (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).sig
  pkb : InBounds S.mem (c.a.pks.add (BitVec.ofNat 64 (j * 8))) 64
  pkr : S.mem.loadPtr (c.a.pks.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).pk
  msgb : InBounds S.mem (c.a.msgs.add (BitVec.ofNat 64 (j * 8))) 64
  msgr : S.mem.loadPtr (c.a.msgs.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).msg
  shab : InBounds S.mem (c.a.shas.add (BitVec.ofNat 64 (j * 8))) 64
  shar : S.mem.loadPtr (c.a.shas.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).sha
  sig : Fits S.mem (c.it j).sig 256
  sig_r : S.mem.readAt (c.it j).sig 256 = (c.it j).readR c.s.mem
  pk : Fits S.mem (c.it j).pk 256
  pk_r : S.mem.readAt (c.it j).pk 256 = (c.it j).readA c.s.mem
  msg : Fits S.mem (c.it j).msg (8 * (c.it j).msgSz.toNat)
  msg_r : S.mem.readAt (c.it j).msg (8 * (c.it j).msgSz.toNat) = (c.it j).readMsg c.s.mem
  sha : S.mem.ShaFit (c.it j).sha
  shaw : Writable S.mem (c.it j).sha
  sha_r : S.mem.readAt (c.it j).sha 1024 = c.s.mem.readAt (c.it j).sha 1024

/-- Item `j`'s inputs, at a state at `memJ j`. -/
theorem Call.itemAt (c : Call) (hc : c.Ok) {S : GlobalState} {j : Nat} (hj : j < c.cnt)
    (hB : c.Base S (c.memJ j)) : c.ItemAt j S := by
  have hso := c.sameOn_keep hB
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩ := hc.batch.holds j hj
  obtain ⟨o1, -, -, o4, -, o6, -, o8, o9⟩ := hc.batch.ok j hj
  have hsep := hc.batch.sep
  have hlt {p : Pointer} {w : Nat} (h : InBounds c.s.mem p w) : p.id.id < c.s.alloc.nextFreeBlock :=
    hc.wf.id_lt_of_inBounds h
  have k1 : c.Keep j (c.a.msgSzs.add (BitVec.ofNat 64 (j * 8))).id :=
    c.keep_ro hc (Or.inr (Or.inl rfl)) (hlt h3.inBounds)
  have k2 : c.Keep j (c.a.sigs.add (BitVec.ofNat 64 (j * 8))).id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inl rfl))) (hlt h5)
  have k3 : c.Keep j (c.a.pks.add (BitVec.ofNat 64 (j * 8))).id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inr (Or.inl rfl)))) (hlt h7)
  have k4 : c.Keep j (c.a.msgs.add (BitVec.ofNat 64 (j * 8))).id :=
    c.keep_ro hc (Or.inl rfl) (hlt h1)
  have k5 : c.Keep j (c.a.shas.add (BitVec.ofNat 64 (j * 8))).id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))) (hlt h9)
  have ksig : c.Keep j (c.it j).sig.id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inl rfl)⟩)))))
      (hlt o4.inBounds)
  have kpk : c.Keep j (c.it j).pk.id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inr rfl)⟩)))))
      (hlt o6.inBounds)
  have kmsg : c.Keep j (c.it j).msg.id :=
    c.keep_ro hc (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inl rfl⟩))))) (hlt o1.inBounds)
  have ksha : c.Keep j (c.it j).sha.id := by
    refine ⟨hlt o8.1.inBounds, (hsep.2.1 j hj).2, fun i hi hl => ?_⟩
    exact hsep.2.2 j hj i
      (c.lt_cnt_of_live (by simp only [Call.long, Bool.and_eq_true] at hl; exact hl.1)) (by omega)
  exact ⟨hso.fits k1 h3, (hso.readAt k1).trans h4, hso.inBounds k2 h5, (hso.loadPtr k2).trans h6,
    hso.inBounds k3 h7, (hso.loadPtr k3).trans h8, hso.inBounds k4 h1, (hso.loadPtr k4).trans h2,
    hso.inBounds k5 h9, (hso.loadPtr k5).trans h10, hso.fits ksig (o4.mono (by decide)),
    hso.readAt ksig, hso.fits kpk o6, hso.readAt kpk, hso.fits kmsg o1, hso.readAt kmsg,
    hso.shaFit ksha o8, hso.writable ksha o9, hso.readAt ksha⟩

/-! ## The batch's digests -/

/-- Bytes determine a whole-byte vector. -/
theorem bytesLE_inj {w : Nat} {x y : BitVec w} (hw : w % 8 = 0) (h : bytesLE x = bytesLE y) :
    x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hl : i / 8 < (bytesLE x).length := by simp; omega
  have hl' : i / 8 < (bytesLE y).length := by simp; omega
  have := congrArg (·.getLsbD (i % 8)) (List.getElem_of_eq h hl)
  simp only [getElem_bytesLE, BitVec.getLsbD_extractLsb'] at this
  have e : 8 * (i / 8) + i % 8 = i := by omega
  simpa [show i % 8 < 8 by omega, e] using this

/-- A read of `a + b` bytes: the first `a`, then the `b` after them. -/
theorem bytesLE_readAt_add {m : MemoryState} {p : Pointer} {a b : Nat} (ha : a < 2 ^ 64)
    (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 a)) (hb : InBounds m p (8 * (a + b))) :
    bytesLE (m.readAt p (8 * (a + b))) =
      bytesLE (m.readAt p (8 * a)) ++ bytesLE (m.readAt (p.add (BitVec.ofNat 64 a)) (8 * b)) := by
  obtain ⟨blk, hblk, hsz⟩ := hb
  have hoff : (p.add (BitVec.ofNat 64 a)).offsetInBits = p.offsetInBits + 8 * a := by
    rw [Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha]; omega
  have h8 : p.offsetInBits % 8 = 0 := by simp [Pointer.offsetInBits]
  unfold MemoryState.readAt
  rw [show (p.add (BitVec.ofNat 64 a)).id = p.id from rfl, hblk]
  dsimp only
  unfold MemoryBlock.lengthInBits at hsz
  rw [hoff, bytesLE_extractLsb' _ h8 (by omega) hsz, bytesLE_extractLsb' _ h8 (by omega) (by omega),
    bytesLE_extractLsb' _ (by omega) (by omega) (by omega), show 8 * (a + b) / 8 = a + b by omega,
    show 8 * a / 8 = a by omega, show 8 * b / 8 = b by omega,
    show (p.offsetInBits + 8 * a) / 8 = p.offsetInBits / 8 + a by omega, List.take_add,
    List.drop_drop]

/-- The bytes of `sha512Bits`: SHA-512 of the data's. -/
theorem bytesLE_sha512Bits (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    bytesLE (sha512Bits sz data) = Sha512.digest (bytesLE data) := by
  have h := (ShaState.absorbed_init 0#1024).append sz data
  rw [List.nil_append] at h
  exact h.fini

/-- `hash_input[j]` holding `R ‖ A ‖ msg`: the batch's digest is the item's. -/
theorem row_digest {m m₀ : MemoryState} {r : Pointer} {it : Item} (hsz : it.msgSz.toNat < 1233)
    (hov : ¬r.offset.uaddOverflow (BitVec.ofNat 64 1296)) (hb : InBounds m r (8 * 1296))
    (hR : m.readAt r 256 = it.readR m₀) (hA : m.readAt (r.add 32#64) 256 = it.readA m₀)
    (hM : m.readAt (r.add 64#64) (8 * it.msgSz.toNat) = it.readMsg m₀) :
    sha512Bits (it.msgSz + 64#64) (m.readAt r (8 * (it.msgSz + 64#64).toNat)) = it.digest m₀ := by
  have hn : (it.msgSz + 64#64).toNat = 32 + (32 + it.msgSz.toNat) := by
    rw [BitVec.toNat_add]; simp; omega
  have hov' (k : Nat) (hk : k ≤ 1296) : ¬r.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le hov (by simp; omega)
  have hbytes : bytesLE (m.readAt r (8 * (it.msgSz + 64#64).toNat)) =
      bytesLE (it.readR m₀) ++ bytesLE (it.readA m₀) ++ bytesLE (it.readMsg m₀) := by
    have e : ∀ w w' (h : w = w'), bytesLE (m.readAt r w) = bytesLE (m.readAt r w') := by
      intro w w' h; subst h; rfl
    have hb32 : InBounds m (r.add (BitVec.ofNat 64 32)) (8 * (32 + it.msgSz.toNat)) :=
      InBounds.add_of_le (hov' 32 (by decide)) (by simp; omega) hb
    have hov32 : ¬(r.add (BitVec.ofNat 64 32)).offset.uaddOverflow (BitVec.ofNat 64 32) := by
      have := hov' 64 (by decide)
      simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat,
        decide_eq_true_eq, ge_iff_le, Nat.not_le] at this ⊢
      omega
    rw [e _ _ (congrArg (8 * ·) hn),
      bytesLE_readAt_add (p := r) (a := 32) (b := 32 + it.msgSz.toNat) (by decide)
        (hov' 32 (by decide)) (hb.mono (by omega)),
      bytesLE_readAt_add (p := r.add (BitVec.ofNat 64 32)) (a := 32) (b := it.msgSz.toNat)
        (by decide) hov32 hb32,
      Pointer.add_add, show (BitVec.ofNat 64 32 + BitVec.ofNat 64 32 : BitVec 64) = 64#64 from rfl,
      show (BitVec.ofNat 64 32 : BitVec 64) = 32#64 from rfl, hM, List.append_assoc]
    rw [show (8 * 32 : Nat) = 256 from rfl, hR, hA]
  apply bytesLE_inj (by decide)
  rw [bytesLE_sha512Bits, hbytes, Item.digest, fd_ed25519_verify.hash_eq]

/-! ## The loop's invariant -/

/-- Item `i`'s digest at `hashes[i]`. -/
def Call.Hashed (c : Call) (S : GlobalState) (i : Nat) : Prop :=
  Fits S.mem (c.hashAt i) 512 ∧ S.mem.readAt (c.hashAt i) 512 = (c.it i).digest c.s.mem

/-- The state at item `j`, `q` items queued (entry `k` item `sel k`), the count aside: the stage's
facts, the slots' room, the queue's entries and inputs, each live item below `j` queued or
hashed. -/
structure Call.Pend (c : Call) (j q : Nat) (sel : Nat → Nat) (S : GlobalState) : Prop where
  base : c.Base S (c.memJ j)
  ks : c.KS S 0 0
  a : c.PointAt S 28 c.decA.1
  r : c.PointAt S 29 c.decR.1
  room30 : Room S.mem (c.s.slot 30) (8 * 10368)
  room31 : Room S.mem (c.s.slot 31) (8 * 512)
  room32 : Room S.mem (c.s.slot 32) (8 * 256)
  q_le : q ≤ j
  sel_lt : ∀ k < q, sel k < j
  sel_short : ∀ k < q, c.short (sel k) = true
  sel_inj : ∀ k < q, ∀ k' < q, sel k = sel k' → k = k'
  data : ∀ k < q,
    S.mem.loadPtr ((c.s.slot 32).add (BitVec.ofNat 64 (k * 8))) = .value (c.row (sel k))
  sz_fits : ∀ k < q, Fits S.mem ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (k * 8))) 64
  sz_read : ∀ k < q,
    S.mem.readAt ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (k * 8))) 64 =
      (c.it (sel k)).msgSz + 64#64
  hash : ∀ k < q,
    S.mem.loadPtr ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (k * 8))) =
      .value (c.hashAt (sel k))
  row_fits : ∀ k < q, Fits S.mem (c.row (sel k)) (8 * ((c.it (sel k)).msgSz + 64#64).toNat)
  row_hash : ∀ k < q,
    sha512Bits ((c.it (sel k)).msgSz + 64#64)
        (S.mem.readAt (c.row (sel k)) (8 * ((c.it (sel k)).msgSz + 64#64).toNat)) =
      (c.it (sel k)).digest c.s.mem
  done : ∀ i < j, c.X.liveAt i = true → (∃ k < q, sel k = i) ∨ c.Hashed S i

/-- `Pend` with the queue's count at `batch->cnt`. -/
structure Call.Inv (c : Call) (j q : Nat) (sel : Nat → Nat) (S : GlobalState) : Prop
    extends c.Pend j q sel S where
  cnt_fits : Fits S.mem ((c.s.slot 32).add 192#64) 64
  cnt_read : S.mem.readAt ((c.s.slot 32).add 192#64) 64 = BitVec.ofNat 64 q

/-! ### Carrying the stage's facts -/

/-- Writes outside blocks below `n` keep the memory below `n`. -/
theorem eraseFrom_of_mods {K : BlockId → Prop} {m m' : MemoryState} {n : Nat} (hm : Mods K m m')
    (hK : ∀ b : BlockId, b.id < n → K b) : m'.eraseFrom n = m.eraseFrom n := by
  have hs := hm.sameOn
  have h1 : (m'.eraseFrom n).mem = (m.eraseFrom n).mem := by
    apply Std.ExtHashMap.ext_getElem?
    intro b
    show (m'.mem.filter fun id _ => id.id < n)[b]? = (m.mem.filter fun id _ => id.id < n)[b]?
    simp only [Std.ExtHashMap.getElem?_filter']
    by_cases hb : b.id < n
    · have := hs.1 b (hK b hb)
      simp only [MemoryState.getElem?_eq] at this
      rw [this]
    · cases m'.mem[b]? <;> cases m.mem[b]? <;> simp [hb]
  cases m
  cases m'
  simp only [MemoryState.eraseFrom] at h1 ⊢
  have h2 := hs.2.1
  have h3 := hs.2.2
  simp only at h2 h3
  rw [h1, h2, h3]

/-- A stage's `Base` past writes keeping `fd_ed25519_lane_base_table` and `identity`, the counter
not lowered. -/
theorem Call.Base.of_mods {c : Call} {S S' : GlobalState} {M M' : MemoryState}
    {K : BlockId → Prop} (h : c.Base S M) (hm : Mods K S.mem S'.mem) (htbl : K c.tbl.id)
    (hidp : K c.idp.id) (hwf : S'.WF) (hle : S.alloc.nextFreeBlock ≤ S'.alloc.nextFreeBlock)
    (hM : S'.mem.eraseFrom c.s.alloc.nextFreeBlock = M') : c.Base S' M' := by
  have hs := hm.sameOn
  have := h.frame
  exact ⟨hwf, hs.globals h.globals, by omega, fun k hk => hm.inBounds (h.slots k hk),
    fun k hk => hm.writable (h.writable k hk), hM, h.tbl_lt, h.idp_lt, hs.fits htbl h.tbl_fits,
    (hs.readAt htbl).trans h.tbl_read, hs.fits hidp h.idp_fits, (hs.readAt hidp).trans h.idp_read⟩

theorem Call.KS.of_sameOn {c : Call} {S S' : GlobalState} {K : BlockId → Prop} {X Y : BitVec 2048}
    (h : c.KS S X Y) (hs : S.mem.SameOn S'.mem K) (h26 : K (c.s.slot 26).id)
    (h27 : K (c.s.slot 27).id) : c.KS S' X Y :=
  ⟨hs.fits h26 h.k_fits, (hs.readAt h26).trans h.k_read, hs.fits h27 h.s_fits,
    (hs.readAt h27).trans h.s_read⟩

theorem Call.PointAt.of_sameOn {c : Call} {S S' : GlobalState} {K : BlockId → Prop} {k : Nat}
    {P : Point} (h : c.PointAt S k P) (hs : S.mem.SameOn S'.mem K) (hk : K (c.s.slot k).id) :
    c.PointAt S' k P :=
  ⟨⟨h.fit.1, hs.fits hk h.fit.2⟩, (hs.readLanePoint_eq hk).trans h.read⟩

/-! ### Offsets in the slots -/

theorem slot_add_offsetInBits (s : GlobalState) (k : Nat) (a : BitVec 64) :
    ((s.slot k).add a).offsetInBits = 8 * a.toNat := by
  simp [Pointer.offsetInBits, Pointer.add]

/-- Two ranges in one slot, apart. -/
theorem slot_disjoint {s : GlobalState} {k : Nat} {a b : BitVec 64} {v w : Nat}
    (h : 8 * a.toNat + v ≤ 8 * b.toNat ∨ 8 * b.toNat + w ≤ 8 * a.toNat) :
    (Range.of ((s.slot k).add a) v).Disjoint (Range.of ((s.slot k).add b) w) := by
  simp only [Range.Disjoint, Range.of, slot_add_offsetInBits]
  omega

/-- Ranges in two slots. -/
theorem slots_disjoint {s : GlobalState} {k l : Nat} (h : k ≠ l) (a b : BitVec 64) (v w : Nat) :
    (Range.of ((s.slot k).add a) v).Disjoint (Range.of ((s.slot l).add b) w) :=
  Or.inl (by simpa [Range.of, Pointer.add_id] using GlobalState.slot_id_ne h)

/-- Two adjacent known ranges: one. -/
theorem Fits.join {m : MemoryState} {p : Pointer} {a b : Nat} (ha : a < 2 ^ 64)
    (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 a)) (h1 : Fits m p (8 * a))
    (h2 : Fits m (p.add (BitVec.ofNat 64 a)) (8 * b)) : Fits m p (8 * (a + b)) := by
  obtain ⟨blk, hblk, hl, _, hd1⟩ := h1
  obtain ⟨blk', hblk', -, hsz2, hd2⟩ := h2
  have hoff : (p.add (BitVec.ofNat 64 a)).offsetInBits = p.offsetInBits + 8 * a := by
    rw [Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha]; omega
  rw [show (p.add (BitVec.ofNat 64 a)).id = p.id from rfl, hblk] at hblk'
  cases hblk'
  rw [hoff] at hsz2 hd2
  refine ⟨blk, hblk, hl, by omega, ?_⟩
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  by_cases hia : i < 8 * a
  · have := congrArg (·.getLsbD i) hd1
    simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, hia, decide_true,
      Bool.true_and] at this ⊢
    simpa [hi] using this
  · have := congrArg (·.getLsbD (i - 8 * a)) hd2
    simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes,
      show i - 8 * a < 8 * b by omega, decide_true, Bool.true_and] at this ⊢
    rw [show p.offsetInBits + 8 * a + (i - 8 * a) = p.offsetInBits + i by omega] at this
    simpa [hi] using this

/-! ### The steps between hand-overs -/

theorem Call.short_sz {c : Call} {j : Nat} (h : c.short j = true) :
    (c.it j).msgSz.toNat < 1233 := by
  simp only [Call.short, Bool.and_eq_true, decide_eq_true_eq] at h
  exact h.2

theorem Call.long_of_short {c : Call} {j : Nat} (h : c.short j = true) : c.long j = false := by
  have := Call.short_sz h
  simp only [Call.long, Bool.and_eq_false_iff, decide_eq_false_iff_not]
  right; omega

theorem Call.memJ_succ_of_not_long {c : Call} {j : Nat} (h : c.long j = false) :
    c.memJ (j + 1) = c.memJ j := by
  simp [Call.memJ, streamMem, h]

/-- An item not live: on to the next. -/
theorem Call.Inv.skip {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hI : c.Inv j q sel S) (hl : c.X.liveAt j = false) : c.Inv (j + 1) q sel S := by
  have hlong : c.long j = false := by simp [Call.long, hl]
  have hP := hI.toPend
  refine ⟨⟨by rw [c.memJ_succ_of_not_long hlong]; exact hP.base, hP.ks, hP.a, hP.r, hP.room30,
    hP.room31, hP.room32, by have := hP.q_le; omega, fun k hk => by have := hP.sel_lt k hk; omega,
    hP.sel_short, hP.sel_inj, hP.data, hP.sz_fits, hP.sz_read, hP.hash, hP.row_fits,
    hP.row_hash, fun i hi hli => ?_⟩, hI.cnt_fits, hI.cnt_read⟩
  have : i ≠ j := fun h => by rw [h, hl] at hli; cases hli
  exact hP.done i (by omega) hli

/-! ### `hash_input[j]` -/

/-- `fd_memcpy`s of `R`, `A` and the message into `hash_input[j]`. -/
def Call.rowMem (c : Call) (m : MemoryState) (j : Nat) (x y : BitVec 256) {n : Nat}
    (z : BitVec (8 * n)) : MemoryState :=
  ((m.storeAt (c.row j) x).storeAt ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64))
      y).storeAt
    ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 64#64)) z

/-- `R` and `A` into `hash_input[j]`, the message empty. -/
def Call.rowMem0 (c : Call) (m : MemoryState) (j : Nat) (x y : BitVec 256) : MemoryState :=
  (m.storeAt (c.row j) x).storeAt ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64)) y

theorem toNat_row_add {j k : Nat} (hj : j < 8) (hk : k < 1296) :
    (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k).toNat = j * 1296 + k := by
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat]; omega

theorem toNat_row {j : Nat} (hj : j < 8) : (BitVec.ofNat 64 (j * 1296)).toNat = j * 1296 := by
  rw [BitVec.toNat_ofNat]; omega

/-- Writes into `hash_input[j]` only, `j` not queued: the queue's state carried. -/
theorem Call.Pend.row {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState} {m' : MemoryState}
    (hP : c.Pend j q sel S) (hj : j < 8) (hm : Mods (· ≠ (c.s.slot 30).id) S.mem m')
    (hrow : ∀ i < 8, i ≠ j → ∀ w ≤ 8 * 1296, m'.readAt (c.row i) w = S.mem.readAt (c.row i) w)
    (hfits : ∀ p w, Fits S.mem p w → Fits m' p w) : c.Pend j q sel ⟨S.alloc, m'⟩ := by
  have hs := hm.sameOn
  have hne (k : Nat) (hk : k ≠ 30) : (c.s.slot k).id ≠ (c.s.slot 30).id := GlobalState.slot_id_ne hk
  have hn (b : BlockId) (hb : b.id < c.s.alloc.nextFreeBlock) : b ≠ (c.s.slot 30).id := by
    rintro rfl; simp at hb; omega
  have h31 (o : BitVec 64) : ((c.s.slot 31).add o).id ≠ (c.s.slot 30).id := hne 31 (by decide)
  have h32 (o : BitVec 64) : ((c.s.slot 32).add o).id ≠ (c.s.slot 30).id := hne 32 (by decide)
  have hbase := hP.base
  have hwf : (⟨S.alloc, m'⟩ : GlobalState).WF := hm.wf hbase.wf
  refine ⟨hbase.of_mods hm (hn _ hbase.tbl_lt) (hn _ hbase.idp_lt) hwf le_rfl
      ((eraseFrom_of_mods hm hn).trans hbase.mem),
    hP.ks.of_sameOn hs (hne 26 (by decide)) (hne 27 (by decide)),
    hP.a.of_sameOn hs (hne 28 (by decide)), hP.r.of_sameOn hs (hne 29 (by decide)),
    hm.room hP.room30, hm.room hP.room31, hm.room hP.room32, hP.q_le, hP.sel_lt, hP.sel_short,
    hP.sel_inj, fun k hk => (hs.loadPtr (h32 _)).trans (hP.data k hk),
    fun k hk => hs.fits (h32 _) (hP.sz_fits k hk),
    fun k hk => (hs.readAt (h32 _)).trans (hP.sz_read k hk),
    fun k hk => (hs.loadPtr (h32 _)).trans (hP.hash k hk),
    fun k hk => hfits _ _ (hP.row_fits k hk), fun k hk => ?_, fun i hi hli => ?_⟩
  · have hlt := hP.sel_lt k hk
    have hsz := Call.short_sz (hP.sel_short k hk)
    dsimp only
    rw [hrow (sel k) (by omega) (by omega) _ (by rw [BitVec.toNat_add]; simp; omega)]
    exact hP.row_hash k hk
  · rcases hP.done i hi hli with h | ⟨hf, hr⟩
    · exact Or.inl h
    · exact Or.inr ⟨hs.fits (h31 _) hf, (hs.readAt (h31 _)).trans hr⟩

theorem Call.Inv.row {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState} {m' : MemoryState}
    (hI : c.Inv j q sel S) (hj : j < 8) (hm : Mods (· ≠ (c.s.slot 30).id) S.mem m')
    (hrow : ∀ i < 8, i ≠ j → ∀ w ≤ 8 * 1296, m'.readAt (c.row i) w = S.mem.readAt (c.row i) w)
    (hfits : ∀ p w, Fits S.mem p w → Fits m' p w) : c.Inv j q sel ⟨S.alloc, m'⟩ :=
  have hne (o : BitVec 64) : ((c.s.slot 32).add o).id ≠ (c.s.slot 30).id :=
    GlobalState.slot_id_ne (by decide)
  ⟨hI.toPend.row hj hm hrow hfits, hm.sameOn.fits (hne _) hI.cnt_fits,
    (hm.sameOn.readAt (hne _)).trans hI.cnt_read⟩

theorem Call.rowMem_mods (c : Call) (m : MemoryState) (j : Nat) (x y : BitVec 256) {n : Nat}
    (z : BitVec (8 * n)) : Mods (· ≠ (c.s.slot 30).id) m (c.rowMem m j x y z) :=
  (((Mods.refl m).storeAt (fun h => h rfl) _).storeAt (fun h => h rfl) _).storeAt (fun h => h rfl) _

theorem Call.rowMem0_mods (c : Call) (m : MemoryState) (j : Nat) (x y : BitVec 256) :
    Mods (· ≠ (c.s.slot 30).id) m (c.rowMem0 m j x y) :=
  ((Mods.refl m).storeAt (fun h => h rfl) _).storeAt (fun h => h rfl) _

theorem Call.rowMem_row (c : Call) (m : MemoryState) {j : Nat} (hj : j < 8) (x y : BitVec 256)
    {n : Nat} (hn : n ≤ 1232) (z : BitVec (8 * n)) :
    ∀ i < 8, i ≠ j → ∀ w ≤ 8 * 1296,
      (c.rowMem m j x y z).readAt (c.row i) w = m.readAt (c.row i) w := by
  intro i hi hij w hw
  have hd (k v : Nat) (hk : k < 1296) (hkv : k + v ≤ 1296) :
      (Range.of ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k))
        (8 * v)).Disjoint (Range.of (c.row i) w) := by
    refine slot_disjoint ?_
    rw [toNat_row_add hj hk, toNat_row hi]
    rcases Nat.lt_or_gt_of_ne hij with h | h
    · right; omega
    · left; omega
  unfold Call.rowMem
  rw [MemoryState.readAt_storeAt_disjoint (hd 64 n (by decide) (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 32 32 (by decide) (by decide)),
    MemoryState.readAt_storeAt_disjoint (by simpa using hd 0 32 (by decide) (by decide))]

theorem Call.rowMem0_row (c : Call) (m : MemoryState) {j : Nat} (hj : j < 8) (x y : BitVec 256) :
    ∀ i < 8, i ≠ j → ∀ w ≤ 8 * 1296,
      (c.rowMem0 m j x y).readAt (c.row i) w = m.readAt (c.row i) w := by
  intro i hi hij w hw
  have hd (k v : Nat) (hk : k < 1296) (hkv : k + v ≤ 1296) :
      (Range.of ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k))
        (8 * v)).Disjoint (Range.of (c.row i) w) := by
    refine slot_disjoint ?_
    rw [toNat_row_add hj hk, toNat_row hi]
    rcases Nat.lt_or_gt_of_ne hij with h | h
    · right; omega
    · left; omega
  unfold Call.rowMem0
  rw [MemoryState.readAt_storeAt_disjoint (hd 32 32 (by decide) (by decide)),
    MemoryState.readAt_storeAt_disjoint (by simpa using hd 0 32 (by decide) (by decide))]

/-- A slot's offsets do not wrap. -/
theorem slot_ov (s : GlobalState) (k : Nat) (a : BitVec 64) :
    ¬(s.slot k).offset.uaddOverflow a := by
  simp [BitVec.uaddOverflow, a.isLt]

/-- The pieces of `hash_input[j]` have room. -/
theorem Call.row_room {c : Call} {m : MemoryState} {j : Nat} (hj : j < 8)
    (h : Room m (c.s.slot 30) (8 * 10368)) {k w : Nat} (hk : k < 1296) (hw : 8 * k + w ≤ 8 * 1296) :
    Room m ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k)) w :=
  Room.add_of_le (slot_ov _ _ _) (by rw [toNat_row_add hj hk]; omega) h

theorem Call.row_ov {c : Call} {j : Nat} (hj : j < 8) {k : Nat} (hk : k ≤ 1296) :
    ¬(c.row j).offset.uaddOverflow (BitVec.ofNat 64 k) := by
  rw [show (c.row j).offset = BitVec.ofNat 64 (j * 1296) by simp [Pointer.add]]
  simp only [BitVec.uaddOverflow, toNat_row hj, BitVec.toNat_ofNat, decide_eq_true_eq]
  omega

theorem Call.rowk_ov {c : Call} {j k l : Nat} (hj : j < 8) (hk : k + l ≤ 1296) (hk' : k < 1296) :
    ¬((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k)).offset.uaddOverflow
      (BitVec.ofNat 64 l) := by
  rw [show ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k)).offset =
    BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 k by simp [Pointer.add]]
  simp only [BitVec.uaddOverflow, toNat_row_add hj hk', BitVec.toNat_ofNat, decide_eq_true_eq]
  omega

/-- `hash_input[j]` after its `fd_memcpy`s: the pieces read back, the whole known. -/
theorem Call.rowMem_reads (c : Call) {m : MemoryState} {j : Nat} (hj : j < 8)
    (hroom : Room m (c.s.slot 30) (8 * 10368)) (x y : BitVec 256) {n : Nat} (hn : n ≤ 1232)
    (z : BitVec (8 * n)) :
    (c.rowMem m j x y z).readAt (c.row j) 256 = x ∧
      (c.rowMem m j x y z).readAt ((c.row j).add 32#64) 256 = y ∧
      (c.rowMem m j x y z).readAt ((c.row j).add 64#64) (8 * n) = z ∧
      Fits (c.rowMem m j x y z) (c.row j) (8 * (32 + (32 + n))) := by
  have r0 : Room m (c.row j) 256 := by
    simpa using c.row_room (k := 0) hj hroom (by decide) (by decide)
  have r32 := c.row_room (k := 32) hj hroom (w := 256) (by decide) (by decide)
  have r64 := c.row_room (k := 64) hj hroom (w := 8 * n) (by decide) (by omega)
  have hd (a b v w : Nat) (ha : a < 1296) (hb : b < 1296) (hab : a + v ≤ b ∨ b + w ≤ a) :
      (Range.of ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 a))
        (8 * v)).Disjoint
        (Range.of ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + BitVec.ofNat 64 b)) (8 * w)) :=
    slot_disjoint (by rw [toNat_row_add hj ha, toNat_row_add hj hb]; omega)
  have d1 := hd 64 0 n 32 (by decide) (by decide) (by omega)
  have d2 := hd 32 0 32 32 (by decide) (by decide) (by omega)
  have d3 := hd 64 32 n 32 (by decide) (by decide) (by omega)
  simp only [BitVec.add_zero, Nat.reduceMul] at d1 d2 d3
  unfold Call.rowMem
  simp only [Pointer.add_add]
  refine ⟨?_, ?_, MemoryState.readAt_storeAt_self r64.storeAt.storeAt _, ?_⟩
  · rw [MemoryState.readAt_storeAt_disjoint d1, MemoryState.readAt_storeAt_disjoint d2,
      MemoryState.readAt_storeAt_self r0]
  · rw [MemoryState.readAt_storeAt_disjoint d3, MemoryState.readAt_storeAt_self r32.storeAt]
  · have f0 := ((Fits.storeAt_self r0 (x := x)).storeAt (x := y)
      (q := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64))).storeAt (x := z)
      (q := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 64#64))
    have f32 := (Fits.storeAt_self (r32.storeAt (q := c.row j) (x := x)) (x := y)).storeAt (x := z)
      (q := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 64#64))
    have f64 := Fits.storeAt_self ((r64.storeAt (q := c.row j) (x := x)).storeAt
      (q := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64)) (x := y)) (x := z)
    have j1 := Fits.join (a := 32) (b := n)
      (p := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64))
      (by decide) (c.rowk_ov (k := 32) hj (by omega) (by decide))
      (by simpa using f32) (by simpa [Pointer.add_add, BitVec.add_assoc] using f64)
    exact Fits.join (a := 32) (by decide) (c.row_ov hj (by decide)) (by simpa using f0)
      (by simpa [Pointer.add_add] using j1)

/-- `hash_input[j]` holding item `j`'s input: its batch digest is the item's. -/
theorem Call.rowMem_hashed (c : Call) {m : MemoryState} {j : Nat} (hj : j < 8)
    (hroom : Room m (c.s.slot 30) (8 * 10368)) (hsz : (c.it j).msgSz.toNat < 1233) :
    Fits (c.rowMem m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem) ((c.it j).readMsg c.s.mem))
        (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat) ∧
      sha512Bits ((c.it j).msgSz + 64#64)
          ((c.rowMem m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)
            ((c.it j).readMsg c.s.mem)).readAt (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat)) =
        (c.it j).digest c.s.mem := by
  obtain ⟨hR, hA, hM, hf⟩ := c.rowMem_reads hj hroom ((c.it j).readR c.s.mem)
    ((c.it j).readA c.s.mem) (n := (c.it j).msgSz.toNat) (by omega) ((c.it j).readMsg c.s.mem)
  have hn : 8 * ((c.it j).msgSz + 64#64).toNat = 8 * (32 + (32 + (c.it j).msgSz.toNat)) := by
    rw [BitVec.toNat_add]; simp; omega
  refine ⟨hn ▸ hf, row_digest hsz (c.row_ov hj le_rfl) ?_ hR hA hM⟩
  exact (hroom.inBounds.of_sameShape (c.rowMem_mods m j _ _ _).sameShape.symm).add_of_le
    (slot_ov _ _ _) (by rw [toNat_row hj]; omega)

/-- `rowMem_hashed` for an empty message: no third `fd_memcpy`. -/
theorem Call.rowMem0_hashed (c : Call) {m : MemoryState} {j : Nat} (hj : j < 8)
    (hroom : Room m (c.s.slot 30) (8 * 10368)) (hsz : (c.it j).msgSz = 0#64) :
    Fits (c.rowMem0 m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem))
        (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat) ∧
      sha512Bits ((c.it j).msgSz + 64#64)
          ((c.rowMem0 m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)).readAt (c.row j)
            (8 * ((c.it j).msgSz + 64#64).toNat)) =
        (c.it j).digest c.s.mem := by
  have r0 : Room m (c.row j) 256 := by
    simpa using c.row_room (k := 0) hj hroom (by decide) (by decide)
  have r32 := c.row_room (k := 32) hj hroom (w := 256) (by decide) (by decide)
  have d2 : (Range.of ((c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64)) 256).Disjoint
      (Range.of (c.row j) 256) := by
    simpa using slot_disjoint (s := c.s) (k := 30) (v := 256) (w := 256)
      (a := BitVec.ofNat 64 (j * 1296) + 32#64) (b := BitVec.ofNat 64 (j * 1296))
      (by rw [toNat_row_add hj (k := 32) (by decide), toNat_row hj]; omega)
  have hR : (c.rowMem0 m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)).readAt (c.row j) 256 =
      (c.it j).readR c.s.mem := by
    unfold Call.rowMem0
    rw [MemoryState.readAt_storeAt_disjoint d2, MemoryState.readAt_storeAt_self r0]
  have hA : (c.rowMem0 m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)).readAt
      ((c.row j).add 32#64) 256 = (c.it j).readA c.s.mem := by
    unfold Call.rowMem0
    simp only [Pointer.add_add]
    exact MemoryState.readAt_storeAt_self r32.storeAt _
  have hM : (c.rowMem0 m j ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)).readAt
      ((c.row j).add 64#64) (8 * (c.it j).msgSz.toNat) = (c.it j).readMsg c.s.mem := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [hsz] at hi
  have hn : 8 * ((c.it j).msgSz + 64#64).toNat = 8 * (32 + 32) := by rw [hsz]; rfl
  refine ⟨hn ▸ ?_, row_digest (by rw [hsz]; decide) (c.row_ov hj le_rfl) ?_ hR hA hM⟩
  · have f0 := (Fits.storeAt_self r0 (x := (c.it j).readR c.s.mem)).storeAt
      (x := (c.it j).readA c.s.mem) (q := (c.s.slot 30).add (BitVec.ofNat 64 (j * 1296) + 32#64))
    have f32 := Fits.storeAt_self (r32.storeAt (q := c.row j) (x := (c.it j).readR c.s.mem))
      (x := (c.it j).readA c.s.mem)
    unfold Call.rowMem0
    exact Fits.join (a := 32) (by decide) (c.row_ov hj (by decide)) (by simpa using f0)
      (by simpa [Pointer.add_add] using f32)
  · exact (hroom.inBounds.of_sameShape (c.rowMem0_mods m j _ _).sameShape.symm).add_of_le
      (slot_ov _ _ _) (by rw [toNat_row hj]; omega)

/-! ### The batch's queue -/

/-- `batch->data[q] = hash_input[j]; batch->sz[q] = v; batch->hash[q] = hashes[j]`. -/
def Call.pushMem (c : Call) (m : MemoryState) (q j : Nat) (v : BitVec 64) : MemoryState :=
  ((m.storePtr ((c.s.slot 32).add (BitVec.ofNat 64 (q * 8))) (c.row j)).storeAt
      ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (q * 8))) v).storePtr
    ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (q * 8))) (c.hashAt j)

theorem toNat_ent {a k : Nat} (hk : k < 8) (ha : a ≤ 192) :
    (BitVec.ofNat 64 a + BitVec.ofNat 64 (k * 8)).toNat = a + k * 8 := by
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat]; omega

/-- Queue entries `k` and `l` of the arrays at `a` and `b` (`0`, `64`, `128`), apart. -/
theorem ent_disjoint {s : GlobalState} {a b k l : Nat} (hk : k < 8) (hl : l < 8) (ha : a ≤ 128)
    (hb : b ≤ 128) (h : a + k * 8 ≠ b + l * 8) (ha8 : a % 64 = 0) (hb8 : b % 64 = 0) :
    (Range.of ((s.slot 32).add (BitVec.ofNat 64 a + BitVec.ofNat 64 (k * 8))) 64).Disjoint
      (Range.of ((s.slot 32).add (BitVec.ofNat 64 b + BitVec.ofNat 64 (l * 8))) 64) :=
  slot_disjoint (by rw [toNat_ent hk (by omega), toNat_ent hl (by omega)]; omega)

/-- `ent_disjoint` against the count at byte 192. -/
theorem ent_cnt_disjoint {s : GlobalState} {a k : Nat} (hk : k < 8) (ha : a ≤ 128) :
    (Range.of ((s.slot 32).add (BitVec.ofNat 64 a + BitVec.ofNat 64 (k * 8))) 64).Disjoint
      (Range.of ((s.slot 32).add 192#64) 64) :=
  slot_disjoint (by rw [toNat_ent hk (by omega)]; simp; omega)

theorem ent_room {s : GlobalState} {m : MemoryState} {a k : Nat} (hk : k < 8) (ha : a ≤ 192)
    (h : Room m (s.slot 32) (8 * 256)) :
    Room m ((s.slot 32).add (BitVec.ofNat 64 a + BitVec.ofNat 64 (k * 8))) 64 :=
  Room.add_of_le (slot_ov _ _ _) (by rw [toNat_ent hk ha]; omega) h

/-- Item `j` queued at entry `q`, its input in `hash_input[j]`. -/
theorem Call.Pend.push {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hP : c.Pend j q sel S) (hj : j < 8) (hs : c.short j = true)
    (hrf : Fits S.mem (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat))
    (hrh : sha512Bits ((c.it j).msgSz + 64#64)
        (S.mem.readAt (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat)) = (c.it j).digest c.s.mem) :
    c.Pend (j + 1) (q + 1) (fun k => if k = q then j else sel k)
      ⟨S.alloc, c.pushMem S.mem q j ((c.it j).msgSz + 64#64)⟩ := by
  have hq := hP.q_le
  have hq8 : q < 8 := by omega
  have hm : Mods (· ≠ (c.s.slot 32).id) S.mem (c.pushMem S.mem q j ((c.it j).msgSz + 64#64)) :=
    (((Mods.refl _).storePtr (fun h => h rfl) _).storeAt (fun h => h rfl) _).storePtr
      (fun h => h rfl) _
  have hsO := hm.sameOn
  have hne (k : Nat) (hk : k ≠ 32) (o : BitVec 64) : ((c.s.slot k).add o).id ≠ (c.s.slot 32).id :=
    GlobalState.slot_id_ne hk
  have hne' (k : Nat) (hk : k ≠ 32) : (c.s.slot k).id ≠ (c.s.slot 32).id :=
    GlobalState.slot_id_ne hk
  have hn (b : BlockId) (hb : b.id < c.s.alloc.nextFreeBlock) : b ≠ (c.s.slot 32).id := by
    rintro rfl; simp at hb; omega
  have hbase := hP.base
  have hwf : (⟨S.alloc, c.pushMem S.mem q j ((c.it j).msgSz + 64#64)⟩ : GlobalState).WF :=
    hm.wf hbase.wf
  -- entry `k`'s three pointers, as `ent_disjoint` writes them
  have e0 (k : Nat) : (c.s.slot 32).add (BitVec.ofNat 64 (k * 8)) =
      (c.s.slot 32).add (BitVec.ofNat 64 0 + BitVec.ofNat 64 (k * 8)) := by simp
  have r0 := ent_room (a := 0) hq8 (by decide) hP.room32
  have r64 := ent_room (a := 64) hq8 (by decide) hP.room32
  have r128 := ent_room (a := 128) hq8 (by decide) hP.room32
  rw [← e0] at r0
  have d01 : (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (q * 8))) 64) := by
    rw [e0]; exact ent_disjoint hq8 hq8 (by decide) (by decide) (by omega) rfl rfl
  have d02 : (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (q * 8))) 64) := by
    rw [e0]; exact ent_disjoint hq8 hq8 (by decide) (by decide) (by omega) rfl rfl
  have d12 : (Range.of ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (q * 8))) 64) :=
    ent_disjoint hq8 hq8 (by decide) (by decide) (by omega) rfl rfl
  -- an older entry `k < q` against the three new ones
  have dk (a b k : Nat) (hk : k < q) (ha : a ≤ 128) (hb : b ≤ 128) (ha8 : a % 64 = 0)
      (hb8 : b % 64 = 0) :
      (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 a + BitVec.ofNat 64 (q * 8))) 64).Disjoint
        (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 b + BitVec.ofNat 64 (k * 8))) 64) :=
    ent_disjoint hq8 (by omega) ha hb (by omega) ha8 hb8
  have hsz := Call.short_sz hs
  refine ⟨hbase.of_mods hm (hn _ hbase.tbl_lt) (hn _ hbase.idp_lt) hwf le_rfl
      ((eraseFrom_of_mods hm hn).trans
        (by rw [c.memJ_succ_of_not_long (Call.long_of_short hs)]; exact hbase.mem)),
    hP.ks.of_sameOn hsO (hne' 26 (by decide)) (hne' 27 (by decide)),
    hP.a.of_sameOn hsO (hne' 28 (by decide)), hP.r.of_sameOn hsO (hne' 29 (by decide)),
    hm.room hP.room30, hm.room hP.room31, hm.room hP.room32, by omega, ?_, ?_, ?_, ?_, ?_, ?_, ?_,
    ?_, ?_, ?_⟩
  · intro k hk
    split
    · omega
    · have := hP.sel_lt k (by omega); omega
  · intro k hk
    split
    · exact hs
    · exact hP.sel_short k (by omega)
  · intro k hk k' hk'
    by_cases h1 : k = q <;> by_cases h2 : k' = q <;> simp only [h1, h2, ↓reduceIte]
    · intro; omega
    · intro h; have := hP.sel_lt k' (by omega); omega
    · intro h; have := hP.sel_lt k (by omega); omega
    · exact hP.sel_inj k (by omega) k' (by omega)
  · intro k hk
    unfold Call.pushMem
    dsimp only
    split
    · rename_i h; subst h
      rw [MemoryState.loadPtr_storePtr_disjoint d02.symm,
        MemoryState.loadPtr_storeAt_disjoint d01.symm, MemoryState.loadPtr_storePtr_self r0]
    · have hk' : k < q := by omega
      have h1 := dk 128 0 k hk' (by decide) (by decide) rfl rfl
      have h2 := dk 64 0 k hk' (by decide) (by decide) rfl rfl
      have h3 := dk 0 0 k hk' (by decide) (by decide) rfl rfl
      rw [← e0] at h1 h2 h3
      simp only [BitVec.zero_add] at h3
      rw [MemoryState.loadPtr_storePtr_disjoint h1, MemoryState.loadPtr_storeAt_disjoint h2,
        MemoryState.loadPtr_storePtr_disjoint h3]
      exact hP.data k hk'
  · intro k hk
    unfold Call.pushMem
    dsimp only
    by_cases h : k = q
    · subst h
      exact Fits.storePtr_of_disjoint (Fits.storeAt_self r64.storePtr) d12.symm
    · have hk' : k < q := by omega
      have h1 := dk 128 64 k hk' (by decide) (by decide) rfl rfl
      have h3 := dk 0 64 k hk' (by decide) (by decide) rfl rfl
      rw [← e0] at h3
      exact Fits.storePtr_of_disjoint (Fits.storeAt (Fits.storePtr_of_disjoint (hP.sz_fits k hk')
        h3)) h1
  · intro k hk
    unfold Call.pushMem
    dsimp only
    split
    · rename_i h; subst h
      rw [MemoryState.readAt_storePtr_disjoint d12.symm,
        MemoryState.readAt_storeAt_self r64.storePtr]
    · have hk' : k < q := by omega
      have h1 := dk 128 64 k hk' (by decide) (by decide) rfl rfl
      have h2 := dk 64 64 k hk' (by decide) (by decide) rfl rfl
      have h3 := dk 0 64 k hk' (by decide) (by decide) rfl rfl
      rw [← e0] at h3
      rw [MemoryState.readAt_storePtr_disjoint h1, MemoryState.readAt_storeAt_disjoint h2,
        MemoryState.readAt_storePtr_disjoint h3]
      exact hP.sz_read k hk'
  · intro k hk
    unfold Call.pushMem
    dsimp only
    split
    · rename_i h; subst h
      rw [MemoryState.loadPtr_storePtr_self r128.storePtr.storeAt]
    · have hk' : k < q := by omega
      have h1 := dk 128 128 k hk' (by decide) (by decide) rfl rfl
      have h2 := dk 64 128 k hk' (by decide) (by decide) rfl rfl
      have h3 := dk 0 128 k hk' (by decide) (by decide) rfl rfl
      rw [← e0] at h3
      rw [MemoryState.loadPtr_storePtr_disjoint h1, MemoryState.loadPtr_storeAt_disjoint h2,
        MemoryState.loadPtr_storePtr_disjoint h3]
      exact hP.hash k hk'
  · intro k hk
    dsimp only
    by_cases h : k = q
    · rw [ite_eq_left h]
      exact hsO.fits (hne 30 (by decide) _) hrf
    · rw [ite_eq_right h]
      exact hsO.fits (hne 30 (by decide) _) (hP.row_fits k (by omega))
  · intro k hk
    dsimp only
    have hr (i : Nat) (w : Nat) :
        (c.pushMem S.mem q j ((c.it j).msgSz + 64#64)).readAt (c.row i) w =
          S.mem.readAt (c.row i) w :=
      hsO.readAt (hne 30 (by decide) _)
    by_cases h : k = q
    · rw [ite_eq_left h, hr]
      exact hrh
    · rw [ite_eq_right h, hr]
      exact hP.row_hash k (by omega)
  · intro i hi hli
    by_cases hij : i = j
    · exact Or.inl ⟨q, by omega, by simp [hij]⟩
    · rcases hP.done i (by omega) hli with ⟨k, hk, hki⟩ | ⟨hf, hr⟩
      · exact Or.inl ⟨k, by omega, by simp [show k ≠ q by omega, hki]⟩
      · exact Or.inr ⟨hsO.fits (hne 31 (by decide) _) hf,
          (hsO.readAt (hne 31 (by decide) _)).trans hr⟩

/-- `batch->cnt = q`. -/
theorem Call.Pend.cnt {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hP : c.Pend j q sel S) (hq8 : q ≤ 8) (v : BitVec 64) (hv : v = BitVec.ofNat 64 q) :
    c.Inv j q sel ⟨S.alloc, S.mem.storeAt ((c.s.slot 32).add 192#64) v⟩ := by
  have hm : Mods (· ≠ (c.s.slot 32).id) S.mem (S.mem.storeAt ((c.s.slot 32).add 192#64) v) :=
    (Mods.refl _).storeAt (fun h => h rfl) _
  have hsO := hm.sameOn
  have hne (k : Nat) (hk : k ≠ 32) (o : BitVec 64) : ((c.s.slot k).add o).id ≠ (c.s.slot 32).id :=
    GlobalState.slot_id_ne hk
  have hne' (k : Nat) (hk : k ≠ 32) : (c.s.slot k).id ≠ (c.s.slot 32).id :=
    GlobalState.slot_id_ne hk
  have hn (b : BlockId) (hb : b.id < c.s.alloc.nextFreeBlock) : b ≠ (c.s.slot 32).id := by
    rintro rfl; simp at hb; omega
  have hbase := hP.base
  have hwf : (⟨S.alloc, S.mem.storeAt ((c.s.slot 32).add 192#64) v⟩ : GlobalState).WF :=
    hm.wf hbase.wf
  have rc : Room S.mem ((c.s.slot 32).add 192#64) 64 :=
    Room.add_of_le (slot_ov _ _ _) (by decide) hP.room32
  have dc (a k : Nat) (hk : k < q) (ha : a ≤ 128) :
      (Range.of ((c.s.slot 32).add 192#64) 64).Disjoint
        (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 a + BitVec.ofNat 64 (k * 8))) 64) :=
    (ent_cnt_disjoint (by omega) ha).symm
  have e0 (k : Nat) : (c.s.slot 32).add (BitVec.ofNat 64 (k * 8)) =
      (c.s.slot 32).add (BitVec.ofNat 64 0 + BitVec.ofNat 64 (k * 8)) := by simp
  refine ⟨⟨hbase.of_mods hm (hn _ hbase.tbl_lt) (hn _ hbase.idp_lt) hwf le_rfl
      ((eraseFrom_of_mods hm hn).trans hbase.mem),
    hP.ks.of_sameOn hsO (hne' 26 (by decide)) (hne' 27 (by decide)),
    hP.a.of_sameOn hsO (hne' 28 (by decide)), hP.r.of_sameOn hsO (hne' 29 (by decide)),
    hm.room hP.room30, hm.room hP.room31, hm.room hP.room32, hP.q_le, hP.sel_lt, hP.sel_short,
    hP.sel_inj, fun k hk => ?_, fun k hk => ?_, fun k hk => ?_, fun k hk => ?_,
    fun k hk => hsO.fits (hne 30 (by decide) _) (hP.row_fits k hk), fun k hk => ?_,
    fun i hi hli => ?_⟩, Fits.storeAt_self rc, by rw [MemoryState.readAt_storeAt_self rc, hv]⟩
  · have := dc 0 k hk (by decide)
    rw [← e0] at this
    exact (MemoryState.loadPtr_storeAt_disjoint this _).trans (hP.data k hk)
  · exact (hP.sz_fits k hk).storeAt
  · exact (MemoryState.readAt_storeAt_disjoint (dc 64 k hk (by decide)) _).trans (hP.sz_read k hk)
  · exact (MemoryState.loadPtr_storeAt_disjoint (dc 128 k hk (by decide)) _).trans (hP.hash k hk)
  · dsimp only
    rw [hsO.readAt (hne 30 (by decide) _)]
    exact hP.row_hash k hk
  · rcases hP.done i hi hli with h | ⟨hf, hr⟩
    · exact Or.inl h
    · exact Or.inr ⟨hsO.fits (hne 31 (by decide) _) hf,
        (hsO.readAt (hne 31 (by decide) _)).trans hr⟩

/-! ### The batch's run -/

theorem storeDigests_room {m₀ : MemoryState} {d : Nat → Pointer} {n : Nat → BitVec 64}
    {h : Nat → Pointer} {N : Nat} (hp : Room m₀ p w) : Room (storeDigests m₀ d n h N) p w := by
  induction N with
  | zero => exact hp
  | succ N ih => exact ih.storeAt

theorem storeDigests_fits {m₀ : MemoryState} {d : Nat → Pointer} {n : Nat → BitVec 64}
    {h : Nat → Pointer} {N : Nat} (hp : Fits m₀ p w) : Fits (storeDigests m₀ d n h N) p w := by
  induction N with
  | zero => exact hp
  | succ N ih => exact ih.storeAt

theorem _root_.MLIR.GlobalState.WF.storeDigests_mk {s : GlobalState} {d : Nat → Pointer}
    {n : Nat → BitVec 64} {h : Nat → Pointer} {N : Nat} (hwf : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, storeDigests s.mem d n h N⟩ : GlobalState).WF :=
  (Mods.storeDigests (K := fun _ => False) N fun _ _ h => h).wf hwf.add_blocks

/-- Past the digests, apart from each output. -/
theorem readAt_storeDigests_of_disjoint {m₀ : MemoryState} {d : Nat → Pointer}
    {n : Nat → BitVec 64} {h : Nat → Pointer} {N : Nat} {q : Pointer} {w : Nat}
    (hq : ∀ k < N, (Range.of (h k) 512).Disjoint (Range.of q w)) :
    (storeDigests m₀ d n h N).readAt q w = m₀.readAt q w := by
  induction N with
  | zero => rfl
  | succ N ih =>
    rw [storeDigests, MemoryState.readAt_storeAt_disjoint (hq N (by omega)),
      ih fun k hk => hq k (by omega)]

/-- Output `k`'s digest, the outputs apart. -/
theorem readAt_storeDigests_self {m₀ : MemoryState} {d : Nat → Pointer} {n : Nat → BitVec 64}
    {h : Nat → Pointer} {N k : Nat} (hk : k < N)
    (hd : ∀ k' < N, k' ≠ k → (Range.of (h k') 512).Disjoint (Range.of (h k) 512))
    (hr : Room m₀ (h k) 512) :
    Fits (storeDigests m₀ d n h N) (h k) 512 ∧
      (storeDigests m₀ d n h N).readAt (h k) 512 =
        sha512Bits (n k) (m₀.readAt (d k) (8 * (n k).toNat)) := by
  induction N with
  | zero => omega
  | succ N ih =>
    by_cases hkN : k = N
    · subst hkN
      exact ⟨Fits.storeAt_self (storeDigests_room hr),
        MemoryState.readAt_storeAt_self (storeDigests_room hr) _⟩
    · have := ih (by omega) fun k' hk' => hd k' (by omega)
      exact ⟨this.1.storeAt, by
        rw [storeDigests, MemoryState.readAt_storeAt_disjoint (hd N (by omega) (Ne.symm hkN)),
          this.2]⟩

theorem hashAt_disjoint {c : Call} {a b : Nat} (ha : a < 8) (hb : b < 8) (hab : a ≠ b) :
    (Range.of (c.hashAt a) 512).Disjoint (Range.of (c.hashAt b) 512) :=
  slot_disjoint (by simp only [BitVec.toNat_ofNat]; omega)

/-- What `fd_sha512_private_batch_avx512( q, batch->data, batch->sz, batch->hash )` asks of the
queue: its entries and inputs, room at and apart outputs. -/
theorem Call.Pend.batch_args {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hP : c.Pend j q sel S) (hj : j ≤ 8) :
    (∀ i < q,
        InBounds S.mem ((c.s.slot 32).add (BitVec.ofNat 64 (i * 8))) 64 ∧
          S.mem.loadPtr ((c.s.slot 32).add (BitVec.ofNat 64 (i * 8))) = .value (c.row (sel i)) ∧
          Fits S.mem (((c.s.slot 32).add 64#64).add (BitVec.ofNat 64 (i * 8))) 64 ∧
          S.mem.readAt (((c.s.slot 32).add 64#64).add (BitVec.ofNat 64 (i * 8))) 64 =
            (c.it (sel i)).msgSz + 64#64 ∧
          InBounds S.mem (((c.s.slot 32).add 128#64).add (BitVec.ofNat 64 (i * 8))) 64 ∧
          S.mem.loadPtr (((c.s.slot 32).add 128#64).add (BitVec.ofNat 64 (i * 8))) =
            .value (c.hashAt (sel i)) ∧
          Fits S.mem (c.row (sel i)) (8 * ((c.it (sel i)).msgSz + 64#64).toNat) ∧
          ¬(c.row (sel i)).offset.uaddOverflow ((c.it (sel i)).msgSz + 64#64) ∧
          Room S.mem (c.hashAt (sel i)) 512) ∧
      ∀ i < q,
        (Range.of (c.hashAt (sel i)) 512).Disjoint (Range.of (c.s.slot 32) 512) ∧
          (Range.of (c.hashAt (sel i)) 512).Disjoint (Range.of ((c.s.slot 32).add 64#64) 512) ∧
          (Range.of (c.hashAt (sel i)) 512).Disjoint (Range.of ((c.s.slot 32).add 128#64) 512) ∧
          (∀ k < q, (Range.of (c.hashAt (sel i)) 512).Disjoint
            (Range.of (c.row (sel k)) (8 * ((c.it (sel k)).msgSz + 64#64).toNat))) ∧
          ∀ k < q, i ≠ k →
            (Range.of (c.hashAt (sel i)) 512).Disjoint (Range.of (c.hashAt (sel k)) 512) := by
  have hq := hP.q_le
  have h31 (o : BitVec 64) (k : Nat) (hk : k ≠ 31) (o' : BitVec 64) (v w : Nat) :
      (Range.of ((c.s.slot 31).add o) v).Disjoint (Range.of ((c.s.slot k).add o') w) :=
    slots_disjoint (Ne.symm hk) o o' v w
  refine ⟨fun i hi => ?_, fun i hi => ?_⟩
  · have hsl := hP.sel_lt i hi
    have hsz := Call.short_sz (hP.sel_short i hi)
    simp only [Pointer.add_add]
    have e0 : (c.s.slot 32).add (BitVec.ofNat 64 (i * 8)) =
        (c.s.slot 32).add (BitVec.ofNat 64 0 + BitVec.ofNat 64 (i * 8)) := by simp
    have r0 := ent_room (a := 0) (k := i) (by omega) (by decide) hP.room32
    have r128 := ent_room (a := 128) (k := i) (by omega) (by decide) hP.room32
    rw [← e0] at r0
    refine ⟨r0.inBounds, hP.data i hi, hP.sz_fits i hi, hP.sz_read i hi, r128.inBounds,
      hP.hash i hi, hP.row_fits i hi, ?_, ?_⟩
    · rw [show (c.row (sel i)).offset = BitVec.ofNat 64 (sel i * 1296) by simp [Pointer.add]]
      simp only [BitVec.uaddOverflow, toNat_row (show sel i < 8 by omega), BitVec.toNat_add,
        BitVec.toNat_ofNat, decide_eq_true_eq]
      omega
    · exact Room.add_of_le (slot_ov _ _ _) (by simp only [BitVec.toNat_ofNat]; omega) hP.room31
  · have hsl := hP.sel_lt i hi
    refine ⟨by simpa using h31 _ 32 (by decide) 0#64 512 512, h31 _ 32 (by decide) _ 512 512,
      h31 _ 32 (by decide) _ 512 512, fun k _ => h31 _ 30 (by decide) _ _ _, fun k hk hik => ?_⟩
    exact hashAt_disjoint (by omega) (by have := hP.sel_lt k hk; omega)
      fun h => hik (hP.sel_inj i hi k hk h)

/-- The batch run on the queue: every live item below `j` hashed, the queue empty. -/
theorem Call.Pend.batch {c : Call} {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hP : c.Pend j q sel S) (hj : j ≤ 8) (N : Nat) :
    c.Pend j 0 sel ⟨⟨S.alloc.nextFreeBlock + N⟩,
      storeDigests S.mem (fun i => c.row (sel i)) (fun i => (c.it (sel i)).msgSz + 64#64)
        (fun i => c.hashAt (sel i)) q⟩ := by
  have hq := hP.q_le
  have hm : Mods (· ≠ (c.s.slot 31).id) S.mem
      (storeDigests S.mem (fun i => c.row (sel i)) (fun i => (c.it (sel i)).msgSz + 64#64)
        (fun i => c.hashAt (sel i)) q) :=
    Mods.storeDigests q fun _ _ h => h rfl
  have hsO := hm.sameOn
  have hne' (k : Nat) (hk : k ≠ 31) : (c.s.slot k).id ≠ (c.s.slot 31).id :=
    GlobalState.slot_id_ne hk
  have hn (b : BlockId) (hb : b.id < c.s.alloc.nextFreeBlock) : b ≠ (c.s.slot 31).id := by
    rintro rfl; simp at hb; omega
  have hbase := hP.base
  have hwf := hm.wf (a := ⟨S.alloc.nextFreeBlock + N⟩) hbase.wf.add_blocks
  have hdis (k' k : Nat) (hk' : k' < q) (hk : k < q) (hne : k' ≠ k) :
      (Range.of (c.hashAt (sel k')) 512).Disjoint (Range.of (c.hashAt (sel k)) 512) :=
    hashAt_disjoint (by have := hP.sel_lt k' hk'; omega) (by have := hP.sel_lt k hk; omega)
      fun h => hne (hP.sel_inj k' hk' k hk h)
  refine ⟨hbase.of_mods hm (hn _ hbase.tbl_lt) (hn _ hbase.idp_lt) hwf (by dsimp only; omega)
      ((eraseFrom_of_mods hm hn).trans hbase.mem),
    hP.ks.of_sameOn hsO (hne' 26 (by decide)) (hne' 27 (by decide)),
    hP.a.of_sameOn hsO (hne' 28 (by decide)), hP.r.of_sameOn hsO (hne' 29 (by decide)),
    hm.room hP.room30, hm.room hP.room31, hm.room hP.room32, Nat.zero_le _,
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun i hi hli => Or.inr ?_⟩
  by_cases hp : ∃ k < q, sel k = i
  · obtain ⟨k, hk, rfl⟩ := hp
    have hr : Room S.mem (c.hashAt (sel k)) 512 :=
      Room.add_of_le (slot_ov _ _ _)
        (by simp only [BitVec.toNat_ofNat]; have := hP.sel_lt k hk; omega) hP.room31
    obtain ⟨hf, hrd⟩ := readAt_storeDigests_self (d := fun i => c.row (sel i))
      (n := fun i => (c.it (sel i)).msgSz + 64#64) (h := fun i => c.hashAt (sel i)) hk
      (fun k' hk' hne => hdis k' k hk' hk hne) hr
    exact ⟨hf, hrd.trans (hP.row_hash k hk)⟩
  · rcases hP.done i hi hli with h | ⟨hf, hrd⟩
    · exact absurd h hp
    · have hd (k : Nat) (hk : k < q) :
          (Range.of (c.hashAt (sel k)) 512).Disjoint (Range.of (c.hashAt i) 512) :=
        hashAt_disjoint (by have := hP.sel_lt k hk; omega) (by omega)
          fun h => hp ⟨k, hk, h⟩
      exact ⟨storeDigests_fits hf, (readAt_storeDigests_of_disjoint hd).trans hrd⟩

/-! ### A streamed item -/

theorem storeResults_storeAt_comm {m : MemoryState} {r p : Pointer} {f : Nat → BitVec 32}
    {x : BitVec w} (h : p.id ≠ r.id) :
    ∀ n, storeResults (m.storeAt p x) r f n = (storeResults m r f n).storeAt p x
  | 0 => rfl
  | n + 1 => by
    rw [storeResults, storeResults, storeResults_storeAt_comm h n,
      storeAt_comm (p := p) (q := r.add (BitVec.ofNat 64 (n * 4))) (Or.inl h)]

theorem storeResults_initStores {m : MemoryState} {r p : Pointer} {f : Nat → BitVec 32} {n : Nat}
    (h : p.id ≠ r.id) :
    storeResults (fd_sha512_init.stores m p) r f n =
      fd_sha512_init.stores (storeResults m r f n) p := by
  simp (disch := (simp only [Pointer.add_id]; exact h)) only [fd_sha512_init.stores,
    storeResults_storeAt_comm]

theorem storeResults_storeSha {m : MemoryState} {r p : Pointer} {f : Nat → BitVec 32} {n : Nat}
    {v : ShaState} (h : p.id ≠ r.id) :
    storeResults (m.storeSha p v) r f n = (storeResults m r f n).storeSha p v := by
  simp (disch := first | exact h | (simp only [Pointer.add_id]; exact h)) only
    [MemoryState.storeSha, MemoryState.storeWords8, storeResults_storeAt_comm]

/-- The digest does not depend on the hash object's buffer. -/
theorem Item.digest_eq (m : MemoryState) (it : Item) (buf : BitVec 1024) :
    Words8.bits (fd_ed25519_verify.hash buf (it.readR m) (it.readA m) it.msgSz (it.readMsg m)).2 =
      it.digest m :=
  bytesLE_inj (by decide)
    (by rw [Item.digest, fd_ed25519_verify.hash_eq, fd_ed25519_verify.hash_eq])

/-- A constant global's block is no writable pointer's. -/
theorem Call.global_ne {c : Call} (hc : c.Ok) {g : Global}
    (hg : g ∈ (verify_x8 c.batch).globals) (hcst : g.init.constant = true) {p : Pointer}
    (hw : Writable c.s.mem p) : c.s.mem.globalBlock g.sym ≠ p.id := by
  obtain ⟨b, hb⟩ := hc.globals g (List.mem_append_left _ hg)
  have hgb : c.s.mem.globalBlock g.sym = b := by simp [MemoryState.globalBlock, hb]
  have hblk := hc.wf.global _ _ _ hb
  rw [GlobalInitializer.image_constant, hcst, ite_eq_left rfl] at hblk
  exact hgb ▸ fun h => Writable.ne_of_readOnly hw hblk
    (MemoryState.imageBlock_writable (by rw [GlobalInitializer.image_constant, hcst])) h.symm

theorem Call.tbl_ne {c : Call} (hc : c.Ok) {p : Pointer} (hw : Writable c.s.mem p) :
    c.tbl.id ≠ p.id :=
  Call.global_ne (g := ⟨"fd_ed25519_lane_base_table",
    _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table⟩) hc (by simp) rfl hw

theorem Call.idp_ne {c : Call} (hc : c.Ok) {p : Pointer} (hw : Writable c.s.mem p) :
    c.idp.id ≠ p.id :=
  Call.global_ne (g := ⟨"verify_x8.identity", _root_.Firedancer.Lane.Mlir.verify_x8_identity⟩) hc
    (by simp) rfl hw

/-- Room for `hashes[j]`'s eight words. -/
theorem Call.hashAt_words8Room {c : Call} {m : MemoryState} {j : Nat} (hj : j < 8)
    (h : Room m (c.s.slot 31) (8 * 512)) : m.Words8Room (c.hashAt j) := by
  have hr (k : Nat) (hk : k ≤ 56) : Room m ((c.hashAt j).add (BitVec.ofNat 64 k)) 64 := by
    rw [Pointer.add_add]
    exact Room.add_of_le (slot_ov _ _ _)
      (by rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat]; omega) h
  exact ⟨by simp [Pointer.add]; omega, by simpa using hr 0 (by decide), hr 8 (by decide),
    hr 16 (by decide), hr 24 (by decide), hr 32 (by decide), hr 40 (by decide), hr 48 (by decide),
    hr 56 (by decide)⟩

/-- Item `j` streamed through `shas[j]`, its digest at `hashes[j]`. -/
theorem Call.Inv.stream {c : Call} (hc : c.Ok) {j q : Nat} {sel : Nat → Nat} {S : GlobalState}
    (hI : c.Inv j q sel S) (hj : j < c.cnt) (hl : c.long j = true) (N : Nat) :
    c.Inv (j + 1) q sel ⟨⟨S.alloc.nextFreeBlock + N⟩,
      let h := fd_ed25519_verify.hash (S.mem.readAt (c.it j).sha 1024)
        (S.mem.readAt (c.it j).sig 256) (S.mem.readAt (c.it j).pk 256) (c.it j).msgSz
        (S.mem.readAt (c.it j).msg (8 * (c.it j).msgSz.toNat))
      fd_ed25519_verify.hashMem S.mem (c.it j).sha (c.hashAt j) h.1 h.2⟩ := by
  have hP := hI.toPend
  have hbase := hP.base
  have hit := c.itemAt hc hj hbase
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hsep := hc.batch.sep
  obtain ⟨-, -, -, -, -, -, -, ⟨o8f, -⟩, o9⟩ := hc.batch.ok j hj
  have hsha_lt : (c.it j).sha.id.id < c.s.alloc.nextFreeBlock :=
    hc.wf.id_lt_of_inBounds o8f.inBounds
  rw [hit.sha_r, hit.sig_r, hit.pk_r, hit.msg_r]
  dsimp only
  set X := (fd_ed25519_verify.hash (c.s.mem.readAt (c.it j).sha 1024) ((c.it j).readR c.s.mem)
    ((c.it j).readA c.s.mem) (c.it j).msgSz ((c.it j).readMsg c.s.mem)) with hX
  let K : BlockId → Prop := fun b => b ≠ (c.it j).sha.id ∧ b ≠ (c.s.slot 31).id
  have hm : Mods K S.mem (fd_ed25519_verify.hashMem S.mem (c.it j).sha (c.hashAt j) X.1 X.2) :=
    (Mods.refl _).hashMem (fun h => h.1 rfl) (fun h => h.2 rfl) _ _
  have hsO := hm.sameOn
  have hslot (k : Nat) (hk : k ≠ 31) (o : BitVec 64) : K ((c.s.slot k).add o).id :=
    ⟨fun h => by have := congrArg BlockId.id h; simp at this; omega, GlobalState.slot_id_ne hk⟩
  have hslot' (k : Nat) (hk : k ≠ 31) : K (c.s.slot k).id := by simpa using hslot k hk 0#64
  have hn (b : BlockId) (hb : b.id < c.s.alloc.nextFreeBlock) (hne : b ≠ (c.it j).sha.id) : K b :=
    ⟨hne, by rintro rfl; simp at hb; omega⟩
  have hwf := hm.wf (a := ⟨S.alloc.nextFreeBlock + N⟩) hbase.wf.add_blocks
  have hk31 : c.s.alloc.nextFreeBlock ≤ (c.hashAt j).id.id := by simp
  have hmem : (fd_ed25519_verify.hashMem S.mem (c.it j).sha (c.hashAt j) X.1 X.2).eraseFrom
      c.s.alloc.nextFreeBlock = c.memJ (j + 1) := by
    rw [MemoryState.eraseFrom_hashMem_of_le hk31, hbase.mem]
    simp only [Call.memJ, streamMem, hl, ite_true]
    rw [storeResults_storeSha (hsep.2.1 j hj).2, storeResults_initStores (hsep.2.1 j hj).2]
    rfl
  have hroom : Room S.mem (c.hashAt j) 512 :=
    Room.add_of_le (slot_ov _ _ _) (by simp only [BitVec.toNat_ofNat]; omega) hP.room31
  have hkov : ¬(c.hashAt j).offset.uaddOverflow 64#64 := by
    simp only [BitVec.uaddOverflow, Pointer.add, GlobalState.slot_offset, BitVec.toNat_add,
      BitVec.toNat_ofNat]
    simp; omega
  refine ⟨⟨hbase.of_mods hm (hn _ hbase.tbl_lt (c.tbl_ne hc o9))
      (hn _ hbase.idp_lt (c.idp_ne hc o9)) hwf (by dsimp only; omega) hmem,
    hP.ks.of_sameOn hsO (hslot' 26 (by decide)) (hslot' 27 (by decide)),
    hP.a.of_sameOn hsO (hslot' 28 (by decide)), hP.r.of_sameOn hsO (hslot' 29 (by decide)),
    hm.room hP.room30, hm.room hP.room31, hm.room hP.room32, by have := hP.q_le; omega,
    fun k hk => by have := hP.sel_lt k hk; omega, hP.sel_short, hP.sel_inj,
    fun k hk => (hsO.loadPtr (hslot 32 (by decide) _)).trans (hP.data k hk),
    fun k hk => hsO.fits (hslot 32 (by decide) _) (hP.sz_fits k hk),
    fun k hk => (hsO.readAt (hslot 32 (by decide) _)).trans (hP.sz_read k hk),
    fun k hk => (hsO.loadPtr (hslot 32 (by decide) _)).trans (hP.hash k hk),
    fun k hk => hsO.fits (hslot 30 (by decide) _) (hP.row_fits k hk), fun k hk => ?_,
    fun i hi hli => ?_⟩, hsO.fits (hslot 32 (by decide) _) hI.cnt_fits,
    (hsO.readAt (hslot 32 (by decide) _)).trans hI.cnt_read⟩
  · dsimp only
    rw [hsO.readAt (hslot 30 (by decide) _)]
    exact hP.row_hash k hk
  · by_cases hij : i = j
    · subst hij
      refine Or.inr ⟨Fits.hashMem_k (c.hashAt_words8Room hj8 hP.room31), ?_⟩
      rw [MemoryState.readAt_hashMem_k hroom hkov, hX, Item.digest_eq]
    · rcases hP.done i (by omega) hli with h | ⟨hf, hr⟩
      · exact Or.inl h
      · refine Or.inr ⟨hf.hashMem, ?_⟩
        rw [fd_ed25519_verify.hashMem, MemoryState.readAt_storeWords8_of_disjoint
          (c.hashAt_words8Room hj8 hP.room31).1
          (hashAt_disjoint hj8 (by have := c.lt_cnt_of_live hli; omega) (Ne.symm hij))]
        have hK' : (fun b => b ≠ (c.it j).sha.id) (c.hashAt i).id :=
          fun h => by have := congrArg BlockId.id h; simp at this; omega
        rw [(((Mods.refl S.mem).initStores (K := fun b => b ≠ (c.it j).sha.id)
          (fun h => h rfl)).storeSha (fun h => h rfl) X.1).sameOn.readAt hK']
        exact hr

/-! ### The hand-overs -/

theorem _root_.MLIR.MemoryState.SameOn.modifyBlock {m m' : MemoryState} {K : BlockId → Prop}
    {i : BlockId} {f : MemoryBlock → MemoryBlock} (h : m.SameOn m' K) (hi : ¬K i) :
    m.SameOn (m'.modifyBlock i f) K := by
  refine ⟨fun b hb => ?_, h.2.1, h.2.2⟩
  have hne : b ≠ i := fun e => hi (e ▸ hb)
  rw [MemoryState.getElem?_modifyBlock_ne hne, h.1 b hb]

/-- `^bb62`: `hash_input`, `hashes` and `batch` started, `batch->cnt = 0`: nothing queued. -/
theorem Call.inv0 {c : Call} {S S' : GlobalState} (hS : c.At62 S) (sel : Nat → Nat)
    (hS' : S' = ⟨S.alloc, (((S.mem.lifetimeStart (c.s.slot 30)).lifetimeStart
      (c.s.slot 31)).lifetimeStart (c.s.slot 32)).storeAt ((c.s.slot 32).add 192#64) 0#64⟩)
    (hwf : S'.WF)
    (r30 : Room S'.mem (c.s.slot 30) (8 * 10368)) (r31 : Room S'.mem (c.s.slot 31) (8 * 512))
    (r32 : Room S'.mem (c.s.slot 32) (8 * 256)) (hf : Fits S'.mem ((c.s.slot 32).add 192#64) 64)
    (hr : S'.mem.readAt ((c.s.slot 32).add 192#64) 64 = 0#64) : c.Inv 0 0 sel S' := by
  have hb := hS.base
  have hn (k : Nat) : c.s.alloc.nextFreeBlock ≤ (c.s.slot k).id.id := by simp
  have hfo : FrameOps c.s.alloc.nextFreeBlock S.mem S'.mem := by
    rw [hS']
    have h := (((FrameOps.refl _ _).lifetimeStart (hn 30)).lifetimeStart (hn 31)).lifetimeStart
      (m := S.mem) (hn 32)
    exact ⟨fun _ _ hq => (h.1 _ _ hq).storeAt, fun _ hq => (h.2.1 _ hq).storeAt,
      (MemoryState.eraseFrom_storeAt_of_le (by simp)).trans h.2.2⟩
  let K : BlockId → Prop := fun b => b ≠ (c.s.slot 30).id ∧ b ≠ (c.s.slot 31).id ∧
    b ≠ (c.s.slot 32).id
  have hsO : S.mem.SameOn S'.mem K := by
    rw [hS']
    exact ((((MemoryState.SameOn.refl S.mem).modifyBlock (fun h => h.1 rfl)).modifyBlock
      (fun h => h.2.1 rfl)).modifyBlock (fun h => h.2.2 rfl)).modifyBlock (fun h => h.2.2 rfl)
  have hK (k : Nat) (h1 : k ≠ 30) (h2 : k ≠ 31) (h3 : k ≠ 32) : K (c.s.slot k).id :=
    ⟨GlobalState.slot_id_ne h1, GlobalState.slot_id_ne h2, GlobalState.slot_id_ne h3⟩
  exact ⟨⟨hb.frameOps hfo hwf (by rw [hS']), hS.ks.of_sameOn hsO (hK 26 (by decide) (by decide)
      (by decide)) (hK 27 (by decide) (by decide) (by decide)),
    hS.a.of_sameOn hsO (hK 28 (by decide) (by decide) (by decide)),
    hS.r.of_sameOn hsO (hK 29 (by decide) (by decide) (by decide)), r30, r31, r32, le_rfl,
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _),
    fun _ h => absurd h (Nat.not_lt_zero _), fun _ h => absurd h (Nat.not_lt_zero _)⟩, hf, hr⟩

/-- `^bb76`: every live item hashed, the queue empty. -/
theorem Call.Pend.at76 {c : Call} {sel : Nat → Nat} {S : GlobalState} (hP : c.Pend c.cnt 0 sel S) :
    c.At76 S := by
  refine ⟨hP.base, hP.ks, hP.a, hP.r, fun j hj hl => ?_⟩
  rcases hP.done j hj hl with ⟨k, hk, -⟩ | ⟨hf, hr⟩
  · omega
  · rw [Nat.mul_comm]; exact ⟨hf, hr⟩

/-! ### Facts for the steps -/

/-- The globals the batch needs. -/
theorem Call.Base.globalsG {c : Call} {S : GlobalState} {M : MemoryState} (h : c.Base S M) :
    S.mem.Globals c.G :=
  h.globals.mono rfl fun _ hg => List.mem_append_right _ hg

/-- `InBounds` past a hash object's store. -/
theorem _root_.MLIR.InBounds.storeSha {m : MemoryState} {p q : Pointer} {v : ShaState}
    (h : InBounds m q w) : InBounds (m.storeSha p v) q w := by
  unfold MemoryState.storeSha
  exact h.storeAt.storeAt.storeAt.storeAt.storeWords8

/-- A pointer read in another block than eight stored words. -/
theorem _root_.MLIR.MemoryState.loadPtr_storeWords8_of_id_ne {m : MemoryState}
    {p q : Pointer} {v : Vector (BitVec 64) 8} (h : p.id ≠ q.id) :
    (m.storeWords8 p v).loadPtr q = m.loadPtr q := by
  have h' (o : BitVec 64) : (Range.of (p.add o) 64).Disjoint (Range.of q 64) :=
    Or.inl (by simpa [Range.of, Pointer.add_id] using h)
  simp only [MemoryState.storeWords8, MemoryState.loadPtr_storeAt_disjoint (h' _)]
  exact MemoryState.loadPtr_storeAt_disjoint (by simpa using h' 0#64) _

/-- A pointer read in another block than a hash object. -/
theorem _root_.MLIR.MemoryState.loadPtr_storeSha_of_id_ne {m : MemoryState} {p q : Pointer}
    {v : ShaState} (h : p.id ≠ q.id) : (m.storeSha p v).loadPtr q = m.loadPtr q := by
  have h' (o : BitVec 64) (w : Nat) : (Range.of (p.add o) w).Disjoint (Range.of q 64) :=
    Or.inl (by simpa [Range.of, Pointer.add_id] using h)
  unfold MemoryState.storeSha
  rw [MemoryState.loadPtr_storeWords8_of_id_ne (by simpa [Pointer.add_id] using h),
    MemoryState.loadPtr_storeAt_disjoint (h' _ _), MemoryState.loadPtr_storeAt_disjoint (h' _ _),
    MemoryState.loadPtr_storeAt_disjoint (h' _ _),
    MemoryState.loadPtr_storeAt_disjoint (by simpa using h' 0#64 1024)]

/-- The array entries' offsets do not wrap. -/
theorem Call.arr_ov {c : Call} (hc : c.Ok) {j : Nat} (hj : j < c.cnt) :
    ¬c.a.msgSzs.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      ¬c.a.sigs.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      ¬c.a.pks.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      ¬c.a.msgs.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      ¬c.a.shas.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) := by
  obtain ⟨h1, h2, h3, h4, h5, -⟩ := hc.batch.off
  have h8 := hc.cnt8
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> rw [Nat.mod_eq_of_lt (by omega)] <;> omega

end

end MLIR.Firedancer.Lane.VerifyX8

module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Cache
public import Firedancer.Crc.Ref.CacheMlir
public import Firedancer.Crc.Ref.HashMlir
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_query
import Std.Tactic.BVDecide

/-!
# `fd_ed25519_cache_query` refinement (MLIR lift ↔ spec)

The lookup as `Cache`'s model: `view` reads the memory as the key → table map, the lift returns
`view`'s table of the key and writes `post`.
-/

namespace MLIR.Firedancer.Crc.Ref

namespace fd_ed25519_cache_query

@[expose] public section

/-- `fd_hash( cache->seed, key, 32 )`. -/
def hash (m : MemoryState) (cache : Pointer) (key : BitVec 256) : BitVec 64 :=
  fd_hash.spec (m.readAt (cache.add 24#64) 64) key 32

/-- `key`'s set, `h & (cache->set_cnt-1)`. -/
def idx (m : MemoryState) (cache : Pointer) (key : BitVec 256) : BitVec 64 :=
  hash m cache key &&& (m.readAt (cache.add 8#64) 64 - 1)

/-- `cache->set + i`, for the sets at `setp`. -/
def set (setp : Pointer) (i : BitVec 64) : Pointer :=
  setp.add (BitVec.ofNat 64 (i.toNat * 256))

/-- `&set->use[ w ]`. -/
def useP (S : Pointer) (w : Nat) : Pointer :=
  S.add (BitVec.ofNat 64 (128 + 8 * w))

/-- `set->key[ w ]`. -/
def keyP (S : Pointer) (w : Nat) : Pointer :=
  S.add (BitVec.ofNat 64 (32 * w))

/-- The first of the ways `ws` of set `S` in use and holding `key`. -/
def way (m : MemoryState) (S : Pointer) (key : BitVec 256) : List Nat → Option Nat
  | [] => none
  | w :: ws =>
    if m.readAt (useP S w) 64 ≠ 0 ∧ m.readAt (keyP S w) 256 = key then some w else way m S key ws

/-- `cache->tbl + (4*i + w)*CRC_ADX_SPLIT_A_TBL_CNT`: way `w` of set `i`'s 4096-byte table. -/
def entry (tbl : Pointer) (i : BitVec 64) (w : Nat) : Pointer :=
  (tbl.add (i <<< 14)).add (BitVec.ofNat 64 (4096 * w))

/-- The cache as `Cache`'s key → table map, for the header's set and table pointers `setp`, `tbl`:
`key`'s table if a way of its set holds it. -/
def view (m : MemoryState) (cache setp tbl : Pointer) (key : BitVec 256) : Option Pointer :=
  (way m (set setp (idx m cache key)) key [0, 1, 2, 3]).map (entry tbl (idx m cache key))

/-- The lookup's last writes, to set `S` at tick `t`: on a hit of way `w` its `use` and
`hit_cnt`, else `miss_cnt`. -/
def after (m : MemoryState) (cache S : Pointer) (t : BitVec 64) : Option Nat → MemoryState
  | some w => (m.storeAt (useP S w) t).storeAt (cache.add 48#64) (m.readAt (cache.add 48#64) 64 + 1)
  | none => m.storeAt (cache.add 56#64) (m.readAt (cache.add 56#64) 64 + 1)

/-- The memory after the lookup: `*_h = h`, `++cache->tick`, then `after`. -/
def post (m : MemoryState) (cache setp hp : Pointer) (key : BitVec 256) : MemoryState :=
  let t := m.readAt (cache.add 32#64) 64 + 1
  let m' := (m.storeAt hp (hash m cache key)).storeAt (cache.add 32#64) t
  let S := set setp (idx m cache key)
  after m' cache S t (way m' S key [0, 1, 2, 3])

end

end fd_ed25519_cache_query

section Proof

open fd_ed25519_cache_query

set_option hygiene false in
/-- One way of the loop at a literal way that is not the last: a miss goes on to way `n` by `ih`,
a hit runs `^bb4`. -/
local macro "way_iter " w:num n:num : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_load
      step_pure
      finish_block
      · -- `!set->use[ w ]`: `^bb3`, then way `n`
        block_init
        step_pure
        step_pure
        finish_block
        subst hS
        refine (ih $n E hArgs ?_ (by omega)).trans ?_
        · env_reads
        · simp [List.range', way, useP, hbr]
      · have huse := hbr
        block_init
        step_pure
        step_call using fd_memeq_28.call_eq
        step_pure
        finish_block
        · -- another key: `^bb3`, then way `n`
          block_init
          step_pure
          step_pure
          finish_block
          subst hS
          refine (ih $n E hArgs ?_ (by omega)).trans ?_
          · env_reads
          · simp [List.range', way, useP, keyP, huse, (fd_memeq.memeq_zero _ _).1 hbr]
        · -- the key: `^bb4`
          block_init
          step_pure
          step_store
          step_pure
          step_load
          step_pure
          step_store
          step_pure
          step_load [htbl]
          step_pure
          step_pure [htb1, htb2]
          step_pure
          step_pure
          finish_block
          block_init
          finish_block
          have hkey := Classical.not_not.1 (mt (fd_memeq.memeq_zero _ _).2 hbr)
          rw [hS]
          have hw : way M sp (M.readAt pk 256) (List.range' $w (k + 1 + 1)) = some $w := by
            simp [List.range', way, useP, keyP, huse, hkey]
          rw [hw]
          simp [after, entry, useP, Pointer.add, BitVec.add_assoc]))

theorem fd_ed25519_cache_query.WF_post {s : GlobalState} {m : MemoryState} {cache setp hp : Pointer}
    {key : BitVec 256} :
    ({ s with mem := post m cache setp hp key } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  unfold post after
  dsimp only
  split <;> simp only [GlobalState.WF_storeAt]

theorem fd_ed25519_cache_query.noOv {sp : Pointer} (h : ¬sp.offset.uaddOverflow 256#64) {a b : Nat}
    (hab : a + b ≤ 256) :
    ¬(sp.add (BitVec.ofNat 64 a)).offset.uaddOverflow (BitVec.ofNat 64 b) := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, Pointer.add,
    BitVec.toNat_add, BitVec.toNat_ofNat] at h ⊢
  have := sp.offset.isLt
  rw [Nat.mod_eq_of_lt (a := a) (by omega), Nat.mod_eq_of_lt (a := b) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  omega

attribute [local mlir_mem] fd_ed25519_cache_query.WF_post

theorem fd_ed25519_cache_query.idx_lt {n : BitVec 64} (h : BitVec 64) (hn : n ≠ 0) :
    (n + 18446744073709551615#64 &&& h).toNat < n.toNat := by
  have h1 : (n + 18446744073709551615#64).toNat < n.toNat := by
    have := n.isLt
    have : n.toNat ≠ 0 := fun h0 => hn (BitVec.eq_of_toNat_eq (by simpa using h0))
    rw [BitVec.toNat_add, BitVec.toNat_ofNat]; omega
  rw [BitVec.toNat_and]
  exact Nat.lt_of_le_of_lt Nat.and_le_left h1

/-- The set's keys and `use` words hold known bits; the `use` words are writable. -/
abbrev fd_ed25519_cache_query.SetFit (m : MemoryState) (S : Pointer) : Prop :=
  Fits m S 256 ∧
    Fits m (S.add 32#64) 256 ∧
    Fits m (S.add 64#64) 256 ∧
    Fits m (S.add 96#64) 256 ∧
    Fits m (S.add 128#64) 64 ∧
    Fits m (S.add 136#64) 64 ∧
    Fits m (S.add 144#64) 64 ∧
    Fits m (S.add 152#64) 64 ∧
    Room m (S.add 128#64) 64 ∧
    Room m (S.add 136#64) 64 ∧ Room m (S.add 144#64) 64 ∧ Room m (S.add 152#64) 64

theorem fd_ed25519_cache_query.tblOv {tbl : Pointer} {x : BitVec 64}
    (h : tbl.offset.toNat + x.toNat + 16384 < 2 ^ 63) {b : Nat} (hb : b ≤ 16384) :
    ¬(tbl.add x).offset.uaddOverflow (BitVec.ofNat 64 b) := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, Pointer.add,
    BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (a := b) (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem fd_memeq.memeq_zero (a b : BitVec 256) : fd_memeq.spec a b = 0 ↔ a ≠ b := by
  unfold fd_memeq.spec
  split <;> simp_all

theorem fd_ed25519_cache_query.setFit_of {m : MemoryState} {S : Pointer} (hf : Fits m S 2048)
    (hr : Room m S 2048) (ho : ¬S.offset.uaddOverflow 256#64) : SetFit m S := by
  have ov : ∀ k : BitVec 64, k.toNat ≤ 256 → ¬S.offset.uaddOverflow k := fun k hk =>
    BitVec.not_uaddOverflow_of_le ho (by simpa using hk)
  refine ⟨hf.mono (by decide), ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals
    first
    | exact Fits.add_of_le (ov _ (by decide)) (by decide) hf
    | exact Room.add_of_le (ov _ (by decide)) (by decide) hr

theorem fd_ed25519_cache_query.way_storeAt {m : MemoryState} {p S : Pointer} {v : Nat}
    (x : BitVec v) (key : BitVec 256) :
    ∀ l : List Nat,
      (∀ w ∈ l,
          (Range.of p v).Disjoint (Range.of (useP S w) 64) ∧
            (Range.of p v).Disjoint (Range.of (keyP S w) 256)) →
        way (m.storeAt p x) S key l = way m S key l
  | [], _ => rfl
  | w :: l, h => by
    simp only [way, MemoryState.readAt_storeAt_disjoint (h w (by simp)).1,
      MemoryState.readAt_storeAt_disjoint (h w (by simp)).2,
      way_storeAt x key l fun w' hw' => h w' (by simp [hw'])]

/-- The tick (`cache + 32`) lies before the set `S`. -/
theorem fd_ed25519_cache_query.tick_disj {cache S : Pointer}
    (hco : cache.offset.toNat + 96 < 2 ^ 63) (hl : cache.offset.toNat + 96 ≤ S.offset.toNat)
    (hn : S.offset.toNat + 256 < 2 ^ 64) {w : Nat} (hw : w < 4) :
    (Range.of (cache.add 32#64) 64).Disjoint (Range.of (useP S w) 64) ∧
      (Range.of (cache.add 32#64) 64).Disjoint (Range.of (keyP S w) 256) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, useP, keyP,
    BitVec.toNat_add, BitVec.toNat_ofNat]
  constructor <;> right <;> left <;> omega

theorem fd_ed25519_cache_query.idx_eq (cnt hv : BitVec 64) :
    hv &&& (cnt - 1) = cnt + 18446744073709551615#64 &&& hv := by bv_decide

/-- `^bb1`, the way loop at way `w`, `k + 1` ways left. -/
theorem fd_ed25519_cache_query.loop1 (cache pk sp tbl : Pointer) (iv t : BitVec 64) (A : AllocState)
    (M : MemoryState) (hwf : (⟨A, M⟩ : GlobalState).WF) (hsf : SetFit M sp)
    (hspo : ¬sp.offset.uaddOverflow 256#64) (hpk : Fits M pk 256) (hc : Fits M cache 576)
    (hcr : Room M cache 576) (hcb : InBounds M cache 768) (hcov : ¬cache.offset.uaddOverflow 96#64)
    (hco : cache.offset.toNat + 96 < 2 ^ 63) (hspl : cache.offset.toNat + 96 ≤ sp.offset.toNat)
    (hspn : sp.offset.toNat + 256 < 2 ^ 64) (htbl : M.loadPtr (cache.add 88#64) = .value tbl)
    (htb1 : (iv <<< 14).toNat < 2 ^ 63) (htb2 : ¬tbl.offset.uaddOverflow (iv <<< 14))
    (htbn : tbl.offset.toNat + (iv <<< 14).toNat + 16384 < 2 ^ 63) :
    ∀ k w (E : ⟪fd_ed25519_cache_query.Γ⟫),
      E.args = (fd_ed25519_cache_query.args (.value cache) (.value pk) (.value hp)).get →
        (E ⊨ [%2 := 1#64, %3 := 0#64, %4 := 0#32, %5 := 14#64, %6 := 12#64, %7 := 4#64, %8 :=
          Pointer.null, %15 := iv, %18 := sp, %21 := t, %22 := sp.add 128#64, %23 :=
          BitVec.ofNat 64 w]) →
        w + k + 1 = 4 →
        fd_ed25519_cache_query.runFrom E ^bb1 ⟨A, M⟩ =
          .value
            (.cons
                (.value
                  (((way M sp (M.readAt pk 256) (List.range' w (k + 1))).map (entry tbl iv)).getD
                    .null))
                .nil,
              ⟨A, after M cache sp t (way M sp (M.readAt pk 256) (List.range' w (k + 1)))⟩) := by
  intro k
  induction k with
  | zero =>
    intro w E hArgs hR hk
    obtain rfl : w = 3 := by omega
    block_init
    step_pure [gep_value (f := { nuw := true }) (noOv (a := 128) (b := 24) hspo (by decide))
          (.inl rfl)]
    step_load
    step_pure
    finish_block
    · block_init
      step_pure
      step_pure
      finish_block
      block_init
      step_pure
      step_load
      step_pure
      step_store
      finish_block
      block_init
      finish_block
      have hw : way M sp (M.readAt pk 256) (List.range' 3 1) = none := by
        simp [List.range', way, useP, hbr]
      rw [hw, hS]
      rfl
    · have huse := hbr
      block_init
      step_pure [gep_value (f := { nuw := true })
            (BitVec.not_uaddOverflow_of_le (a := 96#64) hspo (by decide)) (.inl rfl)]
      step_call using fd_memeq_28.call_eq
      step_pure
      finish_block
      · block_init
        step_pure
        step_pure
        finish_block
        block_init
        step_pure
        step_load
        step_pure
        step_store
        finish_block
        block_init
        finish_block
        have hw : way M sp (M.readAt pk 256) (List.range' 3 1) = none := by
          simp [List.range', way, useP, keyP, (fd_memeq.memeq_zero _ _).1 hbr]
        rw [hw, hS]
        rfl
      · block_init
        step_pure [gep_value (f := { nuw := true }) (noOv (a := 128) (b := 24) hspo (by decide))
              (.inl rfl)]
        step_store
        step_pure
        step_load
        step_pure
        step_store
        step_pure
        step_load [htbl]
        step_pure
        step_pure [htb1, htb2]
        step_pure
        step_pure [gep_value (f := { nuw := true }) (tblOv (b := 12288) htbn (by decide))
              (.inl rfl)]
        finish_block
        block_init
        finish_block
        have hw : way M sp (M.readAt pk 256) (List.range' 3 1) = some 3 := by
          simp [List.range', way, useP, keyP, huse,
            Classical.not_not.1 (mt (fd_memeq.memeq_zero _ _).2 hbr)]
        rw [hw, hS]
        simp [after, entry, useP, Pointer.add, BitVec.add_assoc]
  | succ k ih =>
    intro w E hArgs hR hk
    have hspo128 : ¬(sp.add 128#64).offset.uaddOverflow 32#64 :=
      noOv (a := 128) (b := 32) hspo (by decide)
    have htbo' : ¬(tbl.add (iv <<< 14)).offset.uaddOverflow 16384#64 :=
      tblOv (b := 16384) htbn le_rfl
    obtain rfl | rfl | rfl : w = 0 ∨ w = 1 ∨ w = 2 := by omega
    · way_iter 0 1
    · way_iter 1 2
    · way_iter 2 3

/-- `fd_ed25519_cache_query( cache, public_key, _h )` returns `view`'s table of the key at
`public_key` (`NULL` on a miss) and leaves `post`: `*_h`, `tick`, and the hit's `use` and `hit_cnt`
or `miss_cnt` written. The header's integer fields are known and writable, its `set` and `tbl`
pointers are `setp` and `tbl`, the sets lie after the header, and `public_key` and `_h` are apart
from the cache. -/
public theorem fd_ed25519_cache_query.call_eq (cache pk hp setp tbl : Pointer) (s : GlobalState)
    (hwf : s.WF) (hc : Fits s.mem cache 576) (hcr : Room s.mem cache 576)
    (hcb : InBounds s.mem cache 768) (hco : cache.offset.toNat + 96 < 2 ^ 63)
    (hset : s.mem.loadPtr (cache.add 72#64) = .value setp)
    (htbl : s.mem.loadPtr (cache.add 88#64) = .value tbl)
    (hcnt : s.mem.readAt (cache.add 8#64) 64 ≠ 0)
    (hsets : Fits s.mem setp (2048 * (s.mem.readAt (cache.add 8#64) 64).toNat))
    (hsetr : Room s.mem setp (2048 * (s.mem.readAt (cache.add 8#64) 64).toNat))
    (hso : setp.offset.toNat + 256 * (s.mem.readAt (cache.add 8#64) 64).toNat < 2 ^ 63)
    (hlay : cache.offset.toNat + 96 ≤ setp.offset.toNat)
    (htbo : tbl.offset.toNat + 16384 * (s.mem.readAt (cache.add 8#64) 64).toNat < 2 ^ 63)
    (hpk : Fits s.mem pk 256) (hpkw : fd_hash.NoWrap s.mem pk 32) (hhp : Room s.mem hp 64)
    (hpkc : pk.id ≠ cache.id) (hpks : pk.id ≠ setp.id) (hhpc : hp.id ≠ cache.id)
    (hhps : hp.id ≠ setp.id) (hhpk : hp.id ≠ pk.id) :
    fd_ed25519_cache_query.call (fd_ed25519_cache_query.args (.value cache) (.value pk) (.value hp))
        s =
      .value
        (.cons (.value ((view s.mem cache setp tbl (s.mem.readAt pk 256)).getD .null)) .nil,
          { s with mem := post s.mem cache setp hp (s.mem.readAt pk 256) }) := by
  have hcov : ¬cache.offset.uaddOverflow 96#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    omega
  -- `set_cnt`, the hash, the set index and the set, named
  obtain ⟨cnt, hcnt_eq⟩ : ∃ c, s.mem.readAt (cache.add 8#64) 64 = c := ⟨_, rfl⟩
  rw [hcnt_eq] at hcnt hsets hsetr hso htbo
  obtain ⟨hv, hhv⟩ : ∃ v, hash s.mem cache (s.mem.readAt pk 256) = v := ⟨_, rfl⟩
  obtain ⟨iv, hiv⟩ : ∃ v, cnt + 18446744073709551615#64 &&& hv = v := ⟨_, rfl⟩
  have hib : iv.toNat < cnt.toNat := hiv ▸ idx_lt _ hcnt
  obtain ⟨sp, hsp⟩ : ∃ p, set setp iv = p := ⟨_, rfl⟩
  have hsetov : ¬setp.offset.uaddOverflow (BitVec.ofNat 64 (iv.toNat * 256)) := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have hspoff : sp.offset.toNat = setp.offset.toNat + iv.toNat * 256 := by
    rw [← hsp]
    simp only [fd_ed25519_cache_query.set, Pointer.add, BitVec.toNat_add_of_not_uaddOverflow hsetov,
      BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]
  have hiw : (BitVec.ofNat 64 (iv.toNat * 256)).toNat * 8 + 2048 ≤ 2048 * cnt.toNat := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega
  have hspf : Fits s.mem sp 2048 := hsp ▸ Fits.add_of_le hsetov hiw hsets
  have hspr : Room s.mem sp 2048 := hsp ▸ Room.add_of_le hsetov hiw hsetr
  have hspo : ¬sp.offset.uaddOverflow 256#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    omega
  have hspl : cache.offset.toNat + 96 ≤ sp.offset.toNat := by omega
  have hspn : sp.offset.toNat + 256 < 2 ^ 64 := by omega
  have hsh : (iv <<< 14).toNat = iv.toNat * 16384 := by
    have : iv.toNat * 16384 < 2 ^ 64 := by omega
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, show 2 ^ 14 = 16384 from rfl,
      Nat.mod_eq_of_lt this]
  have htb1 : (iv <<< 14).toNat < 2 ^ 63 := by omega
  have htb2 : ¬tbl.offset.uaddOverflow (iv <<< 14) := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le]; omega
  have htbn : tbl.offset.toNat + (iv <<< 14).toNat + 16384 < 2 ^ 63 := by omega
  have hspid : sp.id = setp.id := by
    rw [← hsp]; rfl
  have hhpsp : hp.id ≠ sp.id := hspid ▸ hhps
  have hpksp : pk.id ≠ sp.id := hspid ▸ hpks
  clear hsets hsetr
  func_init
  have hpkw₀ : fd_hash.NoWrap S₀.mem pk 32 := hS ▸ hpkw
  have hset₀ := hS ▸ hset
  have htbl₀ := hS ▸ htbl
  have hcnt₀ := hS ▸ hcnt_eq
  have hhv₀ : fd_hash.spec (S₀.mem.readAt (cache.add 24#64) 64) (S₀.mem.readAt pk 256) 32 = hv :=
    hS ▸ hhv
  block_init
  iterate 9 step_pure
  step_pure
  step_load
  step_call using fd_hash.call_eq
  clear hpkw hpkw₀
  rw [hhv₀] at hE
  step_pure
  step_load [hcnt₀]
  step_pure
  step_pure [hiv]
  have hi256 : iv.toNat * 256 < 2 ^ 63 := by omega
  step_store
  step_pure
  step_load [hset₀]
  step_pure [hi256]
  rw [show setp.add (BitVec.ofNat 64 (iv.toNat * 256)) = sp from hsp] at hE
  step_pure
  step_load
  step_pure with transparent t
  step_store
  step_pure
  finish_block
  -- the way loop
  have hsf := setFit_of hspf hspr hspo
  subst hS
  refine
    (loop1 cache pk sp tbl iv t S₀.alloc _ hwf hsf hspo hpk hc hcr hcb hcov hco hspl hspn htbl htb1
          htb2 htbn 3 0 E hArgs (by env_reads) rfl).trans
      ?_
  subst ht
  have hkey :
    ((S₀.mem.storeAt hp hv).storeAt (cache.add 32#64)
            (S₀.mem.readAt (cache.add 32#64) 64 + 1#64)).readAt
        pk 256 =
      S₀.mem.readAt pk 256 := by
    rw [MemoryState.readAt_storeAt_disjoint (p := cache.add 32#64)
        (Range.disjoint_of_id_ne (Ne.symm hpkc)),
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne hhpk)]
  have hidx : idx S₀.mem cache (S₀.mem.readAt pk 256) = iv := by
    unfold idx; rw [hhv, hcnt₀, idx_eq, hiv]
  have hway :
    ∀ v : BitVec 64,
      way ((S₀.mem.storeAt hp hv).storeAt (cache.add 32#64) v) sp (S₀.mem.readAt pk 256)
          (List.range' 0 4) =
        way S₀.mem sp (S₀.mem.readAt pk 256) [0, 1, 2, 3] := by
    intro v
    rw [way_storeAt _ _ _
        (fun w hw =>
          tick_disj hco hspl hspn
            (by
              simp at hw; omega)),
      way_storeAt _ _ _ (fun w _ => ⟨Range.disjoint_of_id_ne hhpsp, Range.disjoint_of_id_ne hhpsp⟩)]
    rfl
  have hway' :
    ∀ v : BitVec 64,
      way ((S₀.mem.storeAt hp hv).storeAt (cache.add 32#64) v) sp (S₀.mem.readAt pk 256)
          [0, 1, 2, 3] =
        way S₀.mem sp (S₀.mem.readAt pk 256) [0, 1, 2, 3] :=
    hway
  rw [hkey]
  simp only [view, post, hidx, hhv, hsp]
  rw [hway, hway']
  rfl

/-- The lookup is `Cache`'s query on the cache `view` of memory: with only sound tables in it, the
looked-up table changes no verdict. -/
public theorem fd_ed25519_cache_query.view_result {Item : Type} {key : Item → BitVec 256}
    {core : Option Pointer → Item → BitVec 32 × Bool} {sound : Pointer → BitVec 256 → Prop}
    (hcore : ∀ t item, sound t (key item) → core (some t) item = core none item) {m : MemoryState}
    {cache setp tbl : Pointer} (hInv : Cache.Inv sound (view m cache setp tbl)) (item : Item) :
    Cache.result core (view m cache setp tbl (key item)) item = Cache.result core none item :=
  Cache.query_result hcore hInv item

end Proof

end MLIR.Firedancer.Crc.Ref

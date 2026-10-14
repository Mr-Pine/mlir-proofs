module

public import Firedancer.Lane.Common.Batch
public import Firedancer.Math.Lane.Consts
public import Firedancer.Math.Avx512.Verify
public import Firedancer.Math.Sha512
import Std.Data.ExtHashMap.Lemmas

/-! `fd_ed25519_verify_batch_multi_msg` and `_cached` store at `results[j]` what
`Ed25519.Firedancer.verify` returns for item `j`, from their callees' interfaces. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (bytesLE)
open _root_.Firedancer.Lane.Mlir

set_option hygiene false in
/-- The lift on the multi-buffer SHA-512 `batch`. -/
local notation "LIFT" => fd_ed25519_verify_batch_multi_msg batch

set_option hygiene false in
/-- The `_cached` lift on `batch` and `verifyCached`. -/
local notation "LIFTC" => fd_ed25519_verify_batch_multi_msg_cached batch verifyCached

set_option hygiene false in
/-- The `_cached` lift's arguments `A₀`, `n₀`, `cache`. -/
local notation "ARGS" =>
  (args (.value A₀.msgs) (.value A₀.msgSzs) (.value A₀.sigs) (.value A₀.pks) (.value A₀.shas)
    (.value A₀.results) (.value n₀) (.value cache)).get

/-! ## The invariant -/

/-- `Ed25519.Firedancer.verify` on item `it`, its inputs read at `m`. -/
noncomputable def Item.code (m : MemoryState) (it : Item) : BitVec 32 :=
  _root_.Ed25519.Firedancer.verify (bytesLE (it.readMsg m)) (it.readR m) (it.readS m) (it.readA m)

/-- The blocks kept from item `b` on: the inputs', and the hash objects of items `b …`. -/
def Arrays.Keep (a : Arrays) (it : Nat → Item) (N b : Nat) (x : BlockId) : Prop :=
  a.ReadOnly it N x ∨ ∃ k, b ≤ k ∧ k < N ∧ x = (it k).sha.id

/-- After items `j < b` of `N`: the kept blocks as at `m₀`, room at `results[b …]`, and
`results[j]` holding item `j`'s code. -/
structure Inv (m₀ m : MemoryState) (a : Arrays) (it : Nat → Item) (N b : Nat) : Prop where
  same : m₀.SameOn m (a.Keep it N b)
  room : ∀ k, b ≤ k → k < N → Room m (a.result k) 32
  done : ∀ k < b, m.readAt (a.result k) 32 = (it k).code m₀

/-- The state after `verify_x8` on `c` items. -/
noncomputable def x8State (nb : Arrays → (Nat → Item) → Nat → GlobalState → Nat) (a : Arrays)
    (it : Nat → Item) (c : Nat) (S : GlobalState) : GlobalState :=
  { alloc := ⟨S.alloc.nextFreeBlock + nb a it c S⟩, mem := x8Mem S.mem a.results it c }

section Lemmas

variable {m₀ m m₁ : MemoryState} {a : Arrays} {it : Nat → Item} {N b c : Nat}

theorem add_ofNat_add (p : Pointer) (b j s : Nat) :
    (p.add (BitVec.ofNat 64 (b * s))).add (BitVec.ofNat 64 (j * s)) =
      p.add (BitVec.ofNat 64 ((b + j) * s)) := by
  rw [Pointer.add_add, ← BitVec.ofNat_add, Nat.add_mul]

theorem Arrays.drop_result (a : Arrays) (b j : Nat) : (a.drop b).result j = a.result (b + j) :=
  add_ofNat_add _ _ _ _

/-- A read below the erase's counter. -/
theorem readAt_eraseFrom_of_lt {m : MemoryState} {q : Pointer} {n w : Nat} (h : q.id.id < n) :
    (m.eraseFrom n).readAt q w = m.readAt q w := by
  have he : (m.eraseFrom n)[q.id]? = m[q.id]? := by
    simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter',
      h, decide_true]
    cases m.mem[q.id]? <;> rfl
  simp only [MemoryState.readAt, he]

theorem Arrays.drop_drop (a : Arrays) (b c : Nat) : (a.drop b).drop c = a.drop (b + c) := by
  simp only [Arrays.drop, add_ofNat_add]

theorem Arrays.drop_zero (a : Arrays) :
    a.drop 0 = ⟨a.msgs, a.msgSzs, a.sigs, a.pks, a.shas, a.results⟩ := by
  simp [Arrays.drop, Pointer.add, BitVec.add_zero]

/-- Codes `i ≠ k` of `N` are apart. -/
theorem Arrays.result_disjoint (hoff : a.results.offset.toNat + 4 * N < 2 ^ 64) {i k : Nat}
    (hi : i < N) (hk : k < N) (hik : i ≠ k) :
    (Range.of (a.result i) 32).Disjoint (Range.of (a.result k) 32) := by
  have h1 : ¬a.results.offset.uaddOverflow (BitVec.ofNat 64 (i * 4)) := by
    simp [BitVec.uaddOverflow]; omega
  have h2 : ¬a.results.offset.uaddOverflow (BitVec.ofNat 64 (k * 4)) := by
    simp [BitVec.uaddOverflow]; omega
  simp only [Arrays.result, Range.Disjoint, Range.of, Pointer.offsetInBits_add h1,
    Pointer.offsetInBits_add h2, BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Arrays.keep_mono {x : BlockId} (h : a.Keep it N c x) (hbc : b ≤ c) :
    a.Keep it N b x := by
  rcases h with h | ⟨k, hk, hkN, rfl⟩
  · exact .inl h
  · exact .inr ⟨k, by omega, hkN, rfl⟩

theorem BatchOk.results_not_keep (hB : BatchOk m₀ a it N) : ¬a.Keep it N b a.results.id := by
  rintro (h | ⟨k, -, hk, he⟩)
  · exact hB.sep.1 h
  · exact (hB.sep.2.1 k hk).2 he.symm

/-- Item `c`'s hash object is in no block kept after it. -/
theorem BatchOk.sha_not_keep (hB : BatchOk m₀ a it N) (hc : c < N) (hcb : c < b) :
    ¬a.Keep it N b (it c).sha.id := by
  rintro (h | ⟨k, hk, hkN, he⟩)
  · exact (hB.sep.2.1 c hc).1 h
  · exact hB.sep.2.2 c hc k hkN (by omega) he

theorem BatchOk.msg_ne_sha (hB : BatchOk m₀ a it N) (hk : k < N) :
    (it k).msg.id ≠ (it k).sha.id :=
  fun he => (hB.sep.2.1 k hk).1 (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inl he.symm⟩)))))

theorem BatchOk.sig_ne_sha (hB : BatchOk m₀ a it N) (hk : k < N) :
    (it k).sig.id ≠ (it k).sha.id :=
  fun he => (hB.sep.2.1 k hk).1 (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inl he.symm)⟩)))))

theorem BatchOk.pk_ne_sha (hB : BatchOk m₀ a it N) (hk : k < N) :
    (it k).pk.id ≠ (it k).sha.id :=
  fun he => (hB.sep.2.1 k hk).1 (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inr he.symm)⟩)))))

theorem Inv.start (hB : BatchOk m₀ a it N) : Inv m₀ m₀ a it N 0 :=
  ⟨.refl m₀, fun k _ hk => hB.room k hk, fun _ h => absurd h (Nat.not_lt_zero _)⟩

/-- Entry `j` of the arrays from item `b` holds item `b + j`, as at `m₀`. -/
theorem Inv.holds (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N c) {b j : Nat}
    (h : b + j < N) : (a.drop b).Holds m j (it (b + j)) := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩ := hB.holds (b + j) h
  have hs := hI.same
  simp only [Arrays.Holds, Arrays.drop, add_ofNat_add]
  exact ⟨hs.inBounds (.inl (.inl rfl)) h1, (hs.loadPtr (by exact .inl (.inl rfl))).trans h2,
    hs.fits (.inl (.inr (.inl rfl))) h3, (hs.readAt (by exact .inl (.inr (.inl rfl)))).trans h4,
    hs.inBounds (.inl (.inr (.inr (.inl rfl)))) h5,
    (hs.loadPtr (by exact .inl (.inr (.inr (.inl rfl))))).trans h6,
    hs.inBounds (.inl (.inr (.inr (.inr (.inl rfl))))) h7,
    (hs.loadPtr (by exact .inl (.inr (.inr (.inr (.inl rfl)))))).trans h8,
    hs.inBounds (.inl (.inr (.inr (.inr (.inr (.inl rfl)))))) h9,
    (hs.loadPtr (by exact .inl (.inr (.inr (.inr (.inr (.inl rfl))))))).trans h10⟩

/-- Item `k ≥ c`'s inputs and hash object, as at `m₀`. -/
theorem Inv.ok (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N c) {k : Nat} (hc : c ≤ k)
    (hk : k < N) : (it k).Ok m := by
  obtain ⟨o1, o2, o3, o4, o5, o6, o7, o8, o9⟩ := hB.ok k hk
  have hs := hI.same
  exact ⟨hs.fits (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inl rfl⟩)))))) o1, o2, o3,
    hs.fits (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inl rfl)⟩)))))) o4, o5,
    hs.fits (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inr rfl)⟩)))))) o6, o7,
    hs.shaFit (.inr ⟨k, hc, hk, rfl⟩) o8, hs.writable (.inr ⟨k, hc, hk, rfl⟩) o9⟩

/-- `fd_ed25519_verify` on item `k ≥ c` at `m` is as at `m₀`. -/
theorem Inv.verifySpec (hI : Inv m₀ m a it N c) {k : Nat} (hc : c ≤ k) (hk : k < N) :
    (it k).verifySpec m = (it k).verifySpec m₀ := by
  have hs := hI.same
  simp only [Item.verifySpec, Item.readMsg, Item.readR, Item.readS, Item.readA,
    hs.readAt (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inl rfl⟩)))))),
    hs.readAt (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inl rfl)⟩)))))),
    hs.readAt (q := (it k).sig.add 32#64)
      (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inl rfl)⟩)))))),
    hs.readAt (.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inr rfl)⟩)))))),
    hs.readAt (q := (it k).sha) (.inr ⟨k, hc, hk, rfl⟩)]

/-- `fd_ed25519_verify`'s code is `Ed25519.Firedancer.verify`'s. -/
theorem Item.verifySpec_ret (m : MemoryState) (it : Item) : (it.verifySpec m).ret = it.code m :=
  Avx512.fd_ed25519_verify.spec_ret _ _ _ _ _ _

/-- Item `c`'s code stored at `results[c]` over a memory `m₁` that kept the later items' blocks and
`results`'. -/
theorem Inv.store (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N c) (hc : c < N)
    (h₁ : m.SameOn m₁ fun x => a.Keep it N (c + 1) x ∨ x = a.results.id) :
    Inv m₀ (m₁.storeAt (a.result c) ((it c).code m₀)) a it N (c + 1) := by
  have hoff := hB.off.2.2.2.2.2
  have hroom₁ : ∀ k, c ≤ k → k < N → Room m₁ (a.result k) 32 := fun k hck hk =>
    h₁.room (q := a.result k) (.inr rfl) (hI.room k hck hk)
  have hst : m₁.SameOn (m₁.storeAt (a.result c) ((it c).code m₀)) (a.Keep it N (c + 1)) :=
    (MemoryState.StoresOff.store (p := a.result c) (.refl m₁) hB.results_not_keep _).sameOn
  refine ⟨((hI.same.mono fun _ h => a.keep_mono h (Nat.le_succ c)).trans
    (h₁.mono fun _ h => .inl h)).trans hst, fun k hk hkN => (hroom₁ k (by omega) hkN).storeAt,
    fun k hk => ?_⟩
  by_cases hkc : k = c
  · subst hkc
    exact MemoryState.readAt_storeAt_self (hroom₁ k le_rfl hc) _
  · rw [MemoryState.readAt_storeAt_disjoint
        (Arrays.result_disjoint hoff hc (by omega) (Ne.symm hkc)),
      h₁.readAt (q := a.result k) (.inr rfl), hI.done k (by omega)]

theorem Arrays.drop_results_offset (hB : BatchOk m₀ a it N) (hb : b ≤ N) :
    (a.drop b).results.offset.toNat = a.results.offset.toNat + 4 * b := by
  have hoff := hB.off.2.2.2.2.2
  simp only [Arrays.drop, Pointer.add]
  rw [BitVec.toNat_add_of_not_uaddOverflow (by simp [BitVec.uaddOverflow]; omega),
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  omega

/-- `verify_x8` reads only its items' inputs. -/
theorem x8Of_sameOn {m m' : MemoryState} {K : BlockId → Prop} (h : m.SameOn m' K)
    {it : Nat → Item} {cnt : Nat}
    (hK : ∀ j < cnt, K (it j).msg.id ∧ K (it j).sig.id ∧ K (it j).pk.id) :
    x8Of m' it cnt = x8Of m it cnt := by
  have hR (j : Nat) (hj : j < cnt) : (it j).readR m' = (it j).readR m := h.readAt (hK j hj).2.1
  have hS (j : Nat) (hj : j < cnt) : (it j).readS m' = (it j).readS m :=
    h.readAt (q := (it j).sig.add 32#64) (hK j hj).2.1
  have hA (j : Nat) (hj : j < cnt) : (it j).readA m' = (it j).readA m := h.readAt (hK j hj).2.2
  have hM (j : Nat) (hj : j < cnt) : (it j).readMsg m' = (it j).readMsg m := h.readAt (hK j hj).1
  have hD (j : Nat) (hj : j < cnt) : (it j).digest m' = (it j).digest m := by
    simp only [Item.digest, hR j hj, hA j hj, hM j hj]
  have hRf : (fun j : Fin 8 => if j.val < cnt then (it j).readR m' else 0) =
      fun j : Fin 8 => if j.val < cnt then (it j).readR m else 0 := by
    funext j; split <;> [exact hR j ‹_›; rfl]
  have hSf : (fun j : Fin 8 => if j.val < cnt then (it j).readS m' else 0) =
      fun j : Fin 8 => if j.val < cnt then (it j).readS m else 0 := by
    funext j; split <;> [exact hS j ‹_›; rfl]
  have hAf : (fun j : Fin 8 => if j.val < cnt then (it j).readA m' else 0) =
      fun j : Fin 8 => if j.val < cnt then (it j).readA m else 0 := by
    funext j; split <;> [exact hA j ‹_›; rfl]
  have hDf : (fun j : Fin 8 => if j.val < cnt then (it j).digest m' else 0) =
      fun j : Fin 8 => if j.val < cnt then (it j).digest m else 0 := by
    funext j; split <;> [exact hD j ‹_›; rfl]
  unfold x8Of
  rw [hRf, hSf, hAf, hDf]

/-- `verify_x8`'s code for item `j < cnt` is `Ed25519.Firedancer.verify`'s. -/
theorem x8Of_resultAt {m : MemoryState} {it : Nat → Item} {cnt j : Nat} (hj : j < cnt)
    (h8 : cnt ≤ 8) : (x8Of m it cnt).resultAt j = (it j).code m := by
  have hj8 : j < 8 := by omega
  simp only [X8.resultAt, hj8, ↓reduceDIte]
  rw [x8Of, show x8Tbl = laneTbl from rfl,
    x8_result_lane (j := ⟨j, hj8⟩) hj (msg := bytesLE ((it j).readMsg m))
      (by
        simp only [Fin.val_mk, hj, ↓reduceIte, Item.digest]
        exact Ref.fd_ed25519_verify.hash_eq _ _ _ _ _)]
  simp only [hj, ↓reduceIte, Item.code]

/-- `verify_x8` on items `b … b + cnt - 1`: their codes at `results[b …]`. -/
theorem Inv.x8 (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N b) {cnt : Nat}
    (hcnt : b + cnt ≤ N) (h8 : cnt ≤ 8) :
    Inv m₀ (x8Mem m (a.drop b).results (fun j => it (b + j)) cnt) a it N (b + cnt) := by
  have hoff := hB.off.2.2.2.2.2
  have hso : m.StoresOff (a.Keep it N (b + cnt))
      (x8Mem m (a.drop b).results (fun j => it (b + j)) cnt) :=
    MemoryState.StoresOff.x8Mem (by exact hB.results_not_keep)
      fun j hj => hB.sha_not_keep (by omega) (by omega)
  refine ⟨(hI.same.mono fun _ h => a.keep_mono h (by omega)).trans hso.sameOn,
    fun k hk hkN => (hI.room k (by omega) hkN).x8Mem, fun k hk => ?_⟩
  by_cases hkb : k < b
  · rw [readAt_x8Mem_of_disjoint (q := a.result k) (cnt := cnt)
        (fun j hj => (hB.sep.2.1 (b + j) (by omega)).2.symm)
        (fun j hj => by
          rw [show (a.drop b).results.add (BitVec.ofNat 64 (j * 4)) = (a.drop b).result j from rfl,
            Arrays.drop_result]
          exact Arrays.result_disjoint hoff (by omega) (by omega) (by omega)),
      hI.done k hkb]
  · obtain ⟨j, rfl⟩ : ∃ j, k = b + j := ⟨k - b, by omega⟩
    have hj : j < cnt := by omega
    rw [← Arrays.drop_result, Arrays.result,
      readAt_x8Mem hj (by rw [Arrays.drop_results_offset hB (by omega)]; omega)
        (by
          rw [show (a.drop b).results.add (BitVec.ofNat 64 (j * 4)) = (a.drop b).result j from rfl,
            Arrays.drop_result]
          exact hI.room _ (by omega) (by omega)),
      x8Of_sameOn hI.same fun i hi =>
        ⟨.inl (.inr (.inr (.inr (.inr (.inr ⟨b + i, by omega, .inl rfl⟩))))),
          .inl (.inr (.inr (.inr (.inr (.inr ⟨b + i, by omega, .inr (.inl rfl)⟩))))),
          .inl (.inr (.inr (.inr (.inr (.inr ⟨b + i, by omega, .inr (.inr rfl)⟩)))))⟩,
      x8Of_resultAt hj h8]

/-- Item `c`'s `fd_ed25519_verify` and the store of its code (the uncached tail). -/
theorem Inv.verify (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N c) (hc : c < N) :
    Inv m₀ ((((it c).verifySpec m).mem m (it c).sha).storeAt (a.result c)
      ((it c).verifySpec m).ret) a it N (c + 1) := by
  rw [hI.verifySpec le_rfl hc, Item.verifySpec_ret]
  refine hI.store hB hc (MemoryState.StoresOff.resultMem ?_ _).sameOn
  rintro (h | h)
  · exact hB.sha_not_keep hc (by omega) h
  · exact (hB.sep.2.1 c hc).2 h

theorem Pointer.offset_add_ofNat {p : Pointer} {k : Nat} (h : p.offset.toNat + k < 2 ^ 64) :
    (p.add (BitVec.ofNat 64 k)).offset.toNat = p.offset.toNat + k := by
  simp only [Pointer.add]
  rw [BitVec.toNat_add_of_not_uaddOverflow (by simp [BitVec.uaddOverflow]; omega),
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]

/-- The arrays from item `b` do not wrap for the `N - b` items left. -/
theorem BatchOk.drop_off (hB : BatchOk m₀ a it N) (hb : b ≤ N) :
    (a.drop b).msgs.offset.toNat + 8 * (N - b) < 2 ^ 64 ∧
      (a.drop b).msgSzs.offset.toNat + 8 * (N - b) < 2 ^ 64 ∧
      (a.drop b).sigs.offset.toNat + 8 * (N - b) < 2 ^ 64 ∧
      (a.drop b).pks.offset.toNat + 8 * (N - b) < 2 ^ 64 ∧
      (a.drop b).shas.offset.toNat + 8 * (N - b) < 2 ^ 64 ∧
      (a.drop b).results.offset.toNat + 4 * (N - b) < 2 ^ 64 := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hB.off
  simp only [Arrays.drop]
  rw [Pointer.offset_add_ofNat (by omega), Pointer.offset_add_ofNat (by omega),
    Pointer.offset_add_ofNat (by omega), Pointer.offset_add_ofNat (by omega),
    Pointer.offset_add_ofNat (by omega), Pointer.offset_add_ofNat (by omega)]
  omega

theorem ofNat_sub_eq {r : Nat} {c : BitVec 64} (hr : r < 2 ^ 64) (hc : c.toNat ≤ r) :
    BitVec.ofNat 64 r - c = BitVec.ofNat 64 (r - c.toNat) := by
  rw [← BitVec.toNat_inj]
  simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]
  omega

theorem ofNat_ult_iff {r k : Nat} (hr : r < 2 ^ 64) (hk : k < 2 ^ 64) :
    (BitVec.ofNat 64 r).ult (BitVec.ofNat 64 k) = true ↔ r < k := by
  simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.mod_eq_of_lt hr,
    Nat.mod_eq_of_lt hk]

/-- `fd_ulong_min( r, 8UL )` as the lift computes it. -/
theorem umin_eight_toNat {r : Nat} (hr : r < 2 ^ 64) :
    (if (BitVec.ofNat 64 r).ult 8#64 = true then BitVec.ofNat 64 r else 8#64).toNat = min r 8 := by
  split
  · rename_i h
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hr]
    have := (ofNat_ult_iff hr (k := 8) (by decide)).1 h
    omega
  · rename_i h
    have := mt (ofNat_ult_iff hr (k := 8) (by decide)).2 h
    simp only [BitVec.toNat_ofNat]
    omega

/-- A counter below `n < 2 ^ 64` stepped by one reaches `n` exactly when it is `n - 1`. -/
theorem ofNat_add_one_eq_iff {j n : Nat} (hj : j < n) (hn : n < 2 ^ 64) :
    BitVec.ofNat 64 j + 1#64 = BitVec.ofNat 64 n ↔ j + 1 = n := by
  rw [← BitVec.toNat_inj]
  simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

/-- A batch's first `n` items. -/
theorem BatchOk.mono (hB : BatchOk m a it N) {n : Nat} (hn : n ≤ N) : BatchOk m a it n := by
  have hro {x : BlockId} (h : a.ReadOnly it n x) : a.ReadOnly it N x := by
    rcases h with h | h | h | h | h | ⟨j, hj, h⟩
    · exact .inl h
    · exact .inr (.inl h)
    · exact .inr (.inr (.inl h))
    · exact .inr (.inr (.inr (.inl h)))
    · exact .inr (.inr (.inr (.inr (.inl h))))
    · exact .inr (.inr (.inr (.inr (.inr ⟨j, by omega, h⟩))))
  obtain ⟨o1, o2, o3, o4, o5, o6⟩ := hB.off
  exact ⟨fun j hj => hB.holds j (by omega), fun j hj => hB.ok j (by omega),
    fun j hj => hB.room j (by omega), by have := hB.len; omega, by omega,
    ⟨fun h => hB.sep.1 (hro h), fun j hj => ⟨fun h => (hB.sep.2.1 j (by omega)).1 (hro h),
      (hB.sep.2.1 j (by omega)).2⟩, fun j hj k hk => hB.sep.2.2 j (by omega) k (by omega)⟩⟩

/-- The items from `b` on, at a memory past items `j < b`. -/
theorem Inv.batchOk (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N b) (hb : b ≤ N) :
    BatchOk m (a.drop b) (fun j => it (b + j)) (N - b) := by
  have hro {x : BlockId} (h : (a.drop b).ReadOnly (fun j => it (b + j)) (N - b) x) :
      a.ReadOnly it N x := by
    rcases h with h | h | h | h | h | ⟨j, hj, h⟩
    · exact .inl h
    · exact .inr (.inl h)
    · exact .inr (.inr (.inl h))
    · exact .inr (.inr (.inr (.inl h)))
    · exact .inr (.inr (.inr (.inr (.inl h))))
    · exact .inr (.inr (.inr (.inr (.inr ⟨b + j, by omega, h⟩))))
  exact ⟨fun j hj => hI.holds hB (by omega), fun j hj => hI.ok hB (by omega) (by omega),
    fun j hj => by rw [Arrays.drop_result]; exact hI.room _ (by omega) (by omega),
    by have := hB.len; omega, hB.drop_off hb,
    ⟨fun h => hB.sep.1 (hro h),
      fun j hj => ⟨fun h => (hB.sep.2.1 (b + j) (by omega)).1 (hro h),
        (hB.sep.2.1 (b + j) (by omega)).2⟩,
      fun j hj k hk hjk => hB.sep.2.2 (b + j) (by omega) (b + k) (by omega) (by omega)⟩⟩

/-- A kept block, or `results`', is a block of `m₀`. -/
theorem BatchOk.keep_isSome (hB : BatchOk m₀ a it N) (hN : 0 < N) {x : BlockId}
    (hx : a.Keep it N 0 x ∨ x = a.results.id) : (m₀[x]?).isSome := by
  obtain ⟨h1, -, h3, -, h5, -, h7, -, h9, -⟩ := hB.holds 0 hN
  have hin {p : Pointer} {w : Nat} (h : InBounds m₀ p w) (he : x = p.id) : (m₀[x]?).isSome := by
    obtain ⟨blk, hblk, -⟩ := h
    rw [he, hblk]; rfl
  unfold Arrays.Keep Arrays.ReadOnly at hx
  rcases hx with ((h | h | h | h | h | ⟨k, hk, h | h | h⟩) | ⟨k, -, hk, h⟩) | h
  · exact hin h1 h
  · exact hin h3.inBounds h
  · exact hin h5 h
  · exact hin h7 h
  · exact hin h9 h
  · exact hin (hB.ok k hk).1.inBounds h
  · exact hin (hB.ok k hk).2.2.2.1.inBounds h
  · exact hin (hB.ok k hk).2.2.2.2.2.1.inBounds h
  · exact hin (hB.ok k hk).2.2.2.2.2.2.2.1.1.inBounds h
  · exact hin (hB.room 0 hN).inBounds h

/-- Item `c`'s cached verify, which kept every block but its hash object's, the cache's and new
ones, and the store of its code. -/
theorem Inv.verifyCached (hB : BatchOk m₀ a it N) (hI : Inv m₀ m a it N c) (hc : c < N)
    {cache : Pointer} (hcache : ¬a.Keep it N 0 cache.id ∧ cache.id ≠ a.results.id)
    {s : GlobalState} (hs : s.mem = m) (hwf : s.WF)
    (h₁ : m.SameOn m₁ fun x => x ≠ (it c).sha.id ∧ x ≠ cache.id ∧ x.id < s.alloc.nextFreeBlock) :
    Inv m₀ (m₁.storeAt (a.result c) ((it c).verifySpec m).ret) a it N (c + 1) := by
  rw [hI.verifySpec le_rfl hc, Item.verifySpec_ret]
  refine hI.store hB hc (h₁.mono fun x hx => ⟨?_, ?_, ?_⟩)
  · rintro rfl
    rcases hx with h | h
    · exact hB.sha_not_keep hc (by omega) h
    · exact (hB.sep.2.1 c hc).2 h
  · rintro rfl
    rcases hx with h | h
    · exact hcache.1 (a.keep_mono h (Nat.zero_le _))
    · exact hcache.2 h
  · have hsome : (m[x]?).isSome := by
      rcases hx with h | h
      · rw [hI.same.1 x (a.keep_mono h (Nat.le_succ c))]
        exact hB.keep_isSome (by omega) (.inl (a.keep_mono h (Nat.zero_le _)))
      · obtain ⟨blk, hblk, -⟩ := (hI.room c le_rfl hc).inBounds
        rw [h]
        exact Option.isSome_iff_exists.2 ⟨blk, hblk⟩
    subst hs
    exact hwf.bound x (Std.ExtHashMap.mem_iff_isSome_getElem?.2 hsome)

end Lemmas

/-! ## `fd_ed25519_verify_batch_multi_msg` -/

section Proof

open _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg (Γ)

attribute [local mlir_transport] Room.resultMem MemoryState.Globals.resultMem
  GlobalState.WF.resultMem_mk Room.x8Mem MemoryState.Globals.x8Mem GlobalState.WF.x8Mem_mk

namespace fd_ed25519_verify_batch_multi_msg

/-- `^bb2`'s registers at item `j` of `n` (the tail loop). -/
abbrev TailEnv (E : ⟪Γ⟫) (a : Arrays) (n j : Nat) : Prop :=
  E ⊨ [%3 := 1#64, %5 := a.msgs, %6 := BitVec.ofNat 64 n, %7 := a.results, %8 := a.shas,
    %9 := a.pks, %10 := a.sigs, %11 := a.msgSzs, %13 := BitVec.ofNat 64 j]

/-- The state after item `j`'s `fd_ed25519_verify` and the store of its code. -/
noncomputable def tailState
    (nb : Pointer → BitVec 64 → Pointer → Pointer → Pointer → GlobalState → Nat) (a : Arrays)
    (j : Nat) (it : Item) (S : GlobalState) : GlobalState :=
  { alloc := ⟨S.alloc.nextFreeBlock + nb it.msg it.msgSz it.sig it.pk it.sha S⟩,
    mem :=
      ((it.verifySpec S.mem).mem S.mem it.sha).storeAt (a.result j) (it.verifySpec S.mem).ret }

/-- One trip through `^bb2`: `results[j] = fd_ed25519_verify( msgs[j], … )`, `j++`; back while
`j < n`. -/
theorem tail_trip (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (a : Arrays) (n j : Nat) (it : Item) (nb) (hv : VerifyCallEq nb) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hR : TailEnv E a n j) (hj : j < n)
    (hlen : 8 * n < 2 ^ 63) (hoff1 : a.msgs.offset.toNat + 8 * n < 2 ^ 64)
    (hoff2 : a.msgSzs.offset.toNat + 8 * n < 2 ^ 64) (hoff3 : a.sigs.offset.toNat + 8 * n < 2 ^ 64)
    (hoff4 : a.pks.offset.toNat + 8 * n < 2 ^ 64) (hoff5 : a.shas.offset.toNat + 8 * n < 2 ^ 64)
    (hoff6 : a.results.offset.toNat + 4 * n < 2 ^ 64) (hwf : S.WF)
    (hg : S.mem.Globals ((LIFT).globals ++ Gb)) (hholds : a.Holds S.mem j it) (hok : it.Ok S.mem)
    (hroom : Room S.mem (a.result j) 32)
    (hmsg : it.msg.id ≠ it.sha.id) (hsig : it.sig.id ≠ it.sha.id) (hpk : it.pk.id ≠ it.sha.id)
    (hback :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), TailEnv E' a n (j + 1) → S' = tailState nb a j it S →
        j + 1 < n → ((LIFT).runFrom E' 2 S' >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), S' = tailState nb a j it S → j + 1 = n →
        ((LIFT).runFrom E' 4 S' >>= g) = K) :
    ((LIFT).runFrom E 2 S >>= g) = K := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩ := hholds
  obtain ⟨o1, o2, o3, o4, o5, o6, o7, o8, o9⟩ := hok
  have hj64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hj1 : (BitVec.ofNat 64 j).uaddOverflow 1#64 = false := by
    simp [BitVec.uaddOverflow]; omega
  block_init
  -- results[j] = fd_ed25519_verify( msgs[j], msg_szs[j], sigs[j], public_keys[j], shas[j] )
  step_pure [hj64]
  step_load consuming h2
  step_pure [hj64]
  step_load consuming h4
  step_pure [hj64]
  step_load consuming h6
  step_pure [hj64]
  step_load consuming h8
  step_pure [hj64]
  step_load consuming h10
  step_call using hv consuming hg h1 h3 h5 h7 h9 o1 o4 o6 o8 o9
  step_pure [hj64]
  step_store
  -- j++, j < n
  step_pure [hj1]
  step_pure
  finish_block
  · step_loop using hexit
    · rfl
    · exact (ofNat_add_one_eq_iff hj (by omega)).1 hbr
  · step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · rfl
    · have := mt (ofNat_add_one_eq_iff hj (by omega)).2 hbr
      omega

theorem tailState_wf {S : GlobalState} (h : S.WF) : (tailState nb a j it S).WF :=
  GlobalState.WF.storeAt (s := ⟨_, _⟩) h.resultMem_mk

theorem tailState_globals {S : GlobalState} (h : S.mem.Globals G) :
    (tailState nb a j it S).mem.Globals G :=
  (MemoryState.StoresOff.store (K := fun _ => False) (.refl _) (fun h => h) _).globals
    h.resultMem

/-- The tail loop from item `j` of the `n` items from item `b`: their codes at `results[b …]`. -/
theorem tail (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global) (nb)
    (hv : VerifyCallEq nb) {m₀ : MemoryState} {a : Arrays} {it : Nat → Item} {N : Nat}
    (hB : BatchOk m₀ a it N) (b n : Nat) (hbn : b + n = N) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ r j (S : GlobalState) (E : ⟪Γ⟫), j + r + 1 = n → TailEnv E (a.drop b) n j → S.WF →
      S.mem.Globals ((LIFT).globals ++ Gb) →
      Inv m₀ S.mem a it N (b + j) →
      (∀ (E' : ⟪Γ⟫) (S' : GlobalState), S'.WF →
        S'.mem.Globals ((LIFT).globals ++ Gb) →
        Inv m₀ S'.mem a it N N → ((LIFT).runFrom E' 4 S' >>= g) = K) →
      ((LIFT).runFrom E 2 S >>= g) = K := by
  have hlen := hB.len
  obtain ⟨hoff1, hoff2, hoff3, hoff4, hoff5, hoff6⟩ := hB.drop_off (b := b) (by omega)
  rw [show N - b = n by omega] at hoff1 hoff2 hoff3 hoff4 hoff5 hoff6
  intro r
  induction r with
  | zero =>
    intro j S E hj hR hwf hg hI hK
    refine tail_trip batch Gb (a.drop b) n j (it (b + j)) nb hv S E g K hR (by omega) (by omega)
      hoff1 hoff2 hoff3 hoff4 hoff5 hoff6 hwf hg (hI.holds hB (by omega))
      (hI.ok hB le_rfl (by omega)) (by rw [Arrays.drop_result]; exact hI.room _ le_rfl (by omega))
      (hB.msg_ne_sha (by omega)) (hB.sig_ne_sha (by omega)) (hB.pk_ne_sha (by omega))
      (fun _ _ _ _ h => by omega) ?_
    intro E' S' hS' _
    subst hS'
    have hI' := hI.verify hB (c := b + j) (by omega)
    rw [show b + j + 1 = N by omega] at hI'
    exact hK E' _ (tailState_wf hwf) (tailState_globals hg)
      (by rw [tailState, Arrays.drop_result]; exact hI')
  | succ r ih =>
    intro j S E hj hR hwf hg hI hK
    refine tail_trip batch Gb (a.drop b) n j (it (b + j)) nb hv S E g K hR (by omega) (by omega)
      hoff1 hoff2 hoff3 hoff4 hoff5 hoff6 hwf hg (hI.holds hB (by omega))
      (hI.ok hB le_rfl (by omega)) (by rw [Arrays.drop_result]; exact hI.room _ le_rfl (by omega))
      (hB.msg_ne_sha (by omega)) (hB.sig_ne_sha (by omega)) (hB.pk_ne_sha (by omega)) ?_
      (fun _ _ _ h => by omega)
    intro E' S' hR' hS' _
    subst hS'
    have hI' := hI.verify hB (c := b + j) (by omega)
    exact ih (j + 1) _ E' (by omega) hR' (tailState_wf hwf) (tailState_globals hg)
      (by rw [tailState, Arrays.drop_result]; exact hI') hK

/-- `^bb1`'s registers at `r` items left (the group loop). -/
abbrev GroupEnv (E : ⟪Γ⟫) (a : Arrays) (r : Nat) : Prop :=
  E ⊨ [%0 := 0#64, %1 := 3#64, %2 := 8#64, %3 := 1#64, %5 := a.msgs, %6 := BitVec.ofNat 64 r,
    %7 := a.results, %8 := a.shas, %9 := a.pks, %10 := a.sigs, %11 := a.msgSzs]

/-- One trip through `^bb1`: with `r < 3` items left into the tail loop; else `verify_x8` on
`cnt = min(r, 8)` items, the arrays advanced, and back while items are left. -/
theorem group_trip (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (nb) (hx : X8CallEq batch Gb nb) (a : Arrays) (it : Nat → Item) (r : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hR : GroupEnv E a r)
    (hlen : 8 * r < 2 ^ 63) (hoff1 : a.msgs.offset.toNat + 8 * r < 2 ^ 64)
    (hoff2 : a.msgSzs.offset.toNat + 8 * r < 2 ^ 64) (hoff3 : a.sigs.offset.toNat + 8 * r < 2 ^ 64)
    (hoff4 : a.pks.offset.toNat + 8 * r < 2 ^ 64) (hoff5 : a.shas.offset.toNat + 8 * r < 2 ^ 64)
    (hoff6 : a.results.offset.toNat + 4 * r < 2 ^ 64) (hwf : S.WF)
    (hg : S.mem.Globals ((LIFT).globals ++ Gb)) (hB : BatchOk S.mem a it (min r 8))
    (htail : ∀ E' : ⟪Γ⟫, TailEnv E' a r 0 → r < 3 → ((LIFT).runFrom E' 2 S >>= g) = K)
    (hback : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), GroupEnv E' (a.drop (min r 8)) (r - min r 8) →
      S' = x8State nb a it (min r 8) S → 8 < r → ((LIFT).runFrom E' 1 S' >>= g) = K)
    (hexit : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), S' = x8State nb a it (min r 8) S → 3 ≤ r → r ≤ 8 →
      ((LIFT).runFrom E' 4 S' >>= g) = K) :
    ((LIFT).runFrom E 1 S >>= g) = K := by
  block_init
  -- if( batch_sz<=2UL ): the tail
  step_pure
  finish_block
  · exact htail _ (by env_reads) ((ofNat_ult_iff (by omega) (by decide)).1 hbr)
  have hr3 : 3 ≤ r := Nat.le_of_not_lt (mt (ofNat_ult_iff (by omega) (by decide)).2 hbr)
  block_init
  -- cnt = fd_ulong_min( batch_sz, 8UL ); verify_x8( …, cnt )
  step_pure with cnt
  have hc : cnt.toNat = min r 8 := by
    rw [hcnt]; exact umin_eight_toNat (by omega)
  rw [← hc] at hB hback hexit
  have h3 : 3 ≤ cnt.toNat := by omega
  step_call using (hx a it) consuming hg hB h3
  -- msgs += cnt; …; batch_sz -= cnt
  iterate 6 step_pure
  step_pure
  step_pure
  have hsub : BitVec.ofNat 64 r - cnt = BitVec.ofNat 64 (r - cnt.toNat) :=
    ofNat_sub_eq (by omega) (by omega)
  finish_block
  · rw [hsub] at hbr
    have h8 : r ≤ 8 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    step_loop using hexit
    rfl
  · rw [hsub] at hbr
    have h8 : 8 < r := by
      have : r - cnt.toNat ≠ 0 := fun h => hbr (by rw [h])
      omega
    step_loop using hback
    · rw [hcnt] at hsub
      exact hsub
    · rfl

/-- The group loop from item `b` with `r > 0` items left: every code at `results[b …]`. -/
theorem groups (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (nbv) (hv : VerifyCallEq nbv) (nbx) (hx : X8CallEq batch Gb nbx) {m₀ : MemoryState} {a : Arrays}
    {it : Nat → Item} {N : Nat} (hB : BatchOk m₀ a it N) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ r b (S : GlobalState) (E : ⟪Γ⟫), b + r = N → 0 < r → GroupEnv E (a.drop b) r → S.WF →
      S.mem.Globals ((LIFT).globals ++ Gb) →
      Inv m₀ S.mem a it N b →
      (∀ (E' : ⟪Γ⟫) (S' : GlobalState), S'.WF →
        S'.mem.Globals ((LIFT).globals ++ Gb) →
        Inv m₀ S'.mem a it N N → ((LIFT).runFrom E' 4 S' >>= g) = K) →
      ((LIFT).runFrom E 1 S >>= g) = K := by
  intro r
  induction r using Nat.strong_induction_on with
  | _ r ih =>
  intro b S E hbN hr hR hwf hg hI hK
  have hBo := hI.batchOk hB (by omega)
  rw [show N - b = r by omega] at hBo
  obtain ⟨o1, o2, o3, o4, o5, o6⟩ := hBo.off
  refine group_trip batch Gb nbx hx (a.drop b) (fun j => it (b + j)) r S E g K hR hBo.len o1 o2 o3
    o4 o5 o6 hwf hg (hBo.mono (by omega)) ?_ ?_ ?_
  · intro E' hR' _
    exact tail batch Gb nbv hv hB b r hbN g K (r - 1) 0 S E' (by omega) hR' hwf hg hI hK
  · intro E' S' hR' hS' _
    subst hS'
    exact ih (r - min r 8) (by omega) (b + min r 8) _ E' (by omega) (by omega)
      (by rw [← Arrays.drop_drop]; exact hR') hwf.x8Mem_mk hg.x8Mem
      (hI.x8 hB (by omega) (by omega)) hK
  · intro E' S' hS' _ _
    subst hS'
    have hI' := hI.x8 hB (cnt := min r 8) (by omega) (by omega)
    rw [show b + min r 8 = N by omega] at hI'
    exact hK E' _ hwf.x8Mem_mk hg.x8Mem hI'

end fd_ed25519_verify_batch_multi_msg

open fd_ed25519_verify_batch_multi_msg

/-- `fd_ed25519_verify_batch_multi_msg( msgs, msg_szs, sigs, public_keys, shas, results,
batch_sz )`, given its callees' interfaces and the C's preconditions (`BatchOk`), returns with
`results[j]` holding `Ed25519.Firedancer.verify`'s code for item `j < batch_sz`, the items read
through the arrays at entry. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg.results
    (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (hv : VerifyCallSpec) (hx : X8CallSpec batch Gb) (a : Arrays) (n : BitVec 64) (it : Nat → Item)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals ((fd_ed25519_verify_batch_multi_msg batch).globals ++ Gb))
    (hB : BatchOk s.mem a it n.toNat) :
    ∃ s',
      (fd_ed25519_verify_batch_multi_msg batch).call
          (fd_ed25519_verify_batch_multi_msg.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n))
          s =
        .value (.nil, s') ∧
      ∀ j < n.toNat,
        s'.mem.readAt (a.results.add (BitVec.ofNat 64 (j * 4))) 32 =
          _root_.Ed25519.Firedancer.verify
            (bytesLE (s.mem.readAt (it j).msg (8 * (it j).msgSz.toNat)))
            (s.mem.readAt (it j).sig 256) (s.mem.readAt ((it j).sig.add 32#64) 256)
            (s.mem.readAt (it j).pk 256) := by
  obtain ⟨nbv, hv⟩ := hv
  obtain ⟨nbx, hx⟩ := hx
  suffices h :
      ((LIFT).call
          (fd_ed25519_verify_batch_multi_msg.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n)) s >>=
        fun p =>
          PoisonOr.value (∀ j < n.toNat, p.2.mem.readAt (a.result j) 32 = (it j).code s.mem)) =
        .value True by
    revert h
    cases (LIFT).call
        (fd_ed25519_verify_batch_multi_msg.args (.value a.msgs) (.value a.msgSzs) (.value a.sigs)
          (.value a.pks) (.value a.shas) (.value a.results) (.value n)) s with
    | poison => intro h; cases h
    | value p =>
      obtain ⟨r, s'⟩ := p
      intro h
      cases r
      injection h with h
      injection h with h
      exact ⟨s', rfl, fun j hj => (of_eq_true h) j hj⟩
  func_init
  have hB₀ : BatchOk S₀.mem a it n.toNat := hS ▸ hB
  have hgroups (g : Vals [] × GlobalState → PoisonOr Prop) (K : PoisonOr Prop) :=
    groups batch Gb nbv hv nbx hx hB₀ g K n.toNat 0
  rw [Arrays.drop_zero] at hgroups
  block_init
  iterate 5 step_pure
  finish_block
  · -- batch_sz == 0: nothing stored
    subst hbr
    block_init
    rw [BasicBlock.runBodyFrom_done]
    simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]
    exact congrArg _ (eq_true fun j hj => absurd hj (Nat.not_lt_zero j))
  · have hn : 0 < n.toNat :=
      Nat.pos_of_ne_zero fun h => hbr (BitVec.eq_of_toNat_eq (by simpa using h))
    have hI₀ : Inv S₀.mem S.mem a it n.toNat 0 := by rw [hS]; exact Inv.start hB₀
    step_loop using hgroups _ _ S
    intro _ hI
    block_init
    rw [BasicBlock.runBodyFrom_done (pos := 0) (Nat.le_of_eq rfl)]
    simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]
    exact congrArg _ (eq_true fun j hj => by
      rw [readAt_eraseFrom_of_lt (hwf₀.id_lt_of_inBounds (hB₀.room j hj).inBounds), hI.done j hj])

end Proof

/-! ## `fd_ed25519_verify_batch_multi_msg_cached` -/

section ProofCached

open _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg_cached (Γ args)

attribute [local mlir_transport] Room.x8Mem MemoryState.Globals.x8Mem GlobalState.WF.x8Mem_mk

namespace fd_ed25519_verify_batch_multi_msg_cached

/-- `^bb2`'s registers at item `j` of `n` (the tail loop). -/
abbrev TailEnv (E : ⟪Γ⟫) (a : Arrays) (n j : Nat) : Prop :=
  E ⊨ [%3 := 1#64, %5 := a.msgs, %6 := a.msgSzs, %7 := BitVec.ofNat 64 n, %8 := a.results,
    %9 := a.shas, %10 := a.pks, %11 := a.sigs, %13 := BitVec.ofNat 64 j]

/-- The blocks `fd_ed25519_verify_cached` on item `it` keeps: all but the hash object's, the
cache's and new ones. -/
abbrev Kept (it : Item) (cache : Pointer) (S : GlobalState) (b : BlockId) : Prop :=
  b ≠ it.sha.id ∧ b ≠ cache.id ∧ b.id < S.alloc.nextFreeBlock

/-- One trip through `^bb2`: `results[j] = fd_ed25519_verify_cached( msgs[j], …, cache )`, `j++`;
back while `j < n`. -/
theorem tail_trip (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals []))
    (verifyCached : VerifyCached) (G : List Global) (cache : Pointer)
    (hvc : VerifyCachedCallSpec verifyCached G cache) (A₀ : Arrays) (n₀ : BitVec 64) (a : Arrays)
    (n j : Nat) (it : Item) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs : E.args = ARGS) (hR : TailEnv E a n j) (hj : j < n) (hlen : 8 * n < 2 ^ 63)
    (hoff1 : a.msgs.offset.toNat + 8 * n < 2 ^ 64) (hoff2 : a.msgSzs.offset.toNat + 8 * n < 2 ^ 64)
    (hoff3 : a.sigs.offset.toNat + 8 * n < 2 ^ 64) (hoff4 : a.pks.offset.toNat + 8 * n < 2 ^ 64)
    (hoff5 : a.shas.offset.toNat + 8 * n < 2 ^ 64) (hoff6 : a.results.offset.toNat + 4 * n < 2 ^ 64)
    (hwf : S.WF) (hg : S.mem.Globals G) (hholds : a.Holds S.mem j it) (hok : it.Ok S.mem)
    (hroom : Room S.mem (a.result j) 32) (hmsg : it.msg.id ≠ it.sha.id)
    (hsig : it.sig.id ≠ it.sha.id) (hpk : it.pk.id ≠ it.sha.id) (hmc : it.msg.id ≠ cache.id)
    (hsc : it.sig.id ≠ cache.id) (hpc : it.pk.id ≠ cache.id) (hshc : it.sha.id ≠ cache.id)
    (hrs : a.results.id ≠ it.sha.id) (hrc : a.results.id ≠ cache.id)
    (hback :
      ∀ (E' : ⟪Γ⟫) (s' : GlobalState),
        E'.args = ARGS → TailEnv E' a n (j + 1) → s'.WF → S.mem.SameOn s'.mem (Kept it cache S) →
        j + 1 < n →
        ((LIFTC).runFrom E' 2
            { s' with mem := s'.mem.storeAt (a.result j) (it.verifySpec S.mem).ret } >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (s' : GlobalState), s'.WF → S.mem.SameOn s'.mem (Kept it cache S) →
        j + 1 = n →
        ((LIFTC).runFrom E' 4
            { s' with mem := s'.mem.storeAt (a.result j) (it.verifySpec S.mem).ret } >>= g) = K) :
    ((LIFTC).runFrom E 2 S >>= g) = K := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩ := hholds
  obtain ⟨o1, o2, o3, o4, o5, o6, o7, o8, o9⟩ := hok
  have hj64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hj1 : (BitVec.ofNat 64 j).uaddOverflow 1#64 = false := by
    simp [BitVec.uaddOverflow]; omega
  block_init
  -- results[j] = fd_ed25519_verify_cached( msgs[j], msg_szs[j], sigs[j], public_keys[j], shas[j],
  -- cache )
  step_pure [hj64]
  step_load consuming h2
  step_pure [hj64]
  step_load consuming h4
  step_pure [hj64]
  step_load consuming h6
  step_pure [hj64]
  step_load consuming h8
  step_pure [hj64]
  step_load consuming h10
  -- its state: a witness of the interface, kept about the state before the call
  obtain ⟨s', hcall, hwf', hsame⟩ :=
    hvc it.msg it.msgSz it.sig it.pk it.sha S hwf hg o1 o2 o3 o4 o5 o6 o7 o8 o9 hmsg hsig hpk hmc
      hsc hpc hshc
  have hroom' : Room s'.mem (a.result j) 32 :=
    hsame.room ⟨hrs, hrc, hwf.id_lt_of_inBounds hroom.inBounds⟩ hroom
  rw [hS] at hsame
  step_call using hcall consuming hg hwf h1 h3 h5 h7 h9 o1 o4 o6 o8 o9 hroom
  step_pure [hj64]
  step_store
  -- j++, j < n
  step_pure [hj1]
  step_pure
  finish_block
  · step_loop using hexit
    exact (ofNat_add_one_eq_iff hj (by omega)).1 hbr
  · step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · have := mt (ofNat_add_one_eq_iff hj (by omega)).2 hbr
      omega

/-- The tail loop from item `j` of the `n` items from item `b`: their codes at `results[b …]`. -/
theorem tail (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (verifyCached : VerifyCached) (G : List Global) (cache : Pointer)
    (hvc : VerifyCachedCallSpec verifyCached G cache) (A₀ : Arrays) (n₀ : BitVec 64)
    {m₀ : MemoryState} {a : Arrays} {it : Nat → Item} {N : Nat} (hB : BatchOk m₀ a it N)
    (hcache : ¬a.Keep it N 0 cache.id ∧ cache.id ≠ a.results.id) (b n : Nat) (hbn : b + n = N)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ r j (S : GlobalState) (E : ⟪Γ⟫), j + r + 1 = n → E.args = ARGS →
      TailEnv E (a.drop b) n j → S.WF → S.mem.Globals G → S.mem.Globals ((LIFTC).globals ++ Gb) →
      Inv m₀ S.mem a it N (b + j) →
      (∀ (E' : ⟪Γ⟫) (S' : GlobalState), S'.WF → S'.mem.Globals G →
        S'.mem.Globals ((LIFTC).globals ++ Gb) → Inv m₀ S'.mem a it N N →
        ((LIFTC).runFrom E' 4 S' >>= g) = K) →
      ((LIFTC).runFrom E 2 S >>= g) = K := by
  have hlen := hB.len
  obtain ⟨hoff1, hoff2, hoff3, hoff4, hoff5, hoff6⟩ := hB.drop_off (b := b) (by omega)
  rw [show N - b = n by omega] at hoff1 hoff2 hoff3 hoff4 hoff5 hoff6
  have hkeep {k : Nat} (hk : k < N) : a.Keep it N 0 (it k).msg.id ∧ a.Keep it N 0 (it k).sig.id ∧
      a.Keep it N 0 (it k).pk.id ∧ a.Keep it N 0 (it k).sha.id :=
    ⟨.inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inl rfl⟩))))),
      .inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inl rfl)⟩))))),
      .inl (.inr (.inr (.inr (.inr (.inr ⟨k, hk, .inr (.inr rfl)⟩))))),
      .inr ⟨k, Nat.zero_le _, hk, rfl⟩⟩
  have hne {x : BlockId} (hx : a.Keep it N 0 x) : x ≠ cache.id := fun h => hcache.1 (h ▸ hx)
  -- the trip's premises, from the invariant at item `b + j`
  have trip (j : Nat) (S : GlobalState) (E : ⟪Γ⟫) (hj : j < n) (hArgs : E.args = ARGS)
      (hR : TailEnv E (a.drop b) n j) (hwf : S.WF) (hg : S.mem.Globals G)
      (hI : Inv m₀ S.mem a it N (b + j)) :=
    tail_trip batch verifyCached G cache hvc A₀ n₀ (a.drop b) n j (it (b + j)) S E g K hArgs hR hj
      (by omega) hoff1 hoff2 hoff3 hoff4 hoff5 hoff6 hwf hg (hI.holds hB (by omega))
      (hI.ok hB le_rfl (by omega)) (by rw [Arrays.drop_result]; exact hI.room _ le_rfl (by omega))
      (hB.msg_ne_sha (by omega)) (hB.sig_ne_sha (by omega)) (hB.pk_ne_sha (by omega))
      (hne (hkeep (by omega)).1) (hne (hkeep (by omega)).2.1) (hne (hkeep (by omega)).2.2.1)
      (hne (hkeep (by omega)).2.2.2) (hB.sep.2.1 (b + j) (by omega)).2.symm hcache.2.symm
  intro r
  induction r with
  | zero =>
    intro j S E hj hArgs hR hwf hg hgf hI hK
    refine trip j S E (by omega) hArgs hR hwf hg hI (fun _ _ _ _ _ _ h => by omega) ?_
    intro E' s' hwf' hsame _
    have hI' := hI.verifyCached hB (c := b + j) (by omega) hcache rfl hwf hsame
    rw [show b + j + 1 = N by omega] at hI'
    exact hK E' _ (GlobalState.WF.storeAt (s := s') hwf')
      ((MemoryState.StoresOff.store (K := fun _ => False) (.refl _) (fun h => h) _).globals
        (hsame.globals hg))
      ((MemoryState.StoresOff.store (K := fun _ => False) (.refl _) (fun h => h) _).globals
        (hsame.globals hgf))
      (by rw [Arrays.drop_result]; exact hI')
  | succ r ih =>
    intro j S E hj hArgs hR hwf hg hgf hI hK
    refine trip j S E (by omega) hArgs hR hwf hg hI ?_ (fun _ _ _ _ h => by omega)
    intro E' s' hArgs' hR' hwf' hsame _
    have hI' := hI.verifyCached hB (c := b + j) (by omega) hcache rfl hwf hsame
    exact ih (j + 1) _ E' (by omega) hArgs' hR' (GlobalState.WF.storeAt (s := s') hwf')
      ((MemoryState.StoresOff.store (K := fun _ => False) (.refl _) (fun h => h) _).globals
        (hsame.globals hg))
      ((MemoryState.StoresOff.store (K := fun _ => False) (.refl _) (fun h => h) _).globals
        (hsame.globals hgf))
      (by rw [Arrays.drop_result]; exact hI') hK

/-- `^bb1`'s registers at `r` items left (the group loop). -/
abbrev GroupEnv (E : ⟪Γ⟫) (a : Arrays) (r : Nat) : Prop :=
  E ⊨ [%0 := 0#64, %1 := 4#64, %2 := 8#64, %3 := 1#64, %5 := a.msgs, %6 := a.msgSzs,
    %7 := BitVec.ofNat 64 r, %8 := a.results, %9 := a.shas, %10 := a.pks, %11 := a.sigs]

/-- One trip through `^bb1`: with `r < 4` items left into the tail loop; else `verify_x8` on
`cnt = min(r, 8)` items, the arrays advanced, and back while items are left. -/
theorem group_trip (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (verifyCached : VerifyCached) (cache : Pointer) (A₀ : Arrays) (n₀ : BitVec 64) (nb)
    (hx : X8CallEq batch Gb nb) (a : Arrays) (it : Nat → Item) (r : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = ARGS) (hR : GroupEnv E a r) (hlen : 8 * r < 2 ^ 63)
    (hoff1 : a.msgs.offset.toNat + 8 * r < 2 ^ 64)
    (hoff2 : a.msgSzs.offset.toNat + 8 * r < 2 ^ 64) (hoff3 : a.sigs.offset.toNat + 8 * r < 2 ^ 64)
    (hoff4 : a.pks.offset.toNat + 8 * r < 2 ^ 64) (hoff5 : a.shas.offset.toNat + 8 * r < 2 ^ 64)
    (hoff6 : a.results.offset.toNat + 4 * r < 2 ^ 64) (hwf : S.WF)
    (hg : S.mem.Globals ((LIFTC).globals ++ Gb)) (hB : BatchOk S.mem a it (min r 8))
    (htail : ∀ E' : ⟪Γ⟫, E'.args = ARGS → TailEnv E' a r 0 → r < 4 →
      ((LIFTC).runFrom E' 2 S >>= g) = K)
    (hback : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = ARGS →
      GroupEnv E' (a.drop (min r 8)) (r - min r 8) → S' = x8State nb a it (min r 8) S → 8 < r →
      ((LIFTC).runFrom E' 1 S' >>= g) = K)
    (hexit : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), S' = x8State nb a it (min r 8) S → 4 ≤ r → r ≤ 8 →
      ((LIFTC).runFrom E' 4 S' >>= g) = K) :
    ((LIFTC).runFrom E 1 S >>= g) = K := by
  block_init
  -- if( batch_sz<LANE_MIN_CACHED ): the tail
  step_pure
  finish_block
  · exact htail _ hArgs (by env_reads) ((ofNat_ult_iff (by omega) (by decide)).1 hbr)
  have hr4 : 4 ≤ r := Nat.le_of_not_lt (mt (ofNat_ult_iff (by omega) (by decide)).2 hbr)
  block_init
  -- cnt = fd_ulong_min( batch_sz, 8UL ); verify_x8( …, cnt )
  step_pure with cnt
  have hc : cnt.toNat = min r 8 := by
    rw [hcnt]; exact umin_eight_toNat (by omega)
  rw [← hc] at hB hback hexit
  have h3 : 3 ≤ cnt.toNat := by omega
  step_call using (hx a it) consuming hg hB h3
  -- msgs += cnt; …; batch_sz -= cnt
  iterate 6 step_pure
  step_pure
  step_pure
  have hsub : BitVec.ofNat 64 r - cnt = BitVec.ofNat 64 (r - cnt.toNat) :=
    ofNat_sub_eq (by omega) (by omega)
  finish_block
  · rw [hsub] at hbr
    have h8 : r ≤ 8 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    step_loop using hexit
    rfl
  · rw [hsub] at hbr
    have h8 : 8 < r := by
      have : r - cnt.toNat ≠ 0 := fun h => hbr (by rw [h])
      omega
    step_loop using hback
    · rw [hcnt] at hsub
      exact hsub
    · rfl

/-- The group loop from item `b` with `r > 0` items left: every code at `results[b …]`. -/
theorem groups (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (verifyCached : VerifyCached) (G : List Global) (cache : Pointer)
    (hvc : VerifyCachedCallSpec verifyCached G cache) (A₀ : Arrays) (n₀ : BitVec 64) (nbx)
    (hx : X8CallEq batch Gb nbx) {m₀ : MemoryState} {a : Arrays} {it : Nat → Item} {N : Nat}
    (hB : BatchOk m₀ a it N) (hcache : ¬a.Keep it N 0 cache.id ∧ cache.id ≠ a.results.id)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ r b (S : GlobalState) (E : ⟪Γ⟫), b + r = N → 0 < r → E.args = ARGS →
      GroupEnv E (a.drop b) r → S.WF → S.mem.Globals G → S.mem.Globals ((LIFTC).globals ++ Gb) →
      Inv m₀ S.mem a it N b →
      (∀ (E' : ⟪Γ⟫) (S' : GlobalState), S'.WF → S'.mem.Globals G →
        S'.mem.Globals ((LIFTC).globals ++ Gb) → Inv m₀ S'.mem a it N N →
        ((LIFTC).runFrom E' 4 S' >>= g) = K) →
      ((LIFTC).runFrom E 1 S >>= g) = K := by
  intro r
  induction r using Nat.strong_induction_on with
  | _ r ih =>
  intro b S E hbN hr hArgs hR hwf hG hg hI hK
  have hBo := hI.batchOk hB (by omega)
  rw [show N - b = r by omega] at hBo
  obtain ⟨o1, o2, o3, o4, o5, o6⟩ := hBo.off
  refine group_trip batch Gb verifyCached cache A₀ n₀ nbx hx (a.drop b) (fun j => it (b + j)) r S
    E g K hArgs hR hBo.len o1 o2 o3 o4 o5 o6 hwf hg (hBo.mono (by omega)) ?_ ?_ ?_
  · intro E' hArgs' hR' _
    exact tail batch Gb verifyCached G cache hvc A₀ n₀ hB hcache b r hbN g K (r - 1) 0 S E'
      (by omega) hArgs' hR' hwf hG hg hI hK
  · intro E' S' hArgs' hR' hS' _
    subst hS'
    exact ih (r - min r 8) (by omega) (b + min r 8) _ E' (by omega) (by omega) hArgs'
      (by rw [← Arrays.drop_drop]; exact hR') hwf.x8Mem_mk hG.x8Mem hg.x8Mem
      (hI.x8 hB (by omega) (by omega)) hK
  · intro E' S' hS' _ _
    subst hS'
    have hI' := hI.x8 hB (cnt := min r 8) (by omega) (by omega)
    rw [show b + min r 8 = N by omega] at hI'
    exact hK E' _ hwf.x8Mem_mk hG.x8Mem hg.x8Mem hI'

end fd_ed25519_verify_batch_multi_msg_cached

open fd_ed25519_verify_batch_multi_msg_cached

/-- `fd_ed25519_verify_batch_multi_msg_cached( msgs, msg_szs, sigs, public_keys, shas, results,
batch_sz, cache )`, given its callees' interfaces (`fd_ed25519_verify_cached` returning what
`fd_ed25519_verify` returns, on globals `G`), the C's preconditions (`BatchOk`) and a cache apart
from the inputs, the hash objects and `results`, stores what
`fd_ed25519_verify_batch_multi_msg.results` does. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_batch_multi_msg_cached.results
    (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (verifyCached : VerifyCached) (G : List Global) (cache : Pointer)
    (hvc : VerifyCachedCallSpec verifyCached G cache) (hx : X8CallSpec batch Gb) (a : Arrays)
    (n : BitVec 64) (it : Nat → Item) (s : GlobalState) (hwf : s.WF) (hG : s.mem.Globals G)
    (hg :
      s.mem.Globals ((fd_ed25519_verify_batch_multi_msg_cached batch verifyCached).globals ++ Gb))
    (hB : BatchOk s.mem a it n.toNat)
    (hcache : ¬a.ReadOnly it n.toNat cache.id ∧ (∀ j < n.toNat, cache.id ≠ (it j).sha.id) ∧
      cache.id ≠ a.results.id) :
    ∃ s',
      (fd_ed25519_verify_batch_multi_msg_cached batch verifyCached).call
          (fd_ed25519_verify_batch_multi_msg_cached.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n)
            (.value cache))
          s =
        .value (.nil, s') ∧
      ∀ j < n.toNat,
        s'.mem.readAt (a.results.add (BitVec.ofNat 64 (j * 4))) 32 =
          _root_.Ed25519.Firedancer.verify
            (bytesLE (s.mem.readAt (it j).msg (8 * (it j).msgSz.toNat)))
            (s.mem.readAt (it j).sig 256) (s.mem.readAt ((it j).sig.add 32#64) 256)
            (s.mem.readAt (it j).pk 256) := by
  obtain ⟨nbx, hx⟩ := hx
  have hcache' : ¬a.Keep it n.toNat 0 cache.id ∧ cache.id ≠ a.results.id := by
    refine ⟨?_, hcache.2.2⟩
    rintro (h | ⟨k, -, hk, h⟩)
    · exact hcache.1 h
    · exact hcache.2.1 k hk h
  suffices h :
      ((LIFTC).call
          (fd_ed25519_verify_batch_multi_msg_cached.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n)
            (.value cache)) s >>=
        fun p =>
          PoisonOr.value (∀ j < n.toNat, p.2.mem.readAt (a.result j) 32 = (it j).code s.mem)) =
        .value True by
    revert h
    cases (LIFTC).call
        (fd_ed25519_verify_batch_multi_msg_cached.args (.value a.msgs) (.value a.msgSzs)
          (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n)
          (.value cache)) s with
    | poison => intro h; cases h
    | value p =>
      obtain ⟨r, s'⟩ := p
      intro h
      cases r
      injection h with h
      injection h with h
      exact ⟨s', rfl, fun j hj => (of_eq_true h) j hj⟩
  func_init
  have hB₀ : BatchOk S₀.mem a it n.toNat := hS ▸ hB
  have hgroups (g : Vals [] × GlobalState → PoisonOr Prop) (K : PoisonOr Prop) :=
    groups batch Gb verifyCached G cache hvc a n nbx hx hB₀ hcache' g K n.toNat 0
  rw [Arrays.drop_zero] at hgroups
  block_init
  iterate 5 step_pure
  finish_block
  · -- batch_sz == 0: nothing stored
    subst hbr
    block_init
    rw [BasicBlock.runBodyFrom_done]
    simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]
    exact congrArg _ (eq_true fun j hj => absurd hj (Nat.not_lt_zero j))
  · have hn : 0 < n.toNat :=
      Nat.pos_of_ne_zero fun h => hbr (BitVec.eq_of_toNat_eq (by simpa using h))
    have hI₀ : Inv S₀.mem S.mem a it n.toNat 0 := by rw [hS]; exact Inv.start hB₀
    step_loop using hgroups _ _ S
    intro _ _ hI
    block_init
    rw [BasicBlock.runBodyFrom_done (pos := 0) (Nat.le_of_eq rfl)]
    simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]
    exact congrArg _ (eq_true fun j hj => by
      rw [readAt_eraseFrom_of_lt (hwf₀.id_lt_of_inBounds (hB₀.room j hj).inBounds), hI.done j hj])

end ProofCached

end MLIR.Firedancer.Lane

module

public import Sodium.Update.Defs
public import Sodium.Common.Counter
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `crypto_hash_sha512_update`, `inlen ≥ 128 - r`: the buffered block filled (`^bb2 … ^bb16`,
`^bb32`), on to `^bb33`. -/

namespace MLIR.Sodium.crypto_hash_sha512_update

set_option hygiene false in
/-- One byte, `buf[r + t] = in[t]`, at `hM : S.mem = mem … t`; `hS` then says `mem … (t + 1)`. -/
local macro "byte_copy " t:term : tactic =>
  `(tactic|
    ( have ht64 : $t < 18446744073709551616 := by omega
      obtain ⟨hf0, hr0, hs0⟩ :=
        src_chunk (w := w) (R := R) (k := $t) (j := $t) (c := 1) (D := M.readAt inp (8 * (128 - R)))
          hin hino hn hsep (by omega)
      obtain ⟨hd0, hg0⟩ :=
        dst_chunk (w := w) (R := R) (k := $t) (c := 1) (k' := $t) (D :=
          M.readAt inp (8 * (128 - R))) hMf (by omega)
      rw [← hM] at hf0 hr0 hd0
      step_pure [Nat.mod_eq_of_lt ht64, ht64, gep_value hs0]
      step_load consuming hf0 hr0
      step_pure [Nat.mod_eq_of_lt ht64, ht64, gep_value hg0, Pointer.add_add, ← BitVec.ofNat_add]
      step_store consuming hd0
      try clear hread_st_0
      try clear hfits_st_0
      first
      | rw [hM, store_step hMf (by omega) (show 8 = 8 * 1 from rfl) rfl] at hS
      | rw [store_step hMf (by omega) (show 8 = 8 * 1 from rfl) rfl] at hS
      clear hM ht64 hg0 hs0))

set_option hygiene false in
/-- Four bytes, `buf[r + t … r + t + 3] = in[t … t + 3]`, as `byte_copy`. -/
local macro "word_copy " t:term : tactic =>
  `(tactic|
    ( have ht64 : $t < 18446744073709551616 := by omega
      obtain ⟨hf0, hr0, hs0⟩ :=
        src_chunk (w := w) (R := R) (k := $t) (j := $t) (c := 4) (D := M.readAt inp (8 * (128 - R)))
          hin hino hn hsep (by omega)
      obtain ⟨hd0, hg0⟩ :=
        dst_chunk (w := w) (R := R) (k := $t) (c := 4) (k' := $t) (D :=
          M.readAt inp (8 * (128 - R))) hMf (by omega)
      rw [← hM] at hf0 hr0 hd0
      step_pure [Nat.mod_eq_of_lt ht64, ht64, gep_value hs0]
      step_load consuming hf0 hr0
      step_pure [Nat.mod_eq_of_lt ht64, ht64, gep_value hg0, Pointer.add_add, ← BitVec.ofNat_add]
      step_store consuming hd0
      try clear hread_st_0
      try clear hfits_st_0
      first
      |
        rw [hM,
          store_step hMf (by omega) (show 32 = 8 * 4 from rfl)
            (packLanes_ofFn_extractVecElem _)] at hS
      |
        rw [store_step hMf (by omega) (show 32 = 8 * 4 from rfl)
            (packLanes_ofFn_extractVecElem _)] at hS
      clear hM ht64 hg0 hs0))

set_option hygiene false in
/-- `^bb6 … ^bb8`: 32 bytes as two 16-byte vectors at `k` and `k' = k + 16`, at `hM : S.mem =
mem … k`; `hS` then says `mem … (k + 16 + 16)`. -/
local macro "copy32 " k:num k2:num : tactic =>
  `(tactic|
    ( obtain ⟨hf0, hr0, hs0⟩ :=
        src_chunk (w := w) (R := R) (k := $k) (j := $k) (c := 16) (D :=
          M.readAt inp (8 * (128 - R))) hin hino hn hsep (by omega)
      obtain ⟨hf1, hr1, hs1⟩ :=
        src_chunk (w := w) (R := R) (k := $k) (j := $k2) (c := 16) (D :=
          M.readAt inp (8 * (128 - R))) hin hino hn hsep (by omega)
      obtain ⟨hd0, hg0⟩ :=
        dst_chunk (w := w) (R := R) (k := $k) (c := 16) (k' := $k) (D :=
          M.readAt inp (8 * (128 - R))) hMf (by omega)
      obtain ⟨hd1, hg1⟩ :=
        dst_chunk (w := w) (R := R) (k := $k2) (c := 16) (k' := $k) (D :=
          M.readAt inp (8 * (128 - R))) hMf (by omega)
      rw [← hM] at hf0 hr0 hf1 hr1 hd0 hd1
      step_pure [gep_value hs0]
      step_pure [gep_value hs1]
      step_load consuming hf0 hr0
      step_load consuming hf1 hr1
      step_pure [gep_value hg0, Pointer.add_add, ofNat_add_toNat]
      step_pure [gep_value hg1, Pointer.add_add, ofNat_add_toNat]
      step_store consuming hd0
      step_store consuming hd1
      rw [store_step (k := $k) hMf (by omega) (show 128 = 8 * 16 from rfl)
          (packLanes_ofFn_extractVecElem _),
        store_step (k := $k + 16) hMf (by omega) (show 128 = 8 * 16 from rfl)
          (packLanes_ofFn_extractVecElem _)] at hS
      clear hM hs0 hs1 hg0 hg1))

set_option hygiene false in
/-- `j + o`, no overflow, as one number. -/
local macro "index_add " o:num : tactic =>
  `(tactic|
    step_pure [saddOverflow_ofNat64 (i := j) (k := $o) (by omega),
      uaddOverflow_ofNat64 (i := j) (k := $o) (by omega), ofNat_add_toNat])

namespace Fill

/-- `i + c` as one number. -/
theorem ofNat_add_toNat (i : Nat) (c : BitVec 64) :
    BitVec.ofNat 64 i + c = BitVec.ofNat 64 (i + c.toNat) := by
  rw [BitVec.ofNat_add, BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- `a - 125 <u 3`, the remainder test of `^bb16`. -/
theorem ult_m125 {a : Nat} (ha : a < 2 ^ 63) :
    (BitVec.ofNat 64 a + 18446744073709551491#64).ult 3#64 = decide (125 ≤ a ∧ a < 128) := by
  have h : BitVec.ofNat 64 a < 9223372036854775808#64 := by
    rw [BitVec.lt_def]; simp; omega
  by_cases h1 : 125 ≤ a ∧ a < 128
  · simp only [h1]
    have : 125#64 ≤ BitVec.ofNat 64 a := by
      rw [BitVec.le_def]; simp; omega
    have : BitVec.ofNat 64 a < 128#64 := by
      rw [BitVec.lt_def]; simp; omega
    bv_decide
  · simp only [h1, decide_false]
    have : BitVec.ofNat 64 a < 125#64 ∨ 128#64 ≤ BitVec.ofNat 64 a := by
      rw [BitVec.lt_def, BitVec.le_def]; simp; omega
    bv_decide

theorem sadd_m125 {a : Nat} (ha : a < 2 ^ 62) :
    (BitVec.ofNat 64 a).saddOverflow 18446744073709551491#64 = false := by
  have h : BitVec.ofNat 64 a < 4611686018427387904#64 := by
    rw [BitVec.lt_def]; simp; omega
  bv_decide

/-- `(-(count[1] >> 3)) & 3 = (128 - r) % 4`, the byte prologue's count. -/
theorem neg_and3 (c : BitVec 64) {R : Nat} (h : c.toNat / 8 % 128 = R) :
    -(c >>> 3) &&& 3#64 = BitVec.ofNat 64 ((128 - R) % 4) := by
  have hR : R < 128 := h ▸ Nat.mod_lt _ (by decide)
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (3#64).toNat = 2 ^ 2 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  simp only [BitVec.toNat_neg, BitVec.toNat_ushiftRight, BitVec.toNat_ofNat,
    Nat.shiftRight_eq_div_pow]
  have := c.isLt
  omega

theorem ssub_zero (c : BitVec 64) : (0#64).ssubOverflow (c >>> 3) = false := by bv_decide

/-- The low `k` bits as a number. -/
theorem and_low (x : BitVec 64) (k : Nat) (hk : k < 64) :
    (x &&& BitVec.ofNat 64 (2 ^ k - 1)).toNat = x.toNat % 2 ^ k := by
  rw [BitVec.toNat_and, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt
      (by
        have : 2 ^ k ≤ 2 ^ 63 := Nat.pow_le_pow_right (by decide) (by omega)
        omega),
    Nat.and_two_pow_sub_one_eq_mod]

/-- The masks `n & 252`, `n & 224`, `n & 28` of `n = 128 - r`. -/
theorem and252 {n : Nat} (hn : n < 256) :
    BitVec.ofNat 64 n &&& 252#64 = BitVec.ofNat 64 (n / 4 * 4) := by
  have h : BitVec.ofNat 64 n < 256#64 := by
    rw [BitVec.lt_def]; simp; omega
  have e : BitVec.ofNat 64 n &&& 252#64 = BitVec.ofNat 64 n - (BitVec.ofNat 64 n &&& 3#64) := by
    bv_decide
  have h3 := and_low (BitVec.ofNat 64 n) 2 (by decide)
  simp only [show 2 ^ 2 - 1 = 3 from rfl, BitVec.toNat_ofNat] at h3
  rw [e]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h3]; simp; omega),
    h3]
  simp
  omega

theorem and224 {n : Nat} (hn : n < 256) :
    BitVec.ofNat 64 n &&& 224#64 = BitVec.ofNat 64 (n / 32 * 32) := by
  have h : BitVec.ofNat 64 n < 256#64 := by
    rw [BitVec.lt_def]; simp; omega
  have e : BitVec.ofNat 64 n &&& 224#64 = BitVec.ofNat 64 n - (BitVec.ofNat 64 n &&& 31#64) := by
    bv_decide
  have h3 := and_low (BitVec.ofNat 64 n) 5 (by decide)
  simp only [show 2 ^ 5 - 1 = 31 from rfl, BitVec.toNat_ofNat] at h3
  rw [e]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h3]; simp; omega),
    h3]
  simp
  omega

theorem and28 (n : Nat) : BitVec.ofNat 64 n &&& 28#64 = BitVec.ofNat 64 (n % 32 / 4 * 4) := by
  have e :
    BitVec.ofNat 64 n &&& 28#64 = (BitVec.ofNat 64 n &&& 31#64) - (BitVec.ofNat 64 n &&& 3#64) := by
    bv_decide
  have hle : BitVec.ofNat 64 n &&& 3#64 ≤ BitVec.ofNat 64 n &&& 31#64 := by bv_decide
  have h3 := and_low (BitVec.ofNat 64 n) 2 (by decide)
  have h31 := and_low (BitVec.ofNat 64 n) 5 (by decide)
  simp only [show 2 ^ 2 - 1 = 3 from rfl, show 2 ^ 5 - 1 = 31 from rfl,
    BitVec.toNat_ofNat] at h3 h31
  rw [e]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le hle, h3, h31]
  simp
  omega

theorem Pointer.add_ofNat_zero (p : Pointer) : p.add (BitVec.ofNat 64 0) = p := by
  simp [Pointer.add]

/-- The struct with `D`'s first `k` bytes copied to `buf` at `R`. -/
abbrev mem (M : MemoryState) (st : Pointer) (w : HashState) (R : Nat) (D : BitVec n) (k : Nat) :
    MemoryState :=
  M.storeHashState st (w.fill (BitVec.ofNat 64 R) (D.extractLsb' 0 (8 * k)))

/-- No bytes copied yet. -/
theorem mem_zero {M : MemoryState} {st : Pointer} {w : HashState} {R : Nat} {D : BitVec n} :
    mem M st w R D 0 = M.storeHashState st w := by
  have hs {m : Nat} (b : BitVec m) (o : Nat) (y : BitVec (8 * 0)) :
    Memory.spliceBits b o y = b := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits]
    split <;>
      first
      | omega
      | rfl
  simp only [mem, HashState.fill, Firedancer.Ref.fd_sha512_append.copy, hs]

/-- The next `c` bytes of `D` stored after the first `k`. -/
theorem store_step {M : MemoryState} {st : Pointer} {w : HashState} {D : BitVec n} {R k c : Nat}
    (hMf : M.HashStateFit st) (h : R + k + c ≤ 128) {x : BitVec v} (hv : v = 8 * c)
    (hx : x = D.extractLsb' (8 * k) v) :
    (mem M st w R D k).storeAt (st.add (BitVec.ofNat 64 (80 + R + k))) x =
      mem M st w R D (k + c) := by
  subst hv hx
  have h1 : (BitVec.ofNat 64 (80 + R + k)).toNat = 80 + R + k := by
    simp; omega
  rw [mem, MemoryState.storeHashState_storeAt_buf hMf.1 (by omega) (by omega)]
  have e : BitVec.ofNat 64 (80 + R + k) - 80#64 = BitVec.ofNat 64 (R + k) := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, h1]; simp; omega)]
    simp; omega
  have := HashState.fill_fill_extract w D (a := R) (i := 0) (k := k) (c := c) h
  simp only [Nat.mul_zero, Nat.zero_add] at this
  rw [e, this]

/-- `store_step` for the first bytes. -/
theorem store_step0 {M : MemoryState} {st : Pointer} {w : HashState} {D : BitVec n} {R c : Nat}
    (hMf : M.HashStateFit st) (h : R + c ≤ 128) {x : BitVec v} (hv : v = 8 * c)
    (hx : x = D.extractLsb' 0 v) :
    (mem M st w R D 0).storeAt (st.add (BitVec.ofNat 64 (80 + R))) x = mem M st w R D c := by
  have := store_step (w := w) (k := 0) hMf (by omega) hv (by simpa using hx)
  simpa using this

/-- Bytes `j … j + c` of the `N` input bytes, through the struct's stores. -/
theorem src_chunk {M : MemoryState} {st inp : Pointer} {w : HashState} {R k N j c : Nat}
    {inlen : BitVec 64} (hin : Fits M inp (8 * N)) (hino : ¬inp.offset.uaddOverflow inlen)
    (hN : N ≤ inlen.toNat) (hsep : inp.id ≠ st.id) (hj : j + c ≤ N) {D : BitVec n} :
    Fits (mem M st w R D k) (inp.add (BitVec.ofNat 64 j)) (8 * c) ∧
      (mem M st w R D k).readAt (inp.add (BitVec.ofNat 64 j)) (8 * c) =
        (M.readAt inp (8 * N)).extractLsb' (8 * j) (8 * c) ∧
      ¬inp.offset.uaddOverflow (BitVec.ofNat 64 j) := by
  have := inlen.isLt
  have hov : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 j) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
      Nat.not_le] at hino ⊢
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hw : (BitVec.ofNat 64 j).toNat * 8 + 8 * c ≤ 8 * N := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨(Fits.add_of_le hov hw hin).storeHashState (by simpa using hsep), ?_, hov⟩
  rw [mem, MemoryState.readAt_storeHashState_of_id_ne (by simpa using hsep),
    MemoryState.readAt_add_of_readAt hin.inBounds hov hw rfl, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt (by omega), Nat.mul_comm j 8]

/-- `buf + r + k` for `r + k + c ≤ 128`: room for `c` bytes, and the `getelementptr` does not
wrap. -/
theorem dst_chunk {M : MemoryState} {st : Pointer} {w : HashState} {R k c k' : Nat} {D : BitVec n}
    (hMf : M.HashStateFit st) (h : R + k + c ≤ 128) :
    Room (mem M st w R D k') (st.add (BitVec.ofNat 64 (80 + R + k))) (8 * c) ∧
      ¬(st.add (BitVec.ofNat 64 (80 + R))).offset.uaddOverflow (BitVec.ofNat 64 k) := by
  have ho := Pointer.offset_lt_of_hashState hMf.1
  refine
    ⟨Room.storeHashState
        (Room.add_of_le
          (Pointer.not_uaddOverflow_of_hashState hMf.1
            (by
              simp; omega))
          (by
            simp; omega)
          hMf.2.1),
      ?_⟩
  simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
    decide_eq_true_eq, ge_iff_le, Nat.not_le]
  omega

/-- The registers live from `^bb32` on. -/
abbrev Regs32 (st tmp : Pointer) (R : Nat) (ast : BitVec 64) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1240 := ast, %1241 := tmp, %1256 := BitVec.ofNat 64 (128 - R), %1258 := st.add 80#64,
    %1259 := st.add (BitVec.ofNat 64 (80 + R))]

/-- What `^bb33` must give, as `fill_block`'s `hK` says. -/
abbrev Cont (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast : BitVec 64) (M : MemoryState)
    (w : HashState) (A : AllocState) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) : Prop :=
  ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
    E'.args = (args (.value st) (.value inp) (.value inlen)).get →
      ConstsBlocks E' →
      (E' ⊨ [%1240 := ast, %1241 := tmp, %1256 := BitVec.ofNat 64 (128 - R), %1258 :=
        st.add 80#64]) →
      S'.WF →
      S'.alloc = A →
      S'.mem = M.storeHashState st (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * (128 - R)))) →
      (crypto_hash_sha512_update.runFrom E' 33 S' >>= g) = K

/-- `^bb32`, four bytes at a time from `j`, `q + 1` rounds left. -/
theorem loop32 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hRlt : R < 128)
    (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * (128 - R)))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id)
    (hK : Cont st inp tmp inlen R ast M w A g K) :
    ∀ q j (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        ConstsBlocks E →
        Regs32 st tmp R ast E →
        E ⊨ [%1389 := BitVec.ofNat 64 j] →
        j + 4 * (q + 1) = 128 - R →
        S.WF →
        S.alloc = A →
        S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) j →
        (crypto_hash_sha512_update.runFrom E 32 S >>= g) = K := by
  intro q
  induction q with
  | zero =>
    intro j S E hArgs hC hR hj hq hwf hA hM
    block_init
    byte_copy j
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 1) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 1
    byte_copy (j + 1)
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 2) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 2
    byte_copy (j + 2)
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 3) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 3
    byte_copy (j + 3)
    index_add 4
    step_pure
    finish_block
    · step_loop using hK
      simp only [mem, BitVec.extractLsb'_eq_self]
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).2 (by omega)) hbr
  | succ q ih =>
    intro j S E hArgs hC hR hj hq hwf hA hM
    block_init
    byte_copy j
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 1) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 1
    byte_copy (j + 1)
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 2) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 2
    byte_copy (j + 2)
    have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) (j + 3) :=
      (congrArg GlobalState.mem hS).trans rfl
    index_add 3
    byte_copy (j + 3)
    index_add 4
    step_pure
    finish_block
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).1 hbr) (by omega)
    · step_loop using ih (j + 4)

/-- The constants live from `^bb14` on. -/
abbrev Consts14 (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1211 := 64#64, %1212 := 3#64, %1213 := 127#64, %1216 := 80#64, %1217 :=
    124#64, %1218 := 79#64, %1220 := 96#64, %1223 := 16#64, %1224 := 32#64, %1225 := 48#64, %1226 :=
    112#64, %1228 := 4#64, %1229 := 1#64, %1230 := 18446744073709551491#64, %1231 := 2#64, %1232 :=
    18446744073709551488#64, %1233 := 15#64, %1234 := 12#64, %1235 := 18446744073709551612#64,
    %1236 := 704#64, %1238 := 0#32]

/-- `^bb16`: the bytes from `i0` copied to `j`, `128 - r - j` a multiple of 4; done, or on to
`^bb32`. -/
theorem block16 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hRlt : R < 128)
    (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * (128 - R)))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id)
    (hK : Cont st inp tmp inlen R ast M w A g K) (i0 j : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : Consts14 E)
    (hR : Regs32 st tmp R ast E)
    (hE : E ⊨ [%1306 := BitVec.ofNat 64 (i0 + R), %1317 := BitVec.ofNat 64 j]) (hi0 : i0 + R < 128)
    (hij : i0 ≤ j) (hj4 : j - i0 < 4) (hj : j ≤ 128 - R) (hjr : (128 - R - j) % 4 = 0) (hwf : S.WF)
    (hA : S.alloc = A) (hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) j) :
    (crypto_hash_sha512_update.runFrom E 16 S >>= g) = K := by
  block_init
  step_pure [sadd_m125 (a := i0 + R) (by omega)]
  step_pure [ult_m125 (a := i0 + R) (by omega)]
  finish_block
  · have hjR : j = 128 - R := by
      simp at hbr; omega
    subst hjR
    step_loop using hK
    simp only [mem, BitVec.extractLsb'_eq_self]
  · have : ¬(125 ≤ i0 + R ∧ i0 + R < 128) := by simpa using hbr
    step_loop using
      loop32 st inp tmp inlen R ast M w A g K hRlt hn hMf hin hino hsep hK ((128 - R - j) / 4 - 1) j

/-- `^bb15`, the byte prologue at `j = i0 + c`, `q + 1` bytes left of `p = (128 - r - i0) % 4`. -/
theorem loop15 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hRlt : R < 128)
    (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * (128 - R)))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id)
    (hK : Cont st inp tmp inlen R ast M w A g K) (i0 p : Nat) (hi0 : i0 + R < 128)
    (hp : p = (128 - R - i0) % 4) :
    ∀ q j c (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        Consts14 E →
        Regs32 st tmp R ast E →
        (E ⊨ [%1306 := BitVec.ofNat 64 (i0 + R), %1307 := BitVec.ofNat 64 p, %1309 :=
          BitVec.ofNat 64 j, %1310 := BitVec.ofNat 64 c]) →
        i0 + c = j →
        c + q + 1 = p →
        S.WF →
        S.alloc = A →
        S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) j →
        (crypto_hash_sha512_update.runFrom E 15 S >>= g) = K := by
  intro q
  induction q with
  | zero =>
    intro j c S E hArgs hC hR hE hj hc hwf hA hM
    block_init
    byte_copy j
    step_pure [saddOverflow_ofNat64 (i := j) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := j) (k := 1) (by omega), ofNat_add_toNat]
    step_pure [ofNat_add_toNat]
    step_pure
    finish_block
    · step_loop using
        block16 st inp tmp inlen R ast M w A g K hRlt hn hMf hin hino hsep hK i0 (j + 1)
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).2 (by omega)) hbr
  | succ q ih =>
    intro j c S E hArgs hC hR hE hj hc hwf hA hM
    block_init
    byte_copy j
    step_pure [saddOverflow_ofNat64 (i := j) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := j) (k := 1) (by omega), ofNat_add_toNat]
    step_pure [ofNat_add_toNat]
    step_pure
    finish_block
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).1 hbr) (by omega)
    · step_loop using ih (j + 1) (c + 1)

/-- `^bb14`: the bytes from `i0`, a multiple of 4, by the byte prologue and `^bb16`. -/
theorem block14 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast c1 : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hc1 : c1.toNat / 8 % 128 = R)
    (hRlt : R < 128) (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * (128 - R))) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (hK : Cont st inp tmp inlen R ast M w A g K) (i0 : Nat)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : Consts14 E)
    (hR : Regs32 st tmp R ast E)
    (hE : E ⊨ [%1246 := c1 >>> 3, %1247 := BitVec.ofNat 64 R, %1304 := BitVec.ofNat 64 i0])
    (hi0 : i0 + R < 128) (hi4 : i0 % 4 = 0) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) i0) :
    (crypto_hash_sha512_update.runFrom E 14 S >>= g) = K := by
  block_init
  step_pure [ssub_zero]
  step_pure [saddOverflow_ofNat64 (i := i0) (k := R) (by omega),
    uaddOverflow_ofNat64 (i := i0) (k := R) (by omega), ofNat_add_toNat,
    Nat.mod_eq_of_lt (show R < 18446744073709551616 by omega)]
  step_pure [neg_and3 c1 hc1]
  step_pure
  finish_block
  · have h0 : (128 - R) % 4 = 0 := by
      have := (ofNat64_eq_iff (b := 0) (by omega) (by decide)).1 hbr
      omega
    step_loop using block16 st inp tmp inlen R ast M w A g K hRlt hn hMf hin hino hsep hK i0 i0
  · have h0 : (128 - R) % 4 ≠ 0 := fun h =>
      hbr ((ofNat64_eq_iff (b := 0) (by omega) (by decide)).2 h)
    step_loop using
      loop15 st inp tmp inlen R ast M w A g K hRlt hn hMf hin hino hsep hK i0 ((128 - R) % 4) hi0
        (by omega) ((128 - R) % 4 - 1) i0 0

/-- `^bb12`, four bytes at a time from `j` to `(128 - r) / 4 * 4`, `q + 1` words left; then
`^bb13`. -/
theorem loop12 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast c1 : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hc1 : c1.toNat / 8 % 128 = R)
    (hRlt : R < 128) (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * (128 - R))) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (hK : Cont st inp tmp inlen R ast M w A g K) :
    ∀ q j (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        Consts14 E →
        Regs32 st tmp R ast E →
        (E ⊨ [%1246 := c1 >>> 3, %1247 := BitVec.ofNat 64 R, %1296 :=
          BitVec.ofNat 64 ((128 - R) / 4 * 4), %1297 := BitVec.ofNat 64 j]) →
        j + 4 * (q + 1) = (128 - R) / 4 * 4 →
        S.WF →
        S.alloc = A →
        S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) j →
        (crypto_hash_sha512_update.runFrom E 12 S >>= g) = K := by
  intro q
  induction q with
  | zero =>
    intro j S E hArgs hC hR hE hq hwf hA hM
    block_init
    word_copy j
    step_pure [uaddOverflow_ofNat64 (i := j) (k := 4) (by omega), ofNat_add_toNat]
    step_pure
    finish_block
    · block_init
      step_pure
      finish_block
      · have he : (128 - R) / 4 * 4 = 128 - R := ((ofNat64_eq_iff (by omega) (by omega)).1 hbr).symm
        step_loop using hK
        simp only [mem, BitVec.extractLsb'_eq_self]
      · have hne : (128 - R) / 4 * 4 ≠ 128 - R := fun h =>
          hbr ((ofNat64_eq_iff (by omega) (by omega)).2 h.symm)
        step_loop using
          block14 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK (j + 4)
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).2 (by omega)) hbr
  | succ q ih =>
    intro j S E hArgs hC hR hE hq hwf hA hM
    block_init
    word_copy j
    step_pure [uaddOverflow_ofNat64 (i := j) (k := 4) (by omega), ofNat_add_toNat]
    step_pure
    finish_block
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).1 hbr) (by omega)
    · step_loop using ih (j + 4)

/-- The constants live from `^bb11` on. -/
abbrev Consts11 (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1211 := 64#64, %1212 := 3#64, %1213 := 127#64, %1216 := 80#64, %1217 :=
    124#64, %1218 := 79#64, %1220 := 96#64, %1223 := 16#64, %1224 := 32#64, %1225 := 48#64, %1226 :=
    112#64, %1227 := 252#64, %1228 := 4#64, %1229 := 1#64, %1230 := 18446744073709551491#64,
    %1231 := 2#64, %1232 := 18446744073709551488#64, %1233 := 15#64, %1234 := 12#64, %1235 :=
    18446744073709551612#64, %1236 := 704#64, %1238 := 0#32]

/-- `^bb11`: the 4-byte loop from `i0`, a multiple of 4 short of `(128 - r) / 4 * 4`. -/
theorem block11 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast c1 : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hc1 : c1.toNat / 8 % 128 = R)
    (hRlt : R < 128) (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * (128 - R))) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (hK : Cont st inp tmp inlen R ast M w A g K) (i0 : Nat)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : Consts11 E)
    (hR : Regs32 st tmp R ast E)
    (hE : E ⊨ [%1246 := c1 >>> 3, %1247 := BitVec.ofNat 64 R, %1295 := BitVec.ofNat 64 i0])
    (hi4 : i0 % 4 = 0) (hi0 : i0 + 4 ≤ (128 - R) / 4 * 4) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) i0) :
    (crypto_hash_sha512_update.runFrom E 11 S >>= g) = K := by
  block_init
  step_pure [and252 (show 128 - R < 256 by omega)]
  finish_block
  step_loop using
    loop12 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
      (((128 - R) / 4 * 4 - i0) / 4 - 1) i0

/-- `^bb9`: the 32-byte chunks copied, `k = (128 - r) / 32 * 32`; done, or the 4-byte loop, or
the bytes. -/
theorem block9 (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (ast c1 : BitVec 64)
    (M : MemoryState) (w : HashState) (A : AllocState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hc1 : c1.toNat / 8 % 128 = R)
    (hRlt : R < 128) (hn : 128 - R ≤ inlen.toNat) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * (128 - R))) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (hK : Cont st inp tmp inlen R ast M w A g K) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : Consts11 E)
    (hR : Regs32 st tmp R ast E)
    (hE :
      E ⊨ [%1246 := c1 >>> 3, %1247 := BitVec.ofNat 64 R, %1266 :=
        BitVec.ofNat 64 ((128 - R) % 32 / 4 * 4), %1267 := BitVec.ofNat 64 ((128 - R) / 32 * 32)])
    (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) ((128 - R) / 32 * 32)) :
    (crypto_hash_sha512_update.runFrom E 9 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  · have he : (128 - R) / 32 * 32 = 128 - R := ((ofNat64_eq_iff (by omega) (by omega)).1 hbr).symm
    step_loop using hK
    simp only [mem, BitVec.extractLsb'_eq_self]
  · have hne : (128 - R) / 32 * 32 ≠ 128 - R := fun h =>
      hbr ((ofNat64_eq_iff (by omega) (by omega)).2 h.symm)
    block_init
    step_pure
    finish_block
    · have h0 : (128 - R) % 32 / 4 * 4 = 0 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
      step_loop using
        block14 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
          ((128 - R) / 32 * 32)
    · have h0 : (128 - R) % 32 / 4 * 4 ≠ 0 := fun h =>
        hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
      step_loop using
        block11 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
          ((128 - R) / 32 * 32)

end Fill

open Fill in
/-- `for (i = 0; i < 128 - r; i++) { state->buf[r + i] = in[i]; }`, every vectorized path and
either outcome of the alias check. -/
public theorem fill_block (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat)
    (ain ast c1 : BitVec 64) (M : MemoryState) (w : HashState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : ConstsFill E)
    (hR :
      E ⊨ [%1239 := ain, %1240 := ast, %1241 := tmp, %1246 := c1 >>> 3, %1247 := BitVec.ofNat 64 R,
        %1256 := BitVec.ofNat 64 (128 - R), %1258 := st.add 80#64, %1259 :=
        st.add (BitVec.ofNat 64 (80 + R))])
    (hc1 : c1.toNat / 8 % 128 = R) (hRlt : R < 128) (hn : 128 - R ≤ inlen.toNat) (hwf : S.WF)
    (hM : S.mem = M.storeHashState st w) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * (128 - R))) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value st) (.value inp) (.value inlen)).get →
          ConstsBlocks E' →
          (E' ⊨ [%1240 := ast, %1241 := tmp, %1256 := BitVec.ofNat 64 (128 - R), %1258 :=
            st.add 80#64]) →
          S'.WF →
          S'.alloc = S.alloc →
          S'.mem = M.storeHashState st (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * (128 - R)))) →
          (crypto_hash_sha512_update.runFrom E' 33 S' >>= g) = K) :
    (crypto_hash_sha512_update.runFrom E 2 S >>= g) = K := by
  have hM0 : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) 0 := by rw [hM, mem_zero]
  clear hM
  generalize hA : S.alloc = A at hK
  block_init
  step_pure
  finish_block
  · -- r > 124: bytewise
    have : 124 < R := by simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 2 ^ 64 by omega)] using hbr
    step_loop using block14 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK 0
  · have hR124 : R ≤ 124 := by
      simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 2 ^ 64 by omega)] using hbr
    block_init
    iterate 4 step_pure
    finish_block
    · -- the ranges may overlap: bytewise
      step_loop using block14 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK 0
    · block_init
      step_pure
      finish_block
      · -- r > 96: no 32-byte chunk
        have : 96 < R := by
          simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 2 ^ 64 by omega)] using hbr
        step_loop using
          block11 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK 0
      · have : R ≤ 96 := by
          simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 2 ^ 64 by omega)] using hbr
        block_init
        step_pure [and28]
        step_pure [and224 (show 128 - R < 256 by omega)]
        have hk0 : (128 - R) / 32 * 32 ≥ 32 := by omega
        obtain ⟨hf0, hr0, -⟩ :=
          src_chunk (w := w) (R := R) (k := 0) (j := 0) (c := 16) (D :=
            M.readAt inp (8 * (128 - R))) hin hino hn hsep (by omega)
        obtain ⟨hf1, hr1, hs1⟩ :=
          src_chunk (w := w) (R := R) (k := 0) (j := 16) (c := 16) (D :=
            M.readAt inp (8 * (128 - R))) hin hino hn hsep (by omega)
        rw [Pointer.add_ofNat_zero] at hf0 hr0
        rw [← hM0] at hf0 hr0 hf1 hr1
        step_pure [gep_value (off := 16#64) hs1]
        step_load consuming hf0 hr0
        step_load consuming hf1 hr1
        obtain ⟨hd0, -⟩ :=
          dst_chunk (w := w) (R := R) (k := 0) (c := 16) (k' := 0) (D :=
            M.readAt inp (8 * (128 - R))) hMf (by omega)
        obtain ⟨hd1, hg1⟩ :=
          dst_chunk (w := w) (R := R) (k := 16) (c := 16) (k' := 0) (D :=
            M.readAt inp (8 * (128 - R))) hMf (by omega)
        rw [← hM0] at hd0 hd1
        simp only [Nat.add_zero] at hd0
        step_pure [gep_value (off := 16#64) hg1, Pointer.add_add, ofNat_add_toNat]
        step_store consuming hd0
        step_store consuming hd1
        rw [hM0,
          store_step0 hMf (by omega) (show 128 = 8 * 16 from rfl) (packLanes_ofFn_extractVecElem _),
          store_step (k := 16) hMf (by omega) (show 128 = 8 * 16 from rfl)
            (packLanes_ofFn_extractVecElem _)] at hS
        clear hM0
        step_pure
        finish_block
        · have h32 : (128 - R) / 32 * 32 = 32 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
          step_loop using
            block9 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
        · have h32 : (128 - R) / 32 * 32 ≠ 32 := fun h =>
            hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
          block_init
          have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) 32 :=
            (congrArg GlobalState.mem hS).trans rfl
          copy32 32 48
          step_pure
          finish_block
          · have h64 : (128 - R) / 32 * 32 = 64 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
            step_loop using
              block9 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
          · have h64 : (128 - R) / 32 * 32 ≠ 64 := fun h =>
              hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
            block_init
            have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) 64 :=
              (congrArg GlobalState.mem hS).trans rfl
            copy32 64 80
            step_pure
            finish_block
            · have h96 : (128 - R) / 32 * 32 = 96 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
              step_loop using
                block9 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK
            · have h96 : (128 - R) / 32 * 32 ≠ 96 := fun h =>
                hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
              block_init
              have hM : S.mem = mem M st w R (M.readAt inp (8 * (128 - R))) 96 :=
                (congrArg GlobalState.mem hS).trans rfl
              copy32 96 112
              finish_block
              have h128 : (128 - R) / 32 * 32 = 128 := by omega
              step_loop using
                block9 st inp tmp inlen R ast c1 M w A g K hc1 hRlt hn hMf hin hino hsep hK

end MLIR.Sodium.crypto_hash_sha512_update

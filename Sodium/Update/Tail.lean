module

public import Sodium.Update.Defs
public import Sodium.sodium_memzero
public import Sodium.Common.Counter
import Std.Tactic.BVDecide

/-! `crypto_hash_sha512_update`, the bytes past the whole blocks buffered (`^bb34 … ^bb54`), then
`tmp64` zeroed (`^bb55`) and `^bb56`. -/

namespace MLIR.Sodium.crypto_hash_sha512_update

set_option hygiene false in
/-- `m & 112 == n`: on to `^bb45` with the first `n` bytes copied. -/
local macro "to45" : tactic =>
  `(tactic|
    ( have h := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
      run_from using tail45_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK S
      all_goals
        first
        | omega
        | (rw [hM, h])
        | (rw [h])
        | (simp only [hS, hA])))

set_option hygiene false in
/-- Bytes `j … j + 16` as two 8-byte vectors (`^bb39 … ^bb44`), merged into the struct, `hM`
restated. -/
local macro "copy_pair " j:num j8:num f1:ident f2:ident : tactic =>
  `(tactic|
    ( have ⟨ho1, hf1, hr1⟩ :=
        chunk hM hp hpo hD hsep hm64 (j := $j) (c := 8) (wc := 64) rfl (by omega)
      have ⟨ho2, hf2, hr2⟩ :=
        chunk hM hp hpo hD hsep hm64 (j := $j8) (c := 8) (wc := 64) rfl (by omega)
      have hrm1 := (room_buf hM hMf (j := $j) (c := 8) (wc := 64) rfl (by omega)).1
      have hrm2 := (room_buf hM hMf (j := $j8) (c := 8) (wc := 64) rfl (by omega)).1
      block_init
      step_pure [gep_value ho1]
      step_pure [gep_value ho2]
      step_load consuming hf1 hr1
      step_load consuming hf2 hr2
      step_pure
      step_pure
      step_store consuming hrm1 $f1
      rw [packLanes_ofFn_extractVecElem] at hS
      (try rw [hM] at hS)
      rw [store_chunk hMf _ D (j := $j) (c := 8) (wc := 64) rfl rfl (by omega)] at hS
      step_store consuming hrm2 $f2
      rw [packLanes_ofFn_extractVecElem,
        store_chunk hMf _ D (j := $j8) (c := 8) (wc := 64) rfl rfl (by omega)] at hS
      clear hM ho1 ho2
      have hM := congrArg GlobalState.mem hS
      dsimp only at hM))

set_option hygiene false in
/-- `c` bytes (`wc` bits, one vector) from `in + j` to `state->buf + j`, merged into the struct,
`hM` restated. -/
local macro "copy_vec " j:term:max c:term:max wc:term:max : tactic =>
  `(tactic|
    ( have ⟨ho, hf, hr⟩ :=
        chunk hM hp hpo hD hsep hm64 (j := $j) (c := $c) (wc := $wc) rfl (by omega)
      have ⟨hrm, hod⟩ := room_buf hM hMf (j := $j) (c := $c) (wc := $wc) rfl (by omega)
      step_pure [Nat.mod_eq_of_lt (show $j < 2 ^ 64 by omega), show $j < 2 ^ 64 by omega,
        gep_value ho]
      step_load consuming hf hr
      step_pure [Nat.mod_eq_of_lt (show $j < 2 ^ 64 by omega), show $j < 2 ^ 64 by omega,
        gep_value hod, Pointer.add_add, ← BitVec.ofNat_add]
      step_store consuming hrm hfits_st_0 hread_st_0
      rw [packLanes_ofFn_extractVecElem] at hS
      (try rw [hM] at hS)
      rw [store_chunk hMf _ D (j := $j) (c := $c) (wc := $wc) rfl rfl (by omega)] at hS
      clear hM ho hod
      have hM := congrArg GlobalState.mem hS
      dsimp only at hM))

set_option hygiene false in
/-- `state->buf[j] = in[j]`, then `j + 1`: a byte loaded, stored and merged into the struct,
`hM` restated. -/
local macro "copy_byte " j:term : tactic =>
  `(tactic|
    ( have ⟨ho, hf, hr⟩ := chunk hM hp hpo hD hsep hm64 (j := $j) (c := 1) (wc := 8) rfl (by omega)
      have ⟨hrm, hod⟩ := room_buf hM hMf (j := $j) (c := 1) (wc := 8) rfl (by omega)
      step_pure [Nat.mod_eq_of_lt (show $j < 2 ^ 64 by omega), show $j < 2 ^ 64 by omega,
        gep_value ho]
      step_load consuming hf hr
      step_pure [Nat.mod_eq_of_lt (show $j < 2 ^ 64 by omega), show $j < 2 ^ 64 by omega,
        gep_value hod, Pointer.add_add, ← BitVec.ofNat_add]
      step_store consuming hrm hfits_st_0 hread_st_0
      (try rw [hM] at hS)
      rw [store_chunk hMf _ D (j := $j) (c := 1) (wc := 8) rfl rfl (by omega)] at hS
      clear hM ho hod
      have hM := congrArg GlobalState.mem hS
      dsimp only at hM))

namespace Tail

/-! ### Counters, masks and bytes -/

theorem and_ofNat64 {a c : Nat} (ha : a < 2 ^ 64) (hc : c < 2 ^ 64) :
    BitVec.ofNat 64 a &&& BitVec.ofNat 64 c = BitVec.ofNat 64 (a &&& c) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hc]
  exact (Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt Nat.and_le_left ha)).symm

theorem ult_ofNat64 {a c : Nat} (ha : a < 2 ^ 64) (hc : c < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 c) = decide (a < c) := by
  simp [BitVec.ult, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hc]

theorem and112 : ∀ m < 128, m &&& 112 = m / 16 * 16 := by decide

theorem and12 : ∀ m < 128, m &&& 12 = m % 16 / 4 * 4 := by decide

theorem and124 : ∀ m < 128, m &&& 124 = m / 4 * 4 := by decide

theorem and3 : ∀ m < 128, m &&& 3 = m % 4 := by decide

/-- Bytes `j … j + c` of the `m` known bytes `D` at `p`, past a struct stored in another block. -/
theorem chunk {M m' : MemoryState} {p st : Pointer} {m : Nat} {D : BitVec (8 * m)} {W : HashState}
    (hm' : m' = M.storeHashState st W) (hp : Fits M p (8 * m))
    (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m)) (hD : M.readAt p (8 * m) = D)
    (hsep : p.id ≠ st.id) (hm : m < 2 ^ 64) {j c wc : Nat} (hwc : wc = 8 * c) (hjc : j + c ≤ m) :
    ¬p.offset.uaddOverflow (BitVec.ofNat 64 j) ∧
      Fits m' (p.add (BitVec.ofNat 64 j)) wc ∧
      m'.readAt (p.add (BitVec.ofNat 64 j)) wc = D.extractLsb' (8 * j) wc := by
  subst hwc hm'
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 j) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
      Nat.not_le] at hpo ⊢
    rw [Nat.mod_eq_of_lt (by omega)] at hpo ⊢
    omega
  have hw : (BitVec.ofNat 64 j).toNat * 8 + 8 * c ≤ 8 * m := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨hov, (Fits.add_of_le hov hw hp).storeHashState (by simpa using hsep), ?_⟩
  rw [MemoryState.readAt_storeHashState_of_id_ne (by simpa using hsep),
    MemoryState.readAt_add_of_readAt hp.inBounds hov hw hD, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt (by omega), Nat.mul_comm j 8]

theorem ssub_small {a b : Nat} (ha : a < 2 ^ 62) (hb : b < 2 ^ 62) :
    (BitVec.ofNat 64 a).ssubOverflow (BitVec.ofNat 64 b) = false := by
  have h1 : (BitVec.ofNat 64 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 b).toInt = b := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.ssubOverflow, h1, h2]
  omega

/-- `i0 - m >u -4` for `i0 < m`: fewer than 4 bytes left. -/
theorem ugt_neg4 {i0 m : Nat} (h : i0 < m) (hm : m < 2 ^ 62) :
    (18446744073709551612#64).ult (BitVec.ofNat 64 i0 - BitVec.ofNat 64 m) =
      decide (m - i0 < 4) := by
  have e : (BitVec.ofNat 64 i0 - BitVec.ofNat 64 m).toNat = 2 ^ 64 - (m - i0) := by
    simp [BitVec.toNat_sub]
    omega
  simp only [BitVec.ult, e, BitVec.toNat_ofNat]
  apply decide_eq_decide.2
  omega

/-- No bytes copied. -/
theorem fill_empty (w : HashState) {n : Nat} (D : BitVec n) :
    w.fill 0#64 (D.extractLsb' 0 (8 * 0)) = w := by
  have hs {k : Nat} (b : BitVec 1024) (y : BitVec k) (hk : k = 0) :
    Memory.spliceBits b 0 y = b := by
    subst hk
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits]
    split <;>
      first
      | omega
      | rfl
  simp only [HashState.fill, Firedancer.Ref.fd_sha512_append.copy, BitVec.toNat_ofNat, Nat.zero_mod,
    Nat.zero_mul, hs _ _ rfl]

/-- Bytes `j … j + c` of `D` stored at buffer byte `j`, after bytes `0 … j`. -/
theorem store_chunk {M : MemoryState} {st : Pointer} (hMf : M.HashStateFit st) (w : HashState)
    {n : Nat} (D : BitVec n) {j c wc : Nat} {o : BitVec 64} (ho : o = BitVec.ofNat 64 (80 + j))
    (hwc : wc = 8 * c) (hjc : j + c ≤ 128) :
    (M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * j)))).storeAt (st.add o)
        (D.extractLsb' (8 * j) wc) =
      M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * (j + c)))) := by
  subst ho hwc
  have h80 : (BitVec.ofNat 64 (80 + j)).toNat = 80 + j := by
    simp; omega
  rw [MemoryState.storeHashState_storeAt_buf hMf.1 (by omega) (by omega)]
  have e : BitVec.ofNat 64 (80 + j) - 80#64 = BitVec.ofNat 64 j := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, h80]; simp)]
    simp
    omega
  have := HashState.fill_fill_extract w D (a := 0) (i := 0) (k := j) (c := c) (by omega)
  simp only [Nat.mul_zero, Nat.zero_add] at this
  rw [e, this]

/-- Room for buffer bytes `j … j + c`, which do not wrap. -/
theorem room_buf {M m' : MemoryState} {st : Pointer} {W : HashState}
    (hm' : m' = M.storeHashState st W) (hMf : M.HashStateFit st) {j c wc : Nat} (hwc : wc = 8 * c)
    (hjc : j + c ≤ 128) :
    Room m' (st.add (BitVec.ofNat 64 (80 + j))) wc ∧
      ¬(st.add 80#64).offset.uaddOverflow (BitVec.ofNat 64 j) := by
  subst hwc hm'
  have hb := Pointer.offset_lt_of_hashState hMf.1
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

/-- The final state: the struct stored, `tmp64` zeroed and dead, `0` returned. -/
abbrev Done (A : AllocState) (M : MemoryState) (st tmp : Pointer) (W : HashState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) : Prop :=
  (PoisonOr.value
        (.cons (.value 0#32) .nil,
          { alloc := A,
            mem :=
              ((M.storeHashState st W).storeAt tmp (0 : BitVec (8 * (704#64).toNat))).lifetimeEnd
                tmp }) >>=
      g) =
    K

/-- `^bb55`, `^bb56`: `sodium_memzero(tmp64, sizeof tmp64); return 0;`. -/
theorem done_block (st tmp : Pointer) (M : MemoryState) (W : HashState) (A : AllocState)
    (S : GlobalState) (E : ⟪Γ⟫) (hC : ConstsTail E) (hR : E ⊨ [%1241 := tmp]) (hwf : S.WF)
    (hA : S.alloc = A) (hM : S.mem = M.storeHashState st W) (htmp : Room M tmp 5632)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (hK : Done A M st tmp W g K) :
    (crypto_hash_sha512_update.runFrom E 55 S >>= g) = K := by
  have hz : Room S.mem tmp (8 * (704#64).toNat) := by
    rw [hM]; exact htmp.storeHashState
  block_init
  step_call using sodium_memzero.call_eq consuming hz
  finish_block
  block_init
  step_lifetime
  finish_block
  rw [← hK, hS, hA, hM]
  rfl

/-- `^bb54`, the 4x-unrolled byte loop from byte `i`, `k + 1` rounds left. -/
theorem bytes4_loop (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) :
    ∀ k i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        ConstsTail E →
        (E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1498 :=
          BitVec.ofNat 64 i]) →
        i + 4 * (k + 1) = m →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * i))) →
        (crypto_hash_sha512_update.runFrom E 54 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  intro k
  induction k with
  | zero =>
    intro i S E hArgs hC hR hk hwf hA hM
    block_init
    copy_byte i
    step_pure [saddOverflow_ofNat64 (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 1)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 2) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 2) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 2)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 3) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 3) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 3)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 4) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure [ofNat64_eq_iff (show i + 4 < 2 ^ 64 by omega) hm64]
    finish_block
    · run_from using
        done_block st tmp M _ A (htmp := htmp) (hK := hK) (hA := by rw [hS, hA]) (hM := by
          rw [hM, show i + 3 + 1 = m by omega])
    · exact absurd ((ofNat64_eq_iff (by omega) hm64).2 (by omega)) hbr
  | succ k ih =>
    intro i S E hArgs hC hR hk hwf hA hM
    block_init
    copy_byte i
    step_pure [saddOverflow_ofNat64 (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 1)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 2) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 2) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 2)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 3) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 3) (by omega), ← BitVec.ofNat_add]
    copy_byte (i + 3)
    step_pure [saddOverflow_ofNat64 (i := i) (k := 4) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure [ofNat64_eq_iff (show i + 4 < 2 ^ 64 by omega) hm64]
    finish_block
    · have := (ofNat64_eq_iff (by omega) hm64).1 hbr
      omega
    · run_from using ih (i + 4)

/-- `^bb52`, from byte `j = i0 + m % 4`: done if fewer than 4 bytes were left at `i0`, else the
4x-unrolled loop. -/
theorem tail52_block (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) (i0 j : Nat)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : ConstsTail E)
    (hR :
      E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1479 :=
        BitVec.ofNat 64 i0, %1490 := BitVec.ofNat 64 j])
    (hi0 : i0 % 4 = 0) (hlt : i0 < m) (hj : j = i0 + m % 4) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * j)))) :
    (crypto_hash_sha512_update.runFrom E 52 S >>= g) = K := by
  block_init
  step_pure [ssub_small (a := i0) (b := m) (by omega) (by omega)]
  step_pure [ugt_neg4 hlt (by omega)]
  finish_block
  all_goals simp only [decide_eq_true_eq] at hbr
  · run_from using
      done_block st tmp M _ A (htmp := htmp) (hK := hK) (hA := hA) (hM := by
        rw [hM, show j = m by omega])
  · run_from using
      bytes4_loop st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK ((m - j) / 4 - 1) j

/-- `^bb51`, the byte prologue from byte `i = i0 + c`, `k + 1` bytes left of `m % 4`. -/
theorem prologue_loop (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) (i0 : Nat) (hi0 : i0 % 4 = 0)
    (hlt : i0 < m) :
    ∀ k c (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        ConstsTail E →
        (E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1479 :=
          BitVec.ofNat 64 i0, %1480 := BitVec.ofNat 64 (m % 4), %1482 := BitVec.ofNat 64 (i0 + c),
          %1483 := BitVec.ofNat 64 c]) →
        c + k + 1 = m % 4 →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * (i0 + c)))) →
        (crypto_hash_sha512_update.runFrom E 51 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  intro k
  induction k with
  | zero =>
    intro c S E hArgs hC hR hk hwf hA hM
    block_init
    copy_byte (i0 + c)
    step_pure [saddOverflow_ofNat64 (i := i0 + c) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i0 + c) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure [← BitVec.ofNat_add]
    step_pure
    finish_block
    · run_from using
        tail52_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK i0 (i0 + c + 1)
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).2 (by omega)) hbr
  | succ k ih =>
    intro c S E hArgs hC hR hk hwf hA hM
    block_init
    copy_byte (i0 + c)
    step_pure [saddOverflow_ofNat64 (i := i0 + c) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i0 + c) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure [← BitVec.ofNat_add]
    step_pure
    finish_block
    · have := (ofNat64_eq_iff (by omega) (by omega)).1 hbr
      omega
    · run_from using ih (c + 1)

/-- `^bb50`, the scalar copy from byte `i0`, a multiple of 4 below `m`. -/
theorem tail50_block (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) (i0 : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hC : ConstsTail E)
    (hR :
      E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1479 :=
        BitVec.ofNat 64 i0])
    (hi0 : i0 % 4 = 0) (hlt : i0 < m) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * i0)))) :
    (crypto_hash_sha512_update.runFrom E 50 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  block_init
  step_pure [and_ofNat64 hm64 (show 3 < 2 ^ 64 by decide), and3 m hm]
  step_pure
  finish_block
  · have h0 : m % 4 = 0 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
    run_from using
      tail52_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK i0 i0 S
  · have h0 : m % 4 ≠ 0 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
    run_from using
      prologue_loop st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK i0 hi0 hlt
        (m % 4 - 1) 0 S

/-- `^bb48`, the 4-byte vector loop from byte `i`, `k + 1` words left to `m & 124`; then `^bb49`. -/
theorem word_loop (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) :
    ∀ k i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        ConstsTail E →
        (E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1471 :=
          BitVec.ofNat 64 (m / 4 * 4), %1472 := BitVec.ofNat 64 i]) →
        i % 4 = 0 →
        i + 4 * (k + 1) = m / 4 * 4 →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * i))) →
        (crypto_hash_sha512_update.runFrom E 48 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  intro k
  induction k with
  | zero =>
    intro i S E hArgs hC hR hi4 hk hwf hA hM
    block_init
    copy_vec i 4 32
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · block_init
      step_pure
      finish_block
      · have h0 := (ofNat64_eq_iff hm64 (by omega)).1 hbr
        run_from using
          done_block st tmp M _ A (htmp := htmp) (hK := hK) (hA := by rw [hS, hA]) (hM := by
            rw [hM, show i + 4 = m by omega])
      · have h0 : m ≠ m / 4 * 4 := fun h => hbr ((ofNat64_eq_iff hm64 (by omega)).2 h)
        run_from using
          tail50_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK (m / 4 * 4)
        all_goals
          first
          | omega
          | (rw [hS, hA])
          | (rw [show i + 4 = m / 4 * 4 by omega])
    · exact absurd ((ofNat64_eq_iff (by omega) (by omega)).2 (by omega)) hbr
  | succ k ih =>
    intro i S E hArgs hC hR hi4 hk hwf hA hM
    block_init
    copy_vec i 4 32
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · have := (ofNat64_eq_iff (by omega) (by omega)).1 hbr
      omega
    · run_from using ih (i + 4)

/-- `^bb47`, the 4-byte vector loop's entry at byte `i0`, a multiple of 4 below `m & 124`. -/
theorem tail47_block (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) (i0 : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hC : ConstsTail E)
    (hR :
      E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1470 :=
        BitVec.ofNat 64 i0])
    (hi0 : i0 % 4 = 0) (hlt : i0 + 4 ≤ m / 4 * 4) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * i0)))) :
    (crypto_hash_sha512_update.runFrom E 47 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  block_init
  step_pure [and_ofNat64 hm64 (show 124 < 2 ^ 64 by decide), and124 m hm]
  finish_block
  run_from using
    word_loop st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK
      ((m / 4 * 4 - i0) / 4 - 1) i0 S

/-- `^bb45`, `^bb46`: after the 16-byte chunks, to byte `m & 112`: done, the 4-byte loop or the
scalar copy. -/
theorem tail45_block (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (M : MemoryState)
    (w : HashState) (D : BitVec (8 * m)) (A : AllocState) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m))
    (hD : M.readAt p (8 * m) = D) (hsep : p.id ≠ st.id) (htmp : Room M tmp 5632) (hm : m < 128)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK : Done A M st tmp (w.fill 0#64 (D.extractLsb' 0 (8 * m))) g K) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : ConstsTail E)
    (hR :
      E ⊨ [%1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 := p, %1420 :=
        BitVec.ofNat 64 (m % 16 / 4 * 4), %1421 := BitVec.ofNat 64 (m / 16 * 16)])
    (h16 : 16 ≤ m) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * (m / 16 * 16))))) :
    (crypto_hash_sha512_update.runFrom E 45 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  block_init
  step_pure
  finish_block
  · have h0 := (ofNat64_eq_iff hm64 (by omega)).1 hbr
    run_from using
      done_block st tmp M _ A (htmp := htmp) (hK := hK) (hA := hA) (hM := by rw [hM, ← h0])
  · have h0 : m ≠ m / 16 * 16 := fun h => hbr ((ofNat64_eq_iff hm64 (by omega)).2 h)
    block_init
    step_pure
    finish_block
    · have h1 := (ofNat64_eq_iff (by omega) (by decide)).1 hbr
      run_from using
        tail50_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK (m / 16 * 16) S
    · have h1 : m % 16 / 4 * 4 ≠ 0 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
      run_from using
        tail47_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK (m / 16 * 16) S

/-- All of `D`'s bytes. -/
theorem extractLsb'_self {n : Nat} (D : BitVec n) : D.extractLsb' 0 n = D := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

end Tail

open Tail in
/-- `inlen &= 127; for (i = 0; i < inlen; i++) { state->buf[i] = in[i]; }
sodium_memzero(tmp64, sizeof tmp64); return 0;` for the `m < 128` bytes at `p`, every vectorized
path and either outcome of the alias check. -/
public theorem tail_block (st inp tmp p : Pointer) (inlen : BitVec 64) (m : Nat) (ast : BitVec 64)
    (M : MemoryState) (w : HashState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : ConstsTail E)
    (hR :
      E ⊨ [%1240 := ast, %1241 := tmp, %1258 := st.add 80#64, %1411 := BitVec.ofNat 64 m, %1412 :=
        p])
    (hm : m < 128) (hwf : S.WF) (hM : S.mem = M.storeHashState st w) (hMf : M.HashStateFit st)
    (hp : Fits M p (8 * m)) (hpo : ¬p.offset.uaddOverflow (BitVec.ofNat 64 m)) (hsep : p.id ≠ st.id)
    (htmp : Room M tmp 5632)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := S.alloc,
                mem :=
                  ((M.storeHashState st
                            (if m = 0 then w else w.fill 0#64 (M.readAt p (8 * m)))).storeAt
                        tmp (0 : BitVec (8 * (704#64).toNat))).lifetimeEnd
                    tmp }) >>=
          g) =
        K) :
    (crypto_hash_sha512_update.runFrom E 34 S >>= g) = K := by
  have hm64 : m < 2 ^ 64 := by omega
  generalize hD : M.readAt p (8 * m) = D at hK
  have hfin : (if m = 0 then w else w.fill 0#64 D) = w.fill 0#64 (D.extractLsb' 0 (8 * m)) := by
    split
    · rename_i h0
      subst h0
      exact (fill_empty w D).symm
    · rw [extractLsb'_self]
  rw [hfin] at hK
  generalize hA : S.alloc = A at hK
  replace hM : S.mem = M.storeHashState st (w.fill 0#64 (D.extractLsb' 0 (8 * 0))) := by
    rw [hM, fill_empty]
  -- if (inlen == 0) goto zero
  block_init
  step_pure with ap
  clear hap
  step_pure
  finish_block
  · have h0 := (ofNat64_eq_iff hm64 (by decide)).1 hbr
    subst h0
    run_from using done_block st tmp M _ A (htmp := htmp) (hK := hK) (hA := hA) (hM := hM)
  have h0 : m ≠ 0 := fun h => hbr ((ofNat64_eq_iff hm64 (by decide)).2 h)
  -- fewer than 4 bytes: scalar
  block_init
  step_pure [ult_ofNat64 hm64 (show 4 < 2 ^ 64 by decide)]
  finish_block
  · run_from using tail50_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK 0 S
  have h4 : 4 ≤ m := by simpa using hbr
  -- the alias check: scalar if the buffer may overlap `in`
  block_init
  iterate 3 step_pure
  finish_block
  · run_from using tail50_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK 0 S
  -- fewer than 16 bytes: the 4-byte loop
  block_init
  step_pure [ult_ofNat64 hm64 (show 16 < 2 ^ 64 by decide)]
  finish_block
  · run_from using tail47_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK 0 S
  have h16 : 16 ≤ m := by simpa using hbr
  -- the 16-byte chunks, `m & 112` bytes
  block_init
  step_pure [and_ofNat64 hm64 (show 12 < 2 ^ 64 by decide), and12 m hm]
  step_pure [and_ofNat64 hm64 (show 112 < 2 ^ 64 by decide), and112 m hm]
  have ⟨_, hf1, hr1⟩ := chunk hM hp hpo hD hsep hm64 (j := 0) (c := 8) (wc := 64) rfl (by omega)
  have ⟨ho2, hf2, hr2⟩ := chunk hM hp hpo hD hsep hm64 (j := 8) (c := 8) (wc := 64) rfl (by omega)
  have hrm1 := (room_buf hM hMf (j := 0) (c := 8) (wc := 64) rfl (by omega)).1
  have hrm2 := (room_buf hM hMf (j := 8) (c := 8) (wc := 64) rfl (by omega)).1
  simp only [Nat.reduceAdd, Pointer.add_zero] at hf1 hr1 hrm1 hrm2
  step_pure [gep_value ho2]
  step_load consuming hf1 hr1
  step_load consuming hf2 hr2
  step_pure
  step_store consuming hrm1 hread_st_80 hfits_st_80
  rw [packLanes_ofFn_extractVecElem, hM,
    store_chunk hMf _ D (j := 0) (c := 8) (wc := 64) rfl rfl (by omega)] at hS
  step_store consuming hrm2 hread_st_88 hfits_st_88
  rw [packLanes_ofFn_extractVecElem,
    store_chunk hMf _ D (j := 8) (c := 8) (wc := 64) rfl rfl (by omega)] at hS
  clear hM ho2
  have hM := congrArg GlobalState.mem hS
  dsimp only at hM
  step_pure
  finish_block
  · to45
  have h1 : m / 16 * 16 ≠ 16 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 16 24hfits_st_96 hfits_st_104
  step_pure
  finish_block
  · to45
  have h2 : m / 16 * 16 ≠ 32 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 32 40hfits_st_112 hfits_st_120
  step_pure
  finish_block
  · to45
  have h3 : m / 16 * 16 ≠ 48 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 48 56hfits_st_128 hfits_st_136
  step_pure
  finish_block
  · to45
  have h4 : m / 16 * 16 ≠ 64 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 64 72hfits_st_144 hfits_st_152
  step_pure
  finish_block
  · to45
  have h5 : m / 16 * 16 ≠ 80 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 80 88hfits_st_160 hfits_st_168
  step_pure
  finish_block
  · to45
  have h6 : m / 16 * 16 ≠ 96 := fun h => hbr ((ofNat64_eq_iff (by omega) (by decide)).2 h)
  copy_pair 96 104hfits_st_176 hfits_st_184
  finish_block
  have h7 : m / 16 * 16 = 112 := by omega
  run_from using tail45_block st inp tmp p inlen m M w D A hMf hp hpo hD hsep htmp hm g K hK S
  all_goals
    first
    | omega
    | (rw [hM, h7])
    | (rw [h7])

end MLIR.Sodium.crypto_hash_sha512_update

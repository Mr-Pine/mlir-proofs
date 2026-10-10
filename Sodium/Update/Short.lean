module

public import Sodium.Update.Defs
import Sodium.Common.Counter
import Std.Tactic.BVDecide

/-! `crypto_hash_sha512_update`, `inlen < 128 - r`: the bytes buffered (`^bb17 … ^bb31`), then
`^bb56`. -/

namespace MLIR.Sodium.crypto_hash_sha512_update

namespace Short

set_option hygiene false in
/-- One round of `^bb31`: bytes `i … i + 3` copied, the counter moved on. -/
local macro "quad_body" : tactic =>
  `(tactic|
    ( have hi : i < 18446744073709551616 := by omega
      obtain ⟨hf0, hr0⟩ := inp_chunk (i := i) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
      obtain ⟨hf1, hr1⟩ := inp_chunk (i := i + 1) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
      obtain ⟨hf2, hr2⟩ := inp_chunk (i := i + 2) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
      obtain ⟨hf3, hr3⟩ := inp_chunk (i := i + 3) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
      obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := i) (c := 1) (w := 8) hM hMf rfl (by omega)
      obtain ⟨ho1, hb1⟩ := buf_ptr (R := R) (i := i + 1) (c := 1) (w := 8) hM hMf rfl (by omega)
      obtain ⟨ho2, hb2⟩ := buf_ptr (R := R) (i := i + 2) (c := 1) (w := 8) hM hMf rfl (by omega)
      obtain ⟨ho3, hb3⟩ := buf_ptr (R := R) (i := i + 3) (c := 1) (w := 8) hM hMf rfl (by omega)
      have hR' := hR
      block_init
      -- state->buf[r + i] = in[i];
      step_pure [Nat.mod_eq_of_lt hi, hi]
      step_load consuming hf0 hr0
      step_pure [Nat.mod_eq_of_lt hi, hi]
      step_store consuming hb0 ho0
      step_pure [saddOverflow_ofNat64 (i := i) (k := 1) (by omega),
        uaddOverflow_ofNat64 (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
      step_pure [Nat.mod_eq_of_lt (show i + 1 < 2 ^ 64 by omega), show i + 1 < 2 ^ 64 by omega]
      step_load consuming hf1 hr1
      step_pure [Nat.mod_eq_of_lt (show i + 1 < 2 ^ 64 by omega), show i + 1 < 2 ^ 64 by omega]
      step_store consuming hb1 ho1
      step_pure [saddOverflow_ofNat64 (i := i) (k := 2) (by omega),
        uaddOverflow_ofNat64 (i := i) (k := 2) (by omega), ← BitVec.ofNat_add]
      step_pure [Nat.mod_eq_of_lt (show i + 2 < 2 ^ 64 by omega), show i + 2 < 2 ^ 64 by omega]
      step_load consuming hf2 hr2
      step_pure [Nat.mod_eq_of_lt (show i + 2 < 2 ^ 64 by omega), show i + 2 < 2 ^ 64 by omega]
      step_store consuming hb2 ho2
      step_pure [saddOverflow_ofNat64 (i := i) (k := 3) (by omega),
        uaddOverflow_ofNat64 (i := i) (k := 3) (by omega), ← BitVec.ofNat_add]
      step_pure [Nat.mod_eq_of_lt (show i + 3 < 2 ^ 64 by omega), show i + 3 < 2 ^ 64 by omega]
      step_load consuming hf3 hr3
      step_pure [Nat.mod_eq_of_lt (show i + 3 < 2 ^ 64 by omega), show i + 3 < 2 ^ 64 by omega]
      step_store consuming hb3 ho3
      step_pure [saddOverflow_ofNat64 (i := i) (k := 4) (by omega),
        uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
      step_pure))

/-- `buf` with bytes `[0, k)` of `D` copied in at `R`. -/
def filled (w : HashState) (R : Nat) (D : BitVec n) (k : Nat) : HashState :=
  w.fill (BitVec.ofNat 64 R) (D.extractLsb' 0 (8 * k))

/-- `c` bytes of `inp` at `i`, read through the struct stored at `st`. -/
theorem inp_chunk {m M : MemoryState} {st inp : Pointer} {v : HashState} {inlen : BitVec 64}
    (hM : m = M.storeHashState st v) (hsep : inp.id ≠ st.id) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) {i c w : Nat} (hw : w = 8 * c)
    (hic : i + c ≤ inlen.toNat) :
    Fits m (inp.add (BitVec.ofNat 64 i)) w ∧
      m.readAt (inp.add (BitVec.ofNat 64 i)) w =
        (M.readAt inp (8 * inlen.toNat)).extractLsb' (8 * i) w := by
  subst hM hw
  have := inlen.isLt
  have hov : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 i) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
      Nat.not_le] at hino ⊢
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hle : (BitVec.ofNat 64 i).toNat * 8 + 8 * c ≤ 8 * inlen.toNat := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨(Fits.add_of_le hov hle hin).storeHashState hsep, ?_⟩
  rw [MemoryState.readAt_storeHashState_of_id_ne (q := inp.add (BitVec.ofNat 64 i)) hsep,
    MemoryState.readAt_add_of_readAt hin.inBounds hov hle rfl, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt (by omega), Nat.mul_comm i 8]

/-- `buf + R + i`: the pointer does not wrap, room for `c` bytes. -/
theorem buf_ptr {m M : MemoryState} {st : Pointer} {v : HashState} {R : Nat}
    (hM : m = M.storeHashState st v) (hMf : M.HashStateFit st) {i c w : Nat} (hw : w = 8 * c)
    (hic : R + i + c ≤ 128) :
    ¬(st.add (BitVec.ofNat 64 (80 + R))).offset.uaddOverflow (BitVec.ofNat 64 i) ∧
      Room m ((st.add (BitVec.ofNat 64 (80 + R))).add (BitVec.ofNat 64 i)) w := by
  subst hM hw
  have ho := Pointer.offset_lt_of_hashState hMf.1
  have h1 := Pointer.offset_add_of_hashState hMf.1 (k := 80 + R) (by omega)
  refine ⟨?_, ?_⟩
  · simp only [BitVec.uaddOverflow, h1, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
      Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  · rw [Pointer.add_add, ← BitVec.ofNat_add]
    refine
      (Room.add_of_le (Pointer.not_uaddOverflow_of_hashState hMf.1 ?_) ?_ hMf.2.1).storeHashState
    · simp; omega
    · rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
      omega

/-- One more run of `D`'s bytes stored into `buf` right after the `k` copied. -/
theorem store_chunk {M : MemoryState} {st : Pointer} {w : HashState} {R : Nat} {D : BitVec n}
    {k c wd : Nat} {off : BitVec 64} (hMf : M.HashStateFit st) (hwd : wd = 8 * c)
    (hkc : R + k + c ≤ 128) (hoff : off = BitVec.ofNat 64 (80 + R) + BitVec.ofNat 64 k) :
    (M.storeHashState st (filled w R D k)).storeAt (st.add off) (D.extractLsb' (8 * k) wd) =
      M.storeHashState st (filled w R D (k + c)) := by
  subst hwd hoff
  have h : (BitVec.ofNat 64 (80 + R) + BitVec.ofNat 64 k).toNat = 80 + R + k := by
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  rw [MemoryState.storeHashState_storeAt_buf hMf.1 (by omega) (by omega)]
  have e : BitVec.ofNat 64 (80 + R) + BitVec.ofNat 64 k - 80#64 = BitVec.ofNat 64 (R + k) := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, h]; simp; omega),
      h]
    simp
    omega
  have := HashState.fill_fill_extract w D (a := R) (i := 0) (k := k) (c := c) (by omega)
  simp only [Nat.mul_zero, Nat.zero_add] at this
  rw [e, filled, this, filled]

theorem filled_zero (w : HashState) (R : Nat) (D : BitVec n) : filled w R D 0 = w := by
  have h (b : BitVec 1024) (o : BitVec 64) (x : BitVec 0) :
    Firedancer.Ref.fd_sha512_append.copy b o x = b := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp only [Firedancer.Ref.fd_sha512_append.copy, Memory.getLsbD_spliceBits]
    split <;>
      first
      | omega
      | rfl
  simp only [filled, HashState.fill, h]

theorem filled_full (w : HashState) (R : Nat) (D : BitVec (8 * n)) :
    filled w R D n = w.fill (BitVec.ofNat 64 R) D := by
  have : D.extractLsb' 0 (8 * n) = D := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [hj]
  rw [filled, this]

/-- `^bb56`: `tmp64`'s lifetime ends, `0` returned. -/
theorem ret_block (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (S : GlobalState) (E : ⟪Γ⟫)
    (_hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hR : E ⊨ [%1241 := tmp, %1238 := 0#32]) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) inlen.toNat)) :
    (crypto_hash_sha512_update.runFrom E 56 S >>= g) = K := by
  block_init
  step_lifetime
  finish_block
  rw [hS, hM, hA, filled_full]
  exact hK

/-- `store_chunk` at `buf + R` itself. -/
theorem store_chunk0 {M : MemoryState} {st : Pointer} {w : HashState} {R : Nat} {D : BitVec n}
    {c wd : Nat} (hMf : M.HashStateFit st) (hwd : wd = 8 * c) (hkc : R + c ≤ 128) :
    (M.storeHashState st (filled w R D 0)).storeAt (st.add (BitVec.ofNat 64 (80 + R)))
        (D.extractLsb' 0 wd) =
      M.storeHashState st (filled w R D c) := by
  have :=
    store_chunk (k := 0) (c := c) (D := D) (w := w) hMf hwd (by omega) (off :=
      BitVec.ofNat 64 (80 + R)) (by simp)
  rwa [Nat.mul_zero, Nat.zero_add] at this

/-- `^bb31`, four bytes per round from `i`, `j + 1` rounds left. -/
theorem quad_loop (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K) :
    ∀ j i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        (E ⊨ [%1241 := tmp, %1238 := 0#32, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64, %1228 :=
          4#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)), %1371 := BitVec.ofNat 64 i]) →
        i + 4 * (j + 1) = inlen.toNat →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) i) →
        (crypto_hash_sha512_update.runFrom E 31 S >>= g) = K := by
  intro j
  induction j with
  | zero =>
    intro i S E hArgs hR hk hwf hA hM
    quad_body
    finish_block
    · step_loop using ret_block st inp tmp inlen R M w A g K hK
      rw [store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
        store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
        store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
        store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
        show i + 1 + 1 + 1 + 1 = inlen.toNat by omega]
    · exact
        absurd
          (BitVec.eq_of_toNat_eq
            (by
              simp; omega))
          hbr
  | succ j ih =>
    intro i S E hArgs hR hk hwf hA hM
    quad_body
    finish_block
    · have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · step_loop using ih (i + 4)
      all_goals
        first
        | omega
        |
          (rw [store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
              store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
              store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
              store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl])

/-- `i0 - inlen >u -4`: fewer than four bytes from `i0`. -/
theorem sub_ugt_iff {i0 : Nat} {inlen : BitVec 64} (h : i0 < inlen.toNat) :
    (18446744073709551612#64).ult (BitVec.ofNat 64 i0 - inlen) = true ↔ inlen.toNat - i0 < 4 := by
  have := inlen.isLt
  simp only [BitVec.ult, BitVec.toNat_sub, BitVec.toNat_ofNat, decide_eq_true_eq,
    Nat.reducePow] at this ⊢
  generalize inlen.toNat = L at *
  omega

/-- `^bb30`, after the byte prologue: the rest four bytes per round from `i1`, or none left. -/
theorem prologue_done (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (i0 : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hR :
      E ⊨ [%1241 := tmp, %1238 := 0#32, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64, %1228 := 4#64,
        %1235 := 18446744073709551612#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)), %1357 :=
        BitVec.ofNat 64 i0, %1368 := BitVec.ofNat 64 (i0 + inlen.toNat % 4)])
    (hi0 : i0 % 4 = 0) (hlt : i0 < inlen.toNat) (hwf : S.WF) (hA : S.alloc = A)
    (hM :
      S.mem =
        M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) (i0 + inlen.toNat % 4))) :
    (crypto_hash_sha512_update.runFrom E 30 S >>= g) = K := by
  block_init
  step_pure
  step_pure
  finish_block
  · rw [sub_ugt_iff (by omega)] at hbr
    step_loop using ret_block st inp tmp inlen R M w A g K hK
    rw [show i0 + inlen.toNat % 4 = inlen.toNat by omega]
  · rw [sub_ugt_iff (by omega)] at hbr
    step_loop using
      quad_loop st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK
        ((inlen.toNat - (i0 + inlen.toNat % 4)) / 4 - 1) (i0 + inlen.toNat % 4)

theorem toNat_and_3 (x : BitVec 64) : (x &&& 3#64).toNat = x.toNat % 4 := by
  rw [BitVec.toNat_and, show (3#64).toNat = 2 ^ 2 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

/-- `^bb29`, the byte prologue from `i0 + j`, `m + 1` bytes left of `inlen & 3`. -/
theorem pro_loop (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (i0 : Nat) (hi0 : i0 % 4 = 0) (hlt : i0 < inlen.toNat) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        (E ⊨ [%1241 := tmp, %1238 := 0#32, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64, %1228 :=
          4#64, %1235 := 18446744073709551612#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)),
          %1357 := BitVec.ofNat 64 i0, %1358 := inlen &&& 3#64, %1360 := BitVec.ofNat 64 (i0 + j),
          %1361 := BitVec.ofNat 64 j]) →
        j + m + 1 = inlen.toNat % 4 →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) (i0 + j)) →
        (crypto_hash_sha512_update.runFrom E 29 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro j S E hArgs hR hk hwf hA hM
    have hi : i0 + j < 18446744073709551616 := by omega
    obtain ⟨hf0, hr0⟩ := inp_chunk (i := i0 + j) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
    obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := i0 + j) (c := 1) (w := 8) hM hMf rfl (by omega)
    block_init
    -- state->buf[r + i] = in[i];
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load consuming hf0 hr0
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_store consuming hb0 ho0
    step_pure [saddOverflow_ofNat64 (i := i0 + j) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i0 + j) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure [← BitVec.ofNat_add]
    step_pure
    finish_block
    · step_loop using prologue_done st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK i0
      all_goals
        first
        | omega
        |
          (rw [store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl,
              show i0 + inlen.toNat % 4 = i0 + j + 1 by omega])
        | rw [show i0 + inlen.toNat % 4 = i0 + j + 1 by omega]
    · exact
        absurd
          (BitVec.eq_of_toNat_eq
            (by
              rw [toNat_and_3]; simp; omega))
          hbr
  | succ m ih =>
    intro j S E hArgs hR hk hwf hA hM
    have hi : i0 + j < 18446744073709551616 := by omega
    obtain ⟨hf0, hr0⟩ := inp_chunk (i := i0 + j) (c := 1) (w := 8) hM hsep hin hino rfl (by omega)
    obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := i0 + j) (c := 1) (w := 8) hM hMf rfl (by omega)
    block_init
    -- state->buf[r + i] = in[i];
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load consuming hf0 hr0
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_store consuming hb0 ho0
    step_pure [saddOverflow_ofNat64 (i := i0 + j) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i0 + j) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure [← BitVec.ofNat_add]
    step_pure
    finish_block
    · have := congrArg BitVec.toNat hbr
      rw [toNat_and_3] at this
      simp at this
      omega
    · step_loop using ih (j + 1)
      all_goals
        first
        | omega
        | rw [store_chunk (c := 1) (wd := 8) hMf rfl (by omega) rfl, Nat.add_assoc]

/-- `^bb28`, the bytes from `i0` (a multiple of 4 below `inlen`): the prologue of `inlen & 3`,
then four per round. -/
theorem bytes_entry (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (i0 : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hR :
      E ⊨ [%1241 := tmp, %1238 := 0#32, %1210 := 0#64, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64,
        %1228 := 4#64, %1235 := 18446744073709551612#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)),
        %1357 := BitVec.ofNat 64 i0])
    (hi0 : i0 % 4 = 0) (hlt : i0 < inlen.toNat) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) i0)) :
    (crypto_hash_sha512_update.runFrom E 28 S >>= g) = K := by
  block_init
  step_pure
  step_pure
  finish_block
  · have h3 : inlen.toNat % 4 = 0 := by
      have := congrArg BitVec.toNat hbr
      rwa [toNat_and_3] at this
    step_loop using prologue_done st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK i0
  · have h3 : inlen.toNat % 4 ≠ 0 := fun h =>
      hbr
        (BitVec.eq_of_toNat_eq
          (by
            rw [toNat_and_3]; exact h))
    step_loop using
      pro_loop st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK i0 hi0 hlt
        (inlen.toNat % 4 - 1) 0

theorem toNat_and_neg4 (x : BitVec 64) :
    (x &&& 18446744073709551612#64).toNat = x.toNat / 4 * 4 := by
  have e : x &&& 18446744073709551612#64 = x - (x &&& 3#64) := by bv_decide
  rw [e,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, toNat_and_3]; omega),
    toNat_and_3]
  omega

/-- `^bb26`, four bytes per vector from `i`, `j + 1` vectors left. -/
theorem word_loop (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K) :
    ∀ j i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value st) (.value inp) (.value inlen)).get →
        (E ⊨ [%1241 := tmp, %1238 := 0#32, %1210 := 0#64, %1229 := 1#64, %1231 := 2#64, %1212 :=
          3#64, %1228 := 4#64, %1235 := 18446744073709551612#64, %1259 :=
          st.add (BitVec.ofNat 64 (80 + R)), %1349 := inlen &&& 18446744073709551612#64, %1350 :=
          BitVec.ofNat 64 i]) →
        i % 4 = 0 →
        i + 4 * (j + 1) = inlen.toNat / 4 * 4 →
        S.WF →
        S.alloc = A →
        S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) i) →
        (crypto_hash_sha512_update.runFrom E 26 S >>= g) = K := by
  intro j
  induction j with
  | zero =>
    intro i S E hArgs hR hi4 hk hwf hA hM
    have hi : i < 18446744073709551616 := by omega
    obtain ⟨hf0, hr0⟩ := inp_chunk (i := i) (c := 4) (w := 32) hM hsep hin hino rfl (by omega)
    obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := i) (c := 4) (w := 32) hM hMf rfl (by omega)
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load consuming hf0 hr0
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_store consuming hb0 ho0
    step_pure [saddOverflow_ofNat64 (i := i) (k := 4) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · have hk' : i + 4 = inlen.toNat / 4 * 4 := by omega
      block_init
      step_pure
      finish_block
      · have e := congrArg BitVec.toNat hbr
        rw [toNat_and_neg4] at e
        have hM' :
          S.mem =
            M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) inlen.toNat) := by
          rw [hS, hM, packLanes_ofFn_extractVecElem,
            store_chunk (c := 4) (wd := 32) hMf rfl (by omega) rfl,
            show i + 4 = inlen.toNat by omega]
        step_loop using ret_block st inp tmp inlen R M w A g K hK
      · have e : inlen.toNat ≠ inlen.toNat / 4 * 4 := fun e =>
          hbr
            (BitVec.eq_of_toNat_eq
              (by
                rw [toNat_and_neg4]; exact e))
        step_loop using
          bytes_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK (i + 4)
        all_goals
          first
          | omega
          |
            rw [packLanes_ofFn_extractVecElem,
              store_chunk (c := 4) (wd := 32) hMf rfl (by omega) rfl, hk']
          | ( apply BitVec.eq_of_toNat_eq
              rw [toNat_and_neg4, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)])
    · exact
        absurd
          (BitVec.eq_of_toNat_eq
            (by
              rw [toNat_and_neg4]; simp; omega))
          hbr
  | succ j ih =>
    intro i S E hArgs hR hi4 hk hwf hA hM
    have hi : i < 18446744073709551616 := by omega
    obtain ⟨hf0, hr0⟩ := inp_chunk (i := i) (c := 4) (w := 32) hM hsep hin hino rfl (by omega)
    obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := i) (c := 4) (w := 32) hM hMf rfl (by omega)
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load consuming hf0 hr0
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_store consuming hb0 ho0
    step_pure [saddOverflow_ofNat64 (i := i) (k := 4) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 4) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · have := congrArg BitVec.toNat hbr
      rw [toNat_and_neg4] at this
      simp at this
      omega
    · step_loop using ih (i + 4)
      all_goals
        first
        | omega
        | rw [packLanes_ofFn_extractVecElem, store_chunk (c := 4) (wd := 32) hMf rfl (by omega) rfl]

/-- `^bb25`, the 4-byte vectors' entry at `i0`, a multiple of 4 at least 4 below `inlen`. -/
theorem word_entry (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (i0 : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hR :
      E ⊨ [%1241 := tmp, %1238 := 0#32, %1210 := 0#64, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64,
        %1228 := 4#64, %1235 := 18446744073709551612#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)),
        %1348 := BitVec.ofNat 64 i0])
    (hi0 : i0 % 4 = 0) (hlt : i0 + 4 ≤ inlen.toNat) (hwf : S.WF) (hA : S.alloc = A)
    (hM : S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) i0)) :
    (crypto_hash_sha512_update.runFrom E 25 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  have h4 : inlen.toNat &&& 18446744073709551612 = inlen.toNat / 4 * 4 := by
    have := toNat_and_neg4 inlen
    rw [BitVec.toNat_and] at this
    exact this
  step_loop using
    word_loop st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK
      ((inlen.toNat / 4 * 4 - i0) / 4 - 1) i0

theorem toNat_and_neg32 (x : BitVec 64) :
    (x &&& 18446744073709551584#64).toNat = x.toNat / 32 * 32 := by
  have e : x &&& 18446744073709551584#64 = x - (x &&& 31#64) := by bv_decide
  have h31 : (x &&& 31#64).toNat = x.toNat % 32 := by
    rw [BitVec.toNat_and, show (31#64).toNat = 2 ^ 5 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  rw [e,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h31]; omega),
    h31]
  omega

theorem toNat_and_28 (x : BitVec 64) : (x &&& 28#64).toNat = x.toNat % 32 - x.toNat % 4 := by
  have e : x &&& 28#64 = (x &&& 31#64) - (x &&& 3#64) := by bv_decide
  have hle : x &&& 3#64 ≤ x &&& 31#64 := by bv_decide
  have h31 : (x &&& 31#64).toNat = x.toNat % 32 := by
    rw [BitVec.toNat_and, show (31#64).toNat = 2 ^ 5 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  rw [e, BitVec.toNat_sub_of_le hle, toNat_and_3, h31]

/-- `^bb23`, the 32-byte chunks copied: the rest by 4-byte vectors and bytes, or none left. -/
theorem chunks_done (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat) (M : MemoryState)
    (w : HashState) (A : AllocState) (hMf : M.HashStateFit st) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (hRlt : R < 128)
    (hn : inlen.toNat < 128 - R) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := A,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get)
    (hR :
      E ⊨ [%1241 := tmp, %1238 := 0#32, %1210 := 0#64, %1229 := 1#64, %1231 := 2#64, %1212 := 3#64,
        %1228 := 4#64, %1235 := 18446744073709551612#64, %1259 := st.add (BitVec.ofNat 64 (80 + R)),
        %1326 := inlen &&& 28#64, %1327 := inlen &&& 18446744073709551584#64])
    (h32 : 32 ≤ inlen.toNat) (hwf : S.WF) (hA : S.alloc = A)
    (hM :
      S.mem =
        M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) (inlen.toNat / 32 * 32))) :
    (crypto_hash_sha512_update.runFrom E 23 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  · have e := congrArg BitVec.toNat hbr
    rw [toNat_and_neg32] at e
    have hM' :
      S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) inlen.toNat) := by
      rw [hM, ← e]
    step_loop using ret_block st inp tmp inlen R M w A g K hK
  · have e : inlen.toNat ≠ inlen.toNat / 32 * 32 := fun e =>
      hbr
        (BitVec.eq_of_toNat_eq
          (by
            rw [toNat_and_neg32]; exact e))
    block_init
    step_pure
    finish_block
    · have e28 := congrArg BitVec.toNat hbr
      rw [toNat_and_28] at e28
      step_loop using
        bytes_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK
          (inlen.toNat / 32 * 32)
      all_goals
        first
        | omega
        | ( apply BitVec.eq_of_toNat_eq
            rw [toNat_and_neg32, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)])
    · have e28 : inlen.toNat % 32 - inlen.toNat % 4 ≠ 0 := fun e =>
        hbr
          (BitVec.eq_of_toNat_eq
            (by
              rw [toNat_and_28]; exact e))
      step_loop using
        word_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK (inlen.toNat / 32 * 32)
      all_goals
        first
        | omega
        | ( apply BitVec.eq_of_toNat_eq
            rw [toNat_and_neg32, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)])

end Short

open Short in
/-- `for (i = 0; i < inlen; i++) { state->buf[r + i] = in[i]; } return 0;`, every vectorized path
and either outcome of the alias check. -/
public theorem short_block (st inp tmp : Pointer) (inlen : BitVec 64) (R : Nat)
    (ain ast : BitVec 64) (M : MemoryState) (w : HashState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value inp) (.value inlen)).get) (hC : ConstsShort E)
    (hR :
      E ⊨ [%1211 := 64#64, %1239 := ain, %1240 := ast, %1241 := tmp, %1247 := BitVec.ofNat 64 R,
        %1259 := st.add (BitVec.ofNat 64 (80 + R))])
    (hRlt : R < 128) (hn : inlen.toNat < 128 - R) (h0 : inlen ≠ 0#64) (hwf : S.WF)
    (hM : S.mem = M.storeHashState st w) (hMf : M.HashStateFit st)
    (hin : Fits M inp (8 * inlen.toNat)) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := S.alloc,
                mem :=
                  (M.storeHashState st
                        (w.fill (BitVec.ofNat 64 R) (M.readAt inp (8 * inlen.toNat)))).lifetimeEnd
                    tmp }) >>=
          g) =
        K) :
    (crypto_hash_sha512_update.runFrom E 17 S >>= g) = K := by
  have hl0 : inlen.toNat ≠ 0 := fun h => h0 (BitVec.eq_of_toNat_eq (by simpa using h))
  rw [← filled_zero w R (M.readAt inp (8 * inlen.toNat))] at hM
  generalize hA : S.alloc = A at hK
  block_init
  step_pure
  finish_block
  · -- inlen < 4
    step_loop using bytes_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK 0
  · have h4 : 4 ≤ inlen.toNat := by simpa [BitVec.ult] using hbr
    block_init
    iterate 4 step_pure
    finish_block
    · -- the alias check: `buf + r` within 31 bytes past `in`
      step_loop using bytes_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK 0
    · block_init
      step_pure
      finish_block
      · step_loop using word_entry st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK 0
      · have h32 : 32 ≤ inlen.toNat := by simpa [BitVec.ult] using hbr
        obtain ⟨hf0, hr0⟩ := inp_chunk (i := 0) (c := 16) (w := 128) hM hsep hin hino rfl (by omega)
        obtain ⟨hf1, hr1⟩ :=
          inp_chunk (i := 16) (c := 16) (w := 128) hM hsep hin hino rfl (by omega)
        obtain ⟨ho0, hb0⟩ := buf_ptr (R := R) (i := 0) (c := 16) (w := 128) hM hMf rfl (by omega)
        obtain ⟨ho1, hb1⟩ := buf_ptr (R := R) (i := 16) (c := 16) (w := 128) hM hMf rfl (by omega)
        simp only [Pointer.add_zero] at hf0 hr0 hb0 ho0
        block_init
        step_pure
        step_pure
        step_pure
        step_load consuming hf0 hr0
        step_load consuming hf1 hr1
        step_pure
        step_store consuming hb0 ho0
        step_store consuming hb1 ho1
        have hM32 :
          S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) 32) := by
          rw [hS, hM, packLanes_ofFn_extractVecElem,
            store_chunk0 (c := 16) (wd := 128) hMf rfl (by omega), packLanes_ofFn_extractVecElem,
            store_chunk (k := 16) (c := 16) (wd := 128) hMf rfl (by omega) rfl]
        have hn32 := toNat_and_neg32 inlen
        step_pure
        finish_block
        · have e := congrArg BitVec.toNat hbr
          simp only [hn32, BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod] at e
          have hM' :
            S.mem =
              M.storeHashState st
                (filled w R (M.readAt inp (8 * inlen.toNat)) (inlen.toNat / 32 * 32)) := by
            rw [hM32, e]
          step_loop using chunks_done st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK
        · have e : inlen.toNat / 32 * 32 ≠ 32 := fun e =>
            hbr
              (BitVec.eq_of_toNat_eq
                (by
                  rw [hn32, e]; rfl))
          have h64 : 64 ≤ inlen.toNat := by omega
          obtain ⟨hf2, hr2⟩ :=
            inp_chunk (i := 32) (c := 16) (w := 128) hM32 hsep hin hino rfl (by omega)
          obtain ⟨hf3, hr3⟩ :=
            inp_chunk (i := 48) (c := 16) (w := 128) hM32 hsep hin hino rfl (by omega)
          obtain ⟨ho2, hb2⟩ :=
            buf_ptr (R := R) (i := 32) (c := 16) (w := 128) hM32 hMf rfl (by omega)
          obtain ⟨ho3, hb3⟩ :=
            buf_ptr (R := R) (i := 48) (c := 16) (w := 128) hM32 hMf rfl (by omega)
          block_init
          step_pure
          step_pure
          step_load consuming hf2 hr2
          step_load consuming hf3 hr3
          step_pure
          step_pure
          step_store consuming hb2 ho2
          step_store consuming hb3 ho3
          step_pure
          finish_block
          all_goals
            have hM64 :
              S.mem = M.storeHashState st (filled w R (M.readAt inp (8 * inlen.toNat)) 64) := by
              rw [hS, hM, packLanes_ofFn_extractVecElem,
                store_chunk0 (c := 16) (wd := 128) hMf rfl (by omega),
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 16) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 32) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 48) (c := 16) (wd := 128) hMf rfl (by omega) rfl]
          · have e := congrArg BitVec.toNat hbr
            simp only [hn32, BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod] at e
            have hM' :
              S.mem =
                M.storeHashState st
                  (filled w R (M.readAt inp (8 * inlen.toNat)) (inlen.toNat / 32 * 32)) := by
              rw [hM64, e]
            step_loop using chunks_done st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK
          · have e' : inlen.toNat / 32 * 32 ≠ 64 := fun e' =>
              hbr
                (BitVec.eq_of_toNat_eq
                  (by
                    rw [hn32, e']; rfl))
            have h96 : 96 ≤ inlen.toNat := by omega
            obtain ⟨hf4, hr4⟩ :=
              inp_chunk (i := 64) (c := 16) (w := 128) hM64 hsep hin hino rfl (by omega)
            obtain ⟨hf5, hr5⟩ :=
              inp_chunk (i := 80) (c := 16) (w := 128) hM64 hsep hin hino rfl (by omega)
            obtain ⟨ho4, hb4⟩ :=
              buf_ptr (R := R) (i := 64) (c := 16) (w := 128) hM64 hMf rfl (by omega)
            obtain ⟨ho5, hb5⟩ :=
              buf_ptr (R := R) (i := 80) (c := 16) (w := 128) hM64 hMf rfl (by omega)
            block_init
            step_pure
            step_pure
            step_load consuming hf4 hr4
            step_load consuming hf5 hr5
            step_pure
            step_pure
            step_store consuming hb4 ho4
            step_store consuming hb5 ho5
            finish_block
            have hM' :
              S.mem =
                M.storeHashState st
                  (filled w R (M.readAt inp (8 * inlen.toNat)) (inlen.toNat / 32 * 32)) := by
              rw [hS, hM, packLanes_ofFn_extractVecElem,
                store_chunk0 (c := 16) (wd := 128) hMf rfl (by omega),
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 16) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 32) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 48) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 64) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                packLanes_ofFn_extractVecElem,
                store_chunk (k := 80) (c := 16) (wd := 128) hMf rfl (by omega) rfl,
                show inlen.toNat / 32 * 32 = 96 by omega]
            step_loop using chunks_done st inp tmp inlen R M w A hMf hin hino hsep hRlt hn g K hK

end MLIR.Sodium.crypto_hash_sha512_update

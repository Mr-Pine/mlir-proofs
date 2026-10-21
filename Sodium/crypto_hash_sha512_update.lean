module

public import MLIR.Run.Tactic
public import Sodium.Common.Sha512
public import Sodium.Common.Counter
public import Sodium.SHA512_Transform
public import Sodium.sodium_memzero
public import Sodium.Update.Short
public import Sodium.Update.Fill
public import Sodium.Update.Tail
public import Sodium.Mlir.crypto_hash_sha512_update
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

namespace crypto_hash_sha512_update

/-- `count[1] += inlen << 3`, carrying into `count[0] += inlen >> 61`. -/
def counted (v : HashState) (inlen : BitVec 64) : HashState :=
  { { v with count1 := v.count1 + inlen <<< 3 } with
    count0 :=
      v.count0 + BitVec.setWidth 64 (BitVec.ofBool ((v.count1 + inlen <<< 3).ult (inlen <<< 3))) +
        inlen >>> 61 }

/-- `SHA512_Transform(state, in, …); in += 128;` `k` times from byte `a` of `D`. -/
def blocks (h : Vector (BitVec 64) 8) (D : BitVec n) (a : Nat) : Nat → Vector (BitVec 64) 8
  | 0 => h
  | k + 1 => blocks (SHA512_Transform.spec h (D.extractLsb' (8 * a) 1024)) D (a + 128) k

end crypto_hash_sha512_update

open crypto_hash_sha512_update in
/-- The struct after appending the `inlen` bytes `D`: counted, buffered up to a block's end, whole
blocks compressed, the rest buffered. -/
def crypto_hash_sha512_update.spec (v : HashState) (inlen : BitVec 64)
    (D : BitVec (8 * inlen.toNat)) : HashState :=
  if inlen = 0#64 then v
  else
    let r := v.count1.toNat / 8 % 128
    let u := counted v inlen
    if inlen.toNat < 128 - r then u.fill (BitVec.ofNat 64 r) D
    else
      let u := u.fill (BitVec.ofNat 64 r) (D.setWidth (8 * (128 - r)))
      let m := inlen.toNat - (128 - r)
      let u :=
        { u with state := blocks (SHA512_Transform.spec u.state u.buf) D (128 - r) (m / 128) }
      if m % 128 = 0 then u
      else u.fill 0#64 (D.extractLsb' (8 * (128 - r + 128 * (m / 128))) (8 * (m % 128)))

end

/-! ## Proof -/

section Proof

namespace crypto_hash_sha512_update

theorem and127 (n : Nat) : n &&& 127 = n % 128 := by
  rw [show (127 : Nat) = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

/-- `r`, as the steps compute it. -/
theorem r_eq (x : BitVec 64) : x >>> 3 &&& 127#64 = BitVec.ofNat 64 (x.toNat / 8 % 128) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_ushiftRight, BitVec.toNat_ofNat,
    Nat.shiftRight_eq_div_pow]
  rw [show (127 : Nat) % 2 ^ 64 = 127 from rfl, and127]
  omega

theorem rNat_eq (x : BitVec 64) : x.toNat >>> 3 &&& 127 = x.toNat / 8 % 128 := by
  rw [Nat.shiftRight_eq_div_pow, and127]

/-! `c - r` for `r ≤ c < 2 ^ 63`, as a 64-bit subtraction. -/

theorem ssubOverflow_ofNat64 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 63) :
    (BitVec.ofNat 64 c).ssubOverflow (BitVec.ofNat 64 R) = false := by
  have h1 : (BitVec.ofNat 64 c).toInt = c := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 R).toInt = R := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.ssubOverflow, h1, h2]
  omega

theorem usubOverflow_ofNat64 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 63) :
    (BitVec.ofNat 64 c).usubOverflow (BitVec.ofNat 64 R) = false := by
  simp [BitVec.usubOverflow]
  omega

theorem sub_ofNat64 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 63) :
    BitVec.ofNat 64 c - BitVec.ofNat 64 R = BitVec.ofNat 64 (c - R) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)]
  simp
  omega

theorem sub_ofNat_toNat {x : BitVec 64} {c : Nat} (h : c ≤ x.toNat) :
    x - BitVec.ofNat 64 c = BitVec.ofNat 64 (x.toNat - c) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)]
  simp
  omega

theorem add_neg128 {x : Nat} (h : 128 ≤ x) :
    BitVec.ofNat 64 x + 18446744073709551488#64 = BitVec.ofNat 64 (x - 128) := by
  have e : BitVec.ofNat 64 x = BitVec.ofNat 64 (x - 128) + 128#64 := by
    rw [show (128#64) = BitVec.ofNat 64 128 from rfl, ← BitVec.ofNat_add, Nat.sub_add_cancel h]
  rw [e]
  generalize BitVec.ofNat 64 (x - 128) = y
  bv_decide

/-- Block `a` of the input, past `tmp64` and the struct. -/
theorem block_read {M : MemoryState} {st inp tmp : Pointer} {inlen : BitVec 64}
    {D : BitVec (8 * inlen.toNat)} {X : BitVec 5632} {w : HashState} {a : Nat}
    (hD : M.readAt inp (8 * inlen.toNat) = D) (hin : Fits M inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id) (htmpin : tmp.id ≠ inp.id)
    (ha : a + 128 ≤ inlen.toNat) :
    ((M.storeAt tmp X).storeHashState st w).readAt (inp.add (BitVec.ofNat 64 a)) 1024 =
      D.extractLsb' (8 * a) 1024 := by
  have hino' : inp.offset.toNat + inlen.toNat < 2 ^ 64 := by simpa [BitVec.uaddOverflow] using hino
  have hova : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 a) := by
    simp [BitVec.uaddOverflow]; rw [Nat.mod_eq_of_lt (by omega)]; omega
  rw [MemoryState.readAt_storeHashState_of_id_ne (q := inp.add (BitVec.ofNat 64 a)) hsep,
    MemoryState.readAt_storeAt_disjoint (q := inp.add (BitVec.ofNat 64 a))
      (Range.disjoint_of_id_ne htmpin),
    MemoryState.readAt_add_of_readAt hin.inBounds hova
      (by
        simp; rw [Nat.mod_eq_of_lt (by omega)]; omega)
      hD,
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega), Nat.mul_comm a 8]

/-- A compressed block's state words, over the struct, `tmp64` overwritten. -/
theorem transform_merge {M : MemoryState} {st tmp : Pointer} {X Y : BitVec 5632} {w : HashState}
    {h : Vector (BitVec 64) 8} (hsto : ¬st.offset.uaddOverflow 208#64) (htmpst : tmp.id ≠ st.id) :
    (((M.storeAt tmp X).storeHashState st w).storeAt tmp Y).storeWords8 st h =
      (M.storeAt tmp Y).storeHashState st { w with state := h } := by
  rw [MemoryState.storeHashState_storeAt_comm htmpst, MemoryState.storeAt_storeAt_self,
    MemoryState.storeHashState_storeWords8 hsto]

/-- `while (inlen >= 128) { SHA512_Transform(state->state, in, …); in += 128; inlen -= 128; }`
from byte `a`, `j + 1` blocks left. -/
theorem blocks_loop (st inp tmp : Pointer) (inlen ast : BitVec 64) (M : MemoryState)
    (D : BitVec (8 * inlen.toNat)) (hD : M.readAt inp (8 * inlen.toNat) = D)
    (hin : Fits M inp (8 * inlen.toNat)) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) (hgM : M.Globals crypto_hash_sha512_update.globals)
    (hMf : M.HashStateFit st) (htmp : Room M tmp 5632)
    (htmpo : ¬tmp.offset.uaddOverflow 704#64) (htmpst : tmp.id ≠ st.id) (htmpin : tmp.id ≠ inp.id)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ j a (w : HashState) (X : BitVec 5632) (S : GlobalState) (E : ⟪Γ⟫),
      a + 128 * j + 128 ≤ inlen.toNat →
        inlen.toNat < a + 128 * j + 256 →
        E.args = (args (.value st) (.value inp) (.value inlen)).get →
        ConstsBlocks E →
        (E ⊨ [%1240 := ast, %1241 := tmp, %1258 := st.add 80#64, %1407 := tmp.add 640#64, %1493 :=
          inp.add (BitVec.ofNat 64 a), %1494 := BitVec.ofNat 64 (inlen.toNat - a)]) →
        S.WF →
        S.mem = (M.storeAt tmp X).storeHashState st w →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (X' : BitVec 5632),
          E'.args = (args (.value st) (.value inp) (.value inlen)).get →
            ConstsTail E' →
            (E' ⊨ [%1240 := ast, %1241 := tmp, %1258 := st.add 80#64, %1411 :=
              BitVec.ofNat 64 (inlen.toNat - (a + 128 * j + 128)), %1412 :=
              inp.add (BitVec.ofNat 64 (a + 128 * j + 128))]) →
            S'.WF →
            S'.alloc = S.alloc →
            S'.mem =
              (M.storeAt tmp X').storeHashState st { w with state := blocks w.state D a (j + 1) } →
            (crypto_hash_sha512_update.runFrom E' 34 S' >>= g) = K) →
        (crypto_hash_sha512_update.runFrom E 53 S >>= g) = K := by
  intro j
  induction j with
  | zero =>
    intro a w X S E ha1 ha2 hArgs hC hR hwf hM hK
    have hsto := hMf.1
    have hSf : S.mem.HashStateFit st := hM ▸ hMf.storeAt.storeHashState
    have hst512 : Fits S.mem st 512 := hSf.2.2.mono (by decide)
    have hsto64 : ¬st.offset.uaddOverflow 64#64 :=
      Pointer.not_uaddOverflow_of_hashState hsto (by decide)
    have hino' : inp.offset.toNat + inlen.toNat < 18446744073709551616 := by
      simpa [BitVec.uaddOverflow] using hino
    have ha64 : a < 18446744073709551616 := by omega
    have hova : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 a) := by
      simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
      rw [Nat.mod_eq_of_lt ha64]; omega
    have hblk : Fits S.mem (inp.add (BitVec.ofNat 64 a)) 1024 := by
      rw [hM]
      exact
        ((Fits.add_of_le hova
                (by
                  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha64]; omega)
                hin).storeAt).storeHashState
          hsep
    have hblko : ¬(inp.add (BitVec.ofNat 64 a)).offset.uaddOverflow 128#64 := by
      simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
        decide_eq_true_eq, ge_iff_le, Nat.not_le]
      omega
    have htmp' : Room S.mem tmp 5632 := by
      rw [hM]; exact htmp.storeAt.storeHashState
    have hsep' : tmp.id ≠ (inp.add (BitVec.ofNat 64 a)).id := htmpin
    have hg := hblko
    have hgS : S.mem.Globals crypto_hash_sha512_update.globals := by
      rw [hM]; exact hgM.mono rfl fun _ h => h
    block_init
    -- SHA512_Transform(state->state, in, &tmp64[0], &tmp64[80]);
    step_call using SHA512_Transform.call_eq consuming hst512 hsto64 hblk hblko htmp' hsep'
    rw [hM, MemoryState.readWords8_storeHashState hMf.2.1.storeAt hsto,
      block_read hD hin hino hsep htmpin (by omega), transform_merge hsto htmpst] at hS
    clear hread_tmp hSf
    -- in += 128; inlen -= 128;
    step_pure [gep_value hg, Pointer.add_add, ← BitVec.ofNat_add]
    step_pure [add_neg128 (show 128 ≤ inlen.toNat - a by omega)]
    step_pure
    have hc : ¬(127#64).ult (BitVec.ofNat 64 (inlen.toNat - a - 128)) = true := by
      simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
    finish_block
    run_from using hK _ _ (SHA512_Transform.tmp w.state (BitVec.extractLsb' (8 * a) 1024 D))
    rfl
  | succ j ih =>
    intro a w X S E ha1 ha2 hArgs hC hR hwf hM hK
    have hsto := hMf.1
    have hSf : S.mem.HashStateFit st := hM ▸ hMf.storeAt.storeHashState
    have hst512 : Fits S.mem st 512 := hSf.2.2.mono (by decide)
    have hsto64 : ¬st.offset.uaddOverflow 64#64 :=
      Pointer.not_uaddOverflow_of_hashState hsto (by decide)
    have hino' : inp.offset.toNat + inlen.toNat < 18446744073709551616 := by
      simpa [BitVec.uaddOverflow] using hino
    have ha64 : a < 18446744073709551616 := by omega
    have hova : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 a) := by
      simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
      rw [Nat.mod_eq_of_lt ha64]; omega
    have hblk : Fits S.mem (inp.add (BitVec.ofNat 64 a)) 1024 := by
      rw [hM]
      exact
        ((Fits.add_of_le hova
                (by
                  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha64]; omega)
                hin).storeAt).storeHashState
          hsep
    have hblko : ¬(inp.add (BitVec.ofNat 64 a)).offset.uaddOverflow 128#64 := by
      simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
        decide_eq_true_eq, ge_iff_le, Nat.not_le]
      omega
    have htmp' : Room S.mem tmp 5632 := by
      rw [hM]; exact htmp.storeAt.storeHashState
    have hsep' : tmp.id ≠ (inp.add (BitVec.ofNat 64 a)).id := htmpin
    have hg := hblko
    have hgS : S.mem.Globals crypto_hash_sha512_update.globals := by
      rw [hM]; exact hgM.mono rfl fun _ h => h
    block_init
    -- SHA512_Transform(state->state, in, &tmp64[0], &tmp64[80]);
    step_call using SHA512_Transform.call_eq consuming hst512 hsto64 hblk hblko htmp' hsep'
    rw [hM, MemoryState.readWords8_storeHashState hMf.2.1.storeAt hsto,
      block_read hD hin hino hsep htmpin (by omega), transform_merge hsto htmpst] at hS
    clear hread_tmp hSf
    -- in += 128; inlen -= 128;
    step_pure [gep_value hg, Pointer.add_add, ← BitVec.ofNat_add]
    step_pure [add_neg128 (show 128 ≤ inlen.toNat - a by omega)]
    step_pure
    have hc : (127#64).ult (BitVec.ofNat 64 (inlen.toNat - a - 128)) = true := by
      simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
    finish_block
    have hj1 : a + 128 + 128 * j + 128 = a + 128 * (j + 1) + 128 := by omega
    have hj2' : a + 128 + 128 * j + 128 ≤ inlen.toNat := by omega
    have ha2' : inlen.toNat < a + 128 + 128 * j + 256 := by omega
    refine
      ih (a + 128)
        { w with state := SHA512_Transform.spec w.state (BitVec.extractLsb' (8 * a) 1024 D) }
        (SHA512_Transform.tmp w.state (BitVec.extractLsb' (8 * a) 1024 D)) S E hj2' ha2' hArgs
        (by env_reads) ?_ hwf (by rw [hS])
        (fun E' S' X' h1 h2 h3 h4 h5 h6 => hK E' S' X' h1 h2 ?_ h4 ?_ ?_)
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
    · rwa [hj1] at h3
    · rw [h5, hS]
    · rw [h6]
      rfl

end crypto_hash_sha512_update

open crypto_hash_sha512_update in
/-- `crypto_hash_sha512_update(state, in, inlen)` appends the `inlen` bytes at `in` to the struct
(`spec`) and returns `0`. The buffered bytes must be known, `in` must not share the struct's
block. The block counter advances by `tmp64`'s. -/
public theorem crypto_hash_sha512_update.call_eq (st inp : Pointer) (inlen : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals crypto_hash_sha512_update.globals)
    (hst : s.mem.HashStateFit st)
    (hpre : (s.mem.readHashState st).Prefix ((s.mem.readHashState st).count1.toNat / 8 % 128))
    (hin : Fits s.mem inp (8 * inlen.toNat)) (hino : ¬inp.offset.uaddOverflow inlen)
    (hsep : inp.id ≠ st.id) :
    crypto_hash_sha512_update.call
        (crypto_hash_sha512_update.args (.value st) (.value inp) (.value inlen)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeHashState st
                (crypto_hash_sha512_update.spec (s.mem.readHashState st) inlen
                  (s.mem.readAt inp (8 * inlen.toNat))) }) := by
  generalize hD : s.mem.readAt inp (8 * inlen.toNat) = D
  generalize hv : s.mem.readHashState st = v at hpre ⊢
  have hc1 : s.mem.readAt (st.add 72#64) 64 = v.count1 := by
    rw [← hv, MemoryState.readHashState_count1 hst.2.1.inBounds hst.1]
  have hc0 : s.mem.readAt (st.add 64#64) 64 = v.count0 := by
    rw [← hv, MemoryState.readHashState_count0 hst.2.1.inBounds hst.1]
  have hsto := hst.1
  generalize hres : crypto_hash_sha512_update.spec v inlen D = res
  func_init
  have hD₀ : S₀.mem.readAt inp (8 * inlen.toNat) = D := hS ▸ hD
  have hg₀ : S₀.mem.Globals crypto_hash_sha512_update.globals := hS ▸ hg
  clear hD
  block_init
  iterate 30 step_pure
  step_pure with ain
  step_pure with ast
  step_alloca with tmp
  step_lifetime
  step_pure
  finish_block
  · -- if (inlen <= 0U) { return 0; }
    subst hbr
    block_init
    step_lifetime
    finish_block
    subst hS hres
    erase_frame
    simp only [crypto_hash_sha512_update.spec, ↓reduceIte, ← hv,
      MemoryState.storeHashState_readHashState_self ⟨hsto, hst₀, hst₀_1⟩]
    rfl
  · have hne := hbr
    block_init
    iterate 2 step_pure
    -- r = (unsigned long long) ((state->count[1] >> 3) & 0x7f);
    obtain ⟨R, hRe⟩ : ∃ R, v.count1.toNat / 8 % 128 = R := ⟨_, rfl⟩
    have hR : R < 128 := hRe ▸ Nat.mod_lt _ (by decide)
    step_load
    step_pure
    step_pure [r_eq, hRe]
    -- bitlen[1] = ((uint64_t) inlen) << 3; bitlen[0] = ((uint64_t) inlen) >> 61;
    step_pure
    step_pure
    -- if ((state->count[1] += bitlen[1]) < bitlen[1]) { state->count[0]++; }
    step_pure
    step_store
    step_pure
    step_load
    step_pure
    step_pure
    -- state->count[0] += bitlen[0];
    step_pure
    step_store
    step_pure [show (128#64) = BitVec.ofNat 64 128 from rfl,
      ssubOverflow_ofNat64 (show R ≤ 128 by omega) (by decide),
      usubOverflow_ofNat64 (show R ≤ 128 by omega) (by decide),
      sub_ofNat64 (show R ≤ 128 by omega) (by decide)]
    step_pure
    step_pure
    have hg : ¬(st.add 80#64).offset.uaddOverflow (BitVec.ofNat 64 R) :=
      Pointer.not_uaddOverflow_add hsto
        (by
          simp; omega)
    step_pure [rNat_eq, hRe, Nat.mod_eq_of_lt (show R < 18446744073709551616 by omega),
      show R < 18446744073709551616 by omega, gep_value hg, Pointer.add_add, ← BitVec.ofNat_add]
    -- the counts stored into the struct
    have hv₁ : ((S₀.alloca 704 true).mem.lifetimeStart tmp).readHashState st = v := by
      rw [← hv]
      refine MemoryState.readHashState_of_getElem?_eq ?_
      rw [MemoryState.lifetimeStart, MemoryState.getElem?_setLifetime_ne hst_ne_tmp,
        GlobalState.getElem?_alloca]
      rw [GlobalState.allocaPtr_eq_slot, ← htmp]
      exact hst_ne_tmp
    have hm₀ : ((S₀.alloca 704 true).mem.lifetimeStart tmp).HashStateFit st :=
      ⟨hsto, (hst₀.alloca hwf₀).lifetimeStart hst_ne_tmp,
        (hst₀_1.alloca hwf₀).lifetimeStart hst_ne_tmp⟩
    rw [MemoryState.storeAt_count1_eq hm₀, hv₁,
      MemoryState.storeHashState_storeAt_count0 hsto] at hS
    clear hread_st_64 hread_st_72 hfits_st_64 hfits_st_72
    -- the entry memory past `tmp64`'s block
    have hM₀ : ((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * inlen.toNat) = D := by
      rw [MemoryState.readAt_lifetimeStart, MemoryState.readAt_alloca hwf₀ hin₀.inBounds, hD₀]
    have hinM : Fits ((S₀.alloca 704 true).mem.lifetimeStart tmp) inp (8 * inlen.toNat) :=
      (hin₀.alloca hwf₀).lifetimeStart hinp_ne_tmp
    finish_block
    · -- if (inlen < 128 - r): buffer them
      have hn : inlen.toNat < 128 - R := by
        simpa [BitVec.ult, Nat.mod_eq_of_lt (show 128 - R < 18446744073709551616 by omega)] using
          hbr
      refine
        short_block st inp tmp inlen R ain ast ((S₀.alloca 704 true).mem.lifetimeStart tmp)
          (counted v inlen) S E hArgs (by env_reads) (by env_reads) hR hn hne hwf
          (by
            rw [hS]; rfl)
          hm₀ hinM hino hsep _ _ ?_
      subst hres
      rw [hM₀, hS]
      simp only [crypto_hash_sha512_update.spec, hne, hRe, hn, ↓reduceIte]
      have htid : S₀.alloc.nextFreeBlock ≤ tmp.id.id := by
        rw [htmp]; exact Nat.le_refl _
      simp only [PoisonOr.value_bind, MemoryState.eraseFrom_lifetimeEnd_of_le htid,
        MemoryState.eraseFrom_storeHashState, MemoryState.eraseFrom_lifetimeStart_of_le htid,
        GlobalState.eraseFrom_alloca, GlobalState.WF.eraseFrom hwf₀]
      rfl
    · -- the buffered block filled
      have hn : 128 - R ≤ inlen.toNat := by
        simp [BitVec.ult, Nat.mod_eq_of_lt (show 128 - R < 18446744073709551616 by omega)] at hbr
        omega
      have hinM' : Fits ((S₀.alloca 704 true).mem.lifetimeStart tmp) inp (8 * (128 - R)) :=
        hinM.mono (by omega)
      have hA0 : S.alloc = (S₀.alloca 704 true).alloc := by rw [hS]
      refine
        fill_block st inp tmp inlen R ain ast v.count1 ((S₀.alloca 704 true).mem.lifetimeStart tmp)
          (counted v inlen) S E hArgs (by env_reads) (by env_reads) hRe hR hn hwf
          (by
            rw [hS]; rfl)
          hm₀ hinM' hino hsep _ _ ?_
      intro E S hArgs hC hR' hwf hSa hM
      -- SHA512_Transform(state->state, state->buf, &tmp64[0], &tmp64[80]);
      have hfull :
        ((counted v inlen).fill (BitVec.ofNat 64 R)
              (((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * (128 - R)))).Prefix
          128 := by
        have :=
          (show (counted v inlen).Prefix R from hRe ▸ hpre).fill (off := BitVec.ofNat 64 R)
            (by
              simp; omega)
            (((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * (128 - R))) (j := 128 - R)
            rfl (by omega)
        rwa [show R + (128 - R) = 128 by omega] at this
      have hSf : S.mem.HashStateFit st := hM ▸ hm₀.storeHashState
      have hst512 : Fits S.mem st 512 := hSf.2.2.mono (by decide)
      have hsto64 : ¬st.offset.uaddOverflow 64#64 :=
        Pointer.not_uaddOverflow_of_hashState hsto (by decide)
      have hbuf : Fits S.mem (st.add 80#64) 1024 := by
        rw [hM]; exact Fits.storeHashState_buf hm₀.2.1 hsto (by decide) hfull
      have hbufo : ¬(st.add 80#64).offset.uaddOverflow 128#64 :=
        Pointer.not_uaddOverflow_add hsto (by decide)
      have htmpR : Room ((S₀.alloca 704 true).mem.lifetimeStart tmp) tmp 5632 := by
        rw [htmp, ← GlobalState.allocaPtr_eq_slot]
        exact Room.lifetimeStart_self InBounds.allocaPtr_self Writable.allocaPtr_self
      have htmpS : Room S.mem tmp 5632 := by
        rw [hM]; exact htmpR.storeHashState
      have htmpo : ¬tmp.offset.uaddOverflow 704#64 := by
        rw [htmp_off]; decide
      have hsep' : tmp.id ≠ (st.add 80#64).id := Ne.symm hst_ne_tmp
      have hgS : S.mem.Globals crypto_hash_sha512_update.globals := by
        rw [hM]; exact hg₀.mono rfl fun _ h => h
      block_init
      step_pure
      step_call using SHA512_Transform.call_eq consuming hst512 hsto64 hbuf hbufo htmpS hsep'
      rw [hM, MemoryState.readWords8_storeHashState hm₀.2.1 hsto,
        MemoryState.readAt_storeHashState_buf hm₀.2.1 hsto,
        MemoryState.storeHashState_storeAt_comm (Ne.symm hst_ne_tmp),
        MemoryState.storeHashState_storeWords8 hsto] at hS
      clear hread_tmp hSf
      have hino' : inp.offset.toNat + inlen.toNat < 18446744073709551616 := by
        simpa [BitVec.uaddOverflow] using hino
      have hga : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 (128 - R)) := by
        simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
          Nat.not_le]
        rw [Nat.mod_eq_of_lt (by omega)]; omega
      -- in += 128 - r; inlen -= 128 - r;
      step_pure [gep_value hga, Nat.mod_eq_of_lt (show 128 - R < 18446744073709551616 by omega),
        show 128 - R < 18446744073709551616 by omega]
      step_pure [sub_ofNat_toNat hn]
      step_pure
      have hD₁ : ((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * inlen.toNat) = D :=
        hM₀
      have htmpin : tmp.id ≠ inp.id := Ne.symm hinp_ne_tmp
      finish_block
      · -- while (inlen >= 128) …
        have hm : 127 < inlen.toNat - (128 - R) := by
          simp [BitVec.ult] at hbr; rw [Nat.mod_eq_of_lt (by omega)] at hbr; omega
        obtain ⟨j, hj⟩ : ∃ j, (inlen.toNat - (128 - R)) / 128 = j + 1 :=
          ⟨(inlen.toNat - (128 - R)) / 128 - 1, by omega⟩
        have hj1 : 128 - R + 128 * j + 128 ≤ inlen.toNat := by omega
        have hj2 : inlen.toNat < 128 - R + 128 * j + 256 := by omega
        refine
          blocks_loop st inp tmp inlen ast ((S₀.alloca 704 true).mem.lifetimeStart tmp) D hD₁ hinM
            hino hsep (by mem_fact) hm₀ htmpR htmpo (Ne.symm hst_ne_tmp) htmpin _ _ j (128 - R) _ _
            S E hj1 hj2 hArgs (by env_reads) ?_ hwf (by rw [hS]) ?_
        · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
        intro E S X' hArgs hC hR hwf hSb hM
        have hm' : inlen.toNat - (128 - R + 128 * j + 128) < 128 := by omega
        have hga' : ¬inp.offset.uaddOverflow (BitVec.ofNat 64 (128 - R + 128 * j + 128)) := by
          simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
            Nat.not_le]
          rw [Nat.mod_eq_of_lt (by omega)]; omega
        refine
          tail_block st inp tmp (inp.add (BitVec.ofNat 64 (128 - R + 128 * j + 128))) inlen
            (inlen.toNat - (128 - R + 128 * j + 128)) ast _ _ S E hArgs (by env_reads)
            (by env_reads) hm' hwf hM hm₀.storeAt ?_ ?_ hsep htmpR.storeAt _ _ ?_
        · exact
            (Fits.add_of_le hga'
                (by
                  simp; rw [Nat.mod_eq_of_lt (by omega)]; omega)
                hinM).storeAt
        · simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
            decide_eq_true_eq, ge_iff_le, Nat.not_le]
          omega
        · have htid : S₀.alloc.nextFreeBlock ≤ tmp.id.id := by
            rw [htmp]; exact Nat.le_refl _
          simp only [PoisonOr.value_bind, MemoryState.eraseFrom_lifetimeEnd_of_le htid,
            MemoryState.eraseFrom_storeAt_of_le htid, MemoryState.eraseFrom_storeHashState,
            MemoryState.eraseFrom_lifetimeStart_of_le htid, GlobalState.eraseFrom_alloca,
            GlobalState.WF.eraseFrom hwf₀]
          have hr1 :
            ((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * (128 - R)) =
              D.setWidth (8 * (128 - R)) :=
            MemoryState.readAt_of_readAt_le (by omega) hD₁
          rw [hr1,
            MemoryState.readAt_storeAt_disjoint (q :=
              inp.add (BitVec.ofNat 64 (128 - R + 128 * j + 128))) (Range.disjoint_of_id_ne htmpin),
            MemoryState.readAt_add_of_readAt hinM.inBounds hga'
              (by
                simp; rw [Nat.mod_eq_of_lt (by omega)]; omega)
              hD₁,
            BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show 128 - R + 128 * j + 128 < 2 ^ 64 by omega),
            Nat.mul_comm _ 8]
          have hSa' : S.alloc = ⟨S₀.alloc.nextFreeBlock + 1⟩ := by
            rw [hSb, hS]
            simp only [hSa, hA0, GlobalState.alloca]
          have hmod :
            (inlen.toNat - (128 - R)) % 128 = inlen.toNat - (128 - R + 128 * j + 128) := by omega
          have hoff : 128 - R + 128 * (j + 1) = 128 - R + 128 * j + 128 := by omega
          subst hres
          simp only [crypto_hash_sha512_update.spec, hne, hRe, show ¬inlen.toNat < 128 - R by omega,
            ↓reduceIte]
          rw [hRe, hj, hmod, hoff, hSa']
      · -- the rest buffered
        have hm : inlen.toNat - (128 - R) < 128 := by
          simp [BitVec.ult] at hbr; rw [Nat.mod_eq_of_lt (by omega)] at hbr; omega
        refine
          tail_block st inp tmp (inp.add (BitVec.ofNat 64 (128 - R))) inlen
            (inlen.toNat - (128 - R)) ast _ _ S E hArgs (by env_reads) (by env_reads) hm hwf
            (by rw [hS]) hm₀.storeAt ?_ ?_ hsep htmpR.storeAt _ _ ?_
        · exact
            (Fits.add_of_le hga
                (by
                  simp; rw [Nat.mod_eq_of_lt (by omega)]; omega)
                hinM).storeAt
        · simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
            decide_eq_true_eq, ge_iff_le, Nat.not_le]
          omega
        · have htid : S₀.alloc.nextFreeBlock ≤ tmp.id.id := by
            rw [htmp]; exact Nat.le_refl _
          simp only [PoisonOr.value_bind, MemoryState.eraseFrom_lifetimeEnd_of_le htid,
            MemoryState.eraseFrom_storeAt_of_le htid, MemoryState.eraseFrom_storeHashState,
            MemoryState.eraseFrom_lifetimeStart_of_le htid, GlobalState.eraseFrom_alloca,
            GlobalState.WF.eraseFrom hwf₀]
          have hr1 :
            ((S₀.alloca 704 true).mem.lifetimeStart tmp).readAt inp (8 * (128 - R)) =
              D.setWidth (8 * (128 - R)) :=
            MemoryState.readAt_of_readAt_le (by omega) hD₁
          have hr2 :
            (((S₀.alloca 704 true).mem.lifetimeStart tmp).storeAt tmp
                    (SHA512_Transform.tmp
                      ((counted v inlen).fill (BitVec.ofNat 64 R)
                          (D.setWidth (8 * (128 - R)))).state
                      ((counted v inlen).fill (BitVec.ofNat 64 R)
                          (D.setWidth (8 * (128 - R)))).buf)).readAt
                (inp.add (BitVec.ofNat 64 (128 - R))) (8 * (inlen.toNat - (128 - R))) =
              D.extractLsb' (8 * (128 - R)) (8 * (inlen.toNat - (128 - R))) := by
            rw [MemoryState.readAt_storeAt_disjoint (q := inp.add (BitVec.ofNat 64 (128 - R)))
                (Range.disjoint_of_id_ne htmpin),
              MemoryState.readAt_add_of_readAt hinM.inBounds hga
                (by
                  simp; rw [Nat.mod_eq_of_lt (by omega)]; omega)
                hD₁,
              BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega), Nat.mul_comm (128 - R) 8]
          have hSa' : S.alloc = ⟨S₀.alloc.nextFreeBlock + 1⟩ := by
            rw [hS]
            simp only [hSa, hA0, GlobalState.alloca]
          subst hres
          rw [hr1, hr2]
          simp only [crypto_hash_sha512_update.spec, hne, hRe, show ¬inlen.toNat < 128 - R by omega,
            ↓reduceIte, Nat.div_eq_of_lt hm, Nat.mod_eq_of_lt hm, blocks, Nat.mul_zero,
            Nat.add_zero]
          rw [hRe, Nat.mod_eq_of_lt hm, hSa']

end Proof

end MLIR.Sodium

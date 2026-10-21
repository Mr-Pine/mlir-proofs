module

public import MLIR.Run.Tactic
public import Boringssl.Common.Sha512
public import Boringssl.OPENSSL_memset
public import Boringssl.CRYPTO_store_u64_be
public import Boringssl.FIPS_service_indicator_update_state
public import Boringssl.sha512_block_data_order
public import Boringssl.Mlir.sha512_final_impl
import Std.Tactic.BVDecide

namespace MLIR.Boringssl

open Memory

/-! ## Specification -/

@[expose] public section

namespace sha512_final_impl

/-- `OPENSSL_memset(p + n, 0, sizeof(sha->p) - 16 - n)`, the bit count's two words big-endian
(`CRYPTO_store_u64_be`), then the block compressed into `h`. -/
def last (v : Sha512Ctx) (n : BitVec 64) : Sha512Ctx :=
  let v := v.fill n ((0#8).replicate (112#64 - n).toNat)
  let Nh := v.hi.setWidth 64 <<< 3 ||| v.lo >>> 61
  let Nl := v.lo <<< 3
  let v := v.fill 112#64 (Firedancer.Ref.fd_ulong_bswap.spec Nh)
  let v := v.fill 120#64 (Firedancer.Ref.fd_ulong_bswap.spec Nl)
  { v with h := Firedancer.Ref.fd_sha512_core_ref.spec (n := 1) v.h v.p }

/-- How many `sha512_block_data_order` calls `final` makes. -/
def cores (v : Sha512Ctx) : Nat :=
  if (112#64).ult (v.num.setWidth 64 + 1#64) then 2 else 1

end sha512_final_impl

open sha512_final_impl in
/-- The struct after the padding and the last block (or two). -/
def sha512_final_impl.spec (v : Sha512Ctx) : Sha512Ctx :=
  let n := v.num.setWidth 64
  let v := v.fill n 0x80#8
  let n := n + 1#64
  if (112#64).ult n then
    let v := v.fill n ((0#8).replicate (128#64 - n).toNat)
    last { v with h := Firedancer.Ref.fd_sha512_core_ref.spec (n := 1) v.h v.p } 0#64
  else last v n

end

/-! ## Proof -/

section Proof

namespace sha512_final_impl

theorem saddOverflow_num_one (x : BitVec 16) : (x.setWidth 64).saddOverflow 1#64 = false := by
  bv_decide

theorem uaddOverflow_num_one (x : BitVec 16) : (x.setWidth 64).uaddOverflow 1#64 = false := by
  bv_decide

theorem toNat_num_add_one (x : BitVec 16) : (x.setWidth 64 + 1#64).toNat = x.toNat + 1 := by
  rw [BitVec.toNat_add]
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  have := x.isLt
  omega

theorem ssubOverflow_127 {x : BitVec 16} (h : x.toNat < 128) :
    (127#64).ssubOverflow (x.setWidth 64) = false := by
  have : x < 128#16 := by simpa [BitVec.lt_def] using h
  bv_decide

/-- `llvm.fshl(a, b, 3)`, the bit count's high word. -/
theorem fshl_3 (a b : BitVec 64) : ((a ++ b) <<< 3).extractLsb' 64 64 = a <<< 3 ||| b >>> 61 := by
  bv_decide

/-- The words `w 0, …, w (i - 1)` stored at `out`, 8 bytes apart. -/
def storeOut (m : MemoryState) (out : Pointer) (w : Nat → BitVec 64) : Nat → MemoryState
  | 0 => m
  | i + 1 => (storeOut m out w i).storeAt (out.add (BitVec.ofNat 64 (8 * i))) (w i)

theorem readAt_storeOut_of_id_ne {m : MemoryState} (h : q.id ≠ out.id) :
    ∀ i, (storeOut m out w i).readAt q v = m.readAt q v
  | 0 => rfl
  | i + 1 => by
    rw [storeOut,
      MemoryState.readAt_storeAt_disjoint (p := out.add _) (Range.disjoint_of_id_ne h.symm),
      readAt_storeOut_of_id_ne h i]

theorem Fits.storeOut {m : MemoryState} (h : Fits m q v) : ∀ i, Fits (storeOut m out w i) q v
  | 0 => h
  | i + 1 => (Fits.storeOut h i).storeAt

theorem Room.storeOut {m : MemoryState} (h : Room m q v) : ∀ i, Room (storeOut m out w i) q v
  | 0 => h
  | i + 1 => (Room.storeOut h i).storeAt

theorem GlobalState.WF.storeOut {s : GlobalState} (h : s.WF) :
    ∀ i, ({ alloc := s.alloc, mem := storeOut s.mem out w i } : GlobalState).WF
  | 0 => h
  | i + 1 => (GlobalState.WF.storeOut h i).storeAt

/-- The eight words stored by the loop: `storeWords8`. -/
theorem storeOut_eight (m : MemoryState) (out : Pointer) (H : Vector (BitVec 64) 8) :
    storeOut m out (fun k => Firedancer.Ref.fd_ulong_bswap.spec H[k]!) 8 =
      m.storeWords8 out (H.map Firedancer.Ref.fd_ulong_bswap.spec) := by
  simp [storeOut, MemoryState.storeWords8]

/-- The state words of a stored struct, at the offsets the loop reads them. -/
theorem readAt_storeShaCtx_h {m : MemoryState} (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) {k : Nat} (hk : k < 8) :
    (m.storeShaCtx c v).readAt (c.add (BitVec.ofNat 64 (k * 8))) 64 = v.h[k]! := by
  have hw := MemoryState.readWords8_storeShaCtx (v := v) hm hc
  rw [← hw]
  rcases k with _ | _ | _ | _ | _ | _ | _ | _ | k
  all_goals
    first
    | omega
    | simp [MemoryState.readWords8]

/-- The words of a struct that fits, at the offsets the loop reads them. -/
theorem fits_h {m : MemoryState} (h : m.Words8Fit c) {k : Nat} (hk : k < 8) :
    Fits m (c.add (BitVec.ofNat 64 (k * 8))) 64 := by
  obtain ⟨-, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  rcases k with _ | _ | _ | _ | _ | _ | _ | _ | k
  all_goals
    first
    | omega
    | simpa

/-- Room for the hash words, at the offsets the loop stores them. -/
theorem room_out {m : MemoryState} (h : m.Words8Room out) {k : Nat} (hk : k < 8) :
    Room m (out.add (BitVec.ofNat 64 (8 * k))) 64 := by
  obtain ⟨-, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  rcases k with _ | _ | _ | _ | _ | _ | _ | _ | k
  all_goals
    first
    | omega
    | simpa

/-- `^bb4`, the loop storing the hash words from `i`. -/
abbrev hdr4 (out : Pointer) (i : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%138 := .value 1#64, %168 := .value 8#64, %170 := .value (BitVec.ofNat 64 i), %171 :=
    .value (out.add (BitVec.ofNat 64 (8 * i)))]

/-- The loop from word `i`, `m + 1` words left, then `FIPS_service_indicator_update_state()`. -/
theorem out_loop (out c : Pointer) (M' : MemoryState) (H : Nat → BitVec 64)
    (hH : ∀ k, k < 8 → M'.readAt (c.add (BitVec.ofNat 64 (k * 8))) 64 = H k)
    (hfit : ∀ k, k < 8 → Fits M' (c.add (BitVec.ofNat 64 (k * 8))) 64)
    (hco : ¬c.offset.uaddOverflow 208#64) (hoo : ¬out.offset.uaddOverflow 64#64)
    (hsep : out.id ≠ c.id) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      i + m + 1 = 8 →
        E.args = (sha512_final_impl.args (.value out) (.value 64#64) (.value c)).get →
        S.WF →
        S.mem = storeOut M' out (fun k => Firedancer.Ref.fd_ulong_bswap.spec (H k)) i →
        (∀ k, i ≤ k → k < 8 → Room S.mem (out.add (BitVec.ofNat 64 (8 * k))) 64) →
        (PoisonOr.value
              (.nil,
                { alloc := ⟨S.alloc.nextFreeBlock + (m + 1)⟩,
                  mem :=
                    storeOut M' out (fun k => Firedancer.Ref.fd_ulong_bswap.spec (H k)) 8 }) >>=
            g) =
          K →
        (sha512_final_impl.runFrom (hdr4 out i E) 4 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hwf hSm hroom hK
    have hi8 : i < 8 := by omega
    have hiN : (BitVec.ofNat 64 i).toNat = i := by
      simp; omega
    have hlt : i * 8 < 18446744073709551616 := by omega
    have hgo : ¬c.offset.uaddOverflow (BitVec.ofNat 64 (i * 8)) :=
      Pointer.not_uaddOverflow_of_ctx hco
        (by
          simp; omega)
    have hld : Fits S.mem (c.add (BitVec.ofNat 64 (i * 8))) 64 := by
      rw [hSm]
      exact Fits.storeOut (hfit i hi8) i
    have hr := hroom i (by omega) hi8
    have hgo' : ¬(out.add (BitVec.ofNat 64 (8 * i))).offset.uaddOverflow 8#64 := by
      simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hoo ⊢
      omega
    have hsa : (BitVec.ofNat 64 i).saddOverflow 1#64 = false := by
      simp [BitVec.saddOverflow, BitVec.toInt]; omega
    have hua : (BitVec.ofNat 64 i).uaddOverflow 1#64 = false := by
      simp [BitVec.uaddOverflow]; omega
    block_init
    -- CRYPTO_store_u64_be(out, sha->h[i]); out += 8;
    step_pure [hiN, hlt, gep_value hgo]
    step_load [hSm, readAt_storeOut_of_id_ne (q := c.add (BitVec.ofNat 64 (i * 8))) hsep.symm,
      hH i hi8] consuming hld
    step_call using CRYPTO_store_u64_be.call_eq consuming hr
    step_pure [gep_value hgo']
    step_pure [hsa, hua]
    step_pure
    finish_block
    · -- FIPS_service_indicator_update_state();
      block_init
      step_call using FIPS_service_indicator_update_state.call_eq
      finish_block
      obtain rfl : i = 7 := by omega
      rw [← hK, hS, hSm]
      rfl
    · obtain rfl : i = 7 := by omega
      exact absurd rfl hbr
  | succ m ih =>
    intro i S₁ E hi hArgs hwf hSm hroom hK
    have hi8 : i < 8 := by omega
    have hiN : (BitVec.ofNat 64 i).toNat = i := by
      simp; omega
    have hlt : i * 8 < 18446744073709551616 := by omega
    have hgo : ¬c.offset.uaddOverflow (BitVec.ofNat 64 (i * 8)) :=
      Pointer.not_uaddOverflow_of_ctx hco
        (by
          simp; omega)
    have hld : Fits S₁.mem (c.add (BitVec.ofNat 64 (i * 8))) 64 := by
      rw [hSm]
      exact Fits.storeOut (hfit i hi8) i
    have hr := hroom i (by omega) hi8
    have hgo' : ¬(out.add (BitVec.ofNat 64 (8 * i))).offset.uaddOverflow 8#64 := by
      simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hoo ⊢
      omega
    have hsa : (BitVec.ofNat 64 i).saddOverflow 1#64 = false := by
      simp [BitVec.saddOverflow, BitVec.toInt]; omega
    have hua : (BitVec.ofNat 64 i).uaddOverflow 1#64 = false := by
      simp [BitVec.uaddOverflow]; omega
    block_init
    -- CRYPTO_store_u64_be(out, sha->h[i]); out += 8;
    step_pure [hiN, hlt, gep_value hgo]
    step_load [hSm, readAt_storeOut_of_id_ne (q := c.add (BitVec.ofNat 64 (i * 8))) hsep.symm,
      hH i hi8] consuming hld
    step_call using CRYPTO_store_u64_be.call_eq consuming hr
    step_pure [gep_value hgo']
    step_pure [hsa, hua]
    step_pure
    finish_block
    · have : i = 7 := by
        have h := hbr
        rw [← BitVec.ofNat_add] at h
        have := congrArg BitVec.toNat h
        simp at this
        omega
      omega
    · have h1 :
        S.mem = storeOut M' out (fun k => Firedancer.Ref.fd_ulong_bswap.spec (H k)) (i + 1) := by
        rw [hS, hSm]
        rfl
      have h2 (k : Nat) (hk : i + 1 ≤ k) (hk8 : k < 8) :
        Room S.mem (out.add (BitVec.ofNat 64 (8 * k))) 64 := by
        rw [hS]
        exact (hroom k (by omega) hk8).storeAt
      have h3 :
        (PoisonOr.value
              (.nil,
                { alloc := ⟨S.alloc.nextFreeBlock + (m + 1)⟩,
                  mem :=
                    storeOut M' out (fun k => Firedancer.Ref.fd_ulong_bswap.spec (H k)) 8 }) >>=
            g) =
          K := by
        rw [← hK, hS, Nat.add_assoc, Nat.add_comm 1 (m + 1)]
      clear hroom hK hSm
      run_from using ih (i + 1) S
      all_goals
        first
        | exact (BitVec.ofNat_add i 1).symm
        | rw [show 8 * (i + 1) = 8 * i + 8 by omega, BitVec.ofNat_add]

/-- The last block's bytes all known: the buffered ones, the zeros, the two count words. -/
theorem prefix_last {v : Sha512Ctx} {n : BitVec 64} (hpre : v.Prefix n.toNat) (hn : n.toNat ≤ 112)
    (x y : BitVec 64) :
    (((v.fill n ((0#8).replicate (112#64 - n).toNat)).fill 112#64 x).fill 120#64 y).Prefix 128 := by
  have hsub : (112#64 - n).toNat = 112 - n.toNat :=
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)
  have h1 :=
    hpre.fill rfl ((0#8).replicate (112#64 - n).toNat) (j := 112 - n.toNat) (by rw [hsub])
      (by omega)
  rw [show n.toNat + (112 - n.toNat) = 112 by omega] at h1
  exact (h1.fill (j := 8) rfl x rfl (by decide)).fill (j := 8) rfl y rfl (by decide)

/-- `^bb2`, the last block from `n`. -/
abbrev hdr2 (c : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%138 := .value 1#64, %141 := .value 0#32, %142 := .value 0#64, %143 := .value 112#64, %144 :=
    .value 3#64, %145 := .value (c.add 80#64), %155 := .value n]

/-- The last block, then the hash stored at `out`. -/
theorem last_block (out c : Pointer) (n : BitVec 64) (M : MemoryState) (v : Sha512Ctx)
    (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (sha512_final_impl.args (.value out) (.value 64#64) (.value c)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeShaCtx c v) (hMf : M.ShaCtxFit c) (hn : n.toNat ≤ 112)
    (hpre : v.Prefix n.toNat) (hout : S₁.mem.Words8Room out) (hoo : ¬out.offset.uaddOverflow 64#64)
    (hsep : out.id ≠ c.id) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 12⟩,
                mem :=
                  (M.storeShaCtx c (last v n)).storeWords8 out
                    ((last v n).h.map Firedancer.Ref.fd_ulong_bswap.spec) }) >>=
          g) =
        K) :
    (sha512_final_impl.runFrom (hdr2 c n E) 2 S₁ >>= g) = K := by
  subst hK
  have hco : ¬c.offset.uaddOverflow 208#64 := hMf.1
  have hSf : S₁.mem.ShaCtxFit c := hM ▸ hMf.storeShaCtx
  have hlt : n.toNat < 18446744073709551616 := n.isLt
  have hov := Sha512Ctx.not_uaddOverflow_p hco (off := n) (by omega)
  have hpo : ¬c.offset.uaddOverflow (80#64 + n) :=
    Pointer.not_uaddOverflow_of_ctx hco
      (by
        rw [BitVec.toNat_add]; simp; omega)
  have hoff : (80#64 + n).toNat = 80 + n.toNat := by
    rw [BitVec.toNat_add]; simp; omega
  have hsub : (112#64 - n).toNat = 112 - n.toNat :=
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)
  have hs : (112#64).ssubOverflow n = false := by
    have : n ≤ 112#64 := by
      rw [BitVec.le_def]; simpa using hn
    bv_decide
  have hu : (112#64).usubOverflow n = false := by
    have : n ≤ 112#64 := by
      rw [BitVec.le_def]; simpa using hn
    bv_decide
  have hz : Room S₁.mem (c.add (80#64 + n)) (8 * (112#64 - n).toNat) :=
    Room.add_of_le hpo (by omega) hSf.2.1
  block_init
  -- OPENSSL_memset(p + n, 0, sizeof(sha->p) - 16 - n);
  step_pure [hlt, gep_value hov]
  step_pure [hs, hu]
  step_call using OPENSSL_memset.call_eq consuming hz
  rw [hM, MemoryState.storeShaCtx_storeAt_p hco (by omega) (by omega), Sha512Ctx.add_80_sub] at hS
  clear hread_c
  -- Nh = (bytes_so_far_high << 3) | (bytes_so_far_low >> 61); Nl = bytes_so_far_low << 3;
  step_pure
  step_load with transparent hi
  step_pure
  step_pure
  step_load with transparent lo
  step_pure [fshl_3]
  step_pure
  -- CRYPTO_store_u64_be(p + sizeof(sha->p) - 16, Nh); CRYPTO_store_u64_be(p + … - 8, Nl);
  step_pure
  step_call using CRYPTO_store_u64_be.call_eq
  rw [MemoryState.storeShaCtx_storeAt_p hco (by decide) (by decide)] at hS
  step_pure
  step_call using CRYPTO_store_u64_be.call_eq
  rw [MemoryState.storeShaCtx_storeAt_p hco (by decide) (by decide)] at hS
  simp only [BitVec.reduceSub] at hS
  -- sha512_block_data_order(sha->h, p, 1);
  have hst := hSf.words8Fit
  have hp : Fits S.mem (c.add 80#64) (1024 * (1#64).toNat) := by
    rw [hS]
    exact Fits.storeShaCtx_p hMf.2.1 hco (by decide) (prefix_last hpre hn _ _)
  have hpo' : (c.add 80#64).offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
    simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hco ⊢
    omega
  have hpd : (Range.of c 512).Disjoint (Range.of (c.add 80#64) (1024 * (1#64).toNat)) := by
    right; left
    simp [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.uaddOverflow] at hco ⊢
    omega
  step_call using sha512_block_data_order.call_eq consuming hst hp hpo' hpd
  rw [MemoryState.readWords8_storeShaCtx hMf.2.1 hco,
    MemoryState.readAt_storeShaCtx_p hMf.2.1 hco,
    MemoryState.storeShaCtx_storeWords8 hco] at hS
  replace hS :
    S = { alloc := ⟨S₁.alloc.nextFreeBlock + 1 + 1 + 2⟩, mem := M.storeShaCtx c (last v n) } := hS
  generalize last v n = vF at hS ⊢
  -- for (size_t i = 0; i < md_len / 8; i++) { CRYPTO_store_u64_be(out, sha->h[i]); out += 8; }
  step_pure
  step_pure
  finish_block
  have hS0 :
    S.mem =
      storeOut (M.storeShaCtx c vF) out (fun k => Firedancer.Ref.fd_ulong_bswap.spec vF.h[k]!)
        0 := by
    rw [hS]
    rfl
  have hroom (k : Nat) (_ : 0 ≤ k) (hk : k < 8) :
    Room S.mem (out.add (BitVec.ofNat 64 (8 * k))) 64 := room_out hout hk
  have hK :
    (PoisonOr.value
          (.nil,
            { alloc := ⟨S.alloc.nextFreeBlock + (7 + 1)⟩,
              mem :=
                storeOut (M.storeShaCtx c vF) out
                  (fun k => Firedancer.Ref.fd_ulong_bswap.spec vF.h[k]!) 8 }) >>=
        g) =
      (PoisonOr.value
          (.nil,
            { alloc := ⟨S₁.alloc.nextFreeBlock + 12⟩,
              mem :=
                (M.storeShaCtx c vF).storeWords8 out
                  (vF.h.map Firedancer.Ref.fd_ulong_bswap.spec) }) >>=
        g) := by
    rw [storeOut_eight, hS]
  have hst := hMf.storeShaCtx (v := vF)
  run_from using
    out_loop out c (M.storeShaCtx c vF) (fun k => vF.h[k]!)
      (fun k hk => readAt_storeShaCtx_h hMf.2.1 hco hk)
      (fun k hk => fits_h hst.words8Fit hk) hco hoo hsep g _ 7 0 S

end sha512_final_impl

open sha512_final_impl in
/-- `sha512_final_impl(out, 64, sha)` pads the buffered bytes, compresses the last block (or two)
into `h`, and stores `h`'s words big-endian at `out` (64 bytes, in another block). Each
`sha512_block_data_order` call leaves two blocks counted, each `CRYPTO_store_u64_be` one. -/
public theorem sha512_final_impl.call_eq (out c : Pointer) (s : GlobalState) (hwf : s.WF)
    (hc : s.mem.ShaCtxFit c) (hv : (s.mem.readShaCtx c).Valid) (hout : s.mem.Words8Room out)
    (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ c.id) :
    sha512_final_impl.call (sha512_final_impl.args (.value out) (.value 64#64) (.value c)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (2 * cores (s.mem.readShaCtx c) + 10)⟩,
            mem :=
              (s.mem.storeShaCtx c (sha512_final_impl.spec (s.mem.readShaCtx c))).storeWords8 out
                ((sha512_final_impl.spec (s.mem.readShaCtx c)).h.map
                  Firedancer.Ref.fd_ulong_bswap.spec) }) := by
  func_init
  have hc₀ : S₀.mem.ShaCtxFit c := hS ▸ hc
  have hco : ¬c.offset.uaddOverflow 208#64 := hc.1
  have hv₀ : (S₀.mem.readShaCtx c).Valid := hS ▸ hv
  clear hv
  obtain ⟨v₀, hv₀e⟩ : ∃ v, S₀.mem.readShaCtx c = v := ⟨_, rfl⟩
  rw [hv₀e] at hv₀ ⊢
  have hn := hv₀.1
  have hlt : v₀.num.toNat % 18446744073709551616 < 18446744073709551616 := Nat.mod_lt _ (by decide)
  have hov :=
    Sha512Ctx.not_uaddOverflow_p hco (off := v₀.num.setWidth 64)
      (by
        simp; omega)
  have hoff := Sha512Ctx.toNat_80_add (x := v₀.num)
  block_init
  iterate 10 step_pure
  -- size_t n = sha->num; p[n] = 0x80; n++;
  step_load [← MemoryState.readShaCtx_num hc₀.2.1.inBounds hco, hv₀e] with transparent num
  step_pure
  step_pure [hlt, gep_value hov]
  step_store
  rw [MemoryState.storeAt_p_eq hc₀ (by omega) (by omega), Sha512Ctx.add_80_sub, hv₀e] at hS
  step_pure [saddOverflow_num_one, uaddOverflow_num_one]
  step_pure
  have hn1 := toNat_num_add_one v₀.num
  have hpre1 : (v₀.fill (v₀.num.setWidth 64) 128#8).Prefix (v₀.num.toNat + 1) :=
    hv₀.2.fill (j := 1)
      (by
        simp; omega)
      _ rfl (by omega)
  finish_block
  · -- if (n > (sizeof(sha->p) - 16)) { OPENSSL_memset(p + n, 0, sizeof(sha->p) - n); n = 0; … }
    have hgt : 112 ≤ v₀.num.toNat := by
      have := hbr
      simp [BitVec.ult] at this
      omega
    have hlt1 : (v₀.num.toNat + 1) % 18446744073709551616 < 18446744073709551616 :=
      Nat.mod_lt _ (by decide)
    have hov1 := Sha512Ctx.not_uaddOverflow_p hco (off := v₀.num.setWidth 64 + 1#64) (by omega)
    have hpo1 : ¬c.offset.uaddOverflow (80#64 + (v₀.num.setWidth 64 + 1#64)) :=
      Pointer.not_uaddOverflow_of_ctx hco
        (by
          rw [BitVec.toNat_add, hn1]; simp; omega)
    have hoff1 : (80#64 + (v₀.num.setWidth 64 + 1#64)).toNat = 80 + (v₀.num.toNat + 1) := by
      rw [BitVec.toNat_add, hn1]; simp; omega
    have hsub : (127#64 - v₀.num.setWidth 64).toNat = 127 - v₀.num.toNat := by
      rw [BitVec.toNat_sub_of_le
          (by
            simp [BitVec.le_def]; omega)]
      simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth]
      omega
    have hz :
      Room S.mem (c.add (80#64 + (v₀.num.setWidth 64 + 1#64)))
        (8 * (127#64 - v₀.num.setWidth 64).toNat) :=
      Room.add_of_le hpo1 (by omega) hc.2.1
    block_init
    step_pure [hlt1, gep_value hov1]
    step_pure [ssubOverflow_127 hn]
    step_call using OPENSSL_memset.call_eq consuming hz
    rw [MemoryState.storeShaCtx_storeAt_p hco (by omega) (by omega), Sha512Ctx.add_80_sub] at hS
    -- sha512_block_data_order(sha->h, p, 1);
    have hst := hc.words8Fit
    have hp : Fits S.mem (c.add 80#64) (1024 * (1#64).toNat) := by
      rw [hS]
      refine Fits.storeShaCtx_p hc₀.2.1 hco (by decide) ?_
      have :=
        hpre1.fill (j := 127 - v₀.num.toNat) (by rw [hn1])
          ((0#8).replicate (127#64 - v₀.num.setWidth 64).toNat) (by rw [hsub]) (by omega)
      rwa [show v₀.num.toNat + 1 + (127 - v₀.num.toNat) = 128 by omega] at this
    have hpo' : (c.add 80#64).offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
      simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hco ⊢
      omega
    have hpd : (Range.of c 512).Disjoint (Range.of (c.add 80#64) (1024 * (1#64).toNat)) := by
      right; left
      simp [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
        BitVec.uaddOverflow] at hco ⊢
      omega
    step_call using sha512_block_data_order.call_eq consuming hst hp hpo' hpd
    rw [MemoryState.readWords8_storeShaCtx hc₀.2.1 hco,
      MemoryState.readAt_storeShaCtx_p hc₀.2.1 hco,
      MemoryState.storeShaCtx_storeWords8 hco] at hS
    have hM := congrArg GlobalState.mem hS
    dsimp only at hM
    finish_block
    run_from using
      last_block out c 0#64 S₀.mem _ (hM := hM) (hn := by decide) (hpre := Sha512Ctx.prefix_zero _)
        (hK := ?_)
    have hcond : (112#64).ult (v₀.num.setWidth 64 + 1#64) = true := by
      simp only [BitVec.ult, hn1, decide_eq_true_eq]
      simp
      omega
    refine ⟨by simp [cores, hcond], ?_⟩
    rw [MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]
    have hmod :
      (18446744073709551616 - (BitVec.setWidth 64 v₀.num).toNat + 127) % 18446744073709551616 =
        127 - v₀.num.toNat := by
      simp only [BitVec.toNat_setWidth]
      omega
    have h128 : (128#64 - (v₀.num.setWidth 64 + 1#64)).toNat = 127 - v₀.num.toNat := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hn1]; simp; omega),
        hn1]
      simp
    simp only [spec, hcond, ↓reduceIte]
    rw [hmod, h128]
    rfl
  · have hle : v₀.num.toNat ≤ 111 := by
      have := hbr
      simp [BitVec.ult] at this
      omega
    have hM := congrArg GlobalState.mem hS
    dsimp only at hM
    run_from using
      last_block out c (v₀.num.setWidth 64 + 1#64) S₀.mem _ (hM := hM) (hn := by omega) (hpre := by
        rw [hn1]; exact hpre1) (hK := ?_)
    have hcond : (112#64).ult (v₀.num.setWidth 64 + 1#64) = false := by
      simp only [BitVec.ult, hn1, decide_eq_false_iff_not]
      simp
      omega
    refine ⟨by simp [cores, hcond], ?_⟩
    rw [MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]
    simp only [spec, hcond, Bool.false_eq_true, ↓reduceIte]

end Proof

end MLIR.Boringssl

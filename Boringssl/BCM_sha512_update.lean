module

public import MLIR.Run.Tactic
public import Boringssl.Common.Sha512
public import Boringssl.OPENSSL_memcpy
public import Boringssl.sha512_block_data_order
public import Boringssl.Mlir.BCM_sha512_update
import Std.Tactic.BVDecide

namespace MLIR.Boringssl

open Memory

/-! ## Specification -/

@[expose] public section

namespace BCM_sha512_update

/-- `if (len != 0) { OPENSSL_memcpy(p, data, len); c->num = (int)len; }`. -/
def leftover (v : Sha512Ctx) (len : BitVec 64) (data : BitVec (8 * len.toNat)) : Sha512Ctx :=
  if len = 0#64 then v else { v.fill 0#64 data with num := len.setWidth 16 }

/-- `if (len >= sizeof(c->p)) { sha512_block_data_order(c->h, data, len / sizeof(c->p)); … }`:
the whole blocks compressed into `h`; then the leftover. -/
def bulk (v : Sha512Ctx) (len : BitVec 64) (data : BitVec (8 * len.toNat)) : Sha512Ctx :=
  if (127#64).ult len then
    leftover
      { v with
        h :=
          Firedancer.Ref.fd_sha512_core_ref.spec v.h (n := (len >>> 7).toNat)
            (data.setWidth (1024 * (len >>> 7).toNat)) }
      (len &&& 127#64)
      (data.extractLsb' (8 * (len - (len &&& 127#64)).toNat) (8 * (len &&& 127#64).toNat))
  else leftover v len data

/-- From `if (c->num != 0)` on: fill and compress the buffered block, then the bulk. -/
def rest (v : Sha512Ctx) (len : BitVec 64) (data : BitVec (8 * len.toNat)) : Sha512Ctx :=
  if v.num = 0#16 then bulk v len data
  else
    let n := 128#64 - v.num.setWidth 64
    if len.ult n then { v.fill (v.num.setWidth 64) data with num := v.num + len.setWidth 16 }
    else
      let v := { v.fill (v.num.setWidth 64) (data.setWidth (8 * n.toNat)) with num := 0#16 }
      bulk { v with h := Firedancer.Ref.fd_sha512_core_ref.spec (n := 1) v.h v.p } (len - n)
        (data.extractLsb' (8 * n.toNat) (8 * (len - n).toNat))

/-- How many `sha512_block_data_order` calls the bulk makes. -/
def bulkCores (len : BitVec 64) : Nat :=
  if (127#64).ult len then 1 else 0

/-- How many `sha512_block_data_order` calls `rest` makes. -/
def restCores (v : Sha512Ctx) (len : BitVec 64) : Nat :=
  if v.num = 0#16 then bulkCores len
  else
    let n := 128#64 - v.num.setWidth 64
    if len.ult n then 0 else 1 + bulkCores (len - n)

/-- How many `sha512_block_data_order` calls `update` makes. -/
def cores (v : Sha512Ctx) (len : BitVec 64) : Nat :=
  if len = 0#64 then 0 else restCores v len

/-- The bulk's `data += len; len %= sizeof(c->p); data -= len;` steps `data` back by `len % 128`
bytes, a `getelementptr` with a negative index. The framework takes a dynamic index unsigned, so
that step is poison unless it is by `0`: the bulk has no whole block, or no tail after them. -/
def BulkOk (len : BitVec 64) : Prop :=
  ¬(127#64).ult len ∨ len &&& 127#64 = 0#64

/-- `BulkOk` of the bulk `rest` reaches, if it does. -/
def RestOk (v : Sha512Ctx) (len : BitVec 64) : Prop :=
  if v.num = 0#16 then BulkOk len
  else
    let n := 128#64 - v.num.setWidth 64
    len.ult n ∨ BulkOk (len - n)

/-- `BulkOk` of the bulk `update` reaches, if it does. -/
def Ok (v : Sha512Ctx) (len : BitVec 64) : Prop :=
  len = 0#64 ∨ RestOk v len

end BCM_sha512_update

open BCM_sha512_update in
/-- The struct after appending the `len` bytes `data`. -/
def BCM_sha512_update.spec (v : Sha512Ctx) (len : BitVec 64) (data : BitVec (8 * len.toNat)) :
    Sha512Ctx :=
  if len = 0#64 then v
  else
    let lo := v.lo + len
    let hi := if lo.ult len then v.hi + 1#32 else v.hi
    rest
      { v with
        lo, hi }
      len data

end

/-! ## Proof -/

section Proof

namespace BCM_sha512_update

/-! ### Sizes -/

theorem setWidth_setWidth_16 {n : BitVec 64} (h : n.toNat < 128) :
    (n.setWidth 16).setWidth 64 = n := by
  have : n < 128#64 := by simpa [BitVec.lt_def] using h
  bv_decide

theorem signExtend_setWidth_16 {n : BitVec 64} (h : n.toNat < 128) :
    (n.setWidth 16).signExtend 64 = n := by
  have : n < 128#64 := by simpa [BitVec.lt_def] using h
  bv_decide

theorem ssubOverflow_128 {x : BitVec 16} (h : x.toNat < 128) :
    (128#64).ssubOverflow (x.setWidth 64) = false := by
  have : x < 128#16 := by simpa [BitVec.lt_def] using h
  bv_decide

theorem toNat_sub_num {x : BitVec 16} (h : x.toNat < 128) :
    (128#64 - x.setWidth 64).toNat = 128 - x.toNat := by
  rw [BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; omega)]
  simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth]
  omega

/-- Filling the buffered block to its end leaves all of `p` known. -/
theorem pDef_fill_full {v : Sha512Ctx} (hv : v.Valid) {w : Nat} (x : BitVec w)
    (hw : w = 8 * (128 - v.num.toNat)) :
    (v.fill (v.num.setWidth 64) x).pDef = BitVec.allOnes 1024 := by
  obtain ⟨hn, hd⟩ := hv
  have hm : v.num.toNat % 2 ^ 64 = v.num.toNat := Nat.mod_eq_of_lt (by omega)
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Sha512Ctx.fill, Firedancer.Ref.fd_sha512_append.copy, getLsbD_spliceBits,
    BitVec.getLsbD_allOnes, BitVec.toNat_setWidth, hm, hi, decide_true, and_true]
  split
  · simp only [decide_eq_true_eq]
    omega
  · have := congrArg (·.getLsbD i) hd
    simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add] at this
    have hi' : i < 8 * v.num.toNat := by omega
    simpa [hi'] using this

theorem restCores_counts (v : Sha512Ctx) (lo : BitVec 64) (hi : BitVec 32) (len : BitVec 64) :
    restCores
        { v with
          lo, hi }
        len =
      restCores v len :=
  rfl

/-! ### The leftover: `^bb9 … ^bb12` -/

/-- `^bb9`, the leftover of the `n` bytes at `d`. -/
abbrev hdr9 (c d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%82 := .value 0#64, %89 := .value 0#32, %90 := .value (c.add 80#64), %99 :=
    .value (c.add 64#64), %121 := .value n, %122 := .value d]

/-- `if (len != 0) { OPENSSL_memcpy(p, data, len); c->num = (int)len; }`, then return `0`. -/
theorem leftover_block (c data d : Pointer) (len n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : Sha512Ctx) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (BCM_sha512_update.args (.value c) (.value data) (.value len)).get)
    (hwf : S.WF) (hM : S.mem = M.storeShaCtx c v) (hMf : M.ShaCtxFit c) (hn : n.toNat < 128)
    (hd : Fits S.mem d (8 * n.toNat)) (hsep : d.id ≠ c.id) (hD : S.mem.readAt d (8 * n.toNat) = D)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil, { S with mem := M.storeShaCtx c (leftover v n D) }) >>=
          g) =
        K) :
    (BCM_sha512_update.runFrom (hdr9 c d n E) 9 S >>= g) = K := by
  subst hK
  have hco : ¬c.offset.uaddOverflow 208#64 := hMf.1
  have hSf : S.mem.ShaCtxFit c := hM ▸ hMf.storeShaCtx
  block_init
  step_pure
  finish_block
  · block_init
    finish_block
    rw [show leftover v n D = v by simp [leftover, hbr], ← hM]
  · block_init
    -- OPENSSL_memcpy(p, data, len);
    step_call using OPENSSL_memcpy.call_eq
    step_pure [setWidth_setWidth_16 hn, signExtend_setWidth_16 hn]
    finish_block
    block_init
    -- c->num = (int)len;
    step_store
    finish_block
    block_init
    finish_block
    rw [hS, hM,
      MemoryState.storeShaCtx_storeAt_p hco (by decide)
        (by
          simp; omega),
      MemoryState.storeShaCtx_storeAt_num hco]
    simp only [leftover, hbr, ↓reduceIte, BitVec.sub_self]

/-! ### The bulk: `^bb7`, `^bb8` -/

theorem gep_zero (p : Pointer) : Operation.gep (.value 0#64) (.value p) = .value p := by
  rw [gep_value (by simp [BitVec.uaddOverflow, p.offset.isLt]), Pointer.add_zero]

theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `^bb7`, the bulk of the `n` bytes at `d`. -/
abbrev hdr7 (c d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%82 := .value 0#64, %87 := .value 127#64, %88 := .value 7#64, %89 := .value 0#32, %90 :=
    .value (c.add 80#64), %99 := .value (c.add 64#64), %113 := .value n, %114 := .value d]

/-- `if (len >= sizeof(c->p)) { sha512_block_data_order(c->h, data, len / sizeof(c->p)); … }`,
then the leftover. -/
theorem bulk_block (c data d : Pointer) (len n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : Sha512Ctx) (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (BCM_sha512_update.args (.value c) (.value data) (.value len)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeShaCtx c v) (hMf : M.ShaCtxFit c) (hok : BulkOk n)
    (hd : Fits S₁.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ c.id)
    (hD : S₁.mem.readAt d (8 * n.toNat) = D) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2 * bulkCores n⟩,
                mem := M.storeShaCtx c (bulk v n D) }) >>=
          g) =
        K) :
    (BCM_sha512_update.runFrom (hdr7 c d n E) 7 S₁ >>= g) = K := by
  subst hK
  have hco : ¬c.offset.uaddOverflow 208#64 := hMf.1
  have hSf : S₁.mem.ShaCtxFit c := hM ▸ hMf.storeShaCtx
  block_init
  step_pure
  finish_block
  · -- len >= sizeof(c->p)
    have h0 : n &&& 127#64 = 0#64 := hok.resolve_left (by simpa using hbr)
    have hnz : n >>> 7 ≠ 0#64 := by
      have := hbr
      bv_decide
    have hst := hSf.words8Fit
    have hblk : Fits S₁.mem d (1024 * (n >>> 7).toNat) :=
      hd.mono
        (by
          rw [toNat_ushiftRight_7]; omega)
    have hblko : d.offset.toNat + 128 * (n >>> 7).toNat < 2 ^ 64 := by
      rw [toNat_ushiftRight_7]
      simp [BitVec.uaddOverflow] at hdo
      omega
    block_init
    -- sha512_block_data_order(c->h, data, len / sizeof(c->p));
    step_pure
    step_call using sha512_block_data_order.call_eq
    -- data += len; len %= sizeof(c->p); data -= len;
    have hlt : n.toNat < 18446744073709551616 := n.isLt
    step_pure [hlt]
    step_pure
    have hs0 : (0#64).ssubOverflow 0#64 = false := by decide
    step_pure [h0, hs0]
    step_pure [h0, hs0, gep_zero]
    finish_block [h0]
    have hstate : S₁.mem.readWords8 c = v.h := by
      rw [hM]
      exact MemoryState.readWords8_storeShaCtx hMf.2.1.inBounds hco
    have hblock :
      S₁.mem.readAt d (1024 * (n >>> 7).toNat) = D.setWidth (1024 * (n >>> 7).toNat) := by
      rw [← hread_d]
      exact
        MemoryState.readAt_of_readAt_le
          (by
            rw [toNat_ushiftRight_7]; omega)
          hD
    rw [hstate, hblock, hM, MemoryState.storeShaCtx_storeWords8 hco] at hS
    have hM' := congrArg GlobalState.mem hS
    clear hread_d hblock hstate
    step_loop using
      leftover_block c data (d.add n) len 0#64 (S.mem.readAt (d.add n) (8 * (0#64).toNat)) M _
        (hD := rfl) (hK := ?_)
    simp [bulk, bulkCores, hbr, h0, leftover]
  · have hn : n.toNat < 128 := by
      have := hbr
      simp [BitVec.ult] at this
      omega
    step_loop using leftover_block c data d len n D M v (hK := ?_)
    simp [bulk, bulkCores, hbr]

/-! ### The buffered block: `^bb3 … ^bb6` -/

/-- `^bb3`, the counts stored. -/
abbrev hdr3 (c : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%82 := .value 0#64, %84 := .value 0#16, %85 := .value 128#64, %86 := .value 1#64, %87 :=
    .value 127#64, %88 := .value 7#64, %89 := .value 0#32, %90 := .value (c.add 80#64)]

/-- `if (c->num != 0) { … }`, then the bulk. -/
theorem rest_block (c data : Pointer) (len : BitVec 64) (D : BitVec (8 * len.toNat))
    (M : MemoryState) (v : Sha512Ctx) (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (BCM_sha512_update.args (.value c) (.value data) (.value len)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeShaCtx c v) (hMf : M.ShaCtxFit c) (hv : v.Valid)
    (hok : RestOk v len) (hd : Fits S₁.mem data (8 * len.toNat))
    (hdo : ¬data.offset.uaddOverflow len) (hsep : data.id ≠ c.id)
    (hD : S₁.mem.readAt data (8 * len.toNat) = D) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value 0#32) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2 * restCores v len⟩,
                mem := M.storeShaCtx c (rest v len D) }) >>=
          g) =
        K) :
    (BCM_sha512_update.runFrom (hdr3 c E) 3 S₁ >>= g) = K := by
  subst hK
  have hco : ¬c.offset.uaddOverflow 208#64 := hMf.1
  have hSf : S₁.mem.ShaCtxFit c := hM ▸ hMf.storeShaCtx
  block_init
  step_pure
  step_load [hM] with transparent num
  step_pure
  finish_block
  · -- c->num == 0
    have hok' : BulkOk len := by simpa [RestOk, hbr] using hok
    step_loop using bulk_block c data data len len D M v (hK := ?_)
    simp [rest, restCores, hbr]
  · have hnz : v.num ≠ 0#16 := hbr
    have hn := hv.1
    have hlt : v.num.toNat % 18446744073709551616 < 18446744073709551616 := Nat.mod_lt _ (by decide)
    have hov :=
      Sha512Ctx.not_uaddOverflow_p hco (off := v.num.setWidth 64)
        (by
          simp; omega)
    block_init
    -- size_t n = sizeof(c->p) - c->num;
    step_pure
    step_pure [ssubOverflow_128 hn]
    step_pure [ssubOverflow_128 hn]
    step_pure [hlt, gep_value hov]
    have hoff := Sha512Ctx.toNat_80_add (x := v.num)
    have hpo : ¬c.offset.uaddOverflow (80#64 + v.num.setWidth 64) :=
      Pointer.not_uaddOverflow_of_ctx hco (by omega)
    have hrem := toNat_sub_num hn
    finish_block
    · -- if (len < n) { OPENSSL_memcpy(p + c->num, data, len); c->num += (unsigned int)len; }
      have hlt' : len.toNat < 128 - v.num.toNat := by
        have := hbr
        simp only [BitVec.ult, hrem, decide_eq_true_eq] at this
        omega
      have hroom : Room S.mem (c.add (80#64 + v.num.setWidth 64)) (8 * len.toNat) :=
        Room.add_of_le hpo (by omega) hSf.2.1
      block_init
      step_call using OPENSSL_memcpy.call_eq consuming hroom
      rw [hM, MemoryState.storeShaCtx_storeAt_p hco (by omega) (by omega),
        Sha512Ctx.add_80_sub] at hS
      step_pure
      step_load
      step_pure
      finish_block
      block_init
      step_store
      finish_block
      block_init
      finish_block
      rw [hS, MemoryState.storeShaCtx_storeAt_num hco]
      simp only [rest, restCores, hnz, hbr, ↓reduceIte, Nat.mul_zero, Nat.add_zero]
    · -- OPENSSL_memcpy(p + c->num, data, n), c->num = 0; len -= n; data += n;
      have hge : 128 - v.num.toNat ≤ len.toNat := by
        have := hbr
        simp only [BitVec.ult, hrem, decide_eq_true_eq, Nat.not_lt] at this
        omega
      have hroom :
        Room S.mem (c.add (80#64 + v.num.setWidth 64)) (8 * (128#64 - v.num.setWidth 64).toNat) :=
        Room.add_of_le hpo (by omega) hSf.2.1
      have hsrc : Fits S.mem data (8 * (128#64 - v.num.setWidth 64).toNat) := hd.mono (by omega)
      have hov' : ¬data.offset.uaddOverflow (128#64 - v.num.setWidth 64) :=
        BitVec.not_uaddOverflow_of_le hdo (by omega)
      have hnuw : len.usubOverflow (128#64 - v.num.setWidth 64) = false := by
        simp only [BitVec.usubOverflow, hrem, decide_eq_false_iff_not]
        omega
      have hlt' : (128#64 - v.num.setWidth 64).toNat < 18446744073709551616 := by omega
      have hX :
        S₁.mem.readAt data (8 * (128#64 - v.num.setWidth 64).toNat) =
          D.setWidth (8 * (128#64 - v.num.setWidth 64).toNat) :=
        MemoryState.readAt_of_readAt_le (by omega) (hS ▸ hD)
      block_init
      step_call using OPENSSL_memcpy.call_eq consuming hroom hsrc
      step_store
      rw [hX, hM, MemoryState.storeShaCtx_storeAt_p hco (by omega) (by omega), Sha512Ctx.add_80_sub,
        MemoryState.storeShaCtx_storeAt_num hco] at hS
      generalize hv1 :
        { v.fill (v.num.setWidth 64) (D.setWidth (8 * (128#64 - v.num.setWidth 64).toNat)) with
          num := 0#16 } =
        v1 at hS
      step_pure [hnuw]
      step_pure [hlt', gep_value hov']
      -- sha512_block_data_order(c->h, p, 1);
      have hst := hSf.words8Fit
      have hp : Fits S.mem (c.add 80#64) (1024 * (1#64).toNat) := by
        rw [hS]
        refine Fits.storeShaCtx_p hMf.2.1 hco (by decide) ?_
        rw [← hv1]
        dsimp only
        rw [pDef_fill_full hv _ (by omega)]
        simp
      have hpo' : (c.add 80#64).offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
        simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hco ⊢
        omega
      have hpd : (Range.of c 512).Disjoint (Range.of (c.add 80#64) (1024 * (1#64).toNat)) := by
        right; left
        simp [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
          BitVec.uaddOverflow] at hco ⊢
        omega
      step_call using sha512_block_data_order.call_eq consuming hst hp hpo' hpd
      rw [MemoryState.readWords8_storeShaCtx hMf.2.1.inBounds hco,
        MemoryState.readAt_storeShaCtx_p hMf.2.1.inBounds hco,
        MemoryState.storeShaCtx_storeWords8 hco] at hS
      have hM' := congrArg GlobalState.mem hS
      dsimp only at hM'
      have hsub : (len - (128#64 - v.num.setWidth 64)).toNat = len.toNat - (128 - v.num.toNat) := by
        rw [BitVec.toNat_sub_of_le
            (by
              rw [BitVec.le_def]; omega),
          hrem]
      have hd' :
        Fits S.mem (data.add (128#64 - v.num.setWidth 64))
          (8 * (len - (128#64 - v.num.setWidth 64)).toNat) :=
        Fits.add_of_le hov' (by omega) hd
      have hdo' :
        ¬(data.add (128#64 - v.num.setWidth 64)).offset.uaddOverflow
            (len - (128#64 - v.num.setWidth 64)) :=
        Pointer.not_uaddOverflow_add_sub hdo (by omega)
      have hD' :
        S.mem.readAt (data.add (128#64 - v.num.setWidth 64))
            (8 * (len - (128#64 - v.num.setWidth 64)).toNat) =
          D.extractLsb' (8 * (128#64 - v.num.setWidth 64).toNat)
            (8 * (len - (128#64 - v.num.setWidth 64)).toNat) := by
        rw [MemoryState.readAt_add_of_readAt hd.inBounds hov' (by omega) hD]
        congr 1
        omega
      have hok' : BulkOk (len - (128#64 - v.num.setWidth 64)) := by
        simpa [RestOk, hnz, hbr] using hok
      -- `n` and the length left as variables, so the step's simp keeps their `toNat`s folded
      clear hsub hge hlt' hrem hov' hnuw hX
      generalize hr : 128#64 - v.num.setWidth 64 = r at *
      generalize hn' : len - r = n at *
      finish_block
      step_loop using bulk_block c data _ len _ _ M _ (hD := hD') (hK := ?_)
      subst hv1 hn' hr
      simp only [rest, restCores, hnz, hbr, ↓reduceIte, Bool.false_eq_true]
      rw [Nat.mul_add, Nat.mul_one, ← Nat.add_assoc]

end BCM_sha512_update

open BCM_sha512_update in
/-- `BCM_sha512_update` appends the `len` bytes at `data` to the struct at `c` and returns `0`
(`approved`). Each `sha512_block_data_order` call leaves two blocks counted; `data` is in another
block. `Ok` rules out the bulk's step back by a nonzero tail (poison in the framework). -/
public theorem BCM_sha512_update.call_eq (c data : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hc : s.mem.ShaCtxFit c) (hv : (s.mem.readShaCtx c).Valid)
    (hok : Ok (s.mem.readShaCtx c) len) (hdata : Fits s.mem data (8 * len.toNat))
    (hdo : ¬data.offset.uaddOverflow len) (hsep : data.id ≠ c.id) :
    BCM_sha512_update.call (BCM_sha512_update.args (.value c) (.value data) (.value len)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2 * cores (s.mem.readShaCtx c) len⟩,
            mem :=
              s.mem.storeShaCtx c
                (BCM_sha512_update.spec (s.mem.readShaCtx c) len
                  (s.mem.readAt data (8 * len.toNat))) }) := by
  func_init
  have hc₀ : S₀.mem.ShaCtxFit c := hS ▸ hc
  have hco : ¬c.offset.uaddOverflow 208#64 := hc.1
  have hv₀ : (S₀.mem.readShaCtx c).Valid := hS ▸ hv
  have hok₀ : Ok (S₀.mem.readShaCtx c) len := hS ▸ hok
  clear hv hok
  obtain ⟨v₀, hv₀e⟩ : ∃ v, S₀.mem.readShaCtx c = v := ⟨_, rfl⟩
  rw [hv₀e] at hv₀ hok₀ ⊢
  block_init
  iterate 10 step_pure
  finish_block
  · -- if (len == 0) return
    block_init
    finish_block
    subst hS hbr
    simp only [BCM_sha512_update.spec, cores, ↓reduceIte, Nat.mul_zero, Nat.add_zero,
      hwf₀.eraseFrom, ← hv₀e, MemoryState.storeShaCtx_readShaCtx_self hc₀]
  · have hlen : len ≠ 0#64 := hbr
    have hrok : RestOk v₀ len := hok₀.resolve_left hlen
    block_init
    -- c->bytes_so_far_low += len;
    step_pure
    step_load [← MemoryState.readShaCtx_lo hc₀.2.1.inBounds hc₀.1, hv₀e] with transparent lo
    step_pure
    step_store
    rw [MemoryState.storeAt_lo_eq hc₀, hv₀e] at hS
    have hD : S.mem.readAt data (8 * len.toNat) = S₀.mem.readAt data (8 * len.toNat) := by
      rw [hS, MemoryState.readAt_storeShaCtx_of_id_ne hsep]
    step_pure
    finish_block
    · -- if (c->bytes_so_far_low < len) { c->bytes_so_far_high++; }
      have hcarry := hbr
      block_init
      step_pure
      step_load
      step_pure
      step_store
      rw [MemoryState.storeShaCtx_storeAt_hi hco] at hS
      have hM := congrArg GlobalState.mem hS
      dsimp only at hM
      finish_block
      step_loop using
        rest_block c data len _ S₀.mem _ (hM := hM) (hv := hv₀) (hok := hrok) (hD := hD) (hK := ?_)
      rw [MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]
      simp only [BCM_sha512_update.spec, cores, hlen, hcarry, ↓reduceIte, restCores_counts,
        and_self]
    · have hcarry := hbr
      have hM := congrArg GlobalState.mem hS
      dsimp only at hM
      step_loop using
        rest_block c data len _ S₀.mem _ (hM := hM) (hv := hv₀) (hok := hrok) (hD := hD) (hK := ?_)
      rw [MemoryState.eraseFrom_storeShaCtx, hwf₀.eraseFrom]
      simp only [BCM_sha512_update.spec, cores, hlen, hcarry, ↓reduceIte, Bool.false_eq_true,
        restCores_counts, and_self]

/-! ## What callers chain -/

namespace BCM_sha512_update

theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

theorem leftover_valid {v : Sha512Ctx} (hv : v.Valid) (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) (hl : len.toNat < 128) : (leftover v len data).Valid := by
  unfold leftover
  split
  · exact hv
  · refine
      ⟨by
        simp only [BitVec.toNat_setWidth]; omega, ?_⟩
    have := (Sha512Ctx.prefix_zero v).fill (off := 0#64) rfl data (j := len.toNat) rfl (by omega)
    rw [Nat.zero_add] at this
    show (v.fill 0#64 data).Prefix (len.setWidth 16).toNat
    rwa [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]

theorem bulk_valid {v : Sha512Ctx} (hv : v.Valid) (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) : (bulk v len data).Valid := by
  unfold bulk
  split
  · apply leftover_valid
    · exact hv
    · rw [toNat_and_127]
      omega
  · rename_i h
    exact
      leftover_valid hv len data
        (by
          simp [BitVec.ult] at h; omega)

end BCM_sha512_update

open BCM_sha512_update in
/-- `update` keeps the struct `Valid`. -/
public theorem BCM_sha512_update.spec_valid {v : Sha512Ctx} (hv : v.Valid) (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) : (BCM_sha512_update.spec v len data).Valid := by
  unfold BCM_sha512_update.spec
  split
  · exact hv
  dsimp only
  generalize (if (v.lo + len).ult len then v.hi + 1#32 else v.hi) = hi
  unfold rest
  dsimp only
  split
  · exact
      bulk_valid (v :=
        { v with
          lo := v.lo + len, hi })
        hv _ _
  rename_i hn
  have hrem := toNat_sub_num hv.1
  split
  · rename_i hlt
    simp only [BitVec.ult, hrem, decide_eq_true_eq] at hlt
    refine ⟨?_, ?_⟩
    · show (v.num + len.setWidth 16).toNat < 128
      rw [BitVec.toNat_add, BitVec.toNat_setWidth]
      omega
    · have :=
        hv.2.fill (off := v.num.setWidth 64)
          (by
            simp; omega)
          data (j := len.toNat) rfl (by omega)
      show (v.fill (v.num.setWidth 64) data).Prefix (v.num + len.setWidth 16).toNat
      rwa [BitVec.toNat_add, BitVec.toNat_setWidth, Nat.mod_eq_of_lt (a := len.toNat) (by omega),
        Nat.mod_eq_of_lt (by omega)]
  · exact bulk_valid ⟨show (0#16).toNat < 128 by decide, Sha512Ctx.prefix_zero _⟩ _ _

/-- `update` keeps `md_len`. -/
public theorem BCM_sha512_update.spec_mdLen (v : Sha512Ctx) (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) : (BCM_sha512_update.spec v len data).mdLen = v.mdLen := by
  unfold BCM_sha512_update.spec BCM_sha512_update.rest BCM_sha512_update.bulk
    BCM_sha512_update.leftover
  split
  · rfl
  · dsimp only
    repeat' split
    all_goals rfl

/-- A short update: the bytes buffered after the ones there. -/
public theorem BCM_sha512_update.spec_num_of_lt {v : Sha512Ctx} {len : BitVec 64}
    (data : BitVec (8 * len.toNat)) (hlen : len ≠ 0#64) (h : v.num.toNat + len.toNat < 128) :
    (BCM_sha512_update.spec v len data).num = v.num + len.setWidth 16 := by
  have hrem := BCM_sha512_update.toNat_sub_num (x := v.num) (by omega)
  unfold BCM_sha512_update.spec BCM_sha512_update.rest
  rw [ite_eq_right hlen]
  dsimp only
  split
  · rename_i hn
    unfold BCM_sha512_update.bulk BCM_sha512_update.leftover
    rw [ite_eq_right
        (by
          simp [BitVec.ult]; omega),
      ite_eq_right hlen]
    show len.setWidth 16 = v.num + len.setWidth 16
    rw [hn, BitVec.zero_add]
  · rw [ite_eq_left
        (by
          simp only [BitVec.ult, hrem, decide_eq_true_eq]; omega)]

/-- A short update's bulk is `Ok`. -/
public theorem BCM_sha512_update.ok_of_lt {v : Sha512Ctx} {len : BitVec 64}
    (h : v.num.toNat + len.toNat < 128) : BCM_sha512_update.Ok v len := by
  have hrem := BCM_sha512_update.toNat_sub_num (x := v.num) (by omega)
  right
  unfold BCM_sha512_update.RestOk
  split
  · exact
      .inl
        (by
          simp [BitVec.ult]; omega)
  · exact
      .inl
        (by
          simp only [BitVec.ult, hrem, decide_eq_true_eq]; omega)

end Proof

end MLIR.Boringssl

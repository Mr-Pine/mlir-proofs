module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Common.Dsmb
public import Boringssl.Common.Point
public import Boringssl.ge_double_scalarmult_vartime
public import Sodium.slide_vartime
public import Sodium.ge25519_madd
public import Sodium.ge25519_msub
public import Sodium.ge25519_p2_0
public import Sodium.ge25519_p2_dbl
public import Sodium.ge25519_p3_dbl
public import Sodium.ge25519_add
public import Sodium.ge25519_sub
public import Sodium.ge25519_p1p1_to_p2
public import Sodium.ge25519_p1p1_to_p3
public import Sodium.ge25519_p3_to_cached
public import Sodium.Mlir.ge25519_double_scalarmult_vartime

namespace MLIR.Sodium

open Boringssl.ge_double_scalarmult_vartime (start precompAt digitBlocks Digits SlidesAt CachedTable
  PrecompTable Layout LoopFacts TableLayout PointRoom.entry readLimbs_storeCached_apart
  readCached_storeCached_apart idx_lt_pos idx_lt_neg idx160 idx120 eq_zero_of_not ne_zero_of_pos
  ne_zero_of_neg saddOverflow_neg_one64 eq_zero_of_not_slt64 storeP2_storeP2_self
  saddOverflow_neg_two32 add_neg_two32 start_succ_zero start_succ_ne GlobalState.WF.tableStep
  CachedTable.store8 SlidesAt.of_readAt PrecompTable.of_readAt)

/-! ## Specification

The slides are `slide.spec`'s digits; `Bi` is read from its global's bits. The first non-zero
digit (`start`), the entries' layout (`precompAt`) and the digit bound (`Digits`) are BoringSSL's,
whose code is the same. -/

@[expose] public section

namespace ge25519_double_scalarmult_vartime

/-- `A2 = 2 A`: `ge25519_p3_dbl(&t, A); ge25519_p1p1_to_p3(&A2, &t);`. -/
def A2 (A : GeP3) : GeP3 :=
  ge25519_p1p1_to_p3.spec (ge25519_p3_dbl.spec A)

/-- `Ai[i]`: `A` as a `ge25519_cached`, then `Ai[i + 1] = A2 + Ai[i]` through `u`. -/
def aiTbl (A : GeP3) : Nat → GeCached
  | 0 => ge25519_p3_to_cached.spec A
  | i + 1 =>
    ge25519_p3_to_cached.spec (ge25519_p1p1_to_p3.spec (ge25519_add.spec (A2 A) (aiTbl A i)))

/-- `Bi[j]`: entry `j` of the bits `addressof` stores. -/
noncomputable def biTbl (j : Nat) : GePrecomp :=
  precompAt (Ty.flatBits ge25519_double_scalarmult_vartime_Bi.lit (w := 7680) (hw := rfl)) (960 * j)

/-- `aslide[i]`'s add on `t`: `u = t` as a `ge25519_p3`, then `t = u ± Ai[|d| / 2]`; nothing at
`d = 0`. -/
def addA (ai : Nat → GeCached) (d : BitVec 8) (t : GeP1p1) : GeP1p1 :=
  if (0#8).slt d then ge25519_add.spec (ge25519_p1p1_to_p3.spec t) (ai (d >>> 1).toNat)
  else if d.slt 0#8 then ge25519_sub.spec (ge25519_p1p1_to_p3.spec t) (ai ((-d) >>> 1).toNat) else t

/-- `bslide[i]`'s add on `t`, from `Bi`. -/
def addB (bi : Nat → GePrecomp) (d : BitVec 8) (t : GeP1p1) : GeP1p1 :=
  if (0#8).slt d then ge25519_madd.spec (ge25519_p1p1_to_p3.spec t) (bi (d >>> 1).toNat)
  else
    if d.slt 0#8 then ge25519_msub.spec (ge25519_p1p1_to_p3.spec t) (bi ((-d) >>> 1).toNat) else t

/-- An iteration on `r`: `t = 2 r`, the two digits' adds, `r = t` as a `ge25519_p2`. -/
def step (ai : Nat → GeCached) (bi : Nat → GePrecomp) (da db : BitVec 8) (r : GeP2) : GeP2 :=
  ge25519_p1p1_to_p2.spec (addB bi db (addA ai da (ge25519_p2_dbl.spec r)))

/-- The main loop from `i` down to `0` on `r`. -/
def ladder (ai : Nat → GeCached) (bi : Nat → GePrecomp) (as bs : Vector (BitVec 8) 256) :
    (i : Nat) → i < 256 → GeP2 → GeP2
  | 0, _, r => step ai bi as[0] bs[0] r
  | i + 1, h, r => ladder ai bi as bs i (by omega) (step ai bi as[i + 1] bs[i + 1] r)

/-- Blocks the main loop's callees allocate from `i` down: one per `ge25519_p2_dbl` and per add. -/
def ladderBlocks (as bs : Vector (BitVec 8) 256) : (i : Nat) → i < 256 → Nat
  | 0, _ => 1 + digitBlocks as[0] 1 + digitBlocks bs[0] 1
  | i + 1, h =>
    1 + digitBlocks as[i + 1] 1 + digitBlocks bs[i + 1] 1 + ladderBlocks as bs i (by omega)

end ge25519_double_scalarmult_vartime

open ge25519_double_scalarmult_vartime in
/-- `[a] A + [b] B` as the code computes it: the slides, the table `Ai` of `A`'s odd multiples, then
the main loop from the first non-zero digit on the neutral point. -/
noncomputable def ge25519_double_scalarmult_vartime.spec (a : BitVec 256) (A : GeP3)
    (b : BitVec 256) : GeP2 :=
  let as := Boringssl.slide.spec a
  let bs := Boringssl.slide.spec b
  match start as bs 255 (by decide) with
  | some i => ladder (aiTbl A) biTbl as bs i i.isLt Boringssl.ge_p2_0.spec
  | none => Boringssl.ge_p2_0.spec

open ge25519_double_scalarmult_vartime in
/-- The blocks the function allocates, its callees' included: 15 before the main loop. -/
def ge25519_double_scalarmult_vartime.blocks (a b : BitVec 256) : Nat :=
  let as := Boringssl.slide.spec a
  let bs := Boringssl.slide.spec b
  15 +
    match start as bs 255 (by decide) with
    | some i => ladderBlocks as bs i i.isLt
    | none => 0

end

public theorem ge25519_double_scalarmult_vartime_Bi.value_eq (s : GlobalState) :
    ge25519_double_scalarmult_vartime_Bi.value s =
      .value (Ty.wrap ge25519_double_scalarmult_vartime_Bi.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-! ## Proof -/

section Proof

namespace ge25519_double_scalarmult_vartime

/-! ### Objects in memory -/

/-! ### Transport past the loop's stores -/

section Transport

variable {m : MemoryState} {p q : Pointer}

end Transport

/-! ### Digits and indices -/

attribute [local mlir_transport] SlidesAt.storeP1p1 SlidesAt.storeP3 SlidesAt.storeP2
  SlidesAt.storeCached CachedTable.storeP1p1 CachedTable.storeP3 CachedTable.storeP2
  PrecompTable.storeP1p1 PrecompTable.storeP3 PrecompTable.storeP2 PrecompTable.storeCached
  SlidesAt.storeCached_add PrecompTable.storeCached_add

/-! ### The main loop -/

/-- The registers the loops read, their counters aside. -/
abbrev LoopRegs (aslide bslide ai bi t u a2 : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%2669 := 0#8, %2670 := 4294967295#32, %2671 := 1#8, %2672 := bi, %2673 :=
    18446744073709551615#64, %2674 := 0#64, %2675 := 4294967294#32, %2676 := 0#32, %2677 := aslide,
    %2678 := bslide, %2679 := ai, %2680 := t, %2681 := u, %2682 := a2]

open ge25519_double_scalarmult_vartime in
/-- `^bb8`, an iteration's start at `i`: `t = 2 r`, then `aslide[i]`'s add; on to `^bb12`. -/
theorem headA_block (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (AI : Nat → GeCached) (BI : Nat → GePrecomp) (N : Nat) (hL : Layout r t u aslide bslide ai bi)
    (hNt : N ≤ t.id.id) (hNu : N ≤ u.id.id) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hdig : -15 ≤ as[i].toInt ∧ as[i].toInt ≤ 15)
    (R : GeP2) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRi : E ⊨ [%2711 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r t u aslide bslide ai bi as bs AI BI) (hrv : S.mem.readP2 r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
          LoopRegs aslide bslide ai bi t u a2 E' →
          (E' ⊨ [%2711 := BitVec.ofNat 64 i]) →
          LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
          S'.mem.PointFit t →
          S'.mem.readP1p1 t = addA AI as[i] (ge25519_p2_dbl.spec R) →
          S'.mem.readP2 r = R →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 1 + digitBlocks as[i] 1 →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (ge25519_double_scalarmult_vartime.runFrom E' ^bb12 S' >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb8 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, hu, hsa, hsb, hta, htb⟩ := hF
  have htw : Writable S.mem t := ht.2.1.2.1.writable
  have hrt := hL.rt
  have hru := hL.ru
  have htu := hL.tu
  have hta' := hL.ta
  have htb' := hL.tb
  have htai := hL.tai
  have htbi := hL.tbi
  have hua := hL.ua
  have hub := hL.ub
  have huai := hL.uai
  have hubi := hL.ubi
  have haso := hL.aso
  have haio := hL.aio
  obtain ⟨hf, hdv⟩ := hsa i hi
  block_init
  step_call using ge25519_p2_dbl.call_eq
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show i < 2 ^ 64 by omega]
  step_load with transparent d hd_eq consuming hf hdv
  step_pure
  finish_block
  case isTrue =>
    obtain ⟨k, hk⟩ : ∃ k, (as[i] >>> 1).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := hk ▸ idx_lt_pos hbr hdig.2
    obtain ⟨hAf, hAr⟩ := hta k hk8
    block_init
    step_call using ge25519_p1p1_to_p3.call_eq
    step_pure
    step_pure
    step_pure [idx160, hk, show 160 * k < 2 ^ 64 by omega]
    step_call using ge25519_add.call_eq
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, by mem_fact, ht.room (by mem_fact), hu.room (by mem_fact), hsa, hsb, hta, htb⟩ ht
        ?_ hrv ?_ ?_
    · rw [hread_t]
      simp only [addA, hbr, ↓reduceIte, hk]
    · rw [hS]
      simp only [digitBlocks, ne_zero_of_pos hbr, ↓reduceIte]
    · rw [hS]
      simp only [MemoryState.eraseFrom_storeP1p1_of_le hNt, MemoryState.eraseFrom_storeP3_of_le hNu]
  case isFalse =>
    have hnpos := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      have hneg := hbr
      block_init
      step_call using ge25519_p1p1_to_p3.call_eq
      step_pure with nd
      obtain ⟨k, hk⟩ : ∃ k, (nd >>> 1).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := hk ▸ hnd ▸ idx_lt_neg hneg hdig.1
      obtain ⟨hAf, hAr⟩ := hta k hk8
      step_pure
      step_pure
      step_pure [idx160, hk, show 160 * k < 2 ^ 64 by omega]
      step_call using ge25519_sub.call_eq
      finish_block
      refine
        hK E S hArgs (by env_reads) (by env_reads)
          ⟨hwf, hr, by mem_fact, ht.room (by mem_fact), hu.room (by mem_fact), hsa, hsb, hta, htb⟩
          ht ?_ hrv ?_ ?_
      · rw [hread_t]
        simp only [addA, hnpos, hneg, Bool.false_eq_true, ↓reduceIte, ← hnd, hk]
      · rw [hS]
        simp only [digitBlocks, ne_zero_of_neg hneg, ↓reduceIte]
      · rw [hS]
        simp only [MemoryState.eraseFrom_storeP1p1_of_le hNt,
          MemoryState.eraseFrom_storeP3_of_le hNu]
    case isFalse =>
      have h0 := eq_zero_of_not hnpos hbr
      refine
        hK E S hArgs (by env_reads) (by env_reads)
          ⟨hwf, hr, by mem_fact, ht.room (by mem_fact), hu, hsa, hsb, hta, htb⟩ ht ?_ hrv ?_ ?_
      · rw [hread_t]
        simp only [addA, h0, show (0#8).slt 0#8 = false from rfl, Bool.false_eq_true, ↓reduceIte]
      · rw [hS]
        simp only [digitBlocks, h0, ↓reduceIte, Nat.add_zero]
      · rw [hS]
        simp only [MemoryState.eraseFrom_storeP1p1_of_le hNt]

open ge25519_double_scalarmult_vartime in
/-- `^bb12`: `bslide[i]`'s add on `t`; on to `^bb16`. -/
theorem headB_block (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (AI : Nat → GeCached) (BI : Nat → GePrecomp) (N : Nat) (hL : Layout r t u aslide bslide ai bi)
    (hNt : N ≤ t.id.id) (hNu : N ≤ u.id.id) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hdig : -15 ≤ bs[i].toInt ∧ bs[i].toInt ≤ 15)
    (R : GeP2) (T : GeP1p1) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRi : E ⊨ [%2711 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r t u aslide bslide ai bi as bs AI BI) (htf : S.mem.PointFit t)
    (htv : S.mem.readP1p1 t = T) (hrv : S.mem.readP2 r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
          LoopRegs aslide bslide ai bi t u a2 E' →
          (E' ⊨ [%2711 := BitVec.ofNat 64 i]) →
          LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
          S'.mem.PointFit t →
          S'.mem.readP1p1 t = addB BI bs[i] T →
          S'.mem.readP2 r = R →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + digitBlocks bs[i] 1 →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (ge25519_double_scalarmult_vartime.runFrom E' ^bb16 S' >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb12 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, hu, hsa, hsb, hta, htb⟩ := hF
  have htw : Writable S.mem t := ht.2.1.2.1.writable
  have hrt := hL.rt
  have hru := hL.ru
  have htu := hL.tu
  have hta' := hL.ta
  have htb' := hL.tb
  have htai := hL.tai
  have htbi := hL.tbi
  have hua := hL.ua
  have hub := hL.ub
  have huai := hL.uai
  have hubi := hL.ubi
  have hbso := hL.bso
  have hbio := hL.bio
  obtain ⟨hf, hdv⟩ := hsb i hi
  clear ht
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show i < 2 ^ 64 by omega]
  step_load with transparent d hd_eq consuming hf hdv
  step_pure
  finish_block
  case isTrue =>
    obtain ⟨k, hk⟩ : ∃ k, (bs[i] >>> 1).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := hk ▸ idx_lt_pos hbr hdig.2
    obtain ⟨hBf, hBr⟩ := htb k hk8
    block_init
    step_call using ge25519_p1p1_to_p3.call_eq
    step_pure
    step_pure
    step_pure [idx120, hk, show 120 * k < 2 ^ 64 by omega]
    step_call using ge25519_madd.call_eq
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, by mem_fact, htf.room (by mem_fact), hu.room (by mem_fact), hsa, hsb, hta, htb⟩
        htf ?_ hrv ?_ ?_
    · rw [hread_t]
      simp only [addB, hbr, ↓reduceIte, hk]
    · rw [hS]
      simp only [digitBlocks, ne_zero_of_pos hbr, ↓reduceIte]
    · rw [hS]
      simp only [MemoryState.eraseFrom_storeP1p1_of_le hNt, MemoryState.eraseFrom_storeP3_of_le hNu]
  case isFalse =>
    have hnpos := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      have hneg := hbr
      block_init
      step_call using ge25519_p1p1_to_p3.call_eq
      step_pure with nd
      obtain ⟨k, hk⟩ : ∃ k, (nd >>> 1).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := hk ▸ hnd ▸ idx_lt_neg hneg hdig.1
      obtain ⟨hBf, hBr⟩ := htb k hk8
      step_pure
      step_pure
      step_pure [idx120, hk, show 120 * k < 2 ^ 64 by omega]
      step_call using ge25519_msub.call_eq
      finish_block
      refine
        hK E S hArgs (by env_reads) (by env_reads)
          ⟨hwf, hr, by mem_fact, htf.room (by mem_fact), hu.room (by mem_fact), hsa, hsb, hta, htb⟩
          htf ?_ hrv ?_ ?_
      · rw [hread_t]
        simp only [addB, hnpos, hneg, Bool.false_eq_true, ↓reduceIte, ← hnd, hk]
      · rw [hS]
        simp only [digitBlocks, ne_zero_of_neg hneg, ↓reduceIte]
      · rw [hS]
        simp only [MemoryState.eraseFrom_storeP1p1_of_le hNt,
          MemoryState.eraseFrom_storeP3_of_le hNu]
    case isFalse =>
      have h0 := eq_zero_of_not hnpos hbr
      refine
        hK E S hArgs (by env_reads) (by env_reads)
          ⟨hwf, hr, by mem_fact, htf.room (by mem_fact), hu, hsa, hsb, hta, htb⟩ htf ?_ hrv ?_ ?_
      · rw [htv]
        simp only [addB, h0, show (0#8).slt 0#8 = false from rfl, Bool.false_eq_true, ↓reduceIte]
      · rw [hS]
        simp only [digitBlocks, h0, ↓reduceIte, Nat.add_zero]
      · rw [hS]

open ge25519_double_scalarmult_vartime in
/-- `^bb16`: `r = t` as a `ge25519_p2`; then out at `i = 0`, or around at `i - 1`. -/
theorem tail_block (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (AI : Nat → GeCached) (BI : Nat → GePrecomp) (N : Nat) (hL : Layout r t u aslide bslide ai bi)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256) (T : GeP1p1)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRi : E ⊨ [%2711 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r t u aslide bslide ai bi as bs AI BI) (htf : S.mem.PointFit t)
    (htv : S.mem.readP1p1 t = T)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
            LoopRegs aslide bslide ai bi t u a2 E' →
            LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
            S'.mem.readP2 r = ge25519_p1p1_to_p2.spec T →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock →
            S'.mem.eraseFrom N = (S.mem.eraseFrom N).storeP2 r (ge25519_p1p1_to_p2.spec T) →
            (ge25519_double_scalarmult_vartime.runFrom E' ^bb17 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
              LoopRegs aslide bslide ai bi t u a2 E' →
              (E' ⊨ [%2711 := BitVec.ofNat 64 j]) →
              LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
              S'.mem.readP2 r = ge25519_p1p1_to_p2.spec T →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock →
              S'.mem.eraseFrom N = (S.mem.eraseFrom N).storeP2 r (ge25519_p1p1_to_p2.spec T) →
              (ge25519_double_scalarmult_vartime.runFrom E' ^bb8 S' >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb16 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, hu, hsa, hsb, hta, htb⟩ := hF
  have htw : Writable S.mem t := ht.2.1.2.1.writable
  have hrt := hL.rt
  have hru := hL.ru
  have hra := hL.ra
  have hrb := hL.rb
  have hrai := hL.rai
  have hrbi := hL.rbi
  clear ht
  block_init
  step_call using ge25519_p1p1_to_p2.call_eq
  step_pure [saddOverflow_neg_one64 (show i < 2 ^ 63 by omega)]
  step_pure
  finish_block
  case
    isTrue =>
    have hi1 : 1 ≤ i := by
      by_contra h0
      obtain rfl : i = 0 := by omega
      exact absurd hbr (by decide)
    refine
      hback (i - 1) (by omega) E S hArgs (by env_reads) ?_
        ⟨hwf, hr, by mem_fact, htf.room (by mem_fact), hu, hsa, hsb, hta, htb⟩ hread_r (by rw [hS])
        ?_
    · rw [← Firedancer.add_neg_one64 hi1 (by omega)]
      env_reads
    · rw [hS, MemoryState.eraseFrom_storeP2]
  case isFalse =>
    have hi0 := eq_zero_of_not_slt64 (by omega) hbr
    refine
      hexit hi0 E S hArgs (by env_reads)
        ⟨hwf, hr, by mem_fact, htf.room (by mem_fact), hu, hsa, hsb, hta, htb⟩ hread_r (by rw [hS])
        ?_
    rw [hS, MemoryState.eraseFrom_storeP2]

open ge25519_double_scalarmult_vartime in
/-- An iteration of the main loop at `i`: `r` becomes `step` of it. -/
theorem main_iter (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (AI : Nat → GeCached) (BI : Nat → GePrecomp) (N : Nat) (hL : Layout r t u aslide bslide ai bi)
    (hNt : N ≤ t.id.id) (hNu : N ≤ u.id.id)
    (hwA : ∀ k (hk : k < 256), -15 ≤ as[k].toInt ∧ as[k].toInt ≤ 15)
    (hwB : ∀ k (hk : k < 256), -15 ≤ bs[k].toInt ∧ bs[k].toInt ≤ 15)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256) (R : GeP2)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRi : E ⊨ [%2711 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r t u aslide bslide ai bi as bs AI BI) (hrv : S.mem.readP2 r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
            LoopRegs aslide bslide ai bi t u a2 E' →
            LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
            S'.mem.readP2 r = step AI BI as[i] bs[i] R →
            S'.alloc.nextFreeBlock =
              S.alloc.nextFreeBlock + 1 + digitBlocks as[i] 1 + digitBlocks bs[i] 1 →
            S'.mem.eraseFrom N = (S.mem.eraseFrom N).storeP2 r (step AI BI as[i] bs[i] R) →
            (ge25519_double_scalarmult_vartime.runFrom E' ^bb17 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
              LoopRegs aslide bslide ai bi t u a2 E' →
              (E' ⊨ [%2711 := BitVec.ofNat 64 j]) →
              LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
              S'.mem.readP2 r = step AI BI as[i] bs[i] R →
              S'.alloc.nextFreeBlock =
                S.alloc.nextFreeBlock + 1 + digitBlocks as[i] 1 + digitBlocks bs[i] 1 →
              S'.mem.eraseFrom N = (S.mem.eraseFrom N).storeP2 r (step AI BI as[i] bs[i] R) →
              (ge25519_double_scalarmult_vartime.runFrom E' ^bb8 S' >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb8 S >>= g) = K := by
  refine
    headA_block r a A b aslide bslide ai bi t u a2 as bs AI BI N hL hNt hNu g K i hi (hwA i hi) R S
      E hArgs hR hRi hF hrv fun E₁ S₁ h₁ hR₁ hRi₁ hF₁ htf₁ htv₁ hrv₁ ha₁ he₁ => ?_
  refine
    headB_block r a A b aslide bslide ai bi t u a2 as bs AI BI N hL hNt hNu g K i hi (hwB i hi) R _
      S₁ E₁ h₁ hR₁ hRi₁ hF₁ htf₁ htv₁ hrv₁ fun E₂ S₂ h₂ hR₂ hRi₂ hF₂ htf₂ htv₂ _ ha₂ he₂ => ?_
  refine
    tail_block r a A b aslide bslide ai bi t u a2 as bs AI BI N hL g K i hi _ S₂ E₂ h₂ hR₂ hRi₂ hF₂
      htf₂ htv₂ (fun h0 E₃ S₃ h₃ hR₃ hF₃ hrv₃ ha₃ he₃ => ?_)
      fun j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ hrv₃ ha₃ he₃ => ?_
  · exact
      hexit h0 E₃ S₃ h₃ hR₃ hF₃ hrv₃ (by omega)
        (by
          rw [he₃, he₂, he₁]; rfl)
  · exact
      hback j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ hrv₃ (by omega)
        (by
          rw [he₃, he₂, he₁]; rfl)

open ge25519_double_scalarmult_vartime in
/-- The main loop from `^bb8` at `i`: `r` the ladder from `i` down. -/
theorem main_loop (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (AI : Nat → GeCached) (BI : Nat → GePrecomp) (N : Nat) (hL : Layout r t u aslide bslide ai bi)
    (hNt : N ≤ t.id.id) (hNu : N ≤ u.id.id)
    (hwA : ∀ k (hk : k < 256), -15 ≤ as[k].toInt ∧ as[k].toInt ≤ 15)
    (hwB : ∀ k (hk : k < 256), -15 ≤ bs[k].toInt ∧ bs[k].toInt ≤ 15)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (R : GeP2) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value A) (.value b)).get →
        LoopRegs aslide bslide ai bi t u a2 E →
        (E ⊨ [%2711 := BitVec.ofNat 64 i]) →
        LoopFacts S r t u aslide bslide ai bi as bs AI BI →
        S.mem.readP2 r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
            LoopRegs aslide bslide ai bi t u a2 E' →
            LoopFacts S' r t u aslide bslide ai bi as bs AI BI →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks as bs i hi →
            S'.mem.eraseFrom N = (S.mem.eraseFrom N).storeP2 r (ladder AI BI as bs i hi R) →
            (ge25519_double_scalarmult_vartime.runFrom E' ^bb17 S' >>= g) = K) →
        (ge25519_double_scalarmult_vartime.runFrom E ^bb8 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter r a A b aslide bslide ai bi t u a2 as bs AI BI N hL hNt hNu hwA hwB g K 0 hi R S E
        hArgs hR hRi hF hrv (fun _ E' S' h₁ hR' hF' _ ha he => ?_) fun j hj => absurd hj (by omega)
    exact
      hK E' S' h₁ hR' hF'
        (by
          rw [ha]; simp only [ladderBlocks, Nat.add_assoc])
        he
  | succ j ih =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter r a A b aslide bslide ai bi t u a2 as bs AI BI N hL hNt hNu hwA hwB g K (j + 1) hi R
        S E hArgs hR hRi hF hrv (fun h => absurd h (by omega))
        fun j' hj E' S' h₁ hR' hRi' hF' hrv' ha he => ?_
    obtain rfl : j = j' := by omega
    refine ih (by omega) _ S' E' h₁ hR' hRi' hF' hrv' fun E'' S'' h₂ hR'' hF'' ha' he' => ?_
    refine
      hK E'' S'' h₂ hR'' hF''
        (by
          rw [ha', ha]; simp only [ladderBlocks]; omega)
        ?_
    rw [he', he, storeP2_storeP2_self hF.fitR.1]
    rfl

/-! ### The zero-digit search -/

/-- `^bb6`, a non-zero digit at `j`: on to the main loop at `j`. -/
theorem found_block (r a A b aslide bslide ai bi t u a2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (j : Nat) (hj : j < 256)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRj : E ⊨ [%2708 := BitVec.ofNat 32 j])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
          LoopRegs aslide bslide ai bi t u a2 E' →
          (E' ⊨ [%2711 := BitVec.ofNat 64 j]) →
          (ge25519_double_scalarmult_vartime.runFrom E' ^bb8 S >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb6 S >>= g) = K := by
  block_init
  step_pure [Firedancer.slt_neg_one32 (show j < 2 ^ 31 by omega)]
  finish_block
  block_init
  step_pure [Firedancer.msb_ofNat32 (show j < 2 ^ 31 by omega),
    Firedancer.setWidth_ofNat32 (show j < 2 ^ 32 by omega)]
  finish_block
  exact hK E hArgs (by env_reads) (by env_reads)

/-- `^bb1`, the zero-digit search at `i` and `i - 1`, `i` odd: on to the main loop at a non-zero
digit, out after `0`, else around at `i - 2`. -/
theorem skip_iter (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hodd : i % 2 = 1) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs aslide bslide ai bi t u a2 E) (hRi : E ⊨ [%2690 := BitVec.ofNat 32 i])
    (hsa : SlidesAt S.mem aslide as) (hsb : SlidesAt S.mem bslide bs)
    (hfound :
      ∀ j (hj : j < 256),
        (j = i ∨ j + 1 = i ∧ as[i] = 0#8 ∧ bs[i] = 0#8) →
          ¬(as[j] = 0#8 ∧ bs[j] = 0#8) →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
              LoopRegs aslide bslide ai bi t u a2 E' →
              (E' ⊨ [%2711 := BitVec.ofNat 64 j]) →
              (ge25519_double_scalarmult_vartime.runFrom E' ^bb8 S >>= g) = K)
    (hnone :
      as[i] = 0#8 ∧ bs[i] = 0#8 →
        as[i - 1] = 0#8 ∧ bs[i - 1] = 0#8 →
        i = 1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
            LoopRegs aslide bslide ai bi t u a2 E' →
            (ge25519_double_scalarmult_vartime.runFrom E' ^bb17 S >>= g) = K)
    (hback :
      as[i] = 0#8 ∧ bs[i] = 0#8 →
        as[i - 1] = 0#8 ∧ bs[i - 1] = 0#8 →
        3 ≤ i →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
            LoopRegs aslide bslide ai bi t u a2 E' →
            (E' ⊨ [%2690 := BitVec.ofNat 32 (i - 2)]) →
            (ge25519_double_scalarmult_vartime.runFrom E' ^bb1 S >>= g) = K) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb1 S >>= g) = K := by
  obtain ⟨hfa, hra⟩ := hsa i hi
  obtain ⟨hfb, hrb⟩ := hsb i hi
  obtain ⟨hfa', hra'⟩ := hsa (i - 1) (by omega)
  obtain ⟨hfb', hrb'⟩ := hsb (i - 1) (by omega)
  clear hsa hsb
  have hi1 : 1 ≤ i := by omega
  block_init
  step_pure [Firedancer.msb_ofNat32 (show i < 2 ^ 31 by omega),
    Firedancer.setWidth_ofNat32 (show i < 2 ^ 32 by omega)]
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show i < 2 ^ 64 by omega]
  step_load consuming hfa hra
  step_pure
  finish_block
  case isFalse =>
    subst hS
    exact
      found_block r a A b aslide bslide ai bi t u a2 g K i hi _ E hArgs (by env_reads)
        (by env_reads) (hfound i hi (.inl rfl) fun h => hbr h.1)
  have ha0 := hbr
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show i < 2 ^ 64 by omega]
  step_load consuming hfb hrb
  step_pure
  finish_block
  case isFalse =>
    subst hS
    exact
      found_block r a A b aslide bslide ai bi t u a2 g K i hi _ E hArgs (by env_reads)
        (by env_reads) (hfound i hi (.inl rfl) fun h => hbr h.2)
  have hb0 := hbr
  block_init
  step_pure [Firedancer.saddOverflow_neg_one32 (show i < 2 ^ 31 by omega),
    Firedancer.add_neg_one32 hi1 (show i < 2 ^ 32 by omega)]
  step_pure [Firedancer.msb_ofNat32 (show i - 1 < 2 ^ 31 by omega),
    Firedancer.setWidth_ofNat32 (show i - 1 < 2 ^ 32 by omega)]
  step_pure [Nat.mod_eq_of_lt (show i - 1 < 2 ^ 64 by omega), show i - 1 < 2 ^ 64 by omega]
  step_load consuming hfa' hra'
  step_pure
  finish_block
  case isFalse =>
    subst hS
    exact
      found_block r a A b aslide bslide ai bi t u a2 g K (i - 1) (by omega) _ E hArgs (by env_reads)
        (by env_reads) (hfound (i - 1) (by omega) (.inr ⟨by omega, ha0, hb0⟩) fun h => hbr h.1)
  have ha1 := hbr
  block_init
  step_pure [Nat.mod_eq_of_lt (show i - 1 < 2 ^ 64 by omega), show i - 1 < 2 ^ 64 by omega]
  step_load consuming hfb' hrb'
  step_pure
  finish_block
  case isFalse =>
    subst hS
    exact
      found_block r a A b aslide bslide ai bi t u a2 g K (i - 1) (by omega) _ E hArgs (by env_reads)
        (by env_reads) (hfound (i - 1) (by omega) (.inr ⟨by omega, ha0, hb0⟩) fun h => hbr h.2)
  have hb1 := hbr
  block_init
  step_pure [saddOverflow_neg_two32 (show i < 2 ^ 31 by omega)]
  step_pure
  finish_block
  case isTrue =>
    subst hS
    have hi0 : i = 1 := by
      have := Firedancer.eq_zero_of_ofNat32 (i := i - 1) (by omega) hbr
      omega
    exact hnone ⟨ha0, hb0⟩ ⟨ha1, hb1⟩ hi0 E hArgs (by env_reads)
  case isFalse =>
    subst hS
    have hi3 : 3 ≤ i := by
      rcases Nat.lt_or_ge i 3 with h | h
      · obtain rfl : i = 1 := by omega
        exact absurd rfl hbr
      · exact h
    refine hback ⟨ha0, hb0⟩ ⟨ha1, hb1⟩ hi3 E hArgs (by env_reads) ?_
    rw [← add_neg_two32 (by omega) (by omega)]
    env_reads

open ge25519_double_scalarmult_vartime in
open ge25519_double_scalarmult_vartime in
open ge25519_double_scalarmult_vartime in
/-- The zero-digit search from `^bb1` at `2 m + 1`: the main loop from `start`, or out without
one. -/
theorem skip_loop (r a A b aslide bslide ai bi t u a2 : Pointer) (as bs : Vector (BitVec 8) 256)
    (S : GlobalState)
    (hsa : SlidesAt S.mem aslide as) (hsb : SlidesAt S.mem bslide bs)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m (hm : 2 * m + 1 < 256) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value A) (.value b)).get →
        LoopRegs aslide bslide ai bi t u a2 E →
        (E ⊨ [%2690 := BitVec.ofNat 32 (2 * m + 1)]) →
        (∀ j,
          start as bs (2 * m + 1) hm = some j →
            ∀ E' : ⟪Γ⟫,
              E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
                LoopRegs aslide bslide ai bi t u a2 E' →
                (E' ⊨ [%2711 := BitVec.ofNat 64 j.val]) →
                (ge25519_double_scalarmult_vartime.runFrom E' ^bb8 S >>= g) = K) →
        (start as bs (2 * m + 1) hm = none →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value a) (.value A) (.value b)).get →
              LoopRegs aslide bslide ai bi t u a2 E' →
              (ge25519_double_scalarmult_vartime.runFrom E' ^bb17 S >>= g) = K) →
        (ge25519_double_scalarmult_vartime.runFrom E ^bb1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro hm E hArgs hR hRi hfound hnone
    refine
      skip_iter r a A b aslide bslide ai bi t u a2 as bs g K 1 hm rfl S E hArgs hR hRi hsa
        hsb (fun j hj hji hnz => ?_) (fun h1 h0 _ => hnone ?_) fun _ _ h => absurd h (by omega)
    · rcases hji with rfl | ⟨hj1, h1⟩
      · exact hfound ⟨1, hj⟩ (start_succ_ne (i := 0) hj hnz)
      · obtain rfl : j = 0 := by omega
        refine hfound ⟨0, hj⟩ ((start_succ_zero (i := 0) hm h1).trans ?_)
        rw [start]
        simp only [hnz, ↓reduceIte]
        rfl
    · rw [start_succ_zero (i := 0) hm h1, start]
      simp only [h0, and_self, ↓reduceIte]
  | succ m ih =>
    intro hm E hArgs hR hRi hfound hnone
    refine
      skip_iter r a A b aslide bslide ai bi t u a2 as bs g K _ hm (by omega) S E hArgs hR
        hRi hsa hsb (fun j hj hji hnz => ?_) (fun _ _ h => absurd h (by omega))
        fun h1 h0 _ E' h₁ h₂ h₃ => ?_
    · rcases hji with rfl | ⟨hj1, h1⟩
      · exact hfound ⟨_, hj⟩ (start_succ_ne (i := 2 * m + 2) hm hnz)
      · obtain rfl : j = 2 * m + 2 := by omega
        exact
          hfound ⟨_, hj⟩
            ((start_succ_zero (i := 2 * m + 2) hm h1).trans (start_succ_ne (i := 2 * m + 1) hj hnz))
    · have e : start as bs (2 * (m + 1) + 1) hm = start as bs (2 * m + 1) (by omega) :=
        (start_succ_zero (i := 2 * m + 2) hm h1).trans (start_succ_zero (i := 2 * m + 1) _ h0)
      exact
        ih (by omega) E' h₁ h₂ h₃ (fun j hj => hfound j (e.trans hj)) fun hj => hnone (e.trans hj)

/-! ### The table `Ai` -/

/-- `u` before entry `j` of `Ai`: `A2 + Ai[j - 1]` as a `ge25519_p3`. -/
def tableU (P : GeP3) (j : Nat) : GeP3 :=
  ge25519_p1p1_to_p3.spec (ge25519_add.spec (A2 P) (aiTbl P (j - 1)))

/-- One step of the table: `k = ai + off`, `ge25519_p3_to_cached(k, u)`,
`ge25519_add(t, a2, k)`, `ge25519_p1p1_to_p3(u, t)`. -/
def tableRun (ai u t a2 k : Dst Γ .ptr) (off : Nat) : List (Instr Γ) :=
  [.unop (.gepConst { nusw := true, nuw := true } (Int.ofNat off)) k (.val ai.i ai.h),
    .call ge25519_p3_to_cached.call (.cons (.val k.i k.h) (.cons (.val u.i u.h) .nil)) .nil,
    .call ge25519_add.call
      (.cons (.val t.i t.h) (.cons (.val a2.i a2.h) (.cons (.val k.i k.h) .nil))) .nil,
    .call ge25519_p1p1_to_p3.call (.cons (.val u.i u.h) (.cons (.val t.i t.h) .nil)) .nil]

/-- Where the body at `pos` is `tableRun`: on from `pos + 4` with the cached `u` at `AI + off`, `t`
its sum with `A2` and `u` that as a `ge25519_p3`. -/
theorem runBodyFrom_tableRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {ai u t a2 k : Dst Γ .ptr} {off : Nat} {rest : List (Instr Γ)} {AI U T A2 : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = tableRun ai u t a2 k off ++ rest)
    (hR : E ⊨ [ai := AI, u := U, t := T, a2 := A2]) (hd : [k.i, ai.i, u.i, t.i, a2.i].Nodup)
    (hwf : S.WF) (hg : S.mem.Globals ge25519_double_scalarmult_vartime.globals)
    (hU : S.mem.PointFit U) (hUw : Writable S.mem U) (hT : S.mem.PointRoom T)
    (hA2 : S.mem.PointFit A2)
    (hAI : S.mem.PointRoom (AI.add (BitVec.ofNat 64 off))) (hAIo : AI.offset = 0)
    (hoff : off < 4294967296) (hAU : AI.id ≠ U.id) (hAT : AI.id ≠ T.id) (hAA : AI.id ≠ A2.id)
    (hTU : T.id ≠ U.id) (hTA : T.id ≠ A2.id)
    (hK :
      ∀ vk,
        (blk.runBodyFrom E[k := vk] (pos + 4)
              { alloc := ⟨S.alloc.nextFreeBlock + 1⟩,
                mem :=
                  ((S.mem.storeCached (AI.add (BitVec.ofNat 64 off))
                            (ge25519_p3_to_cached.spec (S.mem.readP3 U))).storeP1p1
                        T
                        (ge25519_add.spec (S.mem.readP3 A2)
                          (ge25519_p3_to_cached.spec (S.mem.readP3 U)))).storeP3
                    U
                    (ge25519_p1p1_to_p3.spec
                      (ge25519_add.spec (S.mem.readP3 A2)
                        (ge25519_p3_to_cached.spec (S.mem.readP3 U)))) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [hoff]
  step_call using ge25519_p3_to_cached.call_eq
  step_call using ge25519_add.call_eq
  step_call using ge25519_p1p1_to_p3.call_eq
  rw [hE, hS]
  exact hK _

/-- What the table loop keeps before entry `j`: entries below `j` in place, room for the others,
`u` and `A2` as computed, and what the main loop needs besides. -/
structure TablePhase (S : GlobalState) (r t u aslide bslide ai bi a2 : Pointer)
    (as bs : Vector (BitVec 8) 256) (P : GeP3) (n₀ N : Nat) (M : MemoryState) (j : Nat) : Prop where
  wf : S.WF
  alloc : S.alloc.nextFreeBlock = n₀ + (j - 1)
  erase : S.mem.eraseFrom N = M
  tbl : CachedTable S.mem ai j (aiTbl P)
  room : ∀ k, j ≤ k → k < 8 → S.mem.PointRoom (ai.add (BitVec.ofNat 64 (160 * k)))
  globals : S.mem.Globals ge25519_double_scalarmult_vartime.globals
  fitU : S.mem.PointFit u
  writU : Writable S.mem u
  valU : S.mem.readP3 u = tableU P j
  roomT : S.mem.PointRoom t
  fitA2 : S.mem.PointFit a2
  valA2 : S.mem.readP3 a2 = A2 P
  roomR : S.mem.Fe3Room r
  slidesA : SlidesAt S.mem aslide as
  slidesB : SlidesAt S.mem bslide bs
  tblB : PrecompTable S.mem bi 8 biTbl

/-- `TablePhase` past a table step at entry `j`. -/
theorem TablePhase.step {S : GlobalState}
    (h : TablePhase S r t u aslide bslide ai bi a2 as bs P n₀ N M j)
    (hL : TableLayout r t u aslide bslide ai bi a2 N) (hj : 1 ≤ j) (hj8 : j < 8) :
    TablePhase
      { alloc := ⟨S.alloc.nextFreeBlock + 1⟩,
        mem :=
          ((S.mem.storeCached (ai.add (BitVec.ofNat 64 (160 * j)))
                    (ge25519_p3_to_cached.spec (S.mem.readP3 u))).storeP1p1
                t
                (ge25519_add.spec (S.mem.readP3 a2)
                  (ge25519_p3_to_cached.spec (S.mem.readP3 u)))).storeP3
            u
            (ge25519_p1p1_to_p3.spec
              (ge25519_add.spec (S.mem.readP3 a2) (ge25519_p3_to_cached.spec (S.mem.readP3 u)))) }
      r t u aslide bslide ai bi a2 as bs P n₀ N M (j + 1) := by
  have hai' (c : BitVec 64) : (ai.add c).id = ai.id := rfl
  have hroom := h.room j le_rfl hj8
  have hcu : ge25519_p3_to_cached.spec (S.mem.readP3 u) = aiTbl P j := by
    rw [h.valU]
    obtain ⟨j', rfl⟩ : ∃ j', j = j' + 1 := ⟨j - 1, by omega⟩
    rfl
  rw [hcu, h.valA2]
  have hp : ai.offset.toNat + 1280 ≤ 2 ^ 64 := by
    rw [hL.aio]; decide
  refine
    { wf := GlobalState.WF.tableStep h.wf
      alloc := by
        rw [h.alloc]
        dsimp only
        omega
      erase := by
        rw [MemoryState.eraseFrom_storeP3_of_le hL.Nu, MemoryState.eraseFrom_storeP1p1_of_le hL.Nt,
          MemoryState.eraseFrom_storeCached_of_le
            (by
              rw [hai']; exact hL.Nai)]
        exact h.erase
      tbl := fun k hk => ?_
      room := fun k hk hk8 => (h.room k (by omega) hk8).storeCached.storeP1p1.storeP3
      globals := h.globals.mono rfl fun _ h => h
      fitU := MemoryState.PointFit.storeP3_self (h.fitU.room h.writU).storeCached.storeP1p1
      writU := h.writU.storeCached.storeP1p1.storeP3
      valU := by
        rw [MemoryState.readP3_storeP3_self (h.fitU.room h.writU).storeCached.storeP1p1]
        rfl
      roomT := h.roomT.storeCached.storeP1p1.storeP3
      fitA2 := h.fitA2.storeCached.storeP1p1.storeP3
      valA2 := by
        rw [MemoryState.readP3_storeP3_of_id_ne hL.ua2,
          MemoryState.readP3_storeP1p1_of_id_ne hL.ta2,
          MemoryState.readP3_storeCached_of_id_ne
            (by
              rw [hai']; exact hL.aia2)]
        exact h.valA2
      roomR := h.roomR.storeCached.storeP1p1.storeP3
      slidesA :=
        ((h.slidesA.storeCached
                  (by
                    rw [hai']; exact hL.aia)).storeP1p1
              hL.ta).storeP3
          hL.ua
      slidesB :=
        ((h.slidesB.storeCached
                  (by
                    rw [hai']; exact hL.aib)).storeP1p1
              hL.tb).storeP3
          hL.ub
      tblB :=
        ((h.tblB.storeCached
                  (by
                    rw [hai']; exact hL.aibi)).storeP1p1
              hL.tbi).storeP3
          hL.ubi }
  have hne (q : Pointer) (hq : q.id = ai.id) : t.id ≠ q.id ∧ u.id ≠ q.id :=
    ⟨hq ▸ hL.ait.symm, hq ▸ hL.aiu.symm⟩
  rw [MemoryState.readCached_storeP3_of_id_ne (hne _ (hai' _)).2,
    MemoryState.readCached_storeP1p1_of_id_ne (hne _ (hai' _)).1]
  rcases Nat.lt_or_ge k j with hkj | hkj
  · obtain ⟨hf, hr⟩ := h.tbl k hkj
    refine ⟨hf.storeCached.storeP1p1.storeP3, ?_⟩
    rw [readCached_storeCached_apart hp (by omega) (by omega) (by omega)]
    exact hr
  · obtain rfl : k = j := by omega
    exact
      ⟨(MemoryState.PointFit.storeCached_self hroom).storeP1p1.storeP3,
        MemoryState.readCached_storeCached_self hroom⟩

/-- A table step at entry `j`, in `bb0` at `pos`: `TablePhase` carried to `j + 1`. -/
theorem table_step {r t u aslide bslide ai bi a2 : Pointer} {as bs : Vector (BitVec 8) 256}
    {P : GeP3} {n₀ N : Nat} {M : MemoryState} {E : ⟪Γ⟫} {pos : Nat} {k : Dst Γ .ptr} {j : Nat}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      bb0.body.drop pos =
        tableRun (%2679) (%2681) (%2680) (%2682) k (160 * j) ++ bb0.body.drop (pos + 4))
    (hd :
      [k.i, (%2679 : Dst Γ .ptr).i, (%2681 : Dst Γ .ptr).i, (%2680 : Dst Γ .ptr).i,
          (%2682 : Dst Γ .ptr).i].Nodup)
    (hR : E ⊨ [%2679 := ai, %2681 := u, %2680 := t, %2682 := a2])
    (hL : TableLayout r t u aslide bslide ai bi a2 N) (hj : 1 ≤ j) (hj8 : j < 8)
    (hTP : TablePhase S r t u aslide bslide ai bi a2 as bs P n₀ N M j)
    (hK :
      ∀ vk (S' : GlobalState),
        TablePhase S' r t u aslide bslide ai bi a2 as bs P n₀ N M (j + 1) →
          (bb0.runBodyFrom E[k := vk] (pos + 4) S' >>= g) = K) :
    (bb0.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_tableRun hbody hR hd hTP.wf hTP.globals hTP.fitU hTP.writU hTP.roomT hTP.fitA2
    (hTP.room j le_rfl hj8) hL.aio (by omega) hL.aiu hL.ait hL.aia2 hL.tu hL.ta2 fun vk =>
    hK vk _ (hTP.step hL hj hj8)

/-- The table loop's six steps, entries `1 … 6`, from `bb0`'s instruction 29. -/
theorem table_run {r t u aslide bslide ai bi a2 : Pointer} {as bs : Vector (BitVec 8) 256}
    {P : GeP3} {n₀ N : Nat} {M : MemoryState} {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hR : E ⊨ [%2679 := ai, %2681 := u, %2680 := t, %2682 := a2])
    (hL : TableLayout r t u aslide bslide ai bi a2 N)
    (hTP : TablePhase S r t u aslide bslide ai bi a2 as bs P n₀ N M 1)
    (hK :
      ∀ v7 v8 v9 v10 v11 v12 (S' : GlobalState),
        TablePhase S' r t u aslide bslide ai bi a2 as bs P n₀ N M 7 →
          (bb0.runBodyFrom
                E[%2683 := v7, %2684 := v8, %2685 := v9, %2686 := v10, %2687 := v11, %2688 := v12]
                53 S' >>=
              g) =
            K) :
    (bb0.runBodyFrom E 29 S >>= g) = K := by
  refine
    table_step (k := %2683) (j := 1) rfl (by decide) hR hL (by decide) (by decide) hTP
      fun v7 S₂ h₂ => ?_
  refine
    table_step (k := %2684) (j := 2) rfl (by decide) (by env_reads) hL (by decide) (by decide) h₂
      fun v8 S₃ h₃ => ?_
  refine
    table_step (k := %2685) (j := 3) rfl (by decide) (by env_reads) hL (by decide) (by decide) h₃
      fun v9 S₄ h₄ => ?_
  refine
    table_step (k := %2686) (j := 4) rfl (by decide) (by env_reads) hL (by decide) (by decide) h₄
      fun v10 S₅ h₅ => ?_
  refine
    table_step (k := %2687) (j := 5) rfl (by decide) (by env_reads) hL (by decide) (by decide) h₅
      fun v11 S₆ h₆ => ?_
  exact
    table_step (k := %2688) (j := 6) rfl (by decide) (by env_reads) hL (by decide) (by decide) h₆
      fun v12 S₇ h₇ => hK v7 v8 v9 v10 v11 v12 S₇ h₇

end ge25519_double_scalarmult_vartime

namespace ge25519_double_scalarmult_vartime

theorem spec_of_none {x1 x2 : BitVec 256} {A : GeP3}
    (h : start (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) 255 (by decide) = none) :
    spec x1 A x2 = Boringssl.ge_p2_0.spec := by
  unfold spec
  dsimp only
  rw [h]

theorem blocks_of_none {x1 x2 : BitVec 256}
    (h : start (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) 255 (by decide) = none) :
    blocks x1 x2 = 15 := by
  unfold blocks
  dsimp only
  rw [h]
  rfl

theorem spec_of_some {x1 x2 : BitVec 256} {A : GeP3} {j : Fin 256}
    (h : start (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) 255 (by decide) = some j) :
    spec x1 A x2 =
      ladder (aiTbl A) biTbl (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) j j.isLt
        Boringssl.ge_p2_0.spec := by
  unfold spec
  dsimp only
  rw [h]

theorem blocks_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h : start (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) 255 (by decide) = some j) :
    blocks x1 x2 =
      15 + ladderBlocks (Boringssl.slide.spec x1) (Boringssl.slide.spec x2) j j.isLt := by
  unfold blocks
  dsimp only
  rw [h]

/-- `^bb17`: the locals' lifetimes end and the function returns; the frame erased, what is left is
the memory without them. -/
theorem exit_block (aslide bslide ai bi t u a2 : Pointer) (N : Nat)
    (hN :
      N ≤ aslide.id.id ∧ N ≤ bslide.id.id ∧ N ≤ ai.id.id ∧ N ≤ t.id.id ∧ N ≤ u.id.id ∧ N ≤ a2.id.id)
    (S : GlobalState) (E : ⟪Γ⟫) (hR : LoopRegs aslide bslide ai bi t u a2 E) (M : MemoryState)
    (he : S.mem.eraseFrom N = M) :
    (ge25519_double_scalarmult_vartime.runFrom E ^bb17 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value (.nil, ({ alloc := S.alloc, mem := M } : GlobalState)) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hN
  block_init
  iterate 6 step_pure
  finish_block
  rw [hS]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le h1, MemoryState.eraseFrom_lifetimeEnd_of_le h2,
    MemoryState.eraseFrom_lifetimeEnd_of_le h3, MemoryState.eraseFrom_lifetimeEnd_of_le h4,
    MemoryState.eraseFrom_lifetimeEnd_of_le h5, MemoryState.eraseFrom_lifetimeEnd_of_le h6, he]

end ge25519_double_scalarmult_vartime

open ge25519_double_scalarmult_vartime

attribute [local mlir_transport] SlidesAt.storeP1p1 SlidesAt.storeP3 SlidesAt.storeP2
  SlidesAt.storeCached CachedTable.storeP1p1 CachedTable.storeP3 CachedTable.storeP2
  PrecompTable.storeP1p1 PrecompTable.storeP3 PrecompTable.storeP2 PrecompTable.storeCached
  SlidesAt.storeCached_add PrecompTable.storeCached_add

/-- `ge25519_double_scalarmult_vartime` stores `spec` of the 32 bytes at `a`, the `ge25519_p3` at
`A` and the 32 bytes at `b` at `r`, for digits in range; `r` is written after every input is read.
The block counter advances by `blocks`. -/
public theorem ge25519_double_scalarmult_vartime.call_eq (r a A b : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals ge25519_double_scalarmult_vartime.globals)
    (hr : s.mem.Fe3Room r) (ha : Fits s.mem a 256) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hA : s.mem.PointFit A) (hb : Fits s.mem b 256) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hda : Digits (s.mem.readAt a 256)) (hdb : Digits (s.mem.readAt b 256)) :
    ge25519_double_scalarmult_vartime.call
        (ge25519_double_scalarmult_vartime.args (.value r) (.value a) (.value A) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks (s.mem.readAt a 256) (s.mem.readAt b 256)⟩,
            mem :=
              s.mem.storeP2 r
                (spec (s.mem.readAt a 256) (s.mem.readP3 A) (s.mem.readAt b 256)) }) := by
  -- folded for `func_init`, whose frame-free check would unfold them
  generalize hQ : spec (s.mem.readAt a 256) (s.mem.readP3 A) (s.mem.readAt b 256) = Q
  generalize hk : blocks (s.mem.readAt a 256) (s.mem.readAt b 256) = k
  func_init
  -- the inputs, named before the frame grows
  obtain ⟨xa, hxa⟩ : ∃ x, S.mem.readAt a 256 = x := ⟨_, rfl⟩
  obtain ⟨P, hP⟩ : ∃ P, S.mem.readP3 A = P := ⟨_, rfl⟩
  obtain ⟨xb, hxb⟩ : ∃ x, S.mem.readAt b 256 = x := ⟨_, rfl⟩
  rw [hxa, hP, hxb] at hQ
  rw [hxa, hxb] at hk
  rw [hxa] at hda
  rw [hxb] at hdb
  have hr₀ : S₀.mem.Fe3Room r := hS ▸ hr
  have hP₀ : S₀.mem.readP3 A = P := hS ▸ hP
  have hxa₀ : S₀.mem.readAt a 256 = xa := hS ▸ hxa
  have hxb₀ : S₀.mem.readAt b 256 = xb := hS ▸ hxb
  clear hP hxa hxb
  block_init
  iterate 5 step_pure
  step_addressof ge25519_double_scalarmult_vartime_Bi.value_eq with bi
  have hP : S.mem.readP3 A = P := by
    rw [hS]; exact hP₀
  have hxa : S.mem.readAt a 256 = xa := by
    rw [hS]; exact hxa₀
  have hxb : S.mem.readAt b 256 = xb := by
    rw [hS]; exact hxb₀
  clear hP₀ hxa₀ hxb₀
  iterate 4 step_pure
  -- signed char aslide[256]; signed char bslide[256]; ge25519_cached Ai[8];
  -- ge25519_p1p1 t; ge25519_p3 u; ge25519_p3 A2;
  step_alloca with aslide
  step_alloca with bslide
  step_alloca with ai
  step_alloca with t
  step_alloca with u
  step_alloca with a2
  iterate 6 step_pure
  -- slide_vartime(aslide, a); slide_vartime(bslide, b);
  step_call using slide_vartime.call_eq consuming hxa
  step_call using slide_vartime.call_eq consuming hxb
  have hai0 : S.mem.PointRoom ai :=
    MemoryState.PointRoom.of_room (hroom_ai.mono (by decide)) hai_off
  have ht_pt := MemoryState.PointRoom.of_room hroom_t ht_off
  have hu_pt := MemoryState.PointRoom.of_room hroom_u hu_off
  have ha2_pt := MemoryState.PointRoom.of_room hroom_a2 ha2_off
  clear hroom_t hroom_u hroom_a2 ht_bounds hu_bounds ha2_bounds
  -- ge25519_p3_to_cached(&Ai[0], A); ge25519_p3_dbl(&t, A); ge25519_p1p1_to_p3(&A2, &t);
  -- ge25519_add(&t, &A2, &Ai[0]); ge25519_p1p1_to_p3(&u, &t);
  step_call using ge25519_p3_to_cached.call_eq
  step_call using ge25519_p3_dbl.call_eq consuming hP
  step_call using ge25519_p1p1_to_p3.call_eq
  step_call using ge25519_add.call_eq
  step_call using ge25519_p1p1_to_p3.call_eq
  -- the table loop's facts at entry `1`
  have hTL : TableLayout r t u aslide bslide ai bi a2 S₀.alloc.nextFreeBlock :=
    ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, hai_off, by slot_bound, by slot_bound, by slot_bound⟩
  have hTP :
    TablePhase S r t u aslide bslide ai bi a2 (Boringssl.slide.spec xa) (Boringssl.slide.spec xb) P
      (S₀.alloc.nextFreeBlock + 9) S₀.alloc.nextFreeBlock S₀.mem 1 :=
    { wf := hwf
      alloc := by
        rw [hS]
        simp [GlobalState.alloca]
      erase := by
        rw [hS]
        dsimp only
        erase_frame
      tbl := fun k hk => by
        obtain rfl : k = 0 := Nat.lt_one_iff.mp hk
        rw [Nat.mul_zero, Pointer.add_zero']
        exact ⟨hai0, hread_ai⟩
      room := fun k _ hk8 => PointRoom.entry hroom_ai hai_off hk8
      globals := hg
      fitU := hu_pt
      writU := by mem_fact
      valU := hread_u
      roomT := ht_pt.room (by mem_fact)
      fitA2 := ha2_pt
      valA2 := hread_a2
      roomR := hr
      slidesA := SlidesAt.of_readAt hfits_aslide haslide_off hread_aslide
      slidesB := SlidesAt.of_readAt hfits_bslide hbslide_off hread_bslide
      tblB := PrecompTable.of_readAt hbi_fits hbi_off hread_bi }
  -- the six table steps, `Ai[1] … Ai[6]`
  refine table_run (by env_reads) hTL hTP fun v7 v8 v9 v10 v11 v12 S₇ h₇ => ?_
  clear hTP hu_pt hread_u_readLimbs hread_u_40 hread_u_80 hread_u_120 hread_u hread_t_readLimbs
    hread_t_40 hread_t_80 hread_t_120 hread_t hread_a2_readLimbs hread_a2_40 hread_a2_80
    hread_a2_120 hread_a2 hread_ai_readLimbs hread_ai_40 hread_ai_80 hread_ai_120 hread_ai
    hread_bslide hread_aslide hread_bi ha2_pt ht_pt hai0 hfits_bslide hfits_aslide hroom_ai
    hroom_bslide hroom_aslide hwf hg hr ha hA hb hbi_live hbi_fits haslide_bounds hbslide_bounds
    hai_bounds hS
  obtain
    ⟨hwf, halloc, herase, htbl, hroom, hg, hu_pt, huw, hread_u, ht_pt, -, -, hr, hsa, hsb, htb⟩ :=
    h₇
  have hai7 : S₇.mem.PointRoom (ai.add 1120#64) := hroom 7 (by decide) (by decide)
  clear hroom
  -- the table's first seven entries, about a memory the steps leave alone
  obtain ⟨M₇, hM₇⟩ : ∃ m, S₇.mem = m := ⟨_, rfl⟩
  rw [hM₇] at htbl
  have hai7₀ : M₇.PointRoom (ai.add 1120#64) := hM₇ ▸ hai7
  have hai_a := hTL.aia
  have hai_b := hTL.aib
  have hai_bi := hTL.aibi
  -- ge25519_p3_to_cached(&Ai[7], &u); ge25519_p2_0(r);
  step_pure
  step_call using ge25519_p3_to_cached.call_eq consuming hread_u
  step_call using ge25519_p2_0.call_eq
  finish_block
  -- the main loop's facts
  have hai8 : CachedTable S.mem ai 8 (aiTbl P) := by
    rw [hS, hM₇]
    exact htbl.store8 hai_off (by mem_fact) hai7₀
  have hL : Layout r t u aslide bslide ai bi :=
    ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, hTL.tu, hTL.ta,
      hTL.tb, hTL.ait.symm, hTL.tbi, hTL.ua, hTL.ub, hTL.aiu.symm, hTL.ubi, haslide_off,
      hbslide_off, hai_off, hbi_off⟩
  have hF :
    LoopFacts S r t u aslide bslide ai bi (Boringssl.slide.spec xa) (Boringssl.slide.spec xb)
      (aiTbl P) biTbl :=
    ⟨hwf, hr, by mem_fact, ht_pt, hu_pt.room (by mem_fact), hsa, hsb, hai8, htb⟩
  have hS₈ : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 15 := by rw [hS, halloc]
  have he₈ : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem.storeP2 r Boringssl.ge_p2_0.spec := by
    rw [hS]
    dsimp only
    rw [MemoryState.eraseFrom_storeP2,
      MemoryState.eraseFrom_storeCached_of_le
        (by
          rw [Pointer.add_id]; exact hTL.Nai),
      herase]
  have hNt := hTL.Nt
  have hNu := hTL.Nu
  have hN :
    S₀.alloc.nextFreeBlock ≤ aslide.id.id ∧
      S₀.alloc.nextFreeBlock ≤ bslide.id.id ∧
      S₀.alloc.nextFreeBlock ≤ ai.id.id ∧
      S₀.alloc.nextFreeBlock ≤ t.id.id ∧
      S₀.alloc.nextFreeBlock ≤ u.id.id ∧ S₀.alloc.nextFreeBlock ≤ a2.id.id :=
    ⟨by slot_bound, by slot_bound, hTL.Nai, hNt, hNu, by slot_bound⟩
  clear hai8 hsa hsb htb hwf hr ht_pt hu_pt hread_r_readLimbs hread_r_40 hread_r_80 hread_ai_1120
    hread_u hai7 htbl hai7₀ hM₇ herase halloc
  -- for (i = 255; i >= 0; --i) if (aslide[i] || bslide[i]) break;
  refine
    skip_loop r a A b aslide bslide ai bi t u a2 _ _ S hF.slidesA hF.slidesB _ _ 127 (by decide) E
      hArgs (by env_reads) (by env_reads) ?_ ?_
  · -- the main loop from the first non-zero digit
    intro j hj E₂ h₁ h₂ h₃
    refine
      main_loop r a A b aslide bslide ai bi t u a2 _ _ _ _ S₀.alloc.nextFreeBlock hL hNt hNu hda hdb
        _ _ j.val j.isLt _ S E₂ h₁ h₂ h₃ hF hread_r fun E₃ S₃ h₁' hR₃ hF₃ ha₃ he₃ => ?_
    rw [exit_block aslide bslide ai bi t u a2 _ hN S₃ E₃ hR₃ _ he₃, ← hk, ← hQ, blocks_of_some hj,
      spec_of_some hj, he₈, storeP2_storeP2_self hr₀.1,
      show S₃.alloc = ⟨S₃.alloc.nextFreeBlock⟩ from rfl, ha₃, hS₈, Nat.add_assoc]
  · intro hj E₂ _ hR₂
    rw [exit_block aslide bslide ai bi t u a2 _ hN S E₂ hR₂ _ he₈, ← hk, ← hQ, blocks_of_none hj,
      spec_of_none hj, show S.alloc = ⟨S.alloc.nextFreeBlock⟩ from rfl, hS₈]

end Proof

end MLIR.Sodium

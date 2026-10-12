module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Agave.Common.Bytes
public import Agave.Common.Copy
public import Agave.Common.Decompress
public import Agave.Serial.black_box_u8
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Serial.FieldElement51_sqrt_ratio_i
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_Neg_neg
public import Agave.Serial.FieldElement51_ConditionallySelectable_conditional_assign
public import Agave.Serial.Mlir.CompressedEdwardsY_decompress
import all MLIR.Ty

namespace MLIR.Agave.Serial

open Firedancer.Ref (fd_f25519_d)

/-! ## Specification -/

@[expose] public section

/-- `constants::EDWARDS_D`. -/
abbrev FieldElement51.EDWARDS_D : Fin 5 → BitVec 64 :=
  fd_f25519_d.limbs

/-- `FieldElement51::from_bytes`: `load8_at(bytes, i)`, the little-endian `u64` at byte `i`, for
`i = 0, 6, 12, 19, 24`, shifted to bit `51 k` and masked to 51 bits. -/
def FieldElement51_from_bytes.spec (bytes : BitVec 256) : Fin 5 → BitVec 64
  | 0 => bytes.extractLsb' 0 64 &&& mask51
  | 1 => bytes.extractLsb' 48 64 >>> 3 &&& mask51
  | 2 => bytes.extractLsb' 96 64 >>> 6 &&& mask51
  | 3 => bytes.extractLsb' 152 64 >>> 1 &&& mask51
  | 4 => bytes.extractLsb' 192 64 >>> 12 &&& mask51

/-- `decompress::step_1`: `Y` from the bytes, `u = Y² - 1`, `v = d Y² + 1`, and
`sqrt_ratio_i(u, v)`: `(is_valid_y_coord, X, Y)` (`Z` is `ONE`). -/
def CompressedEdwardsY_decompress.step_1 (repr : BitVec 256) :
    BitVec 8 × (Fin 5 → BitVec 64) × (Fin 5 → BitVec 64) :=
  let Y := FieldElement51_from_bytes.spec repr
  let Z := FieldElement51.ONE
  let YY := FieldElement51_square.spec Y
  let u := FieldElement51_Sub_sub.spec YY Z
  let v := FieldElement51_Add_add.spec (FieldElement51_Mul_mul.spec YY FieldElement51.EDWARDS_D) Z
  let s := FieldElement51_sqrt_ratio_i.spec u v
  (s.1, s.2, Y)

/-- `decompress::step_2`: `X` negated by the sign bit, `Z = 1`, `T = X Y`. -/
def CompressedEdwardsY_decompress.step_2 (repr : BitVec 256) (X Y : Fin 5 → BitVec 64) :
    EdwardsPoint :=
  let compressed_sign_bit := repr.extractLsb' 248 8 >>> 7
  let X :=
    FieldElement51_ConditionallySelectable_conditional_assign.spec X (FieldElement51_Neg_neg.spec X)
      compressed_sign_bit
  ⟨X, Y, FieldElement51.ONE, FieldElement51_Mul_mul.spec X Y⟩

/-- `repr.decompress()`: `step_2`'s point if `step_1`'s flag is set, else `None`. -/
def CompressedEdwardsY_decompress.spec (repr : BitVec 256) : Option EdwardsPoint :=
  let s := CompressedEdwardsY_decompress.step_1 repr
  if s.1 = 0 then none else some (CompressedEdwardsY_decompress.step_2 repr s.2.1 s.2.2)

end

/-! ## Proof -/

section Proof

theorem one_bits {hw : (Ty.array 40 (.bv 8)).width = 320} :
    Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw := hw) =
      limbsBits FieldElement51.ONE := by
  decide +kernel +revert

theorem one_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      FieldElement51.ONE := by
  funext i
  fin_cases i <;> decide +kernel +revert

theorem d_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_26.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      FieldElement51.EDWARDS_D := by
  funext i
  fin_cases i <;> decide +kernel +revert

/-- The byte at a slot's start, past limbs stored 8 bytes into it. -/
theorem readAt_storeLimbs_add8 {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (ho : p.offset = 0) : (m.storeLimbs (p.add 8#64) l).readAt p 8 = m.readAt p 8 := by
  rw [storeLimbs_eq_storeAt (by simp [Pointer.add, ho])]
  apply MemoryState.readAt_storeAt_disjoint
  simp [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, ho]

/-- `sqrt_ratio_i`'s `Choice` read back from below its `r`. -/
theorem readAt_flag {m : MemoryState} {p : Pointer} {x : BitVec 8} {l : Fin 5 → BitVec 64}
    (ho : p.offset = 0) (hb : InBounds ((m.storeAt p x).storeLimbs (p.add 8#64) l) p 8) :
    ((m.storeAt p x).storeLimbs (p.add 8#64) l).readAt p 8 = x := by
  have hl : (p.add 8#64).offset.toNat + 32 < 2 ^ 64 := by simp [Pointer.add, ho]
  rw [readAt_storeLimbs_add8 ho]
  rw [storeLimbs_eq_storeAt hl, InBounds.storeAt_iff] at hb
  exact MemoryState.readAt_storeAt_self (InBounds.storeAt_iff.mp hb) x

/-- `(repr[31] >> 7) as u8` from the word at byte 24: its sign bit, truncated without loss. -/
theorem sign_trunc_zext (x : BitVec 64) : ((x >>> 63).setWidth 8).setWidth 64 = x >>> 63 := by
  bv_decide

theorem sign_trunc_sext (x : BitVec 64) : ((x >>> 63).setWidth 8).signExtend 64 = x >>> 63 := by
  bv_decide

/-- The sign bit from the word at byte 24 is byte 31's top bit. -/
theorem sign_eq (buf : BitVec 256) :
    (buf.extractLsb' 192 64 >>> 63).setWidth 8 = buf.extractLsb' 248 8 >>> 7 := by bv_decide

/-- Ranges in two slots of a state are disjoint. -/
theorem slots_disjoint {S : GlobalState} {p q : Pointer} {i j : Nat} (hp : p = S.slot i)
    (hq : q = S.slot j) (hij : i ≠ j) (a b : BitVec 64) :
    (Range.of (p.add a) 320).Disjoint (Range.of (q.add b) 320) :=
  Or.inl
    (by
      simp only [Range.of, Pointer.add_id, hp, hq]; exact GlobalState.slot_id_ne hij)

/-- Room for 320 bits 40 bytes into an 80-byte slot. -/
theorem room_add40 {m : MemoryState} {p : Pointer} (h : Room m p 640) (ho : p.offset = 0) :
    Room m (p.add 40#64) 320 :=
  Room.add_of_le (by simp [ho, BitVec.uaddOverflow]) (by decide) h

/-- Room for 320 bits 80 bytes into a 160-byte slot. -/
theorem room_add80 {m : MemoryState} {p : Pointer} (h : Room m p 1280) (ho : p.offset = 0) :
    Room m (p.add 80#64) 320 :=
  Room.add_of_le (by simp [ho, BitVec.uaddOverflow]) (by decide) h

/-- A 160-byte slot's four field elements known: its 1280 bits. -/
theorem fits_point {m : MemoryState} {p : Pointer} (ho : p.offset = 0) (h0 : Fits m p 320)
    (h1 : Fits m (p.add 40#64) 320) (h2 : Fits m (p.add 80#64) 320)
    (h3 : Fits m (p.add 120#64) 320) : Fits m p 1280 := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 120) : ¬p.offset.uaddOverflow k := by
    simp [ho, BitVec.uaddOverflow]
    omega
  have a1 := Fits.append (hov 40#64 (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (hov 80#64 (by decide)) (by decide) rfl a1 h2
  exact Fits.append (hov 120#64 (by decide)) (by decide) rfl a2 h3

/-- The point `decompress` builds at `p`: `X`, `T = X Y`, `Y`, then `Z` stored, read whole. -/
theorem readAt_point_stores {m : MemoryState} {p : Pointer} {X Y Z T : Fin 5 → BitVec 64}
    {z : BitVec 320}
    (hb :
      InBounds
        ((((m.storeAt p (limbsBits X)).storeLimbs (p.add 120#64) T).storeAt (p.add 40#64)
              (limbsBits Y)).storeAt
          (p.add 80#64) z)
        p 1280)
    (ho : p.offset = 0) (hz : z = limbsBits Z) :
    ((((m.storeAt p (limbsBits X)).storeLimbs (p.add 120#64) T).storeAt (p.add 40#64)
                (limbsBits Y)).storeAt
            (p.add 80#64) z).readAt
        p 1280 =
      edwardsBits ⟨X, Y, Z, T⟩ := by
  subst hz
  have hp : p.offset.toNat + 160 ≤ 2 ^ 64 := by simp [ho]
  have hl : (p.add 120#64).offset.toNat + 32 < 2 ^ 64 := by simp [Pointer.add, ho]
  rw [storeLimbs_eq_storeAt hl] at hb ⊢
  simp only [InBounds.storeAt_iff] at hb
  have d (a b : Nat) (ha : a ≤ 120) (hb : b ≤ 120) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :=
    Range.disjoint_coords hp ha hb hab
  have d0 (b : Nat) (hb : b ≤ 120) (hab : 40 ≤ b) := by
    simpa only [Pointer.add_zero'] using d 0 b (by omega) hb (by omega)
  have d0' (a : Nat) (ha : a ≤ 120) (hab : 40 ≤ a) := by
    simpa only [Pointer.add_zero'] using d a 0 ha (by omega) (by omega)
  have i (k : BitVec 64) (hk : k.toNat ≤ 120) : InBounds m (p.add k) 320 :=
    InBounds.add_of_le
      (by
        simp [ho, BitVec.uaddOverflow]; omega)
      (by omega) hb
  apply readAt_edwardsBits (by simpa only [InBounds.storeAt_iff] using hb) hp
  · rw [MemoryState.readAt_storeAt_disjoint (d0' 80 (by omega) (by omega)),
      MemoryState.readAt_storeAt_disjoint (d0' 40 (by omega) (by omega)),
      MemoryState.readAt_storeAt_disjoint (d0' 120 (by omega) (by omega)),
      MemoryState.readAt_storeAt_self (hb.mono (by decide))]
  · rw [MemoryState.readAt_storeAt_disjoint (d 80 40 (by omega) (by omega) (by omega)),
      MemoryState.readAt_storeAt_self
        (by simpa only [InBounds.storeAt_iff] using i 40#64 (by decide))]
  · rw [MemoryState.readAt_storeAt_self
        (by simpa only [InBounds.storeAt_iff] using i 80#64 (by decide))]
  · rw [MemoryState.readAt_storeAt_disjoint (d 80 120 (by omega) (by omega) (by omega)),
      MemoryState.readAt_storeAt_disjoint (d 40 120 (by omega) (by omega) (by omega)),
      MemoryState.readAt_storeAt_self
        (by simpa only [InBounds.storeAt_iff] using i 120#64 (by decide))]

/-- `start p`: the slot `p`'s lifetime starts, with room for its limbs. -/
local macro "start " p:ident : tactic => `(tactic| (step_pure; limbs_room $p))

set_option hygiene false in
/-- `copied p`: the limbs a copy stored at `p` (`hfits_p`, `hread_p`) as `hp_limbs` and
`hread_p_readLimbs`. -/
local macro "copied " p:ident : tactic => do
  let n := p.getId.toString
  let fits := Lean.mkIdent (.mkSimple s!"hfits_{n}")
  let read := Lean.mkIdent (.mkSimple s!"hread_{n}")
  let readL := Lean.mkIdent (.mkSimple s!"hread_{n}_readLimbs")
  let off := Lean.mkIdent (.mkSimple s!"h{n}_off")
  let limbs := Lean.mkIdent (.mkSimple s!"h{n}_limbs")
  let room := Lean.mkIdent (.mkSimple s!"hroom_{n}")
  let bounds := Lean.mkIdent (.mkSimple s!"h{n}_bounds")
  `(tactic|
      ( have $limbs:ident := limbsFit_of_fits $fits (by simp [$off:ident])
        have $readL:ident :=
          readLimbs_of_readAt_limbsBits (Fits.inBounds $fits) (by simp [$off:ident]) $read
        clear $fits $room $bounds $read))

set_option hygiene false in
/-- `copy p h`: a `memcpy` of the limbs at `p` (`hp_limbs`, `h : readLimbs p = l`), read as their
bits. -/
local macro "copy " p:ident readL:ident : tactic => do
  let n := p.getId.toString
  let limbs := Lean.mkIdent (.mkSimple s!"h{n}_limbs")
  `(tactic|
      ( have hsrc_fits := fits_of_limbsFit $limbs
        have hsrc_bits := (readAt_eq_limbsBits $limbs).trans (congrArg limbsBits $readL)
        step_memcpy consuming hsrc_fits hsrc_bits))

set_option hygiene false in
/-- `rebase`: the current state becomes the base of later states (`hS` reversed), so their terms
and the steps' proofs stay small. -/
local macro "rebase" : tactic => `(tactic| replace hS := hS.symm)

/-- `memcpy_n n hd hdst hsrc`: a `memcpy` of `n` bytes by `run_memcpy` with its facts given
(`step_memcpy`'s searches fall back to `simp_all` on a destination `p.add k`). -/
local macro "memcpy_n " n:num hd:term:max hdst:term:max hsrc:term:max : tactic =>
  `(tactic| step_impure => (expect_values; exact run_memcpy (n := $n) rfl $hd $hdst $hsrc))

set_option hygiene false in
/-- `fe_call thm x p`: a call storing limbs at `p`, named `x`; their 320-bit read-back dropped. -/
local macro "fe_call " thm:ident x:ident p:ident : tactic => do
  let n := p.getId.toString
  let read := Lean.mkIdent (.mkSimple s!"hread_{n}")
  `(tactic| (step_call using $thm:ident; name_limbs $x; clear $read))

set_option hygiene false in
/-- `drop p`: the limbs at `p` are read no more; their facts go. -/
local macro "drop " p:ident : tactic => do
  let n := p.getId.toString
  let readL := Lean.mkIdent (.mkSimple s!"hread_{n}_readLimbs")
  `(tactic| (clear $readL; clear_facts $p))

public theorem anon_042b818bc72209407b52bd0e4d6c8368_26.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_26.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_26.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

-- about 150 steps over a frame of 13 blocks and 13 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `repr.decompress()` for the 32 bytes at `repr`: stores `spec`'s point at `out + 8` and the tag
`1` at `out`, or only the tag `0` when `spec` is `none`. The temporaries', globals' and callees'
blocks are freed again: only the counter moves on, by 162 blocks (161 for `none`). -/
public theorem CompressedEdwardsY_decompress.call_eq (out repr : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.OptEdwardsRoom out) (hrepr : Fits s.mem repr 256)
    (hrepr_off : ¬repr.offset.uaddOverflow 32#64) :
    CompressedEdwardsY_decompress.call
        (CompressedEdwardsY_decompress.args (.value out) (.value repr)) s =
      .value
        (.nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  if (CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256)).isSome then 162
                  else 161⟩,
            mem :=
              s.mem.storeOptEdwards out
                (CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256)) }) := by
  obtain ⟨hout_off, hout_tag, hout_pt⟩ := hout
  func_init
  have hrepr_read : S.mem.readAt repr 256 = S₀.mem.readAt repr 256 := by rw [hS]
  block_init
  iterate 6 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq with one
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_26.value_eq with D
  iterate 5 step_pure
  step_alloca with pX_neg
  step_alloca with st1
  step_alloca with pYYd
  step_alloca with pv
  step_alloca with pu
  step_alloca with pYY
  step_alloca with pY
  step_alloca with pt
  step_alloca with ret
  step_alloca with pY'
  step_alloca with pX
  -- let Y = FieldElement::from_bytes(repr.as_bytes());
  obtain ⟨buf, hbuf⟩ : ∃ b, S₀.mem.readAt repr 256 = b := ⟨_, rfl⟩
  rw [hbuf]
  step_pure
  step_pure
  limbs_room pY
  have hbuf' := hrepr_read.trans hbuf
  have hb0 := Agave.readAt_bytes0 hbuf' 64 (by decide)
  have hb6 :=
    Agave.readAt_bytes (n := 32) hrepr.inBounds hrepr_off (by decide) hbuf' 6 64 (by decide)
  have hb12 :=
    Agave.readAt_bytes (n := 32) hrepr.inBounds hrepr_off (by decide) hbuf' 12 64 (by decide)
  have hb19 :=
    Agave.readAt_bytes (n := 32) hrepr.inBounds hrepr_off (by decide) hbuf' 19 64 (by decide)
  have hb24 :=
    Agave.readAt_bytes (n := 32) hrepr.inBounds hrepr_off (by decide) hbuf' 24 64 (by decide)
  clear hbuf' hrepr_read
  step_load consuming hb0
  step_pure
  step_pure
  step_load consuming hb6
  step_pure
  step_pure
  step_pure
  step_load consuming hb12
  step_pure
  step_pure
  step_pure
  step_load consuming hb19
  step_pure
  step_pure
  step_pure
  step_load consuming hb24
  step_pure
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  have hY_fit : S.mem.LimbsFit pY :=
    ⟨hpY_limbs.1, hfits_pY, hfits_pY_8, hfits_pY_16, hfits_pY_24, hfits_pY_32⟩
  have hY_read : S.mem.readLimbs pY = FieldElement51_from_bytes.spec buf :=
    readLimbs_of_reads hread_pY hread_pY_8 hread_pY_16 hread_pY_24 hread_pY_32
  obtain ⟨Y, hY⟩ : ∃ y, FieldElement51_from_bytes.spec buf = y := ⟨_, rfl⟩
  rw [hY] at hY_read
  clear hread_pY hread_pY_8 hread_pY_16 hread_pY_24 hread_pY_32 hfits_pY hfits_pY_8 hfits_pY_16
    hfits_pY_24 hfits_pY_32 hpY_limbs
  -- the constants
  have hone_read := readLimbs_global hone_fits hone_off hread_one one_limbs
  have hD_read := readLimbs_global hD_fits hD_off hread_D d_limbs
  have hone_bits := hread_one
  clear hread_D hread_one
  limbs_fit D
  have hone_limbs := MemoryState.LimbsFit.of_fits hone_fits hone_off
  clear hone_room
  -- let YY = Y.square();
  start pYY
  fe_call FieldElement51_square.call_eq YY pYY
  -- let u = &YY - &Z;
  start pu
  fe_call FieldElement51_Sub_sub.call_eq u pu
  -- let v = &(&YY * &constants::EDWARDS_D) + &Z;
  start pv
  start pYYd
  fe_call FieldElement51_Mul_mul.call_eq YYd pYYd
  drop pYY
  clear hD_read
  clear_facts D
  fe_call FieldElement51_Add_add.call_eq v pv
  drop pYYd
  step_pure
  rebase
  -- let (is_valid_y_coord, X) = FieldElement::sqrt_ratio_i(&u, &v);
  step_pure
  have hst1_8 := Agave.limbsRoom_add (k := 8#64) hroom_st1 hst1_off (by decide) (by decide)
  step_call using FieldElement51_sqrt_ratio_i.call_eq
  name_limbs X0
  have hflag : S.mem.readAt st1 8 = (FieldElement51_sqrt_ratio_i.spec u v).1 := by
    have hb := hst1_bounds
    rw [hS] at hb ⊢
    exact readAt_flag hst1_off (hb.mono (by decide))
  step_load with is_valid_y_coord consuming hflag
  -- step_1's `(X, Y)` at `ret`
  step_pure
  have hsrc := Agave.fits_of_limbsFit hst1_8
  step_memcpy consuming hsrc
  clear_facts st1
  clear hread_st1_8 hread_st1_8_readLimbs
  step_pure
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := ret) (q := pY) hret hpY (by decide) 40#64 0#64
  have hdst := room_add40 hroom_ret hret_off
  have hsrc := fits_of_limbsFit hY_fit
  have hY_bits := (readAt_eq_limbsBits hY_fit).trans (congrArg limbsBits hY_read)
  memcpy_n 40hdisj hdst hsrc
  clear hY_read hY_fit hY_bits hdisj hdst hsrc
  drop pv
  drop pu
  iterate 4 step_pure
  rebase
  -- let X, Y
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := pX) (q := ret) hpX hret (by decide) 0#64 0#64
  memcpy_n 40hdisj hroom_pX hfits_ret
  clear hdisj
  copied pX
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := pY') (q := ret) hpY' hret (by decide) 0#64 40#64
  memcpy_n 40hdisj hroom_pY' hfits_ret_40
  clear hdisj
  copied pY'
  clear_facts ret
  clear hread_ret hread_ret_40
  step_pure
  step_pure
  finish_block
  case isTrue =>
    block_init
    step_store
    iterate 2 step_pure
    finish_block
    have hnone : CompressedEdwardsY_decompress.spec buf = none := by
      simp only [his_valid_y_coord, hYYd, hYY, ← hY] at hbr
      exact ite_eq_left (c := (CompressedEdwardsY_decompress.step_1 buf).1 = 0) hbr
    rw [hnone]
    clear_reads
    subst_vars
    erase_frame
    simp only [GlobalState.alloca_alloc, Option.isSome_none, Bool.false_eq_true, ↓reduceIte,
      MemoryState.storeOptEdwards, Nat.add_assoc, Nat.reduceAdd]
  case isFalse =>
    block_init
    step_pure
    step_pure
    step_pure [sign_trunc_zext, sign_trunc_sext]
    step_call using black_box_u8.call_eq with compressed_sign_bit
    start pX_neg
    fe_call FieldElement51_Neg_neg.call_eq X_neg pX_neg
    fe_call FieldElement51_ConditionallySelectable_conditional_assign.call_eq X pX
    drop pX_neg
    step_pure
    -- EdwardsPoint { X, Y, Z, T: &X * &Y } at `pt`, copied to `out + 8`
    have hdisj := by
      simpa only [Pointer.add_zero'] using
        slots_disjoint (p := pt) (q := pX) hpt hpX (by decide) 0#64 0#64
    have hX_bits := (readAt_eq_limbsBits hpX_limbs).trans (congrArg limbsBits hread_pX_readLimbs)
    memcpy_n 40hdisj(hroom_pt.mono (by decide))(fits_of_limbsFit hpX_limbs)
    clear hdisj hX_bits
    step_pure
    have hpt120 := MemoryState.LimbsRoom.of_room_add (k := 120#64) hroom_pt hpt_off (by decide)
    step_call using FieldElement51_Mul_mul.call_eq
    name_limbs T
    clear_facts pX
    clear hread_pX_readLimbs
    step_pure
    have hdisj := by
      simpa only [Pointer.add_zero'] using
        slots_disjoint (p := pt) (q := pY') hpt hpY' (by decide) 40#64 0#64
    have hY_bits := (readAt_eq_limbsBits hpY'_limbs).trans (congrArg limbsBits hread_pY'_readLimbs)
    memcpy_n 40hdisj(room_add40 (hroom_pt.mono (by decide)) hpt_off)(fits_of_limbsFit hpY'_limbs)
    clear hdisj hY_bits
    clear_facts pY'
    clear hread_pY'_readLimbs
    step_pure
    have hdisj := by
      simpa only [Pointer.add_zero'] using
        slots_disjoint (p := pt) (q := one) hpt hone (by decide) 80#64 0#64
    memcpy_n 40hdisj(room_add80 hroom_pt hpt_off)hone_fits
    clear hdisj
    step_pure
    have hpt_bits : S.mem.readAt pt 1280 = edwardsBits ⟨X, Y, FieldElement51.ONE, T⟩ := by
      have hb := hroom_pt.inBounds
      rw [hS] at hb ⊢
      exact readAt_point_stores hb hpt_off one_bits
    have hpt_fits := fits_point hpt_off hfits_pt hfits_pt_40 hfits_pt_80 (fits_of_limbsFit hpt120)
    have hdisj : (Range.of (out.add 8#64) 1280).Disjoint (Range.of pt 1280) :=
      Or.inl (by simpa only [Range.of, Pointer.add_id] using hout_ne_pt)
    memcpy_n 160hdisj hout_pt hpt_fits
    clear hdisj hpt_bits hpt_fits
    step_pure
    finish_block
    block_init
    step_store
    iterate 2 step_pure
    finish_block
    rw [sign_eq] at hcompressed_sign_bit
    have hsome : CompressedEdwardsY_decompress.spec buf = some ⟨X, Y, FieldElement51.ONE, T⟩ := by
      simp only [his_valid_y_coord, hYYd, hYY, ← hY] at hbr
      have hb : ¬(CompressedEdwardsY_decompress.step_1 buf).1 = 0 := hbr
      unfold CompressedEdwardsY_decompress.spec
      simp only [hb, ↓reduceIte, Option.some.injEq]
      simp only [CompressedEdwardsY_decompress.step_2, CompressedEdwardsY_decompress.step_1]
      simp only [hY, ← hYY, ← hu, ← hYYd, ← hv, ← hX0, ← hcompressed_sign_bit, ← hX_neg, ← hX, ← hT]
    have hoff8 : (out.add 8#64).offset.toNat + 160 ≤ 2 ^ 64 := by
      simp only [Pointer.add, BitVec.toNat_add, show (8#64).toNat = 8 from rfl]
      omega
    rw [hsome]
    clear_reads
    subst_vars
    erase_frame
    simp only [GlobalState.alloca_alloc, Option.isSome_some, ↓reduceIte,
      MemoryState.storeOptEdwards, Nat.add_assoc, Nat.reduceAdd, storeAt_edwardsBits hoff8]

end Proof

end MLIR.Agave.Serial

module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Bytes
public import Agave.Common.Copy
public import Agave.Common.Decompress
public import Agave.Serial.CompressedEdwardsY_decompress
public import Agave.Avx2.FieldElement51_sqrt_ratio_i
public import Agave.Avx2.FieldElement51_Add_add
public import Agave.Avx2.FieldElement51_Sub_sub
public import Agave.Avx2.Mlir.CompressedEdwardsY_decompress
import all MLIR.Ty

namespace MLIR.Agave.Avx2

open Serial (anon_042b818bc72209407b52bd0e4d6c8368_1 anon_042b818bc72209407b52bd0e4d6c8368_26
  FieldElement51_square FieldElement51_Mul_mul black_box_u8)

/-! ## Proof -/

section Proof

theorem one_bits {hw : (Ty.array 40 (.bv 8)).width = 320} :
    Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw := hw) =
      limbsBits Serial.FieldElement51.ONE := by
  decide +kernel +revert

theorem one_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      Serial.FieldElement51.ONE := by
  funext i
  fin_cases i <;> decide +kernel +revert

theorem d_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_26.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      Serial.FieldElement51.EDWARDS_D := by
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

-- a long chain of calls: the state cut from the entry state every so often (`rir.stateDepth`)
set_option rir.stateDepth 64 in
-- about 150 steps over a frame of 13 blocks and 13 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `repr.decompress()` for the 32 bytes at `repr`: stores the point of
`Serial.CompressedEdwardsY_decompress.spec` at `out + 8` and the tag `1` at `out`, or only the tag
`0` when the spec is `none`. The temporaries', globals' and callees' blocks are freed again: only
the counter moves on, by 162 blocks (161 for `none`). -/
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
                  if (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256)).isSome then
                    162
                  else 161⟩,
            mem :=
              s.mem.storeOptEdwards out
                (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256)) }) := by
  obtain ⟨hout_off, hout_tag, hout_pt⟩ := hout
  func_init
  have hrepr_read : S.mem.readAt repr 256 = S₀.mem.readAt repr 256 := by rw [hS]
  block_init
  iterate 6 step_pure
  step_addressof Serial.anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq with one
  step_addressof Serial.anon_042b818bc72209407b52bd0e4d6c8368_26.value_eq with D
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
  have hY_read : S.mem.readLimbs pY = Serial.FieldElement51_from_bytes.spec buf :=
    readLimbs_of_reads hread_pY hread_pY_8 hread_pY_16 hread_pY_24 hread_pY_32
  obtain ⟨Y, hY⟩ : ∃ y, Serial.FieldElement51_from_bytes.spec buf = y := ⟨_, rfl⟩
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
  -- let (is_valid_y_coord, X) = FieldElement::sqrt_ratio_i(&u, &v);
  step_pure
  have hst1_8 := Agave.limbsRoom_add (k := 8#64) hroom_st1 hst1_off (by decide) (by decide)
  step_call using FieldElement51_sqrt_ratio_i.call_eq
  name_limbs X0
  have hflag : S.mem.readAt st1 8 = (Serial.FieldElement51_sqrt_ratio_i.spec u v).1 := by
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
  have hY_bits := (readAt_eq_limbsBits hY_fit).trans (congrArg limbsBits hY_read)
  have hsrc := fits_of_limbsFit hY_fit
  step_memcpy consuming hsrc hY_bits
  clear hY_read hY_fit
  drop pv
  drop pu
  iterate 4 step_pure
  -- let X, Y
  step_pure
  step_memcpy
  copied pX
  step_pure
  step_memcpy
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
    have hnone : Serial.CompressedEdwardsY_decompress.spec buf = none := by
      simp only [his_valid_y_coord, hu, hv, hYYd, hYY, ← hY] at hbr
      exact ite_eq_left (c := (Serial.CompressedEdwardsY_decompress.step_1 buf).1 = 0) hbr
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
    copy pX hread_pX_readLimbs
    step_pure
    have hpt120 := MemoryState.LimbsRoom.of_room_add (k := 120#64) hroom_pt hpt_off (by decide)
    step_call using FieldElement51_Mul_mul.call_eq
    name_limbs T
    clear_facts pX
    clear hread_pX_readLimbs
    step_pure
    copy pY' hread_pY'_readLimbs
    clear_facts pY'
    clear hread_pY'_readLimbs
    step_pure
    step_memcpy
    step_pure
    have hpt_bits : S.mem.readAt pt 1280 = edwardsBits ⟨X, Y, Serial.FieldElement51.ONE, T⟩ := by
      have hb := hroom_pt.inBounds
      rw [hS] at hb ⊢
      exact readAt_point_stores hb hpt_off one_bits
    have hpt_fits := fits_point hpt_off hfits_pt hfits_pt_40 hfits_pt_80 (fits_of_limbsFit hpt120)
    step_memcpy
    clear hpt_bits hpt_fits
    step_pure
    finish_block
    block_init
    step_store
    iterate 2 step_pure
    finish_block
    rw [sign_eq] at hcompressed_sign_bit
    have hsome :
      Serial.CompressedEdwardsY_decompress.spec buf =
        some ⟨X, Y, Serial.FieldElement51.ONE, T⟩ := by
      simp only [his_valid_y_coord, hu, hv, hYYd, hYY, ← hY] at hbr
      have hb : ¬(Serial.CompressedEdwardsY_decompress.step_1 buf).1 = 0 := hbr
      unfold Serial.CompressedEdwardsY_decompress.spec
      simp only [hb, ↓reduceIte, Option.some.injEq]
      simp only [Serial.CompressedEdwardsY_decompress.step_2,
        Serial.CompressedEdwardsY_decompress.step_1]
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

end MLIR.Agave.Avx2

module

public import Agave.Avx2.CompressedEdwardsY_decompress
public import Agave.Avx2.EdwardsPoint_is_small_order
public import Agave.Avx2.Mlir.VerificationKey_verify_dalek_prehashed
public import Agave.Avx2.impl_mul
public import Agave.Common.Copy
public import Agave.Common.Decompress
public import Agave.Common.Tactics
public import Agave.Serial.VerificationKey_verify_dalek_prehashed
public import Firedancer.Common.Tactics
public import MLIR.Run.Tactic
import all Agave.Serial.VerificationKey_verify_dalek_prehashed
import all MLIR.Semantics.Effectful.Memory.Bits
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

/-! ## Specification

The serial tree's, with the AVX2 `mul`: `compress`, `invert` and `from_canonical_bytes` are
`Serial`'s, as are the code's calls to them. -/

@[expose] public section

/-- `verify_dalek_prehashed(signature = r ‖ s, h)` with `self.minus_A`, as `Result<(), Error>`'s
byte: `2` (`Err(InvalidSignature)`) or `-1` (`Ok(())`), the checks in the Rust's order. -/
noncomputable def VerificationKey_verify_dalek_prehashed.spec (minus_A : EdwardsPoint)
    (r s h : BitVec 256) : BitVec 8 :=
  if Serial.EdwardsPoint_is_small_order.spec minus_A = 1#1 then 2#8
  else
    match Serial.CompressedEdwardsY_decompress.spec r with
    | none => 2#8
    | some R =>
      if Serial.EdwardsPoint_is_small_order.spec R = 1#1 then 2#8
      else
        if Serial.Scalar_from_canonical_bytes.spec s = 1#8 then
          let expected_R := Serial.EdwardsPoint_compress.spec (impl_mul.spec h minus_A s)
          if expected_R = r then -1#8 else 2#8
        else 2#8

/-- The blocks the function allocates, its callees' included: its 14 slots, then each call's. -/
def VerificationKey_verify_dalek_prehashed.blocks (minus_A : EdwardsPoint) (r s h : BitVec 256) :
    Nat :=
  14 + 102 +
    if Serial.EdwardsPoint_is_small_order.spec minus_A = 1#1 then 0
    else
      match Serial.CompressedEdwardsY_decompress.spec r with
      | none => 161
      | some R =>
        162 + 102 +
          if Serial.EdwardsPoint_is_small_order.spec R = 1#1 then 0
          else
            1 + 19 + 33 + 1 +
              if Serial.Scalar_from_canonical_bytes.spec s = 1#8 then impl_mul.blocks h s + 20 + 2
              else 0

end

/-! ## Proof -/

section Proof

open Serial (run_memcpy_read slots_disjoint room_add reduce_call_eq pow22501_call_eq pow2k_call_eq
  mul_call_eq to_bytes_call_eq is_negative_call_eq readAt_storeOptEdwards_of_id_ne
  readEdwards_storeOptEdwards_of_id_ne s_noOverflow readAt_s31 readAt_s_tail readAt_s0 scalar_copy
  high_bit_eq lt_of_canonical spliceBits_248 bcmp_select fits_of_pointFit pointFit_of_fits
  readEdwards_of_readAt)

set_option hygiene false in
/-- `memcpy_n n hd hdst hsrc hx`: a `memcpy` of `n` bytes by `run_memcpy_read`, its facts given. -/
local macro "memcpy_n " n:num hd:term:max hdst:term:max hsrc:term:max hx:term:max : tactic =>
  `(tactic| step_impure => (expect_values; exact run_memcpy_read (n := $n) rfl $hd $hdst $hsrc $hx))

attribute [local mlir_read] readAt_storeOptEdwards_of_id_ne readEdwards_storeOptEdwards_of_id_ne

/-- `decompress` on bytes that decode to `P`. -/
theorem decompress_call_eq' {out repr : Pointer} {s : GlobalState} {P : Option EdwardsPoint}
    (hwf : s.WF) (hout : s.mem.OptEdwardsRoom out) (hrepr : Fits s.mem repr 256)
    (hrepr_off : ¬repr.offset.uaddOverflow 32#64)
    (hP : Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256) = P) :
    CompressedEdwardsY_decompress.call
        (CompressedEdwardsY_decompress.args (.value out) (.value repr)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + if P.isSome then 162 else 161⟩
            mem := s.mem.storeOptEdwards out P }) := by
  rw [CompressedEdwardsY_decompress.call_eq out repr s hwf hout hrepr hrepr_off, hP]

-- about 120 steps over a frame of 14 slots and 16 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
open VerificationKey_verify_dalek_prehashed in
/-- `self.verify_dalek_prehashed(signature, h)` for `self` (`minus_A` at `self + 32`), the 64-byte
`signature` (`r ‖ s`) and the scalar `h < 2^255`: returns `spec`'s byte. Everything it writes is in
its frame: the memory is unchanged, the counter moves on by `blocks`. -/
public theorem VerificationKey_verify_dalek_prehashed.call_eq (self sig h : Pointer)
    (s : GlobalState) (hwf : s.WF) (hself : s.mem.PointFit (self.add 32#64))
    (hself_off : ¬self.offset.uaddOverflow 32#64) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hh : Fits s.mem h 256)
    (hdh : (s.mem.readAt h 256).toNat < 2 ^ 255) :
    VerificationKey_verify_dalek_prehashed.call
        (VerificationKey_verify_dalek_prehashed.args (.value self) (.value sig) (.value h)) s =
      .value
        (.cons
            (.value
              (spec (s.mem.readEdwards (self.add 32#64)) (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt h 256)))
            .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (s.mem.readEdwards (self.add 32#64)) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt h 256)⟩
            mem := s.mem }) := by
  generalize hres : spec _ _ _ _ = res
  generalize hblk : blocks _ _ _ _ = k
  generalize hA : self.add 32#64 = A at hself hres hblk
  obtain ⟨vh, hvh⟩ : ∃ v, s.mem.readAt h 256 = v := ⟨_, rfl⟩
  obtain ⟨r, hr⟩ : ∃ v, s.mem.readAt sig 256 = v := ⟨_, rfl⟩
  obtain ⟨sc, hsc⟩ : ∃ v, s.mem.readAt (sig.add 32#64) 256 = v := ⟨_, rfl⟩
  obtain ⟨mA, hmA⟩ : ∃ v, s.mem.readEdwards A = v := ⟨_, rfl⟩
  rw [hvh] at hdh
  have hsig_off32 : ¬sig.offset.uaddOverflow 32#64 :=
    BitVec.not_uaddOverflow_of_le hsig_off (by decide)
  rw [hvh, hr, hsc, hmA] at hres hblk
  func_init
  have hr₀ : S₀.mem.readAt sig 256 = r := hS ▸ hr
  have hsc₀ : S₀.mem.readAt (sig.add 32#64) 256 = sc := hS ▸ hsc
  block_init
  iterate 11 step_pure
  step_alloca with pt20
  step_alloca with ppow
  step_alloca with pt3
  step_alloca with pt19
  step_alloca with precip
  step_alloca with pcs
  step_alloca with paff
  step_alloca with pred
  step_alloca with pexp
  step_alloca with ps
  step_alloca with popt
  step_alloca with pres1
  step_alloca with pres2
  step_alloca with pR
  -- if self.minus_A.is_small_order() { return Err(Error::InvalidSignature); }
  step_pure [hA]
  step_call using EdwardsPoint_is_small_order.call_eq
  finish_block
  case isTrue =>
    block_init
    finish_block
    subst hS
    erase_frame
    rw [← hres, ← hblk]
    simp only [spec, blocks, hbr, ↓reduceIte, GlobalState.alloca_alloc, Nat.add_assoc,
      Nat.reduceAdd]
  case isFalse =>
    have hnA := hbr
    clear hbr
    -- let R = CompressedEdwardsY(*signature.r_bytes()).decompress().ok_or(..)?;
    block_init
    iterate 4 step_pure
    have hopt : S.mem.OptEdwardsRoom popt :=
      ⟨by simp [hpopt_off], hroom_popt.mono (by decide),
        Room.add_of_le (by simp [hpopt_off, BitVec.uaddOverflow]) (by decide) hroom_popt⟩
    rcases hdec : Serial.CompressedEdwardsY_decompress.spec r with _ | R
    case
      none =>
      step_call using
        (decompress_call_eq' (hP :=
          (congrArg Serial.CompressedEdwardsY_decompress.spec hr).trans hdec)) consuming
        hopt
      step_load
      step_pure
      finish_block
      block_init
      iterate 3 step_pure
      finish_block
      block_init
      step_pure
      finish_block
      block_init
      finish_block
      subst hS
      simp only [MemoryState.storeOptEdwards]
      erase_frame
      rw [← hres, ← hblk]
      simp only [spec, blocks, hnA, hdec, ↓reduceIte, Option.isSome_none, Bool.false_eq_true,
        GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
    case
      some =>
      step_call using
        (decompress_call_eq' (hP :=
          (congrArg Serial.CompressedEdwardsY_decompress.spec hr).trans hdec)) consuming
        hopt
      step_load
      step_pure
      finish_block
      block_init
      step_pure
      step_pure
      memcpy_n
        160(slots_disjoint hpres1 hpopt (by decide) 6#64 8#64 _
          _)(room_add hroom_pres1 hpres1_off
          (by decide))(fits_of_pointFit hpointFit_popt_8)hread_popt_8
      step_pure
      step_pure
      memcpy_n
        160(slots_disjoint hpres2 hpres1 (by decide) 6#64 6#64 _
          _)(room_add hroom_pres2 hpres2_off (by decide))hfits_pres1_6 hread_pres1_6
      step_pure
      memcpy_n
        160(by
          simpa only [Pointer.add_zero'] using
            slots_disjoint hpR hpres2 (by decide) 0#64 6#64 _ _)hroom_pR hfits_pres2_6 hread_pres2_6
      step_pure
      clear hread_pres2_6 hread_pres1_6 hread_popt hread_popt_8_readEdwards hread_popt_8
      have hR_fit := pointFit_of_fits hfits_pR (by simp [hpR_off])
      have hR_read := readEdwards_of_readAt hfits_pR (by simp [hpR_off]) hread_pR
      clear hread_pR
      -- if R.is_small_order() { return Err(Error::InvalidSignature); }
      step_call using EdwardsPoint_is_small_order.call_eq [hR_read]
      finish_block
      case isTrue =>
        block_init
        step_pure
        finish_block
        block_init
        finish_block
        subst hS
        simp only [MemoryState.storeOptEdwards]
        erase_frame
        rw [← hres, ← hblk]
        simp only [spec, blocks, hnA, hbr, hdec, ↓reduceIte, Option.isSome_some,
          GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
      case isFalse =>
        have hnR := hbr
        clear hbr
        -- let s = Option::<Scalar>::from(Scalar::from_canonical_bytes(*signature.s_bytes()))
        block_init
        iterate 3 step_pure
        have hs_off := s_noOverflow hsig_off
        have hs31 := readAt_s31 (by mem_fact) hs_off hsc₀
        step_load [hs31]
        clear hs31
        step_pure
        step_pure
        step_call using Serial.black_box_u8.call_eq with high_bit_unset
        step_pure
        obtain ⟨reduced, hreduced⟩ : ∃ x, Serial.Scalar_reduce.spec sc = x := ⟨_, rfl⟩
        step_call using
          (reduce_call_eq (hx := (congrArg Serial.Scalar_reduce.spec hsc).trans hreduced))
        step_call using Serial.slice_u8_ConstantTimeEq_ct_eq.call_eq [hsc₀] with is_canonical
        step_pure
        step_pure
        step_call using Serial.black_box_u8.call_eq with choice
        step_pure
        have hchoice' : choice = Serial.Scalar_from_canonical_bytes.spec sc := by
          rw [hchoice, his_canonical, hhigh_bit_unset, high_bit_eq, ← hreduced]
          rfl
        clear hchoice his_canonical hhigh_bit_unset hread_pred
        finish_block
        case isFalse =>
          block_init
          step_pure
          finish_block
          block_init
          step_pure
          finish_block
          block_init
          finish_block
          subst hS
          simp only [MemoryState.storeOptEdwards]
          erase_frame
          rw [← hres, ← hblk]
          simp only [spec, blocks, hnA, hnR, hbr, hdec, ↓reduceIte, Option.isSome_some,
            GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
        case isTrue =>
          have hs_lt := lt_of_canonical hbr
          block_init
          -- `s`'s bytes copied to `ps`
          step_pure
          have hs0 := readAt_s0 hsc₀
          step_load [hs0]
          clear hs0
          step_pure
          memcpy_n
            31(Range.disjoint_of_id_ne
              (by
                simpa only [Pointer.add_id] using
                  hsig_ne_ps.symm))(room_add hroom_ps hps_off
              (by
                decide))(Fits.add_of_le (BitVec.not_uaddOverflow_of_le hsig_off (by decide))
              (by decide) hsig)(readAt_s_tail (by mem_fact) hs_off hsc)
          step_store
          obtain ⟨hps_fit, hps_read⟩ := scalar_copy hps_off hfits_ps hfits_ps_1 hread_ps hread_ps_1
          clear hfits_ps hfits_ps_1 hread_ps hread_ps_1
          -- let expected_R = vartime_double_scalar_mul_basepoint(&h, &self.minus_A, &s).compress();
          step_pure
          have hexp := MemoryState.PointRoom.of_room hroom_pexp hpexp_off
          have hdh' : (S.mem.readAt h 256).toNat < 2 ^ 255 := hvh ▸ hdh
          have hds : (S.mem.readAt ps 256).toNat < 2 ^ 255 := hps_read ▸ hs_lt
          step_call using impl_mul.call_eq consuming hdh' hds
          name_point P
          clear hvh hsc hmA hR_read hps_read hps_fit hfits_pR hR_fit hroom_pR hroom_ps
          -- let recip = self.Z.invert();
          iterate 4 step_pure
          have hppow_40 :=
            Agave.limbsRoom_add (k := 40#64) hroom_ppow hppow_off (by decide) (by decide)
          have hppow_limbs := MemoryState.LimbsRoom.of_room (hroom_ppow.mono (by decide)) hppow_off
          clear hroom_ppow hppow_bounds
          step_call using (pow22501_call_eq (hZ := hread_pexp_80))
          name_limbs t3
          name_limbs t19
          step_pure
          memcpy_n
            40(by
              simpa only [Pointer.add_zero'] using
                slots_disjoint hpt19 hppow (by decide) 0#64 0#64 _
                  _)hroom_pt19(fits_of_limbsFit
              hppow_limbs)((readAt_eq_limbsBits hppow_limbs).trans (congrArg limbsBits hread_ppow))
          step_pure
          step_pure
          memcpy_n
            40(by
              simpa only [Pointer.add_zero'] using
                slots_disjoint hpt3 hppow (by decide) 0#64 40#64 _
                  _)hroom_pt3(fits_of_limbsFit hppow_40)hread_ppow_40
          step_pure
          clear hread_ppow hread_ppow_40_readLimbs hread_ppow_40
          have hpt19_limbs := limbsFit_of_fits hfits_pt19 (by simp [hpt19_off])
          have hpt19_read :=
            readLimbs_of_readAt_limbsBits hfits_pt19.inBounds (by simp [hpt19_off]) hread_pt19
          have hpt3_limbs := limbsFit_of_fits hfits_pt3 (by simp [hpt3_off])
          have hpt3_read :=
            readLimbs_of_readAt_limbsBits hfits_pt3.inBounds (by simp [hpt3_off]) hread_pt3
          clear hfits_pt19 hread_pt19 hroom_pt19 hfits_pt3 hread_pt3 hroom_pt3
          step_pure
          have hpt20_limbs := MemoryState.LimbsRoom.of_room hroom_pt20 hpt20_off
          step_call using (pow2k_call_eq (hX := hpt19_read))
          name_limbs t20
          have hprecip_limbs := MemoryState.LimbsRoom.of_room hroom_precip hprecip_off
          step_call using (mul_call_eq (hX := hread_pt20_readLimbs) (hY := hpt3_read))
          name_limbs recip
          iterate 3 step_pure
          clear hpt19_read hpt3_read hread_pt20_readLimbs hread_pt20
          -- let x = &self.X * &recip;
          have hpaff_40 :=
            Agave.limbsRoom_add (k := 40#64) hroom_paff hpaff_off (by decide) (by decide)
          have hpaff_limbs := MemoryState.LimbsRoom.of_room (hroom_paff.mono (by decide)) hpaff_off
          step_call using (mul_call_eq (hX := hread_pexp_readLimbs) (hY := hread_precip_readLimbs))
          name_limbs x
          -- let y = &self.Y * &recip;
          step_pure
          step_pure
          step_call using (mul_call_eq (hX := hread_pexp_40) (hY := hread_precip_readLimbs))
          name_limbs y
          step_pure
          clear hread_precip_readLimbs hread_precip hpaff_40
          -- let mut s = self.y.to_bytes(); s[31] ^= self.x.is_negative().unwrap_u8() << 7;
          step_call using (to_bytes_call_eq (hX := hread_paff_40_readLimbs))
          step_call using (is_negative_call_eq (hX := hread_paff_readLimbs)) with x_is_negative
          step_pure
          step_pure
          step_load
          step_pure
          step_store
          step_pure
          step_pure
          -- if expected_R.as_bytes() == signature.r_bytes() { Ok(()) } else { Err(..) }
          step_call using Operation.bcmp_eq [hr₀] with cmp
          step_pure
          step_pure [hcmp, Operation.bcmpResult_eq_zero_iff]
          step_pure
          finish_block
          block_init
          step_pure
          finish_block
          block_init
          finish_block
          subst hS
          simp only [MemoryState.storeOptEdwards]
          erase_frame
          simp only [bcmp_select, spliceBits_248]
          rw [← hres, ← hblk]
          simp only [spec, blocks, hnA, hnR, hbr, hdec, ↓reduceIte, Option.isSome_some,
            GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd,
            Serial.EdwardsPoint_compress.spec, Serial.FieldElement51_invert.spec, hx_is_negative,
            ht20, ht19, ht3, hP]
          simp only [← Nat.add_assoc, Nat.reduceAdd]
          rfl

end Proof

end MLIR.Agave.Avx2

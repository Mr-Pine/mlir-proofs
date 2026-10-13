module

public import Agave.Common.Tactics
public import Agave.Avx2.Mlir.impl_mul
public import Agave.Avx2.Scalar_non_adjacent_form
public import Agave.Avx2.impl_mul.Loop
public import Agave.Avx2.impl_mul.Spec
public import Agave.Serial.mul
public import Firedancer.Common.Tactics
public import MLIR.Run.Tactic
import all Agave.Serial.mul
import Mathlib.Tactic.IntervalCases
import all MLIR.Ty

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

namespace impl_mul

open Serial.mul (digit start)
open NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from
open
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from renaming
  spec → tableSpec, args → tableArgs

/-- Room for a point's 160 bytes at once. -/
theorem room_of_pointRoom {m : MemoryState} {p : Pointer} (h : m.PointRoom p) : Room m p 1280 := by
  obtain ⟨ho, ⟨-, h0, -⟩, -, -, ⟨-, -, -, -, -, h4⟩⟩ := h
  obtain ⟨b, hb, hl, -⟩ := h0
  obtain ⟨b', hb', -, hw'⟩ := h4
  have hid : ((p.add 120#64).add 32#64).id = p.id := rfl
  rw [hid, hb] at hb'
  cases hb'
  have hov1 : ¬p.offset.uaddOverflow 120#64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; simp; omega
  have hov2 : ¬(p.add 120#64).offset.uaddOverflow 32#64 := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt
        (by
          simp; omega)]
    simp
    omega
  rw [Pointer.offsetInBits_add hov2, Pointer.offsetInBits_add hov1] at hw'
  exact
    ⟨b, hb, hl, by
      simp at hw'; omega⟩

/-- `SlotsIn` from each temporary's bounds. -/
theorem SlotsIn.of_bounds {m : MemoryState} {B : GlobalState} (h1 : InBounds m (B.slot 1) 1280)
    (h2 : InBounds m (B.slot 2) 1280) (h3 : InBounds m (B.slot 3) 1280)
    (h4 : InBounds m (B.slot 4) 1280) (h5 : InBounds m (B.slot 5) 1280)
    (h6 : InBounds m (B.slot 6) 1280) (h7 : InBounds m (B.slot 7) 1280)
    (h8 : InBounds m (B.slot 8) 1280) (h9 : InBounds m (B.slot 9) 1280) : SlotsIn m B := by
  unfold SlotsIn
  intro k hk1 hk9
  interval_cases k <;> assumption

/-- `NafLookupTable5::<CachedPoint>::from`'s `call_eq`, its store spelled as the store of its
bits. -/
theorem tableA_call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 10240) (ha : s.mem.PointFit a) :
    NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.call
        (tableArgs (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 68⟩,
            mem := s.mem.storeAt out (naf5Bits (tableSpec (s.mem.readEdwards a))) }) :=
  NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.call_eq
    out a s hwf hout ha

/-- The identity's global, as registers' bits. -/
theorem identity_bits {hw : (Ty.array 160 (.bv 8)).width = 1280} :
    Ty.flatBits (t := .array 160 (.bv 8)) EXTENDEDPOINT_IDENTITY.lit (hw := hw) =
      fe4xBits EXTENDEDPOINT_IDENTITY.point := by
  rw [EXTENDEDPOINT_IDENTITY.flatBits_lit, ← EXTENDEDPOINT_IDENTITY.ofBits_eq, fe4xBits_ofBits]

end impl_mul

open impl_mul
open Serial.mul (digitsA digitsB start_le)

/-- `vartime_double_base::spec_avx2::mul(a, A, b)` stores `spec` of the scalars' bytes at `a` and
`b` and the point at `A` at `out`, the `sret` slot. Every read of `a`, `A` and `b` comes before
the first store to `out`, so `out` may alias them. Scalars below `2^255` keep the digits in the
tables' bounds. -/
public theorem impl_mul.call_eq (out a A b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PointRoom out) (ha : Fits s.mem a 256) (hA : s.mem.PointFit A)
    (hb : Fits s.mem b 256) (hda : (s.mem.readAt a 256).toNat < 2 ^ 255)
    (hdb : (s.mem.readAt b 256).toNat < 2 ^ 255) :
    impl_mul.call (impl_mul.args (.value out) (.value a) (.value A) (.value b)) s =
      .value
        (.nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock + impl_mul.blocks (s.mem.readAt a 256) (s.mem.readAt b 256)⟩
            mem :=
              s.mem.storeEdwards out
                (impl_mul.spec (s.mem.readAt a 256) (s.mem.readEdwards A)
                  (s.mem.readAt b 256)) }) := by
  -- the inputs, named; the spec and the counter folded for `func_init`
  obtain ⟨xa, hxa⟩ : ∃ x, s.mem.readAt a 256 = x := ⟨_, rfl⟩
  obtain ⟨xb, hxb⟩ : ∃ x, s.mem.readAt b 256 = x := ⟨_, rfl⟩
  obtain ⟨P, hP⟩ : ∃ P, s.mem.readEdwards A = P := ⟨_, rfl⟩
  rw [hxa, hxb, hP]
  rw [hxa] at hda
  rw [hxb] at hdb
  have hout_r := room_of_pointRoom hout
  have hout_off : out.offset.toNat + 160 ≤ 2 ^ 64 := hout.1
  clear hout
  generalize hR : impl_mul.spec xa P xb = R
  generalize hk : impl_mul.blocks xa xb = k
  func_init
  have houtLt := GlobalState.WF.id_lt_of_inBounds hwf₀ hout_r₀.inBounds
  block_init
  iterate 7 step_pure
  -- the identity's global
  step_addressof EXTENDEDPOINT_IDENTITY.value_eq with idp
  iterate 5 step_pure
  -- the slots
  step_alloca with selBm
  step_alloca with sumBm
  step_alloca with selBp
  step_alloca with sumBp
  step_alloca with selAm
  step_alloca with sumAm
  step_alloca with selAp
  step_alloca with sumAp
  step_alloca with dbl
  step_alloca with Q
  step_alloca with table_A
  step_alloca with b_naf
  step_alloca with a_naf
  -- let a_naf = a.non_adjacent_form(5); let b_naf = b.non_adjacent_form(8);
  step_pure
  step_call using Scalar_non_adjacent_form.call_eq consuming hxa
  step_pure
  step_call using Scalar_non_adjacent_form.call_eq consuming hxb
  finish_block
  have hσ :
    (⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩ :
          Slots).At
      S₀ :=
    ⟨hidp, hselBm, hsumBm, hselBp, hsumBp, hselAm, hsumAm, hselAp, hsumAp, hdbl, hQ, htable_A,
      hb_naf, ha_naf⟩
  -- for j in (0..256).rev() { i = j; if a_naf[i] != 0 || b_naf[i] != 0 { break; } }
  refine
    search_loop out a A b
      ⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩ _
      _ S hfits_a_naf hread_a_naf hfits_b_naf hread_b_naf ha_naf_off hb_naf_off _ _ 255 (by decide)
      E hArgs (by env_reads) (by env_reads) fun E₁ h₁ h₂ h₃ => ?_
  -- let table_A = NafLookupTable5::<CachedPoint>::from(A); let mut Q = ExtendedPoint::identity();
  block_init
  step_pure
  step_call using tableA_call_eq consuming hP
  have hid : S.mem.readAt idp 1280 = fe4xBits EXTENDEDPOINT_IDENTITY.point :=
    hread_idp.trans identity_bits
  step_memcpy consuming hid hidp_fits
  finish_block
  -- the loop's facts
  have hsl : SlotsIn S.mem S₀ :=
    SlotsIn.of_bounds (hselBm ▸ hselBm_bounds) (hsumBm ▸ hsumBm_bounds) (hselBp ▸ hselBp_bounds)
      (hsumBp ▸ hsumBp_bounds) (hselAm ▸ hselAm_bounds) (hsumAm ▸ hsumAm_bounds)
      (hselAp ▸ hselAp_bounds) (hsumAp ▸ hsumAp_bounds) (hdbl ▸ hdbl_bounds)
  have hF :
    LoopFacts S
      ⟨idp, selBm, sumBm, selBp, sumBp, selAm, sumAm, selAp, sumAp, dbl, Q, table_A, b_naf, a_naf⟩
      S₀ out P (Scalar_non_adjacent_form.spec xa 5) (Scalar_non_adjacent_form.spec xb 8) :=
    ⟨hwf, hout_r, hout_off, hsl, hfits_Q, hfits_a_naf, hread_a_naf, hfits_b_naf, hread_b_naf,
      houtLt, hfits_table_A, hread_table_A⟩
  have hSa : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 84 := by
    rw [hS]
    simp [GlobalState.alloca]
  -- loop { … }
  refine
    main_loop out a A b _ S₀ hσ P _ _ (digitsA xa hda) (digitsB xb hdb) _ _ _
      (lt_of_le_of_lt (start_le _ _ 255) (by decide)) _ S E hArgs (by env_reads) (by env_reads) hF
      hread_Q fun E₃ S₃ h₁ hR₃ hF₃ hv₃ ha₃ he₃ => ?_
  -- Q.into()
  rw [exit_block out a A b _ S₀ hσ P _ _ S₀.alloc.nextFreeBlock le_rfl _ S₃ E₃ h₁ hR₃ hF₃ hv₃]
  have hmem : S₃.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [he₃, hS]
    erase_frame
  rw [hmem, show S₃.alloc = ⟨S₃.alloc.nextFreeBlock⟩ from rfl, ha₃, hSa, ← hR, ← hk]
  simp only [blocks, spec]
  rw [Nat.add_assoc]

end Proof

end MLIR.Agave.Avx2

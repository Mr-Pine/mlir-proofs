module

public import Agave.Common.Tactics
public import Agave.Serial.Mlir.mul
public import Agave.Serial.Scalar_non_adjacent_form
public import Agave.Serial.mul.Loop
public import Agave.Serial.mul.Spec
public import Firedancer.Common.Tactics
public import MLIR.Run.Tactic
import all MLIR.Ty

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

public theorem anon_042b818bc72209407b52bd0e4d6c8368_73.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_73.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_73.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

set_option hygiene false in
/-- `checkpoint hck`: `hS` kept as `hck`, the state a fresh base for the next steps. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

namespace mul

/-- Limbs that fit from their 320 bits that fit. -/
theorem limbsFit_of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 32) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) h

/-- Limbs at `p`, from the 320 bits there. -/
theorem readLimbs_of_readAt {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (hf : Fits m p 320) (ho : p.offset.toNat + 32 < 2 ^ 64) (h : m.readAt p 320 = limbsBits l) :
    m.readLimbs p = l := by
  have hr : m.LimbsRoom p := (limbsFit_of_fits hf ho).room
  rw [← MemoryState.storeAt_readAt_self hf, h, ← storeLimbs_eq_storeAt ho]
  exact MemoryState.readLimbs_storeLimbs_self hr

/-- `X`'s bits after the `memset`: `ZERO`'s limbs'. -/
theorem zero_bits : (0#320 : BitVec 320) = limbsBits FieldElement51.ZERO := by decide +kernel

/-- `ONE`'s global: `ONE`'s limbs' bits. -/
theorem one_bits {hw : (Ty.array 40 (.bv 8)).width = 320} :
    Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw := hw) =
      limbsBits FieldElement51.ONE := by
  decide +kernel +revert

/-- The search's start index is at most where it starts. -/
theorem start_le (an bn : BitVec (8 * 256)) : ∀ i, start an bn i ≤ i
  | 0 => le_rfl
  | i + 1 => by
    rw [start]
    split
    · exact Nat.le_succ_of_le (start_le an bn i)
    · exact le_rfl

/-- `non_adjacent_form(5)`'s digits of a scalar below `2^255` are width-5 digits. -/
theorem digitsA (x : BitVec 256) (hx : x.toNat < 2 ^ 255) :
    DigitsA (Scalar_non_adjacent_form.spec x 5) := by
  intro i hi
  have h := Scalar_non_adjacent_form.toInt_lane_spec (w := 5) (by decide) (by decide) hx i hi
  have hd := Naf.digit_naf (w := 5) (by decide) hx i hi
  simp only [digit, h]
  rcases hd with h0 | ⟨-, h1, h2⟩
  · omega
  · rw [show (2 : ℤ) ^ (5 - 1) = 16 by decide] at h1 h2
    omega

/-- `non_adjacent_form(8)`'s digits of a scalar below `2^255` are not `-128`. -/
theorem digitsB (x : BitVec 256) (hx : x.toNat < 2 ^ 255) :
    DigitsB (Scalar_non_adjacent_form.spec x 8) := by
  intro i hi
  have h := Scalar_non_adjacent_form.toInt_lane_spec (w := 8) (by decide) (by decide) hx i hi
  simp only [digit, h]
  exact ((Naf.digit_naf (w := 8) (by decide) hx i hi).lt_128 (by decide)).1

end mul

open mul

-- 4 globals and 28 slots before the first call, each step carrying the facts: past the default
-- heartbeats
set_option maxHeartbeats 1000000 in
/-- `mul(a, A, b)` stores `spec` of the scalars' bytes at `a` and `b` and the point at `A` at
`out`, the `sret` slot. Every read of `a`, `A` and `b` comes before the first store to `out`, so
`out` may alias them. Scalars below `2^255` keep the digits in the tables' bounds. -/
public theorem mul.call_eq (out a A b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PointRoom out) (ha : Fits s.mem a 256) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hA : s.mem.PointFit A) (hb : Fits s.mem b 256) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hda : (s.mem.readAt a 256).toNat < 2 ^ 255) (hdb : (s.mem.readAt b 256).toNat < 2 ^ 255) :
    mul.call (mul.args (.value out) (.value a) (.value A) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + mul.blocks (s.mem.readAt a 256) (s.mem.readAt b 256)⟩
            mem :=
              s.mem.storeEdwards out
                (mul.spec (s.mem.readAt a 256) (s.mem.readEdwards A) (s.mem.readAt b 256)) }) := by
  -- the inputs, named; the spec and the counter folded for `func_init`
  obtain ⟨xa, hxa⟩ : ∃ x, s.mem.readAt a 256 = x := ⟨_, rfl⟩
  obtain ⟨xb, hxb⟩ : ∃ x, s.mem.readAt b 256 = x := ⟨_, rfl⟩
  obtain ⟨P, hP⟩ : ∃ P, s.mem.readEdwards A = P := ⟨_, rfl⟩
  rw [hxa, hxb, hP]
  rw [hxa] at hda
  rw [hxb] at hdb
  generalize hQ : mul.spec xa P xb = Q
  generalize hk : mul.blocks xa xb = k
  func_init
  block_init
  iterate 8 step_pure
  -- the globals: `ONE`, the panics' locations, `AFFINE_ODD_MULTIPLES_OF_BASEPOINT`
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_1.value_eq with one
  iterate 2 step_pure
  have hone_ne := GlobalState.ne_allocaPtr_of_inBounds hwf hone_fits.inBounds
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_10 with locA
  checkpoint hck0
  rename' S => S₁
  iterate 2 step_pure
  have hone_ne := GlobalState.ne_allocaPtr_of_inBounds hwf hone_fits.inBounds
  have hlocA_ne := GlobalState.ne_allocaPtr_of_inBounds hwf hlocA_room.inBounds
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_74 with locB
  checkpoint hck1
  rename' S => S₂
  obtain ⟨N₂, hN₂⟩ : ∃ n, S₂.alloc.nextFreeBlock = n := ⟨_, rfl⟩
  have houtLt : out.id.id < N₂ := hN₂ ▸ GlobalState.WF.id_lt_of_inBounds hwf hout.2.1.2.1.inBounds
  have hS₂ : N₂ = S₀.alloc.nextFreeBlock + 3 := by
    subst hck1 hck0
    rw [← hN₂]
    rfl
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_73.value_eq with table_B
  -- the slots
  step_alloca with aaZ2
  step_alloca with aaTxy2d
  step_alloca with aaMM
  step_alloca with aaPP
  step_alloca with aaYmX
  step_alloca with aaYpX
  step_alloca with asZ2
  step_alloca with asTxy2d
  step_alloca with asMP
  step_alloca with asPM
  step_alloca with asYmX
  step_alloca with asYpX
  step_alloca with nsZZ2
  step_alloca with nsZZ
  step_alloca with nsTT2d
  step_alloca with nsMP
  step_alloca with nsPM
  step_alloca with nsYmX
  step_alloca with nsYpX
  step_alloca with xBm
  step_alloca with xBp
  step_alloca with xAm
  step_alloca with xAp
  step_alloca with t
  step_alloca with r
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
    (⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
            nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
            a_naf⟩ :
          Slots).At
      S₂ :=
    ⟨htable_B, haaZ2, haaTxy2d, haaMM, haaPP, haaYmX, haaYpX, hasZ2, hasTxy2d, hasMP, hasPM, hasYmX,
      hasYpX, hnsZZ2, hnsZZ, hnsTT2d, hnsMP, hnsPM, hnsYmX, hnsYpX, hxBm, hxBp, hxAm, hxAp, ht, hr,
      htable_A, hb_naf, ha_naf⟩
  -- for j in (0..256).rev() { i = j; if a_naf[i] != 0 || b_naf[i] != 0 { break; } }
  refine
    search_loop out a A b locA locB one
      ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
        nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
        a_naf⟩
      _ _ S hfits_a_naf hread_a_naf hfits_b_naf hread_b_naf ha_naf_off hb_naf_off _ _ 255
      (by decide) E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) fun E₁ h₁ h₂ h₃ => ?_
  -- let table_A = NafLookupTable5::<ProjectiveNielsPoint>::from(A);
  block_init
  step_pure
  step_call using tableA_call_eq consuming hP
  -- let mut r = ProjectivePoint::identity();
  step_pure
  step_memset
  step_pure
  step_memcpy
  step_pure
  step_memcpy
  iterate 12 step_pure
  finish_block
  -- the main loop's facts
  have hr_fit : S.mem.ProjectiveFit r := by
    have ho : r.offset.toNat + 120 ≤ 2 ^ 64 := by simp [hr_off]
    exact
      ⟨ho, limbsFit_of_fits hfits_r (by omega),
        limbsFit_of_fits hfits_r_40 (Pointer.coord_offset_le (a := 40) ho (by omega)),
        limbsFit_of_fits hfits_r_80 (Pointer.coord_offset_le (a := 80) ho (by omega))⟩
  have hrv : S.mem.readProjective r = ProjectivePoint_identity.spec := by
    have ho : r.offset.toNat + 120 ≤ 2 ^ 64 := by simp [hr_off]
    simp only [MemoryState.readProjective, ProjectivePoint_identity.spec]
    rw [readLimbs_of_readAt hfits_r (by omega) (hread_r.trans zero_bits),
      readLimbs_of_readAt hfits_r_40 (Pointer.coord_offset_le (a := 40) ho (by omega))
        (hread_r_40.trans one_bits),
      readLimbs_of_readAt hfits_r_80 (Pointer.coord_offset_le (a := 80) ho (by omega))
        (hread_r_80.trans one_bits)]
  have hsl : SlotsIn S.mem S₂ :=
    SlotsIn.of_bounds (haaZ2 ▸ haaZ2_bounds) (haaTxy2d ▸ haaTxy2d_bounds) (haaMM ▸ haaMM_bounds)
      (haaPP ▸ haaPP_bounds) (haaYmX ▸ haaYmX_bounds) (haaYpX ▸ haaYpX_bounds)
      (hasZ2 ▸ hasZ2_bounds) (hasTxy2d ▸ hasTxy2d_bounds) (hasMP ▸ hasMP_bounds)
      (hasPM ▸ hasPM_bounds) (hasYmX ▸ hasYmX_bounds) (hasYpX ▸ hasYpX_bounds)
      (hnsZZ2 ▸ hnsZZ2_bounds) (hnsZZ ▸ hnsZZ_bounds) (hnsTT2d ▸ hnsTT2d_bounds)
      (hnsMP ▸ hnsMP_bounds) (hnsPM ▸ hnsPM_bounds) (hnsYmX ▸ hnsYmX_bounds)
      (hnsYpX ▸ hnsYpX_bounds) (hxBm ▸ hxBm_bounds) (hxBp ▸ hxBp_bounds) (hxAm ▸ hxAm_bounds)
      (hxAp ▸ hxAp_bounds) (ht ▸ ht_bounds)
  have hF :
    LoopFacts S
      ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
        nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
        a_naf⟩
      S₂ out P (Scalar_non_adjacent_form.spec xa 5) (Scalar_non_adjacent_form.spec xb 8) :=
    ⟨hwf, hout, hr_fit, hsl, hfits_a_naf, hread_a_naf, hfits_b_naf, hread_b_naf, hN₂ ▸ houtLt,
      hfits_table_A, hread_table_A, htable_B_fits, hread_table_B⟩
  have hSa : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 106 := by
    rw [hS]
    simp [GlobalState.alloca, hN₂, hS₂]
  have hS₂le : S₀.alloc.nextFreeBlock ≤ S₂.alloc.nextFreeBlock := by omega
  -- loop { … }
  refine
    main_loop out a A b locA locB _ S₂ hσ P _ _ (digitsA xa hda) (digitsB xb hdb) _ _ _
      (lt_of_le_of_lt (start_le _ _ 255) (by decide)) _ S E hArgs ⟨by env_reads, by env_reads⟩
      (by env_reads) hF hrv fun E₃ S₃ h₁ hR₃ hF₃ hrv₃ ha₃ he₃ => ?_
  -- r.as_extended()
  rw [exit_block out a A b locA locB _ S₂ hσ P _ _ S₀.alloc.nextFreeBlock hS₂le _ S₃ E₃ h₁ hR₃ hF₃
      hrv₃]
  have hmem : S₃.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [← eraseFrom_eraseFrom_of_le hS₂le, he₃, eraseFrom_eraseFrom_of_le hS₂le, hS, ← hck1, ← hck0]
    erase_frame
  rw [hmem, show S₃.alloc = ⟨S₃.alloc.nextFreeBlock⟩ from rfl, ha₃, hSa, ← hQ, ← hk]
  simp only [blocks, spec]
  rw [Nat.add_assoc]

end Proof

end MLIR.Agave.Serial

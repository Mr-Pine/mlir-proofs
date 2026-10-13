module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Serial.FieldElement51_sqrt_ratio_i
public import Agave.Avx2.FieldElement51_Neg_neg
public import Agave.Avx2.FieldElement51_ConditionallySelectable_conditional_assign
public import Agave.Avx2.Mlir.FieldElement51_sqrt_ratio_i
import all MLIR.Ty

namespace MLIR.Agave.Avx2

open Serial (anon_042b818bc72209407b52bd0e4d6c8368_28 FieldElement51_square FieldElement51_Mul_mul
  FieldElement51_pow22501 FieldElement51_pow2k FieldElement51_ConstantTimeEq_ct_eq
  FieldElement51_is_negative black_box_u8)

/-! ## Proof -/

section Proof

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
      ( have $limbs:ident := Agave.limbsFit_of_fits $fits (by simp [$off:ident])
        have $readL:ident :=
          Agave.readLimbs_of_readAt_limbsBits (Fits.inBounds $fits) (by simp [$off:ident]) $read
        clear $fits $room $bounds $read))

set_option hygiene false in
/-- `copy p h`: a `memcpy` of the limbs at `p` (`hp_limbs`, `h : readLimbs p = l`), read as their
bits. -/
local macro "copy " p:ident readL:ident : tactic => do
  let n := p.getId.toString
  let limbs := Lean.mkIdent (.mkSimple s!"h{n}_limbs")
  `(tactic|
      ( have hsrc_fits := Agave.fits_of_limbsFit $limbs
        have hsrc_bits := (Agave.readAt_eq_limbsBits $limbs).trans (congrArg Agave.limbsBits $readL)
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

theorem sqrt_m1_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_28.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      Serial.FieldElement51.SQRT_M1 := by
  funext i
  fin_cases i <;> decide +kernel +revert

-- a long chain of calls: the state cut from the entry state every so often (`rir.stateDepth`)
set_option rir.stateDepth 64 in
-- about 120 steps over a frame of 19 blocks and 27 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `FieldElement::sqrt_ratio_i(u, v)` stores `Serial.FieldElement51_sqrt_ratio_i.spec u v`'s
`Choice` at `out` and its `r` at `out + 8`; the loads all come before those stores. The
temporaries', the global's and the callees' blocks are freed again: only the counter moves on. -/
public theorem FieldElement51_sqrt_ratio_i.call_eq (out u v : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out 8) (hout_off : ¬out.offset.uaddOverflow 48#64)
    (hout8 : s.mem.LimbsRoom (out.add 8#64)) (hu : s.mem.LimbsFit u) (hv : s.mem.LimbsFit v) :
    FieldElement51_sqrt_ratio_i.call
        (FieldElement51_sqrt_ratio_i.args (.value out) (.value u) (.value v)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 148⟩
            mem :=
              (s.mem.storeAt out
                    (Serial.FieldElement51_sqrt_ratio_i.spec (s.mem.readLimbs u)
                        (s.mem.readLimbs v)).1).storeLimbs
                (out.add 8#64)
                (Serial.FieldElement51_sqrt_ratio_i.spec (s.mem.readLimbs u)
                    (s.mem.readLimbs v)).2 }) := by
  func_init
  have hu_read : S.mem.readLimbs u = S₀.mem.readLimbs u := by rw [hS]
  have hv_read : S.mem.readLimbs v = S₀.mem.readLimbs v := by rw [hS]
  block_init
  iterate 3 step_pure
  step_addressof Serial.anon_042b818bc72209407b52bd0e4d6c8368_28.value_eq with sqrt_m1
  step_alloca with pt20
  step_alloca with ppw
  step_alloca with pt19
  step_alloca with pr_neg
  step_alloca with pr_prime
  step_alloca with pneg_u2
  step_alloca with pneg_u_i
  step_alloca with pneg_u
  step_alloca with pr_sq
  step_alloca with pcheck
  step_alloca with puv7
  step_alloca with pt21
  step_alloca with puv3
  step_alloca with pr
  step_alloca with pv3_sq
  step_alloca with pv7
  step_alloca with pv_sq
  step_alloca with pv3
  have hsqrt_m1_read := readLimbs_global hsqrt_m1_fits hsqrt_m1_off hread_sqrt_m1 sqrt_m1_limbs
  clear hread_sqrt_m1
  limbs_fit sqrt_m1
  limbs_room pr
  obtain ⟨U, hU⟩ : ∃ x, S₀.mem.readLimbs u = x := ⟨_, rfl⟩
  obtain ⟨V, hV⟩ : ∃ x, S₀.mem.readLimbs v = x := ⟨_, rfl⟩
  rw [hU, hV]
  rw [hU] at hu_read
  rw [hV] at hv_read
  -- let v3 = &v.square() * v;
  start pv3
  start pv_sq
  fe_call FieldElement51_square.call_eq v_sq pv_sq
  fe_call FieldElement51_Mul_mul.call_eq v3 pv3
  drop pv_sq
  step_pure
  -- let v7 = &v3.square() * v;
  start pv7
  start pv3_sq
  fe_call FieldElement51_square.call_eq v3_sq pv3_sq
  fe_call FieldElement51_Mul_mul.call_eq v7 pv7
  drop pv3_sq
  step_pure
  -- let mut r = &(u * &v3) * &(u * &v7).pow_p58();
  start puv3
  fe_call FieldElement51_Mul_mul.call_eq uv3 puv3
  start pt21
  start puv7
  fe_call FieldElement51_Mul_mul.call_eq uv7 puv7
  step_pure
  have hppw_limbs := MemoryState.LimbsRoom.of_room (hroom_ppw.mono (by decide)) hppw_off
  have hppw_limbs' := Agave.limbsRoom_add (k := 40#64) hroom_ppw hppw_off (by decide) (by decide)
  have hppw_off' : ppw.offset.toNat + 72 < 2 ^ 64 := by simp [hppw_off]
  clear hppw_bounds
  -- pow_p58: let (t19, _) = self.pow22501();
  step_call using FieldElement51_pow22501.call_eq
  name_limbs t3
  name_limbs t19
  clear hread_ppw_40 hread_ppw_40_readLimbs hppw_limbs' hppw_off'
  step_pure
  copy ppw hread_ppw
  copied pt19
  clear hread_ppw
  clear_facts ppw
  step_pure
  -- let t20 = t19.pow2k(2);
  start pt20
  fe_call FieldElement51_pow2k.call_eq t20 pt20
  -- let t21 = self * &t20;
  fe_call FieldElement51_Mul_mul.call_eq t21 pt21
  drop pt20
  drop pt19
  iterate 2 step_pure
  fe_call FieldElement51_Mul_mul.call_eq r0 pr
  drop puv7
  drop pt21
  drop puv3
  iterate 3 step_pure
  -- let check = v * &r.square();
  start pcheck
  start pr_sq
  fe_call FieldElement51_square.call_eq r_sq pr_sq
  fe_call FieldElement51_Mul_mul.call_eq check pcheck
  drop pr_sq
  step_pure
  -- let correct_sign_sqrt = check.ct_eq(u);
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with correct_sign_sqrt
  -- let flipped_sign_sqrt = check.ct_eq(&(-u));
  start pneg_u
  fe_call FieldElement51_Neg_neg.call_eq neg_u pneg_u
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with flipped_sign_sqrt
  drop pneg_u
  step_pure
  -- let flipped_sign_sqrt_i = check.ct_eq(&(&(-u) * i));
  start pneg_u_i
  start pneg_u2
  fe_call FieldElement51_Neg_neg.call_eq neg_u2 pneg_u2
  fe_call FieldElement51_Mul_mul.call_eq neg_u_i pneg_u_i
  drop pneg_u2
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with flipped_sign_sqrt_i
  drop pneg_u_i
  drop pcheck
  iterate 2 step_pure
  -- let r_prime = &constants::SQRT_M1 * &r;
  start pr_prime
  fe_call FieldElement51_Mul_mul.call_eq r_prime pr_prime
  clear hsqrt_m1_read
  clear_facts sqrt_m1
  -- r.conditional_assign(&r_prime, flipped_sign_sqrt | flipped_sign_sqrt_i);
  step_pure
  step_call using black_box_u8.call_eq
  fe_call FieldElement51_ConditionallySelectable_conditional_assign.call_eq r1 pr
  -- let r_is_negative = r.is_negative(); r.conditional_negate(r_is_negative);
  step_call using FieldElement51_is_negative.call_eq with r_is_negative
  start pr_neg
  fe_call FieldElement51_Neg_neg.call_eq r_neg pr_neg
  fe_call FieldElement51_ConditionallySelectable_conditional_assign.call_eq r2 pr
  drop pr_neg
  step_pure
  -- let was_nonzero_square = correct_sign_sqrt | flipped_sign_sqrt;
  step_pure
  step_call using black_box_u8.call_eq with was_nonzero_square
  -- (was_nonzero_square, r) at `out`
  step_store
  step_pure
  have hdst := Agave.room_of_limbsRoom hout8
  copy pr hread_pr_readLimbs
  clear hdst
  iterate 4 step_pure
  finish_block
  subst hneg_u
  have hspec : Serial.FieldElement51_sqrt_ratio_i.spec U V = (was_nonzero_square, r2) := by
    simp only [Serial.FieldElement51_sqrt_ratio_i.spec, Serial.FieldElement51_pow_p58.spec]
    simp only [← hv_sq, ← hv3, ← hv3_sq, ← hv7, ← huv3, ← huv7, ← ht19, ← ht20, ← ht21, ← hr0,
      ← hr_sq, ← hcheck, ← hcorrect_sign_sqrt, ← hneg_u2, ← hflipped_sign_sqrt, ← hneg_u_i,
      ← hflipped_sign_sqrt_i, ← hr_prime, ← hr1, ← hr_is_negative, ← hr_neg, ← hr2,
      ← hwas_nonzero_square]
  have hoff8 : (out.add 8#64).offset.toNat + 32 < 2 ^ 64 := hout8.1
  rw [hspec]
  clear_reads
  subst_vars
  erase_frame
  simp only [GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd,
    Agave.storeLimbs_eq_storeAt hoff8]

end Proof

end MLIR.Agave.Avx2

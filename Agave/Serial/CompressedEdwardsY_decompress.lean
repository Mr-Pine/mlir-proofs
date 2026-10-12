module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Agave.Common.Decompress
public import Agave.Serial.black_box_u8
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Serial.FieldElement51_is_negative
public import Agave.Serial.FieldElement51_pow22501
public import Agave.Serial.FieldElement51_pow2k
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.FieldElement51_ConstantTimeEq_ct_eq
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_Neg_neg
public import Agave.Serial.FieldElement51_ConditionallySelectable_conditional_assign
public import Agave.Serial.Mlir.CompressedEdwardsY_decompress
import all MLIR.Ty

namespace MLIR.Agave.Serial

open Firedancer.Ref (fd_f25519_d fd_f25519_sqrtm1)

/-! ## Specification -/

@[expose] public section

/-- `constants::EDWARDS_D`. -/
abbrev FieldElement51.EDWARDS_D : Fin 5 → BitVec 64 :=
  fd_f25519_d.limbs

/-- `constants::SQRT_M1`. -/
abbrev FieldElement51.SQRT_M1 : Fin 5 → BitVec 64 :=
  fd_f25519_sqrtm1.limbs

/-- `FieldElement51::from_bytes`: `load8_at(bytes, i)`, the little-endian `u64` at byte `i`, for
`i = 0, 6, 12, 19, 24`, shifted to bit `51 k` and masked to 51 bits. -/
def FieldElement51_from_bytes.spec (bytes : BitVec 256) : Fin 5 → BitVec 64
  | 0 => bytes.extractLsb' 0 64 &&& mask51
  | 1 => bytes.extractLsb' 48 64 >>> 3 &&& mask51
  | 2 => bytes.extractLsb' 96 64 >>> 6 &&& mask51
  | 3 => bytes.extractLsb' 152 64 >>> 1 &&& mask51
  | 4 => bytes.extractLsb' 192 64 >>> 12 &&& mask51

/-- `self.pow_p58()`: `self^((p - 5) / 8)`, by `pow22501`'s `t19`. -/
def FieldElement51_pow_p58.spec (self : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let t19 := (FieldElement51_pow22501.spec self).1
  let t20 := FieldElement51_pow2k.spec t19 2
  FieldElement51_Mul_mul.spec self t20

/-- `FieldElement::sqrt_ratio_i(u, v)`: `(was_nonzero_square, r)`, in the code's operand order. -/
def FieldElement51_sqrt_ratio_i.spec (u v : Fin 5 → BitVec 64) : BitVec 8 × (Fin 5 → BitVec 64) :=
  let sq := FieldElement51_square.spec
  let mul := FieldElement51_Mul_mul.spec
  let neg := FieldElement51_Neg_neg.spec
  let ct_eq := FieldElement51_ConstantTimeEq_ct_eq.spec
  let cond_assign := FieldElement51_ConditionallySelectable_conditional_assign.spec
  let v3 := mul (sq v) v
  let v7 := mul (sq v3) v
  let r := mul (mul u v3) (FieldElement51_pow_p58.spec (mul u v7))
  let check := mul v (sq r)
  let i := FieldElement51.SQRT_M1
  let correct_sign_sqrt := ct_eq check u
  let flipped_sign_sqrt := ct_eq check (neg u)
  let flipped_sign_sqrt_i := ct_eq check (mul (neg u) i)
  let r_prime := mul i r
  let r := cond_assign r r_prime (flipped_sign_sqrt_i ||| flipped_sign_sqrt)
  let r_is_negative := FieldElement51_is_negative.spec r
  let r := cond_assign r (neg r) r_is_negative
  let was_nonzero_square := flipped_sign_sqrt ||| correct_sign_sqrt
  (was_nonzero_square, r)

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

/-- The `w` bits at byte `k` of 32 bytes read as `buf`. -/
theorem readAt_bytes {m : MemoryState} {p : Pointer} {buf : BitVec 256} (hf : Fits m p 256)
    (ho : ¬p.offset.uaddOverflow 32#64) (h : m.readAt p 256 = buf) (k w : Nat)
    (hk : 8 * k + w ≤ 256) :
    m.readAt (p.add (BitVec.ofNat 64 k)) w = buf.extractLsb' (8 * k) w := by
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le] at ho ⊢
    simp only [BitVec.toNat_ofNat] at ho ⊢
    omega
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov
      (by
        simp; omega)
      h]
  congr 1
  simp; omega

/-- The first `w` bits of 32 bytes read as `buf`. -/
theorem readAt_bytes0 {m : MemoryState} {p : Pointer} {buf : BitVec 256} (h : m.readAt p 256 = buf)
    (w : Nat) (hw : w ≤ 256) : m.readAt p w = buf.extractLsb' 0 w := by
  rw [MemoryState.readAt_of_readAt_le hw h]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

theorem one_bits {hw : (Ty.array 40 (.bv 8)).width = 320} :
    Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_1.lit (hw := hw) =
      limbsBits FieldElement51.ONE := by
  decide +kernel +revert

/-- Limbs read one by one. -/
theorem readLimbs_of_reads {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (h0 : m.readAt p 64 = l 0) (h1 : m.readAt (p.add 8#64) 64 = l 1)
    (h2 : m.readAt (p.add 16#64) 64 = l 2) (h3 : m.readAt (p.add 24#64) 64 = l 3)
    (h4 : m.readAt (p.add 32#64) 64 = l 4) : m.readLimbs p = l := by
  funext i
  fin_cases i <;> assumption

/-- A field element global's limbs, from its block's 320 bits. -/
theorem readLimbs_global {m : MemoryState} {p : Pointer} {x : BitVec 320} {l : Fin 5 → BitVec 64}
    (hf : Fits m p 320) (ho : p.offset = 0) (h : m.readAt p 320 = x)
    (hx : (fun i : Fin 5 => x.extractLsb' (64 * i.val) 64) = l) : m.readLimbs p = l :=
  (MemoryState.readLimbs_of_readAt hf ho h).trans hx

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

theorem sqrt_m1_limbs {hw : (Ty.array 40 (.bv 8)).width = 320} :
    (fun i : Fin 5 =>
        (Ty.flatBits (t := .array 40 (.bv 8)) anon_042b818bc72209407b52bd0e4d6c8368_28.lit (hw :=
              hw)).extractLsb'
          (64 * i.val) 64) =
      FieldElement51.SQRT_M1 := by
  funext i
  fin_cases i <;> decide +kernel +revert

/-- Room for the limbs 40 bytes into an 80-byte slot. -/
theorem limbsRoom_add40 {m : MemoryState} {p : Pointer} (h : Room m p 640) (ho : p.offset = 0) :
    m.LimbsRoom (p.add 40#64) := by
  have hov : ¬p.offset.uaddOverflow 40#64 := by simp [ho, BitVec.uaddOverflow]
  have hr : Room m (p.add 40#64) 320 := Room.add_of_le hov (by decide) h
  have hoff : (p.add 40#64).offset.toNat = 40 := by simp [Pointer.add, ho]
  have hov' (off : BitVec 64) (hoff' : off.toNat ≤ 32) :
    ¬(p.add 40#64).offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, hoff]
    omega
  refine ⟨by omega, hr.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov' _ (by decide)) (by decide) hr

/-- 320 known bits hold limbs. -/
theorem limbsFit_of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (not_uaddOverflow_limb ho (by decide)) (by decide) h

/-- `limbsBits`' 64-bit pieces. -/
theorem extractLsb'_limbsBits (l : Fin 5 → BitVec 64) :
    (limbsBits l).extractLsb' 0 64 = l 0 ∧
      (limbsBits l).extractLsb' 64 64 = l 1 ∧
      (limbsBits l).extractLsb' 128 64 = l 2 ∧
      (limbsBits l).extractLsb' 192 64 = l 3 ∧ (limbsBits l).extractLsb' 256 64 = l 4 := by
  have h (a b c d e : BitVec 64) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 0 64 = a ∧
      (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 64 64 = b ∧
      (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 128 64 = c ∧
      (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 192 64 = d ∧
      (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 256 64 = e := by
    bv_decide
  exact h _ _ _ _ _

/-- The limbs of 320 bits read as `limbsBits l`: `l`. -/
theorem readLimbs_of_readAt_limbsBits {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (hb : InBounds m p 320) (ho : p.offset.toNat + 32 < 2 ^ 64) (h : m.readAt p 320 = limbsBits l) :
    m.readLimbs p = l := by
  have hr (k : BitVec 64) (hk : k.toNat ≤ 32) :=
    MemoryState.readAt_add_of_readAt (w := 64) hb (not_uaddOverflow_limb ho hk) (by omega) h
  obtain ⟨e0, e1, e2, e3, e4⟩ := extractLsb'_limbsBits l
  refine
    readLimbs_of_reads ?_
      (by
        rw [hr 8#64 (by decide)]; exact e1)
      (by
        rw [hr 16#64 (by decide)]; exact e2)
      (by
        rw [hr 24#64 (by decide)]; exact e3)
      (by
        rw [hr 32#64 (by decide)]; exact e4)
  rw [MemoryState.readAt_of_readAt_le (w := 64) (by decide) h, ← e0]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

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

public theorem anon_042b818bc72209407b52bd0e4d6c8368_28.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_28.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_28.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

-- about 230 steps over a frame of 32 blocks and 30 calls: past the default heartbeats
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
  iterate 2 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_28.value_eq with sqrt_m1
  iterate 4 step_pure
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
  step_alloca with pX_neg
  step_alloca with ret
  step_alloca with pYYd
  step_alloca with pv
  step_alloca with pu
  step_alloca with pYY
  step_alloca with pY
  step_alloca with pt
  step_alloca with st1
  step_alloca with pY'
  step_alloca with pX
  -- let Y = FieldElement::from_bytes(repr.as_bytes());
  obtain ⟨buf, hbuf⟩ : ∃ b, S₀.mem.readAt repr 256 = b := ⟨_, rfl⟩
  rw [hbuf]
  step_pure
  step_pure
  limbs_room pY
  have hb0 := readAt_bytes0 (hrepr_read.trans hbuf) 64 (by decide)
  have hb6 := readAt_bytes hrepr hrepr_off (hrepr_read.trans hbuf) 6 64 (by decide)
  have hb12 := readAt_bytes hrepr hrepr_off (hrepr_read.trans hbuf) 12 64 (by decide)
  have hb19 := readAt_bytes hrepr hrepr_off (hrepr_read.trans hbuf) 19 64 (by decide)
  have hb24 := readAt_bytes hrepr hrepr_off (hrepr_read.trans hbuf) 24 64 (by decide)
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
  have hsqrt_m1_read := readLimbs_global hsqrt_m1_fits hsqrt_m1_off hread_sqrt_m1 sqrt_m1_limbs
  have hone_bits := hread_one
  clear hread_D hread_sqrt_m1 hread_one
  limbs_fit D
  limbs_fit sqrt_m1
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
  rebase
  step_pure
  -- sqrt_ratio_i(&u, &v): let v3 = &v.square() * v;
  step_pure
  start pr
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
  rebase
  step_pure
  -- let mut r = &(u * &v3) * &(u * &v7).pow_p58();
  start puv3
  fe_call FieldElement51_Mul_mul.call_eq uv3 puv3
  drop pv3
  start pt21
  start puv7
  fe_call FieldElement51_Mul_mul.call_eq uv7 puv7
  drop pv7
  rebase
  step_pure
  have hppw_limbs := MemoryState.LimbsRoom.of_room (hroom_ppw.mono (by decide)) hppw_off
  have hppw_limbs' := limbsRoom_add40 hroom_ppw hppw_off
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
  rebase
  step_pure
  -- let t20 = t19.pow2k(2);
  start pt20
  fe_call FieldElement51_pow2k.call_eq t20 pt20
  drop pt19
  -- let t21 = self * &t20;
  fe_call FieldElement51_Mul_mul.call_eq t21 pt21
  drop pt20
  drop puv7
  step_pure
  step_pure
  fe_call FieldElement51_Mul_mul.call_eq r0 pr
  drop puv3
  drop pt21
  rebase
  iterate 3 step_pure
  -- let check = v * &r.square();
  start pcheck
  start pr_sq
  fe_call FieldElement51_square.call_eq r_sq pr_sq
  fe_call FieldElement51_Mul_mul.call_eq check pcheck
  drop pr_sq
  drop pv
  rebase
  step_pure
  -- let correct_sign_sqrt = check.ct_eq(u);
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with correct_sign_sqrt
  -- let flipped_sign_sqrt = check.ct_eq(&(-u));
  start pneg_u
  fe_call FieldElement51_Neg_neg.call_eq neg_u pneg_u
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with flipped_sign_sqrt
  drop pneg_u
  rebase
  step_pure
  -- let flipped_sign_sqrt_i = check.ct_eq(&(&(-u) * i));
  start pneg_u_i
  start pneg_u2
  fe_call FieldElement51_Neg_neg.call_eq neg_u2 pneg_u2
  drop pu
  fe_call FieldElement51_Mul_mul.call_eq neg_u_i pneg_u_i
  drop pneg_u2
  step_call using FieldElement51_ConstantTimeEq_ct_eq.call_eq with flipped_sign_sqrt_i
  drop pneg_u_i
  drop pcheck
  rebase
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
  drop pr_prime
  rebase
  -- let r_is_negative = r.is_negative(); r.conditional_negate(r_is_negative);
  step_call using FieldElement51_is_negative.call_eq with r_is_negative
  start pr_neg
  fe_call FieldElement51_Neg_neg.call_eq r_neg pr_neg
  fe_call FieldElement51_ConditionallySelectable_conditional_assign.call_eq r2 pr
  drop pr_neg
  rebase
  step_pure
  -- let was_nonzero_square = correct_sign_sqrt | flipped_sign_sqrt;
  step_pure
  step_call using black_box_u8.call_eq with was_nonzero_square
  -- step_1's tuple: (Choice, X) at `ret`, then `(X, Y)`
  step_pure
  copy pr hread_pr_readLimbs
  drop pr
  rebase
  iterate 5 step_pure
  -- (X, Y) at `st1`
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := st1) (q := ret) hst1 hret (by decide) 0#64 7#64
  step_memcpy consuming hdisj
  step_pure
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := st1) (q := pY) hst1 hpY (by decide) 40#64 0#64
  have hdst := room_add40 hroom_st1 hst1_off
  have hsrc := fits_of_limbsFit hY_fit
  have hY_bits := (readAt_eq_limbsBits hY_fit).trans (congrArg limbsBits hY_read)
  memcpy_n 40hdisj hdst hsrc
  clear hY_read hY_fit hY_bits hdisj hdst hsrc
  iterate 4 step_pure
  -- let X, Y
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := pX) (q := st1) hpX hst1 (by decide) 0#64 0#64
  memcpy_n 40hdisj hroom_pX hfits_st1
  clear hdisj
  copied pX
  step_pure
  have hdisj := by
    simpa only [Pointer.add_zero'] using
      slots_disjoint (p := pY') (q := st1) hpY' hst1 (by decide) 0#64 40#64
  memcpy_n 40hdisj hroom_pY' hfits_st1_40
  clear hdisj
  copied pY'
  clear_facts st1 ret
  clear hread_st1 hread_st1_40 hread_ret_7
  step_pure
  step_pure
  finish_block
  case isTrue =>
    block_init
    step_store
    iterate 2 step_pure
    finish_block
    have hnone : CompressedEdwardsY_decompress.spec buf = none := by
      simp only [hwas_nonzero_square, hflipped_sign_sqrt, hcorrect_sign_sqrt, hr0, ht21, ht20, ht19,
        huv7, huv3, hv7, hv3_sq, hv3, hv_sq, hv, hYYd, hu, hYY, ← hY] at hbr
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
    have hb31 := readAt_bytes hrepr hrepr_off (hrepr_read.trans hbuf) 31 8 (by decide)
    step_load consuming hb31
    step_pure
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
    have hsome : CompressedEdwardsY_decompress.spec buf = some ⟨X, Y, FieldElement51.ONE, T⟩ := by
      simp only [hwas_nonzero_square, hflipped_sign_sqrt, hcorrect_sign_sqrt, hr0, ht21, ht20, ht19,
        huv7, huv3, hv7, hv3_sq, hv3, hv_sq, hv, hYYd, hu, hYY, ← hY] at hbr
      have hb : ¬(CompressedEdwardsY_decompress.step_1 buf).1 = 0 := hbr
      unfold CompressedEdwardsY_decompress.spec
      simp only [hb, ↓reduceIte, Option.some.injEq]
      simp only [CompressedEdwardsY_decompress.step_2, CompressedEdwardsY_decompress.step_1,
        FieldElement51_sqrt_ratio_i.spec, FieldElement51_pow_p58.spec]
      -- fold the named values back, innermost first
      simp only [← hu, ← hv, ← hr_sq, ← hcheck, ← hneg_u2] at hflipped_sign_sqrt
      simp only [← hv, ← hr_sq, ← hcheck, ← hneg_u2, ← hneg_u_i] at hflipped_sign_sqrt_i
      simp only [← hr0, ← hr_prime, ← hr1] at hr_is_negative
      simp only [hY, ← hYY, ← hu, ← hYYd, ← hv, ← hv_sq, ← hv3, ← hv3_sq, ← hv7, ← huv3, ← huv7,
        ← ht19, ← ht20, ← ht21, ← hr0, ← hr_sq, ← hcheck, ← hneg_u2, ← hflipped_sign_sqrt,
        ← hneg_u_i, ← hflipped_sign_sqrt_i, ← hr_prime, ← hr1, ← hr_is_negative, ← hr_neg, ← hr2,
        ← hcompressed_sign_bit, ← hX_neg, ← hX, ← hT]
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

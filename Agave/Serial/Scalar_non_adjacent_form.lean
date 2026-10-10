module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Naf
public import Agave.Serial.Mlir.Scalar_non_adjacent_form
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

open _root_.MLIR.Agave.Scalar_non_adjacent_form

/-! ### `width`, `window_mask`, `64 - w`, `width / 2` -/

/-- `1 << w` and its uses, `nsw`/`nuw`/`exact`, for `2 ≤ w ≤ 8`. -/
theorem width_flags (h2 : 2 ≤ W) (h8 : W ≤ 8) :
    1#64 <<< W >>> W = 1#64 ∧
      (1#64 <<< W).sshiftRight W = 1#64 ∧
      (1#64 <<< W).saddOverflow 18446744073709551615#64 = false ∧
      BitVec.extractLsb' 0 1 (1#64 <<< W) = 0#1 := by
  have :
    ∀ k < 9,
      2 ≤ k →
        1#64 <<< k >>> k = 1#64 ∧
          (1#64 <<< k).sshiftRight k = 1#64 ∧
          (1#64 <<< k).saddOverflow 18446744073709551615#64 = false ∧
          BitVec.extractLsb' 0 1 (1#64 <<< k) = 0#1 := by
    decide
  exact this W (by omega) h2

/-- `64 - w`, `nsw nuw`. -/
theorem sub_w_flags {w : BitVec 64} (h : w.toNat ≤ 8) :
    (64#64).ssubOverflow w = false ∧ (64#64).usubOverflow w = false := by
  replace h : w ≤ 8#64 := by
    rw [BitVec.le_def]; simpa using h
  constructor <;> bv_decide

/-- The registers live in the loop: `bb0`'s constants and the ones `w` gives. -/
abbrev consts (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫) :
    ⟪Scalar_non_adjacent_form.Γ⟫ :=
  E[%121 := .value 0#8, %122 := .value 256#64, %124 := .value 1#64, %127 := .value 0#64, %128 :=
    .value 6#64, %129 := .value 63#64, %130 := .value xu, %136 := .value (mask W), %137 :=
    .value (64#64 - w), %138 := .value (1#64 <<< W >>> 1), %139 := .value (1#8 <<< W)]

/-- The registers at `^bb3`, the window at `pos` with `carry`. -/
abbrev hdr3 (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫)
    (pos c : Nat) : ⟪Scalar_non_adjacent_form.Γ⟫ :=
  (consts xu W w E)[%141 := .value (BitVec.ofNat 64 c), %142 := .value (BitVec.ofNat 64 pos)]

/-- The registers at `^bb5`: `bit_buf` read. -/
abbrev hdr5 (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫)
    (pos c : Nat) (bb : BitVec 64) : ⟪Scalar_non_adjacent_form.Γ⟫ :=
  (consts xu W w E)[%141 := .value (BitVec.ofNat 64 c), %142 := .value (BitVec.ofNat 64 pos),
    %155 := .value bb]

/-- The digits and `x_u64` stored over `Sb`. -/
abbrev st (naf xu : Pointer) (t : Vector ℤ 256) (X : BitVec 320) (Sb : GlobalState) : GlobalState :=
  { Sb with mem := (Sb.mem.storeAt naf (bytes t)).storeAt xu X }

/-- A sum of a byte and a bit: `nsw nuw`. -/
theorem small_add_flags (a b : BitVec 64) (ha : a < 256#64) (hb : b ≤ 1#64) :
    a.saddOverflow b = false ∧ a.uaddOverflow b = false := by constructor <;> bv_decide

/-- `carry + (bit_buf & window_mask)`: no overflow, and the window. -/
theorem window_add {bb : BitVec 64} (hW : W ≤ 8) (hc : c ≤ 1) (h : (bb &&& mask W).toNat = v)
    (hv : v < 2 ^ W) :
    (bb &&& mask W).saddOverflow (BitVec.ofNat 64 c) = false ∧
      (bb &&& mask W).uaddOverflow (BitVec.ofNat 64 c) = false ∧
      ((bb &&& mask W) + BitVec.ofNat 64 c).toNat = c + v := by
  have h256 : 2 ^ W ≤ 2 ^ 8 := Nat.pow_le_pow_right (by decide) hW
  have hcn : (BitVec.ofNat 64 c).toNat = c := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  obtain ⟨o1, o2⟩ :=
    small_add_flags (bb &&& mask W) (BitVec.ofNat 64 c)
      (by
        rw [BitVec.lt_def, h]; simp; omega)
      (by
        rw [BitVec.le_def, hcn]; simp; omega)
  refine ⟨o1, o2, ?_⟩
  rw [BitVec.toNat_add_of_lt (by omega), h, hcn]; omega

/-- `window & 1 == 0`: an even window. -/
theorem and_one_eq_zero_iff (v : BitVec 64) : v &&& 1#64 = 0#64 ↔ v.toNat % 2 = 0 := by
  rw [← BitVec.toNat_inj, BitVec.toNat_and, show (1#64).toNat = 2 ^ 1 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod]
  rfl

/-- `pos + 1`, `nsw nuw`, below `256`. -/
theorem succ_flags (h : pos < 256) :
    (BitVec.ofNat 64 pos).saddOverflow 1#64 = false ∧
      (BitVec.ofNat 64 pos).uaddOverflow 1#64 = false ∧
      BitVec.ofNat 64 pos + 1#64 = BitVec.ofNat 64 (pos + 1) := by
  have hp : BitVec.ofNat 64 pos < 256#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; simp; omega
  refine ⟨?_, ?_, by rw [BitVec.ofNat_add]⟩ <;>
    · generalize BitVec.ofNat 64 pos = a at hp
      bv_decide

/-- Equality of small counters. -/
theorem ofNat_eq_ofNat_iff {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    BitVec.ofNat 64 a = BitVec.ofNat 64 b ↔ a = b := by
  rw [← BitVec.toNat_inj, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha,
    Nat.mod_eq_of_lt hb]

theorem loop_ge {t : Vector ℤ 256} (h : 256 ≤ pos) : Naf.loop W x f pos c t = t := by
  cases f <;> simp [Naf.loop, show ¬pos < 256 by omega]

theorem loop_even {t : Vector ℤ 256} (hp : pos < 256) (he : Naf.window W x pos c % 2 = 0) :
    Naf.loop W x (f + 1) pos c t = Naf.loop W x f (pos + 1) c t := by simp [Naf.loop, hp, he]

theorem loop_odd_lo {t : Vector ℤ 256} (hp : pos < 256) (ho : Naf.window W x pos c % 2 ≠ 0)
    (hl : Naf.window W x pos c < 2 ^ W / 2) :
    Naf.loop W x (f + 1) pos c t =
      Naf.loop W x f (pos + W) 0 (t.set pos (Naf.window W x pos c) hp) := by
  simp [Naf.loop, hp, ho, hl]

theorem loop_odd_hi {t : Vector ℤ 256} (hp : pos < 256) (ho : Naf.window W x pos c % 2 ≠ 0)
    (hl : ¬Naf.window W x pos c < 2 ^ W / 2) :
    Naf.loop W x (f + 1) pos c t =
      Naf.loop W x f (pos + W) 1 (t.set pos (Naf.window W x pos c - 2 ^ W) hp) := by
  simp [Naf.loop, hp, ho, hl]

/-- `window >= width / 2`. -/
theorem ule_half (hW : W < 64) (v : BitVec 64) :
    BitVec.ule (((1#64 : BitVec 64) <<< (W : ℕ)) >>> (1 : ℕ)) v = decide (2 ^ W / 2 ≤ v.toNat) := by
  have h1 : (1#64 <<< W).toNat = 2 ^ W := by
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, show (1#64).toNat = 1 from rfl, Nat.one_mul,
      Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by decide) hW)]
  simp only [BitVec.ule, BitVec.toNat_ushiftRight, h1, Nat.shiftRight_eq_div_pow, Nat.pow_one]

/-- `window as i8`. -/
theorem setWidth8_eq_ofInt (v : BitVec 64) : v.setWidth 8 = BitVec.ofInt 8 (v.toNat : ℤ) := by
  rw [BitVec.ofInt_natCast]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]

/-- `(window as i8).wrapping_sub(width as i8)`. -/
theorem setWidth8_sub_eq_ofInt (v : BitVec 64) (hW : W ≤ 8) :
    v.setWidth 8 - 1#8 <<< W = BitVec.ofInt 8 ((v.toNat : ℤ) - 2 ^ W) := by
  have hpow : ∀ k < 9, (1#8 <<< k) = BitVec.ofInt 8 (2 ^ k) := by decide
  rw [hpow W (by omega), Int.sub_eq_add_neg, BitVec.ofInt_add, BitVec.ofInt_neg, ←
    BitVec.sub_eq_add_neg, ← setWidth8_eq_ofInt]

/-- Unsigned comparison of small counters. -/
theorem ult_ofNat64 {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 b) = decide (a < b) := by
  simp only [BitVec.ult, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb]

/-- `pos + w`, `nuw`. -/
theorem add_w_flags {w : BitVec 64} (hW : w.toNat = W) (h8 : W ≤ 8) (h : pos < 256) :
    (BitVec.ofNat 64 pos).uaddOverflow w = false ∧
      BitVec.ofNat 64 pos + w = BitVec.ofNat 64 (pos + W) := by
  have hw : w = BitVec.ofNat 64 W := by rw [← hW, BitVec.ofNat_toNat, BitVec.setWidth_eq]
  subst hw
  refine ⟨?_, by rw [BitVec.ofNat_add]⟩
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  simp
  omega

/-- `pos & 63` on a counter: `pos % 64`. -/
theorem ofNat_and_63 : BitVec.ofNat 64 n &&& 63#64 = BitVec.ofNat 64 (n % 64) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (63#64).toNat = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `64 - w` as a counter. -/
theorem sub_w {w : BitVec 64} (hW : w.toNat = W) (h8 : W ≤ 8) :
    64#64 - w = BitVec.ofNat 64 (64 - W) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_sub, hW, BitVec.toNat_ofNat]
  omega

/-- `0 - pos`, `nsw`, for a counter. -/
theorem neg_flags (h : n < 256) : (0#64).ssubOverflow (BitVec.ofNat 64 n) = false := by
  have hp : BitVec.ofNat 64 n < 256#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; simp; omega
  generalize BitVec.ofNat 64 n = a at hp
  bv_decide

/-- `(0 - pos) & 63` off a word boundary, as the shift amount: `64 - pos % 64`. -/
theorem neg_and_63 (h : n % 64 ≠ 0) (hn : n < 18446744073709551616) :
    (18446744073709551616 - n % 18446744073709551616) % 18446744073709551616 &&& 63 =
      64 - n % 64 := by
  rw [show (63 : ℕ) = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod, Nat.mod_eq_of_lt hn]
  omega

/-- `^bb3` at `pos < 256` with fuel `f`: the digits as `Naf.loop` leaves them, then `^bb2`. -/
theorem Scalar_non_adjacent_form.main_loop (naf scalar xu : Pointer) (w : BitVec 64) (W : Nat)
    (hW : w.toNat = W) (h2 : 2 ≤ W) (h8 : W ≤ 8) (x : BitVec 256) (Sb : GlobalState)
    (hfn : Room Sb.mem naf (8 * 256)) (hno : ¬naf.offset.uaddOverflow 256#64)
    (hfx : Room Sb.mem xu 320) (hxo : xu.offset = 0) (hne : naf.id ≠ xu.id) {β : Type}
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ f pos c (t : Vector ℤ 256) (E : ⟪Scalar_non_adjacent_form.Γ⟫),
      E.args = (Scalar_non_adjacent_form.args (.value naf) (.value scalar) (.value w)).get →
        pos < 256 →
        256 ≤ pos + f →
        c ≤ 1 →
        (∀ E' : ⟪Scalar_non_adjacent_form.Γ⟫,
          E'.args = (Scalar_non_adjacent_form.args (.value naf) (.value scalar) (.value w)).get →
            (Scalar_non_adjacent_form.runFrom (consts xu W w E') ^bb2
                  (st naf xu (Naf.loop W x.toNat f pos c t) (x.setWidth 320) Sb) >>=
                g) =
              K) →
        (Scalar_non_adjacent_form.runFrom (hdr3 xu W w E pos c) ^bb3
              (st naf xu t (x.setWidth 320) Sb) >>=
            g) =
          K := by
  intro f
  induction f with
  | zero =>
    intro pos c t E _ hpos hf
    omega
  | succ f ih =>
    intro pos c t E hArgs hpos hf hc hK
    have hW64 : W < 64 := by omega
    have hwin : Naf.window W x.toNat pos c < 2 ^ W + 1 := by
      unfold Naf.window
      have := Nat.mod_lt (x.toNat / 2 ^ pos) (Nat.two_pow_pos W)
      omega
    -- `^bb5`: `window = carry + (bit_buf & window_mask)`, then the digit or the next bit
    have hK5 :
      ∀ (E' : ⟪Scalar_non_adjacent_form.Γ⟫) (bb : BitVec 64),
        E'.args = (Scalar_non_adjacent_form.args (.value naf) (.value scalar) (.value w)).get →
          (bb &&& mask W).toNat = x.toNat / 2 ^ pos % 2 ^ W →
          (Scalar_non_adjacent_form.runFrom (hdr5 xu W w E' pos c bb) ^bb5
                (st naf xu t (x.setWidth 320) Sb) >>=
              g) =
            K := by
      intro E' bb hArgs' hbb
      obtain ⟨o1, o2, ow⟩ := window_add h8 hc hbb (Nat.mod_lt _ (Nat.two_pow_pos W))
      block_init
      step_pure
      step_pure [o1, o2] with window
      replace ow : window.toNat = Naf.window W x.toNat pos c := by
        rw [hwindow]; exact ow
      step_pure
      step_pure
      finish_block
      · -- `pos += 1; continue;`
        rw [and_one_eq_zero_iff, ow] at hbr
        rw [loop_even hpos hbr] at hK
        obtain ⟨s1, s2, s3⟩ := succ_flags hpos
        block_init
        step_pure [s1, s2, s3]
        step_pure
        finish_block
        · rw [ofNat_eq_ofNat_iff (by omega) (by omega)] at hbr
          rw [loop_ge (show 256 ≤ pos + 1 by omega)] at hK
          step_loop using hK
        · rw [ofNat_eq_ofNat_iff (by omega) (by omega)] at hbr
          step_loop using ih (pos + 1) c t _ _ (by omega) (by omega) hc hK
      · -- `naf[pos] = …; pos += w;`
        rw [and_one_eq_zero_iff, ow] at hbr
        have hpm : pos % 18446744073709551616 < 18446744073709551616 := Nat.mod_lt _ (by decide)
        obtain ⟨a1, a2⟩ := add_w_flags (pos := pos) hW h8 hpos
        by_cases hl : Naf.window W x.toNat pos c < 2 ^ W / 2
        · rw [loop_odd_lo hpos hbr hl] at hK
          have hl' : ¬2 ^ W / 2 ≤ Naf.window W x.toNat pos c := by omega
          block_init
          iterate 6 step_pure [ule_half hW64, ow, hl', hpm]
          step_store
          rw [storeAt_digit hne hno hpos (d := (Naf.window W x.toNat pos c : ℤ))
              (by rw [setWidth8_eq_ofInt, ow])] at hS
          step_pure [a1, a2]
          step_pure [ult_ofNat64 (show pos + W < 2 ^ 64 by omega) (show 256 < 2 ^ 64 by omega)]
          finish_block
          · simp only [decide_eq_true_eq] at hbr
            block_init
            finish_block
            step_loop using ih (pos + W) 0 _ _ _ hbr (by omega) (by omega) hK
          · simp only [decide_eq_true_eq] at hbr
            rw [loop_ge (by omega)] at hK
            step_loop using hK
        · rw [loop_odd_hi hpos hbr hl] at hK
          have hl' : 2 ^ W / 2 ≤ Naf.window W x.toNat pos c := by omega
          block_init
          iterate 6 step_pure [ule_half hW64, ow, hl', hpm]
          step_store
          rw [storeAt_digit hne hno hpos (d := (Naf.window W x.toNat pos c : ℤ) - 2 ^ W)
              (by rw [setWidth8_sub_eq_ofInt _ h8, ow])] at hS
          step_pure [a1, a2]
          step_pure [ult_ofNat64 (show pos + W < 2 ^ 64 by omega) (show 256 < 2 ^ 64 by omega)]
          finish_block
          · simp only [decide_eq_true_eq] at hbr
            block_init
            finish_block
            step_loop using ih (pos + W) 1 _ _ _ hbr (by omega) (by omega) hK
          · simp only [decide_eq_true_eq] at hbr
            rw [loop_ge (by omega)] at hK
            step_loop using hK
    -- `u64_idx = pos / 64; bit_idx = pos % 64;`
    obtain ⟨k, b, rfl, hb⟩ : ∃ k b, pos = 64 * k + b ∧ b < 64 :=
      ⟨pos / 64, pos % 64, by omega, by omega⟩
    have hk : k < 4 := by omega
    have hpk : (64 * k + b) >>> 6 = k := by
      rw [Nat.shiftRight_eq_div_pow]; omega
    block_init
    step_pure
    step_pure [ofNat_and_63, show (64 * k + b) % 64 = b by omega]
    step_pure [sub_w hW h8, ult_ofNat64 (show b < 2 ^ 64 by omega) (show 64 - W < 2 ^ 64 by omega)]
    step_pure [Nat.mod_eq_of_lt (show 64 * k + b < 18446744073709551616 by omega), hpk,
      show k * 8 = 8 * k by omega, show 8 * k < 18446744073709551616 by omega]
    step_load
    step_pure [Nat.mod_eq_of_lt (show b < 18446744073709551616 by omega), show ¬64 ≤ b by omega]
    finish_block
    · -- `bit_idx < 64 - w`: `x_u64[u64_idx] >> bit_idx`
      simp only [decide_eq_true_eq] at hbr
      step_loop using hK5 _ _ _ (window_lo x k (by omega) hW64)
    · -- `(x_u64[u64_idx] >> bit_idx) | (x_u64[1 + u64_idx] << (64 - bit_idx))`
      simp only [decide_eq_true_eq] at hbr
      have hb0 : 0 < b := by omega
      block_init
      step_pure [Pointer.add_add, ← BitVec.ofNat_add, show 8 * k + 8 = 8 * (k + 1) by omega]
      step_load
      step_pure [neg_flags hpos]
      step_pure
      step_pure [neg_and_63 (show (64 * k + b) % 64 ≠ 0 by omega) (by omega),
        show (64 * k + b) % 64 = b by omega, show ¬64 ≤ 64 - b by omega]
      step_pure
      finish_block
      step_loop using hK5 _ _ _ (window_hi x hk hb0 hb hW64)

/-- `Scalar::non_adjacent_form(self, w)` stores `spec` of the scalar's 32 bytes at `naf`, for
`2 ≤ w ≤ 8`; its `x_u64` is a frame slot. -/
public theorem Scalar_non_adjacent_form.call_eq (naf scalar : Pointer) (w : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hnaf : Room s.mem naf (8 * 256))
    (hno : ¬naf.offset.uaddOverflow 256#64) (hscalar : Fits s.mem scalar (8 * 32))
    (hso : ¬scalar.offset.uaddOverflow 32#64) (hsep : naf.id ≠ scalar.id)
    (hw : 2 ≤ w.toNat ∧ w.toNat ≤ 8) :
    Scalar_non_adjacent_form.call
        (Scalar_non_adjacent_form.args (.value naf) (.value scalar) (.value w)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem :=
              s.mem.storeAt naf
                (Scalar_non_adjacent_form.spec (s.mem.readAt scalar 256) w.toNat) }) := by
  func_init
  obtain ⟨x, hx⟩ : ∃ x, S₀.mem.readAt scalar 256 = x := ⟨_, rfl⟩
  have hx0 : S.mem.readAt scalar 128 = x.setWidth 128 := by
    rw [hS]; exact MemoryState.readAt_of_readAt_le (by decide) hx
  have hx1 : S.mem.readAt (scalar.add 16#64) 128 = x.extractLsb' 128 128 := by
    rw [hS]
    exact
      MemoryState.readAt_add_of_readAt hscalar₀.inBounds
        (BitVec.not_uaddOverflow_of_le hso (by decide)) (by decide) hx
  rw [hx]
  obtain ⟨W, hW⟩ : ∃ W, w.toNat = W := ⟨_, rfl⟩
  rw [hW] at hw ⊢
  obtain ⟨fl1, fl2, fl3, fl4⟩ := width_flags hw.1 hw.2
  obtain ⟨fs1, fs2⟩ := sub_w_flags (w := w) (by omega)
  block_init
  iterate 10 step_pure
  step_alloca with xu
  -- `let mut naf = [0i8; 256];`
  step_memset
  step_pure
  -- `let mut x_u64 = [0u64; 5]; read_le_u64_into(&self.bytes, &mut x_u64[0..4]);`
  step_memset
  step_load [hx0] consuming hx0
  step_store
  step_pure
  step_pure
  step_load [hx1] consuming hx1
  step_store
  -- `width`, `window_mask`, `64 - w`, `width / 2`
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2]
  step_pure [fl3]
  step_pure [fs1, fs2]
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2, fl4]
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2]
  finish_block
  rw [storeAt_lifetimeStart hnaf_ne_xu, packLanes_ofFn_extractVecElem,
    packLanes_ofFn_extractVecElem, storeAt_storeAt_low (by decide),
    storeAt_storeAt_add
      (BitVec.not_uaddOverflow_of_le (by simp [BitVec.uaddOverflow, hxu_off])
        (show (16#64).toNat ≤ (16#64).toNat from le_rfl))
      (by decide),
    show (16#64 : BitVec 64).toNat * 8 = 16 * 8 from rfl, init_words, ← bytes_zero] at hS
  clear_reads
  block_init
  finish_block
  step_loop using
    Scalar_non_adjacent_form.main_loop naf scalar xu w W hW hw.1 hw.2 x
      { alloc := (S₀.alloca 40 true).alloc, mem := (S₀.alloca 40 true).mem.lifetimeStart xu } _ hno
      _ hxu_off hnaf_ne_xu _ _ 256 0 0 (Vector.replicate 256 0) _ _ (by omega) (by omega) (by omega)
  -- `naf`
  block_init
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Agave.Serial

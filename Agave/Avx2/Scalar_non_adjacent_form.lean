module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Naf
public import Agave.Avx2.Mlir.Scalar_non_adjacent_form
import Agave.Serial.Scalar_non_adjacent_form
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open Serial (width_flags sub_w_flags st small_add_flags window_add and_one_eq_zero_iff succ_flags
  ofNat_eq_ofNat_iff loop_ge loop_even loop_odd_lo loop_odd_hi ule_half setWidth8_eq_ofInt
  setWidth8_sub_eq_ofInt ult_ofNat64 add_w_flags ofNat_and_63 sub_w neg_flags neg_and_63)

/-! ## Proof -/

section Proof

open _root_.MLIR.Agave.Scalar_non_adjacent_form

/-- A four-lane vector load's lanes, packed again: the loaded bits. -/
theorem packLanes_ofFn_extractVecElem4 (v : BitVec 256) :
    BitVec.packLanes (Vector.ofFn fun i => Ty.extractVecElem 4 64 i v) = v := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have h :=
    BitVec.extractLsb'_packLanes_of_lt (Vector.ofFn fun i => Ty.extractVecElem 4 64 i v) (s := m)
      (w := 1) (by omega) (by omega)
  have h' := congrArg (·.getLsbD 0) h
  simp only [BitVec.getLsbD_extractLsb', Vector.getElem_ofFn, Ty.extractVecElem_eq] at h'
  simp only [Nat.zero_lt_one, decide_true, Bool.true_and, Nat.add_zero] at h'
  simp only [Ty.extractVecElem_eq]
  rw [h']
  have := Nat.div_add_mod m 64
  simp only [show m / 64 * 64 + m % 64 = m by omega, show m % 64 < 64 from Nat.mod_lt _ (by decide),
    decide_true, Bool.true_and]

/-- `x_u64` as the one 32-byte copy and the zeroed fifth word leave it: the scalar's bits. -/
theorem init_words4 (x : BitVec 256) : Memory.spliceBits 0#320 0 x = x.setWidth 320 := by
  simp only [spliceBits_eq]
  bv_decide

/-! ### `width`, `window_mask`, `64 - w`, `width / 2` -/

/-- The registers live in the loop: `bb0`'s constants and the ones `w` gives. -/
abbrev consts (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫) :
    ⟪Scalar_non_adjacent_form.Γ⟫ :=
  E[%1628 := .value 0#8, %1629 := .value 256#64, %1631 := .value 1#64, %1634 := .value 0#64,
    %1635 := .value 6#64, %1636 := .value 63#64, %1637 := .value xu, %1640 := .value (mask W),
    %1641 := .value (64#64 - w), %1642 := .value (1#64 <<< W >>> 1), %1643 := .value (1#8 <<< W)]

/-- The registers at `^bb3`, the window at `pos` with `carry`. -/
abbrev hdr3 (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫)
    (pos c : Nat) : ⟪Scalar_non_adjacent_form.Γ⟫ :=
  (consts xu W w E)[%1645 := .value (BitVec.ofNat 64 c), %1646 := .value (BitVec.ofNat 64 pos)]

/-- The registers at `^bb5`: `bit_buf` read. -/
abbrev hdr5 (xu : Pointer) (W : Nat) (w : BitVec 64) (E : ⟪Scalar_non_adjacent_form.Γ⟫)
    (pos c : Nat) (bb : BitVec 64) : ⟪Scalar_non_adjacent_form.Γ⟫ :=
  (consts xu W w E)[%1645 := .value (BitVec.ofNat 64 c), %1646 := .value (BitVec.ofNat 64 pos),
    %1659 := .value bb]

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
          run_from using hK
        · rw [ofNat_eq_ofNat_iff (by omega) (by omega)] at hbr
          run_from using ih (pos + 1) c t _ _ (by omega) (by omega) hc hK
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
            run_from using ih (pos + W) 0 _ _ _ hbr (by omega) (by omega) hK
          · simp only [decide_eq_true_eq] at hbr
            rw [loop_ge (by omega)] at hK
            run_from using hK
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
            run_from using ih (pos + W) 1 _ _ _ hbr (by omega) (by omega) hK
          · simp only [decide_eq_true_eq] at hbr
            rw [loop_ge (by omega)] at hK
            run_from using hK
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
      run_from using hK5 _ _ _ (window_lo x k (by omega) hW64)
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
      run_from using hK5 _ _ _ (window_hi x hk hb0 hb hW64)

/-- `Scalar::non_adjacent_form(self, w)` stores `spec` of the scalar's 32 bytes at `naf`, for
`2 ≤ w ≤ 8`; its `x_u64` is a frame slot. -/
public theorem Scalar_non_adjacent_form.call_eq (naf scalar : Pointer) (w : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hnaf : Room s.mem naf (8 * 256))
    (hno : ¬naf.offset.uaddOverflow 256#64) (hscalar : Fits s.mem scalar (8 * 32))
    (hsep : naf.id ≠ scalar.id) (hw : 2 ≤ w.toNat ∧ w.toNat ≤ 8) :
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
  have hx' : S.mem.readAt scalar 256 = x := by
    rw [hS]; exact hx
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
  step_load [hx'] consuming hx'
  step_store
  -- `width`, `window_mask`, `64 - w`, `width / 2`
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2]
  step_pure [fl3]
  step_pure [fs1, fs2]
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2, fl4]
  step_pure [hW, show ¬64 ≤ W by omega, fl1, fl2]
  finish_block
  rw [storeAt_lifetimeStart hnaf_ne_xu, packLanes_ofFn_extractVecElem4,
    MemoryState.storeAt_storeAt_low (by decide), init_words4, ← bytes_zero] at hS
  clear_reads
  block_init
  finish_block
  run_from using
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

end MLIR.Agave.Avx2

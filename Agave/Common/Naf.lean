module

public import MLIR.Semantics.Effectful.Memory.Operations
public import MLIR.Ty
public import Firedancer.Common.Memory
public import Firedancer.Common.Point
public import Agave.Math.Naf
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `Scalar::non_adjacent_form`'s bv-level spec, shared by the serial and AVX2 trees: the bytes of
`Naf.naf w x`; the memory and window lemmas its proofs step with. -/

namespace MLIR.Agave

/-! ## Specification -/

@[expose] public section

/-- 256 `i8` digits' bytes, `naf[0]` lowest. -/
abbrev Scalar_non_adjacent_form.bytes (t : Vector ℤ 256) : BitVec (8 * 256) :=
  BitVec.packLanes (t.map (BitVec.ofInt 8))

/-- `Scalar::non_adjacent_form(self, w)`: the bytes of `naf w x`, `x` the scalar's 32 bytes as a
number. -/
def Scalar_non_adjacent_form.spec (x : BitVec 256) (w : ℕ) : BitVec (8 * 256) :=
  Scalar_non_adjacent_form.bytes (Naf.naf w x.toNat)

end

namespace Scalar_non_adjacent_form

/-! ## Memory -/

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
public theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- A store at a stored value's start: one store, the inner value spliced. -/
public theorem storeAt_storeAt_low {m : MemoryState} {p : Pointer} {u : BitVec wu} (hw : wy ≤ wu)
    (y : BitVec wy) : (m.storeAt p u).storeAt p y = m.storeAt p (Memory.spliceBits u 0 y) := by
  have h :=
    storeAt_storeAt_add (m := m) (p := p) (u := u) (off := 0#64)
      (by
        simp [BitVec.uaddOverflow]; exact p.offset.isLt)
      (by simpa using hw) y
  rwa [Pointer.add_zero] at h

/-- `x_u64[k]`'s byte offset `8 k`, which does not wrap. -/
theorem word_offset {v : Pointer} (hv : v.offset = 0) (hk : k < 5) :
    (BitVec.ofNat 64 (8 * k)).toNat = 8 * k ∧ ¬v.offset.uaddOverflow (BitVec.ofNat 64 (8 * k)) := by
  have h8 : (BitVec.ofNat 64 (8 * k)).toNat = 8 * k := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨h8, ?_⟩
  simp only [BitVec.uaddOverflow, hv, h8]
  simp
  omega

/-- `x_u64[k]`, read from a stored `x_u64`. -/
@[mlir_read]
public theorem readAt_word {m : MemoryState} {v : Pointer} {X : BitVec 320} (hf : InBounds m v 320)
    (hv : v.offset = 0) (hk : k < 5) :
    (m.storeAt v X).readAt (v.add (BitVec.ofNat 64 (8 * k))) 64 = X.extractLsb' (64 * k) 64 := by
  obtain ⟨h8, hov⟩ := word_offset hv hk
  rw [MemoryState.readAt_storeAt_add hf hov (by omega), h8, show 8 * k * 8 = 64 * k by omega]

/-- Splicing lane `j` into packed lanes sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec we) n} (hj : j < n) (y : BitVec we) :
    Memory.spliceBits (BitVec.packLanes u) (we * j) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hwe : 0 < we := by
    rcases Nat.eq_zero_or_pos we with h | h
    · subst h; simp at hm
    · exact h
  have hl :
    ∀ (v : Vector (BitVec we) n),
      (BitVec.packLanes v).getLsbD m =
        (v[m / we]'(by
                rw [Nat.div_lt_iff_lt_mul hwe]; rw [Nat.mul_comm]; exact hm)).getLsbD
          (m % we) :=
    fun v => by
    have h :=
      BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1)
        (by
          rw [Nat.div_lt_iff_lt_mul hwe]; rw [Nat.mul_comm]; exact hm)
        (by
          have := Nat.mod_lt m hwe; omega)
    simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h
  rw [Memory.getLsbD_spliceBits, hl, hl, Vector.getElem_set]
  by_cases h : m / we = j
  · subst h
    have hc : we * (m / we) ≤ m ∧ m < we * (m / we) + we ∧ m < we * n := by
      have := Nat.div_add_mod m we
      have := Nat.mod_lt m hwe
      exact ⟨by omega, by omega, hm⟩
    simp only [hc, and_self, ite_true]
    congr 1
    have := Nat.div_add_mod m we
    omega
  · have hc : ¬(we * j ≤ m ∧ m < we * j + we ∧ m < we * n) := by
      intro ⟨h1, h2, _⟩
      exact
        h
          (Nat.div_eq_of_lt_le
            (by
              rw [Nat.mul_comm]; exact h1)
            (by
              rw [Nat.succ_mul, Nat.mul_comm]; exact h2))
    simp only [hc, ite_false, Ne.symm h]

/-- A store of `naf[j]` into the stored digits under a stored `x_u64`: digit `j` set. -/
public theorem storeAt_digit {m : MemoryState} {naf v : Pointer} {t : Vector ℤ 256} {X : BitVec 320}
    (hne : naf.id ≠ v.id) (hno : ¬naf.offset.uaddOverflow 256#64) (hj : j < 256) {y : BitVec 8}
    {d : ℤ} (hy : y = BitVec.ofInt 8 d) :
    ((m.storeAt naf (bytes t)).storeAt v X).storeAt (naf.add (BitVec.ofNat 64 j)) y =
      (m.storeAt naf (bytes (t.set j d))).storeAt v X := by
  have hj8 : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬naf.offset.uaddOverflow (BitVec.ofNat 64 j) := by
    refine BitVec.not_uaddOverflow_of_le hno ?_
    rw [hj8]
    simp
    omega
  rw [MemoryState.storeAt_comm (.inl (by simpa [Range.of] using Ne.symm hne)),
    storeAt_storeAt_add hov (by omega), hj8, show j * 8 = 8 * j by omega, hy,
    spliceBits_packLanes hj]
  simp only [bytes, Vector.map_set]

/-- A store and a lifetime marker of different blocks commute. -/
public theorem storeAt_lifetimeStart {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).lifetimeStart q = (m.lifetimeStart q).storeAt p x := by
  simp only [MemoryState.storeAt, MemoryState.storeDef, MemoryState.lifetimeStart,
    MemoryState.setLifetime]
  exact MemoryState.modifyBlock_comm h

/-- A vector load's lanes, packed again: the loaded bits. -/
public theorem packLanes_ofFn_extractVecElem (v : BitVec 128) :
    BitVec.packLanes (Vector.ofFn fun i => Ty.extractVecElem 2 64 i v) = v := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have h :=
    BitVec.extractLsb'_packLanes_of_lt (Vector.ofFn fun i => Ty.extractVecElem 2 64 i v) (s := m)
      (w := 1) (by omega) (by omega)
  have h' := congrArg (·.getLsbD 0) h
  simp only [BitVec.getLsbD_extractLsb', Vector.getElem_ofFn, Ty.extractVecElem_eq] at h'
  simp only [Nat.zero_lt_one, decide_true, Bool.true_and, Nat.add_zero] at h'
  simp only [Ty.extractVecElem_eq]
  rw [h']
  have := Nat.div_add_mod m 64
  simp only [show m / 64 * 64 + m % 64 = m by omega, show m % 64 < 64 from Nat.mod_lt _ (by decide),
    decide_true, Bool.true_and]

/-- `spliceBits` as masks and shifts, for `bv_decide`. -/
public theorem spliceBits_eq {n w : Nat} (b : BitVec n) (off : Nat) (x : BitVec w) :
    Memory.spliceBits b off x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-- Zero digits' bytes are zero. -/
public theorem bytes_zero : bytes (Vector.replicate 256 0) = 0#2048 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h :=
    BitVec.extractLsb'_packLanes_of_lt ((Vector.replicate 256 (0 : ℤ)).map (BitVec.ofInt 8)) (s :=
      i) (w := 1) (by omega) (by omega)
  have h' := congrArg (·.getLsbD 0) h
  simp only [BitVec.getLsbD_extractLsb', Vector.getElem_map, Vector.getElem_replicate] at h'
  simp only [bytes, BitVec.getLsbD_zero]
  simpa using h'

/-- `x_u64` as `read_le_u64_into` and the zeroed fifth word leave it: the scalar's bits. -/
public theorem init_words (x : BitVec 256) :
    Memory.spliceBits (Memory.spliceBits 0#320 0 (x.setWidth 128)) (16 * 8)
        (x.extractLsb' 128 128) =
      x.setWidth 320 := by
  simp only [spliceBits_eq]
  bv_decide

/-! ## The window -/

/-- `width - 1`, as the code computes it: `(1 << w) + -1`. -/
public abbrev mask (W : Nat) : BitVec 64 :=
  1#64 <<< W + 18446744073709551615#64

public theorem toNat_mask (hW : W < 64) : (mask W).toNat = 2 ^ W - 1 := by
  have h1 : (1#64 <<< W).toNat = 2 ^ W := by
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, show (1#64).toNat = 1 from rfl, Nat.one_mul,
      Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by decide) hW)]
  have h2 : 1 ≤ 2 ^ W := Nat.one_le_two_pow
  have h3 : 2 ^ W < 2 ^ 64 := Nat.pow_lt_pow_right (by decide) hW
  rw [mask, BitVec.toNat_add, h1, show (18446744073709551615#64).toNat = 2 ^ 64 - 1 from rfl]
  omega

/-- A word's bits from `b` on, masked to `W` bits, when they stay inside the word. -/
public theorem window_lo (x : BitVec 256) (k : Nat) (hb : b + W ≤ 64) (hW : W < 64) :
    (((x.setWidth 320).extractLsb' (64 * k) 64 >>> b) &&& mask W).toNat =
      x.toNat / 2 ^ (64 * k + b) % 2 ^ W := by
  rw [BitVec.toNat_and, toNat_mask hW, Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow, BitVec.extractLsb'_toNat, BitVec.toNat_setWidth_of_le (by decide),
    Nat.shiftRight_eq_div_pow,
    show (2 : ℕ) ^ 64 = 2 ^ b * 2 ^ (64 - b) by
      rw [← Nat.pow_add]; congr 1; omega,
    Nat.mod_mul_right_div_self, Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega)),
    Nat.div_div_eq_div_mul, ← Nat.pow_add]

/-- `x_u64[k] >> b | x_u64[k+1] << (64 - b)` for `b ≠ 0`: the 64 bits from `64 k + b`. -/
theorem window_spill (n : BitVec 320) (hk : k < 4) (hb0 : 0 < b) (hb : b < 64) :
    n.extractLsb' (64 * (k + 1)) 64 <<< (64 - b) ||| n.extractLsb' (64 * k) 64 >>> b =
      (n >>> (64 * k + b)).setWidth 64 := by
  rw [show
      n.extractLsb' (64 * (k + 1)) 64 <<< (64 - b) =
        n.extractLsb' (64 * (k + 1)) 64 <<< BitVec.ofNat 64 (64 - b)
      by rw [BitVec.shiftLeft_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)],
    show n.extractLsb' (64 * k) 64 >>> b = n.extractLsb' (64 * k) 64 >>> BitVec.ofNat 64 b by
      rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)],
    show n >>> (64 * k + b) = n >>> BitVec.ofNat 64 (64 * k + b) by
      rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)],
    BitVec.ofNat_add,
    show BitVec.ofNat 64 (64 - b) = 64#64 - BitVec.ofNat 64 b by
      apply BitVec.eq_of_toNat_eq; simp; omega]
  have hc0 : 0#64 < BitVec.ofNat 64 b := by
    rw [BitVec.lt_def]; simp; omega
  have hc64 : BitVec.ofNat 64 b < 64#64 := by
    rw [BitVec.lt_def]; simp; omega
  generalize BitVec.ofNat 64 b = c at hc0 hc64 ⊢
  rcases (show k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 by omega) with rfl | rfl | rfl | rfl <;> bv_decide

/-- The window spilling into the next word, masked to `W` bits. -/
public theorem window_hi (x : BitVec 256) (hk : k < 4) (hb0 : 0 < b) (hb : b < 64) (hW : W < 64) :
    (((x.setWidth 320).extractLsb' (64 * (k + 1)) 64 <<< (64 - b) |||
            (x.setWidth 320).extractLsb' (64 * k) 64 >>> b) &&&
          mask W).toNat =
      x.toNat / 2 ^ (64 * k + b) % 2 ^ W := by
  rw [window_spill _ hk hb0 hb, BitVec.toNat_and, toNat_mask hW, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
    BitVec.toNat_setWidth_of_le (by decide), Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega))]

/-! ## Meaning -/

/-- Byte `i` of the spec is digit `i`. -/
public theorem lane_spec (x : BitVec 256) (w : ℕ) (i : ℕ) (hi : i < 256) :
    (spec x w).extractLsb' (i * 8) 8 = BitVec.ofInt 8 (Naf.naf w x.toNat)[i] := by
  rw [spec, bytes, BitVec.extractLsb'_packLanes _ i hi, Vector.getElem_map]

/-- For `x < 2^255` and `2 ≤ w ≤ 8`, byte `i` of the spec, as an `i8`, is digit `i` of the width-`w`
NAF of `x`: zero or odd, below `2^(w-1)` in absolute value, the digits summing to `x`
(`Naf.val_naf`). -/
public theorem toInt_lane_spec {x : BitVec 256} {w : ℕ} (h2 : 2 ≤ w) (h8 : w ≤ 8)
    (hx : x.toNat < 2 ^ 255) (i : ℕ) (hi : i < 256) :
    ((spec x w).extractLsb' (i * 8) 8).toInt = (Naf.naf w x.toNat)[i] := by
  rw [lane_spec x w i hi, BitVec.toInt_ofInt]
  obtain ⟨h1, h2⟩ := (Naf.digit_naf h2 hx i hi).lt_128 h8
  exact Int.bmod_eq_of_le (by omega) (by omega)

end Scalar_non_adjacent_form

end MLIR.Agave

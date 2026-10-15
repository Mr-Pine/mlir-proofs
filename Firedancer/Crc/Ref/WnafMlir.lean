module

public import MLIR.Run.Tactic
public import Firedancer.Common.Counter
public import Firedancer.Common.Memory
public import Firedancer.Common.Point
public import Firedancer.Crc.Ref.Wnaf
public import Firedancer.Crc.Ref.Mlir.crc_adx_wnaf
import Std.Tactic.BVDecide

/-!
# `crc_adx_wnaf` refinement (MLIR lift ↔ spec)

The lifted `crc_adx_wnaf` writes `Wnaf.digits` of the scalar as `short`s and returns their count.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

/-- The `short`s `ys` stored at `p`, from index `i` on. -/
def storeShorts (m : MemoryState) (p : Pointer) : Nat → List (BitVec 16) → MemoryState
  | _, [] => m
  | i, y :: ys => storeShorts (m.storeAt (p.add (BitVec.ofNat 64 (2 * i))) y) p (i + 1) ys

/-- The window of the low limb `w0`, `w0 & mask`, less `2^(bits+1)` when its top bit is set: the
C's `di` for an odd `w0`. -/
abbrev win (B : Nat) (w0 : BitVec 64) : BitVec 64 :=
  (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64) -
    if (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64) >>> B = 0#64 then 0#64
    else 1#64 <<< (B + 1)

/-- The C's `di` from the scalar's low limb: `0` for an even scalar, else the window. -/
def dv (B : Nat) (w : BitVec 256) : BitVec 64 :=
  if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64 else win B (w.extractLsb' 0 64)

end

/-- The registers live through the loop: `bb0`'s constants, the slot `v` and its limb pointers, and
the ones `bits` gives. -/
abbrev consts (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) : ⟪crc_adx_wnaf.Γ⟫ :=
  E[%0 := .value 1#32, %1 := .value 1#64, %2 := .value 18446744073709551615#64, %3 := .value 0#64,
    %5 := .value 0#16, %6 := .value 3#64, %7 := .value 0#1, %8 := .value 63#64, %9 := .value v,
    %11 := .value (v.add 8#64), %14 := .value (v.add 16#64), %17 := .value (v.add 24#64),
    %22 := .value (1#64 <<< (B + 1)), %23 := .value (1#64 <<< (B + 1) + 18446744073709551615#64),
    %24 := .value (BitVec.ofNat 64 B)]

/-- `^bb1`, the loop header: the scalar's four limbs and the digit count `n`. -/
abbrev hdr1 (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) (w : BitVec 256) (n : Nat) :
    ⟪crc_adx_wnaf.Γ⟫ :=
  (consts v B E)[%29 := .value (w.extractLsb' 192 64), %30 := .value (w.extractLsb' 128 64),
    %31 := .value (w.extractLsb' 64 64), %32 := .value (BitVec.ofNat 32 n),
    %33 := .value (w.extractLsb' 0 64)]

/-- `^bb6`, the carry loop at limb `j + 1`. -/
abbrev hdr6 (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) (n : Nat) (w0 di : BitVec 64) (j : Nat) :
    ⟪crc_adx_wnaf.Γ⟫ :=
  (consts v B E)[%32 := .value (BitVec.ofNat 32 n), %33 := .value w0, %40 := .value di,
    %51 := .value (BitVec.ofNat 64 (j + 1))]

/-- `^bb7`, the digit taken: the low limb, the digit, the count. -/
abbrev hdr7 (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) (n : Nat) (w0 di : BitVec 64) :
    ⟪crc_adx_wnaf.Γ⟫ :=
  (consts v B E)[%32 := .value (BitVec.ofNat 32 n), %33 := .value w0, %40 := .value di]

/-- `^bb8`, the store and shift: the scalar less the digit, the digit as a `short`, the count. -/
abbrev hdr8 (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) (n : Nat) (w : BitVec 256)
    (y : BitVec 16) : ⟪crc_adx_wnaf.Γ⟫ :=
  (consts v B E)[%32 := .value (BitVec.ofNat 32 n), %64 := .value (w.extractLsb' 192 64),
    %65 := .value (w.extractLsb' 128 64), %66 := .value (w.extractLsb' 64 64),
    %67 := .value (w.extractLsb' 0 64), %68 := .value y]

/-- `^bb9`, the return of the count `r`. -/
abbrev hdr9 (v : Pointer) (B : Nat) (E : ⟪crc_adx_wnaf.Γ⟫) (r : BitVec 32) : ⟪crc_adx_wnaf.Γ⟫ :=
  (consts v B E)[%80 := .value r]

/-- The state through the loop: the digits `ys` stored at `d`, the upper limbs `U` at `v + 8`. -/
abbrev wst (A : AllocState) (M : MemoryState) (d v : Pointer) (ys : List (BitVec 16))
    (U : BitVec 192) : GlobalState :=
  { alloc := A, mem := (storeShorts M d 0 ys).storeAt (v.add 8#64) U }

section Proof

/-! ### `short`s and limbs in memory -/

theorem storeShorts_append (p : Pointer) :
    ∀ (xs : List (BitVec 16)) (m : MemoryState) (i : Nat) (y : BitVec 16),
      storeShorts m p i (xs ++ [y]) =
        (storeShorts m p i xs).storeAt (p.add (BitVec.ofNat 64 (2 * (i + xs.length)))) y := by
  intro xs
  induction xs with
  | nil => intro m i y; simp [storeShorts]
  | cons x xs ih =>
    intro m i y
    simp only [List.cons_append, storeShorts, ih, List.length_cons]
    congr 4
    omega

theorem Room.storeShorts {m : MemoryState} (h : Room m q w) :
    ∀ (ys : List (BitVec 16)) (i : Nat), Room (storeShorts m p i ys) q w := by
  intro ys
  induction ys generalizing m with
  | nil => intro i; exact h
  | cons y ys ih => intro i; exact ih h.storeAt (i + 1)

theorem Pointer.add_add' (v : Pointer) (a b : BitVec 64) : (v.add a).add b = v.add (a + b) := by
  simp only [Pointer.add, BitVec.add_assoc]

/-- `v + 8(j+1)` as `v + 8` plus `8j`, without wrapping (`v`'s offset `0`). -/
theorem ulimb_ptr {v : Pointer} (hv : v.offset = 0) (hj : j < 3) :
    v.add (BitVec.ofNat 64 (8 * (j + 1))) = (v.add 8#64).add (BitVec.ofNat 64 (8 * j)) ∧
      (BitVec.ofNat 64 (8 * j)).toNat = 8 * j ∧
      ¬(v.add 8#64).offset.uaddOverflow (BitVec.ofNat 64 (8 * j)) := by
  have h8j : (BitVec.ofNat 64 (8 * j)).toNat = 8 * j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨?_, h8j, ?_⟩
  · rw [Pointer.add_add']
    congr 1
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_ofNat, BitVec.toNat_add]
    omega
  · simp only [Pointer.add, hv, BitVec.uaddOverflow, h8j]
    simp
    omega

/-- Limb `j` of the upper limbs `U` stored at `v + 8`, read at `v + 8(j+1)`. -/
theorem readAt_ulimb {m : MemoryState} {v : Pointer} {U : BitVec 192}
    (hR : Room m (v.add 8#64) 192) (hv : v.offset = 0) (hj : j < 3) :
    (m.storeAt (v.add 8#64) U).readAt (v.add (BitVec.ofNat 64 (8 * (j + 1)))) 64 =
      U.extractLsb' (64 * j) 64 := by
  obtain ⟨he, h8j, hov⟩ := ulimb_ptr hv hj
  rw [he, MemoryState.readAt_storeAt_add hR hov (by rw [h8j]; omega), h8j,
    show 8 * j * 8 = 64 * j by omega]

/-- A store of limb `j` at `v + 8(j+1)` into the upper limbs `U` at `v + 8`: `U` spliced. -/
theorem storeAt_ulimb {m : MemoryState} {v : Pointer} {U : BitVec 192} (hv : v.offset = 0)
    (hj : j < 3) (y : BitVec 64) :
    (m.storeAt (v.add 8#64) U).storeAt (v.add (BitVec.ofNat 64 (8 * (j + 1)))) y =
      m.storeAt (v.add 8#64) (Memory.spliceBits U (64 * j) y) := by
  obtain ⟨he, h8j, hov⟩ := ulimb_ptr hv hj
  rw [he, MemoryState.storeAt_storeAt_add hov (by rw [h8j]; omega), h8j,
    show 8 * j * 8 = 64 * j by omega]

/-- Limb `j` of the stored upper limbs is known. -/
theorem fits_ulimb {m : MemoryState} {v : Pointer} {U : BitVec 192}
    (hR : Room m (v.add 8#64) 192) (hv : v.offset = 0) (hj : j < 3) :
    Fits (m.storeAt (v.add 8#64) U) (v.add (BitVec.ofNat 64 (8 * (j + 1)))) 64 := by
  obtain ⟨he, h8j, hov⟩ := ulimb_ptr hv hj
  rw [he]
  exact Fits.storeAt_add_self hR hov (by rw [h8j]; omega)

/-- `d[n] = y` under the upper limbs at `v + 8`: one more `short` stored at `d`. -/
theorem storeAt_short {m : MemoryState} {d v : Pointer} {U : BitVec 192} (hdv : d.id ≠ v.id)
    (ys : List (BitVec 16)) (y : BitVec 16) :
    ((storeShorts m d 0 ys).storeAt (v.add 8#64) U).storeAt (d.add (BitVec.ofNat 64 (2 * ys.length)))
        y = (storeShorts m d 0 (ys ++ [y])).storeAt (v.add 8#64) U := by
  rw [MemoryState.storeAt_comm (.inl (by simpa [Range.of] using Ne.symm hdv)), storeShorts_append,
    Nat.zero_add]

/-- Room for the three upper limbs, from room for the slot. -/
theorem room_ulimbs {m : MemoryState} {v : Pointer} (hR : Room m v 256) (hv : v.offset = 0) :
    Room m (v.add 8#64) 64 ∧ Room m (v.add 16#64) 64 ∧ Room m (v.add 24#64) 64 := by
  have h : ∀ k : Nat, k ≤ 24 → Room m (v.add (BitVec.ofNat 64 k)) 64 := by
    intro k hk
    have hov : ¬v.offset.uaddOverflow (BitVec.ofNat 64 k) := by
      simp only [BitVec.uaddOverflow, hv, BitVec.toNat_ofNat]
      simp
      omega
    exact Room.add (off := k) (by omega) hov (hR.mono (by omega))
  exact ⟨h 8 (by omega), h 16 (by omega), h 24 (by omega)⟩

/-- Erasing a frame commutes with the `short` stores. -/
theorem storeShorts_eraseFrom (p : Pointer) (n : Nat) :
    ∀ (ys : List (BitVec 16)) (m : MemoryState) (i : Nat),
      (storeShorts m p i ys).eraseFrom n = storeShorts (m.eraseFrom n) p i ys := by
  intro ys
  induction ys with
  | nil => intro m i; rfl
  | cons y ys ih => intro m i; simp only [storeShorts, ih, MemoryState.eraseFrom_storeAt]

/-- `bb0`'s three limb stores, as one store of the upper limbs at `v + 8`. -/
theorem init_limbs {m : MemoryState} {v : Pointer} (hv : v.offset = 0) (x : BitVec 256) :
    ((m.storeAt (v.add 8#64) (x.extractLsb' 64 64)).storeAt (v.add 16#64)
          (x.extractLsb' 128 64)).storeAt (v.add 24#64) (x.extractLsb' 192 64) =
      m.storeAt (v.add 8#64) (x.extractLsb' 64 192) := by
  have hov : ∀ k : Nat, k ≤ 16 → ¬(v.add 8#64).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    intro k hk
    simp only [Pointer.add, hv, BitVec.uaddOverflow, BitVec.toNat_ofNat]
    simp
    omega
  rw [show v.add 16#64 = (v.add 8#64).add (BitVec.ofNat 64 8) by rw [Pointer.add_add']; rfl,
    MemoryState.storeAt_storeAt_append (hov 8 (by omega)) rfl (by decide),
    show v.add 24#64 = (v.add 8#64).add (BitVec.ofNat 64 16) by rw [Pointer.add_add']; rfl,
    MemoryState.storeAt_storeAt_append (hov 16 (by omega)) rfl (by decide)]
  congr 1
  bv_decide

/-- `w[0] | w[1] | w[2] | w[3]` is zero exactly when the scalar is. -/
theorem limbs_or_eq_zero (x : BitVec 256) :
    (x.extractLsb' 64 64 ||| x.extractLsb' 128 64 ||| x.extractLsb' 192 64 |||
      x.extractLsb' 0 64) = 0#64 ↔ x = 0#256 := by
  constructor <;> intro h <;> bv_decide

/-- Room for upper limb `j` at `v + 8(j+1)`. -/
theorem room_ulimb {m : MemoryState} {v : Pointer} (hR : Room m (v.add 8#64) 192)
    (hv : v.offset = 0) (hj : j < 3) : Room m (v.add (BitVec.ofNat 64 (8 * (j + 1)))) 64 := by
  obtain ⟨he, h8j, hov⟩ := ulimb_ptr hv hj
  rw [he]
  exact Room.add (off := 8 * j) (by omega) hov (hR.mono (by omega))

/-- Room for the upper limbs at `v + 8`, from room for the slot. -/
theorem room_upper {m : MemoryState} {v : Pointer} (hR : Room m v 256) (hv : v.offset = 0) :
    Room m (v.add 8#64) 192 := by
  have hov : ¬v.offset.uaddOverflow (BitVec.ofNat 64 8) := by
    simp only [BitVec.uaddOverflow, hv, BitVec.toNat_ofNat]; simp
  exact Room.add (off := 8) (by omega) hov (hR.mono (by omega))

/-- A counter below `2^64` compares as a `Nat`. -/
theorem ult_ofNat64 {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 b) = decide (a < b) := by
  simp [BitVec.ult]
  omega

/-- The carry loop's `select`: go on exactly when both hold. -/
theorem carry_cond {a b : Bool} : (if a = true then BitVec.ofBool b else 0#1) = 1#1 ↔ a ∧ b := by
  cases a <;> cases b <;> decide

/-- The limb stores of `^bb8` at the literal pointers `v + 8`, `v + 16`, `v + 24`. -/
theorem storeAt_ulimbs {m : MemoryState} {v : Pointer} {U : BitVec 192} (hv : v.offset = 0)
    (y : BitVec 64) :
    (m.storeAt (v.add 8#64) U).storeAt (v.add 8#64) y =
        m.storeAt (v.add 8#64) (Memory.spliceBits U 0 y) ∧
      (m.storeAt (v.add 8#64) U).storeAt (v.add 16#64) y =
        m.storeAt (v.add 8#64) (Memory.spliceBits U 64 y) ∧
      (m.storeAt (v.add 8#64) U).storeAt (v.add 24#64) y =
        m.storeAt (v.add 8#64) (Memory.spliceBits U 128 y) :=
  ⟨by simpa using storeAt_ulimb (j := 0) hv (by omega) y,
    by simpa using storeAt_ulimb (j := 1) hv (by omega) y,
    by simpa using storeAt_ulimb (j := 2) hv (by omega) y⟩

/-- The limb loads of `^bb7` at the literal pointers. -/
theorem readAt_ulimbs {m : MemoryState} {v : Pointer} {U : BitVec 192}
    (hR : Room m (v.add 8#64) 192) (hv : v.offset = 0) :
    (m.storeAt (v.add 8#64) U).readAt (v.add 8#64) 64 = U.extractLsb' 0 64 ∧
      (m.storeAt (v.add 8#64) U).readAt (v.add 16#64) 64 = U.extractLsb' 64 64 ∧
      (m.storeAt (v.add 8#64) U).readAt (v.add 24#64) 64 = U.extractLsb' 128 64 :=
  ⟨by simpa using readAt_ulimb (j := 0) hR hv (by omega),
    by simpa using readAt_ulimb (j := 1) hR hv (by omega),
    by simpa using readAt_ulimb (j := 2) hR hv (by omega)⟩

/-- Those limbs are known. -/
theorem fits_ulimbs {m : MemoryState} {v : Pointer} {U : BitVec 192}
    (hR : Room m (v.add 8#64) 192) (hv : v.offset = 0) :
    Fits (m.storeAt (v.add 8#64) U) (v.add 8#64) 64 ∧
      Fits (m.storeAt (v.add 8#64) U) (v.add 16#64) 64 ∧
      Fits (m.storeAt (v.add 8#64) U) (v.add 24#64) 64 :=
  ⟨by simpa using fits_ulimb (j := 0) hR hv (by omega),
    by simpa using fits_ulimb (j := 1) hR hv (by omega),
    by simpa using fits_ulimb (j := 2) hR hv (by omega)⟩

/-- `spliceBits` as masks and shifts, for `bv_decide`. -/
theorem spliceBits_eq {n w : Nat} (b : BitVec n) (off : Nat) (x : BitVec w) :
    Memory.spliceBits b off x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-! ### Subtracting the digit from the four limbs -/

/-- The low limb less the digit. -/
theorem sub_low (w : BitVec 256) (di : BitVec 64) :
    (w - di.signExtend 256).extractLsb' 0 64 = w.extractLsb' 0 64 - di := by
  bv_decide

/-- A positive digit not above the low limb: no borrow. -/
theorem sub_upper_pos (w : BitVec 256) (di : BitVec 64) (hp : (0#64).slt di = true)
    (hb : ¬(w.extractLsb' 0 64).ult di = true) :
    (w - di.signExtend 256).extractLsb' 64 192 = w.extractLsb' 64 192 := by
  bv_decide

/-- A positive digit above the low limb: the upper limbs lose one. -/
theorem sub_upper_pos_borrow (w : BitVec 256) (di : BitVec 64) (hp : (0#64).slt di = true)
    (hb : (w.extractLsb' 0 64).ult di = true) :
    (w - di.signExtend 256).extractLsb' 64 192 = w.extractLsb' 64 192 - 1#192 := by
  bv_decide

/-- A negative digit whose magnitude fits the low limb: no carry. -/
theorem sub_upper_neg (w : BitVec 256) (di : BitVec 64) (hp : ¬(0#64).slt di = true)
    (hz : di ≠ 0#64) (hb : (w.extractLsb' 0 64).ult di = true) :
    (w - di.signExtend 256).extractLsb' 64 192 = w.extractLsb' 64 192 := by
  bv_decide

/-- A negative digit overflowing the low limb: the upper limbs gain one. -/
theorem sub_upper_neg_carry (w : BitVec 256) (di : BitVec 64) (hp : ¬(0#64).slt di = true)
    (hz : di ≠ 0#64) (hb : ¬(w.extractLsb' 0 64).ult di = true) :
    (w - di.signExtend 256).extractLsb' 64 192 = w.extractLsb' 64 192 + 1#192 := by
  bv_decide

/-! ### `w >>= 1` on the four limbs -/

/-- The limbs of `w >> 1`: each limb's `fshl` with the one above, the top one shifted. -/
theorem shr1_limbs (w : BitVec 256) :
    (w >>> 1).extractLsb' 0 64 =
        ((w.extractLsb' 64 64 ++ w.extractLsb' 0 64) <<< 63).extractLsb' 64 64 ∧
      (w >>> 1).extractLsb' 64 64 =
        ((w.extractLsb' 128 64 ++ w.extractLsb' 64 64) <<< 63).extractLsb' 64 64 ∧
      (w >>> 1).extractLsb' 128 64 =
        ((w.extractLsb' 192 64 ++ w.extractLsb' 128 64) <<< 63).extractLsb' 64 64 ∧
      (w >>> 1).extractLsb' 192 64 = w.extractLsb' 192 64 >>> 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- The upper limbs of `w >> 1`, spliced into `w`'s limb by limb. -/
theorem shr1_upper (w : BitVec 256) :
    Memory.spliceBits
        (Memory.spliceBits
          (Memory.spliceBits (w.extractLsb' 64 192) 0
            (((w.extractLsb' 128 64 ++ w.extractLsb' 64 64) <<< 63).extractLsb' 64 64)) 64
          (((w.extractLsb' 192 64 ++ w.extractLsb' 128 64) <<< 63).extractLsb' 64 64)) 128
        (w.extractLsb' 192 64 >>> 1) = (w >>> 1).extractLsb' 64 192 := by
  simp only [spliceBits_eq]
  bv_decide

/-- `w >> 1` is zero exactly when its four limbs `or` to zero. -/
theorem shr1_eq_zero (w : BitVec 256) :
    (((w.extractLsb' 128 64 ++ w.extractLsb' 64 64) <<< 63).extractLsb' 64 64 |||
          ((w.extractLsb' 64 64 ++ w.extractLsb' 0 64) <<< 63).extractLsb' 64 64 |||
        ((w.extractLsb' 192 64 ++ w.extractLsb' 128 64) <<< 63).extractLsb' 64 64 |||
      w.extractLsb' 192 64 >>> 1) = 0#64 ↔ w >>> 1 = 0#256 := by
  constructor <;> intro h <;> bv_decide

/-! ### The borrow and carry loops, a limb at a time -/

/-- A nonzero limb `j` absorbs the borrow. -/
theorem dec_limb_stop (U : BitVec 192) (hj : j < 3) (hl : ¬U.extractLsb' (64 * j) 64 = 0#64) :
    Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 18446744073709551615#64) =
      U - 1#192 <<< (64 * j) := by
  interval_cases j <;> simp only [spliceBits_eq] at * <;> bv_decide

/-- A zero limb `j` passes the borrow to limb `j + 1`. -/
theorem dec_limb_pass (U : BitVec 192) (hj : j < 2) (hl : U.extractLsb' (64 * j) 64 = 0#64) :
    Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 18446744073709551615#64) -
        1#192 <<< (64 * (j + 1)) = U - 1#192 <<< (64 * j) ∧
      Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 18446744073709551615#64) >>>
          (64 * (j + 1)) = U >>> (64 * (j + 1)) := by
  interval_cases j <;> simp only [spliceBits_eq] at * <;> constructor <;> bv_decide

/-- Upper limbs nonzero from `j`, limb `j` zero: nonzero from `j + 1`, and `j` is not the top. -/
theorem dec_nz_next (U : BitVec 192) (hj : j < 3) (hnz : ¬U >>> (64 * j) = 0#192)
    (hl : U.extractLsb' (64 * j) 64 = 0#64) : j < 2 ∧ ¬U >>> (64 * (j + 1)) = 0#192 := by
  interval_cases j <;> constructor <;> first | omega | bv_decide

/-- A limb `j` below all-ones absorbs the carry. -/
theorem inc_limb_stop (U : BitVec 192) (hj : j < 3)
    (hl : ¬U.extractLsb' (64 * j) 64 = 18446744073709551615#64) :
    Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 1#64) = U + 1#192 <<< (64 * j) := by
  interval_cases j <;> simp only [spliceBits_eq] at * <;> bv_decide

/-- An all-ones limb `j` passes the carry to limb `j + 1`. -/
theorem inc_limb_pass (U : BitVec 192) (hj : j < 2)
    (hl : U.extractLsb' (64 * j) 64 = 18446744073709551615#64) :
    Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 1#64) + 1#192 <<< (64 * (j + 1)) =
        U + 1#192 <<< (64 * j) ∧
      Memory.spliceBits U (64 * j) (U.extractLsb' (64 * j) 64 + 1#64) >>> (64 * (j + 1)) =
        U >>> (64 * (j + 1)) := by
  interval_cases j <;> simp only [spliceBits_eq] at * <;> constructor <;> bv_decide

/-- Upper limbs below all-ones from `j`, limb `j` all-ones: below from `j + 1`, `j` not the top. -/
theorem inc_nm_next (U : BitVec 192) (hj : j < 3)
    (hnm : ¬U >>> (64 * j) = BitVec.allOnes 192 >>> (64 * j))
    (hl : U.extractLsb' (64 * j) 64 = 18446744073709551615#64) :
    j < 2 ∧ ¬U >>> (64 * (j + 1)) = BitVec.allOnes 192 >>> (64 * (j + 1)) := by
  interval_cases j <;> constructor <;> first | omega | bv_decide

/-! ### The window -/

/-- A positive window is the low bits of `w0`: no borrow. -/
theorem win_no_borrow (hB : B ≤ 8) (w0 : BitVec 64) (h : (0#64).slt (win B w0) = true) :
    ¬w0.ult (win B w0) = true := by
  have : ∀ B < 9, ∀ w0 : BitVec 64, (0#64).slt (win B w0) = true → ¬w0.ult (win B w0) = true := by
    intro B hB w0
    interval_cases B <;> (unfold win; bv_decide)
  exact this B (by omega) w0 h

/-- An odd `w0`'s window is odd, so nonzero. -/
theorem win_ne_zero (hB : B ≤ 8) (w0 : BitVec 64) (h : ¬w0 &&& 1#64 = 0#64) : win B w0 ≠ 0#64 := by
  have : ∀ B < 9, ∀ w0 : BitVec 64, ¬w0 &&& 1#64 = 0#64 → win B w0 ≠ 0#64 := by
    intro B hB w0
    interval_cases B <;> (unfold win; bv_decide)
  exact this B (by omega) w0 h

/-- The window fits a `short`: `(short)di` is `nsw`. -/
theorem win_trunc (hB : B ≤ 8) (w0 : BitVec 64) :
    ((win B w0).setWidth 16).signExtend 64 = win B w0 := by
  have : ∀ B < 9, ∀ w0 : BitVec 64, ((win B w0).setWidth 16).signExtend 64 = win B w0 := by
    intro B hB w0
    interval_cases B <;> (unfold win; bv_decide)
  exact this B (by omega) w0

/-- Below `2^255`, the upper limbs are not all ones: no carry out of the top. -/
theorem upper_ne_allOnes (w : BitVec 256) (h : w.msb = false) :
    ¬w.extractLsb' 64 192 >>> (64 * 0) = BitVec.allOnes 192 >>> (64 * 0) := by
  bv_decide

/-! ### `bits`-derived constants -/

/-- `1UL << (bits+1)` loses no bit, unsigned or signed. -/
theorem shl_one_back (h : k < 10) :
    1#64 <<< k >>> k = 1#64 ∧ (1#64 <<< k).sshiftRight k = 1#64 := by
  have : ∀ k < 10, 1#64 <<< k >>> k = 1#64 ∧ (1#64 <<< k).sshiftRight k = 1#64 := by decide
  exact this k h

/-- The window minus `0` or `2^(bits+1)`, `nsw`: no signed overflow. -/
theorem ssubOverflow_window (h : B ≤ 8) (w0 : BitVec 64) :
    (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64).ssubOverflow
        (if (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64) >>> B = 0#64 then 0#64
          else 1#64 <<< (B + 1)) = false := by
  have : ∀ B < 9, ∀ w0 : BitVec 64,
      (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64).ssubOverflow
          (if (w0 &&& 1#64 <<< (B + 1) + 18446744073709551615#64) >>> B = 0#64 then 0#64
            else 1#64 <<< (B + 1)) = false := by
    intro B hB w0
    interval_cases B <;> bv_decide
  exact this B (by omega) w0

/-- A small `int` count sign-extends to the same `long`. -/
theorem signExtend_ofNat32 (h : n < 2 ^ 31) :
    (BitVec.ofNat 32 n).signExtend 64 = BitVec.ofNat 64 n := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false (msb_ofNat32 h)]
  exact setWidth_ofNat32 (by omega)

/-- `d[n]`'s byte offset `2 n` does not wrap, for `n < 256`. -/
theorem short_off {d : Pointer} (hdo : ¬d.offset.uaddOverflow 512#64) (hn : n < 256) :
    (BitVec.ofNat 64 (2 * n)).toNat = 2 * n ∧ ¬d.offset.uaddOverflow (BitVec.ofNat 64 (2 * n)) := by
  have h2n : (BitVec.ofNat 64 (2 * n)).toNat = 2 * n := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  exact ⟨h2n, BitVec.not_uaddOverflow_of_le hdo (by rw [h2n]; show 2 * n ≤ 512; omega)⟩

/-- `(1UL << (bits+1)) + -1`, `nsw`. -/
theorem saddOverflow_pow_allOnes (h : k < 10) :
    (1#64 <<< k).saddOverflow 18446744073709551615#64 = false := by
  have : ∀ k < 10, (1#64 <<< k).saddOverflow 18446744073709551615#64 = false := by decide
  exact this k h

/-! ### The bit-level digit is `Wnaf.digit` -/

/-- `mask`'s value, `2^(bits+1) − 1`. -/
theorem toNat_mask (hB : B ≤ 8) :
    (1#64 <<< (B + 1) + 18446744073709551615#64).toNat = 2 ^ (B + 1) - 1 := by
  have : ∀ B < 9, (1#64 <<< (B + 1) + 18446744073709551615#64).toNat = 2 ^ (B + 1) - 1 := by
    decide
  exact this B (by omega)

/-- `2^(bits+1)`'s value. -/
theorem toNat_pow1 (hB : B ≤ 8) : (1#64 <<< (B + 1)).toNat = 2 ^ (B + 1) := by
  have : ∀ B < 9, (1#64 <<< (B + 1)).toNat = 2 ^ (B + 1) := by decide
  exact this B (by omega)

/-- `x >> bits == 0` is `x < 2^bits`. -/
theorem ushiftRight_eq_zero_iff (x : BitVec 64) : x >>> B = 0#64 ↔ x.toNat < 2 ^ B := by
  rw [← BitVec.toNat_inj, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_zero,
    Nat.div_eq_zero_iff_lt (Nat.two_pow_pos B)]

/-- The C's `di`, read signed, is `Wnaf.digit` of the scalar. -/
theorem dv_toInt (hB : B ≤ 8) (w : BitVec 256) : (dv B w).toInt = Wnaf.digit B w.toNat := by
  have hw0 : (w.extractLsb' 0 64).toNat = w.toNat % 2 ^ 64 := by
    simp [BitVec.extractLsb'_toNat]
  have hdvd : 2 ^ (B + 1) ∣ 2 ^ 64 := pow_dvd_pow 2 (by omega)
  have hlo : (w.extractLsb' 0 64 &&& 1#64 <<< (B + 1) + 18446744073709551615#64).toNat =
      w.toNat % 2 ^ (B + 1) := by
    rw [BitVec.toNat_and, toNat_mask hB, Nat.and_two_pow_sub_one_eq_mod, hw0,
      Nat.mod_mod_of_dvd _ hdvd]
  have hodd : (w.extractLsb' 0 64 &&& 1#64).toNat = w.toNat % 2 := by
    rw [BitVec.toNat_and, show (1#64).toNat = 2 ^ 1 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
      hw0, Nat.mod_mod_of_dvd _ (by norm_num)]
  have hP := toNat_pow1 hB
  have hlt : w.toNat % 2 ^ (B + 1) < 2 ^ (B + 1) := Nat.mod_lt _ (by positivity)
  have hP2 : (2 : Nat) ^ (B + 1) = 2 * 2 ^ B := by rw [pow_succ']
  have hB9 : (2 : Nat) ^ (B + 1) ≤ 2 ^ 9 := Nat.pow_le_pow_right (by norm_num) (by omega)
  have hcast : (w.toNat : Int) % 2 ^ (B + 1) = ((w.toNat % 2 ^ (B + 1) : Nat) : Int) := by
    push_cast; rfl
  have hBc : ((2 ^ B : Nat) : Int) = 2 ^ B := by push_cast; rfl
  have hPc : ((2 ^ (B + 1) : Nat) : Int) = 2 ^ (B + 1) := by push_cast; rfl
  unfold dv Wnaf.digit
  by_cases he : w.extractLsb' 0 64 &&& 1#64 = 0#64
  · have : w.toNat % 2 = 0 := by rw [← hodd, he]; rfl
    simp [he, this]
  · have hne : ¬w.toNat % 2 = 0 := fun h => he (BitVec.eq_of_toNat_eq (by rw [hodd, h]; rfl))
    simp only [he, hne, ite_false, win, hcast]
    set lo := w.extractLsb' 0 64 &&& 1#64 <<< (B + 1) + 18446744073709551615#64 with hlodef
    by_cases hs : lo >>> B = 0#64
    · have hsm : lo.toNat < 2 ^ B := (ushiftRight_eq_zero_iff lo).1 hs
      have hn : ¬2 ^ B ≤ ((w.toNat % 2 ^ (B + 1) : Nat) : Int) := by
        rw [← hlo, ← hBc]; exact_mod_cast Nat.not_le.2 hsm
      simp only [hs, ite_true, BitVec.sub_zero, hn, ite_false]
      rw [BitVec.toInt_eq_toNat_of_lt (by omega), hlo]
    · have hge : 2 ^ B ≤ lo.toNat := by
        have := (ushiftRight_eq_zero_iff lo).not.1 hs; omega
      have hy : (2 : Int) ^ B ≤ ((w.toNat % 2 ^ (B + 1) : Nat) : Int) := by
        rw [← hlo]; exact_mod_cast hge
      simp only [hs, ite_false, hy, ite_true]
      have hsub : (lo - 1#64 <<< (B + 1)).toNat = 2 ^ 64 - 2 ^ (B + 1) + lo.toNat := by
        rw [BitVec.toNat_sub, hP]
        omega
      rw [BitVec.toInt_eq_toNat_cond, hsub, ite_eq_right (by omega), hlo, ← hPc]
      have : 2 ^ (B + 1) ≤ 2 ^ 64 := Nat.pow_le_pow_right (by norm_num) (by omega)
      push_cast
      omega

/-- The scalar after one peel, `(w − di) >> 1`, is `Wnaf`'s next value. -/
theorem stepW_toNat (hB : 1 ≤ B ∧ B ≤ 8) (w : BitVec 256) (hw : w.msb = false) :
    ((w - (dv B w).signExtend 256) >>> 1).toNat =
      ((w.toNat : Int) - Wnaf.digit B w.toNat).toNat / 2 := by
  have hD := dv_toInt hB.2 w
  obtain ⟨hlo, hhi⟩ := Wnaf.digit_bound B w.toNat hB.1
  have hle := Wnaf.digit_le B w.toNat
  have hwlt : 2 * w.toNat < 2 ^ 256 := BitVec.msb_eq_false_iff_two_mul_lt.1 hw
  have hB8 : (2 : Int) ^ B ≤ 256 := by
    calc (2 : Int) ^ B ≤ 2 ^ 8 := pow_le_pow_right₀ (by norm_num) hB.2
      _ = 256 := by norm_num
  have hy : ((dv B w).signExtend 256).toNat = (Wnaf.digit B w.toNat % 2 ^ 256).toNat := by
    rw [← @BitVec.ofInt_toInt _ ((dv B w).signExtend 256), BitVec.toNat_ofInt,
      BitVec.toInt_signExtend_of_le (by omega), hD]
    push_cast
    rfl
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, pow_one, BitVec.toNat_sub, hy]
  omega

/-- The stored `short` is `Wnaf.digit`. -/
theorem dv_short (hB : B ≤ 8) (w : BitVec 256) :
    (dv B w).setWidth 16 = BitVec.ofInt 16 (Wnaf.digit B w.toNat) := by
  rw [← dv_toInt hB w]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_setWidth, BitVec.toNat_ofInt, BitVec.toInt_eq_toNat_cond]
  have := (dv B w).isLt
  split <;> omega

/-- A shift right by one clears the sign bit. -/
theorem msb_ushiftRight_one (x : BitVec 256) : (x >>> 1).msb = false := by
  bv_decide

/-! ### The digit sequence -/

end Proof

@[expose] public section

/-- The `short`s the loop stores from `w`, with `fuel` peels: the digit, then the rest from
`(w − di) >> 1`, until `w` is zero. -/
def digitsBV (B : Nat) : Nat → BitVec 256 → List (BitVec 16)
  | 0, _ => []
  | f + 1, w =>
    if w = 0#256 then [] else (dv B w).setWidth 16 :: digitsBV B f ((w - (dv B w).signExtend 256) >>> 1)

end

section Proof

/-- They are `Wnaf.digits` as `short`s. -/
theorem digitsBV_eq (hB : 1 ≤ B ∧ B ≤ 8) :
    ∀ f (w : BitVec 256), w.msb = false →
      digitsBV B f w = (Wnaf.digits B f w.toNat).map (BitVec.ofInt 16) := by
  intro f
  induction f with
  | zero => intro w _; simp [digitsBV, Wnaf.digits]
  | succ f ih =>
    intro w hw
    by_cases h0 : w = 0#256
    · subst h0
      simp [digitsBV, Wnaf.digits]
    · obtain ⟨k, hk⟩ : ∃ k, w.toNat = k + 1 :=
        ⟨w.toNat - 1, by
          have : w.toNat ≠ 0 := fun h => h0 (BitVec.eq_of_toNat_eq (by simpa using h))
          omega⟩
      rw [digitsBV, ite_eq_right h0, ih _ (msb_ushiftRight_one _), stepW_toNat hB w hw,
        dv_short hB.2 w, hk, Wnaf.digits, List.map_cons]

/-! ### The blocks -/

namespace crc_adx_wnaf

/-- `^bb9`: the slot's lifetime ends, the count `r` is returned. -/
theorem ret (v d : Pointer) (B : Nat) (A : AllocState) (M : MemoryState) (ys : List (BitVec 16))
    (U : BitVec 192) (r : BitVec 32) {β : Type} (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (E : ⟪Γ⟫) :
    (crc_adx_wnaf.runFrom (hdr9 v B E r) ^bb9 (wst A M d v ys U) >>= g) =
      g (.cons (.value r) .nil,
        { alloc := A, mem := ((storeShorts M d 0 ys).storeAt (v.add 8#64) U).lifetimeEnd v }) := by
  block_init
  step_pure
  finish_block
  subst hS
  rfl

/-- `^bb8`: `d[n] = y`, `w >>= 1` stored back; then `^bb9` with `n + 1` when `w >> 1` is zero,
else `^bb1`. -/
theorem tail (d s v : Pointer) (B : Nat) (A : AllocState) (M : MemoryState) (hv : v.offset = 0)
    (hdv : d.id ≠ v.id) (hRv : Room M v 256) (hRd : Room M d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) {β : Type} (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (ys : List (BitVec 16)) (hn : ys.length < 256) (w : BitVec 256)
    (y : BitVec 16) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get)
    (hK9 : w >>> 1 = 0#256 → ∀ E' : ⟪Γ⟫,
      E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      (crc_adx_wnaf.runFrom (hdr9 v B E' (BitVec.ofNat 32 (ys.length + 1))) ^bb9
          (wst A M d v (ys ++ [y]) 0#192) >>= g) = K)
    (hK1 : ¬w >>> 1 = 0#256 → ∀ E' : ⟪Γ⟫,
      E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      (crc_adx_wnaf.runFrom (hdr1 v B E' (w >>> 1) (ys.length + 1)) ^bb1
          (wst A M d v (ys ++ [y]) ((w >>> 1).extractLsb' 64 192)) >>= g) = K) :
    (crc_adx_wnaf.runFrom (hdr8 v B E ys.length w y) ^bb8
        (wst A M d v ys (w.extractLsb' 64 192)) >>= g) = K := by
  obtain ⟨h2n, hov2n⟩ := short_off hdo hn
  have hRdn : Room (wst A M d v ys (w.extractLsb' 64 192)).mem
      (d.add (BitVec.ofNat 64 (2 * ys.length))) 16 :=
    Room.storeAt (Room.storeShorts (Room.add (by omega) hov2n (hRd.mono (by omega))) _ _)
  have hRvS : Room (wst A M d v ys (w.extractLsb' 64 192)).mem v 256 :=
    Room.storeAt (Room.storeShorts hRv _ _)
  block_init
  seal_env
  -- `d[n++] = (short)di;`
  step_pure [← BitVec.ofNat_add]
  step_pure [signExtend_ofNat32 (show ys.length < 2 ^ 31 by omega)]
  step_pure [Nat.mod_eq_of_lt (show ys.length < 18446744073709551616 by omega),
    show ys.length * 2 = 2 * ys.length by omega, show 2 * ys.length < 2 ^ 63 by omega]
  step_store
  rw [storeAt_short hdv] at hS
  obtain ⟨hR8, hR16, hR24⟩ := room_ulimbs (Room.storeShorts (p := d) hRv (ys ++ [y]) 0) hv
  -- `w >>= 1`, limb by limb, stored back
  step_pure
  step_pure
  step_store
  rw [(storeAt_ulimbs hv _).1] at hS
  step_pure
  step_store
  rw [(storeAt_ulimbs hv _).2.1] at hS
  step_pure
  step_store
  rw [(storeAt_ulimbs hv _).2.2, shr1_upper] at hS
  -- `while( w )`
  iterate 4 step_pure
  finish_block
  · have h0 : w >>> 1 = 0#256 := (shr1_eq_zero w).1 hbr
    rw [h0, show (0#256).extractLsb' 64 192 = 0#192 by decide] at hS
    step_loop using hK9 h0
  · have h0 : ¬w >>> 1 = 0#256 := fun h => hbr ((shr1_eq_zero w).2 h)
    obtain ⟨hl0, hl1, hl2, hl3⟩ := shr1_limbs w
    rw [← hl0, ← hl1, ← hl2, ← hl3] at hE
    step_loop using hK1 h0

/-- `^bb7`: the low limb less the digit, the digit as a `short`, the upper limbs reloaded; on to
`^bb8` with the scalar `W` they make. -/
theorem blk7 (d s v : Pointer) (B : Nat) (A : AllocState) (M : MemoryState) (hv : v.offset = 0)
    (hRv : Room M v 256) {β : Type} (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (ys : List (BitVec 16)) (w0 di : BitVec 64) (W : BitVec 256)
    (hW0 : W.extractLsb' 0 64 = w0 - di) (htr : (di.setWidth 16).signExtend 64 = di) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get)
    (hK8 : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      (crc_adx_wnaf.runFrom (hdr8 v B E' ys.length W (di.setWidth 16)) ^bb8
          (wst A M d v ys (W.extractLsb' 64 192)) >>= g) = K) :
    (crc_adx_wnaf.runFrom (hdr7 v B E ys.length w0 di) ^bb7
        (wst A M d v ys (W.extractLsb' 64 192)) >>= g) = K := by
  have hR8 : Room (storeShorts M d 0 ys) (v.add 8#64) 192 :=
    room_upper (Room.storeShorts (p := d) hRv ys 0) hv
  obtain ⟨hf8, hf16, hf24⟩ := fits_ulimbs (U := W.extractLsb' 64 192) hR8 hv
  obtain ⟨hr8, hr16, hr24⟩ := readAt_ulimbs (U := W.extractLsb' 64 192) hR8 hv
  have hx : (W.extractLsb' 64 192).extractLsb' 0 64 = W.extractLsb' 64 64 ∧
      (W.extractLsb' 64 192).extractLsb' 64 64 = W.extractLsb' 128 64 ∧
      (W.extractLsb' 64 192).extractLsb' 128 64 = W.extractLsb' 192 64 := by
    refine ⟨?_, ?_, ?_⟩ <;> bv_decide
  rw [hx.1] at hr8
  rw [hx.2.1] at hr16
  rw [hx.2.2] at hr24
  block_init
  seal_env
  step_pure
  step_pure [htr]
  step_load
  step_load
  step_load
  finish_block
  rw [← hW0] at hE
  step_loop using hK8

/-- `^bb6`, the carry loop at limb `j + 1`, `2 - j` limbs above: on to `^bb7` with `1` added at
upper limb `j`. -/
theorem carry_loop (d s v : Pointer) (B : Nat) (A : AllocState) (M : MemoryState)
    (hv : v.offset = 0) (hRv : Room M v 256) {β : Type}
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (ys : List (BitVec 16))
    (w0 di : BitVec 64) :
    ∀ m j (U : BitVec 192) (E : ⟪Γ⟫),
      E.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      j + m = 2 →
      ¬U >>> (64 * j) = BitVec.allOnes 192 >>> (64 * j) →
      (∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
        (crc_adx_wnaf.runFrom (hdr7 v B E' ys.length w0 di) ^bb7
            (wst A M d v ys (U + 1#192 <<< (64 * j))) >>= g) = K) →
      (crc_adx_wnaf.runFrom (hdr6 v B E ys.length w0 di j) ^bb6 (wst A M d v ys U) >>= g) = K := by
  have hR8 : Room (storeShorts M d 0 ys) (v.add 8#64) 192 :=
    room_upper (Room.storeShorts (p := d) hRv ys 0) hv
  intro m
  induction m with
  | zero =>
    intro j U E hArgs hm hnm hK
    have hj : j < 3 := by omega
    have hF := fits_ulimb (U := U) hR8 hv hj
    obtain ⟨-, -, hovj⟩ := ulimb_ptr hv hj
    block_init
    seal_env
    -- `ulong u = w[j] + cr; cr = (u < w[j]); w[j] = u;`
    step_pure [Nat.mod_eq_of_lt (show j + 1 < 18446744073709551616 by omega),
      show (j + 1) * 8 = 8 * (j + 1) by omega, show 8 * (j + 1) < 2 ^ 63 by omega]
    have hRj := room_ulimb hR8 hv hj
    step_load
    rw [readAt_ulimb hR8 hv hj] at *
    step_pure
    step_pure
    step_store
    rw [storeAt_ulimb hv hj] at hS
    step_pure [saddOverflow_one64 (i := j + 1) (by omega), uaddOverflow_one64 (i := j + 1) (by omega),
      ← BitVec.ofNat_add]
    step_pure [ult_ofNat64 (show j + 1 < 2 ^ 64 by omega) (show 3 < 2 ^ 64 by omega)]
    step_pure
    finish_block
    · -- around again: impossible at the top limb
      rw [carry_cond] at hbr
      simp only [decide_eq_true_eq] at hbr
      omega
    · -- the top limb is below all-ones: it absorbs the carry
      have hl : ¬U.extractLsb' (64 * j) 64 = 18446744073709551615#64 := fun h =>
        absurd (inc_nm_next U hj hnm h).1 (by omega)
      rw [inc_limb_stop U hj hl] at hS
      step_loop using hK
  | succ m ih =>
    intro j U E hArgs hm hnm hK
    have hj : j < 3 := by omega
    have hF := fits_ulimb (U := U) hR8 hv hj
    obtain ⟨-, -, hovj⟩ := ulimb_ptr hv hj
    block_init
    seal_env
    step_pure [Nat.mod_eq_of_lt (show j + 1 < 18446744073709551616 by omega),
      show (j + 1) * 8 = 8 * (j + 1) by omega, show 8 * (j + 1) < 2 ^ 63 by omega]
    have hRj := room_ulimb hR8 hv hj
    step_load
    rw [readAt_ulimb hR8 hv hj] at *
    step_pure
    step_pure
    step_store
    rw [storeAt_ulimb hv hj] at hS
    step_pure [saddOverflow_one64 (i := j + 1) (by omega), uaddOverflow_one64 (i := j + 1) (by omega),
      ← BitVec.ofNat_add]
    step_pure [ult_ofNat64 (show j + 1 < 2 ^ 64 by omega) (show 3 < 2 ^ 64 by omega)]
    step_pure
    finish_block
    · -- an all-ones limb: the carry moves up
      rw [carry_cond] at hbr
      simp only [decide_eq_true_eq, beq_iff_eq] at hbr
      obtain ⟨hp1, hp2⟩ := inc_limb_pass U (by omega) hbr.2
      have hnext := (inc_nm_next U hj hnm hbr.2).2
      step_loop using ih (j + 1) _ _ _ (by omega) (by rw [hp2]; exact hnext)
      rw [hp1] at hS
      step_loop using hK
    · -- below all-ones: it absorbs the carry
      rw [carry_cond] at hbr
      simp only [decide_eq_true_eq, beq_iff_eq, not_and] at hbr
      rw [inc_limb_stop U hj (hbr (by omega))] at hS
      step_loop using hK


/-- One peel, `^bb1` to `^bb8`: an even scalar's digit is `0`; an odd one's is its window, taken
off the four limbs, through the carry loop where the low limb overflows. -/
theorem iter (d s v : Pointer) (B : Nat) (hB : 3 ≤ B ∧ B ≤ 8) (A : AllocState) (M : MemoryState)
    (hv : v.offset = 0) (hRv : Room M v 256) {β : Type}
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (ys : List (BitVec 16))
    (w : BitVec 256) (hw : w.msb = false) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get)
    (hK8 : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      (crc_adx_wnaf.runFrom (hdr8 v B E' ys.length (w - (dv B w).signExtend 256)
          ((dv B w).setWidth 16)) ^bb8
          (wst A M d v ys ((w - (dv B w).signExtend 256).extractLsb' 64 192)) >>= g) = K) :
    (crc_adx_wnaf.runFrom (hdr1 v B E w ys.length) ^bb1
        (wst A M d v ys (w.extractLsb' 64 192)) >>= g) = K := by
  block_init
  seal_env
  -- `if( w[0] & 1 )`
  step_pure
  step_pure
  finish_block
  · -- even: the digit is `0`
    have hd : dv B w = 0#64 := by simp only [dv, hbr, ite_true]
    rw [hd, show (0#64 : BitVec 64).signExtend 256 = 0#256 by decide, BitVec.sub_zero,
      show (0#64 : BitVec 64).setWidth 16 = 0#16 by decide] at hK8
    step_loop using hK8
  · -- odd: `lo = w[0] & mask; di = lo >= half ? lo - (mask+1) : lo;`
    have hodd := hbr
    have hd : dv B w = win B (w.extractLsb' 0 64) := by simp only [dv, hbr, ite_false]
    rw [hd] at hK8
    have hz := win_ne_zero (B := B) (by omega) _ hodd
    have htr := win_trunc (B := B) (by omega) (w.extractLsb' 0 64)
    have hlow := sub_low w (win B (w.extractLsb' 0 64))
    block_init
    step_pure
    step_pure [Nat.mod_eq_of_lt (show B < 18446744073709551616 by omega), show ¬64 ≤ B by omega]
    step_pure
    step_pure [MLIR.ofBool_eq_one_iff, beq_iff_eq]
    step_pure [ssubOverflow_window (B := B) (by omega)]
    step_pure
    step_pure
    finish_block
    · -- `di > 0`: `w[0] - di` never borrows
      have hpos := hbr
      block_init
      finish_block
      · exact absurd hbr (win_no_borrow (by omega) _ hpos)
      · rw [← sub_upper_pos w _ hpos hbr]
        step_loop using blk7 d s v B A M hv hRv g K ys (w.extractLsb' 0 64)
          (win B (w.extractLsb' 0 64)) (w - (win B (w.extractLsb' 0 64)).signExtend 256) hlow htr
          _ _ hK8
    · -- `di < 0`: `w[0] + |di|` may carry
      have hneg := hbr
      block_init
      finish_block
      · rw [← sub_upper_neg w _ hneg hz hbr]
        step_loop using blk7 d s v B A M hv hRv g K ys (w.extractLsb' 0 64)
          (win B (w.extractLsb' 0 64)) (w - (win B (w.extractLsb' 0 64)).signExtend 256) hlow htr
          _ _ hK8
      · step_loop using carry_loop d s v B A M hv hRv g K ys (w.extractLsb' 0 64)
          (win B (w.extractLsb' 0 64)) 2 0 (w.extractLsb' 64 192) _ _ (by omega)
          (upper_ne_allOnes w hw)
        rw [← sub_upper_neg_carry w _ hneg hz hbr] at hS
        step_loop using blk7 d s v B A M hv hRv g K ys (w.extractLsb' 0 64)
          (win B (w.extractLsb' 0 64)) (w - (win B (w.extractLsb' 0 64)).signExtend 256) hlow htr
          _ _ hK8

/-- `^bb1`, the `while( w )` loop, at a nonzero `w` below `2^255` with fuel `f ≥ w`: the digits
`digitsBV` stored after `ys`, then `^bb9` with their count. -/
theorem main_loop (d s v : Pointer) (B : Nat) (hB : 3 ≤ B ∧ B ≤ 8) (A : AllocState)
    (M : MemoryState) (hv : v.offset = 0) (hdv : d.id ≠ v.id) (hRv : Room M v 256)
    (hRd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64) {β : Type}
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ f (w : BitVec 256) (ys : List (BitVec 16)) (E : ⟪Γ⟫),
      E.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
      ¬w = 0#256 → w.msb = false → w.toNat ≤ f →
      ys.length + (digitsBV B f w).length ≤ 256 →
      (∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
        (crc_adx_wnaf.runFrom
            (hdr9 v B E' (BitVec.ofNat 32 (ys.length + (digitsBV B f w).length))) ^bb9
            (wst A M d v (ys ++ digitsBV B f w) 0#192) >>= g) = K) →
      (crc_adx_wnaf.runFrom (hdr1 v B E w ys.length) ^bb1
          (wst A M d v ys (w.extractLsb' 64 192)) >>= g) = K := by
  intro f
  induction f with
  | zero =>
    intro w ys E _ h0 _ hf
    exact absurd (BitVec.eq_of_toNat_eq (by simp; omega)) h0
  | succ f ih =>
    intro w ys E hArgs h0 hw hf hlen hK
    have hds : digitsBV B (f + 1) w =
        (dv B w).setWidth 16 :: digitsBV B f ((w - (dv B w).signExtend 256) >>> 1) := by
      simp only [digitsBV, ite_eq_right h0]
    rw [hds] at hlen hK
    simp only [List.length_cons] at hlen
    have hn : ys.length < 256 := by omega
    have hK9 : (w - (dv B w).signExtend 256) >>> 1 = 0#256 → ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
        (crc_adx_wnaf.runFrom (hdr9 v B E' (BitVec.ofNat 32 (ys.length + 1))) ^bb9
            (wst A M d v (ys ++ [(dv B w).setWidth 16]) 0#192) >>= g) = K := by
      intro h0' E' hE'
      have he : digitsBV B f ((w - (dv B w).signExtend 256) >>> 1) = [] := by
        rw [h0']; cases f <;> simp [digitsBV]
      have := hK E' hE'
      rwa [he, List.length_singleton] at this
    have hK1 : ¬(w - (dv B w).signExtend 256) >>> 1 = 0#256 → ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value d) (.value s) (.value (BitVec.ofNat 32 B))).get →
        (crc_adx_wnaf.runFrom (hdr1 v B E' ((w - (dv B w).signExtend 256) >>> 1) (ys.length + 1))
            ^bb1 (wst A M d v (ys ++ [(dv B w).setWidth 16])
              (((w - (dv B w).signExtend 256) >>> 1).extractLsb' 64 192)) >>= g) = K := by
      intro h0' E' hE'
      have hlt : ((w - (dv B w).signExtend 256) >>> 1).toNat < w.toNat := by
        rw [stepW_toNat (by omega) w hw]
        exact Wnaf.next_lt B w.toNat (by omega)
          (Nat.pos_of_ne_zero fun h => h0 (BitVec.eq_of_toNat_eq (by simpa using h)))
      have := ih _ (ys ++ [(dv B w).setWidth 16]) E' hE' h0' (msb_ushiftRight_one _) (by omega)
        (by simp only [List.length_append, List.length_singleton]; omega)
        (fun E'' h'' => by
          have := hK E'' h''
          rw [List.length_cons, ← Nat.add_assoc] at this
          rw [List.append_assoc, List.singleton_append, List.length_append,
            List.length_singleton, Nat.add_right_comm]
          exact this)
      rwa [List.length_append, List.length_singleton] at this
    step_loop using iter d s v B hB A M hv hRv g K ys w hw _ _
    step_loop using tail d s v B A M hv hdv hRv hRd hdo g K ys hn (w - (dv B w).signExtend 256)
      ((dv B w).setWidth 16) _ _ hK9 hK1

end crc_adx_wnaf

attribute [local mlir_erase] storeShorts_eraseFrom

/-- `crc_adx_wnaf( d, s, bits )` stores `Wnaf.digits` of the scalar at `s` as `short`s at `d` and
returns their count, for `bits` in `3 … 8` and a scalar below `2^255`; its `ulong w[4]` is a frame
slot. -/
public theorem crc_adx_wnaf.call_eq (d s : Pointer) (B : Nat) (S : GlobalState) (hwf : S.WF)
    (hd : Room S.mem d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hs : Fits S.mem s (8 * 32)) (hso : ¬s.offset.uaddOverflow 32#64) (hB : 3 ≤ B ∧ B ≤ 8)
    (hx : (S.mem.readAt s 256).toNat < 2 ^ 255) :
    crc_adx_wnaf.call (crc_adx_wnaf.args (.value d) (.value s) (.value (BitVec.ofNat 32 B))) S =
      .value
        (.cons (.value (BitVec.ofNat 32
            (Wnaf.digits B (S.mem.readAt s 256).toNat (S.mem.readAt s 256).toNat).length)) .nil,
          { alloc := ⟨S.alloc.nextFreeBlock + 1⟩
            mem := storeShorts S.mem d 0
              ((Wnaf.digits B (S.mem.readAt s 256).toNat (S.mem.readAt s 256).toNat).map
                (BitVec.ofInt 16)) }) := by
  func_init
  rw [hS] at hx
  obtain ⟨x, hxe⟩ : ∃ x, S₀.mem.readAt s 256 = x := ⟨_, rfl⟩
  rw [hxe] at hx ⊢
  -- the scalar's limbs
  have hso8 : ¬s.offset.uaddOverflow 8#64 := BitVec.not_uaddOverflow_of_le hso (by decide)
  have hso16 : ¬s.offset.uaddOverflow 16#64 := BitVec.not_uaddOverflow_of_le hso (by decide)
  have hso24 : ¬s.offset.uaddOverflow 24#64 := BitVec.not_uaddOverflow_of_le hso (by decide)
  have e0 : S₀.mem.readAt s 64 = x.extractLsb' 0 64 := by
    have := MemoryState.readAt_add_of_readAt (off := 0#64) (w := 64) hs₀.inBounds
      (by have := s.offset.isLt; simp [BitVec.uaddOverflow]; omega) (by simp) hxe
    simpa [Pointer.add] using this
  have e1 : S₀.mem.readAt (s.add 8#64) 64 = x.extractLsb' 64 64 := by
    simpa using MemoryState.readAt_add_of_readAt hs₀.inBounds hso8 (by simp) hxe
  have e2 : S₀.mem.readAt (s.add 16#64) 64 = x.extractLsb' 128 64 := by
    simpa using MemoryState.readAt_add_of_readAt hs₀.inBounds hso16 (by simp) hxe
  have e3 : S₀.mem.readAt (s.add 24#64) 64 = x.extractLsb' 192 64 := by
    simpa using MemoryState.readAt_add_of_readAt hs₀.inBounds hso24 (by simp) hxe
  block_init
  iterate 9 step_pure
  step_alloca with v
  -- its lifetime starts
  step_pure
  have hRv : Room ((S₀.alloca 32 true).mem.lifetimeStart v) v 256 := by
    have := hroom_v; rw [hS] at this; exact this
  have hRd : Room ((S₀.alloca 32 true).mem.lifetimeStart v) d (8 * 512) := by
    have := hd; rw [hS] at this; exact this
  -- `ulong w[4] = { load8(s), … };`
  have hs0 : Fits S.mem s 64 := hs.mono (by omega)
  have hs8 : Fits S.mem (s.add 8#64) 64 := Fits.add_of_le hso8 (by decide) hs
  step_load with w0
  step_pure
  step_pure
  step_load with w1
  step_store
  have hs16 : Fits S.mem (s.add 16#64) 64 := Fits.add_of_le hso16 (by decide) hs
  step_pure
  step_pure
  step_load with w2
  step_store
  have hs24 : Fits S.mem (s.add 24#64) 64 := Fits.add_of_le hso24 (by decide) hs
  step_pure
  step_pure
  step_load with w3
  step_store
  subst hw0 hw1 hw2 hw3
  rw [init_limbs hv_off x] at hS
  -- `wid = bits+1`, `mask`, `half`
  step_pure [saddOverflow_one32 (i := B) (by omega), uaddOverflow_one32 (i := B) (by omega),
    ← BitVec.ofNat_add]
  step_pure [msb_ofNat32 (i := B + 1) (by omega), setWidth_ofNat32 (i := B + 1) (by omega)]
  step_pure [Nat.mod_eq_of_lt (show B + 1 < 18446744073709551616 by omega), show ¬64 ≤ B + 1 by omega,
    (shl_one_back (k := B + 1) (by omega)).1, (shl_one_back (k := B + 1) (by omega)).2]
  step_pure [Nat.mod_eq_of_lt (show B + 1 < 18446744073709551616 by omega),
    saddOverflow_pow_allOnes (k := B + 1) (by omega)]
  step_pure [msb_ofNat32 (i := B) (by omega), setWidth_ofNat32 (i := B) (by omega)]
  -- `while( w[0] | w[1] | w[2] | w[3] )`
  iterate 4 step_pure
  finish_block
  · -- a zero scalar: no digits
    have h0 : x = 0#256 := (limbs_or_eq_zero x).1 hbr
    subst h0
    block_init
    step_pure
    finish_block
    subst hS
    erase_frame
    simp [Wnaf.digits, storeShorts, GlobalState.alloca_alloc]
  · have h0 : ¬x = 0#256 := fun h => hbr ((limbs_or_eq_zero x).2 h)
    have hmsb : x.msb = false := BitVec.msb_eq_false_iff_two_mul_lt.2 (by omega)
    have hlen : ([] : List (BitVec 16)).length + (digitsBV B x.toNat x).length ≤ 256 := by
      rw [digitsBV_eq (by omega) _ _ hmsb, List.length_map, List.length_nil, Nat.zero_add]
      have := Wnaf.length_digits_le B (by omega) 255 x.toNat x.toNat (by omega)
      omega
    step_loop using crc_adx_wnaf.main_loop d s v B hB _ ((S₀.alloca 32 true).mem.lifetimeStart v)
      hv_off hd_ne_v hRv hRd hdo _ _ x.toNat x [] _ _ h0 hmsb le_rfl hlen
    -- `return n;`
    block_init
    step_pure
    finish_block
    subst hS
    erase_frame
    rw [List.nil_append, digitsBV_eq (by omega) _ _ hmsb, List.length_map]
    simp [GlobalState.alloca_alloc]

end Proof

end MLIR.Firedancer.Crc.Ref

module

public import MLIR.Run.Tactic
public import Zig.Math.ScalarCanonical
public import Zig.Common.Scalar
public import Zig.Common.Globals
public import Zig.Mlir.scalar_rejectNonCanonical
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace MLIR.Zig

@[expose] public section

/-- Byte `i` of `b`. -/
def bytesOf (b : BitVec 256) (i : ℕ) : BitVec 8 :=
  b.extractLsb' (8 * i) 8

/-- `ℓ`'s 32 bytes, `scalar.field_order_s`. -/
abbrev Scalar.ell256 : BitVec 256 :=
  7237005577332262213973186563042994240857116359379907606001950938285454250989#256

/-- `NonCanonical` (`1`) unless the bytes `b` are below `ℓ`'s, by Zig's constant-time scan from the
top byte: `c` flags a byte below `ℓ`'s while `n` flags all bytes above equal. -/
def scalar.rejectNonCanonical.spec (b : BitVec 256) : BitVec 16 :=
  (BitVec.ofBool (ltScan (bytesOf b) (bytesOf Scalar.ell256) 31 0#8 1#8 == 0#8)).setWidth 16

end

/-- Byte `i` of 32 bytes at `p` fits. -/
theorem fits_byte {m : MemoryState} {p : Pointer} (hf : Fits m p 256)
    (ho : p.offset.toNat + 32 < 2 ^ 64) (hi : i < 32) : Fits m (p.add (BitVec.ofNat 64 i)) 8 :=
  Fits.add_of_le
    (by
      simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
      rw [Nat.mod_eq_of_lt (by omega)]; omega)
    (by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)
    hf

/-- Byte `i` of 32 bytes read at `p`. -/
theorem readAt_byte {m : MemoryState} {p : Pointer} {B : BitVec 256} (hf : Fits m p 256)
    (ho : p.offset.toNat + 32 < 2 ^ 64) (hB : m.readAt p 256 = B) (hi : i < 32) :
    m.readAt (p.add (BitVec.ofNat 64 i)) 8 = bytesOf B i := by
  rw [MemoryState.readAt_add_of_readAt (w := 8) hf.inBounds
      (by
        simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
        rw [Nat.mod_eq_of_lt (by omega)]; omega)
      (by
        rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)
      hB,
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega), bytesOf, Nat.mul_comm]

/-- The global's bytes are `ℓ`'s. -/
theorem field_order_bytes (j : ℕ) (hj : j < 32) :
    bytesOf (Ty.flatBits (hw := by decide) scalar_field_order_s.lit) j =
      bytesOf Scalar.ell256 j := by
  simp only [bytesOf, Ty.flatBits_eq, BitVec.extractLsb'_cast]
  rw [Ty.extractLsb'_flattenRaw_array _
      (by
        simp [Ty.stride, Ty.width, Ty.padding, Ty.align]; omega)
      (by simp [Ty.stride, Ty.width, Ty.padding, Ty.align])]
  simp only [Ty.extractLsb'_flattenRaw_bv]
  have h8 : (Ty.bv 8).stride = 8 := by decide
  simp only [h8, Nat.mul_div_cancel_left _ (by decide : 0 < 8), Nat.mul_mod_right]
  interval_cases j <;> decide +revert

/-- The scan reads `o` only at bytes `0 … i`. -/
theorem ltScan_congr {s o o' : ℕ → BitVec 8} :
    ∀ i (c n : BitVec 8), (∀ j ≤ i, o j = o' j) → ltScan s o i c n = ltScan s o' i c n := by
  intro i
  induction i with
  | zero =>
    intro c n h; simp only [ltScan, h 0 (Nat.le_refl _)]
  | succ i ih =>
    intro c n h
    simp only [ltScan, h (i + 1) (Nat.le_refl _)]
    exact ih _ _ fun j hj => h j (by omega)

namespace scalar_rejectNonCanonical

/-- The loop at `^bb1`, byte `i`, flags `c`, `n`: it returns the scan's verdict from there. -/
theorem loop (p o : Pointer) (B O : BitVec 256)
    (g : Vals scalar_rejectNonCanonical.tRets × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (c n : BitVec 8) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value p)).get →
        (E ⊨ [%3440 := 0#8, %3441 := 0#64, %3442 := o, %3443 := 8#16, %3444 := 65535#16, %3445 :=
          18446744073709551615#64, %3446 := BitVec.ofNat 64 i, %3447 := n, %3448 := c]) →
        i < 32 →
        Fits S.mem p 256 →
        p.offset.toNat + 32 < 2 ^ 64 →
        S.mem.readAt p 256 = B →
        Fits S.mem o 256 →
        o.offset = 0 →
        S.mem.readAt o 256 = O →
        g
            (.cons
                (.value ((BitVec.ofBool (ltScan (bytesOf B) (bytesOf O) i c n == 0)).setWidth 16))
                .nil,
              S) =
          K →
        (scalar_rejectNonCanonical.runFrom E ^bb1 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro c n S E hArgs hR hi hpf hpo hB hof hoo hO hK
    block_init
    step_pure
    step_load with x12 hx12
    step_pure with x13 hx13
    step_pure
    step_load with x15 hx15
    step_pure with x16 hx16
    have c17 : x13.ssubOverflow x16 = false := by
      subst_vars; bv_decide
    step_pure [c17] with x17 hx17
    step_pure with x18 hx18
    have c19 : (x18.setWidth 8).setWidth 16 = x18 := by
      subst_vars; bv_decide
    step_pure [c19] with x19 hx19
    step_pure with x20 hx20
    step_pure with x21 hx21
    step_pure
    finish_block
    block_init
    step_pure with x23 hx23
    step_pure with x24 hx24
    finish_block
    have e : x24 = (BitVec.ofBool (ltScan (bytesOf B) (bytesOf O) 0 c n == 0)).setWidth 16 := by
      simp only [ltScan, ltScan.cStep, bytesOf]
      subst hx24 hx23 hx21 hx20 hx19 hx18 hx17 hx16 hx15 hx13 hx12
      bv_decide
    rw [hS, e]
    exact hK
  | succ i ih =>
    intro c n S E hArgs hR hi hpf hpo hB hof hoo hO hK
    have hg : (i + 1) % 18446744073709551616 < 18446744073709551616 := Nat.mod_lt _ (by decide)
    have hbB := readAt_byte hpf hpo hB hi
    have hbO :=
      readAt_byte hof
        (by
          rw [hoo]; decide)
        hO hi
    have hfB := fits_byte hpf hpo hi
    have hfO :=
      fits_byte hof
        (by
          rw [hoo]; decide)
        hi
    block_init
    step_pure [hg]
    step_load with x12 hx12
    step_pure with x13 hx13
    step_pure [hg]
    step_load with x15 hx15
    step_pure with x16 hx16
    have c17 : x13.ssubOverflow x16 = false := by
      clear ih hK; bv_decide
    step_pure [c17] with x17 hx17
    step_pure with x18 hx18
    have c19 : (x18.setWidth 8).setWidth 16 = x18 := by
      clear ih hK; bv_decide
    step_pure [c19] with x19 hx19
    step_pure with x20 hx20
    step_pure with x21 hx21
    step_pure
    finish_block
    · exfalso
      simp [BitVec.toNat_eq] at hbr
      omega
    · block_init
      step_pure with x25 hx25
      have c26 : x25.saddOverflow 65535#16 = false := by
        clear ih hK; bv_decide
      step_pure [c26] with x26 hx26
      step_pure with x27 hx27
      have c28 : (x27.setWidth 8).setWidth 16 = x27 := by
        clear ih hK; bv_decide
      step_pure [c28] with x28 hx28
      step_pure with x29 hx29
      have hi' : BitVec.ofNat 64 (i + 1) < 32#64 := by
        rw [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; exact hi
      have c30 : (BitVec.ofNat 64 (i + 1)).saddOverflow 18446744073709551615#64 = false := by
        clear ih hK; bv_decide
      step_pure [c30] with x30 hx30
      finish_block
      have e30 : x30 = BitVec.ofNat 64 i := by
        rw [hx30, BitVec.ofNat_add]
        generalize BitVec.ofNat 64 i = y
        clear ih hK; bv_decide
      have e21 : x21 = ltScan.cStep c n (bytesOf B (i + 1)) (bytesOf O (i + 1)) := by
        clear ih hK; simp only [ltScan.cStep]; bv_decide
      have e29 : x29 = ltScan.nStep n (bytesOf B (i + 1)) (bytesOf O (i + 1)) := by
        clear ih hK; simp only [ltScan.nStep]; bv_decide
      rw [ltScan, ← e21, ← e29] at hK
      refine ih x21 x29 S E hArgs ?_ (by omega) hpf hpo hB hof hoo hO (hS ▸ hK)
      refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
      rw [e30]

end scalar_rejectNonCanonical

/-- `scalar.rejectNonCanonical` returns `spec s`, for the 32 bytes `s` at `p`. -/
public theorem scalar_rejectNonCanonical.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hpo : p.offset.toNat + 32 < 2 ^ 64) :
    scalar_rejectNonCanonical.call (scalar_rejectNonCanonical.args (.value p)) s =
      .value
        (.cons (.value (scalar.rejectNonCanonical.spec (s.mem.readAt p 256))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_addressof scalar_field_order_s.value_eq with o
  iterate 3 step_pure
  finish_block
  have hB : S.mem.readAt p 256 = S₀.mem.readAt p 256 := by
    rw [hS]; exact MemoryState.readAt_addBlock hwf₀ hp₀.inBounds
  refine
    scalar_rejectNonCanonical.loop p o _ _ _ _ 31 0#8 1#8 S E hArgs ?_ (by omega) hp hpo hB ho_fits
      ho_off hread_o ?_
  · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> env_reads
  · rw [ltScan_congr _ _ _ fun j hj => field_order_bytes j (by omega), hS]
    dsimp only
    erase_frame
    rfl

/-! ## Meaning -/

namespace scalar_rejectNonCanonical

/-- The first `i` bytes of `b`, little-endian: `b` mod `256^i`. -/
theorem bytesVal_bytesOf (b : BitVec 256) : ∀ i, bytesVal (bytesOf b) i = b.toNat % 256 ^ i := by
  intro i
  induction i with
  | zero => simp [bytesVal, Nat.mod_one]
  | succ i
    ih =>
    rw [bytesVal, ih, Nat.mod_pow_succ, bytesOf, BitVec.extractLsb'_toNat,
      Nat.shiftRight_eq_div_pow, Nat.pow_mul]
    simp only [Nat.reducePow]
    rw [Nat.mul_comm]

end scalar_rejectNonCanonical

/-- `spec b` is `0` exactly when `b`, little-endian, is below `ℓ`, else `1` (`NonCanonical`). -/
public theorem scalar.rejectNonCanonical.spec_eq (b : BitVec 256) :
    scalar.rejectNonCanonical.spec b = if b.toNat < Ed25519.ell then 0#16 else 1#16 := by
  rw [scalar.rejectNonCanonical.spec,
    ltScan_eq _ _ 31 0#8 1#8 (.inl (by decide)) (.inr (by decide)),
    scalar_rejectNonCanonical.bytesVal_bytesOf, scalar_rejectNonCanonical.bytesVal_bytesOf,
    show (256 : ℕ) ^ (31 + 1) = 2 ^ 256 by norm_num, Nat.mod_eq_of_lt b.isLt,
    Nat.mod_eq_of_lt Scalar.ell256.isLt]
  have : Scalar.ell256.toNat = Ed25519.ell := by
    unfold Ed25519.ell; rfl
  rw [this]
  split <;> decide

end MLIR.Zig

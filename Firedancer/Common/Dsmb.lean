module

public import MLIR.Run.Tactic
public import Firedancer.Common.Counter
public import Firedancer.Ref.fd_curve25519_scalar_wnaf

/-! What the implementations of `fd_ed25519_double_scalar_mul_base` share: the slides in memory,
and the arithmetic of its counters, digits and table indices. -/

namespace MLIR

@[expose] public section

/-- Two ranges at byte offsets `a`, `b` from `p`, apart. -/
theorem Range.disjoint_add {p : Pointer} {a b v w : Nat} (ha : p.offset.toNat + a < 2 ^ 64)
    (hb : p.offset.toNat + b < 2 ^ 64) (hab : 8 * a + v ≤ 8 * b ∨ 8 * b + w ≤ 8 * a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) v).Disjoint (Range.of (p.add (BitVec.ofNat 64 b)) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb]
  omega

/-- A well-formed state stays so with its counter advanced. -/
theorem GlobalState.WF.bump {s : GlobalState} (h : s.WF) (hn : s.alloc.nextFreeBlock ≤ n) :
    (⟨⟨n⟩, s.mem⟩ : GlobalState).WF :=
  ⟨fun k hk => Nat.lt_of_lt_of_le (h.bound k hk) hn, Nat.lt_of_lt_of_le h.pos hn, h.null, h.global,
    h.merged⟩

/-- `WF.add_blocks` for a counter advanced twice, as a framed callee's result has it. -/
theorem GlobalState.WF.add_blocks₂ {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + j + k⟩, s.mem⟩ : GlobalState).WF :=
  GlobalState.WF.bump h (by omega)

namespace Firedancer

/-- Two byte offsets from `p`, as one. -/
theorem add_ofNat_add {p : Pointer} {a c : Nat} :
    (p.add (BitVec.ofNat 64 a)).add (BitVec.ofNat 64 c) = p.add (BitVec.ofNat 64 (a + c)) := by
  rw [Pointer.add_add, BitVec.ofNat_add]

/-! ### Slides -/

/-- The 256 `short`s `w` at `p`. -/
def SlidesAt (m : MemoryState) (p : Pointer) (w : Vector Int 256) : Prop :=
  ∀ k (hk : k < 256),
    Fits m (p.add (BitVec.ofNat 64 (2 * k))) 16 ∧
      m.readAt (p.add (BitVec.ofNat 64 (2 * k))) 16 = BitVec.ofInt 16 w[k]

/-- The 256 `short`s stored at `p`, lane by lane. -/
theorem SlidesAt.of_readAt {m : MemoryState} {p : Pointer} {w : Vector Int 256} (hf : Fits m p 4096)
    (hp : p.offset.toNat + 512 < 2 ^ 64)
    (h : m.readAt p 4096 = Ref.fd_curve25519_scalar_wnaf.shorts w) : SlidesAt m p w := fun k hk =>
  by
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (2 * k)) := by
    simp [BitVec.uaddOverflow]
    omega
  have h2k : (BitVec.ofNat 64 (2 * k)).toNat = 2 * k := by
    simp
    omega
  refine
    ⟨Fits.add_of_le hov
        (by
          rw [h2k]; omega)
        hf,
      ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov
      (by
        rw [h2k]; omega)
      h,
    h2k, show 2 * k * 8 = k * 16 by omega, BitVec.extractLsb'_packLanes _ _ hk, Vector.getElem_map]

/-! ### Counters and digits -/

/-- A small counter is `0` as a `long` exactly when it is. -/
theorem eq_zero_of_ofNat64 {i : Nat} (hi : i < 2 ^ 64) (h : BitVec.ofNat 64 i = 0#64) : i = 0 := by
  have := congrArg BitVec.toNat h
  simpa [Nat.mod_eq_of_lt hi] using this

/-- A positive counter is `> 0` as a `long`. -/
theorem slt_ofNat64 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 63) :
    (0#64).slt (BitVec.ofNat 64 i) = true := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.slt, hn]
  omega

/-- `i - 1` on a positive `long` counter does not overflow. -/
theorem saddOverflow_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551615#64 = false := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-- `i - 1` on a positive `long` counter. -/
theorem add_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 64) :
    BitVec.ofNat 64 i + 18446744073709551615#64 = BitVec.ofNat 64 (i - 1) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `i==1` as an `int`. -/
theorem flag64_one {i : Nat} (h : i < 2 ^ 64) :
    BitVec.setWidth 32 (BitVec.ofBool (BitVec.ofNat 64 i == 1#64)) =
      if i = 1 then 1#32 else 0#32 := by
  by_cases hi : i = 1
  · subst hi; rfl
  · have : (BitVec.ofNat 64 i == 1#64) = false := by
      rw [beq_eq_false_iff_ne]
      intro h'
      have := congrArg BitVec.toNat h'
      simp [Nat.mod_eq_of_lt h] at this
      exact hi this
    simp [hi, this]

/-- Entry `i - 1`'s offset, `k` bytes back from entry `i`'s: `c` is `-k`. -/
theorem off_prev {k c i : Nat} (hc : k + c = 2 ^ 64) (h1 : 1 ≤ i) (h : k * i < 2 ^ 64) :
    BitVec.ofNat 64 (k * i) + BitVec.ofNat 64 c = BitVec.ofNat 64 (k * (i - 1)) := by
  apply BitVec.eq_of_toNat_eq
  have hk : k ≤ k * i := Nat.le_mul_of_pos_right k h1
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mul_sub_one]
  generalize k * i = n at *
  omega

/-- `i - 1` on a small `int` counter does not overflow. -/
theorem saddOverflow_neg_one32 {i : Nat} (h : i < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow 4294967295#32 = false := by
  have hn : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (4294967295#32).toInt = -1 := by decide
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-- `i - 1` on a positive `int` counter. -/
theorem add_neg_one32 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 32) :
    BitVec.ofNat 32 i + 4294967295#32 = BitVec.ofNat 32 (i - 1) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- A small `int` counter is `> -1`. -/
theorem slt_neg_one32 {i : Nat} (h : i < 2 ^ 31) :
    (4294967295#32).slt (BitVec.ofNat 32 i) = true := by
  have hn : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (4294967295#32).toInt = -1 := by decide
  simp [BitVec.slt, hn, hm]
  omega

/-- A small counter is `0` as an `int` exactly when it is. -/
theorem eq_zero_of_ofNat32 {i : Nat} (hi : i < 2 ^ 32) (h : BitVec.ofNat 32 i = 0#32) : i = 0 := by
  have := congrArg BitVec.toNat h
  simpa [Nat.mod_eq_of_lt hi] using this

/-- A digit's `short` read back. -/
theorem toInt_ofInt16 {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) : (BitVec.ofInt 16 d).toInt = d :=
  BitVec.toInt_ofInt_eq_self (by decide) h.1 h.2

/-- A digit's `short` is `0` exactly when the digit is. -/
theorem ofInt16_eq_zero {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    BitVec.ofInt 16 d = 0#16 ↔ d = 0 := by
  constructor
  · intro h0
    have := congrArg BitVec.toInt h0
    rwa [BitVec.toInt_ofInt_eq_self (by decide) h.1 h.2] at this
  · rintro rfl
    rfl

/-- `d > 0` on a digit's `short`. -/
theorem slt_zero_ofInt16 {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    (0#16).slt (BitVec.ofInt 16 d) = decide (0 < d) := by
  rw [BitVec.slt, toInt_ofInt16 h]
  rfl

/-- `d < 0` on a digit's `short`. -/
theorem ofInt16_slt_zero {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    (BitVec.ofInt 16 d).slt 0#16 = decide (d < 0) := by
  rw [BitVec.slt, toInt_ofInt16 h]
  rfl

/-- The table index `d / 2` of a positive digit, as the code computes it. -/
theorem idx_pos {d : Int} (h : 0 ≤ d ∧ d < 2 ^ 15) :
    (BitVec.setWidth 64 (BitVec.ofInt 16 d) >>> 1).toNat = (d / 2).toNat := by
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, BitVec.toNat_ofInt,
    Nat.shiftRight_eq_div_pow]
  omega

/-- The table index `-d / 2` of a negative digit, as the code computes it. -/
theorem idx_neg {d : Int} (h : -2 ^ 15 < d ∧ d ≤ 0) :
    (BitVec.setWidth 64 (-BitVec.ofInt 16 d) >>> 1).toNat = (-d / 2).toNat := by
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, ← BitVec.ofInt_neg, BitVec.toNat_ofInt,
    Nat.shiftRight_eq_div_pow]
  omega

/-- `d == c` as an `int`, on digits' `short`s. -/
theorem flag_eq {d c : Int} (hd : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) (hc : -2 ^ 15 ≤ c ∧ c < 2 ^ 15) :
    BitVec.setWidth 32 (BitVec.ofBool (BitVec.ofInt 16 d == BitVec.ofInt 16 c)) =
      if d = c then 1#32 else 0#32 := by
  by_cases h : d = c
  · subst h; simp
  · have : (BitVec.ofInt 16 d == BitVec.ofInt 16 c) = false := by
      rw [beq_eq_false_iff_ne]
      intro h'
      have := congrArg BitVec.toInt h'
      rw [BitVec.toInt_ofInt_eq_self (by decide) hd.1 hd.2,
        BitVec.toInt_ofInt_eq_self (by decide) hc.1 hc.2] at this
      exact h this
    simp [h, this]

/-- `d == 1` as an `int`. -/
theorem flag_one {d : Int} (hd : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    BitVec.setWidth 32 (BitVec.ofBool (BitVec.ofInt 16 d == 1#16)) = if d = 1 then 1#32 else 0#32 :=
  flag_eq (c := 1) hd (by decide)

/-- `d == -1` as an `int`. -/
theorem flag_neg_one {d : Int} (hd : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    BitVec.setWidth 32 (BitVec.ofBool (BitVec.ofInt 16 d == 65535#16)) =
      if d = -1 then 1#32 else 0#32 := by
  rw [show (65535#16) = BitVec.ofInt 16 (-1) by decide]
  exact flag_eq hd (by decide)

end Firedancer

end

end MLIR

module

public import Firedancer.Lane.Common.Jacobi
public import MLIR.Run.Tactic

/-! Five-limb arrays of `long` in memory, as `fd_f25519_update_fg_62_var` and
`fd_f25519_jacobi_var` hold `f` and `g`. -/

namespace MLIR.Firedancer.Lane.Jacobi

@[expose] public section

/-- The five limbs at `p`. -/
def limbsAt (m : MemoryState) (p : Pointer) : Vector (BitVec 64) 5 :=
  Vector.ofFn fun k : Fin 5 => m.readAt (p.add (BitVec.ofNat 64 (8 * k))) 64

/-- `f[k] = F[k]; g[k] = G[k]` for `k < len`, in turn. -/
def storeFG (m : MemoryState) (f g : Pointer) (F G : Vector (BitVec 64) 5) :
    Nat → MemoryState
  | 0 => m
  | n + 1 =>
    ((storeFG m f g F G n).storeAt (f.add (BitVec.ofNat 64 (8 * n))) F[n]!).storeAt
      (g.add (BitVec.ofNat 64 (8 * n))) G[n]!

end

/-- `+` left-commutes, for normalizing sums with `add_comm` and `add_assoc`. -/
public theorem add_left_comm {w : Nat} (a b c : BitVec w) : a + (b + c) = b + (a + c) := by
  rw [← BitVec.add_assoc, BitVec.add_comm a b, BitVec.add_assoc]

/-- A compiled carry step, `(f[i] u + c) + g[i] v`, as `updLoop`'s `c + (u f[i] + v g[i])`. -/
public theorem carry_step (c : BitVec 128) (u v a b : BitVec 64) :
    a.signExtend 128 * u.signExtend 128 + c + b.signExtend 128 * v.signExtend 128 =
      c + (ext u * ext a + ext v * ext b) := by
  simp only [ext, BitVec.mul_comm (u.signExtend 128), BitVec.mul_comm (v.signExtend 128)]
  rw [← BitVec.add_assoc, BitVec.add_comm c]

/-- The compiled first carry, `g[0] v + f[0] u`, as `updateFg`'s `u f[0] + v g[0]`. -/
public theorem carry_init (u v a b : BitVec 64) :
    b.signExtend 128 * v.signExtend 128 + a.signExtend 128 * u.signExtend 128 =
      ext u * ext a + ext v * ext b := by
  simp only [ext, BitVec.mul_comm (u.signExtend 128), BitVec.mul_comm (v.signExtend 128)]
  exact BitVec.add_comm _ _

/-- `p` zero bytes on. -/
@[simp] public theorem add_zero (p : Pointer) : p.add 0#64 = p := by
  simp [Pointer.add]

/-- Erasing a well-formed state's frame from its next free block leaves its memory. -/
public theorem mem_eraseFrom_self {s : GlobalState} (hs : s.WF) :
    s.mem.eraseFrom s.alloc.nextFreeBlock = s.mem :=
  congrArg GlobalState.mem (GlobalState.eraseFrom_self hs)

private theorem noov_of_le {p : Pointer} {off : BitVec 64} (ho : ¬p.offset.uaddOverflow 40#64)
    (h : off.toNat ≤ 40) : ¬p.offset.uaddOverflow off := by
  simp [BitVec.uaddOverflow] at *
  omega

/-- Room for the five limbs at `p`, one at a time. -/
public theorem room_limbs {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) :
    Room m p 64 ∧ Room m (p.add 8#64) 64 ∧ Room m (p.add 16#64) 64 ∧ Room m (p.add 24#64) 64 ∧
      Room m (p.add 32#64) 64 :=
  ⟨h.mono (by omega), Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h⟩

/-- The five limbs at `p` fit, one at a time. -/
public theorem fits_limbs {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) :
    Fits m p 64 ∧ Fits m (p.add 8#64) 64 ∧ Fits m (p.add 16#64) 64 ∧ Fits m (p.add 24#64) 64 ∧
      Fits m (p.add 32#64) 64 :=
  ⟨h.mono (by omega), Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h⟩

/-- A product of two `long`s, as `int128`s: within `±2^126`. -/
public theorem mul_toInt_bound (a b : BitVec 64) :
    -(2 ^ 126 : Int) ≤ a.toInt * b.toInt ∧ a.toInt * b.toInt ≤ 2 ^ 126 := by
  have ha := a.toInt_lt
  have ha' := a.le_toInt
  have hb := b.toInt_lt
  have hb' := b.le_toInt
  simp only [Nat.add_one_sub_one] at *
  have h1 : a.toInt.natAbs ≤ 2 ^ 63 := by omega
  have h2 : b.toInt.natAbs ≤ 2 ^ 63 := by omega
  have h3 : (a.toInt * b.toInt).natAbs ≤ 2 ^ 126 := by
    rw [Int.natAbs_mul]
    calc a.toInt.natAbs * b.toInt.natAbs ≤ 2 ^ 63 * 2 ^ 63 := Nat.mul_le_mul h1 h2
      _ = 2 ^ 126 := by rw [← Nat.pow_add]
  generalize a.toInt * b.toInt = P at *
  omega

/-- `(int128)a * (int128)b` does not overflow. -/
public theorem sext_mul_noov (a b : BitVec 64) :
    ¬(a.signExtend 128).smulOverflow (b.signExtend 128) = true := by
  have := mul_toInt_bound a b
  simp only [BitVec.smulOverflow, BitVec.toInt_signExtend_of_le (show 64 ≤ 128 by omega)]
  simp
  omega

/-- An `int128` shifted right by `62`: within `±2^65`. -/
public theorem shr62_bound (c : BitVec 128) :
    -(2 ^ 65 : Int) ≤ (c.sshiftRight 62).toInt ∧ (c.sshiftRight 62).toInt ≤ 2 ^ 65 := by
  rw [BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  have h1 := c.toInt_lt
  have h2 := c.le_toInt
  simp only [Nat.add_one_sub_one] at *
  constructor <;> omega

/-- A carry plus a product of two `long`s does not overflow an `int128`. -/
public theorem add_noov (a b : BitVec 64) (c : BitVec 128) :
    ¬(a.signExtend 128 * b.signExtend 128).saddOverflow (c.sshiftRight 62) = true := by
  have hm := mul_toInt_bound a b
  have hc := shr62_bound c
  have := BitVec.toInt_mul_of_not_smulOverflow (sext_mul_noov a b)
  simp only [BitVec.toInt_signExtend_of_le (show 64 ≤ 128 by omega)] at this
  rw [BitVec.toInt_sshiftRight] at hc
  simp only [BitVec.saddOverflow, this, BitVec.toInt_sshiftRight, Bool.or_eq_true,
    decide_eq_true_eq, not_or]
  omega

end MLIR.Firedancer.Lane.Jacobi

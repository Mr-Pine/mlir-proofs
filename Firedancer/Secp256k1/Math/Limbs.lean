module

public import Firedancer.Secp256k1.Bits
public import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! Facts about the limb and byte views of `Bits.lean`: `limbsEval`/`limbsOfNat` round trips,
big-endian bytes through `fd_uint256_bswap`, `fd_uint256_eq`/`cmp`, `invMod`, 4-bit windows. -/

namespace Firedancer.Secp256k1

/-! ## Limbs -/

public theorem limbsEval_four (a : Vector (BitVec 64) 4) :
    limbsEval a =
      a[0].toNat + a[1].toNat * 2 ^ 64 + a[2].toNat * 2 ^ 128 + a[3].toNat * 2 ^ 192 := by
  simp [limbsEval, Nat.fold_succ]

public theorem limbsEval_lt (a : Vector (BitVec 64) 4) : limbsEval a < 2 ^ 256 := by
  have := a[0].isLt; have := a[1].isLt; have := a[2].isLt; have := a[3].isLt
  rw [limbsEval_four]; omega

public theorem limbsEval_limbsOfNat (v : ℕ) : limbsEval (limbsOfNat 4 v) = v % 2 ^ 256 := by
  simp [limbsEval_four, limbsOfNat, Nat.shiftRight_eq_div_pow]
  omega

public theorem limbsOfNat_limbsEval (a : Vector (BitVec 64) 4) :
    limbsOfNat 4 (limbsEval a) = a := by
  have := a[0].isLt; have := a[1].isLt; have := a[2].isLt; have := a[3].isLt
  refine Vector.ext fun i hi => ?_
  simp only [limbsOfNat, Vector.getElem_ofFn, Nat.shiftRight_eq_div_pow]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat, limbsEval_four]
  interval_cases i <;> simp <;> omega

public theorem limbsEval_injective : Function.Injective (limbsEval (k := 4)) := fun a b h => by
  rw [← limbsOfNat_limbsEval a, ← limbsOfNat_limbsEval b, h]

public theorem limbsEval_limbsOfNat_of_lt {v : ℕ} (h : v < 2 ^ 256) :
    limbsEval (limbsOfNat 4 v) = v := by rw [limbsEval_limbsOfNat, Nat.mod_eq_of_lt h]

public theorem toNat_append_add {m n : ℕ} (x : BitVec m) (y : BitVec n) :
    (x ++ y).toNat = x.toNat * 2 ^ n + y.toNat := by
  rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt y.isLt, Nat.shiftLeft_eq]

/-! ## Bytes -/

@[expose] public section

/-- The big-endian value of 32 bytes (Horner from `b[0]`). -/
def beNat (b : Vector (BitVec 8) 32) : ℕ :=
  Nat.fold 32 (fun i h acc => acc * 256 + b[i].toNat) 0

end

theorem bswap_bytes (x0 x1 x2 x3 x4 x5 x6 x7 : BitVec 8) :
    fd_ulong_bswap.spec (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0) =
      x0 ++ x1 ++ x2 ++ x3 ++ x4 ++ x5 ++ x6 ++ x7 := by
  unfold fd_ulong_bswap.spec; bv_decide

theorem toNat_bswap_bytes (x0 x1 x2 x3 x4 x5 x6 x7 : BitVec 8) :
    (fd_ulong_bswap.spec (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0)).toNat =
      x0.toNat * 2 ^ 56 + x1.toNat * 2 ^ 48 + x2.toNat * 2 ^ 40 + x3.toNat * 2 ^ 32 +
        x4.toNat * 2 ^ 24 +
        x5.toNat * 2 ^ 16 +
        x6.toNat * 2 ^ 8 +
        x7.toNat := by
  rw [bswap_bytes]
  show (x0 ++ x1 ++ x2 ++ x3 ++ x4 ++ x5 ++ x6 ++ x7).toNat = _
  simp only [toNat_append_add]
  ring

/-- Big-endian bytes read as `memcpy` then `fd_uint256_bswap`. -/
public theorem limbsEval_bswap_ofBuf (b : Vector (BitVec 8) 32) :
    limbsEval (fd_uint256_bswap.spec (fd_uint256_t.ofBuf b)) = beNat b := by
  simp only [fd_uint256_bswap.spec, fd_uint256_t.ofBuf, limbsEval_four]
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero, Vector.getElem_ofFn]
  simp only [Nat.reduceMul, Nat.reduceAdd, toNat_bswap_bytes]
  simp only [beNat, Nat.fold_succ, Nat.fold_zero]
  ring

public theorem ofBuf_buf (a : fd_uint256_t) : fd_uint256_t.ofBuf a.buf = a := by
  refine Vector.ext fun i hi => ?_
  have h (x : BitVec 64) :
    x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
        x.extractLsb' 24 8 ++
        x.extractLsb' 16 8 ++
        x.extractLsb' 8 8 ++
        x.extractLsb' 0 8 =
      x := by
    bv_decide
  interval_cases i <;> simp [fd_uint256_t.ofBuf, fd_uint256_t.buf, h]

public theorem bswap_bswap (a : fd_uint256_t) :
    fd_uint256_bswap.spec (fd_uint256_bswap.spec a) = a := by
  have h (x : BitVec 64) : fd_ulong_bswap.spec (fd_ulong_bswap.spec x) = x := by
    unfold fd_ulong_bswap.spec; bv_decide
  refine Vector.ext fun i hi => ?_
  interval_cases i <;> simp [fd_uint256_bswap.spec, h]

/-- The bytes `fd_uint256_bswap` then `memcpy` store, big-endian, are the value. -/
public theorem beNat_bswap_buf (a : fd_uint256_t) :
    beNat (fd_uint256_bswap.spec a).buf = limbsEval a := by
  rw [← limbsEval_bswap_ofBuf, ofBuf_buf, bswap_bswap]

/-! ## Comparisons -/

/-- `fd_uint256_eq` is `1` exactly on equal limbs. -/
public theorem fd_uint256_eq.spec_eq (a b : fd_uint256_t) :
    fd_uint256_eq.spec a b = if a = b then 1#32 else 0#32 := by
  unfold fd_uint256_eq.spec
  by_cases h : a = b
  · subst h; simp
  · simp only [h, ↓reduceIte, ite_eq_right_iff]
    rintro ⟨h0, h1, h2, h3⟩
    refine absurd (Vector.ext fun i hi => ?_) h
    interval_cases i <;> assumption

/-- `fd_uint256_cmp( a, b ) >= 0` exactly when `b ≤ a`. -/
public theorem fd_uint256_cmp.spec_sle (a b : fd_uint256_t) :
    (0#32).sle (fd_uint256_cmp.spec a b) = decide (limbsEval b ≤ limbsEval a) := by
  have := a[0].isLt; have := a[1].isLt; have := a[2].isLt; have := a[3].isLt
  have := b[0].isLt; have := b[1].isLt; have := b[2].isLt; have := b[3].isLt
  rw [limbsEval_four, limbsEval_four]
  unfold fd_uint256_cmp.spec
  simp only [ne_eq, ← BitVec.toNat_inj, BitVec.lt_def]
  split_ifs <;>
    simp only [show (0#32).sle 0#32 = true from rfl, show (0#32).sle 1#32 = true from rfl,
      show (0#32).sle (-1#32) = false from rfl, eq_comm (a := true), eq_comm (a := false),
      decide_eq_true_eq, decide_eq_false_iff_not] <;>
    omega

/-! ## Inverses -/

public theorem invMod_lt {a m : ℕ} (hm : 0 < m) : invMod a m < m := by
  unfold invMod
  have := Int.emod_lt_of_pos (Nat.gcdA a m) (by omega : (0 : ℤ) < m)
  omega

public theorem natCast_invMod {a m : ℕ} (hm : 0 < m) :
    ((invMod a m : ℕ) : ZMod m) = (Nat.gcdA a m : ZMod m) := by
  unfold invMod
  have h := Int.emod_nonneg (Nat.gcdA a m) (by omega : (m : ℤ) ≠ 0)
  rw [← Int.cast_natCast, Int.toNat_of_nonneg h, ZMod.intCast_mod]

/-- `invMod a m` inverts `a` modulo `m` when they are coprime. -/
public theorem natCast_mul_invMod {a m : ℕ} (hm : 0 < m) (h : Nat.Coprime a m) :
    (a : ZMod m) * (invMod a m : ℕ) = 1 := by
  rw [natCast_invMod hm]
  have e := congrArg (Int.cast : ℤ → ZMod m) (Nat.gcd_eq_gcd_ab a m)
  rw [Nat.Coprime.gcd_eq_one h] at e
  push_cast at e
  rw [ZMod.natCast_self, zero_mul, add_zero] at e
  exact e.symm

/-! ## Windows -/

/-- Limb `q` of the value. -/
public theorem limbsEval_div_mod (e : Vector (BitVec 64) 4) {q : ℕ} (hq : q < 4) :
    limbsEval e / 2 ^ (64 * q) % 2 ^ 64 = e[q].toNat := by
  have := e[0].isLt; have := e[1].isLt; have := e[2].isLt; have := e[3].isLt
  rw [limbsEval_four]
  interval_cases q <;> simp <;> omega

/-- A 4-bit window that does not straddle limbs. -/
public theorem window_eq (e : Vector (BitVec 64) 4) {i : ℕ} (hi : i < 256) (h4 : i % 4 = 0) :
    ((e[i / 64]'(by omega) >>> (i % 64)) &&& 15#64).toNat = limbsEval e / 2 ^ i % 16 := by
  have hr : i % 64 + 4 ≤ 64 := by omega
  rw [BitVec.toNat_and, BitVec.toNat_ushiftRight, ← limbsEval_div_mod e (by omega : i / 64 < 4),
    show (15#64).toNat = 2 ^ 4 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    Nat.shiftRight_eq_div_pow]
  conv_rhs => rw [← Nat.div_add_mod i 64, pow_add, ← Nat.div_div_eq_div_mul]
  rw [show 2 ^ 64 = 2 ^ (i % 64) * 2 ^ (64 - i % 64) by
      rw [← pow_add]; congr 1; omega,
    Nat.mod_mul_right_div_self,
    show 2 ^ (64 - i % 64) = 2 ^ 4 * 2 ^ (60 - i % 64) by
      rw [← pow_add]; congr 1; omega,
    Nat.mod_mod_of_dvd _ (Dvd.intro _ rfl)]
  rfl

end Firedancer.Secp256k1

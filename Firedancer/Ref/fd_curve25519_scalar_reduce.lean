module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_load_8
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Std.Data.ExtHashMap.Lemmas
public meta import Lean.Elab.Tactic

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `in mod ℓ` as the C computes it: the 512 bits as 21-bit limbs, the limbs above `2^252` folded
down by `2^252 ≡ -27742317777372353535851937790883648493 (mod ℓ)` (the `666643 … 683901` rows), the
carries in between, and the 12 low limbs packed into 256 bits. `1048576` is `1L << 20`; the dead
`sK = 0` resets are left out. -/
def fd_curve25519_scalar_reduce.spec (x : BitVec 512) : BitVec 256 :=
  -- Load the 512 bits to reduce
  let in0 := x.extractLsb' 0 64
  let in1 := x.extractLsb' 64 64
  let in2 := x.extractLsb' 128 64
  let in3 := x.extractLsb' 192 64
  let in4 := x.extractLsb' 256 64
  let in5 := x.extractLsb' 320 64
  let in6 := x.extractLsb' 384 64
  let in7 := x.extractLsb' 448 64
  let mask := 2097151#64 -- `FD_ULONG_MASK_LSB( 21 )`
  -- Unpack into 23 21-bit integers and a 29-bit straggler
  let s0 := in0 &&& mask
  let s1 := in0 >>> 21 &&& mask
  let s2 := in0 >>> 42 &&& mask
  let s3 := (in0 >>> 63 ||| in1 <<< 1) &&& mask
  let s4 := in1 >>> 20 &&& mask
  let s5 := in1 >>> 41 &&& mask
  let s6 := (in1 >>> 62 ||| in2 <<< 2) &&& mask
  let s7 := in2 >>> 19 &&& mask
  let s8 := in2 >>> 40 &&& mask
  let s9 := (in2 >>> 61 ||| in3 <<< 3) &&& mask
  let s10 := in3 >>> 18 &&& mask
  let s11 := in3 >>> 39 &&& mask
  let s12 := (in3 >>> 60 ||| in4 <<< 4) &&& mask
  let s13 := in4 >>> 17 &&& mask
  let s14 := in4 >>> 38 &&& mask
  let s15 := (in4 >>> 59 ||| in5 <<< 5) &&& mask
  let s16 := in5 >>> 16 &&& mask
  let s17 := in5 >>> 37 &&& mask
  let s18 := (in5 >>> 58 ||| in6 <<< 6) &&& mask
  let s19 := in6 >>> 15 &&& mask
  let s20 := in6 >>> 36 &&& mask
  let s21 := (in6 >>> 57 ||| in7 <<< 7) &&& mask
  let s22 := in7 >>> 14 &&& mask
  let s23 := in7 >>> 35
  -- Do the reduction
  let s11 := s11 + s23 * 666643#64
  let s12 := s12 + s23 * 470296#64
  let s13 := s13 + s23 * 654183#64
  let s14 := s14 - s23 * 997805#64
  let s15 := s15 + s23 * 136657#64
  let s16 := s16 - s23 * 683901#64
  let s10 := s10 + s22 * 666643#64
  let s11 := s11 + s22 * 470296#64
  let s12 := s12 + s22 * 654183#64
  let s13 := s13 - s22 * 997805#64
  let s14 := s14 + s22 * 136657#64
  let s15 := s15 - s22 * 683901#64
  let s9 := s9 + s21 * 666643#64
  let s10 := s10 + s21 * 470296#64
  let s11 := s11 + s21 * 654183#64
  let s12 := s12 - s21 * 997805#64
  let s13 := s13 + s21 * 136657#64
  let s14 := s14 - s21 * 683901#64
  let s8 := s8 + s20 * 666643#64
  let s9 := s9 + s20 * 470296#64
  let s10 := s10 + s20 * 654183#64
  let s11 := s11 - s20 * 997805#64
  let s12 := s12 + s20 * 136657#64
  let s13 := s13 - s20 * 683901#64
  let s7 := s7 + s19 * 666643#64
  let s8 := s8 + s19 * 470296#64
  let s9 := s9 + s19 * 654183#64
  let s10 := s10 - s19 * 997805#64
  let s11 := s11 + s19 * 136657#64
  let s12 := s12 - s19 * 683901#64
  let s6 := s6 + s18 * 666643#64
  let s7 := s7 + s18 * 470296#64
  let s8 := s8 + s18 * 654183#64
  let s9 := s9 - s18 * 997805#64
  let s10 := s10 + s18 * 136657#64
  let s11 := s11 - s18 * 683901#64
  let carry6 := (s6 + 1048576#64).sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry8 := (s8 + 1048576#64).sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry10 := (s10 + 1048576#64).sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  let carry12 := (s12 + 1048576#64).sshiftRight 21
  let s13 := s13 + carry12
  let s12 := s12 - carry12 <<< 21
  let carry14 := (s14 + 1048576#64).sshiftRight 21
  let s15 := s15 + carry14
  let s14 := s14 - carry14 <<< 21
  let carry16 := (s16 + 1048576#64).sshiftRight 21
  let s17 := s17 + carry16
  let s16 := s16 - carry16 <<< 21
  let carry7 := (s7 + 1048576#64).sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry9 := (s9 + 1048576#64).sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry11 := (s11 + 1048576#64).sshiftRight 21
  let s12 := s12 + carry11
  let s11 := s11 - carry11 <<< 21
  let carry13 := (s13 + 1048576#64).sshiftRight 21
  let s14 := s14 + carry13
  let s13 := s13 - carry13 <<< 21
  let carry15 := (s15 + 1048576#64).sshiftRight 21
  let s16 := s16 + carry15
  let s15 := s15 - carry15 <<< 21
  let s5 := s5 + s17 * 666643#64
  let s6 := s6 + s17 * 470296#64
  let s7 := s7 + s17 * 654183#64
  let s8 := s8 - s17 * 997805#64
  let s9 := s9 + s17 * 136657#64
  let s10 := s10 - s17 * 683901#64
  let s4 := s4 + s16 * 666643#64
  let s5 := s5 + s16 * 470296#64
  let s6 := s6 + s16 * 654183#64
  let s7 := s7 - s16 * 997805#64
  let s8 := s8 + s16 * 136657#64
  let s9 := s9 - s16 * 683901#64
  let s3 := s3 + s15 * 666643#64
  let s4 := s4 + s15 * 470296#64
  let s5 := s5 + s15 * 654183#64
  let s6 := s6 - s15 * 997805#64
  let s7 := s7 + s15 * 136657#64
  let s8 := s8 - s15 * 683901#64
  let s2 := s2 + s14 * 666643#64
  let s3 := s3 + s14 * 470296#64
  let s4 := s4 + s14 * 654183#64
  let s5 := s5 - s14 * 997805#64
  let s6 := s6 + s14 * 136657#64
  let s7 := s7 - s14 * 683901#64
  let s1 := s1 + s13 * 666643#64
  let s2 := s2 + s13 * 470296#64
  let s3 := s3 + s13 * 654183#64
  let s4 := s4 - s13 * 997805#64
  let s5 := s5 + s13 * 136657#64
  let s6 := s6 - s13 * 683901#64
  let s0 := s0 + s12 * 666643#64
  let s1 := s1 + s12 * 470296#64
  let s2 := s2 + s12 * 654183#64
  let s3 := s3 - s12 * 997805#64
  let s4 := s4 + s12 * 136657#64
  let s5 := s5 - s12 * 683901#64
  let s12 := 0#64
  let carry0 := (s0 + 1048576#64).sshiftRight 21
  let s1 := s1 + carry0
  let s0 := s0 - carry0 <<< 21
  let carry2 := (s2 + 1048576#64).sshiftRight 21
  let s3 := s3 + carry2
  let s2 := s2 - carry2 <<< 21
  let carry4 := (s4 + 1048576#64).sshiftRight 21
  let s5 := s5 + carry4
  let s4 := s4 - carry4 <<< 21
  let carry6 := (s6 + 1048576#64).sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry8 := (s8 + 1048576#64).sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry10 := (s10 + 1048576#64).sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  let carry1 := (s1 + 1048576#64).sshiftRight 21
  let s2 := s2 + carry1
  let s1 := s1 - carry1 <<< 21
  let carry3 := (s3 + 1048576#64).sshiftRight 21
  let s4 := s4 + carry3
  let s3 := s3 - carry3 <<< 21
  let carry5 := (s5 + 1048576#64).sshiftRight 21
  let s6 := s6 + carry5
  let s5 := s5 - carry5 <<< 21
  let carry7 := (s7 + 1048576#64).sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry9 := (s9 + 1048576#64).sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry11 := (s11 + 1048576#64).sshiftRight 21
  let s12 := s12 + carry11
  let s11 := s11 - carry11 <<< 21
  let s0 := s0 + s12 * 666643#64
  let s1 := s1 + s12 * 470296#64
  let s2 := s2 + s12 * 654183#64
  let s3 := s3 - s12 * 997805#64
  let s4 := s4 + s12 * 136657#64
  let s5 := s5 - s12 * 683901#64
  let s12 := 0#64
  let carry0 := s0.sshiftRight 21
  let s1 := s1 + carry0
  let s0 := s0 - carry0 <<< 21
  let carry1 := s1.sshiftRight 21
  let s2 := s2 + carry1
  let s1 := s1 - carry1 <<< 21
  let carry2 := s2.sshiftRight 21
  let s3 := s3 + carry2
  let s2 := s2 - carry2 <<< 21
  let carry3 := s3.sshiftRight 21
  let s4 := s4 + carry3
  let s3 := s3 - carry3 <<< 21
  let carry4 := s4.sshiftRight 21
  let s5 := s5 + carry4
  let s4 := s4 - carry4 <<< 21
  let carry5 := s5.sshiftRight 21
  let s6 := s6 + carry5
  let s5 := s5 - carry5 <<< 21
  let carry6 := s6.sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry7 := s7.sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry8 := s8.sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry9 := s9.sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry10 := s10.sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  let carry11 := s11.sshiftRight 21
  let s12 := s12 + carry11
  let s11 := s11 - carry11 <<< 21
  let s0 := s0 + s12 * 666643#64
  let s1 := s1 + s12 * 470296#64
  let s2 := s2 + s12 * 654183#64
  let s3 := s3 - s12 * 997805#64
  let s4 := s4 + s12 * 136657#64
  let s5 := s5 - s12 * 683901#64
  let carry0 := s0.sshiftRight 21
  let s1 := s1 + carry0
  let s0 := s0 - carry0 <<< 21
  let carry1 := s1.sshiftRight 21
  let s2 := s2 + carry1
  let s1 := s1 - carry1 <<< 21
  let carry2 := s2.sshiftRight 21
  let s3 := s3 + carry2
  let s2 := s2 - carry2 <<< 21
  let carry3 := s3.sshiftRight 21
  let s4 := s4 + carry3
  let s3 := s3 - carry3 <<< 21
  let carry4 := s4.sshiftRight 21
  let s5 := s5 + carry4
  let s4 := s4 - carry4 <<< 21
  let carry5 := s5.sshiftRight 21
  let s6 := s6 + carry5
  let s5 := s5 - carry5 <<< 21
  let carry6 := s6.sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry7 := s7.sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry8 := s8.sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry9 := s9.sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry10 := s10.sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  -- Pack the results into out
  let out0 := s0 ||| s1 <<< 21 ||| s2 <<< 42 ||| s3 <<< 63
  let out1 := s3 >>> 1 ||| s4 <<< 20 ||| s5 <<< 41 ||| s6 <<< 62
  let out2 := s6 >>> 2 ||| s7 <<< 19 ||| s8 <<< 40 ||| s9 <<< 61
  let out3 := s9 >>> 3 ||| s10 <<< 18 ||| s11 <<< 39
  out3 ++ (out2 ++ (out1 ++ out0))

end

/-! ## Staged for Common -/

/-- A splice above a splice of `x`, right where `x` ends: one splice of both. -/
public theorem spliceBits_spliceBits_append {n a b : Nat} (bytes : BitVec n) (off : Nat)
    (x : BitVec a) (y : BitVec b) :
    Memory.spliceBits (Memory.spliceBits bytes off x) (off + a) y =
      Memory.spliceBits bytes off (y ++ x) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append]
  grind

/-- Two adjacent stores are one store of both values, the later one above. -/
public theorem MemoryState.storeAt_storeAt_add {m : MemoryState} {p : Pointer} {x : BitVec a}
    {y : BitVec b} (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k)) (ha : a = 8 * k)
    (hk : k < 2 ^ 64) :
    (m.storeAt p x).storeAt (p.add (BitVec.ofNat 64 k)) y = m.storeAt p (y ++ x) := by
  cases hb : m[p.id]? with
  | none =>
    have hn :
      ∀ {m' : MemoryState} {q : Pointer} {w} {z : BitVec w},
        m'[q.id]? = none → m'.storeAt q z = m' := by
      intro m' q w z hq
      simp [MemoryState.storeAt, hq]
    rw [hn hb, hn (q := p.add _) hb, hn hb]
  | some blk =>
    rw [MemoryState.getElem?_eq] at hb
    have hid : (p.add (BitVec.ofNat 64 k)).id = p.id := rfl
    have hoff : (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + a := by
      rw [Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hk]
      omega
    simp only [MemoryState.storeAt, MemoryState.getElem?_eq, hb, hid,
      Std.ExtHashMap.getElem?_insert_self, hoff, spliceBits_spliceBits_append]
    congr 1
    apply Std.ExtHashMap.ext_getElem?
    intro j
    simp only [Std.ExtHashMap.getElem?_insert]
    split <;> rfl

/-- `x`, as a signed integer, lies in `[lo, hi]`. -/
public def Bnd (x : BitVec 64) (lo hi : Int) : Prop :=
  lo ≤ x.toInt ∧ x.toInt ≤ hi

namespace Bnd

/-! Interval lemmas. Their arguments are explicit and their last hypothesis is a closed side
condition, so the `bound` prover below applies them with `decide`. -/

public theorem any (x : BitVec 64) : Bnd x (-9223372036854775808) 9223372036854775807 := by
  have := BitVec.le_toInt x
  have := @BitVec.toInt_lt 64 x
  simp only [Nat.add_one_sub_one, Int.reduceNeg] at *
  exact ⟨by omega, by omega⟩

public theorem lit (c : BitVec 64) (lo hi : Int) (h : lo = c.toInt ∧ hi = c.toInt) : Bnd c lo hi :=
  ⟨by omega, by omega⟩

public theorem toInt_eq_toNat {x : BitVec 64} {a b : Int} (hx : Bnd x a b) (ha : 0 ≤ a) :
    x.toInt = x.toNat := by
  have := hx.1
  rw [BitVec.toInt_eq_toNat_cond] at *
  split <;> omega

public theorem saddOverflow (x y : BitVec 64) (a b c d : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : -9223372036854775808 ≤ a + c ∧ b + d ≤ 9223372036854775807) :
    x.saddOverflow y = false := by
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  simp only [BitVec.saddOverflow]
  simp
  omega

public theorem ssubOverflow (x y : BitVec 64) (a b c d : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : -9223372036854775808 ≤ a - d ∧ b - c ≤ 9223372036854775807) :
    x.ssubOverflow y = false := by
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  simp only [BitVec.ssubOverflow]
  simp
  omega

theorem mul_range {t a b k lo hi : Int} (h1 : a ≤ t) (h2 : t ≤ b)
    (h : lo ≤ a * k ∧ lo ≤ b * k ∧ a * k ≤ hi ∧ b * k ≤ hi) : lo ≤ t * k ∧ t * k ≤ hi := by
  rcases Int.le_total 0 k with hk | hk
  · have := Int.mul_le_mul_of_nonneg_right h1 hk
    have := Int.mul_le_mul_of_nonneg_right h2 hk
    omega
  · have := Int.mul_le_mul_of_nonpos_right h1 hk
    have := Int.mul_le_mul_of_nonpos_right h2 hk
    omega

public theorem smulOverflow (x : BitVec 64) (a b : Int) (hx : Bnd x a b) (c : BitVec 64)
    (h :
      -9223372036854775808 ≤ a * c.toInt ∧
        -9223372036854775808 ≤ b * c.toInt ∧
        a * c.toInt ≤ 9223372036854775807 ∧ b * c.toInt ≤ 9223372036854775807) :
    x.smulOverflow c = false := by
  have := mul_range (t := x.toInt) hx.1 hx.2 h
  simp only [BitVec.smulOverflow]
  simp
  omega

public theorem uaddOverflow (x y : BitVec 64) (a b c d : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : 0 ≤ a ∧ 0 ≤ c ∧ b + d < 18446744073709551616) : x.uaddOverflow y = false := by
  have := toInt_eq_toNat hx h.1; have := toInt_eq_toNat hy h.2.1
  have := hx.2; have := hy.2
  simp only [BitVec.uaddOverflow]
  simp
  omega

public theorem umulOverflow (x : BitVec 64) (a b : Int) (hx : Bnd x a b) (c : BitVec 64)
    (h : 0 ≤ a ∧ 0 ≤ c.toInt ∧ b * c.toInt < 18446744073709551616) : x.umulOverflow c = false := by
  have h1 := toInt_eq_toNat hx h.1
  have h2 : c.toInt = c.toNat :=
    toInt_eq_toNat (a := c.toInt) (b := c.toInt) ⟨Int.le_refl _, Int.le_refl _⟩ h.2.1
  have := Int.mul_le_mul_of_nonneg_right hx.2 h.2.1
  have hb := h.2.2
  rw [h1, h2, ← Int.natCast_mul] at this
  rw [h2] at hb
  simp only [BitVec.umulOverflow]
  simp
  omega

public theorem add (x y : BitVec 64) (a b c d lo hi : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : lo = a + c ∧ hi = b + d ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x + y) lo hi := by
  have hov := saddOverflow x y a b c d hx hy (by omega)
  rw [Bnd, BitVec.toInt_add_of_not_saddOverflow (by simp [hov])]
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  omega

public theorem sub (x y : BitVec 64) (a b c d lo hi : Int) (hx : Bnd x a b) (hy : Bnd y c d)
    (h : lo = a - d ∧ hi = b - c ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x - y) lo hi := by
  have hov := ssubOverflow x y a b c d hx hy (by omega)
  rw [Bnd, BitVec.toInt_sub_of_not_ssubOverflow (by simp [hov])]
  have := hx.1; have := hx.2; have := hy.1; have := hy.2
  omega

public theorem mul (x : BitVec 64) (a b lo hi : Int) (hx : Bnd x a b) (c : BitVec 64)
    (h :
      lo ≤ a * c.toInt ∧
        lo ≤ b * c.toInt ∧
        a * c.toInt ≤ hi ∧
        b * c.toInt ≤ hi ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd (x * c) lo hi := by
  have hov := smulOverflow x a b hx c (by omega)
  rw [Bnd, BitVec.toInt_mul_of_not_smulOverflow (by simp [hov])]
  exact mul_range hx.1 hx.2 ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1⟩

public theorem sshiftRight (x : BitVec 64) (a b lo hi : Int) (hx : Bnd x a b) (n : Nat)
    (h : lo = a / 2 ^ n ∧ hi = b / 2 ^ n) : Bnd (x.sshiftRight n) lo hi := by
  rw [Bnd, BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  have hp : (0 : Int) < ((2 ^ n : Nat) : Int) := by
    have := Nat.two_pow_pos n; omega
  push_cast at hp ⊢
  exact ⟨h.1 ▸ Int.ediv_le_ediv hp hx.1, h.2 ▸ Int.ediv_le_ediv hp hx.2⟩

theorem toInt_ushiftRight (x : BitVec 64) (hn : 0 < n) :
    (x >>> n).toInt = ((x.toNat / 2 ^ n : Nat) : Int) := by
  have : x.toNat / 2 ^ n < 2 ^ 63 := by
    have := x.isLt
    have h2n : 2 ^ 1 ≤ 2 ^ n := Nat.pow_le_pow_right (by decide) hn
    have := Nat.div_le_div_left h2n (by decide : 0 < 2 ^ 1) (a := x.toNat)
    omega
  rw [BitVec.toInt_eq_toNat_of_lt
      (by
        rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega),
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

public theorem ushiftRight (x : BitVec 64) (a b lo hi : Int) (hx : Bnd x a b) (n : Nat)
    (h : 0 ≤ a ∧ lo = a / 2 ^ n ∧ hi = b / 2 ^ n ∧ 0 < n) : Bnd (x >>> n) lo hi := by
  have h1 := toInt_eq_toNat hx h.1
  have hp : (0 : Int) < ((2 ^ n : Nat) : Int) := by
    have := Nat.two_pow_pos n; omega
  rw [Bnd, toInt_ushiftRight x h.2.2.2, Int.natCast_ediv]
  have hl := hx.1; have hh := hx.2
  rw [h1] at hl hh
  push_cast at hp ⊢
  exact ⟨h.2.1 ▸ Int.ediv_le_ediv hp hl, h.2.2.1 ▸ Int.ediv_le_ediv hp hh⟩

public theorem ushiftRight_any (x : BitVec 64) (lo hi : Int) (n : Nat)
    (h : lo = 0 ∧ hi = 18446744073709551615 / 2 ^ n ∧ 0 < n) : Bnd (x >>> n) lo hi := by
  have := x.isLt
  have hp : (0 : Int) < ((2 ^ n : Nat) : Int) := by
    have := Nat.two_pow_pos n; omega
  rw [Bnd, toInt_ushiftRight x h.2.2, Int.natCast_ediv]
  push_cast at hp ⊢
  exact ⟨h.1 ▸ Int.ediv_nonneg (by omega) (by omega), h.2.1 ▸ Int.ediv_le_ediv hp (by omega)⟩

public theorem and_nonneg (x c : BitVec 64) (lo hi : Int)
    (h : lo = 0 ∧ hi = c.toInt ∧ 0 ≤ c.toInt) : Bnd (x &&& c) lo hi := by
  have hle : (x &&& c).toNat ≤ c.toNat := by
    rw [BitVec.toNat_and]; exact Nat.and_le_right
  have hc' : 2 * c.toNat < 2 ^ 64 := by
    rw [BitVec.toInt_eq_toNat_cond] at h; split at h <;> omega
  have hc := toInt_eq_toNat (a := c.toInt) (b := c.toInt) ⟨Int.le_refl _, Int.le_refl _⟩ h.2.2
  rw [Bnd, BitVec.toInt_eq_toNat_of_lt (by omega)]
  omega

/-- `x` with its low 21 bits cleared: `x` rounded down to a multiple of `2^21`. -/
public theorem and_neg21 (x : BitVec 64) (a b lo hi : Int) (hx : Bnd x a b)
    (h : lo = a / 2097152 * 2097152 ∧ hi = b / 2097152 * 2097152) :
    Bnd (x &&& 18446744073707454464#64) lo hi := by
  have e : x &&& 18446744073707454464#64 = x - (x &&& 2097151#64) := by bv_decide
  have hy : (x &&& 2097151#64).toInt = x.toInt % 2097152 := by
    have hlt : (x &&& 2097151#64).toNat < 2097152 := by
      rw [BitVec.toNat_and]; exact Nat.lt_of_le_of_lt Nat.and_le_right (by decide)
    rw [BitVec.toInt_eq_toNat_of_lt (by omega), BitVec.toNat_and,
      show (2097151#64).toNat = 2 ^ 21 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
      BitVec.toInt_eq_toNat_cond]
    split <;> omega
  have hov : ¬x.ssubOverflow (x &&& 2097151#64) = true := by
    simp only [BitVec.ssubOverflow, hy]
    have := BitVec.le_toInt x; have := @BitVec.toInt_lt 64 x
    simp at *
    omega
  rw [Bnd, e, BitVec.toInt_sub_of_not_ssubOverflow hov, hy]
  have := hx.1; have := hx.2
  constructor <;> omega

/-- The rounded carry's residual `x - ((x + 2^20) & -2^21)` lies in `[-2^20, 2^20)`. -/
public theorem residual (x : BitVec 64) :
    Bnd (x - ((x + 1048576#64) &&& 18446744073707454464#64)) (-1048576) 1048575 := by
  have h1 : (-1048576#64).sle (x - ((x + 1048576#64) &&& 18446744073707454464#64)) := by bv_decide
  have h2 : (x - ((x + 1048576#64) &&& 18446744073707454464#64)).sle 1048575#64 := by bv_decide
  rw [BitVec.sle_iff_toInt_le] at h1 h2
  have e1 : (-1048576#64).toInt = -1048576 := by decide
  have e2 : (1048575#64).toInt = 1048575 := by decide
  exact ⟨by omega, by omega⟩

/-- `(x + y) - m` is `(x - m) + y`, for `x`'s rounded carry mask `m`. -/
public theorem residual_add (x y : BitVec 64) (c d lo hi : Int) (hy : Bnd y c d)
    (h :
      lo = -1048576 + c ∧ hi = 1048575 + d ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd ((x + y) - ((x + 1048576#64) &&& 18446744073707454464#64)) lo hi := by
  have := add _ _ _ _ _ _ lo hi (residual x) hy (by omega)
  rwa [BitVec.sub_eq_add_neg, BitVec.add_assoc, BitVec.add_comm y, ← BitVec.add_assoc, ←
    BitVec.sub_eq_add_neg]

/-- `residual_add` with the sum the other way round. -/
public theorem residual_add' (x y : BitVec 64) (c d lo hi : Int) (hy : Bnd y c d)
    (h :
      lo = -1048576 + c ∧ hi = 1048575 + d ∧ -9223372036854775808 ≤ lo ∧ hi ≤ 9223372036854775807) :
    Bnd ((y + x) - ((x + 1048576#64) &&& 18446744073707454464#64)) lo hi := by
  rw [BitVec.add_comm y]
  exact residual_add x y c d lo hi hy h

/-- Below `2^43`, the compiler's narrowed mask clears the same bits as `-2^21`. -/
theorem and_mask43_eq (y : BitVec 64) (h : y.toNat < 8796093022208) :
    y &&& 8796090925056#64 = y &&& 18446744073707454464#64 := by
  have hy : y.ult 8796093022208#64 := by simp [BitVec.ult, h]
  clear h
  bv_decide

/-- The rounded carry's residual, with the mask the compiler narrowed for `0 ≤ x < 2^42`. -/
public theorem residual_nonneg (x : BitVec 64) (a b : Int) (hx : Bnd x a b)
    (h : 0 ≤ a ∧ b < 4398046511104) :
    Bnd (x - ((x + 1048576#64) &&& 8796090925056#64)) (-1048576) 1048575 := by
  have := toInt_eq_toNat hx h.1
  have := hx.2
  rw [and_mask43_eq _
      (by
        rw [BitVec.toNat_add]; simp; omega)]
  exact residual x

/-- The rounded carry's mask is the carry shifted back. -/
public theorem and_neg_shift (x : BitVec 64) :
    x &&& 18446744073707454464#64 = x.sshiftRight 21 <<< 21 := by bv_decide

/-! Rewrites the bounds justify, used to state the compiled code in the C's terms. -/

/-- A logical shift of a non-negative value is the arithmetic one. -/
public theorem ushiftRight_eq (x : BitVec 64) (a b : Int) (hx : Bnd x a b) (n : Nat) (h : 0 ≤ a) :
    x >>> n = x.sshiftRight n := by
  have := toInt_eq_toNat hx h
  have := hx.1
  rw [BitVec.sshiftRight_eq_of_msb_false]
  rw [BitVec.msb_eq_false_iff_two_mul_lt]
  rw [BitVec.toInt_eq_toNat_cond] at *
  split at * <;> omega

/-- The compiler's narrowed mask, for `0 ≤ x < 2^43`, clears the low 21 bits. -/
public theorem and_mask43 (x : BitVec 64) (a b : Int) (hx : Bnd x a b)
    (h : 0 ≤ a ∧ b < 8796093022208) : x &&& 8796090925056#64 = x.sshiftRight 21 <<< 21 := by
  have := toInt_eq_toNat hx h.1
  have := hx.2
  rw [and_mask43_eq _ (by omega), and_neg_shift]

/-- `shl nsw` by `n` does not overflow on values of `64 - n` signed bits. -/
public theorem shl_sshiftRight (x : BitVec 64) (a b : Int) (hx : Bnd x a b) (n : Nat)
    (h : (n = 18 ∨ n = 19 ∨ n = 39 ∨ n = 40) ∧ -2 ^ (63 - n) ≤ a ∧ b < 2 ^ (63 - n)) :
    (x <<< n).sshiftRight n = x := by
  have := hx.1; have := hx.2
  rcases h with ⟨hn | hn | hn | hn, ha, hb⟩ <;> subst hn
  · have h0 : (-35184372088832#64).sle x := by
      rw [BitVec.sle_iff_toInt_le]; simp at *; omega
    have h1 : x.slt 35184372088832#64 := by
      rw [BitVec.slt_iff_toInt_lt]; simp at *; omega
    bv_decide
  · have h0 : (-17592186044416#64).sle x := by
      rw [BitVec.sle_iff_toInt_le]; simp at *; omega
    have h1 : x.slt 17592186044416#64 := by
      rw [BitVec.slt_iff_toInt_lt]; simp at *; omega
    bv_decide
  · have h0 : (-16777216#64).sle x := by
      rw [BitVec.sle_iff_toInt_le]; simp at *; omega
    have h1 : x.slt 16777216#64 := by
      rw [BitVec.slt_iff_toInt_lt]; simp at *; omega
    bv_decide
  · have h0 : (-8388608#64).sle x := by
      rw [BitVec.sle_iff_toInt_le]; simp at *; omega
    have h1 : x.slt 8388608#64 := by
      rw [BitVec.slt_iff_toInt_lt]; simp at *; omega
    bv_decide

/-- A limb's low 21 bits are the limb less its shifted carry. -/
public theorem and_mask_sub (x : BitVec 64) : x &&& 2097151#64 = x - x.sshiftRight 21 <<< 21 := by
  bv_decide

/-- `llvm.fshl` on two words, as the C's `(y >> (64 - k)) | (x << k)`. -/
public theorem fshl_eq (x y : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7) :
    BitVec.extractLsb' 64 64 ((x ++ y) <<< k) = y >>> (64 - k) ||| x <<< k := by
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

end Bnd

/-! ## Bounds automation (staged) -/

public meta section

open Lean Meta Elab Tactic

namespace Bnd

/-- A `BitVec 64` literal's value as a signed integer. -/
def litVal? (e : Expr) : MetaM (Option Int) := do
  let some ⟨w, v⟩ ← getBitVecValue? e | return none
  return if w == 64 then some v.toInt else none

/-- The context's bounds: `x ↦ (lo, hi, h)` for each `h : Bnd x lo hi`. -/
def atoms : MetaM (Std.HashMap Expr (Int × Int × Expr)) := do
  let mut m := {}
  for d in ← getLCtx do
    if d.isImplementationDetail then
      continue
    let_expr Bnd x lo hi := ← instantiateMVars d.type | continue
    let some lo ← getIntValue? lo | continue
    let some hi ← getIntValue? hi | continue
    m := m.insert x (lo, hi, d.toExpr)
  return m

/-- `f h` for `f`'s last hypothesis `h`, a closed side condition, by `decide`. -/
def withSide (f : Expr) : MetaM Expr := do
  let .forallE _ p _ _ ← whnf (← inferType f) | throwError "no side condition"
  return mkApp f (← mkDecideProof p)

def int (i : Int) : Expr :=
  toExpr i

def lo64 : Int :=
  -9223372036854775808

def hi64 : Int :=
  9223372036854775807

/-- The operand and amount of a logical right shift by a literal. -/
def ushr? (e : Expr) : Option (Expr × Nat) :=
  match_expr e with
  | HShiftRight.hShiftRight _ _ _ _ x n => n.nat?.map (x, ·)
  | BitVec.ushiftRight _ x n => n.nat?.map (x, ·)
  | _ => none

/-- Bounds `(lo, hi)` of `e : BitVec 64` as a signed integer, and a proof of `Bnd e lo hi`: by the
operation, from the bounds of the operands, down to literals and the context's `Bnd` facts. -/
partial def bound (atoms : Std.HashMap Expr (Int × Int × Expr)) (e : Expr) :
    MetaM (Int × Int × Expr) := do
  if let some r := atoms[e]? then
    return r
  let any := return (lo64, hi64, mkApp (mkConst ``Bnd.any) e)
  if let some v← litVal? e then
    return (v, v, ← withSide (mkAppN (mkConst ``Bnd.lit) #[e, int v, int v]))
  if let some (x, n) := ushr? e then
    if n == 0 then
      return ← any
    let (a, b, hx) ← bound atoms x
    if 0 ≤ a then
      let lo := a / 2 ^ n
      let hi := b / 2 ^ n
      return (lo, hi,
          ←
            withSide
                (mkAppN (mkConst ``Bnd.ushiftRight)
                  #[x, int a, int b, int lo, int hi, hx, mkNatLit n]))
    let hi : Int := 18446744073709551615 / 2 ^ n
    return (0, hi,
        ← withSide (mkAppN (mkConst ``Bnd.ushiftRight_any) #[x, int 0, int hi, mkNatLit n]))
  match_expr e with
  | HAdd.hAdd _ _ _ _ x y =>
    let (a, b, hx) ← bound atoms x
    let (c, d, hy) ← bound atoms y
    let lo := a + c
    let hi := b + d
    unless lo64 ≤ lo && hi ≤ hi64 do
      return ← any
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd.add)
                #[x, y, int a, int b, int c, int d, int lo, int hi, hx, hy]))
  | HSub.hSub _ _ _ _ x y =>
    -- a rounded carry's residual: `x - m`, `(x + y) - m` or `(y + x) - m`, `m` the carry's mask
    let mask? : Option (Expr × Expr × Expr) :=
      match_expr y with
      | HAnd.hAnd _ _ _ _ s m =>
        match_expr s with
        | HAdd.hAdd _ _ _ _ x' k => some (x', k, m)
        | _ => none
      | _ => none
    if let some (x', k, m) := mask? then
      if (← litVal? k) == some 1048576 then
        let mv ← litVal? m
        if mv == some (-2097152) then
          if x == x' then
            return (-1048576, 1048575, mkApp (mkConst ``Bnd.residual) x')
          let parts? : Option (Expr × Expr) :=
            match_expr x with
            | HAdd.hAdd _ _ _ _ p q => some (p, q)
            | _ => none
          if let some (p, q) := parts? then
            for (u, w, lem) in [(p, q, ``Bnd.residual_add), (q, p, ``Bnd.residual_add')] do
              if u == x' then
                let (c, d, hw) ← bound atoms w
                let lo := -1048576 + c
                let hi := 1048575 + d
                if lo64 ≤ lo && hi ≤ hi64 then
                  return (lo, hi,
                      ← withSide (mkAppN (mkConst lem) #[x', w, int c, int d, int lo, int hi, hw]))
        if mv == some 8796090925056 && x == x' then
          let (a, b, hx) ← bound atoms x
          if 0 ≤ a && b < 4398046511104 then
            return (-1048576, 1048575,
                ← withSide (mkAppN (mkConst ``Bnd.residual_nonneg) #[x, int a, int b, hx]))
    let (a, b, hx) ← bound atoms x
    let (c, d, hy) ← bound atoms y
    let lo := a - d
    let hi := b - c
    unless lo64 ≤ lo && hi ≤ hi64 do
      return ← any
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd.sub)
                #[x, y, int a, int b, int c, int d, int lo, int hi, hx, hy]))
  | HMul.hMul _ _ _ _ x c =>
    let some k ← litVal? c | any
    let (a, b, hx) ← bound atoms x
    let lo := min (a * k) (b * k)
    let hi := max (a * k) (b * k)
    unless lo64 ≤ lo && hi ≤ hi64 do
      return ← any
    return (lo, hi,
        ← withSide (mkAppN (mkConst ``Bnd.mul) #[x, int a, int b, int lo, int hi, hx, c]))
  | BitVec.sshiftRight _ x n =>
    let some n := n.nat? | any
    let (a, b, hx) ← bound atoms x
    let lo := a / 2 ^ n
    let hi := b / 2 ^ n
    return (lo, hi,
        ←
          withSide
              (mkAppN (mkConst ``Bnd.sshiftRight)
                #[x, int a, int b, int lo, int hi, hx, mkNatLit n]))
  | HAnd.hAnd _ _ _ _ x c =>
    let some k ← litVal? c | any
    if 0 ≤ k then
      return (0, k, ← withSide (mkAppN (mkConst ``Bnd.and_nonneg) #[x, c, int 0, int k]))
    if k == -2097152 then
      let (a, b, hx) ← bound atoms x
      let lo := a / 2097152 * 2097152
      let hi := b / 2097152 * 2097152
      return (lo, hi,
          ← withSide (mkAppN (mkConst ``Bnd.and_neg21) #[x, int a, int b, int lo, int hi, hx]))
    any
  | _ =>
    any

/-- The flag test rewritten to `false` by `lem` applied to `args`, if its side condition holds. -/
def flagFalse (lem : Name) (args : Array Expr) : SimpM Simp.Step := do
  return .done { expr := mkConst ``Bool.false, proof? := ← withSide (mkAppN (mkConst lem) args) }

end Bnd

open Bnd in
/-- `add nsw`: no signed overflow, by the operands' bounds. -/
simproc_decl nswAdd (BitVec.saddOverflow _ _) := fun e => do
  let_expr BitVec.saddOverflow _ x y := e | return .continue
  let as ← atoms
  let (a, b, hx) ← bound as x
  let (c, d, hy) ← bound as y
  unless lo64 ≤ a + c && b + d ≤ hi64 do
    return .continue
  flagFalse ``Bnd.saddOverflow #[x, y, int a, int b, int c, int d, hx, hy]

open Bnd in
/-- `sub nsw`: no signed overflow, by the operands' bounds. -/
simproc_decl nswSub (BitVec.ssubOverflow _ _) := fun e => do
  let_expr BitVec.ssubOverflow _ x y := e | return .continue
  let as ← atoms
  let (a, b, hx) ← bound as x
  let (c, d, hy) ← bound as y
  unless lo64 ≤ a - d && b - c ≤ hi64 do
    return .continue
  flagFalse ``Bnd.ssubOverflow #[x, y, int a, int b, int c, int d, hx, hy]

open Bnd in
/-- `mul nsw` by a literal: no signed overflow, by the operand's bounds. -/
simproc_decl nswMul (BitVec.smulOverflow _ _) := fun e => do
  let_expr BitVec.smulOverflow _ x c := e | return .continue
  let some k ← litVal? c | return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless lo64 ≤ a * k && lo64 ≤ b * k && a * k ≤ hi64 && b * k ≤ hi64 do
    return .continue
  flagFalse ``Bnd.smulOverflow #[x, int a, int b, hx, c]

open Bnd in
/-- `add nuw`: no unsigned overflow, by the operands' bounds. -/
simproc_decl nuwAdd (BitVec.uaddOverflow _ _) := fun e => do
  let_expr BitVec.uaddOverflow _ x y := e | return .continue
  let as ← atoms
  let (a, b, hx) ← bound as x
  let (c, d, hy) ← bound as y
  unless 0 ≤ a && 0 ≤ c && b + d < 18446744073709551616 do
    return .continue
  flagFalse ``Bnd.uaddOverflow #[x, y, int a, int b, int c, int d, hx, hy]

open Bnd in
/-- `mul nuw` by a literal: no unsigned overflow, by the operand's bounds. -/
simproc_decl nuwMul (BitVec.umulOverflow _ _) := fun e => do
  let_expr BitVec.umulOverflow _ x c := e | return .continue
  let some k ← litVal? c | return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless 0 ≤ a && 0 ≤ k && b * k < 18446744073709551616 do
    return .continue
  flagFalse ``Bnd.umulOverflow #[x, int a, int b, hx, c]

open Bnd in
/-- `shl nsw`: shifting back recovers the operand, by its bounds. -/
simproc_decl nswShl (BitVec.sshiftRight _ _) := fun e => do
  let_expr BitVec.sshiftRight _ s n := e | return .continue
  let_expr HShiftLeft.hShiftLeft _ _ _ _ x n' := s | return .continue
  let some n := n.nat? | return .continue
  unless n'.nat? == some n do
    return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless (n == 18 || n == 19 || n == 39 || n == 40) && -2 ^ (63 - n) ≤ a && b < 2 ^ (63 - n) do
    return .continue
  return .done
      { expr := x,
        proof? :=
          ← withSide (mkAppN (mkConst ``Bnd.shl_sshiftRight) #[x, int a, int b, hx, mkNatLit n]) }

open Bnd in
/-- A logical right shift of a non-negative value, as the arithmetic one. -/
simproc_decl lshrNonneg (_ >>> _) := fun e => do
  let some (x, n) := ushr? e | return .continue
  unless (← inferType x).isAppOf ``BitVec do
    return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless 0 ≤ a do
    return .continue
  return .done
      { expr := ← mkAppM ``BitVec.sshiftRight #[x, mkNatLit n],
        proof? :=
          ← withSide (mkAppN (mkConst ``Bnd.ushiftRight_eq) #[x, int a, int b, hx, mkNatLit n]) }

open Bnd in
/-- The compiler's narrowed carry mask, as the cleared low bits. -/
simproc_decl andMask43 (_ &&& _) := fun e => do
  let_expr HAnd.hAnd _ _ _ _ x c := e | return .continue
  unless (← litVal? c) == some 8796090925056 do
    return .continue
  let (a, b, hx) ← bound (← atoms) x
  unless 0 ≤ a && b < 8796093022208 do
    return .continue
  return .done
      {
        expr :=
          ←
            mkAppM ``HShiftLeft.hShiftLeft
                #[← mkAppM ``BitVec.sshiftRight #[x, mkNatLit 21], mkNatLit 21],
        proof? := ← withSide (mkAppN (mkConst ``Bnd.and_mask43) #[x, int a, int b, hx]) }

/-- `bnd x`: `hbx : Bnd x lo hi`, from `x`'s equation `hx : x = e` and `e`'s bounds. -/
elab "bnd " x:ident : tactic =>
  withMainContext do
    let xe ← getFVarFromUserName x.getId
    let some hx ←
      (← getLCtx).findDeclRevM? fun d => do
          let some (_, l, _) := (← instantiateMVars d.type).consumeMData.eq? | return none
          return if l == xe then some d else none | throwError "bnd: no equation for {x}"
    let some (_, _, rhs) := (← instantiateMVars hx.type).consumeMData.eq? | throwError "bnd"
    let (lo, hi, pf) ← Bnd.bound (← Bnd.atoms) rhs
    let motive :=
      mkLambda `t .default (mkApp (mkConst ``BitVec) (mkNatLit 64))
        (mkApp3 (mkConst ``Bnd) (.bvar 0) (Bnd.int lo) (Bnd.int hi))
    let pf ← mkEqNDRec motive pf (← mkEqSymm hx.toExpr)
    let (_, g) ←
      (←
            (← getMainGoal).assert (x.getId.appendBefore "hb")
                (mkApp3 (mkConst ``Bnd) xe (Bnd.int lo) (Bnd.int hi)) pf).intro1P
    replaceMainGoal [g]

/-- `bridge h₁ …`: an equation `x = e` between a compiled value and the C's expression `e`, by
unfolding `x` and its neighbours' definitions `hᵢ`, rewriting masks as shifted carries, and closing the
ring identity left by `grind` over the equation's variables alone. -/
syntax (name := bridge) "bridge" (ppSpace ident)* : tactic

@[tactic bridge]
def evalBridge : Tactic := fun stx =>
  withMainContext do
    let mut thms : SimpTheorems := {}
    for h in stx[1].getArgs do
      let e ← getFVarFromUserName h.getId
      thms ← thms.add (.fvar e.fvarId!) #[] e
    for n in [``Bnd.and_neg_shift, ``Bnd.and_mask_sub, ``eq_self_iff_true] do
      thms ← thms.addConst n
    let ctx ← Simp.mkContext (simpTheorems := #[thms]) (congrTheorems := ← getSimpCongrTheorems)
    let mut procs : Simp.Simprocs := {}
    for p in [``lshrNonneg, ``andMask43] do
      procs ← procs.add p (post := true)
    match ← simpTarget (← getMainGoal) ctx #[procs] with
    | (none, _) =>
      replaceMainGoal []
    | (some g, _) =>
      replaceMainGoal [← g.cleanup (indirectProps := false)]
      evalTactic (← `(tactic| grind))

/-- `keep_eqs`: clear every hypothesis but the named values' equations `x = e`, so `subst_vars`
substitutes them into the goal alone. -/
elab "keep_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in (← getLCtx).decls.toArray.reverse do
      let some d := d | continue
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      let prop ← isProp ty
      let keep :=
        match ty.consumeMData.eq? with
        | some (_, l, _) => l.isFVar
        | none => !prop
      unless keep do
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

/-- `bridge_bv h₁ …`: an equation between packed words, by unfolding the `hᵢ` and `bv_decide` over
the equation's variables alone. -/
elab "bridge_bv" hs:(ppSpace ident)* : tactic =>
  withMainContext do
    let mut thms : SimpTheorems := {}
    for h in hs do
      let e ← getFVarFromUserName h.getId
      thms ← thms.add (.fvar e.fvarId!) #[] e
    let ctx ← Simp.mkContext (simpTheorems := #[thms]) (congrTheorems := ← getSimpCongrTheorems)
    let some g := (← simpTarget (← getMainGoal) ctx).1 | replaceMainGoal []
    replaceMainGoal [← g.cleanup (indirectProps := false)]
    evalTactic (← `(tactic| bv_decide))

end

/-! ## Proof -/

section Proof

/-- The constants the code reads after loading the input. -/
abbrev fd_curve25519_scalar_reduce.Consts (E : ⟪fd_curve25519_scalar_reduce.Γ⟫) : Prop :=
  E ⊨ [%0 := 16#64, %1 := 40#64, %2 := 2097151#64, %3 := 21#64, %4 := 42#64, %5 := 1#64, %6 :=
    20#64, %7 := 41#64, %8 := 2#64, %9 := 19#64, %10 := 3#64, %11 := 18#64, %12 := 39#64, %13 :=
    4#64, %14 := 17#64, %15 := 38#64, %16 := 5#64, %17 := 37#64, %18 := 6#64, %19 := 15#64, %20 :=
    36#64, %21 := 7#64, %22 := 14#64, %23 := 35#64, %24 := 666643#64, %25 := 470296#64, %26 :=
    654183#64, %27 := 18446744073708553811#64, %28 := 136657#64, %29 := 18446744073708867715#64,
    %30 := 1048576#64, %31 := 8796090925056#64, %32 := 18446744073707454464#64, %33 :=
    4398044413952#64, %34 := 9223367638808264704#64, %35 := 63#64, %36 := 1048575#64, %37 :=
    2199022206976#64, %38 := 4611683819404132352#64, %39 := 62#64, %40 := 524287#64, %41 :=
    1099511103488#64, %42 := 2305841909702066176#64, %43 := 61#64, %44 := 262143#64, %45 :=
    549755551744#64]

/-! `^bb0` in thirteen runs. Each `runK` steps the instructions from `%K` of any block whose body
from there on is `^bb0`'s (`hbody`), in continuation form: `hK` takes the env with the run's values
named (`sK_n` is C's `sK` after its `n`-th assignment, `tN` the compiled code's `%N`), their C forms
and their bounds. The input values' bounds (`hb…`) let the `nsw`/`nuw` flags be discharged. -/

/-- From `%0`: the constants, and the input words `in0 … in7`. -/
theorem fd_curve25519_scalar_reduce.run0 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 0 = fd_curve25519_scalar_reduce.entry.body.drop 0)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hin : Fits S.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (in0 in1 in2 in3 in4 in5 in6 in7 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%46 := in0, %48 := in1, %50 := in2, %52 := in3, %54 := in4, %56 := in5, %58 :=
              in6, %60 := in7]) →
          (hin0 : in0 = (S.mem.readAt inp 512).extractLsb' 0 64) →
          (hin1 : in1 = (S.mem.readAt inp 512).extractLsb' 64 64) →
          (hin2 : in2 = (S.mem.readAt inp 512).extractLsb' 128 64) →
          (hin3 : in3 = (S.mem.readAt inp 512).extractLsb' 192 64) →
          (hin4 : in4 = (S.mem.readAt inp 512).extractLsb' 256 64) →
          (hin5 : in5 = (S.mem.readAt inp 512).extractLsb' 320 64) →
          (hin6 : in6 = (S.mem.readAt inp 512).extractLsb' 384 64) →
          (hin7 : in7 = (S.mem.readAt inp 512).extractLsb' 448 64) →
          (blk.runBodyFrom E' 61 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 46 step_pure
  step_call using fd_ulong_load_8.call_eq with in0
  step_pure
  step_call using fd_ulong_load_8.call_eq with in1
  step_pure
  step_call using fd_ulong_load_8.call_eq with in2
  step_pure
  step_call using fd_ulong_load_8.call_eq with in3
  step_pure
  step_call using fd_ulong_load_8.call_eq with in4
  step_pure
  step_call using fd_ulong_load_8.call_eq with in5
  step_pure
  step_call using fd_ulong_load_8.call_eq with in6
  step_pure
  step_call using fd_ulong_load_8.call_eq with in7
  subst hS
  exact
    hK _ in0 in1 in2 in3 in4 in5 in6 in7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (hin0.trans (BitVec.setWidth_eq_extractLsb' (by decide))) hin1 hin2 hin3 hin4
      hin5 hin6 hin7

/-- From `%61`: `in0 … in7` unpacked into the limbs `s0 … s23`. -/
theorem fd_curve25519_scalar_reduce.run61 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 61 = fd_curve25519_scalar_reduce.entry.body.drop 61)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in0 in1 in2 in3 in4 in5 in6 in7 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%46 := in0, %48 := in1, %50 := in2, %52 := in3, %54 := in4, %56 := in5, %58 := in6,
        %60 := in7])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %73 := s6,
              %75 := s7, %77 := s8, %79 := s9, %81 := s10, %83 := s11, %85 := s12, %87 := s13,
              %89 := s14, %91 := s15, %93 := s16, %95 := s17, %97 := s18, %99 := s19, %101 := s20,
              %103 := s21, %105 := s22, %106 := s23]) →
          (hs0 : s0 = in0 &&& 2097151#64) →
          (hs1 : s1 = in0 >>> 21 &&& 2097151#64) →
          (hs2 : s2 = in0 >>> 42 &&& 2097151#64) →
          (hs3 : s3 = (in0 >>> 63 ||| in1 <<< 1) &&& 2097151#64) →
          (hs4 : s4 = in1 >>> 20 &&& 2097151#64) →
          (hs5 : s5 = in1 >>> 41 &&& 2097151#64) →
          (hs6 : s6 = (in1 >>> 62 ||| in2 <<< 2) &&& 2097151#64) →
          (hs7 : s7 = in2 >>> 19 &&& 2097151#64) →
          (hs8 : s8 = in2 >>> 40 &&& 2097151#64) →
          (hs9 : s9 = (in2 >>> 61 ||| in3 <<< 3) &&& 2097151#64) →
          (hs10 : s10 = in3 >>> 18 &&& 2097151#64) →
          (hs11 : s11 = in3 >>> 39 &&& 2097151#64) →
          (hs12 : s12 = (in3 >>> 60 ||| in4 <<< 4) &&& 2097151#64) →
          (hs13 : s13 = in4 >>> 17 &&& 2097151#64) →
          (hs14 : s14 = in4 >>> 38 &&& 2097151#64) →
          (hs15 : s15 = (in4 >>> 59 ||| in5 <<< 5) &&& 2097151#64) →
          (hs16 : s16 = in5 >>> 16 &&& 2097151#64) →
          (hs17 : s17 = in5 >>> 37 &&& 2097151#64) →
          (hs18 : s18 = (in5 >>> 58 ||| in6 <<< 6) &&& 2097151#64) →
          (hs19 : s19 = in6 >>> 15 &&& 2097151#64) →
          (hs20 : s20 = in6 >>> 36 &&& 2097151#64) →
          (hs21 : s21 = (in6 >>> 57 ||| in7 <<< 7) &&& 2097151#64) →
          (hs22 : s22 = in7 >>> 14 &&& 2097151#64) →
          (hs23 : s23 = in7 >>> 35) →
          (hbs0 : Bnd s0 0 2097151) →
          (hbs1 : Bnd s1 0 2097151) →
          (hbs2 : Bnd s2 0 2097151) →
          (hbs3 : Bnd s3 0 2097151) →
          (hbs4 : Bnd s4 0 2097151) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) →
          (hbs9 : Bnd s9 0 2097151) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) →
          (hbs15 : Bnd s15 0 2097151) →
          (hbs16 : Bnd s16 0 2097151) →
          (hbs17 : Bnd s17 0 2097151) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs19 : Bnd s19 0 2097151) →
          (hbs20 : Bnd s20 0 2097151) →
          (hbs21 : Bnd s21 0 2097151) →
          (hbs22 : Bnd s22 0 2097151) →
          (hbs23 : Bnd s23 0 536870911) → (blk.runBodyFrom E' 107 S >>= g) = K) :
    (blk.runBodyFrom E 61 S >>= g) = K := by
  -- long s0 = …
  step_pure with s0
  bnd s0
  step_pure
  -- long s1 = …
  step_pure with s1
  bnd s1
  step_pure
  -- long s2 = …
  step_pure with s2
  bnd s2
  step_pure
  -- long s3 = …
  step_pure with s3
  bnd s3
  step_pure
  -- long s4 = …
  step_pure with s4
  bnd s4
  step_pure
  -- long s5 = …
  step_pure with s5
  bnd s5
  step_pure
  -- long s6 = …
  step_pure with s6
  bnd s6
  step_pure
  -- long s7 = …
  step_pure with s7
  bnd s7
  step_pure
  -- long s8 = …
  step_pure with s8
  bnd s8
  step_pure
  -- long s9 = …
  step_pure with s9
  bnd s9
  step_pure
  -- long s10 = …
  step_pure with s10
  bnd s10
  step_pure
  -- long s11 = …
  step_pure with s11
  bnd s11
  step_pure
  -- long s12 = …
  step_pure with s12
  bnd s12
  step_pure
  -- long s13 = …
  step_pure with s13
  bnd s13
  step_pure
  -- long s14 = …
  step_pure with s14
  bnd s14
  step_pure
  -- long s15 = …
  step_pure with s15
  bnd s15
  step_pure
  -- long s16 = …
  step_pure with s16
  bnd s16
  step_pure
  -- long s17 = …
  step_pure with s17
  bnd s17
  step_pure
  -- long s18 = …
  step_pure with s18
  bnd s18
  step_pure
  -- long s19 = …
  step_pure with s19
  bnd s19
  step_pure
  -- long s20 = …
  step_pure with s20
  bnd s20
  step_pure
  -- long s21 = …
  step_pure with s21
  bnd s21
  step_pure
  -- long s22 = …
  step_pure with s22
  bnd s22
  -- long s23 = …
  step_pure with s23
  bnd s23
  exact
    hK _ s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs0 hs1 hs2 (by simp only [hs3, Bnd.fshl_eq _ _ 1 (by decide), Nat.reduceSub])
      hs4 hs5 (by simp only [hs6, Bnd.fshl_eq _ _ 2 (by decide), Nat.reduceSub]) hs7 hs8
      (by simp only [hs9, Bnd.fshl_eq _ _ 3 (by decide), Nat.reduceSub]) hs10 hs11
      (by simp only [hs12, Bnd.fshl_eq _ _ 4 (by decide), Nat.reduceSub]) hs13 hs14
      (by simp only [hs15, Bnd.fshl_eq _ _ 5 (by decide), Nat.reduceSub]) hs16 hs17
      (by simp only [hs18, Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]) hs19 hs20
      (by simp only [hs21, Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]) hs22 hs23 hbs0 hbs1 hbs2
      hbs3 hbs4 hbs5 hbs6 hbs7 hbs8 hbs9 hbs10 hbs11 hbs12 hbs13 hbs14 hbs15 hbs16 hbs17 hbs18 hbs19
      hbs20 hbs21 hbs22 hbs23

/-- From `%107`: the rows of `s23 … s18` into `s6 … s16`, begun. -/
theorem fd_curve25519_scalar_reduce.run107 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 107 = fd_curve25519_scalar_reduce.entry.body.drop 107)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %73 := s6, %75 := s7,
        %77 := s8, %79 := s9, %81 := s10, %83 := s11, %85 := s12, %87 := s13, %89 := s14, %91 :=
        s15, %93 := s16, %95 := s17, %97 := s18, %99 := s19, %101 := s20, %103 := s21, %105 := s22,
        %106 := s23])
    (hbs8 : Bnd s8 0 2097151) (hbs11 : Bnd s11 0 2097151) (hbs12 : Bnd s12 0 2097151)
    (hbs13 : Bnd s13 0 2097151) (hbs14 : Bnd s14 0 2097151) (hbs15 : Bnd s15 0 2097151)
    (hbs16 : Bnd s16 0 2097151) (hbs20 : Bnd s20 0 2097151) (hbs21 : Bnd s21 0 2097151)
    (hbs22 : Bnd s22 0 2097151) (hbs23 : Bnd s23 0 536870911)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s11_1 s12_1 s13_1 s14_1 s15_1 s16_1 t119 t120 t121 t122 s14_2 s15_2 t127 t128 t129 t130
          t131 s14_3 s8_1 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %73 := s6,
              %75 := s7, %79 := s9, %81 := s10, %95 := s17, %97 := s18, %99 := s19, %101 := s20,
              %108 := s11_1, %110 := s12_1, %112 := s13_1, %118 := s16_1, %119 := t119, %120 :=
              t120, %121 := t121, %122 := t122, %126 := s15_2, %127 := t127, %128 := t128, %129 :=
              t129, %130 := t130, %131 := t131, %133 := s14_3, %135 := s8_1]) →
          (hs11_1 : s11_1 = s11 + s23 * 666643#64) →
          (hs12_1 : s12_1 = s12 + s23 * 470296#64) →
          (hs13_1 : s13_1 = s13 + s23 * 654183#64) →
          (hs14_1 : s14_1 = s14 - s23 * 997805#64) →
          (hs15_1 : s15_1 = s15 + s23 * 136657#64) →
          (hs16_1 : s16_1 = s16 - s23 * 683901#64) →
          (ht119 : t119 = (s22 * 666643#64)) →
          (ht120 : t120 = (s22 * 470296#64)) →
          (ht121 : t121 = (s22 * 654183#64)) →
          (ht122 : t122 = (s22 * 18446744073708553811#64)) →
          (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) →
          (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) →
          (ht127 : t127 = (s21 * 666643#64)) →
          (ht128 : t128 = (s21 * 470296#64)) →
          (ht129 : t129 = (s21 * 654183#64)) →
          (ht130 : t130 = (s21 * 18446744073708553811#64)) →
          (ht131 : t131 = (s21 * 136657#64)) →
          (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) →
          (hs8_1 : s8_1 = s8 + s20 * 666643#64) →
          (hbs11_1 : Bnd s11_1 0 357901236818924) →
          (hbs12_1 : Bnd s12_1 0 252488244056807) →
          (hbs13_1 : Bnd s13_1 0 351211825267864) →
          (hbs14_1 : Bnd s14_1 (-535692479350355) 2097151) →
          (hbs15_1 : Bnd s15_1 0 73367170181678) →
          (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151) →
          (hbt119 : Bnd t119 0 1398051034093) →
          (hbt120 : Bnd t120 0 986281726696) →
          (hbt121 : Bnd t121 0 1371920532633) →
          (hbt122 : Bnd t122 (-2092547753555) 0) →
          (hbs14_2 : Bnd s14_2 (-535692479350355) 286592461358) →
          (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) →
          (hbt127 : Bnd t127 0 1398051034093) →
          (hbt128 : Bnd t128 0 986281726696) →
          (hbt129 : Bnd t129 0 1371920532633) →
          (hbt130 : Bnd t130 (-2092547753555) 0) →
          (hbt131 : Bnd t131 0 286590364207) →
          (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) →
          (hbs8_1 : Bnd s8_1 0 1398053131244) → (blk.runBodyFrom E' 136 S >>= g) = K) :
    (blk.runBodyFrom E 107 S >>= g) = K := by
  step_pure [nswMul, nuwMul]
  -- s11 += s23*666643L
  step_pure [nswAdd, nuwAdd] with s11_1
  bnd s11_1
  step_pure [nswMul, nuwMul]
  -- s12 += s23*470296L
  step_pure [nswAdd, nuwAdd] with s12_1
  bnd s12_1
  step_pure [nswMul, nuwMul]
  -- s13 += s23*654183L
  step_pure [nswAdd, nuwAdd] with s13_1
  bnd s13_1
  step_pure [nswMul]
  -- s14 -= s23*997805L
  step_pure [nswAdd] with s14_1
  bnd s14_1
  step_pure [nswMul, nuwMul]
  -- s15 += s23*136657L
  step_pure [nswAdd, nuwAdd] with s15_1
  bnd s15_1
  step_pure [nswMul]
  -- s16 -= s23*683901L
  step_pure [nswAdd] with s16_1
  bnd s16_1
  step_pure [nswMul, nuwMul] with t119
  bnd t119
  step_pure [nswMul, nuwMul] with t120
  bnd t120
  step_pure [nswMul, nuwMul] with t121
  bnd t121
  step_pure [nswMul] with t122
  bnd t122
  step_pure [nswMul, nuwMul]
  -- s14 += s22*136657L
  step_pure [nswAdd] with s14_2
  bnd s14_2
  step_pure [nswMul]
  -- s15 -= s22*683901L
  step_pure [nswAdd] with s15_2
  bnd s15_2
  step_pure [nswMul, nuwMul] with t127
  bnd t127
  step_pure [nswMul, nuwMul] with t128
  bnd t128
  step_pure [nswMul, nuwMul] with t129
  bnd t129
  step_pure [nswMul] with t130
  bnd t130
  step_pure [nswMul, nuwMul] with t131
  bnd t131
  step_pure [nswMul]
  -- s14 -= s21*683901L
  step_pure [nswAdd] with s14_3
  bnd s14_3
  step_pure [nswMul, nuwMul]
  -- s8 += s20*666643L
  step_pure [nswAdd, nuwAdd] with s8_1
  bnd s8_1
  exact
    hK _ s11_1 s12_1 s13_1 s14_1 s15_1 s16_1 t119 t120 t121 t122 s14_2 s15_2 t127 t128 t129 t130
      t131 s14_3 s8_1 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs11_1) (by bridge hs12_1) (by bridge hs13_1) (by bridge hs14_1)
      (by bridge hs15_1) (by bridge hs16_1) ht119 ht120 ht121 ht122 (by bridge hs14_2)
      (by bridge hs15_2) ht127 ht128 ht129 ht130 ht131 (by bridge hs14_3) (by bridge hs8_1) hbs11_1
      hbs12_1 hbs13_1 hbs14_1 hbs15_1 hbs16_1 hbt119 hbt120 hbt121 hbt122 hbs14_2 hbs15_2 hbt127
      hbt128 hbt129 hbt130 hbt131 hbs14_3 hbs8_1

/-- From `%136`: those rows finished, then `carry6` and `carry8`. -/
theorem fd_curve25519_scalar_reduce.run136 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 136 = fd_curve25519_scalar_reduce.entry.body.drop 136)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s9 s10 s17 s18 s19 s20 s11_1 s12_1 s13_1 s16_1 t119 t120 t121 t122
      s15_2 t127 t128 t129 t130 t131 s14_3 s8_1 s21 s22 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %73 := s6, %75 := s7,
        %79 := s9, %81 := s10, %95 := s17, %97 := s18, %99 := s19, %101 := s20, %108 := s11_1,
        %110 := s12_1, %112 := s13_1, %118 := s16_1, %119 := t119, %120 := t120, %121 := t121,
        %122 := t122, %126 := s15_2, %127 := t127, %128 := t128, %129 := t129, %130 := t130, %131 :=
        t131, %133 := s14_3, %135 := s8_1])
    (ht119 : t119 = (s22 * 666643#64)) (ht121 : t121 = (s22 * 654183#64))
    (ht127 : t127 = (s21 * 666643#64)) (ht128 : t128 = (s21 * 470296#64))
    (ht130 : t130 = (s21 * 18446744073708553811#64)) (hbs6 : Bnd s6 0 2097151)
    (hbs7 : Bnd s7 0 2097151) (hbs9 : Bnd s9 0 2097151) (hbs10 : Bnd s10 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbs21 : Bnd s21 0 2097151) (hbs22 : Bnd s22 0 2097151) (hbs12_1 : Bnd s12_1 0 252488244056807)
    (hbs8_1 : Bnd s8_1 0 1398053131244)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t138 t140 s7_1 s8_2 t147 s12_5 s6_1 s7_2 s8_3 s10_5 t166 carry6_1 s7_3 s6_2 carry8_1 s9_4
          s9_5 s8_4 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %95 := s17,
              %108 := s11_1, %112 := s13_1, %118 := s16_1, %120 := t120, %122 := t122, %126 :=
              s15_2, %129 := t129, %131 := t131, %133 := s14_3, %138 := t138, %140 := t140, %147 :=
              t147, %152 := s12_5, %165 := s10_5, %166 := t166, %169 := s7_3, %171 := s6_2, %178 :=
              s9_5, %180 := s8_4]) →
          (ht138 : t138 = (s20 * 18446744073708553811#64)) →
          (ht140 : t140 = (s20 * 18446744073708867715#64)) →
          (hs7_1 : s7_1 = s7 + s19 * 666643#64) →
          (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) →
          (ht147 : t147 = (s19 * 136657#64)) →
          (hs12_5 :
            s12_5 =
              (((s12_1 + s22 * 654183#64) - s21 * 997805#64) + s20 * 136657#64) - s19 * 683901#64) →
          (hs6_1 : s6_1 = s6 + s18 * 666643#64) →
          (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) →
          (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) →
          (hs10_5 :
            s10_5 =
              ((((s10 + s22 * 666643#64) + s21 * 470296#64) + s20 * 654183#64) - s19 * 997805#64) +
                s18 * 136657#64) →
          (ht166 : t166 = (s18 * 18446744073708867715#64)) →
          (hcarry6_1 : carry6_1 = (s6_1 + 1048576#64).sshiftRight 21) →
          (hs7_3 : s7_3 = s7_2 + ((s6_1 + 1048576#64).sshiftRight 21)) →
          (hs6_2 : s6_2 = s6_1 - ((s6_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry8_1 : carry8_1 = (s8_3 + 1048576#64).sshiftRight 21) →
          (hs9_4 :
            s9_4 =
              (((s9 + s21 * 666643#64) + s20 * 470296#64) + s19 * 654183#64) - s18 * 997805#64) →
          (hs9_5 : s9_5 = s9_4 + ((s8_3 + 1048576#64).sshiftRight 21)) →
          (hs8_4 : s8_4 = s8_3 - ((s8_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbt138 : Bnd t138 (-2092547753555) 0) →
          (hbt140 : Bnd t140 (-1434243666051) 0) →
          (hbs7_1 : Bnd s7_1 0 1398053131244) →
          (hbs8_2 : Bnd s8_2 0 2384334857940) →
          (hbt147 : Bnd t147 0 286590364207) →
          (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) →
          (hbs6_1 : Bnd s6_1 0 1398053131244) →
          (hbs7_2 : Bnd s7_2 0 2384334857940) →
          (hbs8_3 : Bnd s8_3 0 3756255390573) →
          (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) →
          (hbt166 : Bnd t166 (-1434243666051) 0) →
          (hbcarry6_1 : Bnd carry6_1 0 666644) →
          (hbs7_3 : Bnd s7_3 0 2384335524584) →
          (hbs6_2 : Bnd s6_2 (-1048576) 1048575) →
          (hbcarry8_1 : Bnd carry8_1 0 1791122) →
          (hbs9_4 : Bnd s9_4 (-2092547753555) 3756255390573) →
          (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) →
          (hbs8_4 : Bnd s8_4 (-1048576) 1048575) → (blk.runBodyFrom E' 181 S >>= g) = K) :
    (blk.runBodyFrom E 136 S >>= g) = K := by
  step_pure [nswMul, nuwMul]
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t138
  bnd t138
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t140
  bnd t140
  step_pure [nswMul, nuwMul]
  -- s7 += s19*666643L
  step_pure [nswAdd, nuwAdd] with s7_1
  bnd s7_1
  step_pure [nswMul, nuwMul]
  -- s8 += s19*470296L
  step_pure [nswAdd, nuwAdd] with s8_2
  bnd s8_2
  step_pure [nswMul, nuwMul]
  step_pure [nswMul]
  step_pure [nswMul, nuwMul] with t147
  bnd t147
  step_pure [nswMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s12 -= s19*683901L
  step_pure [nswAdd] with s12_5
  bnd s12_5
  step_pure [nswMul, nuwMul]
  -- s6 += s18*666643L
  step_pure [nswAdd, nuwAdd] with s6_1
  bnd s6_1
  step_pure [nswMul, nuwMul]
  -- s7 += s18*470296L
  step_pure [nswAdd, nuwAdd] with s7_2
  bnd s7_2
  step_pure [nswMul, nuwMul]
  -- s8 += s18*654183L
  step_pure [nswAdd, nuwAdd] with s8_3
  bnd s8_3
  step_pure [nswMul]
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s10 += s18*136657L
  step_pure [nswAdd] with s10_5
  bnd s10_5
  step_pure [nswMul] with t166
  bnd t166
  step_pure [nswAdd, nuwAdd]
  -- long carry6 = (s6 + (1L << 20)) >> 21
  step_pure with carry6_1
  bnd carry6_1
  -- s7 += carry6
  step_pure [nswAdd, nuwAdd] with s7_3
  bnd s7_3
  step_pure
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure [nswSub] with s6_2
  bnd s6_2
  step_pure [nswAdd, nuwAdd]
  -- long carry8 = (s8 + (1L << 20)) >> 21
  step_pure with carry8_1
  bnd carry8_1
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  -- s9 -= s18*997805L
  step_pure [nswAdd] with s9_4
  bnd s9_4
  -- s9 += carry8
  step_pure [nswAdd] with s9_5
  bnd s9_5
  step_pure
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure [nswSub] with s8_4
  bnd s8_4
  exact
    hK _ t138 t140 s7_1 s8_2 t147 s12_5 s6_1 s7_2 s8_3 s10_5 t166 carry6_1 s7_3 s6_2 carry8_1 s9_4
      s9_5 s8_4 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht138 ht140 (by bridge hs7_1) (by bridge hs8_2) ht147 (by bridge hs12_5)
      (by bridge hs6_1) (by bridge hs7_2) (by bridge hs8_3) (by bridge hs10_5) ht166
      (by bridge hcarry6_1) (by bridge hs7_3 hcarry6_1) (by bridge hs6_2) (by bridge hcarry8_1)
      (by bridge hs9_4) (by bridge hs9_5 hcarry8_1) (by bridge hs8_4) hbt138 hbt140 hbs7_1 hbs8_2
      hbt147 hbs12_5 hbs6_1 hbs7_2 hbs8_3 hbs10_5 hbt166 hbcarry6_1 hbs7_3 hbs6_2 hbcarry8_1 hbs9_4
      hbs9_5 hbs8_4

/-- From `%181`: `carry10 … carry16`. -/
theorem fd_curve25519_scalar_reduce.run181 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 181 = fd_curve25519_scalar_reduce.entry.body.drop 181)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s17 s11_1 s13_1 s16_1 t120 t122 s15_2 t129 t131 s14_3 t138 t140 t147 s12_5
      s10_5 t166 s7_3 s6_2 s9_5 s8_4 s18 s19 s20 s21 s22 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %95 := s17, %108 :=
        s11_1, %112 := s13_1, %118 := s16_1, %120 := t120, %122 := t122, %126 := s15_2, %129 :=
        t129, %131 := t131, %133 := s14_3, %138 := t138, %140 := t140, %147 := t147, %152 := s12_5,
        %165 := s10_5, %166 := t166, %169 := s7_3, %171 := s6_2, %178 := s9_5, %180 := s8_4])
    (ht120 : t120 = (s22 * 470296#64)) (ht122 : t122 = (s22 * 18446744073708553811#64))
    (ht129 : t129 = (s21 * 654183#64)) (ht131 : t131 = (s21 * 136657#64))
    (ht138 : t138 = (s20 * 18446744073708553811#64))
    (ht140 : t140 = (s20 * 18446744073708867715#64)) (ht147 : t147 = (s19 * 136657#64))
    (ht166 : t166 = (s18 * 18446744073708867715#64)) (hbs17 : Bnd s17 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbs21 : Bnd s21 0 2097151) (hbs22 : Bnd s22 0 2097151) (hbs11_1 : Bnd s11_1 0 357901236818924)
    (hbs13_1 : Bnd s13_1 0 351211825267864) (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151)
    (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678)
    (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358)
    (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry10_1 s11_6 s11_7 t189 carry12_1 s13_4 s13_5 s12_6 carry14_1 s15_3 s14_4 carry16_1
          s17_1 s16_2 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %165 := s10_5,
              %169 := s7_3, %171 := s6_2, %178 := s9_5, %180 := s8_4, %188 := s11_7, %189 := t189,
              %195 := s13_5, %197 := s12_6, %200 := s15_3, %202 := s14_4, %205 := s17_1, %207 :=
              s16_2]) →
          (hcarry10_1 : carry10_1 = (s10_5 + 1048576#64).sshiftRight 21) →
          (hs11_6 :
            s11_6 =
              ((((s11_1 + s22 * 470296#64) + s21 * 654183#64) - s20 * 997805#64) +
                  s19 * 136657#64) -
                s18 * 683901#64) →
          (hs11_7 : s11_7 = s11_6 + ((s10_5 + 1048576#64).sshiftRight 21)) →
          (ht189 : t189 = ((s10_5 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry12_1 : carry12_1 = (s12_5 + 1048576#64).sshiftRight 21) →
          (hs13_4 : s13_4 = ((s13_1 - s22 * 997805#64) + s21 * 136657#64) - s20 * 683901#64) →
          (hs13_5 : s13_5 = s13_4 + ((s12_5 + 1048576#64).sshiftRight 21)) →
          (hs12_6 : s12_6 = s12_5 - ((s12_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry14_1 : carry14_1 = (s14_3 + 1048576#64).sshiftRight 21) →
          (hs15_3 : s15_3 = s15_2 + ((s14_3 + 1048576#64).sshiftRight 21)) →
          (hs14_4 : s14_4 = s14_3 - ((s14_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry16_1 : carry16_1 = (s16_1 + 1048576#64).sshiftRight 21) →
          (hs17_1 : s17_1 = s17 + ((s16_1 + 1048576#64).sshiftRight 21)) →
          (hs16_2 : s16_2 = s16_1 - ((s16_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbcarry10_1 : Bnd carry10_1 (-997805) 1927779) →
          (hbs11_6 : Bnd s11_6 (-3526791419606) 360546029442460) →
          (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) →
          (hbt189 : Bnd t189 (-2092548751360) 4042845585408) →
          (hbcarry12_1 : Bnd carry12_1 (-1681705) 121186616) →
          (hbs13_4 : Bnd s13_4 (-3526791419606) 351498415632071) →
          (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) →
          (hbs12_6 : Bnd s12_6 (-1048576) 1048575) →
          (hbcarry14_1 : Bnd carry14_1 (-256121980) 136658) →
          (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) →
          (hbs14_4 : Bnd s14_4 (-1048576) 1048575) →
          (hbcarry16_1 : Bnd carry16_1 (-175078656) 1) →
          (hbs17_1 : Bnd s17_1 (-175078656) 2097152) →
          (hbs16_2 : Bnd s16_2 (-1048576) 1048575) → (blk.runBodyFrom E' 208 S >>= g) = K) :
    (blk.runBodyFrom E 181 S >>= g) = K := by
  step_pure [nswAdd]
  -- long carry10 = (s10 + (1L << 20)) >> 21
  step_pure with carry10_1
  bnd carry10_1
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s11 -= s18*683901L
  step_pure [nswAdd] with s11_6
  bnd s11_6
  -- s11 += carry10
  step_pure [nswAdd] with s11_7
  bnd s11_7
  step_pure with t189
  bnd t189
  step_pure [nswAdd]
  -- long carry12 = (s12 + (1L << 20)) >> 21
  step_pure with carry12_1
  bnd carry12_1
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s13 -= s20*683901L
  step_pure [nswAdd] with s13_4
  bnd s13_4
  -- s13 += carry12
  step_pure [nswAdd] with s13_5
  bnd s13_5
  step_pure
  -- s12 -= (long)((ulong)carry12 << 21)
  step_pure with s12_6
  bnd s12_6
  step_pure [nswAdd]
  -- long carry14 = (s14 + (1L << 20)) >> 21
  step_pure with carry14_1
  bnd carry14_1
  -- s15 += carry14
  step_pure [nswAdd] with s15_3
  bnd s15_3
  step_pure
  -- s14 -= (long)((ulong)carry14 << 21)
  step_pure with s14_4
  bnd s14_4
  step_pure [nswAdd]
  -- long carry16 = (s16 + (1L << 20)) >> 21
  step_pure with carry16_1
  bnd carry16_1
  -- s17 += carry16
  step_pure [nswAdd] with s17_1
  bnd s17_1
  step_pure
  -- s16 -= (long)((ulong)carry16 << 21)
  step_pure [nswSub] with s16_2
  bnd s16_2
  exact
    hK _ carry10_1 s11_6 s11_7 t189 carry12_1 s13_4 s13_5 s12_6 carry14_1 s15_3 s14_4 carry16_1
      s17_1 s16_2 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry10_1) (by bridge hs11_6) (by bridge hs11_7 hcarry10_1) ht189
      (by bridge hcarry12_1) (by bridge hs13_4) (by bridge hs13_5 hcarry12_1) (by bridge hs12_6)
      (by bridge hcarry14_1) (by bridge hs15_3 hcarry14_1) (by bridge hs14_4) (by bridge hcarry16_1)
      (by bridge hs17_1 hcarry16_1) (by bridge hs16_2) hbcarry10_1 hbs11_6 hbs11_7 hbt189
      hbcarry12_1 hbs13_4 hbs13_5 hbs12_6 hbcarry14_1 hbs15_3 hbs14_4 hbcarry16_1 hbs17_1 hbs16_2

/-- From `%208`: `carry7 … carry15`, and the `s17` row begun. -/
theorem fd_curve25519_scalar_reduce.run208 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 208 = fd_curve25519_scalar_reduce.entry.body.drop 208)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s10_5 s7_3 s6_2 s9_5 s8_4 s11_7 t189 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %71 := s5, %165 := s10_5, %169 :=
        s7_3, %171 := s6_2, %178 := s9_5, %180 := s8_4, %188 := s11_7, %189 := t189, %195 := s13_5,
        %197 := s12_6, %200 := s15_3, %202 := s14_4, %205 := s17_1, %207 := s16_2])
    (hbs5 : Bnd s5 0 2097151) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs6_2 : Bnd s6_2 (-1048576) 1048575) (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239)
    (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) (hbs12_6 : Bnd s12_6 (-1048576) 1048575)
    (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) (hbs14_4 : Bnd s14_4 (-1048576) 1048575)
    (hbs17_1 : Bnd s17_1 (-175078656) 2097152) (hbs16_2 : Bnd s16_2 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry7_1 t210 carry9_1 t213 carry11_1 s12_7 s11_8 carry13_1 s14_5 s13_6 carry15_1 s16_3
          s15_4 s5_1 s6_3 t233 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %165 := s10_5, %169 :=
              s7_3, %178 := s9_5, %180 := s8_4, %189 := t189, %205 := s17_1, %209 := carry7_1,
              %210 := t210, %212 := carry9_1, %213 := t213, %216 := s12_7, %218 := s11_8, %221 :=
              s14_5, %223 := s13_6, %226 := s16_3, %228 := s15_4, %230 := s5_1, %232 := s6_3,
              %233 := t233]) →
          (hcarry7_1 : carry7_1 = (s7_3 + 1048576#64).sshiftRight 21) →
          (ht210 : t210 = ((s7_3 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry9_1 : carry9_1 = (s9_5 + 1048576#64).sshiftRight 21) →
          (ht213 : t213 = ((s9_5 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry11_1 : carry11_1 = (s11_7 + 1048576#64).sshiftRight 21) →
          (hs12_7 : s12_7 = s12_6 + ((s11_7 + 1048576#64).sshiftRight 21)) →
          (hs11_8 : s11_8 = s11_7 - ((s11_7 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry13_1 : carry13_1 = (s13_5 + 1048576#64).sshiftRight 21) →
          (hs14_5 : s14_5 = s14_4 + ((s13_5 + 1048576#64).sshiftRight 21)) →
          (hs13_6 : s13_6 = s13_5 - ((s13_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry15_1 : carry15_1 = (s15_3 + 1048576#64).sshiftRight 21) →
          (hs16_3 : s16_3 = s16_2 + ((s15_3 + 1048576#64).sshiftRight 21)) →
          (hs15_4 : s15_4 = s15_3 - ((s15_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hs5_1 : s5_1 = s5 + s17_1 * 666643#64) →
          (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) →
          (ht233 : t233 = (s17_1 * 654183#64)) →
          (hbcarry7_1 : Bnd carry7_1 0 1136940) →
          (hbt210 : Bnd t210 0 2384335994880) →
          (hbcarry9_1 : Bnd carry9_1 (-997805) 1791123) →
          (hbt213 : Bnd t213 (-2092548751360) 3756257181696) →
          (hbcarry11_1 : Bnd carry11_1 (-1681706) 171921745) →
          (hbs12_7 : Bnd s12_7 (-2730282) 172970320) →
          (hbs11_8 : Bnd s11_8 (-1048576) 1048575) →
          (hbcarry13_1 : Bnd carry13_1 (-1681706) 167607563) →
          (hbs14_5 : Bnd s14_5 (-2730282) 168656138) →
          (hbs13_6 : Bnd s13_6 (-1048576) 1048575) →
          (hbcarry15_1 : Bnd carry15_1 (-684023) 34984193) →
          (hbs16_3 : Bnd s16_3 (-1732599) 36032768) →
          (hbs15_4 : Bnd s15_4 (-1048576) 1048575) →
          (hbs5_1 : Bnd s5_1 (-116714960471808) 1398053797887) →
          (hbs6_3 : Bnd s6_3 (-82338792650752) 986283245567) →
          (hbt233 : Bnd t233 (-114533480418048) 1371921186816) →
          (blk.runBodyFrom E' 234 S >>= g) = K) :
    (blk.runBodyFrom E 208 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd]
  -- long carry7 = (s7 + (1L << 20)) >> 21
  step_pure with carry7_1
  bnd carry7_1
  step_pure with t210
  bnd t210
  step_pure [nswAdd]
  -- long carry9 = (s9 + (1L << 20)) >> 21
  step_pure with carry9_1
  bnd carry9_1
  step_pure with t213
  bnd t213
  step_pure [nswAdd]
  -- long carry11 = (s11 + (1L << 20)) >> 21
  step_pure with carry11_1
  bnd carry11_1
  -- s12 += carry11
  step_pure with s12_7
  bnd s12_7
  step_pure
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_8
  bnd s11_8
  step_pure [nswAdd]
  -- long carry13 = (s13 + (1L << 20)) >> 21
  step_pure with carry13_1
  bnd carry13_1
  -- s14 += carry13
  step_pure with s14_5
  bnd s14_5
  step_pure
  -- s13 -= (long)((ulong)carry13 << 21)
  step_pure with s13_6
  bnd s13_6
  step_pure [nswAdd]
  -- long carry15 = (s15 + (1L << 20)) >> 21
  step_pure with carry15_1
  bnd carry15_1
  -- s16 += carry15
  step_pure [nswAdd] with s16_3
  bnd s16_3
  step_pure
  -- s15 -= (long)((ulong)carry15 << 21)
  step_pure with s15_4
  bnd s15_4
  step_pure [nswMul]
  -- s5 += s17*666643L
  step_pure [nswAdd] with s5_1
  bnd s5_1
  step_pure [nswMul]
  -- s6 += s17*470296L
  step_pure [nswAdd] with s6_3
  bnd s6_3
  step_pure [nswMul] with t233
  bnd t233
  exact
    hK _ carry7_1 t210 carry9_1 t213 carry11_1 s12_7 s11_8 carry13_1 s14_5 s13_6 carry15_1 s16_3
      s15_4 s5_1 s6_3 t233 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry7_1) ht210 (by bridge hcarry9_1) ht213 (by bridge hcarry11_1)
      (by bridge hs12_7 hcarry11_1) (by bridge hs11_8) (by bridge hcarry13_1)
      (by bridge hs14_5 hcarry13_1) (by bridge hs13_6) (by bridge hcarry15_1)
      (by bridge hs16_3 hcarry15_1) (by bridge hs15_4) (by bridge hs5_1) (by bridge hs6_3) ht233
      hbcarry7_1 hbt210 hbcarry9_1 hbt213 hbcarry11_1 hbs12_7 hbs11_8 hbcarry13_1 hbs14_5 hbs13_6
      hbcarry15_1 hbs16_3 hbs15_4 hbs5_1 hbs6_3 hbt233

/-- From `%234`: the rows of `s17 … s14` into `s2 … s10`. -/
theorem fd_curve25519_scalar_reduce.run234 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 234 = fd_curve25519_scalar_reduce.entry.body.drop 234)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s10_5 s7_3 s9_5 s8_4 t189 s17_1 carry7_1 t210 carry9_1 t213 s12_7 s11_8 s14_5
      s13_6 s16_3 s15_4 s5_1 s6_3 t233 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %65 := s2, %67 := s3, %69 := s4, %165 := s10_5, %169 := s7_3,
        %178 := s9_5, %180 := s8_4, %189 := t189, %205 := s17_1, %209 := carry7_1, %210 := t210,
        %212 := carry9_1, %213 := t213, %216 := s12_7, %218 := s11_8, %221 := s14_5, %223 := s13_6,
        %226 := s16_3, %228 := s15_4, %230 := s5_1, %232 := s6_3, %233 := t233])
    (ht189 : t189 = ((s10_5 + 1048576#64) &&& 18446744073707454464#64))
    (hcarry7_1 : carry7_1 = (s7_3 + 1048576#64).sshiftRight 21)
    (hcarry9_1 : carry9_1 = (s9_5 + 1048576#64).sshiftRight 21) (hbs2 : Bnd s2 0 2097151)
    (hbs3 : Bnd s3 0 2097151) (hbs4 : Bnd s4 0 2097151)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) (hbs8_4 : Bnd s8_4 (-1048576) 1048575)
    (hbs17_1 : Bnd s17_1 (-175078656) 2097152) (hbs14_5 : Bnd s14_5 (-2730282) 168656138)
    (hbs16_3 : Bnd s16_3 (-1732599) 36032768) (hbs15_4 : Bnd s15_4 (-1048576) 1048575)
    (hbs5_1 : Bnd s5_1 (-116714960471808) 1398053797887)
    (hbs6_3 : Bnd s6_3 (-82338792650752) 986283245567)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t235 s10_8 s4_1 s5_2 s6_4 t246 t248 s3_1 s4_2 s5_3 s6_5 t257 s8_6 s8_7 s8_8 s2_1 s3_2
          s4_3 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%61 := s0, %63 := s1, %169 := s7_3, %178 := s9_5, %210 := t210, %213 := t213,
              %216 := s12_7, %218 := s11_8, %221 := s14_5, %223 := s13_6, %233 := t233, %235 :=
              t235, %239 := s10_8, %246 := t246, %248 := t248, %254 := s5_3, %256 := s6_5, %257 :=
              t257, %262 := s8_8, %264 := s2_1, %266 := s3_2, %268 := s4_3]) →
          (ht235 : t235 = (s17_1 * 136657#64)) →
          (hs10_8 :
            s10_8 =
              ((s10_5 - ((s10_5 + 1048576#64).sshiftRight 21) <<< 21) +
                  ((s9_5 + 1048576#64).sshiftRight 21)) -
                s17_1 * 683901#64) →
          (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) →
          (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) →
          (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64) →
          (ht246 : t246 = (s16_3 * 18446744073708553811#64)) →
          (ht248 : t248 = (s16_3 * 18446744073708867715#64)) →
          (hs3_1 : s3_1 = s3 + s15_4 * 666643#64) →
          (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) →
          (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64) →
          (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) →
          (ht257 : t257 = (s15_4 * 136657#64)) →
          (hs8_6 : s8_6 = (s8_4 + ((s7_3 + 1048576#64).sshiftRight 21)) - s17_1 * 997805#64) →
          (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64) →
          (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) →
          (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) →
          (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) →
          (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) →
          (hbt235 : Bnd t235 (-23925723892992) 286590500864) →
          (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754) →
          (hbs4_1 : Bnd s4_1 (-1155024995157) 24020994654975) →
          (hbs5_2 : Bnd s5_2 (-117529794851112) 18344120457215) →
          (hbs6_4 : Bnd s6_4 (-83472229462369) 24558307514111) →
          (hbt246 : Bnd t246 (-35953676074240) 1728795945195) →
          (hbt248 : Bnd t248 (-24642846067968) 1184926188699) →
          (hbs3_1 : Bnd s3_1 (-699025850368) 699027280876) →
          (hbs4_2 : Bnd s4_2 (-1648166093653) 24514135283175) →
          (hbs5_3 : Bnd s5_3 (-118215755444520) 19030080396440) →
          (hbs6_5 : Bnd s6_5 (-84518502840244) 25604581889791) →
          (hbt257 : Bnd t257 (-143295250432) 143295113775) →
          (hbs8_6 : Bnd s8_6 (-2092549799936) 174694360535595) →
          (hbs8_7 : Bnd s8_7 (-2329321581479) 179618490512171) →
          (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147) →
          (hbs2_1 : Bnd s2_1 (-1820123383326) 112433435901885) →
          (hbs3_2 : Bnd s3_2 (-1983066553840) 80017334357724) →
          (hbs4_3 : Bnd s4_3 (-3434270163259) 134846113608429) →
          (blk.runBodyFrom E' 269 S >>= g) = K) :
    (blk.runBodyFrom E 234 S >>= g) = K := by
  step_pure [nswMul]
  step_pure [nswMul] with t235
  bnd t235
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure
  -- s10 -= s17*683901L
  step_pure with s10_8
  bnd s10_8
  step_pure
  -- s4 += s16*666643L
  step_pure with s4_1
  bnd s4_1
  step_pure
  -- s5 += s16*470296L
  step_pure with s5_2
  bnd s5_2
  step_pure
  -- s6 += s16*654183L
  step_pure with s6_4
  bnd s6_4
  step_pure with t246
  bnd t246
  step_pure
  step_pure with t248
  bnd t248
  step_pure
  -- s3 += s15*666643L
  step_pure with s3_1
  bnd s3_1
  step_pure
  -- s4 += s15*470296L
  step_pure with s4_2
  bnd s4_2
  step_pure
  -- s5 += s15*654183L
  step_pure with s5_3
  bnd s5_3
  step_pure
  -- s6 -= s15*997805L
  step_pure with s6_5
  bnd s6_5
  step_pure with t257
  bnd t257
  step_pure
  step_pure [nswAdd]
  -- s8 -= s17*997805L
  step_pure [nswAdd] with s8_6
  bnd s8_6
  -- s8 += s16*136657L
  step_pure with s8_7
  bnd s8_7
  -- s8 -= s15*683901L
  step_pure with s8_8
  bnd s8_8
  step_pure
  -- s2 += s14*666643L
  step_pure with s2_1
  bnd s2_1
  step_pure
  -- s3 += s14*470296L
  step_pure with s3_2
  bnd s3_2
  step_pure
  -- s4 += s14*654183L
  step_pure with s4_3
  bnd s4_3
  exact
    hK _ t235 s10_8 s4_1 s5_2 s6_4 t246 t248 s3_1 s4_2 s5_3 s6_5 t257 s8_6 s8_7 s8_8 s2_1 s3_2 s4_3
      hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht235 (by bridge hs10_8) (by bridge hs4_1) (by bridge hs5_2) (by bridge hs6_4)
      ht246 ht248 (by bridge hs3_1) (by bridge hs4_2) (by bridge hs5_3) (by bridge hs6_5) ht257
      (by bridge hs8_6) (by bridge hs8_7) (by bridge hs8_8) (by bridge hs2_1) (by bridge hs3_2)
      (by bridge hs4_3) hbt235 hbs10_8 hbs4_1 hbs5_2 hbs6_4 hbt246 hbt248 hbs3_1 hbs4_2 hbs5_3
      hbs6_5 hbt257 hbs8_6 hbs8_7 hbs8_8 hbs2_1 hbs3_2 hbs4_3

/-- From `%269`: the rows of `s13` and `s12`, and `carry0`. -/
theorem fd_curve25519_scalar_reduce.run269 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 269 = fd_curve25519_scalar_reduce.entry.body.drop 269)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s7_3 s9_5 t210 t213 s12_7 s11_8 s14_5 s13_6 t233 t235 s10_8 t246 t248 s5_3 s6_5 t257 s8_8
      s2_1 s3_2 s4_3 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%61 := s0, %63 := s1, %169 := s7_3, %178 := s9_5, %210 := t210, %213 := t213, %216 :=
        s12_7, %218 := s11_8, %221 := s14_5, %223 := s13_6, %233 := t233, %235 := t235, %239 :=
        s10_8, %246 := t246, %248 := t248, %254 := s5_3, %256 := s6_5, %257 := t257, %262 := s8_8,
        %264 := s2_1, %266 := s3_2, %268 := s4_3])
    (hbs0 : Bnd s0 0 2097151) (hbs1 : Bnd s1 0 2097151) (hbs12_7 : Bnd s12_7 (-2730282) 172970320)
    (hbs14_5 : Bnd s14_5 (-2730282) 168656138) (hbs13_6 : Bnd s13_6 (-1048576) 1048575)
    (hbs5_3 : Bnd s5_3 (-118215755444520) 19030080396440)
    (hbs6_5 : Bnd s6_5 (-84518502840244) 25604581889791)
    (hbs2_1 : Bnd s2_1 (-1820123383326) 112433435901885)
    (hbs3_2 : Bnd s3_2 (-1983066553840) 80017334357724)
    (hbs4_3 : Bnd s4_3 (-3434270163259) 134846113608429)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s5_4 s6_6 t273 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4 s4_5 s5_6 carry0_1 s1_3
          s0_2 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%169 := s7_3, %178 := s9_5, %210 := t210, %213 := t213, %218 := s11_8, %233 :=
              t233, %235 := t235, %239 := s10_8, %246 := t246, %248 := t248, %257 := t257, %262 :=
              s8_8, %273 := t273, %285 := s6_7, %291 := s2_3, %293 := s3_4, %295 := s4_5, %297 :=
              s5_6, %300 := s1_3, %302 := s0_2]) →
          (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) →
          (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64) →
          (ht273 : t273 = (s14_5 * 18446744073708867715#64)) →
          (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) →
          (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) →
          (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64) →
          (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) →
          (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64) →
          (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) →
          (hs0_1 : s0_1 = s0 + s12_7 * 666643#64) →
          (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64) →
          (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64) →
          (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) →
          (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) →
          (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) →
          (hcarry0_1 : carry0_1 = (s0_1 + 1048576#64).sshiftRight 21) →
          (hs1_3 : s1_3 = s1_2 + ((s0_1 + 1048576#64).sshiftRight 21)) →
          (hs0_2 : s0_2 = s0_1 - ((s0_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbs5_4 : Bnd s5_4 (-286501693221610) 21754369427450) →
          (hbs6_6 : Bnd s6_6 (-84891614987518) 48652623740457) →
          (hbt273 : Bnd t273 (-115344101434338) 1867242590082) →
          (hbs1_1 : Bnd s1_1 (-699025850368) 699027280876) →
          (hbs2_2 : Bnd s2_2 (-2313264481822) 112926576530085) →
          (hbs3_3 : Bnd s3_3 (-2669027147248) 80703294296949) →
          (hbs4_4 : Bnd s4_4 (-4480543541134) 135892387984109) →
          (hbs5_5 : Bnd s5_5 (-286644988472042) 21897664541225) →
          (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433) →
          (hbs0_1 : Bnd s0_1 (-1820123383326) 115309455132911) →
          (hbs1_2 : Bnd s1_2 (-1983066553840) 82046276895596) →
          (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645) →
          (hbs3_4 : Bnd s3_4 (-175259677294848) 83427583327959) →
          (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349) →
          (hbs5_6 : Bnd s5_6 (-404939563290362) 23764907131307) →
          (hbcarry0_1 : Bnd carry0_1 (-867902) 54983833) →
          (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) →
          (hbs0_2 : Bnd s0_2 (-1048576) 1048575) → (blk.runBodyFrom E' 303 S >>= g) = K) :
    (blk.runBodyFrom E 269 S >>= g) = K := by
  step_pure
  -- s5 -= s14*997805L
  step_pure with s5_4
  bnd s5_4
  step_pure
  -- s6 += s14*136657L
  step_pure with s6_6
  bnd s6_6
  step_pure with t273
  bnd t273
  step_pure
  -- s1 += s13*666643L
  step_pure with s1_1
  bnd s1_1
  step_pure
  -- s2 += s13*470296L
  step_pure with s2_2
  bnd s2_2
  step_pure
  -- s3 += s13*654183L
  step_pure with s3_3
  bnd s3_3
  step_pure
  -- s4 -= s13*997805L
  step_pure with s4_4
  bnd s4_4
  step_pure
  -- s5 += s13*136657L
  step_pure with s5_5
  bnd s5_5
  step_pure
  -- s6 -= s13*683901L
  step_pure with s6_7
  bnd s6_7
  step_pure
  -- s0 += s12*666643L
  step_pure with s0_1
  bnd s0_1
  step_pure
  -- s1 += s12*470296L
  step_pure with s1_2
  bnd s1_2
  step_pure
  -- s2 += s12*654183L
  step_pure with s2_3
  bnd s2_3
  step_pure
  -- s3 -= s12*997805L
  step_pure with s3_4
  bnd s3_4
  step_pure
  -- s4 += s12*136657L
  step_pure with s4_5
  bnd s4_5
  step_pure
  -- s5 -= s12*683901L
  step_pure with s5_6
  bnd s5_6
  step_pure
  -- long carry0 = (s0 + (1L << 20)) >> 21
  step_pure with carry0_1
  bnd carry0_1
  -- s1 += carry0
  step_pure with s1_3
  bnd s1_3
  step_pure
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_2
  bnd s0_2
  exact
    hK _ s5_4 s6_6 t273 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4 s4_5 s5_6 carry0_1 s1_3
      s0_2 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs5_4) (by bridge hs6_6) ht273 (by bridge hs1_1) (by bridge hs2_2)
      (by bridge hs3_3) (by bridge hs4_4) (by bridge hs5_5) (by bridge hs6_7) (by bridge hs0_1)
      (by bridge hs1_2) (by bridge hs2_3) (by bridge hs3_4) (by bridge hs4_5) (by bridge hs5_6)
      (by bridge hcarry0_1) (by bridge hs1_3 hcarry0_1) (by bridge hs0_2) hbs5_4 hbs6_6 hbt273
      hbs1_1 hbs2_2 hbs3_3 hbs4_4 hbs5_5 hbs6_7 hbs0_1 hbs1_2 hbs2_3 hbs3_4 hbs4_5 hbs5_6 hbcarry0_1
      hbs1_3 hbs0_2

/-- From `%303`: `carry2 … carry10`. -/
theorem fd_curve25519_scalar_reduce.run303 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 303 = fd_curve25519_scalar_reduce.entry.body.drop 303)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s7_3 s9_5 t210 t213 s11_8 t233 t235 s10_8 t246 t248 t257 s8_8 t273 s6_7 s2_3 s3_4 s4_5 s5_6
      s1_3 s0_2 s17_1 s14_5 s16_3 s15_4 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%169 := s7_3, %178 := s9_5, %210 := t210, %213 := t213, %218 := s11_8, %233 := t233,
        %235 := t235, %239 := s10_8, %246 := t246, %248 := t248, %257 := t257, %262 := s8_8, %273 :=
        t273, %285 := s6_7, %291 := s2_3, %293 := s3_4, %295 := s4_5, %297 := s5_6, %300 := s1_3,
        %302 := s0_2])
    (ht210 : t210 = ((s7_3 + 1048576#64) &&& 18446744073707454464#64))
    (ht213 : t213 = ((s9_5 + 1048576#64) &&& 18446744073707454464#64))
    (ht233 : t233 = (s17_1 * 654183#64)) (ht235 : t235 = (s17_1 * 136657#64))
    (ht246 : t246 = (s16_3 * 18446744073708553811#64))
    (ht248 : t248 = (s16_3 * 18446744073708867715#64)) (ht257 : t257 = (s15_4 * 136657#64))
    (ht273 : t273 = (s14_5 * 18446744073708867715#64)) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) (hbs17_1 : Bnd s17_1 (-175078656) 2097152)
    (hbs11_8 : Bnd s11_8 (-1048576) 1048575) (hbs14_5 : Bnd s14_5 (-2730282) 168656138)
    (hbs16_3 : Bnd s16_3 (-1732599) 36032768) (hbs15_4 : Bnd s15_4 (-1048576) 1048575)
    (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754)
    (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147)
    (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433)
    (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645)
    (hbs3_4 : Bnd s3_4 (-175259677294848) 83427583327959)
    (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349)
    (hbs5_6 : Bnd s5_6 (-404939563290362) 23764907131307)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry2_1 s3_5 s2_4 carry4_1 s5_7 s4_6 carry6_2 s7_5 s7_6 s7_7 s7_8 s7_9 s6_8 carry8_2 s9_7
          s9_8 s9_9 s8_9 carry10_2 s11_9 s10_9 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%300 := s1_3, %302 := s0_2, %305 := s3_5, %307 := s2_4, %310 := s5_7, %312 :=
              s4_6, %320 := s7_9, %322 := s6_8, %328 := s9_9, %330 := s8_9, %333 := s11_9, %335 :=
              s10_9]) →
          (hcarry2_1 : carry2_1 = (s2_3 + 1048576#64).sshiftRight 21) →
          (hs3_5 : s3_5 = s3_4 + ((s2_3 + 1048576#64).sshiftRight 21)) →
          (hs2_4 : s2_4 = s2_3 - ((s2_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry4_1 : carry4_1 = (s4_5 + 1048576#64).sshiftRight 21) →
          (hs5_7 : s5_7 = s5_6 + ((s4_5 + 1048576#64).sshiftRight 21)) →
          (hs4_6 : s4_6 = s4_5 - ((s4_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry6_2 : carry6_2 = (s6_7 + 1048576#64).sshiftRight 21) →
          (hs7_5 :
            s7_5 = (s7_3 - ((s7_3 + 1048576#64).sshiftRight 21) <<< 21) + s17_1 * 654183#64) →
          (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64) →
          (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) →
          (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64) →
          (hs7_9 : s7_9 = s7_8 + ((s6_7 + 1048576#64).sshiftRight 21)) →
          (hs6_8 : s6_8 = s6_7 - ((s6_7 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry8_2 : carry8_2 = (s8_8 + 1048576#64).sshiftRight 21) →
          (hs9_7 :
            s9_7 = (s9_5 - ((s9_5 + 1048576#64).sshiftRight 21) <<< 21) + s17_1 * 136657#64) →
          (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) →
          (hs9_9 : s9_9 = s9_8 + ((s8_8 + 1048576#64).sshiftRight 21)) →
          (hs8_9 : s8_9 = s8_8 - ((s8_8 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry10_2 : carry10_2 = (s10_8 + 1048576#64).sshiftRight 21) →
          (hs11_9 : s11_9 = s11_8 + ((s10_8 + 1048576#64).sshiftRight 21)) →
          (hs10_9 : s10_9 = s10_8 - ((s10_8 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbcarry2_1 : Bnd carry2_1 (-1954731) 107803735) →
          (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) →
          (hbs2_4 : Bnd s2_4 (-1048576) 1048575) →
          (hbcarry4_1 : Bnd carry4_1 (-2314403) 76069829) →
          (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136) →
          (hbs4_6 : Bnd s4_6 (-1048576) 1048575) →
          (hbcarry6_2 : Bnd carry6_2 (-40821427) 23541329) →
          (hbs7_5 : Bnd s7_5 (-114533481466624) 1371922235391) →
          (hbs7_6 : Bnd s7_6 (-150487157540864) 3100718180586) →
          (hbs7_7 : Bnd s7_7 (-150630452791296) 3244013294361) →
          (hbs7_8 : Bnd s7_8 (-265974554225634) 5111255884443) →
          (hbs7_9 : Bnd s7_9 (-265974595047061) 5111279425772) →
          (hbs6_8 : Bnd s6_8 (-1048576) 1048575) →
          (hbcarry8_2 : Bnd carry8_2 (-1452657) 85990721) →
          (hbs9_7 : Bnd s9_7 (-23925724941568) 286591549439) →
          (hbs9_8 : Bnd s9_8 (-48568571009536) 1471517738138) →
          (hbs9_9 : Bnd s9_9 (-48568572462193) 1471603728859) →
          (hbs8_9 : Bnd s8_9 (-1048576) 1048575) →
          (hbcarry10_2 : Bnd carry10_2 (-683902) 57094798) →
          (hbs11_9 : Bnd s11_9 (-1732478) 58143373) →
          (hbs10_9 : Bnd s10_9 (-1048576) 1048575) → (blk.runBodyFrom E' 336 S >>= g) = K) :
    (blk.runBodyFrom E 303 S >>= g) = K := by
  step_pure
  -- long carry2 = (s2 + (1L << 20)) >> 21
  step_pure with carry2_1
  bnd carry2_1
  -- s3 += carry2
  step_pure with s3_5
  bnd s3_5
  step_pure
  -- s2 -= (long)((ulong)carry2 << 21)
  step_pure with s2_4
  bnd s2_4
  step_pure
  -- long carry4 = (s4 + (1L << 20)) >> 21
  step_pure with carry4_1
  bnd carry4_1
  -- s5 += carry4
  step_pure with s5_7
  bnd s5_7
  step_pure
  -- s4 -= (long)((ulong)carry4 << 21)
  step_pure with s4_6
  bnd s4_6
  step_pure
  -- carry6 = (s6 + (1L << 20)) >> 21
  step_pure with carry6_2
  bnd carry6_2
  step_pure [nswAdd]
  -- s7 += s17*654183L
  step_pure [nswSub] with s7_5
  bnd s7_5
  -- s7 -= s16*997805L
  step_pure with s7_6
  bnd s7_6
  -- s7 += s15*136657L
  step_pure with s7_7
  bnd s7_7
  -- s7 -= s14*683901L
  step_pure with s7_8
  bnd s7_8
  -- s7 += carry6
  step_pure with s7_9
  bnd s7_9
  step_pure
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure with s6_8
  bnd s6_8
  step_pure
  -- carry8 = (s8 + (1L << 20)) >> 21
  step_pure with carry8_2
  bnd carry8_2
  step_pure [nswAdd]
  -- s9 += s17*136657L
  step_pure with s9_7
  bnd s9_7
  -- s9 -= s16*683901L
  step_pure with s9_8
  bnd s9_8
  -- s9 += carry8
  step_pure with s9_9
  bnd s9_9
  step_pure
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure with s8_9
  bnd s8_9
  step_pure
  -- carry10 = (s10 + (1L << 20)) >> 21
  step_pure with carry10_2
  bnd carry10_2
  -- s11 += carry10
  step_pure with s11_9
  bnd s11_9
  step_pure
  -- s10 -= (long)((ulong)carry10 << 21)
  step_pure with s10_9
  bnd s10_9
  exact
    hK _ carry2_1 s3_5 s2_4 carry4_1 s5_7 s4_6 carry6_2 s7_5 s7_6 s7_7 s7_8 s7_9 s6_8 carry8_2 s9_7
      s9_8 s9_9 s8_9 carry10_2 s11_9 s10_9 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry2_1) (by bridge hs3_5 hcarry2_1) (by bridge hs2_4)
      (by bridge hcarry4_1) (by bridge hs5_7 hcarry4_1) (by bridge hs4_6) (by bridge hcarry6_2)
      (by bridge hs7_5) (by bridge hs7_6) (by bridge hs7_7) (by bridge hs7_8)
      (by bridge hs7_9 hcarry6_2) (by bridge hs6_8) (by bridge hcarry8_2) (by bridge hs9_7)
      (by bridge hs9_8) (by bridge hs9_9 hcarry8_2) (by bridge hs8_9) (by bridge hcarry10_2)
      (by bridge hs11_9 hcarry10_2) (by bridge hs10_9) hbcarry2_1 hbs3_5 hbs2_4 hbcarry4_1 hbs5_7
      hbs4_6 hbcarry6_2 hbs7_5 hbs7_6 hbs7_7 hbs7_8 hbs7_9 hbs6_8 hbcarry8_2 hbs9_7 hbs9_8 hbs9_9
      hbs8_9 hbcarry10_2 hbs11_9 hbs10_9

/-- From `%336`: `carry1 … carry11`, the `s12` row, and the unrounded carries begun. -/
theorem fd_curve25519_scalar_reduce.run336 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 336 = fd_curve25519_scalar_reduce.entry.body.drop 336)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_3 s0_2 s3_5 s2_4 s5_7 s4_6 s7_9 s6_8 s9_9 s8_9 s11_9 s10_9 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%300 := s1_3, %302 := s0_2, %305 := s3_5, %307 := s2_4, %310 := s5_7, %312 := s4_6,
        %320 := s7_9, %322 := s6_8, %328 := s9_9, %330 := s8_9, %333 := s11_9, %335 := s10_9])
    (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) (hbs0_2 : Bnd s0_2 (-1048576) 1048575)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) (hbs2_4 : Bnd s2_4 (-1048576) 1048575)
    (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136)
    (hbs7_9 : Bnd s7_9 (-265974595047061) 5111279425772) (hbs6_8 : Bnd s6_8 (-1048576) 1048575)
    (hbs9_9 : Bnd s9_9 (-48568572462193) 1471603728859) (hbs8_9 : Bnd s8_9 (-1048576) 1048575)
    (hbs11_9 : Bnd s11_9 (-1732478) 58143373) (hbs10_9 : Bnd s10_9 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry1_1 carry3_1 carry5_1 s6_9 t345 carry7_2 s8_10 s7_10 carry9_2 s10_10 s9_10 carry11_2
          s11_10 s0_3 t365 t366 carry0_2 s1_5 s1_6 s0_4 carry1_2 s2_6 s2_7 s1_7 carry2_2 s3_7 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%310 := s5_7, %312 := s4_6, %340 := carry3_1, %344 := s6_9, %345 := t345, %348 :=
              s8_10, %350 := s7_10, %353 := s10_10, %355 := s9_10, %359 := s11_10, %365 := t365,
              %366 := t366, %371 := s0_4, %375 := s2_7, %376 := s1_7, %377 := carry2_2, %379 :=
              s3_7]) →
          (hcarry1_1 : carry1_1 = (s1_3 + 1048576#64).sshiftRight 21) →
          (hcarry3_1 : carry3_1 = (s3_5 + 1048576#64).sshiftRight 21) →
          (hcarry5_1 : carry5_1 = (s5_7 + 1048576#64).sshiftRight 21) →
          (hs6_9 : s6_9 = s6_8 + ((s5_7 + 1048576#64).sshiftRight 21)) →
          (ht345 : t345 = ((s5_7 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry7_2 : carry7_2 = (s7_9 + 1048576#64).sshiftRight 21) →
          (hs8_10 : s8_10 = s8_9 + ((s7_9 + 1048576#64).sshiftRight 21)) →
          (hs7_10 : s7_10 = s7_9 - ((s7_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry9_2 : carry9_2 = (s9_9 + 1048576#64).sshiftRight 21) →
          (hs10_10 : s10_10 = s10_9 + ((s9_9 + 1048576#64).sshiftRight 21)) →
          (hs9_10 : s9_10 = s9_9 - ((s9_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry11_2 : carry11_2 = (s11_9 + 1048576#64).sshiftRight 21) →
          (hs11_10 : s11_10 = s11_9 - ((s11_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hs0_3 : s0_3 = s0_2 + ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 666643#64) →
          (ht365 : t365 = (carry11_2 * 136657#64)) →
          (ht366 : t366 = (carry11_2 * 18446744073708867715#64)) →
          (hcarry0_2 : carry0_2 = s0_3.sshiftRight 21) →
          (hs1_5 :
            s1_5 =
              (s1_3 - ((s1_3 + 1048576#64).sshiftRight 21) <<< 21) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 470296#64) →
          (hs1_6 : s1_6 = s1_5 + (s0_3.sshiftRight 21)) →
          (hs0_4 : s0_4 = s0_3 - (s0_3.sshiftRight 21) <<< 21) →
          (hcarry1_2 : carry1_2 = s1_6.sshiftRight 21) →
          (hs2_6 :
            s2_6 =
              (s2_4 + ((s1_3 + 1048576#64).sshiftRight 21)) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 654183#64) →
          (hs2_7 : s2_7 = s2_6 + (s1_6.sshiftRight 21)) →
          (hs1_7 : s1_7 = s1_6 - (s1_6.sshiftRight 21) <<< 21) →
          (hcarry2_2 : carry2_2 = s2_7.sshiftRight 21) →
          (hs3_7 :
            s3_7 =
              (s3_5 - ((s3_5 + 1048576#64).sshiftRight 21) <<< 21) -
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 997805#64) →
          (hbcarry1_1 : Bnd carry1_1 (-945600) 39122740) →
          (hbcarry3_1 : Bnd carry3_1 (-83570327) 39781423) →
          (hbcarry5_1 : Bnd carry5_1 (-193090232) 11332027) →
          (hbs6_9 : Bnd s6_9 (-194138808) 12380602) →
          (hbt345 : Bnd t345 (-404939566219264) 23764983087104) →
          (hbcarry7_2 : Bnd carry7_2 (-126826570) 2437248) →
          (hbs8_10 : Bnd s8_10 (-127875146) 3485823) →
          (hbs7_10 : Bnd s7_10 (-1048576) 1048575) →
          (hbcarry9_2 : Bnd carry9_2 (-23159300) 701715) →
          (hbs10_10 : Bnd s10_10 (-24207876) 1750290) →
          (hbs9_10 : Bnd s9_10 (-1048576) 1048575) →
          (hbcarry11_2 : Bnd carry11_2 (-1) 28) →
          (hbs11_10 : Bnd s11_10 (-1048576) 1048575) →
          (hbs0_3 : Bnd s0_3 (-1715219) 19714579) →
          (hbt365 : Bnd t365 (-136657) 3826396) →
          (hbt366 : Bnd t366 (-19149228) 683901) →
          (hbcarry0_2 : Bnd carry0_2 (-1) 9) →
          (hbs1_5 : Bnd s1_5 (-1518872) 14216863) →
          (hbs1_6 : Bnd s1_6 (-1518873) 14216872) →
          (hbs0_4 : Bnd s0_4 0 2097151) →
          (hbcarry1_2 : Bnd carry1_2 (-1) 6) →
          (hbs2_6 : Bnd s2_6 (-2648359) 58488439) →
          (hbs2_7 : Bnd s2_7 (-2648360) 58488445) →
          (hbs1_7 : Bnd s1_7 0 2097151) →
          (hbcarry2_2 : Bnd carry2_2 (-2) 27) →
          (hbs3_7 : Bnd s3_7 (-28987116) 2046380) → (blk.runBodyFrom E' 380 S >>= g) = K) :
    (blk.runBodyFrom E 336 S >>= g) = K := by
  step_pure
  -- long carry1 = (s1 + (1L << 20)) >> 21
  step_pure with carry1_1
  bnd carry1_1
  step_pure
  step_pure
  -- long carry3 = (s3 + (1L << 20)) >> 21
  step_pure with carry3_1
  bnd carry3_1
  step_pure
  step_pure
  -- long carry5 = (s5 + (1L << 20)) >> 21
  step_pure with carry5_1
  bnd carry5_1
  -- s6 += carry5
  step_pure with s6_9
  bnd s6_9
  step_pure with t345
  bnd t345
  step_pure
  -- carry7 = (s7 + (1L << 20)) >> 21
  step_pure with carry7_2
  bnd carry7_2
  -- s8 += carry7
  step_pure with s8_10
  bnd s8_10
  step_pure
  -- s7 -= (long)((ulong)carry7 << 21)
  step_pure with s7_10
  bnd s7_10
  step_pure
  -- carry9 = (s9 + (1L << 20)) >> 21
  step_pure with carry9_2
  bnd carry9_2
  -- s10 += carry9
  step_pure with s10_10
  bnd s10_10
  step_pure
  -- s9 -= (long)((ulong)carry9 << 21)
  step_pure with s9_10
  bnd s9_10
  step_pure
  -- carry11 = (s11 + (1L << 20)) >> 21
  step_pure with carry11_2
  bnd carry11_2
  step_pure
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_10
  bnd s11_10
  step_pure [nswMul]
  -- s0 += s12*666643L
  step_pure with s0_3
  bnd s0_3
  step_pure [nswMul]
  step_pure [nswMul]
  step_pure [nswMul]
  step_pure [nswMul] with t365
  bnd t365
  step_pure [nswMul] with t366
  bnd t366
  -- carry0 = s0 >> 21
  step_pure with carry0_2
  bnd carry0_2
  step_pure
  -- s1 += s12*470296L
  step_pure with s1_5
  bnd s1_5
  -- s1 += carry0
  step_pure with s1_6
  bnd s1_6
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_4
  bnd s0_4
  -- carry1 = s1 >> 21
  step_pure with carry1_2
  bnd carry1_2
  step_pure
  -- s2 += s12*654183L
  step_pure with s2_6
  bnd s2_6
  -- s2 += carry1
  step_pure with s2_7
  bnd s2_7
  -- s1 -= (long)((ulong)carry1 << 21)
  step_pure with s1_7
  bnd s1_7
  -- carry2 = s2 >> 21
  step_pure with carry2_2
  bnd carry2_2
  step_pure
  -- s3 -= s12*997805L
  step_pure with s3_7
  bnd s3_7
  exact
    hK _ carry1_1 carry3_1 carry5_1 s6_9 t345 carry7_2 s8_10 s7_10 carry9_2 s10_10 s9_10 carry11_2
      s11_10 s0_3 t365 t366 carry0_2 s1_5 s1_6 s0_4 carry1_2 s2_6 s2_7 s1_7 carry2_2 s3_7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry1_1) (by bridge hcarry3_1) (by bridge hcarry5_1)
      (by bridge hs6_9 hcarry5_1) ht345 (by bridge hcarry7_2) (by bridge hs8_10 hcarry7_2)
      (by bridge hs7_10) (by bridge hcarry9_2) (by bridge hs10_10 hcarry9_2) (by bridge hs9_10)
      (by bridge hcarry11_2) (by bridge hs11_10) (by bridge hs0_3 hcarry11_2) ht365 ht366
      (by bridge hcarry0_2) (by bridge hs1_5 hcarry11_2) (by bridge hs1_6 hcarry0_2)
      (by bridge hs0_4) (by bridge hcarry1_2) (by bridge hs2_6 hcarry11_2 hcarry1_1)
      (by bridge hs2_7 hcarry1_2) (by bridge hs1_7) (by bridge hcarry2_2)
      (by bridge hs3_7 hcarry11_2) hbcarry1_1 hbcarry3_1 hbcarry5_1 hbs6_9 hbt345 hbcarry7_2 hbs8_10
      hbs7_10 hbcarry9_2 hbs10_10 hbs9_10 hbcarry11_2 hbs11_10 hbs0_3 hbt365 hbt366 hbcarry0_2
      hbs1_5 hbs1_6 hbs0_4 hbcarry1_2 hbs2_6 hbs2_7 hbs1_7 hbcarry2_2 hbs3_7

/-- From `%380`: the unrounded carries up to `carry11`. -/
theorem fd_curve25519_scalar_reduce.run380 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 380 = fd_curve25519_scalar_reduce.entry.body.drop 380)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s5_7 s4_6 carry3_1 s6_9 t345 s8_10 s7_10 s10_10 s9_10 s11_10 t365 t366 s0_4 s2_7 s1_7 carry2_2
      s3_7 s3_5 s11_9 carry11_2 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%310 := s5_7, %312 := s4_6, %340 := carry3_1, %344 := s6_9, %345 := t345, %348 := s8_10,
        %350 := s7_10, %353 := s10_10, %355 := s9_10, %359 := s11_10, %365 := t365, %366 := t366,
        %371 := s0_4, %375 := s2_7, %376 := s1_7, %377 := carry2_2, %379 := s3_7])
    (hcarry3_1 : carry3_1 = (s3_5 + 1048576#64).sshiftRight 21)
    (ht345 : t345 = ((s5_7 + 1048576#64) &&& 18446744073707454464#64))
    (hcarry11_2 : carry11_2 = (s11_9 + 1048576#64).sshiftRight 21)
    (ht365 : t365 = (carry11_2 * 136657#64)) (ht366 : t366 = (carry11_2 * 18446744073708867715#64))
    (hcarry2_2 : carry2_2 = s2_7.sshiftRight 21)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) (hbs4_6 : Bnd s4_6 (-1048576) 1048575)
    (hbs11_9 : Bnd s11_9 (-1732478) 58143373) (hbs6_9 : Bnd s6_9 (-194138808) 12380602)
    (hbs8_10 : Bnd s8_10 (-127875146) 3485823) (hbs7_10 : Bnd s7_10 (-1048576) 1048575)
    (hbs10_10 : Bnd s10_10 (-24207876) 1750290) (hbs9_10 : Bnd s9_10 (-1048576) 1048575)
    (hbs11_10 : Bnd s11_10 (-1048576) 1048575) (hbs0_4 : Bnd s0_4 0 2097151)
    (hbs2_7 : Bnd s2_7 (-2648360) 58488445) (hbs1_7 : Bnd s1_7 0 2097151)
    (hbs3_7 : Bnd s3_7 (-28987116) 2046380)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s3_8 s2_8 carry3_2 s4_8 s4_9 s3_9 carry4_2 s5_9 s5_10 s4_10 carry5_2 s6_10 s5_11 carry6_3
          s7_11 s6_11 carry7_3 s8_11 s7_12 carry8_3 s9_11 s8_12 carry9_3 s10_11 s9_12 carry10_3
          s11_11 s10_12 carry11_3 s11_12 s0_5 s1_8 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%381 := s2_8, %386 := s3_9, %391 := s4_10, %394 := s5_11, %397 := s6_11, %400 :=
              s7_12, %403 := s8_12, %406 := s9_12, %409 := s10_12, %410 := carry11_3, %411 :=
              s11_12, %413 := s0_5, %415 := s1_8]) →
          (hs3_8 : s3_8 = s3_7 + (s2_7.sshiftRight 21)) →
          (hs2_8 : s2_8 = s2_7 - (s2_7.sshiftRight 21) <<< 21) →
          (hcarry3_2 : carry3_2 = s3_8.sshiftRight 21) →
          (hs4_8 :
            s4_8 =
              (s4_6 + ((s3_5 + 1048576#64).sshiftRight 21)) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 136657#64) →
          (hs4_9 : s4_9 = s4_8 + (s3_8.sshiftRight 21)) →
          (hs3_9 : s3_9 = s3_8 - (s3_8.sshiftRight 21) <<< 21) →
          (hcarry4_2 : carry4_2 = s4_9.sshiftRight 21) →
          (hs5_9 :
            s5_9 =
              (s5_7 - ((s5_7 + 1048576#64).sshiftRight 21) <<< 21) -
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 683901#64) →
          (hs5_10 : s5_10 = s5_9 + (s4_9.sshiftRight 21)) →
          (hs4_10 : s4_10 = s4_9 - (s4_9.sshiftRight 21) <<< 21) →
          (hcarry5_2 : carry5_2 = s5_10.sshiftRight 21) →
          (hs6_10 : s6_10 = s6_9 + (s5_10.sshiftRight 21)) →
          (hs5_11 : s5_11 = s5_10 - (s5_10.sshiftRight 21) <<< 21) →
          (hcarry6_3 : carry6_3 = s6_10.sshiftRight 21) →
          (hs7_11 : s7_11 = s7_10 + (s6_10.sshiftRight 21)) →
          (hs6_11 : s6_11 = s6_10 - (s6_10.sshiftRight 21) <<< 21) →
          (hcarry7_3 : carry7_3 = s7_11.sshiftRight 21) →
          (hs8_11 : s8_11 = s8_10 + (s7_11.sshiftRight 21)) →
          (hs7_12 : s7_12 = s7_11 - (s7_11.sshiftRight 21) <<< 21) →
          (hcarry8_3 : carry8_3 = s8_11.sshiftRight 21) →
          (hs9_11 : s9_11 = s9_10 + (s8_11.sshiftRight 21)) →
          (hs8_12 : s8_12 = s8_11 - (s8_11.sshiftRight 21) <<< 21) →
          (hcarry9_3 : carry9_3 = s9_11.sshiftRight 21) →
          (hs10_11 : s10_11 = s10_10 + (s9_11.sshiftRight 21)) →
          (hs9_12 : s9_12 = s9_11 - (s9_11.sshiftRight 21) <<< 21) →
          (hcarry10_3 : carry10_3 = s10_11.sshiftRight 21) →
          (hs11_11 : s11_11 = s11_10 + (s10_11.sshiftRight 21)) →
          (hs10_12 : s10_12 = s10_11 - (s10_11.sshiftRight 21) <<< 21) →
          (hcarry11_3 : carry11_3 = s11_11.sshiftRight 21) →
          (hs11_12 : s11_12 = s11_11 - (s11_11.sshiftRight 21) <<< 21) →
          (hs0_5 : s0_5 = s0_4 + ((0#64) + (s11_11.sshiftRight 21)) * 666643#64) →
          (hs1_8 : s1_8 = s1_7 + ((0#64) + (s11_11.sshiftRight 21)) * 470296#64) →
          (hbs3_8 : Bnd s3_8 (-28987118) 2046407) →
          (hbs2_8 : Bnd s2_8 0 2097151) →
          (hbcarry3_2 : Bnd carry3_2 (-14) 0) →
          (hbs4_8 : Bnd s4_8 (-84755560) 44656394) →
          (hbs4_9 : Bnd s4_9 (-84755574) 44656394) →
          (hbs3_9 : Bnd s3_9 0 2097151) →
          (hbcarry4_2 : Bnd carry4_2 (-41) 21) →
          (hbs5_9 : Bnd s5_9 (-20197804) 1732476) →
          (hbs5_10 : Bnd s5_10 (-20197845) 1732497) →
          (hbs4_10 : Bnd s4_10 0 2097151) →
          (hbcarry5_2 : Bnd carry5_2 (-10) 0) →
          (hbs6_10 : Bnd s6_10 (-194138818) 12380602) →
          (hbs5_11 : Bnd s5_11 0 2097151) →
          (hbcarry6_3 : Bnd carry6_3 (-93) 5) →
          (hbs7_11 : Bnd s7_11 (-1048669) 1048580) →
          (hbs6_11 : Bnd s6_11 0 2097151) →
          (hbcarry7_3 : Bnd carry7_3 (-1) 0) →
          (hbs8_11 : Bnd s8_11 (-127875147) 3485823) →
          (hbs7_12 : Bnd s7_12 0 2097151) →
          (hbcarry8_3 : Bnd carry8_3 (-61) 1) →
          (hbs9_11 : Bnd s9_11 (-1048637) 1048576) →
          (hbs8_12 : Bnd s8_12 0 2097151) →
          (hbcarry9_3 : Bnd carry9_3 (-1) 0) →
          (hbs10_11 : Bnd s10_11 (-24207877) 1750290) →
          (hbs9_12 : Bnd s9_12 0 2097151) →
          (hbcarry10_3 : Bnd carry10_3 (-12) 0) →
          (hbs11_11 : Bnd s11_11 (-1048588) 1048575) →
          (hbs10_12 : Bnd s10_12 0 2097151) →
          (hbcarry11_3 : Bnd carry11_3 (-1) 0) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbs0_5 : Bnd s0_5 (-666643) 2097151) →
          (hbs1_8 : Bnd s1_8 (-470296) 2097151) → (blk.runBodyFrom E' 416 S >>= g) = K) :
    (blk.runBodyFrom E 380 S >>= g) = K := by
  -- s3 += carry2
  step_pure with s3_8
  bnd s3_8
  -- s2 -= (long)((ulong)carry2 << 21)
  step_pure with s2_8
  bnd s2_8
  -- carry3 = s3 >> 21
  step_pure with carry3_2
  bnd carry3_2
  step_pure
  -- s4 += s12*136657L
  step_pure with s4_8
  bnd s4_8
  -- s4 += carry3
  step_pure with s4_9
  bnd s4_9
  -- s3 -= (long)((ulong)carry3 << 21)
  step_pure with s3_9
  bnd s3_9
  -- carry4 = s4 >> 21
  step_pure with carry4_2
  bnd carry4_2
  step_pure
  -- s5 -= s12*683901L
  step_pure with s5_9
  bnd s5_9
  -- s5 += carry4
  step_pure with s5_10
  bnd s5_10
  -- s4 -= (long)((ulong)carry4 << 21)
  step_pure with s4_10
  bnd s4_10
  -- carry5 = s5 >> 21
  step_pure with carry5_2
  bnd carry5_2
  -- s6 += carry5
  step_pure with s6_10
  bnd s6_10
  -- s5 -= (long)((ulong)carry5 << 21)
  step_pure with s5_11
  bnd s5_11
  -- carry6 = s6 >> 21
  step_pure with carry6_3
  bnd carry6_3
  -- s7 += carry6
  step_pure with s7_11
  bnd s7_11
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure with s6_11
  bnd s6_11
  -- carry7 = s7 >> 21
  step_pure with carry7_3
  bnd carry7_3
  -- s8 += carry7
  step_pure with s8_11
  bnd s8_11
  -- s7 -= (long)((ulong)carry7 << 21)
  step_pure with s7_12
  bnd s7_12
  -- carry8 = s8 >> 21
  step_pure with carry8_3
  bnd carry8_3
  -- s9 += carry8
  step_pure with s9_11
  bnd s9_11
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure with s8_12
  bnd s8_12
  -- carry9 = s9 >> 21
  step_pure with carry9_3
  bnd carry9_3
  -- s10 += carry9
  step_pure with s10_11
  bnd s10_11
  -- s9 -= (long)((ulong)carry9 << 21)
  step_pure with s9_12
  bnd s9_12
  -- carry10 = s10 >> 21
  step_pure with carry10_3
  bnd carry10_3
  -- s11 += carry10
  step_pure with s11_11
  bnd s11_11
  -- s10 -= (long)((ulong)carry10 << 21)
  step_pure with s10_12
  bnd s10_12
  -- carry11 = s11 >> 21
  step_pure with carry11_3
  bnd carry11_3
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_12
  bnd s11_12
  step_pure [nswMul]
  -- s0 += s12*666643L
  step_pure [nswAdd] with s0_5
  bnd s0_5
  step_pure [nswMul]
  -- s1 += s12*470296L
  step_pure [nswAdd] with s1_8
  bnd s1_8
  exact
    hK _ s3_8 s2_8 carry3_2 s4_8 s4_9 s3_9 carry4_2 s5_9 s5_10 s4_10 carry5_2 s6_10 s5_11 carry6_3
      s7_11 s6_11 carry7_3 s8_11 s7_12 carry8_3 s9_11 s8_12 carry9_3 s10_11 s9_12 carry10_3 s11_11
      s10_12 carry11_3 s11_12 s0_5 s1_8 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs3_8) (by bridge hs2_8) (by bridge hcarry3_2) (by bridge hs4_8)
      (by bridge hs4_9 hcarry3_2) (by bridge hs3_9) (by bridge hcarry4_2) (by bridge hs5_9)
      (by bridge hs5_10 hcarry4_2) (by bridge hs4_10) (by bridge hcarry5_2)
      (by bridge hs6_10 hcarry5_2) (by bridge hs5_11) (by bridge hcarry6_3)
      (by bridge hs7_11 hcarry6_3) (by bridge hs6_11) (by bridge hcarry7_3)
      (by bridge hs8_11 hcarry7_3) (by bridge hs7_12) (by bridge hcarry8_3)
      (by bridge hs9_11 hcarry8_3) (by bridge hs8_12) (by bridge hcarry9_3)
      (by bridge hs10_11 hcarry9_3) (by bridge hs9_12) (by bridge hcarry10_3)
      (by bridge hs11_11 hcarry10_3) (by bridge hs10_12) (by bridge hcarry11_3) (by bridge hs11_12)
      (by bridge hs0_5 hcarry11_3) (by bridge hs1_8 hcarry11_3) hbs3_8 hbs2_8 hbcarry3_2 hbs4_8
      hbs4_9 hbs3_9 hbcarry4_2 hbs5_9 hbs5_10 hbs4_10 hbcarry5_2 hbs6_10 hbs5_11 hbcarry6_3 hbs7_11
      hbs6_11 hbcarry7_3 hbs8_11 hbs7_12 hbcarry8_3 hbs9_11 hbs8_12 hbcarry9_3 hbs10_11 hbs9_12
      hbcarry10_3 hbs11_11 hbs10_12 hbcarry11_3 hbs11_12 hbs0_5 hbs1_8

/-- From `%416`: the second `s12` row and the last carries. -/
theorem fd_curve25519_scalar_reduce.run416 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 416 = fd_curve25519_scalar_reduce.entry.body.drop 416)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s2_8 s3_9 s4_10 s5_11 s6_11 s7_12 s8_12 s9_12 s10_12 carry11_3 s11_12 s0_5 s1_8 s11_11 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%381 := s2_8, %386 := s3_9, %391 := s4_10, %394 := s5_11, %397 := s6_11, %400 := s7_12,
        %403 := s8_12, %406 := s9_12, %409 := s10_12, %410 := carry11_3, %411 := s11_12, %413 :=
        s0_5, %415 := s1_8])
    (hcarry11_3 : carry11_3 = s11_11.sshiftRight 21) (hbs2_8 : Bnd s2_8 0 2097151)
    (hbs3_9 : Bnd s3_9 0 2097151) (hbs4_10 : Bnd s4_10 0 2097151) (hbs5_11 : Bnd s5_11 0 2097151)
    (hbs6_11 : Bnd s6_11 0 2097151) (hbs7_12 : Bnd s7_12 0 2097151) (hbs8_12 : Bnd s8_12 0 2097151)
    (hbs9_12 : Bnd s9_12 0 2097151) (hbs11_11 : Bnd s11_11 (-1048588) 1048575)
    (hbs10_12 : Bnd s10_12 0 2097151) (hbs11_12 : Bnd s11_12 0 2097151)
    (hbs0_5 : Bnd s0_5 (-666643) 2097151) (hbs1_8 : Bnd s1_8 (-470296) 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s2_9 s3_10 s4_11 s5_12 carry0_3 s1_9 s0_6 carry1_3 s2_10 carry2_3 s3_11 carry3_3 s4_12
          carry4_3 s5_13 carry5_3 s6_12 carry6_4 s7_13 carry7_4 s8_13 carry8_4 s9_13 carry9_4 s10_13
          carry10_4 s11_13 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%425 := s1_9, %426 := s0_6, %428 := s2_10, %430 := s3_11, %432 := s4_12, %434 :=
              s5_13, %436 := s6_12, %438 := s7_13, %440 := s8_13, %442 := s9_13, %444 := s10_13,
              %446 := s11_13]) →
          (hs2_9 : s2_9 = s2_8 + ((0#64) + (s11_11.sshiftRight 21)) * 654183#64) →
          (hs3_10 : s3_10 = s3_9 - ((0#64) + (s11_11.sshiftRight 21)) * 997805#64) →
          (hs4_11 : s4_11 = s4_10 + ((0#64) + (s11_11.sshiftRight 21)) * 136657#64) →
          (hs5_12 : s5_12 = s5_11 - ((0#64) + (s11_11.sshiftRight 21)) * 683901#64) →
          (hcarry0_3 : carry0_3 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = s1_8 + (s0_5.sshiftRight 21)) →
          (hs0_6 : s0_6 = s0_5 - (s0_5.sshiftRight 21) <<< 21) →
          (hcarry1_3 : carry1_3 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = s2_9 + (s1_9.sshiftRight 21)) →
          (hcarry2_3 : carry2_3 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = s3_10 + (s2_10.sshiftRight 21)) →
          (hcarry3_3 : carry3_3 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = s4_11 + (s3_11.sshiftRight 21)) →
          (hcarry4_3 : carry4_3 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = s5_12 + (s4_12.sshiftRight 21)) →
          (hcarry5_3 : carry5_3 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = s6_11 + (s5_13.sshiftRight 21)) →
          (hcarry6_4 : carry6_4 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = s7_12 + (s6_12.sshiftRight 21)) →
          (hcarry7_4 : carry7_4 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = s8_12 + (s7_13.sshiftRight 21)) →
          (hcarry8_4 : carry8_4 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = s9_12 + (s8_13.sshiftRight 21)) →
          (hcarry9_4 : carry9_4 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = s10_12 + (s9_13.sshiftRight 21)) →
          (hcarry10_4 : carry10_4 = s10_13.sshiftRight 21) →
          (hs11_13 : s11_13 = s11_12 + (s10_13.sshiftRight 21)) →
          (hbs2_9 : Bnd s2_9 (-654183) 2097151) →
          (hbs3_10 : Bnd s3_10 0 3094956) →
          (hbs4_11 : Bnd s4_11 (-136657) 2097151) →
          (hbs5_12 : Bnd s5_12 0 2781052) →
          (hbcarry0_3 : Bnd carry0_3 (-1) 0) →
          (hbs1_9 : Bnd s1_9 (-470297) 2097151) →
          (hbs0_6 : Bnd s0_6 0 2097151) →
          (hbcarry1_3 : Bnd carry1_3 (-1) 0) →
          (hbs2_10 : Bnd s2_10 (-654184) 2097151) →
          (hbcarry2_3 : Bnd carry2_3 (-1) 0) →
          (hbs3_11 : Bnd s3_11 (-1) 3094956) →
          (hbcarry3_3 : Bnd carry3_3 (-1) 1) →
          (hbs4_12 : Bnd s4_12 (-136658) 2097152) →
          (hbcarry4_3 : Bnd carry4_3 (-1) 1) →
          (hbs5_13 : Bnd s5_13 (-1) 2781053) →
          (hbcarry5_3 : Bnd carry5_3 (-1) 1) →
          (hbs6_12 : Bnd s6_12 (-1) 2097152) →
          (hbcarry6_4 : Bnd carry6_4 (-1) 1) →
          (hbs7_13 : Bnd s7_13 (-1) 2097152) →
          (hbcarry7_4 : Bnd carry7_4 (-1) 1) →
          (hbs8_13 : Bnd s8_13 (-1) 2097152) →
          (hbcarry8_4 : Bnd carry8_4 (-1) 1) →
          (hbs9_13 : Bnd s9_13 (-1) 2097152) →
          (hbcarry9_4 : Bnd carry9_4 (-1) 1) →
          (hbs10_13 : Bnd s10_13 (-1) 2097152) →
          (hbcarry10_4 : Bnd carry10_4 (-1) 1) →
          (hbs11_13 : Bnd s11_13 (-1) 2097152) → (blk.runBodyFrom E' 447 S >>= g) = K) :
    (blk.runBodyFrom E 416 S >>= g) = K := by
  step_pure [nswMul]
  -- s2 += s12*654183L
  step_pure [nswAdd] with s2_9
  bnd s2_9
  step_pure [nswMul]
  -- s3 -= s12*997805L
  step_pure [nswAdd] with s3_10
  bnd s3_10
  step_pure [nswMul]
  -- s4 += s12*136657L
  step_pure [nswAdd] with s4_11
  bnd s4_11
  step_pure [nswMul]
  -- s5 -= s12*683901L
  step_pure [nswAdd] with s5_12
  bnd s5_12
  -- carry0 = s0 >> 21
  step_pure with carry0_3
  bnd carry0_3
  -- s1 += carry0
  step_pure [nswAdd] with s1_9
  bnd s1_9
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_6
  bnd s0_6
  -- carry1 = s1 >> 21
  step_pure with carry1_3
  bnd carry1_3
  -- s2 += carry1
  step_pure [nswAdd] with s2_10
  bnd s2_10
  -- carry2 = s2 >> 21
  step_pure with carry2_3
  bnd carry2_3
  -- s3 += carry2
  step_pure [nswAdd] with s3_11
  bnd s3_11
  -- carry3 = s3 >> 21
  step_pure with carry3_3
  bnd carry3_3
  -- s4 += carry3
  step_pure [nswAdd] with s4_12
  bnd s4_12
  -- carry4 = s4 >> 21
  step_pure with carry4_3
  bnd carry4_3
  -- s5 += carry4
  step_pure [nswAdd] with s5_13
  bnd s5_13
  -- carry5 = s5 >> 21
  step_pure with carry5_3
  bnd carry5_3
  -- s6 += carry5
  step_pure [nswAdd] with s6_12
  bnd s6_12
  -- carry6 = s6 >> 21
  step_pure with carry6_4
  bnd carry6_4
  -- s7 += carry6
  step_pure [nswAdd] with s7_13
  bnd s7_13
  -- carry7 = s7 >> 21
  step_pure with carry7_4
  bnd carry7_4
  -- s8 += carry7
  step_pure [nswAdd] with s8_13
  bnd s8_13
  -- carry8 = s8 >> 21
  step_pure with carry8_4
  bnd carry8_4
  -- s9 += carry8
  step_pure [nswAdd] with s9_13
  bnd s9_13
  -- carry9 = s9 >> 21
  step_pure with carry9_4
  bnd carry9_4
  -- s10 += carry9
  step_pure [nswAdd] with s10_13
  bnd s10_13
  -- carry10 = s10 >> 21
  step_pure with carry10_4
  bnd carry10_4
  -- s11 += carry10
  step_pure [nswAdd] with s11_13
  bnd s11_13
  exact
    hK _ s2_9 s3_10 s4_11 s5_12 carry0_3 s1_9 s0_6 carry1_3 s2_10 carry2_3 s3_11 carry3_3 s4_12
      carry4_3 s5_13 carry5_3 s6_12 carry6_4 s7_13 carry7_4 s8_13 carry8_4 s9_13 carry9_4 s10_13
      carry10_4 s11_13 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs2_9) (by bridge hs3_10) (by bridge hs4_11) (by bridge hs5_12)
      (by bridge hcarry0_3) (by bridge hs1_9 hcarry0_3) (by bridge hs0_6) (by bridge hcarry1_3)
      (by bridge hs2_10 hcarry1_3) (by bridge hcarry2_3) (by bridge hs3_11 hcarry2_3)
      (by bridge hcarry3_3) (by bridge hs4_12 hcarry3_3) (by bridge hcarry4_3)
      (by bridge hs5_13 hcarry4_3) (by bridge hcarry5_3) (by bridge hs6_12 hcarry5_3)
      (by bridge hcarry6_4) (by bridge hs7_13 hcarry6_4) (by bridge hcarry7_4)
      (by bridge hs8_13 hcarry7_4) (by bridge hcarry8_4) (by bridge hs9_13 hcarry8_4)
      (by bridge hcarry9_4) (by bridge hs10_13 hcarry9_4) (by bridge hcarry10_4)
      (by bridge hs11_13 hcarry10_4) hbs2_9 hbs3_10 hbs4_11 hbs5_12 hbcarry0_3 hbs1_9 hbs0_6
      hbcarry1_3 hbs2_10 hbcarry2_3 hbs3_11 hbcarry3_3 hbs4_12 hbcarry4_3 hbs5_13 hbcarry5_3 hbs6_12
      hbcarry6_4 hbs7_13 hbcarry7_4 hbs8_13 hbcarry8_4 hbs9_13 hbcarry9_4 hbs10_13 hbcarry10_4
      hbs11_13

/-- From `%447`: the limbs packed into four words, stored at `out`. -/
theorem fd_curve25519_scalar_reduce.run447 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 447 = fd_curve25519_scalar_reduce.entry.body.drop 447)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_9 s0_6 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 s11_13 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hout : Fits S.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%425 := s1_9, %426 := s0_6, %428 := s2_10, %430 := s3_11, %432 := s4_12, %434 := s5_13,
        %436 := s6_12, %438 := s7_13, %440 := s8_13, %442 := s9_13, %444 := s10_13, %446 := s11_13])
    (hbs7_13 : Bnd s7_13 (-1) 2097152) (hbs8_13 : Bnd s8_13 (-1) 2097152)
    (hbs10_13 : Bnd s10_13 (-1) 2097152) (hbs11_13 : Bnd s11_13 (-1) 2097152)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (out0 out1 out2 out3 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hout0 :
            out0 =
              s0_6 ||| (s1_9 - (s1_9.sshiftRight 21) <<< 21) <<< 21 |||
                (s2_10 - (s2_10.sshiftRight 21) <<< 21) <<< 42 |||
                (s3_11 - (s3_11.sshiftRight 21) <<< 21) <<< 63) →
          (hout1 :
            out1 =
              (s3_11 - (s3_11.sshiftRight 21) <<< 21) >>> 1 |||
                (s4_12 - (s4_12.sshiftRight 21) <<< 21) <<< 20 |||
                (s5_13 - (s5_13.sshiftRight 21) <<< 21) <<< 41 |||
                (s6_12 - (s6_12.sshiftRight 21) <<< 21) <<< 62) →
          (hout2 :
            out2 =
              (s6_12 - (s6_12.sshiftRight 21) <<< 21) >>> 2 |||
                (s7_13 - (s7_13.sshiftRight 21) <<< 21) <<< 19 |||
                (s8_13 - (s8_13.sshiftRight 21) <<< 21) <<< 40 |||
                (s9_13 - (s9_13.sshiftRight 21) <<< 21) <<< 61) →
          (hout3 :
            out3 =
              (s9_13 - (s9_13.sshiftRight 21) <<< 21) >>> 3 |||
                (s10_13 - (s10_13.sshiftRight 21) <<< 21) <<< 18 |||
                s11_13 <<< 39) →
          (blk.runBodyFrom E' 489
                { S with
                  mem :=
                    (((S.mem.storeAt out out0).storeAt (out.add 8#64) out1).storeAt (out.add 16#64)
                          out2).storeAt
                      (out.add 24#64) out3 } >>=
              g) =
            K) :
    (blk.runBodyFrom E 447 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with out0
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with out1
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure
  step_pure
  step_pure
  step_pure with out2
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure with out3
  step_pure
  step_store
  subst hS
  exact
    hK _ out0 out1 out2 out3 hArgs (by bridge_bv hout0) (by bridge_bv hout1) (by bridge_bv hout2)
      (by bridge_bv hout3)

/-- `reduce` stores `spec` of the 64 bytes at `inp` as the 32 bytes at `out`, and returns `out`. The
loads all come before the stores, so `out` may alias `inp`. -/
public theorem fd_curve25519_scalar_reduce.call_eq (out inp : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Fits s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hin : Fits s.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64) :
    fd_curve25519_scalar_reduce.call (fd_curve25519_scalar_reduce.args (.value out) (.value inp))
        s =
      .value
        (.cons (.value out) .nil,
          { s with
            mem :=
              s.mem.storeAt out (fd_curve25519_scalar_reduce.spec (s.mem.readAt inp 512)) }) := by
  func_init
  block_init
  step_pattern using fd_curve25519_scalar_reduce.run0
  -- the loads' facts, about the entry state rather than the current one
  rw [hS] at hin0 hin1 hin2 hin3 hin4 hin5 hin6 hin7
  step_pattern using fd_curve25519_scalar_reduce.run61
  step_pattern using fd_curve25519_scalar_reduce.run107
  step_pattern using fd_curve25519_scalar_reduce.run136
  step_pattern using fd_curve25519_scalar_reduce.run181
  step_pattern using fd_curve25519_scalar_reduce.run208
  step_pattern using fd_curve25519_scalar_reduce.run234
  step_pattern using fd_curve25519_scalar_reduce.run269
  step_pattern using fd_curve25519_scalar_reduce.run303
  step_pattern using fd_curve25519_scalar_reduce.run336
  step_pattern using fd_curve25519_scalar_reduce.run380
  step_pattern using fd_curve25519_scalar_reduce.run416
  step_pattern using fd_curve25519_scalar_reduce.run447
  finish_block
  -- the four 8-byte stores as one 32-byte store
  have hov (k : Nat) (hk : k ≤ 32) : ¬out.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le hout_off
      (by
        simp; omega)
  rw [hS, MemoryState.storeAt_storeAt_add (hov 8 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (hov 16 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (hov 24 (by decide)) rfl (by decide)]
  -- the named values' C forms, substituted, are the spec's lets
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Ref

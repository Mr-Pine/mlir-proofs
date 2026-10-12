module

public import Firedancer.Common.Limbs
public import Agave.Math.Scalar
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The scalar functions' bv-level specs, shared by the serial and AVX2 trees, and what they mean
as numbers mod `ℓ`. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Specifications -/

@[expose] public section

/-- `Scalar52::sub(a, &L)`: `a - ℓ` limbwise with borrows, then `conditional_add_l` of the last
borrow, adding `ℓ` back when it is set. -/
def Scalar52_sub.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let l := Scalar52.L
  let mask := 0xfffffffffffff#64
  -- `borrow = a[i].wrapping_sub(b[i] + (borrow >> 63)); difference[i] = borrow & mask;`
  let borrow0 := a 0 - l 0
  let borrow1 := a 1 - (l 1 + (borrow0 >>> 63))
  let borrow2 := a 2 - (l 2 + (borrow1 >>> 63))
  let borrow3 := a 3 - (l 3 + (borrow2 >>> 63))
  let borrow4 := a 4 - (l 4 + (borrow3 >>> 63))
  -- `Choice::from((borrow >> 63) as u8)`
  let condition := (borrow4 >>> 63).setWidth 8
  -- `u64::conditional_select(&0, &L[i], condition)`
  let addend := fun i => (0#64 - condition.setWidth 64) &&& l i
  -- `carry = (carry >> 52) + self[i] + addend; self[i] = carry & mask;`
  let carry0 := (borrow0 &&& mask) + addend 0
  let carry1 := (carry0 >>> 52) + (borrow1 &&& mask) + addend 1
  let carry2 := (carry1 >>> 52) + (borrow2 &&& mask) + addend 2
  let carry3 := (carry2 >>> 52) + (borrow3 &&& mask) + addend 3
  let carry4 := (carry3 >>> 52) + (borrow4 &&& mask) + addend 4
  fun
  | ⟨0, _⟩ => carry0 &&& mask
  | ⟨1, _⟩ => carry1 &&& mask
  | ⟨2, _⟩ => carry2 &&& mask
  | ⟨3, _⟩ => carry3 &&& mask
  | ⟨4, _⟩ => carry4 &&& mask

/-- `m(x, y)`: the 128-bit product. -/
abbrev Scalar52.m (x y : BitVec 64) : BitVec 128 :=
  x.setWidth 128 * y.setWidth 128

/-- `Scalar52::mul_internal(a, b)`: the nine columns of `a b`, in the compiled operand order. -/
def Scalar52_mul_internal.spec (a b : Fin 5 → BitVec 64) : Fin 9 → BitVec 128
  | ⟨0, _⟩ => Scalar52.m (b 0) (a 0)
  | ⟨1, _⟩ => Scalar52.m (a 1) (b 0) + Scalar52.m (b 1) (a 0)
  | ⟨2, _⟩ => Scalar52.m (b 2) (a 0) + Scalar52.m (a 1) (b 1) + Scalar52.m (a 2) (b 0)
  | ⟨3, _⟩ =>
    Scalar52.m (a 2) (b 1) + Scalar52.m (b 2) (a 1) + Scalar52.m (b 3) (a 0) +
      Scalar52.m (a 3) (b 0)
  | ⟨4, _⟩ =>
    Scalar52.m (b 3) (a 1) + Scalar52.m (a 2) (b 2) + Scalar52.m (a 3) (b 1) +
      Scalar52.m (b 4) (a 0) +
      Scalar52.m (a 4) (b 0)
  | ⟨5, _⟩ =>
    Scalar52.m (a 3) (b 2) + Scalar52.m (b 3) (a 2) + Scalar52.m (b 4) (a 1) +
      Scalar52.m (a 4) (b 1)
  | ⟨6, _⟩ => Scalar52.m (b 4) (a 2) + Scalar52.m (a 3) (b 3) + Scalar52.m (a 4) (b 2)
  | ⟨7, _⟩ => Scalar52.m (a 4) (b 3) + Scalar52.m (b 4) (a 3)
  | ⟨8, _⟩ => Scalar52.m (a 4) (b 4)

/-- `Scalar52::montgomery_reduce(limbs)` before its final `sub`: `part1` makes columns 0 … 4
divisible by `2^52` with multipliers `n0 … n4`, `part2` splits off the limbs `r0 … r4`. In the
compiled operand order, `m(n, L[4])` as `n << 44`. -/
def Scalar52_montgomery_reduce.limbs (z : Fin 9 → BitVec 128) : Fin 5 → BitVec 64 :=
  let mask := 0xfffffffffffff#64
  let lfactor := Scalar52.LFACTOR
  let l0 := 0x0002631a5cf5d3ed#128
  let l1 := 0x000dea2f79cd6581#128
  let l2 := 0x000000000014def9#128
  -- `part1(sum)`: `p = (sum as u64).wrapping_mul(LFACTOR) & mask`, `(sum + m(p, L[0])) >> 52`
  let n0 := (z 0).setWidth 64 * lfactor &&& mask
  let carry0 := (n0.setWidth 128 * l0 + z 0) >>> 52
  let sum1 := n0.setWidth 128 * l1 + z 1 + carry0
  let n1 := sum1.setWidth 64 * lfactor &&& mask
  let carry1 := (n1.setWidth 128 * l0 + sum1) >>> 52
  let sum2 := z 2 + n0.setWidth 128 * l2 + n1.setWidth 128 * l1 + carry1
  let n2 := sum2.setWidth 64 * lfactor &&& mask
  let carry2 := (n2.setWidth 128 * l0 + sum2) >>> 52
  let sum3 := n1.setWidth 128 * l2 + z 3 + n2.setWidth 128 * l1 + carry2
  let n3 := sum3.setWidth 64 * lfactor &&& mask
  let carry3 := (n3.setWidth 128 * l0 + sum3) >>> 52
  let sum4 := z 4 + (n0.setWidth 128 <<< 44) + n2.setWidth 128 * l2 + n3.setWidth 128 * l1 + carry3
  let n4 := sum4.setWidth 64 * lfactor &&& mask
  let carry4 := (n4.setWidth 128 * l0 + sum4) >>> 52
  -- `part2(sum)`: `(sum >> 52, (sum as u64) & mask)`
  let sum5 := (n1.setWidth 128 <<< 44) + z 5 + n3.setWidth 128 * l2 + n4.setWidth 128 * l1 + carry4
  let r0 := sum5.setWidth 64 &&& mask
  let sum6 := (n2.setWidth 128 <<< 44) + z 6 + n4.setWidth 128 * l2 + (sum5 >>> 52)
  let r1 := sum6.setWidth 64 &&& mask
  let sum7 := (n3.setWidth 128 <<< 44) + z 7 + (sum6 >>> 52)
  let r2 := sum7.setWidth 64 &&& mask
  let sum8 := (n4.setWidth 128 <<< 44) + z 8 + (sum7 >>> 52)
  let r3 := sum8.setWidth 64 &&& mask
  let r4 := (sum8 >>> 52).setWidth 64
  fun
  | ⟨0, _⟩ => r0
  | ⟨1, _⟩ => r1
  | ⟨2, _⟩ => r2
  | ⟨3, _⟩ => r3
  | ⟨4, _⟩ => r4

/-- `Scalar52::montgomery_reduce(limbs)`: the limbs less `ℓ` when possible. -/
def Scalar52_montgomery_reduce.spec (z : Fin 9 → BitVec 128) : Fin 5 → BitVec 64 :=
  Scalar52_sub.spec (Scalar52_montgomery_reduce.limbs z)

/-- `Scalar52::montgomery_mul(a, b)`: `a b / 2^260` mod `ℓ`. -/
def Scalar52_montgomery_mul.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Scalar52_montgomery_reduce.spec (Scalar52_mul_internal.spec a b)

/-- `Scalar52::to_bytes(self)`'s bytes `s[0] … s[31]`: `s[6]` and `s[19]` straddle two limbs. -/
def Scalar52_to_bytes.bytes (l : Fin 5 → BitVec 64) : Fin 32 → BitVec 8
  | ⟨0, _⟩ => (l 0 >>> 0).setWidth 8
  | ⟨1, _⟩ => (l 0 >>> 8).setWidth 8
  | ⟨2, _⟩ => (l 0 >>> 16).setWidth 8
  | ⟨3, _⟩ => (l 0 >>> 24).setWidth 8
  | ⟨4, _⟩ => (l 0 >>> 32).setWidth 8
  | ⟨5, _⟩ => (l 0 >>> 40).setWidth 8
  | ⟨6, _⟩ => (l 0 >>> 48 ||| l 1 <<< 4).setWidth 8
  | ⟨7, _⟩ => (l 1 >>> 4).setWidth 8
  | ⟨8, _⟩ => (l 1 >>> 12).setWidth 8
  | ⟨9, _⟩ => (l 1 >>> 20).setWidth 8
  | ⟨10, _⟩ => (l 1 >>> 28).setWidth 8
  | ⟨11, _⟩ => (l 1 >>> 36).setWidth 8
  | ⟨12, _⟩ => (l 1 >>> 44).setWidth 8
  | ⟨13, _⟩ => (l 2 >>> 0).setWidth 8
  | ⟨14, _⟩ => (l 2 >>> 8).setWidth 8
  | ⟨15, _⟩ => (l 2 >>> 16).setWidth 8
  | ⟨16, _⟩ => (l 2 >>> 24).setWidth 8
  | ⟨17, _⟩ => (l 2 >>> 32).setWidth 8
  | ⟨18, _⟩ => (l 2 >>> 40).setWidth 8
  | ⟨19, _⟩ => (l 2 >>> 48 ||| l 3 <<< 4).setWidth 8
  | ⟨20, _⟩ => (l 3 >>> 4).setWidth 8
  | ⟨21, _⟩ => (l 3 >>> 12).setWidth 8
  | ⟨22, _⟩ => (l 3 >>> 20).setWidth 8
  | ⟨23, _⟩ => (l 3 >>> 28).setWidth 8
  | ⟨24, _⟩ => (l 3 >>> 36).setWidth 8
  | ⟨25, _⟩ => (l 3 >>> 44).setWidth 8
  | ⟨26, _⟩ => (l 4 >>> 0).setWidth 8
  | ⟨27, _⟩ => (l 4 >>> 8).setWidth 8
  | ⟨28, _⟩ => (l 4 >>> 16).setWidth 8
  | ⟨29, _⟩ => (l 4 >>> 24).setWidth 8
  | ⟨30, _⟩ => (l 4 >>> 32).setWidth 8
  | ⟨31, _⟩ => (l 4 >>> 40).setWidth 8
  | ⟨_ + 32, h⟩ => absurd h (by omega)

/-- `Scalar52::to_bytes(self)`: its 32 bytes, `s[0]` lowest. -/
def Scalar52_to_bytes.spec (l : Fin 5 → BitVec 64) : BitVec 256 :=
  let s := Scalar52_to_bytes.bytes l
  s 31 ++
    (s 30 ++
      (s 29 ++
        (s 28 ++
          (s 27 ++
            (s 26 ++
              (s 25 ++
                (s 24 ++
                  (s 23 ++
                    (s 22 ++
                      (s 21 ++
                        (s 20 ++
                          (s 19 ++
                            (s 18 ++
                              (s 17 ++
                                (s 16 ++
                                  (s 15 ++
                                    (s 14 ++
                                      (s 13 ++
                                        (s 12 ++
                                          (s 11 ++
                                            (s 10 ++
                                              (s 9 ++
                                                (s 8 ++
                                                  (s 7 ++
                                                    (s 6 ++
                                                      (s 5 ++
                                                        (s 4 ++
                                                          (s 3 ++
                                                            (s 2 ++
                                                              (s 1 ++
                                                                s 0))))))))))))))))))))))))))))))

/-- `Scalar52::pack(self)`: `to_bytes`. -/
def Scalar52_pack.spec (l : Fin 5 → BitVec 64) : BitVec 256 :=
  Scalar52_to_bytes.spec l

end

/-! ## Memory -/

/-- `storeLimbs` as the five stores the code makes, given each limb. -/
public theorem storeLimbs_of_eq {m : MemoryState} {p : Pointer} {x : Fin 5 → BitVec 64}
    {y0 y1 y2 y3 y4 : BitVec 64} (h0 : x 0 = y0) (h1 : x 1 = y1) (h2 : x 2 = y2) (h3 : x 3 = y3)
    (h4 : x 4 = y4) :
    m.storeLimbs p x =
      ((((m.storeAt p y0).storeAt (p.add 8#64) y1).storeAt (p.add 16#64) y2).storeAt (p.add 24#64)
            y3).storeAt
        (p.add 32#64) y4 := by
  subst h0 h1 h2 h3 h4
  rfl

/-- A store right after another: one store of both. -/
public theorem storeAt_storeAt_concat {m : MemoryState} {p : Pointer} {off : BitVec 64}
    {x : BitVec v} {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-! ## Meaning -/

namespace Scalar52

@[expose] public section

/-- Limbs below `2^52`. -/
abbrev Bounded (l : Fin 5 → BitVec 64) : Prop :=
  ∀ i, (l i).toNat < 2 ^ 52

/-- The limbs as one 260-bit number, limb `i` at bit `52 i`. -/
def bits (l : Fin 5 → BitVec 64) : BitVec 260 :=
  (l 0).setWidth 260 + (l 1).setWidth 260 <<< 52 + (l 2).setWidth 260 <<< 104 +
    (l 3).setWidth 260 <<< 156 +
    (l 4).setWidth 260 <<< 208

end

/-- Bounded limbs' `bits` are their number. -/
public theorem toNat_bits {l : Fin 5 → BitVec 64} (h : Bounded l) : (bits l).toNat = nat l := by
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3; have h4 := h 4
  simp only [bits, nat, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth]
  rw [Nat.mod_eq_of_lt (a := (l 0).toNat) (by omega),
    Nat.mod_eq_of_lt (a := (l 1).toNat) (by omega), Nat.mod_eq_of_lt (a := (l 2).toNat) (by omega),
    Nat.mod_eq_of_lt (a := (l 3).toNat) (by omega), Nat.mod_eq_of_lt (a := (l 4).toNat) (by omega),
    Nat.shiftLeft_eq, Nat.shiftLeft_eq, Nat.shiftLeft_eq, Nat.shiftLeft_eq]
  omega

end Scalar52

namespace Scalar52_sub

/-- The spec's limbs are below `2^52`. -/
public theorem spec_bounded (a : Fin 5 → BitVec 64) : Scalar52.Bounded (spec a) := by
  intro i
  have hm : ∀ x : BitVec 64, (x &&& 0xfffffffffffff#64).toNat < 2 ^ 52 := fun x => by
    rw [BitVec.toNat_and]
    exact lt_of_le_of_lt Nat.and_le_right (by decide)
  fin_cases i <;> exact hm _

/-- `bits` of the spec: `a` less `ℓ` when that is not negative, for bounded limbs. -/
theorem bits_spec {a : Fin 5 → BitVec 64} (h : Scalar52.Bounded a) :
    Scalar52.bits (spec a) =
      if Scalar52.bits a < BitVec.ofNat 260 ell then Scalar52.bits a
      else Scalar52.bits a - BitVec.ofNat 260 ell := by
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3; have h4 := h 4
  obtain ⟨a0, ha0⟩ : ∃ x, a 0 = x := ⟨_, rfl⟩
  obtain ⟨a1, ha1⟩ : ∃ x, a 1 = x := ⟨_, rfl⟩
  obtain ⟨a2, ha2⟩ : ∃ x, a 2 = x := ⟨_, rfl⟩
  obtain ⟨a3, ha3⟩ : ∃ x, a 3 = x := ⟨_, rfl⟩
  obtain ⟨a4, ha4⟩ : ∃ x, a 4 = x := ⟨_, rfl⟩
  rw [ha0] at h0; rw [ha1] at h1; rw [ha2] at h2; rw [ha3] at h3; rw [ha4] at h4
  have e :
    BitVec.ofNat 260 ell =
      7237005577332262213973186563042994240857116359379907606001950938285454250989#260 := by
    decide +kernel
  simp only [Scalar52.bits, spec, Scalar52.L, Matrix.cons_val, ha0, ha1, ha2, ha3, ha4, e]
  replace h0 : a0 < 0x10000000000000#64 := h0
  replace h1 : a1 < 0x10000000000000#64 := h1
  replace h2 : a2 < 0x10000000000000#64 := h2
  replace h3 : a3 < 0x10000000000000#64 := h3
  replace h4 : a4 < 0x10000000000000#64 := h4
  bv_decide

-- unification compares `2 ^ 260` with `BitVec.toNat_ofNat`'s modulus
set_option exponentiation.threshold 260 in
/-- For bounded limbs, the spec is `a` less `ℓ` when that is not negative: `a mod ℓ` for
`a < 2 ℓ`. -/
public theorem nat_spec {a : Fin 5 → BitVec 64} (h : Scalar52.Bounded a) :
    Scalar52.nat (spec a) =
      if Scalar52.nat a < ell then Scalar52.nat a else Scalar52.nat a - ell := by
  have hl : Scalar52.nat a < 2 ^ 260 := Scalar52.nat_lt h
  have hell : ell < 2 ^ 260 := by decide +kernel
  have e := congrArg BitVec.toNat (bits_spec h)
  rw [Scalar52.toNat_bits (spec_bounded a)] at e
  rw [e]
  have hL : (BitVec.ofNat 260 ell).toNat = ell := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt hell
  have hlt : Scalar52.bits a < BitVec.ofNat 260 ell ↔ Scalar52.nat a < ell := by
    rw [BitVec.lt_def, Scalar52.toNat_bits h, hL]
  by_cases h1 : Scalar52.nat a < ell
  · simp only [hlt.2 h1, h1, ↓reduceIte, Scalar52.toNat_bits h]
  · simp only [mt hlt.1 h1, h1, ↓reduceIte]
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, Scalar52.toNat_bits h, hL]; omega),
      Scalar52.toNat_bits h, hL]

/-- Below `2 ℓ`, the spec reduces mod `ℓ`. -/
public theorem nat_spec_mod {a : Fin 5 → BitVec 64} (h : Scalar52.Bounded a)
    (h2 : Scalar52.nat a < 2 * ell) : Scalar52.nat (spec a) = Scalar52.nat a % ell := by
  rw [nat_spec h, Scalar52.sub_ell_eq_mod h2]

end Scalar52_sub

/-! ### `montgomery_mul` -/

namespace Scalar52

public theorem toNat_m (x y : BitVec 64) : (m x y).toNat = x.toNat * y.toNat := by
  have hx := x.isLt; have hy := y.isLt
  rw [m, BitVec.toNat_mul, BitVec.toNat_setWidth, BitVec.toNat_setWidth,
    Nat.mod_eq_of_lt (by omega : x.toNat < 2 ^ 128),
    Nat.mod_eq_of_lt (by omega : y.toNat < 2 ^ 128), Nat.mod_eq_of_lt]
  calc
    x.toNat * y.toNat < 2 ^ 64 * 2 ^ 64 := Nat.mul_lt_mul'' hx hy
    _ = 2 ^ 128 := by rw [← Nat.pow_add]

end Scalar52

namespace Scalar52_mul_internal

-- `ring` must evaluate the weights, up to `2^416`
set_option exponentiation.threshold 500 in
open Scalar52 in
/-- The columns as numbers, below `2^107`, weighted by `2^(52 k)` sum to `a b`. -/
public theorem toNat_spec {a b : Fin 5 → BitVec 64} (ha : Bounded a) (hb : Bounded b) :
    (∀ k, (spec a b k).toNat < 2 ^ 107) ∧
      (spec a b 0).toNat + (spec a b 1).toNat * 2 ^ 52 + (spec a b 2).toNat * 2 ^ 104 +
          (spec a b 3).toNat * 2 ^ 156 +
          (spec a b 4).toNat * 2 ^ 208 +
          (spec a b 5).toNat * 2 ^ 260 +
          (spec a b 6).toNat * 2 ^ 312 +
          (spec a b 7).toNat * 2 ^ 364 +
          (spec a b 8).toNat * 2 ^ 416 =
        nat a * nat b := by
  have hp : ∀ i j, (a i).toNat * (b j).toNat < 2 ^ 104 := fun i j =>
    calc
      (a i).toNat * (b j).toNat < 2 ^ 52 * 2 ^ 52 := Nat.mul_lt_mul'' (ha i) (hb j)
      _ = 2 ^ 104 := by rw [← Nat.pow_add]
  have hp' : ∀ i j, (b j).toNat * (a i).toNat < 2 ^ 104 := fun i j => by
    rw [Nat.mul_comm]; exact hp i j
  have h00 := hp 0 0; have h01 := hp 0 1; have h02 := hp 0 2; have h03 := hp 0 3
  have h04 := hp 0 4; have h10 := hp 1 0; have h11 := hp 1 1; have h12 := hp 1 2
  have h13 := hp 1 3; have h14 := hp 1 4; have h20 := hp 2 0; have h21 := hp 2 1
  have h22 := hp 2 2; have h23 := hp 2 3; have h24 := hp 2 4; have h30 := hp 3 0
  have h31 := hp 3 1; have h32 := hp 3 2; have h33 := hp 3 3; have h34 := hp 3 4
  have h40 := hp 4 0; have h41 := hp 4 1; have h42 := hp 4 2; have h43 := hp 4 3
  have h44 := hp 4 4
  have g00 := hp' 0 0; have g01 := hp' 0 1; have g02 := hp' 0 2; have g03 := hp' 0 3
  have g04 := hp' 0 4; have g10 := hp' 1 0; have g11 := hp' 1 1; have g12 := hp' 1 2
  have g13 := hp' 1 3; have g14 := hp' 1 4; have g20 := hp' 2 0; have g21 := hp' 2 1
  have g22 := hp' 2 2; have g23 := hp' 2 3; have g24 := hp' 2 4; have g30 := hp' 3 0
  have g31 := hp' 3 1; have g32 := hp' 3 2; have g33 := hp' 3 3; have g34 := hp' 3 4
  have g40 := hp' 4 0; have g41 := hp' 4 1; have g42 := hp' 4 2; have g43 := hp' 4 3
  have g44 := hp' 4 4
  have e0 : (spec a b 0).toNat = (b 0).toNat * (a 0).toNat := by simp only [spec, toNat_m]
  have e1 : (spec a b 1).toNat = (a 1).toNat * (b 0).toNat + (b 1).toNat * (a 0).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e2 :
    (spec a b 2).toNat =
      (b 2).toNat * (a 0).toNat + (a 1).toNat * (b 1).toNat + (a 2).toNat * (b 0).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e3 :
    (spec a b 3).toNat =
      (a 2).toNat * (b 1).toNat + (b 2).toNat * (a 1).toNat + (b 3).toNat * (a 0).toNat +
        (a 3).toNat * (b 0).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e4 :
    (spec a b 4).toNat =
      (b 3).toNat * (a 1).toNat + (a 2).toNat * (b 2).toNat + (a 3).toNat * (b 1).toNat +
        (b 4).toNat * (a 0).toNat +
        (a 4).toNat * (b 0).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e5 :
    (spec a b 5).toNat =
      (a 3).toNat * (b 2).toNat + (b 3).toNat * (a 2).toNat + (b 4).toNat * (a 1).toNat +
        (a 4).toNat * (b 1).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e6 :
    (spec a b 6).toNat =
      (b 4).toNat * (a 2).toNat + (a 3).toNat * (b 3).toNat + (a 4).toNat * (b 2).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e7 : (spec a b 7).toNat = (a 4).toNat * (b 3).toNat + (b 4).toNat * (a 3).toNat := by
    simp (disch := omega) only [spec, BitVec.toNat_add, toNat_m, Nat.mod_eq_of_lt]
  have e8 : (spec a b 8).toNat = (a 4).toNat * (b 4).toNat := by simp only [spec, toNat_m]
  refine ⟨fun k => ?_, ?_⟩
  · fin_cases k
    exacts [e0 ▸ by omega, e1 ▸ by omega, e2 ▸ by omega, e3 ▸ by omega, e4 ▸ by omega,
      e5 ▸ by omega, e6 ▸ by omega, e7 ▸ by omega, e8 ▸ by omega]
  · rw [e0, e1, e2, e3, e4, e5, e6, e7, e8, nat, nat]
    ring

end Scalar52_mul_internal

namespace Scalar52_montgomery_reduce

public theorem toNat_zext_mul (n : BitVec 64) (c : BitVec 128) :
    (n.setWidth 128 * c).toNat = n.toNat * c.toNat % 2 ^ 128 := by
  rw [BitVec.toNat_mul, BitVec.toNat_setWidth,
    Nat.mod_eq_of_lt (a := n.toNat)
      (by
        have := n.isLt; omega)]

public theorem toNat_shl44 (n : BitVec 64) : (n.setWidth 128 <<< 44).toNat = n.toNat * 2 ^ 44 := by
  have := n.isLt
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq,
    Nat.mod_eq_of_lt (a := n.toNat) (by omega), Nat.mod_eq_of_lt (by omega)]

public theorem toNat_lo (x : BitVec 128) :
    (x.setWidth 64 &&& 0xfffffffffffff#64).toNat = x.toNat % 2 ^ 52 := by
  rw [BitVec.toNat_and, show (0xfffffffffffff#64).toNat = 2 ^ 52 - 1 from rfl,
    Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_setWidth,
    Nat.mod_mod_of_dvd _ (by decide : 2 ^ 52 ∣ 2 ^ 64)]

/-- `part1`: the multiplier, and the column with it divided exactly by `2^52`. -/
public theorem part1 (s : BitVec 128) (hs : s.toNat < 2 ^ 110) :
    (s.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64).toNat < 2 ^ 52 ∧
      (((s.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64).setWidth 128 *
                  0x0002631a5cf5d3ed#128 +
                s) >>>
              52).toNat *
          2 ^ 52 =
        s.toNat +
          (s.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64).toNat * 671914833335277 ∧
      (((s.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64).setWidth 128 *
                0x0002631a5cf5d3ed#128 +
              s) >>>
            52).toNat <
        2 ^ 59 := by
  obtain ⟨n, hn⟩ : ∃ n, s.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64 = n := ⟨_, rfl⟩
  have hnv := Scalar52.part1_p s
  rw [hn] at hnv ⊢
  have hnl : n.toNat < 2 ^ 52 := by
    rw [hnv]; exact Nat.mod_lt _ (by decide)
  have hd := Scalar52.part1_dvd s.toNat
  rw [← hnv, show (Scalar52.L 0).toNat = 671914833335277 from rfl] at hd
  have hm : (n.setWidth 128 * 0x0002631a5cf5d3ed#128).toNat = n.toNat * 671914833335277 := by
    rw [toNat_zext_mul, show (0x0002631a5cf5d3ed#128 : BitVec 128).toNat = 671914833335277 from rfl,
      Nat.mod_eq_of_lt (by omega)]
  have ha :
    (n.setWidth 128 * 0x0002631a5cf5d3ed#128 + s).toNat = s.toNat + n.toNat * 671914833335277 := by
    rw [BitVec.toNat_add_of_lt (by omega), hm]; omega
  rw [BitVec.toNat_ushiftRight, ha, Nat.shiftRight_eq_div_pow]
  refine ⟨hnl, Nat.div_mul_cancel (Nat.dvd_of_mod_eq_zero hd), ?_⟩
  rw [Nat.div_lt_iff_lt_mul (by decide)]
  omega

/-- `toNat` of a sum that does not wrap. -/
public theorem toNat_add_eq {x y : BitVec 128} {a b : ℕ} (hx : x.toNat = a) (hy : y.toNat = b)
    (h : a + b < 2 ^ 128) : (x + y).toNat = a + b := by
  rw [BitVec.toNat_add_of_lt (by omega), hx, hy]

/-- `m(n, c)` for a multiplier `n` below `2^52` and `c` below `2^64`. -/
public theorem toNat_mul_lit {n : BitVec 64} {c : BitVec 128} (hn : n.toNat < 2 ^ 52)
    (hc : c.toNat < 2 ^ 64) : (n.setWidth 128 * c).toNat = n.toNat * c.toNat := by
  rw [toNat_zext_mul, Nat.mod_eq_of_lt]
  calc
    n.toNat * c.toNat < 2 ^ 52 * 2 ^ 64 := Nat.mul_lt_mul'' hn hc
    _ < 2 ^ 128 := by decide

-- `omega` must see the chain's weights, up to `2^416`
set_option exponentiation.threshold 500 in
/-- `montgomery_reduce`'s chain over named values: limbs `0 … 3` below `2^52`, and
`r 2^260 = z + n ℓ` for the columns' number `z` and multipliers `n < 2^260`. -/
public theorem chain_core {z : Fin 9 → BitVec 128} (hz : ∀ k, (z k).toNat < 2 ^ 108)
    {n0 n1 n2 n3 n4 : BitVec 64}
    {carry0 carry1 carry2 carry3 carry4 sum1 sum2 sum3 sum4 sum5 sum6 sum7 sum8 : BitVec 128}
    {l : Fin 5 → BitVec 64} (hn0 : n0 = (z 0).setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64)
    (hc0 : carry0 = (n0.setWidth 128 * 0x0002631a5cf5d3ed#128 + z 0) >>> 52)
    (hs1 : sum1 = n0.setWidth 128 * 0x000dea2f79cd6581#128 + z 1 + carry0)
    (hn1 : n1 = sum1.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64)
    (hc1 : carry1 = (n1.setWidth 128 * 0x0002631a5cf5d3ed#128 + sum1) >>> 52)
    (hs2 :
      sum2 =
        z 2 + n0.setWidth 128 * 0x000000000014def9#128 + n1.setWidth 128 * 0x000dea2f79cd6581#128 +
          carry1)
    (hn2 : n2 = sum2.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64)
    (hc2 : carry2 = (n2.setWidth 128 * 0x0002631a5cf5d3ed#128 + sum2) >>> 52)
    (hs3 :
      sum3 =
        n1.setWidth 128 * 0x000000000014def9#128 + z 3 + n2.setWidth 128 * 0x000dea2f79cd6581#128 +
          carry2)
    (hn3 : n3 = sum3.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64)
    (hc3 : carry3 = (n3.setWidth 128 * 0x0002631a5cf5d3ed#128 + sum3) >>> 52)
    (hs4 :
      sum4 =
        z 4 + (n0.setWidth 128 <<< 44) + n2.setWidth 128 * 0x000000000014def9#128 +
          n3.setWidth 128 * 0x000dea2f79cd6581#128 +
          carry3)
    (hn4 : n4 = sum4.setWidth 64 * Scalar52.LFACTOR &&& 0xfffffffffffff#64)
    (hc4 : carry4 = (n4.setWidth 128 * 0x0002631a5cf5d3ed#128 + sum4) >>> 52)
    (hs5 :
      sum5 =
        (n1.setWidth 128 <<< 44) + z 5 + n3.setWidth 128 * 0x000000000014def9#128 +
          n4.setWidth 128 * 0x000dea2f79cd6581#128 +
          carry4)
    (hs6 :
      sum6 =
        (n2.setWidth 128 <<< 44) + z 6 + n4.setWidth 128 * 0x000000000014def9#128 + (sum5 >>> 52))
    (hs7 : sum7 = (n3.setWidth 128 <<< 44) + z 7 + (sum6 >>> 52))
    (hs8 : sum8 = (n4.setWidth 128 <<< 44) + z 8 + (sum7 >>> 52))
    (hl0 : l 0 = sum5.setWidth 64 &&& 0xfffffffffffff#64)
    (hl1 : l 1 = sum6.setWidth 64 &&& 0xfffffffffffff#64)
    (hl2 : l 2 = sum7.setWidth 64 &&& 0xfffffffffffff#64)
    (hl3 : l 3 = sum8.setWidth 64 &&& 0xfffffffffffff#64) (hl4 : l 4 = (sum8 >>> 52).setWidth 64) :
    ∃ n < 2 ^ 260,
      Scalar52.nat l * 2 ^ 260 =
          (z 0).toNat + (z 1).toNat * 2 ^ 52 + (z 2).toNat * 2 ^ 104 + (z 3).toNat * 2 ^ 156 +
            (z 4).toNat * 2 ^ 208 +
            (z 5).toNat * 2 ^ 260 +
            (z 6).toNat * 2 ^ 312 +
            (z 7).toNat * 2 ^ 364 +
            (z 8).toNat * 2 ^ 416 +
            n * ell ∧
        (l 0).toNat < 2 ^ 52 ∧
        (l 1).toNat < 2 ^ 52 ∧ (l 2).toNat < 2 ^ 52 ∧ (l 3).toNat < 2 ^ 52 := by
  have hz0 := hz 0; have hz1 := hz 1; have hz2 := hz 2; have hz3 := hz 3; have hz4 := hz 4
  have hz5 := hz 5; have hz6 := hz 6; have hz7 := hz 7; have hz8 := hz 8
  clear hz
  have hsh := fun n => toNat_shl44 n
  have hm1 :
    ∀ {n : BitVec 64},
      n.toNat < 2 ^ 52 →
        (n.setWidth 128 * 0x000dea2f79cd6581#128).toNat = n.toNat * 3916664325105025 :=
    fun h => by
    rw [toNat_mul_lit h (by decide)]; rfl
  have hm2 :
    ∀ {n : BitVec 64},
      n.toNat < 2 ^ 52 → (n.setWidth 128 * 0x000000000014def9#128).toNat = n.toNat * 1367801 :=
    fun h => by
    rw [toNat_mul_lit h (by decide)]; rfl
  have hsr : ∀ x : BitVec 128, (x >>> 52).toNat = x.toNat / 2 ^ 52 := fun x => by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  -- `part1`; the `omega` calls see only the bounds they need: the whole chain is too much for it
  obtain ⟨bn0, ec0, bc0⟩ := part1 (z 0) (by omega)
  rw [← hn0] at bn0 ec0 bc0
  rw [← hc0] at ec0 bc0
  have esum1 : sum1.toNat = n0.toNat * 3916664325105025 + (z 1).toNat + carry0.toNat := by
    rw [hs1]
    have h0 :=
      toNat_add_eq (hm1 bn0) (rfl : (z 1).toNat = _)
        (by
          clear * - bn0 hz1; omega)
    exact
      toNat_add_eq h0 (rfl : carry0.toNat = _)
        (by
          clear * - bn0 hz1 bc0; omega)
  obtain ⟨bn1, ec1, bc1⟩ :=
    part1 sum1
      (by
        clear * - esum1 bn0 hz1 bc0; omega)
  rw [← hn1] at bn1 ec1 bc1
  rw [← hc1] at ec1 bc1
  have esum2 :
    sum2.toNat = (z 2).toNat + n0.toNat * 1367801 + n1.toNat * 3916664325105025 + carry1.toNat := by
    rw [hs2]
    have h0 :=
      toNat_add_eq (rfl : (z 2).toNat = _) (hm2 bn0)
        (by
          clear * - hz2 bn0; omega)
    have h1 :=
      toNat_add_eq h0 (hm1 bn1)
        (by
          clear * - hz2 bn0 bn1; omega)
    exact
      toNat_add_eq h1 (rfl : carry1.toNat = _)
        (by
          clear * - hz2 bn0 bn1 bc1; omega)
  obtain ⟨bn2, ec2, bc2⟩ :=
    part1 sum2
      (by
        clear * - esum2 hz2 bn0 bn1 bc1; omega)
  rw [← hn2] at bn2 ec2 bc2
  rw [← hc2] at ec2 bc2
  have esum3 :
    sum3.toNat = n1.toNat * 1367801 + (z 3).toNat + n2.toNat * 3916664325105025 + carry2.toNat := by
    rw [hs3]
    have h0 :=
      toNat_add_eq (hm2 bn1) (rfl : (z 3).toNat = _)
        (by
          clear * - bn1 hz3; omega)
    have h1 :=
      toNat_add_eq h0 (hm1 bn2)
        (by
          clear * - bn1 hz3 bn2; omega)
    exact
      toNat_add_eq h1 (rfl : carry2.toNat = _)
        (by
          clear * - bn1 hz3 bn2 bc2; omega)
  obtain ⟨bn3, ec3, bc3⟩ :=
    part1 sum3
      (by
        clear * - esum3 bn1 hz3 bn2 bc2; omega)
  rw [← hn3] at bn3 ec3 bc3
  rw [← hc3] at ec3 bc3
  have esum4 :
    sum4.toNat =
      (z 4).toNat + n0.toNat * 2 ^ 44 + n2.toNat * 1367801 + n3.toNat * 3916664325105025 +
        carry3.toNat := by
    rw [hs4]
    have h0 :=
      toNat_add_eq (rfl : (z 4).toNat = _) (hsh n0)
        (by
          clear * - hz4 bn0; omega)
    have h1 :=
      toNat_add_eq h0 (hm2 bn2)
        (by
          clear * - hz4 bn0 bn2; omega)
    have h2 :=
      toNat_add_eq h1 (hm1 bn3)
        (by
          clear * - hz4 bn0 bn2 bn3; omega)
    exact
      toNat_add_eq h2 (rfl : carry3.toNat = _)
        (by
          clear * - hz4 bn0 bn2 bn3 bc3; omega)
  obtain ⟨bn4, ec4, bc4⟩ :=
    part1 sum4
      (by
        clear * - esum4 hz4 bn0 bn2 bn3 bc3; omega)
  rw [← hn4] at bn4 ec4 bc4
  rw [← hc4] at ec4 bc4
  -- `part2`
  have esum5 :
    sum5.toNat =
      n1.toNat * 2 ^ 44 + (z 5).toNat + n3.toNat * 1367801 + n4.toNat * 3916664325105025 +
        carry4.toNat := by
    rw [hs5]
    have h0 :=
      toNat_add_eq (hsh n1) (rfl : (z 5).toNat = _)
        (by
          clear * - bn1 hz5; omega)
    have h1 :=
      toNat_add_eq h0 (hm2 bn3)
        (by
          clear * - bn1 hz5 bn3; omega)
    have h2 :=
      toNat_add_eq h1 (hm1 bn4)
        (by
          clear * - bn1 hz5 bn3 bn4; omega)
    exact
      toNat_add_eq h2 (rfl : carry4.toNat = _)
        (by
          clear * - bn1 hz5 bn3 bn4 bc4; omega)
  have bsum5 : sum5.toNat < 2 ^ 110 :=
    (by
      clear * - esum5 bn1 hz5 bn3 bn4 bc4; omega)
  have esum6 :
    sum6.toNat = n2.toNat * 2 ^ 44 + (z 6).toNat + n4.toNat * 1367801 + sum5.toNat / 2 ^ 52 := by
    rw [hs6]
    have h0 :=
      toNat_add_eq (hsh n2) (rfl : (z 6).toNat = _)
        (by
          clear * - bn2 hz6; omega)
    have h1 :=
      toNat_add_eq h0 (hm2 bn4)
        (by
          clear * - bn2 hz6 bn4; omega)
    exact
      toNat_add_eq h1 (hsr sum5)
        (by
          clear * - bn2 hz6 bn4 esum5 bsum5; omega)
  have bsum6 : sum6.toNat < 2 ^ 110 :=
    (by
      clear * - esum6 bn2 hz6 bn4 esum5 bsum5; omega)
  have esum7 : sum7.toNat = n3.toNat * 2 ^ 44 + (z 7).toNat + sum6.toNat / 2 ^ 52 := by
    rw [hs7]
    have h0 :=
      toNat_add_eq (hsh n3) (rfl : (z 7).toNat = _)
        (by
          clear * - bn3 hz7; omega)
    exact
      toNat_add_eq h0 (hsr sum6)
        (by
          clear * - bn3 hz7 esum6 bsum6; omega)
  have bsum7 : sum7.toNat < 2 ^ 110 :=
    (by
      clear * - esum7 bn3 hz7 esum6 bsum6; omega)
  have esum8 : sum8.toNat = n4.toNat * 2 ^ 44 + (z 8).toNat + sum7.toNat / 2 ^ 52 := by
    rw [hs8]
    have h0 :=
      toNat_add_eq (hsh n4) (rfl : (z 8).toNat = _)
        (by
          clear * - bn4 hz8; omega)
    exact
      toNat_add_eq h0 (hsr sum7)
        (by
          clear * - bn4 hz8 esum7 bsum7; omega)
  have bsum8 : sum8.toNat < 2 ^ 110 :=
    (by
      clear * - esum8 bn4 hz8 esum7 bsum7; omega)
  have el0 : (l 0).toNat = sum5.toNat % 2 ^ 52 := by rw [hl0, toNat_lo]
  have el1 : (l 1).toNat = sum6.toNat % 2 ^ 52 := by rw [hl1, toNat_lo]
  have el2 : (l 2).toNat = sum7.toNat % 2 ^ 52 := by rw [hl2, toNat_lo]
  have el3 : (l 3).toNat = sum8.toNat % 2 ^ 52 := by rw [hl3, toNat_lo]
  have el4 : (l 4).toNat = sum8.toNat / 2 ^ 52 := by
    rw [hl4, BitVec.toNat_setWidth, hsr,
      Nat.mod_eq_of_lt
        (by
          clear * - bsum8; omega)]
  have hL0 : (Scalar52.L 0).toNat = 671914833335277 := rfl
  have hL1 : (Scalar52.L 1).toNat = 3916664325105025 := rfl
  have hL2 : (Scalar52.L 2).toNat = 1367801 := rfl
  have hL4 : (Scalar52.L 4).toNat = 2 ^ 44 := rfl
  have :=
    Scalar52.montgomery_chain (z₀ := (z 0).toNat) (z₁ := (z 1).toNat) (z₂ := (z 2).toNat) (z₃ :=
      (z 3).toNat) (z₄ := (z 4).toNat) (z₅ := (z 5).toNat) (z₆ := (z 6).toNat) (z₇ := (z 7).toNat)
      (z₈ := (z 8).toNat) (n₀ := n0.toNat) (n₁ := n1.toNat) (n₂ := n2.toNat) (n₃ := n3.toNat) (n₄ :=
      n4.toNat) (c₀ := carry0.toNat) (c₁ := carry1.toNat) (c₂ := carry2.toNat) (c₃ := carry3.toNat)
      (c₄ := carry4.toNat) (c₅ := sum5.toNat / 2 ^ 52) (c₆ := sum6.toNat / 2 ^ 52) (c₇ :=
      sum7.toNat / 2 ^ 52) (r₀ := (l 0).toNat) (r₁ := (l 1).toNat) (r₂ := (l 2).toNat) (r₃ :=
      (l 3).toNat) (r₄ := (l 4).toNat)
      (by
        rw [hL0]; clear * - ec0; omega)
      (by
        rw [hL0, hL1]; clear * - ec1 esum1; omega)
      (by
        rw [hL0, hL1, hL2]; clear * - ec2 esum2; omega)
      (by
        rw [hL0, hL1, hL2]; clear * - ec3 esum3; omega)
      (by
        rw [hL0, hL1, hL2, hL4]; clear * - ec4 esum4; omega)
      (by
        rw [hL1, hL2, hL4]; clear * - el0 esum5; omega)
      (by
        rw [hL2, hL4]; clear * - el1 esum6; omega)
      (by
        rw [hL4]; clear * - el2 esum7; omega)
      (by
        rw [hL4]; clear * - el3 el4 esum8; omega)
  refine
    ⟨n0.toNat + n1.toNat * 2 ^ 52 + n2.toNat * 2 ^ 104 + n3.toNat * 2 ^ 156 + n4.toNat * 2 ^ 208, by
      clear * - bn0 bn1 bn2 bn3 bn4; omega, this, ?_, ?_, ?_, ?_⟩
  · rw [el0]; exact Nat.mod_lt _ (by decide)
  · rw [el1]; exact Nat.mod_lt _ (by decide)
  · rw [el2]; exact Nat.mod_lt _ (by decide)
  · rw [el3]; exact Nat.mod_lt _ (by decide)

-- `omega` must see the chain's weights, up to `2^416`
set_option exponentiation.threshold 500 in
/-- `montgomery_reduce`'s chain: limbs `0 … 3` below `2^52`, and `r 2^260 = z + n ℓ` for the
columns' number `z` and multipliers `n < 2^260`. -/
public theorem chain (z : Fin 9 → BitVec 128) (hz : ∀ k, (z k).toNat < 2 ^ 108) :
    ∃ n < 2 ^ 260,
      Scalar52.nat (limbs z) * 2 ^ 260 =
          (z 0).toNat + (z 1).toNat * 2 ^ 52 + (z 2).toNat * 2 ^ 104 + (z 3).toNat * 2 ^ 156 +
            (z 4).toNat * 2 ^ 208 +
            (z 5).toNat * 2 ^ 260 +
            (z 6).toNat * 2 ^ 312 +
            (z 7).toNat * 2 ^ 364 +
            (z 8).toNat * 2 ^ 416 +
            n * ell ∧
        (limbs z 0).toNat < 2 ^ 52 ∧
        (limbs z 1).toNat < 2 ^ 52 ∧ (limbs z 2).toNat < 2 ^ 52 ∧ (limbs z 3).toNat < 2 ^ 52 :=
  chain_core (l := limbs z) hz rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
    rfl rfl rfl rfl rfl rfl

end Scalar52_montgomery_reduce

namespace Scalar52_montgomery_mul

open Scalar52

/-- For bounded limbs with `a b < 2^260 ℓ` (`b < ℓ` suffices), the spec is `a b / 2^260` mod `ℓ`,
in bounded limbs. -/
public theorem nat_spec {a b : Fin 5 → BitVec 64} (ha : Bounded a) (hb : Bounded b)
    (hab : nat a * nat b < 2 ^ 260 * ell) : nat (spec a b) = nat a * nat b * Rinv % ell := by
  obtain ⟨hzb, hzs⟩ := Scalar52_mul_internal.toNat_spec ha hb
  obtain ⟨n, hn, hr, h0, h1, h2, h3⟩ :=
    Scalar52_montgomery_reduce.chain (Scalar52_mul_internal.spec a b) fun k =>
      (hzb k).trans (by decide)
  rw [hzs] at hr
  have hlt := montgomery_lt hr hab hn
  have hell : ell < 2 ^ 253 := by decide +kernel
  have h4 :
    (Scalar52_montgomery_reduce.limbs (Scalar52_mul_internal.spec a b) 4).toNat < 2 ^ 52 := by
    have : nat (Scalar52_montgomery_reduce.limbs (Scalar52_mul_internal.spec a b)) < 2 ^ 254 := by
      omega
    unfold nat at this
    omega
  have hB : Bounded (Scalar52_montgomery_reduce.limbs (Scalar52_mul_internal.spec a b)) := by
    intro i; fin_cases i
    exacts [h0, h1, h2, h3, h4]
  rw [spec, Scalar52_montgomery_reduce.spec, Scalar52_sub.nat_spec_mod hB hlt, montgomery_mod hr]

/-- The spec's limbs are below `2^52`. -/
public theorem spec_bounded (a b : Fin 5 → BitVec 64) : Bounded (spec a b) :=
  Scalar52_sub.spec_bounded _

end Scalar52_montgomery_mul

/-! ### `to_bytes` and `pack` -/

namespace Scalar52_to_bytes

/-- The bytes, widened, are the limbs' `bits` when those fit 256 bits. -/
theorem setWidth_spec {l : Fin 5 → BitVec 64} (h : Scalar52.Bounded l) (h4 : (l 4).toNat < 2 ^ 48) :
    (spec l).setWidth 260 = Scalar52.bits l := by
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3
  obtain ⟨a0, ha0⟩ : ∃ x, l 0 = x := ⟨_, rfl⟩
  obtain ⟨a1, ha1⟩ : ∃ x, l 1 = x := ⟨_, rfl⟩
  obtain ⟨a2, ha2⟩ : ∃ x, l 2 = x := ⟨_, rfl⟩
  obtain ⟨a3, ha3⟩ : ∃ x, l 3 = x := ⟨_, rfl⟩
  obtain ⟨a4, ha4⟩ : ∃ x, l 4 = x := ⟨_, rfl⟩
  rw [ha0] at h0; rw [ha1] at h1; rw [ha2] at h2; rw [ha3] at h3; rw [ha4] at h4
  simp only [Scalar52.bits, spec, bytes, ha0, ha1, ha2, ha3, ha4]
  replace h0 : a0 < 0x10000000000000#64 := h0
  replace h1 : a1 < 0x10000000000000#64 := h1
  replace h2 : a2 < 0x10000000000000#64 := h2
  replace h3 : a3 < 0x10000000000000#64 := h3
  replace h4 : a4 < 0x1000000000000#64 := h4
  bv_decide

/-- For bounded limbs below `2^256`, the bytes are the limbs' number, little-endian. -/
public theorem toNat_spec {l : Fin 5 → BitVec 64} (h : Scalar52.Bounded l)
    (h4 : (l 4).toNat < 2 ^ 48) : (spec l).toNat = Scalar52.nat l := by
  rw [← Scalar52.toNat_bits h, ← setWidth_spec h h4, BitVec.toNat_setWidth_of_le (by decide)]

end Scalar52_to_bytes

namespace Scalar52_pack

/-- `Scalar52_to_bytes.toNat_spec` for `pack`. -/
public theorem toNat_spec {l : Fin 5 → BitVec 64} (h : Scalar52.Bounded l)
    (h4 : (l 4).toNat < 2 ^ 48) : (spec l).toNat = Scalar52.nat l :=
  Scalar52_to_bytes.toNat_spec h h4

/-- A number below `ℓ` has its top limb below `2^48`. -/
public theorem top_lt {l : Fin 5 → BitVec 64} (h : Scalar52.nat l < ell) :
    (l 4).toNat < 2 ^ 48 := by
  have hell : ell < 2 ^ 253 := by decide +kernel
  unfold Scalar52.nat at h
  omega

end Scalar52_pack

end MLIR.Agave

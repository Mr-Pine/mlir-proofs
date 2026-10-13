module

public import MLIR.Run.Tactic
public import Boringssl.load_3
public import Boringssl.load_4
public import Boringssl.int64_lshift21
public import Boringssl.Mlir.x25519_sc_reduce
public import Boringssl.Common.Bounds
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

open MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `load_3(s + k)` on the 64 bytes `x`. -/
def x25519_sc_reduce.load3 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 24).setWidth 64

/-- `load_4(s + k)` on the 64 bytes `x`. -/
def x25519_sc_reduce.load4 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 32).setWidth 64

open x25519_sc_reduce in
/-- `s mod ℓ` as the C computes it, on the 64 bytes `x`: 21-bit limbs, the limbs above `2^252`
folded down by `2^252 ≡ -27742317777372353535851937790883648493 (mod ℓ)` (the `666643 … 683901`
rows), the carries between (`1048576` is `1 << 20`, `int64_lshift21(c)` is `c << 21`), and the 12
low limbs stored as 32 bytes. The dead `sK = 0` resets are left out. -/
def x25519_sc_reduce.spec (x : BitVec 512) : BitVec 256 :=
  let s0 := 2097151#64 &&& load3 x 0
  let s1 := 2097151#64 &&& load4 x 2 >>> 5
  let s2 := 2097151#64 &&& load3 x 5 >>> 2
  let s3 := 2097151#64 &&& load4 x 7 >>> 7
  let s4 := 2097151#64 &&& load4 x 10 >>> 4
  let s5 := 2097151#64 &&& load3 x 13 >>> 1
  let s6 := 2097151#64 &&& load4 x 15 >>> 6
  let s7 := 2097151#64 &&& load3 x 18 >>> 3
  let s8 := 2097151#64 &&& load3 x 21
  let s9 := 2097151#64 &&& load4 x 23 >>> 5
  let s10 := 2097151#64 &&& load3 x 26 >>> 2
  let s11 := 2097151#64 &&& load4 x 28 >>> 7
  let s12 := 2097151#64 &&& load4 x 31 >>> 4
  let s13 := 2097151#64 &&& load3 x 34 >>> 1
  let s14 := 2097151#64 &&& load4 x 36 >>> 6
  let s15 := 2097151#64 &&& load3 x 39 >>> 3
  let s16 := 2097151#64 &&& load3 x 42
  let s17 := 2097151#64 &&& load4 x 44 >>> 5
  let s18 := 2097151#64 &&& load3 x 47 >>> 2
  let s19 := 2097151#64 &&& load4 x 49 >>> 7
  let s20 := 2097151#64 &&& load4 x 52 >>> 4
  let s21 := 2097151#64 &&& load3 x 55 >>> 1
  let s22 := 2097151#64 &&& load4 x 57 >>> 6
  let s23 := load4 x 60 >>> 3
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
  let b0 := s0.setWidth 8
  let b1 := (s0.sshiftRight 8).setWidth 8
  let b2 := (s0.sshiftRight 16 ||| s1 <<< 5).setWidth 8
  let b3 := (s1.sshiftRight 3).setWidth 8
  let b4 := (s1.sshiftRight 11).setWidth 8
  let b5 := (s1.sshiftRight 19 ||| s2 <<< 2).setWidth 8
  let b6 := (s2.sshiftRight 6).setWidth 8
  let b7 := (s2.sshiftRight 14 ||| s3 <<< 7).setWidth 8
  let b8 := (s3.sshiftRight 1).setWidth 8
  let b9 := (s3.sshiftRight 9).setWidth 8
  let b10 := (s3.sshiftRight 17 ||| s4 <<< 4).setWidth 8
  let b11 := (s4.sshiftRight 4).setWidth 8
  let b12 := (s4.sshiftRight 12).setWidth 8
  let b13 := (s4.sshiftRight 20 ||| s5 <<< 1).setWidth 8
  let b14 := (s5.sshiftRight 7).setWidth 8
  let b15 := (s5.sshiftRight 15 ||| s6 <<< 6).setWidth 8
  let b16 := (s6.sshiftRight 2).setWidth 8
  let b17 := (s6.sshiftRight 10).setWidth 8
  let b18 := (s6.sshiftRight 18 ||| s7 <<< 3).setWidth 8
  let b19 := (s7.sshiftRight 5).setWidth 8
  let b20 := (s7.sshiftRight 13).setWidth 8
  let b21 := s8.setWidth 8
  let b22 := (s8.sshiftRight 8).setWidth 8
  let b23 := (s8.sshiftRight 16 ||| s9 <<< 5).setWidth 8
  let b24 := (s9.sshiftRight 3).setWidth 8
  let b25 := (s9.sshiftRight 11).setWidth 8
  let b26 := (s9.sshiftRight 19 ||| s10 <<< 2).setWidth 8
  let b27 := (s10.sshiftRight 6).setWidth 8
  let b28 := (s10.sshiftRight 14 ||| s11 <<< 7).setWidth 8
  let b29 := (s11.sshiftRight 1).setWidth 8
  let b30 := (s11.sshiftRight 9).setWidth 8
  let b31 := (s11.sshiftRight 17).setWidth 8
  b31 ++ b30 ++ b29 ++ b28 ++ b27 ++ b26 ++ b25 ++ b24 ++ b23 ++ b22 ++ b21 ++ b20 ++ b19 ++ b18 ++
    b17 ++
    b16 ++
    b15 ++
    b14 ++
    b13 ++
    b12 ++
    b11 ++
    b10 ++
    b9 ++
    b8 ++
    b7 ++
    b6 ++
    b5 ++
    b4 ++
    b3 ++
    b2 ++
    b1 ++
    b0

end

/-! ## Bounds -/

/-- `load_3(s + k)`'s pointer does not wrap. -/
theorem x25519_sc_reduce.off3 {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) (k : Nat)
    (hk : k + 3 ≤ 64) : ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 3#64 := by
  have e : (64#64).toNat = 64 := rfl
  simp only [BitVec.uaddOverflow, Pointer.add, e] at h ⊢
  simp at h ⊢
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- `load_3(s)` as the memory reads it: the low 24 bits. -/
public theorem x25519_sc_reduce.setWidth_load3 (x : BitVec 512) :
    (x.setWidth 24).setWidth 64 = x25519_sc_reduce.load3 x 0 := by
  unfold x25519_sc_reduce.load3
  bv_decide

/-! ## Firedancer's reduction -/

/-- A floor carry's residual fits 21 bits. -/
theorem x25519_sc_reduce.resid_le (a : BitVec 64) : a - a.sshiftRight 21 <<< 21 ≤ 2097151#64 := by
  bv_decide

/-- The C's 32 bytes of the limbs, the first eleven below `2^21`, are Firedancer's four packed
words. -/
theorem x25519_sc_reduce.bytes_eq_pack
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 : BitVec 64}
    (e0 : s0 = f0) (e1 : s1 = f1) (e2 : s2 = f2) (e3 : s3 = f3) (e4 : s4 = f4) (e5 : s5 = f5)
    (e6 : s6 = f6) (e7 : s7 = f7) (e8 : s8 = f8) (e9 : s9 = f9) (e10 : s10 = f10) (e11 : s11 = f11)
    (h0 : s0 ≤ 2097151#64) (h1 : s1 ≤ 2097151#64) (h2 : s2 ≤ 2097151#64) (h3 : s3 ≤ 2097151#64)
    (h4 : s4 ≤ 2097151#64) (h5 : s5 ≤ 2097151#64) (h6 : s6 ≤ 2097151#64) (h7 : s7 ≤ 2097151#64)
    (h8 : s8 ≤ 2097151#64) (h9 : s9 ≤ 2097151#64) (h10 : s10 ≤ 2097151#64) :
    (s11.sshiftRight 17).setWidth 8 ++ (s11.sshiftRight 9).setWidth 8 ++
        (s11.sshiftRight 1).setWidth 8 ++
        (s10.sshiftRight 14 ||| s11 <<< 7).setWidth 8 ++
        (s10.sshiftRight 6).setWidth 8 ++
        (s9.sshiftRight 19 ||| s10 <<< 2).setWidth 8 ++
        (s9.sshiftRight 11).setWidth 8 ++
        (s9.sshiftRight 3).setWidth 8 ++
        (s8.sshiftRight 16 ||| s9 <<< 5).setWidth 8 ++
        (s8.sshiftRight 8).setWidth 8 ++
        s8.setWidth 8 ++
        (s7.sshiftRight 13).setWidth 8 ++
        (s7.sshiftRight 5).setWidth 8 ++
        (s6.sshiftRight 18 ||| s7 <<< 3).setWidth 8 ++
        (s6.sshiftRight 10).setWidth 8 ++
        (s6.sshiftRight 2).setWidth 8 ++
        (s5.sshiftRight 15 ||| s6 <<< 6).setWidth 8 ++
        (s5.sshiftRight 7).setWidth 8 ++
        (s4.sshiftRight 20 ||| s5 <<< 1).setWidth 8 ++
        (s4.sshiftRight 12).setWidth 8 ++
        (s4.sshiftRight 4).setWidth 8 ++
        (s3.sshiftRight 17 ||| s4 <<< 4).setWidth 8 ++
        (s3.sshiftRight 9).setWidth 8 ++
        (s3.sshiftRight 1).setWidth 8 ++
        (s2.sshiftRight 14 ||| s3 <<< 7).setWidth 8 ++
        (s2.sshiftRight 6).setWidth 8 ++
        (s1.sshiftRight 19 ||| s2 <<< 2).setWidth 8 ++
        (s1.sshiftRight 11).setWidth 8 ++
        (s1.sshiftRight 3).setWidth 8 ++
        (s0.sshiftRight 16 ||| s1 <<< 5).setWidth 8 ++
        (s0.sshiftRight 8).setWidth 8 ++
        s0.setWidth 8 =
      (f9 >>> 3 ||| f10 <<< 18 ||| f11 <<< 39) ++
        ((f6 >>> 2 ||| f7 <<< 19 ||| f8 <<< 40 ||| f9 <<< 61) ++
          ((f3 >>> 1 ||| f4 <<< 20 ||| f5 <<< 41 ||| f6 <<< 62) ++
            (f0 ||| f1 <<< 21 ||| f2 <<< 42 ||| f3 <<< 63))) := by
  subst_vars
  bv_decide

/-- The same value as Firedancer's `fd_curve25519_scalar_reduce`: the same rows and carries on the
same limbs, the 32 bytes as its four packed words. -/
public theorem x25519_sc_reduce.spec_eq (x : BitVec 512) :
    x25519_sc_reduce.spec x = MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce.spec x := by
  unfold x25519_sc_reduce.spec MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce.spec
  lift_lets -merge
  intro s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 s11_1
    s12_1 s13_1 s14_1 s15_1 s16_1 s10_1 s11_2 s12_2 s13_2 s14_2 s15_2 s9_1 s10_2 s11_3 s12_3 s13_3
    s14_3 s8_1 s9_2 s10_3 s11_4 s12_4 s13_4 s7_1 s8_2 s9_3 s10_4 s11_5 s12_5 s6_1 s7_2 s8_3 s9_4
    s10_5 s11_6 carry6 s7_3 s6_2 carry8 s9_5 s8_4 carry10 s11_7 s10_6 carry12 s13_5 s12_6 carry14
    s15_3 s14_4 carry16 s17_1 s16_2 carry7 s8_5 s7_4 carry9 s10_7 s9_6 carry11 s12_7 s11_8 carry13
    s14_5 s13_6 carry15 s16_3 s15_4 s5_1 s6_3 s7_5 s8_6 s9_7 s10_8 s4_1 s5_2 s6_4 s7_6 s8_7 s9_8
    s3_1 s4_2 s5_3 s6_5 s7_7 s8_8 s2_1 s3_2 s4_3 s5_4 s6_6 s7_8 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1
    s1_2 s2_3 s3_4 s4_5 s5_6 s12_8 carry0 s1_3 s0_2 carry2 s3_5 s2_4 carry4 s5_7 s4_6 carry6_1 s7_9
    s6_8 carry8_1 s9_9 s8_9 carry10_1 s11_9 s10_9 carry1 s2_5 s1_4 carry3 s4_7 s3_6 carry5 s6_9 s5_8
    carry7_1 s8_10 s7_10 carry9_1 s10_10 s9_10 carry11_1 s12_9 s11_10 s0_3 s1_5 s2_6 s3_7 s4_8 s5_9
    s12_10 carry0_1 s1_6 s0_4 carry1_1 s2_7 s1_7 carry2_1 s3_8 s2_8 carry3_1 s4_9 s3_9 carry4_1
    s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11 s7_12 carry8_2 s9_11 s8_12
    carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s12_11 s11_12 s0_5 s1_8 s2_9 s3_10 s4_11
    s5_12 carry0_2 s1_9 s0_6 carry1_2 s2_10 s1_10 carry2_2 s3_11 s2_11 carry3_2 s4_12 s3_12 carry4_2
    s5_13 s4_13 carry5_2 s6_12 s5_14 carry6_3 s7_13 s6_13 carry7_3 s8_13 s7_14 carry8_3 s9_13 s8_14
    carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14
    b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 f_in0 f_in1 f_in2 f_in3
    f_in4 f_in5 f_in6 f_in7 f_mask f_s0 f_s1 f_s2 f_s3 f_s4 f_s5 f_s6 f_s7 f_s8 f_s9 f_s10 f_s11
    f_s12 f_s13 f_s14 f_s15 f_s16 f_s17 f_s18 f_s19 f_s20 f_s21 f_s22 f_s23 f_s11_1 f_s12_1 f_s13_1
    f_s14_1 f_s15_1 f_s16_1 f_s10_1 f_s11_2 f_s12_2 f_s13_2 f_s14_2 f_s15_2 f_s9_1 f_s10_2 f_s11_3
    f_s12_3 f_s13_3 f_s14_3 f_s8_1 f_s9_2 f_s10_3 f_s11_4 f_s12_4 f_s13_4 f_s7_1 f_s8_2 f_s9_3
    f_s10_4 f_s11_5 f_s12_5 f_s6_1 f_s7_2 f_s8_3 f_s9_4 f_s10_5 f_s11_6 f_carry6 f_s7_3 f_s6_2
    f_carry8 f_s9_5 f_s8_4 f_carry10 f_s11_7 f_s10_6 f_carry12 f_s13_5 f_s12_6 f_carry14 f_s15_3
    f_s14_4 f_carry16 f_s17_1 f_s16_2 f_carry7 f_s8_5 f_s7_4 f_carry9 f_s10_7 f_s9_6 f_carry11
    f_s12_7 f_s11_8 f_carry13 f_s14_5 f_s13_6 f_carry15 f_s16_3 f_s15_4 f_s5_1 f_s6_3 f_s7_5 f_s8_6
    f_s9_7 f_s10_8 f_s4_1 f_s5_2 f_s6_4 f_s7_6 f_s8_7 f_s9_8 f_s3_1 f_s4_2 f_s5_3 f_s6_5 f_s7_7
    f_s8_8 f_s2_1 f_s3_2 f_s4_3 f_s5_4 f_s6_6 f_s7_8 f_s1_1 f_s2_2 f_s3_3 f_s4_4 f_s5_5 f_s6_7
    f_s0_1 f_s1_2 f_s2_3 f_s3_4 f_s4_5 f_s5_6 f_s12_8 f_carry0 f_s1_3 f_s0_2 f_carry2 f_s3_5 f_s2_4
    f_carry4 f_s5_7 f_s4_6 f_carry6_1 f_s7_9 f_s6_8 f_carry8_1 f_s9_9 f_s8_9 f_carry10_1 f_s11_9
    f_s10_9 f_carry1 f_s2_5 f_s1_4 f_carry3 f_s4_7 f_s3_6 f_carry5 f_s6_9 f_s5_8 f_carry7_1 f_s8_10
    f_s7_10 f_carry9_1 f_s10_10 f_s9_10 f_carry11_1 f_s12_9 f_s11_10 f_s0_3 f_s1_5 f_s2_6 f_s3_7
    f_s4_8 f_s5_9 f_s12_10 f_carry0_1 f_s1_6 f_s0_4 f_carry1_1 f_s2_7 f_s1_7 f_carry2_1 f_s3_8
    f_s2_8 f_carry3_1 f_s4_9 f_s3_9 f_carry4_1 f_s5_10 f_s4_10 f_carry5_1 f_s6_10 f_s5_11 f_carry6_2
    f_s7_11 f_s6_11 f_carry7_2 f_s8_11 f_s7_12 f_carry8_2 f_s9_11 f_s8_12 f_carry9_2 f_s10_11
    f_s9_12 f_carry10_2 f_s11_11 f_s10_12 f_carry11_2 f_s12_11 f_s11_12 f_s0_5 f_s1_8 f_s2_9 f_s3_10
    f_s4_11 f_s5_12 f_carry0_2 f_s1_9 f_s0_6 f_carry1_2 f_s2_10 f_s1_10 f_carry2_2 f_s3_11 f_s2_11
    f_carry3_2 f_s4_12 f_s3_12 f_carry4_2 f_s5_13 f_s4_13 f_carry5_2 f_s6_12 f_s5_14 f_carry6_3
    f_s7_13 f_s6_13 f_carry7_3 f_s8_13 f_s7_14 f_carry8_3 f_s9_13 f_s8_14 f_carry9_3 f_s10_13
    f_s9_14 f_carry10_3 f_s11_13 f_s10_14 f_out0 f_out1 f_out2 f_out3
  have hL :
    s0 = f_s0 ∧
      s1 = f_s1 ∧
      s2 = f_s2 ∧
      s3 = f_s3 ∧
      s4 = f_s4 ∧
      s5 = f_s5 ∧
      s6 = f_s6 ∧
      s7 = f_s7 ∧
      s8 = f_s8 ∧
      s9 = f_s9 ∧
      s10 = f_s10 ∧
      s11 = f_s11 ∧
      s12 = f_s12 ∧
      s13 = f_s13 ∧
      s14 = f_s14 ∧
      s15 = f_s15 ∧
      s16 = f_s16 ∧
      s17 = f_s17 ∧
      s18 = f_s18 ∧ s19 = f_s19 ∧ s20 = f_s20 ∧ s21 = f_s21 ∧ s22 = f_s22 ∧ s23 = f_s23 := by
    simp only [s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18,
      s19, s20, s21, s22, s23, load3, load4, f_in0, f_in1, f_in2, f_in3, f_in4, f_in5, f_in6, f_in7,
      f_mask, f_s0, f_s1, f_s2, f_s3, f_s4, f_s5, f_s6, f_s7, f_s8, f_s9, f_s10, f_s11, f_s12,
      f_s13, f_s14, f_s15, f_s16, f_s17, f_s18, f_s19, f_s20, f_s21, f_s22, f_s23]
    bv_decide
  obtain
    ⟨e_s0, e_s1, e_s2, e_s3, e_s4, e_s5, e_s6, e_s7, e_s8, e_s9, e_s10, e_s11, e_s12, e_s13, e_s14,
      e_s15, e_s16, e_s17, e_s18, e_s19, e_s20, e_s21, e_s22, e_s23⟩ :=
    hL
  have e_s11_1 : s11_1 = f_s11_1 := by simp only [s11_1, f_s11_1, e_s11, e_s23]
  have e_s12_1 : s12_1 = f_s12_1 := by simp only [s12_1, f_s12_1, e_s12, e_s23]
  have e_s13_1 : s13_1 = f_s13_1 := by simp only [s13_1, f_s13_1, e_s13, e_s23]
  have e_s14_1 : s14_1 = f_s14_1 := by simp only [s14_1, f_s14_1, e_s14, e_s23]
  have e_s15_1 : s15_1 = f_s15_1 := by simp only [s15_1, f_s15_1, e_s15, e_s23]
  have e_s16_1 : s16_1 = f_s16_1 := by simp only [s16_1, f_s16_1, e_s16, e_s23]
  have e_s10_1 : s10_1 = f_s10_1 := by simp only [s10_1, f_s10_1, e_s10, e_s22]
  have e_s11_2 : s11_2 = f_s11_2 := by simp only [s11_2, f_s11_2, e_s11_1, e_s22]
  have e_s12_2 : s12_2 = f_s12_2 := by simp only [s12_2, f_s12_2, e_s12_1, e_s22]
  have e_s13_2 : s13_2 = f_s13_2 := by simp only [s13_2, f_s13_2, e_s13_1, e_s22]
  have e_s14_2 : s14_2 = f_s14_2 := by simp only [s14_2, f_s14_2, e_s14_1, e_s22]
  have e_s15_2 : s15_2 = f_s15_2 := by simp only [s15_2, f_s15_2, e_s15_1, e_s22]
  have e_s9_1 : s9_1 = f_s9_1 := by simp only [s9_1, f_s9_1, e_s9, e_s21]
  have e_s10_2 : s10_2 = f_s10_2 := by simp only [s10_2, f_s10_2, e_s10_1, e_s21]
  have e_s11_3 : s11_3 = f_s11_3 := by simp only [s11_3, f_s11_3, e_s11_2, e_s21]
  have e_s12_3 : s12_3 = f_s12_3 := by simp only [s12_3, f_s12_3, e_s12_2, e_s21]
  have e_s13_3 : s13_3 = f_s13_3 := by simp only [s13_3, f_s13_3, e_s13_2, e_s21]
  have e_s14_3 : s14_3 = f_s14_3 := by simp only [s14_3, f_s14_3, e_s14_2, e_s21]
  have e_s8_1 : s8_1 = f_s8_1 := by simp only [s8_1, f_s8_1, e_s8, e_s20]
  have e_s9_2 : s9_2 = f_s9_2 := by simp only [s9_2, f_s9_2, e_s9_1, e_s20]
  have e_s10_3 : s10_3 = f_s10_3 := by simp only [s10_3, f_s10_3, e_s10_2, e_s20]
  have e_s11_4 : s11_4 = f_s11_4 := by simp only [s11_4, f_s11_4, e_s11_3, e_s20]
  have e_s12_4 : s12_4 = f_s12_4 := by simp only [s12_4, f_s12_4, e_s12_3, e_s20]
  have e_s13_4 : s13_4 = f_s13_4 := by simp only [s13_4, f_s13_4, e_s13_3, e_s20]
  have e_s7_1 : s7_1 = f_s7_1 := by simp only [s7_1, f_s7_1, e_s7, e_s19]
  have e_s8_2 : s8_2 = f_s8_2 := by simp only [s8_2, f_s8_2, e_s8_1, e_s19]
  have e_s9_3 : s9_3 = f_s9_3 := by simp only [s9_3, f_s9_3, e_s9_2, e_s19]
  have e_s10_4 : s10_4 = f_s10_4 := by simp only [s10_4, f_s10_4, e_s10_3, e_s19]
  have e_s11_5 : s11_5 = f_s11_5 := by simp only [s11_5, f_s11_5, e_s11_4, e_s19]
  have e_s12_5 : s12_5 = f_s12_5 := by simp only [s12_5, f_s12_5, e_s12_4, e_s19]
  have e_s6_1 : s6_1 = f_s6_1 := by simp only [s6_1, f_s6_1, e_s6, e_s18]
  have e_s7_2 : s7_2 = f_s7_2 := by simp only [s7_2, f_s7_2, e_s7_1, e_s18]
  have e_s8_3 : s8_3 = f_s8_3 := by simp only [s8_3, f_s8_3, e_s8_2, e_s18]
  have e_s9_4 : s9_4 = f_s9_4 := by simp only [s9_4, f_s9_4, e_s9_3, e_s18]
  have e_s10_5 : s10_5 = f_s10_5 := by simp only [s10_5, f_s10_5, e_s10_4, e_s18]
  have e_s11_6 : s11_6 = f_s11_6 := by simp only [s11_6, f_s11_6, e_s11_5, e_s18]
  have e_carry6 : carry6 = f_carry6 := by simp only [carry6, f_carry6, e_s6_1]
  have e_s7_3 : s7_3 = f_s7_3 := by simp only [s7_3, f_s7_3, e_s7_2, e_carry6]
  have e_s6_2 : s6_2 = f_s6_2 := by simp only [s6_2, f_s6_2, e_s6_1, e_carry6]
  have e_carry8 : carry8 = f_carry8 := by simp only [carry8, f_carry8, e_s8_3]
  have e_s9_5 : s9_5 = f_s9_5 := by simp only [s9_5, f_s9_5, e_s9_4, e_carry8]
  have e_s8_4 : s8_4 = f_s8_4 := by simp only [s8_4, f_s8_4, e_s8_3, e_carry8]
  have e_carry10 : carry10 = f_carry10 := by simp only [carry10, f_carry10, e_s10_5]
  have e_s11_7 : s11_7 = f_s11_7 := by simp only [s11_7, f_s11_7, e_s11_6, e_carry10]
  have e_s10_6 : s10_6 = f_s10_6 := by simp only [s10_6, f_s10_6, e_s10_5, e_carry10]
  have e_carry12 : carry12 = f_carry12 := by simp only [carry12, f_carry12, e_s12_5]
  have e_s13_5 : s13_5 = f_s13_5 := by simp only [s13_5, f_s13_5, e_s13_4, e_carry12]
  have e_s12_6 : s12_6 = f_s12_6 := by simp only [s12_6, f_s12_6, e_s12_5, e_carry12]
  have e_carry14 : carry14 = f_carry14 := by simp only [carry14, f_carry14, e_s14_3]
  have e_s15_3 : s15_3 = f_s15_3 := by simp only [s15_3, f_s15_3, e_s15_2, e_carry14]
  have e_s14_4 : s14_4 = f_s14_4 := by simp only [s14_4, f_s14_4, e_s14_3, e_carry14]
  have e_carry16 : carry16 = f_carry16 := by simp only [carry16, f_carry16, e_s16_1]
  have e_s17_1 : s17_1 = f_s17_1 := by simp only [s17_1, f_s17_1, e_s17, e_carry16]
  have e_s16_2 : s16_2 = f_s16_2 := by simp only [s16_2, f_s16_2, e_s16_1, e_carry16]
  have e_carry7 : carry7 = f_carry7 := by simp only [carry7, f_carry7, e_s7_3]
  have e_s8_5 : s8_5 = f_s8_5 := by simp only [s8_5, f_s8_5, e_s8_4, e_carry7]
  have e_s7_4 : s7_4 = f_s7_4 := by simp only [s7_4, f_s7_4, e_s7_3, e_carry7]
  have e_carry9 : carry9 = f_carry9 := by simp only [carry9, f_carry9, e_s9_5]
  have e_s10_7 : s10_7 = f_s10_7 := by simp only [s10_7, f_s10_7, e_s10_6, e_carry9]
  have e_s9_6 : s9_6 = f_s9_6 := by simp only [s9_6, f_s9_6, e_s9_5, e_carry9]
  have e_carry11 : carry11 = f_carry11 := by simp only [carry11, f_carry11, e_s11_7]
  have e_s12_7 : s12_7 = f_s12_7 := by simp only [s12_7, f_s12_7, e_s12_6, e_carry11]
  have e_s11_8 : s11_8 = f_s11_8 := by simp only [s11_8, f_s11_8, e_s11_7, e_carry11]
  have e_carry13 : carry13 = f_carry13 := by simp only [carry13, f_carry13, e_s13_5]
  have e_s14_5 : s14_5 = f_s14_5 := by simp only [s14_5, f_s14_5, e_s14_4, e_carry13]
  have e_s13_6 : s13_6 = f_s13_6 := by simp only [s13_6, f_s13_6, e_s13_5, e_carry13]
  have e_carry15 : carry15 = f_carry15 := by simp only [carry15, f_carry15, e_s15_3]
  have e_s16_3 : s16_3 = f_s16_3 := by simp only [s16_3, f_s16_3, e_s16_2, e_carry15]
  have e_s15_4 : s15_4 = f_s15_4 := by simp only [s15_4, f_s15_4, e_s15_3, e_carry15]
  have e_s5_1 : s5_1 = f_s5_1 := by simp only [s5_1, f_s5_1, e_s5, e_s17_1]
  have e_s6_3 : s6_3 = f_s6_3 := by simp only [s6_3, f_s6_3, e_s6_2, e_s17_1]
  have e_s7_5 : s7_5 = f_s7_5 := by simp only [s7_5, f_s7_5, e_s7_4, e_s17_1]
  have e_s8_6 : s8_6 = f_s8_6 := by simp only [s8_6, f_s8_6, e_s8_5, e_s17_1]
  have e_s9_7 : s9_7 = f_s9_7 := by simp only [s9_7, f_s9_7, e_s9_6, e_s17_1]
  have e_s10_8 : s10_8 = f_s10_8 := by simp only [s10_8, f_s10_8, e_s10_7, e_s17_1]
  have e_s4_1 : s4_1 = f_s4_1 := by simp only [s4_1, f_s4_1, e_s4, e_s16_3]
  have e_s5_2 : s5_2 = f_s5_2 := by simp only [s5_2, f_s5_2, e_s5_1, e_s16_3]
  have e_s6_4 : s6_4 = f_s6_4 := by simp only [s6_4, f_s6_4, e_s6_3, e_s16_3]
  have e_s7_6 : s7_6 = f_s7_6 := by simp only [s7_6, f_s7_6, e_s7_5, e_s16_3]
  have e_s8_7 : s8_7 = f_s8_7 := by simp only [s8_7, f_s8_7, e_s8_6, e_s16_3]
  have e_s9_8 : s9_8 = f_s9_8 := by simp only [s9_8, f_s9_8, e_s9_7, e_s16_3]
  have e_s3_1 : s3_1 = f_s3_1 := by simp only [s3_1, f_s3_1, e_s3, e_s15_4]
  have e_s4_2 : s4_2 = f_s4_2 := by simp only [s4_2, f_s4_2, e_s4_1, e_s15_4]
  have e_s5_3 : s5_3 = f_s5_3 := by simp only [s5_3, f_s5_3, e_s5_2, e_s15_4]
  have e_s6_5 : s6_5 = f_s6_5 := by simp only [s6_5, f_s6_5, e_s6_4, e_s15_4]
  have e_s7_7 : s7_7 = f_s7_7 := by simp only [s7_7, f_s7_7, e_s7_6, e_s15_4]
  have e_s8_8 : s8_8 = f_s8_8 := by simp only [s8_8, f_s8_8, e_s8_7, e_s15_4]
  have e_s2_1 : s2_1 = f_s2_1 := by simp only [s2_1, f_s2_1, e_s2, e_s14_5]
  have e_s3_2 : s3_2 = f_s3_2 := by simp only [s3_2, f_s3_2, e_s3_1, e_s14_5]
  have e_s4_3 : s4_3 = f_s4_3 := by simp only [s4_3, f_s4_3, e_s4_2, e_s14_5]
  have e_s5_4 : s5_4 = f_s5_4 := by simp only [s5_4, f_s5_4, e_s5_3, e_s14_5]
  have e_s6_6 : s6_6 = f_s6_6 := by simp only [s6_6, f_s6_6, e_s6_5, e_s14_5]
  have e_s7_8 : s7_8 = f_s7_8 := by simp only [s7_8, f_s7_8, e_s7_7, e_s14_5]
  have e_s1_1 : s1_1 = f_s1_1 := by simp only [s1_1, f_s1_1, e_s1, e_s13_6]
  have e_s2_2 : s2_2 = f_s2_2 := by simp only [s2_2, f_s2_2, e_s2_1, e_s13_6]
  have e_s3_3 : s3_3 = f_s3_3 := by simp only [s3_3, f_s3_3, e_s3_2, e_s13_6]
  have e_s4_4 : s4_4 = f_s4_4 := by simp only [s4_4, f_s4_4, e_s4_3, e_s13_6]
  have e_s5_5 : s5_5 = f_s5_5 := by simp only [s5_5, f_s5_5, e_s5_4, e_s13_6]
  have e_s6_7 : s6_7 = f_s6_7 := by simp only [s6_7, f_s6_7, e_s6_6, e_s13_6]
  have e_s0_1 : s0_1 = f_s0_1 := by simp only [s0_1, f_s0_1, e_s0, e_s12_7]
  have e_s1_2 : s1_2 = f_s1_2 := by simp only [s1_2, f_s1_2, e_s1_1, e_s12_7]
  have e_s2_3 : s2_3 = f_s2_3 := by simp only [s2_3, f_s2_3, e_s2_2, e_s12_7]
  have e_s3_4 : s3_4 = f_s3_4 := by simp only [s3_4, f_s3_4, e_s3_3, e_s12_7]
  have e_s4_5 : s4_5 = f_s4_5 := by simp only [s4_5, f_s4_5, e_s4_4, e_s12_7]
  have e_s5_6 : s5_6 = f_s5_6 := by simp only [s5_6, f_s5_6, e_s5_5, e_s12_7]
  have e_s12_8 : s12_8 = f_s12_8 := rfl
  have e_carry0 : carry0 = f_carry0 := by simp only [carry0, f_carry0, e_s0_1]
  have e_s1_3 : s1_3 = f_s1_3 := by simp only [s1_3, f_s1_3, e_s1_2, e_carry0]
  have e_s0_2 : s0_2 = f_s0_2 := by simp only [s0_2, f_s0_2, e_s0_1, e_carry0]
  have e_carry2 : carry2 = f_carry2 := by simp only [carry2, f_carry2, e_s2_3]
  have e_s3_5 : s3_5 = f_s3_5 := by simp only [s3_5, f_s3_5, e_s3_4, e_carry2]
  have e_s2_4 : s2_4 = f_s2_4 := by simp only [s2_4, f_s2_4, e_s2_3, e_carry2]
  have e_carry4 : carry4 = f_carry4 := by simp only [carry4, f_carry4, e_s4_5]
  have e_s5_7 : s5_7 = f_s5_7 := by simp only [s5_7, f_s5_7, e_s5_6, e_carry4]
  have e_s4_6 : s4_6 = f_s4_6 := by simp only [s4_6, f_s4_6, e_s4_5, e_carry4]
  have e_carry6_1 : carry6_1 = f_carry6_1 := by simp only [carry6_1, f_carry6_1, e_s6_7]
  have e_s7_9 : s7_9 = f_s7_9 := by simp only [s7_9, f_s7_9, e_s7_8, e_carry6_1]
  have e_s6_8 : s6_8 = f_s6_8 := by simp only [s6_8, f_s6_8, e_s6_7, e_carry6_1]
  have e_carry8_1 : carry8_1 = f_carry8_1 := by simp only [carry8_1, f_carry8_1, e_s8_8]
  have e_s9_9 : s9_9 = f_s9_9 := by simp only [s9_9, f_s9_9, e_s9_8, e_carry8_1]
  have e_s8_9 : s8_9 = f_s8_9 := by simp only [s8_9, f_s8_9, e_s8_8, e_carry8_1]
  have e_carry10_1 : carry10_1 = f_carry10_1 := by simp only [carry10_1, f_carry10_1, e_s10_8]
  have e_s11_9 : s11_9 = f_s11_9 := by simp only [s11_9, f_s11_9, e_s11_8, e_carry10_1]
  have e_s10_9 : s10_9 = f_s10_9 := by simp only [s10_9, f_s10_9, e_s10_8, e_carry10_1]
  have e_carry1 : carry1 = f_carry1 := by simp only [carry1, f_carry1, e_s1_3]
  have e_s2_5 : s2_5 = f_s2_5 := by simp only [s2_5, f_s2_5, e_s2_4, e_carry1]
  have e_s1_4 : s1_4 = f_s1_4 := by simp only [s1_4, f_s1_4, e_s1_3, e_carry1]
  have e_carry3 : carry3 = f_carry3 := by simp only [carry3, f_carry3, e_s3_5]
  have e_s4_7 : s4_7 = f_s4_7 := by simp only [s4_7, f_s4_7, e_s4_6, e_carry3]
  have e_s3_6 : s3_6 = f_s3_6 := by simp only [s3_6, f_s3_6, e_s3_5, e_carry3]
  have e_carry5 : carry5 = f_carry5 := by simp only [carry5, f_carry5, e_s5_7]
  have e_s6_9 : s6_9 = f_s6_9 := by simp only [s6_9, f_s6_9, e_s6_8, e_carry5]
  have e_s5_8 : s5_8 = f_s5_8 := by simp only [s5_8, f_s5_8, e_s5_7, e_carry5]
  have e_carry7_1 : carry7_1 = f_carry7_1 := by simp only [carry7_1, f_carry7_1, e_s7_9]
  have e_s8_10 : s8_10 = f_s8_10 := by simp only [s8_10, f_s8_10, e_s8_9, e_carry7_1]
  have e_s7_10 : s7_10 = f_s7_10 := by simp only [s7_10, f_s7_10, e_s7_9, e_carry7_1]
  have e_carry9_1 : carry9_1 = f_carry9_1 := by simp only [carry9_1, f_carry9_1, e_s9_9]
  have e_s10_10 : s10_10 = f_s10_10 := by simp only [s10_10, f_s10_10, e_s10_9, e_carry9_1]
  have e_s9_10 : s9_10 = f_s9_10 := by simp only [s9_10, f_s9_10, e_s9_9, e_carry9_1]
  have e_carry11_1 : carry11_1 = f_carry11_1 := by simp only [carry11_1, f_carry11_1, e_s11_9]
  have e_s12_9 : s12_9 = f_s12_9 := by simp only [s12_9, f_s12_9, e_s12_8, e_carry11_1]
  have e_s11_10 : s11_10 = f_s11_10 := by simp only [s11_10, f_s11_10, e_s11_9, e_carry11_1]
  have e_s0_3 : s0_3 = f_s0_3 := by simp only [s0_3, f_s0_3, e_s0_2, e_s12_9]
  have e_s1_5 : s1_5 = f_s1_5 := by simp only [s1_5, f_s1_5, e_s1_4, e_s12_9]
  have e_s2_6 : s2_6 = f_s2_6 := by simp only [s2_6, f_s2_6, e_s2_5, e_s12_9]
  have e_s3_7 : s3_7 = f_s3_7 := by simp only [s3_7, f_s3_7, e_s3_6, e_s12_9]
  have e_s4_8 : s4_8 = f_s4_8 := by simp only [s4_8, f_s4_8, e_s4_7, e_s12_9]
  have e_s5_9 : s5_9 = f_s5_9 := by simp only [s5_9, f_s5_9, e_s5_8, e_s12_9]
  have e_s12_10 : s12_10 = f_s12_10 := rfl
  have e_carry0_1 : carry0_1 = f_carry0_1 := by simp only [carry0_1, f_carry0_1, e_s0_3]
  have e_s1_6 : s1_6 = f_s1_6 := by simp only [s1_6, f_s1_6, e_s1_5, e_carry0_1]
  have e_s0_4 : s0_4 = f_s0_4 := by simp only [s0_4, f_s0_4, e_s0_3, e_carry0_1]
  have e_carry1_1 : carry1_1 = f_carry1_1 := by simp only [carry1_1, f_carry1_1, e_s1_6]
  have e_s2_7 : s2_7 = f_s2_7 := by simp only [s2_7, f_s2_7, e_s2_6, e_carry1_1]
  have e_s1_7 : s1_7 = f_s1_7 := by simp only [s1_7, f_s1_7, e_s1_6, e_carry1_1]
  have e_carry2_1 : carry2_1 = f_carry2_1 := by simp only [carry2_1, f_carry2_1, e_s2_7]
  have e_s3_8 : s3_8 = f_s3_8 := by simp only [s3_8, f_s3_8, e_s3_7, e_carry2_1]
  have e_s2_8 : s2_8 = f_s2_8 := by simp only [s2_8, f_s2_8, e_s2_7, e_carry2_1]
  have e_carry3_1 : carry3_1 = f_carry3_1 := by simp only [carry3_1, f_carry3_1, e_s3_8]
  have e_s4_9 : s4_9 = f_s4_9 := by simp only [s4_9, f_s4_9, e_s4_8, e_carry3_1]
  have e_s3_9 : s3_9 = f_s3_9 := by simp only [s3_9, f_s3_9, e_s3_8, e_carry3_1]
  have e_carry4_1 : carry4_1 = f_carry4_1 := by simp only [carry4_1, f_carry4_1, e_s4_9]
  have e_s5_10 : s5_10 = f_s5_10 := by simp only [s5_10, f_s5_10, e_s5_9, e_carry4_1]
  have e_s4_10 : s4_10 = f_s4_10 := by simp only [s4_10, f_s4_10, e_s4_9, e_carry4_1]
  have e_carry5_1 : carry5_1 = f_carry5_1 := by simp only [carry5_1, f_carry5_1, e_s5_10]
  have e_s6_10 : s6_10 = f_s6_10 := by simp only [s6_10, f_s6_10, e_s6_9, e_carry5_1]
  have e_s5_11 : s5_11 = f_s5_11 := by simp only [s5_11, f_s5_11, e_s5_10, e_carry5_1]
  have e_carry6_2 : carry6_2 = f_carry6_2 := by simp only [carry6_2, f_carry6_2, e_s6_10]
  have e_s7_11 : s7_11 = f_s7_11 := by simp only [s7_11, f_s7_11, e_s7_10, e_carry6_2]
  have e_s6_11 : s6_11 = f_s6_11 := by simp only [s6_11, f_s6_11, e_s6_10, e_carry6_2]
  have e_carry7_2 : carry7_2 = f_carry7_2 := by simp only [carry7_2, f_carry7_2, e_s7_11]
  have e_s8_11 : s8_11 = f_s8_11 := by simp only [s8_11, f_s8_11, e_s8_10, e_carry7_2]
  have e_s7_12 : s7_12 = f_s7_12 := by simp only [s7_12, f_s7_12, e_s7_11, e_carry7_2]
  have e_carry8_2 : carry8_2 = f_carry8_2 := by simp only [carry8_2, f_carry8_2, e_s8_11]
  have e_s9_11 : s9_11 = f_s9_11 := by simp only [s9_11, f_s9_11, e_s9_10, e_carry8_2]
  have e_s8_12 : s8_12 = f_s8_12 := by simp only [s8_12, f_s8_12, e_s8_11, e_carry8_2]
  have e_carry9_2 : carry9_2 = f_carry9_2 := by simp only [carry9_2, f_carry9_2, e_s9_11]
  have e_s10_11 : s10_11 = f_s10_11 := by simp only [s10_11, f_s10_11, e_s10_10, e_carry9_2]
  have e_s9_12 : s9_12 = f_s9_12 := by simp only [s9_12, f_s9_12, e_s9_11, e_carry9_2]
  have e_carry10_2 : carry10_2 = f_carry10_2 := by simp only [carry10_2, f_carry10_2, e_s10_11]
  have e_s11_11 : s11_11 = f_s11_11 := by simp only [s11_11, f_s11_11, e_s11_10, e_carry10_2]
  have e_s10_12 : s10_12 = f_s10_12 := by simp only [s10_12, f_s10_12, e_s10_11, e_carry10_2]
  have e_carry11_2 : carry11_2 = f_carry11_2 := by simp only [carry11_2, f_carry11_2, e_s11_11]
  have e_s12_11 : s12_11 = f_s12_11 := by simp only [s12_11, f_s12_11, e_s12_10, e_carry11_2]
  have e_s11_12 : s11_12 = f_s11_12 := by simp only [s11_12, f_s11_12, e_s11_11, e_carry11_2]
  have e_s0_5 : s0_5 = f_s0_5 := by simp only [s0_5, f_s0_5, e_s0_4, e_s12_11]
  have e_s1_8 : s1_8 = f_s1_8 := by simp only [s1_8, f_s1_8, e_s1_7, e_s12_11]
  have e_s2_9 : s2_9 = f_s2_9 := by simp only [s2_9, f_s2_9, e_s2_8, e_s12_11]
  have e_s3_10 : s3_10 = f_s3_10 := by simp only [s3_10, f_s3_10, e_s3_9, e_s12_11]
  have e_s4_11 : s4_11 = f_s4_11 := by simp only [s4_11, f_s4_11, e_s4_10, e_s12_11]
  have e_s5_12 : s5_12 = f_s5_12 := by simp only [s5_12, f_s5_12, e_s5_11, e_s12_11]
  have e_carry0_2 : carry0_2 = f_carry0_2 := by simp only [carry0_2, f_carry0_2, e_s0_5]
  have e_s1_9 : s1_9 = f_s1_9 := by simp only [s1_9, f_s1_9, e_s1_8, e_carry0_2]
  have e_s0_6 : s0_6 = f_s0_6 := by simp only [s0_6, f_s0_6, e_s0_5, e_carry0_2]
  have e_carry1_2 : carry1_2 = f_carry1_2 := by simp only [carry1_2, f_carry1_2, e_s1_9]
  have e_s2_10 : s2_10 = f_s2_10 := by simp only [s2_10, f_s2_10, e_s2_9, e_carry1_2]
  have e_s1_10 : s1_10 = f_s1_10 := by simp only [s1_10, f_s1_10, e_s1_9, e_carry1_2]
  have e_carry2_2 : carry2_2 = f_carry2_2 := by simp only [carry2_2, f_carry2_2, e_s2_10]
  have e_s3_11 : s3_11 = f_s3_11 := by simp only [s3_11, f_s3_11, e_s3_10, e_carry2_2]
  have e_s2_11 : s2_11 = f_s2_11 := by simp only [s2_11, f_s2_11, e_s2_10, e_carry2_2]
  have e_carry3_2 : carry3_2 = f_carry3_2 := by simp only [carry3_2, f_carry3_2, e_s3_11]
  have e_s4_12 : s4_12 = f_s4_12 := by simp only [s4_12, f_s4_12, e_s4_11, e_carry3_2]
  have e_s3_12 : s3_12 = f_s3_12 := by simp only [s3_12, f_s3_12, e_s3_11, e_carry3_2]
  have e_carry4_2 : carry4_2 = f_carry4_2 := by simp only [carry4_2, f_carry4_2, e_s4_12]
  have e_s5_13 : s5_13 = f_s5_13 := by simp only [s5_13, f_s5_13, e_s5_12, e_carry4_2]
  have e_s4_13 : s4_13 = f_s4_13 := by simp only [s4_13, f_s4_13, e_s4_12, e_carry4_2]
  have e_carry5_2 : carry5_2 = f_carry5_2 := by simp only [carry5_2, f_carry5_2, e_s5_13]
  have e_s6_12 : s6_12 = f_s6_12 := by simp only [s6_12, f_s6_12, e_s6_11, e_carry5_2]
  have e_s5_14 : s5_14 = f_s5_14 := by simp only [s5_14, f_s5_14, e_s5_13, e_carry5_2]
  have e_carry6_3 : carry6_3 = f_carry6_3 := by simp only [carry6_3, f_carry6_3, e_s6_12]
  have e_s7_13 : s7_13 = f_s7_13 := by simp only [s7_13, f_s7_13, e_s7_12, e_carry6_3]
  have e_s6_13 : s6_13 = f_s6_13 := by simp only [s6_13, f_s6_13, e_s6_12, e_carry6_3]
  have e_carry7_3 : carry7_3 = f_carry7_3 := by simp only [carry7_3, f_carry7_3, e_s7_13]
  have e_s8_13 : s8_13 = f_s8_13 := by simp only [s8_13, f_s8_13, e_s8_12, e_carry7_3]
  have e_s7_14 : s7_14 = f_s7_14 := by simp only [s7_14, f_s7_14, e_s7_13, e_carry7_3]
  have e_carry8_3 : carry8_3 = f_carry8_3 := by simp only [carry8_3, f_carry8_3, e_s8_13]
  have e_s9_13 : s9_13 = f_s9_13 := by simp only [s9_13, f_s9_13, e_s9_12, e_carry8_3]
  have e_s8_14 : s8_14 = f_s8_14 := by simp only [s8_14, f_s8_14, e_s8_13, e_carry8_3]
  have e_carry9_3 : carry9_3 = f_carry9_3 := by simp only [carry9_3, f_carry9_3, e_s9_13]
  have e_s10_13 : s10_13 = f_s10_13 := by simp only [s10_13, f_s10_13, e_s10_12, e_carry9_3]
  have e_s9_14 : s9_14 = f_s9_14 := by simp only [s9_14, f_s9_14, e_s9_13, e_carry9_3]
  have e_carry10_3 : carry10_3 = f_carry10_3 := by simp only [carry10_3, f_carry10_3, e_s10_13]
  have e_s11_13 : s11_13 = f_s11_13 := by simp only [s11_13, f_s11_13, e_s11_12, e_carry10_3]
  have e_s10_14 : s10_14 = f_s10_14 := by simp only [s10_14, f_s10_14, e_s10_13, e_carry10_3]
  exact
    x25519_sc_reduce.bytes_eq_pack e_s0_6 e_s1_10 e_s2_11 e_s3_12 e_s4_13 e_s5_14 e_s6_13 e_s7_14
      e_s8_14 e_s9_14 e_s10_14 e_s11_13 (resid_le s0_5) (resid_le s1_9) (resid_le s2_10)
      (resid_le s3_11) (resid_le s4_12) (resid_le s5_13) (resid_le s6_12) (resid_le s7_13)
      (resid_le s8_13) (resid_le s9_13) (resid_le s10_13)

/-- The 32 bytes the code stores, from the final limbs. -/
def x25519_sc_reduce.out
    (s0_6 s1_10 s2_11 s3_12 s4_13 s5_14 s6_13 s7_14 s8_14 s9_14 s10_14 s11_13 : BitVec 64) :
    BitVec 256 :=
  (BitVec.setWidth 8 (s11_13 >>> 17)) ++
    ((BitVec.setWidth 8 (s11_13 >>> 9)) ++
      ((BitVec.setWidth 8 (s11_13 >>> 1)) ++
        ((BitVec.setWidth 8 s11_13 <<< 7 ||| BitVec.setWidth 8 (s10_14 >>> 14)) ++
          ((BitVec.setWidth 8 (s10_14 >>> 6)) ++
            ((BitVec.setWidth 8 s10_14 <<< 2 ||| BitVec.setWidth 8 (s9_14 >>> 19)) ++
              ((BitVec.setWidth 16 (s9_14 >>> 3)) ++
                ((BitVec.setWidth 8 s9_14 <<< 5 ||| BitVec.setWidth 8 (s8_14 >>> 16)) ++
                  ((BitVec.setWidth 16 s8_14) ++
                    ((BitVec.setWidth 16 (s7_14 >>> 5)) ++
                      ((BitVec.setWidth 8 s7_14 <<< 3 ||| BitVec.setWidth 8 (s6_13 >>> 18)) ++
                        ((BitVec.setWidth 16 (s6_13 >>> 2)) ++
                          ((BitVec.setWidth 8 s6_13 <<< 6 ||| BitVec.setWidth 8 (s5_14 >>> 15)) ++
                            ((BitVec.setWidth 8 (s5_14 >>> 7)) ++
                              ((BitVec.setWidth 8 s5_14 <<< 1 |||
                                  BitVec.setWidth 8 (s4_13 >>> 20)) ++
                                ((BitVec.setWidth 16 (s4_13 >>> 4)) ++
                                  ((BitVec.setWidth 8 s4_13 <<< 4 |||
                                      BitVec.setWidth 8 (s3_12 >>> 17)) ++
                                    ((BitVec.setWidth 16 (s3_12 >>> 1)) ++
                                      ((BitVec.setWidth 8 s3_12 <<< 7 |||
                                          BitVec.setWidth 8 (s2_11 >>> 14)) ++
                                        ((BitVec.setWidth 8 (s2_11 >>> 6)) ++
                                          ((BitVec.setWidth 8 s2_11 <<< 2 |||
                                              BitVec.setWidth 8 (s1_10 >>> 19)) ++
                                            ((BitVec.setWidth 16 (s1_10 >>> 3)) ++
                                              ((BitVec.setWidth 8 s1_10 <<< 5 |||
                                                  BitVec.setWidth 8 (s0_6 >>> 16)) ++
                                                ((BitVec.setWidth 16 s0_6))))))))))))))))))))))))

/-! ## The compiled computation -/

/-- The compiled code's computation, one `let` per value, on the 64 bytes `x`. -/
def x25519_sc_reduce.ir (x : BitVec 512) : BitVec 256 :=
  let t555 := load3 x 0
  let t556 := t555 &&& 2097151#64
  let t558 := load4 x 2
  let t559 := t558 >>> 5
  let t560 := t559 &&& 2097151#64
  let t562 := load3 x 5
  let t563 := t562 >>> 2
  let t564 := t563 &&& 2097151#64
  let t566 := load4 x 7
  let t567 := t566 >>> 7
  let t568 := t567 &&& 2097151#64
  let t570 := load4 x 10
  let t571 := t570 >>> 4
  let t572 := t571 &&& 2097151#64
  let t574 := load3 x 13
  let t575 := t574 >>> 1
  let t576 := t575 &&& 2097151#64
  let t578 := load4 x 15
  let t579 := t578 >>> 6
  let t580 := t579 &&& 2097151#64
  let t582 := load3 x 18
  let t583 := t582 >>> 3
  let t585 := load3 x 21
  let t586 := t585 &&& 2097151#64
  let t588 := load4 x 23
  let t589 := t588 >>> 5
  let t590 := t589 &&& 2097151#64
  let t592 := load3 x 26
  let t593 := t592 >>> 2
  let t594 := t593 &&& 2097151#64
  let t596 := load4 x 28
  let t597 := t596 >>> 7
  let t598 := t597 &&& 2097151#64
  let t600 := load4 x 31
  let t601 := t600 >>> 4
  let t602 := t601 &&& 2097151#64
  let t604 := load3 x 34
  let t605 := t604 >>> 1
  let t606 := t605 &&& 2097151#64
  let t608 := load4 x 36
  let t609 := t608 >>> 6
  let t610 := t609 &&& 2097151#64
  let t612 := load3 x 39
  let t613 := t612 >>> 3
  let t615 := load3 x 42
  let t616 := t615 &&& 2097151#64
  let t618 := load4 x 44
  let t619 := t618 >>> 5
  let t620 := t619 &&& 2097151#64
  let t622 := load3 x 47
  let t623 := t622 >>> 2
  let t624 := t623 &&& 2097151#64
  let t626 := load4 x 49
  let t627 := t626 >>> 7
  let t628 := t627 &&& 2097151#64
  let t630 := load4 x 52
  let t631 := t630 >>> 4
  let t632 := t631 &&& 2097151#64
  let t634 := load3 x 55
  let t635 := t634 >>> 1
  let t636 := t635 &&& 2097151#64
  let t638 := load4 x 57
  let t639 := t638 >>> 6
  let t640 := t639 &&& 2097151#64
  let t642 := load4 x 60
  let t643 := t642 >>> 3
  let t644 := t643 * 666643#64
  let t645 := t643 * 470296#64
  let t646 := t643 * 654183#64
  let t647 := t643 * 18446744073708553811#64
  let t648 := t643 * 136657#64
  let t649 := t648 + t613
  let t650 := t643 * 18446744073708867715#64
  let t651 := t650 + t616
  let t652 := t640 * 666643#64
  let t653 := t640 * 470296#64
  let t654 := t640 * 654183#64
  let t655 := t640 * 18446744073708553811#64
  let t656 := t640 * 136657#64
  let t657 := t640 * 18446744073708867715#64
  let t658 := t649 + t657
  let t659 := t636 * 666643#64
  let t660 := t636 * 470296#64
  let t661 := t636 * 654183#64
  let t662 := t636 * 18446744073708553811#64
  let t663 := t636 * 136657#64
  let t664 := t636 * 18446744073708867715#64
  let t665 := t664 + t610
  let t666 := t665 + t647
  let t667 := t666 + t656
  let t668 := t632 * 666643#64
  let t669 := t632 * 470296#64
  let t670 := t632 * 654183#64
  let t671 := t632 * 18446744073708553811#64
  let t672 := t632 * 136657#64
  let t673 := t632 * 18446744073708867715#64
  let t674 := t628 * 666643#64
  let t675 := t628 * 470296#64
  let t676 := t628 * 654183#64
  let t677 := t628 * 18446744073708553811#64
  let t678 := t628 * 136657#64
  let t679 := t628 * 18446744073708867715#64
  let t680 := t679 + t602
  let t681 := t680 + t672
  let t682 := t681 + t662
  let t683 := t682 + t645
  let t684 := t683 + t654
  let t685 := t624 * 666643#64
  let t686 := t685 + t580
  let t687 := t624 * 470296#64
  let t688 := t624 * 654183#64
  let t689 := t688 + t586
  let t690 := t689 + t675
  let t691 := t690 + t668
  let t692 := t624 * 18446744073708553811#64
  let t693 := t624 * 136657#64
  let t694 := t693 + t594
  let t695 := t694 + t677
  let t696 := t695 + t670
  let t697 := t696 + t660
  let t698 := t697 + t652
  let t699 := t624 * 18446744073708867715#64
  let t700 := t686 + 1048576#64
  let t701 := t700 >>> 21
  let t702 := t687 + t583
  let t703 := t702 + t674
  let t704 := t703 + t701
  let t705 := t701 <<< 21
  let t706 := t686 - t705
  let t707 := t691 + 1048576#64
  let t708 := t707 >>> 21
  let t709 := t692 + t590
  let t710 := t709 + t676
  let t711 := t710 + t669
  let t712 := t711 + t659
  let t713 := t712 + t708
  let t714 := t708 <<< 21
  let t715 := t691 - t714
  let t716 := t698 + 1048576#64
  let t717 := t716.sshiftRight 21
  let t718 := t699 + t598
  let t719 := t718 + t678
  let t720 := t719 + t671
  let t721 := t720 + t661
  let t722 := t721 + t644
  let t723 := t722 + t653
  let t724 := t723 + t717
  let t725 := t717 <<< 21
  let t726 := t698 - t725
  let t727 := t684 + 1048576#64
  let t728 := t727.sshiftRight 21
  let t729 := t673 + t606
  let t730 := t729 + t663
  let t731 := t730 + t646
  let t732 := t731 + t655
  let t733 := t732 + t728
  let t734 := t728 <<< 21
  let t735 := t684 - t734
  let t736 := t667 + 1048576#64
  let t737 := t736.sshiftRight 21
  let t738 := t658 + t737
  let t739 := t737 <<< 21
  let t740 := t667 - t739
  let t741 := t651 + 1048576#64
  let t742 := t741.sshiftRight 21
  let t743 := t742 + t620
  let t744 := t742 <<< 21
  let t745 := t651 - t744
  let t746 := t704 + 1048576#64
  let t747 := t746 >>> 21
  let t748 := t715 + t747
  let t749 := t747 <<< 21
  let t750 := t704 - t749
  let t751 := t713 + 1048576#64
  let t752 := t751.sshiftRight 21
  let t753 := t752 <<< 21
  let t754 := t724 + 1048576#64
  let t755 := t754.sshiftRight 21
  let t756 := t755 + t735
  let t757 := t755 <<< 21
  let t758 := t724 - t757
  let t759 := t733 + 1048576#64
  let t760 := t759.sshiftRight 21
  let t761 := t760 + t740
  let t762 := t760 <<< 21
  let t763 := t733 - t762
  let t764 := t738 + 1048576#64
  let t765 := t764.sshiftRight 21
  let t766 := t765 + t745
  let t767 := t765 <<< 21
  let t768 := t738 - t767
  let t769 := t743 * 666643#64
  let t770 := t769 + t576
  let t771 := t743 * 470296#64
  let t772 := t706 + t771
  let t773 := t743 * 654183#64
  let t774 := t750 + t773
  let t775 := t743 * 18446744073708553811#64
  let t776 := t748 + t775
  let t777 := t743 * 136657#64
  let t778 := t743 * 18446744073708867715#64
  let t779 := t726 + t778
  let t780 := t779 + t752
  let t781 := t766 * 666643#64
  let t782 := t781 + t572
  let t783 := t766 * 470296#64
  let t784 := t770 + t783
  let t785 := t766 * 654183#64
  let t786 := t772 + t785
  let t787 := t766 * 18446744073708553811#64
  let t788 := t774 + t787
  let t789 := t766 * 136657#64
  let t790 := t776 + t789
  let t791 := t766 * 18446744073708867715#64
  let t792 := t768 * 666643#64
  let t793 := t768 * 470296#64
  let t794 := t768 * 654183#64
  let t795 := t768 * 18446744073708553811#64
  let t796 := t768 * 136657#64
  let t797 := t788 + t796
  let t798 := t768 * 18446744073708867715#64
  let t799 := t790 + t798
  let t800 := t761 * 666643#64
  let t801 := t761 * 470296#64
  let t802 := t761 * 654183#64
  let t803 := t761 * 18446744073708553811#64
  let t804 := t761 * 136657#64
  let t805 := t761 * 18446744073708867715#64
  let t806 := t797 + t805
  let t807 := t763 * 666643#64
  let t808 := t807 + t560
  let t809 := t763 * 470296#64
  let t810 := t763 * 654183#64
  let t811 := t763 * 18446744073708553811#64
  let t812 := t763 * 136657#64
  let t813 := t763 * 18446744073708867715#64
  let t814 := t786 + t813
  let t815 := t814 + t795
  let t816 := t815 + t804
  let t817 := t756 * 666643#64
  let t818 := t817 + t556
  let t819 := t756 * 470296#64
  let t820 := t808 + t819
  let t821 := t756 * 654183#64
  let t822 := t809 + t564
  let t823 := t822 + t800
  let t824 := t823 + t821
  let t825 := t756 * 18446744073708553811#64
  let t826 := t756 * 136657#64
  let t827 := t782 + t811
  let t828 := t827 + t793
  let t829 := t828 + t802
  let t830 := t829 + t826
  let t831 := t756 * 18446744073708867715#64
  let t832 := t818 + 1048576#64
  let t833 := t832.sshiftRight 21
  let t834 := t820 + t833
  let t835 := t833 <<< 21
  let t836 := t818 - t835
  let t837 := t824 + 1048576#64
  let t838 := t837.sshiftRight 21
  let t839 := t810 + t568
  let t840 := t839 + t792
  let t841 := t840 + t801
  let t842 := t841 + t825
  let t843 := t842 + t838
  let t844 := t838 <<< 21
  let t845 := t830 + 1048576#64
  let t846 := t845.sshiftRight 21
  let t847 := t784 + t812
  let t848 := t847 + t794
  let t849 := t848 + t803
  let t850 := t849 + t831
  let t851 := t850 + t846
  let t852 := t846 <<< 21
  let t853 := t816 + 1048576#64
  let t854 := t853.sshiftRight 21
  let t855 := t806 + t854
  let t856 := t854 <<< 21
  let t857 := t816 - t856
  let t858 := t799 + 1048576#64
  let t859 := t858.sshiftRight 21
  let t860 := t777 + t713
  let t861 := t860 - t753
  let t862 := t861 + t791
  let t863 := t862 + t859
  let t864 := t859 <<< 21
  let t865 := t799 - t864
  let t866 := t780 + 1048576#64
  let t867 := t866.sshiftRight 21
  let t868 := t867 + t758
  let t869 := t867 <<< 21
  let t870 := t780 - t869
  let t871 := t834 + 1048576#64
  let t872 := t871.sshiftRight 21
  let t873 := t872 <<< 21
  let t874 := t843 + 1048576#64
  let t875 := t874.sshiftRight 21
  let t876 := t875 <<< 21
  let t877 := t851 + 1048576#64
  let t878 := t877.sshiftRight 21
  let t879 := t857 + t878
  let t880 := t878 <<< 21
  let t881 := t855 + 1048576#64
  let t882 := t881.sshiftRight 21
  let t883 := t865 + t882
  let t884 := t882 <<< 21
  let t885 := t855 - t884
  let t886 := t863 + 1048576#64
  let t887 := t886.sshiftRight 21
  let t888 := t870 + t887
  let t889 := t887 <<< 21
  let t890 := t863 - t889
  let t891 := t868 + 1048576#64
  let t892 := t891.sshiftRight 21
  let t893 := t892 <<< 21
  let t894 := t868 - t893
  let t895 := t892 * 666643#64
  let t896 := t836 + t895
  let t897 := t892 * 470296#64
  let t898 := t892 * 654183#64
  let t899 := t892 * 18446744073708553811#64
  let t900 := t892 * 136657#64
  let t901 := t892 * 18446744073708867715#64
  let t902 := t896.sshiftRight 21
  let t903 := t897 - t873
  let t904 := t903 + t834
  let t905 := t904 + t902
  let t906 := t902 <<< 21
  let t907 := t896 - t906
  let t908 := t905.sshiftRight 21
  let t909 := t898 - t844
  let t910 := t909 + t824
  let t911 := t910 + t872
  let t912 := t911 + t908
  let t913 := t908 <<< 21
  let t914 := t905 - t913
  let t915 := t912.sshiftRight 21
  let t916 := t899 - t876
  let t917 := t916 + t843
  let t918 := t917 + t915
  let t919 := t915 <<< 21
  let t920 := t912 - t919
  let t921 := t918.sshiftRight 21
  let t922 := t900 - t852
  let t923 := t922 + t830
  let t924 := t923 + t875
  let t925 := t924 + t921
  let t926 := t921 <<< 21
  let t927 := t918 - t926
  let t928 := t925.sshiftRight 21
  let t929 := t901 - t880
  let t930 := t929 + t851
  let t931 := t930 + t928
  let t932 := t928 <<< 21
  let t933 := t925 - t932
  let t934 := t931.sshiftRight 21
  let t935 := t879 + t934
  let t936 := t934 <<< 21
  let t937 := t931 - t936
  let t938 := t935.sshiftRight 21
  let t939 := t938 + t885
  let t940 := t938 <<< 21
  let t941 := t935 - t940
  let t942 := t939.sshiftRight 21
  let t943 := t883 + t942
  let t944 := t942 <<< 21
  let t945 := t939 - t944
  let t946 := t943.sshiftRight 21
  let t947 := t946 + t890
  let t948 := t946 <<< 21
  let t949 := t943 - t948
  let t950 := t947.sshiftRight 21
  let t951 := t888 + t950
  let t952 := t950 <<< 21
  let t953 := t947 - t952
  let t954 := t951.sshiftRight 21
  let t955 := t954 + t894
  let t956 := t954 <<< 21
  let t957 := t951 - t956
  let t958 := t955.sshiftRight 21
  let t959 := t958 <<< 21
  let t960 := t955 - t959
  let t961 := t958 * 666643#64
  let t962 := t961 + t907
  let t963 := t958 * 470296#64
  let t964 := t914 + t963
  let t965 := t958 * 654183#64
  let t966 := t920 + t965
  let t967 := t958 * 18446744073708553811#64
  let t968 := t927 + t967
  let t969 := t958 * 136657#64
  let t970 := t933 + t969
  let t971 := t958 * 18446744073708867715#64
  let t972 := t937 + t971
  let t973 := t962.sshiftRight 21
  let t974 := t964 + t973
  let t975 := t973 <<< 21
  let t976 := t962 - t975
  let t977 := t974.sshiftRight 21
  let t978 := t966 + t977
  let t979 := t977 <<< 21
  let t980 := t974 - t979
  let t981 := t978.sshiftRight 21
  let t982 := t968 + t981
  let t983 := t981 <<< 21
  let t984 := t978 - t983
  let t985 := t982.sshiftRight 21
  let t986 := t970 + t985
  let t987 := t985 <<< 21
  let t988 := t982 - t987
  let t989 := t986.sshiftRight 21
  let t990 := t972 + t989
  let t991 := t989 <<< 21
  let t992 := t986 - t991
  let t993 := t990.sshiftRight 21
  let t994 := t993 + t941
  let t995 := t993 <<< 21
  let t996 := t990 - t995
  let t997 := t994.sshiftRight 21
  let t998 := t997 + t945
  let t999 := t997 <<< 21
  let t1000 := t994 - t999
  let t1001 := t998.sshiftRight 21
  let t1002 := t1001 + t949
  let t1003 := t1001 <<< 21
  let t1004 := t998 - t1003
  let t1005 := t1002.sshiftRight 21
  let t1006 := t1005 + t953
  let t1007 := t1005 <<< 21
  let t1008 := t1002 - t1007
  let t1009 := t1006.sshiftRight 21
  let t1010 := t1009 + t957
  let t1011 := t1009 <<< 21
  let t1012 := t1006 - t1011
  let t1013 := t1010.sshiftRight 21
  let t1014 := t1013 + t960
  let t1015 := t1013 <<< 21
  let t1016 := t1010 - t1015
  x25519_sc_reduce.out t976 t980 t984 t988 t992 t996 t1000 t1004 t1008 t1012 t1016 t1014

/-- A 24-bit value shifted right by `3` fits the mask. -/
theorem x25519_sc_reduce.nomask3_3 (y : BitVec 24) :
    y.setWidth 64 >>> 3 = 2097151#64 &&& y.setWidth 64 >>> 3 := by bv_decide

theorem x25519_sc_reduce.lshr701 (x : BitVec 512) :
    ((((((load3 x 47) >>> 2) &&& 2097151#64) * 666643#64) + (((load4 x 15) >>> 6) &&& 2097151#64)) +
          1048576#64) >>>
        21 =
      ((((((load3 x 47) >>> 2) &&& 2097151#64) * 666643#64) +
              (((load4 x 15) >>> 6) &&& 2097151#64)) +
            1048576#64).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry6` as the C computes it is the compiled `%701`. -/
theorem x25519_sc_reduce.bridge_carry6
    (t685 t686 t700 t701 t624 t580 s6_1 carry6 s6 s18 : BitVec 64) (ht685 : t685 = t624 * 666643#64)
    (ht686 : t686 = t685 + t580) (ht700 : t700 = t686 + 1048576#64)
    (ht701 : t701 = t700.sshiftRight 21) (et624 : t624 = s18) (et580 : t580 = s6)
    (hs6_1 : s6_1 = s6 + s18 * 666643#64) (hcarry6 : carry6 = (s6_1 + 1048576#64).sshiftRight 21) :
    t701 = carry6 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

theorem x25519_sc_reduce.lshr708 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& 2097151#64) * 654183#64) + ((load3 x 21) &&& 2097151#64)) +
              ((((load4 x 49) >>> 7) &&& 2097151#64) * 470296#64)) +
            ((((load4 x 52) >>> 4) &&& 2097151#64) * 666643#64)) +
          1048576#64) >>>
        21 =
      ((((((((load3 x 47) >>> 2) &&& 2097151#64) * 654183#64) + ((load3 x 21) &&& 2097151#64)) +
                ((((load4 x 49) >>> 7) &&& 2097151#64) * 470296#64)) +
              ((((load4 x 52) >>> 4) &&& 2097151#64) * 666643#64)) +
            1048576#64).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry8` as the C computes it is the compiled `%708`. -/
theorem x25519_sc_reduce.bridge_carry8
    (t668 t675 t688 t689 t690 t691 t707 t708 t624 t586 t628 t632 s8_1 s8_2 s8_3 carry8 s8 s18 s19
      s20 : BitVec 64)
    (ht668 : t668 = t632 * 666643#64) (ht675 : t675 = t628 * 470296#64)
    (ht688 : t688 = t624 * 654183#64) (ht689 : t689 = t688 + t586) (ht690 : t690 = t689 + t675)
    (ht691 : t691 = t690 + t668) (ht707 : t707 = t691 + 1048576#64)
    (ht708 : t708 = t707.sshiftRight 21) (et624 : t624 = s18) (et586 : t586 = s8)
    (et628 : t628 = s19) (et632 : t632 = s20) (hs8_1 : s8_1 = s8 + s20 * 666643#64)
    (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) (hs8_3 : s8_3 = s8_2 + s18 * 654183#64)
    (hcarry8 : carry8 = (s8_3 + 1048576#64).sshiftRight 21) : t708 = carry8 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry10` as the C computes it is the compiled `%717`. -/
theorem x25519_sc_reduce.bridge_carry10
    (t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t716 t717 t624 t594 t628 t632 t636 t640 s10_1
      s10_2 s10_3 s10_4 s10_5 carry10 s10 s18 s19 s20 s21 s22 : BitVec 64)
    (ht652 : t652 = t640 * 666643#64) (ht660 : t660 = t636 * 470296#64)
    (ht670 : t670 = t632 * 654183#64) (ht677 : t677 = t628 * 18446744073708553811#64)
    (ht693 : t693 = t624 * 136657#64) (ht694 : t694 = t693 + t594) (ht695 : t695 = t694 + t677)
    (ht696 : t696 = t695 + t670) (ht697 : t697 = t696 + t660) (ht698 : t698 = t697 + t652)
    (ht716 : t716 = t698 + 1048576#64) (ht717 : t717 = t716.sshiftRight 21) (et624 : t624 = s18)
    (et594 : t594 = s10) (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21)
    (et640 : t640 = s22) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hcarry10 : carry10 = (s10_5 + 1048576#64).sshiftRight 21) : t717 = carry10 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry12` as the C computes it is the compiled `%728`. -/
theorem x25519_sc_reduce.bridge_carry12
    (t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t727 t728 t628 t602 t632 t636 t643 t640 s12_1
      s12_2 s12_3 s12_4 s12_5 carry12 s12 s19 s20 s21 s22 s23 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht654 : t654 = t640 * 654183#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht672 : t672 = t632 * 136657#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht727 : t727 = t684 + 1048576#64)
    (ht728 : t728 = t727.sshiftRight 21) (et628 : t628 = s19) (et602 : t602 = s12)
    (et632 : t632 = s20) (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hcarry12 : carry12 = (s12_5 + 1048576#64).sshiftRight 21) : t728 = carry12 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry14` as the C computes it is the compiled `%737`. -/
theorem x25519_sc_reduce.bridge_carry14
    (t647 t656 t664 t665 t666 t667 t736 t737 t636 t610 t643 t640 s14_1 s14_2 s14_3 carry14 s14 s21
      s22 s23 : BitVec 64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht736 : t736 = t667 + 1048576#64)
    (ht737 : t737 = t736.sshiftRight 21) (et636 : t636 = s21) (et610 : t610 = s14)
    (et643 : t643 = s23) (et640 : t640 = s22) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hcarry14 : carry14 = (s14_3 + 1048576#64).sshiftRight 21) : t737 = carry14 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry16` as the C computes it is the compiled `%742`. -/
theorem x25519_sc_reduce.bridge_carry16
    (t650 t651 t741 t742 t643 t616 s16_1 carry16 s16 s23 : BitVec 64)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht741 : t741 = t651 + 1048576#64) (ht742 : t742 = t741.sshiftRight 21) (et643 : t643 = s23)
    (et616 : t616 = s16) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hcarry16 : carry16 = (s16_1 + 1048576#64).sshiftRight 21) : t742 = carry16 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

theorem x25519_sc_reduce.lshr747 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& 2097151#64) * 470296#64) + ((load3 x 18) >>> 3)) +
              ((((load4 x 49) >>> 7) &&& 2097151#64) * 666643#64)) +
            (((((((load3 x 47) >>> 2) &&& 2097151#64) * 666643#64) +
                  (((load4 x 15) >>> 6) &&& 2097151#64)) +
                1048576#64) >>>
              21)) +
          1048576#64) >>>
        21 =
      ((((((((load3 x 47) >>> 2) &&& 2097151#64) * 470296#64) + ((load3 x 18) >>> 3)) +
                ((((load4 x 49) >>> 7) &&& 2097151#64) * 666643#64)) +
              (((((((load3 x 47) >>> 2) &&& 2097151#64) * 666643#64) +
                    (((load4 x 15) >>> 6) &&& 2097151#64)) +
                  1048576#64) >>>
                21)) +
            1048576#64).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry7` as the C computes it is the compiled `%747`. -/
theorem x25519_sc_reduce.bridge_carry7
    (t674 t687 t702 t703 t704 t746 t747 t624 t583 t628 t701 s7_1 s7_2 s7_3 carry7 s7 s18 s19
      carry6 : BitVec 64)
    (ht674 : t674 = t628 * 666643#64) (ht687 : t687 = t624 * 470296#64) (ht702 : t702 = t687 + t583)
    (ht703 : t703 = t702 + t674) (ht704 : t704 = t703 + t701) (ht746 : t746 = t704 + 1048576#64)
    (ht747 : t747 = t746.sshiftRight 21) (et624 : t624 = s18) (et583 : t583 = s7)
    (et628 : t628 = s19) (et701 : t701 = carry6) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hcarry7 : carry7 = (s7_3 + 1048576#64).sshiftRight 21) : t747 = carry7 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry9` as the C computes it is the compiled `%752`. -/
theorem x25519_sc_reduce.bridge_carry9
    (t659 t669 t676 t692 t709 t710 t711 t712 t713 t751 t752 t624 t590 t628 t632 t636 t708 s9_1 s9_2
      s9_3 s9_4 s9_5 carry9 s9 s18 s19 s20 s21 carry8 : BitVec 64)
    (ht659 : t659 = t636 * 666643#64) (ht669 : t669 = t632 * 470296#64)
    (ht676 : t676 = t628 * 654183#64) (ht692 : t692 = t624 * 18446744073708553811#64)
    (ht709 : t709 = t692 + t590) (ht710 : t710 = t709 + t676) (ht711 : t711 = t710 + t669)
    (ht712 : t712 = t711 + t659) (ht713 : t713 = t712 + t708) (ht751 : t751 = t713 + 1048576#64)
    (ht752 : t752 = t751.sshiftRight 21) (et624 : t624 = s18) (et590 : t590 = s9)
    (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21) (et708 : t708 = carry8)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hcarry9 : carry9 = (s9_5 + 1048576#64).sshiftRight 21) :
    t752 = carry9 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11` as the C computes it is the compiled `%755`. -/
theorem x25519_sc_reduce.bridge_carry11
    (t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724 t754 t755 t624 t598 t628 t632
      t636 t643 t640 t717 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 carry11 s11 s18 s19 s20 s21 s22
      s23 carry10 : BitVec 64)
    (ht644 : t644 = t643 * 666643#64) (ht653 : t653 = t640 * 470296#64)
    (ht661 : t661 = t636 * 654183#64) (ht671 : t671 = t632 * 18446744073708553811#64)
    (ht678 : t678 = t628 * 136657#64) (ht699 : t699 = t624 * 18446744073708867715#64)
    (ht718 : t718 = t699 + t598) (ht719 : t719 = t718 + t678) (ht720 : t720 = t719 + t671)
    (ht721 : t721 = t720 + t661) (ht722 : t722 = t721 + t644) (ht723 : t723 = t722 + t653)
    (ht724 : t724 = t723 + t717) (ht754 : t754 = t724 + 1048576#64)
    (ht755 : t755 = t754.sshiftRight 21) (et624 : t624 = s18) (et598 : t598 = s11)
    (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21) (et643 : t643 = s23)
    (et640 : t640 = s22) (et717 : t717 = carry10) (hs11_1 : s11_1 = s11 + s23 * 666643#64)
    (hs11_2 : s11_2 = s11_1 + s22 * 470296#64) (hs11_3 : s11_3 = s11_2 + s21 * 654183#64)
    (hs11_4 : s11_4 = s11_3 - s20 * 997805#64) (hs11_5 : s11_5 = s11_4 + s19 * 136657#64)
    (hs11_6 : s11_6 = s11_5 - s18 * 683901#64) (hs11_7 : s11_7 = s11_6 + carry10)
    (hcarry11 : carry11 = (s11_7 + 1048576#64).sshiftRight 21) : t755 = carry11 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry13` as the C computes it is the compiled `%760`. -/
theorem x25519_sc_reduce.bridge_carry13
    (t646 t655 t663 t673 t729 t730 t731 t732 t733 t759 t760 t632 t606 t636 t643 t640 t728 s13_1
      s13_2 s13_3 s13_4 s13_5 carry13 s13 s20 s21 s22 s23 carry12 : BitVec 64)
    (ht646 : t646 = t643 * 654183#64) (ht655 : t655 = t640 * 18446744073708553811#64)
    (ht663 : t663 = t636 * 136657#64) (ht673 : t673 = t632 * 18446744073708867715#64)
    (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646)
    (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728) (ht759 : t759 = t733 + 1048576#64)
    (ht760 : t760 = t759.sshiftRight 21) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hcarry13 : carry13 = (s13_5 + 1048576#64).sshiftRight 21) :
    t760 = carry13 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry15` as the C computes it is the compiled `%765`. -/
theorem x25519_sc_reduce.bridge_carry15
    (t648 t649 t657 t658 t738 t764 t765 t643 t613 t640 t737 s15_1 s15_2 s15_3 carry15 s15 s22 s23
      carry14 : BitVec 64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht738 : t738 = t658 + t737) (ht764 : t764 = t738 + 1048576#64)
    (ht765 : t765 = t764.sshiftRight 21) (et643 : t643 = s23) (et613 : t613 = s15)
    (et640 : t640 = s22) (et737 : t737 = carry14) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs15_3 : s15_3 = s15_2 + carry14)
    (hcarry15 : carry15 = (s15_3 + 1048576#64).sshiftRight 21) : t765 = carry15 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry0` as the C computes it is the compiled `%833`. -/
theorem x25519_sc_reduce.bridge_carry0
    (t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756 t817 t818 t832 t833 t755 t628
      t602 t632 t636 t643 t640 t728 t556 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 carry0 s0
      s12 s19 s20 s21 s22 s23 carry12 carry11 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht654 : t654 = t640 * 654183#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht672 : t672 = t632 * 136657#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht756 : t756 = t755 + t735) (ht817 : t817 = t756 * 666643#64) (ht818 : t818 = t817 + t556)
    (ht832 : t832 = t818 + 1048576#64) (ht833 : t833 = t832.sshiftRight 21) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et632 : t632 = s20) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et556 : t556 = s0)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hcarry0 : carry0 = (s0_1 + 1048576#64).sshiftRight 21) : t833 = carry0 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry2` as the C computes it is the compiled `%838`. -/
theorem x25519_sc_reduce.bridge_carry2
    (t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762 t763 t800 t809 t821 t822 t823
      t824 t837 t838 t632 t606 t636 t643 t640 t728 t760 t564 t610 t737 t755 t628 t602 s12_1 s13_1
      s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5
      s13_6 s2_1 s2_2 s2_3 carry2 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11
      carry13 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht800 : t800 = t761 * 666643#64) (ht809 : t809 = t763 * 470296#64)
    (ht821 : t821 = t756 * 654183#64) (ht822 : t822 = t809 + t564) (ht823 : t823 = t822 + t800)
    (ht824 : t824 = t823 + t821) (ht837 : t837 = t824 + 1048576#64)
    (ht838 : t838 = t837.sshiftRight 21) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et564 : t564 = s2) (et610 : t610 = s14) (et737 : t737 = carry14)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64)
    (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hcarry2 : carry2 = (s2_3 + 1048576#64).sshiftRight 21) : t838 = carry2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry4` as the C computes it is the compiled `%846`. -/
theorem x25519_sc_reduce.bridge_carry4
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t744 t745
      t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826 t827 t828 t829 t830 t845 t846
      t765 t643 t616 t742 t572 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 s12_1
      s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 carry4 s4 s12
      s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 :
      BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht781 : t781 = t766 * 666643#64) (ht782 : t782 = t781 + t572) (ht793 : t793 = t768 * 470296#64)
    (ht802 : t802 = t761 * 654183#64) (ht811 : t811 = t763 * 18446744073708553811#64)
    (ht826 : t826 = t756 * 136657#64) (ht827 : t827 = t782 + t811) (ht828 : t828 = t827 + t793)
    (ht829 : t829 = t828 + t802) (ht830 : t830 = t829 + t826) (ht845 : t845 = t830 + 1048576#64)
    (ht846 : t846 = t845.sshiftRight 21) (et765 : t765 = carry15) (et643 : t643 = s23)
    (et616 : t616 = s16) (et742 : t742 = carry16) (et572 : t572 = s4) (et632 : t632 = s20)
    (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs4_1 : s4_1 = s4 + s16_3 * 666643#64)
    (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64)
    (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64)
    (hcarry4 : carry4 = (s4_5 + 1048576#64).sshiftRight 21) : t846 = carry4 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry6_1` as the C computes it is the compiled `%854`. -/
theorem x25519_sc_reduce.bridge_carry6_1
    (t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664 t665 t666 t667 t673 t685 t686 t705
      t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745 t761 t762 t763 t766 t767 t768 t771
      t772 t785 t786 t795 t804 t813 t814 t815 t816 t853 t854 t624 t580 t701 t742 t620 t765 t643 t616
      t632 t606 t636 t640 t728 t760 t613 t737 t610 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3
      s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5
      s6_6 s6_7 carry6_1 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16
      carry13 carry15 : BitVec 64)
    (ht646 : t646 = t643 * 654183#64) (ht647 : t647 = t643 * 18446744073708553811#64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht663 : t663 = t636 * 136657#64) (ht664 : t664 = t636 * 18446744073708867715#64)
    (ht665 : t665 = t664 + t610) (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht685 : t685 = t624 * 666643#64)
    (ht686 : t686 = t685 + t580) (ht705 : t705 = t701 <<< 21) (ht706 : t706 = t686 - t705)
    (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646)
    (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728) (ht738 : t738 = t658 + t737)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht761 : t761 = t760 + t740)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767) (ht771 : t771 = t743 * 470296#64)
    (ht772 : t772 = t706 + t771) (ht785 : t785 = t766 * 654183#64) (ht786 : t786 = t772 + t785)
    (ht795 : t795 = t768 * 18446744073708553811#64) (ht804 : t804 = t761 * 136657#64)
    (ht813 : t813 = t763 * 18446744073708867715#64) (ht814 : t814 = t786 + t813)
    (ht815 : t815 = t814 + t795) (ht816 : t816 = t815 + t804) (ht853 : t853 = t816 + 1048576#64)
    (ht854 : t854 = t853.sshiftRight 21) (et624 : t624 = s18) (et580 : t580 = s6)
    (et701 : t701 = carry6) (et742 : t742 = carry16) (et620 : t620 = s17) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs6_1 : s6_1 = s6 + s18 * 666643#64) (hs6_2 : s6_2 = s6_1 - carry6 <<< 21)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64)
    (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64) (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64)
    (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64) (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64)
    (hcarry6_1 : carry6_1 = (s6_7 + 1048576#64).sshiftRight 21) : t854 = carry6_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry8_1` as the C computes it is the compiled `%859`. -/
theorem x25519_sc_reduce.bridge_carry8_1
    (t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691 t714 t715 t738 t743 t744 t745 t748
      t766 t767 t768 t775 t776 t789 t790 t798 t799 t858 t859 t624 t586 t628 t632 t708 t747 t742 t620
      t765 t643 t616 t613 t640 t737 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5
      s16_3 s15_4 s8_6 s8_7 s8_8 carry8_1 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16
      carry7 carry15 : BitVec 64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht668 : t668 = t632 * 666643#64) (ht675 : t675 = t628 * 470296#64)
    (ht688 : t688 = t624 * 654183#64) (ht689 : t689 = t688 + t586) (ht690 : t690 = t689 + t675)
    (ht691 : t691 = t690 + t668) (ht714 : t714 = t708 <<< 21) (ht715 : t715 = t691 - t714)
    (ht738 : t738 = t658 + t737) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht748 : t748 = t715 + t747) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht775 : t775 = t743 * 18446744073708553811#64) (ht776 : t776 = t748 + t775)
    (ht789 : t789 = t766 * 136657#64) (ht790 : t790 = t776 + t789)
    (ht798 : t798 = t768 * 18446744073708867715#64) (ht799 : t799 = t790 + t798)
    (ht858 : t858 = t799 + 1048576#64) (ht859 : t859 = t858.sshiftRight 21) (et624 : t624 = s18)
    (et586 : t586 = s8) (et628 : t628 = s19) (et632 : t632 = s20) (et708 : t708 = carry8)
    (et747 : t747 = carry7) (et742 : t742 = carry16) (et620 : t620 = s17) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et613 : t613 = s15) (et640 : t640 = s22)
    (et737 : t737 = carry14) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) (hs8_4 : s8_4 = s8_3 - carry8 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs8_5 : s8_5 = s8_4 + carry7)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64) (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64)
    (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64)
    (hcarry8_1 : carry8_1 = (s8_8 + 1048576#64).sshiftRight 21) : t859 = carry8_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry10_1` as the C computes it is the compiled `%867`. -/
theorem x25519_sc_reduce.bridge_carry10_1
    (t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726 t743 t778 t779 t780 t866 t867 t624
      t594 t628 t632 t636 t640 t717 t742 t620 t752 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7
      s10_8 carry10_1 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 : BitVec 64)
    (ht652 : t652 = t640 * 666643#64) (ht660 : t660 = t636 * 470296#64)
    (ht670 : t670 = t632 * 654183#64) (ht677 : t677 = t628 * 18446744073708553811#64)
    (ht693 : t693 = t624 * 136657#64) (ht694 : t694 = t693 + t594) (ht695 : t695 = t694 + t677)
    (ht696 : t696 = t695 + t670) (ht697 : t697 = t696 + t660) (ht698 : t698 = t697 + t652)
    (ht725 : t725 = t717 <<< 21) (ht726 : t726 = t698 - t725) (ht743 : t743 = t742 + t620)
    (ht778 : t778 = t743 * 18446744073708867715#64) (ht779 : t779 = t726 + t778)
    (ht780 : t780 = t779 + t752) (ht866 : t866 = t780 + 1048576#64)
    (ht867 : t867 = t866.sshiftRight 21) (et624 : t624 = s18) (et594 : t594 = s10)
    (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21) (et640 : t640 = s22)
    (et717 : t717 = carry10) (et742 : t742 = carry16) (et620 : t620 = s17) (et752 : t752 = carry9)
    (hs10_1 : s10_1 = s10 + s22 * 666643#64) (hs10_2 : s10_2 = s10_1 + s21 * 470296#64)
    (hs10_3 : s10_3 = s10_2 + s20 * 654183#64) (hs10_4 : s10_4 = s10_3 - s19 * 997805#64)
    (hs10_5 : s10_5 = s10_4 + s18 * 136657#64) (hs10_6 : s10_6 = s10_5 - carry10 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs10_7 : s10_7 = s10_6 + carry9)
    (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64)
    (hcarry10_1 : carry10_1 = (s10_8 + 1048576#64).sshiftRight 21) : t867 = carry10_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry1` as the C computes it is the compiled `%872`. -/
theorem x25519_sc_reduce.bridge_carry1
    (t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t871 t872 t632 t606 t636 t643 t640 t728 t760
      t560 t755 t628 t602 t833 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s12_7 s13_6 s1_1 s1_2 s1_3 carry1 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13
      carry0 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht654 : t654 = t640 * 654183#64) (ht655 : t655 = t640 * 18446744073708553811#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht672 : t672 = t632 * 136657#64) (ht673 : t673 = t632 * 18446744073708867715#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663)
    (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728)
    (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734) (ht756 : t756 = t755 + t735)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht807 : t807 = t763 * 666643#64)
    (ht808 : t808 = t807 + t560) (ht819 : t819 = t756 * 470296#64) (ht820 : t820 = t808 + t819)
    (ht834 : t834 = t820 + t833) (ht871 : t871 = t834 + 1048576#64)
    (ht872 : t872 = t871.sshiftRight 21) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et560 : t560 = s1) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et833 : t833 = carry0) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs1_3 : s1_3 = s1_2 + carry0) (hcarry1 : carry1 = (s1_3 + 1048576#64).sshiftRight 21) :
    t872 = carry1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry3` as the C computes it is the compiled `%875`. -/
theorem x25519_sc_reduce.bridge_carry3
    (t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672 t673 t679
      t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t756 t761 t762 t763
      t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t874 t875 t632 t606 t636 t643 t640 t728
      t760 t568 t613 t737 t765 t610 t755 t628 t602 t838 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2
      s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1
      s3_2 s3_3 s3_4 s3_5 carry3 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11
      carry13 carry15 carry2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht792 : t792 = t768 * 666643#64) (ht801 : t801 = t761 * 470296#64)
    (ht810 : t810 = t763 * 654183#64) (ht825 : t825 = t756 * 18446744073708553811#64)
    (ht839 : t839 = t810 + t568) (ht840 : t840 = t839 + t792) (ht841 : t841 = t840 + t801)
    (ht842 : t842 = t841 + t825) (ht843 : t843 = t842 + t838) (ht874 : t874 = t843 + 1048576#64)
    (ht875 : t875 = t874.sshiftRight 21) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et568 : t568 = s3) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et765 : t765 = carry15) (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et838 : t838 = carry2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hcarry3 : carry3 = (s3_5 + 1048576#64).sshiftRight 21) : t875 = carry3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry5` as the C computes it is the compiled `%878`. -/
theorem x25519_sc_reduce.bridge_carry5
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t743 t744
      t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794 t803 t812 t831 t847 t848 t849
      t850 t851 t877 t878 t742 t620 t576 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610
      t755 t628 t602 t846 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2
      s5_3 s5_4 s5_5 s5_6 s5_7 carry5 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14
      carry16 carry11 carry13 carry15 carry4 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht769 : t769 = t743 * 666643#64) (ht770 : t770 = t769 + t576)
    (ht783 : t783 = t766 * 470296#64) (ht784 : t784 = t770 + t783) (ht794 : t794 = t768 * 654183#64)
    (ht803 : t803 = t761 * 18446744073708553811#64) (ht812 : t812 = t763 * 136657#64)
    (ht831 : t831 = t756 * 18446744073708867715#64) (ht847 : t847 = t784 + t812)
    (ht848 : t848 = t847 + t794) (ht849 : t849 = t848 + t803) (ht850 : t850 = t849 + t831)
    (ht851 : t851 = t850 + t846) (ht877 : t877 = t851 + 1048576#64)
    (ht878 : t878 = t877.sshiftRight 21) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et576 : t576 = s5) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22)
    (et728 : t728 = carry12) (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12)
    (et846 : t846 = carry4) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hcarry5 : carry5 = (s5_7 + 1048576#64).sshiftRight 21) : t878 = carry5 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry7_1` as the C computes it is the compiled `%882`. -/
theorem x25519_sc_reduce.bridge_carry7_1
    (t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667 t674 t687 t702 t703 t704 t738 t739
      t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774 t787 t788 t796 t797 t805 t806 t855
      t881 t882 t624 t583 t628 t701 t747 t742 t620 t765 t643 t616 t613 t640 t737 t760 t636 t610 t854
      s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3
      s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 carry7_1 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14
      carry16 carry7 carry13 carry15 carry6_1 : BitVec 64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht674 : t674 = t628 * 666643#64)
    (ht687 : t687 = t624 * 470296#64) (ht702 : t702 = t687 + t583) (ht703 : t703 = t702 + t674)
    (ht704 : t704 = t703 + t701) (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21)
    (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht749 : t749 = t747 <<< 21) (ht750 : t750 = t704 - t749)
    (ht761 : t761 = t760 + t740) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht773 : t773 = t743 * 654183#64) (ht774 : t774 = t750 + t773)
    (ht787 : t787 = t766 * 18446744073708553811#64) (ht788 : t788 = t774 + t787)
    (ht796 : t796 = t768 * 136657#64) (ht797 : t797 = t788 + t796)
    (ht805 : t805 = t761 * 18446744073708867715#64) (ht806 : t806 = t797 + t805)
    (ht855 : t855 = t806 + t854) (ht881 : t881 = t855 + 1048576#64)
    (ht882 : t882 = t881.sshiftRight 21) (et624 : t624 = s18) (et583 : t583 = s7)
    (et628 : t628 = s19) (et701 : t701 = carry6) (et747 : t747 = carry7) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et613 : t613 = s15) (et640 : t640 = s22) (et737 : t737 = carry14) (et760 : t760 = carry13)
    (et636 : t636 = s21) (et610 : t610 = s14) (et854 : t854 = carry6_1)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs7_1 : s7_1 = s7 + s19 * 666643#64) (hs7_2 : s7_2 = s7_1 + s18 * 470296#64)
    (hs7_3 : s7_3 = s7_2 + carry6) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs7_4 : s7_4 = s7_3 - carry7 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64)
    (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64) (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64)
    (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64) (hs7_9 : s7_9 = s7_8 + carry6_1)
    (hcarry7_1 : carry7_1 = (s7_9 + 1048576#64).sshiftRight 21) : t882 = carry7_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry9_1` as the C computes it is the compiled `%887`. -/
theorem x25519_sc_reduce.bridge_carry9_1
    (t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743 t744 t745 t753 t766 t777 t791 t860
      t861 t862 t863 t886 t887 t742 t620 t624 t590 t628 t632 t636 t708 t752 t765 t643 t616 t859
      s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 carry9_1 s9 s16 s17 s18
      s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 : BitVec 64)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht659 : t659 = t636 * 666643#64) (ht669 : t669 = t632 * 470296#64)
    (ht676 : t676 = t628 * 654183#64) (ht692 : t692 = t624 * 18446744073708553811#64)
    (ht709 : t709 = t692 + t590) (ht710 : t710 = t709 + t676) (ht711 : t711 = t710 + t669)
    (ht712 : t712 = t711 + t659) (ht713 : t713 = t712 + t708) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht753 : t753 = t752 <<< 21)
    (ht766 : t766 = t765 + t745) (ht777 : t777 = t743 * 136657#64)
    (ht791 : t791 = t766 * 18446744073708867715#64) (ht860 : t860 = t777 + t713)
    (ht861 : t861 = t860 - t753) (ht862 : t862 = t861 + t791) (ht863 : t863 = t862 + t859)
    (ht886 : t886 = t863 + 1048576#64) (ht887 : t887 = t886.sshiftRight 21) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et624 : t624 = s18) (et590 : t590 = s9) (et628 : t628 = s19)
    (et632 : t632 = s20) (et636 : t636 = s21) (et708 : t708 = carry8) (et752 : t752 = carry9)
    (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16) (et859 : t859 = carry8_1)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs9_1 : s9_1 = s9 + s21 * 666643#64)
    (hs9_2 : s9_2 = s9_1 + s20 * 470296#64) (hs9_3 : s9_3 = s9_2 + s19 * 654183#64)
    (hs9_4 : s9_4 = s9_3 - s18 * 997805#64) (hs9_5 : s9_5 = s9_4 + carry8)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs9_6 : s9_6 = s9_5 - carry9 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64) (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64)
    (hs9_9 : s9_9 = s9_8 + carry8_1) (hcarry9_1 : carry9_1 = (s9_9 + 1048576#64).sshiftRight 21) :
    t887 = carry9_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11_1` as the C computes it is the compiled `%892`. -/
theorem x25519_sc_reduce.bridge_carry11_1
    (t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724 t757 t758 t868 t891 t892 t867
      t624 t598 t628 t632 t636 t643 t640 t717 t755 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8
      s11_9 carry11_1 s11 s18 s19 s20 s21 s22 s23 carry10 carry11 carry10_1 : BitVec 64)
    (ht644 : t644 = t643 * 666643#64) (ht653 : t653 = t640 * 470296#64)
    (ht661 : t661 = t636 * 654183#64) (ht671 : t671 = t632 * 18446744073708553811#64)
    (ht678 : t678 = t628 * 136657#64) (ht699 : t699 = t624 * 18446744073708867715#64)
    (ht718 : t718 = t699 + t598) (ht719 : t719 = t718 + t678) (ht720 : t720 = t719 + t671)
    (ht721 : t721 = t720 + t661) (ht722 : t722 = t721 + t644) (ht723 : t723 = t722 + t653)
    (ht724 : t724 = t723 + t717) (ht757 : t757 = t755 <<< 21) (ht758 : t758 = t724 - t757)
    (ht868 : t868 = t867 + t758) (ht891 : t891 = t868 + 1048576#64)
    (ht892 : t892 = t891.sshiftRight 21) (et867 : t867 = carry10_1) (et624 : t624 = s18)
    (et598 : t598 = s11) (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et717 : t717 = carry10) (et755 : t755 = carry11)
    (hs11_1 : s11_1 = s11 + s23 * 666643#64) (hs11_2 : s11_2 = s11_1 + s22 * 470296#64)
    (hs11_3 : s11_3 = s11_2 + s21 * 654183#64) (hs11_4 : s11_4 = s11_3 - s20 * 997805#64)
    (hs11_5 : s11_5 = s11_4 + s19 * 136657#64) (hs11_6 : s11_6 = s11_5 - s18 * 683901#64)
    (hs11_7 : s11_7 = s11_6 + carry10) (hs11_8 : s11_8 = s11_7 - carry11 <<< 21)
    (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hcarry11_1 : carry11_1 = (s11_9 + 1048576#64).sshiftRight 21) : t892 = carry11_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry0_1` as the C computes it is the compiled `%902`. -/
theorem x25519_sc_reduce.bridge_carry0_1
    (t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756 t817 t818 t835 t836 t895 t896
      t902 t755 t628 t602 t632 t636 t643 t640 t728 t556 t833 t892 s12_1 s12_2 s12_3 s12_4 s12_5
      s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 carry0_1 s0 s12 s19 s20 s21 s22 s23 carry12 carry11
      carry0 carry11_1 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht654 : t654 = t640 * 654183#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht672 : t672 = t632 * 136657#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht756 : t756 = t755 + t735) (ht817 : t817 = t756 * 666643#64) (ht818 : t818 = t817 + t556)
    (ht835 : t835 = t833 <<< 21) (ht836 : t836 = t818 - t835) (ht895 : t895 = t892 * 666643#64)
    (ht896 : t896 = t836 + t895) (ht902 : t902 = t896.sshiftRight 21) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et632 : t632 = s20) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et556 : t556 = s0)
    (et833 : t833 = carry0) (et892 : t892 = carry11_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs0_1 : s0_1 = s0 + s12_7 * 666643#64) (hs12_8 : s12_8 = 0#64)
    (hs0_2 : s0_2 = s0_1 - carry0 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64) (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) :
    t902 = carry0_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry1_1` as the C computes it is the compiled `%908`. -/
theorem x25519_sc_reduce.bridge_carry1_1
    (t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897 t903 t904 t905 t908 t892 t872 t632
      t606 t636 t643 t640 t728 t760 t560 t755 t628 t602 t833 t902 s12_1 s13_1 s12_2 s13_2 s12_3
      s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s1_6
      carry1_1 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1
      carry0_1 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht654 : t654 = t640 * 654183#64) (ht655 : t655 = t640 * 18446744073708553811#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht672 : t672 = t632 * 136657#64) (ht673 : t673 = t632 * 18446744073708867715#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663)
    (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728)
    (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734) (ht756 : t756 = t755 + t735)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht807 : t807 = t763 * 666643#64)
    (ht808 : t808 = t807 + t560) (ht819 : t819 = t756 * 470296#64) (ht820 : t820 = t808 + t819)
    (ht834 : t834 = t820 + t833) (ht873 : t873 = t872 <<< 21) (ht897 : t897 = t892 * 470296#64)
    (ht903 : t903 = t897 - t873) (ht904 : t904 = t903 + t834) (ht905 : t905 = t904 + t902)
    (ht908 : t908 = t905.sshiftRight 21) (et892 : t892 = carry11_1) (et872 : t872 = carry1)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et643 : t643 = s23)
    (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13) (et560 : t560 = s1)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12) (et833 : t833 = carry0)
    (et902 : t902 = carry0_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs1_6 : s1_6 = s1_5 + carry0_1) (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) :
    t908 = carry1_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry2_1` as the C computes it is the compiled `%915`. -/
theorem x25519_sc_reduce.bridge_carry2_1
    (t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762 t763 t800 t809 t821 t822 t823
      t824 t844 t898 t909 t910 t911 t912 t915 t892 t838 t632 t606 t636 t643 t640 t728 t760 t564 t610
      t737 t755 t628 t602 t872 t908 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4
      s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s2_7
      carry2_1 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1
      carry11_1 carry1_1 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht800 : t800 = t761 * 666643#64) (ht809 : t809 = t763 * 470296#64)
    (ht821 : t821 = t756 * 654183#64) (ht822 : t822 = t809 + t564) (ht823 : t823 = t822 + t800)
    (ht824 : t824 = t823 + t821) (ht844 : t844 = t838 <<< 21) (ht898 : t898 = t892 * 654183#64)
    (ht909 : t909 = t898 - t844) (ht910 : t910 = t909 + t824) (ht911 : t911 = t910 + t872)
    (ht912 : t912 = t911 + t908) (ht915 : t915 = t912.sshiftRight 21) (et892 : t892 = carry11_1)
    (et838 : t838 = carry2) (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et564 : t564 = s2) (et610 : t610 = s14) (et737 : t737 = carry14) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et872 : t872 = carry1) (et908 : t908 = carry1_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64)
    (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64) (hs12_8 : s12_8 = 0#64)
    (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs2_7 : s2_7 = s2_6 + carry1_1) (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) :
    t915 = carry2_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry3_1` as the C computes it is the compiled `%921`. -/
theorem x25519_sc_reduce.bridge_carry3_1
    (t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672 t673 t679
      t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t756 t761 t762 t763
      t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876 t899 t916 t917 t918 t921 t892 t875
      t632 t606 t636 t643 t640 t728 t760 t568 t613 t737 t765 t610 t755 t628 t602 t838 t915 s12_1
      s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s3_8
      carry3_1 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2
      carry3 carry11_1 carry2_1 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht792 : t792 = t768 * 666643#64) (ht801 : t801 = t761 * 470296#64)
    (ht810 : t810 = t763 * 654183#64) (ht825 : t825 = t756 * 18446744073708553811#64)
    (ht839 : t839 = t810 + t568) (ht840 : t840 = t839 + t792) (ht841 : t841 = t840 + t801)
    (ht842 : t842 = t841 + t825) (ht843 : t843 = t842 + t838) (ht876 : t876 = t875 <<< 21)
    (ht899 : t899 = t892 * 18446744073708553811#64) (ht916 : t916 = t899 - t876)
    (ht917 : t917 = t916 + t843) (ht918 : t918 = t917 + t915) (ht921 : t921 = t918.sshiftRight 21)
    (et892 : t892 = carry11_1) (et875 : t875 = carry3) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et568 : t568 = s3) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et765 : t765 = carry15) (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et838 : t838 = carry2) (et915 : t915 = carry2_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs3_1 : s3_1 = s3 + s15_4 * 666643#64) (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64)
    (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64) (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64)
    (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2) (hs3_6 : s3_6 = s3_5 - carry3 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) :
    t921 = carry3_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry4_1` as the C computes it is the compiled `%928`. -/
theorem x25519_sc_reduce.bridge_carry4_1
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t744 t745
      t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826 t827 t828 t829 t830 t852 t900
      t922 t923 t924 t925 t928 t892 t846 t765 t643 t616 t742 t572 t632 t606 t636 t640 t728 t760 t613
      t737 t610 t755 t628 t602 t875 t921 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1
      s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s4_9 carry4_1 s4 s12 s13 s14 s15 s16 s19 s20
      s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1 :
      BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht781 : t781 = t766 * 666643#64) (ht782 : t782 = t781 + t572) (ht793 : t793 = t768 * 470296#64)
    (ht802 : t802 = t761 * 654183#64) (ht811 : t811 = t763 * 18446744073708553811#64)
    (ht826 : t826 = t756 * 136657#64) (ht827 : t827 = t782 + t811) (ht828 : t828 = t827 + t793)
    (ht829 : t829 = t828 + t802) (ht830 : t830 = t829 + t826) (ht852 : t852 = t846 <<< 21)
    (ht900 : t900 = t892 * 136657#64) (ht922 : t922 = t900 - t852) (ht923 : t923 = t922 + t830)
    (ht924 : t924 = t923 + t875) (ht925 : t925 = t924 + t921) (ht928 : t928 = t925.sshiftRight 21)
    (et892 : t892 = carry11_1) (et846 : t846 = carry4) (et765 : t765 = carry15) (et643 : t643 = s23)
    (et616 : t616 = s16) (et742 : t742 = carry16) (et572 : t572 = s4) (et632 : t632 = s20)
    (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12) (et875 : t875 = carry3)
    (et921 : t921 = carry3_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64)
    (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64)
    (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) (hs12_8 : s12_8 = 0#64)
    (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs4_9 : s4_9 = s4_8 + carry3_1) (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) :
    t928 = carry4_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry5_1` as the C computes it is the compiled `%934`. -/
theorem x25519_sc_reduce.bridge_carry5_1
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t743 t744
      t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794 t803 t812 t831 t847 t848 t849
      t850 t851 t880 t901 t929 t930 t931 t934 t892 t878 t742 t620 t576 t765 t643 t616 t632 t606 t636
      t640 t728 t760 t613 t737 t610 t755 t628 t602 t846 t928 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2
      s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2
      s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s5_10
      carry5_1 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11
      carry13 carry15 carry4 carry5 carry11_1 carry4_1 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht769 : t769 = t743 * 666643#64) (ht770 : t770 = t769 + t576)
    (ht783 : t783 = t766 * 470296#64) (ht784 : t784 = t770 + t783) (ht794 : t794 = t768 * 654183#64)
    (ht803 : t803 = t761 * 18446744073708553811#64) (ht812 : t812 = t763 * 136657#64)
    (ht831 : t831 = t756 * 18446744073708867715#64) (ht847 : t847 = t784 + t812)
    (ht848 : t848 = t847 + t794) (ht849 : t849 = t848 + t803) (ht850 : t850 = t849 + t831)
    (ht851 : t851 = t850 + t846) (ht880 : t880 = t878 <<< 21)
    (ht901 : t901 = t892 * 18446744073708867715#64) (ht929 : t929 = t901 - t880)
    (ht930 : t930 = t929 + t851) (ht931 : t931 = t930 + t928) (ht934 : t934 = t931.sshiftRight 21)
    (et892 : t892 = carry11_1) (et878 : t878 = carry5) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et576 : t576 = s5) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22)
    (et728 : t728 = carry12) (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12)
    (et846 : t846 = carry4) (et928 : t928 = carry4_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hs5_8 : s5_8 = s5_7 - carry5 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64) (hs5_10 : s5_10 = s5_9 + carry4_1)
    (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) : t934 = carry5_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry6_2` as the C computes it is the compiled `%938`. -/
theorem x25519_sc_reduce.bridge_carry6_2
    (t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664 t665 t666 t667 t673 t685 t686 t705
      t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745 t761 t762 t763 t766 t767 t768 t771
      t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879 t935 t938 t624 t580 t701 t742 t620
      t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t854 t878 t934 s13_1 s14_1 s15_1
      s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6
      s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 carry6_2 s6 s13 s14 s15 s16 s17 s18 s20
      s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15 carry6_1 carry5 carry5_1 :
      BitVec 64)
    (ht646 : t646 = t643 * 654183#64) (ht647 : t647 = t643 * 18446744073708553811#64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht663 : t663 = t636 * 136657#64) (ht664 : t664 = t636 * 18446744073708867715#64)
    (ht665 : t665 = t664 + t610) (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht685 : t685 = t624 * 666643#64)
    (ht686 : t686 = t685 + t580) (ht705 : t705 = t701 <<< 21) (ht706 : t706 = t686 - t705)
    (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646)
    (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728) (ht738 : t738 = t658 + t737)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht761 : t761 = t760 + t740)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767) (ht771 : t771 = t743 * 470296#64)
    (ht772 : t772 = t706 + t771) (ht785 : t785 = t766 * 654183#64) (ht786 : t786 = t772 + t785)
    (ht795 : t795 = t768 * 18446744073708553811#64) (ht804 : t804 = t761 * 136657#64)
    (ht813 : t813 = t763 * 18446744073708867715#64) (ht814 : t814 = t786 + t813)
    (ht815 : t815 = t814 + t795) (ht816 : t816 = t815 + t804) (ht856 : t856 = t854 <<< 21)
    (ht857 : t857 = t816 - t856) (ht879 : t879 = t857 + t878) (ht935 : t935 = t879 + t934)
    (ht938 : t938 = t935.sshiftRight 21) (et624 : t624 = s18) (et580 : t580 = s6)
    (et701 : t701 = carry6) (et742 : t742 = carry16) (et620 : t620 = s17) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14) (et854 : t854 = carry6_1)
    (et878 : t878 = carry5) (et934 : t934 = carry5_1) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) : t938 = carry6_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry7_2` as the C computes it is the compiled `%942`. -/
theorem x25519_sc_reduce.bridge_carry7_2
    (t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667 t674 t687 t702 t703 t704 t738 t739
      t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774 t787 t788 t796 t797 t805 t806 t855
      t884 t885 t939 t942 t938 t624 t583 t628 t701 t747 t742 t620 t765 t643 t616 t613 t640 t737 t760
      t636 t610 t854 t882 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2
      s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 carry7_2 s7 s14 s15 s16 s17 s18
      s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1 carry6_2 :
      BitVec 64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht674 : t674 = t628 * 666643#64)
    (ht687 : t687 = t624 * 470296#64) (ht702 : t702 = t687 + t583) (ht703 : t703 = t702 + t674)
    (ht704 : t704 = t703 + t701) (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21)
    (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht749 : t749 = t747 <<< 21) (ht750 : t750 = t704 - t749)
    (ht761 : t761 = t760 + t740) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht773 : t773 = t743 * 654183#64) (ht774 : t774 = t750 + t773)
    (ht787 : t787 = t766 * 18446744073708553811#64) (ht788 : t788 = t774 + t787)
    (ht796 : t796 = t768 * 136657#64) (ht797 : t797 = t788 + t796)
    (ht805 : t805 = t761 * 18446744073708867715#64) (ht806 : t806 = t797 + t805)
    (ht855 : t855 = t806 + t854) (ht884 : t884 = t882 <<< 21) (ht885 : t885 = t855 - t884)
    (ht939 : t939 = t938 + t885) (ht942 : t942 = t939.sshiftRight 21) (et938 : t938 = carry6_2)
    (et624 : t624 = s18) (et583 : t583 = s7) (et628 : t628 = s19) (et701 : t701 = carry6)
    (et747 : t747 = carry7) (et742 : t742 = carry16) (et620 : t620 = s17) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et613 : t613 = s15) (et640 : t640 = s22)
    (et737 : t737 = carry14) (et760 : t760 = carry13) (et636 : t636 = s21) (et610 : t610 = s14)
    (et854 : t854 = carry6_1) (et882 : t882 = carry7_1) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) :
    t942 = carry7_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry8_2` as the C computes it is the compiled `%946`. -/
theorem x25519_sc_reduce.bridge_carry8_2
    (t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691 t714 t715 t738 t743 t744 t745 t748
      t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883 t943 t946 t624 t586 t628 t632 t708
      t747 t742 t620 t765 t643 t616 t613 t640 t737 t859 t882 t942 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3
      s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 carry8_2 s8 s15 s16
      s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 :
      BitVec 64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht668 : t668 = t632 * 666643#64) (ht675 : t675 = t628 * 470296#64)
    (ht688 : t688 = t624 * 654183#64) (ht689 : t689 = t688 + t586) (ht690 : t690 = t689 + t675)
    (ht691 : t691 = t690 + t668) (ht714 : t714 = t708 <<< 21) (ht715 : t715 = t691 - t714)
    (ht738 : t738 = t658 + t737) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht748 : t748 = t715 + t747) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht775 : t775 = t743 * 18446744073708553811#64) (ht776 : t776 = t748 + t775)
    (ht789 : t789 = t766 * 136657#64) (ht790 : t790 = t776 + t789)
    (ht798 : t798 = t768 * 18446744073708867715#64) (ht799 : t799 = t790 + t798)
    (ht864 : t864 = t859 <<< 21) (ht865 : t865 = t799 - t864) (ht883 : t883 = t865 + t882)
    (ht943 : t943 = t883 + t942) (ht946 : t946 = t943.sshiftRight 21) (et624 : t624 = s18)
    (et586 : t586 = s8) (et628 : t628 = s19) (et632 : t632 = s20) (et708 : t708 = carry8)
    (et747 : t747 = carry7) (et742 : t742 = carry16) (et620 : t620 = s17) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et613 : t613 = s15) (et640 : t640 = s22)
    (et737 : t737 = carry14) (et859 : t859 = carry8_1) (et882 : t882 = carry7_1)
    (et942 : t942 = carry7_2) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) (hs8_4 : s8_4 = s8_3 - carry8 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs8_5 : s8_5 = s8_4 + carry7)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64) (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64)
    (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21)
    (hs8_10 : s8_10 = s8_9 + carry7_1) (hs8_11 : s8_11 = s8_10 + carry7_2)
    (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) : t946 = carry8_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry9_2` as the C computes it is the compiled `%950`. -/
theorem x25519_sc_reduce.bridge_carry9_2
    (t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743 t744 t745 t753 t766 t777 t791 t860
      t861 t862 t863 t889 t890 t947 t950 t946 t742 t620 t624 t590 t628 t632 t636 t708 t752 t765 t643
      t616 t859 t887 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10
      s9_11 carry9_2 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1
      carry8_2 : BitVec 64)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht659 : t659 = t636 * 666643#64) (ht669 : t669 = t632 * 470296#64)
    (ht676 : t676 = t628 * 654183#64) (ht692 : t692 = t624 * 18446744073708553811#64)
    (ht709 : t709 = t692 + t590) (ht710 : t710 = t709 + t676) (ht711 : t711 = t710 + t669)
    (ht712 : t712 = t711 + t659) (ht713 : t713 = t712 + t708) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht753 : t753 = t752 <<< 21)
    (ht766 : t766 = t765 + t745) (ht777 : t777 = t743 * 136657#64)
    (ht791 : t791 = t766 * 18446744073708867715#64) (ht860 : t860 = t777 + t713)
    (ht861 : t861 = t860 - t753) (ht862 : t862 = t861 + t791) (ht863 : t863 = t862 + t859)
    (ht889 : t889 = t887 <<< 21) (ht890 : t890 = t863 - t889) (ht947 : t947 = t946 + t890)
    (ht950 : t950 = t947.sshiftRight 21) (et946 : t946 = carry8_2) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et624 : t624 = s18) (et590 : t590 = s9) (et628 : t628 = s19)
    (et632 : t632 = s20) (et636 : t636 = s21) (et708 : t708 = carry8) (et752 : t752 = carry9)
    (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16) (et859 : t859 = carry8_1)
    (et887 : t887 = carry9_1) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) : t950 = carry9_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry10_2` as the C computes it is the compiled `%954`. -/
theorem x25519_sc_reduce.bridge_carry10_2
    (t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726 t743 t778 t779 t780 t869 t870 t888
      t951 t954 t624 t594 t628 t632 t636 t640 t717 t742 t620 t752 t867 t887 t950 s10_1 s10_2 s10_3
      s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 carry10_2 s10 s17 s18 s19 s20 s21 s22
      carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 : BitVec 64)
    (ht652 : t652 = t640 * 666643#64) (ht660 : t660 = t636 * 470296#64)
    (ht670 : t670 = t632 * 654183#64) (ht677 : t677 = t628 * 18446744073708553811#64)
    (ht693 : t693 = t624 * 136657#64) (ht694 : t694 = t693 + t594) (ht695 : t695 = t694 + t677)
    (ht696 : t696 = t695 + t670) (ht697 : t697 = t696 + t660) (ht698 : t698 = t697 + t652)
    (ht725 : t725 = t717 <<< 21) (ht726 : t726 = t698 - t725) (ht743 : t743 = t742 + t620)
    (ht778 : t778 = t743 * 18446744073708867715#64) (ht779 : t779 = t726 + t778)
    (ht780 : t780 = t779 + t752) (ht869 : t869 = t867 <<< 21) (ht870 : t870 = t780 - t869)
    (ht888 : t888 = t870 + t887) (ht951 : t951 = t888 + t950) (ht954 : t954 = t951.sshiftRight 21)
    (et624 : t624 = s18) (et594 : t594 = s10) (et628 : t628 = s19) (et632 : t632 = s20)
    (et636 : t636 = s21) (et640 : t640 = s22) (et717 : t717 = carry10) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et752 : t752 = carry9) (et867 : t867 = carry10_1)
    (et887 : t887 = carry9_1) (et950 : t950 = carry9_2) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hs10_6 : s10_6 = s10_5 - carry10 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs10_7 : s10_7 = s10_6 + carry9) (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64)
    (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21) (hs10_10 : s10_10 = s10_9 + carry9_1)
    (hs10_11 : s10_11 = s10_10 + carry9_2) (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) :
    t954 = carry10_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11_2` as the C computes it is the compiled `%958`. -/
theorem x25519_sc_reduce.bridge_carry11_2
    (t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724 t757 t758 t868 t893 t894 t955
      t958 t954 t867 t624 t598 t628 t632 t636 t643 t640 t717 t755 t892 s11_1 s11_2 s11_3 s11_4 s11_5
      s11_6 s11_7 s11_8 s11_9 s11_10 s11_11 carry11_2 s11 s18 s19 s20 s21 s22 s23 carry10 carry11
      carry10_1 carry11_1 carry10_2 : BitVec 64)
    (ht644 : t644 = t643 * 666643#64) (ht653 : t653 = t640 * 470296#64)
    (ht661 : t661 = t636 * 654183#64) (ht671 : t671 = t632 * 18446744073708553811#64)
    (ht678 : t678 = t628 * 136657#64) (ht699 : t699 = t624 * 18446744073708867715#64)
    (ht718 : t718 = t699 + t598) (ht719 : t719 = t718 + t678) (ht720 : t720 = t719 + t671)
    (ht721 : t721 = t720 + t661) (ht722 : t722 = t721 + t644) (ht723 : t723 = t722 + t653)
    (ht724 : t724 = t723 + t717) (ht757 : t757 = t755 <<< 21) (ht758 : t758 = t724 - t757)
    (ht868 : t868 = t867 + t758) (ht893 : t893 = t892 <<< 21) (ht894 : t894 = t868 - t893)
    (ht955 : t955 = t954 + t894) (ht958 : t958 = t955.sshiftRight 21) (et954 : t954 = carry10_2)
    (et867 : t867 = carry10_1) (et624 : t624 = s18) (et598 : t598 = s11) (et628 : t628 = s19)
    (et632 : t632 = s20) (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22)
    (et717 : t717 = carry10) (et755 : t755 = carry11) (et892 : t892 = carry11_1)
    (hs11_1 : s11_1 = s11 + s23 * 666643#64) (hs11_2 : s11_2 = s11_1 + s22 * 470296#64)
    (hs11_3 : s11_3 = s11_2 + s21 * 654183#64) (hs11_4 : s11_4 = s11_3 - s20 * 997805#64)
    (hs11_5 : s11_5 = s11_4 + s19 * 136657#64) (hs11_6 : s11_6 = s11_5 - s18 * 683901#64)
    (hs11_7 : s11_7 = s11_6 + carry10) (hs11_8 : s11_8 = s11_7 - carry11 <<< 21)
    (hs11_9 : s11_9 = s11_8 + carry10_1) (hs11_10 : s11_10 = s11_9 - carry11_1 <<< 21)
    (hs11_11 : s11_11 = s11_10 + carry10_2) (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) :
    t958 = carry11_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry0_2` as the C computes it is the compiled `%973`. -/
theorem x25519_sc_reduce.bridge_carry0_2
    (t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756 t817 t818 t835 t836 t895 t896
      t906 t907 t961 t962 t973 t958 t755 t628 t602 t632 t636 t643 t640 t728 t556 t833 t892 t902
      s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 s12_10 s0_4 s12_11 s0_5
      carry0_2 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0 carry11_1 carry0_1 carry11_2 :
      BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht654 : t654 = t640 * 654183#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht672 : t672 = t632 * 136657#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht756 : t756 = t755 + t735) (ht817 : t817 = t756 * 666643#64) (ht818 : t818 = t817 + t556)
    (ht835 : t835 = t833 <<< 21) (ht836 : t836 = t818 - t835) (ht895 : t895 = t892 * 666643#64)
    (ht896 : t896 = t836 + t895) (ht906 : t906 = t902 <<< 21) (ht907 : t907 = t896 - t906)
    (ht961 : t961 = t958 * 666643#64) (ht962 : t962 = t961 + t907)
    (ht973 : t973 = t962.sshiftRight 21) (et958 : t958 = carry11_2) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et632 : t632 = s20) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et556 : t556 = s0)
    (et833 : t833 = carry0) (et892 : t892 = carry11_1) (et902 : t902 = carry0_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hs12_8 : s12_8 = 0#64) (hs0_2 : s0_2 = s0_1 - carry0 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64)
    (hs12_10 : s12_10 = 0#64) (hs0_4 : s0_4 = s0_3 - carry0_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs0_5 : s0_5 = s0_4 + s12_11 * 666643#64)
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) : t973 = carry0_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s0_6` as the C computes it is the compiled `%976`. -/
theorem x25519_sc_reduce.bridge_s0_6
    (t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756 t817 t818 t835 t836 t895 t896
      t906 t907 t961 t962 t975 t976 t958 t755 t628 t602 t632 t636 t643 t640 t728 t556 t833 t892 t902
      t973 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 s12_10 s0_4 s12_11
      s0_5 s0_6 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0 carry11_1 carry0_1 carry11_2
      carry0_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht654 : t654 = t640 * 654183#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht672 : t672 = t632 * 136657#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht756 : t756 = t755 + t735) (ht817 : t817 = t756 * 666643#64) (ht818 : t818 = t817 + t556)
    (ht835 : t835 = t833 <<< 21) (ht836 : t836 = t818 - t835) (ht895 : t895 = t892 * 666643#64)
    (ht896 : t896 = t836 + t895) (ht906 : t906 = t902 <<< 21) (ht907 : t907 = t896 - t906)
    (ht961 : t961 = t958 * 666643#64) (ht962 : t962 = t961 + t907) (ht975 : t975 = t973 <<< 21)
    (ht976 : t976 = t962 - t975) (et958 : t958 = carry11_2) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et632 : t632 = s20) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et556 : t556 = s0)
    (et833 : t833 = carry0) (et892 : t892 = carry11_1) (et902 : t902 = carry0_1)
    (et973 : t973 = carry0_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs0_1 : s0_1 = s0 + s12_7 * 666643#64) (hs12_8 : s12_8 = 0#64)
    (hs0_2 : s0_2 = s0_1 - carry0 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64) (hs12_10 : s12_10 = 0#64)
    (hs0_4 : s0_4 = s0_3 - carry0_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs0_5 : s0_5 = s0_4 + s12_11 * 666643#64) (hs0_6 : s0_6 = s0_5 - carry0_2 <<< 21) :
    t976 = s0_6 := by
  subst_vars
  grind

/-- `carry1_2` as the C computes it is the compiled `%977`. -/
theorem x25519_sc_reduce.bridge_carry1_2
    (t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897 t903 t904 t905 t913 t914 t963 t964
      t974 t977 t892 t872 t632 t606 t636 t643 t640 t728 t760 t560 t755 t628 t602 t833 t902 t908 t958
      t973 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2
      s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 carry1_2 s1 s12 s13 s19 s20 s21
      s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2 :
      BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht654 : t654 = t640 * 654183#64) (ht655 : t655 = t640 * 18446744073708553811#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht672 : t672 = t632 * 136657#64) (ht673 : t673 = t632 * 18446744073708867715#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663)
    (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728)
    (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734) (ht756 : t756 = t755 + t735)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht807 : t807 = t763 * 666643#64)
    (ht808 : t808 = t807 + t560) (ht819 : t819 = t756 * 470296#64) (ht820 : t820 = t808 + t819)
    (ht834 : t834 = t820 + t833) (ht873 : t873 = t872 <<< 21) (ht897 : t897 = t892 * 470296#64)
    (ht903 : t903 = t897 - t873) (ht904 : t904 = t903 + t834) (ht905 : t905 = t904 + t902)
    (ht913 : t913 = t908 <<< 21) (ht914 : t914 = t905 - t913) (ht963 : t963 = t958 * 470296#64)
    (ht964 : t964 = t914 + t963) (ht974 : t974 = t964 + t973) (ht977 : t977 = t974.sshiftRight 21)
    (et892 : t892 = carry11_1) (et872 : t872 = carry1) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et560 : t560 = s1) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et833 : t833 = carry0) (et902 : t902 = carry0_1) (et908 : t908 = carry1_1)
    (et958 : t958 = carry11_2) (et973 : t973 = carry0_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs12_10 : s12_10 = 0#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs1_8 : s1_8 = s1_7 + s12_11 * 470296#64) (hs1_9 : s1_9 = s1_8 + carry0_2)
    (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) : t977 = carry1_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s1_10` as the C computes it is the compiled `%980`. -/
theorem x25519_sc_reduce.bridge_s1_10
    (t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897 t903 t904 t905 t913 t914 t963 t964
      t974 t979 t980 t892 t872 t632 t606 t636 t643 t640 t728 t760 t560 t755 t628 t602 t833 t902 t908
      t958 t973 t977 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6
      s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 s1_10 s1 s12 s13 s19
      s20 s21 s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2
      carry0_2 carry1_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht654 : t654 = t640 * 654183#64) (ht655 : t655 = t640 * 18446744073708553811#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht672 : t672 = t632 * 136657#64) (ht673 : t673 = t632 * 18446744073708867715#64)
    (ht679 : t679 = t628 * 18446744073708867715#64) (ht680 : t680 = t679 + t602)
    (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662) (ht683 : t683 = t682 + t645)
    (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663)
    (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728)
    (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734) (ht756 : t756 = t755 + t735)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht807 : t807 = t763 * 666643#64)
    (ht808 : t808 = t807 + t560) (ht819 : t819 = t756 * 470296#64) (ht820 : t820 = t808 + t819)
    (ht834 : t834 = t820 + t833) (ht873 : t873 = t872 <<< 21) (ht897 : t897 = t892 * 470296#64)
    (ht903 : t903 = t897 - t873) (ht904 : t904 = t903 + t834) (ht905 : t905 = t904 + t902)
    (ht913 : t913 = t908 <<< 21) (ht914 : t914 = t905 - t913) (ht963 : t963 = t958 * 470296#64)
    (ht964 : t964 = t914 + t963) (ht974 : t974 = t964 + t973) (ht979 : t979 = t977 <<< 21)
    (ht980 : t980 = t974 - t979) (et892 : t892 = carry11_1) (et872 : t872 = carry1)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et643 : t643 = s23)
    (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13) (et560 : t560 = s1)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12) (et833 : t833 = carry0)
    (et902 : t902 = carry0_1) (et908 : t908 = carry1_1) (et958 : t958 = carry11_2)
    (et973 : t973 = carry0_2) (et977 : t977 = carry1_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs12_10 : s12_10 = 0#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs1_8 : s1_8 = s1_7 + s12_11 * 470296#64) (hs1_9 : s1_9 = s1_8 + carry0_2)
    (hs1_10 : s1_10 = s1_9 - carry1_2 <<< 21) : t980 = s1_10 := by
  subst_vars
  grind

/-- `carry2_2` as the C computes it is the compiled `%981`. -/
theorem x25519_sc_reduce.bridge_carry2_2
    (t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762 t763 t800 t809 t821 t822 t823
      t824 t844 t898 t909 t910 t911 t912 t919 t920 t965 t966 t978 t981 t892 t838 t632 t606 t636 t643
      t640 t728 t760 t564 t610 t737 t755 t628 t602 t872 t908 t915 t958 t977 s12_1 s13_1 s14_1 s12_2
      s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2
      s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 carry2_2 s2 s12 s13 s14 s19
      s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1 carry2_1
      carry11_2 carry1_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht800 : t800 = t761 * 666643#64) (ht809 : t809 = t763 * 470296#64)
    (ht821 : t821 = t756 * 654183#64) (ht822 : t822 = t809 + t564) (ht823 : t823 = t822 + t800)
    (ht824 : t824 = t823 + t821) (ht844 : t844 = t838 <<< 21) (ht898 : t898 = t892 * 654183#64)
    (ht909 : t909 = t898 - t844) (ht910 : t910 = t909 + t824) (ht911 : t911 = t910 + t872)
    (ht912 : t912 = t911 + t908) (ht919 : t919 = t915 <<< 21) (ht920 : t920 = t912 - t919)
    (ht965 : t965 = t958 * 654183#64) (ht966 : t966 = t920 + t965) (ht978 : t978 = t966 + t977)
    (ht981 : t981 = t978.sshiftRight 21) (et892 : t892 = carry11_1) (et838 : t838 = carry2)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et643 : t643 = s23)
    (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13) (et564 : t564 = s2)
    (et610 : t610 = s14) (et737 : t737 = carry14) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et872 : t872 = carry1) (et908 : t908 = carry1_1) (et915 : t915 = carry2_1)
    (et958 : t958 = carry11_2) (et977 : t977 = carry1_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs2_1 : s2_1 = s2 + s14_5 * 666643#64)
    (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hs12_8 : s12_8 = 0#64) (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs12_10 : s12_10 = 0#64) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs2_9 : s2_9 = s2_8 + s12_11 * 654183#64) (hs2_10 : s2_10 = s2_9 + carry1_2)
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) : t981 = carry2_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s2_11` as the C computes it is the compiled `%984`. -/
theorem x25519_sc_reduce.bridge_s2_11
    (t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762 t763 t800 t809 t821 t822 t823
      t824 t844 t898 t909 t910 t911 t912 t919 t920 t965 t966 t978 t983 t984 t892 t838 t632 t606 t636
      t643 t640 t728 t760 t564 t610 t737 t755 t628 t602 t872 t908 t915 t958 t977 t981 s12_1 s13_1
      s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5
      s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 s2_11 s2
      s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1
      carry1_1 carry2_1 carry11_2 carry1_2 carry2_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht800 : t800 = t761 * 666643#64) (ht809 : t809 = t763 * 470296#64)
    (ht821 : t821 = t756 * 654183#64) (ht822 : t822 = t809 + t564) (ht823 : t823 = t822 + t800)
    (ht824 : t824 = t823 + t821) (ht844 : t844 = t838 <<< 21) (ht898 : t898 = t892 * 654183#64)
    (ht909 : t909 = t898 - t844) (ht910 : t910 = t909 + t824) (ht911 : t911 = t910 + t872)
    (ht912 : t912 = t911 + t908) (ht919 : t919 = t915 <<< 21) (ht920 : t920 = t912 - t919)
    (ht965 : t965 = t958 * 654183#64) (ht966 : t966 = t920 + t965) (ht978 : t978 = t966 + t977)
    (ht983 : t983 = t981 <<< 21) (ht984 : t984 = t978 - t983) (et892 : t892 = carry11_1)
    (et838 : t838 = carry2) (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21)
    (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et564 : t564 = s2) (et610 : t610 = s14) (et737 : t737 = carry14) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et872 : t872 = carry1) (et908 : t908 = carry1_1)
    (et915 : t915 = carry2_1) (et958 : t958 = carry11_2) (et977 : t977 = carry1_2)
    (et981 : t981 = carry2_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs2_1 : s2_1 = s2 + s14_5 * 666643#64)
    (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hs12_8 : s12_8 = 0#64) (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs12_10 : s12_10 = 0#64) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs2_9 : s2_9 = s2_8 + s12_11 * 654183#64) (hs2_10 : s2_10 = s2_9 + carry1_2)
    (hs2_11 : s2_11 = s2_10 - carry2_2 <<< 21) : t984 = s2_11 := by
  subst_vars
  grind

/-- `carry3_2` as the C computes it is the compiled `%985`. -/
theorem x25519_sc_reduce.bridge_carry3_2
    (t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672 t673 t679
      t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t756 t761 t762 t763
      t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876 t899 t916 t917 t918 t926 t927 t967
      t968 t982 t985 t892 t875 t632 t606 t636 t643 t640 t728 t760 t568 t613 t737 t765 t610 t755 t628
      t602 t838 t915 t921 t958 t981 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4
      s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 carry3_2 s3 s12 s13 s14 s15 s19
      s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1
      carry3_1 carry11_2 carry2_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht792 : t792 = t768 * 666643#64) (ht801 : t801 = t761 * 470296#64)
    (ht810 : t810 = t763 * 654183#64) (ht825 : t825 = t756 * 18446744073708553811#64)
    (ht839 : t839 = t810 + t568) (ht840 : t840 = t839 + t792) (ht841 : t841 = t840 + t801)
    (ht842 : t842 = t841 + t825) (ht843 : t843 = t842 + t838) (ht876 : t876 = t875 <<< 21)
    (ht899 : t899 = t892 * 18446744073708553811#64) (ht916 : t916 = t899 - t876)
    (ht917 : t917 = t916 + t843) (ht918 : t918 = t917 + t915) (ht926 : t926 = t921 <<< 21)
    (ht927 : t927 = t918 - t926) (ht967 : t967 = t958 * 18446744073708553811#64)
    (ht968 : t968 = t927 + t967) (ht982 : t982 = t968 + t981) (ht985 : t985 = t982.sshiftRight 21)
    (et892 : t892 = carry11_1) (et875 : t875 = carry3) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et568 : t568 = s3) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et765 : t765 = carry15) (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19)
    (et602 : t602 = s12) (et838 : t838 = carry2) (et915 : t915 = carry2_1) (et921 : t921 = carry3_1)
    (et958 : t958 = carry11_2) (et981 : t981 = carry2_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hs3_6 : s3_6 = s3_5 - carry3 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64) (hs12_10 : s12_10 = 0#64)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs3_10 : s3_10 = s3_9 - s12_11 * 997805#64)
    (hs3_11 : s3_11 = s3_10 + carry2_2) (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) :
    t985 = carry3_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s3_12` as the C computes it is the compiled `%988`. -/
theorem x25519_sc_reduce.bridge_s3_12
    (t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672 t673 t679
      t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t756 t761 t762 t763
      t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876 t899 t916 t917 t918 t926 t927 t967
      t968 t982 t987 t988 t892 t875 t632 t606 t636 t643 t640 t728 t760 t568 t613 t737 t765 t610 t755
      t628 t602 t838 t915 t921 t958 t981 t985 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3
      s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 s3_12 s3 s12 s13 s14 s15
      s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1
      carry3_1 carry11_2 carry2_2 carry3_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht792 : t792 = t768 * 666643#64) (ht801 : t801 = t761 * 470296#64)
    (ht810 : t810 = t763 * 654183#64) (ht825 : t825 = t756 * 18446744073708553811#64)
    (ht839 : t839 = t810 + t568) (ht840 : t840 = t839 + t792) (ht841 : t841 = t840 + t801)
    (ht842 : t842 = t841 + t825) (ht843 : t843 = t842 + t838) (ht876 : t876 = t875 <<< 21)
    (ht899 : t899 = t892 * 18446744073708553811#64) (ht916 : t916 = t899 - t876)
    (ht917 : t917 = t916 + t843) (ht918 : t918 = t917 + t915) (ht926 : t926 = t921 <<< 21)
    (ht927 : t927 = t918 - t926) (ht967 : t967 = t958 * 18446744073708553811#64)
    (ht968 : t968 = t927 + t967) (ht982 : t982 = t968 + t981) (ht987 : t987 = t985 <<< 21)
    (ht988 : t988 = t982 - t987) (et892 : t892 = carry11_1) (et875 : t875 = carry3)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et643 : t643 = s23)
    (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13) (et568 : t568 = s3)
    (et613 : t613 = s15) (et737 : t737 = carry14) (et765 : t765 = carry15) (et610 : t610 = s14)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12) (et838 : t838 = carry2)
    (et915 : t915 = carry2_1) (et921 : t921 = carry3_1) (et958 : t958 = carry11_2)
    (et981 : t981 = carry2_2) (et985 : t985 = carry3_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hs3_6 : s3_6 = s3_5 - carry3 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64) (hs12_10 : s12_10 = 0#64)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs3_10 : s3_10 = s3_9 - s12_11 * 997805#64)
    (hs3_11 : s3_11 = s3_10 + carry2_2) (hs3_12 : s3_12 = s3_11 - carry3_2 <<< 21) :
    t988 = s3_12 := by
  subst_vars
  grind

/-- `carry4_2` as the C computes it is the compiled `%989`. -/
theorem x25519_sc_reduce.bridge_carry4_2
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t744 t745
      t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826 t827 t828 t829 t830 t852 t900
      t922 t923 t924 t925 t932 t933 t969 t970 t986 t989 t892 t846 t765 t643 t616 t742 t572 t632 t606
      t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t875 t921 t928 t958 t985 s12_1 s13_1 s14_1
      s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3
      s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8
      s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 carry4_2 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23
      carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1 carry4_1
      carry11_2 carry3_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht781 : t781 = t766 * 666643#64) (ht782 : t782 = t781 + t572) (ht793 : t793 = t768 * 470296#64)
    (ht802 : t802 = t761 * 654183#64) (ht811 : t811 = t763 * 18446744073708553811#64)
    (ht826 : t826 = t756 * 136657#64) (ht827 : t827 = t782 + t811) (ht828 : t828 = t827 + t793)
    (ht829 : t829 = t828 + t802) (ht830 : t830 = t829 + t826) (ht852 : t852 = t846 <<< 21)
    (ht900 : t900 = t892 * 136657#64) (ht922 : t922 = t900 - t852) (ht923 : t923 = t922 + t830)
    (ht924 : t924 = t923 + t875) (ht925 : t925 = t924 + t921) (ht932 : t932 = t928 <<< 21)
    (ht933 : t933 = t925 - t932) (ht969 : t969 = t958 * 136657#64) (ht970 : t970 = t933 + t969)
    (ht986 : t986 = t970 + t985) (ht989 : t989 = t986.sshiftRight 21) (et892 : t892 = carry11_1)
    (et846 : t846 = carry4) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et742 : t742 = carry16) (et572 : t572 = s4) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et875 : t875 = carry3) (et921 : t921 = carry3_1)
    (et928 : t928 = carry4_1) (et958 : t958 = carry11_2) (et985 : t985 = carry3_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs4_1 : s4_1 = s4 + s16_3 * 666643#64)
    (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64)
    (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64)
    (hs12_8 : s12_8 = 0#64) (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs12_10 : s12_10 = 0#64) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs4_11 : s4_11 = s4_10 + s12_11 * 136657#64) (hs4_12 : s4_12 = s4_11 + carry3_2)
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) : t989 = carry4_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s4_13` as the C computes it is the compiled `%992`. -/
theorem x25519_sc_reduce.bridge_s4_13
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t744 t745
      t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826 t827 t828 t829 t830 t852 t900
      t922 t923 t924 t925 t932 t933 t969 t970 t986 t991 t992 t892 t846 t765 t643 t616 t742 t572 t632
      t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t875 t921 t928 t958 t985 t989 s12_1
      s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7
      s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4_13 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22
      s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1 carry4_1
      carry11_2 carry3_2 carry4_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht756 : t756 = t755 + t735)
    (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762)
    (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht781 : t781 = t766 * 666643#64) (ht782 : t782 = t781 + t572) (ht793 : t793 = t768 * 470296#64)
    (ht802 : t802 = t761 * 654183#64) (ht811 : t811 = t763 * 18446744073708553811#64)
    (ht826 : t826 = t756 * 136657#64) (ht827 : t827 = t782 + t811) (ht828 : t828 = t827 + t793)
    (ht829 : t829 = t828 + t802) (ht830 : t830 = t829 + t826) (ht852 : t852 = t846 <<< 21)
    (ht900 : t900 = t892 * 136657#64) (ht922 : t922 = t900 - t852) (ht923 : t923 = t922 + t830)
    (ht924 : t924 = t923 + t875) (ht925 : t925 = t924 + t921) (ht932 : t932 = t928 <<< 21)
    (ht933 : t933 = t925 - t932) (ht969 : t969 = t958 * 136657#64) (ht970 : t970 = t933 + t969)
    (ht986 : t986 = t970 + t985) (ht991 : t991 = t989 <<< 21) (ht992 : t992 = t986 - t991)
    (et892 : t892 = carry11_1) (et846 : t846 = carry4) (et765 : t765 = carry15) (et643 : t643 = s23)
    (et616 : t616 = s16) (et742 : t742 = carry16) (et572 : t572 = s4) (et632 : t632 = s20)
    (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14)
    (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12) (et875 : t875 = carry3)
    (et921 : t921 = carry3_1) (et928 : t928 = carry4_1) (et958 : t958 = carry11_2)
    (et985 : t985 = carry3_2) (et989 : t989 = carry4_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64)
    (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64)
    (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) (hs12_8 : s12_8 = 0#64)
    (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs12_10 : s12_10 = 0#64) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs4_11 : s4_11 = s4_10 + s12_11 * 136657#64) (hs4_12 : s4_12 = s4_11 + carry3_2)
    (hs4_13 : s4_13 = s4_12 - carry4_2 <<< 21) : t992 = s4_13 := by
  subst_vars
  grind

/-- `carry5_2` as the C computes it is the compiled `%993`. -/
theorem x25519_sc_reduce.bridge_carry5_2
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t743 t744
      t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794 t803 t812 t831 t847 t848 t849
      t850 t851 t880 t901 t929 t930 t931 t936 t937 t971 t972 t990 t993 t892 t878 t742 t620 t576 t765
      t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t846 t928 t934 t958 t989
      s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5
      s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5
      s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12 s5_13 carry5_2 s5 s12 s13 s14
      s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry5
      carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht769 : t769 = t743 * 666643#64) (ht770 : t770 = t769 + t576)
    (ht783 : t783 = t766 * 470296#64) (ht784 : t784 = t770 + t783) (ht794 : t794 = t768 * 654183#64)
    (ht803 : t803 = t761 * 18446744073708553811#64) (ht812 : t812 = t763 * 136657#64)
    (ht831 : t831 = t756 * 18446744073708867715#64) (ht847 : t847 = t784 + t812)
    (ht848 : t848 = t847 + t794) (ht849 : t849 = t848 + t803) (ht850 : t850 = t849 + t831)
    (ht851 : t851 = t850 + t846) (ht880 : t880 = t878 <<< 21)
    (ht901 : t901 = t892 * 18446744073708867715#64) (ht929 : t929 = t901 - t880)
    (ht930 : t930 = t929 + t851) (ht931 : t931 = t930 + t928) (ht936 : t936 = t934 <<< 21)
    (ht937 : t937 = t931 - t936) (ht971 : t971 = t958 * 18446744073708867715#64)
    (ht972 : t972 = t937 + t971) (ht990 : t990 = t972 + t989) (ht993 : t993 = t990.sshiftRight 21)
    (et892 : t892 = carry11_1) (et878 : t878 = carry5) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et576 : t576 = s5) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22)
    (et728 : t728 = carry12) (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et610 : t610 = s14) (et755 : t755 = carry11) (et628 : t628 = s19) (et602 : t602 = s12)
    (et846 : t846 = carry4) (et928 : t928 = carry4_1) (et934 : t934 = carry5_1)
    (et958 : t958 = carry11_2) (et989 : t989 = carry4_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hs5_8 : s5_8 = s5_7 - carry5 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64) (hs12_10 : s12_10 = 0#64)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs5_12 : s5_12 = s5_11 - s12_11 * 683901#64)
    (hs5_13 : s5_13 = s5_12 + carry4_2) (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) :
    t993 = carry5_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s5_14` as the C computes it is the compiled `%996`. -/
theorem x25519_sc_reduce.bridge_s5_14
    (t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738 t739 t740 t743 t744
      t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794 t803 t812 t831 t847 t848 t849
      t850 t851 t880 t901 t929 t930 t931 t936 t937 t971 t972 t990 t995 t996 t892 t878 t742 t620 t576
      t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t846 t928 t934 t958
      t989 t993 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4
      s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4
      s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12 s5_13 s5_14 s5 s12 s13
      s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4
      carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 carry5_2 : BitVec 64)
    (ht645 : t645 = t643 * 470296#64) (ht646 : t646 = t643 * 654183#64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht654 : t654 = t640 * 654183#64)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht662 : t662 = t636 * 18446744073708553811#64) (ht663 : t663 = t636 * 136657#64)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht672 : t672 = t632 * 136657#64)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht679 : t679 = t628 * 18446744073708867715#64)
    (ht680 : t680 = t679 + t602) (ht681 : t681 = t680 + t672) (ht682 : t682 = t681 + t662)
    (ht683 : t683 = t682 + t645) (ht684 : t684 = t683 + t654) (ht729 : t729 = t673 + t606)
    (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646) (ht732 : t732 = t731 + t655)
    (ht733 : t733 = t732 + t728) (ht734 : t734 = t728 <<< 21) (ht735 : t735 = t684 - t734)
    (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739)
    (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744)
    (ht756 : t756 = t755 + t735) (ht761 : t761 = t760 + t740) (ht762 : t762 = t760 <<< 21)
    (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht769 : t769 = t743 * 666643#64) (ht770 : t770 = t769 + t576)
    (ht783 : t783 = t766 * 470296#64) (ht784 : t784 = t770 + t783) (ht794 : t794 = t768 * 654183#64)
    (ht803 : t803 = t761 * 18446744073708553811#64) (ht812 : t812 = t763 * 136657#64)
    (ht831 : t831 = t756 * 18446744073708867715#64) (ht847 : t847 = t784 + t812)
    (ht848 : t848 = t847 + t794) (ht849 : t849 = t848 + t803) (ht850 : t850 = t849 + t831)
    (ht851 : t851 = t850 + t846) (ht880 : t880 = t878 <<< 21)
    (ht901 : t901 = t892 * 18446744073708867715#64) (ht929 : t929 = t901 - t880)
    (ht930 : t930 = t929 + t851) (ht931 : t931 = t930 + t928) (ht936 : t936 = t934 <<< 21)
    (ht937 : t937 = t931 - t936) (ht971 : t971 = t958 * 18446744073708867715#64)
    (ht972 : t972 = t937 + t971) (ht990 : t990 = t972 + t989) (ht995 : t995 = t993 <<< 21)
    (ht996 : t996 = t990 - t995) (et892 : t892 = carry11_1) (et878 : t878 = carry5)
    (et742 : t742 = carry16) (et620 : t620 = s17) (et576 : t576 = s5) (et765 : t765 = carry15)
    (et643 : t643 = s23) (et616 : t616 = s16) (et632 : t632 = s20) (et606 : t606 = s13)
    (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12) (et760 : t760 = carry13)
    (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14) (et755 : t755 = carry11)
    (et628 : t628 = s19) (et602 : t602 = s12) (et846 : t846 = carry4) (et928 : t928 = carry4_1)
    (et934 : t934 = carry5_1) (et958 : t958 = carry11_2) (et989 : t989 = carry4_2)
    (et993 : t993 = carry5_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hs5_8 : s5_8 = s5_7 - carry5 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64) (hs12_10 : s12_10 = 0#64)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs5_12 : s5_12 = s5_11 - s12_11 * 683901#64)
    (hs5_13 : s5_13 = s5_12 + carry4_2) (hs5_14 : s5_14 = s5_13 - carry5_2 <<< 21) :
    t996 = s5_14 := by
  subst_vars
  grind

/-- `carry6_3` as the C computes it is the compiled `%997`. -/
theorem x25519_sc_reduce.bridge_carry6_3
    (t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664 t665 t666 t667 t673 t685 t686 t705
      t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745 t761 t762 t763 t766 t767 t768 t771
      t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879 t935 t940 t941 t994 t997 t993 t624
      t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t854 t878 t934
      t938 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4
      s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 s6_11 s6_12
      carry6_3 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13
      carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 : BitVec 64)
    (ht646 : t646 = t643 * 654183#64) (ht647 : t647 = t643 * 18446744073708553811#64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht663 : t663 = t636 * 136657#64) (ht664 : t664 = t636 * 18446744073708867715#64)
    (ht665 : t665 = t664 + t610) (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht685 : t685 = t624 * 666643#64)
    (ht686 : t686 = t685 + t580) (ht705 : t705 = t701 <<< 21) (ht706 : t706 = t686 - t705)
    (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646)
    (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728) (ht738 : t738 = t658 + t737)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht761 : t761 = t760 + t740)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767) (ht771 : t771 = t743 * 470296#64)
    (ht772 : t772 = t706 + t771) (ht785 : t785 = t766 * 654183#64) (ht786 : t786 = t772 + t785)
    (ht795 : t795 = t768 * 18446744073708553811#64) (ht804 : t804 = t761 * 136657#64)
    (ht813 : t813 = t763 * 18446744073708867715#64) (ht814 : t814 = t786 + t813)
    (ht815 : t815 = t814 + t795) (ht816 : t816 = t815 + t804) (ht856 : t856 = t854 <<< 21)
    (ht857 : t857 = t816 - t856) (ht879 : t879 = t857 + t878) (ht935 : t935 = t879 + t934)
    (ht940 : t940 = t938 <<< 21) (ht941 : t941 = t935 - t940) (ht994 : t994 = t993 + t941)
    (ht997 : t997 = t994.sshiftRight 21) (et993 : t993 = carry5_2) (et624 : t624 = s18)
    (et580 : t580 = s6) (et701 : t701 = carry6) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16) (et632 : t632 = s20)
    (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22) (et728 : t728 = carry12)
    (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14) (et610 : t610 = s14)
    (et854 : t854 = carry6_1) (et878 : t878 = carry5) (et934 : t934 = carry5_1)
    (et938 : t938 = carry6_2) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21) (hs6_12 : s6_12 = s6_11 + carry5_2)
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) : t997 = carry6_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s6_13` as the C computes it is the compiled `%1000`. -/
theorem x25519_sc_reduce.bridge_s6_13
    (t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664 t665 t666 t667 t673 t685 t686 t705
      t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745 t761 t762 t763 t766 t767 t768 t771
      t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879 t935 t940 t941 t994 t999 t1000
      t993 t624 t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t854
      t878 t934 t938 t997 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2
      s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10
      s6_11 s6_12 s6_13 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16
      carry13 carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 carry6_3 : BitVec 64)
    (ht646 : t646 = t643 * 654183#64) (ht647 : t647 = t643 * 18446744073708553811#64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht655 : t655 = t640 * 18446744073708553811#64) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht663 : t663 = t636 * 136657#64) (ht664 : t664 = t636 * 18446744073708867715#64)
    (ht665 : t665 = t664 + t610) (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656)
    (ht673 : t673 = t632 * 18446744073708867715#64) (ht685 : t685 = t624 * 666643#64)
    (ht686 : t686 = t685 + t580) (ht705 : t705 = t701 <<< 21) (ht706 : t706 = t686 - t705)
    (ht729 : t729 = t673 + t606) (ht730 : t730 = t729 + t663) (ht731 : t731 = t730 + t646)
    (ht732 : t732 = t731 + t655) (ht733 : t733 = t732 + t728) (ht738 : t738 = t658 + t737)
    (ht739 : t739 = t737 <<< 21) (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht761 : t761 = t760 + t740)
    (ht762 : t762 = t760 <<< 21) (ht763 : t763 = t733 - t762) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767) (ht771 : t771 = t743 * 470296#64)
    (ht772 : t772 = t706 + t771) (ht785 : t785 = t766 * 654183#64) (ht786 : t786 = t772 + t785)
    (ht795 : t795 = t768 * 18446744073708553811#64) (ht804 : t804 = t761 * 136657#64)
    (ht813 : t813 = t763 * 18446744073708867715#64) (ht814 : t814 = t786 + t813)
    (ht815 : t815 = t814 + t795) (ht816 : t816 = t815 + t804) (ht856 : t856 = t854 <<< 21)
    (ht857 : t857 = t816 - t856) (ht879 : t879 = t857 + t878) (ht935 : t935 = t879 + t934)
    (ht940 : t940 = t938 <<< 21) (ht941 : t941 = t935 - t940) (ht994 : t994 = t993 + t941)
    (ht999 : t999 = t997 <<< 21) (ht1000 : t1000 = t994 - t999) (et993 : t993 = carry5_2)
    (et624 : t624 = s18) (et580 : t580 = s6) (et701 : t701 = carry6) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et632 : t632 = s20) (et606 : t606 = s13) (et636 : t636 = s21) (et640 : t640 = s22)
    (et728 : t728 = carry12) (et760 : t760 = carry13) (et613 : t613 = s15) (et737 : t737 = carry14)
    (et610 : t610 = s14) (et854 : t854 = carry6_1) (et878 : t878 = carry5) (et934 : t934 = carry5_1)
    (et938 : t938 = carry6_2) (et997 : t997 = carry6_3) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21) (hs6_12 : s6_12 = s6_11 + carry5_2)
    (hs6_13 : s6_13 = s6_12 - carry6_3 <<< 21) : t1000 = s6_13 := by
  subst_vars
  grind

/-- `carry7_3` as the C computes it is the compiled `%1001`. -/
theorem x25519_sc_reduce.bridge_carry7_3
    (t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667 t674 t687 t702 t703 t704 t738 t739
      t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774 t787 t788 t796 t797 t805 t806 t855
      t884 t885 t939 t944 t945 t998 t1001 t997 t938 t624 t583 t628 t701 t747 t742 t620 t765 t643
      t616 t613 t640 t737 t760 t636 t610 t854 t882 t942 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1
      s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11
      s7_12 s7_13 carry7_3 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7
      carry13 carry15 carry6_1 carry7_1 carry6_2 carry7_2 carry6_3 : BitVec 64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht674 : t674 = t628 * 666643#64)
    (ht687 : t687 = t624 * 470296#64) (ht702 : t702 = t687 + t583) (ht703 : t703 = t702 + t674)
    (ht704 : t704 = t703 + t701) (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21)
    (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht749 : t749 = t747 <<< 21) (ht750 : t750 = t704 - t749)
    (ht761 : t761 = t760 + t740) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht773 : t773 = t743 * 654183#64) (ht774 : t774 = t750 + t773)
    (ht787 : t787 = t766 * 18446744073708553811#64) (ht788 : t788 = t774 + t787)
    (ht796 : t796 = t768 * 136657#64) (ht797 : t797 = t788 + t796)
    (ht805 : t805 = t761 * 18446744073708867715#64) (ht806 : t806 = t797 + t805)
    (ht855 : t855 = t806 + t854) (ht884 : t884 = t882 <<< 21) (ht885 : t885 = t855 - t884)
    (ht939 : t939 = t938 + t885) (ht944 : t944 = t942 <<< 21) (ht945 : t945 = t939 - t944)
    (ht998 : t998 = t997 + t945) (ht1001 : t1001 = t998.sshiftRight 21) (et997 : t997 = carry6_3)
    (et938 : t938 = carry6_2) (et624 : t624 = s18) (et583 : t583 = s7) (et628 : t628 = s19)
    (et701 : t701 = carry6) (et747 : t747 = carry7) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16) (et613 : t613 = s15)
    (et640 : t640 = s22) (et737 : t737 = carry14) (et760 : t760 = carry13) (et636 : t636 = s21)
    (et610 : t610 = s14) (et854 : t854 = carry6_1) (et882 : t882 = carry7_1)
    (et942 : t942 = carry7_2) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hs7_12 : s7_12 = s7_11 - carry7_2 <<< 21)
    (hs7_13 : s7_13 = s7_12 + carry6_3) (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) :
    t1001 = carry7_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s7_14` as the C computes it is the compiled `%1004`. -/
theorem x25519_sc_reduce.bridge_s7_14
    (t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667 t674 t687 t702 t703 t704 t738 t739
      t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774 t787 t788 t796 t797 t805 t806 t855
      t884 t885 t939 t944 t945 t998 t1003 t1004 t997 t938 t624 t583 t628 t701 t747 t742 t620 t765
      t643 t616 t613 t640 t737 t760 t636 t610 t854 t882 t942 t1001 s14_1 s15_1 s16_1 s14_2 s15_2
      s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9
      s7_10 s7_11 s7_12 s7_13 s7_14 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16
      carry7 carry13 carry15 carry6_1 carry7_1 carry6_2 carry7_2 carry6_3 carry7_3 : BitVec 64)
    (ht647 : t647 = t643 * 18446744073708553811#64) (ht648 : t648 = t643 * 136657#64)
    (ht649 : t649 = t648 + t613) (ht650 : t650 = t643 * 18446744073708867715#64)
    (ht651 : t651 = t650 + t616) (ht656 : t656 = t640 * 136657#64)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht664 : t664 = t636 * 18446744073708867715#64) (ht665 : t665 = t664 + t610)
    (ht666 : t666 = t665 + t647) (ht667 : t667 = t666 + t656) (ht674 : t674 = t628 * 666643#64)
    (ht687 : t687 = t624 * 470296#64) (ht702 : t702 = t687 + t583) (ht703 : t703 = t702 + t674)
    (ht704 : t704 = t703 + t701) (ht738 : t738 = t658 + t737) (ht739 : t739 = t737 <<< 21)
    (ht740 : t740 = t667 - t739) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht749 : t749 = t747 <<< 21) (ht750 : t750 = t704 - t749)
    (ht761 : t761 = t760 + t740) (ht766 : t766 = t765 + t745) (ht767 : t767 = t765 <<< 21)
    (ht768 : t768 = t738 - t767) (ht773 : t773 = t743 * 654183#64) (ht774 : t774 = t750 + t773)
    (ht787 : t787 = t766 * 18446744073708553811#64) (ht788 : t788 = t774 + t787)
    (ht796 : t796 = t768 * 136657#64) (ht797 : t797 = t788 + t796)
    (ht805 : t805 = t761 * 18446744073708867715#64) (ht806 : t806 = t797 + t805)
    (ht855 : t855 = t806 + t854) (ht884 : t884 = t882 <<< 21) (ht885 : t885 = t855 - t884)
    (ht939 : t939 = t938 + t885) (ht944 : t944 = t942 <<< 21) (ht945 : t945 = t939 - t944)
    (ht998 : t998 = t997 + t945) (ht1003 : t1003 = t1001 <<< 21) (ht1004 : t1004 = t998 - t1003)
    (et997 : t997 = carry6_3) (et938 : t938 = carry6_2) (et624 : t624 = s18) (et583 : t583 = s7)
    (et628 : t628 = s19) (et701 : t701 = carry6) (et747 : t747 = carry7) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et613 : t613 = s15) (et640 : t640 = s22) (et737 : t737 = carry14) (et760 : t760 = carry13)
    (et636 : t636 = s21) (et610 : t610 = s14) (et854 : t854 = carry6_1) (et882 : t882 = carry7_1)
    (et942 : t942 = carry7_2) (et1001 : t1001 = carry7_3) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hs7_12 : s7_12 = s7_11 - carry7_2 <<< 21)
    (hs7_13 : s7_13 = s7_12 + carry6_3) (hs7_14 : s7_14 = s7_13 - carry7_3 <<< 21) :
    t1004 = s7_14 := by
  subst_vars
  grind

/-- `carry8_3` as the C computes it is the compiled `%1005`. -/
theorem x25519_sc_reduce.bridge_carry8_3
    (t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691 t714 t715 t738 t743 t744 t745 t748
      t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883 t943 t948 t949 t1002 t1005 t1001
      t624 t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613 t640 t737 t859 t882 t942 t946
      s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9
      s8_10 s8_11 s8_12 s8_13 carry8_3 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16
      carry7 carry15 carry8_1 carry7_1 carry7_2 carry8_2 carry7_3 : BitVec 64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht668 : t668 = t632 * 666643#64) (ht675 : t675 = t628 * 470296#64)
    (ht688 : t688 = t624 * 654183#64) (ht689 : t689 = t688 + t586) (ht690 : t690 = t689 + t675)
    (ht691 : t691 = t690 + t668) (ht714 : t714 = t708 <<< 21) (ht715 : t715 = t691 - t714)
    (ht738 : t738 = t658 + t737) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht748 : t748 = t715 + t747) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht775 : t775 = t743 * 18446744073708553811#64) (ht776 : t776 = t748 + t775)
    (ht789 : t789 = t766 * 136657#64) (ht790 : t790 = t776 + t789)
    (ht798 : t798 = t768 * 18446744073708867715#64) (ht799 : t799 = t790 + t798)
    (ht864 : t864 = t859 <<< 21) (ht865 : t865 = t799 - t864) (ht883 : t883 = t865 + t882)
    (ht943 : t943 = t883 + t942) (ht948 : t948 = t946 <<< 21) (ht949 : t949 = t943 - t948)
    (ht1002 : t1002 = t1001 + t949) (ht1005 : t1005 = t1002.sshiftRight 21)
    (et1001 : t1001 = carry7_3) (et624 : t624 = s18) (et586 : t586 = s8) (et628 : t628 = s19)
    (et632 : t632 = s20) (et708 : t708 = carry8) (et747 : t747 = carry7) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et613 : t613 = s15) (et640 : t640 = s22) (et737 : t737 = carry14) (et859 : t859 = carry8_1)
    (et882 : t882 = carry7_1) (et942 : t942 = carry7_2) (et946 : t946 = carry8_2)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs8_1 : s8_1 = s8 + s20 * 666643#64)
    (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) (hs8_3 : s8_3 = s8_2 + s18 * 654183#64)
    (hs8_4 : s8_4 = s8_3 - carry8 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs8_5 : s8_5 = s8_4 + carry7) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64)
    (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64) (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64)
    (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21) (hs8_10 : s8_10 = s8_9 + carry7_1)
    (hs8_11 : s8_11 = s8_10 + carry7_2) (hs8_12 : s8_12 = s8_11 - carry8_2 <<< 21)
    (hs8_13 : s8_13 = s8_12 + carry7_3) (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) :
    t1005 = carry8_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s8_14` as the C computes it is the compiled `%1008`. -/
theorem x25519_sc_reduce.bridge_s8_14
    (t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691 t714 t715 t738 t743 t744 t745 t748
      t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883 t943 t948 t949 t1002 t1007 t1008
      t1001 t624 t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613 t640 t737 t859 t882 t942
      t946 t1005 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7
      s8_8 s8_9 s8_10 s8_11 s8_12 s8_13 s8_14 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14
      carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 carry8_2 carry7_3 carry8_3 : BitVec 64)
    (ht648 : t648 = t643 * 136657#64) (ht649 : t649 = t648 + t613)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht657 : t657 = t640 * 18446744073708867715#64) (ht658 : t658 = t649 + t657)
    (ht668 : t668 = t632 * 666643#64) (ht675 : t675 = t628 * 470296#64)
    (ht688 : t688 = t624 * 654183#64) (ht689 : t689 = t688 + t586) (ht690 : t690 = t689 + t675)
    (ht691 : t691 = t690 + t668) (ht714 : t714 = t708 <<< 21) (ht715 : t715 = t691 - t714)
    (ht738 : t738 = t658 + t737) (ht743 : t743 = t742 + t620) (ht744 : t744 = t742 <<< 21)
    (ht745 : t745 = t651 - t744) (ht748 : t748 = t715 + t747) (ht766 : t766 = t765 + t745)
    (ht767 : t767 = t765 <<< 21) (ht768 : t768 = t738 - t767)
    (ht775 : t775 = t743 * 18446744073708553811#64) (ht776 : t776 = t748 + t775)
    (ht789 : t789 = t766 * 136657#64) (ht790 : t790 = t776 + t789)
    (ht798 : t798 = t768 * 18446744073708867715#64) (ht799 : t799 = t790 + t798)
    (ht864 : t864 = t859 <<< 21) (ht865 : t865 = t799 - t864) (ht883 : t883 = t865 + t882)
    (ht943 : t943 = t883 + t942) (ht948 : t948 = t946 <<< 21) (ht949 : t949 = t943 - t948)
    (ht1002 : t1002 = t1001 + t949) (ht1007 : t1007 = t1005 <<< 21) (ht1008 : t1008 = t1002 - t1007)
    (et1001 : t1001 = carry7_3) (et624 : t624 = s18) (et586 : t586 = s8) (et628 : t628 = s19)
    (et632 : t632 = s20) (et708 : t708 = carry8) (et747 : t747 = carry7) (et742 : t742 = carry16)
    (et620 : t620 = s17) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et613 : t613 = s15) (et640 : t640 = s22) (et737 : t737 = carry14) (et859 : t859 = carry8_1)
    (et882 : t882 = carry7_1) (et942 : t942 = carry7_2) (et946 : t946 = carry8_2)
    (et1005 : t1005 = carry8_3) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) (hs8_4 : s8_4 = s8_3 - carry8 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs8_5 : s8_5 = s8_4 + carry7)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64) (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64)
    (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21)
    (hs8_10 : s8_10 = s8_9 + carry7_1) (hs8_11 : s8_11 = s8_10 + carry7_2)
    (hs8_12 : s8_12 = s8_11 - carry8_2 <<< 21) (hs8_13 : s8_13 = s8_12 + carry7_3)
    (hs8_14 : s8_14 = s8_13 - carry8_3 <<< 21) : t1008 = s8_14 := by
  subst_vars
  grind

/-- `carry9_3` as the C computes it is the compiled `%1009`. -/
theorem x25519_sc_reduce.bridge_carry9_3
    (t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743 t744 t745 t753 t766 t777 t791 t860
      t861 t862 t863 t889 t890 t947 t952 t953 t1006 t1009 t1005 t946 t742 t620 t624 t590 t628 t632
      t636 t708 t752 t765 t643 t616 t859 t887 t950 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6
      s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 carry9_3 s9 s16 s17 s18 s19 s20 s21 s23 carry8
      carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 carry9_2 carry8_3 : BitVec 64)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht659 : t659 = t636 * 666643#64) (ht669 : t669 = t632 * 470296#64)
    (ht676 : t676 = t628 * 654183#64) (ht692 : t692 = t624 * 18446744073708553811#64)
    (ht709 : t709 = t692 + t590) (ht710 : t710 = t709 + t676) (ht711 : t711 = t710 + t669)
    (ht712 : t712 = t711 + t659) (ht713 : t713 = t712 + t708) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht753 : t753 = t752 <<< 21)
    (ht766 : t766 = t765 + t745) (ht777 : t777 = t743 * 136657#64)
    (ht791 : t791 = t766 * 18446744073708867715#64) (ht860 : t860 = t777 + t713)
    (ht861 : t861 = t860 - t753) (ht862 : t862 = t861 + t791) (ht863 : t863 = t862 + t859)
    (ht889 : t889 = t887 <<< 21) (ht890 : t890 = t863 - t889) (ht947 : t947 = t946 + t890)
    (ht952 : t952 = t950 <<< 21) (ht953 : t953 = t947 - t952) (ht1006 : t1006 = t1005 + t953)
    (ht1009 : t1009 = t1006.sshiftRight 21) (et1005 : t1005 = carry8_3) (et946 : t946 = carry8_2)
    (et742 : t742 = carry16) (et620 : t620 = s17) (et624 : t624 = s18) (et590 : t590 = s9)
    (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21) (et708 : t708 = carry8)
    (et752 : t752 = carry9) (et765 : t765 = carry15) (et643 : t643 = s23) (et616 : t616 = s16)
    (et859 : t859 = carry8_1) (et887 : t887 = carry9_1) (et950 : t950 = carry9_2)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs9_1 : s9_1 = s9 + s21 * 666643#64)
    (hs9_2 : s9_2 = s9_1 + s20 * 470296#64) (hs9_3 : s9_3 = s9_2 + s19 * 654183#64)
    (hs9_4 : s9_4 = s9_3 - s18 * 997805#64) (hs9_5 : s9_5 = s9_4 + carry8)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs9_6 : s9_6 = s9_5 - carry9 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64) (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64)
    (hs9_9 : s9_9 = s9_8 + carry8_1) (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21)
    (hs9_11 : s9_11 = s9_10 + carry8_2) (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21)
    (hs9_13 : s9_13 = s9_12 + carry8_3) (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) :
    t1009 = carry9_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s9_14` as the C computes it is the compiled `%1012`. -/
theorem x25519_sc_reduce.bridge_s9_14
    (t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743 t744 t745 t753 t766 t777 t791 t860
      t861 t862 t863 t889 t890 t947 t952 t953 t1006 t1011 t1012 t1005 t946 t742 t620 t624 t590 t628
      t632 t636 t708 t752 t765 t643 t616 t859 t887 t950 t1009 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1
      s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 s9_14 s9 s16 s17 s18 s19 s20 s21 s23
      carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 carry9_2 carry8_3 carry9_3 :
      BitVec 64)
    (ht650 : t650 = t643 * 18446744073708867715#64) (ht651 : t651 = t650 + t616)
    (ht659 : t659 = t636 * 666643#64) (ht669 : t669 = t632 * 470296#64)
    (ht676 : t676 = t628 * 654183#64) (ht692 : t692 = t624 * 18446744073708553811#64)
    (ht709 : t709 = t692 + t590) (ht710 : t710 = t709 + t676) (ht711 : t711 = t710 + t669)
    (ht712 : t712 = t711 + t659) (ht713 : t713 = t712 + t708) (ht743 : t743 = t742 + t620)
    (ht744 : t744 = t742 <<< 21) (ht745 : t745 = t651 - t744) (ht753 : t753 = t752 <<< 21)
    (ht766 : t766 = t765 + t745) (ht777 : t777 = t743 * 136657#64)
    (ht791 : t791 = t766 * 18446744073708867715#64) (ht860 : t860 = t777 + t713)
    (ht861 : t861 = t860 - t753) (ht862 : t862 = t861 + t791) (ht863 : t863 = t862 + t859)
    (ht889 : t889 = t887 <<< 21) (ht890 : t890 = t863 - t889) (ht947 : t947 = t946 + t890)
    (ht952 : t952 = t950 <<< 21) (ht953 : t953 = t947 - t952) (ht1006 : t1006 = t1005 + t953)
    (ht1011 : t1011 = t1009 <<< 21) (ht1012 : t1012 = t1006 - t1011) (et1005 : t1005 = carry8_3)
    (et946 : t946 = carry8_2) (et742 : t742 = carry16) (et620 : t620 = s17) (et624 : t624 = s18)
    (et590 : t590 = s9) (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21)
    (et708 : t708 = carry8) (et752 : t752 = carry9) (et765 : t765 = carry15) (et643 : t643 = s23)
    (et616 : t616 = s16) (et859 : t859 = carry8_1) (et887 : t887 = carry9_1)
    (et950 : t950 = carry9_2) (et1009 : t1009 = carry9_3) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21) (hs9_13 : s9_13 = s9_12 + carry8_3)
    (hs9_14 : s9_14 = s9_13 - carry9_3 <<< 21) : t1012 = s9_14 := by
  subst_vars
  grind

/-- `carry10_3` as the C computes it is the compiled `%1013`. -/
theorem x25519_sc_reduce.bridge_carry10_3
    (t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726 t743 t778 t779 t780 t869 t870 t888
      t951 t956 t957 t1010 t1013 t1009 t624 t594 t628 t632 t636 t640 t717 t742 t620 t752 t867 t887
      t950 t954 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 s10_12
      s10_13 carry10_3 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1
      carry9_2 carry10_2 carry9_3 : BitVec 64)
    (ht652 : t652 = t640 * 666643#64) (ht660 : t660 = t636 * 470296#64)
    (ht670 : t670 = t632 * 654183#64) (ht677 : t677 = t628 * 18446744073708553811#64)
    (ht693 : t693 = t624 * 136657#64) (ht694 : t694 = t693 + t594) (ht695 : t695 = t694 + t677)
    (ht696 : t696 = t695 + t670) (ht697 : t697 = t696 + t660) (ht698 : t698 = t697 + t652)
    (ht725 : t725 = t717 <<< 21) (ht726 : t726 = t698 - t725) (ht743 : t743 = t742 + t620)
    (ht778 : t778 = t743 * 18446744073708867715#64) (ht779 : t779 = t726 + t778)
    (ht780 : t780 = t779 + t752) (ht869 : t869 = t867 <<< 21) (ht870 : t870 = t780 - t869)
    (ht888 : t888 = t870 + t887) (ht951 : t951 = t888 + t950) (ht956 : t956 = t954 <<< 21)
    (ht957 : t957 = t951 - t956) (ht1010 : t1010 = t1009 + t957)
    (ht1013 : t1013 = t1010.sshiftRight 21) (et1009 : t1009 = carry9_3) (et624 : t624 = s18)
    (et594 : t594 = s10) (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21)
    (et640 : t640 = s22) (et717 : t717 = carry10) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et752 : t752 = carry9) (et867 : t867 = carry10_1) (et887 : t887 = carry9_1)
    (et950 : t950 = carry9_2) (et954 : t954 = carry10_2) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hs10_6 : s10_6 = s10_5 - carry10 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs10_7 : s10_7 = s10_6 + carry9) (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64)
    (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21) (hs10_10 : s10_10 = s10_9 + carry9_1)
    (hs10_11 : s10_11 = s10_10 + carry9_2) (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21)
    (hs10_13 : s10_13 = s10_12 + carry9_3) (hcarry10_3 : carry10_3 = s10_13.sshiftRight 21) :
    t1013 = carry10_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s11_13` as the C computes it is the compiled `%1014`. -/
theorem x25519_sc_reduce.bridge_s11_13
    (t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724 t757 t758 t868 t893 t894 t955
      t959 t960 t1014 t1013 t954 t867 t624 t598 t628 t632 t636 t643 t640 t717 t755 t892 t958 s11_1
      s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 s11_10 s11_11 s11_12 s11_13 s11 s18 s19 s20
      s21 s22 s23 carry10 carry11 carry10_1 carry11_1 carry10_2 carry11_2 carry10_3 : BitVec 64)
    (ht644 : t644 = t643 * 666643#64) (ht653 : t653 = t640 * 470296#64)
    (ht661 : t661 = t636 * 654183#64) (ht671 : t671 = t632 * 18446744073708553811#64)
    (ht678 : t678 = t628 * 136657#64) (ht699 : t699 = t624 * 18446744073708867715#64)
    (ht718 : t718 = t699 + t598) (ht719 : t719 = t718 + t678) (ht720 : t720 = t719 + t671)
    (ht721 : t721 = t720 + t661) (ht722 : t722 = t721 + t644) (ht723 : t723 = t722 + t653)
    (ht724 : t724 = t723 + t717) (ht757 : t757 = t755 <<< 21) (ht758 : t758 = t724 - t757)
    (ht868 : t868 = t867 + t758) (ht893 : t893 = t892 <<< 21) (ht894 : t894 = t868 - t893)
    (ht955 : t955 = t954 + t894) (ht959 : t959 = t958 <<< 21) (ht960 : t960 = t955 - t959)
    (ht1014 : t1014 = t1013 + t960) (et1013 : t1013 = carry10_3) (et954 : t954 = carry10_2)
    (et867 : t867 = carry10_1) (et624 : t624 = s18) (et598 : t598 = s11) (et628 : t628 = s19)
    (et632 : t632 = s20) (et636 : t636 = s21) (et643 : t643 = s23) (et640 : t640 = s22)
    (et717 : t717 = carry10) (et755 : t755 = carry11) (et892 : t892 = carry11_1)
    (et958 : t958 = carry11_2) (hs11_1 : s11_1 = s11 + s23 * 666643#64)
    (hs11_2 : s11_2 = s11_1 + s22 * 470296#64) (hs11_3 : s11_3 = s11_2 + s21 * 654183#64)
    (hs11_4 : s11_4 = s11_3 - s20 * 997805#64) (hs11_5 : s11_5 = s11_4 + s19 * 136657#64)
    (hs11_6 : s11_6 = s11_5 - s18 * 683901#64) (hs11_7 : s11_7 = s11_6 + carry10)
    (hs11_8 : s11_8 = s11_7 - carry11 <<< 21) (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hs11_10 : s11_10 = s11_9 - carry11_1 <<< 21) (hs11_11 : s11_11 = s11_10 + carry10_2)
    (hs11_12 : s11_12 = s11_11 - carry11_2 <<< 21) (hs11_13 : s11_13 = s11_12 + carry10_3) :
    t1014 = s11_13 := by
  subst_vars
  grind

/-- `s10_14` as the C computes it is the compiled `%1016`. -/
theorem x25519_sc_reduce.bridge_s10_14
    (t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726 t743 t778 t779 t780 t869 t870 t888
      t951 t956 t957 t1010 t1015 t1016 t1009 t624 t594 t628 t632 t636 t640 t717 t742 t620 t752 t867
      t887 t950 t954 t1013 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11
      s10_12 s10_13 s10_14 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1
      carry9_2 carry10_2 carry9_3 carry10_3 : BitVec 64)
    (ht652 : t652 = t640 * 666643#64) (ht660 : t660 = t636 * 470296#64)
    (ht670 : t670 = t632 * 654183#64) (ht677 : t677 = t628 * 18446744073708553811#64)
    (ht693 : t693 = t624 * 136657#64) (ht694 : t694 = t693 + t594) (ht695 : t695 = t694 + t677)
    (ht696 : t696 = t695 + t670) (ht697 : t697 = t696 + t660) (ht698 : t698 = t697 + t652)
    (ht725 : t725 = t717 <<< 21) (ht726 : t726 = t698 - t725) (ht743 : t743 = t742 + t620)
    (ht778 : t778 = t743 * 18446744073708867715#64) (ht779 : t779 = t726 + t778)
    (ht780 : t780 = t779 + t752) (ht869 : t869 = t867 <<< 21) (ht870 : t870 = t780 - t869)
    (ht888 : t888 = t870 + t887) (ht951 : t951 = t888 + t950) (ht956 : t956 = t954 <<< 21)
    (ht957 : t957 = t951 - t956) (ht1010 : t1010 = t1009 + t957) (ht1015 : t1015 = t1013 <<< 21)
    (ht1016 : t1016 = t1010 - t1015) (et1009 : t1009 = carry9_3) (et624 : t624 = s18)
    (et594 : t594 = s10) (et628 : t628 = s19) (et632 : t632 = s20) (et636 : t636 = s21)
    (et640 : t640 = s22) (et717 : t717 = carry10) (et742 : t742 = carry16) (et620 : t620 = s17)
    (et752 : t752 = carry9) (et867 : t867 = carry10_1) (et887 : t887 = carry9_1)
    (et950 : t950 = carry9_2) (et954 : t954 = carry10_2) (et1013 : t1013 = carry10_3)
    (hs10_1 : s10_1 = s10 + s22 * 666643#64) (hs10_2 : s10_2 = s10_1 + s21 * 470296#64)
    (hs10_3 : s10_3 = s10_2 + s20 * 654183#64) (hs10_4 : s10_4 = s10_3 - s19 * 997805#64)
    (hs10_5 : s10_5 = s10_4 + s18 * 136657#64) (hs10_6 : s10_6 = s10_5 - carry10 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs10_7 : s10_7 = s10_6 + carry9)
    (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64) (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21)
    (hs10_10 : s10_10 = s10_9 + carry9_1) (hs10_11 : s10_11 = s10_10 + carry9_2)
    (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21) (hs10_13 : s10_13 = s10_12 + carry9_3)
    (hs10_14 : s10_14 = s10_13 - carry10_3 <<< 21) : t1016 = s10_14 := by
  subst_vars
  grind

theorem x25519_sc_reduce.out_eq
    {t976 t980 t984 t988 t992 t996 t1000 t1004 t1008 t1012 t1016 t1014 s0_6 s1_10 s2_11 s3_12 s4_13
      s5_14 s6_13 s7_14 s8_14 s9_14 s10_14 s11_13 : BitVec 64}
    (e0 : t976 = s0_6) (e1 : t980 = s1_10) (e2 : t984 = s2_11) (e3 : t988 = s3_12)
    (e4 : t992 = s4_13) (e5 : t996 = s5_14) (e6 : t1000 = s6_13) (e7 : t1004 = s7_14)
    (e8 : t1008 = s8_14) (e9 : t1012 = s9_14) (e10 : t1016 = s10_14) (e11 : t1014 = s11_13) :
    x25519_sc_reduce.out t976 t980 t984 t988 t992 t996 t1000 t1004 t1008 t1012 t1016 t1014 =
      (s11_13.sshiftRight 17).setWidth 8 ++ (s11_13.sshiftRight 9).setWidth 8 ++
        (s11_13.sshiftRight 1).setWidth 8 ++
        (s10_14.sshiftRight 14 ||| s11_13 <<< 7).setWidth 8 ++
        (s10_14.sshiftRight 6).setWidth 8 ++
        (s9_14.sshiftRight 19 ||| s10_14 <<< 2).setWidth 8 ++
        (s9_14.sshiftRight 11).setWidth 8 ++
        (s9_14.sshiftRight 3).setWidth 8 ++
        (s8_14.sshiftRight 16 ||| s9_14 <<< 5).setWidth 8 ++
        (s8_14.sshiftRight 8).setWidth 8 ++
        s8_14.setWidth 8 ++
        (s7_14.sshiftRight 13).setWidth 8 ++
        (s7_14.sshiftRight 5).setWidth 8 ++
        (s6_13.sshiftRight 18 ||| s7_14 <<< 3).setWidth 8 ++
        (s6_13.sshiftRight 10).setWidth 8 ++
        (s6_13.sshiftRight 2).setWidth 8 ++
        (s5_14.sshiftRight 15 ||| s6_13 <<< 6).setWidth 8 ++
        (s5_14.sshiftRight 7).setWidth 8 ++
        (s4_13.sshiftRight 20 ||| s5_14 <<< 1).setWidth 8 ++
        (s4_13.sshiftRight 12).setWidth 8 ++
        (s4_13.sshiftRight 4).setWidth 8 ++
        (s3_12.sshiftRight 17 ||| s4_13 <<< 4).setWidth 8 ++
        (s3_12.sshiftRight 9).setWidth 8 ++
        (s3_12.sshiftRight 1).setWidth 8 ++
        (s2_11.sshiftRight 14 ||| s3_12 <<< 7).setWidth 8 ++
        (s2_11.sshiftRight 6).setWidth 8 ++
        (s1_10.sshiftRight 19 ||| s2_11 <<< 2).setWidth 8 ++
        (s1_10.sshiftRight 11).setWidth 8 ++
        (s1_10.sshiftRight 3).setWidth 8 ++
        (s0_6.sshiftRight 16 ||| s1_10 <<< 5).setWidth 8 ++
        (s0_6.sshiftRight 8).setWidth 8 ++
        s0_6.setWidth 8 := by
  subst_vars
  unfold x25519_sc_reduce.out
  bv_decide

theorem x25519_sc_reduce.ir_eq_spec (x : BitVec 512) :
    x25519_sc_reduce.ir x = x25519_sc_reduce.spec x := by
  unfold x25519_sc_reduce.ir x25519_sc_reduce.spec
  lift_lets -merge
  intro t555 t556 t558 t559 t560 t562 t563 t564 t566 t567 t568 t570 t571 t572 t574 t575 t576 t578
    t579 t580 t582 t583 t585 t586 t588 t589 t590 t592 t593 t594 t596 t597 t598 t600 t601 t602 t604
    t605 t606 t608 t609 t610 t612 t613 t615 t616 t618 t619 t620 t622 t623 t624 t626 t627 t628 t630
    t631 t632 t634 t635 t636 t638 t639 t640 t642 t643 t644 t645 t646 t647 t648 t649 t650 t651 t652
    t653 t654 t655 t656 t657 t658 t659 t660 t661 t662 t663 t664 t665 t666 t667 t668 t669 t670 t671
    t672 t673 t674 t675 t676 t677 t678 t679 t680 t681 t682 t683 t684 t685 t686 t687 t688 t689 t690
    t691 t692 t693 t694 t695 t696 t697 t698 t699 t700 t701 t702 t703 t704 t705 t706 t707 t708 t709
    t710 t711 t712 t713 t714 t715 t716 t717 t718 t719 t720 t721 t722 t723 t724 t725 t726 t727 t728
    t729 t730 t731 t732 t733 t734 t735 t736 t737 t738 t739 t740 t741 t742 t743 t744 t745 t746 t747
    t748 t749 t750 t751 t752 t753 t754 t755 t756 t757 t758 t759 t760 t761 t762 t763 t764 t765 t766
    t767 t768 t769 t770 t771 t772 t773 t774 t775 t776 t777 t778 t779 t780 t781 t782 t783 t784 t785
    t786 t787 t788 t789 t790 t791 t792 t793 t794 t795 t796 t797 t798 t799 t800 t801 t802 t803 t804
    t805 t806 t807 t808 t809 t810 t811 t812 t813 t814 t815 t816 t817 t818 t819 t820 t821 t822 t823
    t824 t825 t826 t827 t828 t829 t830 t831 t832 t833 t834 t835 t836 t837 t838 t839 t840 t841 t842
    t843 t844 t845 t846 t847 t848 t849 t850 t851 t852 t853 t854 t855 t856 t857 t858 t859 t860 t861
    t862 t863 t864 t865 t866 t867 t868 t869 t870 t871 t872 t873 t874 t875 t876 t877 t878 t879 t880
    t881 t882 t883 t884 t885 t886 t887 t888 t889 t890 t891 t892 t893 t894 t895 t896 t897 t898 t899
    t900 t901 t902 t903 t904 t905 t906 t907 t908 t909 t910 t911 t912 t913 t914 t915 t916 t917 t918
    t919 t920 t921 t922 t923 t924 t925 t926 t927 t928 t929 t930 t931 t932 t933 t934 t935 t936 t937
    t938 t939 t940 t941 t942 t943 t944 t945 t946 t947 t948 t949 t950 t951 t952 t953 t954 t955 t956
    t957 t958 t959 t960 t961 t962 t963 t964 t965 t966 t967 t968 t969 t970 t971 t972 t973 t974 t975
    t976 t977 t978 t979 t980 t981 t982 t983 t984 t985 t986 t987 t988 t989 t990 t991 t992 t993 t994
    t995 t996 t997 t998 t999 t1000 t1001 t1002 t1003 t1004 t1005 t1006 t1007 t1008 t1009 t1010 t1011
    t1012 t1013 t1014 t1015 t1016 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18
    s19 s20 s21 s22 s23 s11_1 s12_1 s13_1 s14_1 s15_1 s16_1 s10_1 s11_2 s12_2 s13_2 s14_2 s15_2 s9_1
    s10_2 s11_3 s12_3 s13_3 s14_3 s8_1 s9_2 s10_3 s11_4 s12_4 s13_4 s7_1 s8_2 s9_3 s10_4 s11_5 s12_5
    s6_1 s7_2 s8_3 s9_4 s10_5 s11_6 carry6 s7_3 s6_2 carry8 s9_5 s8_4 carry10 s11_7 s10_6 carry12
    s13_5 s12_6 carry14 s15_3 s14_4 carry16 s17_1 s16_2 carry7 s8_5 s7_4 carry9 s10_7 s9_6 carry11
    s12_7 s11_8 carry13 s14_5 s13_6 carry15 s16_3 s15_4 s5_1 s6_3 s7_5 s8_6 s9_7 s10_8 s4_1 s5_2
    s6_4 s7_6 s8_7 s9_8 s3_1 s4_2 s5_3 s6_5 s7_7 s8_8 s2_1 s3_2 s4_3 s5_4 s6_6 s7_8 s1_1 s2_2 s3_3
    s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4 s4_5 s5_6 s12_8 carry0 s1_3 s0_2 carry2 s3_5 s2_4 carry4 s5_7
    s4_6 carry6_1 s7_9 s6_8 carry8_1 s9_9 s8_9 carry10_1 s11_9 s10_9 carry1 s2_5 s1_4 carry3 s4_7
    s3_6 carry5 s6_9 s5_8 carry7_1 s8_10 s7_10 carry9_1 s10_10 s9_10 carry11_1 s12_9 s11_10 s0_3
    s1_5 s2_6 s3_7 s4_8 s5_9 s12_10 carry0_1 s1_6 s0_4 carry1_1 s2_7 s1_7 carry2_1 s3_8 s2_8
    carry3_1 s4_9 s3_9 carry4_1 s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11
    s7_12 carry8_2 s9_11 s8_12 carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s12_11 s11_12
    s0_5 s1_8 s2_9 s3_10 s4_11 s5_12 carry0_2 s1_9 s0_6 carry1_2 s2_10 s1_10 carry2_2 s3_11 s2_11
    carry3_2 s4_12 s3_12 carry4_2 s5_13 s4_13 carry5_2 s6_12 s5_14 carry6_3 s7_13 s6_13 carry7_3
    s8_13 s7_14 carry8_3 s9_13 s8_14 carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14 b0 b1 b2 b3 b4 b5
    b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30
    b31
  have e556 : t556 = s0 := BitVec.and_comm _ _
  have e560 : t560 = s1 := BitVec.and_comm _ _
  have e564 : t564 = s2 := BitVec.and_comm _ _
  have e568 : t568 = s3 := BitVec.and_comm _ _
  have e572 : t572 = s4 := BitVec.and_comm _ _
  have e576 : t576 = s5 := BitVec.and_comm _ _
  have e580 : t580 = s6 := BitVec.and_comm _ _
  have e583 : t583 = s7 := nomask3_3 _
  have e586 : t586 = s8 := BitVec.and_comm _ _
  have e590 : t590 = s9 := BitVec.and_comm _ _
  have e594 : t594 = s10 := BitVec.and_comm _ _
  have e598 : t598 = s11 := BitVec.and_comm _ _
  have e602 : t602 = s12 := BitVec.and_comm _ _
  have e606 : t606 = s13 := BitVec.and_comm _ _
  have e610 : t610 = s14 := BitVec.and_comm _ _
  have e613 : t613 = s15 := nomask3_3 _
  have e616 : t616 = s16 := BitVec.and_comm _ _
  have e620 : t620 = s17 := BitVec.and_comm _ _
  have e624 : t624 = s18 := BitVec.and_comm _ _
  have e628 : t628 = s19 := BitVec.and_comm _ _
  have e632 : t632 = s20 := BitVec.and_comm _ _
  have e636 : t636 = s21 := BitVec.and_comm _ _
  have e640 : t640 = s22 := BitVec.and_comm _ _
  have e643 : t643 = s23 := rfl
  have n701 : t701 = t700.sshiftRight 21 := x25519_sc_reduce.lshr701 x
  have e701 :=
    x25519_sc_reduce.bridge_carry6 t685 t686 t700 t701 t624 t580 s6_1 carry6 s6 s18 rfl rfl rfl n701
      e624 e580 rfl rfl
  have n708 : t708 = t707.sshiftRight 21 := x25519_sc_reduce.lshr708 x
  have e708 :=
    x25519_sc_reduce.bridge_carry8 t668 t675 t688 t689 t690 t691 t707 t708 t624 t586 t628 t632 s8_1
      s8_2 s8_3 carry8 s8 s18 s19 s20 rfl rfl rfl rfl rfl rfl rfl n708 e624 e586 e628 e632 rfl rfl
      rfl rfl
  have e717 :=
    x25519_sc_reduce.bridge_carry10 t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t716 t717 t624
      t594 t628 t632 t636 t640 s10_1 s10_2 s10_3 s10_4 s10_5 carry10 s10 s18 s19 s20 s21 s22 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e594 e628 e632 e636 e640 rfl rfl rfl rfl rfl rfl
  have e728 :=
    x25519_sc_reduce.bridge_carry12 t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t727 t728 t628
      t602 t632 t636 t643 t640 s12_1 s12_2 s12_3 s12_4 s12_5 carry12 s12 s19 s20 s21 s22 s23 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e628 e602 e632 e636 e643 e640 rfl rfl rfl rfl rfl rfl
  have e737 :=
    x25519_sc_reduce.bridge_carry14 t647 t656 t664 t665 t666 t667 t736 t737 t636 t610 t643 t640
      s14_1 s14_2 s14_3 carry14 s14 s21 s22 s23 rfl rfl rfl rfl rfl rfl rfl rfl e636 e610 e643 e640
      rfl rfl rfl rfl
  have e742 :=
    x25519_sc_reduce.bridge_carry16 t650 t651 t741 t742 t643 t616 s16_1 carry16 s16 s23 rfl rfl rfl
      rfl e643 e616 rfl rfl
  have n747 : t747 = t746.sshiftRight 21 := x25519_sc_reduce.lshr747 x
  have e747 :=
    x25519_sc_reduce.bridge_carry7 t674 t687 t702 t703 t704 t746 t747 t624 t583 t628 t701 s7_1 s7_2
      s7_3 carry7 s7 s18 s19 carry6 rfl rfl rfl rfl rfl rfl n747 e624 e583 e628 e701 rfl rfl rfl rfl
  have e752 :=
    x25519_sc_reduce.bridge_carry9 t659 t669 t676 t692 t709 t710 t711 t712 t713 t751 t752 t624 t590
      t628 t632 t636 t708 s9_1 s9_2 s9_3 s9_4 s9_5 carry9 s9 s18 s19 s20 s21 carry8 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl e624 e590 e628 e632 e636 e708 rfl rfl rfl rfl rfl rfl
  have e755 :=
    x25519_sc_reduce.bridge_carry11 t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724
      t754 t755 t624 t598 t628 t632 t636 t643 t640 t717 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7
      carry11 s11 s18 s19 s20 s21 s22 s23 carry10 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl e624 e598 e628 e632 e636 e643 e640 e717 rfl rfl rfl rfl rfl rfl rfl rfl
  have e760 :=
    x25519_sc_reduce.bridge_carry13 t646 t655 t663 t673 t729 t730 t731 t732 t733 t759 t760 t632 t606
      t636 t643 t640 t728 s13_1 s13_2 s13_3 s13_4 s13_5 carry13 s13 s20 s21 s22 s23 carry12 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl e632 e606 e636 e643 e640 e728 rfl rfl rfl rfl rfl rfl
  have e765 :=
    x25519_sc_reduce.bridge_carry15 t648 t649 t657 t658 t738 t764 t765 t643 t613 t640 t737 s15_1
      s15_2 s15_3 carry15 s15 s22 s23 carry14 rfl rfl rfl rfl rfl rfl rfl e643 e613 e640 e737 rfl
      rfl rfl rfl
  have e833 :=
    x25519_sc_reduce.bridge_carry0 t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756
      t817 t818 t832 t833 t755 t628 t602 t632 t636 t643 t640 t728 t556 s12_1 s12_2 s12_3 s12_4 s12_5
      s12_6 s12_7 s0_1 carry0 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e755 e628 e602 e632 e636 e643 e640 e728 e556 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e838 :=
    x25519_sc_reduce.bridge_carry2 t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762
      t763 t800 t809 t821 t822 t823 t824 t837 t838 t632 t606 t636 t643 t640 t728 t760 t564 t610 t737
      t755 t628 t602 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 carry2 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12
      carry14 carry11 carry13 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl e632 e606 e636 e643 e640 e728 e760 e564 e610 e737 e755 e628 e602 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e846 :=
    x25519_sc_reduce.bridge_carry4 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662
      t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734
      t735 t738 t739 t740 t744 t745 t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826
      t827 t828 t829 t830 t845 t846 t765 t643 t616 t742 t572 t632 t606 t636 t640 t728 t760 t613 t737
      t610 t755 t628 t602 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3
      s4_4 s4_5 carry4 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11
      carry13 carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e765 e643 e616 e742 e572 e632 e606
      e636 e640 e728 e760 e613 e737 e610 e755 e628 e602 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e854 :=
    x25519_sc_reduce.bridge_carry6_1 t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664
      t665 t666 t667 t673 t685 t686 t705 t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745
      t761 t762 t763 t766 t767 t768 t771 t772 t785 t786 t795 t804 t813 t814 t815 t816 t853 t854 t624
      t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 s13_1 s14_1
      s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5
      s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 carry6_1 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23
      carry6 carry12 carry14 carry16 carry13 carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e580 e701 e742 e620 e765 e643
      e616 e632 e606 e636 e640 e728 e760 e613 e737 e610 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e859 :=
    x25519_sc_reduce.bridge_carry8_1 t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691
      t714 t715 t738 t743 t744 t745 t748 t766 t767 t768 t775 t776 t789 t790 t798 t799 t858 t859 t624
      t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613 t640 t737 s15_1 s16_1 s15_2 s8_1 s8_2
      s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 carry8_1 s8 s15 s16 s17 s18 s19
      s20 s22 s23 carry8 carry14 carry16 carry7 carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e586 e628
      e632 e708 e747 e742 e620 e765 e643 e616 e613 e640 e737 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e867 :=
    x25519_sc_reduce.bridge_carry10_1 t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726
      t743 t778 t779 t780 t866 t867 t624 t594 t628 t632 t636 t640 t717 t742 t620 t752 s10_1 s10_2
      s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 carry10_1 s10 s17 s18 s19 s20 s21 s22 carry10
      carry16 carry9 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624
      e594 e628 e632 e636 e640 e717 e742 e620 e752 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e872 :=
    x25519_sc_reduce.bridge_carry1 t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t871 t872 t632
      t606 t636 t643 t640 t728 t760 t560 t755 t628 t602 t833 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s1_3 carry1 s1 s12 s13 s19 s20 s21 s22 s23
      carry12 carry11 carry13 carry0 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e632 e606 e636 e643 e640 e728 e760
      e560 e755 e628 e602 e833 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e875 :=
    x25519_sc_reduce.bridge_carry3 t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664
      t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738
      t739 t740 t756 t761 t762 t763 t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t874 t875
      t632 t606 t636 t643 t640 t728 t760 t568 t613 t737 t765 t610 t755 t628 t602 t838 s12_1 s13_1
      s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3
      s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s3_5 carry3 s3 s12 s13 s14 s15 s19 s20 s21
      s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e632 e606 e636 e643
      e640 e728 e760 e568 e613 e737 e765 e610 e755 e628 e602 e838 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e878 :=
    x25519_sc_reduce.bridge_carry5 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662
      t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734
      t735 t738 t739 t740 t743 t744 t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794
      t803 t812 t831 t847 t848 t849 t850 t851 t877 t878 t742 t620 t576 t765 t643 t616 t632 t606 t636
      t640 t728 t760 t613 t737 t610 t755 t628 t602 t846 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2
      s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7
      s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s5_7 carry5 s5 s12 s13 s14 s15 s16 s17
      s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e742 e620 e576 e765 e643 e616 e632 e606 e636 e640 e728
      e760 e613 e737 e610 e755 e628 e602 e846 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e882 :=
    x25519_sc_reduce.bridge_carry7_1 t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667
      t674 t687 t702 t703 t704 t738 t739 t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774
      t787 t788 t796 t797 t805 t806 t855 t881 t882 t624 t583 t628 t701 t747 t742 t620 t765 t643 t616
      t613 t640 t737 t760 t636 t610 t854 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3
      s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 carry7_1 s7 s14 s15 s16 s17
      s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e583 e628 e701 e747 e742 e620 e765 e643
      e616 e613 e640 e737 e760 e636 e610 e854 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e887 :=
    x25519_sc_reduce.bridge_carry9_1 t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743
      t744 t745 t753 t766 t777 t791 t860 t861 t862 t863 t886 t887 t742 t620 t624 t590 t628 t632 t636
      t708 t752 t765 t643 t616 t859 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8
      s9_9 carry9_1 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e742
      e620 e624 e590 e628 e632 e636 e708 e752 e765 e643 e616 e859 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have e892 :=
    x25519_sc_reduce.bridge_carry11_1 t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723
      t724 t757 t758 t868 t891 t892 t867 t624 t598 t628 t632 t636 t643 t640 t717 t755 s11_1 s11_2
      s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 carry11_1 s11 s18 s19 s20 s21 s22 s23 carry10
      carry11 carry10_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e867
      e624 e598 e628 e632 e636 e643 e640 e717 e755 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e902 :=
    x25519_sc_reduce.bridge_carry0_1 t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735
      t756 t817 t818 t835 t836 t895 t896 t902 t755 t628 t602 t632 t636 t643 t640 t728 t556 t833 t892
      s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 carry0_1 s0 s12 s19 s20
      s21 s22 s23 carry12 carry11 carry0 carry11_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl e755 e628 e602 e632 e636 e643 e640 e728 e556 e833 e892 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e908 :=
    x25519_sc_reduce.bridge_carry1_1 t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682
      t683 t684 t729 t730 t731 t732 t733 t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897
      t903 t904 t905 t908 t892 t872 t632 t606 t636 t643 t640 t728 t760 t560 t755 t628 t602 t833 t902
      s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8
      s1_3 s1_4 s12_9 s1_5 s1_6 carry1_1 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13
      carry0 carry1 carry11_1 carry0_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e872 e632
      e606 e636 e643 e640 e728 e760 e560 e755 e628 e602 e833 e902 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e915 :=
    x25519_sc_reduce.bridge_carry2_1 t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667
      t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761
      t762 t763 t800 t809 t821 t822 t823 t824 t844 t898 t909 t910 t911 t912 t915 t892 t838 t632 t606
      t636 t643 t640 t728 t760 t564 t610 t737 t755 t628 t602 t872 t908 s12_1 s13_1 s14_1 s12_2 s13_2
      s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3
      s12_8 s2_4 s2_5 s12_9 s2_6 s2_7 carry2_1 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14
      carry11 carry13 carry2 carry1 carry11_1 carry1_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e838 e632 e606 e636 e643 e640 e728 e760
      e564 e610 e737 e755 e628 e602 e872 e908 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e921 :=
    x25519_sc_reduce.bridge_carry3_1 t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663
      t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735
      t738 t739 t740 t756 t761 t762 t763 t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876
      t899 t916 t917 t918 t921 t892 t875 t632 t606 t636 t643 t640 t728 t760 t568 t613 t737 t765 t610
      t755 t628 t602 t838 t915 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8
      s3_5 s3_6 s12_9 s3_7 s3_8 carry3_1 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14
      carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      e892 e875 e632 e606 e636 e643 e640 e728 e760 e568 e613 e737 e765 e610 e755 e628 e602 e838 e915
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e928 :=
    x25519_sc_reduce.bridge_carry4_1 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658
      t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t738 t739 t740 t744 t745 t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811
      t826 t827 t828 t829 t830 t852 t900 t922 t923 t924 t925 t928 t892 t846 t765 t643 t616 t742 t572
      t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t875 t921 s12_1 s13_1 s14_1 s15_1
      s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4
      s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s4_9
      carry4_1 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13
      carry15 carry4 carry3 carry11_1 carry3_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl e892 e846 e765 e643 e616 e742 e572 e632 e606 e636 e640 e728 e760 e613 e737 e610
      e755 e628 e602 e875 e921 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e934 :=
    x25519_sc_reduce.bridge_carry5_1 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658
      t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t738 t739 t740 t743 t744 t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784
      t794 t803 t812 t831 t847 t848 t849 t850 t851 t880 t901 t929 t930 t931 t934 t892 t878 t742 t620
      t576 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t846 t928
      s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5
      s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5
      s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s5_10 carry5_1 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23
      carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e878 e742 e620 e576 e765
      e643 e616 e632 e606 e636 e640 e728 e760 e613 e737 e610 e755 e628 e602 e846 e928 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e938 :=
    x25519_sc_reduce.bridge_carry6_2 t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664
      t665 t666 t667 t673 t685 t686 t705 t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745
      t761 t762 t763 t766 t767 t768 t771 t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879
      t935 t938 t624 t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610
      t854 t878 t934 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5
      s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10
      carry6_2 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13
      carry15 carry6_1 carry5 carry5_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e580 e701 e742 e620 e765 e643
      e616 e632 e606 e636 e640 e728 e760 e613 e737 e610 e854 e878 e934 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e942 :=
    x25519_sc_reduce.bridge_carry7_2 t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667
      t674 t687 t702 t703 t704 t738 t739 t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774
      t787 t788 t796 t797 t805 t806 t855 t884 t885 t939 t942 t938 t624 t583 t628 t701 t747 t742 t620
      t765 t643 t616 t613 t640 t737 t760 t636 t610 t854 t882 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3
      s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10
      s7_11 carry7_2 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13
      carry15 carry6_1 carry7_1 carry6_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl e938 e624 e583 e628 e701 e747 e742 e620 e765 e643 e616 e613 e640 e737 e760
      e636 e610 e854 e882 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e946 :=
    x25519_sc_reduce.bridge_carry8_2 t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691
      t714 t715 t738 t743 t744 t745 t748 t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883
      t943 t946 t624 t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613 t640 t737 t859 t882 t942
      s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9
      s8_10 s8_11 carry8_2 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15
      carry8_1 carry7_1 carry7_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e586 e628 e632 e708 e747
      e742 e620 e765 e643 e616 e613 e640 e737 e859 e882 e942 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e950 :=
    x25519_sc_reduce.bridge_carry9_2 t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743
      t744 t745 t753 t766 t777 t791 t860 t861 t862 t863 t889 t890 t947 t950 t946 t742 t620 t624 t590
      t628 t632 t636 t708 t752 t765 t643 t616 t859 t887 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2
      s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 carry9_2 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16
      carry9 carry15 carry8_1 carry9_1 carry8_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e946 e742 e620 e624 e590 e628 e632 e636
      e708 e752 e765 e643 e616 e859 e887 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have e954 :=
    x25519_sc_reduce.bridge_carry10_2 t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726
      t743 t778 t779 t780 t869 t870 t888 t951 t954 t624 t594 t628 t632 t636 t640 t717 t742 t620 t752
      t867 t887 t950 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11
      carry10_2 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e624 e594 e628
      e632 e636 e640 e717 e742 e620 e752 e867 e887 e950 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl
  have e958 :=
    x25519_sc_reduce.bridge_carry11_2 t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723
      t724 t757 t758 t868 t893 t894 t955 t958 t954 t867 t624 t598 t628 t632 t636 t643 t640 t717 t755
      t892 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 s11_10 s11_11 carry11_2 s11 s18 s19
      s20 s21 s22 s23 carry10 carry11 carry10_1 carry11_1 carry10_2 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e954 e867 e624 e598 e628 e632 e636 e643 e640
      e717 e755 e892 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e973 :=
    x25519_sc_reduce.bridge_carry0_2 t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735
      t756 t817 t818 t835 t836 t895 t896 t906 t907 t961 t962 t973 t958 t755 t628 t602 t632 t636 t643
      t640 t728 t556 t833 t892 t902 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9
      s0_3 s12_10 s0_4 s12_11 s0_5 carry0_2 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0
      carry11_1 carry0_1 carry11_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl e958 e755 e628 e602 e632 e636 e643 e640 e728 e556 e833 e892
      e902 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e976 :=
    x25519_sc_reduce.bridge_s0_6 t645 t654 t662 t672 t679 t680 t681 t682 t683 t684 t734 t735 t756
      t817 t818 t835 t836 t895 t896 t906 t907 t961 t962 t975 t976 t958 t755 t628 t602 t632 t636 t643
      t640 t728 t556 t833 t892 t902 t973 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2
      s12_9 s0_3 s12_10 s0_4 s12_11 s0_5 s0_6 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0
      carry11_1 carry0_1 carry11_2 carry0_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e958 e755 e628 e602 e632 e636 e643 e640 e728 e556
      e833 e892 e902 e973 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e977 :=
    x25519_sc_reduce.bridge_carry1_2 t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682
      t683 t684 t729 t730 t731 t732 t733 t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897
      t903 t904 t905 t913 t914 t963 t964 t974 t977 t892 t872 t632 t606 t636 t643 t640 t728 t760 t560
      t755 t628 t602 t833 t902 t908 t958 t973 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5
      s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9
      carry1_2 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1
      carry0_1 carry1_1 carry11_2 carry0_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl e892 e872 e632 e606 e636 e643 e640 e728 e760 e560 e755 e628 e602 e833 e902 e908
      e958 e973 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have e980 :=
    x25519_sc_reduce.bridge_s1_10 t645 t646 t654 t655 t662 t663 t672 t673 t679 t680 t681 t682 t683
      t684 t729 t730 t731 t732 t733 t734 t735 t756 t762 t763 t807 t808 t819 t820 t834 t873 t897 t903
      t904 t905 t913 t914 t963 t964 t974 t979 t980 t892 t872 t632 t606 t636 t643 t640 t728 t760 t560
      t755 t628 t602 t833 t902 t908 t958 t973 t977 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4
      s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11
      s1_8 s1_9 s1_10 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1
      carry0_1 carry1_1 carry11_2 carry0_2 carry1_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl e892 e872 e632 e606 e636 e643 e640 e728 e760 e560 e755 e628 e602 e833
      e902 e908 e958 e973 e977 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e981 :=
    x25519_sc_reduce.bridge_carry2_2 t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667
      t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761
      t762 t763 t800 t809 t821 t822 t823 t824 t844 t898 t909 t910 t911 t912 t919 t920 t965 t966 t978
      t981 t892 t838 t632 t606 t636 t643 t640 t728 t760 t564 t610 t737 t755 t628 t602 t872 t908 t915
      t958 t977 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9
      s2_10 carry2_2 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2
      carry1 carry11_1 carry1_1 carry2_1 carry11_2 carry1_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e838 e632 e606
      e636 e643 e640 e728 e760 e564 e610 e737 e755 e628 e602 e872 e908 e915 e958 e977 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e984 :=
    x25519_sc_reduce.bridge_s2_11 t645 t646 t647 t654 t655 t656 t662 t663 t664 t665 t666 t667 t672
      t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t739 t740 t756 t761 t762
      t763 t800 t809 t821 t822 t823 t824 t844 t898 t909 t910 t911 t912 t919 t920 t965 t966 t978 t983
      t984 t892 t838 t632 t606 t636 t643 t640 t728 t760 t564 t610 t737 t755 t628 t602 t872 t908 t915
      t958 t977 t981 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8
      s12_11 s2_9 s2_10 s2_11 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13
      carry2 carry1 carry11_1 carry1_1 carry2_1 carry11_2 carry1_2 carry2_2 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      e892 e838 e632 e606 e636 e643 e640 e728 e760 e564 e610 e737 e755 e628 e602 e872 e908 e915 e958
      e977 e981 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e985 :=
    x25519_sc_reduce.bridge_carry3_2 t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663
      t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735
      t738 t739 t740 t756 t761 t762 t763 t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876
      t899 t916 t917 t918 t926 t927 t967 t968 t982 t985 t892 t875 t632 t606 t636 t643 t640 t728 t760
      t568 t613 t737 t765 t610 t755 t628 t602 t838 t915 t921 t958 t981 s12_1 s13_1 s14_1 s15_1 s12_2
      s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5
      s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11
      carry3_2 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2
      carry3 carry11_1 carry2_1 carry3_1 carry11_2 carry2_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl e892 e875 e632 e606 e636 e643 e640 e728 e760 e568 e613 e737 e765 e610 e755
      e628 e602 e838 e915 e921 e958 e981 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e988 :=
    x25519_sc_reduce.bridge_s3_12 t645 t646 t647 t648 t649 t654 t655 t656 t657 t658 t662 t663 t664
      t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734 t735 t738
      t739 t740 t756 t761 t762 t763 t767 t768 t792 t801 t810 t825 t839 t840 t841 t842 t843 t876 t899
      t916 t917 t918 t926 t927 t967 t968 t982 t987 t988 t892 t875 t632 t606 t636 t643 t640 t728 t760
      t568 t613 t737 t765 t610 t755 t628 t602 t838 t915 t921 t958 t981 t985 s12_1 s13_1 s14_1 s15_1
      s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7
      s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10
      s3_11 s3_12 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15
      carry2 carry3 carry11_1 carry2_1 carry3_1 carry11_2 carry2_2 carry3_2 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e875 e632 e606 e636 e643 e640 e728 e760 e568 e613
      e737 e765 e610 e755 e628 e602 e838 e915 e921 e958 e981 e985 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e989 :=
    x25519_sc_reduce.bridge_carry4_2 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658
      t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t738 t739 t740 t744 t745 t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811
      t826 t827 t828 t829 t830 t852 t900 t922 t923 t924 t925 t932 t933 t969 t970 t986 t989 t892 t846
      t765 t643 t616 t742 t572 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t875 t921
      t928 t958 t985 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4
      s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4
      s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 carry4_2 s4 s12 s13 s14
      s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3
      carry11_1 carry3_1 carry4_1 carry11_2 carry3_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e846 e765 e643 e616 e742 e572 e632 e606 e636 e640
      e728 e760 e613 e737 e610 e755 e628 e602 e875 e921 e928 e958 e985 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e992 :=
    x25519_sc_reduce.bridge_s4_13 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662
      t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734
      t735 t738 t739 t740 t744 t745 t756 t761 t762 t763 t766 t767 t768 t781 t782 t793 t802 t811 t826
      t827 t828 t829 t830 t852 t900 t922 t923 t924 t925 t932 t933 t969 t970 t986 t991 t992 t892 t846
      t765 t643 t616 t742 t572 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755 t628 t602 t875 t921
      t928 t958 t985 t989 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3
      s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4_13 s4 s12 s13 s14
      s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3
      carry11_1 carry3_1 carry4_1 carry11_2 carry3_2 carry4_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e846 e765 e643 e616 e742 e572 e632
      e606 e636 e640 e728 e760 e613 e737 e610 e755 e628 e602 e875 e921 e928 e958 e985 e989 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e993 :=
    x25519_sc_reduce.bridge_carry5_2 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658
      t662 t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733
      t734 t735 t738 t739 t740 t743 t744 t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784
      t794 t803 t812 t831 t847 t848 t849 t850 t851 t880 t901 t929 t930 t931 t936 t937 t971 t972 t990
      t993 t892 t878 t742 t620 t576 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755
      t628 t602 t846 t928 t934 t958 t989 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3
      s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12
      s5_13 carry5_2 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11
      carry13 carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e892 e878 e742
      e620 e576 e765 e643 e616 e632 e606 e636 e640 e728 e760 e613 e737 e610 e755 e628 e602 e846 e928
      e934 e958 e989 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have e996 :=
    x25519_sc_reduce.bridge_s5_14 t645 t646 t647 t648 t649 t650 t651 t654 t655 t656 t657 t658 t662
      t663 t664 t665 t666 t667 t672 t673 t679 t680 t681 t682 t683 t684 t729 t730 t731 t732 t733 t734
      t735 t738 t739 t740 t743 t744 t745 t756 t761 t762 t763 t766 t767 t768 t769 t770 t783 t784 t794
      t803 t812 t831 t847 t848 t849 t850 t851 t880 t901 t929 t930 t931 t936 t937 t971 t972 t990 t995
      t996 t892 t878 t742 t620 t576 t765 t643 t616 t632 t606 t636 t640 t728 t760 t613 t737 t610 t755
      t628 t602 t846 t928 t934 t958 t989 t993 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2
      s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6
      s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11
      s5_12 s5_13 s5_14 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16
      carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 carry5_2
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl e892 e878 e742 e620 e576 e765 e643 e616 e632 e606 e636 e640 e728 e760 e613 e737 e610
      e755 e628 e602 e846 e928 e934 e958 e989 e993 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e997 :=
    x25519_sc_reduce.bridge_carry6_3 t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664
      t665 t666 t667 t673 t685 t686 t705 t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745
      t761 t762 t763 t766 t767 t768 t771 t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879
      t935 t940 t941 t994 t997 t993 t624 t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640 t728
      t760 t613 t737 t610 t854 t878 t934 t938 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3
      s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7
      s6_8 s6_9 s6_10 s6_11 s6_12 carry6_3 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12
      carry14 carry16 carry13 carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl e993 e624 e580 e701 e742 e620 e765 e643 e616 e632 e606 e636 e640 e728 e760
      e613 e737 e610 e854 e878 e934 e938 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e1000 :=
    x25519_sc_reduce.bridge_s6_13 t646 t647 t648 t649 t650 t651 t655 t656 t657 t658 t663 t664 t665
      t666 t667 t673 t685 t686 t705 t706 t729 t730 t731 t732 t733 t738 t739 t740 t743 t744 t745 t761
      t762 t763 t766 t767 t768 t771 t772 t785 t786 t795 t804 t813 t814 t815 t816 t856 t857 t879 t935
      t940 t941 t994 t999 t1000 t993 t624 t580 t701 t742 t620 t765 t643 t616 t632 t606 t636 t640
      t728 t760 t613 t737 t610 t854 t878 t934 t938 t997 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2
      s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4
      s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 s6_11 s6_12 s6_13 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23
      carry6 carry12 carry14 carry16 carry13 carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2
      carry6_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e993 e624 e580 e701 e742 e620 e765 e643 e616
      e632 e606 e636 e640 e728 e760 e613 e737 e610 e854 e878 e934 e938 e997 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl
  have e1001 :=
    x25519_sc_reduce.bridge_carry7_3 t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667
      t674 t687 t702 t703 t704 t738 t739 t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774
      t787 t788 t796 t797 t805 t806 t855 t884 t885 t939 t944 t945 t998 t1001 t997 t938 t624 t583
      t628 t701 t747 t742 t620 t765 t643 t616 t613 t640 t737 t760 t636 t610 t854 t882 t942 s14_1
      s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4
      s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 s7_12 s7_13 carry7_3 s7 s14 s15 s16 s17 s18 s19 s21 s22
      s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1 carry6_2 carry7_2 carry6_3
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e997
      e938 e624 e583 e628 e701 e747 e742 e620 e765 e643 e616 e613 e640 e737 e760 e636 e610 e854 e882
      e942 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl
  have e1004 :=
    x25519_sc_reduce.bridge_s7_14 t647 t648 t649 t650 t651 t656 t657 t658 t664 t665 t666 t667 t674
      t687 t702 t703 t704 t738 t739 t740 t743 t744 t745 t749 t750 t761 t766 t767 t768 t773 t774 t787
      t788 t796 t797 t805 t806 t855 t884 t885 t939 t944 t945 t998 t1003 t1004 t997 t938 t624 t583
      t628 t701 t747 t742 t620 t765 t643 t616 t613 t640 t737 t760 t636 t610 t854 t882 t942 t1001
      s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3
      s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 s7_12 s7_13 s7_14 s7 s14 s15 s16 s17 s18 s19 s21
      s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1 carry6_2 carry7_2
      carry6_3 carry7_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl e997 e938 e624 e583 e628 e701 e747 e742 e620 e765 e643 e616 e613 e640 e737
      e760 e636 e610 e854 e882 e942 e1001 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e1005 :=
    x25519_sc_reduce.bridge_carry8_3 t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691
      t714 t715 t738 t743 t744 t745 t748 t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883
      t943 t948 t949 t1002 t1005 t1001 t624 t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613
      t640 t737 t859 t882 t942 t946 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5
      s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 s8_12 s8_13 carry8_3 s8 s15 s16 s17 s18 s19 s20
      s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 carry8_2 carry7_3 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1001 e624 e586 e628 e632 e708 e747 e742 e620
      e765 e643 e616 e613 e640 e737 e859 e882 e942 e946 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e1008 :=
    x25519_sc_reduce.bridge_s8_14 t648 t649 t650 t651 t657 t658 t668 t675 t688 t689 t690 t691 t714
      t715 t738 t743 t744 t745 t748 t766 t767 t768 t775 t776 t789 t790 t798 t799 t864 t865 t883 t943
      t948 t949 t1002 t1007 t1008 t1001 t624 t586 t628 t632 t708 t747 t742 t620 t765 t643 t616 t613
      t640 t737 t859 t882 t942 t946 t1005 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2
      s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 s8_12 s8_13 s8_14 s8 s15 s16 s17 s18 s19 s20
      s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 carry8_2 carry7_3
      carry8_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1001 e624 e586 e628 e632 e708
      e747 e742 e620 e765 e643 e616 e613 e640 e737 e859 e882 e942 e946 e1005 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e1009 :=
    x25519_sc_reduce.bridge_carry9_3 t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743
      t744 t745 t753 t766 t777 t791 t860 t861 t862 t863 t889 t890 t947 t952 t953 t1006 t1009 t1005
      t946 t742 t620 t624 t590 t628 t632 t636 t708 t752 t765 t643 t616 t859 t887 t950 s16_1 s9_1
      s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 carry9_3 s9
      s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 carry9_2
      carry8_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl e1005 e946 e742 e620 e624 e590 e628 e632 e636 e708 e752 e765
      e643 e616 e859 e887 e950 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have e1012 :=
    x25519_sc_reduce.bridge_s9_14 t650 t651 t659 t669 t676 t692 t709 t710 t711 t712 t713 t743 t744
      t745 t753 t766 t777 t791 t860 t861 t862 t863 t889 t890 t947 t952 t953 t1006 t1011 t1012 t1005
      t946 t742 t620 t624 t590 t628 t632 t636 t708 t752 t765 t643 t616 t859 t887 t950 t1009 s16_1
      s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 s9_14
      s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2
      carry9_2 carry8_3 carry9_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1005 e946 e742 e620 e624 e590 e628 e632
      e636 e708 e752 e765 e643 e616 e859 e887 e950 e1009 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e1013 :=
    x25519_sc_reduce.bridge_carry10_3 t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726
      t743 t778 t779 t780 t869 t870 t888 t951 t956 t957 t1010 t1013 t1009 t624 t594 t628 t632 t636
      t640 t717 t742 t620 t752 t867 t887 t950 t954 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7
      s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 carry10_3 s10 s17 s18 s19 s20 s21 s22 carry10 carry16
      carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1009 e624 e594 e628 e632 e636 e640
      e717 e742 e620 e752 e867 e887 e950 e954 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl
  have e1014 :=
    x25519_sc_reduce.bridge_s11_13 t644 t653 t661 t671 t678 t699 t718 t719 t720 t721 t722 t723 t724
      t757 t758 t868 t893 t894 t955 t959 t960 t1014 t1013 t954 t867 t624 t598 t628 t632 t636 t643
      t640 t717 t755 t892 t958 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 s11_10 s11_11
      s11_12 s11_13 s11 s18 s19 s20 s21 s22 s23 carry10 carry11 carry10_1 carry11_1 carry10_2
      carry11_2 carry10_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl e1013 e954 e867 e624 e598 e628 e632 e636 e643 e640 e717 e755 e892 e958 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e1016 :=
    x25519_sc_reduce.bridge_s10_14 t652 t660 t670 t677 t693 t694 t695 t696 t697 t698 t725 t726 t743
      t778 t779 t780 t869 t870 t888 t951 t956 t957 t1010 t1015 t1016 t1009 t624 t594 t628 t632 t636
      t640 t717 t742 t620 t752 t867 t887 t950 t954 t1013 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1
      s10_7 s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 s10_14 s10 s17 s18 s19 s20 s21 s22 carry10
      carry16 carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 carry10_3 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1009 e624
      e594 e628 e632 e636 e640 e717 e742 e620 e752 e867 e887 e950 e954 e1013 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl
  exact x25519_sc_reduce.out_eq e976 e980 e984 e988 e992 e996 e1000 e1004 e1008 e1012 e1016 e1014

/-! ## Proof -/

section Proof

open x25519_sc_reduce Bounds

/-- The constants the code reads after its first instructions. -/
abbrev x25519_sc_reduce.Consts (E : ⟪x25519_sc_reduce.Γ⟫) : Prop :=
  E ⊨ [%531 := 2097151#64, %532 := 2#64, %533 := 5#64, %534 := 7#64, %535 := 4#64, %536 := 1#64,
    %537 := 15#64, %538 := 6#64, %539 := 18#64, %540 := 3#64, %541 := 21#64, %542 := 666643#64,
    %543 := 470296#64, %544 := 654183#64, %545 := 18446744073708553811#64, %546 := 136657#64,
    %547 := 18446744073708867715#64, %548 := 1048576#64, %549 := 16#64, %550 := 19#64, %551 :=
    14#64, %552 := 17#64, %553 := 20#64, %554 := 9#64]

/-- `^bb0` from instruction 0 to 60: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run0 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 0 = x25519_sc_reduce.entry.body.drop 0) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t555 s0 t558 t559 s1 t562 t563 s2 t566 t567 s3 t570 t571 s4 t574 t575 s5 t578 t579 s6 t582
          s7 t585 s8 t588 t589 s9 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 :=
              s6, %583 := s7, %586 := s8, %590 := s9, %557 := p.add 2#64, %561 := p.add 5#64,
              %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64,
              %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64]) →
          (ht555 : t555 = load3 (S.mem.readAt p 512) 0) →
          (hs0 : s0 = t555 &&& 2097151#64) →
          (ht558 : t558 = load4 (S.mem.readAt p 512) 2) →
          (ht559 : t559 = t558 >>> 5) →
          (hs1 : s1 = t559 &&& 2097151#64) →
          (ht562 : t562 = load3 (S.mem.readAt p 512) 5) →
          (ht563 : t563 = t562 >>> 2) →
          (hs2 : s2 = t563 &&& 2097151#64) →
          (ht566 : t566 = load4 (S.mem.readAt p 512) 7) →
          (ht567 : t567 = t566 >>> 7) →
          (hs3 : s3 = t567 &&& 2097151#64) →
          (ht570 : t570 = load4 (S.mem.readAt p 512) 10) →
          (ht571 : t571 = t570 >>> 4) →
          (hs4 : s4 = t571 &&& 2097151#64) →
          (ht574 : t574 = load3 (S.mem.readAt p 512) 13) →
          (ht575 : t575 = t574 >>> 1) →
          (hs5 : s5 = t575 &&& 2097151#64) →
          (ht578 : t578 = load4 (S.mem.readAt p 512) 15) →
          (ht579 : t579 = t578 >>> 6) →
          (hs6 : s6 = t579 &&& 2097151#64) →
          (ht582 : t582 = load3 (S.mem.readAt p 512) 18) →
          (hs7 : s7 = t582 >>> 3) →
          (ht585 : t585 = load3 (S.mem.readAt p 512) 21) →
          (hs8 : s8 = t585 &&& 2097151#64) →
          (ht588 : t588 = load4 (S.mem.readAt p 512) 23) →
          (ht589 : t589 = t588 >>> 5) →
          (hs9 : s9 = t589 &&& 2097151#64) →
          (hbs0 : Bnd s0 0 2097151) →
          (hbs1 : Bnd s1 0 2097151) →
          (hbs2 : Bnd s2 0 2097151) →
          (hbs3 : Bnd s3 0 2097151) →
          (hbs4 : Bnd s4 0 2097151) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) →
          (hbs9 : Bnd s9 0 2097151) → (blk.runBodyFrom E' 60 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using (load_3.call_eq (hp_off := BitVec.not_uaddOverflow_of_le hp_off (by decide))) with
    t555
  bnd_ext t555
  step_pure with s0
  bnd_ext s0
  step_pure
  step_call using load_4.call_eq with t558
  bnd_ext t558
  step_pure with t559
  bnd_ext t559
  step_pure with s1
  bnd_ext s1
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 5 (by decide))) with t562
  bnd_ext t562
  step_pure with t563
  bnd_ext t563
  step_pure with s2
  bnd_ext s2
  step_pure
  step_call using load_4.call_eq with t566
  bnd_ext t566
  step_pure with t567
  bnd_ext t567
  step_pure with s3
  bnd_ext s3
  step_pure
  step_call using load_4.call_eq with t570
  bnd_ext t570
  step_pure with t571
  bnd_ext t571
  step_pure with s4
  bnd_ext s4
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 13 (by decide))) with t574
  bnd_ext t574
  step_pure with t575
  bnd_ext t575
  step_pure with s5
  bnd_ext s5
  step_pure
  step_call using load_4.call_eq with t578
  bnd_ext t578
  step_pure with t579
  bnd_ext t579
  step_pure with s6
  bnd_ext s6
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 18 (by decide))) with t582
  bnd_ext t582
  step_pure with s7
  bnd_ext s7
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 21 (by decide))) with t585
  bnd_ext t585
  step_pure with s8
  bnd_ext s8
  step_pure
  step_call using load_4.call_eq with t588
  bnd_ext t588
  step_pure with t589
  bnd_ext t589
  step_pure with s9
  bnd_ext s9
  subst hS
  exact
    hK _ t555 s0 t558 t559 s1 t562 t563 s2 t566 t567 s3 t570 t571 s4 t574 t575 s5 t578 t579 s6 t582
      s7 t585 s8 t588 t589 s9 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) (ht555.trans (setWidth_load3 _)) hs0 ht558 ht559 hs1 ht562 ht563 hs2 ht566
      ht567 hs3 ht570 ht571 hs4 ht574 ht575 hs5 ht578 ht579 hs6 ht582 hs7 ht585 hs8 ht588 ht589 hs9
      hbs0 hbs1 hbs2 hbs3 hbs4 hbs5 hbs6 hbs7 hbs8 hbs9

/-- `^bb0` from instruction 60 to 90: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run60 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 60 = x25519_sc_reduce.entry.body.drop 60) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 := s6,
        %583 := s7, %586 := s8, %590 := s9, %557 := p.add 2#64, %561 := p.add 5#64, %565 :=
        p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 :=
        p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64])
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t592 t593 s10 t596 t597 s11 t600 t601 s12 t604 t605 s13 t608 t609 s14 t612 s15 t615 s16
          t618 t619 s17 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 :=
              s6, %583 := s7, %586 := s8, %590 := s9, %594 := s10, %598 := s11, %602 := s12, %606 :=
              s13, %610 := s14, %613 := s15, %616 := s16, %620 := s17, %557 := p.add 2#64, %561 :=
              p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 :=
              p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 :=
              p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64]) →
          (ht592 : t592 = load3 (S.mem.readAt p 512) 26) →
          (ht593 : t593 = t592 >>> 2) →
          (hs10 : s10 = t593 &&& 2097151#64) →
          (ht596 : t596 = load4 (S.mem.readAt p 512) 28) →
          (ht597 : t597 = t596 >>> 7) →
          (hs11 : s11 = t597 &&& 2097151#64) →
          (ht600 : t600 = load4 (S.mem.readAt p 512) 31) →
          (ht601 : t601 = t600 >>> 4) →
          (hs12 : s12 = t601 &&& 2097151#64) →
          (ht604 : t604 = load3 (S.mem.readAt p 512) 34) →
          (ht605 : t605 = t604 >>> 1) →
          (hs13 : s13 = t605 &&& 2097151#64) →
          (ht608 : t608 = load4 (S.mem.readAt p 512) 36) →
          (ht609 : t609 = t608 >>> 6) →
          (hs14 : s14 = t609 &&& 2097151#64) →
          (ht612 : t612 = load3 (S.mem.readAt p 512) 39) →
          (hs15 : s15 = t612 >>> 3) →
          (ht615 : t615 = load3 (S.mem.readAt p 512) 42) →
          (hs16 : s16 = t615 &&& 2097151#64) →
          (ht618 : t618 = load4 (S.mem.readAt p 512) 44) →
          (ht619 : t619 = t618 >>> 5) →
          (hs17 : s17 = t619 &&& 2097151#64) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) →
          (hbs15 : Bnd s15 0 2097151) →
          (hbs16 : Bnd s16 0 2097151) →
          (hbs17 : Bnd s17 0 2097151) → (blk.runBodyFrom E' 90 S >>= g) = K) :
    (blk.runBodyFrom E 60 S >>= g) = K := by
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 26 (by decide))) with t592
  bnd_ext t592
  step_pure with t593
  bnd_ext t593
  step_pure with s10
  bnd_ext s10
  step_pure
  step_call using load_4.call_eq with t596
  bnd_ext t596
  step_pure with t597
  bnd_ext t597
  step_pure with s11
  bnd_ext s11
  step_pure
  step_call using load_4.call_eq with t600
  bnd_ext t600
  step_pure with t601
  bnd_ext t601
  step_pure with s12
  bnd_ext s12
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 34 (by decide))) with t604
  bnd_ext t604
  step_pure with t605
  bnd_ext t605
  step_pure with s13
  bnd_ext s13
  step_pure
  step_call using load_4.call_eq with t608
  bnd_ext t608
  step_pure with t609
  bnd_ext t609
  step_pure with s14
  bnd_ext s14
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 39 (by decide))) with t612
  bnd_ext t612
  step_pure with s15
  bnd_ext s15
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 42 (by decide))) with t615
  bnd_ext t615
  step_pure with s16
  bnd_ext s16
  step_pure
  step_call using load_4.call_eq with t618
  bnd_ext t618
  step_pure with t619
  bnd_ext t619
  step_pure with s17
  bnd_ext s17
  subst hS
  exact
    hK _ t592 t593 s10 t596 t597 s11 t600 t601 s12 t604 t605 s13 t608 t609 s14 t612 s15 t615 s16
      t618 t619 s17 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht592 ht593 hs10 ht596 ht597 hs11 ht600 ht601 hs12 ht604 ht605 hs13 ht608 ht609
      hs14 ht612 hs15 ht615 hs16 ht618 ht619 hs17 hbs10 hbs11 hbs12 hbs13 hbs14 hbs15 hbs16 hbs17

/-- `^bb0` from instruction 90 to 135: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run90 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 90 = x25519_sc_reduce.entry.body.drop 90) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 := s6,
        %583 := s7, %586 := s8, %590 := s9, %594 := s10, %598 := s11, %602 := s12, %606 := s13,
        %610 := s14, %613 := s15, %616 := s16, %620 := s17, %557 := p.add 2#64, %561 := p.add 5#64,
        %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 :=
        p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 :=
        p.add 28#64, %599 := p.add 31#64])
    (hbs14 : Bnd s14 0 2097151) (hbs15 : Bnd s15 0 2097151) (hbs16 : Bnd s16 0 2097151)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t622 t623 s18 t626 t627 s19 t630 t631 s20 t634 t635 s21 t638 t639 s22 t642 s23 t644 t645
          t646 t647 t648 s15_1 t650 s16_1 t652 t653 t654 t655 t656 t657 s15_2 t659 t660 t661 t662
          t663 t664 t665 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 :=
              s6, %583 := s7, %586 := s8, %590 := s9, %594 := s10, %598 := s11, %602 := s12, %606 :=
              s13, %620 := s17, %624 := s18, %628 := s19, %632 := s20, %644 := t644, %645 := t645,
              %646 := t646, %647 := t647, %651 := s16_1, %652 := t652, %653 := t653, %654 := t654,
              %655 := t655, %656 := t656, %658 := s15_2, %659 := t659, %660 := t660, %661 := t661,
              %662 := t662, %663 := t663, %665 := t665, %557 := p.add 2#64, %561 := p.add 5#64,
              %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64,
              %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64,
              %595 := p.add 28#64, %599 := p.add 31#64]) →
          (ht622 : t622 = load3 (S.mem.readAt p 512) 47) →
          (ht623 : t623 = t622 >>> 2) →
          (hs18 : s18 = t623 &&& 2097151#64) →
          (ht626 : t626 = load4 (S.mem.readAt p 512) 49) →
          (ht627 : t627 = t626 >>> 7) →
          (hs19 : s19 = t627 &&& 2097151#64) →
          (ht630 : t630 = load4 (S.mem.readAt p 512) 52) →
          (ht631 : t631 = t630 >>> 4) →
          (hs20 : s20 = t631 &&& 2097151#64) →
          (ht634 : t634 = load3 (S.mem.readAt p 512) 55) →
          (ht635 : t635 = t634 >>> 1) →
          (hs21 : s21 = t635 &&& 2097151#64) →
          (ht638 : t638 = load4 (S.mem.readAt p 512) 57) →
          (ht639 : t639 = t638 >>> 6) →
          (hs22 : s22 = t639 &&& 2097151#64) →
          (ht642 : t642 = load4 (S.mem.readAt p 512) 60) →
          (hs23 : s23 = t642 >>> 3) →
          (ht644 : t644 = s23 * 666643#64) →
          (ht645 : t645 = s23 * 470296#64) →
          (ht646 : t646 = s23 * 654183#64) →
          (ht647 : t647 = s23 * 18446744073708553811#64) →
          (ht648 : t648 = s23 * 136657#64) →
          (hs15_1 : s15_1 = t648 + s15) →
          (ht650 : t650 = s23 * 18446744073708867715#64) →
          (hs16_1 : s16_1 = t650 + s16) →
          (ht652 : t652 = s22 * 666643#64) →
          (ht653 : t653 = s22 * 470296#64) →
          (ht654 : t654 = s22 * 654183#64) →
          (ht655 : t655 = s22 * 18446744073708553811#64) →
          (ht656 : t656 = s22 * 136657#64) →
          (ht657 : t657 = s22 * 18446744073708867715#64) →
          (hs15_2 : s15_2 = s15_1 + t657) →
          (ht659 : t659 = s21 * 666643#64) →
          (ht660 : t660 = s21 * 470296#64) →
          (ht661 : t661 = s21 * 654183#64) →
          (ht662 : t662 = s21 * 18446744073708553811#64) →
          (ht663 : t663 = s21 * 136657#64) →
          (ht664 : t664 = s21 * 18446744073708867715#64) →
          (ht665 : t665 = t664 + s14) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs19 : Bnd s19 0 2097151) →
          (hbs20 : Bnd s20 0 2097151) →
          (hbt644 : Bnd t644 0 357901234721773) →
          (hbt645 : Bnd t645 0 252488241959656) →
          (hbt646 : Bnd t646 0 351211823170713) →
          (hbt647 : Bnd t647 (-535692479350355) 0) →
          (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151) →
          (hbt652 : Bnd t652 0 1398051034093) →
          (hbt653 : Bnd t653 0 986281726696) →
          (hbt654 : Bnd t654 0 1371920532633) →
          (hbt655 : Bnd t655 (-2092547753555) 0) →
          (hbt656 : Bnd t656 0 286590364207) →
          (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) →
          (hbt659 : Bnd t659 0 1398051034093) →
          (hbt660 : Bnd t660 0 986281726696) →
          (hbt661 : Bnd t661 0 1371920532633) →
          (hbt662 : Bnd t662 (-2092547753555) 0) →
          (hbt663 : Bnd t663 0 286590364207) →
          (hbt665 : Bnd t665 (-1434243666051) 2097151) → (blk.runBodyFrom E' 135 S >>= g) = K) :
    (blk.runBodyFrom E 90 S >>= g) = K := by
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 47 (by decide))) with t622
  bnd_ext t622
  step_pure with t623
  bnd_ext t623
  step_pure with s18
  bnd_ext s18
  step_pure
  step_call using load_4.call_eq with t626
  bnd_ext t626
  step_pure with t627
  bnd_ext t627
  step_pure with s19
  bnd_ext s19
  step_pure
  step_call using load_4.call_eq with t630
  bnd_ext t630
  step_pure with t631
  bnd_ext t631
  step_pure with s20
  bnd_ext s20
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 55 (by decide))) with t634
  bnd_ext t634
  step_pure with t635
  bnd_ext t635
  step_pure with s21
  bnd_ext s21
  step_pure
  step_call using load_4.call_eq with t638
  bnd_ext t638
  step_pure with t639
  bnd_ext t639
  step_pure with s22
  bnd_ext s22
  step_pure
  step_call using load_4.call_eq with t642
  bnd_ext t642
  step_pure with s23
  bnd_ext s23
  step_pure [nswMul, nuwMul] with t644
  bnd_ext t644
  step_pure [nswMul, nuwMul] with t645
  bnd_ext t645
  step_pure [nswMul, nuwMul] with t646
  bnd_ext t646
  step_pure [nswMul] with t647
  bnd_ext t647
  step_pure [nswMul, nuwMul] with t648
  bnd_ext t648
  step_pure [nswAdd, nuwAdd] with s15_1
  bnd_ext s15_1
  step_pure [nswMul] with t650
  bnd_ext t650
  step_pure [nswAdd] with s16_1
  bnd_ext s16_1
  step_pure [nswMul, nuwMul] with t652
  bnd_ext t652
  step_pure [nswMul, nuwMul] with t653
  bnd_ext t653
  step_pure [nswMul, nuwMul] with t654
  bnd_ext t654
  step_pure [nswMul] with t655
  bnd_ext t655
  step_pure [nswMul, nuwMul] with t656
  bnd_ext t656
  step_pure [nswMul] with t657
  bnd_ext t657
  step_pure [nswAdd] with s15_2
  bnd_ext s15_2
  step_pure [nswMul, nuwMul] with t659
  bnd_ext t659
  step_pure [nswMul, nuwMul] with t660
  bnd_ext t660
  step_pure [nswMul, nuwMul] with t661
  bnd_ext t661
  step_pure [nswMul] with t662
  bnd_ext t662
  step_pure [nswMul, nuwMul] with t663
  bnd_ext t663
  step_pure [nswMul] with t664
  bnd_ext t664
  step_pure [nswAdd] with t665
  bnd_ext t665
  subst hS
  exact
    hK _ t622 t623 s18 t626 t627 s19 t630 t631 s20 t634 t635 s21 t638 t639 s22 t642 s23 t644 t645
      t646 t647 t648 s15_1 t650 s16_1 t652 t653 t654 t655 t656 t657 s15_2 t659 t660 t661 t662 t663
      t664 t665 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht622 ht623 hs18 ht626 ht627 hs19 ht630 ht631 hs20 ht634 ht635 hs21 ht638 ht639
      hs22 ht642 hs23 ht644 ht645 ht646 ht647 ht648 hs15_1 ht650 hs16_1 ht652 ht653 ht654 ht655
      ht656 ht657 hs15_2 ht659 ht660 ht661 ht662 ht663 ht664 ht665 hbs18 hbs19 hbs20 hbt644 hbt645
      hbt646 hbt647 hbs16_1 hbt652 hbt653 hbt654 hbt655 hbt656 hbs15_2 hbt659 hbt660 hbt661 hbt662
      hbt663 hbt665

/-- `^bb0` from instruction 135 to 180: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run135 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 135 = x25519_sc_reduce.entry.body.drop 135) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s17 s18 s19 s20 t644 t645 t646 t647 s16_1 t652
      t653 t654 t655 t656 s15_2 t659 t660 t661 t662 t663 t665 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %580 := s6,
        %583 := s7, %586 := s8, %590 := s9, %594 := s10, %598 := s11, %602 := s12, %606 := s13,
        %620 := s17, %624 := s18, %628 := s19, %632 := s20, %644 := t644, %645 := t645, %646 :=
        t646, %647 := t647, %651 := s16_1, %652 := t652, %653 := t653, %654 := t654, %655 := t655,
        %656 := t656, %658 := s15_2, %659 := t659, %660 := t660, %661 := t661, %662 := t662, %663 :=
        t663, %665 := t665, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 :=
        p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (hbs6 : Bnd s6 0 2097151) (hbs7 : Bnd s7 0 2097151) (hbs8 : Bnd s8 0 2097151)
    (hbs9 : Bnd s9 0 2097151) (hbs10 : Bnd s10 0 2097151) (hbs12 : Bnd s12 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbt645 : Bnd t645 0 252488241959656) (hbt647 : Bnd t647 (-535692479350355) 0)
    (hbt652 : Bnd t652 0 1398051034093) (hbt654 : Bnd t654 0 1371920532633)
    (hbt656 : Bnd t656 0 286590364207) (hbt660 : Bnd t660 0 986281726696)
    (hbt662 : Bnd t662 (-2092547753555) 0) (hbt665 : Bnd t665 (-1434243666051) 2097151)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t666 s14_3 t668 t669 t670 t671 t672 t673 t674 t675 t676 t677 t678 t679 t680 t681 t682 t683
          s12_5 t685 s6_1 t687 t688 t689 t690 s8_3 t692 t693 t694 t695 t696 t697 s10_5 t699 t700
          carry6 t702 s7_2 s7_3 t705 s6_2 t707 carry8 t709 t710 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %598 :=
              s11, %606 := s13, %620 := s17, %644 := t644, %646 := t646, %651 := s16_1, %653 :=
              t653, %655 := t655, %658 := s15_2, %659 := t659, %661 := t661, %663 := t663, %667 :=
              s14_3, %669 := t669, %671 := t671, %673 := t673, %678 := t678, %684 := s12_5, %691 :=
              s8_3, %698 := s10_5, %699 := t699, %704 := s7_3, %706 := s6_2, %708 := carry8, %710 :=
              t710, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64,
              %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64,
              %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64]) →
          (ht666 : t666 = t665 + t647) →
          (hs14_3 : s14_3 = t666 + t656) →
          (ht668 : t668 = s20 * 666643#64) →
          (ht669 : t669 = s20 * 470296#64) →
          (ht670 : t670 = s20 * 654183#64) →
          (ht671 : t671 = s20 * 18446744073708553811#64) →
          (ht672 : t672 = s20 * 136657#64) →
          (ht673 : t673 = s20 * 18446744073708867715#64) →
          (ht674 : t674 = s19 * 666643#64) →
          (ht675 : t675 = s19 * 470296#64) →
          (ht676 : t676 = s19 * 654183#64) →
          (ht677 : t677 = s19 * 18446744073708553811#64) →
          (ht678 : t678 = s19 * 136657#64) →
          (ht679 : t679 = s19 * 18446744073708867715#64) →
          (ht680 : t680 = t679 + s12) →
          (ht681 : t681 = t680 + t672) →
          (ht682 : t682 = t681 + t662) →
          (ht683 : t683 = t682 + t645) →
          (hs12_5 : s12_5 = t683 + t654) →
          (ht685 : t685 = s18 * 666643#64) →
          (hs6_1 : s6_1 = t685 + s6) →
          (ht687 : t687 = s18 * 470296#64) →
          (ht688 : t688 = s18 * 654183#64) →
          (ht689 : t689 = t688 + s8) →
          (ht690 : t690 = t689 + t675) →
          (hs8_3 : s8_3 = t690 + t668) →
          (ht692 : t692 = s18 * 18446744073708553811#64) →
          (ht693 : t693 = s18 * 136657#64) →
          (ht694 : t694 = t693 + s10) →
          (ht695 : t695 = t694 + t677) →
          (ht696 : t696 = t695 + t670) →
          (ht697 : t697 = t696 + t660) →
          (hs10_5 : s10_5 = t697 + t652) →
          (ht699 : t699 = s18 * 18446744073708867715#64) →
          (ht700 : t700 = s6_1 + 1048576#64) →
          (hcarry6 : carry6 = t700 >>> 21) →
          (ht702 : t702 = t687 + s7) →
          (hs7_2 : s7_2 = t702 + t674) →
          (hs7_3 : s7_3 = s7_2 + carry6) →
          (ht705 : t705 = carry6 <<< 21) →
          (hs6_2 : s6_2 = s6_1 - t705) →
          (ht707 : t707 = s8_3 + 1048576#64) →
          (hcarry8 : carry8 = t707 >>> 21) →
          (ht709 : t709 = t692 + s9) →
          (ht710 : t710 = t709 + t676) →
          (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) →
          (hbt669 : Bnd t669 0 986281726696) →
          (hbt671 : Bnd t671 (-2092547753555) 0) →
          (hbt673 : Bnd t673 (-1434243666051) 0) →
          (hbt678 : Bnd t678 0 286590364207) →
          (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) →
          (hbs8_3 : Bnd s8_3 0 3756255390573) →
          (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) →
          (hbt699 : Bnd t699 (-1434243666051) 0) →
          (hbs7_3 : Bnd s7_3 0 2384335524584) →
          (hbs6_2 : Bnd s6_2 (-1048576) 1048575) →
          (hbcarry8 : Bnd carry8 0 1791122) →
          (hbt710 : Bnd t710 (-2092547753555) 1371922629784) →
          (blk.runBodyFrom E' 180 S >>= g) = K) :
    (blk.runBodyFrom E 135 S >>= g) = K := by
  step_pure [nswAdd] with t666
  bnd_ext t666
  step_pure [nswAdd] with s14_3
  bnd_ext s14_3
  step_pure [nswMul, nuwMul] with t668
  bnd_ext t668
  step_pure [nswMul, nuwMul] with t669
  bnd_ext t669
  step_pure [nswMul, nuwMul] with t670
  bnd_ext t670
  step_pure [nswMul] with t671
  bnd_ext t671
  step_pure [nswMul, nuwMul] with t672
  bnd_ext t672
  step_pure [nswMul] with t673
  bnd_ext t673
  step_pure [nswMul, nuwMul] with t674
  bnd_ext t674
  step_pure [nswMul, nuwMul] with t675
  bnd_ext t675
  step_pure [nswMul, nuwMul] with t676
  bnd_ext t676
  step_pure [nswMul] with t677
  bnd_ext t677
  step_pure [nswMul, nuwMul] with t678
  bnd_ext t678
  step_pure [nswMul] with t679
  bnd_ext t679
  step_pure [nswAdd] with t680
  bnd_ext t680
  step_pure [nswAdd] with t681
  bnd_ext t681
  step_pure [nswAdd] with t682
  bnd_ext t682
  step_pure [nswAdd] with t683
  bnd_ext t683
  step_pure [nswAdd] with s12_5
  bnd_ext s12_5
  step_pure [nswMul, nuwMul] with t685
  bnd_ext t685
  step_pure [nswAdd, nuwAdd] with s6_1
  bnd_ext s6_1
  step_pure [nswMul, nuwMul] with t687
  bnd_ext t687
  step_pure [nswMul, nuwMul] with t688
  bnd_ext t688
  step_pure [nswAdd, nuwAdd] with t689
  bnd_ext t689
  step_pure [nswAdd, nuwAdd] with t690
  bnd_ext t690
  step_pure [nswAdd, nuwAdd] with s8_3
  bnd_ext s8_3
  step_pure [nswMul] with t692
  bnd_ext t692
  step_pure [nswMul, nuwMul] with t693
  bnd_ext t693
  step_pure [nswAdd, nuwAdd] with t694
  bnd_ext t694
  step_pure [nswAdd] with t695
  bnd_ext t695
  step_pure [nswAdd] with t696
  bnd_ext t696
  step_pure [nswAdd] with t697
  bnd_ext t697
  step_pure [nswAdd] with s10_5
  bnd_ext s10_5
  step_pure [nswMul] with t699
  bnd_ext t699
  step_pure [nswAdd, nuwAdd] with t700
  bnd_ext t700
  step_pure with carry6
  bnd_ext carry6
  step_pure [nswAdd, nuwAdd] with t702
  bnd_ext t702
  step_pure [nswAdd, nuwAdd] with s7_2
  bnd_ext s7_2
  step_pure [nswAdd, nuwAdd] with s7_3
  bnd_ext s7_3
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry6 (by decide))) with
    t705
  bnd_ext t705
  step_pure with s6_2
  bnd_ext s6_2
  step_pure [nswAdd, nuwAdd] with t707
  bnd_ext t707
  step_pure with carry8
  bnd_ext carry8
  step_pure [nswAdd] with t709
  bnd_ext t709
  step_pure [nswAdd] with t710
  bnd_ext t710
  subst hS
  exact
    hK _ t666 s14_3 t668 t669 t670 t671 t672 t673 t674 t675 t676 t677 t678 t679 t680 t681 t682 t683
      s12_5 t685 s6_1 t687 t688 t689 t690 s8_3 t692 t693 t694 t695 t696 t697 s10_5 t699 t700 carry6
      t702 s7_2 s7_3 t705 s6_2 t707 carry8 t709 t710 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht666 hs14_3 ht668 ht669 ht670 ht671 ht672 ht673 ht674 ht675 ht676 ht677 ht678
      ht679 ht680 ht681 ht682 ht683 hs12_5 ht685 hs6_1 ht687 ht688 ht689 ht690 hs8_3 ht692 ht693
      ht694 ht695 ht696 ht697 hs10_5 ht699 ht700 hcarry6 ht702 hs7_2 hs7_3 ht705 hs6_2 ht707 hcarry8
      ht709 ht710 hbs14_3 hbt669 hbt671 hbt673 hbt678 hbs12_5 hbs8_3 hbs10_5 hbt699 hbs7_3 hbs6_2
      hbcarry8 hbt710

/-- `^bb0` from instruction 180 to 225: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run180 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 180 = x25519_sc_reduce.entry.body.drop 180) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s11 s13 s17 t644 t646 s16_1 t653 t655 s15_2 t659 t661 t663 s14_3 t669 t671
      t673 t678 s12_5 s8_3 s10_5 t699 s7_3 s6_2 carry8 t710 t707 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %598 := s11,
        %606 := s13, %620 := s17, %644 := t644, %646 := t646, %651 := s16_1, %653 := t653, %655 :=
        t655, %658 := s15_2, %659 := t659, %661 := t661, %663 := t663, %667 := s14_3, %669 := t669,
        %671 := t671, %673 := t673, %678 := t678, %684 := s12_5, %691 := s8_3, %698 := s10_5,
        %699 := t699, %704 := s7_3, %706 := s6_2, %708 := carry8, %710 := t710, %557 := p.add 2#64,
        %561 := p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 :=
        p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 :=
        p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64])
    (ht707 : s8_3 + 1048576#64 = t707) (hcarry8 : t707 >>> 21 = carry8) (hbs11 : Bnd s11 0 2097151)
    (hbs13 : Bnd s13 0 2097151) (hbs17 : Bnd s17 0 2097151) (hbt644 : Bnd t644 0 357901234721773)
    (hbt646 : Bnd t646 0 351211823170713) (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151)
    (hbt653 : Bnd t653 0 986281726696) (hbt655 : Bnd t655 (-2092547753555) 0)
    (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) (hbt659 : Bnd t659 0 1398051034093)
    (hbt661 : Bnd t661 0 1371920532633) (hbt663 : Bnd t663 0 286590364207)
    (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) (hbt669 : Bnd t669 0 986281726696)
    (hbt671 : Bnd t671 (-2092547753555) 0) (hbt673 : Bnd t673 (-1434243666051) 0)
    (hbt678 : Bnd t678 0 286590364207) (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) (hbt699 : Bnd t699 (-1434243666051) 0)
    (hbs7_3 : Bnd s7_3 0 2384335524584) (hbcarry8 : Bnd carry8 0 1791122)
    (hbt710 : Bnd t710 (-2092547753555) 1371922629784)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t711 s9_4 s9_5 t714 s8_4 t716 carry10 t718 t719 t720 t721 t722 s11_6 s11_7 t725 s10_6 t727
          carry12 t729 t730 t731 s13_4 s13_5 t734 s12_6 t736 carry14 s15_3 t739 s14_4 t741 carry16
          s17_1 t744 s16_2 t746 carry7 s8_5 t749 s7_4 t751 carry9 t753 t754 carry11 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %706 :=
              s6_2, %713 := s9_5, %724 := s11_7, %726 := s10_6, %733 := s13_5, %735 := s12_6,
              %738 := s15_3, %740 := s14_4, %743 := s17_1, %745 := s16_2, %748 := s8_5, %750 :=
              s7_4, %752 := carry9, %753 := t753, %755 := carry11, %557 := p.add 2#64, %561 :=
              p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 :=
              p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 :=
              p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64]) →
          (ht711 : t711 = t710 + t669) →
          (hs9_4 : s9_4 = t711 + t659) →
          (hs9_5 : s9_5 = s9_4 + carry8) →
          (ht714 : t714 = carry8 <<< 21) →
          (hs8_4 : s8_4 = s8_3 - t714) →
          (ht716 : t716 = s10_5 + 1048576#64) →
          (hcarry10 : carry10 = t716.sshiftRight 21) →
          (ht718 : t718 = t699 + s11) →
          (ht719 : t719 = t718 + t678) →
          (ht720 : t720 = t719 + t671) →
          (ht721 : t721 = t720 + t661) →
          (ht722 : t722 = t721 + t644) →
          (hs11_6 : s11_6 = t722 + t653) →
          (hs11_7 : s11_7 = s11_6 + carry10) →
          (ht725 : t725 = carry10 <<< 21) →
          (hs10_6 : s10_6 = s10_5 - t725) →
          (ht727 : t727 = s12_5 + 1048576#64) →
          (hcarry12 : carry12 = t727.sshiftRight 21) →
          (ht729 : t729 = t673 + s13) →
          (ht730 : t730 = t729 + t663) →
          (ht731 : t731 = t730 + t646) →
          (hs13_4 : s13_4 = t731 + t655) →
          (hs13_5 : s13_5 = s13_4 + carry12) →
          (ht734 : t734 = carry12 <<< 21) →
          (hs12_6 : s12_6 = s12_5 - t734) →
          (ht736 : t736 = s14_3 + 1048576#64) →
          (hcarry14 : carry14 = t736.sshiftRight 21) →
          (hs15_3 : s15_3 = s15_2 + carry14) →
          (ht739 : t739 = carry14 <<< 21) →
          (hs14_4 : s14_4 = s14_3 - t739) →
          (ht741 : t741 = s16_1 + 1048576#64) →
          (hcarry16 : carry16 = t741.sshiftRight 21) →
          (hs17_1 : s17_1 = carry16 + s17) →
          (ht744 : t744 = carry16 <<< 21) →
          (hs16_2 : s16_2 = s16_1 - t744) →
          (ht746 : t746 = s7_3 + 1048576#64) →
          (hcarry7 : carry7 = t746 >>> 21) →
          (hs8_5 : s8_5 = s8_4 + carry7) →
          (ht749 : t749 = carry7 <<< 21) →
          (hs7_4 : s7_4 = s7_3 - t749) →
          (ht751 : t751 = s9_5 + 1048576#64) →
          (hcarry9 : carry9 = t751.sshiftRight 21) →
          (ht753 : t753 = carry9 <<< 21) →
          (ht754 : t754 = s11_7 + 1048576#64) →
          (hcarry11 : carry11 = t754.sshiftRight 21) →
          (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) →
          (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) →
          (hbs10_6 : Bnd s10_6 (-1048576) 1048575) →
          (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) →
          (hbs12_6 : Bnd s12_6 (-1048576) 1048575) →
          (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) →
          (hbs14_4 : Bnd s14_4 (-1048576) 1048575) →
          (hbs17_1 : Bnd s17_1 (-175078656) 2097152) →
          (hbs16_2 : Bnd s16_2 (-1048576) 1048575) →
          (hbs8_5 : Bnd s8_5 (-1048576) 2185515) →
          (hbs7_4 : Bnd s7_4 (-1048576) 1048575) →
          (hbcarry9 : Bnd carry9 (-997805) 1791123) →
          (hbt753 : Bnd t753 (-2092548751360) 3756257181696) →
          (hbcarry11 : Bnd carry11 (-1681706) 171921745) → (blk.runBodyFrom E' 225 S >>= g) = K) :
    (blk.runBodyFrom E 180 S >>= g) = K := by
  step_pure [nswAdd] with t711
  bnd_ext t711
  step_pure [nswAdd] with s9_4
  bnd_ext s9_4
  step_pure [nswAdd] with s9_5
  bnd_ext s9_5
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry8 (by decide))) with
    t714
  bnd_ext t714
  step_pure with s8_4
  bnd_ext s8_4
  step_pure [nswAdd] with t716
  bnd_ext t716
  step_pure with carry10
  bnd_ext carry10
  step_pure [nswAdd] with t718
  bnd_ext t718
  step_pure [nswAdd] with t719
  bnd_ext t719
  step_pure [nswAdd] with t720
  bnd_ext t720
  step_pure [nswAdd] with t721
  bnd_ext t721
  step_pure [nswAdd] with t722
  bnd_ext t722
  step_pure [nswAdd] with s11_6
  bnd_ext s11_6
  step_pure [nswAdd] with s11_7
  bnd_ext s11_7
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry10 (by decide))) with
    t725
  bnd_ext t725
  step_pure with s10_6
  bnd_ext s10_6
  step_pure [nswAdd] with t727
  bnd_ext t727
  step_pure with carry12
  bnd_ext carry12
  step_pure [nswAdd] with t729
  bnd_ext t729
  step_pure [nswAdd] with t730
  bnd_ext t730
  step_pure [nswAdd] with t731
  bnd_ext t731
  step_pure [nswAdd] with s13_4
  bnd_ext s13_4
  step_pure [nswAdd] with s13_5
  bnd_ext s13_5
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry12 (by decide))) with
    t734
  bnd_ext t734
  step_pure [nswSub] with s12_6
  bnd_ext s12_6
  step_pure [nswAdd] with t736
  bnd_ext t736
  step_pure with carry14
  bnd_ext carry14
  step_pure [nswAdd] with s15_3
  bnd_ext s15_3
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry14 (by decide))) with
    t739
  bnd_ext t739
  step_pure [nswSub] with s14_4
  bnd_ext s14_4
  step_pure [nswAdd] with t741
  bnd_ext t741
  step_pure with carry16
  bnd_ext carry16
  step_pure [nswAdd] with s17_1
  bnd_ext s17_1
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry16 (by decide))) with
    t744
  bnd_ext t744
  step_pure [nswSub] with s16_2
  bnd_ext s16_2
  step_pure [nswAdd, nuwAdd] with t746
  bnd_ext t746
  step_pure with carry7
  bnd_ext carry7
  step_pure [nswAdd] with s8_5
  bnd_ext s8_5
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry7 (by decide))) with
    t749
  bnd_ext t749
  step_pure with s7_4
  bnd_ext s7_4
  step_pure [nswAdd] with t751
  bnd_ext t751
  step_pure with carry9
  bnd_ext carry9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry9 (by decide))) with
    t753
  bnd_ext t753
  step_pure [nswAdd] with t754
  bnd_ext t754
  step_pure with carry11
  bnd_ext carry11
  subst hS
  exact
    hK _ t711 s9_4 s9_5 t714 s8_4 t716 carry10 t718 t719 t720 t721 t722 s11_6 s11_7 t725 s10_6 t727
      carry12 t729 t730 t731 s13_4 s13_5 t734 s12_6 t736 carry14 s15_3 t739 s14_4 t741 carry16 s17_1
      t744 s16_2 t746 carry7 s8_5 t749 s7_4 t751 carry9 t753 t754 carry11 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht711 hs9_4 hs9_5 ht714 hs8_4 ht716 hcarry10 ht718 ht719 ht720 ht721 ht722
      hs11_6 hs11_7 ht725 hs10_6 ht727 hcarry12 ht729 ht730 ht731 hs13_4 hs13_5 ht734 hs12_6 ht736
      hcarry14 hs15_3 ht739 hs14_4 ht741 hcarry16 hs17_1 ht744 hs16_2 ht746 hcarry7 hs8_5 ht749
      hs7_4 ht751 hcarry9 ht753 ht754 hcarry11 hbs9_5 hbs11_7 hbs10_6 hbs13_5 hbs12_6 hbs15_3
      hbs14_4 hbs17_1 hbs16_2 hbs8_5 hbs7_4 hbcarry9 hbt753 hbcarry11

/-- `^bb0` from instruction 225 to 270: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run225 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 225 = x25519_sc_reduce.entry.body.drop 225) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6_2 s9_5 s11_7 s10_6 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s8_5 s7_4 carry9
      t753 carry11 t754 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %572 := s4, %576 := s5, %706 := s6_2,
        %713 := s9_5, %724 := s11_7, %726 := s10_6, %733 := s13_5, %735 := s12_6, %738 := s15_3,
        %740 := s14_4, %743 := s17_1, %745 := s16_2, %748 := s8_5, %750 := s7_4, %752 := carry9,
        %753 := t753, %755 := carry11, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64,
        %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (ht754 : s11_7 + 1048576#64 = t754) (hcarry11 : t754.sshiftRight 21 = carry11)
    (hbs4 : Bnd s4 0 2097151) (hbs5 : Bnd s5 0 2097151) (hbs6_2 : Bnd s6_2 (-1048576) 1048575)
    (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) (hbs10_6 : Bnd s10_6 (-1048576) 1048575)
    (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) (hbs12_6 : Bnd s12_6 (-1048576) 1048575)
    (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) (hbs14_4 : Bnd s14_4 (-1048576) 1048575)
    (hbs17_1 : Bnd s17_1 (-175078656) 2097152) (hbs16_2 : Bnd s16_2 (-1048576) 1048575)
    (hbs8_5 : Bnd s8_5 (-1048576) 2185515) (hbs7_4 : Bnd s7_4 (-1048576) 1048575)
    (hbcarry9 : Bnd carry9 (-997805) 1791123) (hbcarry11 : Bnd carry11 (-1681706) 171921745)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (s12_7 t757 s11_8 t759 carry13 s14_5 t762 s13_6 t764 carry15 s16_3 t767 s15_4 t769 s5_1 t771
          s6_3 t773 s7_5 t775 s8_6 t777 t778 t779 s10_8 t781 s4_1 t783 s5_2 t785 s6_4 t787 s7_6 t789
          s8_7 t791 t792 t793 t794 t795 t796 s7_7 t798 s8_8 t800 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %713 := s9_5, %753 := t753,
              %756 := s12_7, %758 := s11_8, %761 := s14_5, %763 := s13_6, %777 := t777, %780 :=
              s10_8, %782 := s4_1, %784 := s5_2, %786 := s6_4, %791 := t791, %792 := t792, %793 :=
              t793, %794 := t794, %795 := t795, %797 := s7_7, %799 := s8_8, %800 := t800, %557 :=
              p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 :=
              p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 :=
              p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64]) →
          (hs12_7 : s12_7 = carry11 + s12_6) →
          (ht757 : t757 = carry11 <<< 21) →
          (hs11_8 : s11_8 = s11_7 - t757) →
          (ht759 : t759 = s13_5 + 1048576#64) →
          (hcarry13 : carry13 = t759.sshiftRight 21) →
          (hs14_5 : s14_5 = carry13 + s14_4) →
          (ht762 : t762 = carry13 <<< 21) →
          (hs13_6 : s13_6 = s13_5 - t762) →
          (ht764 : t764 = s15_3 + 1048576#64) →
          (hcarry15 : carry15 = t764.sshiftRight 21) →
          (hs16_3 : s16_3 = carry15 + s16_2) →
          (ht767 : t767 = carry15 <<< 21) →
          (hs15_4 : s15_4 = s15_3 - t767) →
          (ht769 : t769 = s17_1 * 666643#64) →
          (hs5_1 : s5_1 = t769 + s5) →
          (ht771 : t771 = s17_1 * 470296#64) →
          (hs6_3 : s6_3 = s6_2 + t771) →
          (ht773 : t773 = s17_1 * 654183#64) →
          (hs7_5 : s7_5 = s7_4 + t773) →
          (ht775 : t775 = s17_1 * 18446744073708553811#64) →
          (hs8_6 : s8_6 = s8_5 + t775) →
          (ht777 : t777 = s17_1 * 136657#64) →
          (ht778 : t778 = s17_1 * 18446744073708867715#64) →
          (ht779 : t779 = s10_6 + t778) →
          (hs10_8 : s10_8 = t779 + carry9) →
          (ht781 : t781 = s16_3 * 666643#64) →
          (hs4_1 : s4_1 = t781 + s4) →
          (ht783 : t783 = s16_3 * 470296#64) →
          (hs5_2 : s5_2 = s5_1 + t783) →
          (ht785 : t785 = s16_3 * 654183#64) →
          (hs6_4 : s6_4 = s6_3 + t785) →
          (ht787 : t787 = s16_3 * 18446744073708553811#64) →
          (hs7_6 : s7_6 = s7_5 + t787) →
          (ht789 : t789 = s16_3 * 136657#64) →
          (hs8_7 : s8_7 = s8_6 + t789) →
          (ht791 : t791 = s16_3 * 18446744073708867715#64) →
          (ht792 : t792 = s15_4 * 666643#64) →
          (ht793 : t793 = s15_4 * 470296#64) →
          (ht794 : t794 = s15_4 * 654183#64) →
          (ht795 : t795 = s15_4 * 18446744073708553811#64) →
          (ht796 : t796 = s15_4 * 136657#64) →
          (hs7_7 : s7_7 = s7_6 + t796) →
          (ht798 : t798 = s15_4 * 18446744073708867715#64) →
          (hs8_8 : s8_8 = s8_7 + t798) →
          (ht800 : t800 = s14_5 * 666643#64) →
          (hbs12_7 : Bnd s12_7 (-2730282) 172970320) →
          (hbs11_8 : Bnd s11_8 (-1048576) 1048575) →
          (hbs14_5 : Bnd s14_5 (-2730282) 168656138) →
          (hbs13_6 : Bnd s13_6 (-1048576) 1048575) →
          (hbt777 : Bnd t777 (-23925723892992) 286590500864) →
          (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754) →
          (hbs4_1 : Bnd s4_1 (-1155024995157) 24020994654975) →
          (hbs5_2 : Bnd s5_2 (-117529794851112) 18344120457215) →
          (hbs6_4 : Bnd s6_4 (-83472229462369) 24558307514111) →
          (hbt791 : Bnd t791 (-24642846067968) 1184926188699) →
          (hbt792 : Bnd t792 (-699025850368) 699025183725) →
          (hbt793 : Bnd t793 (-493141098496) 493140628200) →
          (hbt794 : Bnd t794 (-685960593408) 685959939225) →
          (hbt795 : Bnd t795 (-1046273377875) 1046274375680) →
          (hbs7_7 : Bnd s7_7 (-150630452791296) 3244013294361) →
          (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147) →
          (hbt800 : Bnd t800 (-1820123383326) 112433433804734) →
          (blk.runBodyFrom E' 270 S >>= g) = K) :
    (blk.runBodyFrom E 225 S >>= g) = K := by
  step_pure [nswAdd] with s12_7
  bnd_ext s12_7
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry11 (by decide))) with
    t757
  bnd_ext t757
  step_pure [nswSub] with s11_8
  bnd_ext s11_8
  step_pure [nswAdd] with t759
  bnd_ext t759
  step_pure with carry13
  bnd_ext carry13
  step_pure [nswAdd] with s14_5
  bnd_ext s14_5
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry13 (by decide))) with
    t762
  bnd_ext t762
  step_pure [nswSub] with s13_6
  bnd_ext s13_6
  step_pure [nswAdd] with t764
  bnd_ext t764
  step_pure with carry15
  bnd_ext carry15
  step_pure [nswAdd] with s16_3
  bnd_ext s16_3
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry15 (by decide))) with
    t767
  bnd_ext t767
  step_pure [nswSub] with s15_4
  bnd_ext s15_4
  step_pure [nswMul] with t769
  bnd_ext t769
  step_pure [nswAdd] with s5_1
  bnd_ext s5_1
  step_pure [nswMul] with t771
  bnd_ext t771
  step_pure [nswAdd] with s6_3
  bnd_ext s6_3
  step_pure [nswMul] with t773
  bnd_ext t773
  step_pure [nswAdd] with s7_5
  bnd_ext s7_5
  step_pure [nswMul] with t775
  bnd_ext t775
  step_pure with s8_6
  bnd_ext s8_6
  step_pure [nswMul] with t777
  bnd_ext t777
  step_pure [nswMul] with t778
  bnd_ext t778
  step_pure with t779
  bnd_ext t779
  step_pure with s10_8
  bnd_ext s10_8
  step_pure [nswMul] with t781
  bnd_ext t781
  step_pure [nswAdd] with s4_1
  bnd_ext s4_1
  step_pure [nswMul] with t783
  bnd_ext t783
  step_pure [nswAdd] with s5_2
  bnd_ext s5_2
  step_pure [nswMul] with t785
  bnd_ext t785
  step_pure [nswAdd] with s6_4
  bnd_ext s6_4
  step_pure with t787
  bnd_ext t787
  step_pure with s7_6
  bnd_ext s7_6
  step_pure [nswMul] with t789
  bnd_ext t789
  step_pure [nswAdd] with s8_7
  bnd_ext s8_7
  step_pure with t791
  bnd_ext t791
  step_pure [nswMul] with t792
  bnd_ext t792
  step_pure [nswMul] with t793
  bnd_ext t793
  step_pure [nswMul] with t794
  bnd_ext t794
  step_pure with t795
  bnd_ext t795
  step_pure [nswMul] with t796
  bnd_ext t796
  step_pure [nswAdd] with s7_7
  bnd_ext s7_7
  step_pure with t798
  bnd_ext t798
  step_pure with s8_8
  bnd_ext s8_8
  step_pure [nswMul] with t800
  bnd_ext t800
  subst hS
  exact
    hK _ s12_7 t757 s11_8 t759 carry13 s14_5 t762 s13_6 t764 carry15 s16_3 t767 s15_4 t769 s5_1 t771
      s6_3 t773 s7_5 t775 s8_6 t777 t778 t779 s10_8 t781 s4_1 t783 s5_2 t785 s6_4 t787 s7_6 t789
      s8_7 t791 t792 t793 t794 t795 t796 s7_7 t798 s8_8 t800 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) hs12_7 ht757 hs11_8 ht759 hcarry13 hs14_5 ht762 hs13_6 ht764 hcarry15 hs16_3
      ht767 hs15_4 ht769 hs5_1 ht771 hs6_3 ht773 hs7_5 ht775 hs8_6 ht777 ht778 ht779 hs10_8 ht781
      hs4_1 ht783 hs5_2 ht785 hs6_4 ht787 hs7_6 ht789 hs8_7 ht791 ht792 ht793 ht794 ht795 ht796
      hs7_7 ht798 hs8_8 ht800 hbs12_7 hbs11_8 hbs14_5 hbs13_6 hbt777 hbs10_8 hbs4_1 hbs5_2 hbs6_4
      hbt791 hbt792 hbt793 hbt794 hbt795 hbs7_7 hbs8_8 hbt800

/-- `^bb0` from instruction 270 to 315: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run270 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 270 = x25519_sc_reduce.entry.body.drop 270) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s9_5 t753 s12_7 s11_8 s14_5 s13_6 t777 s10_8 s4_1 s5_2 s6_4 t791 t792 t793 t794
      t795 s7_7 s8_8 t800 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%556 := s0, %560 := s1, %564 := s2, %568 := s3, %713 := s9_5, %753 := t753, %756 :=
        s12_7, %758 := s11_8, %761 := s14_5, %763 := s13_6, %777 := t777, %780 := s10_8, %782 :=
        s4_1, %784 := s5_2, %786 := s6_4, %791 := t791, %792 := t792, %793 := t793, %794 := t794,
        %795 := t795, %797 := s7_7, %799 := s8_8, %800 := t800, %557 := p.add 2#64, %561 :=
        p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 :=
        p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 :=
        p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64])
    (hbs0 : Bnd s0 0 2097151) (hbs1 : Bnd s1 0 2097151) (hbs2 : Bnd s2 0 2097151)
    (hbs3 : Bnd s3 0 2097151) (hbs12_7 : Bnd s12_7 (-2730282) 172970320)
    (hbs14_5 : Bnd s14_5 (-2730282) 168656138) (hbs13_6 : Bnd s13_6 (-1048576) 1048575)
    (hbs4_1 : Bnd s4_1 (-1155024995157) 24020994654975)
    (hbs6_4 : Bnd s6_4 (-83472229462369) 24558307514111)
    (hbt792 : Bnd t792 (-699025850368) 699025183725)
    (hbt793 : Bnd t793 (-493141098496) 493140628200)
    (hbt795 : Bnd t795 (-1046273377875) 1046274375680)
    (hbs7_7 : Bnd s7_7 (-150630452791296) 3244013294361)
    (hbt800 : Bnd t800 (-1820123383326) 112433433804734)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t801 t802 t803 t804 t805 s7_8 t807 s1_1 t809 t810 t811 t812 t813 t814 t815 s6_7 t817 s0_1
          t819 s1_2 t821 t822 s2_2 s2_3 t825 t826 t827 t828 s4_4 s4_5 t831 t832 carry0 s1_3 t835
          s0_2 t837 carry2 t839 t840 s3_3 s3_4 s3_5 t844 t845 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%713 := s9_5, %753 := t753, %758 := s11_8, %777 := t777, %780 := s10_8, %784 :=
              s5_2, %791 := t791, %794 := t794, %799 := s8_8, %803 := t803, %806 := s7_8, %812 :=
              t812, %816 := s6_7, %824 := s2_3, %830 := s4_5, %831 := t831, %834 := s1_3, %836 :=
              s0_2, %843 := s3_5, %844 := t844, %845 := t845, %557 := p.add 2#64, %561 :=
              p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 :=
              p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 :=
              p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64]) →
          (ht801 : t801 = s14_5 * 470296#64) →
          (ht802 : t802 = s14_5 * 654183#64) →
          (ht803 : t803 = s14_5 * 18446744073708553811#64) →
          (ht804 : t804 = s14_5 * 136657#64) →
          (ht805 : t805 = s14_5 * 18446744073708867715#64) →
          (hs7_8 : s7_8 = s7_7 + t805) →
          (ht807 : t807 = s13_6 * 666643#64) →
          (hs1_1 : s1_1 = t807 + s1) →
          (ht809 : t809 = s13_6 * 470296#64) →
          (ht810 : t810 = s13_6 * 654183#64) →
          (ht811 : t811 = s13_6 * 18446744073708553811#64) →
          (ht812 : t812 = s13_6 * 136657#64) →
          (ht813 : t813 = s13_6 * 18446744073708867715#64) →
          (ht814 : t814 = s6_4 + t813) →
          (ht815 : t815 = t814 + t795) →
          (hs6_7 : s6_7 = t815 + t804) →
          (ht817 : t817 = s12_7 * 666643#64) →
          (hs0_1 : s0_1 = t817 + s0) →
          (ht819 : t819 = s12_7 * 470296#64) →
          (hs1_2 : s1_2 = s1_1 + t819) →
          (ht821 : t821 = s12_7 * 654183#64) →
          (ht822 : t822 = t809 + s2) →
          (hs2_2 : s2_2 = t822 + t800) →
          (hs2_3 : s2_3 = s2_2 + t821) →
          (ht825 : t825 = s12_7 * 18446744073708553811#64) →
          (ht826 : t826 = s12_7 * 136657#64) →
          (ht827 : t827 = s4_1 + t811) →
          (ht828 : t828 = t827 + t793) →
          (hs4_4 : s4_4 = t828 + t802) →
          (hs4_5 : s4_5 = s4_4 + t826) →
          (ht831 : t831 = s12_7 * 18446744073708867715#64) →
          (ht832 : t832 = s0_1 + 1048576#64) →
          (hcarry0 : carry0 = t832.sshiftRight 21) →
          (hs1_3 : s1_3 = s1_2 + carry0) →
          (ht835 : t835 = carry0 <<< 21) →
          (hs0_2 : s0_2 = s0_1 - t835) →
          (ht837 : t837 = s2_3 + 1048576#64) →
          (hcarry2 : carry2 = t837.sshiftRight 21) →
          (ht839 : t839 = t810 + s3) →
          (ht840 : t840 = t839 + t792) →
          (hs3_3 : s3_3 = t840 + t801) →
          (hs3_4 : s3_4 = s3_3 + t825) →
          (hs3_5 : s3_5 = s3_4 + carry2) →
          (ht844 : t844 = carry2 <<< 21) →
          (ht845 : t845 = s4_5 + 1048576#64) →
          (hbt803 : Bnd t803 (-168285937777090) 2724289031010) →
          (hbs7_8 : Bnd s7_8 (-265974554225634) 5111255884443) →
          (hbt812 : Bnd t812 (-143295250432) 143295113775) →
          (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433) →
          (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645) →
          (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349) →
          (hbt831 : Bnd t831 (-118294574818320) 1867242590082) →
          (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) →
          (hbs0_2 : Bnd s0_2 (-1048576) 1048575) →
          (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) →
          (hbt844 : Bnd t844 (-4099368026112) 226080818462720) →
          (hbt845 : Bnd t845 (-4853654639832) 159529994052925) →
          (blk.runBodyFrom E' 315 S >>= g) = K) :
    (blk.runBodyFrom E 270 S >>= g) = K := by
  step_pure [nswMul] with t801
  bnd_ext t801
  step_pure [nswMul] with t802
  bnd_ext t802
  step_pure with t803
  bnd_ext t803
  step_pure [nswMul] with t804
  bnd_ext t804
  step_pure with t805
  bnd_ext t805
  step_pure with s7_8
  bnd_ext s7_8
  step_pure [nswMul] with t807
  bnd_ext t807
  step_pure [nswAdd] with s1_1
  bnd_ext s1_1
  step_pure [nswMul] with t809
  bnd_ext t809
  step_pure [nswMul] with t810
  bnd_ext t810
  step_pure with t811
  bnd_ext t811
  step_pure [nswMul] with t812
  bnd_ext t812
  step_pure with t813
  bnd_ext t813
  step_pure with t814
  bnd_ext t814
  step_pure with t815
  bnd_ext t815
  step_pure with s6_7
  bnd_ext s6_7
  step_pure [nswMul] with t817
  bnd_ext t817
  step_pure [nswAdd] with s0_1
  bnd_ext s0_1
  step_pure [nswMul] with t819
  bnd_ext t819
  step_pure [nswAdd] with s1_2
  bnd_ext s1_2
  step_pure [nswMul] with t821
  bnd_ext t821
  step_pure with t822
  bnd_ext t822
  step_pure with s2_2
  bnd_ext s2_2
  step_pure [nswAdd] with s2_3
  bnd_ext s2_3
  step_pure with t825
  bnd_ext t825
  step_pure [nswMul] with t826
  bnd_ext t826
  step_pure with t827
  bnd_ext t827
  step_pure with t828
  bnd_ext t828
  step_pure with s4_4
  bnd_ext s4_4
  step_pure [nswAdd] with s4_5
  bnd_ext s4_5
  step_pure with t831
  bnd_ext t831
  step_pure [nswAdd] with t832
  bnd_ext t832
  step_pure with carry0
  bnd_ext carry0
  step_pure [nswAdd] with s1_3
  bnd_ext s1_3
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry0 (by decide))) with
    t835
  bnd_ext t835
  step_pure [nswSub] with s0_2
  bnd_ext s0_2
  step_pure [nswAdd] with t837
  bnd_ext t837
  step_pure with carry2
  bnd_ext carry2
  step_pure with t839
  bnd_ext t839
  step_pure with t840
  bnd_ext t840
  step_pure with s3_3
  bnd_ext s3_3
  step_pure with s3_4
  bnd_ext s3_4
  step_pure [nswAdd] with s3_5
  bnd_ext s3_5
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry2 (by decide))) with
    t844
  bnd_ext t844
  step_pure [nswAdd] with t845
  bnd_ext t845
  subst hS
  exact
    hK _ t801 t802 t803 t804 t805 s7_8 t807 s1_1 t809 t810 t811 t812 t813 t814 t815 s6_7 t817 s0_1
      t819 s1_2 t821 t822 s2_2 s2_3 t825 t826 t827 t828 s4_4 s4_5 t831 t832 carry0 s1_3 t835 s0_2
      t837 carry2 t839 t840 s3_3 s3_4 s3_5 t844 t845 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht801 ht802 ht803 ht804 ht805 hs7_8 ht807 hs1_1 ht809 ht810 ht811 ht812 ht813
      ht814 ht815 hs6_7 ht817 hs0_1 ht819 hs1_2 ht821 ht822 hs2_2 hs2_3 ht825 ht826 ht827 ht828
      hs4_4 hs4_5 ht831 ht832 hcarry0 hs1_3 ht835 hs0_2 ht837 hcarry2 ht839 ht840 hs3_3 hs3_4 hs3_5
      ht844 ht845 hbt803 hbs7_8 hbt812 hbs6_7 hbs2_3 hbs4_5 hbt831 hbs1_3 hbs0_2 hbs3_5 hbt844
      hbt845

/-- `^bb0` from instruction 315 to 360: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run315 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 315 = x25519_sc_reduce.entry.body.drop 315) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s9_5 t753 s11_8 t777 s10_8 s5_2 t791 t794 s8_8 t803 s7_8 t812 s6_7 s2_3 s4_5 t831 s1_3 s0_2
      s3_5 t844 t845 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%713 := s9_5, %753 := t753, %758 := s11_8, %777 := t777, %780 := s10_8, %784 := s5_2,
        %791 := t791, %794 := t794, %799 := s8_8, %803 := t803, %806 := s7_8, %812 := t812, %816 :=
        s6_7, %824 := s2_3, %830 := s4_5, %831 := t831, %834 := s1_3, %836 := s0_2, %843 := s3_5,
        %844 := t844, %845 := t845, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64,
        %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbt753 : Bnd t753 (-2092548751360) 3756257181696) (hbs11_8 : Bnd s11_8 (-1048576) 1048575)
    (hbt777 : Bnd t777 (-23925723892992) 286590500864)
    (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754)
    (hbs5_2 : Bnd s5_2 (-117529794851112) 18344120457215)
    (hbt791 : Bnd t791 (-24642846067968) 1184926188699)
    (hbt794 : Bnd t794 (-685960593408) 685959939225)
    (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147)
    (hbt803 : Bnd t803 (-168285937777090) 2724289031010)
    (hbs7_8 : Bnd s7_8 (-265974554225634) 5111255884443)
    (hbt812 : Bnd t812 (-143295250432) 143295113775)
    (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433)
    (hbt831 : Bnd t831 (-118294574818320) 1867242590082)
    (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694)
    (hbt845 : Bnd t845 (-4853654639832) 159529994052925)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (carry4 t847 t848 s5_5 s5_6 s5_7 t852 t853 carry6_1 s7_9 t856 s6_8 t858 carry8_1 t860 s9_7
          s9_8 s9_9 t864 s8_9 t866 carry10_1 s11_9 t869 s10_9 t871 carry1 t873 t874 carry3 t876 t877
          carry5 s6_9 t880 t881 carry7_1 s8_10 t884 s7_10 t886 carry9_1 s10_10 t889 s9_10 :
          BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%824 := s2_3, %830 := s4_5, %834 := s1_3, %836 := s0_2, %843 := s3_5, %844 :=
              t844, %851 := s5_7, %852 := t852, %868 := s11_9, %872 := carry1, %873 := t873, %875 :=
              carry3, %876 := t876, %879 := s6_9, %880 := t880, %883 := s8_10, %885 := s7_10,
              %888 := s10_10, %890 := s9_10, %557 := p.add 2#64, %561 := p.add 5#64, %565 :=
              p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 :=
              p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 :=
              p.add 28#64, %599 := p.add 31#64]) →
          (hcarry4 : carry4 = t845.sshiftRight 21) →
          (ht847 : t847 = s5_2 + t812) →
          (ht848 : t848 = t847 + t794) →
          (hs5_5 : s5_5 = t848 + t803) →
          (hs5_6 : s5_6 = s5_5 + t831) →
          (hs5_7 : s5_7 = s5_6 + carry4) →
          (ht852 : t852 = carry4 <<< 21) →
          (ht853 : t853 = s6_7 + 1048576#64) →
          (hcarry6_1 : carry6_1 = t853.sshiftRight 21) →
          (hs7_9 : s7_9 = s7_8 + carry6_1) →
          (ht856 : t856 = carry6_1 <<< 21) →
          (hs6_8 : s6_8 = s6_7 - t856) →
          (ht858 : t858 = s8_8 + 1048576#64) →
          (hcarry8_1 : carry8_1 = t858.sshiftRight 21) →
          (ht860 : t860 = t777 + s9_5) →
          (hs9_7 : s9_7 = t860 - t753) →
          (hs9_8 : s9_8 = s9_7 + t791) →
          (hs9_9 : s9_9 = s9_8 + carry8_1) →
          (ht864 : t864 = carry8_1 <<< 21) →
          (hs8_9 : s8_9 = s8_8 - t864) →
          (ht866 : t866 = s10_8 + 1048576#64) →
          (hcarry10_1 : carry10_1 = t866.sshiftRight 21) →
          (hs11_9 : s11_9 = carry10_1 + s11_8) →
          (ht869 : t869 = carry10_1 <<< 21) →
          (hs10_9 : s10_9 = s10_8 - t869) →
          (ht871 : t871 = s1_3 + 1048576#64) →
          (hcarry1 : carry1 = t871.sshiftRight 21) →
          (ht873 : t873 = carry1 <<< 21) →
          (ht874 : t874 = s3_5 + 1048576#64) →
          (hcarry3 : carry3 = t874.sshiftRight 21) →
          (ht876 : t876 = carry3 <<< 21) →
          (ht877 : t877 = s5_7 + 1048576#64) →
          (hcarry5 : carry5 = t877.sshiftRight 21) →
          (hs6_9 : s6_9 = s6_8 + carry5) →
          (ht880 : t880 = carry5 <<< 21) →
          (ht881 : t881 = s7_9 + 1048576#64) →
          (hcarry7_1 : carry7_1 = t881.sshiftRight 21) →
          (hs8_10 : s8_10 = s8_9 + carry7_1) →
          (ht884 : t884 = carry7_1 <<< 21) →
          (hs7_10 : s7_10 = s7_9 - t884) →
          (ht886 : t886 = s9_9 + 1048576#64) →
          (hcarry9_1 : carry9_1 = t886.sshiftRight 21) →
          (hs10_10 : s10_10 = s10_9 + carry9_1) →
          (ht889 : t889 = carry9_1 <<< 21) →
          (hs9_10 : s9_10 = s9_9 - t889) →
          (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136) →
          (hbt852 : Bnd t852 (-4853654880256) 159529994027008) →
          (hbs11_9 : Bnd s11_9 (-1732478) 58143373) →
          (hbcarry1 : Bnd carry1 (-945600) 39122740) →
          (hbt873 : Bnd t873 (-1983066931200) 82046332436480) →
          (hbcarry3 : Bnd carry3 (-83570327) 39781423) →
          (hbt876 : Bnd t876 (-175259678408704) 83427690807296) →
          (hbs6_9 : Bnd s6_9 (-194138808) 12380602) →
          (hbt880 : Bnd t880 (-404939566219264) 23764983087104) →
          (hbs8_10 : Bnd s8_10 (-127875146) 3485823) →
          (hbs7_10 : Bnd s7_10 (-1048576) 1048575) →
          (hbs10_10 : Bnd s10_10 (-26996803) 4539218) →
          (hbs9_10 : Bnd s9_10 (-1048576) 1048575) → (blk.runBodyFrom E' 360 S >>= g) = K) :
    (blk.runBodyFrom E 315 S >>= g) = K := by
  step_pure with carry4
  bnd_ext carry4
  step_pure with t847
  bnd_ext t847
  step_pure with t848
  bnd_ext t848
  step_pure with s5_5
  bnd_ext s5_5
  step_pure with s5_6
  bnd_ext s5_6
  step_pure [nswAdd] with s5_7
  bnd_ext s5_7
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry4 (by decide))) with
    t852
  bnd_ext t852
  step_pure [nswAdd] with t853
  bnd_ext t853
  step_pure with carry6_1
  bnd_ext carry6_1
  step_pure [nswAdd] with s7_9
  bnd_ext s7_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry6_1 (by decide))) with
    t856
  bnd_ext t856
  step_pure with s6_8
  bnd_ext s6_8
  step_pure [nswAdd] with t858
  bnd_ext t858
  step_pure with carry8_1
  bnd_ext carry8_1
  step_pure [nswAdd] with t860
  bnd_ext t860
  step_pure with s9_7
  bnd_ext s9_7
  step_pure with s9_8
  bnd_ext s9_8
  step_pure [nswAdd] with s9_9
  bnd_ext s9_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry8_1 (by decide))) with
    t864
  bnd_ext t864
  step_pure with s8_9
  bnd_ext s8_9
  step_pure [nswAdd] with t866
  bnd_ext t866
  step_pure with carry10_1
  bnd_ext carry10_1
  step_pure [nswAdd] with s11_9
  bnd_ext s11_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry10_1 (by decide))) with
    t869
  bnd_ext t869
  step_pure with s10_9
  bnd_ext s10_9
  step_pure [nswAdd] with t871
  bnd_ext t871
  step_pure with carry1
  bnd_ext carry1
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry1 (by decide))) with
    t873
  bnd_ext t873
  step_pure [nswAdd] with t874
  bnd_ext t874
  step_pure with carry3
  bnd_ext carry3
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry3 (by decide))) with
    t876
  bnd_ext t876
  step_pure [nswAdd] with t877
  bnd_ext t877
  step_pure with carry5
  bnd_ext carry5
  step_pure [nswAdd] with s6_9
  bnd_ext s6_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry5 (by decide))) with
    t880
  bnd_ext t880
  step_pure [nswAdd] with t881
  bnd_ext t881
  step_pure with carry7_1
  bnd_ext carry7_1
  step_pure [nswAdd] with s8_10
  bnd_ext s8_10
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry7_1 (by decide))) with
    t884
  bnd_ext t884
  step_pure [nswSub] with s7_10
  bnd_ext s7_10
  step_pure [nswAdd] with t886
  bnd_ext t886
  step_pure with carry9_1
  bnd_ext carry9_1
  step_pure [nswAdd] with s10_10
  bnd_ext s10_10
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry9_1 (by decide))) with
    t889
  bnd_ext t889
  step_pure [nswSub] with s9_10
  bnd_ext s9_10
  subst hS
  exact
    hK _ carry4 t847 t848 s5_5 s5_6 s5_7 t852 t853 carry6_1 s7_9 t856 s6_8 t858 carry8_1 t860 s9_7
      s9_8 s9_9 t864 s8_9 t866 carry10_1 s11_9 t869 s10_9 t871 carry1 t873 t874 carry3 t876 t877
      carry5 s6_9 t880 t881 carry7_1 s8_10 t884 s7_10 t886 carry9_1 s10_10 t889 s9_10 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) hcarry4 ht847 ht848 hs5_5 hs5_6 hs5_7 ht852 ht853 hcarry6_1 hs7_9 ht856 hs6_8
      ht858 hcarry8_1 ht860 hs9_7 hs9_8 hs9_9 ht864 hs8_9 ht866 hcarry10_1 hs11_9 ht869 hs10_9 ht871
      hcarry1 ht873 ht874 hcarry3 ht876 ht877 hcarry5 hs6_9 ht880 ht881 hcarry7_1 hs8_10 ht884
      hs7_10 ht886 hcarry9_1 hs10_10 ht889 hs9_10 hbs5_7 hbt852 hbs11_9 hbcarry1 hbt873 hbcarry3
      hbt876 hbs6_9 hbt880 hbs8_10 hbs7_10 hbs10_10 hbs9_10

/-- `^bb0` from instruction 360 to 405: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run360 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 360 = x25519_sc_reduce.entry.body.drop 360) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s2_3 s4_5 s1_3 s0_2 s3_5 t844 s5_7 t852 s11_9 carry1 t873 carry3 t876 s6_9 t880 s8_10 s7_10
      s10_10 s9_10 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%824 := s2_3, %830 := s4_5, %834 := s1_3, %836 := s0_2, %843 := s3_5, %844 := t844,
        %851 := s5_7, %852 := t852, %868 := s11_9, %872 := carry1, %873 := t873, %875 := carry3,
        %876 := t876, %879 := s6_9, %880 := t880, %883 := s8_10, %885 := s7_10, %888 := s10_10,
        %890 := s9_10, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 :=
        p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645)
    (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349)
    (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) (hbs0_2 : Bnd s0_2 (-1048576) 1048575)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694)
    (hbt844 : Bnd t844 (-4099368026112) 226080818462720)
    (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136)
    (hbt852 : Bnd t852 (-4853654880256) 159529994027008) (hbs11_9 : Bnd s11_9 (-1732478) 58143373)
    (hbcarry1 : Bnd carry1 (-945600) 39122740) (hbt873 : Bnd t873 (-1983066931200) 82046332436480)
    (hbcarry3 : Bnd carry3 (-83570327) 39781423)
    (hbt876 : Bnd t876 (-175259678408704) 83427690807296) (hbs6_9 : Bnd s6_9 (-194138808) 12380602)
    (hbt880 : Bnd t880 (-404939566219264) 23764983087104)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t891 carry11_1 t893 s11_10 t895 s0_3 t897 t898 t899 t900 t901 carry0_1 t903 s1_5 s1_6 t906
          s0_4 carry1_1 t909 t910 s2_6 s2_7 t913 s1_7 carry2_1 t916 s3_7 s3_8 t919 s2_8 carry3_1
          t922 t923 s4_8 s4_9 t926 s3_9 carry4_1 t929 s5_9 s5_10 t932 s4_10 carry5_1 s6_10 :
          BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%883 := s8_10, %885 := s7_10, %888 := s10_10, %890 := s9_10, %894 := s11_10,
              %907 := s0_4, %914 := s1_7, %920 := s2_8, %927 := s3_9, %931 := s5_10, %933 := s4_10,
              %934 := carry5_1, %935 := s6_10, %557 := p.add 2#64, %561 := p.add 5#64, %565 :=
              p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 :=
              p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 :=
              p.add 28#64, %599 := p.add 31#64]) →
          (ht891 : t891 = s11_9 + 1048576#64) →
          (hcarry11_1 : carry11_1 = t891.sshiftRight 21) →
          (ht893 : t893 = carry11_1 <<< 21) →
          (hs11_10 : s11_10 = s11_9 - t893) →
          (ht895 : t895 = carry11_1 * 666643#64) →
          (hs0_3 : s0_3 = s0_2 + t895) →
          (ht897 : t897 = carry11_1 * 470296#64) →
          (ht898 : t898 = carry11_1 * 654183#64) →
          (ht899 : t899 = carry11_1 * 18446744073708553811#64) →
          (ht900 : t900 = carry11_1 * 136657#64) →
          (ht901 : t901 = carry11_1 * 18446744073708867715#64) →
          (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) →
          (ht903 : t903 = t897 - t873) →
          (hs1_5 : s1_5 = t903 + s1_3) →
          (hs1_6 : s1_6 = s1_5 + carry0_1) →
          (ht906 : t906 = carry0_1 <<< 21) →
          (hs0_4 : s0_4 = s0_3 - t906) →
          (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) →
          (ht909 : t909 = t898 - t844) →
          (ht910 : t910 = t909 + s2_3) →
          (hs2_6 : s2_6 = t910 + carry1) →
          (hs2_7 : s2_7 = s2_6 + carry1_1) →
          (ht913 : t913 = carry1_1 <<< 21) →
          (hs1_7 : s1_7 = s1_6 - t913) →
          (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) →
          (ht916 : t916 = t899 - t876) →
          (hs3_7 : s3_7 = t916 + s3_5) →
          (hs3_8 : s3_8 = s3_7 + carry2_1) →
          (ht919 : t919 = carry2_1 <<< 21) →
          (hs2_8 : s2_8 = s2_7 - t919) →
          (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) →
          (ht922 : t922 = t900 - t852) →
          (ht923 : t923 = t922 + s4_5) →
          (hs4_8 : s4_8 = t923 + carry3) →
          (hs4_9 : s4_9 = s4_8 + carry3_1) →
          (ht926 : t926 = carry3_1 <<< 21) →
          (hs3_9 : s3_9 = s3_8 - t926) →
          (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) →
          (ht929 : t929 = t901 - t880) →
          (hs5_9 : s5_9 = t929 + s5_7) →
          (hs5_10 : s5_10 = s5_9 + carry4_1) →
          (ht932 : t932 = carry4_1 <<< 21) →
          (hs4_10 : s4_10 = s4_9 - t932) →
          (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) →
          (hs6_10 : s6_10 = s6_9 + carry5_1) →
          (hbs11_10 : Bnd s11_10 (-1048576) 1048575) →
          (hbs0_4 : Bnd s0_4 0 2097151) →
          (hbs1_7 : Bnd s1_7 0 2097151) →
          (hbs2_8 : Bnd s2_8 0 2097151) →
          (hbs3_9 : Bnd s3_9 0 2097151) →
          (hbs5_10 : Bnd s5_10 (-428704646225429) 428704628488612) →
          (hbs4_10 : Bnd s4_10 0 2097151) →
          (hbcarry5_1 : Bnd carry5_1 (-204422306) 204422296) →
          (hbs6_10 : Bnd s6_10 (-398561114) 216802898) → (blk.runBodyFrom E' 405 S >>= g) = K) :
    (blk.runBodyFrom E 360 S >>= g) = K := by
  step_pure [nswAdd] with t891
  bnd_ext t891
  step_pure with carry11_1
  bnd_ext carry11_1
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry11_1 (by decide))) with
    t893
  bnd_ext t893
  step_pure [nswSub] with s11_10
  bnd_ext s11_10
  step_pure [nswMul] with t895
  bnd_ext t895
  step_pure [nswAdd] with s0_3
  bnd_ext s0_3
  step_pure [nswMul] with t897
  bnd_ext t897
  step_pure [nswMul] with t898
  bnd_ext t898
  step_pure [nswMul] with t899
  bnd_ext t899
  step_pure [nswMul] with t900
  bnd_ext t900
  step_pure [nswMul] with t901
  bnd_ext t901
  step_pure with carry0_1
  bnd_ext carry0_1
  step_pure with t903
  bnd_ext t903
  step_pure with s1_5
  bnd_ext s1_5
  step_pure [nswAdd] with s1_6
  bnd_ext s1_6
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry0_1 (by decide))) with
    t906
  bnd_ext t906
  step_pure [nswSub] with s0_4
  bnd_ext s0_4
  step_pure with carry1_1
  bnd_ext carry1_1
  step_pure with t909
  bnd_ext t909
  step_pure with t910
  bnd_ext t910
  step_pure with s2_6
  bnd_ext s2_6
  step_pure [nswAdd] with s2_7
  bnd_ext s2_7
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry1_1 (by decide))) with
    t913
  bnd_ext t913
  step_pure with s1_7
  bnd_ext s1_7
  step_pure with carry2_1
  bnd_ext carry2_1
  step_pure with t916
  bnd_ext t916
  step_pure with s3_7
  bnd_ext s3_7
  step_pure [nswAdd] with s3_8
  bnd_ext s3_8
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry2_1 (by decide))) with
    t919
  bnd_ext t919
  step_pure with s2_8
  bnd_ext s2_8
  step_pure with carry3_1
  bnd_ext carry3_1
  step_pure with t922
  bnd_ext t922
  step_pure with t923
  bnd_ext t923
  step_pure with s4_8
  bnd_ext s4_8
  step_pure [nswAdd] with s4_9
  bnd_ext s4_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry3_1 (by decide))) with
    t926
  bnd_ext t926
  step_pure with s3_9
  bnd_ext s3_9
  step_pure with carry4_1
  bnd_ext carry4_1
  step_pure with t929
  bnd_ext t929
  step_pure with s5_9
  bnd_ext s5_9
  step_pure [nswAdd] with s5_10
  bnd_ext s5_10
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry4_1 (by decide))) with
    t932
  bnd_ext t932
  step_pure with s4_10
  bnd_ext s4_10
  step_pure with carry5_1
  bnd_ext carry5_1
  step_pure [nswAdd] with s6_10
  bnd_ext s6_10
  subst hS
  exact
    hK _ t891 carry11_1 t893 s11_10 t895 s0_3 t897 t898 t899 t900 t901 carry0_1 t903 s1_5 s1_6 t906
      s0_4 carry1_1 t909 t910 s2_6 s2_7 t913 s1_7 carry2_1 t916 s3_7 s3_8 t919 s2_8 carry3_1 t922
      t923 s4_8 s4_9 t926 s3_9 carry4_1 t929 s5_9 s5_10 t932 s4_10 carry5_1 s6_10 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht891 hcarry11_1 ht893 hs11_10 ht895 hs0_3 ht897 ht898 ht899 ht900 ht901
      hcarry0_1 ht903 hs1_5 hs1_6 ht906 hs0_4 hcarry1_1 ht909 ht910 hs2_6 hs2_7 ht913 hs1_7
      hcarry2_1 ht916 hs3_7 hs3_8 ht919 hs2_8 hcarry3_1 ht922 ht923 hs4_8 hs4_9 ht926 hs3_9
      hcarry4_1 ht929 hs5_9 hs5_10 ht932 hs4_10 hcarry5_1 hs6_10 hbs11_10 hbs0_4 hbs1_7 hbs2_8
      hbs3_9 hbs5_10 hbs4_10 hbcarry5_1 hbs6_10

/-- `^bb0` from instruction 405 to 445: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run405 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 405 = x25519_sc_reduce.entry.body.drop 405) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s8_10 s7_10 s10_10 s9_10 s11_10 s0_4 s1_7 s2_8 s3_9 s5_10 s4_10 carry5_1 s6_10 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%883 := s8_10, %885 := s7_10, %888 := s10_10, %890 := s9_10, %894 := s11_10, %907 :=
        s0_4, %914 := s1_7, %920 := s2_8, %927 := s3_9, %931 := s5_10, %933 := s4_10, %934 :=
        carry5_1, %935 := s6_10, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 :=
        p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (hcarry5_1 : s5_10.sshiftRight 21 = carry5_1) (hbs8_10 : Bnd s8_10 (-127875146) 3485823)
    (hbs7_10 : Bnd s7_10 (-1048576) 1048575) (hbs10_10 : Bnd s10_10 (-26996803) 4539218)
    (hbs9_10 : Bnd s9_10 (-1048576) 1048575) (hbs11_10 : Bnd s11_10 (-1048576) 1048575)
    (hbs0_4 : Bnd s0_4 0 2097151) (hbs1_7 : Bnd s1_7 0 2097151) (hbs2_8 : Bnd s2_8 0 2097151)
    (hbs3_9 : Bnd s3_9 0 2097151) (hbs4_10 : Bnd s4_10 0 2097151)
    (hbcarry5_1 : Bnd carry5_1 (-204422306) 204422296) (hbs6_10 : Bnd s6_10 (-398561114) 216802898)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (t936 s5_11 carry6_2 s7_11 t940 s6_11 carry7_2 s8_11 t944 s7_12 carry8_2 s9_11 t948 s8_12
          carry9_2 s10_11 t952 s9_12 carry10_2 s11_11 t956 s10_12 carry11_2 t959 s11_12 t961 s0_5
          t963 s1_8 t965 s2_9 t967 s3_10 t969 s4_11 t971 s5_12 carry0_2 s1_9 t975 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%941 := s6_11, %945 := s7_12, %949 := s8_12, %953 := s9_12, %957 := s10_12,
              %960 := s11_12, %962 := s0_5, %966 := s2_9, %968 := s3_10, %970 := s4_11, %972 :=
              s5_12, %974 := s1_9, %975 := t975, %557 := p.add 2#64, %561 := p.add 5#64, %565 :=
              p.add 7#64, %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 :=
              p.add 18#64, %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 :=
              p.add 28#64, %599 := p.add 31#64]) →
          (ht936 : t936 = carry5_1 <<< 21) →
          (hs5_11 : s5_11 = s5_10 - t936) →
          (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) →
          (hs7_11 : s7_11 = carry6_2 + s7_10) →
          (ht940 : t940 = carry6_2 <<< 21) →
          (hs6_11 : s6_11 = s6_10 - t940) →
          (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) →
          (hs8_11 : s8_11 = s8_10 + carry7_2) →
          (ht944 : t944 = carry7_2 <<< 21) →
          (hs7_12 : s7_12 = s7_11 - t944) →
          (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) →
          (hs9_11 : s9_11 = carry8_2 + s9_10) →
          (ht948 : t948 = carry8_2 <<< 21) →
          (hs8_12 : s8_12 = s8_11 - t948) →
          (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) →
          (hs10_11 : s10_11 = s10_10 + carry9_2) →
          (ht952 : t952 = carry9_2 <<< 21) →
          (hs9_12 : s9_12 = s9_11 - t952) →
          (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) →
          (hs11_11 : s11_11 = carry10_2 + s11_10) →
          (ht956 : t956 = carry10_2 <<< 21) →
          (hs10_12 : s10_12 = s10_11 - t956) →
          (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) →
          (ht959 : t959 = carry11_2 <<< 21) →
          (hs11_12 : s11_12 = s11_11 - t959) →
          (ht961 : t961 = carry11_2 * 666643#64) →
          (hs0_5 : s0_5 = t961 + s0_4) →
          (ht963 : t963 = carry11_2 * 470296#64) →
          (hs1_8 : s1_8 = s1_7 + t963) →
          (ht965 : t965 = carry11_2 * 654183#64) →
          (hs2_9 : s2_9 = s2_8 + t965) →
          (ht967 : t967 = carry11_2 * 18446744073708553811#64) →
          (hs3_10 : s3_10 = s3_9 + t967) →
          (ht969 : t969 = carry11_2 * 136657#64) →
          (hs4_11 : s4_11 = s4_10 + t969) →
          (ht971 : t971 = carry11_2 * 18446744073708867715#64) →
          (hs5_12 : s5_12 = s5_11 + t971) →
          (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = s1_8 + carry0_2) →
          (ht975 : t975 = carry0_2 <<< 21) →
          (hbs6_11 : Bnd s6_11 0 2097151) →
          (hbs7_12 : Bnd s7_12 0 2097151) →
          (hbs8_12 : Bnd s8_12 0 2097151) →
          (hbs9_12 : Bnd s9_12 0 2097151) →
          (hbs10_12 : Bnd s10_12 0 2097151) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbs0_5 : Bnd s0_5 (-666643) 2097151) →
          (hbs2_9 : Bnd s2_9 (-654183) 2097151) →
          (hbs3_10 : Bnd s3_10 0 3094956) →
          (hbs4_11 : Bnd s4_11 (-136657) 2097151) →
          (hbs5_12 : Bnd s5_12 0 2781052) →
          (hbs1_9 : Bnd s1_9 (-470297) 2097151) →
          (hbt975 : Bnd t975 (-2097152) 0) → (blk.runBodyFrom E' 445 S >>= g) = K) :
    (blk.runBodyFrom E 405 S >>= g) = K := by
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry5_1 (by decide))) with
    t936
  bnd_ext t936
  step_pure with s5_11
  bnd_ext s5_11
  step_pure with carry6_2
  bnd_ext carry6_2
  step_pure [nswAdd] with s7_11
  bnd_ext s7_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry6_2 (by decide))) with
    t940
  bnd_ext t940
  step_pure [nswSub] with s6_11
  bnd_ext s6_11
  step_pure with carry7_2
  bnd_ext carry7_2
  step_pure [nswAdd] with s8_11
  bnd_ext s8_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry7_2 (by decide))) with
    t944
  bnd_ext t944
  step_pure [nswSub] with s7_12
  bnd_ext s7_12
  step_pure with carry8_2
  bnd_ext carry8_2
  step_pure [nswAdd] with s9_11
  bnd_ext s9_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry8_2 (by decide))) with
    t948
  bnd_ext t948
  step_pure [nswSub] with s8_12
  bnd_ext s8_12
  step_pure with carry9_2
  bnd_ext carry9_2
  step_pure [nswAdd] with s10_11
  bnd_ext s10_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry9_2 (by decide))) with
    t952
  bnd_ext t952
  step_pure [nswSub] with s9_12
  bnd_ext s9_12
  step_pure with carry10_2
  bnd_ext carry10_2
  step_pure [nswAdd] with s11_11
  bnd_ext s11_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry10_2 (by decide))) with
    t956
  bnd_ext t956
  step_pure [nswSub] with s10_12
  bnd_ext s10_12
  step_pure with carry11_2
  bnd_ext carry11_2
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry11_2 (by decide))) with
    t959
  bnd_ext t959
  step_pure [nswSub] with s11_12
  bnd_ext s11_12
  step_pure [nswMul] with t961
  bnd_ext t961
  step_pure [nswAdd] with s0_5
  bnd_ext s0_5
  step_pure [nswMul] with t963
  bnd_ext t963
  step_pure [nswAdd] with s1_8
  bnd_ext s1_8
  step_pure [nswMul] with t965
  bnd_ext t965
  step_pure [nswAdd] with s2_9
  bnd_ext s2_9
  step_pure [nswMul] with t967
  bnd_ext t967
  step_pure with s3_10
  bnd_ext s3_10
  step_pure [nswMul] with t969
  bnd_ext t969
  step_pure [nswAdd] with s4_11
  bnd_ext s4_11
  step_pure [nswMul] with t971
  bnd_ext t971
  step_pure with s5_12
  bnd_ext s5_12
  step_pure with carry0_2
  bnd_ext carry0_2
  step_pure [nswAdd] with s1_9
  bnd_ext s1_9
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry0_2 (by decide))) with
    t975
  bnd_ext t975
  subst hS
  exact
    hK _ t936 s5_11 carry6_2 s7_11 t940 s6_11 carry7_2 s8_11 t944 s7_12 carry8_2 s9_11 t948 s8_12
      carry9_2 s10_11 t952 s9_12 carry10_2 s11_11 t956 s10_12 carry11_2 t959 s11_12 t961 s0_5 t963
      s1_8 t965 s2_9 t967 s3_10 t969 s4_11 t971 s5_12 carry0_2 s1_9 t975 hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) ht936 hs5_11 hcarry6_2 hs7_11 ht940 hs6_11 hcarry7_2 hs8_11 ht944 hs7_12
      hcarry8_2 hs9_11 ht948 hs8_12 hcarry9_2 hs10_11 ht952 hs9_12 hcarry10_2 hs11_11 ht956 hs10_12
      hcarry11_2 ht959 hs11_12 ht961 hs0_5 ht963 hs1_8 ht965 hs2_9 ht967 hs3_10 ht969 hs4_11 ht971
      hs5_12 hcarry0_2 hs1_9 ht975 hbs6_11 hbs7_12 hbs8_12 hbs9_12 hbs10_12 hbs11_12 hbs0_5 hbs2_9
      hbs3_10 hbs4_11 hbs5_12 hbs1_9 hbt975

/-- `^bb0` from instruction 445 to 486: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run445 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 445 = x25519_sc_reduce.entry.body.drop 445) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6_11 s7_12 s8_12 s9_12 s10_12 s11_12 s0_5 s2_9 s3_10 s4_11 s5_12 s1_9 t975 carry0_2 :
      BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hwf : S.WF)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%941 := s6_11, %945 := s7_12, %949 := s8_12, %953 := s9_12, %957 := s10_12, %960 :=
        s11_12, %962 := s0_5, %966 := s2_9, %968 := s3_10, %970 := s4_11, %972 := s5_12, %974 :=
        s1_9, %975 := t975, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 :=
        p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 :=
        p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 :=
        p.add 31#64])
    (hcarry0_2 : s0_5.sshiftRight 21 = carry0_2) (ht975 : carry0_2 <<< 21 = t975)
    (hbs6_11 : Bnd s6_11 0 2097151) (hbs7_12 : Bnd s7_12 0 2097151) (hbs8_12 : Bnd s8_12 0 2097151)
    (hbs9_12 : Bnd s9_12 0 2097151) (hbs10_12 : Bnd s10_12 0 2097151)
    (hbs11_12 : Bnd s11_12 0 2097151) (hbs0_5 : Bnd s0_5 (-666643) 2097151)
    (hbs2_9 : Bnd s2_9 (-654183) 2097151) (hbs3_10 : Bnd s3_10 0 3094956)
    (hbs4_11 : Bnd s4_11 (-136657) 2097151) (hbs5_12 : Bnd s5_12 0 2781052)
    (hbs1_9 : Bnd s1_9 (-470297) 2097151) (hbt975 : Bnd t975 (-2097152) 0)
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫)
        (s0_6 carry1_2 s2_10 t979 s1_10 carry2_2 s3_11 t983 s2_11 carry3_2 s4_12 t987 s3_12 carry4_2
          s5_13 t991 s4_13 carry5_2 s6_12 t995 s5_14 carry6_3 s7_13 t999 s6_13 carry7_3 s8_13 t1003
          s7_14 carry8_3 s9_13 t1007 s8_14 carry9_3 s10_13 t1011 s9_14 carry10_3 s11_13 t1015
          s10_14 : BitVec 64),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (hR :
            E' ⊨ [%976 := s0_6, %980 := s1_10, %984 := s2_11, %988 := s3_12, %992 := s4_13, %996 :=
              s5_14, %1000 := s6_13, %1004 := s7_14, %1008 := s8_14, %1012 := s9_14, %1014 :=
              s11_13, %1016 := s10_14, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64,
              %569 := p.add 10#64, %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64,
              %584 := p.add 21#64, %587 := p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64,
              %599 := p.add 31#64]) →
          (hs0_6 : s0_6 = s0_5 - t975) →
          (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = s2_9 + carry1_2) →
          (ht979 : t979 = carry1_2 <<< 21) →
          (hs1_10 : s1_10 = s1_9 - t979) →
          (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = s3_10 + carry2_2) →
          (ht983 : t983 = carry2_2 <<< 21) →
          (hs2_11 : s2_11 = s2_10 - t983) →
          (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = s4_11 + carry3_2) →
          (ht987 : t987 = carry3_2 <<< 21) →
          (hs3_12 : s3_12 = s3_11 - t987) →
          (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = s5_12 + carry4_2) →
          (ht991 : t991 = carry4_2 <<< 21) →
          (hs4_13 : s4_13 = s4_12 - t991) →
          (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = carry5_2 + s6_11) →
          (ht995 : t995 = carry5_2 <<< 21) →
          (hs5_14 : s5_14 = s5_13 - t995) →
          (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = carry6_3 + s7_12) →
          (ht999 : t999 = carry6_3 <<< 21) →
          (hs6_13 : s6_13 = s6_12 - t999) →
          (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = carry7_3 + s8_12) →
          (ht1003 : t1003 = carry7_3 <<< 21) →
          (hs7_14 : s7_14 = s7_13 - t1003) →
          (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = carry8_3 + s9_12) →
          (ht1007 : t1007 = carry8_3 <<< 21) →
          (hs8_14 : s8_14 = s8_13 - t1007) →
          (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = carry9_3 + s10_12) →
          (ht1011 : t1011 = carry9_3 <<< 21) →
          (hs9_14 : s9_14 = s9_13 - t1011) →
          (hcarry10_3 : carry10_3 = s10_13.sshiftRight 21) →
          (hs11_13 : s11_13 = carry10_3 + s11_12) →
          (ht1015 : t1015 = carry10_3 <<< 21) →
          (hs10_14 : s10_14 = s10_13 - t1015) →
          (hbs0_6 : Bnd s0_6 0 2097151) →
          (hbs1_10 : Bnd s1_10 0 2097151) →
          (hbs2_11 : Bnd s2_11 0 2097151) →
          (hbs3_12 : Bnd s3_12 0 2097151) →
          (hbs4_13 : Bnd s4_13 0 2097151) →
          (hbs5_14 : Bnd s5_14 0 2097151) →
          (hbs6_13 : Bnd s6_13 0 2097151) →
          (hbs7_14 : Bnd s7_14 0 2097151) →
          (hbs8_14 : Bnd s8_14 0 2097151) →
          (hbs9_14 : Bnd s9_14 0 2097151) →
          (hbs11_13 : Bnd s11_13 (-1) 2097152) →
          (hbs10_14 : Bnd s10_14 0 2097151) → (blk.runBodyFrom E' 486 S >>= g) = K) :
    (blk.runBodyFrom E 445 S >>= g) = K := by
  step_pure [nswSub] with s0_6
  bnd_ext s0_6
  step_pure with carry1_2
  bnd_ext carry1_2
  step_pure [nswAdd] with s2_10
  bnd_ext s2_10
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry1_2 (by decide))) with
    t979
  bnd_ext t979
  step_pure [nswSub] with s1_10
  bnd_ext s1_10
  step_pure with carry2_2
  bnd_ext carry2_2
  step_pure [nswAdd] with s3_11
  bnd_ext s3_11
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry2_2 (by decide))) with
    t983
  bnd_ext t983
  step_pure [nswSub] with s2_11
  bnd_ext s2_11
  step_pure with carry3_2
  bnd_ext carry3_2
  step_pure [nswAdd] with s4_12
  bnd_ext s4_12
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry3_2 (by decide))) with
    t987
  bnd_ext t987
  step_pure [nswSub] with s3_12
  bnd_ext s3_12
  step_pure with carry4_2
  bnd_ext carry4_2
  step_pure [nswAdd] with s5_13
  bnd_ext s5_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry4_2 (by decide))) with
    t991
  bnd_ext t991
  step_pure [nswSub] with s4_13
  bnd_ext s4_13
  step_pure with carry5_2
  bnd_ext carry5_2
  step_pure [nswAdd] with s6_12
  bnd_ext s6_12
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry5_2 (by decide))) with
    t995
  bnd_ext t995
  step_pure [nswSub] with s5_14
  bnd_ext s5_14
  step_pure with carry6_3
  bnd_ext carry6_3
  step_pure [nswAdd] with s7_13
  bnd_ext s7_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry6_3 (by decide))) with
    t999
  bnd_ext t999
  step_pure [nswSub] with s6_13
  bnd_ext s6_13
  step_pure with carry7_3
  bnd_ext carry7_3
  step_pure [nswAdd] with s8_13
  bnd_ext s8_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry7_3 (by decide))) with
    t1003
  bnd_ext t1003
  step_pure [nswSub] with s7_14
  bnd_ext s7_14
  step_pure with carry8_3
  bnd_ext carry8_3
  step_pure [nswAdd] with s9_13
  bnd_ext s9_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry8_3 (by decide))) with
    t1007
  bnd_ext t1007
  step_pure [nswSub] with s8_14
  bnd_ext s8_14
  step_pure with carry9_3
  bnd_ext carry9_3
  step_pure [nswAdd] with s10_13
  bnd_ext s10_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry9_3 (by decide))) with
    t1011
  bnd_ext t1011
  step_pure [nswSub] with s9_14
  bnd_ext s9_14
  step_pure with carry10_3
  bnd_ext carry10_3
  step_pure [nswAdd] with s11_13
  bnd_ext s11_13
  step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hbcarry10_3 (by decide))) with
    t1015
  bnd_ext t1015
  step_pure [nswSub] with s10_14
  bnd_ext s10_14
  subst hS
  exact
    hK _ s0_6 carry1_2 s2_10 t979 s1_10 carry2_2 s3_11 t983 s2_11 carry3_2 s4_12 t987 s3_12 carry4_2
      s5_13 t991 s4_13 carry5_2 s6_12 t995 s5_14 carry6_3 s7_13 t999 s6_13 carry7_3 s8_13 t1003
      s7_14 carry8_3 s9_13 t1007 s8_14 carry9_3 s10_13 t1011 s9_14 carry10_3 s11_13 t1015 s10_14
      hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)
      (by env_reads) hs0_6 hcarry1_2 hs2_10 ht979 hs1_10 hcarry2_2 hs3_11 ht983 hs2_11 hcarry3_2
      hs4_12 ht987 hs3_12 hcarry4_2 hs5_13 ht991 hs4_13 hcarry5_2 hs6_12 ht995 hs5_14 hcarry6_3
      hs7_13 ht999 hs6_13 hcarry7_3 hs8_13 ht1003 hs7_14 hcarry8_3 hs9_13 ht1007 hs8_14 hcarry9_3
      hs10_13 ht1011 hs9_14 hcarry10_3 hs11_13 ht1015 hs10_14 hbs0_6 hbs1_10 hbs2_11 hbs3_12 hbs4_13
      hbs5_14 hbs6_13 hbs7_14 hbs8_14 hbs9_14 hbs11_13 hbs10_14

-- 24 stores, merged into one at the end: past the default budget

-- 24 stores, merged into one at the end: past the default budget
set_option maxHeartbeats 1000000 in
/-- `^bb0` from instruction 486 to 587: its values named, with their forms and bounds. -/
theorem x25519_sc_reduce.run486 {β : Type} {p : Pointer}
    {blk : BasicBlock x25519_sc_reduce.Γ [] x25519_sc_reduce.blockTys}
    (hbody : blk.body.drop 486 = x25519_sc_reduce.entry.body.drop 486) {E : ⟪x25519_sc_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪x25519_sc_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_6 s1_10 s2_11 s3_12 s4_13 s5_14 s6_13 s7_14 s8_14 s9_14 s11_13 s10_14 : BitVec 64}
    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get) (hp : Fits S.mem p (8 * 64))
    (hpw : Writable S.mem p) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hc : x25519_sc_reduce.Consts E)
    (hR :
      E ⊨ [%976 := s0_6, %980 := s1_10, %984 := s2_11, %988 := s3_12, %992 := s4_13, %996 := s5_14,
        %1000 := s6_13, %1004 := s7_14, %1008 := s8_14, %1012 := s9_14, %1014 := s11_13, %1016 :=
        s10_14, %557 := p.add 2#64, %561 := p.add 5#64, %565 := p.add 7#64, %569 := p.add 10#64,
        %573 := p.add 13#64, %577 := p.add 15#64, %581 := p.add 18#64, %584 := p.add 21#64, %587 :=
        p.add 23#64, %591 := p.add 26#64, %595 := p.add 28#64, %599 := p.add 31#64])
    (hK :
      ∀ (E' : ⟪x25519_sc_reduce.Γ⟫),
        (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →
          (hc : x25519_sc_reduce.Consts E') →
          (blk.runBodyFrom E' 587
                { S with
                  mem :=
                    S.mem.storeAt p
                      (x25519_sc_reduce.out s0_6 s1_10 s2_11 s3_12 s4_13 s5_14 s6_13 s7_14 s8_14
                        s9_14 s10_14 s11_13) } >>=
              g) =
            K) :
    (blk.runBodyFrom E 486 S >>= g) = K := by
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  subst hS
  rw [MemoryState.storeAt_storeAt_append (a := 16) (k := 2)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 24) (k := 3)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 40) (k := 5)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 48) (k := 6)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 56) (k := 7)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 64) (k := 8)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 80) (k := 10)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 88) (k := 11)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 104) (k := 13)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 112) (k := 14)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 120) (k := 15)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 128) (k := 16)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 144) (k := 18)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 152) (k := 19)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 168) (k := 21)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 184) (k := 23)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 192) (k := 24)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 208) (k := 26)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 216) (k := 27)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 224) (k := 28)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 232) (k := 29)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 240) (k := 30)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 248) (k := 31)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide)]
  exact
    hK _ hArgs
      (by
        unfold x25519_sc_reduce.Consts; env_reads)

/-- `x25519_sc_reduce` stores `spec` of the 64 bytes at `p` as the 32 bytes at `p`. -/
public theorem x25519_sc_reduce.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hpw : Writable s.mem p) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    x25519_sc_reduce.call (x25519_sc_reduce.args (.value p)) s =
      .value
        (.nil, { s with mem := s.mem.storeAt p (x25519_sc_reduce.spec (s.mem.readAt p 512)) }) := by
  generalize hres : x25519_sc_reduce.spec (s.mem.readAt p 512) = res
  func_init
  have hp₀ : Fits S₀.mem p (8 * 64) := hS ▸ hp
  block_init
  step_pattern using x25519_sc_reduce.run0
  step_pattern using x25519_sc_reduce.run60
  step_pattern using x25519_sc_reduce.run90
  step_pattern using x25519_sc_reduce.run135
  step_pattern using (x25519_sc_reduce.run180 (ht707 := ht707.symm) (hcarry8 := hcarry8.symm))
  step_pattern using (x25519_sc_reduce.run225 (ht754 := ht754.symm) (hcarry11 := hcarry11.symm))
  step_pattern using x25519_sc_reduce.run270
  step_pattern using x25519_sc_reduce.run315
  step_pattern using x25519_sc_reduce.run360
  step_pattern using (x25519_sc_reduce.run405 (hcarry5_1 := hcarry5_1.symm))
  step_pattern using (x25519_sc_reduce.run445 (hcarry0_2 := hcarry0_2.symm) (ht975 := ht975.symm))
  clear hwf hp
  step_pattern using x25519_sc_reduce.run486
  finish_block
  rw [hS]
  subst hres
  rw [← x25519_sc_reduce.ir_eq_spec]
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Boringssl

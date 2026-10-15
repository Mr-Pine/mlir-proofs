module

public import Ed25519.Scalar
public import Firedancer.Math.Scalar
import Std.Tactic.BVDecide
meta import Lean.Elab.Tactic

/-!
# `fd_curve25519_scalar_muladd`'s specification

`spec` mirrors the C limb arithmetic; `spec_val` shows it computes `(a b + c) mod ℓ`, by interval
arithmetic over its lets as the tree's `reduce` proof does, with products of two bounded values.
-/

namespace MLIR.Firedancer.Crc.Ref

open Firedancer.Ref (BE)

/-! ## Specification -/

@[expose] public section

/-- `(a b + c) mod ℓ` as the C computes it: `a`, `b`, `c` as eleven 21-bit limbs and a 25-bit one
each, the 23 sums of limb products, a carry pass, the limbs above `2^252` folded down by
`2^252 ≡ -27742317777372353535851937790883648493 (mod ℓ)` (the `666643 … 683901` rows) with carries
in between, and the 12 low limbs packed into 256 bits. `1048576` is `1L << 20`; the dead
`sK = 0` resets are left out. -/
def fd_curve25519_scalar_muladd.spec (a b c : BitVec 256) : BitVec 256 :=
  -- Load a, b and c
  let ia0 := a.extractLsb' 0 64
  let ib0 := b.extractLsb' 0 64
  let ic0 := c.extractLsb' 0 64
  let ia1 := a.extractLsb' 64 64
  let ib1 := b.extractLsb' 64 64
  let ic1 := c.extractLsb' 64 64
  let ia2 := a.extractLsb' 128 64
  let ib2 := b.extractLsb' 128 64
  let ic2 := c.extractLsb' 128 64
  let ia3 := a.extractLsb' 192 64
  let ib3 := b.extractLsb' 192 64
  let ic3 := c.extractLsb' 192 64
  let mask := 2097151#64 -- `FD_ULONG_MASK_LSB( 21 )`
  -- Unpack each into 11 21-bit integers and a 25-bit straggler
  let a0 := ia0 &&& mask
  let a1 := ia0 >>> 21 &&& mask
  let a2 := ia0 >>> 42 &&& mask
  let a3 := (ia0 >>> 63 ||| ia1 <<< 1) &&& mask
  let a4 := ia1 >>> 20 &&& mask
  let a5 := ia1 >>> 41 &&& mask
  let a6 := (ia1 >>> 62 ||| ia2 <<< 2) &&& mask
  let a7 := ia2 >>> 19 &&& mask
  let a8 := ia2 >>> 40 &&& mask
  let a9 := (ia2 >>> 61 ||| ia3 <<< 3) &&& mask
  let a10 := ia3 >>> 18 &&& mask
  let a11 := ia3 >>> 39
  let b0 := ib0 &&& mask
  let b1 := ib0 >>> 21 &&& mask
  let b2 := ib0 >>> 42 &&& mask
  let b3 := (ib0 >>> 63 ||| ib1 <<< 1) &&& mask
  let b4 := ib1 >>> 20 &&& mask
  let b5 := ib1 >>> 41 &&& mask
  let b6 := (ib1 >>> 62 ||| ib2 <<< 2) &&& mask
  let b7 := ib2 >>> 19 &&& mask
  let b8 := ib2 >>> 40 &&& mask
  let b9 := (ib2 >>> 61 ||| ib3 <<< 3) &&& mask
  let b10 := ib3 >>> 18 &&& mask
  let b11 := ib3 >>> 39
  let c0 := ic0 &&& mask
  let c1 := ic0 >>> 21 &&& mask
  let c2 := ic0 >>> 42 &&& mask
  let c3 := (ic0 >>> 63 ||| ic1 <<< 1) &&& mask
  let c4 := ic1 >>> 20 &&& mask
  let c5 := ic1 >>> 41 &&& mask
  let c6 := (ic1 >>> 62 ||| ic2 <<< 2) &&& mask
  let c7 := ic2 >>> 19 &&& mask
  let c8 := ic2 >>> 40 &&& mask
  let c9 := (ic2 >>> 61 ||| ic3 <<< 3) &&& mask
  let c10 := ic3 >>> 18 &&& mask
  let c11 := ic3 >>> 39
  -- Do the muladd
  let s0 := c0 + a0 * b0
  let s1 := c1 + a0 * b1 + a1 * b0
  let s2 := c2 + a0 * b2 + a1 * b1 + a2 * b0
  let s3 := c3 + a0 * b3 + a1 * b2 + a2 * b1 + a3 * b0
  let s4 := c4 + a0 * b4 + a1 * b3 + a2 * b2 + a3 * b1 + a4 * b0
  let s5 := c5 + a0 * b5 + a1 * b4 + a2 * b3 + a3 * b2 + a4 * b1 + a5 * b0
  let s6 := c6 + a0 * b6 + a1 * b5 + a2 * b4 + a3 * b3 + a4 * b2 + a5 * b1 + a6 * b0
  let s7 := c7 + a0 * b7 + a1 * b6 + a2 * b5 + a3 * b4 + a4 * b3 + a5 * b2 + a6 * b1 + a7 * b0
  let s8 :=
    c8 + a0 * b8 + a1 * b7 + a2 * b6 + a3 * b5 + a4 * b4 + a5 * b3 + a6 * b2 + a7 * b1 + a8 * b0
  let s9 :=
    c9 + a0 * b9 + a1 * b8 + a2 * b7 + a3 * b6 + a4 * b5 + a5 * b4 + a6 * b3 + a7 * b2 + a8 * b1 +
      a9 * b0
  let s10 :=
    c10 + a0 * b10 + a1 * b9 + a2 * b8 + a3 * b7 + a4 * b6 + a5 * b5 + a6 * b4 + a7 * b3 + a8 * b2 +
      a9 * b1 +
      a10 * b0
  let s11 :=
    c11 + a0 * b11 + a1 * b10 + a2 * b9 + a3 * b8 + a4 * b7 + a5 * b6 + a6 * b5 + a7 * b4 +
      a8 * b3 +
      a9 * b2 +
      a10 * b1 +
      a11 * b0
  let s12 :=
    a1 * b11 + a2 * b10 + a3 * b9 + a4 * b8 + a5 * b7 + a6 * b6 + a7 * b5 + a8 * b4 + a9 * b3 +
      a10 * b2 +
      a11 * b1
  let s13 :=
    a2 * b11 + a3 * b10 + a4 * b9 + a5 * b8 + a6 * b7 + a7 * b6 + a8 * b5 + a9 * b4 + a10 * b3 +
      a11 * b2
  let s14 :=
    a3 * b11 + a4 * b10 + a5 * b9 + a6 * b8 + a7 * b7 + a8 * b6 + a9 * b5 + a10 * b4 + a11 * b3
  let s15 := a4 * b11 + a5 * b10 + a6 * b9 + a7 * b8 + a8 * b7 + a9 * b6 + a10 * b5 + a11 * b4
  let s16 := a5 * b11 + a6 * b10 + a7 * b9 + a8 * b8 + a9 * b7 + a10 * b6 + a11 * b5
  let s17 := a6 * b11 + a7 * b10 + a8 * b9 + a9 * b8 + a10 * b7 + a11 * b6
  let s18 := a7 * b11 + a8 * b10 + a9 * b9 + a10 * b8 + a11 * b7
  let s19 := a8 * b11 + a9 * b10 + a10 * b9 + a11 * b8
  let s20 := a9 * b11 + a10 * b10 + a11 * b9
  let s21 := a10 * b11 + a11 * b10
  let s22 := a11 * b11
  let s23 := 0#64
  -- Reduce the result
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
  let carry12 := (s12 + 1048576#64).sshiftRight 21
  let s13 := s13 + carry12
  let s12 := s12 - carry12 <<< 21
  let carry14 := (s14 + 1048576#64).sshiftRight 21
  let s15 := s15 + carry14
  let s14 := s14 - carry14 <<< 21
  let carry16 := (s16 + 1048576#64).sshiftRight 21
  let s17 := s17 + carry16
  let s16 := s16 - carry16 <<< 21
  let carry18 := (s18 + 1048576#64).sshiftRight 21
  let s19 := s19 + carry18
  let s18 := s18 - carry18 <<< 21
  let carry20 := (s20 + 1048576#64).sshiftRight 21
  let s21 := s21 + carry20
  let s20 := s20 - carry20 <<< 21
  let carry22 := (s22 + 1048576#64).sshiftRight 21
  let s23 := s23 + carry22
  let s22 := s22 - carry22 <<< 21
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
  let carry13 := (s13 + 1048576#64).sshiftRight 21
  let s14 := s14 + carry13
  let s13 := s13 - carry13 <<< 21
  let carry15 := (s15 + 1048576#64).sshiftRight 21
  let s16 := s16 + carry15
  let s15 := s15 - carry15 <<< 21
  let carry17 := (s17 + 1048576#64).sshiftRight 21
  let s18 := s18 + carry17
  let s17 := s17 - carry17 <<< 21
  let carry19 := (s19 + 1048576#64).sshiftRight 21
  let s20 := s20 + carry19
  let s19 := s19 - carry19 <<< 21
  let carry21 := (s21 + 1048576#64).sshiftRight 21
  let s22 := s22 + carry21
  let s21 := s21 - carry21 <<< 21
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
  let carry0 := (s0).sshiftRight 21
  let s1 := s1 + carry0
  let s0 := s0 - carry0 <<< 21
  let carry1 := (s1).sshiftRight 21
  let s2 := s2 + carry1
  let s1 := s1 - carry1 <<< 21
  let carry2 := (s2).sshiftRight 21
  let s3 := s3 + carry2
  let s2 := s2 - carry2 <<< 21
  let carry3 := (s3).sshiftRight 21
  let s4 := s4 + carry3
  let s3 := s3 - carry3 <<< 21
  let carry4 := (s4).sshiftRight 21
  let s5 := s5 + carry4
  let s4 := s4 - carry4 <<< 21
  let carry5 := (s5).sshiftRight 21
  let s6 := s6 + carry5
  let s5 := s5 - carry5 <<< 21
  let carry6 := (s6).sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry7 := (s7).sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry8 := (s8).sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry9 := (s9).sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry10 := (s10).sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  let carry11 := (s11).sshiftRight 21
  let s12 := s12 + carry11
  let s11 := s11 - carry11 <<< 21
  let s0 := s0 + s12 * 666643#64
  let s1 := s1 + s12 * 470296#64
  let s2 := s2 + s12 * 654183#64
  let s3 := s3 - s12 * 997805#64
  let s4 := s4 + s12 * 136657#64
  let s5 := s5 - s12 * 683901#64
  let carry0 := (s0).sshiftRight 21
  let s1 := s1 + carry0
  let s0 := s0 - carry0 <<< 21
  let carry1 := (s1).sshiftRight 21
  let s2 := s2 + carry1
  let s1 := s1 - carry1 <<< 21
  let carry2 := (s2).sshiftRight 21
  let s3 := s3 + carry2
  let s2 := s2 - carry2 <<< 21
  let carry3 := (s3).sshiftRight 21
  let s4 := s4 + carry3
  let s3 := s3 - carry3 <<< 21
  let carry4 := (s4).sshiftRight 21
  let s5 := s5 + carry4
  let s4 := s4 - carry4 <<< 21
  let carry5 := (s5).sshiftRight 21
  let s6 := s6 + carry5
  let s5 := s5 - carry5 <<< 21
  let carry6 := (s6).sshiftRight 21
  let s7 := s7 + carry6
  let s6 := s6 - carry6 <<< 21
  let carry7 := (s7).sshiftRight 21
  let s8 := s8 + carry7
  let s7 := s7 - carry7 <<< 21
  let carry8 := (s8).sshiftRight 21
  let s9 := s9 + carry8
  let s8 := s8 - carry8 <<< 21
  let carry9 := (s9).sshiftRight 21
  let s10 := s10 + carry9
  let s9 := s9 - carry9 <<< 21
  let carry10 := (s10).sshiftRight 21
  let s11 := s11 + carry10
  let s10 := s10 - carry10 <<< 21
  let out0 := s0 ||| s1 <<< 21 ||| s2 <<< 42 ||| s3 <<< 63
  let out1 := s3 >>> 1 ||| s4 <<< 20 ||| s5 <<< 41 ||| s6 <<< 62
  let out2 := s6 >>> 2 ||| s7 <<< 19 ||| s8 <<< 40 ||| s9 <<< 61
  let out3 := s9 >>> 3 ||| s10 <<< 18 ||| s11 <<< 39
  out3 ++ (out2 ++ (out1 ++ out0))

end

namespace Muladd

/-- Bits `21 i … 21 i + w - 1` of `x`, as a limb. -/
public def chunk (x : BitVec 256) (i w : Nat) : BitVec 64 :=
  (x.extractLsb' (21 * i) w).setWidth 64

/-- A limb as an integer: bits `21 i …` of `x`. -/
theorem chunk_toInt (x : BitVec 256) (i w : Nat) (hw : w ≤ 62) :
    (chunk x i w).toInt = (x.toNat / 2 ^ (21 * i) % 2 ^ w : Nat) := by
  have : 2 ^ w ≤ 2 ^ 62 := Nat.pow_le_pow_right (by decide) hw
  have hlt := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  have h : (chunk x i w).toNat = x.toNat / 2 ^ (21 * i) % 2 ^ w := by
    simp only [chunk, BitVec.toNat_setWidth, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (by omega)
  rw [BitVec.toInt_eq_toNat_of_lt (by omega), h]

/-- A `w`-bit limb lies in `[0, 2^w)`. -/
public theorem ofChunk (x : BitVec 256) (i w : Nat) (hi : Int)
    (h : w ≤ 62 ∧ hi = (2 ^ w - 1 : Nat)) : BE (chunk x i w) (chunk x i w).toInt 0 hi := by
  obtain ⟨hw, rfl⟩ := h
  have := Nat.mod_lt (x.toNat / 2 ^ (21 * i)) (Nat.two_pow_pos w)
  refine ⟨rfl, ?_, ?_⟩ <;> rw [chunk_toInt x i w hw] <;> omega

/-- The limbs of `x`, weighted, sum to `x`. -/
theorem chunk_sum (x : BitVec 256) :
    (x.toNat : Int) =
      (chunk x 0 21).toInt + (chunk x 1 21).toInt * 2 ^ 21 + (chunk x 2 21).toInt * 2 ^ 42 +
        (chunk x 3 21).toInt * 2 ^ 63 +
        (chunk x 4 21).toInt * 2 ^ 84 +
        (chunk x 5 21).toInt * 2 ^ 105 +
        (chunk x 6 21).toInt * 2 ^ 126 +
        (chunk x 7 21).toInt * 2 ^ 147 +
        (chunk x 8 21).toInt * 2 ^ 168 +
        (chunk x 9 21).toInt * 2 ^ 189 +
        (chunk x 10 21).toInt * 2 ^ 210 +
        (chunk x 11 25).toInt * 2 ^ 231 := by
  have := x.isLt
  simp only [chunk_toInt x _ _ (by decide : 21 ≤ 62), chunk_toInt x _ _ (by decide : 25 ≤ 62)]
  omega

/-- A product of two non-negative values without overflow: the integers' product. -/
public theorem mulv (x y : BitVec 64) (zx zy a b c d lo hi : Int) (hx : BE x zx a b)
    (hy : BE y zy c d) (h : 0 ≤ a ∧ 0 ≤ c ∧ lo = a * c ∧ hi = b * d ∧ hi ≤ 9223372036854775807) :
    BE (x * y) (zx * zy) lo hi := by
  obtain ⟨rfl, h1, h2⟩ := hx
  obtain ⟨rfl, h3, h4⟩ := hy
  obtain ⟨ha, hc, rfl, rfl, hhi⟩ := h
  have m1 := Int.mul_le_mul h2 h4 (by omega) (by omega)
  have m2 := Int.mul_le_mul h1 h3 hc (by omega)
  have := Int.mul_nonneg ha hc
  have : ¬x.smulOverflow y := by
    simp [BitVec.smulOverflow]; omega
  rw [BE, BitVec.toInt_mul_of_not_smulOverflow this]
  omega

end Muladd

/-! ## Bounds automation -/

meta section

open Lean Meta Elab Tactic

namespace Muladd

/-- An `Int` literal. -/
def intE (i : Int) : MetaM Expr := do
  let n ← mkNumeral (mkConst ``Int) i.natAbs
  if 0 ≤ i then
    return n
  else
    mkAppM ``Neg.neg #[n]

/-- `f h`, for `h` the decided proof of `f`'s last hypothesis, a closed side condition. -/
def withSide (f : Expr) : MetaM Expr := do
  let .forallE _ p _ _ ← whnf (← inferType f) | throwError "mul_lets: no side condition"
  return mkApp f (← mkDecideProof p)

/-- The integer a `BE` proof gives its value. -/
def zOf (h : Expr) : MetaM Expr :=
  return (← instantiateMVars (← inferType h)).getArg! 1

/-- The bounded values, `v ↦ (lo, hi, h : BE v v.toInt lo hi)`, and the carries,
`c ↦ (s, rounded, h : BE c (c's quotient of s) lo hi, lo, hi)`. -/
structure State where
  atoms : Std.HashMap Expr (Int × Int × Expr) := {}
  carries : Std.HashMap Expr (Expr × Bool × Expr × Int × Int) := {}

/-- The signed 64-bit range. -/
def lo64 : Int :=
  -9223372036854775808

/-- The signed 64-bit range. -/
def hi64 : Int :=
  9223372036854775807

/-- Bounds `(lo, hi)` of `e` and a proof of `BE e z lo hi`, by interval arithmetic down to the
bounded values, literals and limbs; a carry's residual is bounded by the carry. -/
partial def bound (st : State) (e : Expr) : MetaM (Int × Int × Expr) := do
  if let some r := st.atoms[e]? then
    return r
  if let some ⟨64, v⟩← getBitVecValue? e then
    let k := v.toInt
    return (k, k, ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.lit) #[e, ← intE k]))
  if e.isAppOfArity ``chunk 3 then
    let some w := (e.getArg! 2).nat? | throwError "mul_lets: limb width in {e}"
    let hi : Int := 2 ^ w - 1
    return (0, hi, ← withSide (mkAppN (mkConst ``ofChunk) (e.getAppArgs.push (← intE hi))))
  let ok (lo hi : Int) : MetaM Unit :=
    unless lo64 ≤ lo && hi ≤ hi64 do
      throwError "mul_lets: overflow in {e}"
  match_expr e with
  | HAdd.hAdd _ _ _ _ x y =>
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a + c) (b + d)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a + c),
        ← intE (b + d), hx, hy]
    return (a + c, b + d, ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.add) args))
  | HSub.hSub _ _ _ _ x y =>
    if let some (c, n) :=
        (match_expr y with
        | HShiftLeft.hShiftLeft _ _ _ _ c n => some (c, n)
        | _ => none) then
      if let some (s, rounded, hc, e', f) := st.carries[c]? then
        if s == x && n.nat? == some 21 then
          let args := #[x, c, ← intE e', ← intE f, hc]
          if rounded then
            return (-1048576, 1048575,
                ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.resid_r) args))
          return (0, 2097151, mkAppN (mkConst ``Firedancer.Ref.BE.resid_f) args)
    let (a, b, hx) ← bound st x
    let (c, d, hy) ← bound st y
    ok (a - d) (b - c)
    let args :=
      #[x, y, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c, ← intE d, ← intE (a - d),
        ← intE (b - c), hx, hy]
    return (a - d, b - c, ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.sub) args))
  | HMul.hMul _ _ _ _ x c =>
    if let some ⟨64, k⟩← getBitVecValue? c then
      let k := k.toInt
      let (a, b, hx) ← bound st x
      unless 0 ≤ k do
        throwError "mul_lets: negative factor in {e}"
      ok (a * k) (b * k)
      let args :=
        #[x, c, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a * k), ← intE (b * k), hx]
      return (a * k, b * k, ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.mul) args))
    let (a, b, hx) ← bound st x
    let (c', d, hy) ← bound st c
    unless 0 ≤ a && 0 ≤ c' do
      throwError "mul_lets: a factor of {e} may be negative"
    ok (a * c') (b * d)
    let args :=
      #[x, c, ← zOf hx, ← zOf hy, ← intE a, ← intE b, ← intE c', ← intE d, ← intE (a * c'),
        ← intE (b * d), hx, hy]
    return (a * c', b * d, ← withSide (mkAppN (mkConst ``mulv) args))
  | BitVec.sshiftRight _ x n =>
    let some m := n.nat? | throwError "mul_lets: no bound for {e}"
    let (a, b, hx) ← bound st x
    let k : Int := 2 ^ m
    let args := #[x, n, ← zOf hx, ← intE a, ← intE b, ← intE k, ← intE (a / k), ← intE (b / k), hx]
    return (a / k, b / k, ← withSide (mkAppN (mkConst ``Firedancer.Ref.BE.sshiftRight) args))
  | _ =>
    throwError "mul_lets: no bound for {e}"

/-- The context's bounded values: `h : BE v v.toInt lo hi`, with literal bounds. -/
def scan : MetaM State := do
  let mut st : State := {}
  for d in ← getLCtx do
    if d.isImplementationDetail then
      continue
    let_expr BE v z lo hi := ← instantiateMVars d.type | continue
    unless z.isAppOfArity ``BitVec.toInt 2 && z.appArg! == v do
      continue
    let some lo ← getIntValue? lo | continue
    let some hi ← getIntValue? hi | continue
    st := { st with atoms := st.atoms.insert v (lo, hi, d.toExpr) }
  return st

/-- Introduce the goal's first `let v := e` as a plain variable, with `b_v : BE v v.toInt lo hi`
and `e_v : v.toInt = z` (`e_v : BE v z lo hi` for a carry, to keep its quotient from `omega`). -/
def step (st : State) (g : MVarId) : MetaM (State × MVarId) :=
  g.withContext do
    let .letE n ty v b _ := (← instantiateMVars (← g.getType)).consumeMData
      | throwError "mul_lets: no `let`"
    let (lo, hi, p) ← bound st v
    let z ← zOf p
    let carry? : Option (Expr × Bool) :=
      match_expr v with
      | BitVec.sshiftRight _ x _ =>
        match_expr x with
        | HAdd.hAdd _ _ _ _ s _ => some (s, true)
        | _ => some (x, false)
      | _ => none
    let loE ← intE lo
    let hiE ← intE hi
    let t ←
      withLocalDeclD n ty fun x => do
          let xi ← mkAppM ``BitVec.toInt #[x]
          let hbT ← mkAppM ``BE #[x, xi, loE, hiE]
          let heT ←
            if carry?.isSome then
              mkAppM ``BE #[x, z, loE, hiE]
            else
              mkEq xi z
          withLocalDeclD (n.appendBefore "b_") hbT fun hb =>
              withLocalDeclD (n.appendBefore "e_") heT fun he =>
                mkForallFVars #[x, hb, he] (b.instantiate1 x)
    let g' ← mkFreshExprSyntheticOpaqueMVar t (← g.getTag)
    let pe ←
      if carry?.isSome then
        pure p
      else
        mkAppM ``Firedancer.Ref.BE.eq #[p]
    g.assign (mkAppN g' #[v, ← mkAppM ``Firedancer.Ref.BE.self #[p], pe])
    let (fvs, g') ← g'.mvarId!.introNP 3
    let x := mkFVar fvs[0]!
    let mut st := { st with atoms := st.atoms.insert x (lo, hi, mkFVar fvs[1]!) }
    if let some (s, r) := carry? then
      st := { st with carries := st.carries.insert x (s, r, mkFVar fvs[2]!, lo, hi) }
    return (st, g')

end Muladd

/-- `mul_lets n`: introduce the goal's first `n` `let`s of signed 64-bit arithmetic, each with its
bounds `b_v` and its value `e_v` as an integer, both checked against overflow. -/
elab "mul_lets " n:num : tactic => do
  let mut g ← getMainGoal
  let mut st ← g.withContext Muladd.scan
  for _ in [0:n.getNat] do
    (st, g) ← Muladd.step st g
  replaceMainGoal [g]

/-- `clear_mul_eqs`: drop the values `e_v` that `mul_lets` introduced. -/
elab "clear_mul_eqs" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.userName.eraseMacroScopes.toString.startsWith "e_" then
        g ← g.clear d.fvarId
    replaceMainGoal [g]

end

/-! ## Correctness -/

/-- `muladd` computes `(a b + c) mod ℓ`. -/
public theorem fd_curve25519_scalar_muladd.spec_val (a b c : BitVec 256) :
    (fd_curve25519_scalar_muladd.spec a b c).toNat =
      (a.toNat * b.toNat + c.toNat) % Ed25519.ell := by
  unfold fd_curve25519_scalar_muladd.spec Ed25519.ell
  lift_lets
  intro ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11
    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  -- the limbs of `a`, `b`, `c`
  have ha :
    a0 = Muladd.chunk a 0 21 ∧
      a1 = Muladd.chunk a 1 21 ∧
      a2 = Muladd.chunk a 2 21 ∧
      a3 = Muladd.chunk a 3 21 ∧
      a4 = Muladd.chunk a 4 21 ∧
      a5 = Muladd.chunk a 5 21 ∧
      a6 = Muladd.chunk a 6 21 ∧
      a7 = Muladd.chunk a 7 21 ∧
      a8 = Muladd.chunk a 8 21 ∧
      a9 = Muladd.chunk a 9 21 ∧ a10 = Muladd.chunk a 10 21 ∧ a11 = Muladd.chunk a 11 25 := by
    simp only [ia0, ia1, ia2, ia3, mask, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11,
      Muladd.chunk]
    bv_decide
  have hb :
    b0 = Muladd.chunk b 0 21 ∧
      b1 = Muladd.chunk b 1 21 ∧
      b2 = Muladd.chunk b 2 21 ∧
      b3 = Muladd.chunk b 3 21 ∧
      b4 = Muladd.chunk b 4 21 ∧
      b5 = Muladd.chunk b 5 21 ∧
      b6 = Muladd.chunk b 6 21 ∧
      b7 = Muladd.chunk b 7 21 ∧
      b8 = Muladd.chunk b 8 21 ∧
      b9 = Muladd.chunk b 9 21 ∧ b10 = Muladd.chunk b 10 21 ∧ b11 = Muladd.chunk b 11 25 := by
    simp only [ib0, ib1, ib2, ib3, mask, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11,
      Muladd.chunk]
    bv_decide
  have hc :
    c0 = Muladd.chunk c 0 21 ∧
      c1 = Muladd.chunk c 1 21 ∧
      c2 = Muladd.chunk c 2 21 ∧
      c3 = Muladd.chunk c 3 21 ∧
      c4 = Muladd.chunk c 4 21 ∧
      c5 = Muladd.chunk c 5 21 ∧
      c6 = Muladd.chunk c 6 21 ∧
      c7 = Muladd.chunk c 7 21 ∧
      c8 = Muladd.chunk c 8 21 ∧
      c9 = Muladd.chunk c 9 21 ∧ c10 = Muladd.chunk c 10 21 ∧ c11 = Muladd.chunk c 11 25 := by
    simp only [ic0, ic1, ic2, ic3, mask, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11,
      Muladd.chunk]
    bv_decide
  clear_value ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 mask a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
    a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := ha
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := hb
  obtain ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩ := hc
  have hA := Muladd.chunk_sum a
  have hB := Muladd.chunk_sum b
  have hC := Muladd.chunk_sum c
  -- the 23 sums of products, then `x = a b + c` as their weighted sum
  mul_lets 23
  have hx :
    ((a.toNat * b.toNat + c.toNat : Nat) : Int) =
      s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
        s5.toInt * 2 ^ 105 +
        s6.toInt * 2 ^ 126 +
        s7.toInt * 2 ^ 147 +
        s8.toInt * 2 ^ 168 +
        s9.toInt * 2 ^ 189 +
        s10.toInt * 2 ^ 210 +
        s11.toInt * 2 ^ 231 +
        s12.toInt * 2 ^ 252 +
        s13.toInt * 2 ^ 273 +
        s14.toInt * 2 ^ 294 +
        s15.toInt * 2 ^ 315 +
        s16.toInt * 2 ^ 336 +
        s17.toInt * 2 ^ 357 +
        s18.toInt * 2 ^ 378 +
        s19.toInt * 2 ^ 399 +
        s20.toInt * 2 ^ 420 +
        s21.toInt * 2 ^ 441 +
        s22.toInt * 2 ^ 462 := by
    rw [e_s0, e_s1, e_s2, e_s3, e_s4, e_s5, e_s6, e_s7, e_s8, e_s9, e_s10, e_s11, e_s12, e_s13,
      e_s14, e_s15, e_s16, e_s17, e_s18, e_s19, e_s20, e_s21, e_s22]
    rw [Int.natCast_add, Int.natCast_mul, hA, hB, hC]
    grind
  generalize a.toNat * b.toNat + c.toNat = X at hx ⊢
  clear_mul_eqs
  clear hA hB hC
  -- carry, fold, carry: limbs `s0 … s11` in `[0, 2^21)` and `s12 ∈ [-1, 0]`, worth `x` mod `ℓ`
  mul_lets 253
  obtain ⟨V, hV⟩ :
    ∃ V,
      V =
        s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231 +
          s12.toInt * 2 ^ 252 :=
    ⟨_, rfl⟩
  have hA : ((X : Int) - V) % (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by omega
  have l0 := b_s0.2; have l1 := b_s1.2; have l2 := b_s2.2; have l3 := b_s3.2
  have l4 := b_s4.2; have l5 := b_s5.2; have l6 := b_s6.2; have l7 := b_s7.2
  have l8 := b_s8.2; have l9 := b_s9.2; have l10 := b_s10.2; have l11 := b_s11.2
  have l12 := b_s12.2
  clear_mul_eqs
  clear hx
  -- fold `s12` and carry: limbs worth `V - ℓ s12`, in `[0, ℓ)`
  mul_lets 39
  have f0 := b_s0.2; have f1 := b_s1.2; have f2 := b_s2.2; have f3 := b_s3.2
  have f4 := b_s4.2; have f5 := b_s5.2; have f6 := b_s6.2; have f7 := b_s7.2
  have f8 := b_s8.2; have f9 := b_s9.2; have f10 := b_s10.2
  obtain ⟨F, hF⟩ :
    ∃ F,
      F =
        s0.toInt + s1.toInt * 2 ^ 21 + s2.toInt * 2 ^ 42 + s3.toInt * 2 ^ 63 + s4.toInt * 2 ^ 84 +
          s5.toInt * 2 ^ 105 +
          s6.toInt * 2 ^ 126 +
          s7.toInt * 2 ^ 147 +
          s8.toInt * 2 ^ 168 +
          s9.toInt * 2 ^ 189 +
          s10.toInt * 2 ^ 210 +
          s11.toInt * 2 ^ 231 :=
    ⟨_, rfl⟩
  have hF' :
    0 ≤ F ∧
      F < 2 ^ 252 + 27742317777372353535851937790883648493 ∧
      ((X : Int) - F) % (2 ^ 252 + 27742317777372353535851937790883648493) = 0 := by
    omega
  have h11 : 0 ≤ s11.toInt ∧ s11.toInt ≤ 4194303 := by omega
  refine
    (Firedancer.Ref.pack_toNat s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 f0 f1 f2 f3 f4 f5 f6 f7 f8 f9
          f10 h11).trans
      ?_
  omega

end MLIR.Firedancer.Crc.Ref

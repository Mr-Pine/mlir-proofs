module

public import Firedancer.Lane.Mlir.fd_curve25519_scalar_muladd
public import Firedancer.Lane.Common.Scalar
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Lane

open Firedancer.Lane.Mlir
open Ref (Bnd nswAdd nswMul nuwAdd nuwMul lshrNonneg)

/-! `fd_curve25519_scalar_muladd`'s compiled code is the C's limb arithmetic reassociated, partly
unpacking in `<2 x i64>` lanes and packing the result in `<4 x i64>` lanes. The runs `runK` step
from the `K`-th instruction in continuation form: each value is named after the C variable it equals
(`tN` for `%N` otherwise) and bounded (`Bnd`) to discharge its `nsw`/`nuw` flags. Each `x_eq` states
a carry's operand `x` as the spec's lets expand it over the limbs, the carries and the earlier such
operands; `spec_eq` substitutes them into the packed words, which are then the spec by `rfl`. -/

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
  let s8 := c8 + a0 * b8 + a1 * b7 + a2 * b6 + a3 * b5 + a4 * b4 + a5 * b3 + a6 * b2 + a7 * b1 +
    a8 * b0
  let s9 := c9 + a0 * b9 + a1 * b8 + a2 * b7 + a3 * b6 + a4 * b5 + a5 * b4 + a6 * b3 + a7 * b2 +
    a8 * b1 + a9 * b0
  let s10 := c10 + a0 * b10 + a1 * b9 + a2 * b8 + a3 * b7 + a4 * b6 + a5 * b5 + a6 * b4 + a7 * b3 +
    a8 * b2 + a9 * b1 + a10 * b0
  let s11 := c11 + a0 * b11 + a1 * b10 + a2 * b9 + a3 * b8 + a4 * b7 + a5 * b6 + a6 * b5 + a7 * b4 +
    a8 * b3 + a9 * b2 + a10 * b1 + a11 * b0
  let s12 := a1 * b11 + a2 * b10 + a3 * b9 + a4 * b8 + a5 * b7 + a6 * b6 + a7 * b5 + a8 * b4 + a9 *
    b3 + a10 * b2 + a11 * b1
  let s13 := a2 * b11 + a3 * b10 + a4 * b9 + a5 * b8 + a6 * b7 + a7 * b6 + a8 * b5 + a9 * b4 + a10 *
    b3 + a11 * b2
  let s14 := a3 * b11 + a4 * b10 + a5 * b9 + a6 * b8 + a7 * b7 + a8 * b6 + a9 * b5 + a10 * b4 +
    a11 * b3
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

/-! ## Proof -/

section Proof

/-- Four lanes' bits, lane 0 lowest. -/
private theorem packLanes_four (a b c d : BitVec 64) :
    BitVec.packLanes #v[a, b, c, d] = (d ++ (c ++ (b ++ a))).cast (by decide) := by
  have key (k : Nat) (hk : k < 4) (j : Nat) (hj : j < 64) :
    (BitVec.packLanes #v[a, b, c, d]).getLsbD (k * 64 + j) = #v[a, b, c, d][k].getLsbD j := by
    rw [← BitVec.extractLsb'_packLanes #v[a, b, c, d] k hk, BitVec.getLsbD_extractLsb']
    simp [hj]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := key (i / 64) (by omega) (i % 64) (by omega)
  rw [show i / 64 * 64 + i % 64 = i by omega] at hk
  rw [hk, BitVec.getLsbD_cast]
  obtain h | h | h | h : i / 64 = 0 ∨ i / 64 = 1 ∨ i / 64 = 2 ∨ i / 64 = 3 := by omega
  all_goals
    simp only [h, BitVec.getLsbD_append, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    grind

/-! ### The lanes `or disjoint` joins share no bit -/

private theorem fd_curve25519_scalar_muladd.disj0 (s0_6 s1_11 : BitVec 64) :
    s1_11 <<< 21 &&& 4398044413952#64 &&& (s0_6 &&& 2097151#64) = 0#64 := by bv_decide

private theorem fd_curve25519_scalar_muladd.disj1 (s3_13 t869 : BitVec 64) :
    t869 <<< 20 &&& 2199022206976#64 &&& (s3_13 >>> 1 &&& 1048575#64) = 0#64 := by bv_decide

private theorem fd_curve25519_scalar_muladd.disj2 (t873 t875 : BitVec 64) :
    t875 <<< 19 &&& 1099511103488#64 &&& (t873 >>> 2 &&& 524287#64) = 0#64 := by bv_decide

private theorem fd_curve25519_scalar_muladd.disj3 (s0_6 s1_11 s2_12 : BitVec 64) :
    s2_12 <<< 42 &&& 9223367638808264704#64 &&&
        (s1_11 <<< 21 &&& 4398044413952#64 ||| s0_6 &&& 2097151#64) =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj4 (s3_13 t869 t871 : BitVec 64) :
    t871 <<< 41 &&& 4611683819404132352#64 &&&
        (t869 <<< 20 &&& 2199022206976#64 ||| s3_13 >>> 1 &&& 1048575#64) =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj5 (t873 t875 t877 : BitVec 64) :
    t877 <<< 40 &&& 2305841909702066176#64 &&&
        (t875 <<< 19 &&& 1099511103488#64 ||| t873 >>> 2 &&& 524287#64) =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj6 (t879 t881 : BitVec 64) :
    t879 >>> 3 &&& 262143#64 &&& (t881 <<< 18 &&& 549755551744#64) = 0#64 := by bv_decide

private theorem fd_curve25519_scalar_muladd.disj7 (s0_6 s1_11 s2_12 s3_13 : BitVec 64) :
    (s2_12 <<< 42 &&& 9223367638808264704#64 |||
          (s1_11 <<< 21 &&& 4398044413952#64 ||| s0_6 &&& 2097151#64)) &&&
        s3_13 <<< 63 =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj8 (s3_13 t869 t871 t873 : BitVec 64) :
    (t871 <<< 41 &&& 4611683819404132352#64 |||
          (t869 <<< 20 &&& 2199022206976#64 ||| s3_13 >>> 1 &&& 1048575#64)) &&&
        t873 <<< 62 =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj9 (t873 t875 t877 t879 : BitVec 64) :
    (t877 <<< 40 &&& 2305841909702066176#64 |||
          (t875 <<< 19 &&& 1099511103488#64 ||| t873 >>> 2 &&& 524287#64)) &&&
        t879 <<< 61 =
      0#64 := by
  bv_decide

private theorem fd_curve25519_scalar_muladd.disj10 (t879 t881 t883 : BitVec 64) :
    (t879 >>> 3 &&& 262143#64 ||| t881 <<< 18 &&& 549755551744#64) &&& t883 <<< 39 = 0#64 := by
  bv_decide


/-- The constants the code reads after loading the inputs. -/
abbrev fd_curve25519_scalar_muladd.Consts (E : ⟪fd_curve25519_scalar_muladd.Γ⟫) : Prop :=
  E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64],
       rir_reg% fd_curve25519_scalar_muladd.hty 1 := Ty.wrap
       #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64], rir_reg%
       fd_curve25519_scalar_muladd.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64], rir_reg%
       fd_curve25519_scalar_muladd.hty 3 := Ty.wrap
       #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64],
       rir_reg% fd_curve25519_scalar_muladd.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64],
       rir_reg% fd_curve25519_scalar_muladd.hty 5 := Vector.replicate 4 PoisonOr.poison, rir_reg%
       fd_curve25519_scalar_muladd.hty 6 := Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64],
       rir_reg% fd_curve25519_scalar_muladd.hty 7 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64], rir_reg%
       fd_curve25519_scalar_muladd.hty 8 := 2#64, rir_reg% fd_curve25519_scalar_muladd.hty 12 :=
       2097151#64, rir_reg% fd_curve25519_scalar_muladd.hty 13 := 21#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 14 := 42#64, rir_reg% fd_curve25519_scalar_muladd.hty 15 :=
       20#64, rir_reg% fd_curve25519_scalar_muladd.hty 16 := 41#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 17 := Vector.replicate 2 PoisonOr.poison, rir_reg%
       fd_curve25519_scalar_muladd.hty 18 := 0#64, rir_reg% fd_curve25519_scalar_muladd.hty 19 :=
       1#64, rir_reg% fd_curve25519_scalar_muladd.hty 20 := Ty.wrap #v[1#64, 2#64], rir_reg%
       fd_curve25519_scalar_muladd.hty 21 := 19#64, rir_reg% fd_curve25519_scalar_muladd.hty 22 :=
       40#64, rir_reg% fd_curve25519_scalar_muladd.hty 23 := 18#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 24 := 39#64, rir_reg% fd_curve25519_scalar_muladd.hty 25 :=
       Ty.wrap #v[3#64, 1#64], rir_reg% fd_curve25519_scalar_muladd.hty 26 := Ty.wrap
       #v[2#64, 3#64], rir_reg% fd_curve25519_scalar_muladd.hty 27 := 3#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 28 := 1048576#64, rir_reg% fd_curve25519_scalar_muladd.hty
       29 := 17592183947264#64, rir_reg% fd_curve25519_scalar_muladd.hty 30 :=
       18446744073707454464#64, rir_reg% fd_curve25519_scalar_muladd.hty 31 := 562949951324160#64,
       rir_reg% fd_curve25519_scalar_muladd.hty 32 := 2251799811588096#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 33 := 666643#64, rir_reg% fd_curve25519_scalar_muladd.hty
       34 := 470296#64, rir_reg% fd_curve25519_scalar_muladd.hty 35 := 654183#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 36 := 18446744073708553811#64, rir_reg%
       fd_curve25519_scalar_muladd.hty 37 := 136657#64, rir_reg% fd_curve25519_scalar_muladd.hty
       38 := 18446744073708867715#64, rir_reg% fd_curve25519_scalar_muladd.hty 46 :=
       (Vector.replicate 4 PoisonOr.poison).set 3 (PoisonOr.value 18446744073709551615#64)
    (by decide)]

/-- From `%0`: the constants, and the words `ia0 … ic3` of `a`, `b`, `c`. -/
theorem fd_curve25519_scalar_muladd.run0 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hwf : S.WF) (ha : Fits S.mem a (8 * 32)) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hb : Fits S.mem b (8 * 32)) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hc : Fits S.mem c (8 * 32)) (hc_off : ¬c.offset.uaddOverflow 32#64)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 47 := ia0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 48 := ib0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 49 := ic0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 51 := ia1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 53 := ib1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 55 := ic1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 57 := ia2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 59 := ib2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 61 := ic2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 63 := ia3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 65 := ib3, rir_reg%
           fd_curve25519_scalar_muladd.hty 67 := ic3]) →
          (hia0 : ia0 = BitVec.setWidth 64 (S.mem.readAt a 256)) →
          (hib0 : ib0 = BitVec.setWidth 64 (S.mem.readAt b 256)) →
          (hic0 : ic0 = BitVec.setWidth 64 (S.mem.readAt c 256)) →
          (hia1 : ia1 = BitVec.extractLsb' 64 64 (S.mem.readAt a 256)) →
          (hib1 : ib1 = BitVec.extractLsb' 64 64 (S.mem.readAt b 256)) →
          (hic1 : ic1 = BitVec.extractLsb' 64 64 (S.mem.readAt c 256)) →
          (hia2 : ia2 = BitVec.extractLsb' 128 64 (S.mem.readAt a 256)) →
          (hib2 : ib2 = BitVec.extractLsb' 128 64 (S.mem.readAt b 256)) →
          (hic2 : ic2 = BitVec.extractLsb' 128 64 (S.mem.readAt c 256)) →
          (hia3 : ia3 = BitVec.extractLsb' 192 64 (S.mem.readAt a 256)) →
          (hib3 : ib3 = BitVec.extractLsb' 192 64 (S.mem.readAt b 256)) →
          (hic3 : ic3 = BitVec.extractLsb' 192 64 (S.mem.readAt c 256)) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 68 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 0 S >>= g) = K := by
  iterate 47 step_pure
  step_load with ia0
  step_load with ib0
  step_load with ic0
  step_pure
  step_load with ia1
  step_pure
  step_load with ib1
  step_pure
  step_load with ic1
  step_pure
  step_load with ia2
  step_pure
  step_load with ib2
  step_pure
  step_load with ic2
  step_pure
  step_load with ia3
  step_pure
  step_load with ib3
  step_pure
  step_load with ic3
  subst hS
  exact
    hK _ ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) hia0 hib0 hic0 hia1
      hib1 hic1 hia2 hib2 hic2 hia3 hib3 hic3

/-- From `%68`: the limbs `a0` … `b7`. -/
theorem fd_curve25519_scalar_muladd.run68 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 47 := ia0, rir_reg%
               fd_curve25519_scalar_muladd.hty 48 := ib0, rir_reg% fd_curve25519_scalar_muladd.hty
               49 := ic0, rir_reg% fd_curve25519_scalar_muladd.hty 51 := ia1, rir_reg%
               fd_curve25519_scalar_muladd.hty 53 := ib1, rir_reg% fd_curve25519_scalar_muladd.hty
               55 := ic1, rir_reg% fd_curve25519_scalar_muladd.hty 57 := ia2, rir_reg%
               fd_curve25519_scalar_muladd.hty 59 := ib2, rir_reg% fd_curve25519_scalar_muladd.hty
               61 := ic2, rir_reg% fd_curve25519_scalar_muladd.hty 63 := ia3, rir_reg%
               fd_curve25519_scalar_muladd.hty 65 := ib3, rir_reg% fd_curve25519_scalar_muladd.hty
     67 := ic3])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (a0 t69 a1 t71 a2 t73 a4 t75 a5 t82 a3 t84 a6 t86 a7 t88 a8 t90 a10 a11 b0 t94 b1 t96 b2
        t103 a9 t105 b3 t107 b4 t109 b5 t111 b7 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 49 := ic0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 53 := ib1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 55 := ic1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 59 := ib2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 61 := ic2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 65 := ib3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 67 := ic3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 72 := a2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 93 := b0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
           fd_curve25519_scalar_muladd.hty 112 := b7]) →
          (ha0 : a0 = ia0 &&& 2097151#64) →
          (ht69 : t69 = ia0 >>> 21) →
          (ha1 : a1 = t69 &&& 2097151#64) →
          (ht71 : t71 = ia0 >>> 42) →
          (ha2 : a2 = t71 &&& 2097151#64) →
          (ht73 : t73 = ia1 >>> 20) →
          (ha4 : a4 = t73 &&& 2097151#64) →
          (ht75 : t75 = ia1 >>> 41) →
          (ha5 : a5 = t75 &&& 2097151#64) →
          (ht82 : t82 = BitVec.extractLsb' 64 64 ((ia1 ++ ia0) <<< 1)) →
          (ha3 : a3 = t82 &&& 2097151#64) →
          (ht84 : t84 = BitVec.extractLsb' 64 64 ((ia2 ++ ia1) <<< 2)) →
          (ha6 : a6 = t84 &&& 2097151#64) →
          (ht86 : t86 = ia2 >>> 19) →
          (ha7 : a7 = t86 &&& 2097151#64) →
          (ht88 : t88 = ia2 >>> 40) →
          (ha8 : a8 = t88 &&& 2097151#64) →
          (ht90 : t90 = ia3 >>> 18) →
          (ha10 : a10 = t90 &&& 2097151#64) →
          (ha11 : a11 = ia3 >>> 39) →
          (hb0 : b0 = ib0 &&& 2097151#64) →
          (ht94 : t94 = ib0 >>> 21) →
          (hb1 : b1 = t94 &&& 2097151#64) →
          (ht96 : t96 = ib0 >>> 42) →
          (hb2 : b2 = t96 &&& 2097151#64) →
          (ht103 : t103 = BitVec.extractLsb' 64 64 ((ia3 ++ ia2) <<< 3)) →
          (ha9 : a9 = t103 &&& 2097151#64) →
          (ht105 : t105 = BitVec.extractLsb' 64 64 ((ib1 ++ ib0) <<< 1)) →
          (hb3 : b3 = t105 &&& 2097151#64) →
          (ht107 : t107 = ib1 >>> 20) →
          (hb4 : b4 = t107 &&& 2097151#64) →
          (ht109 : t109 = ib1 >>> 41) →
          (hb5 : b5 = t109 &&& 2097151#64) →
          (ht111 : t111 = ib2 >>> 19) →
          (hb7 : b7 = t111 &&& 2097151#64) →
          (hba0 : Bnd a0 0 2097151) →
          (hba1 : Bnd a1 0 2097151) →
          (hba2 : Bnd a2 0 2097151) →
          (hba4 : Bnd a4 0 2097151) →
          (hba5 : Bnd a5 0 2097151) →
          (hba3 : Bnd a3 0 2097151) →
          (hba6 : Bnd a6 0 2097151) →
          (hba7 : Bnd a7 0 2097151) →
          (hba8 : Bnd a8 0 2097151) →
          (hba10 : Bnd a10 0 2097151) →
          (hba11 : Bnd a11 0 33554431) →
          (hbb0 : Bnd b0 0 2097151) →
          (hbb1 : Bnd b1 0 2097151) →
          (hbb2 : Bnd b2 0 2097151) →
          (hba9 : Bnd a9 0 2097151) →
          (hbb3 : Bnd b3 0 2097151) →
          (hbb4 : Bnd b4 0 2097151) →
          (hbb5 : Bnd b5 0 2097151) →
          (hbb7 : Bnd b7 0 2097151) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 113 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 68 S >>= g) = K := by
  step_pure with a0
  sbnd a0
  step_pure with t69
  step_pure with a1
  sbnd a1
  step_pure with t71
  step_pure with a2
  sbnd a2
  step_pure with t73
  step_pure with a4
  sbnd a4
  step_pure with t75
  step_pure with a5
  sbnd a5
  iterate 4 step_pure
  step_pure [expandOfFn] with t81
  step_pure [ht81] with t82
  step_pure with a3
  sbnd a3
  step_pure [ht81] with t84
  step_pure with a6
  sbnd a6
  step_pure with t86
  step_pure with a7
  sbnd a7
  step_pure with t88
  step_pure with a8
  sbnd a8
  step_pure with t90
  step_pure with a10
  sbnd a10
  step_pure with a11
  sbnd a11
  step_pure with b0
  sbnd b0
  step_pure with t94
  step_pure with b1
  sbnd b1
  step_pure with t96
  step_pure with b2
  sbnd b2
  iterate 4 step_pure
  step_pure [expandOfFn] with t102
  step_pure [ht102] with t103
  step_pure with a9
  sbnd a9
  step_pure [ht102] with t105
  step_pure with b3
  sbnd b3
  step_pure with t107
  step_pure with b4
  sbnd b4
  step_pure with t109
  step_pure with b5
  sbnd b5
  step_pure with t111
  step_pure with b7
  sbnd b7
  exact
    hK _ a0 t69 a1 t71 a2 t73 a4 t75 a5 t82 a3 t84 a6 t86 a7 t88 a8 t90 a10 a11 b0 t94 b1 t96 b2
      t103 a9 t105 b3 t107 b4 t109 b5 t111 b7 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ha0 ht69 ha1 ht71 ha2
      ht73 ha4 ht75 ha5 ht82 ha3 ht84 ha6 ht86 ha7 ht88 ha8 ht90 ha10 ha11 hb0 ht94 hb1 ht96 hb2
      ht103 ha9 ht105 hb3 ht107 hb4 ht109 hb5 ht111 hb7 hba0 hba1 hba2 hba4 hba5 hba3 hba6 hba7 hba8
      hba10 hba11 hbb0 hbb1 hbb2 hba9 hbb3 hbb4 hbb5 hbb7

/-- From `%113`: the limbs `b8` … `c11`, the products into `s0`. -/
theorem fd_curve25519_scalar_muladd.run113 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {ic0 ib1 ic1 ib2 ic2 ib3 ic3 a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b0 b1 b2 a9 b3 b4 b5 b7 :
     BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 49 := ic0, rir_reg%
               fd_curve25519_scalar_muladd.hty 53 := ib1, rir_reg% fd_curve25519_scalar_muladd.hty
               55 := ic1, rir_reg% fd_curve25519_scalar_muladd.hty 59 := ib2, rir_reg%
               fd_curve25519_scalar_muladd.hty 61 := ic2, rir_reg% fd_curve25519_scalar_muladd.hty
               65 := ib3, rir_reg% fd_curve25519_scalar_muladd.hty 67 := ic3, rir_reg%
               fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg% fd_curve25519_scalar_muladd.hty
               70 := a1, rir_reg% fd_curve25519_scalar_muladd.hty 72 := a2, rir_reg%
               fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg% fd_curve25519_scalar_muladd.hty
               76 := a5, rir_reg% fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
               fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg% fd_curve25519_scalar_muladd.hty
               87 := a7, rir_reg% fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
               fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg% fd_curve25519_scalar_muladd.hty
               92 := a11, rir_reg% fd_curve25519_scalar_muladd.hty 93 := b0, rir_reg%
               fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg% fd_curve25519_scalar_muladd.hty
               97 := b2, rir_reg% fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
               fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg% fd_curve25519_scalar_muladd.hty
               108 := b4, rir_reg% fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
     fd_curve25519_scalar_muladd.hty 112 := b7])
    (hba0 : Bnd a0 0 2097151)
    (hba1 : Bnd a1 0 2097151)
    (hbb0 : Bnd b0 0 2097151)
    (hbb1 : Bnd b1 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t113 b8 t120 b6 t122 b9 t124 b10 b11 c0 t128 c1 t130 c2 t132 c4 t134 c5 t141 c3 t143 c6
        t145 c7 t147 c8 t149 c9 t151 c10 c11 t154 s0 t156 t157 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 72 := a2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 93 := b0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 131 := c2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 133 := c4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 144 := c6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 148 := c8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 156 := t156, rir_reg%
           fd_curve25519_scalar_muladd.hty 157 := t157]) →
          (ht113 : t113 = ib2 >>> 40) →
          (hb8 : b8 = t113 &&& 2097151#64) →
          (ht120 : t120 = BitVec.extractLsb' 64 64 ((ib2 ++ ib1) <<< 2)) →
          (hb6 : b6 = t120 &&& 2097151#64) →
          (ht122 : t122 = BitVec.extractLsb' 64 64 ((ib3 ++ ib2) <<< 3)) →
          (hb9 : b9 = t122 &&& 2097151#64) →
          (ht124 : t124 = ib3 >>> 18) →
          (hb10 : b10 = t124 &&& 2097151#64) →
          (hb11 : b11 = ib3 >>> 39) →
          (hc0 : c0 = ic0 &&& 2097151#64) →
          (ht128 : t128 = ic0 >>> 21) →
          (hc1 : c1 = t128 &&& 2097151#64) →
          (ht130 : t130 = ic0 >>> 42) →
          (hc2 : c2 = t130 &&& 2097151#64) →
          (ht132 : t132 = ic1 >>> 20) →
          (hc4 : c4 = t132 &&& 2097151#64) →
          (ht134 : t134 = ic1 >>> 41) →
          (hc5 : c5 = t134 &&& 2097151#64) →
          (ht141 : t141 = BitVec.extractLsb' 64 64 ((ic1 ++ ic0) <<< 1)) →
          (hc3 : c3 = t141 &&& 2097151#64) →
          (ht143 : t143 = BitVec.extractLsb' 64 64 ((ic2 ++ ic1) <<< 2)) →
          (hc6 : c6 = t143 &&& 2097151#64) →
          (ht145 : t145 = ic2 >>> 19) →
          (hc7 : c7 = t145 &&& 2097151#64) →
          (ht147 : t147 = ic2 >>> 40) →
          (hc8 : c8 = t147 &&& 2097151#64) →
          (ht149 : t149 = BitVec.extractLsb' 64 64 ((ic3 ++ ic2) <<< 3)) →
          (hc9 : c9 = t149 &&& 2097151#64) →
          (ht151 : t151 = ic3 >>> 18) →
          (hc10 : c10 = t151 &&& 2097151#64) →
          (hc11 : c11 = ic3 >>> 39) →
          (ht154 : t154 = b0 * a0) →
          (hs0 : s0 = c0 + t154) →
          (ht156 : t156 = b1 * a0) →
          (ht157 : t157 = a1 * b0) →
          (hbb8 : Bnd b8 0 2097151) →
          (hbb6 : Bnd b6 0 2097151) →
          (hbb9 : Bnd b9 0 2097151) →
          (hbb10 : Bnd b10 0 2097151) →
          (hbb11 : Bnd b11 0 33554431) →
          (hbc1 : Bnd c1 0 2097151) →
          (hbc2 : Bnd c2 0 2097151) →
          (hbc4 : Bnd c4 0 2097151) →
          (hbc5 : Bnd c5 0 2097151) →
          (hbc3 : Bnd c3 0 2097151) →
          (hbc6 : Bnd c6 0 2097151) →
          (hbc7 : Bnd c7 0 2097151) →
          (hbc8 : Bnd c8 0 2097151) →
          (hbc9 : Bnd c9 0 2097151) →
          (hbc10 : Bnd c10 0 2097151) →
          (hbc11 : Bnd c11 0 33554431) →
          (hbs0 : Bnd s0 0 4398044413952) →
          (hbt156 : Bnd t156 0 4398042316801) →
          (hbt157 : Bnd t157 0 4398042316801) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 158 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 113 S >>= g) = K := by
  step_pure with t113
  step_pure with b8
  sbnd b8
  iterate 4 step_pure
  step_pure [expandOfFn] with t119
  step_pure [ht119] with t120
  step_pure with b6
  sbnd b6
  step_pure [ht119] with t122
  step_pure with b9
  sbnd b9
  step_pure with t124
  step_pure with b10
  sbnd b10
  step_pure with b11
  sbnd b11
  step_pure with c0
  sbnd c0
  step_pure with t128
  step_pure with c1
  sbnd c1
  step_pure with t130
  step_pure with c2
  sbnd c2
  step_pure with t132
  step_pure with c4
  sbnd c4
  step_pure with t134
  step_pure with c5
  sbnd c5
  iterate 4 step_pure
  step_pure [expandOfFn] with t140
  step_pure [ht140] with t141
  step_pure with c3
  sbnd c3
  step_pure [ht140] with t143
  step_pure with c6
  sbnd c6
  step_pure with t145
  step_pure with c7
  sbnd c7
  step_pure with t147
  step_pure with c8
  sbnd c8
  step_pure with t149
  step_pure with c9
  sbnd c9
  step_pure with t151
  step_pure with c10
  sbnd c10
  step_pure with c11
  sbnd c11
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t154
  sbnd t154
  step_pure [nswAdd, nuwAdd] with s0
  sbnd s0
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t156
  sbnd t156
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t157
  sbnd t157
  exact
    hK _ t113 b8 t120 b6 t122 b9 t124 b10 b11 c0 t128 c1 t130 c2 t132 c4 t134 c5 t141 c3 t143 c6
      t145 c7 t147 c8 t149 c9 t151 c10 c11 t154 s0 t156 t157 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht113 hb8 ht120 hb6
      ht122 hb9 ht124 hb10 hb11 hc0 ht128 hc1 ht130 hc2 ht132 hc4 ht134 hc5 ht141 hc3 ht143 hc6
      ht145 hc7 ht147 hc8 ht149 hc9 ht151 hc10 hc11 ht154 hs0 ht156 ht157 hbb8 hbb6 hbb9 hbb10 hbb11
      hbc1 hbc2 hbc4 hbc5 hbc3 hbc6 hbc7 hbc8 hbc9 hbc10 hbc11 hbs0 hbt156 hbt157

/-- From `%158`: the products into `s2`, `s4`, `s6`. -/
theorem fd_curve25519_scalar_muladd.run158 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 c1 c2 c4 c5 c3 c6
     c7 c8 c9 c10 c11 s0 t156 t157 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
               fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg% fd_curve25519_scalar_muladd.hty
               72 := a2, rir_reg% fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
               fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg% fd_curve25519_scalar_muladd.hty
               83 := a3, rir_reg% fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
               fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg% fd_curve25519_scalar_muladd.hty
               89 := a8, rir_reg% fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
               fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg% fd_curve25519_scalar_muladd.hty
               93 := b0, rir_reg% fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
               fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg% fd_curve25519_scalar_muladd.hty
               104 := a9, rir_reg% fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
               fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg% fd_curve25519_scalar_muladd.hty
               110 := b5, rir_reg% fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
               fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg% fd_curve25519_scalar_muladd.hty
               121 := b6, rir_reg% fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
               fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
               fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
               fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg% fd_curve25519_scalar_muladd.hty
               131 := c2, rir_reg% fd_curve25519_scalar_muladd.hty 133 := c4, rir_reg%
               fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg% fd_curve25519_scalar_muladd.hty
               142 := c3, rir_reg% fd_curve25519_scalar_muladd.hty 144 := c6, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               148 := c8, rir_reg% fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
               fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
               fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg% fd_curve25519_scalar_muladd.hty
     156 := t156, rir_reg% fd_curve25519_scalar_muladd.hty 157 := t157])
    (hba0 : Bnd a0 0 2097151)
    (hba1 : Bnd a1 0 2097151)
    (hba2 : Bnd a2 0 2097151)
    (hba4 : Bnd a4 0 2097151)
    (hba5 : Bnd a5 0 2097151)
    (hba3 : Bnd a3 0 2097151)
    (hba6 : Bnd a6 0 2097151)
    (hbb0 : Bnd b0 0 2097151)
    (hbb1 : Bnd b1 0 2097151)
    (hbb2 : Bnd b2 0 2097151)
    (hbb3 : Bnd b3 0 2097151)
    (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151)
    (hbb7 : Bnd b7 0 2097151)
    (hbb6 : Bnd b6 0 2097151)
    (hbc2 : Bnd c2 0 2097151)
    (hbc4 : Bnd c4 0 2097151)
    (hbc6 : Bnd c6 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t158 t159 t160 t161 t162 s2 t164 t165 t166 t167 t168 t169 t170 t171 t172 t173 t174 t175
         t176 s4 t178 t179 t180 t181 t182 t183 t184 t185 t186 t187 t188 t189 t190 t191 t192 t193
        t194 t195 t196 s6 t198 t199 t200 t201 t202 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 72 := a2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 93 := b0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 148 := c8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 156 := t156, rir_reg%
                      fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
                      fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 164 := t164, rir_reg%
                      fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
                      fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
                      fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
                      fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 178 := t178, rir_reg%
                      fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
                      fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
                      fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
                      fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
                      fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 198 := t198, rir_reg%
                      fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
                      fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
                      fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
           fd_curve25519_scalar_muladd.hty 202 := t202]) →
          (ht158 : t158 = b2 * a0) →
          (ht159 : t159 = b1 * a1) →
          (ht160 : t160 = a2 * b0) →
          (ht161 : t161 = t158 + t160) →
          (ht162 : t162 = t161 + c2) →
          (hs2 : s2 = t162 + t159) →
          (ht164 : t164 = b3 * a0) →
          (ht165 : t165 = b2 * a1) →
          (ht166 : t166 = b1 * a2) →
          (ht167 : t167 = a3 * b0) →
          (ht168 : t168 = b4 * a0) →
          (ht169 : t169 = b3 * a1) →
          (ht170 : t170 = b2 * a2) →
          (ht171 : t171 = a3 * b1) →
          (ht172 : t172 = a4 * b0) →
          (ht173 : t173 = t171 + t170) →
          (ht174 : t174 = t173 + t172) →
          (ht175 : t175 = t174 + t168) →
          (ht176 : t176 = t175 + c4) →
          (hs4 : s4 = t176 + t169) →
          (ht178 : t178 = b5 * a0) →
          (ht179 : t179 = b4 * a1) →
          (ht180 : t180 = b3 * a2) →
          (ht181 : t181 = a3 * b2) →
          (ht182 : t182 = a4 * b1) →
          (ht183 : t183 = a5 * b0) →
          (ht184 : t184 = b6 * a0) →
          (ht185 : t185 = b5 * a1) →
          (ht186 : t186 = b4 * a2) →
          (ht187 : t187 = b3 * a3) →
          (ht188 : t188 = a4 * b2) →
          (ht189 : t189 = a5 * b1) →
          (ht190 : t190 = a6 * b0) →
          (ht191 : t191 = t189 + t188) →
          (ht192 : t192 = t191 + t185) →
          (ht193 : t193 = t192 + t186) →
          (ht194 : t194 = t193 + t187) →
          (ht195 : t195 = t194 + t190) →
          (ht196 : t196 = t195 + t184) →
          (hs6 : s6 = t196 + c6) →
          (ht198 : t198 = b7 * a0) →
          (ht199 : t199 = b6 * a1) →
          (ht200 : t200 = b5 * a2) →
          (ht201 : t201 = b4 * a3) →
          (ht202 : t202 = b3 * a4) →
          (hbs2 : Bnd s2 0 13194129047554) →
          (hbt164 : Bnd t164 0 4398042316801) →
          (hbt165 : Bnd t165 0 4398042316801) →
          (hbt166 : Bnd t166 0 4398042316801) →
          (hbt167 : Bnd t167 0 4398042316801) →
          (hbs4 : Bnd s4 0 21990213681156) →
          (hbt178 : Bnd t178 0 4398042316801) →
          (hbt179 : Bnd t179 0 4398042316801) →
          (hbt180 : Bnd t180 0 4398042316801) →
          (hbt181 : Bnd t181 0 4398042316801) →
          (hbt182 : Bnd t182 0 4398042316801) →
          (hbt183 : Bnd t183 0 4398042316801) →
          (hbs6 : Bnd s6 0 30786298314758) →
          (hbt198 : Bnd t198 0 4398042316801) →
          (hbt199 : Bnd t199 0 4398042316801) →
          (hbt200 : Bnd t200 0 4398042316801) →
          (hbt201 : Bnd t201 0 4398042316801) →
          (hbt202 : Bnd t202 0 4398042316801) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 203 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 158 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t158
  sbnd t158
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t159
  sbnd t159
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t160
  sbnd t160
  step_pure [nswAdd, nuwAdd] with t161
  sbnd t161
  step_pure [nswAdd, nuwAdd] with t162
  sbnd t162
  step_pure [nswAdd, nuwAdd] with s2
  sbnd s2
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t164
  sbnd t164
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t165
  sbnd t165
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t166
  sbnd t166
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t167
  sbnd t167
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t168
  sbnd t168
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t169
  sbnd t169
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t170
  sbnd t170
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t171
  sbnd t171
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t172
  sbnd t172
  step_pure [nswAdd, nuwAdd] with t173
  sbnd t173
  step_pure [nswAdd, nuwAdd] with t174
  sbnd t174
  step_pure [nswAdd, nuwAdd] with t175
  sbnd t175
  step_pure [nswAdd, nuwAdd] with t176
  sbnd t176
  step_pure [nswAdd, nuwAdd] with s4
  sbnd s4
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t178
  sbnd t178
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t179
  sbnd t179
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t180
  sbnd t180
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t181
  sbnd t181
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t182
  sbnd t182
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t183
  sbnd t183
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t184
  sbnd t184
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t185
  sbnd t185
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t186
  sbnd t186
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t187
  sbnd t187
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t188
  sbnd t188
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t189
  sbnd t189
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t190
  sbnd t190
  step_pure [nswAdd, nuwAdd] with t191
  sbnd t191
  step_pure [nswAdd, nuwAdd] with t192
  sbnd t192
  step_pure [nswAdd, nuwAdd] with t193
  sbnd t193
  step_pure [nswAdd, nuwAdd] with t194
  sbnd t194
  step_pure [nswAdd, nuwAdd] with t195
  sbnd t195
  step_pure [nswAdd, nuwAdd] with t196
  sbnd t196
  step_pure [nswAdd, nuwAdd] with s6
  sbnd s6
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t198
  sbnd t198
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t199
  sbnd t199
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t200
  sbnd t200
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t201
  sbnd t201
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t202
  sbnd t202
  exact
    hK _ t158 t159 t160 t161 t162 s2 t164 t165 t166 t167 t168 t169 t170 t171 t172 t173 t174 t175
      t176 s4 t178 t179 t180 t181 t182 t183 t184 t185 t186 t187 t188 t189 t190 t191 t192 t193 t194
      t195 t196 s6 t198 t199 t200 t201 t202 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht158 ht159 ht160
      ht161 ht162 hs2 ht164 ht165 ht166 ht167 ht168 ht169 ht170 ht171 ht172 ht173 ht174 ht175 ht176
      hs4 ht178 ht179 ht180 ht181 ht182 ht183 ht184 ht185 ht186 ht187 ht188 ht189 ht190 ht191 ht192
      ht193 ht194 ht195 ht196 hs6 ht198 ht199 ht200 ht201 ht202 hbs2 hbt164 hbt165 hbt166 hbt167
      hbs4 hbt178 hbt179 hbt180 hbt181 hbt182 hbt183 hbs6 hbt198 hbt199 hbt200 hbt201 hbt202

/-- From `%203`: the products into `s8`. -/
theorem fd_curve25519_scalar_muladd.run203 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 c1 c5 c3 c7 c8 c9
     c10 c11 s0 t156 t157 s2 t164 t165 t166 t167 s4 t178 t179 t180 t181 t182 t183 s6 t198 t199 t200
     t201 t202 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
               fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg% fd_curve25519_scalar_muladd.hty
               72 := a2, rir_reg% fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
               fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg% fd_curve25519_scalar_muladd.hty
               83 := a3, rir_reg% fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
               fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg% fd_curve25519_scalar_muladd.hty
               89 := a8, rir_reg% fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
               fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg% fd_curve25519_scalar_muladd.hty
               93 := b0, rir_reg% fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
               fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg% fd_curve25519_scalar_muladd.hty
               104 := a9, rir_reg% fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
               fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg% fd_curve25519_scalar_muladd.hty
               110 := b5, rir_reg% fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
               fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg% fd_curve25519_scalar_muladd.hty
               121 := b6, rir_reg% fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
               fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
               fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
               fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg% fd_curve25519_scalar_muladd.hty
               135 := c5, rir_reg% fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               148 := c8, rir_reg% fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
               fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
               fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg% fd_curve25519_scalar_muladd.hty
               156 := t156, rir_reg% fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
               fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg% fd_curve25519_scalar_muladd.hty
               164 := t164, rir_reg% fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
               fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
               fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
               fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg% fd_curve25519_scalar_muladd.hty
               178 := t178, rir_reg% fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
               fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
               fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
               fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
               fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               198 := t198, rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
               fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
               fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
     fd_curve25519_scalar_muladd.hty 202 := t202])
    (hba0 : Bnd a0 0 2097151)
    (hba1 : Bnd a1 0 2097151)
    (hba2 : Bnd a2 0 2097151)
    (hba4 : Bnd a4 0 2097151)
    (hba5 : Bnd a5 0 2097151)
    (hba3 : Bnd a3 0 2097151)
    (hba6 : Bnd a6 0 2097151)
    (hba7 : Bnd a7 0 2097151)
    (hba8 : Bnd a8 0 2097151)
    (hba10 : Bnd a10 0 2097151)
    (hbb0 : Bnd b0 0 2097151)
    (hbb1 : Bnd b1 0 2097151)
    (hbb2 : Bnd b2 0 2097151)
    (hba9 : Bnd a9 0 2097151)
    (hbb3 : Bnd b3 0 2097151)
    (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151)
    (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151)
    (hbb6 : Bnd b6 0 2097151)
    (hbb9 : Bnd b9 0 2097151)
    (hbb10 : Bnd b10 0 2097151)
    (hbc8 : Bnd c8 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t203 t204 t205 t206 t207 t208 t209 t210 t211 t212 t213 t214 t215 t216 t217 t218 t219 t220
         t221 t222 s8 t224 t225 t226 t227 t228 t229 t230 t231 t232 t233 t234 t235 t236 t237 t238
        t239 t240 t241 t242 t243 t244 t245 t246 t247 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 72 := a2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 93 := b0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 156 := t156, rir_reg%
                      fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
                      fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 164 := t164, rir_reg%
                      fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
                      fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
                      fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
                      fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 178 := t178, rir_reg%
                      fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
                      fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
                      fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
                      fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
                      fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 198 := t198, rir_reg%
                      fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
                      fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
                      fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
                      fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
                      fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
                      fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
                      fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
                      fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 224 := t224, rir_reg%
                      fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
                      fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
                      fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
                      fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
                      fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
                      fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
                      fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
                      fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
                      fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
                      fd_curve25519_scalar_muladd.hty 234 := t234, rir_reg%
                      fd_curve25519_scalar_muladd.hty 235 := t235, rir_reg%
                      fd_curve25519_scalar_muladd.hty 236 := t236, rir_reg%
                      fd_curve25519_scalar_muladd.hty 237 := t237, rir_reg%
                      fd_curve25519_scalar_muladd.hty 238 := t238, rir_reg%
                      fd_curve25519_scalar_muladd.hty 243 := t243, rir_reg%
                      fd_curve25519_scalar_muladd.hty 244 := t244, rir_reg%
           fd_curve25519_scalar_muladd.hty 247 := t247]) →
          (ht203 : t203 = a5 * b2) →
          (ht204 : t204 = a6 * b1) →
          (ht205 : t205 = a7 * b0) →
          (ht206 : t206 = b8 * a0) →
          (ht207 : t207 = b7 * a1) →
          (ht208 : t208 = b6 * a2) →
          (ht209 : t209 = b5 * a3) →
          (ht210 : t210 = b4 * a4) →
          (ht211 : t211 = b3 * a5) →
          (ht212 : t212 = a6 * b2) →
          (ht213 : t213 = a7 * b1) →
          (ht214 : t214 = a8 * b0) →
          (ht215 : t215 = t210 + t209) →
          (ht216 : t216 = t215 + t211) →
          (ht217 : t217 = t216 + t212) →
          (ht218 : t218 = t217 + t213) →
          (ht219 : t219 = t218 + t214) →
          (ht220 : t220 = t219 + t206) →
          (ht221 : t221 = t220 + c8) →
          (ht222 : t222 = t221 + t207) →
          (hs8 : s8 = t222 + t208) →
          (ht224 : t224 = b9 * a0) →
          (ht225 : t225 = b8 * a1) →
          (ht226 : t226 = b7 * a2) →
          (ht227 : t227 = b6 * a3) →
          (ht228 : t228 = b5 * a4) →
          (ht229 : t229 = b4 * a5) →
          (ht230 : t230 = a6 * b3) →
          (ht231 : t231 = a7 * b2) →
          (ht232 : t232 = a8 * b1) →
          (ht233 : t233 = a9 * b0) →
          (ht234 : t234 = b10 * a0) →
          (ht235 : t235 = b9 * a1) →
          (ht236 : t236 = b8 * a2) →
          (ht237 : t237 = b7 * a3) →
          (ht238 : t238 = b6 * a4) →
          (ht239 : t239 = b5 * a5) →
          (ht240 : t240 = a6 * b4) →
          (ht241 : t241 = a7 * b3) →
          (ht242 : t242 = a8 * b2) →
          (ht243 : t243 = a9 * b1) →
          (ht244 : t244 = a10 * b0) →
          (ht245 : t245 = t240 + t239) →
          (ht246 : t246 = t245 + t241) →
          (ht247 : t247 = t246 + t242) →
          (hbt203 : Bnd t203 0 4398042316801) →
          (hbt204 : Bnd t204 0 4398042316801) →
          (hbt205 : Bnd t205 0 4398042316801) →
          (hbs8 : Bnd s8 0 39582382948360) →
          (hbt224 : Bnd t224 0 4398042316801) →
          (hbt225 : Bnd t225 0 4398042316801) →
          (hbt226 : Bnd t226 0 4398042316801) →
          (hbt227 : Bnd t227 0 4398042316801) →
          (hbt228 : Bnd t228 0 4398042316801) →
          (hbt229 : Bnd t229 0 4398042316801) →
          (hbt230 : Bnd t230 0 4398042316801) →
          (hbt231 : Bnd t231 0 4398042316801) →
          (hbt232 : Bnd t232 0 4398042316801) →
          (hbt233 : Bnd t233 0 4398042316801) →
          (hbt234 : Bnd t234 0 4398042316801) →
          (hbt235 : Bnd t235 0 4398042316801) →
          (hbt236 : Bnd t236 0 4398042316801) →
          (hbt237 : Bnd t237 0 4398042316801) →
          (hbt238 : Bnd t238 0 4398042316801) →
          (hbt243 : Bnd t243 0 4398042316801) →
          (hbt244 : Bnd t244 0 4398042316801) →
          (hbt247 : Bnd t247 0 17592169267204) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 248 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 203 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t203
  sbnd t203
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t204
  sbnd t204
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t205
  sbnd t205
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t206
  sbnd t206
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t207
  sbnd t207
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t208
  sbnd t208
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t209
  sbnd t209
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t210
  sbnd t210
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t211
  sbnd t211
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t212
  sbnd t212
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t213
  sbnd t213
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t214
  sbnd t214
  step_pure [nswAdd, nuwAdd] with t215
  sbnd t215
  step_pure [nswAdd, nuwAdd] with t216
  sbnd t216
  step_pure [nswAdd, nuwAdd] with t217
  sbnd t217
  step_pure [nswAdd, nuwAdd] with t218
  sbnd t218
  step_pure [nswAdd, nuwAdd] with t219
  sbnd t219
  step_pure [nswAdd, nuwAdd] with t220
  sbnd t220
  step_pure [nswAdd, nuwAdd] with t221
  sbnd t221
  step_pure [nswAdd, nuwAdd] with t222
  sbnd t222
  step_pure [nswAdd, nuwAdd] with s8
  sbnd s8
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t224
  sbnd t224
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t225
  sbnd t225
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t226
  sbnd t226
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t227
  sbnd t227
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t228
  sbnd t228
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t229
  sbnd t229
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t230
  sbnd t230
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t231
  sbnd t231
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t232
  sbnd t232
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t233
  sbnd t233
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t234
  sbnd t234
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t235
  sbnd t235
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t236
  sbnd t236
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t237
  sbnd t237
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t238
  sbnd t238
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t239
  sbnd t239
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t240
  sbnd t240
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t241
  sbnd t241
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t242
  sbnd t242
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t243
  sbnd t243
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t244
  sbnd t244
  step_pure [nswAdd, nuwAdd] with t245
  sbnd t245
  step_pure [nswAdd, nuwAdd] with t246
  sbnd t246
  step_pure [nswAdd, nuwAdd] with t247
  sbnd t247
  exact
    hK _ t203 t204 t205 t206 t207 t208 t209 t210 t211 t212 t213 t214 t215 t216 t217 t218 t219 t220
      t221 t222 s8 t224 t225 t226 t227 t228 t229 t230 t231 t232 t233 t234 t235 t236 t237 t238 t239
      t240 t241 t242 t243 t244 t245 t246 t247 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht203 ht204 ht205
      ht206 ht207 ht208 ht209 ht210 ht211 ht212 ht213 ht214 ht215 ht216 ht217 ht218 ht219 ht220
      ht221 ht222 hs8 ht224 ht225 ht226 ht227 ht228 ht229 ht230 ht231 ht232 ht233 ht234 ht235 ht236
      ht237 ht238 ht239 ht240 ht241 ht242 ht243 ht244 ht245 ht246 ht247 hbt203 hbt204 hbt205 hbs8
      hbt224 hbt225 hbt226 hbt227 hbt228 hbt229 hbt230 hbt231 hbt232 hbt233 hbt234 hbt235 hbt236
      hbt237 hbt238 hbt243 hbt244 hbt247

/-- From `%248`: the products into `s10`, `s12`. -/
theorem fd_curve25519_scalar_muladd.run248 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 c1 c5 c3 c7 c9 c10
     c11 s0 t156 t157 s2 t164 t165 t166 t167 s4 t178 t179 t180 t181 t182 t183 s6 t198 t199 t200
     t201 t202 t203 t204 t205 s8 t224 t225 t226 t227 t228 t229 t230 t231 t232 t233 t234 t235 t236
     t237 t238 t243 t244 t247 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 68 := a0, rir_reg%
               fd_curve25519_scalar_muladd.hty 70 := a1, rir_reg% fd_curve25519_scalar_muladd.hty
               72 := a2, rir_reg% fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
               fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg% fd_curve25519_scalar_muladd.hty
               83 := a3, rir_reg% fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
               fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg% fd_curve25519_scalar_muladd.hty
               89 := a8, rir_reg% fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
               fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg% fd_curve25519_scalar_muladd.hty
               93 := b0, rir_reg% fd_curve25519_scalar_muladd.hty 95 := b1, rir_reg%
               fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg% fd_curve25519_scalar_muladd.hty
               104 := a9, rir_reg% fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
               fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg% fd_curve25519_scalar_muladd.hty
               110 := b5, rir_reg% fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
               fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg% fd_curve25519_scalar_muladd.hty
               121 := b6, rir_reg% fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
               fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
               fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
               fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg% fd_curve25519_scalar_muladd.hty
               135 := c5, rir_reg% fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               150 := c9, rir_reg% fd_curve25519_scalar_muladd.hty 152 := c10, rir_reg%
               fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg% fd_curve25519_scalar_muladd.hty
               156 := t156, rir_reg% fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
               fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg% fd_curve25519_scalar_muladd.hty
               164 := t164, rir_reg% fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
               fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
               fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
               fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg% fd_curve25519_scalar_muladd.hty
               178 := t178, rir_reg% fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
               fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
               fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
               fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
               fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               198 := t198, rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
               fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
               fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
               fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
               fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
               fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
               fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
               fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg% fd_curve25519_scalar_muladd.hty
               224 := t224, rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
               fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
               fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
               fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
               fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
               fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
               fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
               fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
               fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
               fd_curve25519_scalar_muladd.hty 234 := t234, rir_reg%
               fd_curve25519_scalar_muladd.hty 235 := t235, rir_reg%
               fd_curve25519_scalar_muladd.hty 236 := t236, rir_reg%
               fd_curve25519_scalar_muladd.hty 237 := t237, rir_reg%
               fd_curve25519_scalar_muladd.hty 238 := t238, rir_reg%
               fd_curve25519_scalar_muladd.hty 243 := t243, rir_reg%
               fd_curve25519_scalar_muladd.hty 244 := t244, rir_reg%
     fd_curve25519_scalar_muladd.hty 247 := t247])
    (hba0 : Bnd a0 0 2097151)
    (hba1 : Bnd a1 0 2097151)
    (hba2 : Bnd a2 0 2097151)
    (hba4 : Bnd a4 0 2097151)
    (hba5 : Bnd a5 0 2097151)
    (hba3 : Bnd a3 0 2097151)
    (hba6 : Bnd a6 0 2097151)
    (hba7 : Bnd a7 0 2097151)
    (hba8 : Bnd a8 0 2097151)
    (hba10 : Bnd a10 0 2097151)
    (hba11 : Bnd a11 0 33554431)
    (hbb0 : Bnd b0 0 2097151)
    (hbb1 : Bnd b1 0 2097151)
    (hbb2 : Bnd b2 0 2097151)
    (hba9 : Bnd a9 0 2097151)
    (hbb3 : Bnd b3 0 2097151)
    (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151)
    (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151)
    (hbb6 : Bnd b6 0 2097151)
    (hbb9 : Bnd b9 0 2097151)
    (hbb10 : Bnd b10 0 2097151)
    (hbb11 : Bnd b11 0 33554431)
    (hbc10 : Bnd c10 0 2097151)
    (hbt234 : Bnd t234 0 4398042316801)
    (hbt235 : Bnd t235 0 4398042316801)
    (hbt236 : Bnd t236 0 4398042316801)
    (hbt237 : Bnd t237 0 4398042316801)
    (hbt238 : Bnd t238 0 4398042316801)
    (hbt243 : Bnd t243 0 4398042316801)
    (hbt244 : Bnd t244 0 4398042316801)
    (hbt247 : Bnd t247 0 17592169267204)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t248 t249 t250 t251 t252 t253 t254 s10 t256 t257 t258 t259 t260 t261 t262 t263 t264 t265
         t266 t267 t268 t269 t270 t271 t272 t273 t274 t275 t276 t277 t278 t279 t280 t281 t282 t283
        t284 t285 t286 t287 s12 t289 t290 t291 t292 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 83 := a3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 97 := b2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 108 := b4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 156 := t156, rir_reg%
                      fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
                      fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 164 := t164, rir_reg%
                      fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
                      fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
                      fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
                      fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 178 := t178, rir_reg%
                      fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
                      fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
                      fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
                      fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
                      fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 198 := t198, rir_reg%
                      fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
                      fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
                      fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
                      fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
                      fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
                      fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
                      fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
                      fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 224 := t224, rir_reg%
                      fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
                      fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
                      fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
                      fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
                      fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
                      fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
                      fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
                      fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
                      fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
                      fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
                      fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
                      fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
                      fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
                      fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
                      fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
                      fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
                      fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
                      fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
                      fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
                      fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
                      fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
                      fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
           fd_curve25519_scalar_muladd.hty 292 := t292]) →
          (ht248 : t248 = t247 + t236) →
          (ht249 : t249 = t248 + t237) →
          (ht250 : t250 = t249 + t238) →
          (ht251 : t251 = t250 + t243) →
          (ht252 : t252 = t251 + t244) →
          (ht253 : t253 = t252 + t234) →
          (ht254 : t254 = t253 + c10) →
          (hs10 : s10 = t254 + t235) →
          (ht256 : t256 = b11 * a0) →
          (ht257 : t257 = b10 * a1) →
          (ht258 : t258 = b9 * a2) →
          (ht259 : t259 = b8 * a3) →
          (ht260 : t260 = b7 * a4) →
          (ht261 : t261 = b6 * a5) →
          (ht262 : t262 = a6 * b5) →
          (ht263 : t263 = a7 * b4) →
          (ht264 : t264 = a8 * b3) →
          (ht265 : t265 = a9 * b2) →
          (ht266 : t266 = a10 * b1) →
          (ht267 : t267 = a11 * b0) →
          (ht268 : t268 = b11 * a1) →
          (ht269 : t269 = b10 * a2) →
          (ht270 : t270 = b9 * a3) →
          (ht271 : t271 = b8 * a4) →
          (ht272 : t272 = b7 * a5) →
          (ht273 : t273 = b6 * a6) →
          (ht274 : t274 = a7 * b5) →
          (ht275 : t275 = a8 * b4) →
          (ht276 : t276 = a9 * b3) →
          (ht277 : t277 = a10 * b2) →
          (ht278 : t278 = a11 * b1) →
          (ht279 : t279 = t275 + t274) →
          (ht280 : t280 = t279 + t271) →
          (ht281 : t281 = t280 + t272) →
          (ht282 : t282 = t281 + t273) →
          (ht283 : t283 = t282 + t278) →
          (ht284 : t284 = t283 + t268) →
          (ht285 : t285 = t284 + t276) →
          (ht286 : t286 = t285 + t277) →
          (ht287 : t287 = t286 + t269) →
          (hs12 : s12 = t287 + t270) →
          (ht289 : t289 = b11 * a2) →
          (ht290 : t290 = b10 * a3) →
          (ht291 : t291 = b9 * a4) →
          (ht292 : t292 = b8 * a5) →
          (hbs10 : Bnd s10 0 48378467581962) →
          (hbt256 : Bnd t256 0 70368708526081) →
          (hbt257 : Bnd t257 0 4398042316801) →
          (hbt258 : Bnd t258 0 4398042316801) →
          (hbt259 : Bnd t259 0 4398042316801) →
          (hbt260 : Bnd t260 0 4398042316801) →
          (hbt261 : Bnd t261 0 4398042316801) →
          (hbt262 : Bnd t262 0 4398042316801) →
          (hbt263 : Bnd t263 0 4398042316801) →
          (hbt264 : Bnd t264 0 4398042316801) →
          (hbt265 : Bnd t265 0 4398042316801) →
          (hbt266 : Bnd t266 0 4398042316801) →
          (hbt267 : Bnd t267 0 70368708526081) →
          (hbs12 : Bnd s12 0 180319797903371) →
          (hbt289 : Bnd t289 0 70368708526081) →
          (hbt290 : Bnd t290 0 4398042316801) →
          (hbt291 : Bnd t291 0 4398042316801) →
          (hbt292 : Bnd t292 0 4398042316801) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 293 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 248 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with t248
  sbnd t248
  step_pure [nswAdd, nuwAdd] with t249
  sbnd t249
  step_pure [nswAdd, nuwAdd] with t250
  sbnd t250
  step_pure [nswAdd, nuwAdd] with t251
  sbnd t251
  step_pure [nswAdd, nuwAdd] with t252
  sbnd t252
  step_pure [nswAdd, nuwAdd] with t253
  sbnd t253
  step_pure [nswAdd, nuwAdd] with t254
  sbnd t254
  step_pure [nswAdd, nuwAdd] with s10
  sbnd s10
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t256
  sbnd t256
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t257
  sbnd t257
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t258
  sbnd t258
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t259
  sbnd t259
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t260
  sbnd t260
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t261
  sbnd t261
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t262
  sbnd t262
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t263
  sbnd t263
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t264
  sbnd t264
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t265
  sbnd t265
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t266
  sbnd t266
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t267
  sbnd t267
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t268
  sbnd t268
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t269
  sbnd t269
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t270
  sbnd t270
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t271
  sbnd t271
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t272
  sbnd t272
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t273
  sbnd t273
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t274
  sbnd t274
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t275
  sbnd t275
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t276
  sbnd t276
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t277
  sbnd t277
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t278
  sbnd t278
  step_pure [nswAdd, nuwAdd] with t279
  sbnd t279
  step_pure [nswAdd, nuwAdd] with t280
  sbnd t280
  step_pure [nswAdd, nuwAdd] with t281
  sbnd t281
  step_pure [nswAdd, nuwAdd] with t282
  sbnd t282
  step_pure [nswAdd, nuwAdd] with t283
  sbnd t283
  step_pure [nswAdd, nuwAdd] with t284
  sbnd t284
  step_pure [nswAdd, nuwAdd] with t285
  sbnd t285
  step_pure [nswAdd, nuwAdd] with t286
  sbnd t286
  step_pure [nswAdd, nuwAdd] with t287
  sbnd t287
  step_pure [nswAdd, nuwAdd] with s12
  sbnd s12
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t289
  sbnd t289
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t290
  sbnd t290
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t291
  sbnd t291
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t292
  sbnd t292
  exact
    hK _ t248 t249 t250 t251 t252 t253 t254 s10 t256 t257 t258 t259 t260 t261 t262 t263 t264 t265
      t266 t267 t268 t269 t270 t271 t272 t273 t274 t275 t276 t277 t278 t279 t280 t281 t282 t283 t284
      t285 t286 t287 s12 t289 t290 t291 t292 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht248 ht249 ht250
      ht251 ht252 ht253 ht254 hs10 ht256 ht257 ht258 ht259 ht260 ht261 ht262 ht263 ht264 ht265 ht266
      ht267 ht268 ht269 ht270 ht271 ht272 ht273 ht274 ht275 ht276 ht277 ht278 ht279 ht280 ht281
      ht282 ht283 ht284 ht285 ht286 ht287 hs12 ht289 ht290 ht291 ht292 hbs10 hbt256 hbt257 hbt258
      hbt259 hbt260 hbt261 hbt262 hbt263 hbt264 hbt265 hbt266 hbt267 hbs12 hbt289 hbt290 hbt291
      hbt292

/-- From `%293`: the products into `s14`, `s16`. -/
theorem fd_curve25519_scalar_muladd.run293 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a4 a5 a3 a6 a7 a8 a10 a11 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 c1 c5 c3 c7 c9 c11 s0 t156 t157
     s2 t164 t165 t166 t167 s4 t178 t179 t180 t181 t182 t183 s6 t198 t199 t200 t201 t202 t203 t204
     t205 s8 t224 t225 t226 t227 t228 t229 t230 t231 t232 t233 s10 t256 t257 t258 t259 t260 t261
     t262 t263 t264 t265 t266 t267 s12 t289 t290 t291 t292 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 74 := a4, rir_reg%
               fd_curve25519_scalar_muladd.hty 76 := a5, rir_reg% fd_curve25519_scalar_muladd.hty
               83 := a3, rir_reg% fd_curve25519_scalar_muladd.hty 85 := a6, rir_reg%
               fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg% fd_curve25519_scalar_muladd.hty
               89 := a8, rir_reg% fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
               fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg% fd_curve25519_scalar_muladd.hty
               97 := b2, rir_reg% fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
               fd_curve25519_scalar_muladd.hty 106 := b3, rir_reg% fd_curve25519_scalar_muladd.hty
               108 := b4, rir_reg% fd_curve25519_scalar_muladd.hty 110 := b5, rir_reg%
               fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg% fd_curve25519_scalar_muladd.hty
               114 := b8, rir_reg% fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
               fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg% fd_curve25519_scalar_muladd.hty
               125 := b10, rir_reg% fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
               fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg% fd_curve25519_scalar_muladd.hty
               135 := c5, rir_reg% fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               150 := c9, rir_reg% fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg% fd_curve25519_scalar_muladd.hty
               156 := t156, rir_reg% fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
               fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg% fd_curve25519_scalar_muladd.hty
               164 := t164, rir_reg% fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
               fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
               fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
               fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg% fd_curve25519_scalar_muladd.hty
               178 := t178, rir_reg% fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
               fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
               fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
               fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
               fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               198 := t198, rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
               fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
               fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
               fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
               fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
               fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
               fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
               fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg% fd_curve25519_scalar_muladd.hty
               224 := t224, rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
               fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
               fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
               fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
               fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
               fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
               fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
               fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
               fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
               fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
               fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
               fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
               fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
               fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
               fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
               fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
               fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
               fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
               fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
               fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
               fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
               fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
     fd_curve25519_scalar_muladd.hty 292 := t292])
    (hba4 : Bnd a4 0 2097151)
    (hba5 : Bnd a5 0 2097151)
    (hba3 : Bnd a3 0 2097151)
    (hba6 : Bnd a6 0 2097151)
    (hba7 : Bnd a7 0 2097151)
    (hba8 : Bnd a8 0 2097151)
    (hba10 : Bnd a10 0 2097151)
    (hba11 : Bnd a11 0 33554431)
    (hbb2 : Bnd b2 0 2097151)
    (hba9 : Bnd a9 0 2097151)
    (hbb3 : Bnd b3 0 2097151)
    (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151)
    (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151)
    (hbb6 : Bnd b6 0 2097151)
    (hbb9 : Bnd b9 0 2097151)
    (hbb10 : Bnd b10 0 2097151)
    (hbb11 : Bnd b11 0 33554431)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t293 t294 t295 t296 t297 t298 t299 t300 t301 t302 t303 t304 t305 t306 t307 t308 t309 t310
         t311 t312 t313 t314 s14 t316 t317 t318 t319 t320 t321 t322 t323 t324 t325 t326 t327 t328
        t329 t330 t331 t332 t333 t334 t335 s16 t337 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 91 := a10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 112 := b7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 123 := b9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg%
                      fd_curve25519_scalar_muladd.hty 156 := t156, rir_reg%
                      fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
                      fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 164 := t164, rir_reg%
                      fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
                      fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
                      fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
                      fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 178 := t178, rir_reg%
                      fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
                      fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
                      fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
                      fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
                      fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 198 := t198, rir_reg%
                      fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
                      fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
                      fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
                      fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
                      fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
                      fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
                      fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
                      fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 224 := t224, rir_reg%
                      fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
                      fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
                      fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
                      fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
                      fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
                      fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
                      fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
                      fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
                      fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
                      fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
                      fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
                      fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
                      fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
                      fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
                      fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
                      fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
                      fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
                      fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
                      fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
                      fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
                      fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
                      fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
                      fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
                      fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
                      fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
                      fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
                      fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
                      fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
                      fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
                      fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
                      fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
                      fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
                      fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
                      fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
                      fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
                      fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
                      fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
                      fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
           fd_curve25519_scalar_muladd.hty 337 := t337]) →
          (ht293 : t293 = b7 * a6) →
          (ht294 : t294 = b6 * a7) →
          (ht295 : t295 = a8 * b5) →
          (ht296 : t296 = a9 * b4) →
          (ht297 : t297 = a10 * b3) →
          (ht298 : t298 = a11 * b2) →
          (ht299 : t299 = b11 * a3) →
          (ht300 : t300 = b10 * a4) →
          (ht301 : t301 = b9 * a5) →
          (ht302 : t302 = b8 * a6) →
          (ht303 : t303 = b7 * a7) →
          (ht304 : t304 = b6 * a8) →
          (ht305 : t305 = a9 * b5) →
          (ht306 : t306 = a10 * b4) →
          (ht307 : t307 = a11 * b3) →
          (ht308 : t308 = t303 + t302) →
          (ht309 : t309 = t308 + t304) →
          (ht310 : t310 = t309 + t307) →
          (ht311 : t311 = t310 + t299) →
          (ht312 : t312 = t311 + t305) →
          (ht313 : t313 = t312 + t306) →
          (ht314 : t314 = t313 + t300) →
          (hs14 : s14 = t314 + t301) →
          (ht316 : t316 = b11 * a4) →
          (ht317 : t317 = b10 * a5) →
          (ht318 : t318 = b9 * a6) →
          (ht319 : t319 = b8 * a7) →
          (ht320 : t320 = b7 * a8) →
          (ht321 : t321 = a9 * b6) →
          (ht322 : t322 = a10 * b5) →
          (ht323 : t323 = a11 * b4) →
          (ht324 : t324 = b11 * a5) →
          (ht325 : t325 = b10 * a6) →
          (ht326 : t326 = b9 * a7) →
          (ht327 : t327 = b8 * a8) →
          (ht328 : t328 = a9 * b7) →
          (ht329 : t329 = a10 * b6) →
          (ht330 : t330 = a11 * b5) →
          (ht331 : t331 = t330 + t327) →
          (ht332 : t332 = t331 + t324) →
          (ht333 : t333 = t332 + t328) →
          (ht334 : t334 = t333 + t329) →
          (ht335 : t335 = t334 + t325) →
          (hs16 : s16 = t335 + t326) →
          (ht337 : t337 = b11 * a6) →
          (hbt293 : Bnd t293 0 4398042316801) →
          (hbt294 : Bnd t294 0 4398042316801) →
          (hbt295 : Bnd t295 0 4398042316801) →
          (hbt296 : Bnd t296 0 4398042316801) →
          (hbt297 : Bnd t297 0 4398042316801) →
          (hbt298 : Bnd t298 0 70368708526081) →
          (hbs14 : Bnd s14 0 171523713269769) →
          (hbt316 : Bnd t316 0 70368708526081) →
          (hbt317 : Bnd t317 0 4398042316801) →
          (hbt318 : Bnd t318 0 4398042316801) →
          (hbt319 : Bnd t319 0 4398042316801) →
          (hbt320 : Bnd t320 0 4398042316801) →
          (hbt321 : Bnd t321 0 4398042316801) →
          (hbt322 : Bnd t322 0 4398042316801) →
          (hbt323 : Bnd t323 0 70368708526081) →
          (hbs16 : Bnd s16 0 162727628636167) →
          (hbt337 : Bnd t337 0 70368708526081) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 338 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 293 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t293
  sbnd t293
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t294
  sbnd t294
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t295
  sbnd t295
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t296
  sbnd t296
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t297
  sbnd t297
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t298
  sbnd t298
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t299
  sbnd t299
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t300
  sbnd t300
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t301
  sbnd t301
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t302
  sbnd t302
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t303
  sbnd t303
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t304
  sbnd t304
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t305
  sbnd t305
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t306
  sbnd t306
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t307
  sbnd t307
  step_pure [nswAdd, nuwAdd] with t308
  sbnd t308
  step_pure [nswAdd, nuwAdd] with t309
  sbnd t309
  step_pure [nswAdd, nuwAdd] with t310
  sbnd t310
  step_pure [nswAdd, nuwAdd] with t311
  sbnd t311
  step_pure [nswAdd, nuwAdd] with t312
  sbnd t312
  step_pure [nswAdd, nuwAdd] with t313
  sbnd t313
  step_pure [nswAdd, nuwAdd] with t314
  sbnd t314
  step_pure [nswAdd, nuwAdd] with s14
  sbnd s14
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t316
  sbnd t316
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t317
  sbnd t317
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t318
  sbnd t318
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t319
  sbnd t319
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t320
  sbnd t320
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t321
  sbnd t321
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t322
  sbnd t322
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t323
  sbnd t323
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t324
  sbnd t324
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t325
  sbnd t325
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t326
  sbnd t326
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t327
  sbnd t327
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t328
  sbnd t328
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t329
  sbnd t329
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t330
  sbnd t330
  step_pure [nswAdd, nuwAdd] with t331
  sbnd t331
  step_pure [nswAdd, nuwAdd] with t332
  sbnd t332
  step_pure [nswAdd, nuwAdd] with t333
  sbnd t333
  step_pure [nswAdd, nuwAdd] with t334
  sbnd t334
  step_pure [nswAdd, nuwAdd] with t335
  sbnd t335
  step_pure [nswAdd, nuwAdd] with s16
  sbnd s16
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t337
  sbnd t337
  exact
    hK _ t293 t294 t295 t296 t297 t298 t299 t300 t301 t302 t303 t304 t305 t306 t307 t308 t309 t310
      t311 t312 t313 t314 s14 t316 t317 t318 t319 t320 t321 t322 t323 t324 t325 t326 t327 t328 t329
      t330 t331 t332 t333 t334 t335 s16 t337 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht293 ht294 ht295
      ht296 ht297 ht298 ht299 ht300 ht301 ht302 ht303 ht304 ht305 ht306 ht307 ht308 ht309 ht310
      ht311 ht312 ht313 ht314 hs14 ht316 ht317 ht318 ht319 ht320 ht321 ht322 ht323 ht324 ht325 ht326
      ht327 ht328 ht329 ht330 ht331 ht332 ht333 ht334 ht335 hs16 ht337 hbt293 hbt294 hbt295 hbt296
      hbt297 hbt298 hbs14 hbt316 hbt317 hbt318 hbt319 hbt320 hbt321 hbt322 hbt323 hbs16 hbt337

/-- From `%338`: the products into `s18` … `s3`, the carries `carry0`, `carry2`, `carry4`. -/
theorem fd_curve25519_scalar_muladd.run338 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a7 a8 a10 a11 a9 b7 b8 b6 b9 b10 b11 c1 c5 c3 c7 c9 c11 s0 t156 t157 s2 t164 t165 t166 t167 s4
     t178 t179 t180 t181 t182 t183 s6 t198 t199 t200 t201 t202 t203 t204 t205 s8 t224 t225 t226
     t227 t228 t229 t230 t231 t232 t233 s10 t256 t257 t258 t259 t260 t261 t262 t263 t264 t265 t266
     t267 s12 t289 t290 t291 t292 t293 t294 t295 t296 t297 t298 s14 t316 t317 t318 t319 t320 t321
     t322 t323 s16 t337 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 87 := a7, rir_reg%
               fd_curve25519_scalar_muladd.hty 89 := a8, rir_reg% fd_curve25519_scalar_muladd.hty
               91 := a10, rir_reg% fd_curve25519_scalar_muladd.hty 92 := a11, rir_reg%
               fd_curve25519_scalar_muladd.hty 104 := a9, rir_reg% fd_curve25519_scalar_muladd.hty
               112 := b7, rir_reg% fd_curve25519_scalar_muladd.hty 114 := b8, rir_reg%
               fd_curve25519_scalar_muladd.hty 121 := b6, rir_reg% fd_curve25519_scalar_muladd.hty
               123 := b9, rir_reg% fd_curve25519_scalar_muladd.hty 125 := b10, rir_reg%
               fd_curve25519_scalar_muladd.hty 126 := b11, rir_reg%
               fd_curve25519_scalar_muladd.hty 129 := c1, rir_reg% fd_curve25519_scalar_muladd.hty
               135 := c5, rir_reg% fd_curve25519_scalar_muladd.hty 142 := c3, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               150 := c9, rir_reg% fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 155 := s0, rir_reg% fd_curve25519_scalar_muladd.hty
               156 := t156, rir_reg% fd_curve25519_scalar_muladd.hty 157 := t157, rir_reg%
               fd_curve25519_scalar_muladd.hty 163 := s2, rir_reg% fd_curve25519_scalar_muladd.hty
               164 := t164, rir_reg% fd_curve25519_scalar_muladd.hty 165 := t165, rir_reg%
               fd_curve25519_scalar_muladd.hty 166 := t166, rir_reg%
               fd_curve25519_scalar_muladd.hty 167 := t167, rir_reg%
               fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg% fd_curve25519_scalar_muladd.hty
               178 := t178, rir_reg% fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
               fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
               fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
               fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
               fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               198 := t198, rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
               fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
               fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
               fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
               fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
               fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
               fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
               fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg% fd_curve25519_scalar_muladd.hty
               224 := t224, rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
               fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
               fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
               fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
               fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
               fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
               fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
               fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
               fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
               fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
               fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
               fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
               fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
               fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
               fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
               fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
               fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
               fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
               fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
               fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
               fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
               fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
               fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
               fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
               fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
               fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
               fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
               fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
               fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
               fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
               fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
               fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
               fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
               fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
               fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
               fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
               fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
               fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
               fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
     fd_curve25519_scalar_muladd.hty 337 := t337])
    (hba7 : Bnd a7 0 2097151)
    (hba8 : Bnd a8 0 2097151)
    (hba10 : Bnd a10 0 2097151)
    (hba11 : Bnd a11 0 33554431)
    (hba9 : Bnd a9 0 2097151)
    (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151)
    (hbb6 : Bnd b6 0 2097151)
    (hbb9 : Bnd b9 0 2097151)
    (hbb10 : Bnd b10 0 2097151)
    (hbb11 : Bnd b11 0 33554431)
    (hbc1 : Bnd c1 0 2097151)
    (hbc3 : Bnd c3 0 2097151)
    (hbs0 : Bnd s0 0 4398044413952)
    (hbt156 : Bnd t156 0 4398042316801)
    (hbt157 : Bnd t157 0 4398042316801)
    (hbs2 : Bnd s2 0 13194129047554)
    (hbt164 : Bnd t164 0 4398042316801)
    (hbt165 : Bnd t165 0 4398042316801)
    (hbt166 : Bnd t166 0 4398042316801)
    (hbt167 : Bnd t167 0 4398042316801)
    (hbs4 : Bnd s4 0 21990213681156)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t338 t339 t340 t341 t342 t343 t344 t345 t346 t347 t348 t349 t350 s18 t352 t353 t354 t355
         t356 t357 t358 t359 s20 t361 t362 s21 s22 t365 carry0 t367 s1 s1_1 s0_1 t372 carry2 t374
        t375 t376 s3 s3_1 s2_1 t381 carry4 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 150 := c9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 178 := t178, rir_reg%
                      fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
                      fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
                      fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
                      fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
                      fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 198 := t198, rir_reg%
                      fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
                      fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
                      fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
                      fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
                      fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
                      fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
                      fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
                      fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 224 := t224, rir_reg%
                      fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
                      fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
                      fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
                      fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
                      fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
                      fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
                      fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
                      fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
                      fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
                      fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
                      fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
                      fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
                      fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
                      fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
                      fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
                      fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
                      fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
                      fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
                      fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
                      fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
                      fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
                      fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
                      fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
                      fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
                      fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
                      fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
                      fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
                      fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
                      fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
                      fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
                      fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
                      fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
                      fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
                      fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
                      fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
                      fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
                      fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
                      fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
                      fd_curve25519_scalar_muladd.hty 337 := t337, rir_reg%
                      fd_curve25519_scalar_muladd.hty 338 := t338, rir_reg%
                      fd_curve25519_scalar_muladd.hty 339 := t339, rir_reg%
                      fd_curve25519_scalar_muladd.hty 340 := t340, rir_reg%
                      fd_curve25519_scalar_muladd.hty 341 := t341, rir_reg%
                      fd_curve25519_scalar_muladd.hty 342 := t342, rir_reg%
                      fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
                      fd_curve25519_scalar_muladd.hty 352 := t352, rir_reg%
                      fd_curve25519_scalar_muladd.hty 353 := t353, rir_reg%
                      fd_curve25519_scalar_muladd.hty 354 := t354, rir_reg%
                      fd_curve25519_scalar_muladd.hty 355 := t355, rir_reg%
                      fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
                      fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
                      fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
                      fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 381 := t381, rir_reg%
           fd_curve25519_scalar_muladd.hty 382 := carry4]) →
          (ht338 : t338 = b10 * a7) →
          (ht339 : t339 = b9 * a8) →
          (ht340 : t340 = a9 * b8) →
          (ht341 : t341 = a10 * b7) →
          (ht342 : t342 = a11 * b6) →
          (ht343 : t343 = b11 * a7) →
          (ht344 : t344 = b10 * a8) →
          (ht345 : t345 = b9 * a9) →
          (ht346 : t346 = a10 * b8) →
          (ht347 : t347 = a11 * b7) →
          (ht348 : t348 = t343 + t347) →
          (ht349 : t349 = t348 + t346) →
          (ht350 : t350 = t349 + t344) →
          (hs18 : s18 = t350 + t345) →
          (ht352 : t352 = b11 * a8) →
          (ht353 : t353 = b10 * a9) →
          (ht354 : t354 = b9 * a10) →
          (ht355 : t355 = a11 * b8) →
          (ht356 : t356 = a9 * b11) →
          (ht357 : t357 = b10 * a10) →
          (ht358 : t358 = t357 + t356) →
          (ht359 : t359 = b9 * a11) →
          (hs20 : s20 = t358 + t359) →
          (ht361 : t361 = a10 * b11) →
          (ht362 : t362 = b10 * a11) →
          (hs21 : s21 = t362 + t361) →
          (hs22 : s22 = b11 * a11) →
          (ht365 : t365 = s0 + 1048576#64) →
          (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21) →
          (ht367 : t367 = t156 + t157) →
          (hs1 : s1 = t367 + c1) →
          (hs1_1 : s1_1 = s1 + carry0) →
          (hs0_1 : s0_1 = s0 - ((BitVec.sshiftRight (s0 + 1048576#64) 21) <<< 21)) →
          (ht372 : t372 = s2 + 1048576#64) →
          (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21) →
          (ht374 : t374 = t166 + t165) →
          (ht375 : t375 = t374 + t167) →
          (ht376 : t376 = t375 + t164) →
          (hs3 : s3 = t376 + c3) →
          (hs3_1 : s3_1 = s3 + carry2) →
          (hs2_1 : s2_1 = s2 - ((BitVec.sshiftRight (s2 + 1048576#64) 21) <<< 21)) →
          (ht381 : t381 = s4 + 1048576#64) →
          (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21) →
          (hbt338 : Bnd t338 0 4398042316801) →
          (hbt339 : Bnd t339 0 4398042316801) →
          (hbt340 : Bnd t340 0 4398042316801) →
          (hbt341 : Bnd t341 0 4398042316801) →
          (hbt342 : Bnd t342 0 70368708526081) →
          (hbs18 : Bnd s18 0 153931544002565) →
          (hbt352 : Bnd t352 0 70368708526081) →
          (hbt353 : Bnd t353 0 4398042316801) →
          (hbt354 : Bnd t354 0 4398042316801) →
          (hbt355 : Bnd t355 0 70368708526081) →
          (hbs20 : Bnd s20 0 145135459368963) →
          (hbs21 : Bnd s21 0 140737417052162) →
          (hbs22 : Bnd s22 0 1125899839733761) →
          (hbs1_1 : Bnd s1_1 0 8796088827904) →
          (hbs0_1 : Bnd s0_1 (-1048576) 1048575) →
          (hbs3_1 : Bnd s3_1 0 17592177655806) →
          (hbs2_1 : Bnd s2_1 (-1048576) 1048575) →
          (hbcarry4 : Bnd carry4 0 10485751) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 383 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 338 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t338
  sbnd t338
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t339
  sbnd t339
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t340
  sbnd t340
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t341
  sbnd t341
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t342
  sbnd t342
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t343
  sbnd t343
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t344
  sbnd t344
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t345
  sbnd t345
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t346
  sbnd t346
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t347
  sbnd t347
  step_pure [nswAdd, nuwAdd] with t348
  sbnd t348
  step_pure [nswAdd, nuwAdd] with t349
  sbnd t349
  step_pure [nswAdd, nuwAdd] with t350
  sbnd t350
  step_pure [nswAdd, nuwAdd] with s18
  sbnd s18
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t352
  sbnd t352
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t353
  sbnd t353
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t354
  sbnd t354
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t355
  sbnd t355
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t356
  sbnd t356
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t357
  sbnd t357
  step_pure [nswAdd, nuwAdd] with t358
  sbnd t358
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t359
  sbnd t359
  step_pure [nswAdd, nuwAdd] with s20
  sbnd s20
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t361
  sbnd t361
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t362
  sbnd t362
  step_pure [nswAdd, nuwAdd] with s21
  sbnd s21
  step_pure [Sc.nswMulV, Sc.nuwMulV] with s22
  sbnd s22
  step_pure [nswAdd, nuwAdd] with t365
  step_pure [ht365, lshrNonneg] with carry0
  sbnd carry0
  step_pure [nswAdd, nuwAdd] with t367
  sbnd t367
  step_pure [nswAdd, nuwAdd] with s1
  sbnd s1
  step_pure [nswAdd, nuwAdd] with s1_1
  sbnd s1_1
  step_pure [ht365, Sc.andMaskN]
  step_pure [Sc.nswSubS] with s0_1
  sbnd s0_1
  step_pure [nswAdd, nuwAdd] with t372
  step_pure [ht372, lshrNonneg] with carry2
  sbnd carry2
  step_pure [nswAdd, nuwAdd] with t374
  sbnd t374
  step_pure [nswAdd, nuwAdd] with t375
  sbnd t375
  step_pure [nswAdd, nuwAdd] with t376
  sbnd t376
  step_pure [nswAdd, nuwAdd] with s3
  sbnd s3
  step_pure [nswAdd, nuwAdd] with s3_1
  sbnd s3_1
  step_pure [ht372, Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s2_1
  sbnd s2_1
  step_pure [nswAdd, nuwAdd] with t381
  step_pure [ht381, lshrNonneg] with carry4
  sbnd carry4
  exact
    hK _ t338 t339 t340 t341 t342 t343 t344 t345 t346 t347 t348 t349 t350 s18 t352 t353 t354 t355
      t356 t357 t358 t359 s20 t361 t362 s21 s22 t365 carry0 t367 s1 s1_1 s0_1 t372 carry2 t374 t375
      t376 s3 s3_1 s2_1 t381 carry4 hArgs (by unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht338 ht339 ht340 ht341 ht342 ht343 ht344 ht345 ht346 ht347 ht348 ht349 ht350
      hs18 ht352 ht353 ht354 ht355 ht356 ht357 ht358 ht359 hs20 ht361 ht362 hs21 hs22 ht365 hcarry0
      ht367 hs1 hs1_1 hs0_1 ht372 hcarry2 ht374 ht375 ht376 hs3 hs3_1 hs2_1 ht381 hcarry4 hbt338
      hbt339 hbt340 hbt341 hbt342 hbs18 hbt352 hbt353 hbt354 hbt355 hbs20 hbs21 hbs22 hbs1_1 hbs0_1
      hbs3_1 hbs2_1 hbcarry4

/-- From `%383`: the products into `s5`, `s7`, `s9`, the carries `carry6`, `carry8`, `carry10`. -/
theorem fd_curve25519_scalar_muladd.run383 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {c5 c7 c9 c11 s4 t178 t179 t180 t181 t182 t183 s6 t198 t199 t200 t201 t202 t203 t204 t205 s8
     t224 t225 t226 t227 t228 t229 t230 t231 t232 t233 s10 t256 t257 t258 t259 t260 t261 t262 t263
     t264 t265 t266 t267 s12 t289 t290 t291 t292 t293 t294 t295 t296 t297 t298 s14 t316 t317 t318
     t319 t320 t321 t322 t323 s16 t337 t338 t339 t340 t341 t342 s18 t352 t353 t354 t355 s20 s21 s22
     s1_1 s0_1 s3_1 s2_1 t381 carry4 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 135 := c5, rir_reg%
               fd_curve25519_scalar_muladd.hty 146 := c7, rir_reg% fd_curve25519_scalar_muladd.hty
               150 := c9, rir_reg% fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 177 := s4, rir_reg% fd_curve25519_scalar_muladd.hty
               178 := t178, rir_reg% fd_curve25519_scalar_muladd.hty 179 := t179, rir_reg%
               fd_curve25519_scalar_muladd.hty 180 := t180, rir_reg%
               fd_curve25519_scalar_muladd.hty 181 := t181, rir_reg%
               fd_curve25519_scalar_muladd.hty 182 := t182, rir_reg%
               fd_curve25519_scalar_muladd.hty 183 := t183, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               198 := t198, rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199, rir_reg%
               fd_curve25519_scalar_muladd.hty 200 := t200, rir_reg%
               fd_curve25519_scalar_muladd.hty 201 := t201, rir_reg%
               fd_curve25519_scalar_muladd.hty 202 := t202, rir_reg%
               fd_curve25519_scalar_muladd.hty 203 := t203, rir_reg%
               fd_curve25519_scalar_muladd.hty 204 := t204, rir_reg%
               fd_curve25519_scalar_muladd.hty 205 := t205, rir_reg%
               fd_curve25519_scalar_muladd.hty 223 := s8, rir_reg% fd_curve25519_scalar_muladd.hty
               224 := t224, rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225, rir_reg%
               fd_curve25519_scalar_muladd.hty 226 := t226, rir_reg%
               fd_curve25519_scalar_muladd.hty 227 := t227, rir_reg%
               fd_curve25519_scalar_muladd.hty 228 := t228, rir_reg%
               fd_curve25519_scalar_muladd.hty 229 := t229, rir_reg%
               fd_curve25519_scalar_muladd.hty 230 := t230, rir_reg%
               fd_curve25519_scalar_muladd.hty 231 := t231, rir_reg%
               fd_curve25519_scalar_muladd.hty 232 := t232, rir_reg%
               fd_curve25519_scalar_muladd.hty 233 := t233, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 256 := t256, rir_reg%
               fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
               fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
               fd_curve25519_scalar_muladd.hty 259 := t259, rir_reg%
               fd_curve25519_scalar_muladd.hty 260 := t260, rir_reg%
               fd_curve25519_scalar_muladd.hty 261 := t261, rir_reg%
               fd_curve25519_scalar_muladd.hty 262 := t262, rir_reg%
               fd_curve25519_scalar_muladd.hty 263 := t263, rir_reg%
               fd_curve25519_scalar_muladd.hty 264 := t264, rir_reg%
               fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
               fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
               fd_curve25519_scalar_muladd.hty 267 := t267, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
               fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
               fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
               fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
               fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
               fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
               fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
               fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
               fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
               fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
               fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
               fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
               fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
               fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
               fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
               fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
               fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
               fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
               fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
               fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
               fd_curve25519_scalar_muladd.hty 337 := t337, rir_reg%
               fd_curve25519_scalar_muladd.hty 338 := t338, rir_reg%
               fd_curve25519_scalar_muladd.hty 339 := t339, rir_reg%
               fd_curve25519_scalar_muladd.hty 340 := t340, rir_reg%
               fd_curve25519_scalar_muladd.hty 341 := t341, rir_reg%
               fd_curve25519_scalar_muladd.hty 342 := t342, rir_reg%
               fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
               fd_curve25519_scalar_muladd.hty 352 := t352, rir_reg%
               fd_curve25519_scalar_muladd.hty 353 := t353, rir_reg%
               fd_curve25519_scalar_muladd.hty 354 := t354, rir_reg%
               fd_curve25519_scalar_muladd.hty 355 := t355, rir_reg%
               fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
               fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
               fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
               fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 381 := t381, rir_reg%
     fd_curve25519_scalar_muladd.hty 382 := carry4])
    (hbc5 : Bnd c5 0 2097151)
    (hbc7 : Bnd c7 0 2097151)
    (hbc9 : Bnd c9 0 2097151)
    (hbs4 : Bnd s4 0 21990213681156)
    (hbt178 : Bnd t178 0 4398042316801)
    (hbt179 : Bnd t179 0 4398042316801)
    (hbt180 : Bnd t180 0 4398042316801)
    (hbt181 : Bnd t181 0 4398042316801)
    (hbt182 : Bnd t182 0 4398042316801)
    (hbt183 : Bnd t183 0 4398042316801)
    (hbs6 : Bnd s6 0 30786298314758)
    (hbt198 : Bnd t198 0 4398042316801)
    (hbt199 : Bnd t199 0 4398042316801)
    (hbt200 : Bnd t200 0 4398042316801)
    (hbt201 : Bnd t201 0 4398042316801)
    (hbt202 : Bnd t202 0 4398042316801)
    (hbt203 : Bnd t203 0 4398042316801)
    (hbt204 : Bnd t204 0 4398042316801)
    (hbt205 : Bnd t205 0 4398042316801)
    (hbs8 : Bnd s8 0 39582382948360)
    (hbt224 : Bnd t224 0 4398042316801)
    (hbt225 : Bnd t225 0 4398042316801)
    (hbt226 : Bnd t226 0 4398042316801)
    (hbt227 : Bnd t227 0 4398042316801)
    (hbt228 : Bnd t228 0 4398042316801)
    (hbt229 : Bnd t229 0 4398042316801)
    (hbt230 : Bnd t230 0 4398042316801)
    (hbt231 : Bnd t231 0 4398042316801)
    (hbt232 : Bnd t232 0 4398042316801)
    (hbt233 : Bnd t233 0 4398042316801)
    (hbs10 : Bnd s10 0 48378467581962)
    (hbt256 : Bnd t256 0 70368708526081)
    (hbt259 : Bnd t259 0 4398042316801)
    (hbt260 : Bnd t260 0 4398042316801)
    (hbt261 : Bnd t261 0 4398042316801)
    (hbt262 : Bnd t262 0 4398042316801)
    (hbt263 : Bnd t263 0 4398042316801)
    (hbt264 : Bnd t264 0 4398042316801)
    (hbt267 : Bnd t267 0 70368708526081)
    (ht381 : t381 = s4 + 1048576#64)
    (hbcarry4 : Bnd carry4 0 10485751)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t383 t384 t385 t386 t387 s5 s5_1 s4_1 t392 carry6 t394 t395 t396 t397 t398 t399 t400 s7
         s7_1 t403 t404 carry8 t406 t407 t408 t409 t410 t411 t412 t413 t414 s9 s9_1 s8_1 t419
        carry10 t421 t422 t423 t424 t425 t426 t427 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
                      fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
                      fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
                      fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
                      fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
                      fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
                      fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
                      fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
                      fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
                      fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
                      fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
                      fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
                      fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
                      fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
                      fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
                      fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
                      fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
                      fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
                      fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
                      fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
                      fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
                      fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
                      fd_curve25519_scalar_muladd.hty 337 := t337, rir_reg%
                      fd_curve25519_scalar_muladd.hty 338 := t338, rir_reg%
                      fd_curve25519_scalar_muladd.hty 339 := t339, rir_reg%
                      fd_curve25519_scalar_muladd.hty 340 := t340, rir_reg%
                      fd_curve25519_scalar_muladd.hty 341 := t341, rir_reg%
                      fd_curve25519_scalar_muladd.hty 342 := t342, rir_reg%
                      fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
                      fd_curve25519_scalar_muladd.hty 352 := t352, rir_reg%
                      fd_curve25519_scalar_muladd.hty 353 := t353, rir_reg%
                      fd_curve25519_scalar_muladd.hty 354 := t354, rir_reg%
                      fd_curve25519_scalar_muladd.hty 355 := t355, rir_reg%
                      fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
                      fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
                      fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
                      fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 389 := s5_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 391 := s4_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 402 := s7_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
                      fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 418 := s8_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 419 := t419, rir_reg%
                      fd_curve25519_scalar_muladd.hty 420 := carry10, rir_reg%
           fd_curve25519_scalar_muladd.hty 427 := t427]) →
          (ht383 : t383 = t182 + t181) →
          (ht384 : t384 = t383 + t183) →
          (ht385 : t385 = t384 + t178) →
          (ht386 : t386 = t385 + c5) →
          (ht387 : t387 = t386 + t179) →
          (hs5 : s5 = t387 + t180) →
          (hs5_1 : s5_1 = s5 + carry4) →
          (hs4_1 : s4_1 = s4 - ((BitVec.sshiftRight (s4 + 1048576#64) 21) <<< 21)) →
          (ht392 : t392 = s6 + 1048576#64) →
          (hcarry6 : carry6 = BitVec.sshiftRight (s6 + 1048576#64) 21) →
          (ht394 : t394 = t200 + t203) →
          (ht395 : t395 = t394 + t201) →
          (ht396 : t396 = t395 + t202) →
          (ht397 : t397 = t396 + t204) →
          (ht398 : t398 = t397 + t205) →
          (ht399 : t399 = t398 + t198) →
          (ht400 : t400 = t399 + c7) →
          (hs7 : s7 = t400 + t199) →
          (hs7_1 : s7_1 = s7 + carry6) →
          (ht403 : t403 = (BitVec.sshiftRight (s6 + 1048576#64) 21) <<< 21) →
          (ht404 : t404 = s8 + 1048576#64) →
          (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21) →
          (ht406 : t406 = t229 + t228) →
          (ht407 : t407 = t406 + t230) →
          (ht408 : t408 = t407 + t231) →
          (ht409 : t409 = t408 + t232) →
          (ht410 : t410 = t409 + t225) →
          (ht411 : t411 = t410 + t226) →
          (ht412 : t412 = t411 + t227) →
          (ht413 : t413 = t412 + t233) →
          (ht414 : t414 = t413 + t224) →
          (hs9 : s9 = t414 + c9) →
          (hs9_1 : s9_1 = s9 + carry8) →
          (hs8_1 : s8_1 = s8 - ((BitVec.sshiftRight (s8 + 1048576#64) 21) <<< 21)) →
          (ht419 : t419 = s10 + 1048576#64) →
          (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21) →
          (ht421 : t421 = t263 + t262) →
          (ht422 : t422 = t421 + t264) →
          (ht423 : t423 = t422 + t259) →
          (ht424 : t424 = t423 + t260) →
          (ht425 : t425 = t424 + t261) →
          (ht426 : t426 = t425 + t267) →
          (ht427 : t427 = t426 + t256) →
          (hbs5_1 : Bnd s5_1 0 26388266483708) →
          (hbs4_1 : Bnd s4_1 (-1048576) 1048575) →
          (hbs7_1 : Bnd s7_1 0 35184355311610) →
          (hbs9_1 : Bnd s9_1 0 43980444139512) →
          (hbs8_1 : Bnd s8_1 (-1048576) 1048575) →
          (hbcarry10 : Bnd carry10 0 23068651) →
          (hbt427 : Bnd t427 0 167125670952968) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 428 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 383 S >>= g) = K := by
  fold_eqs
  step_pure [nswAdd, nuwAdd] with t383
  sbnd t383
  step_pure [nswAdd, nuwAdd] with t384
  sbnd t384
  step_pure [nswAdd, nuwAdd] with t385
  sbnd t385
  step_pure [nswAdd, nuwAdd] with t386
  sbnd t386
  step_pure [nswAdd, nuwAdd] with t387
  sbnd t387
  step_pure [nswAdd, nuwAdd] with s5
  sbnd s5
  step_pure [nswAdd, nuwAdd] with s5_1
  sbnd s5_1
  step_pure [ht381, Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s4_1
  sbnd s4_1
  step_pure [nswAdd, nuwAdd] with t392
  step_pure [ht392, lshrNonneg] with carry6
  sbnd carry6
  step_pure [nswAdd, nuwAdd] with t394
  sbnd t394
  step_pure [nswAdd, nuwAdd] with t395
  sbnd t395
  step_pure [nswAdd, nuwAdd] with t396
  sbnd t396
  step_pure [nswAdd, nuwAdd] with t397
  sbnd t397
  step_pure [nswAdd, nuwAdd] with t398
  sbnd t398
  step_pure [nswAdd, nuwAdd] with t399
  sbnd t399
  step_pure [nswAdd, nuwAdd] with t400
  sbnd t400
  step_pure [nswAdd, nuwAdd] with s7
  sbnd s7
  step_pure [nswAdd, nuwAdd] with s7_1
  sbnd s7_1
  step_pure [ht392, Bnd.and_neg_shift] with t403
  step_pure [nswAdd, nuwAdd] with t404
  step_pure [ht404, lshrNonneg] with carry8
  sbnd carry8
  step_pure [nswAdd, nuwAdd] with t406
  sbnd t406
  step_pure [nswAdd, nuwAdd] with t407
  sbnd t407
  step_pure [nswAdd, nuwAdd] with t408
  sbnd t408
  step_pure [nswAdd, nuwAdd] with t409
  sbnd t409
  step_pure [nswAdd, nuwAdd] with t410
  sbnd t410
  step_pure [nswAdd, nuwAdd] with t411
  sbnd t411
  step_pure [nswAdd, nuwAdd] with t412
  sbnd t412
  step_pure [nswAdd, nuwAdd] with t413
  sbnd t413
  step_pure [nswAdd, nuwAdd] with t414
  sbnd t414
  step_pure [nswAdd, nuwAdd] with s9
  sbnd s9
  step_pure [nswAdd, nuwAdd] with s9_1
  sbnd s9_1
  step_pure [ht404, Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s8_1
  sbnd s8_1
  step_pure [nswAdd, nuwAdd] with t419
  step_pure [ht419, lshrNonneg] with carry10
  sbnd carry10
  step_pure [nswAdd, nuwAdd] with t421
  sbnd t421
  step_pure [nswAdd, nuwAdd] with t422
  sbnd t422
  step_pure [nswAdd, nuwAdd] with t423
  sbnd t423
  step_pure [nswAdd, nuwAdd] with t424
  sbnd t424
  step_pure [nswAdd, nuwAdd] with t425
  sbnd t425
  step_pure [nswAdd, nuwAdd] with t426
  sbnd t426
  step_pure [nswAdd, nuwAdd] with t427
  sbnd t427
  exact
    hK _ t383 t384 t385 t386 t387 s5 s5_1 s4_1 t392 carry6 t394 t395 t396 t397 t398 t399 t400 s7
      s7_1 t403 t404 carry8 t406 t407 t408 t409 t410 t411 t412 t413 t414 s9 s9_1 s8_1 t419 carry10
      t421 t422 t423 t424 t425 t426 t427 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht383 ht384 ht385
      ht386 ht387 hs5 hs5_1 hs4_1 ht392 hcarry6 ht394 ht395 ht396 ht397 ht398 ht399 ht400 hs7 hs7_1
      ht403 ht404 hcarry8 ht406 ht407 ht408 ht409 ht410 ht411 ht412 ht413 ht414 hs9 hs9_1 hs8_1
      ht419 hcarry10 ht421 ht422 ht423 ht424 ht425 ht426 ht427 hbs5_1 hbs4_1 hbs7_1 hbs9_1 hbs8_1
      hbcarry10 hbt427

/-- From `%428`: the products into `s11` … `s19`, the carries `carry12`, `carry14`, `carry16`,
  `carry18`. -/
theorem fd_curve25519_scalar_muladd.run428 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {c11 s6 s10 t257 t258 t265 t266 s12 t289 t290 t291 t292 t293 t294 t295 t296 t297 t298 s14 t316
     t317 t318 t319 t320 t321 t322 t323 s16 t337 t338 t339 t340 t341 t342 s18 t352 t353 t354 t355
     s20 s21 s22 s1_1 s0_1 s3_1 s2_1 s5_1 s4_1 s7_1 t403 s9_1 s8_1 t419 carry10 t427 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 153 := c11, rir_reg%
               fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg% fd_curve25519_scalar_muladd.hty
               255 := s10, rir_reg% fd_curve25519_scalar_muladd.hty 257 := t257, rir_reg%
               fd_curve25519_scalar_muladd.hty 258 := t258, rir_reg%
               fd_curve25519_scalar_muladd.hty 265 := t265, rir_reg%
               fd_curve25519_scalar_muladd.hty 266 := t266, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 289 := t289, rir_reg%
               fd_curve25519_scalar_muladd.hty 290 := t290, rir_reg%
               fd_curve25519_scalar_muladd.hty 291 := t291, rir_reg%
               fd_curve25519_scalar_muladd.hty 292 := t292, rir_reg%
               fd_curve25519_scalar_muladd.hty 293 := t293, rir_reg%
               fd_curve25519_scalar_muladd.hty 294 := t294, rir_reg%
               fd_curve25519_scalar_muladd.hty 295 := t295, rir_reg%
               fd_curve25519_scalar_muladd.hty 296 := t296, rir_reg%
               fd_curve25519_scalar_muladd.hty 297 := t297, rir_reg%
               fd_curve25519_scalar_muladd.hty 298 := t298, rir_reg%
               fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
               fd_curve25519_scalar_muladd.hty 316 := t316, rir_reg%
               fd_curve25519_scalar_muladd.hty 317 := t317, rir_reg%
               fd_curve25519_scalar_muladd.hty 318 := t318, rir_reg%
               fd_curve25519_scalar_muladd.hty 319 := t319, rir_reg%
               fd_curve25519_scalar_muladd.hty 320 := t320, rir_reg%
               fd_curve25519_scalar_muladd.hty 321 := t321, rir_reg%
               fd_curve25519_scalar_muladd.hty 322 := t322, rir_reg%
               fd_curve25519_scalar_muladd.hty 323 := t323, rir_reg%
               fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
               fd_curve25519_scalar_muladd.hty 337 := t337, rir_reg%
               fd_curve25519_scalar_muladd.hty 338 := t338, rir_reg%
               fd_curve25519_scalar_muladd.hty 339 := t339, rir_reg%
               fd_curve25519_scalar_muladd.hty 340 := t340, rir_reg%
               fd_curve25519_scalar_muladd.hty 341 := t341, rir_reg%
               fd_curve25519_scalar_muladd.hty 342 := t342, rir_reg%
               fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
               fd_curve25519_scalar_muladd.hty 352 := t352, rir_reg%
               fd_curve25519_scalar_muladd.hty 353 := t353, rir_reg%
               fd_curve25519_scalar_muladd.hty 354 := t354, rir_reg%
               fd_curve25519_scalar_muladd.hty 355 := t355, rir_reg%
               fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
               fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
               fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
               fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 389 := s5_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 391 := s4_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 402 := s7_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
               fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 418 := s8_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 419 := t419, rir_reg%
               fd_curve25519_scalar_muladd.hty 420 := carry10, rir_reg%
     fd_curve25519_scalar_muladd.hty 427 := t427])
    (hbc11 : Bnd c11 0 33554431)
    (hbt257 : Bnd t257 0 4398042316801)
    (hbt258 : Bnd t258 0 4398042316801)
    (hbt265 : Bnd t265 0 4398042316801)
    (hbt266 : Bnd t266 0 4398042316801)
    (hbs12 : Bnd s12 0 180319797903371)
    (hbt289 : Bnd t289 0 70368708526081)
    (hbt290 : Bnd t290 0 4398042316801)
    (hbt291 : Bnd t291 0 4398042316801)
    (hbt292 : Bnd t292 0 4398042316801)
    (hbt293 : Bnd t293 0 4398042316801)
    (hbt294 : Bnd t294 0 4398042316801)
    (hbt295 : Bnd t295 0 4398042316801)
    (hbt296 : Bnd t296 0 4398042316801)
    (hbt297 : Bnd t297 0 4398042316801)
    (hbt298 : Bnd t298 0 70368708526081)
    (hbs14 : Bnd s14 0 171523713269769)
    (hbt316 : Bnd t316 0 70368708526081)
    (hbt317 : Bnd t317 0 4398042316801)
    (hbt318 : Bnd t318 0 4398042316801)
    (hbt319 : Bnd t319 0 4398042316801)
    (hbt320 : Bnd t320 0 4398042316801)
    (hbt321 : Bnd t321 0 4398042316801)
    (hbt322 : Bnd t322 0 4398042316801)
    (hbt323 : Bnd t323 0 70368708526081)
    (hbs16 : Bnd s16 0 162727628636167)
    (hbt337 : Bnd t337 0 70368708526081)
    (hbt338 : Bnd t338 0 4398042316801)
    (hbt339 : Bnd t339 0 4398042316801)
    (hbt340 : Bnd t340 0 4398042316801)
    (hbt341 : Bnd t341 0 4398042316801)
    (hbt342 : Bnd t342 0 70368708526081)
    (hbs18 : Bnd s18 0 153931544002565)
    (hbt352 : Bnd t352 0 70368708526081)
    (hbt353 : Bnd t353 0 4398042316801)
    (hbt354 : Bnd t354 0 4398042316801)
    (hbt355 : Bnd t355 0 70368708526081)
    (ht419 : t419 = s10 + 1048576#64)
    (hbcarry10 : Bnd carry10 0 23068651)
    (hbt427 : Bnd t427 0 167125670952968)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t428 t429 t430 t431 s11 s11_1 t434 t435 carry12 t437 t438 t439 t440 t441 t442 t443 t444
         s13 s13_1 t447 t448 carry14 t450 t451 t452 t453 t454 t455 s15 s15_1 t458 t459 carry16
        t461 t462 t463 t464 s17 s17_1 t467 t468 carry18 t470 t471 s19 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
                      fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
                      fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
                      fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
                      fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
                      fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 389 := s5_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 391 := s4_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 402 := s7_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
                      fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 418 := s8_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
                      fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
                      fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 458 := t458, rir_reg%
                      fd_curve25519_scalar_muladd.hty 466 := s17_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 467 := t467, rir_reg%
                      fd_curve25519_scalar_muladd.hty 468 := t468, rir_reg%
                      fd_curve25519_scalar_muladd.hty 469 := carry18, rir_reg%
           fd_curve25519_scalar_muladd.hty 472 := s19]) →
          (ht428 : t428 = t427 + c11) →
          (ht429 : t429 = t428 + t265) →
          (ht430 : t430 = t429 + t266) →
          (ht431 : t431 = t430 + t257) →
          (hs11 : s11 = t431 + t258) →
          (hs11_1 : s11_1 = s11 + carry10) →
          (ht434 : t434 = (BitVec.sshiftRight (s10 + 1048576#64) 21) <<< 21) →
          (ht435 : t435 = s12 + 1048576#64) →
          (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21) →
          (ht437 : t437 = t292 + t295) →
          (ht438 : t438 = t437 + t293) →
          (ht439 : t439 = t438 + t294) →
          (ht440 : t440 = t439 + t298) →
          (ht441 : t441 = t440 + t289) →
          (ht442 : t442 = t441 + t296) →
          (ht443 : t443 = t442 + t297) →
          (ht444 : t444 = t443 + t290) →
          (hs13 : s13 = t444 + t291) →
          (hs13_1 : s13_1 = s13 + carry12) →
          (ht447 : t447 = (BitVec.sshiftRight (s12 + 1048576#64) 21) <<< 21) →
          (ht448 : t448 = s14 + 1048576#64) →
          (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21) →
          (ht450 : t450 = t320 + t319) →
          (ht451 : t451 = t450 + t323) →
          (ht452 : t452 = t451 + t316) →
          (ht453 : t453 = t452 + t321) →
          (ht454 : t454 = t453 + t322) →
          (ht455 : t455 = t454 + t317) →
          (hs15 : s15 = t455 + t318) →
          (hs15_1 : s15_1 = s15 + carry14) →
          (ht458 : t458 = (BitVec.sshiftRight (s14 + 1048576#64) 21) <<< 21) →
          (ht459 : t459 = s16 + 1048576#64) →
          (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21) →
          (ht461 : t461 = t337 + t342) →
          (ht462 : t462 = t461 + t340) →
          (ht463 : t463 = t462 + t341) →
          (ht464 : t464 = t463 + t338) →
          (hs17 : s17 = t464 + t339) →
          (hs17_1 : s17_1 = s17 + carry16) →
          (ht467 : t467 = (BitVec.sshiftRight (s16 + 1048576#64) 21) <<< 21) →
          (ht468 : t468 = s18 + 1048576#64) →
          (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21) →
          (ht470 : t470 = t352 + t355) →
          (ht471 : t471 = t470 + t353) →
          (hs19 : s19 = t471 + t354) →
          (hbs11_1 : Bnd s11_1 0 184717896843254) →
          (hbs13_1 : Bnd s13_1 0 175921841569750) →
          (hbs15_1 : Bnd s15_1 0 167125752741848) →
          (hbs17_1 : Bnd s17_1 0 158329663913946) →
          (hbcarry18 : Bnd carry18 0 73400280) →
          (hbs19 : Bnd s19 0 149533501685764) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 473 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 428 S >>= g) = K := by
  fold_eqs
  step_pure [nswAdd, nuwAdd] with t428
  sbnd t428
  step_pure [nswAdd, nuwAdd] with t429
  sbnd t429
  step_pure [nswAdd, nuwAdd] with t430
  sbnd t430
  step_pure [nswAdd, nuwAdd] with t431
  sbnd t431
  step_pure [nswAdd, nuwAdd] with s11
  sbnd s11
  step_pure [nswAdd, nuwAdd] with s11_1
  sbnd s11_1
  step_pure [ht419, Bnd.and_neg_shift] with t434
  step_pure [nswAdd, nuwAdd] with t435
  step_pure [ht435, lshrNonneg] with carry12
  sbnd carry12
  step_pure [nswAdd, nuwAdd] with t437
  sbnd t437
  step_pure [nswAdd, nuwAdd] with t438
  sbnd t438
  step_pure [nswAdd, nuwAdd] with t439
  sbnd t439
  step_pure [nswAdd, nuwAdd] with t440
  sbnd t440
  step_pure [nswAdd, nuwAdd] with t441
  sbnd t441
  step_pure [nswAdd, nuwAdd] with t442
  sbnd t442
  step_pure [nswAdd, nuwAdd] with t443
  sbnd t443
  step_pure [nswAdd, nuwAdd] with t444
  sbnd t444
  step_pure [nswAdd, nuwAdd] with s13
  sbnd s13
  step_pure [nswAdd, nuwAdd] with s13_1
  sbnd s13_1
  step_pure [ht435, Bnd.and_neg_shift] with t447
  step_pure [nswAdd, nuwAdd] with t448
  step_pure [ht448, lshrNonneg] with carry14
  sbnd carry14
  step_pure [nswAdd, nuwAdd] with t450
  sbnd t450
  step_pure [nswAdd, nuwAdd] with t451
  sbnd t451
  step_pure [nswAdd, nuwAdd] with t452
  sbnd t452
  step_pure [nswAdd, nuwAdd] with t453
  sbnd t453
  step_pure [nswAdd, nuwAdd] with t454
  sbnd t454
  step_pure [nswAdd, nuwAdd] with t455
  sbnd t455
  step_pure [nswAdd, nuwAdd] with s15
  sbnd s15
  step_pure [nswAdd, nuwAdd] with s15_1
  sbnd s15_1
  step_pure [ht448, Bnd.and_neg_shift] with t458
  step_pure [nswAdd, nuwAdd] with t459
  step_pure [ht459, lshrNonneg] with carry16
  sbnd carry16
  step_pure [nswAdd, nuwAdd] with t461
  sbnd t461
  step_pure [nswAdd, nuwAdd] with t462
  sbnd t462
  step_pure [nswAdd, nuwAdd] with t463
  sbnd t463
  step_pure [nswAdd, nuwAdd] with t464
  sbnd t464
  step_pure [nswAdd, nuwAdd] with s17
  sbnd s17
  step_pure [nswAdd, nuwAdd] with s17_1
  sbnd s17_1
  step_pure [ht459, Bnd.and_neg_shift] with t467
  step_pure [nswAdd, nuwAdd] with t468
  step_pure [ht468, lshrNonneg] with carry18
  sbnd carry18
  step_pure [nswAdd, nuwAdd] with t470
  sbnd t470
  step_pure [nswAdd, nuwAdd] with t471
  sbnd t471
  step_pure [nswAdd, nuwAdd] with s19
  sbnd s19
  exact
    hK _ t428 t429 t430 t431 s11 s11_1 t434 t435 carry12 t437 t438 t439 t440 t441 t442 t443 t444 s13
      s13_1 t447 t448 carry14 t450 t451 t452 t453 t454 t455 s15 s15_1 t458 t459 carry16 t461 t462
      t463 t464 s17 s17_1 t467 t468 carry18 t470 t471 s19 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht428 ht429 ht430
      ht431 hs11 hs11_1 ht434 ht435 hcarry12 ht437 ht438 ht439 ht440 ht441 ht442 ht443 ht444 hs13
      hs13_1 ht447 ht448 hcarry14 ht450 ht451 ht452 ht453 ht454 ht455 hs15 hs15_1 ht458 ht459
      hcarry16 ht461 ht462 ht463 ht464 hs17 hs17_1 ht467 ht468 hcarry18 ht470 ht471 hs19 hbs11_1
      hbs13_1 hbs15_1 hbs17_1 hbcarry18 hbs19

/-- From `%473`: the carries `carry20` … `carry17`. -/
theorem fd_curve25519_scalar_muladd.run473 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s14 s16 s18 s20 s21 s22 s1_1 s0_1 s3_1 s2_1 s5_1 s4_1 s7_1 t403 s9_1 s8_1 s11_1
     t434 s13_1 t447 s15_1 t458 s17_1 t467 t468 carry18 s19 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
               fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
               fd_curve25519_scalar_muladd.hty 351 := s18, rir_reg%
               fd_curve25519_scalar_muladd.hty 360 := s20, rir_reg%
               fd_curve25519_scalar_muladd.hty 363 := s21, rir_reg%
               fd_curve25519_scalar_muladd.hty 364 := s22, rir_reg%
               fd_curve25519_scalar_muladd.hty 369 := s1_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 378 := s3_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 380 := s2_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 389 := s5_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 391 := s4_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 402 := s7_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
               fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 418 := s8_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
               fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
               fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 458 := t458, rir_reg%
               fd_curve25519_scalar_muladd.hty 466 := s17_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 467 := t467, rir_reg%
               fd_curve25519_scalar_muladd.hty 468 := t468, rir_reg%
               fd_curve25519_scalar_muladd.hty 469 := carry18, rir_reg%
     fd_curve25519_scalar_muladd.hty 472 := s19])
    (hbs18 : Bnd s18 0 153931544002565)
    (hbs20 : Bnd s20 0 145135459368963)
    (hbs21 : Bnd s21 0 140737417052162)
    (hbs22 : Bnd s22 0 1125899839733761)
    (hbs1_1 : Bnd s1_1 0 8796088827904)
    (hbs3_1 : Bnd s3_1 0 17592177655806)
    (hbs2_1 : Bnd s2_1 (-1048576) 1048575)
    (hbs5_1 : Bnd s5_1 0 26388266483708)
    (hbs4_1 : Bnd s4_1 (-1048576) 1048575)
    (hbs7_1 : Bnd s7_1 0 35184355311610)
    (hbs9_1 : Bnd s9_1 0 43980444139512)
    (hbs8_1 : Bnd s8_1 (-1048576) 1048575)
    (hbs11_1 : Bnd s11_1 0 184717896843254)
    (hbs13_1 : Bnd s13_1 0 175921841569750)
    (hbs15_1 : Bnd s15_1 0 167125752741848)
    (hbs17_1 : Bnd s17_1 0 158329663913946)
    (ht468 : t468 = s18 + 1048576#64)
    (hbcarry18 : Bnd carry18 0 73400280)
    (hbs19 : Bnd s19 0 149533501685764)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry1 s2_2 s1_2 carry3 s4_2 s3_2 carry5
         s5_2 carry7 s8_2 s7_2 carry9 t506 carry11 t509 carry13 t512 carry15 t515 carry17 s18_2
        s17_2 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
                      fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
                      fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
                      fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
                      fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 458 := t458, rir_reg%
                      fd_curve25519_scalar_muladd.hty 467 := t467, rir_reg%
                      fd_curve25519_scalar_muladd.hty 473 := s19_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 478 := s21_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 480 := s20_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 482 := carry22, rir_reg%
                      fd_curve25519_scalar_muladd.hty 484 := s22_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 496 := carry5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 501 := s8_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 503 := s7_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 505 := carry9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 506 := t506, rir_reg%
                      fd_curve25519_scalar_muladd.hty 508 := carry11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
                      fd_curve25519_scalar_muladd.hty 511 := carry13, rir_reg%
                      fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
                      fd_curve25519_scalar_muladd.hty 514 := carry15, rir_reg%
                      fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
                      fd_curve25519_scalar_muladd.hty 518 := s18_2, rir_reg%
           fd_curve25519_scalar_muladd.hty 520 := s17_2]) →
          (hs19_1 : s19_1 = s19 + carry18) →
          (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21)) →
          (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21) →
          (hs21_1 : s21_1 = s21 + carry20) →
          (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21)) →
          (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21) →
          (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21)) →
          (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21) →
          (hs2_2 : s2_2 = s2_1 + carry1) →
          (hs1_2 : s1_2 = s1_1 - ((BitVec.sshiftRight (s1_1 + 1048576#64) 21) <<< 21)) →
          (hcarry3 : carry3 = BitVec.sshiftRight (s3_1 + 1048576#64) 21) →
          (hs4_2 : s4_2 = s4_1 + carry3) →
          (hs3_2 : s3_2 = s3_1 - ((BitVec.sshiftRight (s3_1 + 1048576#64) 21) <<< 21)) →
          (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21) →
          (hs5_2 : s5_2 = s5_1 - ((BitVec.sshiftRight (s5_1 + 1048576#64) 21) <<< 21)) →
          (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21) →
          (hs8_2 : s8_2 = s8_1 + carry7) →
          (hs7_2 : s7_2 = s7_1 - ((BitVec.sshiftRight (s7_1 + 1048576#64) 21) <<< 21)) →
          (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21) →
          (ht506 : t506 = (BitVec.sshiftRight (s9_1 + 1048576#64) 21) <<< 21) →
          (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21) →
          (ht509 : t509 = (BitVec.sshiftRight (s11_1 + 1048576#64) 21) <<< 21) →
          (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21) →
          (ht512 : t512 = (BitVec.sshiftRight (s13_1 + 1048576#64) 21) <<< 21) →
          (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21) →
          (ht515 : t515 = (BitVec.sshiftRight (s15_1 + 1048576#64) 21) <<< 21) →
          (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21) →
          (hs18_2 : s18_2 = carry17 + s18_1) →
          (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21)) →
          (hbs19_1 : Bnd s19_1 0 149533575086044) →
          (hbs21_1 : Bnd s21_1 0 140737486258142) →
          (hbs20_1 : Bnd s20_1 (-1048576) 1048575) →
          (hbcarry22 : Bnd carry22 0 536870880) →
          (hbs22_1 : Bnd s22_1 (-1048576) 1048575) →
          (hbs2_2 : Bnd s2_2 (-1048576) 5242877) →
          (hbs1_2 : Bnd s1_2 (-1048576) 1048575) →
          (hbs4_2 : Bnd s4_2 (-1048576) 9437179) →
          (hbs3_2 : Bnd s3_2 (-1048576) 1048575) →
          (hbcarry5 : Bnd carry5 0 12582906) →
          (hbs5_2 : Bnd s5_2 (-1048576) 1048575) →
          (hbs8_2 : Bnd s8_2 (-1048576) 17825783) →
          (hbs7_2 : Bnd s7_2 (-1048576) 1048575) →
          (hbcarry9 : Bnd carry9 0 20971510) →
          (hbcarry11 : Bnd carry11 0 88080357) →
          (hbcarry13 : Bnd carry13 0 83886071) →
          (hbcarry15 : Bnd carry15 0 79691769) →
          (hbs18_2 : Bnd s18_2 (-1048576) 76546042) →
          (hbs17_2 : Bnd s17_2 (-1048576) 1048575) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 521 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 473 S >>= g) = K := by
  fold_eqs
  step_pure [nswAdd, nuwAdd] with s19_1
  sbnd s19_1
  step_pure [ht468, Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s18_1
  sbnd s18_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry20
  sbnd carry20
  step_pure [nswAdd, nuwAdd] with s21_1
  sbnd s21_1
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s20_1
  sbnd s20_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry22
  sbnd carry22
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s22_1
  sbnd s22_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry1
  sbnd carry1
  step_pure [nswAdd] with s2_2
  sbnd s2_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s1_2
  sbnd s1_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry3
  sbnd carry3
  step_pure [nswAdd] with s4_2
  sbnd s4_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s3_2
  sbnd s3_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry5
  sbnd carry5
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s5_2
  sbnd s5_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry7
  sbnd carry7
  step_pure [nswAdd] with s8_2
  sbnd s8_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s7_2
  sbnd s7_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry9
  sbnd carry9
  step_pure [Bnd.and_neg_shift] with t506
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry11
  sbnd carry11
  step_pure [Bnd.and_neg_shift] with t509
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry13
  sbnd carry13
  step_pure [Bnd.and_neg_shift] with t512
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry15
  sbnd carry15
  step_pure [Bnd.and_neg_shift] with t515
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry17
  sbnd carry17
  step_pure [nswAdd] with s18_2
  sbnd s18_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s17_2
  sbnd s17_2
  exact
    hK _ s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry1 s2_2 s1_2 carry3 s4_2 s3_2 carry5 s5_2
      carry7 s8_2 s7_2 carry9 t506 carry11 t509 carry13 t512 carry15 t515 carry17 s18_2 s17_2 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) hs19_1 hs18_1
      hcarry20 hs21_1 hs20_1 hcarry22 hs22_1 hcarry1 hs2_2 hs1_2 hcarry3 hs4_2 hs3_2 hcarry5 hs5_2
      hcarry7 hs8_2 hs7_2 hcarry9 ht506 hcarry11 ht509 hcarry13 ht512 hcarry15 ht515 hcarry17 hs18_2
      hs17_2 hbs19_1 hbs21_1 hbs20_1 hbcarry22 hbs22_1 hbs2_2 hbs1_2 hbs4_2 hbs3_2 hbcarry5 hbs5_2
      hbs8_2 hbs7_2 hbcarry9 hbcarry11 hbcarry13 hbcarry15 hbs18_2 hbs17_2

/-- From `%521`: the carries `carry19`, `carry21`. -/
theorem fd_curve25519_scalar_muladd.run521 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s14 s16 s0_1 t403 s9_1 s11_1 t434 s13_1 t447 s15_1 t458 t467 s19_1 s21_1 s20_1
     carry22 s22_1 s2_2 s1_2 s4_2 s3_2 carry5 s5_2 s8_2 s7_2 carry9 t506 carry11 t509 carry13 t512
     carry15 t515 s18_2 s17_2 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 315 := s14, rir_reg%
               fd_curve25519_scalar_muladd.hty 336 := s16, rir_reg%
               fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
               fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
               fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
               fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 458 := t458, rir_reg%
               fd_curve25519_scalar_muladd.hty 467 := t467, rir_reg%
               fd_curve25519_scalar_muladd.hty 473 := s19_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 478 := s21_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 480 := s20_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 482 := carry22, rir_reg%
               fd_curve25519_scalar_muladd.hty 484 := s22_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 496 := carry5, rir_reg%
               fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 501 := s8_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 503 := s7_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 505 := carry9, rir_reg%
               fd_curve25519_scalar_muladd.hty 506 := t506, rir_reg%
               fd_curve25519_scalar_muladd.hty 508 := carry11, rir_reg%
               fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
               fd_curve25519_scalar_muladd.hty 511 := carry13, rir_reg%
               fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
               fd_curve25519_scalar_muladd.hty 514 := carry15, rir_reg%
               fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
               fd_curve25519_scalar_muladd.hty 518 := s18_2, rir_reg%
     fd_curve25519_scalar_muladd.hty 520 := s17_2])
    (hbs14 : Bnd s14 0 171523713269769)
    (hbs16 : Bnd s16 0 162727628636167)
    (ht458 : t458 = (BitVec.sshiftRight (s14 + 1048576#64) 21) <<< 21)
    (ht467 : t467 = (BitVec.sshiftRight (s16 + 1048576#64) 21) <<< 21)
    (hbs19_1 : Bnd s19_1 0 149533575086044)
    (hbs21_1 : Bnd s21_1 0 140737486258142)
    (hbs20_1 : Bnd s20_1 (-1048576) 1048575)
    (hbcarry22 : Bnd carry22 0 536870880)
    (hbs22_1 : Bnd s22_1 (-1048576) 1048575)
    (hbs8_2 : Bnd s8_2 (-1048576) 17825783)
    (hbs7_2 : Bnd s7_2 (-1048576) 1048575)
    (hbcarry13 : Bnd carry13 0 83886071)
    (hbcarry15 : Bnd carry15 0 79691769)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (carry19 s20_2 s19_2 carry21 s22_2 s21_2 t531 t532 t533 t534 t535 t536 t537 t538 s16_3
         t540 t541 t542 t543 t544 t545 t546 t547 t548 t549 t550 t551 t552 t553 t554 t555 s14_5
        t557 s8_3 t559 t560 t561 t562 t563 t564 s7_3 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
                      fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
                      fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
                      fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 496 := carry5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 505 := carry9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 506 := t506, rir_reg%
                      fd_curve25519_scalar_muladd.hty 508 := carry11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
                      fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
                      fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
                      fd_curve25519_scalar_muladd.hty 518 := s18_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 520 := s17_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 525 := s19_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 531 := t531, rir_reg%
                      fd_curve25519_scalar_muladd.hty 532 := t532, rir_reg%
                      fd_curve25519_scalar_muladd.hty 533 := t533, rir_reg%
                      fd_curve25519_scalar_muladd.hty 535 := t535, rir_reg%
                      fd_curve25519_scalar_muladd.hty 539 := s16_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 540 := t540, rir_reg%
                      fd_curve25519_scalar_muladd.hty 541 := t541, rir_reg%
                      fd_curve25519_scalar_muladd.hty 542 := t542, rir_reg%
                      fd_curve25519_scalar_muladd.hty 543 := t543, rir_reg%
                      fd_curve25519_scalar_muladd.hty 545 := t545, rir_reg%
                      fd_curve25519_scalar_muladd.hty 546 := t546, rir_reg%
                      fd_curve25519_scalar_muladd.hty 547 := t547, rir_reg%
                      fd_curve25519_scalar_muladd.hty 548 := t548, rir_reg%
                      fd_curve25519_scalar_muladd.hty 549 := t549, rir_reg%
                      fd_curve25519_scalar_muladd.hty 550 := t550, rir_reg%
                      fd_curve25519_scalar_muladd.hty 556 := s14_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 558 := s8_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 559 := t559, rir_reg%
                      fd_curve25519_scalar_muladd.hty 560 := t560, rir_reg%
                      fd_curve25519_scalar_muladd.hty 561 := t561, rir_reg%
                      fd_curve25519_scalar_muladd.hty 562 := t562, rir_reg%
                      fd_curve25519_scalar_muladd.hty 563 := t563, rir_reg%
           fd_curve25519_scalar_muladd.hty 565 := s7_3]) →
          (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21) →
          (hs20_2 : s20_2 = carry19 + s20_1) →
          (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21)) →
          (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21) →
          (hs22_2 : s22_2 = carry21 + s22_1) →
          (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21)) →
          (ht531 : t531 = carry22 * 666643#64) →
          (ht532 : t532 = carry22 * 470296#64) →
          (ht533 : t533 = carry22 * 654183#64) →
          (ht534 : t534 = carry22 * 18446744073708553811#64) →
          (ht535 : t535 = carry22 * 136657#64) →
          (ht536 : t536 = carry22 * 18446744073708867715#64) →
          (ht537 : t537 = s16 + t536) →
          (ht538 : t538 = t537 - ((BitVec.sshiftRight (s16 + 1048576#64) 21) <<< 21)) →
          (hs16_3 : s16_3 = t538 + carry15) →
          (ht540 : t540 = s22_2 * 666643#64) →
          (ht541 : t541 = s22_2 * 470296#64) →
          (ht542 : t542 = s22_2 * 654183#64) →
          (ht543 : t543 = s22_2 * 18446744073708553811#64) →
          (ht544 : t544 = s22_2 * 136657#64) →
          (ht545 : t545 = s22_2 * 18446744073708867715#64) →
          (ht546 : t546 = s21_2 * 666643#64) →
          (ht547 : t547 = s21_2 * 470296#64) →
          (ht548 : t548 = s21_2 * 654183#64) →
          (ht549 : t549 = s21_2 * 18446744073708553811#64) →
          (ht550 : t550 = s21_2 * 136657#64) →
          (ht551 : t551 = s21_2 * 18446744073708867715#64) →
          (ht552 : t552 = s14 + t534) →
          (ht553 : t553 = t552 + t544) →
          (ht554 : t554 = t553 + t551) →
          (ht555 : t555 = t554 - ((BitVec.sshiftRight (s14 + 1048576#64) 21) <<< 21)) →
          (hs14_5 : s14_5 = t555 + carry13) →
          (ht557 : t557 = s20_2 * 666643#64) →
          (hs8_3 : s8_3 = s8_2 + t557) →
          (ht559 : t559 = s20_2 * 470296#64) →
          (ht560 : t560 = s20_2 * 654183#64) →
          (ht561 : t561 = s20_2 * 18446744073708553811#64) →
          (ht562 : t562 = s20_2 * 136657#64) →
          (ht563 : t563 = s20_2 * 18446744073708867715#64) →
          (ht564 : t564 = s19_2 * 666643#64) →
          (hs7_3 : s7_3 = s7_2 + t564) →
          (hbs19_2 : Bnd s19_2 (-1048576) 1048575) →
          (hbt531 : Bnd t531 0 357901214055840) →
          (hbt532 : Bnd t532 0 252488227380480) →
          (hbt533 : Bnd t533 0 351211802891040) →
          (hbt535 : Bnd t535 0 73367163848160) →
          (hbs16_3 : Bnd s16_3 (-367166532751456) 80740344) →
          (hbt540 : Bnd t540 (-699025850368) 45436678940634) →
          (hbt541 : Bnd t541 (-493141098496) 32054170461648) →
          (hbt542 : Bnd t542 (-685960593408) 44587437263154) →
          (hbt543 : Bnd t543 (-68007832423590) 1046274375680) →
          (hbt545 : Bnd t545 (-46612940005638) 717122174976) →
          (hbt546 : Bnd t546 (-699025850368) 699025183725) →
          (hbt547 : Bnd t547 (-493141098496) 493140628200) →
          (hbt548 : Bnd t548 (-685960593408) 685959939225) →
          (hbt549 : Bnd t549 (-1046273377875) 1046274375680) →
          (hbt550 : Bnd t550 (-143295250432) 143295113775) →
          (hbs14_5 : Bnd s14_5 (-536552866208483) 10031398114388) →
          (hbs8_3 : Bnd s8_3 (-699026898944) 48232798834603) →
          (hbt559 : Bnd t559 (-493141098496) 34026733915040) →
          (hbt560 : Bnd t560 (-685960593408) 47331278328420) →
          (hbt561 : Bnd t561 (-72192927930700) 1046274375680) →
          (hbt562 : Bnd t562 (-143295250432) 9887371733180) →
          (hbt563 : Bnd t563 (-49481427337740) 717122174976) →
          (hbs7_3 : Bnd s7_3 (-699026898944) 699026232300) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 566 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 521 S >>= g) = K := by
  fold_eqs
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry19
  sbnd carry19
  step_pure [nswAdd] with s20_2
  sbnd s20_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s19_2
  sbnd s19_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry21
  sbnd carry21
  step_pure [nswAdd] with s22_2
  sbnd s22_2
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s21_2
  sbnd s21_2
  step_pure [nswMul, nuwMul] with t531
  sbnd t531
  step_pure [nswMul, nuwMul] with t532
  sbnd t532
  step_pure [nswMul, nuwMul] with t533
  sbnd t533
  step_pure [nswMul] with t534
  sbnd t534
  step_pure [nswMul, nuwMul] with t535
  sbnd t535
  step_pure [nswMul] with t536
  sbnd t536
  step_pure [nswAdd] with t537
  sbnd t537
  step_pure [Sc.nswSubS, ht467] with t538
  sbnd t538
  step_pure [nswAdd] with s16_3
  sbnd s16_3
  step_pure with t540
  sbnd t540
  step_pure with t541
  sbnd t541
  step_pure with t542
  sbnd t542
  step_pure with t543
  sbnd t543
  step_pure with t544
  sbnd t544
  step_pure with t545
  sbnd t545
  step_pure with t546
  sbnd t546
  step_pure with t547
  sbnd t547
  step_pure with t548
  sbnd t548
  step_pure with t549
  sbnd t549
  step_pure with t550
  sbnd t550
  step_pure with t551
  sbnd t551
  step_pure [nswAdd] with t552
  step_pure with t553
  step_pure with t554
  step_pure [ht458] with t555
  sbnd t555
  step_pure with s14_5
  sbnd s14_5
  step_pure with t557
  sbnd t557
  step_pure with s8_3
  sbnd s8_3
  step_pure with t559
  sbnd t559
  step_pure with t560
  sbnd t560
  step_pure with t561
  sbnd t561
  step_pure with t562
  sbnd t562
  step_pure with t563
  sbnd t563
  step_pure with t564
  sbnd t564
  step_pure with s7_3
  sbnd s7_3
  exact
    hK _ carry19 s20_2 s19_2 carry21 s22_2 s21_2 t531 t532 t533 t534 t535 t536 t537 t538 s16_3 t540
      t541 t542 t543 t544 t545 t546 t547 t548 t549 t550 t551 t552 t553 t554 t555 s14_5 t557 s8_3
      t559 t560 t561 t562 t563 t564 s7_3 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) hcarry19 hs20_2
      hs19_2 hcarry21 hs22_2 hs21_2 ht531 ht532 ht533 ht534 ht535 ht536 ht537 ht538 hs16_3 ht540
      ht541 ht542 ht543 ht544 ht545 ht546 ht547 ht548 ht549 ht550 ht551 ht552 ht553 ht554 ht555
      hs14_5 ht557 hs8_3 ht559 ht560 ht561 ht562 ht563 ht564 hs7_3 hbs19_2 hbt531 hbt532 hbt533
      hbt535 hbs16_3 hbt540 hbt541 hbt542 hbt543 hbt545 hbt546 hbt547 hbt548 hbt549 hbt550 hbs14_5
      hbs8_3 hbt559 hbt560 hbt561 hbt562 hbt563 hbs7_3

/-- From `%566`: the carries `carry6_1`, `carry8_1`. -/
theorem fd_curve25519_scalar_muladd.run566 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s0_1 t403 s9_1 s11_1 t434 s13_1 t447 s15_1 s2_2 s1_2 s4_2 s3_2 carry5 s5_2 carry9
     t506 carry11 t509 t512 t515 s18_2 s17_2 s19_2 t531 t532 t533 t535 s16_3 t540 t541 t542 t543
     t545 t546 t547 t548 t549 t550 s14_5 s8_3 t559 t560 t561 t562 t563 s7_3 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 197 := s6, rir_reg%
               fd_curve25519_scalar_muladd.hty 255 := s10, rir_reg%
               fd_curve25519_scalar_muladd.hty 288 := s12, rir_reg%
               fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 403 := t403, rir_reg%
               fd_curve25519_scalar_muladd.hty 416 := s9_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 434 := t434, rir_reg%
               fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 447 := t447, rir_reg%
               fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 496 := carry5, rir_reg%
               fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 505 := carry9, rir_reg%
               fd_curve25519_scalar_muladd.hty 506 := t506, rir_reg%
               fd_curve25519_scalar_muladd.hty 508 := carry11, rir_reg%
               fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
               fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
               fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
               fd_curve25519_scalar_muladd.hty 518 := s18_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 520 := s17_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 525 := s19_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 531 := t531, rir_reg%
               fd_curve25519_scalar_muladd.hty 532 := t532, rir_reg%
               fd_curve25519_scalar_muladd.hty 533 := t533, rir_reg%
               fd_curve25519_scalar_muladd.hty 535 := t535, rir_reg%
               fd_curve25519_scalar_muladd.hty 539 := s16_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 540 := t540, rir_reg%
               fd_curve25519_scalar_muladd.hty 541 := t541, rir_reg%
               fd_curve25519_scalar_muladd.hty 542 := t542, rir_reg%
               fd_curve25519_scalar_muladd.hty 543 := t543, rir_reg%
               fd_curve25519_scalar_muladd.hty 545 := t545, rir_reg%
               fd_curve25519_scalar_muladd.hty 546 := t546, rir_reg%
               fd_curve25519_scalar_muladd.hty 547 := t547, rir_reg%
               fd_curve25519_scalar_muladd.hty 548 := t548, rir_reg%
               fd_curve25519_scalar_muladd.hty 549 := t549, rir_reg%
               fd_curve25519_scalar_muladd.hty 550 := t550, rir_reg%
               fd_curve25519_scalar_muladd.hty 556 := s14_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 558 := s8_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 559 := t559, rir_reg%
               fd_curve25519_scalar_muladd.hty 560 := t560, rir_reg%
               fd_curve25519_scalar_muladd.hty 561 := t561, rir_reg%
               fd_curve25519_scalar_muladd.hty 562 := t562, rir_reg%
               fd_curve25519_scalar_muladd.hty 563 := t563, rir_reg%
     fd_curve25519_scalar_muladd.hty 565 := s7_3])
    (hbs6 : Bnd s6 0 30786298314758)
    (ht403 : t403 = (BitVec.sshiftRight (s6 + 1048576#64) 21) <<< 21)
    (ht434 : t434 = (BitVec.sshiftRight (s10 + 1048576#64) 21) <<< 21)
    (ht447 : t447 = (BitVec.sshiftRight (s12 + 1048576#64) 21) <<< 21)
    (hbcarry5 : Bnd carry5 0 12582906)
    (hbcarry9 : Bnd carry9 0 20971510)
    (ht506 : t506 = (BitVec.sshiftRight (s9_1 + 1048576#64) 21) <<< 21)
    (hbcarry11 : Bnd carry11 0 88080357)
    (hbs18_2 : Bnd s18_2 (-1048576) 76546042)
    (hbs19_2 : Bnd s19_2 (-1048576) 1048575)
    (hbt532 : Bnd t532 0 252488227380480)
    (hbt540 : Bnd t540 (-699025850368) 45436678940634)
    (hbt542 : Bnd t542 (-685960593408) 44587437263154)
    (hbt546 : Bnd t546 (-699025850368) 699025183725)
    (hbt547 : Bnd t547 (-493141098496) 493140628200)
    (hbt549 : Bnd t549 (-1046273377875) 1046274375680)
    (hbs8_3 : Bnd s8_3 (-699026898944) 48232798834603)
    (hbt559 : Bnd t559 (-493141098496) 34026733915040)
    (hbt560 : Bnd t560 (-685960593408) 47331278328420)
    (hbt562 : Bnd t562 (-143295250432) 9887371733180)
    (hbs7_3 : Bnd s7_3 (-699026898944) 699026232300)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t566 s8_4 t568 t569 t570 t571 t572 t573 t574 t575 t576 t577 s12_7 t579 t580 s6_2 s6_3
         t583 s7_4 t585 s8_5 t587 t588 t589 t590 t591 t592 t593 s10_6 s10_7 t596 carry6_1 s7_5
        s6_4 t602 carry8_1 t604 t605 t606 s9_5 s9_6 s9_7 s8_6 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
                      fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
                      fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
                      fd_curve25519_scalar_muladd.hty 520 := s17_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 531 := t531, rir_reg%
                      fd_curve25519_scalar_muladd.hty 533 := t533, rir_reg%
                      fd_curve25519_scalar_muladd.hty 535 := t535, rir_reg%
                      fd_curve25519_scalar_muladd.hty 539 := s16_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 541 := t541, rir_reg%
                      fd_curve25519_scalar_muladd.hty 543 := t543, rir_reg%
                      fd_curve25519_scalar_muladd.hty 545 := t545, rir_reg%
                      fd_curve25519_scalar_muladd.hty 548 := t548, rir_reg%
                      fd_curve25519_scalar_muladd.hty 550 := t550, rir_reg%
                      fd_curve25519_scalar_muladd.hty 556 := s14_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 561 := t561, rir_reg%
                      fd_curve25519_scalar_muladd.hty 563 := t563, rir_reg%
                      fd_curve25519_scalar_muladd.hty 570 := t570, rir_reg%
                      fd_curve25519_scalar_muladd.hty 578 := s12_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 595 := s10_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 596 := t596, rir_reg%
                      fd_curve25519_scalar_muladd.hty 599 := s7_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 601 := s6_4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
           fd_curve25519_scalar_muladd.hty 611 := s8_6]) →
          (ht566 : t566 = s19_2 * 470296#64) →
          (hs8_4 : s8_4 = s8_3 + t566) →
          (ht568 : t568 = s19_2 * 654183#64) →
          (ht569 : t569 = s19_2 * 18446744073708553811#64) →
          (ht570 : t570 = s19_2 * 136657#64) →
          (ht571 : t571 = s19_2 * 18446744073708867715#64) →
          (ht572 : t572 = t542 + t532) →
          (ht573 : t573 = t572 + t549) →
          (ht574 : t574 = t573 + s12) →
          (ht575 : t575 = t574 + t562) →
          (ht576 : t576 = t575 + t571) →
          (ht577 : t577 = t576 - ((BitVec.sshiftRight (s12 + 1048576#64) 21) <<< 21)) →
          (hs12_7 : s12_7 = t577 + carry11) →
          (ht579 : t579 = s18_2 * 666643#64) →
          (ht580 : t580 = carry5 + s6) →
          (hs6_2 : s6_2 = t580 - ((BitVec.sshiftRight (s6 + 1048576#64) 21) <<< 21)) →
          (hs6_3 : s6_3 = s6_2 + t579) →
          (ht583 : t583 = s18_2 * 470296#64) →
          (hs7_4 : s7_4 = s7_3 + t583) →
          (ht585 : t585 = s18_2 * 654183#64) →
          (hs8_5 : s8_5 = s8_4 + t585) →
          (ht587 : t587 = s18_2 * 18446744073708553811#64) →
          (ht588 : t588 = s18_2 * 136657#64) →
          (ht589 : t589 = t547 + t540) →
          (ht590 : t590 = t589 + s10) →
          (ht591 : t591 = t590 + t560) →
          (ht592 : t592 = t591 + t569) →
          (ht593 : t593 = t592 - ((BitVec.sshiftRight (s10 + 1048576#64) 21) <<< 21)) →
          (hs10_6 : s10_6 = t593 + carry9) →
          (hs10_7 : s10_7 = s10_6 + t588) →
          (ht596 : t596 = s18_2 * 18446744073708867715#64) →
          (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21) →
          (hs7_5 : s7_5 = s7_4 + carry6_1) →
          (hs6_4 : s6_4 = s6_3 - ((BitVec.sshiftRight (s6_3 + 1048576#64) 21) <<< 21)) →
          (ht602 : t602 = s8_5 + 1048576#64) →
          (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21) →
          (ht604 : t604 = s9_1 + t546) →
          (ht605 : t605 = t604 + t559) →
          (ht606 : t606 = t605 + t568) →
          (hs9_5 : s9_5 = t606 - ((BitVec.sshiftRight (s9_1 + 1048576#64) 21) <<< 21)) →
          (hs9_6 : s9_6 = s9_5 + t587) →
          (hs9_7 : s9_7 = s9_6 + carry8_1) →
          (hs8_6 : s8_6 = s8_5 - ((BitVec.sshiftRight (s8_5 + 1048576#64) 21) <<< 21)) →
          (hbt570 : Bnd t570 (-143295250432) 143295113775) →
          (hbs12_7 : Bnd s12_7 (-2592651761366) 308726522056402) →
          (hbs10_7 : Bnd s10_7 (-3067697219155) 104767946754613) →
          (hbt596 : Bnd t596 (-52349914669842) 717122174976) →
          (hbs7_5 : Bnd s7_5 (-1192168330762) 36698347933206) →
          (hbs6_4 : Bnd s6_4 (-1048576) 1048575) →
          (hbs9_7 : Bnd s9_7 (-78256152924219) 36458041574261) →
          (hbs8_6 : Bnd s8_6 (-1048576) 1048575) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 612 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 566 S >>= g) = K := by
  fold_eqs
  step_pure with t566
  sbnd t566
  step_pure with s8_4
  sbnd s8_4
  step_pure with t568
  sbnd t568
  step_pure with t569
  sbnd t569
  step_pure with t570
  sbnd t570
  step_pure with t571
  sbnd t571
  step_pure with t572
  sbnd t572
  step_pure with t573
  sbnd t573
  step_pure with t574
  step_pure with t575
  step_pure with t576
  step_pure [ht447] with t577
  sbnd t577
  step_pure with s12_7
  sbnd s12_7
  step_pure with t579
  sbnd t579
  step_pure [nswAdd, nuwAdd] with t580
  sbnd t580
  step_pure [Sc.nswSubS, ht403] with s6_2
  sbnd s6_2
  step_pure with s6_3
  sbnd s6_3
  step_pure with t583
  sbnd t583
  step_pure with s7_4
  sbnd s7_4
  step_pure with t585
  sbnd t585
  step_pure with s8_5
  sbnd s8_5
  step_pure with t587
  sbnd t587
  step_pure with t588
  sbnd t588
  step_pure with t589
  sbnd t589
  step_pure with t590
  step_pure with t591
  step_pure with t592
  step_pure [ht434] with t593
  sbnd t593
  step_pure with s10_6
  sbnd s10_6
  step_pure with s10_7
  sbnd s10_7
  step_pure with t596
  sbnd t596
  step_pure
  step_pure with carry6_1
  sbnd carry6_1
  step_pure with s7_5
  sbnd s7_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s6_4
  sbnd s6_4
  step_pure with t602
  step_pure [ht602] with carry8_1
  sbnd carry8_1
  step_pure with t604
  step_pure with t605
  step_pure with t606
  step_pure [ht506] with s9_5
  sbnd s9_5
  step_pure with s9_6
  sbnd s9_6
  step_pure with s9_7
  sbnd s9_7
  step_pure [ht602, Bnd.and_neg_shift]
  step_pure with s8_6
  sbnd s8_6
  exact
    hK _ t566 s8_4 t568 t569 t570 t571 t572 t573 t574 t575 t576 t577 s12_7 t579 t580 s6_2 s6_3 t583
      s7_4 t585 s8_5 t587 t588 t589 t590 t591 t592 t593 s10_6 s10_7 t596 carry6_1 s7_5 s6_4 t602
      carry8_1 t604 t605 t606 s9_5 s9_6 s9_7 s8_6 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht566 hs8_4 ht568
      ht569 ht570 ht571 ht572 ht573 ht574 ht575 ht576 ht577 hs12_7 ht579 ht580 hs6_2 hs6_3 ht583
      hs7_4 ht585 hs8_5 ht587 ht588 ht589 ht590 ht591 ht592 ht593 hs10_6 hs10_7 ht596 hcarry6_1
      hs7_5 hs6_4 ht602 hcarry8_1 ht604 ht605 ht606 hs9_5 hs9_6 hs9_7 hs8_6 hbt570 hbs12_7 hbs10_7
      hbt596 hbs7_5 hbs6_4 hbs9_7 hbs8_6

/-- From `%612`: the carries `carry10_1` … `carry11_1`. -/
theorem fd_curve25519_scalar_muladd.run612 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s11_1 s13_1 s15_1 s2_2 s1_2 s4_2 s3_2 s5_2 t509 t512 t515 s17_2 t531 t533 t535 s16_3 t541
     t543 t545 t548 t550 s14_5 t561 t563 t570 s12_7 s10_7 t596 s7_5 s6_4 s9_7 s8_6 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 433 := s11_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 446 := s13_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 457 := s15_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 509 := t509, rir_reg%
               fd_curve25519_scalar_muladd.hty 512 := t512, rir_reg%
               fd_curve25519_scalar_muladd.hty 515 := t515, rir_reg%
               fd_curve25519_scalar_muladd.hty 520 := s17_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 531 := t531, rir_reg%
               fd_curve25519_scalar_muladd.hty 533 := t533, rir_reg%
               fd_curve25519_scalar_muladd.hty 535 := t535, rir_reg%
               fd_curve25519_scalar_muladd.hty 539 := s16_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 541 := t541, rir_reg%
               fd_curve25519_scalar_muladd.hty 543 := t543, rir_reg%
               fd_curve25519_scalar_muladd.hty 545 := t545, rir_reg%
               fd_curve25519_scalar_muladd.hty 548 := t548, rir_reg%
               fd_curve25519_scalar_muladd.hty 550 := t550, rir_reg%
               fd_curve25519_scalar_muladd.hty 556 := s14_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 561 := t561, rir_reg%
               fd_curve25519_scalar_muladd.hty 563 := t563, rir_reg%
               fd_curve25519_scalar_muladd.hty 570 := t570, rir_reg%
               fd_curve25519_scalar_muladd.hty 578 := s12_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 595 := s10_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 596 := t596, rir_reg%
               fd_curve25519_scalar_muladd.hty 599 := s7_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 601 := s6_4, rir_reg%
               fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
     fd_curve25519_scalar_muladd.hty 611 := s8_6])
    (ht509 : t509 = (BitVec.sshiftRight (s11_1 + 1048576#64) 21) <<< 21)
    (ht512 : t512 = (BitVec.sshiftRight (s13_1 + 1048576#64) 21) <<< 21)
    (ht515 : t515 = (BitVec.sshiftRight (s15_1 + 1048576#64) 21) <<< 21)
    (hbs17_2 : Bnd s17_2 (-1048576) 1048575)
    (hbt531 : Bnd t531 0 357901214055840)
    (hbt533 : Bnd t533 0 351211802891040)
    (hbt535 : Bnd t535 0 73367163848160)
    (hbs16_3 : Bnd s16_3 (-367166532751456) 80740344)
    (hbt541 : Bnd t541 (-493141098496) 32054170461648)
    (hbt543 : Bnd t543 (-68007832423590) 1046274375680)
    (hbt545 : Bnd t545 (-46612940005638) 717122174976)
    (hbt548 : Bnd t548 (-685960593408) 685959939225)
    (hbt550 : Bnd t550 (-143295250432) 143295113775)
    (hbs14_5 : Bnd s14_5 (-536552866208483) 10031398114388)
    (hbt561 : Bnd t561 (-72192927930700) 1046274375680)
    (hbt563 : Bnd t563 (-49481427337740) 717122174976)
    (hbt570 : Bnd t570 (-143295250432) 143295113775)
    (hbs12_7 : Bnd s12_7 (-2592651761366) 308726522056402)
    (hbs10_7 : Bnd s10_7 (-3067697219155) 104767946754613)
    (hbt596 : Bnd t596 (-52349914669842) 717122174976)
    (hbs7_5 : Bnd s7_5 (-1192168330762) 36698347933206)
    (hbs9_7 : Bnd s9_7 (-78256152924219) 36458041574261)
    (hbs8_6 : Bnd s8_6 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t612 carry10_1 t614 t615 t616 t617 t618 t619 s11_8 s11_9 t622 t623 carry12_1 t625 t626
         t627 t628 s13_6 s13_7 s12_8 t633 carry14_1 t635 t636 s15_4 s15_5 s14_6 carry16_1 s17_3
        s16_4 carry7_1 s8_7 s7_6 carry9_1 t653 carry11_1 s12_9 s11_10 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 595 := s10_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 601 := s6_4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 622 := t622, rir_reg%
                      fd_curve25519_scalar_muladd.hty 630 := s13_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 638 := s15_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 640 := s14_6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 643 := s17_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 645 := s16_4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 648 := s8_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 650 := s7_6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 652 := carry9_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
                      fd_curve25519_scalar_muladd.hty 656 := s12_9, rir_reg%
           fd_curve25519_scalar_muladd.hty 658 := s11_10]) →
          (ht612 : t612 = s10_7 + 1048576#64) →
          (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21) →
          (ht614 : t614 = t541 + t531) →
          (ht615 : t615 = t614 + t548) →
          (ht616 : t616 = t615 + t561) →
          (ht617 : t617 = t616 + t570) →
          (ht618 : t618 = t617 + t596) →
          (ht619 : t619 = t618 + s11_1) →
          (hs11_8 : s11_8 = t619 - ((BitVec.sshiftRight (s11_1 + 1048576#64) 21) <<< 21)) →
          (hs11_9 : s11_9 = s11_8 + carry10_1) →
          (ht622 : t622 = (BitVec.sshiftRight (s10_7 + 1048576#64) 21) <<< 21) →
          (ht623 : t623 = s12_7 + 1048576#64) →
          (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21) →
          (ht625 : t625 = t543 + t533) →
          (ht626 : t626 = t625 + t550) →
          (ht627 : t627 = t626 + t563) →
          (ht628 : t628 = t627 + s13_1) →
          (hs13_6 : s13_6 = t628 - ((BitVec.sshiftRight (s13_1 + 1048576#64) 21) <<< 21)) →
          (hs13_7 : s13_7 = s13_6 + carry12_1) →
          (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21)) →
          (ht633 : t633 = s14_5 + 1048576#64) →
          (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21) →
          (ht635 : t635 = t545 + t535) →
          (ht636 : t636 = t635 + s15_1) →
          (hs15_4 : s15_4 = t636 - ((BitVec.sshiftRight (s15_1 + 1048576#64) 21) <<< 21)) →
          (hs15_5 : s15_5 = s15_4 + carry14_1) →
          (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21)) →
          (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21) →
          (hs17_3 : s17_3 = carry16_1 + s17_2) →
          (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21)) →
          (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21) →
          (hs8_7 : s8_7 = s8_6 + carry7_1) →
          (hs7_6 : s7_6 = s7_5 - ((BitVec.sshiftRight (s7_5 + 1048576#64) 21) <<< 21)) →
          (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21) →
          (ht653 : t653 = (BitVec.sshiftRight (s9_7 + 1048576#64) 21) <<< 21) →
          (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21) →
          (hs12_9 : s12_9 = carry11_1 + s12_8) →
          (hs11_10 : s11_10 = s11_9 - ((BitVec.sshiftRight (s11_9 + 1048576#64) 21) <<< 21)) →
          (hbs13_7 : Bnd s13_7 (-117632557296611) 353118642816323) →
          (hbs15_5 : Bnd s15_5 (-46613196902558) 74084291855054) →
          (hbs14_6 : Bnd s14_6 (-1048576) 1048575) →
          (hbs17_3 : Bnd s17_3 (-176127222) 1048613) →
          (hbs16_4 : Bnd s16_4 (-1048576) 1048575) →
          (hbs8_7 : Bnd s8_7 (-1617046) 18547711) →
          (hbs7_6 : Bnd s7_6 (-1048576) 1048575) →
          (hbcarry9_1 : Bnd carry9_1 (-37315442) 17384549) →
          (hbs12_9 : Bnd s12_9 (-61065800) 188230089) →
          (hbs11_10 : Bnd s11_10 (-1048576) 1048575) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 659 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 612 S >>= g) = K := by
  fold_eqs
  step_pure with t612
  step_pure [ht612] with carry10_1
  sbnd carry10_1
  step_pure with t614
  sbnd t614
  step_pure with t615
  sbnd t615
  step_pure with t616
  sbnd t616
  step_pure with t617
  sbnd t617
  step_pure with t618
  sbnd t618
  step_pure with t619
  step_pure [ht509] with s11_8
  sbnd s11_8
  step_pure with s11_9
  sbnd s11_9
  step_pure [ht612, Bnd.and_neg_shift] with t622
  step_pure with t623
  step_pure [ht623] with carry12_1
  sbnd carry12_1
  step_pure with t625
  sbnd t625
  step_pure with t626
  sbnd t626
  step_pure with t627
  sbnd t627
  step_pure with t628
  step_pure [ht512] with s13_6
  sbnd s13_6
  step_pure with s13_7
  sbnd s13_7
  step_pure [ht623, Bnd.and_neg_shift]
  step_pure with s12_8
  sbnd s12_8
  step_pure with t633
  step_pure [ht633] with carry14_1
  sbnd carry14_1
  step_pure with t635
  sbnd t635
  step_pure with t636
  step_pure [ht515] with s15_4
  sbnd s15_4
  step_pure with s15_5
  sbnd s15_5
  step_pure [ht633, Bnd.and_neg_shift]
  step_pure with s14_6
  sbnd s14_6
  step_pure [nswAdd]
  step_pure with carry16_1
  sbnd carry16_1
  step_pure [nswAdd] with s17_3
  sbnd s17_3
  step_pure [Bnd.and_neg_shift]
  step_pure with s16_4
  sbnd s16_4
  step_pure
  step_pure with carry7_1
  sbnd carry7_1
  step_pure with s8_7
  sbnd s8_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s7_6
  sbnd s7_6
  step_pure
  step_pure with carry9_1
  sbnd carry9_1
  step_pure [Bnd.and_neg_shift] with t653
  step_pure
  step_pure with carry11_1
  sbnd carry11_1
  step_pure with s12_9
  sbnd s12_9
  step_pure [Bnd.and_neg_shift]
  step_pure with s11_10
  sbnd s11_10
  exact
    hK _ t612 carry10_1 t614 t615 t616 t617 t618 t619 s11_8 s11_9 t622 t623 carry12_1 t625 t626 t627
      t628 s13_6 s13_7 s12_8 t633 carry14_1 t635 t636 s15_4 s15_5 s14_6 carry16_1 s17_3 s16_4
      carry7_1 s8_7 s7_6 carry9_1 t653 carry11_1 s12_9 s11_10 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht612 hcarry10_1
      ht614 ht615 ht616 ht617 ht618 ht619 hs11_8 hs11_9 ht622 ht623 hcarry12_1 ht625 ht626 ht627
      ht628 hs13_6 hs13_7 hs12_8 ht633 hcarry14_1 ht635 ht636 hs15_4 hs15_5 hs14_6 hcarry16_1 hs17_3
      hs16_4 hcarry7_1 hs8_7 hs7_6 hcarry9_1 ht653 hcarry11_1 hs12_9 hs11_10 hbs13_7 hbs15_5 hbs14_6
      hbs17_3 hbs16_4 hbs8_7 hbs7_6 hbcarry9_1 hbs12_9 hbs11_10

/-- From `%659`: the carries `carry13_1`, `carry15_1`. -/
theorem fd_curve25519_scalar_muladd.run659 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s2_2 s1_2 s4_2 s3_2 s5_2 s10_7 s6_4 s9_7 t622 s13_7 s15_5 s14_6 s17_3 s16_4 s8_7 s7_6
     carry9_1 t653 s12_9 s11_10 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 492 := s4_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 494 := s3_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 498 := s5_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 595 := s10_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 601 := s6_4, rir_reg%
               fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 622 := t622, rir_reg%
               fd_curve25519_scalar_muladd.hty 630 := s13_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 638 := s15_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 640 := s14_6, rir_reg%
               fd_curve25519_scalar_muladd.hty 643 := s17_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 645 := s16_4, rir_reg%
               fd_curve25519_scalar_muladd.hty 648 := s8_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 650 := s7_6, rir_reg%
               fd_curve25519_scalar_muladd.hty 652 := carry9_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
               fd_curve25519_scalar_muladd.hty 656 := s12_9, rir_reg%
     fd_curve25519_scalar_muladd.hty 658 := s11_10])
    (hbs4_2 : Bnd s4_2 (-1048576) 9437179)
    (hbs3_2 : Bnd s3_2 (-1048576) 1048575)
    (hbs5_2 : Bnd s5_2 (-1048576) 1048575)
    (hbs6_4 : Bnd s6_4 (-1048576) 1048575)
    (ht622 : t622 = (BitVec.sshiftRight (s10_7 + 1048576#64) 21) <<< 21)
    (hbs13_7 : Bnd s13_7 (-117632557296611) 353118642816323)
    (hbs15_5 : Bnd s15_5 (-46613196902558) 74084291855054)
    (hbs14_6 : Bnd s14_6 (-1048576) 1048575)
    (hbs17_3 : Bnd s17_3 (-176127222) 1048613)
    (hbs16_4 : Bnd s16_4 (-1048576) 1048575)
    (hbs8_7 : Bnd s8_7 (-1617046) 18547711)
    (hbs7_6 : Bnd s7_6 (-1048576) 1048575)
    (hbcarry9_1 : Bnd carry9_1 (-37315442) 17384549)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t669 s5_3 t671 s6_5 t673 s7_7 t675 s8_8 t677
         t678 t679 t680 s10_10 t682 s4_3 t684 s5_4 t686 s6_6 t688 s7_8 t690 s8_9 t692 t693 s3_3
        t695 s4_4 t697 s5_5 t699 s6_7 t701 s7_9 t703 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
                      fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
                      fd_curve25519_scalar_muladd.hty 656 := s12_9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 658 := s11_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 661 := s14_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 663 := s13_8, rir_reg%
                      fd_curve25519_scalar_muladd.hty 677 := t677, rir_reg%
                      fd_curve25519_scalar_muladd.hty 681 := s10_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 691 := s8_9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 692 := t692, rir_reg%
                      fd_curve25519_scalar_muladd.hty 694 := s3_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 696 := s4_4, rir_reg%
                      fd_curve25519_scalar_muladd.hty 698 := s5_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 700 := s6_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 702 := s7_9, rir_reg%
           fd_curve25519_scalar_muladd.hty 703 := t703]) →
          (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21) →
          (hs14_7 : s14_7 = carry13_1 + s14_6) →
          (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21)) →
          (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21) →
          (hs16_5 : s16_5 = carry15_1 + s16_4) →
          (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21)) →
          (ht669 : t669 = s17_3 * 666643#64) →
          (hs5_3 : s5_3 = s5_2 + t669) →
          (ht671 : t671 = s17_3 * 470296#64) →
          (hs6_5 : s6_5 = s6_4 + t671) →
          (ht673 : t673 = s17_3 * 654183#64) →
          (hs7_7 : s7_7 = s7_6 + t673) →
          (ht675 : t675 = s17_3 * 18446744073708553811#64) →
          (hs8_8 : s8_8 = s8_7 + t675) →
          (ht677 : t677 = s17_3 * 136657#64) →
          (ht678 : t678 = s17_3 * 18446744073708867715#64) →
          (ht679 : t679 = s10_7 + t678) →
          (ht680 : t680 = t679 + carry9_1) →
          (hs10_10 : s10_10 = t680 - ((BitVec.sshiftRight (s10_7 + 1048576#64) 21) <<< 21)) →
          (ht682 : t682 = s16_5 * 666643#64) →
          (hs4_3 : s4_3 = s4_2 + t682) →
          (ht684 : t684 = s16_5 * 470296#64) →
          (hs5_4 : s5_4 = s5_3 + t684) →
          (ht686 : t686 = s16_5 * 654183#64) →
          (hs6_6 : s6_6 = s6_5 + t686) →
          (ht688 : t688 = s16_5 * 18446744073708553811#64) →
          (hs7_8 : s7_8 = s7_7 + t688) →
          (ht690 : t690 = s16_5 * 136657#64) →
          (hs8_9 : s8_9 = s8_8 + t690) →
          (ht692 : t692 = s16_5 * 18446744073708867715#64) →
          (ht693 : t693 = s15_6 * 666643#64) →
          (hs3_3 : s3_3 = s3_2 + t693) →
          (ht695 : t695 = s15_6 * 470296#64) →
          (hs4_4 : s4_4 = s4_3 + t695) →
          (ht697 : t697 = s15_6 * 654183#64) →
          (hs5_5 : s5_5 = s5_4 + t697) →
          (ht699 : t699 = s15_6 * 18446744073708553811#64) →
          (hs6_7 : s6_7 = s6_6 + t699) →
          (ht701 : t701 = s15_6 * 136657#64) →
          (hs7_9 : s7_9 = s7_8 + t701) →
          (ht703 : t703 = s15_6 * 18446744073708867715#64) →
          (hbs14_7 : Bnd s14_7 (-57140150) 169428665) →
          (hbs13_8 : Bnd s13_8 (-1048576) 1048575) →
          (hbt677 : Bnd t677 (-24069017776854) 143300306741) →
          (hbs10_10 : Bnd s10_10 (-717185843331) 120453601686146) →
          (hbs8_9 : Bnd s8_9 (-4227070181871) 180711501133147) →
          (hbt692 : Bnd t692 (-24876706014918) 15918124047480) →
          (hbs3_3 : Bnd s3_3 (-699026898944) 699026232300) →
          (hbs4_4 : Bnd s4_4 (-16009577960712) 24742101197053) →
          (hbs5_5 : Bnd s5_5 (-129046306439810) 18491895880487) →
          (hbs6_7 : Bnd s6_7 (-99104625757003) 25335156069097) →
          (hbs7_9 : Bnd s7_9 (-151657606262624) 24053671281929) →
          (hbt703 : Bnd t703 (-717121491075) 717122174976) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 704 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 659 S >>= g) = K := by
  fold_eqs
  step_pure
  step_pure with carry13_1
  sbnd carry13_1
  step_pure with s14_7
  sbnd s14_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s13_8
  sbnd s13_8
  step_pure
  step_pure with carry15_1
  sbnd carry15_1
  step_pure with s16_5
  sbnd s16_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s15_6
  sbnd s15_6
  step_pure with t669
  sbnd t669
  step_pure with s5_3
  sbnd s5_3
  step_pure with t671
  sbnd t671
  step_pure with s6_5
  sbnd s6_5
  step_pure with t673
  sbnd t673
  step_pure with s7_7
  sbnd s7_7
  step_pure with t675
  sbnd t675
  step_pure with s8_8
  sbnd s8_8
  step_pure with t677
  sbnd t677
  step_pure with t678
  sbnd t678
  step_pure with t679
  step_pure with t680
  step_pure [ht622] with s10_10
  sbnd s10_10
  step_pure with t682
  sbnd t682
  step_pure with s4_3
  sbnd s4_3
  step_pure with t684
  sbnd t684
  step_pure with s5_4
  sbnd s5_4
  step_pure with t686
  sbnd t686
  step_pure with s6_6
  sbnd s6_6
  step_pure with t688
  sbnd t688
  step_pure with s7_8
  sbnd s7_8
  step_pure with t690
  sbnd t690
  step_pure with s8_9
  sbnd s8_9
  step_pure with t692
  sbnd t692
  step_pure with t693
  sbnd t693
  step_pure with s3_3
  sbnd s3_3
  step_pure with t695
  sbnd t695
  step_pure with s4_4
  sbnd s4_4
  step_pure with t697
  sbnd t697
  step_pure with s5_5
  sbnd s5_5
  step_pure with t699
  sbnd t699
  step_pure with s6_7
  sbnd s6_7
  step_pure with t701
  sbnd t701
  step_pure with s7_9
  sbnd s7_9
  step_pure with t703
  sbnd t703
  exact
    hK _ carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t669 s5_3 t671 s6_5 t673 s7_7 t675 s8_8 t677
      t678 t679 t680 s10_10 t682 s4_3 t684 s5_4 t686 s6_6 t688 s7_8 t690 s8_9 t692 t693 s3_3 t695
      s4_4 t697 s5_5 t699 s6_7 t701 s7_9 t703 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) hcarry13_1 hs14_7
      hs13_8 hcarry15_1 hs16_5 hs15_6 ht669 hs5_3 ht671 hs6_5 ht673 hs7_7 ht675 hs8_8 ht677 ht678
      ht679 ht680 hs10_10 ht682 hs4_3 ht684 hs5_4 ht686 hs6_6 ht688 hs7_8 ht690 hs8_9 ht692 ht693
      hs3_3 ht695 hs4_4 ht697 hs5_5 ht699 hs6_7 ht701 hs7_9 ht703 hbs14_7 hbs13_8 hbt677 hbs10_10
      hbs8_9 hbt692 hbs3_3 hbs4_4 hbs5_5 hbs6_7 hbs7_9 hbt703

/-- From `%704`: the carries `carry0_1`, `carry2_1`, `carry4_1`. -/
theorem fd_curve25519_scalar_muladd.run704 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s2_2 s1_2 s9_7 t653 s12_9 s11_10 s14_7 s13_8 t677 s10_10 s8_9 t692 s3_3 s4_4 s5_5 s6_7
     s7_9 t703 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 371 := s0_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 487 := s2_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 489 := s1_2, rir_reg%
               fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
               fd_curve25519_scalar_muladd.hty 656 := s12_9, rir_reg%
               fd_curve25519_scalar_muladd.hty 658 := s11_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 661 := s14_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 663 := s13_8, rir_reg%
               fd_curve25519_scalar_muladd.hty 677 := t677, rir_reg%
               fd_curve25519_scalar_muladd.hty 681 := s10_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 691 := s8_9, rir_reg%
               fd_curve25519_scalar_muladd.hty 692 := t692, rir_reg%
               fd_curve25519_scalar_muladd.hty 694 := s3_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 696 := s4_4, rir_reg%
               fd_curve25519_scalar_muladd.hty 698 := s5_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 700 := s6_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 702 := s7_9, rir_reg%
     fd_curve25519_scalar_muladd.hty 703 := t703])
    (hbs0_1 : Bnd s0_1 (-1048576) 1048575)
    (hbs2_2 : Bnd s2_2 (-1048576) 5242877)
    (hbs1_2 : Bnd s1_2 (-1048576) 1048575)
    (hbs12_9 : Bnd s12_9 (-61065800) 188230089)
    (hbs14_7 : Bnd s14_7 (-57140150) 169428665)
    (hbs13_8 : Bnd s13_8 (-1048576) 1048575)
    (hbs8_9 : Bnd s8_9 (-4227070181871) 180711501133147)
    (hbs3_3 : Bnd s3_3 (-699026898944) 699026232300)
    (hbs4_4 : Bnd s4_4 (-16009577960712) 24742101197053)
    (hbs6_7 : Bnd s6_7 (-99104625757003) 25335156069097)
    (hbs7_9 : Bnd s7_9 (-151657606262624) 24053671281929)
    (hbt703 : Bnd t703 (-717121491075) 717122174976)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s8_10 t705 t706 t707 t708 t709 s6_8 t711 s7_10 t713 t714 t715 t716 t717 t718 s6_9 t720
         s0_2 t722 t723 t724 t725 s2_5 t727 t728 t729 t730 s4_7 t732 t733 carry0_1 t735 s1_4 s1_5
        s0_3 t740 carry2_1 t742 t743 s3_6 s3_7 t746 t747 carry4_1 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
                      fd_curve25519_scalar_muladd.hty 658 := s11_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 677 := t677, rir_reg%
                      fd_curve25519_scalar_muladd.hty 681 := s10_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 692 := t692, rir_reg%
                      fd_curve25519_scalar_muladd.hty 698 := s5_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 704 := s8_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 708 := t708, rir_reg%
                      fd_curve25519_scalar_muladd.hty 712 := s7_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 717 := t717, rir_reg%
                      fd_curve25519_scalar_muladd.hty 719 := s6_9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 726 := s2_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 731 := s4_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 732 := t732, rir_reg%
                      fd_curve25519_scalar_muladd.hty 737 := s1_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 739 := s0_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 745 := s3_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 746 := t746, rir_reg%
                      fd_curve25519_scalar_muladd.hty 747 := t747, rir_reg%
           fd_curve25519_scalar_muladd.hty 748 := carry4_1]) →
          (hs8_10 : s8_10 = s8_9 + t703) →
          (ht705 : t705 = s14_7 * 666643#64) →
          (ht706 : t706 = s14_7 * 470296#64) →
          (ht707 : t707 = s14_7 * 654183#64) →
          (ht708 : t708 = s14_7 * 18446744073708553811#64) →
          (ht709 : t709 = s14_7 * 136657#64) →
          (hs6_8 : s6_8 = s6_7 + t709) →
          (ht711 : t711 = s14_7 * 18446744073708867715#64) →
          (hs7_10 : s7_10 = s7_9 + t711) →
          (ht713 : t713 = s13_8 * 666643#64) →
          (ht714 : t714 = s13_8 * 470296#64) →
          (ht715 : t715 = s13_8 * 654183#64) →
          (ht716 : t716 = s13_8 * 18446744073708553811#64) →
          (ht717 : t717 = s13_8 * 136657#64) →
          (ht718 : t718 = s13_8 * 18446744073708867715#64) →
          (hs6_9 : s6_9 = s6_8 + t718) →
          (ht720 : t720 = s12_9 * 666643#64) →
          (hs0_2 : s0_2 = t720 + s0_1) →
          (ht722 : t722 = s12_9 * 470296#64) →
          (ht723 : t723 = s12_9 * 654183#64) →
          (ht724 : t724 = s2_2 + t723) →
          (ht725 : t725 = t724 + t705) →
          (hs2_5 : s2_5 = t725 + t714) →
          (ht727 : t727 = s12_9 * 18446744073708553811#64) →
          (ht728 : t728 = s12_9 * 136657#64) →
          (ht729 : t729 = s4_4 + t728) →
          (ht730 : t730 = t729 + t707) →
          (hs4_7 : s4_7 = t730 + t716) →
          (ht732 : t732 = s12_9 * 18446744073708867715#64) →
          (ht733 : t733 = s0_2 + 1048576#64) →
          (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21) →
          (ht735 : t735 = s1_2 + t722) →
          (hs1_4 : s1_4 = t735 + t713) →
          (hs1_5 : s1_5 = s1_4 + carry0_1) →
          (hs0_3 : s0_3 = s0_2 - ((BitVec.sshiftRight (s0_2 + 1048576#64) 21) <<< 21)) →
          (ht740 : t740 = s2_5 + 1048576#64) →
          (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21) →
          (ht742 : t742 = s3_3 + t727) →
          (ht743 : t743 = t742 + t706) →
          (hs3_6 : s3_6 = t743 + t715) →
          (hs3_7 : s3_7 = s3_6 + carry2_1) →
          (ht746 : t746 = (BitVec.sshiftRight (s2_5 + 1048576#64) 21) <<< 21) →
          (ht747 : t747 = s4_7 + 1048576#64) →
          (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21) →
          (hbs8_10 : Bnd s8_10 (-4944191672946) 181428623308123) →
          (hbt708 : Bnd t708 (-169056769080325) 57014727370750) →
          (hbs7_10 : Bnd s7_10 (-267530039684789) 63131877007079) →
          (hbt717 : Bnd t717 (-143295250432) 143295113775) →
          (hbs6_9 : Bnd s6_9 (-107630348726628) 49205891316978) →
          (hbt732 : Bnd t732 (-128730746097189) 41762961685800) →
          (hbs1_5 : Bnd s1_5 (-29418047787350) 89222944003254) →
          (hbs0_3 : Bnd s0_3 (-1048576) 1048575) →
          (hbs3_7 : Bnd s3_7 (-216074732879055) 141998482984786) →
          (hbcarry4_1 : Bnd carry4_1 (-29936330) 77413887) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 749 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 704 S >>= g) = K := by
  step_pure with s8_10
  sbnd s8_10
  step_pure with t705
  sbnd t705
  step_pure with t706
  sbnd t706
  step_pure with t707
  sbnd t707
  step_pure with t708
  sbnd t708
  step_pure with t709
  sbnd t709
  step_pure with s6_8
  sbnd s6_8
  step_pure with t711
  sbnd t711
  step_pure with s7_10
  sbnd s7_10
  step_pure with t713
  sbnd t713
  step_pure with t714
  sbnd t714
  step_pure with t715
  sbnd t715
  step_pure with t716
  sbnd t716
  step_pure with t717
  sbnd t717
  step_pure with t718
  sbnd t718
  step_pure with s6_9
  sbnd s6_9
  step_pure with t720
  sbnd t720
  step_pure with s0_2
  sbnd s0_2
  step_pure with t722
  sbnd t722
  step_pure with t723
  sbnd t723
  step_pure with t724
  sbnd t724
  step_pure with t725
  sbnd t725
  step_pure with s2_5
  sbnd s2_5
  step_pure with t727
  sbnd t727
  step_pure with t728
  sbnd t728
  step_pure with t729
  sbnd t729
  step_pure with t730
  sbnd t730
  step_pure with s4_7
  sbnd s4_7
  step_pure with t732
  sbnd t732
  step_pure with t733
  step_pure [ht733] with carry0_1
  sbnd carry0_1
  step_pure with t735
  sbnd t735
  step_pure with s1_4
  sbnd s1_4
  step_pure with s1_5
  sbnd s1_5
  step_pure [ht733, Bnd.and_neg_shift]
  step_pure with s0_3
  sbnd s0_3
  step_pure with t740
  step_pure [ht740] with carry2_1
  sbnd carry2_1
  step_pure with t742
  sbnd t742
  step_pure with t743
  sbnd t743
  step_pure with s3_6
  sbnd s3_6
  step_pure with s3_7
  sbnd s3_7
  step_pure [ht740, Bnd.and_neg_shift] with t746
  step_pure with t747
  step_pure [ht747] with carry4_1
  sbnd carry4_1
  exact
    hK _ s8_10 t705 t706 t707 t708 t709 s6_8 t711 s7_10 t713 t714 t715 t716 t717 t718 s6_9 t720 s0_2
      t722 t723 t724 t725 s2_5 t727 t728 t729 t730 s4_7 t732 t733 carry0_1 t735 s1_4 s1_5 s0_3 t740
      carry2_1 t742 t743 s3_6 s3_7 t746 t747 carry4_1 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) hs8_10 ht705 ht706
      ht707 ht708 ht709 hs6_8 ht711 hs7_10 ht713 ht714 ht715 ht716 ht717 ht718 hs6_9 ht720 hs0_2
      ht722 ht723 ht724 ht725 hs2_5 ht727 ht728 ht729 ht730 hs4_7 ht732 ht733 hcarry0_1 ht735 hs1_4
      hs1_5 hs0_3 ht740 hcarry2_1 ht742 ht743 hs3_6 hs3_7 ht746 ht747 hcarry4_1 hbs8_10 hbt708
      hbs7_10 hbt717 hbs6_9 hbt732 hbs1_5 hbs0_3 hbs3_7 hbcarry4_1

/-- From `%749`: the carries `carry6_2` … `carry11_2`. -/
theorem fd_curve25519_scalar_muladd.run749 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s9_7 t653 s11_10 t677 s10_10 t692 s5_5 s8_10 t708 s7_10 t717 s6_9 s2_5 s4_7 t732 s1_5 s0_3
     s3_7 t746 t747 carry4_1 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 609 := s9_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 653 := t653, rir_reg%
               fd_curve25519_scalar_muladd.hty 658 := s11_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 677 := t677, rir_reg%
               fd_curve25519_scalar_muladd.hty 681 := s10_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 692 := t692, rir_reg%
               fd_curve25519_scalar_muladd.hty 698 := s5_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 704 := s8_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 708 := t708, rir_reg%
               fd_curve25519_scalar_muladd.hty 712 := s7_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 717 := t717, rir_reg%
               fd_curve25519_scalar_muladd.hty 719 := s6_9, rir_reg%
               fd_curve25519_scalar_muladd.hty 726 := s2_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 731 := s4_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 732 := t732, rir_reg%
               fd_curve25519_scalar_muladd.hty 737 := s1_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 739 := s0_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 745 := s3_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 746 := t746, rir_reg%
               fd_curve25519_scalar_muladd.hty 747 := t747, rir_reg%
     fd_curve25519_scalar_muladd.hty 748 := carry4_1])
    (ht653 : t653 = (BitVec.sshiftRight (s9_7 + 1048576#64) 21) <<< 21)
    (hbs11_10 : Bnd s11_10 (-1048576) 1048575)
    (hbt677 : Bnd t677 (-24069017776854) 143300306741)
    (hbs10_10 : Bnd s10_10 (-717185843331) 120453601686146)
    (hbt692 : Bnd t692 (-24876706014918) 15918124047480)
    (hbs5_5 : Bnd s5_5 (-129046306439810) 18491895880487)
    (hbs8_10 : Bnd s8_10 (-4944191672946) 181428623308123)
    (hbt708 : Bnd t708 (-169056769080325) 57014727370750)
    (hbs7_10 : Bnd s7_10 (-267530039684789) 63131877007079)
    (hbt717 : Bnd t717 (-143295250432) 143295113775)
    (hbs6_9 : Bnd s6_9 (-107630348726628) 49205891316978)
    (hbt732 : Bnd t732 (-128730746097189) 41762961685800)
    (hbs1_5 : Bnd s1_5 (-29418047787350) 89222944003254)
    (hbs3_7 : Bnd s3_7 (-216074732879055) 141998482984786)
    (ht747 : t747 = s4_7 + 1048576#64)
    (hbcarry4_1 : Bnd carry4_1 (-29936330) 77413887)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t749 t750 s5_8 s5_9 t753 carry6_2 s7_11 s6_10 t759 carry8_2 t761 s9_9 s9_10 s9_11 s8_11
         carry10_2 s11_11 s10_11 carry1_1 t774 carry3_1 t777 carry5_1 s6_11 t781 carry7_2 s8_12
        s7_12 carry9_2 s10_12 s9_12 carry11_2 s11_12 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 726 := s2_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 731 := s4_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 737 := s1_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 739 := s0_3, rir_reg%
                      fd_curve25519_scalar_muladd.hty 745 := s3_7, rir_reg%
                      fd_curve25519_scalar_muladd.hty 746 := t746, rir_reg%
                      fd_curve25519_scalar_muladd.hty 752 := s5_9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 753 := t753, rir_reg%
                      fd_curve25519_scalar_muladd.hty 773 := carry1_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 774 := t774, rir_reg%
                      fd_curve25519_scalar_muladd.hty 776 := carry3_1, rir_reg%
                      fd_curve25519_scalar_muladd.hty 777 := t777, rir_reg%
                      fd_curve25519_scalar_muladd.hty 780 := s6_11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 781 := t781, rir_reg%
                      fd_curve25519_scalar_muladd.hty 784 := s8_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 786 := s7_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 789 := s10_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 791 := s9_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 793 := carry11_2, rir_reg%
           fd_curve25519_scalar_muladd.hty 795 := s11_12]) →
          (ht749 : t749 = s5_5 + t732) →
          (ht750 : t750 = t749 + t708) →
          (hs5_8 : s5_8 = t750 + t717) →
          (hs5_9 : s5_9 = s5_8 + carry4_1) →
          (ht753 : t753 = (BitVec.sshiftRight (s4_7 + 1048576#64) 21) <<< 21) →
          (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21) →
          (hs7_11 : s7_11 = s7_10 + carry6_2) →
          (hs6_10 : s6_10 = s6_9 - ((BitVec.sshiftRight (s6_9 + 1048576#64) 21) <<< 21)) →
          (ht759 : t759 = s8_10 + 1048576#64) →
          (hcarry8_2 : carry8_2 = BitVec.sshiftRight (s8_10 + 1048576#64) 21) →
          (ht761 : t761 = t677 + s9_7) →
          (hs9_9 : s9_9 = t761 - ((BitVec.sshiftRight (s9_7 + 1048576#64) 21) <<< 21)) →
          (hs9_10 : s9_10 = s9_9 + t692) →
          (hs9_11 : s9_11 = s9_10 + carry8_2) →
          (hs8_11 : s8_11 = s8_10 - ((BitVec.sshiftRight (s8_10 + 1048576#64) 21) <<< 21)) →
          (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21) →
          (hs11_11 : s11_11 = s11_10 + carry10_2) →
          (hs10_11 : s10_11 = s10_10 - ((BitVec.sshiftRight (s10_10 + 1048576#64) 21) <<< 21)) →
          (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21) →
          (ht774 : t774 = (BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21) →
          (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21) →
          (ht777 : t777 = (BitVec.sshiftRight (s3_7 + 1048576#64) 21) <<< 21) →
          (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21) →
          (hs6_11 : s6_11 = s6_10 + carry5_1) →
          (ht781 : t781 = (BitVec.sshiftRight (s5_9 + 1048576#64) 21) <<< 21) →
          (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21) →
          (hs8_12 : s8_12 = s8_11 + carry7_2) →
          (hs7_12 : s7_12 = s7_11 - ((BitVec.sshiftRight (s7_11 + 1048576#64) 21) <<< 21)) →
          (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21) →
          (hs10_12 : s10_12 = s10_11 + carry9_2) →
          (hs9_12 : s9_12 = s9_11 - ((BitVec.sshiftRight (s9_11 + 1048576#64) 21) <<< 21)) →
          (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21) →
          (hs11_12 : s11_12 = s11_11 - ((BitVec.sshiftRight (s11_11 + 1048576#64) 21) <<< 21)) →
          (hbcarry1_1 : Bnd carry1_1 (-14027618) 42544815) →
          (hbcarry3_1 : Bnd carry3_1 (-103032462) 67710153) →
          (hbs6_11 : Bnd s6_11 (-204647145) 57035436) →
          (hbs8_12 : Bnd s8_12 (-128616864) 31152211) →
          (hbs7_12 : Bnd s7_12 (-1048576) 1048575) →
          (hbs10_12 : Bnd s10_12 (-24387717) 8707301) →
          (hbs9_12 : Bnd s9_12 (-1048576) 1048575) →
          (hbcarry11_2 : Bnd carry11_2 (-1) 28) →
          (hbs11_12 : Bnd s11_12 (-1048576) 1048575) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 796 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 749 S >>= g) = K := by
  fold_eqs
  step_pure with t749
  sbnd t749
  step_pure with t750
  sbnd t750
  step_pure with s5_8
  sbnd s5_8
  step_pure with s5_9
  sbnd s5_9
  step_pure [ht747, Bnd.and_neg_shift] with t753
  step_pure
  step_pure with carry6_2
  sbnd carry6_2
  step_pure with s7_11
  sbnd s7_11
  step_pure [Bnd.and_neg_shift]
  step_pure with s6_10
  sbnd s6_10
  step_pure with t759
  step_pure [ht759] with carry8_2
  sbnd carry8_2
  step_pure with t761
  step_pure [ht653] with s9_9
  sbnd s9_9
  step_pure with s9_10
  sbnd s9_10
  step_pure with s9_11
  sbnd s9_11
  step_pure [ht759, Bnd.and_neg_shift]
  step_pure with s8_11
  sbnd s8_11
  step_pure
  step_pure with carry10_2
  sbnd carry10_2
  step_pure with s11_11
  sbnd s11_11
  step_pure [Bnd.and_neg_shift]
  step_pure with s10_11
  sbnd s10_11
  step_pure
  step_pure with carry1_1
  sbnd carry1_1
  step_pure [Bnd.and_neg_shift] with t774
  step_pure
  step_pure with carry3_1
  sbnd carry3_1
  step_pure [Bnd.and_neg_shift] with t777
  step_pure
  step_pure with carry5_1
  sbnd carry5_1
  step_pure with s6_11
  sbnd s6_11
  step_pure [Bnd.and_neg_shift] with t781
  step_pure
  step_pure with carry7_2
  sbnd carry7_2
  step_pure with s8_12
  sbnd s8_12
  step_pure [Bnd.and_neg_shift]
  step_pure with s7_12
  sbnd s7_12
  step_pure
  step_pure with carry9_2
  sbnd carry9_2
  step_pure with s10_12
  sbnd s10_12
  step_pure [Bnd.and_neg_shift]
  step_pure with s9_12
  sbnd s9_12
  step_pure
  step_pure with carry11_2
  sbnd carry11_2
  step_pure [Bnd.and_neg_shift]
  step_pure with s11_12
  sbnd s11_12
  exact
    hK _ t749 t750 s5_8 s5_9 t753 carry6_2 s7_11 s6_10 t759 carry8_2 t761 s9_9 s9_10 s9_11 s8_11
      carry10_2 s11_11 s10_11 carry1_1 t774 carry3_1 t777 carry5_1 s6_11 t781 carry7_2 s8_12 s7_12
      carry9_2 s10_12 s9_12 carry11_2 s11_12 hArgs
      (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht749 ht750 hs5_8
      hs5_9 ht753 hcarry6_2 hs7_11 hs6_10 ht759 hcarry8_2 ht761 hs9_9 hs9_10 hs9_11 hs8_11
      hcarry10_2 hs11_11 hs10_11 hcarry1_1 ht774 hcarry3_1 ht777 hcarry5_1 hs6_11 ht781 hcarry7_2
      hs8_12 hs7_12 hcarry9_2 hs10_12 hs9_12 hcarry11_2 hs11_12 hbcarry1_1 hbcarry3_1 hbs6_11
      hbs8_12 hbs7_12 hbs10_12 hbs9_12 hbcarry11_2 hbs11_12

/-- From `%796`: the carries `carry0_2` … `carry8_3`. -/
theorem fd_curve25519_scalar_muladd.run796 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s2_5 s4_7 s1_5 s0_3 s3_7 t746 s5_9 t753 carry1_1 t774 carry3_1 t777 s6_11 t781 s8_12 s7_12
     s10_12 s9_12 carry11_2 s11_12 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 726 := s2_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 731 := s4_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 737 := s1_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 739 := s0_3, rir_reg%
               fd_curve25519_scalar_muladd.hty 745 := s3_7, rir_reg%
               fd_curve25519_scalar_muladd.hty 746 := t746, rir_reg%
               fd_curve25519_scalar_muladd.hty 752 := s5_9, rir_reg%
               fd_curve25519_scalar_muladd.hty 753 := t753, rir_reg%
               fd_curve25519_scalar_muladd.hty 773 := carry1_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 774 := t774, rir_reg%
               fd_curve25519_scalar_muladd.hty 776 := carry3_1, rir_reg%
               fd_curve25519_scalar_muladd.hty 777 := t777, rir_reg%
               fd_curve25519_scalar_muladd.hty 780 := s6_11, rir_reg%
               fd_curve25519_scalar_muladd.hty 781 := t781, rir_reg%
               fd_curve25519_scalar_muladd.hty 784 := s8_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 786 := s7_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 789 := s10_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 791 := s9_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 793 := carry11_2, rir_reg%
     fd_curve25519_scalar_muladd.hty 795 := s11_12])
    (hbs0_3 : Bnd s0_3 (-1048576) 1048575)
    (ht746 : t746 = (BitVec.sshiftRight (s2_5 + 1048576#64) 21) <<< 21)
    (ht753 : t753 = (BitVec.sshiftRight (s4_7 + 1048576#64) 21) <<< 21)
    (hbcarry1_1 : Bnd carry1_1 (-14027618) 42544815)
    (ht774 : t774 = (BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21)
    (hbcarry3_1 : Bnd carry3_1 (-103032462) 67710153)
    (ht777 : t777 = (BitVec.sshiftRight (s3_7 + 1048576#64) 21) <<< 21)
    (hbs6_11 : Bnd s6_11 (-204647145) 57035436)
    (ht781 : t781 = (BitVec.sshiftRight (s5_9 + 1048576#64) 21) <<< 21)
    (hbs8_12 : Bnd s8_12 (-128616864) 31152211)
    (hbs7_12 : Bnd s7_12 (-1048576) 1048575)
    (hbs9_12 : Bnd s9_12 (-1048576) 1048575)
    (hbcarry11_2 : Bnd carry11_2 (-1) 28)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t796 s0_4 t798 t799 t800 t801 t802 carry0_2 t804 s1_7 s1_8 s0_5 carry1_2 t809 t810 s2_8
         s2_9 s1_9 carry2_2 t815 s3_9 s3_10 s2_10 carry3_2 t820 t821 s4_10 s4_11 s3_11 carry4_2
         t826 s5_11 s5_12 s4_12 carry5_2 s6_12 s5_13 carry6_3 s7_13 s6_13 carry7_3 s8_13 t838
        carry8_3 s9_13 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 789 := s10_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 795 := s11_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 807 := s0_5, rir_reg%
                      fd_curve25519_scalar_muladd.hty 813 := s1_9, rir_reg%
                      fd_curve25519_scalar_muladd.hty 818 := s2_10, rir_reg%
                      fd_curve25519_scalar_muladd.hty 824 := s3_11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 829 := s4_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 832 := s5_13, rir_reg%
                      fd_curve25519_scalar_muladd.hty 835 := s6_13, rir_reg%
                      fd_curve25519_scalar_muladd.hty 837 := s8_13, rir_reg%
                      fd_curve25519_scalar_muladd.hty 838 := t838, rir_reg%
           fd_curve25519_scalar_muladd.hty 840 := s9_13]) →
          (ht796 : t796 = carry11_2 * 666643#64) →
          (hs0_4 : s0_4 = s0_3 + t796) →
          (ht798 : t798 = carry11_2 * 470296#64) →
          (ht799 : t799 = carry11_2 * 654183#64) →
          (ht800 : t800 = carry11_2 * 18446744073708553811#64) →
          (ht801 : t801 = carry11_2 * 136657#64) →
          (ht802 : t802 = carry11_2 * 18446744073708867715#64) →
          (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21) →
          (ht804 : t804 = s1_5 + t798) →
          (hs1_7 : s1_7 = t804 - ((BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21)) →
          (hs1_8 : s1_8 = s1_7 + carry0_2) →
          (hs0_5 : s0_5 = s0_4 - ((BitVec.sshiftRight s0_4 21) <<< 21)) →
          (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21) →
          (ht809 : t809 = s2_5 + t799) →
          (ht810 : t810 = t809 - ((BitVec.sshiftRight (s2_5 + 1048576#64) 21) <<< 21)) →
          (hs2_8 : s2_8 = t810 + carry1_1) →
          (hs2_9 : s2_9 = s2_8 + carry1_2) →
          (hs1_9 : s1_9 = s1_8 - ((BitVec.sshiftRight s1_8 21) <<< 21)) →
          (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21) →
          (ht815 : t815 = s3_7 + t800) →
          (hs3_9 : s3_9 = t815 - ((BitVec.sshiftRight (s3_7 + 1048576#64) 21) <<< 21)) →
          (hs3_10 : s3_10 = s3_9 + carry2_2) →
          (hs2_10 : s2_10 = s2_9 - ((BitVec.sshiftRight s2_9 21) <<< 21)) →
          (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21) →
          (ht820 : t820 = s4_7 + t801) →
          (ht821 : t821 = t820 - ((BitVec.sshiftRight (s4_7 + 1048576#64) 21) <<< 21)) →
          (hs4_10 : s4_10 = t821 + carry3_1) →
          (hs4_11 : s4_11 = s4_10 + carry3_2) →
          (hs3_11 : s3_11 = s3_10 - ((BitVec.sshiftRight s3_10 21) <<< 21)) →
          (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21) →
          (ht826 : t826 = s5_9 + t802) →
          (hs5_11 : s5_11 = t826 - ((BitVec.sshiftRight (s5_9 + 1048576#64) 21) <<< 21)) →
          (hs5_12 : s5_12 = s5_11 + carry4_2) →
          (hs4_12 : s4_12 = s4_11 - ((BitVec.sshiftRight s4_11 21) <<< 21)) →
          (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21) →
          (hs6_12 : s6_12 = s6_11 + carry5_2) →
          (hs5_13 : s5_13 = s5_12 - ((BitVec.sshiftRight s5_12 21) <<< 21)) →
          (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21) →
          (hs7_13 : s7_13 = carry6_3 + s7_12) →
          (hs6_13 : s6_13 = s6_12 - ((BitVec.sshiftRight s6_12 21) <<< 21)) →
          (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21) →
          (hs8_13 : s8_13 = s8_12 + carry7_3) →
          (ht838 : t838 = s7_13 - ((BitVec.sshiftRight s7_13 21) <<< 21)) →
          (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21) →
          (hs9_13 : s9_13 = carry8_3 + s9_12) →
          (hbs0_5 : Bnd s0_5 0 2097151) →
          (hbs1_9 : Bnd s1_9 0 2097151) →
          (hbs2_10 : Bnd s2_10 0 2097151) →
          (hbs3_11 : Bnd s3_11 0 2097151) →
          (hbs4_12 : Bnd s4_12 0 2097151) →
          (hbs5_13 : Bnd s5_13 0 2097151) →
          (hbs6_13 : Bnd s6_13 0 2097151) →
          (hbt838 : Bnd t838 0 2097151) →
          (hbs9_13 : Bnd s9_13 (-1048638) 1048589) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 841 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 796 S >>= g) = K := by
  fold_eqs
  step_pure [nswMul] with t796
  sbnd t796
  step_pure with s0_4
  sbnd s0_4
  step_pure [nswMul] with t798
  sbnd t798
  step_pure [nswMul] with t799
  sbnd t799
  step_pure [nswMul] with t800
  sbnd t800
  step_pure [nswMul] with t801
  sbnd t801
  step_pure [nswMul] with t802
  sbnd t802
  step_pure with carry0_2
  sbnd carry0_2
  step_pure with t804
  step_pure [ht774] with s1_7
  sbnd s1_7
  step_pure with s1_8
  sbnd s1_8
  step_pure [Bnd.and_mask_sub] with s0_5
  sbnd s0_5
  step_pure with carry1_2
  sbnd carry1_2
  step_pure with t809
  step_pure [ht746] with t810
  sbnd t810
  step_pure with s2_8
  sbnd s2_8
  step_pure with s2_9
  sbnd s2_9
  step_pure [Bnd.and_mask_sub] with s1_9
  sbnd s1_9
  step_pure with carry2_2
  sbnd carry2_2
  step_pure with t815
  step_pure [ht777] with s3_9
  sbnd s3_9
  step_pure with s3_10
  sbnd s3_10
  step_pure [Bnd.and_mask_sub] with s2_10
  sbnd s2_10
  step_pure with carry3_2
  sbnd carry3_2
  step_pure with t820
  step_pure [ht753] with t821
  sbnd t821
  step_pure with s4_10
  sbnd s4_10
  step_pure with s4_11
  sbnd s4_11
  step_pure [Bnd.and_mask_sub] with s3_11
  sbnd s3_11
  step_pure with carry4_2
  sbnd carry4_2
  step_pure with t826
  step_pure [ht781] with s5_11
  sbnd s5_11
  step_pure with s5_12
  sbnd s5_12
  step_pure [Bnd.and_mask_sub] with s4_12
  sbnd s4_12
  step_pure with carry5_2
  sbnd carry5_2
  step_pure with s6_12
  sbnd s6_12
  step_pure [Bnd.and_mask_sub] with s5_13
  sbnd s5_13
  step_pure with carry6_3
  sbnd carry6_3
  step_pure with s7_13
  sbnd s7_13
  step_pure [Bnd.and_mask_sub] with s6_13
  sbnd s6_13
  step_pure with carry7_3
  sbnd carry7_3
  step_pure with s8_13
  sbnd s8_13
  step_pure [Bnd.and_mask_sub] with t838
  sbnd t838
  step_pure with carry8_3
  sbnd carry8_3
  step_pure with s9_13
  sbnd s9_13
  exact
    hK _ t796 s0_4 t798 t799 t800 t801 t802 carry0_2 t804 s1_7 s1_8 s0_5 carry1_2 t809 t810 s2_8
      s2_9 s1_9 carry2_2 t815 s3_9 s3_10 s2_10 carry3_2 t820 t821 s4_10 s4_11 s3_11 carry4_2 t826
      s5_11 s5_12 s4_12 carry5_2 s6_12 s5_13 carry6_3 s7_13 s6_13 carry7_3 s8_13 t838 carry8_3 s9_13
      hArgs (by unfold fd_curve25519_scalar_muladd.Consts; env_reads) (by env_reads) ht796 hs0_4
      ht798 ht799 ht800 ht801 ht802 hcarry0_2 ht804 hs1_7 hs1_8 hs0_5 hcarry1_2 ht809 ht810 hs2_8
      hs2_9 hs1_9 hcarry2_2 ht815 hs3_9 hs3_10 hs2_10 hcarry3_2 ht820 ht821 hs4_10 hs4_11 hs3_11
      hcarry4_2 ht826 hs5_11 hs5_12 hs4_12 hcarry5_2 hs6_12 hs5_13 hcarry6_3 hs7_13 hs6_13 hcarry7_3
      hs8_13 ht838 hcarry8_3 hs9_13 hbs0_5 hbs1_9 hbs2_10 hbs3_11 hbs4_12 hbs5_13 hbs6_13 hbt838
      hbs9_13

/-- From `%841`: the carries `carry9_3` … `carry9_4`. -/
theorem fd_curve25519_scalar_muladd.run841 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s10_12 s11_12 s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_13 s8_13 t838 s9_13 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 789 := s10_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 795 := s11_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 807 := s0_5, rir_reg%
               fd_curve25519_scalar_muladd.hty 813 := s1_9, rir_reg%
               fd_curve25519_scalar_muladd.hty 818 := s2_10, rir_reg%
               fd_curve25519_scalar_muladd.hty 824 := s3_11, rir_reg%
               fd_curve25519_scalar_muladd.hty 829 := s4_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 832 := s5_13, rir_reg%
               fd_curve25519_scalar_muladd.hty 835 := s6_13, rir_reg%
               fd_curve25519_scalar_muladd.hty 837 := s8_13, rir_reg%
               fd_curve25519_scalar_muladd.hty 838 := t838, rir_reg%
     fd_curve25519_scalar_muladd.hty 840 := s9_13])
    (hbs10_12 : Bnd s10_12 (-24387717) 8707301)
    (hbs11_12 : Bnd s11_12 (-1048576) 1048575)
    (hbs0_5 : Bnd s0_5 0 2097151)
    (hbs1_9 : Bnd s1_9 0 2097151)
    (hbs2_10 : Bnd s2_10 0 2097151)
    (hbs3_11 : Bnd s3_11 0 2097151)
    (hbs4_12 : Bnd s4_12 0 2097151)
    (hbs5_13 : Bnd s5_13 0 2097151)
    (hbs6_13 : Bnd s6_13 0 2097151)
    (hbt838 : Bnd t838 0 2097151)
    (hbs9_13 : Bnd s9_13 (-1048638) 1048589)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t841 carry9_3 s10_13 t844 carry10_3 s11_13 t847 carry11_3 t849 t850 t851 s1_10 t853 s2_11
         t855 s3_12 t857 s4_13 t859 s5_14 s0_6 carry0_3 s1_11 carry1_3 s2_12 carry2_3 s3_13
         carry3_3 s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 s7_15 carry7_4 s8_15 carry8_4 s9_15
        carry9_4 s10_15 t882 t883 : BitVec 64),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR : E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 861 := s0_6, rir_reg%
                      fd_curve25519_scalar_muladd.hty 863 := s1_11, rir_reg%
                      fd_curve25519_scalar_muladd.hty 865 := s2_12, rir_reg%
                      fd_curve25519_scalar_muladd.hty 867 := s3_13, rir_reg%
                      fd_curve25519_scalar_muladd.hty 869 := s4_14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 871 := s5_15, rir_reg%
                      fd_curve25519_scalar_muladd.hty 873 := s6_14, rir_reg%
                      fd_curve25519_scalar_muladd.hty 875 := s7_15, rir_reg%
                      fd_curve25519_scalar_muladd.hty 877 := s8_15, rir_reg%
                      fd_curve25519_scalar_muladd.hty 879 := s9_15, rir_reg%
                      fd_curve25519_scalar_muladd.hty 881 := s10_15, rir_reg%
           fd_curve25519_scalar_muladd.hty 883 := t883]) →
          (ht841 : t841 = s8_13 - ((BitVec.sshiftRight s8_13 21) <<< 21)) →
          (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21) →
          (hs10_13 : s10_13 = s10_12 + carry9_3) →
          (ht844 : t844 = s9_13 - ((BitVec.sshiftRight s9_13 21) <<< 21)) →
          (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21) →
          (hs11_13 : s11_13 = carry10_3 + s11_12) →
          (ht847 : t847 = s10_13 - ((BitVec.sshiftRight s10_13 21) <<< 21)) →
          (hcarry11_3 : carry11_3 = BitVec.sshiftRight s11_13 21) →
          (ht849 : t849 = s11_13 - ((BitVec.sshiftRight s11_13 21) <<< 21)) →
          (ht850 : t850 = carry11_3 * 666643#64) →
          (ht851 : t851 = carry11_3 * 470296#64) →
          (hs1_10 : s1_10 = t851 + s1_9) →
          (ht853 : t853 = carry11_3 * 654183#64) →
          (hs2_11 : s2_11 = t853 + s2_10) →
          (ht855 : t855 = carry11_3 * 18446744073708553811#64) →
          (hs3_12 : s3_12 = t855 + s3_11) →
          (ht857 : t857 = carry11_3 * 136657#64) →
          (hs4_13 : s4_13 = t857 + s4_12) →
          (ht859 : t859 = carry11_3 * 18446744073708867715#64) →
          (hs5_14 : s5_14 = t859 + s5_13) →
          (hs0_6 : s0_6 = t850 + s0_5) →
          (hcarry0_3 : carry0_3 = BitVec.sshiftRight s0_6 21) →
          (hs1_11 : s1_11 = s1_10 + carry0_3) →
          (hcarry1_3 : carry1_3 = BitVec.sshiftRight s1_11 21) →
          (hs2_12 : s2_12 = s2_11 + carry1_3) →
          (hcarry2_3 : carry2_3 = BitVec.sshiftRight s2_12 21) →
          (hs3_13 : s3_13 = s3_12 + carry2_3) →
          (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21) →
          (hs4_14 : s4_14 = s4_13 + carry3_3) →
          (hcarry4_3 : carry4_3 = BitVec.sshiftRight s4_14 21) →
          (hs5_15 : s5_15 = s5_14 + carry4_3) →
          (hcarry5_3 : carry5_3 = BitVec.sshiftRight s5_15 21) →
          (hs6_14 : s6_14 = carry5_3 + s6_13) →
          (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21) →
          (hs7_15 : s7_15 = carry6_4 + t838) →
          (hcarry7_4 : carry7_4 = BitVec.sshiftRight s7_15 21) →
          (hs8_15 : s8_15 = carry7_4 + t841) →
          (hcarry8_4 : carry8_4 = BitVec.sshiftRight s8_15 21) →
          (hs9_15 : s9_15 = carry8_4 + t844) →
          (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21) →
          (hs10_15 : s10_15 = carry9_4 + t847) →
          (ht882 : t882 = s10_15 >>> 21) →
          (ht883 : t883 = t882 + t849) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 884 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 841 S >>= g) = K := by
  step_pure [Bnd.and_mask_sub] with t841
  sbnd t841
  step_pure with carry9_3
  sbnd carry9_3
  step_pure with s10_13
  sbnd s10_13
  step_pure [Bnd.and_mask_sub] with t844
  sbnd t844
  step_pure with carry10_3
  sbnd carry10_3
  step_pure with s11_13
  sbnd s11_13
  step_pure [Bnd.and_mask_sub] with t847
  sbnd t847
  step_pure with carry11_3
  sbnd carry11_3
  step_pure [Bnd.and_mask_sub] with t849
  sbnd t849
  step_pure [nswMul] with t850
  sbnd t850
  step_pure [nswMul] with t851
  sbnd t851
  step_pure [nswAdd] with s1_10
  sbnd s1_10
  step_pure [nswMul] with t853
  sbnd t853
  step_pure [nswAdd] with s2_11
  sbnd s2_11
  step_pure [nswMul] with t855
  sbnd t855
  step_pure [nswAdd] with s3_12
  sbnd s3_12
  step_pure [nswMul] with t857
  sbnd t857
  step_pure [nswAdd] with s4_13
  sbnd s4_13
  step_pure [nswMul] with t859
  sbnd t859
  step_pure [nswAdd] with s5_14
  sbnd s5_14
  step_pure [nswAdd] with s0_6
  sbnd s0_6
  step_pure with carry0_3
  sbnd carry0_3
  step_pure [nswAdd] with s1_11
  sbnd s1_11
  step_pure with carry1_3
  sbnd carry1_3
  step_pure [nswAdd] with s2_12
  sbnd s2_12
  step_pure with carry2_3
  sbnd carry2_3
  step_pure [nswAdd] with s3_13
  sbnd s3_13
  step_pure with carry3_3
  sbnd carry3_3
  step_pure [nswAdd] with s4_14
  sbnd s4_14
  step_pure with carry4_3
  sbnd carry4_3
  step_pure [nswAdd] with s5_15
  sbnd s5_15
  step_pure with carry5_3
  sbnd carry5_3
  step_pure [nswAdd] with s6_14
  sbnd s6_14
  step_pure with carry6_4
  sbnd carry6_4
  step_pure [nswAdd] with s7_15
  sbnd s7_15
  step_pure with carry7_4
  sbnd carry7_4
  step_pure [nswAdd] with s8_15
  sbnd s8_15
  step_pure with carry8_4
  sbnd carry8_4
  step_pure [nswAdd] with s9_15
  sbnd s9_15
  step_pure with carry9_4
  sbnd carry9_4
  step_pure [nswAdd] with s10_15
  step_pure with t882
  sbnd t882
  step_pure [nswAdd, nuwAdd] with t883
  exact
    hK _ t841 carry9_3 s10_13 t844 carry10_3 s11_13 t847 carry11_3 t849 t850 t851 s1_10 t853 s2_11
      t855 s3_12 t857 s4_13 t859 s5_14 s0_6 carry0_3 s1_11 carry1_3 s2_12 carry2_3 s3_13 carry3_3
      s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 s7_15 carry7_4 s8_15 carry8_4 s9_15 carry9_4
      s10_15 t882 t883 hArgs (by unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht841 hcarry9_3 hs10_13 ht844 hcarry10_3 hs11_13 ht847 hcarry11_3 ht849 ht850
      ht851 hs1_10 ht853 hs2_11 ht855 hs3_12 ht857 hs4_13 ht859 hs5_14 hs0_6 hcarry0_3 hs1_11
      hcarry1_3 hs2_12 hcarry2_3 hs3_13 hcarry3_3 hs4_14 hcarry4_3 hs5_15 hcarry5_3 hs6_14 hcarry6_4
      hs7_15 hcarry7_4 hs8_15 hcarry8_4 hs9_15 hcarry9_4 hs10_15 ht882 ht883

/-- From `%884`: the limbs packed into four words, stored at `s`. -/
theorem fd_curve25519_scalar_muladd.run884 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_6 s1_11 s2_12 s3_13 s4_14 s5_15 s6_14 s7_15 s8_15 s9_15 s10_15 t883 : BitVec 64}
    (hArgs : E.args =
     (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hwf : S.WF) (hs : Room S.mem s (8 * 32)) (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR : E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 861 := s0_6, rir_reg%
               fd_curve25519_scalar_muladd.hty 863 := s1_11, rir_reg%
               fd_curve25519_scalar_muladd.hty 865 := s2_12, rir_reg%
               fd_curve25519_scalar_muladd.hty 867 := s3_13, rir_reg%
               fd_curve25519_scalar_muladd.hty 869 := s4_14, rir_reg%
               fd_curve25519_scalar_muladd.hty 871 := s5_15, rir_reg%
               fd_curve25519_scalar_muladd.hty 873 := s6_14, rir_reg%
               fd_curve25519_scalar_muladd.hty 875 := s7_15, rir_reg%
               fd_curve25519_scalar_muladd.hty 877 := s8_15, rir_reg%
               fd_curve25519_scalar_muladd.hty 879 := s9_15, rir_reg%
               fd_curve25519_scalar_muladd.hty 881 := s10_15, rir_reg%
     fd_curve25519_scalar_muladd.hty 883 := t883])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫) (t910 : Vector (BitVec 64) 4),
        (hArgs : E'.args =
         (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (ht910 :
            t910 =
              #v[s2_12 <<< 42 &&& 9223367638808264704#64 |||
                  (s1_11 <<< 21 &&& 4398044413952#64 ||| s0_6 &&& 2097151#64) |||
                  s3_13 <<< 63,
                s5_15 <<< 41 &&& 4611683819404132352#64 |||
                  (s4_14 <<< 20 &&& 2199022206976#64 ||| s3_13 >>> 1 &&& 1048575#64) |||
                  s6_14 <<< 62,
                s8_15 <<< 40 &&& 2305841909702066176#64 |||
                  (s7_15 <<< 19 &&& 1099511103488#64 ||| s6_14 >>> 2 &&& 524287#64) |||
                  s9_15 <<< 61,
                s9_15 >>> 3 &&& 262143#64 ||| s10_15 <<< 18 &&& 549755551744#64 ||| t883 <<< 39]) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 912
              { S with mem := S.mem.storeAt s (BitVec.packLanes t910) } >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 884 S >>= g) = K := by
  step_pure [expandOfFn] with t884
  step_pure [expandOfFn, ht884] with t885
  step_pure [expandOfFn, ht885] with t886
  step_pure [expandOfFn, ht886] with t887
  step_pure [expandOfFn, ht887] with t888
  step_pure [expandOfFn] with t889
  step_pure [expandOfFn, ht889] with t890
  step_pure [expandOfFn, ht890] with t891
  step_pure [expandOfFn, ht891] with t892
  step_pure [expandOfFn, ht892] with t893
  step_pure [expandOfFn, ht892] with t894
  step_pure [expandOfFn, ht893, ht894] with t895
  step_pure [expandOfFn, ht895] with t896
  step_pure [expandOfFn] with t897
  step_pure [expandOfFn, ht897] with t898
  step_pure [expandOfFn, ht898] with t899
  step_pure [expandOfFn, ht899] with t900
  step_pure [expandOfFn, ht900] with t901
  step_pure [expandOfFn, ht901] with t902
  step_pure [expandOfFn, ht902, ht888, fd_curve25519_scalar_muladd.disj0,
    fd_curve25519_scalar_muladd.disj1, fd_curve25519_scalar_muladd.disj2] with t903
  step_pure [expandOfFn, ht896, ht903, fd_curve25519_scalar_muladd.disj3,
             fd_curve25519_scalar_muladd.disj4, fd_curve25519_scalar_muladd.disj5,
    fd_curve25519_scalar_muladd.disj6] with t904
  step_pure [expandOfFn] with t905
  step_pure [expandOfFn, ht905] with t906
  step_pure [expandOfFn, ht906] with t907
  step_pure [expandOfFn, ht907] with t908
  step_pure [expandOfFn, ht908] with t909
  step_pure [expandOfFn, ht904, ht909, fd_curve25519_scalar_muladd.disj7,
             fd_curve25519_scalar_muladd.disj8, fd_curve25519_scalar_muladd.disj9,
    fd_curve25519_scalar_muladd.disj10] with t910
  step_store
  subst hS
  exact hK _ t910 hArgs ht910

/-! ### The C values -/

theorem fd_curve25519_scalar_muladd.s0_eq
    {a0 b0 c0 t154 s0 : BitVec 64}
    (hs0 : s0 = c0 + t154)
    (ht154 : t154 = b0 * a0)
    : s0 = (c0 + (a0 * b0)) := by
  subst hs0 ht154
  grind

theorem fd_curve25519_scalar_muladd.s2_eq
    {a0 a1 a2 b0 b1 b2 c2 t158 t159 t160 t161 t162 s2 : BitVec 64}
    (hs2 : s2 = t162 + t159)
    (ht162 : t162 = t161 + c2)
    (ht161 : t161 = t158 + t160)
    (ht158 : t158 = b2 * a0)
    (ht160 : t160 = a2 * b0)
    (ht159 : t159 = b1 * a1)
    : s2 = (((c2 + (a0 * b2)) + (a1 * b1)) + (a2 * b0)) := by
  subst hs2 ht162 ht161 ht158 ht160 ht159
  grind

theorem fd_curve25519_scalar_muladd.s4_eq
    {a0 a1 a2 a4 a3 b0 b1 b2 b3 b4 c4 t168 t169 t170 t171 t172 t173 t174 t175 t176 s4 : BitVec 64}
    (hs4 : s4 = t176 + t169)
    (ht176 : t176 = t175 + c4)
    (ht175 : t175 = t174 + t168)
    (ht174 : t174 = t173 + t172)
    (ht173 : t173 = t171 + t170)
    (ht171 : t171 = a3 * b1)
    (ht170 : t170 = b2 * a2)
    (ht172 : t172 = a4 * b0)
    (ht168 : t168 = b4 * a0)
    (ht169 : t169 = b3 * a1)
    : s4 = (((((c4 + (a0 * b4)) + (a1 * b3)) + (a2 * b2)) + (a3 * b1)) + (a4 * b0)) := by
  subst hs4 ht176 ht175 ht174 ht173 ht171 ht170 ht172 ht168 ht169
  grind

theorem fd_curve25519_scalar_muladd.s6_eq
    {a0 a1 a2 a4 a5 a3 a6 b0 b1 b2 b3 b4 b5 b6 c6 t184 t185 t186 t187 t188 t189 t190 t191 t192 t193
     t194 t195 t196 s6 : BitVec 64}
    (hs6 : s6 = t196 + c6)
    (ht196 : t196 = t195 + t184)
    (ht195 : t195 = t194 + t190)
    (ht194 : t194 = t193 + t187)
    (ht193 : t193 = t192 + t186)
    (ht192 : t192 = t191 + t185)
    (ht191 : t191 = t189 + t188)
    (ht189 : t189 = a5 * b1)
    (ht188 : t188 = a4 * b2)
    (ht185 : t185 = b5 * a1)
    (ht186 : t186 = b4 * a2)
    (ht187 : t187 = b3 * a3)
    (ht190 : t190 = a6 * b0)
    (ht184 : t184 = b6 * a0)
    : s6 =
      (((((((c6 + (a0 * b6)) + (a1 * b5)) + (a2 * b4)) + (a3 * b3)) + (a4 * b2)) + (a5 * b1)) +
      (a6 * b0)) := by
  subst hs6 ht196 ht195 ht194 ht193 ht192 ht191 ht189 ht188 ht185 ht186 ht187 ht190 ht184
  grind

theorem fd_curve25519_scalar_muladd.s8_eq
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 b0 b1 b2 b3 b4 b5 b7 b8 b6 c8 t206 t207 t208 t209 t210 t211 t212
     t213 t214 t215 t216 t217 t218 t219 t220 t221 t222 s8 : BitVec 64}
    (hs8 : s8 = t222 + t208)
    (ht222 : t222 = t221 + t207)
    (ht221 : t221 = t220 + c8)
    (ht220 : t220 = t219 + t206)
    (ht219 : t219 = t218 + t214)
    (ht218 : t218 = t217 + t213)
    (ht217 : t217 = t216 + t212)
    (ht216 : t216 = t215 + t211)
    (ht215 : t215 = t210 + t209)
    (ht210 : t210 = b4 * a4)
    (ht209 : t209 = b5 * a3)
    (ht211 : t211 = b3 * a5)
    (ht212 : t212 = a6 * b2)
    (ht213 : t213 = a7 * b1)
    (ht214 : t214 = a8 * b0)
    (ht206 : t206 = b8 * a0)
    (ht207 : t207 = b7 * a1)
    (ht208 : t208 = b6 * a2)
    : s8 =
      (((((((((c8 + (a0 * b8)) + (a1 * b7)) + (a2 * b6)) + (a3 * b5)) + (a4 * b4)) +
      (a5 * b3)) + (a6 * b2)) + (a7 * b1)) + (a8 * b0)) := by
  subst hs8 ht222 ht221 ht220 ht219 ht218 ht217 ht216 ht215 ht210 ht209 ht211 ht212 ht213 ht214
    ht206 ht207 ht208
  grind

theorem fd_curve25519_scalar_muladd.s10_eq
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 c10 t234 t235 t236 t237
     t238 t239 t240 t241 t242 t243 t244 t245 t246 t247 t248 t249 t250 t251 t252 t253 t254 s10 :
     BitVec 64}
    (hs10 : s10 = t254 + t235)
    (ht254 : t254 = t253 + c10)
    (ht253 : t253 = t252 + t234)
    (ht252 : t252 = t251 + t244)
    (ht251 : t251 = t250 + t243)
    (ht250 : t250 = t249 + t238)
    (ht249 : t249 = t248 + t237)
    (ht248 : t248 = t247 + t236)
    (ht247 : t247 = t246 + t242)
    (ht246 : t246 = t245 + t241)
    (ht245 : t245 = t240 + t239)
    (ht240 : t240 = a6 * b4)
    (ht239 : t239 = b5 * a5)
    (ht241 : t241 = a7 * b3)
    (ht242 : t242 = a8 * b2)
    (ht236 : t236 = b8 * a2)
    (ht237 : t237 = b7 * a3)
    (ht238 : t238 = b6 * a4)
    (ht243 : t243 = a9 * b1)
    (ht244 : t244 = a10 * b0)
    (ht234 : t234 = b10 * a0)
    (ht235 : t235 = b9 * a1)
    : s10 =
      (((((((((((c10 + (a0 * b10)) + (a1 * b9)) + (a2 * b8)) + (a3 * b7)) +
      (a4 * b6)) + (a5 * b5)) + (a6 * b4)) + (a7 * b3)) + (a8 * b2)) + (a9 * b1)) + (a10 * b0)) :=
      by
  subst hs10 ht254 ht253 ht252 ht251 ht250 ht249 ht248 ht247 ht246 ht245 ht240 ht239 ht241 ht242
    ht236 ht237 ht238 ht243 ht244 ht234 ht235
  grind

theorem fd_curve25519_scalar_muladd.s12_eq
    {a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 t268 t269 t270 t271 t272
     t273 t274 t275 t276 t277 t278 t279 t280 t281 t282 t283 t284 t285 t286 t287 s12 : BitVec 64}
    (hs12 : s12 = t287 + t270)
    (ht287 : t287 = t286 + t269)
    (ht286 : t286 = t285 + t277)
    (ht285 : t285 = t284 + t276)
    (ht284 : t284 = t283 + t268)
    (ht283 : t283 = t282 + t278)
    (ht282 : t282 = t281 + t273)
    (ht281 : t281 = t280 + t272)
    (ht280 : t280 = t279 + t271)
    (ht279 : t279 = t275 + t274)
    (ht275 : t275 = a8 * b4)
    (ht274 : t274 = a7 * b5)
    (ht271 : t271 = b8 * a4)
    (ht272 : t272 = b7 * a5)
    (ht273 : t273 = b6 * a6)
    (ht278 : t278 = a11 * b1)
    (ht268 : t268 = b11 * a1)
    (ht276 : t276 = a9 * b3)
    (ht277 : t277 = a10 * b2)
    (ht269 : t269 = b10 * a2)
    (ht270 : t270 = b9 * a3)
    : s12 =
      (((((((((((a1 * b11) + (a2 * b10)) + (a3 * b9)) + (a4 * b8)) + (a5 * b7)) +
      (a6 * b6)) + (a7 * b5)) + (a8 * b4)) + (a9 * b3)) + (a10 * b2)) + (a11 * b1)) := by
  subst hs12 ht287 ht286 ht285 ht284 ht283 ht282 ht281 ht280 ht279 ht275 ht274 ht271 ht272 ht273
    ht278 ht268 ht276 ht277 ht269 ht270
  grind

theorem fd_curve25519_scalar_muladd.s14_eq
    {a4 a5 a3 a6 a7 a8 a10 a11 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 t299 t300 t301 t302 t303 t304 t305
     t306 t307 t308 t309 t310 t311 t312 t313 t314 s14 : BitVec 64}
    (hs14 : s14 = t314 + t301)
    (ht314 : t314 = t313 + t300)
    (ht313 : t313 = t312 + t306)
    (ht312 : t312 = t311 + t305)
    (ht311 : t311 = t310 + t299)
    (ht310 : t310 = t309 + t307)
    (ht309 : t309 = t308 + t304)
    (ht308 : t308 = t303 + t302)
    (ht303 : t303 = b7 * a7)
    (ht302 : t302 = b8 * a6)
    (ht304 : t304 = b6 * a8)
    (ht307 : t307 = a11 * b3)
    (ht299 : t299 = b11 * a3)
    (ht305 : t305 = a9 * b5)
    (ht306 : t306 = a10 * b4)
    (ht300 : t300 = b10 * a4)
    (ht301 : t301 = b9 * a5)
    : s14 =
      (((((((((a3 * b11) + (a4 * b10)) + (a5 * b9)) + (a6 * b8)) + (a7 * b7)) +
      (a8 * b6)) + (a9 * b5)) + (a10 * b4)) + (a11 * b3)) := by
  subst hs14 ht314 ht313 ht312 ht311 ht310 ht309 ht308 ht303 ht302 ht304 ht307 ht299 ht305 ht306
    ht300 ht301
  grind

theorem fd_curve25519_scalar_muladd.s16_eq
    {a5 a6 a7 a8 a10 a11 a9 b5 b7 b8 b6 b9 b10 b11 t324 t325 t326 t327 t328 t329 t330 t331 t332
     t333 t334 t335 s16 : BitVec 64}
    (hs16 : s16 = t335 + t326)
    (ht335 : t335 = t334 + t325)
    (ht334 : t334 = t333 + t329)
    (ht333 : t333 = t332 + t328)
    (ht332 : t332 = t331 + t324)
    (ht331 : t331 = t330 + t327)
    (ht330 : t330 = a11 * b5)
    (ht327 : t327 = b8 * a8)
    (ht324 : t324 = b11 * a5)
    (ht328 : t328 = a9 * b7)
    (ht329 : t329 = a10 * b6)
    (ht325 : t325 = b10 * a6)
    (ht326 : t326 = b9 * a7)
    : s16 =
      (((((((a5 * b11) + (a6 * b10)) + (a7 * b9)) + (a8 * b8)) + (a9 * b7)) + (a10 * b6)) +
      (a11 * b5)) := by
  subst hs16 ht335 ht334 ht333 ht332 ht331 ht330 ht327 ht324 ht328 ht329 ht325 ht326
  grind

theorem fd_curve25519_scalar_muladd.s18_eq
    {a7 a8 a10 a11 a9 b7 b8 b9 b10 b11 t343 t344 t345 t346 t347 t348 t349 t350 s18 : BitVec 64}
    (hs18 : s18 = t350 + t345)
    (ht350 : t350 = t349 + t344)
    (ht349 : t349 = t348 + t346)
    (ht348 : t348 = t343 + t347)
    (ht343 : t343 = b11 * a7)
    (ht347 : t347 = a11 * b7)
    (ht346 : t346 = a10 * b8)
    (ht344 : t344 = b10 * a8)
    (ht345 : t345 = b9 * a9)
    : s18 = (((((a7 * b11) + (a8 * b10)) + (a9 * b9)) + (a10 * b8)) + (a11 * b7)) := by
  subst hs18 ht350 ht349 ht348 ht343 ht347 ht346 ht344 ht345
  grind

theorem fd_curve25519_scalar_muladd.s20_eq
    {a10 a11 a9 b9 b10 b11 t356 t357 t358 t359 s20 : BitVec 64}
    (hs20 : s20 = t358 + t359)
    (ht358 : t358 = t357 + t356)
    (ht357 : t357 = b10 * a10)
    (ht356 : t356 = a9 * b11)
    (ht359 : t359 = b9 * a11)
    : s20 = (((a9 * b11) + (a10 * b10)) + (a11 * b9)) := by
  subst hs20 ht358 ht357 ht356 ht359
  grind

theorem fd_curve25519_scalar_muladd.s22_eq
    {a11 b11 s22 : BitVec 64}
    (hs22 : s22 = b11 * a11)
    : s22 = (a11 * b11) := by
  subst hs22
  grind

theorem fd_curve25519_scalar_muladd.s1_1_eq
    {a0 a1 b0 b1 c1 t156 t157 carry0 t367 s1 s1_1 : BitVec 64}
    (hs1_1 : s1_1 = s1 + carry0)
    (hs1 : s1 = t367 + c1)
    (ht367 : t367 = t156 + t157)
    (ht156 : t156 = b1 * a0)
    (ht157 : t157 = a1 * b0)
    : s1_1 = (((c1 + (a0 * b1)) + (a1 * b0)) + carry0) := by
  subst hs1_1 hs1 ht367 ht156 ht157
  grind

theorem fd_curve25519_scalar_muladd.s3_1_eq
    {a0 a1 a2 a3 b0 b1 b2 b3 c3 t164 t165 t166 t167 carry2 t374 t375 t376 s3 s3_1 : BitVec 64}
    (hs3_1 : s3_1 = s3 + carry2)
    (hs3 : s3 = t376 + c3)
    (ht376 : t376 = t375 + t164)
    (ht375 : t375 = t374 + t167)
    (ht374 : t374 = t166 + t165)
    (ht166 : t166 = b1 * a2)
    (ht165 : t165 = b2 * a1)
    (ht167 : t167 = a3 * b0)
    (ht164 : t164 = b3 * a0)
    : s3_1 = (((((c3 + (a0 * b3)) + (a1 * b2)) + (a2 * b1)) + (a3 * b0)) + carry2) := by
  subst hs3_1 hs3 ht376 ht375 ht374 ht166 ht165 ht167 ht164
  grind

theorem fd_curve25519_scalar_muladd.s5_1_eq
    {a0 a1 a2 a4 a5 a3 b0 b1 b2 b3 b4 b5 c5 t178 t179 t180 t181 t182 t183 carry4 t383 t384 t385
     t386 t387 s5 s5_1 : BitVec 64}
    (hs5_1 : s5_1 = s5 + carry4)
    (hs5 : s5 = t387 + t180)
    (ht387 : t387 = t386 + t179)
    (ht386 : t386 = t385 + c5)
    (ht385 : t385 = t384 + t178)
    (ht384 : t384 = t383 + t183)
    (ht383 : t383 = t182 + t181)
    (ht182 : t182 = a4 * b1)
    (ht181 : t181 = a3 * b2)
    (ht183 : t183 = a5 * b0)
    (ht178 : t178 = b5 * a0)
    (ht179 : t179 = b4 * a1)
    (ht180 : t180 = b3 * a2)
    : s5_1 =
      (((((((c5 + (a0 * b5)) + (a1 * b4)) + (a2 * b3)) + (a3 * b2)) + (a4 * b1)) + (a5 * b0)) +
      carry4) := by
  subst hs5_1 hs5 ht387 ht386 ht385 ht384 ht383 ht182 ht181 ht183 ht178 ht179 ht180
  grind

theorem fd_curve25519_scalar_muladd.s7_1_eq
    {a0 a1 a2 a4 a5 a3 a6 a7 b0 b1 b2 b3 b4 b5 b7 b6 c7 t198 t199 t200 t201 t202 t203 t204 t205
     carry6 t394 t395 t396 t397 t398 t399 t400 s7 s7_1 : BitVec 64}
    (hs7_1 : s7_1 = s7 + carry6)
    (hs7 : s7 = t400 + t199)
    (ht400 : t400 = t399 + c7)
    (ht399 : t399 = t398 + t198)
    (ht398 : t398 = t397 + t205)
    (ht397 : t397 = t396 + t204)
    (ht396 : t396 = t395 + t202)
    (ht395 : t395 = t394 + t201)
    (ht394 : t394 = t200 + t203)
    (ht200 : t200 = b5 * a2)
    (ht203 : t203 = a5 * b2)
    (ht201 : t201 = b4 * a3)
    (ht202 : t202 = b3 * a4)
    (ht204 : t204 = a6 * b1)
    (ht205 : t205 = a7 * b0)
    (ht198 : t198 = b7 * a0)
    (ht199 : t199 = b6 * a1)
    : s7_1 =
      (((((((((c7 + (a0 * b7)) + (a1 * b6)) + (a2 * b5)) + (a3 * b4)) + (a4 * b3)) +
      (a5 * b2)) + (a6 * b1)) + (a7 * b0)) + carry6) := by
  subst hs7_1 hs7 ht400 ht399 ht398 ht397 ht396 ht395 ht394 ht200 ht203 ht201 ht202 ht204 ht205
    ht198 ht199
  grind

theorem fd_curve25519_scalar_muladd.s9_1_eq
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 c9 t224 t225 t226 t227 t228 t229
     t230 t231 t232 t233 carry8 t406 t407 t408 t409 t410 t411 t412 t413 t414 s9 s9_1 : BitVec 64}
    (hs9_1 : s9_1 = s9 + carry8)
    (hs9 : s9 = t414 + c9)
    (ht414 : t414 = t413 + t224)
    (ht413 : t413 = t412 + t233)
    (ht412 : t412 = t411 + t227)
    (ht411 : t411 = t410 + t226)
    (ht410 : t410 = t409 + t225)
    (ht409 : t409 = t408 + t232)
    (ht408 : t408 = t407 + t231)
    (ht407 : t407 = t406 + t230)
    (ht406 : t406 = t229 + t228)
    (ht229 : t229 = b4 * a5)
    (ht228 : t228 = b5 * a4)
    (ht230 : t230 = a6 * b3)
    (ht231 : t231 = a7 * b2)
    (ht232 : t232 = a8 * b1)
    (ht225 : t225 = b8 * a1)
    (ht226 : t226 = b7 * a2)
    (ht227 : t227 = b6 * a3)
    (ht233 : t233 = a9 * b0)
    (ht224 : t224 = b9 * a0)
    : s9_1 =
      (((((((((((c9 + (a0 * b9)) + (a1 * b8)) + (a2 * b7)) + (a3 * b6)) +
      (a4 * b5)) + (a5 * b4)) + (a6 * b3)) + (a7 * b2)) + (a8 * b1)) + (a9 * b0)) + carry8) := by
  subst hs9_1 hs9 ht414 ht413 ht412 ht411 ht410 ht409 ht408 ht407 ht406 ht229 ht228 ht230 ht231
    ht232 ht225 ht226 ht227 ht233 ht224
  grind

theorem fd_curve25519_scalar_muladd.s11_1_eq
    {a0 a1 a2 a4 a5 a3 a6 a7 a8 a10 a11 b0 b1 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 c11 t256 t257 t258
     t259 t260 t261 t262 t263 t264 t265 t266 t267 carry10 t421 t422 t423 t424 t425 t426 t427 t428
     t429 t430 t431 s11 s11_1 : BitVec 64}
    (hs11_1 : s11_1 = s11 + carry10)
    (hs11 : s11 = t431 + t258)
    (ht431 : t431 = t430 + t257)
    (ht430 : t430 = t429 + t266)
    (ht429 : t429 = t428 + t265)
    (ht428 : t428 = t427 + c11)
    (ht427 : t427 = t426 + t256)
    (ht426 : t426 = t425 + t267)
    (ht425 : t425 = t424 + t261)
    (ht424 : t424 = t423 + t260)
    (ht423 : t423 = t422 + t259)
    (ht422 : t422 = t421 + t264)
    (ht421 : t421 = t263 + t262)
    (ht263 : t263 = a7 * b4)
    (ht262 : t262 = a6 * b5)
    (ht264 : t264 = a8 * b3)
    (ht259 : t259 = b8 * a3)
    (ht260 : t260 = b7 * a4)
    (ht261 : t261 = b6 * a5)
    (ht267 : t267 = a11 * b0)
    (ht256 : t256 = b11 * a0)
    (ht265 : t265 = a9 * b2)
    (ht266 : t266 = a10 * b1)
    (ht257 : t257 = b10 * a1)
    (ht258 : t258 = b9 * a2)
    : s11_1 =
      (((((((((((((c11 + (a0 * b11)) + (a1 * b10)) + (a2 * b9)) +
           (a3 * b8)) + (a4 * b7)) + (a5 * b6)) + (a6 * b5)) + (a7 * b4)) +
      (a8 * b3)) + (a9 * b2)) + (a10 * b1)) + (a11 * b0)) + carry10) := by
  subst hs11_1 hs11 ht431 ht430 ht429 ht428 ht427 ht426 ht425 ht424 ht423 ht422 ht421 ht263 ht262
    ht264 ht259 ht260 ht261 ht267 ht256 ht265 ht266 ht257 ht258
  grind

theorem fd_curve25519_scalar_muladd.s13_1_eq
    {a2 a4 a5 a3 a6 a7 a8 a10 a11 b2 a9 b3 b4 b5 b7 b8 b6 b9 b10 b11 t289 t290 t291 t292 t293 t294
     t295 t296 t297 t298 carry12 t437 t438 t439 t440 t441 t442 t443 t444 s13 s13_1 : BitVec 64}
    (hs13_1 : s13_1 = s13 + carry12)
    (hs13 : s13 = t444 + t291)
    (ht444 : t444 = t443 + t290)
    (ht443 : t443 = t442 + t297)
    (ht442 : t442 = t441 + t296)
    (ht441 : t441 = t440 + t289)
    (ht440 : t440 = t439 + t298)
    (ht439 : t439 = t438 + t294)
    (ht438 : t438 = t437 + t293)
    (ht437 : t437 = t292 + t295)
    (ht292 : t292 = b8 * a5)
    (ht295 : t295 = a8 * b5)
    (ht293 : t293 = b7 * a6)
    (ht294 : t294 = b6 * a7)
    (ht298 : t298 = a11 * b2)
    (ht289 : t289 = b11 * a2)
    (ht296 : t296 = a9 * b4)
    (ht297 : t297 = a10 * b3)
    (ht290 : t290 = b10 * a3)
    (ht291 : t291 = b9 * a4)
    : s13_1 =
      (((((((((((a2 * b11) + (a3 * b10)) + (a4 * b9)) + (a5 * b8)) + (a6 * b7)) +
      (a7 * b6)) + (a8 * b5)) + (a9 * b4)) + (a10 * b3)) + (a11 * b2)) + carry12) := by
  subst hs13_1 hs13 ht444 ht443 ht442 ht441 ht440 ht439 ht438 ht437 ht292 ht295 ht293 ht294 ht298
    ht289 ht296 ht297 ht290 ht291
  grind

theorem fd_curve25519_scalar_muladd.s15_1_eq
    {a4 a5 a6 a7 a8 a10 a11 a9 b4 b5 b7 b8 b6 b9 b10 b11 t316 t317 t318 t319 t320 t321 t322 t323
     carry14 t450 t451 t452 t453 t454 t455 s15 s15_1 : BitVec 64}
    (hs15_1 : s15_1 = s15 + carry14)
    (hs15 : s15 = t455 + t318)
    (ht455 : t455 = t454 + t317)
    (ht454 : t454 = t453 + t322)
    (ht453 : t453 = t452 + t321)
    (ht452 : t452 = t451 + t316)
    (ht451 : t451 = t450 + t323)
    (ht450 : t450 = t320 + t319)
    (ht320 : t320 = b7 * a8)
    (ht319 : t319 = b8 * a7)
    (ht323 : t323 = a11 * b4)
    (ht316 : t316 = b11 * a4)
    (ht321 : t321 = a9 * b6)
    (ht322 : t322 = a10 * b5)
    (ht317 : t317 = b10 * a5)
    (ht318 : t318 = b9 * a6)
    : s15_1 =
      (((((((((a4 * b11) + (a5 * b10)) + (a6 * b9)) + (a7 * b8)) + (a8 * b7)) +
      (a9 * b6)) + (a10 * b5)) + (a11 * b4)) + carry14) := by
  subst hs15_1 hs15 ht455 ht454 ht453 ht452 ht451 ht450 ht320 ht319 ht323 ht316 ht321 ht322 ht317
    ht318
  grind

theorem fd_curve25519_scalar_muladd.s17_1_eq
    {a6 a7 a8 a10 a11 a9 b7 b8 b6 b9 b10 b11 t337 t338 t339 t340 t341 t342 carry16 t461 t462 t463
     t464 s17 s17_1 : BitVec 64}
    (hs17_1 : s17_1 = s17 + carry16)
    (hs17 : s17 = t464 + t339)
    (ht464 : t464 = t463 + t338)
    (ht463 : t463 = t462 + t341)
    (ht462 : t462 = t461 + t340)
    (ht461 : t461 = t337 + t342)
    (ht337 : t337 = b11 * a6)
    (ht342 : t342 = a11 * b6)
    (ht340 : t340 = a9 * b8)
    (ht341 : t341 = a10 * b7)
    (ht338 : t338 = b10 * a7)
    (ht339 : t339 = b9 * a8)
    : s17_1 =
      (((((((a6 * b11) + (a7 * b10)) + (a8 * b9)) + (a9 * b8)) + (a10 * b7)) + (a11 * b6)) +
      carry16) := by
  subst hs17_1 hs17 ht464 ht463 ht462 ht461 ht337 ht342 ht340 ht341 ht338 ht339
  grind

theorem fd_curve25519_scalar_muladd.s19_1_eq
    {a8 a10 a11 a9 b8 b9 b10 b11 t352 t353 t354 t355 carry18 t470 t471 s19 s19_1 : BitVec 64}
    (hs19_1 : s19_1 = s19 + carry18)
    (hs19 : s19 = t471 + t354)
    (ht471 : t471 = t470 + t353)
    (ht470 : t470 = t352 + t355)
    (ht352 : t352 = b11 * a8)
    (ht355 : t355 = a11 * b8)
    (ht353 : t353 = b10 * a9)
    (ht354 : t354 = b9 * a10)
    : s19_1 = (((((a8 * b11) + (a9 * b10)) + (a10 * b9)) + (a11 * b8)) + carry18) := by
  subst hs19_1 hs19 ht471 ht470 ht352 ht355 ht353 ht354
  grind

theorem fd_curve25519_scalar_muladd.s21_1_eq
    {a10 a11 b10 b11 t361 t362 s21 carry20 s21_1 : BitVec 64}
    (hs21_1 : s21_1 = s21 + carry20)
    (hs21 : s21 = t362 + t361)
    (ht362 : t362 = b10 * a11)
    (ht361 : t361 = a10 * b11)
    : s21_1 = (((a10 * b11) + (a11 * b10)) + carry20) := by
  subst hs21_1 hs21 ht362 ht361
  grind

theorem fd_curve25519_scalar_muladd.s6_3_eq
    {s6 s18 carry6 carry18 s18_1 carry5 carry17 s18_2 t579 t580 s6_2 s6_3 : BitVec 64}
    (hs6_3 : s6_3 = s6_2 + t579)
    (hs6_2 : s6_2 = t580 - ((BitVec.sshiftRight (s6 + 1048576#64) 21) <<< 21))
    (ht580 : t580 = carry5 + s6)
    (ht579 : t579 = s18_2 * 666643#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry6 : carry6 = BitVec.sshiftRight (s6 + 1048576#64) 21)
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    : s6_3 =
      (((s6 - (carry6 <<< 21)) + carry5) + (((s18 - (carry18 <<< 21)) + carry17) * 666643#64)) := by
  rw [← hcarry6] at hs6_2
  rw [← hcarry18] at hs18_1
  clear hcarry6 hcarry18
  subst hs6_3 hs6_2 ht580 ht579 hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s8_5_eq
    {s8 s18 s20 carry8 s8_1 carry18 s19_1 s18_1 carry20 s20_1 carry7 s8_2 carry17 s18_2 carry19
     s20_2 s19_2 t557 s8_3 t566 s8_4 t585 s8_5 : BitVec 64}
    (hs8_5 : s8_5 = s8_4 + t585)
    (hs8_4 : s8_4 = s8_3 + t566)
    (hs8_3 : s8_3 = s8_2 + t557)
    (hs8_2 : s8_2 = s8_1 + carry7)
    (hs8_1 : s8_1 = s8 - ((BitVec.sshiftRight (s8 + 1048576#64) 21) <<< 21))
    (ht557 : t557 = s20_2 * 666643#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (ht566 : t566 = s19_2 * 470296#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (ht585 : t585 = s18_2 * 654183#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21)
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    : s8_5 =
      (((((s8 - (carry8 <<< 21)) + carry7) + (((s20 - (carry20 <<< 21)) + carry19) *
       666643#64)) + ((s19_1 - (carry19 <<< 21)) * 470296#64)) +
      (((s18 - (carry18 <<< 21)) + carry17) * 654183#64)) := by
  rw [← hcarry8] at hs8_1
  rw [← hcarry20] at hs20_1
  rw [← hcarry19] at hs19_2
  rw [← hcarry18] at hs18_1
  clear hcarry8 hcarry18 hcarry20 hcarry19
  subst hs8_5 hs8_4 hs8_3 hs8_2 hs8_1 ht557 hs20_2 hs20_1 ht566 hs19_2 ht585 hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s10_7_eq
    {s10 s18 s20 s22 carry10 carry18 s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry9 carry17
     s18_2 carry19 s20_2 s19_2 carry21 s22_2 s21_2 t540 t547 t560 t569 t588 t589 t590 t591 t592
     t593 s10_6 s10_7 : BitVec 64}
    (hs10_7 : s10_7 = s10_6 + t588)
    (hs10_6 : s10_6 = t593 + carry9)
    (ht593 : t593 = t592 - ((BitVec.sshiftRight (s10 + 1048576#64) 21) <<< 21))
    (ht592 : t592 = t591 + t569)
    (ht591 : t591 = t590 + t560)
    (ht590 : t590 = t589 + s10)
    (ht589 : t589 = t547 + t540)
    (ht547 : t547 = s21_2 * 470296#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (ht540 : t540 = s22_2 * 666643#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht560 : t560 = s20_2 * 654183#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (ht569 : t569 = s19_2 * 18446744073708553811#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (ht588 : t588 = s18_2 * 136657#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21)
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s10_7 =
      (((((((s10 - (carry10 <<< 21)) + carry9) + (((s22 - (carry22 <<< 21)) +
         carry21) * 666643#64)) + ((s21_1 - (carry21 <<< 21)) * 470296#64)) +
        (((s20 - (carry20 <<< 21)) + carry19) * 654183#64)) -
       ((s19_1 - (carry19 <<< 21)) * 997805#64)) +
      (((s18 - (carry18 <<< 21)) + carry17) * 136657#64)) := by
  rw [← hcarry21] at hs21_2
  rw [← hcarry22] at hs22_1
  rw [← hcarry20] at hs20_1
  rw [← hcarry19] at hs19_2
  rw [← hcarry10] at ht593
  rw [← hcarry18] at hs18_1
  clear hcarry10 hcarry18 hcarry20 hcarry22 hcarry19 hcarry21
  subst hs10_7 hs10_6 ht593 ht592 ht591 ht590 ht589 ht547 hs21_2 ht540 hs22_2 hs22_1 ht560 hs20_2
    hs20_1 ht569 hs19_2 ht588 hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s12_7_eq
    {s12 s20 s22 carry12 s19_1 carry20 s21_1 s20_1 carry22 s22_1 carry11 carry19 s20_2 s19_2
     carry21 s22_2 s21_2 t532 t542 t549 t562 t571 t572 t573 t574 t575 t576 t577 s12_7 : BitVec 64}
    (hs12_7 : s12_7 = t577 + carry11)
    (ht577 : t577 = t576 - ((BitVec.sshiftRight (s12 + 1048576#64) 21) <<< 21))
    (ht576 : t576 = t575 + t571)
    (ht575 : t575 = t574 + t562)
    (ht574 : t574 = t573 + s12)
    (ht573 : t573 = t572 + t549)
    (ht572 : t572 = t542 + t532)
    (ht542 : t542 = s22_2 * 654183#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht532 : t532 = carry22 * 470296#64)
    (ht549 : t549 = s21_2 * 18446744073708553811#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (ht562 : t562 = s20_2 * 136657#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (ht571 : t571 = s19_2 * 18446744073708867715#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s12_7 =
      (((((((s12 - (carry12 <<< 21)) + carry11) + ((0#64 + carry22) * 470296#64)) +
         (((s22 - (carry22 <<< 21)) + carry21) * 654183#64)) -
        ((s21_1 - (carry21 <<< 21)) * 997805#64)) +
       (((s20 - (carry20 <<< 21)) + carry19) * 136657#64)) -
      ((s19_1 - (carry19 <<< 21)) * 683901#64)) := by
  rw [← hcarry22] at hs22_1
  rw [← hcarry21] at hs21_2
  rw [← hcarry20] at hs20_1
  rw [← hcarry19] at hs19_2
  rw [← hcarry12] at ht577
  clear hcarry12 hcarry20 hcarry22 hcarry19 hcarry21
  subst hs12_7 ht577 ht576 ht575 ht574 ht573 ht572 ht542 hs22_2 hs22_1 ht532 ht549 hs21_2 ht562
    hs20_2 hs20_1 ht571 hs19_2
  grind

theorem fd_curve25519_scalar_muladd.s14_5_eq
    {s14 s22 carry14 s21_1 carry22 s22_1 carry13 carry21 s22_2 s21_2 t534 t544 t551 t552 t553 t554
     t555 s14_5 : BitVec 64}
    (hs14_5 : s14_5 = t555 + carry13)
    (ht555 : t555 = t554 - ((BitVec.sshiftRight (s14 + 1048576#64) 21) <<< 21))
    (ht554 : t554 = t553 + t551)
    (ht553 : t553 = t552 + t544)
    (ht552 : t552 = s14 + t534)
    (ht534 : t534 = carry22 * 18446744073708553811#64)
    (ht544 : t544 = s22_2 * 136657#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht551 : t551 = s21_2 * 18446744073708867715#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s14_5 =
      (((((s14 - (carry14 <<< 21)) + carry13) - ((0#64 + carry22) * 997805#64)) +
       (((s22 - (carry22 <<< 21)) + carry21) * 136657#64)) -
      ((s21_1 - (carry21 <<< 21)) * 683901#64)) := by
  rw [← hcarry22] at hs22_1
  rw [← hcarry21] at hs21_2
  rw [← hcarry14] at ht555
  clear hcarry14 hcarry22 hcarry21
  subst hs14_5 ht555 ht554 ht553 ht552 ht534 ht544 hs22_2 hs22_1 ht551 hs21_2
  grind

theorem fd_curve25519_scalar_muladd.s16_3_eq
    {s16 carry16 carry22 carry15 t536 t537 t538 s16_3 : BitVec 64}
    (hs16_3 : s16_3 = t538 + carry15)
    (ht538 : t538 = t537 - ((BitVec.sshiftRight (s16 + 1048576#64) 21) <<< 21))
    (ht537 : t537 = s16 + t536)
    (ht536 : t536 = carry22 * 18446744073708867715#64)
    (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21)
    : s16_3 = (((s16 - (carry16 <<< 21)) + carry15) - ((0#64 + carry22) * 683901#64)) := by
  rw [← hcarry16] at ht538
  clear hcarry16
  subst hs16_3 ht538 ht537 ht536
  grind

theorem fd_curve25519_scalar_muladd.s7_5_eq
    {s18 s7_1 carry18 s19_1 s18_1 carry7 s7_2 carry17 s18_2 carry19 s19_2 t564 s7_3 t583 s7_4
     carry6_1 s7_5 : BitVec 64}
    (hs7_5 : s7_5 = s7_4 + carry6_1)
    (hs7_4 : s7_4 = s7_3 + t583)
    (hs7_3 : s7_3 = s7_2 + t564)
    (hs7_2 : s7_2 = s7_1 - ((BitVec.sshiftRight (s7_1 + 1048576#64) 21) <<< 21))
    (ht564 : t564 = s19_2 * 666643#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (ht583 : t583 = s18_2 * 470296#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    : s7_5 =
      ((((s7_1 - (carry7 <<< 21)) + ((s19_1 - (carry19 <<< 21)) * 666643#64)) +
      (((s18 - (carry18 <<< 21)) + carry17) * 470296#64)) + carry6_1) := by
  rw [← hcarry7] at hs7_2
  rw [← hcarry19] at hs19_2
  rw [← hcarry18] at hs18_1
  clear hcarry18 hcarry7 hcarry19
  subst hs7_5 hs7_4 hs7_3 hs7_2 ht564 hs19_2 ht583 hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s9_7_eq
    {s18 s20 s9_1 carry18 s19_1 s18_1 carry20 s21_1 s20_1 carry9 carry17 s18_2 carry19 s20_2 s19_2
     carry21 s21_2 t546 t559 t568 t587 carry8_1 t604 t605 t606 s9_5 s9_6 s9_7 : BitVec 64}
    (hs9_7 : s9_7 = s9_6 + carry8_1)
    (hs9_6 : s9_6 = s9_5 + t587)
    (hs9_5 : s9_5 = t606 - ((BitVec.sshiftRight (s9_1 + 1048576#64) 21) <<< 21))
    (ht606 : t606 = t605 + t568)
    (ht605 : t605 = t604 + t559)
    (ht604 : t604 = s9_1 + t546)
    (ht546 : t546 = s21_2 * 666643#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (ht559 : t559 = s20_2 * 470296#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (ht568 : t568 = s19_2 * 654183#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (ht587 : t587 = s18_2 * 18446744073708553811#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s9_7 =
      ((((((s9_1 - (carry9 <<< 21)) + ((s21_1 - (carry21 <<< 21)) * 666643#64)) +
         (((s20 - (carry20 <<< 21)) + carry19) * 470296#64)) +
        ((s19_1 - (carry19 <<< 21)) * 654183#64)) -
      (((s18 - (carry18 <<< 21)) + carry17) * 997805#64)) + carry8_1) := by
  rw [← hcarry21] at hs21_2
  rw [← hcarry20] at hs20_1
  rw [← hcarry19] at hs19_2
  rw [← hcarry9] at hs9_5
  rw [← hcarry18] at hs18_1
  clear hcarry18 hcarry20 hcarry9 hcarry19 hcarry21
  subst hs9_7 hs9_6 hs9_5 ht606 ht605 ht604 ht546 hs21_2 ht559 hs20_2 hs20_1 ht568 hs19_2 ht587
    hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s11_9_eq
    {s18 s20 s22 s11_1 carry18 s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry11 carry17 s18_2
     carry19 s20_2 s19_2 carry21 s22_2 s21_2 t531 t541 t548 t561 t570 t596 carry10_1 t614 t615 t616
     t617 t618 t619 s11_8 s11_9 : BitVec 64}
    (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hs11_8 : s11_8 = t619 - ((BitVec.sshiftRight (s11_1 + 1048576#64) 21) <<< 21))
    (ht619 : t619 = t618 + s11_1)
    (ht618 : t618 = t617 + t596)
    (ht617 : t617 = t616 + t570)
    (ht616 : t616 = t615 + t561)
    (ht615 : t615 = t614 + t548)
    (ht614 : t614 = t541 + t531)
    (ht541 : t541 = s22_2 * 470296#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht531 : t531 = carry22 * 666643#64)
    (ht548 : t548 = s21_2 * 654183#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (ht561 : t561 = s20_2 * 18446744073708553811#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (ht570 : t570 = s19_2 * 136657#64)
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (ht596 : t596 = s18_2 * 18446744073708867715#64)
    (hs18_2 : s18_2 = carry17 + s18_1)
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s11_9 =
      ((((((((s11_1 - (carry11 <<< 21)) + ((0#64 + carry22) * 666643#64)) +
           (((s22 - (carry22 <<< 21)) + carry21) * 470296#64)) +
          ((s21_1 - (carry21 <<< 21)) * 654183#64)) -
         (((s20 - (carry20 <<< 21)) + carry19) * 997805#64)) +
        ((s19_1 - (carry19 <<< 21)) * 136657#64)) -
      (((s18 - (carry18 <<< 21)) + carry17) * 683901#64)) + carry10_1) := by
  rw [← hcarry22] at hs22_1
  rw [← hcarry21] at hs21_2
  rw [← hcarry20] at hs20_1
  rw [← hcarry19] at hs19_2
  rw [← hcarry18] at hs18_1
  rw [← hcarry11] at hs11_8
  clear hcarry18 hcarry20 hcarry22 hcarry11 hcarry19 hcarry21
  subst hs11_9 hs11_8 ht619 ht618 ht617 ht616 ht615 ht614 ht541 hs22_2 hs22_1 ht531 ht548 hs21_2
    ht561 hs20_2 hs20_1 ht570 hs19_2 ht596 hs18_2 hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s13_7_eq
    {s20 s22 s13_1 carry20 s21_1 s20_1 carry22 s22_1 carry13 carry19 s20_2 carry21 s22_2 s21_2 t533
     t543 t550 t563 carry12_1 t625 t626 t627 t628 s13_6 s13_7 : BitVec 64}
    (hs13_7 : s13_7 = s13_6 + carry12_1)
    (hs13_6 : s13_6 = t628 - ((BitVec.sshiftRight (s13_1 + 1048576#64) 21) <<< 21))
    (ht628 : t628 = t627 + s13_1)
    (ht627 : t627 = t626 + t563)
    (ht626 : t626 = t625 + t550)
    (ht625 : t625 = t543 + t533)
    (ht543 : t543 = s22_2 * 18446744073708553811#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht533 : t533 = carry22 * 654183#64)
    (ht550 : t550 = s21_2 * 136657#64)
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (ht563 : t563 = s20_2 * 18446744073708867715#64)
    (hs20_2 : s20_2 = carry19 + s20_1)
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    : s13_7 =
      ((((((s13_1 - (carry13 <<< 21)) + ((0#64 + carry22) * 654183#64)) -
         (((s22 - (carry22 <<< 21)) + carry21) * 997805#64)) +
        ((s21_1 - (carry21 <<< 21)) * 136657#64)) -
      (((s20 - (carry20 <<< 21)) + carry19) * 683901#64)) + carry12_1) := by
  rw [← hcarry22] at hs22_1
  rw [← hcarry21] at hs21_2
  rw [← hcarry20] at hs20_1
  rw [← hcarry13] at hs13_6
  clear hcarry20 hcarry22 hcarry13 hcarry21
  subst hs13_7 hs13_6 ht628 ht627 ht626 ht625 ht543 hs22_2 hs22_1 ht533 ht550 hs21_2 ht563 hs20_2
    hs20_1
  grind

theorem fd_curve25519_scalar_muladd.s15_5_eq
    {s22 s15_1 carry22 s22_1 carry15 carry21 s22_2 t535 t545 carry14_1 t635 t636 s15_4 s15_5 :
     BitVec 64}
    (hs15_5 : s15_5 = s15_4 + carry14_1)
    (hs15_4 : s15_4 = t636 - ((BitVec.sshiftRight (s15_1 + 1048576#64) 21) <<< 21))
    (ht636 : t636 = t635 + s15_1)
    (ht635 : t635 = t545 + t535)
    (ht545 : t545 = s22_2 * 18446744073708867715#64)
    (hs22_2 : s22_2 = carry21 + s22_1)
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (ht535 : t535 = carry22 * 136657#64)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21)
    : s15_5 =
      ((((s15_1 - (carry15 <<< 21)) + ((0#64 + carry22) * 136657#64)) -
      (((s22 - (carry22 <<< 21)) + carry21) * 683901#64)) + carry14_1) := by
  rw [← hcarry22] at hs22_1
  rw [← hcarry15] at hs15_4
  clear hcarry22 hcarry15
  subst hs15_5 hs15_4 ht636 ht635 ht545 hs22_2 hs22_1 ht535
  grind

theorem fd_curve25519_scalar_muladd.s0_2_eq
    {s0 carry0 s0_1 s12_7 carry12_1 s12_8 carry11_1 s12_9 t720 s0_2 : BitVec 64}
    (hs0_2 : s0_2 = t720 + s0_1)
    (ht720 : t720 = s12_9 * 666643#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (hs0_1 : s0_1 = s0 - ((BitVec.sshiftRight (s0 + 1048576#64) 21) <<< 21))
    (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    : s0_2 = ((s0 - (carry0 <<< 21)) + (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 666643#64)) :=
      by
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry0] at hs0_1
  clear hcarry0 hcarry12_1
  subst hs0_2 ht720 hs12_9 hs12_8 hs0_1
  grind

theorem fd_curve25519_scalar_muladd.s2_5_eq
    {s2 carry2 s2_1 carry1 s2_2 s14_5 s12_7 carry12_1 s13_7 s12_8 carry14_1 s14_6 carry11_1 s12_9
     carry13_1 s14_7 s13_8 t705 t714 t723 t724 t725 s2_5 : BitVec 64}
    (hs2_5 : s2_5 = t725 + t714)
    (ht725 : t725 = t724 + t705)
    (ht724 : t724 = s2_2 + t723)
    (hs2_2 : s2_2 = s2_1 + carry1)
    (hs2_1 : s2_1 = s2 - ((BitVec.sshiftRight (s2 + 1048576#64) 21) <<< 21))
    (ht723 : t723 = s12_9 * 654183#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (ht705 : t705 = s14_7 * 666643#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (ht714 : t714 = s13_8 * 470296#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    : s2_5 =
      (((((s2 - (carry2 <<< 21)) + carry1) + (((s14_5 - (carry14_1 <<< 21)) +
       carry13_1) * 666643#64)) + ((s13_7 - (carry13_1 <<< 21)) * 470296#64)) +
      (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 654183#64)) := by
  rw [← hcarry2] at hs2_1
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry14_1] at hs14_6
  rw [← hcarry13_1] at hs13_8
  clear hcarry2 hcarry12_1 hcarry14_1 hcarry13_1
  subst hs2_5 ht725 ht724 hs2_2 hs2_1 ht723 hs12_9 hs12_8 ht705 hs14_7 hs14_6 ht714 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s4_7_eq
    {s4 carry4 s4_1 carry3 s4_2 s16_3 s14_5 s12_7 carry12_1 s13_7 s12_8 carry14_1 s15_5 s14_6
     carry16_1 s16_4 carry11_1 s12_9 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t682 s4_3 t695
     s4_4 t707 t716 t728 t729 t730 s4_7 : BitVec 64}
    (hs4_7 : s4_7 = t730 + t716)
    (ht730 : t730 = t729 + t707)
    (ht729 : t729 = s4_4 + t728)
    (hs4_4 : s4_4 = s4_3 + t695)
    (hs4_3 : s4_3 = s4_2 + t682)
    (hs4_2 : s4_2 = s4_1 + carry3)
    (hs4_1 : s4_1 = s4 - ((BitVec.sshiftRight (s4 + 1048576#64) 21) <<< 21))
    (ht682 : t682 = s16_5 * 666643#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (ht695 : t695 = s15_6 * 470296#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (ht728 : t728 = s12_9 * 136657#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (ht707 : t707 = s14_7 * 654183#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (ht716 : t716 = s13_8 * 18446744073708553811#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s4_7 =
      (((((((s4 - (carry4 <<< 21)) + carry3) + (((s16_3 - (carry16_1 <<< 21)) +
         carry15_1) * 666643#64)) + ((s15_5 - (carry15_1 <<< 21)) * 470296#64)) +
        (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 654183#64)) -
       ((s13_7 - (carry13_1 <<< 21)) * 997805#64)) +
      (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 136657#64)) := by
  rw [← hcarry4] at hs4_1
  rw [← hcarry16_1] at hs16_4
  rw [← hcarry15_1] at hs15_6
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry14_1] at hs14_6
  rw [← hcarry13_1] at hs13_8
  clear hcarry4 hcarry12_1 hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  subst hs4_7 ht730 ht729 hs4_4 hs4_3 hs4_2 hs4_1 ht682 hs16_5 hs16_4 ht695 hs15_6 ht728 hs12_9
    hs12_8 ht707 hs14_7 hs14_6 ht716 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s6_9_eq
    {s17_1 carry17 s17_2 s16_3 s14_5 s6_3 carry6_1 s6_4 s13_7 carry14_1 s15_5 s14_6 carry16_1 s17_3
     s16_4 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t671 s6_5 t686 s6_6 t699 s6_7 t709 s6_8 t718
     s6_9 : BitVec 64}
    (hs6_9 : s6_9 = s6_8 + t718)
    (hs6_8 : s6_8 = s6_7 + t709)
    (hs6_7 : s6_7 = s6_6 + t699)
    (hs6_6 : s6_6 = s6_5 + t686)
    (hs6_5 : s6_5 = s6_4 + t671)
    (hs6_4 : s6_4 = s6_3 - ((BitVec.sshiftRight (s6_3 + 1048576#64) 21) <<< 21))
    (ht671 : t671 = s17_3 * 470296#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (ht686 : t686 = s16_5 * 654183#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (ht699 : t699 = s15_6 * 18446744073708553811#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (ht709 : t709 = s14_7 * 136657#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (ht718 : t718 = s13_8 * 18446744073708867715#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s6_9 =
      ((((((s6_3 - (carry6_1 <<< 21)) + (((s17_1 - (carry17 <<< 21)) + carry16_1) *
         470296#64)) + (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 654183#64)) -
        ((s15_5 - (carry15_1 <<< 21)) * 997805#64)) +
       (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 136657#64)) -
      ((s13_7 - (carry13_1 <<< 21)) * 683901#64)) := by
  rw [← hcarry6_1] at hs6_4
  rw [← hcarry17] at hs17_2
  rw [← hcarry16_1] at hs16_4
  rw [← hcarry15_1] at hs15_6
  rw [← hcarry14_1] at hs14_6
  rw [← hcarry13_1] at hs13_8
  clear hcarry17 hcarry6_1 hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  subst hs6_9 hs6_8 hs6_7 hs6_6 hs6_5 hs6_4 ht671 hs17_3 hs17_2 ht686 hs16_5 hs16_4 ht699 hs15_6
    ht709 hs14_7 hs14_6 ht718 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s8_10_eq
    {s17_1 carry17 s17_2 s16_3 s8_5 carry8_1 s8_6 s15_5 carry16_1 s17_3 s16_4 carry7_1 s8_7
     carry15_1 s16_5 s15_6 t675 s8_8 t690 s8_9 t703 s8_10 : BitVec 64}
    (hs8_10 : s8_10 = s8_9 + t703)
    (hs8_9 : s8_9 = s8_8 + t690)
    (hs8_8 : s8_8 = s8_7 + t675)
    (hs8_7 : s8_7 = s8_6 + carry7_1)
    (hs8_6 : s8_6 = s8_5 - ((BitVec.sshiftRight (s8_5 + 1048576#64) 21) <<< 21))
    (ht675 : t675 = s17_3 * 18446744073708553811#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (ht690 : t690 = s16_5 * 136657#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (ht703 : t703 = s15_6 * 18446744073708867715#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s8_10 =
      (((((s8_5 - (carry8_1 <<< 21)) + carry7_1) -
        (((s17_1 - (carry17 <<< 21)) + carry16_1) * 997805#64)) +
       (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 136657#64)) -
      ((s15_5 - (carry15_1 <<< 21)) * 683901#64)) := by
  rw [← hcarry8_1] at hs8_6
  rw [← hcarry17] at hs17_2
  rw [← hcarry16_1] at hs16_4
  rw [← hcarry15_1] at hs15_6
  clear hcarry17 hcarry8_1 hcarry16_1 hcarry15_1
  subst hs8_10 hs8_9 hs8_8 hs8_7 hs8_6 ht675 hs17_3 hs17_2 ht690 hs16_5 hs16_4 ht703 hs15_6
  grind

theorem fd_curve25519_scalar_muladd.s10_10_eq
    {s17_1 carry17 s17_2 s10_7 carry10_1 carry16_1 s17_3 carry9_1 t678 t679 t680 s10_10 : BitVec 64}
    (hs10_10 : s10_10 = t680 - ((BitVec.sshiftRight (s10_7 + 1048576#64) 21) <<< 21))
    (ht680 : t680 = t679 + carry9_1)
    (ht679 : t679 = s10_7 + t678)
    (ht678 : t678 = s17_3 * 18446744073708867715#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21)
    : s10_10 =
      (((s10_7 - (carry10_1 <<< 21)) + carry9_1) -
      (((s17_1 - (carry17 <<< 21)) + carry16_1) * 683901#64)) := by
  rw [← hcarry17] at hs17_2
  rw [← hcarry10_1] at hs10_10
  clear hcarry17 hcarry10_1
  subst hs10_10 ht680 ht679 ht678 hs17_3 hs17_2
  grind

theorem fd_curve25519_scalar_muladd.s1_5_eq
    {s1_1 carry1 s1_2 s12_7 carry12_1 s13_7 s12_8 carry11_1 s12_9 carry13_1 s13_8 t713 t722
     carry0_1 t735 s1_4 s1_5 : BitVec 64}
    (hs1_5 : s1_5 = s1_4 + carry0_1)
    (hs1_4 : s1_4 = t735 + t713)
    (ht735 : t735 = s1_2 + t722)
    (hs1_2 : s1_2 = s1_1 - ((BitVec.sshiftRight (s1_1 + 1048576#64) 21) <<< 21))
    (ht722 : t722 = s12_9 * 470296#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (ht713 : t713 = s13_8 * 666643#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    : s1_5 =
      ((((s1_1 - (carry1 <<< 21)) + ((s13_7 - (carry13_1 <<< 21)) * 666643#64)) +
      (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 470296#64)) + carry0_1) := by
  rw [← hcarry1] at hs1_2
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry13_1] at hs13_8
  clear hcarry1 hcarry12_1 hcarry13_1
  subst hs1_5 hs1_4 ht735 hs1_2 ht722 hs12_9 hs12_8 ht713 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s3_7_eq
    {s3_1 carry3 s3_2 s14_5 s12_7 carry12_1 s13_7 s12_8 carry14_1 s15_5 s14_6 carry11_1 s12_9
     carry13_1 s14_7 s13_8 carry15_1 s15_6 t693 s3_3 t706 t715 t727 carry2_1 t742 t743 s3_6 s3_7 :
     BitVec 64}
    (hs3_7 : s3_7 = s3_6 + carry2_1)
    (hs3_6 : s3_6 = t743 + t715)
    (ht743 : t743 = t742 + t706)
    (ht742 : t742 = s3_3 + t727)
    (hs3_3 : s3_3 = s3_2 + t693)
    (hs3_2 : s3_2 = s3_1 - ((BitVec.sshiftRight (s3_1 + 1048576#64) 21) <<< 21))
    (ht693 : t693 = s15_6 * 666643#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (ht727 : t727 = s12_9 * 18446744073708553811#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (ht706 : t706 = s14_7 * 470296#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (ht715 : t715 = s13_8 * 654183#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry3 : carry3 = BitVec.sshiftRight (s3_1 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s3_7 =
      ((((((s3_1 - (carry3 <<< 21)) + ((s15_5 - (carry15_1 <<< 21)) * 666643#64)) +
         (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 470296#64)) +
        ((s13_7 - (carry13_1 <<< 21)) * 654183#64)) -
      (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 997805#64)) + carry2_1) := by
  rw [← hcarry3] at hs3_2
  rw [← hcarry15_1] at hs15_6
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry14_1] at hs14_6
  rw [← hcarry13_1] at hs13_8
  clear hcarry3 hcarry12_1 hcarry14_1 hcarry13_1 hcarry15_1
  subst hs3_7 hs3_6 ht743 ht742 hs3_3 hs3_2 ht693 hs15_6 ht727 hs12_9 hs12_8 ht706 hs14_7 hs14_6
    ht715 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s5_9_eq
    {s5_1 s17_1 carry5 s5_2 carry17 s17_2 s16_3 s14_5 s12_7 carry12_1 s13_7 s12_8 carry14_1 s15_5
     s14_6 carry16_1 s17_3 s16_4 carry11_1 s12_9 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t669
     s5_3 t684 s5_4 t697 s5_5 t708 t717 t732 carry4_1 t749 t750 s5_8 s5_9 : BitVec 64}
    (hs5_9 : s5_9 = s5_8 + carry4_1)
    (hs5_8 : s5_8 = t750 + t717)
    (ht750 : t750 = t749 + t708)
    (ht749 : t749 = s5_5 + t732)
    (hs5_5 : s5_5 = s5_4 + t697)
    (hs5_4 : s5_4 = s5_3 + t684)
    (hs5_3 : s5_3 = s5_2 + t669)
    (hs5_2 : s5_2 = s5_1 - ((BitVec.sshiftRight (s5_1 + 1048576#64) 21) <<< 21))
    (ht669 : t669 = s17_3 * 666643#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (ht684 : t684 = s16_5 * 470296#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (ht697 : t697 = s15_6 * 654183#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (ht732 : t732 = s12_9 * 18446744073708867715#64)
    (hs12_9 : s12_9 = carry11_1 + s12_8)
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight (s12_7 + 1048576#64) 21) <<< 21))
    (ht708 : t708 = s14_7 * 18446744073708553811#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (ht717 : t717 = s13_8 * 136657#64)
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21)
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s5_9 =
      ((((((((s5_1 - (carry5 <<< 21)) + (((s17_1 - (carry17 <<< 21)) +
            carry16_1) * 666643#64)) + (((s16_3 - (carry16_1 <<< 21)) +
          carry15_1) * 470296#64)) + ((s15_5 - (carry15_1 <<< 21)) * 654183#64)) -
         (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 997805#64)) +
        ((s13_7 - (carry13_1 <<< 21)) * 136657#64)) -
      (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 683901#64)) + carry4_1) := by
  rw [← hcarry5] at hs5_2
  rw [← hcarry17] at hs17_2
  rw [← hcarry16_1] at hs16_4
  rw [← hcarry15_1] at hs15_6
  rw [← hcarry12_1] at hs12_8
  rw [← hcarry14_1] at hs14_6
  rw [← hcarry13_1] at hs13_8
  clear hcarry5 hcarry17 hcarry12_1 hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  subst hs5_9 hs5_8 ht750 ht749 hs5_5 hs5_4 hs5_3 hs5_2 ht669 hs17_3 hs17_2 ht684 hs16_5 hs16_4
    ht697 hs15_6 ht732 hs12_9 hs12_8 ht708 hs14_7 hs14_6 ht717 hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s7_11_eq
    {s17_1 carry17 s17_2 s16_3 s14_5 s7_5 carry14_1 s15_5 s14_6 carry16_1 s17_3 s16_4 carry7_1 s7_6
     carry13_1 s14_7 carry15_1 s16_5 s15_6 t673 s7_7 t688 s7_8 t701 s7_9 t711 s7_10 carry6_2
     s7_11 : BitVec 64}
    (hs7_11 : s7_11 = s7_10 + carry6_2)
    (hs7_10 : s7_10 = s7_9 + t711)
    (hs7_9 : s7_9 = s7_8 + t701)
    (hs7_8 : s7_8 = s7_7 + t688)
    (hs7_7 : s7_7 = s7_6 + t673)
    (hs7_6 : s7_6 = s7_5 - ((BitVec.sshiftRight (s7_5 + 1048576#64) 21) <<< 21))
    (ht673 : t673 = s17_3 * 654183#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (ht688 : t688 = s16_5 * 18446744073708553811#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (ht701 : t701 = s15_6 * 136657#64)
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (ht711 : t711 = s14_7 * 18446744073708867715#64)
    (hs14_7 : s14_7 = carry13_1 + s14_6)
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    : s7_11 =
      ((((((s7_5 - (carry7_1 <<< 21)) + (((s17_1 - (carry17 <<< 21)) + carry16_1) *
         654183#64)) - (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 997805#64)) +
        ((s15_5 - (carry15_1 <<< 21)) * 136657#64)) -
      (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 683901#64)) + carry6_2) := by
  rw [← hcarry7_1] at hs7_6
  rw [← hcarry17] at hs17_2
  rw [← hcarry16_1] at hs16_4
  rw [← hcarry15_1] at hs15_6
  rw [← hcarry14_1] at hs14_6
  clear hcarry17 hcarry14_1 hcarry16_1 hcarry7_1 hcarry15_1
  subst hs7_11 hs7_10 hs7_9 hs7_8 hs7_7 hs7_6 ht673 hs17_3 hs17_2 ht688 hs16_5 hs16_4 ht701 hs15_6
    ht711 hs14_7 hs14_6
  grind

theorem fd_curve25519_scalar_muladd.s9_11_eq
    {s17_1 carry17 s17_2 s16_3 s9_7 carry16_1 s17_3 s16_4 carry9_1 carry15_1 s16_5 t677 t692
     carry8_2 t761 s9_9 s9_10 s9_11 : BitVec 64}
    (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs9_10 : s9_10 = s9_9 + t692)
    (hs9_9 : s9_9 = t761 - ((BitVec.sshiftRight (s9_7 + 1048576#64) 21) <<< 21))
    (ht761 : t761 = t677 + s9_7)
    (ht677 : t677 = s17_3 * 136657#64)
    (hs17_3 : s17_3 = carry16_1 + s17_2)
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (ht692 : t692 = s16_5 * 18446744073708867715#64)
    (hs16_5 : s16_5 = carry15_1 + s16_4)
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21)
    : s9_11 =
      ((((s9_7 - (carry9_1 <<< 21)) + (((s17_1 - (carry17 <<< 21)) + carry16_1) *
      136657#64)) - (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 683901#64)) + carry8_2) := by
  rw [← hcarry17] at hs17_2
  rw [← hcarry9_1] at hs9_9
  rw [← hcarry16_1] at hs16_4
  clear hcarry17 hcarry16_1 hcarry9_1
  subst hs9_11 hs9_10 hs9_9 ht761 ht677 hs17_3 hs17_2 ht692 hs16_5 hs16_4
  grind

theorem fd_curve25519_scalar_muladd.s11_11_eq
    {s11_9 carry11_1 s11_10 carry10_2 s11_11 : BitVec 64}
    (hs11_11 : s11_11 = s11_10 + carry10_2)
    (hs11_10 : s11_10 = s11_9 - ((BitVec.sshiftRight (s11_9 + 1048576#64) 21) <<< 21))
    (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21)
    : s11_11 = ((s11_9 - (carry11_1 <<< 21)) + carry10_2) := by
  rw [← hcarry11_1] at hs11_10
  clear hcarry11_1
  subst hs11_11 hs11_10
  grind

theorem fd_curve25519_scalar_muladd.s0_4_eq
    {s0_2 carry0_1 s0_3 carry11_2 t796 s0_4 : BitVec 64}
    (hs0_4 : s0_4 = s0_3 + t796)
    (hs0_3 : s0_3 = s0_2 - ((BitVec.sshiftRight (s0_2 + 1048576#64) 21) <<< 21))
    (ht796 : t796 = carry11_2 * 666643#64)
    (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21)
    : s0_4 = ((s0_2 - (carry0_1 <<< 21)) + ((0#64 + carry11_2) * 666643#64)) := by
  rw [← hcarry0_1] at hs0_3
  clear hcarry0_1
  subst hs0_4 hs0_3 ht796
  grind

theorem fd_curve25519_scalar_muladd.s1_8_eq
    {s1_5 carry1_1 carry11_2 t798 carry0_2 t804 s1_7 s1_8 : BitVec 64}
    (hs1_8 : s1_8 = s1_7 + carry0_2)
    (hs1_7 : s1_7 = t804 - ((BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21))
    (ht804 : t804 = s1_5 + t798)
    (ht798 : t798 = carry11_2 * 470296#64)
    (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21)
    : s1_8 = (((s1_5 - (carry1_1 <<< 21)) + ((0#64 + carry11_2) * 470296#64)) + carry0_2) := by
  rw [← hcarry1_1] at hs1_7
  clear hcarry1_1
  subst hs1_8 hs1_7 ht804 ht798
  grind

theorem fd_curve25519_scalar_muladd.s2_9_eq
    {s2_5 carry2_1 carry1_1 carry11_2 t799 carry1_2 t809 t810 s2_8 s2_9 : BitVec 64}
    (hs2_9 : s2_9 = s2_8 + carry1_2)
    (hs2_8 : s2_8 = t810 + carry1_1)
    (ht810 : t810 = t809 - ((BitVec.sshiftRight (s2_5 + 1048576#64) 21) <<< 21))
    (ht809 : t809 = s2_5 + t799)
    (ht799 : t799 = carry11_2 * 654183#64)
    (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21)
    : s2_9 =
      ((((s2_5 - (carry2_1 <<< 21)) + carry1_1) + ((0#64 + carry11_2) * 654183#64)) + carry1_2) :=
      by
  rw [← hcarry2_1] at ht810
  clear hcarry2_1
  subst hs2_9 hs2_8 ht810 ht809 ht799
  grind

theorem fd_curve25519_scalar_muladd.s3_10_eq
    {s3_7 carry3_1 carry11_2 t800 carry2_2 t815 s3_9 s3_10 : BitVec 64}
    (hs3_10 : s3_10 = s3_9 + carry2_2)
    (hs3_9 : s3_9 = t815 - ((BitVec.sshiftRight (s3_7 + 1048576#64) 21) <<< 21))
    (ht815 : t815 = s3_7 + t800)
    (ht800 : t800 = carry11_2 * 18446744073708553811#64)
    (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21)
    : s3_10 = (((s3_7 - (carry3_1 <<< 21)) - ((0#64 + carry11_2) * 997805#64)) + carry2_2) := by
  rw [← hcarry3_1] at hs3_9
  clear hcarry3_1
  subst hs3_10 hs3_9 ht815 ht800
  grind

theorem fd_curve25519_scalar_muladd.s4_11_eq
    {s4_7 carry4_1 carry3_1 carry11_2 t801 carry3_2 t820 t821 s4_10 s4_11 : BitVec 64}
    (hs4_11 : s4_11 = s4_10 + carry3_2)
    (hs4_10 : s4_10 = t821 + carry3_1)
    (ht821 : t821 = t820 - ((BitVec.sshiftRight (s4_7 + 1048576#64) 21) <<< 21))
    (ht820 : t820 = s4_7 + t801)
    (ht801 : t801 = carry11_2 * 136657#64)
    (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21)
    : s4_11 =
      ((((s4_7 - (carry4_1 <<< 21)) + carry3_1) + ((0#64 + carry11_2) * 136657#64)) + carry3_2) :=
      by
  rw [← hcarry4_1] at ht821
  clear hcarry4_1
  subst hs4_11 hs4_10 ht821 ht820 ht801
  grind

theorem fd_curve25519_scalar_muladd.s5_12_eq
    {s5_9 carry5_1 carry11_2 t802 carry4_2 t826 s5_11 s5_12 : BitVec 64}
    (hs5_12 : s5_12 = s5_11 + carry4_2)
    (hs5_11 : s5_11 = t826 - ((BitVec.sshiftRight (s5_9 + 1048576#64) 21) <<< 21))
    (ht826 : t826 = s5_9 + t802)
    (ht802 : t802 = carry11_2 * 18446744073708867715#64)
    (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21)
    : s5_12 = (((s5_9 - (carry5_1 <<< 21)) - ((0#64 + carry11_2) * 683901#64)) + carry4_2) := by
  rw [← hcarry5_1] at hs5_11
  clear hcarry5_1
  subst hs5_12 hs5_11 ht826 ht802
  grind

theorem fd_curve25519_scalar_muladd.s6_12_eq
    {s6_9 carry6_2 s6_10 carry5_1 s6_11 carry5_2 s6_12 : BitVec 64}
    (hs6_12 : s6_12 = s6_11 + carry5_2)
    (hs6_11 : s6_11 = s6_10 + carry5_1)
    (hs6_10 : s6_10 = s6_9 - ((BitVec.sshiftRight (s6_9 + 1048576#64) 21) <<< 21))
    (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21)
    : s6_12 = (((s6_9 - (carry6_2 <<< 21)) + carry5_1) + carry5_2) := by
  rw [← hcarry6_2] at hs6_10
  clear hcarry6_2
  subst hs6_12 hs6_11 hs6_10
  grind

theorem fd_curve25519_scalar_muladd.s7_13_eq
    {s7_11 carry7_2 s7_12 carry6_3 s7_13 : BitVec 64}
    (hs7_13 : s7_13 = carry6_3 + s7_12)
    (hs7_12 : s7_12 = s7_11 - ((BitVec.sshiftRight (s7_11 + 1048576#64) 21) <<< 21))
    (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21)
    : s7_13 = ((s7_11 - (carry7_2 <<< 21)) + carry6_3) := by
  rw [← hcarry7_2] at hs7_12
  clear hcarry7_2
  subst hs7_13 hs7_12
  grind

theorem fd_curve25519_scalar_muladd.s8_13_eq
    {s8_10 carry8_2 s8_11 carry7_2 s8_12 carry7_3 s8_13 : BitVec 64}
    (hs8_13 : s8_13 = s8_12 + carry7_3)
    (hs8_12 : s8_12 = s8_11 + carry7_2)
    (hs8_11 : s8_11 = s8_10 - ((BitVec.sshiftRight (s8_10 + 1048576#64) 21) <<< 21))
    (hcarry8_2 : carry8_2 = BitVec.sshiftRight (s8_10 + 1048576#64) 21)
    : s8_13 = (((s8_10 - (carry8_2 <<< 21)) + carry7_2) + carry7_3) := by
  rw [← hcarry8_2] at hs8_11
  clear hcarry8_2
  subst hs8_13 hs8_12 hs8_11
  grind

theorem fd_curve25519_scalar_muladd.s9_13_eq
    {s9_11 carry9_2 s9_12 carry8_3 s9_13 : BitVec 64}
    (hs9_13 : s9_13 = carry8_3 + s9_12)
    (hs9_12 : s9_12 = s9_11 - ((BitVec.sshiftRight (s9_11 + 1048576#64) 21) <<< 21))
    (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21)
    : s9_13 = ((s9_11 - (carry9_2 <<< 21)) + carry8_3) := by
  rw [← hcarry9_2] at hs9_12
  clear hcarry9_2
  subst hs9_13 hs9_12
  grind

theorem fd_curve25519_scalar_muladd.s10_13_eq
    {s10_10 carry10_2 s10_11 carry9_2 s10_12 carry9_3 s10_13 : BitVec 64}
    (hs10_13 : s10_13 = s10_12 + carry9_3)
    (hs10_12 : s10_12 = s10_11 + carry9_2)
    (hs10_11 : s10_11 = s10_10 - ((BitVec.sshiftRight (s10_10 + 1048576#64) 21) <<< 21))
    (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21)
    : s10_13 = (((s10_10 - (carry10_2 <<< 21)) + carry9_2) + carry9_3) := by
  rw [← hcarry10_2] at hs10_11
  clear hcarry10_2
  subst hs10_13 hs10_12 hs10_11
  grind

theorem fd_curve25519_scalar_muladd.s11_13_eq
    {s11_11 carry11_2 s11_12 carry10_3 s11_13 : BitVec 64}
    (hs11_13 : s11_13 = carry10_3 + s11_12)
    (hs11_12 : s11_12 = s11_11 - ((BitVec.sshiftRight (s11_11 + 1048576#64) 21) <<< 21))
    (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21)
    : s11_13 = ((s11_11 - (carry11_2 <<< 21)) + carry10_3) := by
  rw [← hcarry11_2] at hs11_12
  clear hcarry11_2
  subst hs11_13 hs11_12
  grind

theorem fd_curve25519_scalar_muladd.s0_6_eq
    {s0_4 carry0_2 s0_5 carry11_3 t850 s0_6 : BitVec 64}
    (hs0_6 : s0_6 = t850 + s0_5)
    (ht850 : t850 = carry11_3 * 666643#64)
    (hs0_5 : s0_5 = s0_4 - ((BitVec.sshiftRight s0_4 21) <<< 21))
    (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21)
    : s0_6 = ((s0_4 - (carry0_2 <<< 21)) + ((0#64 + carry11_3) * 666643#64)) := by
  rw [← hcarry0_2] at hs0_5
  clear hcarry0_2
  subst hs0_6 ht850 hs0_5
  grind

theorem fd_curve25519_scalar_muladd.s1_11_eq
    {s1_8 carry1_2 s1_9 carry11_3 t851 s1_10 carry0_3 s1_11 : BitVec 64}
    (hs1_11 : s1_11 = s1_10 + carry0_3)
    (hs1_10 : s1_10 = t851 + s1_9)
    (ht851 : t851 = carry11_3 * 470296#64)
    (hs1_9 : s1_9 = s1_8 - ((BitVec.sshiftRight s1_8 21) <<< 21))
    (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21)
    : s1_11 = (((s1_8 - (carry1_2 <<< 21)) + ((0#64 + carry11_3) * 470296#64)) + carry0_3) := by
  rw [← hcarry1_2] at hs1_9
  clear hcarry1_2
  subst hs1_11 hs1_10 ht851 hs1_9
  grind

theorem fd_curve25519_scalar_muladd.s2_12_eq
    {s2_9 carry2_2 s2_10 carry11_3 t853 s2_11 carry1_3 s2_12 : BitVec 64}
    (hs2_12 : s2_12 = s2_11 + carry1_3)
    (hs2_11 : s2_11 = t853 + s2_10)
    (ht853 : t853 = carry11_3 * 654183#64)
    (hs2_10 : s2_10 = s2_9 - ((BitVec.sshiftRight s2_9 21) <<< 21))
    (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21)
    : s2_12 = (((s2_9 - (carry2_2 <<< 21)) + ((0#64 + carry11_3) * 654183#64)) + carry1_3) := by
  rw [← hcarry2_2] at hs2_10
  clear hcarry2_2
  subst hs2_12 hs2_11 ht853 hs2_10
  grind

theorem fd_curve25519_scalar_muladd.s3_13_eq
    {s3_10 carry3_2 s3_11 carry11_3 t855 s3_12 carry2_3 s3_13 : BitVec 64}
    (hs3_13 : s3_13 = s3_12 + carry2_3)
    (hs3_12 : s3_12 = t855 + s3_11)
    (ht855 : t855 = carry11_3 * 18446744073708553811#64)
    (hs3_11 : s3_11 = s3_10 - ((BitVec.sshiftRight s3_10 21) <<< 21))
    (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21)
    : s3_13 = (((s3_10 - (carry3_2 <<< 21)) - ((0#64 + carry11_3) * 997805#64)) + carry2_3) := by
  rw [← hcarry3_2] at hs3_11
  clear hcarry3_2
  subst hs3_13 hs3_12 ht855 hs3_11
  grind

theorem fd_curve25519_scalar_muladd.s4_14_eq
    {s4_11 carry4_2 s4_12 carry11_3 t857 s4_13 carry3_3 s4_14 : BitVec 64}
    (hs4_14 : s4_14 = s4_13 + carry3_3)
    (hs4_13 : s4_13 = t857 + s4_12)
    (ht857 : t857 = carry11_3 * 136657#64)
    (hs4_12 : s4_12 = s4_11 - ((BitVec.sshiftRight s4_11 21) <<< 21))
    (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21)
    : s4_14 = (((s4_11 - (carry4_2 <<< 21)) + ((0#64 + carry11_3) * 136657#64)) + carry3_3) := by
  rw [← hcarry4_2] at hs4_12
  clear hcarry4_2
  subst hs4_14 hs4_13 ht857 hs4_12
  grind

theorem fd_curve25519_scalar_muladd.s5_15_eq
    {s5_12 carry5_2 s5_13 carry11_3 t859 s5_14 carry4_3 s5_15 : BitVec 64}
    (hs5_15 : s5_15 = s5_14 + carry4_3)
    (hs5_14 : s5_14 = t859 + s5_13)
    (ht859 : t859 = carry11_3 * 18446744073708867715#64)
    (hs5_13 : s5_13 = s5_12 - ((BitVec.sshiftRight s5_12 21) <<< 21))
    (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21)
    : s5_15 = (((s5_12 - (carry5_2 <<< 21)) - ((0#64 + carry11_3) * 683901#64)) + carry4_3) := by
  rw [← hcarry5_2] at hs5_13
  clear hcarry5_2
  subst hs5_15 hs5_14 ht859 hs5_13
  grind

theorem fd_curve25519_scalar_muladd.s6_14_eq
    {s6_12 carry6_3 s6_13 carry5_3 s6_14 : BitVec 64}
    (hs6_14 : s6_14 = carry5_3 + s6_13)
    (hs6_13 : s6_13 = s6_12 - ((BitVec.sshiftRight s6_12 21) <<< 21))
    (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21)
    : s6_14 = ((s6_12 - (carry6_3 <<< 21)) + carry5_3) := by
  rw [← hcarry6_3] at hs6_13
  clear hcarry6_3
  subst hs6_14 hs6_13
  grind

theorem fd_curve25519_scalar_muladd.s7_15_eq
    {s7_13 carry7_3 t838 carry6_4 s7_15 : BitVec 64}
    (hs7_15 : s7_15 = carry6_4 + t838)
    (ht838 : t838 = s7_13 - ((BitVec.sshiftRight s7_13 21) <<< 21))
    (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21)
    : s7_15 = ((s7_13 - (carry7_3 <<< 21)) + carry6_4) := by
  rw [← hcarry7_3] at ht838
  clear hcarry7_3
  subst hs7_15 ht838
  grind

theorem fd_curve25519_scalar_muladd.s8_15_eq
    {s8_13 carry8_3 t841 carry7_4 s8_15 : BitVec 64}
    (hs8_15 : s8_15 = carry7_4 + t841)
    (ht841 : t841 = s8_13 - ((BitVec.sshiftRight s8_13 21) <<< 21))
    (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21)
    : s8_15 = ((s8_13 - (carry8_3 <<< 21)) + carry7_4) := by
  rw [← hcarry8_3] at ht841
  clear hcarry8_3
  subst hs8_15 ht841
  grind

theorem fd_curve25519_scalar_muladd.s9_15_eq
    {s9_13 carry9_3 t844 carry8_4 s9_15 : BitVec 64}
    (hs9_15 : s9_15 = carry8_4 + t844)
    (ht844 : t844 = s9_13 - ((BitVec.sshiftRight s9_13 21) <<< 21))
    (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21)
    : s9_15 = ((s9_13 - (carry9_3 <<< 21)) + carry8_4) := by
  rw [← hcarry9_3] at ht844
  clear hcarry9_3
  subst hs9_15 ht844
  grind

theorem fd_curve25519_scalar_muladd.s10_15_eq
    {s10_13 carry10_3 t847 carry9_4 s10_15 : BitVec 64}
    (hs10_15 : s10_15 = carry9_4 + t847)
    (ht847 : t847 = s10_13 - ((BitVec.sshiftRight s10_13 21) <<< 21))
    (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21)
    : s10_15 = ((s10_13 - (carry10_3 <<< 21)) + carry9_4) := by
  rw [← hcarry10_3] at ht847
  clear hcarry10_3
  subst hs10_15 ht847
  grind

/-- The stored lanes are the spec's `out3 ++ (out2 ++ (out1 ++ out0))` of the last limbs. -/
private theorem fd_curve25519_scalar_muladd.pack_eq
    {s0_6 s1_11 s2_12 s3_13 s4_14 s5_15 s6_14 s7_15 s8_15 s9_15 s10_15 t849 t882 t883 : BitVec 64}
    (ht882 : t882 = s10_15 >>> 21) (ht883 : t883 = t882 + t849) :
    BitVec.packLanes
        #v[s2_12 <<< 42 &&& 9223367638808264704#64 |||
                  (s1_11 <<< 21 &&& 4398044413952#64 ||| s0_6 &&& 2097151#64) |||
                  s3_13 <<< 63,
                s5_15 <<< 41 &&& 4611683819404132352#64 |||
                  (s4_14 <<< 20 &&& 2199022206976#64 ||| s3_13 >>> 1 &&& 1048575#64) |||
                  s6_14 <<< 62,
                s8_15 <<< 40 &&& 2305841909702066176#64 |||
                  (s7_15 <<< 19 &&& 1099511103488#64 ||| s6_14 >>> 2 &&& 524287#64) |||
                  s9_15 <<< 61,
                s9_15 >>> 3 &&& 262143#64 ||| s10_15 <<< 18 &&& 549755551744#64 ||| t883 <<< 39] =
      ((s9_15 - BitVec.sshiftRight s9_15 21 <<< 21) >>> 3 |||
       (s10_15 - BitVec.sshiftRight s10_15 21 <<< 21) <<< 18 |||
        (t849 + BitVec.sshiftRight s10_15 21) <<< 39) ++
        (((s6_14 - BitVec.sshiftRight s6_14 21 <<< 21) >>> 2 |||
          (s7_15 - BitVec.sshiftRight s7_15 21 <<< 21) <<< 19 |||
          (s8_15 - BitVec.sshiftRight s8_15 21 <<< 21) <<< 40 |||
         (s9_15 - BitVec.sshiftRight s9_15 21 <<< 21) <<< 61) ++
         (((s3_13 - BitVec.sshiftRight s3_13 21 <<< 21) >>> 1 |||
           (s4_14 - BitVec.sshiftRight s4_14 21 <<< 21) <<< 20 |||
           (s5_15 - BitVec.sshiftRight s5_15 21 <<< 21) <<< 41 |||
          (s6_14 - BitVec.sshiftRight s6_14 21 <<< 21) <<< 62) ++
          ((s0_6 - BitVec.sshiftRight s0_6 21 <<< 21) |||
           (s1_11 - BitVec.sshiftRight s1_11 21 <<< 21) <<< 21 |||
           (s2_12 - BitVec.sshiftRight s2_12 21 <<< 21) <<< 42 |||
        (s3_13 - BitVec.sshiftRight s3_13 21 <<< 21) <<< 63))) := by
  rw [packLanes_four]
  subst ht882 ht883
  bv_decide

/-- The stored words are `spec`, the C's lets expanded over the compiled values. -/
private theorem fd_curve25519_scalar_muladd.spec_eq {A B C : BitVec 256}
    {ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 a0 t69 a1 t71 a2 t73 a4 t75 a5 t82 a3 t84 a6
     t86 a7 t88 a8 t90 a10 a11 b0 t94 b1 t96 b2 t103 a9 t105 b3 t107 b4 t109 b5 t111 b7 t113 b8
     t120 b6 t122 b9 t124 b10 b11 c0 t128 c1 t130 c2 t132 c4 t134 c5 t141 c3 t143 c6 t145 c7 t147
     c8 t149 c9 t151 c10 c11 s0 s2 s4 s6 s8 s10 s12 s14 s16 s18 s20 s22 carry0 s1_1 carry2 s3_1
     carry4 s5_1 carry6 s7_1 carry8 s9_1 carry10 s11_1 carry12 s13_1 carry14 s15_1 carry16 s17_1
     carry18 s19_1 carry20 s21_1 carry22 carry1 carry3 carry5 carry7 carry9 carry11 carry13 carry15
     carry17 carry19 carry21 s16_3 s14_5 s12_7 s6_3 s8_5 s10_7 carry6_1 s7_5 carry8_1 s9_7
     carry10_1 s11_9 carry12_1 s13_7 carry14_1 s15_5 carry16_1 carry7_1 carry9_1 carry11_1
     carry13_1 carry15_1 s10_10 s8_10 s6_9 s0_2 s2_5 s4_7 carry0_1 s1_5 carry2_1 s3_7 carry4_1 s5_9
     carry6_2 s7_11 carry8_2 s9_11 carry10_2 s11_11 carry1_1 carry3_1 carry5_1 carry7_2 carry9_2
     carry11_2 s0_4 carry0_2 s1_8 carry1_2 s2_9 carry2_2 s3_10 carry3_2 s4_11 carry4_2 s5_12
     carry5_2 s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 carry10_3 s11_13
     carry11_3 t849 s0_6 carry0_3 s1_11 carry1_3 s2_12 carry2_3 s3_13 carry3_3 s4_14 carry4_3 s5_15
     carry5_3 s6_14 carry6_4 s7_15 carry7_4 s8_15 carry8_4 s9_15 carry9_4 s10_15 : BitVec 64}
    (hia0 : ia0 = BitVec.setWidth 64 A)
    (hib0 : ib0 = BitVec.setWidth 64 B)
    (hic0 : ic0 = BitVec.setWidth 64 C)
    (hia1 : ia1 = BitVec.extractLsb' 64 64 A)
    (hib1 : ib1 = BitVec.extractLsb' 64 64 B)
    (hic1 : ic1 = BitVec.extractLsb' 64 64 C)
    (hia2 : ia2 = BitVec.extractLsb' 128 64 A)
    (hib2 : ib2 = BitVec.extractLsb' 128 64 B)
    (hic2 : ic2 = BitVec.extractLsb' 128 64 C)
    (hia3 : ia3 = BitVec.extractLsb' 192 64 A)
    (hib3 : ib3 = BitVec.extractLsb' 192 64 B)
    (hic3 : ic3 = BitVec.extractLsb' 192 64 C)
    (ha0 : a0 = ia0 &&& 2097151#64)
    (ht69 : t69 = ia0 >>> 21)
    (ha1 : a1 = t69 &&& 2097151#64)
    (ht71 : t71 = ia0 >>> 42)
    (ha2 : a2 = t71 &&& 2097151#64)
    (ht73 : t73 = ia1 >>> 20)
    (ha4 : a4 = t73 &&& 2097151#64)
    (ht75 : t75 = ia1 >>> 41)
    (ha5 : a5 = t75 &&& 2097151#64)
    (ht82 : t82 = BitVec.extractLsb' 64 64 ((ia1 ++ ia0) <<< 1))
    (ha3 : a3 = t82 &&& 2097151#64)
    (ht84 : t84 = BitVec.extractLsb' 64 64 ((ia2 ++ ia1) <<< 2))
    (ha6 : a6 = t84 &&& 2097151#64)
    (ht86 : t86 = ia2 >>> 19)
    (ha7 : a7 = t86 &&& 2097151#64)
    (ht88 : t88 = ia2 >>> 40)
    (ha8 : a8 = t88 &&& 2097151#64)
    (ht90 : t90 = ia3 >>> 18)
    (ha10 : a10 = t90 &&& 2097151#64)
    (ha11 : a11 = ia3 >>> 39)
    (hb0 : b0 = ib0 &&& 2097151#64)
    (ht94 : t94 = ib0 >>> 21)
    (hb1 : b1 = t94 &&& 2097151#64)
    (ht96 : t96 = ib0 >>> 42)
    (hb2 : b2 = t96 &&& 2097151#64)
    (ht103 : t103 = BitVec.extractLsb' 64 64 ((ia3 ++ ia2) <<< 3))
    (ha9 : a9 = t103 &&& 2097151#64)
    (ht105 : t105 = BitVec.extractLsb' 64 64 ((ib1 ++ ib0) <<< 1))
    (hb3 : b3 = t105 &&& 2097151#64)
    (ht107 : t107 = ib1 >>> 20)
    (hb4 : b4 = t107 &&& 2097151#64)
    (ht109 : t109 = ib1 >>> 41)
    (hb5 : b5 = t109 &&& 2097151#64)
    (ht111 : t111 = ib2 >>> 19)
    (hb7 : b7 = t111 &&& 2097151#64)
    (ht113 : t113 = ib2 >>> 40)
    (hb8 : b8 = t113 &&& 2097151#64)
    (ht120 : t120 = BitVec.extractLsb' 64 64 ((ib2 ++ ib1) <<< 2))
    (hb6 : b6 = t120 &&& 2097151#64)
    (ht122 : t122 = BitVec.extractLsb' 64 64 ((ib3 ++ ib2) <<< 3))
    (hb9 : b9 = t122 &&& 2097151#64)
    (ht124 : t124 = ib3 >>> 18)
    (hb10 : b10 = t124 &&& 2097151#64)
    (hb11 : b11 = ib3 >>> 39)
    (hc0 : c0 = ic0 &&& 2097151#64)
    (ht128 : t128 = ic0 >>> 21)
    (hc1 : c1 = t128 &&& 2097151#64)
    (ht130 : t130 = ic0 >>> 42)
    (hc2 : c2 = t130 &&& 2097151#64)
    (ht132 : t132 = ic1 >>> 20)
    (hc4 : c4 = t132 &&& 2097151#64)
    (ht134 : t134 = ic1 >>> 41)
    (hc5 : c5 = t134 &&& 2097151#64)
    (ht141 : t141 = BitVec.extractLsb' 64 64 ((ic1 ++ ic0) <<< 1))
    (hc3 : c3 = t141 &&& 2097151#64)
    (ht143 : t143 = BitVec.extractLsb' 64 64 ((ic2 ++ ic1) <<< 2))
    (hc6 : c6 = t143 &&& 2097151#64)
    (ht145 : t145 = ic2 >>> 19)
    (hc7 : c7 = t145 &&& 2097151#64)
    (ht147 : t147 = ic2 >>> 40)
    (hc8 : c8 = t147 &&& 2097151#64)
    (ht149 : t149 = BitVec.extractLsb' 64 64 ((ic3 ++ ic2) <<< 3))
    (hc9 : c9 = t149 &&& 2097151#64)
    (ht151 : t151 = ic3 >>> 18)
    (hc10 : c10 = t151 &&& 2097151#64)
    (hc11 : c11 = ic3 >>> 39)
    (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21)
    (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21)
    (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21)
    (hcarry6 : carry6 = BitVec.sshiftRight (s6 + 1048576#64) 21)
    (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21)
    (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21)
    (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21)
    (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21)
    (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21)
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21)
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21)
    (hcarry3 : carry3 = BitVec.sshiftRight (s3_1 + 1048576#64) 21)
    (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21)
    (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21)
    (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21)
    (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21)
    (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21)
    (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21)
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21)
    (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21)
    (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21)
    (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21)
    (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21)
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21)
    (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21)
    (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21)
    (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21)
    (hcarry8_2 : carry8_2 = BitVec.sshiftRight (s8_10 + 1048576#64) 21)
    (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21)
    (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21)
    (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21)
    (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21)
    (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21)
    (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21)
    (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21)
    (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21)
    (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21)
    (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21)
    (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21)
    (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21)
    (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21)
    (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21)
    (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21)
    (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21)
    (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21)
    (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21)
    (hcarry11_3 : carry11_3 = BitVec.sshiftRight s11_13 21)
    (hcarry0_3 : carry0_3 = BitVec.sshiftRight s0_6 21)
    (hcarry1_3 : carry1_3 = BitVec.sshiftRight s1_11 21)
    (hcarry2_3 : carry2_3 = BitVec.sshiftRight s2_12 21)
    (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21)
    (hcarry4_3 : carry4_3 = BitVec.sshiftRight s4_14 21)
    (hcarry5_3 : carry5_3 = BitVec.sshiftRight s5_15 21)
    (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21)
    (hcarry7_4 : carry7_4 = BitVec.sshiftRight s7_15 21)
    (hcarry8_4 : carry8_4 = BitVec.sshiftRight s8_15 21)
    (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21)
    (ht849 : t849 = s11_13 - ((BitVec.sshiftRight s11_13 21) <<< 21))
    (es0 : s0 = (c0 + (a0 * b0)))
    (es2 : s2 = (((c2 + (a0 * b2)) + (a1 * b1)) + (a2 * b0)))
    (es4 : s4 = (((((c4 + (a0 * b4)) + (a1 * b3)) + (a2 * b2)) + (a3 * b1)) + (a4 * b0)))
    (es6 : s6 = (((((((c6 + (a0 * b6)) + (a1 * b5)) + (a2 * b4)) + (a3 * b3)) + (a4 * b2)) +
     (a5 * b1)) + (a6 * b0)))
    (es8 : s8 = (((((((((c8 + (a0 * b8)) + (a1 * b7)) + (a2 * b6)) + (a3 * b5)) +
     (a4 * b4)) + (a5 * b3)) + (a6 * b2)) + (a7 * b1)) + (a8 * b0)))
    (es10 : s10 = (((((((((((c10 + (a0 * b10)) + (a1 * b9)) + (a2 * b8)) +
                     (a3 * b7)) + (a4 * b6)) + (a5 * b5)) + (a6 * b4)) + (a7 * b3)) +
     (a8 * b2)) + (a9 * b1)) + (a10 * b0)))
    (es12 : s12 = (((((((((((a1 * b11) + (a2 * b10)) + (a3 * b9)) + (a4 * b8)) +
                    (a5 * b7)) + (a6 * b6)) + (a7 * b5)) + (a8 * b4)) + (a9 * b3)) +
     (a10 * b2)) + (a11 * b1)))
    (es14 : s14 = (((((((((a3 * b11) + (a4 * b10)) + (a5 * b9)) + (a6 * b8)) +
     (a7 * b7)) + (a8 * b6)) + (a9 * b5)) + (a10 * b4)) + (a11 * b3)))
    (es16 : s16 = (((((((a5 * b11) + (a6 * b10)) + (a7 * b9)) + (a8 * b8)) + (a9 * b7)) +
     (a10 * b6)) + (a11 * b5)))
    (es18 : s18 = (((((a7 * b11) + (a8 * b10)) + (a9 * b9)) + (a10 * b8)) + (a11 * b7)))
    (es20 : s20 = (((a9 * b11) + (a10 * b10)) + (a11 * b9)))
    (es22 : s22 = (a11 * b11))
    (es1_1 : s1_1 = (((c1 + (a0 * b1)) + (a1 * b0)) + carry0))
    (es3_1 : s3_1 = (((((c3 + (a0 * b3)) + (a1 * b2)) + (a2 * b1)) + (a3 * b0)) + carry2))
    (es5_1 : s5_1 = (((((((c5 + (a0 * b5)) + (a1 * b4)) + (a2 * b3)) + (a3 * b2)) +
     (a4 * b1)) + (a5 * b0)) + carry4))
    (es7_1 : s7_1 = (((((((((c7 + (a0 * b7)) + (a1 * b6)) + (a2 * b5)) + (a3 * b4)) +
     (a4 * b3)) + (a5 * b2)) + (a6 * b1)) + (a7 * b0)) + carry6))
    (es9_1 : s9_1 = (((((((((((c9 + (a0 * b9)) + (a1 * b8)) + (a2 * b7)) +
                       (a3 * b6)) + (a4 * b5)) + (a5 * b4)) + (a6 * b3)) + (a7 * b2)) +
     (a8 * b1)) + (a9 * b0)) + carry8))
    (es11_1 : s11_1 = (((((((((((((c11 + (a0 * b11)) + (a1 * b10)) +
                              (a2 * b9)) + (a3 * b8)) + (a4 * b7)) +
                         (a5 * b6)) + (a6 * b5)) + (a7 * b4)) + (a8 * b3)) + (a9 * b2)) +
     (a10 * b1)) + (a11 * b0)) + carry10))
    (es13_1 : s13_1 = (((((((((((a2 * b11) + (a3 * b10)) + (a4 * b9)) +
                         (a5 * b8)) + (a6 * b7)) + (a7 * b6)) + (a8 * b5)) + (a9 * b4)) +
     (a10 * b3)) + (a11 * b2)) + carry12))
    (es15_1 : s15_1 = (((((((((a4 * b11) + (a5 * b10)) + (a6 * b9)) + (a7 * b8)) +
     (a8 * b7)) + (a9 * b6)) + (a10 * b5)) + (a11 * b4)) + carry14))
    (es17_1 : s17_1 = (((((((a6 * b11) + (a7 * b10)) + (a8 * b9)) + (a9 * b8)) + (a10 * b7)) +
     (a11 * b6)) + carry16))
    (es19_1 : s19_1 = (((((a8 * b11) + (a9 * b10)) + (a10 * b9)) + (a11 * b8)) + carry18))
    (es21_1 : s21_1 = (((a10 * b11) + (a11 * b10)) + carry20))
    (es6_3 : s6_3 = (((s6 - (carry6 <<< 21)) + carry5) +
     (((s18 - (carry18 <<< 21)) + carry17) * 666643#64)))
    (es8_5 : s8_5 = (((((s8 - (carry8 <<< 21)) + carry7) +
                      (((s20 - (carry20 <<< 21)) + carry19) * 666643#64)) +
                     ((s19_1 - (carry19 <<< 21)) * 470296#64)) +
     (((s18 - (carry18 <<< 21)) + carry17) * 654183#64)))
    (es10_7 : s10_7 = (((((((s10 - (carry10 <<< 21)) + carry9) +
                          (((s22 - (carry22 <<< 21)) + carry21) * 666643#64)) +
                         ((s21_1 - (carry21 <<< 21)) * 470296#64)) +
                        (((s20 - (carry20 <<< 21)) + carry19) * 654183#64)) -
                       ((s19_1 - (carry19 <<< 21)) * 997805#64)) +
     (((s18 - (carry18 <<< 21)) + carry17) * 136657#64)))
    (es12_7 : s12_7 = (((((((s12 - (carry12 <<< 21)) + carry11) +
                          ((0#64 + carry22) * 470296#64)) +
                         (((s22 - (carry22 <<< 21)) + carry21) * 654183#64)) -
                        ((s21_1 - (carry21 <<< 21)) * 997805#64)) +
                       (((s20 - (carry20 <<< 21)) + carry19) * 136657#64)) -
     ((s19_1 - (carry19 <<< 21)) * 683901#64)))
    (es14_5 : s14_5 = (((((s14 - (carry14 <<< 21)) + carry13) -
                        ((0#64 + carry22) * 997805#64)) +
                       (((s22 - (carry22 <<< 21)) + carry21) * 136657#64)) -
     ((s21_1 - (carry21 <<< 21)) * 683901#64)))
    (es16_3 : s16_3 = (((s16 - (carry16 <<< 21)) + carry15) - ((0#64 + carry22) * 683901#64)))
    (es7_5 : s7_5 = ((((s7_1 - (carry7 <<< 21)) + ((s19_1 - (carry19 <<< 21)) * 666643#64)) +
     (((s18 - (carry18 <<< 21)) + carry17) * 470296#64)) + carry6_1))
    (es9_7 : s9_7 = ((((((s9_1 - (carry9 <<< 21)) +
                        ((s21_1 - (carry21 <<< 21)) * 666643#64)) +
                       (((s20 - (carry20 <<< 21)) + carry19) * 470296#64)) +
                      ((s19_1 - (carry19 <<< 21)) * 654183#64)) -
     (((s18 - (carry18 <<< 21)) + carry17) * 997805#64)) + carry8_1))
    (es11_9 : s11_9 = ((((((((s11_1 - (carry11 <<< 21)) +
                            ((0#64 + carry22) * 666643#64)) +
                           (((s22 - (carry22 <<< 21)) + carry21) * 470296#64)) +
                          ((s21_1 - (carry21 <<< 21)) * 654183#64)) -
                         (((s20 - (carry20 <<< 21)) + carry19) * 997805#64)) +
                        ((s19_1 - (carry19 <<< 21)) * 136657#64)) -
     (((s18 - (carry18 <<< 21)) + carry17) * 683901#64)) + carry10_1))
    (es13_7 : s13_7 = ((((((s13_1 - (carry13 <<< 21)) + ((0#64 + carry22) * 654183#64)) -
                         (((s22 - (carry22 <<< 21)) + carry21) * 997805#64)) +
                        ((s21_1 - (carry21 <<< 21)) * 136657#64)) -
     (((s20 - (carry20 <<< 21)) + carry19) * 683901#64)) + carry12_1))
    (es15_5 : s15_5 = ((((s15_1 - (carry15 <<< 21)) + ((0#64 + carry22) * 136657#64)) -
     (((s22 - (carry22 <<< 21)) + carry21) * 683901#64)) + carry14_1))
    (es0_2 : s0_2 = ((s0 - (carry0 <<< 21)) + (((s12_7 - (carry12_1 <<< 21)) + carry11_1) *
     666643#64)))
    (es2_5 : s2_5 = (((((s2 - (carry2 <<< 21)) + carry1) +
                      (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 666643#64)) +
                     ((s13_7 - (carry13_1 <<< 21)) * 470296#64)) +
     (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 654183#64)))
    (es4_7 : s4_7 = (((((((s4 - (carry4 <<< 21)) + carry3) +
                        (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 666643#64)) +
                       ((s15_5 - (carry15_1 <<< 21)) * 470296#64)) +
                      (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 654183#64)) -
                     ((s13_7 - (carry13_1 <<< 21)) * 997805#64)) +
     (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 136657#64)))
    (es6_9 : s6_9 = ((((((s6_3 - (carry6_1 <<< 21)) +
                        (((s17_1 - (carry17 <<< 21)) + carry16_1) * 470296#64)) +
                       (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 654183#64)) -
                      ((s15_5 - (carry15_1 <<< 21)) * 997805#64)) +
                     (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 136657#64)) -
     ((s13_7 - (carry13_1 <<< 21)) * 683901#64)))
    (es8_10 : s8_10 = (((((s8_5 - (carry8_1 <<< 21)) + carry7_1) -
                        (((s17_1 - (carry17 <<< 21)) + carry16_1) * 997805#64)) +
                       (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 136657#64)) -
     ((s15_5 - (carry15_1 <<< 21)) * 683901#64)))
    (es10_10 : s10_10 = (((s10_7 - (carry10_1 <<< 21)) + carry9_1) -
     (((s17_1 - (carry17 <<< 21)) + carry16_1) * 683901#64)))
    (es1_5 : s1_5 = ((((s1_1 - (carry1 <<< 21)) + ((s13_7 - (carry13_1 <<< 21)) * 666643#64)) +
     (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 470296#64)) + carry0_1))
    (es3_7 : s3_7 = ((((((s3_1 - (carry3 <<< 21)) +
                        ((s15_5 - (carry15_1 <<< 21)) * 666643#64)) +
                       (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 470296#64)) +
                      ((s13_7 - (carry13_1 <<< 21)) * 654183#64)) -
     (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 997805#64)) + carry2_1))
    (es5_9 : s5_9 = ((((((((s5_1 - (carry5 <<< 21)) +
                           (((s17_1 - (carry17 <<< 21)) + carry16_1) *
                          666643#64)) + (((s16_3 - (carry16_1 <<< 21)) +
                         carry15_1) * 470296#64)) +
                        ((s15_5 - (carry15_1 <<< 21)) * 654183#64)) -
                       (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 997805#64)) +
                      ((s13_7 - (carry13_1 <<< 21)) * 136657#64)) -
     (((s12_7 - (carry12_1 <<< 21)) + carry11_1) * 683901#64)) + carry4_1))
    (es7_11 : s7_11 = ((((((s7_5 - (carry7_1 <<< 21)) +
                          (((s17_1 - (carry17 <<< 21)) + carry16_1) * 654183#64)) -
                         (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 997805#64)) +
                        ((s15_5 - (carry15_1 <<< 21)) * 136657#64)) -
     (((s14_5 - (carry14_1 <<< 21)) + carry13_1) * 683901#64)) + carry6_2))
    (es9_11 : s9_11 = ((((s9_7 - (carry9_1 <<< 21)) +
                        (((s17_1 - (carry17 <<< 21)) + carry16_1) * 136657#64)) -
     (((s16_3 - (carry16_1 <<< 21)) + carry15_1) * 683901#64)) + carry8_2))
    (es11_11 : s11_11 = ((s11_9 - (carry11_1 <<< 21)) + carry10_2))
    (es0_4 : s0_4 = ((s0_2 - (carry0_1 <<< 21)) + ((0#64 + carry11_2) * 666643#64)))
    (es1_8 : s1_8 = (((s1_5 - (carry1_1 <<< 21)) + ((0#64 + carry11_2) * 470296#64)) + carry0_2))
    (es2_9 : s2_9 = ((((s2_5 - (carry2_1 <<< 21)) + carry1_1) +
     ((0#64 + carry11_2) * 654183#64)) + carry1_2))
    (es3_10 : s3_10 = (((s3_7 - (carry3_1 <<< 21)) - ((0#64 + carry11_2) * 997805#64)) + carry2_2))
    (es4_11 : s4_11 = ((((s4_7 - (carry4_1 <<< 21)) + carry3_1) +
     ((0#64 + carry11_2) * 136657#64)) + carry3_2))
    (es5_12 : s5_12 = (((s5_9 - (carry5_1 <<< 21)) - ((0#64 + carry11_2) * 683901#64)) + carry4_2))
    (es6_12 : s6_12 = (((s6_9 - (carry6_2 <<< 21)) + carry5_1) + carry5_2))
    (es7_13 : s7_13 = ((s7_11 - (carry7_2 <<< 21)) + carry6_3))
    (es8_13 : s8_13 = (((s8_10 - (carry8_2 <<< 21)) + carry7_2) + carry7_3))
    (es9_13 : s9_13 = ((s9_11 - (carry9_2 <<< 21)) + carry8_3))
    (es10_13 : s10_13 = (((s10_10 - (carry10_2 <<< 21)) + carry9_2) + carry9_3))
    (es11_13 : s11_13 = ((s11_11 - (carry11_2 <<< 21)) + carry10_3))
    (es0_6 : s0_6 = ((s0_4 - (carry0_2 <<< 21)) + ((0#64 + carry11_3) * 666643#64)))
    (es1_11 : s1_11 = (((s1_8 - (carry1_2 <<< 21)) + ((0#64 + carry11_3) * 470296#64)) + carry0_3))
    (es2_12 : s2_12 = (((s2_9 - (carry2_2 <<< 21)) + ((0#64 + carry11_3) * 654183#64)) + carry1_3))
    (es3_13 : s3_13 = (((s3_10 - (carry3_2 <<< 21)) - ((0#64 + carry11_3) * 997805#64)) + carry2_3))
    (es4_14 : s4_14 = (((s4_11 - (carry4_2 <<< 21)) + ((0#64 + carry11_3) * 136657#64)) + carry3_3))
    (es5_15 : s5_15 = (((s5_12 - (carry5_2 <<< 21)) - ((0#64 + carry11_3) * 683901#64)) + carry4_3))
    (es6_14 : s6_14 = ((s6_12 - (carry6_3 <<< 21)) + carry5_3))
    (es7_15 : s7_15 = ((s7_13 - (carry7_3 <<< 21)) + carry6_4))
    (es8_15 : s8_15 = ((s8_13 - (carry8_3 <<< 21)) + carry7_4))
    (es9_15 : s9_15 = ((s9_13 - (carry9_3 <<< 21)) + carry8_4))
    (es10_15 : s10_15 = ((s10_13 - (carry10_3 <<< 21)) + carry9_4))
    :
      ((s9_15 - BitVec.sshiftRight s9_15 21 <<< 21) >>> 3 |||
       (s10_15 - BitVec.sshiftRight s10_15 21 <<< 21) <<< 18 |||
      (t849 + BitVec.sshiftRight s10_15 21) <<< 39) ++
      (((s6_14 - BitVec.sshiftRight s6_14 21 <<< 21) >>> 2 |||
        (s7_15 - BitVec.sshiftRight s7_15 21 <<< 21) <<< 19 |||
        (s8_15 - BitVec.sshiftRight s8_15 21 <<< 21) <<< 40 |||
       (s9_15 - BitVec.sshiftRight s9_15 21 <<< 21) <<< 61) ++
       (((s3_13 - BitVec.sshiftRight s3_13 21 <<< 21) >>> 1 |||
         (s4_14 - BitVec.sshiftRight s4_14 21 <<< 21) <<< 20 |||
         (s5_15 - BitVec.sshiftRight s5_15 21 <<< 21) <<< 41 |||
        (s6_14 - BitVec.sshiftRight s6_14 21 <<< 21) <<< 62) ++
        ((s0_6 - BitVec.sshiftRight s0_6 21 <<< 21) |||
         (s1_11 - BitVec.sshiftRight s1_11 21 <<< 21) <<< 21 |||
         (s2_12 - BitVec.sshiftRight s2_12 21 <<< 21) <<< 42 |||
      (s3_13 - BitVec.sshiftRight s3_13 21 <<< 21) <<< 63))) = fd_curve25519_scalar_muladd.spec A B
      C := by
  rw [BitVec.setWidth_eq_extractLsb' (by decide)] at hia0 hib0 hic0
  simp only [Bnd.fshl_eq _ _ 1 (by decide), Bnd.fshl_eq _ _ 2 (by decide), Bnd.fshl_eq _ _ 3
    (by decide), Nat.reduceSub] at ht82 ht84 ht103 ht105 ht120 ht122 ht141 ht143 ht149
  subst_vars
  rfl

-- 20 runs and 69 operand equations in one declaration, over a context of ~1000 facts.
set_option maxHeartbeats 400000 in
/-- `muladd` stores `spec` of the 32 bytes at `a`, `b` and `c` as the 32 bytes at `s`, and returns
`s`. The loads all come before the store, so `s` may alias the inputs. -/
public theorem fd_curve25519_scalar_muladd.call_eq (s a b c : Pointer) (st : GlobalState)
    (hwf : st.WF) (hs : Room st.mem s (8 * 32)) (ha : Fits st.mem a (8 * 32))
    (ha_off : ¬a.offset.uaddOverflow 32#64) (hb : Fits st.mem b (8 * 32))
    (hb_off : ¬b.offset.uaddOverflow 32#64) (hc : Fits st.mem c (8 * 32))
    (hc_off : ¬c.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_muladd.call
        (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)) st =
      .value
        (.cons (.value s) .nil,
          { st with
            mem :=
              st.mem.storeAt s
                (fd_curve25519_scalar_muladd.spec (st.mem.readAt a 256) (st.mem.readAt b 256)
                  (st.mem.readAt c 256)) }) := by
  func_init
  block_init
  step_pattern using fd_curve25519_scalar_muladd.run0
  step_pattern using fd_curve25519_scalar_muladd.run68
  step_pattern using fd_curve25519_scalar_muladd.run113
  step_pattern using fd_curve25519_scalar_muladd.run158
  step_pattern using fd_curve25519_scalar_muladd.run203
  step_pattern using fd_curve25519_scalar_muladd.run248
  step_pattern using fd_curve25519_scalar_muladd.run293
  step_pattern using fd_curve25519_scalar_muladd.run338
  step_pattern using fd_curve25519_scalar_muladd.run383
  step_pattern using fd_curve25519_scalar_muladd.run428
  step_pattern using fd_curve25519_scalar_muladd.run473
  step_pattern using fd_curve25519_scalar_muladd.run521
  step_pattern using fd_curve25519_scalar_muladd.run566
  step_pattern using fd_curve25519_scalar_muladd.run612
  step_pattern using fd_curve25519_scalar_muladd.run659
  step_pattern using fd_curve25519_scalar_muladd.run704
  step_pattern using fd_curve25519_scalar_muladd.run749
  step_pattern using fd_curve25519_scalar_muladd.run796
  step_pattern using fd_curve25519_scalar_muladd.run841
  step_pattern using fd_curve25519_scalar_muladd.run884
  finish_block
  subst hS
  have es0 := fd_curve25519_scalar_muladd.s0_eq hs0 ht154
  have es2 := fd_curve25519_scalar_muladd.s2_eq hs2 ht162 ht161 ht158 ht160 ht159
  have es4 := fd_curve25519_scalar_muladd.s4_eq hs4 ht176 ht175 ht174 ht173 ht171 ht170 ht172 ht168
    ht169
  have es6 := fd_curve25519_scalar_muladd.s6_eq hs6 ht196 ht195 ht194 ht193 ht192 ht191 ht189 ht188
    ht185 ht186 ht187 ht190 ht184
  have es8 := fd_curve25519_scalar_muladd.s8_eq hs8 ht222 ht221 ht220 ht219 ht218 ht217 ht216 ht215
    ht210 ht209 ht211 ht212 ht213 ht214 ht206 ht207 ht208
  have es10 := fd_curve25519_scalar_muladd.s10_eq hs10 ht254 ht253 ht252 ht251 ht250 ht249 ht248
    ht247 ht246 ht245 ht240 ht239 ht241 ht242 ht236 ht237 ht238 ht243 ht244 ht234 ht235
  have es12 := fd_curve25519_scalar_muladd.s12_eq hs12 ht287 ht286 ht285 ht284 ht283 ht282 ht281
    ht280 ht279 ht275 ht274 ht271 ht272 ht273 ht278 ht268 ht276 ht277 ht269 ht270
  have es14 := fd_curve25519_scalar_muladd.s14_eq hs14 ht314 ht313 ht312 ht311 ht310 ht309 ht308
    ht303 ht302 ht304 ht307 ht299 ht305 ht306 ht300 ht301
  have es16 := fd_curve25519_scalar_muladd.s16_eq hs16 ht335 ht334 ht333 ht332 ht331 ht330 ht327
    ht324 ht328 ht329 ht325 ht326
  have es18 := fd_curve25519_scalar_muladd.s18_eq hs18 ht350 ht349 ht348 ht343 ht347 ht346 ht344
    ht345
  have es20 := fd_curve25519_scalar_muladd.s20_eq hs20 ht358 ht357 ht356 ht359
  have es22 := fd_curve25519_scalar_muladd.s22_eq hs22
  have es1_1 := fd_curve25519_scalar_muladd.s1_1_eq hs1_1 hs1 ht367 ht156 ht157
  have es3_1 := fd_curve25519_scalar_muladd.s3_1_eq hs3_1 hs3 ht376 ht375 ht374 ht166 ht165 ht167
    ht164
  have es5_1 := fd_curve25519_scalar_muladd.s5_1_eq hs5_1 hs5 ht387 ht386 ht385 ht384 ht383 ht182
    ht181 ht183 ht178 ht179 ht180
  have es7_1 := fd_curve25519_scalar_muladd.s7_1_eq hs7_1 hs7 ht400 ht399 ht398 ht397 ht396 ht395
    ht394 ht200 ht203 ht201 ht202 ht204 ht205 ht198 ht199
  have es9_1 := fd_curve25519_scalar_muladd.s9_1_eq hs9_1 hs9 ht414 ht413 ht412 ht411 ht410 ht409
    ht408 ht407 ht406 ht229 ht228 ht230 ht231 ht232 ht225 ht226 ht227 ht233 ht224
  have es11_1 := fd_curve25519_scalar_muladd.s11_1_eq hs11_1 hs11 ht431 ht430 ht429 ht428 ht427
    ht426 ht425 ht424 ht423 ht422 ht421 ht263 ht262 ht264 ht259 ht260 ht261 ht267 ht256 ht265 ht266
    ht257 ht258
  have es13_1 := fd_curve25519_scalar_muladd.s13_1_eq hs13_1 hs13 ht444 ht443 ht442 ht441 ht440
    ht439 ht438 ht437 ht292 ht295 ht293 ht294 ht298 ht289 ht296 ht297 ht290 ht291
  have es15_1 := fd_curve25519_scalar_muladd.s15_1_eq hs15_1 hs15 ht455 ht454 ht453 ht452 ht451
    ht450 ht320 ht319 ht323 ht316 ht321 ht322 ht317 ht318
  have es17_1 := fd_curve25519_scalar_muladd.s17_1_eq hs17_1 hs17 ht464 ht463 ht462 ht461 ht337
    ht342 ht340 ht341 ht338 ht339
  have es19_1 := fd_curve25519_scalar_muladd.s19_1_eq hs19_1 hs19 ht471 ht470 ht352 ht355 ht353
    ht354
  have es21_1 := fd_curve25519_scalar_muladd.s21_1_eq hs21_1 hs21 ht362 ht361
  have es6_3 := fd_curve25519_scalar_muladd.s6_3_eq hs6_3 hs6_2 ht580 ht579 hs18_2 hs18_1 hcarry6
    hcarry18
  have es8_5 := fd_curve25519_scalar_muladd.s8_5_eq hs8_5 hs8_4 hs8_3 hs8_2 hs8_1 ht557 hs20_2
    hs20_1 ht566 hs19_2 ht585 hs18_2 hs18_1 hcarry8 hcarry18 hcarry20 hcarry19
  have es10_7 := fd_curve25519_scalar_muladd.s10_7_eq hs10_7 hs10_6 ht593 ht592 ht591 ht590 ht589
    ht547 hs21_2 ht540 hs22_2 hs22_1 ht560 hs20_2 hs20_1 ht569 hs19_2 ht588 hs18_2 hs18_1 hcarry10
    hcarry18 hcarry20 hcarry22 hcarry19 hcarry21
  have es12_7 := fd_curve25519_scalar_muladd.s12_7_eq hs12_7 ht577 ht576 ht575 ht574 ht573 ht572
    ht542 hs22_2 hs22_1 ht532 ht549 hs21_2 ht562 hs20_2 hs20_1 ht571 hs19_2 hcarry12 hcarry20
    hcarry22 hcarry19 hcarry21
  have es14_5 := fd_curve25519_scalar_muladd.s14_5_eq hs14_5 ht555 ht554 ht553 ht552 ht534 ht544
    hs22_2 hs22_1 ht551 hs21_2 hcarry14 hcarry22 hcarry21
  have es16_3 := fd_curve25519_scalar_muladd.s16_3_eq hs16_3 ht538 ht537 ht536 hcarry16
  have es7_5 := fd_curve25519_scalar_muladd.s7_5_eq hs7_5 hs7_4 hs7_3 hs7_2 ht564 hs19_2 ht583
    hs18_2 hs18_1 hcarry18 hcarry7 hcarry19
  have es9_7 := fd_curve25519_scalar_muladd.s9_7_eq hs9_7 hs9_6 hs9_5 ht606 ht605 ht604 ht546 hs21_2
    ht559 hs20_2 hs20_1 ht568 hs19_2 ht587 hs18_2 hs18_1 hcarry18 hcarry20 hcarry9 hcarry19 hcarry21
  have es11_9 := fd_curve25519_scalar_muladd.s11_9_eq hs11_9 hs11_8 ht619 ht618 ht617 ht616 ht615
    ht614 ht541 hs22_2 hs22_1 ht531 ht548 hs21_2 ht561 hs20_2 hs20_1 ht570 hs19_2 ht596 hs18_2
    hs18_1 hcarry18 hcarry20 hcarry22 hcarry11 hcarry19 hcarry21
  have es13_7 := fd_curve25519_scalar_muladd.s13_7_eq hs13_7 hs13_6 ht628 ht627 ht626 ht625 ht543
    hs22_2 hs22_1 ht533 ht550 hs21_2 ht563 hs20_2 hs20_1 hcarry20 hcarry22 hcarry13 hcarry21
  have es15_5 := fd_curve25519_scalar_muladd.s15_5_eq hs15_5 hs15_4 ht636 ht635 ht545 hs22_2 hs22_1
    ht535 hcarry22 hcarry15
  have es0_2 := fd_curve25519_scalar_muladd.s0_2_eq hs0_2 ht720 hs12_9 hs12_8 hs0_1 hcarry0
    hcarry12_1
  have es2_5 := fd_curve25519_scalar_muladd.s2_5_eq hs2_5 ht725 ht724 hs2_2 hs2_1 ht723 hs12_9
    hs12_8 ht705 hs14_7 hs14_6 ht714 hs13_8 hcarry2 hcarry12_1 hcarry14_1 hcarry13_1
  have es4_7 := fd_curve25519_scalar_muladd.s4_7_eq hs4_7 ht730 ht729 hs4_4 hs4_3 hs4_2 hs4_1 ht682
    hs16_5 hs16_4 ht695 hs15_6 ht728 hs12_9 hs12_8 ht707 hs14_7 hs14_6 ht716 hs13_8 hcarry4
    hcarry12_1 hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  have es6_9 := fd_curve25519_scalar_muladd.s6_9_eq hs6_9 hs6_8 hs6_7 hs6_6 hs6_5 hs6_4 ht671 hs17_3
    hs17_2 ht686 hs16_5 hs16_4 ht699 hs15_6 ht709 hs14_7 hs14_6 ht718 hs13_8 hcarry17 hcarry6_1
    hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  have es8_10 := fd_curve25519_scalar_muladd.s8_10_eq hs8_10 hs8_9 hs8_8 hs8_7 hs8_6 ht675 hs17_3
    hs17_2 ht690 hs16_5 hs16_4 ht703 hs15_6 hcarry17 hcarry8_1 hcarry16_1 hcarry15_1
  have es10_10 := fd_curve25519_scalar_muladd.s10_10_eq hs10_10 ht680 ht679 ht678 hs17_3 hs17_2
    hcarry17 hcarry10_1
  have es1_5 := fd_curve25519_scalar_muladd.s1_5_eq hs1_5 hs1_4 ht735 hs1_2 ht722 hs12_9 hs12_8
    ht713 hs13_8 hcarry1 hcarry12_1 hcarry13_1
  have es3_7 := fd_curve25519_scalar_muladd.s3_7_eq hs3_7 hs3_6 ht743 ht742 hs3_3 hs3_2 ht693 hs15_6
    ht727 hs12_9 hs12_8 ht706 hs14_7 hs14_6 ht715 hs13_8 hcarry3 hcarry12_1 hcarry14_1 hcarry13_1
    hcarry15_1
  have es5_9 := fd_curve25519_scalar_muladd.s5_9_eq hs5_9 hs5_8 ht750 ht749 hs5_5 hs5_4 hs5_3 hs5_2
    ht669 hs17_3 hs17_2 ht684 hs16_5 hs16_4 ht697 hs15_6 ht732 hs12_9 hs12_8 ht708 hs14_7 hs14_6
    ht717 hs13_8 hcarry5 hcarry17 hcarry12_1 hcarry14_1 hcarry16_1 hcarry13_1 hcarry15_1
  have es7_11 := fd_curve25519_scalar_muladd.s7_11_eq hs7_11 hs7_10 hs7_9 hs7_8 hs7_7 hs7_6 ht673
    hs17_3 hs17_2 ht688 hs16_5 hs16_4 ht701 hs15_6 ht711 hs14_7 hs14_6 hcarry17 hcarry14_1
    hcarry16_1 hcarry7_1 hcarry15_1
  have es9_11 := fd_curve25519_scalar_muladd.s9_11_eq hs9_11 hs9_10 hs9_9 ht761 ht677 hs17_3 hs17_2
    ht692 hs16_5 hs16_4 hcarry17 hcarry16_1 hcarry9_1
  have es11_11 := fd_curve25519_scalar_muladd.s11_11_eq hs11_11 hs11_10 hcarry11_1
  have es0_4 := fd_curve25519_scalar_muladd.s0_4_eq hs0_4 hs0_3 ht796 hcarry0_1
  have es1_8 := fd_curve25519_scalar_muladd.s1_8_eq hs1_8 hs1_7 ht804 ht798 hcarry1_1
  have es2_9 := fd_curve25519_scalar_muladd.s2_9_eq hs2_9 hs2_8 ht810 ht809 ht799 hcarry2_1
  have es3_10 := fd_curve25519_scalar_muladd.s3_10_eq hs3_10 hs3_9 ht815 ht800 hcarry3_1
  have es4_11 := fd_curve25519_scalar_muladd.s4_11_eq hs4_11 hs4_10 ht821 ht820 ht801 hcarry4_1
  have es5_12 := fd_curve25519_scalar_muladd.s5_12_eq hs5_12 hs5_11 ht826 ht802 hcarry5_1
  have es6_12 := fd_curve25519_scalar_muladd.s6_12_eq hs6_12 hs6_11 hs6_10 hcarry6_2
  have es7_13 := fd_curve25519_scalar_muladd.s7_13_eq hs7_13 hs7_12 hcarry7_2
  have es8_13 := fd_curve25519_scalar_muladd.s8_13_eq hs8_13 hs8_12 hs8_11 hcarry8_2
  have es9_13 := fd_curve25519_scalar_muladd.s9_13_eq hs9_13 hs9_12 hcarry9_2
  have es10_13 := fd_curve25519_scalar_muladd.s10_13_eq hs10_13 hs10_12 hs10_11 hcarry10_2
  have es11_13 := fd_curve25519_scalar_muladd.s11_13_eq hs11_13 hs11_12 hcarry11_2
  have es0_6 := fd_curve25519_scalar_muladd.s0_6_eq hs0_6 ht850 hs0_5 hcarry0_2
  have es1_11 := fd_curve25519_scalar_muladd.s1_11_eq hs1_11 hs1_10 ht851 hs1_9 hcarry1_2
  have es2_12 := fd_curve25519_scalar_muladd.s2_12_eq hs2_12 hs2_11 ht853 hs2_10 hcarry2_2
  have es3_13 := fd_curve25519_scalar_muladd.s3_13_eq hs3_13 hs3_12 ht855 hs3_11 hcarry3_2
  have es4_14 := fd_curve25519_scalar_muladd.s4_14_eq hs4_14 hs4_13 ht857 hs4_12 hcarry4_2
  have es5_15 := fd_curve25519_scalar_muladd.s5_15_eq hs5_15 hs5_14 ht859 hs5_13 hcarry5_2
  have es6_14 := fd_curve25519_scalar_muladd.s6_14_eq hs6_14 hs6_13 hcarry6_3
  have es7_15 := fd_curve25519_scalar_muladd.s7_15_eq hs7_15 ht838 hcarry7_3
  have es8_15 := fd_curve25519_scalar_muladd.s8_15_eq hs8_15 ht841 hcarry8_3
  have es9_15 := fd_curve25519_scalar_muladd.s9_15_eq hs9_15 ht844 hcarry9_3
  have es10_15 := fd_curve25519_scalar_muladd.s10_15_eq hs10_15 ht847 hcarry10_3
  rw [ht910, fd_curve25519_scalar_muladd.pack_eq ht882 ht883, fd_curve25519_scalar_muladd.spec_eq
      hia0 hib0 hic0 hia1 hib1 hic1 hia2 hib2 hic2 hia3 hib3 hic3 ha0 ht69 ha1 ht71 ha2 ht73 ha4
      ht75 ha5 ht82 ha3 ht84 ha6 ht86 ha7 ht88 ha8 ht90 ha10 ha11 hb0 ht94 hb1 ht96 hb2 ht103 ha9
      ht105 hb3 ht107 hb4 ht109 hb5 ht111 hb7 ht113 hb8 ht120 hb6 ht122 hb9 ht124 hb10 hb11 hc0
      ht128 hc1 ht130 hc2 ht132 hc4 ht134 hc5 ht141 hc3 ht143 hc6 ht145 hc7 ht147 hc8 ht149 hc9
      ht151 hc10 hc11 hcarry0 hcarry2 hcarry4 hcarry6 hcarry8 hcarry10 hcarry12 hcarry14 hcarry16
      hcarry18 hcarry20 hcarry22 hcarry1 hcarry3 hcarry5 hcarry7 hcarry9 hcarry11 hcarry13 hcarry15
      hcarry17 hcarry19 hcarry21 hcarry6_1 hcarry8_1 hcarry10_1 hcarry12_1 hcarry14_1 hcarry16_1
      hcarry7_1 hcarry9_1 hcarry11_1 hcarry13_1 hcarry15_1 hcarry0_1 hcarry2_1 hcarry4_1 hcarry6_2
      hcarry8_2 hcarry10_2 hcarry1_1 hcarry3_1 hcarry5_1 hcarry7_2 hcarry9_2 hcarry11_2 hcarry0_2
      hcarry1_2 hcarry2_2 hcarry3_2 hcarry4_2 hcarry5_2 hcarry6_3 hcarry7_3 hcarry8_3 hcarry9_3
      hcarry10_3 hcarry11_3 hcarry0_3 hcarry1_3 hcarry2_3 hcarry3_3 hcarry4_3 hcarry5_3 hcarry6_4
      hcarry7_4 hcarry8_4 hcarry9_4 ht849 es0 es2 es4 es6 es8 es10 es12 es14 es16 es18 es20 es22
      es1_1 es3_1 es5_1 es7_1 es9_1 es11_1 es13_1 es15_1 es17_1 es19_1 es21_1 es6_3 es8_5 es10_7
      es12_7 es14_5 es16_3 es7_5 es9_7 es11_9 es13_7 es15_5 es0_2 es2_5 es4_7 es6_9 es8_10 es10_10
      es1_5 es3_7 es5_9 es7_11 es9_11 es11_11 es0_4 es1_8 es2_9 es3_10 es4_11 es5_12 es6_12 es7_13
      es8_13 es9_13 es10_13 es11_13 es0_6 es1_11 es2_12 es3_13 es4_14 es5_15 es6_14 es7_15 es8_15
    es9_15 es10_15]

end Proof

end MLIR.Firedancer.Lane

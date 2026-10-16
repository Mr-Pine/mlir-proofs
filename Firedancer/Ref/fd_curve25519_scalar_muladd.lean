module

public import Firedancer.Ref.fd_merlin

namespace MLIR.Firedancer.Ref

/-! ## Specification

A scalar argument is the 32 bytes at the pointer as a little-endian 256-bit value (`buf[k]` at
bits `8k`); `long` arithmetic is 64-bit two's complement (no `long` here overflows on the inputs
the callers pass, as for `fd_curve25519_scalar_reduce.spec`). Every function loads all inputs before
storing, so in-place calls are the same function. -/

@[expose] public section

/-- `fd_curve25519_scalar_zero` (`ballet/ed25519/fd_curve25519_scalar.h:13`). -/
def fd_curve25519_scalar_zero : BitVec 256 :=
  ofBytesLE 256 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- `fd_curve25519_scalar_one` (`ballet/ed25519/fd_curve25519_scalar.h:18`). -/
def fd_curve25519_scalar_one : BitVec 256 :=
  ofBytesLE 256 [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- `fd_curve25519_scalar_minus_one` (`ballet/ed25519/fd_curve25519_scalar.h:26`), `ℓ - 1`. -/
def fd_curve25519_scalar_minus_one : BitVec 256 :=
  ofBytesLE 256 [0xec, 0xd3, 0xf5, 0x5c, 0x1a, 0x63, 0x12, 0x58,
                 0xd6, 0x9c, 0xf7, 0xa2, 0xde, 0xf9, 0xde, 0x14,
                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10]

set_option linter.unusedVariables false in
/-- `fd_curve25519_scalar_muladd` (`ballet/ed25519/fd_curve25519_scalar.c:113`): the 256 bits stored
at `s`. -/
def fd_curve25519_scalar_muladd.spec (a b c : BitVec 256) : BitVec 256 :=
  -- The dead `sK = 0L` resets are kept.
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
  -- Unpack each into 11 21-bit integers and a 25-bit straggler
  let mask := 2097151#64 -- `FD_ULONG_MASK_LSB( 21 )`
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
  let s8 := c8 + a0 * b8 + a1 * b7 + a2 * b6 + a3 * b5 + a4 * b4 + a5 * b3 + a6 * b2 + a7 * b1 + a8 * b0
  let s9 := c9 + a0 * b9 + a1 * b8 + a2 * b7 + a3 * b6 + a4 * b5 + a5 * b4 + a6 * b3 + a7 * b2 + a8 * b1 + a9 * b0
  let s10 := c10 + a0 * b10 + a1 * b9 + a2 * b8 + a3 * b7 + a4 * b6 + a5 * b5 + a6 * b4 + a7 * b3 + a8 * b2 + a9 * b1 + a10 * b0
  let s11 := c11 + a0 * b11 + a1 * b10 + a2 * b9 + a3 * b8 + a4 * b7 + a5 * b6 + a6 * b5 + a7 * b4 + a8 * b3 + a9 * b2 + a10 * b1 + a11 * b0
  let s12 := a1 * b11 + a2 * b10 + a3 * b9 + a4 * b8 + a5 * b7 + a6 * b6 + a7 * b5 + a8 * b4 + a9 * b3 + a10 * b2 + a11 * b1
  let s13 := a2 * b11 + a3 * b10 + a4 * b9 + a5 * b8 + a6 * b7 + a7 * b6 + a8 * b5 + a9 * b4 + a10 * b3 + a11 * b2
  let s14 := a3 * b11 + a4 * b10 + a5 * b9 + a6 * b8 + a7 * b7 + a8 * b6 + a9 * b5 + a10 * b4 + a11 * b3
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
  let s23 := 0#64
  let s10 := s10 + s22 * 666643#64
  let s11 := s11 + s22 * 470296#64
  let s12 := s12 + s22 * 654183#64
  let s13 := s13 - s22 * 997805#64
  let s14 := s14 + s22 * 136657#64
  let s15 := s15 - s22 * 683901#64
  let s22 := 0#64
  let s9 := s9 + s21 * 666643#64
  let s10 := s10 + s21 * 470296#64
  let s11 := s11 + s21 * 654183#64
  let s12 := s12 - s21 * 997805#64
  let s13 := s13 + s21 * 136657#64
  let s14 := s14 - s21 * 683901#64
  let s21 := 0#64
  let s8 := s8 + s20 * 666643#64
  let s9 := s9 + s20 * 470296#64
  let s10 := s10 + s20 * 654183#64
  let s11 := s11 - s20 * 997805#64
  let s12 := s12 + s20 * 136657#64
  let s13 := s13 - s20 * 683901#64
  let s20 := 0#64
  let s7 := s7 + s19 * 666643#64
  let s8 := s8 + s19 * 470296#64
  let s9 := s9 + s19 * 654183#64
  let s10 := s10 - s19 * 997805#64
  let s11 := s11 + s19 * 136657#64
  let s12 := s12 - s19 * 683901#64
  let s19 := 0#64
  let s6 := s6 + s18 * 666643#64
  let s7 := s7 + s18 * 470296#64
  let s8 := s8 + s18 * 654183#64
  let s9 := s9 - s18 * 997805#64
  let s10 := s10 + s18 * 136657#64
  let s11 := s11 - s18 * 683901#64
  let s18 := 0#64
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
  let s17 := 0#64
  let s4 := s4 + s16 * 666643#64
  let s5 := s5 + s16 * 470296#64
  let s6 := s6 + s16 * 654183#64
  let s7 := s7 - s16 * 997805#64
  let s8 := s8 + s16 * 136657#64
  let s9 := s9 - s16 * 683901#64
  let s16 := 0#64
  let s3 := s3 + s15 * 666643#64
  let s4 := s4 + s15 * 470296#64
  let s5 := s5 + s15 * 654183#64
  let s6 := s6 - s15 * 997805#64
  let s7 := s7 + s15 * 136657#64
  let s8 := s8 - s15 * 683901#64
  let s15 := 0#64
  let s2 := s2 + s14 * 666643#64
  let s3 := s3 + s14 * 470296#64
  let s4 := s4 + s14 * 654183#64
  let s5 := s5 - s14 * 997805#64
  let s6 := s6 + s14 * 136657#64
  let s7 := s7 - s14 * 683901#64
  let s14 := 0#64
  let s1 := s1 + s13 * 666643#64
  let s2 := s2 + s13 * 470296#64
  let s3 := s3 + s13 * 654183#64
  let s4 := s4 - s13 * 997805#64
  let s5 := s5 + s13 * 136657#64
  let s6 := s6 - s13 * 683901#64
  let s13 := 0#64
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
  -- Pack the results into s
  let out0 := s0 ||| s1 <<< 21 ||| s2 <<< 42 ||| s3 <<< 63
  let out1 := s3 >>> 1 ||| s4 <<< 20 ||| s5 <<< 41 ||| s6 <<< 62
  let out2 := s6 >>> 2 ||| s7 <<< 19 ||| s8 <<< 40 ||| s9 <<< 61
  let out3 := s9 >>> 3 ||| s10 <<< 18 ||| s11 <<< 39
  out3 ++ (out2 ++ (out1 ++ out0))

/-- `fd_curve25519_scalar_mul` (`ballet/ed25519/fd_curve25519_scalar.h:110`). -/
def fd_curve25519_scalar_mul.spec (a b : BitVec 256) : BitVec 256 :=
  fd_curve25519_scalar_muladd.spec a b fd_curve25519_scalar_zero

/-- `fd_curve25519_scalar_add` (`ballet/ed25519/fd_curve25519_scalar.h:117`). -/
def fd_curve25519_scalar_add.spec (a b : BitVec 256) : BitVec 256 :=
  fd_curve25519_scalar_muladd.spec a fd_curve25519_scalar_one b

/-- `fd_curve25519_scalar_sub` (`ballet/ed25519/fd_curve25519_scalar.h:124`): `(ℓ-1)·b + a`. -/
def fd_curve25519_scalar_sub.spec (a b : BitVec 256) : BitVec 256 :=
  fd_curve25519_scalar_muladd.spec fd_curve25519_scalar_minus_one b a

/-- `fd_curve25519_scalar_neg` (`ballet/ed25519/fd_curve25519_scalar.h:132`): `(ℓ-1)·a + 0`. -/
def fd_curve25519_scalar_neg.spec (a : BitVec 256) : BitVec 256 :=
  fd_curve25519_scalar_muladd.spec fd_curve25519_scalar_minus_one a fd_curve25519_scalar_zero

/-- `fd_curve25519_scalar_set` (`ballet/ed25519/fd_curve25519_scalar.h:139`): `fd_memcpy`, 32 bytes. -/
def fd_curve25519_scalar_set.spec (a : BitVec 256) : BitVec 256 :=
  a

/-- `fd_curve25519_scalar_from_u64` (`ballet/ed25519/fd_curve25519_scalar.h:145`): 32 zero bytes,
then `x` stored little-endian in the first 8. -/
def fd_curve25519_scalar_from_u64.spec (x : BitVec 64) : BitVec 256 :=
  let s := 0#256
  (s.extractLsb' 64 192) ++ x

end

end MLIR.Firedancer.Ref

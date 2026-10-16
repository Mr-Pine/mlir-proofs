module

public import Firedancer.Common.Point
public import Firedancer.Ref.fd_zksdk_transcript
public import Firedancer.Ref.fd_curve25519_scalar_muladd
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_ristretto255_point_frombytes
public import Firedancer.Ref.fd_ristretto255_point_eq
public import Firedancer.Ref.fd_ed25519_point_set_zero
public import Firedancer.Ref.fd_ed25519_multi_scalar_mul

namespace MLIR.Firedancer.Ref

/-! ## Specification

What the seven sigma verifiers share. Local arrays (`uchar scalars[ n*32 ]`,
`fd_ristretto255_point_t points[n]`) are functions of the index, updated by `store`; their initial
values (`uninit`) stand for uninitialised stack memory, and no verifier reads an entry it has not
stored (the MSM reads entries below its count). -/

@[expose] public section

/-- `FD_ZKSDK_VERIFY_PROOF_SUCCESS` (`ballet/zksdk/fd_zksdk_common.h:7`), an `int`. -/
def FD_ZKSDK_VERIFY_PROOF_SUCCESS : BitVec 32 := 0#32

/-- `FD_ZKSDK_VERIFY_PROOF_ERROR` (`ballet/zksdk/fd_zksdk_common.h:8`), an `int`. -/
def FD_ZKSDK_VERIFY_PROOF_ERROR : BitVec 32 := -1#32

/-- A verifier's return value and what it leaves in `*transcript`. -/
structure fd_zksdk_verify_result where
  ret : BitVec 32
  transcript : fd_merlin_transcript_t

/-- `fd_zksdk_basepoint_G` (`ballet/zksdk/fd_zksdk_private.h:9`): `fd_rangeproofs_basepoint_G`
(`zksdk/rangeproofs/fd_rangeproofs_table_ref.c:9`, the `!FD_HAS_AVX512` table), fields `X, Y, T, Z`
in declaration order. -/
def fd_zksdk_basepoint_G : PointLimbs :=
  ⟨fun i => #v[0x00062d608f25d51a#64, 0x000412a4b4f6592a#64, 0x00075b7171a4b31d#64,
      0x0001ff60527118fe#64, 0x000216936d3cd6e5#64][i],
   fun i => #v[0x0006666666666658#64, 0x0004cccccccccccc#64, 0x0001999999999999#64,
      0x0003333333333333#64, 0x0006666666666666#64][i],
   fun i => #v[0x00068ab3a5b7dda3#64, 0x00000eea2a5eadbb#64, 0x0002af8df483c27e#64,
      0x000332b375274732#64, 0x00067875f0fd78b7#64][i],
   fun i => #v[0x0000000000000001#64, 0x0000000000000000#64, 0x0000000000000000#64,
      0x0000000000000000#64, 0x0000000000000000#64][i]⟩

/-- `fd_zksdk_basepoint_H` (`ballet/zksdk/fd_zksdk_private.h:10`): `fd_rangeproofs_basepoint_H`
(`zksdk/rangeproofs/fd_rangeproofs_table_ref.c:21`), fields `X, Y, T, Z` in declaration order. -/
def fd_zksdk_basepoint_H : PointLimbs :=
  ⟨fun i => #v[0x000d87bdfce7269f#64, 0x000e869066bc4a1b#64, 0x000f78fcbe75c1b8#64,
      0x000ef81b8c57f39e#64, 0x000c73d889709199#64][i],
   fun i => #v[0x000292720285f8c6#64, 0x0001e62396fcb9aa#64, 0x000358f73250e0e1#64,
      0x0006f930f1e95ec3#64, 0x00044287ae97d597#64][i],
   fun i => #v[0x0000c413deb31662#64, 0x000659e173eeb58c#64, 0x000752c5e28be7e7#64,
      0x0002a93e4b4847b5#64, 0x0001177cf9414517#64][i],
   fun i => #v[0x0000000000000001#64, 0x0000000000000000#64, 0x0000000000000000#64,
      0x0000000000000000#64, 0x0000000000000000#64][i]⟩

/-- `fd_ristretto255_point_set` (`ballet/ed25519/fd_ristretto255.h:31`), `fd_ed25519_point_set`:
a copy (`fd_ed25519_point_set.call_eq`). -/
def fd_ristretto255_point_set (a : PointLimbs) : PointLimbs :=
  a

/-- `fd_ristretto255_point_decompress` (`ballet/ed25519/fd_ristretto255.h:37`),
`fd_ristretto255_point_frombytes`: `none` for `NULL`. -/
abbrev fd_ristretto255_point_decompress := fd_ristretto255_point_frombytes.spec

/-- `fd_ristretto255_multi_scalar_mul` (`ballet/ed25519/fd_ristretto255.h:36`),
`fd_ed25519_multi_scalar_mul`. -/
abbrev fd_ristretto255_multi_scalar_mul := fd_ed25519_multi_scalar_mul.spec

namespace fd_zksdk

/-- `a` after `a[i] = v`. -/
def store {α : Type} (a : Nat → α) (i : Nat) (v : α) : Nat → α :=
  fun j => if j = i then v else a j

/-- A fresh `uchar scalars[ n*32 ]`. -/
def uninitScalars : Nat → BitVec 256 :=
  fun _ => 0#256

/-- A fresh `fd_ristretto255_point_t points[n]`. -/
def uninitPoints : Nat → PointLimbs :=
  fun _ => fd_ed25519_point_set_zero.spec

/-- The `w`-bit little-endian field at byte offset `off` of a packed struct's bytes `b`. -/
def field (b : List (BitVec 8)) (off w : Nat) : BitVec w :=
  ofBytesLE w ((b.drop off).take (w / 8))

end fd_zksdk

end

end MLIR.Firedancer.Ref

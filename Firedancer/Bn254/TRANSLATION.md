# bn254 G1 syscalls: C → Lean

Source: `~/firedancer/src` at 8e5473de39 (2d3b8a36e6 plus the `fd_ulong_sub_borrow` fix; no other
change under `ballet/`). Namespace `Firedancer.Bn254`. Paths below are relative to `src/`.
Entry points (`Syscall.lean`): `fd_bn254_g1_add_syscall.{spec B, s2n, ref}`,
`fd_bn254_g1_scalar_mul_syscall.{spec B, s2n, ref}`, `fd_bn254_g1_compress.spec`,
`fd_bn254_g1_decompress.spec`.

## Conventions

- `ulong` = `BitVec 64`, `uchar` = `BitVec 8`, `int` = `BitVec 32`, `uint128` = `BitVec 128`; C
  arrays are `Vector T n`; `fd_uint256_t` is its `limbs` view, `buf` is derived (little-endian).
  Signed `int` compares use `slt`/`sle`. Loop counters that are ≥ 0 in the body are `Nat`.
- A function writing through a pointer returns what it leaves there; pointer returns are
  `Option` (`none` = `NULL`) in a `<fn>.Result` that also holds the memory state on the `NULL`
  path. Where a path stores only part of an output (`fd_bn254_g1_set_zero` stores only `Z`), the
  def takes the output's prior value.
- C `in` is `in_` (keyword). The syscall's `in` is `Vector (BitVec 8) in_sz.toNat`.
- Uninitialized locals start as `default` (all zero); see "Uninitialized values" for why none is
  observable on reachable paths.
- Short limb loops (4 iterations) are unrolled with the C's variable names; long loops
  (`fp_pow`, the scalar-mul scans and Shamir loop) are structural recursion on the bit index.
- `B : Backend` carries the only build-dependent function reached, `fd_bn254_fp_inv`:
  `Backend.s2n` (`FD_HAS_S2NBIGNUM`, every x86-64 and arm build: `config/extra/with-x86-64.mk:18`,
  `with-arm.mk:31`) and `Backend.ref`.

## Build variant (what is modelled)

Rule: model only C that could be lifted; replace Firedancer inline asm / intrinsics by their
portable branch; model trusted libraries by contract.

| Site | Production x86 build | Modelled |
|---|---|---|
| `bigint/fd_uint256_mul.h:165` `fd_uint256_mul_mod_p` | BMI2+ADX: inline asm `_fd_uint256_mul_mod_p` (`fd_uint256_mul.inc`) | portable `#else`, `FD_HAS_INT128` CIOS |
| `fd_uint256_mul.h:36` `fd_ulong_sub_borrow` | `_subborrow_u64` | `#else` (fixed in 8e5473de39) |
| `fd_uint256_mul.h:54` `fd_ulong_add_carry` | `_addcarry_u64` | not reached (only from the ADX `fp_add`/`fp_sub` and x86 `fp_add_lazy`) |
| `fd_uint256_mul.h:74,86` `vec_mul`, `add_carry4` | `FD_HAS_INT128` | same; the 32-bit `#else` (`fd_ulong_mul128`) is not modelled |
| `bn254/fd_bn254_field_inl.h:125` `fp_add` | ADX: carry chain + borrow select (on the intrinsics) | `#else`: `fiat_bn254_add` |
| `fd_bn254_field_inl.h:179` `fp_sub` | ADX: borrow chain + masked add | `#else`: `fiat_bn254_sub` |
| `fd_bn254_field_inl.h:253` `fp_inv` | s2n `bignum_modinv` | both: `fd_bn254_fp_inv.s2n`, `fd_bn254_fp_inv.spec` (`fp_pow(a, p-2)`) |
| `util/fd_util_base.h:575` `fd_type_pun_const` | `asm("# …" : "+r"(p) :: "memory")` | identity (comment-only barrier) |
| `fd_util_base.h:1224,1136` `fd_memeq`, `fd_memcpy` | `FD_USE_ARCH_MEMEQ/MEMCPY` default 0 | `memcmp`, `memcpy` semantics |

So the arithmetic is the `FD_HAS_X86 = 0` build's. On an ADX host, `fp_add`/`fp_sub`/`fp_mul`
are different code (C on intrinsics, asm); equality with this model is not claimed.
`fp_add_lazy` (`fd_bn254_field_inl.h:160`) is not reached from G1 (only `fp2_mul`, `fp2_sqr`).

## Functions

| C (file:line) | Lean | Notes |
|---|---|---|
| bits/fd_bits.h:241 `fd_ulong_bswap` | `fd_ulong_bswap.spec` | |
| bits/fd_bits.h:205 `fd_ulong_min` | `fd_ulong_min` | |
| fd_util_base.h:1224 `fd_memeq` | `fd_memeq` | |
| bigint/fd_uint256.h:32,62,72,78,91 bswap/eq/is_zero/cmp/bit | `fd_uint256_*.spec` | `bit` takes `i < 256` (all call sites) |
| fd_uint256_mul.h:36,74,86 | `fd_ulong_sub_borrow/vec_mul/add_carry4.spec` | pairs `(*r,*b)`, `(l,h)`, `(*l,*h)` |
| fd_uint256_mul.h:165 `fd_uint256_mul_mod_p` | `.spec`, body `.iter` | `r` stored after the loop: may alias `a`, `b` |
| field.c:4-59, field_inl.h:18-39, scalar.h:30 | `fd_bn254_const_*`, `FLAG_*` | limbs verbatim; all checked numerically (below) |
| internal.h:50-75 fp is_zero/is_one/set_zero/set_one | `.spec` | |
| field_inl.h:42 `fp_is_neg_nm` | `.spec` | `cmp > 0` |
| field_inl.h:47 `fp_frombytes_nm` | `.spec r buf be flags` | `flags = none` ⇔ `is_inf == NULL`; `r` untouched on both-flags NULL, stored on `≥ p` NULL |
| field_inl.h:79 `fp_tobytes_nm` | `.spec` → `{buf, a}` | byte-swaps `a` in place when big endian (callers never reuse `a`) |
| field_inl.h:90,96,114 eq/neg_nm/set | `.spec` | `neg_nm` alias-safe per limb |
| field_inl.h:125,179,208 add/sub/neg | fiat contracts | |
| field_inl.h:226-246 mul/sqr/from_mont/to_mont | `.spec` | `fp_mul` = `mul_mod_p(·,·,p,p_inv)` |
| field.c:74 `fp_pow` | `.spec` + `.scan`/`.step`/`.loop` | `restrict r`: call sites pass distinct `r`, `a`. `scan = none` (bit −1) is unreachable for `b ≠ 0`, modelled by an opaque |
| field_inl.h:255-266 / 267-272 `fp_inv` | `.s2n` / `.spec` | |
| field_inl.h:276 `fp_sqrt` | `.spec r a` | `r` stored only on success |
| glv.h:99-213, field.c:66-71 | `fd_bn254_glv_*.spec`, `na nb nc g1_const_g1 g2_const` | `uint128` wraps modelled; `g1_const_g2` (G2 only) omitted |
| g1.c:11 `fd_bn254_const_beta_mont` | same | |
| internal.h:28,174 G1 struct, `g1_is_zero` | `fd_bn254_g1_t`, `.spec` | |
| g1.c:16,25 set/set_zero | `.spec` | `set_zero` keeps `X`, `Y` |
| g1.c:33 `to_affine` | `.spec B p` | all of `r` stored; only call has `r ≠ p` |
| g1.c:52 `g1_tobytes` | `.spec B p be` | all 64 bytes stored on both paths |
| g1.c:76 `affine_add` | `.spec B r p q` | `r` only stored at the end |
| g1.c:132 `dbl` | `.spec r p` | alias-safe; both calls `r == p` |
| g1.c:187 `add_mixed` | `.spec r p q` | alias-safe for `r == p`; `q` not checked for zero |
| g1.c:250 `scalar_mul` | `.spec B r p s` + `.bits/.top/.step/.loop` | `p` must not alias `r` (syscall: distinct) |
| g1.c:333,363 frombytes_internal/check_subgroup | `.spec p in be` | `X` stored even when `Y` then fails |
| fd_bn254.c:6,38 compress/decompress | `.spec out in be` | `out` stored only on success, after the last read of `in` |
| fd_bn254.c:161,220 add/scalar_mul syscall | `.spec B out in_sz in be` | `out` stored only on success (ret 0) |

## Library call sites and the Pre to discharge

"< p" means `limbsEval … < p`. Every fiat/s2n output is < p when its Pre holds.

fiat (`Fiat.lean`; every Pre: inputs < p). Values reaching them: constants (`b_mont` < p),
`fp_mul` outputs, earlier fiat outputs, and coordinates of non-zero points. A non-zero point's
coordinates are `to_mont` outputs (check_subgroup), `fp_mul`/fiat outputs (`pt2`, dbl,
add_mixed, affine_add), or copies of those (`g1_set`). Zero points' `X`, `Y` are never fed to
fiat (every function tests `is_zero` first). So all fiat Pre follow from:
**(M) `fd_uint256_mul_mod_p.spec a b p p_inv < p` for `a, b < p`** (CIOS no-carry variant, `p <
2^254`; also needed for `R·(mul)` correctness).
- `fd_bn254.c:67` add(x3_plus_b, b_mont); `g1.c:382` add(x3b, b_mont).
- `g1.c:95-97` adds in the doubling branch (x = sqr, p.Y); `107-121` subs on p, q coordinates
  and `x`, `y`; `158-180` dbl; `213-242` add_mixed; `294` opp(pt2.Y), pt2.Y = p.Y.

s2n (`S2n.lean`, `BIGNUM_MODINV_SUBROUTINE_CORRECT`): `bignum_modinv(4, z, a, p, tmp[12])`,
`field_inl.h:263`. k = 4 < 2^57, tmp = 12 = 3k words, z/tmp locals (no overlap with a, p), p odd
≠ 1 — all constant. Remaining: **gcd(a, p) = 1**, i.e. `a mod p ≠ 0` (p prime) at:
- `g1.c:40` to_affine: a = Z, Z ≠ 0 (checked), Z < p by (M).
- `g1.c:98` affine_add doubling: a = 2Y mod p. Y ≠ 0 needs no point with y = 0: x³ = −3 has no
  root mod p (checked numerically: −3 is not a cube), given p on the curve (check_subgroup or
  derived). 
- `g1.c:109` affine_add: a = X₁ − X₂ mod p ≠ 0 since X₁ ≠ X₂, both < p.

Lazy reduction: none on this path (`fp_add_lazy` unreachable). No value ≥ p is fed to `fp_mul`: every `fp_mul` input is a constant, `from_bytes` output (< p), or (M)/fiat output.

## Uninitialized values

- Syscall locals `r`, `a`, `b`: `a`, `b` are fully stored unless zero (then `X`, `Y` keep stack
  garbage, `Z = 0`); `r` likewise. A zero point's `X`, `Y` are only copied (`g1_set`) or ignored
  (`tobytes` writes zeros). Unobservable.
- `scalar_mul`'s `pt12` (g1.c:298): if `affine_add` returns `set_zero`, `X`, `Y` are garbage
  and `add_mixed(r, r, pt12)` would read them (`q` is not checked). Unreachable for curve points:
  it needs `p.X = β·p.X`, i.e. x = 0, y² = 3, and 3 is a non-residue mod p (checked). Same
  argument rules out the doubling branch of that `affine_add`.
- `int is_inf, is_neg` (g1.c:348, fd_bn254.c:48) are stored by `frombytes_nm` before any read.

## Syscall wrapper (`flamenco/vm/syscall/fd_vm_syscall_crypto.c`, not translated)

`sol_alt_bn128_group_op` (l.9): ops `G1_ADD` 0, `G1_MUL` 2 (+`0x80` = LE).
1. LE ops (`G1_ADD_LE`, `G1_MUL_LE`, `PAIRING_LE`) without feature `alt_bn128_little_endian` →
   `SyscallError::InvalidAttribute` (hard error) (l.19-31). G2 ops gated by
   `enable_alt_bn128_g2_syscalls` (l.34-46). `SUB` ops (1, 5) and unknown ops → InvalidAttribute
   (l.92).
2. Cost: G1 add 334, G1 mul 3840 CU (`fd_vm_base.h:437,443`); `FD_VM_CU_UPDATE` before any
   memory access (l.99).
3. Result: `FD_VM_HADDR_QUERY_U8_SLICE(result_addr, 64)` (writable, align 1) before the input
   (l.101); input: `FD_VM_MEM_SLICE_HADDR_LD(input_addr, 1, input_sz)` (l.102): `input_sz >
   LONG_MAX` → `INVALID_LENGTH`; `input_sz == 0` → `NULL`, no translation. Translation faults
   come before the bn254 length checks (so an oversized `input_sz` that does not map faults
   rather than returning 1).
4. `big_endian = !(op & 0x80)` (l.104). The bn254 function writes `call_result` directly (VM
   memory) only on success; input/result overlap is not checked, and is harmless (input is copied
   to `buf` first).
5. `r0 = 0` on bn254 return 0, else 1 (`Ok(1)`); syscall returns `FD_VM_SUCCESS` (l.152). No
   other error codes (post SIMD-0129).

`sol_alt_bn128_compression` (l.157): ops `G1_COMPRESS` 0, `G1_DECOMPRESS` 1 (+`0x80`).
1. LE ops gated by `alt_bn128_little_endian` (l.167-181); unknown ops InvalidAttribute (l.212).
2. Cost: G1 compress 30 / decompress 398 + `FD_VM_SYSCALL_BASE_COST` 100 (l.216), charged before
   memory access (l.220).
3. Result slice of 32 (compress) / 64 (decompress), then input slice of `input_sz` (l.224-225),
   both before the length check.
4. `input_sz != 64` (compress) / `!= 32` (decompress) → `r0 = 1` (l.236, 246), no write.
5. `r0 = 0` iff the bn254 function returns non-NULL. No overlap check; harmless since both read
   `in` fully before writing `out`.

## Suspicious or noteworthy (translated as written)

1. `fd_bn254_glv.h:31-34`: the stated λ = 4407920970296243842393367215006156084916469457145843978461
   is the other cube root of unity. With this β, φ = [λ'] with λ' = λ² = −λ−1 mod r =
   21888242871839275217838484774961031246154997185409878258781734729429964517155, and the lattice
   vectors are (N_A, −N_B), (N_B, N_C) for λ' (both ≡ 0). The code is consistent; the comment
   (and its "a + bλ" lattice) is not.
2. `fd_bn254_g1_add_mixed` assumes `q->Z == 1` and never checks `q` for zero (see pt12 above).
3. `in_sz == 0` (big endian) reaches `fd_memcpy(buf, NULL, 0)`: the VM passes `NULL` for empty
   slices; `memcpy` with a null pointer is UB in C11 even for size 0. Modelled as a no-op.
4. Uncompressed inputs: `y`'s two top bits are flags. `FLAG_NEG` alone is silently masked (point
   accepted); `FLAG_INF` makes the point infinity regardless of `x`, `y` (still `< p` after
   masking); both → error. `x` is not masked. (arkworks behaviour per the C comments; conformance
   phase.)
5. `fd_bn254_g1_compress` does no curve check and ignores the input's `FLAG_NEG`; decompress with
   `FLAG_INF` returns zeros after only `x < p` (masked).
6. The scalar is not reduced (≤ 2^256 − 1). GLV obligations for the proof phase: `k1` (borrow of
   `g1.c:271` discarded) and `|k2|` fit 256 bits and `s ≡ k1 + λ' k2 (mod r)` for every 256-bit
   `s`. The `uint128` sums in `glv_sxg3/sxg2/mul3x2/mul2x2` cannot wrap (constant limbs sum to <
   2^64, checked), and `add4`'s carry (g1.c:270) is discarded.
7. `g1.c:178-179` comments say `4*y`, `8*y`; the value is `c = Y⁴` (`8C` of dbl-2009-l). Comment
   only.
8. `fd_bn254_fp_inv.s2n` relies on `bignum_modinv` treating `a` as a plain residue (no `a < p`
   needed by the HOL spec) — matches.

## Constants checked (Python, `pow`/`%` on integers)

`rr = R² mod p`, `one_mont = R mod p`, `b_mont = 3R mod p`, `p_minus_one_mont = (p−1)R mod p`,
`p_minus_one_half = (p−1)/2`, `sqrt_exp = (p−3)/4` (p ≡ 3 mod 4), `p_inv·p ≡ −1 (mod 2^64)`,
`β_mont = βR mod p` with β³ = 1, [λ']G = (β, 2) for G = (1, 2), [r]G = O, `g1_const_g1 =
round(2^256 N_C / r)`, `g2_const = round(2^256 N_B / r)`, N_A N_C + N_B² = r.

## Sanity `#eval` (scratch, deleted)

Both builds, vectors from `ballet/bn254/test_bn254.c` plus a Python affine reference: G1 add 66/66
(BE, BE-as-LE, LE, short-LE rejections, P+P, P+(−P), P+O, O+P); scalar mul vectors 88/88 and
reference 310/310 (points G, a test point, 3 random; scalars 0, 1, 2, 3, r−2, r−1, r, r+1, 2r, 3r,
p−1, p, λ', λ'+1, 2^128±, 2^255, 2^256−1, ⌊(2^256−1)/r⌋r, 12 random); compress/decompress 65/65
(round trips BE/LE, LE vectors, infinity flag, 32 reference decompressions incl. non-residues);
rejections 40/40 (x = p, y = p, off-curve, both flags, inf/neg flags, lengths 0/64/127/129/95/97).

## Audit

Independent audit against `~/firedancer` HEAD 4f96237db1 (differs from 8e5473de39 only in
`bigint/test_uint256.c`). No transcription error found; no Lean change made.

- Line by line: every def in `Bits`, `Fiat`, `S2n`, `Field`, `Glv`, `G1`, `Syscall` against its C
  (widths, `uint128` wraps, carries/borrows, signed compares, branch order, early returns, partial
  stores, aliasing, flag bytes, endianness). All match.
- Constants re-derived (`~/fd-specs/difftest-bn254/scripts/consts.py`, 25 checks): all limbs,
  `p_inv`, `β`, lattice (for λ' as item 1 says), `g1`/`g2` (floor = round), no-wrap of the
  `sxg*` accumulators, 3 non-residue, −3 non-cube.
- Contracts: fiat models match the `bn254_64.c` pre/postconditions and the NOTE at line 7.
  `bignum_modinv` matches `BIGNUM_MODINV_SUBROUTINE_CORRECT` (x86 and arm at cba3956). The
  vendored `{x86,arm}/generic/bignum_modinv.S` is byte-identical to upstream cba3956.
- Differential (`~/fd-specs/difftest-bn254`, `run.sh`): ~108.7k in-contract cases (two seeds;
  fp ops on arbitrary 256-bit inputs, GLV helpers, every point function, syscalls, VM-level
  forms). Lean `.s2n`/`.ref` match the C on every case for portable x86 (`FD_HAS_X86=0`),
  aarch64 (zig/musl, qemu), x86 no-ADX (intrinsic `_subborrow_u64`) and production ADX (gcc and
  clang), and -O0 = -O2. 199 of 525 out-of-Pre cases differ, all fiat calls with inputs ≥ p
  (opaque). Agave (solana-bn254 3.2.1) agrees on all 13,272 VM-level cases.

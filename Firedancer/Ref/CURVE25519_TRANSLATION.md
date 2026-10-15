# curve25519 syscalls (edwards25519, ristretto255): C → Lean

Source: `~/firedancer/src` at ac6d4a84b, ref backend (`FD_HAS_AVX512` unset,
`ballet/ed25519/fd_curve25519.h:12-16`; `ref/fd_f25519.h:7` `USE_FIAT_32 0`, 5×64-bit limbs;
`ref/fd_curve25519.h:19` `CURVE25519_PRECOMP_XY 1`). Namespace `MLIR.Firedancer.Ref`. Paths
below are relative to `src/ballet/ed25519/` unless they start with `flamenco/` or
`third_party/`.

## Conventions

- Field element: `Fin 5 → BitVec 64` (the reused specs' type); point: `PointLimbs` (`X, Y, T, Z`,
  the C field order). 32-byte buffers: `BitVec 256`, little-endian, `buf[k]` at bits `8k`.
- `int` = `BitVec 32`, `long`/`ulong` = `BitVec 64`, `int128` = `BitVec 128`; `(int)`/`(long)`
  casts are `setWidth`/`signExtend` as C converts; `>>` on signed is `sshiftRight`. Shift
  counts that are `int` are `.toNat` of the value (C UB for negative / ≥ width; not reached).
- Pointer-returning functions: `Option` (`none` = `NULL`). A function that writes through an
  output pointer returns the value written. When the pointer is also written on a `NULL` path,
  a `Result` structure carries it (`multi_scalar_mul_edwards/ristretto`).
- C arrays `T x[]` passed by pointer: `x : Nat → T`, `x j` = `x[j]`; `x + k` = `fun j => x (k + j)`.
  For `uchar n[]` of scalars, `n j` is the 32 bytes at `n + 32*j`.
- Loops: structural recursion with the C's trip count, or a fuel argument the C loop provably
  never exhausts (noted per function). Copies (`fd_f25519_set`, `fd_ed25519_point_set/to/from`,
  `fd_f25519_mul2/3/4`) are inlined as the copied values / successive `fd_f25519_mul.spec`, as
  the reused specs do.
- Sanity checks were run by kernel evaluation (`decide +kernel`), not `#eval` (see the end).

## Call graph and Lean defs

New files are `Firedancer/Ref/<fn>.lean` with a `## Specification` section only. "Reused" =
an existing spec already proved equal to the ref LLVM lift; all are the ref build with the
`#if` branches above (none of them has another `#if` in its body, `FD_HAS_S2NBIGNUM` does not
touch them).

| C (file:line) | Lean | |
|---|---|---|
| `fd_curve25519_scalar.h:59` `fd_curve25519_scalar_validate` | `fd_curve25519_scalar_validate.spec : BitVec 256 → Bool` | reused; `true` ↔ returns `s` (≠ NULL) |
| `fd_curve25519_scalar.c:278` `fd_curve25519_scalar_wnaf` | `fd_curve25519_scalar_wnaf.wnaf` | reused; ignores bit 255 |
| `fd_curve25519.c:35` `fd_ed25519_point_frombytes` | `fd_ed25519_point_frombytes.spec : _ → Option PointLimbs` | reused; `r` unwritten on NULL |
| `fd_curve25519.c:75` `fd_ed25519_point_validate` | `fd_ed25519_point_validate.spec` | new |
| `fd_curve25519.c:123` `fd_ed25519_point_tobytes` | `fd_ed25519_point_tobytes.spec` (`.s2n`, `.withInv`) | new |
| `ref/fd_curve25519.c:96` `fd_ed25519_point_add` | `fd_ed25519_point_add.spec` | new, `add_with_opts(…,0,0,0)` |
| `ref/fd_curve25519.c:183` `fd_ed25519_point_sub` | `fd_ed25519_point_sub.spec` | new, `sub_with_opts(…,0,0,0)` |
| `ref/fd_curve25519.c:26` / `:113` `…_add/_sub_with_opts` | `fd_ed25519_point_add/sub_with_opts.spec` | reused |
| `fd_curve25519.c:141` `fd_ed25519_scalar_mul` | `fd_ed25519_scalar_mul.spec` (+ `.start`, `.ladder`) | new |
| `fd_curve25519.c:334` `fd_ed25519_multi_scalar_mul_with_opts` | `fd_ed25519_multi_scalar_mul_with_opts.spec` (+ `.adds/.iter/.ladder`, `.spec_tbl`) | new |
| `fd_curve25519.c:387` `fd_ed25519_multi_scalar_mul` | `fd_ed25519_multi_scalar_mul.spec` (+ `.loop`, `.BATCH_SZ`) | new |
| `ref/fd_curve25519.h:46` `fd_ed25519_point_set_zero` | `fd_ed25519_point_set_zero.spec` | reused |
| `ref/fd_curve25519.h:196/219/164/183/150` partial_dbl, dbln, add_final_mul, add_final_mul_projective, into_precomputed | `.spec` of each | reused |
| table loop `fd_curve25519.c:152-160` (= `:195-203`, `:351-359`) | `fd_ed25519_double_scalar_mul_base.aiTable` | reused helper, identical C lines |
| digit add `fd_curve25519.c:168-169` (= `:212-213`, `:372-373`) | `fd_ed25519_double_scalar_mul_base.addDigit` / `.add1` | reused helpers |
| `fd_ristretto255.c:4` `fd_ristretto255_point_frombytes` | `fd_ristretto255_point_frombytes.spec : _ → Option PointLimbs` | new; `h` unwritten on NULL |
| `fd_ristretto255.c:74` `fd_ristretto255_point_tobytes` | `fd_ristretto255_point_tobytes.spec` | new |
| `fd_ristretto255.h:59` `fd_ristretto255_point_validate` | `fd_ristretto255_point_validate.spec` | new |
| `fd_ristretto255.h:69` / `:93` `_eq`, `_eq_neg` | `fd_ristretto255_point_eq/_eq_neg.spec` | new; not reached by the syscalls |
| `fd_ristretto255.h:30-36` `_set_zero/_add/_sub/_scalar_mul/_multi_scalar_mul` | the `fd_ed25519_*` defs | `#define` aliases, no defs |
| `fd_f25519.h:210` `fd_f25519_inv_sqrt` | `fd_f25519_inv_sqrt.spec` | new |
| `fd_f25519.c:100` `fd_f25519_inv` (no s2n) | `fd_f25519_inv.spec` | new; reuses `fd_f25519_pow22523.sqrN` |
| `fd_f25519.c:86` `fd_f25519_inv` (s2n) | `fd_f25519_inv.s2n`, `bignum_inv_p25519.spec` | new, contract model |
| `fd_f25519.c:159` `fd_f25519_posdivsteps_62_var` | `fd_f25519_posdivsteps_62_var.spec` (+ `.body/.loop/.fuel`, `fd_int_min`) | new |
| `fd_f25519.c:218` `fd_f25519_update_fg_62_var` | `fd_f25519_update_fg_62_var.spec` | new |
| `fd_f25519.c:243` `fd_f25519_jacobi_var` | `fd_f25519_jacobi_var.spec` | new |
| `fd_f25519.c:269` `fd_f25519_is_square_var` | `fd_f25519_is_square_var.spec` | new |
| `fd_f25519.c:297` `fd_f25519_sqrt_ratio`, `:33` `pow22523` | `.spec` | reused |
| `ref/fd_f25519.h` mul, sqr, add, sub, add_nr, sub_nr, neg, frombytes, tobytes, if, is_zero; `fd_f25519.h:141/156/165` eq, sgn, abs | `.spec` of each | reused |
| `util/bits/fd_bits_find_lsb.h:24` `fd_ulong_find_lsb` | `fd_ulong_find_lsb.spec` | reused (ffsl−1; the `__BMI__` ctzl variant only differs at 0, never passed) |
| `table/fd_f25519_table_ref.c:23` / `:48` `fd_f25519_two`, `fd_f25519_invsqrt_a_minus_d` | `fd_f25519_two.limbs` (in ristretto frombytes), `fd_f25519_invsqrt_a_minus_d.limbs` (in ristretto tobytes) | new constants, copied verbatim |
| `flamenco/vm/syscall/fd_vm_syscall_curve.c:455` / `:495` `multi_scalar_mul_edwards/_ristretto` | `multi_scalar_mul_edwards/_ristretto.spec` (+ `.decode/.loop`) | new; static helpers, no VM memory or CU |

Inlined: `fd_memeq` (`util/fd_util_base.h:1224`, `0==memcmp`) as `=`; `fd_ulong_min` as `min`
on `Nat`; `fd_ulong_load_8_fast` as a little-endian `extractLsb'`; `fd_msan_unpoison` (no-op).

Not reached: `fd_ed25519_point_frombytes_2x` (the syscall has a `//TODO` to use it,
`fd_vm_syscall_curve.c:476,516`; there is no ristretto `_frombytes_2x`).

## Modelling decisions

- **Aliasing.** `fd_ed25519_point_add/sub(r, r, x)` (`fd_curve25519.c:399`,
  `fd_vm_syscall_curve.c:483,523`): `add/sub_with_opts` read all of `a`, `b` before the final
  `mul4` writes `r` (it reads only locals), so the pure spec holds for `r == a`.
  `fd_ed25519_scalar_mul(r, n, a)` with `r == a` (as in `test_ristretto255.c:466`) builds the
  table from `a` before `set_zero(r)`: pure. `fd_f25519_if(x, c, a, x)`, `fd_f25519_abs(s, s)`,
  in-place fiat mul/sqr: fiat computes into locals and stores last. Results written into VM
  memory are written after the last read of the inputs.
- **Partial writes / failure paths.** frombytes (both curves) write the output only on success
  (`Option`). `multi_scalar_mul_*` returns `{ r, ret }`: on a bad scalar `*r` is untouched
  (`r₀`); on a bad point in batch `k` it holds the sum of batches `< k` and `ret = none`. The
  local `A[]` is not modelled past the batch being decoded (its stale entries are never read).
- **`projective` keeps `r->T`.** In every ladder `r->T` after a projective final mul is the old
  one (`fd_ed25519_point_add_final_mul_projective.spec P T₀`), threaded as `rt.1.T`.
- **Base table.** `with_opts` takes `fd_ed25519_base_point_wnaf_table` as a parameter `tbl`
  (as `fd_ed25519_double_scalar_mul_base.spec` does; its bits are only noncomputably
  available). It is read only when `base_sz ≠ 0`; `fd_ed25519_multi_scalar_mul` passes
  `base_sz = 0` and a dummy table, justified by the proved `…with_opts.spec_tbl`.
- **Sizes.** `with_opts` arrays are `[32]`: `sz > 32` overflows them (UB), never passed (the
  batch loop passes ≤ 32). `ulong i += 32` wrapping (`sz > 2^64-32`) is not modelled.
- **Fuel.** `posdivsteps` `for(;;)`: fuel 256; while `f` is odd every pass after the first
  lowers `i` (62 → 0), so ≤ 63 passes; with even `f` the C would loop forever (not reachable
  from `jacobi_var`, `f` starts at `p`). `update_fg` with `len ∉ [1,5]` is not modelled (UB,
  never passed). jacobi `cnt < 25`, MSM batch loops: exact trip counts.
- **s2n.** `FD_HAS_S2NBIGNUM` changes only `fd_f25519_inv` in this graph (→ `bignum_inv_p25519`,
  used by `fd_ed25519_point_tobytes`). `fd_ed25519_s2n.c` (scalarmulbase/double, verify) is
  not reached. Model: if `gcd(x, p) = 1` the inverse in `[0,p)`, else opaque
  `bignum_inv_p25519_unspec`; from the `.S` banner (the HOL proof is not vendored, so the
  `x ≡ 0` case could be refined from upstream's `BIGNUM_INV_P25519_CORRECT`). The ref chain
  gives `inv 0 = 0`. Firedancer asm/intrinsic branches: none reached in the ref build.
- **Ristretto MUL/MSM** use the edwards scalar mult. on the decoded representative; only the
  encoding differs.

## MSM structure

Syscall → `multi_scalar_mul_edwards(r, scalars, points, cnt)`: validate all `cnt` scalars first
(any invalid → NULL, `r` untouched); `set_zero(r)`; for each batch of `≤ 32`: decode its
points (first failure → NULL), `tmp = fd_ed25519_multi_scalar_mul(scalars, A, batch_cnt)`,
`r = r + tmp`, advance both pointers. `fd_ed25519_multi_scalar_mul` batches again by 32 (so one
inner batch) and calls `with_opts(…, base_sz = 0)`: per point the wNAF (width 4) and the
8-entry odd-multiple table; then all 256 bits from 255 down (no leading-zero skip, unlike
`scalar_mul`): `partial_dbl`, each point's digit add in `j` order with `Z == 1` flags
`n == ±1`, the final mul projective except at bit 0.

## Syscall wrapper checks (not translated)

`fd_vm_syscall_sol_curve_validate_point` (`fd_vm_syscall_curve.c:8`):
1. BLS ids while `enable_bls12_381_syscall` is inactive → `ERR_INVALID_ATTRIBUTE` (hard error).
2. Edwards / Ristretto: charge `…_VALIDATE_POINT_COST` (budget exceeded → hard error), then
   translate 32 bytes at `point_addr` for load (fault → `ERR_SEGFAULT`); `r0 = !validate(point)`
   (0 valid, 1 invalid), return success. Unknown id → `ERR_INVALID_ATTRIBUTE`.

`fd_vm_syscall_sol_curve_group_op` (`:80`):
1. BLS gate as above.
2. Unknown `(curve_id, group_op)` → `ERR_INVALID_ATTRIBUTE`, before any CU charge.
3. Charge the op's cost; translate `inputL` and `inputR` (32 bytes each; `inputL` is the scalar
   for MUL) for load — both before any crypto.
4. ADD/SUB: decode L, then R (either fails → `r0 = 1`, success, nothing written). MUL:
   `fd_curve25519_scalar_validate(L)` first, then decode R (fail → `r0 = 1`).
5. Only then translate `result` (32 bytes, `HADDR_QUERY_U8_ARRAY`, mutable); compute, `tobytes`
   into it, `r0 = 0`. A bad result address is thus only faulted on the success path.

`fd_vm_syscall_sol_curve_multiscalar_mul` (`:534`):
1. `points_len > 512` → `ERR_INVALID_LENGTH` (checked before the curve id).
2. Curve id not Edwards/Ristretto → `ERR_INVALID_ATTRIBUTE` (no BLS here).
3. Charge `sat_add(base, sat_mul(incr, sat_sub(points_len, 1)))`.
4. `points_len == 0`: translate `result` for store (`MEM_HADDR_ST`), write `01 00…00` (Edwards)
   or `00…00` (Ristretto), `r0 = 0`; no crypto, inputs not translated.
5. Translate `points_len*32` bytes of scalars and of points for load.
6. Helper returns NULL → `r0 = 1`, nothing written; else translate `result` and `tobytes`, `r0 = 0`.

## Suspicious or noteworthy in the C

- `fd_f25519.h:195-196` and `:256-257` say `fd_f25519_sqrt_ratio` "returns 0 on success, 1 on
  failure"; the code returns 1 when `u/v` is a square (`fd_f25519.c:331`), and every caller
  (frombytes, ristretto, `is_square_var`'s fallback) uses it that way. Comment only.
- `fd_ed25519_point_validate` replaces decoding by a Jacobi symbol; its equivalence with
  `frombytes(...) != NULL` rests on `v = d y² + 1 ≠ 0` (`fd_curve25519.c:68-73`). Checked on 29
  inputs here; to be proved.
- `fd_f25519_jacobi_var` returns 0 if 25 batches do not converge; `is_square_var` then falls
  back to `sqrt_ratio(a, 1)`. Translated; the fallback is believed unreachable.
- frombytes accepts non-canonical `y` and `x = 0` with the sign bit set (documented Dalek
  compatibility, `fd_curve25519.c:53-57`); ristretto frombytes requires canonical, even `s`.
- `with_opts` passes `b_Z_is_one = (n == ±1)` for `ai[j][0]`, valid only for affine `a[j]`
  (`fd_curve25519.h:225-229`); syscall points come from frombytes (`Z = 1`). Not checked in C.
- `scalar_mul`/`with_opts` index `ai[|d|/2]`: in bounds only because width-4 wNAF digits are
  odd and `|d| ≤ 15` (`aiTable` is total, so the Lean would not show an overrun).
- wNAF drops scalar bit 255; harmless after `scalar_validate` (`s < ℓ`), which every syscall
  path does first.
- The syscall helper batches by 32 and `fd_ed25519_multi_scalar_mul` batches by 32 again
  (redundant, harmless). On a bad point in a later batch the earlier batches were already
  computed (work, not result).

## Sanity checks (kernel evaluation)

`#eval` of these defs is exponential: the reused specs return `Fin 5 → BitVec 64` closures,
compiled as functions of the limb index, so every use re-runs the producer (`pow22523`'s 250
squarings alone make it infeasible; `Tests/fd_ed25519_double_scalar_mul_base.lean` memoizes at
the point level for this reason, which does not reach inside `pow22523`). `decide +kernel`
works: the kernel caches whnf of closed terms. Checked (scratch file, deleted), each against the
C test vectors:
- ristretto `B[2]` decode/encode round trip; non-canonical `00ff…ff` rejected;
- ristretto add, sub, `0 + P` (`test_vm_syscall_curve.c:307-415`);
- `13·B[1] = B[13]`, `(ℓ-1)·B[1] = 0 - B[1]` (`test_ristretto255.c:353-365`);
- edwards and ristretto MSM, 2 points (`test_vm_syscall_curve.c:221-305`); an invalid scalar
  (`ℓ`) gives NULL;
- 33 terms `1·B` across the batch boundary = `scalar_mul(33, B)`;
- ed25519 base point validate/decode/encode; `y = 2` invalid; `validate` agrees with
  `frombytes ≠ NULL` on 29 encodings (incl. `p`, `p+1`, sign bit set);
- `fd_f25519_inv.spec d` = `fd_f25519_inv.s2n d` (by `#eval`) = Python's `d⁻¹`; `inv 0 = 0`;
- a deliberately false claim is rejected.
Times: 1–30 s each, the 33-point MSM ~100 s.

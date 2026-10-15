# secp256k1 recover: C → Lean

Source: `~/firedancer/src/ballet/secp256k1` at ac6d4a84b. Namespace `Firedancer.Secp256k1`
(backend wrappers in `.S2n` / `.Ref`). Paths below are relative to `src/`.

## Conventions

- A C array `T a[n]` is `Vector T n`; `fd_uint256_t` is its `limbs` view `Vector (BitVec 64) 4`,
  `buf` is derived (little-endian, x86-64 and aarch64). `ulong`/`uint64_t` = `BitVec 64`,
  `uchar`/`schar` = `BitVec 8`, `int` = `BitVec 32`, `long` loop counters as `Nat` where they
  are provably ≥ 0 in the body.
  `Fin n → BitVec 64` closures are not used for data. The compiler turns a def returning a
  function into one taking the index, so each limb read re-ran the producer. `#eval` was
  exponential in the chain length.
- A function writing through `r` returns the value written; pointer returns are `Option`
  (`none` = `NULL`) inside a `Result` structure that also holds what was written on the
  `NULL` path.
- Shared code takes `B : Backend` (`Private.lean`), the fp_/scalar_ functions the backend
  defines. Instances: `S2n.backend adx`, `Ref.backend`. Entry points:
  `fd_secp256k1_recover.s2n adx`, `fd_secp256k1_recover.ref`.
  `adx` = `__ADX__` defined. Without it, `fd_secp256k1_s2n.c:8-13` redirects
  montmul/montsqr/tomont/triple to `_alt`. arm is always `adx = false`.
- Library models (`S2n.lean`, `Fiat.lean`): `if Pre then <canonical contract value> else
  <name>_unspec inputs`, with an opaque `_unspec`. The only other opaque is
  `fd_secp256k1_point_table_oob_unspec`, an out-of-bounds read of `pc[9]` (UB).
- Left out: `fd_msan_unpoison` (no-op outside MSan, `util/sanitize/fd_msan.h:72`). No
  Firedancer asm or intrinsic branch is reached. `__builtin_bswap64` is translated by its
  semantics. fiat's `value_barrier` inline asm is inside the contract-modelled code.

## Functions

| C (file:line) | Lean | Notes |
|---|---|---|
| bits/fd_bits.h:241 `fd_ulong_bswap` | `fd_ulong_bswap.spec` | byte reversal |
| bits/fd_bits.h:202 `fd_ulong_if` | `fd_ulong_if.spec` | `c ? t : f` |
| bigint/fd_uint256.h:31 `fd_uint256_bswap` | `fd_uint256_bswap.spec` | reads all before writing; alias-safe |
| fd_uint256.h:61 `fd_uint256_eq` | `fd_uint256_eq.spec` | int 0/1 |
| fd_uint256.h:77 `fd_uint256_cmp` | `fd_uint256_cmp.spec` | loop unrolled; int −1/0/1, compared with `sle` |
| private.h:23-79 constants | `fd_secp256k1_const_*` | limbs copied verbatim (Montgomery where the C is) |
| point.c:41 `fd_secp256k1_fp_sqrt` | `fd_secp256k1_fp_sqrt.spec` | `for j<k sqr` = `B.fp_sqr^[k]`; `r` written on both paths |
| point.c:109/117/125 set_identity/set_base/set | `fd_secp256k1_point_set_*.spec` | |
| point.c:134 `fd_secp256k1_point_add` | `fd_secp256k1_point_add.spec` | a, b read before first store (l.203): pure even for `r==a` |
| point.c:216 `fd_secp256k1_point_dbl` | `fd_secp256k1_point_dbl.spec` | `r->z` stored at l.253 before `a->x,a->y` read at l.260. For `r==a` those are unchanged, so pure |
| point.c:271/281 neg/sub | `fd_secp256k1_point_neg/sub.spec` | |
| point.c:292 `fd_secp256k1_slide` | `fd_secp256k1_slide.spec` | int promotions as `signExtend 32`, `(schar)` = `setWidth 8`, int `>>` = `sshiftRight` |
| point.c:313 `fd_secp256k1_precompute` | `fd_secp256k1_precompute.spec` | `Vector _ 9` built by `set` in loop order |
| point.c:329/348 `fd_secp256k1_double_base_mul` | `.spec` + `.loop` | loop recursion on `pos` (64→0), break at 0 before the 4 dbls. `pc[(ulong)slot]` via `fd_secp256k1_point_table_read` |
| point.c:374 `fd_secp256k1_point_to_affine` | `fd_secp256k1_point_to_affine.spec r a` | `r->z` kept; call site `(pubkey, pubkey)` |
| point.c:384 `fd_secp256k1_point_is_identity` | `fd_secp256k1_point_is_identity.spec` | int `&`/`|` |
| fd_secp256k1.c:6 `fd_secp256k1_recovery_y` | `fd_secp256k1_recovery_y.spec B r x odd` | on NULL only `r->y` written (unobservable: caller returns) |
| fd_secp256k1.c:29 `fd_secp256k1_recover` | `fd_secp256k1_recover.spec B public_key msg sig id` | `public_key` written only on success, after the last read of `msg`/`sig`, so aliasing is harmless. `a` starts as `default` (uninitialized, fully written on success) |
| s2n.c:18-237 (all wrappers) | `S2n.fd_secp256k1_*.spec` | see call sites |
| pcurves/fd_pcurve_ref_util.h:20 `fd_pcurve_ref_reduce_once` | `Ref.fd_pcurve_ref_reduce_once.spec` | n=4 (only call), loops unrolled; `r==a` safe |
| fd_pcurve_ref_util.h:50 `FD_PCURVE_REF_DEFINE_POW` | `Ref.fd_pcurve_ref_pow.spec` | table loop unrolled; `r` stored last so `r==a` safe |
| ref.c:18-223 (all wrappers) | `Ref.fd_secp256k1_*.spec` | see call sites |

## Library call sites and the Pre to discharge

"< p", "< n" mean `limbsEval … <` the modulus. Every s2n/fiat output is < its modulus when
its Pre holds. All fp constants used are < p and `rr_mont` < n (checked numerically).

s2n (`fd_secp256k1_s2n.c`). Fixed-size routines load every input before the first store
(checked in the x86 and arm asm), so their in-place calls need no alias condition.
- l.51 `bignum_modinv(4, r, a, n, t[12])` in scalar_invert(rn, rs): n odd, n > 1,
  gcd(rs, n) = 1 (0 < rs < n from frombytes, n prime), 12 ≥ 3·4, no overlap (rn ≠ rs).
- l.61 `bignum_montmul(4, r, a, b, n)` in scalar_mul: a·b ≤ 2^256·n (rn, msg, s < n), n odd,
  `r` disjoint from a, b (fd_secp256k1.c:86,88).
- l.79 `bignum_sub(4, t, 4, n, 4, a)`: no Pre. l.81 `bignum_mod_n256k1_4(r, t)`: no Pre.
- l.93 `bignum_montmul(4, r, t, rr_mont, n)` in scalar_tomont: t·rr ≤ 2^256·n (t < n:
  msg after reduce, s and rs from frombytes; rr < n), n odd. The copy into `t` keeps it
  disjoint even for `tomont(x, x)`.
- l.101 `bignum_demont(4, r, a, n)`: n odd, r disjoint from n. Called with `r == a`
  (fd_secp256k1.c:90-91). Allowed in the model: the asm copies x to z first.
- l.110 `bignum_mod_n256k1_4`: no Pre.
- l.139 add / l.149 sub (`include/s2n-bignum.h:832`) / l.158 double / l.186 neg: inputs < p.
- l.168 montmul_p256k1(_alt): x·y ≤ 2^256·p (holds if x, y < p). l.177 montsqr: x² ≤ 2^256·p.
- l.194, 205, 219 `bignum_demont_p256k1`: input < p (r->y, a->z, pubkey x/y).
- l.208 `bignum_modinv(4, r, ad, p, t[12])` in fp_invert: p odd > 1, gcd(ad, p) = 1, i.e.
  `pubkey.z ≠ 0`. That holds because `is_identity` returned 0 and z < p. Also 12 ≥ 12 and
  no overlap.
- l.210, 239 tomont_p256k1(_alt), l.230 triple_p256k1(_alt): no Pre.

fiat (`fd_secp256k1_ref.c`, all Pre "every input < m"; m = p for `fiat_secp256k1_montgomery_*`,
n for `_scalar_*`; set_one has none):
- l.80 scalar to_montgomery(t, a) in scalar_invert: rs < n. l.81 pow → scalar mul/square
  (`fd_pcurve_ref_util.h:58,62,64`): tbl/acc are set_one or fiat outputs, a = t < n.
  l.82 from_montgomery(t): t < n.
- l.91 scalar_mul: rn, msg, s < n. l.100 scalar_opp: u1 < n. l.107 scalar to_montgomery: msg
  < n needs `reduce_once` to give < n (true for 256-bit inputs, 2^256 < 2n), s < n, rn < n.
  l.114 from_montgomery: u1, u2 < n.
- l.142 add, l.151 sub, l.159 add(a,a), l.168-169 triple's two adds, l.178 mul, l.186 square,
  l.194 opp: inputs < p.
- l.201, 226 from_montgomery: r->y, pubkey x/y < p.
- l.210 pow(a->z, p−2) → fiat mul/square: a->z < p.
- l.218 to_montgomery(r, rs) (fd_secp256k1.c:48): rs < n < p.

Why fp values stay < p in the shared code: the inputs are constants, `fp_tomont(rs)`, and
`fp_add(r, n_mont)`. Every other fp value is a library output. Points fed to
`double_base_mul` have coordinates < p.

Other proof obligations:
- `fd_secp256k1_point_table_read`: slide digits are in [−8, 8] for any 32 input bytes, so
  `|slot| ≤ 8` and the `_unspec` branch is unreachable.

## Suspicious or noteworthy (translated as written)

1. s2n `scalar_demont` calls `bignum_demont` in place (z = x). The banner says nothing about
   aliasing. It is safe only because the asm copies x→z first. Firedancer itself notes that
   `bignum_montmul` has an undocumented no-alias restriction (s2n.c:89). The aliasing
   conditions in `S2n.lean` come from reading the asm, plus recollection of the HOL specs,
   which are not vendored.
2. x86 `bignum_montmul_p256k1{,_alt}.S` banner says `p_256k2` (typo; arm and s2n-bignum.h
   say `p_256k1`). The `.S` banner of `bignum_sub_p256k1` omits "assuming x and y reduced";
   s2n-bignum.h:832 has it, and the model uses it.
3. `bignum_montmul`/`bignum_demont` banners do not require `m` odd. The models do, since
   2^{-64k} mod m otherwise does not exist.
4. point.c:188 comment "Z3 = t1 * t2" but the code (and Algorithm 7) adds. point.c:305
   comment says digits in [−8, 8]; they are in [−8, 7], with the top carry in {0, 1}.
5. private.h:14 calls the points Jacobian, but the formulas (RCB 2015/1060) and
   `to_affine` (x/z, y/z) are homogeneous projective.
6. `point_is_identity` also accepts z ≠ 0 with x = 0, y ∈ {0, 1·R}. 7 is a non-residue
   mod p, so no curve point has x = 0 and this clause fires only off-curve.
7. The backends differ off the happy path. s2n `scalar_reduce` is a full mod n, ref is one
   conditional subtraction (they agree on 256-bit inputs). ref `fp_invert(0)` = 0 by
   Fermat, while s2n `bignum_modinv(0, p)` is outside its contract; unreachable here.
8. `rs` is used unchanged (not `r`) for the inverse after the `recovery_id & 2` bump, as the
   C comment says.

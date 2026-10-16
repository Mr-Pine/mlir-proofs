# ZK ElGamal sigma verifiers: C → Lean translation notes

Firedancer `ac6d4a84b` (the files below are byte-identical at `2d3b8a36e6`). Paths are relative to
`firedancer/src/`. All Lean names live in `MLIR.Firedancer.Ref` (the FIPS 202 file in
`MLIR.Firedancer.Math.KeccakF`). Range proofs are out of scope.

## C → Lean

| C (file:line) | Lean | |
|---|---|---|
| `ballet/keccak256/fd_keccak256_private.h:8` `fd_keccak256_rc` | `fd_keccak256_rc` | new |
| `util/bits/fd_bits.h:209` `fd_ulong_rotate_left` | `fd_ulong_rotate_left.spec` | new |
| `fd_keccak256_private.h:31` `fd_keccak256_core` (no s2n) | `fd_keccak256_core.spec` (+ `rho_consts`, `pi_consts`) | new |
| `fd_keccak256_s2n.c:10` `fd_keccak256_core` (s2n) | `fd_keccak256_core.s2n` | new |
| s2n-bignum `sha3_keccak_f1600` | `sha3_keccak_f1600.spec` (= `keccak 24`), `sha3_keccak_f1600.{round_constants,keccak_round,keccak}` | new, contract model |
| FIPS 202 §3 | `Math.KeccakF.{θ,ρ,π,χ,ι,rc,RC,Rnd,keccakF}` | new (`Firedancer/Math/KeccakF.lean`) |
| `ballet/merlin/fd_merlin.h:8,19` structs | `fd_merlin_strobe128_t`, `fd_merlin_transcript_t` | new |
| `fd_merlin.h:6` `FD_MERLIN_LITERAL` | `FD_MERLIN_LITERAL` | new |
| `ballet/merlin/fd_merlin.c:17,27,40,54,88,99,110,121` | `strobe128_{run_f,absorb,squeeze,begin_op,meta_ad,ad,prf,init}` | new |
| `fd_merlin.c:141,149,160,168` | `fd_merlin_transcript_{init,append_message,append_u64,challenge_bytes}` | new |
| `ballet/zksdk/rangeproofs/fd_rangeproofs_transcript.h:42,50,62,74` | `fd_rangeproofs_transcript_{append_point,validate_and_append_point,append_scalar,challenge_scalar}` | new |
| `ballet/zksdk/transcript/fd_zksdk_transcript.h:11-18` `#define`s | `abbrev`s of the same names | new |
| `fd_zksdk_transcript.h:31,40,48,56,68-100` | `fd_zksdk_transcript_{init,append_pubkey,append_ciphertext,append_commitment,domsep_*}` | new |
| `ballet/ed25519/fd_curve25519_scalar.h:13,18,26` | `fd_curve25519_scalar_{zero,one,minus_one}` | new |
| `ballet/ed25519/fd_curve25519_scalar.c:113` `fd_curve25519_scalar_muladd` | `fd_curve25519_scalar_muladd.spec` | new |
| `fd_curve25519_scalar.h:110,117,124,132,139,145` | `fd_curve25519_scalar_{mul,add,sub,neg,set,from_u64}.spec` | new |
| `fd_curve25519_scalar.h:59` `_validate`, `.c:4` `_reduce` | `fd_curve25519_scalar_{validate,reduce}.spec` | reused |
| `fd_ristretto255.c:4` `_frombytes` (= `_decompress`, `.h:37`) | `fd_ristretto255_point_frombytes.spec` (`abbrev fd_ristretto255_point_decompress`) | reused |
| `fd_ristretto255.h:69` `_point_eq` | `fd_ristretto255_point_eq.spec` | reused |
| `fd_curve25519.c:387` `fd_ed25519_multi_scalar_mul` (= ristretto MSM, `.h:36`) | `fd_ed25519_multi_scalar_mul.spec` (`abbrev fd_ristretto255_multi_scalar_mul`) | reused |
| `fd_ristretto255.h:31` `_point_set` (`fd_ed25519_point_set`) | `fd_ristretto255_point_set` = identity (per `fd_ed25519_point_set.call_eq`) | new alias |
| `fd_ristretto255.h:19` `fd_ristretto255_compressed_zero` | same name | new |
| `zksdk/fd_zksdk_common.h:7,8`, `fd_zksdk_private.h:9,10`, `rangeproofs/fd_rangeproofs_table_ref.c:9,21` | `FD_ZKSDK_VERIFY_PROOF_{SUCCESS,ERROR}`, `fd_zksdk_basepoint_{G,H}` | new |
| `zksdk/instructions/fd_zksdk_zero_ciphertext.{h,c}` | `Firedancer/Ref/fd_zksdk_zero_ciphertext.lean` | new |
| `…/fd_zksdk_ciphertext_ciphertext_equality.{h,c}` | `fd_zksdk_ciphertext_ciphertext_equality.lean` | new |
| `…/fd_zksdk_ciphertext_commitment_equality.{h,c}` | `fd_zksdk_ciphertext_commitment_equality.lean` | new |
| `…/fd_zksdk_pubkey_validity.{h,c}` | `fd_zksdk_pubkey_validity.lean` | new |
| `…/fd_zksdk_percentage_with_cap.{h,c}` | `fd_zksdk_percentage_with_cap.lean` | new |
| `…/fd_zksdk_grouped_ciphertext_2_handles_validity.c` (+ structs of `fd_zksdk_batched_grouped_ciphertext_validity.h`) | `fd_zksdk_grouped_ciphertext_2_handles_validity.lean` (incl. `…_direct_…`) | new |
| `…/fd_zksdk_grouped_ciphertext_3_handles_validity.c` | `fd_zksdk_grouped_ciphertext_3_handles_validity.lean` (incl. `…_direct_…`) | new |
| `…/fd_zksdk_batched_grouped_ciphertext_{2,3}_handles_validity.c` | `fd_zksdk_batched_grouped_ciphertext_{2,3}_handles_validity.lean` | new |
| `flamenco/runtime/program/fd_zk_elgamal_proof_program.c:13` (instruction-data part) | `fd_zksdk_process_verify_proof` (+ `fd_zksdk_{context,proof}_sz`) | new |

Each verifier file holds, in C order: the packed proof/context structs (with `.ofBytes`, the cast
of the `void const *`), the static `*_hash_context`, `fd_zksdk_verify_proof_*`, and
`fd_zksdk_instr_verify_proof_*`. The static `grouped_ciphertext_validity_hash_context` and
`batched_grouped_ciphertext_validity_hash_context` exist in two translation units each, so they
are namespaced by file stem (`grouped_ciphertext_2_handles_validity.…` etc.).

## Modelling decisions

- **Bytes.** A buffer is a `List (BitVec 8)` in memory order. A 32-byte point/scalar/pubkey is a
  little-endian `BitVec 256` (`buf[k]` at bits `8k`), as in the reused ristretto/scalar specs; a
  ciphertext is a `BitVec 512` whose bytes `[0,32)` are the commitment (`extractLsb' 0 256`) and
  `[32,64)` the handle. `Ed25519.bytesLE` gives the bytes back; `ofBytesLE` the other way. `uint`
  lengths and the `uint`/`ulong` integers absorbed into Merlin are little-endian (x86-64, aarch64).
- **Mutation.** A function that writes `*transcript` returns the new transcript (first, when it
  also returns a value). Verifiers return `fd_zksdk_verify_result` = return code + final
  `*transcript`, on every path (failure paths included); `fd_zksdk_instr_verify_proof_*` returns
  only the `int` (its transcript is local).
- **Local arrays.** `scalars[]`/`points[]` are `Nat → _` updated with `fd_zksdk.store`, starting
  from `uninitScalars`/`uninitPoints` (stand-ins for uninitialised stack; never read). Dynamic
  indices (`idx++` in the 2-handle direct verifier) use `let mut idx : BitVec 64`. In-place scalar
  calls (`mul( &s[0], &s[0], zx )`) are the same function, since `muladd` loads before it stores.
  `uchar * c_eq = c;` in percentage_with_cap aliases `c`: the `sub` into `c_eq` overwrites `c`.
- **Control flow.** Each verifier is an `Id.run do` block with an early `return` per C `return`,
  in C order; `val |= …` keeps calling `validate_and_append_point` after a failure, as the C does.
  `||` chains of `fd_memeq` (no side effects) are `∨`.
- **`NULL`.** The direct grouped verifiers get `0#256` for the `NULL` `_hi`/`challenge_t`
  arguments when `batched = 0`; they are not read on that path.
- **Keccak core.** Merlin calls `fd_keccak256_core.s2n` (every x86-64/arm production build has
  `FD_HAS_S2NBIGNUM`). Its model is the s2n contract: `SHA3_KECCAK_F1600_SUBROUTINE_CORRECT` (x86
  and arm, `cba3956c`) says the 25 words become `keccak 24 A`; `keccak`/`keccak_round`/
  `round_constants` are transcribed from `{x86,arm}/proofs/utils/keccak_spec.ml` (identical
  definitions; files in `~/fd-specs/ref-crates/s2n-bignum/{x86,arm}/utils/`). Preconditions:
  `rc` holds `round_constants` (`fd_keccak256_rc_eq_round_constants`, by `decide`), the 200-byte
  state, the 192-byte table, the stack frame and the code don't overlap (the table is a separate
  `static const`). The portable `fd_keccak256_core.spec` is translated literally (loops as
  folds, `b`/`t` threaded); a no-s2n build would need `fd_keccak256_core.spec = .s2n` (checked by
  `#eval`, not proved) to reuse the Merlin defs.
- **Lists, not functions, for Keccak/Merlin state** so `#eval` and `decide +kernel` stay linear.
  `getD … 0` only ever reads in-bounds indices (Merlin's `pos ≤ 166`, index `≤ 167 < 200`).
- **Labels.** `FD_MERLIN_LITERAL s` = the ASCII bytes of `s` (`sizeof(s)-1` of them). Label
  lengths are taken from the list; message lengths are explicit `BitVec 32` as in the C calls.
- **Signed scalar arithmetic.** `long` is `BitVec 64` with wrapping, `>> 21` on `long` is
  `sshiftRight`, `(ulong)` casts are no-ops; same convention as the reused `scalar_reduce` spec.
  The dead `sK = 0L` resets in `muladd` are kept (linter silenced).
- **Basepoints.** `fd_zksdk_basepoint_{G,H}` are the `!FD_HAS_AVX512` table
  (`fd_rangeproofs_table_ref.c`), struct fields `X, Y, T, Z` in declaration order (= `PointLimbs`).
- **Instruction wrapper.** `fd_zksdk_process_verify_proof` models only the instruction-data path;
  `Result` is `err code`, `proofAccount` (5-byte data: account path, not modelled), `rangeProof`
  (out-of-scope verifier called) or `verified` (context-state account code follows).

## Transcript absorb sequences

Notation: `M(label, msg)` = `fd_merlin_transcript_append_message`: STROBE `meta-AD(label)`
(begin_op `M|A`), `meta-AD(LE32(|msg|))` (more), `AD(msg)` (begin_op `A`)
(`fd_merlin.c:149-157`). `U64(label, x)` = `M(label, LE64(x))` (`fd_merlin.c:160`).
`CH(label)` = `challenge_bytes(label, 64)`: `meta-AD(label)`, `meta-AD(LE32(64))`, `PRF(64)`
(begin_op `I|A|C`, forces `run_f`), then `fd_curve25519_scalar_reduce` of the 64 bytes
(`fd_rangeproofs_transcript.h:74-81`). `V(label, P)` = `validate_and_append_point`: if
`P == 0^32` nothing is absorbed and `-1` is or-ed into `val`, else `M(label, P)`
(`fd_rangeproofs_transcript.h:50-59`). Points/scalars are their 32 stored bytes, a ciphertext its
64, a grouped ciphertext its packed struct (commitment ‖ handle[0] ‖ handle[1] [‖ handle[2]]).

Every wrapper starts with `fd_zksdk_transcript_init(L)` (`fd_zksdk_transcript.h:31-36`):
STROBE init (`fd_merlin.c:121-136`: 18-byte `init` block, Keccak-f, `meta-AD("Merlin v1.0")`),
`M("dom-sep", "solana-zk-elgamal-proof-program-v1")` (`fd_merlin.c:141-145`),
`M("dom-sep", L)`. Domain separators `D(s)` = `M("dom-sep", s)`.

1. **zero_ciphertext** (`instructions/fd_zksdk_zero_ciphertext.c`): init `"zero-ciphertext-instruction"` (:122);
   `M("pubkey", pubkey)` (:8), `M("ciphertext", ciphertext)` (:9) [via :79];
   `D("zero-ciphertext-proof")` (:80); `V("Y_P", Y_P)` (:84), return if failed;
   `M("Y_D", Y_D)` (:88, not validated); `c = CH("c")` (:92); `M("z", z)` (:94); `w = CH("w")` (:96).
2. **ciphertext_ciphertext_equality** (`…_ciphertext_ciphertext_equality.c`): init
   `"ciphertext-ciphertext-equality-instruction"` (:162); `M("first-pubkey", pubkey1)` (:10),
   `M("second-pubkey", pubkey2)` (:11), `M("first-ciphertext", ciphertext1)` (:12),
   `M("second-ciphertext", ciphertext2)` (:13) [via :104]; `D("ciphertext-ciphertext-equality-proof")` (:105);
   `V("Y_0")` `V("Y_1")` `V("Y_2")` `V("Y_3")` (:109-112), return if any failed; `c = CH("c")` (:119);
   `M("z_s")` `M("z_x")` `M("z_r")` (:121-123); `w = CH("w")` (:125).
3. **ciphertext_commitment_equality** (`…_ciphertext_commitment_equality.c`): init
   `"ciphertext-commitment-equality-instruction"` (:145); `M("pubkey")` (:9), `M("ciphertext")` (:10),
   `M("commitment")` (:11) [via :97]; `D("ciphertext-commitment-equality-proof")` (:98);
   `V("Y_0")` `V("Y_1")` `V("Y_2")` (:102-104), return if any failed; `c = CH("c")` (:111);
   `M("z_s")` `M("z_x")` `M("z_r")` (:113-115); `w = CH("w")` (:117).
4. **pubkey_validity** (`…_pubkey_validity.c`): init `"pubkey-validity-instruction"` (:84);
   `M("pubkey", pubkey)` (:7) [via :30]; `D("pubkey-proof")` (:31) — both *before* the
   zero/scalar/decompress checks (:34-50); `V("Y", Y)` (:55), return if failed; `c = CH("c")` (:61).
   No `w`.
5. **percentage_with_cap** (`…_percentage_with_cap.c`): init `"percentage-with-cap-instruction"` (:163);
   `M("percentage-commitment")` (:10), `M("delta-commitment")` (:11), `M("claimed-commitment")` (:12),
   `U64("max-value", max_value)` (:13) [via :93]; `D("percentage-with-cap-proof")` (:94);
   `V("Y_max_proof", y_max)` (:101), `V("Y_delta", y_delta)` (:102), `V("Y_claimed", y_claimed)` (:103),
   return if any failed; `c = CH("c")` (:110); `M("z_max")` (:112), `M("c_max_proof", c_max)` (:113),
   `M("z_x")` (:114), `M("z_delta_real", z_delta)` (:115), `M("z_claimed")` (:116); `w = CH("w")` (:118).
6. **grouped_ciphertext_2_handles_validity** (`…_grouped_ciphertext_2_handles_validity.c`): init
   `"grouped-ciphertext-validity-2-handles-instruction"` (:223); `M("first-pubkey", pubkey1)` (:9),
   `M("second-pubkey", pubkey2)` (:10), `M("grouped-ciphertext", 96 bytes)` (:11) [via :27]; then the
   direct verifier: `D("validity-proof")`, `U64("handles", 2)` (:166 → `fd_zksdk_transcript.h:84-85`);
   `V("Y_0")` `V("Y_1")` (:170-171), return if failed; `M("Y_2", Y_2)` (:176, not validated);
   `c = CH("c")` (:180); `M("z_r")` `M("z_x")` (:182-183); `w = CH("w")` (:185).
7. **batched_grouped_ciphertext_2_handles_validity** (`…_batched_grouped_ciphertext_2_handles_validity.c`):
   init `"batched-grouped-ciphertext-validity-2-handles-instruction"` (:63); `M("first-pubkey")` (:10),
   `M("second-pubkey")` (:11), `M("grouped-ciphertext-lo", 96)` (:12), `M("grouped-ciphertext-hi", 96)` (:13)
   [via :34]; `D("batched-validity-proof")`, `U64("handles", 2)` (:35 → `fd_zksdk_transcript.h:90-91`);
   `t = CH("t")` (:39); then the direct verifier's sequence of item 6 from `D("validity-proof")` on
   (`…_grouped_ciphertext_2_handles_validity.c:166-185`).
8. **grouped_ciphertext_3_handles_validity** (`…_grouped_ciphertext_3_handles_validity.c`): init
   `"grouped-ciphertext-validity-3-handles-instruction"` (:228); `M("first-pubkey")` (:11),
   `M("second-pubkey")` (:12), `M("third-pubkey")` (:13), `M("grouped-ciphertext", 128)` (:14) [via :35];
   direct: `D("validity-proof")`, `U64("handles", 3)` (:169); `V("Y_0")` `V("Y_1")` `V("Y_2")` (:173-175),
   return if failed; `M("Y_3", Y_3)` (:180, not validated); `c = CH("c")` (:184); `M("z_r")` `M("z_x")`
   (:186-187); `w = CH("w")` (:189).
9. **batched_grouped_ciphertext_3_handles_validity** (`…_batched_grouped_ciphertext_3_handles_validity.c`):
   init `"batched-grouped-ciphertext-validity-3-handles-instruction"` (:71); `M("first-pubkey")` (:12),
   `M("second-pubkey")` (:13), `M("third-pubkey")` (:14), `M("grouped-ciphertext-lo", 128)` (:15),
   `M("grouped-ciphertext-hi", 128)` (:16) [via :39]; `D("batched-validity-proof")`, `U64("handles", 3)` (:40);
   `t = CH("t")` (:44); then item 8 from `D("validity-proof")` on (`…_3_handles_validity.c:169-189`).

In items 1-3, 5-9 every zero check, scalar validation and decompression precedes the context
hash; in item 4 the hash comes first. In the grouped verifiers the zero checks on
pubkeys/commitments precede the context hash and the scalar/decompress checks follow it (inside
the direct verifier).

## Instruction wrapper (`fd_zk_elgamal_proof_program.c`)

Translated (`fd_zksdk_process_verify_proof`): `instr_id = instr_data[0]` (:19); the `switch`
(:29-68; `default`, including id 0, → `FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA` = -3);
`context_sz`, `proof_data_sz` from the size tables (:79-80; values checked against `gcc`
`sizeof`); `data_sz == 5` → account path (:85); else `data_sz != 1 + proof_data_sz` → -3 (:116-119);
`context = instr_data + 1`, `proof = context + context_sz` (:120, :132); verifier error → -3 (:133-138).
The `fd_zksdk_instr_verify_proof_*` functions themselves (transcript init, struct cast, verifier
call) are translated in full.

Not translated (runtime/accounts/context state):
- `fd_executor_zk_elgamal_proof_program_execute` (:312-403): feature gate
  `reenable_zk_elgamal_proof_program` (→ -3 + log), `instr_data_sz == 0` → -3, per-instruction
  `FD_EXEC_CU_UPDATE` (constants in `fd_zk_elgamal_proof_program.h:12-24`) and log literal,
  `CloseContextState` → `fd_zksdk_process_close_proof_context` (:197-304, all accounts).
- Account path of `fd_zksdk_process_verify_proof` (:85-110): borrow account 0, `accessed_accounts
  = 1`, `proof_data_offset` = LE u32 `instr_data[1..5]`, `offset + proof_data_sz > data_len` →
  `INVALID_ACC_DATA`, context read from account data. No per-proof length check here (C `TODO`,
  :127-131).
- Log messages "invalid proof data" (:117), "proof verification failed" (:136).
- Context-state creation when `instr_acc_cnt >= accessed_accounts + 2` (:142-189): borrow authority
  and proof-context accounts, owner check (`INVALID_ACC_OWNER`), `data_len < 33`
  (`INVALID_ACC_DATA`), `data[32] != 0` (`ACC_ALREADY_INITIALIZED`), write authority ‖ `instr_id` ‖
  context bytes, `data_len != 33 + context_sz` (`INVALID_ACC_DATA`), `set_data_from_slice` errors.

## Suspicious / worth a look in the conformance review

- `val |= validate_and_append_point(…)` keeps appending later points after a zero point (Rust
  `?` stops at the first). Unobservable: the verifier then returns `-1` and the wrapper drops the
  transcript.
- pubkey_validity hashes the context and domain separator before the identity check (the other
  verifiers check first). Unobservable for the same reason.
- ciphertext_ciphertext_equality does not zero-check `ciphertext2` (Rust does the same, with a
  comment that it is allowed).
- Grouped 2-handle: `pubkey2`, `Y_2`, `handle2`, `handle2_hi` are never zero-checked; the C
  comment "When pubkey2 is 0, also proof->y2, handle2 and handle2_hi should be 0" (:144) is not
  enforced. The MSM always includes `pub2` and `h2` (9 or 12 terms; the 8f92ee371 fix).
  Grouped 3-handle: `pubkey3`, `Y_3` never zero-checked; MSM always 12/16 terms.
- The batched 3-handle wrapper zero-checks `pubkey2`, the batched 2-handle one does not
  (consistent with the non-batched forms).
- The account path has no sigma-proof length check (C `TODO`).
- `fd_curve25519_scalar_muladd` uses signed `long` arithmetic; with the callers' inputs
  (validated scalars, reduced challenges, `muladd` outputs, `from_u64`) no product or sum exceeds
  ~2^47, so the wrapping model never wraps there; not proved.
- Basepoints are taken from the ref table; an `FD_HAS_AVX512` build uses
  `fd_rangeproofs_table_avx512.c` (different representation, not modelled).

## Checks run (scratch files, deleted)

- Keccak (`#eval`, ~1 s total): `fd_keccak256_core.s2n` of the zero state starts
  `f1258f7940e1dde7 84d5ccf933c0478a` (Keccak team KAT); `.spec = .s2n` and both = FIPS 202
  `keccakF` on 7 states (zero, all-ones, 0..24, 4 pseudo-random); FIPS-derived `RC i` =
  `fd_keccak256_rc`; Keccak-256 sponge (as `fd_keccak256.c`) over `.s2n`/`.spec` matches
  `fd_keccak256_test_vector.c` for lengths 0, 1, 2, 128, 129, 1024.
- Merlin (`#eval`): `test_merlin.c` vector `d5a21972…0615`; a 300-byte message + `append_u64` +
  200-byte challenge (crosses `run_f` in absorb and squeeze) equals Firedancer's own `fd_merlin.c`
  compiled with `gcc` (portable Keccak) in a scratch harness.
- Scalars (`#eval`): `muladd(a,b,c) = (a·b+c) mod ℓ` on 576 combinations of edge values;
  `minus_one = ℓ-1`; `from_u64`.
- End to end (`decide +kernel`): the `test_zksdk.c` pubkey-validity vector returns 0 (20 s), with
  `proof[33] ^= 0xff` returns -1 (22 s); `test_grp_ciph_2h_validity_pubkey2_zero` (identity
  `pubkey2`, points built with `fd_ristretto255_point_tobytes.spec`, `c` from the Lean transcript in
  the test's order): case A returns 0 (66 s), forged cases B (`handle2 = G`) and C (`handle2 = H`)
  return -1 (148 s together).

## Audit

Independent audit at `bc35596` against Firedancer `2d3b8a36e6`. No transcription errors found; no
Lean file changed.

- Read line by line: every new def vs its C (branch order, early returns, `val |=`, failure-path
  transcripts, aliasing in `muladd`/`percentage_with_cap`, NULL `_hi` args only read under
  `batched`, MSM term lists and counts). Struct sizes/offsets and the size tables checked with
  `gcc` (`offsetof`/`sizeof`). `muladd` body diffed mechanically against the C (329 statements).
  `keccak_round`/`round_constants` diffed mechanically against `keccak_spec.ml`.
- Basepoints: Lean limbs = ref table; the AVX512 table (`r43x6` quad layout) holds the same X, Y,
  Z, T mod p for G and H. Ref H limbs exceed 2^51 (uncarried, < 2^52).
- Differential (`~/fd-specs/difftest-zksdk/`), both s2n and portable Keccak, all equal: Keccak
  1700 states (`.s2n`, `.spec`, `keccakF`), STROBE/Merlin 400 sequences (4930 states, `begin_op`
  at pos 163-165), transcript helpers 3155 outputs, `muladd` 3076, other scalar ops ~1300,
  reused `reduce` 1312 / `validate` 1445. UBSan: no signed overflow in `muladd` on 300k
  arbitrary 256-bit inputs, so the wrapping `long` model is never exercised. Verifiers by
  `decide +kernel`: 877 cases (16 valid vectors, 861 mutations reaching every early return),
  `fd_zksdk_process_verify_proof` 35 cases; the batched 3-handle valid case needs
  `maxRecDepth` raised (kernel deep recursion, ~20 GB).
- vs Rust zk-sdk 5.0.1: `ciphertext_commitment_equality` weights its equations `w², w, 1` (C,
  Lean) where Rust uses `1, w, w²`; same accepts except on a w-dependent measure-zero set.

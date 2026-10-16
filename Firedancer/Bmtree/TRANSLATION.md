# fd_bmtree: C → Lean

Source: `~/firedancer` at 1be38beb58. Agave at 6bc983f254 (`~/firedancer/agave`). Paths are
relative to `src/`. Namespace `Firedancer.Bmtree`. Pure Lean, core only (no Mathlib). Build:
`lake build Firedancer.Bmtree.Bmtree`.

Files:
- `Basic.lean`: `Outcome`, the `util/bits` helpers, and byte-region accesses.
- `Sha256.lean`: the hash interface, the batch-API model, and the portable SHA-256.
- `Bmtree.lean`: the tree.

## Conventions

- **Types.** `ulong` = `BitVec 64`, `int` = `BitVec 32`, `uchar` = `BitVec 8`. Arithmetic
  wraps as in C. Loop counters that stay below 64 (`layer`, `i`, `p`) are `Nat`.
- **Results.** Every function returns `Outcome α`: `.ok a`, or `.ub site` for C undefined
  behaviour. A `ub` is never replaced by an arbitrary value.
- **Pointers.** A pointer is an `Array (BitVec 8)` (the bytes from the pointer to the end of
  its object) plus an offset. Reading or writing past the end is `ub`. Caller buffers are
  passed explicitly: `data`, `new_leaf`, `proof` (`NULL` = `#[]`) and `dest`.
- **Outputs.** A function returns what it writes. A pointer return is modelled by the 32
  bytes it points to at return; `NULL` is `none`. `*opt_root` is an `Option`.
- **Commit state.** `fd_bmtree_commit_t` holds the header fields, `node_buf : Vector node
  63`, and `ip_mem`. `ip_mem` is the caller's region from `&inclusion_proofs[0]` to the end
  of the footprint; node `k` is at byte `32k`. `inclusion_proofs_valid` is the bitmap's
  byte offset in `ip_mem` (`32·inclusion_proof_sz`). So the dummy node
  `inclusion_proofs[inclusion_proof_sz]` *is* bitmap words 0..3, as in C (see Findings).
  A footprint-sized region has `ip_mem.size = footprint − 2056`. A stack
  `fd_bmtree_commit_t` with layer count 0 has 32 bytes.
- **init.** `commit_init` takes the region's previous contents (`mem`). It writes only what
  C writes: the 4 header fields, the bitmap pointer, and the bitmap memset. `node_buf` and
  the nodes keep the old bytes.
- **Uninitialized locals.** Stack locals (`tmp[1]` in `from_proof`, `sibling`, `lvl`, `msg`)
  start as zeros (`node_uninit`). Their unwritten bytes are never read.
- **Bitwise conditions.** `&`/`|` on `int` conditions evaluate both sides, so both `HAS`
  reads are sequenced first. `&&`/`||` short-circuit.
- **Loops.** `while` loops are well-founded recursion (`.walk`, `.loop`); counted loops are
  `for` over ranges. No fuel and no `partial`.

## Functions

| C (file:line) | Lean | Notes |
|---|---|---|
| bmtree/fd_bmtree.h:139-142 | `FD_BMTREE_{LONG,SHORT}_PREFIX_SZ`, `fd_bmtree_{leaf,node}_prefix` | 32-byte arrays, 6 zero pad bytes |
| fd_bmtree.h:149 | `fd_bmtree_node_t` | `Vector (BitVec 8) 32` |
| fd_bmtree.h:189 | `fd_bmtree_commit_t` | see Conventions; `sizeof` 2088, `inclusion_proofs` at 2056 |
| fd_bmtree.h:301, :336 | `FD_BMTREE_COMMIT_FOOTPRINT`, `fd_bmtree_commit_leaf_cnt.spec` | |
| fd_bmtree.c:51 | `fd_bmtree_hash_leaf.spec` | `sha.hash (leaf_prefix[0,prefix_sz) ++ data[0,data_sz))` |
| fd_bmtree.c:78 | `fd_bmtree_private_merge.spec` | portable branch (:135); AVX branch (:117) below |
| fd_bmtree.c:147/156 | `fd_bmtree_depth.spec`, `fd_bmtree_node_cnt.spec` | `fd_ulong_if` evaluates both arms |
| fd_bmtree.c:179/182 | `fd_bmtree_commit_align.spec`, `fd_bmtree_commit_footprint.spec` | `1UL<<n`, `n≥64`: `ub` |
| fd_bmtree.c:196 | `fd_bmtree_commit_init.spec mem …` | `1UL<<n`, `n≥64`: `ub`; bitmap memset past the region: `ub` |
| fd_bmtree.c:222 | `fd_bmtree_private_commit_batch.spec` (`.layers`, `.chunks`, `.add`) | portable `memcpy` branch (:255) |
| fd_bmtree.c:277 | `fd_bmtree_commit_append.spec` (`.loop`, `.walk`) | batch iff `leaf_cnt==0 ∧ 8≤new_leaf_cnt≤64` |
| fd_bmtree.c:347 | `fd_bmtree_commit_fini.spec` (`.walk`) | `Result = {state, root}` |
| fd_bmtree.c:387 | `fd_bmtree_get_proof.spec` (`.walk`) | `Result = {ret : int, dest}`; portable `memcpy` (:412) |
| fd_bmtree.c:423 | `fd_bmtree_from_proof.spec` (`.loop`) | `none` = `NULL` |
| fd_bmtree.c:454 | `HAS`, `set_valid` | 8-byte LE bitmap words in `ip_mem` |
| fd_bmtree.c:457 | `fd_bmtree_commitp_insert_with_proof.spec` (`.proof_loop`, `.cache_loop`) | `Result = {ret, state, opt_root}`; state returned on failure too |
| fd_bmtree.c:540 | `fd_bmtree_commitp_fini.spec` (`.walk`, `.cache`, `.full_words`, `.layers`, `.idx_loop`) | `Result = {state, root?}` |
| util/bits/fd_bits.h, fd_bits_find_{lsb,msb}.h | `fd_ulong_{min,if,is_pow2,mask_lsb,insert_lsb,align_up,pow2_up,find_lsb,find_msb_w_default}`, bswaps, `shl`/`shr` | literal implementations (not the doc contracts) |
| util/tmpl/fd_smallset.c:160-200 | inside `HAS`/`set_valid`/`full_words` | `ipfset_MAX = 64`; `full = ~0` |
| ballet/sha256/fd_sha256.c:139 | `fd_sha256_core_ref` (`.block`) | `block_cnt==0` (do/while): reads past data, `ub` |
| fd_sha256.c:384/399/465/512 | `fd_sha256_init/append/fini/hash` | `fd_sha256_t.buf` as `Array`; `init` keeps `buf` and `magic` |
| fd_sha256.h:250/283/296 | `fd_sha256_batch_init/add/fini` | per the contract, see below |

## Hash interface

`structure Sha256` has three fields:
- `hash : Array (BitVec 8) → Vector (BitVec 8) 32`.
- `batch_max` (`FD_SHA256_BATCH_MAX`) and `batch_max_pos`.

Contract sources:
- **One-shot.** `fd_sha256.h:133-141`: `fd_sha256_hash` is "a streamlined implementation of
  init/append/fini". `:106-111`: "It does not matter how the user group data bytes ... the
  final hash will be identical". So `hash_leaf`'s and `merge`'s `init/append*/fini` chains
  are `sha.hash` of the concatenation. Zero-size appends return early (`fd_sha256.c:405`),
  which is consistent with this.
- **Batch.** `fd_sha256.h:252-296`:
  - `add` queues `(data, sz, hash)`; the message must not change until fini.
  - `fini` populates every hash region with its message's digest.
  - The order is up to the implementation. Overlapping hash regions are "indeterminant".

  The model queues `(msg bytes, slot)` and `fini` writes `sha.hash msg` into `next[slot]`.
  In `commit_batch` every slot is distinct and disjoint from the messages and from `cur`,
  so order and chunking cannot matter. `batch_max` still drives the `p0` chunk loop
  literally. Slot ≥ 32 is `ub` (unreachable: `merge_cnt ≤ 32`).
- **Instantiation.** `Sha256.portable` uses `fd_sha256_hash m 0 m.size` and `batch_max = 1`.
  The reference batch (`fd_sha256.h:321-348`) hashes inside `add` and `fini` is a no-op,
  which agrees with the model under the no-overlap condition above. This instance is the
  one to differential-test.

## Excluded SIMD paths and what production runs

- **SHA core** (`fd_sha256.c:105-115`): SHA-NI `fd_sha256_core_shaext` when `FD_HAS_SHANI`;
  ARM and RISC-V variants. Not translated.
- **SHA batch** (`fd_sha256.h:311-319`):
  - AVX512 (`fd_sha256_batch_avx512.c`, MAX 16) when `FD_HAS_AVX512`.
  - AVX (`fd_sha256_batch_avx.c`, MAX 8) when AVX, except under znver1-3 tuning.
  - Otherwise the reference (MAX 1).

  The AVX512 batch forwards small batches to the AVX batch, and the AVX batch hashes small
  batches one by one. Not translated.
- **Default build.** The default build is `MACHINE=native` (`Makefile:72`). Per target:

  | Target | Core | Batch |
  |---|---|---|
  | haswell-class (`linux_{gcc,clang}_x86_64`, `linux_clang_haswell`) | ref (translated) | AVX |
  | icelake, zen4, zen5 | SHA-NI | AVX512 |
  | zen2, zen3 | SHA-NI | ref |

  So production x86 runs the translated portable SHA core only on non-SHA-NI CPUs, and
  every x86 build runs the bmtree AVX branches below.
- **bmtree's own AVX code** (not translated; the `#else` branches are):
  - **`merge`** (`fd_bmtree.c:117-129`). It stores the 32-byte prefix, then `a` at
    `prefix_sz`, then `b` at `prefix_sz+hash_sz`, into `uchar mem[96]`, and hashes
    `prefix_sz+2·hash_sz` bytes. This equals the portable branch iff `prefix_sz ≤ 32`,
    `hash_sz ≤ 32` and `prefix_sz+hash_sz ≤ 64`. Outside that range, AVX hashes
    uninitialized `mem` bytes or overflows `mem` (the portable branch is `ub` there too).
    All callers use (1|26, 20|32).
  - **`commit_batch` message build** (`:250-253`). Same condition.
  - **`get_proof`** (`:399-410`). The AVX512 masked store of `mask_lsb(hash_sz)` bytes
    equals the `memcpy` for `hash_sz ≤ 32`.

## How callers use bmtree (Agave reference in parentheses)

- **Entry/PoH mixin.** Uses `(hash_sz 32, prefix 1, layer_cnt 0)` in three places:
  `discof/replay/fd_sched.c:3155-3196`, `discoh/bank/fd_bank_tile.c:185-205` and
  `discof/execle/fd_execle_tile.c:255-275`.
  - Leaves: `hash_leaf(signature, 64, 1)`, one append per leaf. A txn has 1..12 signatures,
    so the tree is never empty in replay. The bank tiles call fini only if `leaf_cnt≠0`.
  - The root (32 bytes) is mixed as `sha256(curr_hash‖root)`.
  - With `layer_cnt 0`, every `inclusion_proofs` write goes to the dummy, which is the
    bitmap.
  - Agave: `entry/src/entry.rs:262-297`, `merkle-tree/src/merkle_tree.rs:6-19,115-136`.
    Prefixes are 1 byte, nodes 32 bytes, and an odd last node pairs with itself.
- **Shred FEC sets.** Use `(20, 26, 7)`.
  - Leaf data is the shred bytes from 64 to the proof start.
  - The shredder (`disco/shred/fd_shredder.c:240-282`) does *one 64-leaf append on an empty
    tree*, i.e. the batch path, then fini and get_proof.
  - The FEC resolver (`disco/shred/fd_fec_resolver.c:646-1051`) works on network shreds:
    - `commitp_insert` with each shred's own proof (attacker bytes), `proof_depth` forced
      to 6, `shred_idx < 64`.
    - Recovered shreds are inserted with `proof=NULL, depth 0`.
    - Then `commitp_fini(tree, 64)` and get_proof.
  - `ballet/shred/fd_shred.c:107-129` does `commitp_insert` on gossip duplicate-shred
    proofs; `idx` is not range-checked there.
  - Agave: `ledger/src/shred/merkle_tree.rs:17-169`. It truncates children to 20 bytes
    before joining, returns a 32-byte root, and pairs an odd node with itself.
- **Block id (double Merkle).** Uses `(20, 26)` with raw leaves and no `hash_leaf`.
  - `discof/repair/fd_blockdb.c:158-177` (layer_cnt 12).
  - `choreo/rotor/fd_rotor.c:75-92` (layer_cnt 0, 32-byte leaves).
  - `from_proof` runs on network proofs in `choreo/rotor/fd_rotor_serde.c:236,256` and
    `discof/repair/fd_repair.c:281`; both check the proof size.
  - Agave: `ledger/src/blockstore.rs:2090-2111`.
- **Unused in production:** `fd_bmtree_node_cnt` and `fd_bmtree_commit_footprint`.

## UB cases modelled as `ub`

- **`commit_fini` with `leaf_cnt==0`.** It forms `node_buf + (0−1)` (`:352`), then
  `find_lsb(0)`.
- **`node_buf[63]`.**
  - In append, when `cursor` wraps to 0 (`leaf_cnt = 2^64−1`).
  - In fini for `leaf_cnt > 2^62` (`depth−1 = 63`).
  - At `node_buf[layer+1]` with `layer = 62`.
- **Shifts by ≥64.**
  - `init`/`footprint`/`FOOTPRINT` with `layer_cnt ≥ 64`.
  - `from_proof` at `layer = 63` (`proof_depth ≥ 64`, outside its documented `[0,63]`).
  - `get_proof` at `layer = 63` (`leaf_cnt > 2^63`).
  - The `commitp_fini` layer loop condition at layer 64.
- **Byte ranges.**
  - A prefix read past the 32-byte prefix arrays (`prefix_sz > 32`).
  - `msg` overflow (`prefix_sz+2·hash_sz > 96`).
  - Reads past `data`, `new_leaf`, `proof` or `dest`.
  - Any `ip_mem`/bitmap access past the region.
  - `fd_sha256_core_ref` with `block_cnt==0`.
- **Conservative, stricter than C.**
  - Any `hash_sz`-byte access of a node with `hash_sz > 32` is `ub`. The header documents
    `hash_sz <= 32`. In C some of these accesses only read into the neighbouring node.
  - `ip_get` copies 32 bytes where merge reads only `hash_sz`. This differs only for
    regions smaller than a footprint.
- **Unrealizable.** The `commitp_fini` `inc_idx` loop (`:613`) is `ub` when the step wraps
  or is 0. Reaching that needs `HAS` true on ~2^63 indices, i.e. a bitmap of ≥2^57 bytes.
  C would loop forever (forward-progress UB) or keep scanning.

## Findings (suspicious or worth a proof)

1. **The dummy node aliases the bitmap.**
   - `inclusion_proofs_valid = inclusion_proofs + inclusion_proof_sz` (`fd_bmtree.c:206`),
     so `inclusion_proofs[ip_sz]`, the "dummy index used to avoid branches"
     (`fd_bmtree.h:295`), is bitmap words 0..3.
   - Leaf-based writes clamp to it (`:233,263,315,330,376`), and the batch and loop paths
     leave different values there.
   - Harmless only because leaf-based calcs never read the bitmap and get_proof never reads
     index ≥ ip_sz. A leaf calc followed by a proof calc without re-init would see garbage
     bits.
   - The uncached `commitp_fini` path writes (`:597`) are not clamped. Brute force over
     ip_sz = 2^n−1, n ≤ 16, finds no index ≥ ip_sz there (the TODO at `:564` holds for
     those).
   - `commitp_insert` indices stay < ip_sz by `proof_depth < layer_cnt` and the `:502`
     break (the TODO at `:512` holds).
2. **`get_proof` breaks its header's promise.** `fd_bmtree.h:375-376` says `dest` is not
   modified when it returns −1. It writes the lower layers first. Checked by `#eval`:
   3 leaves, layer_cnt 2, leaf 0 gives −1 with `dest[0,32)` = leaf 1.
3. **`get_proof` returns `0` for `leaf_idx ≥ leaf_cnt`** (`:394`, `return 0UL` in an `int`
   function), which is also a valid 1-leaf proof size (FIXME at `.h:380`).
4. **`commitp_insert` with `idx ≥ 2^63`.** `2UL*idx` wraps, so `idx` and `idx−2^63` are the
   same leaf (checked: insert at 2^63 then a different leaf at 0 gives 0). Callers pass
   `idx < 2^32`.
5. **`commitp_insert` says "state will not be modified" on 0** (`.h:444`). It writes
   `node_buf[0..]` before failing. This is unobservable through the proof API, since every
   reader rewrites `node_buf` first.
6. **`from_proof` does not see the leaf count.**
   - For a leaf duplicated by odd self-pairing, index `i+1` with the same proof also
     verifies. E.g. 3 leaves: leaf 2's proof `[L2, H01]` verifies at index 3 (checked by
     `#eval`).
   - It hashes any extra `proof_depth` layers beyond `depth−1`.
   - Soundness statements need `leaf_idx < leaf_cnt` and an exact depth, which the callers
     must check.
7. **`node_cnt`/`depth` do no UB-relevant shifts** (`find_msb_w_default(0,-1)` gives
   `(ulong)(2+-1)`). `depth` evaluates both `fd_ulong_if` arms.

## Sanity checks run (`#eval`, portable SHA-256; scratch deleted)

- **SHA-256.** All 45 `fd_sha256_test_vector.c` vectors pass, plus FIPS "", "abc" and the
  448-bit message. Each was checked one-shot and by `init/append/fini` with chunks of
  1/7/63/64/65/200 bytes.
- **`test_bmtree.c`.**
  - 20-byte roots for 1/2/3/10 leaves, by commit and by commitp (even then odd inserts).
  - The 11-leaf 32-byte spec root `b40c8475…e1bc` (batch path).
  - All 11 proofs against `reference_proofs.bin`.
  - `test_append_batch` for 1..64 leaves × (20,26)/(20,1)/(32,1).
  - `test_inclusion` for 1..256 leaves, including the corrupted-proof/leaf/root cases and
    `from_proof(1234567)==NULL`.
  - depth/node_cnt against the naive loop for 2..9999.
  - `footprint(0)==FOOTPRINT(0)`.
  - `commit_fini` on 0 leaves gives `ub`.
- **Not run:** the 1,000,000-leaf root (too slow interpreted).

## Audit

Independent audit against `~/firedancer` 1be38beb58 (clean tree). The Agave checkout used is
6bc983f254, not the submodule pin c8630b6b36.

**Fixes: none.** Every def was read line by line against its C (`fd_bmtree.c:51-623`,
`fd_sha256.c:139-217,384-532`, `fd_sha256.h:321-348`, `fd_bits.h`, `fd_smallset.c`). No
transcription error was found, and the differential test found no Lean/C difference.

**Differential test** (`~/fd-specs/difftest-bmtree`, `run.sh SEED SECTION`). The compiled
Lean driver is compared with the C (`#include`d) built five ways:
- portable;
- AVX: bmtree AVX branches, AVX batch;
- zen3: SHA-NI core, reference batch;
- AVX512: SHA-NI core, AVX512 batch, masked `get_proof` store;
- portable under ASan/UBSan.

It compares outputs, return values, `dest` bytes and an FNV hash of the whole state region
(`node_buf` and `inclusion_proofs` through the end of the footprint, so this includes the
dummy/bitmap overlap). This holds on failure paths too. The generator (`gen/gen.py`) uses an
independent hashlib model for expected digests and roots.

Sections:
- `sha`: one-shot, streaming in random chunks, batch, `hash_leaf`.
- `tree`, `treeL`: leaf counts 1..300 and large counts, configs (32,1), (20,26) and odd
  ones, layer counts 0..13. Leaves are appended one at a time, in bulk (the batch path), or
  in random chunks. Then `fini`, `get_proof` on every index including out-of-range ones,
  and `from_proof` at the true index, at a phantom or neighbour index, at extra or short
  depth, and with corrupted proofs.
- `proof`: `from_proof` on arbitrary inputs, with indices up to 2^64-1 and depths up to 63.
- `commitp`, `fec`, `fecflow`: `commitp_insert` in random orders with valid, corrupted,
  truncated, deep, wrong-leaf and out-of-range/2^63-wrapping inserts, then `commitp_fini`.
  `fecflow` follows the FEC resolver: depth 6, 64 leaves, recovered leaves inserted with
  `NULL`.

Result: 751,987 commands over 19 seeded runs, each run on all five builds, with 0
differences:
- sha: 9,900.
- tree: 327,421 (5,715 trees, 101,873 `from_proof`, 103,769 `get_proof`).
- treeL: 128,781.
- proof: 9,000.
- commitp: 81,294.
- fec: 76,791.
- fecflow: 118,800 (900 sessions, 57,600 inserts).

All hashlib expectations hold. The exceptions are 9 `commitp` sessions in which an
unauthenticated first insert (a corrupted proof, or a depth-0 leaf) fixed a different tree,
as designed. ASan/UBSan stayed silent.

**Rulings on the modelling doubts.**
- The flat byte region with the dummy node aliasing the bitmap is what C does. The region
  hash matches in every leaf-tree case with a small layer count, where the clamped writes
  land on the bitmap.
- `hash_sz > 32` as `ub` is acceptable. The header says `<= 32`, every caller uses 20 or
  32, and the AVX merge loads only 32 bytes per child anyway.
- The `commitp_fini` `inc_idx` loop `ub` is unrealizable. Every `HAS` past the region is
  already `ub` first.
- Zero-initialised locals are sound. No unwritten byte reaches a hash or an output, also in
  the AVX branches, where the 32-byte loads past `hash_sz` land beyond the hashed length.
- Pointer returns as 32 bytes are fine for every caller. `commit_fini`'s root is copied
  right away, and `commitp_fini`'s is only tested against `NULL`.
- Modelling `hash_leaf` and `merge` as `sha.hash` of the concatenation, rather than the
  literal `init/append*/fini` chain, is backed by the `S`-vs-`H` tests.

**Rulings on the `ub` list.** Every listed case is UB in C. None is reachable from a caller:
- `commit_fini` on 0 leaves is guarded by the leaf-count checks in `fd_execle_tile.c` and
  `fd_bank_tile.c`, and by ≥1 signature per transaction in `fd_sched.c`.
- The `from_proof` depth is bounded by the callers' proof-size checks.
- The rest need more than 2^62 leaves.

Two notes:
- `fd_ulong_find_lsb(0)` is `ffsl-1 = -1` (defined) on non-BMI targets. It is reached only
  after the `node_buf-1` UB.
- `fd_ptr_if` forms the unselected out-of-object pointer (`:370,577`), which strictly is
  also UB. This is ignored, as everywhere else.

**Findings 1-7 confirmed** by the differential test:
- Finding 2: `get_proof` returns -1 after partial `dest` writes.
- Finding 4: an insert at 2^63+i is accepted as leaf i.
- Finding 6: phantom-index `from_proof`.

**Exploitability of the phantom index and the 2^63 wrap.** Neither is reachable:
- FEC resolver (`fd_fec_resolver.c:560,662-668,686`): requires 32:32, `in_type_idx < 32`
  and depth 6. A 64-leaf tree is full, so no node is self-paired, and `shred_idx < 64`.
- `fd_shred_merkle_root` (`fd_shred.c:107-129`, eqvoc): depth 6, `shred_idx < 2^33`, so
  idx ≥ 64 is rejected (`:467`).
- Repair (`fd_repair.c:291-318`) and rotor (`fd_rotor_serde.c:225-258`): the exact proof
  depth is required, and the FEC-root index is below `fec_set_cnt`, while every phantom
  index is ≥ the leaf count. The parent-info leaf hashes `fec_set_count`, which binds its
  own index.
- In all shred paths the leaf bytes contain the shred's index fields, so a phantom position
  would need a SHA-256 collision.

**Agave conformance** (`~/fd-specs/difftest-bmtree/agave`: Agave's Rust files copied
verbatim, run against the C).
- Entry root (`solana-merkle-tree`) matches for 0..1100 leaves and large counts. For 0
  leaves Agave gives zeros, and the Firedancer tiles write zeros without calling fini.
- Shred roots and proofs match for 1..200 leaves. Agave's `get_merkle_root`
  (`merkle_tree.rs:115-131`) accepts the same phantom indices.
- Block ids match for 1..1024 FEC sets.
- Difference: Agave's FEC-root repair check (`serve_repair.rs:307-326`) has no proof-length
  check, so it accepts a layer-1 node with a shorter proof. Firedancer rejects it.
- Difference: Agave does not require the 6-entry shred proof, while Firedancer does
  (`fd_fec_resolver.c:686`). A grep of `ledger`/`core`/`turbine` found no equality check
  on `proof_size`. This is policy outside bmtree and not yet confirmed end to end.

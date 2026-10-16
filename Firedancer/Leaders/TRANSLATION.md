# Leader schedule: C → Lean

Source: `~/firedancer` at 1be38beb58. Namespace `Firedancer.Leaders`. Paths are relative to
`src/`. Pure Lean (core only, no Mathlib). Build: `lake build Firedancer.Leaders.Leaders`.

## Conventions

- `ulong` = `BitVec 64`, `uint`/`int` = `BitVec 32`, `uchar`/`char` = `BitVec 8`. All
  arithmetic wraps as in C. Loop counters that cannot wrap are `Nat`.
- Fixed C arrays are `Vector T n`: `fd_pubkey_t` = `Vector (BitVec 8) 32`, `tree_ele_t` =
  `Vector (BitVec 64) 8`, the RNG buffer `Vector (BitVec 8) 256`. Arrays sized at runtime
  (`stakes`, the wsample tree, `sched`, `pub`, `vote_addr`, sort keys) are `Array`, since
  their length is a runtime `ulong`.
- A function that writes through a pointer returns what it wrote. A pointer return is an
  `Option` (`none` = `NULL`). `*sampler->rng` is passed in and returned explicitly; it is not
  a field of `fd_wsample_t`.
- Reads past an `Array`/`Vector` give `default` and writes past it are dropped. This is
  reached only where noted below.
- Process exits (`FD_LOG_ERR`, failed `FD_TEST`) are a `logErr` result.
- `memcmp` is modelled by its sign, which is all C specifies and all the callers use.

## Functions

| C (file:line) | Lean | Notes |
|---|---|---|
| util/bits/fd_bits.h:197/200/202/205/206/209 | `fd_ulong_is_aligned/align_up/if/min/max.spec`, `fd_uint_rotate_left.spec` | literal bodies |
| fd_bits.h:609, :968 | `FD_ULONG_ALIGN_UP`, `FD_LAYOUT_APPEND` | macros |
| fd_bits_find_msb.h:7 | `fd_ulong_find_msb.spec` | `63 - clzl`; `clzl 0` (UB) = 64 |
| fd_uwide.h:88 | `fd_uwide_mul.spec` | `FD_HAS_INT128` branch (x86-64, aarch64) |
| ballet/chacha/fd_chacha.c:9 | `fd_chacha_quarter_round.spec` / `.at` | the pointers are distinct at every call |
| fd_chacha.c:20/79/86 | `fd_chacha_block.spec`, `fd_chacha{8,20}_block.spec` | key read as LE `uint`s; output bytes |
| fd_chacha_rng.c:14 | `fd_chacha_rng_new.spec mode` | address checks left out (stack object); zeroed state |
| fd_chacha_rng.c:62 | `fd_chacha_rng_init.spec` | `buf` keeps old bytes; algo≠8 ⇒ ChaCha20 refill but stored as given |
| fd_chacha_rng.c:81/98/103 | `fd_chacha_rng_refill_seq.spec`, `fd_chacha{8,20}_rng_refill_seq.spec` | WF recursion (≤3 iterations) |
| fd_chacha_rng.h:152-164 | `fd_chacha{8,20}_rng_private_refill.spec` | portable branch = `refill_seq` |
| fd_chacha_rng.h:169/177/194 | `fd_chacha_rng_avail/ulong/read32.spec` | `read32` not on the schedule path |
| fd_chacha_rng.h:219 | `fd_chacha_rng_ulong_roll.spec fuel` (`.zone`, `.loop`) | MOD and SHIFT; fuel, see below |
| ballet/wsample/fd_wsample.c:162 | `compute_height.spec` (`.loop`) | WF recursion; `none` = `-1` |
| fd_wsample.c:184, fd_wsample.h:29 | `fd_wsample_footprint.spec`, `FD_WSAMPLE_FOOTPRINT` | they differ only for `ele_cnt ≥ INT_MAX` (function 0) |
| fd_wsample.c:197/272/315/348 | `fd_wsample_join/new_init/new_add/new_fini.spec` | `Option` in and out (NULL chaining) |
| fd_wsample.c:393 | `fd_wsample_seed_rng.spec` | ChaCha8 (not reached by the schedule) |
| fd_wsample.c:427/474/764 | `fd_wsample_map_sample_i.spec`, `fd_wsample_map_sample.spec`, `fd_wsample_sample.spec fuel` | |
| util/tmpl/fd_sort.c:453 | `fd_sort_insert.spec` | generic in `before` |
| fd_sort.c:547 (`inplace` :287) | `fd_sort_inplace.spec` (`fd_sort_private_quick.{loop,retry,partition}`) | fuel, see below |
| flamenco/stakes/fd_stake_weight_sort.h:17 | `sort_vote_weights_by_stake_vote.before` | stake desc, then vote key desc |
| flamenco/stakes/fd_stakes.c:459 | `fd_stake_weights_by_node.spec elems` | input = the iterator's records in order |
| flamenco/leaders/fd_leaders.c:17/22 | `sort_weights_by_stake_id.before`, `sort_weights_by_id.before` | |
| fd_leaders.c:26 | `compute_id_weights_from_vote_weights.spec` | turbine id weights; not on the schedule path |
| fd_leaders.c:68, fd_leaders.h:43 | `fd_epoch_leaders_footprint.spec`, `FD_EPOCH_LEADERS_FOOTPRINT` | |
| fd_leaders.c:78 | `fd_epoch_leaders_new.spec fuel shmem epoch slot0 slot_cnt pub_cnt stakes` | `.add_loop`, `.sample_loop` |
| fd_leaders.h:142/156 | `fd_epoch_leaders_get.spec`, `fd_epoch_leaders_get_vote.spec` | non-NULL `leaders` |

Left out because the schedule does not reach them: `sample_and_remove{,_many}`,
`fd_wsample_remove`, `find_weight`, `remove_idx`, `restore_all`, `sample_many`. Also left
out: the `#if 0` code, and the `align/footprint/join/leave/delete` functions that only cast
or memset.

## Excluded SIMD paths and what production runs

- **RNG refill.** `fd_chacha_rng.h:32-40,152-164` select the buffer size and the refill at
  compile time. AVX512 builds use `refill_avx512` with BUFSZ 1024 (16 blocks per refill, and
  `FD_LOG_CRIT` unless `buf_off==buf_fill`). AVX builds use `refill_avx` with BUFSZ 512
  (8 blocks). SVE2 builds use `refill_sve2` with BUFSZ 256 (4 blocks). Every other build
  uses `refill_seq` with BUFSZ 256 (refills while fewer than 192 bytes are buffered, so 3
  blocks from empty), and that is the build translated here.
  Production x86 uses the default `MACHINE=native` (`config/machine/native.mk`). That build
  is AVX512 when the CPU has `__AVX512IFMA__` (Icelake, Zen4, Zen5) and AVX on AVX2-only
  CPUs (`linux_gcc_x86_64`, Zen2/3, Haswell). So **production x86 never runs `refill_seq`.**
  The portable path runs on minimal/noarch builds and on aarch64 without SVE2 (e.g. M1);
  `neoverse_n2` runs SVE2.
  All variants should give the same stream. In each, the byte at stream offset `p` is byte
  `p%64` of the ChaCha block with counter `p/64` (nonce words 0). Only the refill points and
  the buffer contents differ. This equivalence is assumed, not proved: `test_chacha_rng.c`
  checks it at one counter value.
- **ChaCha block.** `Local.mk` compiles `fd_chacha_sse.c` in place of `fd_chacha.c` on
  `FD_HAS_SSE` builds. The SSE `fd_chacha20_block` is reached only through `refill_seq`, i.e.
  on SSE builds without AVX. Not translated.
- **wsample.** In `fd_wsample_map_sample_i` (`fd_wsample.c:438-443`), AVX512 builds count
  the children with `_mm512_cmple_epu64_mask` + `popcnt`. That is unsigned `<=` on 8 lanes,
  the same value as the portable loop that is translated. The AVX512 height-4
  TRAVERSE/PROPAGATE path (`:559-707`) is used only by `sample_and_remove{,_many}`, which
  the schedule never calls (Turbine does, in `disco/shred/fd_shred_dest.c`).
  `fd_wsample_sample` always takes the portable path.

## RNG buffer state machine (portable)

The state is `buf_off` (bytes consumed) and `buf_fill` (bytes produced, a multiple of 64);
both only increase.

- `init`: both set to 0, then `refill_seq`, so `fill = 192`.
- `refill_seq`: while `fill - off < 192`, write block `fill>>6` at `buf[fill%256]` and add
  64 to `fill`.
- `ulong`: if `fill - off < 8`, refill. Then load 8 bytes LE at `off%256` and add 8 to
  `off`.
- `read32`: first round `off` up to a multiple of 32 (this discards bytes), then refill if
  `fill - off < 32`.

Because `off` stays a multiple of 8 and `off ≤ fill` with `fill - off ≤ 192 + 63 < 256`,
reads never wrap the buffer end and refills never overwrite unread bytes. With `ulong`
reads only, a refill happens exactly when `off == fill`, so the schedule refills 3 blocks
every 24 ulongs.

## wsample tree layout

`height = ceil(log9 leaf_cnt)`, and `internal_node_cnt = Σ_{i<height} 9^i`. Node `i` has
children `9i+1 … 9i+9`, and leaf `k` is implicit node `internal_node_cnt + k`. Each node
stores `left_sum[0..7]`, the prefix sums of its first 8 children. The 9th child appears
only through the subtree total `S`.

- `new_add` adds `weight` to `left_sum[child_idx..7]` of every ancestor.
- `map_sample_i` descends with `child_idx = #{k : left_sum[k] ≤ x}`, `lm1 =
  left_sum[child_idx-1]` (0 when `child_idx = 0`) and `li = left_sum[child_idx]` (`S` when
  `child_idx = 8`). It sets `x -= lm1` and `S = li - lm1`.
- The C gets `lm1`/`li` by overwriting the neighbouring words `temp[-1]` and `temp[8]` (the
  previous/next node or the dummies), reading, and restoring. The Lean keeps the reads
  through a 10-word window `[0, left_sum…, S]`.
- With `ele_cnt = 0`, `height = 0` and every sample is `EMPTY`.

## Fuel and termination

- `fd_chacha_rng_ulong_roll` has a `for(;;)` with no bound. It takes `fuel` iterations and
  returns `Fueled.outOfFuel` when they run out. `fd_wsample_sample` and
  `fd_epoch_leaders_new` pass the fuel through, so the fuel is per roll.
  - Termination depends on the ChaCha output, so it cannot be proved. A draw is accepted
    iff `lo(v·n) ≤ zone`. In MODE_MOD at least `⌊2^64/n⌋·n ≥ 2^63` of the 2^64 values are
    accepted.
  - Measured on the epoch-454 stakes (`n = 392456937698882662`, reject rate ≈ 6.9e-5),
    over 108000 rolls for each of epochs 454, 455, 600 and 1000: at most 2 draws per roll,
    with 7/9/3/8 rejections in total. Fuel 64 is ample.
  - Agave's `Uniform` loop is equally unbounded.
  - The C `int i` counter overflows (UB) after 2^31 rejections; no fuel that large is
    realistic.
- `fd_sort_inplace.spec` uses fuel `8·cnt+8` for the outer loop; each `goto retry` and
  each pop costs one unit. Each partition loop gets `n+1`.
  - Pushed partitions are non-empty and strictly smaller than their parent, so there are at
    most about `3·cnt+1` pops.
  - With an irreflexive `before`, there is at most one `goto retry` per partition.
  - The C stack (256 entries) never overflows because of the "smaller partition first" order
    (`fd_sort.c:549`, `:692-712`); the Lean stack is unbounded.
  - These bounds are argued, not proved. `outOfFuel` would expose a wrong bound.
- `compute_height` and `refill_seq` are well-founded and carry termination proofs.

## Where the stake list is built and sorted

`fd_epoch_leaders_new` does not sort. It expects `stakes` sorted and already free of zero
weights.

- Production callers (`flamenco/runtime/fd_runtime.c:74/113`) get the list from
  `fd_stake_weights_by_node` (`flamenco/stakes/fd_stakes.c:459`). That function copies the
  vote-stakes iterator's records and sorts them with `sort_vote_weights_by_stake_vote`
  (`fd_stake_weight_sort.h:15-18`: stake desc, then `vote_key` desc by `memcmp`). This
  matches Agave's `sort_stakes`.
  - **It does not dedup.** The comment says vote keys are unique per fork, since the
    vote-stakes map is keyed by vote account.
  - It aborts (`FD_TEST`) on the 2001st record.
- Zero stakes are dropped earlier, at insertion into the vote-stakes map
  (`flamenco/stakes/fd_vote_stakes.c:608,633,660,689`).
- That insertion also caps the set at the top `MAX_STAKE_WEIGHTS = 2000` by stake, through
  `min_stake_wmark` (`fd_vote_stakes.c:689-700`). These filters and the iterator are out of
  scope and were not translated.
- Other callers (`disco/shred/fd_stake_ci.c:199`, `flamenco/leaders/fd_multi_epoch_leaders.c:154`,
  GUI) receive an already-built list over a message link.

## Suspicious / worth auditing

1. **`slot_cnt == 0` aborts.** `fd_epoch_leaders_footprint` returns 0, so `FD_TEST`
   (`fd_leaders.c:140`) fails, since the wsample footprint is > 0. Checked by `#eval`.
   Agave returns an empty schedule.
2. **A zero stake or total stake > 2^64-1 aborts.** `fd_wsample_new_add` returns NULL, the
   NULL chains through, and `FD_TEST( wsample )` fails. Firedancer relies on the upstream
   zero filter. Total stake = 2^64-1 works.
3. **No dedup** in `fd_stake_weights_by_node`, unlike Agave's `dedup_by` (equal stake and
   vote address). If a duplicate `(stake, vote_key)` ever reached it, Firedancer would weight
   it twice and the schedules would differ. Equal keys would also make the unstable
   quicksort's output depend on the algorithm, which is why the quicksort is translated in
   full.
4. **`sched_cnt = ceil(slot_cnt/4)`**, while Agave uses `len/repeat` with a debug-assert
   that `len` is divisible. They agree when `4 | slot_cnt`.
5. **The footprint `FD_TEST` is weak.** `fd_leaders.c:140` compares the wsample footprint
   with the whole leaders footprint, not with the space left after the header, `sched` and
   `vote_addr`. It is safe only because `FD_EPOCH_LEADERS_FOOTPRINT` reserves
   `max(32·pub_cnt, FD_WSAMPLE_FOOTPRINT)` for that region.
6. **Dead comparators in `fd_leaders.c:5-13`.** `sort_vote_weights_by_stake_id` and
   `sort_vote_weights_by_id` are never called. The first sorts by identity, not by vote
   address, and would diverge from Agave if it were used.
7. **Stale or misleading comments.** `fd_leaders.c` says the struct footprint is 48; it is
   64. `fd_leaders.h` says `pub_cnt` is "unique public keys" and that `stakes` is "sorted by
   (stake, pubkey)"; in fact `pub` repeats identities, and the sort key is the vote key.
8. **`test_wsample.c` `test_map` checks nothing.** The global `weights[]` is still all
   zeros when it runs, because `test_probability_dist_replacement` fills it later. It also
   declares `uint fd_wsample_map_sample` against the `ulong` definition. The intended check
   (every interval boundary, `sz = 1018`) passes on the Lean.
9. **`fd_ulong_if` evaluates both arms.** For `n = 0` the roll's zone computation divides
   by zero and calls `find_msb(0)`. This is unreachable from the schedule (`n` ≥ 1).

## Modelling choices to review

- `shmem` is an address (`BitVec 64`), used for the NULL, alignment and `laddr` checks (with
  `laddr` wrap-around as in C). `_rng` (on the stack) is assumed aligned. The aliasing of
  `pubkeys` with `wsample_mem` cannot be observed: the pubkeys are written after the last
  sample.
- `stakes` is the caller's array. A read past it (when `pub_cnt` exceeds the array, or a
  sample index is ≥ its size) is the `ub` result. Sample indices are `< pub_cnt` whenever
  the run gets that far.
- `fd_wsample_t.tree_copy` stands for the restore region. It is never written here
  (`restore_enabled = 0`).
- `fd_stake_weights_by_node` takes the iterator's records directly.

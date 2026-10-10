module

-- agave-build/out/avx2-noinline/op/_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51>::pow2k

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_pow2k :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 101>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg51: !llvm.ptr, %arg52: !llvm.ptr, %arg53: i32):
  %2391 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2392 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %2393 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2394 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %2395 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2396 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2397 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2398 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2399 = "llvm.load"(%arg52) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2400 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2401 = "llvm.load"(%2400) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2402 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2403 = "llvm.load"(%2402) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2404 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2405 = "llvm.load"(%2404) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2406 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2407 = "llvm.load"(%2406) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.br"(%2407, %2405, %2403, %2401, %2399, %arg53)[^bb1] : (i64, i64, i64, i64, i64, i32) -> ()
^bb1(%2408: i64, %2409: i64, %2410: i64, %2411: i64, %2412: i64, %2413: i32):  // 2 preds: ^bb0, ^bb1
  %2414 = "llvm.mul"(%2409, %2391) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2415 = "llvm.mul"(%2408, %2391) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2416 = "llvm.zext"(%2412) : (i64) -> i128
  %2417 = "llvm.mul"(%2416, %2416) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2418 = "llvm.zext"(%2411) : (i64) -> i128
  %2419 = "llvm.zext"(%2415) : (i64) -> i128
  %2420 = "llvm.mul"(%2418, %2419) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2421 = "llvm.zext"(%2410) : (i64) -> i128
  %2422 = "llvm.zext"(%2414) : (i64) -> i128
  %2423 = "llvm.mul"(%2421, %2422) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2424 = "llvm.add"(%2420, %2423) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2425 = "llvm.shl"(%2424, %2392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2426 = "llvm.add"(%2425, %2417) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2427 = "llvm.zext"(%2409) : (i64) -> i128
  %2428 = "llvm.mul"(%2422, %2427) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2429 = "llvm.mul"(%2416, %2418) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2430 = "llvm.mul"(%2421, %2419) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2431 = "llvm.add"(%2429, %2430) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2432 = "llvm.shl"(%2431, %2392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2433 = "llvm.add"(%2432, %2428) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2434 = "llvm.mul"(%2418, %2418) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2435 = "llvm.mul"(%2416, %2421) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2436 = "llvm.zext"(%2408) : (i64) -> i128
  %2437 = "llvm.mul"(%2422, %2436) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2438 = "llvm.add"(%2435, %2437) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2439 = "llvm.shl"(%2438, %2392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2440 = "llvm.add"(%2439, %2434) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2441 = "llvm.mul"(%2419, %2436) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2442 = "llvm.mul"(%2416, %2427) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2443 = "llvm.mul"(%2418, %2421) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2444 = "llvm.add"(%2442, %2443) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2445 = "llvm.shl"(%2444, %2392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2446 = "llvm.add"(%2445, %2441) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2447 = "llvm.mul"(%2421, %2421) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2448 = "llvm.mul"(%2416, %2436) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2449 = "llvm.mul"(%2418, %2427) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2450 = "llvm.add"(%2448, %2449) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2451 = "llvm.shl"(%2450, %2392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2452 = "llvm.add"(%2451, %2447) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2453 = "llvm.lshr"(%2426, %2393) : (i128, i128) -> i128
  %2454 = "llvm.and"(%2453, %2394) : (i128, i128) -> i128
  %2455 = "llvm.add"(%2433, %2454) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2456 = "llvm.trunc"(%2426) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2457 = "llvm.and"(%2456, %2395) : (i64, i64) -> i64
  %2458 = "llvm.lshr"(%2455, %2393) : (i128, i128) -> i128
  %2459 = "llvm.and"(%2458, %2394) : (i128, i128) -> i128
  %2460 = "llvm.add"(%2440, %2459) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2461 = "llvm.trunc"(%2455) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2462 = "llvm.and"(%2461, %2395) : (i64, i64) -> i64
  %2463 = "llvm.lshr"(%2460, %2393) : (i128, i128) -> i128
  %2464 = "llvm.and"(%2463, %2394) : (i128, i128) -> i128
  %2465 = "llvm.add"(%2446, %2464) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2466 = "llvm.trunc"(%2460) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2467 = "llvm.and"(%2466, %2395) : (i64, i64) -> i64
  %2468 = "llvm.lshr"(%2465, %2393) : (i128, i128) -> i128
  %2469 = "llvm.and"(%2468, %2394) : (i128, i128) -> i128
  %2470 = "llvm.add"(%2452, %2469) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2471 = "llvm.trunc"(%2465) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2472 = "llvm.and"(%2471, %2395) : (i64, i64) -> i64
  %2473 = "llvm.lshr"(%2470, %2393) : (i128, i128) -> i128
  %2474 = "llvm.trunc"(%2473) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2475 = "llvm.trunc"(%2470) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2476 = "llvm.and"(%2475, %2395) : (i64, i64) -> i64
  %2477 = "llvm.mul"(%2474, %2391) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2478 = "llvm.add"(%2477, %2457) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2479 = "llvm.lshr"(%2478, %2396) : (i64, i64) -> i64
  %2480 = "llvm.add"(%2479, %2462) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2481 = "llvm.and"(%2478, %2395) : (i64, i64) -> i64
  %2482 = "llvm.add"(%2413, %2397) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2483 = "llvm.icmp"(%2482, %2398) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2483, %2467, %2472, %2476, %2480, %2481, %2476, %2472, %2467, %2480, %2481, %2482)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 5, 6>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32) -> ()
^bb2(%2484: i64, %2485: i64, %2486: i64, %2487: i64, %2488: i64):  // pred: ^bb1
  "llvm.store"(%2488, %arg51) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2489 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2487, %2489) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2490 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2484, %2490) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2491 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2485, %2491) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2492 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2486, %2492) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2

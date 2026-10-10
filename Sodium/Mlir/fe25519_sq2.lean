module

-- sodium-build/out/op/fe25519_sq2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_sq2 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_sq2", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg45: !llvm.ptr, %arg46: !llvm.ptr):
  %2353 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2354 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %2355 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2356 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %2357 = "llvm.mlir.constant"() <{value = 2251799813685246 : i64}> : () -> i64
  %2358 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2359 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2360 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2361 = "llvm.load"(%arg46) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2362 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2363 = "llvm.load"(%2362) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2364 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2365 = "llvm.load"(%2364) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2366 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2367 = "llvm.load"(%2366) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2368 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2369 = "llvm.load"(%2368) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2370 = "llvm.shl"(%2361, %2353) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2371 = "llvm.shl"(%2363, %2353) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2372 = "llvm.mul"(%2363, %2354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2373 = "llvm.mul"(%2365, %2354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2374 = "llvm.mul"(%2367, %2354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2375 = "llvm.mul"(%2367, %2355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2376 = "llvm.mul"(%2369, %2355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2377 = "llvm.zext"(%2361) : (i64) -> i128
  %2378 = "llvm.mul"(%2377, %2377) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2379 = "llvm.zext"(%2372) : (i64) -> i128
  %2380 = "llvm.zext"(%2369) : (i64) -> i128
  %2381 = "llvm.mul"(%2380, %2379) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2382 = "llvm.zext"(%2373) : (i64) -> i128
  %2383 = "llvm.zext"(%2367) : (i64) -> i128
  %2384 = "llvm.mul"(%2382, %2383) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2385 = "llvm.add"(%2384, %2378) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2386 = "llvm.add"(%2385, %2381) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2387 = "llvm.zext"(%2370) : (i64) -> i128
  %2388 = "llvm.zext"(%2363) : (i64) -> i128
  %2389 = "llvm.mul"(%2387, %2388) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2390 = "llvm.mul"(%2380, %2382) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2391 = "llvm.add"(%2390, %2389) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2392 = "llvm.zext"(%2375) : (i64) -> i128
  %2393 = "llvm.mul"(%2392, %2383) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2394 = "llvm.add"(%2391, %2393) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2395 = "llvm.zext"(%2365) : (i64) -> i128
  %2396 = "llvm.mul"(%2395, %2387) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2397 = "llvm.mul"(%2388, %2388) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2398 = "llvm.add"(%2396, %2397) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2399 = "llvm.zext"(%2374) : (i64) -> i128
  %2400 = "llvm.mul"(%2399, %2380) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2401 = "llvm.add"(%2398, %2400) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2402 = "llvm.mul"(%2383, %2387) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2403 = "llvm.zext"(%2371) : (i64) -> i128
  %2404 = "llvm.mul"(%2403, %2395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2405 = "llvm.add"(%2402, %2404) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2406 = "llvm.zext"(%2376) : (i64) -> i128
  %2407 = "llvm.mul"(%2406, %2380) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2408 = "llvm.add"(%2405, %2407) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2409 = "llvm.mul"(%2380, %2387) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2410 = "llvm.mul"(%2383, %2403) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2411 = "llvm.mul"(%2395, %2395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2412 = "llvm.add"(%2410, %2411) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2413 = "llvm.add"(%2412, %2409) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2414 = "llvm.shl"(%2386, %2356) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2415 = "llvm.shl"(%2394, %2356) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2416 = "llvm.shl"(%2401, %2356) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2417 = "llvm.shl"(%2408, %2356) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2418 = "llvm.shl"(%2413, %2356) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2419 = "llvm.trunc"(%2414) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2420 = "llvm.and"(%2419, %2357) : (i64, i64) -> i64
  %2421 = "llvm.lshr"(%2414, %2358) : (i128, i128) -> i128
  %2422 = "llvm.add"(%2421, %2415) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2423 = "llvm.trunc"(%2422) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2424 = "llvm.and"(%2423, %2359) : (i64, i64) -> i64
  %2425 = "llvm.lshr"(%2422, %2358) : (i128, i128) -> i128
  %2426 = "llvm.add"(%2425, %2416) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2427 = "llvm.trunc"(%2426) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2428 = "llvm.and"(%2427, %2359) : (i64, i64) -> i64
  %2429 = "llvm.lshr"(%2426, %2358) : (i128, i128) -> i128
  %2430 = "llvm.add"(%2429, %2417) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2431 = "llvm.trunc"(%2430) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2432 = "llvm.and"(%2431, %2359) : (i64, i64) -> i64
  %2433 = "llvm.lshr"(%2430, %2358) : (i128, i128) -> i128
  %2434 = "llvm.add"(%2433, %2418) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2435 = "llvm.trunc"(%2434) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2436 = "llvm.and"(%2435, %2359) : (i64, i64) -> i64
  %2437 = "llvm.lshr"(%2434, %2358) : (i128, i128) -> i128
  %2438 = "llvm.trunc"(%2437) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2439 = "llvm.mul"(%2438, %2355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2440 = "llvm.add"(%2439, %2420) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2441 = "llvm.lshr"(%2440, %2360) : (i64, i64) -> i64
  %2442 = "llvm.and"(%2440, %2359) : (i64, i64) -> i64
  %2443 = "llvm.add"(%2441, %2424) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2444 = "llvm.lshr"(%2443, %2360) : (i64, i64) -> i64
  %2445 = "llvm.and"(%2443, %2359) : (i64, i64) -> i64
  %2446 = "llvm.add"(%2444, %2428) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%2442, %arg45) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2447 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2445, %2447) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2448 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2446, %2448) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2449 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2432, %2449) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2450 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2436, %2450) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium

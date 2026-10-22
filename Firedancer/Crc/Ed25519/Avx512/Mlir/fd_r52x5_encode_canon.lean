module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_encode_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_encode_canon :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_encode_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg199: !llvm.ptr, %arg200: !llvm.ptr, %arg201: !llvm.ptr):
  %2540 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2541 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %2542 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %2543 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %2544 = "llvm.mlir.constant"() <{value = 25 : i64}> : () -> i64
  %2545 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %2546 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %2547 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %2548 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %2549 = "llvm.load"(%arg201) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2550 = "llvm.getelementptr"(%arg201) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2551 = "llvm.load"(%2550) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2552 = "llvm.shl"(%2551, %2540) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2553 = "llvm.or"(%2552, %2549) : (i64, i64) -> i64
  "llvm.store"(%2553, %arg199) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2554 = "llvm.load"(%2550) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2555 = "llvm.lshr"(%2554, %2541) : (i64, i64) -> i64
  %2556 = "llvm.getelementptr"(%arg201) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2557 = "llvm.load"(%2556) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2558 = "llvm.shl"(%2557, %2542) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2559 = "llvm.or"(%2558, %2555) : (i64, i64) -> i64
  %2560 = "llvm.getelementptr"(%arg199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2559, %2560) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2561 = "llvm.load"(%2556) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2562 = "llvm.lshr"(%2561, %2543) : (i64, i64) -> i64
  %2563 = "llvm.getelementptr"(%arg201) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2564 = "llvm.load"(%2563) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2565 = "llvm.shl"(%2564, %2544) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2566 = "llvm.or"(%2565, %2562) : (i64, i64) -> i64
  %2567 = "llvm.getelementptr"(%arg199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2566, %2567) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2568 = "llvm.load"(%2563) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2569 = "llvm.lshr"(%2568, %2545) : (i64, i64) -> i64
  %2570 = "llvm.getelementptr"(%arg201) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2571 = "llvm.load"(%2570) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2572 = "llvm.shl"(%2571, %2546) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2573 = "llvm.or"(%2572, %2569) : (i64, i64) -> i64
  %2574 = "llvm.getelementptr"(%arg199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2573, %2574) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2575 = "llvm.load"(%arg200) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2576 = "llvm.trunc"(%2575) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %2577 = "llvm.shl"(%2576, %2547) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %2578 = "llvm.getelementptr"(%arg199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2579 = "llvm.lshr"(%2572, %2548) : (i64, i64) -> i64
  %2580 = "llvm.trunc"(%2579) <{overflowFlags = 2 : i32}> : (i64) -> i8
  %2581 = "llvm.xor"(%2577, %2580) : (i8, i8) -> i8
  "llvm.store"(%2581, %2578) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512

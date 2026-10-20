module

-- crc/out/mlirproofs/regions/verify/fd_curve25519_scalar_validate.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_curve25519_scalar_validate :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_scalar_validate", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg166: !llvm.ptr):
  %2426 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %2427 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %2428 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %2429 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2430 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %2431 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %2432 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2433 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %2434 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2435 = "llvm.getelementptr"(%arg166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2436 = "llvm.load"(%2435) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2437 = "llvm.icmp"(%2436, %2426) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2437, %arg166)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %2438 = "llvm.icmp"(%2436, %2427) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2438, %2428)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %2439 = "llvm.load"(%arg166) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2440 = "llvm.getelementptr"(%arg166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2441 = "llvm.load"(%2440) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2442 = "llvm.getelementptr"(%arg166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2443 = "llvm.load"(%2442) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2444 = "llvm.getelementptr"(%arg166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2445 = "llvm.load"(%2444) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2446 = "llvm.call_intrinsic"(%2429, %2439, %2430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %2447 = "llvm.extractvalue"(%2446) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %2448 = "llvm.call_intrinsic"(%2447, %2441, %2431) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %2449 = "llvm.extractvalue"(%2448) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %2450 = "llvm.call_intrinsic"(%2449, %2443, %2432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %2451 = "llvm.extractvalue"(%2450) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %2452 = "llvm.call_intrinsic"(%2451, %2445, %2433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %2453 = "llvm.extractvalue"(%2452) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %2454 = "llvm.icmp"(%2453, %2434) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2455 = "llvm.select"(%2454, %2428, %arg166) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%2455)[^bb3] : (!llvm.ptr) -> ()
^bb3(%2456: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%2456) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify

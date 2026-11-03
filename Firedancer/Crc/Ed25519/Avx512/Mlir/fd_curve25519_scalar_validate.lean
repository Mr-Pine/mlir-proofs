module

-- crc/out/mlirproofs/regions/verify/fd_curve25519_scalar_validate.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_curve25519_scalar_validate :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_scalar_validate", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg212: !llvm.ptr):
  %3429 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %3430 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %3431 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %3432 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3433 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %3434 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %3435 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3436 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %3437 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3438 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %3439 = "llvm.load"(%3438) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3440 = "llvm.icmp"(%3439, %3429) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3440, %arg212)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %3441 = "llvm.icmp"(%3439, %3430) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3441, %3431)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %3442 = "llvm.load"(%arg212) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3443 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3444 = "llvm.load"(%3443) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3445 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3446 = "llvm.load"(%3445) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3447 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3448 = "llvm.load"(%3447) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3449 = "llvm.call_intrinsic"(%3432, %3442, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %3450 = "llvm.extractvalue"(%3449) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %3451 = "llvm.call_intrinsic"(%3450, %3444, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %3452 = "llvm.extractvalue"(%3451) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %3453 = "llvm.call_intrinsic"(%3452, %3446, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %3454 = "llvm.extractvalue"(%3453) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %3455 = "llvm.call_intrinsic"(%3454, %3448, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %3456 = "llvm.extractvalue"(%3455) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %3457 = "llvm.icmp"(%3456, %3437) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3458 = "llvm.select"(%3457, %3431, %arg212) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%3458)[^bb3] : (!llvm.ptr) -> ()
^bb3(%3459: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%3459) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512

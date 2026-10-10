module

-- boringssl-build/out/op/CRYPTO_memcmp.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def CRYPTO_memcmp :=
#loop_unroll = #llvm.loop_unroll<runtimeDisable = true>
#loop_annotation1 = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true, isVectorized = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 256>}], sym_name = "CRYPTO_memcmp", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi32>}> : () -> vector<4xi32>
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.icmp"(%arg2, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%6, %1)[^bb6, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %7 = "llvm.icmp"(%arg2, %2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%7, %0, %1)[^bb5, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i32) -> ()
^bb2:  // pred: ^bb1
  %8 = "llvm.and"(%arg2, %3) : (i64, i64) -> i64
  "llvm.br"(%0, %4, %4)[^bb3] : (i64, vector<4xi32>, vector<4xi32>) -> ()
^bb3(%9: i64, %10: vector<4xi32>, %11: vector<4xi32>):  // 2 preds: ^bb2, ^bb3
  %12 = "llvm.getelementptr"(%arg0, %9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %13 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %14 = "llvm.load"(%12) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %15 = "llvm.load"(%13) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %16 = "llvm.getelementptr"(%arg1, %9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %17 = "llvm.getelementptr"(%16) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.load"(%16) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %19 = "llvm.load"(%17) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %20 = "llvm.xor"(%18, %14) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %21 = "llvm.xor"(%19, %15) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %22 = "llvm.zext"(%20) : (vector<4xi8>) -> vector<4xi32>
  %23 = "llvm.zext"(%21) : (vector<4xi8>) -> vector<4xi32>
  %24 = "llvm.or"(%10, %22) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %25 = "llvm.or"(%11, %23) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %26 = "llvm.add"(%9, %2) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %27 = "llvm.icmp"(%26, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27, %26, %24, %25)[^bb4, ^bb3] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<4xi32>, vector<4xi32>) -> ()
^bb4:  // pred: ^bb3
  %28 = "llvm.or"(%25, %24) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %29 = "llvm.intr.vector.reduce.or"(%28) : (vector<4xi32>) -> i32
  %30 = "llvm.icmp"(%arg2, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%30, %29, %8, %29)[^bb6, ^bb5] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb5(%31: i64, %32: i32):  // 2 preds: ^bb1, ^bb4
  "llvm.br"(%31, %32)[^bb7] : (i64, i32) -> ()
^bb6(%33: i32):  // 3 preds: ^bb0, ^bb4, ^bb7
  "llvm.return"(%33) : (i32) -> ()
^bb7(%34: i64, %35: i32):  // 2 preds: ^bb5, ^bb7
  %36 = "llvm.getelementptr"(%arg0, %34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %37 = "llvm.load"(%36) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %38 = "llvm.getelementptr"(%arg1, %34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %39 = "llvm.load"(%38) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %40 = "llvm.xor"(%39, %37) : (i8, i8) -> i8
  %41 = "llvm.zext"(%40) : (i8) -> i32
  %42 = "llvm.or"(%35, %41) : (i32, i32) -> i32
  %43 = "llvm.add"(%34, %5) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %44 = "llvm.icmp"(%43, %arg2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%44, %42, %43, %42)[^bb6, ^bb7] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
}) : () -> ()

end

end MLIR.Boringssl

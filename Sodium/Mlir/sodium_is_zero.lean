module

-- sodium-build/out/op/sodium_is_zero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def sodium_is_zero :=
#loop_unroll = #llvm.loop_unroll<runtimeDisable = true>
#loop_annotation2 = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true, isVectorized = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "sodium_is_zero", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64):
  %0 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 511 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi8>}> : () -> vector<16xi8>
  %13 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %14 = "llvm.mlir.poison"() : () -> i8
  %15 = "llvm.mlir.undef"() : () -> vector<4xi8>
  %16 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %17 = "llvm.insertelement"(%15, %14, %16) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %18 = "llvm.insertelement"(%17, %7, %5) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %19 = "llvm.insertelement"(%18, %7, %4) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %20 = "llvm.insertelement"(%19, %7, %3) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %21 = "llvm.alloca"(%5) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%21) : (!llvm.ptr) -> ()
  %22 = "llvm.icmp"(%arg1, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%22, %7)[^bb12, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb1:  // pred: ^bb0
  %23 = "llvm.icmp"(%arg1, %8) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%23, %7, %6)[^bb10, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i8, i64) -> ()
^bb2:  // pred: ^bb1
  %24 = "llvm.icmp"(%arg1, %9) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%24, %6, %7)[^bb7, ^bb3] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i8) -> ()
^bb3:  // pred: ^bb2
  %25 = "llvm.and"(%arg1, %10) : (i64, i64) -> i64
  %26 = "llvm.and"(%arg1, %11) : (i64, i64) -> i64
  "llvm.br"(%6, %12, %12)[^bb4] : (i64, vector<16xi8>, vector<16xi8>) -> ()
^bb4(%27: i64, %28: vector<16xi8>, %29: vector<16xi8>):  // 2 preds: ^bb3, ^bb4
  %30 = "llvm.getelementptr"(%arg0, %27) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.getelementptr"(%30) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %32 = "llvm.load"(%30) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %33 = "llvm.load"(%31) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %34 = "llvm.or"(%32, %28) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %35 = "llvm.or"(%33, %29) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %36 = "llvm.add"(%27, %9) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %37 = "llvm.icmp"(%36, %26) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%37, %36, %34, %35)[^bb5, ^bb4] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<16xi8>, vector<16xi8>) -> ()
^bb5:  // pred: ^bb4
  %38 = "llvm.or"(%35, %34) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %39 = "llvm.intr.vector.reduce.or"(%38) : (vector<16xi8>) -> i8
  %40 = "llvm.icmp"(%arg1, %26) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%40, %39)[^bb12, ^bb6] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb6:  // pred: ^bb5
  %41 = "llvm.icmp"(%25, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%41, %39, %26, %26, %39)[^bb10, ^bb7] <{branch_weights = array<i32: 4, 28>, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i8, i64, i64, i8) -> ()
^bb7(%42: i64, %43: i8):  // 2 preds: ^bb2, ^bb6
  %44 = "llvm.and"(%arg1, %13) : (i64, i64) -> i64
  %45 = "llvm.insertelement"(%20, %43, %6) : (vector<4xi8>, i8, i64) -> vector<4xi8>
  "llvm.br"(%42, %45)[^bb8] : (i64, vector<4xi8>) -> ()
^bb8(%46: i64, %47: vector<4xi8>):  // 2 preds: ^bb7, ^bb8
  %48 = "llvm.getelementptr"(%arg0, %46) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.load"(%48) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %50 = "llvm.or"(%49, %47) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %51 = "llvm.add"(%46, %8) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %52 = "llvm.icmp"(%51, %44) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%52, %51, %50)[^bb9, ^bb8] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<4xi8>) -> ()
^bb9:  // pred: ^bb8
  %53 = "llvm.intr.vector.reduce.or"(%50) : (vector<4xi8>) -> i8
  %54 = "llvm.icmp"(%arg1, %44) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%54, %53, %53, %44)[^bb12, ^bb10] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i8, i8, i64) -> ()
^bb10(%55: i8, %56: i64):  // 3 preds: ^bb1, ^bb6, ^bb9
  "llvm.br"(%55, %56)[^bb11] : (i8, i64) -> ()
^bb11(%57: i8, %58: i64):  // 2 preds: ^bb10, ^bb11
  %59 = "llvm.getelementptr"(%arg0, %58) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %60 = "llvm.load"(%59) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %61 = "llvm.or"(%60, %57) : (i8, i8) -> i8
  %62 = "llvm.add"(%58, %2) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %63 = "llvm.icmp"(%62, %arg1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%63, %61, %61, %62)[^bb12, ^bb11] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i8, i8, i64) -> ()
^bb12(%64: i8):  // 4 preds: ^bb0, ^bb5, ^bb9, ^bb11
  "llvm.store"(%64, %21) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %65 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  %66 = "llvm.inline_asm"(%65) <{asm_dialect = 0 : i64, asm_string = "", constraints = "=r,0,~{dirflag},~{fpsr},~{flags}", tail_call_kind = #llvm.tailcallkind<tail>}> : (i8) -> i8
  "llvm.store"(%66, %21) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %67 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  %68 = "llvm.zext"(%67) : (i8) -> i32
  %69 = "llvm.add"(%68, %1) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %70 = "llvm.lshr"(%69, %0) : (i32, i32) -> i32
  %71 = "llvm.and"(%70, %5) : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.return"(%71) : (i32) -> ()
}) : () -> ()

end

end MLIR.Sodium

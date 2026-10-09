module

-- zig-build/out/mlir_canonicalized/region/Fe.carry128.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_carry128 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
    %2 = "llvm.mlir.constant"() <{value = 41538374868278621028243970633760768 : i128}> : () -> i128
    %3 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
    %5 = "llvm.load"(%arg1) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %6 = "llvm.trunc"(%5) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %7 = "llvm.and"(%6, %0) : (i64, i64) -> i64
    %8 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %9 = "llvm.load"(%8) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %10 = "llvm.lshr"(%5, %1) : (i128, i128) -> i128
    %11 = "llvm.icmp"(%5, %2) <{predicate = 6 : i64}> : (i128, i128) -> i1
    %12 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %13 = "llvm.mlir.poison"() : () -> i1
    %14 = "llvm.select"(%11, %12, %13) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%14)[^assume0, ^assume0] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume0:
    %15 = "llvm.add"(%9, %10) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    "llvm.store"(%15, %8) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %16 = "llvm.trunc"(%15) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %17 = "llvm.and"(%16, %0) : (i64, i64) -> i64
    %18 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %19 = "llvm.load"(%18) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %20 = "llvm.lshr"(%15, %1) : (i128, i128) -> i128
    %21 = "llvm.icmp"(%15, %2) <{predicate = 6 : i64}> : (i128, i128) -> i1
    %22 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %23 = "llvm.mlir.poison"() : () -> i1
    %24 = "llvm.select"(%21, %22, %23) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%24)[^assume1, ^assume1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume1:
    %25 = "llvm.add"(%19, %20) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    "llvm.store"(%25, %18) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %26 = "llvm.trunc"(%25) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %27 = "llvm.and"(%26, %0) : (i64, i64) -> i64
    %28 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %29 = "llvm.load"(%28) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %30 = "llvm.lshr"(%25, %1) : (i128, i128) -> i128
    %31 = "llvm.icmp"(%25, %2) <{predicate = 6 : i64}> : (i128, i128) -> i1
    %32 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %33 = "llvm.mlir.poison"() : () -> i1
    %34 = "llvm.select"(%31, %32, %33) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%34)[^assume2, ^assume2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume2:
    %35 = "llvm.add"(%29, %30) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    "llvm.store"(%35, %28) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %36 = "llvm.trunc"(%35) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %37 = "llvm.and"(%36, %0) : (i64, i64) -> i64
    %38 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %39 = "llvm.load"(%38) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %40 = "llvm.lshr"(%35, %1) : (i128, i128) -> i128
    %41 = "llvm.icmp"(%35, %2) <{predicate = 6 : i64}> : (i128, i128) -> i1
    %42 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %43 = "llvm.mlir.poison"() : () -> i1
    %44 = "llvm.select"(%41, %42, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%44)[^assume3, ^assume3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume3:
    %45 = "llvm.add"(%39, %40) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    "llvm.store"(%45, %38) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %46 = "llvm.trunc"(%45) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %47 = "llvm.and"(%46, %0) : (i64, i64) -> i64
    %48 = "llvm.lshr"(%45, %1) : (i128, i128) -> i128
    %49 = "llvm.icmp"(%45, %2) <{predicate = 6 : i64}> : (i128, i128) -> i1
    %50 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %51 = "llvm.mlir.poison"() : () -> i1
    %52 = "llvm.select"(%49, %50, %51) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%52)[^assume4, ^assume4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume4:
    %53 = "llvm.trunc"(%48) <{overflowFlags = #llvm.overflow<nuw>}> : (i128) -> i64
    %54 = "llvm.mul"(%53, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %55 = "llvm.add"(%54, %7) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %56 = "llvm.lshr"(%55, %4) : (i64, i64) -> i64
    %57 = "llvm.and"(%55, %0) : (i64, i64) -> i64
    %58 = "llvm.add"(%56, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %59 = "llvm.lshr"(%58, %4) : (i64, i64) -> i64
    %60 = "llvm.and"(%58, %0) : (i64, i64) -> i64
    %61 = "llvm.add"(%59, %27) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.store"(%57, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %62 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%60, %62) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %63 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%61, %63) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %64 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%37, %64) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %65 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%47, %65) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end MLIR.Zig

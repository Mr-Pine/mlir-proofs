module

-- zig-build/out/mlir_canonicalized/region/Scalar.add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Scalar_add :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = -5343 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = -5342 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 5343 : i64}> : () -> i64
    %10 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
    %11 = "llvm.mlir.constant"() <{value = -268435457 : i64}> : () -> i64
    %12 = "llvm.mlir.constant"() <{value = -268435456 : i64}> : () -> i64
    %13 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
    %14 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %15 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %16 = "llvm.add"(%15, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %17 = "llvm.lshr"(%16, %0) : (i64, i64) -> i64
    %18 = "llvm.and"(%16, %1) : (i64, i64) -> i64
    %19 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %20 = "llvm.load"(%19) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %21 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %22 = "llvm.load"(%21) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %23 = "llvm.add"(%22, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %24 = "llvm.add"(%23, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %25 = "llvm.lshr"(%24, %0) : (i64, i64) -> i64
    %26 = "llvm.and"(%24, %1) : (i64, i64) -> i64
    %27 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %28 = "llvm.load"(%27) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %29 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %30 = "llvm.load"(%29) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %31 = "llvm.add"(%30, %28) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %32 = "llvm.add"(%31, %25) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %33 = "llvm.lshr"(%32, %0) : (i64, i64) -> i64
    %34 = "llvm.and"(%32, %1) : (i64, i64) -> i64
    %35 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %36 = "llvm.load"(%35) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %37 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %38 = "llvm.load"(%37) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %39 = "llvm.add"(%38, %36) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %40 = "llvm.add"(%39, %33) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %41 = "llvm.lshr"(%40, %0) : (i64, i64) -> i64
    %42 = "llvm.and"(%40, %1) : (i64, i64) -> i64
    %43 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %44 = "llvm.load"(%43) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %45 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %46 = "llvm.load"(%45) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %47 = "llvm.add"(%46, %44) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %48 = "llvm.add"(%47, %41) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %49 = "llvm.add"(%18, %2) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %50 = "llvm.lshr"(%49, %3) : (i64, i64) -> i64
    %51 = "llvm.shl"(%50, %0) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %52 = "llvm.add"(%49, %51) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %53 = "llvm.or"(%50, %4) <{isDisjoint}> : (i64, i64) -> i64
    %54 = "llvm.icmp"(%26, %53) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %55 = "llvm.select"(%54, %5, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %56 = "llvm.sub"(%26, %53) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %57 = "llvm.add"(%56, %55) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %58 = "llvm.select"(%54, %7, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %59 = "llvm.select"(%54, %9, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %60 = "llvm.icmp"(%34, %59) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %61 = "llvm.sext"(%60) : (i1) -> i64
    %62 = "llvm.select"(%60, %5, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %63 = "llvm.add"(%58, %34) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %64 = "llvm.add"(%63, %62) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %65 = "llvm.icmp"(%42, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
    %66 = "llvm.and"(%65, %60) : (i1, i1) -> i1
    %67 = "llvm.select"(%66, %5, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %68 = "llvm.add"(%42, %61) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %69 = "llvm.add"(%68, %67) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %70 = "llvm.select"(%66, %11, %12) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %71 = "llvm.add"(%70, %48) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %72 = "llvm.lshr"(%71, %3) : (i64, i64) -> i64
    %73 = "llvm.shl"(%72, %0) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %74 = "llvm.add"(%71, %73) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %75 = "llvm.add"(%72, %13) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %76 = "llvm.xor"(%52, %18) : (i64, i64) -> i64
    %77 = "llvm.and"(%75, %76) : (i64, i64) -> i64
    %78 = "llvm.xor"(%77, %18) : (i64, i64) -> i64
    %79 = "llvm.xor"(%57, %26) : (i64, i64) -> i64
    %80 = "llvm.and"(%75, %79) : (i64, i64) -> i64
    %81 = "llvm.xor"(%80, %26) : (i64, i64) -> i64
    %82 = "llvm.xor"(%64, %34) : (i64, i64) -> i64
    %83 = "llvm.and"(%75, %82) : (i64, i64) -> i64
    %84 = "llvm.xor"(%83, %34) : (i64, i64) -> i64
    %85 = "llvm.xor"(%69, %42) : (i64, i64) -> i64
    %86 = "llvm.and"(%75, %85) : (i64, i64) -> i64
    %87 = "llvm.xor"(%86, %42) : (i64, i64) -> i64
    %88 = "llvm.xor"(%74, %48) : (i64, i64) -> i64
    %89 = "llvm.and"(%88, %75) : (i64, i64) -> i64
    %90 = "llvm.xor"(%89, %48) : (i64, i64) -> i64
    "llvm.store"(%78, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %91 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%81, %91) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %92 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%84, %92) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %93 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%87, %93) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %94 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%90, %94) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end MLIR.Zig

module

-- zig-build/out/mlir_canonicalized/region/Fe.rejectNonCanonical.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_rejectNonCanonical :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
    %1 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
    %2 = "llvm.mlir.constant"() <{value = 511 : i16}> : () -> i16
    %3 = "llvm.mlir.constant"() <{value = 236 : i16}> : () -> i16
    %4 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
    %5 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
    %6 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
    %7 = "llvm.load"(%6) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %8 = "llvm.and"(%7, %0) : (i8, i8) -> i8
    %9 = "llvm.xor"(%8, %0) : (i8, i8) -> i8
    %10 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
    %11 = "llvm.load"(%10) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %12 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
    %13 = "llvm.load"(%12) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %14 = "llvm.and"(%13, %11) : (i8, i8) -> i8
    %15 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %17 = "llvm.and"(%14, %16) : (i8, i8) -> i8
    %18 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
    %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %20 = "llvm.and"(%17, %19) : (i8, i8) -> i8
    %21 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
    %22 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %23 = "llvm.and"(%20, %22) : (i8, i8) -> i8
    %24 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
    %25 = "llvm.load"(%24) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %26 = "llvm.and"(%23, %25) : (i8, i8) -> i8
    %27 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %28 = "llvm.load"(%27) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %29 = "llvm.and"(%26, %28) : (i8, i8) -> i8
    %30 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
    %31 = "llvm.load"(%30) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %32 = "llvm.and"(%29, %31) : (i8, i8) -> i8
    %33 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
    %34 = "llvm.load"(%33) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %35 = "llvm.and"(%32, %34) : (i8, i8) -> i8
    %36 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
    %37 = "llvm.load"(%36) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %38 = "llvm.and"(%35, %37) : (i8, i8) -> i8
    %39 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
    %40 = "llvm.load"(%39) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %41 = "llvm.and"(%38, %40) : (i8, i8) -> i8
    %42 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
    %43 = "llvm.load"(%42) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %44 = "llvm.and"(%41, %43) : (i8, i8) -> i8
    %45 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
    %46 = "llvm.load"(%45) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %47 = "llvm.and"(%44, %46) : (i8, i8) -> i8
    %48 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
    %49 = "llvm.load"(%48) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %50 = "llvm.and"(%47, %49) : (i8, i8) -> i8
    %51 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %52 = "llvm.load"(%51) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %53 = "llvm.and"(%50, %52) : (i8, i8) -> i8
    %54 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
    %55 = "llvm.load"(%54) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %56 = "llvm.and"(%53, %55) : (i8, i8) -> i8
    %57 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
    %58 = "llvm.load"(%57) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %59 = "llvm.and"(%56, %58) : (i8, i8) -> i8
    %60 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
    %61 = "llvm.load"(%60) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %62 = "llvm.and"(%59, %61) : (i8, i8) -> i8
    %63 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
    %64 = "llvm.load"(%63) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %65 = "llvm.and"(%62, %64) : (i8, i8) -> i8
    %66 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
    %67 = "llvm.load"(%66) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %68 = "llvm.and"(%65, %67) : (i8, i8) -> i8
    %69 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
    %70 = "llvm.load"(%69) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %71 = "llvm.and"(%68, %70) : (i8, i8) -> i8
    %72 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
    %73 = "llvm.load"(%72) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %74 = "llvm.and"(%71, %73) : (i8, i8) -> i8
    %75 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %76 = "llvm.load"(%75) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %77 = "llvm.and"(%74, %76) : (i8, i8) -> i8
    %78 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
    %79 = "llvm.load"(%78) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %80 = "llvm.and"(%77, %79) : (i8, i8) -> i8
    %81 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
    %82 = "llvm.load"(%81) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %83 = "llvm.and"(%80, %82) : (i8, i8) -> i8
    %84 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
    %85 = "llvm.load"(%84) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %86 = "llvm.and"(%83, %85) : (i8, i8) -> i8
    %87 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
    %88 = "llvm.load"(%87) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %89 = "llvm.and"(%86, %88) : (i8, i8) -> i8
    %90 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
    %91 = "llvm.load"(%90) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %92 = "llvm.and"(%89, %91) : (i8, i8) -> i8
    %93 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
    %94 = "llvm.load"(%93) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %95 = "llvm.and"(%92, %94) : (i8, i8) -> i8
    %96 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
    %97 = "llvm.load"(%96) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %98 = "llvm.and"(%95, %97) : (i8, i8) -> i8
    %99 = "llvm.xor"(%98, %1) : (i8, i8) -> i8
    %100 = "llvm.or"(%9, %99) : (i8, i8) -> i8
    %101 = "llvm.zext"(%100) : (i8) -> i16
    %102 = "llvm.add"(%101, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i16, i16) -> i16
    %103 = "llvm.load"(%arg0) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %104 = "llvm.zext"(%103) : (i8) -> i16
    %105 = "llvm.sub"(%3, %104) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %106 = "llvm.and"(%102, %105) : (i16, i16) -> i16
    %107 = "llvm.lshr"(%106, %4) : (i16, i16) -> i16
    %108 = "llvm.and"(%107, %5) : (i16, i16) -> i16
    "llvm.return"(%108) : (i16) -> ()
}

end

end MLIR.Zig

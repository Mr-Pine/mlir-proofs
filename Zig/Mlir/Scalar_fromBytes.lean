module

-- zig-build/out/mlir_canonicalized/region/Scalar.fromBytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Scalar_fromBytes :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 44162584779952923 : i128}> : () -> i128
    %10 = "llvm.mlir.constant"() <{value = 9390964836247533 : i128}> : () -> i128
    %11 = "llvm.mlir.constant"() <{value = 72057594036560134 : i128}> : () -> i128
    %12 = "llvm.mlir.constant"() <{value = 72057594037927935 : i128}> : () -> i128
    %13 = "llvm.mlir.constant"() <{value = 68719476735 : i128}> : () -> i128
    %14 = "llvm.mlir.constant"() <{value = 56 : i128}> : () -> i128
    %15 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %16 = "llvm.mlir.constant"() <{value = 5175514460705773 : i128}> : () -> i128
    %17 = "llvm.mlir.constant"() <{value = 70332060721272408 : i128}> : () -> i128
    %18 = "llvm.mlir.constant"() <{value = 18446744073709546274 : i128}> : () -> i128
    %19 = "llvm.mlir.constant"() <{value = 1099243192320 : i64}> : () -> i64
    %20 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %21 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
    %22 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
    %23 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
    %24 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
    %25 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
    %26 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
    %27 = "llvm.mlir.constant"() <{value = 268435456 : i64}> : () -> i64
    %28 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<10 x i64>}> : (i32) -> !llvm.ptr
    %29 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%28) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%29) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%29, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%2)[^bb1] : (i64) -> ()
  ^bb1(%30: i64):  // 2 preds: ^bb0, ^bb2
    %31 = "llvm.icmp"(%30, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%31)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %32 = "llvm.getelementptr"(%28, %30) <{elem_type = !llvm.array<10 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %33 = "llvm.mul"(%30, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %34 = "llvm.getelementptr"(%29, %33) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %35 = "llvm.load"(%34) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %36 = "llvm.and"(%35, %5) : (i64, i64) -> i64
    "llvm.store"(%36, %32) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %37 = "llvm.add"(%30, %6) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%37)[^bb1] : (i64) -> ()
  ^bb3:  // pred: ^bb1
    %38 = "llvm.getelementptr"(%29) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
    %39 = "llvm.load"(%38) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
    %40 = "llvm.zext"(%39) : (i32) -> i64
    %41 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %42 = "llvm.getelementptr"(%28) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %43 = "llvm.load"(%42) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %44 = "llvm.getelementptr"(%28) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %45 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %46 = "llvm.getelementptr"(%28) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %47 = "llvm.load"(%46) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.intr.lifetime.end"(%28) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%29) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    %48 = "llvm.lshr"(%40, %8) : (i64, i64) -> i64
    %49 = "llvm.zext"(%48) <{nonNeg}> : (i64) -> i128
    %50 = "llvm.mul"(%49, %9) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %51 = "llvm.mul"(%49, %10) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %52 = "llvm.mul"(%49, %11) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %53 = "llvm.mul"(%49, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %54 = "llvm.mul"(%49, %13) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %55 = "llvm.lshr"(%50, %14) : (i128, i128) -> i128
    %56 = "llvm.add"(%55, %51) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %57 = "llvm.lshr"(%56, %14) : (i128, i128) -> i128
    %58 = "llvm.add"(%57, %52) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %59 = "llvm.lshr"(%58, %14) : (i128, i128) -> i128
    %60 = "llvm.add"(%59, %53) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %61 = "llvm.lshr"(%60, %14) : (i128, i128) -> i128
    %62 = "llvm.add"(%61, %54) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %63 = "llvm.trunc"(%62) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128) -> i64
    %64 = "llvm.lshr"(%63, %15) : (i64, i64) -> i64
    %65 = "llvm.zext"(%64) <{nonNeg}> : (i64) -> i128
    %66 = "llvm.mul"(%65, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %67 = "llvm.mul"(%65, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %68 = "llvm.mul"(%65, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %69 = "llvm.shl"(%64, %7) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %70 = "llvm.lshr"(%66, %14) : (i128, i128) -> i128
    %71 = "llvm.trunc"(%66) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128) -> i64
    %72 = "llvm.and"(%71, %5) : (i64, i64) -> i64
    %73 = "llvm.add"(%70, %67) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %74 = "llvm.lshr"(%73, %14) : (i128, i128) -> i128
    %75 = "llvm.trunc"(%73) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128) -> i64
    %76 = "llvm.and"(%75, %5) : (i64, i64) -> i64
    %77 = "llvm.sub"(%68, %74) <{overflowFlags = #llvm.overflow<nsw>}> : (i128, i128) -> i128
    %78 = "llvm.trunc"(%77) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %79 = "llvm.and"(%69, %19) : (i64, i64) -> i64
    %80 = "llvm.sub"(%41, %72) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %81 = "llvm.ashr"(%80, %20) : (i64, i64) -> i64
    %82 = "llvm.lshr"(%80, %4) : (i64, i64) -> i64
    %83 = "llvm.and"(%82, %21) : (i64, i64) -> i64
    %84 = "llvm.add"(%83, %80) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %85 = "llvm.add"(%81, %43) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %86 = "llvm.sub"(%85, %76) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %87 = "llvm.ashr"(%86, %20) : (i64, i64) -> i64
    %88 = "llvm.lshr"(%86, %4) : (i64, i64) -> i64
    %89 = "llvm.and"(%88, %21) : (i64, i64) -> i64
    %90 = "llvm.add"(%89, %86) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %91 = "llvm.add"(%45, %78) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %92 = "llvm.add"(%91, %87) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %93 = "llvm.ashr"(%92, %20) : (i64, i64) -> i64
    %94 = "llvm.lshr"(%92, %20) : (i64, i64) -> i64
    %95 = "llvm.shl"(%94, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %96 = "llvm.add"(%95, %92) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %97 = "llvm.sub"(%47, %94) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %98 = "llvm.lshr"(%97, %20) : (i64, i64) -> i64
    %99 = "llvm.shl"(%98, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %100 = "llvm.add"(%93, %47) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %101 = "llvm.add"(%100, %99) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %102 = "llvm.or"(%98, %79) <{isDisjoint}> : (i64, i64) -> i64
    %103 = "llvm.icmp"(%102, %40) <{predicate = 8 : i64}> : (i64, i64) -> i1
    %104 = "llvm.select"(%103, %23, %2) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %105 = "llvm.or"(%104, %40) <{isDisjoint}> : (i64, i64) -> i64
    %106 = "llvm.sub"(%105, %102) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %107 = "llvm.add"(%84, %24) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %108 = "llvm.lshr"(%107, %20) : (i64, i64) -> i64
    %109 = "llvm.shl"(%108, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %110 = "llvm.add"(%109, %107) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %111 = "llvm.or"(%108, %25) <{isDisjoint}> : (i64, i64) -> i64
    %112 = "llvm.sub"(%90, %111) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %113 = "llvm.lshr"(%112, %20) : (i64, i64) -> i64
    %114 = "llvm.shl"(%113, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %115 = "llvm.add"(%114, %112) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %116 = "llvm.or"(%113, %26) <{isDisjoint}> : (i64, i64) -> i64
    %117 = "llvm.sub"(%96, %116) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %118 = "llvm.ashr"(%117, %20) : (i64, i64) -> i64
    %119 = "llvm.lshr"(%117, %20) : (i64, i64) -> i64
    %120 = "llvm.shl"(%119, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %121 = "llvm.add"(%120, %117) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %122 = "llvm.sub"(%101, %119) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %123 = "llvm.lshr"(%122, %20) : (i64, i64) -> i64
    %124 = "llvm.shl"(%123, %22) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %125 = "llvm.add"(%118, %101) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %126 = "llvm.add"(%125, %124) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %127 = "llvm.or"(%123, %27) <{isDisjoint}> : (i64, i64) -> i64
    %128 = "llvm.icmp"(%106, %127) <{predicate = 2 : i64}> : (i64, i64) -> i1
    %129 = "llvm.select"(%128, %84, %110) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %130 = "llvm.select"(%128, %90, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %131 = "llvm.select"(%128, %96, %121) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %132 = "llvm.select"(%128, %101, %126) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %133 = "llvm.select"(%128, %2, %127) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %134 = "llvm.sub"(%106, %133) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.store"(%129, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %135 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%130, %135) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %136 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%131, %136) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %137 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%132, %137) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %138 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%134, %138) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end MLIR.Zig

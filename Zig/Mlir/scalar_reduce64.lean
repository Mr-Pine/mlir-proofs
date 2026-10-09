module

-- zig-build/out/mlir_canonicalized/region/scalar.reduce64.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Scalar_toBytes

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Scalar_toBytes

namespace MLIR.Zig

@[expose] public section

mlir_def scalar_reduce64 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
    %10 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %11 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %12 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
    %13 = "llvm.mlir.constant"() <{value = 72057589742960640 : i64}> : () -> i64
    %14 = "llvm.mlir.constant"() <{value = 44162584779952923 : i128}> : () -> i128
    %15 = "llvm.mlir.constant"() <{value = 9390964836247533 : i128}> : () -> i128
    %16 = "llvm.mlir.constant"() <{value = 72057594036560134 : i128}> : () -> i128
    %17 = "llvm.mlir.constant"() <{value = 72057594037927935 : i128}> : () -> i128
    %18 = "llvm.mlir.constant"() <{value = 68719476735 : i128}> : () -> i128
    %19 = "llvm.mlir.constant"() <{value = 56 : i128}> : () -> i128
    %20 = "llvm.mlir.constant"() <{value = 72057594037862400 : i64}> : () -> i64
    %21 = "llvm.mlir.constant"() <{value = 65535 : i64}> : () -> i64
    %22 = "llvm.mlir.constant"() <{value = 40 : i128}> : () -> i128
    %23 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
    %24 = "llvm.mlir.constant"() <{value = 5175514460705773 : i128}> : () -> i128
    %25 = "llvm.mlir.constant"() <{value = 70332060721272408 : i128}> : () -> i128
    %26 = "llvm.mlir.constant"() <{value = 5342 : i128}> : () -> i128
    %27 = "llvm.mlir.constant"() <{value = 28 : i128}> : () -> i128
    %28 = "llvm.mlir.constant"() <{value = 699938952792 : i128}> : () -> i128
    %29 = "llvm.mlir.constant"() <{value = 113228764141 : i128}> : () -> i128
    %30 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
    %31 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
    %32 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
    %33 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
    %34 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
    %35 = "llvm.mlir.constant"() <{value = 268435456 : i64}> : () -> i64
    %36 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %37 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<10 x i64>}> : (i32) -> !llvm.ptr
    %38 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %39 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%37) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%38) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%38, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%2)[^bb1] : (i64) -> ()
  ^bb1(%40: i64):  // 2 preds: ^bb0, ^bb2
    %41 = "llvm.icmp"(%40, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%41)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %42 = "llvm.getelementptr"(%37, %40) <{elem_type = !llvm.array<10 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %43 = "llvm.mul"(%40, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %44 = "llvm.getelementptr"(%38, %43) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %45 = "llvm.load"(%44) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %46 = "llvm.and"(%45, %5) : (i64, i64) -> i64
    "llvm.store"(%46, %42) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %47 = "llvm.add"(%40, %6) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%47)[^bb1] : (i64) -> ()
  ^bb3:  // pred: ^bb1
    %48 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
    %49 = "llvm.load"(%48) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %50 = "llvm.zext"(%49) : (i8) -> i64
    %51 = "llvm.load"(%37) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %52 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %53 = "llvm.load"(%52) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %54 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %55 = "llvm.load"(%54) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %56 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %57 = "llvm.load"(%56) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %58 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %59 = "llvm.load"(%58) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %60 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    %61 = "llvm.load"(%60) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %62 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %63 = "llvm.load"(%62) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %64 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
    %65 = "llvm.load"(%64) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %66 = "llvm.getelementptr"(%37) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %67 = "llvm.load"(%66) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.intr.lifetime.end"(%37) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%38) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%36) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %68 = "llvm.shl"(%61, %10) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %69 = "llvm.and"(%68, %13) : (i64, i64) -> i64
    %70 = "llvm.lshr"(%59, %9) : (i64, i64) -> i64
    %71 = "llvm.or"(%69, %70) : (i64, i64) -> i64
    %72 = "llvm.shl"(%63, %10) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %73 = "llvm.and"(%72, %13) : (i64, i64) -> i64
    %74 = "llvm.lshr"(%61, %9) : (i64, i64) -> i64
    %75 = "llvm.or"(%73, %74) : (i64, i64) -> i64
    %76 = "llvm.shl"(%65, %10) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %77 = "llvm.and"(%76, %13) : (i64, i64) -> i64
    %78 = "llvm.lshr"(%63, %9) : (i64, i64) -> i64
    %79 = "llvm.or"(%77, %78) : (i64, i64) -> i64
    %80 = "llvm.shl"(%67, %10) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %81 = "llvm.and"(%80, %13) : (i64, i64) -> i64
    %82 = "llvm.lshr"(%65, %9) : (i64, i64) -> i64
    %83 = "llvm.or"(%81, %82) : (i64, i64) -> i64
    %84 = "llvm.shl"(%50, %10) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %85 = "llvm.lshr"(%67, %9) : (i64, i64) -> i64
    %86 = "llvm.or"(%85, %84) : (i64, i64) -> i64
    %87 = "llvm.zext"(%71) <{nonNeg}> : (i64) -> i128
    %88 = "llvm.mul"(%87, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %89 = "llvm.mul"(%87, %15) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %90 = "llvm.mul"(%87, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %91 = "llvm.mul"(%87, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %92 = "llvm.mul"(%87, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %93 = "llvm.zext"(%75) <{nonNeg}> : (i64) -> i128
    %94 = "llvm.mul"(%93, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %95 = "llvm.mul"(%93, %15) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %96 = "llvm.mul"(%93, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %97 = "llvm.mul"(%93, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %98 = "llvm.mul"(%93, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %99 = "llvm.zext"(%79) <{nonNeg}> : (i64) -> i128
    %100 = "llvm.mul"(%99, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %101 = "llvm.mul"(%99, %15) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %102 = "llvm.mul"(%99, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %103 = "llvm.mul"(%99, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %104 = "llvm.mul"(%99, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %105 = "llvm.zext"(%83) <{nonNeg}> : (i64) -> i128
    %106 = "llvm.mul"(%105, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %107 = "llvm.mul"(%105, %15) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %108 = "llvm.mul"(%105, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %109 = "llvm.mul"(%105, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %110 = "llvm.mul"(%105, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %111 = "llvm.zext"(%86) <{nonNeg}> : (i64) -> i128
    %112 = "llvm.mul"(%111, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %113 = "llvm.mul"(%111, %15) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %114 = "llvm.mul"(%111, %16) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %115 = "llvm.mul"(%111, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %116 = "llvm.mul"(%111, %18) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %117 = "llvm.add"(%94, %89) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %118 = "llvm.add"(%95, %90) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %119 = "llvm.add"(%118, %100) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %120 = "llvm.add"(%96, %91) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %121 = "llvm.add"(%120, %101) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %122 = "llvm.add"(%121, %106) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %123 = "llvm.add"(%97, %92) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %124 = "llvm.add"(%123, %102) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %125 = "llvm.add"(%103, %98) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %126 = "llvm.add"(%110, %115) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %127 = "llvm.lshr"(%88, %19) : (i128, i128) -> i128
    %128 = "llvm.add"(%117, %127) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %129 = "llvm.lshr"(%128, %19) : (i128, i128) -> i128
    %130 = "llvm.add"(%119, %129) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %131 = "llvm.lshr"(%130, %19) : (i128, i128) -> i128
    %132 = "llvm.add"(%122, %131) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %133 = "llvm.lshr"(%132, %19) : (i128, i128) -> i128
    %134 = "llvm.add"(%124, %112) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %135 = "llvm.add"(%134, %107) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %136 = "llvm.add"(%135, %133) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %137 = "llvm.lshr"(%136, %19) : (i128, i128) -> i128
    %138 = "llvm.trunc"(%136) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %139 = "llvm.add"(%125, %113) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %140 = "llvm.add"(%139, %108) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %141 = "llvm.add"(%140, %137) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %142 = "llvm.lshr"(%141, %19) : (i128, i128) -> i128
    %143 = "llvm.trunc"(%141) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %144 = "llvm.add"(%114, %104) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %145 = "llvm.add"(%144, %109) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %146 = "llvm.add"(%145, %142) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %147 = "llvm.lshr"(%146, %19) : (i128, i128) -> i128
    %148 = "llvm.trunc"(%146) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %149 = "llvm.add"(%126, %147) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %150 = "llvm.lshr"(%149, %19) : (i128, i128) -> i128
    %151 = "llvm.trunc"(%149) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %152 = "llvm.add"(%150, %116) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %153 = "llvm.trunc"(%152) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %154 = "llvm.shl"(%143, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %155 = "llvm.and"(%154, %20) : (i64, i64) -> i64
    %156 = "llvm.lshr"(%138, %11) : (i64, i64) -> i64
    %157 = "llvm.and"(%156, %21) : (i64, i64) -> i64
    %158 = "llvm.or"(%155, %157) <{isDisjoint}> : (i64, i64) -> i64
    %159 = "llvm.shl"(%148, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %160 = "llvm.and"(%159, %20) : (i64, i64) -> i64
    %161 = "llvm.lshr"(%143, %11) : (i64, i64) -> i64
    %162 = "llvm.and"(%161, %21) : (i64, i64) -> i64
    %163 = "llvm.or"(%160, %162) <{isDisjoint}> : (i64, i64) -> i64
    %164 = "llvm.shl"(%151, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %165 = "llvm.and"(%164, %20) : (i64, i64) -> i64
    %166 = "llvm.lshr"(%148, %11) : (i64, i64) -> i64
    %167 = "llvm.and"(%166, %21) : (i64, i64) -> i64
    %168 = "llvm.or"(%165, %167) <{isDisjoint}> : (i64, i64) -> i64
    %169 = "llvm.shl"(%153, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %170 = "llvm.and"(%169, %20) : (i64, i64) -> i64
    %171 = "llvm.lshr"(%151, %11) : (i64, i64) -> i64
    %172 = "llvm.and"(%171, %21) : (i64, i64) -> i64
    %173 = "llvm.or"(%170, %172) <{isDisjoint}> : (i64, i64) -> i64
    %174 = "llvm.lshr"(%152, %22) : (i128, i128) -> i128
    %175 = "llvm.trunc"(%174) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128) -> i64
    %176 = "llvm.and"(%175, %20) : (i64, i64) -> i64
    %177 = "llvm.lshr"(%153, %11) : (i64, i64) -> i64
    %178 = "llvm.and"(%177, %21) : (i64, i64) -> i64
    %179 = "llvm.or"(%178, %176) <{isDisjoint}> : (i64, i64) -> i64
    %180 = "llvm.and"(%59, %23) : (i64, i64) -> i64
    %181 = "llvm.zext"(%158) <{nonNeg}> : (i64) -> i128
    %182 = "llvm.mul"(%181, %24) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %183 = "llvm.mul"(%181, %25) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %184 = "llvm.mul"(%181, %26) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %185 = "llvm.shl"(%181, %27) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %186 = "llvm.zext"(%163) <{nonNeg}> : (i64) -> i128
    %187 = "llvm.mul"(%186, %24) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %188 = "llvm.mul"(%186, %25) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %189 = "llvm.mul"(%186, %26) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %190 = "llvm.zext"(%168) <{nonNeg}> : (i64) -> i128
    %191 = "llvm.mul"(%190, %24) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %192 = "llvm.mul"(%190, %25) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %193 = "llvm.mul"(%190, %26) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %194 = "llvm.zext"(%173) <{nonNeg}> : (i64) -> i128
    %195 = "llvm.mul"(%194, %24) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %196 = "llvm.mul"(%194, %28) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %197 = "llvm.zext"(%179) <{nonNeg}> : (i64) -> i128
    %198 = "llvm.mul"(%197, %29) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %199 = "llvm.lshr"(%182, %19) : (i128, i128) -> i128
    %200 = "llvm.trunc"(%182) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %201 = "llvm.and"(%200, %5) : (i64, i64) -> i64
    %202 = "llvm.add"(%199, %183) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %203 = "llvm.add"(%202, %187) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %204 = "llvm.lshr"(%203, %19) : (i128, i128) -> i128
    %205 = "llvm.trunc"(%203) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %206 = "llvm.and"(%205, %5) : (i64, i64) -> i64
    %207 = "llvm.add"(%188, %184) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %208 = "llvm.add"(%207, %191) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %209 = "llvm.add"(%208, %204) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %210 = "llvm.lshr"(%209, %19) : (i128, i128) -> i128
    %211 = "llvm.trunc"(%209) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %212 = "llvm.and"(%211, %5) : (i64, i64) -> i64
    %213 = "llvm.add"(%192, %189) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %214 = "llvm.add"(%213, %195) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %215 = "llvm.add"(%214, %210) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %216 = "llvm.lshr"(%215, %19) : (i128, i128) -> i128
    %217 = "llvm.trunc"(%215) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %218 = "llvm.and"(%217, %5) : (i64, i64) -> i64
    %219 = "llvm.add"(%193, %185) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %220 = "llvm.add"(%219, %196) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %221 = "llvm.add"(%220, %198) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %222 = "llvm.add"(%221, %216) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %223 = "llvm.trunc"(%222) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %224 = "llvm.and"(%223, %23) : (i64, i64) -> i64
    %225 = "llvm.sub"(%51, %201) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %226 = "llvm.ashr"(%225, %7) : (i64, i64) -> i64
    %227 = "llvm.lshr"(%225, %4) : (i64, i64) -> i64
    %228 = "llvm.and"(%227, %30) : (i64, i64) -> i64
    %229 = "llvm.add"(%228, %225) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %230 = "llvm.add"(%226, %53) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %231 = "llvm.sub"(%230, %206) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %232 = "llvm.ashr"(%231, %7) : (i64, i64) -> i64
    %233 = "llvm.lshr"(%231, %4) : (i64, i64) -> i64
    %234 = "llvm.and"(%233, %30) : (i64, i64) -> i64
    %235 = "llvm.add"(%234, %231) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %236 = "llvm.add"(%232, %55) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %237 = "llvm.sub"(%236, %212) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %238 = "llvm.ashr"(%237, %7) : (i64, i64) -> i64
    %239 = "llvm.lshr"(%237, %4) : (i64, i64) -> i64
    %240 = "llvm.and"(%239, %30) : (i64, i64) -> i64
    %241 = "llvm.add"(%240, %237) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %242 = "llvm.sub"(%57, %218) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %243 = "llvm.add"(%242, %238) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %244 = "llvm.lshr"(%243, %7) : (i64, i64) -> i64
    %245 = "llvm.shl"(%244, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %246 = "llvm.add"(%245, %243) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %247 = "llvm.add"(%244, %224) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %248 = "llvm.icmp"(%180, %247) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %249 = "llvm.select"(%248, %31, %2) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %250 = "llvm.or"(%249, %180) <{isDisjoint}> : (i64, i64) -> i64
    %251 = "llvm.sub"(%250, %247) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %252 = "llvm.add"(%229, %32) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %253 = "llvm.lshr"(%252, %7) : (i64, i64) -> i64
    %254 = "llvm.shl"(%253, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %255 = "llvm.add"(%254, %252) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %256 = "llvm.or"(%253, %33) <{isDisjoint}> : (i64, i64) -> i64
    %257 = "llvm.sub"(%235, %256) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %258 = "llvm.lshr"(%257, %7) : (i64, i64) -> i64
    %259 = "llvm.shl"(%258, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %260 = "llvm.add"(%259, %257) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %261 = "llvm.or"(%258, %34) <{isDisjoint}> : (i64, i64) -> i64
    %262 = "llvm.sub"(%241, %261) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %263 = "llvm.ashr"(%262, %7) : (i64, i64) -> i64
    %264 = "llvm.lshr"(%262, %7) : (i64, i64) -> i64
    %265 = "llvm.shl"(%264, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %266 = "llvm.add"(%265, %262) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %267 = "llvm.sub"(%246, %264) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %268 = "llvm.lshr"(%267, %7) : (i64, i64) -> i64
    %269 = "llvm.shl"(%268, %12) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %270 = "llvm.add"(%246, %263) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %271 = "llvm.add"(%270, %269) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %272 = "llvm.or"(%268, %35) <{isDisjoint}> : (i64, i64) -> i64
    %273 = "llvm.icmp"(%251, %272) <{predicate = 2 : i64}> : (i64, i64) -> i1
    %274 = "llvm.select"(%273, %229, %255) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %275 = "llvm.select"(%273, %235, %260) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %276 = "llvm.select"(%273, %241, %266) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %277 = "llvm.select"(%273, %246, %271) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %278 = "llvm.select"(%273, %2, %272) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %279 = "llvm.sub"(%251, %278) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.store"(%274, %36) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %280 = "llvm.getelementptr"(%36) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%275, %280) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %281 = "llvm.getelementptr"(%36) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%276, %281) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %282 = "llvm.getelementptr"(%36) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%277, %282) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %283 = "llvm.getelementptr"(%36) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%279, %283) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.call"(%39, %36) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%36) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %39, %10) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Scalar.toBytes := Scalar_toBytes

end

end MLIR.Zig

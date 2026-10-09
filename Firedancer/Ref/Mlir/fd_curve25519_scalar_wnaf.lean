module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_curve25519_scalar_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_int_min

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_int_min

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
    %0 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 536870911 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 7 : i16}> : () -> i16
    %5 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
    %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %9 = "llvm.mlir.constant"() <{value = 256 : i32}> : () -> i32
    %10 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
    %11 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
    %12 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
    %13 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
    %14 = "llvm.mlir.constant"() <{value = 65536 : i32}> : () -> i32
    %15 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
    %16 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %17 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
    %18 = "llvm.shl"(%0, %arg2) <{overflowFlags = #llvm.overflow<nsw>}> : (i32, i32) -> i32
    "llvm.br"(%1)[^bb2] : (i64) -> ()
  ^bb1:  // pred: ^bb2
    %19 = "llvm.xor"(%18, %0) : (i32, i32) -> i32
    %20 = "llvm.getelementptr"(%arg0) <{elem_type = i16, rawConstantIndices = array<i32: 255>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%8, %20) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    "llvm.br"(%1)[^bb3] : (i64) -> ()
  ^bb2(%21: i64):  // 2 preds: ^bb0, ^bb2
    %22 = "llvm.trunc"(%21) : (i64) -> i16
    %23 = "llvm.lshr"(%21, %2) : (i64, i64) -> i64
    %24 = "llvm.and"(%23, %3) : (i64, i64) -> i64
    %25 = "llvm.getelementptr"(%arg1, %24) <{elem_type = i8, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %26 = "llvm.load"(%25) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
    %27 = "llvm.zext"(%26) : (i8) -> i16
    %28 = "llvm.and"(%22, %4) : (i16, i16) -> i16
    %29 = "llvm.lshr"(%27, %28) : (i16, i16) -> i16
    %30 = "llvm.and"(%29, %5) : (i16, i16) -> i16
    %31 = "llvm.getelementptr"(%arg0, %21) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.store"(%30, %31) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    %32 = "llvm.add"(%21, %6) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %33 = "llvm.icmp"(%32, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%33, %32)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
  ^bb3(%34: i64):  // 2 preds: ^bb1, ^bb4
    %35 = "llvm.getelementptr"(%arg0, %34) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %36 = "llvm.load"(%35) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
    %37 = "llvm.icmp"(%36, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%37)[^bb4, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb4:  // pred: ^bb3
    %38 = "llvm.add"(%34, %6) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %39 = "llvm.icmp"(%38, %17) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%39, %38)[^bb20, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
  ^bb5:  // pred: ^bb3
    %40 = "llvm.trunc"(%34) : (i64) -> i32
    %41 = "llvm.icmp"(%40, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%41)[^bb6, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb6:  // pred: ^bb5
    %42 = "llvm.shl"(%19, %10) <{overflowFlags = #llvm.overflow<none>}> : (i32, i32) -> i32
    %43 = "llvm.ashr"(%42, %10) : (i32, i32) -> i32
    %44 = "llvm.ashr"(%42, %11) : (i32, i32) -> i32
    %45 = "llvm.sub"(%12, %43) <{overflowFlags = #llvm.overflow<nsw>}> : (i32, i32) -> i32
    "llvm.br"(%40)[^bb7] : (i32) -> ()
  ^bb7(%46: i32):  // 2 preds: ^bb6, ^bb19
    %47 = "llvm.icmp"(%46, %13) <{predicate = 2 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%47, %7, %5)[^bb8, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i16) -> ()
  ^bb8:  // pred: ^bb7
    %48 = "llvm.sext"(%46) : (i32) -> i64
    "llvm.br"(%48, %5)[^bb9] : (i64, i16) -> ()
  ^bb9(%49: i64, %50: i16):  // 2 preds: ^bb8, ^bb17
    %51 = "llvm.add"(%49, %6) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %52 = "llvm.getelementptr"(%arg0, %51) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %53 = "llvm.load"(%52) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
    %54 = "llvm.icmp"(%53, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%54, %50)[^bb17, ^bb10] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i16) -> ()
  ^bb10:  // pred: ^bb9
    %55 = "llvm.trunc"(%51) : (i64) -> i32
    %56 = "llvm.sub"(%55, %46) <{overflowFlags = #llvm.overflow<none>}> : (i32, i32) -> i32
    %57 = "llvm.call"(%56) <{CConv = #llvm.cconv<fastcc>, callee = @fd_int_min, fastmathFlags = #llvm.fastmath<none>}> : (i32) -> i32
    %58 = "llvm.shl"(%14, %57) <{overflowFlags = #llvm.overflow<none>}> : (i32, i32) -> i32
    %59 = "llvm.ashr"(%58, %10) : (i32, i32) -> i32
    %60 = "llvm.icmp"(%59, %44) <{predicate = 4 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%60, %55, %50)[^bb19, ^bb11] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
  ^bb11:  // pred: ^bb10
    %61 = "llvm.trunc"(%59) : (i32) -> i16
    %62 = "llvm.add"(%50, %61) <{overflowFlags = #llvm.overflow<none>}> : (i16, i16) -> i16
    %63 = "llvm.sext"(%62) : (i16) -> i32
    %64 = "llvm.icmp"(%43, %63) <{predicate = 2 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%64)[^bb13, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb12:  // pred: ^bb11
    "llvm.store"(%8, %52) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    "llvm.br"(%62)[^bb17] : (i16) -> ()
  ^bb13:  // pred: ^bb11
    %65 = "llvm.sub"(%50, %61) <{overflowFlags = #llvm.overflow<none>}> : (i16, i16) -> i16
    %66 = "llvm.sext"(%65) : (i16) -> i32
    %67 = "llvm.icmp"(%66, %45) <{predicate = 2 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%67, %55, %50)[^bb19, ^bb14] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
  ^bb14:  // pred: ^bb13
    %68 = "llvm.trunc"(%49) : (i64) -> i32
    "llvm.store"(%8, %52) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    %69 = "llvm.add"(%68, %15) <{overflowFlags = #llvm.overflow<none>}> : (i32, i32) -> i32
    %70 = "llvm.sext"(%69) : (i32) -> i64
    %71 = "llvm.getelementptr"(%arg0, %70) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %72 = "llvm.load"(%71) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
    %73 = "llvm.icmp"(%72, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%73, %69, %71, %71, %69)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
  ^bb15(%74: i32, %75: !llvm.ptr):  // 2 preds: ^bb14, ^bb16
    "llvm.store"(%5, %75) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    "llvm.br"(%74, %65)[^bb19] : (i32, i16) -> ()
  ^bb16(%76: !llvm.ptr, %77: i32):  // 2 preds: ^bb14, ^bb16
    "llvm.store"(%8, %76) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    %78 = "llvm.add"(%77, %16) <{overflowFlags = #llvm.overflow<none>}> : (i32, i32) -> i32
    %79 = "llvm.sext"(%78) : (i32) -> i64
    %80 = "llvm.getelementptr"(%arg0, %79) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %81 = "llvm.load"(%80) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
    %82 = "llvm.icmp"(%81, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%82, %78, %80, %80, %78)[^bb15, ^bb16] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
  ^bb17(%83: i16):  // 2 preds: ^bb9, ^bb12
    %84 = "llvm.icmp"(%51, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%84, %48, %83, %51, %83)[^bb18, ^bb9] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i16, i64, i16) -> ()
  ^bb18(%85: i64, %86: i16):  // 2 preds: ^bb7, ^bb17
    %87 = "llvm.getelementptr"(%arg0, %85) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.store"(%86, %87) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb20] : () -> ()
  ^bb19(%88: i32, %89: i16):  // 3 preds: ^bb10, ^bb13, ^bb15
    %90 = "llvm.getelementptr"(%arg0, %48) <{elem_type = i16, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.store"(%89, %90) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
    %91 = "llvm.icmp"(%88, %9) <{predicate = 2 : i64}> : (i32, i32) -> i1
    "llvm.cond_br"(%91, %88)[^bb7, ^bb20] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
  ^bb20:  // 4 preds: ^bb4, ^bb5, ^bb18, ^bb19
    "llvm.return"() : () -> ()
}
  with @fd_int_min := fd_int_min

end

end MLIR.Firedancer.Ref

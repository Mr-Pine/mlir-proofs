module

-- zig-build/out/mlir_canonicalized/region/scalar.rejectNonCanonical.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.scalar_field_order_s

meta import MLIR.Semantics.Func
meta import Zig.Mlir.scalar_field_order_s

namespace MLIR.Zig

@[expose] public section

mlir_def scalar_rejectNonCanonical :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
    %2 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %4 = "llvm.mlir.addressof"() <{global_name = @scalar.field_order_s}> : () -> !llvm.ptr
    %5 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
    %6 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
    %7 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
    "llvm.br"(%0, %1, %2)[^bb1] : (i64, i8, i8) -> ()
  ^bb1(%8: i64, %9: i8, %10: i8):  // 2 preds: ^bb0, ^bb3
    %11 = "llvm.getelementptr"(%arg0, %8) <{elem_type = !llvm.array<32 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %12 = "llvm.load"(%11) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %13 = "llvm.zext"(%12) : (i8) -> i16
    %14 = "llvm.getelementptr"(%4, %8) <{elem_type = !llvm.array<32 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %15 = "llvm.load"(%14) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %16 = "llvm.zext"(%15) : (i8) -> i16
    %17 = "llvm.sub"(%13, %16) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %18 = "llvm.lshr"(%17, %5) : (i16, i16) -> i16
    %19 = "llvm.trunc"(%18) <{overflowFlags = #llvm.overflow<nuw>}> : (i16) -> i8
    %20 = "llvm.and"(%9, %19) : (i8, i8) -> i8
    %21 = "llvm.or"(%20, %10) : (i8, i8) -> i8
    %22 = "llvm.icmp"(%8, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%22)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %23 = "llvm.icmp"(%21, %2) <{predicate = 0 : i64}> : (i8, i8) -> i1
    %24 = "llvm.zext"(%23) : (i1) -> i16
    "llvm.return"(%24) : (i16) -> ()
  ^bb3:  // pred: ^bb1
    %25 = "llvm.xor"(%16, %13) : (i16, i16) -> i16
    %26 = "llvm.add"(%25, %6) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %27 = "llvm.lshr"(%26, %5) : (i16, i16) -> i16
    %28 = "llvm.trunc"(%27) <{overflowFlags = #llvm.overflow<nuw>}> : (i16) -> i8
    %29 = "llvm.and"(%9, %28) : (i8, i8) -> i8
    %30 = "llvm.add"(%8, %7) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.br"(%30, %29, %21)[^bb1] : (i64, i8, i8) -> ()
}
  with @scalar.field_order_s := scalar_field_order_s

end

end MLIR.Zig

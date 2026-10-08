module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.precompute.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_add
public import Zig.Mlir.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_identityElement

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_add
meta import Zig.Mlir.Edwards25519_dbl
meta import Zig.Mlir.Edwards25519_identityElement

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_precompute :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.identityElement}> : () -> !llvm.ptr
    %2 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 1512 : i64}> : () -> i64
    %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%11, %1, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %12 = "llvm.getelementptr"(%11) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%12, %arg1, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%3)[^bb1] : (i64) -> ()
  ^bb1(%13: i64):  // 2 preds: ^bb0, ^bb4
    %14 = "llvm.icmp"(%13, %4) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%14)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %15 = "llvm.getelementptr"(%11, %13) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %16 = "llvm.and"(%13, %6) : (i64, i64) -> i64
    %17 = "llvm.icmp"(%16, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%17)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb3:  // pred: ^bb1
    "llvm.intr.memcpy"(%arg0, %11, %8) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
  ^bb4(%18: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
    "llvm.intr.memcpy"(%15, %18, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %19 = "llvm.add"(%13, %6) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%19)[^bb1] : (i64) -> ()
  ^bb5:  // pred: ^bb2
    %20 = "llvm.lshr"(%13, %6) <{isExact}> : (i64, i64) -> i64
    %21 = "llvm.getelementptr"(%11, %20) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%10, %21) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%10)[^bb4] : (!llvm.ptr) -> ()
  ^bb6:  // pred: ^bb2
    %22 = "llvm.add"(%13, %7) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %23 = "llvm.getelementptr"(%11, %22) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%9, %23, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%9)[^bb4] : (!llvm.ptr) -> ()
}
  with @Edwards25519.add := Edwards25519_add, @Edwards25519.dbl := Edwards25519_dbl,
    @Edwards25519.identityElement := Edwards25519_identityElement

end

end LeanMLIR.RIR.Zig

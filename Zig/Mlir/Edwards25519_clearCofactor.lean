module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.clearCofactor.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_dbl

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_dbl

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_clearCofactor :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %2 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.call"(%4, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%3, %4) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%2, %3) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %2, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Edwards25519.dbl := Edwards25519_dbl

end

end MLIR.Zig

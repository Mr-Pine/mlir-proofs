module

-- zig-build/out/mlir_canonicalized/region/scalar.mul8.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Scalar_add
public import Zig.Mlir.Scalar_fromBytes
public import Zig.Mlir.Scalar_toBytes

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Scalar_add
meta import Zig.Mlir.Scalar_fromBytes
meta import Zig.Mlir.Scalar_toBytes

namespace MLIR.Zig

@[expose] public section

mlir_def scalar_mul8 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %5 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    "llvm.call"(%5, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%4, %5, %5) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%5, %4, %4) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%3, %5, %5) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%2, %3) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %2, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Scalar.add := Scalar_add, @Scalar.fromBytes := Scalar_fromBytes,
    @Scalar.toBytes := Scalar_toBytes

end

end MLIR.Zig

module

-- zig-build/out/mlir_canonicalized/region/Fe.isZero.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_reduce

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_reduce

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_isZero :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%3, %arg0, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%3) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.reduce, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
    %4 = "llvm.load"(%3) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %5 = "llvm.getelementptr"(%3) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %6 = "llvm.load"(%5) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %7 = "llvm.or"(%6, %4) : (i64, i64) -> i64
    %8 = "llvm.getelementptr"(%3) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %9 = "llvm.load"(%8) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %10 = "llvm.or"(%7, %9) : (i64, i64) -> i64
    %11 = "llvm.getelementptr"(%3) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %12 = "llvm.load"(%11) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %13 = "llvm.or"(%10, %12) : (i64, i64) -> i64
    %14 = "llvm.getelementptr"(%3) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %15 = "llvm.load"(%14) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %16 = "llvm.or"(%13, %15) : (i64, i64) -> i64
    %17 = "llvm.icmp"(%16, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.return"(%17) : (i1) -> ()
}
  with @Fe.reduce := Fe_reduce

end

end LeanMLIR.RIR.Zig

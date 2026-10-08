module

-- zig-build/out/mlir_canonicalized/region/Fe.sqn.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_sq

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_sq

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_sqn :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %5 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%5, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%2)[^bb1] : (i64) -> ()
  ^bb1(%6: i64):  // 2 preds: ^bb0, ^bb2
    %7 = "llvm.icmp"(%6, %arg2) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%7)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    "llvm.call"(%4, %5) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%5, %4, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %8 = "llvm.add"(%6, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%8)[^bb1] : (i64) -> ()
  ^bb3:  // pred: ^bb1
    "llvm.intr.memcpy"(%arg0, %5, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.sq := Fe_sq

end

end LeanMLIR.RIR.Zig

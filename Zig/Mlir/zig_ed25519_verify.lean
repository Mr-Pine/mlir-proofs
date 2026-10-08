module

-- zig-build/out/mlir_canonicalized/region/zig_ed25519_verify.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Sha512_update
public import Zig.Mlir.Verifier_init
public import Zig.Mlir.Verifier_verify

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Sha512_update
meta import Zig.Mlir.Verifier_init
meta import Zig.Mlir.Verifier_verify

namespace LeanMLIR.RIR.Zig

@[expose] public section

noncomputable mlir_def zig_ed25519_verify :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 592 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
    %5 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<(struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>, i16, array<14 x i8>)>}> : (i32) -> !llvm.ptr
    %6 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    %8 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.struct<"Signature", (array<32 x i8>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%8, %arg2, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %9 = "llvm.getelementptr"(%8) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %10 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%9, %10, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.lifetime.start"(%6) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%7) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%5) <{size = 608 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%5, %8, %arg3) <{CConv = #llvm.cconv<fastcc>, callee = @Verifier.init, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%6, %5, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %11 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    %12 = "llvm.load"(%11) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    "llvm.intr.lifetime.end"(%5) <{size = 608 : i64}> : (!llvm.ptr) -> ()
    %13 = "llvm.icmp"(%12, %3) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%13, %12)[^bb1, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb1:  // pred: ^bb0
    "llvm.intr.memcpy"(%7, %6, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%7, %arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %14 = "llvm.call"(%7) <{CConv = #llvm.cconv<fastcc>, callee = @Verifier.verify, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    "llvm.br"(%14)[^bb2] : (i16) -> ()
  ^bb2(%15: i16):  // 2 preds: ^bb0, ^bb1
    "llvm.intr.lifetime.end"(%6) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%7) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    %16 = "llvm.zext"(%15) : (i16) -> i32
    %17 = "llvm.sub"(%4, %16) <{overflowFlags = #llvm.overflow<nsw>}> : (i32, i32) -> i32
    "llvm.return"(%17) : (i32) -> ()
}
  with @Sha512.update := Sha512_update, @Verifier.init := Verifier_init,
    @Verifier.verify := Verifier_verify

end

end LeanMLIR.RIR.Zig

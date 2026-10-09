module

-- zig-build/out/mlir_canonicalized/region/Verifier.verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_clearCofactor
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic
public import Zig.Mlir.Edwards25519_neg
public import Zig.Mlir.Edwards25519_sub
public import Zig.Mlir.Sha512_final
public import Zig.Mlir.Verifier_isIdentity
public import Zig.Mlir.scalar_mul8
public import Zig.Mlir.scalar_reduce64

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_clearCofactor
meta import Zig.Mlir.Edwards25519_mulDoubleBasePublic
meta import Zig.Mlir.Edwards25519_neg
meta import Zig.Mlir.Edwards25519_sub
meta import Zig.Mlir.Sha512_final
meta import Zig.Mlir.Verifier_isIdentity
meta import Zig.Mlir.scalar_mul8
meta import Zig.Mlir.scalar_reduce64

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Verifier_verify :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %2 = "llvm.mlir.constant"() <{value = 5 : i16}> : () -> i16
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %5 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
    %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %7 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %8 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %9 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %10 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    "llvm.call"(%arg0, %10) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.final, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%9, %10) <{CConv = #llvm.cconv<fastcc>, callee = @scalar.reduce64, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %11 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 560>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%8, %11) <{CConv = #llvm.cconv<fastcc>, callee = @scalar.mul8, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %12 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%7, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.clearCofactor, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%6, %7) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.neg, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%5, %8, %6, %9) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.mulDoubleBasePublic, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %13 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    %14 = "llvm.load"(%13) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    %15 = "llvm.icmp"(%14, %1) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%15, %14)[^bb2, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb1(%16: i16):  // 2 preds: ^bb0, ^bb2
    "llvm.return"(%16) : (i16) -> ()
  ^bb2:  // pred: ^bb0
    %17 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 392>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%4, %17) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.clearCofactor, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%3, %5, %4) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %18 = "llvm.call"(%3) <{CConv = #llvm.cconv<fastcc>, callee = @Verifier.isIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    %19 = "llvm.select"(%18, %1, %2) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i16, i16) -> i16
    "llvm.br"(%19)[^bb1] : (i16) -> ()
}
  with @Edwards25519.clearCofactor := Edwards25519_clearCofactor,
    @Edwards25519.mulDoubleBasePublic := Edwards25519_mulDoubleBasePublic,
    @Edwards25519.neg := Edwards25519_neg, @Edwards25519.sub := Edwards25519_sub,
    @Sha512.final := Sha512_final, @Verifier.isIdentity := Verifier_isIdentity,
    @scalar.mul8 := scalar_mul8, @scalar.reduce64 := scalar_reduce64

end

end MLIR.Zig

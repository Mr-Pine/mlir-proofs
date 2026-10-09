module

-- zig-build/out/mlir_canonicalized/region/Verifier.init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_fromBytes
public import Zig.Mlir.Edwards25519_rejectIdentity
public import Zig.Mlir.Fe_rejectNonCanonical
public import Zig.Mlir.Sha512_update
public import Zig.Mlir.scalar_rejectNonCanonical
public import Zig.Mlir.Sha512_iv

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_fromBytes
meta import Zig.Mlir.Edwards25519_rejectIdentity
meta import Zig.Mlir.Fe_rejectNonCanonical
meta import Zig.Mlir.Sha512_update
meta import Zig.Mlir.scalar_rejectNonCanonical
meta import Zig.Mlir.Sha512_iv

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Verifier_init :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %3 = "llvm.mlir.constant"() <{value = 592 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %5 = "llvm.mlir.addressof"() <{global_name = @Sha512.iv}> : () -> !llvm.ptr
    %6 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
    %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    %8 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>}> : (i32) -> !llvm.ptr
    %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
    %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
    %11 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%11, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %12 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %13 = "llvm.call"(%12) <{CConv = #llvm.cconv<fastcc>, callee = @scalar.rejectNonCanonical, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %14 = "llvm.icmp"(%13, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%14)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb1:  // 7 preds: ^bb2, ^bb4, ^bb6, ^bb8, ^bb10, ^bb12, ^bb13
    "llvm.return"() : () -> ()
  ^bb2:  // pred: ^bb0
    %15 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%13, %15) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb3:  // pred: ^bb0
    "llvm.call"(%10, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %16 = "llvm.getelementptr"(%10) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    %17 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    %18 = "llvm.icmp"(%17, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%18)[^bb5, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb4:  // pred: ^bb3
    %19 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%17, %19) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb5:  // pred: ^bb3
    %20 = "llvm.call"(%10) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %21 = "llvm.icmp"(%20, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%21)[^bb7, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb6:  // pred: ^bb5
    %22 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%20, %22) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb7:  // pred: ^bb5
    %23 = "llvm.call"(%11) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.rejectNonCanonical, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %24 = "llvm.icmp"(%23, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%24)[^bb9, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb8:  // pred: ^bb7
    %25 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%23, %25) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb9:  // pred: ^bb7
    "llvm.call"(%9, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %26 = "llvm.getelementptr"(%9) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    %27 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    %28 = "llvm.icmp"(%27, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%28)[^bb11, ^bb10] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb10:  // pred: ^bb9
    %29 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%27, %29) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb11:  // pred: ^bb9
    %30 = "llvm.call"(%9) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %31 = "llvm.icmp"(%30, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%31)[^bb13, ^bb12] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb12:  // pred: ^bb11
    %32 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%30, %32) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb13:  // pred: ^bb11
    "llvm.intr.memcpy"(%8, %5, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%8, %arg1, %1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%8, %arg2, %1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.memcpy"(%7, %8, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %33 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 560>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%33, %12, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %34 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%34, %10, %4) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %35 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 392>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%35, %9, %4) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %36 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%2, %36) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %7, %3) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb1] : () -> ()
}
  with @Edwards25519.fromBytes := Edwards25519_fromBytes,
    @Edwards25519.rejectIdentity := Edwards25519_rejectIdentity,
    @Fe.rejectNonCanonical := Fe_rejectNonCanonical, @Sha512.update := Sha512_update,
    @scalar.rejectNonCanonical := scalar_rejectNonCanonical, @Sha512.iv := Sha512_iv

end

end MLIR.Zig

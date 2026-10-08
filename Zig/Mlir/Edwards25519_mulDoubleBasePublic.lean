module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.mulDoubleBasePublic.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_add
public import Zig.Mlir.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_precompute
public import Zig.Mlir.Edwards25519_rejectIdentity
public import Zig.Mlir.Edwards25519_slide
public import Zig.Mlir.Edwards25519_sub
public import Zig.Mlir.Edwards25519_basePointPc
public import Zig.Mlir.Edwards25519_identityElement
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic_weak

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_add
meta import Zig.Mlir.Edwards25519_dbl
meta import Zig.Mlir.Edwards25519_precompute
meta import Zig.Mlir.Edwards25519_rejectIdentity
meta import Zig.Mlir.Edwards25519_slide
meta import Zig.Mlir.Edwards25519_sub
meta import Zig.Mlir.Edwards25519_basePointPc
meta import Zig.Mlir.Edwards25519_identityElement
meta import Zig.Mlir.Edwards25519_mulDoubleBasePublic_weak

namespace LeanMLIR.RIR.Zig

@[expose] public section

noncomputable mlir_def Edwards25519_mulDoubleBasePublic :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.basePointPc}> : () -> !llvm.ptr
    %2 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %3 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.mulDoubleBasePublic.weak}> : () -> !llvm.ptr
    %4 = "llvm.mlir.constant"() <{value = 176 : i64}> : () -> i64
    %5 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.identityElement}> : () -> !llvm.ptr
    %6 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %10 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
    %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %13 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %14 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %15 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %16 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %17 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %18 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %19 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %20 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %21 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}> : (i32) -> !llvm.ptr
    %22 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    %23 = "llvm.load"(%22) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i1
    "llvm.cond_br"(%23, %1)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
  ^bb1:  // 2 preds: ^bb4, ^bb16
    "llvm.return"() : () -> ()
  ^bb2(%24: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
    "llvm.call"(%20, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%19, %arg3) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%18, %5, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%7)[^bb5] : (i64) -> ()
  ^bb3:  // pred: ^bb0
    "llvm.call"(%21, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.precompute, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %25 = "llvm.getelementptr"(%21) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 672>}> : (!llvm.ptr) -> !llvm.ptr
    %26 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %27 = "llvm.icmp"(%26, %2) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%27, %21)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
  ^bb4:  // pred: ^bb3
    "llvm.intr.memcpy"(%arg0, %3, %4) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb5(%28: i64):  // 2 preds: ^bb2, ^bb17
    %29 = "llvm.getelementptr"(%20, %28) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %30 = "llvm.load"(%29) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %31 = "llvm.icmp"(%30, %9) <{predicate = 4 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%31)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb6(%32: !llvm.ptr):  // 2 preds: ^bb8, ^bb10
    "llvm.intr.memcpy"(%18, %32, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb7] : () -> ()
  ^bb7:  // 2 preds: ^bb6, ^bb9
    %33 = "llvm.getelementptr"(%19, %28) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %34 = "llvm.load"(%33) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %35 = "llvm.icmp"(%34, %9) <{predicate = 4 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%35)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb8:  // pred: ^bb5
    %36 = "llvm.zext"(%30) <{nonNeg}> : (i8) -> i64
    %37 = "llvm.getelementptr"(%1, %36) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%17, %18, %37) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%17)[^bb6] : (!llvm.ptr) -> ()
  ^bb9:  // pred: ^bb5
    %38 = "llvm.icmp"(%30, %9) <{predicate = 2 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%38)[^bb10, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb10:  // pred: ^bb9
    %39 = "llvm.sub"(%9, %30) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %40 = "llvm.zext"(%39) <{nonNeg}> : (i8) -> i64
    %41 = "llvm.getelementptr"(%1, %40) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%16, %18, %41) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%16)[^bb6] : (!llvm.ptr) -> ()
  ^bb11(%42: !llvm.ptr):  // 2 preds: ^bb13, ^bb15
    "llvm.intr.memcpy"(%18, %42, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb12] : () -> ()
  ^bb12:  // 2 preds: ^bb11, ^bb14
    %43 = "llvm.icmp"(%28, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%43)[^bb16, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb13:  // pred: ^bb7
    %44 = "llvm.zext"(%34) <{nonNeg}> : (i8) -> i64
    %45 = "llvm.getelementptr"(%24, %44) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%15, %18, %45) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%15)[^bb11] : (!llvm.ptr) -> ()
  ^bb14:  // pred: ^bb7
    %46 = "llvm.icmp"(%34, %9) <{predicate = 2 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%46)[^bb15, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb15:  // pred: ^bb14
    %47 = "llvm.sub"(%9, %34) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %48 = "llvm.zext"(%47) <{nonNeg}> : (i8) -> i64
    %49 = "llvm.getelementptr"(%24, %48) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%14, %18, %49) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%14)[^bb11] : (!llvm.ptr) -> ()
  ^bb16:  // pred: ^bb12
    %50 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%2, %50) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %18, %6) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb17:  // pred: ^bb12
    "llvm.call"(%13, %18) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%12, %13) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%11, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%18, %11) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %51 = "llvm.add"(%28, %10) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.br"(%51)[^bb5] : (i64) -> ()
}
  with @Edwards25519.add := Edwards25519_add, @Edwards25519.dbl := Edwards25519_dbl,
    @Edwards25519.precompute := Edwards25519_precompute,
    @Edwards25519.rejectIdentity := Edwards25519_rejectIdentity,
    @Edwards25519.slide := Edwards25519_slide, @Edwards25519.sub := Edwards25519_sub,
    @Edwards25519.basePointPc := Edwards25519_basePointPc,
    @Edwards25519.identityElement := Edwards25519_identityElement,
    @Edwards25519.mulDoubleBasePublic.weak := Edwards25519_mulDoubleBasePublic_weak

end

end LeanMLIR.RIR.Zig

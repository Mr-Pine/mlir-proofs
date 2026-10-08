module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.add.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_add
public import Zig.Mlir.Fe_mul
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Fe_edwards25519d2

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_add
meta import Zig.Mlir.Fe_mul
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Fe_edwards25519d2

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_add :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %3 = "llvm.mlir.addressof"() <{global_name = @Fe.edwards25519d2}> : () -> !llvm.ptr
    %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = false}> : () -> i1
    %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %7 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %8 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %13 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %14 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %15 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %16 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %17 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %18 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %19 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %20 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %21 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %22 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %23 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %24 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%24, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.memcpy"(%23, %arg2, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %25 = "llvm.getelementptr"(%24) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%22, %25, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %26 = "llvm.getelementptr"(%23) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%21, %26, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%20, %22, %21) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %27 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%19, %arg1, %27) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %28 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%18, %arg2, %28) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%17, %19, %18) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %29 = "llvm.getelementptr"(%24) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    %30 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%16, %29, %30) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%15, %16, %3) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %31 = "llvm.getelementptr"(%24) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %32 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%14, %31, %32) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %33 = "llvm.load"(%14) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %34 = "llvm.shl"(%33, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %35 = "llvm.getelementptr"(%14) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %36 = "llvm.load"(%35) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %37 = "llvm.shl"(%36, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %38 = "llvm.getelementptr"(%14) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %39 = "llvm.load"(%38) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %40 = "llvm.shl"(%39, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %41 = "llvm.getelementptr"(%14) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %42 = "llvm.load"(%41) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %43 = "llvm.shl"(%42, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %44 = "llvm.getelementptr"(%14) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %45 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %46 = "llvm.shl"(%45, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%34, %14) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.store"(%37, %35) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.store"(%40, %38) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.store"(%43, %41) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.store"(%46, %44) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.call"(%13, %17, %20) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %47 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %48 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %49 = "llvm.add"(%48, %47) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %50 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %51 = "llvm.load"(%50) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %52 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %53 = "llvm.load"(%52) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %54 = "llvm.add"(%53, %51) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %55 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %56 = "llvm.load"(%55) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %57 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %58 = "llvm.load"(%57) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %59 = "llvm.add"(%58, %56) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %60 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %61 = "llvm.load"(%60) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %62 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %63 = "llvm.load"(%62) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %64 = "llvm.add"(%63, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %65 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %66 = "llvm.load"(%65) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %67 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %68 = "llvm.load"(%67) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %69 = "llvm.add"(%68, %66) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%49, %12) <{alias_scopes = [#alias_scope17], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %70 = "llvm.getelementptr"(%12) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%54, %70) <{alias_scopes = [#alias_scope17], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %71 = "llvm.getelementptr"(%12) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%59, %71) <{alias_scopes = [#alias_scope17], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %72 = "llvm.getelementptr"(%12) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%64, %72) <{alias_scopes = [#alias_scope17], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %73 = "llvm.getelementptr"(%12) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%69, %73) <{alias_scopes = [#alias_scope17], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %74 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %75 = "llvm.add"(%74, %34) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %76 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %77 = "llvm.load"(%76) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %78 = "llvm.add"(%77, %37) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %79 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %80 = "llvm.load"(%79) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %81 = "llvm.add"(%80, %40) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %82 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %83 = "llvm.load"(%82) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %84 = "llvm.add"(%83, %43) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %85 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %86 = "llvm.load"(%85) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %87 = "llvm.add"(%86, %46) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%75, %11) <{alias_scopes = [#alias_scope18], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %88 = "llvm.getelementptr"(%11) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%78, %88) <{alias_scopes = [#alias_scope18], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %89 = "llvm.getelementptr"(%11) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%81, %89) <{alias_scopes = [#alias_scope18], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %90 = "llvm.getelementptr"(%11) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%84, %90) <{alias_scopes = [#alias_scope18], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %91 = "llvm.getelementptr"(%11) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%87, %91) <{alias_scopes = [#alias_scope18], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.call"(%10, %14, %15) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%9, %13, %10) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %9, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %92 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%8, %12, %11) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%92, %8, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %93 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%7, %11, %10) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%93, %7, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %94 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%6, %13, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%94, %6, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %95 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%5, %95) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.add := Fe_add, @Fe.mul := Fe_mul, @Fe.sub := Fe_sub,
    @Fe.edwards25519d2 := Fe_edwards25519d2

end

end LeanMLIR.RIR.Zig

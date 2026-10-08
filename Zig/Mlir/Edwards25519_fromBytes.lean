module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.fromBytes.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_add
public import Zig.Mlir.Fe_cMov
public import Zig.Mlir.Fe_isZero
public import Zig.Mlir.Fe_mul
public import Zig.Mlir.Fe_neg
public import Zig.Mlir.Fe_reduce
public import Zig.Mlir.Fe_sq
public import Zig.Mlir.Fe_sqn
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Edwards25519_fromBytes_invalid
public import Zig.Mlir.Fe_edwards25519d
public import Zig.Mlir.Fe_one
public import Zig.Mlir.Fe_sqrtm1

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_add
meta import Zig.Mlir.Fe_cMov
meta import Zig.Mlir.Fe_isZero
meta import Zig.Mlir.Fe_mul
meta import Zig.Mlir.Fe_neg
meta import Zig.Mlir.Fe_reduce
meta import Zig.Mlir.Fe_sq
meta import Zig.Mlir.Fe_sqn
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Edwards25519_fromBytes_invalid
meta import Zig.Mlir.Fe_edwards25519d
meta import Zig.Mlir.Fe_one
meta import Zig.Mlir.Fe_sqrtm1

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_fromBytes :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %7 = "llvm.mlir.addressof"() <{global_name = @Fe.edwards25519d}> : () -> !llvm.ptr
    %8 = "llvm.mlir.addressof"() <{global_name = @Fe.one}> : () -> !llvm.ptr
    %9 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %10 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
    %11 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
    %12 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
    %13 = "llvm.mlir.constant"() <{value = 30 : i64}> : () -> i64
    %14 = "llvm.mlir.constant"() <{value = 60 : i64}> : () -> i64
    %15 = "llvm.mlir.constant"() <{value = 120 : i64}> : () -> i64
    %16 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
    %17 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.fromBytes.invalid}> : () -> !llvm.ptr
    %18 = "llvm.mlir.constant"() <{value = 176 : i64}> : () -> i64
    %19 = "llvm.mlir.addressof"() <{global_name = @Fe.sqrtm1}> : () -> !llvm.ptr
    %20 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %21 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
    %22 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
    %23 = "llvm.mlir.constant"() <{value = false}> : () -> i1
    %24 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %25 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
    %26 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %27 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %28 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %29 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %30 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %31 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %32 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %33 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %34 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %35 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %36 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %37 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %38 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %39 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %40 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %41 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %42 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %43 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %44 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %45 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
    %46 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
    %47 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %48 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %49 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %50 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %51 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %52 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %53 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %54 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %55 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %56 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %57 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %58 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %59 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %60 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%44) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%44, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %61 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %62 = "llvm.and"(%61, %2) : (i64, i64) -> i64
    %63 = "llvm.getelementptr"(%44) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
    %64 = "llvm.load"(%63) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %65 = "llvm.lshr"(%64, %4) : (i64, i64) -> i64
    %66 = "llvm.and"(%65, %2) : (i64, i64) -> i64
    %67 = "llvm.getelementptr"(%44) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
    %68 = "llvm.load"(%67) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %69 = "llvm.lshr"(%68, %3) : (i64, i64) -> i64
    %70 = "llvm.and"(%69, %2) : (i64, i64) -> i64
    %71 = "llvm.getelementptr"(%44) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
    %72 = "llvm.load"(%71) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %73 = "llvm.lshr"(%72, %6) : (i64, i64) -> i64
    %74 = "llvm.and"(%73, %2) : (i64, i64) -> i64
    %75 = "llvm.getelementptr"(%44) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %76 = "llvm.load"(%75) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %77 = "llvm.lshr"(%76, %5) : (i64, i64) -> i64
    %78 = "llvm.and"(%77, %2) : (i64, i64) -> i64
    "llvm.store"(%62, %60) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %79 = "llvm.getelementptr"(%60) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%66, %79) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %80 = "llvm.getelementptr"(%60) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%70, %80) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %81 = "llvm.getelementptr"(%60) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%74, %81) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %82 = "llvm.getelementptr"(%60) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%78, %82) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%44) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%59, %60) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%58, %59, %7) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%57, %59, %8) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%59, %57, %9) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%56, %58, %8) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%54, %57, %56) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%27) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%28) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%29) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%30) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%31) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%32) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%33) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%34) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%35) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%36) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%37) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%38) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%39) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%40) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%41) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%42) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%43) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%42, %54) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%43, %54, %42) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%40, %43, %10) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%39, %43, %40) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%38, %39) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%41, %38, %54) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%37, %41, %11) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%43, %37, %41) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%35, %43, %11) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%36, %35, %41) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%34, %36, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%41, %34, %36) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%33, %41, %13) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%36, %33, %41) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%32, %36, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%41, %32, %36) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%31, %41, %15) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%30, %31, %41) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%29, %30, %16) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%28, %29, %43) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%27, %28, %10) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%53, %27, %54) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%27) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%28) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%29) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%30) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%31) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%32) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%33) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%34) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%35) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%36) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%37) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%38) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%39) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%40) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%41) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%42) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%43) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%55, %53, %57) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%52, %55) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%51, %52, %56) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%50, %51, %57) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %83 = "llvm.call"(%50) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    %84 = "llvm.load"(%51) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %85 = "llvm.load"(%59) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %86 = "llvm.add"(%85, %84) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %87 = "llvm.getelementptr"(%51) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %88 = "llvm.load"(%87) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %89 = "llvm.getelementptr"(%59) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %90 = "llvm.load"(%89) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %91 = "llvm.add"(%90, %88) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %92 = "llvm.getelementptr"(%51) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %93 = "llvm.load"(%92) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %94 = "llvm.getelementptr"(%59) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %95 = "llvm.load"(%94) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %96 = "llvm.add"(%95, %93) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %97 = "llvm.getelementptr"(%51) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %98 = "llvm.load"(%97) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %99 = "llvm.getelementptr"(%59) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %100 = "llvm.load"(%99) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %101 = "llvm.add"(%100, %98) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %102 = "llvm.getelementptr"(%51) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %103 = "llvm.load"(%102) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %104 = "llvm.getelementptr"(%59) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %105 = "llvm.load"(%104) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %106 = "llvm.add"(%105, %103) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%86, %49) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %107 = "llvm.getelementptr"(%49) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%91, %107) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %108 = "llvm.getelementptr"(%49) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%96, %108) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %109 = "llvm.getelementptr"(%49) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%101, %109) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %110 = "llvm.getelementptr"(%49) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%106, %110) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %111 = "llvm.call"(%49) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    %112 = "llvm.or"(%83, %111) : (i1, i1) -> i1
    "llvm.cond_br"(%112)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb1:  // 2 preds: ^bb2, ^bb3
    "llvm.return"() : () -> ()
  ^bb2:  // pred: ^bb0
    "llvm.intr.memcpy"(%arg0, %17, %18) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb3:  // pred: ^bb0
    "llvm.call"(%48, %55, %19) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %113 = "llvm.xor"(%83, %20) : (i1, i1) -> i1
    %114 = "llvm.zext"(%113) : (i1) -> i64
    "llvm.call"(%55, %48, %114) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.cMov, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%47, %55) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.neg, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%26) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%26, %55, %9) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%26) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.reduce, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
    %115 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.intr.lifetime.end"(%26) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %116 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
    %117 = "llvm.load"(%116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %118 = "llvm.lshr"(%117, %21) : (i8, i8) -> i8
    %119 = "llvm.trunc"(%115) <{overflowFlags = #llvm.overflow<none>}> : (i64) -> i8
    %120 = "llvm.and"(%119, %22) : (i8, i8) -> i8
    %121 = "llvm.xor"(%118, %120) : (i8, i8) -> i8
    %122 = "llvm.zext"(%121) <{nonNeg}> : (i8) -> i64
    "llvm.call"(%55, %47, %122) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.cMov, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %123 = "llvm.getelementptr"(%45) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%123, %55, %60) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%45, %55, %9) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %124 = "llvm.getelementptr"(%45) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%124, %60, %9) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %125 = "llvm.getelementptr"(%45) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%125, %8, %9) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.store"(%23, %46) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
    %126 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%24, %126) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %45, %25) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %127 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    %128 = "llvm.load"(%46) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    "llvm.store"(%128, %127) <{alignment = 8 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    "llvm.br"()[^bb1] : () -> ()
}
  with @Fe.add := Fe_add, @Fe.cMov := Fe_cMov, @Fe.isZero := Fe_isZero, @Fe.mul := Fe_mul,
    @Fe.neg := Fe_neg, @Fe.reduce := Fe_reduce, @Fe.sq := Fe_sq, @Fe.sqn := Fe_sqn,
    @Fe.sub := Fe_sub, @Edwards25519.fromBytes.invalid := Edwards25519_fromBytes_invalid,
    @Fe.edwards25519d := Fe_edwards25519d, @Fe.one := Fe_one, @Fe.sqrtm1 := Fe_sqrtm1

end

end LeanMLIR.RIR.Zig

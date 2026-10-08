module

-- zig-build/out/mlir_canonicalized/region/zig_ed25519_verify.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_add
public import Zig.Mlir.Edwards25519_clearCofactor
public import Zig.Mlir.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_fromBytes
public import Zig.Mlir.Edwards25519_neg
public import Zig.Mlir.Edwards25519_rejectIdentity
public import Zig.Mlir.Edwards25519_slide
public import Zig.Mlir.Edwards25519_sub
public import Zig.Mlir.Fe_isZero
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Scalar_add
public import Zig.Mlir.Scalar_fromBytes
public import Zig.Mlir.Scalar_toBytes
public import Zig.Mlir.Sha512_round
public import Zig.Mlir.Sha512_update
public import Zig.Mlir.Edwards25519_basePointPc
public import Zig.Mlir.Edwards25519_identityElement
public import Zig.Mlir.Sha512_iv
public import Zig.Mlir.scalar_field_order_s

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_add
meta import Zig.Mlir.Edwards25519_clearCofactor
meta import Zig.Mlir.Edwards25519_dbl
meta import Zig.Mlir.Edwards25519_fromBytes
meta import Zig.Mlir.Edwards25519_neg
meta import Zig.Mlir.Edwards25519_rejectIdentity
meta import Zig.Mlir.Edwards25519_slide
meta import Zig.Mlir.Edwards25519_sub
meta import Zig.Mlir.Fe_isZero
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Scalar_add
meta import Zig.Mlir.Scalar_fromBytes
meta import Zig.Mlir.Scalar_toBytes
meta import Zig.Mlir.Sha512_round
meta import Zig.Mlir.Sha512_update
meta import Zig.Mlir.Edwards25519_basePointPc
meta import Zig.Mlir.Edwards25519_identityElement
meta import Zig.Mlir.Sha512_iv
meta import Zig.Mlir.scalar_field_order_s

namespace LeanMLIR.RIR.Zig

@[expose] public section

noncomputable mlir_def zig_ed25519_verify :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
    %7 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
    %8 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
    %10 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
    %11 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
    %12 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %13 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %14 = "llvm.mlir.addressof"() <{global_name = @scalar.field_order_s}> : () -> !llvm.ptr
    %15 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
    %16 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
    %17 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
    %18 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
    %19 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %20 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %21 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
    %22 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
    %23 = "llvm.mlir.constant"() <{value = 511 : i16}> : () -> i16
    %24 = "llvm.mlir.constant"() <{value = 236 : i16}> : () -> i16
    %25 = "llvm.mlir.constant"() <{value = 256 : i16}> : () -> i16
    %26 = "llvm.mlir.addressof"() <{global_name = @Sha512.iv}> : () -> !llvm.ptr
    %27 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
    %28 = "llvm.mlir.constant"() <{value = 592 : i64}> : () -> i64
    %29 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
    %30 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
    %31 = "llvm.mlir.constant"() <{value = 111 : i8}> : () -> i8
    %32 = "llvm.mlir.constant"() <{value = 5 : i128}> : () -> i128
    %33 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
    %34 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
    %35 = "llvm.mlir.constant"() <{value = 8 : i128}> : () -> i128
    %36 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
    %37 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %38 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %39 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
    %40 = "llvm.mlir.constant"() <{value = 72057589742960640 : i64}> : () -> i64
    %41 = "llvm.mlir.constant"() <{value = 44162584779952923 : i128}> : () -> i128
    %42 = "llvm.mlir.constant"() <{value = 9390964836247533 : i128}> : () -> i128
    %43 = "llvm.mlir.constant"() <{value = 72057594036560134 : i128}> : () -> i128
    %44 = "llvm.mlir.constant"() <{value = 72057594037927935 : i128}> : () -> i128
    %45 = "llvm.mlir.constant"() <{value = 68719476735 : i128}> : () -> i128
    %46 = "llvm.mlir.constant"() <{value = 56 : i128}> : () -> i128
    %47 = "llvm.mlir.constant"() <{value = 72057594037862400 : i64}> : () -> i64
    %48 = "llvm.mlir.constant"() <{value = 65535 : i64}> : () -> i64
    %49 = "llvm.mlir.constant"() <{value = 40 : i128}> : () -> i128
    %50 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
    %51 = "llvm.mlir.constant"() <{value = 5175514460705773 : i128}> : () -> i128
    %52 = "llvm.mlir.constant"() <{value = 70332060721272408 : i128}> : () -> i128
    %53 = "llvm.mlir.constant"() <{value = 5342 : i128}> : () -> i128
    %54 = "llvm.mlir.constant"() <{value = 28 : i128}> : () -> i128
    %55 = "llvm.mlir.constant"() <{value = 699938952792 : i128}> : () -> i128
    %56 = "llvm.mlir.constant"() <{value = 113228764141 : i128}> : () -> i128
    %57 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
    %58 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
    %59 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
    %60 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
    %61 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
    %62 = "llvm.mlir.constant"() <{value = 268435456 : i64}> : () -> i64
    %63 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.basePointPc}> : () -> !llvm.ptr
    %64 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.identityElement}> : () -> !llvm.ptr
    %65 = "llvm.mlir.constant"() <{value = 4 : i16}> : () -> i16
    %66 = "llvm.mlir.constant"() <{value = 5 : i16}> : () -> i16
    %67 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
    %68 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %69 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %70 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %71 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}> : (i32) -> !llvm.ptr
    %72 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %73 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %74 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %75 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %76 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %77 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %78 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %79 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %80 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %81 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %82 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %83 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %84 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %85 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %86 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<10 x i64>}> : (i32) -> !llvm.ptr
    %87 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %88 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %89 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %90 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    %91 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %92 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %93 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %94 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"src.ed25519.Ed25519.Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    %95 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>}> : (i32) -> !llvm.ptr
    %96 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
    %97 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
    %98 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %99 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.struct<"src.ed25519.Ed25519.Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    %100 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.struct<"src.ed25519.Ed25519.Signature", (array<32 x i8>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%100, %arg2, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %101 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %102 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%101, %102, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.lifetime.start"(%99) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    %103 = "llvm.load"(%100) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %104 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
    %105 = "llvm.load"(%104) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %106 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
    %107 = "llvm.load"(%106) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %108 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
    %109 = "llvm.load"(%108) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %110 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
    %111 = "llvm.load"(%110) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %112 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
    %113 = "llvm.load"(%112) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %114 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
    %115 = "llvm.load"(%114) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %116 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
    %117 = "llvm.load"(%116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %118 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %119 = "llvm.load"(%118) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %120 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
    %121 = "llvm.load"(%120) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %122 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
    %123 = "llvm.load"(%122) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %124 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
    %125 = "llvm.load"(%124) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %126 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
    %127 = "llvm.load"(%126) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %128 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
    %129 = "llvm.load"(%128) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %130 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
    %131 = "llvm.load"(%130) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %132 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
    %133 = "llvm.load"(%132) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %134 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %135 = "llvm.load"(%134) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %136 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
    %137 = "llvm.load"(%136) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %138 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
    %139 = "llvm.load"(%138) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %140 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
    %141 = "llvm.load"(%140) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %142 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
    %143 = "llvm.load"(%142) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %144 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
    %145 = "llvm.load"(%144) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %146 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
    %147 = "llvm.load"(%146) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %148 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
    %149 = "llvm.load"(%148) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %150 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %151 = "llvm.load"(%150) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %152 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
    %153 = "llvm.load"(%152) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %154 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
    %155 = "llvm.load"(%154) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %156 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
    %157 = "llvm.load"(%156) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %158 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
    %159 = "llvm.load"(%158) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %160 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
    %161 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %162 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
    %163 = "llvm.load"(%162) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %164 = "llvm.getelementptr"(%100) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
    %165 = "llvm.load"(%164) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    "llvm.intr.lifetime.start"(%94) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%95) <{size = 224 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%96) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%97) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%98) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%98, %102, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%10, %11, %12)[^bb1] : (i64, i8, i8) -> ()
  ^bb1(%166: i64, %167: i8, %168: i8):  // 2 preds: ^bb0, ^bb2
    %169 = "llvm.getelementptr"(%98, %166) <{elem_type = !llvm.array<32 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %171 = "llvm.zext"(%170) : (i8) -> i16
    %172 = "llvm.getelementptr"(%14, %166) <{elem_type = !llvm.array<32 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %173 = "llvm.load"(%172) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %174 = "llvm.zext"(%173) : (i8) -> i16
    %175 = "llvm.sub"(%171, %174) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %176 = "llvm.lshr"(%175, %15) : (i16, i16) -> i16
    %177 = "llvm.trunc"(%176) <{overflowFlags = #llvm.overflow<nuw>}> : (i16) -> i8
    %178 = "llvm.and"(%167, %177) : (i8, i8) -> i8
    %179 = "llvm.or"(%178, %168) : (i8, i8) -> i8
    %180 = "llvm.icmp"(%166, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%180)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %181 = "llvm.xor"(%174, %171) : (i16, i16) -> i16
    %182 = "llvm.add"(%181, %16) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %183 = "llvm.lshr"(%182, %15) : (i16, i16) -> i16
    %184 = "llvm.trunc"(%183) <{overflowFlags = #llvm.overflow<nuw>}> : (i16) -> i8
    %185 = "llvm.and"(%167, %184) : (i8, i8) -> i8
    %186 = "llvm.add"(%166, %17) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.br"(%186, %185, %179)[^bb1] : (i64, i8, i8) -> ()
  ^bb3:  // pred: ^bb1
    %187 = "llvm.icmp"(%179, %12) <{predicate = 0 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%187, %18)[^bb9, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i16) -> ()
  ^bb4:  // pred: ^bb3
    "llvm.call"(%97, %arg3) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %188 = "llvm.getelementptr"(%97) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    %189 = "llvm.load"(%188) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    %190 = "llvm.icmp"(%189, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%190, %189)[^bb5, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb5:  // pred: ^bb4
    %191 = "llvm.call"(%97) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %192 = "llvm.icmp"(%191, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%192, %191)[^bb6, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb6:  // pred: ^bb5
    %193 = "llvm.and"(%165, %21) : (i8, i8) -> i8
    %194 = "llvm.xor"(%193, %21) : (i8, i8) -> i8
    %195 = "llvm.and"(%107, %105) : (i8, i8) -> i8
    %196 = "llvm.and"(%195, %109) : (i8, i8) -> i8
    %197 = "llvm.and"(%196, %111) : (i8, i8) -> i8
    %198 = "llvm.and"(%197, %113) : (i8, i8) -> i8
    %199 = "llvm.and"(%198, %115) : (i8, i8) -> i8
    %200 = "llvm.and"(%199, %117) : (i8, i8) -> i8
    %201 = "llvm.and"(%200, %119) : (i8, i8) -> i8
    %202 = "llvm.and"(%201, %121) : (i8, i8) -> i8
    %203 = "llvm.and"(%202, %123) : (i8, i8) -> i8
    %204 = "llvm.and"(%203, %125) : (i8, i8) -> i8
    %205 = "llvm.and"(%204, %127) : (i8, i8) -> i8
    %206 = "llvm.and"(%205, %129) : (i8, i8) -> i8
    %207 = "llvm.and"(%206, %131) : (i8, i8) -> i8
    %208 = "llvm.and"(%207, %133) : (i8, i8) -> i8
    %209 = "llvm.and"(%208, %135) : (i8, i8) -> i8
    %210 = "llvm.and"(%209, %137) : (i8, i8) -> i8
    %211 = "llvm.and"(%210, %139) : (i8, i8) -> i8
    %212 = "llvm.and"(%211, %141) : (i8, i8) -> i8
    %213 = "llvm.and"(%212, %143) : (i8, i8) -> i8
    %214 = "llvm.and"(%213, %145) : (i8, i8) -> i8
    %215 = "llvm.and"(%214, %147) : (i8, i8) -> i8
    %216 = "llvm.and"(%215, %149) : (i8, i8) -> i8
    %217 = "llvm.and"(%216, %151) : (i8, i8) -> i8
    %218 = "llvm.and"(%217, %153) : (i8, i8) -> i8
    %219 = "llvm.and"(%218, %155) : (i8, i8) -> i8
    %220 = "llvm.and"(%219, %157) : (i8, i8) -> i8
    %221 = "llvm.and"(%220, %159) : (i8, i8) -> i8
    %222 = "llvm.and"(%221, %161) : (i8, i8) -> i8
    %223 = "llvm.and"(%222, %163) : (i8, i8) -> i8
    %224 = "llvm.xor"(%223, %22) : (i8, i8) -> i8
    %225 = "llvm.or"(%194, %224) : (i8, i8) -> i8
    %226 = "llvm.zext"(%225) : (i8) -> i16
    %227 = "llvm.add"(%226, %23) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i16, i16) -> i16
    %228 = "llvm.zext"(%103) : (i8) -> i16
    %229 = "llvm.sub"(%24, %228) <{overflowFlags = #llvm.overflow<nsw>}> : (i16, i16) -> i16
    %230 = "llvm.and"(%229, %25) : (i16, i16) -> i16
    %231 = "llvm.and"(%230, %227) : (i16, i16) -> i16
    %232 = "llvm.icmp"(%231, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%232, %18)[^bb7, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb7:  // pred: ^bb6
    "llvm.call"(%96, %100) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %233 = "llvm.getelementptr"(%96) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    %234 = "llvm.load"(%233) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
    %235 = "llvm.icmp"(%234, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%235, %234)[^bb8, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb8:  // pred: ^bb7
    %236 = "llvm.call"(%96) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %237 = "llvm.icmp"(%236, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%237, %236)[^bb10, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb9(%238: i16):  // 6 preds: ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8
    "llvm.intr.lifetime.end"(%95) <{size = 224 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%96) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%97) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%98) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%94) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%238)[^bb46] : (i16) -> ()
  ^bb10:  // pred: ^bb8
    "llvm.intr.memcpy"(%95, %26, %27) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%95, %100, %1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%95, %arg3, %1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.memcpy"(%94, %95, %27) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %239 = "llvm.getelementptr"(%94) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 560>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%239, %102, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %240 = "llvm.getelementptr"(%94) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%240, %97, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %241 = "llvm.getelementptr"(%94) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 392>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%241, %96, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.lifetime.end"(%95) <{size = 224 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%96) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%97) <{size = 176 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%98) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%99, %94, %28) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.lifetime.end"(%94) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%99, %arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.intr.lifetime.start"(%79) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%87) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%88) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%89) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%90) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%91) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%92) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%93) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    %242 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %243 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
    %244 = "llvm.load"(%243) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %245 = "llvm.zext"(%244) : (i8) -> i64
    %246 = "llvm.getelementptr"(%242, %245) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %247 = "llvm.sub"(%29, %245) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.intr.memset"(%246, %12, %247) <{isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
    %248 = "llvm.load"(%243) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %249 = "llvm.zext"(%248) : (i8) -> i64
    %250 = "llvm.getelementptr"(%242, %249) <{elem_type = !llvm.array<128 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.store"(%30, %250) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %251 = "llvm.load"(%243) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %252 = "llvm.add"(%251, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i8, i8) -> i8
    "llvm.store"(%252, %243) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %253 = "llvm.icmp"(%251, %31) <{predicate = 8 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%253)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb11:  // 2 preds: ^bb10, ^bb12
    %254 = "llvm.load"(%99) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %255 = "llvm.lshr"(%254, %32) : (i128, i128) -> i128
    %256 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 207>}> : (!llvm.ptr) -> !llvm.ptr
    %257 = "llvm.trunc"(%254) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i8
    %258 = "llvm.shl"(%257, %33) <{overflowFlags = #llvm.overflow<none>}> : (i8, i8) -> i8
    "llvm.store"(%258, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    "llvm.br"(%2, %255)[^bb13] : (i64, i128) -> ()
  ^bb12:  // pred: ^bb10
    "llvm.call"(%99, %242) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memset"(%242, %12, %29) <{isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
    "llvm.br"()[^bb11] : () -> ()
  ^bb13(%259: i64, %260: i128):  // 2 preds: ^bb11, ^bb14
    %261 = "llvm.icmp"(%259, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%261)[^bb15, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb14:  // pred: ^bb13
    %262 = "llvm.sub"(%34, %259) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %263 = "llvm.getelementptr"(%242, %262) <{elem_type = !llvm.array<128 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %264 = "llvm.trunc"(%260) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i8
    "llvm.store"(%264, %263) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %265 = "llvm.lshr"(%260, %35) : (i128, i128) -> i128
    %266 = "llvm.add"(%259, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%266, %265)[^bb13] : (i64, i128) -> ()
  ^bb15:  // pred: ^bb13
    "llvm.call"(%99, %242) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %267 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.br"(%13)[^bb16] : (i64) -> ()
  ^bb16(%268: i64):  // 2 preds: ^bb15, ^bb17
    %269 = "llvm.icmp"(%268, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%269)[^bb18, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb17:  // pred: ^bb16
    %270 = "llvm.getelementptr"(%267, %268) <{elem_type = !llvm.array<8 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %271 = "llvm.load"(%270) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %272 = "llvm.shl"(%268, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %273 = "llvm.getelementptr"(%93, %272) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %274 = "llvm.intr.bswap"(%271) : (i64) -> i64
    "llvm.store"(%274, %273) <{alignment = 1 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %275 = "llvm.add"(%268, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%275)[^bb16] : (i64) -> ()
  ^bb18:  // pred: ^bb16
    "llvm.intr.lifetime.start"(%86) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%13)[^bb19] : (i64) -> ()
  ^bb19(%276: i64):  // 2 preds: ^bb18, ^bb20
    %277 = "llvm.icmp"(%276, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%277)[^bb21, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb20:  // pred: ^bb19
    %278 = "llvm.getelementptr"(%86, %276) <{elem_type = !llvm.array<10 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %279 = "llvm.mul"(%276, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %280 = "llvm.getelementptr"(%93, %279) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %281 = "llvm.load"(%280) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %282 = "llvm.and"(%281, %36) : (i64, i64) -> i64
    "llvm.store"(%282, %278) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %283 = "llvm.add"(%276, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%283)[^bb19] : (i64) -> ()
  ^bb21:  // pred: ^bb19
    %284 = "llvm.getelementptr"(%93) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
    %285 = "llvm.load"(%284) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %286 = "llvm.zext"(%285) : (i8) -> i64
    %287 = "llvm.load"(%86) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %288 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %289 = "llvm.load"(%288) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %290 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %291 = "llvm.load"(%290) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %292 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %293 = "llvm.load"(%292) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %294 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %295 = "llvm.load"(%294) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %296 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    %297 = "llvm.load"(%296) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %298 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %299 = "llvm.load"(%298) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %300 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
    %301 = "llvm.load"(%300) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %302 = "llvm.getelementptr"(%86) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %303 = "llvm.load"(%302) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.intr.lifetime.end"(%86) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%85) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %304 = "llvm.shl"(%297, %1) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %305 = "llvm.and"(%304, %40) : (i64, i64) -> i64
    %306 = "llvm.lshr"(%295, %9) : (i64, i64) -> i64
    %307 = "llvm.or"(%305, %306) : (i64, i64) -> i64
    %308 = "llvm.shl"(%299, %1) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %309 = "llvm.and"(%308, %40) : (i64, i64) -> i64
    %310 = "llvm.lshr"(%297, %9) : (i64, i64) -> i64
    %311 = "llvm.or"(%309, %310) : (i64, i64) -> i64
    %312 = "llvm.shl"(%301, %1) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %313 = "llvm.and"(%312, %40) : (i64, i64) -> i64
    %314 = "llvm.lshr"(%299, %9) : (i64, i64) -> i64
    %315 = "llvm.or"(%313, %314) : (i64, i64) -> i64
    %316 = "llvm.shl"(%303, %1) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %317 = "llvm.and"(%316, %40) : (i64, i64) -> i64
    %318 = "llvm.lshr"(%301, %9) : (i64, i64) -> i64
    %319 = "llvm.or"(%317, %318) : (i64, i64) -> i64
    %320 = "llvm.shl"(%286, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %321 = "llvm.lshr"(%303, %9) : (i64, i64) -> i64
    %322 = "llvm.or"(%321, %320) : (i64, i64) -> i64
    %323 = "llvm.zext"(%307) <{nonNeg}> : (i64) -> i128
    %324 = "llvm.mul"(%323, %41) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %325 = "llvm.mul"(%323, %42) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %326 = "llvm.mul"(%323, %43) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %327 = "llvm.mul"(%323, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %328 = "llvm.mul"(%323, %45) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %329 = "llvm.zext"(%311) <{nonNeg}> : (i64) -> i128
    %330 = "llvm.mul"(%329, %41) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %331 = "llvm.mul"(%329, %42) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %332 = "llvm.mul"(%329, %43) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %333 = "llvm.mul"(%329, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %334 = "llvm.mul"(%329, %45) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %335 = "llvm.zext"(%315) <{nonNeg}> : (i64) -> i128
    %336 = "llvm.mul"(%335, %41) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %337 = "llvm.mul"(%335, %42) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %338 = "llvm.mul"(%335, %43) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %339 = "llvm.mul"(%335, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %340 = "llvm.mul"(%335, %45) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %341 = "llvm.zext"(%319) <{nonNeg}> : (i64) -> i128
    %342 = "llvm.mul"(%341, %41) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %343 = "llvm.mul"(%341, %42) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %344 = "llvm.mul"(%341, %43) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %345 = "llvm.mul"(%341, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %346 = "llvm.mul"(%341, %45) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %347 = "llvm.zext"(%322) <{nonNeg}> : (i64) -> i128
    %348 = "llvm.mul"(%347, %41) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %349 = "llvm.mul"(%347, %42) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %350 = "llvm.mul"(%347, %43) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %351 = "llvm.mul"(%347, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %352 = "llvm.mul"(%347, %45) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %353 = "llvm.add"(%330, %325) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %354 = "llvm.add"(%331, %326) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %355 = "llvm.add"(%354, %336) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %356 = "llvm.add"(%332, %327) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %357 = "llvm.add"(%356, %337) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %358 = "llvm.add"(%357, %342) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %359 = "llvm.add"(%333, %328) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %360 = "llvm.add"(%359, %338) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %361 = "llvm.add"(%339, %334) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %362 = "llvm.add"(%346, %351) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %363 = "llvm.lshr"(%324, %46) : (i128, i128) -> i128
    %364 = "llvm.add"(%353, %363) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %365 = "llvm.lshr"(%364, %46) : (i128, i128) -> i128
    %366 = "llvm.add"(%355, %365) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %367 = "llvm.lshr"(%366, %46) : (i128, i128) -> i128
    %368 = "llvm.add"(%358, %367) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %369 = "llvm.lshr"(%368, %46) : (i128, i128) -> i128
    %370 = "llvm.add"(%360, %348) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %371 = "llvm.add"(%370, %343) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %372 = "llvm.add"(%371, %369) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %373 = "llvm.lshr"(%372, %46) : (i128, i128) -> i128
    %374 = "llvm.trunc"(%372) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %375 = "llvm.add"(%361, %349) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %376 = "llvm.add"(%375, %344) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %377 = "llvm.add"(%376, %373) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %378 = "llvm.lshr"(%377, %46) : (i128, i128) -> i128
    %379 = "llvm.trunc"(%377) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %380 = "llvm.add"(%350, %340) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %381 = "llvm.add"(%380, %345) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %382 = "llvm.add"(%381, %378) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %383 = "llvm.lshr"(%382, %46) : (i128, i128) -> i128
    %384 = "llvm.trunc"(%382) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %385 = "llvm.add"(%362, %383) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %386 = "llvm.lshr"(%385, %46) : (i128, i128) -> i128
    %387 = "llvm.trunc"(%385) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %388 = "llvm.add"(%386, %352) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %389 = "llvm.trunc"(%388) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %390 = "llvm.shl"(%379, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %391 = "llvm.and"(%390, %47) : (i64, i64) -> i64
    %392 = "llvm.lshr"(%374, %38) : (i64, i64) -> i64
    %393 = "llvm.and"(%392, %48) : (i64, i64) -> i64
    %394 = "llvm.or"(%391, %393) <{isDisjoint}> : (i64, i64) -> i64
    %395 = "llvm.shl"(%384, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %396 = "llvm.and"(%395, %47) : (i64, i64) -> i64
    %397 = "llvm.lshr"(%379, %38) : (i64, i64) -> i64
    %398 = "llvm.and"(%397, %48) : (i64, i64) -> i64
    %399 = "llvm.or"(%396, %398) <{isDisjoint}> : (i64, i64) -> i64
    %400 = "llvm.shl"(%387, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %401 = "llvm.and"(%400, %47) : (i64, i64) -> i64
    %402 = "llvm.lshr"(%384, %38) : (i64, i64) -> i64
    %403 = "llvm.and"(%402, %48) : (i64, i64) -> i64
    %404 = "llvm.or"(%401, %403) <{isDisjoint}> : (i64, i64) -> i64
    %405 = "llvm.shl"(%389, %8) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %406 = "llvm.and"(%405, %47) : (i64, i64) -> i64
    %407 = "llvm.lshr"(%387, %38) : (i64, i64) -> i64
    %408 = "llvm.and"(%407, %48) : (i64, i64) -> i64
    %409 = "llvm.or"(%406, %408) <{isDisjoint}> : (i64, i64) -> i64
    %410 = "llvm.lshr"(%388, %49) : (i128, i128) -> i128
    %411 = "llvm.trunc"(%410) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128) -> i64
    %412 = "llvm.and"(%411, %47) : (i64, i64) -> i64
    %413 = "llvm.lshr"(%389, %38) : (i64, i64) -> i64
    %414 = "llvm.and"(%413, %48) : (i64, i64) -> i64
    %415 = "llvm.or"(%414, %412) <{isDisjoint}> : (i64, i64) -> i64
    %416 = "llvm.and"(%295, %50) : (i64, i64) -> i64
    %417 = "llvm.zext"(%394) <{nonNeg}> : (i64) -> i128
    %418 = "llvm.mul"(%417, %51) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %419 = "llvm.mul"(%417, %52) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %420 = "llvm.mul"(%417, %53) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %421 = "llvm.shl"(%417, %54) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %422 = "llvm.zext"(%399) <{nonNeg}> : (i64) -> i128
    %423 = "llvm.mul"(%422, %51) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %424 = "llvm.mul"(%422, %52) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %425 = "llvm.mul"(%422, %53) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %426 = "llvm.zext"(%404) <{nonNeg}> : (i64) -> i128
    %427 = "llvm.mul"(%426, %51) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %428 = "llvm.mul"(%426, %52) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %429 = "llvm.mul"(%426, %53) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %430 = "llvm.zext"(%409) <{nonNeg}> : (i64) -> i128
    %431 = "llvm.mul"(%430, %51) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %432 = "llvm.mul"(%430, %55) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %433 = "llvm.zext"(%415) <{nonNeg}> : (i64) -> i128
    %434 = "llvm.mul"(%433, %56) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %435 = "llvm.lshr"(%418, %46) : (i128, i128) -> i128
    %436 = "llvm.trunc"(%418) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %437 = "llvm.and"(%436, %36) : (i64, i64) -> i64
    %438 = "llvm.add"(%435, %419) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %439 = "llvm.add"(%438, %423) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %440 = "llvm.lshr"(%439, %46) : (i128, i128) -> i128
    %441 = "llvm.trunc"(%439) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %442 = "llvm.and"(%441, %36) : (i64, i64) -> i64
    %443 = "llvm.add"(%424, %420) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %444 = "llvm.add"(%443, %427) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %445 = "llvm.add"(%444, %440) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %446 = "llvm.lshr"(%445, %46) : (i128, i128) -> i128
    %447 = "llvm.trunc"(%445) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %448 = "llvm.and"(%447, %36) : (i64, i64) -> i64
    %449 = "llvm.add"(%428, %425) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %450 = "llvm.add"(%449, %431) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %451 = "llvm.add"(%450, %446) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %452 = "llvm.lshr"(%451, %46) : (i128, i128) -> i128
    %453 = "llvm.trunc"(%451) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %454 = "llvm.and"(%453, %36) : (i64, i64) -> i64
    %455 = "llvm.add"(%429, %421) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %456 = "llvm.add"(%455, %432) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %457 = "llvm.add"(%456, %434) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %458 = "llvm.add"(%457, %452) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %459 = "llvm.trunc"(%458) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i64
    %460 = "llvm.and"(%459, %50) : (i64, i64) -> i64
    %461 = "llvm.sub"(%287, %437) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %462 = "llvm.ashr"(%461, %37) : (i64, i64) -> i64
    %463 = "llvm.lshr"(%461, %5) : (i64, i64) -> i64
    %464 = "llvm.and"(%463, %57) : (i64, i64) -> i64
    %465 = "llvm.add"(%464, %461) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %466 = "llvm.add"(%462, %289) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %467 = "llvm.sub"(%466, %442) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %468 = "llvm.ashr"(%467, %37) : (i64, i64) -> i64
    %469 = "llvm.lshr"(%467, %5) : (i64, i64) -> i64
    %470 = "llvm.and"(%469, %57) : (i64, i64) -> i64
    %471 = "llvm.add"(%470, %467) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %472 = "llvm.add"(%468, %291) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %473 = "llvm.sub"(%472, %448) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %474 = "llvm.ashr"(%473, %37) : (i64, i64) -> i64
    %475 = "llvm.lshr"(%473, %5) : (i64, i64) -> i64
    %476 = "llvm.and"(%475, %57) : (i64, i64) -> i64
    %477 = "llvm.add"(%476, %473) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %478 = "llvm.sub"(%293, %454) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %479 = "llvm.add"(%478, %474) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %480 = "llvm.lshr"(%479, %37) : (i64, i64) -> i64
    %481 = "llvm.shl"(%480, %39) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %482 = "llvm.add"(%481, %479) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %483 = "llvm.add"(%480, %460) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %484 = "llvm.icmp"(%416, %483) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %485 = "llvm.select"(%484, %58, %13) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %486 = "llvm.or"(%485, %416) <{isDisjoint}> : (i64, i64) -> i64
    %487 = "llvm.sub"(%486, %483) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %488 = "llvm.add"(%465, %59) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %489 = "llvm.lshr"(%488, %37) : (i64, i64) -> i64
    %490 = "llvm.shl"(%489, %39) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %491 = "llvm.add"(%490, %488) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %492 = "llvm.or"(%489, %60) <{isDisjoint}> : (i64, i64) -> i64
    %493 = "llvm.sub"(%471, %492) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %494 = "llvm.lshr"(%493, %37) : (i64, i64) -> i64
    %495 = "llvm.shl"(%494, %39) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %496 = "llvm.add"(%495, %493) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %497 = "llvm.or"(%494, %61) <{isDisjoint}> : (i64, i64) -> i64
    %498 = "llvm.sub"(%477, %497) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %499 = "llvm.ashr"(%498, %37) : (i64, i64) -> i64
    %500 = "llvm.lshr"(%498, %37) : (i64, i64) -> i64
    %501 = "llvm.shl"(%500, %39) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %502 = "llvm.add"(%501, %498) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %503 = "llvm.sub"(%482, %500) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %504 = "llvm.lshr"(%503, %37) : (i64, i64) -> i64
    %505 = "llvm.shl"(%504, %39) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %506 = "llvm.add"(%482, %499) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %507 = "llvm.add"(%506, %505) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %508 = "llvm.or"(%504, %62) <{isDisjoint}> : (i64, i64) -> i64
    %509 = "llvm.icmp"(%487, %508) <{predicate = 2 : i64}> : (i64, i64) -> i1
    %510 = "llvm.select"(%509, %465, %491) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %511 = "llvm.select"(%509, %471, %496) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %512 = "llvm.select"(%509, %477, %502) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %513 = "llvm.select"(%509, %482, %507) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %514 = "llvm.select"(%509, %13, %508) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    %515 = "llvm.sub"(%487, %514) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.store"(%510, %85) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %516 = "llvm.getelementptr"(%85) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%511, %516) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %517 = "llvm.getelementptr"(%85) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%512, %517) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %518 = "llvm.getelementptr"(%85) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%513, %518) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %519 = "llvm.getelementptr"(%85) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%515, %519) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.call"(%92, %85) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%85) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %520 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 560>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%82) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%83) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%84) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%84, %520) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%83, %84, %84) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%84, %83, %83) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%82, %84, %84) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%91, %82) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%82) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%83) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%84) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %521 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%90, %521) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.clearCofactor, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%89, %90) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.neg, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%71) <{size = 1512 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%72) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%73) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%74) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%75) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%76) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%77) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%78) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%80) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%81) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    %522 = "llvm.getelementptr"(%89) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    %523 = "llvm.load"(%522) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i1
    "llvm.cond_br"(%523, %63)[^bb22, ^bb23] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
  ^bb22(%524: !llvm.ptr):  // 2 preds: ^bb21, ^bb29
    "llvm.call"(%81, %91) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%80, %92) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%79, %64, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%37)[^bb30] : (i64) -> ()
  ^bb23:  // pred: ^bb21
    "llvm.intr.lifetime.start"(%69) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.start"(%70) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%71, %64, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %525 = "llvm.getelementptr"(%71) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%525, %89, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"(%3)[^bb24] : (i64) -> ()
  ^bb24(%526: i64):  // 2 preds: ^bb23, ^bb26
    %527 = "llvm.icmp"(%526, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%527)[^bb29, ^bb25] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb25:  // pred: ^bb24
    %528 = "llvm.getelementptr"(%71, %526) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %529 = "llvm.and"(%526, %2) : (i64, i64) -> i64
    %530 = "llvm.icmp"(%529, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%530)[^bb27, ^bb28] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb26(%531: !llvm.ptr):  // 2 preds: ^bb27, ^bb28
    "llvm.intr.memcpy"(%528, %531, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %532 = "llvm.add"(%526, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%532)[^bb24] : (i64) -> ()
  ^bb27:  // pred: ^bb25
    %533 = "llvm.lshr"(%526, %2) <{isExact}> : (i64, i64) -> i64
    %534 = "llvm.getelementptr"(%71, %533) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%70, %534) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%70)[^bb26] : (!llvm.ptr) -> ()
  ^bb28:  // pred: ^bb25
    %535 = "llvm.add"(%526, %17) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %536 = "llvm.getelementptr"(%71, %535) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%69, %536, %89) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%69)[^bb26] : (!llvm.ptr) -> ()
  ^bb29:  // pred: ^bb24
    "llvm.intr.lifetime.end"(%69) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%70) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    %537 = "llvm.getelementptr"(%71) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 672>}> : (!llvm.ptr) -> !llvm.ptr
    %538 = "llvm.call"(%537) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
    %539 = "llvm.icmp"(%538, %20) <{predicate = 0 : i64}> : (i16, i16) -> i1
    "llvm.cond_br"(%539, %71)[^bb22, ^bb42] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
  ^bb30(%540: i64):  // 2 preds: ^bb22, ^bb41
    %541 = "llvm.getelementptr"(%81, %540) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %542 = "llvm.load"(%541) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %543 = "llvm.icmp"(%542, %12) <{predicate = 4 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%543)[^bb33, ^bb34] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb31(%544: !llvm.ptr):  // 2 preds: ^bb33, ^bb35
    "llvm.intr.memcpy"(%79, %544, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb32] : () -> ()
  ^bb32:  // 2 preds: ^bb31, ^bb34
    %545 = "llvm.getelementptr"(%80, %540) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %546 = "llvm.load"(%545) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %547 = "llvm.icmp"(%546, %12) <{predicate = 4 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%547)[^bb38, ^bb39] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb33:  // pred: ^bb30
    %548 = "llvm.zext"(%542) <{nonNeg}> : (i8) -> i64
    %549 = "llvm.getelementptr"(%63, %548) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%78, %79, %549) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%78)[^bb31] : (!llvm.ptr) -> ()
  ^bb34:  // pred: ^bb30
    %550 = "llvm.icmp"(%542, %12) <{predicate = 2 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%550)[^bb35, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb35:  // pred: ^bb34
    %551 = "llvm.sub"(%12, %542) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %552 = "llvm.zext"(%551) <{nonNeg}> : (i8) -> i64
    %553 = "llvm.getelementptr"(%63, %552) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%77, %79, %553) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%77)[^bb31] : (!llvm.ptr) -> ()
  ^bb36(%554: !llvm.ptr):  // 2 preds: ^bb38, ^bb40
    "llvm.intr.memcpy"(%79, %554, %19) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.br"()[^bb37] : () -> ()
  ^bb37:  // 2 preds: ^bb36, ^bb39
    %555 = "llvm.icmp"(%540, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%555)[^bb43, ^bb41] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb38:  // pred: ^bb32
    %556 = "llvm.zext"(%546) <{nonNeg}> : (i8) -> i64
    %557 = "llvm.getelementptr"(%524, %556) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%76, %79, %557) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%76)[^bb36] : (!llvm.ptr) -> ()
  ^bb39:  // pred: ^bb32
    %558 = "llvm.icmp"(%546, %12) <{predicate = 2 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%558)[^bb40, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb40:  // pred: ^bb39
    %559 = "llvm.sub"(%12, %546) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %560 = "llvm.zext"(%559) <{nonNeg}> : (i8) -> i64
    %561 = "llvm.getelementptr"(%524, %560) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.call"(%75, %79, %561) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%75)[^bb36] : (!llvm.ptr) -> ()
  ^bb41:  // pred: ^bb37
    "llvm.call"(%74, %79) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%73, %74) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%72, %73) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%79, %72) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %562 = "llvm.add"(%540, %17) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    "llvm.br"(%562)[^bb30] : (i64) -> ()
  ^bb42:  // pred: ^bb29
    "llvm.intr.lifetime.end"(%71) <{size = 1512 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%72) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%73) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%74) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%75) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%76) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%77) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%78) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%80) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%81) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%65)[^bb45] : (i16) -> ()
  ^bb43:  // pred: ^bb37
    "llvm.intr.lifetime.end"(%71) <{size = 1512 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%72) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%73) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%74) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%75) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%76) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%77) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%78) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%80) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%81) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    %563 = "llvm.getelementptr"(%99) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 392>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%88, %563) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.clearCofactor, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%87, %79, %88) <{CConv = #llvm.cconv<fastcc>, callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %564 = "llvm.call"(%87) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    "llvm.cond_br"(%564, %66)[^bb44, ^bb45] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i16) -> ()
  ^bb44:  // pred: ^bb43
    %565 = "llvm.getelementptr"(%87) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    %566 = "llvm.getelementptr"(%87) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%68) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%68, %565, %566) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %567 = "llvm.call"(%68) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    "llvm.intr.lifetime.end"(%68) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %568 = "llvm.select"(%567, %20, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i16, i16) -> i16
    "llvm.br"(%568)[^bb45] : (i16) -> ()
  ^bb45(%569: i16):  // 3 preds: ^bb42, ^bb43, ^bb44
    "llvm.intr.lifetime.end"(%79) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%87) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%88) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%89) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%90) <{size = 168 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%91) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%92) <{size = 32 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%93) <{size = 64 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%569)[^bb46] : (i16) -> ()
  ^bb46(%570: i16):  // 2 preds: ^bb9, ^bb45
    "llvm.intr.lifetime.end"(%99) <{size = 592 : i64}> : (!llvm.ptr) -> ()
    %571 = "llvm.zext"(%570) : (i16) -> i32
    %572 = "llvm.sub"(%67, %571) <{overflowFlags = #llvm.overflow<nsw>}> : (i32, i32) -> i32
    "llvm.return"(%572) : (i32) -> ()
}
  with @Edwards25519.add := Edwards25519_add,
    @Edwards25519.clearCofactor := Edwards25519_clearCofactor,
    @Edwards25519.dbl := Edwards25519_dbl, @Edwards25519.fromBytes := Edwards25519_fromBytes,
    @Edwards25519.neg := Edwards25519_neg,
    @Edwards25519.rejectIdentity := Edwards25519_rejectIdentity,
    @Edwards25519.slide := Edwards25519_slide, @Edwards25519.sub := Edwards25519_sub,
    @Fe.isZero := Fe_isZero, @Fe.sub := Fe_sub, @Scalar.add := Scalar_add,
    @Scalar.fromBytes := Scalar_fromBytes, @Scalar.toBytes := Scalar_toBytes,
    @Sha512.round := Sha512_round, @Sha512.update := Sha512_update,
    @Edwards25519.basePointPc := Edwards25519_basePointPc,
    @Edwards25519.identityElement := Edwards25519_identityElement, @Sha512.iv := Sha512_iv,
    @scalar.field_order_s := scalar_field_order_s

end

end LeanMLIR.RIR.Zig

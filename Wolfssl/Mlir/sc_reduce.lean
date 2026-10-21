
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Wolfssl.Mlir

@[expose] public section

mlir_def sc_reduce := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "sc_reduce", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3298534883328 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 4398046511103 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = -3411763647469 : i128}> : () -> i128
  %9 = "llvm.mlir.constant"() <{value = -2092548097176 : i128}> : () -> i128
  %10 = "llvm.mlir.constant"() <{value = -1434244213295 : i128}> : () -> i128
  %11 = "llvm.mlir.constant"() <{value = 42 : i128}> : () -> i128
  %12 = "llvm.mlir.constant"() <{value = 4398046511103 : i128}> : () -> i128
  %13 = "llvm.mlir.constant"() <{value = 8 : i128}> : () -> i128
  %14 = "llvm.mlir.poison"() : () -> vector<2xi128>
  %15 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 24 : i128}> : () -> i128
  %17 = "llvm.mlir.constant"() <{value = dense<[16, 24]> : vector<2xi128>}> : () -> vector<2xi128>
  %18 = "llvm.mlir.poison"() : () -> vector<4xi128>
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 32 : i128}> : () -> i128
  %21 = "llvm.mlir.constant"() <{value = 40 : i128}> : () -> i128
  %22 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %23 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %24 = "llvm.mlir.constant"() <{value = 6 : i128}> : () -> i128
  %25 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
  %26 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
  %27 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %28 = "llvm.mlir.constant"() <{value = 4 : i128}> : () -> i128
  %29 = "llvm.mlir.constant"() <{value = 36 : i128}> : () -> i128
  %30 = "llvm.mlir.constant"() <{value = 63 : i8}> : () -> i8
  %31 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %32 = "llvm.mlir.poison"() : () -> vector<8xi128>
  %33 = "llvm.mlir.constant"() <{value = dense<[2, 10, 18, 26, 34, 0, 8, 16]> : vector<8xi128>}> : () -> vector<8xi128>
  %34 = "llvm.mlir.constant"() <{value = dense<[6, 14, 22, 30]> : vector<4xi128>}> : () -> vector<4xi128>
  %35 = "llvm.load"(%arg0) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %36 = "llvm.zext"(%35) : (i32) -> i64
  %37 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %38 = "llvm.load"(%37) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %39 = "llvm.zext"(%38) : (i8) -> i64
  %40 = "llvm.shl"(%39, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %41 = "llvm.or"(%40, %36) <{isDisjoint}> : (i64, i64) -> i64
  %42 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %43 = "llvm.load"(%42) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %44 = "llvm.zext"(%43) : (i8) -> i64
  %45 = "llvm.shl"(%44, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %46 = "llvm.and"(%45, %3) : (i64, i64) -> i64
  %47 = "llvm.or"(%41, %46) <{isDisjoint}> : (i64, i64) -> i64
  %48 = "llvm.zext"(%47) <{nonNeg}> : (i64) -> i128
  %49 = "llvm.load"(%42) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %50 = "llvm.zext"(%49) : (i32) -> i64
  %51 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %52 = "llvm.load"(%51) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %53 = "llvm.zext"(%52) : (i8) -> i64
  %54 = "llvm.shl"(%53, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %55 = "llvm.or"(%54, %50) <{isDisjoint}> : (i64, i64) -> i64
  %56 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.load"(%56) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %58 = "llvm.zext"(%57) : (i8) -> i64
  %59 = "llvm.shl"(%58, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %60 = "llvm.or"(%55, %59) <{isDisjoint}> : (i64, i64) -> i64
  %61 = "llvm.lshr"(%60, %4) : (i64, i64) -> i64
  %62 = "llvm.and"(%61, %5) : (i64, i64) -> i64
  %63 = "llvm.zext"(%62) <{nonNeg}> : (i64) -> i128
  %64 = "llvm.load"(%56) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %65 = "llvm.zext"(%64) : (i32) -> i64
  %66 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.load"(%66) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %68 = "llvm.zext"(%67) : (i8) -> i64
  %69 = "llvm.shl"(%68, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %70 = "llvm.or"(%69, %65) <{isDisjoint}> : (i64, i64) -> i64
  %71 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %72 = "llvm.load"(%71) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %73 = "llvm.zext"(%72) : (i8) -> i64
  %74 = "llvm.shl"(%73, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %75 = "llvm.or"(%70, %74) <{isDisjoint}> : (i64, i64) -> i64
  %76 = "llvm.lshr"(%75, %0) : (i64, i64) -> i64
  %77 = "llvm.and"(%76, %5) : (i64, i64) -> i64
  %78 = "llvm.zext"(%77) <{nonNeg}> : (i64) -> i128
  %79 = "llvm.load"(%71) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %80 = "llvm.zext"(%79) : (i32) -> i64
  %81 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %82 = "llvm.load"(%81) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %83 = "llvm.zext"(%82) : (i8) -> i64
  %84 = "llvm.shl"(%83, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %85 = "llvm.or"(%84, %80) <{isDisjoint}> : (i64, i64) -> i64
  %86 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %87 = "llvm.load"(%86) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %88 = "llvm.zext"(%87) : (i8) -> i64
  %89 = "llvm.shl"(%88, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %90 = "llvm.or"(%85, %89) <{isDisjoint}> : (i64, i64) -> i64
  %91 = "llvm.lshr"(%90, %6) : (i64, i64) -> i64
  %92 = "llvm.zext"(%91) <{nonNeg}> : (i64) -> i128
  %93 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %94 = "llvm.load"(%93) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %95 = "llvm.zext"(%94) : (i32) -> i64
  %96 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %98 = "llvm.zext"(%97) : (i8) -> i64
  %99 = "llvm.shl"(%98, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %100 = "llvm.or"(%99, %95) <{isDisjoint}> : (i64, i64) -> i64
  %101 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %102 = "llvm.load"(%101) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %103 = "llvm.zext"(%102) : (i8) -> i64
  %104 = "llvm.shl"(%103, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %105 = "llvm.and"(%104, %3) : (i64, i64) -> i64
  %106 = "llvm.or"(%100, %105) <{isDisjoint}> : (i64, i64) -> i64
  %107 = "llvm.zext"(%106) <{nonNeg}> : (i64) -> i128
  %108 = "llvm.load"(%101) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %109 = "llvm.zext"(%108) : (i32) -> i64
  %110 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %111 = "llvm.load"(%110) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %112 = "llvm.zext"(%111) : (i8) -> i64
  %113 = "llvm.shl"(%112, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %114 = "llvm.or"(%113, %109) <{isDisjoint}> : (i64, i64) -> i64
  %115 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %116 = "llvm.load"(%115) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %117 = "llvm.zext"(%116) : (i8) -> i64
  %118 = "llvm.shl"(%117, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %119 = "llvm.or"(%114, %118) <{isDisjoint}> : (i64, i64) -> i64
  %120 = "llvm.lshr"(%119, %4) : (i64, i64) -> i64
  %121 = "llvm.and"(%120, %5) : (i64, i64) -> i64
  %122 = "llvm.zext"(%121) <{nonNeg}> : (i64) -> i128
  %123 = "llvm.load"(%115) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %124 = "llvm.zext"(%123) : (i32) -> i64
  %125 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 35>}> : (!llvm.ptr) -> !llvm.ptr
  %126 = "llvm.load"(%125) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %127 = "llvm.zext"(%126) : (i8) -> i64
  %128 = "llvm.shl"(%127, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %129 = "llvm.or"(%128, %124) <{isDisjoint}> : (i64, i64) -> i64
  %130 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 36>}> : (!llvm.ptr) -> !llvm.ptr
  %131 = "llvm.load"(%130) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %132 = "llvm.zext"(%131) : (i8) -> i64
  %133 = "llvm.shl"(%132, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %134 = "llvm.or"(%129, %133) <{isDisjoint}> : (i64, i64) -> i64
  %135 = "llvm.lshr"(%134, %0) : (i64, i64) -> i64
  %136 = "llvm.and"(%135, %5) : (i64, i64) -> i64
  %137 = "llvm.zext"(%136) <{nonNeg}> : (i64) -> i128
  %138 = "llvm.load"(%130) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %139 = "llvm.zext"(%138) : (i32) -> i64
  %140 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %141 = "llvm.load"(%140) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %142 = "llvm.zext"(%141) : (i8) -> i64
  %143 = "llvm.shl"(%142, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %144 = "llvm.or"(%143, %139) <{isDisjoint}> : (i64, i64) -> i64
  %145 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 41>}> : (!llvm.ptr) -> !llvm.ptr
  %146 = "llvm.load"(%145) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %147 = "llvm.zext"(%146) : (i8) -> i64
  %148 = "llvm.shl"(%147, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %149 = "llvm.or"(%144, %148) <{isDisjoint}> : (i64, i64) -> i64
  %150 = "llvm.lshr"(%149, %6) : (i64, i64) -> i64
  %151 = "llvm.zext"(%150) <{nonNeg}> : (i64) -> i128
  %152 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 42>}> : (!llvm.ptr) -> !llvm.ptr
  %153 = "llvm.load"(%152) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %154 = "llvm.zext"(%153) : (i32) -> i64
  %155 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 46>}> : (!llvm.ptr) -> !llvm.ptr
  %156 = "llvm.load"(%155) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %157 = "llvm.zext"(%156) : (i8) -> i64
  %158 = "llvm.shl"(%157, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %159 = "llvm.or"(%158, %154) <{isDisjoint}> : (i64, i64) -> i64
  %160 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 47>}> : (!llvm.ptr) -> !llvm.ptr
  %161 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %162 = "llvm.zext"(%161) : (i8) -> i64
  %163 = "llvm.shl"(%162, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %164 = "llvm.and"(%163, %3) : (i64, i64) -> i64
  %165 = "llvm.or"(%159, %164) <{isDisjoint}> : (i64, i64) -> i64
  %166 = "llvm.zext"(%165) <{nonNeg}> : (i64) -> i128
  %167 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %168 = "llvm.zext"(%167) : (i32) -> i64
  %169 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 51>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %171 = "llvm.zext"(%170) : (i8) -> i64
  %172 = "llvm.shl"(%171, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %173 = "llvm.or"(%172, %168) <{isDisjoint}> : (i64, i64) -> i64
  %174 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 52>}> : (!llvm.ptr) -> !llvm.ptr
  %175 = "llvm.load"(%174) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %176 = "llvm.zext"(%175) : (i8) -> i64
  %177 = "llvm.shl"(%176, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %178 = "llvm.or"(%173, %177) <{isDisjoint}> : (i64, i64) -> i64
  %179 = "llvm.lshr"(%178, %4) : (i64, i64) -> i64
  %180 = "llvm.and"(%179, %5) : (i64, i64) -> i64
  %181 = "llvm.zext"(%180) <{nonNeg}> : (i64) -> i128
  %182 = "llvm.load"(%174) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %183 = "llvm.zext"(%182) : (i32) -> i64
  %184 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %185 = "llvm.load"(%184) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %186 = "llvm.zext"(%185) : (i8) -> i64
  %187 = "llvm.shl"(%186, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %188 = "llvm.or"(%187, %183) <{isDisjoint}> : (i64, i64) -> i64
  %189 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 57>}> : (!llvm.ptr) -> !llvm.ptr
  %190 = "llvm.load"(%189) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %191 = "llvm.zext"(%190) : (i8) -> i64
  %192 = "llvm.shl"(%191, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %193 = "llvm.or"(%188, %192) <{isDisjoint}> : (i64, i64) -> i64
  %194 = "llvm.lshr"(%193, %0) : (i64, i64) -> i64
  %195 = "llvm.and"(%194, %5) : (i64, i64) -> i64
  %196 = "llvm.zext"(%195) <{nonNeg}> : (i64) -> i128
  %197 = "llvm.load"(%189) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %198 = "llvm.zext"(%197) : (i32) -> i64
  %199 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 61>}> : (!llvm.ptr) -> !llvm.ptr
  %200 = "llvm.load"(%199) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %201 = "llvm.zext"(%200) : (i8) -> i64
  %202 = "llvm.shl"(%201, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %203 = "llvm.or"(%202, %198) <{isDisjoint}> : (i64, i64) -> i64
  %204 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 62>}> : (!llvm.ptr) -> !llvm.ptr
  %205 = "llvm.load"(%204) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %206 = "llvm.zext"(%205) : (i8) -> i64
  %207 = "llvm.shl"(%206, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %208 = "llvm.or"(%203, %207) <{isDisjoint}> : (i64, i64) -> i64
  %209 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %210 = "llvm.load"(%209) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %211 = "llvm.zext"(%210) : (i8) -> i64
  %212 = "llvm.shl"(%211, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %213 = "llvm.or"(%208, %212) <{isDisjoint}> : (i64, i64) -> i64
  %214 = "llvm.lshr"(%213, %6) : (i64, i64) -> i64
  %215 = "llvm.zext"(%214) <{nonNeg}> : (i64) -> i128
  %216 = "llvm.mul"(%215, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %217 = "llvm.mul"(%215, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %218 = "llvm.mul"(%215, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %219 = "llvm.add"(%218, %151) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %220 = "llvm.mul"(%196, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %221 = "llvm.mul"(%196, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %222 = "llvm.mul"(%196, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %223 = "llvm.mul"(%181, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %224 = "llvm.add"(%223, %92) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %225 = "llvm.mul"(%181, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %226 = "llvm.mul"(%181, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %227 = "llvm.add"(%226, %122) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %228 = "llvm.add"(%227, %221) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %229 = "llvm.add"(%228, %216) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %230 = "llvm.ashr"(%224, %11) : (i128, i128) -> i128
  %231 = "llvm.add"(%225, %107) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %232 = "llvm.add"(%231, %230) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %233 = "llvm.add"(%232, %220) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %234 = "llvm.and"(%224, %12) : (i128, i128) -> i128
  %235 = "llvm.ashr"(%229, %11) : (i128, i128) -> i128
  %236 = "llvm.add"(%222, %137) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %237 = "llvm.add"(%236, %217) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %238 = "llvm.add"(%237, %235) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %239 = "llvm.and"(%229, %12) : (i128, i128) -> i128
  %240 = "llvm.ashr"(%219, %11) : (i128, i128) -> i128
  %241 = "llvm.add"(%240, %166) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %242 = "llvm.and"(%219, %12) : (i128, i128) -> i128
  %243 = "llvm.ashr"(%233, %11) : (i128, i128) -> i128
  %244 = "llvm.add"(%239, %243) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %245 = "llvm.and"(%233, %12) : (i128, i128) -> i128
  %246 = "llvm.ashr"(%238, %11) : (i128, i128) -> i128
  %247 = "llvm.add"(%246, %242) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %248 = "llvm.and"(%238, %12) : (i128, i128) -> i128
  %249 = "llvm.mul"(%241, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %250 = "llvm.add"(%249, %78) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %251 = "llvm.mul"(%241, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %252 = "llvm.add"(%251, %234) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %253 = "llvm.mul"(%241, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %254 = "llvm.add"(%253, %245) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %255 = "llvm.mul"(%247, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %256 = "llvm.mul"(%247, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %257 = "llvm.mul"(%247, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %258 = "llvm.add"(%252, %257) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %259 = "llvm.mul"(%248, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %260 = "llvm.add"(%259, %48) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %261 = "llvm.mul"(%248, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %262 = "llvm.mul"(%248, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %263 = "llvm.ashr"(%260, %11) : (i128, i128) -> i128
  %264 = "llvm.add"(%261, %63) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %265 = "llvm.add"(%264, %255) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %266 = "llvm.add"(%265, %263) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %267 = "llvm.and"(%260, %12) : (i128, i128) -> i128
  %268 = "llvm.ashr"(%266, %11) : (i128, i128) -> i128
  %269 = "llvm.add"(%250, %262) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %270 = "llvm.add"(%269, %256) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %271 = "llvm.add"(%270, %268) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %272 = "llvm.and"(%266, %12) : (i128, i128) -> i128
  %273 = "llvm.ashr"(%271, %11) : (i128, i128) -> i128
  %274 = "llvm.add"(%258, %273) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %275 = "llvm.and"(%271, %12) : (i128, i128) -> i128
  %276 = "llvm.ashr"(%274, %11) : (i128, i128) -> i128
  %277 = "llvm.add"(%254, %276) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %278 = "llvm.and"(%274, %12) : (i128, i128) -> i128
  %279 = "llvm.ashr"(%277, %11) : (i128, i128) -> i128
  %280 = "llvm.add"(%244, %279) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %281 = "llvm.and"(%277, %12) : (i128, i128) -> i128
  %282 = "llvm.ashr"(%280, %11) : (i128, i128) -> i128
  %283 = "llvm.and"(%280, %12) : (i128, i128) -> i128
  %284 = "llvm.mul"(%282, %8) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %285 = "llvm.mul"(%282, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %286 = "llvm.add"(%285, %272) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %287 = "llvm.mul"(%282, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %288 = "llvm.add"(%287, %275) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %289 = "llvm.add"(%284, %267) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %290 = "llvm.ashr"(%289, %11) : (i128, i128) -> i128
  %291 = "llvm.add"(%286, %290) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %292 = "llvm.ashr"(%291, %11) : (i128, i128) -> i128
  %293 = "llvm.add"(%288, %292) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %294 = "llvm.ashr"(%293, %11) : (i128, i128) -> i128
  %295 = "llvm.lshr"(%289, %13) : (i128, i128) -> i128
  %296 = "llvm.insertelement"(%14, %289, %15) : (vector<2xi128>, i128, i64) -> vector<2xi128>
  %297 = "llvm.shufflevector"(%296, %14) <{mask = array<i32: 0, 0>}> : (vector<2xi128>, vector<2xi128>) -> vector<2xi128>
  %298 = "llvm.lshr"(%297, %17) : (vector<2xi128>, vector<2xi128>) -> vector<2xi128>
  %299 = "llvm.insertelement"(%18, %289, %15) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %300 = "llvm.insertelement"(%299, %295, %19) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %301 = "llvm.shufflevector"(%298, %14) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi128>, vector<2xi128>) -> vector<4xi128>
  %302 = "llvm.shufflevector"(%300, %301) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %303 = "llvm.trunc"(%302) <{overflowFlags = 0 : i32}> : (vector<4xi128>) -> vector<4xi8>
  "llvm.store"(%303, %arg0) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi8>, !llvm.ptr) -> ()
  %304 = "llvm.lshr"(%289, %20) : (i128, i128) -> i128
  %305 = "llvm.trunc"(%304) <{overflowFlags = 0 : i32}> : (i128) -> i8
  "llvm.store"(%305, %37) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %306 = "llvm.lshr"(%289, %21) : (i128, i128) -> i128
  %307 = "llvm.trunc"(%306) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %308 = "llvm.and"(%307, %22) : (i8, i8) -> i8
  %309 = "llvm.trunc"(%291) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %310 = "llvm.shl"(%309, %23) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %311 = "llvm.or"(%310, %308) <{isDisjoint}> : (i8, i8) -> i8
  "llvm.store"(%311, %42) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %312 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %313 = "llvm.lshr"(%291, %24) : (i128, i128) -> i128
  %314 = "llvm.trunc"(%313) <{overflowFlags = 0 : i32}> : (i128) -> i32
  "llvm.store"(%314, %312) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %315 = "llvm.lshr"(%291, %25) : (i128, i128) -> i128
  %316 = "llvm.trunc"(%315) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %317 = "llvm.and"(%316, %26) : (i8, i8) -> i8
  %318 = "llvm.trunc"(%293) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %319 = "llvm.shl"(%318, %27) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %320 = "llvm.or"(%319, %317) <{isDisjoint}> : (i8, i8) -> i8
  "llvm.store"(%320, %56) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %321 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %322 = "llvm.lshr"(%293, %28) : (i128, i128) -> i128
  %323 = "llvm.trunc"(%322) <{overflowFlags = 0 : i32}> : (i128) -> i32
  "llvm.store"(%323, %321) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %324 = "llvm.lshr"(%293, %29) : (i128, i128) -> i128
  %325 = "llvm.trunc"(%324) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %326 = "llvm.and"(%325, %30) : (i8, i8) -> i8
  %327 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %328 = "llvm.add"(%294, %278) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %329 = "llvm.ashr"(%328, %11) : (i128, i128) -> i128
  %330 = "llvm.add"(%329, %281) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %331 = "llvm.ashr"(%330, %11) : (i128, i128) -> i128
  %332 = "llvm.add"(%331, %283) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %333 = "llvm.trunc"(%328) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %334 = "llvm.shl"(%333, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %335 = "llvm.or"(%334, %326) <{isDisjoint}> : (i8, i8) -> i8
  "llvm.store"(%335, %71) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %336 = "llvm.insertelement"(%32, %328, %15) : (vector<8xi128>, i128, i64) -> vector<8xi128>
  %337 = "llvm.insertelement"(%336, %330, %19) : (vector<8xi128>, i128, i64) -> vector<8xi128>
  %338 = "llvm.shufflevector"(%337, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 1, 1, 1>}> : (vector<8xi128>, vector<8xi128>) -> vector<8xi128>
  %339 = "llvm.lshr"(%338, %33) : (vector<8xi128>, vector<8xi128>) -> vector<8xi128>
  %340 = "llvm.trunc"(%339) <{overflowFlags = 0 : i32}> : (vector<8xi128>) -> vector<8xi8>
  "llvm.store"(%340, %327) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi8>, !llvm.ptr) -> ()
  %341 = "llvm.lshr"(%330, %16) : (i128, i128) -> i128
  %342 = "llvm.trunc"(%341) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %343 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%342, %343) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %344 = "llvm.lshr"(%330, %20) : (i128, i128) -> i128
  %345 = "llvm.trunc"(%344) <{overflowFlags = 0 : i32}> : (i128) -> i8
  "llvm.store"(%345, %96) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %346 = "llvm.lshr"(%330, %21) : (i128, i128) -> i128
  %347 = "llvm.trunc"(%346) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %348 = "llvm.and"(%347, %22) : (i8, i8) -> i8
  %349 = "llvm.trunc"(%332) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %350 = "llvm.shl"(%349, %23) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %351 = "llvm.or"(%350, %348) <{isDisjoint}> : (i8, i8) -> i8
  "llvm.store"(%351, %101) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %352 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %353 = "llvm.insertelement"(%18, %332, %15) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %354 = "llvm.shufflevector"(%353, %18) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %355 = "llvm.lshr"(%354, %34) : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %356 = "llvm.trunc"(%355) <{overflowFlags = 0 : i32}> : (vector<4xi128>) -> vector<4xi8>
  "llvm.store"(%356, %352) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi8>, !llvm.ptr) -> ()
  %357 = "llvm.lshr"(%332, %25) : (i128, i128) -> i128
  %358 = "llvm.trunc"(%357) <{overflowFlags = 0 : i32}> : (i128) -> i8
  "llvm.store"(%358, %115) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Wolfssl.Mlir

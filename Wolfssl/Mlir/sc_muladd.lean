
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Wolfssl.Mlir

@[expose] public section

mlir_def sc_muladd := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "sc_muladd", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3298534883328 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 4398046511103 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 42 : i128}> : () -> i128
  %8 = "llvm.mlir.constant"() <{value = 4398046511103 : i128}> : () -> i128
  %9 = "llvm.mlir.constant"() <{value = -3411763647469 : i128}> : () -> i128
  %10 = "llvm.mlir.constant"() <{value = -2092548097176 : i128}> : () -> i128
  %11 = "llvm.mlir.constant"() <{value = -1434244213295 : i128}> : () -> i128
  %12 = "llvm.mlir.constant"() <{value = 8 : i128}> : () -> i128
  %13 = "llvm.mlir.poison"() : () -> vector<2xi128>
  %14 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 24 : i128}> : () -> i128
  %16 = "llvm.mlir.constant"() <{value = dense<[16, 24]> : vector<2xi128>}> : () -> vector<2xi128>
  %17 = "llvm.mlir.poison"() : () -> vector<4xi128>
  %18 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 32 : i128}> : () -> i128
  %20 = "llvm.mlir.constant"() <{value = 40 : i128}> : () -> i128
  %21 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %22 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %23 = "llvm.mlir.constant"() <{value = 6 : i128}> : () -> i128
  %24 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
  %25 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
  %26 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %27 = "llvm.mlir.constant"() <{value = 4 : i128}> : () -> i128
  %28 = "llvm.mlir.constant"() <{value = 36 : i128}> : () -> i128
  %29 = "llvm.mlir.constant"() <{value = 63 : i8}> : () -> i8
  %30 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %31 = "llvm.mlir.poison"() : () -> vector<8xi128>
  %32 = "llvm.mlir.constant"() <{value = dense<[2, 10, 18, 26, 34, 0, 8, 16]> : vector<8xi128>}> : () -> vector<8xi128>
  %33 = "llvm.mlir.constant"() <{value = dense<[6, 14, 22, 30]> : vector<4xi128>}> : () -> vector<4xi128>
  %34 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %35 = "llvm.zext"(%34) : (i32) -> i64
  %36 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %37 = "llvm.load"(%36) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %38 = "llvm.zext"(%37) : (i8) -> i64
  %39 = "llvm.shl"(%38, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %40 = "llvm.or"(%39, %35) <{isDisjoint}> : (i64, i64) -> i64
  %41 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %42 = "llvm.load"(%41) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %43 = "llvm.zext"(%42) : (i8) -> i64
  %44 = "llvm.shl"(%43, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %45 = "llvm.and"(%44, %3) : (i64, i64) -> i64
  %46 = "llvm.or"(%40, %45) <{isDisjoint}> : (i64, i64) -> i64
  %47 = "llvm.load"(%41) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %48 = "llvm.zext"(%47) : (i32) -> i64
  %49 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %50 = "llvm.load"(%49) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %51 = "llvm.zext"(%50) : (i8) -> i64
  %52 = "llvm.shl"(%51, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %53 = "llvm.or"(%52, %48) <{isDisjoint}> : (i64, i64) -> i64
  %54 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %55 = "llvm.load"(%54) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %56 = "llvm.zext"(%55) : (i8) -> i64
  %57 = "llvm.shl"(%56, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %58 = "llvm.or"(%53, %57) <{isDisjoint}> : (i64, i64) -> i64
  %59 = "llvm.lshr"(%58, %4) : (i64, i64) -> i64
  %60 = "llvm.and"(%59, %5) : (i64, i64) -> i64
  %61 = "llvm.load"(%54) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %62 = "llvm.zext"(%61) : (i32) -> i64
  %63 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %64 = "llvm.load"(%63) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %65 = "llvm.zext"(%64) : (i8) -> i64
  %66 = "llvm.shl"(%65, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %67 = "llvm.or"(%66, %62) <{isDisjoint}> : (i64, i64) -> i64
  %68 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %69 = "llvm.load"(%68) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %70 = "llvm.zext"(%69) : (i8) -> i64
  %71 = "llvm.shl"(%70, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %72 = "llvm.or"(%67, %71) <{isDisjoint}> : (i64, i64) -> i64
  %73 = "llvm.lshr"(%72, %0) : (i64, i64) -> i64
  %74 = "llvm.and"(%73, %5) : (i64, i64) -> i64
  %75 = "llvm.load"(%68) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %76 = "llvm.zext"(%75) : (i32) -> i64
  %77 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %78 = "llvm.load"(%77) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %79 = "llvm.zext"(%78) : (i8) -> i64
  %80 = "llvm.shl"(%79, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %81 = "llvm.or"(%80, %76) <{isDisjoint}> : (i64, i64) -> i64
  %82 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %83 = "llvm.load"(%82) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %84 = "llvm.zext"(%83) : (i8) -> i64
  %85 = "llvm.shl"(%84, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %86 = "llvm.or"(%81, %85) <{isDisjoint}> : (i64, i64) -> i64
  %87 = "llvm.lshr"(%86, %6) : (i64, i64) -> i64
  %88 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %89 = "llvm.load"(%88) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %90 = "llvm.zext"(%89) : (i32) -> i64
  %91 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %92 = "llvm.load"(%91) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %93 = "llvm.zext"(%92) : (i8) -> i64
  %94 = "llvm.shl"(%93, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %95 = "llvm.or"(%94, %90) <{isDisjoint}> : (i64, i64) -> i64
  %96 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %98 = "llvm.zext"(%97) : (i8) -> i64
  %99 = "llvm.shl"(%98, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %100 = "llvm.and"(%99, %3) : (i64, i64) -> i64
  %101 = "llvm.or"(%95, %100) <{isDisjoint}> : (i64, i64) -> i64
  %102 = "llvm.load"(%96) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %103 = "llvm.zext"(%102) : (i32) -> i64
  %104 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %105 = "llvm.load"(%104) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %106 = "llvm.zext"(%105) : (i8) -> i64
  %107 = "llvm.shl"(%106, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %108 = "llvm.or"(%107, %103) <{isDisjoint}> : (i64, i64) -> i64
  %109 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %110 = "llvm.load"(%109) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %111 = "llvm.zext"(%110) : (i8) -> i64
  %112 = "llvm.shl"(%111, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %113 = "llvm.or"(%108, %112) <{isDisjoint}> : (i64, i64) -> i64
  %114 = "llvm.lshr"(%113, %4) : (i64, i64) -> i64
  %115 = "llvm.load"(%arg2) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %116 = "llvm.zext"(%115) : (i32) -> i64
  %117 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %118 = "llvm.load"(%117) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %119 = "llvm.zext"(%118) : (i8) -> i64
  %120 = "llvm.shl"(%119, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %121 = "llvm.or"(%120, %116) <{isDisjoint}> : (i64, i64) -> i64
  %122 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %123 = "llvm.load"(%122) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %124 = "llvm.zext"(%123) : (i8) -> i64
  %125 = "llvm.shl"(%124, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %126 = "llvm.and"(%125, %3) : (i64, i64) -> i64
  %127 = "llvm.or"(%121, %126) <{isDisjoint}> : (i64, i64) -> i64
  %128 = "llvm.load"(%122) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %129 = "llvm.zext"(%128) : (i32) -> i64
  %130 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %131 = "llvm.load"(%130) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %132 = "llvm.zext"(%131) : (i8) -> i64
  %133 = "llvm.shl"(%132, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %134 = "llvm.or"(%133, %129) <{isDisjoint}> : (i64, i64) -> i64
  %135 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %136 = "llvm.load"(%135) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %137 = "llvm.zext"(%136) : (i8) -> i64
  %138 = "llvm.shl"(%137, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %139 = "llvm.or"(%134, %138) <{isDisjoint}> : (i64, i64) -> i64
  %140 = "llvm.lshr"(%139, %4) : (i64, i64) -> i64
  %141 = "llvm.and"(%140, %5) : (i64, i64) -> i64
  %142 = "llvm.load"(%135) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %143 = "llvm.zext"(%142) : (i32) -> i64
  %144 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %145 = "llvm.load"(%144) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %146 = "llvm.zext"(%145) : (i8) -> i64
  %147 = "llvm.shl"(%146, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %148 = "llvm.or"(%147, %143) <{isDisjoint}> : (i64, i64) -> i64
  %149 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %150 = "llvm.load"(%149) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %151 = "llvm.zext"(%150) : (i8) -> i64
  %152 = "llvm.shl"(%151, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %153 = "llvm.or"(%148, %152) <{isDisjoint}> : (i64, i64) -> i64
  %154 = "llvm.lshr"(%153, %0) : (i64, i64) -> i64
  %155 = "llvm.and"(%154, %5) : (i64, i64) -> i64
  %156 = "llvm.load"(%149) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %157 = "llvm.zext"(%156) : (i32) -> i64
  %158 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %159 = "llvm.load"(%158) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %160 = "llvm.zext"(%159) : (i8) -> i64
  %161 = "llvm.shl"(%160, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %162 = "llvm.or"(%161, %157) <{isDisjoint}> : (i64, i64) -> i64
  %163 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %164 = "llvm.load"(%163) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %165 = "llvm.zext"(%164) : (i8) -> i64
  %166 = "llvm.shl"(%165, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %167 = "llvm.or"(%162, %166) <{isDisjoint}> : (i64, i64) -> i64
  %168 = "llvm.lshr"(%167, %6) : (i64, i64) -> i64
  %169 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %171 = "llvm.zext"(%170) : (i32) -> i64
  %172 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %173 = "llvm.load"(%172) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %174 = "llvm.zext"(%173) : (i8) -> i64
  %175 = "llvm.shl"(%174, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.or"(%175, %171) <{isDisjoint}> : (i64, i64) -> i64
  %177 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %178 = "llvm.load"(%177) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %179 = "llvm.zext"(%178) : (i8) -> i64
  %180 = "llvm.shl"(%179, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %181 = "llvm.and"(%180, %3) : (i64, i64) -> i64
  %182 = "llvm.or"(%176, %181) <{isDisjoint}> : (i64, i64) -> i64
  %183 = "llvm.load"(%177) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %184 = "llvm.zext"(%183) : (i32) -> i64
  %185 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %186 = "llvm.load"(%185) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %187 = "llvm.zext"(%186) : (i8) -> i64
  %188 = "llvm.shl"(%187, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %189 = "llvm.or"(%188, %184) <{isDisjoint}> : (i64, i64) -> i64
  %190 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %191 = "llvm.load"(%190) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %192 = "llvm.zext"(%191) : (i8) -> i64
  %193 = "llvm.shl"(%192, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %194 = "llvm.or"(%189, %193) <{isDisjoint}> : (i64, i64) -> i64
  %195 = "llvm.lshr"(%194, %4) : (i64, i64) -> i64
  %196 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %197 = "llvm.zext"(%196) : (i32) -> i64
  %198 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %199 = "llvm.load"(%198) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %200 = "llvm.zext"(%199) : (i8) -> i64
  %201 = "llvm.shl"(%200, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %202 = "llvm.or"(%201, %197) <{isDisjoint}> : (i64, i64) -> i64
  %203 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %204 = "llvm.load"(%203) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %205 = "llvm.zext"(%204) : (i8) -> i64
  %206 = "llvm.shl"(%205, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %207 = "llvm.and"(%206, %3) : (i64, i64) -> i64
  %208 = "llvm.or"(%202, %207) <{isDisjoint}> : (i64, i64) -> i64
  %209 = "llvm.load"(%203) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %210 = "llvm.zext"(%209) : (i32) -> i64
  %211 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %212 = "llvm.load"(%211) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %213 = "llvm.zext"(%212) : (i8) -> i64
  %214 = "llvm.shl"(%213, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %215 = "llvm.or"(%214, %210) <{isDisjoint}> : (i64, i64) -> i64
  %216 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %217 = "llvm.load"(%216) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %218 = "llvm.zext"(%217) : (i8) -> i64
  %219 = "llvm.shl"(%218, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %220 = "llvm.or"(%215, %219) <{isDisjoint}> : (i64, i64) -> i64
  %221 = "llvm.lshr"(%220, %4) : (i64, i64) -> i64
  %222 = "llvm.and"(%221, %5) : (i64, i64) -> i64
  %223 = "llvm.load"(%216) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %224 = "llvm.zext"(%223) : (i32) -> i64
  %225 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %226 = "llvm.load"(%225) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %227 = "llvm.zext"(%226) : (i8) -> i64
  %228 = "llvm.shl"(%227, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %229 = "llvm.or"(%228, %224) <{isDisjoint}> : (i64, i64) -> i64
  %230 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %231 = "llvm.load"(%230) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %232 = "llvm.zext"(%231) : (i8) -> i64
  %233 = "llvm.shl"(%232, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %234 = "llvm.or"(%229, %233) <{isDisjoint}> : (i64, i64) -> i64
  %235 = "llvm.lshr"(%234, %0) : (i64, i64) -> i64
  %236 = "llvm.and"(%235, %5) : (i64, i64) -> i64
  %237 = "llvm.load"(%230) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %238 = "llvm.zext"(%237) : (i32) -> i64
  %239 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %240 = "llvm.load"(%239) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %241 = "llvm.zext"(%240) : (i8) -> i64
  %242 = "llvm.shl"(%241, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %243 = "llvm.or"(%242, %238) <{isDisjoint}> : (i64, i64) -> i64
  %244 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %245 = "llvm.load"(%244) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %246 = "llvm.zext"(%245) : (i8) -> i64
  %247 = "llvm.shl"(%246, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %248 = "llvm.or"(%243, %247) <{isDisjoint}> : (i64, i64) -> i64
  %249 = "llvm.lshr"(%248, %6) : (i64, i64) -> i64
  %250 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %251 = "llvm.load"(%250) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %252 = "llvm.zext"(%251) : (i32) -> i64
  %253 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %255 = "llvm.zext"(%254) : (i8) -> i64
  %256 = "llvm.shl"(%255, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %257 = "llvm.or"(%256, %252) <{isDisjoint}> : (i64, i64) -> i64
  %258 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.load"(%258) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %260 = "llvm.zext"(%259) : (i8) -> i64
  %261 = "llvm.shl"(%260, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %262 = "llvm.and"(%261, %3) : (i64, i64) -> i64
  %263 = "llvm.or"(%257, %262) <{isDisjoint}> : (i64, i64) -> i64
  %264 = "llvm.load"(%258) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %265 = "llvm.zext"(%264) : (i32) -> i64
  %266 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %267 = "llvm.load"(%266) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %268 = "llvm.zext"(%267) : (i8) -> i64
  %269 = "llvm.shl"(%268, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %270 = "llvm.or"(%269, %265) <{isDisjoint}> : (i64, i64) -> i64
  %271 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %272 = "llvm.load"(%271) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %273 = "llvm.zext"(%272) : (i8) -> i64
  %274 = "llvm.shl"(%273, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %275 = "llvm.or"(%270, %274) <{isDisjoint}> : (i64, i64) -> i64
  %276 = "llvm.lshr"(%275, %4) : (i64, i64) -> i64
  %277 = "llvm.zext"(%208) <{nonNeg}> : (i64) -> i128
  %278 = "llvm.zext"(%46) <{nonNeg}> : (i64) -> i128
  %279 = "llvm.zext"(%127) <{nonNeg}> : (i64) -> i128
  %280 = "llvm.mul"(%279, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %281 = "llvm.add"(%280, %277) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %282 = "llvm.zext"(%222) <{nonNeg}> : (i64) -> i128
  %283 = "llvm.zext"(%141) <{nonNeg}> : (i64) -> i128
  %284 = "llvm.mul"(%283, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %285 = "llvm.zext"(%60) <{nonNeg}> : (i64) -> i128
  %286 = "llvm.mul"(%279, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %287 = "llvm.zext"(%236) <{nonNeg}> : (i64) -> i128
  %288 = "llvm.zext"(%155) <{nonNeg}> : (i64) -> i128
  %289 = "llvm.mul"(%288, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %290 = "llvm.mul"(%283, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %291 = "llvm.zext"(%74) <{nonNeg}> : (i64) -> i128
  %292 = "llvm.mul"(%279, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %293 = "llvm.add"(%290, %292) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %294 = "llvm.add"(%293, %289) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %295 = "llvm.add"(%294, %287) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %296 = "llvm.zext"(%249) <{nonNeg}> : (i64) -> i128
  %297 = "llvm.zext"(%168) <{nonNeg}> : (i64) -> i128
  %298 = "llvm.mul"(%297, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %299 = "llvm.mul"(%288, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %300 = "llvm.mul"(%283, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %301 = "llvm.zext"(%87) <{nonNeg}> : (i64) -> i128
  %302 = "llvm.mul"(%279, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %303 = "llvm.zext"(%263) <{nonNeg}> : (i64) -> i128
  %304 = "llvm.zext"(%182) <{nonNeg}> : (i64) -> i128
  %305 = "llvm.mul"(%304, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %306 = "llvm.mul"(%297, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %307 = "llvm.mul"(%288, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %308 = "llvm.mul"(%283, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %309 = "llvm.zext"(%101) <{nonNeg}> : (i64) -> i128
  %310 = "llvm.mul"(%279, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %311 = "llvm.add"(%308, %310) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %312 = "llvm.add"(%311, %307) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %313 = "llvm.add"(%312, %306) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %314 = "llvm.add"(%313, %305) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %315 = "llvm.add"(%314, %303) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %316 = "llvm.zext"(%276) <{nonNeg}> : (i64) -> i128
  %317 = "llvm.zext"(%195) <{nonNeg}> : (i64) -> i128
  %318 = "llvm.mul"(%317, %278) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %319 = "llvm.mul"(%304, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %320 = "llvm.mul"(%297, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %321 = "llvm.mul"(%288, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %322 = "llvm.mul"(%283, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %323 = "llvm.zext"(%114) <{nonNeg}> : (i64) -> i128
  %324 = "llvm.mul"(%279, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %325 = "llvm.mul"(%317, %285) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %326 = "llvm.mul"(%304, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %327 = "llvm.mul"(%297, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %328 = "llvm.mul"(%288, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %329 = "llvm.mul"(%283, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %330 = "llvm.add"(%328, %329) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %331 = "llvm.add"(%330, %327) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %332 = "llvm.add"(%331, %326) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %333 = "llvm.add"(%332, %325) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %334 = "llvm.mul"(%317, %291) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %335 = "llvm.mul"(%304, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %336 = "llvm.mul"(%297, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %337 = "llvm.mul"(%288, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %338 = "llvm.mul"(%317, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %339 = "llvm.mul"(%304, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %340 = "llvm.mul"(%297, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %341 = "llvm.add"(%339, %340) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %342 = "llvm.add"(%341, %338) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %343 = "llvm.mul"(%317, %309) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %344 = "llvm.mul"(%304, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %345 = "llvm.add"(%343, %344) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %346 = "llvm.mul"(%317, %323) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %347 = "llvm.lshr"(%281, %7) : (i128, i128) -> i128
  %348 = "llvm.add"(%284, %286) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %349 = "llvm.add"(%348, %347) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %350 = "llvm.add"(%349, %282) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %351 = "llvm.and"(%281, %8) : (i128, i128) -> i128
  %352 = "llvm.lshr"(%295, %7) : (i128, i128) -> i128
  %353 = "llvm.add"(%300, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %354 = "llvm.add"(%353, %299) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %355 = "llvm.add"(%354, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %356 = "llvm.add"(%355, %296) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %357 = "llvm.add"(%356, %352) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %358 = "llvm.and"(%295, %8) : (i128, i128) -> i128
  %359 = "llvm.lshr"(%315, %7) : (i128, i128) -> i128
  %360 = "llvm.add"(%322, %324) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %361 = "llvm.add"(%360, %321) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %362 = "llvm.add"(%361, %320) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %363 = "llvm.add"(%362, %319) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %364 = "llvm.add"(%363, %318) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %365 = "llvm.add"(%364, %316) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %366 = "llvm.add"(%365, %359) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %367 = "llvm.and"(%315, %8) : (i128, i128) -> i128
  %368 = "llvm.lshr"(%333, %7) : (i128, i128) -> i128
  %369 = "llvm.add"(%336, %337) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %370 = "llvm.add"(%369, %335) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %371 = "llvm.add"(%370, %334) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %372 = "llvm.add"(%371, %368) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %373 = "llvm.and"(%333, %8) : (i128, i128) -> i128
  %374 = "llvm.lshr"(%342, %7) : (i128, i128) -> i128
  %375 = "llvm.add"(%345, %374) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %376 = "llvm.and"(%342, %8) : (i128, i128) -> i128
  %377 = "llvm.lshr"(%346, %7) : (i128, i128) -> i128
  %378 = "llvm.and"(%346, %8) : (i128, i128) -> i128
  %379 = "llvm.lshr"(%350, %7) : (i128, i128) -> i128
  %380 = "llvm.and"(%350, %8) : (i128, i128) -> i128
  %381 = "llvm.lshr"(%357, %7) : (i128, i128) -> i128
  %382 = "llvm.and"(%357, %8) : (i128, i128) -> i128
  %383 = "llvm.lshr"(%366, %7) : (i128, i128) -> i128
  %384 = "llvm.and"(%366, %8) : (i128, i128) -> i128
  %385 = "llvm.lshr"(%372, %7) : (i128, i128) -> i128
  %386 = "llvm.add"(%385, %376) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %387 = "llvm.and"(%372, %8) : (i128, i128) -> i128
  %388 = "llvm.lshr"(%375, %7) : (i128, i128) -> i128
  %389 = "llvm.add"(%388, %378) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %390 = "llvm.and"(%375, %8) : (i128, i128) -> i128
  %391 = "llvm.mul"(%377, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %392 = "llvm.mul"(%377, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %393 = "llvm.mul"(%377, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %394 = "llvm.add"(%387, %393) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %395 = "llvm.mul"(%389, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %396 = "llvm.mul"(%389, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %397 = "llvm.mul"(%389, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %398 = "llvm.mul"(%390, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %399 = "llvm.add"(%382, %398) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %400 = "llvm.mul"(%390, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %401 = "llvm.mul"(%390, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %402 = "llvm.add"(%401, %391) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %403 = "llvm.add"(%402, %396) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %404 = "llvm.add"(%403, %384) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %405 = "llvm.ashr"(%399, %7) : (i128, i128) -> i128
  %406 = "llvm.add"(%395, %400) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %407 = "llvm.add"(%406, %381) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %408 = "llvm.add"(%407, %405) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %409 = "llvm.add"(%408, %367) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %410 = "llvm.and"(%399, %8) : (i128, i128) -> i128
  %411 = "llvm.ashr"(%404, %7) : (i128, i128) -> i128
  %412 = "llvm.add"(%373, %392) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %413 = "llvm.add"(%412, %397) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %414 = "llvm.add"(%413, %383) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %415 = "llvm.add"(%414, %411) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %416 = "llvm.and"(%404, %8) : (i128, i128) -> i128
  %417 = "llvm.ashr"(%394, %7) : (i128, i128) -> i128
  %418 = "llvm.add"(%386, %417) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %419 = "llvm.and"(%394, %8) : (i128, i128) -> i128
  %420 = "llvm.ashr"(%409, %7) : (i128, i128) -> i128
  %421 = "llvm.add"(%416, %420) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %422 = "llvm.and"(%409, %8) : (i128, i128) -> i128
  %423 = "llvm.ashr"(%415, %7) : (i128, i128) -> i128
  %424 = "llvm.add"(%423, %419) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %425 = "llvm.and"(%415, %8) : (i128, i128) -> i128
  %426 = "llvm.mul"(%418, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %427 = "llvm.mul"(%418, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %428 = "llvm.add"(%410, %427) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %429 = "llvm.mul"(%418, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %430 = "llvm.add"(%422, %429) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %431 = "llvm.mul"(%424, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %432 = "llvm.mul"(%424, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %433 = "llvm.mul"(%424, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %434 = "llvm.add"(%428, %433) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %435 = "llvm.mul"(%425, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %436 = "llvm.add"(%435, %351) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %437 = "llvm.mul"(%425, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %438 = "llvm.mul"(%425, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %439 = "llvm.ashr"(%436, %7) : (i128, i128) -> i128
  %440 = "llvm.add"(%437, %380) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %441 = "llvm.add"(%440, %431) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %442 = "llvm.add"(%441, %439) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %443 = "llvm.and"(%436, %8) : (i128, i128) -> i128
  %444 = "llvm.ashr"(%442, %7) : (i128, i128) -> i128
  %445 = "llvm.add"(%426, %379) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %446 = "llvm.add"(%445, %358) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %447 = "llvm.add"(%446, %438) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %448 = "llvm.add"(%447, %432) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %449 = "llvm.add"(%448, %444) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %450 = "llvm.and"(%442, %8) : (i128, i128) -> i128
  %451 = "llvm.ashr"(%449, %7) : (i128, i128) -> i128
  %452 = "llvm.add"(%434, %451) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %453 = "llvm.and"(%449, %8) : (i128, i128) -> i128
  %454 = "llvm.ashr"(%452, %7) : (i128, i128) -> i128
  %455 = "llvm.add"(%430, %454) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %456 = "llvm.and"(%452, %8) : (i128, i128) -> i128
  %457 = "llvm.ashr"(%455, %7) : (i128, i128) -> i128
  %458 = "llvm.add"(%421, %457) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %459 = "llvm.and"(%455, %8) : (i128, i128) -> i128
  %460 = "llvm.ashr"(%458, %7) : (i128, i128) -> i128
  %461 = "llvm.and"(%458, %8) : (i128, i128) -> i128
  %462 = "llvm.mul"(%460, %9) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %463 = "llvm.mul"(%460, %10) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %464 = "llvm.add"(%463, %450) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %465 = "llvm.mul"(%460, %11) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %466 = "llvm.add"(%465, %453) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %467 = "llvm.add"(%462, %443) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %468 = "llvm.ashr"(%467, %7) : (i128, i128) -> i128
  %469 = "llvm.add"(%464, %468) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %470 = "llvm.ashr"(%469, %7) : (i128, i128) -> i128
  %471 = "llvm.add"(%466, %470) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %472 = "llvm.ashr"(%471, %7) : (i128, i128) -> i128
  %473 = "llvm.lshr"(%467, %12) : (i128, i128) -> i128
  %474 = "llvm.insertelement"(%13, %467, %14) : (vector<2xi128>, i128, i64) -> vector<2xi128>
  %475 = "llvm.shufflevector"(%474, %13) <{mask = array<i32: 0, 0>}> : (vector<2xi128>, vector<2xi128>) -> vector<2xi128>
  %476 = "llvm.lshr"(%475, %16) : (vector<2xi128>, vector<2xi128>) -> vector<2xi128>
  %477 = "llvm.insertelement"(%17, %467, %14) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %478 = "llvm.insertelement"(%477, %473, %18) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %479 = "llvm.shufflevector"(%476, %13) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi128>, vector<2xi128>) -> vector<4xi128>
  %480 = "llvm.shufflevector"(%478, %479) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %481 = "llvm.trunc"(%480) <{overflowFlags = 0 : i32}> : (vector<4xi128>) -> vector<4xi8>
  "llvm.store"(%481, %arg0) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi8>, !llvm.ptr) -> ()
  %482 = "llvm.lshr"(%467, %19) : (i128, i128) -> i128
  %483 = "llvm.trunc"(%482) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %484 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%483, %484) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %485 = "llvm.lshr"(%467, %20) : (i128, i128) -> i128
  %486 = "llvm.trunc"(%485) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %487 = "llvm.and"(%486, %21) : (i8, i8) -> i8
  %488 = "llvm.trunc"(%469) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %489 = "llvm.shl"(%488, %22) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %490 = "llvm.or"(%489, %487) <{isDisjoint}> : (i8, i8) -> i8
  %491 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%490, %491) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %492 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %493 = "llvm.lshr"(%469, %23) : (i128, i128) -> i128
  %494 = "llvm.trunc"(%493) <{overflowFlags = 0 : i32}> : (i128) -> i32
  "llvm.store"(%494, %492) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %495 = "llvm.lshr"(%469, %24) : (i128, i128) -> i128
  %496 = "llvm.trunc"(%495) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %497 = "llvm.and"(%496, %25) : (i8, i8) -> i8
  %498 = "llvm.trunc"(%471) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %499 = "llvm.shl"(%498, %26) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %500 = "llvm.or"(%499, %497) <{isDisjoint}> : (i8, i8) -> i8
  %501 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%500, %501) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %502 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %503 = "llvm.lshr"(%471, %27) : (i128, i128) -> i128
  %504 = "llvm.trunc"(%503) <{overflowFlags = 0 : i32}> : (i128) -> i32
  "llvm.store"(%504, %502) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %505 = "llvm.lshr"(%471, %28) : (i128, i128) -> i128
  %506 = "llvm.trunc"(%505) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %507 = "llvm.and"(%506, %29) : (i8, i8) -> i8
  %508 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %509 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %510 = "llvm.add"(%472, %456) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %511 = "llvm.ashr"(%510, %7) : (i128, i128) -> i128
  %512 = "llvm.add"(%511, %459) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %513 = "llvm.ashr"(%512, %7) : (i128, i128) -> i128
  %514 = "llvm.add"(%513, %461) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %515 = "llvm.trunc"(%510) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %516 = "llvm.shl"(%515, %30) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %517 = "llvm.or"(%516, %507) <{isDisjoint}> : (i8, i8) -> i8
  "llvm.store"(%517, %508) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %518 = "llvm.insertelement"(%31, %510, %14) : (vector<8xi128>, i128, i64) -> vector<8xi128>
  %519 = "llvm.insertelement"(%518, %512, %18) : (vector<8xi128>, i128, i64) -> vector<8xi128>
  %520 = "llvm.shufflevector"(%519, %31) <{mask = array<i32: 0, 0, 0, 0, 0, 1, 1, 1>}> : (vector<8xi128>, vector<8xi128>) -> vector<8xi128>
  %521 = "llvm.lshr"(%520, %32) : (vector<8xi128>, vector<8xi128>) -> vector<8xi128>
  %522 = "llvm.trunc"(%521) <{overflowFlags = 0 : i32}> : (vector<8xi128>) -> vector<8xi8>
  "llvm.store"(%522, %509) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi8>, !llvm.ptr) -> ()
  %523 = "llvm.lshr"(%512, %15) : (i128, i128) -> i128
  %524 = "llvm.trunc"(%523) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %525 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%524, %525) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %526 = "llvm.lshr"(%512, %19) : (i128, i128) -> i128
  %527 = "llvm.trunc"(%526) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %528 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%527, %528) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %529 = "llvm.lshr"(%512, %20) : (i128, i128) -> i128
  %530 = "llvm.trunc"(%529) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %531 = "llvm.and"(%530, %21) : (i8, i8) -> i8
  %532 = "llvm.trunc"(%514) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %533 = "llvm.shl"(%532, %22) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %534 = "llvm.or"(%533, %531) <{isDisjoint}> : (i8, i8) -> i8
  %535 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%534, %535) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %536 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %537 = "llvm.insertelement"(%17, %514, %14) : (vector<4xi128>, i128, i64) -> vector<4xi128>
  %538 = "llvm.shufflevector"(%537, %17) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %539 = "llvm.lshr"(%538, %33) : (vector<4xi128>, vector<4xi128>) -> vector<4xi128>
  %540 = "llvm.trunc"(%539) <{overflowFlags = 0 : i32}> : (vector<4xi128>) -> vector<4xi8>
  "llvm.store"(%540, %536) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi8>, !llvm.ptr) -> ()
  %541 = "llvm.lshr"(%514, %24) : (i128, i128) -> i128
  %542 = "llvm.trunc"(%541) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %543 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%542, %543) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Wolfssl.Mlir

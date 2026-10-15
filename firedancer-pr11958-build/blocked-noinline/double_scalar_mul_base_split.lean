
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_base_point_wnaf_table
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def double_scalar_mul_base_split := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "double_scalar_mul_base_split", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr):
  %0 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi16>}> : () -> vector<8xi16>
  %4 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %5 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 96 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %19 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %21 = "llvm.mlir.poison"() : () -> vector<8xi16>
  %22 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = dense<[true, true, true, true, true, true, true, false]> : vector<8xi1>}> : () -> vector<8xi1>
  %24 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %26 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %27 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %28 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %29 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %30 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %33 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %34 = "llvm.mlir.poison"() : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 172032 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = 147456 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 122880 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = 98304 : i64}> : () -> i64
  %39 = "llvm.mlir.constant"() <{value = 73728 : i64}> : () -> i64
  %40 = "llvm.mlir.constant"() <{value = 49152 : i64}> : () -> i64
  %41 = "llvm.mlir.constant"() <{value = 24576 : i64}> : () -> i64
  %42 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %44 = "llvm.insertelement"(%42, %41, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %40, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %39, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %38, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %37, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %36, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %35, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %34, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%42, %34, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %12, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %13, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %14, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %15, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %16, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %17, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %18, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.alloca"(%30) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %61 = "llvm.alloca"(%30) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %62 = "llvm.alloca"(%30) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %63 = "llvm.alloca"(%30) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%60) : (!llvm.ptr) -> ()
  "llvm.call"(%60, %arg1, %31) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%61) : (!llvm.ptr) -> ()
  "llvm.call"(%61, %arg3, %32) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%62) : (!llvm.ptr) -> ()
  "llvm.store"(%33, %62) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %64 = "llvm.getelementptr"(%arg4, %51) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, vector<8xi64>) -> vector<8x!llvm.ptr>
  %65 = "llvm.getelementptr"(%64) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -24576>}> : (vector<8x!llvm.ptr>) -> vector<8x!llvm.ptr>
  %66 = "llvm.getelementptr"(%62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.masked.store"(%65, %66, %23) <{alignment = 8 : i32}> : (vector<8x!llvm.ptr>, !llvm.ptr, vector<8xi1>) -> ()
  "llvm.intr.lifetime.start"(%63) : (!llvm.ptr) -> ()
  %67 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%22)[^bb1] : (i64) -> ()
^bb1(%68: i64):  // 2 preds: ^bb0, ^bb2
  %69 = "llvm.getelementptr"(%60, %68) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %70 = "llvm.load"(%69) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %71 = "llvm.insertelement"(%21, %70, %20) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %72 = "llvm.insertelement"(%19, %68, %20) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %73 = "llvm.shufflevector"(%72, %19) <{mask = array<i32: -1, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %74 = "llvm.add"(%73, %59) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %75 = "llvm.extractelement"(%74, %11) : (vector<8xi64>, i64) -> i64
  %76 = "llvm.getelementptr"(%60, %75) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %77 = "llvm.load"(%76) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %78 = "llvm.insertelement"(%71, %77, %11) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %79 = "llvm.extractelement"(%74, %10) : (vector<8xi64>, i64) -> i64
  %80 = "llvm.getelementptr"(%60, %79) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %81 = "llvm.load"(%80) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %82 = "llvm.insertelement"(%78, %81, %10) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %83 = "llvm.extractelement"(%74, %9) : (vector<8xi64>, i64) -> i64
  %84 = "llvm.getelementptr"(%60, %83) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %85 = "llvm.load"(%84) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %86 = "llvm.insertelement"(%82, %85, %9) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %87 = "llvm.extractelement"(%74, %8) : (vector<8xi64>, i64) -> i64
  %88 = "llvm.getelementptr"(%60, %87) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %89 = "llvm.load"(%88) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %90 = "llvm.insertelement"(%86, %89, %8) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %91 = "llvm.extractelement"(%74, %7) : (vector<8xi64>, i64) -> i64
  %92 = "llvm.getelementptr"(%60, %91) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %93 = "llvm.load"(%92) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %94 = "llvm.insertelement"(%90, %93, %7) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %95 = "llvm.extractelement"(%74, %6) : (vector<8xi64>, i64) -> i64
  %96 = "llvm.getelementptr"(%60, %95) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %98 = "llvm.insertelement"(%94, %97, %6) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %99 = "llvm.extractelement"(%74, %5) : (vector<8xi64>, i64) -> i64
  %100 = "llvm.getelementptr"(%60, %99) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %101 = "llvm.load"(%100) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %102 = "llvm.insertelement"(%98, %101, %5) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %103 = "llvm.getelementptr"(%61, %68) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %104 = "llvm.load"(%103) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %105 = "llvm.insertelement"(%21, %104, %20) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %106 = "llvm.getelementptr"(%61, %75) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.load"(%106) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %108 = "llvm.insertelement"(%105, %107, %11) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %109 = "llvm.getelementptr"(%61, %79) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %110 = "llvm.load"(%109) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %111 = "llvm.insertelement"(%108, %110, %10) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %112 = "llvm.getelementptr"(%61, %83) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %113 = "llvm.load"(%112) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %114 = "llvm.insertelement"(%111, %113, %9) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %115 = "llvm.getelementptr"(%61, %87) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %116 = "llvm.load"(%115) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %117 = "llvm.insertelement"(%114, %116, %8) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %118 = "llvm.getelementptr"(%61, %91) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %119 = "llvm.load"(%118) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %120 = "llvm.insertelement"(%117, %119, %7) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %121 = "llvm.getelementptr"(%61, %95) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %122 = "llvm.load"(%121) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %123 = "llvm.insertelement"(%120, %122, %6) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %124 = "llvm.getelementptr"(%61, %99) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %125 = "llvm.load"(%124) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %126 = "llvm.insertelement"(%123, %125, %5) : (vector<8xi16>, i16, i64) -> vector<8xi16>
  %127 = "llvm.or"(%102, %126) : (vector<8xi16>, vector<8xi16>) -> vector<8xi16>
  %128 = "llvm.icmp"(%127, %3) <{predicate = 1 : i64}> : (vector<8xi16>, vector<8xi16>) -> vector<8xi1>
  %129 = "llvm.bitcast"(%128) : (vector<8xi1>) -> i8
  %130 = "llvm.icmp"(%129, %2) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%130)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %131 = "llvm.add"(%68, %1) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %132 = "llvm.icmp"(%68, %20) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%132, %131)[^bb22, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb1
  %133 = "llvm.icmp"(%68, %1) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%133)[^bb4, ^bb22] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %134 = "llvm.icmp"(%arg5, %0) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.br"(%68)[^bb5] : (i64) -> ()
^bb5(%135: i64):  // 2 preds: ^bb4, ^bb21
  %136 = "llvm.call"(%63, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.cond_br"(%134)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // 2 preds: ^bb5, ^bb7
  "llvm.br"(%20)[^bb9] : (i64) -> ()
^bb7:  // pred: ^bb5
  "llvm.call"(%arg5, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_decode_step, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"()[^bb6] : () -> ()
^bb8:  // pred: ^bb19
  %137 = "llvm.icmp"(%135, %20) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%137)[^bb20, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9(%138: i64):  // 2 preds: ^bb6, ^bb19
  %139 = "llvm.shl"(%138, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %140 = "llvm.add"(%139, %135) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %141 = "llvm.getelementptr"(%60, %140) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %142 = "llvm.load"(%141) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %143 = "llvm.getelementptr"(%61, %140) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %144 = "llvm.load"(%143) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %145 = "llvm.sext"(%142) : (i16) -> i32
  %146 = "llvm.icmp"(%142, %4) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%146)[^bb10, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %147 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %148 = "llvm.lshr"(%145, %30) : (i32, i32) -> i32
  %149 = "llvm.trunc"(%138) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %150 = "llvm.shl"(%149, %29) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %151 = "llvm.add"(%148, %150) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %152 = "llvm.zext"(%151) <{nonNeg}> : (i32) -> i64
  %153 = "llvm.getelementptr"(%arg2, %152) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %154 = "llvm.call"(%63, %arg0, %153, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.cond_br"(%134)[^bb14, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb9
  %155 = "llvm.icmp"(%142, %4) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%155)[^bb12, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %156 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %157 = "llvm.sub"(%43, %145) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %158 = "llvm.lshr"(%157, %30) : (i32, i32) -> i32
  %159 = "llvm.trunc"(%138) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %160 = "llvm.shl"(%159, %29) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %161 = "llvm.add"(%158, %160) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %162 = "llvm.zext"(%161) <{nonNeg}> : (i32) -> i64
  %163 = "llvm.getelementptr"(%arg2, %162) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %164 = "llvm.call"(%63, %arg0, %163, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.cond_br"(%134)[^bb14, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // 2 preds: ^bb10, ^bb12
  "llvm.call"(%arg5, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_decode_step, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"()[^bb14] : () -> ()
^bb14:  // 4 preds: ^bb10, ^bb11, ^bb12, ^bb13
  %165 = "llvm.sext"(%144) : (i16) -> i32
  %166 = "llvm.icmp"(%144, %4) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%166)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %167 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %168 = "llvm.getelementptr"(%62, %138) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %169 = "llvm.load"(%168) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.lshr"(%165, %30) : (i32, i32) -> i32
  %171 = "llvm.zext"(%170) <{nonNeg}> : (i32) -> i64
  %172 = "llvm.getelementptr"(%169, %171) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %173 = "llvm.call"(%63, %arg0, %172, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.cond_br"(%134)[^bb19, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb16:  // pred: ^bb14
  %174 = "llvm.icmp"(%144, %4) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%174)[^bb17, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %175 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %176 = "llvm.getelementptr"(%62, %138) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %177 = "llvm.load"(%176) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %178 = "llvm.sub"(%43, %165) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %179 = "llvm.lshr"(%178, %30) : (i32, i32) -> i32
  %180 = "llvm.zext"(%179) <{nonNeg}> : (i32) -> i64
  %181 = "llvm.getelementptr"(%177, %180) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %182 = "llvm.call"(%63, %arg0, %181, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.cond_br"(%134)[^bb19, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb18:  // 2 preds: ^bb15, ^bb17
  "llvm.call"(%arg5, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_decode_step, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"()[^bb19] : () -> ()
^bb19:  // 4 preds: ^bb15, ^bb16, ^bb17, ^bb18
  %183 = "llvm.add"(%138, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %184 = "llvm.icmp"(%183, %24) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%184, %183)[^bb8, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb20:  // pred: ^bb8
  %185 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb22] : () -> ()
^bb21:  // pred: ^bb8
  %186 = "llvm.call"(%arg0, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %187 = "llvm.add"(%135, %1) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %188 = "llvm.icmp"(%135, %20) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%188, %187)[^bb5, ^bb22] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb22:  // 4 preds: ^bb2, ^bb3, ^bb20, ^bb21
  "llvm.intr.lifetime.end"(%63) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%62) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%61) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%60) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_wnaf_table := Firedancer.LaneNI.Mlir.fd_ed25519_base_point_wnaf_table,
      @fd_curve25519_scalar_wnaf := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf,
      @fd_curve25519_scalar_wnaf := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf,
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ed25519_partial_dbl := Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl,
      @fd_ed25519_point_decode_step := Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_sub_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts,
      @fd_ed25519_point_decode_step := Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_sub_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts,
      @fd_ed25519_point_decode_step := Firedancer.LaneNI.Mlir.fd_ed25519_point_decode_step,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_final_mul_projective := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

end

end Firedancer.LaneNI.Mlir

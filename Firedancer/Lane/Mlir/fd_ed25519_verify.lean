
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.Lane.Mlir.fd_sha512_init
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_fini
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_ed25519_verify_equation

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_verify := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[3034496493606, 7251660506358, 8531477514791, 3751700492266, 152656122684, 51415276304, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[5761277761479, 1544430418697, 264613410264, 5044390432789, 8643434802371, 1048094254319, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %9 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %20 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %21 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %23 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %28 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %29 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %30 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %31 = "llvm.mlir.poison"() : () -> i64
  %32 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %31, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %25, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %31, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %31, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %31, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %31, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %31, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %31, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%32, %25, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %31, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %31, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %31, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %31, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %31, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %31, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %31, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %50 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %51 = "llvm.alloca"(%17) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %52 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %53 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %54 = "llvm.load"(%53) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %55 = "llvm.icmp"(%54, %19) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%55)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %56 = "llvm.icmp"(%54, %20) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%56, %21)[^bb2, ^bb9] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %57 = "llvm.load"(%52) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %58 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %60 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %61 = "llvm.load"(%60) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %62 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.load"(%62) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %64 = "llvm.call_intrinsic"(%22, %57, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %65 = "llvm.extractvalue"(%64) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %66 = "llvm.call_intrinsic"(%65, %59, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %67 = "llvm.extractvalue"(%66) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %68 = "llvm.call_intrinsic"(%67, %61, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %69 = "llvm.extractvalue"(%68) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %70 = "llvm.call_intrinsic"(%69, %63, %26) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %71 = "llvm.extractvalue"(%70) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %72 = "llvm.icmp"(%71, %27) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%72, %21)[^bb9, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb3:  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%49) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%50) : (!llvm.ptr) -> ()
  %73 = "llvm.call"(%49, %arg3, %50, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %74 = "llvm.icmp"(%73, %28) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%74)[^bb5, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %75 = "llvm.icmp"(%73, %21) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %76 = "llvm.select"(%75, %29, %21) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%76)[^bb8] : (i32) -> ()
^bb5:  // pred: ^bb3
  %77 = "llvm.load"(%49) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %78 = "llvm.getelementptr"(%49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %79 = "llvm.load"(%78) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %80 = "llvm.getelementptr"(%49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %81 = "llvm.load"(%80) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %82 = "llvm.shufflevector"(%77, %79) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %83 = "llvm.shufflevector"(%77, %79) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.insertelement"(%81, %25, %30) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %85 = "llvm.shufflevector"(%81, %40) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.shufflevector"(%82, %84) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.shufflevector"(%83, %85) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.icmp"(%86, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %89 = "llvm.bitcast"(%88) : (vector<8xi1>) -> i8
  %90 = "llvm.icmp"(%89, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %91 = "llvm.icmp"(%86, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %92 = "llvm.bitcast"(%91) : (vector<8xi1>) -> i8
  %93 = "llvm.icmp"(%92, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %94 = "llvm.select"(%90, %93, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %95 = "llvm.icmp"(%87, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %96 = "llvm.bitcast"(%95) : (vector<8xi1>) -> i8
  %97 = "llvm.icmp"(%96, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %98 = "llvm.icmp"(%87, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %99 = "llvm.bitcast"(%98) : (vector<8xi1>) -> i8
  %100 = "llvm.icmp"(%99, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %101 = "llvm.select"(%97, %100, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %102 = "llvm.and"(%94, %101) : (i1, i1) -> i1
  %103 = "llvm.add"(%87, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.and"(%103, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.ashr"(%103, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.shufflevector"(%105, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.mul"(%106, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.and"(%107, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.add"(%104, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.add"(%109, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.add"(%110, %108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.icmp"(%111, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %113 = "llvm.bitcast"(%112) : (vector<8xi1>) -> i8
  %114 = "llvm.icmp"(%113, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %115 = "llvm.icmp"(%111, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %116 = "llvm.bitcast"(%115) : (vector<8xi1>) -> i8
  %117 = "llvm.icmp"(%116, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %118 = "llvm.and"(%114, %117) : (i1, i1) -> i1
  %119 = "llvm.and"(%102, %118) : (i1, i1) -> i1
  %120 = "llvm.add"(%87, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.and"(%120, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.ashr"(%120, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.shufflevector"(%122, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.mul"(%123, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.and"(%124, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.add"(%121, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.add"(%126, %123) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.add"(%127, %125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.icmp"(%128, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %130 = "llvm.bitcast"(%129) : (vector<8xi1>) -> i8
  %131 = "llvm.icmp"(%130, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %132 = "llvm.icmp"(%128, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %133 = "llvm.bitcast"(%132) : (vector<8xi1>) -> i8
  %134 = "llvm.icmp"(%133, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %135 = "llvm.and"(%131, %134) : (i1, i1) -> i1
  %136 = "llvm.and"(%135, %119) : (i1, i1) -> i1
  "llvm.cond_br"(%136, %29)[^bb6, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // pred: ^bb5
  %137 = "llvm.load"(%50) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %138 = "llvm.getelementptr"(%50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %139 = "llvm.load"(%138) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %140 = "llvm.getelementptr"(%50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %141 = "llvm.load"(%140) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %142 = "llvm.shufflevector"(%137, %139) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.shufflevector"(%137, %139) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.insertelement"(%141, %25, %30) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %145 = "llvm.shufflevector"(%141, %40) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.shufflevector"(%142, %144) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.shufflevector"(%143, %145) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.icmp"(%146, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %149 = "llvm.bitcast"(%148) : (vector<8xi1>) -> i8
  %150 = "llvm.icmp"(%149, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %151 = "llvm.icmp"(%146, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %152 = "llvm.bitcast"(%151) : (vector<8xi1>) -> i8
  %153 = "llvm.icmp"(%152, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %154 = "llvm.select"(%150, %153, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %155 = "llvm.icmp"(%147, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %156 = "llvm.bitcast"(%155) : (vector<8xi1>) -> i8
  %157 = "llvm.icmp"(%156, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %158 = "llvm.icmp"(%147, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %159 = "llvm.bitcast"(%158) : (vector<8xi1>) -> i8
  %160 = "llvm.icmp"(%159, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %161 = "llvm.select"(%157, %160, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %162 = "llvm.and"(%154, %161) : (i1, i1) -> i1
  %163 = "llvm.add"(%147, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.and"(%163, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.ashr"(%163, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%165, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.mul"(%166, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.and"(%167, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.add"(%164, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.add"(%169, %166) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.add"(%170, %168) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.icmp"(%171, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %173 = "llvm.bitcast"(%172) : (vector<8xi1>) -> i8
  %174 = "llvm.icmp"(%173, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %175 = "llvm.icmp"(%171, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %176 = "llvm.bitcast"(%175) : (vector<8xi1>) -> i8
  %177 = "llvm.icmp"(%176, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %178 = "llvm.and"(%174, %177) : (i1, i1) -> i1
  %179 = "llvm.and"(%162, %178) : (i1, i1) -> i1
  %180 = "llvm.add"(%147, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.and"(%180, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.ashr"(%180, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.shufflevector"(%182, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.mul"(%183, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.and"(%184, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.add"(%181, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.add"(%186, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.add"(%187, %185) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.icmp"(%188, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %190 = "llvm.bitcast"(%189) : (vector<8xi1>) -> i8
  %191 = "llvm.icmp"(%190, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %192 = "llvm.icmp"(%188, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %193 = "llvm.bitcast"(%192) : (vector<8xi1>) -> i8
  %194 = "llvm.icmp"(%193, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %195 = "llvm.and"(%191, %194) : (i1, i1) -> i1
  %196 = "llvm.and"(%195, %179) : (i1, i1) -> i1
  "llvm.cond_br"(%196, %21)[^bb7, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb6
  "llvm.intr.lifetime.start"(%51) : (!llvm.ptr) -> ()
  %197 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %198 = "llvm.call"(%197, %arg2, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %199 = "llvm.call"(%198, %arg3, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %200 = "llvm.call"(%199, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %201 = "llvm.call"(%200, %51) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %202 = "llvm.call"(%51, %51) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %203 = "llvm.call"(%51, %49, %52, %50) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify_equation, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %204 = "llvm.icmp"(%203, %28) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %205 = "llvm.select"(%204, %0, %28) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%51) : (!llvm.ptr) -> ()
  "llvm.br"(%205)[^bb8] : (i32) -> ()
^bb8(%206: i32):  // 4 preds: ^bb4, ^bb5, ^bb6, ^bb7
  "llvm.intr.lifetime.end"(%50) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%49) : (!llvm.ptr) -> ()
  "llvm.br"(%206)[^bb9] : (i32) -> ()
^bb9(%207: i32):  // 3 preds: ^bb1, ^bb2, ^bb8
  "llvm.return"(%207) : (i32) -> ()
}) : () -> ()

    with
      @fd_ed25519_point_frombytes_2x := Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_2x,
      @fd_sha512_init := Firedancer.Lane.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.Lane.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_verify_equation := Firedancer.Lane.Mlir.fd_ed25519_verify_equation

end

end Firedancer.Lane.Mlir


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

noncomputable mlir_def fd_ed25519_verify_batch_single_msg := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.zeroext}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, i8)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify_batch_single_msg", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: i8):
  %0 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 4294967264 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 4294967232 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = dense<[3034496493606, 7251660506358, 8531477514791, 3751700492266, 152656122684, 51415276304, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[5761277761479, 1544430418697, 264613410264, 5044390432789, 8643434802371, 1048094254319, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %11 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = -17 : i8}> : () -> i8
  %21 = "llvm.mlir.constant"() <{value = -16 : i8}> : () -> i8
  %22 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %28 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %29 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %30 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %34 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %35 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %36 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %37 = "llvm.mlir.poison"() : () -> i64
  %38 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %37, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %24, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %37, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %37, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%38, %24, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %37, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %37, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %37, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.alloca"(%19) <{alignment = 64 : i64, elem_type = !llvm.array<16 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %56 = "llvm.alloca"(%19) <{alignment = 64 : i64, elem_type = !llvm.array<16 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %57 = "llvm.alloca"(%19) <{alignment = 16 : i64, elem_type = !llvm.array<512 x i8>}> : (i32) -> !llvm.ptr
  %58 = "llvm.alloca"(%19) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %59 = "llvm.add"(%arg5, %20) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %60 = "llvm.icmp"(%59, %21) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%60, %22)[^bb14, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%55) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%56) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%57) : (!llvm.ptr) -> ()
  %61 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %62 = "llvm.zext"(%arg5) <{nonNeg}> : (i8) -> i64
  "llvm.br"(%24)[^bb3] : (i64) -> ()
^bb2:  // pred: ^bb10
  %63 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %64 = "llvm.zext"(%arg5) <{nonNeg}> : (i8) -> i64
  "llvm.br"(%24)[^bb12] : (i64) -> ()
^bb3(%65: i64):  // 2 preds: ^bb1, ^bb10
  %66 = "llvm.shl"(%65, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %67 = "llvm.getelementptr"(%arg2, %66) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %68 = "llvm.getelementptr"(%61, %66) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %69 = "llvm.shl"(%65, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %70 = "llvm.getelementptr"(%arg3, %69) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %71 = "llvm.getelementptr"(%68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %72 = "llvm.load"(%71) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %73 = "llvm.icmp"(%72, %27) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%73)[^bb6, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %74 = "llvm.icmp"(%72, %28) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%74, %22)[^bb5, ^bb13] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  %75 = "llvm.load"(%68) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %76 = "llvm.getelementptr"(%68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %77 = "llvm.load"(%76) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %78 = "llvm.getelementptr"(%68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %79 = "llvm.load"(%78) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %80 = "llvm.getelementptr"(%68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %81 = "llvm.load"(%80) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %82 = "llvm.call_intrinsic"(%29, %75, %30) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %83 = "llvm.extractvalue"(%82) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %84 = "llvm.call_intrinsic"(%83, %77, %31) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %85 = "llvm.extractvalue"(%84) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %86 = "llvm.call_intrinsic"(%85, %79, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %87 = "llvm.extractvalue"(%86) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %88 = "llvm.call_intrinsic"(%87, %81, %32) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %89 = "llvm.extractvalue"(%88) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %90 = "llvm.icmp"(%89, %33) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%90, %22)[^bb13, ^bb6] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb5
  %91 = "llvm.getelementptr"(%56, %65) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %92 = "llvm.getelementptr"(%55, %65) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %93 = "llvm.call"(%91, %70, %92, %67) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %94 = "llvm.icmp"(%93, %34) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%94)[^bb8, ^bb7] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %95 = "llvm.icmp"(%93, %22) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %96 = "llvm.select"(%95, %35, %22) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%96)[^bb13] : (i32) -> ()
^bb8:  // pred: ^bb6
  %97 = "llvm.load"(%91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %98 = "llvm.getelementptr"(%91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %99 = "llvm.load"(%98) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %100 = "llvm.getelementptr"(%91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %101 = "llvm.load"(%100) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %102 = "llvm.shufflevector"(%97, %99) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.shufflevector"(%97, %99) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.insertelement"(%101, %24, %36) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %105 = "llvm.shufflevector"(%101, %46) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.shufflevector"(%102, %104) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.shufflevector"(%103, %105) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.icmp"(%106, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %109 = "llvm.bitcast"(%108) : (vector<8xi1>) -> i8
  %110 = "llvm.icmp"(%109, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %111 = "llvm.icmp"(%106, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %112 = "llvm.bitcast"(%111) : (vector<8xi1>) -> i8
  %113 = "llvm.icmp"(%112, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %114 = "llvm.select"(%110, %113, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %115 = "llvm.icmp"(%107, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %116 = "llvm.bitcast"(%115) : (vector<8xi1>) -> i8
  %117 = "llvm.icmp"(%116, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %118 = "llvm.icmp"(%107, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %119 = "llvm.bitcast"(%118) : (vector<8xi1>) -> i8
  %120 = "llvm.icmp"(%119, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %121 = "llvm.select"(%117, %120, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %122 = "llvm.and"(%114, %121) : (i1, i1) -> i1
  %123 = "llvm.add"(%107, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.and"(%123, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.ashr"(%123, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shufflevector"(%125, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.mul"(%126, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.and"(%127, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.add"(%124, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.add"(%129, %126) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.add"(%130, %128) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.icmp"(%131, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %133 = "llvm.bitcast"(%132) : (vector<8xi1>) -> i8
  %134 = "llvm.icmp"(%133, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %135 = "llvm.icmp"(%131, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %136 = "llvm.bitcast"(%135) : (vector<8xi1>) -> i8
  %137 = "llvm.icmp"(%136, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %138 = "llvm.and"(%134, %137) : (i1, i1) -> i1
  %139 = "llvm.and"(%122, %138) : (i1, i1) -> i1
  %140 = "llvm.add"(%107, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.and"(%140, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.ashr"(%140, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.shufflevector"(%142, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.mul"(%143, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.and"(%144, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.add"(%141, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.add"(%146, %143) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.add"(%147, %145) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.icmp"(%148, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %150 = "llvm.bitcast"(%149) : (vector<8xi1>) -> i8
  %151 = "llvm.icmp"(%150, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %152 = "llvm.icmp"(%148, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %153 = "llvm.bitcast"(%152) : (vector<8xi1>) -> i8
  %154 = "llvm.icmp"(%153, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %155 = "llvm.and"(%151, %154) : (i1, i1) -> i1
  %156 = "llvm.and"(%155, %139) : (i1, i1) -> i1
  "llvm.cond_br"(%156, %35)[^bb9, ^bb13] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb8
  %157 = "llvm.load"(%92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %158 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %159 = "llvm.load"(%158) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %160 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %161 = "llvm.load"(%160) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %162 = "llvm.shufflevector"(%157, %159) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.shufflevector"(%157, %159) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.insertelement"(%161, %24, %36) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %165 = "llvm.shufflevector"(%161, %46) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%162, %164) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%163, %165) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.icmp"(%166, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %169 = "llvm.bitcast"(%168) : (vector<8xi1>) -> i8
  %170 = "llvm.icmp"(%169, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %171 = "llvm.icmp"(%166, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %172 = "llvm.bitcast"(%171) : (vector<8xi1>) -> i8
  %173 = "llvm.icmp"(%172, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %174 = "llvm.select"(%170, %173, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %175 = "llvm.icmp"(%167, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %176 = "llvm.bitcast"(%175) : (vector<8xi1>) -> i8
  %177 = "llvm.icmp"(%176, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %178 = "llvm.icmp"(%167, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %179 = "llvm.bitcast"(%178) : (vector<8xi1>) -> i8
  %180 = "llvm.icmp"(%179, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %181 = "llvm.select"(%177, %180, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %182 = "llvm.and"(%174, %181) : (i1, i1) -> i1
  %183 = "llvm.add"(%167, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.and"(%183, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.ashr"(%183, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.shufflevector"(%185, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.mul"(%186, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.and"(%187, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.add"(%184, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.add"(%189, %186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.add"(%190, %188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.icmp"(%191, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %193 = "llvm.bitcast"(%192) : (vector<8xi1>) -> i8
  %194 = "llvm.icmp"(%193, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %195 = "llvm.icmp"(%191, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %196 = "llvm.bitcast"(%195) : (vector<8xi1>) -> i8
  %197 = "llvm.icmp"(%196, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %198 = "llvm.and"(%194, %197) : (i1, i1) -> i1
  %199 = "llvm.and"(%182, %198) : (i1, i1) -> i1
  %200 = "llvm.add"(%167, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.and"(%200, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.ashr"(%200, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shufflevector"(%202, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.mul"(%203, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.and"(%204, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.add"(%201, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%206, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.add"(%207, %205) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.icmp"(%208, %12) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %210 = "llvm.bitcast"(%209) : (vector<8xi1>) -> i8
  %211 = "llvm.icmp"(%210, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %212 = "llvm.icmp"(%208, %11) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %213 = "llvm.bitcast"(%212) : (vector<8xi1>) -> i8
  %214 = "llvm.icmp"(%213, %33) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %215 = "llvm.and"(%211, %214) : (i1, i1) -> i1
  %216 = "llvm.and"(%215, %199) : (i1, i1) -> i1
  "llvm.cond_br"(%216, %22)[^bb10, ^bb13] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb10:  // pred: ^bb9
  "llvm.intr.lifetime.start"(%58) : (!llvm.ptr) -> ()
  %217 = "llvm.getelementptr"(%arg4, %65) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %218 = "llvm.load"(%217) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %219 = "llvm.call"(%218) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %220 = "llvm.call"(%219, %67, %23) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %221 = "llvm.call"(%220, %70, %23) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %222 = "llvm.call"(%221, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %223 = "llvm.call"(%222, %58) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %224 = "llvm.getelementptr"(%57, %69) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %225 = "llvm.call"(%224, %58) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%58) : (!llvm.ptr) -> ()
  %226 = "llvm.add"(%65, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %227 = "llvm.icmp"(%226, %62) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%227, %226)[^bb2, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb11:  // pred: ^bb12
  %228 = "llvm.add"(%230, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %229 = "llvm.icmp"(%228, %64) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%229, %34, %228)[^bb13, ^bb12] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i64) -> ()
^bb12(%230: i64):  // 2 preds: ^bb2, ^bb11
  %231 = "llvm.shl"(%230, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %232 = "llvm.and"(%231, %2) : (i64, i64) -> i64
  %233 = "llvm.getelementptr"(%63, %232) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %234 = "llvm.shl"(%230, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %235 = "llvm.and"(%234, %1) : (i64, i64) -> i64
  %236 = "llvm.getelementptr"(%57, %235) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %237 = "llvm.getelementptr"(%56, %230) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %238 = "llvm.getelementptr"(%55, %230) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %239 = "llvm.call"(%236, %237, %233, %238) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify_equation, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %240 = "llvm.icmp"(%239, %34) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%240, %0)[^bb13, ^bb11] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb13(%241: i32):  // 7 preds: ^bb4, ^bb5, ^bb7, ^bb8, ^bb9, ^bb11, ^bb12
  "llvm.intr.lifetime.end"(%57) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%56) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%55) : (!llvm.ptr) -> ()
  "llvm.br"(%241)[^bb14] : (i32) -> ()
^bb14(%242: i32):  // 2 preds: ^bb0, ^bb13
  "llvm.return"(%242) : (i32) -> ()
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

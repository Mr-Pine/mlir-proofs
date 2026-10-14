
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_hash
public import Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_1x
public import Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Lane.Mlir.fd_ed25519_point_decode_init
public import Firedancer.Lane.Mlir.fd_sha512_init
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_fini
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode
public import Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini
public import Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1
public import Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Lane.Mlir.fd_sha512_init
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_fini
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_ed25519_point_neg
public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base
public import Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1
public import Firedancer.Lane.Mlir.cache_admit

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def verify_one := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "verify_one", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
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
  %28 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 24576 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 6144 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 512 : i64}> : () -> i64
  %36 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %37 = "llvm.mlir.poison"() : () -> i64
  %38 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %37, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %25, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %37, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %37, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%38, %25, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %37, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %37, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %37, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %56 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %57 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_r43x6_ge_decode", (vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64, i64, i32, array<44 x i8>)>>}> : (i32) -> !llvm.ptr
  %58 = "llvm.alloca"(%17) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %59 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %60 = "llvm.alloca"(%17) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %61 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %62 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %64 = "llvm.load"(%63) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %65 = "llvm.icmp"(%64, %19) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%65)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %66 = "llvm.icmp"(%64, %20) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%66, %21)[^bb2, ^bb29] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %67 = "llvm.load"(%62) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %68 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %69 = "llvm.load"(%68) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %70 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %71 = "llvm.load"(%70) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %72 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %73 = "llvm.load"(%72) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %74 = "llvm.call_intrinsic"(%22, %67, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %75 = "llvm.extractvalue"(%74) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %76 = "llvm.call_intrinsic"(%75, %69, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %77 = "llvm.extractvalue"(%76) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %78 = "llvm.call_intrinsic"(%77, %71, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %79 = "llvm.extractvalue"(%78) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %80 = "llvm.call_intrinsic"(%79, %73, %26) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %81 = "llvm.extractvalue"(%80) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %82 = "llvm.icmp"(%81, %27) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%82, %21)[^bb29, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb3:  // 2 preds: ^bb0, ^bb2
  %83 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %84 = "llvm.load"(%83) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 24>]}> : (!llvm.ptr) -> i64
  %85 = "llvm.call"(%84, %arg3, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_hash, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, !llvm.ptr, i64) -> i64
  %86 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %87 = "llvm.load"(%86) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 8>]}> : (!llvm.ptr) -> i64
  %88 = "llvm.add"(%87, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %89 = "llvm.and"(%88, %85) : (i64, i64) -> i64
  %90 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %91 = "llvm.load"(%90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 72>]}> : (!llvm.ptr) -> !llvm.ptr
  %92 = "llvm.getelementptr"(%91, %89) <{elem_type = !llvm.array<256 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %93 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %94 = "llvm.load"(%93) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 40>]}> : (!llvm.ptr) -> i64
  %95 = "llvm.add"(%94, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%95, %93) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 40>]}> : (i64, !llvm.ptr) -> ()
  %96 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %98 = "llvm.icmp"(%97, %25) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%98)[^bb5, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %99 = "llvm.load"(%92) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %100 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %101 = "llvm.icmp"(%99, %100) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %102 = "llvm.zext"(%101) : (i1) -> i32
  %103 = "llvm.icmp"(%102, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%103, %25)[^bb12, ^bb5] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb5:  // 2 preds: ^bb3, ^bb4
  %104 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  %105 = "llvm.load"(%104) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %106 = "llvm.icmp"(%105, %25) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%106)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %107 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %108 = "llvm.load"(%107) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %109 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %110 = "llvm.icmp"(%108, %109) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %111 = "llvm.zext"(%110) : (i1) -> i32
  %112 = "llvm.icmp"(%111, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%112, %29)[^bb12, ^bb7] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // 2 preds: ^bb5, ^bb6
  %113 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  %114 = "llvm.load"(%113) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %115 = "llvm.icmp"(%114, %25) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%115)[^bb9, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %116 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %117 = "llvm.load"(%116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %118 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %119 = "llvm.icmp"(%117, %118) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %120 = "llvm.zext"(%119) : (i1) -> i32
  %121 = "llvm.icmp"(%120, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%121, %31)[^bb12, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb9:  // 2 preds: ^bb7, ^bb8
  %122 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  %123 = "llvm.load"(%122) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %124 = "llvm.icmp"(%123, %25) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%124)[^bb11, ^bb10] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %125 = "llvm.getelementptr"(%92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %126 = "llvm.load"(%125) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %127 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %128 = "llvm.icmp"(%126, %127) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %129 = "llvm.zext"(%128) : (i1) -> i32
  %130 = "llvm.icmp"(%129, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%130, %32)[^bb12, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb11:  // 2 preds: ^bb9, ^bb10
  %131 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %132 = "llvm.load"(%131) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 56>]}> : (!llvm.ptr) -> i64
  %133 = "llvm.add"(%132, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%133, %131) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 56>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%55) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%56) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb12(%134: i64):  // 4 preds: ^bb4, ^bb6, ^bb8, ^bb10
  %135 = "llvm.getelementptr"(%96, %134) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%95, %135) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %136 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %137 = "llvm.load"(%136) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 48>]}> : (!llvm.ptr) -> i64
  %138 = "llvm.add"(%137, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%138, %136) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 48>]}> : (i64, !llvm.ptr) -> ()
  %139 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %140 = "llvm.load"(%139) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 88>]}> : (!llvm.ptr) -> !llvm.ptr
  %141 = "llvm.mul"(%89, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %142 = "llvm.getelementptr"(%140, %141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %143 = "llvm.mul"(%134, %34) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %144 = "llvm.getelementptr"(%142, %143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.prefetch"(%144) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %145 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%145) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %146 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%146) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %147 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%147) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %148 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%148) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %149 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%149) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %150 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%150) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %151 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%151) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %152 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%152) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %153 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%153) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %154 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%154) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %155 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%155) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %156 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%156) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %157 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%157) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %158 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%158) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %159 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%159) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %160 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%160) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %161 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%161) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %162 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%162) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %163 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%163) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %164 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%164) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %165 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1344>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%165) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %166 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1408>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%166) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %167 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1472>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%167) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %168 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1536>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%168) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %169 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1600>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%169) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %170 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1664>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%170) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %171 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1728>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%171) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %172 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1792>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%172) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %173 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1856>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%173) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %174 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1920>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%174) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %175 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1984>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%175) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %176 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2048>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%176) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %177 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%177) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %178 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2176>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%178) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %179 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2240>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%179) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %180 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2304>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%180) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %181 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2368>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%181) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %182 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2432>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%182) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %183 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2496>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%183) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %184 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2560>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%184) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %185 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2624>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%185) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %186 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2688>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%186) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %187 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2752>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%187) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %188 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2816>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%188) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %189 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2880>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%189) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %190 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2944>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%190) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %191 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3008>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%191) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %192 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3072>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%192) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %193 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3136>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%193) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %194 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3200>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%194) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %195 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3264>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%195) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %196 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3328>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%196) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %197 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3392>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%197) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %198 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3456>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%198) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %199 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3520>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%199) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %200 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3584>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%200) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %201 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3648>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%201) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %202 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3712>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%202) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %203 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3776>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%203) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %204 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3840>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%204) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %205 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3904>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%205) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %206 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3968>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%206) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %207 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4032>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%207) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %208 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4096>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%208) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %209 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%209) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %210 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%210) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %211 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%211) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %212 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4352>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%212) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %213 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4416>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%213) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %214 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%214) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %215 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4544>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%215) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %216 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4608>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%216) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %217 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4672>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%217) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %218 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4736>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%218) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %219 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4800>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%219) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %220 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4864>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%220) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %221 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4928>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%221) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %222 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4992>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%222) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %223 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5056>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%223) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %224 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%224) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %225 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5184>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%225) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %226 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5248>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%226) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %227 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5312>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%227) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %228 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5376>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%228) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %229 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5440>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%229) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %230 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5504>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%230) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %231 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5568>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%231) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %232 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5632>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%232) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %233 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5696>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%233) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %234 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5760>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%234) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %235 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5824>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%235) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %236 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5888>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%236) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %237 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5952>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%237) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %238 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6016>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%238) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  %239 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6080>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.prefetch"(%239) <{cache = 1 : i32, hint = 3 : i32, rw = 0 : i32}> : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%55) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%56) : (!llvm.ptr) -> ()
  %240 = "llvm.icmp"(%140, %36) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%240)[^bb20, ^bb13] <{branch_weights = array<i32: 1073204, 2146410444>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %241 = "llvm.load"(%arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %242 = "llvm.icmp"(%241, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%242)[^bb14, ^bb16] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %243 = "llvm.call"(%56, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_1x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %244 = "llvm.icmp"(%243, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%244, %21)[^bb15, ^bb28] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb15:  // pred: ^bb14
  %245 = "llvm.call"(%56) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %246 = "llvm.sub"(%30, %245) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%246)[^bb28] : (i32) -> ()
^bb16:  // pred: ^bb13
  "llvm.intr.lifetime.start"(%57) : (!llvm.ptr) -> ()
  "llvm.call"(%57, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_decode_init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%58) : (!llvm.ptr) -> ()
  %247 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %248 = "llvm.call"(%247, %arg2, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %249 = "llvm.call"(%248, %arg3, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %250 = "llvm.call"(%249, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %251 = "llvm.call"(%250, %58) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %252 = "llvm.call"(%58, %58) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%59) : (!llvm.ptr) -> ()
  %253 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.call"(%59, %58, %144, %62, %253, %57) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base_split_decode, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %255 = "llvm.call"(%56, %57) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_decode_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %256 = "llvm.icmp"(%255, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%256, %21)[^bb17, ^bb19] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb17:  // pred: ^bb16
  %257 = "llvm.load"(%56) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %258 = "llvm.getelementptr"(%56) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.load"(%258) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %260 = "llvm.getelementptr"(%56) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %261 = "llvm.load"(%260) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %262 = "llvm.shufflevector"(%257, %259) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.shufflevector"(%257, %259) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.insertelement"(%261, %25, %29) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %265 = "llvm.shufflevector"(%261, %46) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%262, %264) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%263, %265) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.icmp"(%266, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %269 = "llvm.bitcast"(%268) : (vector<8xi1>) -> i8
  %270 = "llvm.icmp"(%269, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %271 = "llvm.icmp"(%266, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %272 = "llvm.bitcast"(%271) : (vector<8xi1>) -> i8
  %273 = "llvm.icmp"(%272, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %274 = "llvm.select"(%270, %273, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %275 = "llvm.icmp"(%267, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %276 = "llvm.bitcast"(%275) : (vector<8xi1>) -> i8
  %277 = "llvm.icmp"(%276, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %278 = "llvm.icmp"(%267, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %279 = "llvm.bitcast"(%278) : (vector<8xi1>) -> i8
  %280 = "llvm.icmp"(%279, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %281 = "llvm.select"(%277, %280, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %282 = "llvm.and"(%274, %281) : (i1, i1) -> i1
  %283 = "llvm.add"(%267, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.and"(%283, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.ashr"(%283, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.shufflevector"(%285, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.mul"(%286, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.and"(%287, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.add"(%284, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.add"(%289, %286) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.add"(%290, %288) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.icmp"(%291, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %293 = "llvm.bitcast"(%292) : (vector<8xi1>) -> i8
  %294 = "llvm.icmp"(%293, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %295 = "llvm.icmp"(%291, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %296 = "llvm.bitcast"(%295) : (vector<8xi1>) -> i8
  %297 = "llvm.icmp"(%296, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %298 = "llvm.and"(%294, %297) : (i1, i1) -> i1
  %299 = "llvm.and"(%282, %298) : (i1, i1) -> i1
  %300 = "llvm.add"(%267, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.and"(%300, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.ashr"(%300, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%302, %54) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.mul"(%303, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.and"(%304, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.add"(%301, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.add"(%306, %303) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.add"(%307, %305) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.icmp"(%308, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %310 = "llvm.bitcast"(%309) : (vector<8xi1>) -> i8
  %311 = "llvm.icmp"(%310, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %312 = "llvm.icmp"(%308, %9) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %313 = "llvm.bitcast"(%312) : (vector<8xi1>) -> i8
  %314 = "llvm.icmp"(%313, %27) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %315 = "llvm.and"(%311, %314) : (i1, i1) -> i1
  %316 = "llvm.and"(%315, %299) : (i1, i1) -> i1
  "llvm.cond_br"(%316, %21)[^bb18, ^bb19] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb18:  // pred: ^bb17
  %317 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %318 = "llvm.load"(%317) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 32>]}> : (!llvm.ptr) -> i64
  %319 = "llvm.add"(%318, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %320 = "llvm.intr.umin"(%319, %35) : (i64, i64) -> i64
  "llvm.store"(%320, %317) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 32>]}> : (i64, !llvm.ptr) -> ()
  %321 = "llvm.call"(%59, %56) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.store"(%321, %arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%30)[^bb19] : (i32) -> ()
^bb19(%322: i32):  // 3 preds: ^bb16, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%59) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%58) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%57) : (!llvm.ptr) -> ()
  "llvm.br"(%322)[^bb28] : (i32) -> ()
^bb20:  // 2 preds: ^bb11, ^bb12
  %323 = "llvm.call"(%55, %arg3, %56, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %324 = "llvm.icmp"(%323, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%324)[^bb22, ^bb21] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %325 = "llvm.icmp"(%323, %21) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %326 = "llvm.select"(%325, %0, %21) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%326)[^bb28] : (i32) -> ()
^bb22:  // pred: ^bb20
  %327 = "llvm.call"(%55) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %328 = "llvm.icmp"(%327, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%328, %0)[^bb23, ^bb28] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb23:  // pred: ^bb22
  %329 = "llvm.call"(%56) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %330 = "llvm.icmp"(%329, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%330, %21)[^bb24, ^bb28] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb24:  // pred: ^bb23
  %331 = "llvm.load"(%arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %332 = "llvm.icmp"(%331, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%332, %30)[^bb28, ^bb25] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb25:  // pred: ^bb24
  %333 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %334 = "llvm.load"(%333) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 32>]}> : (!llvm.ptr) -> i64
  %335 = "llvm.add"(%334, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %336 = "llvm.intr.umin"(%335, %35) : (i64, i64) -> i64
  "llvm.store"(%336, %333) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 32>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%60) : (!llvm.ptr) -> ()
  %337 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %338 = "llvm.call"(%337, %arg2, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %339 = "llvm.call"(%338, %arg3, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %340 = "llvm.call"(%339, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %341 = "llvm.call"(%340, %60) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %342 = "llvm.call"(%60, %60) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%61) : (!llvm.ptr) -> ()
  %343 = "llvm.call"(%55, %55) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %344 = "llvm.call"(%61, %60, %55, %62) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %345 = "llvm.call"(%61, %56) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.store"(%345, %arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %346 = "llvm.icmp"(%345, %30) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%346)[^bb27, ^bb26] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb26:  // pred: ^bb25
  "llvm.call"(%arg5, %arg3, %85, %55) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @cache_admit, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb27] : () -> ()
^bb27:  // 2 preds: ^bb25, ^bb26
  "llvm.intr.lifetime.end"(%61) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%60) : (!llvm.ptr) -> ()
  "llvm.br"(%30)[^bb28] : (i32) -> ()
^bb28(%347: i32):  // 8 preds: ^bb14, ^bb15, ^bb19, ^bb21, ^bb22, ^bb23, ^bb24, ^bb27
  "llvm.intr.lifetime.end"(%56) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%55) : (!llvm.ptr) -> ()
  "llvm.br"(%347)[^bb29] : (i32) -> ()
^bb29(%348: i32):  // 3 preds: ^bb1, ^bb2, ^bb28
  "llvm.return"(%348) : (i32) -> ()
}) : () -> ()

    with
      @fd_hash := Firedancer.Lane.Mlir.fd_hash,
      @fd_ed25519_point_frombytes_1x := Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_1x,
      @fd_ed25519_affine_is_small_order := Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order,
      @fd_ed25519_point_decode_init := Firedancer.Lane.Mlir.fd_ed25519_point_decode_init,
      @fd_sha512_init := Firedancer.Lane.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.Lane.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_double_scalar_mul_base_split_decode := Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base_split_decode,
      @fd_ed25519_point_decode_fini := Firedancer.Lane.Mlir.fd_ed25519_point_decode_fini,
      @fd_ed25519_point_eq_z1 := Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1,
      @fd_ed25519_point_frombytes_2x := Firedancer.Lane.Mlir.fd_ed25519_point_frombytes_2x,
      @fd_ed25519_affine_is_small_order := Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order,
      @fd_ed25519_affine_is_small_order := Firedancer.Lane.Mlir.fd_ed25519_affine_is_small_order,
      @fd_sha512_init := Firedancer.Lane.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.Lane.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_point_neg := Firedancer.Lane.Mlir.fd_ed25519_point_neg,
      @fd_ed25519_double_scalar_mul_base := Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base,
      @fd_ed25519_point_eq_z1 := Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1,
      @cache_admit := Firedancer.Lane.Mlir.cache_admit

end

end Firedancer.Lane.Mlir

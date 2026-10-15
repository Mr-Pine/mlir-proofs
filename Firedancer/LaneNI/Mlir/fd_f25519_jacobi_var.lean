
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var
public import Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_jacobi_var := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 2>}], sym_name = "fd_f25519_jacobi_var", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = dense<[4611686018427387885, 4611686018427387903, 4611686018427387903, 4611686018427387903]> : vector<4xi64>}> : () -> vector<4xi64>
  %3 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 4611686018427387885 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %17 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %20 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  %21 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2, %17) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %22 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3, %22) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  %23 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%24, %18) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %25 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %26 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %27 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.store"(%27, %25) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  "llvm.store"(%4, %19) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%5, %4, %6, %7)[^bb1] : (i64, i32, i64, i32) -> ()
^bb1(%28: i64, %29: i32, %30: i64, %31: i32):  // 2 preds: ^bb0, ^bb13
  "llvm.intr.lifetime.start"(%20) : (!llvm.ptr) -> ()
  %32 = "llvm.load"(%21) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %33 = "llvm.shl"(%32, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %34 = "llvm.or"(%33, %28) : (i64, i64) -> i64
  %35 = "llvm.load"(%18) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %36 = "llvm.load"(%23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %37 = "llvm.shl"(%36, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %38 = "llvm.or"(%37, %35) : (i64, i64) -> i64
  %39 = "llvm.call"(%30, %34, %38, %20, %19) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_posdivsteps_62_var, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (i64, i64, i64, !llvm.ptr, !llvm.ptr) -> i64
  "llvm.call"(%31, %17, %18, %20) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_update_fg_62_var, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %40 = "llvm.load"(%17) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %41 = "llvm.icmp"(%40, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %42 = "llvm.icmp"(%31, %0) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%41)[^bb2, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  "llvm.cond_br"(%42)[^bb3, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %43 = "llvm.zext"(%31) <{nonNeg}> : (i32) -> i64
  %44 = "llvm.add"(%43, %6) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %45 = "llvm.icmp"(%31, %10) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%45, %9, %11)[^bb7, ^bb4] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
^bb4:  // pred: ^bb3
  %46 = "llvm.and"(%44, %12) : (i64, i64) -> i64
  %47 = "llvm.or"(%46, %9) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%11, %13)[^bb5] : (i64, vector<8xi64>) -> ()
^bb5(%48: i64, %49: vector<8xi64>):  // 2 preds: ^bb4, ^bb5
  %50 = "llvm.getelementptr"(%17, %48) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %51 = "llvm.getelementptr"(%50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %52 = "llvm.load"(%51) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %53 = "llvm.or"(%52, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %54 = "llvm.add"(%48, %1) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %55 = "llvm.icmp"(%54, %46) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%55, %54, %53)[^bb6, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<8xi64>) -> ()
^bb6:  // pred: ^bb5
  %56 = "llvm.intr.vector.reduce.or"(%53) : (vector<8xi64>) -> i64
  %57 = "llvm.icmp"(%44, %46) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%57, %56, %47, %56)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb7(%58: i64, %59: i64):  // 2 preds: ^bb3, ^bb6
  "llvm.br"(%58, %59)[^bb9] : (i64, i64) -> ()
^bb8(%60: i64):  // 2 preds: ^bb6, ^bb9
  %61 = "llvm.icmp"(%60, %11) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%61)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9(%62: i64, %63: i64):  // 2 preds: ^bb7, ^bb9
  %64 = "llvm.getelementptr"(%17, %62) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %65 = "llvm.load"(%64) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %66 = "llvm.or"(%65, %63) : (i64, i64) -> i64
  %67 = "llvm.add"(%62, %9) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %68 = "llvm.icmp"(%67, %43) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%68, %66, %67, %66)[^bb8, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb10:  // pred: ^bb1
  "llvm.cond_br"(%42, %31)[^bb11, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // 2 preds: ^bb8, ^bb10
  %69 = "llvm.add"(%31, %14) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %70 = "llvm.zext"(%69) <{nonNeg}> : (i32) -> i64
  %71 = "llvm.getelementptr"(%17, %70) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %72 = "llvm.load"(%71) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %73 = "llvm.getelementptr"(%18, %70) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %74 = "llvm.load"(%73) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %75 = "llvm.or"(%74, %72) : (i64, i64) -> i64
  %76 = "llvm.icmp"(%75, %11) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %77 = "llvm.select"(%76, %69, %31) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%77)[^bb13] : (i32) -> ()
^bb12:  // 2 preds: ^bb2, ^bb8
  %78 = "llvm.load"(%19) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %79 = "llvm.shl"(%78, %0) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %80 = "llvm.and"(%79, %16) : (i32, i32) -> i32
  %81 = "llvm.sub"(%0, %80) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.br"(%81)[^bb14] : (i32) -> ()
^bb13(%82: i32):  // 2 preds: ^bb10, ^bb11
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  %83 = "llvm.add"(%29, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %84 = "llvm.icmp"(%83, %15) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%84, %4, %40, %83, %39, %82)[^bb14, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 4>}> : (i1, i32, i64, i32, i64, i32) -> ()
^bb14(%85: i32):  // 2 preds: ^bb12, ^bb13
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.return"(%85) : (i32) -> ()
}) : () -> ()

    with
      @fd_f25519_posdivsteps_62_var := Firedancer.LaneNI.Mlir.fd_f25519_posdivsteps_62_var,
      @fd_f25519_update_fg_62_var := Firedancer.LaneNI.Mlir.fd_f25519_update_fg_62_var

end

end Firedancer.LaneNI.Mlir

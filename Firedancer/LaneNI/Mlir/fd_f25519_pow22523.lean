
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_pow22523 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_pow22523", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %6 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %7 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%6) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  %9 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %10 = "llvm.call"(%6, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %11 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %12 = "llvm.call"(%7, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %13 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %14 = "llvm.call"(%7, %13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %15 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %16 = "llvm.call"(%7, %9, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %17 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %18 = "llvm.call"(%6, %11, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %19 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %20 = "llvm.call"(%6, %19) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %21 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %22 = "llvm.call"(%6, %17, %21) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %23 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %24 = "llvm.call"(%7, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb2] : (i32) -> ()
^bb1:  // pred: ^bb2
  %25 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %26 = "llvm.call"(%6, %25, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %27 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %28 = "llvm.call"(%7, %27) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb4] : (i32) -> ()
^bb2(%29: i32):  // 2 preds: ^bb0, ^bb2
  %30 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %31 = "llvm.call"(%7, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %32 = "llvm.add"(%29, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %33 = "llvm.icmp"(%32, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%33, %32)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb4
  %34 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %35 = "llvm.call"(%7, %34, %27) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %36 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %37 = "llvm.call"(%8, %36) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb6] : (i32) -> ()
^bb4(%38: i32):  // 2 preds: ^bb1, ^bb4
  %39 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %40 = "llvm.call"(%7, %39) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %41 = "llvm.add"(%38, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %42 = "llvm.icmp"(%41, %2) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%42, %41)[^bb3, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb6
  %43 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %44 = "llvm.call"(%7, %43, %36) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %45 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %46 = "llvm.call"(%7, %45) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb8] : (i32) -> ()
^bb6(%47: i32):  // 2 preds: ^bb3, ^bb6
  %48 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %49 = "llvm.call"(%8, %48) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %50 = "llvm.add"(%47, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %51 = "llvm.icmp"(%50, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%51, %50)[^bb5, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb8
  %52 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %53 = "llvm.call"(%6, %52, %27) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %54 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %55 = "llvm.call"(%7, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb10] : (i32) -> ()
^bb8(%56: i32):  // 2 preds: ^bb5, ^bb8
  %57 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %58 = "llvm.call"(%7, %57) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %59 = "llvm.add"(%56, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %60 = "llvm.icmp"(%59, %2) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%60, %59)[^bb7, ^bb8] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb10
  %61 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %62 = "llvm.call"(%7, %61, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %63 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %64 = "llvm.call"(%8, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb12] : (i32) -> ()
^bb10(%65: i32):  // 2 preds: ^bb7, ^bb10
  %66 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %67 = "llvm.call"(%7, %66) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %68 = "llvm.add"(%65, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %69 = "llvm.icmp"(%68, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%69, %68)[^bb9, ^bb10] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb12
  %70 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %71 = "llvm.call"(%7, %70, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %72 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %73 = "llvm.call"(%7, %72) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb14] : (i32) -> ()
^bb12(%74: i32):  // 2 preds: ^bb9, ^bb12
  %75 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %76 = "llvm.call"(%8, %75) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %77 = "llvm.add"(%74, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %78 = "llvm.icmp"(%77, %5) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%78, %77)[^bb11, ^bb12] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb14
  %79 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %80 = "llvm.call"(%6, %79, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %81 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %82 = "llvm.call"(%6, %81) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %83 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %84 = "llvm.call"(%6, %83) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %85 = "llvm.load"(%6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %86 = "llvm.call"(%arg0, %85, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%6) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb14(%87: i32):  // 2 preds: ^bb11, ^bb14
  %88 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %89 = "llvm.call"(%7, %88) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %90 = "llvm.add"(%87, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %91 = "llvm.icmp"(%90, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%91, %90)[^bb13, ^bb14] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
}) : () -> ()

    with
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60,
      @fd_f25519_mul.61 := Firedancer.LaneNI.Mlir.fd_f25519_mul_61,
      @fd_f25519_sqr.60 := Firedancer.LaneNI.Mlir.fd_f25519_sqr_60

end

end Firedancer.LaneNI.Mlir


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

mlir_def fd_f25519_inv := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_inv", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %7 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  %11 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %12 = "llvm.call"(%7, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %13 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %14 = "llvm.call"(%8, %13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %15 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %16 = "llvm.call"(%8, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %17 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %18 = "llvm.call"(%8, %11, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %19 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %20 = "llvm.call"(%7, %13, %19) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %21 = "llvm.load"(%7) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %22 = "llvm.call"(%9, %21) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %23 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %24 = "llvm.call"(%8, %19, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %25 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %26 = "llvm.call"(%9, %25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb2] : (i32) -> ()
^bb1:  // pred: ^bb2
  %27 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %28 = "llvm.call"(%8, %27, %25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %29 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %30 = "llvm.call"(%9, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb4] : (i32) -> ()
^bb2(%31: i32):  // 2 preds: ^bb0, ^bb2
  %32 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %33 = "llvm.call"(%9, %32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %34 = "llvm.add"(%31, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %35 = "llvm.icmp"(%34, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%35, %34)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb4
  %36 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %37 = "llvm.call"(%9, %36, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %38 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %39 = "llvm.call"(%10, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb6] : (i32) -> ()
^bb4(%40: i32):  // 2 preds: ^bb1, ^bb4
  %41 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %42 = "llvm.call"(%9, %41) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %43 = "llvm.add"(%40, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %44 = "llvm.icmp"(%43, %2) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%44, %43)[^bb3, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb6
  %45 = "llvm.load"(%10) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %46 = "llvm.call"(%9, %45, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%4)[^bb8] : (i32) -> ()
^bb6(%47: i32):  // 2 preds: ^bb3, ^bb6
  %48 = "llvm.load"(%10) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %49 = "llvm.call"(%10, %48) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %50 = "llvm.add"(%47, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %51 = "llvm.icmp"(%50, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%51, %50)[^bb5, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb8
  %52 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %53 = "llvm.call"(%8, %52, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %54 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %55 = "llvm.call"(%9, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb10] : (i32) -> ()
^bb8(%56: i32):  // 2 preds: ^bb5, ^bb8
  %57 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %58 = "llvm.call"(%9, %57) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %59 = "llvm.add"(%56, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %60 = "llvm.icmp"(%59, %2) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%60, %59)[^bb7, ^bb8] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb10
  %61 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %62 = "llvm.call"(%9, %61, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %63 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %64 = "llvm.call"(%10, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb12] : (i32) -> ()
^bb10(%65: i32):  // 2 preds: ^bb7, ^bb10
  %66 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %67 = "llvm.call"(%9, %66) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %68 = "llvm.add"(%65, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %69 = "llvm.icmp"(%68, %5) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%69, %68)[^bb9, ^bb10] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb12
  %70 = "llvm.load"(%10) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %71 = "llvm.call"(%9, %70, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %72 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %73 = "llvm.call"(%9, %72) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb14] : (i32) -> ()
^bb12(%74: i32):  // 2 preds: ^bb9, ^bb12
  %75 = "llvm.load"(%10) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %76 = "llvm.call"(%10, %75) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %77 = "llvm.add"(%74, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %78 = "llvm.icmp"(%77, %6) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%78, %77)[^bb11, ^bb12] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb14
  %79 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %80 = "llvm.call"(%8, %79, %54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %81 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %82 = "llvm.call"(%8, %81) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  "llvm.br"(%0)[^bb16] : (i32) -> ()
^bb14(%83: i32):  // 2 preds: ^bb11, ^bb14
  %84 = "llvm.load"(%9) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %85 = "llvm.call"(%9, %84) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %86 = "llvm.add"(%83, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %87 = "llvm.icmp"(%86, %5) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%87, %86)[^bb13, ^bb14] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb15:  // pred: ^bb16
  %88 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %89 = "llvm.call"(%arg0, %88, %21) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}], callee = @fd_f25519_mul.61, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb16(%90: i32):  // 2 preds: ^bb13, ^bb16
  %91 = "llvm.load"(%8) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %92 = "llvm.call"(%8, %91) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_sqr.60, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %93 = "llvm.add"(%90, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %94 = "llvm.icmp"(%93, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%94, %93)[^bb15, ^bb16] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
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

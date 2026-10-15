
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast_100
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast_100

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_repsqr_mul2 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 101>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, vector<8xi64>, vector<8xi64>, ptr, vector<8xi64>, vector<8xi64>, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_repsqr_mul2", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: vector<8xi64>, %arg2: vector<8xi64>, %arg3: !llvm.ptr, %arg4: vector<8xi64>, %arg5: vector<8xi64>, %arg6: i64):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %6 = "llvm.icmp"(%arg6, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%6, %arg4, %arg1, %arg1, %arg4, %arg6)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb1(%7: vector<8xi64>, %8: vector<8xi64>, %9: i64):  // 2 preds: ^bb0, ^bb1
  %10 = "llvm.call"(%7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast.99, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %11 = "llvm.and"(%10, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %12 = "llvm.lshr"(%10, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %13 = "llvm.shufflevector"(%12, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %14 = "llvm.call_intrinsic"(%11, %4, %13) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %15 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast.99, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %16 = "llvm.and"(%15, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %17 = "llvm.lshr"(%15, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %18 = "llvm.shufflevector"(%17, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %19 = "llvm.call_intrinsic"(%16, %4, %18) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %20 = "llvm.add"(%9, %5) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %21 = "llvm.icmp"(%20, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%21, %19, %14, %14, %19, %20)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb2(%22: vector<8xi64>, %23: vector<8xi64>):  // 2 preds: ^bb0, ^bb1
  %24 = "llvm.call"(%23, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast.100, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %25 = "llvm.and"(%24, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %26 = "llvm.lshr"(%24, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %27 = "llvm.shufflevector"(%26, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %28 = "llvm.call_intrinsic"(%25, %4, %27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %29 = "llvm.call"(%22, %arg5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast.100, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %30 = "llvm.and"(%29, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %31 = "llvm.lshr"(%29, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %32 = "llvm.shufflevector"(%31, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %33 = "llvm.call_intrinsic"(%30, %4, %32) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%28, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%33, %arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_r43x6_sqr_fast.99 := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99,
      @fd_r43x6_sqr_fast.99 := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99,
      @fd_r43x6_mul_fast.100 := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast_100,
      @fd_r43x6_mul_fast.100 := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast_100

end

end Firedancer.LaneNI.Mlir

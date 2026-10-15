
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ulong_min_35
public import Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_multi_scalar_mul := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_multi_scalar_mul", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %4 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%4) : (!llvm.ptr) -> ()
  %5 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %6 = "llvm.icmp"(%arg3, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%6, %1)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb1:  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.end"(%4) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb2(%7: i64):  // 2 preds: ^bb0, ^bb2
  %8 = "llvm.sub"(%arg3, %7) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %9 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_min.35, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %10 = "llvm.shl"(%7, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %11 = "llvm.getelementptr"(%arg1, %10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %12 = "llvm.getelementptr"(%arg2, %7) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %13 = "llvm.call"(%4, %11, %12, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_multi_scalar_mul_with_opts, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %14 = "llvm.call"(%arg0, %arg0, %4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %15 = "llvm.add"(%7, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %16 = "llvm.icmp"(%15, %arg3) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%16, %15)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ulong_min.35 := Firedancer.LaneNI.Mlir.fd_ulong_min_35,
      @fd_ed25519_multi_scalar_mul_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts,
      @fd_ed25519_point_add := Firedancer.LaneNI.Mlir.fd_ed25519_point_add

end

end Firedancer.LaneNI.Mlir

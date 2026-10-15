
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ulong_is_pow2

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_cache_footprint := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, 0, 6543286497>}], sym_name = "fd_ed25519_cache_footprint", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: i64):
  %0 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -1048577 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -1048573 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 134217472 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 172192 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 268435392 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 6144 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 34359738240 : i64}> : () -> i64
  %12 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_is_pow2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %13 = "llvm.icmp"(%12, %0) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %14 = "llvm.add"(%arg0, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %15 = "llvm.icmp"(%14, %2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %16 = "llvm.or"(%15, %13) : (i1, i1) -> i1
  "llvm.cond_br"(%16, %3)[^bb2, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb0
  %17 = "llvm.shl"(%arg0, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %18 = "llvm.and"(%17, %5) : (i64, i64) -> i64
  %19 = "llvm.shl"(%arg0, %6) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %20 = "llvm.add"(%19, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %21 = "llvm.add"(%20, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %22 = "llvm.and"(%21, %8) : (i64, i64) -> i64
  %23 = "llvm.mul"(%arg0, %9) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %24 = "llvm.or"(%23, %10) <{isDisjoint}> : (i64, i64) -> i64
  %25 = "llvm.add"(%24, %22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %26 = "llvm.and"(%25, %11) : (i64, i64) -> i64
  "llvm.br"(%26)[^bb2] : (i64) -> ()
^bb2(%27: i64):  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%27) : (i64) -> ()
}) : () -> ()

    with
      @fd_ulong_is_pow2 := Firedancer.LaneNI.Mlir.fd_ulong_is_pow2

end

end Firedancer.LaneNI.Mlir

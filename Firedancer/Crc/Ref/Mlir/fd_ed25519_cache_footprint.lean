
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.fd_ulong_is_pow2

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_ed25519_cache_footprint := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], function_type = !llvm.func<i64 (i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, 0, 4395630817>}], sym_name = "fd_ed25519_cache_footprint", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: i64):
  %0 = "llvm.mlir.constant"() <{value = -1048577 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = -1048573 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 134217472 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 4128 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 68719476608 : i64}> : () -> i64
  %9 = "llvm.add"(%arg0, %0) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %10 = "llvm.icmp"(%9, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%10, %2)[^bb3, ^bb1] <{branch_weights = array<i32: 4001, 4000000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb0
  %11 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_is_pow2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %12 = "llvm.icmp"(%11, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%12, %2)[^bb3, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  %13 = "llvm.shl"(%arg0, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %14 = "llvm.and"(%13, %5) : (i64, i64) -> i64
  %15 = "llvm.mul"(%arg0, %6) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %16 = "llvm.add"(%15, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %17 = "llvm.add"(%16, %14) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %18 = "llvm.and"(%17, %8) : (i64, i64) -> i64
  "llvm.br"(%18)[^bb3] : (i64) -> ()
^bb3(%19: i64):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%19) : (i64) -> ()
}) : () -> ()

    with
      @fd_ulong_is_pow2 := MLIR.Firedancer.Crc.Ref.fd_ulong_is_pow2

end

end MLIR.Firedancer.Crc.Ref

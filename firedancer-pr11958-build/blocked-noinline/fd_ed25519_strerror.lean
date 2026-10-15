
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_8
public import Firedancer.LaneNI.Mlir.switch_table_fd_ed25519_strerror_rel

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_strerror := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (i32)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_strerror", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: i32):
  %0 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2 = "llvm.mlir.addressof"() <{global_name = @".str.8"}> : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %4 = "llvm.mlir.addressof"() <{global_name = @switch.table.fd_ed25519_strerror.rel}> : () -> !llvm.ptr
  %5 = "llvm.add"(%arg0, %0) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %6 = "llvm.icmp"(%5, %1) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%6, %2)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %7 = "llvm.zext"(%5) <{nonNeg}> : (i32) -> i64
  %8 = "llvm.shl"(%7, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %9 = "llvm.call_intrinsic"(%4, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.load.relative.i64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%9)[^bb2] : (!llvm.ptr) -> ()
^bb2(%10: !llvm.ptr):  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%10) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @.str.8 := Firedancer.LaneNI.Mlir._str_8,
      @switch.table.fd_ed25519_strerror.rel := Firedancer.LaneNI.Mlir.switch_table_fd_ed25519_strerror_rel

end

end Firedancer.LaneNI.Mlir

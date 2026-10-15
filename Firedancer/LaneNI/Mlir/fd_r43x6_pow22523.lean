
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_pow22523 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<8xi64> (vector<8xi64>)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_pow22523", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 100 : i64}> : () -> i64
  %12 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast.99, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %13 = "llvm.and"(%12, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %14 = "llvm.lshr"(%12, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %15 = "llvm.shufflevector"(%14, %2) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %16 = "llvm.call_intrinsic"(%13, %3, %15) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %17 = "llvm.call"(%16, %arg0, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %18 = "llvm.call"(%17, %16, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %19 = "llvm.call"(%18, %17, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %20 = "llvm.call"(%19, %19, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %21 = "llvm.call"(%20, %20, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %22 = "llvm.call"(%21, %21, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %23 = "llvm.call"(%22, %20, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %24 = "llvm.call"(%23, %23, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %25 = "llvm.call"(%24, %24, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %26 = "llvm.call"(%25, %23, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  %27 = "llvm.call"(%26, %arg0, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, i64) -> vector<8xi64>
  "llvm.return"(%27) : (vector<8xi64>) -> ()
}) : () -> ()

    with
      @fd_r43x6_sqr_fast.99 := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul,
      @fd_r43x6_repsqr_mul := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul

end

end Firedancer.LaneNI.Mlir

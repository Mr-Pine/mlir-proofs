
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_lane_normalize

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_lane_is_zero := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 64 : i64, llvm.byval = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, llvm.nocapture, llvm.nofree, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 256>}], sym_name = "fd_ed25519_lane_is_zero", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = 2251799813685229 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %7 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %10 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  "llvm.call"(%10, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 64 : i64, llvm.dead_on_unwind, llvm.noalias, llvm.writable}, {llvm.align = 64 : i64, llvm.byval = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_lane_normalize, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg0, %10, %1) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.br"(%2, %3, %3)[^bb2] : (i64, i32, i32) -> ()
^bb1:  // pred: ^bb2
  %11 = "llvm.or"(%28, %20) : (i32, i32) -> i32
  "llvm.return"(%11) : (i32) -> ()
^bb2(%12: i64, %13: i32, %14: i32):  // 2 preds: ^bb0, ^bb2
  %15 = "llvm.getelementptr"(%arg0, %12) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %16 = "llvm.load"(%15) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %17 = "llvm.icmp"(%16, %4) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %18 = "llvm.bitcast"(%17) : (vector<8xi1>) -> i8
  %19 = "llvm.zext"(%18) : (i8) -> i32
  %20 = "llvm.and"(%14, %19) : (i32, i32) -> i32
  %21 = "llvm.icmp"(%12, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %22 = "llvm.select"(%21, %5, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %23 = "llvm.insertelement"(%7, %22, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %24 = "llvm.shufflevector"(%23, %7) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %25 = "llvm.icmp"(%16, %24) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %26 = "llvm.bitcast"(%25) : (vector<8xi1>) -> i8
  %27 = "llvm.zext"(%26) : (i8) -> i32
  %28 = "llvm.and"(%13, %27) : (i32, i32) -> i32
  %29 = "llvm.add"(%12, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %30 = "llvm.icmp"(%29, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%30, %29, %28, %20)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i32, i32) -> ()
}) : () -> ()

    with
      @fd_ed25519_lane_normalize := Firedancer.LaneNI.Mlir.fd_ed25519_lane_normalize

end

end Firedancer.LaneNI.Mlir

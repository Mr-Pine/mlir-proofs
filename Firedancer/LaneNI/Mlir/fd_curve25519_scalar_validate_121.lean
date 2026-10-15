
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_curve25519_scalar_validate_121 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_curve25519_scalar_validate.121", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %2 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %4 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %9 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %10 = "llvm.load"(%9) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %11 = "llvm.icmp"(%10, %0) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%11, %arg0)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %12 = "llvm.icmp"(%10, %1) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%12, %2)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %13 = "llvm.load"(%arg0) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %14 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %15 = "llvm.load"(%14) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %16 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %17 = "llvm.load"(%16) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %18 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %20 = "llvm.call_intrinsic"(%3, %13, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %21 = "llvm.extractvalue"(%20) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %22 = "llvm.call_intrinsic"(%21, %15, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %23 = "llvm.extractvalue"(%22) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %24 = "llvm.call_intrinsic"(%23, %17, %6) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %25 = "llvm.extractvalue"(%24) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %26 = "llvm.call_intrinsic"(%25, %19, %7) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %27 = "llvm.extractvalue"(%26) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %28 = "llvm.icmp"(%27, %8) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %29 = "llvm.select"(%28, %2, %arg0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%29)[^bb3] : (!llvm.ptr) -> ()
^bb3(%30: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%30) : (!llvm.ptr) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir

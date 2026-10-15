
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_add_table_ref
public import Firedancer.Crc.Ref.Mlir.crc_adx_table_neg
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_add_table_ref

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_add_digit := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i16, 1, 0>, llvm.signext}], dso_local, function_type = !llvm.func<void (ptr, ptr, i16)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_add_digit", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i16):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %2 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
  %3 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %4 = "llvm.mlir.constant"() <{value = 4294967295 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 2147483647 : i64}> : () -> i64
  %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %8 = "llvm.icmp"(%arg2, %1) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%8)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %9 = "llvm.zext"(%arg2) <{nonNeg}> : (i16) -> i64
  %10 = "llvm.add"(%9, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %11 = "llvm.lshr"(%10, %5) : (i64, i64) -> i64
  %12 = "llvm.and"(%11, %6) : (i64, i64) -> i64
  %13 = "llvm.getelementptr"(%arg1, %12) <{elem_type = !llvm.array<128 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%arg0, %arg0, %13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_add_table_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  %14 = "llvm.xor"(%arg2, %2) : (i16, i16) -> i16
  %15 = "llvm.lshr"(%14, %3) : (i16, i16) -> i16
  %16 = "llvm.zext"(%15) <{nonNeg}> : (i16) -> i64
  %17 = "llvm.getelementptr"(%arg1, %16) <{elem_type = !llvm.array<128 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%7, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_table_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %arg0, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_ge_adx_add_table_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @crc_ge_adx_add_table_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_add_table_ref,
      @crc_adx_table_neg := MLIR.Firedancer.Crc.Ref.crc_adx_table_neg,
      @crc_ge_adx_add_table_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_add_table_ref

end

end MLIR.Firedancer.Crc.Ref

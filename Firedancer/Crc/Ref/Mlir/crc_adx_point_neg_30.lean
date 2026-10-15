
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_fe64_neg_c_31
public import Firedancer.Crc.Ref.Mlir.crc_fe64_neg_c_31

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_point_neg_30 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_point_neg.30", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %3 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3) : (!llvm.ptr) -> ()
  "llvm.call"(%2, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_neg_c.31, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_neg_c.31, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg0, %2, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %5 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %6 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%5, %6, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %7 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %8 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%7, %8, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %9 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%9, %3, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%3) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @crc_fe64_neg_c.31 := MLIR.Firedancer.Crc.Ref.crc_fe64_neg_c_31,
      @crc_fe64_neg_c.31 := MLIR.Firedancer.Crc.Ref.crc_fe64_neg_c_31

end

end MLIR.Firedancer.Crc.Ref

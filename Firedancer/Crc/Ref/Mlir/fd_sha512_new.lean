
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir._str_2_57
public import Firedancer.Crc.Ref.Mlir._str_55
public import Firedancer.Crc.Ref.Mlir.__func___fd_sha512_new
public import Firedancer.Crc.Ref.Mlir._str_1_54
public import Firedancer.Crc.Ref.Extern.fd_log_wallclock
public import Firedancer.Crc.Ref.Extern.fd_log_private_0
public import Firedancer.Crc.Ref.Extern.fd_log_private_1
public import Firedancer.Crc.Ref.Mlir.fd_ulong_is_aligned_56
public import Firedancer.Crc.Ref.Extern.fd_log_wallclock
public import Firedancer.Crc.Ref.Extern.fd_log_private_0
public import Firedancer.Crc.Ref.Extern.fd_log_private_1
public import Firedancer.Crc.Ref.Mlir.fd_memset

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

noncomputable mlir_def fd_sha512_new := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = [["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_new", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = -1045158177143107296 : i64}> : () -> i64
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.2.57"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %6 = "llvm.mlir.addressof"() <{global_name = @".str.55"}> : () -> !llvm.ptr
  %7 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %8 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_sha512_new}> : () -> !llvm.ptr
  %9 = "llvm.mlir.addressof"() <{global_name = @".str.1.54"}> : () -> !llvm.ptr
  %10 = "llvm.mlir.constant"() <{value = 22 : i32}> : () -> i32
  %11 = "llvm.icmp"(%arg0, %0) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%11)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %12 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %13 = "llvm.call"(%9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%5, %12, %6, %10, %8, %13) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%0)[^bb5] : (!llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %14 = "llvm.ptrtoint"(%arg0) : (!llvm.ptr) -> i64
  %15 = "llvm.call"(%14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_is_aligned.56, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %16 = "llvm.icmp"(%15, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%16)[^bb3, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %17 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %18 = "llvm.call"(%4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%5, %17, %6, %7, %8, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%0)[^bb5] : (!llvm.ptr) -> ()
^bb4:  // pred: ^bb2
  %19 = "llvm.call"(%arg0, %2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memset, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %20 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "# FD_COMPILER_MFENCE()@src/ballet/sha512/fd_sha512.c(35)", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<tail>}> : () -> !llvm.void
  %21 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3, %21) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>], volatile_}> : (i64, !llvm.ptr) -> ()
  %22 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "# FD_COMPILER_MFENCE()@src/ballet/sha512/fd_sha512.c(37)", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<tail>}> : () -> !llvm.void
  "llvm.br"(%arg0)[^bb5] : (!llvm.ptr) -> ()
^bb5(%23: !llvm.ptr):  // 3 preds: ^bb1, ^bb3, ^bb4
  "llvm.return"(%23) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @.str.2.57 := MLIR.Firedancer.Crc.Ref._str_2_57,
      @.str.55 := MLIR.Firedancer.Crc.Ref._str_55,
      @__func__.fd_sha512_new := MLIR.Firedancer.Crc.Ref.__func___fd_sha512_new,
      @.str.1.54 := MLIR.Firedancer.Crc.Ref._str_1_54,
      @fd_log_wallclock := MLIR.Firedancer.Crc.Ref.fd_log_wallclock,
      @fd_log_private_0 := MLIR.Firedancer.Crc.Ref.fd_log_private_0,
      @fd_log_private_1 := MLIR.Firedancer.Crc.Ref.fd_log_private_1,
      @fd_ulong_is_aligned.56 := MLIR.Firedancer.Crc.Ref.fd_ulong_is_aligned_56,
      @fd_log_wallclock := MLIR.Firedancer.Crc.Ref.fd_log_wallclock,
      @fd_log_private_0 := MLIR.Firedancer.Crc.Ref.fd_log_private_0,
      @fd_log_private_1 := MLIR.Firedancer.Crc.Ref.fd_log_private_1,
      @fd_memset := MLIR.Firedancer.Crc.Ref.fd_memset

end

end MLIR.Firedancer.Crc.Ref

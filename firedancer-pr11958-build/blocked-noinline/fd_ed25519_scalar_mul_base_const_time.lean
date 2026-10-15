
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_scalar_radix16
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln_secure
public import Firedancer.LaneNI.Mlir.fd_ed25519_table_select
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure
public import Firedancer.LaneNI.Mlir.fd_ed25519_table_select
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit
public import Firedancer.LaneNI.Mlir.fd_ed25519_table_select
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure
public import Firedancer.LaneNI.Mlir.fd_ed25519_table_select
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_scalar_mul_base_const_time := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_scalar_mul_base_const_time", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 60 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 66 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 960 : i64}> : () -> i64
  %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<66 x i8>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<5 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  %9 = "llvm.getelementptr"(%7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %10 = "llvm.getelementptr"(%7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 65>}> : (!llvm.ptr) -> !llvm.ptr
  %11 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %13 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %14 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%7, %arg1, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_scalar_radix16, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %15 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  "llvm.call"(%arg0, %arg0, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%4)[^bb4] : (i64) -> ()
^bb2(%16: i64):  // 2 preds: ^bb0, ^bb2
  %17 = "llvm.lshr"(%16, %1) : (i64, i64) -> i64
  %18 = "llvm.getelementptr"(%7, %16) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %20 = "llvm.trunc"(%17) <{overflowFlags = 3 : i32}> : (i64) -> i32
  "llvm.call"(%8, %12, %20, %19, %9, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_table_select, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i32, i8, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%11, %arg0, %8, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %21 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %23 = "llvm.trunc"(%17) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %24 = "llvm.add"(%23, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  "llvm.call"(%12, %8, %24, %22, %9, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_table_select, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i32, i8, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %11, %12, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %25 = "llvm.add"(%16, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %26 = "llvm.icmp"(%16, %3) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%26, %25)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb4
  "llvm.call"(%7, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%8, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb4(%27: i64):  // 2 preds: ^bb1, ^bb4
  %28 = "llvm.lshr"(%27, %1) <{isExact}> : (i64, i64) -> i64
  %29 = "llvm.getelementptr"(%7, %27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.load"(%29) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %31 = "llvm.trunc"(%28) <{overflowFlags = 3 : i32}> : (i64) -> i32
  "llvm.call"(%8, %12, %31, %30, %9, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_table_select, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i32, i8, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%11, %arg0, %8, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %32 = "llvm.getelementptr"(%29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %33 = "llvm.load"(%32) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %34 = "llvm.trunc"(%28) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %35 = "llvm.or"(%34, %0) <{isDisjoint}> : (i32, i32) -> i32
  "llvm.call"(%12, %8, %35, %33, %9, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_table_select, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i32, i8, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %11, %12, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %36 = "llvm.add"(%27, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %37 = "llvm.icmp"(%27, %3) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%37, %36)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @fd_ed25519_scalar_radix16 := Firedancer.LaneNI.Mlir.fd_ed25519_scalar_radix16,
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ed25519_point_dbln_secure := Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln_secure,
      @fd_ed25519_table_select := Firedancer.LaneNI.Mlir.fd_ed25519_table_select,
      @fd_ed25519_point_add_secure := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure,
      @fd_ed25519_table_select := Firedancer.LaneNI.Mlir.fd_ed25519_table_select,
      @fd_ed25519_point_add_secure := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure,
      @fd_memzero_explicit := Firedancer.LaneNI.Mlir.fd_memzero_explicit,
      @fd_memzero_explicit := Firedancer.LaneNI.Mlir.fd_memzero_explicit,
      @fd_ed25519_table_select := Firedancer.LaneNI.Mlir.fd_ed25519_table_select,
      @fd_ed25519_point_add_secure := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure,
      @fd_ed25519_table_select := Firedancer.LaneNI.Mlir.fd_ed25519_table_select,
      @fd_ed25519_point_add_secure := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_secure

end

end Firedancer.LaneNI.Mlir

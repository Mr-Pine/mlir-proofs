
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_3
public import Firedancer.LaneNI.Mlir._str_4
public import Firedancer.LaneNI.Mlir._str_5
public import Firedancer.LaneNI.Mlir._str
public import Firedancer.LaneNI.Mlir.__func___fd_sha512_join
public import Firedancer.LaneNI.Mlir.fd_ulong_is_aligned

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_sha512_join (fd_log_private_0 : _) (fd_log_private_1 : MLIR.Vals [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_join", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1 = "llvm.mlir.addressof"() <{global_name = @".str.3"}> : () -> !llvm.ptr
  %2 = "llvm.mlir.constant"() <{value = 46 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.4"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.constant"() <{value = 51 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = -1045158177143107296 : i64}> : () -> i64
  %7 = "llvm.mlir.addressof"() <{global_name = @".str.5"}> : () -> !llvm.ptr
  %8 = "llvm.mlir.constant"() <{value = 58 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %10 = "llvm.mlir.addressof"() <{global_name = @".str"}> : () -> !llvm.ptr
  %11 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_sha512_join}> : () -> !llvm.ptr
  %12 = "llvm.icmp"(%arg0, %0) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%12, %1, %2)[^bb3, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i32) -> ()
^bb1:  // pred: ^bb0
  %13 = "llvm.ptrtoint"(%arg0) : (!llvm.ptr) -> i64
  %14 = "llvm.call"(%13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_is_aligned, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %15 = "llvm.icmp"(%14, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%15, %4, %5)[^bb3, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i32) -> ()
^bb2:  // pred: ^bb1
  %16 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %17 = "llvm.load"(%16) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 200>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 208>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 216>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (!llvm.ptr) -> i64
  %18 = "llvm.icmp"(%17, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%18, %arg0, %7, %8)[^bb4, ^bb3] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb3(%19: !llvm.ptr, %20: i32):  // 3 preds: ^bb0, ^bb1, ^bb2
  %21 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %22 = "llvm.call"(%19) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%9, %21, %10, %20, %11, %22) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%0)[^bb4] : (!llvm.ptr) -> ()
^bb4(%23: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  "llvm.return"(%23) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @.str.3 := Firedancer.LaneNI.Mlir._str_3,
      @.str.4 := Firedancer.LaneNI.Mlir._str_4,
      @.str.5 := Firedancer.LaneNI.Mlir._str_5,
      @.str := Firedancer.LaneNI.Mlir._str,
      @__func__.fd_sha512_join := Firedancer.LaneNI.Mlir.__func___fd_sha512_join,
      @fd_ulong_is_aligned := Firedancer.LaneNI.Mlir.fd_ulong_is_aligned,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_log_private_1 := fd_log_private_1

end

end Firedancer.LaneNI.Mlir

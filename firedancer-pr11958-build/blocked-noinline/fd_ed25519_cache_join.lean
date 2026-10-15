
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_5_117
public import Firedancer.LaneNI.Mlir._str_6_118
public import Firedancer.LaneNI.Mlir._str_111
public import Firedancer.LaneNI.Mlir.__func___fd_ed25519_cache_join

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_cache_join (fd_log_private_0 : _) (fd_log_private_1 : MLIR.Vals [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_cache_join", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1 = "llvm.mlir.addressof"() <{global_name = @".str.5.117"}> : () -> !llvm.ptr
  %2 = "llvm.mlir.constant"() <{value = 121 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = -198961776083317248 : i64}> : () -> i64
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.6.118"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.constant"() <{value = 125 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %7 = "llvm.mlir.addressof"() <{global_name = @".str.111"}> : () -> !llvm.ptr
  %8 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_ed25519_cache_join}> : () -> !llvm.ptr
  %9 = "llvm.icmp"(%arg0, %0) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%9, %1, %2)[^bb2, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i32) -> ()
^bb1:  // pred: ^bb0
  %10 = "llvm.load"(%arg0) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_ed25519_cache", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 16>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 24>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 32>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 40>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 48>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 56>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "p1 _ZTS20fd_ed25519_cache_set", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 72>, <#llvm.tbaa_type_desc<id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 80>, <#llvm.tbaa_type_desc<id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, 88>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %11 = "llvm.icmp"(%10, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%11, %arg0, %4, %5)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb2(%12: !llvm.ptr, %13: i32):  // 2 preds: ^bb0, ^bb1
  %14 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %15 = "llvm.call"(%12) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%6, %14, %7, %13, %8, %15) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%0)[^bb3] : (!llvm.ptr) -> ()
^bb3(%16: !llvm.ptr):  // 2 preds: ^bb1, ^bb2
  "llvm.return"(%16) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @.str.5.117 := Firedancer.LaneNI.Mlir._str_5_117,
      @.str.6.118 := Firedancer.LaneNI.Mlir._str_6_118,
      @.str.111 := Firedancer.LaneNI.Mlir._str_111,
      @__func__.fd_ed25519_cache_join := Firedancer.LaneNI.Mlir.__func___fd_ed25519_cache_join,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_log_private_1 := fd_log_private_1

end

end Firedancer.LaneNI.Mlir

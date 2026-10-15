
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_1_55
public import Firedancer.LaneNI.Mlir._str_56
public import Firedancer.LaneNI.Mlir.__func___fd_f25519_debug
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_debug (fd_hex_encode : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_private_0 : _) (fd_log_private_1 : MLIR.Vals [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) (fd_log_private_hexdump_msg : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_f25519_debug", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2 = "llvm.mlir.constant"() <{value = 65 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.1.55"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %6 = "llvm.mlir.addressof"() <{global_name = @".str.56"}> : () -> !llvm.ptr
  %7 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %8 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_f25519_debug}> : () -> !llvm.ptr
  %9 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %11 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<65 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%12, %1, %2) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 65 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %13 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %14 = "llvm.call"(%11, %13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_tobytes.54, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %15 = "llvm.call"(%12, %11, %3) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_hex_encode, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %16 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %17 = "llvm.call"(%4, %arg0, %12) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%5, %16, %6, %7, %8, %17) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  %18 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %19 = "llvm.call"(%arg0, %arg1, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_hexdump_msg, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%5, %18, %6, %10, %8, %19) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @.str.1.55 := Firedancer.LaneNI.Mlir._str_1_55,
      @.str.56 := Firedancer.LaneNI.Mlir._str_56,
      @__func__.fd_f25519_debug := Firedancer.LaneNI.Mlir.__func___fd_f25519_debug,
      @fd_f25519_tobytes.54 := Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54,
      @fd_hex_encode := fd_hex_encode,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_log_private_1 := fd_log_private_1,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_hexdump_msg := fd_log_private_hexdump_msg,
      @fd_log_private_1 := fd_log_private_1

end

end Firedancer.LaneNI.Mlir

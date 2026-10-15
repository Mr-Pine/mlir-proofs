
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_1_24
public import Firedancer.LaneNI.Mlir._str_25
public import Firedancer.LaneNI.Mlir.__func___fd_ed25519_debug
public import Firedancer.LaneNI.Mlir._str_2_26
public import Firedancer.LaneNI.Mlir._str_3_27
public import Firedancer.LaneNI.Mlir._str_4_28
public import Firedancer.LaneNI.Mlir._str_5_29
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_to
public import Firedancer.LaneNI.Mlir.fd_f25519_debug
public import Firedancer.LaneNI.Mlir.fd_f25519_debug
public import Firedancer.LaneNI.Mlir.fd_f25519_debug
public import Firedancer.LaneNI.Mlir.fd_f25519_debug

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_debug (fd_hex_encode : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_private_0 : _) (fd_log_private_1 : MLIR.Vals [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) (fd_log_private_hexdump_msg : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_debug", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.addressof"() <{global_name = @".str.1.24"}> : () -> !llvm.ptr
  %2 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3 = "llvm.mlir.addressof"() <{global_name = @".str.25"}> : () -> !llvm.ptr
  %4 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %5 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_ed25519_debug}> : () -> !llvm.ptr
  %6 = "llvm.mlir.addressof"() <{global_name = @".str.2.26"}> : () -> !llvm.ptr
  %7 = "llvm.mlir.addressof"() <{global_name = @".str.3.27"}> : () -> !llvm.ptr
  %8 = "llvm.mlir.addressof"() <{global_name = @".str.4.28"}> : () -> !llvm.ptr
  %9 = "llvm.mlir.addressof"() <{global_name = @".str.5.29"}> : () -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.call"(%10, %11, %12, %13, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_to, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %14 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %15 = "llvm.call"(%1, %arg0) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2, %14, %3, %4, %5, %15) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%6, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_debug, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%7, %11) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_debug, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%8, %12) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_debug, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%9, %13) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_debug, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @.str.1.24 := Firedancer.LaneNI.Mlir._str_1_24,
      @.str.25 := Firedancer.LaneNI.Mlir._str_25,
      @__func__.fd_ed25519_debug := Firedancer.LaneNI.Mlir.__func___fd_ed25519_debug,
      @.str.2.26 := Firedancer.LaneNI.Mlir._str_2_26,
      @.str.3.27 := Firedancer.LaneNI.Mlir._str_3_27,
      @.str.4.28 := Firedancer.LaneNI.Mlir._str_4_28,
      @.str.5.29 := Firedancer.LaneNI.Mlir._str_5_29,
      @fd_ed25519_point_to := Firedancer.LaneNI.Mlir.fd_ed25519_point_to,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_log_private_1 := fd_log_private_1,
      @fd_f25519_debug := Firedancer.LaneNI.Mlir.fd_f25519_debug fd_hex_encode fd_log_private_0 fd_log_private_1 fd_log_private_hexdump_msg fd_log_wallclock,
      @fd_f25519_debug := Firedancer.LaneNI.Mlir.fd_f25519_debug fd_hex_encode fd_log_private_0 fd_log_private_1 fd_log_private_hexdump_msg fd_log_wallclock,
      @fd_f25519_debug := Firedancer.LaneNI.Mlir.fd_f25519_debug fd_hex_encode fd_log_private_0 fd_log_private_1 fd_log_private_hexdump_msg fd_log_wallclock,
      @fd_f25519_debug := Firedancer.LaneNI.Mlir.fd_f25519_debug fd_hex_encode fd_log_private_0 fd_log_private_1 fd_log_private_hexdump_msg fd_log_wallclock

end

end Firedancer.LaneNI.Mlir

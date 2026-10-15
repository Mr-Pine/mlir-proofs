
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir._str_6_34
public import Firedancer.LaneNI.Mlir._str_7
public import Firedancer.LaneNI.Mlir._str_25
public import Firedancer.LaneNI.Mlir.__func___fd_ed25519_point_tobytes_batch8
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_to
public import Firedancer.LaneNI.Mlir.fd_f25519_inv
public import Firedancer.LaneNI.Mlir.fd_f25519_mul
public import Firedancer.LaneNI.Mlir.fd_f25519_mul
public import Firedancer.LaneNI.Mlir.fd_f25519_mul
public import Firedancer.LaneNI.Mlir.fd_f25519_mul4
public import Firedancer.LaneNI.Mlir.fd_f25519_mul2
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30
public import Firedancer.LaneNI.Mlir.fd_f25519_sgn

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_point_tobytes_batch8 (fd_log_private_0 : _) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i64)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_tobytes_batch8", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -9 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %10 = "llvm.mlir.addressof"() <{global_name = @".str.6.34"}> : () -> !llvm.ptr
  %11 = "llvm.mlir.addressof"() <{global_name = @".str.7"}> : () -> !llvm.ptr
  %12 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %13 = "llvm.mlir.addressof"() <{global_name = @".str.25"}> : () -> !llvm.ptr
  %14 = "llvm.mlir.constant"() <{value = 90 : i32}> : () -> i32
  %15 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_ed25519_point_tobytes_batch8}> : () -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %20 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %21 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %22 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %23 = "llvm.add"(%arg2, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %24 = "llvm.icmp"(%23, %2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%24)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %25 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %26 = "llvm.call"(%10, %11) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%12, %25, %13, %14, %15, %26) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_2, fastmathFlags = #llvm.fastmath<none>, no_unwind, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  "llvm.br"(%3)[^bb4] : (i64) -> ()
^bb3:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%20, %18, %5) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %27 = "llvm.icmp"(%arg2, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27, %4)[^bb7, ^bb5] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4(%28: i64):  // 2 preds: ^bb2, ^bb4
  %29 = "llvm.getelementptr"(%16, %28) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.getelementptr"(%17, %28) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.getelementptr"(%18, %28) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %32 = "llvm.getelementptr"(%arg1, %28) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%29, %30, %31, %19, %32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_to, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %33 = "llvm.add"(%28, %4) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %34 = "llvm.icmp"(%33, %arg2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%34, %33)[^bb3, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5:  // 2 preds: ^bb3, ^bb7
  %35 = "llvm.add"(%arg2, %6) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %36 = "llvm.getelementptr"(%20, %35) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %37 = "llvm.call"(%22, %36) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_inv, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %38 = "llvm.icmp"(%35, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%38, %35)[^bb6, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb6:  // pred: ^bb5
  "llvm.intr.memcpy"(%21, %22, %5) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%3)[^bb11] : (i64) -> ()
^bb7(%39: i64):  // 2 preds: ^bb3, ^bb7
  %40 = "llvm.getelementptr"(%20, %39) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %41 = "llvm.getelementptr"(%40) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -64>}> : (!llvm.ptr) -> !llvm.ptr
  %42 = "llvm.getelementptr"(%18, %39) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %43 = "llvm.load"(%41) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %44 = "llvm.load"(%42) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %45 = "llvm.call"(%40, %43, %44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %46 = "llvm.add"(%39, %4) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %47 = "llvm.icmp"(%46, %arg2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%47, %46)[^bb5, ^bb7] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb8:  // pred: ^bb9
  "llvm.intr.memcpy"(%21, %22, %5) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%7, %3)[^bb10] : (i64, i64) -> ()
^bb9(%48: i64):  // 2 preds: ^bb5, ^bb9
  %49 = "llvm.getelementptr"(%21, %48) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %50 = "llvm.getelementptr"(%20, %48) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %51 = "llvm.getelementptr"(%50) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -64>}> : (!llvm.ptr) -> !llvm.ptr
  %52 = "llvm.load"(%22) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %53 = "llvm.load"(%51) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %54 = "llvm.call"(%49, %52, %53) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %55 = "llvm.getelementptr"(%18, %48) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %56 = "llvm.load"(%55) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %57 = "llvm.call"(%22, %52, %56) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>) -> !llvm.ptr
  %58 = "llvm.add"(%48, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.icmp"(%58, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%59, %58)[^bb8, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10(%60: i64, %61: i64):  // 2 preds: ^bb8, ^bb10
  %62 = "llvm.getelementptr"(%16, %61) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %63 = "llvm.getelementptr"(%21, %61) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %64 = "llvm.getelementptr"(%17, %61) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %65 = "llvm.or"(%61, %4) <{isDisjoint}> : (i64, i64) -> i64
  %66 = "llvm.getelementptr"(%16, %65) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %67 = "llvm.getelementptr"(%21, %65) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %68 = "llvm.getelementptr"(%17, %65) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %69 = "llvm.load"(%62) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %70 = "llvm.load"(%63) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %71 = "llvm.load"(%64) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %72 = "llvm.load"(%66) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %73 = "llvm.load"(%67) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %74 = "llvm.load"(%68) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%62, %69, %70, %64, %71, %70, %66, %72, %73, %68, %74, %73) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}, {llvm.noundef}, {}, {}, {llvm.noundef}, {}, {}, {llvm.noundef}, {}, {}], callee = @fd_f25519_mul4, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 12, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>) -> ()
  %75 = "llvm.add"(%60, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %76 = "llvm.icmp"(%75, %arg2) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%76, %60, %75, %60)[^bb11, ^bb10] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb11(%77: i64):  // 2 preds: ^bb6, ^bb10
  %78 = "llvm.icmp"(%77, %arg2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%78)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %79 = "llvm.getelementptr"(%16, %77) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %80 = "llvm.getelementptr"(%21, %77) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %81 = "llvm.getelementptr"(%17, %77) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %82 = "llvm.load"(%79) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %83 = "llvm.load"(%80) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%79, %82, %83, %81, %81, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb13] : () -> ()
^bb13:  // 2 preds: ^bb11, ^bb12
  "llvm.br"(%3)[^bb15] : (i64) -> ()
^bb14:  // pred: ^bb15
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb15(%84: i64):  // 2 preds: ^bb13, ^bb15
  %85 = "llvm.shl"(%84, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %86 = "llvm.getelementptr"(%arg0, %85) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %87 = "llvm.getelementptr"(%17, %84) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %88 = "llvm.load"(%87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %89 = "llvm.call"(%86, %88) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_tobytes.30, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %90 = "llvm.getelementptr"(%16, %84) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %91 = "llvm.load"(%90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %92 = "llvm.call"(%91) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, callee = @fd_f25519_sgn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %93 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %94 = "llvm.load"(%93) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %95 = "llvm.trunc"(%92) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %96 = "llvm.shl"(%95, %9) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  %97 = "llvm.xor"(%96, %94) : (i8, i8) -> i8
  "llvm.store"(%97, %93) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %98 = "llvm.add"(%84, %4) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %99 = "llvm.icmp"(%98, %arg2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%99, %98)[^bb14, ^bb15] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @.str.6.34 := Firedancer.LaneNI.Mlir._str_6_34,
      @.str.7 := Firedancer.LaneNI.Mlir._str_7,
      @.str.25 := Firedancer.LaneNI.Mlir._str_25,
      @__func__.fd_ed25519_point_tobytes_batch8 := Firedancer.LaneNI.Mlir.__func___fd_ed25519_point_tobytes_batch8,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_ed25519_point_to := Firedancer.LaneNI.Mlir.fd_ed25519_point_to,
      @fd_f25519_inv := Firedancer.LaneNI.Mlir.fd_f25519_inv,
      @fd_f25519_mul := Firedancer.LaneNI.Mlir.fd_f25519_mul,
      @fd_f25519_mul := Firedancer.LaneNI.Mlir.fd_f25519_mul,
      @fd_f25519_mul := Firedancer.LaneNI.Mlir.fd_f25519_mul,
      @fd_f25519_mul4 := Firedancer.LaneNI.Mlir.fd_f25519_mul4,
      @fd_f25519_mul2 := Firedancer.LaneNI.Mlir.fd_f25519_mul2,
      @fd_f25519_tobytes.30 := Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30,
      @fd_f25519_sgn := Firedancer.LaneNI.Mlir.fd_f25519_sgn

end

end Firedancer.LaneNI.Mlir

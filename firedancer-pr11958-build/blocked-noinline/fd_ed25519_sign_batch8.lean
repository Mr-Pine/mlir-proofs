
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_sign_batch8_buf
public import Firedancer.LaneNI.Mlir._str_1_135
public import Firedancer.LaneNI.Mlir._str_3_139
public import Firedancer.LaneNI.Mlir._str_137
public import Firedancer.LaneNI.Mlir.__func___fd_ed25519_sign_batch8
public import Firedancer.LaneNI.Mlir._str_2_136
public import Firedancer.LaneNI.Mlir.fd_ed25519_sign
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_tobytes_batch8
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_ed25519_scalar_mul_base_const_time
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit_134
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit_134
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_muladd

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_sign_batch8 (fd_log_private_0 : _) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_sign_batch8", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -9 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 2048 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = dense<[true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]> : vector<32xi1>}> : () -> vector<32xi1>
  %8 = "llvm.mlir.poison"() : () -> vector<32xi8>
  %9 = "llvm.mlir.constant"() <{value = dense<[-8, 63]> : vector<2xi8>}> : () -> vector<2xi8>
  %10 = "llvm.mlir.constant"() <{value = dense<[0, 64]> : vector<2xi8>}> : () -> vector<2xi8>
  %11 = "llvm.mlir.poison"() : () -> vector<2xi8>
  %12 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_sign_batch8.buf}> : () -> !llvm.ptr
  %13 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %16 = "llvm.mlir.addressof"() <{global_name = @".str.1.135"}> : () -> !llvm.ptr
  %17 = "llvm.mlir.addressof"() <{global_name = @".str.3.139"}> : () -> !llvm.ptr
  %18 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %19 = "llvm.mlir.addressof"() <{global_name = @".str.137"}> : () -> !llvm.ptr
  %20 = "llvm.mlir.constant"() <{value = 187 : i32}> : () -> i32
  %21 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_ed25519_sign_batch8}> : () -> !llvm.ptr
  %22 = "llvm.mlir.addressof"() <{global_name = @".str.2.136"}> : () -> !llvm.ptr
  %23 = "llvm.mlir.constant"() <{value = 181 : i32}> : () -> i32
  %24 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private", (array<128 x i8>, array<8 x i64>, i64, i64, i64, i64, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %25 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private_batch", (array<8 x ptr>, array<8 x i64>, array<8 x ptr>, i64, array<56 x i8>)>>}> : (i32) -> !llvm.ptr
  %26 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %27 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %28 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %29 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %30 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %31 = "llvm.add"(%arg5, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.icmp"(%31, %2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%32)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %33 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %34 = "llvm.call"(%16, %22) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%18, %33, %19, %23, %21, %34) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_2, fastmathFlags = #llvm.fastmath<none>, no_unwind, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb2:  // pred: ^bb0
  %35 = "llvm.icmp"(%arg5, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%35, %4)[^bb3, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%24) : (!llvm.ptr) -> ()
  %36 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %37 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %38 = "llvm.call"(%arg0, %36, %37, %arg3, %arg4, %24) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_sign, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%24) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb22] : () -> ()
^bb4:  // pred: ^bb6
  %39 = "llvm.add"(%42, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %40 = "llvm.icmp"(%39, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%40, %39)[^bb5, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%26) : (!llvm.ptr) -> ()
  %41 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_init.138, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb9] : (i64) -> ()
^bb6(%42: i64):  // 2 preds: ^bb2, ^bb4
  %43 = "llvm.getelementptr"(%arg2, %42) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %44 = "llvm.load"(%43) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %45 = "llvm.icmp"(%44, %5) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%45)[^bb7, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %46 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %47 = "llvm.call"(%16, %17) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%18, %46, %19, %20, %21, %47) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_2, fastmathFlags = #llvm.fastmath<none>, no_unwind, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb8:  // pred: ^bb9
  %48 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_fini.140, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb11] : (i64) -> ()
^bb9(%49: i64):  // 2 preds: ^bb5, ^bb9
  %50 = "llvm.getelementptr"(%26, %49) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %51 = "llvm.call"(%25, %arg4, %6, %50) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_batch_add.141, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  %52 = "llvm.add"(%49, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %53 = "llvm.icmp"(%52, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%53, %52)[^bb8, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb11
  "llvm.intr.lifetime.start"(%27) : (!llvm.ptr) -> ()
  %54 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_init.138, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %55 = "llvm.intr.threadlocal.address"(%12) : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb13] : (i64) -> ()
^bb11(%56: i64):  // 2 preds: ^bb8, ^bb11
  %57 = "llvm.getelementptr"(%26, %56) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %58 = "llvm.intr.masked.load"(%57, %7, %8) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %59 = "llvm.shufflevector"(%58, %8) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %60 = "llvm.and"(%59, %9) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %61 = "llvm.or"(%60, %10) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %62 = "llvm.shufflevector"(%61, %11) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%62, %57, %7) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %63 = "llvm.add"(%56, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %64 = "llvm.icmp"(%63, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%64, %63)[^bb10, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb12:  // pred: ^bb15
  %65 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_fini.140, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%28) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%29) : (!llvm.ptr) -> ()
  "llvm.br"(%4)[^bb17] : (i64) -> ()
^bb13(%66: i64):  // 2 preds: ^bb10, ^bb15
  %67 = "llvm.getelementptr"(%55, %66) <{elem_type = !llvm.array<2112 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %68 = "llvm.getelementptr"(%67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %69 = "llvm.getelementptr"(%26, %66) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %70 = "llvm.getelementptr"(%69) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%68, %70, %6) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %71 = "llvm.getelementptr"(%arg2, %66) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %72 = "llvm.load"(%71) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %73 = "llvm.icmp"(%72, %4) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%73, %6)[^bb15, ^bb14] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb14:  // pred: ^bb13
  %74 = "llvm.getelementptr"(%67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %75 = "llvm.getelementptr"(%arg1, %66) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %76 = "llvm.load"(%75) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%74, %76, %72) <{arg_attrs = [{llvm.align = 64 : i64, llvm.nonnull}, {llvm.align = 1 : i64}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %77 = "llvm.load"(%71) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %78 = "llvm.add"(%77, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%78)[^bb15] : (i64) -> ()
^bb15(%79: i64):  // 2 preds: ^bb13, ^bb14
  %80 = "llvm.getelementptr"(%27, %66) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %81 = "llvm.call"(%25, %68, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_batch_add.141, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  %82 = "llvm.add"(%66, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %83 = "llvm.icmp"(%82, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%83, %82)[^bb12, ^bb13] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb16:  // pred: ^bb17
  %84 = "llvm.call"(%28, %29, %arg5) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_tobytes_batch8, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%30) : (!llvm.ptr) -> ()
  %85 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_init.138, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %86 = "llvm.intr.threadlocal.address"(%12) : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb19] : (i64) -> ()
^bb17(%87: i64):  // 2 preds: ^bb12, ^bb17
  %88 = "llvm.getelementptr"(%27, %87) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %89 = "llvm.call"(%88, %88) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %90 = "llvm.getelementptr"(%29, %87) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %91 = "llvm.call"(%90, %88) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_scalar_mul_base_const_time, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %92 = "llvm.add"(%87, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %93 = "llvm.icmp"(%92, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%93, %92)[^bb16, ^bb17] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb18:  // pred: ^bb19
  %94 = "llvm.call"(%25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_fini.140, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb21] : (i64) -> ()
^bb19(%95: i64):  // 2 preds: ^bb16, ^bb19
  %96 = "llvm.shl"(%95, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %97 = "llvm.getelementptr"(%arg0, %96) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %98 = "llvm.shl"(%95, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %99 = "llvm.getelementptr"(%28, %98) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%97, %99, %6) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %100 = "llvm.getelementptr"(%86, %95) <{elem_type = !llvm.array<2112 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%100, %99, %6) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %101 = "llvm.getelementptr"(%100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%101, %arg3, %6) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %102 = "llvm.getelementptr"(%arg2, %95) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %103 = "llvm.load"(%102) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %104 = "llvm.add"(%103, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %105 = "llvm.getelementptr"(%30, %95) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %106 = "llvm.call"(%25, %100, %104, %105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_batch_add.141, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  %107 = "llvm.add"(%95, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %108 = "llvm.icmp"(%107, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%108, %107)[^bb18, ^bb19] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb20:  // pred: ^bb21
  %109 = "llvm.shl"(%arg5, %14) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.call"(%26, %109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit.134, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%27, %109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit.134, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%30) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%29) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%28) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%27) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%26) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%25) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb22] : () -> ()
^bb21(%110: i64):  // 2 preds: ^bb18, ^bb21
  %111 = "llvm.getelementptr"(%30, %110) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %112 = "llvm.call"(%111, %111) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %113 = "llvm.shl"(%110, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.getelementptr"(%arg0, %113) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %115 = "llvm.getelementptr"(%114) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %116 = "llvm.getelementptr"(%26, %110) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %117 = "llvm.getelementptr"(%27, %110) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %118 = "llvm.call"(%115, %111, %116, %117) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_muladd, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %119 = "llvm.add"(%110, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %120 = "llvm.icmp"(%119, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%120, %119)[^bb20, ^bb21] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb22:  // 2 preds: ^bb3, ^bb20
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_sign_batch8.buf := Firedancer.LaneNI.Mlir.fd_ed25519_sign_batch8_buf,
      @.str.1.135 := Firedancer.LaneNI.Mlir._str_1_135,
      @.str.3.139 := Firedancer.LaneNI.Mlir._str_3_139,
      @.str.137 := Firedancer.LaneNI.Mlir._str_137,
      @__func__.fd_ed25519_sign_batch8 := Firedancer.LaneNI.Mlir.__func___fd_ed25519_sign_batch8,
      @.str.2.136 := Firedancer.LaneNI.Mlir._str_2_136,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_ed25519_sign := Firedancer.LaneNI.Mlir.fd_ed25519_sign,
      @fd_sha512_batch_init.138 := Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_sha512_batch_fini.140 := Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140,
      @fd_sha512_batch_add.141 := Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141,
      @fd_sha512_batch_init.138 := Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138,
      @fd_sha512_batch_fini.140 := Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140,
      @fd_sha512_batch_add.141 := Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141,
      @fd_ed25519_point_tobytes_batch8 := Firedancer.LaneNI.Mlir.fd_ed25519_point_tobytes_batch8 fd_log_private_0 fd_log_wallclock,
      @fd_sha512_batch_init.138 := Firedancer.LaneNI.Mlir.fd_sha512_batch_init_138,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_scalar_mul_base_const_time := Firedancer.LaneNI.Mlir.fd_ed25519_scalar_mul_base_const_time,
      @fd_sha512_batch_fini.140 := Firedancer.LaneNI.Mlir.fd_sha512_batch_fini_140,
      @fd_sha512_batch_add.141 := Firedancer.LaneNI.Mlir.fd_sha512_batch_add_141,
      @fd_memzero_explicit.134 := Firedancer.LaneNI.Mlir.fd_memzero_explicit_134,
      @fd_memzero_explicit.134 := Firedancer.LaneNI.Mlir.fd_memzero_explicit_134,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_curve25519_scalar_muladd := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_muladd

end

end Firedancer.LaneNI.Mlir

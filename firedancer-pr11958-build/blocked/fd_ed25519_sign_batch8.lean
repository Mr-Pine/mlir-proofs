
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_sign_batch8_buf
public import Firedancer.Lane.Mlir._str_1_50
public import Firedancer.Lane.Mlir._str_3_53
public import Firedancer.Lane.Mlir._str_52
public import Firedancer.Lane.Mlir.__func___fd_ed25519_sign_batch8
public import Firedancer.Lane.Mlir._str_2_51
public import Firedancer.Lane.Mlir.fd_ed25519_sign
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_ed25519_point_tobytes_batch8
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_ed25519_scalar_mul_base_const_time
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_muladd

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_sign_batch8 (fd_log_private_0 : _) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_sign_batch8", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -9 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 2048 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = dense<[true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]> : vector<32xi1>}> : () -> vector<32xi1>
  %17 = "llvm.mlir.poison"() : () -> vector<32xi8>
  %18 = "llvm.mlir.constant"() <{value = dense<[-8, 63]> : vector<2xi8>}> : () -> vector<2xi8>
  %19 = "llvm.mlir.constant"() <{value = dense<[0, 64]> : vector<2xi8>}> : () -> vector<2xi8>
  %20 = "llvm.mlir.poison"() : () -> vector<2xi8>
  %21 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_sign_batch8.buf}> : () -> !llvm.ptr
  %22 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %23 = "llvm.mlir.addressof"() <{global_name = @".str.1.50"}> : () -> !llvm.ptr
  %24 = "llvm.mlir.addressof"() <{global_name = @".str.3.53"}> : () -> !llvm.ptr
  %25 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %26 = "llvm.mlir.addressof"() <{global_name = @".str.52"}> : () -> !llvm.ptr
  %27 = "llvm.mlir.constant"() <{value = 187 : i32}> : () -> i32
  %28 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_ed25519_sign_batch8}> : () -> !llvm.ptr
  %29 = "llvm.mlir.addressof"() <{global_name = @".str.2.51"}> : () -> !llvm.ptr
  %30 = "llvm.mlir.constant"() <{value = 181 : i32}> : () -> i32
  %31 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private", (array<128 x i8>, array<8 x i64>, i64, i64, i64, i64, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %32 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private_batch", (array<8 x ptr>, array<8 x i64>, array<8 x ptr>, i64, array<56 x i8>)>>}> : (i32) -> !llvm.ptr
  %33 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %34 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %35 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %36 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %37 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %38 = "llvm.add"(%arg5, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %39 = "llvm.icmp"(%38, %2) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%39)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %40 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %41 = "llvm.call"(%23, %29) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%25, %40, %26, %30, %28, %41) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_2, fastmathFlags = #llvm.fastmath<none>, no_unwind, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb2:  // pred: ^bb0
  %42 = "llvm.icmp"(%arg5, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%42)[^bb3, ^bb18] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%31) : (!llvm.ptr) -> ()
  %43 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %44 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %45 = "llvm.call"(%arg0, %43, %44, %arg3, %arg4, %31) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_sign, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%31) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb53] : () -> ()
^bb4:  // pred: ^bb18
  %46 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %47 = "llvm.load"(%46) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %48 = "llvm.icmp"(%47, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%48)[^bb19, ^bb5] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %49 = "llvm.icmp"(%arg5, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%49)[^bb17, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %50 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %51 = "llvm.load"(%50) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %52 = "llvm.icmp"(%51, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%52)[^bb19, ^bb7] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %53 = "llvm.icmp"(%arg5, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%53)[^bb17, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %54 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %55 = "llvm.load"(%54) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %56 = "llvm.icmp"(%55, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%56)[^bb19, ^bb9] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %57 = "llvm.icmp"(%arg5, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%57)[^bb17, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %58 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %60 = "llvm.icmp"(%59, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%60)[^bb19, ^bb11] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %61 = "llvm.icmp"(%arg5, %10) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%61)[^bb17, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %62 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.load"(%62) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %64 = "llvm.icmp"(%63, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%64)[^bb19, ^bb13] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %65 = "llvm.icmp"(%arg5, %11) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%65)[^bb17, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %66 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.load"(%66) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %68 = "llvm.icmp"(%67, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%68)[^bb19, ^bb15] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %69 = "llvm.icmp"(%arg5, %12) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%69)[^bb17, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb16:  // pred: ^bb15
  %70 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %71 = "llvm.load"(%70) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %72 = "llvm.icmp"(%71, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%72)[^bb19, ^bb17] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // 7 preds: ^bb5, ^bb7, ^bb9, ^bb11, ^bb13, ^bb15, ^bb16
  "llvm.intr.lifetime.start"(%32) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%33) : (!llvm.ptr) -> ()
  %73 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %74 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %75 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%13, %13)[^bb24] : (i64, i64) -> ()
^bb18:  // pred: ^bb2
  %76 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %77 = "llvm.icmp"(%76, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%77)[^bb19, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb19:  // 8 preds: ^bb4, ^bb6, ^bb8, ^bb10, ^bb12, ^bb14, ^bb16, ^bb18
  %78 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %79 = "llvm.call"(%23, %24) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%25, %78, %26, %27, %28, %79) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_2, fastmathFlags = #llvm.fastmath<none>, no_unwind, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb20:  // pred: ^bb25
  %80 = "llvm.icmp"(%93, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%80)[^bb21, ^bb23] <{branch_weights = array<i32: 0, -2147483648>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // 3 preds: ^bb20, ^bb23, ^bb27
  %81 = "llvm.add"(%arg5, %15) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %82 = "llvm.and"(%arg5, %12) : (i64, i64) -> i64
  %83 = "llvm.icmp"(%81, %12) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%83, %13)[^bb29, ^bb22] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb22:  // pred: ^bb21
  %84 = "llvm.and"(%arg5, %5) : (i64, i64) -> i64
  "llvm.br"(%13, %13)[^bb32] : (i64, i64) -> ()
^bb23:  // pred: ^bb20
  %85 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %86 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%93, %32, %85, %86) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb21] : () -> ()
^bb24(%87: i64, %88: i64):  // 2 preds: ^bb17, ^bb26
  %89 = "llvm.getelementptr"(%33, %88) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %90 = "llvm.getelementptr"(%32, %87) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%arg4, %90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %91 = "llvm.getelementptr"(%74, %87) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%9, %91) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %92 = "llvm.getelementptr"(%75, %87) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%89, %92) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %93 = "llvm.add"(%87, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %94 = "llvm.icmp"(%93, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%94)[^bb27, ^bb25] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb25:  // pred: ^bb24
  "llvm.store"(%93, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %95 = "llvm.add"(%88, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %96 = "llvm.icmp"(%95, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%96, %93, %95)[^bb20, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb26(%97: i64, %98: i64):  // 2 preds: ^bb25, ^bb27
  "llvm.br"(%97, %98)[^bb24] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>}> : (i64, i64) -> ()
^bb27:  // pred: ^bb24
  "llvm.call"(%5, %32, %74, %75) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %99 = "llvm.add"(%88, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %100 = "llvm.icmp"(%99, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%100, %13, %99)[^bb21, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb28:  // pred: ^bb32
  %101 = "llvm.icmp"(%82, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%101, %175)[^bb31, ^bb29] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb29(%102: i64):  // 2 preds: ^bb21, ^bb28
  %103 = "llvm.icmp"(%82, %13) <{predicate = 1 : i64}> : (i64, i64) -> i1
  "llvm.intr.assume"(%103) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  "llvm.br"(%102, %13)[^bb30] : (i64, i64) -> ()
^bb30(%104: i64, %105: i64):  // 2 preds: ^bb29, ^bb30
  %106 = "llvm.getelementptr"(%33, %104) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.intr.masked.load"(%106, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %108 = "llvm.shufflevector"(%107, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %109 = "llvm.and"(%108, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %110 = "llvm.or"(%109, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %111 = "llvm.shufflevector"(%110, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%111, %106, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %112 = "llvm.add"(%104, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %113 = "llvm.add"(%105, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.icmp"(%113, %82) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%114, %112, %113)[^bb31, ^bb30] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb31:  // 2 preds: ^bb28, ^bb30
  "llvm.intr.lifetime.start"(%34) : (!llvm.ptr) -> ()
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %115 = "llvm.intr.threadlocal.address"(%21) : (!llvm.ptr) -> !llvm.ptr
  %116 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %117 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%13, %13)[^bb36] : (i64, i64) -> ()
^bb32(%118: i64, %119: i64):  // 2 preds: ^bb22, ^bb32
  %120 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %121 = "llvm.intr.masked.load"(%120, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %122 = "llvm.shufflevector"(%121, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %123 = "llvm.and"(%122, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %124 = "llvm.or"(%123, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %125 = "llvm.shufflevector"(%124, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%125, %120, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %126 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %127 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %128 = "llvm.intr.masked.load"(%127, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %129 = "llvm.shufflevector"(%128, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %130 = "llvm.and"(%129, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %131 = "llvm.or"(%130, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %132 = "llvm.shufflevector"(%131, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%132, %127, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %133 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %134 = "llvm.getelementptr"(%133) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %135 = "llvm.intr.masked.load"(%134, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %136 = "llvm.shufflevector"(%135, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %137 = "llvm.and"(%136, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %138 = "llvm.or"(%137, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %139 = "llvm.shufflevector"(%138, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%139, %134, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %140 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %141 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %142 = "llvm.intr.masked.load"(%141, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %143 = "llvm.shufflevector"(%142, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %144 = "llvm.and"(%143, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %145 = "llvm.or"(%144, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %146 = "llvm.shufflevector"(%145, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%146, %141, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %147 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %148 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %149 = "llvm.intr.masked.load"(%148, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %150 = "llvm.shufflevector"(%149, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %151 = "llvm.and"(%150, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %152 = "llvm.or"(%151, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %153 = "llvm.shufflevector"(%152, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%153, %148, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %154 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %155 = "llvm.getelementptr"(%154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %156 = "llvm.intr.masked.load"(%155, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %157 = "llvm.shufflevector"(%156, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %158 = "llvm.and"(%157, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %159 = "llvm.or"(%158, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %160 = "llvm.shufflevector"(%159, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%160, %155, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %161 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %162 = "llvm.getelementptr"(%161) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %163 = "llvm.intr.masked.load"(%162, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %164 = "llvm.shufflevector"(%163, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %165 = "llvm.and"(%164, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %166 = "llvm.or"(%165, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %167 = "llvm.shufflevector"(%166, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%167, %162, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %168 = "llvm.getelementptr"(%33, %118) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %169 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.intr.masked.load"(%169, %16, %17) <{alignment = 64 : i32}> : (!llvm.ptr, vector<32xi1>, vector<32xi8>) -> vector<32xi8>
  %171 = "llvm.shufflevector"(%170, %17) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %172 = "llvm.and"(%171, %18) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %173 = "llvm.or"(%172, %19) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %174 = "llvm.shufflevector"(%173, %20) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%174, %169, %16) <{alignment = 64 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %175 = "llvm.add"(%118, %5) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %176 = "llvm.add"(%119, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %177 = "llvm.icmp"(%176, %84) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%177, %175, %176)[^bb28, ^bb32] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb33:  // pred: ^bb39
  %178 = "llvm.icmp"(%200, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%178)[^bb35, ^bb34] <{branch_weights = array<i32: 536736, 2146946912>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb34:  // pred: ^bb33
  %179 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %180 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%200, %32, %179, %180) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb35] : () -> ()
^bb35:  // 3 preds: ^bb33, ^bb34, ^bb41
  "llvm.intr.lifetime.start"(%35) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%36) : (!llvm.ptr) -> ()
  "llvm.br"(%13)[^bb43] : (i64) -> ()
^bb36(%181: i64, %182: i64):  // 2 preds: ^bb31, ^bb40
  %183 = "llvm.getelementptr"(%115, %182) <{elem_type = !llvm.array<2112 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %184 = "llvm.getelementptr"(%183) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %185 = "llvm.getelementptr"(%33, %182) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %186 = "llvm.getelementptr"(%185) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%184, %186, %9) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %187 = "llvm.getelementptr"(%arg2, %182) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %188 = "llvm.load"(%187) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %189 = "llvm.icmp"(%188, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%189, %9)[^bb38, ^bb37] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb37:  // pred: ^bb36
  %190 = "llvm.getelementptr"(%183) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %191 = "llvm.getelementptr"(%arg1, %182) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %192 = "llvm.load"(%191) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%190, %192, %188) <{arg_attrs = [{llvm.align = 64 : i64, llvm.nonnull}, {llvm.align = 1 : i64}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %193 = "llvm.load"(%187) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %194 = "llvm.add"(%193, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%194)[^bb38] : (i64) -> ()
^bb38(%195: i64):  // 2 preds: ^bb36, ^bb37
  %196 = "llvm.getelementptr"(%34, %182) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %197 = "llvm.getelementptr"(%32, %181) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%184, %197) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %198 = "llvm.getelementptr"(%116, %181) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%195, %198) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %199 = "llvm.getelementptr"(%117, %181) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%196, %199) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %200 = "llvm.add"(%181, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %201 = "llvm.icmp"(%200, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%201)[^bb41, ^bb39] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb39:  // pred: ^bb38
  "llvm.store"(%200, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %202 = "llvm.add"(%182, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %203 = "llvm.icmp"(%202, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%203, %200, %202)[^bb33, ^bb40] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb40(%204: i64, %205: i64):  // 2 preds: ^bb39, ^bb41
  "llvm.br"(%204, %205)[^bb36] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>}> : (i64, i64) -> ()
^bb41:  // pred: ^bb38
  "llvm.call"(%5, %32, %116, %117) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %206 = "llvm.add"(%182, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %207 = "llvm.icmp"(%206, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%207, %13, %206)[^bb35, ^bb40] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb42:  // pred: ^bb43
  %208 = "llvm.call"(%35, %36, %arg5) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_tobytes_batch8, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%37) : (!llvm.ptr) -> ()
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %209 = "llvm.intr.threadlocal.address"(%21) : (!llvm.ptr) -> !llvm.ptr
  %210 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %211 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%13, %13)[^bb47] : (i64, i64) -> ()
^bb43(%212: i64):  // 2 preds: ^bb35, ^bb43
  %213 = "llvm.getelementptr"(%34, %212) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %214 = "llvm.call"(%213, %213) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %215 = "llvm.getelementptr"(%36, %212) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %216 = "llvm.call"(%215, %213) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_scalar_mul_base_const_time, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %217 = "llvm.add"(%212, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %218 = "llvm.icmp"(%217, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%218, %217)[^bb42, ^bb43] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb44:  // pred: ^bb48
  %219 = "llvm.icmp"(%237, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%219)[^bb45, ^bb46] <{branch_weights = array<i32: 536736, 2146946912>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb45:  // 3 preds: ^bb44, ^bb46, ^bb50
  "llvm.br"(%13)[^bb52] : (i64) -> ()
^bb46:  // pred: ^bb44
  %220 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %221 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%237, %32, %220, %221) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb45] : () -> ()
^bb47(%222: i64, %223: i64):  // 2 preds: ^bb42, ^bb49
  %224 = "llvm.shl"(%223, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %225 = "llvm.getelementptr"(%arg0, %224) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %226 = "llvm.shl"(%223, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %227 = "llvm.getelementptr"(%35, %226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%225, %227, %9) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %228 = "llvm.getelementptr"(%209, %223) <{elem_type = !llvm.array<2112 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%228, %227, %9) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %229 = "llvm.getelementptr"(%228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%229, %arg3, %9) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %230 = "llvm.getelementptr"(%arg2, %223) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %231 = "llvm.load"(%230) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %232 = "llvm.add"(%231, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %233 = "llvm.getelementptr"(%37, %223) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %234 = "llvm.getelementptr"(%32, %222) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%228, %234) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %235 = "llvm.getelementptr"(%210, %222) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%232, %235) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %236 = "llvm.getelementptr"(%211, %222) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%233, %236) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %237 = "llvm.add"(%222, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %238 = "llvm.icmp"(%237, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%238)[^bb50, ^bb48] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb48:  // pred: ^bb47
  "llvm.store"(%237, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %239 = "llvm.add"(%223, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %240 = "llvm.icmp"(%239, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%240, %237, %239)[^bb44, ^bb49] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb49(%241: i64, %242: i64):  // 2 preds: ^bb48, ^bb50
  "llvm.br"(%241, %242)[^bb47] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>}> : (i64, i64) -> ()
^bb50:  // pred: ^bb47
  "llvm.call"(%5, %32, %210, %211) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%13, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %243 = "llvm.add"(%223, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %244 = "llvm.icmp"(%243, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%244, %13, %243)[^bb45, ^bb49] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb51:  // pred: ^bb52
  %245 = "llvm.shl"(%arg5, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%33, %22, %245) <{arg_attrs = [{llvm.align = 64 : i64, llvm.nonnull}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %246 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<none>}> : () -> !llvm.void
  "llvm.intr.memset"(%34, %22, %245) <{arg_attrs = [{llvm.align = 64 : i64, llvm.nonnull}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %247 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<none>}> : () -> !llvm.void
  "llvm.intr.lifetime.end"(%37) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%36) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%35) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%34) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%33) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%32) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb53] : () -> ()
^bb52(%248: i64):  // 2 preds: ^bb45, ^bb52
  %249 = "llvm.getelementptr"(%37, %248) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %250 = "llvm.call"(%249, %249) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %251 = "llvm.shl"(%248, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %252 = "llvm.getelementptr"(%arg0, %251) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %253 = "llvm.getelementptr"(%252) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.getelementptr"(%33, %248) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %255 = "llvm.getelementptr"(%34, %248) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %256 = "llvm.call"(%253, %249, %254, %255) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_muladd, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %257 = "llvm.add"(%248, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %258 = "llvm.icmp"(%257, %arg5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%258, %257)[^bb51, ^bb52] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb53:  // 2 preds: ^bb3, ^bb51
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_sign_batch8.buf := Firedancer.Lane.Mlir.fd_ed25519_sign_batch8_buf,
      @.str.1.50 := Firedancer.Lane.Mlir._str_1_50,
      @.str.3.53 := Firedancer.Lane.Mlir._str_3_53,
      @.str.52 := Firedancer.Lane.Mlir._str_52,
      @__func__.fd_ed25519_sign_batch8 := Firedancer.Lane.Mlir.__func___fd_ed25519_sign_batch8,
      @.str.2.51 := Firedancer.Lane.Mlir._str_2_51,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_ed25519_sign := Firedancer.Lane.Mlir.fd_ed25519_sign,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_ed25519_point_tobytes_batch8 := Firedancer.Lane.Mlir.fd_ed25519_point_tobytes_batch8 fd_log_private_0 fd_log_wallclock,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_scalar_mul_base_const_time := Firedancer.Lane.Mlir.fd_ed25519_scalar_mul_base_const_time,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_sha512_private_batch_avx512 := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_curve25519_scalar_muladd := Firedancer.Lane.Mlir.fd_curve25519_scalar_muladd

end

end Firedancer.Lane.Mlir

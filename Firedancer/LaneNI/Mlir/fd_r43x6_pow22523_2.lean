
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_pow22523_2 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, vector<8xi64>, ptr, vector<8xi64>)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_pow22523_2", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: vector<8xi64>, %arg2: !llvm.ptr, %arg3: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 100 : i64}> : () -> i64
  %13 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %20 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %21 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %22 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %23 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %24 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %25 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %26 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %27 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %28 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %29 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %30 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %31 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %32 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %33 = "llvm.call"(%arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast.99, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %34 = "llvm.and"(%33, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %35 = "llvm.lshr"(%33, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %36 = "llvm.shufflevector"(%35, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %37 = "llvm.call_intrinsic"(%34, %4, %36) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %38 = "llvm.call"(%arg3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast.99, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %39 = "llvm.and"(%38, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %40 = "llvm.lshr"(%38, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %41 = "llvm.shufflevector"(%40, %3) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %42 = "llvm.call_intrinsic"(%39, %4, %41) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.call"(%13, %37, %arg1, %14, %42, %arg3, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  %43 = "llvm.load"(%13) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %44 = "llvm.load"(%14) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%15, %43, %37, %16, %44, %42, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  %45 = "llvm.load"(%15) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %46 = "llvm.load"(%16) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%17, %45, %43, %18, %46, %44, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%20) : (!llvm.ptr) -> ()
  %47 = "llvm.load"(%17) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %48 = "llvm.load"(%18) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%19, %47, %47, %20, %48, %48, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%22) : (!llvm.ptr) -> ()
  %49 = "llvm.load"(%19) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %50 = "llvm.load"(%20) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%21, %49, %49, %22, %50, %50, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%23) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%24) : (!llvm.ptr) -> ()
  %51 = "llvm.load"(%21) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %52 = "llvm.load"(%22) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%23, %51, %51, %24, %52, %52, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%26) : (!llvm.ptr) -> ()
  %53 = "llvm.load"(%23) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %54 = "llvm.load"(%24) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%25, %53, %49, %26, %54, %50, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%27) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%28) : (!llvm.ptr) -> ()
  %55 = "llvm.load"(%25) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %56 = "llvm.load"(%26) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%27, %55, %55, %28, %56, %56, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%29) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%30) : (!llvm.ptr) -> ()
  %57 = "llvm.load"(%27) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %58 = "llvm.load"(%28) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%29, %57, %57, %30, %58, %58, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%31) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%32) : (!llvm.ptr) -> ()
  %59 = "llvm.load"(%29) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %60 = "llvm.load"(%30) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%31, %59, %55, %32, %60, %56, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  %61 = "llvm.load"(%31) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %62 = "llvm.load"(%32) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%arg0, %61, %arg1, %arg2, %62, %arg3, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.end"(%32) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%31) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%30) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%29) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%28) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%27) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%26) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%24) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%23) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_r43x6_sqr_fast.99 := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99,
      @fd_r43x6_sqr_fast.99 := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_99,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2,
      @fd_r43x6_repsqr_mul2 := Firedancer.LaneNI.Mlir.fd_r43x6_repsqr_mul2

end

end Firedancer.LaneNI.Mlir

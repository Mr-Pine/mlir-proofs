
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %4 = "llvm.mlir.constant"() <{value = 512 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %14 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %15 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  %16 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %17 = "llvm.and"(%16, %1) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%17, %15) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %18 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2, %18) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.memset"(%arg0, %3, %4) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 512 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %19 = "llvm.sext"(%arg2) : (i32) -> i64
  %20 = "llvm.add"(%19, %5) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %21 = "llvm.shl"(%5, %20) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %22 = "llvm.add"(%21, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %23 = "llvm.sub"(%7, %19) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%2)[^bb1] : (i64) -> ()
^bb1(%24: i64):  // 2 preds: ^bb0, ^bb15
  %25 = "llvm.lshr"(%24, %8) : (i64, i64) -> i64
  %26 = "llvm.getelementptr"(%15, %25) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %27 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %28 = "llvm.and"(%24, %7) : (i64, i64) -> i64
  %29 = "llvm.lshr"(%27, %28) : (i64, i64) -> i64
  %30 = "llvm.icmp"(%29, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%30, %27, %29, %25, %24)[^bb2, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i64, i64, i64) -> ()
^bb2:  // pred: ^bb1
  %31 = "llvm.icmp"(%25, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%31, %25)[^bb16, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb4
  %32 = "llvm.icmp"(%34, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%32, %34)[^bb16, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb4(%33: i64):  // 2 preds: ^bb2, ^bb3
  %34 = "llvm.add"(%33, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %35 = "llvm.getelementptr"(%15, %34) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %36 = "llvm.load"(%35) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %37 = "llvm.icmp"(%36, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%37)[^bb3, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %38 = "llvm.shl"(%34, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%36, %36, %34, %38)[^bb6] : (i64, i64, i64, i64) -> ()
^bb6(%39: i64, %40: i64, %41: i64, %42: i64):  // 2 preds: ^bb1, ^bb5
  %43 = "llvm.call"(%40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_find_lsb.109, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %44 = "llvm.zext"(%43) <{nonNeg}> : (i32) -> i64
  %45 = "llvm.add"(%42, %44) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %46 = "llvm.and"(%45, %7) : (i64, i64) -> i64
  %47 = "llvm.getelementptr"(%15, %41) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %48 = "llvm.lshr"(%39, %46) : (i64, i64) -> i64
  %49 = "llvm.icmp"(%46, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%49, %48)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // pred: ^bb6
  %50 = "llvm.getelementptr"(%47) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %51 = "llvm.load"(%50) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %52 = "llvm.sub"(%10, %46) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %53 = "llvm.shl"(%51, %52) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %54 = "llvm.or"(%53, %48) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%54)[^bb8] : (i64) -> ()
^bb8(%55: i64):  // 2 preds: ^bb6, ^bb7
  %56 = "llvm.and"(%55, %22) : (i64, i64) -> i64
  %57 = "llvm.shl"(%22, %46) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %58 = "llvm.xor"(%57, %6) : (i64, i64) -> i64
  %59 = "llvm.and"(%39, %58) : (i64, i64) -> i64
  "llvm.store"(%59, %47) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %60 = "llvm.icmp"(%46, %23) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%60)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %61 = "llvm.sub"(%10, %46) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %62 = "llvm.lshr"(%22, %61) : (i64, i64) -> i64
  %63 = "llvm.xor"(%62, %6) : (i64, i64) -> i64
  %64 = "llvm.getelementptr"(%47) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %65 = "llvm.load"(%64) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %66 = "llvm.and"(%65, %63) : (i64, i64) -> i64
  "llvm.store"(%66, %64) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 2 preds: ^bb8, ^bb9
  %67 = "llvm.lshr"(%56, %19) : (i64, i64) -> i64
  %68 = "llvm.icmp"(%67, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%68)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %69 = "llvm.trunc"(%56) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %70 = "llvm.getelementptr"(%arg0, %45) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%69, %70) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %71 = "llvm.add"(%45, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%71)[^bb15] : (i64) -> ()
^bb12:  // pred: ^bb10
  %72 = "llvm.sub"(%56, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %73 = "llvm.trunc"(%72) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %74 = "llvm.getelementptr"(%arg0, %45) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%73, %74) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %75 = "llvm.add"(%45, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.icmp"(%75, %11) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%76)[^bb13, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %77 = "llvm.and"(%75, %7) : (i64, i64) -> i64
  %78 = "llvm.lshr"(%75, %8) : (i64, i64) -> i64
  "llvm.br"(%77, %78)[^bb14] : (i64, i64) -> ()
^bb14(%79: i64, %80: i64):  // 2 preds: ^bb13, ^bb14
  %81 = "llvm.getelementptr"(%15, %80) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %82 = "llvm.load"(%81) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %83 = "llvm.shl"(%5, %79) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %84 = "llvm.add"(%82, %83) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%84, %81) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %85 = "llvm.icmp"(%84, %82) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %86 = "llvm.add"(%80, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %87 = "llvm.icmp"(%80, %12) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %88 = "llvm.select"(%85, %87, %13) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%88, %2, %86, %75)[^bb14, ^bb15] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 1>}> : (i1, i64, i64, i64) -> ()
^bb15(%89: i64):  // 2 preds: ^bb11, ^bb14
  %90 = "llvm.icmp"(%89, %14) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%90, %89)[^bb1, ^bb16] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb16:  // 4 preds: ^bb2, ^bb3, ^bb12, ^bb15
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_ulong_find_lsb.109 := Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109

end

end Firedancer.LaneNI.Mlir


module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
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
  %10 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %16 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  %17 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %18 = "llvm.and"(%17, %1) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%18, %16) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %19 = "llvm.getelementptr"(%16) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2, %19) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.memset"(%arg0, %3, %4) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 512 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %20 = "llvm.sext"(%arg2) : (i32) -> i64
  %21 = "llvm.add"(%20, %5) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %22 = "llvm.shl"(%5, %21) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %23 = "llvm.add"(%22, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %24 = "llvm.sub"(%7, %20) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %25 = "llvm.getelementptr"(%16) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%2)[^bb1] : (i64) -> ()
^bb1(%26: i64):  // 2 preds: ^bb0, ^bb21
  %27 = "llvm.lshr"(%26, %8) : (i64, i64) -> i64
  %28 = "llvm.getelementptr"(%16, %27) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %29 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %30 = "llvm.and"(%26, %7) : (i64, i64) -> i64
  %31 = "llvm.lshr"(%29, %30) : (i64, i64) -> i64
  %32 = "llvm.icmp"(%31, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%32, %29, %31, %27, %26)[^bb2, ^bb9] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i64, i64, i64) -> ()
^bb2:  // pred: ^bb1
  %33 = "llvm.icmp"(%27, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%33)[^bb22, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb7
  %34 = "llvm.icmp"(%44, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%34)[^bb22, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %35 = "llvm.add"(%27, %10) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %36 = "llvm.getelementptr"(%16, %35) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %37 = "llvm.load"(%36) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %38 = "llvm.icmp"(%37, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%38, %35, %37)[^bb5, ^bb8] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb5:  // pred: ^bb4
  %39 = "llvm.icmp"(%35, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%39)[^bb22, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %40 = "llvm.add"(%27, %9) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %41 = "llvm.getelementptr"(%16, %40) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %42 = "llvm.load"(%41) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %43 = "llvm.icmp"(%42, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%43, %40, %42)[^bb22, ^bb8] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb7:  // pred: ^bb2
  %44 = "llvm.add"(%27, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %45 = "llvm.getelementptr"(%16, %44) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %46 = "llvm.load"(%45) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %47 = "llvm.icmp"(%46, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%47, %44, %46)[^bb3, ^bb8] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb8(%48: i64, %49: i64):  // 3 preds: ^bb4, ^bb6, ^bb7
  %50 = "llvm.shl"(%48, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%49, %49, %48, %50)[^bb9] : (i64, i64, i64, i64) -> ()
^bb9(%51: i64, %52: i64, %53: i64, %54: i64):  // 2 preds: ^bb1, ^bb8
  %55 = "llvm.intr.cttz"(%52) <{is_zero_poison = true}> : (i64) -> i64
  %56 = "llvm.add"(%54, %55) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %57 = "llvm.and"(%56, %7) : (i64, i64) -> i64
  %58 = "llvm.getelementptr"(%16, %53) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %59 = "llvm.lshr"(%51, %57) : (i64, i64) -> i64
  %60 = "llvm.icmp"(%57, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%60, %59)[^bb11, ^bb10] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %61 = "llvm.getelementptr"(%58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %62 = "llvm.load"(%61) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %63 = "llvm.sub"(%11, %57) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %64 = "llvm.shl"(%62, %63) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %65 = "llvm.or"(%64, %59) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%65)[^bb11] : (i64) -> ()
^bb11(%66: i64):  // 2 preds: ^bb9, ^bb10
  %67 = "llvm.and"(%66, %23) : (i64, i64) -> i64
  %68 = "llvm.shl"(%23, %57) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %69 = "llvm.xor"(%68, %6) : (i64, i64) -> i64
  %70 = "llvm.and"(%51, %69) : (i64, i64) -> i64
  "llvm.store"(%70, %58) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %71 = "llvm.icmp"(%57, %24) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%71)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %72 = "llvm.sub"(%11, %57) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %73 = "llvm.lshr"(%23, %72) : (i64, i64) -> i64
  %74 = "llvm.xor"(%73, %6) : (i64, i64) -> i64
  %75 = "llvm.getelementptr"(%58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %76 = "llvm.load"(%75) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %77 = "llvm.and"(%76, %74) : (i64, i64) -> i64
  "llvm.store"(%77, %75) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb13] : () -> ()
^bb13:  // 2 preds: ^bb11, ^bb12
  %78 = "llvm.lshr"(%67, %20) : (i64, i64) -> i64
  %79 = "llvm.icmp"(%78, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%79)[^bb14, ^bb15] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %80 = "llvm.trunc"(%67) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %81 = "llvm.getelementptr"(%arg0, %56) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%80, %81) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %82 = "llvm.add"(%56, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%82)[^bb21] : (i64) -> ()
^bb15:  // pred: ^bb13
  %83 = "llvm.sub"(%67, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %84 = "llvm.trunc"(%83) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %85 = "llvm.getelementptr"(%arg0, %56) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%84, %85) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %86 = "llvm.add"(%56, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %87 = "llvm.icmp"(%86, %12) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%87)[^bb16, ^bb22] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb16:  // pred: ^bb15
  %88 = "llvm.and"(%86, %7) : (i64, i64) -> i64
  %89 = "llvm.lshr"(%86, %8) : (i64, i64) -> i64
  %90 = "llvm.getelementptr"(%16, %89) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %91 = "llvm.load"(%90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %92 = "llvm.shl"(%5, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %93 = "llvm.add"(%91, %92) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%93, %90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %94 = "llvm.icmp"(%93, %91) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %95 = "llvm.icmp"(%86, %13) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %96 = "llvm.and"(%94, %95) : (i1, i1) -> i1
  "llvm.cond_br"(%96, %86)[^bb17, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb17:  // pred: ^bb16
  %97 = "llvm.getelementptr"(%16, %89) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %98 = "llvm.getelementptr"(%97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %99 = "llvm.load"(%98) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %100 = "llvm.add"(%99, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%100, %98) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %101 = "llvm.icmp"(%99, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %102 = "llvm.icmp"(%86, %14) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %103 = "llvm.and"(%101, %102) : (i1, i1) -> i1
  "llvm.cond_br"(%103, %86)[^bb18, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb18:  // pred: ^bb17
  %104 = "llvm.getelementptr"(%16, %89) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %105 = "llvm.getelementptr"(%104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %106 = "llvm.load"(%105) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %107 = "llvm.add"(%106, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%107, %105) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %108 = "llvm.icmp"(%106, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %109 = "llvm.icmp"(%86, %15) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %110 = "llvm.and"(%108, %109) : (i1, i1) -> i1
  "llvm.cond_br"(%110, %86)[^bb19, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb19:  // pred: ^bb18
  %111 = "llvm.getelementptr"(%16, %89) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %112 = "llvm.getelementptr"(%111) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %113 = "llvm.load"(%112) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %114 = "llvm.add"(%113, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%114, %112) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %115 = "llvm.icmp"(%113, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %116 = "llvm.icmp"(%89, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %117 = "llvm.and"(%115, %116) : (i1, i1) -> i1
  "llvm.cond_br"(%117, %86)[^bb20, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb20:  // pred: ^bb19
  %118 = "llvm.load"(%25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %119 = "llvm.add"(%118, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%119, %25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%86)[^bb21] : (i64) -> ()
^bb21(%120: i64):  // 6 preds: ^bb14, ^bb16, ^bb17, ^bb18, ^bb19, ^bb20
  %121 = "llvm.icmp"(%120, %13) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%121, %120)[^bb1, ^bb22] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb22:  // 6 preds: ^bb2, ^bb3, ^bb5, ^bb6, ^bb15, ^bb21
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir

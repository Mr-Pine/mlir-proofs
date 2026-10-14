
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_sha512_core_ref
public import Firedancer.Lane.Mlir.fd_sha512_core_ref
public import Firedancer.Lane.Mlir.fd_sha512_core_ref

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_sha512_hash := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, i64, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_hash", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[7640891576956012808, -4942790177534073029, 4354685564936845355, -6534734903238641935, 5840696475078001361, -7276294671716946913, 2270897969802886507, 6620516959819538809]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %7 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 111 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %10 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 112 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 504403158265495552 : i64}> : () -> i64
  %14 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<128 x i8>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.store"(%1, %15) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %16 = "llvm.lshr"(%arg1, %2) : (i64, i64) -> i64
  %17 = "llvm.icmp"(%16, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%17)[^bb2, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%15, %arg0, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %18 = "llvm.and"(%arg1, %4) : (i64, i64) -> i64
  %19 = "llvm.icmp"(%18, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%19)[^bb3, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  "llvm.store"(%6, %14) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%7)[^bb6] : (i64) -> ()
^bb4:  // pred: ^bb2
  %20 = "llvm.and"(%arg1, %5) : (i64, i64) -> i64
  %21 = "llvm.getelementptr"(%arg0, %20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%14, %21, %18) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 1">], arg_attrs = [{llvm.align = 128 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %22 = "llvm.getelementptr"(%14, %18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%6, %22) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %23 = "llvm.add"(%18, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %24 = "llvm.icmp"(%18, %8) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%24, %23)[^bb5, ^bb6] <{branch_weights = array<i32: -2147483648, 0>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb4
  %25 = "llvm.getelementptr"(%14, %23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %26 = "llvm.xor"(%18, %4) : (i64, i64) -> i64
  "llvm.intr.memset"(%25, %9, %26) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {}, {llvm.range = #llvm.constant_range<i64, 129, 113>}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.call"(%15, %14, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%3)[^bb6] : (i64) -> ()
^bb6(%27: i64):  // 3 preds: ^bb3, ^bb4, ^bb5
  %28 = "llvm.shl"(%arg1, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %29 = "llvm.getelementptr"(%14, %27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.sub"(%11, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%29, %9, %30) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {}, {llvm.range = #llvm.constant_range<i64, 129, 113>}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %31 = "llvm.lshr"(%arg1, %12) : (i64, i64) -> i64
  %32 = "llvm.and"(%31, %13) : (i64, i64) -> i64
  %33 = "llvm.getelementptr"(%14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%32, %33) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %34 = "llvm.intr.bswap"(%28) : (i64) -> i64
  %35 = "llvm.getelementptr"(%14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%34, %35) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%15, %14, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %36 = "llvm.load"(%15) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %37 = "llvm.intr.bswap"(%36) : (vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%37, %arg2) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.return"(%arg2) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_sha512_core_ref := Firedancer.Lane.Mlir.fd_sha512_core_ref,
      @fd_sha512_core_ref := Firedancer.Lane.Mlir.fd_sha512_core_ref,
      @fd_sha512_core_ref := Firedancer.Lane.Mlir.fd_sha512_core_ref

end

end Firedancer.Lane.Mlir

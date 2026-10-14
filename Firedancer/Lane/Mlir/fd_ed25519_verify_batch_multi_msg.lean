
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_verify
public import Firedancer.Lane.Mlir.verify_x8

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_verify_batch_multi_msg (batch : MLIR.Vals [.bv 64, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_verify_batch_multi_msg", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: i64):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.icmp"(%arg6, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4, %arg0, %arg6, %arg5, %arg4, %arg3, %arg2, %arg1)[^bb4, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 7>}> : (i1, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb1(%5: !llvm.ptr, %6: i64, %7: !llvm.ptr, %8: !llvm.ptr, %9: !llvm.ptr, %10: !llvm.ptr, %11: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
  %12 = "llvm.icmp"(%6, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%12, %0)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb2(%13: i64):  // 2 preds: ^bb1, ^bb2
  %14 = "llvm.getelementptr"(%5, %13) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %15 = "llvm.load"(%14) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %16 = "llvm.getelementptr"(%11, %13) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %17 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %18 = "llvm.getelementptr"(%10, %13) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %20 = "llvm.getelementptr"(%9, %13) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %21 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.getelementptr"(%8, %13) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %23 = "llvm.load"(%22) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.call"(%15, %17, %19, %21, %23) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %25 = "llvm.getelementptr"(%7, %13) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%24, %25) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %26 = "llvm.add"(%13, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %27 = "llvm.icmp"(%26, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27, %26)[^bb4, ^bb2] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb1
  %28 = "llvm.intr.umin"(%6, %2) : (i64, i64) -> i64
  "llvm.call"(%5, %11, %10, %9, %8, %7, %28) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @verify_x8, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
  %29 = "llvm.getelementptr"(%5, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.getelementptr"(%11, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.getelementptr"(%10, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %32 = "llvm.getelementptr"(%9, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %33 = "llvm.getelementptr"(%8, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %34 = "llvm.getelementptr"(%7, %28) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %35 = "llvm.sub"(%6, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %36 = "llvm.icmp"(%35, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%36, %29, %35, %34, %33, %32, %31, %30)[^bb4, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 7>}> : (i1, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb4:  // 3 preds: ^bb0, ^bb2, ^bb3
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_ed25519_verify := Firedancer.Lane.Mlir.fd_ed25519_verify,
      @verify_x8 := Firedancer.Lane.Mlir.verify_x8 batch

end

end Firedancer.Lane.Mlir

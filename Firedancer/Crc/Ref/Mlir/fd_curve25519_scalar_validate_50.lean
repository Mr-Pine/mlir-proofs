
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow_51
public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow_51
public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow_51
public import Firedancer.Crc.Ref.Mlir.fd_ulong_sub_borrow_51

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_validate_50 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_curve25519_scalar_validate.50", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %2 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %3 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %4 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %11 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.load"(%11) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %13 = "llvm.icmp"(%12, %1) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%13, %arg0)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %14 = "llvm.icmp"(%12, %2) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%14, %3)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %15 = "llvm.load"(%arg0) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %16 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %17 = "llvm.load"(%16) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %18 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %20 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.load"(%20) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  "llvm.call"(%9, %10, %15, %4, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_sub_borrow.51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i64, i64, i32) -> ()
  %22 = "llvm.load"(%10) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  "llvm.call"(%9, %10, %17, %5, %22) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_sub_borrow.51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i64, i64, i32) -> ()
  %23 = "llvm.load"(%10) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  "llvm.call"(%9, %10, %19, %6, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_sub_borrow.51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i64, i64, i32) -> ()
  %24 = "llvm.load"(%10) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  "llvm.call"(%9, %10, %21, %7, %24) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_sub_borrow.51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i64, i64, i32) -> ()
  %25 = "llvm.load"(%10) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %26 = "llvm.icmp"(%25, %8) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %27 = "llvm.select"(%26, %3, %arg0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.br"(%27)[^bb3] : (!llvm.ptr) -> ()
^bb3(%28: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%28) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ulong_sub_borrow.51 := MLIR.Firedancer.Crc.Ref.fd_ulong_sub_borrow_51,
      @fd_ulong_sub_borrow.51 := MLIR.Firedancer.Crc.Ref.fd_ulong_sub_borrow_51,
      @fd_ulong_sub_borrow.51 := MLIR.Firedancer.Crc.Ref.fd_ulong_sub_borrow_51,
      @fd_ulong_sub_borrow.51 := MLIR.Firedancer.Crc.Ref.fd_ulong_sub_borrow_51

end

end MLIR.Firedancer.Crc.Ref

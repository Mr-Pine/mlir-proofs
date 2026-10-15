
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_f25519_one
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54
public import Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var
public import Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_is_square_var := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_f25519_is_square_var", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = dense<[4, 6]> : vector<2xi64>}> : () -> vector<2xi64>
  %5 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %6 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<4611686018427387903> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %10 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  %14 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %15 = "llvm.call"(%11, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_f25519_tobytes.54, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> !llvm.ptr
  %16 = "llvm.load"(%11) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %17 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %20 = "llvm.load"(%18) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %21 = "llvm.extractelement"(%19, %1) : (vector<2xi64>, i64) -> i64
  %22 = "llvm.extractelement"(%20, %1) : (vector<2xi64>, i64) -> i64
  %23 = "llvm.or"(%16, %22) : (i64, i64) -> i64
  %24 = "llvm.or"(%23, %21) : (i64, i64) -> i64
  %25 = "llvm.extractelement"(%20, %2) : (vector<2xi64>, i64) -> i64
  %26 = "llvm.or"(%24, %25) : (i64, i64) -> i64
  %27 = "llvm.icmp"(%26, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27, %0)[^bb5, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  %28 = "llvm.intr.fshl"(%21, %16, %3) : (i64, i64, i64) -> i64
  %29 = "llvm.intr.fshl"(%20, %19, %4) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %30 = "llvm.insertelement"(%5, %16, %1) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %31 = "llvm.insertelement"(%30, %28, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %32 = "llvm.shufflevector"(%29, %6) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %33 = "llvm.shufflevector"(%31, %32) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %34 = "llvm.and"(%33, %7) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%34, %12) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %35 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %36 = "llvm.lshr"(%25, %8) : (i64, i64) -> i64
  "llvm.store"(%36, %35) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %37 = "llvm.call"(%12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_jacobi_var, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %38 = "llvm.icmp"(%37, %9) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%38)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  %39 = "llvm.call"(%13, %arg0, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.br"(%39)[^bb4] : (i32) -> ()
^bb3:  // pred: ^bb1
  %40 = "llvm.icmp"(%37, %9) <{predicate = 4 : i64}> : (i32, i32) -> i1
  %41 = "llvm.zext"(%40) : (i1) -> i32
  "llvm.br"(%41)[^bb4] : (i32) -> ()
^bb4(%42: i32):  // 2 preds: ^bb2, ^bb3
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.br"(%42)[^bb5] : (i32) -> ()
^bb5(%43: i32):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.return"(%43) : (i32) -> ()
}) : () -> ()

    with
      @fd_f25519_one := Firedancer.LaneNI.Mlir.fd_f25519_one,
      @fd_f25519_tobytes.54 := Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54,
      @fd_f25519_jacobi_var := Firedancer.LaneNI.Mlir.fd_f25519_jacobi_var,
      @fd_f25519_sqrt_ratio := Firedancer.LaneNI.Mlir.fd_f25519_sqrt_ratio

end

end Firedancer.LaneNI.Mlir

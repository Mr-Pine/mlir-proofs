
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_sha512_init
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_fini
public import Firedancer.LaneNI.Mlir.fd_sha512_init
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_fini
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_ed25519_scalar_mul_base_tobytes
public import Firedancer.LaneNI.Mlir.fd_sha512_init
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_fini
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_muladd
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit_134
public import Firedancer.LaneNI.Mlir.fd_memzero_explicit_134
public import Firedancer.LaneNI.Mlir.fd_sha512_clear

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_sign := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_sign", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.poison"() : () -> vector<32xi8>
  %3 = "llvm.mlir.constant"() <{value = dense<[-8, 63]> : vector<2xi8>}> : () -> vector<2xi8>
  %4 = "llvm.mlir.constant"() <{value = dense<[0, 64]> : vector<2xi8>}> : () -> vector<2xi8>
  %5 = "llvm.mlir.poison"() : () -> vector<2xi8>
  %6 = "llvm.mlir.constant"() <{value = dense<[true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]> : vector<32xi1>}> : () -> vector<32xi1>
  %7 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %8 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  %11 = "llvm.call"(%arg5) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.call"(%11, %arg4, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %13 = "llvm.call"(%12, %8) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %14 = "llvm.load"(%8) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<32xi8>
  %15 = "llvm.shufflevector"(%14, %2) <{mask = array<i32: 0, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<2xi8>
  %16 = "llvm.and"(%15, %3) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %17 = "llvm.or"(%16, %4) <{isDisjoint}> : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %18 = "llvm.shufflevector"(%17, %5) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1>}> : (vector<2xi8>, vector<2xi8>) -> vector<32xi8>
  "llvm.intr.masked.store"(%18, %8, %6) <{alignment = 16 : i32}> : (vector<32xi8>, !llvm.ptr, vector<32xi1>) -> ()
  %19 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  %20 = "llvm.call"(%arg5) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.call"(%20, %19, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %22 = "llvm.call"(%21, %arg1, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %23 = "llvm.call"(%22, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %24 = "llvm.call"(%9, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg0, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_scalar_mul_base_tobytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  %25 = "llvm.call"(%arg5) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %26 = "llvm.call"(%25, %arg0, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %27 = "llvm.call"(%26, %arg3, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %28 = "llvm.call"(%27, %arg1, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %29 = "llvm.call"(%28, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %30 = "llvm.call"(%10, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %31 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %32 = "llvm.call"(%31, %10, %8, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_muladd, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%8, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit.134, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%9, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memzero_explicit.134, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%arg5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_clear, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_sha512_init := Firedancer.LaneNI.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.LaneNI.Mlir.fd_sha512_fini,
      @fd_sha512_init := Firedancer.LaneNI.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.LaneNI.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_scalar_mul_base_tobytes := Firedancer.LaneNI.Mlir.fd_ed25519_scalar_mul_base_tobytes,
      @fd_sha512_init := Firedancer.LaneNI.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.LaneNI.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_curve25519_scalar_muladd := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_muladd,
      @fd_memzero_explicit.134 := Firedancer.LaneNI.Mlir.fd_memzero_explicit_134,
      @fd_memzero_explicit.134 := Firedancer.LaneNI.Mlir.fd_memzero_explicit_134,
      @fd_sha512_clear := Firedancer.LaneNI.Mlir.fd_sha512_clear

end

end Firedancer.LaneNI.Mlir

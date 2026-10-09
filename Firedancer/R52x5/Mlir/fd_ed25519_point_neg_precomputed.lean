module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_point_neg_precomputed.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.wc_bcast_wide
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.wc_bcast_wide
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_point_neg_precomputed :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_point_neg_precomputed", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg1: !llvm.ptr, %arg2: !llvm.ptr):
  %3 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %12 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %13 = "llvm.call"(%12, %3, %4, %5, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.store"(%13, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %14 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %15 = "llvm.load"(%14) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %16 = "llvm.call"(%15, %3, %4, %5, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %17 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%16, %17) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %18 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %20 = "llvm.call"(%19, %3, %4, %5, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %21 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%20, %21) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %22 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %23 = "llvm.load"(%22) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %24 = "llvm.call"(%23, %3, %4, %5, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %25 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%24, %25) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %26 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %27 = "llvm.load"(%26) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %28 = "llvm.call"(%27, %3, %4, %5, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %29 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%28, %29) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %30 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %31 = "llvm.sub"(%7, %30) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %32 = "llvm.load"(%14) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %33 = "llvm.sub"(%8, %32) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %34 = "llvm.load"(%18) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %35 = "llvm.sub"(%8, %34) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %36 = "llvm.load"(%22) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %37 = "llvm.sub"(%8, %36) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %38 = "llvm.load"(%26) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %39 = "llvm.sub"(%8, %38) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %40 = "llvm.lshr"(%31, %9) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %41 = "llvm.lshr"(%33, %9) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %42 = "llvm.lshr"(%35, %9) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %43 = "llvm.lshr"(%37, %9) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %44 = "llvm.lshr"(%39, %9) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %45 = "llvm.and"(%31, %10) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %46 = "llvm.call_intrinsic"(%45, %44, %11) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %47 = "llvm.and"(%33, %10) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %48 = "llvm.add"(%47, %40) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %49 = "llvm.and"(%35, %10) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %50 = "llvm.add"(%49, %41) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %51 = "llvm.and"(%37, %10) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %52 = "llvm.add"(%51, %42) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %53 = "llvm.and"(%39, %10) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %54 = "llvm.add"(%53, %43) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %55 = "llvm.call"(%4, %4, %4, %3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %56 = "llvm.bitcast"(%13) : (vector<4xi64>) -> vector<32xi8>
  %57 = "llvm.bitcast"(%46) : (vector<4xi64>) -> vector<32xi8>
  %58 = "llvm.bitcast"(%55) : (vector<4xi64>) -> vector<32xi8>
  %59 = "llvm.call_intrinsic"(%56, %57, %58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%59, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %60 = "llvm.bitcast"(%16) : (vector<4xi64>) -> vector<32xi8>
  %61 = "llvm.bitcast"(%48) : (vector<4xi64>) -> vector<32xi8>
  %62 = "llvm.call_intrinsic"(%60, %61, %58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%62, %17) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %63 = "llvm.bitcast"(%20) : (vector<4xi64>) -> vector<32xi8>
  %64 = "llvm.bitcast"(%50) : (vector<4xi64>) -> vector<32xi8>
  %65 = "llvm.call_intrinsic"(%63, %64, %58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%65, %21) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %66 = "llvm.bitcast"(%24) : (vector<4xi64>) -> vector<32xi8>
  %67 = "llvm.bitcast"(%52) : (vector<4xi64>) -> vector<32xi8>
  %68 = "llvm.call_intrinsic"(%66, %67, %58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%68, %25) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %69 = "llvm.bitcast"(%28) : (vector<4xi64>) -> vector<32xi8>
  %70 = "llvm.bitcast"(%54) : (vector<4xi64>) -> vector<32xi8>
  %71 = "llvm.call_intrinsic"(%69, %70, %58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%71, %29) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.return"(%arg1) : (!llvm.ptr) -> ()
}) : () -> ()
  with @wc_bcast_wide := wc_bcast_wide, @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5

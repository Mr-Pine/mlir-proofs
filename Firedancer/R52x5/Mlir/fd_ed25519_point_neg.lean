module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_point_neg.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.wc_bcast_wide

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.wc_bcast_wide

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_point_neg :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_point_neg", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg136: !llvm.ptr, %arg137: !llvm.ptr):
  %3996 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %3997 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %3998 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %3999 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %4000 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %4001 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4002 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4003 = "llvm.load"(%arg137) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4004 = "llvm.sub"(%3996, %4003) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4005 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %4006 = "llvm.load"(%4005) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4007 = "llvm.sub"(%3997, %4006) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4008 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4009 = "llvm.load"(%4008) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4010 = "llvm.sub"(%3997, %4009) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4011 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %4012 = "llvm.load"(%4011) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4013 = "llvm.sub"(%3997, %4012) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4014 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %4015 = "llvm.load"(%4014) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4016 = "llvm.sub"(%3997, %4015) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4017 = "llvm.lshr"(%4004, %3998) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4018 = "llvm.lshr"(%4007, %3998) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4019 = "llvm.lshr"(%4010, %3998) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4020 = "llvm.lshr"(%4013, %3998) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4021 = "llvm.lshr"(%4016, %3998) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4022 = "llvm.and"(%4004, %3999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4023 = "llvm.call_intrinsic"(%4022, %4021, %4000) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4024 = "llvm.and"(%4007, %3999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4025 = "llvm.add"(%4024, %4017) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4026 = "llvm.and"(%4010, %3999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4027 = "llvm.add"(%4026, %4018) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4028 = "llvm.and"(%4013, %3999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4029 = "llvm.add"(%4028, %4019) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4030 = "llvm.and"(%4016, %3999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4031 = "llvm.add"(%4030, %4020) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4032 = "llvm.call"(%4001, %4002, %4002, %4001) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %4033 = "llvm.bitcast"(%4003) : (vector<4xi64>) -> vector<32xi8>
  %4034 = "llvm.bitcast"(%4023) : (vector<4xi64>) -> vector<32xi8>
  %4035 = "llvm.bitcast"(%4032) : (vector<4xi64>) -> vector<32xi8>
  %4036 = "llvm.call_intrinsic"(%4033, %4034, %4035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%4036, %arg136) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %4037 = "llvm.load"(%4005) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<32xi8>
  %4038 = "llvm.bitcast"(%4025) : (vector<4xi64>) -> vector<32xi8>
  %4039 = "llvm.call_intrinsic"(%4037, %4038, %4035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4040 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4039, %4040) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %4041 = "llvm.load"(%4008) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<32xi8>
  %4042 = "llvm.bitcast"(%4027) : (vector<4xi64>) -> vector<32xi8>
  %4043 = "llvm.call_intrinsic"(%4041, %4042, %4035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4044 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4043, %4044) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %4045 = "llvm.load"(%4011) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<32xi8>
  %4046 = "llvm.bitcast"(%4029) : (vector<4xi64>) -> vector<32xi8>
  %4047 = "llvm.call_intrinsic"(%4045, %4046, %4035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4048 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4047, %4048) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %4049 = "llvm.load"(%4014) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<32xi8>
  %4050 = "llvm.bitcast"(%4031) : (vector<4xi64>) -> vector<32xi8>
  %4051 = "llvm.call_intrinsic"(%4049, %4050, %4035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4052 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4051, %4052) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.return"(%arg136) : (!llvm.ptr) -> ()
}) : () -> ()
  with @wc_bcast_wide := wc_bcast_wide

end

end MLIR.Firedancer.R52x5

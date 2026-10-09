module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_point_dbln.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
public import Firedancer.R52x5.Mlir.wc_bcast_wide
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
meta import Firedancer.R52x5.Mlir.wc_bcast_wide
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_point_dbln :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_dbln", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg146: !llvm.ptr, %arg147: !llvm.ptr, %arg148: i32):
  %4137 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4138 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4139 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %4140 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %4141 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %4142 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %4143 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %4144 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %4145 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %4146 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %4147 = "llvm.mlir.constant"() <{value = dense<0> : vector<32xi8>}> : () -> vector<32xi8>
  %4148 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %4149 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4150 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4151 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4152 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4153 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4154 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4155 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4156 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4157 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4158 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4159 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4160 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4161 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4162 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4163 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4164 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4165 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4166 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4167 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4168 = "llvm.alloca"(%4137) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %4169 = "llvm.load"(%arg147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4170 = "llvm.call"(%4169, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4171 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %4172 = "llvm.load"(%4171) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4173 = "llvm.call"(%4172, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4174 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4175 = "llvm.load"(%4174) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4176 = "llvm.call"(%4175, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4177 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %4178 = "llvm.load"(%4177) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4179 = "llvm.call"(%4178, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4180 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %4181 = "llvm.load"(%4180) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4182 = "llvm.call"(%4181, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4183 = "llvm.add"(%4170, %4169) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4184 = "llvm.add"(%4173, %4172) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4185 = "llvm.add"(%4176, %4175) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4186 = "llvm.add"(%4179, %4178) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4187 = "llvm.add"(%4182, %4181) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4188 = "llvm.call"(%4183, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4189 = "llvm.call"(%4184, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4190 = "llvm.call"(%4185, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4191 = "llvm.call"(%4186, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4192 = "llvm.call"(%4187, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4193 = "llvm.call"(%4138, %4138, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %4194 = "llvm.bitcast"(%4169) : (vector<4xi64>) -> vector<32xi8>
  %4195 = "llvm.bitcast"(%4188) : (vector<4xi64>) -> vector<32xi8>
  %4196 = "llvm.bitcast"(%4193) : (vector<4xi64>) -> vector<32xi8>
  %4197 = "llvm.call_intrinsic"(%4194, %4195, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4198 = "llvm.bitcast"(%4197) : (vector<32xi8>) -> vector<4xi64>
  %4199 = "llvm.bitcast"(%4172) : (vector<4xi64>) -> vector<32xi8>
  %4200 = "llvm.bitcast"(%4189) : (vector<4xi64>) -> vector<32xi8>
  %4201 = "llvm.call_intrinsic"(%4199, %4200, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4202 = "llvm.bitcast"(%4201) : (vector<32xi8>) -> vector<4xi64>
  %4203 = "llvm.bitcast"(%4175) : (vector<4xi64>) -> vector<32xi8>
  %4204 = "llvm.bitcast"(%4190) : (vector<4xi64>) -> vector<32xi8>
  %4205 = "llvm.call_intrinsic"(%4203, %4204, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4206 = "llvm.bitcast"(%4205) : (vector<32xi8>) -> vector<4xi64>
  %4207 = "llvm.bitcast"(%4178) : (vector<4xi64>) -> vector<32xi8>
  %4208 = "llvm.bitcast"(%4191) : (vector<4xi64>) -> vector<32xi8>
  %4209 = "llvm.call_intrinsic"(%4207, %4208, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4210 = "llvm.bitcast"(%4209) : (vector<32xi8>) -> vector<4xi64>
  %4211 = "llvm.bitcast"(%4181) : (vector<4xi64>) -> vector<32xi8>
  %4212 = "llvm.bitcast"(%4192) : (vector<4xi64>) -> vector<32xi8>
  %4213 = "llvm.call_intrinsic"(%4211, %4212, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4214 = "llvm.bitcast"(%4213) : (vector<32xi8>) -> vector<4xi64>
  %4215 = "llvm.lshr"(%4198, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4216 = "llvm.lshr"(%4202, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4217 = "llvm.lshr"(%4206, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4218 = "llvm.lshr"(%4210, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4219 = "llvm.lshr"(%4214, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4220 = "llvm.bitcast"(%4197) : (vector<32xi8>) -> vector<4xi64>
  %4221 = "llvm.and"(%4220, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4222 = "llvm.call_intrinsic"(%4221, %4219, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4223 = "llvm.bitcast"(%4201) : (vector<32xi8>) -> vector<4xi64>
  %4224 = "llvm.and"(%4223, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4225 = "llvm.add"(%4224, %4215) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4226 = "llvm.bitcast"(%4205) : (vector<32xi8>) -> vector<4xi64>
  %4227 = "llvm.and"(%4226, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4228 = "llvm.add"(%4227, %4216) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4229 = "llvm.bitcast"(%4209) : (vector<32xi8>) -> vector<4xi64>
  %4230 = "llvm.and"(%4229, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4231 = "llvm.add"(%4230, %4217) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4232 = "llvm.bitcast"(%4213) : (vector<32xi8>) -> vector<4xi64>
  %4233 = "llvm.and"(%4232, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4234 = "llvm.add"(%4233, %4218) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%4149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4150) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4152) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4153) : (!llvm.ptr) -> ()
  "llvm.call"(%4149, %4150, %4151, %4152, %4153, %4222, %4225, %4228, %4231, %4234) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %4235 = "llvm.load"(%4149) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4236 = "llvm.load"(%4150) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4237 = "llvm.load"(%4151) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4238 = "llvm.load"(%4152) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4239 = "llvm.load"(%4153) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%4153) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4152) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4150) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4149) : (!llvm.ptr) -> ()
  %4240 = "llvm.call"(%4235, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4241 = "llvm.call"(%4236, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4242 = "llvm.call"(%4237, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4243 = "llvm.call"(%4238, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4244 = "llvm.call"(%4239, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4245 = "llvm.call"(%4235, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4246 = "llvm.call"(%4236, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4247 = "llvm.call"(%4237, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4248 = "llvm.call"(%4238, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4249 = "llvm.call"(%4239, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4250 = "llvm.bitcast"(%4245) : (vector<4xi64>) -> vector<32xi8>
  %4251 = "llvm.bitcast"(%4235) : (vector<4xi64>) -> vector<32xi8>
  %4252 = "llvm.call_intrinsic"(%4250, %4251, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4253 = "llvm.bitcast"(%4252) : (vector<32xi8>) -> vector<4xi64>
  %4254 = "llvm.bitcast"(%4246) : (vector<4xi64>) -> vector<32xi8>
  %4255 = "llvm.bitcast"(%4236) : (vector<4xi64>) -> vector<32xi8>
  %4256 = "llvm.call_intrinsic"(%4254, %4255, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4257 = "llvm.bitcast"(%4256) : (vector<32xi8>) -> vector<4xi64>
  %4258 = "llvm.bitcast"(%4247) : (vector<4xi64>) -> vector<32xi8>
  %4259 = "llvm.bitcast"(%4237) : (vector<4xi64>) -> vector<32xi8>
  %4260 = "llvm.call_intrinsic"(%4258, %4259, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4261 = "llvm.bitcast"(%4260) : (vector<32xi8>) -> vector<4xi64>
  %4262 = "llvm.bitcast"(%4248) : (vector<4xi64>) -> vector<32xi8>
  %4263 = "llvm.bitcast"(%4238) : (vector<4xi64>) -> vector<32xi8>
  %4264 = "llvm.call_intrinsic"(%4262, %4263, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4265 = "llvm.bitcast"(%4264) : (vector<32xi8>) -> vector<4xi64>
  %4266 = "llvm.bitcast"(%4249) : (vector<4xi64>) -> vector<32xi8>
  %4267 = "llvm.bitcast"(%4239) : (vector<4xi64>) -> vector<32xi8>
  %4268 = "llvm.call_intrinsic"(%4266, %4267, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4269 = "llvm.bitcast"(%4268) : (vector<32xi8>) -> vector<4xi64>
  %4270 = "llvm.sub"(%4144, %4253) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4271 = "llvm.sub"(%4145, %4257) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4272 = "llvm.sub"(%4145, %4261) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4273 = "llvm.sub"(%4145, %4265) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4274 = "llvm.sub"(%4145, %4269) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4275 = "llvm.shl"(%4235, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4276 = "llvm.shl"(%4236, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4277 = "llvm.shl"(%4237, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4278 = "llvm.shl"(%4238, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4279 = "llvm.shl"(%4239, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4280 = "llvm.call"(%4138, %4138, %4137, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %4281 = "llvm.bitcast"(%4275) : (vector<4xi64>) -> vector<32xi8>
  %4282 = "llvm.bitcast"(%4280) : (vector<4xi64>) -> vector<32xi8>
  %4283 = "llvm.call_intrinsic"(%4147, %4281, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4284 = "llvm.bitcast"(%4283) : (vector<32xi8>) -> vector<4xi64>
  %4285 = "llvm.bitcast"(%4276) : (vector<4xi64>) -> vector<32xi8>
  %4286 = "llvm.call_intrinsic"(%4147, %4285, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4287 = "llvm.bitcast"(%4286) : (vector<32xi8>) -> vector<4xi64>
  %4288 = "llvm.bitcast"(%4277) : (vector<4xi64>) -> vector<32xi8>
  %4289 = "llvm.call_intrinsic"(%4147, %4288, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4290 = "llvm.bitcast"(%4289) : (vector<32xi8>) -> vector<4xi64>
  %4291 = "llvm.bitcast"(%4278) : (vector<4xi64>) -> vector<32xi8>
  %4292 = "llvm.call_intrinsic"(%4147, %4291, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4293 = "llvm.bitcast"(%4292) : (vector<32xi8>) -> vector<4xi64>
  %4294 = "llvm.bitcast"(%4279) : (vector<4xi64>) -> vector<32xi8>
  %4295 = "llvm.call_intrinsic"(%4147, %4294, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4296 = "llvm.bitcast"(%4295) : (vector<32xi8>) -> vector<4xi64>
  %4297 = "llvm.add"(%4240, %4284) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4298 = "llvm.add"(%4241, %4287) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4299 = "llvm.add"(%4242, %4290) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4300 = "llvm.add"(%4243, %4293) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4301 = "llvm.add"(%4244, %4296) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4302 = "llvm.call"(%4137, %4138, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %4303 = "llvm.bitcast"(%4302) : (vector<4xi64>) -> vector<32xi8>
  %4304 = "llvm.call_intrinsic"(%4147, %4250, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4305 = "llvm.bitcast"(%4304) : (vector<32xi8>) -> vector<4xi64>
  %4306 = "llvm.call_intrinsic"(%4147, %4254, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4307 = "llvm.bitcast"(%4306) : (vector<32xi8>) -> vector<4xi64>
  %4308 = "llvm.call_intrinsic"(%4147, %4258, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4309 = "llvm.bitcast"(%4308) : (vector<32xi8>) -> vector<4xi64>
  %4310 = "llvm.call_intrinsic"(%4147, %4262, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4311 = "llvm.bitcast"(%4310) : (vector<32xi8>) -> vector<4xi64>
  %4312 = "llvm.call_intrinsic"(%4147, %4266, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4313 = "llvm.bitcast"(%4312) : (vector<32xi8>) -> vector<4xi64>
  %4314 = "llvm.add"(%4297, %4305) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4315 = "llvm.add"(%4298, %4307) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4316 = "llvm.add"(%4299, %4309) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4317 = "llvm.add"(%4300, %4311) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4318 = "llvm.add"(%4301, %4313) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4319 = "llvm.call"(%4138, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %4320 = "llvm.bitcast"(%4270) : (vector<4xi64>) -> vector<32xi8>
  %4321 = "llvm.bitcast"(%4319) : (vector<4xi64>) -> vector<32xi8>
  %4322 = "llvm.call_intrinsic"(%4147, %4320, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4323 = "llvm.bitcast"(%4322) : (vector<32xi8>) -> vector<4xi64>
  %4324 = "llvm.bitcast"(%4271) : (vector<4xi64>) -> vector<32xi8>
  %4325 = "llvm.call_intrinsic"(%4147, %4324, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4326 = "llvm.bitcast"(%4325) : (vector<32xi8>) -> vector<4xi64>
  %4327 = "llvm.bitcast"(%4272) : (vector<4xi64>) -> vector<32xi8>
  %4328 = "llvm.call_intrinsic"(%4147, %4327, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4329 = "llvm.bitcast"(%4328) : (vector<32xi8>) -> vector<4xi64>
  %4330 = "llvm.bitcast"(%4273) : (vector<4xi64>) -> vector<32xi8>
  %4331 = "llvm.call_intrinsic"(%4147, %4330, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4332 = "llvm.bitcast"(%4331) : (vector<32xi8>) -> vector<4xi64>
  %4333 = "llvm.bitcast"(%4274) : (vector<4xi64>) -> vector<32xi8>
  %4334 = "llvm.call_intrinsic"(%4147, %4333, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4335 = "llvm.bitcast"(%4334) : (vector<32xi8>) -> vector<4xi64>
  %4336 = "llvm.add"(%4314, %4323) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4337 = "llvm.add"(%4315, %4326) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4338 = "llvm.add"(%4316, %4329) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4339 = "llvm.add"(%4317, %4332) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4340 = "llvm.add"(%4318, %4335) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4341 = "llvm.lshr"(%4336, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4342 = "llvm.lshr"(%4337, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4343 = "llvm.lshr"(%4338, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4344 = "llvm.lshr"(%4339, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4345 = "llvm.lshr"(%4340, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4346 = "llvm.and"(%4336, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4347 = "llvm.call_intrinsic"(%4346, %4345, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4348 = "llvm.and"(%4337, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4349 = "llvm.add"(%4348, %4341) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4350 = "llvm.and"(%4338, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4351 = "llvm.add"(%4350, %4342) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4352 = "llvm.and"(%4339, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4353 = "llvm.add"(%4352, %4343) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4354 = "llvm.and"(%4340, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4355 = "llvm.add"(%4354, %4344) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4356 = "llvm.call"(%4347, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4357 = "llvm.call"(%4349, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4358 = "llvm.call"(%4351, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4359 = "llvm.call"(%4353, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4360 = "llvm.call"(%4355, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4361 = "llvm.call"(%4347, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4362 = "llvm.call"(%4349, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4363 = "llvm.call"(%4351, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4364 = "llvm.call"(%4353, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4365 = "llvm.call"(%4355, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%4154) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4158) : (!llvm.ptr) -> ()
  "llvm.call"(%4154, %4155, %4156, %4157, %4158, %4361, %4362, %4363, %4364, %4365, %4356, %4357, %4358, %4359, %4360) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %4366 = "llvm.load"(%4154) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4367 = "llvm.load"(%4155) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4368 = "llvm.getelementptr"(%arg146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %4369 = "llvm.load"(%4156) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4370 = "llvm.getelementptr"(%arg146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4371 = "llvm.load"(%4157) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4372 = "llvm.getelementptr"(%arg146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %4373 = "llvm.load"(%4158) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4374 = "llvm.getelementptr"(%arg146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%4158) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4154) : (!llvm.ptr) -> ()
  %4375 = "llvm.lshr"(%4366, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4376 = "llvm.lshr"(%4367, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4377 = "llvm.lshr"(%4369, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4378 = "llvm.lshr"(%4371, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4379 = "llvm.lshr"(%4373, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4380 = "llvm.and"(%4366, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4381 = "llvm.call_intrinsic"(%4380, %4379, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%4381, %arg146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %4382 = "llvm.and"(%4367, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4383 = "llvm.add"(%4382, %4375) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%4383, %4368) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %4384 = "llvm.and"(%4369, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4385 = "llvm.add"(%4384, %4376) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%4385, %4370) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %4386 = "llvm.and"(%4371, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4387 = "llvm.add"(%4386, %4377) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%4387, %4372) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %4388 = "llvm.and"(%4373, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4389 = "llvm.add"(%4388, %4378) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%4389, %4374) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %4390 = "llvm.icmp"(%arg148, %4137) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%4390, %4389, %4387, %4385, %4383, %4381, %4148)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 6, 0>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i8) -> ()
^bb1:  // pred: ^bb3
  "llvm.store"(%4588, %arg146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%4590, %4368) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%4592, %4370) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%4594, %4372) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%4596, %4374) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg146) : (!llvm.ptr) -> ()
^bb3(%4391: vector<4xi64>, %4392: vector<4xi64>, %4393: vector<4xi64>, %4394: vector<4xi64>, %4395: vector<4xi64>, %4396: i8):  // 2 preds: ^bb0, ^bb3
  %4397 = "llvm.call"(%4395, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4398 = "llvm.call"(%4394, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4399 = "llvm.call"(%4393, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4400 = "llvm.call"(%4392, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4401 = "llvm.call"(%4391, %4137, %4138, %4139, %4140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4402 = "llvm.add"(%4397, %4395) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4403 = "llvm.add"(%4398, %4394) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4404 = "llvm.add"(%4399, %4393) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4405 = "llvm.add"(%4400, %4392) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4406 = "llvm.add"(%4401, %4391) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4407 = "llvm.call"(%4402, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4408 = "llvm.call"(%4403, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4409 = "llvm.call"(%4404, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4410 = "llvm.call"(%4405, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4411 = "llvm.call"(%4406, %4138, %4137, %4138, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4412 = "llvm.bitcast"(%4395) : (vector<4xi64>) -> vector<32xi8>
  %4413 = "llvm.bitcast"(%4407) : (vector<4xi64>) -> vector<32xi8>
  %4414 = "llvm.call_intrinsic"(%4412, %4413, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4415 = "llvm.bitcast"(%4414) : (vector<32xi8>) -> vector<4xi64>
  %4416 = "llvm.bitcast"(%4394) : (vector<4xi64>) -> vector<32xi8>
  %4417 = "llvm.bitcast"(%4408) : (vector<4xi64>) -> vector<32xi8>
  %4418 = "llvm.call_intrinsic"(%4416, %4417, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4419 = "llvm.bitcast"(%4418) : (vector<32xi8>) -> vector<4xi64>
  %4420 = "llvm.bitcast"(%4393) : (vector<4xi64>) -> vector<32xi8>
  %4421 = "llvm.bitcast"(%4409) : (vector<4xi64>) -> vector<32xi8>
  %4422 = "llvm.call_intrinsic"(%4420, %4421, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4423 = "llvm.bitcast"(%4422) : (vector<32xi8>) -> vector<4xi64>
  %4424 = "llvm.bitcast"(%4392) : (vector<4xi64>) -> vector<32xi8>
  %4425 = "llvm.bitcast"(%4410) : (vector<4xi64>) -> vector<32xi8>
  %4426 = "llvm.call_intrinsic"(%4424, %4425, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4427 = "llvm.bitcast"(%4426) : (vector<32xi8>) -> vector<4xi64>
  %4428 = "llvm.bitcast"(%4391) : (vector<4xi64>) -> vector<32xi8>
  %4429 = "llvm.bitcast"(%4411) : (vector<4xi64>) -> vector<32xi8>
  %4430 = "llvm.call_intrinsic"(%4428, %4429, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4431 = "llvm.bitcast"(%4430) : (vector<32xi8>) -> vector<4xi64>
  %4432 = "llvm.lshr"(%4415, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4433 = "llvm.lshr"(%4419, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4434 = "llvm.lshr"(%4423, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4435 = "llvm.lshr"(%4427, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4436 = "llvm.lshr"(%4431, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4437 = "llvm.bitcast"(%4414) : (vector<32xi8>) -> vector<4xi64>
  %4438 = "llvm.and"(%4437, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4439 = "llvm.call_intrinsic"(%4438, %4436, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4440 = "llvm.bitcast"(%4418) : (vector<32xi8>) -> vector<4xi64>
  %4441 = "llvm.and"(%4440, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4442 = "llvm.add"(%4441, %4432) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4443 = "llvm.bitcast"(%4422) : (vector<32xi8>) -> vector<4xi64>
  %4444 = "llvm.and"(%4443, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4445 = "llvm.add"(%4444, %4433) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4446 = "llvm.bitcast"(%4426) : (vector<32xi8>) -> vector<4xi64>
  %4447 = "llvm.and"(%4446, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4448 = "llvm.add"(%4447, %4434) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4449 = "llvm.bitcast"(%4430) : (vector<32xi8>) -> vector<4xi64>
  %4450 = "llvm.and"(%4449, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4451 = "llvm.add"(%4450, %4435) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%4159) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4160) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4161) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4162) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4163) : (!llvm.ptr) -> ()
  "llvm.call"(%4159, %4160, %4161, %4162, %4163, %4439, %4442, %4445, %4448, %4451) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %4452 = "llvm.load"(%4159) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4453 = "llvm.load"(%4160) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4454 = "llvm.load"(%4161) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4455 = "llvm.load"(%4162) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4456 = "llvm.load"(%4163) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%4163) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4162) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4161) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4160) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4159) : (!llvm.ptr) -> ()
  %4457 = "llvm.call"(%4452, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4458 = "llvm.call"(%4453, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4459 = "llvm.call"(%4454, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4460 = "llvm.call"(%4455, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4461 = "llvm.call"(%4456, %4138, %4138, %4138, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4462 = "llvm.call"(%4452, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4463 = "llvm.call"(%4453, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4464 = "llvm.call"(%4454, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4465 = "llvm.call"(%4455, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4466 = "llvm.call"(%4456, %4137, %4137, %4137, %4137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4467 = "llvm.bitcast"(%4462) : (vector<4xi64>) -> vector<32xi8>
  %4468 = "llvm.bitcast"(%4452) : (vector<4xi64>) -> vector<32xi8>
  %4469 = "llvm.call_intrinsic"(%4467, %4468, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4470 = "llvm.bitcast"(%4469) : (vector<32xi8>) -> vector<4xi64>
  %4471 = "llvm.bitcast"(%4463) : (vector<4xi64>) -> vector<32xi8>
  %4472 = "llvm.bitcast"(%4453) : (vector<4xi64>) -> vector<32xi8>
  %4473 = "llvm.call_intrinsic"(%4471, %4472, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4474 = "llvm.bitcast"(%4473) : (vector<32xi8>) -> vector<4xi64>
  %4475 = "llvm.bitcast"(%4464) : (vector<4xi64>) -> vector<32xi8>
  %4476 = "llvm.bitcast"(%4454) : (vector<4xi64>) -> vector<32xi8>
  %4477 = "llvm.call_intrinsic"(%4475, %4476, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4478 = "llvm.bitcast"(%4477) : (vector<32xi8>) -> vector<4xi64>
  %4479 = "llvm.bitcast"(%4465) : (vector<4xi64>) -> vector<32xi8>
  %4480 = "llvm.bitcast"(%4455) : (vector<4xi64>) -> vector<32xi8>
  %4481 = "llvm.call_intrinsic"(%4479, %4480, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4482 = "llvm.bitcast"(%4481) : (vector<32xi8>) -> vector<4xi64>
  %4483 = "llvm.bitcast"(%4466) : (vector<4xi64>) -> vector<32xi8>
  %4484 = "llvm.bitcast"(%4456) : (vector<4xi64>) -> vector<32xi8>
  %4485 = "llvm.call_intrinsic"(%4483, %4484, %4196) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4486 = "llvm.bitcast"(%4485) : (vector<32xi8>) -> vector<4xi64>
  %4487 = "llvm.sub"(%4144, %4470) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4488 = "llvm.sub"(%4145, %4474) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4489 = "llvm.sub"(%4145, %4478) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4490 = "llvm.sub"(%4145, %4482) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4491 = "llvm.sub"(%4145, %4486) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4492 = "llvm.shl"(%4452, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4493 = "llvm.shl"(%4453, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4494 = "llvm.shl"(%4454, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4495 = "llvm.shl"(%4455, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4496 = "llvm.shl"(%4456, %4146) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4497 = "llvm.bitcast"(%4492) : (vector<4xi64>) -> vector<32xi8>
  %4498 = "llvm.call_intrinsic"(%4147, %4497, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4499 = "llvm.bitcast"(%4498) : (vector<32xi8>) -> vector<4xi64>
  %4500 = "llvm.bitcast"(%4493) : (vector<4xi64>) -> vector<32xi8>
  %4501 = "llvm.call_intrinsic"(%4147, %4500, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4502 = "llvm.bitcast"(%4501) : (vector<32xi8>) -> vector<4xi64>
  %4503 = "llvm.bitcast"(%4494) : (vector<4xi64>) -> vector<32xi8>
  %4504 = "llvm.call_intrinsic"(%4147, %4503, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4505 = "llvm.bitcast"(%4504) : (vector<32xi8>) -> vector<4xi64>
  %4506 = "llvm.bitcast"(%4495) : (vector<4xi64>) -> vector<32xi8>
  %4507 = "llvm.call_intrinsic"(%4147, %4506, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4508 = "llvm.bitcast"(%4507) : (vector<32xi8>) -> vector<4xi64>
  %4509 = "llvm.bitcast"(%4496) : (vector<4xi64>) -> vector<32xi8>
  %4510 = "llvm.call_intrinsic"(%4147, %4509, %4282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4511 = "llvm.bitcast"(%4510) : (vector<32xi8>) -> vector<4xi64>
  %4512 = "llvm.add"(%4457, %4499) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4513 = "llvm.add"(%4458, %4502) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4514 = "llvm.add"(%4459, %4505) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4515 = "llvm.add"(%4460, %4508) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4516 = "llvm.add"(%4461, %4511) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4517 = "llvm.call_intrinsic"(%4147, %4467, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4518 = "llvm.bitcast"(%4517) : (vector<32xi8>) -> vector<4xi64>
  %4519 = "llvm.call_intrinsic"(%4147, %4471, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4520 = "llvm.bitcast"(%4519) : (vector<32xi8>) -> vector<4xi64>
  %4521 = "llvm.call_intrinsic"(%4147, %4475, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4522 = "llvm.bitcast"(%4521) : (vector<32xi8>) -> vector<4xi64>
  %4523 = "llvm.call_intrinsic"(%4147, %4479, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4524 = "llvm.bitcast"(%4523) : (vector<32xi8>) -> vector<4xi64>
  %4525 = "llvm.call_intrinsic"(%4147, %4483, %4303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4526 = "llvm.bitcast"(%4525) : (vector<32xi8>) -> vector<4xi64>
  %4527 = "llvm.add"(%4512, %4518) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4528 = "llvm.add"(%4513, %4520) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4529 = "llvm.add"(%4514, %4522) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4530 = "llvm.add"(%4515, %4524) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4531 = "llvm.add"(%4516, %4526) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4532 = "llvm.bitcast"(%4487) : (vector<4xi64>) -> vector<32xi8>
  %4533 = "llvm.call_intrinsic"(%4147, %4532, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4534 = "llvm.bitcast"(%4533) : (vector<32xi8>) -> vector<4xi64>
  %4535 = "llvm.bitcast"(%4488) : (vector<4xi64>) -> vector<32xi8>
  %4536 = "llvm.call_intrinsic"(%4147, %4535, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4537 = "llvm.bitcast"(%4536) : (vector<32xi8>) -> vector<4xi64>
  %4538 = "llvm.bitcast"(%4489) : (vector<4xi64>) -> vector<32xi8>
  %4539 = "llvm.call_intrinsic"(%4147, %4538, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4540 = "llvm.bitcast"(%4539) : (vector<32xi8>) -> vector<4xi64>
  %4541 = "llvm.bitcast"(%4490) : (vector<4xi64>) -> vector<32xi8>
  %4542 = "llvm.call_intrinsic"(%4147, %4541, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4543 = "llvm.bitcast"(%4542) : (vector<32xi8>) -> vector<4xi64>
  %4544 = "llvm.bitcast"(%4491) : (vector<4xi64>) -> vector<32xi8>
  %4545 = "llvm.call_intrinsic"(%4147, %4544, %4321) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %4546 = "llvm.bitcast"(%4545) : (vector<32xi8>) -> vector<4xi64>
  %4547 = "llvm.add"(%4527, %4534) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4548 = "llvm.add"(%4528, %4537) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4549 = "llvm.add"(%4529, %4540) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4550 = "llvm.add"(%4530, %4543) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4551 = "llvm.add"(%4531, %4546) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4552 = "llvm.lshr"(%4547, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4553 = "llvm.lshr"(%4548, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4554 = "llvm.lshr"(%4549, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4555 = "llvm.lshr"(%4550, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4556 = "llvm.lshr"(%4551, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4557 = "llvm.and"(%4547, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4558 = "llvm.call_intrinsic"(%4557, %4556, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4559 = "llvm.and"(%4548, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4560 = "llvm.add"(%4559, %4552) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4561 = "llvm.and"(%4549, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4562 = "llvm.add"(%4561, %4553) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4563 = "llvm.and"(%4550, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4564 = "llvm.add"(%4563, %4554) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4565 = "llvm.and"(%4551, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4566 = "llvm.add"(%4565, %4555) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4567 = "llvm.call"(%4558, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4568 = "llvm.call"(%4560, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4569 = "llvm.call"(%4562, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4570 = "llvm.call"(%4564, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4571 = "llvm.call"(%4566, %4139, %4137, %4137, %4139) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4572 = "llvm.call"(%4558, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4573 = "llvm.call"(%4560, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4574 = "llvm.call"(%4562, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4575 = "llvm.call"(%4564, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %4576 = "llvm.call"(%4566, %4140, %4138, %4140, %4138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%4164) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4165) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4166) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4167) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4168) : (!llvm.ptr) -> ()
  "llvm.call"(%4164, %4165, %4166, %4167, %4168, %4572, %4573, %4574, %4575, %4576, %4567, %4568, %4569, %4570, %4571) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %4577 = "llvm.load"(%4164) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4578 = "llvm.load"(%4165) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4579 = "llvm.load"(%4166) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4580 = "llvm.load"(%4167) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %4581 = "llvm.load"(%4168) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%4168) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4167) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4166) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4165) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%4164) : (!llvm.ptr) -> ()
  %4582 = "llvm.lshr"(%4577, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4583 = "llvm.lshr"(%4578, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4584 = "llvm.lshr"(%4579, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4585 = "llvm.lshr"(%4580, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4586 = "llvm.lshr"(%4581, %4141) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4587 = "llvm.and"(%4577, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4588 = "llvm.call_intrinsic"(%4587, %4586, %4143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4589 = "llvm.and"(%4578, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4590 = "llvm.add"(%4589, %4582) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4591 = "llvm.and"(%4579, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4592 = "llvm.add"(%4591, %4583) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4593 = "llvm.and"(%4580, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4594 = "llvm.add"(%4593, %4584) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4595 = "llvm.and"(%4581, %4142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4596 = "llvm.add"(%4595, %4585) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4597 = "llvm.add"(%4396, %4148) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %4598 = "llvm.zext"(%4597) : (i8) -> i32
  %4599 = "llvm.icmp"(%arg148, %4598) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%4599, %4596, %4594, %4592, %4590, %4588, %4597)[^bb3, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 6, 0>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i8) -> ()
}) : () -> ()
  with @fd_r52x5_quad_mul_fast := fd_r52x5_quad_mul_fast,
    @fd_r52x5_quad_sqr_fast := fd_r52x5_quad_sqr_fast, @wc_bcast_wide := wc_bcast_wide,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5

module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_r52x5_reduce.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_r52x5_reduce :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_reduce", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg13: !llvm.ptr):
  %191 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %192 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %193 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %194 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %195 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %196 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %197 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %198 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %199 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %200 = "llvm.load"(%arg13) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %201 = "llvm.add"(%200, %191) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %202 = "llvm.lshr"(%201, %192) : (i64, i64) -> i64
  %203 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %204 = "llvm.load"(%203) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %205 = "llvm.add"(%202, %204) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %206 = "llvm.lshr"(%205, %192) : (i64, i64) -> i64
  %207 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %208 = "llvm.load"(%207) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %209 = "llvm.add"(%206, %208) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %210 = "llvm.lshr"(%209, %192) : (i64, i64) -> i64
  %211 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %212 = "llvm.load"(%211) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %213 = "llvm.add"(%210, %212) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %214 = "llvm.lshr"(%213, %192) : (i64, i64) -> i64
  %215 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %216 = "llvm.load"(%215) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %217 = "llvm.add"(%214, %216) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %218 = "llvm.lshr"(%217, %192) : (i64, i64) -> i64
  %219 = "llvm.mul"(%218, %191) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %220 = "llvm.add"(%219, %200) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %221 = "llvm.lshr"(%220, %192) : (i64, i64) -> i64
  %222 = "llvm.add"(%221, %204) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %223 = "llvm.lshr"(%222, %192) : (i64, i64) -> i64
  %224 = "llvm.add"(%223, %208) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %225 = "llvm.lshr"(%224, %192) : (i64, i64) -> i64
  %226 = "llvm.add"(%225, %212) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %227 = "llvm.lshr"(%226, %192) : (i64, i64) -> i64
  %228 = "llvm.insertelement"(%193, %220, %194) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %229 = "llvm.insertelement"(%228, %222, %195) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %230 = "llvm.insertelement"(%229, %224, %196) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %231 = "llvm.insertelement"(%230, %226, %197) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %232 = "llvm.and"(%231, %198) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%232, %arg13) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %233 = "llvm.add"(%227, %216) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %234 = "llvm.and"(%233, %199) : (i64, i64) -> i64
  "llvm.store"(%234, %215) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5

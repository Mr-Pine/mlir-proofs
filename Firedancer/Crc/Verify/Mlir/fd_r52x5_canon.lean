module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_canon :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg47: !llvm.ptr, %arg48: !llvm.ptr):
  %162 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %163 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %164 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %165 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %166 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %167 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %168 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %169 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %170 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %171 = "llvm.load"(%arg48) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %172 = "llvm.and"(%171, %162) : (i64, i64) -> i64
  %173 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %174 = "llvm.load"(%173) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %175 = "llvm.lshr"(%174, %163) : (i64, i64) -> i64
  %176 = "llvm.mul"(%175, %164) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %177 = "llvm.add"(%176, %172) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %178 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %179 = "llvm.load"(%178) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %180 = "llvm.lshr"(%179, %163) : (i64, i64) -> i64
  %181 = "llvm.and"(%174, %162) : (i64, i64) -> i64
  %182 = "llvm.add"(%180, %181) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %183 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %184 = "llvm.load"(%183) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %185 = "llvm.lshr"(%184, %163) : (i64, i64) -> i64
  %186 = "llvm.and"(%179, %162) : (i64, i64) -> i64
  %187 = "llvm.add"(%185, %186) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %188 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %189 = "llvm.load"(%188) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %190 = "llvm.lshr"(%189, %163) : (i64, i64) -> i64
  %191 = "llvm.and"(%184, %162) : (i64, i64) -> i64
  %192 = "llvm.add"(%190, %191) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %193 = "llvm.lshr"(%171, %163) : (i64, i64) -> i64
  %194 = "llvm.and"(%189, %162) : (i64, i64) -> i64
  %195 = "llvm.add"(%194, %193) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %196 = "llvm.add"(%177, %164) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %197 = "llvm.lshr"(%196, %163) : (i64, i64) -> i64
  %198 = "llvm.add"(%195, %197) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %199 = "llvm.lshr"(%198, %163) : (i64, i64) -> i64
  %200 = "llvm.add"(%199, %192) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %201 = "llvm.lshr"(%200, %163) : (i64, i64) -> i64
  %202 = "llvm.add"(%201, %187) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %203 = "llvm.lshr"(%202, %163) : (i64, i64) -> i64
  %204 = "llvm.add"(%203, %182) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %205 = "llvm.lshr"(%204, %163) : (i64, i64) -> i64
  %206 = "llvm.mul"(%205, %164) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %207 = "llvm.add"(%206, %177) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %208 = "llvm.lshr"(%207, %163) : (i64, i64) -> i64
  %209 = "llvm.add"(%208, %195) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %210 = "llvm.lshr"(%209, %163) : (i64, i64) -> i64
  %211 = "llvm.add"(%210, %192) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %212 = "llvm.lshr"(%211, %163) : (i64, i64) -> i64
  %213 = "llvm.add"(%212, %187) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %214 = "llvm.insertelement"(%165, %207, %166) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %215 = "llvm.insertelement"(%214, %209, %167) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %216 = "llvm.insertelement"(%215, %211, %168) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %217 = "llvm.insertelement"(%216, %213, %169) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %218 = "llvm.and"(%217, %170) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %219 = "llvm.lshr"(%213, %163) : (i64, i64) -> i64
  %220 = "llvm.add"(%219, %182) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %221 = "llvm.and"(%220, %162) : (i64, i64) -> i64
  "llvm.store"(%218, %arg47) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %222 = "llvm.getelementptr"(%arg47) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%221, %222) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify

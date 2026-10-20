module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_dbln.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_ge_dbln :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_ge_dbln", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg221: !llvm.ptr, %arg222: !llvm.ptr):
  %3519 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3520 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3521 = "llvm.mlir.constant"() <{value = 33 : i32}> : () -> i32
  %3522 = "llvm.alloca"(%3519) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3523 = "llvm.alloca"(%3519) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3524 = "llvm.alloca"(%3519) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3525 = "llvm.alloca"(%3519) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3526 = "llvm.alloca"(%3519) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3527 = "llvm.load"(%arg222) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3528 = "llvm.getelementptr"(%arg222) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3529 = "llvm.load"(%3528) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3530 = "llvm.getelementptr"(%arg222) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3531 = "llvm.load"(%3530) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3532 = "llvm.getelementptr"(%arg222) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3533 = "llvm.load"(%3532) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3534 = "llvm.getelementptr"(%arg222) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3535 = "llvm.load"(%3534) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.br"(%3520, %3535, %3533, %3531, %3529, %3527)[^bb2] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb1:  // pred: ^bb2
  "llvm.store"(%3546, %arg221) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3536 = "llvm.getelementptr"(%arg221) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3547, %3536) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3537 = "llvm.getelementptr"(%arg221) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3548, %3537) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3538 = "llvm.getelementptr"(%arg221) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3549, %3538) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3539 = "llvm.getelementptr"(%arg221) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3550, %3539) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb2(%3540: i32, %3541: vector<4xi64>, %3542: vector<4xi64>, %3543: vector<4xi64>, %3544: vector<4xi64>, %3545: vector<4xi64>):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%3522) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3523) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3524) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3525) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3526) : (!llvm.ptr) -> ()
  "llvm.call"(%3522, %3523, %3524, %3525, %3526, %3545, %3544, %3543, %3542, %3541) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3546 = "llvm.load"(%3522) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3547 = "llvm.load"(%3523) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3548 = "llvm.load"(%3524) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3549 = "llvm.load"(%3525) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3550 = "llvm.load"(%3526) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3526) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3525) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3524) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3523) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3522) : (!llvm.ptr) -> ()
  %3551 = "llvm.add"(%3540, %3519) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3552 = "llvm.icmp"(%3551, %3521) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3552, %3551, %3550, %3549, %3548, %3547, %3546)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl

end

end MLIR.Firedancer.Crc.Verify

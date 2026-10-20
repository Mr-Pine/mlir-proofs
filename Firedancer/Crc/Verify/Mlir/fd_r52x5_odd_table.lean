module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_odd_table.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_to_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_to_table

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_odd_table :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 4, 129>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_odd_table", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg218: !llvm.ptr, %arg219: !llvm.ptr, %arg220: i32):
  %3450 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3451 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3452 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3453 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3454 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3455 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3456 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3457 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3458 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3459 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3460 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3461 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3462 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3463 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3464 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3465 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3466 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3467 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3468 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3469 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3470 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3471 = "llvm.alloca"(%3450) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3472 = "llvm.load"(%arg219) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3473 = "llvm.getelementptr"(%arg219) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3474 = "llvm.load"(%3473) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3475 = "llvm.getelementptr"(%arg219) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3476 = "llvm.load"(%3475) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3477 = "llvm.getelementptr"(%arg219) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3478 = "llvm.load"(%3477) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3479 = "llvm.getelementptr"(%arg219) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3480 = "llvm.load"(%3479) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3452) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3453) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3454) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3455) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3456) : (!llvm.ptr) -> ()
  "llvm.call"(%3452, %3453, %3454, %3455, %3456, %3472, %3474, %3476, %3478, %3480) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3481 = "llvm.load"(%3452) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3482 = "llvm.load"(%3453) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3483 = "llvm.load"(%3454) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3484 = "llvm.load"(%3455) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3485 = "llvm.load"(%3456) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3456) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3455) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3454) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3453) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3452) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3457) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3458) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3459) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3460) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3461) : (!llvm.ptr) -> ()
  "llvm.call"(%3457, %3458, %3459, %3460, %3461, %3472, %3474, %3476, %3478, %3480) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_to_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3486 = "llvm.load"(%3457) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3487 = "llvm.load"(%3458) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3488 = "llvm.load"(%3459) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3489 = "llvm.load"(%3460) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3490 = "llvm.load"(%3461) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3461) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3460) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3459) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3458) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3457) : (!llvm.ptr) -> ()
  "llvm.store"(%3486, %arg218) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3491 = "llvm.getelementptr"(%arg218) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3487, %3491) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3492 = "llvm.getelementptr"(%arg218) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3488, %3492) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3493 = "llvm.getelementptr"(%arg218) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3489, %3493) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3494 = "llvm.getelementptr"(%arg218) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3490, %3494) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3495 = "llvm.zext"(%arg220) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%3451, %3472, %3474, %3476, %3478, %3480)[^bb2] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb1:  // pred: ^bb2
  "llvm.return"() : () -> ()
^bb2(%3496: i64, %3497: vector<4xi64>, %3498: vector<4xi64>, %3499: vector<4xi64>, %3500: vector<4xi64>, %3501: vector<4xi64>):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%3462) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3463) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3464) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3465) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3466) : (!llvm.ptr) -> ()
  "llvm.call"(%3462, %3463, %3464, %3465, %3466, %3497, %3498, %3499, %3500, %3501, %3481, %3482, %3483, %3484, %3485) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3502 = "llvm.load"(%3462) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3503 = "llvm.load"(%3463) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3504 = "llvm.load"(%3464) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3505 = "llvm.load"(%3465) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3506 = "llvm.load"(%3466) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3466) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3465) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3464) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3463) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3462) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3467) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3468) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3470) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3471) : (!llvm.ptr) -> ()
  "llvm.call"(%3467, %3468, %3469, %3470, %3471, %3502, %3503, %3504, %3505, %3506) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_to_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3507 = "llvm.load"(%3467) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3508 = "llvm.load"(%3468) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3509 = "llvm.load"(%3469) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3510 = "llvm.load"(%3470) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3511 = "llvm.load"(%3471) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3471) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3470) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3468) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3467) : (!llvm.ptr) -> ()
  %3512 = "llvm.getelementptr"(%arg218, %3496) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3507, %3512) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3513 = "llvm.getelementptr"(%3512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3508, %3513) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3514 = "llvm.getelementptr"(%3512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3509, %3514) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3515 = "llvm.getelementptr"(%3512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3510, %3515) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3516 = "llvm.getelementptr"(%3512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3511, %3516) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3517 = "llvm.add"(%3496, %3451) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3518 = "llvm.icmp"(%3517, %3495) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3518, %3517, %3502, %3503, %3504, %3505, %3506)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_quad_ge_add := fd_r52x5_quad_ge_add, @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl,
    @fd_r52x5_quad_to_table := fd_r52x5_quad_to_table

end

end MLIR.Firedancer.Crc.Verify

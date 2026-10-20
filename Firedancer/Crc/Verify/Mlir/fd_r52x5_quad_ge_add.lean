module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_ge_add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
public import Firedancer.Crc.Verify.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
meta import Firedancer.Crc.Verify.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_ge_add :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_ge_add", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg109: !llvm.ptr, %arg110: !llvm.ptr, %arg111: !llvm.ptr, %arg112: !llvm.ptr, %arg113: !llvm.ptr, %arg114: vector<4xi64>, %arg115: vector<4xi64>, %arg116: vector<4xi64>, %arg117: vector<4xi64>, %arg118: vector<4xi64>, %arg119: vector<4xi64>, %arg120: vector<4xi64>, %arg121: vector<4xi64>, %arg122: vector<4xi64>, %arg123: vector<4xi64>):
  %444 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %445 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %446 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %447 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %448 = "llvm.mlir.constant"() <{value = dense<[1, 1, 2, 1859910466990425]> : vector<4xi64>}> : () -> vector<4xi64>
  %449 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 932731440258426]> : vector<4xi64>}> : () -> vector<4xi64>
  %450 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1072319116312658]> : vector<4xi64>}> : () -> vector<4xi64>
  %451 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1815898335770999]> : vector<4xi64>}> : () -> vector<4xi64>
  %452 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 633789495995903]> : vector<4xi64>}> : () -> vector<4xi64>
  %453 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %454 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %455 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %456 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %457 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %458 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %459 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %460 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %461 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %462 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %463 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %464 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %465 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %466 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %467 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %468 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %469 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %470 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %471 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %472 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %473 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %474 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %475 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %476 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %477 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %478 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %479 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %480 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %481 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %482 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %483 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %484 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %485 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %486 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %487 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %488 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %489 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %490 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %491 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %492 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %493 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %494 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %495 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %496 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %497 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %498 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %499 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %500 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %501 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %502 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %503 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %504 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %505 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %506 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %507 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %508 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %509 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %510 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %511 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %512 = "llvm.alloca"(%444) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %513 = "llvm.call"(%arg119, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %514 = "llvm.call"(%arg120, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %515 = "llvm.call"(%arg121, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %516 = "llvm.call"(%arg122, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %517 = "llvm.call"(%arg123, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%453) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%454) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%455) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%456) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%457) : (!llvm.ptr) -> ()
  "llvm.call"(%453, %454, %455, %456, %457, %arg119, %arg120, %arg121, %arg122, %arg123) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %518 = "llvm.load"(%453) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %519 = "llvm.load"(%454) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %520 = "llvm.load"(%455) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %521 = "llvm.load"(%456) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %522 = "llvm.load"(%457) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%457) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%456) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%455) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%454) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%453) : (!llvm.ptr) -> ()
  %523 = "llvm.shufflevector"(%518, %arg119) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %524 = "llvm.shufflevector"(%519, %arg120) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %525 = "llvm.shufflevector"(%520, %arg121) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %526 = "llvm.shufflevector"(%521, %arg122) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %527 = "llvm.shufflevector"(%522, %arg123) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%458) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%459) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%460) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%461) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%462) : (!llvm.ptr) -> ()
  "llvm.call"(%458, %459, %460, %461, %462, %513, %514, %515, %516, %517, %523, %524, %525, %526, %527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %528 = "llvm.load"(%458) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %529 = "llvm.load"(%459) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %530 = "llvm.load"(%460) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %531 = "llvm.load"(%461) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %532 = "llvm.load"(%462) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%462) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%461) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%460) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%459) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%458) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%463) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%464) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%465) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%466) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%467) : (!llvm.ptr) -> ()
  "llvm.call"(%463, %464, %465, %466, %467, %528, %529, %530, %531, %532) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %533 = "llvm.load"(%463) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %534 = "llvm.load"(%464) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %535 = "llvm.load"(%465) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %536 = "llvm.load"(%466) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %537 = "llvm.load"(%467) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%467) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%466) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%465) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%464) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%463) : (!llvm.ptr) -> ()
  %538 = "llvm.shufflevector"(%533, %arg119) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %539 = "llvm.shufflevector"(%534, %arg120) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %540 = "llvm.shufflevector"(%535, %arg121) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %541 = "llvm.shufflevector"(%536, %arg122) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %542 = "llvm.shufflevector"(%537, %arg123) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%468) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%470) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%471) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%472) : (!llvm.ptr) -> ()
  "llvm.call"(%468, %469, %470, %471, %472, %538, %539, %540, %541, %542, %448, %449, %450, %451, %452) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %543 = "llvm.load"(%468) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %544 = "llvm.load"(%469) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %545 = "llvm.load"(%470) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %546 = "llvm.load"(%471) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %547 = "llvm.load"(%472) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%472) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%471) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%470) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%468) : (!llvm.ptr) -> ()
  %548 = "llvm.call"(%arg114, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %549 = "llvm.call"(%arg115, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %550 = "llvm.call"(%arg116, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %551 = "llvm.call"(%arg117, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %552 = "llvm.call"(%arg118, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%473) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%474) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%475) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%476) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%477) : (!llvm.ptr) -> ()
  "llvm.call"(%473, %474, %475, %476, %477, %arg114, %arg115, %arg116, %arg117, %arg118) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %553 = "llvm.load"(%473) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %554 = "llvm.load"(%474) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %555 = "llvm.load"(%475) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %556 = "llvm.load"(%476) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %557 = "llvm.load"(%477) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%477) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%476) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%475) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%474) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%473) : (!llvm.ptr) -> ()
  %558 = "llvm.shufflevector"(%553, %arg114) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %559 = "llvm.shufflevector"(%554, %arg115) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %560 = "llvm.shufflevector"(%555, %arg116) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %561 = "llvm.shufflevector"(%556, %arg117) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %562 = "llvm.shufflevector"(%557, %arg118) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%478) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%480) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%481) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%482) : (!llvm.ptr) -> ()
  "llvm.call"(%478, %479, %480, %481, %482, %548, %549, %550, %551, %552, %558, %559, %560, %561, %562) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %563 = "llvm.load"(%478) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %564 = "llvm.load"(%479) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %565 = "llvm.load"(%480) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %566 = "llvm.load"(%481) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %567 = "llvm.load"(%482) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%482) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%481) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%480) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%478) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%483) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%484) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%485) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%486) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%487) : (!llvm.ptr) -> ()
  "llvm.call"(%483, %484, %485, %486, %487, %563, %564, %565, %566, %567) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %568 = "llvm.load"(%483) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %569 = "llvm.load"(%484) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %570 = "llvm.load"(%485) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %571 = "llvm.load"(%486) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %572 = "llvm.load"(%487) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%487) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%486) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%485) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%484) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%483) : (!llvm.ptr) -> ()
  %573 = "llvm.shufflevector"(%568, %arg114) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %574 = "llvm.shufflevector"(%569, %arg115) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %575 = "llvm.shufflevector"(%570, %arg116) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %576 = "llvm.shufflevector"(%571, %arg117) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %577 = "llvm.shufflevector"(%572, %arg118) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%488) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%489) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%490) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%491) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%492) : (!llvm.ptr) -> ()
  "llvm.call"(%488, %489, %490, %491, %492, %573, %574, %575, %576, %577, %543, %544, %545, %546, %547) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %578 = "llvm.load"(%488) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %579 = "llvm.load"(%489) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %580 = "llvm.load"(%490) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %581 = "llvm.load"(%491) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %582 = "llvm.load"(%492) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%492) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%491) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%490) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%489) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%488) : (!llvm.ptr) -> ()
  %583 = "llvm.call"(%578, %445, %444, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %584 = "llvm.call"(%579, %445, %444, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %585 = "llvm.call"(%580, %445, %444, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %586 = "llvm.call"(%581, %445, %444, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %587 = "llvm.call"(%582, %445, %444, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %588 = "llvm.call"(%583, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %589 = "llvm.call"(%584, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %590 = "llvm.call"(%585, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %591 = "llvm.call"(%586, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %592 = "llvm.call"(%587, %444, %445, %446, %447) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%493) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%497) : (!llvm.ptr) -> ()
  "llvm.call"(%493, %494, %495, %496, %497, %583, %584, %585, %586, %587) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %593 = "llvm.load"(%493) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %594 = "llvm.load"(%494) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %595 = "llvm.load"(%495) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %596 = "llvm.load"(%496) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %597 = "llvm.load"(%497) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%497) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%493) : (!llvm.ptr) -> ()
  %598 = "llvm.shufflevector"(%593, %583) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %599 = "llvm.shufflevector"(%594, %584) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %600 = "llvm.shufflevector"(%595, %585) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %601 = "llvm.shufflevector"(%596, %586) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %602 = "llvm.shufflevector"(%597, %587) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%499) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%500) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%501) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%502) : (!llvm.ptr) -> ()
  "llvm.call"(%498, %499, %500, %501, %502, %588, %589, %590, %591, %592, %598, %599, %600, %601, %602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %603 = "llvm.load"(%498) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %604 = "llvm.load"(%499) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %605 = "llvm.load"(%500) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %606 = "llvm.load"(%501) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %607 = "llvm.load"(%502) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%502) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%501) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%500) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%499) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%503) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%505) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%506) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%507) : (!llvm.ptr) -> ()
  "llvm.call"(%503, %504, %505, %506, %507, %603, %604, %605, %606, %607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %608 = "llvm.load"(%503) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %609 = "llvm.load"(%504) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %610 = "llvm.load"(%505) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %611 = "llvm.load"(%506) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %612 = "llvm.load"(%507) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%507) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%506) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%505) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%503) : (!llvm.ptr) -> ()
  %613 = "llvm.call"(%608, %445, %446, %446, %445) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %614 = "llvm.call"(%609, %445, %446, %446, %445) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %615 = "llvm.call"(%610, %445, %446, %446, %445) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %616 = "llvm.call"(%611, %445, %446, %446, %445) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %617 = "llvm.call"(%612, %445, %446, %446, %445) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %618 = "llvm.call"(%608, %447, %444, %447, %444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %619 = "llvm.call"(%609, %447, %444, %447, %444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %620 = "llvm.call"(%610, %447, %444, %447, %444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %621 = "llvm.call"(%611, %447, %444, %447, %444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %622 = "llvm.call"(%612, %447, %444, %447, %444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%508) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%509) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%510) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%511) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%512) : (!llvm.ptr) -> ()
  "llvm.call"(%508, %509, %510, %511, %512, %613, %614, %615, %616, %617, %618, %619, %620, %621, %622) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %623 = "llvm.load"(%508) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %624 = "llvm.load"(%509) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %625 = "llvm.load"(%510) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %626 = "llvm.load"(%511) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %627 = "llvm.load"(%512) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%512) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%511) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%510) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%509) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%508) : (!llvm.ptr) -> ()
  "llvm.store"(%623, %arg109) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%624, %arg110) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%625, %arg111) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%626, %arg112) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%627, %arg113) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify

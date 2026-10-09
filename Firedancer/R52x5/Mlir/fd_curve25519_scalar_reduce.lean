module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_curve25519_scalar_reduce.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_ulong_load_8

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_curve25519_scalar_reduce :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_reduce", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg50: !llvm.ptr, %arg51: !llvm.ptr):
  %438 = "llvm.mlir.constant"() <{value = dense<[63, 62, 61, 39]> : vector<4xi64>}> : () -> vector<4xi64>
  %439 = "llvm.mlir.constant"() <{value = dense<[4398044413952, 2199022206976, 1099511103488, 549755551744]> : vector<4xi64>}> : () -> vector<4xi64>
  %440 = "llvm.mlir.constant"() <{value = dense<[21, 20, 19, 18]> : vector<4xi64>}> : () -> vector<4xi64>
  %441 = "llvm.mlir.constant"() <{value = dense<[9223367638808264704, 4611683819404132352, 2305841909702066176, 262143]> : vector<4xi64>}> : () -> vector<4xi64>
  %442 = "llvm.mlir.constant"() <{value = dense<[42, 41, 40, 3]> : vector<4xi64>}> : () -> vector<4xi64>
  %443 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %444 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %445 = "llvm.mlir.constant"() <{value = dense<[2097151, 1048575, 524287, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %446 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %447 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %448 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %449 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %450 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %451 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %452 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %453 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %454 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %455 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %456 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %457 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %458 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %459 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %460 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %461 = "llvm.mlir.constant"() <{value = dense<[1, 2]> : vector<2xi64>}> : () -> vector<2xi64>
  %462 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %463 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %464 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %465 = "llvm.mlir.constant"() <{value = dense<[3, 4]> : vector<2xi64>}> : () -> vector<2xi64>
  %466 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %467 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %468 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %469 = "llvm.mlir.constant"() <{value = dense<[5, 6]> : vector<2xi64>}> : () -> vector<2xi64>
  %470 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %471 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %472 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %473 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %474 = "llvm.mlir.constant"() <{value = 35 : i64}> : () -> i64
  %475 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %476 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %477 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %478 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %479 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %480 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %481 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %482 = "llvm.mlir.constant"() <{value = 8796090925056 : i64}> : () -> i64
  %483 = "llvm.mlir.constant"() <{value = 9223372036852678656 : i64}> : () -> i64
  %484 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %485 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %486 = "llvm.mlir.poison"() : () -> i64
  %487 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %488 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %489 = "llvm.insertelement"(%487, %486, %488) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %490 = "llvm.insertelement"(%489, %486, %450) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %491 = "llvm.insertelement"(%490, %486, %449) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %492 = "llvm.insertelement"(%491, %485, %448) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %493 = "llvm.call"(%arg51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %494 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %495 = "llvm.call"(%494) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %496 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %497 = "llvm.call"(%496) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %498 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %499 = "llvm.call"(%498) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %500 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %501 = "llvm.call"(%500) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %502 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %503 = "llvm.call"(%502) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %504 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %505 = "llvm.call"(%504) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %506 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %507 = "llvm.call"(%506) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %508 = "llvm.and"(%493, %453) : (i64, i64) -> i64
  %509 = "llvm.lshr"(%493, %454) : (i64, i64) -> i64
  %510 = "llvm.and"(%509, %453) : (i64, i64) -> i64
  %511 = "llvm.lshr"(%493, %455) : (i64, i64) -> i64
  %512 = "llvm.and"(%511, %453) : (i64, i64) -> i64
  %513 = "llvm.lshr"(%495, %456) : (i64, i64) -> i64
  %514 = "llvm.and"(%513, %453) : (i64, i64) -> i64
  %515 = "llvm.lshr"(%495, %457) : (i64, i64) -> i64
  %516 = "llvm.and"(%515, %453) : (i64, i64) -> i64
  %517 = "llvm.insertelement"(%458, %495, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %518 = "llvm.insertelement"(%517, %497, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %519 = "llvm.insertelement"(%458, %493, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %520 = "llvm.insertelement"(%519, %495, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %521 = "llvm.intr.fshl"(%518, %520, %461) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %522 = "llvm.extractelement"(%521, %459) : (vector<2xi64>, i64) -> i64
  %523 = "llvm.and"(%522, %453) : (i64, i64) -> i64
  %524 = "llvm.extractelement"(%521, %460) : (vector<2xi64>, i64) -> i64
  %525 = "llvm.and"(%524, %453) : (i64, i64) -> i64
  %526 = "llvm.lshr"(%497, %462) : (i64, i64) -> i64
  %527 = "llvm.and"(%526, %453) : (i64, i64) -> i64
  %528 = "llvm.lshr"(%497, %452) : (i64, i64) -> i64
  %529 = "llvm.and"(%528, %453) : (i64, i64) -> i64
  %530 = "llvm.lshr"(%499, %463) : (i64, i64) -> i64
  %531 = "llvm.and"(%530, %453) : (i64, i64) -> i64
  %532 = "llvm.lshr"(%499, %464) : (i64, i64) -> i64
  %533 = "llvm.and"(%532, %453) : (i64, i64) -> i64
  %534 = "llvm.insertelement"(%458, %499, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %535 = "llvm.insertelement"(%534, %501, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %536 = "llvm.insertelement"(%458, %497, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %537 = "llvm.insertelement"(%536, %499, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %538 = "llvm.intr.fshl"(%535, %537, %465) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %539 = "llvm.extractelement"(%538, %459) : (vector<2xi64>, i64) -> i64
  %540 = "llvm.and"(%539, %453) : (i64, i64) -> i64
  %541 = "llvm.extractelement"(%538, %460) : (vector<2xi64>, i64) -> i64
  %542 = "llvm.and"(%541, %453) : (i64, i64) -> i64
  %543 = "llvm.lshr"(%501, %466) : (i64, i64) -> i64
  %544 = "llvm.and"(%543, %453) : (i64, i64) -> i64
  %545 = "llvm.lshr"(%501, %467) : (i64, i64) -> i64
  %546 = "llvm.and"(%545, %453) : (i64, i64) -> i64
  %547 = "llvm.lshr"(%503, %451) : (i64, i64) -> i64
  %548 = "llvm.and"(%547, %453) : (i64, i64) -> i64
  %549 = "llvm.lshr"(%503, %468) : (i64, i64) -> i64
  %550 = "llvm.and"(%549, %453) : (i64, i64) -> i64
  %551 = "llvm.insertelement"(%458, %503, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %552 = "llvm.insertelement"(%551, %505, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %553 = "llvm.insertelement"(%458, %501, %459) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %554 = "llvm.insertelement"(%553, %503, %460) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %555 = "llvm.intr.fshl"(%552, %554, %469) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %556 = "llvm.extractelement"(%555, %459) : (vector<2xi64>, i64) -> i64
  %557 = "llvm.and"(%556, %453) : (i64, i64) -> i64
  %558 = "llvm.extractelement"(%555, %460) : (vector<2xi64>, i64) -> i64
  %559 = "llvm.and"(%558, %453) : (i64, i64) -> i64
  %560 = "llvm.lshr"(%505, %470) : (i64, i64) -> i64
  %561 = "llvm.and"(%560, %453) : (i64, i64) -> i64
  %562 = "llvm.lshr"(%505, %471) : (i64, i64) -> i64
  %563 = "llvm.and"(%562, %453) : (i64, i64) -> i64
  %564 = "llvm.intr.fshl"(%507, %505, %472) : (i64, i64, i64) -> i64
  %565 = "llvm.and"(%564, %453) : (i64, i64) -> i64
  %566 = "llvm.lshr"(%507, %473) : (i64, i64) -> i64
  %567 = "llvm.and"(%566, %453) : (i64, i64) -> i64
  %568 = "llvm.lshr"(%507, %474) : (i64, i64) -> i64
  %569 = "llvm.mul"(%568, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %570 = "llvm.add"(%569, %533) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %571 = "llvm.mul"(%568, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %572 = "llvm.add"(%571, %542) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %573 = "llvm.mul"(%568, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %574 = "llvm.add"(%573, %544) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %575 = "llvm.mul"(%568, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %576 = "llvm.add"(%575, %546) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %577 = "llvm.mul"(%568, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %578 = "llvm.add"(%577, %557) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %579 = "llvm.mul"(%568, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %580 = "llvm.add"(%579, %548) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %581 = "llvm.mul"(%567, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %582 = "llvm.mul"(%567, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %583 = "llvm.mul"(%567, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %584 = "llvm.mul"(%567, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %585 = "llvm.mul"(%567, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %586 = "llvm.add"(%576, %585) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %587 = "llvm.mul"(%567, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %588 = "llvm.add"(%578, %587) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %589 = "llvm.mul"(%565, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %590 = "llvm.mul"(%565, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %591 = "llvm.mul"(%565, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %592 = "llvm.mul"(%565, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %593 = "llvm.mul"(%565, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %594 = "llvm.mul"(%565, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %595 = "llvm.add"(%586, %594) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %596 = "llvm.mul"(%563, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %597 = "llvm.add"(%596, %529) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %598 = "llvm.mul"(%563, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %599 = "llvm.mul"(%563, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %600 = "llvm.mul"(%563, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %601 = "llvm.mul"(%563, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %602 = "llvm.mul"(%563, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %603 = "llvm.mul"(%561, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %604 = "llvm.add"(%603, %527) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %605 = "llvm.mul"(%561, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %606 = "llvm.add"(%597, %605) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %607 = "llvm.mul"(%561, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %608 = "llvm.mul"(%561, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %609 = "llvm.mul"(%561, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %610 = "llvm.mul"(%561, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %611 = "llvm.add"(%572, %601) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %612 = "llvm.add"(%611, %610) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %613 = "llvm.add"(%612, %583) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %614 = "llvm.add"(%613, %592) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %615 = "llvm.mul"(%559, %475) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %616 = "llvm.add"(%615, %525) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %617 = "llvm.mul"(%559, %476) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %618 = "llvm.add"(%604, %617) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %619 = "llvm.mul"(%559, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %620 = "llvm.add"(%606, %619) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %621 = "llvm.mul"(%559, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %622 = "llvm.mul"(%559, %479) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %623 = "llvm.add"(%599, %531) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %624 = "llvm.add"(%623, %608) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %625 = "llvm.add"(%624, %622) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %626 = "llvm.add"(%625, %581) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %627 = "llvm.add"(%626, %590) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %628 = "llvm.mul"(%559, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %629 = "llvm.add"(%616, %481) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %630 = "llvm.lshr"(%629, %454) : (i64, i64) -> i64
  %631 = "llvm.add"(%618, %630) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %632 = "llvm.and"(%629, %482) : (i64, i64) -> i64
  %633 = "llvm.sub"(%616, %632) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %634 = "llvm.add"(%620, %481) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %635 = "llvm.lshr"(%634, %454) : (i64, i64) -> i64
  %636 = "llvm.add"(%598, %540) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %637 = "llvm.add"(%636, %607) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %638 = "llvm.add"(%637, %621) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %639 = "llvm.add"(%638, %589) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %640 = "llvm.add"(%639, %635) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %641 = "llvm.and"(%634, %483) : (i64, i64) -> i64
  %642 = "llvm.sub"(%620, %641) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %643 = "llvm.add"(%627, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %644 = "llvm.ashr"(%643, %454) : (i64, i64) -> i64
  %645 = "llvm.add"(%570, %600) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %646 = "llvm.add"(%645, %609) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %647 = "llvm.add"(%646, %628) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %648 = "llvm.add"(%647, %582) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %649 = "llvm.add"(%648, %591) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %650 = "llvm.add"(%649, %644) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %651 = "llvm.and"(%643, %484) : (i64, i64) -> i64
  %652 = "llvm.add"(%614, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %653 = "llvm.ashr"(%652, %454) : (i64, i64) -> i64
  %654 = "llvm.add"(%574, %602) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %655 = "llvm.add"(%654, %584) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %656 = "llvm.add"(%655, %593) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %657 = "llvm.add"(%656, %653) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %658 = "llvm.and"(%652, %484) : (i64, i64) -> i64
  %659 = "llvm.sub"(%614, %658) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %660 = "llvm.add"(%595, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %661 = "llvm.ashr"(%660, %454) : (i64, i64) -> i64
  %662 = "llvm.add"(%588, %661) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %663 = "llvm.and"(%660, %484) : (i64, i64) -> i64
  %664 = "llvm.sub"(%595, %663) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %665 = "llvm.add"(%580, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %666 = "llvm.ashr"(%665, %454) : (i64, i64) -> i64
  %667 = "llvm.add"(%666, %550) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %668 = "llvm.and"(%665, %484) : (i64, i64) -> i64
  %669 = "llvm.sub"(%580, %668) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %670 = "llvm.add"(%631, %481) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %671 = "llvm.lshr"(%670, %454) : (i64, i64) -> i64
  %672 = "llvm.and"(%670, %483) : (i64, i64) -> i64
  %673 = "llvm.add"(%640, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %674 = "llvm.ashr"(%673, %454) : (i64, i64) -> i64
  %675 = "llvm.and"(%673, %484) : (i64, i64) -> i64
  %676 = "llvm.add"(%650, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %677 = "llvm.ashr"(%676, %454) : (i64, i64) -> i64
  %678 = "llvm.add"(%677, %659) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %679 = "llvm.and"(%676, %484) : (i64, i64) -> i64
  %680 = "llvm.sub"(%650, %679) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %681 = "llvm.add"(%657, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %682 = "llvm.ashr"(%681, %454) : (i64, i64) -> i64
  %683 = "llvm.add"(%682, %664) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %684 = "llvm.and"(%681, %484) : (i64, i64) -> i64
  %685 = "llvm.sub"(%657, %684) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %686 = "llvm.add"(%662, %481) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %687 = "llvm.ashr"(%686, %454) : (i64, i64) -> i64
  %688 = "llvm.add"(%687, %669) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %689 = "llvm.and"(%686, %484) : (i64, i64) -> i64
  %690 = "llvm.sub"(%662, %689) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %691 = "llvm.mul"(%667, %475) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %692 = "llvm.add"(%691, %516) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %693 = "llvm.mul"(%667, %476) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %694 = "llvm.add"(%633, %693) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %695 = "llvm.mul"(%667, %477) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %696 = "llvm.mul"(%667, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %697 = "llvm.mul"(%667, %479) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %698 = "llvm.mul"(%667, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %699 = "llvm.add"(%627, %698) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %700 = "llvm.sub"(%699, %651) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %701 = "llvm.add"(%700, %674) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %702 = "llvm.mul"(%688, %475) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %703 = "llvm.add"(%702, %514) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %704 = "llvm.mul"(%688, %476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %705 = "llvm.add"(%692, %704) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %706 = "llvm.mul"(%688, %477) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %707 = "llvm.add"(%694, %706) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %708 = "llvm.mul"(%688, %478) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %709 = "llvm.mul"(%688, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %710 = "llvm.mul"(%688, %480) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %711 = "llvm.mul"(%690, %475) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %712 = "llvm.add"(%711, %523) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %713 = "llvm.mul"(%690, %476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %714 = "llvm.add"(%703, %713) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %715 = "llvm.mul"(%690, %477) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %716 = "llvm.add"(%705, %715) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %717 = "llvm.mul"(%690, %478) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %718 = "llvm.add"(%707, %717) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %719 = "llvm.mul"(%690, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %720 = "llvm.mul"(%690, %480) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %721 = "llvm.add"(%642, %696) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %722 = "llvm.add"(%721, %671) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %723 = "llvm.add"(%722, %709) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %724 = "llvm.add"(%723, %720) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %725 = "llvm.mul"(%683, %475) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %726 = "llvm.add"(%725, %512) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %727 = "llvm.mul"(%683, %476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %728 = "llvm.add"(%712, %727) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %729 = "llvm.mul"(%683, %477) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %730 = "llvm.add"(%714, %729) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %731 = "llvm.mul"(%683, %478) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %732 = "llvm.add"(%716, %731) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %733 = "llvm.mul"(%683, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %734 = "llvm.add"(%718, %733) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %735 = "llvm.mul"(%683, %480) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %736 = "llvm.mul"(%685, %475) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %737 = "llvm.add"(%736, %510) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %738 = "llvm.mul"(%685, %476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %739 = "llvm.add"(%726, %738) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %740 = "llvm.mul"(%685, %477) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %741 = "llvm.add"(%728, %740) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %742 = "llvm.mul"(%685, %478) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %743 = "llvm.add"(%730, %742) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %744 = "llvm.mul"(%685, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %745 = "llvm.add"(%732, %744) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %746 = "llvm.mul"(%685, %480) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %747 = "llvm.add"(%734, %746) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %748 = "llvm.mul"(%678, %475) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %749 = "llvm.add"(%748, %508) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %750 = "llvm.mul"(%678, %476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %751 = "llvm.add"(%737, %750) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %752 = "llvm.mul"(%678, %477) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %753 = "llvm.add"(%739, %752) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %754 = "llvm.mul"(%678, %478) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %755 = "llvm.add"(%741, %754) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %756 = "llvm.mul"(%678, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %757 = "llvm.add"(%743, %756) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %758 = "llvm.mul"(%678, %480) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %759 = "llvm.add"(%745, %758) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %760 = "llvm.add"(%749, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %761 = "llvm.ashr"(%760, %454) : (i64, i64) -> i64
  %762 = "llvm.add"(%751, %761) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %763 = "llvm.and"(%760, %484) : (i64, i64) -> i64
  %764 = "llvm.sub"(%749, %763) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %765 = "llvm.add"(%753, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %766 = "llvm.ashr"(%765, %454) : (i64, i64) -> i64
  %767 = "llvm.add"(%755, %766) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %768 = "llvm.and"(%765, %484) : (i64, i64) -> i64
  %769 = "llvm.sub"(%753, %768) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %770 = "llvm.add"(%757, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %771 = "llvm.ashr"(%770, %454) : (i64, i64) -> i64
  %772 = "llvm.add"(%759, %771) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %773 = "llvm.and"(%770, %484) : (i64, i64) -> i64
  %774 = "llvm.sub"(%757, %773) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %775 = "llvm.add"(%747, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %776 = "llvm.ashr"(%775, %454) : (i64, i64) -> i64
  %777 = "llvm.add"(%695, %631) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %778 = "llvm.sub"(%777, %672) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %779 = "llvm.add"(%778, %708) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %780 = "llvm.add"(%779, %719) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %781 = "llvm.add"(%780, %735) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %782 = "llvm.add"(%781, %776) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %783 = "llvm.and"(%775, %484) : (i64, i64) -> i64
  %784 = "llvm.sub"(%747, %783) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %785 = "llvm.add"(%724, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %786 = "llvm.ashr"(%785, %454) : (i64, i64) -> i64
  %787 = "llvm.add"(%640, %697) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %788 = "llvm.sub"(%787, %675) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %789 = "llvm.add"(%788, %710) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %790 = "llvm.add"(%789, %786) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %791 = "llvm.and"(%785, %484) : (i64, i64) -> i64
  %792 = "llvm.sub"(%724, %791) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %793 = "llvm.add"(%701, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %794 = "llvm.ashr"(%793, %454) : (i64, i64) -> i64
  %795 = "llvm.add"(%794, %680) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %796 = "llvm.and"(%793, %484) : (i64, i64) -> i64
  %797 = "llvm.sub"(%701, %796) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %798 = "llvm.add"(%762, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %799 = "llvm.ashr"(%798, %454) : (i64, i64) -> i64
  %800 = "llvm.and"(%798, %484) : (i64, i64) -> i64
  %801 = "llvm.add"(%767, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %802 = "llvm.ashr"(%801, %454) : (i64, i64) -> i64
  %803 = "llvm.and"(%801, %484) : (i64, i64) -> i64
  %804 = "llvm.add"(%772, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %805 = "llvm.ashr"(%804, %454) : (i64, i64) -> i64
  %806 = "llvm.add"(%784, %805) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %807 = "llvm.and"(%804, %484) : (i64, i64) -> i64
  %808 = "llvm.add"(%782, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %809 = "llvm.ashr"(%808, %454) : (i64, i64) -> i64
  %810 = "llvm.add"(%792, %809) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %811 = "llvm.and"(%808, %484) : (i64, i64) -> i64
  %812 = "llvm.sub"(%782, %811) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %813 = "llvm.add"(%790, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %814 = "llvm.ashr"(%813, %454) : (i64, i64) -> i64
  %815 = "llvm.add"(%797, %814) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %816 = "llvm.and"(%813, %484) : (i64, i64) -> i64
  %817 = "llvm.sub"(%790, %816) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %818 = "llvm.add"(%795, %481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %819 = "llvm.ashr"(%818, %454) : (i64, i64) -> i64
  %820 = "llvm.and"(%818, %484) : (i64, i64) -> i64
  %821 = "llvm.sub"(%795, %820) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %822 = "llvm.mul"(%819, %475) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %823 = "llvm.add"(%764, %822) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %824 = "llvm.mul"(%819, %476) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %825 = "llvm.mul"(%819, %477) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %826 = "llvm.mul"(%819, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %827 = "llvm.mul"(%819, %479) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %828 = "llvm.mul"(%819, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %829 = "llvm.ashr"(%823, %454) : (i64, i64) -> i64
  %830 = "llvm.add"(%824, %762) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %831 = "llvm.sub"(%830, %800) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %832 = "llvm.add"(%831, %829) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %833 = "llvm.and"(%823, %453) : (i64, i64) -> i64
  %834 = "llvm.ashr"(%832, %454) : (i64, i64) -> i64
  %835 = "llvm.add"(%769, %825) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %836 = "llvm.add"(%835, %799) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %837 = "llvm.add"(%836, %834) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %838 = "llvm.and"(%832, %453) : (i64, i64) -> i64
  %839 = "llvm.ashr"(%837, %454) : (i64, i64) -> i64
  %840 = "llvm.add"(%767, %826) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %841 = "llvm.sub"(%840, %803) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %842 = "llvm.add"(%841, %839) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %843 = "llvm.and"(%837, %453) : (i64, i64) -> i64
  %844 = "llvm.ashr"(%842, %454) : (i64, i64) -> i64
  %845 = "llvm.add"(%774, %827) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %846 = "llvm.add"(%845, %802) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %847 = "llvm.add"(%846, %844) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %848 = "llvm.and"(%842, %453) : (i64, i64) -> i64
  %849 = "llvm.ashr"(%847, %454) : (i64, i64) -> i64
  %850 = "llvm.add"(%772, %828) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %851 = "llvm.sub"(%850, %807) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %852 = "llvm.add"(%851, %849) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %853 = "llvm.and"(%847, %453) : (i64, i64) -> i64
  %854 = "llvm.ashr"(%852, %454) : (i64, i64) -> i64
  %855 = "llvm.add"(%806, %854) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %856 = "llvm.and"(%852, %453) : (i64, i64) -> i64
  %857 = "llvm.ashr"(%855, %454) : (i64, i64) -> i64
  %858 = "llvm.add"(%857, %812) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %859 = "llvm.and"(%855, %453) : (i64, i64) -> i64
  %860 = "llvm.ashr"(%858, %454) : (i64, i64) -> i64
  %861 = "llvm.add"(%810, %860) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %862 = "llvm.and"(%858, %453) : (i64, i64) -> i64
  %863 = "llvm.ashr"(%861, %454) : (i64, i64) -> i64
  %864 = "llvm.add"(%863, %817) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %865 = "llvm.and"(%861, %453) : (i64, i64) -> i64
  %866 = "llvm.ashr"(%864, %454) : (i64, i64) -> i64
  %867 = "llvm.add"(%815, %866) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %868 = "llvm.and"(%864, %453) : (i64, i64) -> i64
  %869 = "llvm.ashr"(%867, %454) : (i64, i64) -> i64
  %870 = "llvm.add"(%869, %821) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %871 = "llvm.and"(%867, %453) : (i64, i64) -> i64
  %872 = "llvm.ashr"(%870, %454) : (i64, i64) -> i64
  %873 = "llvm.and"(%870, %453) : (i64, i64) -> i64
  %874 = "llvm.mul"(%872, %475) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %875 = "llvm.mul"(%872, %476) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %876 = "llvm.add"(%875, %838) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %877 = "llvm.mul"(%872, %477) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %878 = "llvm.add"(%877, %843) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %879 = "llvm.mul"(%872, %478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %880 = "llvm.add"(%879, %848) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %881 = "llvm.mul"(%872, %479) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %882 = "llvm.add"(%881, %853) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %883 = "llvm.mul"(%872, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %884 = "llvm.add"(%883, %856) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %885 = "llvm.add"(%874, %833) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %886 = "llvm.ashr"(%885, %454) : (i64, i64) -> i64
  %887 = "llvm.add"(%876, %886) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %888 = "llvm.ashr"(%887, %454) : (i64, i64) -> i64
  %889 = "llvm.add"(%878, %888) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %890 = "llvm.ashr"(%889, %454) : (i64, i64) -> i64
  %891 = "llvm.add"(%880, %890) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %892 = "llvm.ashr"(%891, %454) : (i64, i64) -> i64
  %893 = "llvm.add"(%882, %892) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %894 = "llvm.ashr"(%893, %454) : (i64, i64) -> i64
  %895 = "llvm.add"(%884, %894) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %896 = "llvm.ashr"(%895, %454) : (i64, i64) -> i64
  %897 = "llvm.add"(%896, %859) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %898 = "llvm.ashr"(%897, %454) : (i64, i64) -> i64
  %899 = "llvm.add"(%898, %862) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %900 = "llvm.ashr"(%899, %454) : (i64, i64) -> i64
  %901 = "llvm.add"(%900, %865) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %902 = "llvm.ashr"(%901, %454) : (i64, i64) -> i64
  %903 = "llvm.add"(%902, %868) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %904 = "llvm.ashr"(%903, %454) : (i64, i64) -> i64
  %905 = "llvm.add"(%904, %871) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %906 = "llvm.lshr"(%905, %454) : (i64, i64) -> i64
  %907 = "llvm.add"(%906, %873) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %908 = "llvm.insertelement"(%492, %885, %459) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %909 = "llvm.insertelement"(%908, %891, %460) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %910 = "llvm.insertelement"(%909, %897, %447) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %911 = "llvm.lshr"(%910, %446) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %912 = "llvm.and"(%911, %445) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %913 = "llvm.insertelement"(%444, %889, %459) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %914 = "llvm.insertelement"(%913, %895, %460) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %915 = "llvm.insertelement"(%914, %901, %447) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %916 = "llvm.insertelement"(%915, %903, %443) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %917 = "llvm.shl"(%916, %442) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %918 = "llvm.lshr"(%916, %442) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %919 = "llvm.shufflevector"(%917, %918) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %920 = "llvm.and"(%919, %441) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %921 = "llvm.insertelement"(%444, %887, %459) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %922 = "llvm.insertelement"(%921, %893, %460) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %923 = "llvm.insertelement"(%922, %899, %447) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %924 = "llvm.insertelement"(%923, %905, %443) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %925 = "llvm.shl"(%924, %440) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %926 = "llvm.and"(%925, %439) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %927 = "llvm.or"(%926, %912) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %928 = "llvm.or"(%920, %927) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %929 = "llvm.insertelement"(%444, %891, %459) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %930 = "llvm.insertelement"(%929, %897, %460) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %931 = "llvm.insertelement"(%930, %903, %447) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %932 = "llvm.insertelement"(%931, %907, %443) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %933 = "llvm.shl"(%932, %438) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %934 = "llvm.or"(%928, %933) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%934, %arg50) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg50) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.R52x5
